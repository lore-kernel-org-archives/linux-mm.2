Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B102FF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 06:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F41F6B0088; Fri,  1 May 2026 02:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4606B008A; Fri,  1 May 2026 02:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C816B008C; Fri,  1 May 2026 02:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15F056B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:22:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9BD11C0D9A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:22:09 +0000 (UTC)
X-FDA: 84717855978.23.945CAD1
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012050.outbound.protection.outlook.com [40.93.195.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7F13180005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:22:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IsqwQunP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of apopple@nvidia.com designates 40.93.195.50 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777616526; a=rsa-sha256;
	cv=pass;
	b=B8tdHlI2CZHyq7YYW4vmSIiRY471muyI7JOiU2HE+5KfuxOS/eVfxkXi1vdAxSXvzoS7Ag
	1ma6/a31frrB9kH9tz9eVdi+4bZv0zxFWSkuaqwHPfRZQuUkXGGoA4aA73Ttv2MbRuxR5s
	zKGWj1aSyGg/e+gpYKjoeVYf45kxSoQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IsqwQunP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of apopple@nvidia.com designates 40.93.195.50 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777616526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5H7NJBa6jmvF4PPoOr2geJZLxMAPTi0SfGrS+TDFMY=;
	b=J2jGw6fEyZ7NsokFlfBXL+Rq0801JuQyC4/VR7tAGrdiaGW0I3nPYJ4HUCq8/sRLCNrCRh
	9M1Y4pj8GQK1rgfkVZPyjhml/Eo/BQH92VUPExDzV2R1EtyeYFVAQs8wcUsjpOxR0Ac9sE
	Vu1RIVKlt4wvHG2U5jkmJx3TaSiVhw0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/rna/0eMHfsBXxLO9naH+YyZEvhUo3NHhoeCtgftBptP4Y16eedOPBtjHiqxl/J5Gge+55Guw+W8m7jmagbSd+sCB7BZa7Pp35Rds6oKCLy+W8T9kT5vhES6vxefnN8BDr6sNnUUVF5/dmKJ3jzUv+UWdLLM4WFvowan8RZF5cmSjJGQsUoSh5OpqTh94MJTKGL90G4udpTxf6g++Id1aKK+OkWeLn1RtP7J36T0HgKsGB4njh8zdX2oKTFk7g8c/KkV1pbZVVFeD62lxa1A6Vcc5GiRcgpef8xXcAyQKDrq3A8KsqZhlsUH9HsJ8RJ2klrcPzWJURGVnh3wajn0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5H7NJBa6jmvF4PPoOr2geJZLxMAPTi0SfGrS+TDFMY=;
 b=xsVG5UTz/BTTbkplK75oXRI2Dv2nCYKx0OtCJg3PP4u2BJe00DOKBo9+AuTRGKzKKacAyR/i6MNqSrWe0P1aG8QNUzQ7a0b97jVWN8OVvT0bgxDJyk5ebZV92vhuShkYJWmYZDQw0ko6zIlIuCfDft6ywIKBN6O2OsyHiy0zKBhjyr+EGb61lBRdOgESyTIvXW5kehmqHH13YiIiiRAjRy9f3uFEOx41VBnChEo9Xx7dksNbVDicGbiLq0uudXhP2McRoDpBMMRHgViBoZIE3ykxYHqXQ21bV31KgALJn+E8Y9xUcmIA/ftZuK2xyYw0y8CKe5Ar1caycIr/FXc+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5H7NJBa6jmvF4PPoOr2geJZLxMAPTi0SfGrS+TDFMY=;
 b=IsqwQunP6KHKt2f7+/7HEK6sJahfw19fEZYmZhy785D1Fkab3PpZ2c1E0fmQycbBUqqV87BWNRoObL+B9FiCVPW1Ubae01I+uwyBqPCH+hr5IXhHxrwY3mSHXwkmnQb92xuWETxfkHe0XagGK8NBdAUM1EW/mRgmUrbh3gEKzpJrKe8bqLCTPZyRJo6vTrkB4CMLE2xRLVpP+lr5BampwbB59+tE1PpuKGazTWaJQFPkA8K5D3nY0P0Eh/wRQHnUYlgd7LdUIPKH8iTMjmhG1tQolSpchXvfEMlQLnUkQvMHYuMeckLTWUMRdjq4S9OseIj7CeqGdU4qOH7VteDPaw==
Received: from CY8PR12MB7705.namprd12.prod.outlook.com (2603:10b6:930:84::9)
 by SJ0PR12MB8165.namprd12.prod.outlook.com (2603:10b6:a03:4e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Fri, 1 May
 2026 06:22:01 +0000
Received: from CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4457:c7f7:6ed2:3dcf]) by CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4457:c7f7:6ed2:3dcf%6]) with mapi id 15.20.9870.020; Fri, 1 May 2026
 06:22:01 +0000
