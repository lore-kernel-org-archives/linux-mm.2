Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5438C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 11:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2252E6B007B; Thu, 31 Jul 2025 07:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FCCF6B0088; Thu, 31 Jul 2025 07:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CE96B008A; Thu, 31 Jul 2025 07:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE60F6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:13:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DC575A263
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:13:00 +0000 (UTC)
X-FDA: 83724297720.23.0366BF2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 234F740007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:12:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OILWJ9iK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nyfku8Gp;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753960377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAO6Tm7C6qgeM5ph5tiKctp+GMelbzRlAf3TnrtXAgk=;
	b=0iq5kz3KI0F2QB14HG2wejW4VMEh83SjXHU2hQMa+P5gUhxCm62zp3K0+2ttnTjsmMhFpE
	XQKQkx6KS0Xw30ykhaJ2h5ixm0/LBCJApk3QT9IHNJtzbkxkzLK1yxLdNw5gcKNX416CId
	1dqXY7Y70Zf3VzGyW9aAMIvWgNb/k+I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753960377; a=rsa-sha256;
	cv=pass;
	b=d1lHZRXu2Stn1Aafvkifes71kmwGU6KpR9yL0x2e8rYoDeFq7OThDCYRhLWYKq7w/aFraL
	uek5/sFT7tS3Apo1ek4Z6dU/Xu0Z5rTy7jg2b6W6CGKLdLoMjsWuAd7tFPKh4f13qqdfPe
	OI8tc7Z/7WMTcwoDm4tun575wXOwMHM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OILWJ9iK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nyfku8Gp;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56VAsRRF019531;
	Thu, 31 Jul 2025 11:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fAO6Tm7C6qgeM5ph5t
	iKctp+GMelbzRlAf3TnrtXAgk=; b=OILWJ9iKWaHjun1qta5AVRG4vTG/gE5e/X
	JvjKWXkGBeGFVWxr8IgdhqbBjDQRfMBa5RxuMDjSBpiagPICrHKAVwaUsNSTfKGS
	PkiTWXbtXS8XC7Jtc7FNUowBEh+a2+5Uzf0f9/6k4TaIce6AjNjOrMVy2uzbEQtP
	oZOUslta2bN4l0s2GzXI1an+4OTeRRGo9uLFu4EU8d0bTQxGZfBwNvTYePx/qqN3
	OEqTZ24pRBiRaXrpYeydD3kHhTzH7IMWocMQ3cXHMaF1IlRHNmBvXx8ioSD+/ddl
	CJP76A6RrkT5jTA1aTPVnTIhVShCnc084t+enh3KHzVnGRTyTS6Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4yku5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 11:12:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V9qHTk020847;
	Thu, 31 Jul 2025 11:12:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjnyxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 11:12:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xwbdixaoCnebRmmZrvs5ctdBgdu1yzEK5iijyzBA+LCg7CEzY56e6U4A6+82Xl+oI/RKzRl42G1DKAtw1qolpSpgP53Cw+eNJpyWZfFBF5Py6jd9sr9dSCUKUGRkL1M2aHTgn3haF++Q/DbiD8R1dR558C99Il15ZT81ZWgO5SU0TdKnPbBmci3+7pDPBskzVuFzUy8A99upmYdutNijBe7iTYguHGJRmTbmGpmtf2wBtLxS9NTqkxwZyA4F6XVfQtzlX8kc+18PEcyjPTh8EYELFgse4YyqRUp0H5S3T81DvaWnPQpGxIEMJZOhobCwSxJ0rZxZPVYASWZlH+LFUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAO6Tm7C6qgeM5ph5tiKctp+GMelbzRlAf3TnrtXAgk=;
 b=l2QoMKTGv60ydhCKv2Antbhy8W12QUxqmqwoVGGR6+uBF+mYwEzR8x3ViNRHIWSmCD9JZ+TZ+pRZpAhR2xc2UKNxd6ukBfpZsVtVahWBO/qe44O0EA0nfp8m2OGgIsIs5SxgYkptepbTXfUFG2arqCR06axuzqYZxTJOU9CTlcdzspYmbhn/4I5/h74+T5QQkRLdQ+c9PXRccs/bSXRACc7itfnJe7J+z9WRUUjirhwWLbMg/kyRZ5nfBPCkPTJWxc6b/DOs8sGN4DCb6rb8gttOEEv+22uVxDZbYlON08qdkUY/Phw1ta8FgKQP23BmAk0dsUAtc9OuvQHBMzjuXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAO6Tm7C6qgeM5ph5tiKctp+GMelbzRlAf3TnrtXAgk=;
 b=Nyfku8GpBaNTTj4D3LN85bN0JrjAd6Vhn3CEHF5tuCoH5OwYeQle7sEuKtiW4yYVk/Vy12V4LRgpi1S5a6K/p0Se49g+iXT8EVSvvnhRlDCnrD2MTsg4OD+T1xKM1NrEvBhj+aMeddICgHrMUYdho/9atBh1yF5cpjRK6G1ac9k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BY5PR10MB4274.namprd10.prod.outlook.com (2603:10b6:a03:206::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Thu, 31 Jul
 2025 11:12:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 11:12:51 +0000
Date: Thu, 31 Jul 2025 12:12:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: limit the scope of vma_start_read()
Message-ID: <dfb9e654-620e-4658-9ebf-96f531f3bc90@lucifer.local>
References: <20250731013405.4066346-1-surenb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731013405.4066346-1-surenb@google.com>
X-ClientProxiedBy: GV3P280CA0035.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:9::9)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BY5PR10MB4274:EE_
X-MS-Office365-Filtering-Correlation-Id: dddf3e20-992a-43a9-71cb-08ddd023308a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5oigPpAUJVCfVMTKVUdkQJoZtsp/rECnu8BGzPOZKmKnlpiTfEPNQHf8CjLv?=
 =?us-ascii?Q?tIkSPRnRJPjVl8fOu5yn1rYwsAPcf0WJkvrxhROhzb1a6Z7l7L/v7LCnOXir?=
 =?us-ascii?Q?ehFsbCxVuRELpOSLy5EQSN82G5gWkpQencU/x68BqzDFIqbvq39sbPb6VGtN?=
 =?us-ascii?Q?+Cm0jlFUiSjLuOea0os0vlIkyHgYAUWaXA4y4GLRHoEKs4qf5M1Emc4KhOqd?=
 =?us-ascii?Q?83ONYzMU4l+/PaeYkM0raBQ7VzK44QUa2b/5kQOQD1TE2qMcKbgM+w29Ma0h?=
 =?us-ascii?Q?Cwk65oY6C5t438yp0Lx4zLpMlsLcDAR5E5EzcQyXQRyfG2vOSTJnun1+arpG?=
 =?us-ascii?Q?d2FkLPqKv0B0l9GPX/yHoALE1+ZKZZrGLPqq9u4/Q/zTEbUvDXrfl4bfQ5OQ?=
 =?us-ascii?Q?MaU8Fy9sriXp6NcMGlK1gHkjSuYu5jWR12+1+igOroY1bx1+VU1+CbhQldNN?=
 =?us-ascii?Q?prfw4yWQ2DRxaDWCPiaCSCwK6eyxi2nw6FdWZiPm7gRYOjVJHmem5TiBvDcz?=
 =?us-ascii?Q?Ay++8XirF4FNl/oHIK9eUny4kMRJSJodW3ly9F7tgAL5GtNxhJWXz7nhE/pC?=
 =?us-ascii?Q?jfnLC8TCzWGo1KNx45XriGsqxtcTSgraBXgHTuw/0euXPcoNPj8kh3RvaCq+?=
 =?us-ascii?Q?7ZozlgEYI5gYizHBaZRWIAwlYdjsJ3BW34KKSobidCX0j/TaWQ8Aq4FGnxcV?=
 =?us-ascii?Q?VwyeElMqhF3T6k2qe48Uaio75Nl2rsltGPKAJ5QsPXEDRxQupNW5AY9+EO92?=
 =?us-ascii?Q?ZVZUVZLv5gLr2cs++A0MUgrfq3Xex47MzMQFgPg8WQQI4DLQkKLzSwDP4Vw2?=
 =?us-ascii?Q?aEy9G4p6xBMkTWwCz6kzxfdnGZzBIJ0fUpJof9QHCfOGNFZeWs7ELlNliUJK?=
 =?us-ascii?Q?RRbPelgNwL37XqBKgrXK1JlZ8DvfNHHpQQZIKVf9+X+OaEboagWcIm/kMroL?=
 =?us-ascii?Q?QpNHNaNEHnBNrbTqbszOO7MQfji1USqJD+sVVBJdiRhTF+MBLdhG0VERxpeh?=
 =?us-ascii?Q?0aN+r4lypQMyGrom5MxDiROaItVU4IGyBQSgb6I46g03xJwIHFjIzqqKAWmv?=
 =?us-ascii?Q?r3OlTe6+iKc2E5Dr+SarHY7J0iQeuUmVA03LjkW2t+iyk9GyKQX6ZE5AuHed?=
 =?us-ascii?Q?rfQVh6uLePp3lYfGkz+fMkJ485h7ll6Nz4/ekW7myofEw9qJoG2c19y46EjL?=
 =?us-ascii?Q?DXfmO1CFdXuyFrSpRqwb0+kvo/GhMLZVOFP8Yo1jSsGbD7BMf5gtY0uADuRY?=
 =?us-ascii?Q?6Q/72aRMI90F45cwLw8gGg/VmWvIwiQyWOfi+yu/f3QKS6cUJoa5oUYThQVP?=
 =?us-ascii?Q?aIsMC/L4qRtBgokfqCHVHGyANnK4UyShvLJBBYIrdL+JkKsCgRKYULV75sdq?=
 =?us-ascii?Q?qPcWIjFuA5KeEsdAjgd3ho9QAvH5+DVxpDyEohKYz4MFelNBcKy70c40HwfB?=
 =?us-ascii?Q?RlujHLEqv+A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ORyr05yLcjKH3fp/VSnyWVgBQ1ayiiWh7CYeeB70dkDrk/X6Yv4Ep6SMce3c?=
 =?us-ascii?Q?kEi6Md7wiSop7iCBQlviypAfV1zC49HxDRdRhiJJLg19rBcP1Ox3o75/WDtQ?=
 =?us-ascii?Q?6iH4tvyUSeSsHKJel42Ei9hh+t0nnpW+Ax5HbwaHacC7pt2cA8numx1fK8XB?=
 =?us-ascii?Q?1looEaMzTXXio2j+vJ7wMyE2Giy5+gNYkYs3KO0hMyr4M/Yv1wuM6l74CG+Q?=
 =?us-ascii?Q?4mNJNgIRqQkqxZydyQtHAv1VyYS8ogpIJuttUCL6Wp2tX63A+Ju5Va12vkF1?=
 =?us-ascii?Q?pNcPqXkMYRHGaTEtY/ro9ntsNlRO3Z1S9QOLB87WxDaX2UVV+VK6VALmJhgV?=
 =?us-ascii?Q?ImlYrxxFL56IkW2rg/VdX76Y35z5wCpbtZl8ecsutwMLcV6zR9f12PFPMpM8?=
 =?us-ascii?Q?BTajK5SSWwKZj3rYZtPFL5YjbgKpg9ErCgssTBKMZn/EFBVokkW9cdcRo+Eb?=
 =?us-ascii?Q?dsEqp8RlpB34ffaLpkhWupSeRtBv2Pg4G4jbUskXaO/qOAMQ+hL68n/qqp93?=
 =?us-ascii?Q?5F7hnCnVB9RJBxktw+EERMP8ExNL5G5oOM06zmsVKI1rWEo6/mKX7YGxGSau?=
 =?us-ascii?Q?sQCSyIS/FKTzCsxFhXTXmGIKWEibT0wYwTFfb9Prqly297Pllj3GHi0ra5pF?=
 =?us-ascii?Q?efDik0w7uGNY8T+9epk0YaoDChf1nJ+f0X9n4Ic6+QPxeeXFJtLHOAFsr8Vj?=
 =?us-ascii?Q?sRyfv+egobwdhR+++DHs0JiUmuZNLF3qQaixEgi11A/ao/7RDoVywRoxqF/R?=
 =?us-ascii?Q?EMqDGgiuaXlPaYT1U1AJJrO3/quGdM56GgLS2ZrlI/qJgfAk2LtbFlhkcwHE?=
 =?us-ascii?Q?kRbX9HlBVFcEtpqTfkAXxYYfZhrMvryra07JPdY9U+nz1bivMiC+H1rvtWuB?=
 =?us-ascii?Q?VkLsyQ3NeOpwK8kWXR0Tb8e1LbmiBZz/u0JIgu+N7ftlenjNjISYGmYR9YtI?=
 =?us-ascii?Q?+/qJMUJ/E2row+8on7lNKav5ub8A8JcarIpOQB2sCpYY7eJR5oBXCYfWq+mS?=
 =?us-ascii?Q?iwOosa+zj9UTJM5/JCUBaLYp00kpv/pbGFWaqJKFPnZPMRANACUnkbOhPE2J?=
 =?us-ascii?Q?9TKacEaMXkopaqq3YVkBzEQ7VHVYBbErrXtuM+Ca7SBp+FikO+Snjtsohn6m?=
 =?us-ascii?Q?PkGUl4M8SHuw1LPHvAQJrTDtFAiIJ02Gmvim+6FXB5dsSEV/E8fJsfPfrZin?=
 =?us-ascii?Q?J74qnu6SV4lVRa0LhDTSP4rB7KW0RC/4EnboX3PX77poNAkeMgvtiGm2dPSj?=
 =?us-ascii?Q?r9qbJP8oWswpJTztcelxK5Oa3JuLE/gx7X7SZhoUKOnDyB6rqBV6gGZZFpDZ?=
 =?us-ascii?Q?1Dj1QZpCJpjy5rrXMG8uzgxFkexJ2F9Nc3TDz/g/T4+U1yZRJzQUHyXh/Eal?=
 =?us-ascii?Q?ct/jvVboR0W+bzxGEKwiSmJKg1QUd3lhsKI4fp8ncOlEzCQgKdvS/ap/aMut?=
 =?us-ascii?Q?fu3UOO9C6+AQXUnGEoO9pmXqfaai6hZ6ynjE0q+5aBgEVghgb6Dzjasrcn4N?=
 =?us-ascii?Q?GRcKDX+MdNtb1+Hn8XyX/zljehkyDgyisubxXeqiM8XAoBHskOln6FjI3Oki?=
 =?us-ascii?Q?SB5CkbL0w7Uu5N/7oRywd/kXjR8V+rPxp8cM0tAR5delqB7hp4SnmWhEuvZI?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q5m9UoymI8HjW68y+RDqPKdW0Uyr+b0XOTMbedxDlriNYuD58yIIJGCLqJiedm4CpLWzSvNW8rOvcuSKCMBV4u4FjOIivn0iQnm/i5ErPUd5viFjchZbkIbCFFTgiLd1beDP4IDXtctvK6zWQWiYYSYzH2LSUk8ll4dIKGck3oCqQSSJg42LQrbSyIhCq+9aOlGrChjF8EVSYqzMbtBnkrj0NXmZbBXZYymg/aN5PhiDP0N5rEDNInKvezsfnZJsN8vBW7SCxWwbLnkAGw8jwxLPDMdtcNJfgdGrCh8MQvFQgxzbpaJcWKgAY31pPHx/Lc0qfkQUY8R5AFUCGf6/YyW00B1tVx/kLMmLs3Ni7y+qM+1omvLHcvwljC7Pt5LqnPV9Td21GPbzfkv484YM2oWpK7UUZkXmUQg70KAbTkmDaiPSkKX6JRCXFC/sgXy+3vmsBrsVLHO1S5aLUGrE4TvULtE6uVZoLzWhanV3VKIUDOJZFXz8wyme7CVf6J4h7F6gOO4o/BnvMgG3ZYCLRVHqNPix3Gn2tKbgbtWiOa/9eyVhfmnZANEXd5keT3TRWbAdLvM3kUBqVv8xrAFHomR7yUkyLrxOpkJ+7COg5kU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dddf3e20-992a-43a9-71cb-08ddd023308a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 11:12:51.5301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nP9rKTnvYIHqibYh675tvLhcoYQbKQnWjA1odnLIZ9jIwXClLB35viHlteuFFD/vh2tzqziElxBIRtv80hBNdZcSGI47HCW95VQ8Z1VCXkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-31_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310076
