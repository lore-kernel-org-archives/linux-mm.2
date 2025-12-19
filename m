Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E6D4D7496C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23366B0088; Fri, 19 Dec 2025 04:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1656B0089; Fri, 19 Dec 2025 04:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88136B008A; Fri, 19 Dec 2025 04:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A592F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:24:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2771FB9A18
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:24:55 +0000 (UTC)
X-FDA: 84235686150.06.ED7413E
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012026.outbound.protection.outlook.com [52.101.43.26])
	by imf08.hostedemail.com (Postfix) with ESMTP id 39EBB160006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:24:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XFbz6g3I;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.26 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766136292; a=rsa-sha256;
	cv=pass;
	b=8FmVyrUGnfht03Bol5+h7CKvrCuWgYxH7acz+mJ0qjep7B2rieFxEo3QaxG1TFRg1vGBWo
	fhn72/2ijIHJdhgy5IzNegTVlLkgLOcCyDRdsqdSP8ex1UlbCws1vhOsPB1bILi9RHSZir
	Kg6qz/cDJopty0r8Mp3bYZrgsvtdT0M=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XFbz6g3I;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.26 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766136292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHII8ZdzRzhcRHCR9q4ngbBkYCkKhZDdP+dZHxKPHsg=;
	b=WhnbRmXIz6FqkHLIwn87p7iSbU7/AwDICE3qXiW7slj4QjVVoKuukVHBJY3aUjWPDDjGDJ
	Qe04o1U1BriVtiguaRuyM+/IiQ9Cnkz0DippLsy8NCv5m0BTl5Uslbz+DB+ec4OyEAEppw
	XABkbuPc55C6IpacqVBiJtMZOX2jBqE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6tbDRiD/vF6M/cYfz8uJSPqL/diBBvLOePLTxhlFjw9MiJ1oZHYbWdiTE2lWL4PlXuNIGeYujMowPoCXqZr2ShdcFW4+deHsDImRTyktxsHyIvMx0CjIa7Bau2S3gU34QrOqSctTiKrrOmCVuaW30sPmvsGyfUSmEdfr4i5ZNjIbMwFYTY/G+1w15FQq0Xj2h9RwndSp25vR8XVgPLEOfa+Et6RawIg08kb+kwHrKpbu/7/W1y/cwMNLzZtorwBkEUgBmXEk2KERi7YbHr6IPbINfFxUXN+Hm3J4QrB45tDY0c06YOWlFxItJg07XL4zbkdTrW6tgZdDxET4+/pyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHII8ZdzRzhcRHCR9q4ngbBkYCkKhZDdP+dZHxKPHsg=;
 b=tPrz//k5eE90Bkx/oIbR9x79UbDmPcdY0246aLlIknWDmq6W6nTEOnNGnTMmsMK1xn/5THbeebE2IKAL5LonVPCLsRsCoQIQLiJyYS/7YM2M4eemNgQa+SmYEeRG+XgbBvEQIrwCHN+l0KuJ4hegcRyLAolP0otfFQhCXhyf0AqF+zxo2Ysnn6Y2d9Zff0CtyX4w5qQwCWCxR70oGmVwrDVxyGWNJvSzVGUf9bDN3bkpahqKz/uNC7uujIEz2HXEwZtoSMUA8yqA+o3u7kZIQMo/flrtPPl3Q1qiByhxOZtEBvybkH+LQGk4S3hLDzEfBU9OHG3svM7DDC2+vkolqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHII8ZdzRzhcRHCR9q4ngbBkYCkKhZDdP+dZHxKPHsg=;
 b=XFbz6g3IOp+fE46n7gtPY5gKUESrn5pEyJM8Nl5ut25/VMaSZisDBahrerbFG49dD3niKfNoCgVoIo5QQTOOohkCGdIcdG0o5bgyRYotOpDK/JkL41DDRbNS5W6xR1EsuAdCRP6egLirEW99bz7TtiGx8q7YamAK4ty4ytCDQy4=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by BY5PR12MB4225.namprd12.prod.outlook.com (2603:10b6:a03:211::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 09:24:49 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 09:24:49 +0000
Message-ID: <c7c1d62c-7d27-4b73-8173-0493adc66cfc@amd.com>
Date: Fri, 19 Dec 2025 14:54:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
 <20251217024818.ngoime34bxeatqij@master>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251217024818.ngoime34bxeatqij@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0220.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::18) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|BY5PR12MB4225:EE_
