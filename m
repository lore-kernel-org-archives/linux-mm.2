Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD7DC53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 00:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34FF6B007B; Sun, 26 Jul 2026 20:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5D46B0088; Sun, 26 Jul 2026 20:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADD76B008A; Sun, 26 Jul 2026 20:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3A16B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 20:38:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACF61140336
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 00:38:39 +0000 (UTC)
X-FDA: 85032695958.21.29FC74A
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id C4523140008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 00:38:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ulCL0uKP;
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.51 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785112717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CIQm41qBdC2/vjFOuEpu1Kt9/FVv1US0cky8Lv7b7A=;
	b=EdebK7Tk16D6gr2Joyl1Co7gZWs8YDbEx8BBRl2bhocf7sWgJbL/VZ9HTJu5WzgBSfnWz/
	KqrUvOib13OkHUqMMoVGKTJ0zIKGq5q7fISuSMRDifN4LVjQTsWkAIWtZDePwbQWAItGAk
	076B3CFpBJqDHgToV3E8HgZOxuo46uc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785112717;
	b=B2TP97ilRIX0sWDTqd5dXNLXSrNt1w2YlxLSKAqXSJmQpRDmvYtPCb27DrLHNezC9N7+cg
	0LSkqGmWziwDw0Moi3yeZL9dSLjv+5JgSVSPjP8CjPEIXmJYIuCzDH8RIW3qwGWNiGvO4K
	KixE1mEB0UZ55L0A0yVQouIINLAxMCY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ulCL0uKP;
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.51 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADNLeR6Co7ym0B8q1egTDsXtr+X6hF76DM3AKuabciJl0Wgswd7Ecq2rcX31RMOY/IZjFpXhveF+Dr+K/pvlUk63DIofpjj3NkizOhmD2GO1Sb00sTFZdiFQKdm1BgWLTyi5BPGkKUJzyUDIn64vkdNAfgAviIzG3rJxjGx/SSmZ0+DTaGFzcxODTqr/q17931OrK4TXcHHUm2C9UyF68hei5unShLoJI7PwDe64gvPC4G5YkWr2U8G1qY9IbAa2iuZzzXxZZRBHONOMLU0EyUXsCW/W6Clvdcxy+8AGl6KAcTKMMyogRvRJ8cfmjQ0K17nJQ3xYK4++5V+MMJXYaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CIQm41qBdC2/vjFOuEpu1Kt9/FVv1US0cky8Lv7b7A=;
 b=PZnzclF1MajIQSNx+S69IMjQmk9eEFHSH6dGmp+fm7yFpWbg1lXPqNjFWBdbeQVwSu8ysOUoibSA3wRz28FxhI1FBwZE0F34EgjfjbpCT3uIx1FoA51j7DufBFFCslFjUZNyZd7dB64HVCTMvnnX5LvFLvL9xm5y64AucOu/J9fOvZULeHcPAqmZT+b8J1tUafbG5BSUi8JWKNPBdiVwhODaBpniCrbW1C5G1B1ujydNpCOdopK+JNqLKD5Z/YtRHEjwfUHvVOAIaeKqwToCJRPZT5c5UuuFj62tIA+RsDyKvLKPD/aaJ/Gvq9zx4Z9tUce3pf5KpiNKpZRoooMgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CIQm41qBdC2/vjFOuEpu1Kt9/FVv1US0cky8Lv7b7A=;
 b=ulCL0uKP6/R5u9ksHnchuEgHfGi145xshzt3Q+Up5zPZsaX45Yp3rqB2ZCjHcElfKwbHkYPnGddTpXClILhOkGlKNmO39Aomw5pRKfguj6T9DnojIWGbOYN1yUPugs7YXWODlGeXOgUN8Pp4Q4UPlLuaexk3yWk0dLkUZQVsXgKFSdIoWVlGbiC5jToFhEtPJpCuMVIHPxvob/kL2hS9d3rIVNFjujqQSjQjA0uHvuTbTJYwwq/8mx5q5+a3oZue136iuHK/9Yva7gz2WcnQ4xdrkb2UQshT8nzhH9McbHQH8jHsSbJhSQTm5/y8+VFd5Cpnh8ulesgjqebrL5t2eg==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 00:38:29 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 00:38:29 +0000
