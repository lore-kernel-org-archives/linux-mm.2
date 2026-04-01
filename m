Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE9710F9311
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 01:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFDE6B0089; Tue, 31 Mar 2026 21:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171966B008A; Tue, 31 Mar 2026 21:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F946B0092; Tue, 31 Mar 2026 21:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA7F06B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:21:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88357160566
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:21:09 +0000 (UTC)
X-FDA: 84608233458.29.E2D2336
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010068.outbound.protection.outlook.com [52.101.201.68])
	by imf24.hostedemail.com (Postfix) with ESMTP id 84DE5180009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:21:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L8OhytB1;
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.68 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775006466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ld2M7EY8HnSItn2IdHa37zTJahmzrBn4C1F4oPQPNk=;
	b=HoZqPA94gaSCazTSKuatwr+DXRn57h/b5wi01MAOjIyj08DjIWNH2gdbgX0Iuqyv8g5XHu
	bV44d4f5mXQRcX/yb8AbQ4BpsoUK6d4qlGSMlbHkjM7cP/8htqY9jTK7KpwkEVP29v8Khx
	xjlfWHC9bRgKuvGF8fzT3b5EZ0yiZ/U=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L8OhytB1;
	spf=pass (imf24.hostedemail.com: domain of apopple@nvidia.com designates 52.101.201.68 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775006466; a=rsa-sha256;
	cv=pass;
	b=KBN1jfXokgIOKKdkZmzc2sqZ4oLbjG2E56x94WH6GcW6YIA7UiZzeEAygkFCItzW2M4H1F
	0i5vELAAHrF2ugjzsoVV7Jy9ef7qYXYCoMFdddQYNiWRaEX19vvkvR9ei1NDKsbM7pS4By
	jtXMUd5od1ETv52yrrIxmTcd8Ggah9A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EgrLmrpanX1zCeHEfuWmsbZVNVnU/zUF3RV32JftzRYnjJsni/CCaLKbJQdByq+YUy58GVQ/YAsRH9U30MmyGflGH2gFp9K9S3mt3sz5+psV2NegYm6dy2/Yy1Xwl+vyvv9/X/qeyfDZYVsnR/myfedBfNOPFYMBJPOBlayW+gHpVWZCnb9tVfbDCtx6060XUvAslwziz/rSjBwfJdZW1v6UIKMXqJ2yNSnxNH81XBlv+mT36/VSjq4FUKHu6VJMMz2wXldOv18ICVRh0JMtt40oK8kPxcb+wv+eO9HmfUPJAJNDb2WNJ8pMNGEtOKgq/48/DqAQZFWgVXxq6q130A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ld2M7EY8HnSItn2IdHa37zTJahmzrBn4C1F4oPQPNk=;
 b=y+AMK+ZVXKmaSqK5+zMU/Uq3SosfJ1l/IBJNBOz6RuNbzbSGAcxxIySklmNCwWzcY1JLXzdICsc+/Sd/3nldgsq0D+h+UGixLqE5ua3vi7aHR0HB1I2l+J98i/f9YwiMUPIQpx34fz3MIlpBr4UyCszLBXl7oHzDen+VqbWHBU/HzQF4aKJn+l0S14s2X8T2obrofZfbOxU+/XIJ/4/nhgMUO1WZURmd/WVALVRTfYveiYFOR9awXPcwjo0XGy3MvHHx8xIST9fXoaUAcgbUKvEwhaFo++tS3ljcLbyUw0+xqbFMLsjAXrAweD9cU9XXQuIiGki8VdNTRQyZVBrkFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ld2M7EY8HnSItn2IdHa37zTJahmzrBn4C1F4oPQPNk=;
 b=L8OhytB1yR3yy6Hs5Oe7ITDb32JaGZ1Gjd7oFFRjjQKHj3iOwOk4WpABNH4KXDd1bNNmHodD0MFCC5tzhVzEJ041IXv9Oz6IPYvI1LqdQVBjZ6SfYX+vjx2lHzqpf4BFXtqMgTWcRfusPbGVWzxGSKWoPMOPzVK1kOpVYpuJYNJciI/cYN0pA94oqULRKJeQTN5nUCFO0xBSlkNnC+wtVWSKg4b3gmfCWh09q/AMIWW+nw+YwGR64zYALH2I06SARegOkiQ41FG/BvNRm+fmc8kaFW27hJJMTAZLGNpPjDqDe4N8Cj8xwZaWx+7/S4F5UTxqWMaA2lNOBA/LyT0XtA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.15; Wed, 1 Apr 2026 01:20:59 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 01:20:59 +0000
Date: Wed, 1 Apr 2026 12:20:54 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, zenghui.yu@linux.dev, Liam.Howlett@oracle.com, 
	david@kernel.org, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, dri-devel@lists.freedesktop.org, balbirs@nvidia.com, 
	mpenttil@redhat.com
Subject: Re: [PATCH 0/3] Minor hmm_test fixes and cleanups
Message-ID: <acxxJfyZjDqohVSS@nvdebian.thelocal>
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331173313.a471934b6d6b76e64ab9fa2f@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331173313.a471934b6d6b76e64ab9fa2f@linux-foundation.org>
X-ClientProxiedBy: SY5PR01CA0057.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::13) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|IA0PR12MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ac6cfbd-c312-404a-4ee0-08de8f8cee50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	grkCAy4nx5jrJYjD5/JE+fwGLmE59uFZ7oV8McsCGqS9SXbgqguSK4SRYetKbMcTNr0J8QklST2UWbOJKk9ECjt+HbdxmET6G+ciK1C6tB4J55BWuZMLhwekA/mcJN77ObRCcEh2KPPQn7/Ee9BFC/R7tswq2rg0fqlrIL6zr+7P2vPH4SgI4TzDReUeedJIMJFta3oLeCAXiI5NQAqGcl2oakO8IT8KEKFAjIjuxnrPN4EFnrz9VMySPIwR7FqadBEgxn02ZI7LUlzXZ5sMSFeNGrOU7rI6XCHCzp3xurWU9f2JLxUD+PJVPdB7vOW/6+YQmW455iBJH6J8ChUO+KoTTeX3H5R92x0hBd+Ia6XT+6zIGASHc5/BcZfaCEDCOlXpL9TJ50boezwjUOe+wcz/SjudKBrVE4CcjjwbScMaYudnip4l7KOg+/lvStQja9LKW74DfMEDEonECktNzAU/UnINIkxJUlrDOi+ge5A4KRG3TobqqZjoC+YJZxeJ2upmx4PoIQYfZ5jwtoTTOoFhy6Pup+kFiCtSbVyGRJScmm7uNZZnop8mCZE1RZ73f/5kmlnAvCFFfHZhsktmf+c0XEmxmiwBrkPvysxmTvYvniN+bK+T5CoGr2kKGMs5AHbksm+YVA0SDj/Zr0a0qdGlWZuv5VYt3TXA7GZdsfmMEyiZPrLsIrNacNr36cGhRqLDrKlWKHXOMypC+3SV49vWx+Ib2HVhFllrAD1JHnM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ASeqRZis+2Nht6njL8x93qnsUSL7TnwbNXzAfGxaEHQtU3kvwU1ScVyFCnXB?=
 =?us-ascii?Q?UyCLcayBdtruKpkqBoAsQsv5oLvOjsLEf0LVPMhA74kBwuuXRBTNnnOoPnjD?=
 =?us-ascii?Q?XRcWxa3l6ne0uGPclyrnauV64bEs508gDSXvGcUkx9EzkJ4mal4gqIFtsDi2?=
 =?us-ascii?Q?ZRSXA4bpvS0r+ZeJY1pR0URUkTX5AzniTzima9VzxlLia6qkXfh/T5YI+OZu?=
 =?us-ascii?Q?ZKJWVzUkiu3S8AwhL6Z2m4t8SoEXU1j6dzbtECYCtoRLcK5pUSk8jhAZxJvL?=
 =?us-ascii?Q?fwJnuNYXxBUO13ei9k8ZO4UfzZPld7Ck4t5yS6njtgkgu0ZyH1x+P6+hBMOf?=
 =?us-ascii?Q?iUFbjxAjGC/wjow1Jwu7Cqo1YUucGlcIoW1n9t20nKlNbJEeyRfiHpm9EjFU?=
 =?us-ascii?Q?7x//bNT/aCbWyPGY78frdqI7AVA7EUKN1kIJco1K2hvdm7buOKQ61sayMi1E?=
 =?us-ascii?Q?jxPUWeWFHgNNp8KMn3yNOUWYRB4cm6nJ9rJD+8qd8nBNp4Fq5plnNRjIBImv?=
 =?us-ascii?Q?xkrO+gaxxVJJ/C65G0qMDAbH44PaRQyfANYz1NTlNcKkXvQ7M1jd5/POIAU8?=
 =?us-ascii?Q?cBqNTW4US+LTl6k94o1838Qs8rJfrfz/ul1hV+QQOTaQb/lML8SNnFyik+Cl?=
 =?us-ascii?Q?88CcqCMzU9SK53Fh2yygkISrLneaXL+yPc3zaIziW/MzFV3hxIIm/ffm4RJM?=
 =?us-ascii?Q?m3Gid15sqAzmk2aiDsO+s90md17IiD79pxRay1Crtx1I9bJtF3Su0jXzIuPX?=
 =?us-ascii?Q?WbuFI0IGfPHbRDPWprqQV2kgr+AUQG8Nw1IXPOCl7MsHeytjAYpQ8JWJMRff?=
 =?us-ascii?Q?7D/Bgq3eF2VilRIrYu3aoA6G42aEEkOXN+iCvBXLKboiwTSV1cj9pO3BoA6v?=
 =?us-ascii?Q?Q74Tar4YWnA50XuU+xIlv40tf4q0lZ8gSkzdg6Bi2twaE7/wrD9mBGerbdg+?=
 =?us-ascii?Q?r7k7NfLiZeUNgZQXNv2QbTVVWoxHNhAxO+cW6/5vaBa1i634g05rHA5uW5/9?=
 =?us-ascii?Q?cYkuNWYY4tp+2oPYIhs/l22h4si66ZLWRUFjlM0DJdSPpWhFA+N08qHq5TI3?=
 =?us-ascii?Q?wpDvZS7+tjGdR/u7nzq4o45p8ePmkhb8GpMgnNsva/HpIgyplbOFuEjFfgzl?=
 =?us-ascii?Q?q8lhgcO7L51jt+g0Dn5VtQyPIdc1zYck3ZSGJF6rPvPKIVl5g31xVHLRMEIa?=
 =?us-ascii?Q?B5JmNryHqewI92rhch0v/UerjZ6NWQ6oWsjfETvzdK+U46Ee8B43tDYmgBHo?=
 =?us-ascii?Q?+5AEG6lEnsA+8b7tJopicBCxu68WOr21lqHPOiO4OANpK/3Ka7iGSWWKtdO2?=
 =?us-ascii?Q?xdpbFWmBl6bdr+/2c+UO+m5Kxm9dJ+gvEIVcDpD/OqM7EvgVeSoLUuoBqMJp?=
 =?us-ascii?Q?1OE2g7oT1VcvyfneefpJxfs192BTTrrqwaPxxW7Hcen3Gu2xlBYM2PZEo+M3?=
 =?us-ascii?Q?6k6xw8r9zLiZ3vKeCN+fScJDYc+dTVjF6GvKFZwn503KeBVQi/G7He6faLiz?=
 =?us-ascii?Q?vfbLA9gv5zqBsmidNjmNgXM+BYcgdzS5xm1fKThtRAlSxPBXMevPsEtcNYg/?=
 =?us-ascii?Q?nOn3XduwBTS/1JOyqGBQFisUR+ueNsJTJWX5gpaAX4eal4lqVRIEDdUr0epD?=
 =?us-ascii?Q?BFBFGEMiqy1ix0SOFBv5HmTAW/bJDEBEDIfWd49SMUjvibXMglG/gNLuN6Z+?=
 =?us-ascii?Q?fzhLfXPSLNsL6GVSksNs+3IpUSRE/Yks653JgBUOPfv+4oI/zX9BzIccIwcT?=
 =?us-ascii?Q?W3vrHX86+Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac6cfbd-c312-404a-4ee0-08de8f8cee50
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 01:20:59.3296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vBsC6s59Q01jWi1A5DGqPK+JmyrmnE4DzsxVNjicxHyxnGnxs9+qpt8K5d2S7ktltzbePpPxqnbA1rHZLrs9Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8374
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 84DE5180009
X-Stat-Signature: p4m4sh5944trs9c85cwnm5e68ajdny6t
X-Rspam-User: 
X-HE-Tag: 1775006466-512804
X-HE-Meta: U2FsdGVkX19hPal4NrkxVUIxSUrvq4BEa0bZOQPZoVI8kmF3iRCrC7EmKByOQwb6K6mmG3491fv+En6TI35r1QAx6ry8Z6Z045xye0wkH5Zv41ivfG3RXkwAid0VEtI8PuKurgHQXvn6MyrcsRoqjayc3c4wgC9JkOz4mCiMpT4Xu7cJEm996jv7wDSlCeiR7s9djHMh9H9sk8Kpl2teEdWYAttWcHApqplwkVzENBYD64IQhUMONyx0napJfpZQwg3BjXVMLd/rpDXJQqSdNsbQ+8k2ktOyXrbaaU6Ldje4J2qB7iJzrBQkv6P+XephMK/P8f1pc1C6EuLsoht0QlCNoiqlaWnLyqk/dYpTGpbsEHD3oJ/GXKhTlIxsIj9ATWL4jCGvX6dmNlqBPfXGC5fj9zFbbN7oeeRcHMxDLohAzERlTlzbpC3jN7aGyt884Zv+tKYiKB1vLia7inauwake+HH7kMX1EqdE5MabrJldR/I5fLVr7+mgpJgdiuzEYBjTP3GLozVK8PRQyVUWYyA9+JpcY+4RjQD3qvM3KBczlrALuPLIFJ0jMjoY6PPsvq1T1AK2/niukGi0zScCW8gDgZZfOBlGUqZzv+2pX1FCOiX8csPt8GfpoitBD1t8TDf9AkIZAQ+lo8DWND2W4DRigLgDTVux1ZnVXYzCu7HRyF+yu8Xye4u/Qd97gGod2ckQO+uvfgegD49zgEA7soEdcBNP1Df6xSn38x8tVl0TKCuOiZVYRMXCLBTWNSla9UhIyEgoved3dlLNls+ZvgCINxp79zpHNoMi0aeC1drn+8xnbMcwui0V5g+/fKls9gOwjWDBH7rh9XYUVWE6Pax+ApYTxcyB8G9WKroBvQh+QcdNWkooe1olEy26umyasBA/dTK2YSFfKMyeLTtiFC9xOi6iwlJSL1xwaTT8gBQK0qYi1xSGifKT/PmJz9ReuJWFbIKh8bDTzineDSD
 bRgG2Qaf
 2ovZgHWpbvEr4ysb/+/qAmRKOebwW82a2JwC8RErqHEz7E4oNh5FXL+IGp4mmFSwwJwXcBQEpLTpZ1DdpMQL5u6TGZskZwiH37e4wIoVfyCex0692w7JvVoUmZPgGmMcX/Khnm8DUTTLRXCmrY0E1kAij/DWyFghQF3YUOOInZMq2kciNvfvskCdJe6Q792mvNLbibOL2skFPLMvWoGvwnH5Ew1GDeopxOMyCz+22wyLMmZ4pIGHGrNKKzF/maz1VdHGqQPwKLDIl04mrLzeiDbns47rCtLNMM2LCd4D04CFxxKGfjnLiF/Y8GHjzMsMlpcu4bfH8g3aYSDG8HsJ7eu0sXII1kO7/wJu/E0xNhM+vMWOc6IbexEAiHq8+q9jvkzp8ZjRRmgSkJz3SNOSHREgNwpBlsGsQ8e3N6nOQuQ1rTeSh4tTFgRvLLSlcOe3Av6PpfgWAaoLfMuiEt/eY+MqPZ4BvqLC0FY9yual/Tl97Mo5SBPNVgIlXeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-01 at 11:33 +1100, Andrew Morton <akpm@linux-foundation.org> wrote...
