Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F990E9DE68
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 08:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C296B0005; Thu,  9 Apr 2026 04:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3D846B0088; Thu,  9 Apr 2026 04:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52F46B008A; Thu,  9 Apr 2026 04:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C56816B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 04:56:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EBB6BA72F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:56:01 +0000 (UTC)
X-FDA: 84638410122.23.FCE9A3A
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012071.outbound.protection.outlook.com [40.107.209.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A2A014000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:55:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=giIs9Vgy;
	spf=pass (imf23.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.107.209.71 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775724958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOtSyHAZ+2ZjsCUsMTobsb1nqyYu5gywelrfSZgKuQE=;
	b=v37ZMRjfoz4jQSAHeqCXGgRzHNjF7F9Iqki6DbntAkkQfCl9LjNr553hCl6DAqZrgONRa/
	te4/h1IcpM+Pu57gzGQi4DE5b0l4f6pduIxX0YqoPlUxWPpPNn1/i5+RyIkSr7PDp+DQl0
	7P7WKX5zUkkNr+lw7sxFyy0kUDCxERE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=giIs9Vgy;
	spf=pass (imf23.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.107.209.71 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775724958; a=rsa-sha256;
	cv=pass;
	b=vaHR8dmDkOsRPskC7pDlQ5LfVv4tiKKO9KwCOeQvF8d4oIXFpuRJ7ctmn9wNzKrqBoMMvo
	O6xYQyRknFKgvtgouWAXTBV9VY1G6IB6/uBjcojmMvvyJ/f1Gs140+FVSI5AmfrCuCVUIn
	W/M+LMteG262gu4ZuF6FmIHT4rrRkYM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zKWcqnhTJq7ZNIoarOPN3mY4COwxzDD+OWpLjY082ytsCSYGY8R5reJRoRkLj9PEnsQve5UlZ9mqKbeMJiKQDKIV/Qg64titB3hdZnf24A+HYU8T8H7Im11aT9si3kDay5hwcAdpHE1gWj20Z/JjziaN7DW0hNAwVS3wOoHztYAQwFz4xkTJD9i1lDKbc0tCxO0hNvj+hb4rsXNnTztwaNyhwPrQwfX+LkpbmxaErsnOK2VUv1bh6Tn2Rtv1G8xZYA/LbpJwuvr9qNmu7jmDpNl61kM8zb+BIjLmYCiJVzXSwaZKIsHyN7ZJZcUnRrim/WEfQaGrffnRDPOosUFHJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOtSyHAZ+2ZjsCUsMTobsb1nqyYu5gywelrfSZgKuQE=;
 b=OpAP++M+GLF09itnpdY0vhRw0ZXhixVtpsjbTY1H72K+VdN96r75u8TNV8SpJh2AYVzgTfU9ULyuvSFbTta0sPFoCpD3DLMAIVke0ge4Vr8cLuLM44MZkGKKTy1SJFY9azULop/jbwc/JWQ3Ekze4P4ygHFWFZYgYCt7f7oFPg/RLQ7QcNfsTXsMA7i8+qCpuOOxEmT/7zv02RWbkRWa+qocvMBYsjwaZL1/1mM0f3rmOfroUEADIgu721k3U1nn2lbYsdZX2pCPp584XqTar7OPClXYl37BLJGvRrFEThkj8Vr5QoCBLaz4wdQpTvhi42OezZzLBtLyJKpLCfVdWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOtSyHAZ+2ZjsCUsMTobsb1nqyYu5gywelrfSZgKuQE=;
 b=giIs9VgyMq8u1TWF8KIHJO+YzG9M+gwAheLXbo3/XMCGvijjU+lewD/Q4VRyHLP8jGPNJRE6Z6UzbM3UsjFGg6wJShehHqLhTPh3P9NCnBLegoENDGqUEsbql6bE4NouQtNVdpzsRbfhe1KAq8Nf6ZsK08Lwpaozge8Vk8qXIQ8=
Received: from PH7P220CA0177.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:33b::25)
 by CH3PR12MB8308.namprd12.prod.outlook.com (2603:10b6:610:131::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Thu, 9 Apr
 2026 08:55:51 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:510:33b:cafe::f9) by PH7P220CA0177.outlook.office365.com
 (2603:10b6:510:33b::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Thu,
 9 Apr 2026 08:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 9 Apr 2026 08:55:50 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 9 Apr
 2026 03:55:49 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 9 Apr
 2026 03:55:49 -0500
Received: from [10.136.43.140] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 9 Apr 2026 03:55:45 -0500
Message-ID: <fcc68286-d2ae-4e51-b4b2-886af115ad7c@amd.com>
Date: Thu, 9 Apr 2026 14:25:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<rkodsara@amd.com>, <bharata@amd.com>, <ankur.a.arora@oracle.com>,
	<shivankg@amd.com>, David Hildenbrand <david@redhat.com>, <hsalunke@amd.com>
References: <20260408092441.435133-1-hsalunke@amd.com>
 <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
 <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
 <20260408083229.45d1a083f17484d3b2678855@linux-foundation.org>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <20260408083229.45d1a083f17484d3b2678855@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|CH3PR12MB8308:EE_
X-MS-Office365-Filtering-Correlation-Id: a70bce2d-6fff-46b5-4a3b-08de9615cc8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	IW7IY3hM6df0zFALwDgEszJyfYEED1KIMkzOcSODni/dDOBH2v8Y3FjhpZetH5/4ePI8L/yUT9XGYTmJPnQIUrsx0wbNowHYOfqdjGDanan7wlgSpO3MAwjajpn2Ppd12sMOlAy3m4J6YQ7fLPTI6d0oZx/vV1t3V0seZ5xQ4k3R3x/zPmrk4A6kvuflkzuZaadkQdibzsmHhF86ZAhFn+Yqlha9jUbz7Fi+v/erMuHIqVtLNmcjOUe3HDaXVoGDGSmrHY48AdBMOsKTB5W1W8qs0IpL1WslFcxF/R4tav3kyVSpK4fdhCvOSmLPdJQKUAnxd2wS0kVVCW0AjCoOu0TCuBZdfHVN56+yglKOJkqdVN4vjjyP/wQBzrxXHBWrv3yZ015GhV5ZccB+Eiwwk4SbLyvwhwdK81KZvICoyC2IonTGOjSbgL6bdjktFbQ1p0K23MS/Tb9IfbbeT5cdz31jvlkX++ymdUBU9C3jE2Q7uHS77A795Ng/0X/RX2puIcS5DCgN2v1FBwvXC8kUwkSCG3Ib7vb1OjPWgvb5fIQyieNRjM7y2fwr+IbLn+fk2n4JRf6/PkkJU2H7c82WIb/F0zNM2IJ1bGhL2rfKAkE2AmyQKH+6Fx/NKWP27wNc/90y+baMOP0REBTLhvf1pfUiWryn/eFLPrXu8GzgkE/vMA2DQVOV/Xi0743DktogA0UrWT5IH08xBx0Kw3HJg0lpFeLOYJY2qyYUHptZlYKjYop1SdhDpCfyFhbtaQ2Ro40IGbniaFAYAeY9ePugmA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	o3ss6ohbdxBb8g27JW3rk6IEnj+jTn74vqJN8GSSFbEkKKbI8MV9egUZ9xIsREQRXgxi6Wb8+C9K7YDf4MOSo5w5JJMEc1iMori5cVKUgAl+SpAZ/ktDBXEBrFdJWcusx4AlsBRmKbIpX4xeTU6z81YlFvUyVbLexNq3kAmNEJCpKX/1jJKijFkEfNDEkGL5uI0Gb07YQPUXI7qGG7Ujvq3jpxlG1qj04aKYRAzaz2hNEASWqhki9cfzPtlT1Yqy2cqfICmaSZwnlfATpJ7jRPrscGBtAAyPjsDbKVCXelirS9Zle0txbCBz0ZzQBgYA3++CzQttHuGuJ7HcRp2YQ7Uw1a+DYFqIfVlJBddIRqJDaKuN41vOH1kvQGsq5kl21GuPiVzRUF7OWcR0UdOyETzjoiZ5uew08Vo8ZQVu9azPts61iGGg5uL+62It2Wsy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 08:55:50.2804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a70bce2d-6fff-46b5-4a3b-08de9615cc8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8308
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A2A014000F
X-Stat-Signature: yazuaxzku9jqc91r3w9uqm5881t56a4w
X-Rspam-User: 
X-HE-Tag: 1775724957-659754
X-HE-Meta: U2FsdGVkX1+8p3Q+34csvobJvPw0QLFJmDFdX9cX+yyB349vqkS0hEVvwe0k48GPmkbFvuPQmJFhMqPRs8Ogw1tUC7M0bSZSBWCZCRNAbxwWxismunDbVC0GIKl0wKpFZ4CQnrXJxUnNcHzBAIHNDSZ3R98pzVjQqi67Gp6jLZXBMB6uk90hlwKVwx2Lh0GTxUMIxd8HUBlI2bvTqyik9jxssUtWZ/niZyO1z7ZzUD8FtMWmxOaRaNh6gCWvYnVuoHF77zeouWiyQsgLLeo3C+tSJZQ5AY5nixGiPGkxpHbYySpTx74kHVVZENjCm9v5211nPOI6iyWOffZJvQYctAQFlqbrfegMXwmDz2uv1bgK2/Owu0yr2D+9LLwb7QZ3O5NqnLDB3a1EgxWLwpEEU64kI99wPRZ7Ew0Bc4e1q1CRF9N2zlsnx2nGlEwO5j1OhMTcClPgjn4SzPVccuYA0x7swAFXMMbuyKxCEXH/Fnf+dO6nVUzsLl6u1jwd6Mag841+Xkvf5PDDnD+U2AHNpiP3zSH4FSVBsZLJRDhbgh+jtc7rXlES4/sEhVtk0+aQEOWAt1GlQnhJNsZ6mfeXfe0T1Jt/RrTO1DMqVdJm+lsvveLRN4pHxdKKuDnFrNmyDkpwjMIQcw4CTf01c+gsKoQGd8MMgwInkbZL2QOIKfVIglAnhf5URa49RCoTrNIaCbsBhf+SSZVSo5PGaiA4v35jPty/8NIieaMxjLSHZsRj8hR+EdtCfoGbNqzuXg/SvhTbrwVQoQOxPu6CTFC3nkd2ijeKkzPw/AeqBcmgwOinw8e/GMnn1ko++yxcNsVy2osYP4/4AWVfqeNcEATnKS77yvyOIP5fx6g8YulXEynnRyELdxx9OGRNnZ2TGF0ugmH/HZixu/o9afOVkhTadi0eF89A0SmqHgoqE2IZ5BiQhBsNijq/+rX4FrIHduR1TBetBf5WN6hydk3097X
 8gVETYTY
 rmAwLhH6WN6j9QcAs09mPAC+QhCxvZYhvYIPGiFhJH++i23rCHOr3n53Nt3QG0JUOsmsvmD3OkU8z7fKGqdi7DVaIDXEYJceLu96SG2mj3OVyGHV2n4W74FK+37l8WpEwAsW5/DWLZbPl0JvPbIAFFXWRhYrx73pmyNOfRia8mEa3c89LSTcgOEHdlJFmSTGIbUsjpJZr6OD1Yl6V0o7/I6//FtGjQMYIBi82SpTKOgfDs6AzXgLZRC91YFL520zKMThT5LgwOUCX8m8csgQghO7WDG0Bsykxt23ItIHrpVCNK8FqID9aeuLx+z47WE+UzRp+mq6Ly/mH6e1Y3cNCjLJMUMUFaQo9KOmuEh0vFHP0iAExBesVEi28aGh61lT4lt0qiAu6tHrsGScteBQtYJH4rGFcpnykGU/yQHQahqoPOdvsyjZKOo9sCjSi9Bcw0STQXRaFa6vjobIkflYfKyCarmtY0tOvaRKnd3uSGAewsyFVP5HC9NaDBJnBpLsn1HGIjW34jJ3hmJ+tZYxfqsL4cUdSuaGi3tay109sxtteWbQH5aDwzf8HLHWVupJlVTHS7EvOBw25jeOujr6xKaxqDONTUWxvNM1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 08-04-2026 21:02, Andrew Morton wrote:

> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Wed, 8 Apr 2026 16:14:03 +0530 "Salunke, Hrushikesh" <hsalunke@amd.com> wrote:
>
>> kernel_init_pages() runs inside the allocator (post_alloc_hook and
>> __free_pages_prepare), so it inherits whatever context the caller is in.
>> Testing with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_PROVE_LOCKING=y, I
>> hit this during exit_group() -> exit_mmap() -> __zap_vma_range, where a
>> page allocation happens while the PTE lock and RCU read lock are held,
>> making the cond_resched() in the clearing loop illegal:
>>
>> [ 1997.353228] BUG: sleeping function called from invalid context at mm/page_alloc.c:1235
>> [ 1997.353433] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 19725, name: bash
>> [ 1997.353572] preempt_count: 1, expected: 0
>> [ 1997.353706] RCU nest depth: 1, expected: 0
>> [ 1997.353837] 3 locks held by bash/19725:
>> [ 1997.353839]  #0: ff38cd415971e540 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x6e/0x430
>> [ 1997.353850]  #1: ffffffffb03d6f60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2c/0x220
>> [ 1997.353855]  #2: ff38cd410deb4618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x92/0x170
>> [ 1997.353868] Call Trace:
>> [ 1997.353870]  <TASK>
>> [ 1997.353873]  dump_stack_lvl+0x91/0xb0
>> [ 1997.353877]  __might_resched+0x15f/0x290
>> [ 1997.353882]  kernel_init_pages+0x4b/0xa0
>> [ 1997.353886]  get_page_from_freelist+0x406/0x1e60
>> [ 1997.353895]  __alloc_frozen_pages_noprof+0x1d8/0x1730
>> [ 1997.353912]  alloc_pages_mpol+0xa4/0x190
>> [ 1997.353917]  alloc_pages_noprof+0x59/0xd0
>> [ 1997.353919]  get_free_pages_noprof+0x11/0x40
>> [ 1997.353921]  __tlb_remove_folio_pages_size.isra.0+0x7f/0xe0
>> [ 1997.353923]  __zap_vma_range+0x1bbd/0x1f40
>> [ 1997.353931]  unmap_vmas+0xd9/0x1d0
>> [ 1997.353934]  exit_mmap+0x10a/0x430
>> [ 1997.353943]  __mmput+0x3d/0x130
>> [ 1997.353947]  do_exit+0x2a7/0xae0
> tlb_next_batch() is (fortunately) using GFP_NOWAIT.  Perhaps you can
> alter your patch to not call the cond_resched() if caller is attempting
> an atomic allocation.


Thanks Vlastimil, David, Andrew, and Raghu for the reviews.

After looking into this more, I think adding cond_resched() here was
overkill. I agree that dropping cond_resched() and 
PROCESS_PAGES_NON_PREEMPT_BATCH entirely and just calling clear_pages()
is the right approach. There's no case where cond_resched() in 
kernel_init_pages() is both necessary and safe:

- It's unsafe in atomic context, as the BUG shows (tlb_next_batch()
  allocates under PTE lock + RCU read lock via GFP_NOWAIT).
- It's unnecessary for common allocations (order-0, mTHP, 2MB) which
  clear in well under 1ms.
- For 1 GiB hugepages, kernel_init_pages() only runs during the
  initial admin-triggered allocation. When processes later fault on
  those pages, clearing goes through folio_zero_user() ->
  clear_contig_highpages(), not kernel_init_pages().

So rather than guarding cond_resched() with GFP flags (as Andrew
suggested), I'll remove it entirely in v2 to keep things simple and
same scheduling characteristics as the original code, just with the
batch clearing performance benefit.

Regarding the 512 MiB arm64 case that David mentioned the stall from
clearing that without cond_resched() under PREEMPT_NONE is acceptable,
or should it be handled differently?

I can introduce clear_highpages_kasan_tagged() / clear_highpages()
helpers, or keep v2 minimal with the logic inline in
kernel_init_pages(). Any preference?

I'll test v2 across preempt=none,voluntary,full,auto with
init_on_alloc=1 and CONFIG_DEBUG_ATOMIC_SLEEP=y before sending.


Regards,
Hrushikesh


