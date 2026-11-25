Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFB4606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PuifylfB
Received: by kanga.kvack.org (Postfix)
	id 421E96B0AE1; Wed, 25 Nov 2026 16:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8FA6B0AE3; Wed, 25 Nov 2026 16:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8AD6B0AE4; Wed, 25 Nov 2026 16:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DCB26B0AE1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:39:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A9794012B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:49 +0000 (UTC)
X-FDA: 85474958898.27.8438E95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F0BC81A000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PuifylfB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642788;
	b=4iS8oZOdgdydLeNobQL6K+wsd2Hyf2JTgdSKOuM2MZQTb/iJ3NuthXmKvdd4M/JlCaWHJC
	8HmJkXI1bQuroy7B/OLNNVch08H32dW9nOEgMHqUNTtVwgEfAXVOVh1IPXMfMnwxUgsCWn
	syYDYpKdv0jrQt9JFPA6/CDGPOCC7vo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmbHvxSdAW/q1vOhxvKGf/qq9lAABR8oLeslWOTBY9M=;
	b=t5qmIqsLOdzJBsIwmJu+9KmpcN093UeooL3GP8sCtozSjJkq9TWqFeN740YWhYDLFYqmGg
	8Zu2voiUG6BDyk8Md4un2Y/QTzwQyZdLELUVntW/7Azgj0hesqe+3F50oFShEyHL0KXECR
	Vphhoo1Ic9XstysgTVGnb/R/h9rSRQw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PuifylfB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92466627C5;
	Wed, 25 Nov 2026 21:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F741F000C4;
	Wed, 25 Nov 2026 21:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642787;
	bh=EmbHvxSdAW/q1vOhxvKGf/qq9lAABR8oLeslWOTBY9M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PuifylfBLGxCFHUkMhv/Mi8wFziI0lMC4HyaLotkpoyRMiK/TrqZX1AG36tnHuzoq
	 1WDRGhx+pHP7Nh965qPGtyLktzTqHZnDX+4Gh6hbSSD1omJfsf6XgD4SsJGobQnmI3
	 1feZaKZDJZvZVS7LexZ5PqMQicYfd5h8t+kiTsAk+fqrXTEZwdyxXYwnoq9TKkYv9Y
	 6UoVFGwIcQjP0rlrQartx7T9JCZdrZOPwM1GlbC3TJPbh16Dk3C0rtWzKA0VySGrC0
	 ld/K3k6FWZZbjgdKZNNrbnwCNGJ2AOltLaYpYBFbkIbdiXNq+qiPT3Hv4zKdppHG6x
	 vYPnf/H0PmEVA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:13 +0000
Subject: [PATCH slab/for-next v2 12/14] hostfs: specify SLAB_MAY_ACCOUNT
 for inode cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-12-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>, linux-um@lists.infradead.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0BC81A000D
