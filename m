Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530E4606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 05:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1436B00EF; Sat, 14 Nov 2026 00:55:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269516B05B0; Sat, 14 Nov 2026 00:55:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17FEE6B05B3; Sat, 14 Nov 2026 00:55:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC1326B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:55:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6F15C0368
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:55:14 +0000 (UTC)
X-FDA: 85432661748.08.C87699C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 03DD340004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:55:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794635712;
	b=2eszlz5P0PdF1EOwhl5AQJtHTNN2cBRk+jso4ZFqfVqyUQXSqht/A21aCFkWw/YTNNO3NU
	yLBc11+uEv5bdTuALYVL31Mjyms41ylqaR8A1/iI9MLCiaFOAJlITS4Cz0N9r1jJEUxIqc
	zEdRhmTy1/V0ZNzrBDnov43aZWy8VGQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794635712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=zGy1vdLayt8lRYKcl1ZixKiv5rYlTz4T8Pjmfj56gUQ=;
	b=NqNkdoIdeIIYIWZjnOIJPlRCn9Nad4Pql1pQ4S4W6Lt5omzgMfRA02vsv3mdPu9an4Ucjw
	leAkHhZcfEjpuYt0ni7cAM+nU2i1wVNyL/UAjxeGDsL4UNoEDPwT04kchPuwgbDkE+t5FH
	39YmXc+XhcwqKXDo+XrOXsxMkDiN9iU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
X-UUID: eec1f348dfef11f19a56ed5b684f684d-20261114
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3275e801-7e8f-49bc-b2a9-4c4c6dff9e31,IP:10,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.19,REQID:3275e801-7e8f-49bc-b2a9-4c4c6dff9e31,IP:10,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:7db8b62,CLOUDID:c028a24d930a5a1200e4ebd263531e5a,BulkI
	D:261114135506IBV1DO4P,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99|100|101|118,EDM:1|-100,IP:-2,URL:0,File:nil,RT
	:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP
	:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_AEC
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: eec1f348dfef11f19a56ed5b684f684d-20261114
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 371179060; Sat, 14 Nov 2026 13:55:02 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] Docs/mm/damon/design: replace "same to" with "same as"
Date: Sat, 14 Nov 2026 13:54:36 +0800
Message-ID: <20261114055436.5546-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03DD340004
X-Rspamd-Server: rspam12
X-Stat-Signature: 1t6jeczwtb36tbkjx9ecyjqbpbghzuma
X-Rspam-User:
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794635711-998403
X-HE-Meta: U2FsdGVkX18KThllVoAeUhzfPcovNbs2GVpX3LeDT+rGRbXQqDcnXn92rwgKh9LtxNtN2Axc44pAcxvepDax7uEL6kND0gPhfjHJR4YS/eTaBsSxoaNrU0ycSbAcS8ymUXGv0U2cTnxvlZXWCOTqZpASwPSFuwVsaFlmuySHNgCYOWNZIAaDhuNXArZX9cgrIqiJwEjkl2KG6rraz0l1+E0tvQpAVbBXbHkLC507BLwlyBbPO6+W7zS/M2bn3UUQkVVjGiIAZYCjiDKSl6j5pao+49q3lhPzqyBc4SdgxoZYeO+jjaPDxNgbfG8A691mzo0jZMnqsVa5x8fkED3rAr3Cf4Iy/Zyt3nBF5MfexZNzMB8g59VbS2d6LX+6UG6+hnGDmdkCgFdcEfbShtId1VS5HIrVG5KDssj/nWkCwU8Jg337U4B/oPtt5QzA5VNESTqVvid85sa8GUGS+sqAjN2iDmsXjK/RR9ZW+xrobwNLkuyrTf1X9J1Q9NRlpiuGlBvfe0YjHq0w3zQjiicHfC7IlzkeG4JpgsrkKivlvvcMYEzywM5buzPuh3RaD4Bu15lpuCQW46qwMeC+jbqlADUCG9kr8V51qn3GtTYxzqY3C7jJhg/EeyhFqHGhbdAyAocV5U8YaH442v/q6ftQzfFFQzon54OU0A3lWtSS+2xs949N+4+NRADKoKrOP9FuKEf4DdmSuk2sdTVUmWjOBwXoeW8BD1zSZAtr3821LyzJqGThvGCCOtw8UtN0ZpM/0Gc5mVlCdwmpeNvLefv2BSkeqpjQjHExPanGzb0aGC3GwW0Bj724Ks1ALoUSsxIfiJPxuo2XcFYl2SCPm3+4BsQ0z9xvHTsIItIdm1bZxxD4yrcsspytoJ8uFP9fEJpoX1rONd5/9dl/JIZ4kT7e9rYpVND0hS8dtx/uTmsOrYEWcX3WmgjdRypqZb7wGMOZZJ0aKT0kObKzZbTWdPX
 5BTzZck2
 ojclWka29DHCznEBK/Fah/vDNkkO/WTqi+s0LYBlc1g0E6FDoF5n96wtfHYjSgnDioNIZjNurI35Xm0tNymYPk9ZmwM5wxHBjf0n7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"same to" is not idiomatic; it should be "the same as" or "same as".
This doc has six such usages.  Fix all of them at once for consistency.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 Documentation/mm/damon/design.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index b676be697158..6284b9005443 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -292,17 +292,17 @@ DAMON :ref:`context <damon_design_execution_model_and_data_structures>`.  The
 registration is made by specifying a probe per attribute.  Each of the probes
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
-same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently below filter types are supported.
+the same as :ref:`DAMOS filters <damon_design_damos_filters>` except the
+supported filter types.  Currently below filter types are supported.
 
-- ``anon``: Same to that for DAMOS filters.
-- ``memcg``: Same to that for DAMOS filters.
+- ``anon``: Same as that for DAMOS filters.
+- ``memcg``: Same as that for DAMOS filters.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
-- ``active``: Same to that for DAMOS filters.
+- ``active``: Same as that for DAMOS filters.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -706,7 +706,7 @@ There are two such tuning algorithms that users can select as they need.
 The goal can be specified with six parameters, namely ``target_metric``,
 ``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
 auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
-``target_metric`` be same to ``target_value``.
+``target_metric`` be the same as ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   have interest in for the value.  User space main workload's latency or
@@ -736,7 +736,7 @@ auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
 
 ``complement`` is a boolean parameter that determines whether to use
 complemented value of the target metric.  For example, if ``complement`` is set
-and target metric is ``active_mem_bp``, it is effectively same to
+and target metric is ``active_mem_bp``, it is effectively the same as
 ``inactive_mem_bp``.  ``complement`` is no-op when the target metric type is
 ``user_input``.  For the metric type, the user should be able to emit
 complemented metric values on their own.
-- 
2.43.0


