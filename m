Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C91D1CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A01A8E0056; Mon, 10 Nov 2025 11:41:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078078E0003; Mon, 10 Nov 2025 11:41:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECFFD8E0056; Mon, 10 Nov 2025 11:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB0AE8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:40:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A58161A013C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:40:59 +0000 (UTC)
X-FDA: 84095261838.30.A27748D
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB8FAC0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:40:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l8kyq8Ct;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of glider@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792857; a=rsa-sha256;
	cv=none;
	b=48e5XFLZE1RpJ3rZIOYGN9jd03u3qTT/Tui1VISdZvk5U8eEvblSW7lJlcD0LkgD2BxmTL
	VkZqecO6XSeT+EaGLK6f46E3qZDQ8ICI7pmGhU7zH4QoylR/f1d4BVzb6jVVky0saWPImi
	hn2CjX5nOP7/3ZjjF1NV+AMmA3yFiqM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l8kyq8Ct;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of glider@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARP0s0P8t6lHLXGPK7oqG4hn2hPk4JBv7/AQ4HrLq7Y=;
	b=ebeQg98tKgJm5jlEXqkR1ydIS/10jrClENmuB9P+QT0CfKhCDCRZXsTqzUCSHoCiDz6QG2
	127LPgOrV8EwdOxm9xaQBf/4Lk0t9291PA+o2rchM42jtcEkiSUt0LNhfob+Laij0H80qb
	SY0OGA58/cHAls5seOmykv7XnNgfEYw=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed9c19248bso26336901cf.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762792857; x=1763397657; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ARP0s0P8t6lHLXGPK7oqG4hn2hPk4JBv7/AQ4HrLq7Y=;
        b=l8kyq8CtShHqtPAJb4OYhl4zIdNq6kJSeJ1Xo79QhR3eTQ31D3la6+r83K9jna7mPA
         GXCYcsZJHMdPUrFzS7HqPLp+A3No/mQgcg4pcBkp0bSHBSOqAW5/TY44tBs9b8mcSeGg
         fREEYJRWJiiu4UXEHsfnIH/MIzymLbFaTe7SwXCkV35oEIeZ5xqJHoW4ON/UidCLOPJh
         CCrWJS4G9Na6EqXbzayqjYeD7vRi9zTwhUug+WrcuNpnvx3/RnLHEMkyZaNKovQCYujD
         dpF50o6R8vGyAQAjLzJCcCHoq88375twZJxU8p866qHn9aSKXPEwx+Wgi8HbwyobVPda
         M8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792857; x=1763397657;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ARP0s0P8t6lHLXGPK7oqG4hn2hPk4JBv7/AQ4HrLq7Y=;
        b=t3QOFseTTkgBhwQw2VXMgTN7GPNj2Rv0nhKc/WrMWrJ7QCF+latnQbxtacQaoM1E1p
         o3Xe8CB364JwmuFP/5BAWvK74Ndqwx/2twWJ+7DPKwE/qu0uofk/WabdceYBubeX+dAl
         zLfBc7FgG6vIIf2ZODjGxI69aUYJy02yWLTigo4pBrMq/ywyQGO8olHaK9cp7aUluGGA
         YG8TEQU+w3dWNKHSzedC0qytk1PJ8kclEcRJFCdu40wafqUtdvxBsaNLzTzPgPinMTNR
         DNv30sfcIAamrE6ry/2aiUPZQIf97sOvWbevAIPvXkDeMJOggXfGoFm5WsXkZUkfJcir
         pwsA==
X-Forwarded-Encrypted: i=1; AJvYcCVtjaP35KAe5jPdj+9w5iqHaRF1LPgkojbl+u2rTWeQYTCCsqrjqX80lZiB0dwbj70X6QswQ+jG+A==@kvack.org
X-Gm-Message-State: AOJu0YwHj1HiBXkGASnC1Z+34UV37y4L/gqwzNVrnJthDZALqf1OZCl9
	5U4lxipKtffc31qXq09/xbHh8DTsxW9Kaf3VZJCXsETeGEZl7XhFJmbqzYlqJuvvpaubgcQopfH
	UyARlxisFngsczFCq6oHVxrSJN85ihSfp3EfIenX3
X-Gm-Gg: ASbGncsQ+0fr/O9StRBtQRKrMoSWX1H0bpI+siNdQwQC7LfGegcqvtWg+Ayz1QMaWnk
	h6D8DBWh6k1qhlvaYVM3k46cOTgAiGLiE4lKARvWjZSKSNE812Yy945zbcg1wUjlmzEfOYcOKee
	puLLQIJ0U2iC+Py0z2Ay+6Dui0zi0jPTvGmsxqsa7WSAm7vpAEmR2TOSIw/fxilpdFVrJ3rb5yY
	erdJT7FDan3x1oOXYwx17QJDPyXaqtdlfxjSyv90sU+E1SAe3F7Fuul26Wabzvhf0e+OFKq+d1H
	WtBUHCg5d3Z3WQjIQIjKyIMTlQ==
