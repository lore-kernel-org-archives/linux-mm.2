Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C33606A327
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eZA/dDYv
Received: by kanga.kvack.org (Postfix)
	id 866CE6B0251; Wed, 21 Oct 2026 12:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83EA76B0253; Wed, 21 Oct 2026 12:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757A66B0255; Wed, 21 Oct 2026 12:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9BA6B0251
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:48:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1627805C3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:48:15 +0000 (UTC)
X-FDA: 85347216150.19.E9B48DE
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3914A000F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:48:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eZA/dDYv";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of danishkhateeb03@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=danishkhateeb03@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792601294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dXeINQ4QIp7Up68Y8ta4qvgRYMF1gZWIV5kShFfvhqw=;
	b=QC+ynLgU0J5z9nFhDZz0kZH5SgQ3bKd3S2aOGRrJz4Q5ehWLGaYDhMqmtPlrOdp7QOA1j2
	Zw0PCiFLso8fdB9r/r4uixe/iAKzSEfMm4KsHi0ee0aDfsfehavY6FJzcrdu9KVydS8ZFV
	j1uIbeHKMNIZSg5bYe6keILvkrebUe0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eZA/dDYv";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of danishkhateeb03@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=danishkhateeb03@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792601294;
	b=Ddr5BKhCt6p9f2Lzp+rXH2ZysIJzJr+0PT2n7PSTHmEhcYGVFTC94LfjbUh/GDSdsfJjNK
	d89ZrgQfippfLNzoHQ0ANL1NdYIHB1Vp5RNBxa4/qqur+ZrJ2ZEQcVZSs37OBNO2XkLrWF
	9gb3Qa5n8sPMlHaQlELhhtCSc+1e7tc=
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-702dedeb70dso546799eaf.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792601293; x=1793206093; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dXeINQ4QIp7Up68Y8ta4qvgRYMF1gZWIV5kShFfvhqw=;
        b=eZA/dDYv+M1b0Hz2MXaJEonNZBWCf1LtNfBF0DwAra2Xs0BI07pCUQx06wcKqYwwTn
         sv/C+GHzHZqadlNY7a6BoOhqwBTfCHxuwa9gotR2D6xva3fDNML20lz35Vre2d0F3Jei
         0KLlwPFzJwl7H71/nscRFbf9HcMzZ1u4hlt02RbfNQXekRdwvKM6Z4/19SQlk8mBfxmT
         R0o2Sw4Nml17gCDHDHMoLylrvu7z13R96iXq13jB98iJLs0276euozIoN5et6d7m9NGC
         JFKDDEVmeQAkUOthDf23CNXc0xmrZyIbMkfwPhfrMQCMxGRmayzsiFsKOW+V0QQMlehP
         C3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601293; x=1793206093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dXeINQ4QIp7Up68Y8ta4qvgRYMF1gZWIV5kShFfvhqw=;
        b=C1W+9vVWq3eMP0Z5aUNWxcmiNnMTUrHGB48uZp+pSXEriq48UeGbjXV2HKPfBonxu2
         gtVC2FOk1q/aXYbrl+U7JP3cxJR5sNqPo9B1MgILH/IaX/agBZH1cJQtF+yRpe3LJkmp
         TSNvQTFGrRAzlyrOPs0NPy4+A4Ub+iCzb+kX1tDBYfhwAkgHY2K70iQPdgBNEIMu63ai
         LFIKWJTpTily/rODLJmcqcjAtOAq+Ju2yR1F8IRqnt9fDVDyb3jZMusCfXcmbkx6kInF
         IHzxQy31rQ3az2F9kxA+J8E1gWqhxToFk3bH7L6CzQXDuDwxIEhnyb66zjUfNHYQz1oz
         Hojg==
X-Forwarded-Encrypted: i=1; AKwUvBwD5fOiGNIprVWJ/8v79FaPKPgQVDfchwDNGMTT6qebHpM4nWWFUU4QaCDWbynFXZ+r17P/Flm8sg==@kvack.org
X-Gm-Message-State: AFq9FYJX5rCjPiVmP7FFc3zGbTzLUCIRbexmIN5gjAjO4MPk/tKUQc3o
	oDf+KjUuhWLnGCiRjrx3ymZZ0bBl8f/oxScqNekkiQ7sKmPPIL5ipyAQ
