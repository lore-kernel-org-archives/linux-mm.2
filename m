Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F451CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 03:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E515E6B00AA; Sat, 22 Nov 2025 22:49:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01E56B00AC; Sat, 22 Nov 2025 22:49:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9856B00AE; Sat, 22 Nov 2025 22:49:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B20E56B00AA
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:49:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36031160A95
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:49:06 +0000 (UTC)
X-FDA: 84140491092.05.9CE27F1
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 460C540003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:49:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PsdddUJA;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763869744;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXsBhl22c1IQvTlRBqL+lM/+0Tdw6EnkyTO43xiSs+M=;
	b=VnSetw3tuCDTr/kQL5We+OVmbLKWaVblVdnQBjw4NrskhEd7eOJx4X/NdLrUX5iX0m6GAJ
	o69OJ/FQZiKQqtICGMJBUnS7G0ZorpPDSm7qrbKQD1fsdByJyy1+dv7fHUihoFySh6PFJ9
	2ZhbpQ34/DtdKnKy32Oniv0q6j3GGoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763869744; a=rsa-sha256;
	cv=none;
	b=4nsTLj/VJ8ZHT7BkPP+GCpC86gDvYOFx9QMPskSeKaslJqVhnB7Bcrhf18q4StmNxfF1Va
	cO2Lap7TEDAQUbnnyqXq4GG8gHL0rN5W2wed+4rzUOQ1PkNvvRvyMC6RtSmSKYBSvkBGJP
	RKThk3GOwTAFXOpWimSy585qjoZsW7s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PsdddUJA;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b32a5494dso1757014f8f.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763869743; x=1764474543; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXsBhl22c1IQvTlRBqL+lM/+0Tdw6EnkyTO43xiSs+M=;
        b=PsdddUJA3XXRLeRKY9TsBrpsZNRoQ/BCwdO/RJJ63UxA7M3NXijIIT0bLUc/NP+y68
         lUyiBlq4YwSrkx2CnZ686lZB8r6u5p6sBAhqHDyZZsDtwrhMzxiFwugqmgh8/3DxzAsd
         rwe2yvek4AijL5ZNVi/ellAGFHWgEmKWNFtqR3MpyrBTnVhJ90odmUuvq0D4c2HlyrTd
         8/veVrOOuT07+PHyfH/gQyF4JMHEjUlYw64WB+0SwPY2X2K/y/g/g/2AHX3tzUUg72Kt
         yv1IxUOEo5j4wcOcWF1mOQccdflX3KmHGg3GZKnu41f89wt2nme5M6XWn9xe+qx5ikpg
         YXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763869743; x=1764474543;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXsBhl22c1IQvTlRBqL+lM/+0Tdw6EnkyTO43xiSs+M=;
        b=Gr/7++l3GqYOXlg+Sd/UBvz/Q616jl5ZtjrU64fdKRDJzfp6xOk1qqbnnDN9ksAIe5
         lsPGtJkJkTAawmzr08BLErJ7doDoFhSkTpUYdu9pXiWZTX67CQorTn7aOGd+fO0RJHGj
         FPpg0OyYWf9MkhL8CwHiVb8l2I4R+7Nwu2Ak3Uj4wJrA9v6hO/VKpsQI7K4ycZVL5JDf
         UZxCAvAba1hr3cVxo2fuRbYhsxKcc7upMlBY0/PxMlJoNYypBvP8hATmytQgFOmqNQ1w
         yJs99GTgYhGHCEeUPYx9lp3lJMPGaKLSqXyRoyqgHfl02zY0jLYL0dwxqvvN/sbYXoy6
         rm2g==
