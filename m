Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59335C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C366B007B; Wed,  5 Aug 2026 12:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334B66B0096; Wed,  5 Aug 2026 12:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223176B0098; Wed,  5 Aug 2026 12:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2F776B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:52:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AF55160477
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:52:50 +0000 (UTC)
X-FDA: 85067810100.11.467F849
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2C47C0002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:52:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N3BOD1gF;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.70 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785948767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5NBZ0p18ZUUQUw5PM+69x5Ctt0r8EdS52dDgl+VMzU=;
	b=U/jB33dtlsGZIvwf4dsPHRSqCFjFtJNY/RDAlB13f0ivRObNQRcpeE4sDD/HziNYHIaunc
	5lgUunx/c/5Cejt+Tz3Hos2Kz7ceg2VJia4sLfEd8HwAZ2/VK6izh7VINiYmUOy061risb
	okZLeMpQqKMs4pyZcL6ggjTs6Lanvrc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785948767;
	b=Jm2M3JUisSwJz+oW8C4hMG7c+f0S57e4A32fNTCommRG89STsN+w9m/doaScrDT0ddJubz
	4KRswVNf79IpWuK/R4X0BKn15WFW2QBEL+9rXHB2umoSPb+QO/C6Q4KQlEwdhNCHHTjyco
	Km/t4CWofHzD7ZEu6io2qn0qAIAVq3g=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N3BOD1gF;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.70 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XdLxJ0K4DL0PmS1u48vNiaXoxgVmq1gCLjc+Q0Y0sZMiDxZZLHKwdyk3JOD0xZkMe5whQhJzWaANS2+KvqhOgF/skGoTxp0Br5sSWPcAc3VhWgvKUIF3R69oSXx69xB4wB49quYCMrPMYYxjzNcrDPGkjeYWNHYqom1CWBbVQh12qGOLzQxgisQDhUp0uEFpKhaVeCaRMQtbwqYMpLOzzObTIZH3KJ9eS/UpkYe7f20lXneSp0KJRfcBUpxcu+6OUX2SgYuzlm+H2U7+JhUkZdvcCBBdZz16U0U2Da87aa636vvc2IfREHB4QI+b67tiqtuJDMwmbP11Ric4r3LBrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5NBZ0p18ZUUQUw5PM+69x5Ctt0r8EdS52dDgl+VMzU=;
 b=SoWB4UF5nyc5X9XW51D/RSOcIyACeRlJJxvIoChpsD2PwVBwqtzjIw7lgbW3+tZJPtZ1f1wuuex7AEYtj+upx5errmVbT3JoV/bMa/j7jV0X3BbRmVVYhF6yq/gPfexJcVKvsN01F1/h5DXZCEYJsnIAT9ERHQZ8qG42/4oyaQ+QuETPJUz18th09M1G+w3/MS5Iw6VAKV8gv8ttkOOlYd2pPY6q19RjF5cOybXh8H1H0kCZ3Li66UVO9qU86jLJlnvlKXfgfHt+77rfvhRFve92C+6Jwp8IQgHBba+qdBWmsmfTFWXcCMP38uuAt6kpy0fdygk+mjU/BCHGTfN2Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5NBZ0p18ZUUQUw5PM+69x5Ctt0r8EdS52dDgl+VMzU=;
 b=N3BOD1gF9c9ou7RuGC47S/27FNDtOltFh7+ziZrhfqmHfW2L4L3dk0WsRgk3fcYYEFUuOZx5pdRcNVfSdMzx0GurxqCKmIFADsIIbEnfIpSL1NOTg07F88vsLgteqR9lKnar91yXIY920gk8v2DRvL60xBpSjCvTWeC6v3v+oSY+Q+JSudqRmDxWoy1ZAVjSxZLj9NgQd3alMN0aBB/FOHOe4giRaigvEmo5U7LxIyozkXomc/n3nM4UqrZLejXclJ/M3VM2dyM2ItHWgZLaTQgokK/dITpmVPKddj4V/GvGElGmXXPf45rSP3+PUGxh7LKU4ZKkFnuvSE7T5LMlbQ==
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by DM6PR12MB4121.namprd12.prod.outlook.com (2603:10b6:5:220::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 16:52:42 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 16:52:42 +0000
Date: Wed, 5 Aug 2026 13:52:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <20260805165240.GR27883@nvidia.com>
References: <20260805055544.1568534-1-clg@redhat.com>
 <20260805121524.GM27883@nvidia.com>
 <anNkjl0qNHK47WTD@lucifer>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <anNkjl0qNHK47WTD@lucifer>
X-ClientProxiedBy: BN9PR03CA0414.namprd03.prod.outlook.com
 (2603:10b6:408:111::29) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|DM6PR12MB4121:EE_
X-MS-Office365-Filtering-Correlation-Id: 43dfbed6-4b30-46e9-b3e8-08def311f75f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|11063799006|56012099006|4143699003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	8oWdL/KpjkvXHd2fLfIVrnHscq/UKicDrCwbwVmNgchTxJ5r6qfBzjvs4NmZcnqhXp+/QT04ljWC7TXp6pB6KGr8s52nnwqDJ1gBDBpMJVl3OlQptARN6hzGnQ2PfFoXwltUubZ4XNXTHatxxMWEBQJo4gEnUQkLGgiv0uLltpXZ2qMGXWrfZ4hCxAYtoLgQbBjlhcgkz74z7ojeuGBw7/chtHvT2HMyOTrtI7hQkZtBtuWIH8worpFZ346uEV8g5c6TTSdv9Aedw0HuPK7tFUC5RCcr5u/Rb1KZBuNGZZ0y9so2R0GsJ3AanRX6dVVtsqTXLg7S0+Kc5/TIrMmy8kPa5uZq2aNknMmb3VOlT2r5UaThgzyVbpIIgINhNPN8j8GNu2SwlVcrKfm/ca6zTUaQ+rs/Nq4qXjpgcdZ+MMavMutfokqMKVZ5cOvSF7zyPYGWcLQI6B8hHexj7RZD1YXlHcXJdIgU6CITizacjeU+FiQ4Qf/V5Jx5oKPp8kSqv/Vyn8aFj711QO+34AdU/hfJ2Ai2AtcQy9R9yv9weTtWm6oRnOd5ffciLuSpsIizor5XIflaGB3yHprfQgk2UO9faWD6U7rlgvGqdeJrM9rSb0rq8WW4czPMyKUKughoH7t+S84b5Hmv2BEOQAh5+sRD96Xjli27q8I6jQ/13KM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHlleXMycW1VMmN2Mkh5V01rMDlRQ3g2V29uTlo1NVdKa1ZERzI1UHYxeStY?=
 =?utf-8?B?dk5uNE1YVEp5ZlAxQ01xOXVkMTQ3M2lVT25BTnJNNUNFNGFVeWpmS04yMWwv?=
 =?utf-8?B?RndsM2ZkNmtKVmRtZGdKTmtIVXIwMVppWGlRQ2ljVnVRbHpBTjZlRWQzQlh6?=
 =?utf-8?B?YlRkVTEveGtjUVpxQWtwTXFLdE5NU1k4WnhlbDU0U2U3YXNWYzVqSldiMldL?=
 =?utf-8?B?bTBkOHZsUjhoMXlvMlpIbnN3Wmg0a0JPTktORUlNYnhGalZWT0JJajVFczBE?=
 =?utf-8?B?TDYxRHNZdDZCTURDcVYwczU5K3JlVmlkMW12blY3M2FSYjBLUTJPVzRITVd6?=
 =?utf-8?B?SnVuNUhiblU3bCt1eDJ1SUM4eng1SElmOWF0VnVkQmdKdUNDWDVYN09Ec2hJ?=
 =?utf-8?B?RHBYVWpoRyt1aVV1TDRlRGpsVkFJRE40QXR4Ny9BSXBsdzlGS2g1b3VmWkd6?=
 =?utf-8?B?YVp4UUIydnByWERTWHRGckYzS1IwdVlmV0F3d3ltZis2MSttcHhhbUViQUQy?=
 =?utf-8?B?M2tLNlo3YW9vREVGK2pZbHQyQkJhampnQzV4K1BGdjhxZ2crYU9tc3hVemU0?=
 =?utf-8?B?a1luSFZUNHhXMlowZVI4TW1IVmpuTVVLaUlDbkhHa1dLV3dPRVhmcnRHU2Zr?=
 =?utf-8?B?QVRDMWdBWDFCb01HeWV2T09lcjUxeFRESFlHVnhiaTJMUTFpNTJJREZkZHB3?=
 =?utf-8?B?WjJPdEtJU2dqMDJTOVhQYmxkcjBVZTl3bkJ3amhHVHhpYmNZZkVWcmJ2dkFi?=
 =?utf-8?B?M2hzd2ljV09EejJpTythdXdpUXdxWUhGMHpoSG9xMklJVVZ5NlFSOGRqL3Jx?=
 =?utf-8?B?QlRCdk9jY2prNG5Kd1lsYzdZR3ZVNS92alZCMXA2TGxiUXl4N0RwZWdVc0F1?=
 =?utf-8?B?bGxDZnM3aXphM0VoSitZbVBjRndVcUFwZXpXZHJsUlVTcDd3VXF4VzhYMEhy?=
 =?utf-8?B?MEI4ckN1UnpIWTBqWjZXZElib2Eya1RxSkZxdmdYUXZndVpzVHJIbnZpbXBL?=
 =?utf-8?B?ZzVScC9rTkJpb24xYnI1MHBVc3owSmRiQU11b3FUWnJwa0Rid09UK3plVFZp?=
 =?utf-8?B?ZWJTZ0MwYk1vcG9IWFIvakpucUhpMHdvSlpGZWZNeE9CMkZyK2cvTVZTNS9B?=
 =?utf-8?B?MnBrR2RKbk4xK1ZZMUdtdW5ObjRnSGtValBZdUNHdk1PQlNrWXNDajZvZTFB?=
 =?utf-8?B?bGFxU3FhdTQveWtrTExvR0RRdS9ONjRrQWowYVZYSmpPQjEwSmNKcWJuQzkv?=
 =?utf-8?B?SG00dWkwNitnRWg1V0VleHlYMEduRld5b3pKQ3pzR2NmQm9oSGZ6QUJGQzNQ?=
 =?utf-8?B?Skd3TUhDaFdDMDNEMEFlcHJsTjZvcEdzMC9rR2pUL2JOL0syN010NHBMdENC?=
 =?utf-8?B?azRKT0piZnZBNHlHQUZDTGZFdHVFbDhWVXR4bXdZTHdvWjdLcU42WkZWSnRx?=
 =?utf-8?B?bWlTS3JUSy91VGlFYXFDV0xUcGswamxsQkZzblk4cmhvekJTSjNqb2czaWh5?=
 =?utf-8?B?aG81QWxBYTBIWC9BRFpYVDlCZlBDS3Ewb0NKejRxYm9XVGVhSG1WZTI5dmdZ?=
 =?utf-8?B?STQxMHZQdkF4eVUvYTQvcjhTc3R3OWFyTmk2aDd5ejJqRUFWMUNVVlB1cXhZ?=
 =?utf-8?B?c0x4UmR0bjZ2U1lLTEhHS2N2VER6cDgxb0lGckFsMmQ3NFdmOHMzcy9HYjVv?=
 =?utf-8?B?Tk1mTnVKLzJiU251MEIxWVBqd1VrRkxMUTVLYUE2N2dXR3FCeFRvb3pPSmdK?=
 =?utf-8?B?S25TR3FSRjk2SVowbDZnL3dxTXZqYjh4S2ljbjhBT3M1UXAxQ3JhQ2ZHNkI2?=
 =?utf-8?B?M2h1a01qVkZPQlhnRDQyZXZFNjZjajRTT1dBTnZQL1B0WmJIT0xydnZ3Q0tL?=
 =?utf-8?B?RWJ6T2ZtZVRGUnROUnJMVlQ1emlzMVJ6ZVhFUU5scEhBM0ZzT2NFRW9wcWdi?=
 =?utf-8?B?RUhFc21tb25KbGdMY0hsU1JudTlsamV1ZnFhMmZ4ejJYa0x6Z2Q0bVQ4MlVz?=
 =?utf-8?B?RmhqWGs0TU9HSWZ3N1ZzU2pBTElRZ2RwZGtyN3o0RVdheDFEUUxyKzlFdVZ2?=
 =?utf-8?B?cGc1Y3RlZWtHNzZyL2JkMG5pWmxLOGZTWko2a2hTQjVKaDhjZXcxcGpSelhm?=
 =?utf-8?B?d0FjVTRSMlpvb254eWx3b0c5emFya1QySFpLeUtpQml2OXRoS2x3RU1NZW1h?=
 =?utf-8?B?Wm1lejJaU1VoeVk5TFVCS3AyeXdFcDhuQ2g4ejZkYUpPSU1zMk5BOFNrWFQr?=
 =?utf-8?B?cU55MnE4L09yNkIzYW9acGZXMWJZdTU1MENIelE0QjBIM1dEcWdnMW56cjcr?=
 =?utf-8?B?a0JBdXNwOU9jUjdvT2szbFhwdjRxTU5mYUpqTjd2UzVNKys5VHR5UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43dfbed6-4b30-46e9-b3e8-08def311f75f
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 16:52:42.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiLnvLNLC/JUw/a4E3o6TIETpR8BnLdK4J9BAYFKgfutRqGofAfU4k5o6FbXPLWY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4121
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2C47C0002
X-Stat-Signature: 4nfpikma793b5kp9h4iz7phn1x8msi64
X-Rspam-User: 
X-HE-Tag: 1785948767-497063
X-HE-Meta: U2FsdGVkX1/hvAvcD/Ozd3kcDhetYRiwaIBdT4A1bNZEBVIX3rqEv52S/hZnLUwOr5miKlARhu2sD7Eud5q2Ii7O7cbqpw4iUFnW3McX9+wcjj57jAeJE0uJ+PIttdORXBlTRVDe4wSk1B8FdynWP4ZK9zWN6+yXA05vyfmShlLyPBc/b05medh2KnCUHgmLegnQ73rD+c0T6lV+J15WE/zahq9/F92LACx1isL9QdfupbBKlNakpQ3B4EJ75lciQPgXPvIqLMelu+tXgsxG0ywUe3uR0ue1J+z8tl60jsDNn9IxThRrUzolwoeW51gniP+Akfh7Xse/8RJxX3PUYuSYdaNs3mDo0aRSXVcvtAy1B28nP2nELXxzKVvt3RRDw4EiVFaZoQ8XcGtBaecdCNZr2D7FDx1lg7Il7wMpV24k5dUL6EoPwAvn9hhBdV+jLQyYVkjSeNL5rdNNHDEEP0ObEERTk36EtkpfxiwYH0DIuhvLSvmNv3EXygvpPJGyv9pV1VAb3RsPgzbk7rdfh8mCM7ipTDDSkvkCu9hiTlbVFwIPHtBJh5PSJ5FSyiJcP/m4SKAk4L7jw6Eltfj55N87PhkgP/slgTC/TAKR6h2Eyw8+GeBCJEjyYWnwELG/01eYDhZNuPZTx7RNGt2w+jfmuvbe8mdDRpgQWJ2NsHpaMXrdR1OJYb5XKDixSPWfnmCbpbgppJRQ5Zl0Vto/hnpII00SZRWovQjrjVwAqRYhLxegJJaZQM688rrV8tShbjPUX79Sl3QnP1+R7g44e/4YX6DQUwUWWO/I6SeV/N8fK8mB/npHlcGln3o8BcFLCw+VsV1r3/HGNzSSira8D8i5Vg8S+NWlWkpEx5xfZCganmwITot8qh0Azy5Nz9TyqnxuOZF4u/U72APVaYddh0QWysY7SLsRtDebf5FSXZbAvOh5M0IO6aYqdZfgncJVTgygH4NL3RCQWLr8ja5
 pE1nu/9A
 89siTgXczGmt/cXH2k0PMAaUIQjKMAjheKunYc/lA2XRh8cygXReqBBCgv64syIPPuroeeMoBZw/uucN78jhqqvg3DeqB6sAuFE+wGbYaf8xzCBSEiOMXvnPBtZNhgk2bgGnS7pj1oYcrneblE3ASc2UdMT8sHjdqYss9Ci+xcRcDaHaWqBxJhXDj41pva8ijKPy3cbmboJCQs/M36k4tGFRsae4U6JirY9tLKEzWRZYtnhzV/K5iLo9z6NZGLcxtVTmrSnCI7yMS2zBYPfS7ABCYcKeozLo4hCJo9Phzv779jJXQxWQZnqycDOgAmknFkRtLmjQUNXsqTWtNjFFabJFFQgKzLKjocXCN+605Y0pWtgiZk/e7lItwSd+9uI8AGXw48AsvIrSSqoro4ufyEbLIgUdnzGMLKCugItsWbcXJzZI+NznxxI+ixn/K1zSd3yFFGHnehQK+pV6n5VRjYAyCE1CrwBtGxBlL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 05:29:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 05, 2026 at 09:15:24AM -0300, Jason Gunthorpe wrote:
> > On Wed, Aug 05, 2026 at 07:55:40AM +0200, Cédric Le Goater wrote:
> >
> > > The result: each 256 GB BAR is mapped at 4 KiB granularity -- 67 million
> > > page faults per GPU instead of a few thousand PMD/PUD faults. On hosts
> > > with 8 GPUs (2 TB of BAR space), this causes VM boot times to degrade
> > > severely, with 99.98% of CPU time spent in the VFIO BAR mapping path.
> >
> > Broadly upstream we expect people to use iommufd and dmabuf for these
> > configurations to avoid all this nonsense overhead. :\
> 
> Point taken on that :) but I think it's generally reasonable in line with the
> huge PFN map changes to do something like I suggested.

Yeah, for cases like this working with pure PFNs from some non-folio
source the size should be entirely delegated to the driver, and driver
should always have the opportunity to place a maximally sized PTE.

It is definately wrong to intermix it with any THP logic. DAX isn't a
special case, it was just the first place to partially implement
something that looks like this.

Jason

