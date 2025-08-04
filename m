Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559E9C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 01:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93596B008A; Sun,  3 Aug 2025 21:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D440C6B008C; Sun,  3 Aug 2025 21:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33136B0092; Sun,  3 Aug 2025 21:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFD746B008A
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 21:12:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 626F4BA155
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:12:00 +0000 (UTC)
X-FDA: 83737298400.11.54EDB3F
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7F91B1C0003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:11:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b4QHmVjP;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754269918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EHC7Bo4Tna4lRMiPBPdxLTjpzf5j4XSXmXAx1SxHbs=;
	b=gMoj4tMeRBFkWARrhI7bHumXT8jCj2S03mYK1P0w50M+ZLtYThWzrZj98LNKkKxaPnAr1M
	veub5WSHjyxieUO/8juPWVaXLoBRm/qjAafIumj74zRbwxK5z7pS05OuuxYxyGVIXfvExg
	ruh46e6kx/pTBDVDn0ZIWbsgdlQL46Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754269918; a=rsa-sha256;
	cv=none;
	b=ev5O2i6I8z1ITkCcRvecmhAZ5gDf23Jm0YlxLZ9gM1bOUzXJoC0R/Yyf2YycRDaOJXHum4
	1zNUwck8EecoETIRgTEUn7K6HXKGbxp9ICqme4qyHnvs1CyN0pbvgpRlrZnTDqJ0Z28/Zy
	tjrjHamNskXjmcSSLPB9OhsPIDNN0hg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=b4QHmVjP;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b0739c6557so2483741cf.3
        for <linux-mm@kvack.org>; Sun, 03 Aug 2025 18:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754269917; x=1754874717; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5EHC7Bo4Tna4lRMiPBPdxLTjpzf5j4XSXmXAx1SxHbs=;
        b=b4QHmVjP0ad/iaBXyPNNH17e77HiHvKVP1IYMvxQFlKATsDyOfzmCF5lyasME9rQvq
         vOuFyR7FysAxPK15hIe//HqK1BE3wwzpLtXMDyWzcJmVkEk1IUzATnjSFpGEJfD0utz+
         Ytd8gwkaue/85mkbh7RcVVN/gB1V4UYCOaN1m681j86dqg9grHur7jrB9hzyzOiDUTj1
         ijnUvt41b90QleKyg5juOwGEg+yh9BafW1KYAmDOSb48FZ/uxet0rljjaf47rAFDbA2Q
         zAgtGdLP4OW7oiB2DLGZ3D737ZOgoWM1/cfnBVGV1zAW7Zi5e6RT+/Gu0O4H12RsOLBc
         rB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754269917; x=1754874717;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5EHC7Bo4Tna4lRMiPBPdxLTjpzf5j4XSXmXAx1SxHbs=;
        b=LOXDK/snzyQW7J690w1nVXArq8kcJKPECsQYTGMzfQ1nJfPE76HPf7SZx04Y49TrUH
         BrIlcL6Kpa92wtcqgkTsa6+ax6G6I7wm2zAm6og486UlEyZdkdqdO97q7w2IhL/GNCfv
         9g3/R5h3WZOjOj1o2ZAX1VcoDxNH/nmDNT/EeTb5RuRLJZZgU4OkY9zYrP7dt8MWcde8
         HFlt5yjmCnI2SZ+6vh8C9FuGYDmcEk4X6kREIsQzKi+xP4qHcd2lXjfDq/4Gu4edaa41
         HoKwLVg+Zz0h6G9WXYyi2kX3cYo1y77MliqAA3VP48ICWJVxVwbUKBF2WkNCAjtfikIF
         Pbrw==
X-Forwarded-Encrypted: i=1; AJvYcCUoTahso/cVgYha35lqnW29vBUg7tdyC6MtacWugqRh36ouyrfT1QaOY4Fw766UjOcuqShqRbEQSQ==@kvack.org
X-Gm-Message-State: AOJu0YzEUasqo2WAzRvs5b/4XFNKLN/aipQYi090NISS2Y9Dl8SskxCA
	D4A76EXt7QHKPW+/ZRkvR6SE8NClwx2y1LaUd677oUByaA8WZWOP881ZgPDRVs8UstnWuMAmxkR
	BaJzybMuNyxMRxXWxOu1bkMjrdScoLtBGYOw0FKhhGA==
