Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AA4C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 14:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB0C6B0088; Mon, 28 Jul 2025 10:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92EB6B0089; Mon, 28 Jul 2025 10:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C806B008A; Mon, 28 Jul 2025 10:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8CB26B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:05:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D8BDC02BE
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:05:19 +0000 (UTC)
X-FDA: 83713845558.18.88458B2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05CF24001E
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:05:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TytIf2Yt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jtX4e84h;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753711516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dfVRKpeC8Tpcs5qu4YfmLE2T6ES6YsifQZ58P9EiqWE=;
	b=jTiF3ggeKeTVJB8kRhoem99aRH+inVxKBqFwqOOnLGnQL4I5Ln6R6C1hKcle9iSDbZUfdR
	t2knvp4vD1LS5kNDTdz7epyQBJ3c0pSC9H84nCafOZlRJvinhTuqh0NPVe4S5xoUX5yeq7
	Kngd6HaIoU3CqhLaIYqpc7HPSY23cY0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TytIf2Yt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jtX4e84h;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753711516; a=rsa-sha256;
	cv=pass;
	b=tc1dZJEme+YUw9MQyuiDOnCI7oh8JkbodbA1i1uEcHFdRWWKMcG44DWmuGfo7EOAWw7fmQ
	XF7PU7UrJ/CGIf1T4kVCxBFYUzTO1PQHLPdMGBHNzSuSumYMBJ2xbBKW4xPn/tt8s8uCr4
	UjW43Mytq+BktXjyom/sd4N2gBrOspA=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SDCcc5028470;
	Mon, 28 Jul 2025 14:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=dfVRKpeC8Tpcs5qu
	4YfmLE2T6ES6YsifQZ58P9EiqWE=; b=TytIf2YtnaOO09TK6PR6K2Nr5sIvuQT2
	ZwTm55I+G5FQLhx4izw1hRMRNRB1qQ6wMVBgATSDdqmkDHclXO2q37B/F6RDROHw
	pshUhK6/DFAOKQ6QBb4XElK4LOkhuN5a24rchpVULXAQOYRQQ22Gb3UU7yAEJS1f
	D/CmpDEDP6JSN+U5nZV8kJvlLY5OQlZzT+LqByyIQ9H5OKcQNRfBJJSuyWOtcTVG
	gtqD8MJsyXrteaIBnY35SCQ3hiXmvkhEh35meqQ7TkPJigpcMQMg/c1TwvIOP5pG
	8eU4JKudopG3hvClCzXUccLvm7pIR4eLy+e1lOIYOcjO3ivIW/denQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5wv2cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 14:05:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56SDkt9S003459;
	Mon, 28 Jul 2025 14:05:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf8mmay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 14:05:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QP45sPmAWBcmDvk54Yfdv4X3THJfvgRA5Zf7SPKuuZgXd7nyx/z98Wf7VRo7d5UVu1+CCAv2BzWunZNQSh2V7nZ6mPHU48Pe9HK/7NSzwyrXErw1p5xbmRNbl5L5wPXwCLA9eXtUoJlGk0nWudvL2hMcEHtDY/qY9XYusOqCVrrXb0djtTOB8BZfY7CqWzI/ZqLLGwpC7V+gZsZJ32CuDvTaCEITYoIPlczSjChmfsqmwQ3jdFK1JA/mFls59rMd8Jjell5MrzYUJzCnBFEls4WwCuC/2cTFNwLvwcByfF7lrUyIGJWVbgPZsOgLXB6Yt2C9Ru7T5xzLY6dY2vwMBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfVRKpeC8Tpcs5qu4YfmLE2T6ES6YsifQZ58P9EiqWE=;
 b=gl1BDA5wf7G/ui7G/g5FO1GqUaMalSZwHSxqj+Ym0EzQUWcXxWBdLumVLrK9saKI4v9ljrUBk/lhxIXF1m9tt5BnsIBUD8nIrgBiB0/zyjDz3Cl6t/Jmz4INvdJHTqynpHrIbDOVGzUzzheU+jZdYXRKrY0p29VVhJ33yf9TO3GqkrbK5B1DhjgEU9ekp1uTExzo6ndvw1eODx6aVDTjfotwKlvNRl2gw6kGigR3hLsyXjILJjqgyG/s5IH3u1s/R2yd+MGGMIdEV9qXFcNcOCMJ9WWXNykx538bsjuagXTiJ0pZPkqZhxirLBLtsUzS3pcVXZ/CT+2qi0y7BZ/eHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfVRKpeC8Tpcs5qu4YfmLE2T6ES6YsifQZ58P9EiqWE=;
 b=jtX4e84hdxm/q3MZ1EM9ioyEzpRT9m0DLcqvTboRHLFx1LakX+Bf5T8C1WOezYCw6QXUKJi+n+XRGwb1Ynq/fzUizL7eFSlK8ymG4fsQerk5pUs+nlgQ9sYhut25cSOWa5DRmdby+/9mTDHwBO+sZ5ptFlXubuHv++1BMN2BGKg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5920.namprd10.prod.outlook.com (2603:10b6:8:af::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.26; Mon, 28 Jul 2025 14:05:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.025; Mon, 28 Jul 2025
 14:05:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v2 0/2] man/man2/mremap.2: describe multiple mapping move, shrink
