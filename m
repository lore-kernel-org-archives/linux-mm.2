Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00972CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691EC6B0095; Sat, 23 May 2026 13:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6681A6B0096; Sat, 23 May 2026 13:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F0B6B0098; Sat, 23 May 2026 13:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45A056B0095
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:54:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEBC8161B42
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:54:49 +0000 (UTC)
X-FDA: 84799435098.22.D030694
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 24266160006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:54:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=entiYHeQ;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNqONibNib/HURDSoCRdl8F/ugaDRVHwkYT5A3d+6K0=;
	b=Yl7JMMg7zWOSR+dCfvkaMOVG9vkvaoSOQ1794Mmlv3xjvESXK02RTBZ9Kao357b4xJ0UB1
	iIriAOE7xHxplu8JQnSI4UkqjAUPzo4ojsd0ILxLmQZZUnE2CFo/NxzKZJXg02/UisBLyk
	lgLar6ODUHxfI5d+WI0hS0Oz3jpOkE0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=entiYHeQ;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558888; a=rsa-sha256;
	cv=none;
	b=FeAiN/wKq1O2GmDiuuffMlJoAJOcDoOHFXd/V6eAv2b6EYKbJA2k78a/Asj0QoHHq24vUw
	+wQhz8md3NPMrY/y5aXrNJCikZplRuoPd5eMqWup+p5ioOy0c7Qg//vsAf6PlASqgyk634
	HD4oFE+gpUxXtfBMHNtOXRCYDTZYKK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BBD340AE4;
	Sat, 23 May 2026 17:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644EE1F00A3A;
	Sat, 23 May 2026 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558887;
	bh=xNqONibNib/HURDSoCRdl8F/ugaDRVHwkYT5A3d+6K0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=entiYHeQKdJpCq2RAkO9V3DfpsOkdAweTN9otxUQ+O8vgrrn4uoBnmky9dnsr9Fbx
	 m4wuzqZzR5kX+E9pPoVCmlFVpTAW11ZEZACAYWQV4RjU+r1ZFA22q8b2P5ph0C7YXK
	 1DXqT1uS77S65UKLbwRFPf6L/4TWqrNbTww9gtbYR5ZfBcfDx1tVRapQXmJMHH+5Qk
	 n8XIwq073N7B/vc1ZNlgL3xUnvihMimNGqIBpzEqFqEavTPULAoZuVZjF7WDOvBjeD
	 PUHEN8u42mw/tjliBBXnMPRf2hgPurks8kLmsMdUGiyYXv57Cm7/XiWGt/T2OaWkqZ
	 RFoyBRXH51pfw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:13 +0300
