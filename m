Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3E3CCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C7E8E0016; Tue, 28 Oct 2025 09:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34258013F; Tue, 28 Oct 2025 09:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950C78E0016; Tue, 28 Oct 2025 09:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81CF58E0016
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:02:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2962AB8DE2
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:02:16 +0000 (UTC)
X-FDA: 84047536272.23.D80E0DA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id C49A540004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:02:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BdygRNTl;
	spf=pass (imf17.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761656533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+oHSK3Wn0f9C36IapLRaRQi98NQen+5vx+thDJ3dB1o=;
	b=mEY4uCa7OoHwVT9IgpWmfPuS6QLMcEVV/f7FHn3Vic8SyF/wtoFGYStRDVFv9bLwOHIewa
	p/bYFaOqN0nTk7w3ICp7Gj5mWzxGBzNJWNRA66iuVQ7WmzSzwqRyBHDetHCiL5EPcDQdMN
	elQ5AQ2YwmYb9DJPZDE24Nt7PvmRaB0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BdygRNTl;
	spf=pass (imf17.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761656533; a=rsa-sha256;
	cv=none;
	b=YQk+ZUSAOO/V9NkdRmXuID0DZBWvW+f4AVObM+Mqgjf4R2SObaHX3EEtaB/kKdBEGTiPMH
	OPfumufZf4Bh3K2n7/P/6kunuL321+XZ8wLgx37C6kZ/KauDbugpdGB54CEsLcwOXioksY
	dOs9aTPf8I3bwWWHs3NhOQYK9px9cXA=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S41AJ5019381;
	Tue, 28 Oct 2025 13:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+oHSK3Wn0f9C36Iap
	LRaRQi98NQen+5vx+thDJ3dB1o=; b=BdygRNTld3droNAcxcRkNVzezz3YSaotl
	tc101bYpC35KLz6GGndl9JWrswb8t4WJzj8B9y2F+e0QRWLJeWURs11TOcnk9h38
	P4Y7fu+VVZ1c6Ib1Cr/lp65nKsF9kdnPZgxHRYHgUZ5cxLvi/IhfUAfNSCDboSHP
	XU+R0hN+Gl7v9VXxotnRjWhEVVWaJCbpNCuyvq+8EM9pA27Er4HYaZgTRk8mY3HF
	XhTY6BryWOchXHZkVnCuU7dtvVx7qupv8KfWbeEaegyVZq+I5LT40ZAuPAp/HBUf
	4lmjLxJGUnWCZjS63Le7i4IOvcnn+WPb7N4fejg4eGj8QxKObnHmg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0mys3vwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:01:59 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59SD1w1A002820;
	Tue, 28 Oct 2025 13:01:58 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0mys3vwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:01:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBii72022886;
	Tue, 28 Oct 2025 13:01:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a198xjust-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:01:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59SD1pYn59769092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 13:01:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE2F420043;
	Tue, 28 Oct 2025 13:01:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0898820040;
	Tue, 28 Oct 2025 13:01:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Oct 2025 13:01:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: akpm@linux-foundation.org
Cc: balbirs@nvidia.com, borntraeger@de.ibm.com, david@redhat.com,
        Liam.Howlett@oracle.com, airlied@gmail.com, apopple@nvidia.com,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
        dakr@kernel.org, dev.jain@arm.com, dri-devel@lists.freedesktop.org,
        francois.dugast@intel.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
        mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
        rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
        simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: [PATCH v1 0/1] KVM: s390: Fix missing present bit for gmap puds
Date: Tue, 28 Oct 2025 14:01:49 +0100
Message-ID: <20251028130150.57379-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
References: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1IWaxgKcCbAX9g5eiUEXUSG6dBW8TC1L
X-Authority-Analysis: v=2.4 cv=ct2WUl4i c=1 sm=1 tr=0 ts=6900bec7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=MufDUWcMhQhyWPk8zPQA:9
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMCBTYWx0ZWRfX6Uvt5YQT4Rzu
 Tqc2flA5F4AywAliJ9GXPbqvkkbBuJVPyZyvNiaY7+M/pj+XSET0R0dwD2xHsc/WXb13c/R1Cjn
 Za5QtJZlG6ZTkuvrx43BGLO82Woudw/pHuSQXcaRwmg3Lw6YmJ7sjZu5i0MK7ctxfkxJQxK66mJ
 iUydtgZhoO7Sehzgvtxrb+VHYtsVaadTSVdkAjgZhCQLbaYmjKzlt8/gcOrHOVpevOPP57IYzLv
 6mfnnQJISIym2RFVnBtG8szVTssvL9luBu3qa2k8x1JLhes6sA8bMrPqrgAWSPManWYziIlF/Fw
 EzpQvpBrq58QOph5lnVIGQDcv/K9ufmZ2IfgUocUxknLybmR07ddRAZKMUmknhiqTzbK3UaP5f7
 DrTdt7VhqVn6zRemDJJ7w1VsUWz37w==
X-Proofpoint-GUID: 2WzbgKRyldG4biHvk5FucE2LQMmFKT8t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250010
X-Rspamd-Queue-Id: C49A540004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rfdkpfmk1xchceuturmu3erceya89r6k
X-HE-Tag: 1761656533-917863
X-HE-Meta: U2FsdGVkX1+bOGJVEuDwSFlnp7X+YgFF2Sdjx8O3Vz+sCmJSZUqRxBM4YvDgCzuGTFBxEX8UON6aGkwUrgpT6e2h/+S9ZGohy0s+oSbuJCJeoG71y2uUYkiHlSSchPNjI8TePkPUcM0AvBu0T1UF8x0UFCKkCL3nMi4CyVrQkjX+ZIPlwznhpqJkPY9ae5+IgAYynbkpCj6X994nu3SmM6MhO2eIahv2VsdbAE4PFrnQtspcGglBCXEJo2y6tdoMvnHYgrsGmvB/e+bqiInNr9vsCbZZ3v4vC12vdopV8TGq9M0oHPoM+SLqydyqmqGPmQOla7pHkp+V4GVHSwiYKsPZ9BwIa1OpcZdylxvhCQ7RIZk809XGd6dyz7oior89fPYTZkSjPWDxEkUNzdy1pRb9H/RvzAcr/8WWJ7xPFWo0JiOqekgBPA1O5XjTzmeVYviGQb4vYVeBOiTHGhuzFDvwgxr4DCAi26VVisT9IfHwprNPDXjtWn0Uw3EDn3Ze/S9ZCcpcIHlVmplM2cPG8taTEo9uODTcb5fEPZJUjhkIGardD5/tiKwIwXokhfuFQcxWgF2CiRQ7cnwmMGzJDdmWDrjOY0qh48vchFisq/P69J4zYUY/TCj+Hvo6xDUjlq/4dDkZgLgDRUQNL4Nq4Ubaot1RyXcpZlXhkHI2el0vT9Y5qM98/hXSz+PlLhGelCxuQmjyfgGUplzSRvbTvQJnFinyE1qgBKqwqAD4GUBqPVCPfOtXfX6J+t6oHUPnrN0HQXK7c48mTMVnfxaBcco5BzZzLSV1Ch3L6Z6tKtrsHzI6cv0PWcEfENjN5mgbe5u8+mpNhppEJO/a4GJWv3u1k2EykI9rvc7aJ+PRmv7WmS+AaUgVtqkcExMZLPpjgzRJUh1fKoNzir7j06fUaQVWLlXeNJuNKUgD5zBgucDgv4UWPdrJGVycCe/ciInsJ+YNXngkA5aO6CyORdT
 GGQRhcXj
 Gu+6Do7J1kLe0c1neu2YKfeh3SDCulJ9Se5QLG2u5pM0ZYVSVAWyXORRt52QUcTsQadk3mfQwom2q/HqihZ3SFQr8bEkX70Kbr5PisCZlmVL+oiGlG3owJHFBQyzn6gKEKW0uZukAz2usNgvaAG1rkxdFBSQdqWSLrW+na+Yh3rWId4lp+uzDCAn6X9Xn50fxSTPjuswaoEFKVRNmWtteTd6VJwPEYTxCdjpCVpHBwlylBFGW+jVs95NbPxeZVjpfSbZy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch solves the issue uncovered by patch caf527048be8
("mm/huge_memory: add device-private THP support to PMD operations"),
which is at the moment in -next.

@Andrew: do you think it's possible to squeeze this patch in -next
_before_ the patches that introduce the issue? This will guarantee that
the patch is merged first, and will not break bisections once merged.


Claudio Imbrenda (1):
  KVM: s390: Fix missing present bit for gmap puds

 arch/s390/mm/gmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.51.0