Date: Fri, 1 May 2026 16:21:36 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Arsen =?utf-8?Q?Arsenovi=C4=87?= <aarsenovic@baylibre.com>
Cc: amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, 
	cs-tech-ext@baylibre.com
Subject: Re: [BUG] Frequent hangs or WARNINGs when using heterogeneous memory
 with an AMD MI210 GPU
Message-ID: <afREaF6hcka_cxnY@nvdebian.thelocal>
References: <86ecjz2hhr.fsf@baylibre.com>
 <86tssu0w8p.fsf@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <86tssu0w8p.fsf@baylibre.com>
X-ClientProxiedBy: SY5PR01CA0010.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::19) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7705:EE_|SJ0PR12MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: d4da904e-6ce7-4914-9165-08dea749ed5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yGfYR8AOVetzkBd3uw9alADToltb9bTX7e63JO3qCowTAJatypeuUpDYeiJBo9CScVlYyOxOa9++oM1HH8yJv5yHakQ32PhOGp98iDMDK8chF/xJ7p8a/P0jlAfsjGDYEsY94HLvsu2GKQ+oH7M2BgQqhoFsgE7n6IyciiJVg0oQeS/e426x1vKO9AjZ40pYxbMjXYH9817PutZReadQlxdkSJmXPP4x7qqa88zHN+vOOVFYLcpVWmlp68JgXZsRybJ3C2R08c/Pas5bMV3TCfYLSVUWxOgaECNLGqGEf2XiJLjwdY+u7Z5W4/aKpQt7xfDc8WAcAAAA5jrrvigipVsdqowNo6ybbn7SECLsY8rHr3BeVIpJ/BzBBDZPvMdUqnyI3mmzWIO/NanTe++OnEdIpq4+mIvD9LKCLcDnUe97wyYkk8dPrtkBTWlnJS3IMnlcNQ3+WRGF2AFwuhRJ57iFF2X04CgBg/TBf8xbO2gN0fP30Mp3hCV9mVw5baWPjQG/SaDP62BUMNhlFQKkr9BReogRjfX8oYizgUBfgmCuFS+ELmdB5dhsE756YUKj2su6IjZOC4+CbWnORaOxi8aPJyWy0x7A+KwEFj4sRbDwrcVOGP6XmWB6Rf66Bu8HUlLlr6ea8MdZye4a3uHYGOHGEDpkqIKjlevlTg+5vWGAnLhUr9ADImcYn3qRLWCz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7705.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUtpZStrQ2cyYUxpVUNRY3ZiMWl0c3JTc1lja0NpWlNWRFFKMkozZ2IzMGFL?=
 =?utf-8?B?MUVERFd0N3E5Q2Rza00zTTV4NGpLT2ZTZDFjUmVsSUdhVy94TGFTWmJacGR6?=
 =?utf-8?B?Q2U2N1FzQWlocVhGNjFqNTN5c2o3T1l6Q0g1aEFrYlJVVEt2Y3loK2ZTbXEx?=
 =?utf-8?B?R2xoOHo1MURxR0ttWERuM0YzUFJBTGlYZis2RDZTWlJxWHZtdDZQdVhkWHdv?=
 =?utf-8?B?V1JqZGRGZk80aDBvV0Z6VWo0TkFJQTRzTktRWXpPTlAvaGJzUzF0cjhBMk9i?=
 =?utf-8?B?eElwSWlLVlNQTmhPRUV6UCtVRkxyRElLREZZTzQ1TEdCWnhSTnd4RFlHdjZo?=
 =?utf-8?B?UDBzVmVoRTZhcnA4aGpseDNmZ21IUzZ4bnZ2c0xaT0xCTkRRM1FrQ1hnKzBY?=
 =?utf-8?B?amt2RlNndjRvRTdrWUYyMVllVU1rZy92bVhyd3JtV2J6Tzh5M3NLc1Z1cUpH?=
 =?utf-8?B?bTlzK1duUmNiK1V0S1NGTjhpVjdWNVpNalRQMkg5eVhkWERSelJqaFNTSnZ6?=
 =?utf-8?B?SnNmcDJ0YWpyT1F1Uy9tSHhyWEIwRGNRMG5FNzlQazdPTWR6dFhTQXhQS2pF?=
 =?utf-8?B?ZDAwZU5MTlNzVnR3VW1yUmtTWnFRSGl5bXBIMVVIZHBDZzFJMDZhVkV1Qmo0?=
 =?utf-8?B?NjZ3NXVTa1FURm9KVXVOUlovNkdUR2lmZVlpUk9IdXZZOWNMdEUrNS9EK3Fi?=
 =?utf-8?B?N05lZTBPYmw3VFNSVWRIdDY4YnZtT2hXVkQ4NEtxTWNRaTZUTFlJSTZJSzVn?=
 =?utf-8?B?ZlhnQ3o3MUJnZVZqY0J3Z04zaWdaeDVORXNnM21XMldCTzVCODB5UWNIb2tL?=
 =?utf-8?B?N015akJCWWNqU0JZSWJsbk9ycS9DZWxPdGVpL1o0dlFXcXZzSEp3VU1KdkhV?=
 =?utf-8?B?bFFPbjIxbmMzRmxJN0RjRmZDdWcyVGw5Z0M1bXRtdDBxdTlZbXVBVEZMQXZ5?=
 =?utf-8?B?OG5MWnpOanJ5WkR4VjVqNmhmc254anhGTlBNVE1YM1VDYS9zNG9tZEkyV0Mx?=
 =?utf-8?B?cnAzcE5MVUk4MVJadkVYWXBIWmFTM1l1TnV6MW1mM0dJSmNvbm44VWJ2S2dI?=
 =?utf-8?B?VjVhcnZENk9zOERGWHJ6Zk82dFd3K25iMThSenBRR2FIQlViN0JwZ0N6UEhC?=
 =?utf-8?B?Q0Z4UE9Pd09xbk56a0dweVZ0aUxoaVE3cjFtL1NMU2lKZ0htMGJYZDk1ZlBo?=
 =?utf-8?B?aGoxdHJVV3ZDZnBhNlZURG1SblZUem4wNWdFNDI1QjI1VkJEaHVWTWpycXFh?=
 =?utf-8?B?dHJhWkNtL1I5T2NPK0JyRVI4S2tyUGJqb3JIWXRZSWp5Mk5RSmlSL2VZeW9h?=
 =?utf-8?B?R0JlOW4wcFQ0YnQwWjQxUDlNZUszSjc3Y1B5UnpHOFJwbHdjV0NhdE02SEtP?=
 =?utf-8?B?U24zYStBUEJDQTVMVG9iV3Nyek9CeHJsaWV2TkJsTWF4d0tOSHhlOUxqd0hw?=
 =?utf-8?B?TGQ5UFNDVDFRQWZBeEVFMmVZaXBZRVM4eGZtL1BrdUk3a04wQ2QxUm1lWGNM?=
 =?utf-8?B?cE5mVW9aNTV2eUZRYTdTT0FGc0xOUm5yWDFxY3VSMmVEcnA0dEc1Nitsb2FT?=
 =?utf-8?B?RWNxYjlFc2NmQjFjRkpNeklwcGF2eTlERms2T1B3NW0waTdLUldhL3FmT2tp?=
 =?utf-8?B?MUloMERVY2k2U2JqSmFUY1NTbnZiY0xud0NEREhlejVCK3p4WTFOSjhtQVg2?=
 =?utf-8?B?WUJUN2VMNTlGOFQ1cThhUTVkaGYzQmdXUlRlT05WQ01LNHNVQTV4Qi9Gdld4?=
 =?utf-8?B?V1RGUXpNYzlCdGwyWjQ0aGlXdWIyeE96ajF2NUVqc25BK0FqOWhxK3Jzbi84?=
 =?utf-8?B?Z3hQZ1RCdUthaG53R0tMdUNBc1ArcjA5ZWNZdWtxMUlIZW9vMng4V1lKVTNr?=
 =?utf-8?B?UVVTbi9KeVlSR3VvZVM0MXBKdFA1Z2ZxQ1g2V1dLQmNPa0QzN25IOXdMd0J4?=
 =?utf-8?B?cTMzdlJtVG1rYU9FWWZXdHVpZEd3Z3JSanlpcWc2R0YzWmdyNENGZFVNdXow?=
 =?utf-8?B?RTlFYVJ4SnFRaEM3bTAwUlZNZ0VwNWhhdmV2c3JRTjFSQWQ3VzJpLzRldEtK?=
 =?utf-8?B?VWlJN2s0ekYwSWF6anZnQnNVOGlXVmllTWR6bmliMDZ3V200Y2YrZjFNVUdN?=
 =?utf-8?B?SUFncVllM0lUaS9ML1JBbFdzQTVkTFArOTM4SmROaWYzOWJNblhkSGxibjdO?=
 =?utf-8?B?N29KZDZ6NE5meU8yMEsraGtIdkNXMmlkcGM0cGpzTlBKTWswYkpJOFJFMVZB?=
 =?utf-8?B?c2VBNk9uekh4YWorejhuYlRWYTk3TU80NTVINEpBRVdqVGpZbGtMdFhYckVt?=
 =?utf-8?B?d2R5TUorUjBrWm9MZjZWUFhLMnlEWVQvOVVZRUJqeXc5ZGExNjcvZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4da904e-6ce7-4914-9165-08dea749ed5a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 06:22:01.2451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pfQPdY2ZESkT9M8ADMJkP3BRWOOIpMe8vPlSnrdEsRAlBC4OFMuqbv1rxvPlryCeXP0BF0K2SegOzpaLqcw7eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8165
