Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEEF8C98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 04:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9349D6B008A; Mon, 28 Sep 2026 00:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5626B008C; Mon, 28 Sep 2026 00:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4916B0092; Mon, 28 Sep 2026 00:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AEA26B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 00:14:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2B041C3856
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:14:40 +0000 (UTC)
X-FDA: 85261854720.14.54B50B0
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A8A040002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:14:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JnrBTsP9;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 52.101.53.13 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790568877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6Wtge4aHv4YHTLRi4EX8yLmUkelrhOp5ebQE4yjfJk=;
	b=tzdanpcXrKQ2EguJtpNGpcJ439nNNWYyF1UILbuH3xNaCPGr+e+w2hqvX4rIXmGa1mPfme
	haNzYkxWVFJHT62t6WA/rKrjDN7cBbXGvBDbiDqX0hpfNaxG7r6HsBlZecpo1LSXJPoeQR
	LI0/+hApnz8zEb0zQEqewRl1Lqye0fA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JnrBTsP9;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 52.101.53.13 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790568877;
	b=UsVxe3X10vG6d5pDD2a5kNS1bHdlwYf7iN4shgemIpcEVknTfS1nKZB7SXzgypJpcnPnsK
	1Ay4QGAS+Q9BxQeXB4D5BsG2TjGDa1LgByGCHE9TMzrfhzhCGihzJ29EPE6zoS+y6py+VE
	XK9zj1PKLv+n39IH5Rza/YI+UbGqvbA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnX5iY/WyIw/mful9uDOWwFW0c2J/1Gv7o6WVwPaGvfMiApmEX+bx6MIxteMFXwJk1p6fC7+R1II4qoj8vAdO+HpBDqfYBRSO56neixQsMK1mhPnb4OnGCd9mrWyURE/oq2XZc9sng2sQQPIjP5WFctiudy9NUJRtr/wBknWeIWkIT1exxN12LhQ7bCytju9U4xEhf7rAF0Y3Rx9VHZNX3QTbIas+bhrN3zT9yhvp2mEuyK3oQ6mvjO62xx9e2bjsDAYjbMNjcTTUDdKij+DtSzIIE0SwWuDmR3b9k2urCBMLqo+Lw4tBDdSCQI2X9GdHN/CSpsrUEHXIsXqzjIIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6Wtge4aHv4YHTLRi4EX8yLmUkelrhOp5ebQE4yjfJk=;
 b=ekJi0OPPSSAXNzeVotMtA3+S76Oj2IZp1pQ4PhTpGAblmc60Rd885OW4pq9C1JV08oLT7V7YTOrav+NCJK3/udwu/G8RJeF7UlG9ZUFDD+77o7NkL9ZQUuQdoQDZmI1eINhqw9/YeopSfc0ipxls5Gi7jS42G0FE1Qpan8BPXVPybCFO6z2/INq1t6TA3M5+DQMQwZ572L+DuXWSPwCmmTwkuag8SapGuMGU8JmPQ1fkvKPXpFP/c4CviIV5yoLlwkzOwjAfOHnVgW2NY786LYQQv8vjgvPbbPRAJqFSVlzhTWzRheiEh4xOs543hsHdoU9WAX/qIo3xqqXNOcwVSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6Wtge4aHv4YHTLRi4EX8yLmUkelrhOp5ebQE4yjfJk=;
 b=JnrBTsP9PmAV9uzGlASeAdlsYhEQDGnaUAxnqIc2ByB7mqI/G8omcasCXVT5SS4JA96YjTPZJ9ITCLS09YpZ8kMphLyI93iqN8DqWv3FU4dlobcP27haDyBqFKnFrEMlvmArn4xy2lTuYTW/jEF8lEju+2d9Qe6vlVn6pB3u+eE=
Received: from SJ0PR03CA0356.namprd03.prod.outlook.com (2603:10b6:a03:39c::31)
 by CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:51::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 04:14:32 +0000
