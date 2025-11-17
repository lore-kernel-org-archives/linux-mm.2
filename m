Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC90CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6108E0003; Mon, 17 Nov 2025 09:08:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855D68E0002; Mon, 17 Nov 2025 09:08:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E358E0003; Mon, 17 Nov 2025 09:08:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2AF8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:08:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8D6B138385
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:08:48 +0000 (UTC)
X-FDA: 84120279936.25.BB4CDB9
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1EADE20002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:08:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BsZHTOPE;
	spf=pass (imf13.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763388527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eFt/0dR5SJNFqQvlHxE3I1L82J7M+GH636G3V6yWtjI=;
	b=nSDyCWg2uWcqQkWssu9oh6qzEa7WNhizozpQUHUBN3HDPhxJ9pL3kDiDeKqYTZeAQHjEN4
	sigg40vk3alUJjfIENV72EG5MISX4b0S3jmUzlbn95qJjwkJvH3OYcqQJCaRD6rtkWmxSO
	vT40HH8vX8LJoBGI9e61TJY3MPbPr2Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BsZHTOPE;
	spf=pass (imf13.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763388527; a=rsa-sha256;
	cv=none;
	b=Al76K+DoKRJYG1i2gzBCjre6C1AserOKRBnew+0EWlifuB4hsOeQBOuIxz5XRZejbVgld5
	9VpuqJnfkEkQ5RFXhPxvmqaqrqNE6oQi6EzxDfNTmJ0OMkVf0p9vf0x/sYJQ0Vlah8nTk0
	fctYOTq5om9yW3n1cTGjWw6eoRUV3v4=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-475ca9237c2so23865055e9.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763388525; x=1763993325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eFt/0dR5SJNFqQvlHxE3I1L82J7M+GH636G3V6yWtjI=;
        b=BsZHTOPE/MIBFYvSlgT0SaKRbgeBX6FThzoA1Yw0/Pbm24O+znLaf0Dt7tpNBgYbXh
         tUHH18DIFcrpFaJcOLSEUgLld/NdUm0xHEAcns2qKAJDX3jZymqyV/Qdmpmydm6AKKqd
         ferhqUocHz5x71ElJ2eweRotL7LuyezlFEAsvHJ//gdmzTZWRLNyvUTzOwk7mAMTFeBN
         1900qAGlKgJPnowXM8xdidPfVKPEbiCPYCzC8HxjtTevlqVTTAS+6MgOuISLgozG2WgT
         0rv/RReITxicx4n8X4xpwXRfL2s7pBmTXgPxzNgv06pUjxfXH0Mj5+W5IHFqbpf6Tlkx
         GRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763388525; x=1763993325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFt/0dR5SJNFqQvlHxE3I1L82J7M+GH636G3V6yWtjI=;
        b=jkeMYRtn9/FSNIHijvoU9SGvNgB9v7gCJ0KquMwXpbg//r3kKAf2DDdts7AE7nwrbe
         PWb2f5/nfALPZLpZjhQjaWf7hB3Q7/cFvo4RHEGlX1nygwSU+XZNLvI4sC0RTxpc5N/n
         wC7MS15fXeYZ6JGMxK398pkDHESbZ6JzjSFt/jctVWteMtGJV8aeAx2Hpu9UpvQXbsux
         anxC41NJ7z1nkXIE2ckhJrkLtnJFVGDMJRYxnj95EvaNi6rpUfMCkhEa0md9XcuWLU1P
         zMz/zxCPq0Da76wfTyPYoA/KihHydeEMHnoc/iiXWRE8jC2okCorDiEvavWrFBP2aFiJ
         4myA==
X-Gm-Message-State: AOJu0Yy2h1b6KiTSs4jUWQU7G5jNGJfRAnZ+HsSslXsMZ7t57AZ25URH
	izS39/PoXMfr2JZzs5SGH1xF0rpM8sHtEFaQtbCVXUr1QXPm9KgNrfl/
X-Gm-Gg: ASbGnctlzF6+zaLTgOwvERBFAbYFWxnff8aT4thrwtksgqc1fDf9Fd/2Jjaw2/hK1KQ
	rOwgLcRH3GU3auA86tuEQXTHSQRszK24iWmbqUVaXuw8/wa5QuKjVzdPorznqwWdgJC/HsI5Mqt
	FBkm+CYslr5+7oh8aCjVX47z16AvbltjiRanBw7dIO7FJpO8YRa5wxLaSeXx7YZwRKIXfjQ30UT
	ZA2uh7tZO1SAnkdUPl0+Dyq93Oh3f8OBvuKfdWQn2/wYtsQ5pqn4QVgM5T/Qzr1iv+V22ofeaAL
	Nvq9UezBsmeS+E92x0NwqvKg0jxKSQwIbTykBAmsqZjL97kj1r3Zynf/OzyIoD6CLN7ZeLpx95V
	l9rTLIwYV8AUTbxAga/R3WmxsTLbddZxQq/SG1lTNjIbC4BMib9IBInhzYcjmPprJU5TuWJcqXi
	tHAXVo7pclCI7T79UfJcZs2tvajrQKsQXEpq5tLWkWx8vBBV4r512Ztkoo7uA=
X-Google-Smtp-Source: AGHT+IGkGnTkwpwDinuAgoZTmsKo1U5ibTWnT1wU5rzHuKsObAr1nsXRinCrzzduTf4/5dtPOpL3sA==
X-Received: by 2002:a05:600c:1d0b:b0:477:95a0:fe96 with SMTP id 5b1f17b1804b1-47795a0ffffmr79716355e9.36.1763388525274;
        Mon, 17 Nov 2025 06:08:45 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4779fb67e73sm83540275e9.0.2025.11.17.06.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 06:08:44 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linus.walleij@linaro.org,
	pasha.tatashin@soleen.com,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] fork: stop ignoring NUMA while handling cached thread stacks
Date: Mon, 17 Nov 2025 15:07:47 +0100
Message-ID: <20251117140747.2566239-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1EADE20002
X-Stat-Signature: f8o1scaqg7e6xuy4puqod5uh99zcij9u
X-Rspam-User: 
X-HE-Tag: 1763388526-504101
X-HE-Meta: U2FsdGVkX18X59wkbw4yfDZBtKk3k0e04I41nxZ3nP4/hqgVx8BVyckYA7+QsQknUHH+TfwJ1bhhKjVNw20+wkS1kFhK3YcpmgQGk/Z1QsLa7ofEE776E6RmaApG/EapjDV/waGqYVjdfrSjh/orCZtzdvZlFwPK6y28g2fpjB4Rx47Pzn7/ciOp8jjC4+L031yX+Q8MNptPiqbAmlm86gcl5yiSQcfzXoREbPINjYVpg9qbdPyvS+usw8wq4cOYaCrAg6CKiX+S6LvwQqZSExQctiEvjz3SCGlKFxm6as1JN4+hHBL+O1uWf7Tyunyec1qjStPWU+He8A0O1VlyiiSZqNCSoUw9lBiU/OrpAY1q0BaOB82mhzsLtYCQTEkvKVFkZ5+VuvRTLTTXoDkQHajDy0IHyyS78ULBG6N8M8a+6Cjence/6yhBB0Jwfdce5BQYR7F1VyjigqprYs+pD76E/BQGkaPYc7JtjPBsSU0TmjfSDI80kZV8RlhWBsjV6fh224IXWg66nCF5fPtmCTxOB1V7eQ0KppmopbNnDOGuorbIUapZssU+M1OIZPfjBsj0EGu/saT13nfBAqTEefYOCZXcRa1rfy8HS92q/E3JEMuX7yoKFkfaZSjJvKLNguFLcZBhXgy0QlXkBah6biT42Z5bz3QJXvNnqcthnUAqs6vJr+zJvk/gbVvOS2RZf4yeam7sL/phJ7tt2tI1wVyMfIhG55AuTH+GCcJmsPpPTPgtBGGuM+cVwRpOm+K4lj0MrrI4SSpDozbHi9mm21lInDofd6DtECSW09CAVzTGJju3Q1TSP88fOELTfNEURyZFEX30gZpiv9Xx1zZBT4m+lWP3rkYrZ2SkqmUFxtmop/a6zKPJGapZOxk7QcPWUAdT1XjM1AgV4PqE96jMi3xWf6SI8BFzmmlSU4i8OjA0yearHNkLqcF6NKTjCZri55V51CVz/1fKwVbaimI
 QsUeQg6y
 WHK580XIEe2FWuGBDyrOkPefKPVy6vNIiLEw2U6RkzI87DqQtOqykjGNCOeHRoSkENoICh/ALWm9za6ACOp1jz9rKbz2vnGDNngk/unmnr9XlZWjf/hrkk+ch422Hlp+OMrBe4v+gmkO2Io2PMiy7cBQbYbEHXrhucJzcV7Gme8Q78WR8deJx2lDrhs26J03sZGM39L1YOYL8FSAbQcJ0vi2/+lZzXosj5Z92hb97XQaf9/IKzjO9paxymDr1hWvde0rD+V+JddWgO3s6neL6I8HBgk+MAiXPFLihJFqXdSeh1PJLuXbXSKyGz0aH/vm3jLknISISlkal/uzJIMX/Dvtv/Q8wWowJtZk799dmRLIswtVBqyqP5/NLZQvZB95MQ2tMwdU4C+lfNyj3/83OXavLN9PStUFW/0ZR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1. the numa parameter was straight up ignored.
2. nothing was done to check if the to-be-cached/allocated stack matches
   the local node

The id remains ignored on free in case of memoryless nodes.

Note the current caching is already bad as the cache keeps overflowing
and a different solution is needed for the long run, to be worked
out(tm).

Stats collected over a kernel build with the patch with the following
topology:
  NUMA node(s):              2
  NUMA node0 CPU(s):         0-11
  NUMA node1 CPU(s):         12-23

caller's node vs stack backing pages on free:
matching:	50083 (70%)
mismatched:	21492 (30%)

caching efficiency:
cached:		32651 (65.2%)
dropped:	17432 (34.8%)

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

I lifted page node id checking out of vmalloc, I presume it works(tm).

 kernel/fork.c | 55 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f1857672426e..9448582737ff 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -208,15 +208,54 @@ struct vm_stack {
 	struct vm_struct *stack_vm_area;
 };
 
+static struct vm_struct *alloc_thread_stack_node_from_cache(struct task_struct *tsk, int node)
+{
+	struct vm_struct *vm_area;
+	unsigned int i;
+
+	/*
+	 * If the node has memory, we are guaranteed the stacks are backed by local pages.
+	 * Otherwise the pages are arbitrary.
+	 *
+	 * Note that depending on cpuset it is possible we will get migrated to a different
+	 * node immediately after allocating here, so this does *not* guarantee locality for
+	 * arbitrary callers.
+	 */
+	scoped_guard(preempt) {
+		if (node != NUMA_NO_NODE && numa_node_id() != node)
+			return NULL;
+
+		for (i = 0; i < NR_CACHED_STACKS; i++) {
+			vm_area = this_cpu_xchg(cached_stacks[i], NULL);
+			if (vm_area)
+				return vm_area;
+		}
+	}
+
+	return NULL;
+}
+
 static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 {
 	unsigned int i;
+	int nid;
+
+	scoped_guard(preempt) {
+		nid = numa_node_id();
+		if (node_state(nid, N_MEMORY)) {
+			for (i = 0; i < vm_area->nr_pages; i++) {
+				struct page *page = vm_area->pages[i];
+				if (page_to_nid(page) != nid)
+					return false;
+			}
+		}
 
-	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		struct vm_struct *tmp = NULL;
+		for (i = 0; i < NR_CACHED_STACKS; i++) {
+			struct vm_struct *tmp = NULL;
 
-		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
-			return true;
+			if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
+				return true;
+		}
 	}
 	return false;
 }
@@ -283,13 +322,9 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
 	struct vm_struct *vm_area;
 	void *stack;
-	int i;
-
-	for (i = 0; i < NR_CACHED_STACKS; i++) {
-		vm_area = this_cpu_xchg(cached_stacks[i], NULL);
-		if (!vm_area)
-			continue;
 
+	vm_area = alloc_thread_stack_node_from_cache(tsk, node);
+	if (vm_area) {
 		if (memcg_charge_kernel_stack(vm_area)) {
 			vfree(vm_area->addr);
 			return -ENOMEM;
-- 
2.48.1