X-Gm-Gg: ASbGncu8GZMRGlXJKdNgGGhPdaQoYEdYHp/a7UapknRBIoEytTd9slvLOx07nklnBui
	X08Fqi+4Pqzkq8GtTopia/c86BONn7NHq/h0HP/xFxjIvGMbF01o/9HlEBw0QlvjENGasB73Upj
	uHtGdkPZ/2jlnYhd+8rgF2W/cmvYh3TyOTKFPX2K25gY25CaUJ1yRu8R7eBHFwFeo8dEmiV3hwD
	5cx0uMi10wFV74=
X-Google-Smtp-Source: AGHT+IElK+avqeyYUn54//o2iNNGJM5V66RJUxPCF/JnBBNYlvcJkU9/zn67Ob/Mjz52DPZ282PLlisDVXGG6S/YoQU=
X-Received: by 2002:ac8:5a12:0:b0:4ab:7d96:bbca with SMTP id
 d75a77b69052e-4af1098b133mr128405741cf.24.1754269917325; Sun, 03 Aug 2025
 18:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-11-pasha.tatashin@soleen.com> <20250729172812.GP36037@nvidia.com>
In-Reply-To: <20250729172812.GP36037@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 3 Aug 2025 21:11:20 -0400
X-Gm-Features: Ac12FXyfTkQo6Oo5aMdGv4BzhEny3uN9Ow76q668n06TlX48YEn8zjMHGbMDq6Q
Message-ID: <CA+CK2bCrfVef_sFWCQpdwe9N_go8F_pU4O-w+XBJZ6yEuXRj9g@mail.gmail.com>
Subject: Re: [PATCH v2 10/32] liveupdate: luo_core: Live Update Orchestrator
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F91B1C0003
X-Stat-Signature: srun4zddn5gpiy9ks5nma8dppwg4jaub
X-Rspam-User: 
X-HE-Tag: 1754269918-789798
X-HE-Meta: U2FsdGVkX1/D/Ern72U4gKvu3+IJ0MB14oCD/0ScQLyWhZHDgKUxRNLEzNUKzZU2LscxNoD6GVGe/FbvlLk0i7dSSOqu1yeupVh8qMn74fviQdnKnpEDi6a81WFkSNHm7682B//neZZ2Z6DL+amjkLdsSOYDa7YuDJ6kBfS+crJPHiliNVtGjCQr1HLJat8ZaHqUSoWHAX15RqWKZFQgLZ+0VLC3FdqKp7fHl2/6mjZDkNy1zfr5Lc4DNKe+YIDlSvgU4pX/y3MvY/4/9qEJSz4GOzn73bNAY7fJAw6mIrIoo2STMj0sqZuHB2xndLzeyg4KNS3bN4n7Y5gaYmRmK1K3m56/GuduqoyZVsaXi5zzR+dpnoQpEDbkrPkqOlX65xiZB3dCATjHWErD5oqsKU5DBpgJvA1HjA2kSCpomijobemiOWi0956TATIUbtJbaCGt1j/bC6xH0c+P+Gc/Ie+gKwI9JlpWeSfyLKHabl8H2ixjL3EZHj9c39/dHBPhaHoiDfrsXWZmsjYNehN1W0X55gsefLeCTY4cGbGetcoBOa3VTGsNjH2ZcPjVR0yG+1tOA3rloGXJ06xF6U7NHZRoqtGhqNO9tYneVriy/32ZD1GG2MSsKE5XBi4jeJikGzWviK2rkRAjhVz6ChUn+o1t6AJEjsx6VNXVZPgl06XEWDoFL2+avpq/Lzet3wjCtJINaTlak0I/L8mWZfoxXpRqWfa2bGdS6rcY/zfH+anOaVto0wXm9fau3P/1vqWQbPtjGWXPLBK6l9gg7jBAm6dh0/zFwHvl4BYq88Cv7kkgxFxPziC6E0wVyhcrOY+5IRHQNNyFhEwxARn4Rp3iVF7ESNd/wVMbkuNjiJHRObluzniM4veOpiy2dVMyJWmh74ssMrOYwNbQ9wheRUtn8rinibDSZGYkcoghKgm6O8fFWV/kr9ReBYDl/L2cn82r4qDUVDc9jFXb36wxkyv
 mLHbxyUv
 qqN6qGmOmaiww38miFXonH+ki1UmU/zoWmu0rnViQnRrP0r51LeP6jDh5P5M8YLnSmXhQcvLB9atIkfo1PlCXi1Di+3a7YVhiw1y9yDlgbwQ5wIOqiJspa8m7BJ3OLKveaHU41VA1Gx/dhMNZ9niwuRcZgB/sz+/3aTJX8fehWC5E+V4lhVHRUB5NNjceVuHT74POnPsXWp8zvb9IcsV+MUb06anUIX36jJ6ClvhDXpm12vl+994hmSaBersR9a8sRgWBZN8euSLyv+Dg036HiuSPdSSrBb0r5mad5UcUXGQSjX+JuNnenM7A/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +enum liveupdate_event {
> > +     LIVEUPDATE_PREPARE,
> > +     LIVEUPDATE_FREEZE,
> > +     LIVEUPDATE_FINISH,
> > +     LIVEUPDATE_CANCEL,
> > +};
>
> I saw a later patch moves these hunks, that is poor patch planning.