Date: Mon, 28 Jul 2025 15:04:49 +0100
Message-ID: <cover.1753711160.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MM0P280CA0067.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c0d25ae-2d45-4738-0e3a-08ddcddfbe0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?27ZDI0jz4xcD7hUlspftC92b0ldmT857jWslA6qDc8YimyZJ2d01NNuCZooA?=
 =?us-ascii?Q?c0Eg4eHR5GKRUATABUltBrTm5RnuA9Udw47j7RZS325xrNym67gsIYwXfkL5?=
 =?us-ascii?Q?XuMU3CZEX8+rQfSVXskHt1arPATc/HQ5jfvCMxvFI5JuprbQXAuqfPvpSc9H?=
 =?us-ascii?Q?j5H8W6SiVX6+x2P7edWt2CmMWC8Bi85R1XTOkg8Mc/CWz6VtBLc4sPepJrSm?=
 =?us-ascii?Q?ejHBfyjSVugM2WmOpPr4o0dUOMeen+iEGdcsE+5qXaiMj+h8bKCHxkZOqVRH?=
 =?us-ascii?Q?X8ON15vBJgtpFYm9oVK8bAh/T/aQ2s8G5zlTMqvu83JcWUJNo86XSJHM9nOe?=
 =?us-ascii?Q?k3VAmm0CRVbbZ7cWtYOFOXgTEmW5DTiuAIpibPYi8S3gEyOz0jXixjzAOSrA?=
 =?us-ascii?Q?RVSl6LWBB9XENGeUaI1QLtpAOmyLOdhiAccYZGF6eMdpAYD7b0rgPhstY47/?=
 =?us-ascii?Q?PGZwFTePN+myhNxnoUv+j2gNYjc/lsnziT2p+1A+I8zLjvyX4sbHQksBxC1f?=
 =?us-ascii?Q?YB2/HltBXCO8d5pqs/2lWoS1r2ECxw9BKYCQqgZNpk0REXemHm+Z61qAOEaZ?=
 =?us-ascii?Q?195Ul4g7GT+xGBotjmT35XpNw15JT4ew9/rYP9CTq2pZfFdm6iixC7bX+RxU?=
 =?us-ascii?Q?SmbsAwxnLMI0IUAyIp2tP21zrVMroWEh1oPWZxT0OulNSb/PBKkYruRGnYMm?=
 =?us-ascii?Q?81mexGyxDDq2DrHg7lIkYvQqpevrejcqebcnr48++xb+5gu/HcgrgKhJkkid?=
 =?us-ascii?Q?/N9Dbl8MWhvigxnBDcVTb8OEjVCydPVTIkGSzpFURr/jG2NJ2hDf3W7UX3Ex?=
 =?us-ascii?Q?qJH3dYyW1ysOhP1UwSfTAhSe8ktTiztD9DARCHkaxsGetaBV00Oj1Np+pEhW?=
 =?us-ascii?Q?hOf1seDqBgHOxHOFFRL+c8ByK7HGSiSTBzJA8pmITw8aCg6ea2ohfcYVuO0V?=
 =?us-ascii?Q?nHLtGj49WXJN1j9Jm+1uiH2eY3jj9y4aDDqAEzLOJrWb3lJcnA+CZNqNRJ9D?=
 =?us-ascii?Q?oOcOiRWFxK5McH6u1uNZDRo0B9uFnqtiZMCln/JKSg4MXWZbQhEbwIyNXPIv?=
 =?us-ascii?Q?xzdKUA1KnCXcHnmZ/RXmBd8pjTZX2t5rlf4NSmgwjx1aOoXw02g4lQIwvR9w?=
 =?us-ascii?Q?4CC6VV0RLtoXaXLNd3cRrNtw5CaT7BepXoq1OemSD+vywXURV/a3ibouxEzf?=
 =?us-ascii?Q?/kj5x+u1QCpbheXv4uSCtXyzkRuNrIoOIXHZot3axUD+6j0z9pcXYe4C2WzX?=
 =?us-ascii?Q?P6R4TNQJfGkKwo5HHGFySLx7IZvwc/dfDNmnH6S2oarM93m/etFBC9oPlCVk?=
 =?us-ascii?Q?1bbdne4JX29d95V62USLOdzZGtLIh7NsipOPUFoLxINmGicEVKavHjliF3GF?=
 =?us-ascii?Q?E+Ga9+XwllkN/2iwK9VkFL5QxKYcKfAY46yyaOQXdioHyuT1dyoNejzi/vwt?=
 =?us-ascii?Q?EBhFHZI8smI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iVCO76tF4pkPlTTLOJKL/eBbCnjAG/feMY8MQ35UAhRwgDOY6SHgMd5bhHiJ?=
 =?us-ascii?Q?UK4mKOJbX1szHnJJkXQHrCFQvOKErpZza0f0pcaoa8oOqvBpjnb9hf8dVuxe?=
 =?us-ascii?Q?VvXis7JzTpQ7ikUuVKMftus/Mre8XHpFa7nEeS+Qj4+zsf3MZFmlvr5Eq6Cc?=
 =?us-ascii?Q?315SI8krgYpsrvzc08mDWR3UjWFsaw4pKMrDoxF8gupCeBZFI9OZF/lf/rEb?=
 =?us-ascii?Q?hXnUzV9lhEi8ev/aA1txl69SnHlUxt7ysUT+gGivyJu8k4plWwpM30WX9hWq?=
 =?us-ascii?Q?Tl/i4PlbDpDs/UCIaX159co52V0YmAuz5g8XqpQaTqm89ZIoGaDLZoee7Hy/?=
 =?us-ascii?Q?gt5dpmYwVnISFB0YePBHsZ/gkGpFK1FobJCCKFECzc7dhhD+1FMfCIenpQvZ?=
 =?us-ascii?Q?Cup3Nrixj+zkp4Ao8rvB2TbO3gXsfDKTL09n4ZyPfbLhf9tSBsAVGJUs14nr?=
 =?us-ascii?Q?edNxiVDoEIy+kee2TM+e97st869t2CvJ8jY00bW2O38kW0CJYSgX6h9qhWq5?=
 =?us-ascii?Q?wvNgmxyqQk7WW8yRBybBYfPpNcDB2neE36ZpliiOcuvUWmW6hUEnPzG+vgNd?=
 =?us-ascii?Q?ohcKtUNDTBkj8ngaEjO5nmWeXVivaXGs7awugTqaI6PWz393mJYlqZ2KYKqF?=
 =?us-ascii?Q?RQtnojdxgs2DnSFWFcF+fkXMB2B11j6EmP3eqxiouaNK2BVTf5Z8MvDBhwNJ?=
 =?us-ascii?Q?gE7HDFpnjSMoHV04ZRq0ROMOXi52zAosModTqPEahjgs4uOSfLJT938pF2Mz?=
 =?us-ascii?Q?y4fACTiioUAFuQeSTCgOMpbB0yQMvanOFTrARjEKuXmgSzXI37balmbox/yn?=
 =?us-ascii?Q?Kuk0rqBFJK+pfEG/qisVvOZUSCV/D50EUtzYs5EIDmHJP0NC6wlaEVQKLrrp?=
 =?us-ascii?Q?HwsmfOt66WqdR+TRu04OLcX8B1dBPrMx8PwuRui6gzwOOmHxbn7aVnSnk/JQ?=
 =?us-ascii?Q?/wzT7Pm/36daYJqdGmFyyohCPFdS5a+4M82tWIDbOtgSceYFRSTc7ef6eR0m?=
 =?us-ascii?Q?CRuD4FLXmzKImG/3GWINQyQrgwpFIBjXaNzAkVLbLes7/nQI5YQAJwNdVczu?=
 =?us-ascii?Q?I86SqhQyZh47O/Nw/1bj5GbokQdS0ZMPNq+lBYzHeWsbpMhddLte7kv3ycP+?=
 =?us-ascii?Q?0aHCpXELjxSZ8JEvTtXcjW1aOsyb9rDSiyzwUe+qrybv3J5qO3oL93rfsmqI?=
 =?us-ascii?Q?QlFzNQ8XEVZ8pBjdZ6InX1AoIW3iLgaxnhVACeQPMwghxGZiAvaKcADTo1ek?=
 =?us-ascii?Q?hJyqIRxdbUvtKv6n32vvLryUOIcntk5pOhERoScU3pjtzi3dImOM2gwjd227?=
 =?us-ascii?Q?HgXqo1T6hOq5AMfPvTLgKhllflJWfSryVPpo0dWZgthVoiy2m4/xJCQ5aQBo?=
 =?us-ascii?Q?OLjQYKi1TOlozeK8DSXtu+7BRltkRntReAT9D9VQDolU1tPYhz46aX/RkKKn?=
 =?us-ascii?Q?u8kPKzI2jtlk8r+4wGRbbqGHHXXssVaz1zzQ2VAjFtwZB7BPRc1YmGwBCuLI?=
 =?us-ascii?Q?V3krLIhFQo6oZCdXM3Tt4sBNpLFQy+HHO6Ttp37eiv162XQEbY+spKvZpmQB?=
 =?us-ascii?Q?y7I88sEkMYqNMwb1QBxrEXnTjoyqpfZKbXrFZ2gAfKLo1EwpNJxy9IW935CT?=
 =?us-ascii?Q?9A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HbFD0OepRmIY+14227YUUzEE+pVpeliLEk+BOixJcNz+Ci3BQu10a862uwJVsRfAsoxJyuzh04ZEtAYYKA8W92fd3HhnJ4W4TdG2oygDOFVTkqZ2wTqBm8vM03BwOs6Podfu3ZW+ESG1tzryqF2eQvIdD0Wo1eXprMyW5NIeXp3QJhh7bPfaRXAQP8cbf8Ye88GNw1rws8G06XZkPSyXqIlGaZ0ZbS+qiI0C8z67vHgbANhUbo/LO7mNWutdycMwvqRhRIAPoRX/z9zjRuLSe2wYgZqMXZL/7sxtgREaDJxUqhM+gXEOguuyuxwEOYmZ22trirBjAXF8A+IyPFyMWdgJpwvl1BxYm9t0HqMZwgFvyyPVllElkZ42R1UFX1FOU9aK0+LOPZSdTvRlOJglC0HrfUxANeFoD5dO/wSWDCTiKCjO8lcXWUBfJg2/0HToLArB0y5FRHDRYDs9Itl+6IW4ukVBVD5We77xEKwYG429wQKD/mhDKMQyPzFAlRaPKFFdMUShkGvne+mgkDFEchQ7sHoBUCPmiRZkqL5RZE/bnhWkS/i4GW9dYffo3wxkr3HR4sO6z49nB8SKT8AI2cJZHTEEaWHp4i1hfqk1o/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0d25ae-2d45-4738-0e3a-08ddcddfbe0b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 14:05:00.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+knZHMVwsKbq/xM3orTZOze5k9zu4JM5LnzwiuGO/kTMZnIkIebrHsAQgoSuvBh8hC7IL8Bhuo/OvRqcBsq6t+KR4WJwREU1sTb97vtDXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507280103
