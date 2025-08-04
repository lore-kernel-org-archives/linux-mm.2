Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824C1C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 16:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22ED76B00AD; Mon,  4 Aug 2025 12:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFF36B00AE; Mon,  4 Aug 2025 12:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032206B00AF; Mon,  4 Aug 2025 12:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E45186B00AD
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:02:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 909EF115317
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:02:25 +0000 (UTC)
X-FDA: 83739542250.22.532B3A5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id E21971C0011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:02:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VPyTu4tQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CYUiOWGy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754323342; a=rsa-sha256;
	cv=pass;
	b=sICjNfIn8BYMOHF3HbAom2Uk5bRG0nb6vGyswAwHhxO6ZkPhRIVIA/ifqoBXXFPE4Lr4mr
	SMik3UJkpWDyZfvJbWav8OMo0CLnq3YOYEmWWFx/gPm9tS76xdf5MCGsixW52IY+CJdbv5
	+kxY7tUN20fWQt2X/Y9L3UVn64H84Gg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VPyTu4tQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CYUiOWGy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754323342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJ8s5rz7lFwv55xqtF2wwSHoE3UtqPlBeNjnO4oa1bs=;
	b=fP4ZapYtODkwNh7T+wp4ih30vK7bRj81HsgPN1cD+BN0QZiH9gL8ukdMw/k7c2iFv0Epif
	RU8tJDLnIEmOhmkYjx47CvZgeZze8DlcBWa1Z6yHmPHiI8YFOHjGdZvA9dwTwfijv0ZWSl
	kb6+QuBeCp5MY6nnN6LKbqj8jS56DVU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D73S1009637;
	Mon, 4 Aug 2025 15:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iJ8s5rz7lFwv55xqtF2wwSHoE3UtqPlBeNjnO4oa1bs=; b=
	VPyTu4tQqL79qqs8GcbH8WUsEgDvIDTogy3h5s37qCFo1j1/squ0EtRevFNzvGp1
	bG2OuQ7eZSI5diLDMfktu7dWpnb2w9Pi6bueXGMBzoFHXq42+9dQengxEFV0fbjx
	Z9omqRHuwBqewpJ4TE6j+aE4cU6bjVmo0s+l4qb9Mef9POF6GQzGhbJxuSeajvWg
	2pFLL9bDob0RrgNoM1wXRybJJItDLJFKpcuA9UmWW0uhfWtrc2HnCnSitna+cJjg
	iyx0al7YZ5E1BXSL507Og7N7avQamQhV89siiXh3IJgc0dOcUji3QoG/B3PtVlm7
	yEkMpfdTvxInS80pYX5jPQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489b7xjxax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 15:57:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574FmfK9029040;
	Mon, 4 Aug 2025 15:57:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7qctfnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 15:57:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DiR+rzII5lUoHGjgIgBJYLaF0MlGcXDGCbJfS3vncCJjqREkHSPa07zNE7EzHgstUC+us4QZnUfwPjeaLvptQr3G4AHeRcK/qfF8Q1crbAaHoXacMrnQMLRWK6BofMGNKIew/7ib4Jbc5a0AL0fxr6nQ7lo4IMyA1NCI9tes/Ho3AUEkg3lta56zW3MF1Mz9xJqMZcMSDSlGhX80FjO36EyfQXyJzDYZT85aHwUk8Nm+HKPX/6eowmYnA21HCPKjCxX+QfIj8hF5IzuL7olByLY03HK8+N8wX47DjMAYJZ4ysUmt6YYSipwZw4lij/1feF4ZU0qh2G58JnfdAPHrDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJ8s5rz7lFwv55xqtF2wwSHoE3UtqPlBeNjnO4oa1bs=;
 b=kFIKM1KtysJOpraEu8WepS+nX/Jp9n8IJMyVBgJC3DEgxWA17Mzp51vSY4hmfEeTfS8HME92/AsED4goqCxhJl6uVz5zTfSeSaFaP9hKt0vgsloYee6HmTmw0+l/esEAPE2XsEVoHlO+xSAu+lT9X3U5C4vjHCbUmJrnTaNM7KSaNyG9SBnHNG1q/Tv+HXqyDQ6au0etCiGpoSXVL4OTgAbLKm84Jdj3hjy4Z/VhKoGnuoCgRGYfdUpwoPP5481kxGT5xlQAghrbN1ypjqSeROGyPDWgHDmp4qRGgAvVUiGqY0E5WALe2sw/pLa7JFcLVYc0ReJaHgu5pL8ECY/LAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJ8s5rz7lFwv55xqtF2wwSHoE3UtqPlBeNjnO4oa1bs=;
 b=CYUiOWGyA+EqK7tfkNqMt5EeFgwxwh/E0vLGeR21Iaoj85BVtF3XYRKbK8DGuMFn6XE7NeTGyEIGAGxIEXdV22hVTmRJ0IBe48eYgN59DGTENh4yS4kc7IcgqBjCgskPXV2JBVd0ALr08qc0XXtqojYc3t56jminQDntfzq/D6E=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by CH0PR10MB5035.namprd10.prod.outlook.com (2603:10b6:610:c2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Mon, 4 Aug
 2025 15:57:11 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 15:57:11 +0000
Message-ID: <4fdf9c74-e386-46a1-a468-2f93a62e253c@oracle.com>
Date: Mon, 4 Aug 2025 11:57:08 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm; hugetlb: simpify alloc_buddy_hugetlb_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-4-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20250802073107.2787975-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0054.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::11) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|CH0PR10MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: 402c775a-d624-4cf9-7417-08ddd36f929e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDBEdjBjYUZMWW5zeWhKNFdnUHBwM0ZBM0VwYldWM0daSnlYZHNDOTkyMTRm?=
 =?utf-8?B?V3Q1TXZZTS9CekcvNms5Zkp3WVExdkw4Y2NleVpLbGRGb1UzRWZwRVdHL3FK?=
 =?utf-8?B?THRnNktvR2dqM2ZBcUZuUHZ0VlNMKytLM2RLVmNhVmErTHNlVHZUbWJFM2Ex?=
 =?utf-8?B?dzdScWV0dGJRWHZ0QTBtYVlFOFN1M1Y4b1pIWHJMdkRuZ0ZXTmUzUG55Vmcr?=
 =?utf-8?B?cnJpcTdGQVk1UnR1eGxXVVQvUWVRd0NpdVBEOTV4VDBoWEFRbUlNQTl6NWdI?=
 =?utf-8?B?MjZ5YkxHY3VRRkc4VGF5NDlmRkRja3JSOGNlLzlpR3hXVlZickR3S1RxamNY?=
 =?utf-8?B?NThLVmh6ZmpBOERMdU9xb2pyMjNsQ3duajB6R09uWU9WdWo1NUVQaEY0YTBw?=
 =?utf-8?B?alJBcytwMloyaHlycUVzbUZkQTU0OFRSUW5TNXY0TzBuMld5elZadWhPWHNs?=
 =?utf-8?B?NU04RUFuNkxuUlhHcmRPenM0cG1MVFNFNjRTT2ZDbFprMWZ4ZDRQcWZXa3o5?=
 =?utf-8?B?WmpwUGxsUUlvS3dpdUFJN0R1L0xrWkRkREhFUmpCbGsxWUc1OUhXVUpoNmc1?=
 =?utf-8?B?Slc3MXJzNnBteFNiSXlvLy95bGVCd2ZEOWdKbFNlRU1jaHVqWnQyNW9VdUhx?=
 =?utf-8?B?VzhFeHZGNFdQaDRseVRiS3N0MVJoQVRTMEhsemlpUWZhNUFjR2ZKeUEyV25X?=
 =?utf-8?B?c3Q1RkpJcGNVTXhSS2V6a2pxUWFic29WNy9CeWJLRDlmT3BhZDFrMTdEL0lL?=
 =?utf-8?B?NzBERlVKTkVzUDFqR2hQUkd2Sm1lUWJYV3RDSTF4L0MvZTNzZE5TSDVkYWtF?=
 =?utf-8?B?cFM0Y0F4bWJBMnlUaGlxU0Z1UDBlTlM2R1YwK25mS2lYS0tTNmJSakhsZ0pn?=
 =?utf-8?B?VXpHN3owU2xScDZwNEtheTN6WDVsTTRPL1lRdXRGNkV6R215T3BkRXBHeU9K?=
 =?utf-8?B?RUJCSUNwemZPUCs2UWZpb2ZxeVBvVmJ3V3g5RHlWZDVZZkowQlhqcFh3SS9k?=
 =?utf-8?B?UzMyb0pROFhDMW9oQ1crT2RkeHIzNUg2bXJ4T2xiVXFUakRQQklwaXF5MURi?=
 =?utf-8?B?NDFaT2cwQVhGTmNuWjJROXpIS1NaZnVwZXhpb0dBNHczWFgxY0dnN2kyL09t?=
 =?utf-8?B?YWl2bCtBcXd5a2pMVDZHZ01nR0gxWUVPdHpxRk9YZ0tYYTg3RHgvRHlnNVNx?=
 =?utf-8?B?TEFUZlJsMG5rSW4rUG9NbmlPZkxZc1NkNnBGdmJEZ0s3aHcvZ0d1UjVqUzBj?=
 =?utf-8?B?RGlFYWdubmEzZmtzMmEydUk5ZGxORnE3eVJrOFJxQmQyQkhaU0w3Z2dGelFO?=
 =?utf-8?B?ZlIzS3pRZ2J5S2JPMHFkYzZpa1JYM2tKZlRkRGJzRndoVFhBZ3pxbGpaSEtZ?=
 =?utf-8?B?cTZPTFljNHVjbkJYOFBJNVM1U3h3OHNPUlZwL3lua2xVeTIwUEsvWjdWTzhO?=
 =?utf-8?B?enJDV25YRmFZVHgxOUF0TzBmeUtEWGV2REVoOFArMlEwMWJ2SUh1UitpNzFS?=
 =?utf-8?B?V2xMdUpDVDJITk1LVEhCSHdkSGQ0OUllMWtFL0JiRVlmWkphZlFBbDVvTm9S?=
 =?utf-8?B?NHErelJYellTMmNJekRtVnFmQzhwU1RhTmVXSU1adTNhSzU0TERibUQwaU82?=
 =?utf-8?B?eVRVTFVvYVpvVHE1akZsVFVlMi84SHNIRTZLT3pGVkV1RGFpTmF0R3ZQKzVt?=
 =?utf-8?B?Y21qWTluRkhnblQ2SVZjQ1U0RWhLSzd2eGZOVlNYZnZZQmpOREdXS2JkK3lV?=
 =?utf-8?B?a3Y3NEFGYUhlVHVlSEFVbktnOGVGYURKQ3NoUXJFUHZRb2M2UTFRdkFVUXV5?=
 =?utf-8?B?WmI5TFBZRkg5dVphRVlhdmw4Y2lYUiszMkRhMi8rVktndjN3Z2d2eHo3YlJp?=
 =?utf-8?B?S0xTS3ZzUkJQNitCVTU1dzFtUjY4b3B1ZUtXcHNCRTRvc09wN3R1d0J1SEVq?=
 =?utf-8?Q?VZNC2o1dbMU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHZPVzQrM21CN0NFdXo4bWVuK3R2bUdmcjhMZEpqaVRFTVZqTzNDQlJNSmMw?=
 =?utf-8?B?cy9uYmdUbENVSFlWY1VPV2NYZllROE9XQ0t6K0NjYnphb09BR3IwRkNyZkU2?=
 =?utf-8?B?UUI1T2VFUnEyUXZKSFk2TFFJMHE1U0VVT3U1MitkOFdYYWljVzR1cWVkTjFr?=
 =?utf-8?B?Q0N3ek5VTEptYkcxRFVmT0JNTUdpUDhEdDhVeEkvV0gxWlB1UDVPKzI3Y2dI?=
 =?utf-8?B?UzRuQlZZV0ZUTTUwb0ZVdGIvQTJjRk1tWWNkcEgvSy9NRDhVVTNKUHNYSXE0?=
 =?utf-8?B?WldyMkc5UitVeDI3MHZUQitDNXUzMXErVk02WDBEK0NEODMzVkx1bDR6VWNM?=
 =?utf-8?B?TVFtR2ZyU0xINVkyVnZrWkI0dWFJaFZNcHNiR3I1dTlzWElOYU1UL1VCQ0Yy?=
 =?utf-8?B?dnUwN09FWU5CbnVDVEdYSkI1MW5hOW5HaTczTW5ZYXlTeHZGbzhOdFV3TUlz?=
 =?utf-8?B?WTVwV1VtTWZPK1lSK0FST3phbzhYWGZ0Qkp0M1d5T1hHaUNXazJaanBBQmx2?=
 =?utf-8?B?dE1rR1JLcHNJd2hjc2JuNWVGUkdGTFp6VTJPSjNZVFd2Y2RVNTFPd2lmVGpG?=
 =?utf-8?B?Nkg5djRhTVR5UHo1M0JkWWVyK1hYVkNMUEFiL1kvOW13azdaN0Q4dXRFcDBy?=
 =?utf-8?B?bFdKU055UUpsKzJ3MXd5QXJYWDRFL1dpeHpkRGFGeEFIMHB0dnh1L1VTWUl3?=
 =?utf-8?B?dmpEWDdEODdPTmY0dWhVcmkxVERENlF3Tjh2SDdOZU5qenlCU25nRlJCVDNC?=
 =?utf-8?B?M3RHSERoQ3V1eElEcjN0UnY5dGEwVEprWUF1MjBtbnZBQjVtcURxZE9MRHBj?=
 =?utf-8?B?cmVnMHNmRHBFOHA5cDJWYjRMTTNFL1RXWjJIQ3d5ZENEK0RnazVkaFU4eGhC?=
 =?utf-8?B?Mnhmek9WL292UkwvWjBJZHI5SHEvNmhFcWRuRmk1QkcrRExYOEpVd1dleVFU?=
 =?utf-8?B?ejl0VkdVSkUrcVFUeU5OZytzaXBMeFFJVTFieEJhc1I1UExpY3NWVkFnSCtY?=
 =?utf-8?B?RjNoVlgzQkdWU0ZsdlJrY29zTFU4aG80YUZNeHE4OHc5Y2dKY3VWTmM4UUlq?=
 =?utf-8?B?Tk9MblFqUTE3SUw5cXh3WEVNR0lMUDlKaVRJN1pRRENJU3B4bGp3a3ZqWC9L?=
 =?utf-8?B?TENmVVVsU3JzZzNyOUlNTzZ2dUh3aFZoUmN2MFdPa1prNTFwVkRHTWxzWkpB?=
 =?utf-8?B?c2EwZEJtT3dsREl0eW9tK093V2c5ZHdTSEYxZG43U0xnUWQ1RWwyc0sweXpU?=
 =?utf-8?B?RjFNRTZHVklUdi8wdVJHUFROd1JBc09IZy9pY2RrclRQdUxvOVFPUEpMZ3Zy?=
 =?utf-8?B?OFVodDRSc0VneGRYSldLZXJkSlFPUGVKS2FrRlJ0Sjg1VHFuREtBQ2d6cHhE?=
 =?utf-8?B?TFRxUUVWNGR4VVU5dGt1ajNYdGtMZUNqMmRHeldyQTlFTW9lWlRsRXNqZWF6?=
 =?utf-8?B?ZUlVbXdvbUwrV3dJT3M4anBiMThOcmNPemVOSDVDYWNWbm1UaDl2KzBITzIx?=
 =?utf-8?B?ejZSUGhST0ZWQVV6Z0gzNzM5L0JiaEZYbE9ESWIrc0RvbEhoQUJyRXFPM3ps?=
 =?utf-8?B?aFdnaDVCVWZiRTlRK3dmVkhrM0lkZzh4YWhjaUVGR3RjT2JUQVZTYWtEVVJK?=
 =?utf-8?B?QTZhWnllVSs0K2p6TGVkVVY5bUhwclIvQVdXZlpYQ0doTDJjRlNDQ1dvaFF6?=
 =?utf-8?B?RVBCNXNseGpQdkgwR2l1czY1SjdxNmV5bHdGUmJuK2N0dFI5T0t1SkhTUjFK?=
 =?utf-8?B?SVBJckw1MkZzNHlybzNhVllzbTV1M1JqS3lyenIwT2l6QUlsR09lTlRObE1r?=
 =?utf-8?B?OHo5K2pCZjRoZU9pd2xHVEhKWjVXSWJjNCsveUw1d0IySUxHZmV6Z05zUXp4?=
 =?utf-8?B?dk9ZdnhkSm5LOCtFdm5YUHRUeDJrQjFPVWNaZm5IZnpZaE9QWkVKRG4rTm5X?=
 =?utf-8?B?T0tleTZiOXErQml1VXgxV2FidGZTcGpDNXhucWlmWWpFR3hOK0Z2YytxclEy?=
 =?utf-8?B?aHAzRU9oNGpTcXU0S3lHZVhLREE0WkJoK0dNYzRtTlBWQUZoNC82ckREdTk1?=
 =?utf-8?B?UmFOZmlnS0t5dDFGSTFJZFJLM282MklTUlJEOUlBQjlOaWsxdWtEcHU1K2RE?=
 =?utf-8?B?ODNOUWNxQWJlN280SGtHUW9IOXMvb0tLU0Mxa2dYZkhST2huWkppamZ1Q3Ni?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x90FvV4QHa80fRhh0qhRwv+3VtoLdzgAomEgVt4S5V/qTTyvfDb8xskjKqHscpSOQBOJSSRMui1XcfpYPkRBWM1MnIv8uMllJuO/VOj88gmK4iOCKWUsGMlom1hP3WMc1Jj246egusWD6hHzwiynNnhW8XTqOrgX9kr/hq8HhXrlchjWwYyNjimVRmZdAZWsTbvH3AzIwEzwS5ESNWtP3hqzeMB/rHfGhdm6DOJ/k3IJittu3Ha3yGPttm820iXW55ow5UwtAw8DKPHEK+AqHQYBUKxyCv6VVocjXVRJJ22zMUHxlKdMss+VNDlWS+tP6xrShQ68YCYM1IjouUGvFoy99gi1NCUDFr8a53nSKB4upaXBmygUN2WR4SH/wr5wk3c/pcUOFWQztdxt6cC3EEOWdBJzdnlUxwnOtC29bzeX3rVR0I2cJJZClkIv02epalQMzOcYeIgAgFHnLgdQnzqPLkg/SezuzqducjQIUo4Z/GK3Tt57lFv2bHm8WJYzxwNHwRvEetJVX2jcvfHhyTzrqk6+DWsMhoKZaRwTiiRqM2fZnUBCMjvnsZSK/cUjdMWiyDtVeS+BZsqDJi+K9mguqKdaL/4DCQoyAL/Z7Sw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402c775a-d624-4cf9-7417-08ddd36f929e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 15:57:11.2990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oS/hSup17QABhO8FOAPM0uMVbbtAqMAw5salL7ULmnvoTWgpAPuoTXAbajdb/c82nwNKXvnklXJLp/HOz8qYOmrriWZkhqQJzU2C3wVPkCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5035
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_06,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040087
X-Authority-Analysis: v=2.4 cv=MdNsu4/f c=1 sm=1 tr=0 ts=6890d85a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=SK3WxMluIoBve1eYTGUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: iSer_r5p9JfKp-Ku2K2YD2UowdtUBFn-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA4NyBTYWx0ZWRfX+koC1eIJADUC
 pGNkXHioydBBo2s3FiHhA3sCyrUYctc8smqVzsywPZUA6yO3w/gYcdYpmFVRz3vUf8R4FkCOMzP
 BEBRpwqFwFkxigDqiKEFqX991v3O8NnnRZD5ezJ08CgQkfcwCTXFezS5O6EkIIOJgTkj6paORIe
 sCvA5iC+p499vMC2CAbe7n+lWepkYu4EcM04tfGmKKEOwgIi5o61L1dVvhi74tUzMGLb82B6OJn
 zDvBZX8BWmPJzjAX9wslGezcOZ0EbUt8RTOVR+3aO7ZKi9cCIXz5pKSOIa/HnmaiGvyVdoP6OP0
 7mRl66YcUH4KeS1zunpOlwG61+cTokeppfwdMaLXJ2Ee95fN0PYSpbNsNqkBKWsoXDo0h6A3O+B
 kL8M3F+LqTQEPZb+rc9msdDZujfJcaTv3WG1kRXxpv+IVsYyu1yDknOJDx3EfJKBjuoRxTQB
