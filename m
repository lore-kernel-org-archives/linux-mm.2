Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5562606A32E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=CALEGwdc
Received: by kanga.kvack.org (Postfix)
	id D52B26B00EF; Mon,  2 Nov 2026 21:07:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCE66B05B1; Mon,  2 Nov 2026 21:07:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3DE6B05B2; Mon,  2 Nov 2026 21:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9673B6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:07:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 276CD1C240B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:07:44 +0000 (UTC)
X-FDA: 85392171648.16.D79B5A4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 86C7E140008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:07:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CALEGwdc;
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793671662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UCNW70wWpSOTe+qYE8btjgaS6NPKbF5U87PIw6GRK5A=;
	b=xlyjfd93AsgBUGw3j1BB+dvP0vMZmi+6XI+mc47ILQ66OBK7j8KM0VtPTyR2IdLRqWn3aM
	i2+7qKR5T1H/fk5c3t4xXY8gXV1Ojb8tLOPLtP8/1d2RSp8WwBPy4+JH3NmO+j25IuBoPL
	1wcnuav6VSksODHMOPdGOjxLM4jTmm4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793671662;
	b=49zyXGqYYG48zA9wRcZBKHs2yFHLK9GN70Et0EyJBvHw+gbn27qusqUaZtLxKrTGNo+lX/
	JtvUcrIVZ4c1jkLf0Ccgm7lZ7BkLv6X3UDJ0DRrosvRP1joHUjLqOTcP4duUKlWR8gSX9g
	8lPw40M9muQZiC2Yz+VTv3d8OBWCVww=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CALEGwdc;
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UCNW70wWpSOTe+qYE8btjgaS6NPKbF5U87PIw6GRK5A=; b=CALEGwdcQDVbA73bpGaOuE67Qg
	k0OuzbETTSvvki/bgzXs+kXGUIY8LcKWUhQqaVM4FdqBiB2DXo7hZgbwGLyJxH1A0YFPW1NzLcFz3
	r5fDIf6UfB6PTla1NaMBjqsGz1zSlc2hdqvLVqkHX9fYrqqhp5kfRmvV0JlkNyBoWxpM5ZM559/52
	i+mth+Brijk152leS4KzvwT5+qXbLhKnib/B4TfYqnbMKEtbU86v0XMBig8+4Q5AutaFjyqhjBdv2
	rIk4WVJCzsvsVjiNCh+I94vG3rK171dNbD9BfJUabV08jOBUI2XLjrd4ZApRO71Ly7i9QBifpPmBW
	rFHieI/g==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xO3vt-00000000qsM-3jKy;
	Tue, 03 Nov 2026 02:07:38 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>
