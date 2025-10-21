Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C69CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E42B8E0003; Tue, 21 Oct 2025 07:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394F68E0002; Tue, 21 Oct 2025 07:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2840A8E0003; Tue, 21 Oct 2025 07:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3218E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:00:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B39F81DFE6F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:00:12 +0000 (UTC)
X-FDA: 84021827064.01.B23156E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id CC43DC0007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:00:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VdQqBiPh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of william.kucharski@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=william.kucharski@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761044410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NMjd1uZ/QscBSveIYXes2vB4VJaUBjLGGLvhK0f1mz0=;
	b=m5/gXcl9fFJuXSmD9JZkufa6dIaZ9/O8iSoFDW6MaeEkT0bdJT8iHu5HJXM71nO2CT8DRP
	HqxIBOqCs5MJk7UkJGm1AB6EFI/9fGkvhmgAlihsj1/FOSqg3hwsmhc/tHcAm81u1lh6G4
	vZcR/kJBjggnuj+UROqYZ/3QZmWjSyE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761044410; a=rsa-sha256;
	cv=none;
	b=bDLUXUtfuDPmVc7+sIlGKyQ5o6/uaPhlCyC2tHujM4PRMk7774lmR9H5W0md3W+4pYsLBW
	DEIm9Trjjlzb1QR8iVMoIHMkv7VuLb5JnEI3z0cJ7Z0QMSs+gbIDiqbMTngZCwvgO86jEk
	jPDaxNaVCKgf9GkE5MO59NkNuBR4RjI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VdQqBiPh;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of william.kucharski@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=william.kucharski@oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uWIf005851;
	Tue, 21 Oct 2025 11:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=NMjd1uZ/QscBSveIYXes2vB4VJaUB
	jLGGLvhK0f1mz0=; b=VdQqBiPhpaNd90JEgDKdpo3BejXa27bZ/U1yD4wx+YtHQ
	3SAe4TVT0ANRjNANmMGiHjDXgCU95rADrALLs2nErJd9KyWwbMRVr9G+iBMk3Bn+
	++7nfnNQpHBswPvQfnYuXiaLK3+Q0yt0kZrGNvDw6M8b7QMtLwFhc0kRZWGLGneI
	m+TvLZmxJVK2zPM10vYI6qk8woo91d9mG+fHIqVShO8I/0k9ElZV7Y62K9lg8cZv
	r52VH7MtBB843Rz1OgA7xhji4b2Rk59/scBz8bsGAZihMlJiePyz9DHesA3qKUbs
	iv7mHgnOIVlXfO4Dadjmu3NhfHrfPIlen6JMHieiA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypvr8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 11:00:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LA0uPH004361;
	Tue, 21 Oct 2025 11:00:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbyf7d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 11:00:06 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59LB05Ff004240;
	Tue, 21 Oct 2025 11:00:05 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49v1bbyf6e-1;
	Tue, 21 Oct 2025 11:00:05 +0000
From: William Kucharski <william.kucharski@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: william.kucharski@oracle.com
Subject: [PATCH] mm: Remove reference to destructor in comment in calculate_sizes()
Date: Tue, 21 Oct 2025 05:00:04 -0600
Message-ID: <20251021110004.2209008-1-william.kucharski@oracle.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510210086
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXwGhD0rOetU5l
 g8FyW9/hkUQF6B1TgUPBGixhzLUhRplc/kRzvYZZksPrX9Mo2Sr572zbtbNb6vfrFbFVWhRH2EJ
 ZmaxUdyLuFm9Nm3d/lHVHFsTqR+AodJeWqu8i3XWQyCqydOcCmNVSOqEykGPg8eY9dGh6ryC6Tz
 6bq/SN0J83Whu+VzATlMSDWJmu/8piWfVDXtGH7PpORvoPNkPT3dEqzC+rNErwAfXJNAkQkGbDj
 Q/rEEv3Wx/nT5+FSgnQvW7lxPatrV+DbWJQWeXmDnDtynRZZBBzANEblxzMZwGs5QxN+jmzMUgo
 xN2XfasTrfeMFMQcJlqxZZS94kFYVhzMIG8p48gBbaEKwqy9/d7WV5Ku9yOrt4OC3GqQYf0wHNP
 5cPsxCtZnOObCu6754GMS+Tl6SzWIQ==
