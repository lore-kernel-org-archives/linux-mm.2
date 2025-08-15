Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC8BCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4911E6B02CF; Fri, 15 Aug 2025 19:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469786B02D2; Fri, 15 Aug 2025 19:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309F86B02D3; Fri, 15 Aug 2025 19:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23D306B02CF
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:39:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAC501602D8
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:39:57 +0000 (UTC)
X-FDA: 83780612034.17.2E10B7B
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf30.hostedemail.com (Postfix) with ESMTP id B35B78000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:39:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="t p/EqI5";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Anh4ktML;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of boris@bur.io designates 103.168.172.148 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755301195; a=rsa-sha256;
	cv=none;
	b=CspaWeYbzooq03/+gwUYIIDoCpelX4BwXw/KyUMBh9KsQ+tOELx8pyGT964b7E+y0BDcrd
	eqLaFQuV1yq+NZoB2QM8gzMUicwo11kbnTG15DmrHr4iLjdLK3PE9wzQ82CVVniAFM+gcK
	FtQxbtNsld1AbrFk/jDiEVsla+rK8ME=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="t p/EqI5";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Anh4ktML;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of boris@bur.io designates 103.168.172.148 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755301195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmTC3EDeGw6G18ZhnPvPy7FSHrY+VoBy9Wew8lrgMlY=;
	b=dhR8tXu7I/PqUnUu331tK9/UmZCnBNOYHvFxv0MuGqO+7TAe6+uZRjuk+tUn4Li0wC2Ibb
	GrD+CrpK0dljjuLU4d04l99HiHn92DLkDtfUVPjR1LqWef2OyDk7R1vHEC/zezVFHXkEeC
	Q7nUEVUC4r1iNa/5rSk4e2ZoIQR6Fd4=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 12335EC0105;
	Fri, 15 Aug 2025 19:39:55 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 15 Aug 2025 19:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755301195; x=
	1755387595; bh=UmTC3EDeGw6G18ZhnPvPy7FSHrY+VoBy9Wew8lrgMlY=; b=t
	p/EqI5j+3HFY949isxvTPgP21vEaMoJFxcbis/AZu7FRjgKS0RLaT3sf96RC4efA
	lg8pQomdYVV0YRX7JEMC9LbYxi7tGBpFcNvUkpG41wV69tg7+szYmNowE245qv0X
	ANcu4aW0wtuNismWBIK+NPeRO7gwUWZO/VzaMFpsGnlpQ2H9xMmKVq/JwUzG8Syq
	tWS/c9LLqrbKUuTp8C6twncwbZLFUhskxM7P2Q9C3OS+G6GkbJTS4FYwSdBr/fdF
	hS48+srXbaI+ogK/S5axO6grkAilPw5MMuaDBMDE0RB4evwm0Tw7KK2vOFjgBmHR
	9uBz916/68o3hAJDWVsRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755301195; x=1755387595; bh=U
	mTC3EDeGw6G18ZhnPvPy7FSHrY+VoBy9Wew8lrgMlY=; b=Anh4ktMLc6k5v1sxr
	48SH1hyeFHL0qxMUA6XJQBhj6Css7ZfMfboylKSQ34rgmrB2giJqxBHMix7tFUk4
	LzyfAJAmFA0+Bxlk/LujAtezMWS7cSai6NJN3b44H8m2YdcR2PTtAfH/4I0G/1+t
	4YBbm9RyBAceJua7DY8sJXwCyKcYg5BJDsrY4uRajNmHvucFH0mEBfhFqk/6wtTb
	vcsjnAVzo1sW1UBHhqRWD/xzfTSG7qSj+M4w+2ViYNgOaBZxVnSmu6di2VX74peu
	rgGAIWtjm9ljqQ38PQKVvSnwXJ+N8br7rGle7ZklF3yFAXTYpWx4SMnE/HkZtQT9
	gD3uw==
X-ME-Sender: <xms:SsWfaPFB4CtNrpC5kjJ3PlnTErfVlTjsK7FLyurww62hBJipx34e4g>
    <xme:SsWfaAJumzm_n2NFj95tAaxqD8oWQIs6NS02g3woLsTiwgbJ_DPRryDDET7uDfqB3
    nLpCHzP9of8RpLK8fI>
X-ME-Received: <xmr:SsWfaKMCKaSjBDvurjzUjnEunLG8DOLNrV50e8mTzFxxPCTZkPPOQj_pyZlisaXpzJBoN2PiKRCv8OhbY264mMdopuI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugeehfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephfevke
    ffkeffheeffffhuefggffhhedugfetudetudetueefveeijeefvdduudegnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepjedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdr
    ohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpdhrtghp
    thhtohepshhhrghkvggvlhdrsghuthhtsehlihhnuhigrdguvghvpdhrtghpthhtohepfi
    hquhesshhushgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdr
    ohhrgh
X-ME-Proxy: <xmx:SsWfaAnt8vn_5MXPNF_CJ0qFa6AlrhudmAMKCoYuASVL3pVGglMEQA>
    <xmx:SsWfaO79GY718zGpGe83y_jagxFJkExzLVEMY1t1L2x9s3Ck6XhBsw>
    <xmx:SsWfaE2wKeolHsN9YDG16YkATzWoApeBZ8bRk6RQFaU1P6fcIoVcbw>
    <xmx:SsWfaJFcCurQpoq8-SQjG6Bcs9gLWXg2HGjW1Ucw8nTNj30f1NCSgg>
    <xmx:S8WfaNHolf58oLio2ooRBuNQKMgFfRJzvckAVWFmFgkWhp-7sVIh9_ix>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 Aug 2025 19:39:54 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org
