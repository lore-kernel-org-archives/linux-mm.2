Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55DEC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5546B009F; Thu, 20 Aug 2026 03:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D636B00A0; Thu, 20 Aug 2026 03:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9D96B00A1; Thu, 20 Aug 2026 03:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97F3E6B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:59:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD7601406D7
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:51:32 +0000 (UTC)
X-FDA: 85120878024.27.8C6380F
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3114B100005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:51:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gbPEIFNF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787212291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aubUlSmlXjkX3Bgl9N+4ElSNYDzF4BIKWVw7IgpYtfU=;
	b=pbFhOOa0D9mypmiSCQkTY0OQIZ/SbjZcTXusuH0+hLYKL2dEG9XvZooRnq2OEVT68E7M3/
	ZHfnRIP6P7SvbkpKhO4Si1rEoDVujXWyiUFCmRl5ySmxBdUe7JK78N57bLNVNle26c2OKs
	/TsESAA45g7pYZl+lS6jcOenritzzRY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gbPEIFNF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787212291;
	b=D45UvMUc9mUNvjLX0KBGsyFn1kgqDzZ8Oy6uPZek9mJkcgmx/wfX750dJDC97ZuuEp1/4U
	xi4hYo8JGV3qbIaDDzLsWECVzkr9mLaReQig0+Hs7szO15YEp0Wo86G/T49q2bzKEitCV1
	5Mvq+6Rpz2wUORoURRNGFExYthX/YVw=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so2641656a91.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787212290; x=1787817090; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aubUlSmlXjkX3Bgl9N+4ElSNYDzF4BIKWVw7IgpYtfU=;
        b=gbPEIFNFInX0yi4I094wQV/pd0OyCgTvAcKZt/sG2rQ+3V42B/S6+36tT4pfzoM82c
         0Eo+spcl44BP3CL/g9tBYiqyI9Wd4EDh1mGFryZAb7q+6/sOtnGS/kYt2bqOg3eUYDek
         Yibrn2K7HiVXdBO8MBRVNKPgXKIcYPHOdtAgBaHnCMiG5KEZKgYxDGuTyD3y0ZTEUtEV
         UCaJDVKvA+TCN7ZJir+2FJmtINw2qSRHBuQlGYXTn/vvjsiDT12guapNUzxypVECmB0f
         YRamcKIzAFdJWukyaabR4qX9bWoWq6LFfdBbknTpzf4uoXNKuxNvA9hl3FYKE6kSgGVy
         dR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787212290; x=1787817090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aubUlSmlXjkX3Bgl9N+4ElSNYDzF4BIKWVw7IgpYtfU=;
        b=p/sQQThn9Ts5xjZj+FZYZY9xUJ14Wb9tR+F4du+DfS7PYlAqy1HHDdLRMyzYJIKYy4
         0Yj4jjzwBhSf4IIvM8JlvOWLjJFFRquuvcHBG6nkNRGPkNtwviAdnexj6sfIE7g1urde
         TQDZJJOJc2exLGp2NovT3q3B33KFdexots5jS6rU0dkj1pj5aTaTt3s15comh2aKzRMJ
         kj4j38X3uweFNYCCSBN2DjZ9vgqIVxqs87LgXFsHMgj2xh8mE5e4gmARbqAY0/vj8ZLi
         6apTTSqyYG53N4jlwjRuqkqE7d9MCwkViddhDq0LBMNssPdKFYteZFx6n0yThnV/o7Zb
         4vnA==
X-Gm-Message-State: AFuF++ng6kz0xwTtxIiNVjcQ1D3Ixzb7Fclu8/IfIgL7cM5t35dmDro+
	zpBSBR1YMn/L9eBb6t9TYuV03vRApjMzLEkxPFUcnaB1rr8zzcsy8Pj2
X-Gm-Gg: AR+sD113qR7M0Z60wNECWWiugonoeaDba3qmjvwO66qWLEhYa3jNutAAWjRQ99Q6zv9
	0i7xQZ8KQ/dPTm8uFOj6Pq4518fZ63EVZX2bljpdQgnPrGl16BmsiDX+vo0IFrvLYCvkXXeqS97
	IOSzV0RcXwjdIN8IVYYUzhR3N90LBySN8j1D0slbEMGzF4axPYapU+rp8ufZNqJouOhVqPFLexk
	LCAXwG15AemCndzjlahom6nEdDBcFcibMIVCDPIG0S0JgFS4OWJ1ISRdWgzQZcxn3HOieeDpmcu
	Krh0qlpzZoz8Rvk7NDMQRhrQV+A54Jcok9Lw6xcQy1EPVTD1xaa0BQMBU6DEJcoRriLTtPLjmcs
	eQJaYTTR4NlzQ0jnH1YZP30OBKPbx4bbiClZ5r6f0H284fQqSpq7TN/DmFBmna/xKJ4BfqsQTSZ
	mnRK7PlwG/pNg8/4ec+wTtWQ2tEupHDtuEVxp5DYNQvjRcl7TtOysiGfQiI7tW2fij42Qfuu9zx
	+8kkZqzX+iqTFvshg==
X-Received: by 2002:a17:90a:d005:b0:38e:6aa7:68ad with SMTP id 98e67ed59e1d1-39580aa33d9mr20623185a91.5.1787212289904;
        Thu, 20 Aug 2026 00:51:29 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395ada67783sm455429a91.3.2026.08.20.00.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 00:51:29 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH v2 0/3] mm: memblock: fix debugfs flag reporting and synchronization
Date: Thu, 20 Aug 2026 15:51:19 +0800
Message-Id: <20260820075122.3294367-1-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3114B100005
X-Stat-Signature: ebyn7948gr7uuaq16bu8kqs35xsnen3g
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787212291-262153
X-HE-Meta: U2FsdGVkX186tr6BItGxHEFARXPiZhcCmdIFnTXHOgUW2oPQ9MI7mW+HbnlDWBR9pcer7KQbZFxY5jwVfMvukX2WWLznk2blP8QHHC1I/SlDIN4PvPikO58rF7l87+1KCOpvRu881wVV8bdHwcA6CEMXXzKBpAo37Ly7IrkvIHyIjmoCOyhISXnPr3BiYDQIfYYqsegbisqy2DP9OeN4A4ifLVzgK9OJxD3fcC99JOCQDu1GZpfOk0ze2eS4khWAFYCPft6oPHya2AoQrWvobeqS+4ysLqcrt/fbvg3/fv8hkeWSfQ4x9Vji/HXiRkVBQAOQQUTWv1z9gWrtP0Fq9VgFPf822NYWFDECGD0WgzRXlpa+yMlERDKNOZ6rXqg7VAqUpBrU0BcGTu4oFATU/khxfZ98CM77mDQPEookMVcPOkACW1eW2lY6uIgqmhTXpDkt+1MV70mFlUU1GapnFnXwJrUf93e5v6eIrZwHyBBrdfIOc5kh7erxvN21NF9unY+ZsbWaCyisgJeHJENaoqQFiovPq+1csQyQhb9mV9LsLegNEOoYiZF3DqhQ36sA2VaQHOP7AbEtsQPbZdZMZH+u9pX3N2Tx8aFXeQeV0wF8v+d0vdj/UVVlQViLTMAjW9F3BBFY14pR2BhzkEr60ruDwDbuDKxbpCofEV++fWDDDXJXpvD7v1fU3Y9OnS0pD3xslHsJvuCvs6g26F9/EldrWJl22tk7+t/KHrle/onFEiNPoxsnD7UekUBXYm5qhBAVJeChdCZ3BTPjdRK/i+RYhzr6or0mjMDNScf027A/asO3QLCd/gNlIqxNdnKJn5fq/wdc1mHMtsq7D7MQ8nOFQ0M9ZBiKwW2XbCDfmVjVA8W1pFmwDfiw9hLL61h53c8re8H3Yswwe9upzAS9QUocZXA1On8KCgWEeQSgOtREsZ8VX3itOKLNH81ANtGqF9tZDDfaBDv18OJ1JnI
 XzFSwm+y
 BM6g5B87I3wDlzhpfMt9pVYqab+L2Vb+7t3AXOwRBMKseSsBrDvkZaI32N86N7a191XoEFG8EpOEMUhPvL0+wmw5QdMiQ9/8VnwNn1RJFnk8sNSN63Jp12vME1Qrcxe6uZMCEvc2OSemC0I0yD5Avv0d9FPP0Ea02hZQBWM+P4h15fBJ+4ePIJZbu5YBIPSAyV2pVO1DA885BQhF8rSndSJVdBGfaA3wDoTlTQi71jELLHrqQkMSUaw4B5ITDx2i07YsTW9hlzBpZHBmMvR5l8gz6jeW0fLpbPUWKJ1wK+qB+T/x2qhHZWD6YLL+ANrcOSwTT2aSOC4mSnrhqsNGTlJ+t/znyA1ExW5yrXN6jc0Tl5Z3lcmPly++vWRvL6fKeeIt4LLvzI0OEX80GM4MXKNaoJFszJQS1HxOe/sHRtCksyJR6c7iXKXSWNEoCkmCSJ2A2868P1Q8uHHM8KpnQN0ZPrIAy6q5I/nvQyjB03oPhp/M945UWQl/7Dq96necQGRB5hgK86ARhX/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

The memblock debugfs interface has two issues when reporting region
flags. MEMBLOCK_RSRV_HUGETLB has no corresponding name, and regions
with multiple flags only show the lowest set bit.

In addition, memblock_debug_show() walks the region arrays without
synchronizing against memory hotplug. If memory hotplug grows an array,
the debugfs reader may continue accessing the old array after it has
been freed.

Add the missing HugeTLB flag name, report every set bit including those
beyond flagname[], and hold the memory hotplug read lock while walking
the arrays.

With the series applied, a HugeTLB bootmem reservation is reported as:

  RSV_KERN|RSV_HUGETLB

Changes in v2:
- Report set bits beyond flagname[] as UNKNOWN instead of ignoring them.
- Add a separate patch to synchronize debugfs reads with memory hotplug.

v1: https://lore.kernel.org/linux-mm/20260819075422.2387980-1-zhaomeijing100@gmail.com/

Meijing Zhao (3):
  mm: memblock: add missing HugeTLB flag name
  mm: memblock: show all region flags in debugfs
  mm: memblock: synchronize debugfs reads with memory hotplug

 mm/memblock.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

-- 
2.25.1

