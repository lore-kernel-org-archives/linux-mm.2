Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 077BDCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 18:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9D98E0006; Wed,  5 Nov 2025 13:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A808E0002; Wed,  5 Nov 2025 13:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070D48E0006; Wed,  5 Nov 2025 13:51:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB5E68E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:51:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E25AC0477
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:51:41 +0000 (UTC)
X-FDA: 84077447202.14.385119D
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA2DC120005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:51:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P5kfAv93;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762368699; a=rsa-sha256;
	cv=none;
	b=OhH+8t/F+UiIdD1hcVWmFIcEK/VB/BgcfecCzOjuzc6iK4aTF1dRqhOCGrihkwiHplozaW
	fopH5aYfVC7cb1RX1COPttHm8ZOpeYTm+pLnrnCW66Gr+XUE63Gi57wpyx0yVTJu2Qgvsy
	+bMzCZE8zWJTRzAejRck6ysLjaGQ9pE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P5kfAv93;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762368699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QLlMdw1Nm+C7REWuktjxD0DSS7TOxd5dWldBw0pjFb4=;
	b=wGmsbBRAQjnavFJmhgRhY2yjh05MHsKSPN/Gn/OUQsHa1sy0D1rMFkEvCZSlEof3eSEKUn
	LNMCAJe4hqoe7cE+FaCvE+WVwu9i+EDLXheF1FwGrTQMIUDZlVc8uFbr1O6RVvuCmgDb+q
	t4gfmeeGvsl96gzVOVKaHARjdIJsghI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso257837b3a.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 10:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762368698; x=1762973498; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QLlMdw1Nm+C7REWuktjxD0DSS7TOxd5dWldBw0pjFb4=;
        b=P5kfAv93lmBNE4ANYyh2Bv09S/K8SzGPrBT32MgYdpth+vwrz8AM4KVAfTk4PgEDLT
         LavD2i00Gh1JVWV/ef0WyCx31grVqhKYk91MhMH2H5/fIuwFrpr8i+aX0LiO5Ta+XNSC
         wb9sPdDxbtKknLMXVt/JdMrFhc9fM1fE5cE67JEbDa4mDq5GcfQXlLFaHTRGXOucu8kH
         jb2usZEXPbUFuVLwCZgGnjiZjjvDfQmyDAnkEC07pPF12nlTLnLbtzM+dCNtFoxU5xaB
         tcrc2dBPmo9Sgrdg1JedRoMJ6Ik/b6WtRkOplFGeOhSbdVEFbcc5Cs8DoEHk8Vcu0CC3
         mN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762368698; x=1762973498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLlMdw1Nm+C7REWuktjxD0DSS7TOxd5dWldBw0pjFb4=;
        b=cPtp9CKC3LemqpGh7dXol9odX/69dBStg787edcfJPR0qyFJ3Qin6Y8a0b9nZvzYhS
         yTCqWpnJPK9xVyqg8g8T0lMdFMEnOeqIIHcMwKNdqGQvs/ZL3l6bkDmAlSoIti/T5evh
         I+trPO5b7ZZE7UbnDDDO2XGOm1rxWxgrSl+CCvJZrE0EjAVOTbZni0iWQENnC9knRiXy
         /YtKIEPN8b8PWYu0JeR72z8+vaLARTNZf+2FvWLuwsWC/UVl5xqI3yfcUoSe8D/8eUkN
         sb5phWly4LYOutt9HXioEf/GV6pGzs5SOSnirCTb8CLB7s90wyJVCtffdHUgR4JPDiRv
         6jjw==
X-Forwarded-Encrypted: i=1; AJvYcCU38wFSjbfeEhjnFwsoO1GfRVZS6KP4neTn3++imwSdDo76EhjJkw2WCUIef5Fx13jzWH2LovkBlg==@kvack.org
X-Gm-Message-State: AOJu0YwYr8vNE3KVl9GWPdPWMIf99aOK1ic3RzADMPIpTeHK3TpX2Gce
	2vmIwZsheqPhXWaaPpQIYbYsPYzgvv6AmvsnSUxucJSKpOp/5PyPZRMH
