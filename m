Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6EDCD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 19:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046696B0088; Thu, 30 Apr 2026 15:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39536B008A; Thu, 30 Apr 2026 15:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E015D6B008C; Thu, 30 Apr 2026 15:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCB126B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:02:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7272F1C002D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:02:25 +0000 (UTC)
X-FDA: 84716143050.14.03226A9
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023103.outbound.protection.outlook.com [40.107.201.103])
	by imf17.hostedemail.com (Postfix) with ESMTP id 60E9D40005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:02:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=RGoOAv7a;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf17.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.103 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777575742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISDdxFSVTj+nrwTkpGgqvJcug2hdG/LGDXpZwmhC//4=;
	b=w8bF3pwwVb+s26IhVMIqgx+JwwTlnXmUmdKPE5QHXwMgcD1cw9s68FXnI8/kd0ZfeNO8N9
	qkPvxBOTwOc/MJZGq3e1DJ7VvaLWvXc1VzyVB56osOJzqsRWjpSD0J6IJYCXuyrZeMz6nr
	AaJmeRf46F8S5DPhilnlAuCqp2b7awQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777575742; a=rsa-sha256;
	cv=pass;
	b=ArsIoLxsUTBPNVvJEwnzpERDHvjvr+iqL6+8QmKLtVtstfLUYUJlhVzACaheY4kEd/U9X+
	Em+ID4M66kPNZsv5bmSGmhVhZKEbLAePExO+Pbp62E7KrNqns7Oxg0+jbZzysahhZtZCgM
	TVvCRBkY/xxU+O/4laN4nnN7jevspWw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=RGoOAv7a;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf17.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.201.103 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H1f8P/GKqXhgNtFBhSeSApfZ3f29fiNKbubgys0bSOi2xYSp/4IZKtkelYfUReJvhC9w4TCLOLECjdshOuoQd8Xi77l4VJpLIMraygCPnXX4tXtNac1ZEbz7fwEWhtMDYyUHxHa1dGevhtltlN1kKyA9Uyso6qMo8PAfy3fR0QCV1mcPyOB7xcMFOWrcdC4AljIOmchnojLYKABbnsg3LBwQtbp8l5mpVoZYii/1z0yGbc/dib0drB6ZaviyKoea4bBGpkJCMnYgx3zWSTIUPacALlrT9T579P8CZXuMWZhc0bam+YwhAXPxqVPzD1I6c1cCsiqv41RJm49O2wRRog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISDdxFSVTj+nrwTkpGgqvJcug2hdG/LGDXpZwmhC//4=;
 b=ZtZvFy4s0qbPIvMVw3gUoGQDgL21WZjv6YGT/ktUTxdRo0ExxuhFk0UqSOQIHK0/H6WUbQ9G6tj4cKB2U9LRKjJ4ObCiqS3UArM0mYo/PgdrE+GBGDrox3gixDWsbU/ZZScGyznbNfO+2XMCVgoXBKCt6w1/zrbIfcPJtoGnwVh6ifxkVJAgtFMgS7I1iYb8iBaxy6bUsTR/XE44YFqJHKE/2gu0Gle6HjyqOPBHTHyNOpeWHpPoLCqZkdO2HT9s1ecwqdSYuBoJb17baof5AJ0vmjXPYF/8zAdlf0Rhw0EcDLL2VnObJN5bYAt+bF8hZ3482Cj6Zsy/Qw5qB4SV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISDdxFSVTj+nrwTkpGgqvJcug2hdG/LGDXpZwmhC//4=;
 b=RGoOAv7ajhYYj/vL/tj0ZY60W7nN9iNaQerdfK5X237KtBEjx8UabuVFNA+Xy7CzjvEF0cYKGFKhzS1hJxKZ2yZSF87szSOBgJOYAv/kDYFJb+aywqcELHORf7R8LAa1jkM9JzDj8epvuXKsgrbpMIj+pZsPSM+RKysidbcoQWg=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 PH0PR01MB6312.prod.exchangelabs.com (2603:10b6:510:a::9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.20; Thu, 30 Apr 2026 19:02:16 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 19:02:16 +0000
Message-ID: <59860460-5592-42cc-9593-4780fb720e18@os.amperecomputing.com>
Date: Thu, 30 Apr 2026 12:02:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 PATCH 0/11] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: cl@gentwo.org, dennis@kernel.org, tj@kernel.org, urezki@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
 david@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::34) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|PH0PR01MB6312:EE_
