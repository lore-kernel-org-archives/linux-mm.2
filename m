Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29269EE6B76
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 08:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652606B0099; Sat,  7 Feb 2026 03:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6340D6B009B; Sat,  7 Feb 2026 03:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537CA6B009E; Sat,  7 Feb 2026 03:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40D856B0099
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 03:34:35 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF16B160401
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:34:34 +0000 (UTC)
X-FDA: 84416999268.02.DC3BC4C
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id DB445100003
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 08:34:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IAC5b85W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770453272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0F5AWEnR3lt3rLamgMqFPk9qp0cmWTPeqpN4u4E2NUA=;
	b=TTt55rMk7oLyk9L0m6UxVcBZGkfVF1JxgOuZkv7Y50mhsPDE5p9RfvnIxjzZMdQaRnxm/3
	HN71v0Ztyf4HQfxpie6szSSU5DxGIvuWuGyFFIkZdjAAzUjJ21jnqpgihf+ntjRV1sBtPI
	BwNSR+CG9/a39eqriaGRw6ToFnu59Ts=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770453272; a=rsa-sha256;
	cv=pass;
	b=tPfgnDgLKDvZc5DE1DVHcBabMSip69uihxSaB3C+e/rB1g88/WdZppILQB/1UouJuE6lLr
	9G6kfg9NFNjcsGr+pr0zBwxjf9DHV0DVBSYhFQkKdkkVVwtn0KlWVMCATRIArPCPJFviLc
	glFTbq67jYTx0rkiewQCxWtLQ0y/fHA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IAC5b85W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c70ab3b5fcso201407985a.2
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 00:34:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770453272; cv=none;
        d=google.com; s=arc-20240605;
        b=elvnDFHyglyPTHv1c3Jk1nMz3CqiByoSHjMGi2gKYyI/sWTM309r48YDvtN8XxkHrB
         DH2TfoJfhy5CpketuJxThQfOA0bQJs1gLWfdHK8wCs+rEh8xRfA9/MH0aG6PZ5QIVzqH
         FIhLxBEXO/uEQXU+yT57gfNLuY3HzgQAb5+XHQwMwU7e6Q342tsfDHeb/PsO/73swGJ9
         4znq7IpTEGRNJfWT7XocBKWJJsk8RDK5HoJm8ZlAY921+bh1KmqPRDaiJQTKvKvZZlyu
         V0MSTZWKp67nICMWeMWaX4fWoQ07miRxfRf7nqeQJKMFNWsTAsQ7vxyTv6WcQEkuJzWw
         LDrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0F5AWEnR3lt3rLamgMqFPk9qp0cmWTPeqpN4u4E2NUA=;
        fh=OYJZgrHcsJ5+2zVCLfNcgCW8relJ/wOA/evj522nCFI=;
        b=d/cU6m2Jem1xTV30Cjf5Pbyc/Jz+T9BOCCtHegnwvRT7to5k1Xyj/8BLaAdFjRY98i
         cgLupLBBoqLccE3gq5UJVydZLpGeYI7KykFOHTucK9+QHvZ0oFhbqCY4p8cWaFuFfYd+
         gRXjeHm0J++YiUHNU0oZUGjvObh5aZHafjga17vD37Tk5TBxwDcG6Vglvri1MUSqiq49
         HPHnfYS9pWdifhnj9tUyiCk9uExTGR0EeOoGxMjX9XSfkJebQb1EN44b5Xl6Fdu7sZzy
         4rRycL4i9IuDieb7Rz8LC/mugRFL6zYetluxMwktVfXPIZhut6hpePp4gNPj+ZP0yan/
         VwFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770453272; x=1771058072; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0F5AWEnR3lt3rLamgMqFPk9qp0cmWTPeqpN4u4E2NUA=;
        b=IAC5b85WUEB9D5u1HXLmaNAqZZYRqsPEk1juDn+wY53cE6vMjMZ9HDJAkgsu2+TM61
         EasRkwvPir1OWEmo/3TcCu9OSiDxJ3kigBg2zj+iSj2esbN2kl6kslHQ5O1mc/iQzmDP
         0aIjISvw6FZV2Ot+v4K+Zap9vFEKtP1X82l4dF5XDvY17WulJdEkhqku9ReuKTUCIvYx
         QZS7PEmEIL5s7Cqkqn3Fhq65v836Fm5YdatZFRI3cJB42Z5rWI1445flzMwDlAj17XUB
         4zuDR/hjfUhygGRwL20nuSi/1YqAzIQsEVe3bM3MJY3BHHe9hJ/uGUNt+k4LiZgClO4W
         4AIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770453272; x=1771058072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0F5AWEnR3lt3rLamgMqFPk9qp0cmWTPeqpN4u4E2NUA=;
        b=Uw6QHf/SB96qjtP2At2mjXyIrIbZTzULwTPz3l5otNaR+1gICETQ5TnkGDRJYEBiZ5
         Iu+RsRvFcCQWbVrKJu27RBzutl+OZWc5NV236CgWhzXmYAUw8fbhD2lARcWgsK4xStPI
         Pc7c4OYV6X1eAmXSbQ5hRURPRCmHQ7C3ed1fHnocD/2yaVoZElH5tHqBElRiEE73oVWy
         xWXTkRghI6P9YY7EnDvi8jKvkls1UfFvrlCvdOc4xSH+0gOF3aHXuuLMM1vY7ROqB+Zc
         su5FkHz0txKa9fzQDq1qISUWJTk+Ioe/Mj/yNJqlof6r53bejqyyjNCSxCATddTgfk/r
         uolQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp6siOuAMBdLrg2R4Kio1Q/VKPyct1UF7dePPAdeSqPuTAyJa1Dj/gMpdulmV4kLJZlhzLn0Rhiw==@kvack.org
