Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA49F3C9BC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252096B0088; Tue, 24 Feb 2026 11:36:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FFBF6B0089; Tue, 24 Feb 2026 11:36:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080506B008A; Tue, 24 Feb 2026 11:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8AC96B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:36:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E50EC1324
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:36:49 +0000 (UTC)
X-FDA: 84479904138.10.1D15DA0
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023130.outbound.protection.outlook.com [40.107.159.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 943962000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:36:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=Miab+SdQ;
	spf=pass (imf13.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.130 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771951006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9uTVI9cI+hIHQAy5GpMdxBEbQWhVn4MDGadsuUAORE=;
	b=wKvJdfCTwtbLdnAa9nD/4dooqPAzASQow+Hllf6mgZ2Kpxjieyv/7zSho194SqZGzlL56O
	nInCR0CVntNCzakeQ9u8vfDXkIyewJgvj2ehIbEMUMAn9QcEc4FtJJfMrJTem3/aORsecX
	G4vb3gEsBM/cfTxeM0EAiO9Xb9StcMg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=Miab+SdQ;
	spf=pass (imf13.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.130 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771951006; a=rsa-sha256;
	cv=pass;
	b=BGm/D0/uZ+WG56eCQc1TPybfA7Z62rY2w9MnfTWcWdPjWMcS5J7PUPoUPr3YlP4Op296rh
	xltF4jDI7nh8EFDj4EOiYiRqpKCEKfOYBSy+XkvVW9v1zyRx+ucvpni8w8+etoWz7uD1xx
	PjE5kLy3/fMDvc+zqe5PVwfOPn8iCdA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lVdoSeb63/dWkz/RyESsXdV2F9QknqqDBJ3/cC8jMFh+93Vk4PPGpkR3+XkwKpulurbRCRrWsqK4YSRxtm/3N4x7YIgG+wERTCzIUA54F4ZMuZ+Z1omwzT5zZXtWx0v8eY/5Ef9NSiPVHhnwP5sU2s5CMHTy408GgYMQPVpzrIWZ1X69ksDiBolel2vJoSlV6chR8Cs00BZ3BRXcftXocFz1D1ktOdInqOMFscMGEbAK2tJf8hy4THxHCa4e0Mz8HXRVyaM2KqLLP3AYR6KCokCmA0zwu6gSxAprRFNRdJa2P7bYHX5XF/ICFibG5O3diy/+//GNMjeBvb/abBK93A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9uTVI9cI+hIHQAy5GpMdxBEbQWhVn4MDGadsuUAORE=;
 b=qV6EmpTOZpAnUF3mbS+xdcyAV2Jg9XlIk9ZctEas3nhoA4XX8LXD+Pyhtpgexuep0BeAEfzPmZjD7bbRvATVbD4/wTbqk6lWzklQtRknGl3yxsrfUzWnTNb7IoeQ3pJ5x7q4uGBiZ5ZXJTnOi29HZt0zL0qhY/jFaKDEV0QqtjDTGY1Cef84yz2TR0iTzqos5DJqZK0PVvTjYOSxnap7ypnM2O7TF5DK9ULwSsaPAe+EdMIEAfLJEwQiu9JXxu5e7pMxZgO+qH+Vl022sgWLAyufPgujgUoqpZcORW0xyZL9kVOsh/BkY6YJ5YTJZDYyEbTJSQPBxx9RXJqPeYHhgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9uTVI9cI+hIHQAy5GpMdxBEbQWhVn4MDGadsuUAORE=;
 b=Miab+SdQEvYH1/mg3R/AFWnTfct40csBvI59JdKs7mKsu/ObMvkxIEVxH/BP1G2uq9HLMiEV2MERVnZrxKfAIPHfwLcugqX+pWp0ISoYISJp6IflnJE5PS4xXf9dp8cFFnm4PLkcSr02nGeDderN+z7KI6IdImK+BXoRrFGxBE012oOmhuNVq+Glws1P4GLm66ybYhmvouoKsDj3hNT6DWSTVINZx3pocDlSKgsCxw2Fr+byEzgOzD3uvpSULn4VfUNYLXXGPQeGATqTajAJM31pAsQiAFSoCqAIHxzA8FOGS/moegNmUbFQdqkF83YMAEgVScTcKfh0yf6XjPMEtw==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by GV1PR08MB7362.eurprd08.prod.outlook.com (2603:10a6:150:21::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 16:36:40 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 16:36:38 +0000
Message-ID: <f4def6e7-fe45-4e76-9917-aff0deba51d9@virtuozzo.com>
Date: Tue, 24 Feb 2026 17:35:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] pid_namespace: allow opening pid_for_children
 before init was created
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Jan Kara <jack@suse.cz>,
 Aleksa Sarai <cyphar@cyphar.com>, Andrei Vagin <avagin@google.com>,
 Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn <alexander@mihalicyn.com>,
 Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 Mateusz Guzik <mjguzik@gmail.com>
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
 <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
 <aZ2U6TwK7rQtkTvT@redhat.com>
 <3f095a91-f052-4f38-a8e4-2e6dbc9a0c6a@virtuozzo.com>
 <aZ3L3cRL8AEmfQpP@redhat.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <aZ3L3cRL8AEmfQpP@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:66::10) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|GV1PR08MB7362:EE_
X-MS-Office365-Filtering-Correlation-Id: 3508fd10-6efd-4178-9c80-08de73c2e1e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alVNZTRTRFRMenBaV01UaEFqT3UvbTgrelpuSXR6UW42ZlVoQzNSck1CeUly?=
 =?utf-8?B?TG5wUEdFNXRxYjQ4L21sRFNydGs2akNJTGJtL1F0b21JdXlaa0p2K3JXSUpR?=
 =?utf-8?B?eTQ3a1dVcVdtckZLblI3RFJmcU91MmlEZjZUa2ZpSitEOEQ1bHhZZ2w0V0Jq?=
 =?utf-8?B?VGErV09jR1dpZWtNS0ZpakpLRHRhM1RpYnNYZzVJV1FPWnJTZWowYkplTzFS?=
 =?utf-8?B?V1hjMmNkRGNDSm1CaHFvemx3YmlxUmdZb1NZeW9oZGorNmhUS3JHK1d2akpO?=
 =?utf-8?B?R0QzSldiNHhSMEF0NlJXdndTQlRIZUZCQUxBbU5ySG5CcDhvU3FQYmM0QW1j?=
 =?utf-8?B?SUNQNlFUSXlxbE9YWHFWamRDUkhmQ2Z1dkIvN2NyQXcvS1JqTjltd3RFRHBK?=
 =?utf-8?B?QkNxeDFOTDBpMmZRMFBNUXJLTUppM2U1WGFTQll0dEV4anR1UTVTdndkT2pB?=
 =?utf-8?B?NjN6SzdBclBqditLSzY4bGRWR2EvZC9ZVGtuWHRrZ1lNUU1reEt0WlhYbWdB?=
 =?utf-8?B?eTdRbWVWbDJUbVhWRXJCcktPOFkrSU9jblR4YVRRc2d5Qy95SjRlZlMrQmxq?=
 =?utf-8?B?RnRTaCs3d0RPdkV6TXNuNjhSRzJpQndSZWFJVThXN2pRZW9TUEZOVlJ3Q2Fn?=
 =?utf-8?B?d3ZNczNXLzNlRWgrNnZndHBsaXdTZ0t4TXhXMzhBZTd6ZUo3MXVySDB3MWUy?=
 =?utf-8?B?cFNTUUFrcy9hejBLNEhIZnJEUDJIbmZaSURsMkV5WXNjbG1JTEh6MGxsMWI2?=
 =?utf-8?B?Z0IvRHN2NDNYR2FkcjRXYWZrZEJCK2grSzRVYTJNRFY4MUhCaTFxQVp0bnF5?=
 =?utf-8?B?a0ozb3ZlUVZFaFJVcG5QdmFKQnNuN3JQOWNTWFNyRDE3WXJvRWVmVGJ3NnYy?=
 =?utf-8?B?K3hwbGpEZFYvNFpqaUpOeG9PS3FWd25sU2FYNzl0elM3R3hJS2labzZLb0dR?=
 =?utf-8?B?S0dUNHcwUUdrTFJRQzZqTnRiQnVaZ3ZrRWF1RE03eC83MDJpVzFoeFg5b1FX?=
 =?utf-8?B?VDQyL1RJWmkvbCt2am1UcUFIcW5SMUM2NWcwUVErM0E1bDZabXZtdXVTTTlC?=
 =?utf-8?B?UWE4bU52NTJwZEExSjBTdjBVb3N5a1M1U0I1YnU0RUlEODhGczNuVnVpQUYv?=
 =?utf-8?B?VmFmQlQ4elpSd2VWQVc0NTIra2F2enpjY2twL3ROOW9qYXczNmRCbzhyTlho?=
 =?utf-8?B?RlNDN0pvZG5na0hRWGE4YjZsTWJNVjlTSXdObzJ4ekJjTVFsWjFBZU5rSWpr?=
 =?utf-8?B?dzlCRXZVR2wxbDJPdXg2OGxtWFVZTzBPbmo4NGVvbGsxOVRvbFNwUGhCa0pl?=
 =?utf-8?B?dmpNcDhQakdCNWpHRXFDeFlwWE1pU2J5WWhtbzhOQ2c5M0JHaVVaczVyY1lx?=
 =?utf-8?B?TkFLVG1UMWV6VS9ORHlNam9PUWJ2NjA5T0t5SmcyQkx2TWtwRG81eHlVUlZr?=
 =?utf-8?B?SDJ1dU5zMjBSa2RVZi9QY2gzaUVpcTJpbFJua2JyZXMwRlcwQ1d4M1hubkJk?=
 =?utf-8?B?L0M0ckY4ZmI0UHZ0aVY4UkNnT0RxMXJEaEdySzJjRkZyVFg1QjgyNE5zRnQv?=
 =?utf-8?B?UnVFYTQvYmhaRisvRzhQZEc5Uk1OUFJkQWZEd3o0UVlJdjZxVkcyVmpWbkp3?=
 =?utf-8?B?T2xxN3JCYjc5bTFYUFlRSE9HU1g2NFB0YlgrcEozelN4bk9QSWVuZVZZNHM2?=
 =?utf-8?B?dVlNQmFleGRuQUdzYkgvS2Zmc3cyRXVqbDJjT0N5MXRDcE5ZejFMaXdIdXFC?=
 =?utf-8?B?ZURFS2MrRVZOVGJyL3RISEZ0SmdLRzlIRFgrODBXdjFZYTM4N1ZrakxJYTht?=
 =?utf-8?B?TTJnMlgxcjFNV1J4VzNhamNqb0VRdVBNQWxsTWdDeUtxSkFiOHJzWGdoNmdF?=
 =?utf-8?B?OHBlb0VZKzVCQ2EzWVdnckk1SnRvYW5ZYkZnMVlKNnMvWkQ1ZjZSUWpsVGxL?=
 =?utf-8?B?aGRpcUxRVkdsTXRMTjlYWmJWUlhMVG1YVVJLejZCTGU0djhnbnNsaTJzdGNP?=
 =?utf-8?B?K2NZV3hTY0YzV3Fycy9PMmN6d2svc2NFc3pjcnY1ZWZIL3QvY0FnNkN5aGpP?=
 =?utf-8?B?eldLeFpHa0NMbC8wSElIK3N1bU51dlZXdHUrS1ljSUxnekxvei9UMkpnY0tZ?=
 =?utf-8?Q?Dk9U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3M1LzZKL3NuaDZROUZSNjh3czNNc1ZLQnpYK01ka3EyMzF3RGhCZlBlcXVp?=
 =?utf-8?B?ZXE0Nk1ETmdPN3JkUHQxQ3BJQndHR2VTSUd3SDJ0UGI1WnlMQWY1MW5adll4?=
 =?utf-8?B?em1OejBLVThLN2hLZDhnbndiYVpoSFh2QVhkL0kwMCt0RjA3SFVBNHNvYWxJ?=
 =?utf-8?B?dVVEcUs1ekJLL2o2U2crK3pRaGYwYXhnZ1ViQVNjcGpJN3NYSXlPZWgzNm5M?=
 =?utf-8?B?aFExc2VVTkkyTDhLb0VUNlg4QjQ3RVpjWkJEQmtGMk5sVTJWS201MnpyNlQw?=
 =?utf-8?B?clY2TEFtaUpKcGpaUWR1MGdiUFNCRU45eDFuRm13dGg1RnZNa2FGYkh2dzdj?=
 =?utf-8?B?WDRBcU4xeHhaMVlPSHA4R05DOWdWZTA5TTJzOERGSGVxcTJ1UnM4Rzk1c3Fp?=
 =?utf-8?B?QjhzNm9mTmRROTdMUDNKckF6SXJmdUIzODFsaS8xaFJRTjFIcFVzdlNKYXFD?=
 =?utf-8?B?VEV5ejFtcDVkUUJzNlhCeDJNdzFzZ1JYZjNrb1BDei9wWVd3WlJqdnNNLy8v?=
 =?utf-8?B?MXR4aG4vOUlZbWZBOGJMVGd3dWwvbkVsSm9tTG1MbmtxanU1S1F5RGRWOEM3?=
 =?utf-8?B?NTZJWmRtK1hTM0hvbTFqVDdqemcwSjIyRGFpQlZqblJXUFpMMVp5LzJpZk4v?=
 =?utf-8?B?ZCtKNVg0amNtWHFreDk3OUtlNjBHblN5WC9ocnQ4ZERoTEtGU1htZDRCbmFE?=
 =?utf-8?B?U0FLYTVZdkFRZUt4QldydFRTY2NiRE9CV3cyWVhKTFpLMmc0TnNpZEVDK0Yw?=
 =?utf-8?B?QTZNcDdTOGJpclcrelJIS29ucFJjZXhQMjdtdFhuUkM4YmFtN1ZJTTRadjc2?=
 =?utf-8?B?aStWRVdMUCtnQUJEbVNhT2VqU01TV1Evd3VYK1BBbmVWaGRhNTg4NzFFOWo4?=
 =?utf-8?B?dkZidTBoeExHWE8vN05XS0pGaHV3QjJqTk4wQlZ5b1ZYZVlOK2pGOXAxSUx3?=
 =?utf-8?B?K3BHYzY4OUxvNnhQOW93UkdpbURnak1GRDYzUGlSQTR0cjc5Ynp1M2E2SUEw?=
 =?utf-8?B?YVpuT1MrYko0bk5vb0RzL2RZdU14NndCZDVuZFV2dFJZY2RyYmlpMU5EWUMr?=
 =?utf-8?B?bXMvOGZQZDJXYytzN0s4MGN1Q1JHdnBFWTNCRnowaUtWU0V5WDUzRXdXQkZN?=
 =?utf-8?B?MzhEVVRSYlZsN3ppWG8xTG1aT1lTVGRFVGtYRjNTbXkrZkNEMmEwTmNSWDh4?=
 =?utf-8?B?bHBwTEhmTDA0RDdwdGFrWlZFVHVCT0FsZnYvdG43dDRsQmtZYytlejVuZjBP?=
 =?utf-8?B?eS96TXBKOTJtR1BkU3k5eFpsYk0yN21rTkg1QmxzYVV6QVBiUmZ4ZmRVMzc2?=
 =?utf-8?B?ZERDV3FFaXk4REZvVVNjLzZra2pReGtzRThiQnZSNzZ6T3NGQmdXd1UwVFVQ?=
 =?utf-8?B?ci9YT3FKdVdrb3d3b1ZGelM1Q3pHUzhabFZvVmRjVk9Hb29HRDhjNUVEV28v?=
 =?utf-8?B?QmJRSWVscGpYNmNYQnEyUERoTVBxSmM1Zy9zMC9Sd25lZ25UWC9CSkZpL0t5?=
 =?utf-8?B?MVJib1A0SWZraFlTem9wSzZheHNxNkdRRWg1R0o5Qk1Zc25wUzBwZFVoWmtF?=
 =?utf-8?B?WjhqUmUxbXQvNHRjZE5zRjZpdjF1Um55MHpqbVBUb25XVktPeFp1eDJ2ZFFO?=
 =?utf-8?B?ZnNwOUh0RUZoemxvMEdUQXhwekNTUmtyQ2ZsU0t0UWRRVlhiMm1mRlNHTDN5?=
 =?utf-8?B?NWV4RkhUaWt2eEtVRk45WlQwT2p2ZjJlaDRSMDhrQXAxNFhKa09kRFBjdk9O?=
 =?utf-8?B?bHJLdXk0LytXcktiNldabW9rRFJqdko0a2RPdG1WazM4VHFlY2pscDVtZlZx?=
 =?utf-8?B?djVSN1R1S2lzeVNtMHFYLzlRWnRJY0FlVVdnK1RvL3U1RSsxRkttRlp6TSs4?=
 =?utf-8?B?OTdZdmlUL3Ixa3F4Q2llTGFEYUhHOXcvV1JYVkp6M0VqMUZYNzBVZlVTTGhG?=
 =?utf-8?B?OUlxeXZtdUIxY3dKNGVrWUhuS013V0dWTHhwczVUUXNyWUk0OXdPNGRnakg4?=
 =?utf-8?B?ZWxqVWVhZ2tjL1ZxNFRWOGZJdFprUEhlSE00b3hYL01sUjBFMzNmWG5IL2RD?=
 =?utf-8?B?NFN1TmZNeUYvb1ZZalVVUndKVElCcXNYRkl6emg3bG9VanhLZVNZYkV2b2hq?=
 =?utf-8?B?bGVucVdlZXFVQmprUXVEeXlJd2hLQ25lWjYvenFBUU8zWkdvU1pDRVJUVldE?=
 =?utf-8?B?QWhBZW5ad1gwcGhPbHZ3emhoOXpOZGl4RHJrMjFLTFF1aU9Ya2tiYWsyL2dp?=
 =?utf-8?B?YWE2RTkrNDhsMndVUTRTZnBmbU9aOVlGR1BxRWhCVFN0MWpRMmY2ZjVFUFo0?=
 =?utf-8?B?eXVFdGU2R2VqU3dYRG54ejB2aE9ZS2VSS3lNVGFtdnFPVXgrRDBHR2s3aTBj?=
 =?utf-8?Q?M4xcm7e/S1LCGYS4LND0ocymQx/UeRQOBJ5/Jrqkr2PvX?=
X-MS-Exchange-AntiSpam-MessageData-1: 5Y4+lMMqW7UAuhAOjz92pneHT62G8D6yH8E=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3508fd10-6efd-4178-9c80-08de73c2e1e4
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 16:36:38.5005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SLYIHXNV9z+n88D5Um7BXWxOfAUwe+lNM8Gy9xcnrtxBhBMsA2ljcRYit9JhwHq7shuS1pCzTxZhDUNh7NDbdpo5kSCZv2WPjg3kxcLbXvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7362
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 943962000B
X-Stat-Signature: rcte93wewo69a7tkzf3unajjgsnma6ad
X-HE-Tag: 1771951006-285384
X-HE-Meta: U2FsdGVkX1+uZTJHZn7fmW9OFhix3kLYUVJ8yro4I6m4qE8qjfhgPmKDAxR0F3zqCsrKKcU1/oKlgMekOzCkI3WJDLLLW9Zj1qNoUAaDwFxEINHI4q9JiXeQZoLJibRF8dhaXLtfx6FoApcAwlZKj3fm9Gs/Phw/kkWc/qdDA+Atx3XweTq4RkWAw/LFjByGkCotbZgx45ZYshF2fUYvmt4h9uq5c4B3auJTOb4xb4ZV7s0vv8TnhxGPSB5fy5SwTbdI7isIuqCoyexVrBL+B8/NMgoc0nop7/PkutbKeWEW4WMKSe1t8UJ0nfNYHX1iRqWvoKMbc0PkpXKMiH5g69wYwUqGqDWmpZ/Nmkb3TAXVIgC6DMvnMUZtBmS+mgFX7mMCApGayfFXmx/E9LAYN3Uvv2A5JhO3NUQMwvTeAskQGWEGTK202KIQlY+7GRt2JhN2H6yfjzg+oqIACxzJQN6SVyZZ9mk5URdW91HpSXs1tEYAJ2x0cVB2KQuaMeQiUOpaF6gnoyFgtCaJtUi7xap79TS2IKGfk3PMjvjkDeo8HbYXUS+I6WvCeCP272rYUp6zrW4T5+dnO6gTuE/Dwkf+btNimDL7xGfE7pBzo86WX4jXk9WJhGnhI0kt6DHBXzT0b12zgafwhGi++1rDcGNws9UFmmGjR6dYSHzSzl7qF4mC+nPOO9OBmC+WsizzQwUFnltK3yKFNlVfxra6bR5KMyQepvDnndXD0dIB0Eviwc7I8DV4aouD2H7FAaBSqnm7ob55vd9gF0NfLhunGQ/KAXgbLyx2UNRPoGOo1H/zz0iq3BxzFGZEQxGvmAIjbYKGgTfK8wZWtM9oO7003QtjUjl1jswAeYxS2JGvIaLYN5hXgRvquKEWIzXhcVIMrzBRHGqluwXcwQz1gUrfeOABBZBXpTnwYhvi4fu3kHr/jo4XsJMNImz7YTPhqILbFTZxHDLasx6CNLLj0qk
 eGI8GIEC
 0obv8r/JoHwmIRPBufbvXadisEf6dtSzHKUXtcKK+vYku6NUmzGhLtyV5zqIAwuJbqP/UsHa8XTvzwI3DGlXB+xCMx4rSDk2/E9dTcOtFpRyZKL0WLJjci3gQ8/GTr6ILVfoFucDL90UQF47JWmnVxU8XRhk1/YjW3nKEStPz66DMV9c2n5WzDifLQQ0d9tQAFyuq2h0m/jk6pHPv3fiwmWb10UcJwZ/xg4oGAv2XbXX6llZ8Ap7qgfl/Rhzf1WD2Nk4xujoJdUE9QYPv2x3X660yQPJoiDhFPMpfqOnQ0V96zFJt2graHV3wsaj+tsgTGEdvhgwYXdZADKmIlKUb1KJILAC1+2KsNHxV0v/KQYFQN/jbSnq8IgC+qIn7sXrYbLdtTmBxcwdb9z+MfJPbcQDrp2oRBwF5OePZMTSY65avtrOR9MYihAu17CnFySfUHhFFKC83GRo3NCyz4DLlkYjJLhnl8/zoBepKN2BvmryF2RPtYAElokQyIK2RMeI7+d9m+e1pauPGDYpM+swbtG3KsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/24/26 17:03, Oleg Nesterov wrote:
> On 02/24, Pavel Tikhomirov wrote:
>>
>> On 2/24/26 13:09, Oleg Nesterov wrote:
>>> On 02/23, Pavel Tikhomirov wrote:
>>>>
>>>> To avoid possible problems related to cpu/compiler optimizations around
>>>> ->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
>>>> everywhere we write it and use READ_ONCE everywhere we read it without
>>>> explicit lock.
>>>
>>> Yes, this is what I meant... but I can never recall if READ_ONCE() alone
>>> is enough to make KCSAN happy...
>>
>> AFAICS this should be fine for memory safety of accesses to ->child_reaper.
>> I would love if someone more experienced in this area would confirm.
> 
> __READ_ONCE() uses volatile cast, DEFINE_TSAN_VOLATILE_READ_WRITE()
> will pass KCSAN_ACCESS_ATOMIC to check_access(), so it seems that
> READ_ONCE() should be enough...
> 
> But I am not sure, I don't really understand this code.
> 
>>> I won't insist, but I think it would be better to do this in a separate
>>> change for documenation purposes and for discussion.
>>
>> Ok, will do. It will be a bit ugly as I will first add READ_ONCE to the
>> pidns_for_children_get() and then remove the hunk with it in the next patch.
> 
> Agreed, this is ugly. I almost regret I mentioned _ONCE() in the previous
> discussions, I only tried to "nack" another read_lock(tasklist).

Heh, I missed that in pidns_for_children_get() we have read under tasklist
lock, so I don't need to add _ONCE there so it should not be that ugly =).

I will test and send v3 with prep patches soon.

> 
> So lets avoid a separate change and WRITE_ONCE()'s in copy_process/find_child_reaper,
> we can add them later if KCSAN complains, they are not needed for correctness.
> 
> But up to you, I am fine either way.

I also noticed that 
https://docs.kernel.org/dev-tools/kcsan.html#c.ASSERT_EXCLUSIVE_WRITER
asks to add ASSERT_EXCLUSIVE_WRITER, so I will try to accommodate that.

> 
>>> Perhaps something like the preparational patch below makes sense ? Not
>>> sure this is actually better...
>>
>> This looks more universal at least, as instead of two checks we have one in one
>> place. My only concern of putting the check where I put it was to avoid extra
>> idr_alloc_cyclic() + idr_remove(), if we already know we don't need it. But it's
>> only in last pid_namespace we can have ->child_reaper unset so we do alloc/remove
>> for all other namespaces anyway in error case, should not be a big deal.
> 
> Yes...
> 
>> I will add the preparation patches: for below patch and related to _ONCE.
> 
> Again, up to you. But either way it would be nice to have a comment or at
> least a note in the changelog to explain that this is also needed to avoid
> the race between alloc_pid() + fail and another alloc_pid(). This is subtle.

Yes I will try to emphasize this.

> 
> Oleg.
> 

Thank you!

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.


