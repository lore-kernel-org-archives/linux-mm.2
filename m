Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCA7C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6F16B009C; Wed, 30 Jul 2025 05:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967AB6B00A1; Wed, 30 Jul 2025 05:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808DB6B00A2; Wed, 30 Jul 2025 05:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68F206B009C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:23:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28618585A0
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:23:05 +0000 (UTC)
X-FDA: 83720391930.05.059476A
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2AFFC40006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:23:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jZAV7r0O;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.237.85 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7YHUaNEYCFCyzmgllvxKGRRSWIMyNleQOYu5DzM9zU=;
	b=HQyfUBso2GwPRuZv4cl3hhRcpsx20OxkygrqzTqaZ6f/quWuKNqjYAvlfvJARCVtBCPV9O
	Q2dlTEpsNqjczch+99O7nmfYY6k9ZKY5sTT4crC2NWWGn1/O+z6dtS/e474nC0YM7up9Ak
	+ss2SedKVRW6y0MtEYxDswiuGOaoBUo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753867382; a=rsa-sha256;
	cv=pass;
	b=W4kfvRSIU67DhVSsypH6jb65I9h/mAPy8Au1cEHn/+oLMlfHmehLxCQNWfMyGB9HqmbQae
	aWYr/GxjwQhZ3bVb7rkLKwOtIcoWxRb2Xtac7Qzf9j30sL6JtQLeF8CZzUmj5TB7UQpCGJ
	KYRVzTd3S7xmxXsCBN/ei37ztUdVAsw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jZAV7r0O;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf01.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.237.85 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KTSqrnNyGcH1iEOxFP172TFKux6lJy/kOCn8rh6c5Nj08oZ+VLfEFcmILZ52pXXJeqyH+9U5K2P8CV5j/lnmyYG1Zq/2cxw+n8VzSKk7Jr0tiPNgQ/lTIEgkvsn4mzDj7ishdmEdRFRvME0Ipib+1OmZ6h1Zp0PVfLSLbpfGaXSTsFYClt3phK2anOTNGTL8TAhFr7cO6cYtx+dsJ3p+zRlJDNjpPUnRUyTIUen61AtRd4jwRi+hVJ4jEq9UY7hoTaITJxzgK5kDDwkOEGmdyQcw3kBta2r7wRQR/o9pH15Rw3bF9U74qoYS5UC1tLxtfUdP9vecogeUF+MSMQS8vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7YHUaNEYCFCyzmgllvxKGRRSWIMyNleQOYu5DzM9zU=;
 b=Hf7wtrFwPUaWtPBOrfX0TLh6gby6TY4OHnv1mCNbmlOSf9UqCBemPPoWBFyEocDUMfrPO9W+xoziZakqfjtYHxathkgQVZbvj682wZAHGnuhfvGx7IDAFWbw2f2em3kKLsiPHrQWTq3tgzIi6rQI2NKkLy8Lx9lg6b6UVmnk2rfYxP95QuGXItadxfcUjOeUOyAz6ny3NmRRwwj+jJJo7ZFiy6YCuNFLsleXuMRo329aDZDhSATvhSzM8RUOv3dIVOGVcD89rKE1iWXlnOhU6AvwwKACf1KCbrQe0MNHJIx18whyEukF5dYtstr7YBM2+hg1iIF57VzXTD86VZhCNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7YHUaNEYCFCyzmgllvxKGRRSWIMyNleQOYu5DzM9zU=;
 b=jZAV7r0OHlrKC+dOeVU+rrd7lbMUlWe7grzetib9bxLZPQ7h/0jZg9/0OnP8V2jMY1EZant4d1e488bR8ELWojqDbAX61EZS2xPMo7Bkt4gs5Sb6o6G81KVJfdyTpnrXoTC/4gS3WiZzGD3AelQnjUSWlXzPFmTABlt+Hfk8Zqfq+HjdF8JOwGf5fn5Y2987UsMy9UsHkrLX2ixzpqCFqC1SdM0Os+qgV6Tu+w/+lRXkCSrpmLeu5HpSm0VcbCHK/OWjTw5Nd9WukuAYQoHHPmok+PxLTRHGsSSKhxX6jTUZbFdKMLDHCus/OIhAK5LuTyO/uvqb0486zoNoKGdJfA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 09:22:10 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 09:22:10 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v2 06/11] mm/memremap: add folio_split support
