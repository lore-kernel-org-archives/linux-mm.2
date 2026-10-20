Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516E260A260F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mukFFgob
Received: by kanga.kvack.org (Postfix)
	id 582A46B0181; Tue, 20 Oct 2026 14:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C646B0183; Tue, 20 Oct 2026 14:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41AAC6B0185; Tue, 20 Oct 2026 14:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8886B0181
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:12:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F9731C36CD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:12:21 +0000 (UTC)
X-FDA: 85343799282.12.2020D90
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7229240003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:12:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mukFFgob;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792519939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDh+Gx4zWL1eoJPPpMyzufEKMmJDNsByR9q1z2w2fIw=;
	b=nOUze88ncSNsvgGjtrlTwcK4dZ5HVNVpveFsrAjNoQBB7EG3VPvSQhn3j8pfdfCQPSrIk5
	Sj29oP89AS5NtxGS/OrtpIXgtfrigkOcaJzmDl3kfnVM70JRC8kjIdrAeqg4ycGSfooegb
	1vjlOI+dMcrmH5/ZIo/wPcTB17GB6ZQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mukFFgob;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792519939;
	b=UgkY17F899vdo/1H7nb2y068jVnlDs0gZ040XnNi3uJ0BGvKhcB3WtyaS2PHhf4exYJedp
	9xPho5f10QRBZ/yR+XRUExXbHDSnb70zbcfaZrlvdRpiI/VUrrh3EgNJL5bzpV3yAZGuAS
	A/mqPDQQFLrw+b5207mL/8tdS1KghUE=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c37b612635bso479649866b.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:12:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792519938; cv=none;
        d=google.com; s=arc-20260327;
        b=iWq2i6Yne4WA5Zqsgks1Qw2OLoFXBkVLecXHXJ2YYk4X2AfwX/NpoWSWeRvc5YDZFn
         jOi+aNPNIwAeV3K4RYz2HZbBebVmS/kwC+uDbWz0hajpE7UDYljEQK1mypaQLHo4PK3a
         K+fM6vIb0zZC7pbmxZARCZwCM5dm6cIPt3ajwhzt3IUgkEpKgsqPoio8cC4g4R9NAUH7
         v6qUYtrNt3VQCCMjtehV1nxq+HhGX0Hsl6PUMWDtDMy9azm705oHIDvlrP9w3AhVCIlW
         Ygk63Gygvbp9AY1w00CdlY8H8Vh+2CG+YFz48Y4PtzixDHX67zM1cX1RT4PcSV4J3yha
         3OOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wDh+Gx4zWL1eoJPPpMyzufEKMmJDNsByR9q1z2w2fIw=;
        fh=Yu6j9kl/Ie6nngD38vWZKXYJR40SCEwv6II8LfKualc=;
        b=JJTZ9rcylBqwCyfkXhlXiV39n9sjmxcESkIckF3AstoirbA/6Mbpoa6zYMX8oEtbpq
         HWalsnFLTfQaRtclDnr06P3PGZUsFO7Fw9zYdndpAf29x6BXnoWY3+uM1khCPmedJJOG
         W4v8RPdS5ywRUHOuYYEp+ocXyyE7bGHRtSqLGHZiNGNtbgroVZ3j2Jz3AJm0RksxVC0e
         48s5895MfnzZNmiCGvheWnHQbjL9b8u3tvr5Iq6UidaJp9nGH1pTXKgPll/LxW13lNCt
         DYgW1Fqc9HC30rj/iiyeYV/3xQyo/fu/oPRep84E0OC8tf8q4HSIWggCJh1ci5X+gwc6
         CrRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792519938; x=1793124738; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wDh+Gx4zWL1eoJPPpMyzufEKMmJDNsByR9q1z2w2fIw=;
        b=mukFFgob2G4bLbma0E6J5AkzVX5HdZhYODs2/cHxRKqGOnXnVsvnMol6oZMajqh1Pk
         CFPQJLoxyTX2X3y7M00QozdfK3NVS7wHLQZq7fQF8xfjBH4LYgcqBsPTpAlWCTHlYbAU
         Pd20N3MnkHL6J/ih7Ro6kJ5j92+MmS/EV+ujiNzbBWCM5GuFqucuDO8lomCVm+4aIarp
         8Gk3fIV75NdfZKAJdjRVB/kBiy2A4mHG85hv/pFRCnqwrSOM5eD06Yajcdv4zQyQ2Wlu
         a6qCJTmeFklWWNwiWIf8ZctLiKHLVWVlh6V2uLM/hghcmb6wGBYLlNtNdxzMGI26BT3k
         Tvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792519938; x=1793124738;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wDh+Gx4zWL1eoJPPpMyzufEKMmJDNsByR9q1z2w2fIw=;
        b=cfX1GmTwCVKh9OrsUSqGDJe/bkEMTVnUmobTLh/9xsE5JvFJptfi/kLV3CMDmio+A2
         6arfcQKgUtpn1LHE+paJh2P6EE0jOHxLpaSEx1YucVBMm84gPKeNQsQfrFPLcko6OAxT
         aOzSh3euVXk6FKYTS/9YdwVY5m8G6kXxHd15q7ue39/RsBqcXIEvGarzHp6wL5Dhqdcs
         oTPcvd/evwXE8T1tupuvXMkePL4K9Hsxau4Ab5bJhvPknp0SbccO3U7PoarpVVNmNaoC
         87HRAuVtObBcDG+CkZNaI/aIQ/pRnbSIUbKbZ2DjM6yZFwpy+GQ6f2FrOs2KsiZuF+fR
         96uA==
