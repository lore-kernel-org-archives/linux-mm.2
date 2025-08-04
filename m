Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72D0C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 07:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B06C6B0092; Mon,  4 Aug 2025 03:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5878C6B0093; Mon,  4 Aug 2025 03:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4283F6B0095; Mon,  4 Aug 2025 03:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFAA6B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:56:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A79D81C62
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:56:31 +0000 (UTC)
X-FDA: 83738317782.04.F6E6382
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6EB9D120004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:56:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NzXVcpcD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UZ0Kjd+a;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754294188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAvoMMsW/cQkR8nAA9fec1QmFIVifCXNy3z7FCsLucs=;
	b=ltLNWX258NlQ7UsvWP7bVgX0LlUjFR/VJOmXXZdShRSbQanuG8W/OMfEFienBoeIJpevJN
	57Vm+e1mtiLn3lhIGTeQelj7H5zVPZDTk7fvhX7t54U5skm2OxwVnsYHt99t8FckiwqtaA
	53aaXwJEe3wGgb9z+z3VV0R+zB9nMXY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NzXVcpcD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UZ0Kjd+a;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754294188; a=rsa-sha256;
	cv=pass;
	b=lPfudnhgUPVmzBwAbfyn7aN8twINV5ic0bjxoroQSp6foUILElNDREtWx7HlsX1ZOrKvvu
	tVSkmLu1ecbwS/ipV6x8B5s1t5C8JVkPBvwSwQtoR5K9y64HOkC9ae2cm8rTtCrGDzhBcr
	RgylvLlR34BdCmX0f7gh8BRzaFxO5N4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5747gEbr018646;
	Mon, 4 Aug 2025 07:56:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MAvoMMsW/cQkR8nAA9
	fec1QmFIVifCXNy3z7FCsLucs=; b=NzXVcpcDkHZ6nGNKW5t/EQQQA1LuSQQ2A3
	USsc3wsdalLHdYbvL5xGThMS3rsLynQvKmH4Ij6hXpNuK9cBEAL+SvnFY9rMZkrc
	UMV1OMxm4nADZcoNxn4sZ0kCbJ71Byq/yH0xKRg9i9SK1SkzR0TQ96tVtdPIcVNb
	wJzujZUCD8lqkelnSuEqS74Z5x44mHRxRx7z5Dc2M6OWXAmUxD5iQn/OzFZ+W5Nj
	/XDwIeJmHq61MQvhgZtB7Hcl3uN6oYfyeO29T/O06DEvuOHfe37r8cXzr1/NsC5e
	8k2dxk3VA6KmK+xjCV/NvkurzZWLPX8UuI584Iqw07bt0MZt2zEA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899kfa5ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 07:56:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5745vo6I031868;
	Mon, 4 Aug 2025 07:56:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7juaq0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 07:56:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRKs0nI2FgZy4yXMGW+Jb9/oJOvdGlT9KxlcL4v0QLDMjF+paZv1iPwnG/AtPXySNJfgEqUmEcq1vDKlZH6mGs38dcIwgM7i8K+MjpFFagOtz8W6E6Qk4jzBX+nbwfveKeu7L1NiUH30+ZLryS+fCzGP1ZJ9oEWInqK01qlMFJIymEF0RMtS3hH/xm6FlclK6w/vcwFiURumQfr4ovBFVJzjnJ+GPpwjwCi368qCfLKmy8qXkhEtAzaZNxipFNRhyZD6uVIPmrE3L5pCvIX71WVYoxqEnk5RpnfbDdUkYNyPehjGxSRfCM/mWh6PoyFWjPPxMnv7Ojj/bdP2COXuew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MAvoMMsW/cQkR8nAA9fec1QmFIVifCXNy3z7FCsLucs=;
 b=y7QJc8s3t2P/vrI5j4ksO5KglDRQOjdkGJCIiD+z2VeNRQYTF6nF7SwVb25XLjFFuyX9G7hna5Wm/59hslLXPGdt4GG5+TC4QFpRKbSB5+Dn2eI5bneGBSi8XgZqLO0ZLijXk45fOpERjQC/nbOPbg/YqX8G7RGAyEVtG6gZa1uD2FvcHell/XbUqK5uvrpwgG5In+jP9cxsUNpYKhijeCmKO2BxhPkqxEcnTv5zl2p1XXqRje1PwY7EyhtQIHuX0kmp8aF5y+I6N7Vu0TtOii0Z9nrRA9jlsaoTEHDDBms9i4LABPKB0IRxrToSMzpBsIbrVmxEiyAGvSjbqREKSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAvoMMsW/cQkR8nAA9fec1QmFIVifCXNy3z7FCsLucs=;
 b=UZ0Kjd+a9aR28Sr0GGxaKyhIlszeVUMFdzgPdAO7RkiXE/euV4w6i3y5tLOpbHaRMVnVk6IhC0VSZ8XHM9qCOqKuWco5lURVot/WkqTI2dfRwsCC5JnHDJYmCdXZyq3wr4YDCGTineOasf96nkGAeNpMe7m4qYY23xbIhxPxrRo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7805.namprd10.prod.outlook.com (2603:10b6:610:1bc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 07:55:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 07:55:57 +0000
Date: Mon, 4 Aug 2025 16:55:43 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Paul E. McKenney" <paulmck@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: next-20250729: PREEMPT_RT: rock Pi 4b Internal error Oops
 kmem_cache_alloc_bulk_noprof - kernel locking rtmutex.c at
 __rt_mutex_slowlock_locked
Message-ID: <aJBnf738fPEmVqGo@hyeyoo>
References: <CA+G9fYumD2MGjECCv0wx2V_96_FKNtFQpT63qVNrrCmomoPYVQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYumD2MGjECCv0wx2V_96_FKNtFQpT63qVNrrCmomoPYVQ@mail.gmail.com>
X-ClientProxiedBy: SL2PR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:100:55::27) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7805:EE_
X-MS-Office365-Filtering-Correlation-Id: bb1b38d3-2e57-4920-ffb2-08ddd32c58aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tnQ4nYCK5S2cuYObjJCTTKwTVSdE86nkAzx9TqXWCLUTsh4AHyo3fZuvE1bI?=
 =?us-ascii?Q?yX9w33/2tNiqv/TDVDHb9CeNGk6YLzsqDheSAfKA6kitjjOMfIa6NL/i7Akb?=
 =?us-ascii?Q?HW+cQL9b0av6XR+9H4BGhzFe2ulYw/R+wgXrmiUP+p2cEItOJUx2Xv3azX9i?=
 =?us-ascii?Q?00WHz76h5UblTdML1Tnn0OVzCGjomcH8wZjmWdxZkWxIgTRjXtCImva802fI?=
 =?us-ascii?Q?0tDUErni+bInXOfx+VLmmoeFdd/7PBfUNLLsuLpiy6/9YdxjpaavLO9C5X4o?=
 =?us-ascii?Q?l8gAYBifnUXsFp4oVnTeYXnen3PnKbNtHrqj/UPQ57QNoWl/+NKPsWK8t4N/?=
 =?us-ascii?Q?bbDxm3yVS/0a6Cc1CymufCc5WcoUxaatmfcOjoMNeWCDj6YZKixmRQfd7Mp/?=
 =?us-ascii?Q?7TszFvg9omuto5skS1mbhTPH805VgW4RgY5+tD353ZvvOozF+JtuNois3PRw?=
 =?us-ascii?Q?386TkLbxt2G4KjmJqG9ZVsp03P1HjvRqYSRfog0YFy+BzGCds8dlC/dmF/Im?=
 =?us-ascii?Q?JpeJilIwqVSAXd/inRqTmzDO6AmGjGnhfMIJD9VYO8EZ/3TGdDbJ3+327KMa?=
 =?us-ascii?Q?iAF9gsqfNWfyPB/lmq/VhY+FIvnjIxnk48DC8J096Frn17FDfKzx3WTYbops?=
 =?us-ascii?Q?ToJgSpbZLMIWr9I9ilwEvqaUYD6qYEa5nImmeF6EnQOQKSdbbobTNZIpjmJw?=
 =?us-ascii?Q?Sikd0NHxKUDxNfRt4OXcqogAwsXieX0xHHiIETVX7qSb6WBvtHL7a8xu1+Ll?=
 =?us-ascii?Q?tB+0CXMsNYI+jgpiysMsuiDf7PM3xs+vw1FmLDSNltPSmplH0FXP7Lcm+B7T?=
 =?us-ascii?Q?2fpyIK8NGf17hK2v6psvPJyx6ZY7BAeXGP1vvOtHTbnenedVRQJrGsgOVyrS?=
 =?us-ascii?Q?WAxz6LDVmUsxI/3tcnCmjH0xCjahdJ9AQGqwtgGHdYpCZ3/62qDmYbuURqRj?=
 =?us-ascii?Q?7wC7HbNyEJHAB3ZtRVoQWdI99Zml1kw9ItCZi29yQ6bQByFmVhmxhI3rtuBy?=
 =?us-ascii?Q?wyHBB4QkbXxVQqKqKi6DNCq7+OTOlMGAH8Logdj4SK3jpzMo0FJNlZBOIecj?=
 =?us-ascii?Q?QFGYt1YPFXedlcTzDi32kvcFYx+VrrOKN3+SeLYyV7zncXc9125I7IbWwxAQ?=
 =?us-ascii?Q?4P9E/G9OPKypum1TC0/WXFTncVTc0Qqzrl05ISrl+Cwoce9LtjN21yaYUp77?=
 =?us-ascii?Q?twXNCGnjSxYrUXaPw6j5ho86cE4W42559ihkg2ENfGHkE09cPV4Drtm5/I+x?=
 =?us-ascii?Q?xdIBvGDXke99sG09fSMhv//pRwX6zF6SgcTKsh3xp6Y/P8Py8IsZqwmRUusx?=
 =?us-ascii?Q?8adnHx+8gNyYK+OM3Y9aVsFpn5zoiJOwvy3VUVbgIWTc1/VuTKB9RgY7XMu3?=
 =?us-ascii?Q?tsZ5OoQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vHMoh5Zjzen84Lddp9We4YuPZf3LTHAJ7ZnMpNfG2OQNaIY3VEjgxQ0U87Or?=
 =?us-ascii?Q?gzwqgYoyePzLMx728fv8xAXwOqzTO53aij8yF9Mo7kWm2H6iaj8zW9zmCK5E?=
 =?us-ascii?Q?urclTxQ/okzKtqr7lXu18JWRYu6KBoJAv1xVF/FVv2ccIqAXxmvO/QNZ/G7Y?=
 =?us-ascii?Q?WLOt0+C1+84eQdRyEfDcKV4nu/XvtdDdp3bXAUMp4E6pOBloiZDjSQojYeCu?=
 =?us-ascii?Q?JynEumNI7J1hiZr+BvxdN5Fe3Idc8wdv9O0PozYJhiBSXWEfnruWYzb3wuVY?=
 =?us-ascii?Q?kZQ8BVCmGwm0D8laTc0x1SfHF/5x+XzUVXglyevQtMnfH/wUsP68qu3YTd1C?=
 =?us-ascii?Q?ncyoprcwDFCvJx+tezltkouytEXgSUnNUW4Qf9LTpiqqXJeZ+U+02zKZt3W9?=
 =?us-ascii?Q?NCJx55YWL0gbrwmOF0VPI4bZumLu/ImE9KAJ2EL5bxhlazGEMasr1dJsgdeE?=
 =?us-ascii?Q?AO5XeNS6PSHPDpRqC+oEm/dpU1C2SrcWy3MpcfzbQq3ydIgvAtEoiIgyFr+h?=
 =?us-ascii?Q?+P+shtAzR+euGsSqQCnWy/PvM4hMJR4snNcVyhMEsp3cddYW991eyjOnzMIN?=
 =?us-ascii?Q?SOij2hCTvVPJwaeJ2zXlzUXq7n4lI/VRi7cQL83S8Iri0I/OiGjwBLlzUl18?=
 =?us-ascii?Q?Ja/3s34xKcKbDW/Bx+Dna9Vq3ktRFKKGz/+3cCae0HS1a/k+FMWxlzpgoSjC?=
 =?us-ascii?Q?pVH3dvjc/7FaPaAndMHFDu20mFwyj32/I/UqYVpvMI0PYeM8Y5bv2IumunoE?=
 =?us-ascii?Q?6WOsMvIbv6q27Z2q7iSXQphKzzCbGOj2N+oGbwoaYmNbzhXsNbeMX+/wn00t?=
 =?us-ascii?Q?FQkwmuBh+sMn1jef+ln4QQXXQTqcE3uKx+Zdu7Lq5QIZik2kexMfwrVxcbhb?=
 =?us-ascii?Q?xDl/VnfbP399oeqC7h4PYEH6XmSFNjdC5BiuoOQD3bGqvYKt4KFYwVHwXBii?=
 =?us-ascii?Q?V035T9mZCEwjK70IVoSbplt37NfVG+UiiyZJY0Arh6lUrwghv/KH/HUz+wTT?=
 =?us-ascii?Q?j1Ir6A0r3WHAt6SZphS9xEep+fEbjgIkO4RA+6bpyqu65hieqh9zseT7t62m?=
 =?us-ascii?Q?clQtca1Lz8Hdeavg1Q39JF0v/X3sK/mDhGzfE+UclFchySpVvyY45FklbDzv?=
 =?us-ascii?Q?WArlmUxpXrEJkBY15WVoO0PQud2FNeSOIEhIslNjThMPEw++QpEtXp2GsHz7?=
 =?us-ascii?Q?jEqqMA58YE1UH4Aa/eQLH3Icl3H8o4oxmJjhC0bGnSLOhUxp2TDOBgAYhQkO?=
 =?us-ascii?Q?zE9fwDusARCyecbFc0KP0WL0sW9fUXrCr0sIIqHetX49cL1xkkMOpgwD2SZs?=
 =?us-ascii?Q?ejRpwj79k3ZxldMe2WmrbCloYNsOAaRt+ZS+cgorJVbjRelX4KM/GrIsU0Wm?=
 =?us-ascii?Q?WgLkZPDWvAept5jEXm4bm2nT8RBkVoadZ6CeJ+7cXuaIOLtAOV1GwfoP9y+l?=
 =?us-ascii?Q?Pik6TbmoZ1rjkKrIO0f9sd0qdHj6cudku345kP0bPbYtkQR//4ADtJAX30SS?=
 =?us-ascii?Q?VCSswi3XnYi9nRTGihgrV5jnVvAQYN5iSvR7YiisT5elAY5A3rlThmqi1qTi?=
 =?us-ascii?Q?Us1s4mSIJpTez2VHr9sWk3FYp2F73gTxY+GYeK4i?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RzzLg7zB79ZC/IJSnROqszWChhtCPaAMbyaZ6apuq2MMzpxnmbVx3lq1NpsgQuFrOMhbpIY2V685M55+y4eNIfz+V4nv640Xagv+RFFGv5jJrjzjbQXCys1AZR4SH+N/Q1ORTKw4jed983SfGSs1unppK1sYqMyTK+PjCsISq8G3+v/T1BdE9+YLC8q6yetnJ9GLRvwh3jUrHNEB1iS1gulroaoOn+AxKSIiea85DOGUEE3mug8ZrYK0lqQac39eOh+zvfBYN7+B1mwakKS6EggkiFrvCXTQ3jyzIJLviBwHXOqQNHrEYSc0KUXwuzLGZJpGe7vD3ST1vSYtwpetyKhJFR/m/0+RaNF5P10BIYjleys5KePjQzKlFH50dd2eKcJEAesrqQUyxPVbwohKjgb0acmgKNjXN2jwZa6YGDksJ46GH+DTYVsH23LbURb44Li+s9i7ThRXeQsXtvT3PxflgHU4Y+32Svq/yr3PRBOewTCoVrJCO5mxPBcaK26UtSQL065c4sCl8sKMoj6Fa3W3ejoXtXHiOUCEMI8DQQGqXJiCO/jqcl/sflP9+xiav/4h8/E2UN9tgqHWdY20Wvs5PBFG0gs0Nge0GKXdfpY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1b38d3-2e57-4920-ffb2-08ddd32c58aa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 07:55:57.8363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 64EdQC/JEH241ldMiXNuoF86ViAUPNNfBJUv9yblqIf5YnSdRIQFDbqGqEAKV3oAbA2y5zvvZV5T18Y7w+KxIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040041
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0MiBTYWx0ZWRfXzmc2RSa907pp
 yxHv5a67x1k4HVTCgEh0nDT20iizJ5mYIAh2oCrrl+PvGUVOJcr1vgemLRw2ftY7eQ6/paYj8xR
 nMf3XNZ2mdgLcztsjKcIM38ed2pgcQCa6RC/yqF/gKqQDT/kmmTUGJ4ATI7hzpbuJUbW8SSmyAj
 j3ePpi10UPFuDHoVpuqGQraYkdWqVwmEYwjAKcRcT9iQT3gaRZy423nTDdRgnOyirILqGxnfKzc
 zv+v2rzseaSFzLvZVtDZiNVjcUT8Q0xq7WI9LrNcd3LS1kjTrYowmdmUBIvP0pNNAIMLGQHabzJ
 ENR8Cn0JctsY2cY6N9czI12muScgnDDICXeIQIAMT5w5Eg+7FiZNu4bva1Bbp2aDxme9MOn705R
 tq99IB5Ak0GSBk3tAPW2H4wQgGHnHtt9UuDsvyDf+tsRlsfyEvkpLn5zJkiRVX4+H7cxF9WE
