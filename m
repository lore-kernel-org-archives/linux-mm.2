Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9A1CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 06:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D8D8E003A; Fri, 17 Oct 2025 02:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245138E0002; Fri, 17 Oct 2025 02:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1345C8E003A; Fri, 17 Oct 2025 02:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01D938E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:48:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 807EABA0C7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:48:46 +0000 (UTC)
X-FDA: 84006678252.04.84C439F
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3A79040007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:48:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=B6juZ8Iw;
	spf=pass (imf27.hostedemail.com: domain of kassey.li@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=kassey.li@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760683724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b45vcD0RNhdyBBimrVOHx32/MG2SgQ7pep5TrbKAkCo=;
	b=RF4mdVqJ7idJP1B5CxDDnkkMpt0pnI/11r+RZgG3aVTyhcIc0ZI6JRU5oihZFc3DTRIESL
	JSbiYKA2CYFa+n1KwVMy8KMWN4GNPMbam57Dg0qDi+2H9jrOSKYvMAOtl+Z7J3NFt2PeMY
	Gad30d3rxqSYNatADtH40/4JQq1vbm0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=B6juZ8Iw;
	spf=pass (imf27.hostedemail.com: domain of kassey.li@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=kassey.li@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760683724; a=rsa-sha256;
	cv=none;
	b=c7hUK1UWgecToQyxFzFTc34X2BQV0VFFJCq/MbBeow0+Nm+jn07FREHA3QrYAPpZzubCnI
	8Lgr0eA392l2/8G+icmdsJXklbDbsvhFUr0DXPqiAXlJPOtR46qhF0OL1OEujYsW/qnBFj
	XmXZLoOZpaqYn7MDM4bdig7GPzddLng=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59GKLW8N020342
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=b45vcD0RNhdyBBimrVOHx32/MG2SgQ7pep5
	TrbKAkCo=; b=B6juZ8IwqBtekP3afXrB8DmDOcLSuaktWF18+ylupHLZ1JFjf14
	mIyH1zVPuBiPCGFBsv63DUhKercf0PEwCzP/b39Be5hp0Ukj+5MnSpqZ8gsRSGEY
	dW9gQe/VUqYuICyxYWsr3Y+1I0208+yeJnLhfqVGRcIPVfFhnMz0XZ8G5LCStqRw
	/zMmLzEGv5ggN2Wr8X7xkgKs8rnRaMQYG4TvwXsUcSAn/2ciXceFWxX8PwYPm9Ku
	GqcG60KAZXBMBqawVSDJZM0fk/ejPUiPZ78P0o3/E9xOrKWKB/oUWzF0NCnp5z5N
	qopHf9cLDrOxPF7ZDDasJqpGETHhn5D94kw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49tqvpmjyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:48:43 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-33bba464b08so1175656a91.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760683722; x=1761288522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b45vcD0RNhdyBBimrVOHx32/MG2SgQ7pep5TrbKAkCo=;
        b=ne0bTWHJAt5/DjSGyqQh6lHQ4EScO7Od3KgkhklbR964ViodOuxQhdIAQesyWt7kD/
         c87WUWGzaPaFBsW3tuHir/Z/S2aNam4roNPXKEpReLDi4ElrFTZS1lnOfkkMWFnRNlR8
         t63wlMGRkV/uLqRuJPNhcLyN8Tpb0vd5VKEvgi1B+JAfAtBHATBsqbbuJjDdhXjIKwjY
         6CEm+RJlYtuOYdiMz3YyWfEt+mvogl9XSly0cE36y+OcJcyCcSscL+GHvn1MCmq26vgk
         QD1DZSS6sFBKajQ+QQV/truV8MzZ9974IkRfRVrE8MzG0T2lqcAze5qZ7UYZdi8VI+mG
         zwsw==
X-Forwarded-Encrypted: i=1; AJvYcCVG0CTgPMdDzYWft5SIoM4Zo/uWockuk0pGOU580l/zWuNGvPqdKKmhDbdhFfsc7csUO2lXfVS4Iw==@kvack.org
X-Gm-Message-State: AOJu0YzoKTVU4lBDClHl9DDDu8h/hNPwSugjyxBd3ZB2OTXmGjNjcAES
	woKcvu4/KX8j/otZ9frZRWALoNWE8ygTc4j70AALiJjq3csVHehosQDPuO5jguwJXD4Mta/H5Ym
	QB3yWH43SPyxUs6lsPG7tsl9uHULf9hZsGJHoWMOy9ynzmY2vGMiHhA==
X-Gm-Gg: ASbGncv8ZTFGvP2uuGuM3DO6WO+6iWR9dTo8On8z9KGYiwPbLJSjLpDS3Szi0ruBkTP
	T0v2LSuxfAVou+JuThD8AToOhIBI21iprTQHuUFaWIljzVc0mCacMgWN2OE0BSHgxEOYRbRhDra
	3jz8Lr3GBI+4Ea6zZzVp7yesbHOVN2ZSEXHo9dQtQAiljJAm48sp4TQgDCp078m2/QebHUM/oOR
	0x3X2b38R9aF9bfJyrwS+BmFGu104Bh885v41ytqfVo5vonp7f7hR/oXJHX1ZxSsCWSia8+XXTj
	TC33FtHQ7oE6qXPlQTVXtVxSIrA32VPjfbJYl96JChFIuYETZfYHhG6OPhU6DR7etrGS+LaMU1K
	Yp8eG0xt3olYNpk38RdtopuEtwYeNCdofsmHXPbk+r4gNFDYGIQ==
X-Received: by 2002:a17:90b:5111:b0:33b:c5ce:3cb0 with SMTP id 98e67ed59e1d1-33bcf8e4560mr3348982a91.20.1760683721817;
        Thu, 16 Oct 2025 23:48:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwIThdK9ZWr13FTpAec3JJm/4DOASnbw4evWs77j00Y0lv0/Fv57JQjbJhk2VxOhsxJNt8vg==
X-Received: by 2002:a17:90b:5111:b0:33b:c5ce:3cb0 with SMTP id 98e67ed59e1d1-33bcf8e4560mr3348962a91.20.1760683721410;
        Thu, 16 Oct 2025 23:48:41 -0700 (PDT)
Received: from hu-yingangl-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bd7b3177asm1665151a91.13.2025.10.16.23.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 23:48:41 -0700 (PDT)
From: Kassey Li <kassey.li@oss.qualcomm.com>
To: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kassey.li@oss.qualcomm.com
Subject: [PATCH] slab: add flags in cache_show
Date: Thu, 16 Oct 2025 23:48:39 -0700
Message-Id: <20251017064839.585204-1-kassey.li@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=aPD9aL9m c=1 sm=1 tr=0 ts=68f1e6cb cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8
 a=blH2SsOzjbYzLah_e6kA:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDAxNyBTYWx0ZWRfX71Hxi5hkdkOZ
 zELZaRjOWAzJcA0cZZs5kRSJedzUK/mTXIUNqvu+4o1FPMVzza3LY+TCuIsMqnPOM6YSCWdF6/F
 MJcV7NKomvKqvvSUNswq+xZv3ObzhVHRbTjeUEfwHzfDTHNa0kFy6LVaOedt28f05UOWPoAKzDd
 LhV09Cb+kc3gNF43VuWXL9/I+9TmYVS6u8MkM4VbVfzg+kwHG7B5vcHwSfkI963eqwj07Kays4X
 kJQACi8BIusabiNV2oP7fhPpQ5nAF8sQIeoRYrJyltPQZcqsY5J5O88hra93m9Smm3ewzPb/oUg
 /0Z8YDN+nvo+dwKbc6SELVDxyURwDqYpFODyIEONdr/LdYSrRc5ArDwCYsHlk9TFpBMYawLuoeW
 wzpvFtxyza/E/gP0m3rEocPy8bMdDw==
X-Proofpoint-ORIG-GUID: 7bNr_5sDDw-j7_PUF2GzTesR6J2NgARH
X-Proofpoint-GUID: 7bNr_5sDDw-j7_PUF2GzTesR6J2NgARH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510160017
X-Stat-Signature: tnmxkg5b1mbfwaqf5stra9a3jw4hjaig
X-Rspamd-Queue-Id: 3A79040007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760683724-352779
X-HE-Meta: U2FsdGVkX1/dnfWoZzIE4Tai6iGT0O6nmK7VMCftro8AFe+O3o7VsJyRV+Jjxm2CSUzDVt+OH7/cAH05y5LEw4KrY+Hb09J96TT6BoXTV4oEYXpIoXLw+jA58Bv9j1oHUQiPcmIPHtaRNufJdsS7FiV5tFSRO5h3ai0fKPc/op+OjOreEeqEy0C0HB3cZ9AeeqP/i9RO/jEK7JXkl6AlPWwmd41jotDaJFURTinWpS8hI3b39AFpgdjjO9OAL0lB6hxVSlyacRQxmdVS3Zss4fODWzvFppcAM+BIPikwRRGoN+UI9czc3ihsjPEfwe5reNlFm5pYYC6xQdjSYl8zkw5g9SMlzaa7fzJn3DZlUcTv9kvK2VJBAcD8UVsGXNr/DjqeXyEo925o7l+gDXOqD42GBz7IwdUrB6O7fDaQlDg6/3VWKqi6MDfKWlkOXZ4OM5Iru4aqEutbeysAPFKw3kenlQ4G7Pr3zhcyzqpP9b0aB6oKNWy7tBVL+AR9UZsXoUKAAxNYdLcG1vNdvcvvd/g4FSMXVy4LP+wOjWd0K+a38buIvsE+IGddhdJgmgJHngM+dGVT7HpCfysZyplom8xCJIcT869cKJIHsWeHdiws81EF8g9GAp2KppEJrLuTE/NyxgMF9/zEL7yQgFpVMMbNgG7610WEuNUkJilUpmFAQFFrRhKYTCw9Kr9MGQdPep/VscIb0EA3rQ79ggGXCRUnIc1BmXLM/GyjEIdTXx7V0W9icn5sv2RwzGpAIMDOeG/Zle40myuwYJ7V2lyuxC21uq7lWnBB6rxHpUF+cc1QKS6ctyXPLbU4/5s05i1XKNp9SjPcJb4JvH8bBynOmZyf+zzMdaE3njrneOLunW7QvYETNj0NkA1vBm4U3VNEPOJTQEWqrdwzO1LLKBJAdZ6oGByx1NE7+KkvHvlXOKKy2M6LiNhxD0WgY297H9rW+AwExUEOYnJq3Y9T6mo
 8XzlLwvI
 FurBRn1opbgVIJqKUAi7azVOd0/a1aaVx9aIZjfWR9vD8l2HeBJzJ1eo/Hqx50cKuOgwoNFxCEB3B1JqN1BrefLIOl0J9sSeu/sjCQno9rObTVBg3J1oaU6/PEDOfM5K4DQbrHtmMo25cEeSvs8pe0Bq3bwKfKuZh/BiaWp04AptQP7zzlRa1i8QJP9wfU2Opr6tyvEO+zMdt565vKG6whoy9CA+3Vj1NZ6gCRYyejzteyzhcuT/SlaiH+DorfQ36ug2G8dHdVoLzh88x4QN6k0T8qvlYtBwMw1eJ4EjVY0fpeLBEGpuGfDqtT6YqFoxqmD2985rZsqDGqUzak3XYZ4xbV644xWF91pHnj3x560tuZmtg7IHT0NRofwDkSmcDK+jA1xmTeGxAbINgFXd4K70fHUUYKB2WupBKor3ttKaHmm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Flags info is useful to check the slab type.

for example, _SLAB_RECLAIM_ACCOUNT:

    0x50100 _SLAB_PANIC _SLAB_RECLAIM_ACCOUNT _SLAB_CMPXCHG_DOUBLE

Signed-off-by: Kassey Li <kassey.li@oss.qualcomm.com>
---
 mm/slab_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 932d13ada36c..f43239211e69 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1083,7 +1083,7 @@ static void print_slabinfo_header(struct seq_file *m)
 	 * without _too_ many complaints.
 	 */
 	seq_puts(m, "slabinfo - version: 2.1\n");
-	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>");
+	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> <flags>");
 	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
 	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
 	seq_putc(m, '\n');
@@ -1112,9 +1112,9 @@ static void cache_show(struct kmem_cache *s, struct seq_file *m)
 	memset(&sinfo, 0, sizeof(sinfo));
 	get_slabinfo(s, &sinfo);
 
-	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
+	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d 0x%-8x",
 		   s->name, sinfo.active_objs, sinfo.num_objs, s->size,
-		   sinfo.objects_per_slab, (1 << sinfo.cache_order));
+		   sinfo.objects_per_slab, (1 << sinfo.cache_order), s->flags);
 
 	seq_printf(m, " : tunables %4u %4u %4u",
 		   sinfo.limit, sinfo.batchcount, sinfo.shared);
-- 
2.34.1


