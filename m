Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E03FE5210
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80256B008A; Fri, 24 Apr 2026 07:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D314B6B008C; Fri, 24 Apr 2026 07:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C205F6B0092; Fri, 24 Apr 2026 07:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B388D6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:54:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6557016011D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:54:31 +0000 (UTC)
X-FDA: 84693291942.21.B6BB438
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0B5581C0007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:54:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i6H58vB8;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777031669; a=rsa-sha256;
	cv=none;
	b=RlfQLuZaUF9Wv9PG46z2QYh/qxEPU95uzbZqeiV1Fz1DFtiLIOk3c/JZa6Aiim+gEOcZKo
	QcqAjy89WeR7PeNl9mcwdlRKE+iYMdIYQ0ZKvXNSa6IZBha7swKT5FOpF9pwW3LPp0FL/e
	y6dPu0L8KAHlMtfkB2hhCMrhdsVN6hY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i6H58vB8;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777031669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wAdlqQB/ZcosrMkMEnAlX1EnYA8Qltq05LW3i1TVMI=;
	b=BhipL4urHZmvxOHtHo9gqsc+XhNuZEmxVXv8+Ndz45yqnD5+dpgJ2ImmgMuyHoGTG4/lld
	HvON+TvQxYcEuWUaq+pEWiwv1KBlkTRFlqWnrPiOhT8Itc5X7c6+wr4+U1NDFHoDCxw9KD
	tmlFLvOgkFC3T9EWYnexLc1SrHu0ysM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63O9sItb3229011;
	Fri, 24 Apr 2026 11:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=+wAdlqQB/ZcosrMkMEnAlX1EnYA8Ql
	tq05LW3i1TVMI=; b=i6H58vB86JvZ63VK4wgXeAOMV68a1wClDNsat1FP440E5s
	uTZkhPT9c+IOp8oP7ijZG4W9c/OENGf0k2bVIVyGbdsmerb86UdOuGc7T5THi/qW
	gzuZyWx52kr1GahEUY57znw58696lGWndDxnhAfPHHTQIE8ZM4v8I60+wsv4N7i9
	O06IDen1PXW8iQM5W7m2C5zGTfQDdcN8lMXhjveniG6dt1zF0be7ctfslTHkvFTp
	xklAsOOP5GRrZU6BExqguzU8cOsXaP5f7orsNK6YvRSsDwNa/pnkyUzzzf4ZfasB
	zEApF4MmoulRvPIqvhw3QHQ2Bn8+WIgrUOn8lFAQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu2dm3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 11:54:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63OBoGIY014370;
	Fri, 24 Apr 2026 11:54:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjkytmxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 11:54:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63OBsJq647382898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Apr 2026 11:54:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 819DE20049;
	Fri, 24 Apr 2026 11:54:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52AD520040;
	Fri, 24 Apr 2026 11:54:19 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.52.215.75])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 24 Apr 2026 11:54:19 +0000 (GMT)
Date: Fri, 24 Apr 2026 13:54:18 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] s390/mm: Complete ptep_get() conversion
Message-ID: <0ce9c2f7-e9cc-4018-92fe-a2a966889181-agordeev@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <7ad766612a3095c8c8d9a253ef0f484ef98196a5.1776264097.git.agordeev@linux.ibm.com>
 <20260423105118.10371C15-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423105118.10371C15-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _tBjGR7m1MDL9l7NnWkpQNGHIoum42SJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDExMyBTYWx0ZWRfX6ZIBUbdeUSbk
 iC7bi1WAG6BiKq3V4pqZWM2UVoSJSrI6Zga/HgzDb6o5DuDExGC4v6b2DvPUlDPhceYB3yzJeSd
 W9hIimXmraCtp5Xd9B2x3C41Ag8T9o0g5uxk0UnBHsagVebB0vjbKnNZIy83Er4UnDHS1dHQaPi
 0StRNyIzh1aXvQ1swzbVBkM0pVN+8DgBAVgrKXa0rJN8qWlHkxBLxWz08tuGOhO5XZ97yVjASK+
 bIH9Egf2utbL2UHK7ShiYxwT6hSOSFUKsvQQXh5SfrYiYrV96aE1yvZW7CZ667E/rGxkFA0Iahg
 Zj4+IwVqJtbyU+FE4jOQaY45PjeI3AWZ7tzeQFBESVtNitX30EfHe/DdRJ8lGq2lHpgPPQo48kN
 ALc1cMIhOejsjIYOBXgX0AQewO27u/LRgzE7y1gA7PuBsJrY6CFVqXJQ19CNBCVdJhBqZYpmgno
 DLOfZN1AUc8JkjMjWkA==
