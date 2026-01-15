Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A94D4660D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0B06B009E; Thu, 15 Jan 2026 13:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5EBB6B00A0; Thu, 15 Jan 2026 13:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95FA6B00A2; Thu, 15 Jan 2026 13:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3B76B009E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:28:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A39616045C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:28:00 +0000 (UTC)
X-FDA: 84335032320.02.A6A520F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA1134000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OB00Djdf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AQP61rOb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3CqWyD9TKVVKxP/V/+dlFHfqqQO+hsB0l/wolyEkX68=;
	b=b6Sm9WjiQiuS4bhZbDh3GuLdxnX2xooBl110VjF8hbLagAafWTZbCdhgSNllb1oywix5KH
	Oy/mAheVO8Sldy/sGhF5tZc4BSN09P77kK7mBdxbyzB6BD0oh+1BxTMpdC1GSXLYX/KYkZ
	xUVLMANaLwf+ZpfIHiW5G4mZAsrd59M=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OB00Djdf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AQP61rOb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501677; a=rsa-sha256;
	cv=pass;
	b=NuaZjxfUTXSIknlKOGZLXupg8YiIT7T8dvoqCvPgzqP/8pV2enrT790MLhpJ2qiihWG7CP
	iS2k3RTLhNCU3jyRkR21BeCCR6rtkXzroDskENNcd6xY031GhhDfdH7tfvhEQLb//OsYVF
	W992Gb7GyhFg4FE57WfcedPmQmY9Itw=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FFq8ub2395990;
	Thu, 15 Jan 2026 18:27:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3CqWyD9TKVVKxP/V/+dlFHfqqQO+hsB0l/wolyEkX68=; b=
	OB00DjdfGi0kgi9ZucJd+1FV+tJlv0X/LxVwUuqVZi20R0sWUpdfNYNBtchc5b0N
	eoLGaXnJXX5qGUdu0WM2fCmEusP/yhuywlXE9vGfN9tpm8gs8HZhT1l0HkSTARjd
	qRaWRa8TK7WgDeRMFtc9qnZXcyhLm2AkjCkwq6OnJX5yt4gx3Ckhrci5N/trTR04
	H/79O3oVH1b3y1fQiMwyWR4oJgvtegAS5SpeLDUudjR4JVHEw0NWTTgshaOSbQDE
	plmdRejhzh9pJ2NxfZHg3XFGjFTq/gL8NHc3Ge6IUJ5c/2NvOIj/FDfvZPamTKm8
	uuipciBZB/pj1i0RvysTHw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq58cwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FHUmjb029120;
	Thu, 15 Jan 2026 18:27:43 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ndyj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NXczCpZ9+pGOxfRvzh8WZL2DzISl+pCfXLmfdO34jzJ5/UysD/o9bui1g3iga4HcMCmhahgBmpL8s9WX81Tsncch7Ty9GKxjumZnUYP+VwhGjPzCRVCdsmoiaxneP4NtLw2ObOYmSopU5YQaMoSKK8RSJ22SnSKwM1nDA9XW8ZQ4SP3A0jLNq0wa7xdzaNaDNdI8k3sdB0SHhKtvvdIVw+jgglDOewMSKOf0RpxVoVzDMJOMqgvl3nu0KLlPWGOYmAzKliiH82BIPHGW2+QX2PuMcL54BhKXcKFXzUnJcz6ZFq808sp6pWKv5MCK0ooXIdFTxTiJKNYm2iWQp+HzVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CqWyD9TKVVKxP/V/+dlFHfqqQO+hsB0l/wolyEkX68=;
 b=SOimfI4K9XkJ2QHNUEEKOvSoZbpjKKVlr5z+3YQASZ8ttSE9AfQLWwv3p/c2OEk562PJ7hAGbhD/a5FE6YCEwSSF7TTYgWQ7pZgDsdHdti9DFeoOjHMbUm1AgFZxn3WBqHv+GBBALb+nXXy3AHJugHLweNfaSw4PrTU6J8CKtP6ZX5tELlLqo87xGPp5dNjuLnF9a4oyl/aV8sE8bR0FdCPEVgWrMnVS0ir92XUUinK2pZyeDg4j+BXHHGmHAQ0AWGjiF5mPUrwnKOS3yINvFqqZ3IIIz5qzF24wPvqjfOHChpIthFw+dnKXNkNo6TH9YgQ4EYuXhuMjcKWG2pfXYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CqWyD9TKVVKxP/V/+dlFHfqqQO+hsB0l/wolyEkX68=;
 b=AQP61rOb6ROS4pF31vLAyeLpPMGXVHYrf59ZfFJKbH3mEQ4lCMoEceRso39qt8BRC60DNa3Zc31mQI7zoBSYNk/tBr8orVqD2e09PV5zaQhRshps1BW1g2suT3Knb1vkct+Vs75zSqGntqsTskOHocAI3UXWQD3PgbGj9HUhNSo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ5PPF0BB87A13E.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 18:27:38 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:38 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 06/10] mm: Change dup_mmap() recovery
