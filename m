Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E82CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD61C6B0093; Tue, 29 Sep 2026 04:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86D06B009E; Tue, 29 Sep 2026 04:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D326B00A1; Tue, 29 Sep 2026 04:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9391F6B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:30:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95441A03E4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:30:50 +0000 (UTC)
X-FDA: 85266129060.03.86594F3
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf16.hostedemail.com (Postfix) with ESMTP id C70A0180006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:30:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DBVQQSQT;
	spf=pass (imf16.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9l3xBeUfZcvuHoQo1mSle+mTZ9sk+73Aje40erUwh40=;
	b=K2628diwiS/J0gVem9So3VW1s/d3lUGKlGQkCW19LPPulZ7J99H0b4hAqUZCwDFUgffGNP
	LdWzkyh66pGAD58uUTOqogk2GoiS8agma3zaFV8FkjHBI1gZKZmThTrit4HAPk6GKwoIfR
	sHuFfke3zLaqwID8QfPqsnn0d8wFTSU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670648;
	b=DE9LXPw636P4zcSpG5d3ZbHvj0GwiZXFjON4erDZuPZox+PWIcLMWqycEq5/yrhfFEA2GN
	yotu+otO2b+mPjThMqUDxpzTQBWqDxllilMYNSW5vttLvNOb7QneIxAk4cfaosCcJO0oq5
	G2MrHZdDhxazI1F84E8qNlIXrrbrTl4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DBVQQSQT;
	spf=pass (imf16.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887f690df6so2762316f8f.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790670647; x=1791275447; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9l3xBeUfZcvuHoQo1mSle+mTZ9sk+73Aje40erUwh40=;
        b=DBVQQSQTy+j1NiiQ6h9BhJLrIs1GfzIo8XnyvwdjuealYfLDkRd4B+sY8RJHvIvrGe
         b0oBnKzta9OX2NXTiSITdwiNtEvqoP14l5bLgTRZ1uyo0EaQ2UDEInRP8QeK69FLSnkX
         OQmApGXCakRLmktxc4MCM25zexbVaNiZtFUvdDsbw3imNwn1YPLgOX9QeMAm+d0DOChD
         i+sSbvbgq4KQSj5xc0KzhFw02GS2ujEVanxcA/b9qJukZJkVmHNraSjIFFWwEbwPP8D9
         /W/tZd+k3nYiCjGZLFmmnVD+Jx+EFuYFLQUBpBzPohEkwHnB091TJjnxCfd+i1IKqkQB
         M5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790670647; x=1791275447;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9l3xBeUfZcvuHoQo1mSle+mTZ9sk+73Aje40erUwh40=;
        b=XRsK1HfHp0Eu4uehgnHcJXupZivCZ7MD3Kh5bTfK9fOdYsqjFw5CcLfOTChMbPHjkJ
         VmKlKeCMMdMWHiA61CTwGx4U4cW1iQPuHva30QIZMjA13we+WMxFrxWIOx24H56upRBC
         2nB+YYp4DVGupz5BD34QFqyWdpzJqdQq5z7rVdV69EpIj7NKr1PlKAsKXakUkmAu2+yT
         00bm0llatiSr2fRKIRtszWOK9mcfz6POK2QlpRb0lRacZIhaiqb9PnhJyoM+QH1buQSX
         lMkveWHEAPhpHqZkQ0cBiY8eClN04QR5AIXOs9hPwp9ctnszyg6L8+ilGVTEBYWD8pyb
         zdnw==
X-Forwarded-Encrypted: i=1; AKwUvBxBI4tDredGGCVqJ/42CT2c+OqGT5t+sDc4KwMYZVI3WrYoioXJ/vojPDfAigW1F2+CCrlwmmIZ7Q==@kvack.org
X-Gm-Message-State: AFq9FYLyvAQoBx+DZ2oBOsjvEsIRyk9DzZUm4jPzybaZJ6OyF1/LUVWK
	sMN9RnF/2grjHmAYc9k0LsgzzfPo1iZcEO7NOLdjX1zDRyBVNSzXtoPH
X-Gm-Gg: AYBFou01XXZmHJXfEoSjrPZAMOJeTtiuo/IEFGRcqDwQrt90Pfvwl3G2SGaORYL1yee
	7MgdpxKEC69dyu5c4ra5wxulUtOWHlrRQeEi7afRmnho0BIaVOTgwmFQbidiITzNfTQPEpXcaCI
	vQ3RIYGPcb/+s7DkPFj4+uxjuXTGQcyuUEabdG+GLr9STbZjWhY1adSbib/tXBp4ywa3bNofiFa
	Uh2romvzJhuiuBmNvyIT1NmM4hrGOvEe0BNhaOcOB/lS2aC1NLIywfjQMJUTyaYRe0FA4aQQIFw
	MMJd5td1wlI5C+HwQKDzxhIgs+Rjdby1MtFfJxjhPhyBwhURiSdX9YxMI4syu0bEBKTPIeF9RYy
	MEUK/zdEHv0DZubU2SRtowo0taXd2An9aG70XfFG4l4XPjS5D65A1W0Mp2KukZFk9l3MrYJbJEh
	uoyQg+guYeOjyOPGXu0bEOjH2pIMVBnAD9CgyDpxN6v3jtVdA8Rebm+Q3f6KI=
X-Received: by 2002:a05:6000:616:b0:487:27f6:a4d9 with SMTP id ffacd0b85a97d-488716b041dmr31201008f8f.41.1790670642082;
        Tue, 29 Sep 2026 01:30:42 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af508b13fsm1987719f8f.27.2026.09.29.01.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 01:30:41 -0700 (PDT)
Date: Tue, 29 Sep 2026 10:30:39 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Park Tae-sun <ts930@dgu.ac.kr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
Message-ID: <artu7tGV5yiwErx8@gmail.com>
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179066531783.50175.13377521828379196177@dgu.ac.kr>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C70A0180006
X-Stat-Signature: b1cg4nd5ue87mmyhwjjj3eiaihq5qusi
X-HE-Tag: 1790670648-688772
X-HE-Meta: U2FsdGVkX188YeEq4L8jFL5KRGIG6aoYzDCfhP3btFleJLUzk4P+k8vXX8VoaArMl8UJM5ZxMcfivUOZsfvrjOydGO/kOqj2o2KlQweiQOR/3wMzL2ePfqK7UTdv1aMDLdWbCb2PmLXqOmkbEPKrc8MnwDR1G9A04fyC5VqGamhL12C/bh5iAncf34wtUxK4GQlb1OM3pNeDGcE1y0FE8/NXVvKG+GnUdIla9g4lzzsK16YzhYXw6I7/XiF0cJRMP/03f/jJWcELJQYS4agRDwT4dXxSTcgN/xrVPXGLPmgEsbCIC3GojxHm2kuUZSseINnZpLkENZferLtEFQXnVx9T+QxQZl7mZ/2KACrjG+mTlYc7JPd4yW7CqUWxN8sKTXUqzBM/QDYRDk0WkG4bLGYNRsBk/h36EC2JUijQEqXhbr7dIJqEcAOXi855Ztijjo4oZPKZSY1XVezuLGvd4b3xz/MQ1mqIF0c6uN+v7ODHLlBgvQGGWibh2P8qSReLKTzRR6hNosA19OuHHipKYDcPQ07Ha+T9Q7Zd6+/pv04Z/wfGiMlBb9bw2n1SMjvxd+XPcSivq3nYpsTbequI4eIxKPfdjzSLG+18V2z/LmotuDlfzJsnHcDHIdAZPif2mC8pHhAJoysyMJGirsg/aj0fbJ/LY58MpkxkYQsH78tGlI+iaJcXPHLl6/W7e9iJDYfzMRltrGgxF0fzvspNv+g6NJsXminTVkc1u9BQWLuA0NF7paec2TGI9dWEyLvMlfC47gV5bYfn14jnqduDnRPT7d+bndt5SPNyl5RhWQpigJxf6ql2fflXOW+rL/JbqO086fmWMNCxIMryLVxL0W6OEmGtjnjfbDi7ekUFBykz/umNABFCyCNShjQ5XrKyY8B/fvCQsvdkTPNDclGgZvVrLp7lcbOXye0ubriJhvVnKxYIRJHkCyI7sGTglfZMBtsKaTIIW5FYZgq0xCt
 vxy+e7Dr
 y9cgeLCF1G51BueThzrg+uWSF5kSy7S4psh8i7MTNc6eXqGrphFJHGdOGxqdgyoU8iaC44d7efBbP9ZtvJrhFCMcb+S0BQINwTFxQ1qeK6zyWyt0zXHWPzqDxSlBJZBDPIKtaU2DH+0u6TN703vB6khaxKvWQgJmUqudNbqNmMbSjxkoBrLxkne2KOInzxjhGyBDoEo3zA6tulmgUrldOTZ2Ig2ZbFnJeypD7P50a0XIvhHs+UwvGVvCN6zAj7wfgZ0LSxWzIiyhtnnzkQUFuET/RuIwkURbp7kAEciYwEOlThmlDm5nKhs2hRTtGs4CCkG+6Y39Y12rxjQBJ73qiFJCUWlA+u2t9fLE285XbYsJ3MX3I8lqdydX2iNjwFnz89IsCe0enF5SMQWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 02:56:34PM +0900, Park Tae-sun wrote:
> mlock() and munlock() currently normalize the requested address range
> using:
>
>     len = PAGE_ALIGN(len + offset_in_page(start));
>     start &= PAGE_MASK;
>
> This performs multiple arithmetic operations on user-provided values
> without validating intermediate overflows.
>
> First, a zero-length request with an unaligned address is incorrectly
> converted into a non-zero page range. Because
> PAGE_ALIGN(offset_in_page(start)) rounds any non-zero offset up to a
> full page, a request such as mlock(0x1005, 0) falsely locks an entire
> 4KB page (or fails with ENOMEM if unmapped), and munlock(0x1005, 0)
> silently unlocks memory that should remain locked. Conversely, an
> aligned mlock(0x1000, 0) is a no-op. Zero-length behavior should be a
> consistent no-op regardless of address alignment.

I think can_do_mlock() runs before the early return, so mlock(addr, 0)
still returns EPERM in the RLIMIT_MEMLOCK=0 case without CAP_IPC_LOCK,
while munlock(addr, 0) returns 0. should the zero length check move above
it?

moving it up also changes the aligned case, mlock(0x1000, 0) goes from
EPERM to 0 for such a task, so that is a uapi change and the changelog
should say so.

> Second, a sufficiently large length wraps around to zero during page
> alignment (e.g., len = ULONG_MAX). Because PAGE_ALIGN(x) is defined as:
>
>     (((x) + PAGE_SIZE - 1) & PAGE_MASK)
>
> when len is close to ULONG_MAX, adding (PAGE_SIZE - 1) wraps around:
> on a 64-bit system with 4KB pages, ULONG_MAX + 4095 wraps to 4094, and
> masking with PAGE_MASK clears the lower 12 bits, producing 0.
> When len becomes 0, the subsequent check in apply_vma_lock_flags():
>
>     end = start + len;
>     if (end == start)
>         return 0;
>
> evaluates to true and immediately returns 0 (success) without locking or
> unlocking the requested memory range. Similar wrap-around issues have
> previously been addressed in mincore() and madvise() by checking for
> zero length after PAGE_ALIGN().

I could not find that check in mincore. as far as I can see it avoids
PAGE_ALIGN rather than looking at the result for zero. madvise's
check_input_range() in mm/madvise.c looks like the one that does what you
describe, and there a zero length is a no op. am I reading that wrong?

> Finally, address addition overflow (start + len < start) is currently
> detected only inside apply_vma_lock_flags(), after mmap_write_lock has
> already been acquired and memlock rlimits checked, improperly returning
> -ENOMEM instead of -EINVAL. Per POSIX.1-2024 and man 2 mlock, arithmetic
> overflow of the requested range represents an invalid argument and must
> fail with -EINVAL before modifying VMAs or acquiring locks. Note that
> apply_vma_lock_flags() already contains:
>
>     if (end < start)
>         return -EINVAL;
>
> but this was obscured because rlimit accounting preceded it.

I think the errno also depends on the capability today, ENOMEM without
CAP_IPC_LOCK and EINVAL with it, so maybe the changelog should say that.

I also wonder if the wrap around part should be its own patch. the
silent success goes back to at least 2.6.12, so there is no commit to
point a Fixes tag at, but it looks like a bug, and the zero length
change is a separate behavior change that should not ride along with
it. a Cc stable would be reasonable for that part. if there is a POSIX
reference saying zero length is a valid no op it would help, or a
statement that POSIX leaves it unspecified, since EINVAL would be the
other defensible answer.

a test would help for that, len 0 with aligned and unaligned start,
ULONG_MAX, and a start plus len overflow, with and without CAP_IPC_LOCK,
without it the errno matrix can regress quietly.

the rest of the helper looked fine to me.

> Introduce a common check_mlock_range() helper to:
> 1. Return 0 immediately for zero-length requests without taking mmap_lock.
> 2. Validate intermediate and final arithmetic additions using
>    check_add_overflow().
> 3. Reject lengths that wrap to zero under PAGE_ALIGN() with -EINVAL.
> 4. Detect start + len address overflow before taking mmap_write_lock.

--
cheers,
jose a. p-a

