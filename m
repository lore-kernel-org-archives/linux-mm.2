Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C081AC43211
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8D66B0005; Fri, 26 Jun 2026 10:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398A06B0088; Fri, 26 Jun 2026 10:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261A26B008A; Fri, 26 Jun 2026 10:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F12356B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:08:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7741CC20FE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:08:47 +0000 (UTC)
X-FDA: 84922244694.20.88B47E8
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3913100018
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:08:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cjocfrLG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782482924;
	b=n8fJ6gIgqiu5Id209Gze+gA0F/if2FOOyVV0iie9l7eS9MIIK7z3uULjMSfEHnUP2ZNE3F
	MSYZpeaspkf/lJnw7u6MhiZsW+XHm60RKLWW/xlKRb8j2DDvoqkhbJ9dWlC3JZgLjNrTdK
	RPYgeDaiQtPa4zM629xbOu3osI22de0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782482924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UENPahxVswqzuZ7m0i50Mb5wwqzkMw+6H2onMLyuCuE=;
	b=6h7SHD89sOKJ4bgKJE9p+SsFlP5XvgsG+AR+TV6Zg6dRbkV9bzpbT+1XOGsLS5k6gz710z
	PIxw8qK4N61przmvv3wH/7rAUK+JGdNVqW89ldzDXZDiIaAnyUAy/vAC3sv+SS1MLNblN3
	NhpeJpG6EbVrCa7Uh7kMmXYh7ZBDBlE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cjocfrLG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NkTK5H9rR02XSitStMnoI0JMMNgO15Lg/W/bavQukAoYOMzy0zRAgugk0TAmjtkrqI2iEGS3u5PZsRZbykziETYPnOHFUkxbdASbz/ekBXjTHnRVjFA+ZEVpja+LwF6m8gMhN/qgJ8h1rfaT+cTF3uQG5lfUICQZn/10YT9/z8jkowRXfxppXa1lEmTNc566fbx54v47XAAPk2LAsUvneTSTNJry8dSbSqIfLjQwzjaGdazJrcr+4FEXGVXNKFGNgl8Wnqhz7/MV6CeWHQ9L81wlQdS8vnYfNoQrDpMdOdeaoH2jOF9nlow2VsajRWjdZI2nU4L525CDZFYDZbMgvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UENPahxVswqzuZ7m0i50Mb5wwqzkMw+6H2onMLyuCuE=;
 b=gZKWOUx2g8+ZrIv+VtG4B/aazzE9f7pDPAM2Y/c2sDGfjC3VU2LVf2CzXJg1z1aY3YggYSQaIlZhmIKVQMoO0IGW3GjqFSOs2WddknTdDUo/Y+Cfb4Jp7Rrun2tQTSNgOfFkRIQ10ksu+hawv2E6dl0XJ1+G1drAg65QIbCJY2W5OFhLS6QsNSZjVRK7srN3bOm/9sZaTVPvhrtYB+Hy3wL8pGnZnkFgaeGKchXJryKJ+fmx6Mze0mhzGzbxy2rdyKUqw6JTZF0NfVsGSwXxzDGTHsJTrhJcGM8wTsNfSAGNohzO1sDVapXP5YPWPIc1oxHRjH0e+N1f8NOzBjsWTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UENPahxVswqzuZ7m0i50Mb5wwqzkMw+6H2onMLyuCuE=;
 b=cjocfrLGKYfDPUnkarasU0jDAYyOiXYXrbgYG9K4er+I5euPje/vESHiUKxUM3HWOahnTPnS5vy1EQ+LhZl4RaFDh0zMbXwy0yx+wBc7Io4jf6vi5xh+L8zNGBfUFGSpxF4ezDUyGx2I+W1gpBU9jymK8UqoWN6fOJL8eghHshXNOPafLlnLZtELhIwunGxw2lbaFN3SE7vz4m2t0b8NYsCp9N9HSH9nmvF5m6ItP8SaU2jcDAv1BbKtGGt0rU1jmRR4HKTBl55JPjQZk2l/JcgpVnYkA5KMdX3g9UTw9a9B6UjDjQA8GsXw9NlzTEhmOavjPOBwdpj2A/L6xKqfvQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 14:08:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 14:08:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 10:08:34 -0400
Message-Id: <DJJ1GI9R9KYX.VRUNK0PHFG85@nvidia.com>
Subject: Re: [PATCH v2] fs/proc: fix KPF_KSM reported for all anonymous
 pages
