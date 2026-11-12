Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0951360A2602
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DYrhNfoM
Received: by kanga.kvack.org (Postfix)
	id D6B0A6B05B2; Thu, 12 Nov 2026 11:33:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B5D6B05B3; Thu, 12 Nov 2026 11:33:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A656B05B4; Thu, 12 Nov 2026 11:33:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83D756B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:33:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD35D80620
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:33:29 +0000 (UTC)
X-FDA: 85427012538.24.7A1124E
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010020.outbound.protection.outlook.com [52.101.56.20])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0A67740012
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:33:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DYrhNfoM;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794501207;
	b=rF+rV99otENl2IU/XO0LRJR9H+Jf9wEmRJLhEEm414xvgkNj+9FmuFoeN+27gsGoyn/PVR
	FJj6ewqgtP+2qo0u+1atFnt5xGl5uOYUEf1jOFjgygJWVGwjygqQnq9+F4euQe+G3aaiXn
	C7blNxeKNsHoWW03ypK2/pjEtdn/XHU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DYrhNfoM;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2KYMCk5KXldDP8Pn2ubwgmOHu9jpVvXGouBmsN2LCA=;
	b=N/fu4Z8VACAbITsJM1UX2Aep34ln/0oEdlnaNkBC56nZuK4IHlbTmNdNXIPA7U0ikPlm5k
	dGsL0gJCNJVau3bKoh6AL6slTf69aI1oEyGBO2J5VnZ3cZPnKNUwS8GGYCLaK5S05oZJAo
	O25WarPUKtcqs6VOoDSIumPze6hLeg0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IgV5CyFnl6OsuxAuoa+AdmgaTPTkaNSrRRa5aA6KywU1+C7IuaKoC5eaYMVTOoJEWxEyx7vPz+RXrzXUjaDeodNAvnXJrCaSj9pdcBXWMEah9hiG9OAjSJiTLVXF1EhYS4OO1ozfMGo39G+siNYkV7dYqYss9v9t+4m8z+XhsMQPPCcJUsPO8p3IggPBakGbKjbDy/wuzObItohCoIwqsEMhaXID8+srfo5avmd3UbTIGLzTssDi8H92YnyCg4mVRut5KXVsJQxSNgOtkogqswDon0rhYUyfuFEOY7+TZ5/uR2YSaIrC4Jyohib6Vf4lj2y2xwG453pRGZt6wb7vtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2KYMCk5KXldDP8Pn2ubwgmOHu9jpVvXGouBmsN2LCA=;
 b=mUwCkqPUmWXRNFAwSlQasdGthT1DEDh2ZxAMHWS+i2t4DhtPFWJWaL6q37YEtyuR4HGrDsPJYYpbbmsP/iR6eWkRK6yXhu9LqTtPJaGDKFlTQ8TrVc//tJ68szOLSSkuBUVmGWrtP6kLAtTyt7Aqr71vZeRxNq4++T73LIt0vlRMRT8UG6mgd/ICYVEWdlzKdKDSpv6B8202f0FgmQmNjznnCLPNZ4UmXHGxAmwaYfRMkyYdG0ZD1J4TwRAng6Nj30+AyRUrR+ldA3mBIk7RDRYd6W5ii2tRhxVUE4eUM+dQqOqcRx6/lFwkSf/Xiy9CqwSr+i35/PDYopuRf4XMFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2KYMCk5KXldDP8Pn2ubwgmOHu9jpVvXGouBmsN2LCA=;
 b=DYrhNfoMX4UxoZD5LGPLrMlI1jdnMTnQ+l5Z7rk290ThVwAOaLuCxEyrt+/hoNhNv0YBWpiUP8G4aeXySVdvqN8tOiTBdUIAyfPo5vqTdg4E7SnrYEmCZFhVdhwQsQReyAkcbD01Ip1gmf+i3jdKMchGI3pWrr/cZuggaJ9ItpOvIjT/8h40I3DkVMRIGBJRyaPwXrRahQp+o9N9y9hdoLlA5LdyqJBRbMqodWPe9/rD4k7A6vWOIe/oWDJ4oPtesPn9L9TEH9bDsIaGSVufoD+G3qLw2RZphD9iA8Q3DAdvjFWHWxO14NK93vVPMMBaCxCbXXOKJhrylAYWE5VNuw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 12 Nov
 2026 16:33:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Thu, 12 Nov 2026
 16:33:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
