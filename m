Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 205E9CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 04:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731456B0005; Tue, 19 May 2026 00:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA446B0088; Tue, 19 May 2026 00:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C99F6B008C; Tue, 19 May 2026 00:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48FB86B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:06:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F5711A01AA
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:06:40 +0000 (UTC)
X-FDA: 84782832960.25.953581F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id AC0EA140009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:06:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iZz3ev4G;
	spf=pass (imf26.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779163597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=taDS7tqJe/GzKHqEmQMHrAUibv66UsSbZdlpHpy8LhU=;
	b=GJBVkarJ4IcZ3rE7/aZKNe6o7botIiK66o75+qNVwRPZEH8D2AYob1fhe2GFYxufmBQWzm
	YOm1Bxzil/uPQQibmz1eJuFHmLXFE427e67MSfVdWXaTbzKhk1sCXsNTEjT1+LSguxTwHH
	Szn1b06mPE5PMEAtrmtfYkyrphMhIQw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iZz3ev4G;
	spf=pass (imf26.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779163597; a=rsa-sha256;
	cv=none;
	b=SK2XQCOi5in2BsgImywlcsBO0nlFoNKte/FCgA2G3OfPbESay3dhfhsKy5O5tAUM3O9FNx
	08+h+ZrVQaDAOS+HS3++C5vn456sehxwoe9Q9RtqMobdJ3tv8lprZ4J7HZoyfsEAqEJkvN
	xnlDVUyITPIHL1K9ZyLgXVMw1k6pPe0=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IJOvwC4141466;
	Tue, 19 May 2026 04:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=taDS7tqJe/GzKHqEmQMHrAUibv66UsSbZdlpHpy8L
	hU=; b=iZz3ev4GSP/E+NTTf0lcDyUTXixvfZxiA5SYo6g3mxbtIse3DhZFUAlPw
	Oi8QqyqJ7d1UxAyGNAiqAlY4eJDoZYANtg7+3t+wFQgtIoFxhrhvsEAYDV6tOb+3
	jxba58U5g/Qw/BpzvDLPX8XTeHkq4TZXwZgI4KorkYdvlt7iJs7syWzL3ddWWPrf
	f5fznq3dv5x0oMtB6rWKB2fM6BXp82EWFFLKM1NE/0R83b7rb7q7kzTRRqriAjqP
	MX79Dt114vXkyBO0IPl1wmq7wbnjhYdxyIR0gKsUKqbSo9sXTmF/Q9x8ja5eHbby
	7c53PVXWYp76XXDjwMBw7eDbHL3FQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6haw2frw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 04:06:33 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J3sEjr021169;
	Tue, 19 May 2026 04:06:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wk0wbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 04:06:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64J46TxH10813938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 04:06:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00F2B20040;
	Tue, 19 May 2026 04:06:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32C2120043;
	Tue, 19 May 2026 04:06:26 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.39.29.16])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 May 2026 04:06:25 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Sayali Patil <sayalip@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v2 0/3] selftests/mm: assorted fixes for hmm-tests
Date: Tue, 19 May 2026 09:36:21 +0530
Message-ID: <cover.1779090293.git.aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDAzNyBTYWx0ZWRfX8gjc48HJZWw8
 qIr0KBsNell9uYZ3tIjneCVYVbvU3g7+jT03+KXsgS4jMHhGRpdEmJMpIs4q+fw8cVbkyP8aBCE
 MqSGOmiPMS6Zq/wlSxHljWrvYG3zeLPTldEX0H0fr+qBYd8ci/V4fqPZnFnN1Nq4PIl1bbBPqe4
 a/cuzw/jglF4gzlQ4ZFR3dRz2PopYHQ7PbBP893e65TWQl4WNG4N3W93Ch0Mp8t3k4wO8oG3pcK
 h1HUOoZtxvZsWCLiiZ5Z00/5HIL5oCCPKeA0W2GkKyvPFgBohHcpBS9JTtso0w4Yh7WdHZrDQWg
 nE+NZP0AlZtzHJxx8PApymsYtjwHkxu8KNz8wDWW6NHm35X6Ttn6deNrh47nt+UWZiOeHQzorXp
 R0jRVuFD77cCv0afDZJorYLTvNVGrEI3qvcNgsxO9bzvhHU2PhsZIj4qIcAmTLq3iNogob6PekO
 QPQVBiEvWZdXz/xV01w==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0be1c9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=fsPjIq3vPFagtXREB8kA:9