Date: Thu, 15 Jan 2026 13:27:16 -0500
Message-ID: <20260115182720.1691130-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0076.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ5PPF0BB87A13E:EE_
X-MS-Office365-Filtering-Correlation-Id: 30265eab-61ac-4dc1-3625-08de5463c2e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aTNl0cIH+lDAECMDgSMLpGS5YRhEkBSK/vLX+nD2sKzEPQwR2Z9bnB07+Q22?=
 =?us-ascii?Q?CdIDMi0WoHzukXWWte3Cmg00kgMSQ5fhlMEvO606c4+eo8QeMMs2RZ6YzmnK?=
 =?us-ascii?Q?jjOmTOoxuRaxLkaRu4Rzu3BbzYEtMe2ArSR+6nNwTWzvXP8IK/3ZlRwAMG4A?=
 =?us-ascii?Q?DdZntY5nOWVsHydlZLwn9yOLqO4kZiElgs+h+LicdLAMjMbctpPQ+m0ZkJ8l?=
 =?us-ascii?Q?H+Ys0g9lRiRfRDGnIJhrWAdPM99/yM1N16ns1HsPchd3hflWMO0eyMVdS3cv?=
 =?us-ascii?Q?NrRmaXljvmEg0UxKf6TFMXZrgVldwHjP15lpTyDG2RnA8YsRYBKPiwX2sC2K?=
 =?us-ascii?Q?GDgbFo44zX4W+yXt6Gtz1gyNEqCF1HC9mEgjR7WZaRhFcp7GuMYCcNFKSN8u?=
 =?us-ascii?Q?UfEb8sPuV7kl0fqyqn7OrYKmG96tn2FGxzW3s0+xCh5OQXy1WxyMdgN8tV5j?=
 =?us-ascii?Q?xuH1Vg2kFG9MIXoHbK3RiN/KktUvGAeFbUpsRLwrtb4dcELEmIwCbKUoMyvu?=
 =?us-ascii?Q?5n+SM2bJXy3hdH3inYE0bRQG2NrltmZxISPsqun79xbdgzcmAwYvEhAkv++/?=
 =?us-ascii?Q?wtdic+f28T+/oRfOHa2MVbIEGNDiTqiiQtLpu1fwp8214hgfBHb/kKKp7UXx?=
 =?us-ascii?Q?mJq4MXzxN7xHIlMN15A0Hyfj6NpNXCTplBdK9D8U3rlBYlWWUSQ2lhmBL0u1?=
 =?us-ascii?Q?sBoI7N/b8SPwGzqFc9AtzxSxmjHOQT785MPFx3XngN7FvIsQ8wb69gbaIXNY?=
 =?us-ascii?Q?sy3sGYrqKCB7HptVy88CTohutnbteCyHTRhZv4B24yRlbSZ3BOYWtqf8+z16?=
 =?us-ascii?Q?z31dAT6A+1m7TcwXTIkQjIr1kAjD554i+2ye3EYyWf9fmhRfJYZCFFr1sDgV?=
 =?us-ascii?Q?T2oaQLqELwzhoI8krf+N3QB3iCWgJ7CtrZADaHrMTAbb6RNZ1NmBWwoQUGNd?=
 =?us-ascii?Q?hxwfzsziQmy6SOoDvB4MEerGWCD/65bqfLAexANXMBDJvw2at7uUMwJNPY7+?=
 =?us-ascii?Q?OK/p7UAYZ2WjlOQBXGeqFykCAFZ4VnZd8qI1lCj8CbAyy7PyULho2Hme4xX3?=
 =?us-ascii?Q?tJGDEC3oDLWVLkHZmP0cZv3Jt2QCNrFHIDoHco71IhZMQ0mO8R8AEqBZMe/u?=
 =?us-ascii?Q?oo9BPiZ/uiCwaqx4nBn0nmN5mbBd6Wbskq/S/aQMYwoMq5unCXAQNmhtJDEX?=
 =?us-ascii?Q?yCEt/OGqa8w3wUrj6P2/cxiD+W3it/+OawuQmihHTYBbqlFl3aLnqpflrXiC?=
 =?us-ascii?Q?xR9SynVez3A9E7X2sL0XM1n/Kp46g8zADJ6YIgBgNClW2e4w62RXl42gczP0?=
 =?us-ascii?Q?5I7+WZdFNyGEoYPj0rX9bd5X1y3oo1AU5WIBFd02/SY8/fFwUD+JC8H/dUiL?=
 =?us-ascii?Q?6XLXAnXe3cgWCypw4aiPRxZrB/ZdJksBoEdUb+KJeWURUBCWuyaRBUKjAI18?=
 =?us-ascii?Q?6XaSppI4/yGYz2yrL/6pBNiMwbHcEDuj/V9vj1a8PsXMgLyvmj8jZtU2LkXz?=
 =?us-ascii?Q?sPb9gcIoVCMHxBWpn45U1XBDfqd4i63qUATvnfJdRe2N07XaXN+O/w/z1pZ5?=
 =?us-ascii?Q?nXA7WX2jwaLkPmpdHYo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mgHuEhQhaRgg0w4e1s6P3hqNaIS8zXD2VGI90UZpwqlkXT/YFOVC71C/Twap?=
 =?us-ascii?Q?RVMNh4ukLFeGaNhWMpPQYWS9bHUQ8pT0fjaZP9M1M8mcjgj8a6yoTALZE5lu?=
 =?us-ascii?Q?pXVWgMU3CpKvJT3lE2VMrUAPdZ0lPfzne2NwktggXgndaaPNafxjE0bT3mKl?=
 =?us-ascii?Q?2qoNt1dfRoyBzffklZArWSHpXwnhLSakn7wlC/F0MGSPu6Bdleg0NRSyEUTK?=
 =?us-ascii?Q?8dnIb33yKojHcXAUbCmH6WHcQwi85Olfd+ns+SdPM2D7lEv6CET4FkSBemkR?=
 =?us-ascii?Q?7xosWOYl6k+XnKIvEsRqEFdhnSSwKJjkE2DHvCYa0xe7T0Y7h9pXvv7zvr4z?=
 =?us-ascii?Q?X7Tr0uTSToRtsxlWU5yxDfeIKa6D/xTMhM8pogpQzk8v9JukDlh6dcWD4oav?=
 =?us-ascii?Q?JfUgYLFjuPPGqLp/N0trb3r/vSaz151+QCxcS9I2IIcVtU9+bNxSbQhKF9IF?=
 =?us-ascii?Q?mBx4nO2GaF9W2WfOHDMeHaH4PajLyH9MQw4k3o4r4HVFcz6zfIIGFW3PLWsE?=
 =?us-ascii?Q?kEGsIOmI+1evsF7p6HTZP8ft/NVqzSMsdEXgRVwojidZNmIYAJ+33N01iTuT?=
 =?us-ascii?Q?PSRsiL+er8UcBQO9Ry+OBxxv8j1UKtwtN1dbPJe0qFTBBneEOfzga9DcKQX+?=
 =?us-ascii?Q?SgYJR+hkFgfWk8NximKyOvh72AopWvpEDu+F7W4ud+aOZ/GokT60VBGUQ76v?=
 =?us-ascii?Q?ztBQXlXjUxJyEoMV6TbNlhZiL85NDjJcSpSDHMi6cQqOU3C/4eBLNbtjGbG1?=
 =?us-ascii?Q?r4AjA8mJwaLL5H31grE6UA2+D3ould2zti3prvwqigvhjCFxsKOUIeeOda5M?=
 =?us-ascii?Q?pUy/UNhdsn1hMQr2IpM06jehAqqAF5P8Mn2/mH2tOB/Pw9bQtjqOlgn11MOk?=
 =?us-ascii?Q?7NquaFZvDjlvwPimwUY0pz8qsUVJp8gegQY+yJQFb6ZPWtdp0nrFs2mW7Ae2?=
 =?us-ascii?Q?0c8bYn0bVFkz1yemldbdN8IY3ULJFKtA4la+jZ2AnTrHAHF90iM7pEHoQG9L?=
 =?us-ascii?Q?9ThHmM5fAlAGM2qluDVBIKWUvh1KOY4vNTJcIvAuFZcAWm2j40HJVbFw1GVG?=
 =?us-ascii?Q?/urid9fl0sYXBvTsm95lFpz3gC0GnYHKpIoTQF/I690CI4WWcI6UF71BUjx1?=
 =?us-ascii?Q?JiE8Ly5SiIVAaae2nonj1pryTcnEVPDhgoJho0KqzNudhEJer/xUZJ7Dh0BG?=
 =?us-ascii?Q?IDCCrnCdu3mjk1+N7SB5Fn6URghoGyeNFHpG/1tbsLEi/2NeMye0cSh5dPcV?=
 =?us-ascii?Q?c9l4xc85BwCdni5ITgThWFLpQJ/SHYvR0MTDw3Rn7cID3pScw5LNmRLKWs6I?=
 =?us-ascii?Q?B3j+3GxasUwAqHokX0Cwrm3r8des0J8OkTeeJTg+7a0uOxlIOHTdsKFR04h1?=
 =?us-ascii?Q?8QcDVnbCUwV1Y7UA/MYY8tnCRgBKhtf6qV+WM73ua03hdJhoHW1NcdRYQ5n5?=
 =?us-ascii?Q?6u5EbXXd0phRrKsdw0coHrXVAwMLqbpqe5kXQDfUlbbknclsZ4S09i+gLjgB?=
 =?us-ascii?Q?1/t0EI3K01uK+FQBMmXVRk6WU0onSsxYDtjkLhHKaH/cGR5FdB8bmAVJr80/?=
 =?us-ascii?Q?WGGJlf42ayJWGSko7Cb7pDk7IPMQ+1ad7guHAtSFcz6qvfWtP1nn7dcUVRQQ?=
 =?us-ascii?Q?FamcsIWF7seIymN1NieR5g0POAJccqfdPQf7Pca4ld7mOGKT0Zzop8da0V5N?=
 =?us-ascii?Q?u4vFcMqPPoz2ZCJQ5miejApIN7EAobplR2Wn9j1WIErCxbzSwpS3mTsnDI/X?=
 =?us-ascii?Q?wGGTK1YImA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7V6IpNssOwnbg6kSVG2zheVGvFHbocah90XbgalQ2sX5+flSkXUEFyLUd3C/iKDFCTdItsapH2jXNQyqrb3OUjM/COFJ9Yi4RPpi1djnqRhwQUeqB50bAjU9dV6uBYcTZo6StU9hX6oSmWFd6VFj+FYe+aVYnW33D9yp6nYnMhBsxUPHwIVCSHR4EFZDT0YWBMxgjfdwH8zEim3vokWudtgKBwAAlr3CX1u2/hZ50QB8CG3ahDoa8HVu0/dbn34s+gohqKN2bGlnvZYc7BMcn/RASLFYCduMnK1PSuRHwnBe1o4nK9dEz6Bq5ee+UXeNI7FtFYWNkfauV7hJFSjtIO6hJXjEZndO8pFyrEpb73Cz+eqifmGYS1vOQcEWYbgBS3myK9eOAGdxpWCA9Tx5n5LkAxRI2FekXiFELxlQ7OrVBEWxJTteVNNr8wh7hd/sfulbAXCCdMnsLos/9y+1I5DZODgK85ktWoWrez8ryfH3xm3hSBgl/HozFQLEiVKeggUERhCbEvgW55TSTrZaDwTu9e4TzyPotIfO2pSIYqr0kz/o2YiF3mLUxl44llX2pA2lE5kEhn8oFbn1xuOB19NXUVu6oDPS8bpSJk6s0M4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30265eab-61ac-4dc1-3625-08de5463c2e0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:38.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U30cyfMnFNGrXnKyt0l/YscNfi0j2uh9F7S8mxypvvli+VrXMGtQe4JYPIVQV7PEh/TbX9QCIN7A5K+BIdZhRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0BB87A13E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150142
