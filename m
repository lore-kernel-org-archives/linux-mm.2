Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D34AC87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 19:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA276B0099; Fri,  8 Aug 2025 15:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1E46B009A; Fri,  8 Aug 2025 15:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79B86B009B; Fri,  8 Aug 2025 15:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAFCD6B0099
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:02:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 386D9115D30
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:02:04 +0000 (UTC)
X-FDA: 83754510168.06.1AD7F1D
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B04B4000F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:02:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OylgqMeN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754679721; a=rsa-sha256;
	cv=pass;
	b=tug4FIobAEaLWgXyTpMSoj0umfuXqOQl5nN6VZIVhonhYgHA7BAceMWN2Se5aYoGsR4+4N
	7FAvol53C5Log3TS+tgpQrpbm0JkHAJITCeo2O/OnQTrCXyIr07STb0TCQeosnvrWcJWf7
	0Kb6vf0s/fOnucA+ilRX0vSQ+GvzJAU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OylgqMeN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754679721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BJKspbixPPXsmP8d50C2hsdP4k+fNidziJpBCD5eP5E=;
	b=c6MRMDHnVRCJxsS4SYCUryYVFycOa1T3sbS7GNmLdAwgZBxQWh0+ns55FmOy6zgKD7dCYa
	ZtWHk9JOqi3D5jUs2hnZMaXLxJUgVd1M6GlDQXh0p4i4dVLSz8VKQdJjEVNsfV0mUXncxV
	gcZQl9pezUIJbEVR7AW4tre/ArnyHpw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/tYmqgC9K5ckU0R4ginLRmNYlnv1HTQ2GZYgX+o0VMcGJiIiRElwZVl64MM0Nq+wh4JVfIF1V+2AJhQvLAA/fzJPtn3aIL3zQJUSeNNTKBEHixVhf1YlX+BktNxpvx/mtwrjNwFTIfmtxENSAK634f9DJdLXOIwbgsQwpNfyP58VL1a63CDOzasHOPH5QdSfFrH3e3tZn7HAPO5DCVDXBPKZ9nN4z5HyhRo4K8WOmOXnNTjRtwwTm3FnDl4ibBSFAvBawz35gCYQfs4F6iE03k29ShzW8sStTPjserxFHEjPi3S48eT97Q9bIp/p8AqifI7r1IHxtBLC5zTLvbnAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJKspbixPPXsmP8d50C2hsdP4k+fNidziJpBCD5eP5E=;
 b=T0XWMlTE8D0wtIHzApmeCs0TPa2mWgmSkhLTpUrQ+1oJO5xemtXP+vei8xonNiWHcyIQinqrBtevVYC/GMOtFqKuKHjZmqFNXEL6hBheGHultCXolrvXPrsJBKGTFuCbPgVeEYTWe/GZagQlGJDlkWzbaMyDK3Zpbm4kdRWIkSHls1ktdvw1MnqqUkj87YU5rRoFzZVRRkuh6qgNCb5Uraf81nFHTpBvavEgOeYoFySUwjojXuRPFwGKtMK62tprJLM/zViWa/0XaVbxc+Z26ddalYl6/pqoat5yN5Dze9syKpghCAwJ5K+OVr+gNZkfnZrE+Ae5Ze8RB/zEnPGZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJKspbixPPXsmP8d50C2hsdP4k+fNidziJpBCD5eP5E=;
 b=OylgqMeNTdRrg9vTWRIdiVgB8XPOTvt7H2hjDIH7CTFI94XUzWlXBh8N3c6kGTWWS0wm//muE0jHGafl0mJYAttJ8I3Og/XL6Rey+O5RRR1TDI3NcqDMPCU6pJsWslE49+ZyrOryadhzovMlIKXp0Q9HXzcko0G3nIUkL9E4d9k8zFyOyORoy5S7EOejqXHal9GbgrmVYGj7mGoYdV07RFpRFGKRgoP6yvzpnNdg+VMxr4S/4Q6okk8CeGMOyXnq0fvGuTcQ+ED0f5TI5AclPLwfpLanN9z5StT9xnzvr38BAOHw2IKtG6R3z3+A7eTiXb6J8CCIiM+w/8AcYRgURA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB9090.namprd12.prod.outlook.com (2603:10b6:806:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 19:01:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 19:01:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 0/3] Better split_huge_page_test result check
