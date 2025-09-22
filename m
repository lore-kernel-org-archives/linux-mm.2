Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 115B0CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F228E000E; Mon, 22 Sep 2025 17:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116E98E0001; Mon, 22 Sep 2025 17:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20C48E000E; Mon, 22 Sep 2025 17:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E24F68E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:09:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E35B514DB
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:09:52 +0000 (UTC)
X-FDA: 83918128224.08.50A989D
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7A9AD80016
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:09:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VyftjPta;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758575390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIOP0jY/+X/9DN9f80nfhBWfHor4awN8nQUrjS4FFGg=;
	b=VEMBDy58mwtnCeka7T7xbTDdq+KR/7454mT3j062477yHxsfcsNKCTJNxOPRJJNo5BWtyQ
	V1uvyUfoDGq2nq9mhnOxdxs/ENyehSVtG5BzTTDHBxhjN+DeB/N+UTC12j5w7yQCuuH6Ge
	d2ihMj8ksHcV7AnWmEeR9t2gBwZJIYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758575390; a=rsa-sha256;
	cv=none;
	b=C/VfZ1rSXL2NRWF8Cs4NEV7QFHmCMBLnEa8w60z803AkKhDdWL8s8QYThpEGj6F9uxfyZU
	KJHWeIcllp173eJX01MNvSpjx4cgl06W7r3O9+iu/D2Js9SaveLjuD3/zgjQov11oUznaX
	HvJkSTZZFbBTl5W3BtvonkQNuL4fmqw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VyftjPta;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b38d4de6d9so30831391cf.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758575389; x=1759180189; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aIOP0jY/+X/9DN9f80nfhBWfHor4awN8nQUrjS4FFGg=;
        b=VyftjPtaIkt+9Gztd3e1J1hiFcwzICUgkwUVL0sEnyL1y4CDUL4RySoeA8BgMHTOjd
         D1j2VKrznXWbTXUA7VSUcorsdL6SNDDyxrBzXNjPX0c9Y9LL8aSFc1iAX4yC0V1mNDG1
         SzlH1CHZUsr++CwZ+tRqR73XhFduQkahIPm/+4kuD6W+OeSW5rYWVEGYFQqe2YB6dH8u
         z2OPxnA2GQGbhGzsjLeHJoCo7ptLEIenj+s91QGKBa+NQdJclkmpLwO19tPtiIR+XCsU
         wM9luTTIpVGc+WSMfe0l5X/CCrHrgO+ek21pDOpqV2KST8wcFU09zwr6r15atOtrGobh
         MtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758575389; x=1759180189;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aIOP0jY/+X/9DN9f80nfhBWfHor4awN8nQUrjS4FFGg=;
        b=dSj/FL2CpmBNH3vBZtNOEnyik63x/UacrJ0wPrD8n0gD6Qz4ShaFsP8bbjkQGeC69J
         po87P3gqAHNkmiSYWQLSenzl1f65cX4rf0G98sHY++UvXrTklAD3q4ja+Jmd05Cr/Wpe
         9oQCgqNPDRZ60GzkaAuYi4fWXh66gE5jVWXvHynsdeRjPH4AKH19jF8zJmT4HejPF5hq
         cx7PXs2uFZkeljxHPLkYz3ZypcDQt7SpH0cc8O6/7PCaKkQWS3zLKm5YNiC2hC84FocR
         WkLu5juLFDIkB2/6h3VGGOvxiakyzVPyozWIo+HTiCu7JJf3Z6TNp17e5PKLY0fKtixE
         VWZA==
X-Forwarded-Encrypted: i=1; AJvYcCXOmNYtnjmZYpn5kgbmk8ne0ENXeaay/9vAOTmm0QVb2nSFoTPVepAXpNfcqp6ZBVSULKWg5pEgwQ==@kvack.org
X-Gm-Message-State: AOJu0YyC56SPPD6L2gF5K8h1JJwsnjxYR//YOQCd0Km59dyVaVYurauR
	eHTwZvnMetql71aNGqE6lJQWFRfdrsS6WuJhnad7YfAZg0+P8pxNyyR0YqchUdXfYIGRWrs/j49
	Vq0C0uzuEI45x9PMgsfX3L8+TO7QeFq4KyxwNfDq/KA==
X-Gm-Gg: ASbGncvyFg8azji0rqgFT8iChSbivwNbHpW6BB2uYWDDEBN9yxY99FjUrTOxCimtx7w
	LM+W3bX6X/gp3+jC88iFQG3l3xTm3J1WJB+TFDcSIPrvJ4OCAJGNDJoIJf7vJnxZr/2BYeJXiJG
	v+nK5e8ghafpZiGj04QTm86eLIvXo5ktiJVx0OMkOIgMY18E4lIm40YnMjpelXg+y/WaSEELKAc
	DZF
