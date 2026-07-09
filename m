Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC707C44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 00:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931106B008A; Wed,  8 Jul 2026 20:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908A26B008C; Wed,  8 Jul 2026 20:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D906B0092; Wed,  8 Jul 2026 20:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 523E46B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:06:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7E501A034F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:06:14 +0000 (UTC)
X-FDA: 84967295868.08.7E58A99
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id C15AC180009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:06:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z3B0BEBa;
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783555572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGyVs/ziq+v8OBPSx6ZOv0f1yGdel9dIe8uNrAG5/8g=;
	b=3QWhpdO8kuGwFmvRp4r0v4lJhZ7UsFPnWp7s7n/tor32U970OxPR2E9RarpZysa28LVoW2
	eSEp6YhWpuv1vlu7hXGcDtBiuzQoRU+9fXMOVFnA22d8jCD7HXaCgLvgoaDYAgnAMFC873
	meGUjhnwq+Na0IWGltktkj8+YMJSy5M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783555572;
	b=Eb28g69otwkPa7IHKSUWJOFuEjvlQuqmoeErVdE2+H0TzliIscNqPAHcKACvTe279RzEz/
	pMtwhXGm2HnFce8/rj0Wcr60URDLwLM6NSdap85n1DkvRV5aawE+sstN8ajP59EpREQLQN
	4wKxIfSVvpRxGEy0MBmPTDXLUaRXutI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z3B0BEBa;
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3811074a8c5so1114089a91.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 17:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783555572; cv=none;
        d=google.com; s=arc-20260327;
        b=Z1CwF9A1iPlmoK2THh8UsRHPZc/zEryx72T930MLvPEfFSuj+Tuq5fQ0rJtB6x7WLM
         VgVBSezM1O1jKSw47MphkdcFirihLVzYamopqnOgfk/mciZeFWR7U4NyX3uL/1YYJBVl
         /gLyEy44ukNFbu3poqbZLQDKOT5XC+9hC4F3gFeNyXTVlCP+LImE72q/niD+yVaXmEWL
         Xj0AYY/mzwtrSDyZCv2dHSlZ20YQpR9EqOyEd2a2OT17SQe+QuhjL1maztYbuU/lfYVA
         3tSx7OPia0T+qpPVvUkNRKjgbQtTTYYl426WdCJ89Nr2UzkaDK5UXwravlLSRqe4SFsc
         TMNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=LGyVs/ziq+v8OBPSx6ZOv0f1yGdel9dIe8uNrAG5/8g=;
        fh=nAt5RJWIwXkDXKYKQ3+hLpHGk8KIyEe4/I7yv5hym1U=;
        b=Ihwv0NWm4h4gOaQYXTtzVDXKv2hiUWNMwA5X9v01+X9hnvCo9VNzC8CkfJE7eiUkSb
         3oMaYF6fU9qKWYuZezAeOGdRU94iuUyg5m6k9iIguj0Y7FmTKHkUhbu/RpeAGe7EJ1PR
         7oLQiZKkThS+8xwzF/UIGxv9TqyFgDHeCyg7TxP7pcKUIvFtLCsBHC0gKesvlzRH7me+
         jdBsxe37TSAJyMyS7+giduUDOADTH5AFImwqzsvt8dhBim49cECU8tgwatwCkc86QhuY
         UqrV9hW66VBRv011ToRaGFdPAQyTQPnUmStrph2O0MMOO+9ocIIVnaF1sb8poPzSBmR+
         jS4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783555572; x=1784160372; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LGyVs/ziq+v8OBPSx6ZOv0f1yGdel9dIe8uNrAG5/8g=;
        b=Z3B0BEBaOhBQiHA9yxLDZa6PQDHLKa1jt+FDncSKpha/YlS9DENqVck4uEUZ8m7rf8
         WbzittRDhJLN/A+7cDYcyabf7i9Lo8oHNprkqFbCJpWM72vGlE4jJPCCdTj3ki+r6tEG
         Iw/iPzj9eyZ8ikDRyivguBjbSgHivq8x7MhsCYqmIygvHtxyKrfC+vQauryrsN/fu6cb
         qwE2wc/RHIi7JtV5wpeobTEo/0IIxA1Yl6Z0DPgfmWEVW1xPeCOITXNYKGnBUK1fu30+
         kUHn0PLXdTLH5DLZHXP4BT4x/Jvz7ac99wWrbbF74M9xNFrIbw7fts3Mk+NASh5rdfnc
         CHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555572; x=1784160372;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LGyVs/ziq+v8OBPSx6ZOv0f1yGdel9dIe8uNrAG5/8g=;
        b=fROjbN4tap3IvHJeNF2kSGNREc4jfK7Yx1hyFMrbCYBNyg168RE5znR8T7Da53eGf2
         APCgCXkk+BkyOv1IXVMCLHI7pc3TEJGk1N6U+p3Z/r1sG22NGuW5pRAmtUClv0OHZBpZ
         yfoA/lldAboUSh751amZ4tTFNlTUF/tz+oG0JfXj7hUCHI1gNaAp64stUwg/9Naytron
         sP5W5cV1oalvZbsRRAKBEoVZhbqP2J8stON8T53TnYGdW5icEFSuEcdwBDoEnb/kYdaf
         PPLoA0ni5pdDfQ5AqLcg99tLQy+jMWTpWzwiihzKT7QFCIlqvgn3jhkVzOgKjixUtIuQ
         LL1w==
