Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 602E7FD4F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821006B0088; Tue, 10 Mar 2026 15:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6FC6B0089; Tue, 10 Mar 2026 15:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D99F6B008A; Tue, 10 Mar 2026 15:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD2D6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:08:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E12221C310
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:08:07 +0000 (UTC)
X-FDA: 84531088614.10.E3D0CF0
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010048.outbound.protection.outlook.com [52.101.193.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3502B160002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:08:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P2IWz91F;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773169685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYrBl1bENsvdRciuhKBgt++3MpS4gPzZIX60FL0P3YQ=;
	b=4X1T5sTvsr9c/4MHmPZk4yJS/0bqH64gg6pR7KMOclXg25R1KtVi+s4cSJsHpX6C4CpLWq
	mmRaQSrZQZWy9c75vwBG07lRGpwJVrGE0UhhcAdWNN0n7H8VKR4Mv6HIp0uqojDbLsLtAp
	RMxNg5PKSFi+PzU462/yTWPXyDnaFCY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773169685; a=rsa-sha256;
	cv=pass;
	b=DsRJfjdhTVyPqYJ0DXhiuoDRUQrfdXTIDheJ44ezeP9mnvIMJ3bJiYd9j8hOlM23a/P49F
	mXqMET9TntHSyKYAyoomF2zmTJIfxPq6FRImajRKFPdKqK+CzLW25lDzjvKlZybKDaPeyS
	AgyqKl4MD1m87HcCvFHdnk0OF59S5UE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P2IWz91F;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HtwlUvGjryUZH+vDK5wDwl3gdk1zm4eUYi5Va/KwxtesP4WnksGJTFkQKToLQSSCzcD2cV+dUhxpUvCmPb854eV43x7aHJC0V1DWMADO9AoyK4xrlVv6/cSoDVw/oaUoCevaAMnVYG0v3pRrx387tN49vB9kq0URaxC6Xw3AtDrJyLHwrz3y2Rp92StjlERP7ABujZf/xuQcyDnn/2BnEFX46x5wQOsyzg6WeDc5fvoCxPwps4nSCsvLVVVEOJhsWZFdPY32COZZATA5OFkXqAigvRqkhQmShA7hLq3qxGkiX4/M4/99YFJDUhDrAH6YJQVCXNhezt4gpGpJAWmnwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYrBl1bENsvdRciuhKBgt++3MpS4gPzZIX60FL0P3YQ=;
 b=WU4912bPwXJoi+kFa60E0M6mJuBzHNrqS78YYMl8lnR4arBviv5hLbTPsb39PpXzUo2XJr5uztqO3NX1oW4nuoN0Me9qGRKCwrepyUAAPdkb3yON3njBkQ0BSxke12bN5oBXQYARpa8YslBSRyNv1woDNdScJXC326+0T9itjNve7g4wn51JLmUSk6aHyAuw/aN16EagxXJHx1IEhVuXRV8GJVZlEU/N8zWpGd0ZDEajvWjE0KJ4zWRCI6k5sd/tK7mC499a0VNj9dA7dfXETspxD9ofRnR26BWZ8fgf0B0Tor5hS1dedfayvQx+zE5z0omzqYNtNHQ84nn5m1Eulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYrBl1bENsvdRciuhKBgt++3MpS4gPzZIX60FL0P3YQ=;
 b=P2IWz91FCSvfhR8B+tZZ3ehcOV3TCMRGvVckR65/7a/HTfidAuPRhGnRzV7ujfq79BrzwMekgbv//9qLI0gaFfmTu9YvSn90UNnJ92yZBjVCAkIJfvHMY8meJ4d0Pzg4nr+cZOcNhV+FJYwFEnsIfhtRevWd0UKsIImuQINCF2ULeaZWJJuLmXW/0I76VQ3gCbmcNylD7SPv9F+ygYfv0MHFh/NI2M9WQSzN+USo8G/ToqcfimWqwHZRHvM1FL3YvwIKbitXV+FLZt9XGEkhzY8BYO4iyx4BinhupQXVmsciIh26q3rG2VGiH0b61+BEAa5RQfpvt9pAvEqgKANmvQ==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by CH2PR12MB4152.namprd12.prod.outlook.com (2603:10b6:610:a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 19:08:00 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 19:08:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, Liam.Howlett@oracle.com
Subject: Re: [PATCH 09/13] selftests/mm: skip uffd-wp-mremap if UFFD
 write-protect is unsupported
Date: Tue, 10 Mar 2026 15:07:55 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <9CFCE71A-7BE4-47F6-8E5F-172079508878@nvidia.com>
In-Reply-To: <afbe6bf8ca508d810bc1c9d749483711edae9751.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
 <afbe6bf8ca508d810bc1c9d749483711edae9751.1773134177.git.sayalip@linux.ibm.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::30) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|CH2PR12MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dbf5237-ab2b-4ff9-85c4-08de7ed858c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	XtOb0g+nDw9YDEBzAEX/KEgvLvf7uGgr6rBwkyatobsOOL76+s4mcQJ88bEczql/ZL3YJ/1V1s1g2ijQtOwr7vN5+kR8lB/r3fDl/w9txLI6ToZIKqMA+qFRBUjjg32K41ZJep5GAOl2zzBoTVqVpIRVIJ74a+PUBLLx7J5Vr+yoVEUFjC71cwasa8r6FFSo+/NtdOdgI/hOokiknDPWDFEw9zhcBMr4nktZ45wJNaOxH+vJyPSeqwAhuXKUHg8RmtdcdDnuLcST57jUrXeD3BdCwUejdOKg8NDbSmmVGGft5fwN/QMX+7veGEfNleyRihrFGY5vhqp4ZKXmAdKUh0faapnWry1W7Ys+798vO3slCYKXO+cTPuPvDqE9cp+jXKhZ/8z6WoWDglrAQ+5HAMzjuG5oONhV6MrCr6OvJKAMw+YxwPinBneW6tCAlawbQtqMIY76CRAUjkQ8pq4Ywl1NzS9/Jhy3YKbPQWXISy68PnuQEgjT9aQ5r1qNuFPirCJYrELQv352TZj2r6pPiH2Z2ukC3NoOuNxQkhBlTdIbnxP8934I9g3vNBYapmPr1Mhlp5zxBjxJZHn8kw+Xk8lK+v5vXBbEEZytufGbvGG6ETxryWeBDth3+BIYNRLgywCh4Zw34cuVfR+BnVrjZ35+gv3prDQzIEv31+vErkObThke7ko2g4dJZGMhoo+kPyHOZXzSyGl5ggiDMnkfZmZkz2rS+r5GVGmAWoyia0w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Q9RAxEP4otEeflQl30Vv9x2qRir+cq5K0uTc5ZP9p7+txInUBkVzQgxPa3/?=
 =?us-ascii?Q?fA4hSiSHFS77klKNRsVzgRniUtLrkpY3PWAwlmgIbDRt+LdjtekxRnkRQ0lD?=
 =?us-ascii?Q?BRzi0wuM67XEylARXFTNOA0whsaRZIdNA4Lmp6oEDIdjKnmjX/WuNcQdLTZq?=
 =?us-ascii?Q?OMKNrjneyJDpvmqY7Yc1utMu2R7V6PyjLFouPLDBJorxOZ2F0fAkpVs8vgDn?=
 =?us-ascii?Q?UQjEQCzPePJ6qf1hkgqNpyvuSLp+O5oGmIu8txbTNuxK38xamTJfEXRVKr/3?=
 =?us-ascii?Q?VO2/fDu+OI8ZPlH29JVmV6RTWJnSPepPePMEkGfn4YnsZ1tAApHTIAgptrZX?=
 =?us-ascii?Q?XqtPLLWoS7qGCBKv3BW6doa6UR9Km9iIbL1XCF9i3f3gZlRcwQunaYqvqswM?=
 =?us-ascii?Q?Q7RhtauRbYabZ0Ql8yKDwyyGibm0VExxtBDAMgfjcC5D7s7UE+/16mSlAaIh?=
 =?us-ascii?Q?FubheCruU71kS/0LYI/MHr5nFrIVFhPSZMvilxlvqYznEuo0Ft06pG9Nmatq?=
 =?us-ascii?Q?NjnZNkxQKkpgcuqOTHQcdkyC6BMWeiekt3G8ni4rlc2hIlyJ944+HcbyJVcc?=
 =?us-ascii?Q?n0kMCB+GvTpme7YKrZ9B7JrRbZJphMcXcxkH17YxL2gGmQ16rxEj8NqFOGBI?=
 =?us-ascii?Q?quMkrTbYBZ3kv8+3KpOyyzcfXK7MKQ/OdmLQhcT5VCNDoDypYLb90l8FiUSK?=
 =?us-ascii?Q?6LmAvPPkWiASlOWC32jz8brqjLTPgbHBLG0u4myKzHOG8tCYw/60gCiZzoIz?=
 =?us-ascii?Q?TixAEXU9ntNRav0t6DLHNf9mt8Er2zW8WSokJO2ybBBUp1GFRwm2JQ9dk4ZR?=
 =?us-ascii?Q?9c8gquuBtnZ1esFEkHsrmu8zBpRGGg/ZR3NOmu0StUfjAbPOY4OfTNvFioKy?=
 =?us-ascii?Q?CbKpS11Y+mI0fiWXNiY72S9V4MPgACDbVH7wMmSUmmOFmNfquHY2kBeZptQw?=
 =?us-ascii?Q?GRd5PN/bj2vluL8m31c5oUVEY73ehS6N0gbryJus7gS7KP685rGJOj17c8iC?=
 =?us-ascii?Q?XJ1ynjmn3RTSy3eXe6cN1IoksZ1I3S9w6ybDgVwxa4MRsLQsbSe8UW/hOpGW?=
 =?us-ascii?Q?a6uWcGzhK0WxpxVrBx0EoyzH9uED3ua3I6liVfGAVbXel5juJyO52i8YYi4p?=
 =?us-ascii?Q?ZXiUR8V8wOZ4eU9k+b8OEEY/aK/27/A8g0PIOVxiTL4fMWGdzs/FqgPcIeET?=
 =?us-ascii?Q?I27qFtkYBzH15k4z3fTXKTviHz/Dv0NlvQvS57kMWuMlit6iyhw+T18IrJzR?=
 =?us-ascii?Q?MCP8rrm90gy+0Hua+Ehe9Mh2ViktEUnqcxHxIQKYJJxLElpwRxGX7xfDacHt?=
 =?us-ascii?Q?7zrKW1HG8fv4IzmCOfGPdgC+vA49zMYvn99neH2vh/x+FEkyfi+/sVY8q6Q7?=
 =?us-ascii?Q?TYtpDQ6MSGCo0fYHIRmwcE+aPF/xcFNUl2XSMmSBu4fpbsg5pSrMM+QVrq3h?=
 =?us-ascii?Q?7g7AEeUkhQlKgMLIfZGnISxR6D+1/VsSbU0PMzSosE6DUkUDQJovXYkNlZFk?=
 =?us-ascii?Q?kaco60GcXvkxjOjynrKBL7GfiKdNxEUOQQncVeAWa1kowCiO+XL9yyPq+JP7?=
 =?us-ascii?Q?zu53Z55JD3HxUjC6jd8c4mKAs1TLfe0C9vC9mVnaUy2I2EGuEpwMDLgR6PJ9?=
 =?us-ascii?Q?tTMFmeA2SGuq3RUjQVGWTxfdjP2ic3Api91Q0b7EcNWd4689GzPup/m9dZCl?=
 =?us-ascii?Q?byzrkWjl8nLHcRo3JN1D+Zna4i7/y2fcL6h+y48/akTVpd/nNcp0yzpSo9mF?=
 =?us-ascii?Q?yZiKeun7NQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dbf5237-ab2b-4ff9-85c4-08de7ed858c6
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 19:08:00.1687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rBvAE7j1hDGvIdpCcYA0tx2JakjW0inWOAx31lbUxvfT9kdXgTeL5GRAE/uoO/R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4152
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3502B160002
X-Stat-Signature: qn4uj3yw5q93jrpy5zxitjgeq5wfp8mc
X-Rspam-User: 
X-HE-Tag: 1773169685-204259
X-HE-Meta: U2FsdGVkX1+meqQTgQ/StI4ek/93zxyNst+k4rq5HTmgMnSHbk0Td8c7FJsMGDi34wkGStA1McBvYBfkdUelfcFmH7HrZ8M/wFL/uYhxYqWiDZYSB+Ymp0fD/4adofeE3GHwgIoFF1vEdJMyhf9PTNx2jXP7buvx3hUL4Du4G5K/qIYcAS7V8hVCvA6vTjl0/On07dyCPualyWHielVGl6zYpAcBPCTuherZ2jh+dtRqnscj0yPVxiVPrM7PyMnLHZg0reGdnUBFBApCtQmm0W1dLFL/nc2p2nIvDPUZ2ElrhH5IJcDP1KHb0KpJIfxMTOQq2aeyLmykVkbIcugJycmki8dJFS7MpGSvob9HcITfV8rp0xrGrvJ40GmrJApvwvURUoEpXan2yhqM8txsJ12nMxqfUNu1aj67KrHcHxqRoHgdwKGUSbqbMQ6dUr78/P+jwd2weE9ypLblMYFfVNrCkyuk8mExxJl22SfEjnD2LQI+NoG5s5qJCb2EZH5411M48LZxZIO54bX50Sjr8EP7hq1ZppmdW0EHfpktksPi3+i6MChiRIQkAuujRjbf8RnhHVKz5VQiWkLDBt2fgsfXIdSrDcdZFZ7cknrfqtKuw2Q+I14P6goLWr8fOYigSB1Jq9cPbpBeNJ4u2ekkSNPATW71rQ0AEzsA7pfYA9VCx6Y3mlkWPzGLyf89t+rq0agkHpQspcEKI3EeEMSqkPRLIPs8tQWQ8GPg2CXffk62+Lu+aWsw5tgziwfqqYCKjHdg1KzBubQ+FDguLJmAU140dmE7oZlP6fpsoh9bcSv5Ew8yEXRVA6amzaw3+DJx8kOx2RGovgpMd3Qz8q1Za2g+VPjY0WEm57C+VPbKEvu9/e7tAmvv9I9+uAfJLIRfiv3QZJ/E62imGtct3GYgOG1A9OMDCO1+uxV/AxID3e1Df9w1YgkuPOrULMUNms0cFAVEKvwHoc1/tPcJXOF
 RT1Czis4
 yJs9TAVA1DwYKgMGMFtkVIm/J/iaoW0R0ia5Mcl7QjjFhvvqnspeWVqewm6gR8esHaoxF7wE06AdPhTaf2mZ8iAS3YBnIq9T5px8iEEqD6InbUr+UFxm2vkGisiX08hoP6dATUMuNTqz96rNRPdS8mF+ZJwmklL+T5AqonFaENv/kDsjRXiecQPeIAcceyyLyvPDIIJtnxzsx7+/yd1UE4Y0RVUcI53TwLSeIU+BZy4208s72UCWn7MIZZ0Y+hrZFveGWzieK2UGJeLxsX/s5EEqhAQ5/AEVkYs9aDwrjKhG9lnMMDmzF+fezHl09mNOHXGdwe9zoybn8dQo1HutDdbe1WO2fLgDJ8nabOL9AtatHvfC5gvL40SVCTqJQD9onCBks0vAjpJPqpPh0s8FrIXeaci9IS954TsK4I2q4z+TIdZwuO9vhj48yGMbZw9LbzTIb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 5:49, Sayali Patil wrote:

> The uffd-wp-mremap test requires the UFFD_FEATURE_PAGEFAULT_FLAG_WP
> capability. On systems where userfaultfd write-protect is
> not supported, uffd_register() fails and the test reports failures.
>
> Check for the required feature at startup and skip the test when the
> UFFD_FEATURE_PAGEFAULT_FLAG_WP capability is not present,
> preventing false failures on unsupported configurations.
>
> Before patch:
>  running ./uffd-wp-mremap
>  ------------------------
>   [INFO] detected THP size: 256 KiB
>   [INFO] detected THP size: 512 KiB
>   [INFO] detected THP size: 1024 KiB
>   [INFO] detected THP size: 2048 KiB
>   [INFO] detected hugetlb page size: 2048 KiB
>   [INFO] detected hugetlb page size: 1048576 KiB
>  1..24
>   [RUN] test_one_folio(size=65536, private=false, swapout=false,
>   hugetlb=false)
>  not ok 1 uffd_register() failed
>   [RUN] test_one_folio(size=65536, private=true, swapout=false,
>   hugetlb=false)
>  not ok 2 uffd_register() failed
>   [RUN] test_one_folio(size=65536, private=false, swapout=true,
>   hugetlb=false)
>  not ok 3 uffd_register() failed
>   [RUN] test_one_folio(size=65536, private=true, swapout=true,
>   hugetlb=false)
>  not ok 4 uffd_register() failed
>   [RUN] test_one_folio(size=262144, private=false, swapout=false,
>   hugetlb=false)
>  not ok 5 uffd_register() failed
>   [RUN] test_one_folio(size=524288, private=false, swapout=false,
>   hugetlb=false)
>  not ok 6 uffd_register() failed
>  .
>  .
>  .
>  Bail out! 24 out of 24 tests failed
>   Totals: pass:0 fail:24 xfail:0 xpass:0 skip:0 error:0
>  [FAIL]
> not ok 1 uffd-wp-mremap # exit=1
>
> After patch:
>  running ./uffd-wp-mremap
>  ------------------------
>  1..0 # SKIP uffd-wp feature not supported
>  [SKIP]
> ok 1 uffd-wp-mremap # SKIP
>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/uffd-wp-mremap.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

