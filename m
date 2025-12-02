Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA508D116F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 15:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD43A6B0010; Tue,  2 Dec 2025 10:27:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC086B0011; Tue,  2 Dec 2025 10:27:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A7B6B0022; Tue,  2 Dec 2025 10:27:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9507B6B0010
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:27:21 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41415C0210
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:27:21 +0000 (UTC)
X-FDA: 84174909882.14.2528872
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012059.outbound.protection.outlook.com [40.93.195.59])
	by imf21.hostedemail.com (Postfix) with ESMTP id 713641C000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:27:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FTJZFX2d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764689238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xm74YJYnk5wwxOHFanog9/CbuTR4XafiHnR+99D+2kE=;
	b=PWD/CCitDk7HU8Hi9afp5z2PlqLsiGCQMhb42NLb/WlEQz3mPGF2KaWhXSeqFjvMKhE07W
	gM2pACNxq58DZcGefX9gjNh8EYAu3l5Vh5ki9fC3OPKkjSyp/hWTE5/zIXkE+RyZpHO5ab
	22tSVVNrdLtGVIjvxhp0aG9j34Qmcok=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764689238; a=rsa-sha256;
	cv=pass;
	b=0VqNdCbVD2irvplbjaJLi5eSKkaN2t2ZTCZx7M8popqo+oEcIvC7yuz86YeAqe8X9/GLQ5
	LSz7e7VgYu94v9wSRAUFI9YTJYv4SJ4gd/GGgPVreCp63wxBTzbNRkDQknxTMOfqYZw/VM
	Raz+5MHa2Q/WuLKOCZc7pxGJNh00WqQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FTJZFX2d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V/tzt7CoZABraYepWSDG3QZId4/rh9nANHb5SWcjjvrcCYxHkW6dFR0Eqcsjkw2MLGbagB2LfjF/+HWh9mCfsGwsDW0soz930bkSznozI90zqQFl4zElQN04Z9NJXvoKBpLOf8PjiClKEVRRq+PIOznMe6c4gp1nGxXWWwcKxoz29Qa2QzFDaIbFGAqaVyn1noRTPKZECs32nKUcJeeYRxGQ2oLZToe5AwOjg1DlVgLu5VZWISlTaiJiE/1QZ+XpjkqLhT7oF76vfktRW4j74trAxf+R7kJLnMmdgyUi6JxBuO1OnK6saWzi1ThKrNO9Kx6EhPFk5KmiQ4DmaILuGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm74YJYnk5wwxOHFanog9/CbuTR4XafiHnR+99D+2kE=;
 b=er+r6xYjcLjQLtMtvS18Uv03Dl57HNEJrxhexBASw3UygGulo7SPSc9WEYZqao4mSDHWHSDIE5K59kNH06WYEYBUn1n+2ccPw6YXMQK/DeWYXSJR51VuOc24PJVldXQbo0HTFq7cpctlY74ZCihWoctrHrSPPAAkrwXpZRJAuuJtiYk5gGIVUjgl7wfexDBspJzOBoIktsA5N1PsMnhQRkmPNpITM9wPWa9S6eWGkVgQbmrMrshiAQdkI0YFHtH+6Sogi2FT9pyaXm0oQ6AQXQYMZdQEV/aDlBvEdBZlWKcnEW1c+Eu5AaxQZ1PPMKWJzANZOOHZxF9lGTf16KSAfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm74YJYnk5wwxOHFanog9/CbuTR4XafiHnR+99D+2kE=;
 b=FTJZFX2duWusmMvb3zMmLJjNRSIJAxudKFVUI4k1mo+f3x075JXs4geGuLPTVQFDLcVOC5O071Db78y34HZ5skuhihSPntDffgQWJHI6aX14/p2vFYWVaN7mIcc6rImwNhReEFX4zGGsChlD81Qjkhp2LwCV7ZxFAFTvMLvjaWpo9RdyWsgrF3hbfRBifb9sW8GGuRYfzOAypYVn++lq4ZoVg7N2nsthURo5f4IaCzGf+TEXdsHsfOJOItlAPj2m0B9p9nHTlpDGObvUOQVR1obbUz4tzHdjptkpcQX3K0Ul1sUZUAYoiNRRbPSP6Z2k7r6zoeFqH5FXB1T4OPxhsg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB7547.namprd12.prod.outlook.com (2603:10b6:610:147::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Tue, 2 Dec 2025 15:27:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9388.003; Tue, 2 Dec 2025
 15:27:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org,
 mkoutny@suse.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 lujialin4@huawei.com, chenridong@huawei.com
Subject: Re: [PATCH -next] cgroup: switch to css_is_online() helper
Date: Tue, 02 Dec 2025 10:27:10 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <78BB88AE-E4C7-4AB3-9B66-48D97A92FA0D@nvidia.com>
In-Reply-To: <20251202025747.1658159-1-chenridong@huaweicloud.com>
References: <20251202025747.1658159-1-chenridong@huaweicloud.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0504.namprd03.prod.outlook.com
 (2603:10b6:408:130::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB7547:EE_
X-MS-Office365-Filtering-Correlation-Id: 459fc8ff-de19-47e3-8136-08de31b744cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f14B90fX3qDMrTOi+LyYUhPVHtJyv1MqWgkpzBQq+gmMGAi/5n58bQscbQei?=
 =?us-ascii?Q?Cfo5i8R/k1B7WMULipZ0hANkDruYsbfE4t3zDh26d4YNv4p8Tm5dAhHntipq?=
 =?us-ascii?Q?zWGebTCaJK2nsWd1/7heVdHNWmlnCCS6NcE911GTBA18os2QPeSXKFkO67RI?=
 =?us-ascii?Q?ho2MQo1XV00eFoJ5hXq3xG/OSHtlniDkHQvfUN5eaPgWPlv5BiARkQkBBVaQ?=
 =?us-ascii?Q?zJ8obuHirp+HzmEwZa6g2r256CwmlsmiU8nbemQjIGF1gZQgb1Fwv9yFoOUH?=
 =?us-ascii?Q?sjeSZx8zDZWR/S+V66WqBn4SmoV2lyojAvhqd5hALuAot+gE4N85oF/eByP6?=
 =?us-ascii?Q?2y+VghIRHRBwdQPS20Z7vAMLQL9ivbBw7ugjL62tHDu95bfe2IfX3YalqQd6?=
 =?us-ascii?Q?qdAMtedxQI1RZT+AJ0xOwkHQeq6/1XNPCcijztbkYI1f6XO7HI0/aW2rE2QK?=
 =?us-ascii?Q?ad7MoO7vwAZeN8dLT+sHawzeICZwNMN/d2irlmUUZIXPMYxxT7U17wJCzLkl?=
 =?us-ascii?Q?TPceJfwtpfAKDkBqOM9jbZGL/nisK8tnm0sIB/VwVeC0/iKCeWUWBYP8Mwjm?=
 =?us-ascii?Q?LxfMTkVJ0Fj473NpbEed2Fac9KlC7dkZ2pCSln7j/G0T2ioTY3CO7Y6f5HR3?=
 =?us-ascii?Q?2ZGIUp0xU5Uif9W++Ig2MIzYYatMPcABrtGKgQXBx0rW6mTk2qItfzIeOmSf?=
 =?us-ascii?Q?RlebEoXSz/HIMJmuD2yUwvfzakcP4Q9U6rjmQIXr2G87+ewxs29vuc3j2TnN?=
 =?us-ascii?Q?vljgRm17W12HXhxFWXZd/eZv9y0aS1ppTvvp8x1hooWXZxACBtDi8I0O+hfH?=
 =?us-ascii?Q?A/VzhGIcXHTIuI/I+YlftyAUipKh5/kIhs4JbExJAgYVcxcuRC1Qb8McpwSy?=
 =?us-ascii?Q?4C7Wjox8+KWRIsvK26jQl3Djy4ql0XejKb2fRaEsmmswpvnra0C8Z09IJQ54?=
 =?us-ascii?Q?RelWV4vnpSxy6R7RA9UN1cS9MimNf5D93UfHjtnQbsXQN91Nq4kC9ZKitO2b?=
 =?us-ascii?Q?7y5/mdSglQFzA02Puk1uoBOOYUROZ9qiIpvu71rpENKRzy5j2tHZEs90uaYq?=
 =?us-ascii?Q?rGRHl+IOKW+eE8vbbZKvRD4UQCdiVaa7hdNmQwx2RcbXdbAI58YUenLROIhM?=
 =?us-ascii?Q?V17D1rIPnC3dqf7RfcHdIquQZ6OqA2ODS0T3PLn0RH654ZOTfN1MKgAEyeEv?=
 =?us-ascii?Q?/7T4u06dkMyyqKuxTootAGBCNaKFlmiInPTkb0LJ0PFlIfYhvt425Xxhumnv?=
 =?us-ascii?Q?e9aJXe4dUKNziB2dixcWKNdC6loTHxcf7IXMbViCIvu5XDC8fA6HnJ8kaofK?=
 =?us-ascii?Q?61aM6zlA+CoHSyGCA5zEn6WgQ/Y0qhYXh8S8us9SwzHfPDej05vTEmS9E5vZ?=
 =?us-ascii?Q?+53teGAicPzhE/pSoiKPReE8y9gDKH6YOVIxo5RiERiva2cDXUGz4RwdWYb8?=
 =?us-ascii?Q?2OEUOtOxdRnQh8wBityC7UHuJj5RwQOB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/bh5KOjfWnWOdcCPCHrmMVl5SLPcuvwfYJPfIh3DoYV0X8fOuDuNU8Mw7B53?=
 =?us-ascii?Q?anAoLJrlVLpzPkIU76ryHRgKlnlTXIsjf3gP+b08JpvrrM9w3tajTS16q6qT?=
 =?us-ascii?Q?l6YhBm7b8NwrOHnopDKNzV1zFzjMO1LekT75e/sawD7qPSt44cmqRPjGykER?=
 =?us-ascii?Q?unML9zX1S9MozcKCxZ0K/dqGH1fPF1JpUVuvk8xCFoqWWtHyhvkC2ggc/61q?=
 =?us-ascii?Q?obErGx0w5c5PDG6HxC9qGVzAQXobLF6LpHpsNqpAiiRjrSC5FUsibmeyIyHM?=
 =?us-ascii?Q?pN+LwaITVhsKyPoA3EYC4jHkXG+8/j3jvNosEkADK3D96FYiy6dlwk1JWS89?=
 =?us-ascii?Q?uGwgkrYQc3U7UdsT8mE02jxIQcV6HITMIutKB1AveqR6WdxsME+1MtDLEdjB?=
 =?us-ascii?Q?OGMEYpJO6EvcH9Y3EDmlkHBBLtfjhN8FhKqel8gmML+m1JLqSl+Wj+Dc7anZ?=
 =?us-ascii?Q?CLq/ZOZ/JQRKgPEnXZOMURGJ8dgwKaLHQpi+bjJYB1kVDQNVugUChy2g4fez?=
 =?us-ascii?Q?R7tDNx30rUR0Yq1VqrDXYgm699P0uSPz6rhgRye8uhzGTuaIbjjl7SuY1BGo?=
 =?us-ascii?Q?8Rhg46ZyZ1q/960e6j7gsxiRze1bwgPRq5R2AfchoLvXaejV3EVNiJZI3qQ7?=
 =?us-ascii?Q?R4fbM/kdfVzbA2Ly6c4VZFMMop0POVoXsDozi2k21iUONn6gDbkfw6GL1a5A?=
 =?us-ascii?Q?Bq0x6iqLiWrrk9S2DqKO4DVlKqBAtdB6Y0M/9+beww/WSZxKsZnyQI1UFHos?=
 =?us-ascii?Q?7WmV/FXE0yjhYJBQu1xXTWqm3FooiNukUFBoGbY8eXZOk2zfjkc//DsFqTOG?=
 =?us-ascii?Q?CHTyz4/2GmZJ4EZoHilGO4j9P8CK2ZYDoZFP29Lr7uotK0+CFqzIMECgz2Zm?=
 =?us-ascii?Q?Q8x6iGsGOeuWTkNa2ox+fY+kLOnmkhZvxBA1ut8ACy/dK8TMcDNokTGf5FLW?=
 =?us-ascii?Q?NimKeHuHPtK/VXcO52uSrd2S8cFjtphMT+zAjltegdJAtsP/miNqE9QbvFWi?=
 =?us-ascii?Q?qEfnx3fPJd9b6mTv1LmA8SnoeT5nK97f8Fx40HBkH6MA21kPmkTblVeneHCF?=
 =?us-ascii?Q?yLxPIxWFpy4WFAm+Q29hT7rjCm+XKLj6LVS+9ieLAVY8EYZQOHmqyoXDfuZP?=
 =?us-ascii?Q?9kMeRVikKXV1I3KGmJlTBmY31nWVHoW6sH0kHedMxW6cJwvbO/bvwXoAxVsB?=
 =?us-ascii?Q?ArM0Fk5pLelGW0UAUM6x6pzKJB0LnEctEZWwHtur9OCB2fPUB6n73hm96SZG?=
 =?us-ascii?Q?BvVsQLCUBJori3itrIITtflehOAa6H8TXZ+9SntUSBtBqIhgLx4lvwrUTKov?=
 =?us-ascii?Q?lkF77/sm3+yS+pdaO9HvzL9L8Me4y3GMll55HKiszYLqoqCKMR3brLup45qp?=
 =?us-ascii?Q?RChvk3OvivIxcsVejUHUdIA2u5kFSM5yOf4bJrxeqYgSMVbQAgVVmlu8p6pO?=
 =?us-ascii?Q?JTj+wptp+vkOL2LHqmyQvp0ZtX8lYANgYCZhK1yLtqYe0wje/q0ztAvFzS5W?=
 =?us-ascii?Q?g+BnqSTKbN/gvgkpjMJ9S6XgO2TO+TSFdbfpeIhh3Ho+ofHy4Cj2SkIXyQeA?=
 =?us-ascii?Q?Iqjt+BCJey9NPh1DDCsWFKDeH03ceWNSF9UuHra9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459fc8ff-de19-47e3-8136-08de31b744cf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 15:27:13.7692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8eQlrG+a0kmWiNvJlNEuDOTl9EJL6LOhiDTGCeX9tT7WzbOUi7pSgQtcTPgc2oEF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7547
X-Rspamd-Queue-Id: 713641C000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ygtccdbwf3adziecydkhhrnmybe9errc
X-HE-Tag: 1764689238-188987
X-HE-Meta: U2FsdGVkX1/ERqopcOGMKIw95P/KrDMh8LzoWDzzIm+9PzyeIYL96XrWsFAjg2VCgoyGt4lVXH1xxTsHLR5RV1u4/k7Bk0amYPJHCa1PMr0lVsDaAdLjt2z8nI68hwV9jUtcLU/RZpngteAYIB+VjH55Sk/uX4MZZIBDfzJmpnTyRE4omwUzZv3bomAkSfuqqVh6WyVkGaJFlfsRQ5b1CqU0MExmH5BN07bXKFDhy6FZ/x0RxCCt3Em9ps86L5k5b/A6MK2eeivDYUoxa1abVxYjAzCc45V3JOO6mQrmMt6+rUU5dGynR5rAwc5l/p+VwmKzJYKA4Y5839Vjuw323sAg0c1ZAuBcFz+Bd7pvKQeas1Y7TcxjeDZ7r90TzowNck0/GLfsgIk3Wnn3ETXgB3G8JQHpM+T62xrL0WON1u2LnOiggRThyBy+ACtFkbzW1mWSrRiHIdXX4KeqGsRYZofynkr7TNDnUwUhwL+J6yB616Xd86DDlIhgyF8MUOLHiDrNv6hZGnu3CKmVo1rbk94aTd2dPoqiq7qd13d+fYy2YFyNzAn5exevVEe4T3/l/mPaq2MrhwVgGZqhWm8EiNMCobwKrEvUcqz/ULq49aaEg+VWFHV38vx1glK1KqR+bClxr+mK65gvM7Xb17t7+nouu1IoDR5Ny9GW4eyfXDFkGE2Mi5FKqt3T9AASPYbe3J3G7xti+0pAnT6Y3oOx94sZe9tUXnWTicrz+usHKUoVUeK/wSAKjTpPRQZbz62wcUMrENtw+mPix+weVw/q4FS1b4b80SYDKdbst1OMdhvmcakIF8D46+j2ZJcauryRn4vnMVhreCmtP+sY5QjOxZg3PALbRC7pcOLE3LuEw8qKq76VrVaHqzIsZwtQB3YxOkWDdH+SGxBMBPlRVnuKijhR4IN0eZwQX4/BsSem5nD1P9oBCNBuO35+OQcX3FP5Xiy4LDFv/V/mh154wXh
 /iLm/SiD
 846h+8ImO4u0/Oe1ccZKpVKyx2hq7InG4h6/Ib1nwAet30sp73zE6Wy77RtZByuyXk98I1vJck8tdUeMz/PAe0luNfHK6elKIbVN8mG2mh1vRsKBvOFWSAVFk6CtNGOnsT1zwwGGtJa3ZIqa6LPb2EgTIOlmCvR+ujHAeMCHhUaQnMmWUKHUsDD3o4krQSsKHyVZbGpdHL1e0GR2Kif3/4hG05BWY3x3dWxa2//R4LcBrUOvbfzsazBf0BepRbVWVa7GH4yo4fa0GAxkBxoqy/arEB3ZRKJdHCLKhw5UbJbJjaaP2riowO6OhJQjR5Iwmhxkbgl0HAOydMlP7kcrsYV4poAkk+tpyrQ1C9OEAWTL2Xhg8pLDvwvyM3bt+d44mI/rBvfsS/aMrO9yIrTLhL8BHAYjcj3LQoBZk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Dec 2025, at 21:57, Chen Ridong wrote:

> From: Chen Ridong <chenridong@huawei.com>
>
> Use the new css_is_online() helper that has been introduced to check css
> online state, instead of testing the CSS_ONLINE flag directly. This
> improves readability and centralizes the state check logic.
>
> No functional changes intended.
>
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  fs/fs-writeback.c          | 2 +-
>  include/linux/memcontrol.h | 2 +-
>  kernel/cgroup/cgroup.c     | 4 ++--
>  mm/memcontrol.c            | 2 +-
>  mm/page_owner.c            | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

