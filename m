Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA0AE7315C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B896B00A8; Mon,  2 Feb 2026 06:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625A36B00A9; Mon,  2 Feb 2026 06:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDFE6B00AA; Mon,  2 Feb 2026 06:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5856B00A8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:37:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C4255C488
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:37:30 +0000 (UTC)
X-FDA: 84399316260.24.BCA3C3A
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id AAF4F1C0004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:37:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pR+59zPK;
	spf=pass (imf20.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770032247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXXVqLFZzMvuIG8fUgLlO6oXpxs490K5Ahb+VJfzGgQ=;
	b=cDzOlDPmx8pvbHApkJ4pYhpAkkBoWobieZEt0e4p5wzgGD67MlhieDH9nsGDGq6BQhKTYL
	gL1AtNm/QmGw6WvtAj9eK1fLqgaOGyCFyn0Voj5wZmrScunDIdA63TXZIMw5XI4X4x7QBT
	SkXozOGAYDvPiL/SuYVCiSuiQ3dZnfM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pR+59zPK;
	spf=pass (imf20.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770032247; a=rsa-sha256;
	cv=pass;
	b=BlZ3SsQF50AJCG/1rA3Dd0Bl7BTkFqYfsraf/7OF8tKP0TMcmJuYVN9Q7biF8vJMsm3FG6
	MQaMdB6D8FZ+blvrIdoKZAfp/ymOwsiiB9LvfTWgsDk/le7zZy7Cxwi3Kzg1KsvObNUflP
	h26orDS5C3dyIdn/1ajR08r/6iuUa2A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kdh+67dhSXySSGQkBkFKjlL9Uce6bCo1ZJf/+AsM8CjFcAN/pP0solgdZV7kh1bjPuuUZXsXkEjhs7YTnRqvEOrZKdN0IXS+tVJKnnXSnEbj2y6kundwQQHd285x565aLoGzt9lCXRBHgGH48CfllmIipjDUA6yxjEqsRNaxsoTXEQ+9SMshq6vYYfBD/33B5MWQhPTZQMlTTnjY1n+af7rW+kdQ05I22TWqtkZoPHCl1n96DL1pYqnvFwPjrmxg5CbRDxUtHYhldw5rfhQb8tWwZvkpYurR8qUM1P0fcF+rIDCHfrqEqCYB8YpnSNEYoLIcjs9wWAu75dIhZ7imxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXXVqLFZzMvuIG8fUgLlO6oXpxs490K5Ahb+VJfzGgQ=;
 b=y8KiVElrLz06Z7CpEdWQNNXBOPc3RxVRCQcHoXDxRece/mLhzIZJ6kHw7/5eAxHNtQatS0/GI4IXvZZhuEn1wjIS9Y2QP3lWAdNowX+KMAUui4G5UovR9stjIaJX2qkIsKpi9Na7Y38HwzAmV+01Ug8Wyd39c+YOYA30Y43FdyIKoaXFdGub5lq5xXZ6MPG0u2fJ1e8WyvPtHcam2SyXIjiNQm+Q9AfwHWekauU6fS8H/s+/zFzO44+vPs77U845ulPgExNXdwtRyNQgQ1CAyXPhH7Wxy55YVWXDz4UxD9hqYPd+3BMDbthuVcR9Zduw4spug3orldW7Lf8J2R4dbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXXVqLFZzMvuIG8fUgLlO6oXpxs490K5Ahb+VJfzGgQ=;
 b=pR+59zPKFFphKGkEKNL9Ts/M6nDsJdKGHoVrXTKXlvJ5Fqm0x9orvyiKYcK2svGA5ruXdORXnDds9KQYR05d8bev6k0SPakIC2k1QMVnPpFXwPGkUzM4V4up31gbVEr7KfpRepvmQHDklSSZ9q6hkN2+KCRuIsv4gfXKghsl14qs30Zk4xO38roYHAeLIyD3KFnazxj/y2/cU3/ATa1m0AqBqGNPfE+sVp/9NhPbD0s4k72C2+PFe4AkAV/ms+QkIXHo3/2v4zL93Z5ncAcMgVMJn25YDPk813FpOKemQM5mAbU+3MDMitOZdbSCju4smZX3yDIBH+TyYSaionVJLQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9758.namprd12.prod.outlook.com (2603:10b6:408:2bd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 11:36:50 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 11:36:50 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	ying.huang@linux.alibaba.com
Subject: [PATCH v6 01/13] mm/migrate_device: Introduce migrate_pfn_from_page() helper
Date: Mon,  2 Feb 2026 22:36:30 +1100
Message-Id: <20260202113642.59295-2-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260202113642.59295-1-jniethe@nvidia.com>
References: <20260202113642.59295-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:a03:505::8) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9758:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ba07c36-b260-4072-a923-08de624f5ae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ezcHg+i6R6dPOyR5GD7MNoVqEFKy+6PXSucQBILGzBJn2LVfvUDSw6PCN6pu?=
 =?us-ascii?Q?aT8IM9Gv6PHDdDzG29NL6tvZxMXxGWhws5dLr78L4mWpJy6VZYULMZmZANJp?=
 =?us-ascii?Q?HUZQxnYE1/jqKJljUQGoE2crBSL9AimSfAAEZqR21obKWfz8+ErP5NdTIwaE?=
 =?us-ascii?Q?ScrLn5b0I0g6ebzkWIEeZHNAZPlhn81aa5jFuXN435W+yazBetFR3qmQqble?=
 =?us-ascii?Q?L850GkNOl3dG/VLV4Q1svyKEyfsjaOYI98OEyWVnq/K+5Ayt99H2mJia2/uK?=
 =?us-ascii?Q?0kehhj9KQWkosIvYynolgB4z9nGhm+WFFxd6mkt9jGKHkKfowO9MA/VrZnPP?=
 =?us-ascii?Q?ZAZjqLpc82M3503p0ydGnBm8/gJzsirzNWhANdmu8QghUpZOocFUW7hoWnOV?=
 =?us-ascii?Q?tPRQTKND20Y/nOSzzWxAaPEfuc2Fqi7ol/4eG83WBCpq7SYKcK1ZroXIJ8rL?=
 =?us-ascii?Q?pMdCNBbPAnrL5vIps/nXEBPwPJsXiaTbhlOQOyLHe7urq8uQeQ8R31v7JIdU?=
 =?us-ascii?Q?JGz0muVEPEQdLYyrrC2o9nLoLyFiUSgP5hK7QcpXKvJZ8ghdX6Tt+Z9jeUFt?=
 =?us-ascii?Q?Xc6PrPUa5137Eyh6d7G7w227Wi24n1wT+8h2E9CBru2uh7I3CPE2T5KET9tH?=
 =?us-ascii?Q?E/QAVuZX6B5D8Y8YfGiw0+B6lOmXOMRNJoJO8pE7fm//T7pvTC4/Fvj0nvOS?=
 =?us-ascii?Q?WgMV37VFWFYzcksAkJ27ZZL44qsxiVT96DnFwot5xB2wn/0YNfd4n0eQvCPf?=
 =?us-ascii?Q?opkzaQljZHqBVGK8ikCcbzmdQyEwLSEJd5f9qpgCNzjHQrEWKXkJKUgApipN?=
 =?us-ascii?Q?d/5HVfZ/Q9lIpOgEJhzNfbgGkfixaj27KHodRby6n6TNZcp2kpIzvhz4/5vY?=
 =?us-ascii?Q?XDIeviS3+8RwFcflwdiuD9kdVoWrPoAniY/q+hOp/cmoUxqNMVFFmqYoOMc1?=
 =?us-ascii?Q?rp5ZQv5UL3w+HCp+qAsPYzRFWIvMxUTQfL96Fj/UXCQksdNsESrpRJxOvHkz?=
 =?us-ascii?Q?SdlpASQ2HFZ7qxeoj68mETS+4/h6kz0kwfBhZx2qdVFhGbshfgC/8+0YNvQj?=
 =?us-ascii?Q?/cpUtn/ZSpl4uZNNPz8MQcXY0DWUS2j0x79ltdx+VHGLX8UfJbEsC+4ZKrOP?=
 =?us-ascii?Q?Vr2TVDUckcNZ3YBnslCYG2Fie5yo08seobDPvOUu+3Hj5OeK1b4xrlJkQGR3?=
 =?us-ascii?Q?nPJ9XikwUkiQf0bygxpRwVLboc/79zGTI9id6up9ZI3lR4OOUwZPmSfqjX+Q?=
 =?us-ascii?Q?a2zWG3LxU2l0e1JBw1kmc8Fsb7bha3jGKaGGpxE+w294h0mUniZSv4+auwRG?=
 =?us-ascii?Q?zZ+ZO4fEOCIlptdyC0AjkgJKVWwaW3SPEKIuTwGlvnloCCsWXeGDl0SFlsIu?=
 =?us-ascii?Q?l0IMghPCZHhlxALIzOMlat35oCqJBfXUhc3G+/EfzYqqLiHcLxUpyKiGDj+J?=
 =?us-ascii?Q?g1QtsGn/AbyTZBBbFoxwnUZ+Xh84GPaPPBD/E5purXsVHQGjlzdPm8CDeLG0?=
 =?us-ascii?Q?FvJStRhHCluBykIz/i9E8ar94OTpaq8CmehYq8xaTPMMSpQl9RGOTLtKZPn9?=
 =?us-ascii?Q?pcdUJS+VbeMmCgJn+20=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E05bGWI3xoPtzqO4YCjXmMROMO5TmrfVaJfsKsq8LELDwDHvbWT0TZxsGClC?=
 =?us-ascii?Q?0xFIDJbxG2BpH3P+61n5AjQ9/RKuUtzfsvukMPPI1wIhl6EcSZ+c63DUyqPZ?=
 =?us-ascii?Q?DsDpP1uSC6OKJz78ACo6/xRa5v2aRBjcu2x/6JRCtUIdwBRztbz9cH+L1WSa?=
 =?us-ascii?Q?jjeM/euZbQsEk+nt6zy9Bmaxwv606P1SEjHiQCIqlL3b9uP4e8SwGRHK0UO5?=
 =?us-ascii?Q?dSXEVhihSo5pHQ676r/E+uQ6EwFRsGoDFjBl/zJGNy+WRux/ywT43x3pyVBz?=
 =?us-ascii?Q?D61j2MzI3hg7q2WK8OFTQ7S1UdaZPN7+fmDqLhsr4Vw4zktrFoMA7d29H95U?=
 =?us-ascii?Q?IVWvRaPEo0D8YOHdnVBDvosL4iqJ2IBn5XRa7s2SJi+chplEFunDtvBN4O5F?=
 =?us-ascii?Q?uBtD1B4LS1YJJ60yBr4ud99jx7XMM24kFciHnUHCSRycUG0M378iP1atmaIJ?=
 =?us-ascii?Q?IvmxvVGbi4EaHpLm+ShK9V5z6MAmcs1Ms3UtelmcI0IT/1l3WcnHmPAy5dtB?=
 =?us-ascii?Q?9h6G2bl0eAZhxWuWfe+NwUtcrY1f1/TjMd8Obb9kQa3buJvtESi1vKSg1EFb?=
 =?us-ascii?Q?ceU6HwtyLR2UW2m21fKC4E/V/KmVeTND0oRDVjljCd2gNI8VDa4ENH5x0Biw?=
 =?us-ascii?Q?Gu7gB1bxSpX/pTqbEKb56eQBxC4QRWPJAwqJmnzcN+erSBGHxJ0NS4ewbw1n?=
 =?us-ascii?Q?brz9PnQM46YK1PYtFp849/xDm/ikC0yvZ1ntMjsmKvfNiRwM0mOv1LNjz26i?=
 =?us-ascii?Q?EhW5XdJ62QRJhDelVKy5hbUpTEDhtc/Yw/bBBeZNKs8+xMosv8sWCBX5XfLN?=
 =?us-ascii?Q?hBpwqA+LZJtohpM8aNYrS9HzUXN6P6s7Apjm6L/R30DpA2nYS+gxkRHz7riz?=
 =?us-ascii?Q?aJJnv+VNHSwxALZXEvfRs+Qpwb8zPbz3gSVSP4evpklhg/Hot+fVfj/n7t5b?=
 =?us-ascii?Q?e5yeA5CfEvPWoHu6Qq2xf6Tp/S9PpYfPis2zfqtrslEKXUaPpYC8LQ0dF1+D?=
 =?us-ascii?Q?JXFEB851+yCi5qOhvTnR6BeYKIt+uhLm0yyYx1a0FzetBk81ladFEUJ80zRk?=
 =?us-ascii?Q?muJH9W9rgL/4T/QM27jG2rqNWzTJCGmOxXucoDRfBrOvk2ed4qxakNgI0GKg?=
 =?us-ascii?Q?L8vhOkILSFBA43IUopkP8cLDb4jQ58fvca0hMn39ziEgquSaB2Debzq7tsO5?=
 =?us-ascii?Q?zb6fGi339SL3m9cz4xNnAJj4o7VLLOU5b1VhRqRF2EdNa6gt+eNHdf92zCRv?=
 =?us-ascii?Q?HbaIt1MMPCX+iHocVMyR0LcAou87DC249IcA2hgW20Z822Php/t2wx33jJA5?=
 =?us-ascii?Q?z8+pNOvXHrgGhG8GEgAehLd3meuZ3FzV6wl+1witNKqzF7xjyCsO238yPIfv?=
 =?us-ascii?Q?Pbwk2Xbavbq36fAdWziXN+D+UiSJEBPeE73jlGoZzqAJiSmtjzucWj8ML4nx?=
 =?us-ascii?Q?Mcv0IpMtEEICZC008gkzyRGdkJzMELHLptaMg7Ct1ObLNMI38WBOFul94yUB?=
 =?us-ascii?Q?pj5KE1R/BmXSeU+ADHG+srIGNdAsKljqLbXzWi1va1QLa2BoXL7nOKY7K/0K?=
 =?us-ascii?Q?cZGvH3uz1vexlEP0raF/C2zPSai772pZIjSlJuOWaiMeitxeqe5i2HReUGB/?=
 =?us-ascii?Q?qOPtM1SczKcX8GLdi/aCicXQ+i2MwFphUiu4fLx7FcgLKUuAJ7mr1hv4gPhL?=
 =?us-ascii?Q?Q9Vw5htBKia6AzKxg6IQz0AzfLN/mWxIleeQ5dZFacN3kMMKkxWj5vHWETnv?=
 =?us-ascii?Q?a3e3VVvbfg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba07c36-b260-4072-a923-08de624f5ae0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:36:50.1365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FB/+1fzxEeWvwt0A3gnL6vLBEZov1wgBUB93PeiW6oUvHLt6V3T/r7cq4e59niJsoH5Sio6UO8JucSAeSpEHSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9758
X-Rspamd-Server: rspam12
X-Stat-Signature: 5id9ftix17odxriwsapo9sqa9cxpujki
X-Rspamd-Queue-Id: AAF4F1C0004
X-Rspam-User: 
X-HE-Tag: 1770032247-499157
X-HE-Meta: U2FsdGVkX1+DLeaBAmM2zILLtkWApjdP2vue/aPO4tIPdKIoXFuN1HL3nCuOgWyAPzRXJm2sX4w3Thwdlofr9816RnEW1YxkLX6/Cf6B3Pz1cbGMl7vjLvGKlRRT24iy3mQu887kq6mY+kZo2GIVhpiCX1GR73U9ZH4BP+m42bdFtsOrESzCZuXY4TvR3e1jp4kEfdAvuBjwzQm/uFYgYiZw04yKyQTVmUTO9cB7wSVv/GgNr3W1PC83q4kR4+gVewWlN5tdvkq71zgu3DmHpNVi498Nc4l8a6RnhNBd1YtFpdAbdmM5NcqY5qhXCTnFokHFtYHTRan+echTPn3MA/PZ24Q+1Fd6K5f02LPOknGgEazdaa9ZBwm4doZf8oH3aB8ltIyesHaqBgmKWuQm2BFYruEbCJDbbsWzICDwZXzmJv2Mb7vCDFq/jbMMd8jYyc8xSqjoW13v7gaeQXxlMEg10n3PullxRS1WGfXp+VJzlx6wASz7ikj/W9eTqTrLvNdf5vhhZPFmk8mrcnd6wHrhgAQPmSD2xlCYhIMxLrlSNM/0XaD6A+1lBqnHUbB19w1sM0bCC3KIc1xN9ESOHKnUSBp3kH8pRhl9NaiXQOs7A+zLcVor7423XTHPAIP5X52J60MY8SY368uCpZXi1Cd0sET1625IIGIe/chtKRrnWuZMKuA/eSwP65ghhNbpcqQ5YY/1Fqtzbl0w0+Ojy55B0J7xfdsCi4l+v3m2CkrXhLzAgqwVGSJc6N+6m7gA+7B+H9BbXhD7sa4Xd996Cy7djgoTGvKUZZ3eWx9CvIj1v4soBQdWmvAfWbboy7lCGZcJOs4ajuACnW8D5RuZKxxDmgJeAPDuJWzYkFZHwGfsg9LWkNH9bql5Rj0fyQPqznbhdllax1AtRGfmBGSHfj7AXFmoyJGARHgO33dJenYkbMEJu1hW3fFRZDS3uE0YAHI/OFIh4xf6tw7PazI
 DfFVziSv
 t7oqQyADRxmSluniFqedrgGt8wbLropRhXI/klpkEJjgDiRFKKLOrQLDXaW16De83GNxrTHCKHmiSG6T2gde17eh1PFjwY4XvWlCgPZx+8VsUZsmn/dGsfit6H/zgsnxQiYqZscZm0bKp1Y+XaBg29PbdoVH4TcQju2I3+VljvWfg5yFHjA3/qtx15W7oNbWnlP4LrPfxrYEfRMojxzlg59AUxHRV6u0Aw4EDcXKNPhBmMGqCjhkfBRpYryTvHb/16myJoOTrJSG10x0H8dyy4tQHWLgQF1i96YMtyra6TD4Or/QUOmxk7hbR8UBk1G3gGvZ4y6otaypzKlLxYoQAavzRvxG7WnPvF6JKG1Csegl70tAT9pIpEGWhDN1Vz9KTOlmKGjNipIuU9rWOZmeQ8jbREEQsz5TQfm+WqakHPCr9taYB2k2j3DpIAhH3+S4naNVW7xpcEkfsz0jPDGn//aFOZuz75mow984Fr7ys6muoEBUqSEvv2n8wpURaemd60IPECIulq42/mbnd+6BI2yAaJu6bL+eYgVoP8PA3em+zPte5DLQsz3BcBuevEDCvkXWfdmdcrr+Jjj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To create a migrate entry from a given struct page, that page is first
converted to its pfn, before passing the pfn to migrate_pfn().

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn and must be handled separately.

Prepare for this with a new helper:

    - migrate_pfn_from_page()

This helper takes a struct page as parameter instead of a pfn. This will
allow more flexibility for handling the mpfn differently for device
private pages.

Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v2: New to series
v3: No change
---
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
 drivers/gpu/drm/drm_pagemap.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  4 ++--
 include/linux/migrate.h                  |  5 +++++
 lib/test_hmm.c                           | 11 ++++++-----
 mm/migrate_device.c                      |  7 +++----
 7 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 7cf9310de0ec..47abc220ae03 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -784,7 +784,7 @@ static int kvmppc_svm_page_in(struct vm_area_struct *vma,
 		}
 	}
 
-	*mig.dst = migrate_pfn(page_to_pfn(dpage));
+	*mig.dst = migrate_pfn_from_page(dpage);
 	migrate_vma_pages(&mig);
 out_finalize:
 	migrate_vma_finalize(&mig);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index b021f1e56114..297fa108ccf9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -652,7 +652,7 @@ svm_migrate_copy_to_ram(struct amdgpu_device *adev, struct svm_range *prange,
 		pr_debug_ratelimited("dma mapping dst to 0x%llx, pfn 0x%lx\n",
 				     dst[i] >> PAGE_SHIFT, page_to_pfn(dpage));
 
-		migrate->dst[i] = migrate_pfn(page_to_pfn(dpage));
+		migrate->dst[i] = migrate_pfn_from_page(dpage);
 		j++;
 	}
 
diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 38eca94f01a1..f5e76c75e609 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -742,7 +742,7 @@ static int drm_pagemap_migrate_populate_ram_pfn(struct vm_area_struct *vas,
 			goto free_pages;
 
 		page = folio_page(folio, 0);
-		mpfn[i] = migrate_pfn(page_to_pfn(page));
+		mpfn[i] = migrate_pfn_from_page(page);
 
 next:
 		if (page)
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 3d8031296eed..3448e27bd42f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -249,7 +249,7 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 		goto done;
 	}
 
-	args.dst[0] = migrate_pfn(page_to_pfn(dpage));
+	args.dst[0] = migrate_pfn_from_page(dpage);
 	if (order)
 		args.dst[0] |= MIGRATE_PFN_COMPOUND;
 	dfolio = page_folio(dpage);
@@ -766,7 +766,7 @@ static unsigned long nouveau_dmem_migrate_copy_one(struct nouveau_drm *drm,
 		((paddr >> PAGE_SHIFT) << NVIF_VMM_PFNMAP_V0_ADDR_SHIFT);
 	if (src & MIGRATE_PFN_WRITE)
 		*pfn |= NVIF_VMM_PFNMAP_V0_W;
-	mpfn = migrate_pfn(page_to_pfn(dpage));
+	mpfn = migrate_pfn_from_page(dpage);
 	if (folio_order(page_folio(dpage)))
 		mpfn |= MIGRATE_PFN_COMPOUND;
 	return mpfn;
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 26ca00c325d9..d269ec1400be 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -140,6 +140,11 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
+static inline unsigned long migrate_pfn_from_page(struct page *page)
+{
+	return migrate_pfn(page_to_pfn(page));
+}
+
 enum migrate_vma_direction {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 455a6862ae50..0cc3ba9b0502 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -729,7 +729,8 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
 				rpage = BACKING_PAGE(dpage);
 				rpage->zone_device_data = dmirror;
 
-				*dst = migrate_pfn(page_to_pfn(dpage)) | write;
+				*dst = migrate_pfn_from_page(dpage) |
+				       write;
 				src_page = pfn_to_page(spfn + i);
 
 				if (spage)
@@ -756,7 +757,7 @@ static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
 		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
 			 page_to_pfn(spage), page_to_pfn(dpage));
 
-		*dst = migrate_pfn(page_to_pfn(dpage)) | write;
+		*dst = migrate_pfn_from_page(dpage) | write;
 
 		if (is_large) {
 			int i;
@@ -991,7 +992,7 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 
 		if (dpage) {
 			lock_page(dpage);
-			*dst |= migrate_pfn(page_to_pfn(dpage));
+			*dst |= migrate_pfn_from_page(dpage);
 		}
 
 		for (i = 0; i < (1 << order); i++) {
@@ -1002,7 +1003,7 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
 				lock_page(dpage);
-				dst[i] = migrate_pfn(page_to_pfn(dpage));
+				dst[i] = migrate_pfn_from_page(dpage);
 				dst_page = pfn_to_page(page_to_pfn(dpage));
 				dpage = NULL; /* For the next iteration */
 			} else {
@@ -1414,7 +1415,7 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
 
 		/* TODO Support splitting here */
 		lock_page(dpage);
-		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
+		dst_pfns[i] = migrate_pfn_from_page(dpage);
 		if (src_pfns[i] & MIGRATE_PFN_WRITE)
 			dst_pfns[i] |= MIGRATE_PFN_WRITE;
 		if (order)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 23379663b1e1..1a2067f830da 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -207,9 +207,8 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 			.vma = walk->vma,
 		};
 
-		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
-
-		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
+		migrate->src[migrate->npages] = migrate_pfn_from_page(folio_page(folio, 0))
+						| write
 						| MIGRATE_PFN_MIGRATE
 						| MIGRATE_PFN_COMPOUND;
 		migrate->dst[migrate->npages++] = 0;
@@ -328,7 +327,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				goto again;
 			}
 
-			mpfn = migrate_pfn(page_to_pfn(page)) |
+			mpfn = migrate_pfn_from_page(page) |
 					MIGRATE_PFN_MIGRATE;
 			if (softleaf_is_device_private_write(entry))
 				mpfn |= MIGRATE_PFN_WRITE;
-- 
2.34.1


