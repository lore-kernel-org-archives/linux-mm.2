Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92862CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D48386B0088; Tue,  9 Jun 2026 03:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF87B6B008A; Tue,  9 Jun 2026 03:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0166B0092; Tue,  9 Jun 2026 03:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5BA76B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:31:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D499C1CB1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:31:45 +0000 (UTC)
X-FDA: 84859554570.20.753DCB9
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010004.outbound.protection.outlook.com [52.101.85.4])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6063C40004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:31:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZnsR+DEG;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.4 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780990302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+69BT9xQ7xY85k/YF/KKyra/oYCb/rP5Oy/H2j/EQRo=;
	b=C/Y4Y28RWi/zCU+JaOKEMPerbrd57LwFgaG5Pl11bmy9ws4ZPCAgU50dGPeO6lJ/L5ewwP
	6XBu2o/eQlaj76Vk/oM91ody46TZVqkFu37JNya1mn0fzWVxmhXwjEk9Jvtl/15VDzsH+J
	tbh64QhGXodV9wOZxJafOQsR412kIPU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZnsR+DEG;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.4 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780990302;
	b=6PUhe98IcmL/uSDt0KUULQm+V1t9XdE3/lexKXZWPJQiYLnfIyjZe5OnuImpBoNnouiE7R
	WIeBZTZAiFVK0wDCkJ7zZsjf9R0xR1XJeEW1AN5gaHZp2rdJOBL8efeRSOHbG3gkZoBhfa
	xUwqb1aBIzPjWKLfC9WELr8k8KSGlpM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C6MdEFXOW82/78zRm4jzcOGTdbIBSNG/0dOz8TCVheAt0NPWLEXQkLxKGPdc6qM/lbbfq9mkD/CqxFOLlYTy2gu5UGPHfRuMMME3mfOlWjwwE9YcVGRKYTAQx90AcaY8uiHCb23h+oJDIQzQUkwgiMLcRQ064/oRgkPqbS0FGainIyqLuWxbSt6p4/Bv1cA9YST53ffSDMeZMpdvS27y2gpx1JvujWT0uwB9gRjaAQANzP9fsXCHCSL4L87cVVOzfSbY/Xh7HxlHAZklMweksKJbxyAYIwOs5msWq/6lOq5V3CJeCHJj9KRvgwLq4bJ4FN9YbSoAin2lUiKkVS8RmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+69BT9xQ7xY85k/YF/KKyra/oYCb/rP5Oy/H2j/EQRo=;
 b=j00REv9Nx8FDfj9skPQJzD22NYdsPjIS6K8xLyiCaHKh2f7NHigBfWfbgLSnw2Cg1t6oB9HS2gNHnNDcBdq1Wrc//lTK82OF/0Jr8y+gVl+YM+lYgP8sbeRgomBqJqKbNkZbfO+F8OoL0G0vC/VdVchRdqZgBLemvbmxVhP0NdCCa78GUhhiTwfLnryw2qUsk9x2bf98ShJGzHHUvEVCFl8/RlEKlsB1hg9Lb/CHukB2Ax2/cbhkhaI/BiToXvHCClUuzZVTkXyxij1FpFqhGMs4n4l+GeIARjh9Mz0AGlOPZQRTbRyeEMVKsDY3KQ3g0FY+9kfIqizcpGzs+GKYIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+69BT9xQ7xY85k/YF/KKyra/oYCb/rP5Oy/H2j/EQRo=;
 b=ZnsR+DEGQ6uBEtYci0cLx/Bet7ysrxl25Nw1ChNR9Ahw+DN+Hd3VDrrEiQr9s1xFcVICE/oSV56dwmmDL+zhecbR4dKhY3nUPWHR1iBoxsxh1ZGjuNE9Otelrel+sZ7TNaaN1AMltT79QgYcJCYWgN3NuCeMu90+CIJ2f3e1igo=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by PH7PR12MB6489.namprd12.prod.outlook.com (2603:10b6:510:1f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 07:31:37 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 07:31:37 +0000
Message-ID: <a5777c52-9af5-43c0-93a7-dbe4d41f9e86@amd.com>
Date: Tue, 9 Jun 2026 13:01:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] drivers/migrate_offload: add DMA batch copy driver
 (dcbm)