Yes, you're right. I have since moved this to uapi/linux/liveupdate.h
in the introductory patch to improve the structure of the patch
series.

> Ideally an ioctl subsystem should start out with the first patch
> introducing the basic cdev, file open, ioctl dispatch, ioctl uapi
> header and related simple infrastructure.

I have modified the patch series as follows: The rudimentary parts of
the cdev, including the uapi/liveupdate.h header, are now in this
introductory patch. The rest of the ioctl interface is added in the
old patch that introduced luo_ioctl.c.

> Then you'd go basically ioctl by ioctl adding the new ioctls and
> explaining what they do in the patch commit messages.
>
> > +/**
> > + * liveupdate_state_updated - Check if the system is in the live update
> > + * 'updated' state.
> > + *
> > + * This function checks if the live update orchestrator is in the
> > + * ``LIVEUPDATE_STATE_UPDATED`` state. This state indicates that the system has
> > + * successfully rebooted into a new kernel as part of a live update, and the
> > + * preserved devices are expected to be in the process of being reclaimed.
> > + *
> > + * This is typically used by subsystems during early boot of the new kernel
> > + * to determine if they need to attempt to restore state from a previous
> > + * live update.
> > + *
> > + * @return true if the system is in the ``LIVEUPDATE_STATE_UPDATED`` state,
> > + * false otherwise.
> > + */
> > +bool liveupdate_state_updated(void)
> > +{
> > +     return is_current_luo_state(LIVEUPDATE_STATE_UPDATED);
> > +}
> > +EXPORT_SYMBOL_GPL(liveupdate_state_updated);
>
> Unless there are existing in tree users there should not be exports.

Thank you, I have removed the exports from this patch and all others
in the series.

> I'm also not really sure why there is global state, I would expect the
> fd and session objects to record what kind of things they are, not
> having weird globals.

Having a global state is necessary for performance optimizations. This
is similar to why we export the state to userspace via sysfs: it
allows other subsystems to behave differently during a
performance-optimized live update versus a normal boot.

For example, in our code base we have a driver that doesn't
participate in the live update itself (it has no state to preserve).
However, during boot, it checks this global state. If it's a live
update boot, the driver skips certain steps, like loading firmware, to
accelerate the overall boot time.

In other words, even before userspace starts, this global awareness
enables optimizations that aren't necessary during a cold boot or a
regular kexec.

> Like liveupdate_register_subsystem() stuff, it already has a lock,
> &luo_subsystem_list_mutex, if you want to block mutation of the list
> then, IMHO, it makes more sense to stick a specific variable
> 'luo_subsystems_list_immutable' under that lock and make it very
> obvious.
>
> Stuff like luo_files_startup() feels clunky to me:
>
> +       ret = liveupdate_register_subsystem(&luo_file_subsys);
> +       if (ret) {
> +               pr_warn("Failed to register luo_file subsystem [%d]\n", ret);
> +               return ret;
> +       }
> +
> +       if (liveupdate_state_updated()) {
>
> Thats going to be a standard pattern - I would expect that
> liveupdate_register_subsystem() would do the check for updated and
> then arrange to call back something like
> liveupdate_subsystem.ops.post_update()
>
> And then post_update() would get the info that is currently under
> liveupdate_get_subsystem_data() as arguments instead of having to make
> more functions calls.
>
> Maybe even the fdt_node_check_compatible() can be hoisted.
>
> That would remove a bunch more liveupdate_state_updated() calls.

That's a good suggestion for a potential refactor. For now, the
state-check call is inexpensive and is not in a performance-critical
path. We can certainly implement this optimization later if it becomes
necessary.

Thank you,
Pasha