X-Stat-Signature: fjsg5jyeoozjntwrfs35duqkwmfsd3x3
X-Rspam-User: 
X-Rspamd-Queue-Id: A7F13180005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777616526-929605
X-HE-Meta: U2FsdGVkX1/XKm8bxjEw19V3UvVY+yZwyjH3FunijA4gAg855Q1xc7yOwJrwJlN680hCVZSHD0+I8QrJVl6qQxFaNyrazOVbZhUu4gFs8LnN2tFy2bkW1KAwiuUEBzgwKaa27fSV+T0INaSVMdISof9NwTP2Bn5U3s3ECSqb/l/ce0MG1GU2qKggfQ3+a829NfxnrpUq4cM2eGJY4R8hV7MUpahjRD07/AEV4tbGObJDy4a4jUiJXGdLcBzVQeJ5OknMFX9D8aJ8yma6D8tfQJT+ufm9ABRhs4Q5pQFdOX8hKtSepag5CzOJ0MwFEiIxVLTZcxwOjyDjEnMug5C5POmVpclR2uQBHFxDhLJJcuFWg0bxiyf0nNAL+45KzqvkilzezO2qcllDeaM4/FOug4nvVuHLavX3FPZ5qDAavMszXlh33HqmBcnp76D551rP7iibRkWBE+DbY8Y4vj0H92ziutWKHaE0ZOkkHG+rKtPKHnRq9oSoemX1W9hIBRRF4f0Qbb1iDxfrNzu/IO7ff5+Hrt7lRQWj4rSqVHvgOLCJybF94LiigJLsl9KJLTm5LQeFwr1jzUiudjVmEZ0gHvWyRZot8PegO8Kb8qkpHo1mSgDdrXlfC35RPRLwmwMrJg+H7/3bWvp3A91sqFA2T/rosd58+b53ghL/qaDKaULkVodh4QJ0en7o7qzCdTHVHLv7H7nVGdoH5KjFHyzH9lx+Ok9/Yz1Ap3KAfQ6957bDozb9dZmkXqZRZr/SEFCr6wPgHH/Du6Na0I3UdUGlt46WXvxGBNDzZvTo9fFlfB8/PvUIkqrswXcNCcjfJ85HOin3LsaOm824ZVYim6kJ1rmXTdzVdDDYAvqZmaBfsSFkgt135UgenlR28erQg/nWegeq14gxsQft55IyFj8yP2DJGy2FoOTfZIooghMO/WYH+IpdNc7BPDaHGjCmKLctX9dHBxsvDfnNByQqR+e
 tDHdi7m2
 5+pvwgWS6secHWT49RdAq455JLjIJbkqjSLSxT8+qB7fj2TVbwC8g+atM5j/AQM6Fz6iXgvA4gTMxtzVDC9/Q0ivxmNAKLvEsgN4PeUmkf7OHmivanJYVCvBCQhvIkNqeGQfDnUfZkjJMRo0u1Y8NTR3A8aA5wQ8TXuKKGdqSqEsaNSqf/8yrSxp0yM00w9fcvPTiBnhHhV5AhAcAF2wd89NUcHXc58t+5aopQOBz1++aJEIuoOLxc+vT3HKAXl0OIELS7Su7kN4SRS3gFX759lKOSubEdMekrFWPeYw09Hv26UtLgYydiK+DyeC5XGf7MUjmW0S+Wx5S5vKbzbDrdLw6sBtazT8IaxDAhHEkpRqtBek+OBFELuMr6h1SapXqOgywqT+KqFiigIvgzF6pZKJ25A8Q2CeRw0vCQMpbgRW687kQvA1NVL1RVtcvcOXr2UZf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-29 at 22:47 +1000, Arsen Arsenovi=C4=87 <aarsenovic@baylibre.com=
