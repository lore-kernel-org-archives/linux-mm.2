Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C291606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FOUp/N77
Received: by kanga.kvack.org (Postfix)
	id 61BAF6B05B9; Tue, 10 Nov 2026 06:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F38A6B05BA; Tue, 10 Nov 2026 06:24:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509276B05BB; Tue, 10 Nov 2026 06:24:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F37F6B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:24:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 288C3C0294
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:56 +0000 (UTC)
X-FDA: 85418977392.09.3E087B3
Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4345C1C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FOUp/N77";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309894;
	b=fvKz+GPqfvQD3qdmkit5Q86emOy080zb/9FZSf5XlErhvfwdH/V3pSsjVIQDgcmIckBVG5
	GBCBCGGmIz9xP5KCOqOWsrUbhw2hV98BKOVV9zyTid835c1zLGLNGJcazo/FBSX0U4k3G9
	Tv9+FAKNp84rSbw/20JTewt1vd9/P6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ndl0Xjf9nTZN6dKbs+SZ1IK92guKL0Ouhq0SwgbwTp8=;
	b=1WOR25NiiAVcqULSHMsYlhB8Aamfb/qoBzhqxtYaqKIbPXtp/H/kM58t5jQuu/p6wPKlhn
	SYaRaxkYixrE1XYKYQ1nVlCGtSb/U0JMdBrF74/DaKvzNL5IOrlw5g+q6SXAforb5OTSJ+
	AFwcJbUFNsfyYSlEHT21Ctn+VPmZtf0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FOUp/N77";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NOOAGkQRj9IyYCtkbJXvFPbThNHcQSekySmu8iG/sgo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309893; v=1; x=1794914693;
 b=FOUp/N775T8HB1hrcplQ0CeKr3bk3RhBac/S4RA5QGQd9Luyh8bToPK4/wxTk4aE/pchYVWj
 itkGnzCv5Ca1AzYXCk26qg+xpyLxiTu8P4VEhtgINfoSQB30mTMvRLGEhL3UIekXHKoje+KA9mN
 nb4lw/5o/9she7ISxhSPtqMI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a353589fd710b990;
	Tue, 10 Nov 2026 11:24:52 +0000
X-Mizu-Trace-ID: a353589fd710b990
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 4/9] mm/vmalloc: BUG_ON() on an unaligned range in vmap_pages_range_noflush_walk()
Date: Tue, 10 Nov 2026 19:25:41 +0800
Message-Id: <20261110112546.261415-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4345C1C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: 9yjo5e888h5tyuj89a6p8i1op45xtbab
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794309894-584782
X-HE-Meta: U2FsdGVkX19fqkiBl+NybQVclcuaABMv6yWiHyYBoHcMjWPn3nLktPdABY4wD+cP1zBkaDAtQ71ykSS81Yggy0XuwA0/5S9fV1A8QbHMociJVGeVpe1hkW2dzMXU521ARDVkN+a3U+J2vUpvj+9vr/Skcpc+83ha3uTSqQGxsbGqiwf/aG1Azp0fhKyln55taLIg3k0MJpeazHPQjmflPpY2g3XkZZMzKYjX4VnZy9rUzTp29BXvao/UZwND7aU32d5V1wiZvtgmRTico7b71sVNszvzR82YCTseBMoJ91Pr1VUybH3Oh4Exr3SSTqhUn8WB2s0igwIzYs9LJ0SxeZtznF5XuzxBs7W5jXd0SXYehDLifTve9Rp3lj6tXDHB2X8AGGG9zdYRk1OTvw8GO75IpOXKd89m4zcH/idMYBrLMO3OwNtFujIMkKZUBrx6Y6DEWGEeMAxxqn0lBcGg2cGL3Y9CtxZ1X/wKhJMWtLQYtDOvxMXC1/GDCvjDToUpOYtcf7pT4w2SxRa2hqAt32DquQjNkZh8CTUkkCg8Fi01DIC29n95dzfNwZFQnmLa2RW0gPpgt6FWHnt7G8MTQVrZhX9szbK6nH5GcrL0ft0/tCzGq9FinsLr5bG28pMJlXJfCZEVFjHCA9yX8AWfQBJR7SJy0KfXvvnKTYh45NnGqaldQi4Be6GinAs0orwm5hpef4O88U3iISgsiBWA44xgOKTwarTdre5CZOuL1ObdsJ77vfIwORk05/iIiB4GsMalzxhaDo1d8GDBbxD8fied5KzZbJkCMhvAfMn8LXwLUhdmonjANPboCGBOiHt9N//UTy972nC27b7lTPv8aUTitImkUkRtaCq6a2AKs6dxyKG5tk9etx5pV41uj2ClbT8X00PY2h8y85OzsKYbrBJI6oYB2unkqBxrJ1Ua6s5NtEalwl0s91JzW3/jBtTaFMSBNbNHjlZIVTo0Lma
 YsEvZagm
 YX9XeWtCByaa8kNEaMrMELX4OcxN4MeFRY1UTbzTMRjS8iJJ53ZUnfzcMScw/EFLg+zbtlGiSsBxQg5vv33A3+Yc/lsFm2GqkKwDmP2c4Hc5dP+b1kX4j/OVuypo8XXhqQ6rRoMULhnVN2mEvg6sPVzr7Ctq8mXQEqpqYAW+SIHXoSo4JQL2EstJuLp+rLB0UivhvMoWf9CoyRu8RisxtNJaSM9fgWYuJBIfk++h2dtC5Js2y1jVCXJPXDgdTBpmC6MOYIXdMUSc2mUzbf7xMpCBKeNgUCodneNFFlNqnIPb/RXot7hfCXfXurFbN/zuDHwFyQD89TXx8SH3v6eSc96jDvsLIceuitKNQ7GpzqRB3wpBvNSOYeQEUw/KeW0jgdhuQkzkRtbxhZIjI68rMoAU4GdV9TY9d5E1emNmAZDe/+ZUn6jElyN8xcY7ZeU4EH9ae89QG+inrF8cThvGDJzc+3ohInhuOm6YziHGE0WbX39aQa/KwjEhdsTv4LuMANF5t7uK3aQZlw4s0hkCBG3OpYcaqj4MJP6NnAKuUvh97tE8PHYQ0TC/jlkpSGNo/DjLfKE5DAz2Npm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The pte loop of vmap_pages_pte_range() maps whole pages and stops
only when addr lands exactly on end.  An unaligned end lets addr
jump over it and the loop keeps mapping into whatever follows the
range.  An unaligned start maps the page below the range with its
first pte.  That corruption is impossible to debug afterwards, so
bug out on addr and end at the entry of
vmap_pages_range_noflush_walk().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 27f2674a5556..86fbb1d2b27a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -698,6 +698,8 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
+	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
+
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-- 
2.25.1


