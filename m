Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F3BCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533F78E0018; Mon, 10 Nov 2025 03:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E3F28E0002; Mon, 10 Nov 2025 03:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384C98E0018; Mon, 10 Nov 2025 03:57:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21EA88E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:57:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0B1B5D262
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:57:14 +0000 (UTC)
X-FDA: 84094093188.12.8011AB2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 562A5140008
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:57:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gsMQldpw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SWp9HAFV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762765031; a=rsa-sha256;
	cv=pass;
	b=q8e7dKH22L2JXQsGnzOaOqD66uBw5sTQi6Tpi68pD1J6RdP95inJTUTk70XMK4O2uuzKBM
	NFAKcZwplckpFrx07E8+1AziOf1o5wrDRSoxPJe0O4wZDL6+UvI6j9K1bDC35HHyoghMK8
	0CRwCEwdgBWh2oZ+gOQxhiZ50cys0+A=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gsMQldpw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SWp9HAFV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762765031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhMf5ECFhyelssTLmWfdgtuScgAK469rf62vdqatTvQ=;
	b=dLLF6RqDRdz27FccsMT1bdbw+HxjXz16aqbLbUa8mbw6E+r05s6CZb8y0u8eoiid3BpDj9
	VVxi13FoomXGguspykelkqc53tMpl6WhlqMcoE/kfyktK5ogUIPiwahS6GhUt65MyiM/6s
	Zyz3gGGnIjGYbaIA+ri6PoDbh+aBYHA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA7tYCt004499;
	Mon, 10 Nov 2025 08:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nhMf5ECFhyelssTLmW
	fdgtuScgAK469rf62vdqatTvQ=; b=gsMQldpwGk8wfJl21khrpOMDf5w+yG517J
	udecS3S+L9Yu7yuXz1dUB0h3fTYb3n8X8jXFO/nLBteP1MNb7JEJQjQFHCs87lP7
	GvoDvrEvONEPQQAgtz0QXlLGkJDyFiQrdUB2SkmMiT9ZV/GfF80w7lvIZH1n+zoS
	A9D48SNgeo3s5nBBrF1aLkG0e3tRG+TLPmT1IE4wj1wV71vbdTZCB44lNLI1lL4/
	00CYGVvGFAZETTDG3hfiyNwV8DGoYjE6PGiK15g/jnXak93DQBa5zfNRqYtjMf7z
	CW65qIaQILE7tJhxLXHCGxCy0M4De0TebbiKakQQmbbA7FejHOJA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abc33r41b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 08:56:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA83m5U040166;
	Mon, 10 Nov 2025 08:56:55 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va7vgaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 08:56:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vP1muyYEK4lGBuggAhlcohIwi2Z02L5oFZauX8h0dQJubrnQMxa1ZJZQAGqRmriBfUe2roEl52BQirSjxGfrZAqsh48CUBo3gPo6tNBDlCR5Fxjqbu4ZGte8HV86kzOPC/nFBO8m3O9GeDrR5ZwPudpcEIDNb0HJad97+219sXIvC8q9TgOuZl9x6pb7dmEW6rROrKgHfkIQ4EN/0zpxD5z0/LxdXjD7iybPaOk7hny9EC+QEgGF9NyQ4QbG7vyaX5w6fVFa4FIA9mx3n+/s8Jj5F0Jd0oxyyF97H+kAULPpnzcpxn2lJ8j3OwCbLhpYgQIHEtWMYDW6WTmPPjffFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhMf5ECFhyelssTLmWfdgtuScgAK469rf62vdqatTvQ=;
 b=BBIonDjTKYyRbe5+PZhZ8IuTjJr7aNTBv9yZMqsiVAHCU30gFqydWpfEWy6KVA4LqtbMHAxUG4jQQKwlV9qMfg75CimCt1canMkAtobx2AQW8ryazwuqSVHDm/9vx+JURzLzMq5Md0Wig4bFHV92/gPRGhz36cSOst8OQmDQcNnByka1jPSd66/0SlxAxb3OTBMSbNIOXfxjlR2u4BCyA5XNUC87UtgG8NfvESL+DzwLcRQqa0SPEJ3vw0n13vV614QcfSaaAdDcZzOAOQsMxCpjan6S2aAWKJBSXi5ofgwgZd7sUjwhzxrGS+oAffC+bFTO9vzn3JOuv0ObKPispg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhMf5ECFhyelssTLmWfdgtuScgAK469rf62vdqatTvQ=;
 b=SWp9HAFVGBnjtgEu8VesI7Jv4tbAEs1Fok+xM85QnpbPdP8y9GA5DDhIPsHnc2WBKm+QaJoC4ZnN6D6e+SAkFiJQ5Y4pY+dev7cPFyTkXnpi1dF47frsE4Zu1I7hahIUbTeRbdZjA2fKw6/Xe473QRDOZNv/V+JhF+kZnP07WCI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CYXPR10MB7974.namprd10.prod.outlook.com (2603:10b6:930:da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 08:56:53 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 08:56:53 +0000
Date: Mon, 10 Nov 2025 17:56:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH] mm: vmstat: correct the comment above
 preempt_disable_nested()
