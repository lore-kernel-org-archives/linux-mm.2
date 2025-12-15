Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6579FD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 07:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B9D6B0006; Mon, 15 Dec 2025 02:49:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC2E6B0007; Mon, 15 Dec 2025 02:49:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB636B0008; Mon, 15 Dec 2025 02:49:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 48D5D6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:49:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFDE85D80F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:49:49 +0000 (UTC)
X-FDA: 84220931298.19.790517F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 013D01C0012
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:49:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qPF9HPBn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765784987; a=rsa-sha256;
	cv=none;
	b=QuoSxIQfFTtIv4ebem+0lYZrOCW9Zcuotq71Cxw91nY/7QNhG6j+lPt+OUii/8gO8P3wW0
	+vraTvw294SVkalsPJeF2oAFuFEvUX25EfZ+4GROcR1g3+anV6YsZlzS+fY1CO/OfS4PSK
	Q0XeGwmzqKP7OVMENfBKxq2PEzR1wDE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qPF9HPBn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765784987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDjBfb1MSSR8AbXvVjtMwPIfxrW2FO1Fv99ClsCT2+8=;
	b=NYciG0y0A1fSBcgvDOu8AU3uDwOxMqZtgvgY7BdJaR3A2qhSrUvdY7dHSUcg0rA9SEusFQ
	q/fTGtW9ORBIE2Mv9su/sojBYf7v7/1GmcroDVxYSvYvZ3Xjh4emwPbQdGNayLx631WIU1
	ajauhrguDid6bnelv2q1dimz2q4j7Ns=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BEKF0w1022513;
	Mon, 15 Dec 2025 07:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=SDjBfb1MSSR8AbXvVjtMwPIfxrW2FO
	1Fv99ClsCT2+8=; b=qPF9HPBnUXHKWFIuefF2pqB0NLtXIwAvmKjg3D6H+UVq+g
	iEZo9lPrejaBCuFrX32VIQ6fdcZF+ACZDVQ60QwrpwS59H5243QiXPKJqzI6Bqp7
	ornC6UfhFTdFSU9M28fWkoea96XpCA0Z2dILtT2tf2/j4lPZmlUT6nRnsnMvmea3
	OLN9Wo0MWE4hRiRFgYMc3SwndEXi7kbXClRNXUbsjolAAsz0XfUrlOO+XnoTIV7f
	5AzvVPv0YfkrFS1yrpcu8hNx0ehBalYWoP6T5p/cSWuMXVkhhVsC5D2VpQqgGvK4
	VLVPQBXVK1L/0wHiRXsizELjZ7vmvKbSujeQL4WA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0xjkr4qd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Dec 2025 07:49:45 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BF6FAvA005686;
	Mon, 15 Dec 2025 07:49:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1tgnksyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Dec 2025 07:49:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BF7ngWt60227874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 07:49:43 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD11320043;
	Mon, 15 Dec 2025 07:49:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 031C220040;
	Mon, 15 Dec 2025 07:49:42 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.60.230])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 15 Dec 2025 07:49:41 +0000 (GMT)
Date: Mon, 15 Dec 2025 08:49:39 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: change all pageblocks migrate type on
 coalescing
Message-ID: <ee518adf-3a07-4e08-9a6b-f5faba5ae073-agordeev@linux.ibm.com>
References: <20251212151457.3898073Add-agordeev@linux.ibm.com>
 <5e79bed1-598d-4e34-8f1e-87b6dba52bf8@suse.cz>
 <20251214160606.GA905277@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214160606.GA905277@cmpxchg.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JIJub7J5DXMnihwn6S63GJ7sHIpsKJ_W
X-Authority-Analysis: v=2.4 cv=CLgnnBrD c=1 sm=1 tr=0 ts=693fbd99 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Hnd01_47jJv9e3yHuFcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: JIJub7J5DXMnihwn6S63GJ7sHIpsKJ_W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwOSBTYWx0ZWRfX8yTGGcv2gyA1
 zURzqJtX+YO4yogXW3v0DPGIJ8PvzkKLqdsM/EznvBWs6Bh+3e0Xbw5WqbNuSbdST7+JmElWU/o
 jZjlM+c1oJW/VgC/6M5qiYDvFrQZhsD1cZPqvq9/TmjuWfCEWDgJFYx8b9qTVep4zAdd6YA2GI9
 KWq+QXtsHpbXIPeh7Cm6LVwkC4iizw4hCB3HvRcm6lczNxdJ4ce6m187JNGqPDNqcA01EvBnqve
 Pz704PuNX21cagbNl3VMOqz6uYW1zez+xL5RhPXgc9ZgU7FlxS1bcKfADenx6tFktVbKtKXqxP+
 qs8nxkyJdKE+hvKaFfvH3CxYLV5iPnKgBsqHXkafOUMR8qwuR/VM9AE4t7S6krZ63Rerr6cNnuv
 j93EOjoOlm/nz8UCDJyX7o3YOJIyIw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_01,2025-12-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130009
