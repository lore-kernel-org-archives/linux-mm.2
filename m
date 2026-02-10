Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D686EB26F3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 17:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97326B0088; Tue, 10 Feb 2026 12:44:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60F26B0089; Tue, 10 Feb 2026 12:44:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3906B008C; Tue, 10 Feb 2026 12:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73DDB6B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:44:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FE5713B6AC
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:44:55 +0000 (UTC)
X-FDA: 84429272550.13.E2DD7D0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8E9DF140004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:44:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CiS8wvM9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rdbGNijW;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770745491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtLi9y6T/kGIQ09+r2JMxjWN9Px4zf03u0FjNF1ZLFY=;
	b=iCk5QJ9GPaz5jB9SAJ882p9WPpidhWXKCx3fChrCNbtkWcNGygHaVn0gZQFWDB5y2j2t95
	go/n6dtWqyuB90pWXMuVdCHU7i2i79+YvJBrHemAbUNgGtx+8Mdj3B60Xv/0sX1OB7vBon
	Lj5aamnEGdT+vxZe/vDdobUbkjEQYhM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CiS8wvM9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rdbGNijW;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770745491; a=rsa-sha256;
	cv=pass;
	b=eM7en/TbBSMwvEGFaBUJ9a99t2xfg6GllGw2IXYVzfP5yLF7g0A5iu7eW7JJG832vB8R5B
	w6KYbDR7hJ7Z7Nvc8AbybqmesIT9Yxj5CiffYMaMSxKPhMv20SC0ikequ2m5IkWoBO81lX
	rCm3mrlj0Jd3Yif3yVC5+27UDiaFbdY=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9wQYS3999467;
	Tue, 10 Feb 2026 17:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KtLi9y6T/kGIQ09+r2
	JMxjWN9Px4zf03u0FjNF1ZLFY=; b=CiS8wvM95PKs9PgSGIIrsuGRmcn9GHiCaE
	TqTFYGwX7Uzf9xKeir+fnHhNdBtH1fNwDAID8gEX7VxDiUNAhfwHfsTFaJxGhkG2
	O6U0rSCcWJRbGO8KZjfVGmgXLsi8pIw7cAYyDKL3sa3Q/QPUs2/cdvtNziXAJQnF
	2EaUdUriIKS+1QElUiEjJrEHYmysaljsX8bn12DCYhION9VIOU88iug5Byq33oyD
	Rql6mtG7QAv6mtTt1lPSFqOr1Rn9SEjXbE/Lfaszzq+zY4R7eMlOwETXY6oFxhKK
	re0Jfpg8OQcB/FmTcsGdSUpHny4u7220ol5QSatY0sqrfWtS9aAg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp4hrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 17:44:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61AGS7l1030181;
	Tue, 10 Feb 2026 17:44:42 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8228bd0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 17:44:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEp6Xpwpo4pcDkWiZOz5YCWirb2C1Rtcbs6eAdpB9ki7O5bBUruX2Zu+f3gigjeRjZoSQ8oTi2bHltH2FLlirSKsZRBCzcJOrA1uzL3KHiOeyvOyox9DJzmM1UDZNv7XMhPchRV8NkQP2LbLLO0TN/B4B0vT1B79vKCjzhrR6JFbTn4rIWLB3hdVpxjXpk95x/TQaFPfA2oLTWj6L507RP1VNUyNvY/1lk5BQL4MddKjWpq98Q6wPfE3GaOxwBt3Izu5ihOgnwP89f4trzlZbTjim5L/11U4BrDNSvCFJNyDR17L7o097ATXR5gEzcnDzTToges942ihY+ZREIcGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtLi9y6T/kGIQ09+r2JMxjWN9Px4zf03u0FjNF1ZLFY=;
 b=HkBd8OzTu+cqQvfMy9X3Xn4CRU0rizIfmoQ6oibLJ1PMc8i0ahoBpE/seh47bvs/XbBMixZuwplDj0pfQSLpflFGYP+AGvfu4GP8oKIfMxOfrCD0K5sbnObFc31zNuMEZuPHlFCKBsoyDyUN1bB3yP385TQ5ZE6ys2RhaHb9D8U7MMop/ndfoseCYGErb8I/zF6UQgQhuTbtY6twudeC/TAW7KWB2gEfBwbGnk8+SOtathGpoUVRBihWzbYRR58wt0q23kFkY8kvAoATcjLzvs5nl/6yTrzuXYRxfi+n53dIG3qUhawNrfOvLBZnPjTt1IZf2lpDIz62Yf8wVKYFxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtLi9y6T/kGIQ09+r2JMxjWN9Px4zf03u0FjNF1ZLFY=;
 b=rdbGNijWLVkHrbelUTH0sNU5XGX6twtI7N3bvDiXlJp6YdaRiNDXFMx4ndEF46mVQmGncKp8jYVxib5GQ3k/D3uttouQjxM8N9Lhrir+EbpXS67TGR6hk6/1mslLzKIRQZJCeqq66Sm675NfU5S8iTmDciCnw8hMrqkr5Hg+dMo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS4PPFE2271E76C.namprd10.prod.outlook.com (2603:10b6:f:fc00::d51) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 17:44:37 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 17:44:37 +0000