X-Proofpoint-GUID: EWSfRUAK4cX0OFgWK8CSuNOBU0x6cjOC
X-Proofpoint-ORIG-GUID: EWSfRUAK4cX0OFgWK8CSuNOBU0x6cjOC
X-Authority-Analysis: v=2.4 cv=VMvdn8PX c=1 sm=1 tr=0 ts=689067a1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Oh2cFVv5AAAA:8 a=KKAkSRfTAAAA:8
 a=21D8NHQQAAAA:8 a=X6i5wfACDdJPGZCuSDMA:9 a=CjuIK1q_8ugA:10
 a=7KeoIwV6GZqOttXkcoxL:22 a=cvBusfyB2V15izCimMoJ:22 a=aE7_2WBlPvBBVsBbSUWX:22
X-Stat-Signature: bkdit35ky38f9fa4awjckpcifpwj1c6i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6EB9D120004
X-Rspam-User: 
X-HE-Tag: 1754294187-338540
X-HE-Meta: U2FsdGVkX19O5Q4/Y5feVqK184apS6dCTo6mO6UKPVfeAsJzgP3ZgTPgou8/y5yLUwCb60uVKD1/d0hq3CLmFN8YCmk4984ioU9ZiR3esoeyMkVZ4XNHY5LCRQuxGCYrO1tEKHz6MWzQFk1EtsY+fDoTlU5jKCHPBDZS7gn04xF0M/d1HHqJBq0MFOpbAuwJer76ar5c3bXIeVJpXcxZKoezHAgeiNk8eA91yCQn5gxmvF5ygodeDKrtjy/2lyirpVYV+koqIlU7rkTNvW5/8jyS85Velwpyd7So1bcA3ry8sQfqTSCTTKiOzPRX9stjn5kc6JB4KVlw9XZ8pcxEh6rf10T8I+wX/muarGHZAYYOuHvdDY1P47idu2QNFuWTe+uJ0HJdHymYxQ4Q+VWqtWxcisTnqRfJZGld1yaQiCuXp8IUb5iCGqnSSnFfYmK7BZpwT1O95AqLASKMO2Ad5p1GwLakBOUG33InA2dAF1I+joI5IxOzylIwzkcXmCXAHhicrTZxQ2lCjC6flCWaSBABOYIZfS2UXlAvO/R1w4sPMBH0yfFTwjnuUQE41eiQxGVH6YCXpYC8oTuRcI8gTBbkAtXm2Ox/xF/E/LGdY430hH3jd15tUrKMNRb8vRcR9U1ybp1QyHKBcKaECKIm8BMlzFgua/70ruRX5PXuHaNXx107QANipbhkpVH8gnet9ABjwIFdoNrqRrePDDd4bn8SgmMY74vC3YoegCcMVrU1HjbCiD7F9Q1cCizpWCq0eoWi3pjvQDv48z8/CpySHVnnSEJ4JOhzlIP2zW3VdsEqJ/cnFHPAtDWj7eSjJQY+QBuL93dMTNf9TIl57SN2ebKpelKMHwGUNIX7GrjrHr+aw733c2i8/+PctOkPxldgsQRGmH1koNcCnbMP7qliCgxXNDHR8e10EyllMlPBjNcUbClPu2a6QjX+dfrbgwF5hyR4GdO9T+DtbWkGVZC
 XOW7VOd2
 ZvZdcaTmF7MMKfmteGdyOLYm6pPVJaVLfu8aRYCZ4b/U9eWJLF92H5/gMjmANusGKe2z/+FP24ZhQMfV3VoRmFajhsA2t0onH0GRlFjby9Q7rSa/5c9B+uGpFv7z59Ta1A5bdxqGAoLZz372FHHO/AKvBG3djBtN7f1w6fdU6bjRSD7UxLKoNwmtWY0n0y0Ih3nQ5OvXWsxcUPPDXMljyqX1BFmrXDJB81Pr9cvcA3iRswYzI7RZPiCYS6d8Q1Wc8mmWIKaa22jlcuaG+hcxgp7VRGPqTOax0nxAXj/UVvhY/P0zGxZFW1iLJig/WVDTd8l0T+Os7AHGzOwTXQS4jAn5nHLdV/aOBe++lEJrJL6W49+P13VH5qHh/mKBjSwLK0mQZ7uZPt2/g5ETbgfP4FJSDu4GKqrbye3OQNKu+FgnQ/dEEEX6ihJglBURxNXG6TpcKQDsnqw+zUdxdWsEfvxpVUVFx5lTcLSa6lzMm/PwCuXhg/kUk7Liu6iD18HsDvbdhRB2dKujk1RRrhPLn3UuT3xAuIHjFNYwmQgRTE2GvBw+yY62PfPgTKWzHvEJbNcMLv6gw2BDAnqKoTVpx7GSuRNqLiPh6kvHFlkb2Qw6yWdB7sgTyjSkp4rv/g63kdI//csUr+jJtbuNFeqEd4M/9ZNAJVR8FahBeDmnclvCnNDO5/L3oOOY4qUvrjA8VmNRewUYB31NTLL/SFRR6u3sbpyHczRAzG/HBSTom9ZjRYubBoIWc6y8lrzOjEFqJ3eRNKAxSw2jqF8FYuilqPN0AHfwDy+o63Xck1odRolNHB+JukbX/cEEeZxFlR7v/V48d9k5aGe+SvWUtvZbnG6Sbs8j7MU1F7sw1vdOpDocIBRFiIviP6lbsepztynVU1EAI5d8eKcq9HytzTb1laVrFSY1uYXKBokxxElevtkZSYu7/+tXdeRpQ7YnwrGig2VWBvrPxmJoaUOxdj24jv+56tL4Q
 rnenp2qo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 02, 2025 at 03:45:51PM +0530, Naresh Kamboju wrote:
> Regressions found while validating Linux next on the Radxa Rock Pi 4B
> platform, we observed kernel crashes and deadlock warnings when running LTP
> syscall and controller tests under specific PREEMPT_RT configurations.
> These issues appear to be regressions introduced in next-20250729.
> 
> * CONFIG_EXPERT=y
> * CONFIG_PREEMPT_RT=y
> * CONFIG_LAZY_PREEMPT=y
> 
> Regression Analysis:
> - New regression? Yes
> - Reproducibility? Intermittent
> 
> First seen on the next-20250729
> Good: next-20250728
> Bad: next-20250729 and next-20250801
> 
> Test regression: next-20250729 rock Pi 4b Internal error Oops
> kmem_cache_alloc_bulk_noprof
> Test regression: next-20250729 rock Pi 4b WARNING kernel locking
> rtmutex.c at __rt_mutex_slowlock_locked
> Test regression: next-20250729 rock Pi 4b WARNING kernel rcu
> tree_plugin.h at rcu_note_context_switch
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for the report, Naresh!

based on the stack trace, I think there might be a use-after-free or
buffer overflow bug that could trigger this.

Could you please try to reproduce it with KASAN enabled to confirm that
it is the case?
 
> ## Test log
> [  527.570253] Unable to handle kernel paging request at virtual
> address 003f0020f94020a1
> [  527.570274] Mem abort info:
> [  527.570277]   ESR = 0x0000000096000004
> [  527.570282]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  527.570288]   SET = 0, FnV = 0
> [  527.570292]   EA = 0, S1PTW = 0
> [  527.570297]   FSC = 0x04: level 0 translation fault
> [  527.570302] Data abort info:
> [  527.570305]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> [  527.570310]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> [  527.570316]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> [  527.570322] [003f0020f94020a1] address between user and kernel address ranges
> [  527.570330] Internal error: Oops: 0000000096000004 [#1]  SMP
> [  527.570336] Modules linked in: brcmfmac rockchip_dfi brcmutil
> cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
> snd_soc_simple_card snd_soc_audio_graph_card hci_uart
> snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
> snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
> snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
> snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
> drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
> videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
> v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
> soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
> drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
> industrialio_triggered_buffer kfifo_buf rockchip_thermal
> pcie_rockchip_host coresight_cpu_debug fuse drm backlight
> [  527.570493] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Not tainted
> 6.16.0-next-20250801 #1 PREEMPT_RT
> [  527.570502] Hardware name: Radxa ROCK Pi 4B (DT)
> [  527.570506] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  527.570512] pc : kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
> (discriminator 1) mm/slub.c:5403 (discriminator 1))
> [  527.570527] lr : kmem_cache_alloc_bulk_noprof
> (include/linux/atomic/atomic-arch-fallback.h:457
> include/linux/atomic/atomic-instrumented.h:33
> include/linux/kfence.h:127 mm/slub.c:5307 mm/slub.c:5403)
> [  527.570533] sp : ffff80008e24b8f0
> [  527.570536] x29: ffff80008e24b930 x28: 00ff000000584610 x27: ffff800082b30538
> [  527.570545] x26: ffff8000816b64dc x25: 0000000000000cc0 x24: 0000000000000000
> [  527.570554] x23: 0000000000000004 x22: ffff0000f7579d20 x21: 0000000000000001
> [  527.570563] x20: 0000000000000001 x19: ffff000000405b00 x18: ffff80008e24bcd0
> [  527.570572] x17: 0000000000000000 x16: ffff800081e18420 x15: 0000ffffa2670fff
> [  527.570582] x14: 0000000000000000 x13: 1fffe000017942e1 x12: 0000ffffa2470fff
> [  527.570591] x11: ffff00000bca1708 x10: 0000000000000001 x9 : ffff8000816e41a4
> [  527.570600] x8 : ffff80008e24b850 x7 : fefefefefefefefe x6 : ffff800082b30000
> [  527.570608] x5 : d63f0020f9402021 x4 : ffff0000f7579d58 x3 : 0000000000000000
> [  527.570617] x2 : 0000000000000000 x1 : 0000000000000100 x0 : 0000000000000080
> [  527.570627] Call trace:
> [  527.570631] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343

