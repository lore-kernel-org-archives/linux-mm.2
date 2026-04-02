Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACB4D3943A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC126B008A; Thu,  2 Apr 2026 11:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD3F6B008C; Thu,  2 Apr 2026 11:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8754E6B0092; Thu,  2 Apr 2026 11:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 734006B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:31:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF00313BA02
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:31:05 +0000 (UTC)
X-FDA: 84614004090.23.24912E4
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022096.outbound.protection.outlook.com [40.107.193.96])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3C4C180010
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:31:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=qLusmDXl;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.96 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775143862; a=rsa-sha256;
	cv=pass;
	b=NOpf+C0dKg62qQJNC1iy6ACSn0pm+b1fGhfta+aEJ5sWqYCYs1k+MTjeIkF1UGPWUdIbtI
	nyyd94y1a5uGTmH5vhyepU4ObANiD3Z77AHXxpCj3i0O9MrhbDbORNPQVbyp0O32GODq00
	7fOmTDwikK7lZgl4bz8XNA/a8voiklk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=qLusmDXl;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.96 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775143862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFIBhl/W+3X2hmUP29L9om18ibuz/CQtCYXvhcvOAOE=;
	b=CaAtlXwutRdtN/NaliXHtGIFZXnS2vhsP4JdmCG8Oru8XrzIoBXFw6eLGv/qJ4gk2qWwiU
	Z4NG2id3galPK/6ziJd6QSF9IViNeGMGoT/Wafg6v1fHUnn6R4WtZXoJandqoin3/AfrZI
	IwDPIrGJLTtDPKUiD+RtRt+rYdyueb4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AphU9fpqlykzhU6KiT5peN8reRjINZNhctnDX6bSCSVxb6CmwqFiJqIaEHfwWJWCsTK4s/tIEIAOXZ8bxzydFSO4dmdPskh1G6niFGnuNZttQn9T/7TQhEuKHdwyb8ZqsSBRFTiTkUqG/Jhmpinpzno7kRBe3Fjir76Wfj60K7Hg5WgR1ROqvnLmHkU+mLSZP+utOKA8YAuUTXaYrTBaO7m4GWHqm/fCPXSSlcnLJbZARlhcTAB26zg47EPJvsBJe1fL5eqfQWyXfN9F1ls+Uch4f1Uft7zYsJ1cvpIYDKfvrk8KckyDCVX4W0Cq3XlZaexFsJGVWHELn1WM1sfoPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFIBhl/W+3X2hmUP29L9om18ibuz/CQtCYXvhcvOAOE=;
 b=ogF0G83fgjZiAEU0XXma19cylz9WRg17klKUgGU12qwQdVv9pFb9WAEsdIRYXZIuqQeirHEFIUyQX+CjL7xfTN7kUeZkmE8BNt/F1jQRfQgwXRsAK+xKg2s9c/kj8rRyzbaQMkjNXXktQLqLLPVrSAx4g51pJh0T06yYeFVHOikyfnVi1viHc7r0gI8WxsD7G7E9KS0PMsji+8feJd6DPpvPkuoSH0LakiwwbK8r268jhClKoj2kHese8fAHqR+89YU0Wg2hghMTnxOaTrTcQrCXJaNTEOrMKtDtJzr2nXGjzCtmED/8zJRY6g5+lz66atR9bEy8gxJEkKBkdLzndA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFIBhl/W+3X2hmUP29L9om18ibuz/CQtCYXvhcvOAOE=;
 b=qLusmDXl+47LxbZk/p1JLPt5yBzxomW3VO8CNxOKSOPbvERittJIln/w8z0qoAykxQg2UQAt8b+xRIb9VzDdy1g8gypo94cFGWyV6GltgdJLt1XwoVqcXujvmE7UqeuCFcb0eqtx89Ht6i5HAnUThTZb7GjWOAUpcxDfZGqHvuBDZEtMYD4cXSg1l8JEMG8vqIK6RFRYmKxpCIMOigQsZW0vTUfU33cjJz86hdog8ojEGXCWUYq/B3pCyM32WfBY+ub/qfl641G0F7uQ+u0HeerK/Kj7IyO6gv2WT68z2YzC9DN8pfv2HQIDoHtSexXJhvBJ0PQo489O0CuHb623rw==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT1PPF14C895038.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b08::509) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 2 Apr
 2026 15:30:55 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9769.017; Thu, 2 Apr 2026
 15:30:55 +0000