X-Gm-Gg: ASbGncsgmQBIgIGQXCfwhBw/O466x5AKDPTJ254huwmANlqGpBuf0qhlpr4AkCjuchq
	QDTQ+xTcMlQcgfNauLwU5oxS2gDCtzgU1eSD5trNZcMgbruRy1TmQSpghv0AOGqh27RRXWAKS+m
	Y5qxm+qMtx7Ffm0vgWx5mfPTwKGZdZPRcdoDK20nJDCudtRX27jKeMxCVMw4keEfH1GMMOGFO4V
	MzLtDOoKCEfTSVrjb5wKsNAyfCNUHgJ34yBL2/15/OvfKKKAtFkNW9huZl2FxOAIBmTCPkhOyZq
	uXtxM6OUaFFDnypk2HYI/l/sAxm+2R5E3aZO87WAH9SJAKuGittz1izVvGq64xXlBoeKQq/aGdg
	rQEF9TlWZdXbvLTzG3RGUGm98n6zpVHPFk8UMwpyxEWO91m4OZ9HWdovJkvf/czjkLsUM7cum+X
	e93lDgEtL22rdeLyQgwFd9j7exUwqL43sgEQknRurPucPNdgGJR8IKtMqh
X-Google-Smtp-Source: AGHT+IHk3g1K5XoxvDuiQoNx+Td8bjnuXSjXPO5+IwUUPwS057rA+90Avur6GhqGIhH2gjTmcX2sUA==
X-Received: by 2002:a05:6a00:98f:b0:7ad:1e4:bef0 with SMTP id d2e1a72fcca58-7ae1cd59fe0mr5182720b3a.4.1762368698462;
        Wed, 05 Nov 2025 10:51:38 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af827effebsm118409b3a.57.2025.11.05.10.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 10:51:38 -0800 (PST)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v4 0/3] ksm: perform a range-walk to jump over holes in break_ksm
Date: Wed,  5 Nov 2025 15:49:09 -0300
Message-ID: <20251105184912.186329-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA2DC120005
X-Stat-Signature: mustgx6hw1umm1mf7985hymhxwwfs5xo
X-HE-Tag: 1762368699-137648
X-HE-Meta: U2FsdGVkX1+mtzjawfAXzIVrqqPhJs6JeYzxAetngoyCw1V3RDQwPyecfiYtXTqVZpQkD3goiN+I4MXBQF35K7edngTtcqCryYH/xK5WIsrLFilODbVLIN4Z5WGnC6Mz1osc2/R/ZR8WgWov6ek8gGq5zmmDwRQRKqgDD+5LRTbI931tEKfFCsBiZ8ROuLzRYpPUKhAJFALTxeHONeaThpZyx6yN3znfFQ7vii7QQIyasqM6GZmN868FCHos/dBCtizCGi2DTViHJlYuTHuYtATy8EOn7SehP+fiGy4Me0yNZgn+w+Q3H+yFBGKBlHtIeAamHAy0/nhhkB+r+XrNbsr4ZMxIDFl8WUM0Iusqqhmgtx/z/MtYeysJ0OPCTQN4FqJS805sHubYTCNL8eWq4Ac6L2OuekqLCalCXbu66XK6v9HE0igsQ3U1jYcOd36rDLr896KmhPGNsZH8UF7dH9JPPG9kY5KPaqsXZc+q1eAfckExQxJEuUtEORRO1/dk+V394PoyJvc7s7PaVlA6PUTDWytLAxGKAILS9NunH1lgycfefVX4R/6bYPCZYRD9O+0qJQUGAh8g85TDzz3Hap//arcyyWJkVVLV0jru+VPs2YTxwcfCn4lOXLRZ2uIrj/qP6DlNp+t/3r2dKsTkcjLcNi3hr42Fa2VNfanirD89ac5QH5Xq2bHga4AprzfOL0OOc89E8JTDOhljVhtEGJsCgabDHyyQGdmS7KHjOiIzbSgpl0d1hgDFKOhCb4RAEGPs3oA+CwOvdYZtEjN5RJ2iN8Jt0Z2LvtQf0qzTzSVEyvmTmC/FrwSLJh2le1N991abD6s6Xa41XNmuob2psSBEjIehsBUfbStPVBghOzugOraystMs1hBQxPRVESDVhmcK0GMs0/uktvkcMGuXHa3d88sgVEXL1QxWASCu3tnlCIYgpUL1FZ90DoSOagwoSZ9vdg5gZACPRy8EUOl
 8VtE9PXL
 s/GV9OkCDIWBIQsT1QeJPq0ZKC0JxgoZFS+XlSGXjjznT2eRCQQ3rlB8UgLorSfCT4Ffmbf11DSuh2hKcU9NluS9dnjHU5Y+ZJNt2mkBi3l1/4oD/0LgNf1Ybmi0ZGj3PECHRiu0lrdVazL8z5+A4uNHQ898VHQ69zB1yMyQi4RSNm6DecIiHMl+C1nBxHjyldCtYdrURyQz2VOF8BurIVN6zVi2sTGRT2LWCSnkY5f3xGERntwsTORx1N5YcRfIczXWf3wSSBumwwNFR1jAcD2wecBYo2QCGIzOlB/hxfP8L2IxM3VNJebrlZM/hXwOqyEbf9w7XApn0gr1/shI2JiCzphPEwrTbPGcLXkkQKtx1zl4G9gzhI2P6nE3JhZW5UVkA64UB9Uo/VIonAoVleeFsLdHT8jd/J5R8tZmGhHvBoXHb9FXMAFWWYkYY6bOmCTjSg7qP+42/4loY+y0h+OV86A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When unmerging an address range, unmerge_ksm_pages function walks every