It crashes in get_freepointer() because a bad pointer is passed to it.

I think it is reasonable to suspect that the freelist chain is corrupt
due to a use-after-free or buffer overflow (either in maple tree code,
or something else that shares the cache with maple tree nodes).

> (discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
> [  527.570639] mas_alloc_nodes (lib/maple_tree.c:1278)
> [  527.570651] mas_node_count_gfp (lib/maple_tree.c:1339)
> [  527.570661] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1))
> [  527.570667] __split_vma (mm/vma.c:528 (discriminator 1))
> [  527.570677] vma_modify (mm/vma.c:1633)
> [  527.570685] vma_modify_flags (mm/vma.c:1650)
> [  527.570694] mprotect_fixup (mm/mprotect.c:819)
> [  527.570704] do_mprotect_pkey (mm/mprotect.c:993)
> [  527.570713] __arm64_sys_mprotect (mm/mprotect.c:1011)
> [  527.570722] invoke_syscall (arch/arm64/include/asm/current.h:19
> arch/arm64/kernel/syscall.c:54)
> [  527.570731] el0_svc_common.constprop.0
> (include/linux/thread_info.h:135 (discriminator 2)
> arch/arm64/kernel/syscall.c:140 (discriminator 2))
> [  527.570737] do_el0_svc (arch/arm64/kernel/syscall.c:152)
> [  527.570744] el0_svc (arch/arm64/include/asm/irqflags.h:82
> (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> [  527.570752] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
> [  527.570760] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> [ 527.570772] Code: 1400000c f94002c5 b4000aa5 b9402a60 (f86068a0)
> All code
> ========
>    0: 1400000c b 0x30
>    4: f94002c5 ldr x5, [x22]
>    8: b4000aa5 cbz x5, 0x15c
>    c: b9402a60 ldr w0, [x19, #40]
>   10:* f86068a0 ldr x0, [x5, x0] <-- trapping instruction
> 
> Code starting with the faulting instruction
> ===========================================
>    0: f86068a0 ldr x0, [x5, x0]
> [  527.570778] ---[ end trace 0000000000000000 ]---
> [  527.570800] ------------[ cut here ]------------
> [  527.570803] rtmutex deadlock detected
> [  527.570827] WARNING: kernel/locking/rtmutex.c:1674 at
> __rt_mutex_slowlock_locked.constprop.0+0x800/0x8e0, CPU#3: mkdir/34254
> [  527.570841] Modules linked in: brcmfmac rockchip_dfi brcmutil
> cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
> snd_soc_simple_card snd_soc_audio_graph_card hci_uart
> snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
> snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
> snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
> snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
> drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
> videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
> v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
> soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
> drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
> industrialio_triggered_buffer kfifo_buf rockchip_thermal
> pcie_rockchip_host coresight_cpu_debug fuse drm backlight
> [  527.570965] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Tainted: G      D
>            6.16.0-next-20250801 #1 PREEMPT_RT
> [  527.570973] Tainted: [D]=DIE
> [  527.570976] Hardware name: Radxa ROCK Pi 4B (DT)
> [  527.570979] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  527.570985] pc : __rt_mutex_slowlock_locked.constprop.0
> (kernel/locking/rtmutex.c:1674 (discriminator 1)
> kernel/locking/rtmutex.c:1734 (discriminator 1)
> kernel/locking/rtmutex.c:1760 (discriminator 1))
> [  527.570993] lr : __rt_mutex_slowlock_locked.constprop.0
> (kernel/locking/rtmutex.c:1674 (discriminator 1)
> kernel/locking/rtmutex.c:1734 (discriminator 1)
> kernel/locking/rtmutex.c:1760 (discriminator 1))
> [  527.571001] sp : ffff80008e24b2e0
> [  527.571004] x29: ffff80008e24b370 x28: ffff000007c1a600 x27: ffff000007c1a601
> [  527.571013] x26: ffff80008e24b318 x25: ffff000007c1a600 x24: 00000000ffffffdd
> [  527.571023] x23: 00000000ffffffdd x22: 0000000000000001 x21: ffff000007c1a601
> [  527.571032] x20: ffff80008e24b2f0 x19: ffff00001d756e30 x18: 0000000000000000
> [  527.571041] x17: 65676e6172207373 x16: 6572646461206c65 x15: 0000000000000000
> [  527.571050] x14: 0000000000000020 x13: 0a64657463657465 x12: 64206b636f6c6461
> [  527.571059] x11: 656820747563205b x10: ffff800082adac08 x9 : ffff80008015020c
> [  527.571068] x8 : ffff80008e24af08 x7 : 0000000000000001 x6 : ffff800082a5e000
> [  527.571077] x5 : ffff000007c1a600 x4 : 0000000000000000 x3 : 0000000000000027
> [  527.571086] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000007c1a600
> [  527.571094] Call trace:
> [  527.571097] __rt_mutex_slowlock_locked.constprop.0
> (kernel/locking/rtmutex.c:1674 (discriminator 1)
> kernel/locking/rtmutex.c:1734 (discriminator 1)
> kernel/locking/rtmutex.c:1760 (discriminator 1)) (P)
> [  527.571107] __rwbase_read_lock (kernel/locking/rwbase_rt.c:114)
> [  527.571117] down_read (kernel/locking/rwsem.c:1540)
> [  527.571126] acct_collect (arch/arm64/include/asm/jump_label.h:36
> include/linux/mmap_lock.h:41 include/linux/mmap_lock.h:454
> kernel/acct.c:597)
> [  527.571135] do_exit (kernel/exit.c:932)
> [  527.571143] make_task_dead
> (arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
> arch/arm64/include/asm/atomic.h:52 (discriminator 2)
> include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 2)
> include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 2)
> include/linux/atomic/atomic-instrumented.h:454 (discriminator 2)
> kernel/exit.c:1049 (discriminator 2))
> [  527.571150] die (arch/arm64/kernel/traps.c:231)
> [  527.571157] die_kernel_fault (arch/arm64/mm/fault.c:313)
> [  527.571167] __do_kernel_fault (arch/arm64/mm/fault.c:375 (discriminator 5))
> [  527.571177] do_bad_area (arch/arm64/mm/fault.c:482)
> [  527.571186] do_translation_fault (arch/arm64/mm/fault.c:792)
> [  527.571195] do_mem_abort (arch/arm64/mm/fault.c:929 (discriminator 1))
> [  527.571204] el1_abort (arch/arm64/include/asm/daifflags.h:28
> arch/arm64/kernel/entry-common.c:482)
> [  527.571210] el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:637)
> [  527.571218] el1h_64_sync (arch/arm64/kernel/entry.S:591)

