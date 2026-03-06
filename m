Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BC9FCB61F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620826B00B7; Fri,  6 Mar 2026 11:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6EE6B00B9; Fri,  6 Mar 2026 11:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB516B00B7; Fri,  6 Mar 2026 11:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3038B6B00B8
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:17:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDF711A060D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:17:00 +0000 (UTC)
X-FDA: 84516142200.12.3172C0F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79133C000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:16:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lm5JKiuQ;
	spf=pass (imf10.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtoi6WxsFBpQPnnI4jiQWys6zQsSpfXOxB+meQZaJfo=;
	b=KTP5uTw1YPPRpoWaHWwi8hdvC8UDuw6tggJJXhSt6GJmFfmfyNcZugusE+XpdRyQM76PdY
	nCuoSUx36kVOBJo4CB0Mu1BfrzQ6kpGKdE0bPPnT+c4j+JK7EoGghZ6tNIePSrRYdPl/iX
	bt28JuFLGKf3TZNZvpqAmO1vXwR3G3c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lm5JKiuQ;
	spf=pass (imf10.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813818; a=rsa-sha256;
	cv=none;
	b=1XsjWkjSbtoKbOjh1UOOF8wHOwEn9svtaYSv+pgc8EdvdttJDuqqu5OifCwa3QnFgLd1ui
	DMfo7g3kqATXhZVT1r+eJg0aM0HZYA29WM4pN9Oq0A+lwjrht2HXKRguHtVqNBZhcwNyKm
	+HCLiDgjD3LiBVqoUh8AMJar97wGq24=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6269G17K1965535;
	Fri, 6 Mar 2026 16:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dtoi6WxsFBpQPnnI4
	jiQWys6zQsSpfXOxB+meQZaJfo=; b=lm5JKiuQRboh8NPEoa3HrlDaGlOELi+eH
	9+Uvph+D6qPDcdUEwdE2ADbINDvXTdM008wSy4JfujZPtygbO8bTPFiw6h4TbMOl
	tc3feKlFUuCLbZ/dYogG11t+99aonAk7p2zRlXQNEay6sMex2Gy17u0UZz1YgOJi
	QbSemDDQY5yCpd6gbge2aAiN/KMZsSK5GcymchWZ1bcmO+c5KLv3NozUUvkeaWRj
	60cMMxmkY6zFB/LX0tCBY3FmtzPgB/4grL2ww5AShrOs9Ow4BtO6vYsKiOyQ8awB
	/ArqGnsvZ/jt67qI0cXHdJgFdaCfGh8Q2IpEfEd47M8dGSLSm44Nw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksk48udg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 16:16:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 626CPjMo003210;
	Fri, 6 Mar 2026 16:16:37 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmb2ygp11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 16:16:37 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 626GGXFg31195482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Mar 2026 16:16:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6ADEC2004B;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 347D820043;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 19938E078A; Fri, 06 Mar 2026 17:16:33 +0100 (CET)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org
Subject: [PATCH v2 2/4] s390/pgtable: Use set_pmd_bit() to invalidate PMD entry
Date: Fri,  6 Mar 2026 17:16:31 +0100
Message-ID: <a9248694a38cc898d3f0628f59b8abb57d56a416.1772812343.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1772812343.git.agordeev@linux.ibm.com>
References: <cover.1772812343.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IBq9j_EnUwKftO-EgMlfxi2jZe0HPHem
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDE1MyBTYWx0ZWRfX9vUxORZnUkRh
 6GHxzk5WJbK1mY14Wo9QYa72IqTa1p8g+klas9euEzt2CV0T1C6SPO8kHQ7btajT0vaaAjFoNu1
 CIIzg3yiaOASW74bzhZM0ni6NEgs7332rHmxMfpxt4x+ow1ac8OZNzdm1ysUZ2dfaXOmGjck+A5
 6Dvk3YAo2/+1fmh59BJxr7Rpnil7e1Ot2yqnueAf256Yx7hgZwZEpfEW0GlntPo/MQxbqlkJOrZ
 yo+DeWhJBIbR14xgcyYvRlINetk9UWU8nSRouQVpOIopnAhXw8Yx/EKbEmjTr4UcLzFpz3iVM10
 3kjhOeMAJx4Xq8amjnZMNtOHgKyoO4BzLBjNwOueS5jNjqK4MF7pZr0abZgqWWexUogoYQ7y6z4
 ke8W49kGfdueKR/x+OgsyIBN4h4KVuvJGjFyX3tRCeQssNjJikLj+Zrmf7KPScWqwRrT0uFFdBe
 ME8EUmGDwbmNfjzVwkw==
X-Authority-Analysis: v=2.4 cv=csCWUl4i c=1 sm=1 tr=0 ts=69aafde6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=Wwf5FGOAHR2iKIFYnxsA:9
X-Proofpoint-GUID: IBq9j_EnUwKftO-EgMlfxi2jZe0HPHem
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060153
X-Rspamd-Queue-Id: 79133C000F
X-Stat-Signature: w85gj8n6u7aujbydaaxiahzaom97m4nk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772813818-394141
X-HE-Meta: U2FsdGVkX1+cBPwy/6IBu1psy5HUIFOz30oHlWzE8xzY3jEGQmC8Uq+W2TLdnUWfVSFK8SPl5ts0Asi7/LOkqSo6+bzKqSCZ4WQ1mzJHHgXmVPl2MIgPr+71pyEConESPo9y+JXvJhu2anOerM4QFDm4pyg1FPaYboU2roeHNwrzi0/tkvvb4UnR+xF0DJeYZOcZTNE1e2cHbK0DPxdSOhjTZffITjKxkik9ZhqLd/EmUBYhdhrUUCarPz76vmqkxKCCdD7iuRStUZi9eanFJiTSZnAzjTfX5fD3r2ZvP8bDwWzYXxEUr6upXCPjlKK5Kv0SX2ORCSFoiADCGevObOURgBy2MVhG3htLa5P76i5hyxc76yPyhcVibS0KyHntdvldEsBhusdsy9L0xdubCOZb0g+fnTXoTdrJhdfh4KUZwoZg3H3TO5k645TsIlKN7ODT3X4QkYJB2xGX3ZQVaSjOYc66OxPHPntDHGzij3vs0+IrYEGcR4xPqBoDlIywaP6ioNu3fkRjcJ82C/FLrJ2V7DyAlNNQhUizAKCTJ9um+8VwcMA3zpv3lkbf7xxXgaMRkix4zWBgN1RG8Qw8Q+KvxGPmYqWaB/Ph3qETfsjUVeAoyr02GXQV6k97kYYPYEmiTZZzPq0kfLND0T/arqr67b/Ws3sET+zTlN4x0TtllbGYBeW46b6w9qJtCa5uyXb9/cK3vi9RQC3b7zW3dDrzr30kNTVdEgMgbNYKmXXANEe9S0OJX1dPuKqzssjwhsbX3n+xNFWjDKn9q4yDEjJidssmgvuuNJCRF8GjwlI3L/O0WhDvLnoPTW8PlSPjd0dr8QQ6+uyCZl8TAy7M15DZ3bm/krL5FLo/sRA99urU06xDxPozl64IMLoFTajKBtm8WiEEKbynZyZ/cb3ccoyEw79NHh4h+NR/QXC4H04xfeYwT24Q9gGc72Bx+uCRj2Nb1OC6K6oLSiYoNUm
 eCm7YdN7
 j4eQg5EWvabbEOQ75NRrNZ/EAjF901fOCu2cOP4twEWRhXjUHOKSop37zvI2KV+LjnnhSSceitqiI5d4tenHutAYPKuT9WhaTcmVhlzd6z7UtiYxoCkd3BgGBPVmenQ+Ie78uoj+h41OwuSYwVP1JWZjn02MsoWw8ZXZMX2gR0nhSucwtiEJXdsWuauUBjJ8WgdryZj8Pchy0SAxQ3qDJHWKpW+tVTuNhqyf6sWtfAbHROiRzR0Q5U6Ec2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 3a5a8d343e1c ("mm: fix race between __split_huge_pmd_locked()
and GUP-fast") failed to follow the convention and used direct PMD
entry modification instead of set_pmd_bit().

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgta=
ble.h
index 1c3c3be93be9..04ec9fee6498 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1744,10 +1744,10 @@ static inline pmd_t pmdp_huge_clear_flush(struct =
vm_area_struct *vma,
 static inline pmd_t pmdp_invalidate(struct vm_area_struct *vma,
 				   unsigned long addr, pmd_t *pmdp)
 {
-	pmd_t pmd;
+	pmd_t pmd =3D *pmdp;
=20
-	VM_WARN_ON_ONCE(!pmd_present(*pmdp));
-	pmd =3D __pmd(pmd_val(*pmdp) | _SEGMENT_ENTRY_INVALID);
+	VM_WARN_ON_ONCE(!pmd_present(pmd));
+	pmd =3D set_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_INVALID));
 	return pmdp_xchg_direct(vma->vm_mm, addr, pmdp, pmd);
 }
=20
--=20
2.51.0


