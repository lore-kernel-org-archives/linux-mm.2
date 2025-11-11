Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE66CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96F578E0005; Tue, 11 Nov 2025 15:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947AA8E0002; Tue, 11 Nov 2025 15:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85CE18E0005; Tue, 11 Nov 2025 15:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 764E78E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:58:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40E66B6F25
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:58:20 +0000 (UTC)
X-FDA: 84099539160.08.55B448F
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5E83440008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:58:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Da4O4kiY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762894698; a=rsa-sha256;
	cv=none;
	b=By9X5XlCKbu29f2FoV3nl2HLKXuqeaeFWkXCzUx4jui5NGmb0Eck04luwcV69VenYcaPYD
	CWmNTnvCpHsfZcIZSjKWfIM5e2fN2M8qILTqps04rzVLp2vUzBsg/ch7bdDpV+1mvM59So
	maDGgwiYU49P4tFIxMX3ImByGV0MEwE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Da4O4kiY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762894698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IPiXaFkwwZtaZuDIqZvEEkFtfPxtooPB1hfynQopyI=;
	b=Lbmz2aXNZ/9o9fcCJ5PiXCjNSqHSW1/JAjATA7tRKaRlTjxakhZPDpaj1LLXYGTP6FqSzf
	Tah5eenStP0rOZagCwGUfrLsvKrgdhqB5gIo5RD7yEd09tQJ8I2j5nP6cXR/+1/k3MgPNi
	9hcL5qCYpfz1KiU6eSOTSf0AU3tQojM=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640b4a52950so140828a12.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762894697; x=1763499497; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5IPiXaFkwwZtaZuDIqZvEEkFtfPxtooPB1hfynQopyI=;
        b=Da4O4kiY/YmfZHxZC+dz2rFm765JyD8JApWNnm6pSPKJEWa0XqG9h4r97Gjffo9AHg
         BE57OYjwNp4ljMMjHtHPU0EkcICukzdY3WuUB/OtKZea8P1eU1mL7ils6e9qnDTB1Whj
         IJavAKTyq86b+KumlKbopLo95yKz4pOJorU96j3XiMyBPb05L74zv69nsqeSPKWBkY8z
         xSTMbmfklZkSfQ/TkGsYgz+hi/FHFP7RE9zaO42prwWsX8xiL4KNlGquVDDuZGBJ7htz
         +W7YxgaZ9KWNKJexRaJZoF2/XNlxfbPMjnVmXnVWLvgtYJzPCHCYu/GPIhoryk/1KA8N
         TgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762894697; x=1763499497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5IPiXaFkwwZtaZuDIqZvEEkFtfPxtooPB1hfynQopyI=;
        b=oNOa75DFyDTvnLWy3lFZ+qD5VNRehIES72E2iuNe4chTgdz+CmpID6FYMdvd7fQevp
         X7gu5k7kTLd5QueJbg60X5/QcaciQ1G/8fYNpqxlwOnvJIyw9NgKLNk66ApMiw+rtwhq
         dnBf8ZOicm+C+p4530sp13jOJq1hwaMX5Oodk1DTbW6becbJEhhscz5hsSroPtU1SaWX
         XRKhfXP0YN1HLesCc4cW34chnjN7BF4huZd0bNruvWgHMP36JuYgmyOotp7p8wA34dLt
         q7SEqeki3n0i2c6zhTKetxJPXiyjHu9iUjk9ANdFtxqtMHufR3M8CWA5JY3YkKhKqNjy
         eY6w==
X-Forwarded-Encrypted: i=1; AJvYcCV1bpND/Y1+czJG8K2D5xWeriSgN5tb0Gvwf3oAcuc5sLyIY+rC5j49peZVzHuM8aVcdRdlsZD9TQ==@kvack.org
X-Gm-Message-State: AOJu0YzaxknRUDtApmzSLU8qFunfosdA53RZbY17l/jkPxS4swSY2N5L
	tgWj3NShvbiD8RQfabcutvVxWsiSbxbJA5/SNJCLPYgeXUqxZN+29m/NZtlj5ZXpLF9mfbB5dbA
	SGmRoRCenm1jgF2cWRZg8gEg5vNDmlnnE1eGlBroBjw==
X-Gm-Gg: ASbGncunndwHu5zJ/VQui0NMsAk2IIkyGZARc6l/ut6eFxaRc6SCGwMA8R5g2MK2k14
	wmVaHpwnbfifTkUlxEEb4oXrMo24gE5zKUvnIEH8G5y59KsYOnlMRjGBAcS+vSqBKRYRcQkywwK
	srUTM/AzjtuQ7aW45jcXiZbAii3c3xcUTTVfoDackSOmDsP3S+e4IzSfyZYRF8YJ+hX+GYn/0Sz
	P8evVatoRFLQFjZsRP8NqMovEClR7k67TW2NCzK2FCyh4b8BV2N4HNdpg==
X-Google-Smtp-Source: AGHT+IHuAFVKekWd1XIceTepFQM+2KcFkyr0+Jt/14Gjj3YjuSVXCqO15zGETNvx22Zso3bXtPLN06bMXeUC9RPF4AI=
X-Received: by 2002:a05:6402:1450:b0:640:ee09:bfc1 with SMTP id
 4fb4d7f45d1cf-6431a57e0ecmr566813a12.37.1762894696728; Tue, 11 Nov 2025
 12:58:16 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRHiCxoJnEGmj17q@kernel.org>
 <CA+CK2bCHhbBtSJCx38gxjfR6DM1PjcfsOTD-Pqzqyez1_hXJ7Q@mail.gmail.com> <aROZi043lxtegqWE@kernel.org>