Message-ID: <c3532789-6b6f-4cc7-9d4e-cfb05cc88264@nvidia.com>
Date: Mon, 27 Jul 2026 10:38:21 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Arvind Yadav <arvind.yadav@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
 <20260724214307.a50ed52cf78fdc73bc42f9bf@linux-foundation.org>
 <2b2fe98d-1a7b-4aef-a1ff-0fbe43339180@kernel.org>
 <DK7YH5O0FS58.3OTH04TI72U0Q@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <DK7YH5O0FS58.3OTH04TI72U0Q@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0310.ausprd01.prod.outlook.com
 (2603:10c6:220:1d8::16) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: ec31bdd9-2af0-4cd9-172e-08deeb7760a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|10067099003|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	wR98c1xLGyMdPja3nXG1jxeOQc68m68M85RamTviOAvE2et+uT0ZEvs7KY2a1gceaLK/kSqpfM5pVijXF7TUEHJNn5KhEz1ggobuCUPy8B0cTwuV5Ql0wL/y76NYRVSl6iDrvhSzzhdaOaPzIF6D3bE/tfkq/+xfVu1NqqS49xKQPQSLzw2c+Sju4Eoc4HaHAL6DcmiJv4eAXTI6Q0eTMkVvDEimIZkE6U5AqazYH/SVp5JHi0TUf65dvN9SEg7eLAEEoftNtSI3MjTdcBd9pl4hEu0WlL020CffSnX8PlGX6HrWpD2XqviWKMA7cIUb2g/T9oM2PMS994WrGNx+xtT9ipBAv8hfkZhvqHwiugNOpPJ+SvxsULESHL5L0P2BkSFxJJO0Mb0JtXF04hOPNtcbXlMeMNi5RF1d+Y1OyL5MwY+8BRS7XgiKhIBGXAG/db1a4p8Mx/szO3zWURhmHeT46CYW98F883mSwkPuvo+fQEnVBRAy5AXYWxfk4N1XbGrrN0BBRvZmDSID2Z2UMlh02ALAVRh5J5UijLK/imlgfzUshsKfZkYp5EGp5SxGbObYg5q7Xeze69roohxD7aopbeMQES+as012cKMBXCY1b9wLx2ZVfnkz9pKN1RjwDSyy4rH5G+k6q00PEVOVto5A4h7LWk+trw7rDntS1Ck=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(10067099003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUYycVlURlNoQmh2VHlBTG5ncG5oS2VacTAyTjhtU1JvZHFCaG5od001b1Rv?=
 =?utf-8?B?d2FvaWNIZGRIeDYvV3hiUXJLZ2FSbmhlWnkrN1JBMVZVNm1TcEUwTTJvc29m?=
 =?utf-8?B?UG5YdGs0MlV6TFcrOWRSeTVpN051TWEwSk5IY2hjM2lENGVVWDkvcGp3OGtT?=
 =?utf-8?B?SFFqU0RJYTY5ZkhpQmRxYk1JSGJhWjBwb3lXU2ZGZVhVOHdpaS9KTEoybU0v?=
 =?utf-8?B?Y1lGS1lUT3Y4UHQ0ZmU2TzJ4aXpXVEs1VFc5aEZTUS8xNkI4ajF2VTFEUGg4?=
 =?utf-8?B?VC9pUkR0bmpDYWJKNFZKSjVtYlRQR2VJazhWc3R6RFhCME5Sa3ErcmJqVUc3?=
 =?utf-8?B?R1JGVU1iN2QwK1pvaXc1RW9iWWI3ZlVHUnM2cUxLdmkxeGh4TXNqMmVFam0x?=
 =?utf-8?B?c3RrZVZVY3FlOWw3ZTlFaXMySUV2ZzVLQzkzaktIazZORm9lb3lTb3dGZjEy?=
 =?utf-8?B?UWlVSi9XZ1JJYXZHN0Z4TnFKWHRvRDNMdksxNTR3OWlGZGdFaFdtQVJoN25V?=
 =?utf-8?B?MXI3cHRSRWxQUzVEdjJuRitlM0lrUzBHTlhSUmJOK1dFY0VNS3NxUjN0NUZI?=
 =?utf-8?B?Ymg4emIvRzR4bGRCbGsreEdPODFmMXRLMFJIeDN0YjJYRW9FcFF0KzRvdVAw?=
 =?utf-8?B?V2NBQlhHWU5Da0xxV0JFNlM1Z0ZxMCt6NXc4bVltZEEzNFM5WW9CYzRmYmpY?=
 =?utf-8?B?TnVvZXFNY0hQN1VWL3BuQVZvbXZLK3N2MW96VGw5ZWs5STlNdTN2TDZwUG5J?=
 =?utf-8?B?Ukl6M2xiMGxkSWdVV2NESFJwWWZVUU1XS25rUUM0dkkvN0E5eWR4MjZoNWQz?=
 =?utf-8?B?ZWZFTDdDUFYwRSt1RkhJUEgwYmJwWG1FS05KUER5WDlTVy9rV3gyM2RqbEw3?=
 =?utf-8?B?Y21Wanh0YjlQenQ5OG5zVGlGVDRGUmhJTFp6QTRZV2tJRUJ5WXlvOFlGQy9Y?=
 =?utf-8?B?alpHbWk1ZzdCQ0hRbHVXV1YzMGRnVlRxNnlOWXZUWW5saGwzbHY3N1lQOTdo?=
 =?utf-8?B?eWdRTnhoUGtLeitwNmNaaDUxK2dwcHNOQ1U4eW5VdEtNR1FtMjRVSCswdmdT?=
 =?utf-8?B?NHFnZDJPZVREUXl5K0tKS1BOU0tlSW01NFgxMGdZV3dTak8xRlh3VlpOVUx4?=
 =?utf-8?B?WVRsZ1ZOWlk0ZFJKc0JCYmVoaUdpczlVSFBKSnJNV1VSZG1QWWtqUElIZlNs?=
 =?utf-8?B?Tm01ZHR2TmtFN1NpSVV5NXVBMEorZVYrR3E0bzY0T05JYlNXRG13aHVkM1JY?=
 =?utf-8?B?SjJ0RFc4RnJtbkdQNk1TVmtXTmIwUGM1ZE4rSWdJSmk1RmYzRTA4ME4wR3lG?=
 =?utf-8?B?cFQ2RzE3Um9ubHhDM2p2dlN4VlVUbHIrT3ZjLzF5dzBySHlBRnBiZWdhNU90?=
 =?utf-8?B?azNTVDF5dTVPQ05iYm80ZUIwZ25zNEhyVmVXWWxRcFVRaS9QV3pjNlZINnVI?=
 =?utf-8?B?bjNwMnhtMUZyd0dYYm9QTW9lMERIM0JyZHFiajZpaHhqWlRQMjRGV0d2QnhY?=
 =?utf-8?B?L1o4NmFDdnBXL29XcjZXQVNlS21FRyt6RmN6Wk9aMW14blBieUVjWGlrSzZz?=
 =?utf-8?B?V1AxQzc0V3k2QVBmL3JBRmx4LzZVT3kvS1VKdzJ2TlFmNVM2KzVhbnQvWUl1?=
 =?utf-8?B?ejNtMWV2bWtUUWovd0hvc2xvc1d3aU92cjBBK29nYk4ra29Gcy9QSklEMTgr?=
 =?utf-8?B?NG5ZZTIvSy9aYk1CVld1YXlIQTF3ZUdRY0RNS0RpNE40RVErRzdXK2RmRWRG?=
 =?utf-8?B?czI4UkVQRDdKZkpVcUg2OXdVSXY3aUVkWTVZMzExZVlZSHVldmMrL0ZSZ0Ns?=
 =?utf-8?B?TVdaTjhPQno2NHppNU02WWplbmFINGp0WkdNUXh0NWl6WXZodkUvZFk4aHZy?=
 =?utf-8?B?bDY5N21MUUx3N0oyckkyY0F0NUpFeFVGVERzVkRkMmxYeng4Y1JOeWZSZVZP?=
 =?utf-8?B?TGZ4d3ZnUUErK21CVXR1ZXpBRGZQUVJaUG9HbE1WV2szbjNJLzJGdE5BLzU5?=
 =?utf-8?B?V2w2TjhYdURoaVZuSHJyTGVHOHN3RGM0WFhFREsrQ0h5bk45cHNEVHVoTUcv?=
 =?utf-8?B?dnZIejg0YjU5Yk13ZHdQdEszU0kyZXBXblJlYUNJMTFUV1RUdUJ1eGxQaUZ1?=
 =?utf-8?B?ZlgyS3NjOGJzQ3U0R3kxRFdPQ1M0dEhtTUJGZkFQYTJJSEtIbWF2ZGNtNGFR?=
 =?utf-8?B?djByZjdpMUVOQnJ4QkNFQ3kySWpGWVN6bGJGNzJmVmZxakwzNURiTmJPbGpV?=
 =?utf-8?B?RWpNck55bVh1K1N1SGhJdlBvRmNGdVJSYjRDR2NSR2xjWXkwUFZBdlF3Yk4y?=
 =?utf-8?B?UzROU05HNDZIaXhudXY5K3lSSytkVjdMa1NpN3MzWGhYbyszR3ZsZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec31bdd9-2af0-4cd9-172e-08deeb7760a6
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 00:38:29.1924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h//GEZ+/Fz0vGx6yWQboBxGu6nTD0OkKZCPb7Q6/mQN6I02zHr9yP85G8zfkYf99OQKt03u3fFpMvbEA/0W83w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279
X-Stat-Signature: sg7ufdhm4wer31y3j4eqntguysucw38o
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C4523140008
X-HE-Tag: 1785112716-91708
X-HE-Meta: U2FsdGVkX1+SURTPWbLWFjG1yCWZ6T+vPwxJGwr7kQS3oNQdm6lqM/4b/YocnSyLvPckwQVzhvKzS86JCKBRYFTAtzCwBL24xEa4Vue+hx0/C/MXeZAylohtbIsy+HqNhNO0O41xLG0WiBpUZdsI/Hjeo4RYRyAj1tDSmJ5rzaoUENInzt5V/cTQyrHhfqO6dc5qd6E9qiHpa/0MBDojDWRMLDUdr6YMtV6jZd8d+YOTPc5/7uvspOKhfvNvJcgmybzwU8Sug/I1/ZykMmKgYrdXiqOxw7k+L5sTBTCVxksOX7QGV3d4+DadSaqvK2CcR2fVHvQPTrL6i912c9FL2QJwNrfbwmo5LBV0NN3sZlMBsp+2PO+B2X22Q4pPD6oxN4unAndg00hDdcrNv1+WFdIJiX9E+aD9ESC+iX4xGQNS52QGux59MhCYPwQURxq2DHkkMrkhBMaZAYuX4ZDdsUfdqVe1Utl2YBza+FvSOLuk/BDwODhaDfU/J54/FqCqu0FxL6n/u9GqDDthtjC+0LSQo+bNY7cu2bMDhOKagAYW9K1Wn0GKxlsjb7usnD3koUIIiib5DSjglEcL7lWzF08Uk6wypOa4CBUhGg1CuGeQsM/iHuclvgnhgrVZmWVZZtzfXTT84+NEzooEpms08T8iMH6P5FYgS87ACYSHlYACBAV+pnryXpXm+W/HQ2Y0oxuDICtKZ93J3C66kWrS2v6uwwyS2xqgzsw2J1kweyhkaFze+2Bsc2p72620+DtYI80QXmzIINCRtn/Egz0DG4eb6oWsbtSnf7nt/zmIqGnLdwxOZpt02K1s5FegjcHcam/JbpiQ7AaUVLqm7vHm/kRvF5PCGRYX3XhIoEKw59p55D4mQv2qmnI5eK00rz+5VOU7LcTQnqPQIHAPGZ5nOjLlc1Ow8+8ex+IhC0dOfc2xH4RxGp0LZ3JXOQRQGcNBPJqIS0PfkdXXdCQkG5C
 kAgN977W
 FNMys9SOlxM76enUUG/S17OpRHwrILMuNIq04vAQWvL47CouyaH9Pg1+edPPddYIBZMJFChgFMclcF3H7LTR28JsMbM3VlxCrFV19UKXZlPbcf0IGUqWm0ac52Ut2yV3FyJvXQLMOX9kNHUkyNnHEhMYa0at5PA9zLxScLCySBF5gLSNuZGCNyDbqlwlRwiofiCLow9AWCqMJhE76d9jgjhPpl9AWgjXQ0byNpZhgdtaNnJz0umHVy4M+0M0r2gsXze+354L3EvBHEA2RiUZn3xMgfK/Bqxwl5vLM/3JjarFuGxOiGu/jDbwgULrPogpCmxqW2OkcyU0kV3pLp82cWgqNi2lJo3P0EM6yL/BPdkjVlAjkNGUyIcPIJfYk8ZT6H/xuk25TbNKT4N8e8sPQ5HlUyhdXXj0Ca8DhH/Qe0Vl0VArMOW55M6D8GmRpbliAii5tMSCaO6O5facXyUMJDpy033+9JvI0a4sHOSHE2PB0nCL4ZQKdE+4z/UNg5NoX8WTSWjgky7CbGS+5DFCjqvJ6rvf3nNWaVwW7TSK81AHLWPwCsx8pnTTf1WbAkhfD89buCbXMgUXienZccdhVrAwlTBqQiqfiPQEQFm55ZQkqi2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/26/26 7:05 AM, Zi Yan wrote:
> On Sat Jul 25, 2026 at 3:36 PM EDT, David Hildenbrand (Arm) wrote:
>> On 7/25/26 06:43, Andrew Morton wrote:
>>> On Fri, 24 Jul 2026 13:57:02 +0530 Arvind Yadav <arvind.yadav@intel.com> wrote:
>>>
>>>> __migrate_device_pages() reads the folio mapping before calling
>>>> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
>>>> from the swap cache, but the saved mapping still points to swap_space.
>>>>
>>>> Passing the stale mapping to folio_migrate_mapping() makes it take the
>>>> mapped-folio path after the swapcache reference has been dropped. This can
>>>> cause an invalid swap_space lock access followed by a folio reference
>>>> count BUG.
>>>>
>>>> Refresh the saved mapping after folio_free_swap() so the current folio
>>>> state is used during migration.
>>>>
>>>
>>> Thanks.  AI review might have found an issue with this.  And one
>>> possible pre-existing issue in the code which Alistair and Balbir
>>> worked on.
>>>
>>> 	https://sashiko.dev/#/patchset/20260724082702.2531024-1-arvind.yadav@intel.com
>>
>> Yeah, this might need another careful look.
> 
> It seems that the pre-existing issue can be fixed by resetting nr to 1
> after split is successful. It should also complete this patch. Something
> like this:
> 
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 18d097c388530..4a77b6c86ae4f 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1193,6 +1193,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  							 MIGRATE_PFN_COMPOUND);
>  					goto next;
>  				}
> +				/*
> +				 * reset nr so that only first after-split folio
> +				 * is processed below
> +				 */
> +				nr = 1;
>  			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
>  				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>  				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
> 
> 

Hmm.. I don't this error condition possible, migrate_vma_split_unmapped_folio()
will VM_WARN_ON non anonymous folios, but the design contract is for anonymous
folios only. The enforcement comes from the callers of migrate_vma_pages() and
migrate_device_pages(). Also __folio_freeze_and_split_unmapped() checks if the
folio has a swapcache and mapping associated with it, prior to split. I think
this is a false positive

Balbir

