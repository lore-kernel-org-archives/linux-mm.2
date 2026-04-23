Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E08FAD40B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 05:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5EE96B0005; Thu, 23 Apr 2026 01:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0FD96B008A; Thu, 23 Apr 2026 01:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE216B008C; Thu, 23 Apr 2026 01:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ADCA16B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:09:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3430FA0222
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:09:19 +0000 (UTC)
X-FDA: 84688642038.27.9681FAE
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06ED4C000E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:09:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=F+75qAft;
	spf=pass (imf22.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.93.195.7 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776920956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZW71aZUB75cXXss4TYHkq/jv9kF0X1M2pMtVLer0VLg=;
	b=3oX0RsVyVR0hoDKfI4Li9tkGy/jaDpimouNExLa3NHXLsSua9maIbUz4TvfXlHB9ug+uAJ
	uem9YGbrSsf7FGmni/53R1WeMLfHWymNzZKzymJxJieIfoCFiivyqNcu7hegsbU7Jvrrgv
	cQDkrasYfA9UXHr4QXo6TuaCgplwhV0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=F+75qAft;
	spf=pass (imf22.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.93.195.7 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776920956; a=rsa-sha256;
	cv=pass;
	b=SJHkp6FNv+QJ/D0tBsagbXTC5TQpqeUEYqep4vaBhfWgCrFUYi2y+fNolmC8NZoQcEzU7q
	bYiBFmVeDc28/VQxbMiXw/TYDotUHuiPDUIN4NSL8jrZYouYjekzHsVdsHhOw9H31ZqIQW
	0Ms4bF9UYLe5XarAarljei8CtCLJuzE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2LcJlWTKXDUj46CyiNxuJ/05HVCAw5jnpV95g67Sxmmi3d9U03yXDJ40TtKu3VoGq2fLdCsXFsuY0WnhEIQXt3G9StMtv0eDh2EBsx6hHUCbu+vOQakkQJ/JIzadTlAR57yNWdHWweDJdPRMx608Zp79og/vbpU9UfqalfEAYat1rtH+pi2mzosz4VwgWoXeN7QeXm8jlb2pbQjh9uKJptG/9xpyYKcRuKmtfaNVUzdPGxwTIaom1Ue4x5Jjdp//dt/PQa5QEx6fZ6ZeXkPvN3rBOkRq5+3AVpTe0NabD9xzeCTJYqYVtgwuWhRnpUVF36Tt0Mm81UNyHcyjhpVYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZW71aZUB75cXXss4TYHkq/jv9kF0X1M2pMtVLer0VLg=;
 b=ys2juKmWBm0T9h0mRy6isZ0OlXefER7W/sv1XKCZ0JLmeUCIqPl4YV2XVQsR0WPOC7d0dHXD6I7hiaNkSYXCZ0MHk9KJLLGZ4L4k4ldEInwRivTYdCZLY6VF8ZPhHlg89Zq6qcMIP6eVCHi2FP6g0HE6aRX7md1PTmQRoBXtNekhM93jK/oTbfRTaXrfRE062rUUCy7vRixJYjamzZ49lVk5ifEyCORKCoE94wRkpkre+fqD5rujpuYJKL00Cuto7y70oNJFncEqnQYFBEjeTLZoA6iP4afoREPqcqMLtluPoG1TsVQB+tcBELao6c62lV9UJRyIqMgLjhncTH6dGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 165.204.55.251) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW71aZUB75cXXss4TYHkq/jv9kF0X1M2pMtVLer0VLg=;
 b=F+75qAftDe9AqpAtI4/niAuYB/lDFAKXqyfxTo6WoF/6OiCdOYWvXCwRzUXFE2kf9Aq65NJRN8EjeDnOkFNgWBpZ/7U0z3TazRfNYUSpY2oTHLnMsaJaNEM642khZRnmair1gzx5PKOrPBRce0qhSYtKLREyrLeRnMyLF85Soo4=
Received: from BY5PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:1e0::24)
 by BY5PR12MB4145.namprd12.prod.outlook.com (2603:10b6:a03:212::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Thu, 23 Apr
 2026 05:09:11 +0000
Received: from SJ5PEPF000001EA.namprd05.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::9c) by BY5PR03CA0014.outlook.office365.com
 (2603:10b6:a03:1e0::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Thu,
 23 Apr 2026 05:09:11 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 165.204.55.251) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 165.204.55.251 as permitted sender)
