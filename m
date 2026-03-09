Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC4BEA8542
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 03:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48E16B0088; Sun,  8 Mar 2026 23:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C866B0089; Sun,  8 Mar 2026 23:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4726B008A; Sun,  8 Mar 2026 23:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF056B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 23:08:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 274ECC3A88
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:08:44 +0000 (UTC)
X-FDA: 84525042168.30.8A91DD7
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2ED1E2000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:08:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=izBJi9rS;
	spf=pass (imf13.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773025722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzqPjms/tffjy4BC2lVO9Tm/P6GB1dUduvpzcwiyUHc=;
	b=pSWMroKozjGuJOe7NtNT2oBfbXvjpgke5V8GGZ/POOARrX2dkiZ89TgLXz0aKiC1EQdY8+
	LV81fxrZnG/BrF38pF8oSXC/7nFMe4cbXgxz6IvzfVuxZMW5C7kdzGrTyWxmd9tNxw6aXp
	D7VJ/Mlg5rhd8EdzwSXI0sFHHG24qyY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773025722; a=rsa-sha256;
	cv=pass;
	b=O58qXrhFms89s/S5l0UTkoU0y9EWvtOp9JjXJEYEndgC2hlxzyym6cTMVyXTMppC4TDFEf
	gFHw6N0wReGR/VwVBcG2jZFuHfRq/6g4cKOMaDbYzzZiTzZ4oYr3M1EWYMPOCAl7vEk/Ow
	v2Kb4jrrdkEcwsUzL5Vcz1djTTdfHIk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=izBJi9rS;
	spf=pass (imf13.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2ba9c484e5eso10608037eec.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 20:08:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773025721; cv=none;
        d=google.com; s=arc-20240605;
        b=RyY6+AAAJKLik5KU9v5Ystw5Lq1W429XZMWxqdbhxMgfWxsaapY81BSaGb2gyaJAYv
         inySxPGAMnm5SLYg8jl0TeiVMMy0LsCPbYGuBIUSB4ktVlLWiUbGtZMECuyJ8jqk75cZ
         LbZdMFEuyhA/UqP6Y/phkYzBEm8fJTvelgpB04/QK6zOOXyPiPTMzf1iZGuHfjvCK+wt
         ECLt31YETJkrBN583PE8eXOxRqRRmekYDZpqXgR8PPWQEj8kcx87Jsi2lb1y4Gvjle5c
         e++KSYfdcf6Tajsxdnxo5ktCLP3rvbqs3BUdlNCukjsnARCMgRziakqO8rxtoK+VynvJ
         3l8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fzqPjms/tffjy4BC2lVO9Tm/P6GB1dUduvpzcwiyUHc=;
        fh=lzioZPi3T7Hn4N6ku/o6nOIj8e7G2Ylj4Tn47lyyy5I=;
        b=KbB9t9j8btOZ+Z1Y91oy0y6Jnh79XlMMJrmMateRo3wisZqzU7Qs4e8rTcpS0PhlYN
         0duLxyEthbPX/ILJRBta86GhSB9ZT2jdjiuuO0NIWzH5tY5aZDqXARDNcHyg3piZihF4
         wIDDeRjFZUFtCGkjDqHExjrECHF2fr2/3Mq3TlxOxjNbDOjLkrNd5knTkcImOMJwidSx
         77+AGdNQmUJcjoSUmMueEOHuAmgONw66B5zUCNgeKZHBaXzT+R+qOcDZQcgfyw42tc0z
         wxbOkuG28o7X0VKPVbFTzjMdBVPcTUXn5lWO7nonax7IvF9nPsn8P7wnuOTnl/AdIfr5
         hQjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773025721; x=1773630521; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzqPjms/tffjy4BC2lVO9Tm/P6GB1dUduvpzcwiyUHc=;
        b=izBJi9rSieQiuQXIcHSXv4y3Wfxl8WBNostCV1D/xTZ5+N0Wy/TwOihujUPpLtk6UK
         nKTAO7qG3GA4lfzQ8ld64N7gF6w4VEv9pAxlixOn2MUhyjr5oEPwJeUEaUjWGRrUKxpe
         1Lt3K5qGwNlSIBhxiDCB2q4orz4hzq8TBPPOPFZSJLHt40PZ1mwwnwnwnnUKiGoGGn1q
         FhnNXRlGLfhc4RuHUkn2MhoKO1xhLqW1x28q/2wjnILIl1PeTWSvnhNHN4EFGIX0e8bM
         pD9SVUHXDKrMi+4M+f+tCEJJRjSvhUdj4I03AIxtZlJ2isBcicw6oOCBjRit/mNpyXWN
         0w5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773025721; x=1773630521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fzqPjms/tffjy4BC2lVO9Tm/P6GB1dUduvpzcwiyUHc=;
        b=E9UnFzpSpf+DCjJ0XQ+44Ap5bYaAA7J68IjjAANfqNXIiGFu4gOKf2fSbNGfBUaZBx
         tKakHsv6VTiOWuhyfC8Skxv3DjkL7KhLAGo0UaHpCG8NLD8F1uy04SL8gLzY5wLveim+
         rl9pwPrNSKUwUfjZse7n7cNt0/8aEfFa+4kIrHKHLx75fz//fdXooexEROQ4mVLVxZft
         I0T47tUqC9DoOCngsEDmzt3JsTZGr2TEQ/wmDmovGNTu1t/4OS+dYh+qRmZP9ZkbWPtQ
         wO+NIkGjVkEy8rnQxm6wBxq4Ts90GnCIxXVVtaQLl08btDirlyceRj2d8pbSlh2+3UsS
         AFJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ/MwwuyCvFJC7SrCzj9o/IBhsWGY2FmP0HnbM9pewbw2Qrz6LMYHpqZlxUXHq2sIcLc9DwOqGbg==@kvack.org
X-Gm-Message-State: AOJu0Yyj8GKFlZBAD0RxoPIr95yWUDpt7RI9tvo7Hg1/EsxgrG5iD9rS
	CQ1F6F3SoYB3BZwxmRvXBOo9MCBEi2nK1TlqBEpb4498d0HNJzlhjpuM1WbCnKb7L1zr/oOSzml
	n5P4zRG8+64lVngugSMZviKPwlM3vzrg=
X-Gm-Gg: ATEYQzy/dl9XA4KJFpcsGMZp8SSoFIhC4k8NlMBcLkZK42Iy1bz1HFZ0qo2FYu7ePBB
	MeKr0XcYsB0GVerQPqaj8B2qO5fgjjj3WP7rrc69d58UvFynL7yzo6xSO4RG68mYaju0PtDtEB3
	Z4T/SrhHgtnxmJXjGXSLsaHzfNdSdGXE+DwL02dua2BLLvVS2jO0AHGQm6nvLJyfI4q4Pjer4qJ
	pEQRHdt5sRfLkd8s4Y0e2TPDx2ggWAVqrRULfcdZjzWEzusM56QA9ELrUmPzIKZmW09CJbQ/TGK
	FjIdKLa7y9B2ninDg4Wpd61kcR386O7ZIAyBR/PAlA==
X-Received: by 2002:a05:7300:b90b:b0:2be:6f6:a39c with SMTP id
 5a478bee46e88-2be4dff28a3mr3189470eec.13.1773025720706; Sun, 08 Mar 2026
 20:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260307143542.179953-1-jianhuizzzzz@gmail.com> <ffc6106b-292b-d8d7-3c34-aebe4feb6e5f@google.com>
In-Reply-To: <ffc6106b-292b-d8d7-3c34-aebe4feb6e5f@google.com>
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Date: Mon, 9 Mar 2026 11:08:29 +0800
X-Gm-Features: AaiRm5345nQP7wJtt_NLhvQXt--b6XhTjz5lByTfdLY_4-yd1IfeVU4kfncXG9s
Message-ID: <CAEgWzV62v3TPrvLLpQac-KBkDFNTWg-=V2Xep_2+h0c5NXOaYA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/userfaultfd: fix hugetlb fault mutex hash calculation
To: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Andrea Arcangeli <aarcange@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	SeongJae Park <sj@kernel.org>, Jonas Zhou <jonaszhou@zhaoxin.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2ED1E2000D
X-Stat-Signature: zjc8uux4zstwhrbgaxgqfaut44jhjn7y
X-Rspam-User: 
X-HE-Tag: 1773025722-839354
X-HE-Meta: U2FsdGVkX18U9Dm0s5j2yUj1NbuTkojpDV01kjfTFuGe1eOJXKXFMy2Q7TmyZA9ioMiLiwEECIdts3lYOAiEw+YVCHNk+Zh4cp4qGTIAzvYyxJTJX4L3z3a4A22/pqpg8D5PmbS7efUzb8A39QRkBzGncnuta2yixc9AOmkhbzEMHzlCqXgM9izR94jMHbkH9kTvJceG/exxHTFNDoIKBb998Ax8K+fC4clM3j/7weHXJ6odsOHW2ETFOAijn0T6zrSZijc8CKEn7/P99Qpn8/EIHklSfiyVJnLAfBS4zVr0B4vnQkbcYoxLENW4vJqDnjz360VKLm/Dmnz86dh4ZC90t0UMNgMpKO8tSJ/Esn7Pk0rYYa02gG0Chs9018xiw8ogEeXAg+l+5CvsKKyS6IMSlItSibHSdT1qQuMVG+i98PEoQiqWx4cCHl9t33ly2EHpIgUjWJ/z5/S+9fx1cCPuVd+S3g1SljpslYfDP1bQ6g0NQR7zatl1/rygjuG5mHZ1+eTyG0Wflgg+LVrIbnQVhzEUQ26tBfcyEOybOKgan1QGo1e7wPO7tsLvh5jD4XjfRr3K7SOzBLFKEjvhaK7HIfTeDLTQyzMdBQyg5GRZuTfOKLbTy6yByR0M9EIhgdibzIL0Wg+y8Oz5hHLdKREBMDdFvJAwjDSpaud5619UZ3P17GKA7os99aB6KCkRh2DksHtL7Qw3wXBfGg26tetMC/76009P2JYJg1K5DrkjB2ZtPaUv1NkHvSLpghucJncgXngVZLTdOaPPvjLQ1O5E0llfosb+ctZarlv4apb8984Pta+KbP11y36JhOtKrWaKmjb1sscGfZFMIcAYSQpSwBVmNJDOaa1R7jO3diIUt9UR2NPd2OnLIBq9orDo8+Ld2AP/63XrVXvhRY6jbCpAMPM7yHjUUKq/Msqc8rdu/XXO4mjtQSOrRK5mrF8BtHTvmrUAFRknbT6K1cl
 YunNvdaO
 OO2IRZd9AXJOi+uuWROLqSJrpf1hRmgcZWgbtdFFGtX0nWuzICCmfdzYbRujPtIpQlbqOSH13F1qYBdZLnobV/F0+zUbsgS0wMQnJfuVtROadi8HZhh9GN8s4b9VdAI8sLTWB7c8iJbJ0xfFcmmASXuiKwYEtdOH/EauoCdD3g4sVnpbEhNGjpA/2iCY9c8/wTRj0mebezH7FlAQDh9lrgT/7Lfqux3DkiHYBQI1s881G7LjoOll8qfuOzlXq7ke3voD5+8qkh5S458uTufmlfvg7VI/8g8zVklOQ/0uC35mTHmA4a6nXR6OXhA+1orCM6AV0rchT9SyHFV8A7R/gxPY8KJuSK0Sv86PWE45mjx3kzSOUmEK+jbMrkG3vK+f3DF6USZNgPoTWftS0Nx/qGTfCfM9iPvRpq5YNboODK9i5pU7byURqLAkAmVTBYOyKgpqHCi5lZwo27W/iqZjQqdNcamLNkPS7C74tdNIMkWnVd2WRj5zBLZyBxte/AnhtgNUlJrGbCuR3h1z7gGElgfxE4XrAMxaW7b8Pl3YeEypuoCXT3vsMystYDv8lgakO5q5/qgLGBunwzRitsCQBFLmoZDW5CvLpVjiA9YCLbp2LH32/uboUZR5eFZMYMwIslvQ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 08, 2026, Hugh Dickins wrote:
> I have not thought it through, nor checked (someone else please do so
> before this might reach stable trees); but I believe it's very likely
> that that Fixes attribution to a 4.11 commit is wrong - more likely 6.7's
> a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c").

You are right. Before a08c7193e4f1, linear_page_index() called
linear_hugepage_index() for hugetlb VMAs, which returned the index in
huge page units. The bug was introduced when a08c7193e4f1 removed that
special casing but missed updating the caller in mm/userfaultfd.c.

I will fix the Fixes tag in v3. Thanks!

Hugh Dickins <hughd@google.com> =E4=BA=8E2026=E5=B9=B43=E6=9C=889=E6=97=A5=
=E5=91=A8=E4=B8=80 10:09=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, 7 Mar 2026, Jianhui Zhou wrote:
>
> > In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
> > page index for hugetlb_fault_mutex_hash(). However, linear_page_index()
> > returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
> > expects the index in huge page units (as calculated by
> > vma_hugecache_offset()). This mismatch means that different addresses
> > within the same huge page can produce different hash values, leading to
> > the use of different mutexes for the same huge page. This can cause
> > races between faulting threads, which can corrupt the reservation map
> > and trigger the BUG_ON in resv_map_release().
> >
> > Fix this by replacing linear_page_index() with vma_hugecache_offset()
> > and applying huge_page_mask() to align the address properly. To make
> > vma_hugecache_offset() available outside of mm/hugetlb.c, move it to
> > include/linux/hugetlb.h as a static inline function.
> >
> > Fixes: 60d4d2d2b40e ("userfaultfd: hugetlbfs: add __mcopy_atomic_hugetl=
b for huge page UFFDIO_COPY")
>
> I have not thought it through, nor checked (someone else please do so
> before this might reach stable trees); but I believe it's very likely
> that that Fixes attribution to a 4.11 commit is wrong - more likely 6.7's
> a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c").
>
> Hugh

