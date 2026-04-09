Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA81E9DE7B
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792CF6B0005; Thu,  9 Apr 2026 05:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B1D6B0088; Thu,  9 Apr 2026 05:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6592A6B008A; Thu,  9 Apr 2026 05:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 550416B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:28:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1FE885F4C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:28:52 +0000 (UTC)
X-FDA: 84638492904.03.B4E92EB
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010060.outbound.protection.outlook.com [52.101.85.60])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB94A80004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:28:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=K0g1CEXh;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.85.60 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775726930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkxUnfFIQtsRR0zCsYDDfR8OXXTvOaGf9mFUA7vPf1w=;
	b=zHO2YtJrFTaMikQtWSvfbvuh/0g5sslNyCmpMA1m3iszPdiZ+EBL8SMJYzJgysgYt11+XD
	vD53Bwme8FXYcMYXn3UkgO1wywMhjGOsyU9OoR+29GN8yS3n+UWLicqdgkChs7/E5R40oP
	4KchNwJA1axDIa/TktNym8jcpZ/G31c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775726930; a=rsa-sha256;
	cv=pass;
	b=jQRDP0WTCd2dBON8oAHa3969n57f1xT4iE4kh/q81Izstvagz3eVRhyv0wgYhVemBm0fpD
	QjHPaqFYTLe2Rdo3Cte72/9DK2YxGElk18m7YTPJoU0LA8QtN3iJtF52D90cahZs/pFmKM
	awHeGOQrZ5IwaY90FZUZDRJhEFREfVM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=K0g1CEXh;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.85.60 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d2rhxAENnfxnVbIVyk8jUR+176qqLtQyKGGGSu8M70Fk/xsYCYPgJpCLb4Y7RQVeAaz2a3mOP/I4sVVe7v2+UpXxTg7ToJh22B2L48c48mGhNbwAgXCP855BbjgnKhOmHNr2fqFzZQVliV1WXZ5gTQwoYZDeo0jVZ5kM96cxKFgk+Ef/tDK+mr0jfTW6u+3aUcGTW3Rg1CXD4RuhaBJYyyzkDwpv7ZK7g3yhxj5RxyE6CtWSE3MmVB+dYhtTn/KsUiThxKfp29BzMzqzx7aOfB+8e4wXbFhUCC3RLS0QVtaBQOmIlVTiiaMG/SWH3s0uL9uXnEmn2LqPurnAZW1arQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkxUnfFIQtsRR0zCsYDDfR8OXXTvOaGf9mFUA7vPf1w=;
 b=F2dSTZoE6t9RyKPCh4rhjoXY5sC+dBnCaTwbqdQSIknhC3/F+zkMYb+Oti8YM5kzWncLot0cJOcHGghxQSsZRXFxNXBNpNax0udg6lgtgnPqqx4jsavHrK9JJRejZcvGqCUeg58ToUg1Fxoauq5oXgmGxksEa6hah65R6/tHL7knCLHzD6bi3dG5fv3XZJw0NFWeqGIbVVBaoDIQz3UsUiTLkxTxNIopgMTpbtO38Qm3InfzZtQ3iiacG40OQV/ULdox4pz73jrginFT6P4wXcVZ5AwFucoqFrqcYMkByFT0hbiuCOZK5Gp+1nl5EQK5HD/2DD+a1WdfvXKIpiXesQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkxUnfFIQtsRR0zCsYDDfR8OXXTvOaGf9mFUA7vPf1w=;
 b=K0g1CEXhzlytc8kNU9+LTgNEXLv5N3UG1wZFLXs8xdchbTsvjYenPsbcbPKJ5eGi77vixvufHFI+OKB65yaSPH+GnEy0DU/2/Hqy82TqsLlSlSnaRXzWhv7AMpWAMJxPjIDrOIiLS5cZZqxBZ1aDip+yNnq6KV3U4tv/BZXHgtk=
