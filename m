Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58730F3D32A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BECF06B0005; Thu,  5 Mar 2026 11:39:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3B86B0088; Thu,  5 Mar 2026 11:39:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6E16B0089; Thu,  5 Mar 2026 11:39:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97C816B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:39:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D828B6FAD
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:39:56 +0000 (UTC)
X-FDA: 84512571192.01.31A678C
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011052.outbound.protection.outlook.com [40.93.194.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B1414000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:39:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kItICPwc;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772728793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fe6QRHBvqwN7PNv864bxeJuP+0EfPI0q28nVHEcUp08=;
	b=MQHE/bJmsnv1une/T5an/FJ8e/1CQHqsZaT0RuANeLpjf02KOEcr7PMIvdV5gjIHxv6a4J
	7HVTESYqiuHlswvszXx1+xs6zgu6h/r/41O+KcJUiJv9W3JgQcaIoftsIWBepA3yHPl0Xu
	VZpb6nTSJBFvyZExE+cO3O0Zj6KSms4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772728793; a=rsa-sha256;
	cv=pass;
	b=b2XwoOXGASbjuH0HOmwlFs+cY9Ao3Hcoc6kwH+nk6qurkFXR/XGbJ3zTY9KnezZewBKM39
	asWDB4CMM7mmYAY/8E5aDCo9K4h5PzR+kBnBOJvEYkDYUB716QcoHFWlgRPE5ZekDbo9VP
	0fJlTQeZ0Z+X775lb50p4arGqU++mEc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kItICPwc;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NoWhj+UarhkQeFWiCPrds/MmB2va0gRnxfsdIhC6c3nhRLdpKpCjrJb3fAL0JfNi28Mm15WVarjA5AohxRUNq3yrmiCAq9hiZHp1hSdwpnECnXwVXFeVLX23HW57EGuWNTj4xmbKNJSfY1dTi6HhoWgfvVjgcSASHjYCdB8lsTUmmXz/iH7PsmL250Dqd0BcdtjxJK4qhNYZs05lwKSjlhG9BzSSHVYFUtiF+ZUdNYGeXJJan6FuyQrpda8VOku6cKskt1q/JS1/tsHyUd9ZA+9+4CJwPfA1PjmKWqIkicZUHRKYjOXblqQ81H3e+0NxHCbqJdj9CoG8b7EbtyPYaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fe6QRHBvqwN7PNv864bxeJuP+0EfPI0q28nVHEcUp08=;
 b=nLAVpZ71/DioutnbtMCy0h04WBgCsJ8vfe887ic0IbuY3DMNBZVu9qckVLmdEw84SWlK4d7U+PkUAwKG9VOuJjt9tba8lERjxbPqITzrASgU+zeYBR5GpWGwZcc9glELxc9+FncVJJvI9IhsBklPW6DZIAecE4GxqAEvZGMgET0VOgE4ktkVbvRjEk+EWj/jhbQsIc9bZut5Dmpw8/TvE0gJpsVhn9bU+HhlCCFBEXD23rRBCa61z0cGK/edHu6/bRrGWCfhtjxxqo+ZT4fD76npcuecHWqHxbyxnQ9BNVXmXN+vXKYRMiynP5tsVAjol454ofbdd9BDxuLJqNkJzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe6QRHBvqwN7PNv864bxeJuP+0EfPI0q28nVHEcUp08=;
 b=kItICPwcCd4rGTJJQeNkN66i4haUUyBVlY+Y2oBmOo+rnzs7SSmHXmCp1vAKRtxnzDwrIfw2qb7p9yJ/3JumKyQtp/iKRAiJxUyl8E9bdZ/4yUtO2Bu8ur6LyvywLXFWH/1uZWC2pyYW0RL9xaLf8P18qlPXQwp7ekPg/rba9Ujxby0n9PXSfQU4n0ss1EVi9PxhpGGZYlC9kBSler1go0tiLd4Xmk4P+pjxkbUz25YoBBWRNINnb2ydMl2oWb9+IJ9FnfQf930BtnfY5IB/PwLmLJEJzZEIHFojDxbEcGn0djyx1bZJosidO49+sUvue81EEtlgGBWjbixz5LquLg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18; Thu, 5 Mar 2026 16:39:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Thu, 5 Mar 2026
 16:39:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 matthew.brost@intel.com, npache@redhat.com, david@kernel.org,
 Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Date: Thu, 05 Mar 2026 11:39:40 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <CDBCA254-3E40-4BFE-81DE-70DAC9D4222D@nvidia.com>
In-Reply-To: <332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linux.dev>
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
 <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
 <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
 <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
 <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
 <80683d6d-ea38-4326-af5e-e4c173bb1930@redhat.com>
 <332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN0PR12MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f755706-c001-4654-658a-08de7ad5cefb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	dD64gsaSJJ24W2n5c+zTPDRt9dWoT4VjLTJd9LDJjhv3SbLeTRUgp01cXxyrhRYDFIbD5eu5VR+KSRt5T8ZytcnJXGpu4epph+vhu1y76DWZAFNw27/iWV6YWDxcLDuCkF+ykxhd8tg0iK2kxxmAV4dPV/RxtVMmSzzmK5h4MHdlf8mwYbCEPV4AktvSa1F6CPoVrvEnNOPLJGrCURqXdCMjYah5BrFUE9pYVY1+0ZNxkP4tRIptmhz6WJCzOrjW7g7UTevwh8GZPNMOvUwCMXOlOpsqYxyLA0HIycWTTK+eKXSvHU9WHlPbZs7nzwbJRhFAWCsRlnIp9VItxAbZr6hUjk8+AICOglyLn9YcIogp8Xi/CqIhYcY4IJFHBC1+N3fdpQaf9iNckomXyCdDgVqFBR7fJsZDXTN40RU2mkmXYeGXdYOnPPiQVXxxM6k+CUhGn4YtzUhQg2m32h0ka3WnztLMs22duxqPVu0h5Mv/UgzOI5GyZBJbMnkkV5AHpw52FJZXCEgQ6zoK9SBzRjC8OJmORr3sEQJHzoRWTRGenaau+F+W/X8fZHAPb7mpyAreW3g9zzWES2JKYhoYqBMAieEjx+O/wpaBOt9U3mJy8GRGzdA+X9bCNs5p8EsZ05oyN+eZiSedO6mBqeL2i/HIi6/n9Bho3pJWvaGRkI8gqJU/SLNV8UfolafnxWCA1x9YBak03nk/hMjcs2QAjWvD8GtQCyVf0EkvPFo0r/0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXIvZUc5MDZzK2hObTJ2WWxweENka1htdkRwVjZEbTJiM1ZxYW41Vkpza2M3?=
 =?utf-8?B?OHp5dmkrdXVlcWhNV3hxRVNVS3lFL3JVaHdDTW1HdjA0SEp6YXdoaFc3Q1lD?=
 =?utf-8?B?cnBkWWwxY0ZQZzlWbkRFSUZ3c0hWQ0JqRjdOOW5NazNZTlNBeFUwTUFTL1Vj?=
 =?utf-8?B?cnZGbzB2N3BlK2RDbjdpenJZdkpZVzF1Q044OUVXSWF0dUxaVjZOOEczZkxR?=
 =?utf-8?B?ZE9ucmZEenhSMXUwb1daU1NRN2Y3UkhnRGtQa25CSGRFa3lOZ1FpWlQ3UlVQ?=
 =?utf-8?B?RDdFdDNFYUZrNEVodzBwdlhjL0duSGFncFFGeXFyV3FEemdiWSszK3FjZ0l2?=
 =?utf-8?B?OUdSaHZBL3Q1WDUvQjV4T0FMSDNkSVh4cDQ4TU1TdmJnSlFuZ0p4L0V4QlZw?=
 =?utf-8?B?OTljZTA5ZzFvZnhScjRtMnBZTTJEZEpyRWoySVl4aFRhUU5ZSlI3YTVTN1p4?=
 =?utf-8?B?bUVnSWJESU5JU3VjU0k1cjZHdkxzOVN3cDM5ZGtwYmF5ZUNHUWMxOEpUTW9W?=
 =?utf-8?B?TEtGd1YrT21nbWlTNWVjMnpXcjNpMHBmc2owTkJnLzdoUHdRUXY1VXZqU3BX?=
 =?utf-8?B?OHFIMGZyVUxLdGZtaGdEOXY0VWo0NVVEejM0NjBpbE1UdHNFdUNDY1Y1TXJI?=
 =?utf-8?B?MWIrbnNneHFuNFdUbFUrNzdVRVJyVkJMaGoyVjRSVWdrc1NaVW9ibXBBa3Vz?=
 =?utf-8?B?aEVYU2NMdnlLN1B2aWg2S2h5VTJObU40YjlqNEZqbWYvWlBsNFZRNG1lekxr?=
 =?utf-8?B?U293NTd5VE9zLzBVajJSazVpQlVJTnkrMHJpZFBuNDdqMDgzVjdiZzVwOTkz?=
 =?utf-8?B?eVV5cGRjY1hwRFgzTGgxUkQvSzZJWnRJNTg2NkF4cjhuTmtHeHp0ejloMFJz?=
 =?utf-8?B?MkswZzNLTEdOZG1jeEZQNGFUeXRPQWFpemhSUmlUZ1NhZVFGRHhLc3ZPMkZM?=
 =?utf-8?B?eSt5UzNqSGYxOU5LZnZiN3IrNnYvbDFkei9xcmNVUHdrTldSS2tKcnhTMkU1?=
 =?utf-8?B?c0tmLzRsemljNlJKZWVET1hvRlJBTW5CK0ZNdTJoVkJveGNkaU5CUktVM3dk?=
 =?utf-8?B?UWtnbm5sTEZ5cC9ncklMcjFPU0ZjZkd5dlg4ZzBjZXhnSGJoKzFBbWNQTnh5?=
 =?utf-8?B?T3lSVjhhUVhRdHdEWGJFaWU1aDF6VUhQNHo5SG5vMEM3NWJ3TUJOWEd2ZzAz?=
 =?utf-8?B?ZS82ci95VmhGbkxjVTU2R045ZmtNRFZjL2FmQWFmS1BqS3dFV1JKcHlJOHZZ?=
 =?utf-8?B?QzFqTXlrSGphbE9zcnA1OFExcnFnTG0xenhWTHpaN3FVU2wrSG02QXFRVjAv?=
 =?utf-8?B?RjB2aWtEQ2txSzd0S1d2enJCZE5uaFVBRG4rbEszTWVGejU0NEN3Y0hpcmUv?=
 =?utf-8?B?RTRHcWNQbDhBT25xK09vYWVkYk1BbTFDQWlDZys4T1JRSjVPMHNVVXBkWFJh?=
 =?utf-8?B?NDV5cUFWU29yT3pFZUpIa2tyblJkckg3Y3dEZnNPWkJYbWUrM2p1OU5XaEJ4?=
 =?utf-8?B?aGxiNm5XVXdIRnlQbDhzc1IwRnJmUFBOKzJ1Rm1samUxS0s0RmdTM3dtRzlF?=
 =?utf-8?B?Mlp6cHlGcnVrN2lSWW0xWHB6OE4xM3I2bjVPNy96ay9Zcnl6alkxc05makx4?=
 =?utf-8?B?RSt6RUxXc0tPNDdqTXZ3bzJ1Rjl5dldIU2Y3dm55ZGV6MEFURFAycXI5NWd0?=
 =?utf-8?B?Vm1wVUJNZFZ4TXIyN1JuaUlkdzZsRlIwYmdkQlpwUDVwVDgrajl0Z2FRYXF3?=
 =?utf-8?B?dFM1MTNoTXlYb2pKdzVLWEJWNnIvVDNFeXVuaVVyaG1hU05qYWo2Wms2OVMz?=
 =?utf-8?B?T0hxTjBsQWVjK25USmtvdUhzRzB3d2czU2Z6M1BXeE9JdXpGS242OTJ4K1hW?=
 =?utf-8?B?OFhmd2VZY3I0cDNZWjUyMjdEaHJKa25oT0RwUVZmU09zNGxqMmlHV3VRNjR5?=
 =?utf-8?B?Ny9TVHZsYnZ4MWhJNzJrbFV6LzlvQWxVVzJtQloxWmswUFBmMnYwZm1NYnY4?=
 =?utf-8?B?SlR5NUVvVTVtNkhpellXMno4dS9iOEFhanF4S1ljMTEycnBjRTQxTmNiUEpM?=
 =?utf-8?B?bFVySjZsSTkwSko3bHVxRnpRZHZRVHFYdUsyenNnYndjejRlcTVZcE12eEpq?=
 =?utf-8?B?R3F6Qk1mR3krckloUHRoU2o4NUtZcEZVMXI2U3JIdU5SR3FkVUhjM2dzRCtZ?=
 =?utf-8?B?WXB5N1NpWGtIcWlNRmoyeG1NK3A4WVJsU0VPakNmQ2Q1bGhOWEJ4WWc4c01H?=
 =?utf-8?B?eWVrTGI3VjNMVUZIT3ZNUFVmMUI2T0xOTmhweWZHVGJzMXRiemw1MW1ZelRt?=
 =?utf-8?Q?VAOczIXrSodhoBgdNG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f755706-c001-4654-658a-08de7ad5cefb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 16:39:45.4658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXltS/xSmmQZOjQgx9Z+YUFax3g/FDgAd0V8Ff5EzFQ2wKfdNVViyYU92rQiVkfp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B1414000F
X-Stat-Signature: ecs84mbtxujey9379h4orxu7sxa5kek6
X-HE-Tag: 1772728793-451098
X-HE-Meta: U2FsdGVkX1+w4hS+RcOcOn+Ft4s2JHy0KFp1TfkuLRHqu41e26QDywo9O6gu+dQMpGav6scjQKbmNyvmUxPf4kfbrvlasMTmt2rLOfwQiRqkKMq2s8SX7xuoxChfM/ExiKYDUwrKHbVp+efi349JacOgsQGWWX2YDTWFB5DXoGECXHztLv//hmP6CfBgFJgTCMLjQE3iYYF4kyMu8eDJK3K2MEPjkkh4DrDL/a0V0C6C+WXwjQyK3GWynWjVNNSKOGdzhvwKI5RmoEvr/S0IekQcPETqoHsmeQPVKOlWf9yHTIMMxTQ/12PyIFSerCcQsaeGq6HqVs2V/Ojy/MhDRM1N7QDUzRYH+ZBg36VNXOfUNEldzewMPznbMrKqh7/nJr3pfqkp9Y5voqzyy2GgSu21ZivFa8mSC1ZRAAtKDIDWYpVe/GseOlBAlgAEQlfgKwOnKx/t31flW89gC+Ju+nmEadkqSMAszVnVBrZFfVq+qvuDCMP4GSmvAY3PdVbAT83U0lgUFRtmsSj2zQd2gm2qSAxTUe919HVKVyYL3PVbR4RDGP1v6qMKaT7vprAL5+At9g+sF6yp4vf+YoxRN0EZzOEc36ng7digRFzd0Gd6IImsRoksMLiQZimVHb/1wlFjYYO2GfDtUy4/xlYDFaLPBiJiRbb+/WhzWv8vcfddU9O1IwGHUlXGK35MK45Mg64ha3TN2CFThO8MlO11QYo8BkZZRwiTbo7qka9I+A2Gp902NxcBz2H0/dsTk3TVU3/OsMPxtBrTKN6GzJVeP2KG9+czxoXRyZoEppJ1uTo9t7XSGDjQ7Cdy6QN3bgKWqNfIryUXx62oTi+3GlsFgN9sIGQoozGhOoANphKhNN006wtfSfMh8T00/roNQ0ih8iYuSFl2traa4I4WhxOzK5BiTEskbf5SaGNtjgqqwi940xllMooyshHdG1X7V+BYEkWs83+T/DVSi2bavaB
 zDU+8xHk
 TdPLBDPar3kjM+yw+PhK37WyyiCurV/z4uYJe1IbZQaXBaAg7RbwVQEQjO+6q7AaMwjBNEEs1Cz0aPx95vIUJXUUHnA7FQESKs9QHO8sjfcCtS7BH/j3/+Df5NR2z33xyi2eL5/39dx9C3qHiM5pUVpXldHtk2/7WAAfpVCFTcIcNyZ1HzVq3sknNXceJM/jdldaiD2KbKaukgFrFxMG2IcB8JHQei4Dj5c5BsRyqnc9Mg+GiMXWrLMNVXudCRe2kzu+URU5ugxm3Z2pfQqEewePzacioIlQ8euxEEiUxwEgsxSRFwxIgnq2LIRa5Xnc7sUcr9X9r1/9cmS0rEX9LYKbyn43nH1vTrSz3Kmt/Ah+TblCpZp8PROsiHGlMvmhYRgbdKvZF1x/AALN1jxQ4vXAcW+KzxxL4qbjOrZ5gAWmPbQceWxDK8ZMg4P2/m0504QAsRwNlAxnKTvFJETkeo1recO0+R5Lu86ir1nA+72uTMWMXxyRLcwMHFGlzHsCRad6j9ovWXRTFpmaXVbVO4GNLe8A5qgp7Ru7uQ2477ZgAoWcyZqcFBVtYWbZCb4Cei+FHzNv4LPh8OyaMf5ULFeqd5UF95t1ayJeF79mSEgzj7iSSMid+rws/ji1zWujbHkaYst6fVn2yoIrLeOahtC5wY11+Q2umR6Jo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Mar 2026, at 11:36, Usama Arif wrote:

> On 05/03/2026 12:09, Mika Penttil=C3=A4 wrote:
>> On 3/5/26 13:44, Usama Arif wrote:
>>
>>>
>>> On 05/03/2026 06:09, Mika Penttil=C3=A4 wrote:
>>>> Hi!
>>>>
>>>> On 3/5/26 01:28, Usama Arif wrote:
>>>>
>>>>> On 04/03/2026 22:09, Balbir Singh wrote:
>>>>>> On 3/5/26 08:54, Zi Yan wrote:
>>>>>>> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
>>>>>>>
>>>>>>>> On 3/5/26 02:17, Zi Yan wrote:
>>>>>>>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>>>>>>>
>>>>>>>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>>>>>>>
>>>>>>>>>> migrate_vma_split_unmapped_folio() takes an extra reference via
>>>>>>>>>> folio_get() before calling folio_split_unmapped().  On success, =
the
>>>>>>>>>> split consumes this reference: __folio_freeze_and_split_unmapped=
()
>>>>>>>>>> expects the +1 in its folio_ref_freeze() check, and distributes =
it
>>>>>>>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1), w=
hich
>>>>>>>>>> are later balanced by folio_put() calls in __migrate_device_fina=
lize().
>>>>>>>>>>
>>>>>>>>>> If folio_split_unmapped() fails (e.g., unexpected pinning return=
s
>>>>>>>>>> -EAGAIN), the function returns without calling folio_put().  The=
 extra
