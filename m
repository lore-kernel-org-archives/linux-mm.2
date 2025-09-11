Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A55CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 01:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED7E8E000A; Wed, 10 Sep 2025 21:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4BE8E0001; Wed, 10 Sep 2025 21:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3E58E000A; Wed, 10 Sep 2025 21:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9808E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:38:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D899F13965F
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:38:17 +0000 (UTC)
X-FDA: 83875259034.24.34058C5
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1B45C80011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:38:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C5P+1Wx9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757554695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysPDzD7a3oes0dNJ6mvWjMz9MR7z4uYBSERugTHv46Q=;
	b=yw0DokQgD1laujRxMYp1WOoa8HooMYPkjaKCEP+AR6yTxHVse9weivp1uihZDFHSYX+cEE
	mA23Pai7JcxoCafuHgRax0B5czm1R4+Gk0Mlc5Fsv1soW8FrMze9thk8UuwIxtntxN42sP
	Jn6vQ/ywTD6GNHpABbIa8mfYNdi5lvQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757554695; a=rsa-sha256;
	cv=pass;
	b=YjwkiTZHMJBB0nLiBAg/s0hC6DypWV05FcWRLPxXS5ZevljNyU+WbSdx6NpKoniWM48KBl
	p26ZRT1G/yw1GY2CeLcnQwt+vLkN3dVAT1epO47dQFxIExpZ48U7VN/zhkcQIllLGBPthh
	Q1Dyenn0LsMKMlguGLwcnQORq7uFwh0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C5P+1Wx9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ldhqu2SrhwVLGAMX0nFGeCq0mKxXMw5rQDoXclSLTOKaN/vAD7nZsGUIjVat1TG+W5yWkHDH5X7Y+jkv2CL0k0bJCASXC6KSjT4TzMaWHhvlBACd9gEayXoHa2Z7sNAwCIk/SGqfXzNP7W2QPrswS3ABOSPzhtUWWow2HrSH9s/VWxY41wi1OFSHS1/ScIRAocxHF0KDt9mY/yUDvT8vH4NzqMrK0a7arwGir27xNT9mFRQ1rhewXKEf33xT26IfIrAts8AqaVpS7CFVmNq+kbj4/3Px5EyNh4Vh7gcDxr+ptiALGVYKYlnDIctw3QAPMNpwt9TpUYgxOg/axzJGpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysPDzD7a3oes0dNJ6mvWjMz9MR7z4uYBSERugTHv46Q=;
 b=QrI5Upv9Y/mENv9/At2Z3QrRxl0gTbrt00zMc9gX75HhO23kLLnR+mNaNy/pFYzAzUXazcetHeOzlIQhbyZqbbsCzIsGT6sUib2Rv9jHX07ggHheLjhcXEdxJutNLa/HZ1bxNlLQIB2ZFpFtf9bFmsAzVcLsp20sg7Ul52TQAGe4NypXr/lk3Kf2n7QBuHCUYfohk8D5mT8SRURuSFdpe11L+H4qn4k4+mEtB105lrQ/QgVefcOX5TADSf2TUd5o0m6Zl5cSTUgFiOqC7CC61jjTtKJ1O9Bq+ECL/6m1K9fKaxHVgx9WMT3QdPMllEs+smBR2ukNKOV12cIEci0SzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysPDzD7a3oes0dNJ6mvWjMz9MR7z4uYBSERugTHv46Q=;
 b=C5P+1Wx99U1ue6g9fcBK9rzqcw2/BqO5PfG4FNxJjG8R6qqyfi5fOOKweOy9Y2VCEtnlEvqwN5yGNxOIx6N9wADHq/o9hP7+sqoIIlsUlqW0wkqmePEimFMhkBzn1uquQlp3HGZQYvw37dPsT6P+j6dRAZ6fkwzea+emG683k5aRTaj2QKI022s6OqG2QYo9POA6MI6jf/PKVUE370y+Rzu9rRPWugLc2jxEqV/9LpOD+1DXJXnz7DSuxbBCD/AS25lCGCioBWSDH/g4GsfmXQsLNWoJs84MhOZo3ZL/QNvYvDeWYuSR2oGQFgAL0pyOcil8j+Y/mbE+52Gd1TOyqQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY3PR12MB9632.namprd12.prod.outlook.com (2603:10b6:930:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 01:38:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 01:38:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: <akpm@linux-foundation.org>, <vbabka@suse.cz>, <surenb@google.com>,
 <mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
 <wangkefeng.wang@huawei.com>, <linux-mm@kvack.org>,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Wed, 10 Sep 2025 21:38:08 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
In-Reply-To: <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0154.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY3PR12MB9632:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a12fb4c-e868-4517-53fb-08ddf0d3ddcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUlEMTdyOGloRzljSEpJdUJEVUI1QUN4NGxSZExhb1M0UEJCSlJSclhQM2s2?=
 =?utf-8?B?S2VGdDVvTFluQml1NWdBbDFrcFZXN2xJcWlpSXJZL0Jxd0I5Zy95NFZTQjBy?=
 =?utf-8?B?aVBlK3JDUlVKYlhZQnRmQXdFbEhieXFHYjhnL0J6eGwyZ0hhS2xKQjVpZDhW?=
 =?utf-8?B?MkllUkZwTndTOW5OcVVjK3c1Vmt2WHdMQ0FzU3lLYlNQVlR3WE1ZU3ZJbTVp?=
 =?utf-8?B?bUJvZDgyUWRURUdiMXZWa1o5ZGl2WW92czd0Wm1LbTllRjNOaTJoQmhQUUFU?=
 =?utf-8?B?VWNGMHpTSzRSdmUyZXRsdnB2cmM4dk03MzJkZlp2TG8zWGc1VTl0SkpadDFK?=
 =?utf-8?B?aUIwQ2Q3L3AyZVRJdnRmNVByY0toYlpvY1orUDZVSjkzUTFiVHYraHBRRmE2?=
 =?utf-8?B?bXN1eFRpeGNOaVN1b3VLQlQ4T3pMZGI0blFrb0lpWFJnMERwTjNvWm9QN3I2?=
 =?utf-8?B?ZURkVEVEKzVVUWNsVld5OXhhMDJWV3pjdTViTUxSY05RMVptMHVYeDB6aEJ6?=
 =?utf-8?B?RGtXRlFIQWMwTGljNmNZRWdwVkZmdVVzM0xvcnhzTy9LdDl3MWdBOXVOM3dH?=
 =?utf-8?B?TENVN3FpS2c0bnRUR2JTQS9EdnZvblhoWGFMREJmZmRZbWZ5N2xCekU2azRB?=
 =?utf-8?B?QkVxY2o3c2NoNjFUcUcveUhRQnFKUTI0MjhZeWtPMHVFT25JRWNUOXVmYVZ5?=
 =?utf-8?B?UlRaMURYVS85Tyt5cWNFK0ZFL1pwUGhHM3lNR0szNXpIOGlLbXUwMVdDTlJI?=
 =?utf-8?B?R0o3K3Y3VDM4TWN2K2xFT1VKM3lFVnQxTDdwQ3hteGJza3RxSjVwSlE3SllO?=
 =?utf-8?B?MERxeU55VllEUTNqeENTeGFNTG01UjEzUm9NbjNneTF6cEpENlduSEpvRm9N?=
 =?utf-8?B?ekpOOEdWL0duWDlibUdDbGNYK3d2ZExWMTRibTZQM1VZUnJSbVMvVDFVTWsz?=
 =?utf-8?B?c0xocmhyR1VXb1BrbEpldldIVEpIdDB3c09mcFVxNHZOVkR2QUtSTC9JZ3lj?=
 =?utf-8?B?QjdMMkxkSkJNQmN4ejUzd1hTZnpVMjhsd0RrTjY1ZndsajgzWTYrSTliQ3Jj?=
 =?utf-8?B?cXYrRktrQlNCY2taVXc3SnhWZHpMc3BmY2QyTFRVUVJtVkhSVmlZd1NHbnJY?=
 =?utf-8?B?dWQyNmJiQmxXNjhWTlJDT0VMRkZaUjRmTG9TVENUVlI2OW5sbDdvRzFGTWtx?=
 =?utf-8?B?MWRzT1F1U0Mxd3NNR2tJOWpEVnhsKzhGWUNvajMwbEp3ZjFUbDh2RmZKWVlQ?=
 =?utf-8?B?SjVsdzU3NjI0VmhiVXUxbityV29KZmFnVzNtVDNOaWpmM2FPS2hHTHMvcXNO?=
 =?utf-8?B?WlJkUXZBanp2M0plT3NzbWpTY2hMS2g2QVdLcXREWlBpc3g1N3NGZnp2QTJR?=
 =?utf-8?B?VUxnTExOUFhXTEJRcVhMeTB2bFlFcFR0R1JGcWp3djA1Z29Cb0JkVTZ5RUtZ?=
 =?utf-8?B?TGx5MXNrVnk5NnRvT2tuN29DcTlnVDZoUkJlaEtSL3RlakNnK2lWMXNVNHRa?=
 =?utf-8?B?OUVtOVd6cDZIYkVyeFRIY2Raa3pIRDQzV2F5MUUwNWxEYklVQ2RQblVqK1Z5?=
 =?utf-8?B?RnN2YWlPTW5jUGgvcWtrVDBMNExDemlSSFhEcjNxNlNZZWtEaG1kVlV2T3Q3?=
 =?utf-8?B?bWxlRURMQkM3aGF1cVk0YVo0a2c4cVRBOXNjSkFkcDlLVEJsZWpyV01hYnhU?=
 =?utf-8?B?S1VvUmpwZmYweGVHdnlLNG5vckJnOE9EZUNteEp5aG0rRXhoWGh0ZXhxQ2E5?=
 =?utf-8?B?SDBTYms2amNwWnQ0NWM2ZHhLWmw3UGMwakdTRnQ5SzNZTnB2OTBJTkQrUkNT?=
 =?utf-8?B?aUJyQlc1NnRNYU9qTkQ4ZlVHYmpKVXBqSHRiRWIvN2hMWlZ5UTg0NHNLZUJw?=
 =?utf-8?B?akF1bjJvTWcwZWt3OEwxNFo0NUxSUmlBL0Q1RkVYNFdLS3krOXpoeEphUUtw?=
 =?utf-8?Q?mu17qiuzR3w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2VodDlNeEQyN2daVHowcVp5ZUpMeEtxRjZrcHcvRWZSZHlIWkNmcnlBTDI3?=
 =?utf-8?B?aUZOdVI5c3g0RXFyald2aG9kdFIxdi9xeURoRFlWS1EyYUo1dTVIeU11SDZm?=
 =?utf-8?B?Mng0RGsxb1hjbkdyNStIdE9QYVo2SStQT09Uc2YvZDNaY0tXN0tFd25JaHY3?=
 =?utf-8?B?SThoSEJ4cUp0cVkyb1YvbFdmRTRyNnJodmhJSCttaUlpSVg4V3g2UHh1RDFZ?=
 =?utf-8?B?YXU4NVpEM3l1NW5YdXFmckhSYzhGb0g2eFVEZFRuSHNKeXlmQ1A0NjdSNmpT?=
 =?utf-8?B?VktRalFJN2w0dGxKMjRpRlV5c3hrNUdKQjQxOVN0aTIrQlo2a0d6U2hyZFcy?=
 =?utf-8?B?dUZXK0NIa3AzTGg5cjByVnduZ1lEcCswRFhaMFFZbUpBS05maytwTmFPdVMx?=
 =?utf-8?B?MFJidmFGejVFZFVoUGh0dUduL2lVSWFkVTcyMDRMMGlMWStBRElqL3pqaGFk?=
 =?utf-8?B?ZVFoWmxTRVZDakVtdFFnQXBrL2lXOC9GU29wMFg5V1FzL1R3eUZQNUZBcGN5?=
 =?utf-8?B?QjlpVjNiaXRrZStYV28xVktHYjJUZkpuaE9RRjltaHJmd09rYjBXUHBsRml1?=
 =?utf-8?B?NGExUTVoNThML3lodHYyOWFjRXNGaTM5NGNtUTMwaVJsUHBpT21ZdndWSnZl?=
 =?utf-8?B?MnhuMXJIYUlBWENJMEl3bEJxVTBTcC81ckpxWkVabXgvYk8yT3RaYk5lMGJu?=
 =?utf-8?B?N1BLKzI3bjVSa01zdHZKVnNOTkVTTTlvMTNaOGJYWE9RV2tJaWNucnMyMnlp?=
 =?utf-8?B?bDUwTmFxTlNVNU5kUFg2a1pjZUtoTTRaR0xlbXNuMTNGUmZpV1F3M1dLZDNL?=
 =?utf-8?B?eVNoV0FVbVlPTkNKa1h5c3JGSFZtRVM5Z0ExcVZrbU5xTno2eTdybytkWE5I?=
 =?utf-8?B?YkN6b1FNMHlyeGpES1l5ckRSNTBFVExyeklrWjhIeWdYWENLbnpKUmZNa2pH?=
 =?utf-8?B?M2ZiZkJlcXpJNDQ4ZWd1NzZhWWYxeHlCM05pMk1mWmdLbEVEa1JFL09hWHV2?=
 =?utf-8?B?dmQxd1FQa1lqS2JHdHNITlNzWUppQjlWbVlWcjQ1S0FQbWtKTFZZNUY2cEVk?=
 =?utf-8?B?Q2FxVTRMdEl4Tkc3cnV6T0RDSVNZK0lBKzZZSVU3UkVuaXVrV0dlZ2lMMGRz?=
 =?utf-8?B?bW1CWVJBSElOUmVicFo5ZWZuVlF6RGFIVm1WN1F1MmFaRDF2YlBRNEswV0V5?=
 =?utf-8?B?eDZXOFJWcXNjRHhtLzQxRVc0VVJ6TnE4VlRmOWlqL1dqMUJvbUtHSFB0YVVI?=
 =?utf-8?B?MGhIZkFFcGNIUUJhNnlWcmJoK2FNdWhwcGpPcXNvVlNDMUtHUnRNeUZqdnMz?=
 =?utf-8?B?RXpMQmZMc1h3dzl5WlVTZnc0UW9yRGxCbzE4a1hhZlo2RFlINHVZcXpRU1NJ?=
 =?utf-8?B?S0VFblhBcW5sWVdIRmpWUDRCRHZkd1k3cnVVeHl3TlZyQVR3ckgwSlZuVGJz?=
 =?utf-8?B?cWxpZDJOVjdKZHpvZUIrUmFJQ0NPRzROcHRXRFJiK3R3M3c5aDl5S0dwbEdR?=
 =?utf-8?B?S3dTYkovOFVzNkV1OG1VeXFGTHUybFZxVlViMk9mUktEOGF1RVpLenZlbGQ4?=
 =?utf-8?B?eHdUZFlRVnByVUxpOC9KdzNWN3pPMXMyUmhvYTF5Q3FLTk04WFMyYjE5T3U4?=
 =?utf-8?B?Y0VSV041dnkwSlR2T0F2T2wvMXo4eE1xV0h2RzVmSjNFUno1elZLcUpCOWoy?=
 =?utf-8?B?TnFlcGtvTTIrN3lING16c2ZjOUZqUEdQUExiNjVRSStsK2FLZTFoZnBUWm1P?=
 =?utf-8?B?RWNwQ1k0MkREMGdScG1qUnhqbzFQYWdSOE03SEJDK3IzZU50Y01zOE9GTnU2?=
 =?utf-8?B?VDEvWDZFSnJKR2pQUUJnVkNrNnhZdWpRUGp0a3lpUG9OZFFyYUNIZkpZY0lR?=
 =?utf-8?B?UWtrb1VIcStqd0k5WWVuZ29wbzdYNGlmTElmcTFFYjY3V1B1ZjZCQ0Y4dlJn?=
 =?utf-8?B?anlnUGNVMlRmVDVYVklCcGVnR0psNGYvNzV4cTNzTTNCdjVDYWFwRTFiSlFE?=
 =?utf-8?B?c0x0QlFJQzllOHljWUdYWVRERjc0MTQ4OW43bXQ0TFJvYVExWXUvSGg4QU9y?=
 =?utf-8?B?NVZLQWN1OWwxYkpuUE5Ndk5abTcrbWpxUTlZNHl5bUF6N2hNcU56a1FlUkNB?=
 =?utf-8?Q?r7mMNJf89Z2PiOodWy/Db76Vd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a12fb4c-e868-4517-53fb-08ddf0d3ddcc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 01:38:10.7458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jB2FD3ueTr94/WKcLZAvaJeTbSCiDvdR6C5s5gepG+0WJJtTGeq/Bmkae5E31iJd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9632
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B45C80011
X-Stat-Signature: 61ixmhf6ro5xnitosrdh15z84d6pbp7d
X-Rspam-User: 
X-HE-Tag: 1757554694-611958
X-HE-Meta: U2FsdGVkX199fzUumkh5AFo/3GPbq1eyrkrGsr2Xl8pJsaVqVSnSoWnAvyCvgoglaXG99kJqoMEeF1QImRqtzmBkrFBbOC3DOmPC7zCbj5SLGx+QjR9acbIkxfxwO7HKZEQo27FJR3UNUjfwJL9EMfa+OJwocXkhqXdLdRDRIDI4DbP+B9CnblTzPI92CuQekEeRyNud9qG6B6L9iAQa6YvqduaK58ssKzS8pd+pl0Vi5FyhYw9KYURwP2XtcEN3hJH6HLNRD1bJoEYCYil2K8il3+nsRkX8FQMM8l/qalIOZUDlOoiokn+ZeTHk9b/67OBqsyYBhtQYLJ1XWSeRNDozOwGqk1ARBaeHB83EW7Uhe5R6JAk2Ucm3gAP0tds6Y2XfPBEZh0LA9bwyUFdsS/fhcxpOe7iYlRph67x9ja+1VrMe8ocPuciQmSRSI82Q022AAH4IzopwK4FvnLOzR7sLKAUMgnr0QfO40wE7UR8uOTuzXG0WI8Yo0OFHictrRS8GDfJvr02ogEAUQ6doRFvEQg/bW3i3Ax5p4PN1sZgBb4WYbMJu2iZYoNLreWNRLrrDjxcmsY0t1Dw3+kAvP2TZ7WEv5CJfJnJrouewKdTXvbdCpO2WfWscDempR77NSUZVvROgCTyd8LHCMVg57QxqTJZBdZY6lLyZsG3UEvfiDbBDj9wb7/QhpoMPAxCsnG8jv4ucKikHPGoewzJGmVkQV/MF1FaHOxNZZKeQxsXTqBjOVtqHeGpG28+zYBzJNjuhEfMdaKytQQdyO95VyI5j5qJr0YN6VeECUNFOuMaMu+DgBJeQYfhRGAXocbOwiyHz7GfwOpWNBPrIYDSk5sZjz3IL+CBk7EZZr/d7bNynmQOr5w4ToXoFbZR75xjEcdGEbMu2G36vWnb32yTh7Vuz1TLn7io/DvAPUHmVitwFUAP/ChkyeqGDDDZ/sNlIKXLvhLo3uCDFt8KRcSX
 DN0uXvbs
 ILh5hrXoGIUd1uDroaeidr6esCVjEBfIrBvHNFTT4IowtHxbN/X7TDJR31KQL70DA6OgrQrnqEuSFF7xae+Gh735VxvrYR78INUyd1C7ihSrWNir1lX+tvqycYGmg8EWy/44xM3hDcg6eGJlRvZSELvpQ4ahXPuMQXAazR/8dwInF2ONQTSCHAgPU4GMbG8N+xUiAJoKhPoPMgl0/vI3vXC7BFB1YP9hdu+5GhUK2TiHEaFsTrq2CSxxfLYrl9/huBkyI6yMqWF6284jHD9kjgW//Z2SLpexCWhy1dtQ5Grl1IfNvwipwB2b1su85JXL9KwxV1BMyz5cj/Jdhl/9MBfsCIqWU/rFbvUoB8O8/8q6Q6Zk/rFQ81D3nupCZSq4hdx0zIYaHoMNm4D+Lcrp82OlnaWXoKEJtgNhCtL9ozY29/U04LWMgWb3842Rlq6d8CmEC/O4Nc8bjFeEPYLunjfCZ1d7lJhwlqukiAyCJ8FOWFvLZbjsiGqC5OHl9STcG9MYOf5n9CbTogVe7gZ4ebc2vEgnJAbnxCYlrryjvoS/OX9c+UA0VFjyzEBYaUnivNr3+msuR5vm1bBXJhIl7k+6G5ziGp1umhSToHctpKDNQ9SA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Sep 2025, at 21:35, Zi Yan wrote:

> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>
>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>> isolate_migratepages_block()") converts api from page to folio. But the
>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
>>> to head page.
>>>
>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>> which means low_pfn only advance one in next iteration. After the
>>> change, low_pfn would advance more than the hugetlb range, since
>>> folio_nr_pages() always return total number of the large page. This
>>> results in skipping some range to isolate and then to migrate.
>>>
>>> The worst case for alloc_contig is it does all the isolation and
>>> migration, but finally find some range is still not isolated. And then
>>> undo all the work and try a new range.
>>>
>>> Advance low_pfn to the end of hugetlb.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate=
_migratepages_block()")
>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>
>> Forgot to cc stable.
>>
>> Cc: <stable@vger.kernel.org>
>
> Is there any bug report to justify the backport? Since it is more likely
> to be a performance issue instead of a correctness issue.
>
>>
>>> ---
>>> mm/compaction.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>> index bf021b31c7ec..1e8f8eca318c 100644
>>> --- a/mm/compaction.c
>>> +++ b/mm/compaction.c
>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *=
cc, unsigned long low_pfn,
>>> 				 * Hugepage was successfully isolated and placed
>>> 				 * on the cc->migratepages list.
>>> 				 */
>>> -				low_pfn +=3D folio_nr_pages(folio) - 1;
>>> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio, page) -=
 1;
>>
>> One question is why we advance compound_nr() in original version.
>>
>> Yes, there are several places advancing compound_nr(), but it seems to i=
terate
>> on the same large page and do the same thing and advance 1 again.
>>
>> Not sure which part story I missed.
>
> isolate_migratepages_block() starts from the beginning of a pageblock.
> How likely the code hit in the middle of a hugetlb?
>

In addition, there are two other =E2=80=9Clow_pfn +=3D (1UL << order) - 1=
=E2=80=9D
in the if (PageHuge(page)), why not change them too if you think
page can point to the middle of a hugetlb?

Best Regards,
Yan, Zi

