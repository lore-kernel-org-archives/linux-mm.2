Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F99CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7588E009E; Fri, 17 Oct 2025 10:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767F38E003B; Fri, 17 Oct 2025 10:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656958E009E; Fri, 17 Oct 2025 10:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8278E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:49:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90D17118B69
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:49:41 +0000 (UTC)
X-FDA: 84007890162.10.326C52E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 28DF41C000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:49:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CFv8xL7e;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of borntraeger@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=borntraeger@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760712579; a=rsa-sha256;
	cv=none;
	b=fa8REMJ5AnrQeBTen3vUwr+knJyghGtI8S1TpluBCMQAF+CRBfntHzieXSVvGnlIQ2APWb
	4ommZ+PE8wINnDCj/YmCiKVpSF3RXEYn4+8B/3kDuERXf6QHsooxy4SFnwR/kvvq/Z2Osc
	5ixv8FMpUYmsuTmdyj6TqzaId6WTVT0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CFv8xL7e;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of borntraeger@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=borntraeger@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dSIPJcwALWv0mVTVQ+ng2o6HtT44rWSzjve/F3qb2c=;
	b=58+WH0CGeHQPG8gtFL0lCsEvyS4QR6OCRnqVa5w1SyQqrQ+2/Nz69W00Anco3hUsHlQqOF
	3Xh/wEqYN8qDNdmvmd96t/Ww97nTJrZPvMaI7JKD2rGqGo9d6XVVJO0OSSiAoPtWw+3USk
	XZM9XSU1/a9tWVxCdRRNX7yUZTJUVvQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H9mRcK001261;
	Fri, 17 Oct 2025 14:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0dSIPJcwALWv0mVTV
	Q+ng2o6HtT44rWSzjve/F3qb2c=; b=CFv8xL7eUVUkx8ILeVfw51sxDDhOTJXU/
	QhUYMw2ivVvlQOmE+R9v5m9RcBTs3yiwLvE6058CuKstPDE7V849dxNKgACjFmEY
	wnj8rImQh1YPTyI3CRtznA0DW+tVCUCBnUQu3PCYbqB09g/GXtjR6S6J/KEeCm/8
	7oDsxiVfPwPz+DpQZ4/fTN9ntp4MmdjM/ggYndZk0YVpAXU6QuEg62jk2Vg2haXH
	tSeVJXccCucjGnWJxKxjpugj7dGl54YaRDvSZ9oyJ7XYyfIyxd9T5MdiycCDpAek
	cLD5E4bmmjYh6codnEhjGoucnk8x5H23sILHMtd5QS7Rvy38ZpVGA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49rfp8e8sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 14:49:31 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59HEnVhc027905;
	Fri, 17 Oct 2025 14:49:31 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49rfp8e8sa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 14:49:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59HC1xU6003603;
	Fri, 17 Oct 2025 14:49:29 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r1xydwuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 14:49:29 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59HEnTEn34210530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 14:49:29 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1316458059;
	Fri, 17 Oct 2025 14:49:29 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE57058058;
	Fri, 17 Oct 2025 14:49:24 +0000 (GMT)
Received: from b35lp69.lnxne.boe (unknown [9.152.108.100])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Oct 2025 14:49:24 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: balbirs@nvidia.com
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
        apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
        byungchul@sk.com, dakr@kernel.org, david@redhat.com, dev.jain@arm.com,
        dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
        gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
        mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
        rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
        simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: linux-next: KVM/s390x regression (was: [v7 03/16] mm/huge_memory: add device-private THP support to PMD operations)
Date: Fri, 17 Oct 2025 16:49:24 +0200
Message-ID: <20251017144924.10034-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001065707.920170-4-balbirs@nvidia.com>
References: <20251001065707.920170-4-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DfklAXPcfAtrNGM5jY-KNpF22Kob2KaG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA4NCBTYWx0ZWRfXwJljw/lEqKWM
 D1hwuYVkDKLS/aDjhMhaRxdkXUSsyvHOYS97+v4q1edG+GxAcK4qeURdagJiI4mVK2s6N2IiAW+
 HcUFjBszJ89TY2a8nhqnMOY2r9Z3+6/toRhinLlrnZKDkls6dnQVfAEy/mphOIHvkGfmruukvpI
 eh3FxlZBm66BejMBARNCpb2ZZU9PMje2quJEIdM0sotJ6Lbj+2EQjXV6LOsocpdP7nbV+JEub/Q
 zi1OsQ1dlXYfwTnKwlvoaj5KWRQdtidwWKDSBBb/l7q+Ydcv8NYUkQuzj9YJ9fvOgoB5RCWm2Xh
 hHWazhg6C7AUK0gqCe9jK8iyOw7VLAZGw85A5ldyo1xtx38HBNkzQd7K4fMOqEXoBf/r28hVYoL
 R+KqIHei+dJEDX1+JlW0IYYc8R3Oqg==
