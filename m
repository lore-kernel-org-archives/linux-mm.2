Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31C3CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E715B8E0025; Mon, 10 Nov 2025 10:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E488C8E0006; Mon, 10 Nov 2025 10:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E448E0025; Mon, 10 Nov 2025 10:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C45098E0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:44:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A3F81DF2FF
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:44:24 +0000 (UTC)
X-FDA: 84095119248.05.85D477B
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5CCEFC000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:44:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ikgprMaU;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQAadWs2BEV1pVXExDFNf/QXLwU7Gs3Db0cLPnWAqzw=;
	b=sukXTxewhhGQ6XwMikvFSZnhItgWnzgSQf1TKZdwaE+9z7wa9sv7xBSD9Fnv2i7m6hnUY1
	3BfxtUSkaJzXoAKA/MF4we6YtbR5JVijTOoD8smf9nEhMaQfwnrEnKQCMG4ufV/KEMZp8h
	PXNaRu3GVz4YkUfjnWW0k4pYTS6APYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789462; a=rsa-sha256;
	cv=none;
	b=0j6cJjCvNVfJfGRWai8y66+WXblTZ1puxzjrCq47dg7MRv89AV7ammP+23BH8UFd+u1cCt
	U+mf3UAK/pyOmTZpOCQ0YIWwNYziEUoQm0jC7k+xY8QlZIBcpSGpqeNEo/MMUnW+uNpKoL
	dxLqCnvLyli/1ZZChyOAu8JE44jxCYQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ikgprMaU;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso1627163a12.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762789461; x=1763394261; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KQAadWs2BEV1pVXExDFNf/QXLwU7Gs3Db0cLPnWAqzw=;
        b=ikgprMaUpMELW9Nah9h+zGPpAIVckCl8qCAeH2BEqBQd0H+Z3908TDkA3+NkN8fLYV
         M4jLBU9IWlbEYMOzk8G2GzMAftk2S+Ez7IlYASuf83EoL9dyjDI98ZSuUW05fSIUFALi
         rTswI1MDing2ySUetkznxPqBbTPEPZUC5yCRWuHCe9p8pYpZH8v6qmilpNoxX/1n/A0X
         rqcjdz+221srCh3Q2ekQYL24tVZQuuz+TkGcnmD8TpcJQtlzkbkTU/lPne0u1uIxlc7T
         DVsmcc/F5g6zNR/+K2897kZ2PmrfP+hs8lF+SS881n7Y9ccQe19iR2RRByVeKXilx8Fx
         JQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789461; x=1763394261;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQAadWs2BEV1pVXExDFNf/QXLwU7Gs3Db0cLPnWAqzw=;
        b=NhLYbjoAZyIsGmB3/3cGbcH3t83cQN70eNTODIRDKc0I7pAWQf3VxgasLwbfBZdCbj
         gCSJp9AKMFhYxrgNGCevm+ybAV9k1Yx6/s1Or1zeEZ0eqhdYJd31o8yC+2+pOx1wOxMO
         jsjTnnSO/sjTHR3dJY3SPr7S2u4IerWKv800yvWQ9MhkaHlUj3y6pjBpFT/6CTHx5uBK
         KVfwERGJaSFkxhAHsoWtXkHT/u7P0RrGI3IpY4K01W6vOsnyaD5V0A21Tsq5UoK+ZPKT
         etIH8M8ffs11e4u3lxy8Byt9IjPh1+ZicXWJ9SL3DpNzrQvBhlRP1c/F/hIclJhPyPfk
         rXMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5JzoVMyusRY4AOhAdcpHAs5wZqeEgoF6OL3psn9bIrQgTVAaRCusP25xa9q+L/uiRyv7g+CHNYQ==@kvack.org
X-Gm-Message-State: AOJu0YzOTbkEmDdYRcGI4+r1YkQE+/Ni4aYdjmnyp6QLWtsTBh0d/2Kv
	bAfgi+oNHwL7SaN0yI01WrM6qgUuwdmeu6zRoYU5gBvLFwQZF35tBNtPNGfbn5/IjzuTg8WHPJA
	jTqLZSLrhcobRo7bV9RxA9DZ5e/ahxhQiV6s9dpAhsg==
X-Gm-Gg: ASbGncvFFF3XtPUDg5o0nu4QXJRhZCsBq7xcK7sK3eZXrKn0V5gtPc2lV45jcM5XrEq
	u0by7Mx2Px3NdSyeySQKfbNjVTEuxXAtCY4bCIxAbfq5I3A+/DP4Wb3pdyB8awqcJcoYbFru1QP
	RRJL1XPdbHz+3I2E3mEhPVKl8H9QMCQLExul0RtF6N4xV5qVverjzowUrbGsEsEjwa290tazjTo
	iPLw8C4pRvH+3RS4KRxdxqYPH04j/rii5yNM053xpyZsymp1msbt9sPKA==
X-Google-Smtp-Source: AGHT+IHgzYBqOch+pmqIr6aFKeN8KU2lBlaA5VrUfecgkUX1bwRao0L5zlIWi8QFdGiWaxEVfTfghHwHllS6y/yRZSI=
X-Received: by 2002:a05:6402:5245:b0:641:270:2c5b with SMTP id
 4fb4d7f45d1cf-6415dc082f2mr6735966a12.4.1762789460667; Mon, 10 Nov 2025
 07:44:20 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRHiCxoJnEGmj17q@kernel.org>
