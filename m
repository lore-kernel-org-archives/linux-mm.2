Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CDACCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CA0B8E000C; Fri,  7 Nov 2025 07:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A558E0002; Fri,  7 Nov 2025 07:51:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B908E000C; Fri,  7 Nov 2025 07:51:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5AE8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:51:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7CF412CB3D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:51:00 +0000 (UTC)
X-FDA: 84083795880.23.46E747D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6DD414000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:50:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AzZf3UPv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CUNigdDH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762519857; a=rsa-sha256;
	cv=pass;
	b=k2H/oVXv+qkgXK08LS7QOdlmdzvaxMF3weNdf6jyYhVVyFugsCD4MKwCwnylhFZS3MLhGW
	Ufi3Sq/1YZ8GNwEcMdQxtfDjBNX5vgrIhI+ifC8X9wQuwZj786HjPrIwINDYvgTAnAmN2A
	zSF2O/RW/IKPh2P8eohziitLlS7FwRg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AzZf3UPv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CUNigdDH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762519857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOI068TN+SewFKdsd7SaCk3eEUa3ydQ7UrUeUnjy3W8=;
	b=H/wz/IeDp65pNF9Ke2QMhUBxjgXskQz66NnuJkp9lYcbJRQHgTvweqD1Od0twR13r6PER4
	MwJ3AUmjescRiDdpod/J0evAo+WIPwFfPOhKY1jSJr1GmiiLgKDF331ekTj+X1Qjxi74zA
	x5kUh4IIjS49x2ezGyde1sjdXRlrIw4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A78uKlv029557;
	Fri, 7 Nov 2025 12:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kOI068TN+SewFKdsd7
	SaCk3eEUa3ydQ7UrUeUnjy3W8=; b=AzZf3UPvWifjbS/JQoL2vXYODVUvTcjEw3
	upPXQKksGu93w8fTo6fmJVIIMipIw45kUeCgemMBG7oeLHnov4Wm8/N/A9YEk4d4
	55rx/F0TOaBp72w/tZbmGPWYwN1dwP1VpPNobIERsITgH/d2VWAwO5znDg2KxaN3
	S5YJstnWVShqo5VRkv83Y/eQk+ij3HZ/NrSDgtXKE+DzKK9gZC12ZaTnkr7pu591
	QLcYjpFE/OVqptBUK7vpJuxQBRExBxH9LTGL9DPK+vyugdormJsc+ahaUsRSN72L
	X2+qpSoxWhyFFWX5M3Pp3hgE5gDPH1iHIqgq0aiQfcnvYzPZxiiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yhj1ue5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 12:50:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7BaMi9002723;
	Fri, 7 Nov 2025 12:50:49 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012048.outbound.protection.outlook.com [40.93.195.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nhatuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 12:50:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tkj8KrypkjfH+Aq7yi86ygtfYu0tFiqWFtPtNialR8T/rXMRQtDcAv5OEfLm0w86U3Lng72bkkaunIDb07NerevWhqwPHCA4BLCZT3RUILiG9A1M0mCRo7XC+Rl1DN9RZAGikShKJpnvzXEuw2/dfPsNqXXeNrt5+COjr/MmSweax+xjU7kolg26vag1hm8UaWEHeldTjUDQszIJ9Ytmlk2wavm5bZVra/Lslk2wOIN8BxT2gtqinv4TXi7txcrOvGJKu0iG+Iu3RhNfWp1UVRDr9J8wnt4A4Q0kDV2+Vv/H/AfsJcmJNKORUyrVHZdP+NmJ13bj8aeyDxC6Zsm0Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOI068TN+SewFKdsd7SaCk3eEUa3ydQ7UrUeUnjy3W8=;
 b=m4hB2M6b+OxykLiqhfVha9BUTyX/JBHBJudTC0vU2VtgSyljV+V84pI6XIb8dBmAP5W6Ic8NXK+xeuLp4bkks7CGu+CX/e6zEki10kd9PXYeb6Jc+rPPvicMm5dXyJ5+eO7YfHWM39FWA2ya6QOOvrINhxb5SeAz45tYP5ISN+cTO51dapyGCp4SQeMuykX/wxZfouG81dIHNBu/zCFphbMeJnsgZup82EDiSN0f2ONI5AerUJywyg6Hv3UOkKCQ4hd6UTSJaB5oH2RXAFneWkRLrXOSizQY+SD+gH1S87mt3a2LdfyIuDOpg/OgtE94zmOdY1dXzPx4OtR9BE4VVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOI068TN+SewFKdsd7SaCk3eEUa3ydQ7UrUeUnjy3W8=;
 b=CUNigdDHPyAPS5KEdLtLOPovl1wwC9gTUmv+YobtuM8PDXQJtyAxWrZ34saZtds86FrY3U9+IiYs1NGTI0ZlhPSWHrCsnYNOeDXGYeFv9zkY5BwKJ35MjxJ/k+ef4jA+7zy+uLIR1Gg3fwb3J7qVurjxpDXzqhZfqXqGZLSRL4w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7714.namprd10.prod.outlook.com (2603:10b6:610:1ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Fri, 7 Nov
 2025 12:50:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 12:50:45 +0000
Date: Fri, 7 Nov 2025 12:50:43 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        "Garg, Shivank" <shivankg@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        zokeefe@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
Message-ID: <fa0d2df8-70ef-4781-9f26-e9bfbfb498df@lucifer.local>
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
 <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
 <ozkb6mcxuymlz7tm4vcnqf266gd4ruiik2zal2koo5ffprgxfk@35godtyix2cf>
 <43a8c8a6-388b-4c73-9a62-ee57dfb9ba5a@lucifer.local>
 <77a54f63-f5da-42a2-b24d-5c8a0f41d1e6@gmail.com>
 <868d1103-df00-43dd-b04b-21568309445e@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868d1103-df00-43dd-b04b-21568309445e@lucifer.local>
X-ClientProxiedBy: LO4P123CA0354.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7714:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f9f7836-b695-497f-7032-08de1dfc4489
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HLXQYad0dVonxgCFvyJ0WJtYoA+onsCgVTzf01iGAq1wgB8vk1qnk/GmNj0u?=
 =?us-ascii?Q?tVM3L7KBZnmpWyZeRVIIbtSAwIqO5fvwt5/VTVBcU/BvARGYDUmrQ020HeyH?=
 =?us-ascii?Q?N4I4AeORXNR5QNdKkrAYdPpdreMcv4sOG/HAdBeC/lYHiJmnPgQu/Y542nXW?=
 =?us-ascii?Q?y6/kBr+3fKFX3xzMELss8+fgx41C7F2nJ6oxbgU847snltSQk1/htzAz10ZC?=
 =?us-ascii?Q?3qY0RcJNk/OaPXv7PV9LzgD+13km4xwq4mIRv5UhrSrhr/NSLx2gu9ZRkeo6?=
 =?us-ascii?Q?dcNwZuf8vTqUErsQ53KVFiTmKtxeWQMyX8PCwzYFme0/BvPvAtkRx1QwoW1Y?=
 =?us-ascii?Q?jsOALtpPGa5BZwvJjZi66spYWI6qtSvYBpaTS5fFy9bFNIZe+7zHm/qIWiv0?=
 =?us-ascii?Q?hqF7YLX3g65viJCoOWIPdbPbfl/JFv09P4baY8ViG52dqaDm+H3QwE6fcrEX?=
 =?us-ascii?Q?ifFlIv4nJwtHB5mp1uj0JexXMF9YV4ERvFhO/cx5vOq8zRr2+NPo+isKE69y?=
 =?us-ascii?Q?MfR/vp6SI/l11o03jOZIr1CMKe7/lBZSXVKpGMQ26vsFPaIYve6hdaz8Ypkv?=
 =?us-ascii?Q?kOPNVrln/2KDlAwfYY2bzRnPE3E+fpu4WOtoLfXHLMhkhOVYSOQQiuRRUrpY?=
 =?us-ascii?Q?FJUIkUcmQdBH97qBwumXVPfTaIoWMZqho2Hxlzx7pDmXeN4owSuRllHnMwU+?=
 =?us-ascii?Q?TKCXIBCFwQwGA83SNzthvMIhx1nxXV1G3tdcQEL6cnjcwFTH2v1FcfskYwpJ?=
 =?us-ascii?Q?Q0tSxc9A4IBvb0QfNaIc3Ed0GsDKAa1+pAUHVQ+oGLOwS2oWxsX+8mWJrdEw?=
 =?us-ascii?Q?hfvpvyllpXyT5mMC0wy/sWHuOY6v+GM1NyRKCPad212+NwVl2FhPrD+QKC/S?=
 =?us-ascii?Q?blvvzYMK4zZKjCJJvQse9PlG2vFUQnhFoUJJj14KGQfqJRDZm+R0eZlo8ckq?=
 =?us-ascii?Q?2k1qi5t/abshf6+jB5fHy22/SK5+G29HXSEFZ2UUqJ9ckOpKmQNpzw5p8CQp?=
 =?us-ascii?Q?aol3BuvOkfN6+aD590Ft0rC9OyYFed0K4MsXR1fQZ67SKj+se1/nSlzNXgK4?=
 =?us-ascii?Q?v9XWU+F1WVCjaGvoBdWtVgmOO5XPeuUw2GoQq3zu54lNHIuG7vsYr8V+qEa5?=
 =?us-ascii?Q?KoRe3mpTDsmc5GA5ld+et8OUl5nzLd3Njj2q0iZYr2j/2cdGAT2p4ZVXsdP5?=
 =?us-ascii?Q?P9GTD+yqudp8RWEUR9ReeLOHdhDBjIKAgK8eqQtbCDlnjEQH8XXA8Yl3tQpX?=
 =?us-ascii?Q?mFB/VqiPhuMVjkmpIhiw2jvjNg/hPonvFF4GaWzO7GoFqPTLoAJvipQUAUzL?=
 =?us-ascii?Q?v65n2J2XyyWFPc55tcbozrF0m7MCyHWbledgiuztqYF8BMOvYeXAIklNTcsh?=
 =?us-ascii?Q?CGfhaKQS+QXug5khSx4VRkG66wM/UyLPf1fdQMYQBYU53dykX3RDt5ifX/Pf?=
 =?us-ascii?Q?QObYm4NFIs9UimEWRWVNmnIPVYwbFtJh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wGYN2VHg0pWyFmb+b28VCR1ccNDn6Pijb1/IXwUU7GZCqkhd7JWRUJJ46jt4?=
 =?us-ascii?Q?KDq8mHDdhqtSGiVKK1m3Z+PZ8PcKgXuZXz5i3owzm5dTnQzjKFDOxK3PevVg?=
 =?us-ascii?Q?CJlMHal9W00U2GzqNVNe0hILz6daEwSfnNRPmjORadHQFNF1aQApZafZvbqY?=
 =?us-ascii?Q?IqU4bO69RuBAFP3dtZcwIAddLM6+OW4i/eFk03N/hWdMaZwqbUqzE+C18zsD?=
 =?us-ascii?Q?M21VsqgkNkzOVg8FpTm9SNTAyJHIrXV1A54ZCmow7THAqfa8C1Z0UBl2QGnB?=
 =?us-ascii?Q?tQYC7Dnb4Al0pUl0nclDpcPGzDxPM8qH+yin3HmenyrvXDw6nzya/kDAk6bU?=
 =?us-ascii?Q?G4liQ7sRC95DBS92p9uvTs5UM/ORRLrQ1QvzDPEHBYS0IQsmgfajiCgsI8zv?=
 =?us-ascii?Q?DIYXHWa2dkAePA3STJHDujixp7bhr2xpkvciH3gLKwipWn4rrOwReyddSE/5?=
 =?us-ascii?Q?nhuiTb8M5h5zULuODmlFShU5nYJhmEEpwB9aKKMPNEkKfWecSlVFcf0X+sng?=
 =?us-ascii?Q?2tCaKA8AH8p7SxapLIrkXb4pKtVjHbrdOxpi+itRFLjM59qRxS9+unyoFCR0?=
 =?us-ascii?Q?IGBJpkq3aIz0ghmS2PRUrmvJNVZfyh71UKtm2U//nlNynXbMmEd6q1qFBI/c?=
 =?us-ascii?Q?ZH/UGmr44IF34Q11ti22IhvmqwQuM1/tKIiflit9jM/+2PN9ScZiQlPsrL8U?=
 =?us-ascii?Q?UpFT1Dz4Gw9tN11EoNiSsWYhTThAx6R/MvYoi1fnk6yKc3uX9yTXahGWEvEJ?=
 =?us-ascii?Q?g77Vr8bfpmUiFlBHp+I2jgf7dnR0xgsA/z1CCEy/CnhhK4IWrh1abnoyz8B8?=
 =?us-ascii?Q?ono1iCRI56ZqKbnUcEeyA1ECW56UdCtcz3xxgX4c8YlpwatU+ZKwgDN8hw7l?=
 =?us-ascii?Q?PBtxrbNq0COO/EeKdNu0egSD2KSWGUrVmwM9BeZMEiEJjFElhRdyn6Qv4o3O?=
 =?us-ascii?Q?UgwtirkzuZTP4GdZ90r3nkqrIPoRuwjrqOykwMXKwsCseZwP8njhm9EHyTT0?=
 =?us-ascii?Q?cEDkirDmWKEWZH8EUo7eu749UMIxv0UAfqlYv7wTOEQ3wBrLtlGfFgNjOc5B?=
 =?us-ascii?Q?Ke22UtWoWQCl1ffMOKk0Lmhk4uyVUp+HTNSibk7uadLy1JPvqCH/qctIrRwp?=
 =?us-ascii?Q?spKKVJ7YEeMTxvO7MgrOisQOWGOmCB556d2ibWeBtgvd2xUJvRIQueY71S30?=
 =?us-ascii?Q?425/xuMCx1E8Voodod56nXgvajeLor46+H/UoXSPOVQV3w/QU6niHVE7fE47?=
 =?us-ascii?Q?fF2pCKBJLVtoo4nFyJidqou15uW48njQHAdnXR6AlG8tYThu3ubxva5I0cCw?=
 =?us-ascii?Q?rU62Mn26dmVGuopWcSre/XRLOvg4qO96xEj/iuhnJdnjDhXHzPxeGCKgGYYy?=
 =?us-ascii?Q?+xGno7HJtNIY8DimVXR8as5zVume7OAmdu1y47tzyVTGKOLRozqhz946yFPu?=
 =?us-ascii?Q?7xACjF0oiESkOKaJEEKs2AiZpcfIfg6R4v04AlUgnxPfsgH7OFTAfSvyBZjm?=
 =?us-ascii?Q?UxKO6Y4CEWaSTWG3k+Y6M8igVbeLfEUlb46Lf49zvfeiCHvVlgpKeExK+jcm?=
 =?us-ascii?Q?OFTlr9Ecm0HlBll9EvDdEBpCxsjt/sg0FBUtInW/4tf/0HYGyoa1sRF/Durv?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tg3HJn895lAh2J0HplQxE1/3hH2YUT8qnjxTHizp83jNsib2DZTOmRM+DK6fvJx+rp+k7yq6P4yMocDrm5k5a+LM1ZKQ+9Qu1DyQJMQLgPJ2FJ9TlKlFSluy0bbVc5putmOBAwvxCbvJ80sBw6sRUlIPBo43Z4f4tObNPzxnejC92mrFlKps56Bf61xZ/EZaEHHYFm5+NoBSr8LYOTjtbpELuh/Z4AMtunOjZFo7uu9Zib4w4TylhFoXIUDdEmcNf2VBCe/0ZkuxWSN22ZoKd9qUnWuprfvSGsYW7MTKZ17Ku7F1DyszzxaFWPJVZP1YPbISQhvXCktbzsIb8PDp4RXN5YhRmdqCS0d5C/Xn3Wz14hPlTPoW4Lqc89PQPDAZvA8snU7/GZA/x7T/QAcKhJKiynZns4EUI2IWUsvFrIqgJDDseRS+YvXK0kAtZv5n9Nqm+Ckk7bZS0348XNQUac4XTa6oXsLu3H5w4KKWlWvYT++C4dbfUJkqbuowULi02l+Ni0wcXq8Dj7lFewNKHFbJN9SvPX12WDYThf51jsiAQtuFIeKiUw5kqt9uWAG44lB1JsBpTdhRrpBXno7j/JyKRd83gOHjoCptzco6Cdc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9f7836-b695-497f-7032-08de1dfc4489
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 12:50:45.2598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCH3bKLaQu9v+88VFFYl3tKh254emFblhM/NbxuICbA8zW4eeyc2zq5nLvewpIAXJy+gN3HQSkAt+LZC9AUOvSftovIL87pEMqxy2mJgLjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070104
X-Authority-Analysis: v=2.4 cv=BdrVE7t2 c=1 sm=1 tr=0 ts=690deb29 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=K3l1TIwUK4bfC7LTh5kA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13634
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzMyBTYWx0ZWRfX3XQrJ5x0JLsZ
 mVNLSx/otkC3jtP3HIXWJVEPpF0aCA8PeQyZl2avbrejsZrB2/eS4oz81X5YffR6u1p3hZz0jnH
 Z3ZFJmjRxbBRgU5ef5lp/Ykl0Aa9ngsQrlbpEXGCwL6kTuwfoWba3zwuvNSixTowvCrqOUmw3mV
 aqJZZXJDVzDRb1AKk3YMEo0B8/oD4rZd4+2a1cOMUGXWiOgnEvpKu0Nb50aRLrN1z82UEVqAnLI
 tiRI+MNaD05bnOe4npeYacj6zeLFYmCwg22C0OIR+TEzbwhiYCflAL4GQZsVkEOk22iRh7Deo5a
 198n4nt4VtMuJESd3kU9qwHZgftd5wqq8ejHdOqcrNt5+Z72Q4GqAepjdIYi7dBVIY0Y1W1MCZZ
 Y63CHrJr/sjPHv4/1KMDfOONz/6zy5n6m6+dPG+c0ND1pk/SDjM=
X-Proofpoint-ORIG-GUID: VA7L2GJFAFH4PFC9azPS7FdPuXowiQ-b
X-Proofpoint-GUID: VA7L2GJFAFH4PFC9azPS7FdPuXowiQ-b
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6DD414000C
X-Stat-Signature: 1cxtz5qatm131wi6onqk8krt4hxhfzop
X-Rspam-User: 
X-HE-Tag: 1762519857-241415
X-HE-Meta: U2FsdGVkX1/Sr5DpKMMV9hfWUo6WcgjMj+hr7qk4lo8aPoTLqQbuarmzOwnxGU7jnQDz5Ch00eCRp1AeXecN5SoY0LRq0NcVMSWjgND8dwa2GDQWvKdTWX9b5pEOhjDPAAXpzmy0Go2g0JpMY9Hl1x2oehOVTJbcA0M8/ecnaRdO/sJD3pL4KRyRxmSHEylGnVvkdotbYkai2VKctfPmnTkgPdlyuUSUY1M+rSiRnHfQKaiJM1NvHw7ubnE5C39QZlByWNCqh2fQ97BBtjjnVuPVgI3LS42UwWq98crg4VlxmZ1kNswNUmQbdtXD95sqCIJtK86IGdoXnfiQ99NxeTcXlJRT5QtyWsDQCoOnpLBl1qtC98XZ0E18d/L+K8GqX3HDlp4MBrvDAVHmmi7Hdz49tPNFBjVh2vWcqqLH8O/OS495MbufUO3afKV77FDP+T/bly74mEAav8/xl9GAWQ0l4vShMnDQZGhrMObc3o+DEK4bdsW5VvBQbIq+UdNdpcVRzjxObASwhZIdP4Y6+Jmtvqw+obr80FRCFn0FTq+ZYExs9fQ+lNsKDNluoCLBk+H8bxWn4EuKK81rbj7Xqxr8YfH6HFGbjR+qIO22/15VWmx0pFKvRc7T2nYOajqxDpWiwqbx2rpetSFnbROoFRv8UvmqlMlMeap9Xaw36PLGjiwM/ulBBbJLcU93sK6V5HAUo4dgMopmaQ3p/ebZxhyvyHbuZGxs+oYLHqKRb946pz/LmstVtLcWzoY/vKbqEj+iYNnSnDULPqt7HiDCJ2YDAyuHm08YcAksVjzrjMawnTgL/EBJIrqvacQ+ZsFA99Ms1QHSXstx7Cx7OJ6Zvx2wePzyor4+th0tDwL0Sr5cB8W10OXyZUtwK4dFxpIP8jkj2iN89GeiLDgkqRn9PA2uSck5PCoeTbcdnN3GN/jj3VdxCkZ901xiNgooP4aVlr7rsl0qfdZCkqdE/76
 2kT35byc
 lIfNyPuZIKnPUgao+2U1wnPaYGZ+egbUKCs612J57fKazlC2wqU1eI7BSd6zzaMwTR+gUWXPHlfupNgXYsaehrXh4s3c+izRJ0M1CCz9Rzc7Y/WbuRoaE3kyTmGUmlfyI5DpIzKIgNKEbHQemE6LZFxrCr2Xbzjwt5RzO/M3Vunww0GAdypNTosT3nxo686wwwSyBpj/WouCjPe1IkGwGARgFDkxww1MyRdnj5a4WUapJ+Olf6XWeFglhk5zFd1ILDbK15behERzB7izvsIDovusXa6PG0e65wEwvlLgOsEF1VOHnEr88VBa9EyiE1JuEa2OiYYwRYLcaT7vo9baJ3xBBiSt1xfRoVGKkgnRsLtx/SEOY6+l4yibzIgGlflPLrtXwQ8WcPYxAHpW7RyWbim4jyRGtawP5cA7fPb33KeL+ARiShyALk960z4G/Re0a86VvEVWnfm+obEKa/8XCuOC7irYHt+e1e5LdDELTqB19ZykkIOZdteC1gS4B+TvEC/tCKRz7Pyj1JN1IGPhHhIfl4szDDhFVTjccsJ8OjWdlrxhjjd1A34bv/wXUBM/d5D4tPtYkwaVPvbXzHG9p5XSwIr1lgNsjWkXeYEq+h0tofySIEw8n41F+3CPXcrHwHXit699+dJaqz1Jch1MiysKXd4UiMi0lxCxN0/eHVL5lDC0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 10:09:41AM +0000, Lorenzo Stoakes wrote:
> On Thu, Nov 06, 2025 at 10:05:41PM +0100, David Hildenbrand (Red Hat) wrote:
> > 		/*
> > 		 * The lock of new_folio is still held, we will be blocked in
> > 		 * the page fault path, which prevents the pte entries from
> > 		 * being set again. So even though the old empty PTE page may be
> > 		 * concurrently freed and a new PTE page is filled into the pmd
> > 		 * entry, it is still empty and can be removed.
> > 		 *
> > 		 * So here we only need to recheck if the state of pmd entry
> > 		 * still meets our requirements, rather than checking pmd_same()
> > 		 * like elsewhere.
> > 		 */
> > 		if (check_pmd_state(pmd) != SCAN_SUCCEED)
> > 			goto drop_pml;
> > 		ptl = pte_lockptr(mm, pmd);
> > 		if (ptl != pml)
> > 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
> >
> > 		/*
> > 		 * Huge page lock is still held, so normally the page table
> > 		 * must remain empty; and we have already skipped anon_vma
> > 		 * and userfaultfd_wp() vmas.  But since the mmap_lock is not
> > 		 * held, it is still possible for a racing userfaultfd_ioctl()
> > 		 * to have inserted ptes or markers.  Now that we hold ptlock,
> > 		 * repeating the anon_vma check protects from one category,
> > 		 * and repeating the userfaultfd_wp() check from another.
> > 		 */
> > 		if (likely(!vma->anon_vma && !userfaultfd_wp(vma))) {
> > 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
> > 			pmdp_get_lockless_sync();
> > 			success = true;
> > 		}
> >
> > Given !vma->anon_vma, we cannot have anon folios in there.
> >
> > Given !userfaultfd_wp(vma), we cannot have uffd-wp markers in there.
>
> Right.
>
> >
> > Given that all folios in the range we are collapsing where unmapped, we cannot have
> > them mapped there.
> >
> > So the conclusion is that the page table must be empty and can be removed.
> >
> >
> > Could guard markers be in there?
>
> Right now guard markers only exist if vma->anon_vma is set, including the
> file-backed case.
>
> But for file-backed guard regions after my VMA sticky series this won't be the
> case any more :)
>
> So I had better go change that...
>
> I hate that we have open-coded stuff all over the place that makes assumptions
> like this.
>
> This also ignores any other marker types. How I hate the uffd wp implementation.

OK I audited all vma->anon_vma uses and _this_ is literally the only place that
is affected :)

Thanks for mentioning :P have written a self test to repro and fix will land in
v3 of the sticky VMA series.

Cheers, Lorenzo