X-Rspam-User:
X-Stat-Signature: 3wpkkwgn4aetz5ngpopmdc3sz5sxsjs5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795642787-60562
X-HE-Meta: U2FsdGVkX1+LoS+JEV1TzEhln8VMr1ospKxuXMX7jctbvYM9wyw/tIf2Yvs+17/cv8JaTxakLQfav9aDf3UeJLH9U3YNUi+isfkNyC9znDh8KDycovuOPO770g/nhIdHrzI85uY0cAlc8LSlUa7psHEDSxqH+tqBE4BPtUKsboK05/qfbc2EwdXaQh0MTUULOS8RXiiNfB9XsNx3sZu168emuYPnqBoOARDOl2wZdHfhSM/kaZlaAE1N1UUoSCppClwoD2kCV4NocpL8ef+FjkyI+MON/ejP4d3WUBol6/1HELnLIITxjVdf2wGyGqblsV/eF/2z2jsJyQPPu6A1SkYI8pqoHuME1NBywjgZutWIA4X0n2UgpkVrRLuT4Chs011z2U1Tb3VhlW6J7G6qioi02k4z3LZHiW8ZhxFt/OvyRTZSBTJiMgrmPEeWT3b4Rfqbv3IA3YMQ9kB3gNnqPwmmqdUVMMN1hrRsduj8Vc+ui3Sp0GDpgx74cWAZ4NRk4/Wz7sU2pKHkwyzFvExYiaHMwS3rh7dOEn81xTl264ELg8t8PeBiVJAKylnB9wd1c3jrH+Q38OAlOFW7omiXtxfLe4Kw3LfdBD30v4X6jm5vMFvZ4aYMvfJWqituGAimPG0ncDp42nq5WbvJ5NIKdiTWchiSACIzxJQNg3lcjO4Llls7pEBU0//yL7+ofQt2YE76GZVKa8YEnbeuc4cbz9qyz21EImjwphdW9pPI6HXOBUT5luWF64A28yurN1ImBqm5yWGAyt1b0AjhJJ0QlJPcUSBDEDC6GuNP1qN0sMAOVNf6NCixHFj0bjIRVih14M9LES6jHTWA1+wjSgqtHtQ92iDxwYSd2xyxktTMKbKAQLQRNCDVEspHklZvYGEiG5MDxCUdariqy0ADznVEU+dWF6n7zAzuhKsDW9eEk5VlUSGigVzcCz+j2yQU7FRIiCMENEbK8ycHiAT2BG/
 0QZuqF3k
 WoSp6GHYhkiK7fEZRAQdftNvLhAbHondb8VRyhAqnyZSqzd5ngVH8VoPo3fFYxZBLNFXXI+taA5XCvSAviwaSnWXC8gS2tw2OBYUdYf1HvpHkgtoPdjaMUB/2H26saKmQ5adxX1gyG1dkByJZGKjoDGGvpXRYMPb+E6z7IrFlkh//0uvPKfDkfwLrQvSAuO0Wpqen08rlMmURDAALE2Ex4Ik5BsLZ8f6EI+lw+qsCsdcsAYoMkcqkwyPmij77BsJfCw/qX7AcNUdbJZHFgQVTuR6S7jNIllbyzFNJMEYfQdQjwM5tpd2nYF2Ae0CJP4WWx+3ne9JwDjToc+8biZnS5OIujwofWyNXEjTfWqi2KaICD5KunBPBNqEAtthmLu0Qwuyc0sU+lDda8Ph2PoCgJF8JWd6/83DQOeToPycIf351kefn1h4GYXsTYfeeE+g7O40rszbVvjZvFFUa8ltiro+CSxFJJ3yHTfJT+x0tggS0mzKQan72vKmU530iqB6WgbGMW4Bt0smgPgkJOb3E4DYSQkm+eOMC1QW5KD06VaOFRO0RrnEsIQtchJeQbNATkrehKLietiKSGcwirKkneZem9Fyu8IGY0P7Rr0cIVtqFsXH3pCuefmlMZQINKVWaytPUkVkucSRGQq4f5qbFEqr3AM7s3YGCzuWFQkrzQ5F6JmFbkSh02p1DIkhF+A61yPre
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hostfs inodes are allocated with GFP_KERNEL_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: lookup -> hostfs_iget() -> hostfs_alloc_inode()
  -> alloc_inode_sb(sb, hostfs_inode_cache, GFP_KERNEL_ACCOUNT)

Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 fs/hostfs/hostfs_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 613146e76dec..8d748ff838f3 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -1078,7 +1078,7 @@ MODULE_ALIAS_FS("hostfs");
 
 static int __init init_hostfs(void)
 {
-	hostfs_inode_cache = KMEM_CACHE(hostfs_inode_info, 0);
+	hostfs_inode_cache = KMEM_CACHE(hostfs_inode_info, SLAB_MAY_ACCOUNT);
 	if (!hostfs_inode_cache)
 		return -ENOMEM;
 	return register_filesystem(&hostfs_type);

-- 
2.54.0


