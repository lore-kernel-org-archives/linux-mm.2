Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2412CCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59CF96B0008; Mon, 17 Nov 2025 14:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E7E6B000C; Mon, 17 Nov 2025 14:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6756B0022; Mon, 17 Nov 2025 14:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 216A86B0008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:58:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A173160290
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:57:59 +0000 (UTC)
X-FDA: 84121159878.24.9C0BD7D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3731B14000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:57:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lmBRCOUA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SLh6ysTl;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763409476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cJGcUGw4zStIgv+w6ZS1VL8b75U0T/Q3thmQcb2+kY=;
	b=TdrdUokpqZmpJZI15Tro+3jDMtv9KeyXsa2RyS76DuCepaOYzgdOJg3dZYcxDXxW2uH2w+
	s0MGhW6TtezoSzPBirql/KRHbIx2STZXsMfocyS07hSaTiktm9x4fe5vILkZxnl59DH1k/
	x13zHvrxEhYmVSTPFrIqY3ogZ+bbn74=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763409476; a=rsa-sha256;
	cv=pass;
	b=2w746qwWFm4zd2WEssW34UzYzDR6OvR+VJcGI+mqOtyfMTcZgfvWo0MhB3O1zHE6jhuj7Q
	rrPuRYOvU8u9npILjwgsia+o6PKlL0rAwzFDoo9zTx/WD9Uyj4JKp3zr86/r+A1XnEqmxR
	CoTCHuuTt2jkw1+HFuMa9n+K4/ALZhA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lmBRCOUA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SLh6ysTl;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHJamIq014549;
	Mon, 17 Nov 2025 19:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5cJGcUGw4zStIgv+w6ZS1VL8b75U0T/Q3thmQcb2+kY=; b=
	lmBRCOUAsdZ1x/Ia3H5H9KswYoUeICneoGKa5Kst+NVlJWei3kUrPUORqBpElx8e
	AzInBMjXhGfmAJyra81xt7MlrfwUM4MpNciLNzCRdh+M2bbEwGqXoL8+WT7IwOEL
	q+P5MA11uDs1AxFasf5618HithWyamSz/9SmAxieTxUzHL4k/Mm5vAQcjhx27X02
	/NlzfFo/nlqL6caZZwstlX2EzDsZOqIoKu6HWvENYCXTyUOYM0CujN9tSDkVwool
	nXhcu+yQXAUcZX9wAb3l3aCvJQxDwcnz4zqn2WeKwtTlWmtcnj6fTe9A8y6kHPBY
	4wughNJ21YUrErSuh5mayA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j3a0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 19:57:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHItd1x040040;
	Mon, 17 Nov 2025 19:57:37 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011021.outbound.protection.outlook.com [40.107.208.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyjep0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 19:57:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NVTRDwy8hg4s0FG7JNowRUg5160UmeL4/flQf+67OWtV99BlAcDvQ4qRQ7pKoDZT/k3QAYAnB9xeSZrFi9i2CE66pU/4sex/KzGhfamJVoQgJ4oMOotvO4Nu5vAnA1ACijTWL795IY9xSLleOH/QRQQkQ+Tu58myILr/JMK06YmEILATC1pxlRezuCigF3/o0RRJHlXQZrtvRz8EkldNINptN38DdBhK3rdE1SxEOTIHbu5Cr+wWqRnnMoyMYzsN9OuUIVlD4q7OJGm73qrs9ZfgOM0w0gpYdQMixQ68pic8IeD32H0/HgWBTG9ZmFemCmAo72CkTFQE2QvqpE++Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5cJGcUGw4zStIgv+w6ZS1VL8b75U0T/Q3thmQcb2+kY=;
 b=fthKU+xb9vTnG2QeVyAbrOGCwUebph+1n+xpta+BObm6uvjJmUnlmXI15grH23JLdI2thHDbErV4vyMV+5+3Qol702JuXUoeAU9GDdT3P8OZF6VRemzh3B2orgEO9mlQNFIe9d/QTE68hGfdVxtBf49pxCNJjt8fEax25Q+xXG5prt5vIR9yV0lSs4kNzcBHK8FyUh7cSTvF2AzryeZFekQfNjmB4Of6UYOdlMPjiRCjHav0j6W4YpkNUZ1513I+v0NQOkziLGFYh9pNHIdmHmPepMBPzAASvl8weHZgIvuz2ubhEXOgrQYBbptm30gHtIfPdkJ7XXKvs51CD4DBpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cJGcUGw4zStIgv+w6ZS1VL8b75U0T/Q3thmQcb2+kY=;
 b=SLh6ysTlZJCkExSz+ldQ2jmGB6zsLOSR6Q/1p5I/rAXMwcFwC9rWNhaymiSe/rPBYFm7tikwv07m/6nSsuuQ0CKIeSj2w8lw8ln+Oz8h3vSSvPE9COR4ukiZJ7FVxwUi8vzELfQ0Gfc1vx0l+HInQci5SNsYteDNL6aZDc7RNUk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4628.namprd10.prod.outlook.com (2603:10b6:303:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Mon, 17 Nov
 2025 19:57:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:57:32 +0000
Date: Mon, 17 Nov 2025 19:57:30 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, criu@lists.linux.dev,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
Message-ID: <f00a062a-8941-4cdb-975e-c13aad860168@lucifer.local>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com>
 <1c20ec44-0775-47e0-aabb-e1cf1f38ce94@lucifer.local>
 <CANaxB-zPuxtbpt7wcjDE1X5nv4yWp=JTq_MqWSfDce2gx-WKiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANaxB-zPuxtbpt7wcjDE1X5nv4yWp=JTq_MqWSfDce2gx-WKiA@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0230.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4628:EE_
X-MS-Office365-Filtering-Correlation-Id: 61c98799-2d3a-4d39-3a93-08de26138bfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1A4b3Fkb2ZJSFJBNFpkbmg3L2YvK0NwZEpJaUtwM1NiRTF5dXFGcVNIUDRF?=
 =?utf-8?B?R24yVzN5U01YSHJ1MkJsQitwYnMvZi9kaFlweFdISkJkL09EajlZcWI1TzVx?=
 =?utf-8?B?WDlvWTVoWndsVUFqRW9tMVFIWFBzVjU2Y3NHTmJOYk11NjI1dzlSTWJhNGdO?=
 =?utf-8?B?OWJVcTZXTUZ2bzJ5WEdUOGJXOUh6RmhPS3VsWlUybTFWV0xmTGhYRDRYaVV0?=
 =?utf-8?B?SktlRnFlNGI4QVF1akRFN25FbGsvZ2pLdEFZWTVyVGNTSnF4U2JweUdsNUFF?=
 =?utf-8?B?V3ZBQzlyNWU1dU1Wci9XUnErU1RpYjBFL0ViQ3FhcE05R2dVaDI4K0VWLzJG?=
 =?utf-8?B?c2diYmVYb3lOVXZ0MlMzTS9IZ0kwZ0dCdUU1OFVwWmZHNUQ0RjRuS2xoYzJz?=
 =?utf-8?B?YXFKQXhoVGEwcHFEODZZUU53TDJkanF1ajI3dVNNTStLK3p5UjlNZlZ5ZFBI?=
 =?utf-8?B?SXRQd0tMR1NaOUhKUVQ0YVRkdnpiUDQrZk5oL3FXS0hHNGtHOVdjTVdQRFRk?=
 =?utf-8?B?ajZnOTF3NTdsL3ZmekN0NUl0MkY4YTdnaGhyTW9NamJLalo5bHVBTVJPZ0JW?=
 =?utf-8?B?MDV1R1hONkFmY3RnUDkrbmZDV1R5T1lGWmU2bm5FOFFSZFR3ekVOSitCRjNn?=
 =?utf-8?B?amlybDQ0OU8yUkFkNitFQjFTOENuWmc0QlBqdDFoVlpHVzErQUcvQkVoUkZE?=
 =?utf-8?B?TlA5VTZJbWYxbnBmUUtOaXRCakhDSmtGZGpzZGlTZGRpQ3JoODVHN1dZK2Jy?=
 =?utf-8?B?YXQ4U2w3cjJ6dnRmR2ZrR0xhdVoyYUxDSHJ4SkxRWitybzhjOENxQUJUek54?=
 =?utf-8?B?VVVRWkhBL25jaHFFWnU0dHVjNDd4TW4xdmJWTWxJblpsQ1ovL3RhUWtGcnly?=
 =?utf-8?B?UzJoeVMxSDd0NHdBZXRqNkR6V2xDSFRIQThXSTZsSzEvVHpwWVV5TmZzZjFK?=
 =?utf-8?B?dmlscm1VYTVTYkk2ZDE2aGtXbmxhRWpwRklrL3o2SFM2bnNPR1VqN1lPY0N5?=
 =?utf-8?B?N1lpejF0ZEJLUVNuNXhYTjh2L2ZPdGZuS04rMXVKNEM1dDJDdGxnajIxeVU5?=
 =?utf-8?B?Uk9Vc0ZoYUY1ajRYejFIVGErbDR1TlkrM2R4K1pONE13UUdWSHk5YlJveDZO?=
 =?utf-8?B?d2JFZWU4VDk4ZVVDbTBKSS83OFYzTVF6TDU4THV0ZjArMmllbTIzMXVYaUtY?=
 =?utf-8?B?WUsyb1Zpd2NtOEpocGFnUW1Eay9ma1pmbU96Y1Y4VnJ5NjEvSSsyOVZHbHRV?=
 =?utf-8?B?Y0I1cTlTWGowaXR0UGxwVUx6bHQ4OG5obW8rb01yMVRZTnVGK2RMUWFTSVVz?=
 =?utf-8?B?ZjBkbGc5TWxnL2dLS1ErSkJHN3pZcVpKT0FpdDlsWEdJRGpZM1hkK092Y21o?=
 =?utf-8?B?WmJycElSL2dud2lFVUtpMGp4dDN6bE1xbTZiU3k4eVo1VlkrL1dGbUJVd3RW?=
 =?utf-8?B?dHgxMXpjb1M1N0ZjUW1HSmJHeS9HOE45TXEzNW9RNjBSTHlvRnptM0lOZnph?=
 =?utf-8?B?cU5pUUdJN0ZrVjFGWXFpcWpnMWdsN0tUNkxMR2I4YkEyaVE4ZDl4K05OVHJn?=
 =?utf-8?B?ck9wSTUzcFB2QlBzeVpMKzk0VlBmUy90K1c0QnZZbUZDQ2hCZDlBcHZuWnRz?=
 =?utf-8?B?ZndraHZRSXgzSzBpeHlpYVlnYnZEZDd4N2Q4cHVKT2RGVGN6TEFQczVsMmYx?=
 =?utf-8?B?NGY4MS85aDZPWHYwOHpvakhzMnlmb0tpNkRRT2NmVStGVDFoY2VpOTZLRUF6?=
 =?utf-8?B?eEd5d2RJNVUvclBiSG9aaFcwelBEYXhwNGt3bVpsMXE2ZndzWS95VlZ0Ykox?=
 =?utf-8?B?K2hLNFIxYlNZUHVmMnBRV3JQdy80S0NrZ2VhTTlsbnlsYVRnNUFKcHRSc0JX?=
 =?utf-8?B?dDRiWU1Ed2FKQ2FVcTRuS2diLzlrbWFsRUtpR01wLzFBU2tzK1RDeENCNXBM?=
 =?utf-8?Q?fcZbDhD9PXYRXWvJ3Z+H8rkjODbkzoCY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1AvUFpWZFE4ZjV4UThMUDhHS2ZuWHJpWGl0YzNST3B2WjgyQzRoTnNlY2dt?=
 =?utf-8?B?L1pnQVNmdlM3cWRWRnZza2hqbVRXSVhQK0pBUlY1WXV4elJBRWVDa2ZEV3VI?=
 =?utf-8?B?VG5IOEw5ckJObGtFNWdGSjRaMjUvbkpYU3Ntc3FSZjRiRFNJWkIxaThzZlZ0?=
 =?utf-8?B?bTJGSnYzMjNCcjVTVHgrWFMxT0VQbEx4TjRLWXJDZDRvWUNORWxDVWczY1Zt?=
 =?utf-8?B?QWV5OGpZY1B0cVZCaGVxSWQ0WEUxSi9WN2plS2VXbmRKbmExUTRRRjBaSjFG?=
 =?utf-8?B?Z2cxRHY1bU1hMW5GY1ZnUjZkcVgyUlZJTTV6RjVNWVpxRGFaZzlxS0thdG56?=
 =?utf-8?B?Z1JvK3RtdkNhSHk1TUFWcUpYVEFXUTFJUkFSUkg1ZmNpRkJMU05rTHZEblpp?=
 =?utf-8?B?bk9RdkdVM3NmejNKK0tjUStGTTRYanZrQUx2cFZXWHQvUlBra3RYaUlYYXpO?=
 =?utf-8?B?T3dpamwwaitDakY3YVBGeHpiV2FVRHdEMWhRY1RwR0w5ait2QXQ0ZHBITkZs?=
 =?utf-8?B?REoycUlCMGp1WXhqZEpwVjNITDN4MEFxWElLaFZIeWdtYmpkMjUwdWswVkND?=
 =?utf-8?B?OWJWczBmaXlJQ1dBNXZYK1FmN1lSRG81N21jam1xdlRRYTF6dFluUHlCK0hk?=
 =?utf-8?B?VmM4dVpQRDExaFJPNFN5aXpMQWc1QmZlZ1Z5TjVvUkVLVWlHSFd4VXRKMU1k?=
 =?utf-8?B?QnNXdXVtRzl3WDNJRjBHRlFHM2R0R3JJdm5zcFl3aHdPT3ozWXNLaW0yQ1hD?=
 =?utf-8?B?Y1BEUG5aNm93ZEZyc1VJMXI5Vnp3S2JiT0pZaEREbmFCWDJjb2pYWkErV2Iv?=
 =?utf-8?B?TjJBMWtCSTNFU3R0WEg1ZnMwUnMvQnRnTFZia1Y0U1B5b2YweFRGeENBNG53?=
 =?utf-8?B?bWdKbVBJTHpOdVlLTmYxUitQdUxkMlRNUkU1OGxPUTVMbzJmbFJQVTg3SGxP?=
 =?utf-8?B?bndvWUluMFF2NFdKV3dScTZtZTJnVHpxek9ZOGVSQXYxZEFLU0ZERlcrZnVW?=
 =?utf-8?B?YUdvSHFEQ2ZkNmd0MUhLRy9lMTdOYUxUaGFFWWZGSDR6clpqcVM3Tld3Uy9Q?=
 =?utf-8?B?RmcrNWtBWk5nTFFDcDRZSEJSMWZvZEg2dGNoZFZVZm9hMFdvOGN2VERCNHN5?=
 =?utf-8?B?VkQzb0JXMy92T3hhT0tMV1VnZ1Z6NWpINGkvSW9WeWxWQUZNNzBXTGJRVHZO?=
 =?utf-8?B?Y3gyaFI4RWU4K2U1RVVUOGFzelJXS0xMNEpuTFpJdWtmSUttOEZpeHlDZ1lB?=
 =?utf-8?B?c0V2U1BaQlJyKzMwWEtXdHJDRzIva3pCVkFPQ3EzNFMvYklqWjMyZUJFT3Y0?=
 =?utf-8?B?cTIxVERaL2dCNGN0V05ZTVdBeFJLNHZQdDhoemNYN3JUbld0cWFMSWg1M2hR?=
 =?utf-8?B?UkNBeEhxeUtCUVpPRFc3ZSttektpNnNtcUFtN1BJaHRNckU5WnI2MGxSNWZP?=
 =?utf-8?B?VXR1bUtqdGJjbUlJWmNuZDQxVGQ3OHBSRXZmbzRpQU5kaFhmdGxneFJTbkdN?=
 =?utf-8?B?N0d6Y0FnZkRzR0FRQm8xUzRIZmVIT2JpUGFCUUtrZllCN3RTSlhtNjloTVhr?=
 =?utf-8?B?eWpaSi9jeHo4d2tPRit0ODBVaEltWkU2NTl3d0cxenFiYjZ1eDk3NWxLZU9L?=
 =?utf-8?B?eEJ1VDV3Um5hWFBGMEhPQTJ1c3RZK1pqQ2J6WGRCN2hEblhTTnAwSVZHQjVr?=
 =?utf-8?B?ei93RytobXRoY05sS3R6enRteTJpWU4rQ3hya0NpLzdEYThPU2tVR3ZhSGYw?=
 =?utf-8?B?SEp1NGJzUkVjYW52QzVvN3l3dmc1bWRuYnkyamJwbUxJdjBBYkhuN2dZa015?=
 =?utf-8?B?a082ZFVhd0RtVDJUMzM1eTFWOXdtLzQ2aCtNV1kwL092S0FRd0RkdnRxWEJW?=
 =?utf-8?B?L1Z0M1gxRlZrYXh6RER6VlZzdEUvZVJyMTlqYXhuWWxyWXZ2Tktib2lZRm1s?=
 =?utf-8?B?Z0hnZURGdm9qMWJJelU2TThveTlwSkhhRWxsVkVBWUJjeVBuemFOTUU4L1RY?=
 =?utf-8?B?ZWQzbXZuQlY4QkxpeE9mQjBoUGZlYnAra3pPMEdqcWQvVTZ6R3JKbGdMQ2Fq?=
 =?utf-8?B?cTFtN1pnYTdMclFmV3pDcVFDUjdHb21kUm41Y1lYZ0x6eVo1VlY3OWFFSXBy?=
 =?utf-8?B?UGgyWjhtMVJTKzlRRUdYR1I2SXQ1YXliV3g5cUZ5cjZIdW1rZ0UyQXBlYytv?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RHaT6f2bnY2bZeTcqhcay9FGl+KXZ6kfuqqHcLmQWBytItDxR+cgLZbeNNOubSZ9x0tH1Q/jkGEs0wf/ZSpYVliR6Il7Ld89wBnKS7cMFgllMuofT2b7E8HNuRMQC8YHHOTpxp5D8n1vUETzdoTDxQiP6MLMXoDBDxjkyVxsbyv8JZuVFcDfqxHRslFbv3xb+mLiYHuBeetsE/A2DE/yMqYDy16cglh7ItGLt7l1LUgEhgC1i8rfu0IOgrv+BkxngS4xDQ+0jWudXL77TvCCI6BpCzS9pzOpW8erIbrWMKENChWJKVt0dTE1g6v6YuULtcQuslkyQWLmpruGEtB5GuyhvX5D3QFDfhkeH6icxqVnvTHKvFC7YUOB4L8fovBFaWGq6ePewgxFTm1hAFa6oEycJ7phId0Vf20vZsOmH+1v6WHamfP6oY76BH8Tgz7y4xhR/RhjVBntrEyGxBrIb2dxnhG5MK2DXb1lSfGzwEUGzagQ5LmZ3xPACLMPXnLHu7iVVed9CInRVzLlitJhYwqyhdLsrfCCX7AaXV5CPDtyYY+4DCW/c1xOXh9BixQlvDQCzBKKVDA71smQl2bSzhgUAOJasn+U+pY+MzEvoOc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c98799-2d3a-4d39-3a93-08de26138bfe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:57:32.8808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8irm9Vkwab9WkCnrvrUvqyuigoRaiWJr8IzC8lxni2H+0RWWDW6ml2Q5rzTmw4gTGaa77FQ4/f05b4gzbPs+kvymToSzhQfIf1Dvpiy4nnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4628
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=730 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511170169
X-Proofpoint-ORIG-GUID: 0D9Y-X9rIcfop_0iIvJocey0Zg6dIKYk
X-Proofpoint-GUID: 0D9Y-X9rIcfop_0iIvJocey0Zg6dIKYk
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691b7e32 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=ffw2vSSFC8ixZ3IVRaMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXyPY8lEoEhOB0
 MLSFiUZ8agAQSReLAGbxmFFZntRRvx0wWEsXkxcwkFifcFT7vagDH5w5oz/y8krU/Rg1HZQXbmi
 OzN1cjwyoJ85oNBgXXzQEMtE6T8kQficcUy5FcX8ei2MvBtZnb7AS8xy/WwHSeLJDpHvJVyalRW
 i/sc/Jfo7hYC6qyVrLSJjRMZCMMYQySRW7VjKw5/fU42zfz+Mt1gcrLo1M+vQ9NpBVvseA8rosD
 8Wxa+FHS5342DaT6eB35zscB5zrpTITY3+oTbMYD42iblebpk7zc4QMITlGw2/g6VlSlj23MVQH
 aKaohzkFMe2z+57RwQGux7DZ2jYjEU66EUy2hCFIUe97nKBqnhc1qVPaZ+l3Xr30g2x5NXOi/CM
 EMRK+qpyb5y3CxxUZkCpKm+bukKd5/MNJ1+bm/usYSpYmkW+R1A=
X-Stat-Signature: rx7q59fncwb6opxjsuprainkxnsw18hs
X-Rspam-User: 
X-Rspamd-Queue-Id: 3731B14000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763409476-853249
X-HE-Meta: U2FsdGVkX1/Pid8R8IqyELY85Cv2nkWMqb1pNVIm4JdJoDwaZJOX2rl76ns3BMqwdC3/38KxIsRTskaMAyEKezFYAXDyCGIM9V2QE+kxCyOeGQGDE8n3FZ6Sd2Zzefp1B7vDDhcUEQkOVOilQBFnAYyA8BzkFuZ17qIxPUf+4wo/Pvn7WvjcHHB4DEWffwIDOoARVXsJqOwaovRfeq7pyI/vfTOyDrZv3j5K+7HSEJroi9uBWgaxvEmxU9qUOscLWRRTL1X+76Td4FMsay8svwU5ChjDZVwEyg2UzlqhKo+ttQXdCDtuFeUozFXSSG5YknXMECtUcST2MaLNBxCKfMVbpngjiBObWwrj5WhuL72e1BtTcBuY9dfT5GNdfZNooMN5YHc26GS8YSQJNTXQcBBnXKoP/vLLCuJ8MYyiLi7T5O4sfk7A4HCQ/gYzWpAqgJRe5TCLhumfxIG7jacqB/p/o3mFvHvoUvo3ojrVw0PrWIblsRlr1b/w8YsCFwF7nUFZHRo/jKBEOiJIJFr83ZnzdNbqRIt2X6SMRqWUJsucEUt8T/Z2gyezctj1uhWoH91m9oYE0dJ1j2Sv2p4NeIqwXPVKEHGPZt8HkRqlWb3lUeWoB/Jh7blvxtVWl0D3XAjfnj08T4IkIsvpoDbSvOtLAVxWiqTXsKm90e/i5cr7kX7xsjODBcxsP1Z5KSlEVG515ewpZbrsGgkMvueZSMZUiH7c/1S0Q624+cb62faX3px6W3Ho5G8AdH4jBIkwDksExy0y8IIwh08ztWuf6hq0lI43jCGR6MmbNGdI8hxWKxnZzIdJdvqcYnJ963ih2P/iY3ZKBn/2tKTTBxFy0j2XE+3IsTqRiySP8AZczbUEDnKyT0dSyHcEsBcwv+POQl5UC9LObojWEn58ASzFntMo9cUqAW+OXE1j80Qi4dSsz6SBc9LbUWGkidWpxUvJgqXtLqLVE6AVGFcvmbg
 FzB2V/Yf
 la28xYXSXrlG/BDhwRerADp7Mvvlmm12C2iPHSCEVn3pnEPUSTDzT3RSLjRFRPZSzxMkgXCp1vlqrjlRr0xf/stdRHOQWm6FcfkWVS4H6wW7SFuP6ThXSe7DAkWqEFBpw05cKMswAzwbSbumwxu4w9ocTZ22l7emVAWJ2KhoARQ7xo0crHInEQ36Y+snJJ5oNv+IPVKfQIApaP0AySCoW8JwzTA0vIIsCn3hd2cfTNhm8+SHwYu0yC9j+zdVEXBVn6pgnmAWeMRgYL18U+tcYuTDtTsElB1lVIbdta/X+PlG5Fk0X9Ejhvh8wqXllRYA3IpSHvLi3jZwJMK2y9KF7r4a6CTfvtzSt1i3KGtVskddEPFkuGMRKP4fnOjlzbXLRlweHgsVJgRVU24HKoP/aMjqhewUstE5DGBvO3xQLeNXiVjcIwMFsqwKimHvP14QwpfWwe6rYkSJgS5jJL/T1muZUT/USh82vV7rhiq5Gp1w4UQF6BSh5tMB/WqTtM6dW8/TsUZYERtEL+uMf7DWvzDqFmKDsqvTOwpqU51Yerz8zSeiESxnxMYmDdG2A1vA1tOZMeRuTTCBpz/MXVWAldvqd1Z02HsPeJn/JRPUuyPScA5wmyHpaK4o1w8gmzDlRzI8UDH3f+ZEgLi4D3GMF5hadyZu76i/z1otoVbLYkL/ARccL2Q/uCiv3pYAXMfvf8pUNQMBLmuLm1mDG8MJ15F5fIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:26:34AM -0800, Andrei Vagin wrote:
> On Mon, Nov 17, 2025 at 3:33 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Sun, Nov 16, 2025 at 04:53:36PM -0800, Andrei Vagin wrote:
> > > On Fri, Nov 14, 2025 at 9:59 AM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > > >
> > > > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> > > > establishing a new VMA, or via merge) as implemented in __mmap_complete()
> > > > and do_brk_flags().
> > > >
> > > > However, when performing a merge of existing mappings such as when
> > > > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> > >
> > > Losing VM_SOFTDIRTY is definitely a bug, thank you for fixing it.
> > >
> > > A separate concern is whether merging two VMAs should be permitted when
> > > one has the VM_SOFTDIRTY flag set and another does not. I think the
> > > merging operation should be disallowed.The  issue is that
> >
> >
> > This patch doesn't change anything in terms of merging, it only _correctly_
> > marks VMAs as soft-dirty where certain, very specific, circumstances might
> > result in a merged VMA being incorrectly indicated to not be soft-dirty
> > when it in fact contains pages which are.
>
> As I mentioned in the previous message, this patch is correct, and I
> appreciate your effort to solve this issue. My comment was about whether
> we should allow merging VMAs if one has VM_SOFTDIRTY and the other does
> not. You are right, this is a separate question unrelated to this patch.

Thanks :)

>
> I recall correctly that initially, merging vma-s with different
> VM_SORTDIRTY bit values was not allowed. It was a bit surprising that
> this behavior was changed by Cyrill in 34228d473efe.  Cyrill was an
> active CRIU contributor at the time, so we can't even blame anyone for
> breaking CRIU :).

Well I think Cyrill is in the right here :) the problem described there -
that of hitting the max_map_count simply due to failed VM_SOFTDIRTY merges
- is very serious and clearly highlights the issue that arises from not
merging these - that is VMA fragmentation.

>
> Thanks,
> Andrei

Cheers, Lorenzo