Date: Wed, 30 Jul 2025 19:21:34 +1000
Message-ID: <20250730092139.3890844-7-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730092139.3890844-1-balbirs@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0060.namprd13.prod.outlook.com
 (2603:10b6:806:22::35) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c32615c-9b9b-4d71-4e00-08ddcf4a8fb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTRJRUVMdkZGdnVjVzJabytxbDlPRFRtTEZIcWdzb1FLdFo5SHNUYVJuQmxj?=
 =?utf-8?B?WStiWGt1QnRuUXVCTDdQWGxJSWJSUDN2OGhzV0lsNTlueGpxWlNYbFdGWGhH?=
 =?utf-8?B?RTNUMDc4WlRUU2MrY2MrWFovWTd6STMvUWh1SkVac0QzQlc5cTNKQ3VGM3Zx?=
 =?utf-8?B?bWhJOGUyMThDbjdpOWR2M2ZyenB4NGVlMWFwbUZFS2RGNk9MUlcxOTY1ZkpH?=
 =?utf-8?B?RG40ZTE3ckVBT3pyV2t6SVcrMUVyZkJVK3FaSStiNElOUytrTjRVenFqSXQ2?=
 =?utf-8?B?RWN3dlZzWm5zK0lYTXh5MkJQWnpUYy90NG14czY3Mk9aL3p3WUNkV1IrR01h?=
 =?utf-8?B?dkdZcHo4K0dPSFBXYXJ5cHU4Rzk0ZnBLMmZiSE0veW5xVDkxY2lxNGpWbVlB?=
 =?utf-8?B?LzBkbzY0WjlRTmNGY0doTVR2MXlhbWUzakxpT3QxdzhkMERhS0ExclpVT29w?=
 =?utf-8?B?ZmhCYzBpOHNPSDFhUThDdWw4VzUvQ3pMMFRFRTA1RlFBKzhDajhTWi8vMnFI?=
 =?utf-8?B?MHBiM0VnRmw0NlY5U3FkNTI4VXNEaXVqeDFRYWIrYjY3S2dHZ1NoMDRLL3NK?=
 =?utf-8?B?akFDYmZkU29KdkMvelFBaXI1VHJJWEVkR0VMVmZST080UFZqbVpEQTcweGtN?=
 =?utf-8?B?NzdZUDlkL2FPK05KVXBTLy9KaTc5VUJlOERVRUhRNEExaUNoZTdBRHBKZXUy?=
 =?utf-8?B?REExdEpJaGlYRW94VGpSYTJxZEZGYkdvM1hpam9pNWF4ZHdqQnljVEEwcGV4?=
 =?utf-8?B?eCs0cHQyUnlDalhmN0pRaGg2NmFudTdyUFFlWUR4M21hV3d3NEtTUVhTaC9Z?=
 =?utf-8?B?eXVtaU9jOGJ1V1cwZGlVYUNVOUdrMWJkUEIrNnFQYjlkYm1TVEFKbjkzSjh6?=
 =?utf-8?B?R3FrVWtCTW1nL3pKUjlPSk1ZS2RTT2JPNjcyTDhZQzNSNjQ5SGh5b2tZV3V3?=
 =?utf-8?B?MTh1bnhPTTVDYXN4WDZ2a09sZDJaZloyd1ZWL1BrcnltTCtNd21qcDFDTnpE?=
 =?utf-8?B?TmdTdWVrMjlEN2NyT0I5TUVhSmN4OGdZWjhxRUFPbVRpYlk0aDlCT0FTL0xU?=
 =?utf-8?B?aXUva2tsNE9HYmNZd3loTlRuR2QyeHVaU0RmTitUL0NoZjVUaEhSTG1xSVZG?=
 =?utf-8?B?ZFVhbGtSUERVYjk0dDZwWFpDT09HM2g2OWxkbWJGNEplT20yVmk2RHUvRzli?=
 =?utf-8?B?dEZDN0V1aS9SVmplT2UwZHVic2d5cjliMzhocjhrREU3YWlMTFBiVlVZZ3o3?=
 =?utf-8?B?STVGQWp6Z280RXZQc0xFdVF3SGFLUUtkZGNodzBoTmRBRzY4S29sYWp2M09G?=
 =?utf-8?B?ZExlV3E5aXFHTjkyYjJSc0ZId2NwNXdyaFVrNGRWNVNsNEJiOGZhZmU0OU1s?=
 =?utf-8?B?eEUwTXJJWHJDR3d2VW45TTFhUDdMMkorYzNHKzJZMmlmZklFNGZ0alN4ZHZ0?=
 =?utf-8?B?b2kyMWpEV0lOSEExKy9XQ2N3Yit4WWZWc1E3VXJZalV0K0hQN24wS2Y3aldz?=
 =?utf-8?B?R1Voemc3UUhQNTNDVDFhVzNCVWd1Z3hTeVhDaXB1eGhxYXNtanFKZjJzU0Zv?=
 =?utf-8?B?RkJ0TXdPNGhxY29kN1JsZTRyNGIzemd6QUhFRTlqNU51eWZoK1JIZHYvekxl?=
 =?utf-8?B?UTVadm55SjJRRDl2WnRMU25UZzczcUlpQTA2RE8rMzdhQmNWSzFjYTh5U3Zh?=
 =?utf-8?B?Z0xRS2I5dy85MGdJVDRTRVJEaW50WWl3Zkc3M1JpcEhwVmxaSU5RRlJabkc1?=
 =?utf-8?B?cmVYSzZjOHZPa1QwcUU5emlYZEQ5NUh3SGxPQ1Y4UGhkMmNZK0pqSm0raE4w?=
 =?utf-8?B?MHp4R2RIRWZ0a1R2RnZ6N0h4NmE5c3N1cDV3bTlqNzl2UWRJa2VRNGJVQk1Y?=
 =?utf-8?B?Z0R1NFVCeklZUGNvOFJ1SVpNQkNjM3pxMzFMT2Z1QmdHSkhkeFNXS2VWRk1I?=
 =?utf-8?Q?7GydqqQANb0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGxMYXc1Z3c5K1hBRVFWVW1sNFFhN281WVZzc3ZacHBaZDkvUW5QL2ppcWRs?=
 =?utf-8?B?Y0J3RnBOZWF3bHJod1hsaWZFaVoySFkyQVZkMFNuZVZISVlYK2JZb0hFSXMr?=
 =?utf-8?B?cC9oWm82eis1d2JBSmtCcVZYc3RURjhjdllXM2FnWWtmblg1TFl1VGVLQlU4?=
 =?utf-8?B?TkIxbmIzTkRURnc5ZUVJQ3pJNm16S2kzdmU0VGIyYldjYXhTU2ZHV2s2YWto?=
 =?utf-8?B?V1JSSXBicVQyajlJQStTSHJHMXRsSnpCcklwS3RwdkpDQloySjlPVGVJZ0g2?=
 =?utf-8?B?SzR5cUpLUG1TSVNMcU9xZjJDUTk2L0lPalpqS2xjK1NaYkNPaCtDKy96ZmhC?=
 =?utf-8?B?VmRBcm5zbGZBcFIzNmxGM2RJazNMNElLam40K2FzZno1SHZLZVFOUkNjWUxQ?=
 =?utf-8?B?WkZ1RWlEK1BZd0l2Ny9QTHlxYWVLdVd5c2JXM1BZci85d3pyK1NlN3FoNXYx?=
 =?utf-8?B?aDBSOU80Z3BzWmJIekh1eUxkUmcxMXA3R08yRHhTWW8vV3hjbThCblJaeW1O?=
 =?utf-8?B?K0hrWVd3VjR0cHpYdU10OXZaLzhSeDNQZlVnaWtoQy9HdkxxWDN0K2dGQzVx?=
 =?utf-8?B?SFRkZ3JuRGdvd21BMG5IaDczMHZJUDQ0c3FQV3BZTW0yVm5pa1BZd2ZPbGln?=
 =?utf-8?B?UXh2anZQQnYyeERUZzRsT1JIQjJqaVpvenJ4Qnd3VDBiV2E5cjlZU1ZZbWRY?=
 =?utf-8?B?aTFzZFN5UE9rVlNJOFBpZDRCazRvNjRIa3ZtVXZuUjE2WTRsMGVsRVEyOWo2?=
 =?utf-8?B?WUJvSWsveUtFYVpJTmxLR2plWWMxYVYyK3FkUURtQUhMR1VKUkNwY2tvQ3NE?=
 =?utf-8?B?YTE1VklnOG10S0l2RDNZR0toOE1NdVRaazIyVWg0SUdpRnliRENwQmhYVThx?=
 =?utf-8?B?V1dVazNTNlNwT0tqOTNhSVdrdUM1RFVIS25jZXdpVnNjU050cHV0QmVCTnFB?=
 =?utf-8?B?aEFPeG0vVnJGL3ZRQ3Nqc1RDVDFKb2Q1SHVjWkxYMzg4cWwrbUhCWW9xb0NH?=
 =?utf-8?B?Nk9GNFRtaXNIejQwaWVDZUM2NWFRWklYb3loY2hrN1JvSWVHS0E3TXQ4dkN4?=
 =?utf-8?B?VGlMRGU5OEpXRjQ4a1dJU3MwVlJMRGl3a3VObGFZaGdGemk3RlphRXVnUGJU?=
 =?utf-8?B?K3ZUMHRWTG50eUdWZVB6c2NiWTNHcktYc1BiQ3JjZmx4MVdFVzJXOTdEK05X?=
 =?utf-8?B?ZlFyQ0c5ZUhXSStXajNNeU1yMFVZaXdtd3hQeUsvU29QcXZHZFUvQkpUQkRM?=
 =?utf-8?B?UUdOMGRZUCtRdE81NmNXdTVWeWdVbkFRbFg5TlRqOHNUYktXa2o4eDlxNU1U?=
 =?utf-8?B?UThxS0RQckZBYzMzL2hjR09GaE11VmlWUXJkZzVsL1E5UXBuMnl6eVJEZThr?=
 =?utf-8?B?ZDhHa3JRalY0NFBoMUlQZHhzYmhuc2srZEZDZVUyVXE4bFVYR2Rsd2pWQmJ3?=
 =?utf-8?B?SDkxSGRUWk14emNXem14UDlLV0tNTVkxa3VjV3pVMVFBQkc5V3NhWGZ2azhL?=
 =?utf-8?B?QzNuYlVYVGxJVGo3RGFJQ1FEdmNIRlVTY0ttZ2ZIWEhHSDdQZGR6ZXVNdDBZ?=
 =?utf-8?B?UmprcUprejVqbUhaKzNPc2VhMno3QkZqVkE0WENZUVpCbi9sL3BDMUFLcFhh?=
 =?utf-8?B?d2VwMWdCT0M3Ym9uK25zc0xHRXdGTnJSUXNyWkpGbzM2bUVTZ051WXdNMHFz?=
 =?utf-8?B?TGwxeHBEbkcvYnY1WkFncjg2QWlMbGxpaFhJQXovUDJzZlpONGlKd3QvMHlu?=
 =?utf-8?B?QWZzckZHTWtCdGlObnlMN0NtYnlqM2xZQjE2Z2RSRXp0cW1jODFPMEVDTWdT?=
 =?utf-8?B?SjVYNXgzeit3R2c5cTdxNExBVUl6Z3hRQk5iTDdTRURHMmhlN0pUMi9iREZM?=
 =?utf-8?B?bjZQakdOdnFFckJVWlZUelFlSS9RZXVLd0IrTHp6SXAzb280UkJLYWpMQlhs?=
 =?utf-8?B?T0hvT2UycndRaTB0M0N6akprUkRGMzFsaCtwMXY0Q0ZDWFMvcllXcjdFWXRM?=
 =?utf-8?B?OVY3d0o1clhwWmhKRjBiVXkyeXlaeko2ZFdKSGRja2E0UmtuYjFZRnV3VVB5?=
 =?utf-8?B?UEhCam8ySWtRV3BGR3VLSVNJdVdxYXNBdVJoVTNPbUFCcFBzN2U2cFBvcmNp?=
 =?utf-8?Q?MpgGofu/9fpfvmcS0FvNnroVR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c32615c-9b9b-4d71-4e00-08ddcf4a8fb3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 09:22:10.3079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QT68h/jtWOOIR6bAKv9Kx9Q8X/jppC2YbWpG5ki8zZG78IOShUiFdG06+ipyfdbF4qyBqT3vwPhDcNAeie5kKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Stat-Signature: r4xdepbbukfxzh11f7ysf81z5pdrnwyu
