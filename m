Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19810C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276456B0095; Wed, 29 Jul 2026 09:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246D06B0096; Wed, 29 Jul 2026 09:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136606B0098; Wed, 29 Jul 2026 09:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8FAF6B0095
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:52:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 604831A06E4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:15:42 +0000 (UTC)
X-FDA: 85041861324.02.08F5974
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6738B140012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:15:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XL+H9pVv;
	spf=pass (imf26.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785330940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVQt/Nqqji69kIM5g7rx01djRP/pornxKI6rvofp1o0=;
	b=I7noDpksrTKG+8aCZM7OvkuDFGG5Xu5B+PQV5XPLyhhBf/ccxVnZTt6hY2w9eAjtxBr/Uq
	/ORuQhgjYFIFc0dpacrgzwXMp6VAe/CdIctNh+Nl4mFTe+oNPWgiAVSIovV8l+mZ6l4LjV
	5ayhQY+J3s9ahgHyEAslnLKw+3xyEy8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785330940;
	b=OnB1u7E7j38G9MjpQq4Lvmb0r8gespXY8zc5NixCf1VPqhJrd5wty1Db0Jj7QN0trEaPzR
	SRXoOHDBYNHNnpGkm63pXyhTv+UshHYl5fPWjgD+6vDhHssOA/5h0xRw+R0qeXZ5ormgQB
	fTXtosll1eRg/FNUeReXt06dnGTtadM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XL+H9pVv;
	spf=pass (imf26.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-49ff971e903so1409939b6e.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:15:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785330939; cv=none;
        d=google.com; s=arc-20260327;
        b=Qm+sUC5j2W5mkLmvVVHzFYDv6RX7tDz9J2ebubmvJe5dsIj7EP0MnxeTt7sM4PhzUg
         U4zMHPZezQu7UNvVypETwQ2aYAlZ6jHbUpNKwsWnCMXPZOVjPFJN3XZ+uRwpRZZEDQC7
         EAJsMgopvEg+4PYAW8NZ7mFDiZtlagZbh0gsO2PSDXOeulpLcjb3u+a8y46qS5dqHHWz
         UchClvyu+MPKL7SlnPHku6qqMEIoyyi4OQavuNKCaB3KA+ugSxMAPHuE47tVdQ9gybJp
         8hLQjPH7H+5CyGp1IWn7GXsPQvlnPM2r54IFZ4ixm/3BGVxYb+Uu5Bod3MUJILs2X6tV
         kfyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LVQt/Nqqji69kIM5g7rx01djRP/pornxKI6rvofp1o0=;
        fh=LCcPzoj0G2ko/eyJCpYwFa/qCXtGLWb6AfH3WdCjwFM=;
        b=f0RkNvU82AAkds5cC9rGzaAa7OL/iTH0QD0O3qRquIjqorJF/L6xspiFkwnIdoUWgs
         G2753AooFKncpQxyjL4ucg4RBOH6EEzokFtPuCsVMWv7+6HgtDjHCdONBHF55C974sAy
         eSnZdBeyg1wPulMLFUwjL38kEe9SNa+ycAh2X3gNF1W+BMsiJA8JR7xtjy3QWYMVN0Gz
         PRpQreaqEpsk41483cfCv1bWdjhqT85iWUeuD1NWDnCielI0TLMm8SYLEBAvkXLQ7D5h
         dkgTk4/JnYbQrfb1Kve/AVxgkwVgNiflLXxfkMG4DHkN9vvfCM1/aYg6sABvy8UiIGrO
         5PEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785330939; x=1785935739; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LVQt/Nqqji69kIM5g7rx01djRP/pornxKI6rvofp1o0=;
        b=XL+H9pVv61xtyDMlvf3BEo2VVUWuZ/kMRXXSq18wZd61nvKV2UZD6GICEHjM8njhM+
         O78PJq3/cFbrmXHerFJHTvt91EM3o92zHJMgOEW7psolhinQ7O7edbOK063TjKatnfkp
         7yEUbpcRVZBLsawOsIR19Wnew+NpATmCm2lVYef1VnDJ6PjMtLFTx+axr236TDiaTsZ3
         TqtNoDn2TEntsnk72CcQ77abOy8ACgw6qtuIs7jqPDz34JpQXAZ3w91IgWTm5loJosiv
         ESULA58hJWrLLFRLZUXhjsAjM+x6BssG80izQvkwfys5qh3eDbDUuMyLUzSuqp1AHnh8
         jh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785330939; x=1785935739;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LVQt/Nqqji69kIM5g7rx01djRP/pornxKI6rvofp1o0=;
        b=qG1kScf1bHRChJhe8cKjbU99ybQut40GZFjbWIsb0hZc3EU3v6+oh/z+0bXn/Uotpe
         PnAtDCQG6x/nq/uxVj4ezPZ/wZC3J0I64P5TjblzhOqyfeO3fY1arFSViW/Iugfo9v+6
         OYN3r5hDqtVBEMRrkoJZLHHC9Yk7iBR8j6axetAgPczHbSyIYlTbbs6oyZhUKghiJ0Ro
         s3/3/lxkzxmIHo2zVr720+QsHCZIUD0ynQCfbT1PZ+UQSYjjxBvwfHn1veza0NB/Zb7s
         cX7IsZYpErelxeYk754+/L7vNRQr8TszC629uvbb//lfBBTd9Hht3udewgTjEmBto5iS
         L3AQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq3KMjpr1XV1zRi4RitZEi+L0PUcJEsO/TtWdGT8tIE27jSkH0cd/WLb726klKXa2rC7WiwT74thQ==@kvack.org
X-Gm-Message-State: AOJu0YxQPHTY4phhCc0BJCuzHalA1hlKMVQkewZjNhVBmYBaj2rACNEG
	5rNgi3P+MKE2bDmnYXpii1p8tLxJQA1EsFI4Zl/7AVwEYS/KCSzSWew2R87xn8SGw6hLCuG3qb2
	FudAyZ1XwK85unXxcukbsSZH/QszVYvs=
X-Gm-Gg: AR+sD12Vg2Ww0knsBT6a2xmn3aExNbOQ4wuZR/ibS3q3yMB1n76CVGLUN5b6pK+uTiB
	XCv2OMGN0ohN92SAljGmWY3VgK0zW3Hayv2ueWMKMFxi0jv/0O1B8kEpimO6tOTS44ycpRe46cW
	vE1SPoY2po/dflhjY7djRS41Ey69fA62KJNVKg5jeIrdbD+b4ITJgl0OctDIBg5Cbp1uK1K0hEX
	xYu9WgLKsp7xZa07PlP4kV+sXNETSdoawtsfom9nhE5byCXtUxxZ1mSJGDXN3TxQIL7VSj2zoIx
	JxgTlqVTH7UggGbAMmft/xLjmwu3SoUuSxnW6gzODX5fWFWVYj5UXg//7FN9lQ+urrxnzpjoDVs
	=
X-Received: by 2002:a05:6808:f8c:b0:491:c51e:189c with SMTP id
 5614622812f47-4ad733d5965mr922440b6e.24.1785330938411; Wed, 29 Jul 2026
 06:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260715120813.3609949-3-jiangwen6@xiaomi.com>
 <20260721181729.305137-1-devnexen@gmail.com> <CAGsJ_4wWhvKA=BmPwCrGv06kq07QMP6CKES1mGUnx=HmiDPGLw@mail.gmail.com>
In-Reply-To: <CAGsJ_4wWhvKA=BmPwCrGv06kq07QMP6CKES1mGUnx=HmiDPGLw@mail.gmail.com>
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 29 Jul 2026 14:15:27 +0100
X-Gm-Features: AUfX_mz1TodIEmggv-n_OH9oyqAzpZyOfg5h99XrwfHGTz1FfzI2tlKVX0hemHU
Message-ID: <CA+XhMqzVk2K=NCjsBCvRnfCShizf7vTSB1e3jfadXUxOdbpTLg@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: Barry Song <baohua@kernel.org>
Cc: jiangwenxiaomi@gmail.com, dev.jain@arm.com, david@kernel.org, 
	urezki@gmail.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6738B140012
X-Stat-Signature: dp5gbwamjsmmo68diwtttadj5656admm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785330940-776549
X-HE-Meta: U2FsdGVkX1/X0yQMUidfURbmm7QEkD1kDkXu8Xsmaab2IBEgM5ODDLttF/v1bXLTIVmDZoWnAi32qkyvF1Z/1utSYhGYnmHM0d3sol/HD1axV5ZX4/LRQ5nt8GjdgPOk0FbXiDM6Ei6ALaEwxIZIZ+KPOOCjPE4zNhuxIND2cLdwJRSOl0ODu94gC9YhszbkKs+wZnRBSqJniT4NW22LzW3TSSGA7eKLNx+LQYnc437yv9xoa6ESUmq5de5PX6289IAvViRTzP8A+EQ5EaBYE+xF6f5Y5ODO2+M6VEiQdXyP0gNYy0ENLFMTRbd8DX9j5o5y/YK5+oBVkX4he4YNl6COC1IXFyC8QhVwTFXCaUZS2f2c1dNV1y8mPREr+C9rNHx6a6/cNLc/wKX08mpxTNjF9KEg0HFuzDB2Sw0NhQkXkgL3ZHaJ3b9R/aDDVJRtBsguj82YvB3pN/YrDsQgQ/cD4BgRmNaniwaaq116PNS0/m8qAY/cocatDFrWzoQhp2hfww1HhAw9NKvmlPuDLebsFgEtKwnjOvJ2ZTQfoKlmM45wUGv9W5fe42NNQFES8XDg7tXP827bo5xUAljWz1VoofRkVLH0zJV0lW6pjmhMg7RxguYSUBLEadVGDlwBtHzHkzC1XCNG5T1GGKO48aVq6P1x1MRvkYsUWgBK6sE6o5cZqZtM6F+ZN8k1Xqp8zT2lCWhCsjsDlkMZx4TvN3omTXRS0m+UDdXe/v8BtCF/jGjbdL16M9VN9Zt1g3uZzX4unRdp+nrDwi/prXGL3+7cpQRmHUucA31LTcPSlS8lcjMKkeOTAzQxmtgFjzI3qHITC6LaHJFwy0lxv44rqOM0jPaNrWU+QU/SiMpVHb1eZJ4u8gA+9jwLMbhtwu3dHuLcpecW2rh/t6i/MCnEz1izZJW7e3W/55oAr5bHEszQWu6UQA7GMIuBQprgqlTLUeGMsDXS60rFOfmFDsJ
 p5vf1nKS
 t1KA9u8yPU1BF9iCaZobAHMeId0pfiUOM8YCa2VFZPKZm+Vd8nKxBeA7/pb31YpRva14gp3IZUTgPVbIkCpkNMrBVKzPsjRmDhP4TK9qXyXV3hW1zz7y5bS4e/ehY6axTyp6+r+L5vP8wYTblmWiZ+4iN+00BHUQAK/nLpCBT1U/qbxv4SHEgUc1MUeIWawxWFmYa4n6KfS/HaoPYZYbjUhc1ZIRsFYZgVPNHev5zFycl5yoIWYH4qkS+xuM0TguW73RHNWkokLo/MQUdeb2WCnDs1Dqbotj5rEYmyHbd2fqt/buXlKx26j1XIc3acP3IfJPCBhnm717AGFZITMYCck9ZlK6EktyDjpripS882D4peEn/5NIi4pbPkxAiR0XBdc+HqWmnqDNt3oN/usIRsjBTuEjGEkJf8FDfchE50eL7Lj9dbzlN5y0a4Uk9R8emCbef
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Could we do the same here?
>
> +       if (!IS_ALIGNED(PFN_PHYS(pfn), size) || size < CONT_PTE_SIZE)
> +               return PAGE_SIZE;

Thanks for looking.

I don't think it carries over. 8xx tries two candidate sizes, so a failed
alignment test falls back to the smaller one, whereas here we would
return PAGE_SIZE and lose CONT_PTE over most of the span.

My concern was misplaced anyway, sorry. [addr, end) is always a single
contiguous run here, and addr and PFN_PHYS(pfn) are already
CONT_PTE_SIZE aligned, so every 16-entry group in the batch is naturally
aligned. No extra check needed, the patch looks fine as is.

Cheers.

