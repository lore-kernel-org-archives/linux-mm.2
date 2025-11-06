Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F547CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79AF78E000A; Thu,  6 Nov 2025 11:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772458E0002; Thu,  6 Nov 2025 11:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A3A8E000A; Thu,  6 Nov 2025 11:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC858E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:35:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6439C01B1
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:35:15 +0000 (UTC)
X-FDA: 84080732190.28.8AD70C1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B65780008
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:35:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eJVbzDjB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dpuk3I3i;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762446912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3n/ztQZBvp+bhZuNYtXx/8RKlVaLWFEGz3JyFa0TW4=;
	b=qT0BgARw+zWYkORNnjVVQwWEGKO2oAT2Im5DFz0DBBrKF673bfTNdL8rr0/mRvODHDy0tk
	r3rtRBYlXkK2np8GNe6WJAMCQEucVRNEbpKsLQAAzvhm0cmPya5W2z3x8F0FsYj1quHuBw
	g7YrD24Ne4+gTICzpsCRlecyinE9UzY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eJVbzDjB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dpuk3I3i;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762446912; a=rsa-sha256;
	cv=pass;
	b=zqkBbOqcSZXBOQS0j7Ou6DBi4y3CU6GaUxiaZ/p8FEk4Y5++jOziyP37HcPA75P3Iptl6E
	h7Ql86CcOJD98NzTR2+WPUUmIbYrMRxWWq0ari33Qw4MMYH+1FyrYuUxJQxYwBtmAjChVr
	JvEwPotJLav3hYoZZmQbJdMy5+EeWj8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6B9TSt000639;
	Thu, 6 Nov 2025 16:35:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+3n/ztQZBvp+bhZuNY
	tXx/8RKlVaLWFEGz3JyFa0TW4=; b=eJVbzDjBNdecrF4mskUfqavO7iCvJ8d6Uw
	4miOxISWHVtXoWG1VaRMH/cGUbO3Z7JiHD4gjJ3cdB/DPHtNj+oy3gVST5TXGvL4
	8Xl1Z/8BFN8pSaQBp2Z+KKKouoeXEG9ykPu0Ixue8QV57Q3YGAFLmrnCP3tNJjUj
	PKvSsNP80ohCvZOzC1cU5SSDEDQmxvJE6ULweW9lZsi/nI21XKVG2544AKfqcfGj
	HpltFK0EkYiShXeLP7VQFxi0c9sKyPAYM4OcUZQvhYHNSAccDy1UeNS5vA6v1Jtc
	Zdb1PiV9pXYcbwQKjxykbzIUsfZyMmXLfI51HkQxMKjv8pldE9hg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8at92e3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:35:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6Fud7a023183;
	Thu, 6 Nov 2025 16:35:00 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013049.outbound.protection.outlook.com [40.107.201.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ng6bvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:35:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bTafx+5zCfG0qjBuO2RMWjaKi4izZZ2hF9EZvy4B36ylXcrsMt+3Bvqsy+r0rVjW6Wdrv8NF/9niWT73wMEvgMPO+Stey4yxpDqMFEtLN4UmR6EzMqqyWTC79oGy94OvXmnKIJqWNC0q36Je93bBAiBLI2cYOJ3bojYlVeDhEle69IKRkx15axH2bE48sPxmWLZiS5N8nn4ZDISCk098ir8GJV4maNdr3Fs+MnJK78zCDtEmTcmTlr2H/22ztLMCYeI6OeKBL0ywh1wfyrzbOFjk0uo2qYg25QDNIcfgAAUrFMlW+iCfvEx3sJDR0bAR6Z85eBaz77wtu0rbi617kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3n/ztQZBvp+bhZuNYtXx/8RKlVaLWFEGz3JyFa0TW4=;
 b=xn6IDeslz0abpCS9HI6ggQcKw7z6rgfXel95bYYRb7bfCZzb7C5zJD4e210oENaD3EM76HkKCXIBO9j3/v8sS8xqGK25dVp6Mdm2fiPAu8rBK8oo7SsjuExImDCltiZtAlXiw8vYqN5swyMerydzGCP7deslZCYfmioNkC31iavQBUJZkMl03Ka0dqWgXrc+tOTyuhbdd/DL4tKVxjHBTaJlPbIVHamh4Ki1XolP1Z6Q7JVe+qtRXb4A5bWigVyGIMJ8DaBwXSEmrcWwkvbrNxMWPjHrlFUOs49bULY9wqu/n0WD9I7F4T6XexPWTyQuzFH7te0qgcE95FDVpKZfzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3n/ztQZBvp+bhZuNYtXx/8RKlVaLWFEGz3JyFa0TW4=;
 b=dpuk3I3iznT3ZpPv3GimLWkfTNrBwuOUDXJAdwVeSzmwPNyu/Kdc8bzgUtBFbRjU16eDL4WoEWZRfqRJ0vHoj1oiWVQXt8Iv2l3dJ6b1FlLKNH8DoD4xYTpZgvXwTxGE0tqdQEchh9ezKAa2lcurdJq8CgwqroB4WyMGmQEMUDI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7701.namprd10.prod.outlook.com (2603:10b6:610:1a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 16:34:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 16:34:55 +0000
Date: Thu, 6 Nov 2025 11:34:52 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: kill mm_wr_locked from unmap_vmas() and
 unmap_single_vma()
Message-ID: <xuyrhqdyceyhcdwecgb5zghgyolorewskx5yxxeqjhs2cpeziu@s7llff42vxai>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
References: <20251104085709.2688433-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104085709.2688433-1-wangkefeng.wang@huawei.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YQBPR0101CA0266.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::31) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 14a386ec-4ba3-4006-f3a9-08de1d526b0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wRKnkzz/DEPhha6OSc+HDDae3d417yu3xqjSj+UMDks3aRhw7VNkKwha9auH?=
 =?us-ascii?Q?YunopK0orFldYLdpahJDExl1RgeznbKy8mZn9anZPC+ZbNT4HESU02zLe9pV?=
 =?us-ascii?Q?M92PPw8Ml/so9mLTgMQJA6e4f0jgKaobS2LWg4MxKTNZmj5rkEB/ULKDdjps?=
 =?us-ascii?Q?CpPuLe6NDDZvDZUfW+MGZXp41syEdfiMVei7PsGOzetitYrHgxX3Rw7eeKey?=
 =?us-ascii?Q?Iu+eP9p2wt6RCWocx+MvOJJI9kuKrxPzI4IXKOTUpGvj+/y6RURdV8N3Wb2O?=
 =?us-ascii?Q?iKiqQ+Qwlgobu637gsO/fb4/5gxAf+0klQ+hcTDbto0EdooOVT3XBP1aO4As?=
 =?us-ascii?Q?a/vc0IAPPg9buiPvqOKIPQ6YUvw6EmJGEIg1a632gmcxb2LNEnstH/BLrbEn?=
 =?us-ascii?Q?a/1Y9A4zcrXfqcTPlwtikR+eWUvuFe9ZE6K2nly4eFN2qmOJ3Inlc0Ps6qep?=
 =?us-ascii?Q?w/UFHpppu0QY4LuT0QvAtMNxIsPq9b13UKWORMng9ToKGvqdbniS2w1BU4GX?=
 =?us-ascii?Q?3HATmkSTwTbcZuFJcRC7z5eVIoPNl+fFBZIJMInZb644JBb7nV/6nw4Rh9T4?=
 =?us-ascii?Q?clucI/LRs/KXZFBsezpXGuh0AiqMC4bToAV75QmQjYspl+ybIFtUxaStSus5?=
 =?us-ascii?Q?OxAxS9fQlpBlfyE4z8bMYMTYUZRnQkBuA5rC8ma8pFInM6KCq8IBQ86djRj2?=
 =?us-ascii?Q?ZZ6U4BflngTvXZQuvULiA/1JdO3ZCKlNCSz7GLP9Vwfhs/XEi6dIba4HFsKR?=
 =?us-ascii?Q?ZKMcFlSvjQ9ln5xDxJKaZmq27f7BLeRgpm7O7GykpVYjQqppgMknCUFlduV4?=
 =?us-ascii?Q?Or6AW+jRic5T8IXNP+qEDLXfCTMZQLzLlwKhsUrAdxR1FL/U2nM9yF8YxafH?=
 =?us-ascii?Q?3vchT9K08scrZloMlxccI0qKO4bP4FWXZO3/y/73Wigu/h5NqI7wor717udA?=
 =?us-ascii?Q?rmp5FRnGTpmIHr9wCbrZGxSipWWnpg85nSVqLimGQGo1BZQHiShQ0IcxRGn2?=
 =?us-ascii?Q?LPnIRYdLugP4E39+Z2VlqKkU1RNEdTzQglDiu57poYmpMo2wiMQDZpURCWoX?=
 =?us-ascii?Q?IYLVGIjxG4CYhTZigx8hlI6ZiCl4EUCWl7grXcIkugmWB4MD5QeLKpnH5Mjy?=
 =?us-ascii?Q?fW3lhOWRNZtgRHkWOb0cn2mUxL+WF27coVJ95MDoNh5OwpJ+Wx6iPFgUJOnp?=
 =?us-ascii?Q?aXYJzh4ZpyaWP0r/VM3vEJR/74+/JificpW3vmOAB2OWOPAHS4jTPTyojJVn?=
 =?us-ascii?Q?RhHLhrKvDutZ/mRyHan9gJgoIi8/kLLF08ZVZl67WEeCrfqDCN2C/mloWHAS?=
 =?us-ascii?Q?BthBbHfhtgf0olmtg+pp9G63dZO1KnnGspAj5kk6vQabujvWr5KOvfI1LllH?=
 =?us-ascii?Q?1Y/VmAxB659YtCuC8wI+iOSPmNvpepBDBE8+KCdIqKlPbC7vsg35b9xJA2OE?=
 =?us-ascii?Q?eFkGvs2wpTS8iidqS1lGT/yVedoGYqIF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wcKjtyxriTkzj0gnPIvhd2HPMFbQlBhAktA83qEcXX5SuG8OTcK6JhAtU1h4?=
 =?us-ascii?Q?pM+S4GCD3vPOxKpExsHFxScvFg7bHhQiNQvkJLxBlJq4tSOoaouma/Vf1S4+?=
 =?us-ascii?Q?iVV3pVsnrPrfywT+seGVZ+vH14+c/VOR+L0JiWxyd4sK0wAyfpx/u7KL4bBw?=
 =?us-ascii?Q?bRS7S2/hpJDoPzUUWQbroBqG1Xz/AENdrEOo/+s+pSZ5LVcapYgiFevsc0D9?=
 =?us-ascii?Q?rDwTBuftsVtFm9Ugx/h3PqHiP6cNXZrcXJqVY45/fbtuzHIYrRkaOvYUIYuP?=
 =?us-ascii?Q?Xf94Ezut/0lSo+eiIZ79mkJdvdHr3CU5TYC2CQD4lxcY5bdRoKlZs7WcpuSA?=
 =?us-ascii?Q?bNUXhBxNs2t7UiJFVt6dBfp6Y7yJnYPIT5b+kQBkhfp7Lb2y4TYfq4wnGPFc?=
 =?us-ascii?Q?9KDfyaSEsfB+GCq9JjLanRm/os0fTMh0xyikVJokEKIrFEbhijFlInvuC+yz?=
 =?us-ascii?Q?Z7JkoK9rVAphUYHtaB9d0/iuYmTXI48e5934I6MZMlLwfN23l6dhlNtGZtVT?=
 =?us-ascii?Q?pdxvAG7JvlTavi4FZdy5ZhoDOFQ+VHq4f2AEVqd0xSCSnD9dpeZJiF4MXTsb?=
 =?us-ascii?Q?r13wNMSV6l01XS8X5TYmwy1OXoxsrqivCIEB0a5VJiH6qsuvdmN9PyGFn+ij?=
 =?us-ascii?Q?EU95p26LRYgfaax8uSTLcahLc+7yc4+H8KLEglK4YQfH46PRYto1BtVnqVxk?=
 =?us-ascii?Q?xlCX/Yz/mquYgi+lP46/YtcaBPiOxcVS26ef1Bva9x5C0rQdb/NG0YNeIEtp?=
 =?us-ascii?Q?aa/Ta5U/8IaTjizrcw2kiD+5Td/qowNii16VbV5TpLmj6JDe+KneeJSkAkWL?=
 =?us-ascii?Q?zAIpkW+moumxyvW+bWP62hDvtE48eUQzAKhf3c+CK1sWBOk4YMogVr+Lutje?=
 =?us-ascii?Q?57aSKl9tt1czopF8CGWR/CNcwdG8KD7FnB/Z4Khjm3yx5o/R+9n68j5HTt3p?=
 =?us-ascii?Q?m9b8XIz9XnDt9ZQJ7665MG2/dlPMjTuZjuK6Qhty831dlxZl3arAveuD79Bl?=
 =?us-ascii?Q?qAG2++X9d3cUW/+QMzpE1rFGxtQYVXmPzpRQMgLZF1HZGOy2sEnutEMhbrY/?=
 =?us-ascii?Q?190fXBZ2c6B3CNFTKmGYy36ha48a6VRJmZydDYPVKS/mAujxnXZjsI7+nSBy?=
 =?us-ascii?Q?sDJtG2RNN5jkAyQ/duBpUKgn3oXuJB3T2nlIb7/voYbxAu60dpz3OsQmypCx?=
 =?us-ascii?Q?P5vVH9+P7G+oDTS3LV2EWqcyY0o5fv1gBJU5esQNQoIU+TSZMR8cxBtpBRYG?=
 =?us-ascii?Q?D4z0XPD/sj+/DF9xQVhPwlydMlMyKv6ua9ucrIr7gJrlL33nyBIO2E0oE3Q4?=
 =?us-ascii?Q?c2jcOa00SmCIhRe9AJHWo6IDHUrrhrmFWSPjT54OSoXQPXu1fCsdU3SmH0RO?=
 =?us-ascii?Q?7iaOOAZ4VBqichClbLIG3rJ9u6n48XfuIMCP2fmljn+jWncNj5kIXWt0VfRw?=
 =?us-ascii?Q?+MgcsPNITAjsfnMk62CpOuav0U23RoG6vW9M8WE/+VM5YcIWB9gegltmCB/2?=
 =?us-ascii?Q?Pc/e3PnI0CRD5u4bGn6/Ef0SfjI3KoWkoHMxYgFFrKMEMZSk+Zh87+lm5Rxi?=
 =?us-ascii?Q?7AQkxZk26eYPgh5NGYzVSwvGJEm1cxZtOy86yuPE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qeKml6hsL3FJs+8rbUmCgRk81ugejZ5i5BUva/wd4UT+k+y+n9yRd+13x8be+dOuL0dVxOhXHId4p7aXVqCeuyoeSA7C76Hi5uR7L5WwG/J9j7KhlsdyDpKHTibXlA3SqKH+1opejXdFuOyBMH1viCQ2cu6MUInE0iYUPIyfk91KfEYbUwgLAF6lZ85R2FlcxvwzcyXX2AdvgqiBBbpcHfap7akJqaFHZn3S+7lQ1yL+OG1UdwQUrCCdtt5nyia4/JG9+Kk5xm1huXKfo8TQG1SrBKrh/qXuRhLedOch2HuSe4rOapdMBj68nZN4zOLpfuOs8krP4W1JHvxx0c0spU3nczB7HmGKoqYN2fwVrCWD+N5sizKRdL+PPcppSPjYp2s2jE/GffgsaJZU8BceKmffIpdClqgHPvuGusoJEvFrVpBHnW87fb7aFKjKwiYeWEFgXvQ2jYHLgGt26qyV5eyQ0YhtS3K7ps0GilQe+Bho1zL7LXpnzWligStMKS0RGR/I1nLXk0cxSdltK+fHz7qf5DIaV4lTxbLofpskGOQ0kpNE9UMSparSi39IOGWoI0LBSGriA09kOaacSDjQDzAkzVeLcIB245fUIkioY0E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a386ec-4ba3-4006-f3a9-08de1d526b0a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 16:34:55.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0TgI94tMKqAYO72tZo9Z1rDeWUG/rnq4jsXf224ph25NrVWOm792v3pXohFAt5Hppgs+onLbMUlc2wM7ZWYBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511060132
X-Authority-Analysis: v=2.4 cv=HPPO14tv c=1 sm=1 tr=0 ts=690cce36 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=87Iwcn7idRxoOCfZp7YA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12123
X-Proofpoint-GUID: 9e-68eHBYuDYwTi1zY41_2cE5rpqsD23
X-Proofpoint-ORIG-GUID: 9e-68eHBYuDYwTi1zY41_2cE5rpqsD23
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzNCBTYWx0ZWRfX59oIA83y4icU
 fHjyzRvzo0L4gCw0HKe1OPVedMIKsveOI190qW8K1O8GLLWoUZIS7vddGbOUxWu+B9BRRyjR5DU
 s+jrvSOOnpDVYJC+KmCVem6/aIXrJ3+jkiVKyPg065v4l9BpHYYPYX2HL8WR50OQyOW9cAJXMQT
 i9qsR9gsayjPCCW4eEX/UhwGJVm2VmQLzjOjjTSgfwufvZ3fO8tXd2Szg3Tr1YkTKOVfeT99Q96
 sZyk4lbUGwBGaWYbNShcZgHsa0HAbxmTb41eOW6Q2a3rkoQpizXcb0/kKxjwaJaFj6QOMar9P3S
 Hq2UHMiFUfoL4OlxWm2GkOTMV55F1wFYmPqPrq9CFh+mGUZ/8ITSfVxEIMoy19crME+Ene6a8f4
 Q8QVrzDoR95wdZnqG3qArrL8QsEIFxLH7D9LuOxY3lWuAizPgbQ=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B65780008
X-Stat-Signature: ke48bp1hzbzchis4qm7ig6qahmk3pe8p
X-Rspam-User: 
X-HE-Tag: 1762446912-791360
X-HE-Meta: U2FsdGVkX1+NDCiNgSklaob9NVMltm0jt9RkRuTo+Dsb5fj3fmITiPSnGVjvMtv3wcxGCaMAa7iRVC899Ves8UU0hFjjFb+XFkT44YOidnfvAMj1a8ahsm8qczGIdK6imNii78t9FCvZ0L5SvPtcdrmcVUNlnJY9v46U1UjM3otpfTVCZjsn6wtoVaVR0MIeoicCMBn/vJUeosF/y0nPGu03yyHcboYn2VBggMqyGj3BosDldqQzNv09KbmVpbqxU7aCsPGF3e/f/guy7n/U5syNqdHFTM4mLvhdtvsw12cYt3Soav5k0/de0EOu8d6nBBktFqs0/Op+abXhPsq4hRjWC9vS3nD+4RReDzxKV4sXP7Kie/FodSrzYYXvveLbOW4ccIjjll0+AG8FFlNedtq2TywQQ55Scvs4Ds82cVExmCsFWg5OFZJVGZtBxobaQR5Ua/SvcFb4TbMScqlq10sGnUzSgGUuzuucGzZao6k++e5aHbxlMpWZlmooxgLJ8wfXpCnoJ/hlrLKcRBqMtaAvnIvslxqyWGk9WNoVJ6E1GgzFlqKjOpkeS/sdRDKYvIFo5r8KsO74MPRO5pZ/OyLnvvNu+Y4bvVPvi3KBSKsRD7iUVInXXDuUpJ3fl9EArdU+vduErfC0n7th3aXegLlIV/7VyL8nj1FzDWFZpOF7laOlEbvWJNRYgrF7fERlXDUrO0d6vSrGorkbMVLIne4uza/0L/Jrkcl1r6toILC+pM1azHCkFWrbbSFDZNNCJiNLBoLzB17fOzI4404aGMuK8Utf1p9w24gMKCGdmte0cTbG2wNtfvcZhsZmDpfwTcxU5QdLnKrLWwgwGhcQ51FtRUCJ7wuIO8e+pFu0qX2dYdPwFJbEttK+hdILjUN+2AKA/kZNsqEjSm+Ww7GM8yl5cH7ygDvhgHDNLBVEE8//HGbrUQwOoGMXBiIuR/pfMjUkzpvFPwb3kOPfkiC
 X1EHQVkF
 aubtd/hOl6gPvAmOAgMXY4zWVhE/uX8/dXAnVsbIhdXBL8CZzBhDjCPAxf9QN/3Qmbe3r32o/ArVW5441aYA8O6Uh3kVMex/W+X8OnAstiPnI19FaL3dSBn2TqNkXs2fL1aAaH6o1WpUk95RNp47sU48IwEfk1kzEDs1y4MTzGBGyZ4LTVWOJT/U8Cs7wKdOvckuXk0Ik9UZZAO/7VBbLS4wh5UCbogQwLbbNM9GphbQe4rvyC9yEQeBLnmf6/KzckKGBCVWNx3riUlBNtu2D4bZEOYAYmaM1P5STDcNVlQ9iE5k7/KUyh80I389IKcb1Lwy96tPfdknz79Gjlt+BCLaoZ0KpLzqXka9Sl2fTxAq1vA4YvFIkfDGkYHrs/MUTG1MP6iRZF/PSODtwZzEy1cfbid9x9BhE7v+MM1XyduPEwLg/9hLIZAor7om8vA8RoWaRkjpcETHCwUjv5cUe4Cfn2xTgy8oVp52ZlpVtTNpovcuwSGv78sJCBsBoKSa79Hp6YB7GIm97+TkQ/eK//zmV8OkFa+saiYE1pXjJt9ZEvKOdxSX1kpP1nZu6XyLjzJQDHDCI3cYiuvQgnrB7AF3zPz/cmLI5EqKjl+mSGbdVFZwJ/pazQUnRuBmTQAYsew6XFsJeCOH9ebjtBFpp38Vi52ZZJX1aU6aEwOJsJ67cuTjTHuIGAutAyjnF7IwEZmjAppDR5V/4LbeXozF0g7YO9Fj4MI37VSAamYhlqGAWzQQvT78r0S6bNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Kefeng Wang <wangkefeng.wang@huawei.com> [251104 03:57]:
> Kill mm_wr_locked since commit f8e97613fed2 ("mm: convert VM_PFNMAP
> tracking to pfnmap_track() + pfnmap_untrack()") remove the user.

Thanks.

Many of these functions have way too many variables passed through, and
we weren't even using this one.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/mm.h               |  2 +-
>  mm/memory.c                      | 12 ++++--------
>  mm/mmap.c                        |  2 +-
>  mm/vma.c                         |  5 ++---
>  tools/testing/vma/vma_internal.h |  3 +--
>  5 files changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f27c3687ea43..9909e35ebb8d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2471,7 +2471,7 @@ static inline void zap_vma_pages(struct vm_area_struct *vma)
>  }
>  void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		struct vm_area_struct *start_vma, unsigned long start,
> -		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
> +		unsigned long end, unsigned long tree_end);
>  
>  struct mmu_notifier_range;
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 4c3a7e09a159..1a1626bba55a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2023,8 +2023,7 @@ void unmap_page_range(struct mmu_gather *tlb,
>  
>  static void unmap_single_vma(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, unsigned long start_addr,
> -		unsigned long end_addr,
> -		struct zap_details *details, bool mm_wr_locked)
> +		unsigned long end_addr, struct zap_details *details)
>  {
>  	unsigned long start = max(vma->vm_start, start_addr);
>  	unsigned long end;
> @@ -2070,7 +2069,6 @@ static void unmap_single_vma(struct mmu_gather *tlb,
>   * @start_addr: virtual address at which to start unmapping
>   * @end_addr: virtual address at which to end unmapping
>   * @tree_end: The maximum index to check
> - * @mm_wr_locked: lock flag
>   *
>   * Unmap all pages in the vma list.
>   *
> @@ -2085,8 +2083,7 @@ static void unmap_single_vma(struct mmu_gather *tlb,
>   */
>  void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		struct vm_area_struct *vma, unsigned long start_addr,
> -		unsigned long end_addr, unsigned long tree_end,
> -		bool mm_wr_locked)
> +		unsigned long end_addr, unsigned long tree_end)
>  {
>  	struct mmu_notifier_range range;
>  	struct zap_details details = {
> @@ -2102,8 +2099,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		unsigned long start = start_addr;
>  		unsigned long end = end_addr;
>  		hugetlb_zap_begin(vma, &start, &end);
> -		unmap_single_vma(tlb, vma, start, end, &details,
> -				 mm_wr_locked);
> +		unmap_single_vma(tlb, vma, start, end, &details);
>  		hugetlb_zap_end(vma, &details);
>  		vma = mas_find(mas, tree_end - 1);
>  	} while (vma && likely(!xa_is_zero(vma)));
> @@ -2139,7 +2135,7 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
>  	 * unmap 'address-end' not 'range.start-range.end' as range
>  	 * could have been expanded for hugetlb pmd sharing.
>  	 */
> -	unmap_single_vma(tlb, vma, address, end, details, false);
> +	unmap_single_vma(tlb, vma, address, end, details);
>  	mmu_notifier_invalidate_range_end(&range);
>  	if (is_vm_hugetlb_page(vma)) {
>  		/*
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 644f02071a41..4f51ca644903 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1274,7 +1274,7 @@ void exit_mmap(struct mm_struct *mm)
>  	tlb_gather_mmu_fullmm(&tlb, mm);
>  	/* update_hiwater_rss(mm) here? but nobody should be looking */
>  	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
> -	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
> +	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX);
>  	mmap_read_unlock(mm);
>  
>  	/*
> diff --git a/mm/vma.c b/mm/vma.c
> index 919d1fc63a52..0c5e391fe2e2 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -483,8 +483,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>  
>  	tlb_gather_mmu(&tlb, mm);
>  	update_hiwater_rss(mm);
> -	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
> -		   /* mm_wr_locked = */ true);
> +	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end);
>  	mas_set(mas, vma->vm_end);
>  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
>  		      next ? next->vm_start : USER_PGTABLES_CEILING,
> @@ -1228,7 +1227,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
>  	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
>  	update_hiwater_rss(vms->vma->vm_mm);
>  	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
> -		   vms->vma_count, mm_wr_locked);
> +		   vms->vma_count);
>  
>  	mas_set(mas_detach, 1);
>  	/* start and end may be different if there is no prev or next vma. */
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index d873667704e8..c68d382dac81 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -848,8 +848,7 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
>  
>  static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  		      struct vm_area_struct *vma, unsigned long start_addr,
> -		      unsigned long end_addr, unsigned long tree_end,
> -		      bool mm_wr_locked)
> +		      unsigned long end_addr, unsigned long tree_end)
>  {
>  }
>  
> -- 
> 2.27.0
> 