Date: Fri,  8 Aug 2025 15:01:41 -0400
Message-ID: <20250808190144.797076-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.47.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:208:36e::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e09dc71-409f-4c2b-b16e-08ddd6ae0b8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rWCKwLUNwh1tq5UnknGWiJBP+QmHAmKAoQ+u5ca52GM0md0KsgGTcPgg4Aig?=
 =?us-ascii?Q?vpdpS+FrG8q6G2X7w7K9XU/pWJgZfIquymq+Wxw490V6jRe4m3tS31YHu/ph?=
 =?us-ascii?Q?MR/UCWqyaOWdaQ0oem75rnTUP2kq6NlBZkxeLQ52Tjujp30Iwvi/Cdu9rgth?=
 =?us-ascii?Q?pKfT3LH8AIhRpRvqKCHyEA57dAi7bRa4RHadKEIzRiXWF5pOCQy1PqiS/LA0?=
 =?us-ascii?Q?XBGPadZiDRTkMiQWwrUocK5oIPrsCJE6ZaZu7K4L/xZRQGAZ4KunBZVqCosG?=
 =?us-ascii?Q?UYpaJmjmA1AsA+lwMGtfgTaA1o2+Dgh2shF6y90FBgcw90YPyjc4WVzmX1sL?=
 =?us-ascii?Q?KrpudV5TLNvfCt6oRtDWFRfYyhAm3fXaHGJ4lX2u5JsMcHjNg6EeYTblREnh?=
 =?us-ascii?Q?AD1TQCXakSwj9qFO8n34oufzz7xp7LjeaaLT8TczL4JPbmFbNAuO+3WYsmHY?=
 =?us-ascii?Q?NqM+U5KMzhDkqM0MGXPtI9s0mqdWMgWEbAoeB7yG8yS67d3plUGuz93IPhnp?=
 =?us-ascii?Q?CNkseftq/rYDY9J8oIi2T1W6VkYgfChjx5Oea6PBBcMLNkNdO2fYbfCGG+Ax?=
 =?us-ascii?Q?r0AheTDvxjv1LZVwEOGFaoqFMWOaBCZVC0/xMKFy37w0NqGYoDsPNZb97o0r?=
 =?us-ascii?Q?SmIK1QcdoTLiFxmHcB3gO1TzTw5xe4gwrmLcWTZSeWfCVaPFGoOOCy77u3Gl?=
 =?us-ascii?Q?7up3Cj0mtw9ZREVvJ+Y8UYP812znQ+BU+hPut9f+bj0tR+3XNWEwF1kLM+LO?=
 =?us-ascii?Q?VJh3Nd0GoptnWN0d0i2phjIIE1/nWHKFtM/S7v7evQpOQjLpHGkgexR3nsDA?=
 =?us-ascii?Q?sKZCtGJKlt2uJ2VUHEDHq9teeaMLGbZyYCEcSfb3mYYIZUJKZJ/Eo2NL+Qyh?=
 =?us-ascii?Q?j4ZZbVGVdqBG4gMfcTuLAni6sRdgpRlQzS1gJzuJ13JLse3aTBs7A656CXl9?=
 =?us-ascii?Q?q8lwrtC1ULdKoHbPIa0kFcvV2FLCyE6ejEVdj0FCagOycrrVEu0jPBihcypf?=
 =?us-ascii?Q?PRyrHqR5Emkosz06nLJHd3MMHCw2+GIWdEN9RQV8i1PvC9QraACLfnYdMeUS?=
 =?us-ascii?Q?E/tarPcxTiDKHhZ3zpokCxcGNgvjtTIjxVvLuVWLFVeqSIg1mhqgfNNqSs1s?=
 =?us-ascii?Q?9QIRLC5qhTsV1Ur7KP8BCk81bF9xTGo9lR6tigm0E65Uj4oPCVerQa9PxEDV?=
 =?us-ascii?Q?hZKiPMZOZexa2sMWc613YtQJ48rEls2IrhusRhpVhs2TRubggonguy250n9u?=
 =?us-ascii?Q?zzUISgOVtmZRYZFWG05zvoa4OQ6vjZixZXADlpuoBYLbKDeGP52g2LFeQbtq?=
 =?us-ascii?Q?O/0ZXmENaUxGH7CLkB3q6362NcVVUWA6x2tVlnucNChHVMCqTpQk0/VOhELz?=
 =?us-ascii?Q?qtOTAgLvMIfzPetjXhrLuspDEUU3XcJq687N4xKwIr6W6oJXpBue7+fpqgB0?=
 =?us-ascii?Q?DxiKZNsX9Vg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0d77mHUp6qqpCwTaBx3Y3iB5DheGk4x0mXkiFwAbgSq3J1S9ZwnpRIsKjp8R?=
 =?us-ascii?Q?TdU+sXk8yuRr7zVRCIOZkpZZtI9RbN7tbibjS562IfsgBPrv9xduUBZw5+pC?=
 =?us-ascii?Q?AKx4kp6JJkTXul9M/uY9c7+6hwcTZT6JT14DrFAo+snjx3MrCTq3Tjui9bvL?=
 =?us-ascii?Q?9FZRAIwQByVJ1rYQhcE6MLtGBEQ9ArI0eMHJQ/NsSVqAtbEteS+43vYwaNY+?=
 =?us-ascii?Q?lc8+vInU5FEjE+FD2pgJx0HTYFm5hkB6MYuL2iHyZhuTI0ypFX5mSrtS6GTx?=
 =?us-ascii?Q?3htkritUNnBG7XoYe3fCNmlMQDcMOr4YmCugY6NW2YgOShXCVCT1bf/GyI8Y?=
 =?us-ascii?Q?NRWJASFzGATYzNcTAgRcMfgvVbR2MfN9k72qR2nDMGMTeaTxsclN2jIQZRrm?=
 =?us-ascii?Q?/vsYh5WzFUO9dceEh8010vJogoen0eFGbwWuSwk/4IGdqhlrfgi1nAvs2wR/?=
 =?us-ascii?Q?RWbu0uPAbLYushNxnWHLJzao4yOoT2niCvzruImEpXaBZy1pVoFqTJ8qeSe1?=
 =?us-ascii?Q?VGnwmkMIT32IP0xC//w70v1wyU8z4jU0a09P3Ijdi56OmUD4QuOXGPOHYOOv?=
 =?us-ascii?Q?cZ232tNkIX2swleg5fvohiBq086/Uu89TSmY6BYJDo1ISObRlqfTvQDLzEmU?=
 =?us-ascii?Q?WGL267xLM7hpeBqDAM70dxdlrxWeX4oDDQH4JaPJNtX3NtLwp+Irrs2eenjP?=
 =?us-ascii?Q?WWwHnQBqpA1Jyi1XP2bbJv1SYhKZr3hwmWg+v/AFFE5dhjhfEuKAVdTnZUcV?=
 =?us-ascii?Q?mU8ik3nUI5LJmUSjaiKSMFmfyByeoLnhmMafiW5UzpEPqz5CFfU+0ShC8n0g?=
 =?us-ascii?Q?pvPPgjXgjLrI2CaORRlZqaLBSsEvaOYK9UKEekm8JxYdbF9mJ2mw4oaaIGFv?=
 =?us-ascii?Q?H1CQ/1TueCLJfVIT/8Ol3n3beneQK0/3CpfWpa6niHZZyQwo0gShkKxBfEyk?=
 =?us-ascii?Q?KzCbhhDcZaA2Qdsf+RcL1mouJgiyzq2S9RU7B4808VyqtOe2IAnItqzKmJ/e?=
 =?us-ascii?Q?/6LXvgu3VTkBFHQg6lztr2aiQgjZzGfo6xhGLRO59uudxmn9IOwjG29Ktq7k?=
 =?us-ascii?Q?p9cNUXcO4tr0Sy/RBdnzYxo5wSDG+kJZg0B+aux61oKtepiwjDNdnWnaRgO6?=
 =?us-ascii?Q?bEzm66lDESnSEtj5uu2ayX3nEfxNgK7WB1HERuxyOIjK2RPJ/Dt9X6j078bs?=
 =?us-ascii?Q?/ITzi/RDWm9tsZOIbbliR1fVGNXRdoC3C2DuonGORQzCQnumMLWM/1zkRQgq?=
 =?us-ascii?Q?QQeDkjENST8I82RIITgAqcd0g5UsmhLAQSYuf2wQ38LI4mxft5EtjMkfPqIr?=
 =?us-ascii?Q?8i4zZsx27Po/+4wTW/t82XUeJBYfI+iVjJz3If4B1iZ2qvzctQo4dzqK4MgW?=
 =?us-ascii?Q?FRuknrx7IL4Fsrk52tHL9oLsKRo3WFUOf0yd1mLq2him84eIFY/jLUi3cQsL?=
 =?us-ascii?Q?3ve0C6BCAiNgFLIo1+lwdelfiTS6rnq2WM9YBDe0Ok9ZuXDF3Ae2VAo3Zp5o?=
 =?us-ascii?Q?lGp1zTAqH8G4jd6MpeUz5LOYuxIGxGNc8P2giDW2vdME9HHM7vwndBtxH3eh?=
 =?us-ascii?Q?RB2xhxZ1eBTwIWRx5pyCytzC9N4NgvoG2mcgyk5I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e09dc71-409f-4c2b-b16e-08ddd6ae0b8d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 19:01:56.4274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgQbHIMX4HNY3mz5ydyQkI7LjQjsK6ESTNpnLJ624NQ+2HdMN2m8Wl95Xrp4BXjL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8B04B4000F
