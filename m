Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B536CCD1AB
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BDE8E0005; Mon, 20 Oct 2025 15:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC838E0002; Mon, 20 Oct 2025 15:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D488E0005; Mon, 20 Oct 2025 15:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45FE68E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:56:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7FFA160294
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:56:07 +0000 (UTC)
X-FDA: 84019548774.02.550336D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011011.outbound.protection.outlook.com [40.107.208.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0874180010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:56:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z62JvQN9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760990165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gP3xDs62LNe0sqQMlFcipHjwYzxPTeracwUxDgrojK0=;
	b=lGFOAPqK5uO1XgT3QnGu8dKmCiJtFE82ppxQHI1T7YKPw5a0EZjQT7fAkgags+UWMJ+lOU
	V6+nIRPx4mHoRWGELOlcIu66On+I1312Ag9bIjqqmBUbtp70GMxJDVyCmCtaOFXNRq8gI5
	Cu6IJm/rRzU4u7SNSK2ty1dw/6gYZdw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760990165; a=rsa-sha256;
	cv=pass;
	b=TQcYKAVgO00dtVMBYuQ6JJVi+uC8gxdSO0880EpCRAPDOQWPh4JilUo5CUx91F5fEL5Qi5
	ELGRnqcWnswx4fg/aHZjXU9h5PGM8K404Bo1E3clFNJto8eeSTuhllFL8X8VZsJzWRcelM
	Gek1ZCVlHroLv+//7Pe3d+BljJeNTNE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z62JvQN9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QV/hGYAzjPL2BC5XvQYg/qPeEnYDSNeRsc2DSXGVJTYPEA4J+e5PSKJ2XJDjrZ+ZKbuwzu/N56OiAfpcJEtHrHaU6qbSgipefyKMYTzwRarb8mXc6aVEUTFsBGup+GrB+Vo/BBG8CJfr/PHAOFdUBY3PlV2z9BfXkIdjqHhZWbpHOAJD3xR6868ySuz0n9Cr+YPI091hvdTSs6WXF7wbRTFAkhPO89cc6uI0Bl9OpmCMxwtDVLSEYVw1Tv75hla+2xpLM/tdGUWjK82TYzfkq+V0vklFnD+pJxybsagD/MZpaWaUX+rFnM9/Vz8mVqLMcIaaZHw6QaX7Dxz2ykMmwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gP3xDs62LNe0sqQMlFcipHjwYzxPTeracwUxDgrojK0=;
 b=rs6M1WJz11cLjURKPefAzBAQ51qAjl87Rp+bxALPzlMl2W++w1cbXPRzRYZe+InKREsWFX5ufZ3AN/fk/XtEc934/fxvBZW1zk4m/mK6+Tr01xQXrGvrQV38uuTwtHSEBHbC/t05DNwRdZAMQtR+LpS6AtwZAw+8PyFEeo7OTo/7FgWPPv/MlvcwCYzKqhvoE/hfQ3TattVvd3sNBrMQXYS3O8Y8iCAftFGVDS3XQOj/LTjgnHQNJaBw4acBJlvVkadcR1i0JHChcSkx11avXfKnaMpnuc41Y3qg8Iciz/4CZ1xSV+YFyLdOWbKG2z24gKYB0wE/qn1X36NDvA5zxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gP3xDs62LNe0sqQMlFcipHjwYzxPTeracwUxDgrojK0=;
 b=Z62JvQN9tm6crCkS2/FLqBwNSX6kzo2Vt6ntAQnvCeHXdLs7TY5qHv+vZnswbKRIdqWXZ6NKIHb/3Ad11Z0aap6Mvd0uw18cjhBzW/JOndlDGVxtZXqeS7yfYgcRIiW5YpGZ+pMMV7yDlxW8xMrR0bTuS6rfaWamOL9ST1iifH74kFyOJOSbbQsukKwgIIryW/CjLcQSyahOxhPE1PjJuEPHLc5uG3mPNqYZOnbhPXmGpqxvOAp+NS4khbKCndCgKfsz07ohcSia7j6P4GeKRJPoJ4WGhRf3jDpGdfpw6ic7SrTqbK+ZYJm/+bG20BAP7S1uBYubbQ7kdsX7sVJRKQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8970.namprd12.prod.outlook.com (2603:10b6:610:176::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 19:55:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 19:55:59 +0000
From: Zi Yan <ziy@nvidia.com>
To: jinji zhong <jinji.z.zhong@gmail.com>
Cc: akpm@linux-foundation.org, feng.han@honor.com, hannes@cmpxchg.org,
 jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 liulu.liu@honor.com, mhocko@suse.com, surenb@google.com, vbabka@suse.cz,
 zhongjinji@honor.com
Subject: Re: [PATCH v0] mm/page_alloc: Cleanup for __del_page_from_free_list()
Date: Mon, 20 Oct 2025 15:55:56 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <7E6AC98B-29FC-4B92-BF72-56615D22CBF0@nvidia.com>
In-Reply-To: <20251020150626.2296-1-jinji.z.zhong@gmail.com>
References: <7B0DF4ED-FBB8-48E5-95B7-4C32B645F4A6@nvidia.com>
 <20251020150626.2296-1-jinji.z.zhong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0140.namprd04.prod.outlook.com
 (2603:10b6:408:ed::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8970:EE_
X-MS-Office365-Filtering-Correlation-Id: 581397ad-cf1a-4e92-2205-08de1012b060
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFk4ZVk0SmQxVnNaSWN5R3B2L1NUSkhaejhmVjJLTlkzRzJMNkorVmYrSFho?=
 =?utf-8?B?M0d1YkRPSE05amhSS2FVdU1OaDNLcGhFZk1kZzRZdjdjTWw0bDRuVVlibmlH?=
 =?utf-8?B?ZGdZWldHSS9Ja0lvS2J3RzZKU1hxVXBBVEF2Z2pxUG14aWNHMkx2ZzB4S2hE?=
 =?utf-8?B?b20yWDB6eEJwdGFHVkprTUtJQTJYOEVYbE5wTmxlcjIrYzQyMjF0ZWg0WHdr?=
 =?utf-8?B?L0RwSFlJOWRGU25VMEpWSGZjWVBwc3hJQUxYcDNQM0kzVkFmdENLY00zUzE2?=
 =?utf-8?B?NDN1aSt3K2dFVitoVnR2WFNaN084SkhDTENLeVVtejQyUG9DNDVzZHYrRkJr?=
 =?utf-8?B?NVhseEZtV3QrSXA3SFREOFRmbm54VkRpd0VEM2NKWVMvWDNuMjN1U1JsNmxj?=
 =?utf-8?B?SjN1YnczMDc5cEJqV1JtRTZOV1NaTHNYUU9tR293aXBTV1NCaFFZcjVWd3N4?=
 =?utf-8?B?TTRlZUJpYXBDbHpQOU5WTkpKdlJKelZzZ1BNVThyTHhoVDZaVVM1UFdhYXpS?=
 =?utf-8?B?WmdkOFVuc0JhOXh4ZTU5N0tZcnE0akdyaUZ1SUJkVkl0bXhaV0FJcEh6TTlI?=
 =?utf-8?B?aDdNajQvenNxeFdDLzM4Wnh4OEJicVlUU1dtenhNZ05OQ2NBSGRiZVJJUWRv?=
 =?utf-8?B?QW5DWHpCZUFiS2dsWlZRRzI2TkhzTXhxUU1mRXdkRnVNdHkreTdPNEJNcDVa?=
 =?utf-8?B?bDdlTy91VUVsbjNvbnJ3dHZrQ3JJMzZmbVQwWGs2bTNZVW5QOFNJOXFVenJS?=
 =?utf-8?B?ZG90S0tNaTU0UlFpV291ZkQ2aGJObnV5bVYwU05FeDNTdksyZXhvendscFgz?=
 =?utf-8?B?a09rSXhyQStxNjJXRkEwY1kya1NKOXRhYTdnYURCNjdNOVYvWklqc1VUbGZT?=
 =?utf-8?B?S1lZY2tLemM4RG9CYk5QcGQwS2NMZy9VNWYvYjZ4VUliL0tkenhFV1NzeXg4?=
 =?utf-8?B?U2ZLcGVWZ3FDOXE1cVFNWDVKelJUbDBodWZmLzd6OEg0TWt1cTRVc1UwbU5C?=
 =?utf-8?B?Yk5tbVc2dXdwVVZ5OW1uSlJWQk1ydUJvTDdvbW5WQW9lVXJ0QlRXOGhVN3hr?=
 =?utf-8?B?N1lIMXNwNVNpSlNRNEhZWVYxTFNwNDArTVNyN0U3RGc5T3pHL0tVc2NzM1o4?=
 =?utf-8?B?WTVHL1BKa291eEphMUxNbVBGOUZXNUJkNkswMDJzcVZlUkp3MlFsbFRwUXRr?=
 =?utf-8?B?T0wwQkdsbE9xTGFFNTg4R0VPVGNlNHU5WXZDejVYcWFxUFpOakhBTEVlOHRo?=
 =?utf-8?B?TWxXRlFNV1NTbG1aNDFpaFRjY3VQV293S3JhMGFWVkU0cVhjaDlPRFZHbGRq?=
 =?utf-8?B?QjRMK0lrdFRGMXZ3Qk5peWVGM2VSZTZHRTYyTTRrNEhTMFphOTFsQWtFUFZU?=
 =?utf-8?B?R3g1WnQ2d2NPdGF2djlOQ1NuMFJSM0xDY3VCUDNMQjk0Ylg2WmZoczYvdFE1?=
 =?utf-8?B?cFloYitjN0hwMHd5UDRQcURKenl6cWlvS2hXUHQrVkl2RUwybTRKWlgxTkRy?=
 =?utf-8?B?UDZPQW9UclJjR0FmanJmcmZnNFhTTExDS056UG50QzM1K25SSktCeWVlYWFF?=
 =?utf-8?B?UXFuTGdBR1FWWU9MQWl4c1VvV2xzTlZGQW0yeldQeWZkYjZzVWVCSHlOaFoz?=
 =?utf-8?B?TUlFbjYrWE5mYXM0bmI3RFZXUy9hR0UzQlIyYkZOKzRpQSt3d01VaFcrb1VE?=
 =?utf-8?B?S2ZFN1ZHYTJ4SlhxN05Ec0JKb1huWTZHczVEK2ZYSzFheG4vT0pWcVlpUHpj?=
 =?utf-8?B?ai80ZmFmVkZnakkwSnRyUGlRcGNwWXNjeEJOcTZDaHcvTG1pekd6ZVJRL2Zw?=
 =?utf-8?B?QVI4T0k0T2cvWjBYTy9JaE4wd2pzcnBTYmpVVVl2QjZCcm9qbW5jcElGaDcw?=
 =?utf-8?B?OG1taHNXK3c5UTJRM1ZrOEF2MWNhQ0tvb096YitWbndmd3NZRVRBaDgxSkZ1?=
 =?utf-8?B?MUlGc2pVdFlMNlZjR0FZeFJvY21qSXRSeE5kRjdQbFBKTmx0WkhNcGwwdUIv?=
 =?utf-8?B?N1BNakpTZnV3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnYwMjZSVDNGRW9yYy9JT0pBdFdxVE51UTBicTdYR2xucDdacVJJNGlMWEY5?=
 =?utf-8?B?WEh1K09XbldXSTdRVzVEVVUzTExNODVKRFhiSXpXNVFQbGh4VUx1UDFTcjhL?=
 =?utf-8?B?REZkd1d1aGswRlpYd1pNQVZDN2hCL2ttWmU2M2JFWDhidTltQ21DdDhlemdp?=
 =?utf-8?B?L2ZzM2xlRm1DZ1krdHhNMzV1cE5YRWdVK3VmdGhsWjRTT1BRenJWVkhEMFVD?=
 =?utf-8?B?dWJ4WDFqS1NqM096SDlpSW1iTysremtVUHdzYytqejZiRXVYbHN4YmJOclJp?=
 =?utf-8?B?bXhEQXlPRnUwWVNXTVpySXFxN2dnTXhiUHZON1gwYWR0b1liMFZhM2dFaGZM?=
 =?utf-8?B?Um5aTkl4SlZxSk1nVkYreW1uTURxaURPd1hHc3p1YkdOekJOaDEyQzJlMEw4?=
 =?utf-8?B?eXB1R3dJdzUyc2srV0JxTlVoenR6WkloWmVnR0xKN2NWMC9na1JFN2dPMVJL?=
 =?utf-8?B?U1dFSTRLTFg2VEllWmVhWi9ZMTA2a3Rpa1pkWjZxaDZLVXNKY0ZscGVNUnl5?=
 =?utf-8?B?RzJFcXAybHRMVXViTlpkUUxiL1dCcVJRUHE1S2JITVdFN0J1bkpZZW9LWnh1?=
 =?utf-8?B?WXY0WXlvbGxpLzJ5SmR3K1FMZFNrSmU1WDNQVm0yQlZRY0tIZnZpV0EvUFds?=
 =?utf-8?B?RXVTSEhxb1dVUlZLYklTZXlDZmFrUFFqOHd3U29qTDhmU1VWbG1UVEVVejhv?=
 =?utf-8?B?cy9aTm1wNHFUTi9NUCtLbmk4RWp1cHp5VFlwQVNyM0JNaXBvS2lDeFpTQ0FV?=
 =?utf-8?B?eHo5VlJIMjUybHZ3bENvOW9aZ0l0RlBuNmpMTndsYnNHbEJic2FIWWhILzhP?=
 =?utf-8?B?U29nY21iSWNONC8vZDNjdit0VDdIeFYyYTFURTEwM0I4MWs2WmNFZjVoT0lX?=
 =?utf-8?B?Vnp6NXlMbDFCTnFwMGI1QnlIc0F3VzlqVmJ3dVlZQjN0ang2OUZRM09lRFlv?=
 =?utf-8?B?WkhxUERiOFRGek1qM2ZNU3ZYWDNyelBndi9IMzhVZWlrSm5aWVQrMUw0dFJv?=
 =?utf-8?B?WDdzQWdXRkUxQjlUT0diNnVqUlFmK3lkTTliNzAyczBNTWlzQUp0Q2MzS1FT?=
 =?utf-8?B?SWJ1QUkyVyt0ck1wRk9DSXE3QXBRcTVzQVRDdUF1ckZxend6UjcrUmVBMkVH?=
 =?utf-8?B?VDdFT2Y0Wk5CcW96VkxCYy93cEp0RzdxdUhURXJIUFZiS2dIUjB1aWlEbWVN?=
 =?utf-8?B?Rlhxdkp1bjFUZ0VmRXhaVUJ1ZXliL1N0SXhiSmJLMUUvZk5HR2NLZHc5cUla?=
 =?utf-8?B?eDJ5SDA1eWdnTHFMY1l6dVQvaWsxMmRSck9OeXRtd21BRDV0d1hZa2dCZWFC?=
 =?utf-8?B?aFBkcXVCTmEwZFRZWUdVZlZiOTk2VmtUZEQ4WjlWL2VvdldvL29rQU1MTmFX?=
 =?utf-8?B?THo0aC80TU1JMDFROXNwSnRPekhrS3NmdGJsU1J6MzREd252NUdHYmcyRjQ1?=
 =?utf-8?B?alVIU3kya3d2UnFBdlN2Z2V0TGlpS3Z2WTR3OTBRcFkwZVozYVRNeXpaclZE?=
 =?utf-8?B?NEY3NjF3b3dSdXVhNGp5ZG8ycS9SZzFScStUb0V2QldVQ0JLby9UOExXY0w0?=
 =?utf-8?B?aGtzRndBUjFnRmxnUXdrNngvS2pOWFE5VVBEMmd1cmhjQ2VVUnRCbEVrSDBW?=
 =?utf-8?B?c1ZrR2VSZDN5ekEzRTVvWmtVL3ZJeFN0cGpKclI0VWlSWGgxM2VtVWs4R0Qy?=
 =?utf-8?B?Y092THA4dHMyUjc3V29pWDNlY05oeWxlSVlXUEk1SUN1MEFweE8yV21Kc0pq?=
 =?utf-8?B?N2l6eWNUY0tDWmFEUVg0MVpUVUpTY04xL0ppM2FQeXR0b2Uxa2d2dGRiTGQ0?=
 =?utf-8?B?VW12bVFGeVZrZzhJOGR0SUc2cyttKy8xcGYvOXhWWVlHcWs1MmsvQmNyY29h?=
 =?utf-8?B?Yk8zZGx0TTBQUWtybGRVVHhvZEtvYURFQStmRjFlMGE3bGNraTBscXQ2SUxB?=
 =?utf-8?B?KzFpNk0xcU9NWDJSTmNoQUFPZGRZMEVxQXZ3bzhmSFE5c0ZiV3FMQW1RQTdJ?=
 =?utf-8?B?MzZtMHJQeVZXeDFzZTRqbHBBSjdkRHlUQVh3cVpZVWNOYzJTV2hacEZPak1Z?=
 =?utf-8?B?dXh3NVRSeGhieXFuc3QrcXZpSW5jMHIxdUZDTnVlYk0wREZYTXhLcStkUW9w?=
 =?utf-8?Q?5ebr+eR3gsp11zpbUVE0BvbTv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 581397ad-cf1a-4e92-2205-08de1012b060
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 19:55:58.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDlSVj2S1vqtwO/R1pPw+5Y1zR/pVkC3JT/KHR4czyFI02oJtjOWoRgOoZrjjvMx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8970
X-Rspamd-Server: rspam05
X-Stat-Signature: ratpt9eyrmj69pp6pkxuoyrb1mrqm7nt
X-Rspam-User: 
X-Rspamd-Queue-Id: E0874180010
X-HE-Tag: 1760990164-706223
X-HE-Meta: U2FsdGVkX1+tuaSmvLB2944tXgeNokoaXHhp37uc3E+iAZArI+aO9EF/A3E+bGfeNV/+VOFPo3FBGHXakKF7sddGA/3H2nWHmPYoOOzwcyu941VBf3kCyEO3T88xAvsm/3XE5dazlyEc2q4HX4j9LUIa9EMoZyZO+rJWZMGVpvmIaVPRkSYNEvN8UpDFEhL0GCjU+9roiOxjOKSVbUJy/lzzndvDEPQ/Od0Ovn+01o5Tu9t89+CluERYl8fYoChZMCOkyvPas64W7k7ubYBdBIsi5xNd9ZZQa5A8BTrw4NIIYzLtIzho9mSjZf6H5mRQGgt1SKiHsITj3rW05gCeDs7nkR8Pzsj1wMU8CL0O60douqZ0IXuXRvn+5bsfOV0N4wf6WYSaOUO5vB3ctSZzyGSJj7uU+fLVJGClPJiv3iX2RCvRJjvkvvusn6Pov5iWH0R906DtoKzhPFYEZwiSgTEl1s4ksUqnKEEzgikpYzMuyAbCyuY+fVOP5rH9gL3i7/OEuFXzKKwGH8Wd/kTkKRi3igbEwBRMHEjc5VpcVgLcCrknatrG0QaUgfR1kQvtkKwT346i2pLtcOsNnPjUXtT0tuhFt3lLu7y9ngC2CsqGvHly+SdbQCopK5X9jvEAnPSabQEDCcos9it41191I6liLHDPjUkM2PakVaRGpkCLJ3eZ+OJ4ki5QWzM8hb1m+Bqsso1zdPs3UHjSLb1CjaVmaoyip1Vs9RHD50bFZ/cUizv5nc7V1QbCRtLo1AewBiJ1Fw1BjUVkEAapaX/b8QQ3g45Z4mURqqVOpO6tTgWLgIbwF/pEPpzWBb9xAzRhFi6OBMKF4fRnD+h3/PhSaiV01ufVTxCpuRfH6z/LxtH6j/PlrOutJ82QJD8QfGLNuxwEimgF1rfO/vCA+Mh4k+3AEyfBAu0Aw4xukZjNTVmqV+YD5TrHkdezWzITQG6XMv1I5FfSug4ALbTdZao
 dseDiY8s
 rTnE2W9lpgRelaUoYJx0q79HmbvlOJj8KT1BMlgn/pHLvFNs/qzFm9S1CSrykDA0EWZWABiwpKPpnUhtpuijswoK2nkxS008BdhZydOlRt2n2X0hZtYtA98y62jzgOPOYtIeUuFtRP/VqOIUq/6HWEC1ATi6ZcJ0QBuxvFbzWtfiQSYffrYhot3yBpyz9ntQps0m+OMLBQBW6ks6QV7AnFiVxTIy/vbLGvTEjx567HLvXEwHzgNVqzvJvq2GWx5SAvZL+NI64/a326pAbVoGm+ESt2VwNsQXLOYGWSxoSPRfPrqmzi9euw7q5BFsBblumwdvNYKCAH13zAF3E/qcf2adSpZsEuuCcLcEY6UeiXMJHMHjafAGmzDynporTOs2+3ANnz400K1zj39Q1eVLLPVrhvRxvFEhfGAqr8vJeDNEcOnDBbk5qRcoZ05Mso7U47YL4CNlciAHoY1iLsdDweLIDeqlsK027j9N43JkfVKV8r3dgKOfaHjns5Bh/33o1EM/8mSkN4U2Fi03XJSW4vLZwH2CLMJe5hHFA9uoC5uFJDPiDtzkm4+I1SdVFKhNpMd/w0WLj634lxt73BlHhlVEfWh0vXqnroK6oLC9pK9ftv04=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Oct 2025, at 11:06, jinji zhong wrote:

>> On 1 Oct 2025, at 0:38, jinji zhong wrote:
>>
>>>> On 30 Sep 2025, at 9:55, Vlastimil Babka wrote:
>>>
>>>>> On 9/25/25 10:50, zhongjinji wrote:
>>>>>> It is unnecessary to set page->private in __del_page_from_free_list(=
).
>>>>>>
>>>>>> If the page is about to be allocated, page->private will be cleared =
by
>>>>>> post_alloc_hook() before the page is handed out. If the page is expa=
nded
>>>>>> or merged, page->private will be reset by set_buddy_order, and no on=
e
>>>>>> will retrieve the page's buddy_order without the PageBuddy flag bein=
g set.
>>>>>> If the page is isolated, it will also reset page->private when it
>>>>>> succeeds.
>>>>>
>>>>> Seems correct.
>>>
>>>> This means high order free pages will have head[2N].private set to a n=
on-zero
>>>> value, where head[N*2].private is 1, head[N*(2^2)].private is 2, ...
>>>> head[N*(2^M)].private is M and head[0].private is the actual free page=
 order.
>>>> If such a high order free page is used as high order folio, it should =
be fine.
>>>> But if user allocates a non-compound high order page and uses split_pa=
ge()
>>>> to get a list of order-0 pages from this high order page, some pages w=
ill
>>>> have non zero private. I wonder if these users are prepared for that.
>>>
>>> Having non-empty page->private in tail pages of non-compound high-order
>>> pages is not an issue, as pages from the pcp lists never guarantee thei=
r
>>> initial state. If ensuring empty page->private for tail pages is requir=
ed,
>>
>> Sure. But is it because all page allocation users return used pages with
>
> Some users [2] do not reset the private back to 0. When the page is a tai=
l
> page, the non-zero private value will persist until the page is split.
>
>> ->private set back to 0? And can all page allocation users handle non-ze=
ro
>> ->private? Otherwise, it can cause subtle bugs.
>
> Yes, you are right. Some users(like swapfile [1]) cannot handle non-zero =
private.
>
>>> we should handle this in prep_new_page(), similar to the approach taken=
 in
>>> prep_compound_page().
>>>
>>>> For example, kernel/events/ring_buffer.c does it. In its comment, it s=
ays
>>>> =E2=80=9Cset its first page's private to this order; !PagePrivate(page=
) means it's
>>>> just a normal page.=E2=80=9D
>>>> (see https://elixir.bootlin.com/linux/v6.17/source/kernel/events/ring_=
buffer.c#L634)
>>>
>>> PagePrivate is a flag in page->flags that indicates page->private is
>>> already in use. While PageBuddy serves a similar purpose, it additional=
ly
>>> signifies that the page is part of the buddy system.
>>
>> OK. You mean ->private will never be used if PagePrivate is not set
>> in ring buffer code?
>
> In the ring buffer code, it only uses the private field of the head page,
> but I recently found that the swapfile [1] is assuming page->private is z=
ero,
> even if the page is a tail page, which seems a bit dangerous. Adding this
> patch will make this situation worse.

Yeah, thank you for the detective work. The comment in [1] sounds really
alarming, as the code relies on a specific behavior:
    /*
	 *Page allocation does not initialize the page's lru field,
	 * but it does always reset its private field.
     */

We can revisit your patch when page->private is gone like Vlastimil suggest=
ed.

>
> link: https://elixir.bootlin.com/linux/v6.17/source/mm/swapfile.c#L3745 [=
1]
> link: https://elixir.bootlin.com/linux/v6.17/source/mm/swapfile.c#L3887 [=
2]
>
>> If you are confident about it is OK to make some pages=E2=80=99 ->privat=
e not being
>> zero at allocation, I am not going to block the patch.
>>
>>>
>>>> I wonder if non zero page->private would cause any issue there.
>>>
>>>> Maybe split_page() should set all page->private to 0.
>>>
>>>> Let me know if I get anything wrong.
>>>
>>>>>
>>>>>> Since __del_page_from_free_list() is a hot path in the kernel, it wo=
uld be
>>>>>> better to remove the unnecessary set_page_private().
>>>>>>
>>>>>> Signed-off-by: zhongjinji <zhongjinji@honor.com>
>>>>>
>>>>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>>>>>
>>>>>> ---
>>>>>>  mm/page_alloc.c | 1 -
>>>>>>  1 file changed, 1 deletion(-)
>>>>>>
>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>>> index d1d037f97c5f..1999eb7e7c14 100644
>>>>>> --- a/mm/page_alloc.c
>>>>>> +++ b/mm/page_alloc.c
>>>>>> @@ -868,7 +868,6 @@ static inline void __del_page_from_free_list(str=
uct page *page, struct zone *zon
>>>>>>
>>>>>>  	list_del(&page->buddy_list);
>>>>>>  	__ClearPageBuddy(page);
>>>>>> -	set_page_private(page, 0);
>>>>>>  	zone->free_area[order].nr_free--;
>>>>>>
>>>>>>  	if (order >=3D pageblock_order && !is_migrate_isolate(migratetype)=
)
>>>
>>>
>>>> Best Regards,
>>>> Yan, Zi
>>
>>
>> Best Regards,
>> Yan, Zi


--
Best Regards,
Yan, Zi

