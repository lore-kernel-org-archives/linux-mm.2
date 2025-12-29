Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73616E784BE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 01:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4618C6B0088; Sun, 28 Dec 2025 20:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E356B0089; Sun, 28 Dec 2025 20:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BAC6B008A; Sun, 28 Dec 2025 20:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1456B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 20:16:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8588C8BF73
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:16:30 +0000 (UTC)
X-FDA: 84270743340.14.3407AF5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2163340009
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:16:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=B6VyTaWb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="QsAwN1/z";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766970987; a=rsa-sha256;
	cv=pass;
	b=7FqVzA/Z5fE0nwEW+QgkPSSNSkYEvuyL3tpgVA7keAHT8s5VrWHkZiAN0Ta9CrRrsMqVkh
	6wzXPkyqJKNEl469s6kuFqKatUpt5/HNC0zWJQTibFunUeJlttYv9i44bvTt3gi5LjweTH
	dFVFEhJ8p0qNWwLtDszaoFiTDPfW0l0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=B6VyTaWb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="QsAwN1/z";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766970987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYxbCysdskGquR5kJE7ot6QIi8ew51QKRvPEIy3YCs0=;
	b=ABQIT2aTU7kp9ol5pm3Muoi0HeTazub0dCO1MtAj04f7z+KFaCBT00puR/9ek+dW/b7PhO
	5eG3rVykK9prRvKS2Si1UILdmq94reJF775435pWGciLghtUX3zN+eX+LLGFVLUnroUKFv
	tmIvKNnK2VtOF38gTuKX+81Yw9M6i7E=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BT0mPbW737802;
	Mon, 29 Dec 2025 01:15:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aYxbCysdskGquR5kJE7ot6QIi8ew51QKRvPEIy3YCs0=; b=
	B6VyTaWbTFaK6C7SuS0rQh0M88c0uu2dFv+pVrAFqO7Wi9yIPCAVIAcHvZXTv4En
	Y5KzWmZXu8uvQ/X+XhQosDI/ObxGe7uMixjSY5UHz2UfB8yVz/sOoDMcB6iXoFWG
	/if/Vl3p84k7K6BWdMCuNz6jY/73QRCiUwB/YQcqwUouh59wS4nI6ajMoRnJvwEE
	4rlphr+LTj/SREig1KElHyCYMwqyQRTUsPrqQjtNJBY9VvPvWjrDfptSZHx6Qa8i
	otTaWcReXvFb7OvxIi3/EsOhg0zWliuCuNkxdD5j4O77vQrV4xqmALLbJw+OaYat
	UlRUYBTnQFOXjynwDFznNg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba5va160g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Dec 2025 01:15:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BSLR4sg022959;
	Mon, 29 Dec 2025 01:15:50 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w6r2k4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Dec 2025 01:15:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VVvoBYB5y+pXqN0OC1hVvx8t5ZmrTy0a+wGEJ3EoJFsEHmUhGWStw45qVPSSyThBhTHUDifX/mNYhNaGjHQO7rGXAaWB4+yDuhq++D2G+6SiTdXEsQz+5l8J5F6SRD4GNzseEvwhDxuDptSDcriFJlUgdukDGiAIRazLygyaBtYR+QigliUN+G1lK4qGFYDTZZ+GeLVXTRtcCeza7m4cnBaXJ56WEDfsQeX2Dso3cd6OgEHBdOmrKWGJveas4LEoXEQo2jVwJc7A70WFRLerblEy2Id+WGhvqU++hgs/Ad2R/UL96JP2NMRcRzEAdXPA9GhxCwvIeDLUpZ7AnLogdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYxbCysdskGquR5kJE7ot6QIi8ew51QKRvPEIy3YCs0=;
 b=mh188yLx2knP6MtR3SIQoB/dx/r/vaGCasqAP+EOapSO8/ISMAFkaUR36P28sOM8uVJlOLyFHqLc8A/5Jm2Lr0t9Kz8wNHPECSURUyJB/hkuy49892WaXYnJB1M/eUnHPHSoq7LxoIbVVYZmy4nCm1l40UzHsj4w4gOfPJXA6WC3UVurF3hUcBqtoFKh6qsl5I87DdeQVAuWomWDFyu8035Jj9YggxotL7BeeeIPAam+AiU5orZliHkhuNwMns8MqgWJzAimp1XwgP4ZrNjVyeH++j+i33Db04d4v/j/KQaLgKHL6cNsjlCyD7e7WVqhJJxFmzIBVHQpPOMqRhhGtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYxbCysdskGquR5kJE7ot6QIi8ew51QKRvPEIy3YCs0=;
 b=QsAwN1/zklXBmssV3O1qKsR8LVTxFKZPx7NeEYXqPlIJHgVIp6KlOeiGjo13Ld70dAGgBajEofDEHsNooTqJlOB/BGAWXUwPdJByL0cfKTT8qJ8OMT6PRut+Zt6OT9MhN9o09NYsIMUCRDfC30CdgaqGJWRfcZ0NTj/jcaq4aeQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM6PR10MB4185.namprd10.prod.outlook.com (2603:10b6:5:217::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Mon, 29 Dec
 2025 01:15:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 01:15:47 +0000
Date: Mon, 29 Dec 2025 10:15:36 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
        ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com,
        david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com,
        tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
        akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
        rientjes@google.com, duenwen@google.com, jthoughton@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
Message-ID: <aVHWOMa9n40_8Yu3@hyeyoo>
References: <20251219183346.3627510-1-jiaqiyan@google.com>
 <20251219183346.3627510-3-jiaqiyan@google.com>
 <aUolGHkJQwKi0A8A@hyeyoo>
 <CACw3F52hZp+xC51bK=UfrfdAWdFEEqhsiJY2+0fzCLzB_3=XYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F52hZp+xC51bK=UfrfdAWdFEEqhsiJY2+0fzCLzB_3=XYg@mail.gmail.com>
X-ClientProxiedBy: SE2P216CA0099.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM6PR10MB4185:EE_
X-MS-Office365-Filtering-Correlation-Id: 581b156f-b636-4c62-7631-08de4677cbe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?REl4ZTZsUUUzN1ZON1lOZlNIa1YxN0x3RTBqZFpiWC9wVGVOaWxQazBGWEpn?=
 =?utf-8?B?cjJYb1FXZnNSS1V6Z1N1Z2VOMUJMcDhWTk9WdkpRYnB2VFdTbll4ZWZkWklL?=
 =?utf-8?B?Uk4vL0lQaS9BM1llSkxORm5uQUxFTmtqUElHcDJuNUZRdTh4WEpHd0dSMWdK?=
 =?utf-8?B?N09uL1ppOWEwbkNFYTlSZlNMSkRObklLb3ZQa2ZTbTA1eGJvdFhsRnJRRFFZ?=
 =?utf-8?B?MDYyNE5BcnNaY0puS0lVZFhFRGluU0F6OURmVndWekc1Z21XM1pncmZxeTc2?=
 =?utf-8?B?WkFtTG54RXJCWWJyWEVZclpIbE8ycUtEUzNLWW1pR0h4Z1dMTXdOeS9qMnZW?=
 =?utf-8?B?N2VVV2oyRjllK2l6bGFOOTljOVlxNlZBYjF3UFNUUHlCU3p6Vm5JUUd0allR?=
 =?utf-8?B?SkJVY1RYRlJtWS9hUkZxY203elFtMGlwemkxdlpvTlRlVkJTUCs5MlY3Znd1?=
 =?utf-8?B?R1BoVWR1MWJmUDE4eFJGREhwMzArdzkwMnpJcEFsWW5mK1ZCcnQwaHk3eHRt?=
 =?utf-8?B?dWRLcnV1OHpuQ0JsOThyZHIyRnV1T1p4cjJ3dXJTY2hYZWRid20wcENPM1JW?=
 =?utf-8?B?NlpXdVFlK0ZYZjIwdnRTWDVXdUZKNDdHSFgza0sxaTZvU2xkSDZmaFB2Tmo4?=
 =?utf-8?B?a3laWTVldGFlQkxUc29yOGZSM2w2VS9MSmppNmJqVXE2U21IT3k5UzB1Q3Vw?=
 =?utf-8?B?NkNDOHpBZE1kQytmbUlkU09xVm04YmdURnlScEtSU1h3QXpvOFgvTWY5WE5I?=
 =?utf-8?B?cTFKUnhtRDl4Rk94ejFVM3pWeTNDekxLMGlPUDhzek9PNEJ4MlhJN1NEZFcy?=
 =?utf-8?B?NDZaV0tTeEhMbDNZQmpHeGtiSnpzMTRSOTBBd202QlZJNVRiRUNuZHJCVFdi?=
 =?utf-8?B?WXlCY2NFRjVFY0I0bDdaMk8rVFZZc0J6WjBNTEpBSHp4M3FDZ0lzWGsxN0xz?=
 =?utf-8?B?dmRkeTc1RGxhNDRHOVdmUVJJUml2S1NwZnVRakhPTWtqWFB2dWRCTVlBUjNw?=
 =?utf-8?B?cU53Ulh4MXY0cTUzMGVCbWZZVjcwWFdyZk52VnBYTzV0V2pyaVlyY2xCSWln?=
 =?utf-8?B?MVBEaVdQWE5CVFFKUFg5V0krM3F6Z3BhbmRVVC9kTzd0QThlemw4Y0VSU2w1?=
 =?utf-8?B?ZVVwREZPNGpJdXhrQ0tJQWlYNldyQ2FDRWo1TERRTVgwQ1VYZ29MMjdqOUNM?=
 =?utf-8?B?ODR4L29nZ0F0SHRheHNUYVZ3UVZqMHp2b2Npd3JxK3V3cDQzWk1ZUVBEZWVN?=
 =?utf-8?B?ZTRqSGJNSTZZNjZYNHBnSE8wRXIzWTl1Q2Fxa2t0TFp0L3oxSHlLak5TOXBm?=
 =?utf-8?B?a0ZzL1IxY2cyWkdYSU9JcGFocWNEODQrbEpMUVVhVjJ5cStQbm5IUlVKMlEv?=
 =?utf-8?B?OVJuREZQRVpXZkM4VzVoUnNtOGVNeUlUTUdxZDZaamUwTERKNVpPZEtGREs0?=
 =?utf-8?B?WEJYeEg2YVJUUDB2Qk80U0VqekhqMXoyMUZoYTJVUWF0MGlFMTVHUWsvUVIv?=
 =?utf-8?B?R3lnaG9FOGVvL2RkakhWaFJFdllqUVI4d0h5TjlwRG5kbkRUM2N1WksvbXZa?=
 =?utf-8?B?YXVrWjBJVzNOVjBqVnZ2eG1pckhvZTdBaHJpNktESGNVMERXMC8vOHdhWU1G?=
 =?utf-8?B?NStoUit1QlJlTjFOSUpkcGl1KzFtN0ZxUkt2S3FnMThkQUdYaXBMeVpYUGZY?=
 =?utf-8?B?WEdNd1dzVXB2WW5HSncranZpQmdTZlhsanBpMWNreEVyU1A0VUwyNXJ3Z0M4?=
 =?utf-8?B?eks1amZaYnpPMGVQYjJqeGxmRFg5RTNIQTBrNzNuRHpjVzA3STJKdzNZcTBN?=
 =?utf-8?B?R3lJWnJCUnUvanl2bnVkRU9ZdUcwUStRc3ZNanpNRmR3YnlPNDVGdGc5emlV?=
 =?utf-8?B?c1lDbWNNT21ybCs5dDdaNTFEWDdyNUR2Y0tMcTR0VnlHa09SVmJpaTZ5TkFu?=
 =?utf-8?B?TE94S3dNMks0VnVSNXFYRU92M3l0K1FGY2dvWGV2ZjJrVTExWkVYR2JaUndN?=
 =?utf-8?B?U2o5dkt5YVZ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3h4WlpOMkpaS3hJUW56WXpFL0ZmUnVDN0dVK1poMUtkc0FqT3luREhabmpR?=
 =?utf-8?B?QnJSTUJucnJmUlhweEdwYmx5ZzExQ3VIR28ycE9QV3hoWmIwRzA1V1VwMUt0?=
 =?utf-8?B?VmtsdGxhOUFqK2RpdkNScCtVcXprc0hMc1oxVFlXb1VJL1k5dU9OZnRRaWNP?=
 =?utf-8?B?VGVNRVN0K20yQ01MdlZ5cFEzRWVDY3hPMWpGQURidk12NHovNnR1ckV4OWxF?=
 =?utf-8?B?VlRDMlhYTTRpdTUxdUZBZ0Y2RGx2dXVDUzd1QXNER2loYkZ6SFFvVGpYV2RW?=
 =?utf-8?B?cnRyZGpZUEFoYTJIOXpEdnZBUm9nWFlVS09ETEkzakFKM1lCU1VLdms0Vlk1?=
 =?utf-8?B?a3hsYWVBejFxZkw5YXZBVFJMN1dqZldGYmdsSTAvbjFZRVF6SFNHQ0RmSzBZ?=
 =?utf-8?B?VjFmKzZYdzlhN1RGRXFTaG1aTElON3lXRHVQZzNZZXlhWVo3VlhRVDZoYUlj?=
 =?utf-8?B?RDBDTmxWWGNOZk9MejN1c21haUVZYXloNnRTUWZ4OFIwT1l6cGVXYWtFRzBk?=
 =?utf-8?B?SGNpNUJLZXpGN0d4aFlKRmNSU2tjNVhRQ0VQUEp5M1phNGF4SlhBbWVRdXRZ?=
 =?utf-8?B?NVVTd3pGbXhmMzg2WFp1b2tobTYxVnpOSWZnait2RjBiTG5tdUNSaWh1VHpE?=
 =?utf-8?B?TU9COHp1NFYvMjBZQ2Y2cnA5ampCNnE4NjAybmZOYWxGRmI0V2xYYWliV0lH?=
 =?utf-8?B?VW5RT25lM1ZkS3VsdU9XU1NVRTQxWThCMkVZSEJTVWVoZUM3anFybXphUlVw?=
 =?utf-8?B?eExGTlB5d0h2R3VBaW42NGVEVHFLejZmZGNtSlU1WExqWE1jMzZ3UGNIOG9H?=
 =?utf-8?B?QU93MjJCVzhYMTJ5UHRtcnRiY0d6TDczdE1kRWk4RFZGMzJNSWJXQ2hvUnJ4?=
 =?utf-8?B?UThQekpWUmF5WFJGQzdBeXVIOUMyQWlPbWR6UTVrY0tJVE4zaEpXRlgyWU9p?=
 =?utf-8?B?d0ZGcGxRekdMNmp5NnE5QjFSWWFWS3dwQ0VFWXV3UkxpY1JxVE94NGtqcW5P?=
 =?utf-8?B?dFRxV3dOaXFmcGkxMHpoc0xsOGdFaThJdG43SVVFLzAvZmdjM0poZ3BpT2pG?=
 =?utf-8?B?b05VN0E1bFA0VXBVdTR3alI5ZXRJd3pVejcxWnk4Z3Q2OVBUZFJNdjV0aW1O?=
 =?utf-8?B?MVFTTUc0eXhXaC9vQ3k0SDAvYXBTTWZxOCtUT1VUYkFJNnduRkxBTzVJR1hl?=
 =?utf-8?B?V1Jzdi9wSk9uWUlMSHU3ekZLWm55R1VMeXJ0ZWlrZGltK0FVaXZQZm94QSsv?=
 =?utf-8?B?ai85d2pnM2NCRmx1cHM0UWtoZGxTNFV2TTMwVkJiOXNPMXp3VHphcEdlQ0lq?=
 =?utf-8?B?TnA3VE01NUkzOGNEajZJNGU0d0VpMW9Vd3BTVVUzWmszc1BwYmE4ZmlFM3Y1?=
 =?utf-8?B?elBQenh1Nnhjd3h3aXZGVnVwMW1DK2ZheWJPU2paUTY2RHoycGpDSDVmZHZ6?=
 =?utf-8?B?NHc1MUsyTU1lbGsrZ05ydXo2dWZRd1RBNmZXTis3S3Z5cm5ldWFzRnZJN1pv?=
 =?utf-8?B?dWFSZDlzQnUyTHlUTlRDSE1tRU1hYkovNmc2Z0lKa2ZoWlpZZlp4MFlLbmNp?=
 =?utf-8?B?YUR5cVdVY0QrQkV6QTd5WVhmVUQwMDZoc0JURzUwMFk1dDJ5QWJCRVozV0Vt?=
 =?utf-8?B?VGZFZHBCOTJTenRldEpHb29uV0Fxc2ZWLzhTQVRxZnU2M3R4cUVjemNoZy9n?=
 =?utf-8?B?R1VDcWdHYlpEVVFZcUVLclFlam9pQnNQUjh5YklMakV1OExQVHd1VHIxeGhn?=
 =?utf-8?B?WFJpTnNuRTBIenozeVRNeUdpWUZNTEdDazhQc3QvVDcwdk5wVG1hRWNrcHVi?=
 =?utf-8?B?MFFoYlNSMVNYbUdqMDV1YmlnRlkrbTUvKzJPUkJiZEwwbFVOeVhzWXJIdHYx?=
 =?utf-8?B?eUZtSktPR04xbHJtRUEzYUltN3A3aHMrSVBYalpoTnliZXlER0lmQmlLeVBT?=
 =?utf-8?B?WEtiQzNpeUN5Z2VVV0drT282V0lQNFIrMVNFdTlvNVAvMGp4THovVU05STdF?=
 =?utf-8?B?bS9ESDFpMTlRK1lKYzNMOUd2VjM2Q3h2Qm84QUZHNUpGQnpNVy9IYi9Yd2Jy?=
 =?utf-8?B?NVJRaHBoZlBYQ3pVZ0twOUV4SFdPNVJKZU8zeVp5MVZJakcwRXd6THNSTHk5?=
 =?utf-8?B?L2JIbkxGbi96Sk5lMWFsVXRxWkZBcmdSWlBDVytkbU9GZHhhMDBva2hIaDZC?=
 =?utf-8?B?Mk54U0xvV1M0NVRlQW1teTBUZm9yK2c5NkZjYUNNRmxVUmEwZ29vek5KZEZN?=
 =?utf-8?B?UW5aSUFYc3ZuSlRYY2dLbEU2WUh4bUdRVVRrWGR5cUoxeEhML3V4RFk3NUFx?=
 =?utf-8?B?S0VRMmMxd3UyQzFFR1ZoNEc0VHFWYWVMSlpaY2NvUEpXK2lBemgyQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	az6H+hAt8yj4nz8N2o4StPclQTbo5YYbF6eP6X6suL3l/use9iMPUX08h6knydux13+phtRxN2zpQ6oGz/8gGkET7OByhK8XVyzETIYBL5YHrxUHiDdsrKPZc/qmyWesM9nIOA1qYCwoxO058c4PnSOEQJrYXP32hh7PoSbISMskzj9lQZXRwsUxQODgetyJdrfnCMN9exX2XCJ+Bt/7S/usdmAqbwN5hkNz81g5iDgezqhqN6SA1Wnr2icyyGzZl5VwU398k6vMZPwaH8vTCFo1UH56/KK9KBuufBjWBXeJ7VsZEAb4Rd+0M/5jbwZ1m3hP0LSQM9wD5bPdvDMEGScwwE843UQxbXdpu4uctFBFUcGkRWF/rlkjzMD10xQeVFUA1GNb1Bybf4Mh8JcyunP6R5HWpsjf2Tn7xRRgTb/SIkLg0tuzRHFJ8aUbGeY+ZrhQiZ/P26i/Wh0OsX2eBRzvzEm0uWwXqKwDSLVNQIhjy79yn45kgrIL1qOG5BSoPJr0bXnvmg1Rc5rBKQsROXw3P/LWhLnLksXIctU+yuepkS7DXaR/cEdJnPuOOihc50fFnT6vcv3zsyplN1H0Dj0ddEYwnmgvMGvkMH1Qngs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 581b156f-b636-4c62-7631-08de4677cbe3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 01:15:47.1742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ENsN223+UE/8rdFi+pD/SVJ8PICRzJ74d+f0DGfVo7lTI6a5XIaI79htjU+AH0Bapbd5I1apzYjmu2EkvR3bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-28_08,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512290009
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDAwOSBTYWx0ZWRfX6V2Xaadkx1S5
 bjhUSRXi0SLaRCxO03xHlTTU8EQVv8biXv5J4CUIwV44lgs/VK3LUed0+j5VvpwDMuau61b+3pf
 oN9v+zQgvn243E6/h7t5EzF52Z27G6xraKQCYqeMsUmyv0m1V3uIbLJzcxnfMq65a6Nd2W0GZZp
 8Tc4URu8EC/+5gJV1inW8c/KUsmk3XI/TIIVlD8/KoS2KKthNwwh1PFYmZIVLyUSQiSNvn51gEC
 xA+wxbKV70WK13/NSktg66uzcJJMF5lO6VfQ4IrYsFXUTDv27DCuWKeUyCSqatv/FZX7Yphs9Vk
 B/pIiiXI01ASh6u+O+eMP/ULtcoUKLHcvbvMEqzSmnd23p6abIxfPqEQk38toxWrrgCG5P7CYRA
 QsxPTsBp/uFf0KHZ+BWRt/gRX42oRA9WMqxYzJiBQPjV7R384SG1SG1iJq2D2/WFdnM8e2tHcIJ
 P0emZ8JaC05/YpdqQEg==
X-Authority-Analysis: v=2.4 cv=NMvYOk6g c=1 sm=1 tr=0 ts=6951d647 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=R_Myd5XaAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=_NwqGlprfMQgQDcaiX4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L2g4Dz8VuBQ37YGmWQah:22
X-Proofpoint-GUID: avlG40EfHfHIQjY5sUbfavuFTdTUEwYs
X-Proofpoint-ORIG-GUID: avlG40EfHfHIQjY5sUbfavuFTdTUEwYs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2163340009
X-Stat-Signature: m8qfmz59hibwma8ao4ihditgc7d4oeez
X-HE-Tag: 1766970986-42003
X-HE-Meta: U2FsdGVkX19URF8hWjJOZy+ZHP6d0wtwjp3HaYHNpY+1BMm2aQ9VBF6vD6RApl32/EVjL0TruBHnLJYUnE5LfWdLPwu6uFVOjDC4oLDZdRzlhOjtYUJQRbdfAuPjBN24ol6yY6mIV9btsGmnAhVpAymNmFBlHoaprKRFX0maw9JbParqejaJDpW09FTARhJILLMvj5sCnpmIRZTNojPXzPSLcZkYo0VbKrfBmlOaVBvAs54YoSD4RfKb4hoyzGz48FbdmgDxT9E8mOYoMxpEX5gU7B1X0/4MFdarbwdzfoP2Bb7A1azvDLLZI3Umxjk2Mss7uGLvYQczsROx+lZ0ZPLG6TRIJIt0KE+Dnzf1U71HrRZCwvSKnDmCBqQedX7mf3xpmmg8ozHh6iJOwttI0mntMDNnaHc/C/6twXvJmSCeS1hNoP/lp+duwufSaoezJKmg0WWi2hkhvAxX0vi5u3QxGza8E1oBiwmbjuhpnmpIzSLTU2205T3EdQsU//gnaKc7CcSozaI18y3x4cEi4dAk8jMRXPYDcU9oKZqs1NBsGnVr4RfVPqNSDE+4JVcDCoWwAcKDyuP/TRK8GH622y7ToYUaVyai/9jgfOfznFPiwhwAFBw6AR0FV9FEYehwt4qjFLVOk+2hb1o31G/qFdmKD/RlJVJVwWafjlyyxDKa1MD2+x+d8DfoYCuDPxGq6B4SGMksAWxOugjFhrGc2qBnhIQXufS8ve3r+VZXEvNzMiOVOhaykLoSnt9wPxoqMdELGQeBPQGp2R/Uz7/tvANTjdv818sHnsmKtwWR51QWeqaeltpef4KONRlMKLkwItlBBYMu6r0KFBtGj6+lEaHw0HyMbxxVfJuojJPR2fJg5IQUJCzqzTP7bJSc/Ld4PoDQXff5sl3xrsR5SsDmC9cmGh90cfXUxkMXOLC5WASLAX+VZSiJ5cwCyKY0H/dARKxz1mik6Kj9ueopVIn
 EazGD7n8
 iwx+msCQdkhkWOxs6mfnxPe5FXdhQ48r4/XrnC/cUo5l9xF1XIhIKM1fNRK5XPtx1C2F3XylyowE8AtuKJOpxMxyGIF+2SjgCTm41yxKyxyOH90AdBjzOouo7Ka6rcdAWJeAlyqmimOSNatFAcFgcuD3lzJLn8s94gbEYyrt41un5C2Om6w7sgikH2xQZUKE9ecoshJydjUS9yhB1SDnd9ZJyeYLVy0UDsNXP/ssCi8rvjaW0P5h1uvkTwyUDfPfN8WhB95oSJKid01fqWb17TZhRLJ5kk0tSpOjrOFijo/gqK23hV3fe9Uf/76RnGtxK0HIMiWd5auVUaLO9gtUTTk/bZDKZokfC3+H22r1l2oEuRZVwC8K2GZNtC53ijNaQTImqFTccvgodCRkLm55+X/nwNEQjDaO3G8FL85Ln+sdeYq9UyZX2+UgsTajNYRukPMExhiBGuckO+EUeJzS1ysYsv3FL2Xo+v+h38+a5sJG2cXOW8MvYy50yGWFibiGqxQR4dB7oGN5JwdEE7CnqZv9k98iBdRny8CT86vWoRivZMxaisnFJb/FOAB+qF7tyftWdB6xRIKdMgZPXwOD0fKlD5g4jWIwHF0DIjeCEsOgNIIl0bE4b5Kz61zHRMbclaeeCKCcl7jClfS0ig0oX0+HwLtIksQJe2Ecp52gc8BCAb0jCqgq2mJ1qZfX6d30bNSHgykWZmBRw0CWsftM7QIlZcMkjc58/kNZNAyPIVOH/+QRQ2VtoUNmF4MONplmIUlDHCS9nBp9KNWtA5yNahi03cXxeyyIGxA3xfZq+uzmSW+WWbgQz/ZBeb2JRroCLzlbVtNO4ME07e4eYaQ9C0JqUNZng8cGKtQt+Bw8VtyhbeJTUkTq34eSkDi9L5QVZIk0OblPUupZS7UE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 05:50:59PM -0800, Jiaqi Yan wrote:
> On Mon, Dec 22, 2025 at 9:14 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> >
> > On Fri, Dec 19, 2025 at 06:33:45PM +0000, Jiaqi Yan wrote:
> > > At the end of dissolve_free_hugetlb_folio that a free HugeTLB
> > > folio becomes non-HugeTLB, it is released to buddy allocator
> > > as a high-order folio, e.g. a folio that contains 262144 pages
> > > if the folio was a 1G HugeTLB hugepage.
> > >
> > > This is problematic if the HugeTLB hugepage contained HWPoison
> > > subpages. In that case, since buddy allocator does not check
> > > HWPoison for non-zero-order folio, the raw HWPoison page can
> > > be given out with its buddy page and be re-used by either
> > > kernel or userspace.
> > >
> > > Memory failure recovery (MFR) in kernel does attempt to take
> > > raw HWPoison page off buddy allocator after
> > > dissolve_free_hugetlb_folio. However, there is always a time
> > > window between dissolve_free_hugetlb_folio frees a HWPoison
> > > high-order folio to buddy allocator and MFR takes HWPoison
> > > raw page off buddy allocator.
> > >
> > > One obvious way to avoid this problem is to add page sanity
> > > checks in page allocate or free path. However, it is against
> > > the past efforts to reduce sanity check overhead [1,2,3].
> > >
> > > Introduce free_has_hwpoison_pages to only free the healthy
> > > pages and excludes the HWPoison ones in the high-order folio.
> > > The idea is to iterate through the sub-pages of the folio to
> > > identify contiguous ranges of healthy pages. Instead of freeing
> > > pages one by one, decompose healthy ranges into the largest
> > > possible blocks. Each block meets the requirements to be freed
> > > to buddy allocator (__free_frozen_pages).
> > >
> > > free_has_hwpoison_pages has linear time complexity O(N) wrt the
> > > number of pages in the folio. While the power-of-two decomposition
> > > ensures that the number of calls to the buddy allocator is
> > > logarithmic for each contiguous healthy range, the mandatory
> > > linear scan of pages to identify PageHWPoison defines the
> > > overall time complexity.
> >
> > Hi Jiaqi, thanks for the patch!
> 
> Thanks for your review/comments!
> 
> >
> > Have you tried measuring the latency of free_has_hwpoison_pages() when
> > a few pages in a 1GB folio are hwpoisoned?
> >
> > Just wanted to make sure we don't introduce a possible soft lockup...
> > Or am I worrying too much?
> 
> In my local tests, freeing a 1GB folio with 1 / 3 / 8 HWPoison pages,
> I never run into a soft lockup. The 8-HWPoison-page case takes more
> time than other cases, meaning that handling the additional HWPoison
> page adds to the time cost.
> 
> After adding some instrument code, 10 sample runs of
> free_has_hwpoison_pages with 8 HWPoison pages:
> - observed mean is 7.03 ms (5.97 ms when 3 HWPoison pages)
> - observed standard deviation is 0.76 ms (0.18 ms when 3 HWPoison pages)
> 
> In comparison, freeing a 1G folio without any HWPoison pages 10 times
> (with same kernel config):
> - observed mean is 3.39 ms
> - observed standard deviation is 0.16ms

Thanks for the measurement!
 
> So it's around twice the baseline. It should be far from triggering a
> soft lockup, and the cost seems fair for handling exceptional hardware
> memory errors.

Yeah it looks fine to me.

> I can add these measurements in future revisions.

That would be nice, thanks.

> > > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
> > > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
> > > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> > >
> > > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > > ---
> > >  mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 101 insertions(+)
> > >
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 822e05f1a9646..20c8862ce594e 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -2976,8 +2976,109 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
> > >       }
> > >  }
> > >
> > > +static void prepare_compound_page_to_free(struct page *new_head,
> > > +                                       unsigned int order,
> > > +                                       unsigned long flags)
> > > +{
> > > +     new_head->flags.f = flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> > > +     new_head->mapping = NULL;
> > > +     new_head->private = 0;
> > > +
> > > +     clear_compound_head(new_head);
> > > +     if (order)
> > > +             prep_compound_page(new_head, order);
> > > +}
> >
> > Not sure why it's building compound pages, just to decompose them
> > when freeing via __free_frozen_pages()?
> 
> prepare_compound_page_to_free() borrowed the idea from
> __split_folio_to_order(). Conceptually the original folio is split
> into new compound pages with different orders;

