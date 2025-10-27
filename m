Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F72ACCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A99800A6; Mon, 27 Oct 2025 19:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A1A8009B; Mon, 27 Oct 2025 19:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39BF800A6; Mon, 27 Oct 2025 19:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 880D18009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:05:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B582B7BB5
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:05:14 +0000 (UTC)
X-FDA: 84045426948.24.22B8497
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3AB7540004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:05:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yeuml+0z;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761606312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QcjKyTr9fdqx3O9SBoesqfDFwLKYeF8Vx1HeQeexLA=;
	b=PTPJ+PywbOfy+5ash6gE261pVTmKaS18e0BNFaGUP53jEEh6FHq29VEOM9Kf+7Qwdmu4VS
	KGlLcpUqRwJKFSu7a01tc5YrdoUp0HUY9PLM8aM57E296DupTIh6XbhRy8WdgD+jq+7bG2
	iqhH6buLd0P5QowkNWHPGHY0bOMNojA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yeuml+0z;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761606312; a=rsa-sha256;
	cv=none;
	b=PO2rYQnQMcpPJRvSC4IuOvcZtWa6pKktacZmCssW97z0Oa7Nkdl02Kwq3JzZB/jt0w3dkM
	s4bRsZ6hVzHoc6JOL/qe6npTPp8DEL6m8zppRVBuqtEILLMeQoXm4EYP+wFbEZgzhIBeOG
	Fat/pu6QKUyMmuljbjbh+IcpgVISrZg=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5d96756a292so8310835137.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761606311; x=1762211111; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4QcjKyTr9fdqx3O9SBoesqfDFwLKYeF8Vx1HeQeexLA=;
        b=Yeuml+0znD8iJImnouZxtnq0zxnixk1WYcGm/Il1frK7ifCV26lYE3YYio8ONNIhKv
         BIGcxRSDFT8Vr9xYdlyvSyj6DSfji3TWj1/2JedypK5h2ZCCqVK8OYQ2ZTT1FqJcx3G+
         RxYYJy2zmOggNylnKWnHDSXNB+VpfmV+2WKOfXu5i8FEg2aMIbrk1+Zszgwz5OlwVXby
         STmW0ALBVzYh9+N26GiM74P53kFNUildl2rkLcfhKwzxEMrJF8qRFvtG1glNfTL21ype
         jbmmX8/XuabMdB6OYOImCpfiDe5dbD70T67iBQ2MrGTg155/3y6hrNACik17NT24D4Fd
         xUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761606311; x=1762211111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4QcjKyTr9fdqx3O9SBoesqfDFwLKYeF8Vx1HeQeexLA=;
        b=kE3tA8gKLhPOMHgYodKUwDVrqax1kxEFdGCynyNVa6IYJyF7eMHqrT8aKhLpjwHwCb
         EpYVP6l2HBWJR3l9Z8WJfmpwD9quIxDOY++ZZ51zh0OEO74P3IiAY6bsl51bQ3sNv1js
         jvyv8V++cSfNRFlMy/hwfxP5XRYKN8g1fMcvXyRgdjaaFm+VZlHzwgGBSs39CEp8KHbm
         ERdgounp6mzi8VPr++51eYeI8nxNRxO1++RG5CZyruOAvocVEtR+0A/XktuUElbOOa8q
         3l83KBcN/i7fuK8hE9DPSMapPeX7PWZslYKClBxqY89ryKF7DRjHSavnt1aZGgND5In5
         hEVw==
X-Forwarded-Encrypted: i=1; AJvYcCWb06PAeR30zXskuXUL2GvoMbcBJlO97iAo+lhUw5hXHOrhXcQJ9sluvEFHMxyh2hImpKkp+lpuVw==@kvack.org
X-Gm-Message-State: AOJu0YyctQ9X0lvdQ6LxSKcww+AzzmK/Tzu6LszSxxEKRutfSxBBI10F
	1rIugtCalMyqJuABM3hgDoV3UojOyLyhu5zkkWv9LajTAdbS1cxn1N2vdtU6QJ7/i+Kbiwe7U+l
	YXLcnB144IBt4RH/HRU/7PwlQ6+kA+cF5T/nfPWks
X-Gm-Gg: ASbGnctc2niwNfW7SKkbSYBypEDXpJJNvibPw8YObTxrFvACVKTAxi5065l/FpWvuSu
	xh2JZ+jUhQjPcH0PuoYPPP6ZEPJdCkYZkN3KYKX/Ga1z9zFNRPjKlpsm7YC8vL6qkviTbrk/Gzc
	ITgZbLBz/oAamZ0AS9QLBqvAJPbEp/V6AsrG/QM1pbZ+0JNADmhBj4V+KbuFHHQgQY4VR9E2XFL
	9SiGCLqN+OkNj8x5ZZNN2NrRk8B2Z6+tFvJ1z2aKCsRloeczTkHpIPfx1VoSFPYper5+XY=
