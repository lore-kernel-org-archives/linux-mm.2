Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 404A0CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D75A8E007D; Thu, 30 Oct 2025 10:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987E2280003; Thu, 30 Oct 2025 10:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877728E01D8; Thu, 30 Oct 2025 10:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5BE8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:59:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27152140194
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:59:15 +0000 (UTC)
X-FDA: 84055088670.11.825DEEB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id C038A4000D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:59:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Xg4Syogi;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761836352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szkv1VBsV5AZDTc7OasVlkTIQXnkgGgqPoYbWRPezv0=;
	b=QqulBdCVyRXFqMGwoD7eguocdq2jqVX85fm2xTLt3ffAGn1gD+4lkVvbdeBH3PIHtjbhu1
	uZvMiA/DLkmdO/zhu/hPHW4kEmPppNuGdReJAVQOqSSLsdfJXZ41oPPunOW4eC8Hsh5G/9
	NTWvucKSMhrt2OwbWB42t0wLDG1sca0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761836352; a=rsa-sha256;
	cv=none;
	b=4o4Qw+UjdRXtvPndrDOl7zYmuR6mCTrFUp19jois3i+BAtL0IxxntheUCRpp5vCwY5toFM
	LLxKLlCCC3ezIKnJSjwDM+IHwt8LVVitGYppQKrqVxiSJ8jdN/gkpJuxwltxd299cDQkYo
	qstYjVoH2KKqynVh1DOARFgGVAJ+NpA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Xg4Syogi;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UDEP1F026053;
	Thu, 30 Oct 2025 14:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=szkv1VBsV5AZDTc7OasVlkTIQXnkgG
	gqPoYbWRPezv0=; b=Xg4SyogiVAXKcG6w/Yr3MNFxIaNM8G6rw3Ge3SywIpdnEL
	aX0YjKId0XAa6ZWEQCn87N/R+akWktPlvn+mBYF3je+YleQx0xY+Kn9rsMfg7una
	lDHteG7oCjMWeTHJRm7Mlj9afFzdgHK5UDu1LdsFuk9CqazvIUtv9hrsX7CxyS3q
	uzpCRaIeLnlf6abatyDEgDtI7dwL9i4jM2fduO0sTlFJ8KqdPxxRc96IhU5Jcyam
	ykX4WNcdoJuZjlRKA6uHLtQM9Z43W1UQcj+oPu+aFY7gIjjYeHCy2Vp63S+Z9U7g
	o1vaLXkczpvUm56OGkWMfWUoYNgoPgvX0aPjuHbA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34aartm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 14:59:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59UDJQLC019555;
	Thu, 30 Oct 2025 14:59:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a33xy99gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 14:59:08 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59UEx5Vs39256572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 14:59:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F313C20043;
	Thu, 30 Oct 2025 14:59:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F94B20040;
	Thu, 30 Oct 2025 14:59:04 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 30 Oct 2025 14:59:04 +0000 (GMT)
Date: Thu, 30 Oct 2025 15:59:02 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luiz Capitulino <luizcap@redhat.com>, borntraeger@linux.ibm.com,
        joao.m.martins@oracle.com, mike.kravetz@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        osalvador@suse.de, david@redhat.com, aneesh.kumar@kernel.org
Subject: Re: [PATCH v2] s390: fix HugeTLB vmemmap optimization crash
Message-ID: <20251030145902.16837C8a-hca@linux.ibm.com>
References: <20251028211533.47694-1-luizcap@redhat.com>
 <20251028145334.5a97211e0e46ca42fe2fa0d0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028145334.5a97211e0e46ca42fe2fa0d0@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ALkgKXG8 c=1 sm=1 tr=0 ts=69037d3d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=pnrwH9RaTRmhQM8EeXAA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: oHpYfSrcI6OOpyeOQezm9Vb57hP5iAPn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX0Ksmz6rT4f+q
 kKyfEFKwabEfiC76idkfmav3QtBTrTLlVq5CPl9EZJLL1FRpZjcwgIyZ/yCe5U7Tz52SMmHfxvs
 YywqnUnsfXy8K0JqE6CBFyvlIinM89AFPwrY+0cjDh3SRvvqqDBxhbLfPSnGd7617H49qpE1uwy
 WhPC5TLsd0k/nz73nTw+0+mqM0DR6nTBN7W8WOWGC8g3obWq74rYKlBlBIiCGqeIGRu1VH8Xplg
 XaGQiYx67SNpwNU2NMqyI2cUYFFj4ykOj7EJ1cn45xum+NF+NzEkQpW4fLKgk9hN/1anE3Vx0Ue
 seuv1applaZsC13GGepco+QQJNalq0VIZrZ+ht4xkz14OcRznwioLr4+4Zw5LHGXFeBmmMezlfd
 Dq/vHqbe+afSWyr+75yIH/nqXqmPVw==