>>>>>>>>>> reference is never released.
>>>>>>>>>>
>>>>>>>>>> Add the missing folio_put() on the error path.
>>>>>>>>>>
>>>>>>>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting duri=
ng migration")
>>>>>>>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8Hd=
oJGCEqVsVxq7DhOUB=3DL4PQA@mail.gmail.com/
>>>>>>>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>>>>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>>>>>>> ---
>>>>>>>>>>  mm/migrate_device.c | 4 +++-
>>>>>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>>>>>>>> --- a/mm/migrate_device.c
>>>>>>>>>> +++ b/mm/migrate_device.c
>>>>>>>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio=
(struct migrate_vma *migrate,
>>>>>>>>>>  	folio_get(folio);
>>>>>>>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>>>>>>>  	ret =3D folio_split_unmapped(folio, 0);
>>>>>>>>>> -	if (ret)
>>>>>>>>>> +	if (ret) {
>>>>>>>>>> +		folio_put(folio);
>>>>>>>>>>  		return ret;
>>>>>>>>>> +	}
>>>>>>>>>>  	migrate->src[idx] &=3D ~MIGRATE_PFN_COMPOUND;
>>>>>>>>>>  	flags =3D migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1)=
;
>>>>>>>>>>  	pfn =3D migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>>>>>>>> --=20
>>>>>>>>>> 2.47.3
>>>>>>>>> Add Balbir, who wrote the code, to comment on this.
>>>>>>>>>
>>>>>>>> Thanks Zi!
>>>>>>>>
>>>>>>>> Just wondering if there is a reproducer for the issue and how the =
fix was tested?
>>>>>>>> I expect migrate_vma_finalize() to be called for folios, even when=
 split failed and
