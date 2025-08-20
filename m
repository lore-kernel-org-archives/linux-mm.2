Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B54CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 06:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C058E0025; Wed, 20 Aug 2025 02:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9139C8E0011; Wed, 20 Aug 2025 02:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAF78E0025; Wed, 20 Aug 2025 02:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661CD8E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:29:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E600658C83
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:29:34 +0000 (UTC)
X-FDA: 83796159468.30.9C6B934
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	by imf01.hostedemail.com (Postfix) with ESMTP id D2F4D40010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:29:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=J6DcNBuW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf01.hostedemail.com: domain of KPrateek.Nayak@amd.com designates 40.107.94.86 as permitted sender) smtp.mailfrom=KPrateek.Nayak@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755671372; a=rsa-sha256;
	cv=pass;
	b=GlGeMpiQI6CwgbN9Iy0dLALUukdpggCl4/DmZSmXsPzyuoiUBonMR2c3sDYLMQHkBv6ODE
	k0K5o+S4SoQefWz1yUGt837NMCgzkQy1iIpSfGtJBNkE2cSJLHtvpIeQdr+G7887G+PzqC
	ch2mrLxN4CRhJdYcSevY93fUdEwBbek=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=J6DcNBuW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf01.hostedemail.com: domain of KPrateek.Nayak@amd.com designates 40.107.94.86 as permitted sender) smtp.mailfrom=KPrateek.Nayak@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755671372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbeOWknQtUjT2jERZLYHtz1GtCyHPp8LAy6RMmhUW8I=;
	b=BIM2IN6egCo1BVA5VCA9GTDWXiirhprNugd//r7hnjPmClFBchQBWq7FuUwFgW4q+q6BRe
	3l/Z4s8/a+D33UnKB3eBGqkfUIZ+Hbq6SVf7F1LK2rZSxbkkOEyk//Ul5JDJz/IqvJQPyE
	exwGfopIgK7TJWqcBgdtCbwHJ6875W0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q5vP6+tijtudj2ifFaxqxEYA8TuiN1xavzONznivru2/SNc8ERkH7bXt/CaYN4ZL6QN2MNQFKp2K+baCIQl9GzJBDSme86wYX/6YhLqxBxxrtx5KOVtQJ+Cz/VoCGTfbtPvzbABnOgvelt6L1g5oAkia3ggzJiBzxC95BBjIbWabQx7T1VXjLD3RcVyrEXjpFR1lVrcyMLfUQ2peTRJ7ev9Kkwl9TXemBFfnX5XZ6UVEiY+nmpw3u1BrO/oaPlbE/tlQyK/gkhO+jxRbUxSVeBXUK93ZhB6mOONO9GGcylOKI/OqjJO30cfVfnSl7j1ceQigf+NAxEMR+H2SfgI2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbeOWknQtUjT2jERZLYHtz1GtCyHPp8LAy6RMmhUW8I=;
 b=fV76GgPasV8SZOa+e8SdwdYQQC3HifG7TP9VN2fV0eVzXRsTJomHc1cKLquQnf3fSu/Mudj8XPsou5vn83olE5uvs8c49iHTptvSWo055mPrCT/cP34jY5/svLMjenPEB8kFiTFORgHjQZxqnwDrkcgv0B0sizZfBhMpAil0i/B0/VP9VYkm/laOKGTXXtttcg1pl4PC1KmgMJ+OTtMgGdGOw7q/uLqMii4+TpVxpLUsnGXyL8Uq1nRgKVqbI6LAmZu76u3fYdHwYWdiF7U6/mT/xjG3C4u/jXdAJ+6JnkVyh7zlkgnuEPAA8Zu+P1W8D/3YvBvEG+f5XGodaxcEeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbeOWknQtUjT2jERZLYHtz1GtCyHPp8LAy6RMmhUW8I=;
 b=J6DcNBuWeyhVbNZfGJq7WXZATTCk9d/+aJjZMDeTdwi9Dd16ftt1PyFH2cwqeFj6JMvt/whFKf7bDjpPCFqbu1Bpoua4lhQZjhjldvBvFUg7uC91Mu4l1+ZguS2H4wKJ/30gqk5ZYyUO9kotcapdAM2USY/OEtjMZRf+eTQO4Mw=