X-MS-Office365-Filtering-Correlation-Id: 9316ecbd-030f-4feb-e8f7-08de3ee074d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1FrcWN4QW9VNFgzYTJDSG9oQUdObFoweGpaS0RSV3VMSzcxRVZrRDlia2dO?=
 =?utf-8?B?bVRSNnYyZ0pmdFNvM0JNRXUvL3JFTk1zTDZjQkJpd0tiY1BsTzJkL0NNTUVO?=
 =?utf-8?B?NlJGTytYQWw2alNXdmk1SUJRY1QrbTU1MDdzK3lpc0pnOUUvWWdTbFFFUWtJ?=
 =?utf-8?B?bnRQeUJJWnpDaHJjM2xzQmpwRGlkUlUwNXFLMDMzNzBGS2M2V0d1UmFpUzEy?=
 =?utf-8?B?STk1eVJiRVIyRllQSlhjNEg1dnE5MGdxSVdCUmJObVhnV0pYeUJPcjBzRXRy?=
 =?utf-8?B?ZWxrZUVaRkVyVGhLWTNtUWtydkkwK2V4T0g4ZFVWN01za3YzSEU4Y3NTTkxP?=
 =?utf-8?B?QTlib3QwT2RrSkVGVXBHcVJYZ0ZKaER6ZmZIbEFicGJMRjdrOEJLV201OTFW?=
 =?utf-8?B?dG5BcjE3U3JVSElMYm1aVXh2MDJJL0lRck5xdjF5WVZGTGx6OFNlR24rRkVI?=
 =?utf-8?B?eExxc3hpL2lkL2JraHN5b1BHNmdRbVZYRHBiRkN3ZXlZRjhPaXRiTXpBLzd5?=
 =?utf-8?B?Ulh2Y3d5dG9kcUgrbnEyVzlHTktxdXNRN2pTdWRvaDBnRmJwVUUrTVNiSUcz?=
 =?utf-8?B?dlZNZUFFQzJ1aUdvVmcwekwyNFJHS05vcXAvUTZiTXZEODdLb09UV0hlLzJF?=
 =?utf-8?B?SFB2aGRlcnl1M2E0aGdSaUkrV3JHZHdJSEljQjBYQWg5Yjl0aXd2VXlKb2RM?=
 =?utf-8?B?Yk9STXZIRThJSzczcThqcFprOEJLUHk2b0kyS1g2ZE1Oa2hNNkU1R1JZb1F2?=
 =?utf-8?B?N2ZoM0tHbUo4Q1hWWU5sN1FlcjhmNy9NTnhVc0FsYXRmMUJIZERlejNVTGxC?=
 =?utf-8?B?eXhyclpxOXcreEdOazhIZmd3RzNNNVljRGRoMjRkTWFiMGRCUGxNNVNyVWxU?=
 =?utf-8?B?NGlGL2dRalNvclFHOGxHTWo2K1RYaGJUUjNlMGlWWkFEejFETGxOM3crSkJw?=
 =?utf-8?B?eXBtMEQ0RE80bStoZHMzY2hOZVc4NUZadzV4bGVBVWV2UHQyUDRQcEZlSG1K?=
 =?utf-8?B?RHYvQ1hlV3dyYVdjNVhTM1lwdWx5YitTVUZGSDhzNjh3Vjk0WjBLWGk3ZFlp?=
 =?utf-8?B?VUd0T2tGa29BZC9hKzVZQkxiWVdGblIzUWNHekkxUmFDNUhpcnd0Q0dmOXpK?=
 =?utf-8?B?RFREME5OWDc5TlVSMWkyUzE0RUtNR3A5Z0Y3MVRhQmg3Wk9SR3pRbFExaEFr?=
 =?utf-8?B?N081YXNCN3ROWG4xMEVuZHllVkVsb1BRV1NRSUMwUm5rL0JyeHhMaFZHYlox?=
 =?utf-8?B?Z3hPNlFuUFVRWG1nY25UNGpJdlZGdUJkbVVaU3g1R2Y0eEowVDRHV3ozT1BU?=
 =?utf-8?B?TWFseE0zVmtsNi9saUJqRGlOSC9iKy9UTE9QaDFxdjNJWmlvSG51M3BkVWFE?=
 =?utf-8?B?RzBkazA0eUdHODlsL1NmdkF0amlnck0xUkU1VFhwMlJOMWMwVEJMMjFiVUg1?=
 =?utf-8?B?VFpNOTBKZlRMMllYREZJTy9RTXNLdWFMeWhDOGcyOUh5bmxTMWNLRmRXRkhP?=
 =?utf-8?B?bU9qTUZhamxOM0xVeFFTS3QxcW4xQVByY0FRSkRqZGF6ZHgveEc2cmZLbXVh?=
 =?utf-8?B?b0l3NHd0OUFZSDBqSkFXcnVtVEQwK2dYZ0JQYjRhOXBRaWlaSktPbGFjSUhj?=
 =?utf-8?B?WGs0RVpiaDl2ZUxLRnlpZ2o5azZJOFZoSUFTMzNWM3NrWlFoT0x3Ym1oNlRo?=
 =?utf-8?B?OWM3RVZmV3Zsd2x3YW9PZlpWbEI3OHBTY1ZFM21Pa0p4VDZOOUk4aXN5QTJ3?=
 =?utf-8?B?UU5GK3JtcjF5QXMrdDFsU0ZjR3ZERjdScGp1ZzE3eUs1Snprekd5TU94cXhB?=
 =?utf-8?B?S2kzSmRMelYzNEZmS21RcHE2NnZwaTNURXpDenk1VFNjWDlVc2tqaG16TjhT?=
 =?utf-8?B?aE5KTW4yMlZUWWNtNVBIY21sTE9EcXF1L1JtSUw5YkFBS3lsMExQc2VYeEp3?=
 =?utf-8?Q?TphuWDs/16rnJamzsC79Ec5AWw3tMam4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzdPQ1lRNlFlQzdYMlpRYnl1TWhNRkNoRGRmOHgwMDUvYmFKMW5uYzNHNmFs?=
 =?utf-8?B?WmlvZHNBZFBQSUx5Snd3d1NBNHdwak1pZVRiL0FoWitQc080cG1EdDR2QTJk?=
 =?utf-8?B?NU1qYmZZTXh6UWhoUHFjZEZhN0VNK1FDdlFTNEszeGxQODM4Sk1HLzRYZzR3?=
 =?utf-8?B?RTN1Q2JUUHIwQ1daWStCNEVFSEhvTFRVdUZKbGNBNUpCbTM0OEZJU0VpTmY3?=
 =?utf-8?B?QUpvMmtDenAwWFppNUQ3YjhRbnBiby9TdmJ5cTNRL0t5b056eUVYZE5FenVv?=
 =?utf-8?B?clBEUSs3eXhQaDZ6TFhHT1U1MGNrWDZjQWM3OXZ5VS9leHphY2NuYW9qRm5o?=
 =?utf-8?B?Q0JRbXQ2b05qNEVuSGE3QlNTRHc5aWhQYnEwMmc3S2xaUDdtdEwvdU9JNjI1?=
 =?utf-8?B?c3Uyb3dySGR6WDZONnJwSURMR09ZVzZZN1dKS1dnZmt0TjI5MzNMT29RZllZ?=
 =?utf-8?B?LzRnMVI0a3ptYVpRY0dyeWludUtOclg3dERVNzlUeldNWmQ4NjJSbVhqOUU4?=
 =?utf-8?B?Y0N2ZGl5MGhXcWlocUJUQndlbHJxdy9wRytoUWxTTm5aNU0zYzVwVCtSM1N3?=
 =?utf-8?B?eGNmSWxybTFaNlVvMmRndm4rdkRnSVNtMlZZUDFpTllhYktkd0tFVHNtVGox?=
 =?utf-8?B?NDMzZE45NlM2VFdCY2cwZHlMckRUZVYwWUdjMUVURkc5SFhRTG41Z0JGcTNX?=
 =?utf-8?B?b015WUZHSUI0T3NDN1BVVWdqUjJUU1NrR1FLY3NWdnFVUUkzeVNSMVNiTW55?=
 =?utf-8?B?MzY2enh0NHRqaE1zVTRHMXpNTHI5UENSZ3pBWnFvMW9YdWpQZVZCSlJIWkQ1?=
 =?utf-8?B?N3Bibk9WVUN4OTNzUXUzdnI3U2hqZ2RzQ0xOT09CSFFPVlN2NmFZZlYwQndE?=
 =?utf-8?B?aVk0OUpWL2lYMWgvck9tbE5mdWdzM2FQM0l5TnYrUmRGd1Z5Q0l2Nm1OOFdo?=
 =?utf-8?B?cG8wcnFlYlJsQTV4TWR6QWZhNkdBc04vOWdrUFdyb09PeEZncHg5amtqY0k0?=
 =?utf-8?B?OTk1K3o4Mm1qd2lDbVQ0Q05yRjRpS3RjNWU0T1o3U3ZUOE1hMlVDQWN1M25Q?=
 =?utf-8?B?czBHMTVnazVBeEZlaEZQLzRJN256ZTVMR0RRZDRHQXE1NFVSMzUvZFlDV3Mz?=
 =?utf-8?B?UG5sWkt1RGtJOEE4dEh6Q0lwRXYwTWZoODVDU1lOYS9xMWN4Wm80NE1DWTEv?=
 =?utf-8?B?Um5UUytrZHdXQk9ZQ29lUUs0bUtRL1o3bUhhWm9BcVd6R05VbXFzNjBabTht?=
 =?utf-8?B?S0kwOXY4d1BrMjQwYTNraTBnUWdlT1ZZYjVnTk4rY0FRaHd1a2pQYnV4OHBW?=
 =?utf-8?B?cXNEbnNIUjR4K0hFL014YXdsUUUxZGhaNDkxVXUzbXEwRGtWdGlXT2JoRUFR?=
 =?utf-8?B?T0M4VEtabjFQTlhBNGF0eDJjeXh4Tlloa0tlZUo3SmU4ak1vZWVQUVo5L3pw?=
 =?utf-8?B?VkUwS2J2U0pydUpnK2xMNEtHd2FEL0RmVzllbCtob1FrckZxTlk4eGpESHk1?=
 =?utf-8?B?VytiWG5VaTA0REJSNWRBbEZhenk2czlJSGMvRHh6eTR5QlkrOENUenpUWUY2?=
 =?utf-8?B?U0hJcHJiOURGMzBkMEhrb2w1YlZYVjZMWXRUSlYwa2JZYzNwZUFrS1lzUnJU?=
 =?utf-8?B?WVhhUysxUGFoZkw0WC9LdWhWdEdKajN0STlsSC9Wb25tYXhOalMyeXN4VFk2?=
 =?utf-8?B?aWVBN1daRUFheTF2S0JvOFdBRXJXa2tjYjVkbnJsWElzZ1QvODJKYjZJMnc4?=
 =?utf-8?B?Rkl6VCtKY3pyZ1BLZGZrcUdDS2NEWVNmdUxXZGJRT0RLT2luZ1JydWpBWXNn?=
 =?utf-8?B?LzZsYVlWVmY1RDVsRndDMExBdE5zUmREbmg1SFptZVNwVEI4SklMVTV3eFhF?=
 =?utf-8?B?NnVkU3UrZUQ3eEdTQlhHMmJzWi9jbjJKZUd1QXczeEwzRHByRVRZTjZtRTY1?=
 =?utf-8?B?LzJ3V1lQNDJZSi9xcEloZER2U2E0b1hDeFlvWFFwTEJBQmREaTh1UHpUWlU3?=
 =?utf-8?B?UmlFVk1DMU9GbTRuUFpFR0JzZnBmY2VrYXRxd3lXa3JidXZvYy9uTjgrMUEy?=
 =?utf-8?B?d3FEUmdvc2pqbGw3OEFFUmRlQUNRNUtTdFQ1VUdpOHQ4cm00WFVKekMyRlBj?=
 =?utf-8?Q?/bU+0HnAvdYHM/2caSb0qytr5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9316ecbd-030f-4feb-e8f7-08de3ee074d1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 09:24:49.0711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+eujRLdGKUVnjCVP7WXAM4CV+wDpaniqzQrNJU+iLwm32Nrb2+N1rc4FgYodH4Bw/5i54I2+5vIhub/U1jIlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4225
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 39EBB160006
X-Stat-Signature: sthcqzt6s4fru3gep7iwtocjzfshtdyc
X-HE-Tag: 1766136292-899170
X-HE-Meta: U2FsdGVkX1/rN4KR8HY12m6w5yDHZF3jJrEmYF1HdrRi02lt5vT/CEQ0v4LwK8apBv/a7yxhd19dkBPOiyI+h/6Hrkg3PURvpq4J7I7T7GnzN8bBhp8pM6lCUZsSID6/sqoQSn5Kbkg39tPBaTiRhbew4CDuYidCpErbIv6SdOiHzlFvZf6SMZQyzceDuiSRVTVDEu+aTbw9rzAToXBSsIiISUqIENwaznIdE1H987cqD3rQ/JUSqAz0AYFmOKMDB3Zf+nFScwZ9WdUrC08qiwdRmqh9LhpuVv+Urc7EtrTFyh+/bo9tSJGNEO6HYssV/ytWdxAl2EnhvmaJ8l3fbRipJx0Ko3Fstd80sgQZd1Mg4KkEZDv9F9gq4bSa0NJ9XGGFqyNAS051eFdqJHeEfo9qnIPXn4zlZ5Gik8UP6N/BZUEcgPHhpryvUJPYb1qA7CrX7zGaj9ZUTIUwIJUXgrGtiiRdDocpNkq1Xhwhsf/lZpWjQjjIMLVihs6czV/x1WGo5UHUWorxVeFJvzHaYtVZPau5/6atMzgKArD1K3U7dP3FugHTCQMNe7jzmm4/TETfgW6VIA1ol/GJnPWGZcSTrcImqbmhOB7WjC5lu/Q0AyWn4cGTf3FJVIOlMISm+05Z+a2tTN2w9M8d1xHF9qWzOv8aUed1dvamyA3ZBCk1KbOxlwE2CiqKNtchsUgu30TJrIQ4RZmBZIWioLcF+T9k7jMYt7uGV83rWFchorozlL5Fg7N5Eg1HEQH2tyWvBqrRXMHTOx/gpzUUNhBAnMld6Lxhae6c043FQAii1Q0SwoCn8YWkCok3p15j13rQi7x8olznu7p477UDfEnWOUZsRt19CUIaGOGj12QOITqcQIDoFaCO4zPSNIclEZhUrEpj3X368zKmdGJu+ViWy/ZYzJonbBTC38CDgKcc2xxaHyDbwBg+CN7/Q1o82Ct/da3gvJZHe1p5JaHDyUF
 i8WFogpy
 5uc55ex/E55pneeFtwxe6vJAduTrXzNkOV2RbNxBk9kD5WKx7k0yNAy+O0Ca5flWAGLou/YTLcMw5RGwdVOacSHj/ofm4zgzpr1m1eqwhb9zeh7brF6GpcpZpKA5DeuZMXgtteJ3GhD+uIf2oJ5EPiJCPYCCMpU1XCcedbAKRKyMpEFuP/OC3QX9ChNlkJP3IRV4DCSxlgMXA33pbSWLQ4XbIy2799TyDAXIUUjU+1OGBPD2QoSXdzROs+BUt6/NYG67QF2JRBymcbVS9In49gBv4iczmdCettjcQPlg0Qx2bDg4BotXGGp10ZJAt53LFhP9igyMikuWMNzLU6vLB2tiRVw31OTZHhk9wq/jky+1eTU4C2LgPuW1VqR7Y5ZJ1jc1SMtVKEXp8EZRnmy96T94IwDMC2L1BlpFJVA3hQBoas8dUEmSTIIL4HuoNBNv6KZe+E3Xv5H2iYHRn1g1MtEdcGrdBuLlSyuxhwB4HswAq4K553PpBB9eC3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/17/2025 8:18 AM, Wei Yang wrote:
> On Tue, Dec 16, 2025 at 11:11:38AM +0000, Shivank Garg wrote:
>> Replace 'goto skip' with actual logic for better code readability.
>>
>> No functional change.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>> mm/khugepaged.c | 7 ++++---
>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 6c8c35d3e0c9..107146f012b1 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> 			break;
>> 		}
>> 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
>> -skip:
>> 			progress++;
>> 			continue;
>> 		}
>> 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>> 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>> -		if (khugepaged_scan.address > hend)
>> -			goto skip;
>> +		if (khugepaged_scan.address > hend) {
>> +			progress++;
>> +			continue;
>> +		}
> 
> Hi, Shivank
> 
> The change here looks good, while I come up with an question.
> 
> The @progress here seems record two things:
> 
>   * number of pages scaned
>   * number of vma skipped
> 
Three things: number of mm. It's incremented 1 for whole khugepaged_scan_mm_slot().


> While in very rare case, we may miss to count the second case.
> 
> For example, we have following vmas in a process:
> 
>      vma1             vma2
>     +----------------+------------+
>     |2M              |1M          |
>     +----------------+------------+
> 
> Let's assume vma1 is exactly HPAGE_PMD_SIZE and also HPAGE_PMD_SIZE aligned.
> But vma2 is only half of HPAGE_PMD_SIZE.
> 
> When scan finish vma1 and start on vma2, we would have hstart = hend =
> address. So we continue here but would not do real scan, since address == hend.
> 
> I am thinking whether this could handle it:
> 
> 		if (khugepaged_scan.address > hend || hend <= hstart) {
> 			progress++;
> 			continue;
> 		}
> 
> Do you thinks I am correct on this?

I think you're correct.
IIUC, @progress acts as rate limiter here.

It is increasing +1 for whole, and then increases by +1 per VMA (if skipped),
or by +HPAGE_PMD_NR (if actually scanned).

So, progress ensuring the hugepaged_do_scan run only until (progress >= pages)
at which point it yields and sleeps (wait_event_freezable).

Without your suggested fix, if a process contains a large number of small VMAs (where
round_up hstart >= round_down(hend), it will unfairly consume more CPU cycles before
yielding compared to a process with fewer or aligned VMAs.

I think your suggestion is ensuring fairness by charging 'progress' count correctly.

Thanks,
Shivank