X-Forwarded-Encrypted: i=1; AKwUvByUq9PAnfGn81EtiCMTCmwUYCVJizF735sNFZTIocJOpZ8iNNHyaquiiK0nglEpUdER9KSiBi5blw==@kvack.org
X-Gm-Message-State: AFq9FYLdSiU1+7juaB/IXdL3jjG3vCm8qnG17uOutsLi/L+d88YqVanH
	KGNJ6iOAMVsv+YYeA7WXSviRVsY6uXN8oT6+C7vF/4SQ3/qF/GL8pGvnB5csF8T7Hd3oRv6ecId
	cInrR9JIm6r/IEYH1VOA6phwXuhmpuEP6rER5JzvG0w==
X-Gm-Gg: AYBFou2YYKyrrZ/U0rcbzz7LblDNx5HSNebjAxKvmsqF5cTqZdNWmLYSlzbdaSofT8Y
	kfHrRhlTB2bAgqfPaMghQjHBnvmzmgrgVdb0FBZiLxHW+lstJNEGa91JTbIGqcsq38VkQ4C/Wz1
	43BOH5QZttImZVjsv9liNf8F7EuQ7Zd8Bh96DBDSy0P3an6xntV/uAr8qc+jxtw0Xe2g688IFW1
	Z4lFY7OAeFnUQUwwTi8rZGRuhvbJn/Q7pgG2b3DoklG8WngH6pUi7wqAZwZbw+Djt88ugP0QNyX
	16mH2YFfGVA13byM0bpL79/f5kdZRVgIo0XhKq6osCcQa0lN42eR9LTY5xQYURxDVdggBpmR3V9
	FMUEctn8qgMNO
X-Received: by 2002:a17:907:9483:b0:c46:7645:86c with SMTP id
 a640c23a62f3a-c4676450bc8mr47938466b.47.1792519937953; Tue, 20 Oct 2026
 11:12:17 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CANGjgdkFAK_EF-z64cyJttAOS2gqcJuM9jOAXAXOeio6h3wg=g@mail.gmail.com>