The deadlock wouldn't have been triggered if it didn't crash in SLUB, so
this looks rather irrelevant.

-- 
Cheers,
Harry / Hyeonggon

> [  527.571225] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
> (discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
> [  527.571232] mas_alloc_nodes (lib/maple_tree.c:1278)
> [  527.571241] mas_node_count_gfp (lib/maple_tree.c:1339)
> [  527.571251] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1))
> [  527.571257] __split_vma (mm/vma.c:528 (discriminator 1))
> [  527.571265] vma_modify (mm/vma.c:1633)
> [  527.571273] vma_modify_flags (mm/vma.c:1650)
> [  527.571282] mprotect_fixup (mm/mprotect.c:819)
> [  527.571290] do_mprotect_pkey (mm/mprotect.c:993)
> [  527.571299] __arm64_sys_mprotect (mm/mprotect.c:1011)
> [  527.571308] invoke_syscall (arch/arm64/include/asm/current.h:19
> arch/arm64/kernel/syscall.c:54)
> [  527.571314] el0_svc_common.constprop.0
> (include/linux/thread_info.h:135 (discriminator 2)
> arch/arm64/kernel/syscall.c:140 (discriminator 2))
> [  527.571321] do_el0_svc (arch/arm64/kernel/syscall.c:152)
> [  527.571327] el0_svc (arch/arm64/include/asm/irqflags.h:82
> (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> [  527.571334] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
> [  527.571341] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> [  527.571349] ---[ end trace 0000000000000000 ]---
> [  527.571354] ------------[ cut here ]------------
> [  527.571356] Voluntary context switch within RCU read-side critical section!
> [  527.571372] WARNING: kernel/rcu/tree_plugin.h:332 at
> rcu_note_context_switch+0x4ec/0x538, CPU#3: mkdir/34254
> [  527.571383] Modules linked in: brcmfmac rockchip_dfi brcmutil
> cfg80211 snd_soc_hdmi_codec dw_hdmi_i2s_audio dw_hdmi_cec
> snd_soc_simple_card snd_soc_audio_graph_card hci_uart
> snd_soc_rockchip_i2s snd_soc_es8316 snd_soc_spdif_tx
> snd_soc_simple_card_utils btqca rtc_rk808 rockchipdrm btbcm
> snd_soc_core dw_hdmi_qp bluetooth snd_compress reset_gpio analogix_dp
> snd_pcm_dmaengine panfrost hantro_vpu dw_mipi_dsi rfkill rockchip_rga
> drm_shmem_helper drm_dp_aux_bus snd_pcm gpu_sched dw_hdmi pwrseq_core
> videobuf2_dma_sg v4l2_vp9 snd_timer drm_display_helper v4l2_h264
> v4l2_jpeg phy_rockchip_pcie snd v4l2_mem2mem cec videobuf2_dma_contig
> soundcore videobuf2_memops drm_client_lib videobuf2_v4l2
> drm_dma_helper videobuf2_common rockchip_saradc drm_kms_helper
> industrialio_triggered_buffer kfifo_buf rockchip_thermal
> pcie_rockchip_host coresight_cpu_debug fuse drm backlight
> [  527.571503] CPU: 3 UID: 0 PID: 34254 Comm: mkdir Tainted: G      D
> W           6.16.0-next-20250801 #1 PREEMPT_RT
> [  527.571512] Tainted: [D]=DIE, [W]=WARN
> [  527.571514] Hardware name: Radxa ROCK Pi 4B (DT)
> [  527.571517] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  527.571523] pc : rcu_note_context_switch
> (kernel/rcu/tree_plugin.h:332 (discriminator 1))
> [  527.571529] lr : rcu_note_context_switch
> (kernel/rcu/tree_plugin.h:332 (discriminator 1))
> [  527.571535] sp : ffff80008e24b1e0
> [  527.571538] x29: ffff80008e24b1e0 x28: ffff000007c1a600 x27: ffff000007c1a601
> [  527.571548] x26: 0000000000000000 x25: ffff000007c1a600 x24: ffff800082a60368
> [  527.571557] x23: 0000000000000000 x22: ffff000007c1a600 x21: ffff800083125260
> [  527.571566] x20: 0000000000000000 x19: ffff0000f7576080 x18: 0000000000000000
> [  527.571575] x17: 65676e6172207373 x16: 6572646461206c65 x15: 0000000000000000
> [  527.571583] x14: 0000000000000020 x13: 216e6f6974636573 x12: 206c616369746972
> [  527.571593] x11: 6320656469732d64 x10: 6165722055435220 x9 : ffff80008015020c
> [  527.571602] x8 : 6863746977732074 x7 : 7865746e6f632079 x6 : 7261746e756c6f56
> [  527.571611] x5 : ffff80008317146f x4 : 0000000000000000 x3 : 0000000000000027
> [  527.571619] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000007c1a600
> [  527.571628] Call trace:
> [  527.571630] rcu_note_context_switch (kernel/rcu/tree_plugin.h:332
> (discriminator 1)) (P)
> [  527.571638] __schedule (kernel/sched/core.c:634
> kernel/sched/sched.h:1519 kernel/sched/sched.h:1841
> kernel/sched/core.c:6865)
> [  527.571647] rt_mutex_schedule (kernel/sched/core.c:7044
> kernel/sched/core.c:7339)
> [  527.571655] __rt_mutex_slowlock_locked.constprop.0
> (kernel/locking/rtmutex.c:1676 kernel/locking/rtmutex.c:1734
> kernel/locking/rtmutex.c:1760)
> [  527.571665] __rwbase_read_lock (kernel/locking/rwbase_rt.c:114)
> [  527.571674] down_read (kernel/locking/rwsem.c:1540)
> [  527.571683] acct_collect (arch/arm64/include/asm/jump_label.h:36
> include/linux/mmap_lock.h:41 include/linux/mmap_lock.h:454
> kernel/acct.c:597)
> [  527.571690] do_exit (kernel/exit.c:932)
> [  527.571696] make_task_dead
> (arch/arm64/include/asm/atomic_ll_sc.h:95 (discriminator 2)
> arch/arm64/include/asm/atomic.h:52 (discriminator 2)
> include/linux/atomic/atomic-arch-fallback.h:564 (discriminator 2)
> include/linux/atomic/atomic-arch-fallback.h:1020 (discriminator 2)
> include/linux/atomic/atomic-instrumented.h:454 (discriminator 2)
> kernel/exit.c:1049 (discriminator 2))
> [  527.571703] die (arch/arm64/kernel/traps.c:231)
> [  527.571710] die_kernel_fault (arch/arm64/mm/fault.c:313)
> [  527.571719] __do_kernel_fault (arch/arm64/mm/fault.c:375 (discriminator 5))
> [  527.571729] do_bad_area (arch/arm64/mm/fault.c:482)
> [  527.571738] do_translation_fault (arch/arm64/mm/fault.c:792)
> [  527.571746] do_mem_abort (arch/arm64/mm/fault.c:929 (discriminator 1))
> [  527.571755] el1_abort (arch/arm64/include/asm/daifflags.h:28
> arch/arm64/kernel/entry-common.c:482)
> [  527.571761] el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:637)
> [  527.571769] el1h_64_sync (arch/arm64/kernel/entry.S:591)
> [  527.571775] kmem_cache_alloc_bulk_noprof (mm/slub.c:5343
> (discriminator 1) mm/slub.c:5403 (discriminator 1)) (P)
> [  527.571782] mas_alloc_nodes (lib/maple_tree.c:1278)
> [  527.571792] mas_node_count_gfp (lib/maple_tree.c:1339)
> [  527.571802] mas_preallocate (lib/maple_tree.c:5538 (discriminator 1))
> [  527.571808] __split_vma (mm/vma.c:528 (discriminator 1))
> [  527.571816] vma_modify (mm/vma.c:1633)
> [  527.571824] vma_modify_flags (mm/vma.c:1650)
> [  527.571833] mprotect_fixup (mm/mprotect.c:819)
> [  527.571842] do_mprotect_pkey (mm/mprotect.c:993)
> [  527.571850] __arm64_sys_mprotect (mm/mprotect.c:1011)
> [  527.571859] invoke_syscall (arch/arm64/include/asm/current.h:19
> arch/arm64/kernel/syscall.c:54)
> [  527.571866] el0_svc_common.constprop.0
> (include/linux/thread_info.h:135 (discriminator 2)
> arch/arm64/kernel/syscall.c:140 (discriminator 2))
> [  527.571872] do_el0_svc (arch/arm64/kernel/syscall.c:152)
> [  527.571878] el0_svc (arch/arm64/include/asm/irqflags.h:82
> (discriminator 1) arch/arm64/include/asm/irqflags.h:123 (discriminator
> 1) arch/arm64/include/asm/irqflags.h:136 (discriminator 1)
> arch/arm64/kernel/entry-common.c:169 (discriminator 1)
> arch/arm64/kernel/entry-common.c:182 (discriminator 1)
> arch/arm64/kernel/entry-common.c:880 (discriminator 1))
> [  527.571885] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:899)
> [  527.571893] el0t_64_sync (arch/arm64/kernel/entry.S:596)
> [  527.571900] ---[ end trace 0000000000000000 ]---
> [  540.645451] sched: DL replenish lagged too much
> 
> ## Source
> * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
> * Git sha: 54efec8782214652b331c50646013f8526570e8d
> * Git describe: next-20250729
> * Project details:
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250729
> * Architectures: arm64
> * Toolchains: gcc-13
> * Kconfigs: Preempt_rt
> 
> ## Test
> * Test log 1: https://qa-reports.linaro.org/api/testruns/29282584/log_file/
> * Test log 2:https://qa-reports.linaro.org/api/testruns/29337984/log_file/
> * Test lava log: https://lkft.validation.linaro.org/scheduler/job/8373114#L19186
> * Test details:
> https://regressions.linaro.org/lkft/linux-next-master/next-20250729/log-parser-test/exception-rtmutex-deadlock-detected/
> * Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/30XMjtCEi0VzsU1gYZ0a7kcTkLJ
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/30fq2ElntxgscJ13dnaD7iL5Z1G/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/30fq2ElntxgscJ13dnaD7iL5Z1G/config
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