X-Stat-Signature: af9913gsduokipbwna9wac93r4m5o7n9
X-HE-Tag: 1754679721-154716
X-HE-Meta: U2FsdGVkX1+x3PwsqIqaAbit8sBIWxu9uV+GQUjkKLYTm45+NOuvRc+qcGiCVp6fvRrgjMfWio9XTS7Vj/sMuAENAR0fxJpDkMFBMq0JBDTMc8BtVy2dRkrbu2hlfsPJCDGh22FXVa1fxXdPwdp3d0pU9Z78D0qN6f6dq3QLhdysRyAWjy3qBUA14YXWYRSzVjyKgpM9BIRkld2QfZHmZWlycYFMYOSPBargHL7KoZdp3sDtjiFPkY0yQbY6652SDpTikH/LLfzpZMR4z2ULmHI44m1YitCl5gF3/KstM/6PBhAN+Vnn7kuiaYx1RT4SVdyokPzqE7MzbaXh9KKX4ovi2+gtJKSrQA/2zm7PdE344zDuKSPibdprtfz8dt30GzdmHi8ucYzKw4zckrgLkGdH1EclHug8cJfyIjB9PsjlBQQ+9jYouOy0RpmOdQd3/9aaC6SNDGFs05bNWX3wKZRRcrgp2kJBel+zei0Ti7GQWxlkys0SyB9rqldWXQ2TuEGuN+JJq6uhmDdP1ewOsItiwjy+MvdiNDDYAPSeOvKHVFL2jTYI7SInSgs9myA322r6mnQ2NIwlZQ2fWEjN5+Liov4jr+4P4WQ35TQvYq7CR+W0muKEA7l3Y6vT2OzZPDtCLmdxHt/67Z6PZ8WLVBksQOUH2WhfjsPeQSZ10t72NiE05FC+2CBeg6wZBbGcAatD6UqJpvjaI5nn9bZ5hpi5aBNhMaV017sJUevr8Jqiw/CVUjm5UmkAcGVHqC6agYRM/Uif+LNFJUU2Pw8JrbG+eHR2v/lzodefwU4lFRq8TG7QsceII4VuCxt8zkmXWgyKNNOxMVK8U0UHpEY3s3LfU3VHYDyg6p5JMs/UydVUzWR7ajiXn3bdIcfO0PRksk0aB+8CB160eEKahAmUvY8d8K24VhvZ//PmUAYlHgG8AvyVmeOX9BpwVYssMkZ+LixxKFR4p5Q+/c5LUua
 ovlHSIaB
 bADuosVCXHi6Njv4pipz92+zmT53ISZRqXU0tZ4lqh6Y/tWLk+v+Dp2FknRr/R82Ogla8/pmVflZQUvMdP1a8iqRUpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset uses kpageflags to get after-split folio orders for a better