In-Reply-To: <CANGjgdkFAK_EF-z64cyJttAOS2gqcJuM9jOAXAXOeio6h3wg=g@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 21 Oct 2026 02:11:40 +0800
X-Gm-Features: AclHuK-a56hhk3GNOqdGt_ccV_P4wvltV_luq0BHFJPtqBbWLhDlh9fkskaTQ9k
Message-ID: <CAMgjq7BoOTKxZEdcwnHAkuAZLzifaAD6YpoDAZXZsUx8oyN+vw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: preserve physical order in swap fallback splitting
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7229240003
X-Stat-Signature: bahxzk83xd1p6968ibmw1t41mxuzuqrb
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792519939-165174
X-HE-Meta: U2FsdGVkX1+zvl7wPqaahUHH7BJjwHDJZNYg9VANOZqjHO4XTkZDXHHDnPo8aHq22CMltShCAVKrHXCT1IuhuRryDrVgQG8UFelW74OtC2srPoA/v2Nz3R4ekgxT/IhkSM0TqwlEzuZlg+c7l2h916RQEBwgf1YW3VGc3JtlGuS6w+52qDTemqQliWvWaEFQ+GCE481+vzMZwtDzuyqFYKrvsWO4oA3yutC1Y8CQ2FUcdoN7qaoyy+dk5PN8IwRjU+AlUevjgqE+/rnq/ntBstXl4AHvr7p1OFM1I7Bi1udKRTbQ52ssn5tROEIKLmGsq8pdneX3ICqVunRBoL9/A2fbw6cQl87PHYiSoGi/5as3t/Vnv/rNzAf0SBEmtmdU0XYSW25sean/T9MkpuCrpPDEk60Xt/nlpY7GVjNTl67eft6gGZsa9x1s247V5BkzcFOPdb9V0MTRrpJHcxwb/ZNpeoVLaynY47t4KTBZuZoS/bns9+o9c5tFtwKpusi6wAucQHynQAFucbxYIli1fsJhJNdM8M00xhRb0WyPpAhhUdp206/WYa4sCJdnImWzawUKozJTWp6ZbDBRkeIfWSoYpSInyWSWGn4Mnq4HKyN2+XxKTK6IOLSfAe/1774+r0iDU5CxlSUgH8rzfLs27BjJIHuPckw0IYkb1FJaukZjXN5gHfNyGyQup0elgIUJcVOuPKdC/DaYRLwMuGoti7VR91LMwg2odQd+8O/tifQXtc3idWIQA1ObALrxXiIBf93Q6ytR3wEc7JYBW5nis21jDIdKEjAvCzsPSnilF6W9Uz9uBtyec//9tetTBZq1MhRtqJ7/rDswWDSmJoUbmnUAhKO+If7Be6i7/eSsgXm7cyxl+/dALInn7JDcMcKFJP6nnq4GvNw4GeuN/ohu+f2s7IbDkv3JTuWDk0dnax7nFJjfxQx/Oi40cwpQiu5zQKskkI2+CTU3uuWMO72
 JOY7L6yH
 9Crl4Vnhk5f0ssDlU2s2jzIo+sCmnJwTYazctLlSQ5/b7rp1CuFWNH3+YMI7RZNPFeFlZ/me4rIwZfH4/Y6pe4RYDvZRhZ6DDXPlU5LiPNRil1Iy7hSMCyI2x6r5wLn9kYCs3MPfURpnnrQe1Fw6b/AqpkoCLF0nBs1yqak7D+Woot/kQ5SAfVby5WKvlVU06KcT+TJTjeb58vAJCZkHsSGnPsbk5+dfsfxKLsXe0I2+wdmQyExbjxmEvjYGLtBwXg36eE5BoZDecd+QyPifr5WVd4ohmaMaaioGxQClnGO7xUJGMdbw2cEdCj9AS+xwb3kP0LPhPyyVxfWCVVlCfqOf6XBd6vJK6jptjfh0k9XeTXjwE7l3h/2Op1YX9gE71nX7Y18jyo7cZa1gXDBc7deoIXdrqvb0/PEmGZqPrjZpFVNqTB4q3YKSxEjjT3+1ZyI0D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 18, 2026 at 2:39=E2=80=AFAM Chengfeng Lin <lin2530632123@gmail.=