X-Proofpoint-GUID: iSer_r5p9JfKp-Ku2K2YD2UowdtUBFn-
X-Rspamd-Queue-Id: E21971C0011
X-Stat-Signature: krfyr44tc7fhyhuagyma5g751ucyhmd9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754323341-788101
X-HE-Meta: U2FsdGVkX1+2hf6D8wq/+y7SUpZLBQG2vgdqVpeODks/8RkDH60l2tMvpEPBEVmBtTlDM5J+3OmgzPpxFoMW86FusLlDXdI7dhr+B+MoFnrsrR17REq7G+lrwSJ71W8CK6lnrLK0+KWtmAHzB54UXuDiUtIGUjTnme6YrZN/85nk2DTrXxod1AVPZZAenUnCOPxPV1B4zzfYOjAlFVGi/5Es+FLCQD9dEjXetOnmdBau1AsRaFSp4wCLC9rCheTcBJ9yBpqX3NqsHFhNvQbaQ2i/dwTgw1MFYPDrk2VMN5Fqu/19kfi95NeGftOw8RzWBUrogcTcNwwYfTeW960j7nFV4lnjxqXZjdYV5qLVJFvg/5ZGvHcqhUoIppuEKy0jo1+j/VIiyC5sqiflUAZFQXKpEJM11Gfg+65KmA77BbuiEw5UTzPKx2UnJ9MjXJYXCKf7+/fght7BBDuus+2XwhDmzO7wyvHTrj0qNeXsSQ4XT48KsEVtQwFOtjpGVhMMQgkDN7BMRw6Eg/W5u9tkmjk+7MbZ2rJMuNY9gTGZUzgEiWo9pateVfC6ny0ItXZoXCr7tNMOsTopPbiKeVntPK5DQJh1FneOzSK+6rZ/pwcIT9+/rsY31p4F2xpoF6WywYfHSrPjNsH4u5He1moHLrW/uMEvtPpLlWGHSohl0Bp3JxyBr6PIpLGmdKc1TxNsu/rR4gE0wihA6V3llyjHq/ZkEVooPq5T2EFD34T050vbIMP39N6iqpBS5n9zNq64vPskwC7aw5GaF/20Ksex+uIkvlQD0wNrDnf5d+7stwsZArJbcicF3NdYCaB8T559iLUsKt/+fIRUKeQKjU/WkJgnavS+TUORJRC8r1iwkiVhq/K02KM0CQatv2yVDmVmrXeZc5YMX4hBgfloAhlvAiHakbMpGXQvhQxhDxYABN4Xmq0xroc+j+RPggLGKdGfJGyniRcRMxuJXn9JWa9
 /mBqsoQV
 yFsH/pHEAwxpYOOFBBzRns/62j67uQztTfbpaNkPMNBAoGBYk5r7GfcQm3xPmc6aPGiZZbLVoC+JjPpXRIdeOX3ybw9T3ABoEc1uScaAlor/LjO4FI5FG/KlxRgXZVpAVn9fG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/25 3:31 AM, Kefeng Wang wrote:
