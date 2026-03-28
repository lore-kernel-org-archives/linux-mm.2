Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9344010F3DC1
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CEC46B0096; Fri, 27 Mar 2026 20:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080056B0099; Fri, 27 Mar 2026 20:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89DE6B009D; Fri, 27 Mar 2026 20:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D01486B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:54:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 982901A1467
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:54:18 +0000 (UTC)
X-FDA: 84593650596.23.742BFEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E7B3F20002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:54:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KbxFGJ/1";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774659257; a=rsa-sha256;
	cv=none;
	b=fIh9yYsQqhdXINduBOVvGVBAmz63ILp8dJogAyGKcqEsA+As8BAGyDlbY6x9FAv1qSpTCt
	1kXA2ynwHbLLVyIBs/46bjSJLmWAEtSvRdbqpgYB5SNVzvQ8TYmbgwrYV/Yo+HXa/uztz8
	H3xfE4iKpOsQ9rAyhWDurLBjB4GZPQo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774659257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59vS6w5KqRkE1jhlSYx9GY/TDsLh6ZRrkbovFCvMCzY=;
	b=snax7HhJ3L5dc2kVgw2Fx8VlCY3FVlFA4bhUfeJ6nx68Iw9u7GpG9B7NEJFzjm0K2ETBTx
	jFPVnKFTKH5MbtEsSy0flx4YWyZz1QnBq/ousod4BvObkCHRlYuwnm62ZBqEV5kLPqpiBP
	9k8YAYgBOX5h0Nr9aM/pIuSzlVp+/mE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KbxFGJ/1";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24A0F44468;
	Sat, 28 Mar 2026 00:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FE2C2BCB1;
	Sat, 28 Mar 2026 00:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774659256;
	bh=xj+qGE0/+xoZp0bbzzefLJA/Ga+imeoh2utC1fQRZVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbxFGJ/1VvEfifuvXF9eb1wOC09YVBuwaq71eXVjuyBkPpR+mxbz473h7tddXueDU
	 DsMDGMk+EcOvrQa3ni0cXa602tIVOYGiRHUdJEPJ6XQKJxQ+BVbuTDhmBsej/Evzlv
	 u+aijzLWeUhVf+Iujs22FYhn3bxDGelB5WdaDvOY7MdEIxLv3YVPBTzNmyuNQpOwy8
	 Tw/l6titFFHfPgyHP3uCTo+jDEwQ0xH73xyrEozwVx5iCcS6Jz6nfBRtZY1NUKbGvx
	 qAkrqSJLKIn9NO50PmECP6W+VsWhHRf1dfEVgbk93UVvJt41iRYcclgGOX3RA6DXCV
	 prv6UP89Wp3CQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
Date: Fri, 27 Mar 2026 17:54:10 -0700
Message-ID: <20260328005412.7606-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328005412.7606-1-sj@kernel.org>
References: <20260328005412.7606-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7B3F20002
X-Stat-Signature: kr6m3uujcu7615sqjnf6i4kxqkyr8icf
X-HE-Tag: 1774659256-629336
X-HE-Meta: U2FsdGVkX19cNzT2UBIdtLeDpudwsvNwU6t1IS0y5ZDCt5o5LJNA87FP429XE9w/cDh35LNsw9U22lijzyOereNEiOU8CTPCmlU2wE2IZa2eMzWxmWgON+E5aBU9nmzSn2fpcBuNuJAPGlwBiwvMniQNVqFHo9+e3zRRmiX3e8KroK+qndb93L4PXhyeyRr7OJy98kk18h5zv+8GETQqaRIml2G673TW09FIoWmR3fvr8vtJ0vklUs6ykYCErpqGKdykoJYW4JHC7kw1lHcIsAUKVhndn252kYfP0XrjwUPpGQS/B0cT6CZg8xx2lbRzZ8iUw/s2rRazix2ViJT5k44vB2IAR0oQ3REW3pzDsEULHKekJCsuwFsce15R2MHrQzLzoTEowjAfyzjHB5SwvqME5d4Rc+exo9lA/dFAfXZFtigc6ukLVJbyP5jBC+NxJ9ulUVmFU23kTsBmVVKT3fbsMnPwhRxaP+ojDwg1ltrX4KK4yOJxt9OVxAClwWUkKdBJzXSDJaQBpsaHENvrn8W6Re8+2h4OB3N3SqElgmB61p+yNsV9PQWrICLABi4GEhDLpgbo32gEdBaxDJ5987ZgQPWwmOAyq8IFyvKvGHb/xTZlC8R0CDLmXVR+vuoX8PZF2o0+/3cl15JHfNIvDPF2nyEAK42p7WG1tzGmg8ozLiSEOfyikIzJZROnI9mE3xdulOSRzy8UeVT+Az/7Rc9ob3OHb81DLXu2Iux7uUykd8zvu50uE7uTsAeXqcuGHzOSYKSWgybZS6Mzkcy2PvK2PS3cSACmMm42rI4jttJeUBCMxHESX+w7alElRNgjrzL5CqLFoIyX10O/Ng/kNqS4oyxfos0M2CN1FwVlOxs3BAu84ZZL4VtTQx6cY5qRJdxKWP7jAjA1AKfRpEbDcR/d5dq8Y07HUZ8FC8a+pK18WkP6moNHcQSDFz7mdtOaC0Yor1WbyOlNRdpIKTc
 4MDXGZ2P
 quVOMFs7hmcFWjoHMPa1Cp0hEySW21bfq9UnQViRlj0R305u79e19sIyPk4lLNASp7UNAf8cJAXTB9kFuKJ1H6ldLcxDPbEVAN+ftTMhPr12U85h5jqmKamDlVlW2eOGTIHA/fOxbiheFHDJyw01qSotkuBufCmE0eTQ1V9VLKZlz7+8Bt4+0gExmdWR2MiiMyWbNPOzK7dEcMnnm1tfpDDY+hVtKX637vC4dN0OJ0uWbb4M3i0ANaXxlGzkGwjSh1E/Htyavkvk88PyQ+U+U3m79mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users can set damos_quota_goal->nid with arbitrary value for
node_memcg_{used,free}_bp.  But DAMON core is using those for
NODE-DATA() without a validation of the value.  This can result in out
of bounds memory access.  The issue can actually triggered using DAMON
user-space tool (damo), like below.

    $ sudo mkdir /sys/fs/cgroup/foo
    $ sudo ./damo start --damos_action stat --damos_quota_interval 1s \
            --damos_quota_goal node_memcg_used_bp 50% -1 /foo
    $ sudo dmseg
    [...]
    [  524.181426] Unable to handle kernel paging request at virtual address 0000000000002c00

Fix this issue by adding the validation of the given node id.  If an
invalid node id is given, it returns 0% for used memory ratio, and 100%
for free memory ratio.

Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9a848d7647ef..3298ee8d8f64 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2251,6 +2251,13 @@ static unsigned long damos_get_node_memcg_used_bp(
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
+	if (invalid_mem_node(goal->nid)) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 10000;
+	}
+
 	memcg = mem_cgroup_get_from_id(goal->memcg_id);
 	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
-- 
2.47.3

