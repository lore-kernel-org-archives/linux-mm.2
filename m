Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4E5EFB806
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 06:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A0E6B0096; Tue, 24 Feb 2026 01:06:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8376B0098; Tue, 24 Feb 2026 01:06:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9706B009B; Tue, 24 Feb 2026 01:06:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A79616B0096
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:06:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E02A13AD45
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:06:40 +0000 (UTC)
X-FDA: 84478316160.04.975279C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1715B20005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:06:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q+sikCqd;
	spf=pass (imf13.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771913198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSwCN+J+wMeHyT6grODleBZy2GEkq0PcaMF6dUqouaQ=;
	b=xQPVzRdCtsaR+FLEJKAtC0dxU9mok1YZfPL9o86NbNUAsAi65jNn83lldzAzK9VIZ988ul
	LMIIZrRGEMm/H4ubJwreWmGZOja2GAV7UcFG2yGY419V3SVJTbuUB2cesPKX5uSuMqgZsu
	zLydXMUA7O3+L0TPG9lSiz0vCIFOAng=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q+sikCqd;
	spf=pass (imf13.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771913198; a=rsa-sha256;
	cv=none;
	b=DZFF6yrETMgwe9AGVmOWCYHcPrAW3AOmkQLjTG0oB1Sl223FM57rhVhUw8iSjDXPQx08UM
	chX9rN9DnsrYpC/3kQp34BAk41jC1g/6pIp0gF4uPy3/Mulp1/q9EMT7jEEEgyXLSdynf2
	wd76oa2moO/W0RrRmBk6gDIGElP7FhE=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NGPScP2832046;
	Tue, 24 Feb 2026 06:06:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=uSwCN+J+wMeHyT6grODleBZy2GEkq0
	PcaMF6dUqouaQ=; b=Q+sikCqdOnEu0m1X8P3rXKKxoogSH8A7M6OgY5QzabXD/K
	vYEollVPH0SnHN0teWlne7IIGNzNYDEujC89EKknnkNyDCyx5PnTODBgQfPU7Syj
	zmBozBkckkUyyToEo8FjD5Y8e4oj1zqu8cQ8X1NRVs446fGfpYAL9lFovpoKJGh9
	YcLk6Qeg/Vt/PuWofk6Wixh9Qzu5lyy/lxm5GQw9Nkqwpl/QKWG/MmWQ7moOE7A9
	yYx4l8o5pCUptYHXr0gmg6ogCYuP28bhcH28L7739jM9n6+QZxYYgXDHPhlEkNn/
	AkII+GeeJIAyTZaUA34wruFzQThwlbxQMcrgA/kg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4brsjfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 06:06:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61O37WZf027821;
	Tue, 24 Feb 2026 06:06:32 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfsr1qdvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 06:06:32 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61O66UdD42402116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 06:06:30 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45F022004B;
	Tue, 24 Feb 2026 06:06:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 975FE20040;
	Tue, 24 Feb 2026 06:06:29 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.3.229])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 24 Feb 2026 06:06:29 +0000 (GMT)
Date: Tue, 24 Feb 2026 07:06:28 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org
Subject: Re: [PATCH 1/4] mm/page_table_check: Pass mm_struct to
 pxx_user_accessible_page()
Message-ID: <cfdc9b3d-06fd-4cc1-b946-076ff1479c66-agordeev@linux.ibm.com>
References: <cover.1771845678.git.agordeev@linux.ibm.com>
 <68c2f6df2955033cbf1ccbd2b5c2816e72ac345c.1771845678.git.agordeev@linux.ibm.com>
 <20260223101335.aa3696d86341260e03989ac0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223101335.aa3696d86341260e03989ac0@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GRFhXxJJ51Drfa5KN-RgSm71wqJuLn6I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA0NiBTYWx0ZWRfX1uDOPTCSWGJm
 H28pUjz7WGw4rD7VYhrEKjR3wg5TnqYAO9fws+uEqxvLRB07iiUVvPUWvke4PquoiaHy7cj8NP0
 +5MgaPW34kffQmMJwrJOzID1NlSHyGC1xRPjjpVc0DJtk+Ei9BSKJrK/MTg/uBF7CHEUtyrBEgm
 C8pv7ZPckr0Po4LPDbSsI/kid9Phn3VvVADlJGR+B0eZN9g8aP315xXoblRCeHkhcccGbVxpMJ1
 DimKqPwVFtB0GfFZXnWVLOIyLev9XNuRnLc5gjtcxk7i3PSPH6DQO5CHGxAU88Fl1DSfNddJRpF
 zCrD9OX+BuzNo5iPhvuxgVh5wzbSyJDcGk5cNKRYBcGOei2Gvk2vQF1A6X+6yzK7czC5GEBr7ms
 xqNUd8nfV8wQ9NbpXHKeEzn6WXK2DXy33/wCLKadxjfeemckf67RPFYG2YMxjPHUYBrhwk/xpzH
 aO9nMbTo1mWhHFFtwhg==