X-Authority-Analysis: v=2.4 cv=C8LZDwP+ c=1 sm=1 tr=0 ts=69eb59f0 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=7-lpDXNR-v68OR7j9qkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: _tBjGR7m1MDL9l7NnWkpQNGHIoum42SJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604240113
X-Rspamd-Server: rspam10
X-Stat-Signature: i7p8suhez5hb7bspoz4ime83bagx36w7
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B5581C0007
X-HE-Tag: 1777031668-492145
X-HE-Meta: U2FsdGVkX1/IOlvffRuaMw3p06cgnrGya9CpF67TG/+dgVXU+PY7dw7cGehZtJEKAGmGMQ7T9FXHLjiFkAOH0d21ACD0jtqkKsHWM6Uwtn4Y1lN1UHQpME5wpOgk2afbtJ32Fgy7ZLDL3YJV0jvp4kFAxwhxLEVaztvFwFkYo0Br650oDoGMmogGrcZxkUDDlaHNBh+d+htbfWc9wgx7dR2eLdggZ7tBGwLOfCzL+3hhsDnsfKgUgwnSmDyTKUnA3GBxo52qj2+8Dv2FewwoMiavLFTXG3C6ZKC5/dxn0+NIHKfv46rsO5g0HNYyPxe9xLWCw30GxP040iVHJpsG49nUWwXFgMMvVAM5ocMR3lp2lsCByxuJEbff2cIkgQqJb+ldmtPMrqFdlAb0gyskxullcvxdecUvyL6kxG8cgKvB2KPwM0+z/ZXuQW3CGwB0MSKczszXPZe8bC5vvSbOeXEre5ITFD6bv3j0VSZP8fbhOl6PeQAnDfGPRMUpHhYHQVSVxLOrMfuNbX81177+66SbhW+Y8vGV4c87dMFD3XsDVSe3PyaJymuh3GvR7snhQB0hFG3LrRpBsd3ScVhd2pbPjuf2OtbdL6tqIoDt4Xdg2Jxrnx4dRMHaqJpNz3k9vEDFUnlyxz9JdAvTWVldYjEoIY/aMi24Lii6R0chCsagFZANQyNYWSPEQmxv96W/BRBJKpi1YTlBhm19SxzWlqh0aF/Bs4dWjtq7Dc8ZqwxgH2QeAPA38B1ad0it1WoYjCk2qnLX26dIlMUpTlUfoTPDLqb1omXhKjqmKj5sMdl2aeQIj7A9C8mBQMIVWtjVCurSdF1ktaLQ3n1qpFIPbb/RWoLQUkGdmHIMaHtN+JX82G1LwnO2rBshO+WyRrFh8AWQcdzii5b7kaHUdfvpiFmVxgHxCyhBr4MbnbY6PfYt1uZ0yQ5fVDeE4Zq06/oTsHMYqJ/FqMKxoN1fohL
 XSVBvNpg
 2Xst/DHgDy/M+33Yu7r9F83KpfLZ4JJiD3fEWwh1Ys3dnSsR38MITet2bDxoK7pLENvCBWpmPXxo3cYsRQU31oD5z3nqTmaixQZ4EPdAdHOj0OejuQBjaV4ApFn3qp10IZSccq9lVzwdrDvqSYP5+Hc0eQxymhGyNplWIBp/ZqNvdf8MR4Wdoi1C74DQPu+LM5IWProURiXIPynykTg/UrdU1ow8H21fPUJqWh0K3WnkUlmmsYolBdKKjjBp4/8noPbFuLjusDL0ATL2EjrEFyyvnkLtgep/WEZKszUIXyrEEQLDRgSgSQrZbeH0jT/xqENi0BBciVwgAEyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 12:51:18PM +0200, Heiko Carstens wrote:
> Was this a manual conversion, or did you use some tooling?

Manual :) But I will try to recheck with a tool.

> I'm wondering since I can spot not converted locations, e.g. one in
> __kernel_map_pages().

Whether this fixup is fine?

diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 3a54860cb05f..e6f788696dd1 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -455,7 +455,8 @@ void __kernel_map_pages(struct page *page, int numpages, int enable)
 		nr = min(numpages - i, nr);
 		if (enable) {
 			for (j = 0; j < nr; j++) {
-				pte = clear_pte_bit(*ptep, __pgprot(_PAGE_INVALID));
+				pte = ptep_get(ptep);
+				pte = clear_pte_bit(pte, __pgprot(_PAGE_INVALID));
 				set_pte(ptep, pte);
 				address += PAGE_SIZE;
 				ptep++;

> Besides that:
> Acked-by: Heiko Carstens <hca@linux.ibm.com>