Date: Thu, 12 Nov 2026 11:33:17 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <3A5BEC5A-BAFA-4541-8ACA-43E57C7DBCFD@nvidia.com>
In-Reply-To: <avXoJSGh5xjGFgod@raptor>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor> <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
 <avXoJSGh5xjGFgod@raptor>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0391.namprd03.prod.outlook.com
 (2603:10b6:408:111::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB4399:EE_
X-MS-Office365-Filtering-Correlation-Id: 09256116-69b4-46e0-69e2-08df40daa9ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|10067099003|4143699003|11063799006|56012099006|261026121527099003|261022105027099003|261026140227099003|261028144727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NnDtCHCpEicAV3xc0o49gyGRL+w5WKfVCQfSSKc4+rjCbznun6rk4kjwgNxkXJwadM+eIG/LrmHdS+VS4uuV3eYyopBM9JoQpnzx9PSOIy2jhYwEq8SdicuJuAphpYEeGj88vi69y9slbyXriPSFkqnjxzLxlcVcDHSCma75/XKeVx4CotGtcWUE9DYh2l9QO2kACCT3U7wDsyrBo8Brc1CpIoyMn8FDaPjsin4lpmN2uiItvz6kiciNHmy3vzbcRpbHPYg2E1klxXWqiMjwSo9w2omms/ootA+gwnsONptB6Bc7tc/bhnG36zYLEOdRuGCGw2XmpQbSUA/LqP+6tazqL6xn5zT5ZTkD1+u7KsOtJHhYF8bgKtNmeDtuiZHXYXeGkBViYFEvtyxdYTt7ZKm9nw9g4nYRP6I2eWFK6/DqHxCOjtovssbSxdSuQzplc3sKXXsFnerU2tlTYljtRuykJNegig7x465DXBWVUfOTJSDyrXHxtTdCq0TM3z0wugXRnjNtF5AT8MJBrQAGmhHI0JHl3l+nS8zZ+H5AISzA096DCllQPfAIpglqpYQAYf8Ev5S6+eLIB4KyDgeAq+dPMlw1z/CStOxvlj6M2Av7gGpeAAhhr4cXUEp4WqYd4ey15QSf8PUjr9t0CYcRddIrOeDT4C5cEHkPBYf208U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261022105027099003)(261026140227099003)(261028144727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEpXN3JHZG10UFJjckhWWWpMZEV6NmJWNlRqelZlYy9IUTBuaitIREtuK1F0?=
 =?utf-8?B?Y3oxYUQ1UTZQQ2R2RmxCUSswTUI4Z3Z6TENDWDMxQ3ArZUV5aEErdW8vSEdl?=
 =?utf-8?B?MXFnYkVUdWFGdnB5YVQwS3U0OXgzVEkxd01VZUUyVHNsWGl0R0ErTlBtbzE0?=
 =?utf-8?B?SVdET3FoMnF4alkveExoZEsrd05KZFd3TVE0SzJRY05IN0ZLY2ZubGp6M0o5?=
 =?utf-8?B?cE9jN3U2emxzTWxkREdmUnJxQnd1aU9hV01SREZBVXk3SndpRDVodkpKektk?=
 =?utf-8?B?U29wVWRCMXpjdTBUY0pqT0VMcHZYUURVQUJPeWNHUzBsY01nNkNaUk5wSGRR?=
 =?utf-8?B?TENWSXo4U2JYNWFMTUdJaUpPN1FKMGhYdWR6OWJDb3d1TnMxZjcyUkNncXdl?=
 =?utf-8?B?dW5pODdxWVRMRnRxVjhzOUlkWlZpU3BYZFMrUUpwOGZlbFlVelE5WEpINVAy?=
 =?utf-8?B?Z29VVmNDY2NKN3FvUmEvdTdJRmM3em9zV2l1K05YUWl3a1kzd0ZoRERON2xr?=
 =?utf-8?B?OFhYblB1TkxGR3RSVVlhWVczcmhxaHplN0hqdk82MDNrWjAzMW83Y3E3UEFR?=
 =?utf-8?B?dEMySGJXRzIvWU9acGlyREQ5VHpIaERXdE1hS3RRajJXTERXSWR4Q0UrYVFN?=
 =?utf-8?B?QkYwSmVObTBUa2QvcGZaVGNNL0lRSytRa3hublp3MTJZaUUweE1NZ1JhcS9J?=
 =?utf-8?B?YU5XS0NTcUhLTjdueE1ES3JqOXA1WGNFYmpkaE16NGtGelUzYkk1Rk9lMGJj?=
 =?utf-8?B?cTJmaUMrK1JYbzM4akxhMkF5V25mN0Z1eXVZL2ZVZUZ3YVBmcUlPclU4KzJP?=
 =?utf-8?B?NUc0OEhITnRZQ0tQK2d0elFTNUFTRmExRGIrV0JzUDNkQW5Vd1FDZGZHZzhY?=
 =?utf-8?B?NS9TSDEvSVRhZEdCRVZTTXRJRVE3SmZnZjEvQS9wOWlFOWRoTStPMlZMd1dJ?=
 =?utf-8?B?RHR6MysrUUJpa082TURaNHdzSWUvaEJNR0lqOFVyWEpEL3M2SHRWNGRETEZL?=
 =?utf-8?B?emhlOSt0QWVOazVSYlFBejlHZUxuaHlwQU83VGlMMGVhakhNUkwxN3U3akQz?=
 =?utf-8?B?OW4vcVBiTUs1RFZTTnh4VEhObU5GL3FmdGRFU3EySjBDQUp0bVVNSjhXYWV5?=
 =?utf-8?B?Y2xmanYxQmMvNXhSQjN6ait5YitPZTh5TlZxbVM4aW1RRS81bFF3NzZ1MnNo?=
 =?utf-8?B?QTNsWkVlVlp3QlF5cmpyc0JaU2ZTMUxCd05NOVFwKzRFd0JEaTBQdGNlaEM4?=
 =?utf-8?B?Y0gxVnI1b1A4NWcxSVdhVEZDNjhzUlFRc2daWWM5dW13MldWVUpvWCsyd1d0?=
 =?utf-8?B?ZWV5NXZEemVBajZDMHdOVmpKNnd6YzZtNE8yVGM4cXB0d3ZWZTRsS3RVM05l?=
 =?utf-8?B?Rk9xWUdkTlUvRW5ZQ1lkdFdyTFJsN3lNM2x4eVlvTUttL2M3dXpCelFxdTQ0?=
 =?utf-8?B?NXNoTVVEYkdQWExabHZTbTJlK3JMVExBZDlJcE9QUFpTN0x5UmVmZ0Z3UjMx?=
 =?utf-8?B?VlJ6S201MHE5cXh6ckxoYTNxWTRRUzNXcHZQTkZpdGdsUWw1ZmFydUhvRXdi?=
 =?utf-8?B?QVhacnUwcTV2U3FRU08zWWZ1V1lPRnBiTm9UYnNGYzJLOWlyb0Qxc0t0Y21U?=
 =?utf-8?B?TERPSkVxWkpqQ3J4c0lRMHRMSnJSN0tPUEFpV1NOV05UUzJmdDNjeUpzcUZH?=
 =?utf-8?B?WTBkWEdtanhWdldTOVUvMnhzNHhMeGs3L0lkY3krZmJib29mOExRUzhtbDRt?=
 =?utf-8?B?RWJVR3A1S1h1ZVhNdHNnb3lkaFJGdHNNbUdJS1d6bGxsdTQvRHBlYlNLdGRH?=
 =?utf-8?B?QVA2a3VJb293TnRCRnF1a3VLY29iZHNYZXJNWFFRa01BeklPTjFtYytFSUp3?=
 =?utf-8?B?ZnhnelBUbi8zN05ySkdacW1QYWIrRmdFYXZteWlFTitBZGlsY0F6a2ZmWE9U?=
 =?utf-8?B?REsrcUZUYzF3cC9WK2FWUytGNUZKVWFzWTZuRlY0RFUyOHdkRVJIVURMQUhK?=
 =?utf-8?B?YUh0UlM5eTgvWSt3WVpaZTM1bWUxVkRXaFVPNzRlK1BodDByWVZzVnRlN3NB?=
 =?utf-8?B?OG10VzUzOEliaXNtay9mWC8yQU43eWxEUldYdDIrUmxIdmJqMTJ0WHB0Rkwy?=
 =?utf-8?B?eE9GUkxYYUlOaWdwWGlVb3VPaDNHWGdGSldBWEV1aHVZUmluNUtJY2NhNEUw?=
 =?utf-8?B?K2lMRFZwcmhqS0Q2NGk1Y0ZtSVRMbGx2TW1GQmp4VGxpL01RYmI5cTl6UDFt?=
 =?utf-8?B?Vk5DSUhUa0M1NVdHSEJWTStCaUpXWEpsQXJzcDBzN1F0MGcwY3RveGdqUk9W?=
 =?utf-8?Q?MRyJ7I4Ebde0GQZBLA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09256116-69b4-46e0-69e2-08df40daa9ce
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 16:33:20.7046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OY8h6VTj3qiF2LQcfEQCmqOSlbNnsU/44aRMVZ98E2SfH8UIVBSMlLIjAvA/WgF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399
X-Stat-Signature: qi8bqoqeg39k15ayybaoz4ao7hy39bwc
X-Rspamd-Queue-Id: 0A67740012
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794501206-370059
X-HE-Meta: U2FsdGVkX18Aw2Pyo7IpGJ1l0y5ZBrmUMHoBRVNCzaW6ltG77y2+782wDglDERkMjqsidY0nGM1sBGXfYEe+s4TJbEDiOUaxaNyB+jmc179QfVonGBcCUDxhXsHNsTREaJNtI++4Xe+yrXu0HEj+FK34NvTu0PfHUUQOBGZRriuoOIMjRCdCh6t/9oXf3HLkx/8Uha/heDw3PU16QmemojAp5FwPFPkzuVTmSZDhlHCrXL1YEu4wxisbjB/jL2GXeyBUS+Tx42988MdzCUm4N2lybMWimwrlijbwzXo7jpu0iYBdKe0hWSuE1ExH6m8ccdF5VySzADAe21R+J6xOrMbs5aix4IptYcah1HBg2RExo4pA5I/Lj1o/beMoVa1H6cJkCuTiApoPay12t0miEKoiHmFUvZ4vsANdNT4qcv7mwX8GDnY4RIbdbzyOhR/721GcsTxWbp8Cvz8OSZNM132Oqn/ESN8PJzbfWCe7umGmPBdJ6EM3VAHGKEY3JuH51I6jgs301QiAfTirhpOvwDUW+2l4uQx6XfjycvAVEDZA63J8PUKuJUfp588QCOAR28Uu3SPmC6QR5QBBlOCvfQ3K5p43X3i0z1FwGnSFHcJSCXphnOKQJzCYbx5TsH9Yt3QBQlY7ksZWbE/XZmlWAcTD+kwxUdvmfbiemdXNxQq11CVqwIFKCqQvTuJBBNewUzrTzpVZ7lf7994/RPfhxnwrOoRlOYaghW7XfAvU0pWSLaqBejBK/DkZmcPSCpxw+meB+0kCeWmp9VfXOK31zjxSWrv+bo2wMCC/yIb6SWzdupt4l1NBq2LaZK8RVMjbkA09aBWgCg/A7VukoGTYjUbaYkK72FwN6RScLaATqPIwwMWsBzxVJRkS3sLJUM034OHr1UuxxEvaLosHpEwu3AY8FYRSnNpWBEfbRTTi8SByhsX5o6xceH9p4jRcknaJn2Ayw3CZImKn03i+OJx
 n5ZvG//M
 qK5+DB14/oMMF7pztlJEg8yJZAKTCLpYoO9y2pR5MaN8pR0tjGPNMeyq7kPfix67i+qzjGbpJTS5R7sKCGmNM1FyYQgcVkGlbhJW0k4epCDYqZ/5nkxsrvS9/0XTPbQqHplXAH3QvM8YCVb04abe/lQ+4rjRoaYH8gQ+wlu424QYXTHYTrtm3jvpw0fid0UWpL2f8uhCUqe5UKYm34/M4za8Pk9s+nC9eU5F5oWnYl/YSZtU9Y+2oVV0jLaCi6CgPktLkfFodDdqTx0XK/bC0hE14yMKMWpIJ+UfAYekXS2WLUmqfAyORJ+dV6j/Q7LhPNqlcZNxskUWPtbrWuiJAvjm0bQ0rTU95HtV7VMYwW+OHI6SV58VX5/+aDRzM6IgyDQeo+VDvdrNVlrmBfel7TiVtoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 12 Nov 2026, at 11:24, Alexandru Elisei wrote:

> Hi Mika,
>
> On Thu, Nov 12, 2026 at 04:00:09PM +0200, Mika Penttilä wrote:
>> Hi Alexandru!
>>
>> On 11/12/26 13:56, Alexandru Elisei wrote:
>>> Hi Mika,
>>>
>>> I want to help getting this series merged, and I've been familiarizing myself
>>> with hmm and device migration, please bare with me if the questions I'm asking
>>> are obvious or downright silly.
>>
>> Thanks for the interest and willing to help! I am preparing a v18 of the
>> series and plan to post it early next week.
>
> The series is big, and as far as I can tell the MM people are hard at work
> reviewing bug fixes. It might be better to wait a while, to give people a
> chance to have a look? I know that if I see a series being reposted often,
> I am less inclined to review the patches since probably a new iteration
> will be posted soon. But I can only speak for myself, you know best.

Totally agree. It is better to wait until MM people finish the bug fixes.

Thanks.


Best Regards,
Yan, Zi