In-Reply-To: <aROZi043lxtegqWE@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 11 Nov 2025 15:57:39 -0500
X-Gm-Features: AWmQ_bkvWgSaihTKA4ZFuehWCb49R8fZ8C14CFTHsoW2qubcK_JcQqaA8FvRRnI
Message-ID: <CA+CK2bAsrEqpt9d3s0KXpjcO9WPTJjymdwtiiyWVS6uq5KKNgA@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E83440008
X-Stat-Signature: txq9yhii6e18yecyddfowdkw45o6k76p
X-HE-Tag: 1762894698-10295
X-HE-Meta: U2FsdGVkX1/1PrCUvZPwcJ7N8A31y8eoeDFCtUinSjnn3qQlTRTg9fOkL7++kGvfq1EYld7D2ZY7dLQiB3VMOi7J+dDhwlFEi+OsMKRHiqr0bd0XbVCYhkaOvvWTFsZ5EBaF4o/HhmRrjAYIALuCAmerWrxk0CARI9ct602PWLvWQLPm3Z6Gz7GBYtQz9pxpcz0BwPI9uAW8pa2T9bAjzMqA9lCpvGjRZIOU6c/ZWt4s+QpZlpBZBUJdRjBxINxMoeBd0N8ppWQhBAh5FLHS6t8yMMW2Ktph0ynMUJYXoo4EIleZqNj5a4lJ9YOGnfWhUbpTHlAfM2t0vdzw510TYurPM6+qE2VaGteIQYlybd9tku9nULPqc/bUucHkvFtrcfqwvk5q6Kn+3GAW4C6/23H8ih1FigJkbivcIT+nvV5qf8Q0QlWz4tzF/UO5hUTDsZtisx8t87tCb2OPrvttfjiKiVKMqv91zXTAo1uboaaoq/GTymYmqrup8OQrFc6WxIBrvgwl0kouSE2tlQp30tvdxt84KfsgfbSLCKzxKcmv/NxZyp+Pkd/U1W0EezA+hzNBeynIARLRwWAKhTYn/peTRCQnSm/Vz4ynxLmcscDIwGjbr4Ogj2xuk+jgyzEMEHTzhvwK5RHnbqeO6O7exviI6Q8HIaMGBJ3RaifapOlGYIAuBjSzAxPu7JhHqFiKw57nuc+uMOH7XEl0LaySJ7fjbZ970N1GDV9H/wXhhAjNcTGEaaDbVfbwZ4NhZl0SLy9+tqFqUZM3YrEuV/ERnlgWfHxO225nQXBr4bdX62sg5tYN2WWNqSybfOEgkFwq2PUPDqU/OOV6Dmm0ilykzRx/gzNkuM/9rckYVQrWIF70EK6wqRKu9xrc4gceNe9B/rdDs2QIrAtDdkxbdKnf55eVEtnbl5FQqMjAqUlTtX1OXwYZ5zXCn4oYhZKACZHQPG7JWyPIY9ALYj8n7gD
 TADCEkCL
 +jYf4haqtKYgS6mnAN2xMDrJPc/pHQZOFDvelKkaFIbcfooSPfEC4ZkEh7S38mLAVGvGY9ZoUzZCEXalk5CxzaahvlU8m6T/PvnbwS+ywMiNZjc/1aW1TYOHEXRjMrMo/8RAJnBezc++V9UhiqmAhctrJVNRrVwotcM14IZU1Nm+0kSBAnYNo94x/mq+c8iqZ3JF428mNSJ0TGrxJ0wVRZxRexA+7wpN1jhYrrvjKIYHEPRCElpNPNbFiBkGC+9k5tUZ7XoXgWUg5ukZleX0zpsLEErdWKL/k3cUWvJ8oTtqTQIyv5UkcF0zpfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thank you for review, my comments below:

> > This is why this call is placed first in reboot(), before any
> > irreversible reboot notifiers or shutdown callbacks are performed. If
> > an allocation problem occurs in KHO, the error is simply reported back
> > to userspace, and the live update update is safely aborted.
>
> This is fine. But what I don't like is that we can't use kho without
> liveupdate. We are making debugfs optional, we have a way to call

Yes you can: you can disable liveupdate (i.e. not supply liveupdate=1
via kernel parameter) and use KHO the old way: drive it from the
userspace. However, if liveupdate is enabled, liveupdate becomes the
driver of KHO as unfortunately KHO has these weird states at the
moment.

> kho_finalize() on the reboot path and it does not seem an issue to do it
> even without liveupdate. But then we force kho_finalize() into
> liveupdate_reboot() allowing weird configurations where kho is there but
> it's unusable.

What do you mean KHO is there but unusable, we should not have such a state...

> What I'd like to see is that we can finalize KHO on kexec reboot path even
> when liveupdate is not compiled and until then the patch that makes KHO
> debugfs optional should not go further IMO.
>
> Another thing I didn't check in this series yet is how finalization driven
> from debugfs interacts with liveupdate internal handling?

I think what we can do is the following:
- Remove "Kconfig: make debugfs optional" from this series, and
instead make that change as part of stateless KHO work.
- This will ensure that when liveupdate=0 always KHO finalize is fully
support the old way.
- When liveupdate=1 always disable KHO debugfs "finalize" API, and
allow liveupdate to drive it automatically. It would add another
liveupdate_enable() check to KHO, and is going to be removed as part
of stateless KHO work.

Pasha