Received: from SJ5PEPF00000204.namprd05.prod.outlook.com
 (2603:10b6:a03:39c:cafe::91) by SJ0PR03CA0356.outlook.office365.com
 (2603:10b6:a03:39c::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.23 via Frontend Transport; Mon,
 28 Sep 2026 04:14:32 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF00000204.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 28 Sep 2026 04:14:32 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 27 Sep
 2026 23:14:31 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Sun, 27 Sep 2026 23:14:23 -0500
Message-ID: <ed55b8ec-638a-4336-8530-7784721a76d9@amd.com>
Date: Mon, 28 Sep 2026 09:44:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/8] mm: Hot page tracking and promotion - pghot
To: Davidlohr Bueso <dave@stgolabs.net>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-4-bharata@amd.com>
 <20260927232552.u6iypdeadjf4nyla@offworld>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260927232552.u6iypdeadjf4nyla@offworld>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000204:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 29bc38ab-6a78-4b07-39e0-08df1d16ff9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|7416014|376014|10067099003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	z1m2f9bf6jR0n0IVlIEeqjGgInrzhx4F0Hh/xAfgflyuaxHvbhWYHl0QxKuAlB6U7t8sO6gw7mkd0DLeF47UuCjRvtnsZcTdOKdKiVAS02agizUYWNejZYPMw6jNyvqqqp4EZMh8gOTgzcZUJUwfRrp6NTJHWF47lprXXphSMeR9qXQ4g9vZkp1PnMBi/01ZmIXK3BzqX3zBLijjoatgqgB7xM8liOeaIgyvaTvoL2AHo0WacbOEtTHxDSMARfQn4qqQmcQDPhrLadcybeWu7IkNmaRW6Py3gTuibDDRTlfD8til9zauB+HsDuemIWDBRITkb2kWBqa4z6K2pauAp+I0I5KqjalsZkEV6JNPmNhlx2Zzrj1k1SYtvXMudD8jDrd2IMKJfm5e2TV993a1tJMx7rgSDMKfDRpGUv9VH1sDeXC3OfcPA5B8VEbdS+J6eQoIVC6eAfjyiZ3cK+aDSinGUc2O3PEKAYHacIU2zExruOgSyEC/eFTsHtb6Q7FlcxeIWYIGy3WEdoK+UWKWLxRzRxoLGz7+Ze+lSjpvUmaPCs4iBHm/guQLy460YgItM7m9/I+QaLn9db5egj/lSSOJn8OwFgdCJZyhKB+iVlKI0fiwZx7D8qj2CpumCrHKmn2nXzdWxotyRzDgAMxbOVN5rA407drMzQww843OMZUIjuMK1+KmSw+jJ3HM+FlO
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(7416014)(376014)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tX2j93mJQvUaI84zyS4C10utpk+/CNk5/YUhDH6FqDOooG+AzZVnpnTY0174+6pztW23KBIdNCmb/H86XajaaTJjvAz4s4EOg8dsn5PEPlZsgbCYFxmq3PuCSWaAzRJdX63wEsKVWJwbdWk5fttEkUO4+pXRyo+w9TtrCO6KyLKhfnvpFRQPn9Me+gESmi3j7dbRaiBALh6DdeHTf7D/gPAyxx/0yGolY67W/yXxWI2dCOAEusZIYFw9BHfMn8VAA2k5tfmmYFO5ak9CxGXmLgqIqjZ4RmBzknETlIltrwrwiYvq5AoMFpc704oO1LFex1OLKEAdW7Ao/fgvXOQvyQ57L4Iz6TFUnyS3TbBsxnhh2ROusZaQDCbTbLq89kdoc4yB6f7Q/M7ZXZuEYMF5sZtOHml0FiqluUFzG9N853CwtYK5n4K7zR3qeF0QvSys
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 04:14:32.3482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bc38ab-6a78-4b07-39e0-08df1d16ff9b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000204.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097
X-Rspamd-Queue-Id: 9A8A040002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: aet6k87wp81k974hidc163ynethfmdy4
X-HE-Tag: 1790568877-785845
X-HE-Meta: U2FsdGVkX1+OdgLYclwNRJ4ZW1SKvml/ggb7+w21sfJu/jhoot4FoH38Q2xmJ2EliKQ4UndxT8v8LiYyktpFT392zSJOls0+DFxejK15Y6jZLYZ308Ed/lpnpwibhDBnUx4CIhFn7mK6b5ZQ7VTtKT8BRFi5BoqirIzL0G0I8KNruHVPjFVGeaFhnmKOjblhYnYSre640exXZiMTcT3PVt2sjTtjkNX+QeIoPCemt/MCEyipiXIW/GAt3ujvahmHs0YFkIRHMqkTglpZ/6wtbhk2XhennmEpWrp00s0S1G0zJ4n6nqHn7JQfeJVlLL01duWcKtCTkIllJwhb8+qMOFyn+5w1GFXTkE1cqxMI7RUx8FisiRT4eI452NJm9Hq6+yv7A4D+QXihWGuqhbmteHwgBLZKvc6ffyNllPHDyV7Rsqukhp4U8XeXddrwvDu+eVLfrkBjD/P6WPUf/K35BkSem2CX7Ggc+INa+SNMH0+MJqRUuaPBkSs+wb9xCFsCPIoQexLyGNYGr/K4pJ95HyBhbB+tNc2aPmh4pFLY8UqJe62bQLZkX+SZ5lNuda2s/82HgFf4Ue9JmQ2A9LdLSit8lpRgqG2/mczSi5hShM49yFshhF6sBAKTM2LqYCINMR9CgoLF0JCCbU9KpEQUzopHNeiS7e9L6bSqlhScRr9MakXO+51ieq8lBMSyhgou1c1yfdEzaS4dPmtozV+ufohO9/0qaPF63gancS5yLteGCCSexidrBg03n/AmHBUXIWtCA/0Y46Ar3SpRfYtOyw3kSVRB+/XRGZRep7iicN05I0KOrAv/g5d+ouOXatgZ9DZPqKflj/35zwmgVBV/TqJbjLeMFyC0gYQxJWB+WlNhlowd/vDEqEVqU2FnIOk4yUP+6vDaXvr+Z+77yTPEc9rrhL/poodiu6VGlSQivHpebQnX7YB9/tchMb6jXvN3w1ImqzRz2HmPus0Hv2N
 cJ32ptHU
 nmV0Xw7UXGcjUJ13W54vH9R5zsI5O/pVhgU9O3Lku5aHBHlmM+bjIC7caSaJdTuOKTe3knOMVAYH5YpAb3Es36enb3sQ+I7HOQ/YfVZonVk/YrvdovkP6wNKUMkLYyL0acZtUrd08NC0UoSn4Iv/MtwPDrJTJsK3V9QLhHKAoZcGEEAJeXquKHcthHthxhid6NGExMTSO6/ayB/+jQ69066WnsKmWHoO+J6A+GLDHZzViMXue9dWne9i8QC3uV//+OwR1GHmcgoynGfb5oBNV+vezf5Azb0fXXd30eQR32azv/HU0GNb8vz7L0PWzkDRIfPU8iXXWy4BJwHwlV/ad5hwMhfMSg2ZLawsMmol3wnG31D00W0f1LtaC16qSeTir9wIFprN1JC8p3i7mYgzGEYzjbl5f0IKU/57bSxqC/Pyu7wyV89Yr687LHkgP7hOITfL2xGIB4tsHmokVoAw572bxkIozG3InALbGMCaS2nf/f1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28-Sep-26 4:55 AM, Davidlohr Bueso wrote:
> On Tue, 28 Jul 2026, Bharata B Rao wrote:
> 
>> +/**
>> + * pghot_record_access() - Record page accesses from lower tier memory
>> + * for the purpose of tracking page hotness and subsequent promotion.
>> + *
>> + * @pfn: PFN of the page
>> + * @nid: Unused
>> + * @src: The identifier of the sub-system that reports the access
>> + * @now: Access time in jiffies
>> + *
>> + * Updates the frequency and time of access and marks the page as
>> + * ready for migration if the frequency crosses a threshold. The pages
>> + * marked for migration are migrated by kmigrated kernel thread.
>> + *
>> + * Return: 0 on success and -EINVAL on failure to record the access.
>> + */
>> +int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
>> +{
> [...]
>> +}
> 
> This needs a EXPORT_SYMBOL_GPL(pghot_record_access) for any module based
> sources.

Ah I didn't see that till now. CXL driver would need that. Thanks will add.

Regards,
Bharata.