X-Google-Smtp-Source: AGHT+IFXtIVYv/1akorIwGTU2TyeYWKo/ZKjasuLxC+KldJLVH++s5nwoozhcb1g1AswN8A4ZgMNuJJXiz33fQE7EOA=
X-Received: by 2002:ac8:5d05:0:b0:4e8:aa15:c96d with SMTP id
 d75a77b69052e-4eda4fec971mr97364671cf.55.1762792856275; Mon, 10 Nov 2025
 08:40:56 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <932121edc75be8e2038d64ecb4853df2e2b258df.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <932121edc75be8e2038d64ecb4853df2e2b258df.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 10 Nov 2025 17:40:19 +0100
X-Gm-Features: AWmQ_bmi0ifqdxD1pRga8rXt1izLseEvw-FOTscdlGLXMffgSbt_R_kuG7tm2tc
Message-ID: <CAG_fn=V6pbNdN3w0Jr5rCL=M27-bOBt4AK8rB7UvvwT=3g4m7g@mail.gmail.com>
Subject: Re: [PATCH v6 02/18] kasan: Unpoison vms[area] addresses with a
 common tag
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org, stable@vger.kernel.org, 
	Baoquan He <bhe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB8FAC0006
X-Stat-Signature: dsjt9qorhkdcq48hj7rsayq66aecth9n
X-HE-Tag: 1762792857-87002
X-HE-Meta: U2FsdGVkX1+I2cYjUXkaRuN6cDc1ORxxFWPHhtHqQ9MZvt9oENiT+PsdqnFqRn5yYkuVZuIS4Rr4LvjjKYY4GY2MqY/QfIBdTcosvaOfF3L2JzuM+LJ5Mfqv9B/nIGycmxwjWh8VCikXjMIgqLc2PFoIwdUoAr7GL6o2EVkuaIP8IhQEtyKssu+0xeBQR53hSumJV1InceXnyGn5LCSmHbOY9bqM2mKoG6/JHQ4H4x8rMvFteKyd0Dj12AYZi60XGok2kBUE5aDmXVu/3/xhC31kaHcWLaVEMMuHepYLCdL9wILc66ckQJ0QOkA/McJKhbz9EGxarZpsjko+Btov3TLOicMizrPLEaFwn7DD4RteVYRi4lg0gNzgXJUXGK7EpU8v0DxSzU0//lGICT/tNYWA5wziUFi6VtHIR/D//FgpETBeYiiJ+O5caCIxCW8bEjwnBNjhKq8AEYLa9Gb3vy17/ue5lgs9dUfoJGTGiu2RMXMVkc8Kr0QBnvqJK+VN1NSzUIJ8NI+Qu923Yt2FytWAE5pwwTruwiYt+1VBIrKjgoHRCY7u9x4DMsUzJeBsnThcLbuQ9PGG+S4eUbxwt9GbIJCfzF1Rn8CQK/7E2oo7hEwFAXcB91fY1ZdNalynWbVEf3rJ3SyGvAmq8ddR2f32z/Gx0Kh46sIF7dUt4mU9Es/YxCPWaIHR5IUeIAo5UCWSaE0vnc7l5SGOu8BO0rOEmXaza/l/0pMobU896Y0cWhbwwVwYomVnLP8b5aRaZ8pF64zzUaXnY1MPq2HxEijk0YnTN//ERuhUaHeLbLnFKJgIWjOkVtFBcpcHbdPQHSDcDZxt+fVLB465/gnwlBz1vVBxR1O5hkDQsiuVMpGCOZtYsD3lOlppWl1239X1HvSkmU1QuEwobi0vID7VaUWemySlyVPShpc4F4Q2/hIZSZSYeDGO3tte441+02vPxgTI5cVIcMGGPkjDeMZ
 RmN/atNc
 C8yRXIBVsJtcHkAOY7DVKbw1Xh8aCBjBrqSIJElC7Sk05NVbn8Hsva1E2jkUTYprbFvhNakx6kwVeQ0k4X6tMl1XNybCx1f5hgRS39MjHe7gGcfX0NCDJ1Yo6dapoTKRp2t+SVMFnEWyKpssAIkYNXfcJKkB+hqaJZuv8dX2E2BRoBaFaJXAQOT4z64PbzzfnphSix0nCQcGkhhDMn2DFrKHrGW14vFqwBtLEaKuh4Vab2rbCaK2D2h92mMIXYyInVp7JJa5KcwUadWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
>  {
>         int area;
>
>         for (area = 0 ; area < nr_vms ; area++) {
>                 kasan_poison(vms[area]->addr, vms[area]->size,
> -                            arch_kasan_get_tag(vms[area]->addr), false);
> +                            arch_kasan_get_tag(vms[0]->addr), false);
> +               arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(vms[0]->addr));

Like set_tag(), arch_kasan_set_tag() does not set the tag value in
place, so this line is a no-op.

