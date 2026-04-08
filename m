Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA4C10F9958
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0576B008A; Wed,  8 Apr 2026 11:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50AE6B008C; Wed,  8 Apr 2026 11:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D136B0092; Wed,  8 Apr 2026 11:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC4BE6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:47:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FB53E051D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:47:44 +0000 (UTC)
X-FDA: 84635818848.28.5938FBD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C5BFC000F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:47:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=drahk1PU
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775663262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LT/kDv7NmM6H9XF70WMUnfbRhC7vWN8v8AgsiqkvL94=;
	b=UusO27XRNnPzgTuwlP2uzIdZWcndlMbR4k9D4KzEs6NQyxhAsq6r9r51dh+qsGm1pX6AB1
	uZ3Jgo8nZNG6B/s7yQ3m6rD1Emt173fn+G9/5a+db+eVip487gPBdEGThUxIosThvIEVu+
	3aUt4vnOQMtwZ5FnbhcqwpbpyN2uaDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775663262; a=rsa-sha256;
	cv=none;
	b=HYNUa6toAapsdyPhFFi6b75llx/2ekYJOavDTg1bNGeyiha6ADhA0tuVUiQrk88WN/sUke
	S/OH+q629QROjqGc8kKnaPwVQjbin6eeC1awt1SBO2EvdZ6Tqxt3UJSeEQC3gPV4z6k/EV
	YtdVtVp98s9aoB9mVEAPqGvvDa05dgE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=drahk1PU;
	dmarc=none;
	spf=none (imf28.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=LT/kDv7NmM6H9XF70WMUnfbRhC7vWN8v8AgsiqkvL94=; b=drahk1PUkWRinoPqEMUu/IGpID
	sespBLN33xkv3O6Jo4lmIb3svEtdh52lD2jPc7b0qva+SWObuIwmOPSmZNk9IKPMqJ4Sa1pCRWgjX
	qosQDrkepdDMvgAYye/KH+of2EIVWESUABROUReQFWpLz5K+H/LObbOQeNql6RS2v+Cj6ddAj5TLi
	zZ/sy4yB1R4M68fFS5SrZRdObpTnLHHCx8Owi9DBY8DPs2cwZd6Rt/dSbOfL7JxE4admIhTp3hKnp
	Z5MWFZ5Ax0fRtqTbbchR7hrpDsLy7PaSmpzG6X9+CTT2DGLiY0mEfnCV0Y0f2S1TfXLMsd26ezjWE
	7vv09mhg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAV7v-008We3-02;
	Wed, 08 Apr 2026 15:47:35 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 08 Apr 2026 08:47:01 -0700
Subject: [PATCH v2 2/2] mm: huge_memory: refactor defrag_show() to use
 defrag_flags[]
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260408-thp_defrag-v2-2-bc544c1bde4e@debian.org>
References: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
In-Reply-To: <20260408-thp_defrag-v2-0-bc544c1bde4e@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2413; i=leitao@debian.org;
 h=from:subject:message-id; bh=mTQwwZt5uj8cXUAizL9ChIQTeOvHj/NUcNxSipTdwOE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp1niIJkVjI5JeQhzpSXj5cT6B2M8rkQkPYw/h8
 B1diSfbV5KJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadZ4iAAKCRA1o5Of/Hh3
 bfBVD/9GZrthmy+SIFfHPYogBzJSYvug1zP4vuKbzqQl/Q4yLcfr6lsLsWBVn9EnAcdF8K3hiO6
 4qua0ajk1RjssYSxMNSoBvbgT30y1bFciqPEqXOb/zFOHPevTxoBe2NuVOfQVcjMmp8n8I3qJE0
 5PuJrHyY7tD2V7wI3nQO0zU5TOzmaFWXrXQJHrh7LqlvUWxvD4TnOdE2v1T9cSArRf0mFBopR23
 7m6Cq53UJulAOtNsSH8tjNyEkBR+/z4RrLyY5tZxdxtOHQ0dCF+OTpXU6LwJMGGq1x+Osl9FHrz
 9PLz2oOvMvjWWjPcvIP8wH1XHXwFjUZXu7StH5wLgGKAr1fDPYzHMIiasVSm2/Q03wmI0ZksH7/
 kOGchHKltrb3rEZn4jB/FNYn5QrKaNL+aQn8cqRCt3mgYXOZaD3JGz9zedTjmdrl6USkgFZmTXr
 WPsgssF1UKp9Lx1tYEyNgI+omLMkCa95GFJWjsjwZNQcmypJYf03dUEr6rfjc6/l8JL+CJx95Dj
 O2ChzMieK5qo/w8Oic1TuoSt26rauwBhlXFx6KHqTlRpYEOK0h8StUzazfMYUR7USEnHpl7Yf93
 SBvEusTF9/tbH3aUbdpJZ8JEnfFFq80OUX8ZBaFnyn2ARNGlMRbmB1kICX+UGqu4D5KGaQlpQye
 tOuSyoN97RpVNgw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 7C5BFC000F
X-Stat-Signature: hfaxrepow7macp7k5hs3fhagucnpzshn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775663262-690014
X-HE-Meta: U2FsdGVkX18UIEwuuwae+0dKQU82xV5Vf6trsI2rhnOFy3hp4PjMgknYX+4eLxr4jMpfYFKtNcg3jyz5DGOm8ivSeavSB4tUMGNsMc7vylaVeQ8sjSJSlXOaVqtVMyJrBfmaLm2J0jtwtVq79TIJ4xLATtry4ed4Tnnn28ZzTkj5QbSL1NQ4jk+HnoMDvaFQ9PQm97TtGejklqN3ma0c7xkNcmnT2A9vDvUd3pCzU2viLU8ENcvAw/dQn52BXKkpjJzaahE+CF/512FcOi7ncFXc2SZcnHKtiBM4SvYjct/HPtZ/XlJfbNkPIYZ7xgGx2xoPV2SNpVLrGBUWqiP3ov214babvU4z1W2y2GhQEtbCHo5861Jl77znTmcCX1SnE3WPb2iHbgUJGPZLscCBP6/dzfvD76qAEKiTOSn/PBC7WafcH5i9QyybSq3Ihb7XQKNzKtS6v8u6NkDrSJknaQXywoPZVk7a1OStRNbh6y8jyymfpPBe3K5E6IH6UdviTyYvebERcwKlSAOtFB/Q+n/eAu6I8A18P7miTASjyWYGUAMOArlaWhJ/uJthm3xg0hqlwqnDw3GSNKpx5PuVLSNvnR6i0feJ9JAgVU18mFqVoxPosKdnzZo6bIl1/pdYQQxy/L6INjhukFa6x04bpIBfopLTUcDgbF/P+JCwslpQum5EYaMdwczgDFcdA/uE52hd9/Yh0l94r40xNsvRQnCi5EDKi3FwASxFAk/k7gC9IWiv4G0N1S+rJhpw2Q8kQilHP66bIzNfMqqJ1+yNbd1qKoQD/+vsiKjhsWlfPRKdwB/SccZfib8zr2g5iTCgKMGK4WQg0ctoVglfG6zsc08Kk8QI/7fXt1OO/ukXw18518iDVR+Ze6PSaw7QRihpf2W8NUI+qonIdDb1w5n64rBJ3XlxVWmBGUfhQLZemerw85RhAvlo5dsCA2v3Wj2dRS3+mUXoSaCmCyWhZE1
 km3Ucs+/
 igrC5a5iHOxgW5SuYjHGqY747b4S2go/Q9GexQfbUoniK63e7/viJaXkPKDgNT+Nd3lt2acNPST1FoKXbzPwHBgyK1eOP6wIfPnNTOze1n86JzNgze28s1bVV03/V6OZIM0diQj8wC397SI6AiDf0aY8xbk279sZx8eEgkO4/Ys2Y5i7xO5kMzCSnCllpTKV/HmOEVtFqMKyBX25fp3VH9AAsuNFa4p2428Zr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the hardcoded if/else chain of test_bit() calls and string
literals in defrag_show() with a loop over defrag_flags[] and
defrag_mode_strings[] arrays introduced in the previous commit.

This makes defrag_show() consistent with defrag_store() and eliminates
the duplicated mode name strings.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 76f2d32428c7f..6993c6d8709dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -455,24 +455,30 @@ static const enum transparent_hugepage_flag defrag_flags[] = {
 static ssize_t defrag_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
 {
-	const char *output;
+	int active = DEFRAG_NEVER;
+	int len = 0;
+	int i;
 
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
-		     &transparent_hugepage_flags))
-		output = "[always] defer defer+madvise madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always [defer] defer+madvise madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always defer [defer+madvise] madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always defer defer+madvise [madvise] never";
-	else
-		output = "always defer defer+madvise madvise [never]";
+	for (i = 0; i < ARRAY_SIZE(defrag_flags); i++) {
+		if (test_bit(defrag_flags[i], &transparent_hugepage_flags)) {
+			active = i;
+			break;
+		}
+	}
 
-	return sysfs_emit(buf, "%s\n", output);
+	for (i = 0; i < ARRAY_SIZE(defrag_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+					     defrag_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+					     defrag_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
+
+	return len;
 }
 
 static ssize_t defrag_store(struct kobject *kobj,

-- 
2.52.0


