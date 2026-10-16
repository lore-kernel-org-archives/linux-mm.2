Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28038CCF2C2
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 19:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B8D6B0088; Fri, 16 Oct 2026 15:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6876B008A; Fri, 16 Oct 2026 15:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE3D6B008C; Fri, 16 Oct 2026 15:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B80E6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:53:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11D8D16061C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:53:18 +0000 (UTC)
X-FDA: 85329538476.14.9DDC14F
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F7271A000D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:53:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PdkNRkrL;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792180396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/z+gmg3ANTK0WEq9y6k4IA7I1dnFgvIT+G3bbMJhDg=;
	b=4pwWZWUqw2ZR+jATRs/QBm9G41fFUN47fPUJfum+vs/tUCR5muU546ZtMI9CGuPCt8feHH
	t7AkTyBEItn/w+4QR0JvMqrzR9U1UM1GOfD94r7ZI7FpWpfYjJruMbHv06d6UU8mJT8e+F
	DoSJUM1kdDhEvoc/uMoNDE1TfDg/smc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792180396;
	b=yUc8q0oyVy95yFn5y218cYSBkIS4LEScITorLBETteJyhpV0rY0pnKpItTnmxTjBy9jDrk
	B2Ghyxk/zDW2xpFA2SyRjYpbTwsXiCO/pJRDfV+D+Hx2j+ASqH0540p5Qdl3dP8bn+oHqZ
	LwghLlLnzxM3erqQV8FykbDWLBM1TMg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PdkNRkrL;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-16079d54c17so548269c88.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792180395; x=1792785195; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f/z+gmg3ANTK0WEq9y6k4IA7I1dnFgvIT+G3bbMJhDg=;
        b=PdkNRkrL8ofB9+BcrX15M0e8tUQGpKZrIYgw9CsRD4YsQcDw6zfxmBgLOJ4m+icRnf
         3RPvM4K6f7UMNxTyxAtPqtC55Y1cEgV8fWbU2C7g51nR7ULhm7tya/s81KrNhfODft+U
         ywy3vNRUQsS3871DKx51Lelo0PI2KJ+EbP8TLidJy90KaArdkXrOHvzAAzYGRgaBvc8x
         datS1/u9b0HpvJK/HUPIWSuqRWcxRExYyMZQ4qOorx1xkbz0AxZOXG/HAM7ZP7qzdvIT
         qvNyrgzqIIpjAuXqnNc3xO3tKnJ0pxqzyJowlew896l/Fa9HjWdH9L7UQi2PTmflKzzJ
         3YGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792180395; x=1792785195;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f/z+gmg3ANTK0WEq9y6k4IA7I1dnFgvIT+G3bbMJhDg=;
        b=xJXaPV9c+ruVHcOWSTy3VJT7xGc5B1T3fmEIx+2IRvBsda3QschtiMyqLXjFigHLQp
         RmYPiHsAALnRcFtP8grc1ZLBAHddfQirj5ThGYo0WiexxzH5XE40MnF1LAgxVE0IRBW5
         01P3MJDzE/GFT7SuHYwvfRcjxI5mYATMD9OhqGF31VNcJq+In5AQI2B9tjhcN0fxTxHs
         fbV3GBJQo5uJ7JbAoP8qFpI0AyRxQ6Z2ouWv2Nr/+rOwW4nhgsakLLD0xINaWa3TB6yV
         oQ7uhpNmI2chP1Qv/GTqeXqHlu8GTQFMJ4kcBmRMkFICWHLbXKL2aJ40PlIe8xwBVeTZ
         Kwiw==
X-Gm-Message-State: AFq9FYK2gXQiId4Z2ZdYo0EMGy26WBkXH54Hu1plrhoaznYOapzFxnge
	s7XPO69AZ4LArrzDOUZkiZvJ5C6Y/nVVKDdSnbHIhz0Icu7ue6KF7LTI
