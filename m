Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E58ECD6D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 18:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2376B0005; Wed, 11 Feb 2026 13:22:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66FCD6B0089; Wed, 11 Feb 2026 13:22:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2956B008A; Wed, 11 Feb 2026 13:22:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 38C796B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:22:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3B538B4E6
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:22:08 +0000 (UTC)
X-FDA: 84432995136.06.6406D5B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0C1DE1C0014
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:22:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FpzWCZ1t;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SXtpJJVt;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770834125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfZVEEb74swq2m0sRyvOUeaFgBk5HYVc9+WQMjbzgcU=;
	b=JJ9YVw5WIbp+sE9Ugm8kqWcHHBOhidOXPiM0Wj1HgEo3Dn8JLDvlqEuh9pWwjFM7/y84Eb
	uAakHzRCPygOfb6q9guT51WU6EieY4SIjjx4bZDkLkcObqw65gEJ7jmXFqy+FbKYCSmYnR
	k7kRbPtzwtsVGSPyYrbFmwiBh5fJO5I=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FpzWCZ1t;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SXtpJJVt;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770834125; a=rsa-sha256;
	cv=pass;
	b=MhtNuZmEarovnucmU5LUH621MGPNVYN3ahPI9yHtzRK9E0rjoYMShYxV1OWF6Iha0IKOmj
	fOHhbhbpnYLie1NDifPAFOGn4+NNdVG2TPknFnoCdQpgZsf7B/JZ5T32IbbJIqargpy0mT
	yjZvImHz66DCf3zybOFYsFxOv5oiYZY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B9wSN01759149;
	Wed, 11 Feb 2026 18:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CfZVEEb74swq2m0sRyvOUeaFgBk5HYVc9+WQMjbzgcU=; b=
	FpzWCZ1tdZkSHWVvMlfk1h3EjD1wH7Ad99Kso36XJGrwOVvk6C0nEB2bDPi643sL
	LrGS3yXxeLynRz12qtkstHtGHyT6YAkuUQgrceFGFjlkMYgEa/NRhyZNWANaQ7a5
	U5D4oN5gn6eovINbhBZacz0XxvfbPu/WBQ+1RcqhXNkf/ep+m1Oeglf4nhqzFfi3
	DPl6/2YJfJIrumw9vpAOtZIZCXtq3NP44pBuJRPcswZIwrSG6kT7SAkefLEqINd+
	Z60o8n103RAkEX+YwYqZagQp0OR0okgnLd9zj0pXM0rLO/XWwFzRrmUG5xTISug/
	PT1ICS5X/iC8Z3eQLduTBg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88n7j20u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 18:21:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61BH60IL030143;
	Wed, 11 Feb 2026 18:21:41 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010059.outbound.protection.outlook.com [52.101.61.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8229wkfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 18:21:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RRQrd4ExcvImGU0fqaDoLnbKiBny3BEOFGZ0cK6t5mZ07pOTgP1tj8MdhN32z3B22HG5pi+lpKBKfWCdHfWf8oUw6jflu+bvWZDN6nd15RFKICIxAhll0HRk6/aQUh/DK9mSdQwOXOtBjdYpffVzoTZJV7qJRy7H6yZkN8kCpKLnAtNMee//PeonI7/exD7iSVL4hEsvV1Tn5XZPPWzZ6wLlc21ndNTb3L/psLpVsAYgmd5ir4PZBriVlHXk2y9YELQMIQHN2qCY62zV5zYx6+AXXn5Dw7MAmVXRZ5AujmzQA1Tiy8lbXsuL+cACDZ5owDC549WD9MJRvvDe6dOIcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfZVEEb74swq2m0sRyvOUeaFgBk5HYVc9+WQMjbzgcU=;
 b=AJmBV8FbSRk12OTYQQgPSNORAZyxrUrCT2SiT/N+NflsEe9QSfvPLLZ6DRZLU2rW2J/asnmA2wMMGdRpoFioezKkdj2AJTR/YW5d1iJOpgYr4U+gZl/zCHyRpfYmwc4XUwYW899zdzH7U3g0bAQP+y7c7UM5nLDiBDeDaQnP0Iv7A6WFSuXLDDVWXErwLjZbwfxBACHvLTlUUtNRTdgY9iLOrYYLpli4SMr6gfktyTXQKgLS0D9rQY4kF6FAxHtEcoSbLl3FcCmTaYMWcvJWMLECIfJ4eGrUg61O7XyAyfznu+Eq6nTxeGJqlZuqMxfokH9b5A0qoAZe+mJG4KCj2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfZVEEb74swq2m0sRyvOUeaFgBk5HYVc9+WQMjbzgcU=;
 b=SXtpJJVtLx6JpNupO1ntA00aL9nvkEpLYQH83sN+uoapYORIiCADvA8x+2UsEI1hm8pWyVXhy3MoOjpsBcIQ6ozUrTQ2FITX39sxumQn7zMwpcn9u7b5X/RZApMw3epOgxC64cxhAKy7jwKTuxp/ZLUCJeH7429lU019D9SLTZ8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB5568.namprd10.prod.outlook.com (2603:10b6:a03:3d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 18:21:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 18:21:30 +0000
Date: Wed, 11 Feb 2026 13:21:26 -0500
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
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
Message-ID: <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
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
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT2PR01CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::30) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB5568:EE_
X-MS-Office365-Filtering-Correlation-Id: 994f0660-f0b9-448b-de41-08de699a60d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ulxfrppl+Su6c7gJAGxV/Qjez6EsGVoPi/c52pas3fdrYcpacZ8zWvW3GAH7?=
 =?us-ascii?Q?79MEibEkX+rixb7SAWBFMNI0gLs9AnQ7PDMRqsKnMtKp4NcdJwvoX8xhCoUR?=
 =?us-ascii?Q?/m+SuFJik3Bdk4YO9toYTcieoM4M0WBuMkiBKld3dUVpWqjeZvnEYuhnEgOI?=
 =?us-ascii?Q?WDSTwG3A1xj1VyCEseSMlT1uWfqaNuVqMhAJtUtwEYwU3/E93f7ShH1vqgb1?=
 =?us-ascii?Q?JF0E7Yb/iRyseVVVwB1CHERFpjh+S1JPs6O3DUxFG8vvDvqk7xvt2GvNhQ2L?=
 =?us-ascii?Q?+spUhsnmYoroqKHLst+tduj2eE/Tytm2rhQxprsCfMkiaMqc6VBAfuPxFvew?=
 =?us-ascii?Q?+w1Ong8CjP9YGsDNgA2JTOIDNLcFnjQv99ZEEhHhsD17KUQIHYoanuS4Z7z3?=
 =?us-ascii?Q?q0gm93SoJeGJxRHlIPmTFJLWXU56fZlOzmyqOqPiMDo2VAoB44Z2Q59G8nqt?=
 =?us-ascii?Q?WxYHKk3NIyesCS9jnCpqqgs118Kk3DhxaP6Bp+d50w5NHQHhZgLEZjHI8UbQ?=
 =?us-ascii?Q?02Z8gD7RzrMrbJsGA89hTsUyJRRqGj+YQIw+XtwjK7C+GY5n1Lok5pjjd7dV?=
 =?us-ascii?Q?hvvKCt98FLqViRTB2OoTUJhQsyA9x7kUq/5dHubNTvQo+Yb1IgdZOQFWDoH3?=
 =?us-ascii?Q?Nhpxatqm7mwSGTYnSWYKSh+Nl2ZknTyI+n+YWy6l8Hnip2nYmLT2UHmb1VBp?=
 =?us-ascii?Q?9zV5/Qdm3U8t0r1vtUxCwuS8JP+/Bk/CkAnx2ESlDw4v/wKqRNMJu+6mHjgG?=
 =?us-ascii?Q?R/QMLhbOIPgmn0+lmH9SQJ/2ipyp9Lvc4FhMpo39/9IDdi0QQJ2KGbp7+TDR?=
 =?us-ascii?Q?3kd/CMYdWwXRL4KrSicDqdv6HbHIg0KQF28p2wBwZ9XeSJQekSo/ZyMyWnnn?=
 =?us-ascii?Q?ugflTVxvcoZs9uD+b3wf+0xmuITIfD45t5s2vSxKlzO+rsfK7CzrvTvwe2oG?=
 =?us-ascii?Q?H9DimfcUHQ2vjonnnmrKMtJh8lde2o0LuuToF4LfQBXvSbHkTPaF2pmem0aj?=
 =?us-ascii?Q?zO7iupkQkca+F3w0/1AYf1mQ0ofU7YGAKWm8TQFN52zJZfLCzRvbZfJR9amw?=
 =?us-ascii?Q?DoFoutHHCI6JfAPoP/ZgFYuxLomSwVd/RSxVQ5bHsMcU+A76pawj/Mpao6DY?=
 =?us-ascii?Q?UQCOKge0lOhZiY4yMROTWi63ev9LmSvm5uoeFKVGZ+WUDj4M8I9DpdGPKz/T?=
 =?us-ascii?Q?olBdJfdAOCTdfAoYBmLNIHjqyTLDIoqtYtyRuWemO7QnLEYua0xncezYRR8Y?=
 =?us-ascii?Q?Vzy2GI4p46uWeGrLS5GyAeZu/r8evSKt/hUvshhAH/iSwClnaNYTwz8PpOnP?=
 =?us-ascii?Q?OYaxgnH1zpYygg8WfI7WxuM+vIptOeqaIdow2REI8l9WTT47PcBY+B2Umubr?=
 =?us-ascii?Q?yR79e8E0aWnN+//6s6kQcGuNNApVNClsKBRm/Gjzh/HlzTxFu0z3FiW1av3p?=
 =?us-ascii?Q?MReZS9ShuFEr3kVEcUHGFOlUzHbMDT6DxJXPpmBoFNgiZ9C8Z76OlPipCaFG?=
 =?us-ascii?Q?2radhnuDtzf1pQg7tCRHL0wBt9mtxiQG55Qz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Jdy4MO5D+j4DMsvPFTXWJoFCSc5GVQhoBW4wLEQz80HQHqBdJeaKLbSiXdU?=
 =?us-ascii?Q?1HTFaEs7mwD9NOpJYuKc0lElUZqmrec53soywleHgCdntLdBpE5gtrp3mLRD?=
 =?us-ascii?Q?rCtoweo5qXDdslpq0xwPWEYs909/n5NKiQWgPWiJopMxBrHrX2L9vDK3fGPd?=
 =?us-ascii?Q?rOa//KISA4aNceBLiRUPiAauSyJCfAD/K9X2woYXftFv3cHHmHU3mv//HMR1?=
 =?us-ascii?Q?eg67fagAp2BH1DbuZ/aONZRM95Cw5rbYjCetRLVwLokPCjmGyMsmT/jfzt3A?=
 =?us-ascii?Q?h6mP//ByKE7vLf2LbUJxfltFC37eChWYmXgIuYPg7sQRqXgU2jiaLL+3UJQv?=
 =?us-ascii?Q?aNKO+NniUQt3TkC+dwN7fiqpCDERJ9zL+0qNtHIkP586nQ8j90yPSIA43TGy?=
 =?us-ascii?Q?8uTaj2AgM2VT9rTwzailKSqT3Aj6g3RnO52AEh335a4FYmWk8IgfsghDey3J?=
 =?us-ascii?Q?n8AGVhxuklUb+eTVxvyj77Ct+mblSZ+IzCZRgMQV69Qt1HaXvV4N1l7eiDIf?=
 =?us-ascii?Q?IoYbAptxFcT63tZwvb2ujmZ1LGc23faWpnb9WUbYNfkMQXD+2rFGupaxJkUw?=
 =?us-ascii?Q?GXZz2ObUPF2FKRC7uJ8X+cBNZZPCXemZYCALpHCBblr8MBEpW38COV11B8Dp?=
 =?us-ascii?Q?8vp8gP6klNxtF7tIi/+t5a6VEbkmjBrjPZz6uMfdXgK1RAO/2hDM3zoBhExd?=
 =?us-ascii?Q?ry5R0xc/MoMNtktJEqI0DZzzFSJh4lc6IGKjZfMNys6Vc99NSJutDiAq4ZiB?=
 =?us-ascii?Q?iMYJGmCbyb8cTiOyCbnMHXGQtBYwNaQvOHK2ppb68ZNIgUECIXE9RtC7Ruc5?=
 =?us-ascii?Q?xHkCpkSBNUSaoWN4zn6ySu8W7luy9ESnuRNdwGYmltYdv6jDckVBj8ezzR+/?=
 =?us-ascii?Q?lMliGWQKzWk3Y+lR/kwzfwuKzcCgIB07tZojlXKg2n23/50BjGkAOE1Fo/GY?=
 =?us-ascii?Q?0eR+/rGFnIsXvxxen07m5xeeZkDSbQ0odH+CkDgyc1xW3Q+xeA76thDhp2nu?=
 =?us-ascii?Q?4zOaEf+R0fZH32fVOXWLV++6a0n3vMVxDyR8mPiHIbWApVD3/vpRhBGRV/Cy?=
 =?us-ascii?Q?Zx20ZICTc3F8rn/OUwCyObjwHgwyWiiyVmQeiA9r9g6+r6wERGPamjJXXxA4?=
 =?us-ascii?Q?WsCETv57jE7wwjhDSDgwhBU8IiByxNyxaRMavYs7I9ff6+qOi2AcBf3qLW/4?=
 =?us-ascii?Q?Zzasvw9TPMIJdcBzuaUScZeytxJBB6AzktK1q7iGkSJ9wZakBfhRzBb3DJWY?=
 =?us-ascii?Q?pTjYBcxD/WKzk0b/UNryLWbjWRIophyrH4DzhLE/5PFguCXbIAKOJtxfrzPv?=
 =?us-ascii?Q?cT7dKCo6I+EXpYxyUNAr+/wYquubUeWMpFeg9Y/hTR8ryN1x7u3oJ0S8rrwr?=
 =?us-ascii?Q?gadvdOyuPR8VeRXrLzgnUJBMBjeQYrCua/sH0/WXN/iT/F2dNZ5jZAwWN5O8?=
 =?us-ascii?Q?zRmXQ0CSUK99iCq/imRNjJIEV55dLfLwfVdqz6Fkwej5PQXx8an6eoOHLVwK?=
 =?us-ascii?Q?5SSLg/HGskV2JqtIte4ALPtAeNcHtoSaaohpnW5gFRiyrp6H490ZF4lT6cls?=
 =?us-ascii?Q?TPAo6vEtrgFlYk1llHo5apVuHuNd+RCHcyhtpn3Cq+mBbKUrFOO+INn1Qlkg?=
 =?us-ascii?Q?brfjjnKiwKUDL1XuP0PU6bNNa7NxfqYvnsdpozFosCaB5M2Qu/h4BCDooGqi?=
 =?us-ascii?Q?1QR0T50NaumwXDY43auqJRIRUjn9C4vd2U5xyyh+BYs1B3dT2FalHtWvRCq+?=
 =?us-ascii?Q?2ZL2zhbHCw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	faR4N3ITdlBJODVxyfS+jKPcVCBlTcNrX9pHdbn/2iOhe/r1j/bQbb5nR2z538npmn0jW1XvrNqiwEUbquRFjgXkvTzul+n9Bt6wSsR2ThduVZ3I8+3cz6h/WxZ24MlYdoDVj/hMPj1VBZKuqNiKl4QAP07G/506Pfgrq1xwfSL4VOmmLkqXvrin15E24eymG9nFI2c5BD+6vvXeDCGM4Jf9gbxkrC4NWfa9Q9i5n+c3q10g2i4GTiSdeV7YtvKsAAl4ugcFaiX1CowZyI0n1H2cfQncCodunZi0SkNxf4BpKLgltls32go6uodn3iSlC3DoLDckzVaIes1S30sWX5spDIJBDPIpE7wCc0lQeq/89hvmeKF2M6ciaI+5KDJduWnWjrKxEl4rMSTUYpLgSWA2h2cP8arQVBPBqmE6wZTpu0iPiti/7PoDEmZVSAGkt/hCNwvryCDD2YhA60IUy3TeUKV9kAXLsFe5+yw8B4LMSihp+jqt2CDp0WNxGOWQ9S7frffiyGUTuoYrnRiiqmwEsfDU9j7Hks+rxBq4U98aWePdjIpZHD1q4YECJENsSCh2VQZSFmIhhHvtidr/EuaY4a93lUgkPxVfAi1TRSQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 994f0660-f0b9-448b-de41-08de699a60d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 18:21:30.5338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLuWO2yj4+psC+vOxTOd1LgnwnyaFoN4BaYFJgWjBghpCbJ9d4FL94Sa0Sa034EXKTlp3CIYTN0qqI3rD3O5UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5568
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602110141
X-Proofpoint-ORIG-GUID: J01nSVrnjuVkv3o7ewqXPdaM37a4fmc0
X-Proofpoint-GUID: J01nSVrnjuVkv3o7ewqXPdaM37a4fmc0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDE0MiBTYWx0ZWRfX5Ve8WaRB+N5Y
 2H8efafMYqFsslTMLF0MuxR4hvM9G5kYpbH4GlkKyCzackXOqNjwOq52006w9A401g+3/wOTEEe
 PmdAvmc9RGRAiZfIYJpGhS7iDBMcQM8VI17kNL8lK02a5sDzh/UZPZm3Fh9HsdP2IyMV8MapvFy
 o65xCU6BwS5rPz4VMdEkJsC5UoQ0lIkbgWif1bQeI7B8ijGQtMi/UdLfeni2wi6oIUPuIkb1fGf
 42jVPF+PHXVUjQNNrwyoWaHA8uwYsspK6sjzaxXtcXpvtg4TsqyY7RqrhAYgjPxF32iO+OYNBfg
 fsiVPfuStbJh/xBqJ905GDcg/8zKMI9h1JKK/hYY+j7Q5LUFB4GPAKQE7PI6t41cdJI/4ZPzKAT
 ZlkzKLJh+3cD2+zAsmZKdIUL2gsUKhtL+BPAcJ1Cfh5v6cLvet2RpfIYTMT7eOQ27nTbLHuSpHJ
 L7jh0zEgOCAtbniIxZQ==
X-Authority-Analysis: v=2.4 cv=O5c0fR9W c=1 sm=1 tr=0 ts=698cc8b6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=NQ9segQSpgSptwzz7iwA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0C1DE1C0014
X-Stat-Signature: qgzeheapwfihsp8kxa4thxaftj15ijxb
X-Rspam-User: 
X-HE-Tag: 1770834124-353239
X-HE-Meta: U2FsdGVkX19i3NZMwTK5e6edk5JftqEMWOua9F5kp5p0Zoqef6zjgnM+zqKugSIgP/zyJcBrlzx66gh3FlZBv4IwdZk7ZqC6cXUK7mbU180AhSJxrlyOFZBP8qZ2zYrElNh0VWFeS2pv957WY4pekvFtWTkD+TqVkAa8NMqxeyfnBYzMLIDeJ32xiBYUizcrDPySUFxPsCoxmk/+Y2brX2V2lGFwlH2Ozt79W8Kw01t5cH/bukVmaN6ItlTo8jVMMQ28mO/Z7lEeXmtRr4ZnoevDioZjclJn1ZqMq1aVx9FR6npyM94YEIJhnsiv15pe46qql+T/eWjELi100AtBxKoPLDrtIjvhwbA2qSe15T9qm4aB//wo8azTJhrqvr8TSCY0PY9hBGQD0WsmvcUkTYsMua1gy+19h+nAnuqVtFgyKi9J5IRw/j/D8Tzniu0x66cy8K9PibFIO+jP9hwVT1aHdOuPRChO2tr/mrk/CYJoT9kmhYqUm87+7WysSG26H7q45hU65MGTBe2aQBPPXb3l07WkITJe1ctD2aJsODT76xnGU0WeUkB13kkr/gh8kKORam9Nlf88uppFAg+vpvEhgcQeU0yvRIfIwIOhBbcAR32KAMLIs5t1QbbnJygR8Lsqqf+WREElY4T7Mfh0QoQxGjkSykBz6sacBTv4zNptjtQQfrebHH1wfTiS1qfOa1s5LieQY5xhV5hVsSMv34yVxbkDhjndRdN+9DiJeWNCQznD5BqWstY41Sl3RjP7CXqlAEF66pXyML4PZkzfuMmbY+tj4BoFOG895CmR6vH6CXano44mlsgxoDESSWRSbuRvWj9UzqARuw1ZQ7P9xS5TGCkoL8RkcKIc+0vAGF2ikZokHpNhJDFkT9An6bTZZFdV8jw7EM+LexnWGdHeXU9ETxZ1L4ZUrq1cERaFKyKKNkDJ2JAtJb/a57PK/E7vRQTTtL52VOQpegdSjCN
 GqnNLvSl
 VXSxOxCh4UWDYkYY1lLqZjgYuBtLCODQdgSwnqet+7+P91bt9gi5SCVVdwBuZJTR3RZnqwC0N6pefVq6oJ2sqfMsMrBwYbKyDyU+0SFwj7dXArGzykPDPpZWVmv7W8X9jFOn77LshudQ1BjSAs3AdDeZBymwaKSSDelS+TspxuRkssz0Sq+zveorgJ3RJn4GQM6R8uqAUG3DzaiErL5F4rT6jjb9sJE6DYETXRdIE2FrBLLEjoGcUUc1vuAp2uWydfAVBRT3yxaei17q+QctAT8KiLz3X4xjS6sDgmQMFUwJc37mESW7RP4VSG3zpdTdk6x3qbPi8bi+mV26yjIGBcmeRRdGfubSoCIf0gq+6JwcxyMMl6RQ+EmTGyp4Ax4XfaQ8MHiJsDHID99qEcoJRizki44KjZEC19TCXmxjJj/DT63yAAUvQIajcHwYY2vzATbuQZhdsiRKxeJ+WEut/heJsMlSJ4FwQuuihzB9pd9ZnR0zpeXBKmQ+o8uTOASRt8gWEiS2jpQ7iHTdzAkBMYzTcfsWVe+aQwsvcZWOxwfc8LUFySNtQX5uW9lhaAlLo5Po4FDN+YVT004Ohh6Vgmv8eSklJlLnAKU92W5F7pTp9sRx5rdrjGYzCR4uqMuRI3hcrfCr5wo5fQbTZJBtQ4vGxom+4TBmV5BGPeB1+fX2aixXyBoLO9wtREN1b7i1toAxwIPiNbEXesgquhr9o0KAhzm0g80/JrLBbPVx1vZe/R28ToIBAUOiaQpo0Rz+m4NGe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andreas Hindborg <a.hindborg@kernel.org> [260211 02:41]:
> "Liam R. Howlett" <Liam.Howlett@oracle.com> writes:
>=20
> > * Andreas Hindborg <a.hindborg@kernel.org> [260209 14:38]:
> >> Add a convenience method `contains_index` to check whether an element
> >> exists at a given index in the XArray. This method provides a more
> >> ergonomic API compared to calling `get` and checking for `Some`.
> >
> > I think this is going to result in less efficient code for most uses.
> >
> > Most users use the results returned, not just checking if there is or i=
s
> > not a value.  So if you find the value an xarray state and then just
> > throw it away and find it again, it'll be less efficient.
> >
> > If there are users that do use the xarray to just check if something
> > exists or not (which there probably are?), then it should be in a
> > wrapper for that code and not the generic API.  Otherwise we will have
> > users pop up to use this method when they should not.
>=20
> I agree in that I would prefer matching on the result of a lookup and
> using that result. This is not always possible due to a limitation in
> the current implementation of the borrow checker. Please see my response
> to Tamir [1], it has all the pointers.
>=20
> Since we cannot use a match statement in certain situations, we have to
> fall back to something that does not borrow from the collections, like
> `array.get(index).is_some()`. I would argue that
>=20
>   if array.contains_index(foo) { ... }
>=20
> is easier to read than
>=20
>   if array.get(foo).is_some() { ... }
>=20
> And I don't think `array.contains()` is going to have worse codegen than
> `array.get(index).is_some()`.

This is probably my lack of rust knowledge...


My concern is around API usage.  I am concerned people will use xas as a
throw-away lookup with this API and cause more walks of the xarray to
the same location.

In the normal API, we have lookups like this; you take a lock, look
something up, drop the lock and return it.  Since the life cycle of the
stored information is outside the scope of the xarray, the user is
dependent on the entry being stable by some other means after the xarray
lock is dropped.

In the advanced API, we do more within the locked area, usually.

Usually, applications don't just print out there is a value, they do
something with it.  So I would expect a real example to be something
like (this horrible psudo-c/rust mangled mess):

let entry =3D array.get_mut(foo);

if (entry.is_some()) {
        /* do something with entry */
        send_to_party(entry);
} else {
        /* deal with it not existing */
}

What I don't want to do:

if (array.contains_index(foo)) {
        entry =3D array.get_mut(foo);
} else {
        ...
}

Where contains_index(foo) sets up an xas, walks to the location, returns
the entry (or not) and then translates into a boolean.. then if it's
true we set up another xas to walk to the same location.

That is, the worst code gen would come from this:
if (array.get(foo).is_some()) { array.get_mut(foo).. }

From what you said here and the link, you are saying we need to do this
in certain situations due to rust's borrow checker and the lifetime, but
I cannot see why we would need to walk the xarray twice from the example
provided.

And making it easier to do this could result in a lot more users
doubling xarray walks without realising that it's a bad idea (unless
it's this special case).

...
>=20
> [1] https://lore.kernel.org/rust-for-linux/20260209-xarray-entry-send-v3-=
0-f777c65b8ae2@kernel.org/T/#m95fb90870c511491f4f487dbf852c689cd0733f4
>=20

I have trouble following 'the taken arm' in your link.  I think you mean
one of the branches based on the existence of the entry, but I don't
know which is the 'taken' and how 'self' is out of scope.

Other links off the above link seem to indicate it is a problem with the
rust borrow checking hitting a false positive.

It seems we need to look up things twice to work around the false
positive - or implement something like get_or_insert()?

Or, wait for the new checker to be released - but that doesn't fix all
the false positives, just this one?

So, do all users of the xarray suffer from this false positive?

Thanks,
Liam


