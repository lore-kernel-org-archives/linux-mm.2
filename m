Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A8D1CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 06:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375D28E0006; Wed,  1 Oct 2025 02:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF6B8E0002; Wed,  1 Oct 2025 02:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1798B8E0006; Wed,  1 Oct 2025 02:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F30F38E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 02:58:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE5661A0923
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:58:22 +0000 (UTC)
X-FDA: 83948641644.17.06EF9C5
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	by imf10.hostedemail.com (Postfix) with ESMTP id F16BAC0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:58:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mX4CvQoq;
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.64 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759301900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTIeljN4phatoi2xIoAxM+GG4T0FIyehCs4+iQbIzQI=;
	b=AOpvrjdnArP8uQ9oE3gsd0/2hQmggeGcisV47tIX7aPHFa1ETEgykTHh3JvT0yhlpJbnZe
	P+nmWHLH1NOlJK9BpM2E9LwazrFBcPq0tezQ10/DHG24c8a15dN8QlU7flVPrLtu67fbhv
	cACZPnOP0l5eRZ9qUYGi9uv9LP1dFJw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mX4CvQoq;
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.64 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759301900; a=rsa-sha256;
	cv=pass;
	b=IK7HrUNdRHvdMb3FMaOiv7tMnK7BEx2zPmh6Zch1GwZVSHgEdZZtC7yUcSdS4mc0XqOU0P
	4vG4dSjyKgM/zqrTWx5rO5x8Q0xqbESihin95xEoiBKNF0IOD3nj5lNnM3RJsAl8dZSgDo
	j8KSUVcVrTcPSbdGfqPrlgECo/aY0zg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nq63B3bcwHRpUZoL/QAjGYbTLUsQx9cV+b0fi9z1buj8n3a5tplinG04dzmZz8gKXVP+cHPGBo9wdm1GrjsCStyb5oJ5ZLtFZCDlM0ogL63TGaPb0yxL0Qy63qtXULWhR+TrJOiphSvvfhipgoshxT8tMMZFCZ34wWhZNDpnK692PeEmjnk8kKIMUmC++B25aoPu0OjZBDtu1DGeZ/aci4tQXC2frVwNFLm6iT4gR+28T2/mOfgWtV03RSaX7/695sBK1mLez5NiOkoOtt7COJQlOAf7V+8JzdMulL9/36G2o+XSYaHwDOpq3e27YcVlowEtib439nkIa4hjzd345Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTIeljN4phatoi2xIoAxM+GG4T0FIyehCs4+iQbIzQI=;
 b=uTyPw+x/xZx8RSSxRVNhY1a0+XKIJsiYwhozBtbNKpPF289CDnVAvXF+FhVsajjeV83+2rM2vmubGTbI0WY8egVpkhHRAPspjiwlvaiQ26Xots1X7afMJMv6FtBOm/UOKg0MujmPiuRXaum3cl4GnXLksEkTjswhGZ+FGydzOwuJdUTydbncL6M6IzobuMX6tgXyWmytbb61d5YeLS+/PWWseTRsdAxbRrF4/KOXbZcK2gy0h7c+21gawcAw5iro9VcEXY/9O8LLGfgM9SAVg0lB0F/yPaN7PS1XXRBcN9puO/+Y+7bx4fTClQXzIuFWSKOkUNUi1/9Odj7Msqp3Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTIeljN4phatoi2xIoAxM+GG4T0FIyehCs4+iQbIzQI=;
 b=mX4CvQoq6EKje1YdW8Y0fDKZPYzy49Ni48gnZwOxXOyL5EBk9asYdUnNJgvarRVgcu5QAxsx1yksk45xolxNc9o1ekJaEdItknGWznceTBlxnstWBdgLXKT25s/qP9CAmjRGCyJNxsyFjid8Odt0sma5hrCgC7+8vCWDuRoZztXeN6xwfGxS8NbmLkm/Ju6x5X7hveoAptJnX+OTo23Y5QTmAM1LEMuTK+AeEDQWvrmwo6bUaP+fozxwird56pPBYJL/X9ndW24VOnqitkhIoNKE9scGJxXNzVg1Yts8k2S0i4CVagGA2eH6a6DBXu8SCzZY1d3hdr+5i4k7jkag1g==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY5PR12MB6299.namprd12.prod.outlook.com (2603:10b6:930:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 06:58:16 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 06:58:15 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	SeongJae Park <sj@kernel.org>
Subject: [v7 04/16] mm/rmap: extend rmap and migration support device-private entries
Date: Wed,  1 Oct 2025 16:56:55 +1000
Message-ID: <20251001065707.920170-5-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001065707.920170-1-balbirs@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:8:2f::26) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY5PR12MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: cf2b5758-ea7d-4628-f91f-08de00b7e4fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzg2U0VWbVcyVEdMbXFnOWlKYVJHV2ZCdXMwcUJYMHNmMGtiN0QyaUFYZ21J?=
 =?utf-8?B?bXYxVno1L0czOENJa0o5RlFEV3FrSFhQK3JtanBqRW56ZGtWV2NQeXZGVklB?=
 =?utf-8?B?NUhjWTc3NW5TTlBqTDdFVjRsMlk4S1BJeWt3Z2NXd0lZVVVmSkp3dnpwSzlG?=
 =?utf-8?B?V2tSZEhjcW9IZytkeitWcmRYdDBKNndsLzVhM3UxRy9DQ3ROcGhBUjRQSkU5?=
 =?utf-8?B?WWdqck42Z29yZnVCRktzdk9Oa1YzSjM2UGh0NUFwZVh6dmJwZXJGRDFzRmFh?=
 =?utf-8?B?ZUlpOWVtUUo1d08xUGowY2RFUFAzNkg4U2RVZndlWFZQTVNINUlQcWorWEFF?=
 =?utf-8?B?c2RPUkV3UStQRzBmOGl1TzV5d21KeGNqRlh3eG9NQWZ1Zy9XRlk2TVduQzdy?=
 =?utf-8?B?d0hRdjVMYWt3WTlWbFY2WG9hZTR6UzYweVdvZDlwTjVmTytKOTgzeE1rd3NQ?=
 =?utf-8?B?VFZhd3ZtNE9PM1ZhVUE3RjZVd3p5YVBnUEljbWIyeFNpdmh1bXBRUXVHNW1J?=
 =?utf-8?B?MjkxT1k5MXFzcTdrWUVnZnYzbmdtR0FKVTdrWDJXNi93bFNPZ0lTcGtZOG9L?=
 =?utf-8?B?eUZQM3N2OWxrN0JVSFQ2bFNtVkp5RzRrcE8vcktQajFKOWMzOFZ3YVE5Ulhz?=
 =?utf-8?B?c0dYWVdqNjB1K0t3bDl0d1dxcThZam9NcHdnaUhaTUhKNDRSd2RNWWpkZUcy?=
 =?utf-8?B?UnpFZE9xNGkwWDhiZ3ZMblFpWTFCS25xRG5uZ3cweVlPZ25tNElIV0IxelV6?=
 =?utf-8?B?akh4TzlyU3BTK0hnYWJad1JUcmFGRXFtYmZ4MEJlN3htRHFMYXJWNHJBTWNh?=
 =?utf-8?B?ZG1uUmQ4bGNYRVdLYUx2UGlsR3c0UGhwaXhwdzFYRzBKSEplNDVLWjR0WXFO?=
 =?utf-8?B?QnlsS04yVG5DSFZ1OElDSDZJL3FIY3BiOXhzNFNwNEZjVGRPcWI0ZklrQTRm?=
 =?utf-8?B?emh4Qktlc3lzbGdLQ0tQbXhseUk1UFpJeFBBRm0wbTI3UXBsR1RHQmJOZnVa?=
 =?utf-8?B?UkJBWGtuSVY2OXlUSXR6NHc3VU4wZmVNTkdKWTNlZUhYb0ZLbTZKUlJPZzZl?=
 =?utf-8?B?aDZaNVI4ZVhRcDdNWGd6b25WUm82V3BQVEZaSmpPUW1PN0EvVzRFMGtWOFVn?=
 =?utf-8?B?bnRRQUdMSTFvWCtQK3BybFRyRnN4ZXgycTBIejdXR2RQcWRIWjRUQ1ZOOHBH?=
 =?utf-8?B?dW5GaFRxa3NTR0ZsRUlJUHUvcCtuVWlzWWFicXEySDRYMnVkWFFwNnJPWDI1?=
 =?utf-8?B?ZERUZFl1TTFSeEYxVWs2NDZZSGczWFUyR056Y01ldWJaRzdsOU02SFBjaWRB?=
 =?utf-8?B?UTlDTlh2bExMTVlTSkRBcjlmUitBMi9obGhZNHcxaFZtMTlNZk5YeVJRV1FT?=
 =?utf-8?B?S0JQMVA5T2pxaXo1bVBsLyt1YWEyWkxqZFhuTzZ0Q1BvRXRqamNzcDFiL1Jk?=
 =?utf-8?B?N2tHREFidTRJb2ZDdUlsQmZkODlibzZRMUlpd0d2ZDRuV1pKMzJLYnR1Z1g3?=
 =?utf-8?B?QWR6ajZqNnI0UEhXTWE5ZWNCSzFHR3hlcm9hT1FncW0yNUgwdlM4cnFTZUtl?=
 =?utf-8?B?b1haRjZBS2R0dC9CdUpJT2NHWFNKRUlBaTAxdzdUQW5WQzVQbUZZenBSallj?=
 =?utf-8?B?b3piQkl3TXZBYTdWb29mTmRCYkF1ZzZuTlRybnBUUjJYZW9yWDB0TXRKWU1o?=
 =?utf-8?B?VDhtMXZGSkd5ODg5ZGhvVTNXWlNzWFJRMjNXeHdHMk5vVXNKdWdkZ1c3UUx2?=
 =?utf-8?B?TWxIbnhHU011VG1YaUliMlpiTjZzQmxlTU5rRlF4VERvL1B4OWpRZWFsamZy?=
 =?utf-8?B?bmp4NlBQcGhoUjllM0t2QXkvTk9uMnkrOHFKRkZqMHo0NDZLLzBmOXNjSGlH?=
 =?utf-8?B?R0ZEWE9yYXVEWmVKZ2FDSWJqbjR6c2djK1VvR3lzOFVONlRwNE14YXVvSEk5?=
 =?utf-8?Q?ufz3QcRh/31m+EEFXNB8Y1hnxwwe3aFe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWZKQ0ErS3dWNnJudUJydnRHcHlmWjhPVVp4UUYyTFhlVmRwTkMvMnNwMHM5?=
 =?utf-8?B?VXZFZlJKSFdmUUlSODJuVFlvWVRjYjFpTG04bG9JYlU0bTBMZS9ITmlFYURD?=
 =?utf-8?B?bTBaYTdqVTJCRHZVcWMzUmxpY2pTYWpuekt2ZHhvTnJwclI0MEFyR3VDY1Rl?=
 =?utf-8?B?WWtGaHpzYnUvWGhadUNZR21LZ0V4V1QxdUd4cHd1TkFqdlNoYnR1VkpOUEZR?=
 =?utf-8?B?bXRZWnp5bmVyakh1OG1qUTFMcnZpUWZ2RFNlMXl2QjJHV3NxYkROWkdKWU1T?=
 =?utf-8?B?TlhoVE5yTXROZXo0UVNJS2hteVhLdzBVQkF3MEhuSmlkbHVtcXhIc1k4Mi91?=
 =?utf-8?B?bElhY0NtcHBMTC91WkN6czYrS3JMeFdGQ25MQzhCOTFMaTVoWUZSdTFDdzda?=
 =?utf-8?B?REJUOG9vTFhSckdRVXY3ZVpCeERBNjd1V1N6cXdUbVRyNlhMbEVSQTVVUnBK?=
 =?utf-8?B?NW5Qb1lyRDVMcmpVR0FMWjRndDJ2b2lxbzFuWnZrbjlrVTd3M1llRlVXRnNu?=
 =?utf-8?B?YjJNTENvbHBZMFFwMlVQc3ZFaFlHVkhzd3BIVzBHRDdDQUVsQ3E2Zm5pVThJ?=
 =?utf-8?B?UFlZUkZYaXdjOEtuSFY2dU5wcEZLeVorL2pVU0M4Q2FQYUtLWGlTdGF1eHla?=
 =?utf-8?B?cklqOERSdndtMCtzRkMyLzNLMDJWUldpMW5jalUvZkFiY3IzamErYjZqU3VJ?=
 =?utf-8?B?ci9hOXp0MytjbUxUbUYycHJpV2xJbGV5eWV6U0NNQnYyWnRXRGNtRWhobFIw?=
 =?utf-8?B?dHRtRlZwNll0K3hRcTU4UXp6Vk1RbHgvZURTeHBaMlRBWWFxNm81a0xKMDhB?=
 =?utf-8?B?ckd1TmRJandWVFBNNXlsRmVSamc5L1JkWEdMTERKVjdYYXoxK1lEY1V0OUJM?=
 =?utf-8?B?bWpFV2pTTkNyK3RWWW5KQUlxdGw2ZU5Zc0hJcnpxelU1ZW5LME1vbWQ0VEFL?=
 =?utf-8?B?MGplZ3pPcXhWZzQzQkxaaUVaZmVpbWZOMC9Td2plNGxQVU0xMVptenpGYS9J?=
 =?utf-8?B?WDFnczZrN2RRakNxYjNuTm9ZZ09jQkZuQkh1bHE2QnpWN0dTL3NGclFONnVi?=
 =?utf-8?B?aFZqUU40UGVOMHp3cHdKQy84djhUa2EwdzZMeHdnYmp3eTNzWmUvV1Q0eGpN?=
 =?utf-8?B?SUwxUDI1akYwUzVpcnhOZnRjYzd2SUlqZ1hWWUlVbmZlWkkyenZjcjBNTHpI?=
 =?utf-8?B?RStNVU4rUnFNbWVrS0FHQUU2MUgxOWowankrcnViM1NxVDRRdjA2cVo0Z3Uy?=
 =?utf-8?B?aTdjUDQ3U3dBZ29xYmE0L1ZGNzBDU2tPR1hjTlNLTDBtaS9sMnIzMWd1VENq?=
 =?utf-8?B?alRMczFEMCt5T3BrbWpoQVZDa0EyL0F3YW0wMTM5TXp4anRCY21HSjhrNXQ4?=
 =?utf-8?B?MzBDTHlHT1Jmdityci9XZ0pVK2xHSEZOVkhtazdOVHNZT2luaEprakc4Y3J3?=
 =?utf-8?B?cnAydW1kWVhSVjJ3SFhlK2d2OGxFMkRKWEUraHhoOGRHODFWWm1SVlF0c294?=
 =?utf-8?B?QU9SQlNDTlR5Nyt2WjB1OUZrNjF3WWRFaklTd3hjWE5sTC8zMkREWSs5KzB4?=
 =?utf-8?B?Vkl2aHBJSDRvSSs2SmwvQktockNiNGFFQ3lqREkycDFhZ2V0YVptdU9rNlRJ?=
 =?utf-8?B?L3RDUC9vQUlteHdVT2Q3U2k1SExtc1FzVzNrNGVuT2VkNE5RdHJEcURuVXpu?=
 =?utf-8?B?MEJURXd5MlBJYXdIV2NyZGNmKzNSYmRRb2dVQ2hIOFE3NzMrZThLTDd3RjdZ?=
 =?utf-8?B?ZHhaWjI0cDdXc1FKNmlhWWppbXMvcklWOVNLeUNIbVBLOUFsVVVXWmVyYnZK?=
 =?utf-8?B?Z21xTWw0bmZTblpxTTc1czloMllyem9jeWNFVFlJUEdEbG1DQThLejZnaHQz?=
 =?utf-8?B?amhSREhrTGdQN0l0ZG5iOWNWV0VRMUNucWlKRURKa3lZYlk5bkhoVFIrYnBD?=
 =?utf-8?B?Z2JTQmRieEhMdWVXcktQNnhDMjFxZHJmTEJYMVkxMG9tUTBhKzhSRVAxRDZv?=
 =?utf-8?B?NDhkZzhxWnNRMXdRYytQa29PL2hSL2FNWGwvRFFlV2UwbjIrTGl6WlBuZDhY?=
 =?utf-8?B?YldGamdyc3BiRTlGeG42SXprOGw1RmVNekRscWxQUElhUWQ4aHFIaFR3TWtl?=
 =?utf-8?B?b0UvVUswaWFCZnZjdTlWZjFmNFF0LzZXOEw3dWtidnk2MER0Sks3SDQ3bFpz?=
 =?utf-8?B?dGc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2b5758-ea7d-4628-f91f-08de00b7e4fe
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 06:58:15.7697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1wtbaEf7rs161kKg9ASwpIG5OGTtkDNigXL2RBRqzN1YeL5y6ItzS3TksjHLNITdWbQArtjybNuqFsehMyQHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6299
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F16BAC0003
X-Stat-Signature: cf9f7cdpxmjph516adwwfqkskpe6bxxk
X-HE-Tag: 1759301899-434584
X-HE-Meta: U2FsdGVkX18xXguw0zivZZBhall3tN1uK7irAyZ4W0dXT0rupZWDuVnq15Cib803NHyi5tJw8Y0gjWmjB/BISMtiPjPjiE2wEySbVbtfRPuv387brIo0nNnOfIXdZ/Ad+oGXybCk4bmrzAVHdxvnqXg7z5daNvR0Y8V89C8Pked0fx/jPo71zkOXAFx6r9LiyJHofgRHP4fP5XxuvMwBcEgGPWfW3zBYvwBaPyZUpNtvZu02+NoXSi40pV19ndS3zBqhiDGE6El8cCWuFv1avORi5qXraRmjKpXhK+QB07PzfigQAKDzXBW3NEi1m6vCCJ3E1Xs6W24q1weP2LUbHZaKTHX5WByVN0MSLPrzWP4iW6RaMiaQzMO3GwDt56k7Vc0tHU9jLbmd9isUQn46NDxSFulpjbf/e7u+gK1icPipoNFWahkCeF4vHreyzJgWhnTqPXWVqIu78JeAylnY4H1xvSjHlZyT05CB0BfVaSncmzptPtNO98Bgj3fWQIZDBmQrVZsnIiwRMZ8UlxGa5y1SZY0cbW0CevFkh7A0ZoDYzZl2GrT6NQ4eJPB780m5+P7WTCbpuPk0lxrPrD+cD0e2uA2maA+JjS4+CIb2PswbzAq2noEIRLCserD84SuCGu3suQpSJ0SYPDQgsMTTPRpZAqSE/UvsLiVBCoca0dq6/mjO5rhLBXcXmP9Qik8zaI+KrFc+L0R4mHKt+priQiYOAieDv9FyO5LGP2ZzKOkkGwJHhjbZyQOrRXr7kkRZ1XeIyKb9A35oeF6++UxO/OkzYiIx7jUgFLzkXgc2vMqoevExUVHyZSOl0NqBQfDnysbaxt4BONW4gCpAVHoIhaBC7HxEN22AtnU+tq8/Uv8BNeY1XwJdBwi1JtXm3wJvx4SkygvSaOVznsu73wJ9ug3YobLy8X2U1yE4tL+RQRVll6yyDVBLS+Avb9E46CK+UlLmeojNxrCFSeEz7Yc
 ARu6gc4i
 sEvQdN6ik0oS65VcrWlBG5cO27By8Nt0WbMuVhlYs6pfrrbHe7xmKSgV9e+mGmARQlv7TaQUcPAX5MLkXyaWe38PYdhwcNEaaWM6CYfoHlbkVw5Bo7T85VbdZaPEkilH1eD/MIlV9HcnTKCqIQXUYxsQQXSA37qwKIYxx3RLCRqPqgZD5MAbeAJTEzPdHjtUerCEVwo9dvSSvdbXpmPGtIdeamQURktqYOJCkJsuOwThQ2XEoJHjbWZp7xEQrQqZ9GEfuwuvH9ZGvoA7a/WqIu3Ugz1jjmEGk6z04zg+yDWSYL5ryorHPZxCHBPbGMoKPKfxOTaiNHz5+VsrMyKuTYPEXyaZ5QR9AJLljiNsr/z39X93jTUeSUCVHSOL1i0/RpdTPES+o5LDKK0oGBN+DnhnwSG9mONiJuJPJQTATCGAuN26lfd4dQVX9fblrNSNJ1Gj6YioNturEwcxNLevbhVVEoD9L/ZmhADm4V5UNcWGF2ggHfkg9zZGcxusWbU93286cXfceDyybOJJ9QrV4T7M6izsuKpoPjE421ST7BiAxyhLb3HqoJXrMNsuSm/11It75p/ivK3fX0/Slml0jsTnjH3ZJ8AsGQBKKVNtjXc//G9SV05oeh2oi4GrscjCzekaUHAS3piVyl4TKG29UyHQKnhu6yKwVTFhqhDHUs+/IA6q1/NhlLxyFRDSEyL2741GIH1vLxdmypW/ltgVRH6UI/uA+FFz87n/OgKjwdkpHCQPOHvpDXr7qURd5M2ZRlKQLuA7ZNbfKHJpSjdiTG2/g8MpzN00jM40wFJdi8oSHXAUbFMCeo5qXE9KCo+Bi/j2p0wK9IyJTifGRYwghlx9tYCDCdi2wZKJIuxDmndh0P7jO0iWmDgXgQ+GZP+VSC6k+slZy88933TMeBN+RLlEmKCHBtJbIkTyMX7rNL/+h3inRJ9srvKIUbatQ45LZIKR9G8fVZBMLu4RjDwXAf6+nU7jO
 mjbyjXzZ
 AOT9TjedMo0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add device-private THP support to reverse mapping infrastructure, enabling