X-Gm-Gg: AYBFou3jFQK2DsQ1oSSZt7TPNvSQ7qNPgG0X3JwvUqdj6JQbANWlowkzNtW1cb+okUO
	vIygcQGYiRxpJmBhBh4jjpfFaF/HgMo3PheKoaiKhPo+YWZ0zvYAf7OVxOdspvkHlI2yOwLzEsJ
	lS2qknZEB0fCgRQWvUAANaFgs/gDWZ7zIHfXZz+9xHwhZOFNIwc2zVU/sWPvD6poS8mNzan0pDY
	bsZ1RVaMENam6vmanH7ACcAgVkMEO11mTt9drUSduURBIWMDfAMl4ZF5TPO++ScEsSQXb6PMV8d
	waS2zJVvg/Aqwn3trEl1NBmV5yhPagpXjVQqLAOV1dpfmfBB1SP0fqZY19hLhxyizmG9DjQ+tAC
	IXsKzeQhFnbyziy66UYbfY620ec0cAqD+2xSv/B5hB+vzQAG1ql0FrU2BMbC9x6ErHuR+BUsyZy
	NFLTb2qUoPQOHdFheMI188sh0UOg54Ui6ChsRz0T7DMgUQNHvdbzQM937edXp5UEu6VAcpYQmsc
	UURhQtZ+/fFY2FkZyQS4IlVbtNz68yMeRMN8/TqAdo76nkApcemHFiQazRnmzWCOpYB3JMjS8IW
	rM7tiKrQWjx7Po63pBYsZw==
X-Received: by 2002:a05:6820:821:b0:6bd:f79e:501c with SMTP id 006d021491bc7-7093f8b08f4mr1720613eaf.16.1792601292924;
        Wed, 21 Oct 2026 09:48:12 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a7d5ebc240sm2352610fac.2.2026.10.21.09.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:48:11 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Price <gourry@gourry.net>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH v2] selftests/mm: merge: keep the far mremap() targets in the carveout
Date: Wed, 21 Oct 2026 11:48:10 -0500
Message-ID: <20261021164810.45846-1-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F3914A000F
X-Rspam-User: 
X-Stat-Signature: dsymiqgjqb1ipbxowhzapeam69qff9fg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792601293-789822
X-HE-Meta: U2FsdGVkX18TpguH9iQgITw7zJpWgMWW/FqDX1sQ7Cgy5VKEm38MXVyMC96UIg/xIHfb64VMWBLMROk7Ls8xg34Kjbi+UhRWXp1ZI97j51WjAwOWxAfPMA46UnsE6iTW/qPNoE8jxs7WtRrZ7bCsUrmOmXeFBogMxF5k60TbY7kp0fa/2nJBbhNVSZPrDVI/1G+DXo2jKBpGDo9fCg58M0nXgmSng47mDeMZv8lMXSpCflyLQ29e4br2CRg75BzYMYh8TV700/w/W+Nt5tbs79K23DPY+QveufAz66Ibh3XMiGCgud7GnZclmB4WqHLNPq1IA7tWHPD41dPmoTNnTCrO3isXo8mkICCTOY7W9Z1cDiowGBvmgtTY/0dycp4YNeXwgwoQo80h0MlflxGGCY+sp4Z7r5YSCLfWHsUu7t9M4tX6JoiQHPj7qzl+w0fmIbnaFHqQ3BC2YO3FiV5hSam/813UuNswvi4fjXB1K0lHE5xodelrAazdzdFIdyUM3fRLuX7TIwGX0Qt1Ts3HTrGLH+sSW424UZviUX9EKMHxM02GGmOJtgbNIynDWqRWOjFVWX+SxP/tl/lSfEhhlPhKB5MgRfMYU41IF+iqC5bahpnV2u7ZTGTuHjP2zahLxBN2y7Hia5vqiZHpDhWOc8suhbbCjTUpRXXTGs4+mcERaXgD15O/8X11R/YlRh95LuUPijiUfe1X60oRST0uIkQzawmCKJ9ar4dpVCOhULUA4f0BuI4L5Kf7xPPcJzQ8tnu0Q+PB0tIG/nUEAPM/6D8H7e56D0cu+S9SKTRh8sqhKTLH6NkDT1TigcFYTApRf0k4zHKP5hZ9bn5ZCxBJ44xq320WLPkBzyghyA4I5xlq1ywvFH8YkKhi3zK1sPwW0fx2cLAzycbN7Jsjf1pYJub8/vVg4ZZQiUqeLzNDOwVo/h2+rXO3Pxe5YOB3T9a7TVilq0jO9GcVVuwE6iC
 mMlEcP2P
 OGO/2P35BHaCEQgx6X8b7xkX6K215crleTOaJ8UD1adOselFwqt9UvWK6WxR9h1Xg3VYb6/bk8DGR+h3u7bULOjOLh3u+SBqiJrHMClukKcd8VbWR5cDlr9wJVvkrLkwcCvVVr+vOMbDtSAkH+etUqp+7gnfzOIfGmkfWZOyDaMZlk/ZC0dnzArT3TUo+sMKRr3b5/y17JuLmyn9brvR0g6uU8tLJNj7JnQp0Xcp/gS/J9BwrsU30KxkjjYYOzBM20ygEls7E91MfPWF9YpkcxAN5Fb8qoWGwkHLXEAjbPPjojVoO3zaD7BnKqzxHGUXA0cBDJXCx1NOti0JyUiD1k9iFfnhwQr8RmXrvc394HRzA1xm+w2WiTTPZOTguGiUQeAK8sUGRAHLcIrYspCWReilPIxNpCIKVlLA/KfR0Dgd3f0+tid+6V4p2mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The merge tests map their areas at fixed addresses within a 30-page
