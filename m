Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93D5606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=byWX0jAh
Received: by kanga.kvack.org (Postfix)
	id 892616B0644; Thu, 12 Nov 2026 22:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A4B6B0647; Thu, 12 Nov 2026 22:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AD36B0652; Thu, 12 Nov 2026 22:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA5C6B0644
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:23:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0DD31C23C7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:23:49 +0000 (UTC)
X-FDA: 85428651378.19.2B9780A
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010003.outbound.protection.outlook.com [52.101.85.3])
	by imf22.hostedemail.com (Postfix) with ESMTP id D43E4C0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:23:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=byWX0jAh;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68o9g584xkn2oa7671GxsnuHQqyteC9n1uJT2DR6q7U=;
	b=mQUNDSsKAwv2w9b9UOtM9JX2ub8PyYAkKeV+KkEzfrM+ZTwUyZ5JnvxO9LbkX+m5r3eVeA
	vVgCF4EmFr/BjDTp2OhLaE0Z9dkoMiJr4yh3AplbN4ceCg3BVR8tdliGnuMUq5tEZ+kwKs
	DW217bZrr5VJWUuDa10gqgrC8D+6U1g=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794540227;
	b=ce5YfigJgLibqLvwndBy+EIZslKBs1IkohLgrOsgC91onn/tZgj45ijEh3v8DAJRMZO7N5
	f/jZ17R76usKmbCyW4BpefvM5rfeXlmKcJ8Gs36XcG/9onPUC76ocQ3YJF7zk4FUSo+BUb
	TKDyjMN0rd8kLr/7HBu/duVQ9ltKqcw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=byWX0jAh;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hCoUZWUkWSsvddwKcVpeR4DP/aRUCNtfWhi2rI9gCDXICUlDAcZKFYbEB9CdjN6E+YkQYDwhCMcICHSwAh6B9CdVTmP9xyEn04+xNRrgTpfMk7KCNLVdd5lhfQx2T9OZWiET0vrXIlJyf0Sb3UTW+x3Ozlu1KbJu5u3ROiaVQdQvGdCXxolXafdelKVKpfE/a7aYuHvLixVphHvZ4eCEmLm8Q1xoxAoo15VDms4I1DrU5aV2T9DGaixcdqC+jsfLod0tse6EQmT/KgUppT71Xj9AXngfbGADGq/qUXn32LlENAd8y/TbM5MrmXcAU56mjLgCn/givc2+9vh7ug5anw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68o9g584xkn2oa7671GxsnuHQqyteC9n1uJT2DR6q7U=;
 b=XyiLUbZyJwGs95Fy74aGnkr/MeWQ1YM6jJU5zf+4acd1+9UlKA+sqGwylmVeIgNKf93vY/pCq+mhHtEx707MFxvDu45ZSginXVNn8vgGgQshFz8dge6UNZ4A5NYT4qmQBiz8xuqVMpoflrOdtFONrjiqDfNgNjBnQXkEdDkVwIB0Jp9ZjKnQG3/7K5Xv/O1CBDKZfjWgHH6VKWp2LpxKPfTE4PDVscEAdGwAX32e7mMIttHOu/X3Qn28wfG2s/vWQ0fC/Abp2stb3nco/14DXUNdqW76cpqIaM0XnroDHQm1Brf8Xz5Xltg0uXIlUc3ojOhKUOKuIsgm4uGxqSE/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68o9g584xkn2oa7671GxsnuHQqyteC9n1uJT2DR6q7U=;
 b=byWX0jAhoIwT9VYuHGOc/vOtsyPDs3zD6MbORA3iNac/DZNV8SJokFjSW/K9JzLy28AY7G90YH3N52IuV0fboIFr5MTCdUzqt2ET1sOds7heMSO1KwwLBWzTYg3GeN1XJbLZC1PxOqYh+Ob6sS0cH/0igCuzAiES+hFc+AIdxnoaKmcCm7Mp4vFmeHBAwWXwThX69zFK7Ji2XEyrB23uTTeJQg2RiWVdMK6hrwBq2OJhuWmMZuEgWO2ksEY0tgdzsBXrt8MrIvX21PIEpz/kP5VVk6PveaIQ6w5Hx2CMCySSYeK/oRKYK23w8cHmBbGBjdbOlYqVcw9BXNqg9eMxtA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA4PR12MB928846.namprd12.prod.outlook.com (2603:10b6:207:12d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 13 Nov
 2026 03:17:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 03:17:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Alistair Popple <apopple@nvidia.com>,
 Xin Hao <xhao@linux.alibaba.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Yuan Zhong <zhongyuan@hygon.cn>, Shifei Ge <geshifei@hygon.cn>,
 Jianyong Wu <wujianyong@hygon.cn>, Shijie Huang <huangsj@hygon.cn>,
 Yibin Liu <liuyibin@hygon.cn>, Fengyu Wang <wangfengyu@hygon.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
Date: Thu, 12 Nov 2026 22:17:13 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <1BC0AD09-DDF0-4BA1-B959-4F88C25EA144@nvidia.com>
In-Reply-To: <20261112010357.2739389-1-qiuzhiteng@hygon.cn>
References: <20261112010357.2739389-1-qiuzhiteng@hygon.cn>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:32b::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA4PR12MB928846:EE_
X-MS-Office365-Filtering-Correlation-Id: facde21a-12e0-4ac6-0e69-08df41349ef6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|23010399003|1800799024|376014|18002099003|22082099003|10067099003|56012099006|261026140227099003|261102123227099003|261022113327099003|5023799004|11063799006|261021121427099003|261028144727099003|261022105027099003|261026121527099003|261021123027099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	wg7kxRBro/okuy3A8XZ/itL+JAYUgpNyT++obXNSKt0d7+xpxdBFAwmZioFsuCa5LQI6waN3j0fZhm5XWgKOYoA/PJiT4HuO82Q7HGQ7g5rOg39hj3YnzQtORkiF65s5r614/F9r9VeGfBsqP8bztWXY0yOxeEfKmAYFoLHW+NnSeDgS9SptSLAihoiwgH3kAkh3xxpXy+gVRpvqSOzuTn/u2pAvUsGZh7FwiSgqpHvq2AO1n5aIttmGTAKtjYZxcZEVz88jSpXRFmSQI8rcEMydFO/WvRso03fFGjtevcMf+IUWp3B1GaI5X4Uwe4bmhD51QEs/IGKAlP3Ky6Rs0lvCKIcXliQJHEtIbJOcDrajzo1fEon2ruC+ssUdN3mT5GopBnwmbCIvfEBUOAPWss7gkpyng2r2q/r6E1BMODND4sx4k2d+i9osjR3vGVciAYnpGS+ME8QR51A6/LvCVJSAN3eboinXo4mcxYauRpvsrntbzTrzK1fgjd2dJiuhugiijRvIUuTLP75uTVNC4zvmUY5TgTciKUWYIz7dmn8EwwTZqoVyYQhynzE4zn/4XG2vlxPfA36KUjybXz7riZxHWjS1XXtTYcwIb7Z8C3jLNN1Wi0xRVrXu9M3nYoWOb5SDVn6FB2LiIhDlXEDbQuAFucVRxyFWeYJn6lSOL7A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(10067099003)(56012099006)(261026140227099003)(261102123227099003)(261022113327099003)(5023799004)(11063799006)(261021121427099003)(261028144727099003)(261022105027099003)(261026121527099003)(261021123027099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kKK4Gg+sq8zGMZWWv3r6Z0YTsprPDl6x2eip90lU2aqUBN+9hzTfz9Okc+45?=
 =?us-ascii?Q?o6t2pbabzW3z7Ojdb6kIBcezdeG7Ose0dUUzbPNISQ116FdsrqzQMSqG7bLs?=
 =?us-ascii?Q?vK8xg7QYccMBU0IBtreXmdDNUojjuXrKKYm/hcmkjG6CMNzxujMBLNrXhRdR?=
 =?us-ascii?Q?JlMZqvBAz9286EkpO5BHCRpuR/8OcaM5E/HNquUs0uQiMWSoIAwuc1VkD0Co?=
 =?us-ascii?Q?J8bbvYMif96ZZgC2+3tenFXoBwNk9r4xJUZDAMK+vcggYG0lBbTe5S/Q+eo3?=
 =?us-ascii?Q?GZD6aBA60MCSKkVBLK7nKbh5mzFiogTD8nZ1R9OElCQpAOaFu7Vix12nNaQS?=
 =?us-ascii?Q?Gka4XQtxcFcolnP+nlF5DtiYfDa5raxoIlUMu8ac+I/JEtKnybvLudqsPMAI?=
 =?us-ascii?Q?4fKwD2bdK9MRgp0gH1zjLxcn9/KXly25rc5YtaGiwjwPYcgKUmxv2lXh4W/p?=
 =?us-ascii?Q?pF3Qmp5QIUaFNzgkfWb2kCfaq0OM4DdJxekmt3qYSla1YPN0X/lVQ/mkoShd?=
 =?us-ascii?Q?HflgBey3q/drP2AEHsLiXGwQopW4GlUI9CYI687OKWf8xLnPjjL6vDfLYFG5?=
 =?us-ascii?Q?P5OiwMsScJHlWEG/850LT4tpyfI6zc6lYo3KI31zsbcqgsZfmUs/EQJi13xF?=
 =?us-ascii?Q?i+qNHauRUKVBKDw/JDeFbObxM43p3NUpOi/CmrbgJ2EMtIe08xcMiRPtmH9j?=
 =?us-ascii?Q?IS60+3kM6drMUS4q+fJA/WX10lcgw78T3Qk6QKppP2OGSlZwfjxNcHAQS5RM?=
 =?us-ascii?Q?IULND8pMbVzdgKJgDycI/HrD+/UhN5Tnl/l1F6KyGXUJgjmwnWg1v++Uwhkx?=
 =?us-ascii?Q?yBHIxSPwTFrM0VFyDZ7vRlRUJ8f7psMlT4p2xKrFHJn+0ZLJECyZGCZx1RPu?=
 =?us-ascii?Q?lZ62z4H/TxNEBK9WMzbJvhaU4h9tqazJTiK6bpJbrBDPK0b64v7YvE6VhUUH?=
 =?us-ascii?Q?50TJchbozdgsgX6kooTeQmclUIkFnrdVLMGTYzexBnUcU+s0CCtreBLdg5R3?=
 =?us-ascii?Q?NpZNJMSSiwBWiTp7AS/igszu/zIwzsQ/14HMuki4QU0bncX14aYgsjZpJfdJ?=
 =?us-ascii?Q?5XA1xXXatPIXeyQlUzoQqJmvZNEmnyee22xW6/jYKifzyU4z4jwe6NvmkYOk?=
 =?us-ascii?Q?ekaPrYc4+V3dilKuh5YtDNisbe4+ztjJW+BhMDuZk4phkBK8cxE/XkrM9EwV?=
 =?us-ascii?Q?ElDeeqC6XfoNhUJbJbnvl15aKcB/jHg+UrPtrW9/wP4tE+1qANVxwfkPey8N?=
 =?us-ascii?Q?2HIBOgTF483ItYp0cZQ2SZ+ve2pXuAsK4y9fJI4VnaByImIjc+4/EK1AiS6d?=
 =?us-ascii?Q?2BfgyKVAGkTHuY4ynKN3t6hH/QqqtrRi90SXuX0hncodCC2NHKm1TufJIlzr?=
 =?us-ascii?Q?EWfZT/R39EzPfoz2IuuBtFpbkxHGVkI3M9/rqqRqVVIHSIHwjoOj4ACN0XbN?=
 =?us-ascii?Q?bjtl5A9Zdvru8jI4Wg6U+X1Y3Db2AXL486JbmrUQkuYNclwkWifrpKjBKwYR?=
 =?us-ascii?Q?AirejiEWHdZI2RxtDXGu+jrqV5DlCagRrhapMPAFzuvZRvrwr8+XHX05ds8T?=
 =?us-ascii?Q?liGTSAn7pfpAFH8lF46IWP/FC6NyFUU+0XdNj9tSzlXIz8XyabPONRPcunn/?=
 =?us-ascii?Q?Mcr5YNMqeRYljuBdBlXl1u+aexQ5osfbWr7ErllnsO15OvdbQFjubKDPRncU?=
 =?us-ascii?Q?fG04t2phG/v71gmKyf4qi7SptCJSYHA7TXyRHoS4vwrqAFTh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: facde21a-12e0-4ac6-0e69-08df41349ef6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 03:17:17.1976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kN25E6prTOArXwcYDM1XtJpTUYRT16wEwR2TKqGyNSAFY+Y6iGWWBPNQGSPFO4Cr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB928846
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kzjyattmnwxo34ftf1wqtjg1zxbwto3n
X-Rspamd-Queue-Id: D43E4C0003
X-Rspam-User: 
X-HE-Tag: 1794540226-973963
X-HE-Meta: U2FsdGVkX19L2zGQ0tcLdcVovRAR/VTvBc7afaBXI0PFC1oAaqXtQG1tCrz6wsSOUQudtgS1bBIXx2xmLa//LhEHuJXQt6qKyA3YQVLwa0wF/QA4aG6QaV9YLwvJfJiTkWaO/6huMEL/yGjyJoWHgWhewXIbpb1wAlUXSecT4SDhu90lnRwnfYM08UoCbxyYBaZZtfBkpJg0TZNGZiSY/QPo//rUyECzVnteq3B14srPRQ40DqzMC2iwNYMegzHG3GnLflUJfLn0Q251W33jkAnXhOSjLPTOz5YKplyj4zdEl0paPDvWwCzZI7FyM3/rJr+PBtFebfuGxeVvSF8zHXOUpGZ6GNOE+MfcsNdEaKczBqfxU+wU4Vho9JuWpM/HLXlJRB5PHxQWEl0EnbH6rDXDKALBE2g+xs52CD4c3y53JM9sy6EqHRXfRgS+Qqv9hhOgtkkEBNAeM0jptyUI1x3nVU8cGJgvUMVjVddgwedpBFAQZNMzFNobj/HuGNkEeuDgWxoir0JbkPc/0f6oPwhLzepe/2PWG+Ug9vBTtFeeATuXxsN6WcYpoVRviFmIFMLQTzCupkVipGNGeGRY9laJdSjJ/idkJMD0Q0aUAx82PtKvjKOHha9TPiMvdU+DRALYbspHztZfHGTyWIvo2t29obQxjKxnCWRUNCt46gFyGGhSzCjtK3K/bWsGMv61tX2Bt+2balnHgFS5jiyROfEH2YIalFz/r2E6z/bpqhCpvFdae0tKbzZ8x/ZDzToXLrqjF2YUiWxW6lUjRKGV1rL1R8OSTMLG//jpXUH0v6a0qrC8RCUgE2rSGRKYKYEGSjoJEGi+v9i4UJO0mjfS1wC0BNkt+lCMXeqobJy9WqKEXzfvGymkmg4NnPUxJxKzwYjjote8zbzYZtWwzMNqYIosy+vsgehDVWhW3R24TY4+2rDSVpxTGstA6qm7vafGB4Z9EODMbW8l97I9qsQ
 ttaWfYVL
 5DBFRvEGd8M81c/IyiyEyynthVxfyxm3C144hj2VXp9upBjkZ9mhUZJD1xU6ZwfhG8d+LOU/6vQ8ENT87Ix0YN/Ore/O2kpGYQD/2eEyzChT2ZgduwcDqZZKwPJWV8cVQktOHeM8//xjFfmqKKWHG2Lv/t13ddPhbQjM9hSrbjhLmA67sPpQCB5uDbT7SIn5KJy0jaNquX1Dg0oR1c/r23tD7OJsC/wqRy4R0Eynbvss8V2DYNI/+kVUSkflACuFsifFWXMKCLUCD2Nvx9Q1UnQ07FjJ7+Gmyl1U73de4Q17D6khkLnpDiF5jWw7Y7hBQmSc305IZu613hQ35StzbWdRC4CSVhjPeFmVezc06JlBNBsfOs4kQK7BH+0zpOmLj9YbVtBYpgiexMgsdghYfx1cGom2AKzWbLb80AsS0CIn94e44CYeaA2NYufG3UitZVSCREYtxLrqTi7EsYYwKDY3+IOxAKv8a7WLOey3E5/0pUQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11 Nov 2026, at 20:03, Zhiteng Qiu wrote:

> NUMA balancing migrates one folio at a time, but since commit
> 7e12beb8ca2a ("migrate_pages: batch flushing TLB") it still unmaps
> with TTU_BATCH_FLUSH like any other MIGRATE_ASYNC migration.  When the
> batch contains one small folio mapped only once, there is nothing to
> batch, and the batched unmap can leave mm->tlb_flush_batched pending,
> so the NUMA scanner's next change_pte_range() can call flush_tlb_mm()
> before changing the PTE table.  With migrations running concurrently,
> that state keeps being refilled, and on this workload the scanner
> often flushes the whole mm as it walks the PTE tables.
>
> This slows scanning and keeps mm->tlb_flush_pending raised longer.  On
> x86, a migration that unmaps a PROT_NONE PTE while
> mm->tlb_flush_pending is set gets true from pte_accessible() and needs
> a flush too; with batching, the resulting arch_tlbbatch_flush() is a
> full flush.  The two feed each other.  In one run, 33% of the
> migrations overlapped a scan pass, although passes covered only 9% of
> the time.
>
> On a 2-socket, 384-CPU x86 machine without INVLPGB, with v7.3, a
> 120 GiB anonymous working set on 4 KiB pages and 384 threads (three
> balancing on/off pairs per kernel):
>
>                                      v7.3          patched
>   throughput loss from balancing     13.0-16.5%    0.5-6.3%
>   TLB interrupts per migrated page   202-210       12.7-13.6
>   average scanner mmu_gather time    ~90 ms        ~6.7 ms
>
> The mmu_gather times were measured in separate instrumented runs.
>
> So don't ask for a batched flush when the batch holds a single small
> folio that is not mapped shared; try_to_migrate_one() then uses
> ptep_clear_flush() for each PTE it encounters.  Large folios retain
> their existing flush behavior.  migrate_pages_batch() computes the
> flags, since it knows how many folios it is migrating.  PMD-mapped
> THPs are not affected, since set_pmd_migration_entry() flushes them
> regardless of TTU_BATCH_FLUSH.
>
> Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
> ---
> Changes in v4:
>  - Compute the try_to_migrate() flags in migrate_pages_batch() with a
>    helper and pass them to migrate_folio_unmap() instead of a bool, as
>    suggested by David.
>  - Go back to v2's check, limited to small folios, using
>    folio_maybe_mapped_shared() as Zi suggested.  folio_mapcount() would
>    stop being a good hint for large folios once try_to_unmap() batches
>    them better (David).
>  - Shorter comment (Zi).
>
> Changes in v3:
>  - Use folio_mapcount() for the check, as Ying suggested.
>  - Cut the changelog down.
>
> Changes in v2:
>  - Pass the try_to_migrate() flags directly and use single_folio in
>    the VM_WARN_ON_ONCE(), as suggested by Ying.
>  - Rewrote the changelog after looking into why b99a342d4f11 does not
>    avoid the flush here.
>
> v3: https://lore.kernel.org/r/20261109122915.2150586-1-qiuzhiteng@hygon.cn
> v2: https://lore.kernel.org/r/20261107143456.1590658-1-qiuzhiteng@hygon.cn
> v1: https://lore.kernel.org/r/20261106041628.1177963-1-qiuzhiteng@hygon.cn
>
> The table was measured on v7.3 with the same check as v4.  On mm-new
> with v4, three balancing on/off pairs gave a 1.9-2.9% loss and
> 13.2-14.6 TLB interrupts per migrated page.
>
> I re-ran the tests on v4: mm/migration selftests 6/6, LTP move_pages
> and migrate_pages 14/14, 30 minutes with compaction forced every 30 s,
> and 4.5 hours of NUMA balancing racing with fork(), MADV_DONTNEED and
> move_pages(), 4 of them on a CONFIG_DEBUG_VM kernel, all without
> warnings.  Splitting partially mapped 2 MiB THPs during NUMA migration
> still gets the batched flush (0.115-0.120 TLB interrupts per migrated
> page), and 64 KiB mTHP and a MAP_SHARED mapping shared by two processes
> behave like base.
>
> No Fixes: tag, as this is a performance trade-off that has been there
> since v6.3 and nobody has reported it as a regression.  Happy to add
> one if you think it should have one.
>
>  mm/migrate.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

