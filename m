Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C91F55805
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 04:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE8E6B008A; Tue, 21 Apr 2026 00:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7624C6B008C; Tue, 21 Apr 2026 00:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677036B0093; Tue, 21 Apr 2026 00:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36ED26B008C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:49:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6CE18CF70
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:49:48 +0000 (UTC)
X-FDA: 84681335256.30.B439396
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F00A180012
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:49:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ULln33mB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776746987; a=rsa-sha256;
	cv=none;
	b=LAH4a0E64mbTW4j9bmZVjlusQBQtexz69tMFuGh759bR7Pp7HntwdjZ+8iGIloDEiq1S7Z
	/f37FBIRBCI1hXJiYbpdkG+ILIJ1nTnfUSNXLChW3bgyfmMCKJjLFyF1ZvsQpzScOIbMP1
	PFcNaoQOUZs0PW3Gp2nwF2Q3ACSnVUU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ULln33mB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776746987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxtW6Kli3Sic3XH89y9kl0VVuaLbu/hqqvU3S8hWBqo=;
	b=FbBR5xhC9jO2w5d321iyK/sgeXr+LYcVXGy4oDomRh9A7fSHORPNrc8HKi8IG2cJvAZ2/Z
	8CnlqU8+TS93VOWu9p5c7yH9r18EHw2LomAmDqt+xpZQmgzkAXcONJ16Y739/R8u3Gx48B
	HFY8THuITRETiMRD9L5moFZKD00CjRw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 022B5445AB
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC367C2BCB3;
	Tue, 21 Apr 2026 04:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776746985;
	bh=58RqIGxjkE+DGlcSy5aHIfF8jnvuEdtFZZsL+mLllnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULln33mBNTI3tL5SwpU2ppT2qiQ22TC5bpbiUC5rjOoQj1IpPFMqFMUFXCw6yE/cv
	 KaG90NotlnowFbXifeKAOAwW2xcmatGracrelf8vM5cRj49xOylnI4IVRJBempzfBt
	 p3n7uRjBh1eG3WdDuw8r8kGLojkP72NQli8YgW+HLRZyiQRxSiH5hDPJpwq+Ky33D+
	 AqBrNbQFN0BGmV5qeIsj+kcsoCdSG0DEvtLtHsoe73Op/m2ATggp2KGYDhB1jMwsFA
	 2NR7UYZnxwm6KZ9HohH8QFJ1+cdEs/X+BLtuZPJ4KhyzJ1m5FqDjggB2eqe7BNfwex
	 4u3OkwntHcJ5g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/2] Docs/ABI/damon: mark schemes/<S>/filters/ deprecated
