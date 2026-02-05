Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1B5EA794C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 00:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063766B008A; Wed,  4 Feb 2026 19:56:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B4F6B0092; Wed,  4 Feb 2026 19:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27D76B0093; Wed,  4 Feb 2026 19:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFA1E6B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:56:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F688C188E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:56:53 +0000 (UTC)
X-FDA: 84408588306.05.F7D7993
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010034.outbound.protection.outlook.com [40.93.198.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 921B7180007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:56:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=anrlF+jH;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770253010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2qtNfM4W4Q2C4m6w99tBvhSJmgGjiUrqgB+Htb0E0Q0=;
	b=f2zZXkUF6J/555mVvHg15fUj7L73se4leRPhwbwVDxNGgrvs1EZM4sY/MztKZOezpjPXw1
	CJCj78yAGE3n65B7F9Gtier4BSl1QnWz/W11VNsEtYptEp2g3Ifgv3Kku96GPY42QtNo3A
	R3a70w5WbX2wJOCzTbseQqTCU+Rxhbc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=anrlF+jH;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770253010; a=rsa-sha256;
	cv=pass;
	b=6Q7Buf3czhgq5PExmZ/5X2zN5u42zNdzadBAEjau7qJ0lES+wYV2Fyuv1FSWvFE1ykklr/
	FJvXMNYrJkTlbbU809CdlCs6De4/UKm3h0ZwbqvDgnCtY2xhCAYsXDLdCNGQ2ZueDPkwe7
	ABVWILDJ8MYOqxa/SFL/GlTPV+bfIEo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ukeIZhQxu8XzwnTLbkMCmn/AvE4M/UpRDVzoknXshuL+rwwmvCgj+waMld0R+BOxB9TTi4zpzQMz2E99kcmI+e8FrpAN9DDpmzkhXtezxDmc4+DUL8wEu97nrD39SXsOdqiB90Ea68dP4w2WOy7mKjBM/1XhJFro6m/9tpE6gugxOWZlTkbyfHq0YSzhsLTTWeOMgEsit3S2rLw0wfDka5oxWbbeWRvyszLigwfEB9LDZNmB79ROXCPORtu5mm6bgC7KxGV1gN3Gvv3TpXxqsrFZzQghnvAyWMaidC50fYiE2/8QAWOb6zOw8sS3YHMyRWy6MFgrZ+IbSBaqZEBkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qtNfM4W4Q2C4m6w99tBvhSJmgGjiUrqgB+Htb0E0Q0=;
 b=yx282/RilORBmLCID34ts2I7xDLvB2PY8sj2lymTkW2QmwhUJckrFtjCo/sZ2j+DZ82rRgaKy4onqazDNU0MdIyHBBNeqXfaqP9FnQqRqAauPeGvZOo5q2NdwLhgpXvgRwlY0zab6rzfuycHWs8hnKQ5xvRLG0t3aKTPNEtf3fGgJ3BOKsSU0F4eGSFvJ27+i6NQ7z9SXZ5NParNMbyQLYhF0ad0m4IKxALIhjkEoWrj6dSuWAyZoxMJ6qz46WqmnQ9BrRF0anJCYre7Ql7jMWaRoZNNptrHzYajFJOpywrl0Kn2z+VJOWjYDKLBXY7svCnJoXe3jss/7v1bF90QGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qtNfM4W4Q2C4m6w99tBvhSJmgGjiUrqgB+Htb0E0Q0=;
 b=anrlF+jHvEOdfzcnaIYDsuiXJFMVCn1ja5Z48mlDsmc0q/GB9V89Yj4Vny3mK6ifZTUABekob5YyF92rvKpRTwDpNnd5qJI2+BVr3azrHIy87j/9FtSk3U1XUprIoj+a32RqcyIPD2Hlaso+LAd9jgv1T0QBBAeixxM8wJEzKXSm7Vo1JF2ofzFQChKL2ZG0EJuubTsjobISxwigl70punAASyBVWHRrGXYdvd57jSzfYfjkTVWLmye+J4vi4hYkX0A4p/JJBq/9E8U+uQSejNLizLTkIlSxzd9fp6YMAnbt7J8KFwZNvbLUT/3v3K5SHgxNby85yXGlZR+ZJkJaZA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA5PPF6CDAEAF48.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8cf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 00:56:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 00:56:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Yu Zhao <yuzhao@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?=E6=98=AF=E5=8F=82=E5=B7=AE?= <shicenci@gmail.com>
Subject: [PATCH] mm/memory_failure: reject unsupported non-folio compound page
Date: Wed,  4 Feb 2026 19:56:03 -0500
Message-ID: <20260205005603.274383-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR01CA0056.prod.exchangelabs.com (2603:10b6:208:23f::25)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA5PPF6CDAEAF48:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0f12fd-6eac-4ee9-89d3-08de64516ec0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VlFIWm5FVlNjUlJDV1pCTDU1SDhiOU5IRUdVcnlGUEFzTERwamhMQi9ZdXpX?=
 =?utf-8?B?U0NNTjYwanhkWVhaS1lYc0Q4VmRkNnU0TXBQWGQ1cStpOUNaa0hlL0Q0Yitw?=
 =?utf-8?B?QkZrUjB0S2VUYVVRcnoyZlZhVDA0N2xQd1E4eTVuempaTlJxcHVnYTVGU21n?=
 =?utf-8?B?U3F5ZzVnNS9iMCtxd1owQzNyMEF1ZW1IWUcwdldlaUcvZ0ViMXdTZDhjT3Ja?=
 =?utf-8?B?eTVBY0FmVDFORkx5bC9UZzZTRGowcmg2cnhUMFNOU1J0anR4anNObUQyU1RK?=
 =?utf-8?B?UjRQdWowWkhDZGY1N1JtWjkyTlU3Qm81QXBGYnJZeC9uODRQTW5jQzJ3RUFr?=
 =?utf-8?B?NjVGZHJ2RjVNNmFSSDFUcjZ2OEhsd2ZMQmhsL1QxditPaVJqekx1UGlkL2Zs?=
 =?utf-8?B?R1Y4TzF0UnArVFV0WmREc2IvOWk5TEdKTzIydktvdzdNNVJybEE1anNqaTli?=
 =?utf-8?B?bWE5UHdVM25FS0ROSi9Vb1U3MXNDb1F1NUE4V0dJL25qNE05dEY2NHNXSjlr?=
 =?utf-8?B?VmkrRjJUMzV0eUlHNDNJeWhaTjExdlAzT1J5b0VGdGV1cDNuV3lCUDVZSnBM?=
 =?utf-8?B?MWt5VjVGaEhpdUVMZ1AwckRWbDV5RHExVGJBYjhjNDcrS0d1SnlNV0o0V1Ey?=
 =?utf-8?B?UCtXcVExWXVicGhzcXNxWFhhMTduRS9sdG9MQ0Zab1BHM3pFN1NReWV3UHRG?=
 =?utf-8?B?dVNVZUF5and6UlMwV2dienJQelZ3TjlpaCs2WjFDU2k0eDRSVk5FalIwMTB6?=
 =?utf-8?B?d2lNaXVkRVI2TGVlSzdqeEV6bHNFT3hNUk93M2UxWWRoTk1hT1BWYU56VHhO?=
 =?utf-8?B?YlBaUGNUc1BLOENZdEZhOVVTMkJNRFZaZnFCeGtkUkF0ZFpHbmw0UCtiTlFJ?=
 =?utf-8?B?ckdNVmE2OHVaWEsrdFFhTlpIa0VtU2p6eENua2ltb2MvNXdDN0hRZ0hKTzJW?=
 =?utf-8?B?czViTXpFTm5Dcitpa1BwcWxKUXllelk1SUhsUlljQ0NZUWZaOVExWjhOQTBn?=
 =?utf-8?B?VWRSYkVXeWFoZlZGUHo3cWlpWGRlM21aR3IvdE5rWFEyRElRd0ROWjlGcCsx?=
 =?utf-8?B?MGs1MGM3ZEJnL3Z2M2VrclZ3OWd6NVIxQmFWU1h1SHRISnFaRW94djFlVmM4?=
 =?utf-8?B?eU1NcDlkNkJSUHNYc09RSU1OK1NGYmV4Ym1WQk1LZWJZMWRwb2xkSlRpa3hq?=
 =?utf-8?B?ZDhlMXI2TnVWTEV1RlRGLytJOVVKN3k3Skg4U0RUa21xL3puNWxDMUVua0Ju?=
 =?utf-8?B?ekdvMVJ1L20ra2J4ZWhPaTdjRDJaODFYV01lR3BrTHlSZVpldkJ0WWJjYW4v?=
 =?utf-8?B?ejNWTVBuYTFxcGlUMmFpUHpFcWdRR0JwSWNGWVNXVUVyVk9FdWhCSGtISGhS?=
 =?utf-8?B?MGl2di9ySW5QNzY3NkdYelF6bzdlY0JJMTVRaWE1U0dGTnZiQzdNeHVIWjl2?=
 =?utf-8?B?bHFMMEZlN2JCY0dYQU1ueEdwamRDZUxqazZ1QzM2ald0L0xlWXUwbVc3VmxL?=
 =?utf-8?B?RDNiNVl2K3FxaXJ2S2VMSTdyRDc3R0QrdWFKRnU5TmI0eUk3a2VFRmZabnZQ?=
 =?utf-8?B?cVNiR0xOckk1STBzWkQ1RUZveHZuRGd0UldQU29pbVMrRjJVS2RBQVdvKzFF?=
 =?utf-8?B?eUFoSnp5MzRTODJWazZCWTZpRDZLQmgrZis4NEJReHBKZCtRaEFKZjRXQ0V4?=
 =?utf-8?B?RWVtUm41UVRZYkZCQWFkekN3Tkx2ZWJWWDNmb1UwSnBDbVhoMGM1S0VOUGFy?=
 =?utf-8?B?aXQvWnhuOEpKdGhaQ3hZQmJ5ZWY5U3JCYVVKQ05SNThYUGNCcDBxWWFlMzJ6?=
 =?utf-8?B?K1lhUTBnTE4wT2xwWi9vQk9UeGk1S3BpRWM0UlhhMjI5eldXV0IvMFlmaFJH?=
 =?utf-8?B?QjdaUWViTWJuNTBxR3FYRHN4czdtbk1nWWlWeUlabXRGVjRaZ1hOZHp2QWpm?=
 =?utf-8?B?clBQRHN6VDlnNzZ1T00ybnNBbmJ0OHZWZFFoUHFMT3QwRGcxbG1CVHQ5N2hM?=
 =?utf-8?B?SEJLcFpuOGVlZEIzMDBSaFFUWWdudnlQNTE5Q2prOWFvQzFNRFRvcklQOGJa?=
 =?utf-8?B?TFBoNU5TRjE4ekZsY0lHbHI5dFJhNVJXZHpaUUNQdVpvMmJuSUs4TVdGVmtY?=
 =?utf-8?Q?CTJA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWtvbC9EU1YrQ0VuZEY5cVhWOVI4OHdsMDZNOWpZeTVuazdOb1VtOXUvaVo5?=
 =?utf-8?B?dXNUdm1SOGJjU2RKNXV3ODZrU0tHVUdiQW9GUWFyMEpkY0xTQVlYazU4bWYx?=
 =?utf-8?B?dWFLT1RPdVR3dWo0Z3lsaEFhbUhSTWJYR0JoS2xUOFFTbjZ2U3I3NG5MRGNN?=
 =?utf-8?B?YmRURnFhM1dmN3dnckh0NFRYbG0vZjB0L3YvbkQ2MDd5d2lnVkZmZmRhd3RI?=
 =?utf-8?B?VEZURWlKYzJyeW9QZG83RjYwbzlQVERVN1F3RzZOS01Zd1EvMzFSK1dJNlli?=
 =?utf-8?B?UmdmRmxtMTZXNzR0WS9IRjMzQXpGbWp1d05TVGE0TFJaRlMrWjZ5azdHZ3ph?=
 =?utf-8?B?TTBja05oamtOVlBVcTRRZWpSU24yRlZHZm9tOUJCV1VYUnh2aFpwTzExYndt?=
 =?utf-8?B?VVI2ZjVnSW1XTlEyZmlKcXI3bVlMbHVvdzNkK1EwWmZRTzgwZzdGRFlGZkFX?=
 =?utf-8?B?bVlTeVkxSXZRc2pZZDFZSE50RmVCNVJoWGlFSFdNWERZRjNYRUs0WTVYbmhV?=
 =?utf-8?B?MkRidERhRDA5THYyWitUYWVCZ0lpcFhlYVRjTm5TVTE3dGtXZTFpdmtTcnFw?=
 =?utf-8?B?eWR5amY3NWNJeUR4S1hSQ2pLRzJqZFBNaERPeDBUdG1idjdtSXhYUklXVVlH?=
 =?utf-8?B?RTArTmhtS2prbDVlSmVUN3loVEVza3l1ZGYvT21HU201bGRTNlZzMTJ3Skgr?=
 =?utf-8?B?M1Z5TWd6cTJvbmplcUJJNmRxck55NnRtVmNCQTJHY1hNNUJqM1V0eXlMTEZt?=
 =?utf-8?B?Z2wzK0VEanlnREFPZjJrVDl4QklkUHlkakRIeHJId09IWG1Lb1BXZHI2b2ZP?=
 =?utf-8?B?VWlWUGZPYktielo0djBSdStjNEdqRWdabTJaQVRib2dnbHpmNFZPK3VrMTZL?=
 =?utf-8?B?RzhoT3liWFJaWGgxd2JQdVVYMTA1blpBM2NDMnNoVDlFTnVubFVpd3FWdUIw?=
 =?utf-8?B?SFpUbzNSdzJpM1FjU24ybHVFSHpZZjVIVllTQSs4d3RtMzRVWnVhcWlhc1N5?=
 =?utf-8?B?bm0zaDRWajBFTTg5MVUvMWN2aHhWMnJVN0dxWjdqMTloeW1RM0p4UDQvT1hW?=
 =?utf-8?B?czhVbjhoYm9TUjBQazhXbmxwT0pONXZVSEl6VnBPcWpZVmpUbmhaU3Jvc3U0?=
 =?utf-8?B?akx3Y2xzdlIwZndka2JRcHhaNm1QZW9RK1p4WUJySWlVRXEwQjdHVnJ6TDNH?=
 =?utf-8?B?MXF3RnZrUjY5KzNEak1ucXJHWUNuajNLc3ltZmVudTg1SHRlT05DZmRObkx4?=
 =?utf-8?B?SitQM0wxRE9TLzVwSlNDRFdkMkpyQTQ5TW1uZVJCRGE0NDVvTEZlVDVlWFZC?=
 =?utf-8?B?d1lIc0dwYjhYUmRqenRGc3c3T3EvMDVzOGQ5Yy8rc0J4WC81TldIOWxKNC9L?=
 =?utf-8?B?SkZGeXhSbUhiLzdEMUlhS2dCRTZSVEE1U25LaWt1OUhETGd4WDRwaEx6WFZP?=
 =?utf-8?B?ZjVMNWxMVjdNcTZaOFprZHd1ZWxLdTd3dnNHaGM2RnlxcUtmeW1ueVoyeUkr?=
 =?utf-8?B?Q1JXb2JmZVh3UVdYcTFlRUpkRDhkNEpxQ3pXVUEyK3dKWkp1S3hVZnpOUWwr?=
 =?utf-8?B?bEphVGsxMW9lRkd5MWkzdUFGbXhJbzJxcDB3aHl1RmNqNFRtLzJtL2ZkQkJE?=
 =?utf-8?B?SHg3QXpFKzVpcVhocEpNb0Q4dVpLb0RYODVienJoMjBTVnkwZU16V3lWekVG?=
 =?utf-8?B?MUhxcWJEOUFuWFdGa0dmYmpkRUMyK1FYY2l3NzY0TU5TMDEzcmg4Z1FDNnhB?=
 =?utf-8?B?aXZINlhBR3pzVW9NK3VDblQ3T1ZsaE1Va2laOWNJYzFaR2tQblc4R0FZSktW?=
 =?utf-8?B?UmlkWXI4OGs4dXpNdHk2eURnaG8wcktEd09KVlZuUEs5NGdnQWM5YnhtdlFK?=
 =?utf-8?B?YXhBR1BKZ0hDVXAxRndocmJTNVpURUlVSCt0UHFlV3hUTXNBZXhEdmttRU0y?=
 =?utf-8?B?djRRWklRTmYrRUxlQmVYWVd5aDF1MDJhdGFBSXdsdEZZb1JhbkU2NHhpUWlj?=
 =?utf-8?B?dThUMEd1REg5cGgvZnNESUZqd1FTdi9pK0FLQUdEY2pkNU0zcGFyZUNsWWNT?=
 =?utf-8?B?QlM2SUdiYVcrNXVoS2hLZFQ5ampUODAvNUYvUVhBWU81RmRwU2gwRzZzTlZx?=
 =?utf-8?B?ZmsxMzhSTjdlN2xtZzVxL2FKYUx4dUFwM3hLUml3MXUwZ1BvSDNHM3dNQWhV?=
 =?utf-8?B?Tk80SGl0dU1sRWs2NGtnNVBUQXRzcCtyZU1zaExtWWRYRHI4eC9jamVRYVNt?=
 =?utf-8?B?UWpTdS9sYm5kTnBKYkh4cXJXS3liazAzQVVpbmxuTGZ6Y0hqL2VRUjdWdkRz?=
 =?utf-8?Q?zEFc0Yekt2CtXe7/OR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0f12fd-6eac-4ee9-89d3-08de64516ec0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 00:56:44.7514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYW4TRAeTeiC8Iu3VXP/VV2DxRLSaicyuszIeyCaLcr4DXOAMXI19QnFk6HYden0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF6CDAEAF48
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 921B7180007
X-Stat-Signature: 4qch3mdqypbm9ob9u77egbdwtg8jrp4s
X-Rspam-User: 
X-HE-Tag: 1770253010-354546
X-HE-Meta: U2FsdGVkX19ubW3f4dtcKfYcBnD3ph4D5BxG7d2EqDLsaH0jrcsUcckR8iYQdpIHAh46UiAFnKTQm1z9NO+byeGqMlFZsYq/S3WK6zAmgMf/jUIUP5PuTnvjA/uvTWZSTqdNGNS2NbrXW4uWYe6BV5zzqGhCMyn2UUCEgLvDChAs5PX6gTcVWc6yeM3UYhD9wlGDnWIq/UnuZfuxGkolbKYyIYaS1tU4Wvn3kLa1Iw+TxGRnug2V6o+GW7iyaKsceQJ9DONtIz2dD20gN//p5RjtsnwIkKfY4Bm3VWTjJnKwDbYtjZ1bENJA/3G5wLP59EQ3zDaoW4gFfs9bAE8mIyrqxTxLoZnYcosoK1uAywar9YkhFTyUCg2eBoymRkrHKLiwccVUz3KKGURnXoZ7YpBrcq8Cg9KD5MBfAnH/BB1FhofPYRAzJPyw9NF+lH1e3BvC0qM4RCPKCBPIoTyrQJcABSJBd8EKUKMzPpVqPSAnb+Sn/+ocUQ38gVxBhG9w+ueJcq75QpFuNwepFWrsL1F81X7m1MNI5LV4QG3hzKoqHgRq5CGNDMFwCjavDJR2YvTiFGF1tuRih129naNiywK5+7MPdv6i0nyyfX6QNGC+pO2R4Z+qGKnmmX9A2+dVknYH/rArQRpzECWzAEWZRlr2ZVcfN2Ccx1yzQaRE/p5Zf8xOwMR0v20NlDe5QCZTHBp3/V+ejJMQMdp3CjepCCdUQsp/mPYsg3p4xFc5GhhbSMm9eObyhfpwhQo3/VZhaGIIXCdE+X7epjuV5jsAQSncGZ/GrfI/7N/CZ2IdleRNyV9qXgtP3y3sHF8xnxirKzTKeXreb4tMLwZKFQpW8lHsVfTTnl298Z3D2Iay442VRUad6Kwdcwc4bsk3fh6pLkuFlhwfA8KzKLo11IjS2e96ML3JwyBNJPmmZPg8VIMTHtLgv6m1HwwJnCG08+bReMggCRMJDyv1ZPVCp5H
 AUnXmLyD
 jLTokRAz1/wWb4BfyNxj8Y7NtueFD59u8by6Fx6uyHH+FbaQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear in
a userspace mapping via either vm_insert_*() functions or
vm_operatios_struct->fault(). They are not folios, thus should not be
considered for folio operations like split. Change memory_failure() and
soft_offline_page() to reject these non-folio compound pages as
EOPNOTSUPP.

Add PageNonFolioCompound() helper function. This function is functionally
equivalent to folio_test_large() && !folio_test_large_rmappable(), but it
is supposed to be used on struct page. So open code it instead.

Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Reported-by: 是参差 <shicenci@gmail.com>
Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/page-flags.h | 16 ++++++++++++++++
 mm/memory-failure.c        |  9 ++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..2fe8047f42a3 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1102,6 +1102,22 @@ static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
 
 bool is_free_buddy_page(const struct page *page);
 
+static inline bool PageNonFolioCompound(const struct page *page)
+{
+	if (PageCompound(page)) {
+		const struct page *head = compound_head(page);
+
+		/*
+		 * Without CONFIG_TRANSPARENT_HUGEPAGE, PG_large_rmappable
+		 * should not be set/used.
+		 */
+		return !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
+		       !test_bit(PG_large_rmappable, &head[1].flags.f);
+	}
+
+	return false;
+}
+
 #ifdef CONFIG_MIGRATION
 /*
  * This page is migratable through movable_ops (for selected typed pages
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index cf0d526e6d41..8b6b5950bb66 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2440,9 +2440,12 @@ int memory_failure(unsigned long pfn, int flags)
 
 	folio = page_folio(p);
 
-	/* filter pages that are protected from hwpoison test by users */
+	/*
+	 * filter pages that are protected from hwpoison test by users or
+	 * unsupported non folio compound ones
+	 */
 	folio_lock(folio);
-	if (hwpoison_filter(p)) {
+	if (hwpoison_filter(p) || PageNonFolioCompound(p)) {
 		ClearPageHWPoison(p);
 		folio_unlock(folio);
 		folio_put(folio);
@@ -2945,7 +2948,7 @@ int soft_offline_page(unsigned long pfn, int flags)
 	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
 	put_online_mems();
 
-	if (hwpoison_filter(page)) {
+	if (hwpoison_filter(page) || PageNonFolioCompound(page)) {
 		if (ret > 0)
 			put_page(page);
 
-- 
2.51.0