proper handling during migration and walk operations.

The key changes are:
- add_migration_pmd()/remove_migration_pmd(): Handle device-private
  entries during folio migration and splitting
- page_vma_mapped_walk(): Recognize device-private THP entries during
  VMA traversal operations

This change supports folio splitting and migration operations on
device-private entries.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 20 +++++++++++++++++---
 mm/huge_memory.c      | 16 +++++++++++++++-
 mm/page_idle.c        |  7 +++++--
 mm/page_vma_mapped.c  |  7 +++++++
 mm/rmap.c             | 24 ++++++++++++++++++++----
 5 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 998c5180a603..ac54bf5b2623 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -75,12 +75,24 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	struct folio *folio = damon_get_folio(pmd_pfn(pmdp_get(pmd)));
+	pmd_t pmdval = pmdp_get(pmd);
+	struct folio *folio;
+	bool young = false;
+	unsigned long pfn;
+
+	if (likely(pmd_present(pmdval)))
+		pfn = pmd_pfn(pmdval);
+	else
+		pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
 
+	folio = damon_get_folio(pfn);
 	if (!folio)
 		return;
 
-	if (pmdp_clear_young_notify(vma, addr, pmd))
+	if (likely(pmd_present(pmdval)))
+		young |= pmdp_clear_young_notify(vma, addr, pmd);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE);
+	if (young)
 		folio_set_young(folio);
 
 	folio_set_idle(folio);
