Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAE2606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jx0FNzRq
Received: by kanga.kvack.org (Postfix)
	id BED8C6B090A; Thu, 22 Oct 2026 06:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E5D6B090C; Thu, 22 Oct 2026 06:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D586B090D; Thu, 22 Oct 2026 06:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75CD76B090A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:52:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 622AA140310
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:52:38 +0000 (UTC)
X-FDA: 85349948796.18.EF19C89
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010021.outbound.protection.outlook.com [40.93.198.21])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3E0B8100006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:52:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jx0FNzRq;
	spf=pass (imf05.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.93.198.21 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792666355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9Dd2ssvJRSBtfdoXr+5jlyWjNNmYog2TOK/zngVrrk=;
	b=0EAm6rAR9F6muNaQpJOjdAE4A297hf/oeNi54FwAGDjFCquCkUlXoaMOq4rrwEA5UyP8W+
	E3NE6HXySJgBcJVvaTyzhBHwLHUWMpsvtMohpKuMPVAsZ6jWVUpbSSa9XwdPi100FU2Zuy
	CXTAaNZhmuZUW47CzkOT0vfBs6rkG0o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792666355;
	b=bxnt8m/QCHHdYDNLmt5KRUNJBDvYhG0K+7db9Gqa41IRIjBtZjNca4iOQrJfFRLZzs/EH0
	0QqvR8WVFmOA0Wuioa4zsJ24kQaToh07amoBc8buaZ5jU+r7keQQWLR18W3l5he+1R4VOg
	3iX472Rb7+H87FHcQ52A0NVGFjwyTvY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jx0FNzRq;
	spf=pass (imf05.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.93.198.21 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vA0EkeEEIOMonwt73K9c7L5lwU0BM+zudUraQP/sz5ZN0VYTGRE2dk/zol7m/zbZ7JJquVTs8wEV/X0ImdSbY0nMER9eWPp49uHktFPDPFXrqc5SY9jzLmvlXAVF+b3u9mPHxdEjuC263EGcpiaM9iPrWeH228Wd0Euor49sGqGdIK+5Fuhjn6Dlf8w3WAI0RAsFUPJ4rCX8bA2KSPmoU6VfRR6yf9SjJjXn3g1uDZKJJ2mY4QcJG+GOLAiorGXQE/MKO1xTS3zko9AujUReKPfOkoEoRJBYYWU6t39piNI0S/icsCYIMj5wWmBw7ng6sTYr1e135TWsR+dqMWJowg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9Dd2ssvJRSBtfdoXr+5jlyWjNNmYog2TOK/zngVrrk=;
 b=CYzvYyO458/7xPfssNzTmUByikPUIU+mc4PBHQg057nMPGJ/z1Dj53ZlPzGoepJryfnFb0JqH870MKJcpN+Z1s+7yFcwRVM71VxJ+g5wu2FGH3TRrNTN/GjU4aisr5MXtz4eXcN9DpIGixXPIBmCzrKEN+zYavLuMykBOMPmmPjibTYNzS3L67RK6+sNCtei+HUXAQy6e8zfCgtnfIwfboHVFU4cRknoux/tTv8odEm33NdkH4oOGw079/Yei6PsHI0xiwjNK7LzBt/BLICifu4VHMGoMDpMk3M4EMfT96QhITL+AWtSHuBO17LWFsBptQ2sX5DI1eg4PkWhPXKwaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=suse.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9Dd2ssvJRSBtfdoXr+5jlyWjNNmYog2TOK/zngVrrk=;
 b=jx0FNzRqpb2D4pO+bh0PmjVXDsQZk/0PAkI8uWR1W3DNFalv8kJPzxKJXQ0X1P8+ZvzFUmZ5s1MI4ZUWf370RpaHzfCILgTPVffVOdaLoaVdbgrodGIvzpuMC/P+VfGDrCnsK5PsutiQjPtAqPybIW8KvHJE1Iqj+eUPySSLqSI=
Received: from PH5P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::16)
 by DS7PR12MB5958.namprd12.prod.outlook.com (2603:10b6:8:7d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Thu, 22 Oct
 2026 10:52:30 +0000
Received: from CY8PEPF0000005D.namprd21.prod.outlook.com
 (2603:10b6:510:34a:cafe::2d) by PH5P220CA0004.outlook.office365.com
 (2603:10b6:510:34a::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.17 via Frontend Transport; Thu,
 22 Oct 2026 10:52:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY8PEPF0000005D.mail.protection.outlook.com (10.167.247.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.0 via Frontend Transport; Thu, 22 Oct 2026 10:52:29 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 22 Oct
 2026 05:52:28 -0500
Received: from [10.136.45.54] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Thu, 22 Oct 2026 05:52:24 -0500
Message-ID: <3c39b754-1f17-430d-8f3b-292b7e3f3691@amd.com>
Date: Thu, 22 Oct 2026 16:22:18 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
To: Pedro Falcato <pfalcato@suse.de>, Shivank Garg <shivankg@amd.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>, Peter Zijlstra
	<peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Bharata B Rao
	<bharata@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
	<x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20261022-clear-pages-batch-v1-1-13d3bd0b876e@amd.com>
 <atndhWpGDvs4vHoN@pedro-suse.tail5790ac.ts.net>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <atndhWpGDvs4vHoN@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PEPF0000005D:EE_|DS7PR12MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: 0123ed2d-04f2-4589-1a88-08df302a9134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|7416014|376014|36860700016|1800799024|18002099003|22082099003|5023799004|4143699003|11063799006|261021123027099003|261009223027099003|261021121427099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Xccun1NrrYRaM5boGtOZ84izmYv993svUPrppevW8kD4d14yFFqeX8/pb0i8exiFyPX6ux2+uEfTI67edFgaX78grP0xhorYc8JU4HM3pz8tSaiSMwhlgk8wi6tqtV6fuj9Po2KHR4fZ+A5kRiD9pgF5vGqFBsLcLySFDcDwjbf1kA3NvpBedFZ43/GAValskPj/0q3eOa6MHuyndUV7v1+9//RFTWiykkpoAF77HhDwPHmAQNLkaJ1SBuedPs8zT1XI4qyZSM9jhT/5dTl119kazmeO3ja+8nmMppnjxoioBwOPHtJJMXcHrlw7CInNuyiiGsvtVuxnEJUoTJPqKwPivKtWy1bI+3s/NIN0KAzJaBAsEz5W2+lgO8ecn5blanUcV8mhkzQYZEDpjIdEVlfomFKXRaAKzBgJVU3V5lWTAjMToKMl0ee8zF25504eMpjwDHuWQhGEAPczgLDVOczU4Sz5+jTR15MBAvyxth0VPTDC7xZSf84mZKTKJKm/SX4X1edfSahEod/rUraStnntJwamalx/0lXQuju+vPVBe+YKI7CTSjjhNUmCIcntOY67XM9sEuhA+ajhznLMZN1+gSY/am6pQlNNtx4Fm3bYIGm4g11/2OTHoPZeNOqfMEK2ejBwXExaSbdU9WlWVwP+1PouUQZNkiQ0h4ot41s=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(7416014)(376014)(36860700016)(1800799024)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(261021123027099003)(261009223027099003)(261021121427099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z+6iifCh2146QOlud7nEeRfiZjyt4oT38Ko6wMc49PCHZY6hi5NnRiYvJKftCvM6I4oS7JotgLqJFalefPCskbekFcExD+KMIuMrCrqBG8Nt64+a7PK3qzoF+qzLzsixdSg1zSECSMkZNzpkIpYWSofphGzVjnqXUDDClLJ+LghAVcNRWwqLZlcRTz0pCN5REd8mVcqJu1cSSnd2+wqiV/5wNaHXucPtof7PqXrh/RwaEaZshtU8y6buh9Kn9lgPxxPJgpGMEwETiSI39zQ7VvygzgHwSgbP/gGsY3YDehWiKywM0+HMC3XPgIecrwgW2Ui8psoIdcdKIlXceY+nQ8QQRuQDyDoDQ80m3ssOfR6ahKhNr+Or7llJ2UDh6v4oWnWw9zyvWNGQStxTwGDKqgwdda6gHhZ0JY8gSkVgvezmBIOH4PNBxbrgVyFSZCk7
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 10:52:29.1880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0123ed2d-04f2-4589-1a88-08df302a9134
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF0000005D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5958
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E0B8100006
X-Stat-Signature: tbsrjctd65njos7ayum4jd6cqieas4j4
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792666355-815670
X-HE-Meta: U2FsdGVkX191XfUiWJQpjxzbq1RvM7FsWhuD8XR896B/lGo3mMPP3R+u3asjjqZ0owTerfMzA6O+Xwr1aBtkAxf8kdfC+tD0osOpa7a8j6m8UdcJROkyRhExUKFvMGB4GJWArYy8zDsTiKa3uGu0N7piHe4XLSOSPiuE18IHbH7wSqlsw64zoQgRhWa+ewK3E249eDCNhPigkfZKTP5bWku39CDlZ8CjRwDkOBRQyFdU4SUTS/evafLhk585j9phnTTDmiOjyyxqyrgns/i/WvniGJ5QsB86K2ZcPcv93AUbFO179orbCKdLmprUm+bcyEJXujsHoQU31eukQsJVkPxFJnFDMP0QuZuNF1my5lYYL9ioMJPxK/tq//WGxx2GfOgIq+LFRxq3QbXsQn3VmlpnkTn755F71sYiKpiD+gd/pPA8lusXvYZlBHoKoFcv1M1C7Hvi6jXeG0zoahHOFJg87nZ2GZFDlwdK0BXDWzcAgQvPis7pH3ebtNDkb8ruabcVLKaOHhMJU3IzkDLG3DF6v7Np1glSvBqaIWttgYQOG0HV9l61qFsqZDv6ZaiTorfvW7S6wIFnVeuNk54Qt5Q+52zOoH7OhUcOJyTDPsWa+60EzjNXdkdmiuVkNLWaxa4QSJzqfTQ2C+3dPW9CJESMBINb6R3WytaeDpUUDsW2NPVPGSdHdN22TyhJ3zROdvUjKaHU6Gkuc1i9dLRcBgOXSj0DgVXopaqjgZjiGtOavE9ypCFmNUCpyMP5vWjYsGxHzOv+Ds0EyGvnXFic0YNTlMIuEoKlZ8iha285TE14yXAFWXVIfdA88UVShucTuAZnKGf3NJTgsacP92cadc2j3ntLsTZu8toZESNlmwHSRyYmg5jFBsV4+vctcpTz329VQbQ8tY99LtXwjMgykRXHFyfU0c0Q6tBhZfo1/Z/oc7vbFTmcPtNgbmzoYfQEq3CEpvL7+NQuq01nBl5
 WVLvt5Ku
 Gyt8M3rO8jZmscjblmQBKA5G4wL16g/zDndu20U2gLsAuqfCouO4LvPMfuW3hQFWVQAa40zkq/3Nhuy52Azar8587VJciA+yshDAQ9NdjaQK9Sa6N1J/0Ztq54zMmWytyK+yCJBITqNQIMAJdQHY2ZbUOOiG5d9V6G3rHb/KF8NxYP8kk+iiehPn8g+07h5opV+RIiMlPqTNzmXMIgxUZbyyMBuYeyuCM1BvyOC8clvrLK4OCT4WL9uI8JD9PP0q//1gj7FMGmDGLfd60kWouCYS9YcrrwaZ7xqCuE69D3O4eHK1p42goZdJEbrIGZEzVccxsZcn4venp1ypfMMYo0qTZzM7dTPbprJW/JFYkyrCUCJhuuiiDV1+ZQ4NkLPSJ7BO2NwFC8it+BSrNSgMhRM254djDHxg8sUPpCXOKS8jI9q7WiH6Y6nGJHkaD8ETqS8wEOxbuDVe5wVmrl1LhTPZM/VQpT9Vjzi4zR5595d032pTBe+bkmN45tjByUO96mQMX2pYL/bMY25oJ3+uyfY6oY+QcQNxbSrs+MF4+t8TvkNaf7WflUwoFU3H8U4cvki+42JxoQD1GdJr/TIu9MP3hgTT/zqOE0Jq4En4fxaQpoPNTaMMevzUr0Sk4Yt2/RlxoDCV94DkvSbwWgS89tJtgBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 22-10-2026 15:28, Pedro Falcato wrote:

> On Thu, Oct 22, 2026 at 08:14:30AM +0000, Shivank Garg wrote:
>> clear_contig_highpages() clears the whole range at once under
>> preemptible models. Otherwise it clears PROCESS_PAGES_NON_PREEMPT_BATCH
>> pages at a time, with a cond_resched() in between. The batch is 32MB if
>> the architecture defines clear_pages(), and one page otherwise.
>>
>> Since commit 7dadeaa6e851 ("sched: Further restrict the preemption
>> modes"), architectures that support lazy preemption only offer the
>> full, lazy and RT preemption models, also with PREEMPT_DYNAMIC. x86 is
>> one of them, and it is the only architecture that defines
>> clear_pages(). So the 32MB batch is never used: whenever
>> clear_contig_highpages() runs under a cooperative model, the batch is
>> one page.
>>
>> Make that explicit. Clear the whole range when CONFIG_PREEMPTION is
>> set, and one page at a time with cond_resched() in between otherwise.
>> Drop PROCESS_PAGES_NON_PREEMPT_BATCH, which has no other users.
>>
>> PREEMPT_DYNAMIC kernels also have CONFIG_PREEMPTION set, and
>> cond_resched() does nothing on any of these kernels. So a build-time
>> CONFIG_PREEMPTION check is enough, and preempt_model_preemptible() is
>> not needed.
>>
>> No functional change intended.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>> This came up in review of the copy_mc_highpages() series [1]. Pedro
>> pointed out that most architecture are full or lazy preempt, so mm does
>> not need to check the preemption model at runtime or batch the copy for
>> cond_resched(), and simple per-page fallback is enough for non-preemptible
>> models. David suggested doing the same for the zeroing path, and
>> this patch does that.
>>
>> [1] https://lore.kernel.org/all/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com
>> ---
>>  include/linux/mm.h | 28 +---------------------------
>>  mm/memory.c        | 29 ++++++++++++++++-------------
>>  2 files changed, 17 insertions(+), 40 deletions(-)
> Awesome!
>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 35f5fc43861a..1083d0645d63 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -5269,7 +5269,7 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>   *
>>   * When running under preemptible models this is not a problem. Under
>>   * cooperatively scheduled models, however, the caller is expected to
>> - * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
>> + * clear one page at a time and call cond_resched() in between.
> Why can't clear_pages() itself do cond_resched()?

clear_pages() is also used from contexts that cannot sleep. The page
allocator zeroes via clear_highpages_kasan_tagged(), which uses
clear_pages() for __GFP_ZERO/init_on_alloc in post_alloc_hook() and
for init_on_free in __free_pages_prepare(). Those run in whatever
context the allocation or free happens in, so clear_pages() can't call
cond_resched().

Regards,
Hrushikesh