Received: from CH0PR03CA0100.namprd03.prod.outlook.com (2603:10b6:610:cd::15)
 by IA1PR12MB6652.namprd12.prod.outlook.com (2603:10b6:208:38a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 09:28:40 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:cd:cafe::ba) by CH0PR03CA0100.outlook.office365.com
 (2603:10b6:610:cd::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.41 via Frontend Transport; Thu,
 9 Apr 2026 09:28:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 9 Apr 2026 09:28:40 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 9 Apr
 2026 04:28:33 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 9 Apr
 2026 04:28:33 -0500
Received: from [10.136.43.140] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 9 Apr 2026 04:28:30 -0500
Message-ID: <5c01d4ba-4453-47ac-9904-6ad6dbd69c2c@amd.com>
Date: Thu, 9 Apr 2026 14:58:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<rkodsara@amd.com>, <bharata@amd.com>, <ankur.a.arora@oracle.com>,
	<shivankg@amd.com>, <hsalunke@amd.com>
References: <20260408092441.435133-1-hsalunke@amd.com>
 <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
 <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
 <20260408083229.45d1a083f17484d3b2678855@linux-foundation.org>
 <fcc68286-d2ae-4e51-b4b2-886af115ad7c@amd.com>
 <4dd26573-85cc-446a-b2b7-2aeab8aa2417@kernel.org>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <4dd26573-85cc-446a-b2b7-2aeab8aa2417@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|IA1PR12MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: 44616498-bf1b-41da-9393-08de961a62d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|7416014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jGvbb/TI4zweUUKG6dH/A950aJewbe0PJs7I/LwJTIpDX/a8dJwJjhum2/3+toVR07wuPefV6awlau/HZx4hkC4hjfIMk4TMWi1LH9t+0wFFq5cuIfdn03uiy9whoMjsMh7A1LuBNpc2AO6eoDYa6MY3aCizkcKwKSsL9ElkiEFlU78TXhorhCxX7vPfHDyaP0AnpZjjwA9J4c0bSdeSr5lHpvUOAzHpwynJ9QHD2j+UaHEhroTmOCBL18P3lVzuzY7lXRqrJ7WCM10h53ABzgF9E5MrGIvI14dnfXEpzQJvcGhya0QKqEGu5XGQt0BaXtvrWQVFdddp4Auie5ArpBM0+vAMPEAmrJnotIQzmpgTvG3XeuOIhrQ2ddITriRapJpEwBHP7vf0flV/jrGSItFZnQf6j5+49E6PaeswmH7gxIgO+BRo6QeOx+NgQfJ8OMveFppfBmxIZvxHx6ML5DcZ48amjQUohTUJ1LOU3Azb4l6/DhZvxUjhrRIU9E1iEQfVKNV18+JF1nVS/kLiObZS9OHHrw6B+I/Y0w+WrGD2eyxjdyTla74QlhBC0231Qnx9TNmiw1NZk3ucZXIASxM37C2NW6bLCCs87AHiyFzvYR6zabHxYsKHKJPScmRJoiGS4SzDKHDEAF+V3VEMKYHPKScl1pFMaOsOWNA7DFjL7UVYjswpTxMJFuPHP11yy3Hxnti36xMhyxuebistc6LS11rJb0N5kMZsmJLLiHbrD0np/N36ndwxWPKOqrybUe3i+tjHK+WNKWEDAIssWg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(7416014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C1MiqjSXV1vSTMVqh+TczXCXImxoQvebCPPKF7XUXsVR76Iy93LO3mL9UB51eovA416UfqCQl2cE5yzqwU5Lvr6+SPtLHomdR5FWMqYSkthhuMlPZgvwrwvBlwHY04RALDiHHYuUrJ8Agfa6kZpLqZ0bRvSSWFS03FgWgacgkAgS4qgUsKYHdNU6q8lPWeBVhRtf4ZzRORL4vIOM6jWGoTs3l+DkXuMozARg1D+RA0F7gqq8zwBmVvxij5HlaqXe0rZKCRbsw+L49hRfQRfVHgQfHDnBv11t5lKKyNzVEeDBITk8++uEZiisYsY1+LzzpHpCrVp+9B1hx0Ar3BzLPgRqEXD3obBM2vZuizi6KGU7TLLegUQo1xHjECS9FVPQc0sbE2dtrBAiMRxYJLnzW8EIVFOceApX7p5RNUqAA6m6uWYQaxH0Bkfoiq+2H0Vr
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 09:28:40.4392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44616498-bf1b-41da-9393-08de961a62d9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6652
X-Rspamd-Queue-Id: BB94A80004
X-Stat-Signature: 1ktgtrymszm4igfaaqfieikkbns7rh5w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775726929-518802
X-HE-Meta: U2FsdGVkX1/Oq84TiNc785Y8Lf1k8QyVHJ0010X3zHpUBMqCcyyHtBeMV/0GaLu/+cq5fg3s1qOXIi+rzGrBjMlIQrLo4YQIsc3sxibXsy3CpJ++YJ+k6G5prqkVpATbVjbNbfG7ihCKdyTq4N+R6LEB9fCp+yfaZG4S6klf8tJzsZdmzedUAcAFZcvgzsOfud5Sc40Xjp3S0axSR/4mIGQZsj8LtC5mt0eKj1S0pjdp50xzbgMLGP0n7A1eDkls8o4cmbFxgZs9D2Dr363rL7ti9irauH9RxBCGk4anDgwuEEIwyHLX8LroldZsxpGGMlCWJx1kcfFkXtDiMvLqj3CADT/cuiHj8fFvvh3cYdrystiBh7WOAZi6+POuJT0M23tIce8zUQpC1vKHW8015xcFyNBLB/ZTJ3FRnrwmaURGvoKvTxBIYu1fYPhF3EDJBGpK87l+y3ASpnBgi7XKT/kukPYeipN06oDkW8Ofm/ilZ0fslx40a6xpp6aJ9EDo7OyQbev/XIl1b86S6xRybD9at/h71vIKMooe9G+iSvQelQnJqGWp4emaGLGswfFOGyAUSnshzxbNrRZuhYlxNs3Gq+cNMhftDn9YzhhR9iXJsIO1ftHlmeDgjZ+TCn4LlLn8r2GkJQMFD2Pe/V7C7u20DbknRA+Zhmz42ptuCD2Z4p8uJFLLhLGq+eIPAlCKudpJDTY5QK4iZGJ90uTVRsiN/1RcZdghmEFMwHHZdbWDfuW6359ghENcLIEaRmimNnF8A99FNTuejwpxFDtYjLX7NlNfCH+kZMc1BDQbWHC54PadD3Fij+EOmjcInByYilBi/O5tkV9JYqY6HtnT/otBd7efqYhk6t/5wYpcF6Jg4teKuDDmvegQTgQrP/hIXV4THtL8WN/1Yw4osjPCG2WM9xXGrPKTPciYpnch/6Z6qtPmwf7w1O88qg7gvfIQTalebRU+GmDWo5JlXQJ
 wpiN+/oO
 GwBYz5eTD4r3Nx1019j1zxj4rI/Z3nxfkPBjmABhgn+cnl4fEKaOwm4XMpguA7ZD2ACX2Fm0UunN3sPsv0pGU7oC1RCjKWRCTxzjuyE3zPFiI7rTOSBcmpBEXil/c/hNXMmP9UiflIdkWkguwFd0tR/dlu+YFsgyyJKDf5JcZyw29td2jlGdzbmKY5HYAf9jrFzWVpFt5IDYRoW/HkE/st59fdM9nweD9RlnMS32JiHSAKUylFiQllywz/mHX4PQmsYh158GjcHOVWnL86NUjOxF+N/Wfyn0JoEy9wMapHFLGbfShnw2GDjDEqvQ+Dykr+GwP1J+zPQCor4Pd3RA2CEN2T4tnLDU8z2hZ8gL18EEPNPOE2IPZ3x06OOh3hLAf5lNeIdRpQWXGM6WhyytS96jQ9dhzUYDf7aQaMrGxkoh5qL0+kdfxESnmjGkUfSbodH86jvTLwawPAqyzjTULY9c1WllVV+siuuP8v301STzEqIp/6mIK6JngPSyCdom7tjKBFw2VGKz6QLNvFZYl9CKo0BXdbzOqNLKZV1CMCIKaF3bc/w+hRAzMbk6eSK1w65cCq+oT76WZnq3rA8SEWTuv9cgbVSNAdfV7P3S5XMBKtPfzPESD//fAmz31DYMpC+c1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 09-04-2026 14:30, David Hildenbrand (Arm) wrote:

> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On 4/9/26 10:55, Salunke, Hrushikesh wrote:
>> On 08-04-2026 21:02, Andrew Morton wrote:
>>
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Wed, 8 Apr 2026 16:14:03 +0530 "Salunke, Hrushikesh" <hsalunke@amd.com> wrote:
>>>
>>>> kernel_init_pages() runs inside the allocator (post_alloc_hook and
>>>> __free_pages_prepare), so it inherits whatever context the caller is in.
>>>> Testing with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_PROVE_LOCKING=y, I
>>>> hit this during exit_group() -> exit_mmap() -> __zap_vma_range, where a
>>>> page allocation happens while the PTE lock and RCU read lock are held,
>>>> making the cond_resched() in the clearing loop illegal:
>>>>
>>>> [ 1997.353228] BUG: sleeping function called from invalid context at mm/page_alloc.c:1235
>>>> [ 1997.353433] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 19725, name: bash
>>>> [ 1997.353572] preempt_count: 1, expected: 0
>>>> [ 1997.353706] RCU nest depth: 1, expected: 0
>>>> [ 1997.353837] 3 locks held by bash/19725:
>>>> [ 1997.353839]  #0: ff38cd415971e540 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x6e/0x430
>>>> [ 1997.353850]  #1: ffffffffb03d6f60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2c/0x220
>>>> [ 1997.353855]  #2: ff38cd410deb4618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x92/0x170
>>>> [ 1997.353868] Call Trace:
>>>> [ 1997.353870]  <TASK>
>>>> [ 1997.353873]  dump_stack_lvl+0x91/0xb0
>>>> [ 1997.353877]  __might_resched+0x15f/0x290
>>>> [ 1997.353882]  kernel_init_pages+0x4b/0xa0
>>>> [ 1997.353886]  get_page_from_freelist+0x406/0x1e60
>>>> [ 1997.353895]  __alloc_frozen_pages_noprof+0x1d8/0x1730
>>>> [ 1997.353912]  alloc_pages_mpol+0xa4/0x190
>>>> [ 1997.353917]  alloc_pages_noprof+0x59/0xd0
>>>> [ 1997.353919]  get_free_pages_noprof+0x11/0x40
>>>> [ 1997.353921]  __tlb_remove_folio_pages_size.isra.0+0x7f/0xe0
>>>> [ 1997.353923]  __zap_vma_range+0x1bbd/0x1f40
>>>> [ 1997.353931]  unmap_vmas+0xd9/0x1d0
>>>> [ 1997.353934]  exit_mmap+0x10a/0x430
>>>> [ 1997.353943]  __mmput+0x3d/0x130
>>>> [ 1997.353947]  do_exit+0x2a7/0xae0
>>> tlb_next_batch() is (fortunately) using GFP_NOWAIT.  Perhaps you can
>>> alter your patch to not call the cond_resched() if caller is attempting
>>> an atomic allocation.
>>
>> Thanks Vlastimil, David, Andrew, and Raghu for the reviews.
>>
>> After looking into this more, I think adding cond_resched() here was
>> overkill. I agree that dropping cond_resched() and
>> PROCESS_PAGES_NON_PREEMPT_BATCH entirely and just calling clear_pages()
>> is the right approach. There's no case where cond_resched() in
>> kernel_init_pages() is both necessary and safe:
>>
>> - It's unsafe in atomic context, as the BUG shows (tlb_next_batch()
>>   allocates under PTE lock + RCU read lock via GFP_NOWAIT).
>> - It's unnecessary for common allocations (order-0, mTHP, 2MB) which
>>   clear in well under 1ms.
>> - For 1 GiB hugepages, kernel_init_pages() only runs during the
>>   initial admin-triggered allocation. When processes later fault on
>>   those pages, clearing goes through folio_zero_user() ->
>>   clear_contig_highpages(), not kernel_init_pages().
>>
>> So rather than guarding cond_resched() with GFP flags (as Andrew
>> suggested), I'll remove it entirely in v2 to keep things simple and
>> same scheduling characteristics as the original code, just with the
>> batch clearing performance benefit.
>>
>> Regarding the 512 MiB arm64 case that David mentioned the stall from
>> clearing that without cond_resched() under PREEMPT_NONE is acceptable,
>> or should it be handled differently?

Thanks David.

> I mean, it would already happen today, because there is no
> cond_resched(). So nothing to worry about I guess.

Right makes sense.

>
>> I can introduce clear_highpages_kasan_tagged() / clear_highpages()
>> helpers, or keep v2 minimal with the logic inline in
>> kernel_init_pages(). Any preference?
> I'd prefer not sprinkling IS_ENABLED(CONFIG_HIGHMEM) around and simply
> calling a clear_highpages_kasan_tagged() from kernel_init_pages().
>
Sounds good. I'll add a clear_highpages_kasan_tagged() helper in
highmem.h and have kernel_init_pages() call it directly. Will send
v2 shortly.

Regards,
Hrushikesh


