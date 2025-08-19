Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FC9CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 00:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9D78E000D; Mon, 18 Aug 2025 20:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A916B00FB; Mon, 18 Aug 2025 20:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD798E000D; Mon, 18 Aug 2025 20:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4481E6B00FA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:36:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B9141A01D1
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:32 +0000 (UTC)
X-FDA: 83791641024.16.E54B4DB
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf21.hostedemail.com (Postfix) with ESMTP id 27FE31C0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="s 0qb2bI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=eAtlw1AA;
	spf=pass (imf21.hostedemail.com: domain of boris@bur.io designates 103.168.172.145 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755563790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4jbtDWlH4fW3RgHZtpgw2FYUwY1QFj6S1833X5dCgc=;
	b=gZ21UaONQJ2lKCzZ3M1EYs3NBizHJAUYIooKTS/fAvygIGoYZIxPU+f9mHWOkKpg7NoJog
	KEcj4BYGR78lWPN8+MhrNWzotfdxcM21yCEfdyxreTHnneXFibbAR3W6WM6bYjJihhb0md
	o9iL9ItaGr5wroQqUxN+uGDXX/plxoI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="s 0qb2bI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=eAtlw1AA;
	spf=pass (imf21.hostedemail.com: domain of boris@bur.io designates 103.168.172.145 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755563790; a=rsa-sha256;
	cv=none;
	b=xIX6NwZAnBOYnVOhYmU2U5Q5RP2uAxv3f23V3iYfIkVUV0pgTtEXNH7Gq9LOI9YLFDhFdh
	qKTqN1euiT/r16f+tReJkd8AvOjMLKTERBVWWifu/S5H2lEowcsaRVnNvDY8FOvWqnDL5A
	cx9t4xN38XoE2VsLt2Z6Mjw/OBMVgIA=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 8C0D5EC0853;
	Mon, 18 Aug 2025 20:36:29 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 18 Aug 2025 20:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755563789; x=
	1755650189; bh=u4jbtDWlH4fW3RgHZtpgw2FYUwY1QFj6S1833X5dCgc=; b=s
	0qb2bIhJA+VfL4JxcGIFVoMcrlZfSYd+t0NtSAktMy6vA0kg1lhAQ+t14CErYEZN
	UV+bvoEWZjEA0Q5Wn7m8NbI57fap1X7+3IFWyvQUTR3TNv4uWfJ3xn1RG6wBC2WD
	4VapbYL5RxbeX6F4SNyoO+yWHGUPrylCs1YxJDN6j1f1M0kGwH9lsvIrpGKOpUOw
	+l7HZiB/rVxDWT3E0M2pVhjw2RKRbEVUwQJwZEFyHz5qdY66myu3WiH7oODZF+Ds
	7PxT1yHpBM/Cx0A5I76HwIwXk/fexwOq85wm/Q2W5toYBP6JjOYDMYHi/GTlYEWo
	POyFWc1TCrf3uBC6VgBRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755563789; x=1755650189; bh=u
	4jbtDWlH4fW3RgHZtpgw2FYUwY1QFj6S1833X5dCgc=; b=eAtlw1AAcna6a2w7y
	0Vw2NScfDCuCheV0l1m72WiwrXMFWqzLqAco40cz4Xx+sVMQ2jc4FneCdoMFbOzi
	X9NWg/5WDDhz7DHq41ykVM6kqXfV5ZKT0Z5F49z2CUJEttfol72dlpdv/CuDHOI5
	FwsEd4vP2BWYfqJWos1JtzGOusxYsNK9LwG2bs8y1BnpJPihaUaClm4hGJUur8Sl
	H5e8BnFKHbf0G++1Nd95q+CAFwh8M9fEk2VteABaUow8RnEiKwbwe0TJIaJw4LU3
	LrxcezqChGjPz/f2bWv0VmSJpvwKXSm5AnPMvx3IsK8TUnYNsccmcNWpa0VvzdX4
	5MJPg==
X-ME-Sender: <xms:DcejaN7qPpOSkCLo_Dq-y_9dJW26on58-EVvVqnLC9W82hY1D_cpHQ>
    <xme:DcejaAYLAIgTCjIltDtFaOJedbt2_KrCmVqGjH1uyUIm2WSgQsgcjYJTGZwTlwxKE
    mSo1D4XWeiZPGrAJK8>
X-ME-Received: <xmr:DcejaDjncnolvloFZXC6gZcBS9S34KRYCJoYtHzickaSB44YULF_bOrTX7oE4gt8mFMQFfb9p3FFhezRusmKXHIzNjY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheegtdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepueekhfeuleegtdevudeggfethfdvgfehteejuddugf
    ejffekueefudelieeuleevnecuffhomhgrihhnpehshiiisghothdrohhrghenucevlhhu
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
X-ME-Proxy: <xmx:DcejaKfQ4d8rLqZYBEsJpLYGUsBMxtScHd0Z366wZdkbI_bZ27kqew>
    <xmx:DcejaKlf-rLNhJjqlbmhjzn7nyLqqZDzZEn12TuJZvHesXOqOnJylg>
    <xmx:DcejaHyySGEK2eX4qeaQ4Fr-HbJ7PSW_BmlZF_jH1qEEg2oh0PTbzA>
    <xmx:DcejaFwGDTTdP1r1vfm6hFPe4kTE6PlyB9mOP0mPnlkTyx1iMaDHLw>
    <xmx:DcejaJLkwITDUFaiDXM_USMOTo9Dq7Nc8tYvh4MxnTpcG60Nen2wEYWb>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Aug 2025 20:36:28 -0400 (EDT)
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
Subject: [PATCH v3 4/4] memcg: remove warning from folio_lruvec
Date: Mon, 18 Aug 2025 17:36:56 -0700
Message-ID: <0cf22669a203b8671b6774408bfa4864ba3dbf60.1755562487.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755562487.git.boris@bur.io>
References: <cover.1755562487.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ougbceqm7eycxw9prnxqzs4oyccbcb7t
X-Rspam-User: 
X-Rspamd-Queue-Id: 27FE31C0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1755563790-262145
X-HE-Meta: U2FsdGVkX19VoDEDQ91q5RqvuZ7VOSEFQiWtNyYmngDYxB+/hjq2C6rKgKxh9ZD7A9RSDpNdF9F3JP6dhaDxYLvH1J8Yz1WimMW/wAIkKmsOI5P7AwrbZ/3ljzgQbMU147TMJ4J1CZXHHFiUZTnbissQ9K9EsmIgx3oiePHXB7INTRzm4cYOGjqyWrwEIXRdT4DUHFMTsVimfOQNYFxCQtQq+cAlElisc3wAVJKK8sbW+3Z2bUTN3i07/GbPUNyJnSpAwt6bIE0a4G6JdOlxNMGmhpZMWZzagJwe0YwBKFxw+djdlcOzzz6vj9jp4bX866JHQGx+EUd87cxi8T2kuH8Li3a5LRjzl+EAofkJvZFIIMFqKXsguKkJT5tv0itywNJo13XXHs2KhiauUtQPZhyF95+Zo8aKk3ZFmA+S7z0RpOyzLxtDcCAJvYcvbEzt3sAVz8smWChxoyH5M5w/KqG/32sVe0RRRzKwliVSZnHvzJ5VVMq0sYb5h8QhkQ9LN4nKHLmy/Oay/7cQiobv5DWO0bjCsWjaJAg+6YNIaSEmD7m4H2StrEligsvFOBiLLVllrtgOhRwLrE1ZFCmbUDlNVOLoh3pOvLz6EfrUJzQuL/DokNBrsVaGkkMSUVhp5zMYFisbyQBtrqxONAthExk0hBj0TQkiA/BQ84LDVMuiVeRbyWAWzaqdIojv/C+EiOQoRuteHXEdEwuk8oMpNa32U9w7jmcBAI3vC42hQFPC9p5UN3+UQ9h4uYA6nMXfkYgJPMqv27LwmmZrOa07UdSiUL8X30+97rz1YauvKcn76QakHifmzxsdIzexgRIoWZWwpTrSt+uxrZVxf03vLJiTwMWS9ZYMW6+IC6k7Ti04M5nRUhhLYNm9u3UFbHUCy0i/Qg7E+lULgWMLHYCwqba9nTOpLVENAM5wVe1iLffQRG8/UaRMNCt1tmZ0AYoftwnIwtkIrNh4rAkXZf1
 GmwDMpDi
 sBHRYpu8Ht9ykTi1dzqBmkY8RomxbNqSB4XqXsllhuLUk822CT4uWc12ZdQs0IoslLgJ/z/iHbGqD5tH96BO4Z6lgY73115ZzYVv7Q4zkWhrAuXN++nrsUn0fydaJ+gppFrsJeFshhh1VG/YQEpJeVsh9LE+WEW9B7aqdJXnP+VOe4vuqyyvdC6WluBmmYW39l+92Dp6DY2Ke4+1vjlXXgjAY6uuSLCw8dP3jdtqPDx7ty1KpI4kx62tzoYuOEn/wCgcZ1Br3RXnsukCc5Cq/6I1RXDEcZV9xh11nXInaMWGGeSPWnOmQ9BM0Hjnk/5vOjGGPSlB6EatBbLkaBW9rTOd/v40XjWWpuqh5a2NaHrbr6tV7VUy4eckR0ZYkMzqZe1Jg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shakeel Butt <shakeel.butt@linux.dev>

Commit a4055888629bc ("mm/memcg: warning on !memcg after readahead page
charged") added the warning in folio_lruvec (older name was
mem_cgroup_page_lruvec) for !memcg when charging of readahead pages were
added to the kernel. Basically lru pages on a memcg enabled system were
always expected to be charged to a memcg.

However a recent functionality to allow metadata of btrfs, which is in
page cache, to be uncharged is added to the kernel. We can either change
the condition to only check anon pages or file pages which does not have
AS_UNCHARGED in their mapping. Instead of such complicated check, let's
just remove the warning as it is not really helpful anymore.

Closes: https://ci.syzbot.org/series/15fd2538-1138-43c0-b4d6-6d7f53b0be69
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9fa3afc90dd5..fae105a9cb46 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -729,10 +729,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
  */
 static inline struct lruvec *folio_lruvec(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled(), folio);
-	return mem_cgroup_lruvec(memcg, folio_pgdat(folio));
+	return mem_cgroup_lruvec(folio_memcg(folio), folio_pgdat(folio));
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
-- 
2.50.1


