Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAF3CD585E
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 12:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42C66B0092; Wed,  7 Jan 2026 07:11:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEFD06B0093; Wed,  7 Jan 2026 07:11:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5276B0095; Wed,  7 Jan 2026 07:11:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9591C6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:11:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7F7E13A6C6
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:11:04 +0000 (UTC)
X-FDA: 84305052048.22.8921F38
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012017.outbound.protection.outlook.com [40.93.195.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 171A840002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:11:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=citrix.com header.s=selector1 header.b=YEQ40pcp;
	spf=pass (imf27.hostedemail.com: domain of andrew.cooper@citrix.com designates 40.93.195.17 as permitted sender) smtp.mailfrom=andrew.cooper@citrix.com;
	dmarc=pass (policy=reject) header.from=citrix.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767787862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMnmLy4ws50j+rhYtlqoj7KCsfnPl39S1vS1XBtCEy4=;
	b=8rV4cF8NPn/paKoragyCc/5wkB/E6hHe1nINPMvOvA6WRzxaYkkMl7YHNI3TvZQctYH+iv
	JbPHGZV6JbplRRt0A69mkkKlRFUlSbGEO6Nxo6q6KUgA0PVrhN/wQnB+R12r1QiG/S+Op3
	yffWajyUQjW8C8PWyJgroOcudjkmumM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=citrix.com header.s=selector1 header.b=YEQ40pcp;
	spf=pass (imf27.hostedemail.com: domain of andrew.cooper@citrix.com designates 40.93.195.17 as permitted sender) smtp.mailfrom=andrew.cooper@citrix.com;
	dmarc=pass (policy=reject) header.from=citrix.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767787862; a=rsa-sha256;
	cv=pass;
	b=dG4FYqoHk4ga9JF87PfmUkZpHhXHrQ02ZRjfIrn77nQgOduttEPsFMOr6tAzvXDMennlUg
	jZA9IzcK5r5R5esKa8KcEDc6jCBfx/wgai3fq1x/YrvouHG/BX+NuIx8zvsVSLLlCrhes3
	Ga/ShfDFAJum5AjYMnzfy4ko5Arlycc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n0SLqxYgCzdo4siE5vD6l4UcDkIN/WOWpCUu6Xo3LC5OzhWv7ngq3q/AEv47orPx3lwpDTD4CQSPKmDLa6rp57i1RdHNH5/9dJ912k7Biw6u1eoNmLRFdQRnRuv44tQtNTauIF/NKH1MFhmm6GpR8KZ8d28lyaYE++W4SJQISIY51rhAMk1h4z6nfCQGtgYF/ba27rWpzVCFaLkyv31tPIOEEoV16OJB6qblLFT2B/IejLgbChidbooy8wG7MBfuQypEJFIzgH4qBUGDQi0UY5R5bEu+QOGqWn9ZIxDb3ap9g19thWFS/nyrN/R+GeqfSgZUbiEQ4Gzc96tF/i279g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMnmLy4ws50j+rhYtlqoj7KCsfnPl39S1vS1XBtCEy4=;
 b=G20U5dW0wUEheWb3VeOHCIPk2dR+6T6P4WJZrYmiMwWDxhFp2AlqrCeNtkj4On/z38PvtlpEC08bbl+QzHr9frGNkvhTZjFWC66mDxtwS2JGeQ1+1bzA9SGIxxhlC0Kb/e07kSFia+IysSmRFcA5d/hmhWsJnTd6drCkqUAR+PJtS0RDiU1lQuyTuaggktHonYni0GTiIoFht1akEIvFRWDKngHd+HaNiQjjx8PYeiW9jXr2DBaCM+8N8mb/tfP+geU3l5UOucfMllce4G/+zDi26HnCj1kXtGWKSRUySSGX3ifzahK86vJpagHrSxZjruNF/KP1jlkO9dVwtgoWYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMnmLy4ws50j+rhYtlqoj7KCsfnPl39S1vS1XBtCEy4=;
 b=YEQ40pcpL7MjGJj6Af6YAcidqno/L/FYSyXuxbT5vd8Tp52yQxvLrF34/jQp5BzAErvcIgbTp2S9RtcrZ2X04Pa0smYFL8NlfejuYKTsdVBrsYflfpIQpF1NlobJ+ofDUm1LZ48cBsc9vVzKkInIYG+Wib6s9ir3+vkZzbheISY=
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by SA6PR03MB8000.namprd03.prod.outlook.com (2603:10b6:806:42f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 12:10:59 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%4]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 12:10:58 +0000
Message-ID: <0d53c80f-46e3-4e78-8d8b-cc36085229e4@citrix.com>
Date: Wed, 7 Jan 2026 12:10:52 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v4.1 07/10] x86/entry/vdso: include GNU_PROPERTY and
 GNU_STACK PHDRs
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Xin Li <xin@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brian Gerst <brgerst@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>,
 Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>,
 Uros Bizjak <ubizjak@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
