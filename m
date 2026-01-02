Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A05DEED628
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 17:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95D86B0088; Fri,  2 Jan 2026 12:46:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C192D6B0089; Fri,  2 Jan 2026 12:46:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A995A6B008A; Fri,  2 Jan 2026 12:46:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9100B6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 12:46:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B19D1A9ED5
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 17:46:41 +0000 (UTC)
X-FDA: 84287753802.10.1750B85
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id A757F140004
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 17:46:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kx8e2/jh";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TLEzvynV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767375997; a=rsa-sha256;
	cv=pass;
	b=aNTreKKpr4e6rVj/103/ZEMOpcEJCTAqcjKq56l2XQN1omqOEwWCtArAult9I7ZOoIJ8El
	8uxkS8gS2Rp7whRGUXBwcNvVrRZEmM1dlIWw/ynfaBPzzEREY/jl3m8g1KBW5k9+M0ealm
	av2q83zc9X9C+vrFM2p3MaNFlJUiCmk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kx8e2/jh";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TLEzvynV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767375997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kY+kOdx4myZqC4tdr/4VJFA8LuFBkMKlOLUVutyhsAY=;
	b=ShkRVrH3BLdO6d41fjxQDy6rSpJsbXsNDlffe1YkSQLIkgQN/dNJUBpXFaCukydIXebpz5
	zLNFHvhQLQBHHwDmfoyPmRXlNDNIQLoP5QYC8VYcWg3+bkYhyaA6SMFWB/T8m0xiHXLTMJ
	PfIzOFCSns/IAgyMavGBpVOexxvghio=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602BuqgN2738293;
	Fri, 2 Jan 2026 17:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kY+kOdx4myZqC4tdr/
	4VJFA8LuFBkMKlOLUVutyhsAY=; b=kx8e2/jhiD9xM80RSuSGZvrdiqIF94OAnE
	p4Nr0RllTbDUqa6VDbR9ATNdbariQrvY0vUhxHbwveHUXRYXPkRhyQFE7w3kB1mz
	qnCm553PzrEfOPh6hpHYhXAgckTb7NH9wTQAMpNroFfbthV8SW0NgHiOn/927uj0
	ABu5m0ouy+nolkqgoabAq47uyIa1AGAUnuqorBbE5Y8OqjDZBK6LaIi1Ku1tkTgk
	mBLGZA2KsKks8XmUyUeXeU1/JnSzBZ6VxFrKhU3pOnU2InPq0jGblWfQmNPg5sLX
	jjaGQ1BPyBKnsGniYLyHKviR2NM7qmWAOGLAKEpEq9kEmiHA13gg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba61wdbb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 17:46:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602FUrbi024686;
	Fri, 2 Jan 2026 17:46:29 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wmk5m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 17:46:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPItclZjQxNFN4fCe9RxSU+SnKmud+9ymMY5HNSBMqEZMP7N7cmxtJh83QMmTLtSsWLFAglEf96zDuFbQZ7tfn8YK6LQEDTs5kqsO9pj+48kwcUbrquflNOljtpyOm75tkQdhSH8tRCxhSIkSDiXzgSRHRXwvt21wYMaZvpf1w0ttmXF237ZGj7qCIQ3jrjz78S/4kErgDC/GNkWpWbIOTRg1aoWntlpIjQlZql2q3L7U+Li/SX5iM4G2u335EDf50VPN5ser74I9vvg72aWHQqImWFkHBA2M+0Lyc7bJgQ1lgnF7C15OTL8fBxgkiCt+2ee2/NrpfzQ2zxEuNz/5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kY+kOdx4myZqC4tdr/4VJFA8LuFBkMKlOLUVutyhsAY=;
 b=TpBjva3ASH8X5Sr/qbV214/UJ7taS06nRazN7D6ldBEQSOv+wN9/CmS4GI5Nn367r3OP6xrv1L6DSfRnf6aqaibjot7zsKWY6z7G9GLjRXb+Vd9E6/V8j/a4MEzmPe+rOwenl6ai/Xvnrl1U2YNkGT4aaJlmzy8/+POm7MontNpJv0QkvPojD6VkBa2Xjf4ob0SGUR0Di1ULAOlXmZdT8KLeAK3s3rI72uhmGVMlEBWMtNAqKUZGlCvoBm9NBliazuF3Q0Q3iCxpKSrMpDVsI2KJxm1IHORe6kzsOR29M9JM6V9j4jclT6tK4N+bmf8TarrcplDcih9zlS3Pdxq42g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kY+kOdx4myZqC4tdr/4VJFA8LuFBkMKlOLUVutyhsAY=;
 b=TLEzvynVdKBgMTT85LRDVMvSuaULWHsEOZNYZuJAq8qcdCqRochir6WZugi1Y8UwRg/Hf7Gh2hsVK11MNTaNh487ZYO57h5ZGr9NEciq6PM0JCXkF9bn/VlOb/XKpWC7HyZBtGQYkr4k1eBPs0Q55ReQr7OSpVbQvSeCqoC8sZw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB6190.namprd10.prod.outlook.com (2603:10b6:930:32::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 17:46:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 17:46:27 +0000
Date: Fri, 2 Jan 2026 17:46:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <99a5ca7c-006a-443f-909b-d6375164412e@lucifer.local>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
 <aVZ6b2ri1iRpM-7y@hyeyoo>
 <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
 <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
 <dd304877-1010-462d-bdf8-9d824250a05c@kernel.org>
 <9306c37f-bc7a-4a7f-931d-452ef6aad358@lucifer.local>
 <aVd-UZQGW4ltH6hY@hyeyoo>
 <75ba8e22-9f00-489b-989a-373d374244f5@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75ba8e22-9f00-489b-989a-373d374244f5@lucifer.local>
X-ClientProxiedBy: LO2P265CA0293.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB6190:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a730de6-ac0b-41d2-d51c-08de4a26dabe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sks4FYe0KxThcJmBjc8ZTuAjsU/3YuAGIzQBfQMyJ4GO8MQ7e2JMp4cz6Jvi?=
 =?us-ascii?Q?Ia9A/TgXg99KvTg4N+a51zXxtMVH389xJ+fX0ubb9CdJJzJSaefZh7cb2skr?=
 =?us-ascii?Q?9988Cd/jPwfD7SQr0HN8/fl8Sh8FPoMh55yflaY2Yt15UQ0ertczkTvxh3g9?=
 =?us-ascii?Q?fWUVS4roj4BCPPSa5BaCxm3A2tqBpUizYZRGqSCD2Frvo4BiRoyItcR5EDaF?=
 =?us-ascii?Q?MG7Nl6voGbwLBSKXVZDKgjD3n/r7J0vUIhNzN7aum4lNiRbC1ykc1UkS+lRE?=
 =?us-ascii?Q?lyWvbpIsNV39nNrLpuLDksRlnZP+SXKV9sh920OG5v6J9UcHlTYhE/iHgfES?=
 =?us-ascii?Q?kFuPuPR99VZ3YJrrmsWowUCHHsdmGk1iUrrZrXfJpr32Ym9ohiLFyuhmOJ6Y?=
 =?us-ascii?Q?CjsnliuJYAWk6dkl2Od8tfFjCaRbfsmvwA82fD/dOwgGHmNLQo4aHQnHYJml?=
 =?us-ascii?Q?e24w6P56IsEDqRlioshb7a6/73dVp+YPFmPKZNeTNg4hjFqqznugivE9S9Z5?=
 =?us-ascii?Q?bjuLqC1nYASA9AfL3ogkNlVue6OqGDjOAls+Wsg4sY9VkchhAQhRXweO04tg?=
 =?us-ascii?Q?+ezElgjuz8N8zRbalzISJRZnp7+f4rSJfM/AkSp2xSchiI3IBtbqAH5UrrAF?=
 =?us-ascii?Q?ON7Q2ZqnPhoGH/syF1oeLLUAiVZn2On1eoOesRs9XdWbqHAcRPwHFxoSMTUE?=
 =?us-ascii?Q?jOCMiOX9BXVX0L3HQKDF2OMySn0eTgmleg3Co+H0BQQT1zY/3yFyqAYSx/Gf?=
 =?us-ascii?Q?UxiM51wXPL1H7Q6m4Lj0BkpmmF692PsRFeB+ycD/ZBpEQHlAqwvlGrvanOCb?=
 =?us-ascii?Q?OOEgy1+CguW/Lfz7QC0fYtCoYA2BmBDuoDR/wgi6cbH8vMfpUrQda1tSbdX9?=
 =?us-ascii?Q?xOvFCuSpf5ro9UQbF7Z7mWTMlyqNmRHZ0XHu41oj+dHEsphjq4+nX4BN7IVh?=
 =?us-ascii?Q?1AbFhgxhzWgxILaiNXwQS4tXN+hDIC4RVx1nVYfpqwLo+/Ct8OPj3d0WaGrF?=
 =?us-ascii?Q?c7OyTrNqJUG95fxRWvMgMwlVN3js1CnYOMuH4uC5e6vVOxfqCbFZ8+e16dsg?=
 =?us-ascii?Q?ZB+9FkwI1OTde5TxIeWWkCBQXZ1l1TwEQ3LVrQy8Em0MqjLi+luBIdpn9Fo5?=
 =?us-ascii?Q?5MTXDM6JkMlYyxS6BMw0XFenKSpQ5140Qi5ZHAUwqn6zQ541CjiHt6qQfeRv?=
 =?us-ascii?Q?6g4g6sD4h81QcDQKfjWbxhF5up+L2Eppxs6/UHJHw9UtE7wrL93nzGTdeMwJ?=
 =?us-ascii?Q?y78TiR6vQdftQ9Lp2NFjucUqox5WzyPY0uLVLENm39UKVq9gjt8B8svcbcxz?=
 =?us-ascii?Q?egpIimacxMoocJdSBGVEP1A1KhJH+dbiiYTJVGPNdYgWXiMnU6GHpN2ucEpA?=
 =?us-ascii?Q?tM6ADQFcGQBvEtsfD8gqN53HJBwQ2n4jdJbmh9z0mRkkk5W3TEbSLxDzu0hX?=
 =?us-ascii?Q?+a6IV4Hx42Xi3EGCQUtJYNvweNBz4Q4S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5neLvlIVrHDQV6UbTMce0R/Q3P8eO79icKQ2M6/P7TAqoCutEUO48UxdnNbD?=
 =?us-ascii?Q?NEL9R/+GNBZfSWCo7mfxCTV1KQOhuOHRgk3JHoYiei/VPCVps7nGS7Lz4pnl?=
 =?us-ascii?Q?Whgy6+p61IzRQadpkGy57cC1ofJ8rLaLzFwFv6f5SDYEUM9/NWLTdohuviHp?=
 =?us-ascii?Q?7NY6vwadS2kZWiFY4lCjeiOrl5tvovjasEIkaC/WWa+tM8IxJ96THWQRW38Y?=
 =?us-ascii?Q?GswZRxzS7idKQQhn7xm25vXBsYAWBcQJDI2n1DM+c4pBKBaBdzJFJEESda9p?=
 =?us-ascii?Q?q3ESNDeOpqvqqTcIw/EBfEpyJ4weFgB/YBTpsmudl7xWBrrZbAAX8R3Ry73T?=
 =?us-ascii?Q?CpRMdSD+PZmsdUA5QMU/s00TWrI4lHC6tpmGToMjBtGkN1d6QvQYi8IlZYyk?=
 =?us-ascii?Q?jA/5yAFsg+kGwjFhn72BNkQG7mP1djN34lsf8MrjBVZPfh1rAKrn340iL4Qn?=
 =?us-ascii?Q?nf4tndHzIurWzz9qQo3j3DqsXbvToddeOz1T4FgRGsObMeKeuzd7mEnwXjJe?=
 =?us-ascii?Q?SrVL0aODj9PXMc8tr+MbM043GlmEx/hbeLz66ovDZceGDqRT+F73K/++FtHF?=
 =?us-ascii?Q?hjrdCDJmL1pnPgBnQZZ2FYLFYEdibtrN9UYytUpmegRq6jR94p1aw7e2e83E?=
 =?us-ascii?Q?cdXSwr4SYYh+4/O+0whuW9gvXjZLjagLa9kqSSTNp+66iiNkMDfdFLHaBGn8?=
 =?us-ascii?Q?XMSu31gfPGHD4O1POGTK09SpJ2rSHWdzfmNYL7Al8ZOF+SjAggxgEtC/uNCE?=
 =?us-ascii?Q?PiGMVjyWNi4v6s4Q3ARH47JyLugWidVB0POI2gYMPWGTUdL6jgVP1G4eIF4y?=
 =?us-ascii?Q?C1QT5LYR62dgvyTtyTd15MYpF5cV/xshN6wH3GSw61F1RxMz5sVfuxiF4G9Q?=
 =?us-ascii?Q?/MIFp2H6Sk8yqu2tMvoVLnDaGlGE3RzXr0VFJJzbgLPsRG7h0D0Jj75vO+Z3?=
 =?us-ascii?Q?JwuEBBw7SIrfl6F9YKQkxfdJWzcx9aNhGBSRyTL8A/IKOMTeTjYS7L4FjJ3y?=
 =?us-ascii?Q?mVW77N+mAPIA6JUvs44SfHrLSFrnjfbaF68HAa7YDsUNxtJP9t0QWRorEx2k?=
 =?us-ascii?Q?+RUqxBfJeJMi+ngCkbLreDGG67V8R+NewLT7Y3KGHakoI8Lo9MX7EHssgV8C?=
 =?us-ascii?Q?G9EGLJbmt9G7AKUWT+QmlJMzLF7T6xa6xfX1YlpVwsvN9QhQinEICR2CmRE4?=
 =?us-ascii?Q?8TznarcAZtF0E/9m2fZ8HXzpil1VZ4d3mQakb0nApA41ej5mo1O2i1VehtPd?=
 =?us-ascii?Q?bmAuhPaf+fsMyJ9WPiDJbrOXhTMpNLQvlpx1QNckixpjvREyg2h/2BUcJJz4?=
 =?us-ascii?Q?5e5IrOZcQh2TZrHtqwJq7OhMR7iLYc+Pe4yqtLBuUjsMnf+etq3hCaHpQPD/?=
 =?us-ascii?Q?os6VYashyWghC8nuIstMDG3E3fXUAuuW7D5xaZ0voCQNgSY5MXwOErsr4PKP?=
 =?us-ascii?Q?vd0bQsi8o4wSkIM0LunW1RiwNDI4bQdgth20miEYYoPxA+OXePFXmNLM9ipr?=
 =?us-ascii?Q?BWrxk3IuzM4Pgg18Q1IsG08itGavQ0bHkYZufqGsgSEuIt+kryMLZHJr59zL?=
 =?us-ascii?Q?yn3ggH3p8wVE4CFT7ynkkLAGqUNqvT65qBgCAF1fSwojy+fWMDzEurpU0TTD?=
 =?us-ascii?Q?RDZbc70GO39BsGgnr9spadZwC+R+Su7E86F5OGM8y+2NIO3KxvaPgnTyUnug?=
 =?us-ascii?Q?ddCma0ttQuhdLlT+VCDQUbdvf3poJHjXD8+E5dVZSrwpLIglbD7q458qbjOa?=
 =?us-ascii?Q?yOEVOWPWJZXRYuUouaMS3xsd0RGi4dE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M2d5uCnie4YBeupPGcO9CpdDDWuP0sS+B+ifOApmsKa/gZHfZauCNKtgG2fF2s7NDlXwYEuYpSpcy48EOlh9n1B4F92c1EB5Sl8f+mxX8btOYfHW9DeQPQp4S/BIaBXa+qgKIf4GJCUWjdtBkieMabmZGG06uHjXmP2ajtsUh4CXS12CXIAfsnDQp+rx3VBP8Jv1W8pFWBDtLk+6lWllG/aX0k2/kr5ZGR47CWQUhut35Cupr8KYMPMZQ5/5ES+ezSbJVWdKMbEuKqrLYOvkfEk7WmIbZPr+AaO3jD1V5SHsK/8u6DrMudHhscXjTCwSiv47wFahn7tHXBOszQC5hyyedcQZ5iSWYSAUQtTByrKlh+n3bYjeD22VSUqP2oPi47zSURDjHWT4vOJzskz3m1wVN9kdjwsLgnaogFAKHPfMcOcqONw8ZLV9XhW/a66dbPaa2WRkYAoMvMKJNA/Um+2myQGiBi3im7V/4gelYXpXkci7RgT7wvLs+3+Hg9mGvnE+HrbGlXDuTkXWFZAwQ0TB7WEf5GRSaioS0kowCIjLkC3+ohSY17BTERzglRwHT1vXqYbUgt+hOYT4fLmqBp84a5HFhU8JWGnnN0J85os=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a730de6-ac0b-41d2-d51c-08de4a26dabe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 17:46:27.3786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdsLguoOXl0UmZGgpYgyQfgBf6thnQSwNoGZ4SCiK8YuRvfhv9+HfouqbRVsMl3ZZdEgXRp5XAswpRR8MtedMiF4wida8ClqVAjJVaPTY3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=891 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601020158
X-Authority-Analysis: v=2.4 cv=LL1rgZW9 c=1 sm=1 tr=0 ts=69580477 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=MY_yOW_JCWjPHViqXNAA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: VK7zBFOobQmmg0289wnFd8_z_-Z9GWRU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE1OSBTYWx0ZWRfX26H1JM6evX44
 enxUQnvZpjhcLsx5p2iqRXheFKJnaRcIENjQbLsp6zbM1FK8lxcAXOtb8Q8RW3QoYdEb802SATF
 gsBAbg4ZA7ydJR5VJYtVdssFzYj6byoeSrZ4rrx14QEW8EO6kGiwPt21373FryrNAL5KM3PvLck
 bog8dMMMzoJa8H5AG6aqFyLHne8ESeSlBBjwPPpZWy8W0eEyov0AdqP5LuSY5LU4TzAj5usNsMR
 4MU39WtxgQJqbzPOkQ9kScnER28VzWH9JfQjHbhS+SaNv3QVw4GD8LXHKIYToZQ030DI/RZkVn3
 ++uUtCzhJh1zUYnNMM9s6iSSGIV2Ce/hFLU2sW5V2a1ZNqaCdOPcAssV2CllIcmIxEpuUXRORIO
 jGPG5NDHnaFUMYdWpeZegowvEwV92qG9DIdu+L/JgtVvT11aEbI4K3crPVXmVpUOD3+MkDyRLQX
 YqTidhCWXr6mTb98O7oqY2jinfkXjGwyQ71vnaZQ=
X-Proofpoint-GUID: VK7zBFOobQmmg0289wnFd8_z_-Z9GWRU
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A757F140004
X-Stat-Signature: ezt51acsqa13tcqaat1o1ydu7965skxw
X-HE-Tag: 1767375997-951196
X-HE-Meta: U2FsdGVkX19u2eOdoKynQ/nX7Pbs41rFyhMFlNkgB6iEC4ppnh1wHjryh66Tdnqnvkj4XXgrYvNcBqTClH/rBGXDI1e/I155qHstIfA5I6vjzCzhIyoE0EHjnW/hq+N3n/4VVAEWt2v4nI4QojSVVbc0O3+130xtDV8Apclz3pLDz6ZVNgzljWTou9zpNt9+cHqXXLkjCcumtpP+6KnFEXNy2Bh4PHFLKH28W7pHwUvlDmXUQ67WyW8W/HaPRi57DEEZPqtK8J6tRqFfube3Pi4OAjJxbeFu4tOc6tuQxqylEld8Odem8ZPpPlsRItvQHvHmEoLkpM5vf5csw987pJ0mLDiflfHdJV8pzbcq8onb2/z8JtV2gE1ivtsAnxLdvP0eCbzPXJnrjlejjyqeHQz0+b213R7CpemNIcYBoEPiJNK2czdZnQTE7i8mXPLatV6xUjC8Np7SWznEKWy9SVID7amtEy0k2mM19iIboofZ5hv3oladTAJZV+6lIsfeCbo/Cm+txbs/NlXhxQgpJKQj38vWcPFeG7TQ6/CBV9FQ3UaDiWBhJtG/ilKEvkg6HXkr8s3cBu0mGAA66F3vYsyEN12Xhtbg5F0BRw6UjWA8ioWj0UUxhGeUloKLPwDOFYke0lrvF7CDCl+9WKoCJcfQzY1RZYoG3X2oSU6uSI6B9ySqEPAN0A/KkaLo4nJ8nQIkzSV3Y3BxprwPynNhaGvM6i8A4KSnkgXuG02v92HEnfQT09Zel2fM5S4bT4WDPCba2ckvpDtaSbrOk5zBBsNig6J5spG+2GdN0+Jl76YPKQUmYx78xFvWqXW6e+WtdaIfb3aqK2ktTAox0P1wg9YSXVDrr12H0gMDxYIc00MEX8ROR4yVv9AtolESuTV5DXOsc8l1dTRLcOGTOFuLFkh99JlKkgzLOV9bYRGVmiBgVIBtFl258DXuRAc8LrbdupsqwB+KiBGaumWo807
 OvF9U/V6
 oxPOwjbyRj+icSrNwNGL7apcg1yND5nEXb+JA/AK7CEKsxi6/n+KwcmIJriHliatHjfMh8jCmUp5lkwgXAMS9sNzDxbI6i3KMPymuF+ta3hnlaASHpyKohAD/P3escRxq+GoFVJtFua3ow4kU+HMtll69FIQvhgkpeUeQfFmyMGVdCagYl1Mi16OC/+wr3VY2sp81lml52nsHOEd0G2X2uUoFc8RSDqDOJZsw4xWtj2jG6bAtyhaFEYdwc+kZ4buxRWZWpqVKFs1vdGOEkv4pjOCkdCkvrdA0WF27K/00J1WKlEp7BVqS33Nyf2ef6U0nzj96nJJn/a7d3GA/G80WLA4b6X6zn4oDbuV9ZW20TniN/67FWkmjUtoNgDQ2DwPyFhUy3gXFUPV4xMf9ppceiU+ETbzig1aEqpmWulCbKjjQalZ6W7NXmr+RXZcq1KX9DIhBGDStQMQ37PXv1VDj/kJ2LMq8zu5sWLEdRDTRpITJBjoeM26aW21JMkx5Ugo5o73NcNcgt4zOHkTXynJSSWAq5sWQIQFHY6GdwMuaj4Yc/66m72UQ/V+51Oh3HOzKcn8F1UuA3G0f8cfV2a7tx56EXDt/2FxHhcJRwGigWVKe+qw2Q5iHufPLloctGq6KMWOI1ydPIbtEEyUlIixLKBkQ2fbfklW5tZzt6eE6Gr9bJWSriVOUPxJXYDSNeVeQmWsOMW5/pKWv6i+vyY72OOwEdt8Jn47/vOU7GoZ4/jEoxi8FgEA6DY5fKeRmZwd/IfWSaxX8esytnpHc+c5BQCfQX2sloYE0zVaD3fcH/8YC4pKf2/ikDzk1PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK I now have a sane repro. It doesn't require a race, not even MAP_PRIVATE
file-backed VMAs, it just requires the problematic merge to occur.

This triggers both for KASAN (doesn't even need iteration) and with sufficient
iterations (to avoid re-use of anon_vma I guess?) triggers Jann's assert.

If you're using a >=6.17 kernel in your host I recommend you don't run this
locally but rather in a VM :P

Requires CONFIG_DEBUG_VM or CONFIG_KASAN to be visible.

Will follow up with proper patch. Not sure a test makes sense as we can't really
assert anything sane here, will perhaps include in commit message instead.

Cheers, Lorenzo


#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

#define RESERVED_PGS	(100)
#define VMA_A_PGS	(10)
#define VMA_B_PGS	(10)
#define NUM_ITERS	(1000)

static void trigger_bug(void)
{
	unsigned long page_size = sysconf(_SC_PAGE_SIZE);
	char *reserved, *ptr_a, *ptr_b;

	/*
	 * The goal here is to achieve:
	 *
	 * mremap() with MREMAP_DONTUNMAP such that A and B merge:
	 *
	 *      |-------------------------|
	 *      |                         |
	 *      |    |-----------|   |---------|
	 *      v    | unfaulted |   | faulted |
	 *           |-----------|   |---------|
	 *                 B              A
	 *
	 * Then unmap VMA A to trigger the bug.
	 */

	/* Reserve a region of memory to operate in. */
	reserved = mmap(NULL, RESERVED_PGS * page_size, PROT_NONE,
			MAP_PRIVATE | MAP_ANON, -1, 0);
	if (reserved == MAP_FAILED) {
		perror("mmap reserved");
		exit(EXIT_FAILURE);
	}

	/* Map VMA A into place. */
	ptr_a = mmap(&reserved[page_size], VMA_A_PGS * page_size,
		     PROT_READ | PROT_WRITE,
		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
	if (ptr_a == MAP_FAILED) {
		perror("mmap VMA A");
		exit(EXIT_FAILURE);
	}
	/* Fault it in. */
	ptr_a[0] = 'x';

	/*
	 * Now move it out of the way so we can place VMA B in position,
	 * unfaulted.
	 */
	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
		       MREMAP_FIXED | MREMAP_MAYMOVE, &reserved[50 * page_size]);
	if (ptr_a == MAP_FAILED) {
		perror("mremap VMA A out of the way");
		exit(EXIT_FAILURE);
	}

	/* Map VMA B into place. */
	ptr_b = mmap(&reserved[page_size + VMA_A_PGS * page_size], VMA_B_PGS * page_size,
		     PROT_READ | PROT_WRITE,
		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
	if (ptr_b == MAP_FAILED) {
		perror("mmap VMA B");
		exit(EXIT_FAILURE);
	}

	/* Now move VMA A into position with MREMAP_DONTUNMAP to trigger the bug. */
	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
		       &reserved[page_size]);
	if (ptr_a == MAP_FAILED) {
		perror("mremap VMA A with MREMAP_DONTUNMAP");
		exit(EXIT_FAILURE);
	}

	/* Finally, unmap VMA A which should trigger the bug. */
	munmap(ptr_a, VMA_A_PGS * page_size);

	/* Cleanup in case bug didn't trigger sufficiently visibly... */
	munmap(reserved, RESERVED_PGS * page_size);
}

int main(void)
{
	int i;

	for (i = 0; i < NUM_ITERS; i++)
		trigger_bug();

	return EXIT_SUCCESS;
}