@@ -203,7 +215,9 @@ static bool damon_folio_young_one(struct folio *folio,
 				mmu_notifier_test_young(vma->vm_mm, addr);
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			*accessed = pmd_young(pmdp_get(pvmw.pmd)) ||
+			pmd_t pmd = pmdp_get(pvmw.pmd);
+
+			*accessed = (pmd_present(pmd) && pmd_young(pmd)) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
 #else
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e0a1747762d..483b8341ce22 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4628,7 +4628,10 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		return 0;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
+	if (unlikely(!pmd_present(*pvmw->pmd)))
+		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
+	else
+		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
 	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
 	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
@@ -4678,6 +4681,17 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	entry = pmd_to_swp_entry(*pvmw->pmd);
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+
+	if (folio_is_device_private(folio)) {
+		if (pmd_write(pmde))
+			entry = make_writable_device_private_entry(
+							page_to_pfn(new));
+		else
+			entry = make_readable_device_private_entry(
+							page_to_pfn(new));
+		pmde = swp_entry_to_pmd(entry);
+	}
+
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
diff --git a/mm/page_idle.c b/mm/page_idle.c
index a82b340dc204..d4299de81031 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -71,8 +71,11 @@ static bool page_idle_clear_pte_refs_one(struct folio *folio,
 				referenced |= ptep_test_and_clear_young(vma, addr, pvmw.pte);
 			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-			if (pmdp_clear_young_notify(vma, addr, pvmw.pmd))
-				referenced = true;
+			pmd_t pmdval = pmdp_get(pvmw.pmd);
+
+			if (likely(pmd_present(pmdval)))
+				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
+			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
 		} else {
 			/* unexpected pmd-mapped page? */
 			WARN_ON_ONCE(1);
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index c498a91b6706..137ce27ff68c 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -277,6 +277,13 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			 * cannot return prematurely, while zap_huge_pmd() has
 			 * cleared *pmd but not decremented compound_mapcount().
 			 */
+			swp_entry_t entry = pmd_to_swp_entry(pmde);
+
+			if (is_device_private_entry(entry)) {
+				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+				return true;
+			}
+
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
diff --git a/mm/rmap.c b/mm/rmap.c
index 9bab13429975..c3fc30cf3636 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1046,9 +1046,16 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			pmd_t *pmd = pvmw->pmd;
-			pmd_t entry;
+			pmd_t entry = pmdp_get(pmd);
 
-			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
+			/*
+			 * Please see the comment above (!pte_present).
+			 * A non present PMD is not writable from a CPU
+			 * perspective.
+			 */
+			if (!pmd_present(entry))
+				continue;
+			if (!pmd_dirty(entry) && !pmd_write(entry))
 				continue;
 
 			flush_cache_range(vma, address,
@@ -2343,6 +2350,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	while (page_vma_mapped_walk(&pvmw)) {
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
+			__maybe_unused unsigned long pfn;
+			__maybe_unused pmd_t pmdval;
+
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
@@ -2351,8 +2361,14 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				break;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-			subpage = folio_page(folio,
-				pmd_pfn(*pvmw.pmd) - folio_pfn(folio));
+			pmdval = pmdp_get(pvmw.pmd);
+			if (likely(pmd_present(pmdval)))
+				pfn = pmd_pfn(pmdval);
+			else
+				pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
+
+			subpage = folio_page(folio, pfn - folio_pfn(folio));
+
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
 
-- 
2.51.0