X-Proofpoint-ORIG-GUID: QUQ6POAdX6D-gnyLVYvUpc4usJ9nOaaV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfX3V2bZbRA2A4q
 t0bQizInCtqc25PF9JQD5/1/t5QiwDIiPRjkHh8ATtcjT8GFlsSC1rhVmBCmrWlfnC1TSp+Po4W
 N3WlVeGO8ERSXuRgx8OaUran3E43dA20ZQpcEeN8tdfLmH8K9peo1u1ub9RGAsuM9WrevV2rZnJ
 Rc3Y3dmj7xTmfLm92V2ZFLyQpiEYjshlmh1hSJhvyTKVx89MPfl9K3Ap14iW9Uo6qnzBVnUZ+B8
 ch95ksjq1ZAg6i9JU4mcr4LpE2xPN2chRKX6Lo6GzkKw5/OtZTeYpnAF/D1wr3RUW+2/8dmSBm5
 qRh4yjAMO3zN3Dg1AuUWGCBnO2qPnA5aM+IyMRkmnQKUdIFjcC97/zUUZ65f9jPSZny0iPSa+Wt
 KV5zkUoGWNDVmHK7ImsepRP8tl0+ZNA5Ruv9VkesJmiI3FqdWXkrpaQk0vd5Kbe0zrqU19J/TFW
 sYCMtdo0zVmCajaOQqYVS/VyasvjImBoeUYMNrOs=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=696931a1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=-ybE2mxfzGY9hGNCwgsA:9 cc=ntf awl=host:12109