X-Forwarded-Encrypted: i=1; AJvYcCU9rFYNHu0okPKdPfpn4Slr3CxMXyIlUpMZr7soUWLYHFn/ZrdeIJQ+kstJCaTeIP4eUaCKiVztBw==@kvack.org
X-Gm-Message-State: AOJu0YxHGFhFJXUEq7+76h5sMTv7pyui/h0faxByFt34PpVtUUOFrmd0
	jS+ZOvveWQ972PfjIaxg+e51BlPkXFwO1tr6vwW8yO1HTHAIB+6oS7Te
X-Gm-Gg: ASbGncvFrheOIZfJowWkMmx+bZVrCr4XlZvnfYdJslnLdccND0ofBve2BMmz4wzezyS
	1SJfe2baVFFTxdaFh3q/0JlpWwq1gpC/K27j6U9sLCHigN1eQi/+DSFEqckcTceZjzexmaQ6q9F
	D3z0RUfpz4fSEnAHCQ1rw5ljCo6Gg0JUokJAFOmhTFDMvUwd1qTQ4l2KkQHUonILxTDISy6K96u
	uouH2sWP22UKHxZqs4ZS4WPttDoDca6ffpLuMJIPsLsucoVWu4NEEWq6brUVXbuDDOP0QYglphY
	RWVJPQj/QqOYhB4tPNy/qrpEqO+lmwrNyPT3zCoKiItD4jTp2DI9DBKrlEHZwRVlMsBjOtvLPaT
	bHjkpK6lqA7xY/wHABYneRj+yJM/A0S5UK8f9TCJzAVdcU13aQqTvXeJjwuto4DUrhmCHTHB4JD
	DH3L9ENvv5acxuFw==
X-Google-Smtp-Source: AGHT+IEbvlAKnsPBP96si9Xg/bJce/BPX2dyx8MBR559zWC8AHAjifETllRpS9g3zzpJlP7SUwQaJg==
X-Received: by 2002:a05:6000:22c9:b0:42b:2eb3:c910 with SMTP id ffacd0b85a97d-42cc1cd9466mr7001715f8f.3.1763869742340;
        Sat, 22 Nov 2025 19:49:02 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa35c2sm19232083f8f.25.2025.11.22.19.49.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 Nov 2025 19:49:01 -0800 (PST)
Date: Sun, 23 Nov 2025 03:49:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH v2] fixup: mm/huge_memory.c: introduce
 folio_split_unmapped
