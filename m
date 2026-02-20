Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1809C5AD4E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BE96B0088; Fri, 20 Feb 2026 14:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12496B008A; Fri, 20 Feb 2026 14:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5226B008C; Fri, 20 Feb 2026 14:10:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA1046B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:10:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EE931BD1A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:10:15 +0000 (UTC)
X-FDA: 84465775590.20.67E6263
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	by imf19.hostedemail.com (Postfix) with ESMTP id 444EB1A0016
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:10:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zgRiBSkP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of Benjamin.Cheatham@amd.com designates 52.101.61.64 as permitted sender) smtp.mailfrom=Benjamin.Cheatham@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771614612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04gaNMWQBuHiKHl2ClYwVAqWs211MC0Ytv3ZGWMIDys=;
	b=21U939PQp6YgOJMkYU/oieAouGuylxtJ8RL6iZ1cNclL29Q5afHmlNyXuFAtjiMc9yS2I5
	/v807FwWZBh6dHZLe+6Q+r8VjnI4TU3pJbKMiVwklY7LEYxibhDGa7ZSBwxMNvbHF1UmA0
	FzlY6TJc1uk/HWy2tY5KGnziPrsIxRc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771614612; a=rsa-sha256;
	cv=pass;
	b=4RHc+54lI6QXGOEnKKPruGggWFmYKqzAxOm+IHTmFAZkfeyAvNZpkRFpdgw9uiYCvokMSE
	z3xAREA7qjw0UwKlWU8ccRpAh5trROpqYfDtXtJomItY0+eQwW6uL8YcqrKdFLnYUmkwx/
	702MZNE7fdF6XQwdfnbwWmRC1Tu9OGQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zgRiBSkP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of Benjamin.Cheatham@amd.com designates 52.101.61.64 as permitted sender) smtp.mailfrom=Benjamin.Cheatham@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+p0C1Pfhp0ma+g0Tkmn0sWGmcQV0BG5xYp8LqMuXJ/IskD5YLH3mhxsfpYzE0MEPtavUuZe2XK8ngbLl9MYeVMNypUAE3g8//KzqknjIBFk/zpwtNFJFAjYsatREl0USMcVadfgMnPHXSTK4SF79mpVeTBlj+jyZy5o20WfC1JT1JEHPYqRg/KoeD+8YpEU7078heYjnsZORRWhrhaZHQoT5/vNj1lRRlNIxmXNVvC7MFGzGZJItXA1Q0fhC8TJ6yZoBy9F85W3gOurPykHCTXnMqKv9UCENULVjlW/J6lxCxxleZ4sfN3X83us7kp7iCvJc59H68YFRHrya9iqdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04gaNMWQBuHiKHl2ClYwVAqWs211MC0Ytv3ZGWMIDys=;
 b=nXKiXLxLokZsBDYSSriXGFTRTOe2rTJl1xgNsPyNKMORE4o6rnC1t8wBaZzS8SJSHQC7KBP++QBLdhzdgHT3N8iBTWYlJSaXg9XBlWm9n63RzYHzaYKP7MNqjCPa6E9uTdQLtosr1+fCgtD5eqd0yeoGGsH7j/O9bGGfW9eLfYG3NouIY9jOpguGgqi5GOgALK9hthn65P0XTjalC66Tyu+TQTUQhTCaeg+8RxL6pdHA4G4T80imZKjy34B1AYckDk/2iZ6ol7JD+Ooh3uJ1qwi628iou/ukhKH4hxPUSdTH8VGmpuAZoa+I0ZodTxF76nc3PJEvl5CR2JPXb/YF/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ilvokhin.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04gaNMWQBuHiKHl2ClYwVAqWs211MC0Ytv3ZGWMIDys=;
 b=zgRiBSkPZ1pmC+742aaFXwtOwY159iDRqu1dEoPeLg4RV3HQD7GdKQ/u97AQSQkQthc1jmLQBnNJ8TFiU6TOBl7QvHAHyAA0XEN01MnzbSEJmv2hVQJ46UWOtYlzpU5qmQvAKBse2Cl6IMo5LZJX3rHG0VmF8Qr7ycjUKlDTJ2Q=
