Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890AAE66880
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26026B00AA; Fri, 19 Dec 2025 12:27:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03CF6B00AD; Fri, 19 Dec 2025 12:27:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB416B00AE; Fri, 19 Dec 2025 12:27:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B98F76B00AA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:27:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3588D140342
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:27:50 +0000 (UTC)
X-FDA: 84236903100.23.551E9CC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E884A000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:27:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="hRm/UlbX";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f3VtjJqd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766165266; a=rsa-sha256;
	cv=pass;
	b=y0ZKf+wQjw/ZRKD4QXYibrx1WqsP74CL1DJvWVawv93fiBnWKPJSgOjVHP1FyWGJFuK0oL
	uIilWCUW05hTDpNooUxVgWlSRjB++BmbfopZsgbHk+g2FuoeYGAu8iRDAcUJyqiQXYJuKK
	ImNLZsqKrvjjONIU4XuqX7lrHSBu8NE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="hRm/UlbX";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f3VtjJqd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766165266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HaWUq44xruFvi42uZ8wktx+g9lFzrfRcWDoOmT/6+VM=;
	b=b7UfKXrdfF2u2LyBS+3ujNa+kyljvLqyBVvHzEzK2iXUxWCB1ILIz5Z9bAgStYBlAB/6O0
	+BjnOaLtB1NDFr3OUFy3YXrgu33YML4j6H74BeV1Ytzp3wXKEh+Nefz0kfC2HgqhiFO4PR
	RKrmtc5hvqeIvKiI08vQR7iPYCwE84c=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ5VsF93125240;
	Fri, 19 Dec 2025 17:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HaWUq44xruFvi42uZ8
	wktx+g9lFzrfRcWDoOmT/6+VM=; b=hRm/UlbXpZBs7lkLHlNqCu9qC+IdTGPcjG
	Bo+yySqr+oBiFE5nuxiijXkrGHvixOYnrDHE8jwnebvrhDWG7AH3qyOcAQUX94nn
	c4DbMmSTxfQbHmtzyiT+F6L97pgixE1Z7U3a53yelzKwUoBeVahTVUAdo4+xrJmM
	ZW8vPPvT197ptJ7e8JXf6vALqqhM1r3OYTMLxHEz+/xKc3wbI4ZbVDVlFO+RFVSS
	6nS7RYjdldcQsD19xcn+gHDoxPH7dS4aYNW98YrYEGjJh5mzDQ6F4igt+kIUMdhD
	e+QX+rNPBmb8SfcXsjxg9lfeS7IQC+fFjO3b2/CThjYhJhjVDfeQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2f1fbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 17:27:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJGRMUC023521;
	Fri, 19 Dec 2025 17:27:36 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtb889j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 17:27:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wXtLDF6/bm3yu8RbuBday/nbMX+YxWzsWHijDZqiI41QrC2oYuiTgYaLWcbcL7LxVn2SBx7D0/k2+Y4os82Wf1r0hKYPhIb3AV242kJ1jizdYB7m7WfSAzDZQJ1l7OSqmODKd1l7gicY2gtSTK6gtBXqRow87a0JJBsRaJQ7bASlYoFxjvxNEe78wZUb+h4FNg8E2VlwVPA7e56O0bw8MJnBM5tT4nwxQU3jcXVVAe82dQJayvOKV0Mc+QzVA9pG4K7Z2vjCIzUHN7g4jafs3kLPdI8A/PmvL3mBv6lrk2+A9puw1qVY8CEif9L29HFbGZrvFNRlWhGblIyWdxeptQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaWUq44xruFvi42uZ8wktx+g9lFzrfRcWDoOmT/6+VM=;
 b=rGWKJROu1TOrBqbbfu3jDzLv0qn4shd3lMQYaiQGSRTuD4Nh4dW4zUhb11MIUmVR7jsUV+UX7TJD3A0SDJ+vAx31NtGrUAYtimUg0c95q5GrlDm4ugwhbz7RKPMtp/BNnIlbXHvU6Ibavkfe33UUFBALFZfbs2uxfmq+JVYlJ037faUIa9P741g07v7Jfjc3FCaJZnl4tEbEyLdZ/I7593B2CoRksoVaDRgTWA/tyffwrt0F/GZohKSh1XWSwHHQsQXaGww13Rv+k4XLWMQ/oz4KMVT31cT/sgctO7CW/GzTq5oqA+ZkW+pZI9WEaqLafDwR9vz/tIwoACdKfLO/nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaWUq44xruFvi42uZ8wktx+g9lFzrfRcWDoOmT/6+VM=;
 b=f3VtjJqdF5ITihwIxqKA0X0KgKuyLJpaq0UlMmBCwyGadYK5ZkmIVFvEPSaWvnQAQqq0d9JMgX/h2QEPx7MqiM0jXRrp+eUnMe1Rvg/tSW036nwLpLzRRn1cnHOEw+91HA0W7ScW16llhbyuA8UjVl5jMN0xdrSbVNoFIsunhRs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Fri, 19 Dec
 2025 17:27:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 17:27:30 +0000