com> wrote:
>
> When swap allocation falls back to splitting an anonymous PMD-sized
> folio, the new children are appended in ascending physical order.
> shrink_folio_list() consumes its list from the tail, so it processes
> those children in descending order after the original head. On the
> tested NVMe/IOMMU path, this prevents much of the DMA mapping coalescing.
>
> Keep this ordering change local to the swap-allocation fallback. Collect
> the new children on a temporary list and reverse their insertion into
> the reclaim list after a successful split. Leave the original head and
> existing reclaim entries in place. On failure, append any children in
> their original order and return the original error. Other split callers
> are unchanged.
>
> Assisted-by: LLM
> Signed-off-by: Chengfeng Lin <lin2530632123@gmail.com>
> ---
> Hi,
>
> This prototype reduced PAGEOUT plus cached-refault worker CPU time by 14.=
84%
> with one worker and 13.14% with two workers in a synthetic 8 MiB test
> starting from anonymous THPs. Is this reclaim fallback a reasonable place
> to preserve physical page order, or would you prefer addressing it in
> the split or block/DMA mapping code?
>
> The patch and both measured kernels use mm-stable 2967f3ccdb5f
> (7.3-rc5). The machine is an Intel Core i7-12700KF with 32 GiB RAM,
> an ext4 swap file on NVMe, and translated IOMMU DMA mappings. The test
> uses full preemption, the performance governor, turbo off and zswap off.
> Workers run on CPU 2, or CPUs 2 and 4; the total size stays at 8 MiB.
>
> Each cycle fills and collapses the memory, calls MADV_PAGEOUT, waits
> 20 ms and checks swap-cache readiness, then touches one byte per base pag=
e.
> Each invocation repeats this four times. The primary metric adds the
> workers' CPU time in PAGEOUT and these cached refaults, then averages it
> over the four 8 MiB cycles. Setup, waiting, full data checks and cleanup
> are outside this metric. It measures CPU cost, not concurrent throughput
> or storage-read latency. The extra traversal of the split children runs
> inside PAGEOUT, so its CPU cost is included.
>
>                        Baseline A   Prototype   Baseline B
>   Initial THP, 1 worker   3804.69 us   3243.69 us   3812.94 us
>   Initial THP, 2 workers  3978.96 us   3445.82 us   3955.02 us
>
> Each point has two warmups and nine measured invocations per condition.
> Relative to the two baseline points combined, the savings are 565.13 us
> and 521.17 us per 8 MiB. Baseline return drift is +0.22% and -0.60%.
> The two base-page controls showed no clear change. All 108 measured
> invocations, including controls, are retained. This is one A/B/A boot
> sequence, not evidence of the same gain in an application.
>
> Separate non-timing checks confirmed the changed page order. Both
> kernels submitted 65 BIOs per 8 MiB. Within the observed PAGEOUT caller,
> the same 8,384,512 bytes required 2,047 IOVA links on the baseline and
> 64 with the prototype; these counts exclude work outside that caller.
> The checks covered data, page state and cleanup on both kernels.
> Failure/partial-output handling was source-reviewed and checked with a
> local list model, not exercised by kernel fault injection.
>
> The reproducer and patch are attached. Configurations, measurements and
> review notes are available at [1]. The numbers above are from this
> MM-tree pair, not reused from older kernels.
> Codex assisted with the workload, prototype, tests, analysis and message.
>
> [1] https://github.com/lcf0399/linux-regression-evidence/tree/a233ed8edb1=
e91a6a0ea0d326668bb1f52384489/mm/mm-swap-fallback-folio-order
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1153,6 +1153,37 @@
>                         SWAP_OPS_F_REQUIRE_NOFS))
>                 return true;
>         return false;
> +}
> +
> +/*
> + * Keep this ordering local to the swap-allocation fallback.  Reclaim ta=
kes
> + * folios from the tail, so reverse only the newly split children to pro=
cess
> + * physically adjacent pages in ascending order after the original head.
> + */
> +static int split_folio_for_swap(struct folio *folio, struct list_head *l=
ist)
> +{
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +       if (folio_test_anon(folio) && !folio_test_swapcache(folio) &&
> +           folio_order(folio) =3D=3D HPAGE_PMD_ORDER) {
> +               LIST_HEAD(split_folios);
> +               struct folio *child;
> +               int ret;
> +
> +               ret =3D split_folio_to_list(folio, &split_folios);
> +               if (ret) {
> +                       /* A failed split may still have produced some
> children. */
> +                       list_splice_tail_init(&split_folios, list);
> +                       return ret;
> +               }
> +
> +               while (!list_empty(&split_folios)) {
> +                       child =3D list_last_entry(&split_folios, struct
> folio, lru);
> +                       list_move_tail(&child->lru, list);
> +               }
> +               return 0;
> +       }
> +#endif
> +       return split_folio_to_list(folio, list);
>  }
>
>  /*
> @@ -1391,7 +1422,7 @@
>                                 if (ret !=3D -E2BIG)
>                                         goto activate_locked;
>                                 /* Fallback to swap normal pages */
> -                               if (split_folio_to_list(folio, folio_list=
))
> +                               if (split_folio_for_swap(folio, folio_lis=
t))
>                                         goto activate_locked;
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>                                 if (nr_pages >=3D HPAGE_PMD_NR) {


Thanks... But I'm really not sure if this will cause any real issue,
the LRU gets shuffled easily in reality anyway, and synthetic tests
for adding a chunk of code for a limited particular case don't seem
worth it.

I had a similar idea for THP splitting in general for a while, but as
a cleanup (to reduce LOC for mm/) and not to make things more complex.

