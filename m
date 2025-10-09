Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBADCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484898E0085; Thu,  9 Oct 2025 08:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434C98E0002; Thu,  9 Oct 2025 08:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324168E0085; Thu,  9 Oct 2025 08:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18F678E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:01:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82EE2140906
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:01:58 +0000 (UTC)
X-FDA: 83978437116.29.FF31FA3
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id B84AB10000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:01:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QrGpZH7I;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760011316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GM7HHu3HbolbVRGEPyllWwUcu2/FcpmuCKiQlqwBpNU=;
	b=GT+aF0efrGiS/3XFMbDZGywdLzIn04N8Mc+bvTDPiJ4xbT0QswlASinYgtKeHCmgRBRcQo
	Z5mZgKCPAxI5nuNjvGxqJhrT7jhKKXXtKOj4xThgvsU6ywAcqO1v9VbBq2EMWkrPrDt2R5
	Okpz2OnuCvQwYdAQy7KkIw7eZkJJDng=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QrGpZH7I;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760011316; a=rsa-sha256;
	cv=none;
	b=ab0jUxdz7kpKEB09A9CGzNN8eR84+jRef4hkkP/Y/H5AYN1y7ltW95mviMZATD8bIZlSTE
	od7BK/y/0fhbZNizKu5oFHZZDuTiWyLKoqv9pWjFfu9S8RTk85UvDg6j0XflIXrzoP3Vnf
	R7pJaHng2nnyaaOeEsATKqSEstAdQVw=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4da7a3d0402so12685931cf.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 05:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760011316; x=1760616116; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GM7HHu3HbolbVRGEPyllWwUcu2/FcpmuCKiQlqwBpNU=;
        b=QrGpZH7IJQLGrPRUTJF7IugYzZD8qLPpEnOtHefcEc57gPu/I56zLKb9mS7M2OPC8T
         zrYHsoA4LYXcrRLAycC8rrOpqlPlxeUDiU5qHkZrah1butZug64r/F1Su7JuP/h57lAs
         NV6myR3MAe+RMhLIPtLDX16esQHFFkyiU/8OqUY8pB5ucahULZVZqDdXB9i4ND26sdiO
         tq2uwdBY/XqXD3gSgT6+5ybTyIwHBhBZAYkbwAUEXqhvDxYF9+fZzzrh5+2morFoKNBF
         Ly90aBfI5keZ4sJqFBFbMAs6pmf6FqBM63/O8i2iwDFRYtGb9t5NTaB/hZspXKdF61HD
         qQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011316; x=1760616116;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GM7HHu3HbolbVRGEPyllWwUcu2/FcpmuCKiQlqwBpNU=;
        b=mOLw5KQxSKT5S6QX0QxO/v6O+tYuq9GhXbWnxbePYGegMBspted+V4F6IH+ax0QEPT
         jCLaujg43ooorNqk3spQ63XLfLehzjp8bVVrSatdLZxwq0ODFp5n2PGEbtuErSRmUNsu
         ribUzimD/Y6dTM0f7EpOxu6N6SIbei7MfQ6PyIPIK7kbiRAEEQDMk9LSwL6p86CFQfxf
         OP2j7RMxMiIn98yLPbUkawu7EITjXah8ngHmP8d4g36HCf3yvVg6sxvCNNqC171metPL
         AQBW7U7/q3Js18juCESjaZPF8hELQitPu+kvDibMxrGDxMj5emQyy+H8eWZwZCeUa30z
         q0ww==
X-Forwarded-Encrypted: i=1; AJvYcCVTyJ3ICcHX5noOacx4xlsN0E4gXn/RLvXkp6BIwkAK+BH3/DKGjNiHAFNtVuCz5/pZBe/Xa/tghw==@kvack.org
X-Gm-Message-State: AOJu0YyNl9sJEsSxzvQWjVp9+PRaAqbs2lwhiZi7Tfl2JQf1RkUweB1J
	D6c6+nA7SJMh8S29AYaviSUctfldJgB2tSIPWFB35DnGtH3I4sgmoAvC1XgZUBzt5WPYDp27mYG
	6ZEjKHaUhJDfm1Zx/m0ozVcwhM3qejFsuOezup0WGWQ==
X-Gm-Gg: ASbGncumfS+ZXBlQpf4DWHFvajMqVJ1OaHlFFFAEBFf0EJN7+Rfwg+j3xt/NRiOnVwu
	yMx8+JvsD1DvP+Z+KXO4KrWI+xw9v0kEa6QNwGTgDc1KTXOPIt86Z+LARL2PLDNN++uFqWoDnTq
	VfzPXw9WVSCbodVNq8FuDl4//olQOder1zA7SBP5zHBaWJ+etjEdYEPDJ1sXeGJTGyFNiS8dcXY
	7E6C7PVa/xkXCdqIjAUto+M99rF
