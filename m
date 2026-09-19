Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2276BC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0126B00B1; Fri, 18 Sep 2026 20:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97516B00B2; Fri, 18 Sep 2026 20:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADC36B00B3; Fri, 18 Sep 2026 20:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8703A6B00B1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFF551A0151
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:13 +0000 (UTC)
X-FDA: 85228617306.27.447D012
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0C92B180006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f pvhKEO";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=p0fdNOtV;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777511;
	b=UqMr3mDwOtIxpEq9esZw0Cg/JytaenhY2pwvAKtLMV9H6HkVQZfg9Oqn28qBued34w+gQI
	lSMZwFWlM87gW0npyoR90qwAVxKSV23y1/yn9VWnRS0xWmSyvenYstmPLMBTWdpxG/93wZ
	P6HLjQqymw5N/LLA5wlj80xdrNHQ7Ac=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f pvhKEO";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=p0fdNOtV;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2EjQwNXVZ3kBO5GV05H9uox01LTGQvy8R6+J7n+hI4=;
	b=wYmfewdtxv8lEmUTy+spiqivE8bm1UmbfCxwpAuhj204LGQ99wio8u31rVqbJxOHMid95Q
	6R/Ts+Td6dtRKjyZ590xh8LQnKyvnGWWvvDVGVbZonzCtaEb8c7TXlY7rG5OqYQ2bX1iNR
	uwE5L4sCZ393SAq4tHE+AyUw6qqaxl0=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 8DEA0EC020B;
	Fri, 18 Sep 2026 20:25:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Fri, 18 Sep 2026 20:25:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777510; x=
	1789863910; bh=b2EjQwNXVZ3kBO5GV05H9uox01LTGQvy8R6+J7n+hI4=; b=f
	pvhKEOsnferr1TcELH0ZjHcmCKDsp7M8cEp+bv8VH9TaXB4Q6Tj9YXYl1dszTn+7
	rxHRsHxJ8fNyPWLxwLum+AqjSh3tgoJrgTVzEIAykBkoVGaailLTL8ygdCXx/UZ7
	BN51HOu5z68vqOQkpwRaCR0j3hORXzfVbVWEPj0eupXkDpLy6NeouvFmLzqrbD0r
	hFtzLQwSfxyHYFptCfkkTOAmm6tKDUF0tPzH1kbIJflo5yuOzMds+U6yOp0+xSGU
	dLdOtF+ICdTZ6uV2QSBTH8i5IbCjwL+BSEoXeUDNDGngrlp7+/VJ9iFsXw3tHGB+
	GGjDuIj1IQBVnDXxx7e6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777510; x=1789863910; bh=b
	2EjQwNXVZ3kBO5GV05H9uox01LTGQvy8R6+J7n+hI4=; b=p0fdNOtVkteZenxx4
	RX5+fgb+XldF8DelrvXyps4ZtW4VieNLSFaGzQvs6PLCvkzMu77mx2PjWDDcsrTX
	zTIdHZm14LkhWgQDeXtAScOkJ8gmwKyTazcBxOIT7Z6k+522EbuKcoNDmmgzcxQ2
	nkvATOnpkaEQc8rJmfwMXbcdXWnYvLppXcND83MquDgU0N43HiT+PDoD0NdU3hwe
	a0cUihwsDoYmaeUnGEFJPh8L23idDawphD+TsrO2Xj3UdeQlCfv0RgJPFK3DtOsB
	pEUCFfqoiqdj4BYrfPwrADQkJTtEgqnFDz5lZH4D3CpeWDRxnD4+13f7o5A48oEW
	kmZIQ==
X-ME-Sender: <xms:ZtatalzCdBtIsRjWJz0c9LbPBF0xsMoAgljQ17-F_TOPXXbEqQTnkw>
    <xme:ZtatatoBavb4oNUryslmtNHmV73wWTx9Qt3A34eOkdnDafSfXBw-plFQ7fEgDgyZT
    IONsiQsIG4QIB-bQoaTa2tirB8UJXNwPckTLSaaouHBGO8XCgTMN0b4>