X-Proofpoint-ORIG-GUID: j3Q4XY3U7EgWHhtnHFBlP64i_7nyE5bC
X-Proofpoint-GUID: j3Q4XY3U7EgWHhtnHFBlP64i_7nyE5bC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190037
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC0EA140009
X-Rspam-User: 
X-Stat-Signature: hug3bxfcysdxbrctdy6pdushaswi1i81
X-HE-Tag: 1779163597-190438
X-HE-Meta: U2FsdGVkX1/ABGm3z2uX9TCAefmRva2tpx2lmF//bRH18a48XfSLupGoCnlqScsIz6mIepNGUfRtUgT8siiDn+Zrl5d7GWthwQmtvw0szbx66xONTxLcfLdQxKxt2ShkhVDpYTxtmXUJA7yY2HLx4NZqkZBUnKwPr28YXaq1pNs1X6wjAK3p0MgYdCotVMELYsVwm4TrAg9AW7ARC7izq2LCvBscLfkbl0VMPhE1f2zDkAL4jCQDOywK2W9sIeALMN+PSmxeunD+SqZtanYE5ePGvJVQj23CzbaTxrXBS9X7KI1kUdqn1ODbYmi0VJ2+Hz3GLT+GXsM4TMAVt/grsiw+q8LAn/JcCtprrsDi0a57/iV+KMuD3eFQBZ79TXAUPvoDTNhtoDG0wYgyL5aIt9ke9l6Tdnt9/3jbwNBvJOGrDWCFGTWjl7hJuyQB7OD/aoC098lyLalebtb82lhrOS7W6xgf/r7uDIuabDW0rTx0nwPQRTxhOlkglTEYzaonzE4oRfb4q0AylZcIn0mqHweL+g0JOEHgsLWRbQBdtBs/BGlVx0LddIDJlTgyfolQtb+Vat+njpNOSRib7NE74ynSw7KB39QbGZfIVZk5G4VjbH+IGm82uq/OxFP5omq1wAeEN5CXFAo3DxbdRpg8tLkB57D9olkisvJP+NcXhqdKQXS16nBkRPz7JG7IP88VSTTof2MDlfSOsP4ldZQpSoVjSlywtwf5qUIOSDIPKpyJ14sj1JSSb23pW5tYOxO7TVtohBTYK1BF3dDpf/zhrt85tPhyxio6cX1Z85oWZRfwqjLP/7ngi3M4Tt1D/Z/XAqIFLw9TtOz4see3gxfwrd3mbFLVjeYJL7GN+OSpe2vDINPZycsz6OanOYeLpLcThVBvnye4q0KbrjGqSkFKuM4g4+S0ScCEO5+6YfyXP5pHkXuKiVUV2FvjZTDkE1JkQee1KyGFkZybC7zD3uY
 oxy5Lm4T
 sPULzzgOHrW61W/YdwjbxYrYIGR3BcLvx3OLwc9zKhlhyuygKCh19gb47M5Qs5gVRbtdKYdBUk2VlOQ+nawQ3PaM+DZEnwva4Rh8GX+ctryo831IcrmkBYT1wGmQ8+hrGWlrlB6ILaFYVzzyn77q9tLz/KaBs3JiXgGrnJOLoH9NdjwGP5UaxQMGat0B9r92mTb2qy9/UNyI2zqhMGxiW8Lt4XEtiW6J9tL0H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series fixes a few issues in hmm-tests that show up when
page-size and huge-page configuration differ from the hardcoded
assumptions the tests were written for (PMD/THP sizing, default
hugepage size, and related cases).

It also includes a fix to exclusive_cow: the test ignored the return
value of fork(), so both parent and child ran the same teardown path.

v1: https://lore.kernel.org/all/cover.1777870179.git.aboorvad@linux.ibm.com/

Changes in v2:
- Patches 1 and 3 are unchanged.
- Patch 2: fall back to TWOMEG when read_pmd_pagesize() returns zero,
  use a fixed-size array to avoid non-constant initialisers, and skip
  benchmark sizes that exceed INT_MAX instead of capping the THP count
  at runtime.

Please let us know if you have any comments.

Thanks,
Aboorva

Aboorva Devarajan (1):
  selftests/mm: fix exclusive_cow test fork() handling

Sayali Patil (2):
  selftests/mm: allow PUD-level entries in compound testcase of hmm
    tests
  selftests/mm: remove hardcoded THP sizing assumptions in hmm tests

 tools/testing/selftests/mm/hmm-tests.c | 104 ++++++++++++++++++-------
 1 file changed, 76 insertions(+), 28 deletions(-)

-- 
2.54.0


