Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53B2C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 05:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6596D6B0092; Tue, 29 Jul 2025 01:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6095C6B0093; Tue, 29 Jul 2025 01:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F89A6B0095; Tue, 29 Jul 2025 01:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1036B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:34:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00504113A71
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:34 +0000 (UTC)
X-FDA: 83716187310.01.9A29A7C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 972CF160002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FJmQlAu6;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753767272; a=rsa-sha256;
	cv=none;
	b=an4AMb1DHmutyfedNxsMJDJ5/nukSnVn+CayQBlOSvzw3b7ZTNM9ni/w326GeZ25vpHtF8
	meaA1F5BGUUIvSLcy5bSyibXFY6JAQQuPt9n6rOrUuyIz8daPEt/L8yTSPMAZejpT87bKD
	fwCtmPYwZ6Ew8uu7cjhP7nsVvc0d/5g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FJmQlAu6;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753767272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVp2jxW3gsshZpoJacr5kNhvPrUc1+lm5rLjVwVsfB8=;
	b=F0VlRaqtcMjKTlrrtiUGL7ikPn3+vXTbIS/o+/CxWg7PKouqlJACL7PfdFmv4JM8nbWHMH
	ucoBNDfAPPdizVtnrL+FYW4n76qvLP3vjKQqinznG2Eq++of2ODsK+LodlPoZuBvrXHDJq
	++U91Z/Qf6xtkaHkPhYrBiBjFJbkHNA=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4ZEiL017211;
	Tue, 29 Jul 2025 05:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tVp2jxW3gsshZpoJa
	cr5kNhvPrUc1+lm5rLjVwVsfB8=; b=FJmQlAu6bbxvmVB5JXkkTM/fhY6xCoVj7
	1sb4fB2eHFT0Adv5ltczADkQEEjQK8UETghMA9LEhN+OCG/HF464xZiJJKblmFzo
	fBlrH9pY68BexxfxGRGu8SxEh9RR/WyfJAxEA+3822+GiKavFutARlmxn0fujP5t
	NAA9ETXG+LU8yNsssdnaIlvfJB45851dEAp1db7Hb9BGqt31m9zaebelctM5hCbW
	3v9L2SV80pF9js/jaAki79gjHuridgoDZ6o+KCpcp9Zes5RJ6Xr1cOx8iZ+8U8Ly
	0EdWqV9Qn8yJ+NVl1RX+Pgm2U6yCwKxzUOp54NHNJ7RRc3uC1OC8w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4864k7n8hq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:21 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56T5YLRk004087;
	Tue, 29 Jul 2025 05:34:21 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4864k7n8hd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56T0osw4028728;
	Tue, 29 Jul 2025 05:34:20 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 485c22gq9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56T5YGpe40960468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 05:34:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 523FA2004D;
	Tue, 29 Jul 2025 05:34:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7EB120040;
	Tue, 29 Jul 2025 05:34:10 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.150.11.63])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Jul 2025 05:34:10 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v3 1/7] mm/selftests: Fix incorrect pointer being passed to mark_range()
Date: Tue, 29 Jul 2025 11:03:57 +0530
Message-ID: <20250729053403.1071807-2-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D__wZ5AViJXGYz87T-6nXF7ExHIzFUtF
X-Proofpoint-GUID: dKgDLYsOgFphMGf_RokuWg65kcFQFwD9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzOCBTYWx0ZWRfX/+W//Ctohoc8
 p5knvb8YutA96ws9OSpQt301EIQV2mBZ8B+dP+8pKjfv4cqXC+JU1ROrUut+CSwmsD0fThjoJDU
 pz5BqPbr/mYHRkTOzr1ObC1C+XtBf9ReI4PScF4LaPKB7Wdipz8jHEJJ2uF9TZ6Tjh0zugUWYeM
 K5HwLX9izDqZlILCQHb4epLgljjblTUc56Apc0ftMMLmU3iLtzy2ToXFcfy265fOSLXix0xayE/
 R2Cki7tXa/rs29kjEGlYEFlceZOHK4JA1spBiVAa+0NFZxvK43Tn7lzq3i8HRJD+1I8QQ4WwEii
 Wq5FkxOsfnKaA3WOdxC5HuP43E4R/yWv9at8kUhFStt4UzdRkBrsm+J3RAv1O+zKN1dRcPPIdX9
 N+LdRGYsI1vhQx6BPnWKFToQ+oOH7kgAgYERCdrJgTG3OzfAS5S4FCelKiQ+oUy64MPuSUx+
X-Authority-Analysis: v=2.4 cv=ZoDtK87G c=1 sm=1 tr=0 ts=68885d5d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8
 a=Ikd4Dj_1AAAA:8 a=UadLiVKD9PNbdUwwWnMA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0 clxscore=1015
 adultscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507290038