Cc: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
To: "Jinjiang Tu" <tujinjiang@huawei.com>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <luizcap@redhat.com>, <willy@infradead.org>,
 <linmiaohe@huawei.com>, <svetly.todorov@memverge.com>,
 <xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260626013252.2846774-1-tujinjiang@huawei.com>
In-Reply-To: <20260626013252.2846774-1-tujinjiang@huawei.com>
X-ClientProxiedBy: BN9PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:408:f8::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cca92ce-c581-4920-f2f3-08ded38c6a22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|921020|6133799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	UmBgSJLp9L5AtPgIsAOuopFJ4twzZiCQ6/EgnJz1MYI/ZX3pKXQ485hNToc3BFu84iuTOf6uchSu/Mw3J7BRBq1YAhS8CEDOcxNnxnL4jYX3FJM2yn4Mey6tVhf7ew7U6WMFq3uMkXgBFcrQnr89BLuJOXurG7STcIw7mzY2RSIJ9i/fGrThWGkS7PEeZ3XTFu1KzOGO89kJH0IxmC+kkq3NQ75V4LaTiNg+9bnQC8viC3LcncvG15CpOtsI2T9eIesKKMlVnCJjQLCjuSfMvs9Eovau7i4A9Z/1yAFGAK5X5Kk2AlzPUkcQlC+e9Cqy2eKH24UlH5O46iZOXKU6A7BOPlDYDv1YcqRbaL5kriWREZ/QUa5PEdCegO8PHMOIyapy1NTh9Qco7qftc8rR75UvUSBCuCWnOJEK/wnFJ+m1TG7f4jHS+jJ2Zg2blMa6Q+7dZEFW2WYvcW5qDEcmObTM5ZnkFjBGsfCpDrmRK/pFARupJPoovSaba30BcksWSyfESQ+gLIipPg/0KO9qDRNb0YO6hYSqsSYsXlwzNbntpQ0sPG9AoIQxcsnpDKmTuMD/T9sl1y1a/w3v9svgBrzjGTeUTviE2mCFDwPXSGE8gFwiC2JVHSkUooD+mD2dTUDjcGsKEILSJ1GsZGvmAJOgsGeEBzjyiquwUYcGMH4YtJ2QNcqq9pxw+WFOIotqdPw6rqWE123UPy8UgR2xrw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(921020)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emRLeW5YZTdUTFNueEM5Tm1LRTUvZEFmaEE4TWdaNGF6TDJYdEk2UGR3NTds?=
 =?utf-8?B?YUdaaWhob1pocUgzQlUzeTlVYjJvSmJkOS9VVmhQbW9FY0owdzRnOEhWWEdW?=
 =?utf-8?B?dmRWUDl2eVJVQmkzQU82ektuT0VDeks4bDVpcW85cng1c2wyUWVHbmZXTEln?=
 =?utf-8?B?Y3JlR08vZ0lpTXNXNTVWQS91RVpVR0RUakxUSnljb1NiT3JoZm1Xd0tTb3JX?=
 =?utf-8?B?RU9adFIvenYvL0VxOS84TjF0RU5iR2NINnpGZVlYdHdGUlM2WEwxZkowbmhv?=
 =?utf-8?B?NStZakNORU40d2x2NDlKdlQ0OGhUQTFvQ1Iya1hrdFFtcFJ5R2ZiTEdzSjZ0?=
 =?utf-8?B?b3hqRUorNE1LcFd4cTNib281ZDlUM3pSVkdHd1hkbXg4dW1LOGJ2OVhHYUFz?=
 =?utf-8?B?amJ0RThkOUJHZ1FqMFpvOWtPbFpERHdsdXpqSFhJRXRJTkdlWEdyTnBIZTQ4?=
 =?utf-8?B?NGJzMDVydjBmTE1OajAxL0J4cCt5Q2p6a0xUamFndUxtODlZV3NSQ1RvcnUy?=
 =?utf-8?B?RnhYMndlcnZJcXdMYm9NY01rTVBEVGVIcWsyQUJ1ZVRPdVpYdXhUU0pQa0tE?=
 =?utf-8?B?ZTJZT0w3S1loSWs1VFpLOElhR2FlQndUc0NNNHRUVjFGeFlKajk4S0lxU3VN?=
 =?utf-8?B?S0lUT0w2eCtOOTM1bjNnSTR2cmQrNHprS0gyajc2bzRQcjdkQjJkWWlZL2tQ?=
 =?utf-8?B?WE9MUy9FdDMvOGxldWxMbGJnbDQwVUx1ejJQRmhoNFlrY3p4QW92WkZCdEtl?=
 =?utf-8?B?WkUyVFIvbHJKQmY5dTlvNmk1RnFyZjRROFF4VkNlNU5ZWUZSd0ozL05DTWxm?=
 =?utf-8?B?MkZJTnhDOGw4S2huZmN1dzlmcGRsRXM4c1E4bVcrK25XRkE0aTQ1cENwKzNh?=
 =?utf-8?B?Y2tlbURmR3o2NnBHY3BtOUhYUVZyMlgrSFIyTTFCSHlvRGhaaldSREhYc1d2?=
 =?utf-8?B?cnZhcnY3VEF3TkZpUXhQaUx3VWdjdnlneFk0K2oyNnMxYjEydGZDaGNhQUgv?=
 =?utf-8?B?WjRLbnlUZEZtTHpKbFlYaklSYjMrdnRscklSLy9KTjJtMjZyQ2xyUmhDUnhn?=
 =?utf-8?B?UVhOT0dxcmI0aVkrNUFnZDZwWmRVRDl1UnM5akZhZnZkTUJ0cjF4Ni9QWG8x?=
 =?utf-8?B?VCtqdlNyZWd2ZjlwN0JleWFRWGhnaDlJWi8vTlNVV0ZEWVpFczE1K3BENEJF?=
 =?utf-8?B?Skg5ZVhUOUE0QjZLQnd5SkhVMUR0NGNZMEtPVW51WHBFb1J0b1lObXVGaW1E?=
 =?utf-8?B?T0JBSEhPMG15V1djV0Vja2gvMHY5bzBZbkZ0TTVNSjAvTnc3SU14MjJLclE4?=
 =?utf-8?B?L2RSVXZYQTFpdFZKNGtKbGkxWFd4RXpaNGxSbWZqcjFER0FzdEg5aldhT0p1?=
 =?utf-8?B?K3p0OUlOQWhmWlZDUFJsQ1NNb21VR1dnSUFtV2FTb24xT1ZkYWxSY2txVHBE?=
 =?utf-8?B?aUl2SnNHdSt2RUdnNXNGTUpubzZ1TDVIaDg0dEFlQ01lV25ycUpsMUp5cEdm?=
 =?utf-8?B?bW5WUXY2allIZmRWWUEwOTBFUG1WS05Ca0c4OE40d0xCR051SkJ6NjBieURW?=
 =?utf-8?B?bEhzUHp1bHc1T0l2VzViYXRneWtETVREYVVHcGlvV1JxZDJINXFmSkNRbTk3?=
 =?utf-8?B?R2lidU9UcGZVbU5ZK0hZOTcxOVRiUkdMN29tdk5MUmc5R1dnam5xZ0lVK3lw?=
 =?utf-8?B?UGdLVHFmbVFzY1duSVJkOXRTdXFFSFI1clRvOVZNaGxrbFRLTkEyOWVyWnFq?=
 =?utf-8?B?Q1l3cFdJMWFQWWI4cFZjTmZFUGRsbHdrcW9BYmhwbkwydEIvT0oveTZvVGh2?=
 =?utf-8?B?b2NWL3dWZExpdU44SnFQQWxPL0xnRGJBUmtpOFNqb1VtYWkrWjNVRUJCUEFz?=
 =?utf-8?B?VE5XanNzcDdYSVQ4ZlErZXd2UUxtSjVUejZERmdMNFRVaU9kZ3lCWjlGL2lU?=
 =?utf-8?B?bHpTY1ozaCtuckl3NE5TQytabTgyTE9mOWZzK2dsdXkwZVlnRGNtSk1HcnVy?=
 =?utf-8?B?anJUbytXdHZ1UitDZDZzZy9JU1ZMTUpDdUVLYnVNTWhhM0J1NGdkUklBNGY4?=
 =?utf-8?B?ZTZ3NVRiZ3ZBWEZ6MzlhOTM2RmE2b1VKRW1ON0Qzb0pGa1Q2QjQxTkwzUDJZ?=
 =?utf-8?B?emxNcVJmdDFCSGErN0JQYVBRNzNwTzVOQjQ4UmJuOHdNQjJ6S1U3dUlYbGQz?=
 =?utf-8?B?TEdaVXdZUEsyZlh3cjNobFgxUmMwWCtZbERTd3ZrSlFjb2RrQ1VsQTVxU0xl?=
 =?utf-8?B?RUdhcmt2MkczQm1LME5WM2Vnb2NWNENkbXhQQkQyQXY1N2prOTgzQmdhZXJW?=
 =?utf-8?Q?Wz7beMnO4uYBBoy9iR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cca92ce-c581-4920-f2f3-08ded38c6a22
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 14:08:36.3833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBndanGQh2GZjnJaKufDN1apj9sTFKYpbKtJERYk1gdL4sB2V7Yr+gGQVZhyMB2t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5953
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A3913100018
X-Stat-Signature: gudsoose1w9mjmzhq9s5ti3pqs4fnio8
X-HE-Tag: 1782482924-572301
X-HE-Meta: U2FsdGVkX1+jQfJ/Khbp3ggVqtSZNFzz4F4qUhj8iSu+8KHU4TIDHc2sQkWOd6Rg3tUY/+XxQhHlgE2hD/ZtrkJy1CZUes+6N3mx2uSGF6HRyeFjehh5CFjjRvV74fK/WT6rsBOLMAkHL1oUqyToNHDZ+dEe1AujLO1H66Wx8rmsRwtVarShoLkSmKO6UKdpMXMPXyDC3Byc1xukYA0ucv5Y1KvU3kJU9GY9Ix6pHZxVblSY8FSoC4vvXzGvbMArwOLWlqcOFkVeTqrCM9EuA196cn17UktYAEkt55zN5PbEYfwX4A3fiX63o7fAbNbphzUv/jOt6w0J4DRi+u1puOxU/vEFL2exwbL2B9u6cL0GivDVvWbRGD4ng2AvRdxLdhervE/YE89uIzKJfp9gUCT++wxFm3dXdZo4MQBodML+Q4aFVChcUR+17wwtz1I3AZNHuw5yR/pnBrub5lcEBvq4fuhG9mUM7DFSrEfZTRliZdTb/YlqKU22EcxlMwVKIf8Er+4FhlWIc0zVwvKlQMwLaS1dyM+X6gAg1SVxLZA+bS2Jk4W+uv/0WewZN+IX0Vf0pJqQPfhB6DMmJRG0gFJ+yXZ21JOXkt/lis9+Lx127ZF2NfNyHvAh2ZwZAmLzInVs2p11cJyY2teHcJ0gI2A/IhGsyjtd6e6ThaaFXwYIVP8zGfVVEoCoIlHQ3bVPQI0TJijlYUM2QBqsFahHxC3JXrSn97z1QJcpnsTtfhhtjvxWnYvFjJCszA1RODBuid09A+j9Ddgxl+Hi4tOqkvmKuxKto4w+H4G48vr9xkaOuV7apYXf2c614A2DwZr+zjz7jH7SZBVgmYt1rOGemSIjGHrIj4OgoWt6PT/luRFxPOVkExcb9MVeT5rgzXy9UWQ7LR90Nv4UNRcw8KEWSlX05Y5VVlkt1MKi4z/vmunMXP+1ooSgTmpaeO3iK5wneet9lcb8Q6oy5c9rjIw
 YP/XZ+Ve
 1xpXmVGWAUKd5pQwqiycVpx/beL80YJs2Z/7LXnE/fuEQY28OkoUESW5Xu72xnIIL89G5rUpZ0r2gD/qnH8n5TYH2olDUQIQ5zJ2rn8mzOBtxJnqqeHD3d1RYOsRJSTe7sDkv2kCSuKhfHKPdJXPezwU3abT1Jcevq057VsgI84ObVpyYhzpE+O06LW+zSR2VZ+h4wWwn8Ms9HPo07sfm5FMJGgN7XOk2N7NoII1NE88tBlcFGrrxqk1mUW48LaE0LSCfZqG4HsVGxgZQCcbcBUqH2BcjgFZeqifqx0yHdaXlD9xP2qyNmEgl4Fqj3WVI3mKoQshg1If6wHuR667SAy8BKOnWNhbyjQcK4u12xMhoypS8NvTmu8uDBoUY6yv3Rb6SOhqRCyXxDp69Waym6LdySDzK7t9fVGHxGScypENDybmNbytNMcXBPC77E0SviBfIgXmO4tRmSNZMqCrv+55pRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 9:32 PM EDT, Jinjiang Tu wrote:
> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
> when KSM is not in use. As a result, tools misclassify all anonymous page=
s
> as KSM merged.
>
> In stable_page_flags(), if the page is anonymous, then use (mapping &
> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM=
,
> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
>
> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
>
> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
> Changelog in v2:
>  * use FOLIO_MAPPING_KSM to match explictly instead of use FOLIO_MAPPING_=
ANON_KSM
> only.
>
>  fs/proc/page.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

LGTM. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


