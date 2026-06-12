Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 748C1CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6EC6B00AC; Fri, 12 Jun 2026 00:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E576B00AE; Fri, 12 Jun 2026 00:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794436B00B0; Fri, 12 Jun 2026 00:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 675B86B00AC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:20:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AD95140370
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:20:41 +0000 (UTC)
X-FDA: 84869959482.17.6FB207C
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1007120007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:20:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MMkY22C8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.85.61 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781238038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfyrFXoX5R+oqlXoiZ3ejF6v8A5qo23gkX25PizxcLk=;
	b=7m64Qqe3jpx9QmAIr4Tt3RIagSAwMLf3a6m7DXtVfiVgdg3+QKBmGTavIfAYOYoxGfQKU6
	DfnqXlefv6VlAT2ZEocW1Eg5y+QYIrnxODbJkTgC0yTBWldTB7SyQwg+Esg4prrmcFcLti
	cL5W9+tQ6Ebu63wc0hjWLnPhq8DvVhI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MMkY22C8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.85.61 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781238038;
	b=tmyvsYheqXJtYgCSFA7cAl8qL+ipYwPTbNM1mOyeqx6am1ekY945ZBfCFERUUmo9XFffYO
	eXr6+5EbRqF7QgBbu/Acv7K9qvrr9dHVtaUuGKss4/yFC96EuKqevfTcUUXUkaAIqXkP6w
	dm3rG7LBl97r7ZICpOCoGnZJJzlmmKI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PFGwD1c3av6H+kGZb4btXjUUmdu3YeTznvQ7/xHCQKfxh0V0WnN+XingW+MkNAgEnPXpsUrloZZKit+e8wDfBIAM0I7R4w8TeNBGj5hidKnNUYn4uIYw3VW1ct3CisVedlXdoXXTX9UKqJNsa83LDgyjREbo6mL3BseQ9MzjfJ5/dQXCfw6opt5BDQokGg8Lnav/H0yp6Jr/9bgoS+5si9SP82uMKybwDjSybt98YV37vowC+V/CDGxEN1hVLu18TKtgo87vMYIfqwkF/XEZMutFaaMcnOdrEuf6MGZt2XDIU8VpP3FOUDrYkPBvKSDgYGpoM+zUCigYofs4NOr/ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfyrFXoX5R+oqlXoiZ3ejF6v8A5qo23gkX25PizxcLk=;
 b=aLB0UBtlHR/N3T4GW51YPrfTPF6xp8CGaPohAmxBSalGgUY5apqaJ20dsxAu/ql3X2sVkJgeJvACFrBKZfH/W4AFX7fV4GEQiuZP1fR6J3RWaOIhU+/2aQ9w+oud8rBB8IpnL6JjdySib+sz3B+7Zh3KCTp2s2LQCEYbzBDGwrehRUPACxX/adrYPQ535msHtRlpfcqbUvP3JI6D93HPcAqgdvxsC5CfGHYrv24DDJuSEVHhi5YUaWZs3+2Opvr/MVgtYlNshhwyCQOGyJ+IJHxGSey63J/tXpNI8xp8bdgaiXp8lIJ0rKE+S5y/qCiB6XvErkKIPF5HXILTQLZa/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfyrFXoX5R+oqlXoiZ3ejF6v8A5qo23gkX25PizxcLk=;
 b=MMkY22C8tEZj0o66VJ7G+9w5AvjfTPy/tpOfLkCJWeMadpCaxfPghE93+wCeX9YBPuUgiVA+NQcTwhMujx+fBoxJOH1NI4d46i2/ticnu3+t33bLvLVsp7eRdhWGn7WdeJqqR4bta1cW0DOwspk8qefIW1YnijOMYJE0p/J+aE+Yjzct32Up4oUBy1YNB3+SjZSW8SdNXteSQ8URsKQekPYrhL9Wltfnee1hLRixEdymie35G9OHnM861EJetPScn0MwK8bn54BCrIvq5gO7tDffGSY/iUo/NsCXXDM444NwHaI5HO8fN0W//wOfh4xr0LtlS01mHJuYbAc+TvAhUw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SJ0PR12MB6853.namprd12.prod.outlook.com (2603:10b6:a03:47b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Fri, 12 Jun
 2026 04:20:33 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 04:20:32 +0000