X-Google-Smtp-Source: AGHT+IG/qgae5Me0ExwT19ZtCSc7WJPaTAk40SN+WOTTYohTOQCqtXZFZ8mCtUhw0BmokKMxl2aqS4C1ND0ndsRc4Xg=
X-Received: by 2002:ac8:6f07:0:b0:4cc:48c0:adfe with SMTP id
 d75a77b69052e-4d368a800a4mr3604971cf.30.1758575389346; Mon, 22 Sep 2025
 14:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-17-pasha.tatashin@soleen.com> <20250814134917.GE802098@nvidia.com>
In-Reply-To: <20250814134917.GE802098@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 22 Sep 2025 17:09:11 -0400
X-Gm-Features: AS18NWCsBRxoeYSv5S_-rUt98UUe9gxpk-iBTnQrKdXEdTrrgwXCgW39zL3zdf8
Message-ID: <CA+CK2bD68E1-AWxz9p-Byyb=fDVQGu4Q+GpW2ogCNdjCxbAJqQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/30] liveupdate: luo_ioctl: add userpsace interface
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7A9AD80016
X-Stat-Signature: uuqge68xf8r5ezx9pzekauh7j3c5ywju
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758575390-509700
X-HE-Meta: U2FsdGVkX18EEjWp5fTxmoDA5rVyFCZfHTXj5WFaCkXX5gJHuEPJG1TWfoN/a5LJBBjgnMIeaAvXXZK6XYWyQ8cdvXhNHq/4esyfj7yjo0BJ91+NKZDZmK3RjCFMVUYyF+VYvyJsv8iUbLh6JiWqgbhJ7Hkoc7Or7q45vKQiRY5RZ6q++nTdJjKNFk7Siu3eb0bN5YV99Id6daC+5IVzPLXKB80WBOqRvcOuDBhYVMxbwj0NmPBkxbQCQyMJtcCWwW+bv3yFR8v/R7JQpHkPtgAmMHGMhxEjcH4rZ8iIgY3wtt5KUv9U1UUZjjp6ezRZSQTXR+jtmDltMxSfE9U+4kfi1aJWiuqNY6YTjELk8Wu0pCRrcQgs8dKawFaeC+SCpU8GZzb0bN5Lf+H1o4f0DGP8IRkV2ENlyJxncbQZq5aZKz2vnF8UHwzluZP2+bZYp1sd0Rg7H1IkeIgymEBXbLfqxN/jaThfT35MRlQOa53nv+G5kFlYhhyf0ZzKrlKAldQCp9gMXcO5aAX7L66T59pRD4uYQCAXEycJOxZ2Nfv0sWo81Brt6Vyki3xVZROPxDUVRT+wDJ+D360DIebTIPfAKJNSmeNFsnx0oBt/p3dJYnL0pXAtAu1SYktYMQXvgoAVZ9nHhjyaSv0/99H8b6Dg39xLuP3BbxPZnLu6mTfOR2uOTnDH3kHP+jaGh286UjnXYoizVsXqmhzrws+JpRHhiFtzHe7UDv9ntZfCbyky3HtvNyRW2/YRB5SlNzbrGltpAE6Jhde39Og1UcN13Yef3k1ZN5ouNejbilG5gyDeCu/z0FVx1qZUKaYv8XI+vzZrvTLMnY8q0uATfoRCgRbJkhpkt++79zV9fpWTgm5ls1C4xxhjmJpJc4IYxSL8o65m1q5ujp87Kal44imuz1IJ55BIJULQsJUBv0CBkFDP/Efgsni0MCnj1GmmRq3wO7Pv9ZlpglZV1ZSOUWS
 l5przu8l
 q7/0a12hORrkP1WDDV2SGrlPJ6Dj8zXcGuXskdsUDmRbCmsxhpXYLI8IueK44uGhGTxFS3tiO8xkRD9t6pwLM5otbWWlWjcRrexC6hz2qc2AyUniG9sAsQAvTUX0YnRE/HF2A7ywFpTfSgQR6Fs8XEtLGV0ZUNnEL4x9TAAOjTOydzcQeQKmqr3XoiqZIKlLBmQk/N0Pr95UNYWBtWZ9drl0e5FrIfWgRz6949Nww3pvIjsarDJacIPWFwpnjgUhnZb9R6ZMStjT1CTR78R/5AjkcY4GRoPzreaHbJAWkHgRFLmDS6+tHyxRUTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > + *  - EINVAL: Everything about the IOCTL was understood, but a field is not
> > + *    correct.
> > + *  - ENOENT: An ID or IOVA provided does not exist.
>                     ^^^^^^^^^
>
> Maybe this should be 'token' ?

Yes, replaced with token. :-)

> > +struct liveupdate_ioctl_fd_unpreserve {
> > +       __u32           size;
> > +       __aligned_u64   token;
> > +};
>
> It is best to explicitly pad, so add a __u32 reserved between size and
> token
>
> Then you need to also check that the reserved is 0 when parsing it,
> return -EOPNOTSUPP otherwise.

