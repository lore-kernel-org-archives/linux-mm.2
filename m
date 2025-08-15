Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA2ECA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 11:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E32900245; Fri, 15 Aug 2025 07:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6708E01EC; Fri, 15 Aug 2025 07:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2832900245; Fri, 15 Aug 2025 07:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0A5C8E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:37:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BCEB803F5
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:37:02 +0000 (UTC)
X-FDA: 83778790284.30.713DF57
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9D13140008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:36:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cU6E8EPC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.59 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755257819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cf0obU2TIFIq1SG9gmhoIop9rtkn7M9JfH+fIzO1u+o=;
	b=sKtVJMvVjbbc5aX9cNypSLWhJEDJnGmF+C5qgKOWxI1KqPEUC9e2Q0jXf2lRkRHIo/rI57
	gMljkiPLX1isSkE++wpFzLIK4MareXk7L9Oj93cktafNx2VRepRm7ibJ3xWcv0gIpeo4vK
	cfjnRhQiwNITxSIrACYxy0+EhVDQI+s=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cU6E8EPC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.59 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755257819; a=rsa-sha256;
	cv=pass;
	b=wTSXq2f/6XypbrBnNOmgpes/nRtO2Q036vFKVwISLrvp3KIX15DGe457ilh/mlPj7OTZx0
	19ky1vF42oxLks9hlUGL+tgOnCmkqMBDRV2G7mZyzaUuew/d+kENKnymWrDAR9XE3fYWCg
	rfXd8F/LfFanpQGAPun95Fc1El8UhYU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ki+qISV6pbPP7HqORROgevp7h27QObMEuk9MQC/AfPEySKcqqh8gc9V1vr8TYVIsYhqiqBqO/OF4dPPbyj0GIY+XKqfqilFcnzngTxRZETK2doaRfr8cJ0zJDAuc9R1uITO0pYaXuhXqzvkHF9SsP/W8YMHksuUKEkyLcRvo8w9io0EQzpL+Lduv7iurdpv/NOz7JHltbpJWIQbuUPlM99aY6ONxFsRa3HdFh+nCoTf4vEvGUShL4dU0myyNcX1MXWY6TDihPT7Q9a0SkxvR4eyY1tZp4PBWH14bYE/asufkKkcSGXVNHliggnAtLm9Y9B/3m134OGo7C2uoMbGVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cf0obU2TIFIq1SG9gmhoIop9rtkn7M9JfH+fIzO1u+o=;
 b=zFhABk8pzuz78oQyN17Ahl77R6AiVfxioiKCdxfOJh01ImP+k5DSNnPo+LXfq9RPTDqvp2Pz6hbfIBzXA7R+qp4YYgHTo64tV7waAeJ3u9EQIeHlHq1JHIcUxstwOjV55M0mmprsA6aLJPqrywVWcyUYgcc1kwnW1fOfV38VrctIgo4BXDGJS1zQn+zNggRpookUNak2u4TpB+RNLDzdgOdhjdrqWTF8KBmUIeitAZtvXU0aW5XmVuYicFpbunOA9OYHz4tO5lRDoVuZ0SGw0tchyH6bEl/271TaoRBKWfccp7ReY+q/4NpSyieoMf2ubHJHD797+ZwIsq+fI/JyGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cf0obU2TIFIq1SG9gmhoIop9rtkn7M9JfH+fIzO1u+o=;
 b=cU6E8EPCMy41Z+qi4USLhTyQDBO2wAKXBep1LJcqsfOGeAl0ivwke7iubmJBRx2PYIEU9nyTNH+YtXiONhVRQ8o4mobWyP5V0zOcIvMYTs73ikAroJxZr1H1P5BAi/Au+gtbwpB3Xru2RSuwNuwopV1S4La4bPuXX5xLqY6mjeEef5c6VB/qamh8NByZW3CeS7LRQgejZgVfkJlJWbSGXDi3n5olHzOZ1hPEC0BXbaZjNl0NnYk/tE/JsRsNhhlO+gVkylKgEp4GnHfB94d1fragUKwCpcrSm4PFPLXJfzQaX+VZq4s2Iub8a/PthdANJzDJx5ZqMtvnvoKCStY3Rg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Fri, 15 Aug
 2025 11:36:56 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.9031.012; Fri, 15 Aug 2025
 11:36:54 +0000
