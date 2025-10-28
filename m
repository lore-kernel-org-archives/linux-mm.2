Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08707CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66ED680141; Tue, 28 Oct 2025 09:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646B38013F; Tue, 28 Oct 2025 09:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BBF80141; Tue, 28 Oct 2025 09:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4290E8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:22:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D78AB160389
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:21 +0000 (UTC)
X-FDA: 84047586882.28.652286A
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 12C4A1C0013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Jvkaa/F6";
	spf=pass (imf21.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761657740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jloGoDgioftfqidIFa4cgHHXNxg9uPjhBuXbiium1FA=;
	b=iE+/aQSlfw1tJyLURav7ZBwBU72KdDvb2CJK29e3hoZ1C3SY6on73ZCBOfwfFLNuqlv0QL
	3jmrf6hfjVrfvnMGteQGzaqW7s0lklBEyRiFnL5MtjLv4wxwwfjqC38ehjWc6T5ZYfj5oN
	sxYuL/VrYQsJ4wdYjYprlge5DKh5OsU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Jvkaa/F6";
	spf=pass (imf21.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761657740; a=rsa-sha256;
	cv=none;
	b=6AWD1zfekGe84rW3ZGxqsaxmrcB5aUoefgofkgxG4jXbq1yJ9bXW83/uPl9DQuv+xYLoMk
	QDNBBMsnyJHThBgfNu3LKiXtG9r1+DvY8za7db4rUuR3me6uoDlwsIZUXRUm9pFAAC0NJq
	kFTR89xKwb6qIwWU8shFBvahzS2mu0g=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29470bc80ceso66748005ad.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761657739; x=1762262539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jloGoDgioftfqidIFa4cgHHXNxg9uPjhBuXbiium1FA=;
        b=Jvkaa/F6ImI6eo1iovBMlVwwwzFVic1UD9bhyIzLLzABE6t9kWmfz4APkZ1xieJlpk
         wKhmITG4BumFphSswV7WN8vYDfeyHjt/QkJoqytHpikTPZQ7Fq9Ns8BbQH73H7dTZFO2
         H57/T08obSj8szxDoFidZc13Rj+pbTBXpRt2byGz5Qqz1IE3r0MDAW2Wvprcsbl+W5b/
         so4Zn0I9f2RknAv7M1sg05vCKms/I9BOzHuGhqWA/5pzsQGK0Xtpdqjj8sJynj22+ogw
         nQgeFVbZ9IMvKxVTfInfTsvQcRo7SC4SrSgqrtIdR7ItNMwRSa9uEeq7ViAYDUzPerRI
         oL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761657739; x=1762262539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jloGoDgioftfqidIFa4cgHHXNxg9uPjhBuXbiium1FA=;
        b=BFG+14QQ/eAPKFDdggOTKhNdWXJq+ZLcTx1BFEqNDEzG22SE0M0E86xLRUe/JWqRoT
         eFVoOPJMwNmLTw24KRI8csHDE8drct1nHwYv74WWJPoEXHnIE8lOr8z1gc0xYCTw0HZw
         4tok/owSbKX53/yEXdCaaREEsqSkGngWs/k4Q+uZDHj8bdY0T76ckyoNaKc2hcfvvc8p
         U63lXId+DljhkPhbxTBPrA+j5X5vAzDGHoHFmnG5JUbwrlRzNMEKd8/KLt4WQNgM8BSD
         ewpXvZ7UIUiLseSYKHUoA8FcXEIVjakXoJeZYaIxv3ybp2g6CSZCZeJWbXTlWiZeU8FO
         lMAA==
X-Forwarded-Encrypted: i=1; AJvYcCXvNiI9VfnrbxVf6sVBWLS0sYBroiL0GDeA+3vtABplSayqgCfuavBFBQg4xJz70P4KLLOOv/cAXw==@kvack.org
X-Gm-Message-State: AOJu0Yx3ygDr/A8alb6HmUTSQXeTyV/LEncOeox9aBru2iqxGJBEH+xJ
	lq49BEem/U5k+sM4jiw5RFYhEDWM1rpv/21UL6SEJxNsbflkaIxywSDY
X-Gm-Gg: ASbGncucIx/CNGrLBCyBvCAgMyalmZHks7ceq1/24bSa7IzZ7Iz/S5iSb9VB7Gymx2T
	9nubzge23SDlFtBL8vLwU+dWJZIiQJQOH+jXI9ibHvcLElBTkBulTXC/r6b97/CqAA7nW/rOIT1
	+eelDQT3ynj397qUGCVf7lFrhlXLJFUNz244zHHkXYxRFppLY6PEMr8rn1HEHu8R6wNXJo3t0oA
	Z2iEveWVuAgxNn6WwjUzudGRSdR18/7Ggdf5UaybOUff1l23Ky2nDM/mDe+0cfa2MRtokDa0zdj
	DhoJJa5WfVVz+Rud0ZeZlZB12ESoz3Fgi/upVrZ6/NV44EyjcymaEbwQgSlAGmkUvuWKvfqO78I
	d78CHbHv839WGiHnX+5NAg2JN8MDB1ElEP8OSI2f/QcQZnpjaYxB1JNvw2TRVzkqf5jGTOxSIPq
	Lnsc9jewJid4gzlntm00vyqBMg
X-Google-Smtp-Source: AGHT+IGtbW5N87Fdq/kMZmApEC+rTjGEnrvlNdPpTyAZAg8rxqQg14bT0yJjZHg34xR5/QKF3HFBlQ==
X-Received: by 2002:a17:902:c951:b0:274:506d:7fcc with SMTP id d9443c01a7336-294cc686ba7mr37922375ad.6.1761657738427;
        Tue, 28 Oct 2025 06:22:18 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d0c6eesm117446235ad.42.2025.10.28.06.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 06:22:17 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH 0/3] ksm: perform a range-walk to jump over holes in break_ksm
Date: Tue, 28 Oct 2025 10:19:42 -0300
Message-ID: <20251028131945.26445-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j1pydd6dzko8e9rno693bnd4wte4ddqt
X-Rspamd-Queue-Id: 12C4A1C0013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761657739-13164
X-HE-Meta: U2FsdGVkX19ohI3kjbt/IPkVjUvPjwzCb0FZjbAtK6Dn07BVYXEPya3bxBuou14ogr5xLK4yrrjIt4b5chvmMbtAzQFe1yA3O3umM+wqVSkSdahWYyoD0PMy8tt93KWKG99ikytsDYGMEilrNwi8WcGsJd6ELoLlrfmDifGT2wixHjlbTXPiAYgAqPRt/gsV5I6UQp/uhVVWOAfgyB0HvisVA8c5zMfLKf3ksa4AbxzSGSkpGiSS7mTKdBt8xPaXQ8Akg6YHhPP+SWXChiXVnqaRx8wujDNLARNf+5+wgEkba/BgbLgCVe9GZvsuK1AOdFDZEfxRoQGFjWV58gqvK5SP+D7BjgehztNISNutcKXuls7f6OGImpO7riXNrx8dHnpvhGDypsBBoa+J5efAqd17AYtdOK/hcdWIhebd7gCykEowfOiuPGM9D0L+bI3SHKZJifwsrD/0r25H3zkmXBIemBEv+JxRb35Iy9v2pYD3Ue53PdlVJkf0Dt4p6uV67H4gdytLcEOz8kycraSer7SoeqW3F5C8+I+oQCoYhCRWps5zVJ/YC4u7HfuAtaMeUoHU49CJwZLf3uv2kzBeOLi9u71KKVdOSauu0DJqo0dqBCMqIEQDJ3hQTPJkhTGjukix4waKZheWrhWjUqEVWP0SAPnj8d+BajPAzOeG0VCNjaBTvA3bQ0jVn9+OkPHgJ3ctmZhgM5UUrlLj6FVyLRK5Xvck+X1H1EjDHhHv1vbD428H+jnkLic2vml4VnoYSzgpGXcrpZXu0BUEX1HtVjE81BAeSiVf0YoDYTHMZOO7wcKim1sFBSg43iIQDxMBfAxu35x+YA54fTboDukY6mBIOMRU+m2YJxqy6RR53tMc/P+1XYMcUg3j47XinM881ZT0nYSuLkOzOZBhi1lt1hZiAZzHUXw2Os0d24RDIhtK9OQY6Jm6EWINyAeeX5Wb7ZnOZGCO4NnMe5G2O9u
 jGUlwDCn
 tk6ZgfMqczFRY8bi4OVuOlJBRNmIHsXUzD4ry50J7PpugyTk8L4STKiyP7jDnmJtPcIlSSABRnckbqL9glwN2ux3gv4gm1U8q3Q/qBxnPaeL8kZ5B8xieM98MutQa/c5+qCPIo/cS10QLPD9YyrmyX2RNqCe61bzzTQBzM9aTjz9cJCMZITTrrv7xEwMIHjJLDSeYWC1bo+yhovysLtHrMsDBpga8pD07t50daMdyLBUMlE4+pgsV1iX8tzyKdCUTx9MiQfPgTjfbPZ4yh2ZY5GqTzyNdigbi55gB/zNwfZzNDKtDcoUH0I57crjxibIQw24FYQ2FwPXpeJWcBPyHeRP6z73a3Bjvr0aAEcI+onf4oH/VXdGimDl/oFZDwtwtnAnxdGh4xnFaZVU1/whjVnV7FAhpm4VRg8fS0HbxPHvFR0FXpWcxq8CYHIjJCMwVDkc8Q0xdtliaESxnwCehuvB8d/nDRf+w5/1VzLwXY5bqLxOVOtGauLz4WYWlxA+WjXsZ
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

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

Pedro Demarchi Gomes (3):
  Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to
    folio_walk"
  ksm: perform a range-walk in break_ksm
  ksm: replace function unmerge_ksm_pages with break_ksm

 mm/ksm.c | 142 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 88 insertions(+), 54 deletions(-)

-- 
2.43.0


