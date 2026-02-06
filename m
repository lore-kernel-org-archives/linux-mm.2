Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C553ECD9B5
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 00:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888F66B008A; Thu,  5 Feb 2026 19:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835FE6B0092; Thu,  5 Feb 2026 19:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3AC6B0093; Thu,  5 Feb 2026 19:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2FE6B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 19:54:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B36E1C5FA
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 00:54:06 +0000 (UTC)
X-FDA: 84412210092.12.B95D8C4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id BCE0C180004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 00:54:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BVpNvmVA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bfsag8Ir;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770339243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QOyus5L/MWRlDJHLeL+SztdXyabmvDrYZ/+N+FI7p5c=;
	b=HLOO0XmF5idzmAut+e6NguHlC5SK7TmeveUI4WqnifkVJxUAZQ31hb9CJ1Z8q9TbOcW+62
	7sKkdIfblnQ9ckvUgYir+ZjgtjfrGB+sCdXanoEFPbIjrYHOQ5amZFp6jPN/p2Is4Sm1uU
	VF4psSQSeuW9LXEfe9VkGKXfBvRoavw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BVpNvmVA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bfsag8Ir;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770339243; a=rsa-sha256;
	cv=pass;
	b=xKWNpIkLQdhzKXE0+HcgpAwyg4OmWP0s3+WWVFfC4L4eE406p4R1n0FvbK+JGVInCWM/5w
	PuegCbhEnK+vrYprU6XgnQ7STx0frEYryymhyIloekqhIfhnigz3kzYRk6elCoFAOJBrml
	TzbBNahCfwOfn37hzcwO3JBe5wKdKt0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615Ftwfr482329;
	Fri, 6 Feb 2026 00:53:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QOyus5L/MWRlDJHLeL
	+SztdXyabmvDrYZ/+N+FI7p5c=; b=BVpNvmVAyyejboUPIplMmqUV/KGYmPx0W7
	PcaO3qB5Ss51MpGIX0tXcM15tGShsIg7h/jjcl+OWj/bEmvk7ta9v/qyv4Fa350B
	eKBV1PpiuNnx5/Ipwva7muYOEUdkk42Yik74kTJTJ1wUliMqniGOBNU7inkNxBQz
	iheIw38U/iRD6l8icn7PST6Lzd2o0vq+aqat3wqYa8q+bakFGCF63H30hpxAw/wt
	ROSgZeFbVyl6x/L//NANC3jl2kHaUmHJ7wr64UFkuwjKuFDFz8xO9a7b+1rhFooW
	PKWS0PvwPbvgKLDDiRer9mUlHAkQHTPagPw+MSyNIkVPkkVU+PCg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb4qw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 00:53:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61606ZAo038957;
	Fri, 6 Feb 2026 00:53:58 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012023.outbound.protection.outlook.com [40.93.195.23])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186dxtfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 00:53:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yT0K/NCtA4mDeXFfs4rrzaQXkj/4PAootiiOkU/uDSshw4eBk8iKJDMTx3BFY02LA8bZMBju3sq1KZ2hmcxSzGT9UHmunVNJdQenKwn0kht+sVOD17hovPA5RTDc0RUFn4v3tJOTfcd2H5FfKfxSwvm3pJCmSo7ZqflY4GvEWIpBxnF7CjL+ozQF6BIaU1LRoL3XWakjkonSgdXIS8m6lcoitn4jeVY/0zpHR2BPkJMoQIOeHkcUe7tjw/2jqfcU1cdXVb3XvCLYSXGRz264hQC6wOZ/xySYhlWIxRPx601hXh09iY6oBvj/Ib5Y7qaRMU8HoQhXXxIpKsjWMhn7Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QOyus5L/MWRlDJHLeL+SztdXyabmvDrYZ/+N+FI7p5c=;
 b=eRuuwEEShUkyK9kgXPu8actKCQrI3nZzxs4kiDbRHXgXjeA7e9WkIOsYyPTG/0MCBCJSAtFxbPTDBZbipSpFpvYZYGcxISgZV696D/e+Wqs4EK5+cmEGHa0ri4OPinIbxyljhHbbwzaqkVklR5cqswqepwLAoN4GWlGsKDye9FTbMqidfybz+Qyytp+1P3vrCvQwfJ/xhZg+iPhMPHrHSWrio8qhXdsj3/l3SKCK0+lUJFv4d4sQHTlS/rIYLX+iYVEi96/e/ZtYkeoUyu7p6JeaxI568wKn9eTiOiNHPJEsQGoUBu878PKbKHIYidfWVb5Lgo1JhjETE0LY7Tlcfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOyus5L/MWRlDJHLeL+SztdXyabmvDrYZ/+N+FI7p5c=;
 b=bfsag8IrzEkkNkw+JpnoZSBe7XOpzJXyxRofJ03zc1eJHYDSr5NyHfb2rLgQDhWPEqTZN92UU6pBDK8x5i+512qJPeNxXwg9m4oF0OZwC+YcdeRKUp07Z/GBJk+edISEsD4lLDsiRGWVtehoVco27eCtPeBb+bVs4ijydldVKY8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB7323.namprd10.prod.outlook.com (2603:10b6:8:ec::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.14; Fri, 6 Feb 2026 00:53:56 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 00:53:49 +0000
Date: Fri, 6 Feb 2026 09:53:43 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: let need_slab_obj_exts() return false if
 SLAB_NO_OBJ_EXT is set
Message-ID: <aYU7l6P2ikKvnrWT@hyeyoo>
References: <20260205120709.425719-1-hao.li@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205120709.425719-1-hao.li@linux.dev>
X-ClientProxiedBy: SL2P216CA0118.KORP216.PROD.OUTLOOK.COM (2603:1096:101::15)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b1518d-dbe7-4452-8af0-08de651a309e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UBOOKViVsJCLHTXmgDFm5RdXvWtyEUegHv5nzv/5j8VEiW7jsb8Zzmrw8D26?=
 =?us-ascii?Q?oFCoyt5uRWncvQ19WGuxSC3ZBlOsqJAy/OS9bG5449lqvt1pR+Fl0bvmQicZ?=
 =?us-ascii?Q?l6l3vwalGCJPF2Dcv8MqEEwx3jUcp+R+WVuw/LSl7rG2Me6qynERGcQBn7cL?=
 =?us-ascii?Q?mvOzYzEn4OqDQk5woYdmSY8wT+cthmX5Sxn2H6fnEmfblF1kRDAhvKnkitZw?=
 =?us-ascii?Q?XCaeEa0HtiTGObiYz4TkL1Hlh0UABaTb+027zgxRhWdFYAAaMxXaeLZxAY9a?=
 =?us-ascii?Q?1Wu9dF3nJG4UrD6UcK1g+o8W8p734xlLxijx6I11YEEbDiqweFmfl2gCN5D2?=
 =?us-ascii?Q?BlKtzYTIzqVteN12PgpyGKY8J2YyePvvE9GWPpUAb4hVkMtSO+pmw1n38QaA?=
 =?us-ascii?Q?fWbrubnhG3JmzSUzwOckWr/Tcrfp68cLpTTjHssSJk3Hk57sTJoE7FE1IWAI?=
 =?us-ascii?Q?/9CWTj/0C/KPRiWUcwbtp2SMhQTrQ7tJXnamqs8VAQ738Oed1S8Ag7YQ4nwF?=
 =?us-ascii?Q?+s7eNvJhWxI4ThOl2y1bhTfJcRMcyA92s3U4a3FM+Bvk2wJOha9YeXU2YnIx?=
 =?us-ascii?Q?Q1ZMXQ+YAQWxkWsfNoLVteI4wiGSOBb+xmQL2K29MFPrsajbJmfYavo6moiK?=
 =?us-ascii?Q?nPPjZYOmQrzqIq/akuu8AYastp183fKJbw4dE57+YJQHAl1fam0zSn0vJ+s/?=
 =?us-ascii?Q?ml/MItRoiG8YfoFPtoGd4BO030hAh+qDsq9GbaiW9gV8etWpmuyPPUs8inNy?=
 =?us-ascii?Q?kJFE8hVdgQvtqH7C0rp6KAKYTTPSs+eZQyfyHSeWbm1N6LYTUpe5ChVx4PMc?=
 =?us-ascii?Q?a9LaafSEnINcRVG14J4terhSTwur9GVdwvQi/SMmRDwWtbT81ApNMjYME45J?=
 =?us-ascii?Q?AfWbUCI0pAgfdyEbtREuqWU7hc/CQUKwyAcxK2JCd9s1bmDtDtaIaRYg19xx?=
 =?us-ascii?Q?+eLqABV7cMp/hiUXaKDr9f8WYDhvNFTHaoq0ahjanvZgaU6NFNIcIpCe6EwU?=
 =?us-ascii?Q?onOrnY+W0+BUrqtcPKT5U9G5kWv0lEikvXiV30pMaCP3+LQS0ilJz3owqGKk?=
 =?us-ascii?Q?uLA1hsg21dbl9nVtr8qhSv/BGxOADiDhXxxVFIeSgpcKPMgBfQCJtxPiaoHJ?=
 =?us-ascii?Q?mI1+/eIdDuDsP0LfzL/CScK0PIlDjEa0KTRz8OFeIoQJov3LFEDsSLB6t0l6?=
 =?us-ascii?Q?kOUO4LDjxDtT/4ey952YNCJJlcjd1Cazi4N1sIiNqX7u1Z8dscIvSbOYcvrc?=
 =?us-ascii?Q?g/ceopm7himeYlX+cHEQ9i42sTubfV16/XF9kwzu4DA+QIUKHe8TBxapkY8B?=
 =?us-ascii?Q?BucNzbawewnQde2hgqJDpGcGTwN+k1CLY+9kt4PqmH9ec4ljmRyI68BtIqj4?=
 =?us-ascii?Q?I8+6MlHkuK33RspyQboDQimkGcNcSrq+la3BlArTsZuN/TlyYZ6WMBrfdVTT?=
 =?us-ascii?Q?b32/hiFzFxVuz+aZ95RPC1poBA7/5hMaDybzMGX66XlVYwkB8PlE96Mslelu?=
 =?us-ascii?Q?3oT9m3lkhe0eXQOpZ1ErTk/ut0BebufV8fxOlahi4UMtdHPBDU8ekZJbUKhs?=
 =?us-ascii?Q?4SvD/+IUdy1LGseiEhc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/kVuAVJHW0Enp40ZNgEE+WjmxeUvX5JFg2nfPDyRvTAT5mH5LR8lIgAv/5po?=
 =?us-ascii?Q?ilQVUxKrNhIsHZGuOIxNFJR7olWb+NRMXocnhw+M1kkqtGHaEXxxHTNkHjRD?=
 =?us-ascii?Q?Q+4WGSgGChVnjUEZZzPMfdSLYcutpbKnq/yx+j9mCqn937VrMXxQpj2S6Rrx?=
 =?us-ascii?Q?P+PTnX6Wck//4F1Z8+CxQQ+oPH2zk4sStE5vUZtnLP6LX1njaTA7T3zOLQfx?=
 =?us-ascii?Q?b2PSZcDSXc5bk6myG/FCD1wYoHm1La0uYcajMMJchWNDkbKc+1rEZvfzJyQE?=
 =?us-ascii?Q?vavuLbddIynaIcJKTsr5DDujG3dlUPQpNDSzE5oCv4PwrYB6uKhJ/4KuiKUa?=
 =?us-ascii?Q?qPC363VQpjIsVmFFHy7F5+AcVrDqIAdELYSYVbhJ3PwvQ5DKNsbV3yCK4YiT?=
 =?us-ascii?Q?Qvx8ZIuwN4NO6uAcquukDmv2w0W8FQIFLGL5xyQOVeb6mOi3rTIQjjYYDSg5?=
 =?us-ascii?Q?N8cVSUAX6mhsAMfkE3MzjrjUZ/o3FynrMgTo76ViHKG433jYlbaDZpuB3WrN?=
 =?us-ascii?Q?nHAz3pAVhTtzBkH1ItDIGZg+ts7PtGLwSgquw+FHh0BJDQ4/CIKvD/flXO/i?=
 =?us-ascii?Q?Fz3AWy++3IJGc8zo+Vnrnaf/ZJQieTZeVJglJsdpSepLUbjqzvDVVAlkSTfJ?=
 =?us-ascii?Q?mMQ3QOi+e2FVVWWArcvL85dGAODmc3qGy4pO/EdJ235kLl0GrYz8+2AT/vx6?=
 =?us-ascii?Q?8quW53f1eU8XtV7rIDsB4FGCsUYD/TOfq3uc+qENOsBBAFezy547UQaNo/33?=
 =?us-ascii?Q?ohk8tfp+/I6TFlaYYAPEMOVZX1Uiyc2/reQwySMEjMOsxR5P90NVduD96JIB?=
 =?us-ascii?Q?KmZuDOoU22AtspDAmL8mZCeLFWYvpeN47HOE+1m1zE8WXFh7JGTaV3VC80cR?=
 =?us-ascii?Q?jb0YlGTEzo9NiT2OM8f553g3QGlw2ipCbDqRatR4k6DEJOLJj3YeS81uuyoo?=
 =?us-ascii?Q?+7oZn7Vk96iSMK8mqnaRQlsn/vYZ9q/H2a33frewhtJwy70gGk54/07lDLO8?=
 =?us-ascii?Q?QF1xTEpncH4mN4G5MpEeuZR6Dx2O1jaL4VzRNUgTaHJGCyojPJCQ7ZHDqxIM?=
 =?us-ascii?Q?Sk6IiRBKssL0JT9Z8CqQxoF+8FORbLyysQiiIzbrXz2f9mv54yOLHry6UPxk?=
 =?us-ascii?Q?Huu97WfLD+LQbHhqXnfyZGhUoqGziMmOEyOVThGIfL/6OXqogFH8SAmce2M4?=
 =?us-ascii?Q?D1W0Gm1k0GeHEmNcH87aAXenOPcYq/DnV5MZmEQ77S+weDG2C5Lv5Y0KvqXE?=
 =?us-ascii?Q?rKRnQ9rr/Ph4+joKAdpVflwhIM2FDCQuhq/sBZL7WEw3IWnnYQ1edXgEgIL0?=
 =?us-ascii?Q?065tUxKkElz1to0ieuAoKIdiMBKTcz8joDvMDleJAveFIvGJfBoPElN1Pqdr?=
 =?us-ascii?Q?8UJ7awUbafXknZvOwTWM1N2OR85LisOzFVIgZ5jUU9FlYTZu29IEAePkctwR?=
 =?us-ascii?Q?Nuw4EA865I9L9qxbbPWyNOdlhOJ7c9qJizAKbQYe9Pul4k16xd8uXHkkoOK6?=
 =?us-ascii?Q?D+JtjQpMjABM2zAay19GbTP0exHuGYaryNzTdQEFdi6I86coVshcpwTKsNcQ?=
 =?us-ascii?Q?5HDSsBJIDKWYq96hf9urvz3COPMiEHSULpc10gzSTUWkWqN5jxglAOQPLoUN?=
 =?us-ascii?Q?dz1Gt2/Fogg0lT6Merh1TxQEQc9RxCtBnmlL/z+5COgq7+XRxVmXcd3YcfgQ?=
 =?us-ascii?Q?vikGD0u7ryPbKGtsYdpH1j2EPKv6lwz0qw4024FhFVb7Zm1aNZAArQtOeSSW?=
 =?us-ascii?Q?FOM/aPC+fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A/Fbrha7VpgWSoLo2ZOWtpxKT7ihmREEN7hVCvWFsOYziTJwTzUsobGLKWIbejhzqGsamlYBAhP46LzEH7t1/Lb8f24slI0Z0h+KwPyUxJfYjlWezN51jqib16Ky+MMGvYRTaBOrG7hHGFIn+sbHT+fp5uo59/EiJBnHVlriPJlXTf1yr4KPSNa1Kz11qUXFzIBH5x867fLeJ6CQ82hiMhm8+P2pSCVefr8qxpH3csjM9+BdgBaPPIJwOGrCxccBO7l48+9vZDwzjnfC78gQl54RAxHOF5nAbuAhHrR08aY0NBL47ptDmGDR5YjaOM+JzQY/l3y6P5vSpHt/DayhPJyttjgL8deYYEM13IFag827poa8Ksp50UJ0AyUBkaZn/6JY8YFwPynIz6SV8L9XDjIPrWjMFv+B9ec8Yhr7jyC4OjpqANoKCoHltiehUI+SZ8jcPGRzWmR19UvaBlmRhgjBJYItwsNA4lOELuGpw5T8CQzUGPRnr0SLW6dXaRsFG2Iv+k81cdtvtu21G5dUoGXNoJWysA+f3DJc6xW4nAvzuYLNTX49MTFMxvmXg7zM9mh3Ee3pMvLljOgKLaOwVsp1j0kJKYDdBY25RiE/5lA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b1518d-dbe7-4452-8af0-08de651a309e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 00:53:49.4523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcfI9EWgsAjSO4vJ3zXYMU0afsYhXpEWkFPZpJoKjwRw456h3/JfGdmSWCxrsWrdaEJITvYDWk4mlo4k0z38cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_06,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602060005
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDAwNSBTYWx0ZWRfXyNpKE9LyuZJv
 MjGG193wwKIpdEaExNLL4+kGAJsGTDvsBcjVYKAu80AZtMHtmMq+kRTBNZ1+kW9O/BtwATLKBcw
 E7LKpZaYnlgU2EcveB6PsQu6mh/xU8GLfgkR1nN0a2LaGnsMy8bWugMehbzGyAONkgggXF/u3rL
 e8Vr6sY1pbW/Dy01fgv+mqVOJko82UWdi3+9NrKHrEqKvD6pICuTABjC0w4ePanOH1FW0/jEiAd
 vxOqepFpG5XFB+6U3wR2FHBt52kEGSA0bf7ZDZlv669DGv2l55Wj40GmYS+K4cM6N6LXXU4G7mK
 FS2rIyDu66Daq3oihJNQ4oquM/0fk98dqIkG/vPErPVCd5T3cTo68+jUUZN3zW0BBxuO+5bY0g6
 2rbZ0IKor0QC8yuQge16g9bVCiRsT5GGC2jk6xCzGXDBguEcEvm60xKWSzxlL8gB9idTjBDFsXy
 1jlvM+OlyenIR2TN1Sw==
X-Proofpoint-ORIG-GUID: zOVVDX1jST_bEqnnaO2FzgshQHiE9SLB
X-Proofpoint-GUID: zOVVDX1jST_bEqnnaO2FzgshQHiE9SLB
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=69853ba7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=9QmbAbKMmkWtl4gDuB8A:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam11
X-Stat-Signature: hhej79xkr77po8wjmt5jyf1meqoasj4n
X-Rspam-User: 
X-Rspamd-Queue-Id: BCE0C180004
X-HE-Tag: 1770339242-185842
X-HE-Meta: U2FsdGVkX1+9XhsWAntzpuJiOHC8TxifeQkVShgNN21QjccW8/GlxXttSrIPB9GtUta/Knn3D58/AwuonNOLXxaJcutRUvkpEvrCXzHlOHX+3TNkI5il6Lxh5jhK7QSMQi/7Te5Tj25bHkR4VXrVrwJjwY9hh97PzcIHrqC78G1y/najQwvWJvPPcg7/umx3zHDZNQIocOD0QpRQ/RhcAh3gEd7eYazGzUUw0TPR+pN1vEodErbOxNGT8oyy20me7GBs7eBFTX2MH7EjnSOdScovzDByaq/+ZDYM+JjUMukn7c3LzUMeu3evuMg2bKK++zn8AHpqt5cgGGrOUMfN53vxt7w/ceHX7rwkqyN/K99CjUGNF4BdrmJDNSOlmwfEWoBTIHPLeaJWq0ySyMVw3t/tB2BvTQRTHtv6s3XhonanygTKXNpZhtZdGp57ATj4g4N/smiKvxR5gGm+xhXc9nYXmmmYhjl22g9xGB18oH1ZS/yDGh1XF200P3NZ2wcxlKnzxoxV4YQMxPZ/jIEbv3/vAU1/FRKBI3mkRVeRjNOaMqEm0GAAicKTCRh+NawxaLMuIemkFppNN5LDEeua5a0Wnr16DJrzY/yxQKuchP4HW9N35bylzx/D1PXDM0RAYu3J0phXdT0FyuSjxNG85nr4Erxl6k8f4WRcfzOmMDoX9+T7KJ7rpGW8tN+hedtQcYAoEWS+Cs0UN9ED3fF3rrUwS2dBRtvVCHSqayk8adYX4XhW7by+4x3wnIHP8oXTsUTFY07KgNwV1cisP0eihrXDuJGUD33RkiyYRL9R+PuzxQw0iNktnKR8Ahl8tuVOkdG51bJ/hjMbywIS2ZdF/ioeAtG+AQEKC+bNFXw49RLIPjXAli0Kct1qvqY0Q5Oh7/EZE+YWmj7QtHFGt5+13mXI1ZRNzIDd71CpJIi78EzjcR7G8Yh8tXbADCWec99f3RaEvXpliJAI4d9P1pU
 1bb6u+G1
 /R0pxR+bJOZnZ9QU+/ZESrwW2RypXDb8sjUMMdmJ527XpLaMIwIFMMQxYd6eeAtqqtHgi5ccZvjG6rKuEbN6y4Q4O1y9DgFheAk6SNTxNUFNLSFAMcqHpijFmHJ9DMUj6X18T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 08:07:23PM +0800, Hao Li wrote:
> SLAB_NO_OBJ_EXT is set for boot caches, but need_slab_obj_exts() doesn't
> check this flag. We should return false unconditionally when
> SLAB_NO_OBJ_EXT is set.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---

Looks reasonable to me,
Acked-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!

>  mm/slub.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 865047eaf02b..3b1402e1c39d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -901,6 +901,9 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
>   */
>  static inline bool need_slab_obj_exts(struct kmem_cache *s)
>  {
> +	if (s->flags & SLAB_NO_OBJ_EXT)
> +		return false;
> +
>  	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
>  		return true;
>  

-- 
Cheers,
Harry / Hyeonggon

