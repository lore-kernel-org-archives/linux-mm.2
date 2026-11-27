Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE93E606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MgJzpPXu
Received: by kanga.kvack.org (Postfix)
	id 0B7CB6B05B5; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0410C6B05B6; Fri, 27 Nov 2026 17:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73806B05B7; Fri, 27 Nov 2026 17:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 832606B05B5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:27:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BEC8C055B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:30 +0000 (UTC)
X-FDA: 85482336660.04.8797561
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C1F3A000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgJzpPXu;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818448;
	b=V91O3UMWVotJbJqI/uGQo8gMY6ov9MCqlO34n5AEfk0sOfiNUa9MbT03wJ3UNW0irM2rUG
	jUcVbm8ANbHPqsuDw6l7uJ1wk/9xl5h+BxxOkRL7voNemks4MqWvdveJhSGDNBGS5KFo4s
	yii9FC+Ri9yi+D2k3UXT7k9KsxZAwQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdRKRFKagh7ahfwk2gV4n/6foyOOG7uiXbJX19kNPyY=;
	b=ZibHiLhKPKh3nITd1aGmCEmBYe6YH1gRNjl3eH5Xif/8090HV8afATY1HYU9jrpBSFVIgx
	VVWMJwjhXelsSynTD+X3LIAIC0R234Ja0mlBeo5I9oDplVEPvzDI2l2cTpZ/xwdRgpkAQ6
	I99gdyGKiQXb7WsB/lqcrQI40HZIQ6o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgJzpPXu;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1E4B61200;
	Fri, 27 Nov 2026 22:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779D01F00899;
	Fri, 27 Nov 2026 22:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818447;
	bh=bdRKRFKagh7ahfwk2gV4n/6foyOOG7uiXbJX19kNPyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgJzpPXu0BIifZ5pmGjr8ujeHNI9pOSc61O3tOreUSor8axL+/sxxy1wvvLuZofFX
	 6NyPnZC2YA+qi9rQx0+x2ksW1aDWxAM691QEEVS/xQkh5QyvhzYub9q0YTgaxqtwOi
	 IHBA42opq6JPqGSn9ALrzt21vqKerbByqOdkpN3Jt+QdASRwjPjVxFkHKYi3+WrdI5
	 T441iCnXCSztPdMAskpnLU5u/zu6a2+AuxC3MUgNsS2NSorjCaRWen5Rl07+GmS26d
	 h+yGXEWZMl/EYCCiNYLHNjFo/52T3X61ad8VasuyMQeTdNe9Tb0Y0Mg3Aelp1sgmbH
	 dtI9OKnL5crPA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 1/7] mm/damon/vaddr: advance migration attempt in folio level for filter out
Date: Fri, 27 Nov 2026 14:27:12 -0800
Message-ID: <20261127222719.105510-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127222719.105510-1-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 6C1F3A000B
X-Stat-Signature: crj8rnyoraxdurh4q4w4aohbbqg1rf4k
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795818448-584705
X-HE-Meta: U2FsdGVkX1+5ZjeGlWOMpCrVjlmV7KJ/DJ1GWuu7lcd381/bvkoUbocBwCDppi8iHMCGmIJ1ELa+Wq/5feXWmJF6YB/QESyvxCnioi2S+IBysVi8WnbOEsHjWLpzeDZE+TLTKtmOU9jZ6pCVVaBIq2Q1PkEsZYhSyNRZkbd7vbFAnqBlyH1l3+OTa8MD+AWs1ZBo7EttElGBdmPa4pyXVTxGKFCONgCX3lfhYZ9RSu+db3iSskJoNX0lhFa6O+/tAct8BikY+TdZR9nQVv+Ve/4hXgxSvymIHX+NEzz3CfD9/GXZJFs24e1MEKwgXy4NWtNqk7fTGD+zn+tLnZKUcV7dj4o+8ZpIXlOQ7v6pys2sunUS69fUm5Z7jBhdQIVoM/oCpnnyrZ4qunfZxsMXrgQ0pEnSD7+VwoTk2J7/9AsTsVGb2xnt8VM8uDFSrDhAi5Wp+iCjMYTL9NX9YZbSEVJFEny7e7ZFriDw/OxL+oUsK2vcTOMBgQgIMBNhJNKWHNVUjRq5gZIMwArLKrWl7U1mSaidYbWIHUXonN51iSgBlbABKOOPSjPXZ5dGhbJ6/aEts8Xp2H1RvjhkqKqm1ueRE+R51JeGgZlKjcxGeM07iRYn5coV037nqM5ZfHXXtocShli1+IjSfPuKeQSfIYX5iwXv1J+cgar++XqlfDfcrloKF2aiaib0f6IQkvKp7QIHFPjLgX76l5/zv0H5Y4cCp7V+E1Dn/1sf0e3glDE8sp8YkbhH0o3DSFhlN3nshDar4hS9/3vPRL09GA+8TcYvtYIA7BC2EPjbDBhlO/FZhxd9bgjfE5XbJtHVGhP8tKgG45/SoZExGAUyJZ49m8kliEV4+B3YgwuHzib5sbrHjkXgiE0MG/MuKu4YTo/qyXA5MN2mEYKRNkqtBC4zq+ZM6/TTbYSJ8M/ZagBs0KRG/9cmZVMHzb/yYIb7W0mlDM8nxppza+w3hwXvQHc
 FKXyt5uj
 cI2Jrwo8kqbq/Rv2SbR4WXKAf4SPlwkjPJtougln8ANLjLu3j7EjiynfxwZNUMVmCqzi59MDwui+wRMcjT0DRs5/D+4d+qCDpb0N4sdvIkOEaetA8mJQDOhSMWJoRs5MYGnUMrdzybsUL6V8mM/mzJk+lnWcVzahCBV95H+c2TQiIryw2Hr4Qdo8hS6nBIgn9R+ucLd5P3LQ+b+5ywDszOwjCEj1BkLd5ycB7hWMEeeohzsRn93vhqy+rtsB9rV3UBiDBVgav6b+lkdboAFl0ffH5mmjPBBmgzvGlhUlZjphy5s7OWlgjoyV/bk685BQnO/nY3hyT6/5eRLkbw+pQmNPkIkLOyR2fiC7E/supJMN2tHR7M7uK/TFW134L/1sl+yy3pu4lvIvIusbZvzKu2BOd67wD8fcoIl1B0ptE/PbrjapBTiN2dgt7giHGvVujWohygRXD9SQx8UyR4C5Ewv3q6rDSK7qNmeZX2kR1k6N2xBWR8k15yO9veA66Nv4alRC7CJRrKG+eGG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_va_migrate_pmd_entry() finds folios to migrate under the given
pmd, using a loop for the pmd address range.  The loop advances in page
size if a given folio is excluded by DAMOS ops filters.  DAMOS ops
filters work in folio granularity.  Hence it is more efficient and makes
sense to advance in the folio size.

Advance the loop in folio size for the ops filter out decision.  For
that, do the folio size based loop advancement offset update before
applying DAMOS ops filters.

Closes: https://sashiko.dev/#/bug/linux-67c34df7-6dfb-4e18-9ce0-0d26915e5785
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 750e643e020f..ca7ce9bd96e7 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -883,12 +883,12 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		folio = vm_normal_folio(walk->vma, addr, ptent);
 		if (!folio)
 			continue;
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
 				migration_lists);
-		page_idx = folio_page_idx(folio, pte_page(ptent));
-		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
-- 
2.47.3

