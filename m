Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB8DCA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E0B6B0088; Tue, 13 Oct 2026 09:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE2E6B008A; Tue, 13 Oct 2026 09:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FD76B008C; Tue, 13 Oct 2026 09:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF4466B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:31:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A49F940CED
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:31:27 +0000 (UTC)
X-FDA: 85317689814.27.A772E5B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 314D81C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:31:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ueg2H0Ka;
	spf=pass (imf18.hostedemail.com: domain of gerald.schaefer@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=gerald.schaefer@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791898285;
	b=nmpzgcDmkwqJ/+JW+giKu9f4BiUjuQv9TmwNdDvlQzGL66ZZbIHkAryQmcjQQwohQFD1z1
	FJFLHCyYISqn1GsApha0YxML9xN6DK1oxnDHm7xjHbGyXzuv979A29wyjvnJMmmf+epQQ/
	WTo0cIsaP64IG6FtVBhdFb+snxVvDV4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ueg2H0Ka;
	spf=pass (imf18.hostedemail.com: domain of gerald.schaefer@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=gerald.schaefer@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791898285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7kvEJQaPDNDdTkfPB2lp3f8P59cG671gJ5eqMlzdMc=;
	b=uJbgGo9XOEt7c0MO+f6aSlHpJ35VRhQHaCeT5HJ57P+JHkQ9t1iRBaQz37dCibb7qj2Ic/
	dIJuBgWj4Qxw7eqlPKGO0M9Xbktrgwy9HNgI3rlowCH7Q0k4pVFuKBYjH65oLRpfiTfZEu
	w3SThUgTrHc5Z8dypwicOlaZlLMlEek=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2EtIQ1891889;
	Tue, 13 Oct 2026 13:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=B7kvEJ
	QaPDNDdTkfPB2lp3f8P59cG671gJ5eqMlzdMc=; b=Ueg2H0KatpC8Kok2B2+tSv
	INeSKM+dh5Jq7hC9ib4zNRJMqsZ9M2arzKTSaJzoHSQH8O5yzxl4TIjMZ7Suyscv
	+uARUbxgHUI6l0zND5n9H6d+ODg20FH4VncOC+hyeCaTBYmPoSxyJbwfiVQiPSe9
	y4CzbXACLRfW9eUdgmCdeStUVbLl8miOZRt4hksCBEp26ujHT/qOZMIY1Sgw/C/6
	xJG5WY5FTbfsxQr2LnH2XllVaXj7JVC/ukSbmb8rq64kcow8UE4vGSk47IahFs3n
	RVdOdnJJ1+zMx8+HepaoYvBL7efhry7MVicOUynD03oW1sMIHDWfrKwOX0CVB7QQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dv3e9rt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 13:31:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69DCQ7Cx2660046;
	Tue, 13 Oct 2026 13:31:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h7yppt6wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 13:31:15 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69DDVCgg13173040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 13:31:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6CE52004F;
	Tue, 13 Oct 2026 13:31:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 520FE2004B;
	Tue, 13 Oct 2026 13:31:11 +0000 (GMT)
Received: from thinkpad-T15 (unknown [9.87.131.228])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 13 Oct 2026 13:31:11 +0000 (GMT)
Date: Tue, 13 Oct 2026 15:31:09 +0200
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin
 <ryabinin.a.a@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v8 10/15] s390/mm: Cleanup pXXp_flush_lazy() routines
Message-ID: <20261013153109.5d5143f6@thinkpad-T15>
In-Reply-To: <964adeedfd20d4dbcc9a6341f57ec7aaac6c6adc.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
	<964adeedfd20d4dbcc9a6341f57ec7aaac6c6adc.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: nbn6L9Ekh3ehchxzuRjBBJZzbONil6I2
X-Proofpoint-ORIG-GUID: _EMY1DVppaZqn56vCK9_9jqVJYlZCfvl
X-Authority-Analysis: v=2.4 cv=aqInmiZV c=1 sm=1 tr=0 ts=6ace32a4 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=mmsD3Eh6YA-KHFnkoBgA:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA1MiBTYWx0ZWRfX4602m6zcTb7e
 qnLVW5A8CULLZLaZsTQHpjdHHPNRkjITA3O4QcvhC9OxNWgcutb90Pbn+OcczOHivkFFCc4XTzP
 vf/qTWv/k/dcKvOJOsnC+DQt5KjrYzw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA1MiBTYWx0ZWRfX3Fny+U00kJZM
 hkCrydYS+YKWHg2EFbUCegrwD9C1TeQpoG9e2n2Px6hZ+4aPxLXZo2RxTgpuP17VgSe9rQwK8jq
 ztJtWhCdvwsXm7dsZLBluy+Kxljg5wWVMVVswfoXi8HTzHesLME09BVlOwFdXZLt0gp/SvDV6Qf
 L6o2mVak+nqIUgEOQD1Rs8EhFapELqUj0YWWjypFo5Sxplxkzm322MQQOxCeuPiAXxQNlUFNE+u
 Q+wCMRNPFnQbSNZijrZs4ZLpz3f60T5GJq3Rg+Iux5LZjScPmV5cbRFLY89o+K7qtU4YQHBa+HO
 vOMNjCqhJtqhrY8UIFZwEm3etl8+9TqkBgZwn/kvDZnARzdNlMJOhZlD/KdPM3X9SGKTtOOq9lg
 Q1TwgMYq/AhqmyUKIEQfmj9ywVXSdBsqQYZt5dA4BK4A+L9viv+EnOsuoX1dPYhHaLRD5qlxDWF
 3YvIYUV4Kx51wq7UiLw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1011 spamscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610130052
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 314D81C0004
X-Rspam-User: 
X-Stat-Signature: gdwsnr1u3apm6tijjmphdyh5sczxwqxs
X-HE-Tag: 1791898284-499274
X-HE-Meta: U2FsdGVkX19xJzkFvARhqVN7B9Hj7QQ5JuPwr+xTwX2dXsffbvl9Ata1/AsUZGovutzBo+hE1gaF2CV3yvHQZpU89se7oT9Fu6omkSZKTrk2i1TISXUA7nz0lI2rviiJnXce6SxOIiNI47KZYIQktT7iWdzZuSW18ETg+Kha3ldKnEWzjykE9VPh0IlquVN8/ZA5SouByAJ/3nlGkGstf3es7iWCLXSXbwwupKnsh0cQxQn/yoCwhz3DlLCqMd0KejpFavIhiqq2pYIcdAVw2D0YXSmWocpwXE5AIWJ4pnXbpv3ziIgN+tciqRzzPWlrJrUKStJ4PO5fDvNtRouI54sWYSupBqcIv1igqCEePohY5b1dqDQSPcbu8QpUt2aaEoZ7leBvXpgzqX467LoBsslQ5ekiEb9UltNEchkh1F4nh8u5PBuRRK8jcwPdJORhWHEKQlonhdIZgoTpVydzFo/u4bcIMpbh5P1YkUYPylbM9qXM8j+VB667wGtFKFgQfYB2jye1asvAIaOxxKxBV05WpbeQmVly9haAsb6GI2iG1yHA/9mXyXRANocBSYEWrMzmGzbxms8fJ8ut4nz46BLrLyIGydXZqHYULV1hu06GvvfqtV2KuWfvuZxuDrRyJuPCAHWQYJNXtrTCKJqPoXBleSpazLLaETClWw/HaHtJdq1fR5NMwDhYp84u5DZXam9gnKgVI33cM1OV8oP8Z8nyYPJ4sypyXt6q05A2lANuHGZvB8GNijuHxjdz0kpY0zWZ9jU+7fFQbnprdePH3xTDto6ZdixvGuByurIuUv4vy/43NtJphm4h4Q1j5ZkYh9WPL0IKsbVdwonTRw03HHn65ZZQI6GTtmQt3dP3py99Dxr6cHzWRnq3HieCQICvw3+9GsCN7SajZaxWnJXr5cWzn3rty7c1ENubHw/FVcCL7ZTAbiGGSTWUNKJrC4ax6HeJkRkjxfLXW8NiEmO
 uof5ETp0
 EMCNtcX1bwfTBoXzUGsqlwArbGH86wL3ya/RT4lrUfZBfznNweeVLJ8gNx1/baCrfpZBmzvpexS3DT6vTs56Brr//gfoOM9A870lhqsqUh2ayLC2jRdIftUAbpQSDrURX+j4QI9wfMc+l+jDjsuymMAmBsnVGaBnBOPqZYzm6+H4pOap5BSDkCzLOR5TTMt6RaiFlQk2Sg44gMxZlrTBKNsX3hOwBeWdi8dp1f9mxBIyi3AS2QD8xffGrzzJvwcTK9+crtiCIne19uwGCBZEpCjx/6rscvTAuBQ6mxy0Br/a/B9rRKSrg58XplrItocTfpliP3PN56DZXlRo/H+xP3WjDl36FHfVJ8S/jF2zj3eX7yulDTo7k8xqKh63TAkGlmDYpIW6FZLm8PQopb6HSZmgQytEMwNrBj0E9/yd/ujHAh1KNjY5O9TIkN/+0D7GVFqXua+yz6NvBYq2XfrNwcrtKnAzNlIpRdfNzF3EkFkbsKQosIwPuqLb9hbNMHpjbOr3gLxfrNBofMio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Oct 2026 13:41:53 +0200
Alexander Gordeev <agordeev@linux.ibm.com> wrote:

> Avoid unnecessary pgtable entry read in ptep_flush_lazy() and
> pmdp_flush_lazy() routines. Use the already obtained value of
> a pgtable entry instead of dereferencing it again.
> 
> It might appear that the optimized out second dereferencing happens
> under mm_context_t::flush_count lock and therefore a race condition
> is possible. However, both routines write invalid entry bits to the
> pgtable entries and therefore no reader is allowed to interpret the
> rest of the value afterwards.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  arch/s390/mm/pgtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks good to me.

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

