Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB43606EE80
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LcdXsSLP
Received: by kanga.kvack.org (Postfix)
	id F3CB56B05C9; Wed,  4 Nov 2026 08:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14186B05CA; Wed,  4 Nov 2026 08:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E030A6B05CB; Wed,  4 Nov 2026 08:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF3386B05C9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:03:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3595E806F2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:03:04 +0000 (UTC)
X-FDA: 85397451888.14.6A35A71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 160C82001A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:03:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LcdXsSLP;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rz5gqclVsI7Nyi3wdIsP2V0gZuIMwOehVRh4pvFPagk=;
	b=qzXclvavY2ptLTlygK7zJ7UC7WmJhNSPa6A2PEUUc/G5DzIQw1V1jFrnI/P61LN5aZl+wm
	ILueQ15g0j2tJnPZTasGXIA3m0X95K6McyhYk2UnsWrguiT0IqU94RhiVPLiD0LuNqVZJJ
	rLbGXLFIsBQbIRXre1JYKoZMVZLUKpg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797382;
	b=bARt35trg4BcKJJ1SaFjMx4+bBSh8WNBszSEi3rX2KSYVMLSTYh11id11QOOPieC0eEh3C
	rto8njEwKqUdYZKZG/EJ4xnJaouc9n8oAp2fjKl77lnhqqEOCBT5dkjettkNjWqvdUGjf7
	La0qLbfuRzzIGGquHmlulDhnyRpLaag=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LcdXsSLP;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61A36438DC;
	Wed,  4 Nov 2026 13:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F091F000C1;
	Wed,  4 Nov 2026 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797381;
	bh=rz5gqclVsI7Nyi3wdIsP2V0gZuIMwOehVRh4pvFPagk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcdXsSLPAg5DKaj/aTv9PSu2NP1TfKv/KnATTp80uFZvAj/RMdBW+1ZOPeFrFXIx7
	 C8QG6ERv/NLY32h5WhymVgGeNa+YQYciUPxku0pk8GVL18LnAMrB2tjXMT35BVtc1f
	 RKHAHigPew3UGAZSjvFYrFmd/K1cEReTLTZLPr6jKunichT+DFykWt/XzltrNGwlxj
	 wZP27+w9nPxPszO97Il7WVkaoQE/QEWONuTFLsBkK3oKjpihaYjzEp9BjCpS5snY85
	 FpI1lwH5PeatNZSbHRappTVAIgHvJ3XURdvAarRP31JRYg3s/AIJ3b1+rDwU6eY0Om
	 XcDyC66dIpPig==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id AFE2F1980054;
	Wed,  4 Nov 2026 08:02:53 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 04 Nov 2026 08:02:57 -0500
X-ME-Sender: <xms:_SzrajjhOxjr2XwmQIqse1UH4LUbP5FMftC_A5W_XWSuGXPGh7Ne8Q>
    <xme:_SzralRIVATV3PkPWnjCM5SvKMZ0McdyzgmUKTIQJtK-L_e3PbBXnMpYJOjbb0UGt
    9u8BTkQyp3pWleC3fWEBloQXw-hlE-bVCkfIqL5wIp8dHO3NAWZouI>
X-ME-Received: <xmr:_SzraluTmjoqOwcQy9e6ka_pj-2Ujp5hVDTOHn6Ct-5eQUDjaP9sMcvxvkM>
X-ME-Proxy-Cause: dmFkZTFyj9iBgTb70dT7Nrskf29uuOyI8LMvpppsr+ztaR0SBDghph+zBPTBpK5ZS8w9Hs
    ZfoFoa0Z54ye4qFPVN9z+iBcUmGJLuDx+F5E+GwM0Yai8h0Kc4rjSxG6WPfOH2iKPLuf3P
    s2X5S/AicHnwf5qqVsIRpEEeMef/YyNBtQ+L8UUZ6s+iWkyfT6d384myBgsvxs/VTn39m/
    MUnuiW24J8M/zjUd3ANt41C4Bw9zgbZVxkihnU4ozkl0ylLdfdgBXUdCPFEeO2l/cn91tf
    naFqCjfGvhGtglGyOuDPbmSg5ttJSGEvGw0VM28OvYSuugU2nbyQInHmfNiv9aGwbOcLH4
    On74nzUC3nPKqfDN/sMhYaGYO1MhljVDfGE2vC9FhLtaOGURgAAOil+k7jNMbJdmEX0NvH
    swNaHl/JaFLs6rjXZGOyd5xvwPmbfq1hTp5NWLUbQ12f+BXP5EvzTG4tMGeerrxcrufkjh
    EzwpMH60K5EW6Z37zOiO9WWgNGElXeReO7uYKlOLtTpSMyfzof0LBZaT33gmHu1A7UQtNY
    npzMWa+RFPD0Yae0NV8sWf7t87X19860EPPgf/BtLIW4Vsla8t/wiVOklLjsi1yFPg05B2
    P13+BfYZVFRbqLI4WVn7+IhSyz5k7yg8mJzNRGz+x/GOLEdoSNUNQCEsYylg