>>>>>>>> drop the lock.
>>>>>>> Does migrate_vma_finalize() do folio_put() for failed-to-split foli=
os?
>>>>>>> If so, how does it distinguish between split folios and failed-to-s=
plit folios?
>>>>>>> By comparing source and destination folio orders?
>>>>>>>
>>>>>> We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.  =
We do a folio_put
>>>>>> on the src in finalize, if it is split then on all the split folios =
as well.
>>>>>>
>>>>>>> What we see from migrate_vma_split_unmapped_folio() is that
>>>>>>> it adds a refcount for all input folios, but only drops a refcount
>>>>>>> for the split folio. Isn=E2=80=99t it cause failed-to-split folios =
to have
>>>>>>> additional refcount?
>>>>>>>
>>>>> Hello!
>>>>>
>>>>> Thanks for reviewing everyone. So its very difficult to create a repr=
oducer I think
>>>>> the extra reference would need to appear after migrate_device_unmap()=
 but before
>>>>> folio_split_unmapped() in migrate_vma_pages()? That's hard to trigger=
 reliably from
>>>>> userspace.
>>>>>
>>>>> The fix came about when Nico indicated there might be an issue if spl=
it_huge_pmd_address
>>>>> fails in my patch [1].
>>>>>
>>>>> Below is my understanding of how refcounting is working over here ste=
p by step. I
>>>>> might very well be wrong on this, and the refcounting is a bit all ov=
er the place
>>>>> and I might miss a reference change somewhere so would really appreci=
ate if someone
>>>>> can confirm this!
>>>>>
>>>>>
>>>>> 1. migrate_vma_collect_huge_pmd():
>>>>>   a) folio_get(folio) -> +1 (collect reference)
>>>>> 2. migrate_device_unmap():
>>>>>   a) folio_isolate_lru() -> +1 (isolation reference)
>>>>>   b) folio_put() -> -1 (drops the collect reference)
>>>>>
>>>>>
>>>>> Without this patch fix:
>>>>>
>>>>> 3. migrate_vma_split_unmapped_folio():
>>>>>   a) folio_get(folio) -> +1 (split reference)
>>>>>   b) folio_split_unmapped() -> fails
>>>>>   c) Returns error =E2=80=94 without folio_put() which is the fix
>>>>> 4. Caller in migrate_vma_pages(): clears MIGRATE_PFN_MIGRATE | MIGRAT=
E_PFN_COMPOUND
>>>>> 5. __migrate_device_finalize(): sees !(src_pfns[i] & MIGRATE_PFN_MIGR=
ATE), restores the folio:
>>>>>   a) remove_migration_ptes(src, src) =E2=80=94 re-establishes user PT=
Es
>>>>>   b) folio_unlock(src)
>>>>>   c) folio_put(src) -> -1 (drops the isolation reference)
>>>>>
>>>>> The split reference in 3.a is never released and the folio has a perm=
anently elevated refcount.
>>>>> Unless I missed a folio_put somewhere for the refcount increase in fo=
lio_isolate_lru() (2.b)?
>>>>>
>>>>> Please let me know if this makes sense!
>>>>>
>>>>> [1] https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsV=
xq7DhOUB=3DL4PQA@mail.gmail.com/
>>>>>
>>>>>> Thanks! Yes, the patch makes sense
>>>>>>
>>>>>> Acked-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>
>>>>>> Balbir
>>>> I remember stumbling on this while ago also. The folio_get() in migrat=
e_vma_split_unmapped_folio()
>>>> is balanced with put_page() in __split_huge_pmd_locked() (freeze =3D t=
rue), can't fail for device pages.
>>>> Folios at this point are unmapped but have 1 refcount from "collecting=
".
>>>> After folio_split_unmapped() the refcount(s) is still 1.
>>>>
>>>> So it seems the code is good as is? A comment though would be good for=
 the extra folio_get..