Date: Fri, 19 Dec 2025 12:27:27 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Jane Chu <jane.chu@oracle.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
        rientjes@google.com, akpm@linux-foundation.org,
        lorenzo.stoakes@oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to
 accept hugetlb tail page pfn
Message-ID: <fl5lkxxvlsyeur7e7ls2tnsh4afzyhvotoaluxcv2ge2tm2dp3@7vf7xvbf7mkp>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Jane Chu <jane.chu@oracle.com>, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com, 
	rientjes@google.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20251219062819.2499399-1-jane.chu@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219062819.2499399-1-jane.chu@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT1PR01CA0037.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BY5PR10MB4339:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dbae124-d7fb-435f-1cec-08de3f23e354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vm8pQ7JBg3lSLG0LAEeFs87E/mybleD8ixN4VF4+xnip4ssLW0RqGSSjCWeq?=
 =?us-ascii?Q?PoW0hCmME6tvlO4ll0FLP+uNnwBPwG6IUD8odPN14uQaDil4wGxzCuR0Wn4P?=
 =?us-ascii?Q?BfnzY/Ffa0uIUTN6rrQISZTK8VrFt18GkP3A1ehsv/ncEs9dnHoRWIir0Kj8?=
 =?us-ascii?Q?nRH7zm+jVQWuqmqlwKJ0CRKjOG34JXkBn/rmY2JG3YFddoBLhjNE/nKamJAP?=
 =?us-ascii?Q?h2phUSRDa+hlRB9l5iIsGDJAs3PIiyKflghgQ25R7BQv2v5YkPupE1UCUTfe?=
 =?us-ascii?Q?OOb+mG5PEen577AJOSJJoc7DORO848p1ChMbQtFwo+gGKTFlIQWDpM3LwthD?=
 =?us-ascii?Q?ky66mRslIU+wVrQZWQaMDK3rkZGdktO4fbPnvVbbNxn6+kKsjIBBoN7TjFx6?=
 =?us-ascii?Q?5oObXfO2DS9rZ0qEuP5LNCsDpJAiSaDPi7czrHCsYPi71yTDNqOkLYMqzMnM?=
 =?us-ascii?Q?XfvNFf6ABnOfzQi2iFSBAJ09AHFIFmLDW7ftKY7cvi/Cjx2WwRbkwOxr7v0a?=
 =?us-ascii?Q?1mTFKcmgHu1drvfF/Pf0oneepD+db04IbcLO7UgLzCrqHlBrhe6lx0iyFTes?=
 =?us-ascii?Q?FYijpJmuU58c4ZBULoElG7+V5SmBuuTz7UHtxBoXzxxoAE++AXr3ngWojqOK?=
 =?us-ascii?Q?nLBCrp/dpuufx9CpvPFBwfwqU1exINlviwl0OPfQxJ4S+fDeUzs5+/GDuaW8?=
 =?us-ascii?Q?UU/0k7uoAN6Ny/+BaDLkimKVkPsWHfdOy+CtrPtBUGSXSi/tz54gNwvqTg1N?=
 =?us-ascii?Q?zt0KZGa9VO/upwEU/+Uco3EzXQ8ZkKXev7F9ruHB2KoHf3u4DCmF8vhSw5Io?=
 =?us-ascii?Q?/0O5fvTdWIM/pAHV/hFEWnVccLsXC1/QjbNkQmt+rhOo7s3K+t3J8LC8tbua?=
 =?us-ascii?Q?Ce3rfKyfn8dUnyKiSGbAF1VWpsCQmJDVOX11A0EU5PWbaefrBWZ4665zMGbQ?=
 =?us-ascii?Q?vfI7dJPA46uMPri9ESf7KrRkZo5NkY2z/bsFns3k3AMQ78WlaWP7jdX1wUvk?=
 =?us-ascii?Q?gB8VmAnvheaF5LcQmg3qfZvGYgF2dH18tx8rSMVgKGKHq2BVQEVP0U/BybG4?=
 =?us-ascii?Q?ql5pBFze52g6wj4iLBrhvWyEKN2Ij0bChzGX21IV8ZzwtpRPJUNbt0oX6uMX?=
 =?us-ascii?Q?0qPzhlUnUxhQG1Qs+DIsguFzkTQbEOrqQAABRXvdVHC1YklXaz3pGwYprYZ9?=
 =?us-ascii?Q?0PH1+Xjc8vXLnw4CeJHAZLMOfu9wsAk9H8VFWzZvXlTQX9SCkaVeieLT8Pkb?=
 =?us-ascii?Q?zLAs7ODRHun5AkvXg40CvjXnZKaa6MnfRDqxH5mwTdbD3liugbe3LERq2BKj?=
 =?us-ascii?Q?mg3HotL/pGMP7ytZoXPjST8wkUOGH9nVTn5c++E/p99PG9A/5o3h6ZazHJ1i?=
 =?us-ascii?Q?+UCJIt/LN4UhSVpVf84tRP/n5v0FcJYa3bewBrXYXVmXXV/VUGRxVWuzEppv?=
 =?us-ascii?Q?2CQoJcwvRubG0eghwKnJcwguWgvKudwb55eONfatbL55lZ65boTl8g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8oujmoKALvyBnzf7mxHYwkRLdYD5KXAi6UHyLjgdTbQXKvl64x9Zt5SMZATv?=
 =?us-ascii?Q?yR42DUB9kvOdkYKo04RQwjFyjqRl16fTyK4slPigrAX+A+A/OwvV7mOl8jjV?=
 =?us-ascii?Q?n1JcNS6oTeUHWFSGPepOCGJWI3I+2hjD3T6SmnDxqnxZPKOfPs64/gju4lsQ?=
 =?us-ascii?Q?Ex+7LTsPIu7bw5r4nTXwUSn0Nzjgw5uEOUQhTrEklKZcAu7F/etwHUre4ic1?=
 =?us-ascii?Q?rQfczEd+wwUPBsLC8NcC17zLye4G0hU2u0lJkL3LKTAlqgzW3eTXLYn9iyMV?=
 =?us-ascii?Q?AZmiADpYR9xAiduao8/ixE+UjgdzGDkkWEj3eh4neHVJUCUhnP/o83gsGig1?=
 =?us-ascii?Q?UIxIu8zDkd0wcLZBnTO/dHBnDA7J9bgVaN7UU6FdQtUbKSXfMUeGyhhXOoHP?=
 =?us-ascii?Q?pd71PIcmu2HWjQR+6UkMdtwPKev46SaNzRJsyIow7L9S3I9zah4yBg8dw9qD?=
 =?us-ascii?Q?RQzyoGMXFsokjPGeMTL7aBiHzZHUmQyIXrdbGCTyYrnd+NenAjgGzLVdpJwO?=
 =?us-ascii?Q?TBXA6wWDmo8uPcMdBTjqRhPj9TcCvcvAejkavo6KU8t/77C6ow3TYO8ofxw3?=
 =?us-ascii?Q?OLdl4Vz5YjhE64AhLF+Cq+/fDs2BLqioJ0UzEZYZGAGSgiGpdyuW2EC4B/XT?=
 =?us-ascii?Q?l5c00ws9HbPDiIU4nzWATxbfWzpMETibylxq2O1/xS0y/S3bQeS/5XvWa4xG?=
 =?us-ascii?Q?PQAtC8XB8xVfGEAKlfsRG7qt6MDMsjuzBENE59a3c0+xZnVRJWhmVMEb8QQ6?=
 =?us-ascii?Q?EkW0pcXhyDTSkS81NIjvvD7Ef1qRbyNZtQl/UUEFifCFLK2ofZewpoKVWTLi?=
 =?us-ascii?Q?+Coxik1dlR1DXyyS+sytBrUK0ncG4CCOmdloHDYJKaLVsClTkcet9j+BdYY1?=
 =?us-ascii?Q?B+MYZL5RXnJCT7QURDIoGzcGL2PQolgFdxW2AwicWF7Dzh8nshnjEFMP8nCG?=
 =?us-ascii?Q?KWiRguP6W6tV929lmFam/K9aXgp231Z4Pfe0YZSzE9q+hulJef/Z/VDjxhiL?=
 =?us-ascii?Q?vLDww2KLnyOPSzYYtKq/5HP3lVqWAFSKS8IyjOtCD/p7jspkgJhom7F2MuRu?=
 =?us-ascii?Q?G8NPr5Y9QymSzWw/ri8PGQ+bWc9EkUtFrFPxEUA4bekhBe0pc28CsUfY9+GG?=
 =?us-ascii?Q?BpNmwDs2FtGFPjBRsgqbsNKSflTnUBwd6TTWgA9D2c9QiC00ozm0OdAscwO/?=
 =?us-ascii?Q?FgRJDVLzAtANII9K1mYqbGg42v/R+1xa2BxkOiV63bNQlCsslN40joGrse3H?=
 =?us-ascii?Q?Yqc06jQ3XPfysS26lyEsCHqtGwVr/uRea2jRQjaE20AYyICP5vtOpmS6IpFa?=
 =?us-ascii?Q?jHIymsqjmir9HbDV7JZXBfXqq43YjNhD/V9DkmFZ8+Zjx1L67Y5ERoibBHb6?=
 =?us-ascii?Q?ra11qmXV1BJcIVLQxbZXuteB1iBlq0AJll7fdz5tw+d57M8JV+IRLQsH2xCZ?=
 =?us-ascii?Q?yCsO7433bzAHARx5B4DzS6I+fkpqpapI6gstC7TUzrBe+Z/VWpbqwzs80s72?=
 =?us-ascii?Q?h/+fzEiZkCvYgUjwPHaIVgzoFqjJnCHaw2LEkeZmzZkCZi5ZoLlJFignplCR?=
 =?us-ascii?Q?q9U8rGVeb3ZTT/DzbZuiMjKEubR2Osbc/NPcqBzjBOnyijpVkFWUOCNTEduU?=
 =?us-ascii?Q?tTBM1WQl3Kc9uyZQyCt9rePArOGppbqiVGqA7xF31wn24W6jpyQG0mnSOjHK?=
 =?us-ascii?Q?X3qy4SHRJwu02l1hnncPylpyd5sNA11uFx2/Lj2Sxa5pM6jo20SZb/rSk8Or?=
 =?us-ascii?Q?sW/74tNlYw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G2aobbtxH9LoOGk7dhuFUz4ld9Qcjl+I/nwGoow+jjY9RTXtk4toi2MZFkBib/LilJYla3NdxSJ8QLXvalEMam3H3ip83U44MjpDR7OX0tYsAnmU/+oBxqzOBn902o+J2uwuGkAGAdS5vTrPGivc9YO6dBC92BwF4iOmGxF04DUk8Nt12baUyZQj7xSz4YzTwOXxsq79UDv4wKsuQeUi9uP34DKBlwvXxASkcnWz7ttUnUC7hRHUmO79ORT0wq+7gnjsws83daTF8W0llnBzNrNJ603cUs960rvjDnDhQIc9l6ncEatotAq1tGWnioJu3UaPV/zIBEx3e2s3KlqfuCJrFhnAxc/KBep9+Ovh1OLTbmSfE5rXH5cPgMOcx1KVTMZzOWjnKL4cGpwEavBy2pvJunJ2zzBR/I8TxMl/WvkX8Ro4H02z5LD/ig1IRXeSq6U1owGVRl3lJeMTvUN0KKZQyAd+gnmQ/mPIgaF/0GBGz3460ykfv93dp9oSfHhvRSGfmMIu7lNDcV5/+/ybkj/yNW/PanNVQ0mwqb9EqemlpEGzwuEEnz/XyhizncIza/67JrQfNPYoP+ee+IuQQmjeRrmE9xO0Ui7ivAbDWus=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbae124-d7fb-435f-1cec-08de3f23e354
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 17:27:30.5262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +01aZp8YbDdTZQ1ITcKSbK0AfXr6iyKlF5C2DbQT+lOHDDrFF37qPoqjQKGd9gWAeO/JqwDXPblIgNMHN9CleQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_06,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512190145
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDE0NiBTYWx0ZWRfX2TQXhyOfsWa6
 aBHv77TU/Tx7fqg0nyoAqiCZ9JUm3j0+d0qZdlYCwN5XIPSa882c+esEHSpvyRPlQfOnwMZhOvS
 fN21tWlFUdJtRSgEZAR5e4Jg2ozrmn+QwVpqi9OxcDg6L4BYF77AGISB+VSq+1+QCZZojODDulX
 Qv1JBNCSSTED/kl/WEe3zb8Kx4qOpXwQLH0PNgVqaBPVDeiYfRsRccEwCwiorlj62y1uBfVMbgn
 RTLiDOvsKwHjyJYHhaUhOns63lsurr7YgCibCNRd1AXFkqBCgzGONh9BfyCN43s/3OWFz/gX0Nm
 mFQjWtrVfF2BGSL2PWzgHSrUPh7G9ZDVlNLsrC8ndCkKO6c4rb4uglMzkWAqD2Qi1F8yUwvYWGB
 0O/hXg29GtXVcu7HWJArMs5Q+9BelMGUWDVVx2UuNSvuLpMAoVp0PsPcURPFgwahfRkC5cK8nlD
 aYCPQOtwsXi4XQCo9ZQ==