X-ME-Proxy: <xmx:_Szrav-b31d6zMJAwAENaJdU8AZEIB2CijIOzOdlc-_ugaDjKdk7Hw>
    <xmx:_SzrahYUifZzOGQwa65MAOu6uQsW36D4cuUMV9Bs5zReC8nLjx-3AQ>
    <xmx:_SzrauNjCv6ipufU8vee145tFV4L_LJ8ioWtu4UN3clsM2caO2UP1w>
    <xmx:_SzrapSz7raAMh0YiZbyG2yxTyALTmGivrf6UazVsdQ5EDkaFvVucg>
    <xmx:_Szrap-zRACVOvdl3tdSQLZ_LHA2ubYpNiblmBUTaBM0i1IvgdP3_fM6>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:52 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH v2 15/18] mm/filemap: don't store f_ra.prev_pos for FMODE_RANDOM files
Date: Wed,  4 Nov 2026 13:01:11 +0000
Message-ID: <20261104130118.2507513-16-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: g1ixtjniw48bquo5c9zommpitazmkzc5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 160C82001A
X-Rspam-User: 
X-HE-Tag: 1793797381-121200
X-HE-Meta: U2FsdGVkX1+uiKm6iAaYxUGtbNnxxsGyU7rH9MnzrDDwTcfgAh8eqlJ8+OfgEdjxTFjlDtwXpasYBB2SdiTPbEuGTqVOF1cT8NqFk4r3lisA5W/k1VFe/PiiV/1pF7dpLnPGvY2vXJOnDfMy7/SMvyeDzKNBIgYM/zIMXpSA/ejPfUBzareaC97KpcTiTNEOzsAFZnCABYqgk8r89qChnNhJ84Gn8K+RYTPr8YVrlVwFcjItTwfgQwwXC3+DJ1R0haT7sZjDItproTr+kXYcHFdFfK+2SaWV3qn22Zxq/k4SoeWC4mRnHjijD5fei9WHqfBRrKBqBfD0/W73w0RN0oaQIzD518g5KVyIVunYoYmlNpkpLwCEnlBssQN1pTlg11DV5hvV/hZ9W9hNx1d7mUNNeHvmowyLvvsAwYPI4h+kwEy5gtdNYSUZLvkBwndD6iNAgX9GnOz7SkKhKvVSEPfSr1hD48eFpTe8RXRpiYbH8ADiPMy8w4v/qUKv+CTi3NHS9+LHED/WSXikLBmYTHRs5MUeHIa2zxtiq7FWLeoCToPHjeIGbdAmP/WtVqyHHkzO2aZpqI4S8dmORpQxlJ2ZNia+TgMbyvSj2ne2aNzPIZrEfxCbTFsOGRxV8eZl6N9S7Scy5T3aNgVQ94fWFMMf/BLjrIpqABb+RTMyH0nC3nSHuIjxoucX7AxpiczpGYRoReMW/VkfXm6rrwYn8CIwyi/jKJvQ44WbtOWU/ECIIfnt3ukuRuvnMaIYDxiXIIafNgHbudhWGxrpSG2dcTjkhH57lfecX/jExpkXLwYfY3Ame1O+Sm3bla31qwQGijoovF1G85DQFA9HCO2cpnIfktpht9vnmZVJjeL8NUxZdglpiLqCiCDqlVxAqP8KQV50XZE/cKHhpJSbJKT0S4bCYt7keMpDwyjYfjIOyH9OFHHPLc2sYdt0A+Ur4IQHjIRT3pR0n5bAEy9waV2
 cfB3YRnV
 au+FjosGMqSfw4Wt8Wy34gEkErg00h8Q+DbH61eXfNfs4N0XfD10Yepmt9gwRuwJaBKsmJCysH9o4lIbOI713AdKo8OTFUrpSmpRFHimTpEmVma2QXNRg2voHB+DJOyOoXWGXMuQfIrNop9QbyR0fik8E35t7eD7h64i2NDCX13gHi3Xb30/oOBLzgi9T0IzjvZQIdjRf4J466cJAM8fSVdCupkobFjIQ4DNFqAe/4Sonnbj2siipnIRQ3pNsITf1TuElIgcd6RSEpUW0q5D99RkjuUNb6p7KvK39+Dvci8MU6ekUmwysInO0u/OZayvZydgcrh+uGSF16ud0DmPZXDyPx6n/GYF3zn3t0oCnmATeWjKexBMi7pl4LCUvtbiPujZj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

filemap_read() writes the end of every read to file->f_ra.prev_pos, in
the cache line that fdget() and fdput() write when threads share the
file table.

Applications that read a file at random offsets from many threads, such
as RocksDB, set POSIX_FADV_RANDOM on it.  Readahead then never reads
prev_pos: page_cache_sync_ra() forces the read first.

Skip the store for such files after a read that filemap_read_rcu() did
in full: without folio references, the file's line is what the threads
contend on.  Keep it on the slow path, which takes folio references:
skipping it there made reads slower in my testing.

filemap_read() compares the start of a read with prev_pos, to tell a
read that goes on in the same folio from another access to it.  On an
FMODE_RANDOM file it can now be stale; with many threads on one file it
was another thread's read already.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 182ae7d5db56..5998de3d6697 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3078,8 +3078,13 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	if (fast_read) {
 		already_read += fast_read;
 		last_pos = iocb->ki_pos;
-		if (!iov_iter_count(iter))
-			goto out;
+		if (!iov_iter_count(iter)) {
+			file_accessed(filp);
+			/* Readahead of a random file ignores it: skip the shared store */
+			if (!(filp->f_mode & FMODE_RANDOM))
+				ra->prev_pos = last_pos;
+			return already_read;
+		}
 	}
 
 	do {
@@ -3161,7 +3166,6 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		}
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
-out:
 	file_accessed(filp);
 	ra->prev_pos = last_pos;
 	return already_read ? already_read : error;
-- 
2.54.0