Subject: [PATCH v2 1/3] mm/filemap: add AS_UNCHARGED
Date: Fri, 15 Aug 2025 16:40:31 -0700
Message-ID: <38448707b0dfb7fabae28cbebba3481eec6f2f4e.1755300815.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755300815.git.boris@bur.io>
References: <cover.1755300815.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B35B78000F
X-Stat-Signature: stjkzgfzrktt4enuy6wohbcr8szzp5cn
X-HE-Tag: 1755301195-989023
X-HE-Meta: U2FsdGVkX1/5dDKIZyyQyprBKFyukh8F/RHRlz682ASa2xEgZEdwKKDANXXYERvVyZHaJVwAqq9/VDNfO3Zq0qRemLEVLDHbNWy7YtN2yJbruo5lh8DmSYz127xAQQP9B/usKCRxJIA6jnn5YUhYYAi6Pjj3UaCYq3jtkQrNH4g8vB0zOGVqlEd0ta9OnQODoKw/jl7AkK+JFWDg+AgXZw36lg92NR90EpYto4UwSfpt0/3gOVLfqwpCFGEfdfhXsxZCq6zU0TNnAsEGB5AiPS9z9/wjUEfDH4Z5zK1JcBwKk14W5y42uhaZgDMS/XwvCl/mlfI2ewRfNIBwVgFpAdKrK1fvhjabbRb+HI5G1GeVca344G9/4HTSrhxFZDoozBxLGPfeo+hThGwhXsdGV5XPmopaGh0WBFcOeSJqwEWbcvTEjkR8N75sVUbENBkGo/50/460Iv0p0a1hO7/AqZtbdeL887+sqM7aB7dmlyr/Sr7SUfRWGzuX9xLGnq0suboKTDyA54Csn7OmxHCvigS1ZM+q3j75mTsmuutWowgINffNcP/7+elmeWUUiKELyVl4Us4xf4cJvb3XsoGjDfc5Ks1UK3GhydOJ8HWdZOP3op+/MXgrWuZq2dWp+Q7LHk1EPH1e5wNDLTXs4m51JFKzDOa0mRZsxWZRvGRrzbPTN1XAZhTQsxltL7ZnqXtNkJPDIYq0a04pue23nJonnMafgZPoSXKELPsvynAqjQvau+NK1rT1hx1z/hnhPraIjE6eGLmKdMIRvwtPZA4aC2yt+wMuR1wBmV5yyGuVIoCIl6E8BwB0DOCa1YyMYrIny3Icudi7CtJOU1BCoeJi3vmiXvTNoagnGJbrVK42VIWTbnntkbUlyfaBSSKzESLImYHWJKBdloTrULIbNlY0d7xhjIaS2Al5H7LyUSmVaFCAiPTeBJRM0OXsJ+rX3OmS9ybNLg37hYo46WLyUtg
 E4j6N2AK
 qdi6Qx6xnS5bbRBRGIy3ZPX/lgeyIT0DThgM5uJ08ddUtTSMCTPYsKppyD7FWbjNF3ANjMX+ZDoF5k582mk6CFGX9uhDqk0mHoLOI2tKymd05UdheafRAd580lACKHZ9I1aC/gIAjy/uUuNw34r7NkcwARF2otcQM7pMIyYxMnY1FNYwJ7RlV7HSS8XWz2vgYEmgA+alr8L/ewAtViNh85Zd3suXZCa5ZWOTCzPLSIWLay5tDmfhKFU/kIZyGNPEhTSmQ7jR0NxxKF91eGCLt4cyHZXG+64WSKELkvqpvKt6ByIAdjowIurIqoOvNbqAoJd93
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Btrfs currently tracks its metadata pages in the page cache, using a
fake inode (fs_info->btree_inode) with offsets corresponding to where
the metadata is stored in the filesystem's full logical address space.

A consequence of this is that when btrfs uses filemap_add_folio(), this
usage is charged to the cgroup of whichever task happens to be running
at the time. These folios don't belong to any particular user cgroup, so
I don't think it makes much sense for them to be charged in that way.
Some negative consequences as a result:
- A task can be holding some important btrfs locks, then need to lookup
  some metadata and go into reclaim, extending the duration it holds
  that lock for, and unfairly pushing its own reclaim pain onto other
  cgroups.
- If that cgroup goes into reclaim, it might reclaim these folios a
  different non-reclaiming cgroup might need soon. This is naturally
  offset by LRU reclaim, but still.

A very similar proposal to use the root cgroup was previously made by
Qu, where he eventually proposed the idea of setting it per
address_space. This makes good sense for the btrfs use case, as the
uncharged behavior should apply to all use of the address_space, not
select allocations. I.e., if someone adds another filemap_add_folio()
call using btrfs's btree_inode, we would almost certainly want the
uncharged behavior.

Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 12a12dae727d..1ca63761a13a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -211,6 +211,7 @@ enum mapping_flags {
 				   folio contents */
 	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
+	AS_UNCHARGED = 10,	/* Do not charge usage to a cgroup */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..6046e7f27709 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -960,15 +960,19 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 {
 	void *shadow = NULL;
 	int ret;
+	bool charge_mem_cgroup = !test_bit(AS_UNCHARGED, &mapping->flags);
 
-	ret = mem_cgroup_charge(folio, NULL, gfp);
-	if (ret)
-		return ret;
+	if (charge_mem_cgroup) {
+		ret = mem_cgroup_charge(folio, NULL, gfp);
+		if (ret)
+			return ret;
+	}
 
 	__folio_set_locked(folio);
 	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
 	if (unlikely(ret)) {
-		mem_cgroup_uncharge(folio);
+		if (charge_mem_cgroup)
+			mem_cgroup_uncharge(folio);
 		__folio_clear_locked(folio);
 	} else {
 		/*
-- 
2.50.1


