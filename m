Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AADEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361206B00A6; Wed,  1 Jul 2026 09:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312126B00A8; Wed,  1 Jul 2026 09:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2010C6B00A9; Wed,  1 Jul 2026 09:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFEC56B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:32:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A6871C3001
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:32:18 +0000 (UTC)
X-FDA: 84940296756.09.45B91FE
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 95FD74000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:32:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qRBtFnOd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782912735;
	b=vUeRyEV2yvPViYxg9lO8ZNyLx5KeRW/+GZmEk/YK8RDsS3rdIeNgl2dpLgDov+QHIS3SZM
	AMj3EUFgd+/xHScUBr9stttHQT6y99n1Kn9+Sxbq+eLEc+ssU//d7B4XAoRL1okNHnD4Uk
	tpYso/s2y2zOc3uTY8t9afsUC2LSnD4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782912735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEV5uvlYmSd3SdRXhBqwGY0okwykGJkIaAN6PzAia0M=;
	b=gaOWa5OSI93FVxtvE06nJ1rY0Y2OQgL3woMmtX0BNZOJCmKGzfagVk9nysP93gVMcyBZqh
	vWX0vdnkwnMUM8+rd++nvf+4ZztX9lsj+tBvwWMfDkLzkzr/htXvjh4gEip9kFXJUOxnco
	Xn2EooklxRQvaOTKufVP+GzvAhu2plU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qRBtFnOd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UwKPwuwlXtP+BlA4dx3j40qzdgksZDLdcHKRvJmUVvXUZgNkaiWMOqw4qP8k/DkmTDqH2iLucMDYBNLMFMBcWEwppayZr+eGut6l9lgGN0W6uQUrWkP+iZLAJ2amnKQWQHEL/klfG8xNgQ6j/PhHx3v0A48O9OBK4hbKjIhVQwSbhcdtZqhIh5Lc47rlw03v6PM3ZSR7kEWRGgjzS2CSz3A43cSt92mIfZ8G33OEcQNmzOdvGwDIgTcH+Ehg6Gr544b+tdfu6y3x5mWA48N43oqsym0BL1RhG65EzVR45pqwxV1uQcEZ96tgqbQTSFpvfYJEWodd0w/sYBhq4WETZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEV5uvlYmSd3SdRXhBqwGY0okwykGJkIaAN6PzAia0M=;
 b=sL6oUuCeWMWviEnx+q7XDGTJgInaOiToPjkH2kiQ8TLuD7QmxKFAJb4PYgWa+XxrHSi8srN1yyBI7SixQ7pj8bLMqeP2YjwUKTNu5BfLXI/ZacoPQK0E8tkSOwLwNYMDC5+I+13KG2FRo65+xZGKQOL3bl4+t7qKws0ZYCqn2f6MA1r2VWtQehQ5fWBUkxJE/jKE6iUtGeH+jSlM6ZkUW4z/zvog3Kx5D4GgzexnB/JSOECp646din5dJusqKFkapN8fn2ML090M7kIuafxr1F0d7DIaZoDtqMU5hiYJJaRlzZVGSEZumDPaHNc9dVSyTEUEH2R3JSg0lRw/Pjn6IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEV5uvlYmSd3SdRXhBqwGY0okwykGJkIaAN6PzAia0M=;
 b=qRBtFnOdz+QuMUuXn+zBsvDj9WxL1fatxyNWPhnEcY6bxn5Y8KeL1jEPs6JdZH88P1Joxi+uPS3e3noYAQx8NviBCA8jhvBpNS310TZr8fWMC7L/Fp6JQfm4y5Q0v+My0F3OARVe8yr1bxm2TjIeIpx0KSNRdXpeKlDCJA9f+e0LJhCay30NenCDxPQk9tYCEkQkbvVoLgRq4ZRYvRgK7OBXPA9ZGTwD4ANjygDXrh9K6wIPtWCeb8rLirweNU/OU3XG4YcL7Kuy2OL2Jq4CKFqbI9xitgt3M7PBz8/5Mg+x+C/Vd0ArR1NR29Je2u6DkPZmF8dw32apfYbHu9WWzw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS7PR12MB5840.namprd12.prod.outlook.com (2603:10b6:8:7b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 13:32:07 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 13:32:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Jul 2026 09:32:03 -0400
Message-Id: <DJN9TA4XQ8YX.3NB0LR0HU49F5@nvidia.com>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <surenb@google.com>,
 <mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
 <ljs@kernel.org>, <baolin.wang@linux.alibaba.com>, <liam@infradead.org>,
 <npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
 <baohua@kernel.org>, <rppt@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 2/4] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
