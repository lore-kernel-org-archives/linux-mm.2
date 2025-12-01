Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C016CD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21BBF6B002A; Mon,  1 Dec 2025 16:03:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3C46B002B; Mon,  1 Dec 2025 16:03:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3516B00A9; Mon,  1 Dec 2025 16:03:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFA0D6B002A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:03:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C39FB160373
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:03:37 +0000 (UTC)
X-FDA: 84172128474.13.7509139
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013032.outbound.protection.outlook.com [40.93.201.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id AB80840011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:03:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=B+itDq5D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.201.32 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764623014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qHZ52JgkXukyMZHpaZBkGdFsNuZsgHpy82LUPkqDxx0=;
	b=wk0Jx7Gy+HEj0c+Fzsf8QR+e4SmcjKiY56ycD+yaziLN/5PzczNCMOH2Lodxfo3v7lybu/
	bYeKpn8Ium7InP0j/MOLt4we4unzvjngZgJ8t7FJJMStpLu9iycac/zzb3Po7XyBAzVgwQ
	bSaWMQqe5a2gmPf77XRTY4vxZT2M8x0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=B+itDq5D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.201.32 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764623014; a=rsa-sha256;
	cv=pass;
	b=fljcvUEkFJYcYGHYX6Smm1J6Tt+LjO5NG56JiREo/TSjt4Ir8l5K+tyY37UD4bVz1VXZVi
	XfW/1KOrTwIpeb6HQi6aquV7+EqcJPDyL7Gu42roLA+DOtiIYOspmEJy8P5JzT4YqcdgrM
	wtNNrg5zbc7kJrqG6hhwy1Cvwd+TAQs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4Va79mUu0vythjY7XwCdwQi25/wbL7ZpYFtQKZvvOaRdBcuIkMI8peprLVHcAG1r/ZGnkUccrB5vhssxTxc3FxplXJbwckP31Q5fGRcWaePT5VYj3iIXWB5bjuhTKy+VrkfsbOjZz7z0npc/2e3Vqzs+pBgyhxK1ceoc2yeGFYkZXHY6kGHRlwoxSggtyot9u6xoY7IHGOxd1L3smSQ7gFoJobplq0a8jcx+ZuI3fXvo+G++ojoGXONuBFntPkrJ9aDPHynv2bc7YZSkW+llfUHyFyxWH7MCiFOeNbn3Uyt4yqLcf3EFyB6bALFmly8Cvb5ycWuE6LNR2VLlPPBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHZ52JgkXukyMZHpaZBkGdFsNuZsgHpy82LUPkqDxx0=;
 b=VUAsJhcN1qUXkgthlsphceqOs8HCrvYhPX5h5RRG+Ow7KuovzTvovRhlk6lqGTmVJZTqHjYlDclvaoF3UJVgkkg2FQzFIrn5jluOSj9x6enythni3PjwwBA0pWREtQXso+/OCoF5RilnELa0seKMtuI2VeD2wjbOZw5Qw9tjDFTdGMZ13WLI5Zt6Mq83XoUmwAEKomi2KzRolUEpWlZnxky/KmRMCTzE5HY/FRUjev9z/8lepWPzov6hLP2q0NLqvHej29XQD6qCON7LaDiOql7zP5S+POqtF/mL+r9w/+Lt4UbVXsfiCs5aT0KsC36Etgi6/iy11HraIfXlI8KqgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHZ52JgkXukyMZHpaZBkGdFsNuZsgHpy82LUPkqDxx0=;
 b=B+itDq5DVVoH/FZcjavhuvN8qtWMfO2ezKVt2uY2LoC0TzqMc86dNDVqdf4cpEv7Y41haxjF/PpZPGlkHDQpl41JMFrNlhs9qphnCGkpRtpef/mYRlO/w1UJEAXequ7iRiOaYpMjlZaI1L61iZHT3jQvTsAdzFi0Imx1eTb5Wx4=
Received: from BN9PR03CA0339.namprd03.prod.outlook.com (2603:10b6:408:f6::14)
 by CYXPR12MB9278.namprd12.prod.outlook.com (2603:10b6:930:e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 21:03:29 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:408:f6:cafe::47) by BN9PR03CA0339.outlook.office365.com
 (2603:10b6:408:f6::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 21:03:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 21:03:29 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 15:03:29 -0600
Date: Mon, 1 Dec 2025 15:03:08 -0600
From: Michael Roth <michael.roth@amd.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20251201210308.2hlrt5m4gzo62j35@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
 <CAGtprH9_yo4P+oTaGzhHkC3gSdFPTYkvwHkwN66gQhQXX9fhRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9_yo4P+oTaGzhHkC3gSdFPTYkvwHkwN66gQhQXX9fhRQ@mail.gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|CYXPR12MB9278:EE_
X-MS-Office365-Filtering-Correlation-Id: 370dcafd-f408-4f49-211b-08de311d13fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1o4TmNVRzhNeVVkQm94TkdFSmRlR0N4TUhZSUp0QnF3YVNHWTI1dXNJcmJX?=
 =?utf-8?B?NjlGMnFZakZueG1ZbzQvMmxEb2ZrbnhTWWllSmRkaUhGdlBqVWl3dWlROS83?=
 =?utf-8?B?R3kvNXVFL1FpU1J6aHNXbm8xTDNoVG56bFhmamZ1Qys0YU5LRy9HOFhpME9k?=
 =?utf-8?B?WjFkbCtLUUM1TzYxdlZ1N0tFUitLNW5hRzdQNnZBYUtQejdwNWovb29kd2Q0?=
 =?utf-8?B?eC9ORHR6SEZvSkF0aGxnRkV1S2IzeWFnSnRDWXF5R1BEREJYeENYdldSMTZj?=
 =?utf-8?B?U0dCUmJPRzNZR3VudkErcEh3MzJZODdHMXJkVWl1aEYvN2haNUtjWE14MUtV?=
 =?utf-8?B?RGdvemU1QnVjSHByUWR1REFjM2daZDRoNW5sc1U0VnE4VjJxdUM3U2VNUU16?=
 =?utf-8?B?MGtzUzVsMXY4MEJJZ0U5K2d0N2paakZtVTFBbkd0dGEyUFdEc1pYRFhPaXFF?=
 =?utf-8?B?U0M5OHhMSHp5czNyRTFlaG4zbG1teE1aL0xzSEZoNm9FaWl3SGtsNEQ4ZnRz?=
 =?utf-8?B?MnRtczBlKzBhaHRVNU1CSnUxVG9JWVViSVoxSWhhODg3OVlhbjhMZjc1YnRu?=
 =?utf-8?B?L2NvYU5RMFQyV0pUdzYvWWV5Y1FvazFFU0hRTS85Z25adnIxa3dzMGdvL2Ew?=
 =?utf-8?B?WWRDR2ZOUWxNNTZqSVg1UnRSZjU4aTA0R1l2YStvL05raGUxQ1NlbUtqQlFV?=
 =?utf-8?B?cVMvd3RkU01aaVR1YkFvaUlLZVNDYUN1Yk80djZrTDZJWWdTT016Ny9Vc0NJ?=
 =?utf-8?B?VVM2K0pSQSt5czZnMi9sWWdNaDFROGhEcnByUytxckZ2SDI0QTV1a2NXSVlJ?=
 =?utf-8?B?cFJDR0NzRzM5ZXVXMUxoT2t0cEQvd202MUdiV1BOWS90VklxU1lYeFBRaWJ0?=
 =?utf-8?B?YkEwT09oREJrdnNYdDBBdkFhYVUrR1dscjhKUTZZU3NaU0l6aFBOZElDQU9m?=
 =?utf-8?B?bzJ3Tk5VOTJ1eXdScHhQUnprazAvbFhVL2ZPTjZNL0ppcXFZMHVldkM5QjQv?=
 =?utf-8?B?R096TTVGYmZUT2ZQc1FyOVZUQTd5b0x0enF0MGR2Q2FoM2w0MHdTREttSGgx?=
 =?utf-8?B?cDNERUV2MnE3b2dmeVZTWUQycXZoK2d4YVMxTjdXRXI2aXU3ZW16cUR3RWlL?=
 =?utf-8?B?ZlhnZDFZZHA1RS9oOE5JWkc5Y3ZCZDJMOEZabTlldjVKbzB4WEhzSk14c3JO?=
 =?utf-8?B?bHMxV0wxVHhYWVA5S3ZxVnlHRTdoTmFOVDhoMzBmS1NHR3dEWjlxUWVDM2FE?=
 =?utf-8?B?T3dHWkJ0VXh6MkV6Vy81ekpodWlMODNCMjNzTmxvNEloYUE4bTA1NHEvOG1M?=
 =?utf-8?B?MzdsTTI5TkhnSTkyRXA5TFB5azJib3dCcHRPT2V4OTRnU2dqNUtDL0pwVUZB?=
 =?utf-8?B?OElkRC9qUGdJd1ZKYXJpZEczeFR6MUFoM0RtWlhRTlA0Qk11SnVCd1BxYVpa?=
 =?utf-8?B?eGdRWFF4V05QK05TK3BLRS9sTGJ6TG45VVR0eE5UaGJ4TUZxUTV0eTFXb3JS?=
 =?utf-8?B?aStGeEIxN0xidlAyQ2RFVDJXRkd1ZWN1dm1LTDl3RVU4N2d5S1JEYlFtMlQ5?=
 =?utf-8?B?L1I3Y0dqOUVqb3dwVVRvY2xIVUc4VzlTWFVqRFhRR1IzcWxnUkE5Umlldmkz?=
 =?utf-8?B?SlA1WTNuaGozcDQrUWMzVGp6cklweFNqZGIvOUYrZmhqNEVmU3crMnkzMExR?=
 =?utf-8?B?MTNSNHc4RXVaUHdpRDVGV09wNVlrczlpTVNPQU85OEthT3FHTjJHaUNudGNE?=
 =?utf-8?B?Nmc5aWRRTHUxZjlraGFnRlg0NDQwcStRa1U2eTQ2MXNqU3BLOWtSUWsxTFpi?=
 =?utf-8?B?Z3JDVHJwNWsvZlhFR25jeFFDT2lEQmR2L3ZzdXNQdmtkb3oraFNrekJ2V3ho?=
 =?utf-8?B?WEJtNVc5WTR2TytYd3NEQmV1ZFJsSmI1RzM1VkpicGtHSWplSGN3SWhJUTVS?=
 =?utf-8?B?emRXcHJ4MUJVYnFLdTFreEVLMWFpc1pvWUs2andEejNUNDh5NG80eGlMUVhI?=
 =?utf-8?B?bjBYejNKVGloZWgrUDlqaXJpL0V3WUFhVkdBdVpOUHJkaTFtdlVOUGhrenVI?=
 =?utf-8?B?Si9Kd3QwVW9Ed2s0TlZtWnRDSkNzdnJtdlc1U3FJV3NTVDUvaHhLQ2ZrdTlN?=
 =?utf-8?Q?3SII=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 21:03:29.1978
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 370dcafd-f408-4f49-211b-08de311d13fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9278
X-Rspamd-Queue-Id: AB80840011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 35nzc3wb5csftugd3b5geifg16bm9gcj
X-HE-Tag: 1764623014-737364
X-HE-Meta: U2FsdGVkX1+aKNELKM/1O0477x1QF1ZpgFxi/R18zAX69QSIYQQYY1cgO9LU8TO5buiieT8b3iV6nMIpjaOq5eoOK0WIPjQKUxFvTpi/+dPFofQcwRqW9tKcXBB0h88pk08GgCvOVAtq5hdBDq0181xcfGPDZFMn4Ta2dW1DM/+ELfSYs5w3dptGpvpfU2Hy8bwgYAwOfpmxLN4d7KoCsAbY3LSl1VYp9EAfRWQJWVWFuca3opyMYvx0v+Ks+zB0wCQ3WdEkgGtvdlsNML6AtZmJEpIDjtek20q89TvtxZ+T4x5rIxmE4mDH4Zs7iILNPGjUcpFXqfFGneNsfjZYvmN7ajq6+b4EBtv10YL1P3JJiO4cR9/uGZjZcW2dGg28rMuqBzaENG8N3EZkT7mbJ+Mz22iDspjuVGkjL1mypBroK5hdKb1Wze8qmrXpIBZGKowYk1vIrenTbDK8LT7cFw3PnY/Ekz0l2u0i8A5To4Trb9Fm6+HywOMs1ydZLYr4h9WGuQY8a6T+Sj02B7rQnc3iM6l5XfB2/5Dg8L4BPWHxdtlJuscACWoG58LS0OP99auxiwm0bm0z0yg1HtD/7lzlBqj0k+1dbncptVzzxUNA049J9fY6x65Z7ibxZC8QI8SArhZh6cT76bxhasDikcFLf8MAvk3rGoT1pe5LaZLpgj3cYCk5R09voCxt7Gxddi6lt/vSXiteuvQycC1BnFVYz26c6aNbnnMFfY32EKhvn8EGoAxGMB7Shl7roCEHOGX+1OUH7P+mxGFqNT5F6UuMhY4CQydr1SmC1EpzEfTsQA43Dx0ReJd7aVskE7fiOMMR7tEO0qIxhzwpRmGh/nEIFs3nXP5zNtcfQ2q034J//9xt8ZewZVs8ElpysRnBxWMkzlNddWHXZDhO9rME0eQ2gaoDhTYwP8F+H8lewA9eTx745TIlOLQaK9l88hzgq3i3dGmZItG1W8Wp+kF
 HroyKr5V
 4F+S1URUaif3cOdyjjqcYm+VXffQHuAKTnr1bvzCOpNZGh9Nrh2qTr4KZbjeez544RymYc7elL3DdbGd9NgbzXJjsfUNO8OOdtXYNDvaLXXNnS3fNynYLwbspnOY22io0qfgKBvQCEgCsBhRH+h0ytCcx+fOFVfv/YNWMjb14KXyHpyk+CZqoTR1xW0FHlFwXf+HKeQvmeCbxYjABwlAXksty4fbGepJdWzLkX5Ngj01BGfQ4YIPRhBaLB981rF3uDD8bmiYsugY5sVnTQWKx5jcyKKkGoJ6XQEnsu26vhKpqbtJvneYHLiXaf6WRu6myMioBdjfz3QhLG/SPfbFWY5Wq1kzDbkcKClIjx/UVynqmk7GM3G+jnkYW5E+c1DPg2jWReN/gfWjlDTj425JO7WN4aUtl0ZILf5i74ondSPWMVBCZVSyD2htCPn3wBnV8YuJ7LC4roJJTOrSkZElR3Fw6Av38CitlY8tuxNdlDUSS/a+GQLCIGQaeUgUoI60D0cYkbhbYDiE/Q22gwwQTFhUDC0Msl6A+cyFixugisM4PRtWEtKowONURkDW7T9qIZUJUaqv0lIN9lM+OtPkCnusxhLh3GfvQlOk6t5q52qsA0sR9SvwXqmm8np97GuvfD4zoM5K3UEuoWVr+acz/fcbohg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 05:47:37PM -0800, Vishal Annapurve wrote:
> On Mon, Nov 24, 2025 at 1:34 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > > > > +                 if (src_offset) {
> > > > > +                         src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > > +
> > > > > +                         memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > > > +                         kunmap_local(src_vaddr);
> > > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > > >
> > > > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> > >
> > > src_offset ends up being the offset into the pair of src pages that we
> > > are using to fully populate a single dest page with each iteration. So
> > > if we start at src_offset, read a page worth of data, then we are now at
> > > src_offset in the next src page and the loop continues that way even if
> > > npages > 1.
> > >
> > > If src_offset is 0 we never have to bother with straddling 2 src pages so
> > > the 2nd memcpy is skipped on every iteration.
> > >
> > > That's the intent at least. Is there a flaw in the code/reasoning that I
> > > missed?
> > Oh, I got you. SNP expects a single src_offset applies for each src page.
> >
> > So if npages = 2, there're 4 memcpy() calls.
> >
> > src:  |---------|---------|---------|  (VA contiguous)
> >           ^         ^         ^
> >           |         |         |
> > dst:      |---------|---------|   (PA contiguous)
> >
> >
> > I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
> > as 0 for the 2nd src page.
> >
> > Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> > snp_launch_update() to simplify the design?
> >
> 
> IIUC, this ship has sailed, as asserting this would break existing
> userspace which can pass unaligned userspace buffers.

Actually, on the PUCK call before I sent this patchset Sean/Paolo seemed
to be okay with the prospect of enforcing that params.uaddr is
PAGE_ALIGNED(), since all *known* userspace implementations do use a
page-aligned params.uaddr and this would be highly unlikely to have any
serious fallout.

However, it was suggested that I post the RFC with non-page-aligned
handling intact so we can have some further discussion about it. That
would be one of the 3 approaches listed under (A) in the cover letter.
(Sean proposed another option that he might still advocate for, also
listed in the cover letter under (A), but wanted to see what this looked
like first).

Personally, I'm fine with forcing params.uaddr to. But there is still some
slight risk that some VMM out there flying under the radar will surface
this userspace breakage and that won't be fun to deal with.

IMO, if an implementation wants to enforce page alignment, they
can simply assert(src_offset == 0) in the post-populate callback and
just treat src_pages[0] as if it was the only src input, like what
was done in the tdx_post_populate() callback here. The overall changes
seemed trivial enough that I don't see it being a headache for platforms
that enforce that src pointer is PAGE-ALIGNED. And for platforms like
SNP that don't, it does not seem like a huge headache to straddle 2 src
pages for each PFN we're populating.

Maybe some better comments/documentation around kvm_gmem_populate()
would more effectively alleviate potential confusion from new users
of the proposed interface.

-Mike

