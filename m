Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C211AC55162
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 02:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C40F6B008C; Thu, 30 Jul 2026 22:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DDD6B0092; Thu, 30 Jul 2026 22:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE8B6B0093; Thu, 30 Jul 2026 22:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46C4D6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:18:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BECA1120317
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:18:25 +0000 (UTC)
X-FDA: 85047462570.20.B4469E7
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013068.outbound.protection.outlook.com [40.93.196.68])
	by imf24.hostedemail.com (Postfix) with ESMTP id B86DA180002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:18:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OroRuM+Q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785464303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Oda5z4ZaDge6ff+UY+DWKDLtpP+OPJBcH+CzdLENdjM=;
	b=O/MD+JLnRiKuVtoaZy6U/H6i6wrdHWSPfBlqNjYlLjmr4cNGkJAhsORSosV1bohPebcnHW
	4cwNJWyRUniPWTQo8JF8m/oFDxKgXG8shizHx0uWcomRZiq7ZxzFZ6P/pC3SlGWfUh/LNN
	d26B8704AIq+inMj9ce6ZWnDq/6TUrg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OroRuM+Q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785464303;
	b=jpzzZuedRrJCNcSxvgoYqfSQO2/eZ90/q1z+7nR/HZC6AFdZvzcezJPwYay76viSRgjxxB
	ifuyOouYWvupPOc7A2od856T1pw45HzovbKBQcUQJUTHYZ4rbPhq5FghxMsp2R5Gjf23Bz
	DSnQEcHtUsZEfBUzs8HtstopsMr6Bo4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=covRHrJCpCM2LSO6DMXnetBUYjFUi34WuknDwHwrOzWphFHQdQv0RnOXznsBjg2PaM1692zwm3m6TJgZLVlVUecO9dMTjG+yzwn/exOn3DeJaBEgUbFtBpbsXH4EPkPZ23coFkEHB2ZrSAyQYIBroG9Gxa/EWdf0nwt8WKS8paOqmZy5oRA4yZ060xTG532NP7C2hN2U6oXQ3k0jY3DjzC87+fs3uNR17JHw2rHa0b2gtgr21oZbhhvRzu8jjug04YH3wvDnrRqLoXTheUEFWyCkzC65nb3CHWM/aoqwdEPaL+4ib2QKNU5+XNjj5e//fCRjzUhEvW4mbWFBlp2xfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oda5z4ZaDge6ff+UY+DWKDLtpP+OPJBcH+CzdLENdjM=;
 b=JArOYxskzI31nwoHUlXmI/AKI1/yR9xHLMCXPczZgP2CgBXfEpaksf+maYb2+IFk5QPesEXY9kljC2Ga0kmDK4dAYJAfB3dWhxUBmGV73M+tEwOhtgXMmLzl18k3sNgAyR/hxfFr4pBiJ5I+Y93PRzqFQbdgzSM20mKX994HnPNKAFlFL2yrwDMZnFUFBmxCaeqvN7XGPJZUMfXWJkYHsKKFy4EpqS9ipWqe8UfDdwbp2AsaAUdZvKBoFENdmkOYrH9x5Z0XCK0nedJdBoo13KGATT3p3gn0OZjrEE9nOFLJiuZlg9Z1VZr9v5gOohgdNCHaIApvDoO7NlFyqB1OUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oda5z4ZaDge6ff+UY+DWKDLtpP+OPJBcH+CzdLENdjM=;
 b=OroRuM+Q2sbeoCN5AtOa0Vckiy2wzIW6k1j7K22W1H+llkdpR/1hpI7bVN4W8NxcfKFRZ50FP4LT3qiR8KZmnDC7KUvoBweJGqcNRlD4O+xnHYWdhgxzcuF6ACx25HDNC1t3A+qI5fUkG9+5khSkDrksqzkV7qoM39jQPkT7eRIcMEuo2KUF1ND238enmyuattBqGp3jBO9YG0AibtbrcBDgwyIvVVKZBpQzM0VASykoQa2gC1uQYYdD4AIWwZnn13qInkP1xMFUw2dd3LD9lnMzY+gRwp6PIg0sicDmfpBOr3eVXYX2ZY/wg7yjA1SxZUQ8S91JIW8Y6taf0o5hXQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW5PR12MB5652.namprd12.prod.outlook.com (2603:10b6:303:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 02:18:15 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 02:18:14 +0000
From: Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 0/2] Honor XA_FLAGS_ACCOUNT in xas_split_alloc() and
 charge to folio's memcg