Message-ID: <aRGozmeFB1VhAx5x@hyeyoo>
References: <20251110084437.46701-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110084437.46701-1-qi.zheng@linux.dev>
X-ClientProxiedBy: SE2P216CA0061.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CYXPR10MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: c6f3823f-4fea-4ecb-89cb-08de203717c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hp+hWGnSDFcQqOS5uONwpBKyXV8RHiBIV1Cn8+ZTW/iESuzFy9dXGLmayjGW?=
 =?us-ascii?Q?HcGvKd6Zq1gHSMDtafHhsxePCr+o9ppg8yoi1KH4m75oJFPF8zHEDbiDDGMc?=
 =?us-ascii?Q?2R1FG87K92duqm/53FV6OnSTdx9T4FJ680gGEUGCb8xGOrRzzH7GiFPjLSr8?=
 =?us-ascii?Q?WzHri8q4QWtc1LKOdnWkcHpo/XJ3kh6QFJY0GE61W5HWMIn6B/GIU6YYBjMf?=
 =?us-ascii?Q?j1PSSQFvUDw/F2oJVuZ+pymyt6V3QU6r2/nvOUvr/pniKlAdYh/HCE5nlPQh?=
 =?us-ascii?Q?U9PH7T5woi6Isc8yijYQ0weS2VHuINvEzGx48NQ0dpimf01G820DEec2roJk?=
 =?us-ascii?Q?Vr2qOUhHQrRz2BqgxRjFYpgsIWe1SN9e4IbVj8e0W/XecpNTinLUkaFvPOI7?=
 =?us-ascii?Q?NLpWQLkCiZxlbLQRRbBh9Ir7moHqqoKAHjR+rft+toPrDhk16NVM4re8K2E4?=
 =?us-ascii?Q?UkpacuHmEoRoStL+BK3Qlobo4VrdEb1BQlVlOe011LAiVYvYGfNmXSRw2AU0?=
 =?us-ascii?Q?FJq42zjEukIgam/dEV0wzi+zwVIogmNPSe1OJzurHRAMYIMxhA1q/VsZEtY5?=
 =?us-ascii?Q?03i7HZzWf3bQPDvO8/vsY2Muah38LhJm6HRXQAARWeyr0lJ8Qj7tfNb5Sq/Y?=
 =?us-ascii?Q?GjueQve1y1hje+0xrfvjirIWsC9nZ6LqKw2YZSsYpQorYOuXnOJz3O2kxmVP?=
 =?us-ascii?Q?02diNwD9lwlKzZipErjfVedBKNkcej3SNFjErB3d9wZA3WMfV8+xCOvtoxoO?=
 =?us-ascii?Q?uODr3AKQ+bAvpHViyrbXXiued6FTl+Qmr6FLhn6oZivr+XLdiq3MnGAeQc0u?=
 =?us-ascii?Q?KaVQ8wYShu31tah4kFfjtV4dS1YK7G+yZBwRw0ujQ3GL2F0Vx1a1U2xYJ1hb?=
 =?us-ascii?Q?m/uvJTU8QpEasccDW7zqjxa9swKE9iTvD3Vc1z6b6EpaZ8jBmJUR+ev7Em31?=
 =?us-ascii?Q?ZD58jbdIU9pLgQPK/KbqxbIASjIQo9Lhwrh7Ir1ltEdyxIRvs7XKX2AuGZut?=
 =?us-ascii?Q?splKh19kktO1z+GVI8PhFXzBf03S9grr7e9VV9ip+AETtH0BsvcLW+tINSXD?=
 =?us-ascii?Q?/j7dkZLVSESKylM1/H/2eTNbz2mVcmomCm9bRRZgd0Ux50ArNXtlbGFYOStN?=
 =?us-ascii?Q?b7fzojA/0Y3xtGqy2k5svuIa6FPYiD9e3Low8orTm7jw/BFlRgDDaMwBYHSI?=
 =?us-ascii?Q?nveC+vW1B8FF6oa2EdFvJN6igPOypjm8lB6XIQetOCWEGBwxlQgt5HcgGkIR?=
 =?us-ascii?Q?tjmM2p6sg01zlSYJHZZ7Qp+bmp/OD0VhUZrmo62VvYdWHYgm00zVcpYNVfVl?=
 =?us-ascii?Q?10iFonXFd1+4GaNC79E+2uHp9ihVHzyR/vZfEsr0zrDY6SfDucgFvaMgPmDy?=
 =?us-ascii?Q?2Tly1zM+YG8viBNIHrZ1qNHmBOAb6LzEr3QvciqXQh2jsN4eDCTiSY8rSLfr?=
 =?us-ascii?Q?xulDiS6D8kZFzfl6oOVZVmycqfWS0JMy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ladEGkeljmCPB5jAwcMN5dJdBnv3ehnvJC4cWTLdPaxrvJHdfNjshS+teqp6?=
 =?us-ascii?Q?vCLWwckLtAQ6PJHGBTyHLc39HpQ7hsnn5mO8BEOPkuPnIBfioTseIUH7ShcP?=
 =?us-ascii?Q?CENQULKW2RFdM9VVnEaPCwTqRhS5sIk0/1ghJa/Bn7nysYwkrxF8vjvuCD5M?=
 =?us-ascii?Q?HVCD0P3XLOA9DQK6RABYIjPjiTdm+cLT3nj8RltG+HOqn0fCbbBrQXUW/ssi?=
 =?us-ascii?Q?jwfHy0VlV/xZDDZN/gyXP8129C5CCyDPzRaWMrNekQTrlnbtxlPzzQa2VVBD?=
 =?us-ascii?Q?SbK6R1ckucv+tzgmgprIaMd62TML199fQvmR4kNdW6OywX1EHMFQaUg/wCgu?=
 =?us-ascii?Q?4DEFut6mon3KMwqq+FYnWUAbRyl5T4kgTEMOw/oQaWCnQIDMPEZVv9ZaWA/J?=
 =?us-ascii?Q?SvKQJESalGIDqTFzKw46qIehJO7ZOCDNDzPi46qsmQ4aQ/Yo9hYkrH7ibDNi?=
 =?us-ascii?Q?sC0DZnBlk9/SS05LeSsn5dI3kE+Gf/1py/1/K/+fMNvyMhqqgwI0eFjw5U4D?=
 =?us-ascii?Q?ttiJNl5a4+jSCOU3DW1tk0Up3Mhbyp8uIqaSS2bfwiW9lVFyvl5XHa+x8uuA?=
 =?us-ascii?Q?LO+wpNyVW3DHovopentEg2TaGUZ6OWDEjKH+BFzhCSZM8oO6pMZDoMqjBzTB?=
 =?us-ascii?Q?CGX+Rchy/VLhdty6uoCNPh9+VAarywSodEXmkLGDeVKGfKb3EGEu0yUPmwlA?=
 =?us-ascii?Q?3b263eoKyZXogXiMQ+VMLNZNQOARaXbcVOvMOxd5sRVeVxJyGQBaW+Vo5aTC?=
 =?us-ascii?Q?E1ZCLUCIhpf4MSdzzyUxNDWFCKsV8yuZ4VzB7b4ls7z32DDqIXy4euCqWzj5?=
 =?us-ascii?Q?GgTLKJ4uOlYgGObsAsHyelA7mBnku/c4yr6mOwstZbB5hgT+Rpp+gXLSWcMm?=
 =?us-ascii?Q?H8zl+4w7Mel5NmP05+Tm2Wh0xcvl5ItdsKM28m31CP5PL1hrERX5jUOv1DVp?=
 =?us-ascii?Q?ST8WykTQNT/3zIZ82SW8u/C2lVJ6fGXSG6V6Ft7zsHqctA+0vPg/HXHx4t7Z?=
 =?us-ascii?Q?6QTmi7ZJRiTOOP+Q6JD1KBPxJ1YCBah5G8bcPThPi9iM9nMf7+k28HpP1KLJ?=
 =?us-ascii?Q?4RqoFTf7DtqSUqF8AEQ+t8zIXWSpWE7ZYVvm409/B0bA1FPBZ1g73Z1l1qCD?=
 =?us-ascii?Q?W/GOQqDGT3HGEKERpJudcMhQM+JylWw3AtYi5g3KPgy5MJKV1sH+rLWWEVSz?=
 =?us-ascii?Q?LvAveoOt2krhiXWHUA1cYtYkspfMaU6UsALsF8OLpqgYSViOUPI0VL0V40/A?=
 =?us-ascii?Q?+WIpQTguf7sNVvdRsA+c1jCoUDvKpyTyLiTIjY5Fg3CJWsfdzmEATswpgCsD?=
 =?us-ascii?Q?H8QRQi83NWWVaL3Nlf8A4V47m8Nsiwq2R+rTGLjCGM6XRg9tIQLDoC7U3hlr?=
 =?us-ascii?Q?QQSuU3B65Fa+bTmJO2VTv63xvK9Wqbzp61AwGF5UYqFF5JLVLXe42Tq6IcVJ?=
 =?us-ascii?Q?rPY2UoeR7QBiUXtI/b0DP5zbtS7nfE1hW+LNU4FV9KmYhWdFIN8BT1Pro32y?=
 =?us-ascii?Q?rbSQ1QkAobdTmYjAMrUVrcAM34005D0nOVZ9SzcW0iVEIkF5dI/ilaK7m/7v?=
 =?us-ascii?Q?gY8TqkByWhAZzjp5mgncaCnw5AhZMsLe4iySzc8g?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mMh5wR57+8D3/tMRLGNfpzTLe3hhzeIF/l9kwfj3gUQGdSyb84VkJJYqOpt1nib9pyojaaYPVv1rebNIhahyXYV1lztq8CmV3+2cuPNMilKkvgLLgTOfGSpzpN30frEhsX8N/qa3SJCy+8SHvfOAXlCI6E/Gn3OR6nO1H0+PI/HhO/ViPGO5todWPAkzx7oziJ/N4avaVnoeA3c4hxhU74Ow71ZVHiVZdqu/dk8axKfoVh0X1yTZZGw5juu4KNXLq9SaFusx3LyQoFSd6io3vdk0E4EBrYnfaBHYXqDZnW0poDJBGfIBI7phbIu7Tp/3ONh8bQNX41hvzhSExcn0dyPjeqQdc8CUZ9UkszEv2+q4ZaifvwWzKo3EE5AT8Ulu6C3QyeCvU5V/l2nOMWrMzF46WSNOlTghYTIIMvdKGUGeqA0zVfPtiKmdQfCNbgFGqwsmfRFCac6AmYH4DIUqoaRXWn7TmlAqFEWRN7sCVchHUDRfRxqF2Qxq2SiTnhbW8F+tvX+xVt5A8Mg1ig7Yjad8KJHVJR021HxtNZMqmyMRTXt02Ijxealj5n4Lp09Ga3vyQl4bIkQcPj5FQG579JsqBMfjine+eO2hr9NIzv0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f3823f-4fea-4ecb-89cb-08de203717c3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 08:56:52.9108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5s8yF1aS31NuAKf0f2y+Wd2jU6wfYLd9dk3QbGBke+M2e8D3F7EatPHh67hhBkZHoqYyZAwbfW0rDSokvXV6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=631 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100078
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDA2OSBTYWx0ZWRfX4VTb16y8fMI7
 YKbNnE4nc4+dTUBhf15wZnrsTqe9BnXuC4UmYdSn17B/QgobvhfHnF0FEKkC8sQt++jVfIr58VX
 dPf+YfXymqtc4dm0epAX3CmAbjtO5m0QgmSHvfBmRF/E6g/4oDA/db2uc7iHebhQdQUsj2oOSuK
 04ETG2dL8monKMd0Nsk+9lUbQVnrC7M+e2vPABnH6sxiR0zLJJAa7MYri7CR09g42IrhSvof5YR
 ulrbvirV4iSXAt4wfKlxujt5HIUUlb23s0v5KJ+WOok32e+SmUxXX/nMNMbHRjI2Gd4fRBnCcL8
 4q7VKaeIcfvqfjOGDqviyuKl4UO/2AMiYsY7UJeNttwmbVK638MlRnf9GbeISzufW17qWPlbN85
 CU7LJXlBvFWVNzNzfLEGVrgiJJnrng==