X-ME-Received: <xmr:Ztatahj-iBRp3UURbK4C203UHZlNlmhrHAif3BwDRV9pmuPJRsF4jaqli6w>
X-ME-Proxy-Cause: dmFkZTFyC+XeKYnZ766rqTYe4SsoatN0doBd7ADemiperjFlmE10ggdkgYpZeWmNOU4aBc
    lm02WEvCO2QGG+A0SGXMzCjVWjDSVCQ5WJ/xmSMbLZJLqVjt5aEnrGd0hUbHPJ/ejcqjFa
    xrmYY/YNxh9EpvRrTjNMqslNp6oZ1XKAjj0b9YUD/U+Umt4HJhNRFStrIx7jR3Gf+CAD8k
    /TwEvtSve0+WgA7utVqBt9LeXDUSIUkf7dn/1M9JWIyORT8Kp2cNKrwYutOzK/Z35sBm5S
    qWNICJAq9yYROUOkEgx1cQSYtjkPP2DMZwKGXS3JxTiE+xMdBmJUepOSBHs3/DvnVTIME9
    uYZjolEHn+PrRoQ3gunGcY531LB4NKn1ulXhKnB5hZbu6jfSqL52hNw5Bm8YaKVHImFX6k
    rbx7VgDsl19eZrOCN4Cwjvh91Nb4WjXuHc7NwO7T5rJVZIe46Rh4+fKpySSYCzxgBSy4u6
    hkX2g1jivopcIqWvY9jGMPyiTIi+P8huS8YKqMencvrUzsfbh56N9KA4/STLlqbRNMS9O7
    GoFIdDj9oeN/IqIfInOTzomBVdLdnoyOgH5gDMC1pG74PfzGdZnyTT0fAO0UEfFGhUWMVO
    AjI46RulfUP6t4T5EQdNms9qaQ2CbM94ZQnCAjNGmWd3cMbGrifAEvJQeQVA
X-ME-Proxy: <xmx:ZtatavXxG9KT6CclOUyFTK41b1OPUMLWmJVm2vvwVQdPTWL4_84ADg>
    <xmx:ZtatapGM9V7QMmL6uYy9I5-6KfGnwxBHIASTYegJwII8I39dvyEokA>
    <xmx:Ztatav9-kqIEbmfgTUW8xyI3qxYe23ZqOks-jVKH0kavG-PcycFhFg>
    <xmx:Ztatap3Wfq_MAgA07qSw0pKCysWF8Sk4SM9wqhPS_20wKTY8591OXA>
    <xmx:Ztataqb32XYtxGAeLpEYe9bw6jJrpauFBoZjIuIN0h4CJ15oztq8Y9qH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:09 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 06/19] selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
