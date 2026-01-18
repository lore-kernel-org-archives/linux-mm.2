Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F20C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 15:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6D96B0092; Sun, 18 Jan 2026 10:57:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095996B0093; Sun, 18 Jan 2026 10:57:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DE96B0095; Sun, 18 Jan 2026 10:57:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D404D6B0092
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:57:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 710761A057E
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:57:41 +0000 (UTC)
X-FDA: 84345539922.24.629C2C8
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022114.outbound.protection.outlook.com [52.101.96.114])
	by imf21.hostedemail.com (Postfix) with ESMTP id 78E761C0007
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:57:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=W3W7ssUl;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.114 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768751858; a=rsa-sha256;
	cv=pass;
	b=Nxbg+FNTZSq6Jt1j3W0yEdBjzMdxlyIZZLrtPxpVNg2fe/r1zrqnAq1RymXpX9W1wHcwaK
	5LwwdmDUByd5V3/TSc86uBb+UKfaR++WEbvZuoQpkvqP8K2DLFHn4mIJA9/wDunvNIjKHf
	Rc39HMgx5Xo1vlhXLxkWWUC8g1W9HW4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=W3W7ssUl;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of gary@garyguo.net designates 52.101.96.114 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768751858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJbqbF+j+0+AfpBhhXJd4ekN3equfU8MwqWISrem4G0=;
	b=TgA4P/1VpYKRCtTPPvy7iXYFfxXItmVqCRUNumpxT0kXLSPItA9pnKYOb//a/bvppXzldP
	E8uw/Ng0yutLsbVG8FPw76sK1ykRsYevOzODEI4nNBQKlq3Gqo2fCEADWEZAEtoaw6JQI2
	D5YzykfrX8tKuhypA6NecVGRoOPJXzg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BX4pCXYpZ7nZkvtOgygrMeGv28JeGFh8f/E+w6J0Il5wvQ81YCg5kx3nG7wMDTFy83zNRIs9o3QMHBb7uRV9akHAaGjkdNfL5xRE0kwpgOa5rTBj1lsBRvneqYekHC0YXmuIjTsBKmB/KeX9OC3/yV8fIevXYkvHVlIVMJsIlGFdH+7IlsS87UW/LUIerFfAGCucVWsBSNy0ZlRA/E3ETLLTvkmphvdrSKWCOIlVthAJeYKPBEsjID4O/omylZ57lJhrUsHMd9gmQae8wdpmojetDkJXjbwCFRe5M+Vp7v+urLl2IvMO0OmIAziXbmKsbthxZQbPQwX47iaS3hD72w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJbqbF+j+0+AfpBhhXJd4ekN3equfU8MwqWISrem4G0=;
 b=QTzrbwIQgRYN/bdMP3O9O85Nz171stpGHRpMdq9LgGJ97bSPXX8BifU8Djm/dOHYSI7C2koxkcIv9NAyLsboZ4bBobuvAxjG1+8c87mBzQFma10bdEQop2GiT6sfx4mO3f3SFy8Gmoo0PYloNsdu1WecxMrnXlCadqEHEChoFu4pyus5ctIXqi0tli7haRB0K/T4sLZZQNkSzIontjoeXkVItvytsIgwD65fu5LHxwdmd1qhASNelpwjcS9IvB8IsNif4+nuh3e1BnGdW2ILOywIHamYoOe++3sBJj938ahKcbW/4GLYwkIAuaqrPfyTV7MZQC01Rl5Jio+YgNSbEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJbqbF+j+0+AfpBhhXJd4ekN3equfU8MwqWISrem4G0=;
 b=W3W7ssUlxlebx4tO3Tgb++hAMDgvc/aExl5MfGD/UM/LHfv7syw+7g3mdwcSiFKJeOnCeM3pIOCR/BCenduQI8xb6d7/3+EtwPjR/ILlZVMXJG6D6RPs3SFiV0lwZyfUrt6UgLevBBHNTD5Syg7nyXM68fyWb4RskQ7hQeK4KcA=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LOYP265MB2159.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:117::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 15:57:35 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9520.010; Sun, 18 Jan 2026
 15:57:35 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Jan 2026 15:57:34 +0000
Message-Id: <DFRU7CF0SSWN.3KMT2U5FWC2NU@garyguo.net>
Subject: Re: [PATCH v6] rust: iommu: add io_pgtable abstraction
From: "Gary Guo" <gary@garyguo.net>
To: "Alice Ryhl" <aliceryhl@google.com>, "Joerg Roedel" <joro@8bytes.org>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Will Deacon" <will@kernel.org>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Boris Brezillon"
 <boris.brezillon@collabora.com>, "Robin Murphy" <robin.murphy@arm.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Asahi Lina" <lina+kernel@asahilina.net>,
 <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-mm@kvack.org>, "Deborah Brouwer"
 <deborah.brouwer@collabora.com>