X-Rspamd-Queue-Id: 2AFFC40006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753867381-647093
X-HE-Meta: U2FsdGVkX1/JYi2j3TtE4nYzHP8Jzxz7dhAmD14BgEgZ1HsPWoL2aay5SBdqpGLUoF7Lw1BhthAYX93D9LjZZXKXz34pyrWMMvjDJyKAbZdGa8WAmIcF2ahGapeGoR1f/e7ek26wUmCJdq3QwCW5jQjrPRw/gMWqjMdSgR7+x4CQm/UrobjpEm/n2bPTEURA4WgVYcJ/3Tta1y6nm0FmMufQeSMIbdmMPxKQXjCX+UbQ0p6sR4MTCFEkZssN0GMbc+GL5EVro+7t263UTJyyoQRVltHA8U6UjP4r1yLmWTE4KP5s3pz+y+B0sBQUdVSXxBO2yrg/obsRpvgmJHRKFNnU1T5bXkaiml0qaS4PXalp+FwIafr0XmFVteJt6Tnqt0hJQScKW9OaIm2FZwfzMevZfWs+UT/TJimqK3DN0ScFhcPYSohgg73JR1LDsOo2Qb3gFvzScpfgn68OuZqNNNA3EUXddvdSfVZs39G7f7gxhsMbtZIO4xStCgEJ2z93s9k2azsBJVmgcHt9CC3Mrh/F1ZcSZlfeTsGlPfMz5DmyR8HvgyCMswl4CSTxXcyqrviDbsn6DYSrMPAMEcMWoxDb5aNIUZmfS+uUQjhy7rOWo8uqcIpRkkq2eoMVQQfCfKvk9oS5uHnjJFog2hrpSpaqW/pbnUAdwi4ScXdfzxUEi06MAvdPlZKoacJ9bRzV/jiaefLrIojsRPjmqpSdLXEJzuP7s9qr7EMuzEoeFCFCYcDfAzEGEBs4+3gceX9OggT62rMMdj3Y2ZBa0rv/VHrfPs7J/9mL9eLWdgYCzF65z4JzwLZupXQ1FUV7gPbhmCIW1NfezRIDU44SVdOv/gU7NKc00kHw7Ia5uKPH5snIBeBe+C7lRbmNda4HPvp4WA4Z+v5/LPAstP4arvi9vxCikVWjHAm0nMxyCgf2eQdVqk/UJH1vzP2KQdZV/DxLMq7RXxqws8enFa0Lsge
 Y1Nj0Z+n
 MKKKuNniLqovraJEdf5CKDrWMchTx9TgbJfk3lAUmWUPDw5LYV+ulhRNNEMGJxhsCJ1h3HGGUnnQBEBE+oHdr2LZNtZoT2ySRykITjMmuisQ6vss9UUT4dbC01ErOXP25wSYikM5lHlLo+xQpnIPwkxNRaFZI2lX5q3+TtB64GeBAfpnh92SPNNUYrkWuA3GYeSjer/zclofKiJDu2zeGa+AHSurzs1ctXBOJH9uO83RekGPcxVpW9uTdV31iXNn29ngWpYeT0jAFno3EaEv1KucCrLmOXhpVJCist72/+lccIqC/Exzb/Qmf+86zKW3vh/qk05ey5B8aeNe2GuNU8FGT6kFMETVkUShdsb8ZV137iBXa0i3LNNeruOrBpsNI5GnyiP8TtHdT01tDMBdgGKatHhMuFWdUtRYL4Nq2QCL7ANpiOmXIbWKMqRjSHSsNWfIJM5ICU8YUx0hfKzYlZ/XxiANYX+xPB2amx6gUupWlu1NaXg3LpaMoohVhLoUserDLVFmQT44oDxe4d3bmSxTxCyc8I3y98WRRgIsFOXbNnkhnqv1j4P/ppHW4uiOpwLK9TQIoA5SeUXogKxDcul9W76iCpY3/kBf991TblUjreF7EGjLH/kkXulGp5EfxI6s7q14kAB+2heU9cLFfnN2iyZDNmVfrYSHp6M0EEdP42LDV/hD23r9gR1zzT4GB+AfSho0fFKF7H/ffXbrch3FkdMv2hNId/U0UII4vpbwG93nXQr4U8GYdeOU3M/6cxCe8VRJyqMJLClpkMgDW/1n3ksGLtBico1KPwvPtvNRcW+SMY/SeqvuSw2LzO3EzbUaiS6DqPPrk7cv6R+V8cZsRlrHndqrHDeWL2w5d0sv+yJ475OAPhwcdiVjT0w6vUks2yLELJU32U0I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a zone device page is split (via huge pmd folio split). The
