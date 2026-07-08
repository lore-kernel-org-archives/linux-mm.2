Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EE3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0975E6B009F; Wed,  8 Jul 2026 04:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EE06B00A1; Wed,  8 Jul 2026 04:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7246B00A4; Wed,  8 Jul 2026 04:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C45B66B009F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:40:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41E0690E1F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:40:56 +0000 (UTC)
X-FDA: 84964964112.27.2CD7F4E
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011071.outbound.protection.outlook.com [52.101.52.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57E0CC0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:40:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=agnjzEY5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.71 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783500053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FqGvOW4kOFTtL4fCnVLYrzWIQbgvV72MGfaGYZz0FQ=;
	b=Q3a4yvL+ZQJHQ2rSRO5Ak/CGVeueP6aupjus4c9wjGwy0kptOPlGZ3JgG2ViAfeU0BlS44
	mBpAXR9Ca0ZWE21GaC3v45/Sx/5KMCjiSZFaBV/bfgjga5vMoByvQbxlt9QF5TCmGiszZp
	fwOgBMQCdo+yQuf/oSTEvvdwg7tUtSw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=agnjzEY5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.71 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783500053;
	b=HDundsKxlBOgXNrHEHBNe2ubz5WkHXvD6MU+zEqrAEJOGHdVTjwjtir4n/rLaT42tLeTo4
	MgTirLwmaLPMdsSKV3k78Zh1rfnHOIfKYp6AWYWcmeX2CIlebXTikHsRHWta+QF1K1RSbi
	82ghoaTsulrM8iykTxH9lYZRcLdKtGQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ryidJWeRp8GZF/FJ8TYVzeiHsO2UMBZw9iA9OCyksdyOS1QWW9gkSolofUAy4s9vVc6i34YCN4UFsgzXhBMeMo+euGe0hLSI2s9cThDPBRhWAX6YEWUfBB8dUCGkURiuhPocQjyHguS8KqXx5w00vqaeS1VEjfLfPaglv0TxwRm6rH3oSxIavproqpD0ANSphuweAt2WeZ+jpfzGcqzruZAnBZ0SlDbwBGc+xmCJb/zG7KJ7GU1Y6Bu3/MptRq3wfFTZhYuiPJmkuQnOGaBdMy9WW4Oy7qBq7PTSpbHEoVaMu3My6CqkdSWqt2kUdZBqZo2vErFOR1b/ZRaWCy4OmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+FqGvOW4kOFTtL4fCnVLYrzWIQbgvV72MGfaGYZz0FQ=;
 b=Xfz9gMAD3+JN2TbEwzGmTIlcBwzPorbwRTfIyMmX5rKY0hLiyMg6aSQ8N4cQRjD4qL+7pfnJP7/XztUrttG24zb+w0dqS4AguBxkCv4siQTEEJTTWB3octLAYLB+saPkafVoTtojQNFp+jvoq1NFgTd8hdQLvA+RvP62AphElRR9+gb0odduwPKB2R1gkXDyYmtBjTTX/MRa3gezkfccjhB0KXMwNOBG0gHmOXJWLndIlwqCGD+0bMhstvRUmeGw+i4TmTJq7ZJjfsMG1UJgkw/sAah5W8SqUeyvADxpElu0hTQiJ+MESe+G9vR8RdwQu3KMUIIXzNZvcP1ZxT3hrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FqGvOW4kOFTtL4fCnVLYrzWIQbgvV72MGfaGYZz0FQ=;
 b=agnjzEY5uEaEMNG99XdMvTeitOWgk4uyJoW5noXQNdMLrA00MN87x3GLiEASuhpy98ZOmnEyBrCZBQY/ET0Jg6rjpUPYl9H80hs5Pqw7TtqrexO/SP+BDmqHYOJl9Y7R3iQJT3XjCBUOUAyHa5j7dXw3kpujBzMAaayW4Dao0LdiFnq7d2cgZeqgev4PdfUhdSL8gzhv2jkzhrfKKYn3WdqfRpZwKg888ENuYNDs3EwlT3dqle2uHM0PBDaF+vT2g8Y9O8e4N2PLH6thF+jH6XOed95b71MsHqF4empZRTmnwxhdL41BLBe9fV5cA/B0hDoohQI2f1Z7IruQjczxBw==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by SJ0PR12MB8168.namprd12.prod.outlook.com (2603:10b6:a03:4e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 08:40:48 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0181.012; Wed, 8 Jul 2026
 08:40:48 +0000
Date: Wed, 8 Jul 2026 18:40:43 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com, 
	vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
Message-ID: <ak4MjMvQeaD2r_Xq@parvat>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <ak0FtLIlTyCo_8lB@lucifer>
 <fde1372f-5d80-4a1b-8bbb-11441db9f55d@linux.dev>
 <ak4It9Hm8S01Nun9@lucifer>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4It9Hm8S01Nun9@lucifer>
X-ClientProxiedBy: MEWPR01CA0175.ausprd01.prod.outlook.com
 (2603:10c6:220:1f2::16) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|SJ0PR12MB8168:EE_
X-MS-Office365-Filtering-Correlation-Id: 31f740d5-d52a-46ff-86fc-08dedccc9c2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|22082099003|11063799006|4143699003|18002099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	gGpM3MhkY9MeC7yqsPn2Cf5j2bDPTGVD3L9WeWeMDQSNQ8nfw/FTc4V6JFvzZ1IYLmJsGOrc0mXz5gd9KCU2lRTf+QkkX9W6kqiW9JbFZ4Oh3EUIPvkNAaScXoatjA/TEzs1c8BAU/b96jnzrZQgZhoPRZAjpNAR1CH1PN3w+cVZ9JmTDFgb8ooEaQ8jqinfMBMbjVtJbQLb/oAhmyUoJ5d4wZ6ku106Rt0RicZTXtTbG6SqV1ydqtF7DNPjzOl9XVxojVZRrcM1+XTAiVEexAXzvpO0phGgHzkaYI+23tKOhkbSh9luuVf6niyByE5AbaCPp1YbDtfuVVTDM+FWakeuy9oBgd41PkKErHjh8Bfbg8x3F5+GLNbOgBqoHr/SwS66sTLXF+ygxXyv85Tqv0mW3mMpwFNK4KpMFqnGWFKmCdOs57fGnqRIjZENeDeOB/WaxVxt/Xg6SNBPZcFfV+Yx/qMKtJMUCbIrGa+Ix2Xoy7uFFooSfrV31OVBHxHbgi5AG6bNztP2h2BbKF3JgzizmAhb1I3W2+BM8HV6FJ/YVa2gnQZCeNPpvnexDGjyGN4ePxVxvx+fCpdCx4bQ5mqyCc2ZMxLVR9W4x8SJXr2SRPlplnl4/q0BsdnQDHEFVakkXhepwpVXut5P0sOSxU8/HTj5z1n4rM+XSIqclUg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(22082099003)(11063799006)(4143699003)(18002099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Aacq3mc29afsV6D2vDrJwMcf9dUopV7xnChtZBbLmz6Ply7UMlCRVxArLLXm?=
 =?us-ascii?Q?nz94rRcRR18mCCRQWALstmhKSJGdog2GT7p4ffsg+oQDc9zLPvbGWlJp+OH9?=
 =?us-ascii?Q?f+rVBMTjp72FM4wvd1irLwi/0v/fHcQD4r80U2nnupUgZjtt8CnHa7xkJFfk?=
 =?us-ascii?Q?k5BYQnaGzhTkj/g/INqh8+2IGLr4Qp32NjUWlmvN211jNUTWYx84LdsR6dpu?=
 =?us-ascii?Q?msnthnUkxsRrDB4Nbly496MfG1ryBGnjgiPp9ueJJQWZST76fF1MzL1B3iib?=
 =?us-ascii?Q?EbEmuwAdOwa8VNgkw7OeBhZCRigIYpSC+zGDoFH4DPaCtpi4xzFM14WTx3Av?=
 =?us-ascii?Q?vGyW3UIkTEsvpna+OhahfBoq9ZQ7uESb0IJ/faZM5lG95imz/U84uQ/Ol6mi?=
 =?us-ascii?Q?CIL4FuHywg+7e+5dKdWuHVlRAaqTd6gjlEo21kW25gUYieHaqgh95AgU7sTD?=
 =?us-ascii?Q?cerOBGiyTVsmjhwlPyxWfgNT8tIKOGeXkX1IKJPJ+gowlyYmh/ohDCV/Q/sZ?=
 =?us-ascii?Q?A509PWZIgevQZsKNlboJx4ixji8aQQv3nSdHHB2y+8o7BYFqwkcQjUj2mAGM?=
 =?us-ascii?Q?zf/I/WAF0o+uhS3XV2+49C6ID9Q+mRxLjRiThEZdwcvhjxSJ4Fr92dFhLnkv?=
 =?us-ascii?Q?+mEC1brNRg81Bf9Zm//eOJnvjdvKoeW7IFEg8ajN7pt2N/IFVkcFzHFXc9AF?=
 =?us-ascii?Q?AHPizPnwEwWE/3FIyXHUDp98vmVpfJLMzOY25kr98Db/bSAjkIk8kIX40cLT?=
 =?us-ascii?Q?6PyrjOKldKLQz2AaAloQnP9HivnRUqdPmbYNWVEtpnSl9HwNFinMrKUciKio?=
 =?us-ascii?Q?aXsW3fusyOtLExJ4FuKvFcTKGRmotu1OJX6RNBDe+U+9x2WY91lcnYn5wVZE?=
 =?us-ascii?Q?AUTQovuzTdpZFPaNLFiyEN+3R97Hzqlzi810NZFuHdHi+56Mh/A/sdAQek6s?=
 =?us-ascii?Q?ApefgZWpt0nc43Wq4RGbSerOZLxkQrkIZowmklODgUvkMq4Bh4jvH7BkGcSU?=
 =?us-ascii?Q?T1nCGPgHtGs+YLqjdZNIKxuxk2J/hvrLulGTZaJHtwsQSlcPj11RTtHcYnH6?=
 =?us-ascii?Q?JMATvTO0HU5Zwcql+0uJInC4Qc6Bbzqs8i56GBHkRIze8iIaqQKLWQUbxE1x?=
 =?us-ascii?Q?EC2GEZNLJPncuOTkGgcgkE/J8E7MdcHR1r6plzMFPmjgJfYQ1g+f4PAoaWew?=
 =?us-ascii?Q?w4kIngBzEt37+dNHPXVT5Mie/wUTs+KH4+EymAsoKxHooluODI04ecPjb9on?=
 =?us-ascii?Q?pBAuSyF9FNCMN7qSMrIlXMEhZbdeR9o4K3UeZ3UkJOQ4MY175M+wMH4zssj4?=
 =?us-ascii?Q?b48M4uB7BpXFLL6ZLh6HGMguzU6iiZETXZ6ewDgSJTZK1v5s8j17AUaLrMsb?=
 =?us-ascii?Q?0Fe/pb8Z6EUbwjRjqgUPvhBdwRax0qZNI/2O186nbXhBC4+xKDDlS8aGoMmn?=
 =?us-ascii?Q?SjLDBJkdZqThmA8M3qA4pUgDIvKZreOOMYXRpSMTIa5z0cgmVo5pjQtdCz2i?=
 =?us-ascii?Q?Z3Lc2UocWrFI9no9T3/VP+lkwPkZqVRX+t9BNLJAv5ymmjAx/oeiYolnaRta?=
 =?us-ascii?Q?6lIplU6D5movocfj82SBRQwj9DdeJaDQwrh01ohDMOVT5PvkaJ7fRM1laX79?=
 =?us-ascii?Q?3/uQaMMeCFBBTyEOFbCdTPJ9aWghO1SmkXwPmzguEaBMrGNTUs7iVqbv6GGC?=
 =?us-ascii?Q?VHYNx2sJLDV6tS64NT9qXpKNTO37MdxNC3N4Ou9KefXzBwkI/J1YVk3xpm5+?=
 =?us-ascii?Q?AoSpcNo0gg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f740d5-d52a-46ff-86fc-08dedccc9c2f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 08:40:48.7983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBCGv1XInwW9kSw/PqhaC1IR1XuT5fILhDEPXXy2VMEqYLhof6mPNdJGSgrCbIY7my3DZhf0nN3/LQi8mYeyTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8168
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57E0CC0002
X-Stat-Signature: oshfugret8abqegh7rrao6xpt4wum945
X-HE-Tag: 1783500053-234644
X-HE-Meta: U2FsdGVkX1+szxp8e2guwLsj2Y/Xj79AJfiK3paJII3X/g3/GH3KW7Vz7QqjIb9SNAf4Jjgwl4M6c82amqOLD6ll+Vtld2tpv0+GRcJr/QxQGIcfM2bNo2FT2R52jN+76iRYNfcUHeczGczu9BnRXPulVM6jPWcN/uOppHN0RMx24ux0NCAZoC9MFYOV+tttX1uJfHcgFKBLmfiAp4a6B7jJ0PSWx/PNN2K4luEXfYQvdrcTDkdnumAQQPXS7unBhXh5wGE5drjKC+3eVojqUjg7YccbkQGkEfICVaf9fIF6fdUlsd+uFHmC9VJ3zauDoAGLTobt1oXwdR5DnLHeIMevx9FdyCWEtQ6TyNnimGTd3IaAan+VDJ+L+NvJTGHRMXJgCMfG128qRoIBx9fTGwiG+XfvfH1EY9UDReTz05sXObpMGb5UgkaGXTYXukvs7UdmpVq1MUd+BvIn/fkwuye+zVNk8Flse2+d0as06r5QDugIFSMU5Yi6mUHYBySTkPbhlTj4hgq2p3H3J5rtm8sX82O0wjsPfb9M6MVMXKGuZ/we/jJPr3b5uX/zmjpio/qvMYgK8VIEAy7PziRVNDndweWGd0b+YshzXWluuwR+UIVn8EjnOAjSjI7WRFP5/3esbaJ9JEfMuu42IIr0VbCbxgghpND2fyQqvaQKJFk+7QciKEEq5RKbfnE8TcjF4opRE31U5TUSu0RRnzTfpv6DE4YbqHb5ZJb/tVWCQsqKHs4T4kMT5Ii+hJT8hRRjvpAFPQctitYclTtvscTJOu7xnUqid+2UVTbGJY9yZxC2vHCd7m2CZI3Aiwo8nun8aQ9KM8InPVuj2P5vP1pMDd0Jn+P+BvoLRSQqqhGXsXtGRYB/rd+eGw4le4E2rIeGv9VdCwpyeCbmO0DP/LXEA+M1KZrH6kHFKcwZaMUS+QaMZRosJsPf+Y0KXQR+nudQFvCnJ7hE2WR6Ln9fPr0
 AaNbhfBc
 ElpAHwPl3VVjyxlm6JNW/nzkBA0WlvPMkPA5mcvUysKO94/OMgWyy70siKxVNy0E9vQea5XTofIyQ1igCPOg4pRB19zu7EiUqYhorpPedAocE/3RegUF2JWFJQDpUOAWgWDoII0Yx4XerKcdmCcezZp3JU90zWXINm13hUMCYaRbkCYrde+WkdEJsNKxf9FX77D5fp8HPoDJIv/pCe606YdengI8XrUyMvFLstuLElzPJDAKyGQ89WDx0TwZueHlo2jH13il3bwjrfPSe3m6kBltf+wWk0WaqunWwO76KHP2lO8OV3r/lxS6TuqwrneHAC8QNHJAAaBAERFH+ZOJEcSZm2fBprDcgbuDcTTvLVu38PSKFhEBlqMPh2A+XIyLVmG/Fy7wLsxZ3HmJqyHTufIv/YSLFMHGZbwgn3GbTkQzOlax+6E0TCw39m1NQCfYDpjj+PQRPyP87zVDAYww5Co0GxJn1c1T/sJgE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 09:23:36AM +0100, Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 03:12:11PM +0100, Usama Arif wrote:
> > I think maybe we should modify get_maintainers.pl so that if there is
> > a "Fixes" in commit message, than the author of that commit is also
> > in the output from that script?
> >
> 
> I thought it did that already, but it's forbidden perl magic that I dare not
> look at so who knows :P
> 
> Wasn't nagging per se about that (for once :P), often people who'd be good to cc-
> get missed anyway even doing all the right things, so just wanted to make sure
> Balbir was aware, also so we can make sure there's no other device private PMD
> stuff lurking! :)
>

Yes, thanks for brining it to my attention! I have started looking at
the set of changes again to see if

1. I can improve test coverage (mempolicy tests for example) and madvise
2. If there is lurking code that has not been tested at my end or
covered.

It's a slow burn, but I do appreciate a Cc, I skim through linux-mm, but
the volume may make me miss topics of interest due to TZ and other
factors depending on when I check email.

> Cheers, Lorenzo

Cheers, Balbir