Received: from BN0PR10CA0017.namprd10.prod.outlook.com (2603:10b6:408:143::26)
 by DS0PR12MB7849.namprd12.prod.outlook.com (2603:10b6:8:141::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 06:29:27 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:408:143:cafe::5f) by BN0PR10CA0017.outlook.office365.com
 (2603:10b6:408:143::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.13 via Frontend Transport; Wed,
 20 Aug 2025 06:29:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 06:29:27 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 01:29:26 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 01:29:26 -0500
Received: from [10.136.47.145] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 01:29:22 -0500
Message-ID: <f8e85fe1-87e6-4b31-9e87-f48fd7b8e3f6@amd.com>
Date: Wed, 20 Aug 2025 11:59:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] 9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN
To: Oleg Nesterov <oleg@redhat.com>, Dominique Martinet
	<asmadeus@codewreck.org>, syzbot
	<syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com>
CC: <akpm@linux-foundation.org>, <brauner@kernel.org>, <dvyukov@google.com>,
	<elver@google.com>, <glider@google.com>, <jack@suse.cz>,
	<kasan-dev@googlegroups.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<syzkaller-bugs@googlegroups.com>, <viro@zeniv.linux.org.uk>,
	<willy@infradead.org>, <v9fs@lists.linux.dev>, David Howells
	<dhowells@redhat.com>