driver callback for folio_split is invoked to let the device driver
know that the folio size has been split into a smaller order.

The HMM test driver has been updated to handle the split, since the
test driver uses backing pages, it requires a mechanism of reorganizing
the backing pages (backing pages are used to create a mirror device)
again into the right sized order pages. This is supported by exporting
prep_compound_page().

Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/memremap.h | 29 +++++++++++++++++++++++++++++
 include/linux/mm.h       |  1 +
 lib/test_hmm.c           | 35 +++++++++++++++++++++++++++++++++++
 mm/huge_memory.c         |  9 ++++++++-
 4 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 0c5141a7d58c..20f4b5ebbc93 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -100,6 +100,13 @@ struct dev_pagemap_ops {
 	 */
 	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
 			      unsigned long nr_pages, int mf_flags);
+
+	/*
+	 * Used for private (un-addressable) device memory only.
+	 * This callback is used when a folio is split into
+	 * a smaller folio
+	 */
+	void (*folio_split)(struct folio *head, struct folio *tail);
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
@@ -229,6 +236,23 @@ static inline void zone_device_page_init(struct page *page)
 	zone_device_folio_init(folio, 0);
 }
 
+static inline void zone_device_private_split_cb(struct folio *original_folio,
+						struct folio *new_folio)
+{
+	if (folio_is_device_private(original_folio)) {
+		if (!original_folio->pgmap->ops->folio_split) {
+			if (new_folio) {
+				new_folio->pgmap = original_folio->pgmap;
+				new_folio->page.mapping =
+					original_folio->page.mapping;
+			}
+		} else {
+			original_folio->pgmap->ops->folio_split(original_folio,
+								 new_folio);
+		}
+	}
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
@@ -263,6 +287,11 @@ static inline unsigned long memremap_compat_align(void)
 {
 	return PAGE_SIZE;
 }
+
+static inline void zone_device_private_split_cb(struct folio *original_folio,
+						struct folio *new_folio)
+{
+}
 #endif /* CONFIG_ZONE_DEVICE */
 
 static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8e3a4c5b78ff..d0ecf8386dd9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1183,6 +1183,7 @@ static inline struct folio *virt_to_folio(const void *x)
 void __folio_put(struct folio *folio);
 
 void split_page(struct page *page, unsigned int order);
+void prep_compound_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
 
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 4850f9026694..a8d0d24b4b7a 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1653,9 +1653,44 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	return ret;
 }
 