PROT_NONE carveout. Several mremap() tests move an area 1000 or 2000
pages away to separate it from the others, but those targets are outside
the carveout, and MREMAP_FIXED unmaps whatever is mapped there.

Under virtme-ng, the shared libraries are packed right above the
carveout and the dynamic linker starts about 4 MiB above it. The moves
then replace part of its text with an anonymous mapping, and the test
crashes in its next lazily bound call:

  merge[6980]: segfault at 7f7ebb3c1e60 ip 00007f7ebb3c1e60 sp 00007ffd35fbaec8 error 14

Two to four of the mremap() tests then fail with "Test terminated
unexpectedly by signal 11", depending on the exact layout. On a host
where libc is mapped at a 2 MiB aligned address, the targets happen to
land above the dynamic linker and the tests pass.

Since the areas are all within the first 30 pages, moving one by 30
pages is enough to keep it apart from the others. Add FAR_PAGES for
that distance, move areas by FAR_PAGES or 2 * FAR_PAGES pages, and make
the carveout 3 * FAR_PAGES pages so that it covers every target.

Fixes: 4e25f85b9f85 ("tools/testing/selftests: add mremap() unfaulted/faulted test cases")
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
---

Notes:
    v2:
    - Replace the 1000 and 2000 page offsets in the tests with FAR_PAGES
      and 2 * FAR_PAGES, and derive the carveout size from FAR_PAGES,
      instead of only enlarging the carveout (Gregory Price).
    v1: https://lore.kernel.org/all/20261021011929.89150-1-danishkhateeb03@gmail.com/
    
    Tested under virtme-ng (9p root, glibc 2.44) on next-20261020 with a
    KASAN/lockdep kernel, three runs of each binary:
    
      merge before:  pass:22 fail:4 skip:1 (SIGSEGV in ld-linux-x86-64.so.2)
      merge after:   pass:26 fail:0 skip:1
    
    On the host (glibc 2.44, libc mapped 2 MiB aligned) the results are the
    same with and without the patch.
    
    An LLM was used to help with this patch.

 tools/testing/selftests/mm/merge.c | 39 ++++++++++++++++++------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 7dd2933417c1..208ad7e340fa 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -22,9 +22,18 @@ FIXTURE(merge)
 	struct procmap_fd procmap;
 };
 
+/*
+ * The tests map their areas within the first FAR_PAGES pages of the carveout,
+ * and some move an area FAR_PAGES or 2 * FAR_PAGES pages up to separate it
+ * from the others. MREMAP_FIXED unmaps whatever is mapped at the target, so
+ * the carveout must cover those targets too.
+ */
+#define FAR_PAGES	30
+#define CARVEOUT_PAGES	(3 * FAR_PAGES)
+
 static char *map_carveout(unsigned int page_size)
 {
-	return mmap(NULL, 30 * page_size, PROT_NONE,
+	return mmap(NULL, CARVEOUT_PAGES * page_size, PROT_NONE,
 		    MAP_ANON | MAP_PRIVATE, -1, 0);
 }
 
@@ -73,7 +82,7 @@ FIXTURE_SETUP(merge)
 
 FIXTURE_TEARDOWN(merge)
 {
-	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
 	/* May fail for parent of forked process. */
 	close_procmap(&self->procmap);
 	/*
@@ -115,7 +124,7 @@ FIXTURE_SETUP(merge_with_fork)
 
 FIXTURE_TEARDOWN(merge_with_fork)
 {
-	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
 	ASSERT_EQ(close_procmap(&self->procmap), 0);
 	/* See above. */
 	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
@@ -660,7 +669,7 @@ TEST_F(merge, mremap_unfaulted_to_faulted)
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -721,7 +730,7 @@ TEST_F(merge, mremap_unfaulted_behind_faulted)
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -785,12 +794,12 @@ TEST_F(merge, mremap_unfaulted_between_faulted)
 
 	/* Offset ptr3 further away. */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -870,13 +879,13 @@ TEST_F(merge, mremap_unfaulted_between_faulted_unfaulted)
 
 	/* Offset ptr3 further away. */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1035,11 +1044,11 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 */
 	ptr3 = &ptr[10 * page_size];
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 	ptr2 = &ptr[5 * page_size];
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1075,7 +1084,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *                  ptr2      \       ptr       \       ptr3
 	 */
 	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
-			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + FAR_PAGES * page_size);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/*
@@ -1110,7 +1119,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *                  ptr2      \       ptr       \       ptr3
 	 */
 	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
-			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + FAR_PAGES * page_size);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/*
@@ -1168,7 +1177,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *      ptr                     ptr3      \       ptr2
 	 */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1203,7 +1212,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *            ptr                         \       ptr3
 	 */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 	/*

base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
-- 
2.56.0