References: <68a2de8f.050a0220.e29e5.0097.GAE@google.com>
 <20250819161013.GB11345@redhat.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20250819161013.GB11345@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|DS0PR12MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: d677bd3c-c09a-417b-6937-08dddfb2e987
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|30052699003|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUdLYkRrN0RYU3poOUJ5YlJodnFEdThMVC81Y2t2c0IzYmVDR1FUMEp5ZUVR?=
 =?utf-8?B?R1J1dVY2dVE4bGVDcG1JelA2ZEZzeWpiUDBRN3NSRjNqWFJabFlHVTRhR0pa?=
 =?utf-8?B?NUVHb2lJYktobTkrME9RWmZVL2dNTHBXb2xNSitmNS96MFBQYm9MY3Y5QStT?=
 =?utf-8?B?Rzh1M2pXRWNxekRsaC9ObUxTcDZNWlh2U093RVlTWlpRM3ZKNzZhUFhUZzN5?=
 =?utf-8?B?SlhlVDhSdWdodXFNOFhFVnUxRElkY2VEMisyb21mU09iaEZCTTRJcWFlZDEz?=
 =?utf-8?B?cnRvTjYwNDFLOHBEV0p5c1pMZ0hGSGFoeDErV3I0ZjR5bmhITTlYUDB4d1ZQ?=
 =?utf-8?B?NkJVSHFRbENJN0tIQTNUc3V5TVhrOWg3MVlMT0NncFVVMWhReFc4eEd0TDNV?=
 =?utf-8?B?SlRUUzBFQUltOVhiNXcrNjUzby9GVEV5RVVMVFJzUHE4Y2tYbE5rZXk4UkVi?=
 =?utf-8?B?Q0hhRGlaWXA4WnlOcHUzcTN4YUw2R085UDVWWi9uZFZ6bUpLZm9sUy8wQUpO?=
 =?utf-8?B?VHpJN3NPNVlFYzVybiswVVpUZkxsV1l5VDN2VFhobXpnaGdGNFlCSGVqTWZ4?=
 =?utf-8?B?cVE5Wk9vSG5kdVh0VERpSGZFUkovVzR4V0pXMlVDeVV3dmE3RUNtN3JHcklj?=
 =?utf-8?B?TXc1cTAzZHkvdVBjSU9PelRGNU5jZnhoUHFCRVlkRnZlcmNGNW0rbVc0dWVU?=
 =?utf-8?B?Mlo3VEhnSXExUTVhODQrQVh6SHUzY08wZHFONzJpSkVYNmxGeVpjOEtaTGg5?=
 =?utf-8?B?NC8rRi9NbzJQSCtBNzhnSUllQTVFUXl2QWN1RXZJMVJmQXB2alJ3SmNlaHBw?=
 =?utf-8?B?MHZRK05ick9IR0E0SWZuUnhLZ3FZc1U4MHBZUHdjSktvRStVWmlUcnF5eGNM?=
 =?utf-8?B?Z0psTEtydk5LNjQ0S1kxUHZVNEZCZk1Db0hXWTYyVjhZeHhiRnRTdG1ZVjcv?=
 =?utf-8?B?WndKaHlNYmJlR1JIZHQ3QkJTN2QwREw2UmxwbStZM2NmOCtPb1JrWFFCWnEv?=
 =?utf-8?B?K09meHJmZk04Vk9hcFBqNU5DbUNmMTJoZlZkVWIzaG5tTTFCUGg4MEdUMnlT?=
 =?utf-8?B?b0pmY3YrUU1nakpJU3BNb21CQmFaV1BubmEwRWVtMVlwWVZuL1BkSDRUa1Jt?=
 =?utf-8?B?U2FDOUdkOG0rSThWWUlWeUNFdVpyZ3ZYRkt5NktHZExGdnMxNklvM21lbE5M?=
 =?utf-8?B?WTRlTDVwQ3pxY1oyVUFsVzRGcTRpZWMzcVAwcmNDdFo4NXNrUTFNNy9ETmJS?=
 =?utf-8?B?Sjc1NC9kZ3NjS21FM04zaXV0QXlFZFFCa2V6QngyUWdGSGthd29JdlFTRHN6?=
 =?utf-8?B?RjU3RmJ3bythWHNMeFdTNnBnbkk1STFUMythSmhZZFdneE5PUSt6OGFnUmZZ?=
 =?utf-8?B?QXIxbUVZRlJYcTl6WFF1V1VuZU1HZElsKzBsZFg1MHBqQnJVR0ZPcFl2eCtn?=
 =?utf-8?B?TkJOZHgrYWdQeFFQaG9tWGZabjdlLzUrRjhsL3lzdGMwK0UyclMrZytBQU4r?=
 =?utf-8?B?V1FmSkVHTnkzMWtndkRrY1lYcnBKVjJzU1NkdWdTLzVFNkRnOHRvZzVJOXlJ?=
 =?utf-8?B?VVVhaGxZR1lFdHUzTUpOb0lBeW9uR1JyeG5nZ09PWmhqUjBlQWpubU9kc1pY?=
 =?utf-8?B?cFhIZHhnandlZ1h1amh5K1VSSTBlVkdhbHpHdEhhcXRlMmJieGRTN2ZMS3dN?=
 =?utf-8?B?c1l4WkhDcUViOWx4ZjZZRFZpYVRlMUVWenA1Q2JsaEcvS2pFdjFJMDBOT0tL?=
 =?utf-8?B?eEYwcWtsL3ZBREpQSW9PN0E0SEh2YkxrMXI2TjdaNUloZm5TcitsMlFPUjA4?=
 =?utf-8?B?NkFOc05td1ZYODVkejdvZ3RwQU5iTDdCaGlKSVRpcEt3cUk0MEpadXhVOG1P?=
 =?utf-8?B?dUEvSDBFZ1RKVk1GUit6SXNuaTYvQmNISGc5T1phZmNyYlZzc2tVcm5xWFhU?=
 =?utf-8?B?Y3pRMDFNUW84L3pmcXlTRko0SnhFY1VBY3g2RTVCWlM5RW40bDdlQUtqYWdF?=
 =?utf-8?Q?6iJAcPy789pHcq8xKch/bixqMuDwig=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(30052699003)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 06:29:27.0699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d677bd3c-c09a-417b-6937-08dddfb2e987
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7849
X-Rspamd-Queue-Id: D2F4D40010
X-Stat-Signature: wypjan9i9d73d3njoixf9ncooy3fpf7h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755671371-350322
X-HE-Meta: U2FsdGVkX1+y9hencV/2FAWl3wq30S9GAPOBTv/xqkSYUkZBBNERrij/GlKHCMFXwhY9tMIrpXiTLrBTH722UtWdjp8u2cBUOTyfMgNbAmXNlssv97AgatPiiOLtkSdYC4UD7ELJR7cIrXbqYzp8xYA0yjEUJYiXXLHlFROYJePBtacFJYN2oNLXyGXpKj0SS2u6mSBeSiKzvF8gglbPZqyH1fM9QtokMSP5FoYpl2q+f7ul4N8VjCbP/roHFP2Q6dqc2daurvMDtfsxrGdibIBE/GRplMnzv8jLz1vj/SHoJ64J0ZW8NuDen4CdfAM9HusxKFcqN13iOhOo6+o5j030xLqK5VuQfjtkqmAV0cq62vXNNNRKVFnhNrYYNMLtOOia4zDjiduH9WKQblPeDQlTylwYgWnBBI4PtIAc2d7bro/d4qql/ScTUz0TRGYU+AiywBSKZOAhfQQyf6t8iaLWamLVqbQf2Ihy7l4HmTe/I6SzpjEQ3wEIl2NtewEus/VqVkQm+ehzymyS2Sq0y6v5VhCSx6AGYKnN3mqgARgmcnl5ScNBazz7xM+vNGPrDe4cxHPKNBgo8Er4ziPmpzmG6J2BhLfsozBl5J175+XbwwiKdAA9Kj6J+hfxbYk/USJdnAUgaRL8pxYZnW9959GDDe4xM+WBvsHBylw3tHzfP7bl2MIQh/IvEmOo4RVIrrGLocVhbH5G/p0/G4mjaXRWBmDmaoil0Cjux7q3dozGbe32RZ++m/HTBipx7N+6yRIx+hmo7kOd5HFO0gvn7A3CyBTaL1nu1fiXzWEG5crdR54AyLWzdTo2pcuFfBdwMSSOekPku9tdSqD1Z+hx6wkXObqFoRfeDa+iWNWk84wfu90g9eIMoTIvt2GG7+gpqDlUVGFaX/SGrIMi8PIIm2hcGTrb7a/BX0j5fYzU37okLIRnmeSkT2DNLeTIM/LNKolu8HTf9oFRSubxoX1
 vwQOl5aA
 Q32gAhwZ8PrDwX6tJxHbmyJkjKNRUue/k+dKusi1EyE7g+wQMIiBxOkN2lecF2iAVdH60OwoPRg8wYu2hEQqg0l7iBOoab12TrboYCZnsVy0Mc05x3nfMnNJ01AuNsqJCqLBYgmg0YzjZ+SUrq4PL1BfTouGkVxClXRPONkU4vPfC5po+8zxgQt428+vvDwM/PVAbr6XOAweIAPzgBlbUokzOAG1EoAusTyO82Ok6owpweT0NYwx1Ojvldri/91AvdwIUT9UZj7FQl54zheJmgdZhg6zFsHe7CzWVdV4C3ONIWvZZTzYDjtrr+IQuxw92yfsaKKrHpOI+Ps4pDCIRImCleTth/YLx2iAx24zWUtu4BI0poB9bCgTSBQpaV8E/hp3R8ionMPVmhDWP1kLndhpXJ4t/aH9ZZZlGfBL8eguYaBDhvmluI2hflauFUUO0hsqlcZeAYlIQiv/UbeeIRPV09tsT4kAiGbwRYXzB5cche0IUuC7NZ1yc92927AQA5NR50sQFpzdo67aelhzBnQFP6rYmCyvHCVHc43H4vzey+zWmmse9Zt2dqdNpOB4mCcqwN1WSNLVvYIyaZlrdnQK4SrkhpIOid93Pxa3C3zQNE7LUEjG4yKgRxaoM1b8EUjNLxaGstRK5fZLmE20YWBP1wHjqzkclv2a3+Kvh8i3+tE44tFsQYeBSq5Z0GhGcdls/qBmCvLGh2ubYxHj5/Khxbd+TEbxzUbhHhk7pfcbbAwKqtSOEPcX1Ic7z5UChQyhM2P5zsPT5QImQMivvtKfF5rvobiTSvLL1PbMStFsgb6Lm1zQGiOjOlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Oleg,