X-Gm-Gg: AYBFou1WFcZfD2aWBVCSpyq1y5dtrqL+BOEXIbbKr+TDBPgSKrCnxzS2cDhOTmRTiCx
	CIN9G+aw8so49FV9kpbmX7LXCLl6vl1T1AyUFgoB4Las96+swUWweGklGEGq/n2ZARy0c2NeIH8
	GdxQtFyBA+2vtsxHfGrw7FltXGZadsS9lDb0rRvrkhXx5rA5/SYhxc0ktSHsCYBO0NA0HzxTakg
	gNk1DGMxH/IhMgmD3jE9hr94eYBQs9kbxoKrC0LppstYM12txAduIf5QBAX3QV9TOzWMd07xCpX
	3EmLv9KxwXVXPMfxaql+shzS4UhXR5ZkZ7u1fOBMZROj1ZuLafOZXnM4HwVX+E9BBDGL0JC0Yws
	bdzsg3t8N0aa8ePkmBHBG0Aq1PPLx+mSW7lb61TtgQx1ylrxYwpJVn+rKJsORFtVoYouiLqnd1v
	Ted35+I2PqCEBWJXD+yiLghqq7CvyqLg/lD4pKsfCz71cl3Z4heg21z9phXm/XUfxTzE2rqcpgV
	7+8ATgxoDG/viBrYPJwgmD3HBNo/8nCpz4DMkHSntY9lh4Uw9w3MJ4D5XHpPcTFIZY732j2E1c+
	ZYfjpRED/fw5evsUoxzHuA==
X-Received: by 2002:a05:701b:2608:b0:183:4719:5c01 with SMTP id a92af1059eb24-18513e7c69fmr962623c88.35.1792180394710;
        Fri, 16 Oct 2026 12:53:14 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-185aaea8b24sm174511c88.19.2026.10.16.12.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 12:53:13 -0700 (PDT)
Date: Sat, 17 Oct 2026 03:53:08 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, baohua@kernel.org, 
	kasong@tencent.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <atJwMRHXzXc57qpu@KASONG-MC4>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-4-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901063755.1519710-4-hebaoquan@kylinos.cn>
X-Stat-Signature: eujpxiwy3az4bm1c3u4n3oiicqqz487e
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F7271A000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1792180396-798559
X-HE-Meta: U2FsdGVkX19gbmdavX/0Z3/F8aazVOjnrKoM362rG8UxqxCtiZW0K5HYdxTv1urPA/zO7vbV7xUu2HJcil/uV1oW/8rvwaatEX7VPY/585JXYvCsWqOmVy3QdspiWwVVO+bREC9Op7VmKvn6Lw3eiMnBBSqC7EhvkipzwPx0GiqjX9B1ejQilff8uS0QSEqvrhCTwbxjBt4CK0QYiJiG3yXWp9rPHHEmTvchAST9l5AftFM398Y6RPlpHdGzRS5oSHIOtB4c+gxsw1Ywoo3a9GlWytSauxrpDxFrvsqPUoGIgJDvcesD/h7oNn3rUFn0xonnMvb8w3sjRKVlgzLTiU+4Fk3SjXS+Fbz7I1Untg/9KGcW+GfZlV8FRIvoOiTnscwFLTO9O5ait3H0FDCzpcWkyHKXh4CJyAV/0KWo9xIPpFVZu+v4z+uHvDIEhWe9qMnpFN7ywuLvLAAfxqhAjLu8gYiinu95UA6T36nipMOV9ZGUZXG8dh+74ZRdB6fbodk5qVeUgnrLAJ8JvcuHAwQ8vKT8wGtIQoFod+FniNGyzppK6/FO4aCoYSzI7pSqQo8JL6Mi++aA9YuWqO+C2QqiD7EVml5B0OWnxmes9VCvpcx2L4GHUBEOmwEZQpR3Wk090RGUIDbrkXOcq2NlyRokcJytutwpNY5dHLGR0qbzRGq0GZjgI6N9CjujXLynvmgO3m7NQANg5FxkgxrZCAPDdytMhS956M/YDM8GvQ4+6X9WGN7KbFeBhrUn9ou9Bxl/oI9ns8CtxOnM6Pjw1zLyLHdjKC9ePyTd/gCTsHZscIHXe0ffvQcxyBZUVHwBfMCoHOoXlteP7OcFJFKKURAzHyP5l2SCMFkPq/4CSLf/+gYK5wjmxClpEz5ozhlfV43c37GDs9WREEepbhLNsneVlfJ3DTpRM8KMPVwzo05uEJr5/IPZuw2Fmk5RbPt/LMBxKTnEmqVvD8uNPtC
 zgwdGh1s
 4pQH+IcfFWi4s4b2l4CVQZw4D1eFnz0chdjrDCLk0bC9pKzQ7eiIr/ct18QfwGlxReRbouQF/Raa1rE49akZXfTZ7mZyTcwR+XHGwzboLTDdzy0r1tF8ePgjWlTkPUB799VABYTahZ+YGaByRuEzMqw0ANpy/IFWrEnYZrJfcK6CrrhSGk0qEahp1X0kP5yWrymxvUk52XQYI9QITlCf7YObdCkw0IMYGO4kS/21ioTHVB9BSyE1NLFmmqQYRfIc/gWPYYFwhy3DqIrodPSwg80gixxQyluT8xweca5LFIgnmWAb/ZST/1dSOF+xtMVTHDEoMMWVFd5xyCd0kaT6Y8QbUh/7M0ue5flsaQy8sQGQJ2IWkMKayEImKb7+yIDgH0fb6Hw9LXbLigLX2pvw5ue/Hn7zKJw41sIQvdxCs/ILKLZ2pmzVvkvbBbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 02:37:54PM +0800, Baoquan He wrote:
> The aging walks into every PUD and runs the PMD-level Bloom filter
> on each PMD. Add a coarser PUD-level filter (pud_filters) one level
> up:
>  - walk_pmd_range() now reports whether it found any young leaf entries,
>  - walk_pud_range() records that in the PUD filter, and
>  - on subsequent generations, skips the whole 1GB subtree when the filter
>    says it had none last generation.
> 
> The double-buffered filter flips with each new iteration, so newly hot or
> migrated-in pages are re-checked promptly rather than suppressed
> indefinitely. force_scan walks bypass the PUD test, so manual aging and
> newly added mm's always rescan and re-populate the filter.
> 
> To keep hot regions marked, also report the covering PUD from the rmap
> feedback path (lru_gen_look_around()), so regions whose hotness is only
> observed by eviction will be re-scanned.
> 
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 47 insertions(+), 5 deletions(-)
> 

...

> @@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  	lazy_mmu_mode_disable();
>  
>  	/* feedback from rmap walkers to page table walkers */
> -	if (mm_state && suitable_to_scan(i, young))
> +	if (mm_state && suitable_to_scan(i, young)) {
> +		/* the PUD entry covering the young PTEs scanned above */
> +		pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
> +						     pvmw->address), pvmw->address);
> +
>  		update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
> +		update_pud_bloom_filter(mm_state, max_seq, pud_p);
> +	}

I saw the discussion from Barry about the concern about the overhead

I think we can drop the PUD ptr walk entirely. The filter only
needs a stable identity for the range walk_pud_range() is iterating,
and (mm, PUD-aligned address) gives that on both sides:

   walk_pud_range(), test and update alike:
      (void *)((unsigned long)args->mm ^ (addr & PUD_MASK))

   lru_gen_look_around():
      (void *)((unsigned long)vma->vm_mm ^ (pvmw->address & PUD_MASK))

Will this work? Also I took a look at the hash algorithm of this too:

static void get_item_key(void *item, int *key)
{
	u32 hash = hash_ptr(item, BLOOM_FILTER_SHIFT * 2);

	BUILD_BUG_ON(BLOOM_FILTER_SHIFT * 2 > BITS_PER_TYPE(u32));

	key[0] = hash & (BIT(BLOOM_FILTER_SHIFT) - 1);
	key[1] = hash >> BLOOM_FILTER_SHIFT;
}

And hash_ptr is actually hash_long, 64 bits if we use hash_32
will it be even better?