Received: from satlexmb08.amd.com (165.204.55.251) by
 SJ5PEPF000001EA.mail.protection.outlook.com (10.167.242.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Thu, 23 Apr 2026 05:09:11 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 23 Apr
 2026 00:09:11 -0500
Received: from [10.136.43.140] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 23 Apr 2026 00:09:07 -0500
Message-ID: <5eb58895-b9c2-4124-aec7-e55074c372d5@amd.com>
Date: Thu, 23 Apr 2026 10:39:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<jackmanb@google.com>, <hannes@cmpxchg.org>, <ziy@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <rkodsara@amd.com>,
	<bharata@amd.com>, <ankur.a.arora@oracle.com>, <shivankg@amd.com>
References: <20260422102729.166599-1-hsalunke@amd.com>
 <be256a32-dd9f-4dcb-b9b4-3f2a7fcde70c@kernel.org>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <be256a32-dd9f-4dcb-b9b4-3f2a7fcde70c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EA:EE_|BY5PR12MB4145:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d36551c-6eff-4346-0a1c-08dea0f674e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|18002099003|22082099003|56012099003|921020;
X-Microsoft-Antispam-Message-Info:
	zPYxSSup616s9dwwHr5N00EaY/NaLmJFpROgXM0PpN32mUhFH7C7PgDgLMuR9ztW4j/iB5Tiy8yX/ycLDANVgaHi7OFVfB0j9gHoJ8d5KC7tT8ZpBd4OKwy82+eVDayH+nLxl4sZjl/CYKgEWzxyV9p49DShdzvjFynqP/OKT4BTW0GN5cothMhjgX4E0fa7HugVAV6Vdrc8FdMcSjhuFIOqoeU0DAvhMiAfyhi8rpCwdpykGqw7itleX2PAQJEEOHk2Vbb//XsPQIhqlCDfsgwOU8xPGZvqArcefJjy5huePhmTOm7D6W20TXOqoXcMxIa8WQ+TWhDWtGf8jvv2yAJoyC/Lw5kEB6bBBgoD12U46dU/f1xarJFqLUHwDQpvVbv4kTkKNjK8Ed8Tdek2itPR6R+OLaWBbIau3AJ4cXmu9fDKFPfZ3+faY9YILhSymRz2v3dc3cJGGccDUqBzIibuLGp53FGUaWd5TuvJlVOJ+HmAbty5agP5ut5AfrFcoNcteuJi3l5/7kHs+3OOTulbkJcQgiT2nu8wEer6n5jL33+boUGfouF3btowS2eaTGBQJ0xVQn8SdiS933ziZDjo1sx5ovQDQFaIoqjsA4HaEQ5B5AjI1+cfG7gFXLjSbAXM/h/MU3/iEjdV1hBlrytM+z61WaQRAhvQBZQ2xbBNR7j6t4q5CqGLgJOgyReKhM2uxBWfRw1tfM8P0v+iS/qjnKEZGTFIVECOEHq2t5nzGkLhcUPKF689h8Hjg8TbYKR6RtZkmLdE2Di+gqZbT7b+7hecNCotTh/Mp1qilsHK2SWqbrgA9EoNO1IZ0TrH
X-Forefront-Antispam-Report:
	CIP:165.204.55.251;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(18002099003)(22082099003)(56012099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bw/35Xfhi32T9QBBll/XIzN/otwMQ4hhq0QdTW5GhRvOoroomTgROI6dKzYYuNHkcF4cxaTiVhr6gSpnJvuwWWDZiVu/Ma/QSdgRLvQnFvluMLnM2phx+BvokClrdC43ZD6ejEK8qkieZVVqa4n4raepvTcDgfJln7o3ErDiyPfz5XS8bruF17YO5kJ/+8EUpX9alq4LosbBpxP+TMURKsSJHbLDzmhRfznyt5g0SexaxqEPMAHVoXS/YNLbpQBQLaAb5THno4XWhVNgm6Be5zUkKcWXxMBi6MZQdyXQX+wVxDLFbtRVOc7kKMRdS6et+1uSyBNr8qjtyTvqvffv7Q7R+qCrHeIffrjVfytEdxU4aiMAZylnk8Wyh5ZhpkmPl4vIHW1jddF5FtQgUqGJt8M/ZWugRT9A7GhgMkfm90/YBPLwkOcccQ8Ox5EBLi3M
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 05:09:11.3723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d36551c-6eff-4346-0a1c-08dea0f674e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.55.251];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4145
X-Stat-Signature: tmbhiq9xxabqgj8k8osxdrea3ptym7ea
X-Rspamd-Queue-Id: 06ED4C000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776920955-969723
X-HE-Meta: U2FsdGVkX1+XKiax0r4GKvxMg//Ncui4NFK/xbSiwiHQjwLIT0o/xu/SQUNfuYW/h18Sk+09JXW7qV1lMcG7raAyV59O9t2kGUB3NaOPvEoy8GEbBv3SDce/LvmndgWSEBe08Wy4c9M9WzgryNMA7NbxLMa1O7y5XRagIfSYm+lMBaf7YLqLN8/XnelmOnPP0S5S4eqmDlrKLdifLQ9n1xoLveGxwH4GPH4zSKWtR+ohetPwkqQefr//ZbNqbdKD4B3x5SMVxgVTvaoOVE1+56430MFAI4cMcx+/bZdc+sCDhwZUTPIYqRGAJzJIfr/33D65NZCbZESCuhltyRtGzkjBz6iKr79jsIo+zCh6RuJBtDJdn5b33XoJTP6vAc+MKhz4x8s96E6XrPhdhkHX/lxeytZ55i8h25Bdy8j4ShOKENSIwqAHOBXxa15p3NBhWToRukEUr1u/l28sYWmu1Tq8PEvn+3ZmxsSf9v4GDhWjFLhuXL0bc3tBmFp4EIZVQEI1Y7nJ7bctFVc6ZxRDkGy1b1hVtbUySxMpSQXBl4LwTqG55j7RVJPYenweQfIoJwWM0J8qMHQTFfjbaXDtqmibqy/lLqR61ql7ahCFSPuNpNx+tWlcBJbNJv4DmbA+o+iu5kVknmBAgtmgi0B9z8hf1KKyegJSDjtBAjv+bvePoDxExoTB1dE/RXSbJ8u0heqMVo8XgXskxu4LE8uh6CJBzmL8kkRykM0FG+Rxud9kD1FpIiMr1aysfSZSS0ReOFZkRvMU6eFj8qrxK9UmJ5wVuOmYik/5BfGqKb7Lqukq0OKr3pUaSWCd0d80WvjsVzYfNP8OHGSg9cphj5Q4juAqvBfHJV1W3cT0j+GBzDCmJzbmRGb6QIuaFOtwhN+G/WyhfeJFRvo7iLmquEv7LXQ6xfXsIqUPk87ls6JwRRihHdnib16yVF9pZ97axE9C4/363dnMbBLseEoAzDR
 mNmiSQe7
 FptWiD5lwR7KMM6XWigbgjHmPd/rAqBy4FcX4OBmCZvXdxd88EfOkRm5iEcGQDaTtSQeeypavQY4rUG2J0kRRpK1UNtmmSiYqIsoUhAo3uK24YRp5J/nU9/EJZ2WnxpWqO/s6euFtrn1UIVCm/0eTvbleGBvQkX1RNREUmeQ4eZ0rNZSVJLqBGMbnPqRDL07bWNKUnj4FYPfrgXNoaAoPjhloTIUtKjOi8VnDY/f1EbvYtSZnP5sGYC1nqzsvlq3lHdluWf7bpHN4xHrN+Ztko5ccl20S/MZUA1DNGZLpl2vZo6CeYLeIhlToDD9BoR9/eO6jesfhK7ZxAyqBV4bP1xc3ZLkJQR0SFBM7IjwFXM+zMqX4JcwnQW1+femwJQlhsNGbcDWjfazh2+Lu+42R1lTGRgi4SdbRK4rycPrSUWTSKW4O45H3xe7uiFpF54bLL3tDc+d1waRr/4UPZpp9a0EMNjIdL//DEQBcCZ/p09lXF609fQRRUMuCDasd+IR+iCJ7paxlJu9ZYtv7yO/FNIWNS1xe2qw1Ei7pWtG7dHJY71ErM7YiqIC4OXZAWqg3qrCImC/SRbm5fE3aaJ6UvYKHaTRvG88eIMXu2HmRVQayPSpjE9O7q/OPLd7z80JqbMlY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22-04-2026 23:55, David Hildenbrand (Arm) wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On 4/22/26 12:26, Hrushikesh Salunke wrote:
>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
>> kmap_local_page()/kunmap_local() overhead and prevents the architecture
>> clearing primitive from operating on contiguous ranges.
>>
>> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
>> clearing helper that calls clear_pages() for the full contiguous range
>> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
>> a single invocation of the arch clearing primitive across the entire
>> allocation. The HIGHMEM path falls back to per-page clearing since
>> those pages require kmap.
>>
>> Replace kernel_init_pages() with direct calls to the new helper, as it
>> becomes a trivial wrapper.
>>
>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>
>>   Before: 0.445s
>>   After:  0.166s  (-62.7%, 2.68x faster)
>>
>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>
>>   Workload            Before       After       Change
>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
> We do have some elaborate handling in clear_contig_highpages() to chunk it up
> (and to call cond_resched()). But that function can get called with much bigger
> ranges.
>
> I'm not concerned about the cond_resched() -- we wouldn't do one here before --
> but I'm wondering whether we could end up triggering a HW instruction that is
> uninterruptible and takes a rather long time.
>
> But clear_contig_highpages() breaks it into 32MiB chunks, and only x86 supports
> it so far. So we won't exceed that with the maximum buddy order of 4MiB on x86.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

Right, on x86 the max buddy order keeps it well within safe limits.

Also, rep stosb/stosq on x86, currently used for clearing, is
interruptible, the CPU can take interrupts between iterations and
resume where it left off. So even for larger ranges it wouldn't be a
single uninterruptible operation. Other architectures use a per-page
loop for clearing, so the same applies there.

Thanks for the Ack!

Regards,
Hrushikesh