X-Authority-Analysis: v=2.4 cv=X+lSKHTe c=1 sm=1 tr=0 ts=68878390 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ksT-AFgZVfhhEIfaLFQA:9
 a=ZXulRonScM0A:10
X-Proofpoint-GUID: R4HmvXkjrlS1v4M-I1eY6JTgOPZF5qJF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDEwMyBTYWx0ZWRfX8s/9MhjZFE08
 s2CY+t3KJVNRQsxS5BhQ7GN+1ewrf4JL59WoWil4oGpW8Gg8f06JIQRN7lVZw1URb5Wep6LIeDS
 r/8mAR/lDH6pzgfVwwmOM+d2oUbDLBmuQvrMyvQLxNwXKg3/bkOUaV+frTjCAS95GGo86gFJVXc
 QiKpAYvFunkQgHy6d+4fYwc77Uuqyx8P8gXaZwT8r2Q2ywN7FzGvl4uue5rfcqjqL9/rYbnrb07
 CIrnihIbhcfl29Z9GJpQzC6qDyOtEcNSjBDJzPU7vZD2LErHXnGOOYf2Rbx1DV+f/1fOmVVhAGC
 AD/YnjYQOQIF8CyVoiAfF0Yke70qgRO3kLhwBZfh1E9DqfCP0u4l0xS16j8EGRYe94Vto5sgfPn
 icYtufYVZvFzsQOQNFiNrRAKAh4ZrdXvJeh1kqMI4vWWWmmJJfW87Ia0wS72zQv/otQ7RI7f