X-Proofpoint-ORIG-GUID: X0ILDQY81oG97Ud5nudLaT-v2jdRr1bh
X-Proofpoint-GUID: X0ILDQY81oG97Ud5nudLaT-v2jdRr1bh
X-Authority-Analysis: v=2.4 cv=OZGVzxTY c=1 sm=1 tr=0 ts=69458b09 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=J6Gi1xeAUPSayhOIKvcA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Rspamd-Queue-Id: 8E884A000C
X-Stat-Signature: oatcqhune4gw5w6gunrwc4itbj6pgghx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766165266-343225
X-HE-Meta: U2FsdGVkX1/DneqJHmkjVxnDGpx4s9yyFs5b/RF/isQoL1VcR3s/FNfVhlt2k6Sn/kgpMHnCagBvF+D/KpO6eoAZ6+M2tgY4N54IYMd1N8m5ajfGOOczxldq/DqHzJyjj2s1IQTboE+ObZyCSqIdsLLXk1W5kncGLzSBnIq1hDMmo/p0O0muvzcHwPDkaWSz3YeAItcmp3K9mc4G62Ei0L5G4Bwe2bwwEP09erPwiH3K4KhdeFv44kKbPs4NSKIOY/k5DOOLlSKuJ1ViQXgsoI+U9c8SWXLioHumm0oGm1j+2nSU9ctXfAAf/Xr3bGxarwbxA2QBP3Vk1nPbYBUq/xyK7sLVUkNOISn/QkkG4CPO1nH8SVGMKxwXNU5ovBmEmGSeajXf1jQrpF/6TVy1IRpYVpYffJXHED5+OpZUea4QrZ7b93NKgU+1U6ytPrd8PvQn8h1+/PEd8VwreGTASOyBuq/jR4sRyts02a0xvrcDphUP/gMSOm8T17pYSjJS/mhSUr2JpG7cfbKjmYtWuEP22gV4wmei8Nw4F4uRsMhfyQPV5B36WL1OM+Gif6YKfkch3M6Fk4UKnqAbxBn0MLYBbpn+S4Dc7TrImlVCpQ70DfxgU487jkyLZXjeS4KmK05LF5l0Ne469d/NavlcDcaTTxEBGSChhKqJGhYBMnU86Mg6pu+0VsGGzBFeuRAGm5RjkAKVRT0vbWoK1sMjIMQ9vtWuMakKR12KtawsxV21lLpkBGlPN9Qb9p6QXfaYIXmIFlLrTod2GYNkKBMXIqrydL+gz3lrOWjVCC+KUYa7LUD7IXFCJIarb9pibvqDBfhxKUc4lIV1QskGDNmJUI1svcin0b2qKFVvb3D1PGRAl8AHeWQJdrAWfulL5T9mKwtPaw4VF83r9UAN3dAoppDRmX/8C+Aob6d54XnKYFg8xzVrRamic4qM8nseCWWO/JpLwxbhE4bRzGrvMi5
 0lLSP3jY
 ycdqOUKHTNk8xnPEtKdFEop9t9WU2yOmHZf9WFQBSHC4b3IXkESGfpdYzUhEW0Jhk+o3oQT1BK4KQvMO8iyycEVKFrmLoF+KGCDgofK305AD5x4ePoT19BfUP0FnTi2inObtaVvW8EHKD7XZiiHkPNP3IVP7k/RPaKvgLubbaCeqYlmn7G8Coz+Co+Uy7JLpHQD1l3ztHCJcLrTXRZYDhjpWfyCayF6FcUZ6Nfwdb6DYfRtPybF4/VedFCg5FyUmvMeB5ScLCKuOC5btj6BJwvAkFwHJy5iFudfuwGNz8zdtBtL2NUIfF40yMUzP3FdEXKRdsdilFILRgDQbCL3DDg09O4SoqGRMlEwJVW+Zhc7HfyVWNvu+JQj/oF7ViOJ0k3piWb4+A/r2fhJyYn56jYmq256ETI7DT5agd6O2R0ZR+SrZxTdmpCgbsaZNA7DMyzlg189m/5pkwluzwTevoBhlrm/3uo4HSCMPv5jB/U4pJs8/F2LNZPuFXiAgVOh5dIoIaj7o47pnhhWDoYSxQ6dSNBMgYk7sEsTb3wQrqWrGT53YnwkTZzdygpZU97pR0y9NoO201GKRaN14Egbhjjg6vtPoid/kD3+s6nbVxv6EqYpCnIoH213403fmweObMG6SGRi11pSIrBVr29iI654ljYTZYwzrXMTP1FH//LbSLW/kIFdCO+VfmRVJHYYmK9/hM1HyqghYPmmv2AQZC1AIpObxDw8vwMzYP7sS8QGl0uxOu3DI7sQsUPkhwtoSXGJA88bU0C149aag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Jane Chu <jane.chu@oracle.com> [251219 01:28]:
> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
> passed head pfn to kill_accessing_process(), that is not right.
> The precise pfn of the poisoned page should be used in order to
> determine the precise vaddr as the SIGBUS payload.
> 
> This issue has already been taken care of in the normal path, that is,
> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
> correctly in the hugetlb repoisoning case, it's essential to inform
> VM the precise poisoned page, not the head page.
> 
> [1] https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org
> [2] https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
> [3] https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

I don't see stable in the Cc list, did you miss it?

Looks good, small nit below.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/memory-failure.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3edebb0cda30..c9d87811b1ea 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -681,9 +681,11 @@ static void set_to_kill(struct to_kill *tk, unsigned long addr, short shift)
>  }
>  
>  static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
> -				unsigned long poisoned_pfn, struct to_kill *tk)
> +				unsigned long poisoned_pfn, struct to_kill *tk,
> +				int pte_nr)
>  {
>  	unsigned long pfn = 0;
> +	unsigned long hwpoison_vaddr;
>  
>  	if (pte_present(pte)) {
>  		pfn = pte_pfn(pte);
> @@ -694,10 +696,11 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>  			pfn = swp_offset_pfn(swp);
>  	}
>  
> -	if (!pfn || pfn != poisoned_pfn)
> +	if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))
>  		return 0;
>  
> -	set_to_kill(tk, addr, shift);
> +	hwpoison_vaddr = addr + ((poisoned_pfn - pfn) << PAGE_SHIFT);
> +	set_to_kill(tk, hwpoison_vaddr, shift);
>  	return 1;
>  }
>  
> @@ -749,7 +752,7 @@ static int hwpoison_pte_range(pmd_t *pmdp, unsigned long addr,
>  
>  	for (; addr != end; ptep++, addr += PAGE_SIZE) {
>  		ret = check_hwpoisoned_entry(ptep_get(ptep), addr, PAGE_SHIFT,
> -					     hwp->pfn, &hwp->tk);
> +					     hwp->pfn, &hwp->tk, 1);
>  		if (ret == 1)
>  			break;
>  	}
> @@ -772,8 +775,8 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
>  
>  	ptl = huge_pte_lock(h, walk->mm, ptep);
>  	pte = huge_ptep_get(walk->mm, addr, ptep);
> -	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
> -					hwp->pfn, &hwp->tk);
> +	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h), hwp->pfn,
> +				&hwp->tk, pages_per_huge_page(h));
>  	spin_unlock(ptl);
>  	return ret;
>  }
> @@ -2023,10 +2026,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>  		*hugetlb = 0;
>  		return 0;
>  	} else if (res == -EHWPOISON) {
> -		if (flags & MF_ACTION_REQUIRED) {
> -			folio = page_folio(p);
> -			res = kill_accessing_process(current, folio_pfn(folio), flags);
> -		}
> +		if (flags & MF_ACTION_REQUIRED)
> +			res = kill_accessing_process(current, pfn, flags);
>  		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>  		return res;
>  	} else if (res == -EBUSY) {
> @@ -2037,6 +2038,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>  		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>  	}
>  
> +

nit: extra witespace added.

>  	folio = page_folio(p);
>  	folio_lock(folio);
>  
> -- 
> 2.43.5
> 

