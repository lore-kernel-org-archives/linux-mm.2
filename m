Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D62BEA854C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 02:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E016B0088; Sun,  8 Mar 2026 22:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16606B0092; Sun,  8 Mar 2026 22:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22386B0093; Sun,  8 Mar 2026 22:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 929116B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:09:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1918EC3C83
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:09:04 +0000 (UTC)
X-FDA: 84524891808.29.47BB095
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B41020010
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:09:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0AzuzUcA;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773022142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6//2ijlmMRzvlm6uQ16m8RLuSwott7gMXyhq9LM7gw=;
	b=KCGEJMHPUwCvBBRUyNNWR0GJoinv3w/GXeAm/infyVHGKCFX1e+KxthWvcdmdYdd+t+2V8
	/OVAo+ag7itnz/tphG8Ie1JDO1gJygATeCJgzjb5nkpLittH9MP2aCS6bEo6CDPbmJVPMz
	kHRQRpN64SxvWLjo8uXn6EJF9m9hhtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773022142; a=rsa-sha256;
	cv=none;
	b=6eAWKfMYBqG0urQ/EopxqmhvVGSZxLC6P6ZvmfUlwG0Cvealsg1zeFcI8JeLatsJo1YOn0
	K69qbSZ4oHLNJvZR2ULt66dky5gtoUmO0betO/ZcEN3P0A9fbN90O5xNLZLnY9BEmZ2RjL
	Xi3Nibzi4yB29ThDJ+RetggDQ6r/INs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0AzuzUcA;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78fc4425b6bso110143807b3.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 19:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773022141; x=1773626941; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R6//2ijlmMRzvlm6uQ16m8RLuSwott7gMXyhq9LM7gw=;
        b=0AzuzUcAsLhSpoow9xzHWfdpwduCo3FvGb/AJmK1HKrMpU9v4dmi1J5Di5Mk1+dYt4
         4cmNPsfgT4svPXhFUbSLLwq5SXX5bfqyHdCIT3+aklBTbEdx2lN7coU0btsraMcOLtf3
         YdF+P55HYpIPjMapqD4Tprts2AMZeACEMGaTdb+am+WPn3r917KXnrKINWOJWb1sPpLe
         H3Oi4nx8LEqxWykgkwr0yGWneSeqn5826ymyrpWW/sdV90U81FbPF+yxQzZJ/xT+xuiQ
         07gM62TfhUmTRx+DP0cmF9UKkGD5b0I//vyEbJiebWoEWemRVtw4neHqlEXLl0V0jUh4
         MiDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773022141; x=1773626941;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R6//2ijlmMRzvlm6uQ16m8RLuSwott7gMXyhq9LM7gw=;
        b=jg6svfy/HYHgEZnB16YRw1Zky388QQUg4udnTJPYoSPhsRoil2Ra4y9OlHaPs6OXUV
         PnhQZZXpGUE7G+b5seryaVx6DjL2KiflPOWFB3mJ3+dDgNjEE0fhvW0EZsfrs60jss1t
         lhsZQNxB6trHAziODHmDy54mHsMCTBpvmLJpQSfEdqCxmXAEyBhb43L2xXzw5XKzGyfs
         tuB2fKsECXqBnVOYmmAWV4lTiyCbMVci63Cc14bAxzCmR6dUp2AqHVzGdJer56I8O+8R
         +gaZ3Cq8+9t2bORO+mxmAhVt0qJz3+vnDmidLkFktVZ1ALbOcKtVnGETHs28Bn2C4KYD
         xEFA==
X-Forwarded-Encrypted: i=1; AJvYcCX3iR4orR6v/iCkSwHhNSfPxX7vTE/DhKUUkM5jqXmMHfMQJJemdhGzL3QG42DNDMRsKGXUZpr9bQ==@kvack.org
X-Gm-Message-State: AOJu0YwV8K0c+DCsCk8iwUfG8CHYYl98l/YqglG70Q80+4vX/dpwD0ZS
	PxyuuBEF436hW2f99qipcAUN5jtEO8R6DT95pE8hBokLf9e+NQRoa95VU0FUnegnAA==
X-Gm-Gg: ATEYQzyd6ebMDev6CGng8VE18HJkt9uL09Q2025bHtTChk3dTcpptFq1v2T7txCR1cK
	ndAXIZq8hnphomFnadQTjkg/mozsqC/A3vPtS17r5Jn44tzMR+9teLV2+HmROkfuHxBFfbEUsH8
	X61llWpIKvuR48uXe/B6e1IKnCsErObaOgE39daFwj+M5jHCuTuufPu1y6vyAifjUElddwNQwvh
	qEU4FVS6cwa1L/mRMYhJRRGVkoTM9ZEoXUgM2B+DgeDu76uOhoK6AuIrl3xxf5HP/ZOUHipDuYg
	9n7qIi8x44ahyqy4JzqYrtDPLL56wNmR9cNhdkYSlv87cvYMSpveRhJAiblvWY6T0ogGjdbYG4Q
	ocGub9uwsbirSeDJyNtkA2DBlUEtSgStq9fdcgdTElVSUValEqODKlx15ZqxWG5HZUwcqFHl6/f
	UHfUj7po0yFVTaV8hl5Pla4b6b9CIBNn8UIrdxkLLJTuHYlTzD8zZA/OQv12fKys9mOzeTxrOOu
	vmg
X-Received: by 2002:a05:690c:670c:b0:793:db81:f1dd with SMTP id 00721157ae682-798dd672d69mr99067567b3.4.1773022140970;
        Sun, 08 Mar 2026 19:09:00 -0700 (PDT)