Message-ID: <6a5f2139-0ff8-40b3-88f9-98d2ea020d6f@efficios.com>
Date: Thu, 2 Apr 2026 11:30:53 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
To: Andrew Morton <akpm@linux-foundation.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, linuxppc-dev@lists.ozlabs.org,
 Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Michal Clapinski <mclapinski@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Srikar Dronamraju <srikar@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
References: <20260319233745.GA769346@ax162> <abzKcGiRSR_E8lLN@hyeyoo>
 <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com> <ab1J9ODkX5iChu-C@hyeyoo>
 <7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
 <7a8faee8-0eb5-4e58-a6d5-ef711791e3f4@efficios.com>
 <h5qax9x2.ritesh.list@gmail.com>
 <20260320192153.759d6fec57f04fb653a0dac7@linux-foundation.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260320192153.759d6fec57f04fb653a0dac7@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::21) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT1PPF14C895038:EE_
X-MS-Office365-Filtering-Correlation-Id: cfd7a477-03a1-486f-d334-08de90ccd4db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iHKxDqzNMd5Fg+mHLiDfMYBcgcfhbQ6R30Db28n291PjCX0TPGg2C1OuXcpN7S1o0UhzK+Pt1FhjKmMnD5sYKoFH4zo+oHifVVdgiaVRAg8YttOlPDoODWv7izK9v6jP11p0t+hLyJiP4MIfZth6AsJtiks1YtvDns4HLpj8Eq645y3IDfBObwitNEPluwBaqCbWFQ9EnHy2anqJtKrcYUwBd+yyB5jxI8k9hUDGV33zqvyrnwUTdEZT6rnyrp8QQ16ngi6K6GV4BcVXKqDbdyMEmbm8iHStY0Q1g1Daam6kG0MoEap/fN1XLesRh4oe9n10AfqrHCyw+ogk6iiSstSWOHjDU3WTzLkiwB0l/erQDqrShngG4zQOlPkyyPR2k0c70d4wLsfWQigJkmBJih1f6K7eKOBvfj7d9hqLjhhX9OzSm0ZS0eQ2qRce79oVQTOJz2ioEf5dIMFCqHKE8wIohCXrt4FxgdJN2PXh4KlQlbJ4h6YhcERnnCd1wf4zqBYX8PCuBCZzQss61EBiLv3U6HbqEFWfU9ESSfPtohuxeHx3Kj6WIdLAAsFujwLpxh0VEfWC/5/FzZxXjO8mnV+1MFwRvRKlh/lDsDwBySZFtgBQPSduMPFpdlp8BOlEV/M75QzDYPIAB3Vq0TJsEhuc2Pgim4d/P5RqGgr2Cl+rXZKcyFU8x8Ac+s8JHJlL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTBwYkNOL2lyOVF5RHpLMUlhYklueTEyZUxTRHpUNndSUndFUE9WRWhObDEv?=
 =?utf-8?B?dlBncjNRVXZHUDBnSVJEOVZhYVFEV3MzcnF3TDY5TjU3bGdUK3RHSHRCNGVY?=
 =?utf-8?B?Q0N0dHBYVGhBT2xaZFF4KzdYTVVzNkM3OTRpb0grN1d1bVNOWnhJWHBvOS9y?=
 =?utf-8?B?d29CWmliUEd1T0Y1ZDdHY2RxUkRIYVl4RGpzcUlqb2syTW51WHl6WEZkVnlj?=
 =?utf-8?B?Rk04TGtyMVJyYzc5Y2NPRytuTi9LcnhjK1ZnUFpCUkJvYzlvWCtsMEZJeXo3?=
 =?utf-8?B?bEZXZG9XMVEwdEZaWmRZOTYyWjdhbDFkYmEybnF5cU11WllNdnJRSWtWTXJi?=
 =?utf-8?B?anhWWUppVmdhdEFsYmlsTktSbUhuYXQ1Rjk0amtDNlpOazdqU3A3Y2JpSG9Q?=
 =?utf-8?B?ZFRnUjlKVkxOdHlueURQWnpBM3pMSTRYUVh6ZkUvRnhIL3JwT3ltU2dLOCsw?=
 =?utf-8?B?NE9jaGV6WnhsNSsxM054ZmNoRjhPekltSWhzOTRTalhrRHpRMjM3Sy9Ua2JT?=
 =?utf-8?B?V0ViS09qSC80VE04R1JYVUdPeDFDWURPUC9jcU10VTQxYk5mcmVUUHNDVTJx?=
 =?utf-8?B?ckxGRnRPejJVa0VDK1ZaazVlQldxVHY4dDdWNDZTR0h0YnAwVktRZTg1YVFK?=
 =?utf-8?B?K2dXOHZnOHg4dDRnNTZ6MkErOFJpQ3FFdXdyZitsQzZJajJtaUtCY0VNUFdl?=
 =?utf-8?B?MXlDRHI2czUrSWM0Y1o0b09teVFBUWdpQm12VkprTGt4a0FNN1VZVG1NNWJJ?=
 =?utf-8?B?MEE2Nm1VRkh0YzQ0UU5ITVZaNnFQMkJHdzFhSUNkZWliWEg4OFV0dVQvUGhX?=
 =?utf-8?B?QWVTWEJJclVKa0liQ0dkWEF5VkVJRnVCTDJzQWQrbFRRL293S3JueXFTZTM2?=
 =?utf-8?B?S0EvTkNIUnRPRFJ6WUl3R0FzOGZ1bWlXYmlOV0EvektTSUFERi9CVXpHd1di?=
 =?utf-8?B?TnAvZEIrOHhBMjFyZVJTSkh0QVNIdXFHK0pLR3pQWTJtbHh5cXdHenVMVEd2?=
 =?utf-8?B?V0hjTk9BcHhwa1dTd2FRMlZRMlRHTjdCTU9seEFocngxajlVVFkxZVJnaGVh?=
 =?utf-8?B?dzNCR3RWMmdIT2lpYXN6K3JBeWhQUWt0SXJrVmllTFFwQTlmRHZrdDJIZ09Z?=
 =?utf-8?B?cVYrblhLNnVTSUViRDNhVzZJRy94K1RuUThoelBhSHA4QW1rNC9nUHRoS0t3?=
 =?utf-8?B?S1ZiZk1YMlBPR3NVYWxxTVNuNnVBMlRPbDRGVERDS2h2UXhBRFNlZGgyNUpC?=
 =?utf-8?B?Uk5aQU1yazhwTS9vMGlxR1NYQW83a09xTHpHcmREY1hScGw1NHlSUUtwdSt0?=
 =?utf-8?B?NG9kNG5wMXRVaGI0c3BTcDdlSkpXbnRyTm91MmxqWEg2N05EZUJqTTk2N2do?=
 =?utf-8?B?MnVEdkNycWVrSkVDcU5XMXdlWU9PUHI2bXE0VUZKdDlyVjZ5UGt1NXBPK1Bv?=
 =?utf-8?B?M0JWRW1RUVUvaXF4WFBIalNTM3lNbE01VHl1VlRvUHRGVE1DY0VYTGRONHhu?=
 =?utf-8?B?Q0t0aXNaVDhxRjBsVUpET1J4dlg0Ti9PUmY0MkE3OVpRZnVBckZvMW9RNWF3?=
 =?utf-8?B?TE9OaHRMQXdLS2tDWklmL1VROTZWVkRGNHB0a09ubFpxd0gveGFpRDFzc2M3?=
 =?utf-8?B?dGNyVEdaOXN0a010RWFYM0RYVDR2WW5TV3dieGN4TkcwWnhZdXBHek51WTdi?=
 =?utf-8?B?UUswRUdKWUduVit3WUF3dHRuNGcxdnpYbklsTWdoL0t1RnpYWVdpOEJrVk96?=
 =?utf-8?B?QmNOTEZSaWwvYnZUN3BUSWZtOG5MQ2lLYStHNzhqNDZaQVJ0ZUgvcGNOeU5U?=
 =?utf-8?B?UmMraTF2czN6NHZBQXJYaTZXNmJXbVFtVVBIcjZ0aDZ1UUFJYllFKzFDMmc2?=
 =?utf-8?B?K3NPQ1NRYzF4Q0pDTGcyaERpR2tqKzFOdkhwdU84cHJEdTFnemJBTGc1a2NQ?=
 =?utf-8?B?aEp1S3crNXFHYVNabyt4MFRlSWV3L1hjMDNFZzVmS21RaERDVFp0cXA0N3Nh?=
 =?utf-8?B?M0tDNlMzK2dMMjkyQW1ibnlqSnZpZlVEZSsyWXpzUkppSHRNYUl6YnJ5TVp3?=
 =?utf-8?B?V2FXcXU0NEFKZnpzczlFWFFhLzNEa3d3a3ZodmNsa1ZWQ040TEJjMHhFSWp6?=
 =?utf-8?B?VXVKOVVWR2RFMW1ObTBOQVgwQ2dLS1VFNlp3cXlNbjl5bXdjN0xIb2I3am9m?=
 =?utf-8?B?RGZoZlA3NXE3cWdQWnY5amVraTJHbHMrdG82UmdPRWM4V3ZnNmtFc0NDNnNR?=
 =?utf-8?B?QzlycDdHcmh0V2FBbUVCNXdEdGttNWR5VzFOZDF2ZW1kYmhGdUQzQktiOUxS?=
 =?utf-8?B?b3BQZWU3SEU5Rlc1ZTNzYnU5Ni9sc2ROWHRPWTk5SHRwbWkveDZ3TG1aeHJD?=
 =?utf-8?Q?jrmY1/M7V3aOBuf+oAnr86llynFYnf2Lf2Hta?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd7a477-03a1-486f-d334-08de90ccd4db
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 15:30:55.3802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T6DS4KFhhF/3Yiq4e/FsGWy7FFwpSb9fHX4vrVDFUFk56NZXG516Db/aG1gNmTyJAX18f0CJl3Rv5aDd2xOAamuttyz/1Yi89AI1CC0c0F0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PPF14C895038
X-Rspamd-Queue-Id: A3C4C180010
X-Stat-Signature: cau38kk9m79w5inhsmwjmcyzwi4719fp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775143862-71492
X-HE-Meta: U2FsdGVkX1+KbY43U6wUuNh6D2ovb4pDTbJunASgdK4hg5EcZH1qF1oNP6HMTnVjIepNgLyLcjhgtcrYkONCZKc9b3QfslWqtZQwu/Rp5mhcPXpxfd2gyrQKslEBJe5uRhCbrxmllbPg6MQ8Zf0MhtVpd4K52pS5v3SqqktmE2spmShDbMgPb20TZMBDv9RzFmm8PDbt7rbroN1yehY3QEDJMRK90wlppOiJMRQdkzQL7PCarqJzZetsExudShHTdA2/3vG75zd2SLOuO1PfW93WkU4mts0Agi364Ec8C8orkEmpWG9PjIgsb6ViIFFb76qRnItEDYrfzfKuQP4bdiyauXG0WwA+uy0nyvvMFo8j0oTIEOu+ElxJ4qaaJBlkUL370VudKDW3oxXNEIrHycuvOhe6Fu2K+NLmk9gqq0gZun7JkxQMW0GAK3r51CJcS5JYun5kWCxFOvENaG1O4uM3jmDJmO5C/kAkC9lbzlnjT0KFS2fxcnbwmA4ZnuBrl9rMH/SzcRb++K2kFAgH6K1fRYxLkVfGpafXsb/tq7UcI2+kMTRHp+CVNBpTnx6Xt6oyCAF6iSmUeAr9zuvCcKrFhQ3SSHeBIU23dxkOhXoZFDvzbTkhgIM+uTjGT7MB6kYmWslxWY5XJWbf252OSkOBueZlAMUKaDbjMjaGdjM5xlFNJHTH7J390zQ8A/qTfw3ysMr0fL0XP3UeMx4NKbWWSdk3HZJr8tkACOw+2Mx1aS6wW4kKLxFHju8Htee5bZMYcPqKCxG2d/ULHn8z3yTyQKYL0sw+1O4fB6SV945GooyRY00KZgVljDWKUAFA/XwamoPTtDMAQx9+m5RfC2lDF/CVVSarWuk92VrRgV2npjt00Ytvtwy1wuGz6ghUt3tZZQJ9IPMkXnrDqAfKV60V7e3oAvVEbCpmS+VTDHAqmfeK8SZ20vZbv2RuBcFCPJplIqY9POKqzzUSZhv
 7It+l/el
 sV+Xna2eF5VXEWDN+H0H2IDYjkGhYqZb5abm/CrzqynIOXtNjxk6Q+26U+yQhZPLTNLanhzqzn7FlxXA3gKZhsuqK+y6PcKQ1Q+IAJ/EsmlyrxijNh/j1fUdlqm3nToBKP59XRdD10nRZlcvvT7iEhj3m5Ml7xdexDLUad0wsr97YF6s7a3akPMP8E7VkfyFZohYnM1dB56tZSmYdmxj+E92e6tUt7eOvVpcxAAZsYwUxhZcRfsEoGvC0mU+H9xk8WiADIz6JbFVAM3Ckz51n8oG76lot0Fq8pTNsWjU4MAYPtH2AOOWZRgYE+uQV9xS9YQzp+i1U32gzLuGfMCI4FcBcV/aEudc2/PU4/6Xw0l8Pj8EKNPH56iwQsYcwbZaF6eXMTDTUHbIZrjC9s0biDLHk7lDTzHwbNqgUBEEJKUxODuKUZjcVzzLS8OjoTQG0w0SYvw4Pi5EgnTuN+1g1IsEW3O2+gSqRiWhVH3F7DmdT9soAAngxT9qVUOFlcmHkboJEzlY2oNrBvXBm37uLHnXNkZYJDlo9iA10Y68OFGi83jMLlk89OUKOwBwcQvPIxOBxsjufxiPIfSPiv0pAOVjJfQ1dM7+XsEETJzlkU5jpz9NxDIF56Bv1cLxltkspNgFS7D/SV9bNFgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-20 22:21, Andrew Morton wrote:
> On Sat, 21 Mar 2026 06:42:41 +0530 Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:
> 
>> Looks like this is causing regressions in linux-next with warnings
>> similar to what Harry also pointed out. Do we have any solution for
>> this, or are we planning to hold on to this patch[1] and maybe even
>> remove it temporarily from linux-next, until this is fixed?
> 
> Yes, I'll disable this patchset.

Hi Andrew,

I have prepared fixes for this issue. On which branch should I rebase
them ? Do you still have the HPCC series in your branch or should I
send it anew ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

