Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F0EC54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527116B00A1; Tue, 28 Jul 2026 01:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD896B00A2; Tue, 28 Jul 2026 01:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C52F6B00A3; Tue, 28 Jul 2026 01:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11F656B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 839CD802BE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:22 +0000 (UTC)
X-FDA: 85037054844.16.DB3612A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F07F1140004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D79Wl+u+;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTkFqCNT/LseVbtXKhwVw4AevH2QQucXk6b0DrI2IK0=;
	b=LsbxSN3oNfzjE3ImwFr1VSqbtg9lnhhb8WW8yYLvXJECIiiqvJA9LgWVDPma8PdQMgY84d
	705tDfwwRrRkvjzJp95raajvSMgiBGZXk+gnfCW41HLCs3Ga2Bj0aeujSk7Z1n2QjV2rpJ
	h8DEUD9nOaCUZ7TtDqGwuT8ieL2UvSM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D79Wl+u+;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216501;
	b=jwwdh9cfGIJ+aDH3EpYndxalOgqhHwteYx+qnnPt3uPHLJrHxJTdZGO3qPXSWdvmMCs0hl
	fiVGFKgHA2IkRO3dzfXJ5hHXwzg7iIF1Mo7+58QgXvGV56nZd3kSUY6qprljbty6gHgAUs
	d8R8EKklSdgHVuu++OSWfD72jABfSfc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5873043C50;
	Tue, 28 Jul 2026 05:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5931F00ACF;
	Tue, 28 Jul 2026 05:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216500;
	bh=FTkFqCNT/LseVbtXKhwVw4AevH2QQucXk6b0DrI2IK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D79Wl+u+H5GZQ89D0Yq2/pD/Qra22nMMYXqRknbyYwIsEbcCD7WW9xAg9oxwd88An
	 xV8DXBGQwXek7sdNI1+/P2r+TOL80aLQoH7SjT2wad84L4HKAH3XHP3dv6H0bA3Fa9
	 FGT6iScfI62Nx3Y1Y/zfRix9/U6Ec/IJSwpyI56y0Vi9japCqQGGwqfXC0gUiuXASz
	 WNYRNlCmVhdTrim+l9CXH8b9n2BOG9fpWHjdI92kMGywSELOcaj6TArv6jmfM4Vq4q
	 0oeuRzl4Fy1qe88mMbEnpyJnNcq6g2sdBegU0Ds7q/99Crkz7QYJeJQQ500YldL1Gk
	 f72SYsmBGR+Qw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/10] Docs/ABI/damon: recommend subsystem doc instead of admin-guide
Date: Mon, 27 Jul 2026 22:28:09 -0700
Message-ID: <20260728052811.192712-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F07F1140004
X-Rspamd-Server: rspam01
X-Stat-Signature: rxfkyfgcucue94cpjaqpkkf5xf38xdrm
X-HE-Tag: 1785216500-629228
X-HE-Meta: U2FsdGVkX1+fjhA3qwNzJQG923/37UXvuLeHKNrJgQCLruZCQqDFYbGk0LE6xchr/e8dq+IawgG1Sx+FQ/+NY7XWyoCXDuskZZudcruechse4pnjj4oQ4hkrdVWIdzJracXFahzeUPRDVe7ByzrBI0y8L5z9VHhMpPeS9zeN1qviQL56af+0FrXnqmR71f/u5pEogrjDQUJHfVPEGixLcSowncR9TIxvJI+iNWW45ISgIgKEf7EPnBlkqhE1Cj7+mYpxEFmxnYF9BTATj7MDANh8V7gngMpzCpR+kutKtbCaEIlbLrB+qV42L95WiBz9lDeq9prugydWgbwG6SqtKcfk5rWqwQXaRWDJej4ylehYwiFoyOsBsN+HF+m0yaAzDqxmLH/icDdNme/LsiuHRTBdBJCACOu2PckqOcvhuYaSoKR+bua/l2ch4M1JBX4XRZAfqkP5nB/3d8MnvbMz/SZG/pWe1wagzI2CVgbAg3JlXTNeuxCDW+3pTVs3UUwqeBfXFl7gW8IJt7zelhP/3AaBfgKFJRGVRE3uhWSgIiV15GoTBhMpgw7qfrLv2zNqWGGLCKM5BN4Gb9qZZFN4KbmopSITYaRuaR73ks/SNYbR19y8xsKVC6taMdSN09D2Cg2GKFKrJL4uZMeF7TMw1IhOLdwRYW7PN2nXQES1yZjfeNiqxODN1kONae3mKz0hWSOVEJlOuNiY/+XnF3lZTHLG0ndj3L54tW9aalUkqeChqThYUq26wCIBomCYFeC2OA+ay/uzDHu9obYjJ6oltpHge5CWqwJsqIIVFzcyVu2LrYPqL51/yLFZAxcjNxh0wjuBWnE/gY7ZhR3FHz96ScQbQexRwGIEILJmy3r4TqWYT91rWRSsk5+amS27d4+rwczRyNWwzp8TQkbkW4/iHcHQET0N76c4S5a+bVUqz2BNBKNm7R+SxTpSRPcqnRn6JMKR9Tb5nwfSaQoYGCl
 TBw4RLke
 qi3vqTGkSHDAMji/vhyaQbp/pAl21TDnXKGADODW/60ptQk1JsA4zLyWwHCrARvGevHuJ6zYi+7OuQ63tFqmXGitWx6CumZdiM0x37PhQGSjKQT30/lcsDwqzTzkvwbqak0EZcV2A28e4KXAa2i98sdep2xL3pJIJbcaOPXoTx/hPR+AXfuIr9eA5fT5lvvZyfPWYKa07euMRR/bgHtgGMih1792gtO1RrSkLK9980lPcGqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON ABI doc is recommending DAMON admin-guide for people who are
willing to know further about DAMON.  Nowadays the subsystem doc
(Documentation/mm/damon) is a more recommended place for even beginners.
Recommend the subsystem doc over admin-guide.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index f8d2601e82904..ad21f58f3c912 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -3,7 +3,7 @@ Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
 Description:	Interface for Data Access MONitoring (DAMON).  Contains files
 		for controlling DAMON.  For more details on DAMON itself,
-		please refer to Documentation/admin-guide/mm/damon/index.rst.
+		please refer to Documentation/mm/damon/index.rst.
 
 What:		/sys/kernel/mm/damon/admin/
 Date:		Mar 2022
-- 
2.47.3

