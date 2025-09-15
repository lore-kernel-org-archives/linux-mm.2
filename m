Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C90CCAC593
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97568E0011; Mon, 15 Sep 2025 07:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F488E0001; Mon, 15 Sep 2025 07:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D468E0011; Mon, 15 Sep 2025 07:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1158E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:28:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 470BA1A0567
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:28:23 +0000 (UTC)
X-FDA: 83891261286.09.F719A0B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id C213B1C000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:28:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YQCJaEYR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ED9jodiV;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757935700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7tQzm97wj6NGUpjlF7vzWWDTtzbRb6MHq69Pmgz6h4=;
	b=JfXzfDytdnZ0edAxToTvYt4XHF5KhwifmFudzOUz/k7y21AsbC14o073zkXJPLvNmHc5Zt
	Z92iVOkUcG/JtQfvRPvI/qYuerlPL4Hq2lg7LFmHP0+e55G7uY8TB5WhGNoBDjSRLIhow4
	sNFwA85d4WtGvK1U7ZSCtNKKtnYseRA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YQCJaEYR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ED9jodiV;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757935700; a=rsa-sha256;
	cv=pass;
	b=IjV1IZDHaA2FZeSDuhHxlEVZG/CdUQ3BSDiIfhdtVNqtifmqE1qY4KkfLpPrMl0xhsd0dG
	tkJ0oNn0TUAvq5EW2LTdpnbVcNScADIQB1N5c01RSXw26IDnzjnTZZLxRCaC6KZu5x0gea
	isbZxEHWThsxsHfGeeC6ka3mT1dvdzc=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAu6Z8025178;
	Mon, 15 Sep 2025 11:28:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=x7tQzm97wj6NGUpjlF
	7vzWWDTtzbRb6MHq69Pmgz6h4=; b=YQCJaEYRmz9LLv6p5NOimCFG7dRoyoIvZD
	ClefH0f6XRG7XGrxmsESwKp+E5CkJnM6VZAqqMOIARlrCF4QzFc7IIc2BA3sMrBa
	XhcCfC4ixavI+vS7GGAqg8udn85kDRQvxv8CXfbV6BYyYIgcVvs/CPWE8/412DQy
	R/rnFCz3p9BOGS6OJkwokk5gIGHTIZqbfFCVLz3Lkr9lN7M0uRC/8DDjxpiMawuP
	F8PL5L2aMVWI1iEYr37F+XyXJLJK7jV7wKRFOJCGhMX1sPTvP1xzg6xDCxDENUKo
	DUyBCbnQcRxKpzO3cpHZP7i1mSIST7Wx79/3ikzlRwIxLJIBlWdQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v24f7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:28:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAeCJK021282;
	Mon, 15 Sep 2025 11:28:14 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2aw0g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:28:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D32gB/ojCh5DUy9FehYjAmSdC+fN9HNIkXYCKtJkw5ftwB2LGV02EAY/42AevdFgJ8FDG/JigEY11p9u7Za0YkZ7J7KlbYEuMTE8fbPaFlo9XUMYVE8VWcBunUpQR/BH0crH5PPTmZHcGVIuJokExDnrKEx/mPrLPKJdfDJ1BW3tnsFriCdG46yy4x3nmYVN97MWV0etOHcEJZrvvOX+3eQWMlsWpBLyU5RJhUdTkEHBwywPuoceShIVPjrXPRgEQx14kjGI4KQrnqDIiCfzy/9BDIPBpD5N2t/Mjj4YCI1/eV8GytF44vTKBwgzaXU+aKzI1E5MdvPU8pyAJjOJyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7tQzm97wj6NGUpjlF7vzWWDTtzbRb6MHq69Pmgz6h4=;
 b=Jom87Vra/wuF4+AkLwSq9TdEWHL6oa7kOZTxi9tSPiNBFxf0UAm8NLc8FJXzv59ZAPo2FHQ5/BXjbihNA6MCLau6GbGJzMhDSm8AA/6yT0WoKquF8rn2sVTQEzxbMkKoqW/hr/1MfCg8zHRxuxm3CZ9ue/wselxEsSL/+Oo72gpFylVBUhMMLS2JB9aZouJds3inkkP9Vs+MfnL7J+r7O9Qs07oOQGuFL3fWvgPDh7GsEKBNumbfPKgjCfXYpBMHMHRme3HtiQQd6l7sRxXbn1EY0Pq+XnSazhz7a3pkb8OiJg1HX8hNz22siW5MQz433gSGMZT+s9DlaTPxx3CxdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7tQzm97wj6NGUpjlF7vzWWDTtzbRb6MHq69Pmgz6h4=;
 b=ED9jodiVd+v4BzmSqjeTwDKqLCSzlagcTtLcBGmfbHquP39cQNs3YhekGP8STzONtSw2XoIDpyFiTjXPsTLuV0bJjLXTeXWtL2enC0A/ip7g5k+kHHdruZb8H/stkPdOWivVs8R2F/bSOzIaRvvyjV/5RR0l+3XSJn5friIyDuI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5106.namprd10.prod.outlook.com (2603:10b6:208:30c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 11:27:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 11:27:46 +0000
Date: Mon, 15 Sep 2025 12:27:43 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com,
        Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>,
        SeongJae Park <sj@kernel.org>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <4e782b1c-ec51-4468-9c6b-002ab7415fb0@lucifer.local>
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <d507dc89-e6b0-4360-bc77-1a8bf74b9134@lucifer.local>
 <3f37af16-abf2-4ed4-9894-0028a9f02f76@redhat.com>
 <CA+EESO5D6CBezDCnN6=7zujzczDZp1t-kajXQCEVsgYTYciT4g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EESO5D6CBezDCnN6=7zujzczDZp1t-kajXQCEVsgYTYciT4g@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5106:EE_
X-MS-Office365-Filtering-Correlation-Id: c99a16ed-bcc8-4eac-6a39-08ddf44ae52a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Glq8hNqWjMaHa+iQILEDt5+bRB9YhSWKpnIW5mjX/4maPnHiKKhRAk5fDleQ?=
 =?us-ascii?Q?zsr2DKcyGQuhgNSE8JXTapq/RMHw7K3tfepk3BETv11wy112pUkYNyKx39B3?=
 =?us-ascii?Q?03+zx9nX/qcfUmaJF1EXvuzXSUxvr9agGZeE7mfZtvLshazl/53Y8ebVO2sw?=
 =?us-ascii?Q?3mPOIE2ov0C01YW34NBJWYce2S3ngYpgMbRFR2SyXMKJTuExAPzMTi6oWzIl?=
 =?us-ascii?Q?jy2u7/3GqyK8ArrSMUKJ8omgWMyfN4R1kXjMl8YOO4F/BRLu/dkWRLlVso6n?=
 =?us-ascii?Q?r845hAxLI9VRgyjyWJeuf0nYhAbYKmgvm5smfxYQ/IG16sLX/4pEK4aXpUVP?=
 =?us-ascii?Q?45qUKczx41RfM1KrW7D8QRuF4OSrnQV1mTlLKverTTCUZ1cYUmqGMzHSGXIe?=
 =?us-ascii?Q?oHMmEL39ZnkNrbI7QIkUBKdp5/LU0lLh5tNmXycO5y5gfeyLGd4tzDTKRWT8?=
 =?us-ascii?Q?Rwz/iXHn4GBB4J4n55+hcUQKEXTUEp/T4qyK1pu2a/TkP/+IL7EW7q3J+Sbr?=
 =?us-ascii?Q?c1ck3qkT0zjLMZYBUOrwKlwCljkX7ZWOxNyaSulQT12ivu2nWa90XnW8Iq6Q?=
 =?us-ascii?Q?s50fsa8fQ3jd1YRKSdbhkLknKi+9G7dnf+qls46D9VBBkyyvjd+movQ+GPYV?=
 =?us-ascii?Q?ueN/Fp+ckuxGoUInxWqG1kpZEs5Sl0arUEZPVV3uhzNepZ5V/6hxzLXomxLL?=
 =?us-ascii?Q?1NmojwsQc81s0PcHOrM0ldrjjzylCEckJ0s8tXqPb6U3HA6e6kyRgzvP3RDA?=
 =?us-ascii?Q?2jlPPoAGFbWQzhTrsKMsSJv0PJldSn5NBL40wcsbQV87avGb/eWcn8kieRBO?=
 =?us-ascii?Q?IFj+kEik5THpzqLcUR76/FCNB3UNWhuri60I9UCtZzs0a62J84Y4pr8ca2k3?=
 =?us-ascii?Q?j+mPwkYsRHA11/OTpvJKMaAOVpr/Mi8CX5j8kl+vBHnPGB99/qMrE6xzIOyK?=
 =?us-ascii?Q?YkJvx0sXWSi4sB0NkIj1TfusbYeQToVHjQzcc8wNgyKzI3JJXaN20g06b4gn?=
 =?us-ascii?Q?MgUqtVH89LlRpVyKYL3C/MhX+g2HrYpRh56lmVKS8CA00WElvCJrNUsRxmCM?=
 =?us-ascii?Q?DF7qp4n0U8aCmKWw0gb45id0hr7wOpF3OBrzuP5554zujl8lKdXVMsYj7bp3?=
 =?us-ascii?Q?QM4T1kogO9VUsiJcqLa3enUsnW92XXsnmUy872tnjCmd1iuyJW4o/IUpmqah?=
 =?us-ascii?Q?ir58fu7oPxOrMxWkxI47Fczr+K/TS49BViLvm31nhQuWGBPYdQG2ApuGkJED?=
 =?us-ascii?Q?AoYo/8yIJphpFyiaZ/7CAuEOiY6zCPACs1drGEZ4xOMNDwx2U7vUT2WA+zO7?=
 =?us-ascii?Q?5Y5D+16KBYC8BhJmGSn9CFiUn2eVL5Yv6Ehl4L6LoLzo7zgd6kba4VMnZi/3?=
 =?us-ascii?Q?ViYIEjLmHb52dmCrZduEkzJO25nR9hPgipF/A48Ju3pot7OGEA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kqSJMMdZNjTWinawkRBcw+Ey8H0gXy7CWxRo1nqXqVKj2N8dT77IOjVfPEhx?=
 =?us-ascii?Q?FmvbhzLHBAH4nQ9Nb9Xfbofd6bAFmfbdymq5sws3n1KIP05I3fLVnYJtZS3c?=
 =?us-ascii?Q?8J4qq36/3H1hRknme0QR87mBdjEURrnop1rPWKYRlxk5uuWHKUa8ektgMLdh?=
 =?us-ascii?Q?R/zalGyypPD2hWZgDsEYAhU2Tp14FsEMByLz8kVi7/GZKwG3HQO1stOB5/S7?=
 =?us-ascii?Q?k+Iic0vQ2cprBv9Lclwe8i3xxt8F6T4tpnxFYa9JAAMVT199Xk9kVCcfCBho?=
 =?us-ascii?Q?v9AMD0J92kCjfO4RtXtIvxRPk071dZZT7IVy9GFYNLSPruwhQQUyCoGlTWV0?=
 =?us-ascii?Q?GfnglL5D0qLyE7wXN0uXu2vqunXNP4ANhxArh8x60TqfD02EVin5gWx6sPit?=
 =?us-ascii?Q?izysobzzbLBElvQ9pnGldq1E3XDICefB5sB4V0cKudmZDCGt2DNXAYf6Qwdz?=
 =?us-ascii?Q?y8LEWZHpea+sDYljV94cdIMJzbsybFyDc1X09TeoLpFBAPuxkTjEKswwhxP/?=
 =?us-ascii?Q?Zc6K/NA/agS01Pmnt0rsGnBOlaRRJYgzGh+93kM6WmWP5fmwpg33EcEwsBdt?=
 =?us-ascii?Q?Mo1AYuoD+2WYV4WnGMucgfamTebxX8SlQ4ndkCOWiBvzLxtosRV/YomdA6QF?=
 =?us-ascii?Q?xPn4AYM2yxGzXLS8t8Xfj4HjVQ8x0bFEr35NPdOwgJCZcvyk1JplL5m4oE7U?=
 =?us-ascii?Q?vq0C3inkXrhD7Ti8Oo3en6Wn5A334z4xdoB+c/nb3c8jOQziOkFLN/ByQqNe?=
 =?us-ascii?Q?QmY5uWCc8Q8W/UBhkmwU2wm7mJQ+C75fKUmcImkigb1dc+NKwB9pvQARZO58?=
 =?us-ascii?Q?E4Wt9mgB68d3fnT5Dd/ZL/d5dcKzQPuno9Gf8GXO2urkLSQ43uDZ+jJNz3B4?=
 =?us-ascii?Q?oLpPmuaNO+WQu/4EyiHKIk2AiqqGj/9OjmsZ3wByMqR1VPfTcyZnScYU4TwM?=
 =?us-ascii?Q?FNtlgQ/BweENZY1DCeYNymdZWp1ZWxOwK/WfGvPqcp7HUpy25P9icG+PK66Y?=
 =?us-ascii?Q?8NagJZTzZ9IexhcTV58vT4clEMGiekXHL2hilDL+2aPXQ29fb/OVsk18+7Hn?=
 =?us-ascii?Q?weePZWlUUy8AVVyVouwazGEYyp4iLtjuHHBnZ1QF++oEtxJXbn6Y01kcrUdp?=
 =?us-ascii?Q?bCdI76XKZyu7idaaVvJ4aFoS/1CUIZSXhNY0koMdBZue4j9A1uq4uL7hDPy/?=
 =?us-ascii?Q?CuEXKt87ZHUGZcpVdFK7ahqrE8PGKxlW/oo/31fsNzaDuhah7zki/BppcgLY?=
 =?us-ascii?Q?QznsfP2JM5Y/lgDoE+JNzb/Ou6JMi/bkvzstbXL8ThqYbzgUwu+SunqF8LL7?=
 =?us-ascii?Q?gHC9f47ZURvNo3ZagF9NvKPP/p0lKnK2eIhCI6ArnXBZn9oeQjpRjSREHmd7?=
 =?us-ascii?Q?/4PR6wis6TAbPlXeifO6B5BVAo5rkHqIMMJJ+DAkVbOqKJHEjrVzMJ8/DgwW?=
 =?us-ascii?Q?UJB5HooLyQCk3nZ6GN2KVFo9oFm0x8pNDNxKkAFUTIywpYn8xVPbiXcEZhvy?=
 =?us-ascii?Q?/aW5evh8PLTLG/judrWL0TB6KaGyBjxa54Fv4jjdJjDag+YiEXkkUkEhVNQB?=
 =?us-ascii?Q?PurWskJItfHpGIw2koOepZz+/qhUJcSqInP/d2qR32rUw3WzJ00iemk5xaWz?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4CzB5ve6OskSpTR0drhN15wRiGGvPof6/+RtKa+0LQgJwVRwltlkYVakejXv2JEy6EgeEsjoCm2jSchgYj4veZbSSYYOj7rkgXFDhqG20Aalqlp+E6rxzhOL7aae8GY/9mRn2GvJFym7UoZ+/1Ku/GharHgiOZQPw8WhDGVwS06a1u8JEm5h0ewhD3nT0jENHGugDv+cvIPzcU4R1x47KBz4E8LJtemHPMcdADokcetpO+fOJefCx1elsncf5/sWaNgYNxa8EDljfYZcVldgqoIchZMaH5XtC+n5sv3QC+Vf5JgYHSxeyNSUangWDhBiGOnC6t7bJpl+wj1PnT+TxCI3RN71BuHQN2+L3Pta5FbY1TfDNV5jV/nCDHSwd8FwN00tbvTDe25v4/hmOxzHPTqvXiI26ar5gnKZr6Zrn6jnx/IW9QPGtPB7/7Yb0sgMLWVZ1smGQlW/warsWFlFerBu7S+riKv6tr1pYGrfGCIAaPF5wP+5oG6L8QYYq8FpcnAS4Z+ZYS4lsCbLBOCuoDw729YmWAGHGiQCF279jiJMnolz11W0Q6QOrYrc8EnEpERJbEJ8lhGAyp2yZa+DafILk16X7KUd4DOLEaJa2ok=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99a16ed-bcc8-4eac-6a39-08ddf44ae52a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 11:27:46.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J1+AN7ycxwJyKIfEb2d6wjbmGOxSZzeUd8KpoiJVjVs+a7OZE2NByEkJh7D3ahs9WhArh6Uk9tWrC3nr81ZauUkbdQVyei0LeoxpS9dWBRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5106
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=708 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150108
X-Proofpoint-GUID: JKAvrAmeibrLVZOQokCSDLVvMgNFgnTi
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c7f84f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=nRMzZrba6OD0NPjrb8cA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX/3DNvrFnYR/C
 dO2H2loHGYlzi1ccHQiXxAe2wIuQNKhmXni/0zknh65LFPVrsI39ZjRXMU069H+3z2cH18NLzyw
 qGgTqcoxUaE6onqW5HLbStHx/ugDcepQ3vL7uVmyFRSpAYTZrMeiu5hhBLhWhxXDJjgtaFHKlVj
 LCR47qMj+Ph0BUbnCOk+LXuV7IdaFINkKYylBW/Qnghj0af6RUoSVTTw2/HTRCCx/YPiyyIi7Ep
 nAsN8DfumBY6Yx+bAh26dacg5PCr0Z5O2xoZbQPU9tMGkbHFDAMXZkfY4LTxbTMCu1ch9soLoPA
 k6BtZB4PqNT2+F6jFfLAHQDfmR+1x0F0EOvKvxC+JplPAdPr8EAFqrOBs0TNuGTfoVdEMC+kJGi
 T2mgF7Xd
X-Proofpoint-ORIG-GUID: JKAvrAmeibrLVZOQokCSDLVvMgNFgnTi
X-Stat-Signature: ta3n3g9bdp6ftzg5rssbn4t9rczdwib9
X-Rspam-User: 
X-Rspamd-Queue-Id: C213B1C000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1757935699-774635
X-HE-Meta: U2FsdGVkX1+FNjTiM7wYr9BAVV5okNGr48hJor/WO2pwDOtxHoQaLTTPxl7MNCJfpPiO62hGRwymPVI7CimtXRHJWOAP9b6wbGLzE1xjue6FLACe2H1GWVZRcdL04d0nuiTkY4I2O6tz8aDWBcH8SV8oQ8MzVoPUk7r1V25c9b9wdCjKUp+9sytSTZpsdZLGkjOZGZd4z/bM7aAHeZcoYE5r10/GmIaE7kwtlp5yCBErLTiFrooqizMoU17pF2UDZ3dtVYEVqSISBOfuSrBKqiw+zaDUuY5C9ScTyfuE9XDRp1CYaEk2wYT8bAK3nMqs+c/FZcxRKOfNf4g5xcT6g5Y8YyHKnSSPolBsUObQV5ASVS6PYBy3C/DY+EAY86SeGBWalwtSHvG/EKDWzhMEg0HgNwNY9mNR5KHtXu6nYi41BdReRHnByXRwC7ZrbHO0hwj6O8VpT7Zdk/JdlHw3rVXdbQu8dSLeL6zhKbhz+zNiICuO4x6RioMbNKKwQjFB+j2fymb/YkEC/Uuw3B/zph46Yvx033E0wG3LEw1ehyqMiGxftITeoEgfkFxcNvq7+/e84SfCxuP6UrYQfVkeFNmNMq0VvO12sPkM1TxMDiG4XZubQbNS8Xx90X4e66KD3ITkdugERhZYGYrfRH4rmK2Uy3CSr08671qJ6mthT6bhxHTrHdEWvmLnzwPJK9pgqCEwYLdO9huit02mlMewrFuU8QpkwKU9NtPcLrVTIBMn1aoW6Vh94feGSLH53JxGT20q17LB1kqzx3kZkbq3rWDMFPjWHujIB7gWIM3CbGsHVc/Jkb2tubH+sUsm968IEl+JQbtFi+MKycie/687wvWuIIAIYertUaBXWmCkvHjFBKhbJIQLotq7BSatgUCLII6rd13biLxJzgL5xkT7iPMr/2Ao7rzXV/vF1upJWRIJikljvMnL0bdpMME7dbkNLavGwkEiBri8jsTNHaf
 EA/nUM06
 o8VdOVFvEgT9XTjMi/92JhJnkAMWtLVIsTCouw360DXjwA2eNXs+xId8ghc9xhZ4qBFOXrWZYfxuLuLscjH0JzzRHFRlzcB3AASXkBao58h38+Ev8MtgBatn/aji+UfK9ZEoNVcmcMXY98lxBQ7ulAc0/y4hAhXSP3+w3sPPlF0fcdddt7Uow6K2KSUaTFsPt8DaTYl+pBPer4EZEbXheF3I0vXdCiQMkWFWaxawNQMiTc66y3eJHF5xaaLYCJIHqw49/CsUXJkk4BLa+RPu7w39FdmnvgWnhpvskwJSras1x1YeqS7C95C9l5rFVkkHT3MUKQO/e6Gyo99UojPPwsLv2ZRtktyADqqOkshKDVOH/YSp6BinKsvQUkg73UhrqZQ3hSQSi3LJL8P/8suh7Xs/rLyoD7t/YrlPGrzgIxZW21R1yQ+bJwo+2ANaHMY2P3exeUKQkh3Pob2Ey5aiSUn378bTZKPsa7Gciz+xN/0C6h+nTNPgXsqemACajRCZS7vieS4UfxkYeT2gij67/bIRd4BuEEwJ83giI/v2vX1WipkCOhycQC0MDQv1iJSfolSmyLvhVZIFF1ryiKnHGdYGKyFVKAKLLhJxDMXqsu15TB0eCo7LN/qMlXPpcfhmPRRodFatPf/H0PWFobSbhYGXVzXVhwCWgvoBSzUT7o69RO2pNWSNB4fXz/sWsgoJ8bFAU+42Z2tNuTD6lALf0a+T6RCo55JS0esnW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 09:27:03PM -0700, Lokesh Gidra wrote:
> Thank you both for the valuable feedback. I'll upload next version
> within few days addressing all the comments.

Thanks! :)

Cheers, Lorenzo