Received: from [192.168.1.163] (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-798decec989sm38049157b3.16.2026.03.08.19.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 19:09:00 -0700 (PDT)
Date: Sun, 8 Mar 2026 19:08:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
    Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
    David Hildenbrand <david@kernel.org>, Peter Xu <peterx@redhat.com>, 
    Andrea Arcangeli <aarcange@redhat.com>, 
    Mike Kravetz <mike.kravetz@oracle.com>, SeongJae Park <sj@kernel.org>, 
    Jonas Zhou <jonaszhou@zhaoxin.com>, 
    Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
    syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
In-Reply-To: <20260307143542.179953-1-jianhuizzzzz@gmail.com>
Message-ID: <ffc6106b-292b-d8d7-3c34-aebe4feb6e5f@google.com>
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com> <20260307143542.179953-1-jianhuizzzzz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B41020010
X-Stat-Signature: yu9uujhegj4eshpxmfm3s6kf4dobdwp4
X-Rspam-User: 
X-HE-Tag: 1773022142-860049
X-HE-Meta: U2FsdGVkX1/Cg5heK/FHN89bS6aAFCF40YV6V+h+x4CX0qA7S8vn/+Dvwm7BUUbRpxtgwuDSoh9DpHY56HfFsF2piARJZHRUicue1e61Okpl7ny2399B2/hOo6eOcPYqYxMIJIrmu7fW6qWeB3SiCx8wxfFz83jNMGlP4JhoWzKK5MZNid0NToHfG9i/7MMgZxAcaHJkexYPD+9ceMRfkjghimIu475caArQKQQj1QxNQQBi0fQkpbJXKcrfyKQ6eH42zGjcLDKlA0Uvj+0ybquydTgmvVCbdRiLFZ+iJHg10h4ilDl/qJWIBmcS1nMchjkF+T/wiEcqMG+pw7eAjliAh8n6ccXBvBJiWSAp7Y4GIU7WIaFB/vIuxywg2W4YlxYeHxFupraOM1Ae3eL0lXRG8eYGNp8CDwwnHhqBB+r79gDdMMnUBh0CYCpUvjE17KWQ9x6h2JFIN3wndxigDSpQG/lzhz7bPmbtVVu37UeL/UEelVY1nccbc4vgqWQShwQSAC7jm2FDMPYKG6NltXrVazWxfMdH97/ZmCEIdra9TlWaCKRbdNj4psj+twgj6R2S7mhBaF7BYfl5ETMKma7404r86/he6Ta8FGhOFQ8KysgdXZ940OelAjHiydrEj+0cUXQwSVuOdVqM0jjz8XaxNm9VSg/DQQUq6h4YFe4XvVMB55roDyofPtaP/Y+Cn3bc6rkqoThW3PQi7cyVVQyHWpzTf6Qm4IclMoe3QK28NY0GUSQQHYFMMc3TwcFbwFd9jfZIU76GbD9T9wl7UrPG4rwLGffMI9Y+kDgG4F3e75iUBbablHjhbBiTqStdPtHzrELn90byHPEBp7H8ayGZUjFiP77rhwKzZJxSDVvTfUF1YF817qIlVttb96u8IHzxZ4TJdQ1RP8imrYDIdM4M11Sr6IRm51w4oBSXn77WvmOXey9crSawYPtSzVm4hJ0HtORuAhMG+ej/mi8
 b4eanbLR
 Y+PLHD/JC++PGUpeVHx3XTYgeUNKIb9cdnvh7YjZAHntgH3RsbpERulzfwJ1qjUAUqbpYpDciQ48raCt4uVQOdR3fGu7HY7dwHrsj5Ao36J+S1ARRqXPuIRmVyRoSpTF2Fgl1RxeCkQvXCvLF4pRmJQVhmpqzhaCenNpZx1ePEt2kMDSSaq+DZ7tDrbApPDRA+iRzgUwMkLil8eQPHdXMyTrjtj4EzAZuFdDvP5SbPn7DVjhTDbrrO+WER3mQrTd8mi2XNVdrNd7ifjyJmm2e5AW3ujpZMrV4SeYxNCsut47r+UBtK9S0+rwqvUK8GeexO8cZ6XGER83jwk66OHRWsDTMWDAfFqu4k+jL+CEyeueGjPIKSZFn99fqJyDiJ3zJvurgPzvAv+9KGLFweds81juL80OV/g3suG2kiPF4wKBtp2NLC1+n/gGfL8N6vUYxHrt7FFI7GWWhDwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 7 Mar 2026, Jianhui Zhou wrote:

> In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
> page index for hugetlb_fault_mutex_hash(). However, linear_page_index()
> returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
> expects the index in huge page units (as calculated by
> vma_hugecache_offset()). This mismatch means that different addresses
> within the same huge page can produce different hash values, leading to
> the use of different mutexes for the same huge page. This can cause
> races between faulting threads, which can corrupt the reservation map
> and trigger the BUG_ON in resv_map_release().
> 
> Fix this by replacing linear_page_index() with vma_hugecache_offset()
> and applying huge_page_mask() to align the address properly. To make
> vma_hugecache_offset() available outside of mm/hugetlb.c, move it to
> include/linux/hugetlb.h as a static inline function.
> 
> Fixes: 60d4d2d2b40e ("userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY")

I have not thought it through, nor checked (someone else please do so
before this might reach stable trees); but I believe it's very likely
that that Fixes attribution to a 4.11 commit is wrong - more likely 6.7's
a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c").

Hugh

