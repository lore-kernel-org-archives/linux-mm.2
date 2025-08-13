Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BCFCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837C090003F; Wed, 13 Aug 2025 02:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2298E01B6; Wed, 13 Aug 2025 02:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0C690003F; Wed, 13 Aug 2025 02:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 569FF8E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:28:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21440B7E4D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:28:01 +0000 (UTC)
X-FDA: 83770753962.26.82DB11E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF6AE1A0006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CID4lWrm;
	spf=pass (imf19.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsQJsGaxcqmvsVIG5QO45P6Jy0ZaCP+miqd9jeaLu1A=;
	b=f451BLtBiy6Vt1RB0UheRA4ir/BiR0RsEbKBYjBtjv0iYsHwCOZMBOgZN0nzxJg8CDbkxL
	ZTjBFPXEeVaxp6cNLPHQHSzSMKpRI1XkYNe4ItGkIpQuCfoQ23EtRAGonZ0wdf/oDE0keb
	9uwwZDPOoydMY7jA54Y2OSF75mZ5C6w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CID4lWrm;
	spf=pass (imf19.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066479; a=rsa-sha256;
	cv=none;
	b=WH5qc36MI1Ei42UUX03vuey60RhiwpuUkQ6czP/K7TK+pDTqFHAZ04/a04CYOOxnAEJlSL
	YK6HdFf+ui9U2BclsPF+LtTh3V87lmvoJLvISguCPh2NpMF5kFHHiyQmmFE5eGYwXPS+8M
	+9bd7iLer56RZAbmwxK3oAridUU15XQ=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQEj0008385;
	Wed, 13 Aug 2025 06:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BsQJsGaxcqmvsVIG5
	QO45P6Jy0ZaCP+miqd9jeaLu1A=; b=CID4lWrm0wGGcKXYczdkZ6A4WoNsFRUG2
	P7ZoHlfkVjMcE514h7Z7Xu73WM8jMyH71BJ6IoUbQd6jwYnEO+So6NNTOsphvBPr
	8XvBgb14JZ6rpy+3Zq/hLnmkAF2qzyGtfJGoHVlukPkmcg3HrSI43emfQV4W9dUv
	e5NeznnQ5e54qunUAQCN6rdPEjWx/6rBl/KkeAsrB3ekeqDRQ13sdNcn1qExVlSq
	UaZpwlEFMa60hkXpdT5GphW8kv5RCg5eUtWbLuqttz2Q7DBzH8sbQE+swrfWA6n+
	OzaX/ZEt7NPpB4cDFtpkvKmLNe7NUApjPIUIzlyT5MMNR+gs6FPGA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duruavc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D1gaat026377;
	Wed, 13 Aug 2025 06:27:53 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh21659n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:53 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6RqUD30999048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:27:52 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E67315805B;
	Wed, 13 Aug 2025 06:27:51 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D440E58067;
	Wed, 13 Aug 2025 06:27:45 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:27:45 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        Rohan McLure <rmclure@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH v16 10/13] powerpc: mm: Add pud_pfn() stub
Date: Wed, 13 Aug 2025 16:26:11 +1000
Message-ID: <20250813062614.51759-11-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6p78tIu4d1GxeDYW0_yoMYEY7Uv1CVko
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX7SEwZJR9uMEo
 twnLAjMn1uDuQyNZFvA5mghsluXsrnnNXzdlUz6WtiuS1mzji4hMRYhDtFXzKdsF1+dii5tv0OK
 BXF3GJhRE4Y31srrKALkZx8xNOBm23JXu/foFaUhocmzOkUk8WWqGvVm77BftHaXkfhZ32Na2EN
 yNGLCWhCqEBpUzlnE3kSKahcHr+OemUixZd+rxh6kXeHWoIEKfLtMNfa7vMpjD5zkrgTYDKoJBa
 /G+mhmgKee31fJSwJtZqqRwu5G2dUHERaHLdGVfNOddfx64sKo8ruZRfrSDufbwcUmwYso2UXCF
 5tAN90eLLoWhejCdoXT2qTEnPXyeG2HHqlMFJumDS3tekxkh1Jb/YEkrLSN0IgLCfZuQz8iC6+F
 mV3/I3lB
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689c306a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=qzKveJzcHEAUI94IIBQA:9
 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-ORIG-GUID: 6p78tIu4d1GxeDYW0_yoMYEY7Uv1CVko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224
X-Stat-Signature: uu9q1guiioe8qakg4at6q4ikis5arfsg
X-Rspam-User: 
X-Rspamd-Queue-Id: DF6AE1A0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755066478-748358
X-HE-Meta: U2FsdGVkX1+50+zzZPBqA0V9BCcdxVoHWi91scVhBmPspKMNZlss9MRNYJ39IN+ziQ9LqFf7PcC6/ICAWKqucSln4j0+YCBw9YBBudmuUEzHzUWsV7rZSCeXdCvNWXn0z5MduS/ixYoCipzK/fAhV45rlvgovUa2TswBezpoLY+64zhNuIes+RuHU3orym2G0YpR2sfiE7Luvqkc20A13XelQXhBdmhDv1OMAzgGmzXYmlAraq2+kOOg4NhwfsJPtG7NWiLkJIjik62E2cZ40CmKY8Bsx6DoXgOJlUccToFcK5lqh/mPG6boDC4VoYgxViD5y4g+rQ7VZpSg0PxObsLLtTpBlozWzNJQspJnktdwE5KD6vg//0f0Kk91CEIqEOHT+0V9DrZFqD8BjbSshyZY1tq16PxeEJUREpi7kj0/k6MgXUulj/xVpCAEtI1pUAxao47Jravl42MqPCxeWc9GPHTogPdzYSu8277B+ELCdrenLj8VQwUrU13zszIEn+j7CQ0HKhVvdSahhQDW8UXm+S73uU5qHwF47cOOdJurDM5qNc+s16DPhMwEoOq5RpPTfPGbSvu+mE4ht7HLiartHIuLD2jxj+u2wdThpz7ynBFAbZYZiOkNjALApkabQJxK0agG4CrFTshT5jcTOvauQx5I4aBUW8t8W//ogrJDdgmYyJs+Q4cOifumx3yMN97EbBqw8FYOzPXnnc6vDkoYGwDXM/Y463XRIqnye3TpUZREewl8xWLYtPEOGSYfpF/GLvNTzPvc7fqumJjrN+j370fIakhucFpoNCzWndO+uIwJ0vkrYRRo8fEn7vnsru3uGvsyCAG7HqTky9HWXG9GU7pwTf750lZw00OFbrDtm0TNQfcybM0NPhcUOrygC7LJY9Ar/6o4yZDb7V+Vyb3Ewje9ZPi2UrHkIzXPC+PfGQd3OgB2Z1iTwOBWIr4oVJ5ZoqUgz6hltRYRNuE
 +o4XZ6HH
 XTJlZUSC7phYP+TMMDQ4tBh9unHyQ3atFUwF/7dBJvbnXQ5jmlf/cRld/OsPTLC9ExUxcITgP3CubVCKZEB19QxFOh/wudmEXb81lAFBGYqeGvXS9AgIZPzdlvwuapsS3pspFC1BLwEn6onMzR1j9Yl+FaQu84IXPfsM+nHVNHfyWVN/rECDpYg1f7mpYXWEym93FGJYi+H25wLcFzJhft8rXu7yLqBo9CVhm7hmvBK8DjerEcOjHny7dhTHqqUqiumu3svAD80cYvRO6PwIRGU2aYFHSBZT/iowcwuVjm67hR4ITf0KfH6sqMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

The page table check feature requires that pud_pfn() be defined
on each consuming architecture. Since only 64-bit, Book3S platforms
allow for hugepages at this upper level, and since the calling code is
gated by a call to pud_user_accessible_page(), which will return zero,
include this stub as a BUILD_BUG().

Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
---
 arch/powerpc/include/asm/pgtable.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 93d77ad5a92f..0f73a9ade0ed 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -214,6 +214,15 @@ static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
 
 #endif /* CONFIG_PPC64 */
 
+#ifndef pud_pfn
+#define pud_pfn pud_pfn
+static inline int pud_pfn(pud_t pud)
+{
+	BUILD_BUG();
+	return 0;
+}
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
-- 
2.50.1