X-Forwarded-Encrypted: i=1; AHgh+Ro2kyUAib1cq8nqCm7MUWtgr86adfh5OLxxsTFsiSZMPfpYylLhzN46ZUFSfpvlzqP2lNtpT3MJnA==@kvack.org
X-Gm-Message-State: AOJu0Yyo4UBo5Q0BOXgqEqDSM/n0bNhamqGu1MkXHR74gx9UYhHTgA/M
	F8I5dtomUE96EDOmCEBE2AqStzZFC+6QGDppOHPzl30JUlr9esInIpfHhg+jFxgFz/VBSN+W2bR
	4yevnAdtErJQjzaG0MWCPb4fATFUEKkUqunSQ2dNY
X-Gm-Gg: AfdE7ckejm+FOcQmU7q499f16tt/hevXVKqW747XON0LpDYLBK26pjsNFwvlh72wTMm
	F6kff4Vm8W4d4UL0GuTygA08s7Y+wKYmB+FJzdfsBl6qkNYE4XK1SzdBLE7Z1FGqD2MO9z96vH5
	AxE1zv83M7MiPO1PtjEgBOp2oQSxX7qPTJSlYEx3dOlr4rihxcNMsh5T5mhDcuXk+b5hKGYzIOo
	OKA+p5rvNvyiL4RoZl9SJFW+mp2iXKht/v1c90+/cQrf79IZHiB8bxjRhaXIvBUeR4Mc+d4W8oV
	oTcZU98mUL0JO99NrKvLrXeTgzY1bAV2zrmNsVvWoCMq8Mr2LjsNq44wR7g=
X-Received: by 2002:a05:6a21:1f88:b0:3c0:9c19:b27b with SMTP id
 adf61e73a8af0-3c0bcce9940mr4979424637.73.1783555571036; Wed, 08 Jul 2026
 17:06:11 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:10 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org> <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Date: Wed, 8 Jul 2026 17:06:09 -0700
