Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EBA606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kgpkTNhB
Received: by kanga.kvack.org (Postfix)
	id 84CD16B05B8; Tue,  3 Nov 2026 13:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8242F6B05B9; Tue,  3 Nov 2026 13:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7616D6B05BA; Tue,  3 Nov 2026 13:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5489E6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:32:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E355C40506
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:32:09 +0000 (UTC)
X-FDA: 85394652378.26.BA52166
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E0AC51C0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:32:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgpkTNhB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730728;
	b=wmPNdUEXdvf3LLdLfRn08klHQNjU7+nFAfxUqO8rb5E+jEHZt4xn0Z7h7tUcaHfYT1ggLK
	AlWyMn9jxinB5E1y55uI0pSbTQUT2akR854Yi6O/M21hydFV5sC1OY442uQCPhrOm0bJpp
	vWGQWKVmSR+07MzwKVanIS8wo1c17tM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lPgWCWw5afVEOKQYPDlfBM+bkXafIhu1shhrvFW/Os=;
	b=452/Wp4WCDm1IsxUOuzVCMJq92FbV13yrSZyi+fJohqMDjrSLr2KmQ/5eVBldMKsiW7koF
	/gMTvM35PyD3W881ZT8m81hd+6m6hRC+BtMC3yiwHl6k8bYiWP2HblnZRCTDIW683IJgIu
	95WUiFhLmEDHd+RzVwXcaIyY+Sv4fpc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgpkTNhB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 436BB403AE;
	Tue,  3 Nov 2026 18:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF9E1F00919;
	Tue,  3 Nov 2026 18:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730727;
	bh=4lPgWCWw5afVEOKQYPDlfBM+bkXafIhu1shhrvFW/Os=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kgpkTNhB7yGXCkKUs4H6jKAD5UBj78pCC/2XF6BjFOZtt8aJaQWLro4WgITERqSea
	 TyXcWQBG9mkCON+8iBxqKY9eT2aC+PNu7PnRil3Ljfx3NwEGZrFqcf56Bzc9n0pyI8
	 v4Y0SjZehNNiK3xlxdxo0YHVxys5EjJBXrmdfcQAr23ZIQ8pQ531kP3SVCl9KoBbMO
	 P8kvxNuIkzUvuWxfWt6Ta6CNaCdwIvms1azZVe5UPBop0UMUDr6nrkSCxZw7yZIxSL
	 lPymmtDYnrpakY2TcJiXxR0DMSdHKaJaUGCkqSm8d8Rny/vcmB9mGVPp+GD3fYD7n4
	 fJBY0Ak91Usug==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 03 Nov 2026 19:31:44 +0100
Subject: [PATCH 1/2] mm/memfd: handle GUP pins more reliably when
 write-sealing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-fixes_core_2-v1-1-f332954f1df4@kernel.org>