>>>>
>>> hmm I dont think the put_page() in __split_huge_pmd_locked() is there t=
o balance the folio_get() in
>>> migrate_vma_split_unmapped_folio(). There are other points where split_=
huge_pmd_locked() is called
>>> with freeze =3D true [1] and they don't get a reference before calling =
split_huge_pmd.
>>>
>>> I think the folio_put() in __split_huge_pmd_locked() freeze =3D true ca=
se is there as migration
>>> entries are being installed?
>>>
>>> [1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/rmap.c#L2334
>>>
>>>
>> Yes normally you want to drop the reference when installing migration en=
tries but in this context
>> you have already done the collecting for the THP folio and you want to b=
alance with the folio_get()
>> the put_page() to keep the refs unchanged. Is that right Balbir?
>>
>> --Mika
>>
>
> Hi Mika,
>
> You are right, This patch is wrong. I tried the below diff to force folio=
_split_unmapped to return
> -EAGAIN. I ran tools/testing/selftests/mm/hmm-tests -r hmm.hmm_device_pri=
vate.migrate_anon_huge_err
> to trigger the path for folio_split_unmapped.
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e2746ea74adf..6df33b4990a13 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4140,6 +4140,8 @@ int folio_split_unmapped(struct folio *folio, unsig=
ned int new_order)
>         if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) -=
 1)
