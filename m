Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 719AFECD6E0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 18:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09A36B0088; Wed, 11 Feb 2026 13:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E12D6B0089; Wed, 11 Feb 2026 13:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FC06B008A; Wed, 11 Feb 2026 13:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75DD66B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:56:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 275445939E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:56:07 +0000 (UTC)
X-FDA: 84433080774.29.168C453
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 969EA18000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:56:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VZ9wOmwe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="WhDHata/";
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770836163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+heg7qTKAjPIHHVFmJ0qWmuBav28imw4+VTwn1Npn0=;
	b=Jk3BOA+2vKjwiO+OnUEbJFrFym+aL4CnPPWMTnWMnip9X053mtzjrVC03WKfljn/GTrO5A
	bNjOg3OQbRBh37Cpk/0MZXfZBbpwwcFR9tTWbeD74XkntNQ6Ye8wQ0FRie1PKzideOD16W
	xgn+nlZK9a0PDLqrZmyjsBHD7m3pSqY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VZ9wOmwe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="WhDHata/";
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770836163; a=rsa-sha256;
	cv=pass;
	b=hjV7V7i6eZ1BG0n+rs5ZJfFcYnXfrqaJJ2V8Bk4Op+Jca5UhgsPx6tljYBg70W2cRi/Z4O
	ZMcM8lkF/k+n0R+XwGab6jQW5fj8GnacHSnEuf7zTj6nDCxng+8jGrRIkhQ+VbRmHBr9z3
	i6XlPlQTOlnT4vIocOn9UubtN1HTYzc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B9uoja2124780;
	Wed, 11 Feb 2026 18:55:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=G+heg7qTKAjPIHHVFmJ0qWmuBav28imw4+VTwn1Npn0=; b=
	VZ9wOmweaG2WgDETy39xH8BG+rtbHJpaPaJ8eIrGPohr5CDXyW5WWAhr/uBF3lAM
	I7mRL0tABSWP3rZCJAMwTLJ6HPfHoxiKY8JoXWXUSXUO9Bcgd9GendK/LzADQFDY
	UoW+rRIVnz2b1OZVQxeVts8yqOUhdY9PkPeAhIxw9ETy+WUF+SpFJZHHYp+4M9aB
	9h4vSLTnPXlTHOW/UXLM+SlVCuQCBtCq29p6wInybjFo3WQ0tdlHe9CKGE50gDIP
	OPKMuqgPtuywbWLNleBYkyVJ7kNhm5M7qLoTjfQ2s/5SUwIqXkCbEALxqOlVoD40
	l0mrg3Rsi+FtmlsRdceZfg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7rxu3j2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 18:55:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61BHZIqZ033618;
	Wed, 11 Feb 2026 18:55:53 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010036.outbound.protection.outlook.com [52.101.193.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8246phvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 18:55:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PcH5oXiQAu9y0RQxuWXpWPS2FdLbtmcxeqXgmCYI0ZY3UtUuSvJ8FnG0Fx339zVePFbz4YEms/f4zwnuhbMkc4lirHE9gE9rFU+JP/hJpgKFwTT0BGBeqTHLq5B2kT2jiJWRu+jTQZarDF3iju9nrakiQcG71MYfpEoVODZsaCIIlLmsD8o8KvuEWfxksCafPcLfekfLT88b6RNnCQ2avGadFsUS9giUA0fFSr9Ah/8a0h8fX22x7VwAf1v4rp5GImJteRNpsACFKgx3/2vTmXx3rwPVUBdJ3lUVlTlZ+/03SMjXbwZ50lfmCoqa+5t6em5kiD0ANwKQKzeQv4UPSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+heg7qTKAjPIHHVFmJ0qWmuBav28imw4+VTwn1Npn0=;
 b=ax7bJJwN90cIL2bBWhqzjIz93F2WwWW9b2N0Eeh7TCtaHmQJSNPGZ8gGlTaT8M1faqgQZ5e2MY3wgyZPwRYSycSNTZlf8dZ/GpA9RXwZ2ZIwpDKeP0DzH5LlIFrxXPMJIoMSG27Gk/4uW+kHJ/5kkYN0xYZpVecBxBuswymE1Q8QJrD/LYJ2gI9bbHRTjQ9okBwgqOIS32DFs0ZQChnEUoc/3GBE3fi913xMvTvhmSFKQ9lJPkEdlJYd3lZlt96lNQUh6pkZr6wZwIQF7YF9950hgJ5/T1Iggl6GIJbCHd3yAQeCW5LlrwQzCfJFIGzNYXaHfaIBnmHj4yRSKs2YsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+heg7qTKAjPIHHVFmJ0qWmuBav28imw4+VTwn1Npn0=;
 b=WhDHata/u9NVCZ+r7wCG7AyuLrtndNPPFhwn/b6nCJsfMrBU7uc0ZRN4qfH9oMm4OgoxTSvtAdaJN+b4Zd7zIAvadV+hXJJ4Q9Jll+6SLcQS2PA46FD/c+0bnnO90Vs7ppq84vKPA1dPoA1UjZ/VMjK+x8S48N+kN2R6sNc0kNs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CO1PR10MB4401.namprd10.prod.outlook.com (2603:10b6:303:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 18:55:47 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 18:55:47 +0000
Date: Wed, 11 Feb 2026 13:55:43 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Boqun Feng <boqun@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Tamir Duberstein <tamird@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
Message-ID: <55jeqjcqqldnvkpnmigc5pbys5ee5xfdo3in7fhbxe7uqnm634@xsykemyms4sy>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Boqun Feng <boqun@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Tamir Duberstein <tamird@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org>
 <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
 <CAJ-ks9njGhT85pgUSahki989Y9vn3XOBNO5wxB8wE+KvbL00wA@mail.gmail.com>
 <6sd4numrxigibwynr2lfmtdj5uabggrx2l57igtjbnq4uwddrm@wipmwcmqbkjn>
 <CAJ-ks9knC3pKpiMaG6f3C1Kr6su9p26hM7YvVMzsVwYVHGtm2Q@mail.gmail.com>
 <CAH5fLghKwNEdVeRi3H3LQ9NTPYprpAeY41-jgfq8YEST9PaGdw@mail.gmail.com>
 <hq46fcdy6zvwcwlbtbjynqadiwy3wjs7raxioime2et5amzez6@wvzzlkiijwvf>
 <aYzDzeh1cTN2TEVz@tardis.local>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <aYzDzeh1cTN2TEVz@tardis.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT1PR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CO1PR10MB4401:EE_
X-MS-Office365-Filtering-Correlation-Id: f5a4cfed-e261-4d57-ddcc-08de699f2af1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1kzNVJNZEFsQzFpMXpjSzZqUFQybUVLVFNnUFdhd2VIcnZ5dFlFQUZ1RmYv?=
 =?utf-8?B?QTlTVlJucWI1Zk5DcGRCUGJCa0dpd1hkczV2RCtIL044eFBNZ3RVaGI2bFhR?=
 =?utf-8?B?eEtrNXBqUWVEN29JKzBxYjNOODRFc3VmRmNlODhqVzU1QkpzR1VDdkxwL096?=
 =?utf-8?B?aUNOSnVCWktYK1UyNldKczNVL05wVTNsOFJQeEVTNFV2RjJDOEV5K0h4WStW?=
 =?utf-8?B?VTdwQUpacUZKVXJNUy9kdmVteDBiTkFaVEZta3RyVzNTSFJ2UlZsbTVmenVw?=
 =?utf-8?B?a04rMS95cVY2dGlmajR5eW9OMGZTUUdWeStYRjlQa212OXlZV1dldEFVa2lQ?=
 =?utf-8?B?TXhqSS9rV0RUZWNIaStGNFZUVEFFaURDdTdNNWxKcVBaS3BBMTd1REtibHda?=
 =?utf-8?B?RlMwbEdBV3IwQzU5QkNtYllxOWcyTW1vekJMdmViSUNpVGZoelptalFWRUFp?=
 =?utf-8?B?THl0UlJKVU1OTlhaY1dvYVN3THJnYkQyU1ZNcFpRZ1RoSXUwZUJhbHY2RUVG?=
 =?utf-8?B?SVc0RWJmRTJCQTZuaklPTFpoL0g1NU80R0NPOFdia0VMK3NabHhrYjE1Rk43?=
 =?utf-8?B?SUl1SkRwVkFQQ21WY2xlVDlwclZ2d0dzM2I0RGZKQlFQTE5NYnk2Q3pmQkZQ?=
 =?utf-8?B?cDFYaVB5UTBPblZjQy9OemJmenhCeG1VK21hREdXWXNGUG9VWVBsWXJMdXdX?=
 =?utf-8?B?YUo1K1drMWpwaDJGM2wvN3NBcWtkVGJQTWR0eGs4Y1J2MFRHUEp1SXJ6YzNW?=
 =?utf-8?B?bDNzV2c0R09BczFaak9FQW1GWHF0TCtyKzk3UytRZ3ZhVithb1ZLVVFkemYx?=
 =?utf-8?B?cUc2MDB2aWNWMHpvb2RQSmZDb1hFekhMRjJLdnhoU0pTODZxVG0vb0pGbW9p?=
 =?utf-8?B?SGRrNkVWNWkzUXBYMEpjMVd5eWxXazFFNnF4OWFaeFRRYmdubkhiUE0xaTlh?=
 =?utf-8?B?ZXFxRWNHYUE4TlA5L3lsbW5XQjlSeStHaUZXOW1velpHczB0K2ZUZk5CaTN2?=
 =?utf-8?B?RVcwZ2MvbVdLNlJFdXo2amRkaVZRSWYzME52RlNFc09hcmVvQUdGc25CWmNN?=
 =?utf-8?B?RlpKTXZ5TzZJUlBBdEJXNDNuays2WE9hUHRSSUNnN2pBK3FZVXVNRHIxSjIr?=
 =?utf-8?B?bHVTd09lY1FrMUdtb1JRamZ5R0ZySjBMR3NRa2J2TEYxdGo1RmVkc3N5enRO?=
 =?utf-8?B?Wkczd2gyNkxjZlZObHNNWjltV0RZaGplNzMrSGtEdDN6Vy9pZjJoQ01venI5?=
 =?utf-8?B?aTFoeTd4REdna0E5d21PclhxV2tmWGF0SnN0cVpabVlzeExsVVQzV29ESC9I?=
 =?utf-8?B?emFNTlIrUGNvSkEzRnh0YkwzT2loUUwwOEVyMnVVSTFZZUdFNGRkYXVFN2Jw?=
 =?utf-8?B?RU1EejYzbVEwcVNINkpUTU1vQUJOd1ZJaTJnTFI0NEhjczZwaFVZaEJ6Qy9y?=
 =?utf-8?B?USt0aElSaWdaS21oTDkzUVJhaHg3QnBSZ1pHVnk4dkdYN0NQWC94LzlZR1di?=
 =?utf-8?B?NTdRV3VxUFJuNGtYckdzWmNzRDd0UE94QThlSEI3Z0k1bktiREVKNlpTcSty?=
 =?utf-8?B?NnBHYVNHenhXMUhZblRkS3FoY2Z3bStLZHVkMjcycXd5a2NuNS9mUCsrdFhu?=
 =?utf-8?B?cVdUYXNFNk14QWtmTnlleWFsTEIvNDlDYVQ2RE16eFl5V2ZpNUpJRGYvWEtl?=
 =?utf-8?B?Z2xMa3lRSUYwTi9PeDI3eGwvRENNU25vS3dqT0JtM1NjQ2RNN2o4YUs4dkdt?=
 =?utf-8?B?RS9rbGV6dHZHQzAycFltdUlJU1Y1OUZmWlpSM0YzS05CYlh2cC9scXYxd3lI?=
 =?utf-8?B?amh5RkErL2gwK2lpbWVsSlVQOXVzZkptcUJRWmpwS3Vqa0NrYmFuK084MmpI?=
 =?utf-8?B?NmZaNElYempPbHZEZ1dkTVl6VWhJbHJyakVKTlhXQWxoclo5dEoycnVMRmZ3?=
 =?utf-8?B?RUNvSExUaHZ2QTU5WkpsNzZNWDZpQ0NWTWtnditMcUFjNnBscUw5bTFlMmt5?=
 =?utf-8?B?V3cvL3oxYTVBNXY5dE8zNlRGRVpCNHpVSGVnbWlBZ1NTamV1bEZzMktWL1cr?=
 =?utf-8?B?enloY0lWdVY2YW5SQjNnTWFTSzdabisrYXpkblR2b0hsNDFFUGFzMytkendj?=
 =?utf-8?Q?XrWA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aE8zbTUxNmRyeGJkZ21PYUw5eE1hUElndlA1b3RYOS9nemRKL0QvQ1JCdm5u?=
 =?utf-8?B?cDU5MXFDOEVUb2FiY2NkN1U4YzZ3QWJNeTlQSkFMS1FJeEZnZWgrWXpuSVd2?=
 =?utf-8?B?Z0ZFMXN5cjJBOVBQQkFJdnV0Z0JPODhrdEtZRkJFMm9kZlluZ0VJZm41ZHlQ?=
 =?utf-8?B?ZldKb0ZzV0MxSU1UOGtLS2FoRG9wL1dXSndOU1FROHByQVRQbVVwTXVNTHdV?=
 =?utf-8?B?Y2gxVHVVWTRSQzlHT2pVK0NjR3REWmY4NEZqNGNGL3Z0NExOSjRzNkRuNHYy?=
 =?utf-8?B?K2N0OTVtWG1wR0swWm14bEFBeDl4KzI5MjhIZkZRZnhNbHl5b1gxK3ByTXY5?=
 =?utf-8?B?NHRjS3N6Q2RrcmpsUEZyY0lNVlpEbzJPUU1qOWhVWHd1S203RWFKaDlzYnVK?=
 =?utf-8?B?S0VZSUt5TkpuazFmcm1MZktGQjBQZVZ6d0YwVmNnc2FibGd0NG9WWURBZ0pD?=
 =?utf-8?B?TUdKZU85QzllcWZSamljdmVJUEFETldUdlNrNDdFald1eElBQ2JIZnZ0Zitm?=
 =?utf-8?B?bzErbUFDWGRZeW0vM1dKZmZjU3JzdjdtMk1kWUp5WGljTkF0WjhrRnA1Vkdr?=
 =?utf-8?B?Y2tQR3dZcXZDUDdaeksrZ2xMVTFuZlh3UDhvNXRDUGxZMzFjNFpacUhsdmly?=
 =?utf-8?B?THNVYXo1cWpkOXhLeEZtL1VYbGFIbEFOVXgxdG04ZzlRTGlWd2VDZ0VMc3Ru?=
 =?utf-8?B?Unp1cXdiVnBmenZWdkJyUEJxZVpYZkJzU2U4UEx6VFIyZDFSOWc4ak4wdUFH?=
 =?utf-8?B?OW44aEJzdHJjVnF4OTFwV29yWGc3YzMwVHI0Y05qTUx2TFBTRTBXSjZjS1dL?=
 =?utf-8?B?R0pidjVrUXBYZzNCeVhuTVRQZ3ViVVRybVhmSy9HQWdlMGlkLzNzWkNIK1pC?=
 =?utf-8?B?ZWJnYlljR0ZKTGxzQ1h3NmdWb2JsODcrb0lIQnphMVdXS2J5emtubjRDMzNs?=
 =?utf-8?B?Q01EbFM2OFczaFRnbWdFTXpJSytGVGJkbTZFU2t1c0p4bHlMNjc4b1dFaWxD?=
 =?utf-8?B?cE12WkhqZFdqOHRkR3Y4dGtNejBIdzgxT0tyOFJxQ0F2clBtRW5hVzNmNE0r?=
 =?utf-8?B?eXBBbW1SbitpMzJnL0o1YktndVkxVzlCMnI1UlZ0Wkg1Skt2VlhmbUR5UFJN?=
 =?utf-8?B?c05taEY1ZDUzNDZzanlNRkdjaWdDdVE4MHA2SzUvYk00N2ZhVEx4RzFIb3RE?=
 =?utf-8?B?SFpES2dhSEtGQ1NUNE80dCswMzA5OGt6b0c4S3NSM3d5Vnpid3NPNlo5Ukxm?=
 =?utf-8?B?VDZkLzIwb0NEcDRheUtGbWVhZmtta2FUWDJ3bTlvaUxTdEpCemJVb1VzRllj?=
 =?utf-8?B?TnBXNGtvL0xnSlU3SkVZaERoVFRQaFgwRGgxM1hhZUFIV0JrTmhpMUdzaGp6?=
 =?utf-8?B?M3lScTJ2am9scWpES3VRM0RtRDFhdHFIS0N0RG93WDJFdmM5L2w1Sy9waWJt?=
 =?utf-8?B?ZlRSV3FYb2ZEaGFjSFh3M0NMem5QaTBFMHRHbytzWGFaRlM4T25lOWdaeWNs?=
 =?utf-8?B?L21HUjYvalFEQnZZNUkzMGdZSEs5N2pmQzBGWlZQTTNnNGViaWxNNTl2eUJU?=
 =?utf-8?B?ZW5aRFM2c2hCcU9EbEhpZVdDdWY3T1NDNzVUL1FwUWZna2l0akp4Wk94ZWRP?=
 =?utf-8?B?VzJqYW1WZzF1bnhNaWZsMWhleGFnZHp3aFVwMEZYWG5JbmhZb2lzV2NxVVdp?=
 =?utf-8?B?MlVySFhMTUxLd09TNnhuVmJNeHVMc29wOEZJOHh5cVVMYTZ6R1pHVTBPbkJo?=
 =?utf-8?B?TE5TS1lPV3cyNWNUQXBxODRRZFA3K2t6ZWFteUdkV2ZDaVgxbUFWdG1lTGNs?=
 =?utf-8?B?MXl3UDRCV3gzdjF1UDcvai9mUkprSHNkQis4MW84R1VEcUVoZDBsQkhnekR4?=
 =?utf-8?B?TG9qVUhma3R5L0cydFZUQXp1S0RaazdJZXVUY1NQVHlybzlSYWszUjNDZTZo?=
 =?utf-8?B?VW9iRVNBbG82WjVlVmJOazhBc2luOWQ5ZUhGcXoxN3Y2R2wxSG92OXprMGpC?=
 =?utf-8?B?c29pbFRnbnBTdmRTMzR4bzJjWmhJM1JrSXpiOW0xUnJxQkF5MFZJOEFoTXpI?=
 =?utf-8?B?TFA1T3dNZXBDWVQwOXFucTNyT3JJK1ptWm9HeEsvT2FubkxpRzlwaCtRZjVY?=
 =?utf-8?B?V2xlZHBpZFQ3S00vOW9MQUltbFRmbmM5b0YzTFpsdDlteEExb3hjVlhEMHlw?=
 =?utf-8?B?eGl4QmFyQmhtR2VsYTA5OHNyUkxNNStRUmQxZnNEN1RMNldOOFR4K0lrNFE5?=
 =?utf-8?B?T2gwS3JTcnJReEVGT0dnc3JFeWpFZzRDNWpMdlRQS05iVDg3cHR3eUtlWHR6?=
 =?utf-8?B?eTJLZ0tVY1huT3g3Zkh2RDBDbXVubExFaTJKNEViQnlabk5kSjU0UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m+MQoxwbGkKDeojLYcVBrY5KJXXoIUEHmKNY8TIz7qJTvR1leaJ/ePL4d09OZsc9x+ttwkkPkEC/62nhWZnsKBRy0gOSY8FauS8x1+iz/HyU/HhQVAULozHIcOR+2lQlSRRdQQfzwDzuuzfQk87hiR+1Msbpipegus8jAG3KGF0IJ/MFYrafjL57n6eMOEBlLlHMAW6PeS4by43i4Lj41E7QfT1OgIw4iOnTgQibVNEbZpCDhE3bEAA4CHqL3YHvhGALi//7xKwy+GIArhM2nvkIZA96oz1kCE+K0CiVQ65o5EyVHfz4tcVPZd8ZWUeCx0nAVlcVBpuOHBm3TQ5q3iPKSkzFDxL7HqEU7DigWEdQi7eB2vya/3fuyBEcOl6o7StmBRjyEwJiuZV4SBlvxCR3FM87HD/4we+OZGNZPr+OciyvsxK5rt3KdTNG5CjYAvbV+Ybx5gfniuLBEI7wupYcLjZWXUQpSq2tHiTXVOb+CQd1Ni4iF12U85LZv66f3/WAijJ1fqkH9WIiN5+CQrlIxRMDci6beMmGPJ6GzSDqlc6rc+D4JMpchcGzR8kuG7cUAMa6v5lFWdUOmwL2ug9QPmMgz+K4hAhIEaEgsQg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a4cfed-e261-4d57-ddcc-08de699f2af1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 18:55:47.7032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/ms0wd06nJrMIcmmjXU22SubuTEP1w4Bnyqc1t2cVQKaITxxaQcOLTPjAgz3D8RLWUbbOwJ0q2i7yOSVuYNeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4401
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602110146
X-Proofpoint-GUID: J_XbD5X13jn16RPgpRZpzOUSjeiV7bZE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDE0NiBTYWx0ZWRfXxDSVir85PKpd
 CH14a7WXErjEJRkrHKwXezH81KOXs1EF6iZOZd6B6yXNbGYsk4OqyRuT74u23ENA3262ZJlRrSL
 L730dws4tuCRM+JZ/kOqPY2LPS4o0/y8kaBvGFG9WL3AZzX7Ww7340EjIOYO62jTZSkZjHUgoGI
 bjo/ezoS4CdDegz8j3otuLCFH02f+kuq4CDGw0Ya/MixXKK6jKCH5My9aa4M2anwLwqVijebmoo
 Abk2KlZTNA6xGN1EUn0WCU//1JkOq6oQzzFeKWOk/A5iGuZcxoDID6l6NJnHHhfOcS+nrC0yOt0
 uCpTmmhJ9x7VUrkm4Rt2ekJtOLIj5KeGG0IHAA/YJmHRqugCkJZucBcyeHurBy3YGZ+kS/rqYCD
 7k3ElbbO0J30CKWwZZa9CSFpx7OHNdDVIfhcC4HcfWrkOFJXlUG6jASFtO18opL2+M9LgBIOCU0
 DeXcHZHWJq7AkxtAPAA==
X-Proofpoint-ORIG-GUID: J_XbD5X13jn16RPgpRZpzOUSjeiV7bZE
X-Authority-Analysis: v=2.4 cv=Y6f1cxeN c=1 sm=1 tr=0 ts=698cd0ba b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=yZL3FSLA5NX9fD37I5YA:9 a=QEXdDO2ut3YA:10
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 969EA18000F
X-Stat-Signature: k41cxneegtuh7nqp4q8btwumqm1zr8r4
X-Rspam-User: 
X-HE-Tag: 1770836163-696782
X-HE-Meta: U2FsdGVkX18ipKSdElbmMRhvrq6Dr5rTQgqNOSIyZvjdOPKXHtBM2Cv4patsP/xsgcU1FUkW1eEhvYdj+VNAv+s27/NSx+773n3jhTcj2BykE+TtBQtpfAm0b6eYAzPej9jyhAB52v4/kLXkA6SHBd8AHsthVgmmw4MXOoc8YlM/NJRssJJhmVEHAPNbvK/r0HWv1cfFCN5yEFRXVCYVGaB5+3bq+Kdv91uGucuUheSHRSnEHLpEZEWw7+6Bd16bYdfkXQuZZu5WphqiG6XkYGtZyHONCPHYZvVa4T5fZT0p5306jhWB7YGrMzHztFSIpsSROacWDbUWGiQ3JEL2Pa8AO6xgSw4W5iNA+Hmb5N22r3qsUKyWJSOHmwgVQwQkroIBZo3NhALi5UymvY0Sg7W72Pk53OL9/1AHdW0Aza5FmhI4mLxyGDqqpeTJAlD6KuhiECbZzvY24L4HYV1P0EJUhRNpM5AEFmYBKRqiINE6ZXns03964eYAcNahGD4pDT8+QS4CvuM0uf3U2Y9duW41sn6WEe0cC99vpWT4nQ1HlMtAL3VLkElK8YFciRDa8X+aSfews7yIdNBgxIFUisqY6NWSmzpVWi0L07F67yzQgj82mof0SdIp3UD2QxALkk2KfFFlNMkRBzVslrSbRhsps/rNhMDHV2JswWCxa4imRbWvd6v0yXRDUo+sCM1O/7RRMdtASVAIys+Sy4q4bRFKu7KDk6iGs3d0j9vauJC4XZs9oirlZoxNiWgvHgE42iZ+qZONvAcvz7bVbJ/BrateZpqemnsRJlHLWjoB6iugNOC0vc2/MlbfLiczBinQ3xZ631ez/wagjjXMbuCurL1kQXuaCie16SsdY5Kpw8QFsSutp3TdhisZZlXxrV56hFDgULt+ppqfbS+Hip0zGR8UfjT/VklMdCKJypvQ6BtKEqc2aTow6jUQ9EaLTKO2MhwQMXLVl+XfiPwE35Q
 VTl8AYEM
 v8p6NwCGTsu2geVFo5ZlodF0fvZZfqKBTMZc+77Kb4WbE88mmH3hdExnHeRoYcylClLjbY2NcRioMPHHGq9CmCyars1Uvqx3tVeM5yf0kUUnr685gUmye+/CoWhjw7pUmRa+oOIbg1WU3yBhaBysKsq2Jw8E92T07F+9h3dEmtVRQlA8sptL53IiS5WHyaXkA9Lwblhy79rRZ2A3T9nujWWJqmpslXRF5dgt+ewxVIagz8cmEoGWadbgE18VKFtoqSYszzYavTXLmXI0DB1EH8I52an73rt8QHDlp3S8Cgl34D9LmzMMTMRzINROl0/0uGUl4M+FzVlp6YWKcdwnybN4J+ukeJrTUYYdL862OSmj+8rS2vdY2E52sJkKBcvfRZlegk/zKi0L2Qh2OBuan7vHk+85/Ud4/wGAEjajmH6DdETfnTD8bfM+g4NRdZALeEKCvmxf0KbtTBi9SyUhZiNA++rATu+PlJaDcG8B9tOGEuQsOtyyHoLLYiVRWLhZDVACrUdQgwCWTFEs29kjsgJopCZeHdMlxOmVOAVyNM5Y6fkLjU3obz3/ZGqQO0cU9f9WUe263qu2Gy9JuAB/P17yuPbq7SgU+2X1qahac4PgCrsodRP/DHCKg/os5aM5c/MmbTb7I3XXsRnHGTRL3LS+9Ue6RWuSOgi+eaU5fF7Hr+/EC+2Qkuk/8joSeTueTwrgp4H9fu98oBF7aN/nY3y3ldYe+oc/Bgp9WURIZLbloGqG/3pBSyDRu50u/t2Sm86QKs8rF21E+9D0bFGWcGab5l7nwWc6W6XJff+W95nuHYooFyhGK+Yyi4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Boqun Feng <boqun@kernel.org> [260211 13:00]:
> On Wed, Feb 11, 2026 at 09:32:36AM -0500, Liam R. Howlett wrote:
> > * Alice Ryhl <aliceryhl@google.com> [260210 16:34]:
> > > On Tue, Feb 10, 2026 at 10:23=E2=80=AFPM Tamir Duberstein <tamird@ker=
nel.org> wrote:
> > > >
> > > > On Tue, Feb 10, 2026 at 12:59=E2=80=AFPM Liam R. Howlett
> > > > <Liam.Howlett@oracle.com> wrote:
> > > > > Is this a temporary limitation?
> > > >
> > > > Maybe? I don't think RfL has good abstractions for RCU yet. For
> > > > example, exposing load directly on the xarray using xa_load would
> > > > require a way to guarantee that the returned pointer's target isn't
>=20
> Well, if we only return a pointer, we don't need to guarantee that,
> right? Because it's up to the user to provide that guarantee. So we
> could have XArray::load() (not Guard::load()) that just calls xa_load().
> Also see below.
>=20
> > > > being concurrently mutated (e.g. under the xarray lock). I'm not aw=
are
> > > > of anyone asking for this, though.
> > >=20
> > > It's relatively easy to add an rcu-backed load using the RCU
> > > abstractions we have today. I already shared an RFC containing such a
> > > method for the maple tree, and it would not be much different for
> > > xarray.
> > > https://lore.kernel.org/all/20260116-rcu-box-v1-0-38ebfbcd53f0@google=
.com/
>=20
> I need to point out a difference between xas_load() and Alice's usage
> (also what Tamir mentioned above) there, what Alice needs (at least from
> her patchset) is the existence of the object is protected by RCU, i.e.
> if there is someone else dropping the object, a RCU read lock would
> still guarantee the access to the object is valid.
>=20
> However, the internal RCU usage of both xarray and maple tree is to
> protect the *internal* data structure if I'm not missing anything, i.e.
> an writer may change the array or the tree while a reader is reading,
> the internal structure itself is still consistent and valid. But the
> nothing guarantees the object you read is still valid. For example, you
> can have an xa_erase() racing with an xa_load():
>=20
> 	<writer>			<reader>
> 	ptr =3D xa_erase(xa, idx);
> 					ptr =3D xa_load(xa, idx);
> 	reclaim(ptr);
> 					use(ptr); // <- object may be gone
>=20
> the users of xarray needs to use other mechanism to guarantee the
> existence of the object.
>=20
> In Alice's case, she in fact used an RCU read side critical section with
> a larger scope to protect the object as well, which is definitely nice
> to have, but not only way of using maple/xarray.

The lock surrounding the ptr is only useful if your ptr is rcu
protected, which isn't always the case.  So having the rcu read side
critical section extended to the life of the ptr means you've extended
the rcu window for no reason when the ptr is protected in another way.
This may perform poorly, depending on the situation.

>=20
> > >=20
> >=20
> > It would probably be worth having two loads then, one that does
> > rcu_read_lock()/unlock() and one for writer/advanced users like we have
> > on the C side of things.
> >=20
>=20
> Agreed. But we may need more ;-)
>=20
> Here IIUC that Andreas does is adding a `load()` for `Guard` of
> `XArray`, which is the load for a writer and most certainly you won't
> need to take an RCU read lock for that. The load of a reader can be
> added as I suggested above (similar as your "rcu_read_lock()/unlock()"
> suggestion above), but no object existence guarantee. We likely
> need a third API that can provide the object existence similar to what
> Alice had in maple tree.
>=20
> > Or at least name the load() function to indicate which is implemented
> > today?
> >=20
>=20
> It's a namespace thing ;-) , the function in this patch is
> kernel::xarray::Guard::load(), and as I suggest here
> kernel::xarray::XArray::load() should be the same as xa_load().

Ah, okay.. this might be hard to follow in code, but I guess the
compiler will catch the wrong user.  That is, Guard::load() would not be
written out, we'd just see array.load() in both cases?

It's also more confusing with the borrowck false positive issue in play.
That is, using Guard::load() will do more work than necessary, I believe?

It is odd that only one of these exist, especially considering we have
users for both on the C side.  I guess the other one will be added once
it's needed.

Thanks,
Liam