> wrote...
> Arsen Arsenovi=C4=87 <aarsenovic@baylibre.com> writes:
>=20
> > We get this by running the following OpenMP program built for offloadin=
g
> > onto an AMD GPU:
> >
> >   https://gcc.gnu.org/cgit/gcc/tree/libgomp/testsuite/libgomp.c++/pr119=
692-1-4.C
> >
> > ... built by:
> >
> >   x86_64-none-linux-gnu-g++ pr119692-1-4.C -foffload=3D-march=3Dgfx90a =
\
> >     -Wl,-rpath,/opt/rocm/lib -fopenmp -O2 \
> >     -DDEFAULT=3D'defaultmap(firstprivate)' \
> >     -lm -o ./pr119692-1-4.exe
> >
> > ... using trunk GCC configured for amdgcn-amdhsa offloading[1] and
> > executed as:
> >
> >   timeout --verbose 10s env HSA_XNACK=3D1 LD_LIBRARY_PATH=3D. ./pr11969=
2-1-4.exe
> >
> > ... when the timeout happens (i.e. the program gets stuck for 10 second=
s
> > and then, when 10 seconds pass, timeout sends a SIGTERM to a.out, and
> > results in the crash above).
>=20
> I've now confirmed that it is possible to reproduce this specific issue
> also on bare metal, also with kernel 7.0.2 and ROCm 7.2.2 (using the
> rocm/dev-ubuntu-22.04:7.2.2 Docker image):
>=20
>   [ 1171.959571] ------------[ cut here ]------------
>   [ 1171.959577] WARNING: mm/memory.c:1753 at unmap_page_range+0x10d5/0x1=
bc0, CPU#247: pr119692-1-4.ex/143761

