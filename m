Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F15A1CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0832E6B008C; Tue,  2 Jun 2026 18:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C946B0092; Tue,  2 Jun 2026 18:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16EF6B0093; Tue,  2 Jun 2026 18:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBC876B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:29:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40F45140193
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:29:25 +0000 (UTC)
X-FDA: 84836415090.04.20B4F30
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4D864100003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:29:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FlkK1pyZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of memxor@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780439363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCD4hCc4XJ9cLp0cEeWugpV7A+Kjg6CRiPP8rloQDrU=;
	b=DPU4YpkRHehyOUAiR+Or4Gj3aMO800Sl4aEJ4+Zj4mi6Xa+i7EP+n9vJHAS6gZ/gbk+i0q
	UC46PHHvVwo9pPh9FpnJ6G6JSdzw4eoUxy0U+F/54LNP2X9/sjo1AS9aytznn7ylquPlvc
	x+oFzV1KZQCSXRNZDGci0Itk2LbbN6M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FlkK1pyZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of memxor@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780439363;
	b=eVDFhrtA5txx8murB4KWY9s7/1trQWUwI8FIUxaBHIm2wuf8l8kyx2H2JzeQ0rKBAu0Hzd
	NLCLpANHCfhXJteSzB1xTzmwDLiZy96SoCLvoqWx0dLXoGI9ILBu+OR71+zjkE7a43Q9Nl
	qGjnkgrep1tE91rjaI5GqzTbVwEMaT0=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-490a7678b2dso27019555e9.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 15:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780439362; x=1781044162; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCD4hCc4XJ9cLp0cEeWugpV7A+Kjg6CRiPP8rloQDrU=;
        b=FlkK1pyZxT6ccPjlXgCZPU12LqGCv1nhF/WLWP/uWYPk639My7hZK+8lBunksNWwNl
         PnKnX2Z1f7ozCMDpHBUP1d7NpzbR7aVwVDdDAKTtTS74rD23GHK6C5XgZgWcgOYUJ3ys
         Lf4mOhj0jAPK0t4q9ycb9kM6QxO4MTSA5btePwWnIJwLJ/1lusdPXsQuBZ/9R94osSdB
         t/ztY/kX8aWY5WgLlkTcQjDQzur0V+Ex2R2Za0z+jKMzbAXq98et/o3aK2Lf4oeDthcA
         OZmU6ISogAF3URFWUUecO1oICLoiSELH6ttEeOk/jhqngphhFT5uLbRDGHJo78YIYk4m
         iVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780439362; x=1781044162;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uCD4hCc4XJ9cLp0cEeWugpV7A+Kjg6CRiPP8rloQDrU=;
        b=KEm0FBox+8sMwcyFNaNJItMPIHYiJk+1Wvkg377MTLTSDXJtzqe/pRVCisM8ybEVic
         8JujGhw4XmK980D6gDOpTGiGz0Lf2MiaCcxlO+uitxcKOS2nNRoWo5UvlCHgB+IZXVcC
         5lNuFomSqqYJXjTeTXtIkA44Zzx7Pt/PLpBP288epx4Gq5EXaMR/IhzobqNJd0SoRNX4
         dNU/8Up1lG1OWLly1oMInV+4lvgFKppaxkInABMk6yEoKP2GNopyqTY+af+0kg017X2F
         A8DmO0jkLJ4DOfexk40Q5Rf/wDiU8MlKJHE99bVD0Q1Ik5HkDdcDsifTq80eG1FnV437
         ZeGA==
X-Forwarded-Encrypted: i=1; AFNElJ/ByAunwbCouoPqHuLaaNrI3q0xIRSUgBBjreT8qOTrmzcGpMrKaKL+zzrulX5gMRBDCFSswZttig==@kvack.org
X-Gm-Message-State: AOJu0YyIcqV6lAKTCkYZhxf38fihxnmLVvQK2qdG7WZmsnzalvhiOj2P
	aSCRwTqK6K8VGw0rRDQGP1DgojKyQ701kZfwxiR3LkhVQ3QDsi/lIonB
