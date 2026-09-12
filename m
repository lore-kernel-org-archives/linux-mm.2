Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC98C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0C06B00B6; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259E76B00B8; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122976B00B7; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2C7A6B00B8
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1077514052D
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:26 +0000 (UTC)
X-FDA: 85206197412.29.7171EE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7E48C100006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EP8NNACn;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPw7WofRL0yhNhsrvBljQ1VTNgjVbgROPe2T+epdfNs=;
	b=s9XKWebuxjaZpNt6sbnTjye5mYr9NQh/4m2iaWA+u9cghkEvaj56TddNUeNkLWJzzHXfII
	+vLOq0JIX6kEvKp6qLBXrJ3M3B4TP/gwASsCRDtUbjnjUaMylI9m+wTb9/TbCauqSSqvEV
	lHQIlytiTU4jOhwGbjEYtQOBA6PFUoU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243704;
	b=wjG0ks+WSnveJwbj5apDlKb+PIaTnLsWhonYq7Mpgt2N2P+jtHTVt4jIF2FuPuQKhdH8Yh
	CTiu+Hkxj1gv5O00EeNB9HaaLFOy5/P81NLw7sa/tJBWpboBU2bN8TWR8ZvIO5hmOQlWgM
	HiT80hSq4ih/t1Ccxk+G0Ajwrdji4Vw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EP8NNACn;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27F3260233;
	Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7641F00899;
	Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243703;
	bh=SPw7WofRL0yhNhsrvBljQ1VTNgjVbgROPe2T+epdfNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EP8NNACnxP8LGX0DzyAGrK4kC150AOFWaffrHPg6BDHffvFL2APmtx+fTXVg7xgmY
	 rIOBtRjTxhwkYweY1ksR8IJNS0EOUF3hFAwt9N3vg2YAWGUS/+O6x8Lbr3S+X6aOpz
	 gH8YdKJypaT9DVpoPfWwU8rZkUq62iME1elhD5MrQ0uFs7reGwuFCmX+sCGtxXhsj9
	 vzYqSQ6EaUn04l+QiGiWeu4lhZ6mhTIhO2yUG672NW6JaG+Rhn2JBYCKK3yGX06SRK
	 zKzmsqYTpKv+7BaLr1iO9X6If2mQBEAZEP9CJlJY7c2ogsEC1/s2dv70aGxK02puKl
	 J7SrG1DR3Aakw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/9] mm/damon/core: use damos_quota_is_set() in damos_adjust_quota()
Date: Sat, 12 Sep 2026 13:08:05 -0700
Message-ID: <20260912200814.145612-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wyygq3taphm6e1rfg86rqajrbahii83s
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E48C100006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789243704-325153
X-HE-Meta: U2FsdGVkX18NpwKtqr5gHf2odGESyYzAQ4oe3uVeo4yyeBNZfZjiH9hjBEi+AVGZH5KpsTmRqU3N7w7fxw5VbJ9fqMIlMrhFSKzP12n2fcmgJjs0W4oHOGhd5PmGqdvP7zLot3SrQV9hCPXAkyoRCdOmzo2dw1LZwNuk8NZzxn+NU/ZwssMoITGwxlBP5DKwY7U/+pWUbv/cA5Ddyo9Uym/idLlG+wkjKmxfu0N+1RYsU/rEWsPlndy/3WBFq9IHLwQ7goRVHRg2+PdbdCFcj2yy7uWqXbjRsFR9gLecBiaMVCBMTnDsZLumce+OvLvwkkYOVMplxSHKrQWPOq9/wnfAWK1W8m3Otfam8GQj+XpylLEckwrhQRY0NFvzB3BlndkRCLBITCiCPCj6LFpPB3G7agHvoic46LKu4kg8ZH3AJYsMoWe3HHLAz6KpUVn3rfIz7Dt86D5de5oogjIkHwZhQ94fH45B5hZHu5tpmr4Y20TYdrUypykaG7SoVixdLrVp2aFL/A3ehVeCZgNEhSxLgRuFn60nSh1mkuNBO7nH29MIPPui7Nno4VcpNZpfOWMSf1IINjy+2REmHN815HevxbJAW6iE1hgZhBqejjpq/a1+KQkqGbaxdMy1nwSeyLz5Abl7ydlfB4ismHjep154gRpuWvvHVnxEUP84NNBqarqU3XNQytsasd6pdMeVWIHlkgw/o58Brea3UN3pp+qPknMFBl7e3FbQu9PlLuAXLD2WMLwk/3Ro4/68Cym2wEuVLVl0XCumCXz03HkeF923/a4uVCxVF1wRkUDqMfkLzIyMvEAEt6phs3hqvTuTNeDC9Cc9mx0/zCDZdgFfy3F1bu+kEqCoRcCeHCV72DfhT876N/ME0gPRwyoztRvruZAxfVRnQ92uqZjOdjxrSy0Qj+YdMGZqSW/G9L6/WbG1K0eqD27RSl6j25Mm0z97Znie9dTyrVGfSFADqW1
 P7Dl7E/w
 k7xRjIQcpm11TtPviiqvcdN+kvAmdalI+I1umsIXDhrx9k3AlI+07VZTgMiOp+wLArFyLzqTSAo2HFkpF9IiA336Czsif8Zx86f0MmwT3gtX/YoX6K3ps4tiXc1fh/PbfsftfixA9cYdniyCSOfbvPA6CC1IwIx6Av6PHEX4tDw2GivsSo6RIkaAdsvxkmN0w2Q1d3kzZiNRFo3eW7ozcswX3/BoAJngId0xJq50oQUm7Iv7es6ZD6P+19tjWwjYbGtzflMQPsOyiByXCkl9PKdW9AqRY97ubvgP+y5KI4YZHmHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_adjust_quota() is manually checking if the user set the DAMOS
quota.  There is a dedicated helper, damos_quota_is_set(), for the
purpose.  Use the helper.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index cf10f6d725c19..dd27068cb83e3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3344,7 +3344,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	unsigned long cumulated_sz, cached_esz;
 	unsigned int score, max_score = 0;
 
-	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
+	if (!damos_quota_is_set(quota))
 		return;
 
 	/* First charge window */
-- 
2.47.3

