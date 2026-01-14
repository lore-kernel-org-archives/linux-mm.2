Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B972ED3CC88
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 22:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2626B0005; Wed, 14 Jan 2026 17:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C4E6B0089; Wed, 14 Jan 2026 17:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6ED6B008A; Wed, 14 Jan 2026 17:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0CC66B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:57:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AF361A654
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:57:23 +0000 (UTC)
X-FDA: 84332082366.22.EEC3CC7
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011006.outbound.protection.outlook.com [40.93.194.6])
	by imf22.hostedemail.com (Postfix) with ESMTP id 727B6C0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:57:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0pIiiDaT;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.194.6 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768431440; a=rsa-sha256;
	cv=pass;
	b=M1Yn8gcrgOC6qcgC7UyWMiCLfvLw1G2UA1cVQAp2o8AB+4BEf5Wthpxtk0Kur++rBVv2SW
	MNa4b9Sz/vfQuKdX8Xl9TmS6zHu7PrOm+H8ECcDWyV2mNIOjV2eQi0yvfoFMZfdiSK3ZTD
	gEABucz5BT0mZLJfbRPuH0a/hiPgiLY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0pIiiDaT;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 40.93.194.6 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768431440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBJu3S7lTT9Ovfbg0fRc/BKMcB6ZnCr7JZYLGfwhanY=;
	b=hjWKis3BSWsOqchZrVDiot/pn0aiVszhqWejh0vVusAoa8aIpXX2QQk/LRVIj1pmEEwtvR
	rPqlsyiU+zu3YzXTczM4HrGHRcU8qJqQHE//UrwogejqMus2AfijkO1qX28YHFMxmsToXE
	0QhSQiSt/hA/AKSNEFb0KrRF8nHniAQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LfqipeMTk9CcTCKMaiOtp151mEYfcUMps1s9hPra/TTP6ptVyYMelIKo2Nt4Y2K4+sryZSWkQqjTMXBF7zB7rCVZ1yRJko6MpO2j0v6xo2vGso+QFxpV8LP1Snk04pLskEPiRxOyt+SUfLCC7Hs81bjp/9JFnzImEw5siWv5H4zCpbQrr+BB84LJ/pkn0fJ58Ib/dOB9Mt2H6NZjsRwE3Hc9gCZYC7ae2s3YsFwwVyt8ot+nb3hIyJojaJ+W4uuQcYxjhLObvEbzWpNIpP8naFto/7ep2HFekTHiY2E0eUnoavXQE9V9h0UFupabpo4ykhkB2Bfx7N/i/Jz5pf3mMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBJu3S7lTT9Ovfbg0fRc/BKMcB6ZnCr7JZYLGfwhanY=;
 b=n59JkqEJznqDIWPJk/heamDcb202plVA5arDQS4Okh4/nxocDFUeFQNee3ib1xDDckfUkdU7IPqC/YYw6abAvfvyZeKxqfrvM/ypWsEepur5ATGbDd7ZbHvocfHg14OYNIET86n3ANym+jxPQyhPY6E2zxSV/4lDhiW2qPvqH0SR55dXKxpcrEONB0fNghmavhwzW/WyDwILpfPn3XPComkpNG2SpY4No2YgdDx0byifMOE5kByfLA3pDsOFmx3BJLbyonch9cb8cDeB3ufWhlxo44xQtUanrMKmH11Royy/a7lrvPYlMkUptwuCf7jVJBqZz9n1gl+qLiGuGAZfWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBJu3S7lTT9Ovfbg0fRc/BKMcB6ZnCr7JZYLGfwhanY=;
 b=0pIiiDaTd3EqOHa1KcFX8gYv03ii7+5327LH9IHnQ/agZGxVIHbFTYkTG6wmXr1s/ZfE/K9hHcFtTuoUpt3QC9P8hUdkT4JO3GK7ov5VTxzhBEz35rrbzm4jGcZ6qVtthe0jmNlswk7GOvlGu3Yk6TdXVlypsHcDHgtlmpmEoIw=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by DS0PR12MB6389.namprd12.prod.outlook.com (2603:10b6:8:cf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.5; Wed, 14 Jan 2026 22:57:15 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 22:57:15 +0000
Message-ID: <928e1004-231d-4dfa-a7fd-0ae2d0e13616@amd.com>
Date: Wed, 14 Jan 2026 16:56:57 -0600
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: Add support to unaccept memory
 after hot-remove
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de,
 thomas.lendacky@amd.com, michael.roth@amd.com
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-3-prsampat@amd.com> <aWYctexPTf-w7QT8@thinkstation>
 <af3bf2ef-0231-4e75-9a80-c2bd3a7e1bf1@amd.com>
 <aWaGBandNCLT93Tm@thinkstation>
 <7283516a-ee5b-4226-ba32-1d9325eb6748@amd.com>
 <aWdwIvzPDqY21cbS@thinkstation>
Content-Language: en-US
In-Reply-To: <aWdwIvzPDqY21cbS@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::19) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|DS0PR12MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: c8c96965-0d92-4e8c-dc8a-08de53c042e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVFjU2ZSWWdoUzFpQ25DYzhyckk4SFhTUDJCYXdJd3hDRjYwdE5qRDlYeUhv?=
 =?utf-8?B?U1cwb2JCaUo5RDVtbTZlT3hqdkZsVTJMdDY0N0k0ZFNrbGlKQzZORXFXNFYw?=
 =?utf-8?B?YXJWaG04K09NbHZzMElWNFRMS2xmbUZybmJlZjZuOWF1TU55a3lLRXNkL0RT?=
 =?utf-8?B?Umx5emhkMDZ2di80RUorMGRtVUFSMXlIdDl5N0RDeVl5N1FVc2Z6Qm9SOXlF?=
 =?utf-8?B?a3RyWXlwQzVzOXkzUXJodGUwRkk5VHFrcG1YRFZxZW80SGcwQ2h4SXQrVDhQ?=
 =?utf-8?B?STdOZjhGT01GQmhnQ1ExZWQvTVpKQmw4akQ2MzN2YkdQQnFIYlQzTENJQUFY?=
 =?utf-8?B?QTM3OWFyc2NDMlpZSmtmZUVLUkZKVS9SN1ZteUVmZXpJVWlJbmNEZXlXRm1E?=
 =?utf-8?B?bkxvUHVFWkdpUmNzWk51UTNnM0ljRzBkVlRobzc5MzFER2lkV0piZjFveU9u?=
 =?utf-8?B?MHlOQkJiQTIrMGY5RkYweWVOWWxEZzRVZnlhbmp6ci9HV0dXQlA2UytvczRL?=
 =?utf-8?B?Qy9OTWNsS1NlVlpVenNaS3ZnYStZVzFlTCtyQitWZFFxVllBc0hIck93MW0v?=
 =?utf-8?B?YUpPbEhBR2c1QWxtRldQTHFvN1FYVVI4bHltSS9vY2R3TE5TUWtEaVYzUUNq?=
 =?utf-8?B?cjFyOUZ1Q1RRa2xHWnBadVEwRmkzYWxKYlhtaWVmWU8zZkJoWnlEaUJRZ2RI?=
 =?utf-8?B?bHd1bmJoaWN4SUhNNnRUcUxSWHNYa0VvNEVRUEpEU1BYSURyZUl2SGxnVWpE?=
 =?utf-8?B?anF1ZWl6bzdTT3h6UUFJYmd5SVVXeFFHRXROZ3ozTWZ5MEM0VnNGOERRdml3?=
 =?utf-8?B?TW9HVlBuTnhya29rd0R4VGY0QlI4bisrUHZzNG5yUFg2TkNzeWZvOVN5Sk1s?=
 =?utf-8?B?QkQrT1VIbnIzMTVtckh3dXp0ZVZIeit2V0RVYnF1alg2RnJxYjkrZVd0Y3Rp?=
 =?utf-8?B?RFZ5SGpSTTRXTEg5Q2VkOTQ5TTAvOXRyMjFkUkIzRWw4M0Rwc0ZicEZFWHVl?=
 =?utf-8?B?bnhaelNmZnkwRmxvSGVGdTdCVTNMcUNOQlJsV0Z4Z0pteEtIZDVUSmkyOTNl?=
 =?utf-8?B?dXYzWE92NVpuMktod3lXVFJ1UjJEaldmVUNXZy9aT0tGYkkzNythc1JvVU9P?=
 =?utf-8?B?U1gvQzk0eC9xMjZnR0tLUk16elRFVEJNNnVya3YydFRiVEhUV1l5dGxWRDVL?=
 =?utf-8?B?bXdyUzhxZkcrbjR2QmJnQjJlcnRTVVpwYmRyUWhrOVRWVXdjeHRqVWtTZ0JY?=
 =?utf-8?B?VEk3NFNvSlpLQTMxbU5KK29HZmc1MWZLbGlCcTlzemRxdmVXNWpBUEMweHdV?=
 =?utf-8?B?c3RONWwvUTE2dTFSSmRSQXhub0FkR1RCRFhMRGRndzhrWWZEWThuSFJwbklw?=
 =?utf-8?B?dG01cGNDK2dtL3NpanRNRGlaVjZWWllyNjVZenJQcWpNWW1lemVrS2ZSeCto?=
 =?utf-8?B?My9jUGxKQXZ3TldqNmRhV0dLTGxoK21yTmdkWlRIcituTGFGMTlvQjhhQ1JR?=
 =?utf-8?B?WUJEWlY3KzV5NU8zV2dsMW5udW5FMHdUcERWOWdZNXp4dm5yc0M4YkJHOCtU?=
 =?utf-8?B?RlJUYXRlRnZ2YjluNEVrYW5RZVZwU1NDeHlEVFlEU2pIZmZ6aXA5Q0hsVU1q?=
 =?utf-8?B?QzJXM1Z1T0daVWp3VkxoRUVKSW4yQ0kwaGh6MnRXRUtDRjNmQnlYNGwxUkVa?=
 =?utf-8?B?VDcvOU93VXZDTFBBc3EwWlBFQ29vY0JDdnR0YkZPRzI5N244QWs0VlFWbks4?=
 =?utf-8?B?WUY1bUxXM2pPS3Z0clZFUjhPaEFScmZmak85NjJQdkVVUmJBSlMyb3FWWXNE?=
 =?utf-8?B?RnJlL1VzZ3hXMzBBdnVPdVJzQzhZZE5tY3RTZGVSV0VtVExjUCtlSmhjZlhm?=
 =?utf-8?B?VlUzbms0QW1UL2k5MXJzWWNPcXRlYTBiakhlQ3RrL1ltKzlXRkw5OGdFMXhG?=
 =?utf-8?B?b1RHS0xOeWpSRkw0UmMrWjVQQ2g0c1I4NTJzWHdSMFd5bC9GVXpMWDNWazcx?=
 =?utf-8?B?SUtoWHhDMFNoNjZtbGNndnlBdVM3RXV3YmhJSGZEeXZETEhJRlpneWNmRmsz?=
 =?utf-8?B?TUs3TGM1d2JjSEp5U2xWaVFUd2ZmTExhTFZzRTl3ci9xWHNhbHhnQS9NWVZB?=
 =?utf-8?Q?Hs6s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUFRaHhISFROZDAwems5T09uSmh1MFVKREswaEY3VWRqOStaUmIrcndvT2di?=
 =?utf-8?B?UWs0eGxvVEZXT2pkajUvTG5QM1lzc0lJVytSZS9WcWh6OCtQK09FT3NiWjNv?=
 =?utf-8?B?MlJzeE1RdDZTSk80bWY5THhXTG9JOEFZUHdrRjE3cGZRaC9EQko4WmtTYTdn?=
 =?utf-8?B?YzRPZUZ5WWhTSnROZlpKOVFMYUJnMkhyUzU4SjU3V3lwUFpCUElDekRQRlhi?=
 =?utf-8?B?dURXSEtvbVZoTlhJUGR0YVlZRUg0cjZKTmkzTlZNZTI5dlc5U0VmUncwTjk5?=
 =?utf-8?B?SU9LRGFhVy8rZHBheHpENzdkNjRGQ3Y0V0NZRHFhMEFmZi9MRlFHcHg0NkNN?=
 =?utf-8?B?bWFQM2VBT0NkOXZZWjZ4MDhkOFJ6YmtaZk54SFFuOTdORFdsaG9VL3ZyTWU1?=
 =?utf-8?B?TjQxVFFra0U4Skh1RWM4eGd3SUF1TGhxdmpIN0NxSUlZbU01OHIrRnc3R2dL?=
 =?utf-8?B?NG9adTZCMHM5aDBDTW1wNDY2bG1tRnR1OWg3MGpoOEphRjVNRE5IRlBxODVu?=
 =?utf-8?B?T1RHM1pDQVpkdUlJK1R6K21HZnpTNGwvcmZ5TU5TcUg5MHNsNVJXbHlIelZl?=
 =?utf-8?B?RWl0bXFXckltckZPVmFPZ2hSY1J3YmpuU3FMQjlSWVYwL2pEUG9FZ0MxVGRr?=
 =?utf-8?B?dEttMEVLQ3lJVForeXJQeDREbVRWN3J6N1NkeEVyRE53UlN3NDEzVnlmVFRY?=
 =?utf-8?B?U0NXc3ZJeDlkOFkrcTV3eURwNFpvc2w5UFJoYVZITnlQNk91WEhVRXdjK3RN?=
 =?utf-8?B?VlNscm9sNVlpVUROVmorQ2RGeUxPdGJ3WFFhUTUwOTFZSEtObFBDOTRGN2F0?=
 =?utf-8?B?K1pxK05oNldpeWtTSmkzMUJqTTFRSGFyY0JWT1V6aDhDbG1LNEQyZUZmSVd2?=
 =?utf-8?B?WmQ0UHFibTZtZFo4b1h5cVJmWVhjMjJhZXN1MUVmQy9ONTFKSHN0TjhEaDdX?=
 =?utf-8?B?Tm5qUW9PNnZWaVhEZEY0czVjWFlqenJZUXlOaXRPNmZXVVpQWG1zb0pES2JZ?=
 =?utf-8?B?dk5RVnF0eFdQaUJvTFhmNlYzck56ajNWVGpvVTFBcjFUU3JVMExKaldpN1Ar?=
 =?utf-8?B?UUtRd3ZVRnF1SzhTOUxXVDdLNkhHOFhuNlJHenNkOWMrRXhvN0g0bkFHT1Fs?=
 =?utf-8?B?OHJNUTF0SzBMUmM3Y25vQUs1YUU4M1hqS0pXU3ZUdTFVK0V2cG95Mm40MTVn?=
 =?utf-8?B?eDhjOTQxVmkwemZRYmppTXBzN0VDZ3c2SFAwUU80cXkrQTdDbHI2eHhub2JK?=
 =?utf-8?B?cGNUNmFINzFETnBXajAxWWlkcWZjNU91YVh1a3Z6VDNobnEyMkl5U2JiZjZn?=
 =?utf-8?B?UUo4NzVaTjc4ZU1wSHpQYUtBclJFbTArVFRPb2lJbzlLeXVNMlFYem50Q2dj?=
 =?utf-8?B?ZmkrZFdmc2VteGZRNjVVTHUzUHFud2U1Y1c1WGtXU2xBZnZKalVCdkNCVDNi?=
 =?utf-8?B?T0hQenA2U05hT29yY1Q3Tm9lWFhzVTFVek1hdGxlYlpZV1U5N0V1anFLUkc3?=
 =?utf-8?B?cGJPTCs1aVJsRzQ2cEtmUEtlOWxtSERzUERjdlRHSXVzSkNXb2drcnhSZzJG?=
 =?utf-8?B?ZzV5TkF6M3VVRncvUS9WL01rTXhEcTQwaVFPVmRrWUJHcmJkOGhhWGFiOUtn?=
 =?utf-8?B?WmVjMFRWZFB3S2llY0syaVJabWJOb1dBTkNaZGJqcUVXd0ZZOURKRzFITDVM?=
 =?utf-8?B?K3NqYkpSc3dJNzhhRFVzN2hlaVBVc0ZhL3RMWjkxVEhHMFcvbFBPMG5lTTRO?=
 =?utf-8?B?Tmo0Q0ovdUF3c1dWL0FWSVJsdE5PcW04S1BEOFlOcUtMelY2VzI4VzlnR0pj?=
 =?utf-8?B?R1VPWGZqYzB5VW1BcTRzdk5DRVJ5czM0bDAzSkpUSytTeUExNVB0MkN5WWtV?=
 =?utf-8?B?N0R1SUludHhRZDQ0dXE3MHpHVHVkODkrdzEwVmcraTFnUUdIcTA5NzhYWXMy?=
 =?utf-8?B?VTdVM1BIWVNDbWE4SEJaS0VNNEFLMkV2K2ltNkJ1ZHpVUUorcnI1RmJkNUZ4?=
 =?utf-8?B?WnpUdzh5d201VldpbXlRT2IvK2lXb0ZtcW5LWnR1c0I2ZVZFL0p6NWlYWElL?=
 =?utf-8?B?UTBhK1ZxWlY4ZGMxWFFydjJzZDB5VWJNeWxsLzMyQUUyanNHM1ZIM2xiZFRG?=
 =?utf-8?B?S292WE1sdjRnanpCOE5JZGErWWhqT3JDOHpGRXEwTVo4YUJZZjhwcTFBV2RW?=
 =?utf-8?B?WE1mWitDcklkRm1OWGtHZXFrcE9LQnl1Z1AzemlPWllvRHF4MVRJcEluWFJm?=
 =?utf-8?B?Q0p2SWYydlRkdVAvMENoZEo0MC9pb2RIL1pYTGlydGlYeWFUYm56NytuRjdU?=
 =?utf-8?Q?BDvU7UyL0Bfg0Fe4SB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c96965-0d92-4e8c-dc8a-08de53c042e9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 22:57:15.6250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BO/BhKvnxcL81O9wQqp/v/S0a/DSpP8TvpAqDfo1W9vZGv1wOSiR4jvArDPOaIDwEXltDIOuj++ygrYNXy9JrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6389