>                 return -EAGAIN;
>
> +       return -EAGAIN;
> +
>         local_irq_disable();
>         ret =3D __folio_freeze_and_split_unmapped(folio, new_order, &foli=
o->page, NULL,
>                                                 NULL, false, NULL, SPLIT_=
TYPE_UNIFORM,
>
>
>
> I inserted a lot of traces to keep track of refcounts [1]. Without this p=
atch, I get
> ....
>        hmm-tests-129     [000] .....     1.476233: __migrate_device_pages=
: SPLIT_UNMAPPED: folio=3Dffc536e2c4100000 refcount=3D0 AFTER error NO foli=
o_put
>        hmm-tests-129     [000] .....     1.476234: __migrate_device_pages=
: PAGES: split FAILED folio=3Dffc536e2c4100000 refcount=3D0
>        hmm-tests-129     [000] .....     1.476236: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffc536e2c4100000 dst=3Dffc536e2c4100000 src=3D=3Dds=
t=3D1 refcount_src=3D1 mapcount_src=3D0 order_src=3D0 migrate=3D0 BEFORE re=
move_migration_ptes
>        hmm-tests-129     [000] .....     1.476237: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffc536e2c4100000 refcount=3D1 mapcount=3D0 AFTER re=
move_migration_ptes
>        hmm-tests-129     [000] .....     1.476237: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffc536e2c4100000 refcount=3D0 AFTER folio_put(src)
>
> i.e. refcount =3D 512, which is correct as split_huge_pmd_address was suc=
cessful. Full output is
> at [2].
>
> With this patch, I get:
>
> BUG: Bad rss-counter state mm:00000000cfe88d5e type:MM_FILEPAGES val:-511=
 Comm:bash Pid:63
> BUG: Bad rss-counter state mm:00000000cfe88d5e type:MM_ANONPAGES val:511 =
Comm:bash Pid:63
> ...
>        hmm-tests-129     [000] .....     1.468315: __migrate_device_pages=
: SPLIT_UNMAPPED: folio=3Dffed210c840f0000 refcount=3D1 AFTER error folio_p=
ut FIX PRESENT
>        hmm-tests-129     [000] .....     1.468315: __migrate_device_pages=
: PAGES: split FAILED folio=3Dffed210c840f0000 refcount=3D1
>        hmm-tests-129     [000] .....     1.468318: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffed210c840f0000 dst=3Dffed210c840f0000 src=3D=3Dds=
t=3D1 refcount_src=3D1 mapcount_src=3D0 order_src=3D9 migrate=3D0 BEFORE re=
move_migration_ptes
>        hmm-tests-129     [000] .....     1.468357: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffed210c840f0000 refcount=3D513 mapcount=3D512 AFTE=
R remove_migration_ptes
>        hmm-tests-129     [000] .....     1.468357: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffed210c840f0000 refcount=3D512 AFTER folio_put(src=
)
>
> refcount=3D0 means the folio would be freed which is not correct. The ful=
l output is at [3].
>
> Thank you for clearing this up!

Thank you for doing the investigation. Can you send a patch to add a commen=
t
in migrate_vma_split_unmapped_folio() about this to avoid the confusion
in the future?

>
>
> [1] https://gist.github.com/uarif1/65e1e816af7aa0ae38dd6ec64d62a993
> [2] https://gist.github.com/uarif1/79ea9500667daa4e2ef09cb5d308f041
> [3] https://gist.github.com/uarif1/8a35a6c65ba8b3a1c1dfe72dc30e821d


Best Regards,
Yan, Zi