page address in the specified range to locate ksm pages. This becomes
highly inefficient when scanning large virtual memory areas that contain
mostly unmapped regions, causing the process to get blocked for several
minutes.

This patch makes break_ksm, function called by unmerge_ksm_pages for
every page in an address range, perform a range walk, allowing it to skip
over entire unmapped holes in a VMA, avoiding unnecessary lookups.

As pointed by David Hildenbrand in [1], unmerge_ksm_pages() is called
from:

* ksm_madvise() through madvise(MADV_UNMERGEABLE). There are not a lot
of users of that function.

* __ksm_del_vma() through ksm_del_vmas(). Effectively called when
disabling KSM for a process either through the sysctl or from s390x gmap
code when enabling storage keys for a VM.

Consider the following test program which creates a 32 TiB mapping in
the virtual address space but only populates a single page:

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>

/* 32 TiB */
const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;

int main() {
        char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
                          MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);

        if (area == MAP_FAILED) {
                perror("mmap() failed\n");
                return -1;
        }

        /* Populate a single page such that we get an anon_vma. */
        *area = 0;

        /* Enable KSM. */
        madvise(area, size, MADV_MERGEABLE);
        madvise(area, size, MADV_UNMERGEABLE);
        return 0;
}


Without this patch, this program takes 9 minutes to finish, while with
this patch it finishes in less then 5 seconds.

[1] https://lore.kernel.org/linux-mm/e0886fdf-d198-4130-bd9a-be276c59da37@redhat.com/

Changelog:

v4:
  - Fix few nits

v3: https://lore.kernel.org/all/20251105172756.167009-1-pedrodemargomes@gmail.com/
  - Remove leftover code from previous version
  - Call is_ksm_zero_pte() only if the folio is present
  - Rename variable ret to found in first patch

v2: https://lore.kernel.org/all/20251031174625.127417-1-pedrodemargomes@gmail.com/
  - Use folios in break_ksm_pmd_entry
  - Pass address pointer to walk_page_range_vma private parameter
    instead of struct break_ksm_arg
  - Do not unnecessarily initialize start_ptep
  - Order local variable declarations from longest to shortest line
  - Improve patch 2 description (do not reference the cover letter)
  - Quite a few styling fixes and improvements as suggested by reviewer

v1: https://lore.kernel.org/all/20251028131945.26445-1-pedrodemargomes@gmail.com/

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

Pedro Demarchi Gomes (3):
  Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to
    folio_walk"
  ksm: perform a range-walk in break_ksm
  ksm: replace function unmerge_ksm_pages with break_ksm

 mm/ksm.c | 137 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 82 insertions(+), 55 deletions(-)

-- 
2.43.0


