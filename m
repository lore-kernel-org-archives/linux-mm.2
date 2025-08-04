Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51255C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6DD8E0002; Mon,  4 Aug 2025 19:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE948E0001; Mon,  4 Aug 2025 19:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D46E8E0002; Mon,  4 Aug 2025 19:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7048E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:01:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E129B115A77
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:01:19 +0000 (UTC)
X-FDA: 83740597878.22.B33FA04
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E8C02000A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:01:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="I/4w3gXd";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754348478; a=rsa-sha256;
	cv=none;
	b=LiAbT46pQ9UbTu9ByDdrrMifQOAeyMu6BP6iNYsLeXFuVoKkMQ3ubNQLdUn095jEA/YPGN
	eGtmobks7fPMziUXCJO5tUSyWtkIkiHF2o5Anzw9wBBBvynf3WWQR+o5JWai6AHGs6UJxp
	IlASeq5hg57UtRNnsQ8TfMXz175YEfg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="I/4w3gXd";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754348478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gU7gICCtCiiOkKgytm+DZgh/C6t4tnk/oqWk65I1YqY=;
	b=0I+41i40E2lrU12M6yCoxE+X2tFunZytYtNWoSc9B4La1jyaXz3jJBo2+sR41TMQ15JyMU
	lqp20p7fw6mZ3+6iKUJSuiVpSOYTi8k2M+AirfLzV6BX8733JuyAC5QaCKums1sUbwp0Wb
	3UKcKhE2e3HjchUaDc8g5Ti5Y+pAr7Q=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4af027d966eso36946341cf.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754348477; x=1754953277; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gU7gICCtCiiOkKgytm+DZgh/C6t4tnk/oqWk65I1YqY=;
        b=I/4w3gXd1TAYGl5y25tU3GDZL9qB2xOIb9J2LXFwnjV6o8SBd4m3tKbyOzvHwKs8JB
         VFGlKiYljuwuK0J99SWjdxsMnDJeUShFfnQgg5mMQMtmY/FsGBnVcgmDSsYjaZ4I/VBg
         Zb89VMniSBrTImPaHEK37wq97DdqCCMS5MuhwjXTf+ea5ylvaFne/SNJnqW9mKETwnWb
         HFeRx+/FMS7mvImaaxns0Z8+qy3AH3A/9vretyDCGDySe9sDiVFigooGeYf0QbNM85nz
         +Zmnff4/ze/wCVanzoNN4De45rXIVBoK2mbFidIvSKJK3sKS5isAunQEL3gEpLPivvEE
         Wvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754348477; x=1754953277;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gU7gICCtCiiOkKgytm+DZgh/C6t4tnk/oqWk65I1YqY=;
        b=nocGeLnrVSvzPAqpHjmu6MOxTPuqoblpsMHoSFRIZi7KKai4ISl9eYEJVqxX/mvJGt
         2Ed2xUJ9UGkLOONMTUtN/XPFNyXadMCjs+qdFJcN0Jx/7Ic7afFVmhD34Dtom4DXumIt
         /DBZrrzgiK8Rtm1B8EZKSzLf+KhpsM+MzOVHj0wivFtfAnsCK5XD1Lz7iX7gZqlBwGQW
         WwUX3PKHWVi5uNE3B4l5+/JIxtbOAxrz752NMqapp2P19FoJ1S82A/zY7k7XLsMtkehz
         W4b2tU2t5zG0qx2tHwmRMT1CzOPG1YlMtlauaaBDne9R+jLG8iQFjSxFCTGmoZIV6/Lx
         KzFA==
X-Forwarded-Encrypted: i=1; AJvYcCV/dg7wGGVn1ql+ZqLCf0Cv9yYENhFUEmmV8gXDSdW2c7Gc+PLP6LkJnvggU196Aw+HDwvzWsI+Kg==@kvack.org
X-Gm-Message-State: AOJu0YwCxRgld3H1HgDMXzTOOSup6BBOK9HzySxkY7S3al6exf0sk3vC
	AvUKFmp+7VGyjueEcFBPXGJUZG1NfLdjT59ThDXnk95MYx5EfNVftyhOE98rVjzn/8oh/MPMeCZ
	N19+8aIj/Z3+8hDMrSCgkdFFJa60bMrOQm1yvghSu3Q==