X-Proofpoint-GUID: QUQ6POAdX6D-gnyLVYvUpc4usJ9nOaaV
X-Rspam-User: 
X-Stat-Signature: o8qrf1fghi8ew5aojp8ya8gnzm19gea4
X-Rspamd-Queue-Id: DA1134000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1768501676-716762
X-HE-Meta: U2FsdGVkX1+i0jlPwZn+zo4N2K4qaYDYmKfNYbJK/pnnf1B21a3/MOVE3yVWLbje6ZFnCoS6SC1IMQpsZPdx8/ktqj+lblPUtayfl1yaorcsgG4Mq7yo2WWTkJhvzr6gV7VdpHe+HdI28YnThzQ7bh+EMC9WM/G2bNPvvgeQxOceoQdYLbxWqanA4p/QjWytzW/vQv+LrFZCuEYldiGdpnucytDOh/k64W0x3/4BJBw3vxveyBRrhdu84C2AYNOMe4C82X8iBo7IPxhDqicYc9rxo13XAyLCjH6t0eb0dXsSGNZAJm5RhmY+N7Psre5z+QyURacR7yPc1BouLdQ3rXaE6IA2mtLBcqEfDRD6i+Hk43oprAqZNvG0dFo8h8QKfXmyf1I/aZMcreRy5DrHUATY2oOzdA0oM2YAmTAY4Hik1FkOx8bMpqnVUut1KrJKCEe+fHUaCv4OhNkT/Qri0b/GK0xA6KdipeJBafRAZ3yCLFfANi4KpPdZEu+KIF7PMnkGcpcbMfAwkQ8khGXispoXlEF4Gic2/8VdWYZ2BGroP0gZ3n+CYpFxn+8VbfnCI6FMG2lPP9KEoEaUmvf9CPnpi9SP5rVtfg2mxDaQsSwmmJpQ+KtCUZOQmnNxKVWm0uJnfIhbirstedA/SRu6jlMHXMXWKhDophpwmDRnpLtZgkZocHXg83ycYMnr9DUIpUBQs0lFAHXsY0+dX4s6rISfHCl6YisHZbvsE2EbePriNpAGGLLZgSKDST++gNPim9tX1BQl4raFDBUE+XkQM/OpJHs1OUtX14F1MvNxLX3WLMUDetcmzczDGOZ+jACHi3R8jwmE/QhYkLbLpuhBEqqGYo0zziSsyrPtA91mclvKlqH5fXytbAMslTwqVysX57ChAgoW+DYMsRueAQRDRpGA0+SuPu3d4Kk/kqUX5U45dPskyNog2Kr7AvyKfRgYhG2oBK42rSULLnGzBRT
 +HZnmJMP
 CCiD5PCy1o2nvj8uLRft8hoyVdX7QDKZ+c7gXUx7AdVl7ey+sZWf3UjdZyCjt8RynY2fd93tfy2CE11dLK9lBheSsVxmT3a63TbTbsvU6lyNTUzUs2REdfKNfFKac9jfZ6fKGqJsnSaohcJZsKZ40WaWCFDtBf+ndQbrOPT9qgANe/XVCqm+u49DksbWA1I4iw7c2MCRUmV99YYSHz+MIVwpAXRDBxYQ4dv2XSNH6T08GJSCWSZRXjHzKu8LGwkYkSF8bLEapf7qfksbpeVI6J4RMVc0l6TVCx0pCAQKwnXqjUs4B/v0zm0aFYhf5BZXkSOKU7Qwc67oi7iWVBuSeCMHODx5dqVlq1xuljbEMwauXap2dNSlJjvec1PS0g2m7b7DK7I/flMZLbbs+3tDGqLKdEgyw0MvsiBnwex5KyyN0oU1Tg0ZssPDOwIdMxsJoqEdFf1n3t1lGT2gqrMaeIghY+l8kdISvq4znPVFdC27BcT6PgKRjoLloKaTCZ+9luTGtCoXA56pn73hzeZq7TfgWVFCy0undpHugeIoor37YpXkLR4P2+zI2/N9f+zCcFo5nJCcVOEgPlsHzC2COHJTy4bHP4dJOzJeYis3VKzSY+jpEBa5a4YrhE57MWEyMzvZQLFgRjWi7tuo3++tL6dJ2pGSPoYIau4/dg7FSH+7408VD7udHPk45qt0Yp6xMZmwzFtXAjoGc8as5Qfey7nhuVE/yRH+yj0Wv1bqtc+HQElNsM0Snbrhld6fNYmVokEDgP5xHp5SkEE8xKe7uxA8f0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the dup_mmap() fails during the vma duplication or setup, don't
