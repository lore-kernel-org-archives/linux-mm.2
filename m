Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4121CAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8A98E000D; Thu, 25 Sep 2025 10:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78848E0006; Thu, 25 Sep 2025 10:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E7E8E000D; Thu, 25 Sep 2025 10:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C98208E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:33:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7748358505
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:33:23 +0000 (UTC)
X-FDA: 83928015486.11.75F7DB5
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 967261A0014
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:33:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cvLhVUas;
	spf=pass (imf19.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758810801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rovQXBMGlH+WdMko9tBwUJE7c1iL7Sj9W2ARd93iF4Q=;
	b=eRwXakw+Ji7pm85c/7Nxha8RxhS7sWJSAv8tNWoyAjx4b6ZIFLvyhKph1HUlsgg19uM+f5
	y4dzoOwr7QW+L+15EZHVyy1bJjLpXABObfTAR1veb1R0I1wB4cc5inDKcXWtyYVG2Y3HTA
	tvW78IIsYa+7iwztcmiLGfSIswdCwdk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758810801; a=rsa-sha256;
	cv=none;
	b=naBy3JLglDuSllfctGZCwvo0uaqseMHtQk1wZqiriPUdQuMeW0R0WHqBCJ7FpujgrlTHK7
	32aSsSlYuggu6MYgyN2uD3VDIcYsYZ7ierSoiKfOTQ+BoK1gAOWdYUBPQb2jmtmPaLT0SS
	mmI/gMz5fHDQK/L/gXUPqjtIVKlFsPM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cvLhVUas;
	spf=pass (imf19.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3322e63602eso1372843a91.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758810800; x=1759415600; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rovQXBMGlH+WdMko9tBwUJE7c1iL7Sj9W2ARd93iF4Q=;
        b=cvLhVUasJYuK5VDOCvvX7qrphvNi+TaQVJqBGaFSqpuyq5LXqtf8bih3uO69xgr8H6
         954kLgOBj+5hrJDp2AraermnHkGbEmNHiG94xyXd9a8b+q7UAzRulAEDNa5ZsOo51fD4
         yhBqNTtsI8OOPHw6iE7iMClGPKhzA3jGq24kZ0ksbKTPkKOrT8h9rC2VMW7VexiM+zWn
         wvRCN3ycFZ9EpTH6fsjwSJAVKFT7GmLNR9uz+y/Vl54BdWels+ikpZkhwv/XnrDe8ywo
         6i2Np2k+6IUshLNSaI26JFiEYkCmrOfumFs1xNMauISFsG9hzet2/qsRdgBIDhL2Im5S
         dmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758810800; x=1759415600;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rovQXBMGlH+WdMko9tBwUJE7c1iL7Sj9W2ARd93iF4Q=;
        b=cRxYQFt1tPkeTWjORmQbmSJ3QceO7rhWQ5HDjimwSkvsmRD3fn2K7pJPGqsXUegjfQ
         o24IR7pcASD/Xchj/wPiC1lZ24pe0tyUvtw82hoSIDj/9CDM+/J34GLc96mk3ULIWvzN
         tpn35vFhzQxUKqFl7qUQzCnB8FJf+FkjtUmIVVpxnc2z6a/+ixow19V86GKsjF9f0P8Z
         mP0w3woFNnNEMUJgHdtorH1vEcEMxBaMcxwOEKRONM4Z8nWpbUk1aY90rrNRnc3K8nLp
         Q11i36/JTtnf9A6dUTvTEA/Zgdf+EMr8gjxf1sA2KWZzRsm6ACSrmUQkA9tsqywktBKX
         Q04g==
X-Forwarded-Encrypted: i=1; AJvYcCWHP1kwQHfQYy9Fu7h+lEYYiGugu9TSYP7lDEbWSlp1++VBwC6JPgOPAWfekaxm2BWCz2HXyyQLjQ==@kvack.org
X-Gm-Message-State: AOJu0YwTEqcZatNM51iBVf+SLswxM4qgYbOL2XwCqxI/Vdkg8iABONXq
	xol2X6EzVt0DVWiT1A9s2NCKepnGzc7q+rCvD+nRgL3z/0KbM3BqaICk
X-Gm-Gg: ASbGncuNewYTNzRG5LGbUGSHWo+UEYS6mrU1Udj4+BCuR/mztzywCp2XWMcX6MyuerV
	bLE6GQX5/CvwZxJkRXgG94yvdhXteKouZrhwcWMHfdOjpHmfCD5dX5SxbpHbU8jg3vNLQXvsAva
	Ak7iqkX3A0izToaYUXmmKSjm1MU02C1Gm/vNpnDG1BKcY/o5UHbXVSYhrDCdzLKj1F7+2HH/Dyd
	rpASTxL2zUpDkuycKGVOegBt+Ynvkt0AqOAfH4wJmASy0CFVaxPdHPg2DfDpia7iRlpna1hdHag
	Ud8XnEf+y9/Rf+DlgQxC4gHyZdI9NqrBRNRmGcQIKO5OS2d1UDefnsG35S2JhGLkdV60xXTgjb5
	YMWsdNIhga42H/eO6FwPG3yseGF8yZxoHQC+H54TvC7idbO601mENUDjNmh0DjfDOt5+MAsp4/u
	VwSS/CL6Ut45lA
X-Google-Smtp-Source: AGHT+IHSDckebz//1CVV5rONYtIqOlPvAVcv8Lm81NXrtrXR1QF/SkRc6vOphHtEvl8rAXgjaL9smw==
X-Received: by 2002:a17:90b:4c12:b0:334:2a2f:59a9 with SMTP id 98e67ed59e1d1-3342a2f59bemr3860265a91.18.1758810800294;
        Thu, 25 Sep 2025 07:33:20 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:3094:63df:f80:7856:8de9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33471d735d4sm2645767a91.2.2025.09.25.07.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 07:33:19 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com
Cc: akpm@linux-foundation.org,
	mike.kravetz@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: [PATCH] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
Date: Thu, 25 Sep 2025 20:03:09 +0530
Message-ID: <20250925143312.149623-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 967261A0014
X-Stat-Signature: 8obamk8ze8n3yrmnzirx5jg8q6zou7fs
X-Rspam-User: 
X-HE-Tag: 1758810801-965591
X-HE-Meta: U2FsdGVkX19Au08wrljAMqqrjgbae1klOfJdn1i58OUd8dKILi2wol/HtQcnGRZuZkGPw/cMjFgGwIa2PS3M7U6FYohCivA/bV023xTGUbC+A6yfpRp1FzKdC1HNa3EOOI1SvpAu/kZmmKXwOPA0DzqE8cNPp+NMBbpc6B0eYLq5ze4OjtrCfHWKpExOQqdSY3dj3cbM7aRF+Kr6ef1fV+htLbTEnyerJEqprEAURfbKD05lVGmE/iEIw4YKEsyyHzcUxIl09Cc5Md/icB45yx/+dsqIoRUwgctEq1x7W3+CtkkK1zcDoCAxME/tMu/7tDJJ5k10X0Hh1Jyi7lLjlAtxrcYHNXQccT5nqMOMKlt48vY3LQ7od9UjnqLK6upZ69VJxzxCUCTLuzfAYrL5uqd8wqR2RG3r+mXfbqCTCPkK4YsoY+77kdFT1Ms3wPxtjMEHIHwyCH4E/jYboBjILGjv9A1KcATmGhqoSbzpQZpGidgG3sICpj+JEQ5N5I9nZ+Mgg/87C1QSyw/KmMPJ+TgR3UBMfC4U4sf9UgEs0Xw0f7wqxP7P2OEw2G2COAVcus3hf0xbXg0JJVQDU6yh6S69u+o6o3PxSMD27D2O9Rl/Ck5q7b8IGhj7P50kHdc6xhrYlE6yz5TT+nirgQd54CA0YaT2OTayGP4IcE8BwS4Bit4qsQlRS9ZLRZmC9qnW/UUbPlNYto9QQ90ie7W89bnz39Q8Wn4RbHmIcJ+qY4Zt457RBeLz456bxIeTnbq7MfHfiSgvKfmWjKBB4FOsWWfFC9/qbA4/Wi1BOnRN+DPFWCfhu1HGdxV3eTVHJLEQmWDoI0mv2sxAsxF4WWBXe+s647kPYKOFrkXXuI7I34VqYUQusVZV7W81hNp4HkTFOlyHo1WqgsuL9TZIAAQ8SOuQVu6qK2vjQ0XLD+eDURqXpL4qKtL8MctG+CHRCeqgEb7Gx0gU6C+qe6xG8+X
 rIflmL8b
 XiGDRIuEqBXKo6ESu8wt9ZNOg3gvDdsn03nFxJmDmf37reTGrLWQ/fEKExAD9y0VtB6AMAEkTQiTsE5N5507gm3iAZhSSDoCAwCI7d+kQXy2WuV/vgU+veeyxep47nLZtd5ig3wlI0+GDR+CyBGVItzr+7KbDuR0zmahGBVW01yE8E3p7JMMPkusj7JLHnUC/kCKS99P2i6qfLaxoD96KF2Cm/1PfPzb1h5Ub3kjkUsESHzcxewRYp/DfnvMiPRP1eYHlnRoSlpLFA2rryZs/WZTlO4SBahnsct4+SVAu4gyBMniD8DdKXHrzv4b4FDiG8A1b0Ru/a+Izv1V5PjBppjc1mEIAJlb1yE10JMlO2JkiiSzWoR+DlCWxZC/5WZHO4OT2qZ3H8iv8IZbR5UYWXD4sQ3t9cfSLBAM27FVBNrlg1TyzpfPcgJoN3UsyiGejd9ByG5uuUUsZbVjZQcO7gqMFYeKmn2gxf71YOEfxQBGx44cmArCRqEXXyUK/H/APgEZoq6nVzngmkPJATLBCcSfUCAZLFAd5PFgTXbgAq5+haFOA9B2nJ7wLGKyQEbdpPvvVkDSrk45Ly0PKVixQ/ao8/6bHRw904Qne0rf2gnxsSfStnA6FtWZGU7F1TSkGCMlcU9ki9ZNrsUP9vqvSm4f01wRKVnjVRtqyrSE18T0smjm56fB+gRUdlOYgdyo6pFfebIt9ufYYvMzAb6aTwUEWdSZmYefSdrPN4judrBPnjV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


hugetlb_vmdelete_list() uses trylock to acquire VMA locks during truncate
operations. As per the original design in commit 40549ba8f8e0 ("hugetlb:
use new vma_lock for pmd sharing synchronization"), if the trylock fails
or the VMA has no lock, it should skip that VMA. Any remaining mapped
pages are handled by remove_inode_hugepages() which is called after
hugetlb_vmdelete_list() and uses proper lock ordering to guarantee
unmapping success.

Currently, when hugetlb_vma_trylock_write() returns success (1) for VMAs
without shareable locks, the code proceeds to call unmap_hugepage_range().
This causes assertion failures in huge_pmd_unshare() → hugetlb_vma_assert_locked()
because no lock is actually held:

  WARNING: CPU: 1 PID: 6594 Comm: syz.0.28 Not tainted
  Call Trace:
   hugetlb_vma_assert_locked+0x1dd/0x250
   huge_pmd_unshare+0x2c8/0x540
   __unmap_hugepage_range+0x6e3/0x1aa0
   unmap_hugepage_range+0x32e/0x410
   hugetlb_vmdelete_list+0x189/0x1f0

Fix by explicitly skipping VMAs without shareable locks after trylock
succeeds, consistent with the original design where such VMAs are
deferred to remove_inode_hugepages() for proper handling.

Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
Fixes: 40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9e0625167517..9ba98cab3388 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -487,7 +487,8 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 
 		if (!hugetlb_vma_trylock_write(vma))
 			continue;
-
+		if (!__vma_shareable_lock(vma))
+			continue;
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
-- 
2.43.0