On 8/19/2025 9:40 PM, Oleg Nesterov wrote:
> p9_read_work() doesn't set Rworksched and doesn't do schedule_work(m->rq)
> if list_empty(&m->req_list).
> 
> However, if the pipe is full, we need to read more data and this used to
> work prior to commit aaec5a95d59615 ("pipe_read: don't wake up the writer
> if the pipe is still full").
> 
> p9_read_work() does p9_fd_read() -> ... -> anon_pipe_read() which (before
> the commit above) triggered the unnecessary wakeup. This wakeup calls
> p9_pollwake() which kicks p9_poll_workfn() -> p9_poll_mux(), p9_poll_mux()
> will notice EPOLLIN and schedule_work(&m->rq).
> 
> This no longer happens after the optimization above, change p9_fd_request()
> to use p9_poll_mux() instead of only checking for EPOLLOUT.
> 
> Reported-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
> Tested-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68a2de8f.050a0220.e29e5.0097.GAE@google.com/
> Link: https://lore.kernel.org/all/67dedd2f.050a0220.31a16b.003f.GAE@google.com/
> Co-developed-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>

A "Debugged-by:" or equivalent would have been fine too since you did
most of the heavy lifting by finding p9_poll_mux() but I don't mind
standing behind this since it is doing the right thing :)