X-Proofpoint-GUID: FMxTvdFdAsHpeQIzVN6T6lFv6ZTA0cpa
X-Authority-Analysis: v=2.4 cv=af5sXBot c=1 sm=1 tr=0 ts=68f2577c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=axXWKVb_3fx9jgWgKzgA:9
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510120084
X-Stat-Signature: jeuifi974otcsth4mnwyjx6uy1y7rzx8
X-Rspamd-Queue-Id: 28DF41C000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760712578-458919
X-HE-Meta: U2FsdGVkX1+NdDe769KhMoZ8Wl5VtVCT8MdmyvFYmp8aoMvPgKCvWAAAE0E0B/4Uk1QUKRAOamgDRR4oPZBgY+tHkZvyHy6WhSkQpd1okece1zEOLuMN79HuwB0RiIPemoPSe8z4mCj1qdpdG7rzMO7VBEP0soQMf7fP5aoFA0BKeBnb8Xa8u2Y88Ynif9OCDYVaCuLL+BvNRmQdcKgLkSzrIyuahBpf05C3g2BqO4CWLzgBiNm15OoHQFmJx9b+2NtArgW1sVnlKc2s1xgwOto9x4i0gpLai2y9c0zMbXrkwWUy4IyhMDXLO47WE0jn0XIuPkak6RtNcD/G8bRd/IE8MphyDuvOHp00XYvv8mvvcqoQ05bUY1FBrEh1smOCrV5kMKeF7l0Xc6yEyuwfwhUpKeNyxOYmhEZW5A1BLPIWFvTfn3VZ34gxfZGKT8En+NIblixL7vp5BR/buPuGDgdE5LRDESj/tcI9PNFpaYcRrHrEFdJ7DaQIxsAgr0MCUSD3luVwoaqfRZ27toUqtCrosqbrV9HH1F/z7oB7vR+8DuDR2HsEUg5AwqQn9aaVdxcTl2iH5MwnLBMiM0FDL9VEZQGN134atWNHXErjEbRGSghOhuYIvuU0/l7Or3obHRVj0PJdtfZ5lmV8XXdvOB8OVDKUiMxQRDjBBORqfKdnZBj9w41wiEbygAB8iwRFdIS3/KFY4nU6dHcvuxNEvBxFfu3fMGxPaUrTEfWiGIkqH/gfvEPVK6S8WK12hkv0eUb0sen+Vq/os6TJmgAeVd18Oeh9JQGn56+GX8M70P5bzLyaDUAxIUy7JD5sQcKSDPzL8u2w/7ZidJODnip45JbzLWmPM3bFk1lg4rlwQ3rFQnj6GAL9r4mH1xTcHgsi7SR/mb0+x9DqkZV9b/AfAmUQZ/BScaWDTFvH/ZCxc33utS3ByJJTzujk7ezEDKPnaDpqQJ9ulMtO5g8i75H
 BP5HGCKt
 dyQeFfEiEkrN9H7oGu/Uhu64Q4MXn2lZ6e5EVdBHqQBxgdkbNcuAqUsrD5ph2VSAI9mHRsPzaWiJ7koIH8ouL7ZGbuuS7ZLT0DWVfhknpUms9/PHxIjxwthDGLJR6hIW1wDpejnJT+crgPWe1wL7eX3QL3eIerI1UNLS6OkA8JefI4swpGAIwXO2Cg2VqTa+4AkW5IoI031rKkIJUPHBPO0432ok4DO4TgQ4PKVZTxLV646MBpCzeiDZZVFSutwikKvbwM7AgToQ5iTl37OcfaRl66rGvy3ViyQnhgimIFv7kpQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch triggers a regression for s390x kvm as qemu guests can no longer start

error: kvm run failed Cannot allocate memory
PSW=mask 0000000180000000 addr 000000007fd00600
R00=0000000000000000 R01=0000000000000000 R02=0000000000000000 R03=0000000000000000
R04=0000000000000000 R05=0000000000000000 R06=0000000000000000 R07=0000000000000000
R08=0000000000000000 R09=0000000000000000 R10=0000000000000000 R11=0000000000000000
R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
C00=00000000000000e0 C01=0000000000000000 C02=0000000000000000 C03=0000000000000000
C04=0000000000000000 C05=0000000000000000 C06=0000000000000000 C07=0000000000000000
C08=0000000000000000 C09=0000000000000000 C10=0000000000000000 C11=0000000000000000
C12=0000000000000000 C13=0000000000000000 C14=00000000c2000000 C15=0000000000000000

KVM on s390x does not use THP so far, will investigate. Does anyone have a quick idea?

Christian Borntraeger