X-Rspamd-Queue-Id: 727B6C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: ypa135eo9gdn51so6i4r5bk69pymc3qy
X-Rspam-User: 
X-HE-Tag: 1768431440-345415
X-HE-Meta: U2FsdGVkX1+TPi+/Mx7mCjFzG2A76IjBboiyXTYpQwBARUFyES5l7E5Mss26PWzlmviZf0jYxTWPM+WxRDC0B4gyp5xuql4x5dFc84KNhk3xV6CAZ0h9lu6x4hWvkSPyNysP9P6PA5BXy888Kh1kQtwoWeWCYzdKbKdqKoHi4w9r28uXfiM5mfzHTUWA4Eyz9IIe0/NXgX0TFCET6ozjeOUBohVXeh1HkLTOe8cqhIIf37ViFhyCHpU1zs/skIDW+z2zGLPGc/VWfzgIE4HcPNTsgii7Pc/E2Sd0izHP34T5nhvz6q0QCvedSA0/Ah+3QkBmj/CON/kHwo6xUZxE/ehuVBJbVL46Zhv88fSVo7maLlzHGpqI4kIK1lMFsG9vF6MgGOiR+FOpI5CjiCjMOVr8OtmTKuAa25Ocm+IgDB1BRWLOX752r8L20pVvZVsmZy2fX8w+BWIyKRe2COHB3YICypVD9yJ5uuLXmUGXKC5jmDmdr7Jz3x54xzMEkJRRIqq89HLYSd32v0qfWAbNt3AR8p7wxuGImeOwguZ82hMrjCtAtLVqmNlqf5aIZD0t7xvzDQJkruu7soZBnN6ax4gZ2DEF2+dFm7/ji3an4jCkk8mv/yBUIt+vDI9vEUUwwI0RIZn37z6UlGHHWqFmL+ug4tsem6ZgSUx+JDvIq5T9bYSkrzkz3VG0DbmeROkq6tRHtPyQL8QWJ/BOvCHG6iec2fOOp7dZeOvIiKXF6NNVNoUYlyNAlXphC+XW0nNO7rLNs4UD6UwGxyfvOmh3tqCYlU4tJF2vy0JuaM2pQEE0tDCEERMAkjw68bTh5kr6D4PMK1XGoUhAoEs6OOtlcqf8DJRkeEQ8GhFqN1RXYu6/6f0nrHZoKURgT+Aa7efme+1OST3XQwCRSskWuRDpmlrBRp+dnyCFcLJVvh9Z2C/6gCpmsf1YsjnkauOzmrFLfsRkGM9NIbOZf35N8Ik
 jRB7Ri8r
 FVljviw6RrxkoFE1zWBmzLmByrR0gnY5aDYkk6j2WpZnj1MbXimS3JKeHBwVzjUkPwqlSJSvXLqob6U73nH9WI9AeOUEi5nh51HtCa30Uve/gNaVI21hN2anb7RMfFw3eKtmv2aY8dph+zURvo4QWIeW9zLaMXFV4TPcVPUT9E3Z3o0r+D+thQFU+SmFrPDFAzjN8YX/zjesGPDW8i5uMMcjaFYDLZnxuz34AWf3I8f7Vq9dqksOst4GIK0i+8ks6y4zpFwROPJxEQf+uPK1mPHJvxYSCfdXsd5vHOIW3nmDvJSSNHMOLHUf51K3n1x28CiZ1QMNB9nTnjiXY1dmBjWJdMyBcY8cgjb3HAlu58RSPfrO4IqvoGrntvthW6kRiODSuS6yJ7ZW1UrobehEzGV11co+yiLmuRWzKflXwVfHEnyakY1lOWvcajgO9jC013BUljfgBSYjqx9B4RhAvO52ucz7/afPxoBUshf+yoTNjh+pIU0StAtgRARg9pTcNIQEQkBrE/+CSzEs0UOm93kyfz4vPkFmtPgYbRmMgfUh0VqXea0N8h4MUbTFmCT/63IeEgoO8/RdjpZY50RmGPaeIC5CSdEj55KGr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/14/26 4:47 AM, Kiryl Shutsemau wrote:
> On Tue, Jan 13, 2026 at 12:22:33PM -0600, Pratik R. Sampat wrote:
>>
>>
>> On 1/13/26 11:53 AM, Kiryl Shutsemau wrote:
>>> On Tue, Jan 13, 2026 at 11:10:21AM -0600, Pratik R. Sampat wrote:
>>>>
>>>>
>>>> On 1/13/2026 4:28 AM, Kiryl Shutsemau wrote:
>>>>> On Mon, Jan 12, 2026 at 02:23:00PM -0600, Pratik R. Sampat wrote:
>>>>>> Transition memory to the shared state during a hot-remove operation so
>>>>>> that it can be re-used by the hypervisor. This also applies when memory
>>>>>> is intended to be hotplugged back in later, as those pages will need to
>>>>>> be re-accepted after crossing the trust boundary.
>>>>>
>>>>> Hm. What happens when we hot-remove memory that was there at the boot
>>>>> and there's bitmap space for it?
>>>>>
>>>>
>>>> While hotplug ranges gotten from SRAT don't seem to overlap with the
>>>> conventional ranges in the unaccepted table, EFI_MEMORY_HOT_PLUGGABLE
>>>> attribute could indicate boot time memory that could be hot-removed. I
>>>> could potentially unset the bitmap first, if the bit exists and then
>>>> unaccept.
>>>>
>>>> Similarly, I could also check if the bitmap is large enough to set the
>>>> bit before I call arch_accept_memory() (This may not really be needed
>>>> though).
>>>>
>>>>> Also, I'm not sure why it is needed. At least in TDX case, VMM can pull
>>>>> the memory from under guest at any time without a warning. Coverting
>>>>> memory to shared shouldn't make a difference as along as re-adding the
>>>>> same GPA range triggers accept.
>>>>>
>>>>
>>>> That makes sense. The only scenario where we could run into trouble on
>>>> SNP platforms is when we redo a qemu device_add after a device_del
>>>> without first removing the memory object entirely since same-state
>>>> transitions result in guest termination.
>>>>
>>>> This means we must always follow a device_del with an object_del on
>>>> removal. Otherwise, the onus would then be on the VMM to transition
>>>> the memory back to shared before re-adding it to the guest.
>>>
>>> This seems to be one-of-many possible ways of VMM to get guest terminated.
>>> DoS is not in something confidential computing aims to prevent.
>>>
>>>> However, if this flow is not a concern to begin with then I could
>>>> probably just drop this patch?
>>>
>>> Yes, please.
>>
>> Putting more thought into it, memory unacceptance on remove may be required
>> after all at least for SNP platforms.
>>
>> Consider a scenario:
>> * Guest accepts a GPA say G1, mapped to a host physical address H1.
>> * We attempt to hot-remove the memory. If the guest does not unaccept the memory
>>   now then G1 to H1 mapping within the RMP will still exist.
>> * Then if the hypervisor later hot-adds the memory to G1, it will be now mapped
>>   to H3 and this new mapping will be accepted.
>>
>> This will essentially mean that we have 2 RMP entries: One for H1 and another
>> for H3 mapped for G1 which are both validated / accepted which can then be
>> swapped at will and compromise integrity.
> 
> I don't know much about SEV, but I assume RMP is similar to PAMT in TDX
> where TDX module maintains metadata for host physical memory.
> 
> What side problems do you for guest here?
> 
> I probably miss something, but it seems to be VMM problem, no? I mean if
> VMM doesn't update RMP on replacing one HPA to another for the GPA, it
> is bug in VMM housekeeping. Guest is not responsible for this.
> 

Right, the problem is that we do not inherently trust the host to make change.
That is why in my understanding, the guest is responsible for validating and
rescinding those pages.

--Pratik