I don't know the AMD driver well enough to comment definitively but chances=
 are
this warning is spurious. I have been meaning to put togeather a fix for it=
.
The problem is that migrate_vma_setup() etc. allow for migration of anonymo=
us
folios, which is subtly different from only allowing migration of anonymous
VMA's.

Specifically migrate_vma checks for folio_test_anon() which returns true fo=
r
private file-backed VMAs while the warning is based on vma_is_anonymous()
which is false for such mappings. So it is possible for the driver to migra=
te a
private filebacked mapping to GPU memory which will trigger this warning du=
ring
teardown if the page wasn't migrated back.

 - Alistair

>   [ 1171.959613] Modules linked in: xt_iprange xt_LOG nf_log_syslog xt_co=
mment amdgpu amdxcp drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks =
gpu_sched drm_suballoc_helper video drm_buddy drm_display_helper cec rc_cor=
e iptable_nat iptable_filter vhost_vsock vmw_vsock_virtio_transport_common =
vsock vhost vhost_iotlb nf_conntrack_netlink xt_nat veth vxlan ip6_udp_tunn=
el udp_tunnel xt_policy xt_mark xt_bpf xt_tcpudp br_netfilter xt_conntrack =
xt_MASQUERADE xfrm_user xfrm_algo xt_set ip_set nft_chain_nat nf_nat nf_con=
ntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_addrtype nft_compat nfsv3 nfs netfs=
 overlay 8021q garp mrp bridge stp llc bonding tls nf_tables nfnetlink binf=