X-Mailer: aerc 0.21.0
References: <20260118-io-pgtable-v6-1-423846996883@google.com>
In-Reply-To: <20260118-io-pgtable-v6-1-423846996883@google.com>
X-ClientProxiedBy: LO4P123CA0459.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::14) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LOYP265MB2159:EE_
X-MS-Office365-Filtering-Correlation-Id: e7374ab1-fb0d-4ba1-7dd8-08de56aa4bc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjdKOWZhWXVpb3VKeVpNL0JPOFd3dWpsMmZIeDdCNXRJcmV6QkJzM0VPMGJC?=
 =?utf-8?B?eEg1TzQ0dWpqSFlsbk5RNnhNcllWOHNham9pckt1VnNJcDNScG5ZNGUrR1FK?=
 =?utf-8?B?eTdrNHVNcE1kc09JdHJGWDJLY1RsTHlubkpoMXRzREdzUDV6QnJKNE5TcWcr?=
 =?utf-8?B?WE9NMEkyWWZORENMTndSTDg4cUozQTNMbzlMb1RsbHNwZGYrYUJzOEY1MWNG?=
 =?utf-8?B?L1dTWmltREFkN3FGMlZpU1lCVUFydGFOOFkvRytpRHQwYmM2bWxtMUpYM1VT?=
 =?utf-8?B?WDVzSmZwK1pibUdQUCtFOXFuNDlmaXVWSVF4NjZQYllVOFRTU1NWOHdVSEsw?=
 =?utf-8?B?UGVxeDl5b0lCbEdwRWg0YjcwVjgvcTNwS3FGdzlpelRTa3EvSDRabk96eXZC?=
 =?utf-8?B?UVJKZWk4UEJGU2dWeURTZDNaT0lvc0pudWFSYVRNWkNFRnZocGk2WVN0MUpq?=
 =?utf-8?B?U0JPWlkxOUpFMm8zNTJ2cExMN0ptMy9IWW9KbUVJNGRrNjlRcndGS1FzcUF0?=
 =?utf-8?B?bGNUK1F2bGF5MzU5cHpTVzBqc1haZEhXaXk1eDF5Wlk2dFdGdXFuMXJnanpm?=
 =?utf-8?B?Q3VIazBZK3hUVUdFbXhWcVV4YVVBd1FQQzJVRFFiSm04TjhINllWNzFhZ085?=
 =?utf-8?B?V2ZmNEl6QTZac1hzSVduZ25YQXFZVzJXUXZrV1NiVkVuMVNBZ2I4dTI1S0sw?=
 =?utf-8?B?djVaTEh3R2Z6UTAzY0V0aXliL1FKeVNLNHc2MWZaaXpNTEFydnZxS2lrdzBI?=
 =?utf-8?B?V2V3WUo2cVBRTmtUWHg0MGdxdnIwZi9xd2JhYklLeElnSnJlZHpMVmJpak10?=
 =?utf-8?B?V0k1bmhWcDcyRGRlQnNWd2hVdXo3TFpxRHRraFo5S1huVjU4OGQ4c1I3ZUNl?=
 =?utf-8?B?OXhLTy8rN3hLUmdmbEtaYjhDL0sxcmZ1OFRreUNZY2lZU3l2RGc1S0JaNkgz?=
 =?utf-8?B?K1NEZVlFUnRRZklUWWloUy8zVlBnck1Rczk1UngvS0IreDhybFV5bzRBSzk1?=
 =?utf-8?B?ZnZLd2ZtM0xxWm15aVhGTUVyNnFWdVRod2dSZ3k5L0s5bVlmYlQvbUhLaFpF?=
 =?utf-8?B?QzhLaTRjc3E5NzMxRldOa0Q0QzBZSW1vMkZnbVpoSXhQaXBGUFAyUEtNWHIx?=
 =?utf-8?B?a1NrTWVWNS9Bb0MvL0w3OXRuMUZ2aE9aU1EvbkNNVVM2dWJVUkZ1Y1V1emcr?=
 =?utf-8?B?eENlZTN6WjJBQ3BsdkFkbnJrQ1dWQWhmc3Q1WE1CZTR2Sk82YTZVdFEzNUM1?=
 =?utf-8?B?MGVYTXVHckVSSktZK3hUQTdaU050MmxHV3M3cUxoV1JSdTAxODh2T1VUWVEz?=
 =?utf-8?B?TVVielpuR0tJeHpNWWVhQzBiTEdzTThKc2lnUTdRTFdlYzFKNjFBT0t0aWpM?=
 =?utf-8?B?T0RlM0hDTnZ4TUJpanVtakd5ZE9VS0FSOUR3NjMwaHNUQjVqbExSS2JRYnFE?=
 =?utf-8?B?S1JPdXNlTTYwZjI5anhUL012bHoxdDRFMHY4WGs4RmR3ZDEyWmM2VnI1amRL?=
 =?utf-8?B?czJpRFMzcHJNUGtmdXl4dmw0MC9DWVVSY2xQUjBMUXZjWUlEUlRsdnpNNUFQ?=
 =?utf-8?B?b0VTTVUzTVlLbTkzdTJXdW5nNGRJaEJ4OU5LSHpibE9Ud2ZZWjlqMFdHUHVP?=
 =?utf-8?B?K09zVkFHQjN1QzErMjlpdGRET2NBVytkdDB3clVlQWRJVjl2SlAyRjcyYXVD?=
 =?utf-8?B?dmphODJZV0NEZTZLeFlVY3lRVUlGdksrQWRGcUJEeTlpMXNKcG5hM1RUbG00?=
 =?utf-8?B?QkVBMThoV2Y2OXpCcFJwRGE5NldBT1REcEVqTFl1NlUyL2hwTnlTRTRscGJu?=
 =?utf-8?B?N0djYU9nU1FEM2t6S2hYL3k1UzZvQ3lBVzdyMjZxMkhyVWd2NDFKSFRpQm5H?=
 =?utf-8?B?b1I3eVcxRTJFU3RCaVVhMmpCVGloV0xTbU9lVDhkMVpWdFBUaWpFSXJNVGxl?=
 =?utf-8?B?V05HQVZzNWI4OHJjbWtsYllVV1ZIOExtQ2VhYW5EYTlaQjVHRjR1UUdxTTgw?=
 =?utf-8?B?LzBZMjhUZUZyK2dBQnpZUDA5bk9vR3lpa2QvYzMweDR3QmF1Mjd6TXc2WnFH?=
 =?utf-8?B?N2dPUGpvclBIaVlRQ082bVBIdDFvN0pzSXpJRUwyR1NhTUNIUXhlTC9zcmZE?=
 =?utf-8?Q?ZLXA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1hHaTlFVkxoMTd0eTc2R3Z3aUQyYkJaZ1lCS0JJUi94OTBpTGhYckdUb2M5?=
 =?utf-8?B?UFgwT3I2cW9CU2I5akFnK3Arc3p3ZjBueTQveXlpanRRNk10WVFSQUFFeXg1?=
 =?utf-8?B?L0pYTXFlZUtjWXNLZXRud0h5TlpHRjhFdGswdzRuak0wN0M0SnB5QUM3YlR0?=
 =?utf-8?B?ZjhlSkliOGFGQ0tpeWlJQTRyVVV5U1lnRXdnQVpRMzdjMlIycEU4d1pHamZt?=
 =?utf-8?B?Ujl1WGd4ZzBYTHJRZ3FIT2hOZDBCMExsRjVYT2FsMzdvbVQvcFh3OVpPc0JG?=
 =?utf-8?B?QUJ4d2IrWWZDUi9iVEpadkliVkVXd2JnY3pZZ2x3SVVMRlJVa1RiWCswUkQ4?=
 =?utf-8?B?VEZ3cDUyRHNhYUZIZm9jcGNibFhOQ0pEVVN3OHNqR3Nac2lia3k4L0V6a21J?=
 =?utf-8?B?aEVsM1pOTnJuYnBWcjQzcEhMbGw1dnNKRkJSSTBxQ2VMWU9LbVkwNjc3K3Vs?=
 =?utf-8?B?c3JDQjZWclBaa2VrZUhiWEV3YmplV3VteVp0WC8zWU91TGlxZG4wRzF2VThX?=
 =?utf-8?B?TG5Bb3BndWdtOUp3QUc4ZWxnZ09YY0tmOTh6aTAwMU9YZ1RObUpjdFQyZHFh?=
 =?utf-8?B?UC9FV2cvMjBhczJsaEZOU1E4cStxbS9BeVQ4OVFUMjd3YlpUTk5pWWhXS3pD?=
 =?utf-8?B?SXRUS3BnMExSdUg3cGp4Y21Td04yR0tSV3I2UW5tb2ExQmgyUTl6bTBPSXl5?=
 =?utf-8?B?S1dCY0taaTcrR1hEQ1RIaWk5WFhlb1lIVzRpQ3R6UjB1SncxVnFrdEtCTWYw?=
 =?utf-8?B?UFFWR0lranNzcVdGVmxQR3d0UTF1T3dBc0JPU0JOU1VpcUUzK0pac2M4OTJV?=
 =?utf-8?B?c0NWT1VacndJYWlWNGlwV0lrQzFFYTRTMy93blhhRXVvSkJaZ3Izbkl3VDc1?=
 =?utf-8?B?Z2ZwY29SbmdXL0s1eHdkaFdmQk1ZaXBUTjRXa1UwOVo0QnJxd3dTV1Q4ZUMw?=
 =?utf-8?B?T29NRldQU1ZhUnd0L0hvQ1p1aWZ3dUNuMUFMc3k1UkdoamJaWlB1L0FBbzJX?=
 =?utf-8?B?ckhiSEliWDJCdTkwVk9KOXV4MHQ0UW0zS2ZlWUNjcVhneWJ3VzNPR2Q0ajhI?=
 =?utf-8?B?NlVTWDJMVTM1VTBvOTlUM0NmeUdyb2ZudlhWVEh2YjR4OGNWZ2JtREJpVHht?=
 =?utf-8?B?VWNSVzZhTXR4VHVDaWF5R2FUdmZpQitXZkxsSFhPRTVZTlFHdkNYQktaQURs?=
 =?utf-8?B?MFBqQTY1MWo4enJnWkdxRFY3VVduV0VDWTVBZVQ4d1lqT0czcGc5Y0JlcStW?=
 =?utf-8?B?WFVLQlVNSmY2L0F3d3RGcysvdHY0TlU1TFhlS09GREI1T0lCTGpTZkdNcWNP?=
 =?utf-8?B?aFl3VDVvenNpbFJMNlBnSWNPUGM1V1FEREo5MEdZWW5Rb0JvYjFIaXNmL1cw?=
 =?utf-8?B?dWNhbmNGd1RFc3dDYjRudnpvNmNvdmx6K1NjbXVCNXZaWUxlRmpYRElybS8z?=
 =?utf-8?B?YzEzeHo3bndzRWlQbU1CVzJBSm5DRUQzSjlwZVRkV3MxdzhLUVlMUkJwUkV5?=
 =?utf-8?B?SDgvVGtReXpLWGJDTUFlKyt5NVllUmdia0w1TWNZWnlvSVpCZkREK0loUVlR?=
 =?utf-8?B?MjBtaUoyakZRSzc5eWxXalh1bjcwSitsYlQ5MndhbkRrcDRRb2k0WTUzcCtq?=
 =?utf-8?B?Z0ljcko5Y09UblZBWXJOdkZjSWsycExza1RxT2FEZmI0b1ZGd3VnczQvaXBa?=
 =?utf-8?B?MWVrMFBkVDlEelYvRU9OWlNnbHQ4S0I5V3FQNkF4dzlpeEFVVFJBQU4vb2F1?=
 =?utf-8?B?U2J2OERKejRhSjZySFJUT3l4SU1IMENqeWxIVklqZFdCajhnRFQ3MW9TQUsy?=
 =?utf-8?B?ZEk3bStHbVlJOEpsSkxyYjQwZ0lSakY3Z0NVNVJtTHlBVFcxRUZaUUNoaUFa?=
 =?utf-8?B?UDFHbWFrV3puaHpHTHB5SVY0bG54c2piakk2Mk91eEZlNk9aN1Z2azFhbE1O?=
 =?utf-8?B?N3ZsU0RLMDZxMTZuWGZmYzhtTE5JMmJjY3hLeVBrTEowdUJqM1dKM2tjN3Q3?=
 =?utf-8?B?V1RqMUFGQnpFWTlSU0pvdFhZbjQ0SDVmVlhwS3JLZTNXVnp6M2dWYjRzbDJm?=
 =?utf-8?B?ZXZpNWNTajRuTWlOVERaUDJkTG1KeVQyL3ppNktxa01vQTVHcUNZRDkwTUZl?=
 =?utf-8?B?WklMUThXU1VQSHRURG5sS3A0WGhDM1N5aE1wS1UzRE5QOU1CU2hKNTYyUDgv?=
 =?utf-8?B?RGNrNHdMRmlDbDNPUTFjTzZhdzRGUENMUnFZNTJDNG5sNUtHNzQvbVBSUzE0?=
 =?utf-8?B?R1dWNEZVRmtwVGZvdnZOYTZ1NmkzVktHT2FWRkFkZmFKaU9uUFhYWFQ2c2pP?=
 =?utf-8?B?VG4rek5hZ0V1V0lDVDZqbE56cU9TYzNPSUNuSlVXQmxuZ2pqcTVjQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: e7374ab1-fb0d-4ba1-7dd8-08de56aa4bc6
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 15:57:34.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhS5I6/UrFfT1mm4Pf32oIbenezNxkRPtSh1BH+kG5khNhVnJPDbDxmJ8wH3mC3s8vwg5Cj2y34gLR6V/m1DKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP265MB2159
X-Rspamd-Queue-Id: 78E761C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: qwtz74fmy49tcuxumhj6cqmyaxuobp6b
X-Rspam-User: 
X-HE-Tag: 1768751858-232451
X-HE-Meta: U2FsdGVkX1/9zclpl3oL0ihC+4jcIT864zmxrzgA7ISG0g+wOhaPHA9eepQkwDG4KqzkCcIDeNaovGlzlMbXrkeaP4M9sue6cdE3YdTmyoMeY7QoKoMWD+/KQo/creQ5Ik4lvQQIK/DNGXN3sjXM+m4J+jSCCNKiZiPAPwJ0rEzZrO3UVkSanR4be4g4a9jlq5bV1wOe1HvZsDoLuY8GGVjI3uiAlyt7k6rySwRSsfRfIEtzgl7CfeFMVA/OuTxMrya0WYINpz/fjED92CRKeCxGf/Wn9SioJQy7f31YvJD6h0HhlSLYYQSmE6UokHgOuMsMvPg7L0carIJLHm17J6TrNfJKvMR2AOVskBTZ8sBTODl4bhLKnboRooy1Qx0QoHGTpUPykZcAPDwZOnuJEQFpf/uLshOKrfUnmkAHPSelLLDKOc1vd9yqbwRrmMlrAhg3Y5WQLi1EnELNQreIuSNa9E937lVRlWUfnxc5AJJxDmmm9StDlyt+rToWy63mgTWLkFMoSMeNW1P7hlRk1jPPbkN9TrPoz6nT0o7tpWvxPP7W+1c/tI/mXbGH/9SKEpOHOSs+KREAd1HsANB1zAV5uIW9qKRKEnRxdyObK90BK8yeQG1tZhGoBGnzm5XjSZWC1fI8sC7PwmidiRvJ++yCaT8O//OEvm/8z0MxBh3cxXqHLmmAB38NwRvgQ351ybLFON5cZ67jSO0n1ATlK4g5XXz6P7t3MQCnRRIqLlp3wdJawL8Qb9grDUqMPsXh5+9Bs2uX0LPkbM8aRPHS+RhWOgocXA0OmTtnmzb66uvHxKq8iW3OAOUUTDc7Vfq1bmdvwJ125+O8Z7iWqf0xAvSyFXpw5U57cNosGoyEByZl8dX+JMLsL+3sb+Se+lpiWpDmkFjD0ev01SdJJKISr5VcIcufu0TugoK+BzBLwYe1PQW9/lGdXGllSRQ1MGzt6OguqlJPwxYxG7ppD10
 NpkQ9iaT
 fHNVn741fwcUjeS3VHPyKQMAbd+ehIK1K3diGyA5GHAPjUWOyudyeysukjh87elYMwuPpJpJkEWvtUe7yz0u0LenNmCWq/VqqJ9wyvHLJNBPy4GTDRpp/3ti9q/KqIrSzGSaortuiM4h52ynsSlrASbVHHn68V1Y7SLQJxM1ula3GqE0f9lt8OKd+ZNPBhHZ/XDDB7/+9Dr70t7HoBCwA9AoapXC3NTlR8ixtyRDDU2Dc4iEPIi1rfgXZs5ej83DZBOvHVsjFpsmpNMoeO59+OJDlsSThpaux+OeUp2OF9weqv2T5HAkcGCFGq5Lj7q2Vg40aU5GWURySLM6VepxdqXR8Ldn6WyJmYUKvl3d1p0uOzg0eqzbC0r3QlVIlRZ/6WkVMIlc6Kv/LPKScfgljnzf5phssdacjL7MEg5wlie3XkS78eUdISd7voV9nKnpoMlHil63teNS5UGUZEasJyFMuRL9OPsDwSMD/jkr5YPo1BE9My2Ox4OuNN7u0lCAnDKeyHtvqgrJFkSG7noDInw11kcNP3++hwCxxsJyeQdSVOhxkl/gHADBn4qK7GM6sV65L/LpnMYC9V7poyDqNDP+YfFJRlJ1dUfyd9gDizelIG+GBdc886+wsfq6Fm8VyCuqEbJIqq8gcq+QcB9YHDeZ83iDobr2DMmFs7BTWMpmUhHW4vRkiAj9BaOHGa+H+nplcI+6JQ349qg/yO8XOI8Wqm5AhWIcvijaw+iMXfzi4FBO9YZB5rU25frh9dxOeJlrMjFL4E2EPCUsmaWXYVUfFrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jan 18, 2026 at 10:08 AM GMT, Alice Ryhl wrote:
> From: Asahi Lina <lina+kernel@asahilina.net>
>
> This will be used by the Tyr driver to create and modify the page table
> of each address space on the GPU. Each time a mapping gets created or
> removed by userspace, Tyr will call into GPUVM, which will figure out
> which calls to map_pages and unmap_pages are required to map the data in
> question in the page table so that the GPU may access those pages when
> using that address space.
>
> The Rust type wraps the struct using a raw pointer rather than the usual
> Opaque+ARef approach because Opaque+ARef requires the target type to be
> refcounted.
>
> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> Tested-by: Deborah Brouwer <deborah.brouwer@collabora.com>
> Co-developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Changes in v6:
> - Move to rust/kernel/iommu/
> - Pick up Tested-by tag.
> - Link to v5: https://lore.kernel.org/r/20260113-io-pgtable-v5-1-7ed771bc=
3d8d@google.com
>
> Changes in v5:
> - Fix warning by removing #[must_use] from `map_pages`.
> - Reword comment on NOOP_FLUSH_OPS
> - Add blank line after `alloc_io_pgtable_ops`
> - Reword safety comment in Drop to refer ttbr method
> - List in MAINTAINERS
> - Pick up Reviewed-by: Daniel
> - Link to v4: https://lore.kernel.org/r/20251219-io-pgtable-v4-1-68aaa7a4=
0380@google.com
>
> Changes in v4:
> - Rename prot::PRIV to prot::PRIVILEGED
> - Adjust map_pages to return the length even on error.
> - Explain return value in docs of map_pages and unmap_pages.
> - Explain in map_pages that the caller must explicitly flush the TLB
>   before accessing the resulting mapping.
> - Add a safety requirement that access to a given range is required to
>   be exclusive.
> - Reword comment on NOOP_FLUSH_OPS.
> - Rebase on v6.19-rc1 and pick up tags.
> - Link to v3: https://lore.kernel.org/r/20251112-io-pgtable-v3-1-b00c2e6b=
951a@google.com
>
> Changes in v3:
> - Almost entirely rewritten from scratch.
> - Link to v2: https://lore.kernel.org/all/20250623-io_pgtable-v2-1-fd72da=
ac75f1@collabora.com/
> ---
>  MAINTAINERS                     |   1 +
>  rust/bindings/bindings_helper.h |   3 +-
>  rust/kernel/iommu/mod.rs        |   5 +
>  rust/kernel/iommu/pgtable.rs    | 276 ++++++++++++++++++++++++++++++++++=
++++++
>  rust/kernel/lib.rs              |   1 +
>  5 files changed, 285 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b11839cba9de1e9e43f63787578edd8c429ca39..b83bd50c2755115cc14e903e7=
84b1dae1bd921bd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13241,6 +13241,7 @@ F:	drivers/iommu/
>  F:	include/linux/iommu.h
>  F:	include/linux/iova.h
>  F:	include/linux/of_iommu.h
> +F:	rust/kernel/iommu/
> =20
>  IOMMUFD
>  M:	Jason Gunthorpe <jgg@nvidia.com>
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_hel=
per.h
> index a067038b4b422b4256f4a2b75fe644d47e6e82c8..1b05a5e4cfb4780fdc27813d7=
08a8f1a6a2d9913 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -56,9 +56,10 @@
>  #include <linux/fdtable.h>
>  #include <linux/file.h>
>  #include <linux/firmware.h>
> -#include <linux/interrupt.h>
>  #include <linux/fs.h>
>  #include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/io-pgtable.h>
>  #include <linux/ioport.h>
>  #include <linux/jiffies.h>
>  #include <linux/jump_label.h>
> diff --git a/rust/kernel/iommu/mod.rs b/rust/kernel/iommu/mod.rs
> new file mode 100644
> index 0000000000000000000000000000000000000000..1423d7b19b578481af3174e39=
ce2e45bc8eb0eee
> --- /dev/null
> +++ b/rust/kernel/iommu/mod.rs
> @@ -0,0 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Rust support related to IOMMU.
> +
> +pub mod pgtable;
> diff --git a/rust/kernel/iommu/pgtable.rs b/rust/kernel/iommu/pgtable.rs
> new file mode 100644
> index 0000000000000000000000000000000000000000..001b1d197563728881e995c90=
395bf167d29dfe9
> --- /dev/null
> +++ b/rust/kernel/iommu/pgtable.rs
> @@ -0,0 +1,276 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! IOMMU page table management.
> +//!
> +//! C header: [`include/io-pgtable.h`](srctree/include/io-pgtable.h)
> +
> +use core::{
> +    marker::PhantomData,
> +    ptr::NonNull, //
> +};
> +
> +use crate::{
> +    alloc,
> +    bindings,
> +    device::{Bound, Device},
> +    devres::Devres,
> +    error::to_result,
> +    io::PhysAddr,
> +    prelude::*, //
> +};
> +
> +use bindings::io_pgtable_fmt;
> +
> +/// Protection flags used with IOMMU mappings.
> +pub mod prot {
> +    /// Read access.
> +    pub const READ: u32 =3D bindings::IOMMU_READ;
> +    /// Write access.
> +    pub const WRITE: u32 =3D bindings::IOMMU_WRITE;
> +    /// Request cache coherency.
> +    pub const CACHE: u32 =3D bindings::IOMMU_CACHE;
> +    /// Request no-execute permission.
> +    pub const NOEXEC: u32 =3D bindings::IOMMU_NOEXEC;
> +    /// MMIO peripheral mapping.
> +    pub const MMIO: u32 =3D bindings::IOMMU_MMIO;
> +    /// Privileged mapping.
> +    pub const PRIVILEGED: u32 =3D bindings::IOMMU_PRIV;
> +}
> +
> +/// Represents a requested `io_pgtable` configuration.
> +pub struct Config {
> +    /// Quirk bitmask (type-specific).
> +    pub quirks: usize,
> +    /// Valid page sizes, as a bitmask of powers of two.
> +    pub pgsize_bitmap: usize,
> +    /// Input address space size in bits.
> +    pub ias: u32,
> +    /// Output address space size in bits.
> +    pub oas: u32,
> +    /// IOMMU uses coherent accesses for page table walks.
> +    pub coherent_walk: bool,
> +}
> +
> +/// An io page table using a specific format.
> +///
> +/// # Invariants
> +///
> +/// The pointer references a valid io page table.
> +pub struct IoPageTable<F: IoPageTableFmt> {
> +    ptr: NonNull<bindings::io_pgtable_ops>,
> +    _marker: PhantomData<F>,
> +}
> +
> +// SAFETY: `struct io_pgtable_ops` is not restricted to a single thread.
> +unsafe impl<F: IoPageTableFmt> Send for IoPageTable<F> {}
> +// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
> +unsafe impl<F: IoPageTableFmt> Sync for IoPageTable<F> {}
> +
> +/// The format used by this page table.
> +pub trait IoPageTableFmt: 'static {
> +    /// The value representing this format.
> +    const FORMAT: io_pgtable_fmt;
> +}
> +
> +impl<F: IoPageTableFmt> IoPageTable<F> {
> +    /// Create a new `IoPageTable` as a device resource.
> +    #[inline]
> +    pub fn new(
> +        dev: &Device<Bound>,
> +        config: Config,
> +    ) -> impl PinInit<Devres<IoPageTable<F>>, Error> + '_ {
> +        // SAFETY: Devres ensures that the value is dropped during devic=
e unbind.
> +        Devres::new(dev, unsafe { Self::new_raw(dev, config) })
> +    }
> +
> +    /// Create a new `IoPageTable`.
> +    ///
> +    /// # Safety
> +    ///
> +    /// If successful, then the returned `IoPageTable` must be dropped b=
efore the device is
> +    /// unbound.
> +    #[inline]
> +    pub unsafe fn new_raw(dev: &Device<Bound>, config: Config) -> Result=
<IoPageTable<F>> {
> +        let mut raw_cfg =3D bindings::io_pgtable_cfg {
> +            quirks: config.quirks,
> +            pgsize_bitmap: config.pgsize_bitmap,
> +            ias: config.ias,
> +            oas: config.oas,
> +            coherent_walk: config.coherent_walk,
> +            tlb: &raw const NOOP_FLUSH_OPS,
> +            iommu_dev: dev.as_raw(),
> +            // SAFETY: All zeroes is a valid value for `struct io_pgtabl=
e_cfg`.
> +            ..unsafe { core::mem::zeroed() }
> +        };
> +
> +        // SAFETY:
> +        // * The raw_cfg pointer is valid for the duration of this call.
> +        // * The provided `FLUSH_OPS` contains valid function pointers t=
hat accept a null pointer
> +        //   as cookie.
> +        // * The caller ensures that the io pgtable does not outlive the=
 device.
> +        let ops =3D unsafe {
> +            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, core=
::ptr::null_mut())
> +        };
> +
> +        // INVARIANT: We successfully created a valid page table.
> +        Ok(IoPageTable {
> +            ptr: NonNull::new(ops).ok_or(ENOMEM)?,
> +            _marker: PhantomData,
> +        })
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct io_pgtable_ops`.
> +    #[inline]
> +    pub fn raw_ops(&self) -> *mut bindings::io_pgtable_ops {
> +        self.ptr.as_ptr()
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct io_pgtable`.
> +    #[inline]
> +    pub fn raw_pgtable(&self) -> *mut bindings::io_pgtable {
> +        // SAFETY: The io_pgtable_ops of an io-pgtable is always the ops=
 field of a io_pgtable.
> +        unsafe { kernel::container_of!(self.raw_ops(), bindings::io_pgta=
ble, ops) }
> +    }
> +
> +    /// Obtain a raw pointer to the underlying `struct io_pgtable_cfg`.
> +    #[inline]
> +    pub fn raw_cfg(&self) -> *mut bindings::io_pgtable_cfg {
> +        // SAFETY: The `raw_pgtable()` method returns a valid pointer.
> +        unsafe { &raw mut (*self.raw_pgtable()).cfg }
> +    }
> +
> +    /// Map a physically contiguous range of pages of the same size.
> +    ///
> +    /// Even if successful, this operation may not map the entire range.=
 In that case, only a
> +    /// prefix of the range is mapped, and the returned integer indicate=
s its length in bytes. In
> +    /// this case, the caller will usually call `map_pages` again for th=
e remaining range.
> +    ///
> +    /// The returned [`Result`] indicates whether an error was encounter=
ed while mapping pages.
> +    /// Note that this may return a non-zero length even if an error was=
 encountered. The caller
> +    /// will usually [unmap the relevant pages](Self::unmap_pages) on er=
ror.
> +    ///
> +    /// The caller must flush the TLB before using the pgtable to access=
 the newly created mapping.
> +    ///
> +    /// # Safety
> +    ///
> +    /// * No other io-pgtable operation may access the range `iova .. io=
va+pgsize*pgcount` while
> +    ///   this `map_pages` operation executes.
> +    /// * This page table must not contain any mapping that overlaps wit=
h the mapping created by
> +    ///   this call.
> +    /// * If this page table is live, then the caller must ensure that i=
t's okay to access the
> +    ///   physical address being mapped for the duration in which it is =
mapped.
> +    #[inline]
> +    pub unsafe fn map_pages(
> +        &self,
> +        iova: usize,
> +        paddr: PhysAddr,
> +        pgsize: usize,
> +        pgcount: usize,
> +        prot: u32,
> +        flags: alloc::Flags,
> +    ) -> (usize, Result) {
> +        let mut mapped: usize =3D 0;
> +
> +        // SAFETY: The `map_pages` function in `io_pgtable_ops` is never=
 null.
> +        let map_pages =3D unsafe { (*self.raw_ops()).map_pages.unwrap_un=
checked() };
> +
> +        // SAFETY: The safety requirements of this method are sufficient=
 to call `map_pages`.
> +        let ret =3D to_result(unsafe {
> +            (map_pages)(
> +                self.raw_ops(),
> +                iova,
> +                paddr,
> +                pgsize,
> +                pgcount,
> +                prot as i32,
> +                flags.as_raw(),
> +                &mut mapped,
> +            )
> +        });
> +
> +        (mapped, ret)
> +    }
> +
> +    /// Unmap a range of virtually contiguous pages of the same size.
> +    ///
> +    /// This may not unmap the entire range, and returns the length of t=
he unmapped prefix in
> +    /// bytes.
> +    ///
> +    /// # Safety
> +    ///
> +    /// * No other io-pgtable operation may access the range `iova .. io=
va+pgsize*pgcount` while
> +    ///   this `unmap_pages` operation executes.
> +    /// * This page table must contain one or more consecutive mappings =
starting at `iova` whose
> +    ///   total size is `pgcount * pgsize`.
> +    #[inline]
> +    #[must_use]
> +    pub unsafe fn unmap_pages(&self, iova: usize, pgsize: usize, pgcount=
: usize) -> usize {
> +        // SAFETY: The `unmap_pages` function in `io_pgtable_ops` is nev=
er null.
> +        let unmap_pages =3D unsafe { (*self.raw_ops()).unmap_pages.unwra=
p_unchecked() };
> +
> +        // SAFETY: The safety requirements of this method are sufficient=
 to call `unmap_pages`.
> +        unsafe { (unmap_pages)(self.raw_ops(), iova, pgsize, pgcount, co=
re::ptr::null_mut()) }
> +    }
> +}
> +
> +// For the initial users of these rust bindings, the GPU FW is managing =
the IOTLB and performs all
> +// required invalidations using a range. There is no need for it get ARM=
 style invalidation
> +// instructions from the page table code.
> +//
> +// Support for flushing the TLB with ARM style invalidation instructions=
 may be added in the
> +// future.
> +static NOOP_FLUSH_OPS: bindings::iommu_flush_ops =3D bindings::iommu_flu=
sh_ops {
> +    tlb_flush_all: Some(rust_tlb_flush_all_noop),
> +    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
> +    tlb_add_page: None,
> +};
> +
> +#[no_mangle]
> +extern "C" fn rust_tlb_flush_all_noop(_cookie: *mut core::ffi::c_void) {=
}

Any reason that these needs to be `#[no_mangle]`? Would just `extern "C"` n=
ot be
enough? If there is a good reason, I think this should be noted as such (no=
te
that `#[no_mangle]` would be unsafe in edition 2024 so we probably would wa=
nt to
avoid using it if possible.

The rest LGTM, so

Reviewed-by: Gary Guo <gary@garyguo.net>

Best,
Gary

> +
> +#[no_mangle]
> +extern "C" fn rust_tlb_flush_walk_noop(
> +    _iova: usize,
> +    _size: usize,
> +    _granule: usize,
> +    _cookie: *mut core::ffi::c_void,
> +) {
> +}
> +
> +impl<F: IoPageTableFmt> Drop for IoPageTable<F> {
> +    fn drop(&mut self) {
> +        // SAFETY: The caller of `Self::ttbr()` promised that the page t=
able is not live when this
> +        // destructor runs.
> +        unsafe { bindings::free_io_pgtable_ops(self.raw_ops()) };
> +    }
> +}
> +
> +/// The `ARM_64_LPAE_S1` page table format.
> +pub enum ARM64LPAES1 {}
> +
> +impl IoPageTableFmt for ARM64LPAES1 {
> +    const FORMAT: io_pgtable_fmt =3D bindings::io_pgtable_fmt_ARM_64_LPA=
E_S1 as io_pgtable_fmt;
> +}
> +
> +impl IoPageTable<ARM64LPAES1> {
> +    /// Access the `ttbr` field of the configuration.
> +    ///
> +    /// This is the physical address of the page table, which may be pas=
sed to the device that
> +    /// needs to use it.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that the device stops using the page tabl=
e before dropping it.
> +    #[inline]
> +    pub unsafe fn ttbr(&self) -> u64 {
> +        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for `ARM64LPA=
ES1`.
> +        unsafe { (*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.ttbr=
 }
> +    }
> +
> +    /// Access the `mair` field of the configuration.
> +    #[inline]
> +    pub fn mair(&self) -> u64 {
> +        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for `ARM64LPA=
ES1`.
> +        unsafe { (*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.mair=
 }
> +    }
> +}


