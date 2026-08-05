Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DEA1C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833666B0092; Wed,  5 Aug 2026 11:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5B36B0093; Wed,  5 Aug 2026 11:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB326B0095; Wed,  5 Aug 2026 11:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE696B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:32:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9C1E804D1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:32:52 +0000 (UTC)
X-FDA: 85067608584.23.FC7CF36
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id DE4188000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:32:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="WTIk/f6h";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785943970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mF/wSDasJLPRyQsEhzJ9VdqLbsfAPw1WEjOgN0U/gJg=;
	b=S4gn3mPcRrrLh7UOSP4zhx4p12+cYpPB02rjeY2Lu/CgGzzVJ1rv8jMHiJ6U16QM5hFXDW
	8/jn+R0moolakBviygSiZR0AT1Zj6oW1zj9tqOnGyf4y2+s+NO4vHblX6upEg2sAV4Ki2I
	auPxkaQT1zHDzxF3+1FKP+zLBIuUKu8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="WTIk/f6h";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785943970;
	b=8N9etPasCZj79HTjp28b8Q7+paXY33dWD4KJOd48Igd92pv3q7O0YPWp4Tw3EIh6fPszlU
	EHBcmeqUOYv7zQECcH1HiQObVU7ErH8mznebHB5nqSTOh/IjAavYd3wr5xp6i4KaNrdJTX
	z3I0HabpVY5G3duGl4cx5H4g8Q00+Bc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MvA5uF5jt7F5VdyygwKxLuBeqqP/oBPRILDfmIQmZO3r9MQl4zcEYxdzinXqEVaafz3vJLSEKlSi2uzPSkBwV4HQYCB/mqCBU7/CG6td1upjl1VoFQqUxyFF4MVAzmiyLrwvo+h5EpJ7AZNu90cleWLU+t2f28qPwhvmsOW88bVBKC+RaX5QXGz/lmt/F2IzBhBg8PKiihQveqNzXDHpbUU6ptJFjxejV4+VLJGa1PsPC3YID4/rJ+4TYavjsLP3ACCv1lq0Y1XDbuv/HC21X24EhScFjduA6qiqoCZtw/Tb4RFt/kICKCPtQQoWIcXrryq5mVm57YlJozeUVAedlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mF/wSDasJLPRyQsEhzJ9VdqLbsfAPw1WEjOgN0U/gJg=;
 b=MK3Mqadqau6gX7RHZDgzNlXFOc8Vsa5ww/nsqMakzcjIZ0EALXK+NzV1xKdrjgWnIkPZ2HnPTpSC0g1jwx3zR+mW+/OCODWfkTUhVY81YAOzbH9jqBwVa4Xxfmmdc81jOv+hil4I+BF5nBI9X0kuWB8tgFC0YGKAIsZzJn21PrTaFo08RKsqi704WKO9VLNQJjpF0+3vbKCzmBf/AThWsDPvnYe8x/8DU8HmoFqa6TClt7bNaEsqUCtmEqR8agwZJh0x/AGc9LKMgCwh/rkB9s+A7CKTrp5DEEEdOUbm6Z/RYgx5T7Y3OpavvEo1PKYlmAFyXdC0cd7PILf7URjV8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mF/wSDasJLPRyQsEhzJ9VdqLbsfAPw1WEjOgN0U/gJg=;
 b=WTIk/f6ho4YDqtbdWK2u61xbAFkE8OV9rzS27UzxiSlNAk0C8uxfyRqESkOx6PNbhMEIsOgifeCyNPLNq9iH91D0MqJAsEvd0auDgdVz0nuiNCm3XLlOh/o6sySMOhaFwPCiQ/Lu/Yf1QdxBS0cOgxR9qfjx1CiTfq+8RojbwmKBT15l+6/tTgpSMYYpuS9poYp2pSNvn2BMLt4fKJ9XWxDNLlwFKWP6uwB+Q3P0wi9kOepiDyAQb+I3lFyURdXipQrItHJ31PcWRcXLe45o2haopjoCp+NaicvioxolAh0Q2Iegp6da+I6GGSgEtX+pfhJKDt07CVRT7XLgpo+j6w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 15:32:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 15:32:45 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Aug 2026 11:32:44 -0400
Message-Id: <DKH4AQPWT2WA.YAGFEOHERIED@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 2/4] selftests: mm: move
 gather_after_split_folio_orders() into vm_util.c file
