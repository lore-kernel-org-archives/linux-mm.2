Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99638CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76848E0065; Thu, 21 Aug 2025 17:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D0E8E0056; Thu, 21 Aug 2025 17:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15088E0065; Thu, 21 Aug 2025 17:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE468E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:55:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68033160562
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:55:14 +0000 (UTC)
X-FDA: 83802120948.08.E3C83F4
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9AE27C0009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:55:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="o 15FyfC";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FZcoMawA;
	spf=pass (imf10.hostedemail.com: domain of boris@bur.io designates 202.12.124.159 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755813312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTjJpIvPC3sSZ8qeQ6s9N5Jc2/0IphFglsc/jRyQy4k=;
	b=6FmVlU76AjWCA9JUYQ2IPq7CWrtKFsANtNB/mWR2h9NZzixrqUGToVU+OeScuP+poAHUQb
	+FdJKhzH2dNrAyEQYP0+XLYIuS62ihJOqzsU5NZ48NRUd1/B0bxnwyWLyZvsEWVyvyV/HD
	DIe4oEUyYXs9xpC2r1LvepH3Ikal0IE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="o 15FyfC";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FZcoMawA;
	spf=pass (imf10.hostedemail.com: domain of boris@bur.io designates 202.12.124.159 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755813312; a=rsa-sha256;
	cv=none;
	b=O/liPl7BToVvgveQkp1wRVatsuiUvsWt/ZXkai7kMme11zxi48PqV0gwuP5wyfwpnfDeVk
	gAeYh52noA/tkdwH6/gTgGY1Rs3t8RhNEWIcNXfUvb8pfavmF8shWlqQkHlF5OnCq3Tz6u
	oak+opClnizhm16AJNiEtcZuAwMXBPM=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9F7AE7A013E;
	Thu, 21 Aug 2025 17:55:11 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 21 Aug 2025 17:55:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755813311; x=
	1755899711; bh=KTjJpIvPC3sSZ8qeQ6s9N5Jc2/0IphFglsc/jRyQy4k=; b=o
	15FyfC+Zds+sXQkGP85yff98CZCNS05vSrD7tg78D8+LPswpNTSfvCOtwaaGl3Eu
	q62CMRF7VGjY9rUw9IaXKIiOKBjUhmxcrQKk22Mcix+lPf64/k5DgEr6WiAY96Aq
	J7uIXFUTxteL8E4AFxecjEnARoYLtIr1yZ5SjtB6M50nUxDIRKR4IrTzK6k3Bp1m
	FJij1tI5QVNgI9DXUiDtwbd//GSCIUruJylUtOa/dPfbsvsOHyESqIzENXXSKB9A
	lJD6FklzUN372LC469iMrM09DRLvlPFKfStmt78DARJE9SJ2lRXHW9q5bVqxC9qz
	ZeDW3wRsHN60OrR0N50kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755813311; x=1755899711; bh=K
	TjJpIvPC3sSZ8qeQ6s9N5Jc2/0IphFglsc/jRyQy4k=; b=FZcoMawA/ebPtt9X8
	amYjTE5rrnagLUkcr9vdFqG3uanNnGsAkaWO22oynxPRexKTsjgQyLz9Yvso3aVy
	WEs6EGonhJctObBS384o0+n97+qiq70jyLkgB7GgtLuZZ9v1WfUWD8TG6/3r7l91
	6iiiLenRNa4ZoN0ANapRN1448n/A9KfYIgKrq58agw/EwgzOcgQyRH9pB9EkrM3w
	tkqIxXCcXB7ZFfI9Gfih2BDdOEA1Kh0gBxGVKhvNC9reMSMr+UodkWv+ITq39FbR
	/+NVlskBSJCvoVJmH3tSSlzgEvZl9S7ujjOJgwBnzNlHyHxXX0zKxyJl9V03NqMk
	BO7TA==
X-ME-Sender: <xms:vpWnaG09pjrcjRvv1n_XQuN6M-uBletMQu1_Dd21mq1cg_Ugek-3zQ>
    <xme:vpWnaOmr_sBi6wNiL0DfapYL8ZW8uKsz_G0xcW_7ixmtfeHr1LjKbC4vcaX10IBli
    BYeroR_6aGHZsrie2g>
X-ME-Received: <xmr:vpWnaN9Zra7jauUSe61g6WfIk8fmD0PfIcb8j4Mgf4vQN3h59h6TNOh7iW997Z6KjqXurQXFIk4mR5_D5kf_DmUUMaY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduiedvvdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhephfevkeffkeffheeffffhuefggffhhedugfetudetud
    etueefveeijeefvdduudegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfsh
    guvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghl
    qdhtvggrmhesfhgsrdgtohhmpdhrtghpthhtohepshhhrghkvggvlhdrsghuthhtsehlih
    hnuhigrdguvghvpdhrtghpthhtohepfihquhesshhushgvrdgtohhmpdhrtghpthhtohep
    fihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehmhhhotghkoheskh
    gvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:vpWnaMKruiPdU6x_UleUEPSEWzdCDBTdOiBhhagNwhADnjcb-lxccA>
    <xmx:vpWnaCjsDdJvZefGmRGi5H_THVIpUQ5X_typei7ANTDfm1at4OddRw>
    <xmx:vpWnaI-e6dN1aX_LIRCXFZHs4l0bubMB5xORYLQEC_lBc600ga4ZQw>
    <xmx:vpWnaHOcLrIl8gHMLNvjzvn4cIilb-Ih3IIjO5IbM8iFVYGkwdIFcQ>
    <xmx:v5WnaNwxx5FGZYMeitHe83t-5KuMs6-IFqArjWql4NPpOHISiQhE50FW>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Aug 2025 17:55:10 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: akpm@linux-foundation.org
Cc: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com,
	shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v4 1/3] mm/filemap: add AS_KERNEL_FILE
Date: Thu, 21 Aug 2025 14:55:35 -0700
Message-ID: <f09c4e2c90351d4cb30a1969f7a863b9238bd291.1755812945.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755812945.git.boris@bur.io>
References: <cover.1755812945.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9AE27C0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mxf83nbbqrnwwkebdkgnifkymyz66axb
X-HE-Tag: 1755813312-906681
X-HE-Meta: U2FsdGVkX18a1uW7tyeUABwsXSZZ2K4lcDkL2GkzkTurt2btiTHbN2zGBkGj3HjR1gO2KlBNXzu86LO8QfqEHcYgw1fF5uuuofachHUsCQwaPgFzAsWT5IMykkI9qh3Esy0W8N/qdCKBGz/UKwafHiy4cmV6QOFWpFgAyAo+nD2wWzBhneepKMajhPQURtTLlTlbdRS2jLydvy0onoq5lI+QMiRbT4fNLSK5kBHIgJTqwe8Kzy/BIor1a8aZ5JuybNEiaSZEJAN7ZMxuaLGH7qsara5H54vHbTdSps7Y8KsV7oUVMgpV87tXGduVNq5uIw8bN1fbME8aS6ol20Iz3W5SE3p/t+JXBct/imed0s1qpm6vs0L6c4MmnBT90Ptglpc49s4JAJRD4rSSgMVmPaFLtKVuxj1dQQJrIPSbObxtPnKGnqVr58NyJFl6XkbX1q5s0ed5B5GFsFZNL1+fdlRIvVeAQWhyelKSwHCTYUdlN1bF1MNVPKL7/zDjmX/kBpYDNupe/acKoHAnzBsXQnmG4InYiPDWhCA0sgluqYKwtoPTzDXuDODTIxCXOAIU5ioCV7vKfxN4J8NyfWn6Mka7m4KzoUC0KzlLZM7X5P/ZAwQShnx4vxNaFctTBoFpFcw9RmfbzGC4x/CbgCLOuiXcTIBLoS0TrzYIISxRW7+PC33hyTv2J8qZKbcK3tX/atn5IVbZQ2ZoQNZwnGlDhagdGQHvR4DJO4rF6xTzPYCJNS9zbh9ZPi6+lvKgbIYoD8aLGwEsKM6NMkHLwIceYrcDEwWZBWwBWUpVe3Kp9iSWfheegr5A5Z921QLOFUFvkxjluTA4bS5nroUkA5ch59dw9klslAMuFKhj040hBqc1mg/dITv1kgrYsD604Ns4GcYdhsAMy1veLvkN+4BW/pmHNgsJ4bm2z/bZoPm0iEP3zlLpmJvly16tYZzzdd2vSPsb2zBZ6wAhxD97crF
 yhE8b5Nm
 R+mIj1E6fLD3qI7xBfI9GG/eZ/A==
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

We have two options for how to manage such file pages:
1. charge them to the root cgroup.
2. don't charge them to any cgroup at all.

2. breaks the invariant that every mapped page has a cgroup. This is
workable, but unnecessarily risky. Therefore, go with 1.

A very similar proposal to use the root cgroup was previously made by
Qu, where he eventually proposed the idea of setting it per
address_space. This makes good sense for the btrfs use case, as the
behavior should apply to all use of the address_space, not select
allocations. I.e., if someone adds another filemap_add_folio() call
using btrfs's btree_inode, we would almost certainly want to account
that to the root cgroup as well.

Link: https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/
Suggested-by: Qu Wenruo <wqu@suse.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/pagemap.h | 2 ++
 mm/filemap.c            | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c9ba69e02e3e..a3e16d74792f 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -211,6 +211,8 @@ enum mapping_flags {
 				   folio contents */
 	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
+	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
+				   account usage to user cgroups */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
diff --git a/mm/filemap.c b/mm/filemap.c
index e4a5a46db89b..05c1384bd611 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -960,8 +960,14 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 {
 	void *shadow = NULL;
 	int ret;
+	struct mem_cgroup *tmp;
+	bool kernel_file = test_bit(AS_KERNEL_FILE, &mapping->flags);
 
+	if (kernel_file)
+		tmp = set_active_memcg(root_mem_cgroup);
 	ret = mem_cgroup_charge(folio, NULL, gfp);
+	if (kernel_file)
+		set_active_memcg(tmp);
 	if (ret)
 		return ret;
 
-- 
2.50.1