X-Gm-Gg: Acq92OHwMzF3sciv4Os8BwsARH/+qFiS9f9QrUwrJOgPUwvDZrQzvKVc0t3ofHOtMjY
	o3cVhvt9+2Qgv/xCIvBgVP0r8zsd72y9ixwnjEkfADZ3KZVBHtSVDwHAy83lkkRSzUPfN6XhWI/
	062/DbbdPRKSAZnv3nfQsM6BPhQN68zi18DH7M6N5fKqhpj4VRZZprsZkr+TAtx82+CE1suQkcR
	4jzAjXaCxS6aT/cFH+vSrmIKAI+7m5LApyyi34rf441OZXu2vJIIG6Ym0IYvIvTcE0rjQ0gKL9e
	zNzNR9FS5BSan5qQqHAgYPQ27Ozt1yFn+q3lyywXUfjxhsUgDccHNQThP99Wypdf7X6yUo2QgqX
	nIiOtALt9Iwg6tWULhUjITc/UI3axRweu7fAP38+ifxPpg8aak5ecK7AX4LDjxJ8S4d7iBGC4YA
	/f/UJj9k4JgZiVA6s6RkL3vx4Xtotg7RERJWWa9ep0vt+2bs1eJt0ziZ5YKSRb/rgDaJ4dN2xml
	2Jl9EdpomJwfwnZ6m2YmmL5QFLZCsrlhz++6huEvzIhT33UwwnTFaW9D7UOaDLp/+akHy/BL/AN
	JyMbJY+eHQs=
X-Received: by 2002:a05:600c:3495:b0:490:3c90:2cda with SMTP id 5b1f17b1804b1-490b5ed636amr10835505e9.20.1780439361703;
        Tue, 02 Jun 2026 15:29:21 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b612f92fsm3362605e9.15.2026.06.02.15.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 15:29:21 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 03 Jun 2026 00:29:20 +0200
Message-Id: <DIYX2UV4C7W8.212LVKLCI8WG0@gmail.com>
Cc: <peterz@infradead.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
 <dave.hansen@linux.intel.com>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <rppt@kernel.org>, <emil@etsalapatis.com>,
 <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>, <x86@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Replace scratch PTE atomically when
 allocating arena pages
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Tejun Heo" <tj@kernel.org>, <void@manifault.com>, <arighi@nvidia.com>,
 <changwoo@igalia.com>, <ast@kernel.org>, <andrii@kernel.org>,
 <daniel@iogearbox.net>, <martin.lau@linux.dev>, <memxor@gmail.com>