X-Google-Smtp-Source: AGHT+IHpaQt5+0pcMaIPZPH6gSZTkFVrpAwY4H8c4baBjFBSVkthH7idSXvBuMd/bzOIGy2JEPxjML5/b0vPbAuuafA=
X-Received: by 2002:a05:6102:18d7:b0:596:9fd8:9268 with SMTP id
 ada2fe7eead31-5db7e0ae09amr369527137.8.1761606310932; Mon, 27 Oct 2025
 16:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com> <20251021000852.2924827-4-pasha.tatashin@soleen.com>
In-Reply-To: <20251021000852.2924827-4-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 16:04:42 -0700
X-Gm-Features: AWmQ_bkP7kzVj43hv33PyztzJtnw3ebpuh-wFqU7ylSkamn2ND777xZJOuB-IiQ
Message-ID: <CALzav=fa0rxnf-ufDmV0uhA+zhoOB2vp9ksfNpeE0amxnLt0jw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] liveupdate: kho: allocate metadata directly from
 the buddy allocator
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 14mskx91w1pyzwqdwoja7ny3uguojhkj
X-Rspamd-Queue-Id: 3AB7540004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761606312-502902
X-HE-Meta: U2FsdGVkX1+CO+yOyF5CpMhYlSFF4VOhUEw6OeR9UTRBveqspuclSNtX9s29U6hLjxBkRcNVnagFkgVqijo6HFTyssl+N+H2dUN7DYbzboXuts/BXm0QwiVNz/EyEcJnqzndaf5BCfztMHRthmuFPONavGywtcazauuQHM2W4oAgFoqkjbf9urYc9nqA96rN6msswmOQORykBUNVYitCEkWqS5F8inW2uYe0Poz3fFqcBXcJ1k2AwoEJGtzCF6r/UjG3PZuDf3ggzFaEcc0cWoMVYrKBaiq6+PJWyeLg8fL+waxIpXXdGlM7/gl5FUr2yiSYTYdj5yZ/9yBe9CAairZsvpoISUSwymL5SETpfOx8oT36WK01+gQthr+a15TYkBP4n1J349xsiiOAVDnr8eckbaugyR/2JHXZ1moDOpVf2nddUX99bvaPtHJsGQnpVZC4dIFxDsjTHgNv527Wval8tDHjLQrL3GpYMOg3u6HgTjt9GfaBCfXsQ5vffRGoAbyszcPCWApcMvsfQiGT89ZUkuHfLDQqAQV3h9gyk/8VKRub1otX5gcXztbi008zKS4vfDtp+NVjYGrHM449OQ8zTQfDIBTpYoN2FqrhBsSimhzjbLa9NYsTiKz9YKnhPx8QmVAmIxApIgg+UrLJAx6hVAYRh+8mfLgB977K1yJVCPYarzmnLK/XL2FTsg8IXlUo52UB6AIllU2R0prRZmsMnYzfnZZbqWI9j1zWnqVe/5mAjI/7woQT1Wwa7eJiOlPIjSHYS/WOv9whxw97DK/o+dYJeaEd6PqB1h9lxREyOCI7BP+0Xs9fuXBvIZw8YqRwMDpuO5W8gmg2cuMdSsSSthW8mgJCydEvxtrLOBEoqYgiGk1Aty+18vnnFfWKQqCMCZ32Ih/wwIl9032K3yJDckyWDP/EwNT3oxXyvzrxR0zb4q2s1twULPQfh9CyajscL3Pf82IG9L/s/3R
 Y83oMqWc
 ArS/Hu+DscQ9fx4QnnLCQbWmxyq1/ZHS0CS6/mrttuJwSG+GgAeOcqAOCy79UShM27Ewccx0qCh9vEM+jpkhCo+I9Z93CvO78Bq6L8fkvhJaVM9HdiNkMEeSjR4yB2JZ9JqpJ2zwwUd/t7ak/ESOulTS4FwUvjkrXVH1nkz4XYuRaeYamdevwOt+4hAl8HjgQI4S70cKAw7JL2dV5aFgutaa77I2iSHEPV/W5lgEkdeNfzqVHsUE1wvi5aL5BQoabvQvEHp7605PzJzWeW34oSMz0vaGW03lFWsd/f63llbIjDZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 5:09=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> KHO allocates metadata for its preserved memory map using the slab
> allocator via kzalloc(). This metadata is temporary and is used by the
> next kernel during early boot to find preserved memory.
>
> A problem arises when KFENCE is enabled. kzalloc() calls can be
> randomly intercepted by kfence_alloc(), which services the allocation
> from a dedicated KFENCE memory pool. This pool is allocated early in
> boot via memblock.
>
> When booting via KHO, the memblock allocator is restricted to a "scratch
> area", forcing the KFENCE pool to be allocated within it. This creates a
> conflict, as the scratch area is expected to be ephemeral and
> overwriteable by a subsequent kexec. If KHO metadata is placed in this
> KFENCE pool, it leads to memory corruption when the next kernel is
> loaded.
>
> To fix this, modify KHO to allocate its metadata directly from the buddy
> allocator instead of slab.
>
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: David Matlack <dmatlack@google.com>