Done.

>
> > +static atomic_t luo_device_in_use = ATOMIC_INIT(0);
>
> I suggest you bundle this together into one struct with the misc_dev
> and the other globals and largely pretend it is not global, eg refer
> to it through container_of, etc
>
> Following practices like this make it harder to abuse the globals.

Done, good suggestion.

> > +struct luo_ucmd {
> > +     void __user *ubuffer;
> > +     u32 user_size;
> > +     void *cmd;
> > +};
> > +
> > +static int luo_ioctl_fd_preserve(struct luo_ucmd *ucmd)
> > +{
> > +     struct liveupdate_ioctl_fd_preserve *argp = ucmd->cmd;
> > +     int ret;
> > +
> > +     ret = luo_register_file(argp->token, argp->fd);
> > +     if (!ret)
> > +             return ret;
> > +
> > +     if (copy_to_user(ucmd->ubuffer, argp, ucmd->user_size))
> > +             return -EFAULT;
>
> This will overflow memory, ucmd->user_size may be > sizeof(*argp)
>
> The respond function is an important part of this scheme:
>
> static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
>                                        size_t cmd_len)
> {
>         if (copy_to_user(ucmd->ubuffer, ucmd->cmd,
>                          min_t(size_t, ucmd->user_size, cmd_len)))
>                 return -EFAULT;
>
> The min (sizeof(*argp) in this case) can't be skipped!

Done, thank you for catching this.

> > +static int luo_ioctl_fd_restore(struct luo_ucmd *ucmd)
> > +{
> > +     struct liveupdate_ioctl_fd_restore *argp = ucmd->cmd;
> > +     struct file *file;
> > +     int ret;
> > +
> > +     argp->fd = get_unused_fd_flags(O_CLOEXEC);
> > +     if (argp->fd < 0) {
> > +             pr_err("Failed to allocate new fd: %d\n", argp->fd);
>
> No need

Removed

> > +             return argp->fd;
> > +     }
> > +
> > +     ret = luo_retrieve_file(argp->token, &file);
> > +     if (ret < 0) {
> > +             put_unused_fd(argp->fd);
> > +
> > +             return ret;
> > +     }
> > +
> > +     fd_install(argp->fd, file);
> > +
> > +     if (copy_to_user(ucmd->ubuffer, argp, ucmd->user_size))
> > +             return -EFAULT;
>
> Wrong order, fd_install must be last right before return 0. Failing
> system calls should not leave behind installed FDs.

Fixed.

>
> > +static int luo_ioctl_set_event(struct luo_ucmd *ucmd)
> > +{
> > +     struct liveupdate_ioctl_set_event *argp = ucmd->cmd;
> > +     int ret;
> > +
> > +     switch (argp->event) {
> > +     case LIVEUPDATE_PREPARE:
> > +             ret = luo_prepare();
> > +             break;
> > +     case LIVEUPDATE_FINISH:
> > +             ret = luo_finish();
> > +             break;
> > +     case LIVEUPDATE_CANCEL:
> > +             ret = luo_cancel();
> > +             break;
> > +     default:
> > +             ret = -EINVAL;
>
> EOPNOTSUPP

Ack.

>
> > +union ucmd_buffer {
> > +     struct liveupdate_ioctl_fd_preserve     preserve;
> > +     struct liveupdate_ioctl_fd_unpreserve   unpreserve;
> > +     struct liveupdate_ioctl_fd_restore      restore;
> > +     struct liveupdate_ioctl_get_state       state;
> > +     struct liveupdate_ioctl_set_event       event;
> > +};
>
> I discourage the column alignment. Also sort by name.

Done

>
> > +static const struct luo_ioctl_op luo_ioctl_ops[] = {
> > +     IOCTL_OP(LIVEUPDATE_IOCTL_FD_PRESERVE, luo_ioctl_fd_preserve,
> > +              struct liveupdate_ioctl_fd_preserve, token),
> > +     IOCTL_OP(LIVEUPDATE_IOCTL_FD_UNPRESERVE, luo_ioctl_fd_unpreserve,
> > +              struct liveupdate_ioctl_fd_unpreserve, token),
> > +     IOCTL_OP(LIVEUPDATE_IOCTL_FD_RESTORE, luo_ioctl_fd_restore,
> > +              struct liveupdate_ioctl_fd_restore, token),
> > +     IOCTL_OP(LIVEUPDATE_IOCTL_GET_STATE, luo_ioctl_get_state,
> > +              struct liveupdate_ioctl_get_state, state),
> > +     IOCTL_OP(LIVEUPDATE_IOCTL_SET_EVENT, luo_ioctl_set_event,
> > +              struct liveupdate_ioctl_set_event, event),
>
> Sort by name

Done