To: Karim Manaouil <kmanaouil.dev@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kinseyho@google.com,
 weixugc@google.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, willy@infradead.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
 vkoul@kernel.org, bharata@amd.com, sj@kernel.org, rientjes@google.com,
 xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
 hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com,
 riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com,
 tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-14-shivankg@amd.com>
 <20260609000009.dvh7gfbmiz76eliu@wrangler>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260609000009.dvh7gfbmiz76eliu@wrangler>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::9) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|PH7PR12MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f0bc16-9846-40ef-14bb-08dec5f923b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|6133799003|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	OHnWkyRAewQtFKyXxateXMzDVKCJdG7f4srPElteSi+IJJ4BirFwtnqc7pnzvt6W24/f2UstDxdvbRgyWv7QEzDikJWAL5MWcqXWTFT/ey3jr1geS5CCOZTTsecF5od4/yT+BnZNiaND/HMEyAet6h0oTxK2yAafp3kcWhukhELBqdkDzl5gTzzrenPv8Xb5sbzy7VzBMlXC8DNwHKUvKFWFBeOW3Z8wKnoyYTf7NKgbzDZpCSE3Jya62IWutLISoEiuAaTDdIlCjhv1Onjh5aALXQYEgItxE5uN0rOAmuQKzCdTZNdOAmHd0U/k50SWhb2ElyJOJKAQ7YnNe7LBMGA1oOu6sHhrPOnZKgKCFP38b79+B/z+CbDnyiiYcmiy3hp4xqMURD+DFrP32FuPD128pKzGpcTMJEN0l3ElcyNH6ieSLzkgnexMhrbDBq1+lILP9jZmWvDkYAPGJ8ecajPuOKfvfl1QdB8nsisrESzOfBYiSYra18U5WS6B6aRtixBY+iJNoXH/ktL7d0rcJ+6XA5kQSye9zAnp3le2kJPaJuLwZe63FCRKx3zbarHnOMULzN8dA/bI7gNWX8+fEEsMAeYNPJO+GnkSnPNpVkUoChbYde7z3u7Ka2YUgdK9MZ80IM85Bz1BSYs+Td669dQ/7qGdo1JFANLky0FR2oQZPlgbme+u1Dj78AcCx2XA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(6133799003)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmFnTHBHVlB0ZHRQd1k3dllaTUtDRFk2V1dOS3Y5bXU5cHc5NGcxRjBmQlNa?=
 =?utf-8?B?c2RoR0FuR1U3aVhIVUU0SFpwRFJrTTE0dHh6SktEbExnRG5ESjNIQTBPdjdM?=
 =?utf-8?B?NjlDMHZ1aFRaN2VLaDFNZTA0b2JhZkJMZVM4NnBzaUpaSVp5dWVtMGJRbDIw?=
 =?utf-8?B?eTZ1ZVZzcklhYUl1a3VxdVJUY0hhKzk3cTlIdmlubStvNEtUZGdsR2ZyeWZJ?=
 =?utf-8?B?UWNtWmJsR0xmUlFreFVhOHdIMldTWHdOVGlMR0FmV1VmdEQxcnBrK0FqODlz?=
 =?utf-8?B?TFZwUzNNOW5MRng0bWk5NVRYMU9oT3N4M3NiQTNYbjVnMnJjYTk2QzFWeWdk?=
 =?utf-8?B?VGlvWTdqR3pEU003TVRwYTF0TzZQajFhVkNpSk9nL1UydndUTmMxc1hYc28x?=
 =?utf-8?B?RCt6MEJOZmVhNHBCSExLZU82N2U1eVlQZVRvOFBNdGMxRFNEQjNIZ0VyTEVW?=
 =?utf-8?B?VUwvRnE3TEZ6K205UVR6dy9OZUxsT0d6N0E3cnNsamxPVmlxWXhYa3RJYjBi?=
 =?utf-8?B?d2pNd1B4ZWpxMXRMQitxOXcvWFpyWnFLbGQwcTQ1YVUvbVJkb1lLdTZRQk14?=
 =?utf-8?B?UUV5M2R3U2d4MjFPeTRTZ1ZPM3lrWW1OaTJtL2Z6OEJWU3I4Q3ppNngvNHZj?=
 =?utf-8?B?emVobVNNcVNsUUtQMm9FTFBuMW9VT1gwKzlKbUQ5T3NvbFR0VEZVSEhMclNI?=
 =?utf-8?B?aG8xOUUrbGYzZmJMbFJFYXlOVW5SSEFnQXJEejhIYkRNUEd1WmhKdTNOQ2RU?=
 =?utf-8?B?NWlOclp4bDlZczVhZVJiWjB1QXpKMzJteFk2eW4yNDdTbHlnczlnWmxHZHg1?=
 =?utf-8?B?RXRuQkdHeHhOQlpNbUhtN2w5bFdvUExmNHhKTzJuQkxaK1FBVFlqbEt5dWln?=
 =?utf-8?B?cnN3S1UxQ0NOUlppRE9RMkxsMGhRb3RGTHpKSEZ4VEhnTDFLcU8xSUJ4Yisv?=
 =?utf-8?B?S3lpUFpvSWd5bXoxMlhRaW8yMnB0WWw1RXg1RjdScU1tVnFGM0FOVUtSVTNt?=
 =?utf-8?B?OVVWcEJnTk5sakduQ2xsclUwcUJqU3hSdm12bHk5TWV4d3l0QnZ5NUxXZnNS?=
 =?utf-8?B?dU1hYmk4ZVdkaDhBQlBoeHgzcVk3VkJIcFNzS2dxZ1pCNEJyUGdYd0JFeEd2?=
 =?utf-8?B?UHlaMjB5c0JNL2NqcCtjeGVzdld4ekc1dnNYTE9tMU1STkkvNTBzZTVYOTBk?=
 =?utf-8?B?dHduTFJRSEs5RC93MG9pUGhRTjQ0bmFTOE1Jam9mdkpQMFdzalI1bURmOGtC?=
 =?utf-8?B?ek5hVThwaGF1RHB3WVRaUFhlang3OXN6eGtPUGJjaHI4RmlBNDlyZFhoTmRD?=
 =?utf-8?B?cFlwSjNNQkhROG15NmxDYkxDRndaSlBsNURxcGFvNWxCTkZ0RE9nZmp5RG5w?=
 =?utf-8?B?R3VpRlpOdDY1cXVWaFNrQm1MZ0tMYzY5Q3hYbUp2TjlydDJhbkgrcWtQa0FD?=
 =?utf-8?B?V2h3TUgwWkIrNU9CUEd1SW12K1hqUjZkcFJQemkxa1g4bVdlNnpUWVJsQTNO?=
 =?utf-8?B?YzZNZVpZNjJwSmIyQUVVT3ZwM0Mxb1gzVXZHSmZJVHFRVGNvWGtFTFB2bGJn?=
 =?utf-8?B?NEs2UHpzUjNxb2Z4WU0rVU54cmQ0Q00xK2R6M3pHVDlWV0h1NUU5U1dWc3ds?=
 =?utf-8?B?WmN2dWVXVVIvaXVSa1J4RnI5ZjlXYjV5aUduUkZBVXJiUWtrMW8yT2xKeE9v?=
 =?utf-8?B?Y0lVN1M5Tkc2RGZMSWw2N0Z3dTRBYWZDenBFOHkrblZGaHpXMGNoOGh3VkRR?=
 =?utf-8?B?ZkJXQWN4aDhUYzVUYklWYk9vYWNUcmpqczVpd0UwSG5qbEp3L09MRlI5QS9s?=
 =?utf-8?B?SG9BVGF5N2Y4S2k3UlFZL1VUT3RzV2FadWt1TXlIT2hjSk9FVDVmc0xuQkZv?=
 =?utf-8?B?Wk80YlZQSDN1UnpROWkwcUpvOGtrNnlLRVk1d3FSMTRvdURBSGEvalp6eTBq?=
 =?utf-8?B?dmUvOUswN1ZLR1htMVdkWVVSSHVJSWhtLzMvTFRzUDhyNE1sVEFTb2NOdmUx?=
 =?utf-8?B?K1J2aU1WSHZWTks1SjdNekJYOE15VFBXUlJMSHJ6Qkt4NENCV29TNGVyZGUw?=
 =?utf-8?B?Ky9lbTBneUo2RmdpVTZROGhnc3J4dytRd0xkR1FUcU13SG5sYkI1amtkYXFR?=
 =?utf-8?B?eDA2bmI2N3NheFBOV2lkUzdScTljSUlESkxqQnhSZ0NaQ1A4NkxWaWd1L05L?=
 =?utf-8?B?czcxNkRFeUIrQ1o1Wklqc2pPT1UzQlFlNmFPL3h1QmZtQVllZGlsUlc4enZr?=
 =?utf-8?B?SnExYjZuTW9rbmhQdVg2SUR3OE40WVBKazREcjN3MC9rS3I0UW0vZUFyU2VH?=
 =?utf-8?B?Z3oyZEh5M1dHY25KaUV3eWhsK2hGeHZaaXlmTmp3emtJRE9qdVhTQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f0bc16-9846-40ef-14bb-08dec5f923b7
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 07:31:37.1187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XGXl1dX1nRRaLb3kA8D7eG/6xCmtbtxpyDfRy6YN3CxPLzK8LkiydoiOfEKnw7u3uzuYP6Mg6m63wts2FuGq3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6489
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rbwnx3dwp3ndff1eqbof1xgej6y7wb4x
X-Rspamd-Queue-Id: 6063C40004
X-HE-Tag: 1780990302-686207
X-HE-Meta: U2FsdGVkX18crX+i44PMsTy5xT286ODrix9awosYNgR7WcrgfoCJCJKoFHihFd12ksUUqYe8i+urLJunye/gvSIPcOF9pNZssObLDSfg31lCfkY6eHoFctTtypyDsngjgg9SpzlDrTcK699FnQ7zNQLat6PcQdwbErWhzVyQ1108q8XiuZZmlOVhjEi/M6dAyV+FJAZEJPEr0LUeoJi/AsvgmolRy8UJASCQ1RpcboyQA1KKheTZnBkK4sltFLFhed2P40UZJWeZzM9n2EEo5cdCC00e/C7PIjxIMTYZO86PqIjEVgnZwUY5AYC3+lBJd2Iu1Oz/ZWQ7Nm7rykyXTFDAGJ7vFLTrgZsURfSUdkDqn3AI3sm0E1CSkALD71d4jmH8V2hTNrjtwP2io1WBv+uYk88HNHls+YVAdIe1jaIoQiQdiw90cnZlIfmuB/OXhCjQ35Oy8JVKZbGZiIpjaXb7BTD+1ljKRsvRTfEboaiqgcwMRrZllU6yZ4rzjNBfDgaWcn13eSHTnzIImWKqgYXR+AwjCvW9RM8OghtxRayWuWepEVfffjPmnqk598mYtfk0jQA5jBisuBdx1x2CltTwqnwUitP37gQdyvkVPEoOw39J96uvNYaQfqEhuRy1IgPYBxpmP0x0po8EknSA8RRLUJYlBM3yh1FN0BaCZ2O5unXc4aKGTzgAVJDpFYCnYck+71PSvHV1422n9uaJ6FHd7pNEv4Oo/dU5WJSIovH5L50E/oLz0C09caCp51CIUQeLKJA/USIpfzBp7k3VcmkV8aWWHf+TMbKJLlC5MGy3K/CMgOW7Z7qKvyfViVBSesBxP/vIHZtCJLJhbAKPnQzvkxFY86u85+hpIT4EIvyVVdGFruNI+nR5pyXrnHH8RNluWEtr3OH+uEz0JL3JHD1LmanvZBFjd2qGYMH/ZZAnq0BJ1S3IWgnqhezO9oad3jUHbn5+dQguoXCsNNk
 2G7wL+6Y
 64A9zUYVHqNA1V/iboc14Jx5Qx9VTzgvw6RslicCSL5+ud4plOYCU84agqbXtkAdomy38KxV6KyWFX3qCv5+eAqqsTJVJTYqBWrrAf13ZN7d4e8ZxY+6n8fNJH1H91tE0fKWbq0n3gHtonlxVa5aYdNqZYiBc8lpgPPboLqbYs7CPpUtpy7Iu2/Db4yUftLNoDm0oa6YFIVVF7Dx6HqB4ZhLljqad/vR1G3Qt97GQ5YH5UqHcb9xNupm/4iIc2SPPDQhQNvsV7UBxx8bj1cRvyzUkJcciPDIK5oWLtiGEdqj9KbGGRduvyMlVrz+0vYJPnYyCK5hvgJCLj4vY00lP+zjwpm2cTOIvtKgZUR0vtdof7j959YtqG22/D2Eew36m4aHBkEC9w3d8AsgZZughohed7Qxc1EEcUVT+7SY13scY1BqWABH33iI7AqjJfrgewg38DMQedABZUCDICu72K2ReABOqkOMmw37L7xKG25aZBCY9vpqwp+2wluxsjZzwInOBpL4yUuxIX4zJWsJPm84Q/m2u2W4T0jx9BsOi21aWfcrfVm14DmI96iU4tN+BEhz87LOKmn8gG+C4EzNCtkzMaLnmhalG/DZJI4VwtRmYIyob/NJGSGCNW6aJc6e3F4HQIyZYjWmz2HOcqQnmtDyGxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/9/2026 5:30 AM, Karim Manaouil wrote:
> [You don't often get email from kmanaouil.dev@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> In my opinion the driver should be at drivers/dma/dcbm, other DMA drivers
> in the same directory like idxd and sdxi can just export a struct
> dma_migrator. It makes it easy to have everything in the driver's own
> directory. For example, idxd has some internals headers as well as an
> already existing dmaengine implementation in drivers/dma/idxd.
> 
> PS. I am writing an implementation of this based on idxd. I'll try to
> post it soon with numbers.
> 
> You can add
> Reviewed-by: Karim Manaouil <kmanaouil.dev@gmail.com>
> 

Hi Karim,

Thanks for the review.

I'm excited to see your idxd based implementation.

For plain memory to memory copy, which is all migration needs right now,
the public dmaengine API is good enough, and idxd/sdxi/ptdma ... can
all work through it. I'm curious which features you're planning to use
from idxd internal headers that dmaengine can't provide?

Also, my understanding is that driver/dma houses DMA providers,
whereas DCBM would be consumer of DMAengine APIs. So is that right
place for it?

Best regards,
Shivank