X-Google-Smtp-Source: AGHT+IE9zb3wwXEpUh5P+ZmZZJCDFFOKUQIOo3/6KsN55Cs1OSGbV39rZ1DIVG9kDY7HFP8FPvwlsRPNuhjvFarm0hU=
X-Received: by 2002:ac8:5d4d:0:b0:4d2:ba6f:28fa with SMTP id
 d75a77b69052e-4e6de8b5d39mr171303161cf.34.1760011310206; Thu, 09 Oct 2025
 05:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com> <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
 <mafs0qzvcmje2.fsf@kernel.org>
In-Reply-To: <mafs0qzvcmje2.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 9 Oct 2025 08:01:13 -0400
X-Gm-Features: AS18NWB0gqbxGnAmt0TyUGPWI9yXOeOjTQwVBIB2xaJy4b4dnuqgnZXYRRh26fc
Message-ID: <CA+CK2bCx=kTVORq9dRE2h3Z4QQ-ggxanY2tDPRy13_ARhc+TqA@mail.gmail.com>
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state monitoring
To: Pratyush Yadav <pratyush@kernel.org>
Cc: "yanjun.zhu" <yanjun.zhu@linux.dev>, jasonmiu@google.com, graf@amazon.com, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B84AB10000C
X-Stat-Signature: b6gxosd3e38uyg8gmomixqah6ed7hhra
X-Rspam-User: 
X-HE-Tag: 1760011316-968968
X-HE-Meta: U2FsdGVkX18084VGVXhdYg8+N737OBD0Cix03kmU974gB5vPuKxEe+UcNRHL9PJOIvZZ47Q24nRQWhq3VLhgmh0XhOG5onicarqxCCfjfwECMxb9AgM0BpO6vlGq0IdJcLXbhjTPFgS56l8Pou7sqablL/O7+HGupsWDHvuWm7E9of+qsD1TchcshoH7O/DDNTCBAflpsIi9z225F6Sx4Brc4krF7yqQYZwjedy1G8IIJsxff6JaYmCQ9AMsotbakkHxDQ51VoMX0juSA1Rg4WbiW0DCFeirIwjSsds27RS2kZqprf0NgIqQ5vL13cHNVh++aCSVtCHwK92a6bD6MaMN9DGIfHa0zGHXgiCwfrfblQWCs4y8WUsEUdrPzQ4Fo6XtH7yXrj/Ap/6Lz1AdoRA33GGQuohq+p/ZwNcOU4goEfMpNYlRxU4xy9TFfG38+g96Uv2VK/gB/ukt+I9EHmswGHe0qgso5XIjEPHAzq2cW0iy5PD4tyMDKZ8E0hqvYe8qoXZWLtn0mz/c2Il0ZJDNjHbPAmv7m/5Bq5pxU4FgvVLF4diS3OP/KvoFuVh34lVUcPhsWESR8tLwpRslpufWWuFY9/SZjv1VsfZcEr5wL2dd8IFtEYYh9a3pud7wJZvGtgZwJJ7CQDXjGUuur7yIcHWsyRwsp6paOvtDjLtaMezsObWzdxCD3y2TumCJbylmEdu+WcglNXxsH031XnvNgqWcrjpyNbkHp4Dt+3suOoa4lZQx0+pHAhMtPoTM1sProcWZ6dKqGugrbEJWAYf/SrQSSHrrGgYAVv5qK3NIdQo7TdrNVemA0h+UA7GBDEuhzAxHkBdo2yDFmA+M48NEf3c06OsSe3QDohUU/LY2g42Rn5pFl+05Z0a4/nicSjo9KGhdwJu7PhW363SzWTMbnO0c6jiGyB9YFYvfZO1ZKSjuidKPUQTCCCD6xiRluwUrFcKzIaV87ss+qXI
 EIETIRf3
 q9C011dNVgw/rhRWL6kYzzL8so/4UlSip0kjEj8IsBniQJN8Zf2wZAY22hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Because the window of kernel live update is short, it is difficult to statistics
> > how many times the kernel is live updated.
> >
> > Is it possible to add a variable to statistics the times that the kernel is live
> > updated?
>
> The kernel doesn't do the live update on its own. The process is driven
> and sequenced by userspace. So if you want to keep statistics, you
> should do it from your userspace (luod maybe?). I don't see any need for
> this in the kernel.
>

One use case I can think of is including information in kdump or the
backtrace warning/panic messages about how many times this machine has
been live-updated. In the past, I've seen bugs (related to memory
corruption) that occurred only after several kexecs, not on the first
one. With live updates, especially while the code is being stabilized,
I imagine we might have a similar situation. For that reason, it could
be useful to have a count in the dmesg logs showing how many times
this machine has been live-updated. While this information is also
available in userspace, it would be simpler for kernel developers
triaging these issues if everything were in one place.

Pasha