X-Authority-Analysis: v=2.4 cv=eNceTXp1 c=1 sm=1 tr=0 ts=699d3fe9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=Z4Rwk6OoAAAA:8
 a=I00-mOCqQq542zIoxl0A:9 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: GRFhXxJJ51Drfa5KN-RgSm71wqJuLn6I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_06,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602240046
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 1715B20005
X-Stat-Signature: 7gcirsot7nzqmypox6nyezs3q5qnhpcu
X-HE-Tag: 1771913197-360794
X-HE-Meta: U2FsdGVkX1/ijA0gqIBrKF7WHJZ/i/PVfj/45JEhxYVgV0PMqpONJ0ADK4VOWj3FYeSFU2uuDF0bZMbCP0xrk6O+O84I9TeNHfGjrqmw5jcsWERWvt7UTi/Q5eZROcXWnvAVlh9cN27JjnaE6Dx4AvzVTa8jWP/g35kNnvKXOCSAxxfAzQHb9cMIztNee69qEMhpTdg8GaHjfl3OFSbXPuPql0q2XWcxeaRvUksbSFJYAE5t0J2h7MgC+FuccrTxh34znWIVz3FDzd/e4w58P5YlMG247fKFL7Eovno6CkKMs6FSvUGtt8ZYb+tgtT1F03Boh2IqWYuHGOA2ONpzyjr+5kgx68ZpsuaMYUPGCZUxv1Z5ocIJPJwnT+zxEFMc27rFpdv1DbBA08/CPGr0S+oqwNTKUvccIr2d37UmQT4bjbQCPz1FN95u6EAUHqGLawqLr/ZtCpfCDaV0OxtfpXC/T17se2n+TmVoqqjl7cn9B/8WvabrwQfduX+H6K+AQOBRzLuTxrVsxDQixggBAFSf+v+rVQsUNHEHWvdLbTwCKVIqoEPLPDapbLvsBD5oa2fA5LgEOuIb0OjhVBkiC8MMMa/uVbSq/gN3UK587SsP9PTMq+skYjDVj+0tuX0Wi9g+MhEfCjA7ywERXzzdYdvlxSbRYF83WDaIxXFE0vzJxtrAoZaNWPOKowc246Jlqv9bOszUwdItftbxNrzng8k9b/npK5rWtkM899X+eNEkWIkWui7/yqHOBX0KAAn4RHcGHsTNpnHyL7WKQqTtY07svNfGu7XX1rHVZTXy0AO9Rw7MM2MeRgoZZsGQdHQNdE4DlPsV59ANoeQ2VVN5rSvpIdC68TtRF0R/gnuL8XyczTWyTnhlzpK2GZmcos47OFc2uoaPCoQu2GsGtypBhG3tEQ+wxtRh1q2W3b7vgb0QCALgQy3XSub5lJw8H9efpBlfEwGGchBfI0RYZal
 cYoNwB4l
 E1QvqI9V3Z9FZlkZzeSe3zUpghg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:13:35AM -0800, Andrew Morton wrote:
> >  arch/arm64/include/asm/pgtable.h |  6 +++---
> >  arch/riscv/include/asm/pgtable.h |  6 +++---
> >  arch/x86/include/asm/pgtable.h   |  6 +++---
> >  mm/page_table_check.c            | 15 ++++++---------
> >  4 files changed, 15 insertions(+), 18 deletions(-)
> 
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>

Thank you, Andrew!

> I assume this can go into the s390 tree?

I think so.
@Vasily?