Cc: <liam@infradead.org>, <nico.pache@linux.dev>, <dev.jain@arm.com>,
 <ryan.roberts@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
 <usama.arif@linux.dev>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
X-Mailer: aerc 0.21.0
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <cb0697506337320d438bce15cdd3c4caccb914a1.1785564857.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cb0697506337320d438bce15cdd3c4caccb914a1.1785564857.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: BL1P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ded4c71-37da-46bd-9b98-08def306cbec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xWYPZlc/sLs6F06B76hS1/VYmfUeixu+aU6x5NMh3IJBos00Ek2ESM6imryF2AFe29I+RUo0Ws3kdmhznPQV3KYg8WaqWmvSYCL27umizk1nfpKcOqoP2szOEPLAgu4Ntn6hnDQAz4wnB3NvAE64JaQ06cNcj4wHFbBSb4FFU9jlz9/qBX97lbBzZtq1aJb93/MNUH7dKXgBXTuHj9O0uUW2vkckQfNCqW810S4W8NpyIEutk34pgCg9FLLSt7gNhpgmt0zL8AW6hDF5hVKxE5dQnJAvNymgh4kmbm23448IiWKNtjCzb5RzXRQwdN0LGDyzcKceZ4iKGBJOjT2qJTeAYtJt6P8IuB1LfOfCggFLEuKoG4DeSlmU1WOLANaDGhZiUy4GAnMgK/XbXqMK2tndM5ZKMdz4othOxJHv4gt0GqPAKjOq+44DRcE9eizjDbEvUaueOOxIeJ/p9qiePkhcO9yALIUYUkTGHvLrkYVjDJ/LxdJDlnMbBpkjMH0jkuM5XpcJD+r8lLtP//fIBnjfK5oQJVcRjlGedsf4X5qk78obYDweQgeJBPmWPtUHP6r2K2pdxdd9V19aN7ka47qzPLJ9nN2v6KPb55RvbjL2MJJQXnW6sGNMzoNyjPH47IzQQUgXxaHouaopJ5EWz0LN8kqetR4ypWM/qH3BO00=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDg4N2FDaWF6NEZCbGJxMFN4aFM1eEtzYytuWE85MDRDa01oMmJScTJFMHF2?=
 =?utf-8?B?VTFRdG5DRHpDUXIxZU45U0dsbW1yNzNQM1FENVZOQ0VEbThEUlJoaTZRQThZ?=
 =?utf-8?B?cEQvZTcwcUxuOXcvTVZZVG14VklGMnVTQnkvLzFNa0ZrZW8xR3A3b016R2xx?=
 =?utf-8?B?cHhPTTJXVExUMTlVcndLbjJqQTdld05JQzZRUlgzZXEzOXlpYk1pRC9ucG5M?=
 =?utf-8?B?ZDVxdU5vSlpVcEppaGw3TlBaRjg3cmIxV3RCajNTd2grNlp0R29pWFJBWDYy?=
 =?utf-8?B?d2RiVHVSL0V5NUxnM0dpKzJqZ1ZSRnBaejdvZEVhMlBEMXhrKzBSd2o4N1Yx?=
 =?utf-8?B?WTUyS0VxMG80NVR0eDZxZFZIb2VZU3dHV0MyOVNSSXJSWENmOXA3MnF3aW9q?=
 =?utf-8?B?cHUzRHU2bHM5MlJMQzNXV3JDZStsT00vZnJsVlZUVUZBd1ZieG1pc2VKbHVO?=
 =?utf-8?B?Y2tHWFpFQXlGcnhUY1pEb1k2bmV4cDVyOTdST0NYTGdEZ3lxR1JoMnRaWWc1?=
 =?utf-8?B?RGhxSGdCWWhhZlQ4WHVjcVExYk9tL0xEd25wVDNBS0N3T2tBbW91K3R2TlZv?=
 =?utf-8?B?bENVS2RpYUFWY1UwS2NLMUx3KzJOOWp4R0M4Qm5UYjR2T2l1aitwNm91di9H?=
 =?utf-8?B?d0NMNi9hZHlsamp4UzlRcEM2MU96K3QvVWpPOFprMHZqenJ2UzR0M0MvWUsx?=
 =?utf-8?B?QU1LT0QxdE1pbFdWSFNtWU1mK3pNdis5aU8wUjF0dlRsVDhhUThNd0VsUnVs?=
 =?utf-8?B?Q0c1WjB5UnZBWDR5VUFwU25GVnpJSXJzL1dRZGZmWUpQdE44K3J3dlpXL3lH?=
 =?utf-8?B?a2gzZGJBR0pNN1lwSnY4YW12azZBZ3RZUTFCVXVvR1hvT0RGTFZoL1NrZkp1?=
 =?utf-8?B?bk1vNnB0bWhRbUpsMGI1OTlLL3V1YjRyVGlJbE5SSHJRSWQwbkp2MktWRWNR?=
 =?utf-8?B?VWt5TWFyU0NiejU5ZXFDUjVoU3p5TGwyTGZKWlBMSXlUVXFaR0JXYUhLVU1H?=
 =?utf-8?B?eHMvRHV6dUFLTXdlR0RyMll3bGNPV2s3bkxXR2Y1V0NlZnpLUFo5SlA5ZXQr?=
 =?utf-8?B?VnZmaDRNc1E2WjNRNEVpOFN6ZmtIL1d2S2JqWndmN1FWUWlrczFFckRFTlVH?=
 =?utf-8?B?R1lZdzJHcjIrT2FRY1lObnNtbjd6S0t0aGN1ZXZ5Z0U1cWlhQ3VMV0U2MHBo?=
 =?utf-8?B?K1ZyWGRCc1Jnd05WOGRYdEFDRm1HWU9ha0RsTzJRODQ4SFllQ3BwV1c4T2ZU?=
 =?utf-8?B?TlVEcHBTWWNwa291WDV6ZjljM01ZMHhPazBiVEZyR3Q5K1BrN3hjQjNTa01u?=
 =?utf-8?B?ZkNOYk5sb2srZitvWldxT09EYjhmVGxWMFJCaFZIbUhaaGFCaEhPeW1idmVt?=
 =?utf-8?B?MXhiYS93WUo5S3pLZ3FVMERwa1J0YXlCLzV1cHFVVEFPNmU1V2daUWJkTGls?=
 =?utf-8?B?d3JRUTk4UmhXNHpEUGJTSFB1M3JaWExSbkNmdTcrSnBVRDl1aDB3R1ZuOUYv?=
 =?utf-8?B?eTM0c1Q5WUdtVXJGR3pkSk16Z0thbWtSZ1hLZThsUGV2K0JpS3ZuVitIZWNk?=
 =?utf-8?B?UkhvWWM2WTgwRDd3UTZmQTYzUm5IOWp1Qk9EeWF4ZGZVOWNNM1RNVXlZZWVa?=
 =?utf-8?B?NURCbE91QUJJb1B5ODJUVFAxeVNJejhsNzRpcVhvQXRBUjl3WnFGWUZENTFp?=
 =?utf-8?B?cjlMUFJzVHlQcEVHWVEzSnB2VEpaVmhJQTRSWmRJTEdzZENCWStWWW5pYXdy?=
 =?utf-8?B?TWlEcDZ4VGJ3akVmb3Azci9TZG05eFM3UC8xMkhzVk1pRU56Z2w4VW5VeFNa?=
 =?utf-8?B?dzRjRDlyb2pCRWVNOGZYek1Qei9aeVpjcHlxM1FPVm1aV1gyenMvT0RObXps?=
 =?utf-8?B?Nk9XTHBYemVLb241MjdTbzM5VHE0dTRHWjlVdDd3TUpWcWFxdzQvZTdDZmxy?=
 =?utf-8?B?em9Qd3lhdGUrN0JUb3U3bGptcHl3RHRyVFlQQjZjL24veXQ4N2xWSzJTMmFJ?=
 =?utf-8?B?ZGFGRjc3eHdiVTZPQzBneDVnb1RJeCtXalJOWW9yT1hGRC93UmxUU2Q5U2FF?=
 =?utf-8?B?M1RSR3BMOWxheEJtdHIyREJpc0kyQmk5K3FlMnJLSktqamN1TWs0aTlTWXZL?=
 =?utf-8?B?MTJISXl2VnpLalVxVDhONHp2Wkw3ZEM2WkFRTS9WT1ZIcytWOFp1ZldCL3lp?=
 =?utf-8?B?K3dGRzFkU2ZvOEk4bzVqNXpsWmdSendzdmt0c0MvMWVxbW12OFN3aGNLenZU?=
 =?utf-8?B?OFp3UGtkY1NwT0htYklTRE40aHFyTmhsRXBxd01EMit3MjlVTG5BL1Irbkxx?=
 =?utf-8?Q?T+VOs0wOI4kvRECOiZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ded4c71-37da-46bd-9b98-08def306cbec
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 15:32:45.0976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWlkyPfQvWfPvGc+T1g36P53cCK+EtN8NK7V33jvjI0s4BgaIbxpisS+I6U5kmfj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE4188000C
X-Stat-Signature: 8oy8wzbbo4h58gngkwgk1pny37fcf1wf
X-Rspam-User: 
X-HE-Tag: 1785943969-318689
X-HE-Meta: U2FsdGVkX19Qgj/Z9oEHG7MYP3R1lV5KvoyxUeQ1Jdvuzrv10HEIwC7+/Pm1RxUEayoD3Nh3IEleprRJqfj/n1+HwMBFnePxRV0GZb9uHJ0w4aQXt3BKD5giByeO8ERuHZ/F5QZ0dDJGORaQR27GooRNU6arE87Xt3XkKKC9cfknom7d60axdByNYAnsjr61BpZHaNU14NWEhpEDRp7iUwspuEpwD7eKCA/55PAOX6pusG1kXLs650Mvh1iat0Xk1w/e7TOv+wfQnk2vZUet9NbICfFO3eqY7bigKedbhb8paSq9uurf8j19jno3ArwEItAbXp9gzT2f6PRIqn7JtM39edq25CpSfdgkdijT2YQJX1yOuf/Orrn1e4yvpcmC+EoOIrmHq555nIZt3AtiR0O8LhbBakG6ka+h3Xnqk3euPSXeAEgk32SI/yu2FhHeDaZy/XfMtespsIPUrZF62oOG8xQhe0PF4Z/oRG9CO+V5+XWwF7bbh5aPoJ8m1vGfgntEAZQ8Y1PWDJaVEndBdjciYDgbdPR8OkSn39PK58yIXHHgoAzePTt5ed9Bh0shV5JgjYHy/jXfpu7+wNVtM03TA3P4gRZPkXOFR8HCR4mc9hA7pVadvcPreFWD+UJGnjEQEDBnXY5h1SXEhPz9i08urEZsl8mBhWwBueWAeb/D5+EuGaDhL1WyvrFURudRXlOsVS8bs283v8e/aT3cRSfpd0MPM//4IvmlKxmOgmxngd4kk1+1/h8oMCyHveaLmDKf4ePH1UEqV3fLOJoatPbWaKb85JMyRO9SbMBnsJDcM8Vil6ngebu7doGiMDbk9f7S+na4dxcCWuJdrtWwzbsh6vNclGOnTrfuRLEZWDqCMpVF7Rvl+luralyXMHJyEALE/R+dVGIoFPbHeMM9UVJixhFkxsfvznzacx/8mB6HyPf6MPeHlPbC0IBbQGLW2ee4mWu3eTG6mO5TQdc
 tP4w1VDJ
 PhHjOHhQzJUTRkwWFPJsOHPO1T6GKd6rVwKS3m78Px7JkCjr1+aX2ByRaOFMpbDDj8Edr3nBgk1J65IWE62jUrcn1d+OeWrIY3g/XG27kIyxg/Bc15wQPkhmHF6HIf8dJHWUDD6PkV5ErGw4e8nlHTj+f1QvFm2YMytoWdNHePWhQIO5rDK70gssIr8Hv8AGs9RaeiBV7N4P4rJeunVDhk6VK3NaVZETfFnJB+0Fw6b2xeAaU9L9p/WHwfr/GQpbZCj003EdVji99kXof9ix05CfmMV5cAw9Vd9iw10MXFDPfz8g/Osn9ospxxVKodR+9H3hcRhcVDHOQ0oaBVuXa3kWB6NyBOcynvsYdKtOTPoIG+sYlcqa6s687VjtELbKJ3VQ30VOp9uiGaeVonpqT2kxUvEVy5HWFFdU0hYKTQV5vCabgouY2fFoGwCSPtdmhj27qMwQPl4lvhjMDrrGyAa+WsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
> Move gather_after_split_folio_orders() to vm_util.c as a helper function
> in preparation for implementing checks for mTHP collapse. While we are
> at it, rename this function to indicate that it is not only used for
> large folio splits.
>
> No functional changes.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  .../selftests/mm/split_huge_page_test.c       | 125 +-----------------
>  tools/testing/selftests/mm/vm_util.c          | 119 +++++++++++++++++
>  tools/testing/selftests/mm/vm_util.h          |   2 +
>  3 files changed, 122 insertions(+), 124 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


