Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C28C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC9D6B0088; Wed, 15 Jul 2026 14:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08CEF6B008A; Wed, 15 Jul 2026 14:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96FE6B008C; Wed, 15 Jul 2026 14:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAC6D6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:05:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2656FC024E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:40 +0000 (UTC)
X-FDA: 84991788840.21.2A8027B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022141.outbound.protection.outlook.com [52.101.43.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3EDAF20008
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=CxijXkxU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.43.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dhgYyHhNx3mFWlfEOgFLcf2FH4tPJUwjwawBC1RyrP0=;
	b=i9KtmAuYMiwLPja4nz/KrSBQXreszDS3vILpZnyPoyDY68UuzUaET70hIcSvsIXWsgOcrd
	pRFHFgUl5Pm+jcsiU9XB1jVaXu6BhDpzIvmWpBxeuzjxxuxnt99ZSVdFFED7fhTLg8E1gI
	8Z5F04VjldYFieM2xNbs1RpLVTiA/os=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=CxijXkxU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.43.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138737;
	b=8qnQKhMmc8oBWfhzBbsHD0ZrgQDS3sj4yt7vQUMzCG2eiGabpjImBdYKmZG7YU6YJx7v9d
	p0/tC1Imtk/9JMi59VeTAADRZsc5Mqb2rEwyX+Nve0DlLqqjckJPlLICOhVjvHSrJ110kz
	dn+dwSvOmYH/CBJgNLDSDbQ6ov5p9J0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MIzyEPXomQYUafbCmTm066o8wMu3Htf7bgPS4Ep2ufxTQlN7eZt8P9spCyrOWcgJ1pQGZX+k753f2htrMjXduwClzqo11FbP6iC2YW5tqUA0d4RTYRna1wf6OI/liqZZUoB6rJ0yXJYkTsaSVusHK7AN+Bt81ZeZYvEoK7G0K4t3VIfU9bIJRBWFuZn5l/81LcvBf2zTU0nXB0vzxjb5x+TUySubapCundyw1mXTKMpdbXyRb9bRn+x9F+ePH1cw+0YT4Q1EbzN1kkbl/CIeI/X0zPBnA0KfhlBDTIbjEShE7F7ukHanmuuOoLyL910Sn6Nxyuyi0kXUJF381c81bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dhgYyHhNx3mFWlfEOgFLcf2FH4tPJUwjwawBC1RyrP0=;
 b=c54Q9q6QLt3Yue+IEd+8aIEkWzP2dTn1l29r0ku1eqyUHaMbZtGQB/7JaYP76zicSTcdcOHK3Vube7qear4F1JeLdpaP+br6mlhTM+W7UTbW5yQUZg9Z3NijbINrUih6yWEcZJMPP2RziHVXI46rubtDjXCrh/0HxIN0Q8z5swKNMQUXfxYTVYw/w9cQIZAJIf5fR1nCgZ2b/CuCfwgGuJYy7pNNK91VI8QH7Oo7mwsJw5NYEeckHHgYd5nVkpi6GIbN50lHF+VSyHaXik52k6dS+Z1Ez4jpPgOz6PRgVnYWQ5CT2Yh9V4A49y8l/lzv5jzaGkUtLIde+JjpPeNDuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dhgYyHhNx3mFWlfEOgFLcf2FH4tPJUwjwawBC1RyrP0=;
 b=CxijXkxUzn+9shMOcPz5otcULHjqGMKRIQiyBObOVBWqrf7KHQ1hyBGaEIO+7SKm+diwrjDiBYAEgYZstBNze0wu/vFq8vsSkJrwcNewJam7HU2afSdJ9RpDMUDu6e7St290FrOi2fQxXWrjmgxgKVi6K2rL+8sh5uxdiQ/HkYg=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SJ0PR01MB6207.prod.exchangelabs.com (2603:10b6:a03:29d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Wed, 15 Jul 2026 18:05:32 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:31 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64 for this series)
Date: Wed, 15 Jul 2026 11:04:02 -0700
Message-ID: <20260715180455.515692-1-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SJ0PR01MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: b735caa3-519c-4802-de73-08dee29ba909
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|56012099006|11063799006|6133799003|3023799007|55112099003|18002099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	TbBw/NGl1kmTmAiqZ+GPTPXsv3UUYtCzUZIqQl3e/yF6SYuWbPaPdQqaL4yFApGgvadEYzi1+lyfOv25SuMl2YYW/dsXSxfHvdRTvDMMjRPUBkZDG8tTOCySDNqUGIUPo8t/JCtR1AcXcP/dHYRgTM1DEjzpCtc01dfq7aoA9Em30nj2KTeeSLdJcC4pa/C1H+xsoBKywYzACsMXeGyAVdjTJtRm/2sVhg899yw651eSYdOaNz0X4z1mxn2+N5j7kollfm89Fc0gWg5J9d/jYKRWV/q9LcEYTsNnDDrQ6PpranQ78h6odaoFiXvboApkXGnGV2zSeyVNOWS2QyPRQyUIlMhd/hwG3Kfkf1xt6u39lhykoa2zhkCiL1hMiWY5hCSufBvN+brZQvB1dQlI7J706PemDqBH60PSA2CV47jOgv+zfJtNU52WO4U0Qg9xbalquRRAXs2e5v90tYPw2uE8x7IaVUuXqIzTfeeYFThzPFueKQsm3XbRZyzjCZBZ7bqoiBrIlldIw/nKBQkgezCFHzsjQ8w2I2vHBJSZaxeUzD9MVm8YmikV5Nzk8RtZiFwtAXQGsi3qaO7HqA3SdE8grM8GhvZZhwN/s/F3uVVun8lRJ8crAdlU+wbTWzX4Rxh2Slp8h3Tw1Kx/HMoofbA9uTiRsCbsec4p9WUgcxgqNZ1f4wC1w8Mmri2+u5V762fcDSaSSqYidna6pqkqPw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(56012099006)(11063799006)(6133799003)(3023799007)(55112099003)(18002099003)(10067099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHovQUFLTEVENThab2ZsNVBvNG9rdlNER2tYdEM0QURJWkhicEVWTWl0V0VC?=
 =?utf-8?B?TCt2UDNmaHhjbUJJMUdFNkRkUS8zeEdZSU04MWY0TGNYbVE1MGRHM1VCWHpi?=
 =?utf-8?B?Z3ZUM0FNTU5JTVg5SmxNU2wyQjhIQXBxWmhoY2dCdU5BRURXTFZoZVFIYk9i?=
 =?utf-8?B?Nkw2anRUcDlyOWpRWHdodzNJNDlLTm9WekgvTWtUUTgxZE0xdm02Mm1VellY?=
 =?utf-8?B?RVdUbHdqd0NJbEJBdWtzNHVINTZmOGFxOXh0NFg3OXYxS0VrT0ptbWdoa0gw?=
 =?utf-8?B?bllVUmQ5M2VWTmpmRmdMelBBaDc3VGtjMVA2RDIxblc1ZERsTXVWWlNJaHI4?=
 =?utf-8?B?M3lzNTI4bXJ1R201cGl6Mjh4R0VWa1JCUUFPV1AzOFNLZFhJRjZDeTFGRzBZ?=
 =?utf-8?B?K1gwSzI0TTh5anJGN0ZIdWxaU0xvb3ZkdHREQlhmYi9wc3dNdnhGVGduenMx?=
 =?utf-8?B?NFNCRG5HbGxHWTRjRE9YTFdMYkhGQld6UGFEcVJoMWNpeWlPRk1VUHhMN051?=
 =?utf-8?B?ZDVNNFl5RFI3dkF3dWkvOXllMXdVOEZ3TW5GYWRvU0xIMmIvbE9KSTZYWlZn?=
 =?utf-8?B?WlhvcktpZFpaelBlQWVOUDNNYWE4UzhETjF0RkpVSTdKMjAyeVdiOWVxZlph?=
 =?utf-8?B?TEZSTUlNK3Z1bDdnclQ3aUs4Uzd3YUdWYndNQkVvY3poVUNlL0dheUdySFJn?=
 =?utf-8?B?MS93SWdzWHdTWERCanpQY1dOazhLVUZIM3B1aFJGY0c0Wkg3L3JPaUhlOWky?=
 =?utf-8?B?VFhuZ1FCRHhYN3ZySFFKUVJrNzRROUl6YmQxc0tBNGFsV21jQnNiSUlxcHNp?=
 =?utf-8?B?NGxFeEsvK2UrNGpkZVJBaXhaelN0TWNCMVhkaFU2NmZWOFYvcE9mcW5Ma3VR?=
 =?utf-8?B?YkZFQmNsTU9vSldnbHp3ODJGZHBSNy9LZ1hpTVljY1Z5TGY1Z0IzcVBvRm5w?=
 =?utf-8?B?T2tNZk11YzRzc1RubGp6OWZINklaS1l0b0M3blZEOFZ5UjFQVDduWlhOWXpC?=
 =?utf-8?B?bnMwanIwVDk2ckhqQ3lDd3AvMUIxZlh0Qzc2cTZTWjhRZWxjZ2ZuaWx1UkpK?=
 =?utf-8?B?SEVzZks0UHFrZ2RwZ1pNb1FyR0NsQng0TmRjUlJsWm1rM1ZaSmE4YUFXL056?=
 =?utf-8?B?MUNvK1E3RndsTS9ZLzd0WFF2R2JHTU1RQzQ5TkpoeWw0bEJ4VGlqbXQ4Z0ZB?=
 =?utf-8?B?ZzBCVHZjMm43T1R3TVpUQ0RlMXdZdi9ydXRucWNhOHQyWUpRb2pwcVdLTWJJ?=
 =?utf-8?B?Z1M0cWc0dURTdmdBYlV6OFBUS2txMkFXSWU5UVlxN0JDMWRPL0NoVGU3SlZZ?=
 =?utf-8?B?TnpvVW5raEpLUVVHM1lEZllkN0tRWVlrY1FpTmk4aVJPYUZQMmdScXpReFFY?=
 =?utf-8?B?L2dNNkdZdnF3czd3TlB1ZFVWdXhCN3liMk85eWIwNmpUYnBjQU15cW1CTjBv?=
 =?utf-8?B?QWIzVHhzaG01VFFUZGVhc0NlSmtxeitZd3kyMWtDWXdSMGVJK2V2TGs5Ym93?=
 =?utf-8?B?K0o0TzNkR1RpMWk1Qi8vR1JXRVR4elVVeWM1bFk2M2swalhUTGlSdUprMjJX?=
 =?utf-8?B?b1N6Tm5waWRHb0hEdjBtR2V2ZW4wRjZuc0k5Wm13NUQzTkgvSFBNV1FMcCtk?=
 =?utf-8?B?YnlXck5tVWs1N25NOXlJMUM3RWZnc3RrcU0zY2NtYkVRVVVTb3U2S0N5NXJ1?=
 =?utf-8?B?SjJsdzc2bzY4VnFqakkxeklhdU56MVRPTVZIOWMrZGtnckV2d211NHVBaTlB?=
 =?utf-8?B?Z1NKcWZRQVlwaTNkUzUrMHdXdmE0RUYxZkV0eXlRb2E3T3c3MGQzZ0Vmc2Q5?=
 =?utf-8?B?NUNaRnlQajdOQVVlMnl1QlNmdTlTb1ExRDJNdWVoM3RkL1FkaDZaS2tHRitu?=
 =?utf-8?B?TUxhRVkyakRGdXVsbEgrdmZUYjJEcm9BRjhRZXIyd0RhNXFSdUFwbUZRbFdp?=
 =?utf-8?B?RlFTakpGQkFyeGxyVWk5S3JWRmVScGpWWDluNUpkQTkvWVBoK0hCQUpBaHhW?=
 =?utf-8?B?WnJteTdFVURXQml5SE1ZODZ0dE0zYUJIOUVtaWVnQWQ0ZFdDa09hQkd1Q3lR?=
 =?utf-8?B?MVBhRnN1TFUrT2hQUHVhRU5xWmM2Y2lpUmJISmU5aWNmVFc5M0UwQkloUWZL?=
 =?utf-8?B?OEZ0WnJBOWNVeEwxMSt1aFYwK2J1N0RHWnRESnlsdlN2RjQ3YnRhTzZLeFFP?=
 =?utf-8?B?Skw3NzBXOEN6TlZDVE1WQzdxWCt0QWloWkM4MHY2NmJUditGdWZYZ3RJVXdY?=
 =?utf-8?B?aXE0UDVnUmtDZnpnYzJkbFNWQ0xKQkR5eEZPOEY2SHAzOHNyUnFlRHBqSnJr?=
 =?utf-8?B?TnR4OTdRU1g5Y1hUTzVyRXhQSTdIN2g1SVVkMkR3cnVNZXpuc3J5clVXaGVG?=
 =?utf-8?Q?Epktc37p92Y60tJc=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b735caa3-519c-4802-de73-08dee29ba909
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:31.8710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KvgL6JDpzeNRXVL1Qlgj5uCdldwTuELpObMI5h0BQ5iLgOCbUjpSU6a+7g3ZKtgUJkxQWBrFAQVN+gDY/NfMYTJ54Uh2UtKGQVvloD/fK3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6207
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3EDAF20008
X-Stat-Signature: hj8ptm9poeyq5ss914qqetqzhb838rnq
X-HE-Tag: 1784138737-694735
X-HE-Meta: U2FsdGVkX192Yoa0YRG3HmY24AZGCf0OmFrC1v7C85qpGTYbBnQ7TinT2C5DYSdMVGXAlak2dffY4uw4uUf3JIPIWxX9ZLUmu+KLbNT9pP7s3jWDOWrumFkRCNy8KWQgU7EuhCv9U7+4BRHc9L+d9AS6M98yMH5vUQkgSAY7AtTg7MU5wV2SgxtUbEP/5qGp+Sz7uxxpPKQxyFIrq6H5a4sIqoh507WZuNAn/ldGfC6Wtj3McfNSbQK7ZHFHf6Lypx1QQ3aOpSv18UFijkfHh9n5PStW2Ow73MabVDkePszAAS+aErARFhbqkwalejoXdQrd/3u9Vt7FJ4rduI73Ge3NBnY/kslFqW+eAf6/vbucf+Ox1eEH02dKUDpTufREAxbuySd0JzVmnpj4vznqmOn2X6zO2LDtiaGGvpvgEIHKZzozEnKbboBoSx5Wj3BfslK6hpEw2yH2E8CiicYijqP6gWmcl0Fxg4a6byTna0/m8gQYxQoGVBpDCup1ppurqszw6i7nbf2Eu+9JD/ZZyiW9xAeRS893II0oTd6px1Ient+bz45JLxzF6za9vtsz72k++ksSeX/XXPSNaF1ioI1TkgWF9YtAM49h7QS7EhKs10kGA5X2Hb2ozwj2xGQx9hyWxYxic+osD/jsyOFMCmClwmifTQrexlhOhtBNq1VzcaettutAwK5Ci34QD+S2IMIyu4MO4uBxnqGPMd2hwyghwdv/QyXAqNfWXise3PSS9l2E5fen5mwLO6P/9nbOyk0IOampmUrDPx/jXccdcvdUgVRJe4tX+kb8D7Xvarf8jKX6SWmett64aKrtT+k9L5HjN996x5oavaA/6SAGcx+e6yNZ2OJEC+Y3VlCLv2iciMNB9Y5bk+s7pnLqFoMFZU3xPLDhj6D24Xf6sEtnY0xU+yFzHA3uoZZeshMAczQusT4SpeGEpCUO76Fm2uHqcfH/nYg/ITxMUdKkDk2
 ZXD6C6Zd
 5GD1wRREV0jErBOI/CVeMNtgUgLYJxNAf8nu8jDyzk3Ec/9c+UfIIW3QFr/H2S0DL5olCYI1/gPd87dvSEb6Th9cPUyGPm+bpql8Isuoa3hhkhLI+ZMId+Le30PGCjWM33DYHjKL4b0rUXxK1LRBYycSV3nD8jqVn9qNcIpEL6901yfUS3wMV+8gjoKplZgoKyigpFcu3JqVvwpZ47z2E0S3CxJpcWPpPHWpufo0xr0IMWI/vIe5GN8MZ4wK0bX1ItrjMYbEhDsBagKpH21wHOe/PyjarDMf1GOBooudl14ujuj+VKSe/qwJeI4FyNQw8lMP2sb3+3e7YHbowh60CQ8W9+MTvsOVU43FqwCLRwa69VpsU57Nl4zoVQj+eQT2faJVWCKI3gMBXvaaiOZlZpqbwj7kSCZxo/4IkHiYN7h3bPGCgNnEvXz8doODDrFPAGG5mYItLa+9G2GsggrDoYRvOEHHrXdnZ4bR4BVL2AQnPavTA6QhgQ26CB30Lq8QHd6/BsX1fPMfXNtgh8I3b4K/qjoMvOp6/8JfG4osQMW8tShWhFJLNzMYLersyznjxNo9WXlZg46pIQaIuNP4i9ZvincSYNE++0cweniBZTe/Ig0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi,

This is v2 RFC. In v2 a lot problems found out by Sashiko were fixed and more
feature gaps were closed (please see the below changelog for the details).
Although there are still some open issues, for example, it just can support
48 bits VA (for 4K and 64K) and 47 bits VA (for 16K), KPTI support has not
been solved yet, etc, but I think the delta should be big enough and worth
a new RFC to gather comments in order to make sure I'm on the right track.

Some more benchmarks were done, for example, some latency related benchmarks
that I mentioned at LSFMM because I thought responsiveness should be improved
due to the removal of preempt_disable. Collected more PMU counters as well.
Please refer to the benchmark section for more details. 

Look forward to comments.


Changelog
v2: * Added 3-level and 2-level page table support.
    * Tested with 16K and 64K page size. But we just support 48 bits VA (4K
      and 64K) and 47 bits VA with 16K for now.  Please refer to the below
      "known issue" section for the detail reason.
    * Added support for memory hotplug.
    * Added support for KASAN (generic).
    * Treated percpu and local percpu area address as vmalloc address.
    * Fixed build failure for x86.
    * Fixed build failure for !CONFIG_NUMA.
    * Added KASAN support for local percpu area.
    * Some other misc bug fixes found out by Sashiko.
    * More code refactor and cleanup.
    * Regorganized the patches.
    * More benchmarks, refer to benchmark section for more details.
    * Rebased to v7.2-rc1.


Introduction
============
This patch series implemented the LSFMM 2026 proposal for optimizing
this_cpu_*() ops on ARM64. For the details of the proposal, Please refer to:
https://lore.kernel.org/linux-mm/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/
I didn't repeat it in the cover letter because there is no change to the
proposal.

The series is based on 7.1-rc1. It is basically minimum viable patches.
There are still a few hacks in this series and it may break something,
for example, KPTI, SMT machines which shared TLB, etc. But it shoule be
good enough for now to demonstrate the core idea. The main purpose of the
RFC is to gather feedback, figure out missing parts and risks, and make sure
we are on the right track, as well as hopefully it can help the discussion
for the upcoming LSFMM.

I broke the patches down to arch-dependent and arch-independent parts so that
hopefully the interested persons can do experiments on other architectures,
for example, S390, easier.

A new kernel config is introduced, HAVE_LOCAL_PER_CPU_MAP. The architectures
which can support this feature will select it. Allocating and freeing percpu
local mapping is protected by this config so that others won't pay the cost.

 
Known Issues
============
1. KPTI
-------
We need determine what CPU we are on, then switch to the right page table.
Currently arm64 kernel fetches tramp_pg_dir via swapper_pg_dir - fixed_offset,
and fetches swapper_pg_dir from ttbr1. But ttbr1 may not hold swapper_pg_dir
anymore except CPU #0. So we need to figure out the other way to handle it.
Switching to tramp_pg_dir should be easy, but the reverse seems harder because
tramp_pg_dir just maps the trampoline vectors.
Maybe we can do two steps switch. Switch to swapper_pg_dir at the first step,
then switch to per cpu page table (for entry) or tramp page table (for exit).
Nobody should call this_cpu_*() at either userspace -> kernel entry stage or
kernel -> userspace exit stage.

2. SW PAN
---------
Has the similar issue as KPTI. It installs reserved_pg_dir to TTBR0 when running
in kernel space, but fetching reserved_pg_dir via swapper_pg_dir - fixed_offset.
Maybe we can save the physical address of swapper_pg_dir in a variable, then load
it from that variable instead of ttbr1.

3. Shared TLB machines
----------------------
Some machines may share TLB between CPUs, for example, SMT machines may share
TLB between the two hardware threads in one core.
The per cpu page table just can't work with it. Maybe we need a new
cpufeature to indicate whether per cpu page table is allowed or not. Then
just enable it for not-shared-TLB machines.

4. Don't support all VA bits
----------------------------
We just support 48 bits VA (4K and 64K) and 47 bits VA (16K) for now. For 4K
and 64K, supporting other VA bits is not hard, we just need to determine the
size for percpu and local percpu area.
But it is harder for supporting 48 bits VA + 16K page size. We just have two
top level kernel page table entries with this configuration, but we assume we
just need to sync up kernel page table at the top level for now. We need to
sync up kernel page table at the second level in order to support it. I'm not
sure whether it is worth it or not.


Benchmark
=========
The benchmarks are done on 160 core AmpereOne machine. The baseline is
v7.2-rc1 kernel.

1. Reduction of kernel text size
--------------------------------
The patchset can reduce at least 11 instructions for this_cpu_*() ops. Both
preempt_disable() and preempt_enable() need 4 instructions to manipulate
the preempt count, and preempt_enable() needs more instructions (compare +
READ + compare) to determine whether reschedule is needed or not.
Because this_cpu_*() ops are inlined and called in a lot of places so we
can save a lot of instructions.

The size of kernel text is reduced by ~184KB with default Fedora kernel
config. This also helps reduce kernel icache miss rate and stalled frontend
cycles as kernel build benchmark result showed.

2. Kernel Build
---------------
Run kernel build (make -j160) with the default Fedora kernel config in a
memcg.
13% - 18% sys time improvment
3% - 7% wall time improvement

5% fewer kernel icache miss, 5% fewer executed kernel instructions and
15% fewer stalled frontend cycles for kernel.

3. stress-ng vm ops
-------------------
stress-ng --vm 160 --vm-bytes 128M --vm-ops 100000000
8.5% improvement

4. stress-ng vm ops + fork
--------------------------
stress-ng --mmapfork 160 --mmapfork-bytes 128M --mmapfork-ops 500
15% improvement

5. Specjbb
----------
The specjbb test latency curves showed the patched kernel has consistently
lower p99 latency (the lower the better) than the baseline.

2.5% improvement on max-jOPS and 4% - 5% improvement on critical-jOPS.
The specjbb benchmark is quite sensitive to latency and responsiveness, 
particularly critical-jOPS result. The patches are supposed to improve the
responsiveness due to the reduction of preempt-disabled critical sections.

6. MySQL
--------
1% - 2% gains on read-only test, 2% - 4% gains on write-only test. Also see
15% decrease on frontend cache stall.


Regression test
===============
1. memcg creation
-----------------
Create 10K memcgs. Each memcg creation needs to allocate multiple percpu
variables, for example, percpu refcnt, rstat and objcg percpu refcnt.

Consumed 2112K more virtual memory for percpu “local mapping” and a few
more mega bytes consumed by per cpu page tables.
No noticeable regression was found for elapsed time.

2. fork test
------------
stress-ng --fork 160 --fork-ops 10000000
fork() needs to allocate multiple percpu variables, for example, rss
counters and mm_cid_cpu.

Roughly 1% regression was found. However stress-ng fork test has quites
small address space, the real life workloads typically have much larger
address space and do more complicated works. The stress-ng mmapfork
benchmark saw 15% improvement.


The organization of patches
===========================
The refactor and prepatory patches (patch 1 - patch 4)
Percpu page table support patches (patch 5 - patch 8)
Local percpu area support patches (patch 7 - patch 15)
Use local percpu area for this_cpu ops (patch 16)


Yang Shi (16):
      drivers: arch_numa: move percpu set up code to arch
      arm64: kconfig: make percpu related configs not depend on NUMA
      mm: pgalloc: introduce {pud|pmd}_populate_sync()
      vmalloc: pass in pgd pointer for vmap{__vunmap}_range_noflush()
      arm64: mm: enable percpu kernel page table
      arm64: mm: defined {pud|pmd}_populate_sync()
      arm64: mm: sync percpu page table for memory hotplug/unplug
      arm64: kasan: sync up kasan shadow area page table
      arm64: mm: define percpu virtual space area
      mm: percpu: prepare to use dedicated percpu area
      arm64: mm: map local percpu first chunk
      mm: percpu: set up first chunk and reserve chunk
      arm64: mm: introduce __per_cpu_local_off
      mm: percpu: allocate and free local percpu vm area
      arm64: kconfig: select HAVE_LOCAL_PER_CPU_MAP
      arm64: percpu: use local percpu for this_cpu_*() APIs

 arch/arm64/Kconfig                   |  12 +++++++---
 arch/arm64/include/asm/mmu.h         |   5 ++++
 arch/arm64/include/asm/mmu_context.h |   9 +++++++-
 arch/arm64/include/asm/percpu.h      |  37 ++++++++++++++++++++++++++++-
 arch/arm64/include/asm/pgalloc.h     |  24 +++++++++++++++++++
 arch/arm64/include/asm/pgtable.h     |  37 ++++++++++++++++++++++++++---
 arch/arm64/kernel/setup.c            |   3 +++
 arch/arm64/kernel/smp.c              |  44 +++++++++++++++++++++++++++++++++++
 arch/arm64/mm/kasan_init.c           |  47 +++++++++++++++++++++++--------------
 arch/arm64/mm/mmu.c                  | 165 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
 arch/arm64/mm/ptdump.c               |   4 ++++
 arch/riscv/kernel/smp.c              |  51 ++++++++++++++++++++++++++++++++++++++++
 drivers/base/arch_numa.c             |  51 +---------------------------------------
 include/linux/mm.h                   |  11 +++++++++
 include/linux/percpu.h               |   4 +++-
 include/linux/pgalloc.h              |  13 +++++++++++
 include/linux/vmalloc.h              |   3 +++
 mm/Kconfig                           |   9 ++++++++
 mm/internal.h                        |   5 +++-
 mm/kmsan/hooks.c                     |  14 +++++------
 mm/percpu-internal.h                 |  14 +++++++++++
 mm/percpu-vm.c                       |  94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/percpu.c                          |  58 +++++++++++++++++++++++++++++++++++++---------
 mm/sparse-vmemmap.c                  |   4 ++--
 mm/vmalloc.c                         | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 25 files changed, 712 insertions(+), 144 deletions(-)


Thanks,
Yang


