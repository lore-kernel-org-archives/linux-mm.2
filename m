Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8CDEEA4FB4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11EE6B0088; Mon, 23 Feb 2026 06:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF606B008A; Mon, 23 Feb 2026 06:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0F66B0092; Mon, 23 Feb 2026 06:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA59B6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:53:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E52C1408F3
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:53:25 +0000 (UTC)
X-FDA: 84475561170.24.D0C4358
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4271940009
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:53:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dS5a3926;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771847603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtoi6WxsFBpQPnnI4jiQWys6zQsSpfXOxB+meQZaJfo=;
	b=0ZWW1N/hCxZUVcxAOS+OuzPQRas2zLU940SXBBsXYkDfpuaPBhcp7xhRwhb44yHeedxNT4
	g0rgJEwz6O1BF+b71nDKctV8ACxcpJjlqmXwhAxJLE/MYkfKdJ98NX0aveVyQoU9TR6lBz
	FTX7xgbyBgrI/cnTpH05tlj+m9JYxcw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dS5a3926;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771847603; a=rsa-sha256;
	cv=none;
	b=e0lJWehkU4lvmLYR+sIpUTS6kq5kfHKhYVSUuVCYxF1eIIKVv05XDF9kgImaSLPP3Svc20
	65SYUgnZqYZc/tXtA5dTRzGcoFM0AOwNjTBPL9M97rvjSeGGqAQJm105xbdkNxrSXERbeW
	QaXl4kvV7XtXLbLt9tZ5iNdjVuUHBWo=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MNOPnj2839813;
	Mon, 23 Feb 2026 11:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dtoi6WxsFBpQPnnI4
	jiQWys6zQsSpfXOxB+meQZaJfo=; b=dS5a3926tb9lFIYlZu7aBI9Qi2p57+YQx
	cHOPx5fda1/ncnccroIcqr6PO69D4AOEYWon5rcAImhACMbF82MEJhAnZy7TjMK3
	V48oK90FvOa+qsFPpp3HSes4HsKirC9S9w0IxS9cEPz4WaDS6gS8QBDzkRaNrkQC
	XYKAXDPMCO6s7sAF3ma/2gqOmpTY+IOdXzuZzLyEFoMaqcoJN+z3nB7VXhT5xxg0
	PDx42R8TccAsP+8OU8/6NbziAP2T1rmrDOD9Db6qHMxyuR7D6b19JnVce0oY6V9y
	zK7TGZhD5UB90I/kYc6fI80tpdUjZX9C+ftipJMztSo0CAheyupuQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4brpee5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 11:53:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61NA31Ce013419;
	Mon, 23 Feb 2026 11:53:18 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdxvnsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 11:53:18 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61NBrGJ030605940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 11:53:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A1F72004E;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62E3E20040;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 42E52E0B66; Mon, 23 Feb 2026 12:53:16 +0100 (CET)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 2/4] s390/pgtable: Use set_pmd_bit() to invalidate PMD entry
Date: Mon, 23 Feb 2026 12:53:14 +0100
Message-ID: <0aa1229418fc85cd89975e61abeef421a22097be.1771845678.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1771845678.git.agordeev@linux.ibm.com>
References: <cover.1771845678.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DJdugSA8pf3un2SMyjkFtn6m3EEbpSPF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDA5OSBTYWx0ZWRfX6VlxABNsYuyo
 LpLWehqxZkWz5ST1QDK3NffVHaXaHbm+YEYrYwryvg7KgVpJC6YezjMMvh+eCuwZIChQT/DP4vT
 fOoVRBE5VEFHKHFbPE9TrYA1LADNsa3rk4tRjSfBYOFoI+8gq6CQi4ty4EC6SSoF1uu5syUdEN8
 y//Ke2RE6sWfyqcwh9YxUEOl0XkjM5/mVl4eWOAX5+tmMKLYmLrf0HpevD9H9T3AuSEfyk3GxBN
 MomQpkKawTBty5ZeI8IJfxUQYWrjExbzkEM6qhtXopgPbvZFG4uSHURQOCP6zCbaUQ/9g/9tt1v
 34scLjD6Qfpet0dGGIqQD4Gz9Psn+7OGQtHe8MScQTRJozUEYGa2nFUND2Znc583gFKazYB0ERy
 0IwtNIwteKE6KT3AliSVXOdpwf1s3JZr+x/GFrZM76vHHeioprzpM071IlHOGVgrRvu1H5pW4tB
 GRuOAvoIXJ87IS0Ab8A==