X-Gm-Features: AVVi8CdcseowPqFId5ObGoqB8gTqCLO4QEXGH1ZjH1-pjTCLGI84NpwTLe_LrAc
Message-ID: <CAEvNRgEV9VkWHULS4g5hVHu3T6=YZ89HJmkv6rS0+hK=5UFu6Q@mail.gmail.com>
Subject: Re: [PATCH 19/30] mm: use linear_page_[index, delta]() consistently
To: Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten <hsweeten@visionengravers.com>, 
	Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, 
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C15AC180009
X-Stat-Signature: y9mk18njsz87wywkj7iwboqycxya4b8d
X-HE-Tag: 1783555572-867096
X-HE-Meta: U2FsdGVkX19rw6nJ4DT1E3Pt0Mfb2RfhiJ91rrVWM01BtZCNPky0z54La85NLVVCC99VxWzqCCfruglt+s5MmfLhZ8aJruImTMFQJPkDvdXwtUA/5wJE4d5CsAX5OeosRUX4TAogNDczDzFaSBtxzf+EJm75EuPo9zREBP0W99BKGr+vgDrO679q7eM3CfLKzKT7oyQH6QVp5Ntbw+m/KPAl//hWM67U0hcUTDB60IGFpVNf+DaWAo0kQREgyjCRTz6GBEAYeafWsz2nhe5QQSbJ7BFYRUDFlU8nDBaqp2fjCYHS5cHD2AjsMTlN1I6Cz2Vt33NXVcng/kexr9HLdqZjPX4LYDSQ0V/eLpowUrHI7nJDs6JF2qad0sEMa3rQIHf0vu2+0S8+DxspB93b4sgNRoq4I7nVR3NErsDOnDaaeo+jExvLvC5v1GrZ4860yp8rjxJGc9+bkk/udrkBH9kE1aS78agXwXgB27nGrY+SLoXpEmHNq6roNJA1T/+2GNRlk4lNinLErmP64EY29vF+uVfEX684MOfxtHaptF/7+optxKnytGHz3Sih4BcuNlMzc/VA283VYxFwOpz9bHXQjJxuH+BG72o98+zZbtde07jR4KstlAXLlF24sM5I3JDjKLq+0Egp8rk8CxslyedbVHe+sK4y5l48zyX0M4tvCpSteo9aGBW1v1GByBNNDQNZeWtfwP8DnFlODrRI6wJhZBQDE/qM9GnZIcaAPrSxURuI+iKvwk+WSq1Q2vxbQCOTXnwoDxC18V054HiTgiB/WH3bjs0OREt3jzuFyfiJHXjJGMCEI4PQ4BCOwdeF63vtfN/AKK7HGWzwEbjeNUtnC9KOIxiQ37YqeMLeG7oItRrrehjO3DYW3UeC+32mFMOCGE3jWNr40+LHe4oRgsfI2fu8z42X/mcgDOyKVwZFtDpD6n3Dm6Nw0+l62UGbBpZQWIhkOsu9c1KbmIN
 HOQc4ojk
 6z5oAqEpte1PUXaI21hOfWnQinNSPuN6oRXVuFvStxQyz8MXzPEvSmAMzJXUDsSijkkP2BrnVJOn4cGzuXGK1ubhtBV71k2nTvDWXI8eQruXBEM6xT1LibzAIIxuQAyg7cVAKXZjAdVcPP5PuXpL9diFti4AfG8Yd/gmTpPKr6BEaiWIpv9hxooLxCH9jX7i5qCNHjE7ExPsMfGg7tCS/wVmfaQa4osuPaO7jaYMf7UZWZX6kUYH1x0TQRsJ1p3XOWyHxr5rF8YVRGrkh2dgzPcqRFMgvBmaJlvJ1CjbBlQBrlIjBQeevBKsGdzFIbX1FO1FWr1EVNE3vyo20kIcLT8dgFF1qeaSAF7KouR4kBEkuteuuUm6i2G7UWHZB4EJ6kElnW3mAOQWm2p321MJWqKdJmx8nK9ChLBqYe+OQgHl89m/ot7yJTXpcbVj0N8UFn26xeqiRLSl5DgMOWNZsySkMVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes <ljs@kernel.org> writes:

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab6..f0e5da490866 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -440,7 +440,7 @@ static int kvm_gmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpo
>  static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
>  					     unsigned long addr, pgoff_t *ilx)
>  {
> -	pgoff_t pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> +	pgoff_t pgoff = linear_page_index(vma, addr);
>  	struct inode *inode = file_inode(vma->vm_file);
>
>  	*ilx = inode->i_ino;
> --
> 2.54.0

For the guest_memfd change:

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

Thank you!