> Check folio once instead of three times in alloc_buddy_hugetlb_folio().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/hugetlb.c | 37 +++++++++++++++++--------------------
>   1 file changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index afec5a6a8aca..436403fb0bed 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1949,29 +1949,26 @@ static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
>   		nid = numa_mem_id();
>   
>   	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
> -
> -	/*
> -	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> -	 * folio this indicates an overall state change.  Clear bit so
> -	 * that we resume normal 'try hard' allocations.
> -	 */
> -	if (node_alloc_noretry && folio && !alloc_try_hard)
> -		node_clear(nid, *node_alloc_noretry);
> -
> -	/*
> -	 * If we tried hard to get a folio but failed, set bit so that
> -	 * subsequent attempts will not try as hard until there is an
> -	 * overall state change.
> -	 */
> -	if (node_alloc_noretry && !folio && alloc_try_hard)
> -		node_set(nid, *node_alloc_noretry);
> -
> -	if (!folio) {
> +	if (folio) {
> +		/*
> +		 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> +		 * folio this indicates an overall state change.  Clear bit so
> +		 * that we resume normal 'try hard' allocations.
> +		 */
> +		if (node_alloc_noretry && !alloc_try_hard)
> +			node_clear(nid, *node_alloc_noretry);
> +		__count_vm_event(HTLB_BUDDY_PGALLOC);
> +	} else {
> +		/*
> +		 * If we tried hard to get a folio but failed, set bit so that
> +		 * subsequent attempts will not try as hard until there is an
> +		 * overall state change.
> +		 */
> +		if (node_alloc_noretry && alloc_try_hard)
> +			node_set(nid, *node_alloc_noretry);
>   		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
> -		return NULL;
>   	}
>   
> -	__count_vm_event(HTLB_BUDDY_PGALLOC);
>   	return folio;
>   }
>   