Message-ID: <20251123034901.nqza7nlg57ivobzu@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251120134232.3588203-1-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251120134232.3588203-1-balbirs@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ca7gwmyzwudq77ji3fir3g6yjj1ajx9u
X-Rspam-User: 
X-Rspamd-Queue-Id: 460C540003
X-Rspamd-Server: rspam01
X-HE-Tag: 1763869744-116218
X-HE-Meta: U2FsdGVkX1+S03s/8e4Mh6IQY7c4cT3/90EODAoVApU0t0z7xIy7f/+VQ3OMYAT40lBLNN3TMqUU84nECp62SG39A2OE9QTWSP5UBNncpLbSp2HT5dlV3fI0NdpyYyzrvT9ps6LVT7CNfhE1McFdFDX49NH96omzXDc9Y4/N/zIGrn3PC8pBQWH+m5mnwNTkHzFHMmSsaGeTSZWrEf89MCA3PHYCedQzwsFv4Sjmv1NZ21GV9X+vTgeEPGcqrfonbv/0b7Zb31XhOK7EHjrB9eDfLb0k/eYkKUAgNed8jS7RUxorgPQcKXDMWoClPlhjRf2t340TPER8TwEgNvfYqbhl5SQFDzpsx0izwHavZzTQ16GTX4xmSKjvnVynENiHx2UUN1oTDJQegOyX2ydpJymCYLYa0L6enWojbi/Xu/QMcYhMcCU2sWLnXcNsn8mPET5ZfwzzR9NNwaN7X9wP0i2zqdgQ4wf8nbvx99YKqQqWYVX3y9geCdnqbsa1GjxBbcI0ka4snClOEmEZ0cPWNInf7FHOQWuf6gz4naulk1ITZJqQlmeaNR+IZ9Z/uWcRKpO4wfXgJzOQG9Wv7UGVT7/vwJruQiLYPXE7Y0wO9F+f0aO1jR6qIFOtIQXPuSiuUoA2iZX2YV5sb+a90tg3voAB9E8VT7YZCivHlNDwQvocOPV4HWJKUBpDAeEGp26M+hsuqGjL75vuCn7ahk3Z3JerFUmJYM2Nw3eJ/OMo7Xbntyd+i0Heft4FNsFPR7A+dXhwv+9xOyYyyovp0FTRaVnOBxdg1GDcqXVH2h6ROOUvG6A82/JGRO6XkacqT4wDxhhqvlxlFeXqH1X53O8PVMsH4IKt8jdwd5UPFW6rNibSXj4ZONEo0ibuE5+/YVjf7RgbfOGyQrhvjSNshD80ENo1cPpoMON6hMkbpxya0lqa7wv6ewbbJqAY6pK5XMe9u7xB1mPkQO+ykXfnLbZ
 7//teU9I
 BCbzMrqJOoUSBpbUKt9XRUqH6f4KYgURMam3hcPAu1/r1vREkISdY3IozK5uVG+LCFiNrcsdXHPN0rzGp8RZFlqYxaDfagboASfjfFkmjax+nQ/QZ12c+ubQrHhp3FDafsJOYzqAI4OCnzZAYGKwTukecmhLQKft/HncAQO0N+jr8lQ2kDguAtfeBjlWwFdrvQ3/4pcBOujYZTwWg1XHm2+5jx2IsihQzploHdN3V0XQ/eUw9rpHVIeeSmNi2KeskBML8kZs8MWKPs6HFZWEF0qu/0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 12:42:32AM +1100, Balbir Singh wrote:
>Code refactoring of __folio_split() via helper
>__folio_freeze_and_split_unmapped() caused a regression with clang-20
>with CONFIG_SHMEM=n, the compiler was not able to optimize away the
>call to shmem_uncharge() due to changes in nr_shmem_dropped.
>Fix this by adding a stub function for shmem_uncharge when
>CONFIG_SHMEM is not defined.
>
>smatch also complained about parameter end being used without
>initialization, which is a false positive, but keep the tool happy
>by sending in initialized parameters. end is initialized to 0.
>smatch still complains about mapping being NULL and nr_shmem_dropped
>may not be 0, but that is not true prior to or after the changes.
>
>Add detailed documentation comments for folio_split_unmapped()
>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: David Hildenbrand <david@redhat.com>
>Cc: Zi Yan <ziy@nvidia.com>
>Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>Cc: Rakie Kim <rakie.kim@sk.com>
>Cc: Byungchul Park <byungchul@sk.com>
>Cc: Gregory Price <gourry@gourry.net>
>Cc: Ying Huang <ying.huang@linux.alibaba.com>
>Cc: Alistair Popple <apopple@nvidia.com>
>Cc: Oscar Salvador <osalvador@suse.de>
>Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>Cc: Nico Pache <npache@redhat.com>
>Cc: Ryan Roberts <ryan.roberts@arm.com>
>Cc: Dev Jain <dev.jain@arm.com>
>Cc: Barry Song <baohua@kernel.org>
>Cc: Lyude Paul <lyude@redhat.com>
>Cc: Danilo Krummrich <dakr@kernel.org>
>Cc: David Airlie <airlied@gmail.com>
>Cc: Simona Vetter <simona@ffwll.ch>
>Cc: Ralph Campbell <rcampbell@nvidia.com>
>Cc: Mika Penttilä <mpenttil@redhat.com>
>Cc: Matthew Brost <matthew.brost@intel.com>
>Cc: Francois Dugast <francois.dugast@intel.com>
>
>Suggested-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>---
>This fixup should be squashed into the patch "mm/huge_memory.c:
>introduce folio_split_unmapped" in mm/mm-unstable
>
> include/linux/shmem_fs.h |  6 +++++-
> mm/huge_memory.c         | 30 +++++++++++++++++++++---------
> 2 files changed, 26 insertions(+), 10 deletions(-)
>
>diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>index 5b368f9549d6..7a412dd6eb4f 100644
>--- a/include/linux/shmem_fs.h
>+++ b/include/linux/shmem_fs.h
>@@ -136,11 +136,16 @@ static inline bool shmem_hpage_pmd_enabled(void)
> 
> #ifdef CONFIG_SHMEM
> extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
>+extern void shmem_uncharge(struct inode *inode, long pages);
> #else
> static inline unsigned long shmem_swap_usage(struct vm_area_struct *vma)
> {
> 	return 0;
> }
>+
>+static void shmem_uncharge(struct inode *inode, long pages)
>+{
>+}
> #endif
> extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
> 						pgoff_t start, pgoff_t end);
>@@ -194,7 +199,6 @@ static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
> }
> 
> extern bool shmem_charge(struct inode *inode, long pages);
>-extern void shmem_uncharge(struct inode *inode, long pages);
> 
> #ifdef CONFIG_USERFAULTFD
> #ifdef CONFIG_SHMEM
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 78a31a476ad3..18c12876f5e8 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3751,6 +3751,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> 	int ret = 0;
> 	struct deferred_split *ds_queue;
> 
>+	VM_WARN_ON_ONCE(!mapping && end);
> 	/* Prevent deferred_split_scan() touching ->_refcount */
> 	ds_queue = folio_split_queue_lock(folio);
> 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
>@@ -3919,7 +3920,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 	int nr_shmem_dropped = 0;
> 	int remap_flags = 0;
> 	int extra_pins, ret;
>-	pgoff_t end;
>+	pgoff_t end = 0;
> 	bool is_hzp;
> 
> 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>@@ -4092,16 +4093,27 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> 	return ret;
> }
> 
>-/*
>- * This function is a helper for splitting folios that have already been unmapped.
>- * The use case is that the device or the CPU can refuse to migrate THP pages in
>- * the middle of migration, due to allocation issues on either side
>+/**
>+ * folio_split_unmapped() - split a large anon folio that is already unmapped
>+ * @folio: folio to split
>+ * @new_order: the order of folios after split
>+ *
>+ * This function is a helper for splitting folios that have already been
>+ * unmapped. The use case is that the device or the CPU can refuse to migrate
>+ * THP pages in the middle of migration, due to allocation issues on either
>+ * side.
>+ *
>+ * anon_vma_lock is not required to be held, mmap_read_lock() or
>+ * mmap_write_lock() should be held. @folio is expected to be locked by the

Took a look into its caller:

  __migrate_device_pages()
    migrate_vma_split_unmapped_folio()
      folio_split_unmapped()

I don't see where get the folio lock.

Would you mind giving me a hint where we toke the lock? Seems I missed that.

>+ * caller. device-private and non device-private folios are supported along
>+ * with folios that are in the swapcache. @folio should also be unmapped and
>+ * isolated from LRU (if applicable)
>  *
>- * The high level code is copied from __folio_split, since the pages are anonymous
>- * and are already isolated from the LRU, the code has been simplified to not
>- * burden __folio_split with unmapped sprinkled into the code.
>+ * Upon return, the folio is not remapped, split folios are not added to LRU,
>+ * free_folio_and_swap_cache() is not called, and new folios remain locked.
>  *
>- * None of the split folios are unlocked
>+ * Return: 0 on success, -EAGAIN if the folio cannot be split (e.g., due to
>+ *         insufficient reference count or extra pins).
>  */
> int folio_split_unmapped(struct folio *folio, unsigned int new_order)
> {
>-- 
>2.51.1
>

-- 
Wei Yang
Help you, Help me

