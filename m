Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09928606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=AQfeeYHM
Received: by kanga.kvack.org (Postfix)
	id 248EC6B05B9; Wed, 28 Oct 2026 11:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8496B05BA; Wed, 28 Oct 2026 11:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110D86B05BB; Wed, 28 Oct 2026 11:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E58DF6B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:42:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71F4FC0111
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:44 +0000 (UTC)
X-FDA: 85372452648.13.1BE2E12
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6707F80005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AQfeeYHM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pUgYjIVsfvmVUNs8qB5suwB5TeHvRpiFHFLqpx4meZQ=;
	b=5MMqqSGSSGlypoxiyRa9tMTXNWBbjXh30y1PFQ39B/5sEIKE0Oqe6Yja3Vea9PnaEr3z0n
	L6ufFMbm/cWpX766U7oSnwS9aIuj+cbdEiV7kAAZLjVDBp2RYt4M+M4d14wqx285oe06Ir
	QeZ3H+u2ITyNm9JjhrrrmLvGIKsKmpk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AQfeeYHM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202163;
	b=5NizUFyOBEUOEvbOxBuYI8SzGj56CajdrQpvF6oYHeSVv+AqE0RjBRHVFLRH+/AxKCz1jd
	6cB10qy5m54imLeJ7wDU8Lt4Ek4M37xf6yczM0jHslKQ2+2RMoQ2oJI1Mgfx8PGQUuA8BS
	DQ7k6o/7Gel3RcoJGpPK60PBlpzXWQ0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=pUgYjIVsfvmVUNs8qB5suwB5TeHvRpiFHFLqpx4meZQ=; b=AQfeeYHMMGo4hJeHsYDE+/Kusv
	OnaEzLdR9C+ACTkeOsiq7LVtyMAXQi7lbkAZRV+QxsHIHLWKLAN3LEIUyC+2ANqDS5SDv2gYpXo/b
	qQMW15ulGnGRtJ1mKdrJAiAbJqAnw9PoxmH7JS0/ljjAYF3mQKZ6GxmU1KtMbcUGqqreLNqb7EjWh
	/tsZKRTbOMl41HHOkW6CWm2zWqzkMiqrKilPDviKvDXX8QImKukI1Ow3UoD87CtEOAbwByhSSAaWN
	6EuhEupnu6nUGSkcpBH9M5BjT/jS2V9YdDlzw+8m/N1bdKv2dm9Etw0U84Xs/mJfGKWkOTsTqjSvN
	BhZCo9eQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5nU-00000007Qmm-1fQb;
	Wed, 28 Oct 2026 15:42:40 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>
Subject: [PATCH 0/4] Lib fixes for 7.3
Date: Wed, 28 Oct 2026 11:42:14 -0400
Message-ID: <20261028154218.1668182-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6707F80005
X-Stat-Signature: 46ox4pay6udp1t48j1ckyn8g1e5zbt36
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202162-519630
X-HE-Meta: U2FsdGVkX18w7UYO8p3JT0t9sK9sa0fx2/5NUVXACBgfFhislCGq3QamT4enXPGOlwE+ErMCx81vmetb3d/hEbOPeijVoXdZiTFnLBi6um5C+W0YC52Nh3xmEN0OfQjnIoLzeBpQsl4sLno0Cs/Lz6SIOxgI40NE7M/ULnxzw9Xw6aYFfbTEFpqMG316Ov1ZgllGcez3thcyM8w3/X7UqLT8V6ID4wWa9FhQctH+R74d7sbb17zID/gSpfYYTenM8U24leTlS2dpX35+uw5pdrs8+gBe4Z3+lneMTe/oUKubpw30fCQxlcjbKFZ2QYvEusm1rQEvrQvWiQVob4StxD0Jy6RX8SJPqTsmOrrNYS8C2oPd0zzwuKIK/4KZSK8uZwsJLMtDCQg8CENaO8U49cnHhGazA3RBfHUpLHzav7Z62+zdHRiUI9KQn5mGPPart3+S7m4kZ+lkh0pgEcye3koU/9FDkIx20+7LPgNUs4n+xxKIZw6/w6ogMvsEQhdWFdLHE0ypBqK4otxeHrXoIYKQLrPDugwvdEZuHxXXcsNOwIujhyL5EgKVY2fwx7SybP1Sqq/lrL+uDS48diJceeVhBNAHmrqoiVvdKbBTlrkCYbBGxH8HA1zdZCgRGMWZyyTfCa6brLbzjlXatmhjEKGIuivXdt/lTQAS1Ydt/5O4G7u6p/AS2MUt2zVQV5dlAngcw+llG1OgN3mc7y+RKKO3jzey/lDCigBBfsjdhzCs1uHurbT0cb800jgjGBaCZGLaWa7ESD1dJRdCDSrcUTHp1thkb0OUTTxqbzimeVXrgllcxSBUgwKLCQb4UFmYx+XSuNyRKxNFdwJe4vo/qMJyJjVVh4VlVBc947sG9X4VeYTJr1vjjzXhaG1g1gWUETitmXPJjD/9qTC+49EpT6gE+KpZxAKPoalTI2y36bZrybSTqaAIXXEkKf07l01hk+4UM+26RrGJ8auIy98
 YptPIhwi
 qleAIvN23Aw094HNd7pIStdbP/SrR19wolHxgD0l4+ND8k0jkFKebUMvVk7y5B2C6DqdYmFkK7PWKjukI6WShbilTD8THZ8y5X7VwNSINBBDn3UfAfSa8jWyMJwhcQJKP+1xUiwR7IJJZXo+J45ZP2mAsaKd/IKurahJ1jD4ytdLuQb2itUJfXl94hpQi09dr5TAbFS52UPTckyh21MnNLxZOPg4GuOGK36nnlPVhGB9/4ZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Two bugs found by an LLM review, and one problem Lorenzo Stoakes
reported off list.

An RCU reader that restarts after its node dies can dereference NULL if
the tree was emptied, or holds a single entry in the root pointer.
Patch 1 fixes it and patch 2 adds a test.

rhashtable can deadlock when an insert in atomic context grows the
table: the rehash may call vmalloc(), which takes locks that are not
safe against interrupts.  Patch 3 keeps non-blocking callers on
kmalloc() or a nested table.

With CONFIG_DEBUG_MAPLE_TREE, MT_WARN_ON() and the other WARN macros
print the tree and call dump_stack() rather than WARN(), so syzbot never
sees them.  Patch 4 makes them WARN once per call site, after the dump,
and makes the BUG macros BUG() after theirs.

Chris Mason (1):
  rhashtable: fix vmalloc() deadlock in atomic rehash

Liam R. Howlett (Google) (3):
  maple_tree: Fix rcu reader NULL dereference after the tree is emptied
  maple_tree: Test emptying tree while RCU reading
  maple_tree: Update internal warning and bug_on code

 include/linux/maple_tree.h |  54 +++++++++-------
 lib/maple_tree.c           | 110 +++++++++++++++++++++++--------
 lib/rhashtable.c           |  18 +++++-
 lib/test_maple_tree.c      | 129 +++++++++++++++++++++++++++++++++++++
 4 files changed, 257 insertions(+), 54 deletions(-)

-- 
2.47.3


