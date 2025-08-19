Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84ACCA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 00:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6246B00F8; Mon, 18 Aug 2025 20:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696E46B00F9; Mon, 18 Aug 2025 20:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EC66B00FA; Mon, 18 Aug 2025 20:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 477D86B00F8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:36:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D28D41A0153
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:26 +0000 (UTC)
X-FDA: 83791640772.19.DD43C73
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf16.hostedemail.com (Postfix) with ESMTP id E360C180004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:36:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="G XpGAPq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=MxemWkr0;
	spf=pass (imf16.hostedemail.com: domain of boris@bur.io designates 103.168.172.152 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755563785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWSqEyIvlgjxYOSQ3qRcRu9FlxJpbiB8lkFmvuQAWa4=;
	b=qD4WvLUg7l/g7sJH4TEuck7jzIgMB350Y+aaa+YEImo6muoIXMFu0pPteSAX1/aNdk6IFc
	5zjC23ePJwFIbE80T9iDBhi9aLZVvp0KyQXWT/cTk5NN6KJctiS/hKPGz1IQJMgfYWDTyZ
	FsDL589jK57evYaI9Szi1VBwrGVIQVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755563785; a=rsa-sha256;
	cv=none;
	b=IFTtMeQT1O4UIUnY0XFJxwQc9W0ecQcBcHXosu8SX4+BFcFd+jeFpfoOt8tV2WiCs8Hw7d
	asliTTcXrKwzt5Z7/DBzTzQlmmIfJaI/RKB8pI63zaipWyct8aoFGlAzmAjLR3ejC/27uB
	doZUtif+KYL87PsPTygn/CQoWbGNFqM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="G XpGAPq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=MxemWkr0;
	spf=pass (imf16.hostedemail.com: domain of boris@bur.io designates 103.168.172.152 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3A7D91400724;
	Mon, 18 Aug 2025 20:36:24 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 18 Aug 2025 20:36:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755563784; x=
	1755650184; bh=OWSqEyIvlgjxYOSQ3qRcRu9FlxJpbiB8lkFmvuQAWa4=; b=G
	XpGAPq0D4ExUO0cV3qi7cWH83b02zq5iwSfVkXmh8akVhBtM2O02WYsWV6+x+Cp7
	5zVeSqR3MYwh+lub18+l1nktquudjSI3PFhMsuOAb8gkiCdQy9r5Sa+QBDZI5bUN
	tfPXZmHdlia77mx3UW440osaCKufflUxm+akPFuVrX7RDB7LxODLp2g+Q3fFGdSy
	BiGLtblwpToNrjAtnAwKe15U+CL9r1G3/hQE/ZcPcHvzoffNIZP1oE+jlxxEodxJ
	orT3KOlMq7GT9/Zs9tTiATdC9b0w3AfHCCNQ9MJyoyz5s2cjNN2t1ncHzG4LI3D6
	djxgsN1NzpFd2VcgO48nA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755563784; x=1755650184; bh=O
	WSqEyIvlgjxYOSQ3qRcRu9FlxJpbiB8lkFmvuQAWa4=; b=MxemWkr0UHIaqptZQ
	UfVglu08uM98N8zzw3qizMEwMC31SLvlWg66s5VtABcFIJ3m6FQj5/UIjD//7KIp
	TnQLGI0f7LDG5v4eTnnsynVtaibJ/C3wc6snvUd2+M9VZBIQ7h6RRMIXG3JRjEi0
	WKuVd6PhezsFAx7qZmZLfJfxI0f7CNzm71QaofgWGvS9xDS2B1NEhrF63GncI9i9
	qQ5C0o5qzoHahz/MVZlcGV7FLtTIg3cEz5pmVlWUb3Hx0yI5tbVldEgY7+tdEvxF
	Rg9RDZauUEsG4RDMCxbLJvMIdBxG6vm/77dR1hRmG6p678yR/dEPsg2tZ03RAnFo
	DJqfA==
X-ME-Sender: <xms:B8ejaJ0xtSjf3z0AK94Mu5JPVY7776rceqZrHp2DsFFQHB6Pi2Mwtw>
    <xme:B8ejaFnE_0iIP4FOUXi57sq2ytdbyp5QpVFwdLk-Or4s8UgDHjO6lZwN46BlX6C1m
    F52ZbphtTz4vm4-Lks>
X-ME-Received: <xmr:B8ejaI9hWTqYtVXbzfeef41O0ABDiG0qGVnDgGMTbLMJCbEjDrUex29qAYfznA4etHaTpKTduFKCPTimRwY3ePctFOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduheegtdejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:B8ejaLIRIuF1sPg3MJDFWBC3GpyqXlc_3Dv4pSuK73mHxnR3Bi2oWg>
    <xmx:CMejaFjz6XWIN-PfpTjsuGYmMOSXOAkzwBG5QS0XaUWsZMFPSEkw9g>
    <xmx:CMejaP_NTYeT8OLFEmJuAq4Q7wIK_UKNrdfAEuAoy2oI9fATd6H7cQ>
    <xmx:CMejaCNvtfHNGHXoFyEZY97ehv53SEbSCpi9OATgh2e0cA5hXAgICg>
    <xmx:CMejaAxew4AYN4mVTSwJ8vJAzMn21ZIZKoys7zR3cwL8D6Kxg4KCX7ef>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Aug 2025 20:36:23 -0400 (EDT)
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
Subject: [PATCH v3 1/4] mm/filemap: add AS_UNCHARGED
Date: Mon, 18 Aug 2025 17:36:53 -0700
Message-ID: <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755562487.git.boris@bur.io>
References: <cover.1755562487.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E360C180004
X-Stat-Signature: o58n6nri5m8poukshn47n6m9opaw3e11
X-HE-Tag: 1755563784-827018
X-HE-Meta: U2FsdGVkX18kdyUP6ryw35Xkekwh+eRlG+iWuKmAYlQvvj9l+8E6NeqGbG69ftw1KXVyFPFERo3y5dfXXW1gYMlFrBHqK6UVoN/GZUt4M3viIYoaQRyCnTQm+EEMfWZmhSK385loDfTY0H4ORGj/Lsoy0Qzxy/eu/TITjHBIIm9MXnlrt460eeJ1ZTxnoe7LWsNeICHoX7qUwWfQGiLLeH0qjJfU4ESya90jvkUuvvmVdkxvCR6gLYPE8sUJ7JjZdQmMJe7KdeaA9rYxTs0/R4kIGhfR08A1xITZ9p7Jf9IPoeT0bG16tfupEbUI+AIOKTq3eJW1D/CKNyjLauKKOW5mm8fQPPiXt4zZutLFmEFVM6mTDO2eZoaN/FDRtE1VVWBaQnwfaPxjb2IN/vhhv66ouO3kqmYTWR0k7MLT/Nu9w0pM8ep+TRC56ZhRdWgioBsvEE5cG4uMwA7qYfAMJyDtTMf2691MREn2/m9sVbJ/mqz5wsjAlTA2kEdzRpXjYyapocY3R4Jc4DCfil1G1Qlse5lhWSzR4fN8eAkek1Ovpo9QprDALxD8CTwZlvxVH54Z40TVrklx2+wfjQZtB446tqO6KlqeMLLZFagw+RIHMIAQtm2GevfANh6yP6YMK0XtBDN3Ygr6oM3Qq+3C2K3eWFmGPyI7+Bifplx+Cs+fqVciV3tqu/r5L/iMG4Va9m1ADNgmiiRWvyIAoO1a+ND+2YjFPBS2JVEAbBtRKokd+jA3DVjgOH7ZD1OCyn8ALaN68MqeOBiYljKznDV14Ty4RlVROy0juFwD8x15twka66tYIpyDKP6fgBMQyYmyDw9TYAQnrkFvxpDb2VAP/ZLc3y5ilFRIWILtns7+V/Gdsgz3t7yhTGHoOswoDdFII4D1ATjbbs8sFyZLiAVJe7PBkLGd3YP1NHxtDXb9fyPfbnGwLmInFUsWYSTEdWIZz8xepUKy01UNAvDTVzo
 opuas7Bp
 lfO8NyRBVdyPE4S9iZvqo35HFFqOPr0xDLgjCeOVfm7fv8FikKoAfydspGPKBIzVtmJ6GuxjGPXUC+Gju39S+0+L48QmdpyFyf4X3AefVfwNE7YUf7xAXevCiWcp7qtV7bO7uOIWWu9kBDN50RpNiNiz+PwUj/R6PntRJE0ayj5yu5ErK1IE5fUJ21cggubHLYPBuIJotbmVzBDjm9+QakGEwe2cTtYruPT9DRRlvA6nERzOudDMqUhruYaHnI1dQJi0kiQH0pZvTNlBk2EX1lBk5LAfTM+zNvjwlTqir/MAhQOPhVOiNovA658uhLVtaZV0bcHCwJueHQO7fxA5GjSvbbIttfN5/W9zOKXXN8bAn0Q6XSAZwupPc1IlxPpsjSA6R8ZmSD9mLx9z08UpLKYYjQD3mV5iyB9G13qrUYKA3Ft8=
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c9ba69e02e3e..06dc3fae8124 100644
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
index e4a5a46db89b..5004a2cfa0cc 100644
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