Subject: [PATCH v2 0/3] maple_tree fixes for 7.3
Date: Mon,  2 Nov 2026 21:07:21 -0500
Message-ID: <20261103020724.2614498-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3onek1mad5w66y81d1wxr3xobn8m86iu
X-Rspamd-Queue-Id: 86C7E140008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793671662-1180
X-HE-Meta: U2FsdGVkX1+7aZKPp5WAmhqFMyMqJdYND4JZETl7NItWqImtX+FjhC/bDBW7u0Tg2Ix82LFegO6fjmL+U3UxTRf/aZJJHhMVIi8ULREUk8a+NrA+1hAPaOtZcHTqTuTb9vjfFwgOL98Lo8vxEZGgju0jtiLD/WQd4opxboyVQeAn2dvkN0f9KBeOMXq7qNkiliQ02JGxCZQgwyMiV8MoopLoVFByM2oI8z8NpDhEtjCRXFZr7tXpqBNvi9jt26nXLsGdVyjKIlRybh5Irr1DSFEDD5IvgyLF7BvlUF4ApSkMGaJV5UtrN23LHDQNhicT71W9xRvq/KlsR7EO+dqhB9DlC/IDuwlwhg5Tm4pTxH9qzIyanmZnJnsHibCmM1xOZ3wQOcSeyCPibtwPZlyIOrbJAD2nUT6zG62D7/mVITnv6DWVBmxOIQMtRrR+LHi0nZCaPYQ2PgIuMdC7w/AHMghzaQpOtgqDbpy0bT7afr8L0/m0MQ6Kxau0OqzQevO+HmUZthFpZ9AMukuiR+p9OYphmlnLWx4bR2MgAUmaSy6egG5ljgmlIwPdz5lYi/3FI/zH0PS2vSLZdmjo4S8gPsGqmcC39Ewi6zgA2HXaAADWvjEmeaHG6/yAI5yJWy/I5aXgYuxw0xT1K408SzMwLwN5innGnOlH0AJdWoYJa0kb8C6AIaAfZxUsZZaQep06bKYdSVFPw+lZMyPb9sS2LbRQWrmUf2E5aNB08xcoLEVhDGt6KNSXl/EFpTT/Cooi3o+KnjGpHv2H5RyJRl3G0KvysMC2fvOljkmaW8WufKYaFbMK+7G9TOE/hpGPkb84KF8xVvD9yYSTWdyuWvDjPaOKAZSV7LJ9YzsV8QUxpxGv1HetLXLI3aM/wwBzRToxIq+iqzMl0+57AjKiKykyaMSB9GqKRumkmR2JRiQ7bL8ob6/GLeFeq2jbJ0TZx+1e/d535lmuAmACzivLKRz
 4itpGFeZ
 OkJ206S+MOncMfmqasUC1YSFOWn+gvqC2leoR2nT16Ln72egD4opNkoEdmNSxAJOXKOpMJ1deJfPkM67Yow/JKzpOoqyV7IZmW/FV2OqZOiunpNmJNp7vPpQ06J410ye32V4+6e1K6lAJywQ77av9gx3Sw6paHPrfBVDED7O42GlRW42qVUwCSZrUT87O7lb1mGjdE20oNGo/i8mmTgz2YrJurWRI4TysYVhGqOwujLeo09TRYLUUa3ptnCWsvr/TszD6IRxUadbXfVJ5qvr7otmHKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Two bugs found by an LLM review, and one problem Lorenzo Stoakes
reported off list.

An RCU reader that restarts after its node dies can dereference NULL if
the tree was emptied, or holds a single entry in the root pointer.
Patch 1 fixes it and patch 2 adds a test.

With CONFIG_DEBUG_MAPLE_TREE, MT_WARN_ON() and the other WARN macros
print the tree and call dump_stack() rather than WARN(), so syzbot never
sees them.  Patch 3 makes them WARN once per call site, after the dump,
and makes the BUG macros BUG() after theirs.  The userspace tests make
WARN() fatal to keep failing as they did on dump_stack().

Changes since v1:
- Drop rhashtable patch.  It is still undecided and will go to linux-crypto
- A reverse walk from index 0 returned the new root entry a second time;
  fixed and tested (Andrew's review bot)
- Fixes tags point at the commits that introduced the problems
- The WARN macros' once state is reset by clear_warn_once
- WARN() is fatal in maple-shared.h (Lorenzo); the maple test exits
  non-zero on a failure

Liam R. Howlett (Google) (3):
  maple_tree: Fix rcu reader NULL dereference after the tree is emptied
  maple_tree: Test emptying tree while RCU reading
  maple_tree: Update internal warning and bug_on code

 include/linux/maple_tree.h          |  48 ++++----
 lib/maple_tree.c                    | 112 ++++++++++++++-----
 lib/test_maple_tree.c               | 165 ++++++++++++++++++++++++++++
 tools/testing/radix-tree/maple.c    |  13 ++-
 tools/testing/shared/maple-shared.h |  33 ++++++
 5 files changed, 316 insertions(+), 55 deletions(-)

-- 
2.47.3