mt_misc nls_iso8859_1 intel_rapl_msr intel_rapl_common amd64_edac edac_mce_=
amd kvm_amd ipmi_ssif kvm irqbypass rapl wmi_bmof pcspkr ccp input_leds joy=
dev mac_hid acpi_ipmi ptdma ipmi_si k10temp ipmi_devintf ipmi_msghandler nf=
sd auth_rpcgss nfs_acl lockd sch_fq_codel dm_multipath grace scsi_dh_rdac s=
csi_dh_emc scsi_dh_alua sunrpc msr efi_pstore ip_tables x_tables
>   [ 1171.959847]  autofs4 btrfs libblake2b raid10 raid456 async_raid6_rec=
ov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 hid_ge=
neric usbmouse igb bnxt_en ghash_clmulni_intel usbhid ast rndis_host ahci c=
dc_ether libahci dca usbnet hid i2c_algo_bit mii i2c_piix4 i2c_smbus wmi ae=
sni_intel
>   [ 1171.959939] CPU: 247 UID: 0 PID: 143761 Comm: pr119692-1-4.ex Not ta=
inted 7.0.2-instinct-arsen #3 PREEMPT(lazy)
>   [ 1171.959947] Hardware name: Supermicro AS -4124GS-TNR/H12DSG-O-CPU, B=
IOS 2.8 01/26/2024
>   [ 1171.959951] RIP: 0010:unmap_page_range+0x10d5/0x1bc0
>   [ 1171.959959] Code: 2e 2e 2e 31 c0 4c 39 b5 50 ff ff ff 0f 85 72 f2 ff=
 ff e9 b1 fd ff ff 48 8b 45 90 48 8b 53 18 48 83 78 48 00 0f 84 28 f9 ff ff=
 <0f> 0b e9 21 f9 ff ff a9 ff 0f 00 00 0f 85 cb fb ff ff 48 8b 10 83