X-Gm-Message-State: AOJu0Yx89s8ueDEIBUV9V7vcTK2l23tqNrnpbEkAOsuobCt4FjXoiI7A
	Pn1jo5rUHp6gI9M/cUpYs38ob/708hmonYtqwiUGz8pktiprPd9du/yInmfDjU3EQ/kx5M3ylRe
	mZ5Y7qWiBvDaK+KpdV3HjI8t5A6APAp8=
X-Gm-Gg: AZuq6aIIA8kSaWSvSASBqLbH2O8cwVm5L1FEq8wRwxGzj3w2NvumUGYgL/mmtjcaF+D
	38QjxVOWYEHIjXfI1XKbCMV9m2M2HdJmshRzZ2vG+uBOaF660MGIvLRXBWszA42cTLlNycPZWIo
	LF7HjkkpyB/lQ9VuuydYgvLe4MjWqhkefZr/4iPCnFXCZTB5rk3pxcVt6jRLBrdGY9Cih4/Rveo
	tIID7AbW8mjqbZi80T9Pe1AQxxH1uBmTG3bd0Vs/ahyBSm4M7mYPBh3t4HX5N1WCSgFMA==
X-Received: by 2002:a05:620a:f12:b0:8c0:cd96:9bd9 with SMTP id
 af79cd13be357-8caf1bc5cc3mr747779285a.90.1770453271692; Sat, 07 Feb 2026
 00:34:31 -0800 (PST)
MIME-Version: 1.0
References: <20260207081613.588598-1-vernon2gm@gmail.com> <20260207081613.588598-5-vernon2gm@gmail.com>
In-Reply-To: <20260207081613.588598-5-vernon2gm@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 7 Feb 2026 16:34:20 +0800
X-Gm-Features: AZwV_Qg6CO0x_AsjX1FciVPClHDaTlbzKWBX6Fl-Ro5DXKTWtBnRDwWwhNB924I
Message-ID: <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DB445100003
X-Stat-Signature: w8hzg6kaneaqzg77e3o6czbrqpgi47ds
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770453272-421922
X-HE-Meta: U2FsdGVkX1/Qv6SUjkb6AaiDnJoJehkQd7PEg89//u7vdKs7iXU4zpo75Vh2OQ06z7Kb4xzwU8SdMF8fYN1mA8YzPqgbtBXoHC1XnuMivegsU3EWHtdE+webTDO3abwTLCmU+/3U/tnHkIkMtIDS3pEj5P/p0qOezWAg0o7hxE6bJUr4yR2QQCJh+ejnQbyaUW4QhLxN/1/MgoGzf3LzWmGfzocRscEU+P113a/RUwlV2iRqL4NmAouMfrwLXvOEC1OCFSlHM6pYMKlrD+IMHHh2/pFGSNM0MhNTmKAFPvfaYdfZTGsrv6aLBzms1H7JR1SFxXXBzhCciJCcvFDwztCD/F4weFGkCqBrBdgjbtt+R8A2KsSEeLJie/dZSSNRQggKAFGz8B4DywKzLXNzmS4DKmdeYbMVWoa0RKxPIoRhvSuYggbB2Ae+Qck2wCvgHbMH6uONK6kS/cIg35iCRKt9FbjpEtgL5FbPMsWWwHCTNyrg2fkmoMS+bJ2D4+212CcOeOKNCurSDFLEi0N0ywDovhgMpFPc0UTnNK4Va1CHfk5YxJEJ5bMIF/CcSL9IWWo2RbChTJm+B99ScM7hGQOTIEF9T8fD07a0UqHo77wtUh0krYix7LGMltpsOZQqJLqaC6R5VYHiK7eN//G8pcrjoMqwI+3zUtfKvMjncDeQjLF8L7OK+JAxufOOw5c+zCxIEePjYP5TGmZGYyBoZ24sl1dav3oFppzgsSBL3X53GHNcr3FvVsOh3BBgJfypiy12QVRSrg5+RgXV7zCCnHd0rM80FdzYJerlegju8K0dcRzZWOwpofg3bDl1Sj9U9MPRS/cVRxm69JGI2/0Xp4rRLeThv5XFhcDcB+XXr91Tz9hAWRtokWd2n1JuVwoZpktDacMhOtLbVs4mBDwxzgGghMjqIgUmmKkJ0ixPjBtA2kOzf0fbMuUS2v0EB0WbdwgMrSS0bb/sFgXbVUZ
 kwpLAroo
 YKHAgV55lM2fvr4/rWDizIjzP+5jIQID+9Lm3qPmUYCJXrPP2LvvXsvd91L4+ZhvmJsOPPXiaPEcEzVDkBX+haoYsSp+2OsWoj8YEVkUfN3d9Du9tgo/nSPlgZ87+LDyDHTa4b/+vo/K/5cRgfhAc/TGU/jzPsHALakv7J42PEkA3N6z5jku8Mg3EOEMBAliRtnTS5YCX+TGyWWSNXJhPT2YydUWo0eBpBZon/QVMs/yd97tvqV3sJi51HDck3llJKnGLC7TmFRXgItfAg2TTHEBQ752kK8iwKz80NCsZsdWySN/B3NUINXCYPvF0DANQu0cBfk6y/JZGXtwLVMMd3pRLxfJSA0CANmSYzaigeFx2ltwuq9USCCzEL7Iq9jcHYEz8YiT7++uYj1FofFdgv9c2ECun0odtAuhl0wCTe5qmX7qREwkITxvqRYDZzwkohNHm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 7, 2026 at 4:16=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly and then call madvise(MADV_FREE). However, khugepaged
> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
>
> And if we collapse with a lazyfree page, that content will never be none
> and the deferred shrinker cannot reclaim them.
>
> So if the user has explicitly informed us via MADV_FREE that this memory
> will be freed, it is appropriate for khugepaged to skip it only, thereby
> avoiding unnecessary scan and collapse operations to reducing CPU
> wastage.
>
> Here are the performance test results:
> (Throughput bigger is better, other smaller is better)
>
> Testing on x86_64 machine:
>
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> | cycles per access   |  4.96         |  2.21         | -55.44% |
> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>
> Testing on qemu-system-x86_64 -enable-kvm:
>
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> | cycles per access   |  7.29         |  2.07         | -71.60% |
> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> ---
>  include/trace/events/huge_memory.h |  1 +
>  mm/khugepaged.c                    | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/hu=
ge_memory.h
> index 384e29f6bef0..bcdc57eea270 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -25,6 +25,7 @@
>         EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
>         EM( SCAN_PAGE_LOCK,             "page_locked")                  \
>         EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> +       EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
>         EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
>         EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
>         EM( SCAN_VMA_NULL,              "vma_null")                     \
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8b68ae3bc2c5..0d160e612e16 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -46,6 +46,7 @@ enum scan_result {
>         SCAN_PAGE_LRU,
>         SCAN_PAGE_LOCK,
>         SCAN_PAGE_ANON,
> +       SCAN_PAGE_LAZYFREE,
>         SCAN_PAGE_COMPOUND,
>         SCAN_ANY_PROCESS,
>         SCAN_VMA_NULL,
> @@ -583,6 +584,12 @@ static enum scan_result __collapse_huge_page_isolate=
(struct vm_area_struct *vma,
>                 folio =3D page_folio(page);
>                 VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>
> +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
> +                   folio_test_lazyfree(folio)) {

We have two corner cases here:

1. Even if a lazyfree folio is dirty, if the VMA has the VM_DROPPABLE flag,
a lazyfree folio may still be dropped, even when its PTE is dirty.

2.  GUP operation can cause a folio to become dirty.

I see the corner cases from try_to_unmap_one():

                                if (folio_test_dirty(folio) &&
!(vma->vm_flags & VM_DROPPABLE)) {
                                        /*
                                         * redirtied either using the
page table or a previously
                                         * obtained GUP reference.
                                         */
                                        set_ptes(mm, address,
pvmw.pte, pteval, nr_pages);
                                        folio_set_swapbacked(folio);
                                        goto walk_abort;
                                }

Should we take these two corner cases into account?


> +                       result =3D SCAN_PAGE_LAZYFREE;
> +                       goto out;
> +               }
> +
>                 /* See hpage_collapse_scan_pmd(). */
>                 if (folio_maybe_mapped_shared(folio)) {
>                         ++shared;
> @@ -1335,6 +1342,12 @@ static enum scan_result hpage_collapse_scan_pmd(st=
ruct mm_struct *mm,
>                 }
>                 folio =3D page_folio(page);
>
> +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
> +                   folio_test_lazyfree(folio)) {
> +                       result =3D SCAN_PAGE_LAZYFREE;
> +                       goto out_unmap;
> +               }
> +
>                 if (!folio_test_anon(folio)) {
>                         result =3D SCAN_PAGE_ANON;
>                         goto out_unmap;

Thanks
Barry

