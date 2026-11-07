Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA117606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PgDBO7R9
Received: by kanga.kvack.org (Postfix)
	id DA40B6B05B4; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B796B05B6; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7516B05B4; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 940BF6B05B5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D0F81A03F0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:39 +0000 (UTC)
X-FDA: 85409655198.29.450A8A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FDCB20006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgDBO7R9;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794087937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmfkuEncO7HrgAvrvHVaRTSKNdQ3l+JsObN4du/E/II=;
	b=ydrQpnvtSTLHZBpv4HyKu4sIzw73y5EffPBaLH+z/yi/12m4d+i1dhwShIJ2ICS1EyhLo4
	DBcUdI+Im1BMy6Dqn8+W3vVMs76MH6BTEGBx9698LHEMO8uhpMybQYP3wik+07xwWQNyRX
	8mTQciZ6gNLgdAM+TAFvNYMuV1CaQ7k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgDBO7R9;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794087937;
	b=yDhFcHDQyRZCQq8niJSU/HJCha7vRVqhG5UmInKpmqoHjvSLO95HLQUIhtarvAmeYYEp53
	xSgKW+roDk9Uruejl3rsmntDJbuAernWEiHLdtfLDHiO6u/KsCGuw+OzCLTjWr+ONiPwDB
	701dXUPqoQIxyAf4tqr2OOPZJH1t7Wg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A67AD4469E;
	Sat,  7 Nov 2026 21:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5218F1F0089F;
	Sat,  7 Nov 2026 21:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087936;
	bh=lmfkuEncO7HrgAvrvHVaRTSKNdQ3l+JsObN4du/E/II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgDBO7R9zy4bT6hGZ8egNmJMKX2P1CUnL3wYteY5+qxFF00Ks68Ez2rAW2khacP3H
	 lNdfFE3FrV7jyM6hhXmy1qSPpagMXcMRRqxGTcJJQSZwcS6sAboYJ5XM9pP0K3FsVZ
	 CVseyA4FmNo2iL9mTd8CBlHC7uqK9O/T4acfySY8rFGLfJZ/qt8kTI89QCAU7ZaE8M
	 b9PIedAzsH4hyfPTMFG1iGFLAQ3ma43Sw2jtD0p9E4VNzF6bjiurw09NPs6M53GXvi
	 3GMX3h+4IXnqDr4Lmt5klFIL3M7dKRqNty1BMgzV9Eb4HwjbJmbA9yAu2CKVX28k19
	 RSSuvC3I5ZEVA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.12.y 5/5] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sat,  7 Nov 2026 13:45:24 -0800
Message-ID: <20261107214525.304638-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107214525.304638-1-sj@kernel.org>
References: <20261107214525.304638-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7pwgq3haxjipqi3utf9bndr1647gzbwe
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5FDCB20006
X-HE-Tag: 1794087937-184310
X-HE-Meta: U2FsdGVkX187Q4ua4gtgLckKEsDCEak2ZnTiX7w4bMxOPPtYxYnoxivsU/e/NIEJr0ByPKa1WY3YpadY90pVAE0E4qurCp2t2YhSX14IG4Ozr31jN3PO2LPzivDCPparlFmDsuRYGOkJ8KqrGkIEZaQD2StKeyxAUAuupUgyDt+XwyHu+4bBAp8eBXJQVTMdaQwAg3pl8NPpex8Ch95/N9VapFukdP/Ap4Ty8GUZMUivmKcKB+XZ+pjG749UGOcR5igGfbmvmgUNvwJ8zJZIymSXOng03LelG18xkgWjdWHvKvyBINKxOjmYoofYHqfMPGhOTYxLkbruLBz+ZuKeinWZWyafYoK1KKuEEWbSiaYQDqsCLzZfk4Tx2/sWODYF+9zf9gq6buq0nY7OIcNZxgdiHRApaujwTi5VFNWF8mfvgjyQoe0k35vaA7e1XD9oubmqivN3FFcXn7BZCLv5gGmmP0zuKLFC8Ncm/Z2T2seyU4fd3wqQzJbw/KlaUkliIhJrQV9gd5U3Tq+ycehyRTHnsqnSdvJMkZdIpXikRzUnzguwXPpRfS/spg/bnpmuL/W5wqmi0fHxcW5PcAhgjfQRjR8ZmZZYrMxszQ9q7idrSNmf1wZZQ7Yj5YAFO5AZJlHv4Wpyrz0gNvGlkTwOVlb10TyrxsLPcynDugRKCRTsOY1m2G1ryDnuPerfL6ZHZ2f6vyTeDrOENyNpEPeULjXNkgsTmfvAo0gWolpY3RGqODBv4ta+9YxrwUyGGlmhgJ0fJ23lJLGgPAU/m6puNWiZg52Qf7a6EZlq8XF/AAc+vFNzZQMNPdfuKk7w+QsA11N7aJx0pOeOmC9KxQS1V+tH55RUOcKjNFYi5aT94APnIVi1uGaqxCiDWtLYkjoe0zEiVoWlc+uIBh85IQenjCtW+QWQ2ye+D+S3aSTS1xNhgZ9Pqa1RG5RLjRNG09km22g+MXMM5r3kWlRnsmW
 QrhX3pLx
 5WXoBhDI1csBb0h/GaNP2n5x6fTmWk4r7c/i7dRUgkyK1tEcEZ5yFxJjsrhrd0N/3VUTyThaZaHKZSODZOyLAmaLnncIxVwoe7px8AndFNJBoyC7AGhyz/sT6fyIHfkmM0Pk6nLW9vVfCi8Cvo6iSr2FrPCrxjwyR0o27QkL2VWVsBQYIyHOlEnXDK9kNpiNxmBPy54E2pIQg4qmJGouyW/wwksTwLhpSotDL/5e1f5uLRv9UGfG90Ad9naZ4UEXl344u5wTKClb0RltkwXxuYGdW8mVqfMXy1lrXgzd1bmM1gQxwFAN1e+y59YbBtMEWAFSORBmAwnzci/BLoXAc4SGfZ17oD75lmyPcrwy7QXc+4+vhusrrswdmaQvdqHKbzxF/AYwxeGQHLX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
(cherry picked from commit 5695abc4e742b947f586bfb6a080a80ad9957e5d)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 046c07b86a6e7..badd0628e5eb2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1686,6 +1686,26 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -1714,6 +1734,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damos_set_effective_quota(quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.47.3