I see, and per the previous discussion we don't want to split it
to 262,144 4K pages in the future, anyway...

> here this is done on
> the fly in free_contiguous_pages() when order is decided.
>
> > > +/*
> > > + * Given a range of pages physically contiguous physical, efficiently
> > > + * free them in blocks that meet __free_frozen_pages's requirements.
> > > + */
> > > +static void free_contiguous_pages(struct page *curr, struct page *next,
> > > +                               unsigned long flags)
> > > +{
> > > +     unsigned int order;
> > > +     unsigned int align_order;
> > > +     unsigned int size_order;
> > > +     unsigned long pfn;
> > > +     unsigned long end_pfn = page_to_pfn(next);
> > > +     unsigned long remaining;
> > > +
> > > +     /*
> > > +      * This decomposition algorithm at every iteration chooses the
> > > +      * order to be the minimum of two constraints:
> > > +      * - Alignment: the largest power-of-two that divides current pfn.
> > > +      * - Size: the largest power-of-two that fits in the
> > > +      *   current remaining number of pages.
> > > +      */
> > > +     while (curr < next) {
> > > +             pfn = page_to_pfn(curr);
> > > +             remaining = end_pfn - pfn;
> > > +
> > > +             align_order = ffs(pfn) - 1;
> > > +             size_order = fls_long(remaining) - 1;
> > > +             order = min(align_order, size_order);
> > > +
> > > +             prepare_compound_page_to_free(curr, order, flags);
> > > +             __free_frozen_pages(curr, order, FPI_NONE);
> > > +             curr += (1UL << order);
> > > +     }
> > > +
> > > +     VM_WARN_ON(curr != next);
> > > +}
> > > +
> > > +/*
> > > + * Given a high-order compound page containing certain number of HWPoison
> > > + * pages, free only the healthy ones to buddy allocator.
> > > + *
> > > + * It calls __free_frozen_pages O(2^order) times and cause nontrivial
> > > + * overhead. So only use this when compound page really contains HWPoison.
> > > + *
> > > + * This implementation doesn't work in memdesc world.
> > > + */
> > > +static void free_has_hwpoison_pages(struct page *page, unsigned int order)
> > > +{
> > > +     struct page *curr = page;
> > > +     struct page *end = page + (1 << order);
> > > +     struct page *next;
> > > +     unsigned long flags = page->flags.f;
> > > +     unsigned long nr_pages;
> > > +     unsigned long total_freed = 0;
> > > +     unsigned long total_hwp = 0;
> > > +
> > > +     VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
> > > +
> > > +     while (curr < end) {
> > > +             next = curr;
> > > +             nr_pages = 0;
> > > +
> > > +             while (next < end && !PageHWPoison(next)) {
> > > +                     ++next;
> > > +                     ++nr_pages;
> > > +             }
> > > +
> > > +             if (PageHWPoison(next))
> > > +                     ++total_hwp;
> > > +
> > > +             free_contiguous_pages(curr, next, flags);
> >
> > page_owner, memory profiling (anything else?) will be confused
> > because it was allocated as a larger size, but we're freeing only
> > some portion of it.
> 
> I am not sure, but looking at __split_unmapped_folio, it calls
> pgalloc_tag_split(folio, old_order, split_order) when splitting an
> old_order-order folio into a new split_order.
> 
> Maybe prepare_compound_page_to_free really should
> update_page_tag_ref(), I need to take a closer look at this with
> CONFIG_MEM_ALLOC_PROFILING (not something I usually enable).
> 
> > Perhaps we need to run some portion of this code snippet
> > (from free_pages_prepare()), before freeing portions of it:
> >
> >         page_cpupid_reset_last(page);
> >         page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >         reset_page_owner(page, order);
> >         page_table_check_free(page, order);
> >         pgalloc_tag_sub(page, 1 << order);
> 
> Since they come from free_pages_prepare, I believe these lines are
> already executed via free_contiguous_pages()=> __free_frozen_pages()=>
> free_pages_prepare(), right? Or am I missing something?

But they're called with order that is smaller than the original order.
That's could be problematic; for example, memory profiling stores metadata
only on the first page. If you pass anything other than the first page
to free_pages_prepare(), it will not recognize that metadata was stored
during allocation.

In general, I think they're not designed to handle cases where
the allocation order and the free order differ (unless we split
metadata like __split_unmapped_folio() does).

> > > +             total_freed += nr_pages;
> > > +             curr = PageHWPoison(next) ? next + 1 : next;
> > > +     }
> > > +
> > > +     pr_info("Excluded %lu hwpoison pages from folio\n", total_hwp);
> > > +     pr_info("Freed %#lx pages from folio\n", total_freed);
> > > +}
> > > +
> > >  void free_frozen_pages(struct page *page, unsigned int order)
> > >  {
> > > +     struct folio *folio = page_folio(page);
> > > +
> > > +     if (order > 0 && unlikely(folio_test_has_hwpoisoned(folio))) {
> > > +             folio_clear_has_hwpoisoned(folio);
> > > +             free_has_hwpoison_pages(page, order);
> > > +             return;
> > > +     }
> > > +
> >
> > It feels like it's a bit random place to do has_hwpoisoned check.
> > Can we move this to free_pages_prepare() where we have some
> > sanity checks (and also order-0 hwpoison page handling)?
> 
> While free_pages_prepare() seems to be a better place to do the
> has_hwpoisoned check, it is not a good place to do
> free_has_hwpoison_pages().

Why is it not a good place for free_has_hwpoison_pages()?

Callers of free_pages_prepare() are supposed to avoid freeing it back to
the buddy or using the page when it returns false.

...except compaction_free(), which I don't have much idea what it's
doing.

> > >       __free_frozen_pages(page, order, FPI_NONE);
> > >  }

-- 
Cheers,
Harry / Hyeonggon

