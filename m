Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2BD2D26D8F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 18:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294E36B008A; Fri,  9 Jan 2026 13:53:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CBD6B008C; Fri,  9 Jan 2026 13:53:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D246B0092; Fri,  9 Jan 2026 13:53:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00B4A6B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:53:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFE5713BAF0
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:53:46 +0000 (UTC)
X-FDA: 84313324452.29.C4604D6
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010045.outbound.protection.outlook.com [52.101.56.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4315D180007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:53:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WxLgvDvv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767984824; a=rsa-sha256;
	cv=pass;
	b=HYPOuAaAxvBEnaHCtYrc4oQJOSH7z6AvhdmzXlmqOOtqBFZgRyvKmK/vOTGmaOZAbr/kjx
	Y9zJaDH+VbJxMVe51Hhy7bzDmFqoG4U4I0W67e7xAWY0+w95hL/euxplT04twx3gnTQEFZ
	5VSe7Yza5J3CgG5lRZvldcNqPeZfhh8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WxLgvDvv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767984824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbyIJlOk1tluXSM42zkJJs7P/HY7JuwAZLxGUnLI3ik=;
	b=fSW0WolQCjEnmHqmy2wCL1rrF48cjSsoFyOlA68GRs5sY1zOFL6jrtGCW8gqhk/WbdbcZs
	B9dYqC2aaf2+srPc0aXMxb+rsPEGMKEZ5Q8/ftP2rwUH5N4czaxihmD+8O7lwyjst7FvWW
	Bj3HhdXN6wj2BAvL8nleXJBZ/3MAZ0U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1//bnW/YSBPWzlMGkoLMNAT39KnOk2rCDlNVD2/WFAVuVnT9fSslRnFG4Gk82Wuh5sok9djXDLdKABkFN9xxtEqemtDKktcO3gux9dmNbYTA1wBXsSScXnWl+Oe+PZ9Yh7aLT6yxIsECsZ8D52i+XVIHU/OoAAw2RQMg0d4KHB9hxDy0OH5SUvV2zake3POgfSrNaE4Hr4uypKb9sYdroG7I133qFF9rWBAx0YQoPIB/Uo36W8TMRu35XGrf23dVAF3gdYI7ORgcuHQMWHjy6M7muYUJ25rMOpFcy7+ZMqJHEQntPR7lIGjG+XCvjo3chsbzpMGFfLH8l27YyFrCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbyIJlOk1tluXSM42zkJJs7P/HY7JuwAZLxGUnLI3ik=;
 b=Ly6T9UrZjdPFUcMS9CPWSTfpIu3hI7D/rNMcezV9xyL8cRiY99zmbJRZ0rCC0WtiJZ1wnKdMXYmKvaygl4KCSNClBVCdg5U3r/iKKwckjANtdFfecH2QBi0tm/uCD8IEJ2cpCoaIzAQAVDAVdUVMTFdb2XVhRQXSYb3IDH6zcXvjJ/lgijF7cDfVWjo+n6l47n4Ugt7z8TF1pGlLd0q9okv70f5sZPkLkJrSLgWQd2tVDyCFE2W/A7NEhmO2HuZBnhsQiCVzrM0rzpKslXnrPi4C85cI+w/SvVlb39ZuIlc+Xn9fzJ6soFFYlQzo6rEKax5o9ZEXjOzR/vJPxOaqjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbyIJlOk1tluXSM42zkJJs7P/HY7JuwAZLxGUnLI3ik=;
 b=WxLgvDvvaiGC4cza+XGPGe4wtm602O48KJ/1OQA/W5NtGeMcBXmJ800ZAzGGiWqxHQGrcB/hE+5XsDuQqpDQKeRlUDY57pjrMSRjUIF6oY1Om/EEkI7xGRtZz0mywakiIATy3ou3Qs603Xb3UQg7PEixO032vU9JW9rs8GkDFOJ+DW2aXFpGW/yuSMxItfiTr4JgyQX7olV57dCOfz/wrQdiYT+wDBGA2XM6DOg034/i+bi+tvEHAmokndkfX3w9DMeEVT79b49Fu1+kbO8RoVJ3gujpDvRcy9UK/CihGsTmY2rUIzdb7iOhGhgmfi771gfU7bWuH22VMJZZKBtMdA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7288.namprd12.prod.outlook.com (2603:10b6:303:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Fri, 9 Jan
 2026 18:53:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.002; Fri, 9 Jan 2026
 18:53:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, Balbir Singh <balbirs@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] mm: Split device-private and coherent folios
 before freeing
Date: Fri, 09 Jan 2026 13:53:33 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D9ED5F01-E758-4A89-87F2-ABFF5197231D@nvidia.com>
In-Reply-To: <aWFIW6XCKXPpIinv@lstrano-desk.jf.intel.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-4-francois.dugast@intel.com>
 <d1d80b81-678d-4d28-9ac2-95cb74824e73@redhat.com>
 <DF5A6B81-7811-4654-855F-8EAB76CCCE51@nvidia.com>
 <aWFIW6XCKXPpIinv@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:a03:505::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7288:EE_
X-MS-Office365-Filtering-Correlation-Id: ae9d4c76-2f70-461a-3310-08de4fb06633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2ZlVS9rdkdGdk11YmFYMzVZNjUrSVdMczJrMjVMUTNaL2JrajU1NGZVTGs0?=
 =?utf-8?B?YTFjL0g1MFMvTFF2QnhFUzRvUXVVSU9rbi9DRFRrQkJGZXBLV1dvdFI5ZFp0?=
 =?utf-8?B?MFQrdXViWUEzRFQ5YUVIQ2R1aEgrK00xbkJ3bWlQSjVjU0piL0NiR1NKVWtp?=
 =?utf-8?B?ajFvQkJEa2xjTWxVdEY1QmRWWlFaRHRjUWwzeEJsVlBpa0s5U010Y0FuYWxr?=
 =?utf-8?B?LzlpWm91bFYyQytvTXVabXpvWTZBNXpydWdBWGhuQVgzcXY0QnF2empaNlZH?=
 =?utf-8?B?UW9DbmM4eWh4R3BJUDNvUG5sVGJramsxSnM3WDBjSWxNcU5obkdXTEtXaTB1?=
 =?utf-8?B?Q3ozdytrdmVrVmpkOWg4dzhyUGNOOTZTK25lRm04TUdjRk5UU3g5cElLWlRJ?=
 =?utf-8?B?dkRNRTlaSU91Uk5neVZGRi9sUEJoZ3d2QngrSTZTMytSZmhhaExIQ0VEV1Vp?=
 =?utf-8?B?N1YrK2xpTUYwSEVOVVRVOTA5cDQycGx1YVlvUk15ZFloNGNSN2ZiRHVWVEw3?=
 =?utf-8?B?d01aY1ZDeVhoaFpvRW54aDIwVFlOYkFZUy82WDFXL0gybjNqOXdwN1ZaNDJ6?=
 =?utf-8?B?c2FxY1BpRU1jaDlNNlVYUGxlVGVUMWRCSFExWERjYmdKbUJtQ0NpTVRWV3dS?=
 =?utf-8?B?Q2JQNlpNUEswS2p3dGU0ZExJNmtoT2s4YkpydHdJWEJZMGJwUFJheEo2NDFH?=
 =?utf-8?B?eUNpNDFPTEV2azN6SW8wa2ZVRTFFVzhSUnlBdlZ5T0laK3FKeUtXbS9pcGM5?=
 =?utf-8?B?LzIvK3Z2SnBaTWhXaUI2VHZWZk4vYUttTFRUOWFIQTJOVTlTZXZXMHY4TTNR?=
 =?utf-8?B?NG9wZXltWFlBanUxMFJwdGtxdFF4S0VTcDA3TGZ4M0NxUzlHMmhPSHlVemVE?=
 =?utf-8?B?NElLeE9VUGhScHJhUG9lcmMzL29jc1FqYTc5Y2Q5cjhZbHU4OXdhYzBNV0Q3?=
 =?utf-8?B?clhxcFIxZkNmenI4b3VrYTIvd21kaGdveUZrY1lLNDluOWtFZEg0R2F5cjlE?=
 =?utf-8?B?TEhEeXhIWXlrcnJreExxem9Dc1p6eStWdW92ZitoMkVBR1hBRloxbXZDaWo4?=
 =?utf-8?B?NXY5dmUrYThidVBqbUphZmlQS1R1TDNpVnlXWEU4MkJzeGcrU3E1WSswOHlp?=
 =?utf-8?B?dVRmNXhOcVFSRjllc25UYkpqM2VwSmt3Y29rb29rME1mMkJFOGFNVDZuZlBT?=
 =?utf-8?B?K2h6R1FqbS84QWdOc3puaFdUTXlDMHFGVXc5TTlQVmNqeGhmUUFaUUhTTmF6?=
 =?utf-8?B?OURIYnJ6b0ZwZVhkdVJoY09kR3FrWjlSLzZDMS96cEhXQllTU043Q1NNUEFL?=
 =?utf-8?B?SkNqUmpJaWhsQ2VscGJaRkFLRERGbHRKSDBkbnhrMWx4aWd3b3BkNHJDTW5s?=
 =?utf-8?B?YWlVN0ZVQ2lKYUJmMVdBbC91Z1IrNlB6djJueXRxNGJWOWd5VGxlVUhNb1Z3?=
 =?utf-8?B?NTlmVFpoYWtyY0FTUWVESWZZNGt3c3E2L3ZSamVwMzZBd2hYak1QZkc3SE44?=
 =?utf-8?B?NU42UEI0ak9GOXVNVFd4M2dLaElxRVlsbHpjejZObkdWNUtOTGRmL2ROK0I5?=
 =?utf-8?B?Nk1mQVJ3Ujk4QlFWS2JnNElGWUM1aTBGVjRwZUlPMTJXc0lIdTZmNFA0ekxo?=
 =?utf-8?B?ckRiQS8zWEVtNmQ1ckZyWjlNeEhIMGwvSHF5cDZRWjFGQmd5Rk0zQlNlN3dr?=
 =?utf-8?B?Y0cwb1QvZEt1V1Y2dDBJNkRuV2Jobk9yOGpxc2V5czhCemJpSFJRYjJTbll2?=
 =?utf-8?B?eVQvVlozT3B4ZHc3dVlXVm52ZVcwSmdCZmYvTGR6cVViUnZrQ2NRQkpGeHBU?=
 =?utf-8?B?dWpuOStIY1lGbW55MTNKMURBZU1tUzZLOEt0RHZsdTRlZFlNUlV2SDhoQVo4?=
 =?utf-8?B?MzFTTzFCa3VqUjduVWdZVng3Q0ZtbkdBeTd6UlIyUFd4TFRMNkM5ODVnZG9K?=
 =?utf-8?Q?NTlSag84eVSWK0y+3x+ntla1jOn70fVE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekU2VXprOW4vaElYOTU0YU9XZkFWK3g0T3VTeHA4YUlVVEFTaGc2MklzTTls?=
 =?utf-8?B?K3VEOWNJeDJaTUpCRkJKOVQ5YlRLdmY1WDErVWQwS05wcFdBMEszeURjR3R6?=
 =?utf-8?B?dXE5ZUlRcnVic1JjTVo2dTVNRXllZ2dzU1p6YnMxYnlPZXE5bE1FaWNDRUFO?=
 =?utf-8?B?bk5lT3FBbnBnWUNuaXNlWm1tT1dhekN6Q21sNVYyTEtZY1QxMm4rVnppK3BN?=
 =?utf-8?B?UFdXQks4NTUyTjBxV2hxWjhMMU9IaWhTYUZSRXU3L2dhRlhNUDFQZWtHcmZ2?=
 =?utf-8?B?bGEzWlhGTHRaT3FyajJJMDFNWnkwNHpIekJvbGNBQTJocURNWVFWcVJFYUVG?=
 =?utf-8?B?bzd2U3RadjRUT3ZUajhrRDVBa2g3cCtJNGpBbVI5UG9sTE8vd0ZIVTNYd2h5?=
 =?utf-8?B?ODJaZkU4S3ZZdEdBeUVudzJFTVFjV1BqTEtRVTlHTWJyNTlGdHA2TGp2TTJ0?=
 =?utf-8?B?N2dMaU1VL3kxOGE0ZzlkNFFUSXJoamk4cHZzVWlSVUlyL3FRQWU1ZWQ1d2pL?=
 =?utf-8?B?ZTBTaUZaKzBpaVJWMXNiTGF0NkxKdWhhNS8rNEVXTVhFaHlBblJFM0ZPMTE1?=
 =?utf-8?B?R0ZDZW9IQjhaeXp1ZU5PSkhLMkRRM0F6eUF5aTB0OS90WXB5a2F5azdvNm1z?=
 =?utf-8?B?d1VmY0NaN0g4c2huS29HOUVseGZ5bk0wdFVSWnZjd0xJZ0pCcWZicHV0L1Vw?=
 =?utf-8?B?Vnd1aS9lU2FqRE1CMlRMcG4vVXlYclE5Vm9HdWdwd29zeDZoMjNnUHd3Wmtk?=
 =?utf-8?B?MUNpaGJSWmF0SmVLdWdYaHVVZzZUOTAzaW5EdlBrSC8reDlhd3FkR2lTVHda?=
 =?utf-8?B?WnRIbHRibEJJcUFqS3g0YUFkcDB4UHgwR0NHNGhTT1hhNjdGdnM4YXhlUWpQ?=
 =?utf-8?B?UW1pNkVGSEowMWg1QUgwelNWSUJVYXpMV1VraFkzUTFzSnhMK0FORW8xMjVH?=
 =?utf-8?B?d2Jra1ZYcXdkdGgyV2ZIeWRmS0lxNERZTDlYSG5oVVBoNDNubGh3RUIrNzNv?=
 =?utf-8?B?eUFqMFVQMEN5Tmh6Y2plb3VqSWVyTzlHMnQwQXNtN0VOaFhhVWw0V1FKNktw?=
 =?utf-8?B?d2tjMWloNytYZ2FsMm44MS9yUEl1WDVleFJxdHBQV3lLWVk1d2ZLNUROaUFE?=
 =?utf-8?B?ekZIeVRobUpMWktBTmlDOUFFSGt6ODNnYXRpNWh2T2hwODNLZkptc3MwQ3k1?=
 =?utf-8?B?TGRLRVdaSU5MUEJnV01EVVI3ZFZpWnExUXNZM1pXdmVoOVVlVmZDM1lPS0hu?=
 =?utf-8?B?ZlBuc25uUVJtRXA3YzVRaTEvREdmaFRJcExqTlcwK3FuSkpsTEJGZVFIMWgv?=
 =?utf-8?B?OFMrd2pBWmJhQ1lSVU5rblRPTmZFRERrZzh1RmV2MVdvTTdkaVp0YjV4eFE4?=
 =?utf-8?B?bm56dkNOMlZacWd6WlRETkZZalBJNFlIZnhieWkxTW5WNlBsYjhpRG1VNWl0?=
 =?utf-8?B?dUhXeVc1a1VMOEVndTZOSVJqM0MxUkYyQlhaWnBjUGJldVplb3prZUxxcU1r?=
 =?utf-8?B?aWNKSjZOanBHWUgrMXJBakVqV051QXA5b0h2KzFmYnIvUEJrd2gxSXlQNEZH?=
 =?utf-8?B?RWhmSUYrek05bjlSWkI0RlR4QkdBY1IySU55R0VxVWF2a3dDYm5JcFlsZ0ov?=
 =?utf-8?B?bC9JOG1YK0N0Wm01MUdYbndVVjZyeGIyclhSM3htV2QzVmhySE9qVDAwOVll?=
 =?utf-8?B?MTM5VnNrbGRud3dxWFd4SnFlT1RYdGxCQ1dzRkpzQXdLOFIvRm1MRW56RE9L?=
 =?utf-8?B?NndONVpNV0psclMrQXM5ODlqNzhlYzdndk01NnEzTlVMUHQxY213Z3lmVGFG?=
 =?utf-8?B?MlBYblhGZnFiM0FYZ01pZ2pvcjVKVzMwN2hJYTN0OTdIZ2VwTHFSRUx1NTZr?=
 =?utf-8?B?SXN5ZXRUWThYdFpYem1pRCt1UE9XeTdVYktHMXhDL3NqZ0RGV2k4c0VEYmpY?=
 =?utf-8?B?VmxUTFUrUjdNRmFQUVlnSDB6MlE0TWNVNzBEZTcxbll2cnNOcE93NEdMSWNw?=
 =?utf-8?B?QU9oMXByY2liUUZ3SkRaS0RkODBTVGVSeUlHbFJGTXJGSkNJNXIvaG9lcjc0?=
 =?utf-8?B?bU9ZTnFtWW9oSmc1UzUrZ3oxUnJSQzdkeWQwbzAwZnBkaU44MWIrbXhPNWtu?=
 =?utf-8?B?K0d0Um9kdXUrcm9Fck14dHQ0dUZJWEZnQ1JNdWU1RjFKblVTbi9OL3hJRFBu?=
 =?utf-8?B?NDZKVGhJdlVSQ3FSRWpVZWg1MkYxNXpLZjVmOUR6b0VwZTV0L0U5K2Z5US9p?=
 =?utf-8?B?bzJxMUNnM2x0a1lqK2FNTk9seFRtazcwZ28xbU1Bcjd6RHFvd0RvaStkR0ZQ?=
 =?utf-8?B?eXJqdHBWREtYZ2RXL0hhWEhXWEhHUGFvUVUrcDNHMCs4UjVyVDN1Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae9d4c76-2f70-461a-3310-08de4fb06633
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 18:53:38.1873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: puQiwM36H19jKKKx16k5wLwr4uJCXXEowYpsEabBx8pQjEaOgUxfw7bhvpKDpYmK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7288
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4315D180007
X-Stat-Signature: f38sfam3u79rtedaf9gdh7g693kpn39n
X-Rspam-User: 
X-HE-Tag: 1767984822-868567
X-HE-Meta: U2FsdGVkX1/djcxV4JM/f9BJcuO+G2AgKrrfOfB4LNuna3ijCazzDctXT2rWrlAYk+7LXP5zx+rumTc6neuec41X1yirbXtkUNETegDKwJN36YOVqCre3LYyflrxU6O8iQlW6k+cnjIxRArGiZVKljrh5aVkii0B5OJR06y8shHEbYIM1dnsnDD0u0w9roiAAJZWWPkPinllXj6dhSe4aai0zGacsHnQqdLyBK3pjSKVW8Jt5kggrmmZyBMn3Aslw6h6djThtW7XGgeitXcpS/mWei1NKhNYUUK+74Geht5sN5ffqtfd+J4aPHoi8aT0Vz7vM9F/D7KYAs0zfeeQaeOpS79UDYQUYp1pLNZ6fTmc524nXD4RMd8+DZf7GGyA96PKd7G3/w+hkAt8F4ALUsXVXGooCTmT/QS4urxdLHB5mX0ljDGCYktwzVg71gDeP0qxVe4usbC9D8a98XCfy8dAkUtnyg0WOrtLhQ4dAN8iBazS7ag0w6zHjMuu15JSXKtLELu9E3I7/SotTzu9twVlRJF8CZZmpmrupyqJQzgbtVZkS4pO2ZcR+cqbO0iY3sV7An7Ew4BxMnxb3KRqGhZAEH9hVXIe5iDswwWP3j4lnJe8OU4dKYkmBXc1hZX6ZcxuscTxij64/+0pFXy1ABJ+t/gv1XluditvsLqktCCRbYWacqpd5CZP8DUeg7oZUBIQzD95nXSM4AEIHOh6QBNdEpGw1/0PUf+few5yVoj3WGk0vk8oB+KoVISDWeogZFINuMx9lvCu936VWvHd3isrIfl89wmqFTwdCnH52RvqKKlQ/RhKJkouG1JPW4SJjZw1fEDx9OqjkXVMPIPbRK5MbfSDgT6IUCVArPKwWUT6NvTxIHDkG1ubi4RMZarmn/DvDCoJhwBfTuKrV3o/sGgv3EAwWS6pn3X0CtdDz6l+dikRIFCGmbammO0ehxCxWRvmDFLfUytlM5hbo+4
 CsKWIIJ7
 ylJ5EgxypBrf2JALwhWyAVo9c2MrufEELxjweMmolfNV3dX64d4sIDJaFgohfl+3g/gZc9vrt6eAeFHqOcle+WjOitUm6EjA/Vqv6eSCRwCikoBI4CrsnkxsFqW3yptffOPfbixqFi35I8x+Mp2q/sQT7KfIsZERNxw+u4lsoQmOTg0quAo+VWejiBFkmfJhyp52m88+j9ZczvUZrHRwSq8EndCZdo18p6bo8QlPwOabcKN4tS6kneWPq5DXUefhJXuRvJbnCDZDJ+akZuXtV708/jp8MM1BTON4Mni87URw+C5trGQhW6bJzNJgAPqcNRIuanm79bzCnKTTRV/KBxeVvKbfgtfT8GrNgQ3PGveFLkvmkLpx4H88T8Vb0x+BQTJNudYEs1+WEc3kBrW3nH9ZI90QcJ7Vz90FSeeOrtYcQA0GPLfRijWH/9no+lk1aZRAkDuniIqv939y8CRmMcqGxds7NzJbOV970q8kEV8A6Ix0vhlYk70RLO++c5zZn0py4wBm0ZjF2MEG+zTfoWopz0nscHvNF6gq1uCdaBqE/5uMQl9x8fvzRuXU0eXx/CrJ4OJN2fTF4JOth9hooJ99oQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jan 2026, at 13:26, Matthew Brost wrote:

> On Fri, Jan 09, 2026 at 12:28:22PM -0500, Zi Yan wrote:
>> On 9 Jan 2026, at 6:09, Mika Penttilä wrote:
>>
>>> Hi,
>>>
>>> On 1/9/26 10:54, Francois Dugast wrote:
>>>
>>>> From: Matthew Brost <matthew.brost@intel.com>
>>>>
>>>> Split device-private and coherent folios into individual pages before
>>>> freeing so that any order folio can be formed upon the next use of the
>>>> pages.
>>>>
>>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: David Hildenbrand <david@kernel.org>
>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-cxl@vger.kernel.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
>>>> ---
>>>>  mm/memremap.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/mm/memremap.c b/mm/memremap.c
>>>> index 63c6ab4fdf08..7289cdd6862f 100644
>>>> --- a/mm/memremap.c
>>>> +++ b/mm/memremap.c
>>>> @@ -453,6 +453,8 @@ void free_zone_device_folio(struct folio *folio)
>>>>  	case MEMORY_DEVICE_COHERENT:
>>>>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
>>>>  			break;
>>>> +
>>>> +		folio_split_unref(folio);
>>>>  		pgmap->ops->folio_free(folio);
>>>>  		percpu_ref_put_many(&folio->pgmap->ref, nr);
>>>>  		break;
>>>
>>> This breaks folio_free implementations like nouveau_dmem_folio_free
>>> which checks the folio order and act upon that.
>>> Maybe add an order parameter to folio_free or let the driver handle the split?
>
> 'let the driver handle the split?' - I had consisder this as an option.
>
>>
>> Passing an order parameter might be better to avoid exposing core MM internals
>> by asking drivers to undo compound pages.
>>
>
> It looks like Nouveau tracks free folios and free pages—something Xe’s
> device memory allocator (DRM Buddy) cannot do. I guess this answers my
> earlier question of how Nouveau avoids hitting the same bug as Xe / GPU
> SVM with respect to reusing folios. It appears Nouveau prefers not to
> split the folio, so I’m leaning toward moving this call into the
> driver’s folio_free function.

No, that creates asymmetric page handling and is error prone.

In addition, looking at nouveau’s implementation in
nouveau_dmem_page_alloc_locked(), it gets a folio from drm->dmem->free_folios,
which is never split, and passes it to zone_device_folio_init(). This
is wrong, since if the folio is large, it will go through prep_compound_page()
again. The bug has not manifested because there is only order-9 large folios.
Once mTHP support is added, how is nouveau going to allocate a order-4 folio
from a free order-9 folio? Maintain a per-order free folio list and
reimplement a buddy allocator? Nevertheless, nouveau’s implementation
is wrong by calling prep_compound_page() on a folio (already compound page).

Best Regards,
Yan, Zi