In-Reply-To: <aRHiCxoJnEGmj17q@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 10 Nov 2025 10:43:43 -0500
X-Gm-Features: AWmQ_bn3hTY0dfz8jKC-NQyPogDeCUM0IUVj5R8f5Xi9W9zl_j-5I3l31CcFnck
Message-ID: <CA+CK2bCHhbBtSJCx38gxjfR6DM1PjcfsOTD-Pqzqyez1_hXJ7Q@mail.gmail.com>
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
X-Stat-Signature: aioibi664aeh8pijtt5maxfe1zjxi6pe
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CCEFC000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762789462-810381
X-HE-Meta: U2FsdGVkX19g/454A0JTfcsotjeo0kiokzIjxt3vbuGYGt19CBLOMwmFKHiGqFiaGW02piV6mjhRyeESGyH/566Gik7BITNEXoHP2Jvz4WwSX9uaCfBKTyhtD/1OssxbQlA+uUiCayyhf/NULY7iPlY0Y27BR1ZR/lPs1KXgABkBZ0NMn6tS/sDg9+SdU8hTJeD0j40rJJdkPf7MYyKsfI3a8KR/jMzpraqYV/JKEB/QiYfTr3RjfHHn0dnxEiehJZYiHZz3OXVlbAZ9JbXVayOAoY9zsA3kljqpIGeU2ZHMkwFDoH04E5AI9Nqf8L6wLSxg+DHwTbTbWAs9IuQ1begSdNQE7Y1RitVOFvrn4o+BsB+vB8Qd4Lh7nML5nK7BrDynRaJeMv4tEJ9fggJtSWrd7Np+av6hC5RTdE57EbTgncME26fqBQduKkKiSG7lTHN0VaT4td1a0EP/X4Jn1mCa2S9TSjNqJyH4iB02iTWov7LMxiCuFGnkWobZ3YD5zvBSOurRE8gKYWmNDLwxnnj/UTHJUzQQp632utISf5J/zAbfHrKKgnOaZTIIo1lB3wXb0S8Fmk/ijU+MR1WtJMxa7acmUaS6J2gF5lSMgMl2klOMxt0yVbqhZBGTxtaXoA6GTOeXbP0FWN902mvG0J1fNjlmA12gVODWtLQPhowJ8WQPtQSh6/rcatB5q/ZEzjWNI+9i/O4TcOr1knhouWacp+uFGtBKKAq6AN/3Yt2wM3wed2jQSJLqcNRPF78A+L+b9Y65s49JEh3bntLtOUo+dTRTsorNON/+xPnDEZ/Ps3IfCN9a7gtZaiO6Ujd0OZ8eQTdV539iFgNFQ5xg90omP2nwDO/CT7Nr1ORIdeS9Wh33B/7rhKrpSuLTC4RDVWvplFXGb4Wx4or4b574KuuisGu+F7EnIVf4tf20Fb7kVmEHnrEeUw3YYlTbwwjDFFfUs6m9EAY5fPJKNOc
 o4yyysQs
 uuXQlP9ohKbzSBFC7LUfrgBSMdMsoVs3wV4ZPEU/zVhPBtlqWLauPhuOMtjQuNkkm9+1EFX6ZYVB6Gvxu+N1QZYplpmo8adEUcKZIuNIxAVrCwgiIQCcsaeUVZtsBhPaCc5eV9AgCDA9eUejRlUnZPiD5BNpxhfoHN0B+IqFtXP0fOKdwlift4+3ialdWqW35BB9dO8u4cKcBUUnEdLeXoVeWXxO53BdPTWzbUvqzqDcyvyLf0RcX0NRl6OeSs3HManOzMSsjgCtdw/aCQMXTY1twB1yWXRcRWjeDRW78pEc0HymANDpZZF9k9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> kho_finalize() should be really called from kernel_kexec().
>
> We avoided it because of the concern that memory allocations that late in
> reboot could be an issue. But I looked at hibernate() and it does
> allocations on reboot->hibernate path, so adding kho_finalize() as the
> first step of kernel_kexec() seems fine.

This isn't a regular reboot; it's a live update. The
liveupdate_reboot() is designed to be reversible and allows us to
return an error, undoing the freeze() operations via unfreeze() in
case of failure.

This is why this call is placed first in reboot(), before any
irreversible reboot notifiers or shutdown callbacks are performed. If
an allocation problem occurs in KHO, the error is simply reported back
to userspace, and the live update update is safely aborted.

> And if we prioritize stateless memory tracking in KHO, it won't be a
> concern at all.

We are prioritizing stateless KHO work ;-) +Jason Miu
Once KHO is stateless, the kho_finalize() is going to be removed.

>
> > +     if (err) {
> > +             pr_err("kho_finalize failed %d\n", err);
> > +             /*
> > +              * kho_finalize() may return libfdt errors, to aboid passing to
> > +              * userspace unknown errors, change this to EAGAIN.
> > +              */
> > +             err = -EAGAIN;
> > +     }
> > +
> > +     return err;
> >  }
> >
> >  /**
>
> --
> Sincerely yours,
> Mike.