Subject: [PATCH 01/17] quota: allocate dquot_hash with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-1-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 24266160006
X-Rspam-User: 
X-Stat-Signature: 53zsfb1zmcjpj475h1nt8zr9azsy3yuq
X-HE-Tag: 1779558888-422942
X-HE-Meta: U2FsdGVkX1+UDMcS/76scsPTgVDFxw2b18LG6cyIMv2krk3dgCt2DFT8e9GOTw1zEARxDmPAtp5opuAVVB8wkMIfcdItcnfZG/r52oUxT2uqa1MFVoXE7bidOQbMdCdzbqSralgo2p6HfFFBbYrvHWelOHSfS8YhhdLpV+l1Co2rDA1es496mVFu//YMqVovGuRj2Nb5U2qAXZohrnThyAqo6I06UKN3tlKxUrea6smGK+Ptqq8A1h1rjbSThT8Ik0YKgo3L8CXMPOs0KHigzfrdHOTLqmMuQR2VL94qgxoOHz2FyQCZFuTxpsj+R5Kd60K7UV+ZBTO0kh3UqVEbFuBSTEWPBdDzfoP529ajrSw5Qs7SBvSRmepJMTq9bbdNziHeIoKZuJ0uoPUupPq3NmDnWhDFy2AiCwSfbZp7sg9mOZdwRpasR5qt0kPok5vg+/ukaktV1mjCruMb3mqtgrtTipfg8hsr94ARj28it0vyqKKKcyEve30IvLJlo1qAeUBYw5TJxrfSzZmLupE/JU7IbfTMnlk6iqB8AYS45G0DG47xT12+tKTngH1BwK83C1johibMqjhZ1oCb96CNNiyPaq/6icvmVgOupLMY9n/KOC9WPtxd8G/XFL1ja1+zvH79a3vofRNekKQLOJ6YKDcE6a26hoGL+0k5S1tie5CPx/T8T6+dx2E2QC0FXwsDFTniyq4pFP1CbMc/Cc3R6B9iV6eF2N5dd8tAKCfBGFZ0lNurmjVPAbVn5fYJh4xncFnNYVW2YoyPrur5inyRVBYW8iEg8NnnzwraAhu+LmF6BL+tcttFnKANCzNaoekqf+g4J7RNrbQSiH+og8wZUsnsCIfQZDNahGGp0MRDQiIkJt4kwvCqwsYhHF1bnshtB0Q3cpHLftnjTBb4wsonW+HnYmS5sgHtoE8w/jXmhk0sgrHTpePFoKm5UGi6WRe1VoxlwgBRqSZbUC4nwZl
 ke8jC/G1
 2+bl7nmoDXjrGBhUqgACOzkWkXfxkQcFJKXianHptOwRrKi3FAE/ngd89a64kje+iSNJSUMzmNaCpqstjFb/g+66phgGhTxXtUjk0mG4ZArwvvdBETCr7eZY6/Tvsbcno/KNTrmnVF33MU4ezicHgjXoEnS5pMwq/x7rhozOV22v85qJmCF9jl3AZo8P5FQ+xo6QXJy3QutTXFOBA9MRKa7XQoaBxhLtTvfXCb/VdgKXgpRw38s8J8Y4xx5NT2+QmSjMXwNMNnMQu6GK7tS+fo+K8T4AoafahKdBXKdrqeQJa0rKCAg6FQlNUMXA8mAWfV3vM90jPutaePF7odwpUsiNmCFnHMm/235EW6W79nURnFik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dquot_init() allocates a single page for dquot_hash with
__get_free_pages().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_pages() with kmalloc() and get rid of the order
variable that remained 0 for more than 20 years.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/quota/dquot.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 64cf42721496..9850de3955d3 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -3022,7 +3022,7 @@ static const struct ctl_table fs_dqstats_table[] = {
 static int __init dquot_init(void)
 {
 	int i, ret;
-	unsigned long nr_hash, order;
+	unsigned long nr_hash;
 	struct shrinker *dqcache_shrinker;
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
@@ -3035,8 +3035,7 @@ static int __init dquot_init(void)
 				SLAB_PANIC),
 			NULL);
 
-	order = 0;
-	dquot_hash = (struct hlist_head *)__get_free_pages(GFP_KERNEL, order);
+	dquot_hash = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!dquot_hash)
 		panic("Cannot create dquot hash table");
 
@@ -3046,7 +3045,7 @@ static int __init dquot_init(void)
 		panic("Cannot create dquot stat counters");
 
 	/* Find power-of-two hlist_heads which can fit into allocation */
-	nr_hash = (1UL << order) * PAGE_SIZE / sizeof(struct hlist_head);
+	nr_hash = PAGE_SIZE / sizeof(struct hlist_head);
 	dq_hash_bits = ilog2(nr_hash);
 
 	nr_hash = 1UL << dq_hash_bits;
@@ -3054,8 +3053,8 @@ static int __init dquot_init(void)
 	for (i = 0; i < nr_hash; i++)
 		INIT_HLIST_HEAD(dquot_hash + i);
 
-	pr_info("VFS: Dquot-cache hash table entries: %ld (order %ld,"
-		" %ld bytes)\n", nr_hash, order, (PAGE_SIZE << order));
+	pr_info("VFS: Dquot-cache hash table entries: %ld (%ld bytes)\n",
+		nr_hash, PAGE_SIZE);
 
 	dqcache_shrinker = shrinker_alloc(0, "dquota-cache");
 	if (!dqcache_shrinker)

-- 
2.53.0