split_huge_page_test result check[1]. The added gather_folio_orders() scans
through a VPN range and collects the numbers of folios at different orders.
check_folio_orders() compares the result of gather_folio_orders() to
a given list of numbers of different orders.

This patchset also added new order and in folio offset to the split huge
page debugfs's pr_debug()s;

Changelog
===
From V1[2]:
1. Dropped split_huge_pages_pid() for loop step change to avoid messing
   up with PTE-mapped THP handling. split_huge_page_test.c is changed to
   perform split at [addr, addr + pagesize) range to limit one
   folio_split() per folio.
2. Moved pr_debug changes in Patch 2 to Patch 1.
3. Moved KPF_* to vm_util.h and used PAGEMAP_PFN instead of local PFN_MASK.
4. Used pagemap_get_pfn() helper.
5. Used char *vaddr and size_t len as inputs to gather_folio_orders() and
   check_folio_orders() instead of vpn and nr_pages.
6. Removed variable length variables and used malloc instead.

[1] https://lore.kernel.org/linux-mm/e2f32bdb-e4a4-447c-867c-31405cbba151@redhat.com/
[2] https://lore.kernel.org/linux-mm/20250806022045.342824-1-ziy@nvidia.com/


Zi Yan (3):
  mm/huge_memory: add new_order and offset to split_huge_pages*()
    pr_debug.
  selftests/mm: add check_folio_orders() helper.
  selftests/mm: check after-split folio orders in split_huge_page_test.

 mm/huge_memory.c                              |   8 +-
 .../selftests/mm/split_huge_page_test.c       | 102 ++++++++++----
 tools/testing/selftests/mm/vm_util.c          | 133 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 4 files changed, 217 insertions(+), 33 deletions(-)

-- 
2.47.2


