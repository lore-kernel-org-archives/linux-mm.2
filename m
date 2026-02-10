Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7531EB26F3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 17:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188446B008A; Tue, 10 Feb 2026 12:52:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1602F6B008C; Tue, 10 Feb 2026 12:52:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0002A6B0092; Tue, 10 Feb 2026 12:52:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0BB16B008A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:52:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 870A9137F88
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:52:37 +0000 (UTC)
X-FDA: 84429291954.29.3B17855
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9EC7A000B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:52:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VT+Tp5q3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="QccE/fXK";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770745954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBK88/pJcK6y5OOaXalTDRegASjdn3F3jwGLyzwbLnw=;
	b=a995ihPJr6aoeAWrYoVdGKhuyYlbl2hWGiexiWhF/wszP78oBBvFzJpA9OSPE61aQdBvRQ
	tk/h4sce5ysDhzTgwxARXP5MpCP9ehHuRGMFek4g8cQMrho6uB76EgsUFF07xexXmxxso5
	fcMY1flWr2kHl4m9qzEY3VWEmswCKzg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770745954; a=rsa-sha256;
	cv=pass;
	b=Y5+Ai7Mjx1c6M5ff6cN1mJXSA7nEOayYpW5mvXoeAwizRQL/rD4lMIcGR6BMHGI6LyRmC/
	88aDH5fojF7gIm5AtSEwOv4xUgDJGu/gBWHMD8WekBRMcOSIQ4rAEriju54HIsCHJZCSEl
	XZt2Bg8Gq10EjT0wjsgBv9OhWD2qFkY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VT+Tp5q3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="QccE/fXK";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AGjweN3810310;
	Tue, 10 Feb 2026 17:52:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eBK88/pJcK6y5OOaXa
	lTDRegASjdn3F3jwGLyzwbLnw=; b=VT+Tp5q3N+ToGep8/GvN/oxuxAwykGOerA
	zTyEQ6Bd/vvfwaQRRuFplTBCKsUg8JseeYvtcMTADAPIVNCL51qdmGf1/bZGUus5
	/NPW/mstAk0CaVC8VgT6p+u73x7i+5X6V2s3HCV6Ya5yfa0qzJDPAf8dRY77e7jI
	A9DrRRmDrP4e+89zKStkPG6oKQ9I11tSptaO8/Xrb01FT5MIYK5SNTeCPrinIQxO
	U1E3+aIKwdGx/0SN61eFgJs4arO1ZGTB2sYFS8OJIhYcsM0ImOXrXJAaJyxbzIM2
	zblJz+bNUo2CgzYC67z8vh5wfF80KqcTK3H5etxuIJHKgsu6Vv2Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88fv0441-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 17:52:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61AGHhqh013085;
	Tue, 10 Feb 2026 17:52:12 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c826yb1aq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 17:52:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TfGGlaNCKRsG0lq/chkQ6goVXb7gKRNjdg9QgjYdswyDxnwqBwj3iSRSN27Jhqos/moNM0U/jC6OHpmGC4oCB+RxHA7pUx5+mJIjtIc6VabFxeg0maWyMxBhAVb0TQfgflmcngq57WUCPMuKtipPeuCTTvlZPLEklg0JdHCyjvrs/b4IrholnmcRDJRnTP3ce7v31rUduEbr4oy1EQMFe6R6wjWPOCKVdr0/2cU1RSjrdJ76FQ8+WkpAOefGweQU+EzSl+ToPjgN5ebBG1AN6WXkeNz1E2xFVEbi9+ws1vH7ulA54YzSGzA8u59S8KxKO9WO98qwDFtWdrEWwFOMNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBK88/pJcK6y5OOaXalTDRegASjdn3F3jwGLyzwbLnw=;
 b=ds5lsrD5NDWx3WmY/6dJN8yyu+VstckaKAB1E7ogEcg8J19LSIqaW0ZDNZI3hYVTCIIA8kPAIpJul8j4QohZszUcrw3hxirmjr5T6N3PLlnjrxK7wlvqjNYH3H8EDGWazWEEpm0mFEf3pO61vs2P75B4Y85/lxoNILWEgedXs9lcl2j0kjsxMPO1AwVC37bgnGcDHdLkyKZzSPpmC6fQsK0NSGpK7wjmKdOCvyUH2bAmmdYvk9XPlSutyUgvnFoiAiR82AfF2quqHUbSyzrFKLlFtLl2xEAh7G9vPMwyn+LId9QHfqd6khHpJXvcBZm8iZis1dMMNPBRw2GBkY9RUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBK88/pJcK6y5OOaXalTDRegASjdn3F3jwGLyzwbLnw=;
 b=QccE/fXKyTNpoj8ILV16/OGJPDPQpC7oLv5JigmVwsHRkxr1mT93nQFjICXvg0VJzNIld3w7ZBYue5KzZ4Z4cGqzbiBVb83uA9HjAyC68CzXags3iMg9H11Jp0sUQkE1JOb1f4YdhSLPbMhxfRAung32eEom8BEC7E8x3k84N00=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7307.namprd10.prod.outlook.com (2603:10b6:610:12f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 17:52:07 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 17:52:07 +0000
Date: Tue, 10 Feb 2026 17:52:03 +0000
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
Message-ID: <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0044.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: c3bda800-8eb7-4dee-e287-08de68cd1b7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7fu2wqAYGXzKKC7RTrPLiAZDCH7PbyhnDLBVcPQtUrofEJJG4wkR2KAvILJh?=
 =?us-ascii?Q?EZDs7DAdCz/Y3Z/H+zMcyVSjj7/nceV4Yo/+0u4LbT+BmQu4zzfFg2OVdAPu?=
 =?us-ascii?Q?gcaNq3fjDJBwbpQn/RcxZVbW5mD7XrwCKcrZqIX6B8VnH6EtlOlDZf9HbfIi?=
 =?us-ascii?Q?CvDrzMulm6P3k0kVB/kk8W5MYc3CuaucjenF+Usxg8vXTyTono/ZGyDzQ6dH?=
 =?us-ascii?Q?yrIGqrcZcvLDZUNitZBQDCPRkj2XOp/xXbj/HbtBQsbbYM5A642a89Wkg0ks?=
 =?us-ascii?Q?n09Ow/R+zpdxGfmuoA071+LTJrRKtnDCPxqslXHlpA4LpSyQ7zq93Au8tScM?=
 =?us-ascii?Q?PMq8WlWHPprzO6ywGUkrRqFzQNQKwGfQHXbqVPvdz7jrTulkg1eEYX3QD3UF?=
 =?us-ascii?Q?u9x2ILgjKFRNeo7EEbdU4wbHGLhctHeeM+VIx4fOBidXhplQIeU3d1evbEcX?=
 =?us-ascii?Q?LgmBlZ9CcD/sgsQntgcMH+z5Qt4B4OKSRisXFog5Dd5WwEcqiRD4763+SP+C?=
 =?us-ascii?Q?VNfGt4vt4Q9Nr8JrqHg5sJW6TWnzGSXbJ85dsqqjMTEiS3we7r7vhiqb4cb9?=
 =?us-ascii?Q?c9Wgf+JKMUbKrhhEwwqGE2Rq/7k8TmEFJcUkMVYayXbpzJHwg1pyYYembinr?=
 =?us-ascii?Q?E100/WqVydL+fUxEeBiwG6PiWPR4XE+XBffyei+xZyOP2ClWxkFYJvZMF/sc?=
 =?us-ascii?Q?etp/HYgyAc2QyezJMJDKqc0W4UFClPHfkahUaIxwEVQ7tbj0Vxc2Oq1bMvvp?=
 =?us-ascii?Q?FCh71+rMAsyMHhjKXzq0fMKjWSELmdrp9m7ppBPpEq8Osim559PoTnzlIIpZ?=
 =?us-ascii?Q?zgtbhVWSHbK8SgeWAAi8oePJdfFDY/Vq7zavJqjtxWiMUSrNzlGI77rQ0737?=
 =?us-ascii?Q?CM17pDlEZnFpYGYrT9pqvaMngJFKPIAbDTyWfQ5d48ki+W4CwDpOKqHi2+4/?=
 =?us-ascii?Q?/VFZMSo12a4lUMnvUfsAhcVGkXUDVYLRWrm6JK0JHgEOAQxAuUlWx+c6Fj0P?=
 =?us-ascii?Q?9JMiUFDj7tsEfhOmrdCd1zJ1s2bQoVarF2Vld/SqKzBxc8q1JwSuddMPQXuZ?=
 =?us-ascii?Q?BGPMR74yRLRgkWCIdPxWi3ybQ02yn5b9cZne2hyTPSXCpq//sqT2XzGUkFBi?=
 =?us-ascii?Q?WlPL3FIEY0Zw4v4XMBayaTWsHsQb3MfSbQxBvQ+EmU0SwEVyvsDlSNAwjunI?=
 =?us-ascii?Q?j5ImPQE4jcZ7F7nmy7jWl4CtXSJ4+EoJP3/mE4Sow7ghSkzw+PpEIjmqdyAr?=
 =?us-ascii?Q?p3KRX+++AFnbDIeNUjqu6//o4pvsMErcT9xM/nSQJ7XARyPCLgYDXRAql5oZ?=
 =?us-ascii?Q?B4uVQBRqcvl+oRIp1gRfai1WaFkyAL10AkimwMp6Zy5f03HiZHKuxkk+SrfR?=
 =?us-ascii?Q?dLeYzy9akIKpnLMfYiPmc8SO6JchZgbvud9CLiKWA5nJ9GdOIqJcgKfSUdXg?=
 =?us-ascii?Q?mgRTQSI8YhEJDCLm4JV7Acnqgb4//NYUQb0lW9xiVeMWBIYv2r5hpSai+P0W?=
 =?us-ascii?Q?WtshS5Gg5VPK8xg5Mn9n19QLVpNq8rD5XU24HJUNF/VbtIxxZ6hmF/A30Mbp?=
 =?us-ascii?Q?T9ulqBlqDFAKOLI9i/w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5LFh6AoUxCOsF5VKFk2JcrQoF+K034Q8jpW424GFbmIHV9P2d9qrliEQXBX6?=
 =?us-ascii?Q?I7AIuK3B1/yeVdoKwG7UEO/EhAWws78OPo76fcH6nns53fIlFkM4hcpK89yG?=
 =?us-ascii?Q?qYn6HAubD4C4e9iNORgiH92OcrbE8MjWX6uAF85HCAAL0rbJmE2Wc7v+elFe?=
 =?us-ascii?Q?YF07sU3D8qsfn5k0JjSqzzeu42yyQfa0MEJdPvCvOzjU/kdiET2WZ4/b7sMR?=
 =?us-ascii?Q?ssnVIEvYnO9RhwUiHVGJqL86tYeUazzHwPTXiJJb24mtdB4FR2wNweJSlc5e?=
 =?us-ascii?Q?3eAF4+5cwDkI0kzSr31RJyyWUFujvnC4X7zQg2wChmX+ePqL08QyIifhFgvr?=
 =?us-ascii?Q?IVdXbWfosy60e40vYoSaqrtBVRjK8HWUcIJ113s9ekIJvUVefwyo3XZpWfYw?=
 =?us-ascii?Q?fKg+QQIqayKTSAqT++GvLG2/9e6GTFBMSVwnYOIHENGKxggJNJ+oUMW9g6Kq?=
 =?us-ascii?Q?fUWaove4ycQkcAszlFy1EbWo5dgFqIywQQDbF5xNk+rnU0f/B5xUDacxPjmh?=
 =?us-ascii?Q?7hl8sJJyL/GW9OizBIjerp23yGOgJci3O40DAwlgnKlXRAQBr6N7wwFnTNau?=
 =?us-ascii?Q?TINE5B2fGYApxVyFcwQ2/mIJ9adknXicIdhNamcobh3JLojnoIAb7JUgDSdo?=
 =?us-ascii?Q?PdF9tXdJzozFWPKssDPuZgWfewMjWa3yKVvBpXU/M8I5PSaED/F2nIuhkQ2A?=
 =?us-ascii?Q?qmZ0RfrlivWve5KIbbxnv01+uHlhBHD71v/Wk97f/aBp++6an8KQukOO/GwS?=
 =?us-ascii?Q?ogfg0myL8rUmhzE+ECTDZIQrVhunV1inoU0taneeHonPBwt/HNvnYTGD1ODP?=
 =?us-ascii?Q?4Ay9ZJ9MovbnPwtQGi3z/NY7uIRnrjDhPnSXkp995XUXyw4RG830wiIUVG9z?=
 =?us-ascii?Q?a5cLIZ38SBXKJMW6dNra/7GVrv3tpy1lHrvvkb2Xr5vrfcBuKfEvE/E2JFW0?=
 =?us-ascii?Q?C5QlNTOiZQX25tdinEiGMVFf41QfjXH/U0DQSb+ouAd8hfDwQkxigA0e94vT?=
 =?us-ascii?Q?j+tfFH6hYuaYFKhZgBM7q6hfu/uFKgw0xywCiGQCKZd9G8nMnnOqu0z1hrmt?=
 =?us-ascii?Q?doi2+iQVUZfP+0UkpklZsycSuPEgP3RqczBpTAV8mJ6h4U3yhrRVma2BXbAO?=
 =?us-ascii?Q?OXPyrZHUUjGWiuJW/iXC+iPjr+Bm7e+Kp9pXsrUflY7kY9AnCwt58ayBoD3t?=
 =?us-ascii?Q?zvwBv8KntL+WOAXpeeSH/QjiYyyig3zkjVI5KX6adJd6g85EHm0JHriv5Ukb?=
 =?us-ascii?Q?6Z1sMeAEzKbkU+3eHTWfbJpIugiC4UZWEJcKoxRP/V4iqFKnOHWhFY7B1sOe?=
 =?us-ascii?Q?4NGaUBuwxd1Dw6G8ubTHnd36wqe3HAzKp2chJKCExWJ2vsAp4UHeL9u9FCQB?=
 =?us-ascii?Q?qWgKIsa2Iryy+ydHlFqaaSEsUUNIt8mQADlurE2vteNoEAcZnLb3Ytukoxpb?=
 =?us-ascii?Q?YCIpR77Lt4YbgBVUm/RXGArCjMdHtK8+JcZb0qZJDqHbCksrOJ4vZSvFmt6N?=
 =?us-ascii?Q?SSqJmSOPfr+BUGMCeWBpbz5oIwWpzXLRiNdK9+c6vLxrZSJQrZZL1tv699WM?=
 =?us-ascii?Q?n25Rdc4wV61xJzfBqyp/R/9u7ovk/tGn6xftweKmJN6I4OWwt1zbF+vtXPhv?=
 =?us-ascii?Q?c8ETFziajXkOpURM4JChSevpwYYHDLjT/Usrt2E+/FIP9LQoNne0pXWbrjtr?=
 =?us-ascii?Q?5l2WUAu92SncX03TvFZwCFx0dqmbt6GwkWep9hWCtHXkS73MvG0Ddwj05CRk?=
 =?us-ascii?Q?pmnekP6vgw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ksLBGc2L6Lje9TvVnaz9/nMdrTRqIoyLWQJZvmyuGWFAhUcpmOJVP4I9jjH8GBvA45q0wnYVPKFIZ5Xrjfq2yFznbGjkei/fxhlUI64Ge0rLivDOdgRzCcCnXI+8WcFauzKF1fEpGL5oZ5bwFofyekJwyOThRSDbh7m8Txhajy2TWI+uIZc1geDpwe5rfC8F1UpSyFps5gYTUfsVIjzF4yAn7kwwTlDd/DiqRpdBVNYjBlgSxc5szV2ZZ4YtfEys387PKbVa+Hox/+wXz2hFCBBo5SqB/n0ukJuVODj/lBh+s0hnTat8g7ymma5jxIJxhlpjF0fpUrpY1jtN8BLx1+zvP39SjMPsdgUjYi+KRigfXj7khpKZFVE5ewf184Anwyn6DWY4MTEiovtNAjFKkjyqw6zClXA42NaBg0sNSSdDR1jIqe7QermsZZLVyVC0LxxauY/MVy6VXoB9d637LOe6lBTAck+4J7RBXw4IpnZM0JogDMSLhqrFYHoc7FUijziXvzL2lX2zRl9+RGZXskP/qaZLQNwQnASAiDLBDIjNxKdr+HhSCMaBsZXRFvKfr7xNYugZwRopEqxyCX+p8q7wcsOVz1wt764bpZuyF1g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3bda800-8eb7-4dee-e287-08de68cd1b7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 17:52:07.2720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLxzZty2FiFmKqCIGU+lrlgy6Cp1gOJZoBtVOh3iZiKK0QQYeI07KeRyyj2kMDVc40CPozGpK9dZ+MgvwGpbAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7307
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_02,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100149
X-Proofpoint-ORIG-GUID: Io_wWHCPcGIhVQmZjwAam7SBjFWg3tdd
X-Authority-Analysis: v=2.4 cv=Qchrf8bv c=1 sm=1 tr=0 ts=698b704e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=c-wpql0DFEiiU-M0XAMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13697
X-Proofpoint-GUID: Io_wWHCPcGIhVQmZjwAam7SBjFWg3tdd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE0OSBTYWx0ZWRfX1Ch3C1rga7uG
 Ve9yCIdZbGwdZdE2EgXaThozlPPkHihPcOMZWfJkLYuncMo2HlKxDvHlHeTSMbr4z50uH0RmZOS
 aC2oR1H70ZLy+b2uzMfieorrnbbooO9+kSyn4CYqMQIfN+ASonJNUIuOGtkbZbw350jfJUD/F4P
 X3SM5XeKiz/oLEHUHgj6KpWKH3/O403LuyWO0P5w1orgtyVkr7j34DeR/9UDcSOoIM8AkJUFpsK
 tKBusewwQMjBRKO+I5m6cXdH0R3i3funriev0PeOdlOKXxvKIwGpPcIGhcxh0U9S6w2Vnue8Uf9
 mESXFJlEAE9UfZMEX+AzpeC9aW1vHSkwerV+6XZVAv/pAZScnP1ejQRZtzpvyjYxNJDCjYZ7P/z
 8tvi1L7cNpWjDPpzYdgGgc656NlLdL/BIOaxjPTaOQUDjkwOZbeUBVaH8TLQsQQ3CRwuFcILCrH
 oOPMrlRTr1dxw2gnZxGz1RaRJzofySbSAMEhjWUw=
X-Rspamd-Queue-Id: E9EC7A000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ksj17x7co9ik6no51dhipgrsadmwgfdk
X-HE-Tag: 1770745953-640302
X-HE-Meta: U2FsdGVkX1+zYQ0bGW80Lt9X2q9rfk+3rQo+MsrVrzNvEV4o3IFmuHO//3XzgDlx0TwDbEENpIvgPdmA/yJvuGheU1WdBHerR1S0ERUzK0asi9xyS6nrOUV415jIEKDRsIZtH6HBf/MHHqeGuZOSHBKk1POuErm7RdJSBodsGMmP0bKzq+cNu2uQ0Qxoa0klbaW8G4qhNGlr4BwwMZ1yDctJjNGAZZ6Cbeq0Ftzi1aVXX+t6RDwqVOwUZXk9IJPM3UpkIzQIPdMbF/jHyHtpzMj45Hn1CAziydUtk3deQbdiyYgPnikhCe7F47+887kdcujSNoTkZUQF3exezhYzeNJ2rZ+1XlLHGzRKAyqjDKrHI3JDnDamSZgMx2Bz9Ub6uJQULbgfq6TtNtHUBnrA15050zdgTBZYJ1Wq5lRUyz8EPEL+yEH6XZaNjY9Jyy5lArTV/gvxFEDkyPDHiuFIBmyHQyAN8aoEFs4p7KUkhpqAyz4kM2mmIQp7mpTc6TQcX9WpaCWl3KMcjt9ze4k4xOKk3ZVyvARBPQNhdMB/DlNesDMP7TsbijTyluPg4CW4lrlIYflYMfLAd27bJ7ck1dEuAO5HOTQ2JY8KrBcY6EMJ4a1U1PlVg34TRsOkxHk2HegC9bK+scayKAFk8DZiXk2cYLyHEpwUS2N9palnEBIU7bNmPpDIFaztz8DvIoeZNqBfszmG04WMVbBfcmwXfLvLuCZxIGb/NfkxF7ta1JEhWE3u2TFhMVAaFSV8AUNNy/0WJkXWxKNMX416UB3ZQEpAq0RAOvGHmRvWygB2hYdkXNl+Om4e/4K5siu7mN+nFL3F8i1MuwLaPHPkVyA4dc1uP0AE2YRtnXADZhQOj8xsl3I2MhlGSzw+f4tDMXm2V/WNyQrJ+h9Tgm0yk0oHB9L7i6pyLrwwlEXzJrs85hwdI6Lul8V7xlnKsgb0T6mOZR+MGm3UFwlNU/y1sgr
 /EV7RGrj
 1x7Dwj71XFJT5lD34PnvIU6S2HMGYODuXDSSkb7yN4hrvXmRCMoPxd4o0GBgfaKzz30CJbTkXkaUg0durs98wlsLOdinRtYZFi+TCQe1H22skhQpZhw59kFW5esjoWpxQPHZAEK8lq9/oRLG2qlIywqBFQvEqsehPcQehnrwbJlox7sFoQSKL8enk3saVlYnlInbEhjvTm6ow6sW2ZhpxXu3i3esvguili8BlrnvWqA1FVrybFTlYcxksv5FghK6o4e2OP/nOx2w1X8zbkmG6On94Y1feKKAf+7blvqKVXXLdgjMPDvFCd0we00Jxn40nZw+p9gWJ4jX4AHaxcYEQE1HIjafDsg/7e2JKi0K7CipwG4OEbWm1Ul9MPsx1fWIDQBj883WvIOUYOuRgJ7MzFOtlvnlUhOj16Z/6Bik5Bz5tkhEzUCKakx7v8iRf9AkUp0C0gVshO8iYACD+rU3xg0427lE19xTaqiMoq2ucbvgW6OMAb3K009FOmvMKEA6LgXRRxpZtVuWbbQYKbb9cCPlI/C7OCNJWluhV0lv0Po1bcBNOW+aDwgqx4+VCRzmPwZYJ5fplf4KOzIMoAou+5hvfZeS0GzqqVEux2Bl2ZfzSUUXGjIBM0ZkbwAA7P4OJU4HskjRBxNx/5SNRduP8vteilw1FmD/6UfqAfGbpj25Y81sffCzqnySIJZXwtnFEjg5TUH651wiCtrhWctgFFAzB2EAnCA+1r/si+gi3vI+BQgzBXQU8F1tlE9SYzvXCi8RVm1eTZDK6Ckk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andreas Hindborg <a.hindborg@kernel.org> [260209 14:38]:
> Add a convenience method `contains_index` to check whether an element
> exists at a given index in the XArray. This method provides a more
> ergonomic API compared to calling `get` and checking for `Some`.

I think this is going to result in less efficient code for most uses.

Most users use the results returned, not just checking if there is or is
not a value.  So if you find the value an xarray state and then just
throw it away and find it again, it'll be less efficient.

If there are users that do use the xarray to just check if something
exists or not (which there probably are?), then it should be in a
wrapper for that code and not the generic API.  Otherwise we will have
users pop up to use this method when they should not.

> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/xarray.rs | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index d9762c6bef19c..ede48b5e1dba3 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -218,6 +218,27 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
>          Some(f(ptr))
>      }
>  
> +    /// Checks if the XArray contains an element at the specified index.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```
> +    /// # use kernel::{alloc::{flags::GFP_KERNEL, kbox::KBox}, xarray::{AllocKind, XArray}};
> +    /// let xa = KBox::pin_init(XArray::new(AllocKind::Alloc), GFP_KERNEL)?;
> +    ///
> +    /// let mut guard = xa.lock();
> +    /// assert_eq!(guard.contains_index(42), false);
> +    ///
> +    /// guard.store(42, KBox::new(0u32, GFP_KERNEL)?, GFP_KERNEL)?;
> +    ///
> +    /// assert_eq!(guard.contains_index(42), true);
> +    ///
> +    /// # Ok::<(), kernel::error::Error>(())
> +    /// ```
> +    pub fn contains_index(&self, index: usize) -> bool {
> +        self.get(index).is_some()
> +    }
> +
>      /// Provides a reference to the element at the given index.
>      pub fn get(&self, index: usize) -> Option<T::Borrowed<'_>> {
>          self.load(index, |ptr| {
> 
> -- 
> 2.51.2
> 
> 