> On Tue, 31 Mar 2026 17:34:42 +1100 Alistair Popple <apopple@nvidia.com> wrote:
> 
> > Just a couple of minor fixups and cleanups for the HMM kernel selftests. These
> > were mostly reported by Zenghui Yu with special thanks to Lorenzo for analysing
> > and pointing out the problems.
> 
> Geeze, if a kernel oops and a ugly WARN are "minor" then I'd hate to
> see your "major".

Heh. Yeah fair. It wouldn't literally set fire to anything but maybe that bar is
too high :)

> I strengthened the [0/N] cover to read "Two bugfixes a cleanup for the
> HMM kernel selftests....".

Thanks.
 
> I also slapped cc:stable on [1/3] and [3/3] and queued everything for
> the upcoming merge window, OK?

Sounds good to me.

> Here I assume that some users of earlier kernels will use that kernel's
> in-kernel selftests.  I don't know how accurate that is, but if they are not
> using them, they don't care!
> 
> [3/3] lacks a Fixes:, but I'm sure the -stable team will figure it out.

Sorry, I shouldn't have been so lazy there. This looks like the correct tag:

Fixes: 6a760f58c792 ("mm/hmm/test: use char dev with struct device to get device node")

Added Mika to 'cc as that's his commit.

> Thanks ;)

