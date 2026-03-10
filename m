Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7DEFD4F19
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D5B6B0088; Tue, 10 Mar 2026 14:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D373A6B0089; Tue, 10 Mar 2026 14:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF26C6B008A; Tue, 10 Mar 2026 14:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF516B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:55:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0958A8B2D4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:55:36 +0000 (UTC)
X-FDA: 84531057072.13.1ED8927
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4CFF5A000E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:55:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XdXKjG+e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773168933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4hhpAu+Lbgg88oPiomDXRFUEx2pF1A+Y6zOQUFSa3I=;
	b=iAGLGdMIbjpK3T0qlQT+ngR1ShkxQUv1ThEVahK2VpZ/f0hIjQrc4WK7sBd+Mt8IZdm78H
	pXe2puSTqDB3noSF9SGAkH9I9N2+i1frl7VM6yO8N3giPvMXTM7AnGwi6lP+R2T4FR8oTh
	Eb5P6s7eNTFG8PJFr0OwHd8RZFKYhis=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773168933; a=rsa-sha256;
	cv=pass;
	b=4yC6XSqMCYgkLRAfKpKrZhsqYZk/eGd7n1pk8bWBKqJ43X3nGh6jZcNk2QMdxK6Y0bIYuA
	G93iy959AwBI22l+PSm1+UKxVpX0DMsJYKObYUgNR5054L2EWJi9bBC9EjlqWuj9aO6x5C
	ID2TxQSG/If0ztiESd62ghgCz7kjXA0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XdXKjG+e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZDZjoNufK87ceoNHkPKIHHY4PvZ5ai0kYCk8/4nEk8F8nH+Ra/i2WycVN47OHLyXyhdhI7uFJtw7x+L+Tfi1Wp7l6SlcfJMH3MgGW1IC5RGPqb4MOKrtXx0GV2EQPrCK4dfu1aiMoMK5Kf65B8AHJpyhh6DvCzyG7qjV+9ZIPNNNvoq4j3PaflAaWgqNEDQxoXJLrZpDCy5lJNYy/nDCvhGOUVq9C0cf2alm9JvSnoAWJWGmjYo2XKISFb8RTr+u/abOuG8YVqMW/ZxiPvfLVrigo7hFY4Cawly7rdfBiLLfLbBUxfT9FLAeBP29xN/n612LD0wBEuAKmcGqRkXyhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4hhpAu+Lbgg88oPiomDXRFUEx2pF1A+Y6zOQUFSa3I=;
 b=BzaPVS8qYi+qnfKQGugSPd66KSo8T+Hkg86ApdCXk0c1N1ai1k8UwpPuwjTG1gODgwzdK+ygSTuPFZZjgrm5peY+KYyVS5unWWMyPluiWmlS4P59nbAzDIzh62xII/anluhzuxmqXGKlltVPwiEIGejMN+DX3KolkvkTJ7TxWZDgVY1yyBdMatV8/8Xu74YFIMaN7ywuxDKPyKXoffMqkhKDrH6llo0aB9ik1MBzKkrzBkXbJIFf7iytsijiAZzezXSErcshJb4n0NigTi4jWXAmcWfrgC34xkkYdG/XYers8Gym6jX+L14piju5GFCvIqtK7RLesnNOaGQueIudXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4hhpAu+Lbgg88oPiomDXRFUEx2pF1A+Y6zOQUFSa3I=;
 b=XdXKjG+eph/imd7AWHwT64uCdFdozEdzGTvPjjqob4u1bwhD1FgQ1g7tCp/qlEmC+5kAMxVt/FOxuLd3RwE2f/5M74uwbLm30oebmsbT9oU6R8WxVClJ6/5wKi9Z16+Ude5r1Puwbw2iXJg8a1Js+/qxFvZSp0vtwBiJBwwTW5yHsCtZZ43eUvl5AQWSXhqydikNBwnxt2r/TjaGgYormk2ZN9enbEA1R3X95x9bQmJZ6ILPTlp7RtxgfGLMtLWfJqjGZVH5olCQzPRiY+nUBFP504xsXIiLYRKl2jeiALUXDMhaGFYSuyjbrdaAGhy7K1jS0XEWYtsxYC7v8WRsdw==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 18:55:29 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 18:55:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, Liam.Howlett@oracle.com