Message-ID: <e57cfe5e-2031-422f-9c50-f5a03a467cb3@nvidia.com>
Date: Fri, 15 Aug 2025 21:36:50 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] Migrate on fault for device pages
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20250814072045.3637192-1-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:a03:167::27) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 79aa57ab-eef1-4128-cd96-08dddbf00911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGRtM2dXVXRvbGRpcHhYRG5ZNldyMEdoTk1oc2Q1a0JsbFBQOFVPK2JheWx2?=
 =?utf-8?B?d2c4aDFjaGl3eXl4MTBQdlU0d2F3ODNKS1RTTDdwL0ZxQjlUUUx3ck50L0VP?=
 =?utf-8?B?R3p2c0tnWnA0L3NvU1ZUOExUMWxORE1vZ3J3Ny9uWlFmODQrak9wcm1iaTdI?=
 =?utf-8?B?Mzk5cFMrNThzeTFtRGNKd01jT21DeGpoOHJvWHl5SFJMRkdvc3RkbGFwQjda?=
 =?utf-8?B?K1UzNnlZSEhEZ3RLWmhWdGU2T2dWa20raEhDK0pkTFYyOTlDSWx3MHRiRUZU?=
 =?utf-8?B?eE5scEJvdzZQN0VMSkJmY2p0U3VzUUtPM0pQVTRFRU9peklCa2oxV3RjOGNM?=
 =?utf-8?B?aTQrRGlTS3h1S1kwVHhJK012WmJnRnc5UWE4eFh2dkZidlF5WjJPdXRldEtq?=
 =?utf-8?B?VE1QVnBCQVgvK0xYTFNlOVBTZkNGUUcrL3NadUZWUXpEaWxiZzFDSjF3SmVY?=
 =?utf-8?B?VE82RVBTVlZxemhTRS92OWx2TkNCZVBNeDVnckxFWXBjUTY0OEFwYXlsTUVX?=
 =?utf-8?B?d0hubEVjZHgwTENLVkx5MGFIMmF4UURtSzQ0Q0RnR3oxME5rUDZleUU5M2NQ?=
 =?utf-8?B?R3U5VmhQOHVubWlDNm14S2VqMTFGbU8vTkdrTjUxVzgrZWFmVnN1b3creVdM?=
 =?utf-8?B?N285ZXhzTVFvWmpsanI5YlZBdVNpM3NacEpZY2NxMEtlMWhRS29HSWVaQjc5?=
 =?utf-8?B?ekU2NXhCTUtGZXdEeFZ5SzlydE5pSW5GVU4xYXhLV1c4M2lmQkpHcXUxSTBx?=
 =?utf-8?B?U21KNlVMcnFwdFdjcEdjNVNBWC9kbWNDYjA1RytJSyt2SnlYWWtDbzkrYTFa?=
 =?utf-8?B?UjVIMS94K2krQ3lOcTZ1b2dUVWxSZlY3NzdFY3RnZW5aU2RacUxOK0JTUUZw?=
 =?utf-8?B?MlU0a3pQM0lPeUx2Ynh3R0VMWFMyVUYxUlpzMko5Wmd5R1IyVjlUQW55cngw?=
 =?utf-8?B?RkZ5L1dpYmFLZ0d0NitYd25GdnVid3p3bVhXU3RFYjJpY3VaZktXbnNZWWg1?=
 =?utf-8?B?VkkxQTV1QUhLNEVkTHhYdEF4dUNhSUNMdWtialB5ck1BRC9kRXltV2NQYXJK?=
 =?utf-8?B?UlRtWVRaNCsxZXFNcW9iUUJtWGZIeEdMQVhyMVF2MUUwaXFxbUMvOWlaQ0pa?=
 =?utf-8?B?NCtrVVpweHZVVzI1eDF5T1YvOGFEZ3pSaWc2R3VKSFVuYzhsK0MzZEhYNDFr?=
 =?utf-8?B?UlR2a2Z3NG95RTA4NVpXcFl2QmxXYTBPR1VIVjh6bmZqU2tjOVR2SVpRaks1?=
 =?utf-8?B?R0k4eDZWdUZwaXF5a0RJUDFLV0N6OUx1djNxbmxGN0Y1TFBDNGxUaStmb25Y?=
 =?utf-8?B?UDZIRWdrU0dhcXZFeHRlOFlWQXVaYUsrTjZQQmIwaVQ4alhQUGlER1NncjVh?=
 =?utf-8?B?bGFDN3lKTzVYZm15clBHMzIxTWxSWCsvalZqeXpaMExqVU5XSTBFd0pTQ3ll?=
 =?utf-8?B?Qno3L0tTMGZxekpxQ2paNENqaVZCRE9YRG5qOGVkZk1vTFNsdkZja3RJSjRw?=
 =?utf-8?B?Z296bWhDZk9zOVNGcUhXUG11Wm5TZ01DWkVPMSswMGVkWWkvSFFoNHZOYmdI?=
 =?utf-8?B?VmcyblVSUGE1S3UxdEVDcWhrbkpRSEllS2NZWHJibUN2RXhvdVNhSUZkaXpM?=
 =?utf-8?B?UEtDYzl5Ry9PdzNKQVovVDRqdU1ZdlpnR3dOSlJBQ085cnI3Uk9nYzk2aGM1?=
 =?utf-8?B?UEdqb0Q4YWZxb1luUVdWWGhaeHBlZ0ltUWVUVEVreWtVNHNsSFd5cVdYdTRT?=
 =?utf-8?B?NE9jYnFuSC9hTWFhem0ycmsyV0ZIV2NrZjVySDNLbTFBcEpRTWg0S080Y3gx?=
 =?utf-8?B?bjU4Q3k0bTNiWUdoSUUrRVYxYlE1THJRSUE5NDFYK1VqNDlvUi8yVHYxRWc3?=
 =?utf-8?B?elljSTdhQUkydlBvYWRWUitRcmo0SWFGdzhBbU1iQWlGY0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bENrMXBjMjcxaHIxNEhHRWg3ZDZkaHBUYjBaVFdDV1c5Rk52NEIvVlBBZ0tn?=
 =?utf-8?B?NDhzVyt4azV1OWtrWnlQTXV2UlUyT1FqclpiRmZTMUswZkFNbDlSb2FCVjFG?=
 =?utf-8?B?WFJicng2bys4cmJSQm1TaXJiNlY5U21sSE94alVDY0RBZlBZaUZTc01FdjlE?=
 =?utf-8?B?YktGelgrMk9SNkRSS0lTSkx0TG9objhadnR6NjBLSmNRc1loM2gwUEtDRFN6?=
 =?utf-8?B?QU1FaldxbS9OQ0VyRlA1eDkwQ2N3T2xDTnk0UDhPMEJRQXgvdmNwdjZ2R3Fw?=
 =?utf-8?B?bTJ6SWJ1cHVza3BwMVBCWFUraGhReldqY0JBdE9LRWpoMXlhRW4xZVo5OFRB?=
 =?utf-8?B?SElibjVXUWxURjlhZlNCWjd3RURnbXBuOUN0TFhjUTFIZ3R1ckR4N1RhV1da?=
 =?utf-8?B?TEVlcjU4WlM5dDJHZys5SXpBSW9BK0xFNE1nL094WitPMFJOZW9ybGlJdVVx?=
 =?utf-8?B?NmNvcXVKYTY3bjgvdVMzNnVyUHJBNEtwMXFobVhxSEE2ZkpaZkVKdkFiRmVr?=
 =?utf-8?B?TUdmMWNueXdKdHpXTW51WHVPNzMwK29HZzVrc05sZzZEVml3eFd4WXEvTzJV?=
 =?utf-8?B?TXJ3VURrVFJoa0xsQVVpMVhRSHdkWXRQSnY5YzNjRkJzei9SemRRQzVyRmxU?=
 =?utf-8?B?SnVGZGRka3JENGpwU2xBcUV1Z05hZ3IzWnVDZVAxUFBEL2RyUkNNUlIrREg3?=
 =?utf-8?B?ZTVxTG41NkliVUh5c2NGSk85VXB1bHRoT0JKajUyL3VuSHVNZHJPVjlKcU8v?=
 =?utf-8?B?bjlDaWR4TnEwZ1lWL2RpeFVYYVlOSzBnclQ0dHJCdnFZSTAvcFpkK25GN1Zv?=
 =?utf-8?B?MXZQUE5yTGl3blBnWFU2eUJSaS9WOTJKck02aCtqM0J2RkJmWEFiU2UwMWVm?=
 =?utf-8?B?ejF4d3NqK09mYWlNVUpDbjVkNGZGTHM5akhHSEdqL0hLM1cwQ1NhTGRTKzJk?=
 =?utf-8?B?V2NCV3dNVHVWSFZGNkJqa3ZZWkkyb3Z5VDgveVl1Y2RuQTRDT2hDMlRBclFL?=
 =?utf-8?B?cDlrcnZMSFh5U0JIbW0yOS9DdWZFVFZFZm1HdEdURDhyKzJraHU5MlJ0MTEw?=
 =?utf-8?B?OW01Ukl4QklZUy9FbHRPWVh0clVEdWRMNE1QZVlkUzgwZTdKVlZ4ZkphenFI?=
 =?utf-8?B?dDd0aTFRdlQ0SURGUmFLUzRZYWdndE9rY2hvNmxFZDBvOXM3TG5mc0xxUlYr?=
 =?utf-8?B?b3BibC82QVdWb0JrZWt4Yzd5K3Arc3dwRkRRTFhXUE82NWRwUHNoKy8yT3or?=
 =?utf-8?B?bW1OaUhodEQ3WmtCZWlXOTRoditXTnVWQmhFNTFvNE11M3VzVVUvSWZhb1JS?=
 =?utf-8?B?Q2VQK0FGcXpNM25wZ3JDcDh4d2k2R082NTkwWlcwaG93ZjYvOWo0c1RXQXA5?=
 =?utf-8?B?TFYrQitTdXlyYkJ3MTFXMVBSdndrcTBNZnVBNSttYXJFTHdZOWtZZ2hrYUlZ?=
 =?utf-8?B?cHBRbjU3THBMaEwwbldENnUwOSt1dVR1QnkwRkVBZWxqbHpLZ3d3TndjcFBk?=
 =?utf-8?B?Qlp1bU9aMTB2YUFuUmR2SWJhVkdlM3FVUFp0amFya0FiT1FOdysrNmtTOVYz?=
 =?utf-8?B?UEp4ZnJSRmd5MERzMFo0ZDVhZUhSVUlqWU5ISE9CN3lxalVUWXRiTU56TVVP?=
 =?utf-8?B?WDhPRi82bDdvc0ZxTnUzYmM3S2FxUWx6Wlg5a0dXRTZqbDJMZkhiaEF1VnR5?=
 =?utf-8?B?Vk1wZ1QwT1JXS2svYjA2QXNlWmpPS1A4VjF0WCtYNlliSFoyN0l3RW5FYmgr?=
 =?utf-8?B?R1hmS2J6QSs5MWJNYkU0bXVUQjBJbENrcmVkakY5UFBRSm56RnY5Y2gvalBM?=
 =?utf-8?B?aEMxaTNEZlFUb1RDT2oxTldSS204cnliYU1sa3hmWUZ5Zlk1ay9yZ2dLTSta?=
 =?utf-8?B?VitTeHFlUFk2MjFRK2x1ek9vSzZITUlOU1pDREVHUWZvU1JHcjI5MzV1eUZP?=
 =?utf-8?B?N0duenJaMG5STGFsNENoc25neEdwc3FZaUhkVVU2NVNXVXV0UDFLZ3lXMzBj?=
 =?utf-8?B?MzN5QWlEcVVrYzYyU29HcXBlcmsrZ1BsUzVaenZmbnp0ampJZThJZVEyTDV3?=
 =?utf-8?B?bTVLYk5ydzR1NStUL2puai9yakhDbDZGektQUVk2dHRHUFV1WndzdDJ3N3Bl?=
 =?utf-8?Q?EiaGxQf55bMDUOZqthvcOkc/i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79aa57ab-eef1-4128-cd96-08dddbf00911
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 11:36:54.8903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1WMKwAbYzrowG7fjEdnuGVLp5Mp5OwVbSMAs9KPWPpnhfdIfyvQw367Qivain9vnYoHEvVOET18xLYVn0iNXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D13140008
X-Stat-Signature: 3qau7sqdguwcrwzjzoc5zcdhdh89sbjm
X-Rspam-User: 
X-HE-Tag: 1755257819-873869
X-HE-Meta: U2FsdGVkX1/r+phyd7ZTaDrMMxVS6xeZiRvJobiTQwbWd5daX1VGzwZuuW5HNOuTCP2XN+h2YpesK/k+m6/LfQb0Fl+LDlUjX5bx+2AQw6pPGxoQO1Fla8KzQPpLOmhm7Hfoit2GAD+D1GyjxvLuz/cnkgQaBbUuFqaqJrzZagC+I2xOBbYCDqfM0nwHghRdpc3WCD2byiN7dImC9bWwLt4nkJpIohFqKVOcLcjSJIIpNA6SsaCbYbYpyaGTkpk6ubA6NbpgGx0PtMBJRw5wgw49JpuW7iRLfJGQ1UFfePExacQ4EzAWCJ0FEC2kbzkkZADDh92pVcWVzr283iJmgppteXTGYdBaAD+Me7Z8k/rnaKURA10RD5X0zSI0c92kbkaVJjhlD+hlevZR+St1Of6soKVJ3GrbpiOK8ctZR9ujo9orbxKB4LSbcM3Aa1DyfK9LxKkb/BPxNZZlvGnecxomk0NPtsN926G4Jw8esHWE0ehhENPxeFXFDYVhM5m/eolG7+AJ+MymoJmAWRos1PK4a0YhMPqG4mZ5LDWt08xraUGnv/USb1x+vKB4gtNklUSMDtqi3NTJEDtMubVzFmbg85r5lfaBBIOVlbtoYNTyPzE0Wh5eDITIRbIG6zH8dbyYeUQjq0npvaj3yyObIQ/qcNo1XnWet8YUmaEjWIfCcnkuPiQRNnAbdIko/IHL9f4c3TKsQP4FSVanYEcwqtegjAtvEac+7gI1DnmNLCoYjTZDneX7HaYIcbSwqwbbCAkmgwDKlABeHP8S2rX0hWeAUiYwm7G4cGpJxL7KV1jvuDnI7nsN+wyDBYrbdkk3sqeuoe0GdYZrHbp1P5YDG4RTkMswEP7INU23w0rllhhCm3QQfDMhh4i9J421jAgSob/ZM5c22WjL2XdgqW+idVKQ46gemytmDuvVEY3vSAAY2051aSd/wHe4VuDPvEeMl/dpwJKEEKSphc+gfk2
 Z5B+X/E0
 X/lsUiFk98mwvvF8mBHj+k9W+6nlwUogdB1f9hgvQ1I84zNw2YnMSdJloQSK7rEL6sEx3A3dNaxksBkMOt9sK7WmLlbYjw21bfWWK/ZSR7jONdMgcJDM1WPCe0UiB3S9mczNYrdfM59wGL5HYOosHMzuA1DAmzafN6p2ZK6aSNbDJPX/RUb8jNmy4wWe8RmQKrrbcTrUTp24qNnlM9Gy8B36RUzirPojlIhFIRGhetFDd+3VQ7RGjCqAs0nepNtYV15XgV42TaEIQ6Mqbq4rSY6USsfR5VFYbxo2S926HNCzpl1T88ewV8G9ta86PU++AqGkaD3LWhUWy6CK310R7LARNi9f23bT7B/CyznuS3rZVRyK8jzJF46F9cjUaAThpINZbNYttMQk/x+xp73+8hPDcp7MqsxPJdTkS41TQVCI+PQIlFyD5l4LTKDC91n61vJugw+lIv1/j5tRpsTvlvBmyHRRisH4TEt6hcIYERBF9Czy5amPAy1MfSaSSwqlVrwr8g3zqkU5/tqwEAQVlRzouUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/25 17:19, Mika Penttilä wrote:
> As of this writing, the way device page faulting and migration
> works is not optimal, if you want to do both fault handling
> and migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the following
> sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct
>    permissions,etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It also tricky to code correctly.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 

The use case makes sense to me, but isn't the sequence always going
to be racy, by the time the pages are faulted in, there could be
others that have been marked non-present or do you intend to lock
all pages during this operation?

Balbir

