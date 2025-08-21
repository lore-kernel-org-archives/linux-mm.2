Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70993CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52C18E0067; Thu, 21 Aug 2025 17:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03098E0056; Thu, 21 Aug 2025 17:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2228E0067; Thu, 21 Aug 2025 17:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 797F88E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:55:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC0A61DDA7A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:55:18 +0000 (UTC)
X-FDA: 83802121116.29.E1B0B2F
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf26.hostedemail.com (Postfix) with ESMTP id 32436140008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:55:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="k espNPe";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=LXqRumNz;
	spf=pass (imf26.hostedemail.com: domain of boris@bur.io designates 202.12.124.148 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755813317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Y/NEyt7ymKiMS/llOk2P8t/dM0OZDpztKj3DY9zQ/I=;
	b=iJrNoU2N5gi9Zm0elc6QCTUf/6v5z1mAdb5Whh9pM6OQCJyZqBEyGbI12qCVQpgKtCwCzW
	hb+4VW1P+fqtxoQJwhHgItYVTyDdxxaP+91hTwPKQ7zU15jyN6P0btP5IOuZxGGc7naKYA
	F3uOCumI+LexeYulOYvqTe4gFu5Fwhg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755813317; a=rsa-sha256;
	cv=none;
	b=x7XZpg4gQUCXcBh4VGRyyKqB98wSLb+JCHv4OdTq8heMQOJeaPsvRgEeU0jcxsxoyjBN2j
	PQkiF4SQ71VOe6rBId2iAOgCPnsa6nOPKDMuGYdujLywA/KEMqKMBJdibcKzZLp34tevjF
	8c7ndxTfV+irD1DSLnXquKUUBegb0Nc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="k espNPe";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=LXqRumNz;
	spf=pass (imf26.hostedemail.com: domain of boris@bur.io designates 202.12.124.148 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 2C6B41D001B1;
	Thu, 21 Aug 2025 17:55:16 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 21 Aug 2025 17:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755813316; x=
	1755899716; bh=+Y/NEyt7ymKiMS/llOk2P8t/dM0OZDpztKj3DY9zQ/I=; b=k
	espNPe33CZp4MkiZnmymRTInr4O6gVX21JVIX1LVEVkUhxfFhoYJvp+U8leobhuy
	R6E09ZhM1ZjyTOusns3MH1OSHwyP8VTPim1WYX8v1axHRpyI08XFB/tGGF+lOsQv
	Sft5VVU66aTU6yln9IFyVYbcqp8RREEnPRLYY/w6qohIW3U43udueydOIl3j76l8
	C85cKMmcl4nG2v0uq57h5E15aVJxjx25nkHpI1oT9nAPeUJI2vp5x2NAsCuGsn10
	jnIlkix+ctQxFV4rritS08Qn6vWV38F2qYorWGR0QJOcWfdGuY7y9ImkZqgprSYD
	vbaFVQUIE+BO86z3Isaqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755813316; x=1755899716; bh=+
	Y/NEyt7ymKiMS/llOk2P8t/dM0OZDpztKj3DY9zQ/I=; b=LXqRumNzkuckFJRPU
	qzJzpfdM3cJvj/6k1ZvGr8VujS1ssmvl0/lqX3wXPAKFpwgq+uux87v9gAQC112C
	13o6qTbGWrOH/CHenhofd5rtvJ9m+PmAEtX2rVOGMxNlW9R9Lin7tGh9jdlxLCGy
	5zeH00caQdwQQbCr0lZWZxnt5fG2+ub5upJHT655RNjEVc1SZLZMdAIr6Foj5jGq
	RSm7j1PaqzrbK4uTLmPeRs+lsSo7Tt7lR+RyaWuStO7iQcaqpDbPtRYNDsh6b7xv
	9ceiGJbBBy0YLcWUsG3UINEr5m0JjHpnwHYy26wNnfnOZxDTSYCPZaPz8XvCk8XM
	Ghbqw==
X-ME-Sender: <xms:w5WnaIOrFOU2YEFkx1D2A_4I5uHbHGUeZ4TGoQFg-9Iq6l3AMe3i_g>
    <xme:w5WnaEdPMxnFe_OpZ9pIZAu-lF6rjj2KH7b_rGulYkNuaBKDnr4AaWa-BL32X5Okm
    V1uZG84YwIOsmuov_k>
X-ME-Received: <xmr:w5WnaOVchaYxyB6SOx34RF8E9yaTODM3UwCHPwnXzdv9_5zch_vLxxoBloJNfgHJGRszNFcqOtqhppw-r2e9LZrgt-I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduiedvvdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepgeduteffveeileetueejheevveeugfdttddvgfeije
    fhjeetjeduffehkeelkeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeduvddpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomhdprhgtphhtthho
    pehshhgrkhgvvghlrdgsuhhttheslhhinhhugidruggvvhdprhgtphhtthhopeifqhhuse
    hsuhhsvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepmhhhohgtkhhosehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:w5WnaFBZ87pqek2e3ZxXTRUAJDqKID1CS-K8Bc56OJ0YJm-xhOq37w>
    <xmx:w5WnaJ5lBUTYVO2YthjeG7VrYUHlmRUog3LkfSQt6SjS98znEkcakw>
    <xmx:w5WnaM1ZMP7_c16eUIAJgJFNMu_L0d2prMs_BP7QiBZniUl-SLaIkA>
    <xmx:w5WnaNkJrp9i4GxudzhYN7rhxrbaAVwFAOMHzpG3GMV2t7RkxO9tVg>
    <xmx:xJWnaPJuxooOsIZzeuAG1Ob2seij3jbCgPxyx0XS6M0Hdjso4YcSM1Px>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Aug 2025 17:55:15 -0400 (EDT)
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
Subject: [PATCH v4 3/3] btrfs: set AS_KERNEL_FILE on the btree_inode
Date: Thu, 21 Aug 2025 14:55:37 -0700
Message-ID: <2ee99832619a3fdfe80bf4dc9760278662d2d746.1755812945.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755812945.git.boris@bur.io>
References: <cover.1755812945.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 32436140008
X-Stat-Signature: 9tq58gertt3u56yx4jzdhmpw7unhq5dg
X-Rspam-User: 
X-HE-Tag: 1755813317-70951
X-HE-Meta: U2FsdGVkX1+ivQ9Bm6ALL1A47CGHoHXX7NNXrrp1WgVOhN7KmmRaDwgfR/JGL8C/WHBvVLXJs55pAekqyMQOUR6egxOlWEghMuNNCZpSFB1u+GTddhx5tLKyCYTMzJ+CgEK5aS9QvieTOJ+unSjNyAxb8+gN9PZfuqTZowJtZwQWWZM/5qr4Qb8Aijm/CpIJtt8daf/745+VkUk0+88nrVXg872QB0na3jJEZC0qZO3BtJ0L2G7zo2kxhnrZeFuBnIQN+CquxDcaj7A0HBMeP39XXweTMC4HETYBIOLc6X3RLxDWJbivyopN6F3WFnC3D14Wynra8nobDJzMdhiN+qUNp5/Wdz6Q7GCOi/AoCJumkYjdlAu8Z2YMx7q8F4EiGXOkNgodtlsF+Pq0FotFiLjQH6AXPvHlo9odhPbEDCxx3anr+0i1zqnfGbo0U5CxZMWnvy5QcwD0w7Axx5J5r7UnkIn/yWB1oLfjnoty6gqlMvbqGbZpTn0/37CE/TUitqM44ysfwczrJWG8oHPkKSvApdo0WXAjoL7BLzY3FUU1MCYCeaSD60ueBzUPeIUN69Zz+rjGPEdtPr7deRQnWNR0I60ieASEIQursbw5gpiYISex/7+ylWwORfjBJVzxuttK8vdeBZb4NkpDoXK5wVSp3FAhrapJu1MlEImpHktTyIj4/ShmJUQhDZx4wu7suWKkk+Z0yaZ37IPNXgf2p2oHtj9l+1835yrtOVSmC0+ysPaStwMGw+NXGjdXpl6TW3J5kvzfnhmHGxj/8EILTEEYGF3fdDXvJEProb4KwsXvC9jXSgBHZ/54sh4xNPJUxTUiIQeA5BnjZ3xccR6nH9v1NvnpU+I5yBPF0fqk3EjJzeV3NB3eD9iSwedDFl0lbjhUe0kIvmfr2dg5ntB89o51OU/va/J3Jj00rNrN3uAljV2vaPmsIcESvFMZAEmxQDxJ3gj79lTnZu5XDFH
 qGBXbBnv
 wg0J1jR15kroxtEPLXjx10dEoFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

extent_buffers are global and shared so their pages should not belong to
any particular cgroup (currently whichever cgroups happens to allocate
the extent_buffer).

Btrfs tree operations should not arbitrarily block on cgroup reclaim or
have the shared extent_buffer pages on a cgroup's reclaim lists.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 70fc4e7cc5a0..7fab5057cf8e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1930,6 +1930,7 @@ static int btrfs_init_btree_inode(struct super_block *sb)
 	BTRFS_I(inode)->root = btrfs_grab_root(fs_info->tree_root);
 	set_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags);
 	__insert_inode_hash(inode, hash);
+	set_bit(AS_KERNEL_FILE, &inode->i_mapping->flags);
 	fs_info->btree_inode = inode;
 
 	return 0;
-- 
2.50.1


