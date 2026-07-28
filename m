Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B95CC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABEFA6B007B; Tue, 28 Jul 2026 11:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A964C6B0088; Tue, 28 Jul 2026 11:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADAC6B008C; Tue, 28 Jul 2026 11:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61B616B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:29:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C66841603E9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:29:41 +0000 (UTC)
X-FDA: 85038570162.25.CD945BE
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011043.outbound.protection.outlook.com [52.101.52.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id E71A714000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:29:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fqsmh0Dv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785252579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L88v0JQduFg1Aactd83eQ9lKeolN+STJ8d062QBCPNA=;
	b=hHh2fyg4SSOtpuYqbRTcuYHA79eNKwx6xPNLeTzbBC5jY5yPfHgkOotLwNztaK5wm15n0z
	zXx8nW9QaPL1AB/B0VQtG6x4yTZZ7spmMgoJ0VaoCaXxjzL1lTV4OY/ZP8XAVUgNywkY/W
	pKWyoKy82p5k+8xYNSHubLfE5P8FROY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fqsmh0Dv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785252579;
	b=agtYBfSMXaIGjih9geaKNsE3+9sjNkXuQ5e1iWlMAeT8fN8H/RmB2t6MfscaAuGbjDegP8
	5LeDZ4MiWTfip5zz3LXhI/5S27EpDBW8bYOV4PRAbgR8/CwhCwic6hbFPri+v53WbKjfIi
	fVoLFYfibTcdx9xeaR8UFj2RzuPHnlI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbSx0cMnxmUv5rtLe2qHyIelYfY+/DwBv/pbGI7sMhEM8hI9nkeWvVPDkF2lccMk0axYpTY3HMnpoGDpLLGt+u2PFlb67rewkJfoC5L9XS2DYHvGpqm0kcBXlbUqguTn5t4SJGxwQAdnud4vQ7MXHv8Ijt2fqIe4vggRJbu7VYgc86xEBdVVEn0VNXCyc49Jh6a1H+5E6HnMnyLFCcrLQWTagefyTIJa6ph/GptpKg4wwPPxlcYECa/hBbD5Nu4ZxspaXbFKERk0cCrjGYVc3RdRHSCYPk87oAEdJcupZwfzS9r6cSTCEEZsScM52rX+Mxb4XgtjLFpdXZtW4XPsFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L88v0JQduFg1Aactd83eQ9lKeolN+STJ8d062QBCPNA=;
 b=Dms4Hna09DcewWCtnjkIwdGHI8iabp+ynTFjw0tVMxP3IAKSUSPZQrGwX6Ah6vWdWCPxY8iGLmEOXK7YWYh/Fr7hI+gPk5ZDgxbfKpvm/VxvIwDD0U++ReanSqQEFnMixxsjB/+7waywx3BjyGsmyU2mnSOC9QO4gYROZING82BEOIfIBeyn9V9nGJVfvXUem6CfG+kBMeriNYobDPpjI9KTvsQZvGcIxRE+lrqXolnjp2NgdbTUJPG7EpHr8CmJrIEZR4gSI5CIAwBGhGE5DCBMhUZnqBXAqESg+0rBtJU0eiTejgEVv8RONh9YQboOntKwvjYAuG7S7tI/rdCrvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L88v0JQduFg1Aactd83eQ9lKeolN+STJ8d062QBCPNA=;
 b=fqsmh0DvKQi0A3Cz5cyPjbLcrWXFsHADIsozIrVQpBsRJnnPrtSI/m7nuRVxR8ywkoYlvzCV43VV7/+dGQUpSpPz7M/jeOOuY5jxu5LrKX5OasfjnWXYslh1qH9BoZXanY7F8WJ403HOi4QUH7ZeP439GPlG+dnnzm4fp8/fuUrcDiskkYdvGqqoFePREvYHMiDQx2te9MJOKU/Fg1lSw6RXWeI+GHnErOkNn58gvqdg/DhESQET7L/hMuJXRlbvEy4FNbuiRUOUNuUZ/Y2UWYq+ecQ3K/+J+ezJrxikx2KEPYlZ/HSMxcRoRRzWN7FuHOmZeGNOBR5qMjwMsg2cjQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW5PR12MB5684.namprd12.prod.outlook.com (2603:10b6:303:1a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 15:29:33 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 15:29:33 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Jul 2026 11:29:32 -0400
Message-Id: <DKAB7XNPH1GY.3SQENETD9J2VX@nvidia.com>
Subject: Re: [PATCH] mm/filemap: __filemap_add_folio() restore index before
 retrying
Cc: "Kairui Song" <ryncsn@gmail.com>, "Matthew Wilcox"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "David Hildenbrand"
 <david@kernel.org>, "Kiryl Shutsemau" <kas@kernel.org>, "Chris Arges"
 <carges@cloudflare.com>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
To: "Hugh Dickins" <hughd@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com>
In-Reply-To: <562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com>
X-ClientProxiedBy: MN2PR20CA0046.namprd20.prod.outlook.com
 (2603:10b6:208:235::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW5PR12MB5684:EE_
X-MS-Office365-Filtering-Correlation-Id: 716cdb10-f207-4f11-7ac2-08deecbd065d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bQ9Oxs+uDXoiWopRgetEaO3EPoZqbdgTqrK4qH4lZDToZgzxgMyU52O5ca7eQHF5hVI+rC/EucwAElCO9+DEjBSeipbj2v2zeLcIR5grf+SB45PdNf8RaUEynL7Lc1DxGpl/MilWeYwESvZlupfr/73z2t9pch6PWwpe4eoEPVe1UTrtPTBIe7mFQ8iuQmoXAEs7apqKqWXdmVVGwFpt8tu5GFBHkyU1OcUxstO1koclg7vMlFhhsTJ51h0HAtGRblRWsDOU6Fwe0ZHKBr3J0W60wVVl9Es3AcRirbnM1TIVdzt72Yox9Llbw75nLQuFHk1izLC3VCl3sVvdR7xf9a1HI5AfFcFe+4k7RxTWHSTvHxuuTZjSXKMUn3sf1HPzInEC/tVFGnXLBKjdNf+DBBoYasGXbLZiLa6ja8r55aJafP/k1mQTXa9tBEZ5BM/3LclTvop4wmFgxCkXRLx4SYrsFiaRnfDz+4Pkgy8ds0IMNtZzNknjNK589GCeghwM7ReuinhJxtMwqKfU6Ip7nBCmSJ7YbxrBHiqT88IGOeBEHOP8wkLcVpp5VoKtO1O0oczx5ocrrlNPe7dwaDn5Y5IZ6qBm7CK2BIKq0p27TIof/g2U546ncc72h727pzUuok//AqqWhSytr2in2XBbdVxi79USByjGCGZ1tGDNMJ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1JVMzltVm5sdUk4VzRxM2pVNHNscjkwTythb0RXR1FBU2pmMkFpeDd3cW5K?=
 =?utf-8?B?aTlEd1pkTGoxWTJvQnRFVGFvQnpVa2JqSjZodFR3dWRkRHdrdmJxU3AwQVMr?=
 =?utf-8?B?UENvVFdDU2ZiMCtoNXZXakpjRlhZRXEweGFSSFh3SS8wN2xqYnZCL2lsSnJm?=
 =?utf-8?B?dTkvUjdsVGU5QVovZ2tEb1FndFc2aXh6dTFmSG5rSHlGRnc0dWF2NG84RmVN?=
 =?utf-8?B?aFNTaWdEOFlGTnA5V2hHUEJxRHNWaFYrVExwVUdZRVc0dXhEUUtQd1hHWmNO?=
 =?utf-8?B?VVBzQmJCTzJlazlnUTZxd21vaFFPanNsM2tENis2STRtR1RIMm5XaENUdU9h?=
 =?utf-8?B?YldGV216REt4VmxPYU5IanBkVWQyUkNYclZhWVU0TG9WTnZ5ZTliSk1BSXR0?=
 =?utf-8?B?VXBNRzV2MG1OSndYbTdTUlFvd1lPZ2lIMjcwVTlPTUtMU0tJQzExaFc1UjFk?=
 =?utf-8?B?bDdvdkpHcVZIeGFZdGRWYzlNL2E1Yk11NmxSbGlISXB1V3d6SGxTOXlla0g1?=
 =?utf-8?B?Y0hZaGZ0UEJiUW1aMjgrb3ZSVUZ5d1o5VzZFUzFoSGFhSjAwMm04YThGcm82?=
 =?utf-8?B?cGtQT0VDVmRSc3A3dlVHakZ2S0FSOXdDTUxKM0ptMklESVpqWm1saU51Vnls?=
 =?utf-8?B?R2RjeXl6cXhZNERhMkE2RDBPcURlak12NXordEorVG1DUDgrK2RNaVdpR2FS?=
 =?utf-8?B?ckl2VHAvUDFyZENQZ0Y3NkpVaFMvOHZLaG81YmdwVzZEV2t0Q1JDVm1FVlVm?=
 =?utf-8?B?Mml0Y1k5aXkzT2VnNDJhdWxtdGZLVWkyYjRYU1IyUEh3bzQ5d0NGaGFLRUcr?=
 =?utf-8?B?Q2t4WnhzbklNUStiM041RVA0bHNVdmg0clkwNGc2eFNoaDBncldpOGFIMTdX?=
 =?utf-8?B?NUZHNForQnlMblUyenVQNXRwZzAxY2lobFVBWkZ3M0VpdGxmWjdoTm5iUHFJ?=
 =?utf-8?B?M2Q3Ui80U2xuQlVObnlQODByVDFRbGdEakFGSXgxaVRqdDR5N2FHYlYrRTVm?=
 =?utf-8?B?L3ZPWU9mdXZQL1ZZRmJWY2lLUHdjdEtMZFUyOFlrcFZQZitJWUt3azFPQTAw?=
 =?utf-8?B?UHBqNS9EcVNlc1dBQ1IrNklYaW9GcS9YU1c2ZzVxbTJvL3hTdkdndHpLTERl?=
 =?utf-8?B?Q3c0cXluTlJGcUZiUWVCQzRHa1NhaS8zN1F6U0lQZGJpcStGOHk5WVcxeWZz?=
 =?utf-8?B?ejluM01GSWZrOUlEdGhLSVA0RVlNOFBIc3lPMlFoZ1BlMXFXcUcwN3M1SUdJ?=
 =?utf-8?B?by9jMVFETUhVUlkvaHBTNHdBKzhMWEFHMUJnUlRzOUFDTi9tUkZtTDdxNFBK?=
 =?utf-8?B?N2lxK1pzci9hTUhqVk1tbUtEQ1preUk4L3VYZkpobm1Db09pRWNPL0puUTBJ?=
 =?utf-8?B?YXZ5elcrWGt0Uk42SEtZbWdrcXpvVTNqVlhmcDNGNEZNbmdnTU03MjZhcXBJ?=
 =?utf-8?B?UlBYRVhUMlIzNFg3cFNkU1p3RC9rcitFTWEyK1pNQ3h6ZnZ2WVh6WmNJYXBl?=
 =?utf-8?B?ZkhZbjdmMXlOV1JONXNWajd6UHpiRDRBdWlJdTEvS1BSZUdDbEViKzhnbnRP?=
 =?utf-8?B?bmVBb0tmODNaZEZtaGlxcDNtQUczazVsTjc1TUtzNVl2cEF6cG1CbE5hRW93?=
 =?utf-8?B?UGpYRjNMc0gyWUtFOEpjd25TOXN3MXAyRFpIRXg0Zkc4YVJpVEdxamdDZFM4?=
 =?utf-8?B?UHJpL201TWROOXlpOVNVOXRrRlhieXk3RURwL2xScEdyWWkrQ1BtdFJkOFhM?=
 =?utf-8?B?RE9SZ2RXd0xreVRpSk8xMDg3eGoydnhrWmtPVEQ2a2hTQWhBZGFZWGMvYWJ4?=
 =?utf-8?B?UG1GQkdrMmpLaTJQLy9FUDd6RXk2TXVNT1BIbmJkQnN1MTFUWjRhcVk2aE9Z?=
 =?utf-8?B?anM1WkNSU241Ung2Z1FKdytVNEI0T2l5UEE1bkpWdFZ5VUdCdHRncUp4WW1n?=
 =?utf-8?B?OUIvZzhPamNtcnJNemoveDBxNlBHUEIzdjFqVGZUNGFjK1dmL2RCajVUY3hh?=
 =?utf-8?B?bWRtSVhXT0NCMFZMeDlaMFNsYnh1MTNzTTAycEhRaHdWUEdXTVhMSmNMQjlZ?=
 =?utf-8?B?Vm40U3pJb3puWkZVczZrM3lMVklNMWtXK24rclRzY3hvQjRCR2U4WFczbnNK?=
 =?utf-8?B?TUNKVmRUZkhJQThFYlFvT1V6bFF0OHFmSSsvcmJhQU5sVW5FNHkyaFVSd2Vh?=
 =?utf-8?B?OSszWU5vTmNKa2hNczV5L0R3L25Wa1ZhcHpaUG1paTlNUmdMMmZ0Slk0Z3B4?=
 =?utf-8?B?OEhvNFZTZDl0YjE5YWpPTldoeXJ2Y25Id3Rvb2tGOVlvb2RGd2pSTklmaGEz?=
 =?utf-8?Q?4N4TmzS0FKexxM1XGv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716cdb10-f207-4f11-7ac2-08deecbd065d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 15:29:33.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7dz2xnTOKb0NERFj0E+WyPym5j0+7iLzbd5ZLOEoMgCkqMiv0geHVXwitFwOJAI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5684
X-Rspam-User: 
X-Rspamd-Queue-Id: E71A714000B
X-Rspamd-Server: rspam01
X-Stat-Signature: nuxfzcwt9sy8xygqdtf5wb7z3kogjnqm
X-HE-Tag: 1785252578-237061
X-HE-Meta: U2FsdGVkX18Ioe3hAwHbcsNhwwpEvmAIjyLaT7ffiILEWR+/+STX2n7q3H1L5xR3yntekv+aCd+x6KpHrE86QqN4+Id5XGzuN4f/y9eV1bcNVuBWde0xV74BzMVO55CF9E3M7kySvBfnzA41/rSiksLP/KXuZEulkaT78MFOyfCFtKOTsDq2zEmWuZAa7pHLUivTj2ZpMLepbQ45PvPAq1X6qIB5DpJlnXLMZTClTKMyE10bGXAYSDCGYiSqyJd37Ek5vn/of0N78LinjYCG0oTA1eLxWiLE0fzIEDPii9XZ/0aA659JUb8CyNuT510lIMAhxe69aRnhrIkURQXCZt6gA+VolEnq8mIEc1CzETeXwxpArFtw3NBsKIXH0sBS1dB2rsRC/Q5Dc64JXJhVKMpFaN7PvtWX0wKjdOy5hniSAuuKvvE15x0GJMX2SsA8OQx/rrgv2CNlhxrHCXvSF6iBgcxH+Ww2qwuHDralfBthvHUBFdGt1pjtkq21sF3qDZOeiIxmWXOsVM4lZnu/YY89DDkwJBHraGcOFpVBsvODfYqinq5oTDavkqXowe3RFJrQudkgEuSEF7VhNKiNXNvtbRIVHCWcz0W62S5riBeOq6SWSsXhOj0CyZhcWbsXBBrCH4+DIlJaUvC8lG0/ipmXu4aXWCNJjX58I/WY6hFoebOPqra2Bheef6OWTg1EWnuIpA99Px1DisVXyPfIu9VP+6vzou4Sce5C+U3HGIC5l90rncCTD/oM4PQasLmMIzfQH/hp6IKAqD7SDHzOXNpHCQQXMG6BecUwcvgV2wC9WwOl+ViycWt7XLsmDRmyaaQZadPNkhqK/XDbN+gOs2uhxKvr1houvvT4JQBZfZ23HZT8rYrOGDByrgxVuyzhLp2p141gU15OpL+Vfqby35G1gOz2gSIjXJuXgP1UYmDTVQnmt4gWNqi1oeITcsYmF/9MVMN5Of9B28Pu5G2
 ADn2co1C
 l5VB3DvxcmVxlSfvnR1N49pRy0FSs6rLqdou8YzwtSXYx6/siLuQa8YtULtgIzuOCL7+HGXK1oSoQT0+kCBzgD2DPmOVeDthHL3EejxzafjXoQ+zXrk8INvkzjAx79Te44EibUKjHG7AcSpjDr+zp28dxnDfEJMYRKE2IUBkhA/yHSFF7jeybHuC3dqYBnohwOpi8iCec2Bqj/9Ls1+aVVFJrqDKOccw5ReTfNMyNB/Xl57PI+B6wleyCf1WC2WT8gsxg27oRtasJtdCGh9a1zM8Z7BYbuoyUT57llLXCqA/LaNNNvoFSd9MRsi2iLTOBivgaB7gRcZ05p6gk8nUr74yNjEG0mJg91cnWsBIvUhxDCJIV7/GeRfhsONI8B8FGCFl7pF74Xci14Q+/MGnNOSX55ZJGbq80fRo4LPrYNQ7QBIgz5WSidNFRGZce65zXROSBUeXwYVYMiB/WRMR7g/aBjveX26in+LhuUhfU0ujEfnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 28, 2026 at 1:24 AM EDT, Hugh Dickins wrote:
> In __filemap_add_folio()'s split-a-conflict loop, xas_set_order() is
> applied repeatedly: each application modifies xas.xa_index, rounding it
> down according to the split_order attempted at that stage: and if all
> goes as intended, it eventually (or immediately) converges on an
> xas_try_split() to the required folio_order, with xas.xa_index now the
> same as index: then xas_store() puts the new folio into the xarray there.
>
> But if a new node was needed, and GFP_NOWAIT allocation did not get one,
> the lock is dropped, xas_nomem() used to allocate, and sequence retried.
> If (that part of) the xarray is unchanged when the lock is reacquired,
> no problem. But what if the conflict was meanwhile resolved by another
> thread (perhaps even doing the same thing, inserting a folio at that same
> index)? Isn't there a danger of now putting our folio into the xarray at
> an intermediate rounded-down index? With !folio_contains() bug to follow,
> when CONFIG_DEBUG_VM=3Dy is checking for that.
>
> Fix this with an xas_set_order() to restore the original xas.xa_index at
> the bottom of the loop, so the retry does a full re-evaluation after
> reacquiring the lock, and cannot reach xas_store() with the wrong index.
>
> Production was suffering from rare SIGILLs and SIGSEGVs, executable text
> found a page away from where it belonged, !folio_contains() bug hit when
> debug enabled: symptoms not seen since this patch went in.
>
> Fixes: 200a89c159a7 ("mm/filemap: use xas_try_split() in __filemap_add_fo=
lio()")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/filemap.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>

Thank you fro the fix.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