Date: Mon, 20 Apr 2026 21:49:27 -0700
Message-ID: <20260421044928.141388-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421044928.141388-1-sj@kernel.org>
References: <20260421044928.141388-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F00A180012
X-Rspamd-Server: rspam12
X-Stat-Signature: enqbc6417ian4s4n63wx3irdugdcadqc
X-Rspam-User: 
X-HE-Tag: 1776746986-997207
X-HE-Meta: U2FsdGVkX1+JlMUkNsAg3YUwQXKO9uvhr3TL/rB4YluuncoWxgXfw/JSFd0qW6cFPoOpSaNgNN1kAe6sCkTXPZT5LBApZ/N4NuvduHMLzzA05x3QpYtlggjNXXE//XagrtGi+oRvhc3ygd+W6+olN8CaCulLAaqo5NeqpE8QQhZmKk8TC1Xb2IwrjVniJP/ZpCcsAb95fhDhqE14GUJMMYeWEYTnDQYYAB5KhqgEWwbECDMyoVu4sQtvpy12ZCoqu84OWpItZj0DJC8Jo+MgFNKRo609s9M+sZzEWjrG4dDo2VHaY5d/sho/Vm8TIMthlnz6wZunM5iExrsaSpfkoDkL1v8aNYHPA5nHssECwRTFQxZIx72Ax6CGpQfhsvHOG0gwfV8kyUuEuHs7/c6aeRA6PrGFHv48QPRj1KkSEsRAGGFuApiDVkinQhb4yLVIZdCdWCPDFsRooXFsC5thA99qsZPS3b+pSJC/6Hw9NBoFvN+e1VNMyRiG2A9AaAJ2gPnv+X2jS/5VR6a4VAzeUhlxzT0ES3o0Ka7OAU676MkUQuAZfzFDl2JGsG43cnc0pg6huIqfhOkIq4UgvaUxzyFyrmTzrf7XjQR5x0fKvLhg7rIHA+VA184slwE3W7Smm14tkbyucN2ALtfGzwfUYln1xSCqZP6e5Won6rDxr1HTGjUxt8Kh6uraowAA00CMKcOZ2ZQf67wwl+kHaLp5xenA6ZhXIosc8MUh+fNT3tsMRDQJzNYguWJC3DXqr+RPkRZW1Ae3gZRSYfPxP0/Is5pDjxKdppRKE/lq/Nr2giehw21KwzfW0dLYC7BMLrH3rnHDB5Wno25Lpjxy14l/J8WS61JbfLOeyN+/OshoBEmm0Jk0imlzswTnbYKUwH354cOvsNuKIqWcBaHQl/AxruxLPRn1DyEQpMhjBILA3h1Fo/MD7NDgMqa7lBZS89rCyJq7sgoTTd6hlToRwdz
 VbiuymOd
 Teu1ItErg5jXcLG0EAjWkwHkLBiZfLrDYnK4mp1hizz3q8w/IJxPcvVi8HRtNYgOPf+OLWqPaVKmnaMLsrnHnK6ywmn8V/Sj0Z9bYhXKsKO2gBL4JayqlrxnVJJZ/UT9gMUHUxppe72qVDxfh1V84WxCE8QEK6cvmUaWZH25VAGV9OUJU5bU5Laba2CGA7rFmafkm+2HjpgrWEIO+jj8ud/Q2adQdVwqMEjbkO9gFMoO9XYfRa/FyhQh8yRa4VuzGAPELreZzvhNL530q1NbxOvPP5RdxaLgJPn/6Azg/XG0UHxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now the 'filters/' directory is deprecated.  Update ABI document to also
announce the fact.  Also update the descriptions of the files to be
based on 'core_filter/' directory, to make the old descriptions ready to
be removed when the time arrives.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 62 ++++++++++---------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 971c22e34e722..ee29d4e204ffa 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -396,15 +396,20 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the low
 		watermark of the scheme in permil.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/nr_filters
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Directory for DAMON core layer-handled DAMOS filters.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/nr_filters
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing a number 'N' to this file creates the number of
 		directories for setting filters of the scheme named '0' to
-		'N-1' under the filters/ directory.
+		'N-1' under the core_filters/ directory.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/type
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/type
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
 		the memory of the interest.  'anon' for anonymous pages,
@@ -412,77 +417,78 @@ Description:	Writing to and reading from this file sets and gets the type of
 		'addr' for address range (an open-ended interval), or 'target'
 		for DAMON monitoring target can be written and read.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/memcg_path
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/memcg_path
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'memcg' is written to the 'type' file, writing to and
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_start
-Date:		Jul 2023
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/addr_start
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'addr' is written to the 'type' file, writing to or reading
 		from this file sets or gets the start address of the address
 		range for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_end
-Date:		Jul 2023
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/addr_end
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'addr' is written to the 'type' file, writing to or reading
 		from this file sets or gets the end address of the address
 		range for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/min
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/min
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the minimum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/max
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/max
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the maximum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/target_idx
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/target_idx
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'target' is written to the 'type' file, writing to or
 		reading from this file sets or gets the index of the DAMON
 		monitoring target of the interest.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/matching
-Date:		Dec 2022
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/matching
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
 		the memory of the 'type', or all except the 'type'.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/allow
-Date:		Jan 2025
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/allow
+Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
 		applying the scheme's action to the memory that satisfies the
 		'type' and the 'matching' of the directory.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
-Date:		Feb 2025
-Contact:	SeongJae Park <sj@kernel.org>
-Description:	Directory for DAMON core layer-handled DAMOS filters.  Files
-		under this directory works same to those of
-		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
-		directory.
-
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/ops_filters
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Directory for DAMON operations set layer-handled DAMOS filters.
 		Files under this directory works same to those of
-		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
+		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters
 		directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
+Date:		Dec 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Directory for DAMOS filters.  Files under this directory works
+		same to those of
+		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/{core,ops}_filters
+		directory.  This is deprecated.  Use the core_filters and
+		ops_filters instead.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/nr_dests
 Date:		Jul 2025
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