Date: Thu, 30 Jul 2026 22:17:59 -0400
Message-Id: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANcFbGoC/5WNSw6DIBQAr2JY9zWCRmhXvUdjDPLRl1gwQImN8
 e6l3qDLmcXMTqIJaCK5VzsJJmNE7wqwS0XULN1kAHVhwmrW1ZxxkFrDZNdBKuXfLkHysMk4xHX
 BNMhl8QpEI+moRCtGzkkJrcFY3M7Jsy88Y0w+fM5npj/7Vz5ToHCz0nSj7VrRiIfLqFFelX+R/
 jiOL3ZpUSzVAAAA
X-Change-ID: 20260727-add-gfp_account-to-xas_split_alloc-83a1bc848b77
To: Johannes Weiner <hannes@cmpxchg.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: YQZPR01CA0104.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW5PR12MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: bce995f4-e1a7-41ad-9047-08deeea9fa0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|18002099003|10067099003|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	/sC4Jv1dmqTV3Fvnaoyq2azFsWE+boMe8uwjjsYi+IAU5BLdIdLE7POQbaqZfYg2UYyBgG0kD5O0PKvJ1rs/zElHLDkb34DYMumsDAbvCZFENuUSJg07vfkfRJkxixe/H+0ARIsoNBDZ0g3pKoIbMa4MmNRVlHx4RDi+Q4tKE2f3QlU5BOzpNTm4bVFjSgTQpBVO4GdntBx1F015CCYZwt/DlQ30mUHwsmBRBx/UkJ5Cc/pf9SUb6WedsoT0C44qhONnjekyl0ZHeshCezoVLV7WgWMnyufUU+2AqQSEpQ5LtgDvxlQY9XP/1Ejpxx9BzxNj03+xO8JdTCEYaudVHBJyLRcT4WNBAwU2ALhsPkg7IkJkdUPG/O0tEvr3UgxHe1XX917alaQza71kmkK33e/teCAym7uctS6itd1QpkrBi7zsa3E+qRate0LYhErYKxVlfeTEiAGE0H7mMCwJJNoU1US62iJiN1XAqAWeP9mi0zZk4VT1ZGpVEn2H9w28Q/7EP7MaTf8MKjTtF6WBbUn+YqvW0ntaldSD3FzGhzHVwIqLl72yz3StMz4kQwFmLpr2oKpFMWvsdIgzrnTTkl4muk+1dTSk2AnNpcusnDnNr9BFMoxt0lIIU0q+LUxlG92r3We1By2gUu1lJXILgW7FQt2pHYkC5Li87r7FV9VG4w8M32o6cB8UauDFFe8IW7jBgX6k1TOvr+fX6o6Quw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(18002099003)(10067099003)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDB4Qjc5RDlNWVRZRnZ3bWhSVEdTNGg4eFhneVM3WHl0Zzd6NFBzUXcyNENZ?=
 =?utf-8?B?MFZtMVMvbHBDU1N3YkNhUUlwRHNrQ0tmVnlzMk9KQUZ4NEx4S0xydW5WRTZZ?=
 =?utf-8?B?RXBuVTN4OHpONUdmVUNkRGtUV1pMc1E4NUMyZUxJSFB0aWhWWnFSSGw3RjM2?=
 =?utf-8?B?YWFRWGFhM0RjOWlMVmg1dTlQOCt2QWxaWlRYeTM4VnJLZnJUWWtZcFFMSVgr?=
 =?utf-8?B?enEwaDByWm11RlZiYWFON25CaFg1dlZKWUd6aWV2SmVqNk84aG04Ly9DYVp0?=
 =?utf-8?B?dFNGY1I0Y2k2ODgxdXhtYmxpYnF5SUErd0JRWGpqTkJpdkNkSnQ0clpLem5D?=
 =?utf-8?B?eWt0UVJpZmZ0aUV6SnVpakt0N1phK05XZ21oK01nQTI5OEpOWldnVmpWbmZG?=
 =?utf-8?B?Ym92QW50ZUlRV1Z3a1FRcGVoVFhFZC96eHVNWUF6MVBOM0NVanh6L29oSWVI?=
 =?utf-8?B?V016SE5BQkU1M050azZXQzdRUitXckYzQldMaFZqUEZ6QWJpLzc5a1Z1Ullv?=
 =?utf-8?B?M0JEblZiRmprbHdUMW0rOEVGZ2FvWk91bTBtVXRwMUs1QnZJbGtqMThQU1RX?=
 =?utf-8?B?ZVppeGR4aW93RTd3SDF1cy9QcWg3ZTdGblBoQW9MTlFtOE0vTndtQnczYXNJ?=
 =?utf-8?B?eVBxenJscHZRMkpzeG4rV3FzOEtNUCtqQzIxNUdudnhNWUh0ZzBWQ2UwZ2dR?=
 =?utf-8?B?OUdYZENlWkpZZlpjQXdoSmFkNWY1bFdZVDVLekYzN1NRRmFOWXNOY2lka1Jz?=
 =?utf-8?B?aWdwUGVIRHZQaTRhT2ltUStKb3JlVDdaTXhnTHM2SzBWYktoZHRvb2dicy9u?=
 =?utf-8?B?U3N5aDFoVEU1NDh2ajZZVjcwSStUWU41NzlTTlZHUVRuc25Rd2ZQQ2Q3c3BT?=
 =?utf-8?B?QktTWXVsK3FRQjA0ODdzZllnMVZJeFR2MUpieUVBN0RkaytDR044T2NiamJo?=
 =?utf-8?B?K2QvL0lsUVNHUlRaUy9zYm9NaGdBRVF4ZVVUdXo3Y0htMFhKaHBWZ01SVHNC?=
 =?utf-8?B?Wm5nQVh0cndISlM0d1FsSy90TklkQm1QSVYxNVNFb3V2dW5ubFE5dEVBeTBj?=
 =?utf-8?B?UVF1aWZXaWFDYzVpNkNRaEhWOXpKNmlHRFdGazIyOWhrRU95dHVMdVMyVUJ5?=
 =?utf-8?B?Y290bGhqR1YvdVcvT292eTlXWUQzMWdWVk1xL3RjWURTTzdMNlJ0MlJKdVpV?=
 =?utf-8?B?N0lPZnFOdUdsc2E4TWJrWE1xZDBhaFhwRHlLSlNPcXRyTEpjaE02cHJtUURy?=
 =?utf-8?B?bDR0MGY1ZGhGTnRKQks2bk8ydGxXdTZjNVdmNVl5ZXN4dTc4UnF3Q3p5bDZa?=
 =?utf-8?B?TDdHRGsrV0VtQ3pmcXFsTGFxYmxSamx0a0NGa2JLUklaRkhmZVg4Q2M5WlJB?=
 =?utf-8?B?bmQwL3p6UjhtWW13d05rVHJSTEtneEpTdWdTMC8vNWY4clZnQmFEbldxeHJr?=
 =?utf-8?B?TjY3OVFrTG9ob0czUUlyNXFTSWJ1OFpIemVNS0FhVTZ6djVCbENnZktoMDVN?=
 =?utf-8?B?UFF3cHpxa0lQakRIZy9IT3BqamhrOGdYVXZFbnFqTURIdGtBUmMrVWdiLysx?=
 =?utf-8?B?bzV3RTZPdUo2cHFIOHVlczJDTktsclBPMzJmTHRGYzlPOThvL28xOWI5WjVN?=
 =?utf-8?B?VmJBRC9uOE50Zy9MMW1rUENEMjFXOC9lbFJMMlV2VUFGRllhdGF5eVJkMjEx?=
 =?utf-8?B?MlowS1VuMVdIMXI5TVp4M3V0WHM5UGE5VVgrdjIwbm9GS1VnNWNNSzhHVDhY?=
 =?utf-8?B?UWVaM2ZGUSt4N0NEdWh5YUpqMTBFWlZNZWNHcFhwSENEUjFVWVZjN1BKRlZZ?=
 =?utf-8?B?RzNrOE9KU1JRUDRJVlYxZzY1RTZFY25hSitkY0plcnJRb0xjemhmN21rS1FE?=
 =?utf-8?B?QTM0eWRRam8xWlVuVlNDVlBBM2V6Qnp5Snc2cDJHVXYrOXYrUHNLMzY3TGVS?=
 =?utf-8?B?dUUvYmVqWGh4dTRuL2g4dDZjQW1nZjFCZ0E2YUFEbTdFV0lWb3JBSG5zUWxm?=
 =?utf-8?B?ZFp4aUEyQkVXRk0xaENnYU02RWUvWDNSM0ZKeFVaTnNXVlpnZ0hnaHhIZFJl?=
 =?utf-8?B?dzl0a05hMUFWSlJSWVJoZUxIS3Y2TUp5Tlg4emUrNnVNR3Y4VUQvNlhLSEpD?=
 =?utf-8?B?OEg5b1VBRU5lZnYreG9wL1EzaTJQUUNwU24xMks0dVBhWlR0S3RLNlJOZkNj?=
 =?utf-8?B?WUhuS3NRK3RDdFZJVnZvTmtTVUE0VEZaSlh6UDNoTUxEUW5zaktZUDc4THNJ?=
 =?utf-8?B?NGt4bFJ0WUNYcFlGQ0k1dis4V3R3a2EvZllwWDl5TURQWHRTUmliSm9XSlR1?=
 =?utf-8?Q?U/VzdmaI3A1IFbOXFt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce995f4-e1a7-41ad-9047-08deeea9fa0f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 02:18:14.7125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lvs1/5B9HzfvVg7+6uh7d6j4gkrLdXzboZPzboCID59KMfH+4GutSXtO0pU6XbmQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5652
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B86DA180002
X-Stat-Signature: 64an5o9jo894wipbgt7t48ekss4ctrjm
X-HE-Tag: 1785464302-45327
X-HE-Meta: U2FsdGVkX1874OoxKStmfOAj1/j5x8/bh0HEQfp2pT77q85G/ykOdeWDWV29IGOPtM3PRMvyicrIGNjy5dzuOniyHNN0PX6dD3ZdSzplfYsrCuWEz+vF/SfNJVBUqrSx21d1GkmDDqvKvpVRJFHg6L1sDUUUy7J6XQEIsWS4zIxnODZ4NnqaUPL/YuJ08nVbaGc5N11xZ2bbekjZ5nKzHwL9XFReAIhxCDO7QIzfVvwVFGkij86GGDXogt0nqN3LfNkFN86uJ8dVnhbzo5H9+MYeDSziCUs14eqZcZkZDmA/gk93nJ/e5mx54+IyMPXhieZExmbRIJwkI218ArTk//2yKAQmEhc2O5kIDkCRyZo2H7m81x2tNZweKChWZCheLzpScEFuqUSltAVcNlnWYXVPpx/k+KkH/VinPaQyDyEFnvbx7Riuialh7HKD4VNl1EttMi9PhRgmaL1hkcMKYin/RbFHAfm7bDR3/uPwecv3tAy382P6vbTysl8dmiyw+nsnfIw8QmbQrNtUgPSTiFtyoyx7fJNjNDqBFazAxdizSwaAA+C/JSPSuPm0IYaHj870+Ef1+I3TGH7qeaXZlYt1SrncZY722jY4VKSILlqVR6u8G8LroPxH2wtbAJZsLL4n8mMk5m4avUrhfDQehlBHPUTOhxOL6K0hNU/2qrJdv+jpDYo6Cz0FPgtyIihbuXjUGXPZju3IupzxFUTxNp/YkHrPw1Z53JmfrgSR6YPvwGia6HrBJpqkplCVNDp75vaPwOcriYHO6fL+2CjagOIN8M3eiyATl9+WvkvyL5qR8twUihyE/p7pMx723uvJajOTVUP7eZJyuxPa47z+IxdE/WDl/gW3dCCdZzxABGGcOK6Lhu2b6s9IVDQPmxeFv4jE74yZ+HQxwZsxfx+PryeVucPdr3ZnmP3AHcQn2mdD1paRbDQ3LYK81DEh1Vb0ISLZckicTWffjp0HFFX
 b/+MTcXA
 Qh3Wd6BJfQQfEGbsoB4UoNBMg0xlnjsgiokvQOS067qRbAe7qm0Hpw8pP+1UaOXdC81H882ITzqdUC5+f1qP2KBMDdaXhfuMMshnoS55TV0zhBGVqE4TxcVNDpkW1ifem9HH9Brl6tu28JaADhpHSsC0EN2qX/5rDXIFzcK2OnOVjNCyHiibDSi1TtMazORqgHeyvVhjrenX455XpLBjs9CN8STusPac59eH7QnLyIMQZNgASUIo0tQt5Cp3clQD6BiT0hZGNDpC9ZGaA+PjFhNuHjJ15rvVQUT206OGbupY0OGZaWXKETffRuVWplhw5pHwm86cUHQqztmlS6o/vZdBpmAcnNlw71x97c7LFwBxI+F9KSOoRASYt8FgvQX5gVyLX2ROw4PAOFEJwVTxFX0ujqbAkw3bzzjzEYB/yKHLJtJYEivdkR94vt7eZHGOKCJPaYIWTIJLMe5VdlOHr6fh5iV0mZM5lmGEFUHGMz2dJbWy0vh2dLB3wkDvyQxNVeLzMo0R3zYKXrTk7ec9ynYdsMdB5xT6y/ubcsXKS9hAAzLBYmhDRAwQNUVgE+ElzPWnKdj+u5eqzj4DW6nvkqoM5gFmP6KnChGIMVkG2yQkfb0aMBzbE+t9dsr5rvtwEFNNtntyTKtr6l28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__GFP_ACCOUNT is needed for xarray node allocation accounting when