X-Gm-Gg: ASbGnctdR6UuUz2bdGtv8jOiM3PfRom8XOKgQfpIYX0MyaQK5xTXfL/abwjKJiE83r+
	Mxw5g36CVfarzEm8PEoht/1DRDiO91xf4+jVQdtMAxJyfwoHXlCcrsOBK4+gij/JFHV+OB6yMFr
	+Q8ZCnzSQBW9T8eNxMuS99QEoGBeQWSMXUTh+btfgdzsMvJQlcD7BflEv2F7RPp6g+SVB4ehedu
	GVG
X-Google-Smtp-Source: AGHT+IHe63ELG7HHSW4Jr0p22ejEnswLaJpBTfGBY8KrlhhHwCd1xtHK5nLfdWJ/GzdTJH5a222X5rXcjnstQZeQWOo=
X-Received: by 2002:ac8:57cf:0:b0:4af:c21:41b1 with SMTP id
 d75a77b69052e-4af10ad5bdbmr146282341cf.55.1754348476999; Mon, 04 Aug 2025
 16:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-15-pasha.tatashin@soleen.com> <20250729173318.GQ36037@nvidia.com>
In-Reply-To: <20250729173318.GQ36037@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 4 Aug 2025 23:00:39 +0000
X-Gm-Features: Ac12FXy6p3_gSOnGWR1VjKZIJjskzeugSY4VSrqKY12UE9gHpXQr70kL51Ej-YY
Message-ID: <CA+CK2bBEX6C6v63DrK-Fx2sE7fvLTZM=HX0y_j4aVDYcfrCXOg@mail.gmail.com>
Subject: Re: [PATCH v2 14/32] liveupdate: luo_files: add infrastructure for FDs
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
X-Stat-Signature: g7dfdzzb35yq1ydoi14tzu9kq4ixwyao
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E8C02000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1754348477-346358
X-HE-Meta: U2FsdGVkX1+siaT0kOeDS0GbzMbnW90b2vKqVoUbKnXvJUUsQknzRBcG1qNbdddIzT8rwLUNorSOOSzRcMYdrkCRK6lFMU/8kcre6lnn2xFBKqsRFd42txIwU7hJQIlsulsclixeu1+fjbvrHmoNNjpaQ+ftGNbm7ZGe/mq30hoJfHXs3Y8Z0EV499w/zzuarUr7ofDTTA6o0qmor3JdQgeAGuOQsLAOpZvQ4yeZFeA0V6IawNAzku9oRuUmCBXGLAoGDFE7RXO1iFreri0wUbItOVv1nwXeHqAlcCRj6daqlGnoZX4s4vOH+YVL6ncz+4M/kMVTthyOUrQQt3v3lqJlc0ZhFwH4brR+mKmWyFhKQuKlD75OjNnhUaGOn7/Y1OxzE2FbYIvIDMwntae0jHjVxF7GRQitpwi/zF8XjOalh6pFISxmuoUl8U2Z9BnS6xfJGaJhI4TwzRXxluP91/CSfsqyefIhEx39ZARnoDbUoyDKkC30baGk+kuYBm5DKLoM3tEy38RHoTHO+exeRjytj8Wbuei+5p6UhQeqlSkMwqg7YFWiJrAOI4z7tOF41dROwHz/Nuz1+okDDoA/iV6CWDIszQVkSyihfM6k8RQKgl3HcdyQLmID0xzUMNXsf0xfnxnzn239YgnMcCWT+klMlRn9Nr/1HW3vxT6zvAz64hDSDIpZkACEoT49VooSxkb3qhrkp1Jo2JDu6N3XZ/+cRl1mxP065Y/PBpfUhClLOsckqgjirKZMO4+7GPYx1cD3fjvk+AzPcvdharmNoqYWT6TF75SltsccdLyjWCk89LIY82u3+ZTN6DJkDOSM3wc/9ha0CTj9qoRV9EE/nvgDhQdgj7w/o1dQ4d5wbPXCAxito/TgINKDCzkfdcxvPAwVNyAEN+ssLOy0qDxSwY7oD6EnTpZrq3WOat36HfXmvJuxd3qc+e6mzl2Q3MfY4cbA2xYwuVA+iojxxj6
 jgvUkM5N
 v1/kgvdVAPK+wrZRNF5PRkw3vDxSYAWDYTZ1QioXCCMknOMgTiTCfcnmekFmhlyxXI4Q5ZGVlozZznIzPEkc7uh6mDTk0cW34onTJYmrppdU6x/hmLzempSf0NsSsmxVEm7XKQ/r73EIp68LCIiKV9pMRtsuOp2TkFvGVYREO669i+YVMIaWq7A4ZMbYXcbCHcohVU9e7eWlLQB9Fu0iry2oSCMQWxUpUAPey9yq7Vu38Pxd2o+GOHYi1OxWj2tCAi5LroKLGnNx811aAfSY+BOriFmmSSLVY1KWCrKoE+gXRMDLq6Y+VkHGxMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +struct liveupdate_file_ops {
> > +     int (*prepare)(struct file *file, void *arg, u64 *data);
> > +     int (*freeze)(struct file *file, void *arg, u64 *data);
> > +     void (*cancel)(struct file *file, void *arg, u64 data);
> > +     void (*finish)(struct file *file, void *arg, u64 data, bool reclaimed);
> > +     int (*retrieve)(void *arg, u64 data, struct file **file);
> > +     bool (*can_preserve)(struct file *file, void *arg);
> > +};
>
> ops structures often have an owner = THIS_MODULE

