Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8783FCFA474
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 06:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55FA6B0012; Fri, 21 Nov 2025 01:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06726B0022; Fri, 21 Nov 2025 01:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80176B0024; Fri, 21 Nov 2025 01:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B8CB56B0012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:28:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3802612F7B8
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:28:10 +0000 (UTC)
X-FDA: 84133634340.21.AA1D54A
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010043.outbound.protection.outlook.com [52.101.85.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5919B180004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:28:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="n/zrClAc";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.43 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763706487; a=rsa-sha256;
	cv=pass;
	b=OsIr2FEzv+R29e6CYGr6zRXHXtbSo15be4aNzJnZlmZiCV6IJoC/iyCc2sgB82V/+wBJUD
	iuqrMsiz6d7gbPi90BtbQ6onaQAm5agI8nFCxtVygSQt1/r+vwujWjDwMQWa54LhhXZlbo
	yS8hcKZ6XSSIZvGq0EJ6NISlHH9cxEc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="n/zrClAc";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.43 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763706487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UblVZmjCNH55MlHej4grXdmVlGsu2AV1lzC9/zQETY0=;
	b=NQwGBNfGUyX9Ywx9fQxlkFifoIBdYnIHPc7RIfK5QgikWQhF6/SaWA9sEdCgchcOTAZZjf
	J5TW0ujaht+v0v/0cG2M0BPA39g5Yeuq22D7qtjnAawHfA9vecUUdIqiGxicBD3085SEgE
	jZv52BvVw/0g1jXLQUum/pdjklJlcpY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D6+BrS4MjY5NHeuhp7NoEDZeRgJYutQad0dU0nKRJwMYpqtrlHsnEH9f2nMTL9+Pjkbtt5mmALleI04L7QZxje/tSCNgQ2MNMETlEim+NgMWuapvDlbxykvFh6uJKfInJ75zzjsM5L9yPjQmRRjbxGeYl932srfvKNDrq2IrvjW4AcEDYq1RuFTJRn5ftTwJQRzf4Q1AWIWgr8o/x+o2+uLfjt6RwuPhNV1ZI3DeV0ApWB/Z3ESiPXk3ddG9LBFsdV7hS82dO2qylrgaqHW4ZH6ofN7A7OIFDPgsfjlfDpuOb5PvdBt/6JwNvwrQUTjWE3NrwgNiPNs4/GsS9uWQbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UblVZmjCNH55MlHej4grXdmVlGsu2AV1lzC9/zQETY0=;
 b=W7JBpG5EqJyjay8870b7sSkKsWIDGjCBMqc6GZVZONKeGNc1E5+UAYHpYzvmJ71JRqiAFzLNG6pSf20HwwKl5kMJzPHpuduqFjb9BVRjszR0aO3rHFqIOLNpDSRJfGOY6euYaD451Rfg9lMJnEz9o4XwDmnFGJ+GEnuxCuFmaLe7lTdWl2oY0emsR8eXv1RLgX2letP/xHdVSz41fNYXlV2wrIHX4kbnGTIh41WAZnslaopLIyv3JDiCal7VfREsvx6xuRBHhbcEdbNUBMb6P+qsKJVP85FdzK6/7ZmA1Qzbf4f1Bpl3ncTqDEhgaSeVdDc60/tnE5F7cnw1azVSDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UblVZmjCNH55MlHej4grXdmVlGsu2AV1lzC9/zQETY0=;
 b=n/zrClAc9FEzjg+Rxgny1ECBPWy6RoMDJlMN8hsXlanFpoOJtDGWdpWTogggZkN2Lyi8WHAy/OHcNuykrlEVWql6Sb6E/Ec0W5URXA1aBqoTiNZgfKpn089XFoXYa1rfVEj+m9sLH9QHHMpDHP1yXsiVVxFCObKXFUQI5G0AKao=
Received: from MW4PR12MB7465.namprd12.prod.outlook.com (2603:10b6:303:212::18)
 by CH3PR12MB9100.namprd12.prod.outlook.com (2603:10b6:610:1a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 06:28:04 +0000
Received: from MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::6b00:b9eb:486a:f10b]) by MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::6b00:b9eb:486a:f10b%4]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 06:28:04 +0000
Message-ID: <faa024e5-c67f-4235-b8ac-b37725b58eba@amd.com>
Date: Fri, 21 Nov 2025 11:57:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251120065043.41738-6-shivankg@amd.com>
 <20251120065043.41738-8-shivankg@amd.com>
 <be698a14-c292-42d1-9a85-109a9072a0b2@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <be698a14-c292-42d1-9a85-109a9072a0b2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0119.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::9) To MW4PR12MB7465.namprd12.prod.outlook.com
 (2603:10b6:303:212::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB7465:EE_|CH3PR12MB9100:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ccab953-a2bb-466c-32b5-08de28c7206f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDRWc054anA1dFNJZUQvYytqRVBmYlJJWFlUdFl5THl2aWRMMU41dE9Lbmx5?=
 =?utf-8?B?UGZIQUxyUGtsSFdnZTZ5NjVqc0ZMSi83Rm1CNGZLdzBlVVlhOFhZM1l5SnZP?=
 =?utf-8?B?SnI5Tmo4QWxOS29OVStoNXI5U1Y0RmFFOGwvMGpuMUU5cXhCTTBGbGhXL29K?=
 =?utf-8?B?QzNrME9hK1pJb2tPc0JJQUxRRVNDOHBZdCt0eU9kUjQ3QThrdW1wOEw4SXNz?=
 =?utf-8?B?U0s4cTIwYUxMZ1ZTZWQ0S3JRQXU5MCtGTUV6KzZiSTM5bUZsSFQxbjIxRGRM?=
 =?utf-8?B?YTNiajh3T3hVTE5jWWkrN1BQdWRJUTcwVmxqYjNxd3o1M0tKL0MzdGxpd1gw?=
 =?utf-8?B?YjFsb2xNRTJRa2ZzMmJpUTRzeHhJZUlvQWNRellibG1rSHhxbldQRXBHZG40?=
 =?utf-8?B?dVp6MHFmUEVaekNvWURwUkpaaWh1WitZOUw3YTZ6ZThGd2xLU1BlZWNHUWhz?=
 =?utf-8?B?bHhsRUJYQkE1cnZnc2FkY2NScmxia3hqUHRxdHRaMTI4K0VCWnI4VmNMOXBs?=
 =?utf-8?B?VEhBVzVvKy85L21GNkNZbTFsWDhXVlNXenFPODlueVg2UzNyNW5wVUVWbDcz?=
 =?utf-8?B?VkdrTnpPNVJEb3BtTURpQWptVWltLzhDUjdOTG9wZHIxTWJmM1RqKzBOK24z?=
 =?utf-8?B?VUIxYWY5MWtGQW9keE5LZGphSGo2SzRINlZtMit6UUJKbmZRRWxjQVRCYmli?=
 =?utf-8?B?OEgrN2FHR3dyNmZZZDFGSFpYVThWM2pUYnMzU1JMQjBrcVRmaWUxYVltdm9H?=
 =?utf-8?B?d09NVnYraVRUZ0Ftbzc1d0FudGxWR2txUWNuRG4xcmlMcjRhYm82M01qS2Fl?=
 =?utf-8?B?cjFNNHdyQWx5TnA2SDlCQTA0ZHNSclNRVlh4aW1XVzFQdHFTK3VZN0VYbmhC?=
 =?utf-8?B?YW4wMnJyakU3KzdmUzcyV2d2dTVrRjlVSmQ4WnNLVklHS2JrLzRpWmVrYTlS?=
 =?utf-8?B?MnJQc1Z1UlRSTDhyWm9hV3JQbmtweURHMmNtalBMbUVlNUh1MGljbWtRY3FY?=
 =?utf-8?B?MEEzTTNHVVRDZGVyU3ZGNy93b0ZHU2x3TDNvbEN6SjA3aWlLbU9JRWhzWkJm?=
 =?utf-8?B?RU4xbVVXUmZUNmc0Umx0eXo0b0cyTFNpQ2RkeWJuUGUwcnRzRmErM1FKdksr?=
 =?utf-8?B?ZEk4eExjSFJWMnUxZWsyRHdIeitvSWlFYjRwWmd3cGNIb0IyRjBQSmdRbE1a?=
 =?utf-8?B?RHZLNHFGdnA5T1RXVjdaNE9MS0JxREQ1c3E5dkZnbjNZd3VYOXpOSWhIT1Rv?=
 =?utf-8?B?ZlBxYVdSck9mTWxQWUZyZUpFNzFnTDdVNDRvVTR6ZXNDcU14RWt5dkpWSjJW?=
 =?utf-8?B?dC9qWVJIYXhJRU16a2lBb3RyUGRHYVp4T0h6YzJGakFvUkUvRytxdkh4cldS?=
 =?utf-8?B?cHhuRVRndEpML2hCL3JGaFZSMG9oZUE1WEVBelpjOVZTRjJtNm56aUhiMFFH?=
 =?utf-8?B?TmxIQnBPYWJIYUZ1Qlg1VTV0NE81TnRBZW5icjY3TmcxQWcrMFY0NEp3Qll6?=
 =?utf-8?B?TnZ6MnJ6c1FhZ3Jlcm1LNEVkSnlDV1kxdkNPdnNvUTZCY2Z1TUJpRE9sNHRZ?=
 =?utf-8?B?dVg1SG5MaGJ3bmYzNGlxTDh2SXhUVCtaQ1lDMkZKSTQwRDRWT2tSbGdUS280?=
 =?utf-8?B?aWZ6WjRGQXFGNE5va1lsdHp1N1M5dEE0Wm83V3Yza05BV2FkVVNERWZKOXBW?=
 =?utf-8?B?cnJqUzNvWjVKNVRWcTRta2Rsa0pvLzBUU1hyNmFHOFkySS9JSXV2dlQyWktr?=
 =?utf-8?B?bXlwYXFpQnNxcDVCZFY5ZXJDZFhocjhFcnFDRTZJZXRUd2R4Rlg1cGZzZFo2?=
 =?utf-8?B?NkhkNmNLL0pnODZISXlZRTV5ZmlOeTVscTBsUXBXM1hoVUIvR015c2kxSm95?=
 =?utf-8?B?LzZodWpqZTZRK3grNTMxNzdSdDh6bGFkTFZKeUVQME1DRGUxNXBpU0lLYktO?=
 =?utf-8?B?SWdTeFg5SWhoeUFaQzlqQ2dNczk0YXVtcm9jN1hPQVhEUzBFbkRhNnJHOG81?=
 =?utf-8?B?cElDcDlBbkx3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7465.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWFIQzNxWnBSdjBLNlZOMnl4WFNBR3hycUVoK2ZLTHAwRmc2V3p5dGJYOEJX?=
 =?utf-8?B?aGJNQWJQUFBXRjNvQjRhYldBNWNBL1dmNHF3RG5JdHkzSStHcVg4cXlMYXJE?=
 =?utf-8?B?c1hvUzZ0OGRTMEd1anJRY0FkdjFQbitJMTZRUmc3Q1QzejIvTFVxUnUzVUFa?=
 =?utf-8?B?MWsyV3Q1d1BPdTZsVWRZSWZzaER4Qks3WCtJdmx3TkJFYTBjcDgyU3dva0xX?=
 =?utf-8?B?bE9NdVN0K1FIZ1ljeWwzcWUwOUJvcEZBYWVyNzZ4M2FySEZMZGNXeTFLSWVv?=
 =?utf-8?B?dVZqYVR4MVRwOWd3akVFd2R4dk1sSUVTV3RqTnkvUHpnTUxkenhOTzFHMnE5?=
 =?utf-8?B?VzZVUG1SRXNlbldUdVVpdllNdFQ0M0FzdmJkWnhEUkVtN2JqYnpPZ2szR2Zw?=
 =?utf-8?B?dWcwaTBxM3NQRnU4VFhQQVVPNTZISEFvMVNoY09oQ09ibWMvWTVWTDVuSjd5?=
 =?utf-8?B?N04yL0lVd09xVUduNDZJR3dpSERocG1ERFpSaVEzTEJaczY4Q2Nub2QzWnd0?=
 =?utf-8?B?YThoWm9ZUHhQcnpwUFJzWVJnS3M4aklma1dOMGdCUndJSThBUzZiMXp4K1F0?=
 =?utf-8?B?Y1ZaWkwzREZUVFA0RE5sNFUzYjRwYXlyUGhsOXBaR0JRaG03N3pNSkZmTGta?=
 =?utf-8?B?N1VLTkNha1hwV0k0dHFRV0p3OFFBUnoyWHhpN3pHU203NFlJdTI0V1YxWGov?=
 =?utf-8?B?d1ZEdmxjbmlZSDBOT21WV3hlSnpxcW1LcHJCUTd4cExBb3RBVTQxMFlQbE0r?=
 =?utf-8?B?eks2cWUvNitzcUV0alJJYjZxN3Bwa2lUTjV1eWVVZ0NWQ3JtaTA1LzJQdmcr?=
 =?utf-8?B?dWhpVk55bjdjUHRvdFlhTWRIaHRtR3VscEhNZDh6WUd1QWNUSVJXOTZDUEJn?=
 =?utf-8?B?TUJYQlh5bUFYOGpnMGFPUWtZWGt0OXhMYklwK0FhekF1TVV4a2c5YUU5VTlN?=
 =?utf-8?B?SWNGcmdRL3o0OVdIeFhleEYxYXNXOXVkWFBuL3laSlZXbzhZQmpLTzIxN2VE?=
 =?utf-8?B?U3N1cnFGZXU4TGtZMVJFTEQ4bFdmbzB6cWNqeHgvbmhTWWJucmM2VHVuYk9T?=
 =?utf-8?B?VVVvNjNMTFU2d1VWZW50Sk5SRS9KUHJ3Q3I4REtmMi8xY3dGb1pLazduT2pu?=
 =?utf-8?B?SGVxR1U1QUZlMXZLYk1FSXNpQm1iYklUQ01aelVIb1NCeHU2Sk1Lck4rSW5E?=
 =?utf-8?B?NGJvVDNzL21oMkdNT0ZXUnR0Mno1QTA4U0JELzVNSDBkVUh4REFlRU1Yekdp?=
 =?utf-8?B?dGRKcnYvbTUzS0t0K1VHTVlCYUlWL1BDSlRSWDhQdkZFZGd5TnZ4OHNqaTlQ?=
 =?utf-8?B?MUdHQVZNKzhYdkYwYWxKQnNTdTZYNU9vVldVbjBTNFppS1Y3ejNDNjlYdTF3?=
 =?utf-8?B?SnQxclRHc1d3M0t6bmhYWThLdDRWY3A5SjZvYjdaZUh2NE9ibk1oRjFwRkNZ?=
 =?utf-8?B?bmlwbXBFWlo1TUc5QjdNNWJhZ0JROG1GZTQ3ZWh0eExkK08vZ2wzWi9COWx0?=
 =?utf-8?B?dHJIQndIbWZVdEJHK1FuYmNGTDgrUDNBK1pHSlpkOVNnbUY4TnV3dFJKaWdQ?=
 =?utf-8?B?UzFiMjVNQjJFelozK1hmdG9rZ1NGbTVOQ0dZUlgyRVdzd0Z3UWY4alBEL0RD?=
 =?utf-8?B?V0NzaG1MUHg1SndzYzNXQzE1Z0RBYWtwZTJEVlhNQTQ3NXVPZjlEMm81L2lJ?=
 =?utf-8?B?dGFzLys4OWQ3Z3k0MHNOblM4bWNHTklhRGEweTJ5VTVtQVRwTHA3YXdqZG5s?=
 =?utf-8?B?UmV6eEhaeHJtU2h2Y0M0cmEyTXN1QlZWdDY3cklzRmdBZHBJMVNFWWVyUnFP?=
 =?utf-8?B?TnQydlBpS3VMZGtGNFQvcVM4K1pqU1pvMGxzNzV4OW1BbDJNWm4xOFdzeW1R?=
 =?utf-8?B?d3lNaUk0TUVaSXJjVDlaNnNENHhoeXc2K0VTNkg5MG91RjJ0RURCNGNlbm4y?=
 =?utf-8?B?MVF6d2lBZGo5Z0MvMEZWbTRzOE9MUUpFaWlkSVcrSWdpYUNJLzVFUWtaUFNj?=
 =?utf-8?B?SUFmckhxaGh0and3Yi9KZ0tRVzlBOGExQWV3Sk1Ca2JSVGdtOHdKZFM1OEhi?=
 =?utf-8?B?RWpCNVdkaTh0cE56cmNuN0dHNi9MWXl6U0xvWjdiNENhYWFMMWdPKzFjTXRD?=
 =?utf-8?Q?WmF1vPBosB0pt25P81VCdswC5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ccab953-a2bb-466c-32b5-08de28c7206f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7465.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 06:28:04.1809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHihfWft5RMu9xFj6OgG/KNWHu+WEA9UJGgs77kJoHmz5AQ7w0tUzCnbeVg7arv692tUxV/whvPq3mXCOc8jIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9100
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5919B180004
X-Stat-Signature: u4hnmetiok5zz7aayp5tktsbmbme7hkh
X-HE-Tag: 1763706487-619844
X-HE-Meta: U2FsdGVkX1+eDsvH62f8HLRv8Ti2hbMJg1AQEaYVSsDFl0UqrmhkI2/shffstnOuJzCWQNpJ8Q6RUh5NvYd2doGR2vMGuRcKY9ln3nQrcAFbpvB16gh05bLFF/6lhxqEUZV6o803fL4jv8W1xoLI4nztXE70ogBio5dV2kogfPkN5IDBdlkOJLbTg2uSnnkCWVCWou2+H+aynOhm0e3dtEF8sGj+fC5sg1n+JxkkiD5JjC4/paL/7xOy9DYc4NGqXVkTcg4qxyp7ROpUkDcth6xkpKHZ51KQfH0nWZ3s90h9x+Edb19uvURtwUlQcorndK9jEVlt4hlT94ZPGuU1Weh5AuXlMPKM2nyrzwpk51f+15O9UDrRVk4OeoUwLotXU/130A6FD8jeoM0M3UVRMjWiZ6jxY1UPBpnWzUWzTEsmf3VxjUnr/nXehsqtlshTibxEzge1WgiBEmWSXyUubTv6yI6lvlDhCLY8QcVxyVMkJ8IEA/sc5yned6zHxAaNMTlzn7iE/ZwjD27GPThlP5ST0eyLyIMLvCIwpwxWvUoD2BeT5cVj5o7TCMbd+u+bZBaqdNtAjU16UdHk7EfjFGBbO5xiv5SvUIeITGSZ7OEfAjZphJCjFOakAprj8ESFNiJlC774LievGZAcOzwHxy3lvrXMDohbF3bgrcByKu1gbql8o+FnpK7SerWWU1XfkngAMTb8xuR5m8lSIeqL2gzSzG8gSaJw8oZU+6iI7ra9tdGSKzyxDC0IOrV/jg1d0E8tk+6+6WnMXzWGtmIczYlTGVfI5+n+EoE5fsCEeWgnzUrrzhRfkt8CKaVVIiV868VJQioKKEijuySqYbjOrN6gahbrk13mE101+Wy2A8kA2X0R4saok1HAoixOGhcuDms4xI89LS4AYQ49gL00/GHBysu/XCZMn3cJ17VH4GWO3cHzShHvkvXFXvF7w2dIUYS0MgccllKwwd3Zc3J
 A26B/mNd
 593TZu5YhLHRVkyCNkvqQQltWFVreDJRt8eVSOUgD0B/DFwGJhcrUGnTBsZIrYCNFGfm0RSlBtwUFiQxzI3wDLxbvyNox6t+Wmxz91y4AZuGSVvksebzjoBZci7E6zW0cFqigYB1dKC7YjdbllwQupn90cRSJLIPYB8VRX+j/iiBqGdPo1OYp7j7btGKWkKTn1UsqJXVEqIO4BVJUrGDZtuqKOPTsEh59RZxcoYs38AptTE5OLiuh6UGyjtsc0PmGrX9wyGlJlUzK97/4WvxSWqp43spjjFPutAgeEVb7u/DGLwLJsAdlU+vQAiA/VzVC6lRqcQZFeMCYJQYqNo6gObpV2PAUvvbrwRCfDXnrg1MP3v5IMsFdMJSDwK0Vzm8L72TE8BlkvjzZ5Ef0YEReX/kiIJIeA7Q5ul/eSTdfaL3OHbRTKVQj81CckZooRFd0wt4LUhDMd074fahY2lrUWSqKvi/PNuNH+9LSJgAnJJtsv1ouo9mXeEFJRqUsXha22+v86zYgzBneo0hpfMkf4NcZ1/rUgmL7ME8R4jz0lU3bE1W8VKLH+kiSNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/20/2025 7:05 PM, David Hildenbrand (Red Hat) wrote:
> On 11/20/25 07:50, Shivank Garg wrote:
>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>> text sections), the pages may still be dirty from recent writes and
>> cause collapse to fail with -EINVAL. This is particularly problematic
>> for freshly copied executables on filesystems, where page cache folios
>> remain dirty until background writeback completes.
>>
>> The current code in collapse_file() triggers async writeback via
>> filemap_flush() and expects khugepaged to revisit the page later.
>> However, MADV_COLLAPSE is a synchronous operation where userspace
>> expects immediate results.
>>
>> Perform synchronous writeback in madvise_collapse() before attempting
>> collapse to avoid failing on first attempt.
>>
>> Reported-by: Branden Moore <Branden.Moore@amd.com>
>> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>   mm/khugepaged.c | 26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 97d1b2824386..066a332c76ad 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/dax.h>
>>   #include <linux/ksm.h>
>>   #include <linux/pgalloc.h>
>> +#include <linux/backing-dev.h>
>>     #include <asm/tlb.h>
>>   #include "internal.h"
>> @@ -2784,6 +2785,31 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>       hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
>>       hend = end & HPAGE_PMD_MASK;
>>   +    /*
>> +     * For file-backed VMAs, perform synchronous writeback to ensure
>> +     * dirty folios are flushed before attempting collapse. This avoids
>> +     * failing on the first attempt when freshly-written executable text
>> +     * is still dirty in the page cache.
>> +     */
>> +    if (!vma_is_anonymous(vma) && vma->vm_file) {
>> +        struct address_space *mapping = vma->vm_file->f_mapping;
>> +
>> +        if (mapping_can_writeback(mapping)) {
>> +            pgoff_t pgoff_start = linear_page_index(vma, hstart);
>> +            pgoff_t pgoff_end = linear_page_index(vma, hend);
>> +            loff_t lstart = (loff_t)pgoff_start << PAGE_SHIFT;
>> +            loff_t lend = ((loff_t)pgoff_end << PAGE_SHIFT) - 1;
>> +
> 
> Hm, so we always do that, without any indication that there actually is something dirty there.
> 
> Internally filemap_write_and_wait_range() uses something called mapping_needs_writeback(), but it also applies to the complete file, not a range.
> 
> Wouldn't it be better do do that only if we detect that there is actually a dirty folio in the range?
> 
> That is, if we find any dirty folio in hpage_collapse_scan_file() and we are in madvise, do that dance here and retry?
> 

Good point! This makes sense to me.
I'll send V3 with this approach.

Thanks,
Shivank