XA_FLAGS_ACCOUNT is set. Commit 7b785645e8f13 ("mm: fix page cache
convergence regression") fixed a workingset regression with it.
xas_split_alloc() does not have it and needs to be fixed.

In addition, based on Sashiko's review[1] and Johannes' confirmation[2], to
charge the right memcg, folio's memcg needs to be active during folio
split. Add that before adding __GFP_ACCOUNT.

There is no workingset convergence regression related to missing
__GFP_ACCOUNT in xas_split_alloc() and the impact to userspace should be
minor.

Both patches need be applied on top of the mapping_set_update() fix[3] to
avoid causing the same issue for uniform split path.

Link: https://sashiko.dev/#/patchset/20260727-add-gfp_account-to-xas_split_alloc-v1-1-9fae6bf64838%40nvidia.com?part=1 [1]
Link: https://lore.kernel.org/all/amtcBZ-_QVRgCd6b@cmpxchg.org/ [2]
Link: https://lore.kernel.org/all/20260725101419.3938406-1-matt@readmodwrite.com/ [3]

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Changes in v2:
1. added memcg switch code to __folio_split() to make __GFP_ACCOUNT charge
   to the right memcg.
2. removed RFC.
- Link to v1: https://lore.kernel.org/r/20260727-add-gfp_account-to-xas_split_alloc-v1-1-9fae6bf64838@nvidia.com

---
Zi Yan (2):
      mm/huge_memory: use folio's memcg inside __folio_split()
      xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()

 lib/xarray.c     |  3 +++
 mm/huge_memory.c | 20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)
---
base-commit: 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
change-id: 20260727-add-gfp_account-to-xas_split_alloc-83a1bc848b77

Best regards,
-- 
Yan, Zi