I tested this on top of v6.17-rc2 and the upstream runs into a hang
instantly with the syzbot's reproducer. The dmesg logs:

    INFO: task repro:4150 blocked for more than 120 seconds.
          Not tainted 6.17.0-rc2-upstream #34
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    task:repro           state:D stack:0     pid:4150  tgid:4150  ppid:1      task_flags:0x400140 flags:0x00004006
    Call Trace:
     <TASK>
     __schedule+0x474/0x1620
     ? __wb_update_bandwidth+0x37/0x1d0
     schedule+0x27/0xd0
     io_schedule+0x46/0x70
     folio_wait_bit_common+0x112/0x300
     ? filemap_get_folios_tag+0x232/0x2a0
     ? __pfx_wake_page_function+0x10/0x10
     folio_wait_writeback+0x2b/0x80
     __filemap_fdatawait_range+0x7c/0xe0
     file_write_and_wait_range+0x89/0xb0
     v9fs_file_fsync+0x2d/0x90 [9p]
     netfs_file_write_iter+0xec/0x120 [netfs]
     vfs_write+0x305/0x420
     ksys_write+0x65/0xe0
     do_syscall_64+0x85/0xb30
     ? do_syscall_64+0x223/0xb30
     ? count_memcg_events+0xd9/0x1c0
     ? handle_mm_fault+0x1af/0x290
     ? do_user_addr_fault+0x2d0/0x8c0
     entry_SYSCALL_64_after_hwframe+0x76/0x7e
    RIP: 0033:0x7f3b26d1e88d
    RSP: 002b:00007ffe581fa348 EFLAGS: 00000213 ORIG_RAX: 0000000000000001
    RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3b26d1e88d
    RDX: 0000000000007fec RSI: 0000200000000300 RDI: 0000000000000007
    RBP: 00007ffe581fa360 R08: 00007ffe581fa360 R09: 00007ffe581fa360
    R10: 00007ffe581fa360 R11: 0000000000000213 R12: 00007ffe581fa4b8
    R13: 0000558168a6de12 R14: 0000558168a6fd10 R15: 00007f3b26f03040
     </TASK>

With this patch applied on top, I haven't seen a hang yet and I've been
running it for 30min now so feel free to also include:

Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  net/9p/trans_fd.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index 339ec4e54778..474fe67f72ac 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -666,7 +666,6 @@ static void p9_poll_mux(struct p9_conn *m)
>  
>  static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
>  {
> -	__poll_t n;
>  	int err;
>  	struct p9_trans_fd *ts = client->trans;
>  	struct p9_conn *m = &ts->conn;
> @@ -686,13 +685,7 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
>  	list_add_tail(&req->req_list, &m->unsent_req_list);
>  	spin_unlock(&m->req_lock);
>  
> -	if (test_and_clear_bit(Wpending, &m->wsched))
> -		n = EPOLLOUT;
> -	else
> -		n = p9_fd_poll(m->client, NULL, NULL);
> -
> -	if (n & EPOLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
> -		schedule_work(&m->wq);
> +	p9_poll_mux(m);
>  
>  	return 0;
>  }

-- 
Thanks and Regards,
Prateek