X-Proofpoint-GUID: oHpYfSrcI6OOpyeOQezm9Vb57hP5iAPn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_04,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166
X-Rspamd-Server: rspam01
X-Stat-Signature: wmqit7ae7drhu8w6sd5hz6xrfd66wu5d
X-Rspam-User: 
X-Rspamd-Queue-Id: C038A4000D
X-HE-Tag: 1761836352-18169
X-HE-Meta: U2FsdGVkX181iS5hd3O0mXafXYgrF+o5t6wPIKyzpQb4IjOw7S8tR6Q1Co/skjm3L/sEcK6x7ltrqCMecEOfV+YtBn3BYSH9/gefBhHyMUlSbzXlsFIrokkoXBedgb3PAsq11ByV5egcFZj/iouIqO6HDpBTTL0ubZhol9UZTRiOzjyGqFeALkdMocs/9UIcV6r8hi6HXBJfC/1SzIk7sw7gFvyEa7zAHTj7zb9URI4LlHplAryx/tg7GquoSxrwdfP3Lag589ncFeMVvUEaQUNO77W6eXDnH8i1vc6G/cTVMlOZgV5HOcC/KxmRZU+Ms1ASm2gVSIgxP76Ac1AFlfKnACEuTfteiUe+LWm/MeIdp9f2NwR1KTg734U/SYdgeRDs7eIZDLbYrPfEHyaw/LDI9DlmHC02Y1/o/VFL/tMiKVWxlhU9ws2a8r3dhI74eVF8kGLfWVzh/nSCO4SR0Nks5NDkXp9DJKHU9nIf5aZhEornQXzeqpqZwT7GKv3Q1cnM2Rad2jqAKDMXpyNMkaQakZpyZoUQcXh805R3RCLyOSCPWafCE3QsAPO5mdt9JG1qCg9a/C5S2CGy65iUf37zb73iCKVA4lbT/UR5E8BMTlBNM1B89PmUMlXiE9i2dNoKUFVifWOr8C8W3FToDjwEWFwdYTyLij+/JNxWv6DOCOLcW8bVbYpqBU7ODwK1eeQBcSLrFNOVoVePCyA/xreNrYdiZ+KexCDB3KBWBfhJjOd5RPOLr8CPmkHEJBZk3oCO8ooobY20Nnhcw3/fwr++QCHtIc3oJ5C+zgS0GJwFPpJv/gftRNGLcQU8cUa6YW7Lo+gqta0l3vOPkK4SFdMSHj/8B4+9xDkZHtPTELJZCCBfAzYQinw5Vp67gjrl8yopn/U55c17HNR52hT5FWEdvsforVCShoEflirD2IgEofRk/O0hsNOGMdCRG68ZQDoUC+x7BQyS89w7BHZ
 YhskaKe2
 +eLwtJLXWwX5RoilzF2KvVT73bn6u++Tn9pjSnEkvod2XzX2M3F8zfBwDQ8b10Y0Du1V6ykxn20Xl4QhFxy8WbYf5yPQ84PKPGIatxBlP/yW+vTfb28fgUFsPyeyj3Vj1XTeCuQ/ss3ctDiEsxeuzpG5YGMvXOOMVJqlFW4q+2sLvpZuCOS0vVRsH2VRl1sc5g98/zytyP8+gg4Em1q66KytgJ68S2e9jotpffdbm71SSh0ogFDtAPeaKM4GorZL2PyzPO6UFIvkD0FOBbQJ4gOHyeSmGzKUmTPEgVbzGTpRfVzKXbXeXw4MVtY3vBjnUXVaaBPU2iWxMKKEC1rMdnydOEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 02:53:34PM -0700, Andrew Morton wrote:
> On Tue, 28 Oct 2025 17:15:33 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:
> > A reproducible crash occurs when enabling HugeTLB vmemmap optimization (HVO)
> > on s390. The crash and the proposed fix were worked on an s390 KVM guest
> > running on an older hypervisor, as I don't have access to an LPAR. However,
> > the same issue should occur on bare-metal.
> > 
> > Reproducer (it may take a few runs to trigger):
> > 
> >  # sysctl vm.hugetlb_optimize_vmemmap=1
> >  # echo 1 > /proc/sys/vm/nr_hugepages
> >  # echo 0 > /proc/sys/vm/nr_hugepages
> > 
> > ...
> > 
> > This commit fixes this by implementing flush_tlb_all() on s390 as an
> > alias to __tlb_flush_global(). This should cause a flush on all TLB
> > entries on all CPUs as expected by the flush_tlb_all() semantics.
> > 
> > ...
> >
> >  arch/s390/include/asm/tlbflush.h | 6 +++++-
> 
> Thanks, I'll add this to mm.git.  If s390 people prefer to merge it
> (or nack it!) then please do so and I'll drop the mm.git copy.

Andrew, could you drop this one please? After looking a bit deeper
into the real problem, this patch would just paper over the real bug
(and it could still happen).

I added you on Cc for the bug fix, but that is supposed to go via the
s390 tree - just in case you are wondering :)

