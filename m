Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F624F43832
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5821C6B0092; Wed, 15 Apr 2026 11:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5330E6B0093; Wed, 15 Apr 2026 11:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3AC6B0095; Wed, 15 Apr 2026 11:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 167276B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:01:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CAC81B7FAC
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:01:35 +0000 (UTC)
X-FDA: 84661104150.01.2F9F8FA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1375B10001F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:01:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XDb05Qxk;
	spf=pass (imf14.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776265293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBRR1F60wTYJWiacYJmTk6Dc6L5tjtST2WlW/uldChM=;
	b=GAnUc7838v/6AGnNzAIiY7DiogN/49O43Ef62buWzYG35+IAwyNHlp9ArA+/3NGp47IWs/
	ZfCe1tzKZeFkRNLBJGlGac/CJQR0+tnQN//KHVhFts0ennkGDZtCu0X4FNGwuyWdqRJK9m
	b378fcSMoDelZFf/KHN0hsEzsCRmfaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776265293; a=rsa-sha256;
	cv=none;
	b=cnfrex1CMna/dIcqn+FfhqMIXRuq78+WEk17RmFXB7tB8TgHjEsMlthuom5/EzA5TndY7W
	+RD+ywyDbfDroEJX0Kipx1aiTgdf1umJCkQmcwUKEyNv26FvQ/w7rIoBUPJNVv759sdn9T
	lSUWBJqLTRLr/EcvJ6k/6B2MTmXAWVw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XDb05Qxk;
	spf=pass (imf14.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F53Crd1805234;
	Wed, 15 Apr 2026 15:01:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=yBRR1F60wTYJWiacY
	JmTk6Dc6L5tjtST2WlW/uldChM=; b=XDb05QxkZ6GZqYlqvRMAPLtjO6MY4FyOx
	LVHZ4pQ6LdT2bCK9v6ONyhYgCIC4ymL1fs0InBNtIPx1PMnFqJh/eTjuEZnHFtAX
	7wfOW7y1QjFauUYXkzH3KsmSuPSeam+m6+vKZJ8ACblploG216B6Id3QKhQLcAL5
	cUJkJ6xVW+peHdNza52YhDxnR+vLt+BGQAuq0a9z26YFFHchhGSXhEfkXx6LqNpv
	4k9ZoMgN93+hG6NX/6tU9lVg7rmNmDZ8RzSJWAAmk+Flc3TkvJF9bn2wvsGBrGv6
	1o5t4t9T6x4vnpZNt3SL2oZiWi8CtwFp7LGUCwF2ErKW3y5lfdnTg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89k86eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 15:01:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63FDNr3t003305;
	Wed, 15 Apr 2026 15:01:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4djbh90aug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 15:01:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63FF1PSH50463190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 15:01:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D0C72004B;
	Wed, 15 Apr 2026 15:01:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C12520043;
	Wed, 15 Apr 2026 15:01:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Apr 2026 15:01:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id DC23CE081F; Wed, 15 Apr 2026 17:01:24 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] s390/mm: Allow lazy MMU mode disabling
Date: Wed, 15 Apr 2026 17:01:24 +0200
Message-ID: <24d843c5568a8b591cbbe16eca092e7f45d18cf5.1776264097.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776264097.git.agordeev@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l2dlRjD_8C7XYgEgk06AnfNamAoit9K8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDEzNyBTYWx0ZWRfX3dGuZkUwyxFs
 P9qcjJOqT5qP/DG5iIzm18JRHriX4VUVAT4dPIKNnaDZ+8gFdqHNbVLijuJOM4/ey/6H7Z/6SLu
 p4k9Yao+Bl1lQa8vQFylg9QXm+6QgrIbpe38xkcEvgKCHrCwvSEhyJMEMN2+2k7juclN3UhQ0KY
 XyZna1THNUqLSVUv0sB8wZ+AtoaY4KdPBYaI60kkg4sTmdzm/RFBMYv1rCbvjTPqOUEbUUvFwOj
 PmJRF8yvvY7ESYlFDNh0FOJsF6fWnWc8GaENhk68h3y+wxEtgwTlmxtgnrzNVbKBFRxaRu6h7no
 UCm43P6TTkFdvAjnNV75HGtplBjQw1PCGYzistOAtZdxisG+dltFshROgg4NWjBTFfqYoL59iZq
 1w0iaK9PPrmpNccuMchCAhVooA1kS6mPqtKU/SugeWpG/6iYdbG+DRLjaiFDcHGfNKR8Cm3c+YH
 jT27eHk0jfso9Y/tjpA==
X-Proofpoint-ORIG-GUID: l2dlRjD_8C7XYgEgk06AnfNamAoit9K8
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69dfa849 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=bNGpEJzzvkTflYE8CzsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150137
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1375B10001F
X-Stat-Signature: c8ttbkowzozttgker9wkix6r39cg8zh7
X-Rspam-User: 
X-HE-Tag: 1776265292-343101
X-HE-Meta: U2FsdGVkX1/xGWKhhVNiqvME+rjeL8gVvguUiT6MwFAcTUsIfifGsHOfBM6ZjxAORL1pPfnYLtvuZnQ6oT53gXVLW6mCOo25GbMN281p53dKODBGI1IlNL1/Yg+iwwLF4207AImEjA6L1dUngIqq/44sWUR9UDG3TYIJwIPfJpRN6HnHSnfddmYoTLo3H94jdCSjG5pk8QQE5ossyTzL/RVeTT8NVtUhWvSUWUY2/1ImHqkIC+PFgZXOP5KAjhfqeLr8YVuPl393ei7CMcD6zd74XX02cXfThTSFTd3Wo5fRhPSm1Z6XjqjsJYAwMAd3DLAGpb3igZkb/JV+pO6JQRQ3B1qbY9u4c5PIAspuCaC37iVGKicDLp7cS6csgy/jhm86Do0Z2GCuktXuijtL51aCfKkTHFP2fB+aAabpP7O7LQOBEMeAjfZvOJF6c4Eo/SOv11w+PgqmWueKIfjveWsI54JiJlwhfq9FbUYxVeLV+QcHkOxed7qeRkgQrbPMobZeaAMvEaRDkenRUoKfaOnbN4iCNP5/MvUz9IqddWj1dc0PWbmyHAfWIvTXnmDzGYqNO2KD+ZVfGg47FwjI+nDa6368XMQCxTTX8va6iMlWObbSUZ02R7LVlgxAgOzaOYxiMa2hOt6s4NZNYlLdCv9XoBNsdBYC6zty2Cq9hg2ulMdB8qGRS8p60GLIYYBrP2/8tT9hIi4Syuin7+i5ED7zssCItUtcD7jCz/WrEWJ8XQOVhGP6T9kA8ZfTz7965dDUKmLJitPuy0/Ae/Lka4MpPmgRmS7EgDpNP+3NAc3satsd+8hic7UDshS+15aiOO0P/WpsK4tAyRrrSZn3YyWWmFVH28Z3hPZIj80PTVaBRJU5R2NTDwuefm9Fqf1aFdqvJP85s8Fzi6Qwcag1UHcgJ093tS4QbqcIJvzjLn8JHKew4QrDtniIyDpZHfcHZn4/k71wGP3paNcD2y3
 McZ8PrS2
 0MZsWz/HULiDvBxHkAhuOjaSqwy2uKYMHMV/p9wf2l59ZYRhCTpjZt5vAnMA20Q/4qNLl7P1qw818E4HtuEWCaZO+tmdXc3pjOjm1ZzlG2WBeZiD3VRdl+5GXJdA+n/B97tR8/vBWaAVg3iBL1NCK9naTpzHQN8z83Wg/yMu57XnVCKZ/DuQ41S4J5Qg5Af8mWTbSOTXN5FEBc2rROXfGHaP5qIz7Jr5QcdFIRL96F4N+DZFgw4lw5FkOvNcQ0JoF2H/c9vVm0FDG07vCT2StX/wQOtPTqYcrKokaFC59ncsNrcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inroduce "lazy_mmu" kernel command line parameter
to allow disabling of the lazy MMU mode on boot.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/mm/ipte_batch.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/s390/mm/ipte_batch.c b/arch/s390/mm/ipte_batch.c
index cc4c50347d0f..cd86daeba7ec 100644
--- a/arch/s390/mm/ipte_batch.c
+++ b/arch/s390/mm/ipte_batch.c
@@ -16,6 +16,22 @@ struct ipte_batch {
 };
=20
 static DEFINE_PER_CPU(struct ipte_batch, ipte_range);
+static DEFINE_STATIC_KEY_TRUE_RO(lazy_mmu);
+
+static int __init setup_lazy_mmu(char *str)
+{
+	bool enable;
+
+	if (kstrtobool(str, &enable)) {
+		pr_warn("Failed to setup lazy MMU mode, set to enabled\n");
+	} else if (!enable) {
+		pr_warn("Disabling lazy MMU mode\n");
+		static_key_disable(&lazy_mmu.key);
+	}
+
+	return 0;
+}
+early_param("lazy_mmu", setup_lazy_mmu);
=20
 static int count_contiguous(pte_t *start, pte_t *end, bool *valid)
 {
@@ -169,6 +185,8 @@ void arch_enter_lazy_mmu_mode_for_pte_range(struct mm=
_struct *mm,
 {
 	if (!test_facility(13))
 		return;
+	if (!static_branch_likely(&lazy_mmu))
+		return;
 	enter_ipte_batch(mm, addr, end, pte);
 }
 EXPORT_SYMBOL_IF_KUNIT(arch_enter_lazy_mmu_mode_for_pte_range);
@@ -177,6 +195,8 @@ void arch_leave_lazy_mmu_mode(void)
 {
 	if (!test_facility(13))
 		return;
+	if (!static_branch_likely(&lazy_mmu))
+		return;
 	leave_ipte_batch();
 }
 EXPORT_SYMBOL_IF_KUNIT(arch_leave_lazy_mmu_mode);
@@ -185,6 +205,8 @@ void arch_flush_lazy_mmu_mode(void)
 {
 	if (!test_facility(13))
 		return;
+	if (!static_branch_likely(&lazy_mmu))
+		return;
 	flush_lazy_mmu_mode();
 }
 EXPORT_SYMBOL_IF_KUNIT(arch_flush_lazy_mmu_mode);
--=20
2.51.0


