Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F75E9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8DE6B008C; Mon,  2 Mar 2026 05:58:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48CAB6B0092; Mon,  2 Mar 2026 05:58:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3412D6B0093; Mon,  2 Mar 2026 05:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 231206B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:58:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1EB31A0A0A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:58:05 +0000 (UTC)
X-FDA: 84500823330.23.9024C11
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8B63B20006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:58:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aqEWMzXE;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oF+YF9Yt;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772449082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmsQomB4I/zlf2gsyTPj11Yfkx4qJaO4aP/0JDYxUsg=;
	b=YoXvQSoEIPEAtr1XgO+0m4KfSKyYbLYgwEBBJFoHstf5d6/jxx2P+i61QIRwS9I7RbIlyf
	e9sEbwIhuVQ3gSITOKoFwzfC1a+cvdo3Hu9GC2P6ucDZ44GTOXY1SbJ0O4wBdY9Qy7Cefc
	5QVjSnhOY72MFf3Mk3beCurjXJO5NTU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772449082; a=rsa-sha256;
	cv=fail;
	b=HhR/txalm5lTIu6qn+mxLmSe7bj3BhRc5TOT4o3YUmOfBYHxGtjNW/QQZRqv9wFMvwmU+D
	JEnQ2u6UZxke9KSwA2pFSwOW7bleMNvEWy7WZGo9O6tjLm26d6uAz5kWlAd10ggCapNcH4
	v+ZU+z9aqnLr5EYDQI5njE8B0z76h2Y=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aqEWMzXE;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oF+YF9Yt;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622AriG41737958;
	Mon, 2 Mar 2026 10:57:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BmsQomB4I/zlf2gsyTPj11Yfkx4qJaO4aP/0JDYxUsg=; b=
	aqEWMzXE+5rt7RyubGaeaSRsUeq/dx3hUXD2tM2MSWVdeduYUuoNVE8Tj2vq3fJp
	GtMetQfOoEy+F3wzRNYEMR+oQvHRcFYl+nIKOI1+k/G7dLf5Bq+vx5uejV7GYNLt
	gvpMuWzMNdBcSBG/bt3t0OeVbL1jQdEqOE9BqTByB+HafQC7KvDnb9hpvwvPCR6s
	4L98PjMOzTuNreNRJT0j8bsho5OIrmy6eXRHZguTA0yuk8iCDkFvLk3bG2SJHfSd
	dlOw64k/BA49f+a2Y1SwoMA/2vr0Hqq/+dbGAFSyuzBZ8INV3PHUYivY1GooRoIX
	q/OcWMnSmUx00eO74/s4cQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn96rr07j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:57:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622A9BX1021503;
	Mon, 2 Mar 2026 10:57:54 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8h70e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:57:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=malAIIq5vO1+3HOQUmUFMl5nqN878E45ZCz2T5/F3po36Rqc0jnYNT3WceX1Uzp0jSIEAAO9vRJrE318GnzpGjkQWeLanPK6IBEIVOwG3l4Yi4gomWcbwbtjAFVvUtR1iTdSlAA/Bg8//8gw1auXuEXJ0VLRv5d+Vhd+6DWzRG7Yx1T16ObQeoK+LYVdGQ7k2gtCrr5iT9UiT804J3yaQ2+E8w8T4egMZ7nlkjjabpiJHOtoliGAKlRuyDiZhhjjwNU2EnhBq3ESwhf+WQVtjYNhiB26ww/JnInA0O2/x/t/ndawWYdlEWZJ2Ak+MOt0jkFBZvTrganOyBq6ZKTTyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2s3PvGJbTC62+N2vd6z489cIXoOvvGTTfOtpGEU9LlA=;
 b=Sm/+YmxptfKAsTrtqRsVBa8LPUEhst+IWp24PiO54oglBGT8/tWDIdnx4KgwoLJI5xrBIFIC4Ma4SRLvK1MQbo83yv4yaSX+7a5SlO5fZCPcO3ksRaf4m5EQCDRT4exLe0LYeBOg+lE+lbcEFaOKoxcF+DIPcCjXcUhixkoWy6wnbwlDW83snEj1x5n4B98rwPaxeQhXBBrmcQgPEuOoxNCJqo4ESRuQmYccnGEXFpI9DV1oDi+R/j9sY4UYo+5xdk0vHqHcnoU0tyG0HypHWXhT6WBJhNaE7e2V5A70aYrULlkdKKNR7dlasuWHirtnbBxsC4ygjPn7TSFwm24n5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2s3PvGJbTC62+N2vd6z489cIXoOvvGTTfOtpGEU9LlA=;
 b=oF+YF9YtLkbASaQWfwK4TF27YCCkx21UoBR82XylSb7n1dbc0oV57Hki91vEGDRx9VSerp0GZtTr6okEvTohWz71rGZC8FJMLflUHAFHswKScQHQ0hqQciEUoyY8TUr4A5Vx/CaY7Lk9ixzK18vvAIn1+MTQuvn3Rz0pyG25pmk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN6PR10MB7468.namprd10.prod.outlook.com (2603:10b6:208:47b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 10:57:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 10:57:51 +0000
Date: Mon, 2 Mar 2026 10:57:47 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Zi Yan <ziy@nvidia.com>,
        Gavin Guo <gavinguo@igalia.com>
Subject: Re: VM_BUG_ON_VMA in split_huge_pmd_locked: huge PMD doesn't cover
 full VMA range
Message-ID: <9e273ce7-8471-495c-a344-d9bf61cb808c@lucifer.local>
References: <aZ78kFBEA2SjgT93@laps>
 <24cbde8e-53b1-48bb-b44d-2b4bdc674d55@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24cbde8e-53b1-48bb-b44d-2b4bdc674d55@kernel.org>
X-ClientProxiedBy: AS9PR05CA0190.eurprd05.prod.outlook.com
 (2603:10a6:20b:495::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN6PR10MB7468:EE_
X-MS-Office365-Filtering-Correlation-Id: ba1ae40a-0cfb-4134-f796-08de784a8c2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	eQYPk0Nm6waf2eJWHpQGDsDMmNFtDSCCbtA8757jO6rVeHJ9Qp19Yr2S9t8oZgzQaXulHxmJwDxJ7MY6ZUfygVb+Z5JxxsqqM2OiAAbBmiPJZhcperzyp75dU5ApV9M+91aAeRnZHSXEC9CNWYqa6UoNmpUfE652HJ7JzFICIH1woq9AkNP2yakSPzuFQT3424qimRwww19W3Q5ciYetTQ8dcRm0aI4Z5qTk5Dp1XY/K0UC7uPtIWJ84nMeclN9ARfYt1yTYDzVlpeAkVKKYd3jf5UPJILcw+hBXx04EtfgNqvcsywSzSpzFlLR8+Poas6KoHJX+hJES89ro2EqHC+sePp0dOVQpQhkCo79EzgY5yg06b2In0eAOKKsQDSvtl2onwiLgQV2npaKlz5BGRmU/ASPBcsN3RJwvw0iKknw+rqojtbpwxuM/WeQoKJkE9RizrFSC02ZffnSkb3jmcjdgl43MCl5r8qZXdQQbfEqhrhYgDYxY8bzPqS+oFUHbcCW7KKA2x2rrQzeGN9ll9m4cE1RF6/Eys9tJTxxPeguLNrOqW3n/6TSwUbLY3vf0EqEshwa+2xmd30fWIP18ZCQGDTR3cWt2lh4Opc1AGZQhzXn0oPzdVvKC8aT9MuutFEpc6a6JXub+NWAUJTh6NypJudeiX6uOsEvzBWgAbEjMlFwILvxaLraoR5vtwZdGy5rc/ua2Jv3jSUmFFOZmBCZM4q1OrTMIkmX8hUIFtMI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?F5V8F+BEP9+0Nf+nE2nlUKFYC9d/ti1V30ZxyWk6m37ZeMxeV333sgUu+0?=
 =?iso-8859-1?Q?a9Z9Foy/MzmshSL9scHTPWMrE4nxa2KszAYEzpELA2OusYGtmjC9yJv594?=
 =?iso-8859-1?Q?plydN/cUf0pHg+3AySMsJEM0nuK/exAbRjwiEJfBYVfpnnPXofGJ65WFy/?=
 =?iso-8859-1?Q?14MVFwrEacDcbECpGFe09ZA663V8d8jP+zrauiJts6pd9wqPoBfG4GNKa1?=
 =?iso-8859-1?Q?Bj2cI0CIGqJ0sOY1tOMxnob6ipPyn2HMTQq05z45dzHqlPr/ep2/UmHWPU?=
 =?iso-8859-1?Q?RVhPp1I3MHKvGzugN1T4qVFv64GfDcoMldTcnNX8Cuz0wB3x+wFVBO25c+?=
 =?iso-8859-1?Q?x4jWkiWEURJghzDor0M/DPzV6bD5h+j5l4hmKQRe/Us2LWqAXs7wcPQvwu?=
 =?iso-8859-1?Q?HD6UCqwy1gsKdMuTYGEFLwrZYc7eoEtfnN0bWjaZT3JNMwi440Ii/i0pkf?=
 =?iso-8859-1?Q?EnYKzYje8IB2/vhexiJsznBEIOf87uGLmw89TV+tq1iOjF0E3BW4SNrB6y?=
 =?iso-8859-1?Q?2RqRm8fxRfmlmER8hxcB6pD0bWdCapCoghTO5IOsg5OjwozMI/CqkuwFgB?=
 =?iso-8859-1?Q?fKvitZt+HqhRZwvVmBKk7fsi/3dDbE53HD6qlrZDbqzXH+2sF4VZ/3OiLE?=
 =?iso-8859-1?Q?y0p5XDVTuudbdZDrrp8xJYCAspOpOOsfJZQ7iaZaA3lYAyefKQDNVrPrBt?=
 =?iso-8859-1?Q?io2y9WAntC28PGPCBy345gaZ89VyEyYmA0DrZ8Rmo61PQwPyPeK3F1raFC?=
 =?iso-8859-1?Q?/XXJXu3BD6HofTzV498JDtVNE+sLXFst+hNo6k3quv56rKsAW18qzjhXt1?=
 =?iso-8859-1?Q?4X2R0QgRfZimbPcXf2i9YAipN8kpv2SsGF8hv8oKABySd7fWu0mKF5QJa8?=
 =?iso-8859-1?Q?FTTUWQJR6wl5ZPmMGcwo7dU2Xitub/PNzD17VEwkL2RjzYfkxpivIEe1NM?=
 =?iso-8859-1?Q?hJPemPLUSzEoNagjahxGVFB4IPE7PNQJPVraOEoorwqg/GX9LrcGJx79Z+?=
 =?iso-8859-1?Q?oH62AIBx+uiNCEIppwYmfYg3IYXfRDj1Ei3l4Fn1QG/UaIuT4pBUQBdW9u?=
 =?iso-8859-1?Q?0ymCrRJsbhb8TI4DXIVg7HywEAlY09Wv8SkJQTP1bfNIWfsxvlXmDE7YgO?=
 =?iso-8859-1?Q?Na0+wHb6kgdZrWKD1zrnl6WfdlknSSoquMWM87xG+fyo0Bqx5jdNbIvtf7?=
 =?iso-8859-1?Q?OctQll7m+v1J/6Vs3YPuBP09ssYuV9PwJoX4S5wfU+FsIXOLNdg0nNwIX0?=
 =?iso-8859-1?Q?OT5m5H0xlhWDXphqKQEBxR/oZqhgxHxtAW8C6yQZX+djYx0WMsQ4/VO4/E?=
 =?iso-8859-1?Q?Jy37IoxBngqyH+ijYlFB7FDggVkY+m64GKXbS8lbAaO4gZEAjsGFtMMgIM?=
 =?iso-8859-1?Q?FROpe/xkV8kguJlbGvgrZgGxA3riV5bEbSEDD+R9xoNXfhTZkwG5NrGoSg?=
 =?iso-8859-1?Q?c6MR7Gaf/4ncK2fKzShv/3QzlsmRtQOJT1Sav+utRJQ/zc4P0m2cKucT1u?=
 =?iso-8859-1?Q?tGijK/xSu9ObskUNd814JBAQihK5MUBpBdKJwlQbD0QhEem8W2YXbRJpiz?=
 =?iso-8859-1?Q?d60locgj4lvX2DAcKp+2bY3GgTjFGG+iVkQcQn1+PF/FVMZBq/Z1stGaOs?=
 =?iso-8859-1?Q?bgFdHOYPCisrI3Uo8vOI7vwDH1+CyUWoyRJsTelcz4eSPfrx6wmc/iufBc?=
 =?iso-8859-1?Q?JFOm5B4CBssUbogysTFMw0Ujryh9grrSdrds1eY5yVcFTKIdCy9ip+Wsy3?=
 =?iso-8859-1?Q?QWGzehBMlwIPJSmktjH2YrlILQ+ta36HAOYazRsMWmCrlW7G5AUIxqEFla?=
 =?iso-8859-1?Q?XyA5jtKe9dT6Yqi4ybgD+NYHk7KQclQ=3D?=
X-Exchange-RoutingPolicyChecked:
	unovD4HD9hfHW8dBHJK9n2xCfRG44lXzTReHqTzLjwHtZm8l1MsAwTnhYH5WwgvkHnloydeYxWiIeW39ih6vjyOB8FBrxoHcL3w6iaHUm4C7m0/L5WvEQpFCek/yLgm1F57urPKk1r/5mA4QqalV0qbRZtMTsiEcvtquq54fqtpsy33orMzzgKvE0UStlW0NPGXJ4Nu/IK52x/GRh9+6Bc9VIuKCm4uXFeL69gtnO4dhWJkPTOnxpBqFpJOQNvi+p4SilUm10Sx4zZPt+p8YwDO0j3pL6QybnpMeEi+Kj+Cz7naVVU2LBaxrWDHXcjARvxykH2p/MkXYUoJJy2np1g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9q8OMTaLEz+OwzMdZzLKo8aScPk/0yZI4mAZzSjIKZCYGAkGpNGjD9kfc0tyUI35maN5cSkrjOwNouHjnbLyFugeq3l6KhS9byMWQzr06142GEWayEPWuxuyKQpHW2BvWXi2Y9/bNXuJYsEiPDiLYUq2f/FEOTvxdrnav2eKOxMdxDJeXa3V75Iw7/l8tF+N6wt2+XTO35WRy1cYT1t/UOLLrKJf64q6MStQ0s0jvRuYGf9xVGRUBRjDgBlKVyidIGEFgqvQGz3kFXKKkR9USD59yl/McDVSimvdO5b2ZMVUVwgiPSS/hdBdDNm2fQlIF5wFYWt/sydF3ryNeYKL0vkxx30naUlvkiChnLwNF6lHe8QtQvcUd3pYMxLhq75kaWS13+RBz0pAo06rGRbYfBiB1LXZlgCOBY4i9oeQEe1oTgfWci5OOcUXs1Q++l53cK8m9793Nsa+hbLJgbFttx4NFZ29wGe5WbCkKvKvRLxzS044A9VmysaxBxgUAu7CwGN6an2PWOm+gbD0Z6VK4FPJDukcdd3c7ZT3XcoGfIkv4SSIp4kAl3K4blT8rmuD7VhxX2JKYiL+Mu4WA9D40C0ZjXd5z3UcGO9oEn+RUb0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1ae40a-0cfb-4134-f796-08de784a8c2b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 10:57:51.3790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hIob4oxK+hPac6GcJQILsjlhdOmt9TJqzuzjIv7eBDzg5MgAx/mWTdZ6N3FDPrZl+JqRftYsFra79dQgvnIz8pgl0HxrX6Aj4FAYpJuKas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7468
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020090
X-Proofpoint-GUID: pR2QUzBsDunQdATO3zzrJI3yvYYXltwf
X-Proofpoint-ORIG-GUID: pR2QUzBsDunQdATO3zzrJI3yvYYXltwf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4OSBTYWx0ZWRfX3YEWObLmXLpP
 wpfhkzBj2UNOyDoZnj+rtPBMd0dN1ZKst+WKomCVpJVQqkdy9jj1OxGYa2P1j4QhXmYLYYtkZJS
 kX0fcpWqkfnpF//qmdF8wX2WhwW1l81oGD0GWafnAZzSFe8//PeTMl7ffZFe0Ozp+vP3qMBXThU
 LIos/zJOWbCwgc7mPTqTcdncQcXCBBdgTjBnveqwpYu00ZhgSK3dBDMkeBUf2mY8stIhHsTWtwK
 X83auszUZmiig6Op654C7JpXXRG+q8dQHYRwuBm7bV76hWSMz5RWf+MFiVKUjM7ITtTG4OfEYAp
 jzCk6DfWgWDjzMpTJZ9e6EFMTjcIzm+6Abna3ZVeHIepo/Zm63UT4Oy5014NczoJ7TkbxXjvZkm
 7wyFwzqKOEkv8Db2FBdS5KUI3xOFYWKp6F6gQSWvKrU47B0/NYsGY8zFFiUKm955SvNhRSxQeAv
 xnO/OdiuNzyqHfA2Jgw==
X-Authority-Analysis: v=2.4 cv=bbdmkePB c=1 sm=1 tr=0 ts=69a56d33 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=AS7bR-Mh96_MIutKsucA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B63B20006
X-Stat-Signature: zx9peg4zpsy8iru9b7hwha5d6zkmnmr6
X-Rspam-User: 
X-HE-Tag: 1772449082-405251
X-HE-Meta: U2FsdGVkX1/+dMwObyCiuov85+YkliK8DPq+t0TVQTJUEF9D649HYTf1drKjP4zLgs7DS6OlplbD5lrvTJfcaFWtRMyFt0fVkMHWYd7t7RnV6B2ccVAXqFKsxwXewBrS6usNFPa+lTQZVDXUUnfkyD+aYe8MkvOOdnAVIWQZeFGPg5YBQsSNR0b/1LhASsM2xu74AM9YXYnwMcBtdw6Gw8VVUCiQ8+O3KWwpgqpwSu1AUXVCQEHl67E1xu9aZ2/YB8CHS5ueMnjG4SBvbqUvVoyE0STqrldw8iGN1plJbqnqjt3RRuZVnNcS9qpIp16SpgnsfLBGhgVVyRvaeG4jk9Y56jz42SEzZSm7W4M7lOjUkpmWb2OPtWgL2Y2PweIuqApwpsHaSKFTfY91/c7hk/1s5znYwuHrzX55g0GJnoknL+eccNA7CDPltnCF0diuarGP4IX7ppNmbRJns20Xx84fR5tXsx0xKPU20WDjldS+fokQE9fMsZo+qcsa2TTFR6yNKNdOHqmEOcKu+ntU2lG/z3tRPK07l6+GSQVV0S/9PN7tdQGkZbicE6xVqjvoi7Pbs6mjScO0isWIqrEX5XT2CnE3Ib4uje9LYLgtlEM8irB/at5v7Gl9z1+CCNK1ovjxLZVV842Pfq9zqRNxBey90BYOuLmvD0V64E83TbhM063EJQoQsICjJEF50Xtt0t6pGjJWD/KdKRoPSqhm2FcucgzxOAPHSY3unQ4oL9sQM7JPRRLUOtLYuQSYkIeMYw1m6Vq72OyjKVqT0mspkbrvVc3KBXDcUwJJDgtmmic2dWJayS4fxlHgttpHve4RFhYrSdSVIy59yFeokpCHiEZPveabmOeuY5ftFGXjt2CpvXjyqSGQEYHoFNGvYnNB9iJ+V5Nx5uMXJTA3/cMJvvpDEmX8Eq8VxstQDpNJOIfFDOWRatWKlhXrnt/pFzhAuOJRbzqcjoe8U+eKdFc
 gzPPPd9X
 XmXsWsFAdEthruY4I4uc2unvRshD/7Id9F+fdlNjQsQjvztVDbRaY8Y63jww8UtduJ2JQOWErJWI8XD5rw6DMhF7smqvHRAhnK6gSSUs0PwKmobhFdJycgZysjBRYL3XI6t3h6Ibg2m/m/iMdJM8FhWOC11ZV3DmpVAIgIeNoWmVYGMiPCU94wDAiN7WUkmMh3qaulcI/8w3thQ6C2C3cxO7e+WalLwTVoqHIuNYMwZFGoNp+naD3Nlvq1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 02:50:16PM +0100, David Hildenbrand (Arm) wrote:
> On 2/25/26 14:43, Sasha Levin wrote:
> > Hi,
> >
> > I've been playing around with improvements to syzkaller locally, and hit
> > the
> > following crash on v7.0-rc1:
> >
> >   vma ffff888109f988c0 start 0000555580cc0000 end 0000555580ce2000 mm
> > ffff8881048e1780
> >   prot 8000000000000025 anon_vma ffff88810b20f100 vm_ops 0000000000000000
> >   pgoff 555580cc0 file 0000000000000000 private_data 0000000000000000
> >   refcnt 1
> >   flags: 0x100073(read|write|mayread|maywrite|mayexec|account)
> >   ------------[ cut here ]------------
> >   kernel BUG at mm/huge_memory.c:2999!
> >   Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> >   CPU: 3 UID: 0 PID: 15162 Comm: syz.7.3120 Tainted: G
> > N  7.0.0-rc1-00001-gc5447a46efed #51 PREEMPT(full)
> >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-
> > debian-1.17.0-1 04/01/2014
> >   RIP: 0010:split_huge_pmd_locked+0x11a0/0x2f80
> >   RSP: 0018:ffff888053cc7338 EFLAGS: 00010282
> >   RAX: 0000000000000126 RBX: ffff888109f988d0 RCX: 0000000000000000
> >   RDX: 0000000000000126 RSI: 0000000000000000 RDI: ffffed100a798e43
> >   RBP: 0000555580cc0000 R08: ffffffffa3e62775 R09: 0000000000000001
> >   R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000080
> >   R13: 0000000000000000 R14: 0000555580c00000 R15: ffff888109f988c0
> >   FS:  0000000000000000(0000) GS:ffff88816f701000(0000)
> > knlGS:0000000000000000
> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: 00007fe2ac1907a0 CR3: 0000000021c91000 CR4: 0000000000750ef0
> >   PKRU: 80000000
> >   Call Trace:
> >    <TASK>
> >    __split_huge_pmd+0x201/0x350
> >    unmap_page_range+0xa6a/0x3db0
> >    unmap_single_vma+0x14b/0x230
> >    unmap_vmas+0x28f/0x580
> >    exit_mmap+0x203/0xa80
> >    __mmput+0x11b/0x540
> >    mmput+0x81/0xa0
> >    do_exit+0x7b9/0x2c60
> >    do_group_exit+0xd5/0x2a0
> >    get_signal+0x1fdc/0x2340
> >    arch_do_signal_or_restart+0x93/0x790
> >    exit_to_user_mode_loop+0x84/0x480
> >    do_syscall_64+0x4df/0x700
> >    entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >    </TASK>
> >   Kernel panic - not syncing: Fatal exception
> >
> > The assertion VM_BUG_ON_VMA(vma->vm_start > haddr, vma) fires at
> > mm/huge_memory.c:2999 because a huge PMD exists at PMD-aligned address
> > 0x555580c00000 but the VMA only covers [0x555580cc0000, 0x555580ce2000):
> > a 136KB region starting 816KB past the PMD base.
>
> Do you have a reproducer and would this trigger before v7.0-rc1?
>
> Lorenzo did some changes around anon_vma locking recently, maybe related
> to that.

A quick glance doesn't suggest any changes I made should have had an impact
here.

_Should have_ :)

I think without a reproducer this is going to be hard to pinpoint. Hopefully
syzbot proper should figure one out eventually?

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