X-Mailer: aerc 0.21.0
References: <98cf3340-1a2f-4d50-8410-6e9d6d3a5308@kernel.org>
 <20260701110151.77453-1-lance.yang@linux.dev>
 <f7ae2a47-730e-4665-85d9-07a7a40e1b39@kernel.org>
In-Reply-To: <f7ae2a47-730e-4665-85d9-07a7a40e1b39@kernel.org>
X-ClientProxiedBy: CH2PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:610:4e::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS7PR12MB5840:EE_
X-MS-Office365-Filtering-Correlation-Id: f4fdab69-3990-4c70-9950-08ded775248e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sZKobWm3vSqKM5gS4djZnUJxtqSzW1y7p9UxTo7ERWEkp2FYnoL+L/KAjSEO5dnT6/W0x8WH9AtxXfSmf2YLqHRL1gH2P0DPoegSm2+hYpQmURT4NIAQG00UdGDQWTqB2WR+GlUPFkTOiElyO9AH0yMk5jLdw99WEFjpH2OR3e2qqI2ZZykLNglnbYF41S7FY9IF6XSITt1Ui9KGlYwAuToO8j1tLXLksoSMwTWAm263n6q9Zz1w9CGY/91S2nmGwSQYwPQ/jQ65wKGROzRqCz8La4Ov9X+OA1rAydbIqbGafHHHu6eBeN3pb2k8402UDtJXDpwyulBtdUzKWDCMzcIsOCslceOqG04n6sJcoy6W/XxjA7ANOZx4UxVAG6HksX5AuSNBbPYrui55ig7JBI0x21qsuK89wASkO6H5fYlz+qiSwovTweQdaA4ZkmniFjLZHswslGjbAQu11ozMIoU4D+5fBs5W5BpWaPx/eFfIQNOixGoWuCW9Km/YVc9XfKh7dvLyUZ/SeiXPNaXAm57RwaVtzhDFxbK2/2L23ZNrCQcZCRI3OMFGTp9P3lCjYHnbiEb/9UsJieu/8+O27YlsqGBGjWGB9+pPxW3sNKIb8b4Ijlz81dA3V93eY/7ejBqxeYEuMeJsWox2kPIqxWX00Dcev72WV1VWsXGpPIs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGN6L3hxZFBjZkVvbFlQQUtwK3JGbXVONlZYOElhc2FEMWFCWVlySnUxeFBB?=
 =?utf-8?B?T3FkWm5ybUVVSVg1R0NESldDcGp6RzIwajlIYVF2NHpTeFZtMHBQSDY1RGR4?=
 =?utf-8?B?a2FoZDUyV0Yrc0FsQm50NDA4UzNyNmlydFF3cHdZVnN2ZjI2emVkcHhwTDdm?=
 =?utf-8?B?RTNiWTZFZTlnR0Npa1dZOHE1YzlRSzRicVcxV05HeEdkdytDV2t1L0ZZcXhX?=
 =?utf-8?B?NSsveUE2dWQvanVjZkhNanpYYWd5NUt2RGVUZkg2VjY5bCt2TmdFRVkvd0lK?=
 =?utf-8?B?SnVucUo5V0xwMWdqb2JSQ0hQZytZL0drdlNvNldoZHJJeHpJR2thcFROaUp6?=
 =?utf-8?B?N0VIcWdMWllsUnJSVVRMOTNtTE4rb0NmVEdZWU92ck8ycm1qOWQwMVFrN3pm?=
 =?utf-8?B?ZUdyQ014L1dwUmgzN0ZXY0dDc0JaSzV5L28wSllSN0s2eFB3QWZFeEJTWFpD?=
 =?utf-8?B?cjE3QUQwYXZyZjhSakdwTWVEd0VweUt4WjROVlFWbWpHSWIwSjhLdGFVRlc3?=
 =?utf-8?B?cEVFMW11MUFkY0h4NWxnUTV0T1loRURYbFFTOGxEVko1MElCYUI5UGJsaWcx?=
 =?utf-8?B?NlM2ZG5GUGQ5UlErQThwbk5STFBuT2xTellwb0lCc3p4ejJmR3U5NG5UY2Iv?=
 =?utf-8?B?VDRza1hMWVR6cjNVYXZSNHR5cTV6MHJ1TXBrNTIrN2lqVEpQdmtVZ2dxUnN2?=
 =?utf-8?B?UlAvaFBrZE5RNWgxb2hrbDUrYis5Ni9VUjMwdXV6Y2xsTGJTQzRISnNmaHVy?=
 =?utf-8?B?blJhZGx4U1F2L3drWEpNN0dUVEY3QmZjTFY5NzRsQ3RIT1JnSHdwd3VELzI0?=
 =?utf-8?B?ZWNYbUxSRFhoMStwakZxVlZmckwycmxlbWlpK2piZjVlZzR6eGVDL2hGcWl2?=
 =?utf-8?B?S0ZuUWVFZFZlU3VPZ0tDT3RqYkNrYmlGeUNUbW4vYXEvL2VWcUdZTXRkeFRj?=
 =?utf-8?B?cHlVY2gyYVIwSEhlTTZyK2FTbHVzTXFSU05icmtKQ2JnbzB1ZDcyY2srbm9O?=
 =?utf-8?B?UFgxYkZFS012MHU4Y3VxaHBrd1lUTGZtbTM2YTZweW1CckR6c1UwN0RJUWVI?=
 =?utf-8?B?YmJweHlrbHYrb3pibVYvVHFGMWdlVmFGMXliWS9KSm93Y3dheVVxb1JTeVZF?=
 =?utf-8?B?Z1BUd2NBWGVrWnA5NXR6bndtb3JUcy9yek1PNWVJWXp0eVVDOVhTOHZ2WExr?=
 =?utf-8?B?NUYxNGhJc3Z2VDlEZ3RuMitmTjRPa01zNUwxc0dIOFhYZi9qUmdqNVZjdzFm?=
 =?utf-8?B?OWNMU0lrMkxoQzUxa0ViMHpqdEU0Q3cxMEJtWm92aUtVNldlYkFYODl2RUdX?=
 =?utf-8?B?dzBrU2JDd2VyVUZ4U0tqQWg5UmJQNnE5TDhuWkpwcXJNeWJHVzJjbUVycnNM?=
 =?utf-8?B?c3BrOWxKeGMwaXN6N1JrSnpiUHlBUUJCV2JPZlF2MjQxbDFSSWdFYTFvVFN6?=
 =?utf-8?B?NjJILzZkS09PTFpZcWhpNE1wcmtMS2h4citLdG42KzhHVzMzTTA0NWRQRlJY?=
 =?utf-8?B?ek1tNHBxeC9vcTgvVmNGSVpodmE0S1FQWTJMRzFSeldnSW9vTkR4dk9RVCtZ?=
 =?utf-8?B?RjdycWhKRGJ1dzBzSTFCUU9HaURRMHRyWVgycDFJc01vbjRvTUcrVmtHK2FU?=
 =?utf-8?B?clhRcXBSRnBRWm52VzlCMCsySXl4RlA2ZlhUbWR0UU05MVNKZG1GeEtzczRa?=
 =?utf-8?B?NnErYmVpYTgraFpldjV3UTgyT2hUMHh1S1FIa2Z1TmxscTROSXNJVWt0cnR3?=
 =?utf-8?B?SEFrRXFLN2NWZitHcy9mODRFZ2E2THJvQ2xyc3FZako2ZjdGdXBuZkZUUVBj?=
 =?utf-8?B?K3FZZkpuSGgzUDkxQmFJZTBaVGhnamVIa1Roak9BcTdaR0RzZW1kdCtINDVl?=
 =?utf-8?B?b2NlOSt3dTU1KytMUjlXdVRvZXY3N2U1Y00wb01ndkxEbTF6dHM5LzhEZ1N0?=
 =?utf-8?B?b2c1djhlZmY2SlNqL3M1NjZKWEF2bXBobVJmTG9UTjdQYy9IL2orQW5QRElt?=
 =?utf-8?B?RkR4QklBUFN2M3pwYkIrVG1jTndqQnY2RS9pOWhzdmZQbytRSTZmb3VFaEdT?=
 =?utf-8?B?NUhCUVdBKzlNdEhCTDBndy9CTUYzOW1YTzlHS0RmSnZyUlhmTFU4UDdzT2g4?=
 =?utf-8?B?cDJYcWNQQjhENEkzQTVSK29JN1UyVFBoMi8zNTVDa1pWVmtqMzZDSTllSVd1?=
 =?utf-8?B?NXVmRzlTZkNOM1lUc1dZMWxLSFpJVUdHdDE0TUU1THQxNXpnWlNQamVkakFG?=
 =?utf-8?B?dGVvVEFVd20rcFJoN3d3THlQY2lWckZrNnJNbElGdWRoL3EyZlRnVWk0eU9l?=
 =?utf-8?Q?qzYcNcdBZ4kA91PYVm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4fdab69-3990-4c70-9950-08ded775248e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 13:32:05.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAuoM1pqHwUjbfl4YCSUqQY7+lNjE8Zy+SHvB236QNhZEC53tbUrTmQHPocgJoTy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5840
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95FD74000C
X-Stat-Signature: 8bc6m33xoc5xodmjyzj9cztckhrgt4oe
X-HE-Tag: 1782912735-851467
X-HE-Meta: U2FsdGVkX1/t6hJiwmkn3VrwIKbpprNvT4Ydh4gyzPWtMuTpEyyLKh9Er2aOYX1werlN83VL2WEDixBVVaM4OcWNDa9wsVfL2d1W73FaLzq3UvQRIkj1WYfQqMOJYpKo6cmTEG0Xqv31ImfQ8B/KGMQfx42ubYM/E6sCaRMEd0Dn4duSPDag2IzW/pj36rE44sTRRSjI6f39CM9x/PMRlFOHqB0JjQg+PqNZ38J93C0+/lLt0fzUt6DIfiBgncinfsX+yFkoZkoo53KF3EnPxN7sLAeX3Xe8l+PZS6x26At78q9QfQhixbKYA5OB+bOky9JjLYh0+BorCJ4XMQap79YWNoCDi3CiNiMSALozk8KmCW6zo1QTas0lRhPCUq4T5SApirT2BptwA7sLniJC3DgvKBAlDWm2OcdWZjQVwWtv1SN12QJxReB9UPDUK36Ei2+ecTY/knCgRCGGDfxEzuVlow5xP17R8BclEFpb6p8vAnk9TdH+XwM9mOJZmu4qN9xnr2IC9lgowZOFfqvXL46xl+NwbZk6F5YItclHMn5E3ZNZagzg5BzzVJUTtsBu0HVKjDYRd7L9JwA6IJJbt+Fxw/+HzH5NrMyi0WlXnFFN/lKxkHQeZgT1ZKzG3UHquSaQsEjn/X3Wz67ZFPQlwMp/Ou2CPDSu9MmBeaefRU3PyvKIwJIdwic40VShoLC3at5TkobloHSqIs7Nr3MuYQtpx+j2OTQ7uMz9gQ0/P6UJt3DbQyOTC85vMgWWaA++FVu+LXpmk9Q0/GkK4KWmheR9VIjiG93SFRcysCcePqtFvc2xJ161gh+tPMah6OGI7QYd7zmSSsc9gcORlWQq0FUTpoBpueizn9etHWdRog0pHCOSsZWlVc0Awig9eojR63gFzWAlZZzLL3JlH1dG5UQOoyrA66/0z4VejWbUJHhW498SY7EA3Jf2INn2ZcKb33MqVBUIVN6TX+DCA1d
 5Y6zSUlC
 52UcUwATnsIl51F7Tom1NEz5qshZInI/kpkh1bdt9oCGmvOHpwVAoj5pZsN+K05zkpegWzEatCr77/VpUZ0grcUtf3jCEY3L2ws+JtqkpOLdA+FjZatfmA3ubyzt/vgtpjUo9VakVQDYBNK/0U1X/1hMDx8QhxWggTTcwQIPnX1L8XTQv4kCzMhpZL3UM//VHdOGv1PrsIt8DrWz7N/uvyoIosh21x/a9MSYqwVbMA/U2cZTQiZiA7ogtDARpYAUEz3kUzox+5RuLhsxTcZ6s23vefQIZYDzaWAJ9FT8N4X2D3QAwLcgho1cAKGzEUVgSxPHx1LW0a8WvGkrH8rD3PbxucMF2a/zIuJF4tjjdM7FTeYN6MBXO8t7PsqfZLNcqZOBvmygJvLY0AmP8yNN90IbSopp7Vj3qSKuSpcQ8iSyPUZ2u0gsd0MrhvoKYrY/n3v7yP1Lysb/hazgrMI5H9gjQfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 1, 2026 at 7:08 AM EDT, David Hildenbrand (Arm) wrote:
> On 7/1/26 13:01, Lance Yang wrote:
>>=20
>> On Wed, Jul 01, 2026 at 10:56:47AM +0200, David Hildenbrand (Arm) wrote:
>>> On 6/29/26 16:39, Vlastimil Babka (SUSE) wrote:
>>>
>>> s/add/readd/
>>>
>>>
>>> You can link to the discussion where we clarified that this was not int=
entional.
>>=20
>> Probably this one?
>>=20
>> https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.=
com/
>
> Indeed, thanks for digging it out.

Thank you all for the feedback. I will update the patch based on the
feedback.


--=20
Best Regards,
Yan, Zi