Date: Tue, 10 Feb 2026 17:44:33 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
        Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 02/12] rust: xarray: add debug format for `StoreError`
Message-ID: <5ghxusbyvsdgexoxonjjn26zczrlvpy34idzehethqha5e7e4m@i7rnjmkgakvz>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Tamir Duberstein <tamird@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-2-f777c65b8ae2@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-2-f777c65b8ae2@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0466.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS4PPFE2271E76C:EE_
X-MS-Office365-Filtering-Correlation-Id: 6027e7e8-549f-4480-8406-08de68cc0f31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nMW2S6gp2WdHRylqxZ3vR8d3/DJQa1m/pJMghw2vHKqk5yaIpt2ZQsqYyLLk?=
 =?us-ascii?Q?LQ6n30DJTYEaGhUIkPHZQFzDgzZiIdwgv3kCp7CeDebqO2O/3etVBND44t3T?=
 =?us-ascii?Q?Bj6ZvJCx14RXrjJfcBHv0wbM2QpwA/V1GH6Ep9jZek69BFkjDk9WfR4CW93V?=
 =?us-ascii?Q?Bz76N6sbjG0cbkudaKPnn7fUmDqGFR8nKmnfxiNzj/omWxFO1TIPuDtjh5pG?=
 =?us-ascii?Q?MM6KHb9eldVtNTqFXSVBSVUe9Ag9VrrgqZqUHqEFF32wWQ2o7yVC5Yh7AHLb?=
 =?us-ascii?Q?hM4a72fNS/pVUAoaeHSijuWsJp46mRxbE/Qp/wx+IfUG76OOHTK4Kr9sboJK?=
 =?us-ascii?Q?Xa/21lBgA8Si0fjRSvE0tnK9UJtWbgXFhgO2HazusHbTOG8I3Gv+1wW9gT/r?=
 =?us-ascii?Q?nxSviOQ4nmxNJHDjm6A4B+hSBRpv9/+IdYFKZkpWvJGdQgHKDCuv19dQ9iM2?=
 =?us-ascii?Q?EFRG98LQTrU45/FgFG+Z4SiL7fWWqJHKGxLNNI84/HPhPmKIWPbW5hA3qpJz?=
 =?us-ascii?Q?igJozYCBierhEAid37N/jTq05pBrnEjvip6BXN8hrlWPKau27q7xPmo8LbSR?=
 =?us-ascii?Q?O7gEqaM7KlWB72TUdNVER93Avke1l4diHpaxyWSEQ3MbzTl37iyh47a/fQg1?=
 =?us-ascii?Q?j9tXvnE9gCstyiNWZUi3nJvXw1pO7jv3Oqnm0K8Lk78FCgAVb/r37+RKY55f?=
 =?us-ascii?Q?6e/5MGeqpJ+FDaXeztA/+yH94yWCRG1hWdEsx5dWevokbdgn/xogdNqgk+Sk?=
 =?us-ascii?Q?SA0bAEL/P7Sl42Yw32D+FyiBi5AkL5yXR/ucSvJfEgmRjfccgiZC0/3lihct?=
 =?us-ascii?Q?G4LrMVweMdtNebroPqWQpYNTQOhgYKM5B4ESN/AooNWh4j4Ytn+jqQhNT81i?=
 =?us-ascii?Q?5Pj84psAVgSbTc79TO97ArSfGCs3bS5MUKyJyO12qgt6o6WK2FAJg95M9Pxu?=
 =?us-ascii?Q?SEfl4b1X4vW8WyIc9AmpUUcz6QJJcdL0Zy9Pp8QUiJFmqWQvvehbIC5GGePw?=
 =?us-ascii?Q?6zzEnUI8q8N7Uq4d1CIzwN1XAprD1u3LZINPQh8IIYvwKEhxQEdTSuZWj7DD?=
 =?us-ascii?Q?uzIY4Qdb3KMe+1mhWclja1LPDxYdRIN2t/ky8FjSe93l6I3rWWKyKqAs3At7?=
 =?us-ascii?Q?peblRHeF0H09dB5LeY+RGpAF67mEz/RU6kk5ypotx8NGIZPJ4Oej/v54C3cN?=
 =?us-ascii?Q?TBXkotNN18m5hUgCrF+IfQ646wmLxy1/TeNznlCte5XZDOxD5rjLyd7Gc/uD?=
 =?us-ascii?Q?4aQx6d2djUPEjBZA0LYammdeNoOFngCQnxVZShSI/Rxh7xeQ6N4o7KeqYF4V?=
 =?us-ascii?Q?S+7E8y82ZWZWCr5STIgc9wluT8lJiPpp8gudESwG1KT5ON2CxzqAd3dji061?=
 =?us-ascii?Q?lgxrsulTvXA5fVo9V5qMrf2WiPD6Udc0tRv15shRYgxhZAYMROeS2xreMIcM?=
 =?us-ascii?Q?WQAiyIbFAFwuQBbAlT68Ib+nfnfDhRxhZTyImWC9qvAFbkzukaROArKZJh6J?=
 =?us-ascii?Q?3i+fkIHYEmcG6I1j724cZLOJGzHab+zgBlFTdBSjdlk5y97qkTUhNVY8j4o2?=
 =?us-ascii?Q?SXM6Ixhav+eBbX5Q3t0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3RN/XtmrtJ+V8KXH4zwfXrQv9fk/6a7tGaJCmfC2kO+rz2rg3iPmojChcNhF?=
 =?us-ascii?Q?xi4lvcjRPvsMch3jR3UfHktAzDu54/ybigiHuAwM5ynjadA7cEkuImGjaAdZ?=
 =?us-ascii?Q?qszYsRTH+D14ZKH/l1DpjNYZ4dQVykNzOZvOFQ+UgUsozWL8CCve0fKOmMth?=
 =?us-ascii?Q?AgJf/VHz91KPewpaQCl3Uhykn8VKlUaTjs5sRfVy89F/ebGt/LrhrM35etRs?=
 =?us-ascii?Q?VnqoGTgQJVg3dHOcOmYg9Su3E7kF/61PzM+nax3UW87WMaw3U7WJWsWkL4Mz?=
 =?us-ascii?Q?V7NDOGxGJaAGe3vuoLQuLOQItsj4VNIr6HZhS6LKjEdkckvewqlashQ/9/18?=
 =?us-ascii?Q?uF3FNuJJc08/iU6MTXuGtsOqyI1oQS6tHFUiky0WodB89w2NmrF02FYVTLhl?=
 =?us-ascii?Q?PP8qPCZmeEyekd5LV4urlu19cSmKEgYCjqYc4Smr//e/nJa6s1eJ/zEZqaCm?=
 =?us-ascii?Q?1MykS3N6xEhmNVKy+pXmS3g1rWgwqQ16oLIJXpW0Hl8eunenwZcIzIRirsCj?=
 =?us-ascii?Q?6nXZlCfPP+RkNBeoMbMUHxg8vBLKtTdzXBTVGx9CAUmh0MSK9q6y/uIQyoe1?=
 =?us-ascii?Q?UggEWKjbJ8WYdEWi7QXF9IYAfrtE7mao0tELBppWDgKrpI3D+yPF8a7wLNWR?=
 =?us-ascii?Q?HyQkVATMHrPt2EW0mHNBPztlyFc+fJQORplRU9IP/bYrN8NGPnheJUpS1vPk?=
 =?us-ascii?Q?fKi5UTmgY0pB1hX03k72q37TW02CcdQyK5umbAIrT0DJEgumt6wzajrgLZti?=
 =?us-ascii?Q?CPvKYHMJFQ+WrgsBIvsrwZKgH2xULPQNvZkPTGYX+QdgHxfklBwgCKUrd6KO?=
 =?us-ascii?Q?6CzxJdiMya5rWQA+ixNWzTqeuNvQ87NeNlfnqep1D4Fw7JgwzaSgKMD7M97Z?=
 =?us-ascii?Q?R9j3f/hu4Av1trniR8DybbPVWKeWNaO8OxjE7uK9huRRnyDgGTC/+V/gNBaZ?=
 =?us-ascii?Q?L30Gu5n73TCQollYD4JKjIAKEgNRomkPekGLxFhaRAK/ACtD9moNTS1vsIGE?=
 =?us-ascii?Q?xkj2c7ctuSnybS23+e7XHWAecBCJd+R7Bz/VxUEqRJ4Lv0qk4F1v3hNabxGG?=
 =?us-ascii?Q?Ur/55epXCRIn2x7ERBZjSL9OLzDTxXTIpLZVljuvB/t5w97LTrx2XwUCEjdr?=
 =?us-ascii?Q?qyVVm1XHr/B0oixM97lFsUFj7L73pLrLccwB4oVaQy34oxZOLTO+J/sbJky0?=
 =?us-ascii?Q?G0jArKVn908uszf+IEFTrzcLK2CGJTXpDkb5cYxPk6AWLMXt/96OMnM9e52p?=
 =?us-ascii?Q?G8O/OSemXepE1bfd09x5oj3K/rcTRDf2UK4LZCj6y2PiJG5T4IWsunuC3WXl?=
 =?us-ascii?Q?805HETWWKfsXZwhhXGPP5yL5YVg3DtSaNtW+5tPVr6Nt4Bs3cLfXS+lzY90h?=
 =?us-ascii?Q?l0UbcndTrnRBYYv3hdKoV0eIMqYWW8hrLvRJLPLVv3sNAGSgqINpvxs/H744?=
 =?us-ascii?Q?NtmO563mxSj37l2x9xyH4dtJp6m9psIE7aDKehMPWlwsrFjBx8j98kMoqPR5?=
 =?us-ascii?Q?7xCT190iMT+erG4Pp81co/23SZBH9cMUJBHljANBKgGme451OocJYreJ+rEG?=
 =?us-ascii?Q?nBEGI5iwqLbABx4Jq/wcvXiIGN6lL7ODc4iA37aXt3gpdQbOAFDpoSSVBN5v?=
 =?us-ascii?Q?Z65jaiX7nI5imfbdwNNB4DNwTL16FSFD9aN+tC0Jw2k95NONBuGuAkl6U3uJ?=
 =?us-ascii?Q?vjApzfnoyjN3b3b7ddwakslyYFGA/rGKmcVeD71rO8voSHGEdtEWPIStbvKg?=
 =?us-ascii?Q?bcctDiQ+Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SKUgo3XAXad8INQNiAqQCOLZA2GL4KxY/x3ay6mYHu2sJSv1fBbpcjQ7DCCE8L1LfLqo3mnU917AzEm4iQ1Bx9U8RgMeA8VaKuD8aHNfBtoKcB5logvrlWepL35PQC4EzQaAwqNJ5N3KDsQGi7HK7uA+wlOBp0WnStY1ynidUZp0ytRa9D1R0su5OXZaBDPDYV7dvSVlEHw63XZwexUYWCDDCjzJbafRMCZ2wlkgC7pmtqjI+kI8oRtON1tYt637TZCtRqMRN8t+BYPjlBfIGWWFI+rukJZbjpocoZ4lpagah+ROZ4uCDgT+ZuapW9fmTaHau/5IiBKryQqYbPbktsLbN8eeAXPBu7gFIGp0wNG3JcpC9GRnPUUGX6Mo1/gA61Sc22hDxx4dHd+uRVn3QAk0w4XM/fIoVP9Yf8V3M7362jXNuCReIycRNMpiwr345iZoLKO2z4mpgF8vwvVf3zQCc2ZL/h3i1c8WLzi80lWq33b/ELUZY9x9APFjWoXou0keyFtaVwHad+8K8+eR6iyogx1w2WK2VsrCeqFHWighAyXve/d4EdOaGt58ZqVIbULuNeo6xfmo7T/ifw/VD2DTO8+8E1kX3X8blOThDFk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6027e7e8-549f-4480-8406-08de68cc0f31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 17:44:37.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rlwl1AEN0DGrIhK62KSgexnJ9MmrEduue+HeJmN6ikfQPsZNxRQf4VeJpc4B/+ZAvxu/vAAN/inhnEX90rXdag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFE2271E76C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_02,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE0OCBTYWx0ZWRfX2yCf+DI8MuiD
 of6Z3XXpalsRydeTVqEmNoUn2TtbYc6kPpEwrEkyRIWeEvgzVoKseORJb5Wypbo5DWhp+5hXOIm
 fc6yEaZIEtQtmYUbXTpdyWBDro1wDPQI/mKT3E+PFe9EnW/sraH2xaVslFJnfQ8sAxR4sFzgFGk
 +dTv9XIQ78tdTePQvbzb9qDQ3T5hD/FTlMYNeF4AGvqGFLR5CFsKlQtHGZCBic4No6UquziHvar
 H9cQZ+B2LUJOeBpxZu3VCfV8xmKYlJLugPXKJkyNxvH84xGGnPdxfA1osUI2AMjQbSvfdiuXwiK
 yJwVpMfRSExxqsJMXz53YxzFcOWoEh9G/7PFuNyMQPMzYDb7LEQduXW1y1L+ur98tQRWXc+nY4u
 +PRjvpikNzRhfjZc1DkFHlxKfF3AaDuKshOrzo79y758TDt/Xa1hcMGLnJ3TU7v2V9pCEk2kd5f
 JJ22l+g/9qyUzprFdUg==