X-Authority-Analysis: v=2.4 cv=eNceTXp1 c=1 sm=1 tr=0 ts=699c3faf cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=Wwf5FGOAHR2iKIFYnxsA:9
X-Proofpoint-GUID: DJdugSA8pf3un2SMyjkFtn6m3EEbpSPF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_02,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602230099
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4271940009
X-Stat-Signature: f5fbbmngapw5ktsjb3tw3z1ypfi7ys1o
X-HE-Tag: 1771847603-166548
X-HE-Meta: U2FsdGVkX1/bp8fRxwa6aU7Zkz2fYirWR7D5jWPi/mtuJlw5Y3An3z+O7ME2CZGb5UaOAYUXPt1e4NEtXBHtAbI9DDAVWtZpmkD4lWk6ovlOR3ddOzw3CGUGqXXQMkr0tQY2559z+y5KHAdyfFyEPpSG3W36Mgb2Uj4f29jQdxoraFJKhlbq4YVK4IiaHscMfmrvYy5HhpqbuJ55j/q9I6a3KL7hrdeFCwm8Paqz9HnoMFHt4/1wU6Uz0/Xi/t8ak+uYm5nAchvEqwXm1CkB3PmGIL4p9pWhR4ecWmk9+kfkOETk9GpdGShBNayOX7VwMJo32eFnbKpaDfgsrfZLPDIruQEYJ2rTS29Xzbu0f/CjoC4S3fbTiME1xnyXUZIUvcM/pkcRdm7xQxyZwUF1DN6M9mpS68NhWFnHZmYhfMMD+X4K++/Xr0aWfRU6NJ81CaZK/9g60G7Ed1tK8vgzBK62fuqCsSPupeWmVeLf/b606kKt5WGtstydUkkD950RAOBb5znpTxWzkhVHPxSjuDB1HQ00G/5cv92CzAnNmfYwa79sKqroFF5ybx+/pvAzbn6WM3nug1mpSgE6t6oqr7QTUEJOmTgA/75wxFsYQz12ITTQ0Ig6pZ88MzrjjJAQMARFXykBpg/7SFUoVU7txTlsycQEa43CoeBXYFxdCf6tOgHtLOrM7pSklupnUIDdkQDxgi2xn9SJiMVwfhzRtS0DltnxgPoWt3Tpcov5Ez6p/AJ22Ju8PGp162tbvlz7Y2/t+Xx7WiXVua1UUwkOr5OQ/q4LKLgBCBgquKYDIW4jd+tcy8VJfEN2KzPyd5R4+eIAsz362UpHsIMkg1RMDYOLK7O6PVo+dwokRQ8cJhYS7370LBFjNoUvP9HM5aqBYOkoVdunL8N7MxCPTX46Xumf0Cf3y4i2jkhe2slZgU35GUaDGiM0Gd1pIh7b9NDtO93McWm1Wot/ea6a2sK
 jCd4931d
 xj7LaEcrI+uBie+3Z9wwi1ywxc/fJx1p3QVJK/a/yQoYoN715rtZHWHeE0d5GIa4NjdTUEZgbVU4SBZyhdZPmGD1cXCIsC9FtBCu0vzOzMJUXsb9317/5nQMOLHqNq241AzNkwvE2kbb5OeuRjKzRUDuTh1junSoF/8iYqUQ4sgLZ/b4DsXuHPGWPB8bJYp6Hzots7YhHU+mmFjUkQeykOBIXxOVTXVdlQKccyBv7bQnVGo6eAqOV6L2l9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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


