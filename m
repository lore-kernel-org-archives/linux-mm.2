Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD0FC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 16:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813246B007B; Tue, 29 Jul 2025 12:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4406B0088; Tue, 29 Jul 2025 12:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664D96B0089; Tue, 29 Jul 2025 12:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 54A766B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:27:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0C4CC017F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:27:09 +0000 (UTC)
X-FDA: 83717831778.06.D58D0BA
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010014.outbound.protection.outlook.com [52.101.84.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id 23A391C0006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:27:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="BDpWc/cH";
	dkim=pass header.d=arm.com header.s=selector1 header.b="BDpWc/cH";
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.14 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753806426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olpMFDwASacEEZQNbrMULSQ+6ICftdmhbLe2zdZtGrI=;
	b=pYAR5Ui6GTrUzoP6WnrZU1b+DH+jUqHhnCvsvuGxfm2C13dOafOywQSpm2pJqVa3brsik+
	t0VueAFXZDrI8F8ST4fuYRSj39Eoh7hfq9Wr8+tjUwupQfqmyneH0KL2fyJoI0NTOp0LQz
	2pDUvmtAoE5izG0Hjm4s0dIbMSVphQM=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1753806426; a=rsa-sha256;
	cv=pass;
	b=MaUtsQN5nhWLbcjsewIU+HL38GM/djNkSkUVKwKFUrAeV0aIdzrtkZQR5b8ScjRTAxKePj
	gyejjkiYTKvz+mPKKR6MskbXiJ+afb+uKehhSBcHCDFhmaKanq+CwaYNTe72utsxjYQUjh
	pQjZAR0s9NVsE9wTLzNMQXaJGYsDSd8=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="BDpWc/cH";
	dkim=pass header.d=arm.com header.s=selector1 header.b="BDpWc/cH";
	spf=pass (imf20.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.84.14 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Y9GZAptSWYiILsww5VJA4+JXOLMitV1KsDN9UuccmGitxuEo73OrfgHqPNWGpTq0H/8GDjaY0ShDONbYaByo/inXrRjHc8Hkz8ah+tPHYfJAxfhd1Z+eUEyh2G4ait9lbw2ysKBL985Jig1u+ll3D52Ldv4XQOFzapAoC++C0GOfIs8hH3XcbXlZ3mDnGWKgfeIzhmaT/OlyME8xhEoTXOPsDYQkj5Df4H/qAP5kf1AQJEioeoO2Jf7P85WlOtPr8/XFarGRmdaRNGTiK51+i4WsERzAX5j1Ywe45X0GRQC7FCzQc2caywIGJMOyGbaZx4JeKG44tKjm0tMJk6IjJw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olpMFDwASacEEZQNbrMULSQ+6ICftdmhbLe2zdZtGrI=;
 b=M0lWQzccmevSY9zVzAA4IHsQK3PPqQbvNzgKeqTeSVjHMTYmUnQ2VDFx5V5DZ75RYPnnnl/sVRRz+hEzvCxcD5hN+bMOhbNpeeg+x9EDT1/NoilZSz0nfy4XNdWajkxW+vKrlCgU2qOlVI7nyH0NznmDlg5IhvUbmL2XwR6Gng2ZapL0zO6OSiyhtKG8HzRV7wkwHLOWaxXzcqdt6KWu8Q0/ZoLU5lWWi/iKFhSthA8mVxroLtTWRReLZfbOoa36SgMj8e9CYU1Xmt3qBORo5jZ17kKjEHOCHuMcFKCjYrKLMnXptj6uXVK20YSzysJP/yRn+M9zkYZj9TR3wOpJlw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olpMFDwASacEEZQNbrMULSQ+6ICftdmhbLe2zdZtGrI=;
 b=BDpWc/cHW98l8Mg4P/JqJ+tmK5rjAk4BnU8fh9USOj0xn/w61D/4T9r5DKIBUzW7uzhCrO59sCxs5nTCWu05GBF70D0bIEkxxE9Ccui6guHHjKzIaXXrR9EXhjci7h5AFiCJGy2oM5LI75ZLxlCFvHsC9nEiMVvDf5wivV36Cac=
Received: from PAZP264CA0107.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fb::17)
 by GV1PR08MB7876.eurprd08.prod.outlook.com (2603:10a6:150:5f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 16:26:58 +0000
Received: from AMS0EPF00000191.eurprd05.prod.outlook.com
 (2603:10a6:102:1fb:cafe::ae) by PAZP264CA0107.outlook.office365.com
 (2603:10a6:102:1fb::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.11 via Frontend Transport; Tue,
 29 Jul 2025 16:26:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000191.mail.protection.outlook.com (10.167.16.216) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.10
 via Frontend Transport; Tue, 29 Jul 2025 16:26:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yech/EADq+S2I8H2Eb5r/oWx0HMDeF03MbsZiDEOf9iCfcMuL2zqpO7xE7bhRtbOQaeuJXPNke7ARSIJXe6GpM2q8tH2RS0hGGcMZg4Ttquef37NA16IQaOPi5XLQ9AkkKfTcIcz3oREvGeNN8a1tOCx5gLxDzmXMhXAFFVuJCEsppStVJ+jV4dkYEAuT0KzqV4zWSxq1dLhtzFk4WRC9g8e8N5wCyjMDbBjF2CEhpx0jLYyMiYp7wzRVNsv8MFi8ekejHUqpI4NhsBHhSePpMJsOpNw5/+PYow2sVQ0lSMrP7yFCB0A1Z+vosE5A+t5dms02WZKOByMJkIoZSr00g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olpMFDwASacEEZQNbrMULSQ+6ICftdmhbLe2zdZtGrI=;
 b=fQpRJWnEDlOZArGUKWk2XnNyclD5lPLG1CxlEU63sFwXwAGgau002yiXopNZ2YWfXHMvip7cZnA+T6TdzLHO44AE3cHvNHRYGoH9ZFHPkHX+j40Vh+0iY0baLOfvmvHZGvCht0Pbi4TCqZPtGN73Szxfci2Yo/s95SWEQuR3i+Umn0IPixi1Ocp/7pQ0badt43bc7gzbRIbvwf45nj9/Lw/HQ38f1oQPDqsZ2KpLfs/gz1NfDwUG3JrzhM3hmD/klMAiA5mDv2TLi8YsGHkIGfSA7W9AMMQU82bEWTudNzl4qnfW1E7HoYiFOQHyx9X9/rX7GHYqU6GO6/qLOCHezw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olpMFDwASacEEZQNbrMULSQ+6ICftdmhbLe2zdZtGrI=;
 b=BDpWc/cHW98l8Mg4P/JqJ+tmK5rjAk4BnU8fh9USOj0xn/w61D/4T9r5DKIBUzW7uzhCrO59sCxs5nTCWu05GBF70D0bIEkxxE9Ccui6guHHjKzIaXXrR9EXhjci7h5AFiCJGy2oM5LI75ZLxlCFvHsC9nEiMVvDf5wivV36Cac=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by VE1PR08MB5823.eurprd08.prod.outlook.com (2603:10a6:800:1a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 16:26:23 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 16:26:22 +0000
Message-ID: <f5efa19f-7eb9-4ffd-aa12-6aae19379cf8@arm.com>
Date: Tue, 29 Jul 2025 21:56:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: vmalloc: use VMALLOC_EARLY_START boundary for early
 vmap area
To: Justin He <Justin.He@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
 Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: Anshuman Khandual <Anshuman.Khandual@arm.com>,
 Ryan Roberts <Ryan.Roberts@arm.com>, Peter Xu <peterx@redhat.com>,
 Joey Gouly <Joey.Gouly@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20250722040850.2017769-1-justin.he@arm.com>
 <c185e160-1b82-41f6-832d-cef3938a1a9f@arm.com>
 <AS2PR08MB97864CC7022A8DB7BDB87952F75AA@AS2PR08MB9786.eurprd08.prod.outlook.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <AS2PR08MB97864CC7022A8DB7BDB87952F75AA@AS2PR08MB9786.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::16) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|VE1PR08MB5823:EE_|AMS0EPF00000191:EE_|GV1PR08MB7876:EE_
X-MS-Office365-Filtering-Correlation-Id: 498f2135-588e-45fc-4bc2-08ddcebcbc8d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Y3dqTjZUQ3JsMUhmZlZOSnFocVJJQlY1TGh3ektWWmswTlllVVUzRFJPSnZ5?=
 =?utf-8?B?VHN4L09WVTdhVWZ2UDB2a2FjQU1HbFRTZ3NyVFNuNWtOUHVWVzF5c2ZGeEZo?=
 =?utf-8?B?T2gwYjdERE1ycnhSbktQcVp2MEcrOFdxWEpUUEg2YU9mMUpNd2dLdXFRNVNq?=
 =?utf-8?B?OTRkMkdSaWdlRG1jUVJVdmpsNGNjdE51YWluZGNUd0xoNnVrZEFoVHFEcXVx?=
 =?utf-8?B?ejdjMXdNNGF5OEQ5YVBDQ05wUjlVUlZiMVEvOGRweURCdE1QZitzSW1ISi9a?=
 =?utf-8?B?WTNPWGRvMUZqdjZkV2l5OVpQYXZnRnBpOTl3YXlSaStHUWRXYVpHNmFlU2dX?=
 =?utf-8?B?MkpZM2dwK1dHRkhRbVcyRnE1YXd1TTNpL2JwU29KaTgrSi9lZEx6SVFKMzIw?=
 =?utf-8?B?cUttNmVGQ0VmeEtPbzRNK2hjNVdKN2pObS9TUlRMWmtDVXluRWhRTHpLRVBG?=
 =?utf-8?B?emM1VmYyem9zNDRWYXdqM0dTbHI1USt5ZHpzZEduVFczS0kwL09rRkYrTkhT?=
 =?utf-8?B?RERwZS9QMzFPckplMzdHYmFOZDZRdzcwUGpmZ05qc1lnQ09kc29XL3J6NzFF?=
 =?utf-8?B?K2tNdzZaWHlGc1hsblBCd1haejhhbUZLV2xrS2Zsd1RRaHZkNlRlSU1WSE5y?=
 =?utf-8?B?NElvV0ZlWFBtNDJ1b3graGpvVFlXdk13Si9pUENId1RVZmlUMmJaQnovemFG?=
 =?utf-8?B?ZUErVFBCdUpvUGdackxOTzRERG1tMlk4WjNRM0pnWFNvcGJTVlNOQzVwU01t?=
 =?utf-8?B?d3dBaEREQ3JjVno3bUpiQmwzMDAwWW9VdnZoYlFURkRvTTNQRG4yT1Izb3kr?=
 =?utf-8?B?UldyejNxeVY2RjZ1NGJlVnkyUkpKVW1KWXRjcFVtd3cvek1GUkZlMXl4NW9D?=
 =?utf-8?B?WG1UUTRhY1lleWN5UFJSVzFjck1KQ0o1blR2YVhoek4xVHlkY0FSTjVIWTV1?=
 =?utf-8?B?cGU3V1RVSG9mTEJLY0pkZXZvTmZDaUdjOXVGWFpJdUU0S2FuNThhL1h3aExJ?=
 =?utf-8?B?Z3JEMTFLK1ZMNURuT0lUbms1V2dEQzQwbUlrVlZVRi9LS1FoUWtoOWNRRGFp?=
 =?utf-8?B?R2RsVjN2VlVnSDFrZGl6ZU5UL09Vbmswb2M2UTRIRFA1c1lMaGR2WkxELzl3?=
 =?utf-8?B?NCtDd09HdjRINi9FM01sYnZsTC9TYjJuUis5UWwrZDB3alJZL0traUR2aVZi?=
 =?utf-8?B?TUVlRmwrcmphVks2ckdwdDlEaEtnbUhxWWpKNHRMTElQdFViaEVTZHFzOWlZ?=
 =?utf-8?B?S2h4VXVxdW4xK0F5Q3dNSSt3UXlZVFU1TVEwbVYwSExITWJmekRJMkZNSFBz?=
 =?utf-8?B?QzZUZklwRVkvMXVHUmZjcGVaWENQbytoSGFBRS9BbGxMaCsyN24zRGxBMDlI?=
 =?utf-8?B?VytIanhDamo0UVNWaEFRdGY2d08vTC8xdEcvcjY0TGFJUGdXUkhNemRhT3Uy?=
 =?utf-8?B?ZE9BYVJVRlY2K0p4OHFmcVdFSm50NVJzNXlrbnlSY3JySGJYdk9ZK0Yxcys1?=
 =?utf-8?B?UzUzcUhWdDdsWVFXUGxlSTNHeVJYSklEaHVDajBmZ2QzY1dSMVdGUGZydXg1?=
 =?utf-8?B?eE1hOFBienNzOVVnM3VVZjAzd1hRMitXbndNWFEzWGZxVys1OU9VMVJmOW9H?=
 =?utf-8?B?Z2JvK2tyV3YxcjhqQmVJTmpMMVhtUlo5RHprV0JTU1VIa00wMXl6MHdjVkMr?=
 =?utf-8?B?c0dSL3FGb25iK1RJSmlhWDBwRnQzeEUvUzFDMjg1SjdvTHNNUU8yYUpOY2pk?=
 =?utf-8?B?eG9sSzdpbWJOYXN2bnR5dDhHVFRPVWRvdWtXdXlUUGwwLy9KaU9CcCtXN0VP?=
 =?utf-8?B?VEc1UEVlTi9ISG16SzZCUUZSZWtWZFB1dVhKQVVWaDMrb3dFanFJejcwR0RQ?=
 =?utf-8?B?Sk8vZjR0Tnoxc1MvZldza0puSWY3MUx1WktjdHgrUitNdGdMeWpCM1pMMi9L?=
 =?utf-8?Q?10R5aDt4LLM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5823
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	cbe51d6e-c3fb-4539-0cb5-08ddcebca7c4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|14060799003|376014|35042699022|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFUybytRdFk1UWdxeE9XMFZJRzJGQkpkaS9HWW1ReEJlWm53ajdPVmRmelVS?=
 =?utf-8?B?SUc1dlN0b2sxKzZtUWlKQ3ZTd2VWWC9scDhJRFhYMGJjdEs4VVc5VlBGSVBI?=
 =?utf-8?B?TlJHOFFHUFllZG90TCswTThsb3UwY3k3blk3bVlZVWFRZXZMS1AvOGFCZ3VD?=
 =?utf-8?B?TmtnTlZqeUtjQmh4RXcrb0hRYUg4UlQ5ZGZucXhzV3U4UG1lc0N1VkNDa092?=
 =?utf-8?B?MEZDaUYzQnVycWdkM3paa29rS0tqUllKV0w2U09UaDZORUY1dXVUTEJUWHJG?=
 =?utf-8?B?VGVJQUtlNUtpL2UvN2N5SGpDZG52RVU0b2ppdTlsUXpYZUNsZ0RuRXY4dWg1?=
 =?utf-8?B?aHJIRkF3YTVkczQ2NWZPWkdjRWtWSnFxc0htTkVIQWtuWUk4MUx3T3JsOU00?=
 =?utf-8?B?UkhNd2Y2c2txaURDSzZGSnFabGVVM1dPM2hSSXdUZmZuZHR2MmdVQWI1ak5s?=
 =?utf-8?B?Z2NKaXFjUFQ1RG94S0NMaHpxaDNvZHlKaUUxdC9rYzB5dUtlTzJ0ZnpZMGlu?=
 =?utf-8?B?S0M3V09vdVFRYzBXMWxPdXNJa1MxSENtQVdxeDhnUGFya2hXSWtDcEtJNktp?=
 =?utf-8?B?eUlPSDVKeVhhUDVqY2dsYm5pUWM2ZlV5NnFTSmEvdWRMT0FGbHlvS2w4aHV4?=
 =?utf-8?B?SHRMYlE3UU1GKzdmR2pzdzZyMWdSWjVlU0VCRkJIRmpNQXppb1dyNGhXenEz?=
 =?utf-8?B?MHZBUVUzZ0xUUFlYYzdkcWdyOVRPOWZ2RnBKZGo4Z1cxeGg2SGFoazd6MG1D?=
 =?utf-8?B?TkRUSFB3RFJhWGxFNUhBTVBVdklsVkNxZlhhTmxXSnVLcWk3TXhEemZnS2s2?=
 =?utf-8?B?SjZUOXd0RFh4YVVudE9KNTR6R0hHZE9RSzBOK0ZFZy81dlpGQksvT3VGRVho?=
 =?utf-8?B?NWE1Y0FwQW5JNTlTUmJ2RlljMlZuNGloY1ZVYlJuMStBdlllaWMxNjlUODk4?=
 =?utf-8?B?WHFWc1IxTTVVQ3lXRWtwM2pPR1d2cDdCSXNTT2xpc3FTRllFNmRsbkNPTy9B?=
 =?utf-8?B?SEZNZ3NnMVJmYlgrYUlaTytCa1J0eWtmWDVwVGU2QjNpV2tqOGVOL0ppVnBS?=
 =?utf-8?B?Y1VIalQ0T1FzamRla0tRTUpkZFM5emxiMjlTRVF4QjFiZkxLT0F0NGxXdEZW?=
 =?utf-8?B?RFlicmZtMFI2czhHV2pjd09RczZIQU10ZHVQWGczNHVtdHhVeFRrOXgydkY2?=
 =?utf-8?B?WVNGWkhWMGRmY2FFYjFLWFZSWG5DeWZQbWZ0UkxXampuNVhQTnE2Y00zODA5?=
 =?utf-8?B?ZkU5WmFlWE14TnlPMElYQXhLTldHTWM5dmxWOTBXZXljeUdNVUJvUGtUWml5?=
 =?utf-8?B?c3FoZ3ByeGJRUWdIMi9HVHI0NkZHYlllZTVIdEdKeXN4S2FGOTRGcHd6YjUy?=
 =?utf-8?B?S1VObktHall0NHlHckp3OTVFYThQU1E3eXRZR05BNkUvQ3FoRys2bzV2Zi9W?=
 =?utf-8?B?MFp3VjNNZGtCaVVUd1pqUFB0UkZBRmpxbm1Edk9GdU1yNGE5dFJ5NXF0Ymow?=
 =?utf-8?B?dlZ2NFZUL0JFVWQzcm1ybXpyNUZlVDY4WkxSeUlVQkRBSEpSZUNGMndCbk9L?=
 =?utf-8?B?UWxjbUJ5ZFlnd1JOQ3RvMXpkM2grdy8xUldKTmlzcXo4MTRNUVNySUt0WFZW?=
 =?utf-8?B?eHJiR0JMR2hkcFN0VVprMW9oWnMwKzF3d1dVdlpFR2hoRGJvN1ZIbm03V3FS?=
 =?utf-8?B?Sy9rU3krSUxEVlNLaTNhY2JPcVY5UGFmaVFoVXVjcjY5eUJ4cjFDVUk5YkRC?=
 =?utf-8?B?UVQ1UUhsSE9IbG1Oci90Y1B1cnA0Rm1ORHVBa2J6QVRpaHMxN3htTjhIV0Rm?=
 =?utf-8?B?T1QwdkxmN0prbzNTNnliRm12bktkNFFyanM3c2pZRVZsWU9DRG1jeU5YWUg1?=
 =?utf-8?B?QWMwS0lYYUNIcXIyYUFjRGVzL1VXV0sxZmtlVlR3WWpzSjNDNi8wWm5COTFj?=
 =?utf-8?B?WmFMU0dhdHBJaExoeERsVU1oWUdtVUcwMTBtTnBjOFFlUXhGdlRwbGxYNFcz?=
 =?utf-8?B?a0VWc0N0cUZsNlVVMyttd3VBSkcvampQSG9VQjNDcy9uQlJzYkpHU3dLS1ZF?=
 =?utf-8?Q?4nyo7P?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(14060799003)(376014)(35042699022)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 16:26:56.8058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 498f2135-588e-45fc-4bc2-08ddcebcbc8d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7876
X-Rspamd-Queue-Id: 23A391C0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: t89739wcfaiw4kp9xn7pknqghe971s4q
X-HE-Tag: 1753806425-531855
X-HE-Meta: U2FsdGVkX1+Wjcd9PeiNiL0pLW7zikzU0yS0ySL/jJvxfSK3tNAwrz18xD4pYo4VqJIYeo1YN7Rc4HaKltDTlM8AgKSyjmOyZaKp3Z8RM8IDardE9xZwmwxNOmNe4MrmM1wKlaB/PI+DJTrmAcjgenrVogCCtfCzpTTieAM2mgT+wdZ5Fq0p7S8dYYpD19BhsP8sZIJpTHkMJaADp1y54S6vvYwPGUwKlPzcER6czpYJmbeDEw67EpPxCWMTn1/5AEPXKW5gdBQAXJUktmwNWWiC76QQUa6oWikUWME7yN6iZyHcfmtRpFiNUYo0r8pO7TMMBSwdRA+LX7ud4QZosKQV4HmAViqeMRewBDMqtYJ+auWIhkxQv2SNF+xnUXIianCwH+akdQFNBIiJfOEW2axvbZAvZQUt0zIS3wKKY7WP0HTbhYJEYjhuYI8XUozQF1UiuSjPmhwoBO2cdMO8OGLJHtsG9Pa2NbgFQ971OIDoqFupuK8h6IehrtiPzpnrQiI2DBlmSUmGsDTghRp8gQfyd1agH9h8KN6HuZpJuMRipTJc0F5TkG1F5K6UtSfd1fo9C0Wu6W7uk7XAqOUMMJ1GSZvbDJ3ZGswWXGlQU0It6jkfN2gFwQyrRpBOP95HZuwCxfdsPNClHXm5VHM9rOT2TCIyKa/oaaaY6Mv2mBJcg4TnFWVeiIS4VN6gw145ucS9V354lX5vUSZwahPEpP8uQBZRPpwCZlLN0elRi9AZJ4o8LVweQ32wnKYvWqaIACeNfikiNS8pmdlPMFOgq2X5IeWvJgNhe6YuEUmT+DJJA/gbTa0iwXiLUxtBRGjLDppaQvFIP7MOC22KTwvOQMYo+5g7I4kENLQVNHFIc6MmDPtwcobd+aoJCCZttEt7c66MyxXQOKjr9JunPXVMocBigI4EjInqhHC/gWrGphvBUC9A1m+9WOZyglymF5g5qwwX26xT6GmVNiU9OZU
 l7vgdbdU
 yNNzzY2lMhT875AnqORlo6Ek+rUxuWW5TdMKddTfZf4DMOhGKm1HoW0JIA6nNiIaNvcovIa4x36VosGbOrk6MasNxyvk0gvY/8pPiZKB0CHob5LJsAKhNKYW+uO+lmtq3zywL2PR+IMmL/YUExsV6+Q1ngN5Ygt/mQQ97XJmgEBGXguD44oKytNkcT4EYRTTS2IfU6QrGhkwxCJXd3tbZhIgZQwvbugfhSPg0uJb/manh5sgH9AhzbvEB7YW8rh7e8Bs9UqFqudQVNCQGx0Hex23wzwNmXm02JjlfFDLS5xKmZpb020KgpVady5LDkSvu6RMf8EItQUmzbbft2UrbvtF1WR4tg8wyWSvPUqouk79ovgfk4rINxujij5yG9yiaIs9JtIbUeMoshCuIlnQLJInJjuJ0k204ap5EvFMRnJBhOPGhO2mgqkwEL0kVhJdLFQhQR80rGunzFUm6IN15D6/kuZDd1JY1T3pclTHbVQNVDuiasQPcHwxHBv+hFzLPSiQdcCq574YDU2GJm3jjQHGV01g73WhXSWjO7rfouViVxYHjg/BfyA1spo3y0WWc2RIy9gkntGc+877081voOS6806WWC1kIOqc2Y9MNlkJUfyuj8yz73DbburroLZA4NVUpq02Q40JKIUREDoPKCH/cSiovn66JL5UeKDuvgs01jxfMi+aYo/Njcnp5f1vWVHLg2VlO1+JWe85N9t8FIeBp7da2jUTgkVSWuXSd0vFDlj89O3mMmKMrAb5UNbPNvFDuWsNTU9hbzeuzdOZRrGdVdJNTBhRHPo9f98ZK3Pu8V1gySNz2m5zA9Pkhnf/Z2765lelQ5a+dM+gH2laTJyLiDUpILEtbPi+OlD7Y4HdR8n6nyNhVWeHjzuDmenFx5/XlSRsra7VZI+uRciBUieR7cvj8tkbZvTKqynq8dfI1P6VEJexMp4rcxQQkQwKouUZAA6t0NpL4FfXRrImDm+QMwxIO
 KkWvICER
 +w24I0J5AJA2dTk9fEBuGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 28/07/25 11:49 am, Justin He wrote:
> Hi Dev,
>
>> -----Original Message-----
>> From: Dev Jain <Dev.Jain@arm.com>
>> Sent: Tuesday, July 22, 2025 2:48 PM
>> To: Justin He <Justin.He@arm.com>; Catalin Marinas
>> <Catalin.Marinas@arm.com>; Will Deacon <will@kernel.org>; Andrew
>> Morton <akpm@linux-foundation.org>; Uladzislau Rezki <urezki@gmail.com>
>> Cc: Anshuman Khandual <Anshuman.Khandual@arm.com>; Ryan Roberts
>> <Ryan.Roberts@arm.com>; Peter Xu <peterx@redhat.com>; Joey Gouly
>> <Joey.Gouly@arm.com>; Yicong Yang <yangyicong@hisilicon.com>; Matthew
>> Wilcox (Oracle) <willy@infradead.org>; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; linux-mm@kvack.org
>> Subject: Re: [PATCH] mm: vmalloc: use VMALLOC_EARLY_START boundary for
>> early vmap area
>>
>>
>> On 22/07/25 9:38 am, Jia He wrote:
>>> When VMALLOC_START is redefined to a new boundary, most subsystems
>>> continue to function correctly. However, vm_area_register_early()
>>> assumes the use of the global _vmlist_ structure before vmalloc_init()
>>> is invoked. This assumption can lead to issues during early boot.
>>>
>>> See the calltrace as follows:
>>> 	start_kernel()
>>> 		setup_per_cpu_areas()
>>> 			pcpu_page_first_chunk()
>>> 				vm_area_register_early()
>>> 		mm_core_init()
>>> 			vmalloc_init()
>>>
>>> The early vm areas will be added to vmlist at declare_kernel_vmas()
>>> ->declare_vma():
>>> ffff800080010000 T _stext
>>> ffff800080da0000 D __start_rodata
>>> ffff800081890000 T __inittext_begin
>>> ffff800081980000 D __initdata_begin
>>> ffff800081ee0000 D _data
>>> The starting address of the early areas is tied to the *old*
>>> VMALLOC_START (i.e. 0xffff800080000000 on an arm64 N2 server).
>>>
>>> If VMALLOC_START is redefined, it can disrupt early VM area
>>> allocation, particularly in like pcpu_page_first_chunk()-
>>> vm_area_register_early().
>>>
>>> To address this potential risk on arm64, introduce a new boundary,
>>> VMALLOC_EARLY_START, to avoid boot issues when VMALLOC_START is
>>> occasionaly redefined.
>> Sorry but I am unable to understand the point of the patch. If a particular
>> value of VMALLOC_START causes a problem because the vma declarations of
>> the kernel are tied to that value, surely we should be reasoning about what
>> was wrong about the new value, and not circumventing the actual problem by
>> introducing VMALLOC_EARLY_START?
>>
>> Also by your patch description I don't think you have run into a reproducible
>> boot issue, so this patch is basically adding dead code because both macros
>> are defined to MODULES_END?
>>
> Please try this *debugging* purpose patch which can trigger the boot panic
> more easily(I can always reproduce the boot panic on an ARM64 server):
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>   index 192d86e1cc76..2be8db8d0205 100644
>   --- a/arch/arm64/include/asm/pgtable.h
>   +++ b/arch/arm64/include/asm/pgtable.h
>   @@ -20,7 +20,8 @@
>     * VMALLOC_START: beginning of the kernel vmalloc space
>     * VMALLOC_END: extends to the available space below vmemmap
>     */
>   -#define VMALLOC_START          (MODULES_END)
>   +//#define VMALLOC_START                (MODULES_END)
>   +#define VMALLOC_START          ((MODULES_END & PGDIR_MASK) + PGDIR_SIZE)
>    #if VA_BITS == VA_BITS_MIN
>    #define VMALLOC_END            (VMEMMAP_START - SZ_8M)
>    #else
>   diff --git a/mm/percpu.c b/mm/percpu.c
>   index b35494c8ede2..53d187172b5e 100644
>   --- a/mm/percpu.c
>   +++ b/mm/percpu.c
>   @@ -3051,7 +3051,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
>           max_distance += ai->unit_size * ai->groups[highest_group].nr_units;
>
>           /* warn if maximum distance is further than 75% of vmalloc space */
>   -       if (max_distance > VMALLOC_TOTAL * 3 / 4) {
>   +       if (1 || max_distance > VMALLOC_TOTAL * 3 / 4) {

This will always return true - which leads to returning -EINVAL and then
panicking in setup_per_cpu_areas(). Probably you made this change by mistake
and are trying to say that the redefinition above panics?

>                   pr_warn("max_distance=0x%lx too large for vmalloc space 0x%lx\n",
>                                   max_distance, VMALLOC_TOTAL);
>    #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
>
>
> ---
> Cheers,
> Justin He(Jia He)
>
>