>   [ 1171.959964] RSP: 0018:ffffce40ffc87920 EFLAGS: 00010286
>   [ 1171.959969] RAX: ffff8e18cb2ee900 RBX: fffff3333ffb6a00 RCX: 0000000=
000000000
>   [ 1171.959973] RDX: ffff8e18de1b18c9 RSI: 0000000000000005 RDI: 0000000=
000000000
>   [ 1171.959976] RBP: ffffce40ffc87a30 R08: 0000000000000000 R09: 0000000=
000000000
>   [ 1171.959979] R10: 0000000000000000 R11: 0000000000000000 R12: ffffce4=
0ffc87b90
>   [ 1171.959983] R13: fffff3333ffb6a00 R14: 0000000000000001 R15: ffff8e1=
8ba912018
>   [ 1171.959986] FS:  0000000000000000(0000) GS:ffff8e57ac3da000(0000) kn=
lGS:0000000000000000
>   [ 1171.959990] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [ 1171.959994] CR2: 000070d717bfe920 CR3: 0000004169a48002 CR4: 0000000=
000f70ef0
>   [ 1171.960000] PKRU: 55555554
>   [ 1171.960004] Call Trace:
>   [ 1171.960008]  <TASK>
>   [ 1171.960022]  unmap_single_vma+0x96/0x110
>   [ 1171.960031]  unmap_vmas+0xa5/0x180
>   [ 1171.960041]  exit_mmap+0x13b/0x400
>   [ 1171.960060]  __mmput+0x45/0x170
>   [ 1171.960068]  mmput+0x31/0x40
>   [ 1171.960074]  do_exit+0x285/0xad0
>   [ 1171.960083]  do_group_exit+0x2d/0xb0
>   [ 1171.960090]  get_signal+0x86a/0x930
>   [ 1171.960099]  ? kfd_ioctl+0x4ad/0x5c0 [amdgpu]
>   [ 1171.960563]  ? srso_alias_return_thunk+0x5/0xfbef5
>   [ 1171.960570]  ? __x64_sys_ioctl+0xbd/0x100
>   [ 1171.960580]  arch_do_signal_or_restart+0x3a/0x250
>   [ 1171.960608]  exit_to_user_mode_loop+0x8f/0x500
>   [ 1171.960618]  do_syscall_64+0x2cd/0x14b0
>   [ 1171.960626]  ? srso_alias_return_thunk+0x5/0xfbef5
>   [ 1171.960631]  ? handle_mm_fault+0x1e8/0x2f0
>   [ 1171.960640]  ? srso_alias_return_thunk+0x5/0xfbef5
>   [ 1171.960646]  ? do_user_addr_fault+0x2ee/0x830
>   [ 1171.960655]  ? srso_alias_return_thunk+0x5/0xfbef5
>   [ 1171.960660]  ? irqentry_exit+0xa5/0x600
>   [ 1171.960670]  ? srso_alias_return_thunk+0x5/0xfbef5
>   [ 1171.960676]  ? exc_page_fault+0x94/0x1e0
>   [ 1171.960682]  ? ret_from_fork+0x1b2/0x3a0
>   [ 1171.960691]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   [ 1171.960697] RIP: 0033:0x70d718dab9cf
>   [ 1171.960704] Code: Unable to access opcode bytes at 0x70d718dab9a5.
>   [ 1171.960708] RSP: 002b:000070d717bfda90 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000010
>   [ 1171.960716] RAX: fffffffffffffffc RBX: 0000000000000003 RCX: 000070d=
718dab9cf
>   [ 1171.960720] RDX: 000070d717bfdb60 RSI: 00000000c0184b0c RDI: 0000000=
000000003
>   [ 1171.960725] RBP: 00000000c0184b0c R08: 0000000040000001 R09: 000070d=
708000dd0
>   [ 1171.960728] R10: 000070d71902bc68 R11: 0000000000000246 R12: 000070d=
717bfdc10
>   [ 1171.960732] R13: 000070d717bfdb60 R14: 0000000031050b60 R15: 000070d=
708000dd0
>   [ 1171.960741]  </TASK>
>   [ 1171.960746] ---[ end trace 0000000000000000 ]---
>=20
> I'll try the other testcase we had (omptests t-unified-* all running in
> parallel) later also.
> --=20
> Arsen Arsenovi=C4=87