Date: Sat, 19 Sep 2026 01:24:36 +0100
Message-ID: <20260919002451.496763-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C92B180006
X-Stat-Signature: o98xti5em6c6z9fs5zyjsj88dngs4d3j
X-HE-Tag: 1789777510-932073
X-HE-Meta: U2FsdGVkX1+GduZFiqKHMcvhGnmBJ3WxQ8cQqEP/7IXK7PKg+lDs1t7s98eKSyj198yod5Qx39yFHUPxKb34uDCFmYwL0rsoJhheD2SjXZ2NU9oUpQy+yzbwS8bIVFnrMhe02Tat26llCXnHhp7Oq9VCyOzro65u6GWVQQDltx7C5ib/4rh9KusFliqTb/Gzzw0ZVYkBp9W9l7bPfxPHxccd9XC2UrsHKS8gQF2GH7ogHgEIz/ZjDBa/8v16+gPyybHvJ+hobxVeMrNADom9bGWC2gsP5k87AxRQhQE5kKuv7y7IArg4Cj4tbY73LfBhKiXMdlkbIAMtSYDZuFAJpvfvf12fkrUQV4NX6Q8qng8uIFdKwBbPa/C4Eumqnia9N+TxWECBlQvz58sgyk9n8sZPf6pWKL26JQq9YFcPbO1oa8XyVA9ckbbo4t8WLRZ4m39BVfut7mJOUvR43cSU02Pv6X5cUmmeGgGTkITfAOufw9Z/rKOC+o0LsIVx3i8TilNdUN46LRNkvsyzYTzM06HhuaNTGbbH+KltZUVY05uddxU65q6ce5Q5nPtncFxqc5GPvxKrFtdM39t3Rx6wao80L7wA0eFJKID5NMKJ1ldBfbn9dhXVPuN7xgwIyrZvX+JGrmKQccGH0deSCTNXave4fjIscZh+THpokCKCPYHD2ORX2DhFvRpaiIr6rFXiD2Sc8WzCiXYMgYWIVFt3evYZswE+ow6KKUhbE21LCJ/2/Ye8YvfEKX2Yq0zslJfFN9J3cIQ2BjX3zoUlNddZc8MhQKCAHjvFq51e1lyWHDr88QXqiCNP/1Y8G+9BCbuuchlEHy99yNnHIzT7Uy8fEjshN5DtGCl0YufutfK2LmNyJzM5++Y27ggMqJb1tgGSqeJi6eDPHL8zfUTr7TQi8DNnGgilz+BlJ71gxScRqk5v5xmNUNV/DEZDc78tpJPdXXSVJNcLQQ5re3U29yO
 ObyES4Oa
 16RauScuJgbJMjWsdyqcA4P1W13HpMWzsjWYyzTZ0pwtjoyT4Ru03oxfiCKSl6sDP257PB5q0kka0z93SpX9GnsT3k+VOZpg0vmEuMaqdgykORr3+ezrXfk/UQmSvsJslhVJQeQ8A/JaRONDyBppkv4VyVHA8DtFJ88VcZkDtPoYV0PJmKXXhHil0yhiTxVUbhJV6FylfAgaaNtLnNmUUOpOfyX8Wmn8H3Bf3YXPwSkmtC0BepiC++/ZRm8c1q1SLyPXIVoh1qcXITagK/F8WH7DUjGs4AYWe9n6vV7m7+WzVru1MR58yVNux03YSBFwqBGfyRs1MbEqk0Z55aq5Ps40c12koko6wIgzdqB2V8YDjPe+d3jwxdSCP/n93TxzhMJOmq7thz57n/goS4q5r9nvs8JmoY6Vt7HkVgaJg249e1UAl7d2HOvrVK+RS019AH8x0mPj5uTnHPJsh0GPkaN4tWjPPR3N9qp1d7pldUA1md13iDSA9Bv2LyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

__madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
It clears the global controls only, which is no longer enough.  A per-order
control overrides them, and -s, which makes the cases fault in folios of
one order, leaves that order's control at "always".  khugepaged then
collapses the very range the case is working on, and the case fails on a
collapse that was interfered with rather than refused.

Clear the per-order controls too.  MADV_COLLAPSE does not consult them:
anon never did, and shmem stopped with "mm: shmem: ignore sysfs configs
for shmem forced collapse".

Fixes: b7f16963efe7 ("mm/khugepaged: run khugepaged for all orders")
Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 13a2a47ab110..e013eebc7136 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -538,8 +538,8 @@ static bool is_anon(struct mem_ops *ops)
 static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 			       struct mem_ops *ops, bool expect)
 {
-	int ret;
 	struct thp_settings settings = *thp_current_settings();
+	int ret, i;
 
 	ksft_print_msg("%s...", msg);
 
@@ -555,6 +555,10 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 	 */
 	settings.thp_enabled = THP_NEVER;
 	settings.shmem_enabled = SHMEM_NEVER;
+	for (i = 0; i < NR_ORDERS; i++) {
+		settings.hugepages[i].enabled = THP_NEVER;
+		settings.shmem_hugepages[i].enabled = SHMEM_NEVER;
+	}
 	thp_push_settings(&settings);
 
 	/* Clear VM_NOHUGEPAGE */
-- 
2.54.0