X-MS-Office365-Filtering-Correlation-Id: e6afbabe-f6d5-4c64-de72-08dea6eafeca
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|22082099003|18002099003|55112099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	lCsS+uxTtmaChzcnvhSt8kZL1gCcfUO9bK56buIqHru2a/UIBmABzLV5CLhr/KQ1KyF5faI6azAnL6r/VCLWNuhehxyuWY3uYpZ4SWgj+EZQy8AaPz12S4JYwkmOzwxDLl1qFwAQ5MAcpHET03SGH62FD1HFbQWvrEJai0HI4i9rOA4REG4uK27xvPwy7PESAuz675BImX/dSHsuT7zNQpflqu8BOAmYxqWcBnGOwZACaS0/uXrPo5KNs27pjFRq132NDourOCqmtpWf4kg/P4ikXbHRAr1iQZvWCHClXvBMMgot3P33zVUp+V+AIC/O9fh/2RgM3ZgQNDpGTrl3uJKwcJe2lRXhir/NkKsCzzCbiOo51gctdQILeEAFCJLuM+PAwHemSHdHoskl9Bv1rzLfFssNsqv+OS8Hqst3BSLeIx9TOF/vwUN5HSHTvzbFHtVEquoeupQp4d8ioFu/2pehyTdtFCzTT5FuWDYt1U/7kb1ArIGbefKL3yXPo7YpIJh5kE8s0oSLkMfV82FaMzj5AVRNAXA68EIUL00VBS81Ufo69P1sSdU+j9ieO1vlXRWSo/MeLbtuD2oBhkYAXtReCOc0fQYtSarBGTWnHWqtggHsu7E4/D9gqrwdX+cwhYKM4kELZleDLM9SbgB/XpyGf3mIRv7Aov1jSMYtEnJJ7dXEecB2xq1Ayk+i0PU0q71nFQY0NEuK0JnZDzXWfHNBFWCJOrdNrP3GL+dPsgp/WvVWkrPO2s+hrgEiDSgS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(22082099003)(18002099003)(55112099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXNZWW95RyttaTNLWnNaZ080NEY3NWpKckRud0JTZ1oxempRdFk1RTUvbVFP?=
 =?utf-8?B?d2p1VE5Td2JIYzgyQUZTQmo0c09MdFhaTUI5MkQ5U0w5TWxtdE9vWkNrNnEy?=
 =?utf-8?B?Q0NyMzl0eXJDckpXTytFKzlrM0dvTEtOMGU4QUpSMjBsSm1yL3cyeHBxUFlm?=
 =?utf-8?B?MEY0aWhneTVLTUx0WE4vRWk5OGNicHN6SThPWVRNWWxtR2FUREtFdXRiTU9D?=
 =?utf-8?B?V1I4L1B1ZWVVenRaZU1ncEJvNCs4ZGNjTGxFU2dvejZsZ01sQzBBU2x3WnhL?=
 =?utf-8?B?UWJHMFcreVFHR1ZGNTVSSVh2YnE0d3g5YWNiZjNoT2NUc1BjYjJyWFc0SFBR?=
 =?utf-8?B?c0g1N1JPSkJEVy9GOTZQVXFnVkI2V1VETm1WaWViWVVBK3lBOVRlbVQ5Lzl6?=
 =?utf-8?B?THd3NFRJZDB5ekhRazk3eXQwMWdxYnJ5aitzQVVaUXlJait6RllROThJajB5?=
 =?utf-8?B?Y2k5YTNOSzUvS0Foam1qTmtZY1JPQUJSdWFSeDZVK01xYW1odE4yVVVtVWZJ?=
 =?utf-8?B?OGZad1ViRjMxbUhqcXU0b0hYK29DeVpKTERqNmFxWVlCdXZSSm93K3owT1lL?=
 =?utf-8?B?SDZ2d202Zno4dWpFQ3A1cVErWjFPSE9PaGdMZlYreWJjTkpKeXkwcGRYbTFR?=
 =?utf-8?B?cXQrcmo1VHNxcE45a3poVUd5T1JaZCsxSjhpaFg3LzRoSXAwbzZJWmh1clFu?=
 =?utf-8?B?bzJadG1ybkNsMkRuRGthRGozdE9nRG1ZcWZ5SHc4NUpnaFpFSEpVcXpEMzdR?=
 =?utf-8?B?TkJJTm5vMzhQM3hNd2dmbzhVbjFxUGpKRHFBazM3S0lqdnRzTkkybWhSdVhy?=
 =?utf-8?B?aHkvTFFadnl0S3ZGU2t1OEhyaHQ0NHpBVFBEc3FrLzBFeTRpdmVpY0l2MDM3?=
 =?utf-8?B?bGVsREhHVFZaNWpYYkxIOXFwbjBsMUJ3bzlSc1Q3aStPcXNMMXFFaUQ4VkpX?=
 =?utf-8?B?S2JKQ2Evd28rV3d3QVplZzhHQlM0WlFaZ0drSUVBVnBxOTZRQzlYbEFtcFVP?=
 =?utf-8?B?YXFCdDF6ekdremowczloL080bE1UY005MURFS01KQXMyanhiSThENlBWV0Nr?=
 =?utf-8?B?V05aaWhuRURXeGVoSzlKZHVBZE5vUG96aHVlYkZDR0cxY0FQSE00cTZpZFpm?=
 =?utf-8?B?WjVsWHVmZUJPVGVKcjdMVnRpbWovZEozQXpVMncrODk2Sk01TnkrdzVlVWpr?=
 =?utf-8?B?K3NiL0laK2EwdDJaN1BidlQ5QWRjTXRYVEVJV09YZzlyMG5USGptQ1NlR1o5?=
 =?utf-8?B?WkczUExyWGF4RDNiQzV6MVRERGRhdCtxc0JvbUlwRWVqQkk3SGRveHlrSGU0?=
 =?utf-8?B?dDEwVk9uYVRGNkl1Q2hKck1RSkttNHpkVGNMbzdYNExVYVpkSEdqTkdvSDAx?=
 =?utf-8?B?eXNiTXRud3c5TkFMMDVrTnNYWU45T0U5L3pYWDIyMTVsbDUvYytOMnVjeEdk?=
 =?utf-8?B?Sk8xMVNYR1RGUlk0YjhVN2VaODFCZEh3d0NDM3c1VjRuQmhNY1lyUmoveFAx?=
 =?utf-8?B?a2N2V25lREZFRzM1OUI3a2V6ZmdPVWQ2K1RBYk9hVmt1Y0pyaEsxMzFBaHNI?=
 =?utf-8?B?UTRmemE0MVUvZDFpclVRK1FBMkY5Q0xRZFROeTJ4MkZDdkxrSGEyM0t1eTdX?=
 =?utf-8?B?dnhkMmhUWll1SG9HSXBwMndKKzBrci9pbFRTYlBUSnIwaEZkazM2cjY0ZVVW?=
 =?utf-8?B?a3hDeUJBa0FCTzVldUxMQjA5dVppbVRQS0pPeUwrbjkxWUVGWW1Ea2ZEUHBO?=
 =?utf-8?B?SjRPZEFGcTVMS1JHQ0pSdkNtS05mY0huOGdacU1CdDFKRmQxNGJhaEVxRUt6?=
 =?utf-8?B?ZFpkdmZkdExKNkl2Rm9kREhHUmRacWU3WjlnT1hkNUdMT2hqZmdLMVNEU2l2?=
 =?utf-8?B?S2xTQm5uS1h5SFZzdHhqYWc5QXhVbTlBR29VY3laOFl3akZ2M2hwUDJZRmti?=
 =?utf-8?B?MHVTUTJZMzlTd1dqNVdXTW9EYjFNWGdkaURHNEE2NXpMUFE2VWZST2VKVFo4?=
 =?utf-8?B?dnBJcVIySlVvbU5JZHQ0ZXl1Yyt3RHlYUzR5ZWNUTWtENEZMLzF3N29XOUJL?=
 =?utf-8?B?SzdmTzRRRllTOURYNWVQMHVGaCtMa01tUmtSWEdrVGtEVHJESjYxNzllK0pV?=
 =?utf-8?B?enJJNFpwaGRBWmgyVE00akdSMkh6dk8wb245T0NhcVJQcWRxaXFKT0l5ekRl?=
 =?utf-8?B?Y0MxTDVFMXByeTFsU29UNG1iMCtpcnFSa3Z3bzVoaTA4SlBLbzhXS1IyeTho?=
 =?utf-8?B?dTVDWFV0c0hkWTFKQm5GYW13SlVPVWozd1dtU2ZpYWxidmdLeTd0N1VVYzlS?=
 =?utf-8?B?RXlwbEtQdzQxbU9KYlRiWDVZbjFhaEwvaS9oOFFEaEpTU3A3QUxzVFJFZDJE?=
 =?utf-8?Q?G/zxJ2fn+GczicEk=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6afbabe-f6d5-4c64-de72-08dea6eafeca
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 19:02:16.3237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7tIIy42+pWPaO1ulrkAcH0yZASibbhtXHd5C7NFhDobUF+jXfMtWMnq+JeyI86Q3GLKyevhSVSTM5O4ygcciTBXNBnSc1Zr/bTtcoqW47k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6312
X-Rspam-User: 
X-Rspamd-Queue-Id: 60E9D40005
X-Rspamd-Server: rspam04
X-Stat-Signature: fyzsuo4xn8wuhrogkf9hdmr5hj4mbha1
X-HE-Tag: 1777575742-204949
X-HE-Meta: U2FsdGVkX1+hlLdJeGw4C+dMHlG81JHGeYhVzOaSZOHqL/JFpLUYMC3bg0cbFRiANBZqeM8gzFjcbaOxu+SIVH1SVt8XTW/WUR2c4iIOSNXKwU7SS2RQsUOUV1vyvip5zt0KJI23xKhed+BRICRmNprwa0cu+BAz2nkEgHiuGWxC/1f9NLJ4fN5Inx2RHSJffB85GYQHLyqzSyIdJ8c/WcTa7ZNppztV9ukTdlIlYZ9DN8dIKYxQtnRs1JqnP5IqPFnmAMhUj5WujeSawabmkCasypUu53AGerbcz/v8FACEaBL4eFPgUwKmvqR4Q3yi0gpiEcJ1uq11CjvP1Z2QJikyWN2palkKaHut88h4G53wDsqygJolV7cHTkqHIxkjxUil8tOa2kOINpUN6xgl1/ylOWnI81sx7rSSExtbNvjcBv8jUv0IRx+6WNdZpr3d5idbJQVurTZy+MOTyfKJm5hIz6DGHBq7lpOXBDn+E/b/ErD+5JPJBO4x6XtEPZh/UovlvhSx0v3sfAp+HhseNbgVt96tp5C76ANy0yrfIAHFMMExvV5+KJlA2/aJSkdyOD6H+DObOE8oSyIlnw88p89RbjipOXUIfT7Tb0dgoiKT71sAe3wUWG50L1YuaIlbPhxMNS1YI3/J0U6CslvIqzYByEyFtiL36cZoJeaNjrZE8GHuIfyTNGk4kyFt/Uv1uxP8ivJrXoDypxMA9wJwlqivWEopd9+JS4PqKjMhV1/dlu87ok14D5EwjM/lBN/SnRhgvLtL/i9zY2JgpuYOf1TgdCXL3oxsBPuMEcYSVAxi3gX6D80y/hkVsQTbPhyoHC7jWI0UnTPtci5MARvHCSna7zn37xnN/Nk+N4imcpYOl6QHlKJ9aN+FKvGNWkQk0WT1KU3fJVuEcsQSCGTL6OKggQU7UT7KBDB+UoKoz5vKH3TrQ5BzU1p2SpsMttnZnIpcu3QxC2d7LnxHZj6
 0rUJHowU
 2dc0a7x3ZwFkkaxwzfSz0qJx2vlIxPVfJ0s8QbrgHrPr+Rf3Ml7iir+elii/SReaZ1V++wb1SlAsUeRtTvrpCz9z3zGATodB3hrZGwPLLpMgU4Oqvh51Sv8hrIKbQDoAl424Xx4Hhw/4oiJ9742vy1nw3plndzmaZjX39RP/n3T8DyQ/D4MP3xyCM7qSn4IZTPXqtdUW0uV9ArKCSXyOsGsM+2SX7e9Fr8ETxWBWQOMo0Sf1gYdHGeJS2nW0wTwxUR+tSu6dcG7MQxrVV/7NkPcbdPRUAKeq5txVu/1LRYCpDFSgBtPD9tvfkKys4w5aOQVECOSJLBWF4MdTMa/wVZbnUJ3LCs12HqpNrbSGq26rCR6C7rQRWV7YYVG4kL6O3QulE2lIQfz6fTDTfaq1NA8L8EtIgfslLBPrvHagMgDflvZFyjv7C7seLz+FVEOx+0tiyNLT9LKffhn1Gf4IbFqzDRSasvho5Mt1D2wpK8wMOIjR0TjH/TQ5LBOsoTrdBWspehROzF6ENygu6kfQ5hYS9ZsLEhQGU9RAFtqNnwr5iZ9AE1rqAOK/mo/OC8qvMQQK3eCy/ltxhneIM2W82pQfVKjsXWIm1F6TBOf11R9mz2xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 10:04 AM, Yang Shi wrote:
> Introduction
> ============
> This patch series implemented the LSFMM 2026 proposal for optimizing
> this_cpu_*() ops on ARM64. For the details of the proposal, Please refer to:
> https://lore.kernel.org/linux-mm/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/
> I didn't repeat it in the cover letter because there is no change to the
> proposal.
>
> The series is based on 7.1-rc1. It is basically minimum viable patches.
> There are still a few hacks in this series and it may break something,
> for example, KPTI, SMT machines which shared TLB, etc. But it shoule be
> good enough for now to demonstrate the core idea. The main purpose of the
> RFC is to gather feedback early, figure out missing parts and risks, and
> make sure we are on the right track, as well as hopefully it can help the
> discussion for the upcoming LSFMM.
>
> I broke the patches down to arch-dependent and arch-independent parts so that
> hopefully the interested persons can do experiments on other architectures,
> for example, S390, easier.
>
> A new kernel config is introduced, HAVE_LOCAL_PER_CPU_MAP. The architectures
> which can support this feature will select it. Allocating and freeing percpu
> local mapping is protected by this config so that others won't pay the cost.
>
>   
> Known Issues
> ============
> 1. KPIT
> -------
> We need determine what CPU we are on, then switch to the right page table.
> Currently arm64 kernel fetches tramp_pg_dir via swapper_pg_dir - fixed_offset,
> and fetches swapper_pg_dir from ttbr1. But ttbr1 may not hold swapper_pg_dir
> anymore except CPU #0. So we need to figure out the other way to handle it.
> Switching to tramp_pg_dir should be easy, but the reverse seems harder because
> tramp_pg_dir just maps the trampoline vectors.
> Maybe we can do two steps switch. Switch to swapper_pg_dir at the first step,
> then switch to per cpu page table (for entry) or tramp page table (for exit).
> Nobody should call this_cpu_*() at either userspace -> kernel entry stage or
> kernel -> userspace exit stage.
>
> 2. Shared TLB machines
> ----------------------
> Some machines may share TLB between CPUs, for example, SMT machines may share
> TLB between the two hardware threads in one single core.
> The per cpu page table just can't work with it. Maybe we need a new
> cpufeature to indicate whether per cpu page table is allowed or not. Then
> just enable it for not-shared-TLB machines.

Adding more known issues, I forgot to list them.

3. Memory hotplug/unplug
-----------------------
The linear mapping and/or vmemmap may be out of sync because 
__create_pgd_mapping() and __remove_pgd_mapping() are called
to deal with the page tables for memory hotplug/unplug, which don't have 
mechanism to sync page tables. But it should not be hard to resolve.

4. 2-level and 3-level page table
----------------------------
Need to make page table sync work for them, currently should just work 
with 4-level page table for now. It is not hard either.

5. Confusing /proc/vmallocinfo
---------------------------
The percpu were allocated from vmalloc area before, now they are not. So 
they should not show up in /proc/vmallocinfo
anymore,


Yang

>
>   
> Benchmark
> =========
> The benchmarks are done on 160 core AmpereOne machine. The baseline is
> v7.1-rc1 kernel.
>
> 1. Kernel Build
> ---------------
> Run kernel build (make -j160) with the default Fedora kernel config in a
> memcg.
> 13% - 18% sys time improvment
> 3% - 7% wall time improvement
>
> 2. stress-ng vm ops
> -------------------
> stress-ng --vm 160 --vm-bytes 128M --vm-ops 100000000
> 8.5% improvement
>
> 3. stress-ng vm ops + fork
> ----------------------
> stress-ng --mmapfork 160 --mmapfork-bytes 128M --mmapfork-ops 500
> 15% improvement
>
>
> Regression test
> ===============
> 1. memcg creation
> -----------------
> Create 10K memcgs. Each memcg creation needs to allocate multiple percpu
> variables, for example, percpu refcnt, rstat and objcg percpu refcnt.
>
> Consumed 2112K more virtual memory for percpu “local mapping” and a few
> more mega bytes consumed by per cpu page tables.
> No noticeable regression was found for elapsed time.
>
> 2. fork test
> ------------
> stress-ng --fork 160 --fork-ops 10000000
> fork() needs to allocate multiple percpu variables, for example, rss
> counters and mm_cid_cpu.
>
> Roughly 1% regression was found. However stress-ng fork test has quites
> small address space, the real life workloads typically have much larger
> address space and do more complicated works. The stress-ng mmapfork
> benchmark saw 15% improvement.
>
>
> Yang Shi (11):
>        arm64: mm: enable percpu kernel page table
>        arm64: mm: define percpu virtual space area
>        arm64: smp: define setup_per_cpu_areas()
>        mm: percpu: prepare to use dedicated percpu area
>        arm64: mm: map local percpu first chunk
>        mm: percpu: set up first chunk and reserve chunk
>        arm64: mm: introduce __per_cpu_local_off
>        vmalloc: pass in pgd pointer for vmap{__vunmap}_range_noflush()
>        mm: percpu: allocate and free local percpu vm area
>        arm64: kconfig: select HAVE_LOCAL_PER_CPU_MAP
>        arm64: percpu: use local percpu for this_cpu_*() APIs
>
>   arch/arm64/Kconfig                   |   2 +-
>   arch/arm64/include/asm/mmu.h         |   3 +++
>   arch/arm64/include/asm/mmu_context.h |   6 +++++-
>   arch/arm64/include/asm/percpu.h      |  17 ++++++++++-------
>   arch/arm64/include/asm/pgtable.h     |  24 +++++++++++++++++++++---
>   arch/arm64/kernel/setup.c            |   3 +++
>   arch/arm64/kernel/smp.c              |  40 ++++++++++++++++++++++++++++++++++++++++
>   arch/arm64/mm/mmu.c                  |  75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   arch/arm64/mm/ptdump.c               |   4 ++++
>   drivers/base/arch_numa.c             |  51 +--------------------------------------------------
>   include/linux/percpu.h               |   4 +++-
>   include/linux/vmalloc.h              |   3 +++
>   mm/Kconfig                           |   3 +++
>   mm/internal.h                        |   5 ++++-
>   mm/kmsan/hooks.c                     |  14 +++++++-------
>   mm/percpu-internal.h                 |  15 +++++++++++++++
>   mm/percpu-vm.c                       |  91 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   mm/percpu.c                          |  46 +++++++++++++++++++++++++++++++++++++---------
>   mm/vmalloc.c                         | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
>   19 files changed, 419 insertions(+), 99 deletions(-)
>
>
> Thanks,
> Yang
>