X-Proofpoint-ORIG-GUID: R4HmvXkjrlS1v4M-I1eY6JTgOPZF5qJF
X-Rspam-User: 
X-Rspamd-Queue-Id: 05CF24001E
X-Rspamd-Server: rspam06
X-Stat-Signature: ywbpoouuek85coirq9b53njhz5akp7en
X-HE-Tag: 1753711515-49664
X-HE-Meta: U2FsdGVkX192CnQ9P392Csp1NMbRW0vs/YLbtens31j9BmPe0bdw1e3k/behskxZzq2YMjEaCTa+/JuRtRmct3k1TJTb7M5pRSdadVGF0t/8U9i3cQHqt2m2WDNHPebAuGMdX8GaZKfhlmgCnlWNNHLWh6eU/dfFMcbrCm2WrNC9EW+UCsrQVO8e4u56OqHipMb088tC+qntPlOMelztAca6fXSCHiow1jVa17AnOo0n5LaNbk8DMTc/G4Q7iKBzPVzgopk6eF04zDveFwL4DfSowRvouVS5bPg2ahTCbtmPhbgFqi2xK2M0LM4NTfwcbYxaqI57DAoknyaWpRYA+J/7XKdyq1hgCRNIgAvbkkUzALvndRjN2UOOR7EkzWvmjYpOYR5ZU1fhOZvkFARTI96hgmaY31iDDWKDCixx5CZaVKe+rv8CzfHQhRmxJjBrJPfRD9SGWzXwiZEnBssokLkND7Mq+nm5CbtfQX42OShrPL8zr3yHn0upIfQl8JJoqOeFAUAFDePV6rC6NH46OnHtV9DbibcFliN6Kmn5ScjL/Hhsvge/GAIhV1bm/I2v1Sz/Up6dUjarLDQOQ34bqxf1z62OZiiHoQUBboW+NwfOepEkC7wwFpve5NuSEB4MCIxdzKIrxseQ0e0Dubs3gMEhrABNFrmSpwdifZlV1To1+Q+cy/9axaX5q8VjNkk7IfPU+QIZ4WCdTK8vm1ox8ZnUhOFci2406xFPm3O6eUh08b+8usiF4wd2TCdhfLJ6fzrKJcJPzwM3tTN+TcDffsimUN37ZDLLt4dRg7ab8aiaWXt10YjBWRN4lRY/IN4qquXdmgTJU5OY7EwZ1wZlnkIjbezS53T9f7wZBWA8cfsWSGrmVLifSd/vid1oOdz7TyU6oCzeC65/FkdJbyaM7fnpNlQrmDwDm8IsbAQ0KEONTh2jqJSlFBhC/Ieu1seRCPwzmSYrzDDaG43DjVy
 iv70gNRa
 LjS5QzTbZoXvy7kc2SWLbrmFEEgLIjUt9CTvGn7C/n4/9l9m1MhreC8I+5+ar5TZ3CLGPfwJcmO0WQVxnNyqeTYeW10znmRUQ3ynZOcYrDEqyLUZNx0zqaeJR14+1XyWgPYOpjifjhvXgTTV1qzxnS205Xzyva9+Juz1Lq1PG/LBwmUY0wJsMY9f5Zc3VorrC0y1C2whT6KIWthJw9mYpMUIn3GB6ZdxgngWAPqEunDr2XYwp2C5wc7Q4/NHJIhQHxRHtZD1az4zVrNzFIOKecyuh3IqYatsDRBvueF3yCYPlFYz7DNDZKuiHJ0LHEqluRWU+Sm+8XbbXvrORDQ374nOJE3ouVVF4Mj6Rvo63q2t3yuebKNvLLyDAnKyhtaWG0YRDjDEXkWQdbH5Rwwt55lyyS287KyI8MimTbIiW0e4s28wT1Xq9vFeIP/RdNlKmQPTlY2hvcvjSr7e7tkas2Co4pBG2vda/6M9AuU9M5PNKlFxXK6SnMyPeDMCIy9zREexBWBmT7Y8M5TdXRp5Kl8uyBzF++aJtL35jnSyiwl1sgE61kq2c8NlKtTzrfB5Z8ZRm6YIb7Ru0OIaNS5v/xeqUmK0YQhuXjeHtXMJ6KSFYzpP25foIee68Lh/Htyy9ZT1CyRoKpEGybdd96rcB+TfxTEyKOTMOcRhI4b5PXnKCkTdRzYpEh1Rq8g5Z+2gBwGafCUAlx4k2HAAZh1kisAoUfYe/89Pd657IU3u47MHksDFFF4014C/zrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have added new functionality to mremap() in Linux 6.17, permitting the
move of multiple VMAs when performing a pure move (that is - providing
MREMAP_MAYMOVE | MREMAP_FIXED flags and specifying old_size == new_size).

We document this new feature.

Additionally, we document previously undocumented behaviour around
shrinking of input VMA ranges which permits the input range to span
multiple VMAs.


v2:
* Split out the two man page changes as requested by Alejandro.

v1:
https://lore.kernel.org/all/20250723174634.75054-1-lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (2):
  man/man2/mremap.2: describe multiple mapping move
  man/man2/mremap.2: describe previous undocumented shrink behaviour

 man/man2/mremap.2 | 93 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 82 insertions(+), 11 deletions(-)

--
2.50.1