X-Mailer: aerc 0.21.0
References: <20260601183728.1800490-1-tj@kernel.org>
In-Reply-To: <20260601183728.1800490-1-tj@kernel.org>
X-Rspamd-Queue-Id: 4D864100003
X-Rspam-User: 
X-Stat-Signature: stq6nowiic3cnmki1dfsey5ask9ihhus
X-Rspamd-Server: rspam09
X-HE-Tag: 1780439363-951638
X-HE-Meta: U2FsdGVkX1+P22mlBRxP78JnVWc3F25h6P8W6zDnxc0jlulEsxpfr6uBIM8oyhtAH/WtiB/xvJlcgKlcRmrOZpmWqgVRHaFGLzY2I8f6Qyk8wgSpR7PYnsdyLjNLi3fX8LGUp22npCWXpsCYv1wz7R5yiuRk/X3Ha9y6L3MN8Kexa05YPFiU1YELDCRiYRMcgGRQy9c6W35mbbfOD1jORJHBGgU+ex9z7mAGWZUOIdH/5brJf57U3gvi6bK9kQHKIV5bFdsnPnopmpbqdPF5na9q4pvT3axY/FME5BmLgcEyZIb/uVgxoeYhfzY6gRwDCf2VSLk6+sIZMjHljqTUr4OVcjkRaynxkTaMSzX9CcRJzPg/i76c+ifWT8Kp1vEb0cxecRSAmlALZi+idWtDrIxUO1CX5YxL59Hwyr3v1K8erejWrIc0mYoBcZSWNMnyecKnyAa2YliyR7LJzj8wx7MxhMg6qZs2Bd5ELIuE6fYBcQqBNaiAWyUyytqDhqamwkZkbTdbYfKDpVGwVASs6pVQiCjTsXyPqzgDjWie9bIchkZt5A36WnmtwH99iCAcMj1bKkS6rU1lZTj49Vsvnh0BAIt7O5vPcyct0oCaJVqDXK4zJ6gh+ntuxKRaL+zTe0eZ8lH+2keC8NCM3qeaEFHEuZNgcFnPw4ZXsdJXMa4JTPvZsPXTMgAzeg+7NHPChda0eBBn/N7+h5GBmmyRKkwotKi+dxpqOYvOqiEAZ/Bcn4RgTZnkg8Tqsoxh1vdJaA+uPm/BtMcTcDPv7Ilas8nIIoOfEX/YF9VxG6O/At4hAVd9XMvanXwk8nC2bstZXQugfsZOXDVbZfyJxNwIKeWjBNPN6KCLDuLm5ibmcyiQr4Hl4VJNkQ5y2d+impWjAkxFP5lpF/5tmr7C0yL1GJ4JlqPXJnu1Tglo+K8/g+ZxfddysCSen+korubxLP4y3mLNAPmZmSpJkmEfrDC
 glcUo0+q
 MiQUxKVd16k0UpaOeiwKhPtpgUr2wh9o2iJYPeyWOj1XEGYYRdbZdGgzI2HBBhYyAqrOylOZ+92HQ8IvOgq66ERl3peqEvt+ygtwpBXQQ7sV20SINIX1wsUlAeAiyoIKVbvwCFiWAB38dLxXdadG+VYKF4K8cCIItMgPXgZKpjYC2v1NDhZKtfwsvYRWEKVy1gr/7tB0dalNN1RxIE06+K8b/tRR2jlDkAkoU3x2lFdthcSFmxyj4VMEFtQGfFp1Ip1S4bvum0BQL/fEgoTyvKnjNG3UrjU/uXrWektNym0C5NFhyvTiukxtslCO3sdtd+RN5L0TpI5BbvsFeMFraVwrZjbV0qlzSP8UuSs1Pd/NpRDO26G2eYEQELMliaukeNctWyYEzx8yAINMovrGZv4rOresI/x5zAu8mjEHj1eqdhErg4RuuDwQi0WnBVkncjd7q7FiD4LJZbp9JFiuoI/vI83v3OBoQLb16H8EEzIMb1UpTv9Qo9WboEDaOXYprd6kXkGjXSCov1sbZg0pmQDhnexL2EBnhYaMbUZvkGUuae2othgFfZpCYK9jlUndyafOmuKSNPYDpU56T5VKVweQEmUlZ4MpOCg6u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 1, 2026 at 8:37 PM CEST, Tejun Heo wrote:
> apply_range_set_cb() maps the pages for a new arena allocation and return=
ed
> -EBUSY when the target PTE was already populated. Kernel-fault recovery
> leaves the per-arena scratch page in unallocated arena PTEs, so a later
> bpf_arena_alloc_pages() over such a page hits that -EBUSY, and every
> subsequent allocation of it fails the same way. Allocation must install t=
he
> real page over scratch instead.
>
> Overwriting the scratch PTE in place is a valid->valid change, which arm6=
4
> forbids without break-before-make. Route through an invalid entry instead=
:
> ptep_try_set() fills only a none slot, so the PTE goes scratch->none->pag=
e.
> On finding scratch, clear it and flush_tlb_before_set() before retrying. =
The
> new flush_tlb_before_set() is a no-op except on arches like arm64 that ne=
ed
> the break-before-make TLB invalidate. The loop also copes with a concurre=
nt
> fault re-scratching the slot.
>
> Arches without ptep_try_set() never install the scratch page, so keep the
> must-be-empty check and set_pte_at() for them.
>
> Fixes: dc11a4dba246 ("bpf: Recover arena kernel faults with scratch page"=
)
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> ---
>

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