X-Proofpoint-GUID: dFPMblz8YaKD2z-LSrm_GqZZgoWl08hP
X-Authority-Analysis: v=2.4 cv=Db8aa/tW c=1 sm=1 tr=0 ts=68f767b7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=U8uE9Md__1QdxW6YSgIA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: dFPMblz8YaKD2z-LSrm_GqZZgoWl08hP
X-Rspam-User: 
X-Rspamd-Queue-Id: CC43DC0007
X-Rspamd-Server: rspam02
X-Stat-Signature: m1heg9wc9aysedb8nwgm4td1ug53s4or
X-HE-Tag: 1761044410-515525
X-HE-Meta: U2FsdGVkX1/o1lyuyFrEqZZKwskxfOwNh5gJGKY+Q+Jq1VRSCzdwrrtR8lFKb5SNg49WBc5Pq8NnsEIBmXBlDbeSCoFpjpmT/PETGk3SoCAwK5PPgCDB0diwXlEPI4/kweXRwIs2mxhLgDg7Qta+AQvlWPN72c7hzUj7H4HZUTx+eWFS/JK2VEXrlK8y74JX31LEWgwtA2XV7wdr4p/3CE7anYrHUZz+3jllTnBwu44GPhS1f1I0NnmILEodY8RJLv/wOWo52UhX7ear4Vj0MxdCnGLVjYu0Fof8Fu6SMcmwF7Z1CjK2ZBgOD2Pd+9eS6fv93hLQhzsM4E4RkcmvZbgh7Z9PjK5c8sIBJK6fURVq4iRck7xxdRtr2pOiPIK0SrvO/LnhBqxWcx+lgammc9MpS+vrS09RcSTAA13FqH0WhUgLJWWdiCjyj5miKpiUqVXNqVsp0baEUrzoU4ojaNh06ai25RD3wDi9sFYv2a7EGJCjAdlknn+XafCsGIdl3f7K6H2uIasZKxKK58YqLdqaDaqJ7UDPcqOpMfk/NZi4ejEATrFa5tEOUU99GRXp6yUPPrZZ9eb8+dygSErU3UybK8KlCu3ky/TQNItZmWpc1Z2BtHe58RdQ+VWOJeiaAXabVYe8fEhzAHDIE00AxF+KCw9iXis7kgMZR15Z5TcRXrnj4JV6ToCI4NiGXXKh45bbY9TqKsLmRoE41ODYAYEUm0SqqSmmFMyBAIMPkae9INcAdz2tSxW0+vSDDmAK4tKNOs8Nklh9hBRxZMAgH7Z6uBI/NeLNY+zRKkC0bi4/MYee6y1CsRYg4pVhFvMblir5MVu4/NHKjyK1DKpHf5iPxE2IUM1+dU16DSBcJ017zCGeh2z+ZUScCTLL7gznN7Z/DM1tcSWjgkj97eCWUQNVklsKpyi1xdowW0U9rnEPnzK2mlsok6Mq8NtnPcIb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit that removed support for destructors from kmem_cache_alloc()
never removed the comment regarding destructors in the explanation
of the possible relocation of the free pointer in calculate_sizes().

Fixes: 20c2df83d25c ("mm: Remove slab destructors from kmem_cache_create().")
Signed-off-by: William Kucharski <william.kucharski@oracle.com>
---
 mm/slub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a8fcc7e6f25a..09cbbe923a05 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7875,11 +7875,11 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 		 * permitted to overwrite the first word of the object on
 		 * kmem_cache_free.
 		 *
-		 * This is the case if we do RCU, have a constructor or
-		 * destructor, are poisoning the objects, or are
-		 * redzoning an object smaller than sizeof(void *) or are
-		 * redzoning an object with slub_debug_orig_size() enabled,
-		 * in which case the right redzone may be extended.
+		 * This is the case if we do RCU, have a constructor, are
+		 * poisoning the objects, or are redzoning an object smaller
+		 * than sizeof(void *) or are redzoning an object with
+		 * slub_debug_orig_size() enabled, in which case the right
+		 * redzone may be extended.
 		 *
 		 * The assumption that s->offset >= s->inuse means free
 		 * pointer is outside of the object is used in the
-- 
2.51.0


