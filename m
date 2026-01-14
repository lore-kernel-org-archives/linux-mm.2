Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F019D30CDB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB656B0088; Tue, 13 Jan 2026 20:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896D36B0089; Tue, 13 Jan 2026 20:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717266B008A; Tue, 13 Jan 2026 20:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCF26B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:28:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC4C1C17F6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:28:28 +0000 (UTC)
X-FDA: 84328834296.08.EEA2491
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7CFEE20004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:28:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xbdo4bPl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lQ6nf5re;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768354105; a=rsa-sha256;
	cv=pass;
	b=vHm6S9fDR0TSHumIfznLrLAhrf5SPEH2fcRegMBI4Wcup8Y+UvdcNPP2PyvOiZkQUS2/HL
	iyW7r6POat439DyiLalpFIaFLpfOVtyYSlhgthtzwEnpl0Mhwy6sPygG/NmE7xK8UJYUO0
	vwtc7r6UfcdB7Ps+O7n2swF8GimQJiM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xbdo4bPl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lQ6nf5re;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768354105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SQJkzbNUI3PotvJXehDSOOZKDdEzHLNTs14hWmUydg=;
	b=iFmEUmsYn7W6mTKS4eHoLpa3s4B1bDbdVgP3C9i4wTc16MiZtuTCnkiMk/Q2zPNK0qTvni
	NVDLBJ/MjQiRsPHp7yFAPZb078dZN2XomXU9lDsSKzPzlMS3HwAJ9j0LvmA2skc0DH4Z0A
	bTC+sDbQiggujGg5ybmCq72f0voOMU4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DG2C9K3330362;
	Wed, 14 Jan 2026 01:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9SQJkzbNUI3PotvJXe
	hDSOOZKDdEzHLNTs14hWmUydg=; b=Xbdo4bPlmyDmy/nCaDqyrs6KIrAWfw3OnO
	pHzWjKbrSDSDxAFL6/HNN9SWvPFT81iDbGuNbCKFJwgSXxm6bwX0s0GvExDi9Xnz
	g6DT66+EmD+rJe8Ag9qMU8oG9UCZIbk5CzGWBUmSUcuKsLK9MQn5pFvFnNUIVsPc
	0qeKcbIrDTm0ZLhpsFpk6e1gLggOmR0I78jwBrrKc69YmJuHgT8bxrVQu3RIBMRG
	AabcufVtOn4L0IB0gHlhSOXSoJRdUpKpC4/0KxHFNcPb4bT9HirhKdSylMhNFjz+
	f729erqauvd530aYUDBJ7TaRtJvU2KR2LzLI/hkDEMzef/bCcrKQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrp8mjhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 01:28:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60E0om6E004549;
	Wed, 14 Jan 2026 01:28:22 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012006.outbound.protection.outlook.com [52.101.48.6])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd79efgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 01:28:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tTB9OiDVeaNQHyiQdaFrDqSJkSqsSWA81bsWNS6Xn6IPCA+7CsV4MmJRU/AAd/CLhRmyB5tlKqIP/9Qzp7sGcC+2CCa1lUvdJ0um4mE8F0xtx900eYBHzHnkCLOMWp5iTaZT7lsmBVATIvvbMUTsUo6iATSPmdzpTJta5Cksq3smMowV6BnZbxrXgd7cevl/Blc4Ww+xdPe+0mzphZI/xL2nb56SOuXUdD467JPRs/dtgv2v0ES8NP7c84lYmWDBZoXfLggqBufbKdUZqfrVhw6Qre0QZDa7fBcVKo0qVO/GDuNwheBBOp2sJAGG/OiwxvAPz/Bc3n2ftUftaxMB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SQJkzbNUI3PotvJXehDSOOZKDdEzHLNTs14hWmUydg=;
 b=sSIR/d/FNJwG1X0lW34fqtJpzp+m59dwe95BItwI55bGyNXcPx9i/Ity81wAzvhf/isZB+zLurD4UY0s+ao1ukjOhVMwRIq0wB69DdDv7Fv8S9UrU/2ZlP1V2xzgAJVMezQq9A7f8Rkst38y1uJ6o20nw4i7ZMpKFmP2ShAKIR4FsQJUjFF3q2S8jcmtj7L/AVB5H0SAs2Gvn0Ai0evWTCmUU3BAIatluSbor5lotOTYwKIHz38i20e1kVDadWGYeA4BQ9MlpSH4Icnysk/KkTSDfmaP0uFfJLAtusu2BmLwUiZdle8wZAmE4ElVboS2G7sCFUT+nGAgaUe4LrsHSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SQJkzbNUI3PotvJXehDSOOZKDdEzHLNTs14hWmUydg=;
 b=lQ6nf5re/EEdwrOZA50SPcaRIDTfPcF+lCGXuiFrUUns4PQl1bMy34yVrVt4Iqk9WvBIbZFVoSaNjS0zDXeGdQ0JMwEVhBsRKhDV5VMipmw5tdo8Ev9Qs3KGqa/CuHERgthIGggWjtgv0jJtjva7qzTPwI6spt1j7f7oscgq6D4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8251.namprd10.prod.outlook.com (2603:10b6:208:570::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Wed, 14 Jan
 2026 01:28:18 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 01:28:18 +0000
Date: Wed, 14 Jan 2026 10:28:13 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [vbabka-slab:slab/for-7.0/obj_metadata 9/10] Warning:
 mm/slub.c:7013 function parameter 'objp' not described in 'ksize'
Message-ID: <aWbxLWF0R5rIvRb5@hyeyoo>
References: <202601140605.GNpnpgLF-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601140605.GNpnpgLF-lkp@intel.com>
X-ClientProxiedBy: SL2P216CA0210.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8251:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d50b3c3-bc84-4d62-00e1-08de530c3266
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7sW8J3Q7p80tjnHvg8beLZ8CdHXlYyKuTSz11hMEhFd3Es3O4rkT8WZ72Oy+?=
 =?us-ascii?Q?ddstMtO8iUTcLx9PAZ32P1Qvsf6Yz9BG74bE8xNMYughpxCZHls2n6YovvCH?=
 =?us-ascii?Q?NSOS3c3EZZiIM93VTbS+YFLZjuqbmRaVartEMUy2/u9TyawLkzJ9fCbEMqTc?=
 =?us-ascii?Q?M5FDC/hnD4f0Q6zQDo8mxQALMZwT7TPI2oOpk6yYWnVxiv0EuSzavVRbibm9?=
 =?us-ascii?Q?Xo/CEslvtTaYJpiSOWIo8mbQ1L4ZiovauGXDKBSeIcDhHkKro4RKf5KmYue2?=
 =?us-ascii?Q?TQEr0FU8FN+MCZUGdrqwM10yP8vgq7KNAOrH/mLjlo9YonPztGx/g15c4R57?=
 =?us-ascii?Q?a5pGpD3irZLVmACiRgcFWl763a3zGgvik0XomUSF7Tm869H1KW2/JrMScPI+?=
 =?us-ascii?Q?PGoHPRKewULNhsbaJP3H5Yj/IWtBWfwPU5BRJJAo8kx0S62bBXqPNtjVO1KX?=
 =?us-ascii?Q?6I8WI/xDR7ziLgVJHk3g4riMOTgpsDOTcDDf5RtGdoydiNTErRPZ8o8b8BTj?=
 =?us-ascii?Q?BtHXmEzE23jkft59C80asTNb4vKogg0Spl0QdpEDrA7Ddm21t/Q6CnE5K+JM?=
 =?us-ascii?Q?oBAp7KT0OqlB+n9sFdwC2Hhv/yJO/skZDODSEwUoRSiUZvJZOco3wJVNjAMj?=
 =?us-ascii?Q?t9ocI+aGaW2by8S0oy9xGIodjVuFrpfqzAo5H4IKJ+CKpL2YrW0MwEci3uBT?=
 =?us-ascii?Q?4v3PkmNCL2QHy+v2RcGAYshWrcfQ9muFqlN2pKuYmZDJNYNZSQP9mWgeZ9kn?=
 =?us-ascii?Q?pH/64WecRTLD4yBOsaFCDestrkxPxEaNzMMD0yJk2wEcerdWH7PKOvlp6rzj?=
 =?us-ascii?Q?Vt9oDRYXUCxLRqsmXCLsjQD7NZcgkza0Ef4j+qDrZepBtJk1+9vjUTeFo+m4?=
 =?us-ascii?Q?ACOtMlCMTXmdufKLNBkwjQ7qrbXEoOnBCo1IBn9hY5N3jfPaeaFLYgZaYHWi?=
 =?us-ascii?Q?J8Jc9WTgpEjv2LYKfwCUXPzBHG1uMnRbYRXsXYPfYzK8+o6MHzkniLLfHelp?=
 =?us-ascii?Q?/eIdZeecpCusPHftwjhlxWMevYMjzfKXk3bVMzTASp9hejz3+xV/Euyy6VBA?=
 =?us-ascii?Q?mLeWr3OFC8U55uBRUDopi8BoaJydB/mzYP+nc8q46H0ITNkagM1gWj42NW4v?=
 =?us-ascii?Q?dXSV0s9BGn4ew+mI86Qk1WQemPWs3wTsIE6VNzZMNcr/b5vZaH4QHR8UPj3T?=
 =?us-ascii?Q?h37EkdWcIawbSS8IADqM6hZmXBYubkB6k60Xz1ZU8B+deYpEYFzq/Rn0HmiG?=
 =?us-ascii?Q?lhCmj0F/9OS77P3kyeW8RVVohnTg40cJ93BSxHIhvXGKz6FGctDN0yu6O4ej?=
 =?us-ascii?Q?6vx1noA6wbEoqg9ySC6iAKlYiNKzk9w/4tlm00gzRGSMyha1X/Xja9yUzSLK?=
 =?us-ascii?Q?k1Maqc1+opbD8dTH8iFX4ChsWsFDhDDpw7nKzbfr46zYyVhjnzst9L/p/Pv5?=
 =?us-ascii?Q?ydIPaij0TQKgyRzljTMPgL3RUoSzh63w1UhRx2wPVHeZ22e+u6FxVQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C+QvFprY+h7DdHpY05k4h3kjo2BhRaZz9aCwHqmeZSpd+Vg48j+Dn+QFQqy2?=
 =?us-ascii?Q?G/UH0XN2Tp3aQRFXxGoKC7kmBHKsyZrvGa1vhJ3U3UtpKcf5m3GL6MSnls2I?=
 =?us-ascii?Q?BTIch4Sa1y424ihYsYYVKZby688ybRkULtPNB+PKoTz5UIgq4uJI1lzGXKLW?=
 =?us-ascii?Q?9Tk2fjbPrN+OXRgHyl7YujpZMhOgZBRJOKo/wK6UfINf7/Y6SB/a1wCBGeDd?=
 =?us-ascii?Q?cgHlPkEQ5fImWG46BYGJBvYL7mBK1tUAVr4LHopb/ooD7JGb7KYcwFQzzHI9?=
 =?us-ascii?Q?1ZbjnG0pTjXPLOdzQTm/aBiyt6JYUTk3CNelrCRCmlym0sl6bYxRGALAsZO0?=
 =?us-ascii?Q?JQAZ6+pGh7uMWeQw3RtzVE2j72s/+jGfMs7pLS8ovDIm29qFZap7QgxQcSDF?=
 =?us-ascii?Q?2q5uSC4u+KQBAkhq4twZdOAxvKUfWGFlI0rBNUQ0DFK25v7hSz44j0My1h1K?=
 =?us-ascii?Q?0YnRHDVfFSzfCWlqoUN3Y3lhPSwxh+mUd+JqkZ8aZ4vkQsGMlXAsnXxcQcjR?=
 =?us-ascii?Q?l/u20vL33VH6vz/c5ia98BooluO/F3U6Mg3PYeZ4HgizfrO3uyDqLfr/PI3o?=
 =?us-ascii?Q?rLSYSZUchrZjk39od2Ks10sJN2O1BAD+aax+7iO6QMbmVkPHJqAxKkVf1Qwq?=
 =?us-ascii?Q?24LO+FqgKl4ZnMhHHSzDBXBML7X7cZG/EGDcE0otfkw4HC1ibqOwh3yKi9UE?=
 =?us-ascii?Q?J1AZ0G1taxmf/Ki6F9lg2a4eNBxnr5Mretj51BcYNZPnXcY2TlRmgNTRpTw5?=
 =?us-ascii?Q?G6ZRh7Tq+eMIWX1Bf5xJ7bzU5+hLw4dZ94I1CJIEc0agN/GK7iHfbZAEqXYJ?=
 =?us-ascii?Q?tN/YoeMXLlty64THsyI5/lvMaaKomQOOtZ/Xu0qDM4Wvdmyrxa3FFenASi3d?=
 =?us-ascii?Q?AVyUAqoS7yWDOcYfNGOUPqiYmO9WBuzELNH/V4ejkcIgGSQ5F6evkwvRdsLJ?=
 =?us-ascii?Q?2j8UvtLgXMilqFKDk1ZI4aFwgvPc8nS9SGScUMaM+SHPUud4liwTGv1cLPEf?=
 =?us-ascii?Q?M6Hj9WFAZRIIYkvV/YgsvRZX73durmh8wLW+sAkb5mZvxbgei4y6Gd0n+m7W?=
 =?us-ascii?Q?6Dt87lrrmTsh14W4YGyThHsIl2o7X4/OlxEA7eCpJHp3kiPZjj96v0G2qJEj?=
 =?us-ascii?Q?Fy7ak0/Y2/jAUGAjufU/909DERjkjO7veLyXyCTYC3fFoBYjWSAbZKtcf/d6?=
 =?us-ascii?Q?AYNWqj1kGkhEKvlVCpDJwjU20ZJqVIWVWvdaq0s/+WXLXs/91qMyn3j/NGMU?=
 =?us-ascii?Q?euz0WdQHKUirz62XuI2pgRRZIIc+Dhk3HHzLSAKF6rAqA0W3vulwD6qQ5zGN?=
 =?us-ascii?Q?4AVEkMpu8pPiy2sNTgAqR7eZo4MAomyYh3MwXKrXDsr4ORmOKqBA4JKl5cLI?=
 =?us-ascii?Q?q29bYzUO7+HhDX1yGlgeNYJaxMn9PnVCS0v8RGqy1biM5lMMsPB6xZeR0o7G?=
 =?us-ascii?Q?qQrQKHHS6WRgGPeQiVR0Z2Mk+bbrLjRDjuYvZ+KZEUzte3WsnCv9vViqA0eT?=
 =?us-ascii?Q?XcR/a/GZ0VufHZoJKikzdXuM2XAURHZsNN+Tsxivfqq3DzzpXpapoQPoGTqN?=
 =?us-ascii?Q?CpqVTx7y8O4/GI19NtDTdgn4v57oiBHaJeL6LFibhERYE26L5E9tK1RX+WZn?=
 =?us-ascii?Q?xhgCKZM29Q2XAKuPSYozKNTQ2Zll6FiRNTW9fcp7hSvyKK8hcu/ug1ldY7yo?=
 =?us-ascii?Q?6u7Tt0Gw5UBzwbkRGldaiVgnMy2fIzzTflWyBrxH6SvCMzl8Qxtm1ptFJ0gx?=
 =?us-ascii?Q?1EinYfAm8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MTDpvIMC+RvQEBLVPATgmRxN2kWJfW3tUhL4JE/XOC8w81Pptw9M5vCcAOU9112GWtySgTpYq4KS39mvP9mNsr/SR201FwbNPsrgD7F6Z/RO2VkrVIzVckKpqXFDDamIwUj392A9AzMfoQYcW7V9/hs4G+kmnmy3TPojQB44arI/Z3QCaoKHab9vYKR7jYS7mqgwDGmVJwcl2NVUoTxWGgv1XLy9rb0EoFj9hDFtfcg7anX7VNGKh6NWbglQOpdNoxMJuYZQUyCW+R70qCTtjp2ka+/F1qPtprWX6z+Ut6VH5wbr3oqxbmOiRo570dbEQ+vhkGtHArhtjmSDTVgBYr1rr/Le5bqCq/5D6pitIITrpcjlfHn1g0Uk8IgsDzepk3TZBjTFdkT5hbddDFAH5tkaHPOzgAHBQ/kow4wlp0rO0M2bFoeQWl4LrzGF0cW+jYNvvYUXPhf47EUkii2ZVktdEO6tZsKbJ6q4qmHgtW5JRjVhPlh+vdBKbFHemkVpZ8SOmOOZ/8evS8L229UAvO0CJqBzHDrvHp8P82xBE61aVcpJLdmQ1W86iSDmX1yV0lex9bO27stDg8xM0y1+Ri5d74nG6ZAbla2dKynNHmc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d50b3c3-bc84-4d62-00e1-08de530c3266
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 01:28:18.6328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZ1Tmi6n1Hdyx2vH+aKboJqisHTQpwZakcijrxT9LtF0HeIlmJVcnyYbvXdfwNYCDn/X/l51BDIdveIs9lEQdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8251
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140008
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDAwNyBTYWx0ZWRfX/nk37Oc/2sTs
 jARRYMg6rWREcxrBIh+M051uomevq/xZ7Bu6sZibPjhCP2fV9Q9GBsDqjLGWwAbb1BSTJ7/QNAO
 JOSjNcQxNd50hGwc3hmBbf9tjb2S02JQrvpvNRWelLBjY3hfX/2VN54JjWaNuADObLP+O7uls8u
 J84YcG2DRc2LQ4G7Itou2rim9kfTJwO4kAhO3xP4DzST0MyVME+RmJJWa0gP6ULOaayp4tils3F
 9bJ5yg5CHe4iMI/deFzmC1eYmJmYE4pgQYYk3QJT8e/WLt7qKFXcRauvD92JOk4o2I9COlSNNZ5
 u1dFzhyKQW+n6nl8U56wtTqlbdDoMEY61tx/kMerBGFNqULo/ZTPxolyI1SEJnU7dCx1ktRMITc
 nBvaOyF4YPm/FC51+xCiA4E0DCFP1Qo7wnHUZkoJ10MGPzoXQ98lw60YpRtyGRGlNJnAkzMF4dI
 bghBJ0kJrLY6Yxlt4TQ==
X-Authority-Analysis: v=2.4 cv=YcGwJgRf c=1 sm=1 tr=0 ts=6966f137 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=DIzP5EfeZF5ZH_g1OKgA:9
 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-GUID: LT6ROdx93Dhci4b7rdo6kSgS3PBt8unw
X-Proofpoint-ORIG-GUID: LT6ROdx93Dhci4b7rdo6kSgS3PBt8unw
X-Stat-Signature: 5jisxymsmud4o4poqmac4djn57dek8zq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7CFEE20004
X-Rspam-User: 
X-HE-Tag: 1768354105-736013
X-HE-Meta: U2FsdGVkX1+P0ZPKHrRnWEdK8UPtlcZZbpHV0q8JKM/q9CmDBrBG51jNZSoNXoxS8IMVu8UV7+Q7PwaQIXWG6dWDQvWWkTMZN1BSoZReh+sg0cyCDvxSstmG/E672WfHxtdKYCjdDUZKeQ3B5ZYPf0Fbij/YWM/dytozZH4uIerH/eamzNT89NltVzzHb9vaYTFD0z54GgN2gaPNdcmgVHo12rX/wYIgFFd/fbWD2rh09LDTwgiJ/lJWppQOaFKCERHH/bpg4Eld/w9Ru+IfMzGC1rh6HHjvgW/UqERZY0pRjzDDHZ8QAKhLdD0kxYhJ9TnIeZszq8+ZUAD87tUinkM5dFzt8mCZvpy0y2qZWMMrVJv5WjCyeIDU+eaUgZu/Gj0+O3Z2toMNursILxxCUEfXzZXaqHvBHALYeDkSak2FNu55ATURjwtsGk4ZUwNeH1R4iK4JcvIZmbKTsTCdhQoxrFZXDxIJKBjrXL0YUO2r+h7nu3aQxEhrvl56ZvBzESlLlIxrONkzgbL0cH/VxkvIM5XJWHDr+0HBZUE0GTDv+5NK+4boclANMzRg2hL/ZRDC86mhMNKfLm6rwDNpeGfgdlrzP8kGr5w8BAFKNItfgUefPUyuJaiYy0MUnkX/sVcyDJ5HfZB759fGXUA7p3W5b06Q6Ap2KMUftQnBjES87GNGpd0w4NIzXzLaTdNwateMyQCn/tBq6YsA/7pvyk7kOIRKVlL7K9g/22Jj2ukMaibx6nytiB3gPV/nx5YwdXEVYzCEav5/GjwN2Y7MT9gZP7E5mO1a8FOZmpRR6gidEMczDjF2y7BCgBp5uXsCkSDTSt9kHwwrQaNMaNfHx7c/Vc+jFzYIVQow68peQvDe6BSkr/Y/b5HfPFKLfmvlimsioq0ubUfolpnELVDYzJWymp8pg4/upWG3lbmklcu2jBgevR8KouC46YBoBkwfHzUJaYoOMV5A6wJc5T6
 CULu2C+P
 pL9/N2RjxjVP6RtLQ2a7ZQ52t+kTmsA3K+Du3J5TggWSkHDbQYcFNVLs+/QdshFmY/ueCHnL8d1wFuV3ahYgbpnx+8zhIUtiDTsJUJfGgruZmInOQFjpaZ0uPBcy8Z9z3VrRw2MtN2XNQN0Ats1AJvhi/FrELTIosFrhetnRBr9djJAvtE2BnM5JtQ+rrjcHSlNS4MGXzzvAUT0x+CyekxzjCYE9aRzGcFVOPiQDolX5t9RHUV2//caRF3t9N0Ozz5AQZ89DgGaSo1Zj6oMbS/da/y4doyFRGliQ7bK3Q6wtMHmEfwKPyCTlKA9srGDinewmsO+MscDhKooSQXrF0J8MOUV9/nHGRYXQ68G05xHCunY2j8Dyq3owlGcQpywzOzJV2XylvxZPo+dTrDBE3IH5q6w9RHs6gHVXOy/nZF6v3Kk9uix7dPv1/2W2xerYy1++9JiOsMEGwmqLU+Hk5IZb/MgfZNszs2/QRDA9fylbN6w4IG189lVX5z8+Dz6265Czzwx22idtvCaARkZn6+n2nP4FgEX7uHg8etHlCgvip8Xpzr4XbuzqOx5KaYqrJvDFXnWSmFVbzuLmJVPedkzjnSriXi6QTMFpmwuuCiYPnwkuW2budy+iXFmgQ9OUTpLQINvAElxP4j2PyogIiweelSUCBMgMnhYR8zxTX3zdaGROG3ocD+sze0mo3OfNFsaJGsIjzVNWqPZiKbUMQmUUST8WEpdfmC3wiIn3femNA5P0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:00:18AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
> head:   a4e5702b7bb846cf50d2917cadf2289c25720812
> commit: 1e8eb4117f27366855b192104098330a2f290f26 [9/10] mm/slab: move [__]ksize and slab_ksize() to mm/slub.c
> config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260114/202601140605.GNpnpgLF-lkp@intel.com/config
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140605.GNpnpgLF-lkp@intel.com/reproduce
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601140605.GNpnpgLF-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> Warning: mm/slub.c:7013 function parameter 'objp' not described in 'ksize'
> >> Warning: mm/slub.c:7013 function parameter 'objp' not described in 'ksize'

We moved the comment from __ksize() to ksize(),
but didn't rename @object to @objp.

Could you please fix it locally, Vlastimil?

diff --git a/mm/slub.c b/mm/slub.c
index d3aa805f3e05..373ee58b8b9e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7070,7 +7070,7 @@ static size_t __ksize(const void *object)

 /**
  * ksize -- Report full size of underlying allocation
- * @object: pointer to the object
+ * @objp: pointer to the object
  *
  * This should only be used internally to query the true size of allocations.
  * It is not meant to be a way to discover the usable size of an allocation
@@ -7078,7 +7078,7 @@ static size_t __ksize(const void *object)
  * the originally requested allocation size may trigger KASAN, UBSAN_BOUNDS,
  * and/or FORTIFY_SOURCE.
  *
- * Return: size of the actual memory used by @object in bytes
+ * Return: size of the actual memory used by @objp in bytes
  */
 size_t ksize(const void *objp)
 {

-- 
Cheers,
Harry / Hyeonggon

