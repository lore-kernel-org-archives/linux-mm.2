Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60443E73158
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC146B0093; Mon,  2 Feb 2026 06:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA056B00A5; Mon,  2 Feb 2026 06:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D276B00A6; Mon,  2 Feb 2026 06:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD336B0093
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:57:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDDF686834
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:57:01 +0000 (UTC)
X-FDA: 84399365442.03.F93B011
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 72D091C0012
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:56:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pbhkg0wZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U9OPsm0o;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770033418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffSfb8c9JiUEgT15VDj7RVlwQT7RFCWxKBt63vzE6RE=;
	b=UE+aDS+07dvO3mT/3/aNY5P/qXGz/t06DedxccXvm3MuU4ekC2I09+z2Vh7nPRk1tIKNWm
	1QEmE+InVE74wzd456TgKQFArIahEJK3YkZz1DRjILQ2Lwe0989oKQ9ueaO9+TPvWZn+sm
	qtsO/Q2TSoe83QerEX5KWlYdpVRgZ+I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770033418; a=rsa-sha256;
	cv=pass;
	b=hLY2LuM3f2qEbf5bb04zaam5q+PcP5bEmadUEgWIrsC3r3qWuqRP8nnTZU55+hQ/1cVWFU
	X/cMMzGnzuQP+iWr4ayW9VqWw0/2HOhtXh4eWuSGwLTncXtydvcgDoHMOTeXTfC62ghnWZ
	fZyWoAASLPsIRoREgpwvxuiHFHJyZaA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pbhkg0wZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U9OPsm0o;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128uMUe698463;
	Mon, 2 Feb 2026 11:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ffSfb8c9JiUEgT15VD
	j7RVlwQT7RFCWxKBt63vzE6RE=; b=pbhkg0wZn6h4z83OaVQrVD9UXDmHzV4QJw
	BfXTBSeQRKwoUvTrU1UWJA4YeH4lFQL4wBpLr+2y4QL89RY45KokQ0zswELiPIRS
	0CfwNfx3ZP1TxHrhj/3CZHYRhu5Vz4m6wBpuLuT9JvKVjQXbtl7vUuID1t17ch3o
	NTJkWAMCsEyMVL9cn4f6F/U5Djq7+89sengTsQwsRbQ5WZBhHwjZdOoZMnhb6qEc
	Wxt8qrjgxM98r3nbStwEl4B+gvlWulHY3TCG/TJIy+5T6NVo77EGrE+FfI6sCifx
	P3Ws4h6fzn2wt4MgwiCAjd9mF6T9KsfqXR4RmMFGiqXlCIfcUL2g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1axe23dk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 11:56:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612AwZ5L018622;
	Mon, 2 Feb 2026 11:56:48 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012069.outbound.protection.outlook.com [40.107.200.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186jtve1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 11:56:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b42gV31beNJEtpiYnP4mPsz9Jg15A9he6oC5rMx6k9uwSuaI9pyX6f4FlCaEAU0TH8Vbp7xC33YTZzp7pWSYzi30VCZeWC38a8michEJ2UFIKP10vwq1ldNzk4ybz7Rmtm9jLWjwc0SFl9ghOvj5dYeHGcI2uGe90bYZkOinlGeVu6NCIeRkzI0v80lTdzT6m0DsMGvuqEKUp9Kb4G+BXhG/ABO6oF3gVcZiO1PF3gR+tKlrBTZI7VH8xDm46n9EgwDdV0OKxcAOlF6djpkCkZFgU3L3i6Ngdh+aLsdHjin8x5kCUBMVxHm1aTk2HE9B0TmqTN9ztNP7il2s+1ksPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffSfb8c9JiUEgT15VDj7RVlwQT7RFCWxKBt63vzE6RE=;
 b=bPnp72HMhSHcrQ50aI+xGVO47RWtDnofhfaQxRNQhxZEx7JIGs479U6Dl/0mHoN7mJQjh6hX/Hp/2Rn3AdZFrqux05scrBGhmwr7HPSTXHKp3s65+Y3iiTIgw1NCDTAcWzIzF+Nt4ggDYyr7xwpRIntr3ax9/qu31z/OtqCqk/vrW+Z1MqgfVmRU0nixtFaf5NkcH797A8xEgGq45hbcP0tsZoliik0XnotgEV3ouvyIXZPiJLL5Mk/r9G6Wiextc5hMrI6NWIJgaH2lkQJ2goDYWhbWffn6ydIyVOPakE6IYpg3zJl230+YwZB2kHuJOe6JS79fon+4B1CB3j5Xtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffSfb8c9JiUEgT15VDj7RVlwQT7RFCWxKBt63vzE6RE=;
 b=U9OPsm0oRUH1Hm/JcDXBmMS99kNaqNE9tUKBN+LhVm/6emoXMlK+rox9Ivd+x6F8ZpHLZqbMtQK4ELAIHYTDzm/d+ue32JRN+Z3XAoMtItu7q7MQTwNQxHhPjAcVmqfCf8tNyAV/mI0/R0AVGf0t96f0w06e2KrxjQDranzRQM4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CH3PR10MB7460.namprd10.prod.outlook.com (2603:10b6:610:15e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 11:56:44 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 2 Feb 2026
 11:56:44 +0000
Date: Mon, 2 Feb 2026 11:56:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
        hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
        kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        lance.yang@linux.dev, linux-kernel@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [RFC 02/12] mm/thp: add mTHP stats infrastructure for PUD THP
Message-ID: <a2f775f3-b966-47ce-8e67-699582b2f0ac@lucifer.local>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-3-usamaarif642@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202005451.774496-3-usamaarif642@gmail.com>
X-ClientProxiedBy: LO4P123CA0482.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CH3PR10MB7460:EE_
X-MS-Office365-Filtering-Correlation-Id: a3f3e30c-c9ab-454f-f3b4-08de625222e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B8ehlW9p0gfw0gSSf7QJPhRI4qtOUXn6KSV+TcYRdRqThjazb0rIJijOcKc2?=
 =?us-ascii?Q?CeBzPwHear0HGKHSjW6cOlBP6h57oOtV5Lx3hqmXXT91idpDZDpaKpMz30Ts?=
 =?us-ascii?Q?J8tg/RA2gUTL7Ga80UlCWQefpUtb1zim1FbTzjX1v9FpEJb9kLYeK5uHzjay?=
 =?us-ascii?Q?w6EpBAV8gwxgo00suXLsqFrUmabqke83960J5Ncx3uGXKHTpUc+9JeiXQ+VO?=
 =?us-ascii?Q?AQVt2ydBsJ9CJy4OhLB5MrbSOCLI5GFIjd1LtsIQ4oNqNV2YEnQApCr8/Yj2?=
 =?us-ascii?Q?9MLFy507vL/JMGz/P7oe3kbsUYZJ+wtAs/TB95U+sVNh2rfLhKG6Tm3K2re1?=
 =?us-ascii?Q?NCIuTw05PRIDbKs21gnbwAoGk0vcGyUDbneyLwmyU7g2spS4HQAGYJ1luVsX?=
 =?us-ascii?Q?r+IR6Hzfi2YtiK72rdHzdELXWKn55YJhMlD0QB780KUj6+HYuuyjErUFXPcD?=
 =?us-ascii?Q?QnYY4MeUq1sC519ui79Q4pyBiPBOc+mIr/kunO1Oqh80LzF7PrXTpDYMLVSM?=
 =?us-ascii?Q?uWHVf7IQ8rf8GMK0NsYkac1WYF8Qmd2lTVVF3qaBF6yIwCJdTANddJSoceow?=
 =?us-ascii?Q?g90HFx4WQVf5OBZAsdJUjZD/npiJ1/QLSsBnCztOeyl4F9VE+/32biSSi1dn?=
 =?us-ascii?Q?VlcVAnjg/ZacMw0YF3XA+tWsZkkA5R3YBKHwxgbdqbA+oNdAlUygWxmDnZUL?=
 =?us-ascii?Q?sLCaqC3LxihQ8dxLvaOjTym3u5ox7fzhsHCLUJz9F4PfG6+RirNe3zF1JySq?=
 =?us-ascii?Q?IS/1dgUen7/r7iiN9Z+AR6PobBADaAKka8s02WTesb3zYb1DqaNnXYxR1Zwg?=
 =?us-ascii?Q?L9Ip2PY5AleHTP23htSQwtv4iBWf+1p1k0jOWx264aHcjUQ4HN0iwgweTZ40?=
 =?us-ascii?Q?o2yhKol+S8jXabDpvqXgrk+6724j/eddRQphEciLOsSvUlpaTkM8pLkSOPGP?=
 =?us-ascii?Q?lX+8opgPHKg97OOcEZFlik6RRTf2qHEd6urBHeVe/ltdLkrLpouIzg9KBWIs?=
 =?us-ascii?Q?OkaDkt5l1CpmlLrLYyl4o2ciky6HUrzJB1IxMGzxzEKh/4VKo2T1uFt41axg?=
 =?us-ascii?Q?rlTpDLnJ6hJDZZhZKtWVNrqMrOKeM6rjqlNdT+T7I9EBQO817xYPMgdKggfT?=
 =?us-ascii?Q?yZUTkQ2b0stfxAfl89C/ZqDnXlbbSoeKclTgXVAmTzhZvU2S7/uFhZp7Fm0z?=
 =?us-ascii?Q?tvEpN0PdQdE4VXTIq0cWBDRrsLVAkvXzGQcyaG3l0PixlpzFDH7sn+EEHH0l?=
 =?us-ascii?Q?Af4KAwir1XQRv0BS3MkUIQl5tWR8pmP+BWKCgME0yYe2SYoAmvErQEOIgbZz?=
 =?us-ascii?Q?+tAF2Wb6PtUp8wKEetdwaar9yHsEB5HxvhanYnmh2FTHYkfXnDQKiI1NMp3x?=
 =?us-ascii?Q?5vEQYhsI/0RyALL4AEwNi8cEIedpCzG/dcMbmoenOBzP1SRo25x/semVwZpe?=
 =?us-ascii?Q?ToGyGOJfnD7SwU4PhBYbRhfyrNEtEjugQEE0fk9tK8Kyv/ZsoHsCHf2iue0d?=
 =?us-ascii?Q?ySIsUXD9LIBbXpgp5PotgFJGcLwUtsKDr2DaZ7HF7mWIGjeNGNSDBUe5IU4i?=
 =?us-ascii?Q?CEoU3NTi0ymkw97dsqI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ViconYfxiCHpIHCLoJemp42VD4zo8JDSB/8bY931UJNpFFcBl0psQYhs/PAv?=
 =?us-ascii?Q?51ci+2mAIXg9cAyVqOyG+CX9J72i7IubQgKoRdMEpvkKLJsz262maiwqex3+?=
 =?us-ascii?Q?J8rXRTkYu+BOXkM7+iSVPul+ydZKrqUehoTJqWutxpkKL++PImzmx+TNG7jv?=
 =?us-ascii?Q?fZt3alPSAkRAMKOfYIXdcLB6NQ89VUOI0mFIcTVpAu65e9DLUdTWh5bE+usv?=
 =?us-ascii?Q?bFS8GMS7bcWYyui+gLqQfR+G8gwmbq5Ws6Ht41yCVVStoxIyBqBBRDcWPcFo?=
 =?us-ascii?Q?aDI9rvTXsMVjgcVpvhqNJO79F4XC77/ZblUAEzM3IgDoYfSQRVT0BW7IZjry?=
 =?us-ascii?Q?N2wdXzZ6NcSBDG6499ldZM8JNpZlvAGeV7MsM5sgYqirCfBFOQkqyfnH8y3R?=
 =?us-ascii?Q?sNSlL8uFRWmnQs5bfbMvnsPYYqlfD3drf6flRSrwle6L40r0fGaJs9UXnF1f?=
 =?us-ascii?Q?a72VQOvfkdW2yNebrKtCK/NvgZ4D3wUnHrH7RKBIZrdDZ9XgrlhH/SNUUXDu?=
 =?us-ascii?Q?1GXbcZBUEBf0eH5X4cM6yGCLJOn9LWURd3phQTPyHxumx1QXzjAZTpLqmf9z?=
 =?us-ascii?Q?m17PsNvRr9kn6amL8mSeAjGQC6GeJfnVH/Qy8x+1EQz9BIb3/jFhdLoTZl13?=
 =?us-ascii?Q?kkTEgi9m/cZCYYL1f+7XiDbtfDTZcsdzVmoPb5DGYwpnpg+GnxWMp5FvZ6nB?=
 =?us-ascii?Q?NWzYhJNMyorgbXQsOBfW1ZCsgZ86/eGNxFT2goByhQDku0q7cNtgZhRHPAbg?=
 =?us-ascii?Q?Tm3QNIhIkdhNhJhLvpN2K/XQFjqwl9qJgLVQ7Q4f6kB9TCqL7YXRcUIudTY9?=
 =?us-ascii?Q?xCsu/6+2w2NXnaC09rtEHPdGQfTNc/hDdv+N0RN1EuI539abemUAKVfXaH4D?=
 =?us-ascii?Q?gFPQ9NrFKcOVKBkFxOCCc3QM+M8w51+H9gni92frVLNkzMsS8yFULfMef+CA?=
 =?us-ascii?Q?RNAtOL3Ihe7r34pUKLDeV0cW+NvN2srgDGjxGuO8buIkMKN67xnJmWGbVqM3?=
 =?us-ascii?Q?W8ZLc5oYtP7yBXmKMrzJtPS6EcNMrEcNP4jXyH07Iarh62PEZFMs0vo7nYGQ?=
 =?us-ascii?Q?pk89NAmQdnILodffkqEMt7+vsfpaSgHXcQOkAPH3iueqra/3tfLwY3RJfohC?=
 =?us-ascii?Q?sp7oIoXKJNltib2zE1Wkd1c6yCFfO/Vx8Ime3Qh9Q6uDKSZb13cV6a9JYBWY?=
 =?us-ascii?Q?MBhnnzQGBPagDKyQjPADN/go4sKHQhm++97/+9HUXpLeRzcCmjkYKIMYKarr?=
 =?us-ascii?Q?IlYFNKUa1w4jsD74E6E7FbP4W8+fiBczrQf307lcP4tlOhL+91eE/jO5+mAW?=
 =?us-ascii?Q?O1ydDt2a8paZxa19QrOw9QFCGBLDEWzFKM2cx8h+nM8HbOXb6ccY5NRlAL5N?=
 =?us-ascii?Q?cf/BhloFPldpd8RM2yA2rCRiUSYKXJtJHLKAkfVqvIlzA1TFo21k7Ub4DNwm?=
 =?us-ascii?Q?xvnt6eWAYK2/JYtsru9Fxyz4Muo7w5N+YVCNjBvk+oY9iIb729VyXh71tdoI?=
 =?us-ascii?Q?1UVlvQ0uTkj0OclhQ2CutXOOOUanOGtaTSps27LBVcmcHs2BDq5yYMLXC+ki?=
 =?us-ascii?Q?6wvNVAFGFEEgArU2djlTBpOgPSznCwsGQq6Znx7/C1uCL4O+gwzsO1XJpbkf?=
 =?us-ascii?Q?PCtbmLjylw2GELlMlk9g8oRNeZgqWVX0ROgPBfRKILXJUVo1eqiSkhPryWWd?=
 =?us-ascii?Q?6i5Fp4xDsVHKtz91DVWHBrAHJ0/7LGf6KdNSMs7Z3rt7Mxbbucz2FDvZMjRe?=
 =?us-ascii?Q?fIDpocgqNYSAS9y7OTg+NaCsZG8xkhQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PviyuoSJIkY4b3E0PPurqE+FkA3RkjZ2AyCCa3aTE0AHbk9C90Z4/cuVVfTUKlAEBrWxScchRsbpqQJJ7bTW2lje/Onpep6bPNOrYiz2CCq0xp5nlODY6K+4EIHM/Ap/IjPgPyz9NjCpUGGTlfKKXdnmXPtAM1kx64OFy03lkjDQmQamHrbl27K46yDt/TR5YptFFDyE8PYAJoNjtqWvfB7zHUntCl1CSFLbLzbJTJpswQCym/aEGAsdNn7Dr3A8TQvkn5H+bV1iqEkgMNfg9mF7+hnM8NYkdCWwnJSp4zGV2m7dmHIyA6nPeVVqHGheHzWpmdPlCjIvC9w9+jpy8/RFBqLbUHFaJyqWCZEDCKaO8kHiQ1siZbx5c6QiBF6s3g47F5rpTcduBbWlKuoyMEBXXQwOmZJdsvv019JmoePs5nplmqYppdTxs3i2JnQENIkRZePezl90f0UembtxjG6CJ9jg+kQS2CGZLAxPHfh8o5b2gVngIgD1izdO54jIxADZ2fYf5m9xXjxPEA33I71atEJervDdmu+7UCD49g13cqwASW35ovaXBGavekKqkRhQT7S8EAQVWJj7idGrRARQXWHkFO8UOrrgzqCyvAU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f3e30c-c9ab-454f-f3b4-08de625222e9
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:56:44.7374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b27sbXgphmedDLoWVsmCURvYaWIUY8SquED6wdqQ+V6fSXRnoxiJH+0P61wZ9a3Joxm5105DNML/rFfZ2INqnN0Kw2f503me00Ncwt+btKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7460
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602020092
X-Proofpoint-ORIG-GUID: CJxQVTfRecr50L8Kq_463YOwiuo9-seP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA5MiBTYWx0ZWRfX0LFb7wzT8nlV
 gbRgNGRHJV9Y0HH9rCl+uY1WKmIUTW56/faYbzg8djD8+vzFZMM3McizPxaO2TV1WBnIHHCjdkE
 00ugSNsjiPMp5iJaeW6c2nCh2DcrFDacVSKwJjBI80UNEsW545MJOp1nw+1SAtPxXYlQrF7kmHZ
 V0xRUjNO7yrjFxSJNgHflkjFRQvCDkc9cqq8CqTdkpe67sNTeCUB+cPmfcsHt+bVtoFowa7rtak
 86UFineHGNbYUAR0oAos0stbCIeasHdVgPMxKdM/P7uoDDESBWcsDaSk60AJ8xdppNKgkyb3Jhg
 ONbrDgFVYdiGksoZUivRdaD5OvZU4Wb8w/nBw7S/BzVuWEkmyOZK6AyI0BFyxeBWxNBF8eeX9OU
 Uyq7DCCxcSzZUCUSR0iRWaLIH3ZcYw6wad0YQ13KWEfw3BIMNh6DDbS5WXYHKQP0vw4+IXalDFs
 hwwcABdeI8282xEiLMRpCJeydY+6jFBSGjuZM0X4=
X-Authority-Analysis: v=2.4 cv=F5hat6hN c=1 sm=1 tr=0 ts=69809101 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=oCae5A3mbGEN_T9vk_UA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12103
X-Proofpoint-GUID: CJxQVTfRecr50L8Kq_463YOwiuo9-seP
X-Rspamd-Queue-Id: 72D091C0012
X-Stat-Signature: jrx7qgigxwkm6cxmc5smwfbhrbs1hi13
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770033418-663872
X-HE-Meta: U2FsdGVkX1+qz/VkAa8TJzUTzex4jIRRTUPB67I9ZF1z+aoOM2A5d/S6AqJFvoxRgORaSO2nw82pElSaVEA0gtOykf2XoZ/HnbGcaXH5nbaOOPKTd2uMIVoqgR3+SmJ3JDzbtSBtIqqysut3sj3iyOh63bejz1++2Pu4j9UtLl7CZxrU7BKbddXuhiAN+9PHQx4kcybbOwszGES6jrfvwxHTUjxnPoMnwxCq3nlXotfeeqt1ejEz2GMMKGsu1LCrF7YTmd8DvueXAnkpdGZjlcsvHhI041f2q8txZSZOvrUaoRwyVHtc6CDaQo0GxD4jYCI/m2QwNmDFQGmAqndKfqjrWldTsaNaIh1GiToUYOq85y+iAGAy4Sfgv+reGO/0jT8y/OUF5Umr0kNIlse/+cqFAPr7m7AKiCrDBHcGnrozqwQXro4d75lch7wSXK0ysJtJDjXmlN9Qlk8wPzHYuwFy9c5Zue5Y1DhwTyoGkOHjyc4k9+j79SaXRc6lNhijHBvP+OHh4690V8eiCiCic+s3oGTpCeEUI1pcmYGwv+waaM8NEbGDr99MxZyqd+UwSQS7qsGJMFjmhv4v5AcdHONk3kVkxusT+i4s2mfKFx5nWLgmtKSMiUfSQqR9pkg03A6UMYVnZ0COqZ9XQJ0TwgzhwDjlX3DE2Yr8ungvPSCi3k1U6YxrQp+UGvk4s6SPmNOaqyvtKQ6SzgSOlO58kiLLSuISGapsZJJLwc0Of5UgqsIegTQV4gvC7dPTasbpiSx5196a5iRPap7zjStnihelaym9CQa/e46tsQ2xT/V8XCadDVsIpyP6qs63p+I/Rxa9PIM3WDY0VBXlk6LhYIsv+P//n0zwrZS5APbCpxeE4sLDQTBpVC45ZQhNQUpVXeivp62qPekELJIeeUN2gHoXJ3G68d0GzwUMGB7lr4x/R9kTgj8PCcaKfTpIf3yrQVSNI4uwLLL77ErglXz
 fRehrfjo
 tWNDW6XjfQpTEZpDShwtxvddRr5q3JQ/MezvhY2ImVSLcsdN/4npZnK6jPdjeQxmfC/s7Y8Kl37B9VLpBlm9vR/PoUjv4y3O94XgzWZLUfi03a43ovmMHAhPw1Xf2h8EXYO4+Om0fYo4aAoouYgiGgoCuhIORSmwciyWoV5P0tayxjDGoNBS4pdLg9Lr6znLL2mGtj6cSXVrwC8JEnwHY5qdtTvD4XexrRTigi1OnEaIYxQC/LBrpmj3fEvWDpEGgxp+lzD+fs1lg+EbVo2KV/KoUC0ebuNI+qYYwtpDjNo/PMP+o/x2lBfCA/p9x9GkBYAnF1y0qY1isDLQdE/+0F6KkSvzzyQkGQAJr1vMS9lRDmYNC+WArYvPdXFAS1H4fjQGXs9MCqO3MaRZ0hcfD8hSTBEiEP/CVHlw6NeV/2I1qQjYM3wu7u4s7fn3JtL3NQWULZ4U8Qt3ryA7bR/BCO0Jr3P6I6QXSgqQ9vGNq8/UucKf/BVot2kE62SGhgdEtBpDZBVzDzkO6bQXXjJftllZuoaFlu5T0VbNDCxHaA6wmnHuIaTGxRUmsHeYKK0/ykEeD7Coxo9fopkpT6czyZwdNLXNo6zrphJlzRV6xGmXd6PhC4ZZ1rg6/VWnC29VeimncfVQ42K+8dgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 01, 2026 at 04:50:19PM -0800, Usama Arif wrote:
> Extend the mTHP (multi-size THP) statistics infrastructure to support
> PUD-sized transparent huge pages.
>
> The mTHP framework tracks statistics for each supported THP size through
> per-order counters exposed via sysfs. To add PUD THP support, PUD_ORDER
> must be included in the set of tracked orders.
>
> With this change, PUD THP events (allocations, faults, splits, swaps)
> are tracked and exposed through the existing sysfs interface at
> /sys/kernel/mm/transparent_hugepage/hugepages-1048576kB/stats/. This
> provides visibility into PUD THP behavior for debugging and performance
> analysis.
>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Yeah we really need to be basing this on mm-unstable once Nico's series is
landed.

I think it's quite important as well for you to check that khugepaged mTHP works
with all of this.

> ---
>  include/linux/huge_mm.h | 42 +++++++++++++++++++++++++++++++++++++----
>  mm/huge_memory.c        |  3 ++-
>  2 files changed, 40 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index e672e45bb9cc7..5509ba8555b6e 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -76,7 +76,13 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
>   * and including PMD_ORDER, except order-0 (which is not "huge") and order-1
>   * (which is a limitation of the THP implementation).
>   */
> -#define THP_ORDERS_ALL_ANON	((BIT(PMD_ORDER + 1) - 1) & ~(BIT(0) | BIT(1)))
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +#define THP_ORDERS_ALL_ANON_PUD		BIT(PUD_ORDER)
> +#else
> +#define THP_ORDERS_ALL_ANON_PUD		0
> +#endif
> +#define THP_ORDERS_ALL_ANON	(((BIT(PMD_ORDER + 1) - 1) & ~(BIT(0) | BIT(1))) | \
> +				 THP_ORDERS_ALL_ANON_PUD)

Err what is this change doing in a 'stats' change? This quietly updates
__thp_vma_allowable_orders() to also support PUD order for anon memory... Can we
put this in the right place?

>
>  /*
>   * Mask of all large folio orders supported for file THP. Folios in a DAX
> @@ -146,18 +152,46 @@ enum mthp_stat_item {
>  };
>
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
> +
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD

By the way I'm not a fan of us treating an 'arch has' as a 'will use'.

> +#define MTHP_STAT_COUNT		(PMD_ORDER + 2)

Yeah I hate this. This is just 'one more thing to remember'.

> +#define MTHP_STAT_PUD_INDEX	(PMD_ORDER + 1)  /* PUD uses last index */
> +#else
> +#define MTHP_STAT_COUNT		(PMD_ORDER + 1)
> +#endif
> +
>  struct mthp_stat {
> -	unsigned long stats[ilog2(MAX_PTRS_PER_PTE) + 1][__MTHP_STAT_COUNT];
> +	unsigned long stats[MTHP_STAT_COUNT][__MTHP_STAT_COUNT];
>  };
>
>  DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
>
> +static inline int mthp_stat_order_to_index(int order)
> +{
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +	if (order == PUD_ORDER)
> +		return MTHP_STAT_PUD_INDEX;

This seems like a hack again.

> +#endif
> +	return order;
> +}
> +
>  static inline void mod_mthp_stat(int order, enum mthp_stat_item item, int delta)
>  {
> -	if (order <= 0 || order > PMD_ORDER)
> +	int index;
> +
> +	if (order <= 0)
> +		return;
> +
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +	if (order != PUD_ORDER && order > PMD_ORDER)
>  		return;
> +#else
> +	if (order > PMD_ORDER)
> +		return;
> +#endif

Or we could actually define a max order... except now the hack contorts this
code.

Is it really that bad to just take up memory for the order between PMD_ORDER and
PUD_ORDER? ~72 bytes * cores and we avoid having to do this silly dance.

>
> -	this_cpu_add(mthp_stats.stats[order][item], delta);
> +	index = mthp_stat_order_to_index(order);
> +	this_cpu_add(mthp_stats.stats[index][item], delta);
>  }
>
>  static inline void count_mthp_stat(int order, enum mthp_stat_item item)
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3128b3beedb0a..d033624d7e1f2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -598,11 +598,12 @@ static unsigned long sum_mthp_stat(int order, enum mthp_stat_item item)
>  {
>  	unsigned long sum = 0;
>  	int cpu;
> +	int index = mthp_stat_order_to_index(order);
>
>  	for_each_possible_cpu(cpu) {
>  		struct mthp_stat *this = &per_cpu(mthp_stats, cpu);
>
> -		sum += this->stats[order][item];
> +		sum += this->stats[index][item];
>  	}
>
>  	return sum;
> --
> 2.47.3
>

