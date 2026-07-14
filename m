Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90EFCC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703DD6B00A3; Mon, 13 Jul 2026 22:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4446B00A5; Mon, 13 Jul 2026 22:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CAC06B00A6; Mon, 13 Jul 2026 22:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10A616B00A3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:15:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7228D1601F3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:15:48 +0000 (UTC)
X-FDA: 84985766376.29.580AB97
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010019.outbound.protection.outlook.com [52.101.46.19])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8BA32C000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:15:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AlgBfdCg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783995345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsnnM91XRr4h/OQyXl3GF5DVG7WrnExQxZitfbNVlWQ=;
	b=1+AQcU1PRjlPBQTw7+gyqdo6yDkkILE/rZEQKBgCaDSkUY5JcDwv86I1XS4V1xBF1/wrnS
	gvQB6lSyWNc9ee1ThhfoCDFuE4lBkXCdxuY/T5HVBEXfgfgfv/0Hbc68JYaUd9swd3x/Fe
	qclq/DH0YHAzLyUN9UPEBdn6Wr8/aqM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AlgBfdCg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783995345;
	b=CdjunyiBdg/clFBFXKvoatVDE8qlbkp3oGoeCJuXTzrXp7TED3LNhmR5sZEIxeimGIK8Dh
	jXhZvWbt0aJWLH1693q2BDthiEDHdyjurkbUUpEz+p/fL+1VT/gTVjW1ltppZiCFUlhq/3
	th1DSgqmUu5vuiuDJHkenv2n8MCFGgg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQ/wnzX9N9iDRHo/IN9ilRNdQYG4ve23hdTbrBJ7f48kigYA7YCE3MItOCK4vvBM0ygvgd3EOmnngdQGP0qWD5ZTRectxybp8i4bnxIj9XTNJro2OdayfBuDHHcMlL3538u4+VXOKAIePRtKt94gh5XNt9JYYLcwmyy6qWFEX120tGfGM7Pw+hIqNCcTZV3dohYVUlbNbpDELrbWheofvddxZLG1KzXGT6KndYqxrUb3XmMS8bIqcsgyyydm4bDHJjreWK4Ym9eSDAnou6sflXOPVP8ekZkhHee4LSLHYbpMmmHSUWViMyVzN9bRBIMycuFooXk+r9q+C7zrfE2ErQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsnnM91XRr4h/OQyXl3GF5DVG7WrnExQxZitfbNVlWQ=;
 b=zFJkSbufb3R1G6MNCwsKomrU1+Zgx1iHs7Km3cTGf3kMY753tb/bJoCBcq6QvQLp3K/SjJW44nveCR64SMrKJJkU26wjQJw6D4xrJ2PAkoJDFFc64VNacpXr5RwQoE4IOO1PW8x+jsQtx14RRFV2gjKRKtjxLmecLy9dJ4qrmjigcFvKND3vXUdAIpwzFqYtfgJSLI0rzhEUBijo/1/YOt425NsScj18HgmyrbB2hv2I1lT4GGihLZk2cx7YcVS6LZj6lOCoTUGm12Hq40i7KwdIiC2PG7UpgtlJsKAntbXIRDUMNYvsx/9e4z2irHmpznWpRcEwJ6h5VBA6qfNaOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsnnM91XRr4h/OQyXl3GF5DVG7WrnExQxZitfbNVlWQ=;
 b=AlgBfdCgA3R5EsDXIv5Zosmr9pZav5FtYaDBunoodRFnA9tCOVc+S8HS53gY1944OgtNDxonjacBJzYgqq4mogXYlE9hpEi317K0jff4Wk9MXUXTsGm/ZhnqW1TRX0Fo4rlvxJSsf7t4fTSxFAlSQGPz/Gien9gKdBtE5OVcUjofE5kO0NxOSMD6FLkfhHMa9sdDxjiLIkHaN3pPHfxmHEHxV3HUntaiwO0oscUG9lsQbjguciOBW9ZBXFBQrg8mu61l7ZDn8p7cypWR+sqpEvCNn7zvSuqLKK/LM7JY048LtQhEmlaE6Y8CmUoCIRjDB1qTZ9uK6k1fnapkOlQS+Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM3PR12MB9392.namprd12.prod.outlook.com (2603:10b6:0:44::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18; Tue, 14 Jul 2026 02:15:40 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Tue, 14 Jul 2026
 02:15:40 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 22:15:40 -0400
Message-Id: <DJXXKH4KOBVQ.2I9NU3EJL88HA@nvidia.com>
Subject: Re: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 <linux-mm@kvack.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Hao Zhang"
 <hao_zhang_kdev@163.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260710071344.GA106129@zh-pc> <alDSekC_5t-29vJS@thinkstation>
 <alEWEColDdwQboYX@192.168.1.215> <alEg6ZPc-ao7s6o6@thinkstation>
In-Reply-To: <alEg6ZPc-ao7s6o6@thinkstation>
X-ClientProxiedBy: MN2PR01CA0040.prod.exchangelabs.com (2603:10b6:208:23f::9)
 To IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM3PR12MB9392:EE_
X-MS-Office365-Filtering-Correlation-Id: 30ab989a-6580-40fe-be21-08dee14dcd3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|11063799006|5023799004|4143699003|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IOY2STPfep16Ypd/S5gwJS1KknFeEhxaLq5vwZg1vs8eVERR3m0RH3DLDbOdjVtu2dkUVx/bQKJBhJqk67i/sS8pzHLbUaV3onKl2OhwEE9ol84w37ly0e+PzUvL53cCcT8Tt2kpVoxF//r6zc65k4eSYfKqcQYULoiTuqa8Aaa67c8/ANbjwTrkXoh/4vrgKjjW4RQI64vUh5dnshyaLzjASZm/O7MWEGj2JNTVN1KWLWUMNoAjGED2GBbJatMe7BcFsc1AQloCFxOLgaJTzB2wglo97cbFmB7lutj96zdBKMkQzqFfFXl+C3VWDUWwy3/DZvPC2JkvesuT0nHw1q5xCV5CD3PaDXnyzVJ58wTiPigg6wdxumg7Ru1rMY85eB3xuTRV+zdoNo2hboQ2ulwTrv1bk+XN3Z66/JG6izSiVVjMGn/rFb6sGr/QurIPJ7PKRBXb2OUxZYZTFB6BfRjxkC5I9OMUrVa4nC5r9E6og4BitntwCJmz7tQJedWbaAw7tK8WRPKoggbrzA101NPZMlDF38G0Y9sgi2TfYeJaAziGTL/0zYLr21ay/3ZcOd07B8TxKbwNqMPtTggb6jGjUPmbbviMeAwpEkDO+5MPINIaJDe4MwCHbMrmveiH04epQroU+jb552M3HMP91wRpu+GXc7Rk7+kQLGEjZ1A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(11063799006)(5023799004)(4143699003)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXBUREk0Y1pKbWNDZWpaOER0QWlraTZkL1lzdGN5NGJ1b0dFTlBhZ0FhYzdI?=
 =?utf-8?B?V21HVjc1U0hHK1E2SjVNbGdSQ0l2SlYzREsrOGVFdjZFTm5MV1NJRUZUeXp3?=
 =?utf-8?B?UWdZQktOM25yWXZnWElReWxxbDFDandEZzVTRGlIRHRzdEZ2dUhYQTZ4MGhC?=
 =?utf-8?B?YnZKbUxpK0kyUzVkUDV0K1dFcU5oamRJcEVNbCt4RVZxeFgxR2lIbEF4dkNx?=
 =?utf-8?B?bEZFMlR1ZjloMkVmbU44M2VhTlNBUXF0SHlTRkNRTFRsL1loRXpFblRMdnFs?=
 =?utf-8?B?V3RoYVV6ZFVmd2hHckNlZFlHUDEwWldpV1FyWlRmTjlPZ05lbXUvQ1NPNG9Y?=
 =?utf-8?B?KzluWldxRGN2WHlqY3FqVXVVU2RWeFI1RlR2NDU0VS9oeXdDcFZsZUl5MHBr?=
 =?utf-8?B?WHV6dlkyUEVMUVVrQnRaMEUrM0NOMlpsNC9CNFdvQkNtWkVtdXpmWGpiSkxO?=
 =?utf-8?B?cUJnUFZSSllMSkxBVXlHQU9TcGFZMjY4ZDdsUURnZTc3bDFaZm9jbFVGLzNw?=
 =?utf-8?B?WWhjRTJvS1pDSitubVVrWkNSR1FZZy9kdWYrSGhXUjN3RkVUdnc4KzZRR1RX?=
 =?utf-8?B?N3BZOE84MU5UK212QTNGVkhDU3dIc2MvMkFYL01UY3UveWNVSzNVSi9vaHRv?=
 =?utf-8?B?NWs3ZWw4OUFZOVA0VTUyUnVwOWJzWld6c3B0TU5tRzhiNmI4WHdIaWV4QnZv?=
 =?utf-8?B?RG41Q0x2OTh6RHhSVVNWK1VGaVEvZXZ5NnVWbzZoQ1FwNVNLd3lXRUhlQVEz?=
 =?utf-8?B?UGZIWExRVkh6SDR4T2NXQjRpRDUvc3l6NE1CNTUzQWVibUVWZHgwQ25BNHBG?=
 =?utf-8?B?Y20weFFmdnZFbkEyRUJDaWxmZlZIbGNZeUI4VS9kdzV5YWVpbWM2aGNoL2o4?=
 =?utf-8?B?TmN5dzBSSGxGejBxZTU1d2h0RDNwelkyalNPd1Y1ZlpHMXlQSXc0b0NCS3lr?=
 =?utf-8?B?SHZyMXFFbHowUlpOdHViQ0JzV3lzOFFKUUJteUJVMHk1SWdyM0FtM0NTVGJW?=
 =?utf-8?B?UFBSb2pMRTlyRFVKdDV6ZXhDUFNKT0dOdXpEQkN0YlRFbDJkN3hiTTJRdklz?=
 =?utf-8?B?VWRxNGtWcStISTRWcG04WS82c3llUXJQcVN4VU9RdDZUOXJHSndvd2dLck5L?=
 =?utf-8?B?Z2FiQ2UxR1FUQWh0VmxacHVuY3d4alN1a1Z6Y0FLT25MWFJMT3VqM2l0QUY1?=
 =?utf-8?B?eEZmSmdld3cwM1RGME1TSDlCOE41WVBPWDB1WC9kaDFnNnBlTVFrY0JVYVFR?=
 =?utf-8?B?bENleVBKUnhWRkN1bUlJcDZQQWVET05saXBpcWhvU0R0aFRFRlgxTHdOa3o5?=
 =?utf-8?B?SXkvOEwyV00zWmtMU0V2U3lNdUQxS3FlYnVZeW9ER0RpOEhRL2ZTWTU5QVRF?=
 =?utf-8?B?TVZLREw0cWoxTFJsS253WmlGSjZraFN5UkJJYk80cDU3QVd0aDhIY21KMjJr?=
 =?utf-8?B?RGxXRFcxMmJhTnNJLzM2VU9UODBZaXhmczlkNE5wZzFtdisrZzBJUkt1UkVu?=
 =?utf-8?B?L1lPT3BqcmxXQXJ2MUxDY1Q1TDYvdXBBZUIzUE1lc3d3VzIrV29iZndDSHhX?=
 =?utf-8?B?cXB2YURianRTZEhaVDVPMDk1UGdpS0FhT1hOVzBnZ3lhcm52ZVpxWG4rMTBR?=
 =?utf-8?B?aWpmRWtrY1lTZGx0eEYvWHkybUI5cEJBUlAvQVNZbExMUjdIWEJaSHhxYll0?=
 =?utf-8?B?UXFGTVByRk1TN2liaXVnR3pyOVVWWVRJM0MvTENtakNYOG1tYmhjbnJxekNq?=
 =?utf-8?B?akNMTXVjbCtENjNaSWJvRnh4OTNrTGhkbmMvYlRINlBDWGljZjZkWVlwd2x2?=
 =?utf-8?B?b3BGMFBncXFWTWYvNXM4bDg1cG5nQ3I1UHdPWXhtZ3RWbHF3YVhKcWU4L01L?=
 =?utf-8?B?aGFYaERyY3FHelV6K0tER1dGOHhoQ0xoOUlFdXJDWWs4ZHJKbVBjRjJsTGI5?=
 =?utf-8?B?UCtVQUVpYjZXMkdyREpjVU8xVnFjc3VMdXV0bjZOMHhTY3NrNEwycjZzSlNo?=
 =?utf-8?B?MWxXdjFPVjRpNmdvU3MxNksydkhad1YxVlR6YlBFeUJWa0l5UEZkSzNFRXo1?=
 =?utf-8?B?T1NOUUVNN1RtS1RZci9LMFlDZXkwN2RhLytxdlRBYWxjYlBkb1ZCSnUrMmFj?=
 =?utf-8?B?L1JvN3dieVpvcEtaOTFJWnZxSTI4bXI1Mm5pMmsvbTRGL25ZSVRTamp0Yk1h?=
 =?utf-8?B?OW5nQzdlY3dLcFJDQk9FM3g4TEJxR01jdGJNREZaTGIvdWNtRUJBZ29qc2VZ?=
 =?utf-8?B?ZlN4bVVyYTkvUU0zcExVb29tcEFOUUZZSHkxdDhwbldNeFJEdmRIRm8wNnZ4?=
 =?utf-8?Q?lNaNuyC2KlLVMRwf9j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ab989a-6580-40fe-be21-08dee14dcd3a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 02:15:40.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I3rCrzUfT83iCejeFQVgFROZVIXf6ORTDlFR+8lejH4gZQ/OCi8p23xZDUXRWR0U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9392
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8BA32C000E
X-Stat-Signature: paomegmkd7xoxj5enkdtwf8osw64wrzy
X-HE-Tag: 1783995345-835950
X-HE-Meta: U2FsdGVkX19cDCBK3U81PaMBn2SztHRFqqQxnG77xoEeL4PBQXlwSFCWdPizPpPOE6WrizzmCDxg+M4IpAY4mWCwxJWY8T/DZpEg08Dvy26J372+KuIEmefmVn7f8kKMrLt/fhyN5hL7heGY1jr0GQRPX3iPyxW7pGzrCXQBRexkrii02KfR3hFi1CSdu+ps7lq1k81rPo26Vmh5cSX50g+2nzaZercLQRn3enIx3kvY8y728MGPsgLDIxGCLI4m65ek9TvH2Ctk7HhR/uD9xaTge2h2EgJaEmybHsSwOTgH7wQlTClZH+BJcu28J9INe+QEI5JM6KNEQB3BABbsb1BjFpD1Jd2TWTqOEwb+yYnH5/uItQgqBxu0Rv9Qme/pErv6STrTfDufOyv5VLQuE2h/mNkzUFh5/ZQwh9KKopD+Bzx7WUtEz88D+SvqBEaLpXQDXmbZrVRDo70ceoMkh0M8cO2ejZnpAFcVesjJehb1s+6fdgvklMpBPeV6p/KblbvP7/PZ0epVWhDYz2/EOALSeN1Oo+JxmB9LKeGT6yE7Ojc4+082BJS5FNwk3N3uI7ZfLLFzoVjHumvWsXZhY5cW1ulB6UsdLwAaX4QqpLtHNwp9KArag1Rqi3cHOkCJQhjrCLgRBl2xd3s73STNK4j5eFE8DmS8wh3fJHowAvZrgDjjPkgk00Q3C5WjSU+tJEGGdyvyCR1jo0J7wSXHxQcgOxakFhy+D371cZLxbrvQrsbhSU/ChGJ6/aRXLAfU1wOW4fK33O8IMu3G4sv+cAEPFX+vjAqPj2iGpRZKiZM1RwNPfxpdNp/VgxhVd7L6q7rqdrUC1A6R93RZCd7uVNlUb26iX74HxlHkaBEE8dXV4sIyb0smGIXBoqHFtAtx6OgseWhG5bsmxn9aMwrdNYHnlGADf+bx6Kx4QdZYyTEgkLjENZrm20xMa1EojcWD/35U3nVpwj66wUrE2R0
 EB4Hljjr
 8ATCZhV01FGScY7bZ1j88NqlcDzAMXHDi+ZDVmVPMFrNfrPhv5MNKRw5ekO9xzgi/Y/MJwBoA2iWlf7+h1iMQlu3KeRt5H5owgBOk+OY9wTYo6v4rvInbCsoYAfUVZAz4plKyDZ3wjk+FSMk/rD825+j+nQga/QXGQQvKt5gUlvlzcyRIoWU6UP03x65iWISs2Mckv9cJuMaJz+dHHfVZWZccuK5Zt7oznrsK+44htW9vnPM5Fyab0Pz+kMEYrVYBpqZo7w1SOgaMwJ/4vIU7f5nQI3beCW4vhtgC6RanCmFPPUu4w3yIeRUKFMKjhUq7ysfw/Ed0Oewx7iw2r+goIRjjhlEZPHHj3ziVdwTWfcDLvHem4llQTlsnTCh4ibqTgl34SUlUwP5Q50nBYt3o7dghLWRGqf3AmHJ3wC8d4zI9G96CA/XVhK2Y9BY/aD1pMPtFalWJX2JG3U9/A6tun9jlhnIMTWS4GXjHTfMK7HqFb8AvIVpdhJBMFgeMc1NnmWmLinLYVZfgCFSeSQlssPY2VY3Q50OffEeXuQGbKsozo2dV0sED3XzX6xpROdXFLJD5qxXqkYnvYdLJc6iOiJzz9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Removed owner-linux-mm@kvack.org from Cc.

On Fri Jul 10, 2026 at 1:17 PM EDT, Kiryl Shutsemau wrote:
> On Fri, Jul 10, 2026 at 11:56:00PM +0800, Hao Zhang wrote:
>> On Fri, Jul 10, 2026, Kiryl Shutsemau wrote:
>> > On Fri, Jul 10, 2026 at 03:13:44PM +0800, Hao Zhang wrote:
>> > > From: Hao Zhang <zhanghao1@kylinos.cn>
>> > > Date: Thu, 9 Jul 2026 16:30:00 +0800
>> > >=20
>> > > __folio_split() takes mapping->i_mmap_rwsem while unmapping and
>> > > splitting a file-backed large folio. The lock is currently released
>> > > only after the split folios that are not returned locked to the call=
er
>> > > have been unlocked and put.
>> > >=20
>> > > That leaves a lifetime hole. Once the split folios are unlocked and
>> > > their references are dropped, inode eviction can make progress throu=
gh
>> > > the final page-cache truncation path. After the folios are removed f=
rom
>> > > the page cache and the last inode reference is dropped, the inode th=
at
>> > > embeds the address_space can be freed after an RCU grace period. A l=
ater
>> > > i_mmap_unlock_read(mapping) then dereferences mapping->i_mmap_rwsem
>> > > from freed memory.
>> > >=20
>> > > A possible race is:
>> > >=20
>> > >   CPU0                                    CPU1
>> > >   __folio_split()
>> > >     i_mmap_lock_read(mapping)
>> > >     ...
>> > >     remap_page()
>> > >     folio_unlock(new_folio)
>> > >     free_folio_and_swap_cache(new_folio)
>> > >                                           evict inode
>> > >                                           truncate_inode_pages_final=
()
>> > >                                           destroy_inode()
>> > >                                           call_rcu()
>> > >                                           RCU callback frees inode
>> > >     i_mmap_unlock_read(mapping)
>> > >=20
>> > > Release mapping->i_mmap_rwsem after the page-cache and reverse-mappi=
ng
>> > > work has completed, but before unlocking and putting any of the spli=
t
>> > > folios. Clear the local mapping pointer after the early unlock so th=
e
>> > > common exit path does not unlock it a second time.
>> >=20
>> > I don't buy this analysis. We still have the lock_at page which is loc=
ked
>> > and still in the page cache. Inode eviction cannot complete past
>> > truncate_inode_pages_final() until it is unlocked, which only happens
>> > after __folio_split() has released i_mmap_rwsem.
>> >=20
>> > One possible path how this can be hit is if lock_at ends up in an
>> > after-split folio beyond EOF and __folio_freeze_and_split_unmapped()
>> > removes it from the page cache. Note the drop loop starts at
>> > folio_next(folio), so this requires splitting at a tail page (e.g.
>> > memory-failure) racing with truncate.
>> >=20
>> > But that's not what your analysis claims. Please share the actual cras=
h
>> > reports. Let's get to the bottom of the situation before changing the
>> > code.
>> >=20
>> > --=20
>> >   Kiryl Shutsemau / Kirill A. Shutemov
>> >
>>=20
>> Memory failure: 0x5a6a7: recovery action for clean LRU page: Recovered
>> Injecting memory failure for pfn 0x81bfe at process virtual address 0x20=
0000ffe000
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790 data/linux/kern=
el/locking/rwsem.c:1353
>> Read of size 8 at addr ffff88800b81c5e8 by task syz.2.11034/45874
>>=20
>> CPU: 0 UID: 0 PID: 45874 Comm: syz.2.11034 Not tainted 7.0.0-rc3base+ #6=
2 PREEMPT(full)
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0=
-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>> Call Trace:
>>  <TASK>
>>  __dump_stack data/linux/lib/dump_stack.c:94 [inline]
>>  dump_stack_lvl+0xbe/0x130 data/linux/lib/dump_stack.c:120
>>  print_address_description data/linux/mm/kasan/report.c:378 [inline]
>>  print_report+0xd1/0x660 data/linux/mm/kasan/report.c:482
>>  kasan_report+0xec/0x130 data/linux/mm/kasan/report.c:595
>>  __asan_report_load8_noabort+0x14/0x30 data/linux/mm/kasan/report_generi=
c.c:381
>>  __up_read+0x634/0x790 data/linux/kernel/locking/rwsem.c:1353
>>  up_read+0x22/0x30 data/linux/kernel/locking/rwsem.c:1633
>>  i_mmap_unlock_read data/linux/include/linux/fs.h:537 [inline]
>>  __folio_split+0x732/0x1640 data/linux/mm/huge_memory.c:4100
>>  __split_huge_page_to_list_to_order+0x7b/0x140 data/linux/mm/huge_memory=
.c:4203
>>  split_huge_page_to_list_to_order data/linux/include/linux/huge_mm.h:385=
 [inline]
>>  split_huge_page_to_order data/linux/include/linux/huge_mm.h:389 [inline=
]
>>  try_to_split_thp_page+0xab/0x390 data/linux/mm/memory-failure.c:1675
>>  memory_failure+0x1394/0x26e0 data/linux/mm/memory-failure.c:2470
>>  madvise_inject_error data/linux/mm/madvise.c:1487 [inline]
>>  madvise_do_behavior+0x4ae/0x8a0 data/linux/mm/madvise.c:1925
>>  do_madvise+0x162/0x230 data/linux/mm/madvise.c:2028
>>  __do_sys_madvise data/linux/mm/madvise.c:2037 [inline]
>>  __se_sys_madvise data/linux/mm/madvise.c:2035 [inline]
>>  __x64_sys_madvise+0xae/0x120 data/linux/mm/madvise.c:2035
>>  x64_sys_call+0x1bed/0x25e0 data/linux/arch/x86/include/generated/asm/sy=
scalls_64.h:29
>>  do_syscall_x64 data/linux/arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xe2/0x14e0 data/linux/arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> ...
>
>> Memory failure: 0x81bfe: recovery action for already truncated LRU page:=
 Ignored
>
> This log line confirms my suspicion.
>
> The UAF fires at i_mmap_unlock_read() while try_to_split_thp_page()
> still holds the poisoned page locked. For the inode to be freed at that
> point, eviction must have completed truncation, which is impossible
> while a locked folio remains in the page cache. So the after-split folio
> containing lock_at was no longer in the page cache =E2=80=94 and the only=
 way to
> remove a locked folio is the split itself: the new_folio->index >=3D end
> drop in __folio_freeze_and_split_unmapped(). It requires lock_at to be a
> tail page, which is what memory-failure passes.
>
>         CPU0                                    CPU1
>   i_mmap_lock_read(mapping)
>   __folio_freeze_and_split_unmapped()
>     __filemap_remove_folio(lock_at)   <-- beyond EOF: leaves cache, stays=
 LOCKED
>
>   /* no locked folio pins the inode */
>                                         evict()
>                                           truncate_inode_pages_final()  /=
* nothing to block on */
>                                           call_rcu() -> free inode
>
>   i_mmap_unlock_read(mapping)          <-- UAF: rwsem in freed inode
>
> Your fix moves i_mmap_unlock_read() out of the window, but I don't think
> it is complete: shmem_uncharge(mapping->host) a few lines up also touches
> the inode, and its nr_shmem_dropped guard is exactly the beyond-EOF drop
> that triggers this. So it is in the same freed window; the patch just
> relocates the one dereference KASAN caught.

I was discussing this issue with Codex after I saw Kriyl's patch and the
iput() issue raised by Sashiko[1]. Hao's patch might be still valid for
shmem_uncharge(), since all after-split folios are locked at
shmem_uncharge() and prevents inode from going away. So the rule is no
mapping/inode dereferences after the after-split folios unlock loop
begins.

But let me know if I miss anything. Thanks.

[1]
https://sashiko.dev/#/patchset/20260713170915.239819-1-kirill@shutemov.name

>
> This is a lifetime problem, not a lock-ordering one: __folio_split()
> relies on the caller's locked folio in the page cache to keep the inode
> alive, then removes that very folio. I'd rather fix it by pinning the
> inode explicitly -- igrab(mapping->host) up front, so the inode is
> alive), iput() after i_mmap_unlock_read(). That covers shmem_uncharge()
> and the rwsem both, and won't regress if someone adds another mapping
> deref later.
>
> See the patch below. Untested.
>
> Any opinions?
>
> Hao, could you give it a try?
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..9bfa3a879453 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3982,6 +3982,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  	bool is_anon =3D folio_test_anon(folio);
>  	struct address_space *mapping =3D NULL;
>  	struct anon_vma *anon_vma =3D NULL;
> +	struct inode *inode =3D NULL;
>  	int old_order =3D folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped =3D 0;
> @@ -4053,6 +4054,20 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>  		}
> =20
>  		anon_vma =3D NULL;
> +
> +		/*
> +		 * The locked @lock_at folio keeps the inode alive: eviction
> +		 * cannot remove it from the page cache while it is locked. But
> +		 * the split drops it if it lies beyond EOF, after which we
> +		 * still touch @mapping (shmem_uncharge(), i_mmap_unlock_read()).
> +		 * Hold an inode reference across the split to be safe.
> +		 */
> +		inode =3D igrab(mapping->host);
> +		if (!inode) {
> +			/* Inode is being evicted; nothing to split. */
> +			ret =3D -EBUSY;
> +			goto out;
> +		}
>  		i_mmap_lock_read(mapping);
> =20
>  		/*
> @@ -4135,6 +4150,8 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  	}
>  	if (mapping)
>  		i_mmap_unlock_read(mapping);
> +	if (inode)
> +		iput(inode);
>  out:
>  	xas_destroy(&xas);
>  	if (is_pmd_order(old_order))




--=20
Best Regards,
Yan, Zi