Message-ID: <932e1fa0-dd9e-47d2-9133-d3b2f78dcd97@nvidia.com>
Date: Thu, 11 Jun 2026 21:20:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup_test: fix race with PIN_LONGTERM_TEST ioctls
To: Yunhui Cui <cuiyunhui@bytedance.com>, akpm@linux-foundation.org,
 david@kernel.org, jgg@ziepe.ca, peterx@redhat.com,
 yang.lee@linux.alibaba.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260608025043.88087-1-cuiyunhui@bytedance.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260608025043.88087-1-cuiyunhui@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SJ0PR12MB6853:EE_
X-MS-Office365-Filtering-Correlation-Id: c558dba0-9eff-4fbd-bd45-08dec839f1af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|22082099003|11063799006|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	oReW9XqowuMIs70bAx4hWaM3WFXIwQDkGGlfx8wzv6Md/LewSkFSqQXpv97MygL+wvPcMSkQt29AwGazCot1Zp2PFe7PTKAil4lq0jI0CPzHTiSv6P/X3XH7DuQtNXI+QukYaIPCE6Cf1rWayFRN+/ns4VL4XKtUrfIMa+C+ju1NJkFe9WqNl24DwcWGK3oUqZpumZQ6yHJBYqVXrBm5EyGHop2cBe8Hz1ScHYi6vnJKHmAQtG07XU8/GsXeRgzxXQC5GG8whzt2830qAIQmzreFWm8bPKkWoyQd0m9s4SqTOhlUyMyG9iwfE3Ri0NXF30dyOt++5KJFMIkmgSDpqVytJvpWty2hWJmeNEdPcYyA3C7anwsL3JpyNvG31bG+ouTuNIumThPPgC3QueTlNb6Eapj6UkPSwfWcibeD0pwoGT9csTPMnIZjEP2idkvsR+w5VvO3LM2PT20hQevEf6VnlrY4XTwGHmWfiFku+XPqydMRetjcN6pR9neviYfaUBcpAA3r1BTxqc6GWqBcFXkaxU+l6sQ67rS8D7MKLMQnQfvbdcZ4MBMTwCKVzhRl6ZVUvlSB8Ck1AhR+mRTJ0mukVRiFerHIn1y09MSEvsJrNSpKQznjJV/maOQRlRdhlYkrhRFidFRsMH+QChw0BJyJkDN7ZJExj2r6k3KeSadJ8F5QtBqVWCqdFOJCXEN/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(22082099003)(11063799006)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDZJb3crN1llYXpCbUZCSjdibHcvSjc0bGlSSEVHZVRxUVhqU25CZG5xRFVl?=
 =?utf-8?B?bS9yN3AwMEd5QUh0QnZhaVNubzNrTGtGa0N5eEdiejkxaytKUFBEN3JIWmtr?=
 =?utf-8?B?ZHEyOGhKbHo2R3hhZlNXdmExSldwMDJRYWorR1NFQXJsek5OdDVBMzFDRWVq?=
 =?utf-8?B?ZFVEdDhsRlN2U3FDc0V3VkRFUXg3R0lpNUpMR3g3ZkRDMlkzeU05SHNrRGh0?=
 =?utf-8?B?NGZ6WktrUmp3SFIzbGtxK1dPTHFhempUUHlXVmMvdzRoa1VwMzNLMzI5OExK?=
 =?utf-8?B?TUJJYXJ6RXVFckFpMVVOUVp6RzhOUm9kek8zMVQyYngzaFNTME1KQ1dmT0Nt?=
 =?utf-8?B?bU10N3JVL2tmc2lQRVJCRVlrQUJNNWFKbVJXbUxoWkNTMmpCQVJGSmZoZ2VI?=
 =?utf-8?B?enJYc3I0SnN3cXBSd3dueTB3OTN4UnFyVCtlZFBDWk9TeXZhYk5tSFp2S1Ra?=
 =?utf-8?B?SFRRc2U0NGVGeWdFK1NiMThscjlQb2xhOW83ZWdDSGdvTm9VZW9tTTJORVRU?=
 =?utf-8?B?VnVXVjB6SlhWNU55VGNBZENwYy91U0RLOWl5SndBUTB4RWdabUt3NElCaVlr?=
 =?utf-8?B?UXUvcTBtZVI3b1J4Nmd2c1Zlbm1TRWFMVkVpcUVPQ1hTUW9MVHl2ZFUzUmxO?=
 =?utf-8?B?MXAvNGhIaTA2WkVXWW9SUlVFYTdhM0c0SnFPa3BnVEtlL0oxVmdnQjVQbTRT?=
 =?utf-8?B?VDBXQlgwSDN0LythbmZyMUs2WE9nNkdCdUQzcmJlK1J5ekR0VElzZW1kZVhm?=
 =?utf-8?B?cE81dVdVL1lwbUZLRjFGdVRadURpYytQRzJYUlZ4Q3dnK2owNXdiNi9lNzRM?=
 =?utf-8?B?QzJkQmlRb3U4WmVPY0QyeWRxZnh1NDgvZVR6ZlpUREcrbSswbUFCZG1YVzhk?=
 =?utf-8?B?cjRNZ3o2RVhjQW12VDFxeVBZaTBsQnl3eWZiMTZtdlZpZ3RQcHVHa0FzbGUz?=
 =?utf-8?B?QldzRU9NTERiYTJxRnlKRE83djVWak0xbjlyMm9XWTF0aVdEUW5XRXJ6d2FP?=
 =?utf-8?B?UXBLWHRwMDJGVXI4L3dWck5vTng5MUlhYVpKTUMweG1wRXVDSDVxOFlRNmlq?=
 =?utf-8?B?UC9mcDdCMytFenp4NlhTVGRQTU9uWG8rWkJEanVRM0sxd2pYUjJCc2pnQVZF?=
 =?utf-8?B?M0RuRmlyRG1QSFY5LzdqMytNTURVc2tMSitqQjI0UUlRT3JvMERwT2plV2tU?=
 =?utf-8?B?V0VCcGNrWTRzYmtWRk1IT2dtWUxyUzhya0Q1UHVLVGVIR09DdkQ2L2x6b0VZ?=
 =?utf-8?B?N2dLZjRIY1YrUW1xSUlnS3BXMG9JTUNDMlVPRWlOb3FvK3FvSTZkcGJmWTBS?=
 =?utf-8?B?WWsxNklxZU9EcUM1WWFBWUc0VHhPVnRKazdBczJCYVY4SC92bnN5ZGZnV01N?=
 =?utf-8?B?c1hWdTZkT1YwSE9meVdyc3RHbFNRNS9vQ0xPT2dIK2JUSVJRMjFxMEdKZ044?=
 =?utf-8?B?WXdweWxINUUzTEJqNDh4MnVlYjhUQmVOWG5FNnJPNmh3cEVBcjdQeElNL0Vj?=
 =?utf-8?B?QWZaNytVNmlQalNRQllDOS9wTzBKVXFOWndqZlQ5YjZlTXlSdTU0NGNRUDho?=
 =?utf-8?B?QkJkZm9lY21QSW1XeTlQbUt2YWxWaGs0Tzk0Ny90YjJIMnlOdDJnL1RVZ09m?=
 =?utf-8?B?RTZ4WVNweXBrM0M3TjRWQURVc1dhREF1UnRJWmpPR1BEK01Vam02Q3BVTUcw?=
 =?utf-8?B?cHoxY1ZJM2Q2MVFIYmVkL25xZXI2YjVycngxdHh3eng1cXFmcTNmMytRWnlH?=
 =?utf-8?B?VFlvVWFUVHVxd2JmamErdjYvL2lWbjQzTk1GK2x1blJWQUhZRStSb1FiWm9W?=
 =?utf-8?B?Tm1haytrZGhwUnRBdkJ0N0VjNVJGdzFOUDFwSSt2WWFVU3JRZHlPSm14N3Rj?=
 =?utf-8?B?NUdHVEw1MkdFb1hNUU1nRkNVTWR1NXlVUlRFa2NjYW1wa3E1eG1weFlUejRq?=
 =?utf-8?B?TjJDTWdtN3ovN0VzVWt0dWZicmwwWHkzSXgraDlzUlJ6N2Z4cUcyTkZsbjdo?=
 =?utf-8?B?Z2NZTnhzV2xReS95NFBzTlhyMHFSRlE1MHFBclYyVTAwa3plYTY3Wml3ZmdL?=
 =?utf-8?B?OExCUTlCL2RFVmk4bDJkU0lpMXRTMkNnZWVWOVVrdFZXQ3ZHVnp5QklZUG94?=
 =?utf-8?B?UEtlM2hPWUovWDMySFl3WVdXM0FPdFdNTTFrMUk4OGtoZndzcWdvUG5XeFFy?=
 =?utf-8?B?bzE3UjBOUXJ2czRialJxUmx4VEdhVUlGNCtCZmRKYzVGWG81QXR4aHdUWnUw?=
 =?utf-8?B?VTcxZVE4TXUxSm9uVUlzUjA1L2JtRzdVMUU4ZHZhc3BrM2xWTnFsQ1RrUkQv?=
 =?utf-8?B?OWVOTTlORFVNcStxa0pjeHlqanQyWVZ2NndubTlLSnVYeHpXK0k1dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c558dba0-9eff-4fbd-bd45-08dec839f1af
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 04:20:32.8412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOrDwLAGHoxxFFWHRDVZ4EoD5cdq+u+D5YF48HOMBImv/6ZKmHi4BuyfXq+XC0IpKwupMn2PD4ptxDB8adyL/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6853
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rmp6i9zu4eq9poxyzn8y75jkdoowcdm1
X-Rspamd-Queue-Id: 1007120007
X-HE-Tag: 1781238037-40363
X-HE-Meta: U2FsdGVkX18C819Nq5XdUke6d+wdV0tNlir45bYbxLs9VgHQiH6duCVFXX7Z8JxQtiWVHQZ3YM4ByHv6ZNV5pu2lsSJkYHiPFfgXzIOL7PbGfTHYaQtDNsza2R8NoEwhr15capPJ7P8UQn8xm11cdPaUnhzs9EYuZ/NcHfwZod46hz9srGWMLoUCTLLbxGs18pEcz5cHy7B4DQ3+s33TzBQOKVCsZ7M3Z2ul9MYGyJyAIaOs7NVYgBnwQighxVhFqYESCARrrZw42xsjAMKexViNQOzD+t7udxpVR6RMJ4nPfp3T9v2ZMG6AqbqGVgKSZ2IDHvWn2QICJ1qo9DxIiebl7kHkGwoS7ZqESWsK+JdB5c02k8MrT2QrlKTuyIkACNLuFqMDvqj2rof7soI+4nSWvxidD3wRiEI2/EWmrsw9uaovf6MzufUkJ0sjOHp1LQ5vTxsOiD/C56wuzrfZ8NQ7t+J5wqWAjqq+CizWrlM1/DQlMruG2d3lDHv3FnkhPh05Mh8vZuSGCxSgYHj4++MTjc8+pWmo9Js99XJAROH3ZKAmVqzJnKjCy+iDVBHoYy0bjJp0QrKP8cg71QEovOUH1rsUH+Bcowz+eArO3o/j+G43wQRQUeaWrERg+5zl41qos49yJRCkgyoqVhsM+hXmO183/t3JF+KI7NC4hwo8Df7+/zLCCwWA1Lzg4NtdGBf21Ckh3lOAEy7OvHyZF/naVhDfioVhpdH1v1j8C7eZ9pPxFn1HJRWpvYlKZ4MTVSxHgp4YKuyreSHV0mSOh7qc0J8pQD3JHfK8FEAgpPOYEUovh/8UzkLJcubPMZiF7cWSqG8PwTldgEjVA4KXWlHlctkD2wEP176WUq/gn08mj3kuS31xy/n72FL0K/6Rd0EYBy8fzUGeVZU5sMnwPLBTB6nImC0RbKGXjfnaKO9ArqTyqJxYsiJWTk0oqNdGmWfWhSgEqpuJjxp6lVH
 sAJOGp/3
 DuW1x/Kvk3tSABKec7uHTEimnGopcUYAIkvLrNQd1UurBRKUf3U50odfmWN8Dk9Zt/CfYg2pzM39Cveq7F3izPK8Qns2KkGAhU+sgxEhQe5nUiSKMNh67nXYZwwdFlXgQOfXZFDZ3KspA6yuDGR++xqRYlR0bThc1SH07ZQPM1tlntePjFhkaaO9JB4F1LbkMbrjXqemqbhCwmUt/4XFj+5CEhf5QOkn49rNZfs15Q2cekg2XBY3Vrgu8Akaxf4MHKTW11364vdaKI5hX0JCtF3jS9CWKMKtDpJRi6POS7K4r0OxeixlLXdV9VQpehVkThhIdwSplaU+puaqC19rjPGlw21D86EGmfhUljj0zPvMB6HVg2bwDiZkAnkqCJwe83wcVyXRdDF4HvBZ8161yyLnXJZQ9JCfrTB2F0lyGV9j5M1j5sQn37Zxi2TKdO3ZtzDll/jSW4xSgsZ3cm/odNtwhmjywk1OA7H9m57mhNXBhdBnd9RrI5f3AkbfyrP/VUPct0l4yYASDsas183ePiQ6POg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/7/26 7:50 PM, Yunhui Cui wrote:
> The PIN_LONGTERM_TEST helpers keep their state in global variables that
> are protected by pin_longterm_test_mutex when accessed from ioctl().
> However, gup_test_release() calls pin_longterm_test_stop() without
> holding that mutex.
> 
> This can race with PIN_LONGTERM_TEST_STOP and let two callers operate on
> the same pages array concurrently, corrupting the test state and possibly
> freeing it twice:

Let's add here that there are *no* such callers in the kernel, today.

> 
>  CPU 0                              CPU 1
>  -----                              -----
>  ioctl(PIN_LONGTERM_TEST_STOP)
>    mutex_lock(&pin_longterm_test_mutex)
>    pin_longterm_test_stop()
>      if (pin_longterm_test_pages)
>        kvfree(pin_longterm_test_pages)
> 
>                                     close()
>                                       gup_test_release()
>                                         pin_longterm_test_stop()
>                                           if (pin_longterm_test_pages)
>                                             kvfree(pin_longterm_test_pages)
> 
>      pin_longterm_test_pages = NULL
>    mutex_unlock(&pin_longterm_test_mutex)
> 
> Protect the release path with the same mutex so that stop and release
> cannot run pin_longterm_test_stop() concurrently.
> 
> Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
> Cc: stable@vger.kernel.org

umm, no, to "Cc: stable". This is the sort of thing that gives AI
a bad name. Specifically:

* Nothing in tree can possibly hit this race condition.

* This fix is purely static code analysis hygiene: correcting
  a theoretical problem that does not actually provide any
  sort of vulnerability fix in the kernel.

So claiming that the fix must go to stable is AI just making
overly grandiose claims, which I'm getting used to seeing lately,
but it still irritates.

> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> ---
>  mm/gup_test.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/gup_test.c b/mm/gup_test.c
> index 9dd48db897b95..d1c2b1014f0ef 100644
> --- a/mm/gup_test.c
> +++ b/mm/gup_test.c
> @@ -373,7 +373,9 @@ static long gup_test_ioctl(struct file *filep, unsigned int cmd,
>  
>  static int gup_test_release(struct inode *inode, struct file *file)
>  {
> +	mutex_lock(&pin_longterm_test_mutex);
>  	pin_longterm_test_stop();
> +	mutex_unlock(&pin_longterm_test_mutex);
>  
>  	return 0;
>  }

With "Cc: stable", removed, please feel free to add:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
-- 
John Hubbard