write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
free the new resources, leaving an empty vma tree.

Using XA_ZERO introduced races where the vma could be found between
dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
race can occur because the mm can be reached through the other trees
via successfully copied vmas and other methods such as the swapoff code.

XA_ZERO was marking the location to stop vma removal and pagetable
freeing.  The newly created arguments to the unmap_vmas() and
free_pgtables() serve this function.

Replacing the XA_ZERO entry use with the new argument list also means
the checks for xa_is_zero() are no longer necessary so these are also
removed.

Note that dup_mmap() now cleans up when ALL vmas are successfully
copied, but the dup_mmap() fails to completely set up some other aspect
of the duplication.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/memory.c |  6 +-----
 mm/mmap.c   | 42 +++++++++++++++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9043cfda65b94..4331a6abe3e4c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -411,8 +411,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *next;
 
 		next = mas_find(mas, vma_end - 1);
-		if (unlikely(xa_is_zero(next)))
-			next = NULL;
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
@@ -431,8 +429,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
 			next = mas_find(mas, vma_end - 1);
-			if (unlikely(xa_is_zero(next)))
-				next = NULL;
 			if (mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
@@ -2125,7 +2121,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		unmap_single_vma(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(mas, tree_end - 1);
-	} while (vma && likely(!xa_is_zero(vma)));
+	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 827a64cdcc681..48dae3d48e46f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1285,7 +1285,7 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 
 	vma = vma_next(&vmi);
-	if (!vma || unlikely(xa_is_zero(vma))) {
+	if (!vma) {
 		/* Can happen if dup_mmap() received an OOM */
 		mmap_read_unlock(mm);
 		mmap_write_lock(mm);
@@ -1851,20 +1851,40 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
 	} else {
+		unsigned long end;
 
 		/*
-		 * The entire maple tree has already been duplicated. If the
-		 * mmap duplication fails, mark the failure point with
-		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
-		 * stop releasing VMAs that have not been duplicated after this
-		 * point.
+		 * The entire maple tree has already been duplicated, but
+		 * replacing the vmas failed at mpnt (which could be NULL if
+		 * all were allocated but the last vma was not fully set up).
+		 * Use the start address of the failure point to clean up the
+		 * partially initialized tree.
 		 */
-		if (mpnt) {
-			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-			mas_store(&vmi.mas, XA_ZERO_ENTRY);
-			/* Avoid OOM iterating a broken tree */
-			mm_flags_set(MMF_OOM_SKIP, mm);
+		if (!mm->map_count) {
+			/* zero vmas were written to the new tree. */
+			end = 0;
+		} else if (mpnt) {
+			/* partial tree failure */
+			end = mpnt->vm_start;
+		} else {
+			/* All vmas were written to the new tree */
+			end = ULONG_MAX;
 		}
+
+		/* Hide mm from oom killer because the memory is being freed */
+		mm_flags_set(MMF_OOM_SKIP, mm);
+		if (end) {
+			vma_iter_set(&vmi, 0);
+			tmp = vma_next(&vmi);
+			flush_cache_mm(mm);
+			unmap_region(&vmi.mas, /* vma = */ tmp,
+				     /* vma_start = */ 0, /* vma_end = */ end,
+				     /* pg_end = */ end, /* prev = */ NULL,
+				     /* next = */ NULL);
+			charge = tear_down_vmas(mm, &vmi, tmp, end);
+			vm_unacct_memory(charge);
+		}
+		__mt_destroy(&mm->mm_mt);
 		/*
 		 * The mm_struct is going to exit, but the locks will be dropped
 		 * first.  Set the mm_struct as unstable is advisable as it is
-- 
2.47.3