Added here, and to subsystems.

>
> It wouldn't hurt to add it here too, and some appropriate module_get's
> though I didn't try to figure what happens if userspace races a module
> unload with other luo operations.

I added try_module_get()/module_put() to register/unregister functions.

> > +
> > +/**
> > + * struct liveupdate_file_handler - Represents a handler for a live-updatable
> > + * file type.
> > + * @ops:           Callback functions
> > + * @compatible:    The compatibility string (e.g., "memfd-v1", "vfiofd-v1")
> > + *                 that uniquely identifies the file type this handler supports.
> > + *                 This is matched against the compatible string associated with
> > + *                 individual &struct liveupdate_file instances.
> > + * @arg:           An opaque pointer to implementation-specific context data
> > + *                 associated with this file handler registration.
>
> Why? This is not the normal way, if you want context data then
> allocate a struct driver_liveupdate_file_handler and embed a normal
> struct liveupdate_file_handler inside it, then use container_of.

Good point. I removed arg, and added handler as an argument to the
callback functions.

> > +     fdt_for_each_subnode(file_node_offset, luo_file_fdt_in, 0) {
> > +             bool handler_found = false;
> > +             u64 token;
> > +
> > +             node_name = fdt_get_name(luo_file_fdt_in, file_node_offset,
> > +                                      NULL);
> > +             if (!node_name) {
> > +                     panic("FDT subnode at offset %d: Cannot get name\n",
> > +                           file_node_offset);
>
> I think this approach will raise lots of questions..
>
> I'd introduce a new function "luo_deserialize_failure" that does panic
> internally.
>
> Only called by places that are parsing the FDT & related but run into
> trouble that cannot be savely recovered from.

Agreed. I added a new macro in luo_internal.h:

 11 /*
 12  * Handles a deserialization failure: devices and memory is in
unpredictable
 13  * state.
 14  *
 15  * Continuing the boot process after a failure is dangerous
because it could
 16  * lead to leaks of private data.
 17  */
 18 #define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)

And use it in places where we panic during deserialization.

Pasha