+static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
+{
+	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
+	struct page *rpage_tail;
+	struct folio *rfolio;
+	unsigned long offset = 0;
+
+	if (!rpage) {
+		tail->page.zone_device_data = NULL;
+		return;
+	}
+
+	rfolio = page_folio(rpage);
+
+	if (tail == NULL) {
+		folio_reset_order(rfolio);
+		rfolio->mapping = NULL;
+		folio_set_count(rfolio, 1);
+		return;
+	}
+
+	offset = folio_pfn(tail) - folio_pfn(head);
+
+	rpage_tail = folio_page(rfolio, offset);
+	tail->page.zone_device_data = rpage_tail;
+	rpage_tail->zone_device_data = rpage->zone_device_data;
+	clear_compound_head(rpage_tail);
+	rpage_tail->mapping = NULL;
+
+	folio_page(tail, 0)->mapping = folio_page(head, 0)->mapping;
+	tail->pgmap = head->pgmap;
+	folio_set_count(page_folio(rpage_tail), 1);
+}
+
 static const struct dev_pagemap_ops dmirror_devmem_ops = {
 	.page_free	= dmirror_devmem_free,
 	.migrate_to_ram	= dmirror_devmem_fault,
+	.folio_split	= dmirror_devmem_folio_split,
 };
 
 static int dmirror_device_init(struct dmirror_device *mdevice, int id)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 713dd433d352..75b368e7e33f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2955,9 +2955,16 @@ int split_device_private_folio(struct folio *folio)
 	VM_WARN_ON(ret);
 	for (new_folio = folio_next(folio); new_folio != end_folio;
 					new_folio = folio_next(new_folio)) {
+		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
 								new_folio));
 	}
+
+	/*
+	 * Mark the end of the folio split for device private THP
+	 * split
+	 */
+	zone_device_private_split_cb(folio, NULL);
 	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
 	return ret;
 }
@@ -3979,7 +3986,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
 					     mapping, uniform_split);
-
 		/*
 		 * Unfreeze after-split folios and put them back to the right
 		 * list. @folio should be kept frozon until page cache
@@ -4030,6 +4036,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			__filemap_remove_folio(new_folio, NULL);
 			folio_put_refs(new_folio, nr_pages);
 		}
+
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
-- 
2.50.1


