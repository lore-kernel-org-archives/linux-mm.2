Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B13C5C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564506B009B; Wed,  6 Aug 2025 16:44:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BC26B009D; Wed,  6 Aug 2025 16:44:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4034F6B009E; Wed,  6 Aug 2025 16:44:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3246B009B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:44:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 001381406DF
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:44:03 +0000 (UTC)
X-FDA: 83747509566.28.05E4EB2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C0C1180007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:44:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KKgQww56;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OR1RkCzk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754513040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADmFL6MnNxwXmBbs2+4p2YqfFKrI+lvAQysMK4f/5ak=;
	b=g2FoSa4Nt4yMzJt6oCSGhIGmd6d+Wp7C+khnNcpVXGdJO0SotjQknNZlTPMbfbOR4bmohb
	vbCDDaG6iTdDjSFRJMCfHZL2WbgmKi4nXhqy+1lCxn7IPIiUmVDVlC8akvefa+o2FthNc7
	iDzTmRywYb+xNL7vwksCgf6UXwys+EA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754513040; a=rsa-sha256;
	cv=pass;
	b=Gu5gICcxdp9oKzlavgjvV8A9LbQVl1PiAi79PKP5Fx0NzTW9hwS/08VFDa0b0tttzwmkLD
	GTpep5jeXCcDXhpESGVicOydjZzg9XV0egmEcfi7y6UCcWrJt5AA1n7ueVjIE6XCSHJ3r/
	9Et+RxBRTRxw/d0zMy1Tgb3Yy6q/IZQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KKgQww56;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OR1RkCzk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576KRSgH010240;
	Wed, 6 Aug 2025 20:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ADmFL6MnNxwXmBbs2+4p2YqfFKrI+lvAQysMK4f/5ak=; b=
	KKgQww56WiMn+fjMwzH3uk5Z99RWpiHP0t1m+lSAAaHUqp9XArCagvzWsBm1WbGs
	qW8Cr2eqZjXe6cnIPZLVXQXZ66PkEir3VxM7458tp6tKGQl660J6fmOZWoEZ6AND
	XggXryRLN+qxsm856ryKe9jI7lIg7Z4C6wWvvoTwYmYsO6o+VruErzy1xP2RkHMT
	m3YfdOKQ/kOqX7x45pID+7djvZk9i5gU5AwygLjpd04GemyuNp+axDaSf0DrUajm
	T+p8o1VnhqENsL8u2bZnX29pgQz0vHoqCEHUaZxaHMua+fireQM/FkbGoLRiUuHi
	yEAFBNKUrkTzjZjneSi64w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvf2n7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 20:43:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576KWQNG009798;
	Wed, 6 Aug 2025 20:43:53 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwmh82q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 20:43:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VmU1SXWzD2bQdLGozNSn8fioptJ5XXF5s3jTqw9WyPD1nG1utSuwLZWEZvW66beXSE5U0nMwgxXeVhsyhrQ7DMW0tQY/wOYSTa6Wk82x/ZLBpj3Fn7axO1LX/zFkeHUuFbH5dAQFPhhiBb3iyssR8NZvk8dV+tz/CTzSvN/4e+Rzf05jrOEmA1rOvlpDnH1F13LnP4WMwuWpGxc2H3b2bmXrs/HE67LX08CaKzneS+rQyI6ywe+fK1zTYVmlbHYA7OO9KrP+HDNKhuacSugT79XPDb5XbLRqtM2a4QPyd3eAan3buyhJj2996XIwAkBQ5oEhbkyMAklpJBaadV5pXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADmFL6MnNxwXmBbs2+4p2YqfFKrI+lvAQysMK4f/5ak=;
 b=zStjjnSm/3umQAauM3mnuTVJ3HDqVGC7J9sjn+RXWn6b/f7qrK/evtjG6fulVHXq3LPXuAr0dS4FnyGDKesNvYEynHwdDPgHW8UhWkq9xHaSm/TtTRlFS2+hG0AIcJSbklaQaLI+Z9AuFTJlcTogBIH4ZYgx7ZDByzPqobRkTZC0lLd8DT8G+iAhGo5FuAz1mxWVa4d0gKtEQghSlq7ADRP0yAXPsAPyekj+7CeZjqHxtTPNiPJOqM2Qbq3gABbKAJ9TXU7mLz0Vh5bGs2r1R6GnbLIOoALnmyXCC5tMUbr7t7ukpNN8tKoSCJ819krTJnOr+nzfix6KNBLOZPTpcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADmFL6MnNxwXmBbs2+4p2YqfFKrI+lvAQysMK4f/5ak=;
 b=OR1RkCzkrlz1BBHYHM+4YKy3S+g/1kPxZIxWX2YTB6MPH8aJhpJkRupPrfWSfd7WAtVRGI2F0N3wopdqRp+dPjoTzzguHHLmpZ7+I4fWV7qY+De8pxhynMdBY72OVu9wkqRFPDbtORBRmRs33kYijMe0Uf4L7MJ8r+Er8BFBmAA=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CH2PR10MB4390.namprd10.prod.outlook.com (2603:10b6:610:af::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.21; Wed, 6 Aug 2025 20:43:51 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Wed, 6 Aug 2025
 20:43:50 +0000
Message-ID: <dd8a3a65-a9c1-41e0-90c6-99c2ea6d9f6a@oracle.com>
Date: Wed, 6 Aug 2025 13:43:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm: hugeltb: check NUMA_NO_NODE in
 only_alloc_fresh_hugetlb_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-7-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250802073107.2787975-7-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0004.namprd21.prod.outlook.com
 (2603:10b6:a03:114::14) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CH2PR10MB4390:EE_
X-MS-Office365-Filtering-Correlation-Id: 52fb39bc-1bd9-4845-8135-08ddd529f32c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUUzNzNhQ0JJVDg0NW5vOUFhblV6U2MwcDlCcGd1ZThFNmZLL1JYSmx4ZmFP?=
 =?utf-8?B?MUFPaUxIb0dRT0Y4b2lNZUYvNnVJaCt4VENja21RR29YZnFWL09hSXI4RnpF?=
 =?utf-8?B?TTVUcU1VUTl4djJRcE9vWkdLZlQ1QzhYRllVdzJwMThiNVBtVmt0Ui9LVlM0?=
 =?utf-8?B?TXB2ZkpGbHJHTU82TTdpN1Zhb2dneWx5UGN0TmhWbDBHN01qZ2NHRk9kWS80?=
 =?utf-8?B?RDlvdkJiVmRISWwzU3RQcE14NnFtRlRXQ2NWaTBRYUhGYXlGK2xtYm5rV0hT?=
 =?utf-8?B?TUxFMjJab0NMNG14Z1E3T3IwdDFadFNzUHl0ellrS2YzdWx2TjJYQkluM0tV?=
 =?utf-8?B?WTBZNGZ3MWJNUTMrNndzQTE4bEgydVRLbWNZWC9SSFNWN0V6VjhRdzZkMXpo?=
 =?utf-8?B?WFdWOGlseVQ2ZTNFVk5wUzQwdnVNSGxCWXplN2hWbXQ5UWNjMDlIcTAycXRt?=
 =?utf-8?B?L3c4YmNWQlZKZkdTbnhJSHhqeXMvbnlJMzlOc25NeXlVUTUrK3VVNUpTVTYw?=
 =?utf-8?B?ZURuM3lYSVg3NTRXOG1OUW1URytwZXExM1o3Uk5TeG5mdUxKejFlRjZ4TFNN?=
 =?utf-8?B?ZVJUTHk3MCtORXp1dVFJRkgyb2FqY2JTQjZ2dnVJSGJhRVVrc2Vkd0hXYUhp?=
 =?utf-8?B?WEZ5bTB0RG9sRVN4UEVPa3NWTGZhc3RJZ3BYQWRhUU5tQzZaMVhBQXQrRVFh?=
 =?utf-8?B?V1FRS0lCRlBubzZDSkhxdUxRei94RWZwbHJBbzJubzhzSWNWMlMzNjJCb1lx?=
 =?utf-8?B?YWRXV2hEL0swaHFHWVR1N21Od0tNeUc1THFZYmdGK08wbmh3R05qSUdLSTFW?=
 =?utf-8?B?TkNadGxSZU4vY3Z3RlZaNUpaM09SRUZIemFXV0tHZFZpQ3ZGZ0dFSk5KRTVY?=
 =?utf-8?B?dHcreXNiYXhJdVpMOWZmWTVKUUJNSTZDUnkraXNDdnUvVFpJcWtiZmJ3cEVD?=
 =?utf-8?B?RmFIcTI1enlQYzltL21OWEVZcDZoem8yVXBNQjV4VWZGNE16cDN2VUs0S3pF?=
 =?utf-8?B?SzNNVlJaRDNTdWZBWU9ielhmRUUzSzFnWE9jRTE2amhWSHZZZTRwTlFtYnEz?=
 =?utf-8?B?bEFRd0M4aDZUZkxUdmdoL1lNb2ZQTThrTCtLTW56V0FVeklkTHFwaUJRYjNm?=
 =?utf-8?B?clBhZDhlMUdpMngrUXl1M1lVOG0zb3BIWHBTKzhaWGxzRzk4SlRmdW5wUU0z?=
 =?utf-8?B?Z0RZVEVFRW9FSnMxQzdKTXNvQkVmNEltc093SHBNQXFLaFgzOUkvUFJiSVRR?=
 =?utf-8?B?MHdGTElvakxnTFdtTkhEazZ6NjFEaU1TQ0lGaXNHSlBpUFdYMHJadVVJNmR5?=
 =?utf-8?B?amd2RFlPTUV4cW1rR3d0WUhZcFFPejBXTWY3VWY3dXYzY3JHMnk4RUczNVM5?=
 =?utf-8?B?OXdKYndnbml0bk1iSStsZXNHeTU0N1lib3A5eWVWOEU1cHBmNEdqK1JoTFBv?=
 =?utf-8?B?b1FyMnd0S2xIMTZxYXpuaFgrbzM1dURsazdVL3ZKVERtUUdUZTR3K2gxbjNJ?=
 =?utf-8?B?M2NNd080NHl4ang1WklIR2xFQUxqSEk5VHI4eS9EQmQwMkIrNllKTFRMK0hJ?=
 =?utf-8?B?SjVIWlovTVE0TFV1S1VuNVVWR1d5NStESXh4RDJjcXJ5Y1k0NXVTUytlZGhE?=
 =?utf-8?B?eldFcE1FY1N2T0YwTTFobWd0Y2JuTUhFSFI3UVdXdGlyR3MwNGc2ZlZodTBr?=
 =?utf-8?B?OUR3NExBejEzZFdnU2JYRDEydVFGRnJoZE5xUkZNSkwrQnlzL3grNTBVZGZu?=
 =?utf-8?B?NFZUSHdWOGNSZ0dWRkQ3VVhYaWN6bUY2Y3hsZEliOXpBWnduRVdXcEdaUzUr?=
 =?utf-8?B?Vkc5QWFuZlB5SURkMytqODhQM1EvUC9nMFBtS0ZaampSalg5WDgyQUxjS0RC?=
 =?utf-8?B?VGJOeSs0cXBKY3hLVE9EOUUxSFVTMkkrS3hEVWk1WjlCTS9mbWRpOEpndTho?=
 =?utf-8?Q?puxYm0ez8og=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0YxZGhmNGlRVmpTNytBYWQ1WHZGSSs4KzJsSytCNEowRzdHRWIrQW9XMWR3?=
 =?utf-8?B?MkpMYkJlaVJ3OTEzRnV4UE9OU0hGVHdyOWsvMDhhTWRMK0pzWWpqK3dpZHlo?=
 =?utf-8?B?bXh5azNuQzQvTGh5M2RKUEJTTWxUWmJCSTdxT3ZTamVNVG1KMXp5bkpMM0p0?=
 =?utf-8?B?U0xlNGxsUWMzS3NCd3BoN2V3VmpVV29TUE9jYTJocXlkVzFBY1pGelcvdmNw?=
 =?utf-8?B?MDlMVEt4dkp4d1VpN3pKY20xeitjczNDZFZsaGxRWkFQamx5cTZ3bXJhTWdW?=
 =?utf-8?B?SnM0d0NpaDg3eFJjemlaZktwR1NtVlk0d00wOG55cUk0TFBFRE9vMWxGUE5S?=
 =?utf-8?B?NUZPVFpPcEhQeWxmNXdJa3Nyc01QOG1oalQ5ejVKNnJ0c3hNeHZ4V1hYTzZE?=
 =?utf-8?B?L3pDZXpHMkdiMXhYTlZZallDVEJPV3MzVVdtR0VlK0pVRFpIZUIzR0FpREg2?=
 =?utf-8?B?QlNFSnFlT2pKQklJNm1JK2FTYy9JU2lJWnlqclJtb3B5ZGFSOHB2YUI4NHJv?=
 =?utf-8?B?ZlQzQmgzR1R5cVU2WXd4NFV5WStkaTB0TFBkMTBmQVBZWEd3YjZqSzVDelRB?=
 =?utf-8?B?NTRZR1hnblNad2R0ZDc0MHo3bXFBUWlaOWducXhSbTBQK1pIVHlPa0FWT1px?=
 =?utf-8?B?Rlo3eVpoTDhYWnQxakxLWE5wNVRhQWRkU2VDYjJGNzk1U0h1OTA5NzZmbVB5?=
 =?utf-8?B?RUx0TlhRcC9vQjRlNkJldmlNc2h2Sk1VbVQ0VUFpb0ZsUUJ3TUR3eThFMWUw?=
 =?utf-8?B?V2hFTlk0ZkxFcjNHUDk4K0NGb0FVbCtIQ01EZ2d3aFlhdVVIcmhOaHRWL1F3?=
 =?utf-8?B?MEI4dGxHeTNvWWRtSmlyb0VZa1FZeDVjaXMzS3UrRDNQU053cGlLazBLZU1G?=
 =?utf-8?B?d0FGNHBJVkJjQ2FjUW03a1dGTFZWSU0zYXNSZ2hZa3dpU29KU08zcStEWlBH?=
 =?utf-8?B?THNmTjhTSXB0RE0xK21weXRrM3o2Vjl3VjFkU0NrMnQyS2RtYWZXUzBRWW96?=
 =?utf-8?B?K2ovNkllcERjeDhnTHdpNjJ2dkhIdzdoN3o2VU91YUdGaFlJT29ISWIwRHUv?=
 =?utf-8?B?WGZKN1ZWZ3BLbWpoazlQcE1BNDE0RGxKQkRCWTQxUDZhUUFFaERocnlSbjVJ?=
 =?utf-8?B?V1FNRU1hMXNKU1pCTTdveE1hUDgvL0xMNDZyOXB5YnpXUEFtdXBPZzVMMnUy?=
 =?utf-8?B?VTV3R3lldGRjeWIxSCtwc3J4eFg1MzVReGpycy84VWZheGxsU3JCNnNiMlE3?=
 =?utf-8?B?ZW12V3l6eFJ1N1EyUnBpMnNaaFNKaGRTYWZKK1VFRFlFSG95TUJKWnVJRTNT?=
 =?utf-8?B?dTRrQnM2eWRod1d4WEN2RFdyTnBSMWhqMUNlbldpL0xSK0JuVFdwdkdPVkp2?=
 =?utf-8?B?YXRCTFl1YXNtVE5YS1FFb0dLQzRQSU1uUGp0M252L1YyejdndzdKVHE1RlNW?=
 =?utf-8?B?RkpNMnhkcTFXcWtJakdISE81WEdvS2plcXpvVFJ2T2dGc3gxblg4YUdreXdW?=
 =?utf-8?B?Ryt4c2RhQWpFYkp2YTRZc0NvTHo1TUs2NGJzeHowcFR4eGt1RUo5SS9oSUZv?=
 =?utf-8?B?QWk1Z1dzWGRiL251clQ3SFVvNnA0MXNGZGhQcHFISGlKMUs5Q1BuMzNoRXpz?=
 =?utf-8?B?ZFQzaU5HamplenhsQkJvTHI5Wnd6NGhiSGZHK3FOT28yaXA4d0RzcG9FVThT?=
 =?utf-8?B?OUNhU0xLdmVHK3huMlVxeGwzNWlJZjU1d2JLbUpLY1d6SFR6elFTUVFFQWVx?=
 =?utf-8?B?MXlpTlNwMlp1UEJUZzhRbUlPSWdMdmk0SmIzYzlHd0Vpa21EQmxkT014NWwx?=
 =?utf-8?B?UVlHQWM4QTdyQitiS01kZ3JqZERpcjJpcHY3dHhQa1gxOVJJVTIyVDloZmU4?=
 =?utf-8?B?VURmYm02OE8raHFyVEtPc3JaQmZGRFN2ZTB0bTRZL3VuTGxVSFlZRDYxc2I2?=
 =?utf-8?B?ek0xMytPZHhyMnQrYnEvLzFwcDNlOGZWY1hIOHM5eTk4WVVaK3VqeEJVcy9z?=
 =?utf-8?B?ZUNwaUxJOER4UHJacGs1bG5vMlYwSzV5S2JJK1g5MGNTQ3dodGZiVmRaaWtw?=
 =?utf-8?B?Ynpod0diaHhoZlJTS3F2TVJRNEFKM0pMQ0pUVm5zcDNKUjdjbHdWRTB6N1Mw?=
 =?utf-8?Q?lMB2IuRhmlTHEmFw/Rb6+s8m+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e9oSeRgXvQSip01LrvT2Jwtb9IBR6H8DrZR8kMo+el2SYR1GWi7PoSGicm8Yrbwx2vl+qqjRQVHfyU/WYRjxKIo8lD1KmZbTLf+ENEmrVv+w2Xbd9fdRdf52tZ/7r9hXNPX1WQnE6aurXo5K66rCrEDFYQYKCzqn1ohaMHzXEaW3eYmaCN60MCxnDnWsK7kQmjPB+/ZKF+cjf9rd7pPdX6+4TYBXkruZ+YXKT7tszNOaTei4l7xggU2r4BdOdVX+rYqVRWMSGIsG0D0eXF6m99GxU326rAaUp0oN8sukMxyQGZcWoeNnMuw3CReL7nSQ+DS24zpIIVbfOpRc2sbaEEXuZd9vKblu34ks7OFoxNrB/34n6Ztr8/Uk0sQsfuv5WZedYJpjtlCIUwi+ist8yMaPajFAQZKzmlmtHODwHVXt4GOd3FA3Gly1vP/aiL2CmnkLJ2vgas7ZtOjBqDkhiL568HhJTQx7cQvmzcTdo3AZDt4HDYOJTb14RKiaB1w2Z9CbDvitkeNW2w8VjCBEBV4cwyRdSvvLfQEqZrqLQIYhJ/nw/DfBr5ttwyc4Kd9xu/hqf3qZUczlZXnuxiqYXxwNrrL4AJXdgmK/zJWCBzE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52fb39bc-1bd9-4845-8135-08ddd529f32c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:43:50.8127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rBMq/akehLXJsTNckmqFuy9LL838q6Ywdgb6QQGwDVO1aU8riPSFqDcaGBvR+AOjtG82LdFrExuowSQw1fnZWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4390
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDEzOSBTYWx0ZWRfX15on8Go0jbu3
 vidD8r2Hj+E2nUrrIZME1WoKl3rmoex40kVmqe6juDId1ZluhoAjJxFWIwXezAVkAYmxl7/8moB
 n1UL8Amxz7ljaOvjoKxoZ/2Nqq868hlYHgedZWLAlYf4n2lD90MQnJPUHOQvozr4IsqtN9lOreb
 f7FrT5KBj9+KtltOnD01IndNWUZ4VIXSVukbV+A6MLLyiMDoh2N8Q1uuOxAvHuVaNXkDxPxEzRG
 KpznoZNuoAJNJbvyMzaJZvW3X2rNsFncnu7McBmuFlCDHkIW2dLrco3mC/07siK9+Nm8xJ3qLBx
 fTBRF2D6p39LqMavvc6W6I/JwII89Z37AapeLmavpZGW7IdkKhplcn+YTOCjL7esv5cY+oVzo0r
 IMjsJ1ug+HHWodF4Ta59qhncuvafcg7ChlrmzNqn0mXZaa4mJCaGcEiSA4xlds8ARyD7MtR8
X-Authority-Analysis: v=2.4 cv=RtTFLDmK c=1 sm=1 tr=0 ts=6893be8a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=JX64XnjZpCeqXLigKFcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: agOQdwwTREiIDm3XIcvvcTxrYm0d_RqK
X-Proofpoint-GUID: agOQdwwTREiIDm3XIcvvcTxrYm0d_RqK
X-Stat-Signature: 1yo7tnkb5mbm55kem6w46rmsbbucuhw5
X-Rspamd-Queue-Id: 9C0C1180007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754513040-847370
X-HE-Meta: U2FsdGVkX19aTO9NMWKO0FGRIcAk9T4W8933Rsq3kMeB06pgARpKYXLjtfpY6xbq5emb4kLs2Ibho5cgQDmE4/VuuXFQGAA3YH2Ky4LNQHNs3j4KJJTen3+Ia9jRRbz7UiZcsRJwk1zb3WRJOPZFeMmLzsvZXPSLCc2ROcZk1hmjWU+/naLxneqD70tF9B3jpucqpnUd4zkXpoAat1H4GhQ21gTl1PHD8zFalHn4vSoce5LsAOby1eHEx6rLie0KJm+wJ58yujQ+b1Wj+hihP8ygJFVOSG6Ifm1Sb+WnRPKN0b2aw3IVJAPdhdYTggEOYDCZhOVVE0IWqjz6AbvKDmarIkR5t1lHen4hsst7VqUsjIXELjinYI6hPJl4bsogm6ce8ETMUN2wHIgTrfdWt8+/rACU706rt7u3/LW8+k+FI7liHeeMv1tdB0zH3cCWxDyYk37mOOgFAMrY3qt+4n0mmIjRWGwSMJxthFh2zN8GjkdffSVEDMxvQNgQXLHpjf/gd+VoSEfKTvOZNDmJWLwSu+QPVk0She4bm2QLO1ESLgO/KFLRp6PUjn4aHmNNeSt9T/wCQ74HWhNsPFbgKD6sRT/BtPjB8tsLM5CL95xzqjYj5LBC6HNZ10nJQ3feXEET0ubndYfM7hZs+Y5NVqFyKEIYnkDDBnsUtRmawh+EZ2E1B2LvHDwudOFINIVsPCJII48p8lrnEa+yQLOmmpj3OKbDt+gJY53EgJtcWn+ibJcGrPwO4VWQrTjIPdvGJftRtsbbC4YjI+KEFUUYv9eHOHc9uOi7ZEcuYDkOfTMqAbhjiDeTtlTKEYEKNI+p41inNWsB/SxzuFSQE0DSwsRkkpPodNxR/DLBww3pvBMtYDzuoW+7zAW4XWfO50lSnJLGSfgWHssdgaieVJhOVTgSSLZnfaF1/gy6rQGMoKOA+JSTWmL83b6CkA/R6me7QOEFBXRDzFExXiEjfo9
 PFWyKiMF
 6Ier1ZZtr7QP6dzJJXgmUsMRLZAiW+O0HTaz7O98d650siu7ny9szp2jyK0drM7ysFfDv36ZgCtwdS+Dd7JrBBLdwDIpFWGjrQVOGUpuFwCpXLwZ5KqwUJugIGz1S9rbVzjyxJ7URzMRKlse1s3iVnG9+vWb7pNRatTjTK312RIsOxb1UxvKwMBNpJV29rt9n0Gy6HDL+pav9RXTi6kLyRcgrJQdzCHeW4LDPs+Mbvdcb9O3wLPW3ttJZ26fH8k4CB0xFoE47nZUbjiRV6Tloo7Mo2KVUC9IgU0JyngDo1KHcwaYPSRLiDqCNEiYeMb3WTC7rxDYK1wp73KMp5WBRIL0Rsi5k3GkuhFnUGiphoDFIP3thiG4PFLivps01Q3QK4v/19UiJVgLv7nWAZ9LtSiueIJqD28Z3dWfJADx3tPGKhTlNebiGucpc59o/IynGsEhq0aVky1DAzbP1gMTRqs/a0c59lsgDFk33v2rweNXEzGxghDO4usmM9c3LhqlceLMmn8yz+6qrW/VAPsW4bAANeWmXQ9Pgo2QEeUDuXBFtpFAExM9RfJgnOdSbJEaqIJBas3PZ+v0jBSy8lZFjdP+BkLhUCOWzvspIyWoPlfIJ4wLauq+dsvxtjB5EVKt9541NTv/Tb8SpM9rTvpabGkdPOHcemVPPGHh7DNlVBQTTG6LgbLnqs50V3hJQYUb1xwxkuVor48fQxKyeMpLsRaj5Us0LZFdmrbPa90JFpSsafY+SrNrddRysOKsbhgEucD1i2pv4vTwhBbwVE/EsYvoe7ghb6SN7hoi6C3W9UeGR9iidgo/8O89i+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/2/2025 12:31 AM, Kefeng Wang wrote:
> Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation
> to cleanup code a bit.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/hugetlb.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index b16011c9645d..4f73b74a2cff 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1479,8 +1479,6 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>   	struct folio *folio;
>   	bool retried = false;
>   
> -	if (nid == NUMA_NO_NODE)
> -		nid = numa_mem_id();
>   retry:
>   	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>   	if (!folio) {
> @@ -1942,8 +1940,6 @@ static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
>   		alloc_try_hard = false;
>   	if (alloc_try_hard)
>   		gfp_mask |= __GFP_RETRY_MAYFAIL;
> -	if (nid == NUMA_NO_NODE)
> -		nid = numa_mem_id();

Looks like you're also fixing a bug, because the code block was
         if (node_alloc_noretry && node_isset(nid, *node_alloc_noretry)) 
  <--
                 alloc_try_hard = false;
         if (alloc_try_hard)
                 gfp_mask |= __GFP_RETRY_MAYFAIL;
         if (nid == NUMA_NO_NODE)
                 nid = numa_mem_id();
in theory, NUMA_NO_NODE (-1) could be passed as 'nid' to node_isset().

>   
>   	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
>   	if (folio) {
> @@ -1976,6 +1972,9 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   	struct folio *folio;
>   	int order = huge_page_order(h);
>   
> +	if (nid == NUMA_NO_NODE)
> +		nid = numa_mem_id();
> +
>   	if (order > MAX_PAGE_ORDER)
>   		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
>   	else
Looks good, thanks!

Reviewed-by: Jane Chu <jane.chu@oracle.com>