References: <vdso-cleanup-patch-4.1@zytor.com>
 <20260106211856.560186-7-hpa@zytor.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <20260106211856.560186-7-hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0227.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::13) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|SA6PR03MB8000:EE_
X-MS-Office365-Filtering-Correlation-Id: d2e61065-ae94-4655-88b0-08de4de5d108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmxMZlJSM0F5Z3dQdS9uOWt1Um45RFlpc0E4VFZlZjd2RkZpYW1WYlA0RzBk?=
 =?utf-8?B?Z1BneXZTcEJ5Q1N4UlZSR1BWS0o2K212RDJLdDd3NXM1cFdQOStRWEx4YzhO?=
 =?utf-8?B?VE5GdG9NRjFhdjU2SENPM0JLckJKdTVRdjB0Um5GZ0huUTlaUnlvcklaYUtL?=
 =?utf-8?B?OWJnckg1WndhRWxHQWV6dE1xSUJaRHJvVmdsY2p1Ym5vVEFTV0FiZ0gra3lr?=
 =?utf-8?B?QnovZWFjQUNoQUlxTDVvSGdyZVE5Sll0TkxhTy9tNS9EVC9FTlQ5S0dYWXpT?=
 =?utf-8?B?ZmR6QkI2KytSa1o5WUpDQjI4cGZrTkZVYXFIM2VLYVpYTGlQSml2RWhGMGtt?=
 =?utf-8?B?V3ZNbVlXcGZOOWxEckZnY2piMHg2a1JjN1JYMlN1WTFseWxJdTRPV3lkZFJu?=
 =?utf-8?B?OTlqVkpORWtXTFduM0pNejU3Ty9yZzVybXpqM0FFMHZKdnd6YUtKcndLNmFD?=
 =?utf-8?B?VkcyOHNoRWVnazBoNWdxVk5YaTRQVnREbmVxeW9SUGhGYitNSm1seWpVMTNK?=
 =?utf-8?B?U1FSMXRxZHBQZFFGUmdaQjh6Y21mWCtCRlNEMjVRKzUxRENodHM2U2orakJh?=
 =?utf-8?B?bmxQZzN1M0NWNkxRam1tZSsvb1kvUEcyMUhkYWNneHRramlUTytiWVV4SzF5?=
 =?utf-8?B?SE91aFFRaXFNd1JCSGpteXBrckRVRDFzWEJtN2VwazZNQjB2V050ekpLbnJq?=
 =?utf-8?B?S2pHM3MwNVp3R1ZJbXpKREZrcFlmMFd2OFhPRVZBdE1vQldzMVFMMDhGcUE3?=
 =?utf-8?B?TjhwN1NWT0lqbGEveGU1bmQrb0xVd0h0UHh2OVR3UWJLVjIxdlJVb2c2S1pN?=
 =?utf-8?B?dGNBYVpwT0R4OGxiOUVPejB5WnJsVy9HdW1NbEhIMFdpSm9yMTJzYlR3YjVl?=
 =?utf-8?B?djY0WWVJcS9mdnI2eUJWNktJQy9xOFNtUFNNand1VVlWTFkrZ0RjZU1Na29t?=
 =?utf-8?B?dmIwM3FaV0VDQUc0dXBERkd0RXRkQ3Q2bHVoNm13WlEreVNuMFlEL3FvZXAz?=
 =?utf-8?B?NHcxR0FBRjBIREYxazVtTjBFS0h5SlNwWTlpajJyckpIMHNvTnM5NVJuT0Rl?=
 =?utf-8?B?NGhpakF3enZ3VnVwN1pWaGxrR1AwWHNmSVJacjN5VnlnUXFwVXhReGR0QXpD?=
 =?utf-8?B?bDBTUEJLQ1VZWGtxcHNsNkRsVGFEc3BGcjBsYWF2b0FzdXhhZ2tVNXg5NHUr?=
 =?utf-8?B?WEcyVWlBUVBXbXc4TWpJTHhzcXZCRng2NWYxRW5Fd2RRdW9kOHEwV09yN2lq?=
 =?utf-8?B?RjdiZnlOY1YvYVVNbGF2TStjV3ZldTB0TnpRMVlMU1kzS2JtdTFvQkRTUXZj?=
 =?utf-8?B?cmluMTdYNTdvb0ZRVGdNUUdjazJnOG1VLzVqcnN2bXlPVlUzSUM0dmMxUXFC?=
 =?utf-8?B?MEJiU0swS1E3UDNLYVErTUZLcjVVVXJoUittWmpia3o3ZDJTdkZFRmEzb1Fh?=
 =?utf-8?B?NGw5TVFZUHU4ZGROOGlLRVhVZk5kbFUvZ0lDaW5VYTZzelppcXcvKzFBU2Zi?=
 =?utf-8?B?NFJKVlBBa3MzV0FYSDVzSU51YkJTbXMrODJnME13OEg0clVkWmgxR1A2VVMw?=
 =?utf-8?B?WDVIb0wwMFFwa2loTFBpS1NMamFMYWVvSUYrYk0rSmN5T1BFVzg1RkFIS2ha?=
 =?utf-8?B?WTdoSy9zYU1PSVYzWWxPRE1nWEcyL2Q3ajJoN3dYTjBMV2NMdmJzZUEzVi9u?=
 =?utf-8?B?V0hhazY1ZHV6a3packszbXI4aTFFYm9yYzlhRlo0ZzNuSGNUeFlaMTJzcU9t?=
 =?utf-8?B?Uk51S1RVdVNia3FpbUVteFRtT3V2SnFEWDRERHNzN3N3WmdjeVVjYW5BTW9q?=
 =?utf-8?B?aXdIOEMwclhQdysxd1BhbWJja0krd3k5R3hUV2NKakhsRlhIc0VyYWRiZlgv?=
 =?utf-8?B?NjZOaVNaL0luR3FFQ1JYNjJ1Z3poTU5oTnBFQkN2d2pHRUJ3Z00venlLakdj?=
 =?utf-8?B?eFpSSVBrU2hkQk82dHF1RjVQcy92d2xIK2NNeEVTc0g3UTdQZWJKb0k5OHR1?=
 =?utf-8?Q?9ZuM7xC1+GehEVGLDDfuTLEjQSu+VU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzEwSi81cHNVa293WGViOHlhTEZLTmx0bnE2dTNiZnNoRmtrdlJyOGd4QkFG?=
 =?utf-8?B?UnYrakxoQlU3OUNUQ1Q3azlHMUZMd0JFL1c0UUxPNG9Kc3VTbnRkYWZQVzRZ?=
 =?utf-8?B?bXQ0RzZBakZLbng2M1RmYSttazZQVzl5VkFtSlM1cGRRc1ZQbEFCYllhVDhz?=
 =?utf-8?B?c3ZLb00rbkZJOG9oVXEvNW5UTTVHUVhDWi9PamRsMXRrU3ZSelNVRXFqcDV4?=
 =?utf-8?B?cytzT2ZUaDZpOVgyWjN1UFV3L3FheUwrWGFkTGxyYmdmVnZiNnVaankwekk4?=
 =?utf-8?B?MWhLTFErNG1Rc01YdjNoVU1rZGNnZmtpWnZRSUV5VHFtbXROSTBTc0lUNW5n?=
 =?utf-8?B?aW1xWjhaQTA2Vmc1OG00WXUzSlQycHQ3aHBCVStnM3dVMGZTY0JydjhjKzlh?=
 =?utf-8?B?MWE4Y3BsQUw5NWw4QTg0eEFoSVB4U2NPSGxPZHRzZGkrTmZGSmlEQVBOdGxx?=
 =?utf-8?B?bG9yWUQ2ZjN1b2VHZmU0VnJSOURPVEZnWHpMUkZWT1ViNy9PMUU3aTlWUGJk?=
 =?utf-8?B?VTMrMExXeVJ5KzJKSnRSL2YwSCtaYkVjemc3cVdBTHNIQ1pZL21OZmk5NkhD?=
 =?utf-8?B?MGlRU241ZlBEK3U3ZEpJWEZPbHppQkVDQjB5U3d1N1JFQWlFYXc4cWJ2SWEy?=
 =?utf-8?B?RnN0Z3EvOUVzSkEwVkpiTWtpUDRWcHU5U05OeVdmT1hrRTFUZmhiSTJ1eis1?=
 =?utf-8?B?TkljNFdjazV5eVQ5RktZdHp4anZOSHVGZFBVVVBXRFVUVGc4SWNqejNid1NQ?=
 =?utf-8?B?RmJNd3NmL0QyM0RzSFZoc0hLNnRoTm5ic0EvbWNRWkxNVW1vWUxKTjBUZlBE?=
 =?utf-8?B?eXBOSUZURnZxYmc1YmpydElwNnhLSDdONEM0cHlsU2FMdFVZS0tySWRDVWFr?=
 =?utf-8?B?Z1NzRTJuTVNDQ0xWZ0JSbkR4WXNmSmcxQnFCUFJYWlAvV0dXRFdHK3FJTjNO?=
 =?utf-8?B?VGM0L2hpb296VzZxSmhody9WU0FuakY1Z1gzcFR1WGg0a054aDN0aXI2VVZV?=
 =?utf-8?B?TGZmQ3E5REkzdXdIRVRxMDBiU05NeG9nNVNmT3A3b2lvR3M5T3k0ekNZcVZM?=
 =?utf-8?B?SU1oQjlQN2FsNDdoUS9qQjJsUW9QRXlEVWJ0c1Bsby9LSjRUN29Ka0YyUi9C?=
 =?utf-8?B?bnY3NW9IYlZ5ZFg5eHM2Q2Voalg4MWh6VGE2YVV6U1AxNUZwRTE1VVFsbEZN?=
 =?utf-8?B?UzYvMDBQY3BEWExRYjZDVjl3ZkJNNnhZdXVhL0V5YWxPR3Y3aEVVcmJ4bFRI?=
 =?utf-8?B?SnZDY1lHeVFqenBZOXo4eHRVL1lldnVWOEJpRmUrdG9hbGZ2OVpmcGpxZVFz?=
 =?utf-8?B?WmpKV2NsYWttQVVjZmJxendDVVhTdVdBaXc4SmdHM1JPUllBRUkvV0pSL0lF?=
 =?utf-8?B?Z1ZDcTExUWdBSlFmcEtidEFXWENETTJZb3EwaS9qU0k5NTlLeG1Wa2ErZi91?=
 =?utf-8?B?MDdCcGtSeGpSTHlOcnNlc2pWWFVlTkhqUERNcHJTV3lVM1NqODlKTGZkRWtr?=
 =?utf-8?B?OG5Ccit2KzV2UDc1VjY4VjROZ1ErcEZ1TmtRb1AzdVF0dWpadlpPaHdSZGs5?=
 =?utf-8?B?TWJIYytYbzVSNHgvU2NMRDVhM0h1dHNZbi9KcENQNCt5bHlQaVY1UFhEeVA1?=
 =?utf-8?B?UzQ5akVyN2xObjNRVXplZXY3YVBsRlZXcExKbXpqUGN6N2sxM08zOWRNTE4y?=
 =?utf-8?B?UHNFK1ZKMTJZaUNpWXFVWk5iR2dnTFVGeUR6NklyVGVNdk53blpPQ0Rubi93?=
 =?utf-8?B?SE5ldThXWjl3aVA2S2lsa2FEU3ZtNDJOaUtzY3ZZZmdXaW5ZZ255Z1h2cDdS?=
 =?utf-8?B?MlBoc0Uwd3E3a1BhdFYwWGU1NmV2NzFkc0VKSUdJNFlQbjdzZUZ3NjRvZFRL?=
 =?utf-8?B?L3pNSW5ZVCtIeGFMOEZib2o3Mk8vQXVPdVBjVmFiYXNOTXNEVlZ6OStCUGJi?=
 =?utf-8?B?NGJBdzhaQ0owUEl5amFaSEthNHlkcGpFTDFjYkxHNWMwU0MyNGx4MVBoa290?=
 =?utf-8?B?dUtRaDYyTHo0N0FDc3VJdjRwVWE0L2RrbkwzZVZwSHFmY3l6aEtmWE9CWFgv?=
 =?utf-8?B?UWlMRDFZaGVJWE1qV1pDem1iLzhNWnErTkxOWWh1NTBvQUx3am9aTW1tTXdw?=
 =?utf-8?B?SzRUS2krbk1Pcnk2cjdOcEVITVZYNDBIT3EySjViUlBUZEl3QVZTSXY2Y0lI?=
 =?utf-8?B?R3ZkTjYvLzVOZjNGcm5kd2U0aVpKRDcyZDZha0FWK01vYkZGaWRnN0J0dTl0?=
 =?utf-8?B?TnJaeXp1d0ZiNUYzK2d1M2tnWGJmTGoyQkJxMEFUZlRwYVhaSUxTZVUvd3FW?=
 =?utf-8?B?eXEwOGRnbWtDbTdYWVNjL1JicXFoYWxVMUNoTmtabDBHa1VnSUd1Z2N3UWZ6?=
 =?utf-8?Q?Qlm/SEEd4cG7BrG0=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e61065-ae94-4655-88b0-08de4de5d108
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 12:10:58.4635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbdM9oQo8Z8u24iZVkb065zsThVBxtRZkJ+cxyqjHnVhR4wI2VXU6A5dVLhMlz6cDyqB3ZXcr/MnZ9ibeRY7++FaojIEn1ewvQXrGJlV8J8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR03MB8000
X-Rspamd-Server: rspam02
X-Stat-Signature: t7u4xdepfnmpeqc973tbbm5xmighytrc
X-Rspam-User: 
X-Rspamd-Queue-Id: 171A840002
X-HE-Tag: 1767787861-905767
X-HE-Meta: U2FsdGVkX1/9vr+KWlOyY1aIwTRqOm9otDbb2U0r6IOjm1MIFYqYpVW/7Ug2hL6w+uKWL9tDhjkcxXdw4YshqZ4IJbgOPjndK9ke8vw2Ggp6FRRtsol+MfbXa5ywC4i6opeiwMFiKmwrLVCquzEIxbKXJTTV6GBJgITbJJ1zrn7A5ELfVb7JFV47zR81JqD8k8za/aqaw4F6WDRgp2rDrjU7RZNz+H7Lm3t0qf/GTN4RQEmJnrnRZStLJ95gIwEsDiIOCirnuapzYBlFzZP51pJi/38dXCNEQoILvY/R5/8sX9zYwTYXh5Bex+sYGnB8pkaILUK8E2dguQE4Qwf2mGp3njJILhv8AJRyq5mxfgvHeJ+nuq0Xa8becUmWf153Ll/tygwLTOUltlqTmu7d7s+VRqZ+61x9DijzH64M8h0j9vd87DHBPIWHr76Kl8cdfwe2Oj115Z4qy/7WrfmISOg/t1i9B3q/Tet9MfbLfjSexwXS1aMMMw974YwGeEehQ1zvSjNriTnS+KT3KpmWefLzEqYbxVtPhfeBOdMnPq+Y8Z/2WZAVkF3Xtry6yMI976BgQV9KCu+EES4A+jBu3T5ugreRGsDu5J7SwjPZ6g5EsRtZO62/kLtvjsZRxg4Uk81V8lNmp6nqZK/A27ptWLRaKuzhlGWZqInQ6r+dpkcSbpGfmn50aqsvHfbmAF1armjRwSRY44sEjL2PZbVmcBgp+B7EDBgldOcY//H2vwyK9oAw1QJUjIRQufaHt1AUgxakUofT/MlImQW/zcWsNA85e5iBxWfesfhlwNIbGqbctHWkbhregm4JgJHwbOi/CbLDb/pW5oJnL5va455rOwEXjRoB83hRWBceJD4x8AgDvkyqhhnazfLhyfKVAlhhl3XX32B18lqv3/cyxYIkd8DI+K2q96qkMpDklcukUdQMW7LdYk8OwfAKcuQ5u78qiOrmUKsW7CA0h+0dx4B
 wWqFBMr0
 MOEqYxyTDCpGmVCx0NACkqWoz2XggQWtDsdGLZr4H8CXIiHXbT11kBQRrbcA22zOKUNWEI3j8+f+0fcb3upoY3ki68SqOHIctOyg314m5MW+OTpziHrAluoljb3o0WmdYo5YnWW61b+2jCZklIwbrt/tIdr3H759gkqhc6orw1snmcpQXmGySORbfU/znbMizyRXLmGNeTuW++letExcep1WSDyIKQbPSZKYFODxW+FuTAjychWHKEKReUpJCDutnL/+eG+9ZTYLZe5BhpKx5wQNhu72FahNaRizmLsq12JEQk7HX3n/rjLENlLKDXcAZU+nBMPFL/KwB4XkrKq+wJBl67+Jclyj7zukJNtR/a2l/H2g621mLmFkXzkX8xf7hHfNapW16TQEn2gapYbDoU/RP6ouhdSQ7Rk++2AhXcI0lVy8UaOND+59RCBYniJqDG6EN2fqVDzQIVzt4Y1Q9kSw6pnEmCX2Xq7PklOEMYx2TzaVuyVxLflHXOw65SMkvGieYYf27QJBEk9SFxuyIG7ehW1FL36KIh99Kf8F4z/WyGDrE3FNPWuRLshhwyyFTk4HrViUibi0za/SvOme/QBcSJtbmNS2p357KGyn1IQfI7teOa/tr0Agij9eyamw7HjZNAOoTi9GBzeTo9pv2nurUF4eBXQa75viN+ELmxjyJeDg6DoL1/793yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/2026 9:18 pm, H. Peter Anvin wrote:
> Currently the vdso doesn't include .note.gnu.property or a GNU noexec
> stack annotation (the -z noexecstack in the linker script is
> ineffective because we specify PHDRs explicitly.)
>
> The motivation is that the dynamic linker currently do not check
> these.
>
> However, this is a weak excuse: the vdso*.so are also supposed to be
> usable at link libraries, and there is no reason why the dynamic
> linker might not want or need to check these in the future, so add
> them back in -- it is trivial enough.
>
> Use symbolic constants for the PHDR permission flags.
>
> [ v4: drop unrelated formatting changes ]
> [ v4.1: drop one last bogus formatting change (Brian Gerst) ]
>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>

The v4/v4.1 notes will presumably want dropping before committing?