X-Rspamd-Queue-Id: 013D01C0012
X-Rspamd-Server: rspam03
X-Stat-Signature: emprr7xy1wzydxujh73xdrbi5dnm8qhs
X-Rspam-User: 
X-HE-Tag: 1765784986-437746
X-HE-Meta: U2FsdGVkX19h4S8iNLSvrDTlk/grxTTNnxiHAiXj2hqprqYPV/OotJ4vEgauP6IbZ8D0DHHIgWcuNqvB8umMlCgUNJI1qFtuAcWQ+ai9vXWnzDbhUuDJ0c63TxxPyVmdGkFv5YRRHdUbcCoTZtgpbKOqSwK5Lv4SYgjWt/WDCOnzOghiCn9tjaOy0im/sRMSeGb40K8RFBZdleNCgZ9NT1XZZT2B8ZLr3expb7OErW+wqa75hIyICV9YJNfbMECkSNiz7MH045DPEDE3VBIL4mcbDJQtHh6USb34rOAY2E1DLtoM07L7FMyQUsaue5Kn5OmIeHxuuTGnpzNQHta3D6tdVo0EX6L9buVd9x90qSfW64YDFK/kyyRlDT6dGwbfi1Ne3K8Mi5clHEkwM/z0WoSpXuHTTORNBBVQhED2OWQlFRNu5NuAEVqO5jRULclx2Zdoex7Nk0mvcKpCLdPl4Vz7g1/umKELsfG9TntbT8sOmkMCrvJw6yhKnopAEbl7w777KK33ryptJNBYN4FQ4wN8+n9uL1uOHPwpN9sMJQ4InQq80D2SZy9Zad4NXL9xPQGxmhmCroNN4gwTafwckvF9nH4w1PzBaY/2xe9JVY/KK1T18+kB+ZP1qQ2pcK8gLW/8sexYzhhhS+SSMjeZ7KVu011BX5ByjJj4jU/1G4XYOY5TwLhE54ZevRInutPciDW4RneBVWfFGpgMOfr5f1YQSr5E81CJLP4MP1QDJgPCFqH1otFczqQ5xmUeKBIYbNp/uP1JA1Z86TVSUUZ+L16rylvmHot7tz/mt/zlZjzKE6M5x0IfxhmOmKrBzR+tb2tMq4PAw2gxGggwd4h7Rxo+Zw5WK41zWMRxFB7NXu5BMDnqDrm/5ZL2yRz31XsP8WM6dgLpEH4UmAPNI80mc2gM5BzE/tHa9DRGAzdziZEtmBo9gYLKLU1Vl3MpehDsDkXfhL+mVo/AIWuRfp6
 GHD6dAA0
 zZM5dLgytN1H7+tm6JA8zUzBHKXZ8/7E77E0p73cCrP1hCv0zxD1wK6dyTnm3eXKMxScDwrdbe+RG/6lun4liSSOwLPwHgpVU59uF/ToaUjjM7NkRoTChg3j6nh2gkUqVWvpvV+HR8XsBsCy6x7wPrf/bq8qqclnUP/P73y12+TIYwM0aq9EcwewWxv/a+7R0tSNnD/IfA0BWppqox97dkQNs7CCxZ4xbIhNtrrImXGgLci4PZabHDcvsYDvCCMXrlYWmoG8GobZgQ4UTHlBFTFmIjuploLWv7rn0+Sjl4OMaf+WfQ2ePizGPz8fEDrnJo3y0sHgiMdOb+ANpea+yrixpfqXiM4pm13qXWompRdPMDL+PknHCbc31PiSjcKaShyJh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 14, 2025 at 11:06:06AM -0500, Johannes Weiner wrote:

Hi Johannes,

> The warning makes the issue loud, but your patch is arguably fixing an
> earlier commit that introduces type updates during merges.  How about:
> 
> Fixes: e6cf9e1c4cde ("mm: page_alloc: fix up block types when merging compatible blocks")
> Cc: stable@kernel.org

Yes, I was in doubt which commit to address - thanks for clearing it!
I will remove the last statement from the commit message and post v2.

Thanks!

