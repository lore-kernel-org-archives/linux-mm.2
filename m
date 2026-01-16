Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F100CD4A5F1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 03:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0716B0005; Thu, 15 Jan 2026 22:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234376B0088; Thu, 15 Jan 2026 22:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108FB6B0089; Thu, 15 Jan 2026 22:14:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFC786B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:14:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 986DC592CB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:14:00 +0000 (UTC)
X-FDA: 84336357840.13.D715AE9
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38020A0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:13:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NYygGJ9J;
	spf=pass (imf25.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768533238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fW9DCoyeRwgZraySQWN8vHpYbvVPEVqIauwbJyIM5A0=;
	b=RWrqc1wy7nvRAS8Y91KvzilFbojJOrG2RIVxyjzT/wsZl3E6IxA+dYBj3URab65rT33+Pz
	mOQrC9jlMY0VVTxSKGmW4BDHOLemXtJnp+FDULTeFjiptsJUYzKy9DL0bCmCqSSRdWyw0v
	WbpOCllELeNpCjaLg4hF8i/PWp3Nu2w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768533238; a=rsa-sha256;
	cv=none;
	b=8ZBA0cW+wHJcU8ZEUXNIHjhBvab8tupfQE9NA1Erh8uk4+xpN1GYnnVMPpsroAFPKTcZ1w
	sVMJvihUJkvflQ4ptJ2r8Q1lvppjom/ACyXo+4yqc1TP4pHip/8MevB5u9PZgmNoE6lLfH
	5L8nuo71sNFXD+DCh96djHmpEzLPBIw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NYygGJ9J;
	spf=pass (imf25.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60FNIHeB029136;
	Fri, 16 Jan 2026 03:13:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fW9DCo
	yeRwgZraySQWN8vHpYbvVPEVqIauwbJyIM5A0=; b=NYygGJ9J3OYSrN2x4e9z6X
	NYJJ7RxBn3MNL1AVw7mshGtX9hPULZCWlATJxyuqbZdUQNguUfdOxrarn4j5Ydg1
	AGxQ+d5Zgz6XZzKjE2TXf58qyp1fSESB+YjMrh9aoxPdurBGbMmC22goMcZuNX/z
	f9zzUdAKK6dBmJVMrUhMz+afmJX2H72x6505h4wAImixn8Ym3Uw54J2ocq8sNd24
	Tnbr6UBUIEDOOI/BkljqDwrEkqyz7B/CNXwLzBbk12VTJjv2QrIFNMGmWZWDEcyy
	x/HlZF3eMB4ZeJMeBQ6mXmns4eec10jUcxphWK90EAjjjDG36OrRJ2dqbKDWG3tQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bq9st8k9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 03:13:51 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60G3DoSk002919;
	Fri, 16 Jan 2026 03:13:51 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bq9st8k9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 03:13:50 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FNYKXh014274;
	Fri, 16 Jan 2026 03:13:50 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm1fykxcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 03:13:50 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60G3DnoW25101006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 03:13:49 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2BE25805C;
	Fri, 16 Jan 2026 03:13:48 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A470458051;
	Fri, 16 Jan 2026 03:13:43 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 Jan 2026 03:13:43 +0000 (GMT)
Message-ID: <ba35672820c2fbad2611a0a89b3cb60125776f9b.camel@linux.ibm.com>
Subject: Re: [PATCH v18 00/12] Support page table check on PowerPC
From: Andrew Donnellan <ajd@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Pasha Tatashin	
 <pasha.tatashin@soleen.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Madhavan Srinivasan	 <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Rohan McLure	 <rmclure@nvidia.com>, Alexandre Ghiti <alex@ghiti.fr>,
        x86@kernel.org, Nicholas Miehlbradt
 <nicholas@linux.ibm.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Andrew Donnellan	 <andrew+kernel@donnellan.id.au>,
        Srish Srinivasan
 <ssrish@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Date: Fri, 16 Jan 2026 14:13:42 +1100
In-Reply-To: <20260115161857.ad9952cf1ebd1b37839aa652@linux-foundation.org>
References: 
	<20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
		<CA+CK2bBjoQmheEstv1MacGev_srdx=m5v=hwxdyfAKogbpG3FA@mail.gmail.com>
		<bf0def77b07a34c00928cedb46030ea17be4fceb.camel@linux.ibm.com>
		<b6c39059-faed-41a8-80b2-addaa229c143@kernel.org>
		<cc97397d3c75d796ee71081cc842c867a62ce39a.camel@linux.ibm.com>
	 <20260115161857.ad9952cf1ebd1b37839aa652@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KNRXzVFo c=1 sm=1 tr=0 ts=6969acef cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Y5EJBO6SgJiHs8anXDIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 55htG9PDokbxJx8uQ6srL93nebqrpK1p
X-Proofpoint-GUID: YOi29F4SNz54m1WROzu-sRkP6zlVhnnc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDAyMiBTYWx0ZWRfX+AFfHh/cyIIs
 bJQv6kvsfmeTtynUjb6q5acSz5NV99GlwAWc2Cdw+aIY773Sk1Jx0AU8AGPqrkiFsh5DIgsWZab
 l4KzZtSHmo4HZ6zzXOr8C5VRJI8wJtmrLRHxvQhtRdWyhdOlJTWYsr11jTchKxv8aEGc7AQSEH4
 PewoYzY2OxNY+PBDkh/xfq7ECz3wsnqg4Ot0ixK+uM67WU1GFayhSS1Xv2R94C2p1Aleg6ympam
 PBuyjS4HCHvSNa/blb2ORlmIncCBmSTSBjvXh3yuRJ8/x9kPI30vigZ97XQ+5gUduWdvjeZOz64
 5yUKs1skk9SpC5UfQMTteYAjlJmk9mR3kPFfFR76igDW6b1BTU7Z4deWPfgEJ2SzlNbgWL6xkdN
 1KEbXNv7crX3PHM3ZLXRK+2ftCyNFptvnp/hpTMzaDxvNeGOnIODTok8V2WUhnRn2GL6xdQHsCl
 /G87cYrP3vwn/veSdtA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_01,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601160022
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38020A0005
X-Rspam-User: 
X-Stat-Signature: ukciszz89fmkek3b1xiozqehcp56b4sm
X-HE-Tag: 1768533238-346147
X-HE-Meta: U2FsdGVkX19o3lHWmV/Ye7M5BYKnm01/9p++lRk4n/wnnVzQ1bL7ctZ2BUuuQ3aT4/Qu6Rhux4Up8DURFJgJ906t0IV5/q52GRmBVEaRyKgnVERL1gXgLWNC8piFSKofs4DrEL5AiPQCQ3nN+ugVOG2cvKzHlu6KWlm2x+9nGTey22dML9B9M+5Xifi6r6YyfDaVp7CkLwyo4XhClRToOpPVe1X6PIBwwmR7FzxLbHl9QnyTQMulHj48r7eP/xzgiCx1ovYs3rA3e1i9402a4xjhI6pQKiZyAi1PdglbUxgQI1PA8jDHyetmlhufP8Ptt4fOeM8K5FFx/zazX67gkwVgfZbniY/JOfTPu8gMoD5dsF3ezjL1XVUFwMM42TdTHv2yg2zvqz1Fx2c7969fdLSpqllZ23ro79K7FJBakF4Gsn895Bz8HRAnkykQFp2COVGa05u/XEiGb75vPw3NmglPVyA2+1RfZgsUITnYF183HhtJrY37RKVNJOEGYAslibeXzSuY6Fncr+KRX/a5SCGdc53jTkDTYYpmngZqeLbii2ZCThP9LJqkVbbgEABdmtNczMxY7w+KR5GaeSZg+UU+hG9Ch1x83Mai7NfpTPFi20WsE6a636QV/tB9eAvLC2bjRXk6UCXRE5MUQNP8U8G+z+VX+2tyPH8Oq1Z76cTl5NJTfUziUvvjoe0QhCevF8eWfHH454ptkdXTRDf9kR6XW9ClIVVtzTDoZlQ+h7MQ/BJ2qh35e2JEMgVbTkcYatSfFGdpqmAF088Qb0h6R5aQ91F8HGA6N71EYQB/HdqL4+mpotqAieHEAwfYqAmT1EWIuPNTSSxlo/hokGKSzWIweN+7pRgSqDs4wRtBvu9rUkTFddzycufE85t+z/KCBuGaMhF+Kw8KwW4OXgUpZ4lriZ216tJf4PExzSTlDPYVbkkwdzrfPKK7jLfciCjf1dxQrZdxNpvpgiDfRMF
 Ipv4vlQj
 ivsjVEo6/aCfX4erLQQo61ZTIW1YB9a2KcdiYqwJ8XTB58CPrHI/9HY45Uk59gUrsZ/3YgSvctUdD+T2ICgYpjx5ZvWLAEIQAJvlrkB660qOsugfLNdwkmbBRxFnJF3iRdBwsjmjBxmVI/TBn3na3YcTVs3CikXoRCIWn3OD940zLgOXwWLKmY3ekkMkJ4fw0CgTwFqHhKxgq658eS7BdMn7D6A2gP8OieLwachfMQC/7dBKwRRZDuQhZFpjsExT+McY15z7BNyi9YClof0LgekDhoMfWzdgDNms6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-01-15 at 16:18 -0800, Andrew Morton wrote:
> On Thu, 15 Jan 2026 17:13:26 +1100 Andrew Donnellan <ajd@linux.ibm.com> w=
rote:
>=20
> > On Wed, 2026-01-14 at 10:34 +0100, Christophe Leroy (CS GROUP) wrote:
> > > What is the merge plan ? I see all powerpc commits are acked by Maddy=
,=20
> > > will the series be merged by Andrew into the mm tree ?
> >=20
> > This is what I was expecting - this revision is rebased on mm-new as it
> > stood
> > around when I sent it.
>=20
> Ouch, sorry, I did not understand this.=C2=A0 So we've lost 4 weeks testi=
ng :(
>=20
> The core MM and ARM changes are trival, in the if-it-compiles-it-works
> category.=C2=A0 Is the mm tree really the best place for this?=C2=A0 It'l=
l get
> more testing in the powerpc tree?
>=20
> But if you're OK with it, I'm OK with it.
>=20
> > By the way it doesn't apply on top of powerpc/merge branch:
>=20
> I guess we'll be hearing from Mark when this hits linux-next.=20
> Hopefully the resolution isn't horrible.
>=20
> As I'm adding this to mm.git's mm-new branch, Mark won't actually be
> seeing it.=C2=A0 I'll aim to move this into mm-unstable (and hence
> linux-next) after just a single day.

Thanks, sorry for the confusion! *Hopefully* 18th time's the charm...


--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited

