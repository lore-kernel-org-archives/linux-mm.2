Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C3BFCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4FD8E0006; Mon, 13 Oct 2025 11:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C9D8E004E; Mon, 13 Oct 2025 11:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644EB8E0006; Mon, 13 Oct 2025 11:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 476088E0006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:22:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8C6BB8172
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:22:26 +0000 (UTC)
X-FDA: 83993457492.05.F0C7CE5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 98D3D1C000B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:22:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="DD0TnP/2";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KV0RQaFE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760368943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p02/J/evFfMSZsD7t1lxwS2K3L/jaxj+Ik4PqUhXMJ0=;
	b=2l5rcjZl24zMa3R2jwnkL4Dyqf/HL07nX+0TZRGWUq72QBb92mm8kcqgGH2RMIsqV0Erdr
	sIrUXv7UIsWRy+Gul15mj5gHieZ1itMxtYf1n0oKeJiKIYi1x78wCQji8m3cKQD67Aodwv
	42BvfJ9pT2gZN9UfA1J0dPC9RlGArkY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760368943; a=rsa-sha256;
	cv=pass;
	b=Njzhrv1gwq6zxpkZkxCm6ymTdbQSdn/VPuDrtsxm4eVUdZA1UOlF0Yta8TTLKqUJrrIBor
	fbVLN0qxjEePbHp0GYt9in4O2VrR3EHyAos/JYiSCSPADIpWCBO4elUtneCO/V12NVteAN
	30x45pjI1GDwErPJOTUWIRF1r8Lgnro=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="DD0TnP/2";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KV0RQaFE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59DElTKS023896;
	Mon, 13 Oct 2025 15:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p02/J/evFfMSZsD7t1lxwS2K3L/jaxj+Ik4PqUhXMJ0=; b=
	DD0TnP/2TzHCiWvyYmvJDWWP0SaIyr71Bgy639pnhgXwSVHITOwMuuigN42GsHbF
	ZUGAmoJ7tmxgbpQSzQzU0xXHjL7eNkXzG5TuNIbH0Ql7MC8SSfxtlLmxRwdOpi5R
	PhK+uWNIYosD3f+huNJx5F04U32CCoW9aUZnOjs/JpKWhXUWIMyiQT++fmjNi5cd
	0Qpk6wLf4oPAcjC0eju2E/BHur1I3lnQNQq1BGgnCm6QrDWXMQHhruI9YyWtsXV9
	HIl91/k+iNQoBT6Te7z0HzsHxgLUYgKYLNcWga4ObB3+Jloqj9cMNqy/xQb8hDeE
	GC6GoK45bQ5CcGZxOYE1Bg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1q9kmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 15:22:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59DFAEVb018357;
	Mon, 13 Oct 2025 15:22:09 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp7f3m4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 15:22:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=leC82h0Oy4yiy0i7XJ2UcEud6mXHjBRVz12jKxiCKKKGQD7Hreq6UqEo2XWR6nq0sJNC6ptkocvTQeWTAX9KLn/ISkjo4fW3WLh8Vjj+V8MOn4g3kHjjl9yJB7AzyIsyeApZhT6S4G/XW1GrnVlDQL5vyXN8vJtyzOvyN2n39FDCHVwVyeP4V5HvbqyO8n3Yr+6rNRgrMSiNEkqmO0GYGQLCmoMNPMTvRig+p2W5+edjT5EvIRpm/37rJ9djG9RLfauTUWQrhNg2nw9lQBQh2eLKXgl2veTs8zyri0cqZMvxRkGFnBBYdCk/DnbLyxhM10qbX/wX4JHJfXh6K9p9Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p02/J/evFfMSZsD7t1lxwS2K3L/jaxj+Ik4PqUhXMJ0=;
 b=q3hZ0yyS6mqWxxPf8dolBxAm+lb7AVk9Qrf5NiAqndKmTKZO9h0+OoRJT4wtRRJxF/ZBQeRvh7TaiclgutDFBcQMAK7w6DMsVFXOw4FIKBCeB3HXbs+e56nW6ogA34l7oAxlKnQJMl8u01mhHJL1UtlUTTHFtY3ckBxLvnoJhRQlkJLSPrNUi9kQtwrOF/PRBNdeVPIw6aBHpc8n8g5iJWy77YtZTaMchD+a9z78N2j9uGwzrLojbCAnjyooHNhTjJVy+6C0hYqr53+S7yvQDKGzCh895ZI89HIv9c0PdCneXprtOU9JLlxTBB0svaKxIlQg80NvBjyP+wb7Nlx9Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p02/J/evFfMSZsD7t1lxwS2K3L/jaxj+Ik4PqUhXMJ0=;
 b=KV0RQaFEsrj5cs1CI0y9p6pVQRIOUZdN10ajMLGOiCj1iq5oRiZxkG23TJGYmQ3gbqIomwIn6gPZVPDki+WBBNmTZj1Vfl3IKg8ClLsq7Q9C47jsa+6fk8Cqvs4MqkngxzaKJij4qWSVPIrzehX5/ZIce9XPLDUGELQAOemLeyg=
Received: from CH0PR10MB5113.namprd10.prod.outlook.com (2603:10b6:610:c9::8)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 15:22:06 +0000
Received: from CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2]) by CH0PR10MB5113.namprd10.prod.outlook.com
 ([fe80::eab6:6dcc:f05f:5cb2%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 15:22:06 +0000
Message-ID: <b11fff4d-dc8a-4ec8-9b38-4ea1203a5c62@oracle.com>
Date: Mon, 13 Oct 2025 11:22:02 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: mprotect: avoid unnecessary struct page accessing
 if pte_protnone()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::20) To CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5113:EE_|SA2PR10MB4665:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cd1cbbe-a201-4c3a-8eb4-08de0a6c44d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bW55ZTlWRDZoeFNqczJoYitienZ1YWcxMWM3WVVBZTZPTVozTWxaVUhaWFRh?=
 =?utf-8?B?N1JXM1d2TE1JTnVoc3RvWU0veXI3L1QvVDR0dXlPOGk0MFlmaHJ0MjZwd3Vu?=
 =?utf-8?B?bEZkMGp1Zmh1SG1CNnR0Ym5jb3NpTWJGYUFpY2JLcnl0cHJzbUlzeER5cUYz?=
 =?utf-8?B?RERVckh6eThGSEZrN1Rtc1diWnpsZGovN2pRU2tmNVhYSllCQUU0RFJUcnJP?=
 =?utf-8?B?M1FnM094bVpKRUVXUFBsUmQwRnRtaFF2K29ld0JjbC8zSmVGbXQreHFiVkpi?=
 =?utf-8?B?OUpJTUltbnhZZ2krSTNnQXp5c3pPQmtjMmN4cERPVmdLck5SL0hzNG9NbUZQ?=
 =?utf-8?B?dVJZdjhGS1Bkc2tUTVdwR3p2bDk4THI0b2sycU50cTRXQ1JqZVhWcklERzlj?=
 =?utf-8?B?Y1Z0REdYa1lUSVR4cGJnSTB0cm12NXRVUFgyWDdDeXZtbE1jbWU5amQzZkVK?=
 =?utf-8?B?T3dFMUI0UkR0TWx5Nkw4Mi9oY1pudzZSWHI3VTM2RmhreGxlZ2xDOXZlS2FN?=
 =?utf-8?B?UWplRDk0bm85S0QxajJtcS9TQkJhbXNyVFE2OWZSWXBwa2wwdUwxNEZpL0tz?=
 =?utf-8?B?MWFSTFpLWGxTcWdnZUZKNVg3NkVlZEovYzErR1NoYjZwU2sreUlmU0h3WEdS?=
 =?utf-8?B?NXhDNU9ZY1lqRVdlMzJqY0RaaEl0TzJjZW91YlNtQjg3OExqTVBNUHdac3Js?=
 =?utf-8?B?T3RodTdBNWdYK0NBUkxOZ2lCejNHWEx0T0N2aG04dE51QWtPczdIZE9VZlhN?=
 =?utf-8?B?S2lMbkdYSXpqaWtHbnNFZDVIWlNGaEUxdThHSmU0ZmlaQStlVytRem5Remxj?=
 =?utf-8?B?YTJpRUxNK3hocm93WWJLUW1qVnpXb3BUb0V6c0NCOHRkRThKbFJNaktCTDF3?=
 =?utf-8?B?M0VZaGJ0RnZZZitCSWFvQ0Q3SGF6UUMwWUhHZGEySUVHMUZhbjBGeklhTUtp?=
 =?utf-8?B?TTRxQnI3Qyt1Ty9ya0tWTFdaY240NkNoU1lidzJaam9FbHh4cW16WmRRS29z?=
 =?utf-8?B?YVRiL1UzSlpUTWZnYUx5czBqUVd5UHFMKzVQaFV5WDVMTXNrczA0Z0t0aC9t?=
 =?utf-8?B?R1hFSXBxNkZReU04SHNHWUlSNVR1V0NJNFJUQ0ZSNmNPWkZYQUtRaW1zU0Fl?=
 =?utf-8?B?aWhpZW9vNDluSGxYVWpuV0o2UTFFMXNjTi9yMmdZY01SRXZndkx0Zko1ek5G?=
 =?utf-8?B?ZzdZOGp0RThZQi83eExvNk85RG9PTEcvL3A0NUorZXY0TUZtdE1UTkxSNUhZ?=
 =?utf-8?B?eXFxTTQ5cmFOOHZZcFF5dHByUENYcDVqeWxneTlnY0U0dWIyNnlKeDBNOUpT?=
 =?utf-8?B?VTR1NWtIUzlUeWJzL0ZZUWt5REhXUFhWSWZNeXlGVHVCOU9Jbk5VV2hBMlQx?=
 =?utf-8?B?dksvMGFJZ1ZZR2JHbGhkRHhDTEhiUnRFVnl2dk5LeHJJOFRJN1V5ZTZvMzZK?=
 =?utf-8?B?dWZ1YW5lUmRqbmVuczVFVndKYnZpQnE3L3QxNlJqZ3FaR2w1QWFsMGFabzJo?=
 =?utf-8?B?WUdWQlZwcEptTHhZOU9DSmFLZWd4OGJ5bWcwY05BZS9ON1pRbGFEL0pCaDJw?=
 =?utf-8?B?ckU2OXJhVzZDZ3UrbUdFekwzRE1HdXRzWHcyV1VGVVQzaDNlSzVvWVplN2M0?=
 =?utf-8?B?ako0VHFhblNhUDBBSlZPUk9hRkxqTlYrZ1o4clg1YXdKNVREeG5HcUlCajZ2?=
 =?utf-8?B?a08zcHlVcmV5bW92bzc2ajhrWi96REZlcVN0bHpqT3diU1dwT2crNjNkb1JF?=
 =?utf-8?B?QktOUTdDRTBPT0QwMFYvTTFldWszcW9wVDZXdmdlNzJMZCtoSFAyN3YrSzZW?=
 =?utf-8?B?SU5xSVpYeWpPSW5GZnZlaFJVRE53Q2VVSERhM0MvQ1hQMmRYcTcwU3I3OCtr?=
 =?utf-8?B?OW5mNWxBcDZ2MkRyWVl3b2w2TlVBMnlDaU55a2MzSyt5Q2tXSXBFcVZraGtF?=
 =?utf-8?Q?Fi3w/rYFVoDzDjtAC+pYFF58Y7+Wkze1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5113.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2M2bHZRTXFwV1JZdi9xVWJHOVBvQis4NHI2TG9kMnBrOEYyTVBXT0djdVlv?=
 =?utf-8?B?M2NoaHd1bU1icVVVbWU1NU1UaTAwS1NHcE54Y05lYlZ6QTBPWHI4YVJaQWZh?=
 =?utf-8?B?aEpkNWJxVzgxcGh6bG1RSm9hbHBtTVRFdnpBYkp2SnV2enExV0x0cTNzTzA0?=
 =?utf-8?B?NW9tQUZPVXBCQ1BDZ0l5K0NHUDc5Z3hnTkZ1UFFNQ053Uk9QdHNUOUFUbGw2?=
 =?utf-8?B?OG9SbVFvNXFBRm5yN1RUVFdVTk9Idm1WTFVVS1J4TzVVeW1iaGdWcU5TM0tu?=
 =?utf-8?B?Y1lDVEpneTNBUkllcVo2NjhvYitXekFBS0IrNFI3K0JscmlkcER5UWQ5TUVW?=
 =?utf-8?B?cTZ3dzVKeXdHOU9xeUlKWGl2aHVsSnIyQU00QkNtb3A4OVo5S3h4UWFVaHdZ?=
 =?utf-8?B?ZHdHOVpmV0hBdmROczBXTlZlTUJ0SitBNWVQaTZtY1A0bTRqTFhERElhUy9s?=
 =?utf-8?B?NnJTYWJHV2Rib3dVYnk2WWNocGFEdk94aU1ZRFpZSG9kcUtsTGx6Z0FhM3VO?=
 =?utf-8?B?TkxVTWplR1ViNURTTjNOQ29Fc1NqY2t6b1ZCRHpYelZ5YjhObFFTUFUwcVhw?=
 =?utf-8?B?QVZCNWtXSHlMNDduL203QlA0SEV3Qyt5M2hpZTJZRklDUG5wbWcrMitjaGNJ?=
 =?utf-8?B?eVJoRlRiMGFUd2ZmUk1aRVpNRzhBU01qS1dKL2gzSTQ5N3Y0NkpteUVXZkRu?=
 =?utf-8?B?akNrdS9GSHliQlRBYXNYTldYUTkxc082NFgvd09MWU1pK1Yrb2trTkRvN3J1?=
 =?utf-8?B?V3BYOEJkRnZoUzg1UkNFTC9xZ2JUUkFoalZzS3lZb3AxMHl1Y1MraUpya1NH?=
 =?utf-8?B?cGtFV0xZbnRFa2F4ckZtNU1kZSt3dHNkQ1g4Ymx3cHVHZ2Yyam82M0RGM3Fj?=
 =?utf-8?B?WmJQLzVENTAwL1ZqUno5WisxYVUwWU90KzhlU0g4VUh2YXM4K3RMYXlPUkNr?=
 =?utf-8?B?UTBscDBCa0tTL2ZlSUpjS3pVcVU5ajhMTzdUY29KWlpnTmlLb0N5eU96Y2lM?=
 =?utf-8?B?WWFMTWpRY25uVVVaK1BiZ29kcEVIRkJFaGJSejc5SlpzVVZHemdOUTRaV01Q?=
 =?utf-8?B?aXQzdXo4MTY4dlp0Z2FzdE5UOHlFUVI1V20xajR3VVppK0pKQ3g1V3hqUFJ0?=
 =?utf-8?B?Ykp2SXRwRFhPUmdycGVRbTUzaWxZK05XYUJOYnE0UmR1S2YzYjNwcUpZZnR4?=
 =?utf-8?B?OXA5bnZUTG9aUldkcDB1NG5KZktIQ3BYaTV2RnJPdy9QNm5FK0VWMTA0Skgy?=
 =?utf-8?B?WDFzT1N5U3BpWU1FS0tKR2M1M0t0U2Fnc2xpUTc2aXdvdCtnZ3ZaNnl0ZHN6?=
 =?utf-8?B?N1BWK0tmQ3grekE4QTltVTVUWDdTTlh1Y1phc1kvWDVtTVY4NmtrUlc2OC9y?=
 =?utf-8?B?Qkw1d044VkVWL3QybUJEbkgzRDNCVVlHK0NKQ1daWXFZS2pWN2dOVmpQQVBO?=
 =?utf-8?B?VUd1bXBxY0JoR0k4eGR1Wk10bE5tTVZhVTg0MmdVWk10ZkNiNS9MaGlFQWRK?=
 =?utf-8?B?ZHFEOFY5VHZRalZPdkovNUpZaHRqUkRHRnE2cUZRTi9SaXFHTklaMGhycjZB?=
 =?utf-8?B?aVJodXQyaUdoN081NzB5emVNYXBvK3Q0MDNRSk9lTXpLWE1BNDZmdTYvRVUy?=
 =?utf-8?B?RUZOeXRRVk81cHVLTHpqZXNJdWxWRDhockM4M0Rpb0RRZk5neWpuKzhlU056?=
 =?utf-8?B?dzk4UEYvK29FM3c1TUJad1RNVDRqVHBZTjBKNEdjN2Y1WDRiSUZPZEVKYVc5?=
 =?utf-8?B?VTFrN2Y5QWczQ1ZDbUg4YUoxRHZLQ0N1emVpVEE3WGVNWndJd0lTVGhkbmg1?=
 =?utf-8?B?em1jNWlvMnBFNWNlNmN2R0NlblJXQ2cxTkRDdXNhajZwQ3VDRmFBZkdQUVQy?=
 =?utf-8?B?aUJJZWdmTWpXZVgwY2NzOWtHRXQzYUducTA1Q1FLTmhJaEp5bTN0aDFzaXk4?=
 =?utf-8?B?MVkzdFNCTUZzSlQ3RkZJM1E2b2dvelluWjB3cjNUOXBzUldabXdKelJHUlpQ?=
 =?utf-8?B?a2E0RFBWcHR5NTFqRHZHbXQ0bjc1WG8zbGJTR3ZlT0t1WFJ6bTc0ME8zQyts?=
 =?utf-8?B?OWN4eDBLc0gxVVFRNG1LTWY4TUphT0wyMUhEYldRUzAwdXlTQXRwbjRhdGJG?=
 =?utf-8?B?R3VQWEY1Q1pFdWdyMzRZVXRQZTNETitqY1BwUzZmeVB4Mm5xTTB1RGpNNlUx?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eZc4x3zWb6nu+ZAK3iqfVns/tvvqiWMuVk/DGkYJnpMIvKIL4XeMRkBXA3gaoJoBShkX1xFdOYk/2zr80a65lWPk3H5PbkKIkoy4mWMHWUW0N9WXUChWAP+4Z7PpXRRtzZDutoRaLjfgQFUNKEk+Mv1gpI3JBSod0D5O74ZZ853B4XwKzPwW1/bjhC7PUhME9tX5n6QWnNcOlnodV1t22HGe9HV+T10RQIYnH+wSXXevq7uIWLZCEtIAj4UTtVZivexaI56PegVYrzuMjW8bAzZLzD/UA6OjVZvWu2715W03vdYrEgmQO0GpjEPMcImBX+ObJZv/L2Lztj8TMnObJqAi3U9Xo9IyIKrHGsUq3ewDdwqwoYewTd0R0s+6T+MJogkItvYRJIYSnXe4mjsHkbOJ4YI0IPzm5DDcdx00sgCEl0lgAgSJeWROth34sAB7SO7qWM9cxGDhYyc+kUNKW8OuaTuceGjgJGx0ujZelLbuJRPt2g3TKJc9vqWjw1abmWLLV/lYNDlVLNsrMzTupXS5H6JVmjsUyUucagZorml0XlLyd5XMx2hgfvl53oW2ZjoAf6YloUIejTrPtLGN+8yTm5nKfJIxXBdFfN9hJiw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd1cbbe-a201-4c3a-8eb4-08de0a6c44d7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5113.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 15:22:06.3319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NjuDGyw8xfOpxR0BzqSuCKycfJ3Z8L6SwDOkQ2q72BGhnH0MY4ii6dOyGrrGXoCpp8mWrkqTjMSRUBILbMWxWrL7kHbbX5Icex4Rq4aLIMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510130068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX2/R2M/f14OeZ
 r46PFqapiskMTF+2H+HeW5s7UF5cI/X+sqGW5Uwtni6JLaBSi4jan5hDIMD2/oRdZCnNsTkJPr3
 3Irh+aAn6E1c7YU7Ci4grMAQ6vAr117Ve8sgsshIKnjGKsb5fi8DYJxS5Wl9LgL9TL9whTmtUvV
 nLzJhI+/fBZ4aFdnkolLbY84a6YSF4i7Y0eOEMNhwb0DbEPX3nznL/EbTFWmzAB839Enmko+n3X
 TDEzFJ8L1PgFmuwxg72sBiSJ+6c+M4HwLlp7iv4ErmecPXzlvDS7SGz08Yfz3/ofht2TYrTsrVo
 vGp4xwt3LaIwMTDpQY0u+hSv0zC2rPjOoY//yoj6tRfhcXR3mqOADpWbb8SooVsGKqobz1r50U4
 pakAInLUZ7PbQTYKHSkkMbojEonarA==
X-Proofpoint-GUID: KcDF2fB9GKX7nt6Uiltk2wCzD4GB2pAD
X-Proofpoint-ORIG-GUID: KcDF2fB9GKX7nt6Uiltk2wCzD4GB2pAD
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68ed1922 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=P4zszPnidlUPrBzV5QMA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam01
X-Stat-Signature: 51awrqscw16pd5uoscfx9m4wa6zzwkmw
X-Rspam-User: 
X-Rspamd-Queue-Id: 98D3D1C000B
X-HE-Tag: 1760368943-786537
X-HE-Meta: U2FsdGVkX19GJ9vPU8SYByKoQR+UNQEZbikpC9EYRaIsiXO2abuCC0Y7lzFVNs1TKOCIScvHZ1Fig0T11gynjUQdtESUmEZG2ELCfKXC8/hI0dbeatlgfT9OA10c/rUwKb5OrjbuKgGOBf0X/4PdWFpLbNLmSTVyM52XG8kCUV36jiTcgSkDtmUF4eAuZabCIHp7UgvH01eq05xpOlE26n3w07uU8y42WLFWa8rU5nq2Yi9VkK+fxMM+X/zENfH5kR+ODG7Zvpe9ENPEHe9nxk5+4/QQQ5/0MFZ0eeMBmgQv78Luqmb7i26SzN4ukZOhHG9Y06kLknhoLOaHZhAzQ7i8W6hc/iLOfHxJdyuT6rFXY9c+z6jX2pbqWsUZ2bgNRTnOe9RzuJ6J+dSQjUDq4G7D+z+EPbWm7mmaqNqN/CW/re1gRqEl3x7aFdJpnwAOKX3y9SH6AJAOsbDU/aR9lM7KT9wU0iPHqn6Uwnbhrp68fEWKSq2wYVDsTqhlegr5BGLXOiU6QD7L0smQymP42X8T+FpV+KcCykUQS3d5IJi0TeNjo0SU2iyzGeWZnPYgpwUQHQkvK4KdErWThSIqGuiLooGaR8bmmP4SYkLaRrbMitqKslrHKnUiRTkV3ldX2MjFOZLHs3IT+R4sh8w8tU3pgERVLtsjLUbNNGQteOP3lOFzpkRUBYd9WcBcNSKYJEPCGBSCvbK8jryxTJSd7O24oEMlKWHXxAM1rlwGtutAlo+9eqNQ85jZ3aNbbrpq82IPt25YkuxUUqJxIwteGo0EQ2J0fYY5k+yZU9KmqUpbf16iY7qvl9HCC96P3jFt81qkUM1RGb1R/1gZXCr1nGHPlpeW3Fo7yXOjDeFDlUqQsDnvjPKRxDml5HYZEB+w2O2p2nyDtFkvCJIUTMs+/cvXB5urfNzD1jQpILHngwsFYCcoWcNgwNmplcMUiOJqJHsc+BTj3FtUZnqa3pH
 KP4eyCgf
 5yY9/vE4xNxkjci6kDjO4i6eX5U+puFoaAxlJcknrPfE4q4dQ7jfOEZZU2nUCnjG87DfxQsU93Idf/v1WM+6tmShYjPD8lsrDSOeVccVrN2zOqXXC7ighBddsSJbo7QoCZW0josti0Jpjijs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 8:15 AM, Kefeng Wang wrote:
> If the pte_protnone() is true, we could avoid unnecessary struct page
> accessing and reduce cache footprint when scanning page tables for prot
> numa, the performance test of pmbench memory accessing benchmark
> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
> footprint when scanning page tables").
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

> ---
>   mm/mprotect.c | 21 +++++++++++----------
>   1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 51a28781de9d..0f31c09c1726 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -118,18 +118,13 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>   }
>   
> -static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> -			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio *folio)
> +static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
> +		struct folio *folio)
>   {
>   	bool ret = true;
>   	bool toptier;
>   	int nid;
>   
> -	/* Avoid TLB flush if possible */
> -	if (pte_protnone(oldpte))
> -		goto skip;
> -
>   	if (!folio)
>   		goto skip;
>   
> @@ -307,17 +302,23 @@ static long change_pte_range(struct mmu_gather *tlb,
>   			struct page *page;
>   			pte_t ptent;
>   
> +			/*
> +			 * Avoid TLB flush if possible and unnecessary struct
> +			 * page accessing when prot numa.
> +			 */
> +			if (prot_numa && pte_protnone(oldpte))
> +				continue;
> +
>   			page = vm_normal_page(vma, addr, oldpte);
>   			if (page)
>   				folio = page_folio(page);
> +
>   			/*
>   			 * Avoid trapping faults against the zero or KSM
>   			 * pages. See similar comment in change_huge_pmd.
>   			 */
>   			if (prot_numa) {
> -				int ret = prot_numa_skip(vma, addr, oldpte, pte,
> -							 target_node, folio);
> -				if (ret) {
> +				if (prot_numa_skip(vma, target_node, folio)) {
>   
>   					/* determine batch to skip */
>   					nr_ptes = mprotect_folio_pte_batch(folio,


