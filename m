Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F56FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1F76B008A; Mon, 27 Apr 2026 05:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89B76B008C; Mon, 27 Apr 2026 05:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0CD6B0092; Mon, 27 Apr 2026 05:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B97096B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:01:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 582EB1C09C4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:01:48 +0000 (UTC)
X-FDA: 84703743096.22.51DB5AF
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 214D42000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:01:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DgStsnVo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777280506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmk6DXmeTYCrC2/6PymHBcrqJO1bZEMLU2hVDCq6V40=;
	b=iAcWZfagwxG9U9ONY3diNDODpu/FNECVvjbZX3pTARRS/tv1u2jRdyap4q3uBsHPARfe0U
	SZopXx6/SSnWc0DetJMidCzW7eA3aeslidaDmqTA1UDeMMX3Siz5dsH3PlbtaItc3s25ku
	H2teOYVZHBmbRR7pY93XDGI2si2MBUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777280506; a=rsa-sha256;
	cv=none;
	b=qPdYVNjHPdG4EEXdLxncUl8Chan2oYFI/NIPKrBK7Rx6WWf0VoZeCZMgtklFVzEr3A8NzT
	Uwgto/TJo4Rb212sGOX3GHneIjVUelNLuAfhEM5YyXLHEQCzU/zOR0tyQrlR+vQ1Qjvw7t
	I1CPlHpCq/GiPm9K8eg4KrqzTQPHYtw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DgStsnVo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QLq49J2652173;
	Mon, 27 Apr 2026 09:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=zmk6DXmeTYCrC2/6PymHBcrqJO1bZE
	MLU2hVDCq6V40=; b=DgStsnVoyg2jmP8mzAEZ3VWAASgzbCNOBDmIydLGpwoaXz
	JSX0iJEGLHjjYabX0BGyO7JasE+Udqo+3RTHl3H+VPXQF9t++oDmdg2bZkIY4BnR
	VrQQXHEPCUXRaA+fbnEZqXdB31Jy6JArc4QQByhiJSoDLIf32V9bK5iFPGyQAI+q
	BOVBsvmhalb41CIZJMREu0GRjvwL/wGJt6IRtTT4WXuDcmNZmo7LEBEGMvyHlzvU
	JcxegxLUtxtZnT6mHDICyl8SqCvJII++JguqOd496OFOVDudzQ5a3iFHkmVPfrxO
	PkT8w5dqc7eGvWdQj9ZVyNW2LnwF/Bngo9mDQ9jQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn8v6rdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 09:01:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63R8rtP6004685;
	Mon, 27 Apr 2026 09:01:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dsamy47ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 09:01:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63R91WsL41615756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 09:01:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1960A20063;
	Mon, 27 Apr 2026 09:01:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67E9C2004D;
	Mon, 27 Apr 2026 09:01:31 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.9.29])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 27 Apr 2026 09:01:31 +0000 (GMT)
Date: Mon, 27 Apr 2026 11:01:29 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
Message-ID: <570e049b-1e9b-4030-9f80-d44162979a50-agordeev@linux.ibm.com>
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
 <ae8g4jipQxQZRe6E@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae8g4jipQxQZRe6E@localhost.localdomain>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=CIIamxrD c=1 sm=1 tr=0 ts=69ef25f0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=3mycV0Wr0ScokfTl4csA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: iS7_IKrtN8NgHGoW9hdwneOKkL3-MuLb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA5MyBTYWx0ZWRfX2/ZYHwOxmLxh
 zQAkT4X98mKyW2oZIYPOcL2usGOWi7JRQEKx0MsD06PG/sv5H+QOzuCFUdouxDLpowB+F9yuCch
 nkQhROnBSS27RopHrXYW/DdkYpA6YOKiz+3B1sSOyeshR2ME03kWAQNpwXxfvjKWY3T/yBEFXon
 v5E55O0xLd1sy+GyyFEy6mQrXFGRAfudaU8VbcO6VkGMxMkYPaUYDhOSBZqrsL/wzL8JDhSxEqz
 KZl0SgK6StWjvpW07dSOSSzynxrDgrwZtV6eDyQ6T5PuDv49Oae+mTNq2vg0ZOuQ78EJcAPBGFt
 XCFgtHwzxSFyGNAAxNax+ht4Y6RtBLupr/5w0XLs85IQStDHMg80rzVmJSa7GKXMR6eo+wWgL7o
 OGmAV4S61IFIublU7TTSIxwoerBVq/P8cSh5cRxqbzVNG6SoUhXFVnt6F80bZsLD4wdoXmn0PZD
 DcObcQLE0roMUwN5IOw==