X-Proofpoint-GUID: lGnN8nZFVsbCD5Mkuf2fta_Naxtxdphu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDA3NyBTYWx0ZWRfX1ZnIAysXseZV
 JD5QDYelST3Qzx0R4pPVqLpe9uT8kO6V69StengLRZRWB4Jp+AqAFsPW/obFSR8obRxMgyhu4hz
 X2YT8dDJBIEDlXhXQQVnrSzcIuglqrkgWPUmwr8hG91DJ1mjJ/Gyl1CiLxuyYLuFU8Tr2Dqt47m
 nUMOOwHatqDX05CE8AvCDiyvvA/YAXFdylgo7+Fj6sYLULZ5HeVZkJoEw145+8DKS7JJOSleeFy
 O17u5gXSIpj0S9/mCx3760egjrLoHnt8tsqWUciwsxqepkoNshFms/WW7f1qVUZVcE4CLhKAZ5b
 Jg9153d8CDX/u+mraE+UKxyR7rdvpIQEinJpXNhWvDMIXmf5U1etoOHS0wz8Esv9E8kAl31oy6F
 r9412Fi54cwn+BubAKZUPCCLO6qpGAn2d4ZB/5nkITOAMlLWPMESPdDnErn77plpLMCavoBr
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=688b4fb6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=BxIJ8i9q6BBtgn-aMGoA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12071
X-Proofpoint-ORIG-GUID: lGnN8nZFVsbCD5Mkuf2fta_Naxtxdphu
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 234F740007
X-Stat-Signature: dz47thupnjd9kkm68ndewd468f9bohho
X-Rspam-User: 
X-HE-Tag: 1753960377-615256
X-HE-Meta: U2FsdGVkX1/fDwPMg3eoylSbcLHv5Jm0IPn/p7ZAO9vOQKXef+L0sBZsMXp48eRVeb3YtTHLFZXSkH/v4I0/ZAM7QyJ1/eg2IF5vwg9QGghcF2whmwvIg1IkAQxAu0U//ZVhT/EVeqjO0dKDCL41Emr4yH7EZcXN+bre8vQeGAj2pfcIHBC79Mos4QnYC8uElWkRilh/liaMMuTr541K51L9/BjaeeOUHXZsLK5gz86DFv6DS63ZqflVZ7bhF37RVeHnXJLKWu4r1F3tR5lp1Fx3OTpn4fF1Bag/7+xSZRDAEu71ZzHU1heWtAjHsOoPUnDv2DxrdiIp+j3E1kVTxMty3zlt1gBJLGiaovE2vbrcQEeZKolpKS5i0XEy09mrmwoOzqaLvaFUwm376OEZCPfRbi9YJLmUI+Uz4Opjqae8TMJ5DuJZsZ31rlFRwqwAQboIF5RF0FXK/Z5K6FEEKwnPFBSFpvumAQa+zAFDpwDvWjvdGyK2LQcIlysr2rsJOXEHsWUuGRr01+HYqHhH1tSnVVb8HQGAJ9UAepYX/jHU4UPDd0fRDztTFyuu4oulzB9/XAa4cKKfo8krEZa8f1JAt0zZSkpXNniirUYzbJAIGe79zSi8EnG6AK+yubllDycl2S94Hf12lhvqQeEJhcxx3yVcQVkkKTsi84ey0c6QaMZVncm5AEAfwQPrmPPDyefYjPbIbyFDk+WErJtPRFjv8ASdy8d4X+D+8Z1uXPmZABrmjxrb0bxDI+qDrKredeh1jIftH9016MpEvA5jAmMlyR8qPZxto1NeHMspLoWZvyZMaAWjRcjrI2/h4+qNBxz6iCWZinWjCQFgp04ays3Qg5uHRfp0ZTtQffFcVrMoBBt49AB8FzxpZlPGGvcqwjhCPbB9LE0h4qbAYJe+V44GB80cGXXNZQd2nJVbtWQ/jWGYP3fNrs9HlXzkOaTplPilxpMB55zw5ZYmVTA
 F579BAGE
 EqdScbyfkQHXCQbTZZUC0ITnGvz3lB1gOhbr1T6vDQPo4u/Gd15w92I8s6bQWibfPqSTVk/ty2vgsVO+P5AGYRWB0qd8fzXSLWrqpWKOPcVbCZwkX9nLELe7xJFZyVeZkEDpwc29vn8UHy7BHD7jDM0Q7bsvJAeqzY9M0RY/lkJdb2+UVTzJoBljPHAPL0PjRj8i1Zh3jiBFknjPhcL7TvQFKzTzELjkUn9nu+StDBYxBqu6zoqIw5RKBAAXV2D9rC4w2tCVi0bJETCTNXno6HBShT3Ji0JWENeyexuQK60CM9+PvCoG1ofVaVCZPil8OmR4N0W7DQ5s/SYpaGUAZr6udmRHvgoZME5qoW/jqqnj9q7WNMMSGi+unrkF1ZmZCUvYX99ICSQROULeSUg8PE9V0vbv9iNArScKik3VOGDnHuvZxIKFlw496OMHPJdHQfjSEj7iXkYO583iSUmeCodfohbjBce/hWTbZJ9vM8krpCvnyLPFcY+yMIThLQc2+SQJT/t4N/Fh6J1rBflq9J/8XoSHxVHpubv/hb50F/55TPg9Uy4Rr5x4ifGKcjNibsZp95r54TGVqFYKeBlKJnq2Doik9JzkvJ7nePl4H/5YIw4btYvJ16tLYOYAyPWskDpnn0NtPV/ayLyuK0niZ6QUdU64khMD3DnrK2no9dGGq2o10iAsVw7R5GoLhP9HXK3sDXJZaUUkOcobBPdpRHErL5C+EGusPs2m+CW6PrR3LeXwIUUeugENTYDGJnQMaM1yQfXjlnGTWTq6aSQD35xZlR0nFGb9WVxkke8qIuyOzmcPiQmhytGoz4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One small nit, or maybe just _my_ personal preference :P could you use a