Subject: Re: [PATCH 03/13] selftests/mm: fix hugetlb pathname construction in
 hugetlb_reparenting_test.sh
Date: Tue, 10 Mar 2026 14:55:24 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <A17EA6E2-E083-49AA-955C-F731B79770E9@nvidia.com>
In-Reply-To: <19d011f1e9ac2e69c8885e182f8a800fffd088d3.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
 <19d011f1e9ac2e69c8885e182f8a800fffd088d3.1773134177.git.sayalip@linux.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:332::28) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a33c5b0-45a7-481f-160f-08de7ed698f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	UdCWF20hbfwMvXDRHMKZeiV4IpgH6nwmAFVqrScrlIcBK4PRzyj5HvpwvV1PiUcMx7VvbyQ4mscm2yMXOpWOsexSJ65HhFO5QGAlTaKGI13HvyUMDW75gzmhkUH/TVvmlENbS7MAj2k2qhWo86DUjpn14KXhSq4IeE1MUmHvGNK/uMJVMcoOC52NA1X5BA4Ym9e7gw/Pk8WHHrDVoS6NUrJrcwAc6E4QLjn2OmH0QENVZnGQieoYm8OQgSwLA9aoISIZHPKrFOtVlqVPdDqd3fk31yo0bDfWlg9yO4oF2h8gk0wVE6U7RgEsJmvzA5FrnynXmFjmBSA9e8Mi2tf46ejj8GnRmH4o/jaKT502VXCEKeGshDgHqj+mOPoOhlgm/oW7c2l5rsRPHaKgXM7BgA1LV3Mrwg5H79Hn2dA8iUzD6USEdpx5Cnqr4mN+EI0ZfzAqEaxtuCLSLLhPlROgbd1LveXzH1BjgJhodPTooJwe8KbPdn5gyZh+QDa/PssUaU5FqxO/NChwX3CfuYisKnNQekHwMk7IbDKQwOwFhwnaZd+zESYIW7KdZ4PiYnAqGLdzwy6p0U/qs51VDkgXRhLnMsr6tON8bBcvpPV+21vxjDEGRnijKJhicCcdDtkv0jJj28N4tnRoDn6UFqwoDc5TMmiV03JxDs9LcNXmtX6Ef9Cz6Jv8p0aQSuPT1l2T5ZwPurNJS5F3C22aLYiu6fzok1jRyPP3Wz+M4Cg6MnU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2cpvp/mHd7kiDkYyIJJt+TottGVM7WlyLpnkzWY6PitPJvMKmbW3zpdLHAtB?=
 =?us-ascii?Q?i3N3T/KzPQ0CnoWDlsIktNQg4EG2w9689Z/DKH2NF3EOc004flQk18g3btCa?=
 =?us-ascii?Q?lkkOxxWRNW2w4U2fq+RK5mq2ww/XAJDj5kNJQ/3ymTVJkeiOO4FQTzApTi0x?=
 =?us-ascii?Q?IT7mpI/u0jqeCH7NGH08brDE/WBGd8hZ3qCPBocug5NYTc8k9pXIgK23JKyF?=
 =?us-ascii?Q?nuqxP9c4uVTY876L/beKG0i3KA0lYcUZKJkEnbazZ5O+uTJNTHjQN2qxIwBX?=
 =?us-ascii?Q?Sts0FLUU1rPXtrHsY48sfNMR8DksqB9uX+bgORjmdfqrzGIAFsygTdH++I82?=
 =?us-ascii?Q?eCQ/HJ8KDFCI+nXWzf4Caaq06s1UgG9ElJAvDeLW07Ry46XSpFH/cd9Q+UO8?=
 =?us-ascii?Q?fXvWax5oLKpGicAoOWozjBgvs6PgXLgBS7c26YgjBXtFQCUJbivhQlkD+M9V?=
 =?us-ascii?Q?aGMhar3o8H0BBo0MK/gET5omYukTVkyoCgJGpwA5kPkbtQ8QAT5gW6aNmh1w?=
 =?us-ascii?Q?7hB2zww8j449xxE+gtUbuI+5oQoRfxIFkTw8isiyJCEXnLaVHgtsbRDrdS63?=
 =?us-ascii?Q?F12eT+UyW619TLlzmoaj2jJrLoEeOw29ZlaAXuEDG5O2yCy2+AHLZAlMMjVz?=
 =?us-ascii?Q?GKH213j8hn54U08g9mRDXvRB3f5U14H6eVjjhtqKiCrSy9+5Pwt3AanesMtF?=
 =?us-ascii?Q?lhfIonKjVC0xTKHNQMa3vVl4dCYgGBK0Nsb29qB7FKXp9iJ0maSrNKEbdTyr?=
 =?us-ascii?Q?0WoL5y4vRe5M4iMgQxp74I/M3SGwwXnRe9wRtsF9kqwRhvHH9xAFXSl6mXai?=
 =?us-ascii?Q?fc+op5G6Du1x7hd6/Xc/yOBVQ9OCrsR6zrsi3L7Um62Yx6vvZBPVBBxthGv4?=
 =?us-ascii?Q?Fut0gPVj2l5eOt1qszlvp1kPtYnbydX+jvWTdtxUMfJ0qFBa+LJ4XVz1bd0+?=
 =?us-ascii?Q?eUt17oPdhjct1fWErg7KLmPcjkMfiGafYtFQz7i6QqdQjbam2rzztm2Zr8f9?=
 =?us-ascii?Q?Ylm6hsIjho5fl9npJJAqiHggbXWwsHo3Zz2afx9pgAARL79D2nvsw0kjs8yW?=
 =?us-ascii?Q?uA/AT+LQUivVVrKXAb5z90xgmC46nltxJS0y5lsHygb6XMV7EeIBWDrchBfi?=
 =?us-ascii?Q?r9Widr/QpWHYlLvux251oiYuJu99tafFWAn2M/FwJMLVKaufvpd0W50dgy+v?=
 =?us-ascii?Q?3n0sDvCa5ZQchH6DIpOl5is/vTJ4gWJ9pcCmDlQoEakZmquI0ehocxEhx6mU?=
 =?us-ascii?Q?ehk3CaDfmlEmElRXcxidZIy3Y5GGX5IA+MBSRs2jB1V1V9EAfZNYz3anvQXg?=
 =?us-ascii?Q?O19VUmTseUpA4LAsHxaHUHCRhqD4KWQqq5h1CptEAP7qAP/j6PTC3fJH+v0d?=
 =?us-ascii?Q?7SvAv5kGRydBllQ6bzd6phQmUxSNWqKTo4+WkVWEVtzu+Yyrdak6ZjBHudAi?=
 =?us-ascii?Q?FS72gDvF9O6EK4sM4RLmUgOvSwkCAYdp3UwoSH7yO5ZMPo5scXCI/Ign0spI?=
 =?us-ascii?Q?yu+pd+PRowrVx2/1/wLx/etjNuQ6SIXBcqgmPrCsLAwAgrakoeIhwX9RuaKS?=
 =?us-ascii?Q?eNBVfmPYrJhmWEh3094EOJAh0r9sRms9zd6boBJjoZmeIVRbTEFrxXXWyXo8?=
 =?us-ascii?Q?t3x0W3/S1bKQagTeas7FHEGM/onQeW35m+XmHU5TRZgds/EuD256xAoTm47i?=
 =?us-ascii?Q?VrDV6LsDb+8oyBTEFKrlNZY4nROQCyuj1ctLEjAatJrGIQZ8kr9FgZbi31W5?=
 =?us-ascii?Q?oFi0A76s4A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a33c5b0-45a7-481f-160f-08de7ed698f2
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 18:55:28.8475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0e/T+N6pSplSn6dooF/6Yl5aeryHOawF/6skEjn4T5ZNt1B65IGPik0eHFJ19EBx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4CFF5A000E
X-Stat-Signature: aus6yakpq9jz7oenbs61sthbup57biuf
X-Rspam-User: 
X-HE-Tag: 1773168933-451033
X-HE-Meta: U2FsdGVkX1/ibL3rHblYaoPl/mQLfvCWyAVp6Ae/BwzsHR8Krml6etjkFqPJQIOXK9bdl9A+GOHMVRY8/PSLVDrWWWzDt6ZVQtRegxwLIozZfS/ihAWTawxucgAoDbWfLnZsfjfuHeV9KHdxQGENL9pDunRZRUqnsT4z4wCrLzLycMFF1xRjQARNXQQJIGJ4X/IlSYplhQJ3005BNzaTHsZzN4nq3SgjkaEECcN/4qO9YXS12iU4hCKqfwqQ6kqDkTzTwFMD9jc3+xzsm0uQeyZA3Py/DRl9YzR0bQTn3Di9D+TKXma1fec0X0pKNRFj8/qGaANdQ28YhFLesUWa+E3zTdtrLEQBLXGNMFqmI8Xtc03SyoSs3bJq5854dMm5co+b+6bukVIIDlq3K/JlSUCMLB3HUk4SP+x+BI6VMsuTpFkrirGV6zE0Ema6a9COvxiFrFJGuy1xtfMipJJCenmWkxcKJ5yhKqKkkKuJdnvoqwNnyiJlrou7RtVxx8k00D9bWH1DxZkSnQuyYlzf4WejFnK6+wS0HJMQ+MdQkdOfhyc70znPpuHjZNrb8UBdbQHR3qAJe33P2XoRuRLLM1OBYWvxOReKBdAxa80gb0ZljoIGRQ5xOsJkojiC6PgQObgYNAOPzQFxOgAJVuq0taOp4sZ7Hgez8jaRicJBq7CffBhLivEfOE6z+5Xi89bp/tZVIE9RBx3DoARU3gz6CZtGlDtgvAt9bVvN53C6ISeXGcI3b6Ip6wE3A4eywDLQa+G+MtE7xKvy7bY/3hHUeOf9yW+FRQDn/DUeU//+2hBWe4RcMcpFf1CkyyeIUTHeEc4JMxgHQdSFmfE8vXGYGjh+kgM3zpYFU/s7FU++nJU5vD7lUaoipM0lM7bK287zgXZp5wEK2pZh6LPXeazXnyvQlpMwr0TKSVSHlJcQXETt0sF/JSniNz14hgzQruyfig6JfyQIj4PzeHlxPCI
 pOqeNj11
 2VAnPMoXuxDVW95zNL67Zo+wFFk86i5Or0WUj2yb/CCF3uk1q4lYqXxj1ZBA/BUGzQ2rpM1yGRulnw5AvbJPz3e3inbssOxDgoR9PCTDKvqVkXaFM19ZG3bQwvh+k5wXnNAIl83fe19bkg3ZDfq4vFVuv/hEh9Kzar6uPSDQNyw/538G2tlUoCnxnHpaSg9Vgs1gbTcbnv6Icqfbi2r60oVTbazlRTLNVEkH919+QY9hxQO2qoVwe/fZxKUpST6C3fTDbPCjUnudLsqcOVgXDybJYEQtL2BcaRWnaRTJNpw45S6inIo6aqmhv8KbdZOZZq8K/GwsWByHjVQBAycLqYXRzeTxDqbjv9tOSD6M3jc7JxlN9taCa0LgGjDOBJoSxKlw7N70hkiXY6oOAPgUdu1UurpIKNAYcMU1vRYkYLaAGz7XI1P8j4ayPTReXEVIboi4xd5hmj4IwG2kaa9bwd42srakCIjIb1ECfSO9mRIpw+IaCj6jWSldUDm4jnTZU5abKp2Oy4Irw8vkGK4ArIHJlDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 5:49, Sayali Patil wrote:

> The hugetlb_reparenting_test.sh script constructs hugetlb cgroup
> memory interface file names based on the configured huge page size. The=

> script formats the size only in MB units, which causes mismatches on
> systems using larger huge pages where the kernel exposes normalized
> units (e.g. "1GB" instead of "1024MB").
>
> As a result, the test fails to locate the corresponding cgroup files
> when 1GB huge pages are configured.
>
> Update the script to detect the huge page size and select the
> appropriate unit (MB or GB) so that the constructed paths match the
> kernel's hugetlb controller naming.
>
> Also print an explicit "Fail" message when a test failure occurs to
> improve result visibility.
>
> Fixes: e487a5d513cb ("selftest/mm: make hugetlb_reparenting_test tolera=
nt to async reparenting")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  .../selftests/mm/hugetlb_reparenting_test.sh       | 14 ++++++++++++--=

>  1 file changed, 12 insertions(+), 2 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