X-Proofpoint-ORIG-GUID: fLG3mFsoONIQhni1oxSY9PVCKa3eKW-b
X-Proofpoint-GUID: fLG3mFsoONIQhni1oxSY9PVCKa3eKW-b
X-Authority-Analysis: v=2.4 cv=aPv9aL9m c=1 sm=1 tr=0 ts=6911a8d8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=aWT9NC-pKboVgujlGf0A:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 562A5140008
X-Rspamd-Server: rspam07
X-Stat-Signature: fkjwdsqzwqebrobapgwyki3z6wf7dnrm
X-Rspam-User: 
X-HE-Tag: 1762765031-128315
X-HE-Meta: U2FsdGVkX1/etaJfXvi87md8H/CTaVcvzT4giAI7UA2oWkvruz2Kz4FAy9nvYK6T2CTOBbA5nu13YHmIvcp2Up9V5ndGk2xmKktqetHPN2tPMY5fknMgDZv4Lr+QnJWjfK+gFnkYA5BdokZna8H4rACLFAFwtLVOE6FF02QDa+cQ0pput/AgysMMdknkMNm32wX5yczP2RLrKMROEHary2+0TNkTQyo26gh1V7vqpbeKVxxCuPBUSn/9VGiEwwwE3MLX9f7Bgc11vW+yThYhc4lmwOf+U8YvRkKu2Neh0hD7dWSJc6r2y1TW68k+6/TDTZQuqy+Ay/zYBSXIPZIM0kCpfUMBw5ESbi1EFFD9yhilZbgZwTtE4UZ53obpZ/vLfouhsE7UW2hELDZGJuYWXcxjLOtZbKFBauroeFBBCZz7BR7mUmnYp5y91E9u8bmGK+lw0xaO1R+OFpxcABNp8EnRij1FzbApVj2eg25m8PPWYQOpseJEpZJ1IQUi+ZG2bks/v7ZHagQLXXC+vMJbAPjiKhcV23kJ+Nv/Y12SgOSP3yMeOkbFX1s/KKUc3slEbTs/Pk8/k731OKJv2lOrtZ/tfGqNsvmC7WtFoQFLIwByNpuln7x+eKCMzwmmrjfvr1em/PyzQ7BsY9aGLNWhXH+asbcARasdvUMHJO0IEEYrlrQjHYih/60cooyqSwcC3d156APtIF0Px5Yv+0xGQOrgdv76U19VeBWvi2hFXiD24/kuDN78HdRodTGXcW/J6TLRUlq0tvKoyrB1f8skHx4bj+5GWIxLhLAtKaL4gbsdOqQPMTN/c5c5NDDiTqM4zQP200L5ZBy77Hik34N9NarL9Z/U541HnQIRZNozia5QNX5cV/oJhe2+RsrdcvjGeA+YO1uVVGXVuPLKQs+UVewCaFUKfT3cWRVTEWxNtRlUsrRJUkwjQcOHbAZ76DhZHGGli3DVfyM5FeLNaQT
 ZBD8XQQM
 aS5l6cEf4Jt5eKjVkxnQJk4vHijWwGVNbigbCboC6l7lzZsMgGtcIZLidhHgDBh7eLAy1xLLOJcWVuAwnH9GnXbhtmHrZSP+HA9eFoZevm7W0ZZTI0quijsssgU3+fdVoFBVl2+FZBAYsMr1CtV6/MPSywja9a3+MJw8GQs+pWuL4i+zqO3D/cggVS8IaHMBXJ0Tr6S8RKyC+gR7uje6MyUJlTj3pmW+VE6yV4q3Wd9emJTokaDI0YD055RDVXHcnCmW8RSXvPg5MhiI6gugakkulMMZPs2lL7ABt7okGpJbsEivqoHwCqJh20Mmvyo+/eSZYwdANlGjbqNzHYrQctxhCiZR+T745c2Li1EmBH9L9h6CskStSIBoCrIYWMjkQSbYIl6fLB49DM9F5zVsFmDaQf8g+gxqqaGcIuGuXSQYifPQ+paY44Xiq+uomfJ32Ce749WFBdAjbqGUckfRxq4fP7/L1w5Tcvjk++LQfef92+ze1fv1+B27/SglWyr7DtxEdTeIxiuMJIaS+d9WgrSqIlNvi+m7RU2JWvtnfnCMZtgtrhZaZ+/g/hkA1xB5edFGNs7dclvsiPwD+QGBH9mfrAEM66E6ivyipqKFWxxF1LPxFajkzlCHiz1/hhyliHm+oRa1qR1PKDMJtD/6P/x0I44cSH6GuyulWJ2QaDF/rVZEhNGiD0IaN+UPvBLqgHe2XvdWHKyJ7u4NrT8hJskg9o2EoeGDXXoC1i6d6T1xKQbXYE4zXvux2FzfXKjuY2MmJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 04:44:37PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The comment explaining why these parts use preempt_disable_nested() is in
> __mod_zone_page_state(), not in __mod_node_page_state(), so we should see
> __mod_zone_page_state(). Just correct it.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Acked-by: Harry Yoo <harry.yoo@oracle.com>

Yeah I was confused when all these comments says
"See __mod_node_page_state()" But even in the function it says
"See __mod_node_page_state()" :)

Thanks for fixing it!

-- 
Cheers,
Harry / Hyeonggon