Received: from PH2PEPF00003851.namprd17.prod.outlook.com (2603:10b6:518:1::76)
 by DS5PPFFF21E27DC.namprd12.prod.outlook.com (2603:10b6:f:fc00::66b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Fri, 20 Feb
 2026 19:10:07 +0000
Received: from SJ1PEPF000023D9.namprd21.prod.outlook.com
 (2a01:111:f403:c902::13) by PH2PEPF00003851.outlook.office365.com
 (2603:1036:903:48::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.16 via Frontend Transport; Fri,
 20 Feb 2026 19:10:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000023D9.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Fri, 20 Feb 2026 19:10:07 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 20 Feb
 2026 13:10:06 -0600
Received: from [10.236.185.70] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 20 Feb
 2026 11:10:05 -0800
Message-ID: <74fc1f28-b77e-4b9c-b208-51babae9d18e@amd.com>
Date: Fri, 20 Feb 2026 13:10:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [PATCH 3/4] mm: convert compaction to zone lock wrappers
To: Dmitry Ilvokhin <d@ilvokhin.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<kernel-team@meta.com>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Steven
 Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
	"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Qi Zheng
	<zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, "Axel
 Rasmussen" <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>
References: <cover.1770821420.git.d@ilvokhin.com>
 <3462b7fd26123c69ccdd121a894da14bbfafdd9d.1770821420.git.d@ilvokhin.com>
Content-Language: en-US
In-Reply-To: <3462b7fd26123c69ccdd121a894da14bbfafdd9d.1770821420.git.d@ilvokhin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D9:EE_|DS5PPFFF21E27DC:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e61f732-4893-40c9-f6b4-08de70b3a922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|30052699003|82310400026|36860700013|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qjl0MWVPVUdweS8rQVhpNTgvcTljNFkwb1JnbktHV2Z1U0ZERHNKZG92bjZ5?=
 =?utf-8?B?ekU4K1ZIQVpDak9TUTNJWHlGZXJzY1RtcXdqTVpVZUhGdjFaRkVUUnFEQ0dl?=
 =?utf-8?B?Z29UZzdCWDJmNzZUdVZhcjFPa0VqOEF3VU9lUGRPajkzWHE1R01Hckd3T3dx?=
 =?utf-8?B?UXFsN0hTbWRRclRlZ2U5QzFOcTN6Q01EZk8wdURjcE5KdTZ2bFF6ZmxXcllu?=
 =?utf-8?B?STRFRnVMTkgzZWt0Q3hrZUozaG15cTl3YkErWmFSZDAwalBMbktLd1laYXg3?=
 =?utf-8?B?YitUYndaVisrUDY3MW1OdDNGSzdjbzBvYjl1Rmc4cTBSSzB1dFlpV0UwUUNG?=
 =?utf-8?B?Y3cvL0NiZGxTT2tmVWVicGEwOVZRQk5RMExOVnM3azk4NzU4RnVmVjVRTEw3?=
 =?utf-8?B?UHRsQUhsbUlrT1A1TStkNTlqQTVnV2YzR2N2OUJYUWR3RWFsTnJpRDNYa0VW?=
 =?utf-8?B?dHRNWkgzSmQvb0sxbnJmYmQ2dlE4d1dFbldrMWE0cnZQQlBFTndJQVlBVTh2?=
 =?utf-8?B?ZHRTRUlBek5YTU9LTy9qa0ZoZFlReXdCRjhRV20vUTlmby84YnB5UUZuWkZM?=
 =?utf-8?B?UXBvQjVNWDdQRkpuRUZsRkN6bEE3bFgvdzV1Njh5ejByazQ3Rk5LRnZLK2dS?=
 =?utf-8?B?OFBEMjBUVi9aSG4wdlJjQUkzSzcrZm5IbEFQY1FjWHh4WGNYanp3YWUrR0JS?=
 =?utf-8?B?aWpHZVNYczU4OFJCc2t0R2tSYW40c00rMVZwWkVLMW5XSTczL3JHdVZUZ2ZY?=
 =?utf-8?B?QmtYL21XVDVhQTRFSVpYbUk4TWNza2IzczhGS1p2aVBrdUYxd0JzMXlRMlZW?=
 =?utf-8?B?ckpIM1VVa1N1RTZlemV2aytkazFndjY5d3RvVU1acUIrQUE3V1JxYzRTRkw4?=
 =?utf-8?B?TEU2cE5iZUhZT3ZFS3pySHN0MjRmaDExbWxTdHhjWGpTQ1JoWjM0SEJkQkpl?=
 =?utf-8?B?R1Q5SFU1QnFPcUdVa3paWHYvd2Z3WkVhQVZ5djluMDhFaWxrS3kxcG9kdHVS?=
 =?utf-8?B?TEhBQUZmbzVKQUF1cjlIMWYrV0VRWENSeXZodmFPdzdWREk1TzNENk5CazMx?=
 =?utf-8?B?bWJyZFFiSmxacVUrbXRhM2FySmdqRDNsenVZN1JYT0pxMzRSaWtIWUI0VTFZ?=
 =?utf-8?B?b09XalVzU2RSVHo5NzZ5Z0RQdVZxd2JqQlI0OHdzclBiYlJFVHloLzJIcmVG?=
 =?utf-8?B?ZDFaNGRTaWtiaUdSS2tuTUZ0U0h6czJEYVZDeHJnMmRWbGhZNXUyeElCWmRs?=
 =?utf-8?B?aTBtZVpDR0JiRTBtNlRCVEtNN1dYWnVkb0lZMlNwU054NFQycU5lNHdYd1lE?=
 =?utf-8?B?MjZlTDk3MmM0aERMTk5lZDFrNS9XY3VrWkRxVjlNUHFNZ3Qxb0E4M3EvWmZ2?=
 =?utf-8?B?M0hvOC9VQ0w0MlRvdW5VN0JnMXo1b3NUVGUvZC9XbDQyTjdjYWdqeTdzSlVi?=
 =?utf-8?B?WEZOYUFqR0dsT1RSSXJsUzZ6RzNiM2hGcjYzTk9BZ2Z0ZEdsTGNQVjJhUnBs?=
 =?utf-8?B?YkdoSTRIeGFVSEhUVkV6Q3Avb244OG5ucXBpMWl4TjZUNmorcE92cExqenQr?=
 =?utf-8?B?RVlZSlVEME5hVEphdGJVbml5cFE4ME0xeUJRY041UHdTV2ZIanRKcGExZ291?=
 =?utf-8?B?UVpvMWxVMlhxU1ZYYjVpYjVNcTZBR2VJUm5rZ1dNSm5UMnhvYXNORFljUFc0?=
 =?utf-8?B?NFczc0JDSWhDSmViaTZNUitvQXh6VlV0VWhnUjZvVmZPWEY0dGY5NnlRdFhs?=
 =?utf-8?B?VzBkT2pKdzlDejQwYmxQZzdWbmlMOG5SWENCMzh3TEMzU2NBZmtMakpmY2kv?=
 =?utf-8?B?aDZDb3pOWDN3ZzBVR3lxNHhFZjYvcFRHOVoyMWNlTWNlMEY0YmRvcGZ0dXJH?=
 =?utf-8?B?RVcrdENOcmM1Ylp2c3djY1UrUy80QzArZnJIbDB0SGt1VDRBNkNIQTY4clB5?=
 =?utf-8?B?VnUyVkdrM1lwSnBYSnJnSGRLNTFCeVl1MTdPeXBsUkFzWVFTYlFkczkvOTUr?=
 =?utf-8?B?L3NpSnJMRE1YSjhESmZjSmJ0ZGxMWTgvUi9OY3RIeXRCN3IrUUdZaWZIREZ3?=
 =?utf-8?B?M1Zkc3d4S2lKOVBsWEkwTVd3YW4rTnZmMmZ1cWNUMWJWNEduYTdBS083VERa?=
 =?utf-8?B?K3RhYWhkSGg2aVJZd1FCcGRVeXg1Tzk5UVFUaXlCbmhaSjlzayt6V0d5OER1?=
 =?utf-8?B?WHdJNHlkWXoxcVRnN01kTGZ1OUpCMVlSWFVBckNOTWFLcVZKKzB2eUx6VTZi?=
 =?utf-8?B?R0gvRHNsYUJUTmk2MGp2NHRpWlNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(30052699003)(82310400026)(36860700013)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CdETpvuae9MsLoiISeMTrLS+2N+IXfSHkw+dS//XJ4FPtP3tXTKVltKMHU4c1k218KHGyLMf0ydQO0J8/0pnq8wBBUwhrSnnHPJux0/jpnyTnP5SiRmGkSFYSdGpfmyaym4mYmwjyOFCNlLHdnGyZOBYoqRViekwRzN+WE9Qrb+4a2uEokRAnM902gq3IGWbUTCQWRoSxFdknSGkzM3T7v7dV3WEqiE2098lM2FhQ7YNE+I6bHSEKtQTJYLfDSKTR8bDd+OT7JYfrUEcf9Q0+BYdUErZHre5xK/Gb8D5CtWqdPWTdd1xm5hOKudPoAIft4WWDs9sY0LXJ36NG97Qz4QhJ6w0yf/aJNiZwoG9AWwmphHD1a0MgQ2GUPG1GE/xcuVKkXniFeubYsYj2l9X1+F6hDHRxgrrJa3O+QAkkEJbgP3NQw028kyiTYv2SOLt
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 19:10:07.1180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e61f732-4893-40c9-f6b4-08de70b3a922
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFFF21E27DC
X-Rspamd-Server: rspam09
X-Stat-Signature: 11r1oxj8asihzxy769dtit55htuiec34
X-Rspamd-Queue-Id: 444EB1A0016
X-Rspam-User: 
X-HE-Tag: 1771614612-61979
X-HE-Meta: U2FsdGVkX1+8q7bG3YeumaiGFA+tudOxMqk/bccFAuK7igKodTiZaO20FCq2O7IBJL6ABKs5cV4BftQ79bnkd6Gq0o904+HUao/lRA7XOa4LOahCEiN6RqRNd1c6pWz7xQI0Sp3jgSHkQKiLM5TB5XVrXRm194P4sekk8IEaEog/r/QONmB3HupoPdXgRqFTRU+ZxWAV1TcbfWHfpQ/xgWZwl9C3KGGsQ5DlkUOFkTcXCAFWfHObzwlq+yorIcDTkk+Exd5a98sjTwS7VFtd2ZlRNhSND8ER3GW75QTGnxgNs3spApe+0NZzd1X7noMjFjopXCCKNZulUNMO2YR0MmvfP6wlqC9BpIL40OuOBMDaPXGetWU/fjxsDRiijw5Fk4T1ZN1YDcAyZVz8sc4cXSwsP7mqc2KTySEacFdWq75Xp2u78SZJQW5kOvy5CoeUE8XI0d/qbwXf2aJprCc1RSkDkOiwY+ZSqyS0dCSlJjv/ec5IF7n3qKwytHn9eHcVPPDw0LyDN81kRHiORQlpSf73iVo4g3xzcNgvADQtwa25swp4pudFpsdcuY9XBiHI7LPuRfEbR5n3/d8WG3b362B69qQoztiCN8g8lKBmSFgOSW6IxBXycUduGJQaZ+QEN9CIXGj1hT4RpMCmv8J6KCsAVgh7lFwlRvBHV0DNqB40ec7S9PUlakrC1JGF8r0JPPRpkI15weY0bov6Bcw3xEzKuqsABRo+uZwbqiMYgobc26rWyejFcUUrwSMfXTZtQDugrTtzdPxIOyHO94/iD0wzYF12RHd3PMJs0Q3RJyajbHoc4/S06U9qtffNs8jiMMyfihNyTwdzvkWVygzBKDywFBnwMeXpKlKjfgGzC+jVv1WMDR6lvdXN0THLeH1GMGwiRAMjoqGZAGfnvCxHxX7orXu2v7aTLJSCjpWgdw0Xxto+Q0y0Bk4T1+SRY6miS4flGjRvGIdwkdtgEYb
 tVLewX7A
 kBixK4X48gpwzck8co8vZN6j61CwBfK8h5inSiTnYP0G3DqpwWnTsXunyC2d+Uamv4aUcdoCvvyrKhFUcG+ckQA1neVbJz2j+62QYQCnPdhBSv3mNJKIJZwF4kElQmyrCPEYXcpOMgiFgaup3odyb7sYXwVfzBQjIO5uTS4MLqCV+N9Y7FG1jt2qxuWpTkfLzaBFA3+j6xf0JCGhjPW0Bj44GeWbtoZOmPIxgYrUCYcQc6P1DAOTVxBWIUK6QLv+8nF36dSmwYGB/83JEOsXTzZkVolcqF6/rQ3rq2gJBKl9CiLSGe+sMFmbs6zY1IyjWZcPWhOUIG2RhbRQCszkXnt5RuaKfKlhivlxJ2isTY8qPORMC3RqKPAU3W/v1kayuDBGntMDAjiR8Cv33N4gHZQS6C3XuY5TjTjl7qQR+f/8bVTCnxyhQ5ugFChV2O+tKv8gnq0+yxCXv6/V0eR6eemvI4MM2HGqyR1Xh0nEiWaJC44estqkamDm/jJ0aQim1sG30zUNiGUB6JgWn/ICxQuNsdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/2026 9:22 AM, Dmitry Ilvokhin wrote:
> Compaction uses compact_lock_irqsave(), which currently operates
> on a raw spinlock_t pointer so that it can be used for both
> zone->lock and lru_lock. Since zone lock operations are now wrapped,
> compact_lock_irqsave() can no longer operate directly on a spinlock_t
> when the lock belongs to a zone.
> 
> Introduce struct compact_lock to abstract the underlying lock type. The
> structure carries a lock type enum and a union holding either a zone
> pointer or a raw spinlock_t pointer, and dispatches to the appropriate
> lock/unlock helper.
> 
> No functional change intended.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  mm/compaction.c | 108 +++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 89 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 1e8f8eca318c..1b000d2b95b2 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -24,6 +24,7 @@
>  #include <linux/page_owner.h>
>  #include <linux/psi.h>
>  #include <linux/cpuset.h>
> +#include <linux/zone_lock.h>
>  #include "internal.h"
>  
>  #ifdef CONFIG_COMPACTION
> @@ -493,6 +494,65 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
>  }
>  #endif /* CONFIG_COMPACTION */
>  
> +enum compact_lock_type {
> +	COMPACT_LOCK_ZONE,
> +	COMPACT_LOCK_RAW_SPINLOCK,
> +};
> +
> +struct compact_lock {
> +	enum compact_lock_type type;
> +	union {
> +		struct zone *zone;
> +		spinlock_t *lock; /* Reference to lru lock */
> +	};
> +};
> +
> +static bool compact_do_zone_trylock_irqsave(struct zone *zone,
> +					    unsigned long *flags)
> +{
> +	return zone_trylock_irqsave(zone, *flags);
> +}
> +
> +static bool compact_do_raw_trylock_irqsave(spinlock_t *lock,
> +					   unsigned long *flags)
> +{
> +	return spin_trylock_irqsave(lock, *flags);
> +}
> +
> +static bool compact_do_trylock_irqsave(struct compact_lock lock,
> +				       unsigned long *flags)
> +{
> +	if (lock.type == COMPACT_LOCK_ZONE)
> +		return compact_do_zone_trylock_irqsave(lock.zone, flags);
> +
> +	return compact_do_raw_trylock_irqsave(lock.lock, flags);
> +}

Nit: You could remove the helpers above and just do the calls directly in this function, though
it would remove the parity with the compact helpers. compact_do_lock_irqsave() helpers can stay
since they have the __acquires() annotations.
> +
> +static void compact_do_zone_lock_irqsave(struct zone *zone,
> +					 unsigned long *flags)
> +__acquires(zone->lock)
> +{
> +	zone_lock_irqsave(zone, *flags);
> +}
> +
> +static void compact_do_raw_lock_irqsave(spinlock_t *lock,
> +					unsigned long *flags)
> +__acquires(lock)
> +{
> +	spin_lock_irqsave(lock, *flags);
> +}
> +
> +static void compact_do_lock_irqsave(struct compact_lock lock,
> +				    unsigned long *flags)
> +{
> +	if (lock.type == COMPACT_LOCK_ZONE) {
> +		compact_do_zone_lock_irqsave(lock.zone, flags);
> +		return;
> +	}
> +
> +	return compact_do_raw_lock_irqsave(lock.lock, flags);

You don't need the return statement here (and you shouldn't be returning a value at all).

It may be cleaner to just do an if-else statement here instead.

> +}
> +
>  /*
>   * Compaction requires the taking of some coarse locks that are potentially
>   * very heavily contended. For async compaction, trylock and record if the
> @@ -502,19 +562,19 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
>   *
>   * Always returns true which makes it easier to track lock state in callers.
>   */
> -static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
> -						struct compact_control *cc)
> -	__acquires(lock)
> +static bool compact_lock_irqsave(struct compact_lock lock,
> +				 unsigned long *flags,
> +				 struct compact_control *cc)
>  {
>  	/* Track if the lock is contended in async mode */
>  	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
> -		if (spin_trylock_irqsave(lock, *flags))
> +		if (compact_do_trylock_irqsave(lock, flags))
>  			return true;
>  
>  		cc->contended = true;
>  	}
>  
> -	spin_lock_irqsave(lock, *flags);
> +	compact_do_lock_irqsave(lock, flags);
>  	return true;
>  }
>  
> @@ -530,11 +590,13 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
>   * Returns true if compaction should abort due to fatal signal pending.
>   * Returns false when compaction can continue.
>   */
> -static bool compact_unlock_should_abort(spinlock_t *lock,
> -		unsigned long flags, bool *locked, struct compact_control *cc)
> +static bool compact_unlock_should_abort(struct zone *zone,
> +					unsigned long flags,
> +					bool *locked,
> +					struct compact_control *cc)
>  {
>  	if (*locked) {
> -		spin_unlock_irqrestore(lock, flags);
> +		zone_unlock_irqrestore(zone, flags);

I would move this (and other wrapper changes below that don't use compact_*) to the last patch. I understand you
didn't change it due to location but I would argue it isn't really relevant to what's being added in this patch
and fits better in the last.

>  		*locked = false;
>  	}
>  
> @@ -582,9 +644,8 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		 * contention, to give chance to IRQs. Abort if fatal signal
>  		 * pending.
>  		 */
> -		if (!(blockpfn % COMPACT_CLUSTER_MAX)
> -		    && compact_unlock_should_abort(&cc->zone->lock, flags,
> -								&locked, cc))
> +		if (!(blockpfn % COMPACT_CLUSTER_MAX) &&
> +		    compact_unlock_should_abort(cc->zone, flags, &locked, cc))
>  			break;
>  
>  		nr_scanned++;
> @@ -613,8 +674,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  
>  		/* If we already hold the lock, we can skip some rechecking. */
>  		if (!locked) {
> -			locked = compact_lock_irqsave(&cc->zone->lock,
> -								&flags, cc);
> +			struct compact_lock zol = {
> +				.type = COMPACT_LOCK_ZONE,
> +				.zone = cc->zone,
> +			};
> +
> +			locked = compact_lock_irqsave(zol, &flags, cc);
>  
>  			/* Recheck this is a buddy page under lock */
>  			if (!PageBuddy(page))
> @@ -649,7 +714,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  	}
>  
>  	if (locked)
> -		spin_unlock_irqrestore(&cc->zone->lock, flags);
> +		zone_unlock_irqrestore(cc->zone, flags);
>  
>  	/*
>  	 * Be careful to not go outside of the pageblock.
> @@ -1157,10 +1222,15 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  
>  		/* If we already hold the lock, we can skip some rechecking */
>  		if (lruvec != locked) {
> +			struct compact_lock zol = {
> +				.type = COMPACT_LOCK_RAW_SPINLOCK,
> +				.lock = &lruvec->lru_lock,
> +			};
> +
>  			if (locked)
>  				unlock_page_lruvec_irqrestore(locked, flags);
>  
> -			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
> +			compact_lock_irqsave(zol, &flags, cc);
>  			locked = lruvec;
>  
>  			lruvec_memcg_debug(lruvec, folio);
> @@ -1555,7 +1625,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
>  		if (!area->nr_free)
>  			continue;
>  
> -		spin_lock_irqsave(&cc->zone->lock, flags);
> +		zone_lock_irqsave(cc->zone, flags);
>  		freelist = &area->free_list[MIGRATE_MOVABLE];
>  		list_for_each_entry_reverse(freepage, freelist, buddy_list) {
>  			unsigned long pfn;
> @@ -1614,7 +1684,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
>  			}
>  		}
>  
> -		spin_unlock_irqrestore(&cc->zone->lock, flags);
> +		zone_unlock_irqrestore(cc->zone, flags);
>  
>  		/* Skip fast search if enough freepages isolated */
>  		if (cc->nr_freepages >= cc->nr_migratepages)
> @@ -1988,7 +2058,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
>  		if (!area->nr_free)
>  			continue;
>  
> -		spin_lock_irqsave(&cc->zone->lock, flags);
> +		zone_lock_irqsave(cc->zone, flags);
>  		freelist = &area->free_list[MIGRATE_MOVABLE];
>  		list_for_each_entry(freepage, freelist, buddy_list) {
>  			unsigned long free_pfn;
> @@ -2021,7 +2091,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
>  				break;
>  			}
>  		}
> -		spin_unlock_irqrestore(&cc->zone->lock, flags);
> +		zone_unlock_irqrestore(cc->zone, flags);
>  	}
>  
>  	cc->total_migrate_scanned += nr_scanned;