cover letter for these? As I find the 2/2 replying to the 1/2 thing a bit
weird.

Possibly a 'Lorenzo' thing though ;)

On Wed, Jul 30, 2025 at 06:34:03PM -0700, Suren Baghdasaryan wrote:
> Limit the scope of vma_start_read() as it is used only as a helper for
> higher-level locking functions implemented inside mmap_lock.c and we are
> about to introduce more complex RCU rules for this function.
> The change is pure code refactoring and has no functional changes.
>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

I've checked this carefully, compiles locally + all fine with no
perceivable delta other than move so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mmap_lock.h | 85 ---------------------------------------
>  mm/mmap_lock.c            | 85 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+), 85 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 11a078de9150..2c9fffa58714 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -147,91 +147,6 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
>  	}
>  }
>
> -/*
> - * Try to read-lock a vma. The function is allowed to occasionally yield false
> - * locked result to avoid performance overhead, in which case we fall back to
> - * using mmap_lock. The function should never yield false unlocked result.
> - * False locked result is possible if mm_lock_seq overflows or if vma gets
> - * reused and attached to a different mm before we lock it.
> - * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
> - * detached.
> - *
> - * WARNING! The vma passed to this function cannot be used if the function
> - * fails to lock it because in certain cases RCU lock is dropped and then
> - * reacquired. Once RCU lock is dropped the vma can be concurently freed.
> - */
> -static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> -						    struct vm_area_struct *vma)
> -{
> -	int oldcnt;
> -
> -	/*
> -	 * Check before locking. A race might cause false locked result.
> -	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
> -	 * ACQUIRE semantics, because this is just a lockless check whose result
> -	 * we don't rely on for anything - the mm_lock_seq read against which we
> -	 * need ordering is below.
> -	 */
> -	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
> -		return NULL;
> -
> -	/*
> -	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
> -	 * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
> -	 * Acquire fence is required here to avoid reordering against later
> -	 * vm_lock_seq check and checks inside lock_vma_under_rcu().
> -	 */
> -	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
> -							      VMA_REF_LIMIT))) {
> -		/* return EAGAIN if vma got detached from under us */
> -		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
> -	}
> -
> -	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> -
> -	/*
> -	 * If vma got attached to another mm from under us, that mm is not
> -	 * stable and can be freed in the narrow window after vma->vm_refcnt
> -	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
> -	 * releasing vma->vm_refcnt.
> -	 */
> -	if (unlikely(vma->vm_mm != mm)) {
> -		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> -		struct mm_struct *other_mm = vma->vm_mm;
> -
> -		/*
> -		 * __mmdrop() is a heavy operation and we don't need RCU
> -		 * protection here. Release RCU lock during these operations.
> -		 * We reinstate the RCU read lock as the caller expects it to
> -		 * be held when this function returns even on error.
> -		 */
> -		rcu_read_unlock();
> -		mmgrab(other_mm);
> -		vma_refcount_put(vma);
> -		mmdrop(other_mm);
> -		rcu_read_lock();
> -		return NULL;
> -	}
> -
> -	/*
> -	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
> -	 * False unlocked result is impossible because we modify and check
> -	 * vma->vm_lock_seq under vma->vm_refcnt protection and mm->mm_lock_seq
> -	 * modification invalidates all existing locks.
> -	 *
> -	 * We must use ACQUIRE semantics for the mm_lock_seq so that if we are
> -	 * racing with vma_end_write_all(), we only start reading from the VMA
> -	 * after it has been unlocked.
> -	 * This pairs with RELEASE semantics in vma_end_write_all().
> -	 */
> -	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
> -		vma_refcount_put(vma);
> -		return NULL;
> -	}
> -
> -	return vma;
> -}
> -
>  /*
>   * Use only while holding mmap read lock which guarantees that locking will not
>   * fail (nobody can concurrently write-lock the vma). vma_start_read() should
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index b006cec8e6fe..10826f347a9f 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -127,6 +127,91 @@ void vma_mark_detached(struct vm_area_struct *vma)
>  	}
>  }
>
> +/*
> + * Try to read-lock a vma. The function is allowed to occasionally yield false
> + * locked result to avoid performance overhead, in which case we fall back to
> + * using mmap_lock. The function should never yield false unlocked result.
> + * False locked result is possible if mm_lock_seq overflows or if vma gets
> + * reused and attached to a different mm before we lock it.
> + * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
> + * detached.
> + *
> + * WARNING! The vma passed to this function cannot be used if the function
> + * fails to lock it because in certain cases RCU lock is dropped and then
> + * reacquired. Once RCU lock is dropped the vma can be concurently freed.
> + */
> +static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> +						    struct vm_area_struct *vma)
> +{
> +	int oldcnt;
> +
> +	/*
> +	 * Check before locking. A race might cause false locked result.
> +	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
> +	 * ACQUIRE semantics, because this is just a lockless check whose result
> +	 * we don't rely on for anything - the mm_lock_seq read against which we
> +	 * need ordering is below.
> +	 */
> +	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
> +		return NULL;
> +
> +	/*
> +	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
> +	 * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
> +	 * Acquire fence is required here to avoid reordering against later
> +	 * vm_lock_seq check and checks inside lock_vma_under_rcu().
> +	 */
> +	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
> +							      VMA_REF_LIMIT))) {
> +		/* return EAGAIN if vma got detached from under us */
> +		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
> +	}
> +
> +	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +
> +	/*
> +	 * If vma got attached to another mm from under us, that mm is not
> +	 * stable and can be freed in the narrow window after vma->vm_refcnt
> +	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
> +	 * releasing vma->vm_refcnt.
> +	 */
> +	if (unlikely(vma->vm_mm != mm)) {
> +		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> +		struct mm_struct *other_mm = vma->vm_mm;
> +
> +		/*
> +		 * __mmdrop() is a heavy operation and we don't need RCU
> +		 * protection here. Release RCU lock during these operations.
> +		 * We reinstate the RCU read lock as the caller expects it to
> +		 * be held when this function returns even on error.
> +		 */
> +		rcu_read_unlock();
> +		mmgrab(other_mm);
> +		vma_refcount_put(vma);
> +		mmdrop(other_mm);
> +		rcu_read_lock();
> +		return NULL;
> +	}
> +
> +	/*
> +	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
> +	 * False unlocked result is impossible because we modify and check
> +	 * vma->vm_lock_seq under vma->vm_refcnt protection and mm->mm_lock_seq
> +	 * modification invalidates all existing locks.
> +	 *
> +	 * We must use ACQUIRE semantics for the mm_lock_seq so that if we are
> +	 * racing with vma_end_write_all(), we only start reading from the VMA
> +	 * after it has been unlocked.
> +	 * This pairs with RELEASE semantics in vma_end_write_all().
> +	 */
> +	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
> +		vma_refcount_put(vma);
> +		return NULL;
> +	}
> +
> +	return vma;
> +}
> +
>  /*
>   * Lookup and lock a VMA under RCU protection. Returned VMA is guaranteed to be
>   * stable and not isolated. If the VMA is not found or is being modified the
> --
> 2.50.1.552.g942d659e1b-goog
>

