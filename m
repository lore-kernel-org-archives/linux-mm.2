Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66709FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD246B0088; Mon, 27 Apr 2026 23:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4D66B008A; Mon, 27 Apr 2026 23:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAB86B008C; Mon, 27 Apr 2026 23:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEA56B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:17:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 833DA8B864
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:17:05 +0000 (UTC)
X-FDA: 84706503210.23.29F44F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B83AC40006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:17:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JA+GnZnt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777346223; a=rsa-sha256;
	cv=none;
	b=DGSa6LogL+ThzfVXYKj47J9A37glu9QeEZZszoqoAUjLNHESw/ESt+PU1cAKOJTsHDuTAe
	ezcANVpU5YzLYNpQp7Ps0dnVty/XnnSU2LGyBPSAOTqlIocGm8I5+nE+QLr8WkP+FqQqL+
	ek4cvEi3Am1ALZlNzKLgN3nZhbbhjUw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JA+GnZnt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777346223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTEZ1HZ1PdRHfsgQndRbtsh7bY4hkpV65+GmJp+lBmM=;
	b=L69aDffjUkjW3MOJv8sFXp1/XFdk75R1nQakQXeXUrC/rPiTrXTi+NaRx7pa/ILJVud+Zx
	qH1s64qevcto0OP5MAPMduzL0N2R8uZXDTGptpmZhDKivdnuTtzJ9qAk6mQovxioM5b6dk
	LpQP4ro7DXWnKLj4abZFbxBnBt3dK1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7D9B60128
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85236C2BCAF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777346222;
	bh=wyw3V0ckGkRkNnb1F5GXlIGScC5WOYDuhH9iKbweEj8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JA+GnZntI++ywISl//G2he7Sf6z4XhwDvYfIeWytJMGDUtt7AFq+ATNvlKhxKoe8B
	 Q20DQweR0Sr0ZJ/FxFjdTPFak1zI9cbIUbNCLTIxkttzgPPRtx3RJp79PXJwd3vL/c
	 WWnuQdXVIPE+1onllLCsElsUI0Zsr9l4Hoywtd5DQTDQ0txmMSLYbc/56wCuAzTjWm
	 HBza8zLJfWcprz+RsA8HMPPbMgglwSyCzG9lOoCzKxdmtlbcu06d969/CT0MIXg/hm
	 UAK5MEjflfvIQRmB1NG1cGO9gHmoP88eqUJXWY8rex6dcUOfnX48s/mXh6vcbuWptP
	 j3pD/8Efe0d2g==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8a08fa355a1so160094266d6.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:17:02 -0700 (PDT)
X-Gm-Message-State: AOJu0YyJRUGLQ90c9+zcrPCIUxOiDtvCxf1NfSiSxM7VOzVs7fibLcWJ
	QGO7/ZRYLbcghGbQmO2tD3n95hR9hWR3JqylLHUHS5P12ittLyzXgYY704GXifrmnobfCO6IzV1
	gaBoKPnkUNPYM6k8uTw8djHFbCVrXSE8=
X-Received: by 2002:a05:6214:4a02:b0:8ac:a6f7:8a70 with SMTP id
 6a1803df08f44-8b3e306a5a9mr25772956d6.22.1777346221843; Mon, 27 Apr 2026
 20:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <fb022a6f-0faf-4742-8934-8a7ffae806f6@arm.com>
In-Reply-To: <fb022a6f-0faf-4742-8934-8a7ffae806f6@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Apr 2026 11:16:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zwrsrKt5NiuN-rYCqJiyjNdv=UssLuf8VCu8xZ+5sohA@mail.gmail.com>
X-Gm-Features: AVHnY4KKjM_yWoA3CDFUcrhYL1bvm0dmk8-MpHN_PetdZebPEYEa2kPDHJNVQVA
Message-ID: <CAGsJ_4zwrsrKt5NiuN-rYCqJiyjNdv=UssLuf8VCu8xZ+5sohA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com, 
	ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org, 
	Xueyuan.chen21@gmail.com, jiangwenxiaomi@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 78ck594wr7mqjc558kd4k61hngjfsx66