X-Proofpoint-GUID: iS7_IKrtN8NgHGoW9hdwneOKkL3-MuLb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604270093
X-Rspam-User: 
X-Rspamd-Queue-Id: 214D42000B
X-Rspamd-Server: rspam04
X-Stat-Signature: xjbitjaajt3exznpm6ipaikpird8fkhr
X-HE-Tag: 1777280505-683359
X-HE-Meta: U2FsdGVkX19QQ6+dc092maaaVGtkwdturW0wtEKmvqEnuEibv9IUNVS2YF9/L+WiABH0vBzpbW+BbLiTypHTqd34eiOPDdAvZhaqFiqhVwkOFWbN5pIrAuN0XbdF76zjXDgDeuKD3NNQ04IXXt9LhrULma2jdC75QpfyBDPwQD+vub5+xzGYpp75Sw2CdYUPEtUu5HVXGBgXiMwnDSEqsIzw4/FBrJz0OA9MnSNWrzmm9k/j/npPK6ouDUZk7ezrWsL646krx49MoL6Yfmsg3LJUx7tyymLq7YO8comi/bvKBDKJrjjmOl4PeOc0FTIXgBTiqj831PVPKXLLSk/l6f3OeSqhsPKfE07s38m86FY71aSreqrDsFhMCQU6B16F8uDGk42yEGSq7nD2NBvNhQMH3C9JySlv/qBSZ7YWWv8naNGQfjEQRqfvH2xfw7oLri5k8zCGgAF/MDl2pcS96nOoFdcdRNHQFDQ6325reWrvuO1S2xK3Gm3MngXY6C6odvk9FCCWLvpLP6UAjSDjnfQ6kZq5d9VzSAkqwgyKTMz+FNLde3oM+uqNm2Jhv80HhN/xVGz2VCC9DVzeCsQ+N3BwgcMBPpjJp+RdyvhDO8ew0G9C2fI6UrnGKxG41ohhC4au6AKa5kVxhveCjXsVZ3kHQ5BnTPHpn5YVfM6/sq2HVRhabiobf3taW1okRwo+XxZJp8rFxiKIuyyi+aICmHxjRedKNQeDihqccEdRApIHd8i54iGtkRKmAcN3FNqqV/SQATBwY829MRL3dOUD8KNkFB5NBoGiRbYbU6tAv4qGJ+OcVXdwcJ7lyrTcIAJPDXYHpL704bJwTZl2zRXxeI8ztJb87KJZJRVx/fqFQYEmAM9y/Hq7W4ixAvaH4qWKsXT+nphnykW1eUcwU3Ce5t0ofTr/bjv47PAbrvPrZAXIYBhOb3qJog+u495cK/igAeF/u9VZ/FxfuOmJDNq
 zfYePuvg
 vKA9BdChTCCSRhFZTVNpWLjIRS6NMYmeTx9VI66s4UXJeHLUXrCs7ZZbdsnQkax46T3N8FmfVk1hEXcmSW6dXEjx63V5wTjZuZY/zsijgOtiKG+0hBYyXWGBSCaDtENpVt0UX+3XiE68iX0/RvRR4AkNQJPIpVaAQz0cA51+wKFAm04NLuPBp3J0yxHp/pYGPhrGqoH7mT7cBOLyU8YGRUQUz/4h7O6EmWWmd6EH8muU1Ene63rvonCkdoLhQDycQJgwQHwJYWDXpUbwkPDLZ6BihICT2JSxBDPnl3Y7uGFurU2WqGaMgugtYZTINicA4QlVuxyWufoaC1jgr3vAG4bmo2L5Tz7RKCjzGq7lzTi0OME6PoeHv7+p1k2xlrEpye6Pf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 10:40:02AM +0200, Oscar Salvador wrote:
> On Mon, Apr 27, 2026 at 07:20:00AM +0200, Alexander Gordeev wrote:
> > Convert pgtable direct entry dereferences to the corresponding
> > pXdp_get() accessors. Use ptep_get_lockless() variant for PTE
> > reads when no lock is taken.
> > 
> > Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> > ---
> >  mm/page_vma_mapped.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> > index b38a1d00c971..a4520bb10d2a 100644
> > --- a/mm/page_vma_mapped.c
> > +++ b/mm/page_vma_mapped.c
> ...
> > @@ -317,7 +317,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >  				goto restart;
> >  			}
> >  			pvmw->pte++;
> > -		} while (pte_none(ptep_get(pvmw->pte)));
> > +		} while (pte_none(ptep_get_lockless(pvmw->pte)));
> 
> map_pte() might take the lock if PVWN_SYNC mode, or am I missing something?

Then ptep_get_lockless() would not be a problem. But if it did not
take the lock, then it is a problem.

> -- 
> Oscar Salvador
> SUSE Labs

Thanks!