References: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
In-Reply-To: <20261103-fixes_core_2-v1-0-f332954f1df4@kernel.org>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Rheinsberg <david@readahead.eu>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1804; i=david@kernel.org;
 h=from:subject:message-id; bh=Wy87zWgjvDFa6nQn3gznSv/cs+suxS5XMGobWeCkKH4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJeacxay2Tq/jbvx5a4SpXu5FvTM5f3zpp0mGf3tISf8
 8orotOZO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiIjC4jw35n6f1q96ULl63I
 5P10sEks7a+G2Pf/s6X9mafcXTDzji0jw6Ps/xadM04YR4VOShN4+fWJYTFnrmRs52SRBKPbM+4
 /5wIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: tn4yr3kthftwt8hnke9ddgjrhcx8beza
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E0AC51C0006
X-HE-Tag: 1793730727-309406
X-HE-Meta: U2FsdGVkX18tIkJx9CjWJNqlBUsn6WaXlPgi/teWey5i3Xt00w+7Z2OxzhXt/L+2dWi72a/MVlZhMjhlJKTSh/c7cktwP2bR7NpFHZr5UTyV9pztAD3AkDl5w2puSI/sDeMQIiq02W2F8e6uiJs/BEAvIB5JeDBBd8SSdSLBLCq1zwoA1ajaKX4HEJeLGwHfYezrePKDPrJaLwLGYLbPknQLc3bhCwFikYlfNVDWpGEKEVxLnTvZ6SWlKV/d3vf5m60wRpUKLv0i+pZofz+sPDfYu9nfnjv86OKfqypHZMHAGt6HJ5E8aJaRIq4hQTdGLuF3d2wecStkT2Z2s5GdbTbklbP2EZ7bT5Bc+EInYMIm0a10lGpNOxqCLMKp5Zl6XSurjEgkpxHGgpLxjEQTHtWK24Wlc8tGKhrV4ZdmSUJKO75KJlhPk7hSJx+DkziDbG41WlcZA+jgxepsP2CFw1i5fus8dJVOM+yGXplB8cSlDje8Awuk+OJRsQxshU/5Amb0C5biEop8JfOCZwfZoDsQEDv/J9e4+2QHjYKKY2vQtScIXCm+odJfW46JDZzYvvV/NiOsGnlasJkGJnf4lzg6fxk8GsKUk1QlLv1RqOA+CbKh7CHA7Ep/CfX6CZs0cZyETMgPZa5pVFgkUE5IJhf6A9q7ExVBeP+QvxNPHrp2FyZO0uEM1oRJKrb55ag3RzQZb1ibM6yRTYnnwSfpjJYfZs1TMrv0cve9YFc2j+Mk/tMJoRHOlaVbv589RcOm+WNuUOehcQnWdjz4vboxfbRacJaEgMiATPYoWPNwGSW8ZK7OZrC2dXQ15uBW2pqQ/s8tWZc0eFwMpN8a95ycokQhbFhWF1E9zlenksFUMutpZfVwg3dpdxYlURlHGFDKhmQZd3tKO6uCkkyI/K1nyrIvbQ0hSZmwPpSEXseXLxSw8nx8ItInRuUUA7v3PLGHSw8VZ6OXiTex/mnilK5
 1MNZG0DG
 YLldMqIzpyP7VWg2FOvJg77J0SKbAnw6M6ypDMRLN+k8C6dRanxn772HYcmbzg+lkmQrtFjivIn1Ez/UUABh837tglk7KuDzNGqANwo1B4fWwflTz0hGnUkDOhOLMVX/Z1NyPOdxYrYyjUuRuf+/VsGcw7h8XFU5P+XS1hpSNIJfxy/jQNCDf/L6IVXJ1jCMzPzSgHkqR6rKauFlVT9aNQansWaux8M6kLKNJZ8Nt9ShFdYP9k77Ysl5b7GYaCD4LA4BUuJwZpOHxyI7tqSlQHq9iSna33BGyiOxR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memfd_wait_for_pins() detects GUP references by comparing a folio's
actual refcount with its expected refcount. As spelled out by
folio_expected_ref_count(), obtaining the expected refcount when there
can be concurrent folio (un)mapping is racy.

So it is possible that a changing folio mapcount can race with our
check for GUP references, and F_SEAL_WRITE might succeed even if there
are some, allowing file contents to be modified after sealing.

For folios with a reliable pincount, detect FOLL_PIN references using
folio_maybe_dma_pinned() before falling back to the refcount comparison.
For small folios without that, the 1024 pinning BIAS makes it very hard
(although not impossible) to misguide the refcount comparison.

This improves FOLL_PIN detection for folios with a pincount. Handling
FOLL_GET and small folios requires a more fundamental change.

Fortunately, most interfaces that allow for GUP'ing such pages use
FOLL_PIN, in particular interfaces using FOLL_LONGTERM. However, we
still have some FOLL_GET leftovers ...

Fixes: 05f65b5c7090 ("shm: wait for pins to be released when sealing")
Cc: stable@vger.kernel.org
Cc: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memfd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 0f6fff004f5e4..9eda4c3eeaca5 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -32,6 +32,13 @@
 
 static bool memfd_folio_has_extra_refs(struct folio *folio)
 {
+	/*
+	 * Use the precise pincount where available to avoid racy refcount
+	 * comparisons.
+	 */
+	if (folio_has_pincount(folio) && folio_maybe_dma_pinned(folio))
+		return true;
+
 	return folio_ref_count(folio) != folio_expected_ref_count(folio);
 }
 

-- 
2.43.0