X-Rspam-User: 
X-Rspamd-Queue-Id: B83AC40006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777346223-120470
X-HE-Meta: U2FsdGVkX19ZwdzDfKH/zmY17H5zxENSJTY0KLLkf/ebzeh7VVacNxPF0cy4LdSb2Ts3NF0xHzphf1uw4dlH6BO/dmhVMvTP0ouyGY9eOTzGvxie30/h6Ent71LI/sv2K4d4NNHJUK/cwf3MPMTlyNS5Dcpz1V9WzF3qf58Hk/15hVdcNblT3CPVvLrX4Aj22MAuQQIjZz2jN9ZLjhfNChxGcsMwP7RwgBLTF4vXHi68R/qHM/5coybtIc8XZwpQhraHoIvKxyFlcmogv/ER1P5lpsc68A+EQ1MPuX16Mty43f6cGncfBqTiriis4EZ1C63IGH9zT6jdZMeeGDe7IM/7hGmp7YOxDEChg29e0SJ9s4gLGx0zUfrUXLaLGj1z6e9+Ixp9m5U2wLEn8pVTzSqDazjAaT91462Eff1BkKgh+50pRo6M62gupEF5cdkWR6+8YmCo3xlpcBcVtVIMc8T1bZSDJ7P15mMJ+dD5XkzlZlbfm/MWAdisBM4eqKExxN72KujUa/opfTCLCNN3rrAlTDbDssBR8lhbWAI17EOn6EUjOGppX9RlnAqlN8bfc7n/jJOY6shb8bA/qsMkF1wcM5SeAEhkzC7HaM3kwvuOfS6VSDQJdF1/4J6abjSZP10j10j4iEQOjVd63RX/9b2lECaBziNeCzcIT61+RcUiMF6YDFsWdY/9b599GYIXulgbyqFgS2EtZlTQWDp0d3NGPPiNb/JzSEhNPp3m0Ybv3RSg/siuwZ3j9Snwxsd3FWPi7dDwgnBuKDlNtQtmjjny/n36nkjlSXpNmnTbubu9B/X0sdkmobdSaqwRfUU7ppNgUQ5sqYtrsUON+5GcaxXxgdQyv7mmc/kb80Ow5RL8zW7/SqasGVSW4rxanHB6qYHFHf/jPqxpDhp6vRoUMDSQn/e+NMUJSO0O+4GC5o9Le/GhxHqBXFAlsroMDVykCZNN89/8CxnT/qRP5dx
 L8WDfQt8
 skwsznEfwCzmCXCAdrrzarW4D3Shr4VjjPcQOuk7maAW5P/3rAASrh/9AwoXjI6q3/1HlMEsxoYL9t6kbP4zI7aOizGUOKHClDGqUC2YBgow02aVJ/Vii0esOjSoQeBCXpHT/q9NmKL15aHoJdpyfMGGMrh6BpaEEtRPYYiNmPcLZzVNM/B3D8/0RcemqsSmMy1oXMYFf9y2g6V/pMda6P+qOtp1xIqGlGrHvN7jVYXI7yickcyuYVo20MxxbdcxOIY+FZGPeF1ANEXsyO35ww+ia9IbKH5iMNczpjgu9VSxxsFRNLwn/rIdSZ5Hqt6s5Jwpc9hD8Ty45ZNFC891oNm4mhvbUkqm1djg6YfGlZjeWQ1NG5EXVsG5BZ841qZ8ssw77gCY+3Ly7evpNPjcSyjqyaBQcnPIR0qG6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 11:05=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
[...]
> >
> > Barry Song (Xiaomi) (8):
> >   arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE
> >     setup
> >   arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple
> >     CONT_PTE
> >   mm/vmalloc: Extend vmap_small_pages_range_noflush() to support larger
> >     page_shift sizes
> >   mm/vmalloc: Eliminate page table zigzag for huge vmalloc mappings
> >   mm/vmalloc: map contiguous pages in batches for vmap() if possible
> >   mm/vmalloc: align vm_area so vmap() can batch mappings
> >   mm/vmalloc: Coalesce same page_shift mappings in vmap to avoid pgtabl=
e
> >     zigzag
> >   mm/vmalloc: Stop scanning for compound pages after encountering small
> >     pages in vmap
> >
> >  arch/arm64/include/asm/vmalloc.h |   6 +-
> >  arch/arm64/mm/hugetlbpage.c      |  10 ++
> >  mm/vmalloc.c                     | 178 +++++++++++++++++++++++++------
> >  3 files changed, 161 insertions(+), 33 deletions(-)
> >
>
> Hi Barry, have you got the chance to work on v2?

Hi Dev, thanks for the ping.

Yes, I=E2=80=99m getting Wen Jiang (cc=E2=80=99d) to send v2 within the nex=
t few days.
The patchset is basically ready, but still under testing.