X-Stat-Signature: yr67fhf6ecka793h35orycei14i7ij8b
X-Rspam-User: 
X-Rspamd-Queue-Id: 972CF160002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753767272-367258
X-HE-Meta: U2FsdGVkX19xG48Wn1euievaipjQDVTy/X0rvVPAD5BkVrcMNS1f+omrllgTuz5CFBWBT1RX2becFjQSJeoOWHxKxH0BG8SD1hiZaCqOT8b23N+iAboU/QNziVLmVVagrO+czrAK0MeYBfTj4555GwIoGnOcDxskI5oiu4+IDD6WZySPcHqw2OUnyubgRqunLwlmGNZaDHNXvuT3gFeF6OHEODTwdkuHAEk9OPoqPh1rQzbPJVYKlYV16Hp+9gsMInB5EfxV+fZl6BU2bZVxMM9t71aAEjYxI4015lVoDo3kWwBrPJePlswvjBcWTnxi751gpOMF6UeCZ/CliW8w7MFJymSEXc/9WIXfQ+0QLWICwo4h3PFbbHwb0zqtukWo1eVruGmZewePjDhGuLFPEU6Ms05Ack3Vu+iYpBXoJRdzDQ30YkC1PLrY2Sonk5tmsjA6VXYuHR5WU1CzyQzHobImg5Huyjq4ApL21tYM6bww6+eZqNDQLxtw3ujbInIOhpQYJUehpTP0Ln7UJpfuCM0joBX7W3az8FGg4O0+LeH/coHOMzdcjC/48PqiEmdB+SL9WhWsTHA1QuEXOUVQx7kPlkl9MtKDIfJ/V/pCjMm13Jd4JvR4QdnO63jssCpY/VBzeaQ+GTyH4Z240xko1cku/X0Ghg2PXnUeHLVhjOUjevR7kYWRjtGWnToxaBkVMdpa6KlENuyH+RGYIjYE6Fd1pl0QXts+u2Gr94DOmIUunrHJt1t4LSemjg/9k8XqcGdiH6a8OPk650Y8l4LaJyb0Bgs4TreyfwALd6z7uDcVqLdJnz0m9NSCmzg06LNzRITdy+X1JN15F5e7yjryKfimsgYyM0AX/ScIUguiRV8w1UmOVuqg+QtD093IsxO9gUnZsQxnWtCiyh1F85QMu43CcPJrxD/LucwhRcUbwvE52PH3PCoH6pHQwjBCbIqNgdq1Lrw5MAgqwv/lcTQ
 SHN8pdZY
 YNkOVIJqsv/o7vEs+m3Z9nvpfS3VwIrOrbIWhNx/N677ixILMruej0dQQSmTK5uIoYepbwHlNwNdcreiYFqxqOCrBIkEfGWaRXgTQZI0brsIsAXjKuKfc6KII5YDYWC1a000lBsM7PdNGiQAsZ9WiU601SaaXpq+Bt9PwWZE4Vc7Nd/IZtGobML7z8+RDMGTRvh0IxZRpNe03XQ6T+up02CmqvpR+O83s55kRMftj0vDP86+Q4BkFdIpoNI/uGoC4C1YzTb0FQoQa9HIyEqY8ffYTLn/tTvcmMcyaZeIFZguwJizt624Ctn0Ft04KVXHS1eADLU+juyI5pmBsSJnJ5UwGC8MV+RkY4TiNf2NGTxaIhYm+wpU/ywppROYvtyXR4xHyV1QXsRPB7pX5X6m/PGSFuxVagGxtiBzf4opZXRuBjnQCplYU7CZ4W9aaXQuEo/JoaLsz4Yr5iZBHXA9SMzX3+7ClfGUzxbtSWxtaJVe6hVk5jWBuDbYckErFHh55TbgEXu6ly0WNI3LC0sryF61ZQnQrXJevRyxAf7vR1BOjv7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donet Tom <donettom@linux.ibm.com>

In main(), the high address is stored in hptr, but for mark_range(),
the address passed is ptr, not hptr. Fixed this by changing ptr[i] to
hptr[i] in mark_range() function call.

Fixes: b2a79f62133a ("selftests/mm: virtual_address_range: unmap chunks after validation")
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 tools/testing/selftests/mm/virtual_address_range.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/virtual_address_range.c b/tools/testing/selftests/mm/virtual_address_range.c
index 169dbd692bf5..e24c36a39f22 100644
--- a/tools/testing/selftests/mm/virtual_address_range.c
+++ b/tools/testing/selftests/mm/virtual_address_range.c
@@ -227,7 +227,7 @@ int main(int argc, char *argv[])
 		if (hptr[i] == MAP_FAILED)
 			break;
 
-		mark_range(ptr[i], MAP_CHUNK_SIZE);
+		mark_range(hptr[i], MAP_CHUNK_SIZE);
 		validate_addr(hptr[i], 1);
 	}
 	hchunks = i;
-- 
2.47.1