X-Proofpoint-GUID: Tve2wvJUPF3xQ_xFU2CzFE8aqiqIanna
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=698b6e8b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=_2yia0w1AAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=THcrnZPhnZIA0t3sRdUA:9
 a=CjuIK1q_8ugA:10 a=4yAS8WwzZ1jAEY03B-5r:22
X-Proofpoint-ORIG-GUID: Tve2wvJUPF3xQ_xFU2CzFE8aqiqIanna
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E9DF140004
X-Stat-Signature: 8r5ksbz6z7p13wj96qrodcepn4m5j8s3
X-Rspam-User: 
X-HE-Tag: 1770745491-191772
X-HE-Meta: U2FsdGVkX1/I3swzdqsgy6AUfqf5guKqpeL49vvqd4vbdYWFjvYoNDsXKnDW9dkLpF0IGgCic0SM4eV2i/NRb9PWnQUi+1o8YkF6hwK8kHI+I3XcRG+gfmLtRxbxSSIwdMl2GKWbsLyWPLifhmiqEi/yeR6eCCJ461qJrL/FXu/78NQVrSdEMfBQP7KEhvJ/lYPkeHWg6kp/iUMjXy5WLuJ+7TcZO+zWHgtUUm+rfSs7BGduajhNVtqp21NKz9rGcYxOJW35jOEEUED1h6xHTmIvIeSv+/3Ug1+cI4OGiybrSKcLLCTBOAqx6tgl6b+LR1QcyBLqnQuHq33jWlfYFlFTuhPW3+I6dMuHFjQ+/axbY9puOIxPJTuDxmDhnEsqQXyG7SzjubzLpqStdUi5Q4C2D/w5CwfZNbATNmsLfHjGSu47Ic3zTPNiP0SoPN33RBah4FeoOlJManEBiiBgyotKy1qdp4RQOjR65ljbR1wdpeAnewdR+cVrCDpb3T7BvUtl9NLhY5xdWG9w3gNE+wc5soGteb2z2GS4PKTSXty8CJoiTm02xd/j6I7vPCQ4AWbke4yHjGe4KNbtT2UPCbvcVeHXLSWRUO+umlUcRwvZOC+luQCoMKGiFyVKgXoV9WPyiTKP+gCpAfQdn4KbqDkTRQWfCcO1RUqDuWcUS/BHaD/yY2Z2WjtatKhN0QPUvoFmcyXy+vz67M09RddfyVY00W25cRX5qzfGtnXdzUIPRQS1MUpxtQ5YGOtWRiEcWdrrEGQXxq28K++7rcpABVukeLnndH/9PH6Elqlq3s34LZSlr4bUUfuoi1UTXr7e23LcTbr2Zcz2S0imcqrudnSiqq/NFjt0TrTm1CmtlPVgI2YXDi79kPBOZljpvu3wmuRfuSbJi4DEOhwsgsdoocK3OT6OgJ3BTug/WBVsZnguod/nIMyRAp5YSvtsHB6JAhIysnXhj3cn3gpa2BR
 gmbcDFcO
 gC8md0zgkkWfTkj78Q8F8HFq625fT9ZBsa8cT5P9qnzGu7S2qtRt96+8aH0n/pTyjWmB4eohD+JX9MZGmMhkgr75+s/0zFNt4x479kFKHnRVSSI7JnBLn2SnpcUDQqoz2Xke3VckBn8t8Dj/Ahgh2rSwQ+90kV+WAkeKwfrw0VOkvDtf0F9X5Mn5ANH4dfUgPasLRrPqBZbFm4OwV7FJ/C2ivnuqFWq+U4F/8NI/OWhWa9osJng5nDpj31y9ElDoGlNk3Uc96l3aMg91rKniittIlN4vxXH1sTrjS6UzrX9dS9b9Tq6ptmx740SEUBeqEb5d84j8Y7EayqYHeXnMTHVdrceAvmc0+oJbztufhWlUZd4XyCffTfWZm71vgCBCVT1+zduZ/4jcOZNcrfrwSwvNyz8DuTX+Pgsfh5J8bNJV7HJY5FSSbqdqjAt8YwHuT/mXnZOk19RADBWHw2w47Zcq3iREgVIn0dds6w8T8bWeQXABGFctbU9iWL9wAW67PmXNgjl+HSPKEiPYE2OUKMi/pdJ7KZcqCIyPuuTHhltHGWa/a2uI6DD+Yp8kXFM//SOcbdofnCHFCC04biiW+N7nd6G5yLYt7C/cLDFg5gsetiFEXlgNgWk9aaH9Me0Kn6xrMQ6WZfl595sS6ELi7qt94kEn9ghTK30RwFG2dMs2J6923p9L48HcP5tyxI3se0/xcKpa8q5QccaoBHBiLHksdiMHLUwadB+dY4EcJ66yx4h1kpE3VuIi22ldD2XN2fDhj9WulyO5/Sm9MPyzFRIr7bjia6r93cKGz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andreas Hindborg <a.hindborg@kernel.org> [260209 14:39]:
> Add a `Debug` implementation for `StoreError<T>` to enable better error
> reporting and debugging. The implementation only displays the `error`
> field and omits the `value` field, as `T` may not implement `Debug`.
> 
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Acked-by: Tamir Duberstein <tamird@gmail.com>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> ---
>  rust/kernel/xarray.rs | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index 88625c9abf4ef..d9762c6bef19c 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -193,6 +193,14 @@ pub struct StoreError<T> {
>      pub value: T,
>  }
>  
> +impl<T> core::fmt::Debug for StoreError<T> {
> +    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
> +        f.debug_struct("StoreError")
> +            .field("error", &self.error)
> +            .finish()
> +    }
> +}
> +
>  impl<T> From<StoreError<T>> for Error {
>      fn from(value: StoreError<T>) -> Self {
>          value.error
> 
> -- 
> 2.51.2
> 
> 
> 

