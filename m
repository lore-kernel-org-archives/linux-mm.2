Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89BDAFCD0A5
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 04:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B2F6B00E2; Wed, 18 Mar 2026 00:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BBA6B00E3; Wed, 18 Mar 2026 00:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413A36B00E4; Wed, 18 Mar 2026 00:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD216B00E2
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:11:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C642B1404B5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:11:29 +0000 (UTC)
X-FDA: 84557859498.05.EF29F76
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 36CB180005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:11:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qw2cYyht;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EIgf8fCJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773807086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7swa0tYJHOsVNIUTPS6EeYUIRVfH0uqpqjSeNRhWXE=;
	b=u9GnL4BmX+tV/GFHIPwa5hl5mZDkZ/YuksUo5J3N/s4Vz0VmeBKCL0NT9vBPEke8E27NTR
	lnHgDS7tsMnQwJlGnooNm0Ix6yYFU20Y13pQnFYFddnw2SPA3OzS45CSzKthgV5aCXz5CU
	o8Z0r1VZDP0a/U4TmoCim8i7Vwe7ltU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qw2cYyht;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EIgf8fCJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773807086; a=rsa-sha256;
	cv=pass;
	b=hhnr20zCrw7DcC/B63oYz0ioreGDpiNYk2aawuOUhH1OXieJKKqdi1ySCI5wbPB3qnsvQn
	ALGBdHGJBUZd7FZdYWBgqXk1SKgtnFH3qVBBIf6b4wSw/JMCM/Qxt5XWdj0FW6XH/PXk3i
	Gx3Ozi0yWYi57Lc3SCkeGIJbSCuFLa0=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I2NW9M1776835;
	Wed, 18 Mar 2026 04:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l7swa0tYJHOsVNIUTP
	S6EeYUIRVfH0uqpqjSeNRhWXE=; b=qw2cYyhthcOOnsMI51Xn7O1p9FKKTysr0e
	yh8Rkxjf9cFM4IvnLR91Qgye9C+UadbTpgpIcJyLB2nU+RAtbmFdDzl29yyAdUXS
	JIDuCRXqA35duLOWZUuwv1KjXUNCvaQIuEI93rzV4guBQzAWP3bGo25Ih0avbuqO
	Hg4797aIodMD78B7dGQShmB7NrGHQFkpNruyrmD3oJdV7FkhcTWbWhgCOnpYPKd4
	mdTzsR2Qbs3HgITTKA0aB6IZqd30ZhCiqt7s0/koPVtIYlu3TC2Rx1KwWJ/6Qbkh
	7y7erUdYE2XjhFX8vhtRb/qkfC4RNUflnJV5zTBqeaE0VP2DumLQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxk8devs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 04:11:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62I17KU9003496;
	Wed, 18 Mar 2026 04:11:05 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4b2fs7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 04:11:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=okUUhiCaL05/+Tp+mTG1cnv/Y2YlqbMrF3730kp02w6c2dnpXSKgn6/ELm+4+B7WBMWjJU/7rkPnSK6E87BaUL1N98vRszxr68TNhOllr00TiKtEIbv+EQgqrTJhgjf4Xn76b7Xejz2bgYEvvA3pwMVkLxz3X7Irdikr+Tu0ITMtQxViGT3BB8AvVNTP2FvMw+eZb7cyltkx9XUFygHLHDWvfGoPmUMkbIdwDJGQzZAhti6axLoiCwGLu1dcx+QBRJPeEMDHDEO/rd/aFogtT5Q0j6c7cMFuD6IopyBFe34z7bjYWHaZhBDtH8Vd5bLHvSAamCLd1RGeF6a3bPqZ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7swa0tYJHOsVNIUTPS6EeYUIRVfH0uqpqjSeNRhWXE=;
 b=P7mp7+sLn8uZtsimAZUlDrI/nOwxQbGvg2hkjeOnDKlxlUe68GLozWMW5PgJOx3upZLMJ3Jw5GrieFWm1eeogM3wkh4Ojnjus3JH6hZsiFk2CBqGJmJKOZ6ICOJzH0itlq6ZQzTTm+vR++SgworcOqiclV9OiqtqMmopF/CrSbtOqRJrXSNmw/xP3eYVAdMCZE+rhWBLsGz+5aijdpIjH+Ma2bqzVyCQhfEa4ZalCoBcbE5+6XiJv7dsuAaxZl1++10DWT3Y30qsx8EFngg26/bEq0XdKSWq0yZPuDzsLwTn72+hsrJdFk1NVBvVFyK93sV3FvyWeEEj3uIIHriPiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7swa0tYJHOsVNIUTPS6EeYUIRVfH0uqpqjSeNRhWXE=;
 b=EIgf8fCJHNBKoDTbRfQwGkh2HEi0NvL8PRv/663HH3yC1wJfbSrEIDT6ZM3VwCYAbJJH6PxRzJtZNhnsS2zy18eZD6jYHIeL276TZR9fCtDfV1Nd48uBQ/GVgcBX6RM4/uRWGMiJVwzi90JDBNI4UKofTmyhgopxvrCNLY9r4C8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5659.namprd10.prod.outlook.com (2603:10b6:510:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Wed, 18 Mar
 2026 04:11:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 04:11:01 +0000
Date: Wed, 18 Mar 2026 13:10:48 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, chao@kernel.org,
        hao.li@linux.dev, jaegeuk@kernel.org, jannh@google.com,
        liam.howlett@oracle.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@kernel.org, vbabka@suse.cz,
        wangqing7171@gmail.com
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <abolyGbAyynUANDB@hyeyoo>
References: <aa-1-Y3v3D1hzPvL@hyeyoo>
 <69afba32.a00a0220.d013.0002.GAE@google.com>
 <aa_R-6SdHYBBkQX-@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa_R-6SdHYBBkQX-@hyeyoo>
X-ClientProxiedBy: SL2PR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:100:55::31) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: e8334ed4-dfe9-4ac4-f5a8-08de84a45d47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/fwrQ+jjqDzuG3ao0MxA8icgRQ5x8hPsAnZcZDpNbttquqS/zkE6spqdILlf/W9BI+FSOhpJsBHGO3bL3/2S6vL3vn2OZXiugZJuf5hXcneQDGBkj0AQoAQnODWJrldDsBSAS6uHov4pVtFCSu6AAqqeMtK8HAg+Ty6CO1t6mUOgSBxeGL3HByEtqdmwYK356vDPnSl9BXfwF6lruaD/jTU6CvTZzb3btRN9oTn9ymF0Z0eKPF+k0wc9DDycKhpDi7acrC8X7TqzFoxFy1HZSFwY/KZBM8hV977wFbBhThkJtEWZX4RVErGUZl4A/p6mPXJWd8xqVWB+L4i3kv1qictbwKs/lJRNeNlBZTazSCDKChD+pM9bgW5ZqWt6VzA556oIbe+vWoe4IS6HnN8F67yUiOV9C8yrig3O3RM0DT9G0maXkqIHhzAykP2MH2SoyiIZT//ODjf6s8ik7Q7G651HPjLgpXa/0hfyMi/K6irB1S5GE2DBkxd2CJQQ+YcHCNw3rKm/U/BAt4R9Sd9yv0PwrROiJ8R1zLsikDsgH5Z7BlyhWe7MNxIo6zVdYOkCD4nZTtjJBtldzMVMqvHPfF0Q2AI59vCbI1MEkOMlWL4SUZedi4BI3IlBRbU1oXYfH2DFg/zVkJMZXMKB1qHEgPjtn2KLSzGUOaA6dHdFRzwqRVAT8fhSX+xvT05eKeefejXe/HnOMF7dg0Kj6TSPpolN4D4bORiYQre3sNxs9Kw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GP+q5PyRB7nbPVS9yzfI/hJ/NXX9PyVryPG4YOI54PH+/TLnEMF1Ei1xRftG?=
 =?us-ascii?Q?b5fTMzuYDwtLl8ohNXMRBcl5Abqw2F/LwDFKI/R1SZRgKfoVmJgJuEdSSxGS?=
 =?us-ascii?Q?nlRRJcP+oLHIVQSjXj9R6KFXnUfg0HvFpUljZMIhvXb3p4zN6RZxhifH0WML?=
 =?us-ascii?Q?YpnkvkXe0l5uKdecy4JLl2X2DqoHy1tBzcQpLY9tE1chaL28L0FuoTGV/txD?=
 =?us-ascii?Q?6m8OWUm/8UdzZzNRKnDmqRBJkq9+ViIv4bgmREIWiTw4wo6Qy+wIe0ZphXoB?=
 =?us-ascii?Q?KZtZSQ8Zyl+rTNWqgpoV9g7ZpZbDxACaqleST/yI4nzJkj30mUkhzuivrzj+?=
 =?us-ascii?Q?3WknlspRyozdWs6izBfmXhhil16IUvfxgWevXFrzn/YEjvT/zm39CTSTDKYp?=
 =?us-ascii?Q?4I6wY9NmZ0q13RR3OFTSyNCUOPcWZnwqqDvLWWIXHyXY2qY0OfK3BfRWeX7K?=
 =?us-ascii?Q?0FBPCC5PYPmSGciXvgLjQaTnatAGwHvoTrEWDSX2o8Xv/VkKG5nXdGPOXdyD?=
 =?us-ascii?Q?/j6rW7FGLpCAn10TeOMqss1POtO4Ju7vL6KTMLAeAHG7imJzFvZFcBDVaFx+?=
 =?us-ascii?Q?6pYHTGozce7TI2yKScHJF7RsDMFb2RXlAp09pyGy7UOXKfVANG1GS292WFs7?=
 =?us-ascii?Q?etTDiwL893byZCYlWPrbo4ZCL5xgxtwFSf4V22XJek/lsrgCYTlzAu59bfxH?=
 =?us-ascii?Q?6xQcz8rrNyXOMTxVItCOK+MO8D8ognJHm6QlBOXgf22kD7KmJ9RMomBa1GPM?=
 =?us-ascii?Q?he8JBuP+9xnrIUSBY0XevbXzUlsdd3S2TPEHKJd8QV0F+RVco+X1CZIMwyYO?=
 =?us-ascii?Q?nuiq+/0onzL/+9nJL+a3CoTOmiYY44P//IWCt1b3Sm/JiaFxMOEKk+9sJN9b?=
 =?us-ascii?Q?mYV2I5pEDMycTpmY3msF+xNQS9b3ObB32wwbtVQudp2+QsJHLNi0DG/xJJmh?=
 =?us-ascii?Q?giDMFNtHWPWamZyNcMChj8r6vaxEYuESAd65kNJyFzmhTSWdyNpJLWC4B7J6?=
 =?us-ascii?Q?fl4Xiuw6VpfSeEAhEHaQHpD9k4Mw8JTy4fvJPSQ7x5AU+F1LQAlYOJiG4lj1?=
 =?us-ascii?Q?bb8SLV9DSxBgi3/0RZ0pgGo/ltk204rAybdmgagEfRYL7fPRJN8rsYPK+SlY?=
 =?us-ascii?Q?GH0FUwaQI8xpLopCM2N0Kuu9tev5G3U5lDBXbkhv/BEYfWArOJ+of3MqWVas?=
 =?us-ascii?Q?7G9D7twM6Ihqs02kENj0GnIzdmxCd/mv3B2HuKCI+PKDVaNTM/pyJMX5La4t?=
 =?us-ascii?Q?A6VvNYJ/0UbMMoONVex6wqm4l1iLeSGPavdKUgF+yrVD96tFmYC4VryDT7Mw?=
 =?us-ascii?Q?6cRSF2Xq2WdOpXi7TZEy3aIQUGP9PdNI0H5KB1wHlUs1Zev7IyADyjqoES1D?=
 =?us-ascii?Q?yDM/GlZrs5NHWsxIXuDVIQVYHW0nkZQ0BW+sh08DGRj9ClITCDr5xQgDA1e2?=
 =?us-ascii?Q?6V5l73pzYienDAXJkQCCwmNhLxuYGld2dooivRPp9HiahIi5FH33VHsvgqux?=
 =?us-ascii?Q?Emkn4dXkTR5mMVLNWXaOqb1UHyh5oPxksCPympao1RJpJ1Jxf6e6K+PuHIzn?=
 =?us-ascii?Q?4Dp6LWaFY7FERiwSErx3fW5TibUajghS7EUtYFSNl2k4OwObd41b6EeuL3Tw?=
 =?us-ascii?Q?iS4Lb4DnnmlSHjdmXQik4BybzLZBCLpAbHY5QMax71+WkTubu2ZacJwpmuTx?=
 =?us-ascii?Q?kgIR3JfVjOdmBIfiZl91fFBCFw7457u97e8csqIeOzL2iM4K7gxykJO5nOH1?=
 =?us-ascii?Q?qE/Suc2c7g=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Xc420Qrn7jglw0QYGr4NWUiKyDCVwBacK0Clir3HPXM5Hnh1WhjmQ/JH2x3soaoGG5YKkPcHgvSX3vv8Hwi6jFofTMcQ2OERStfE8k27pmddP4AmUxp5LWPkQJ4iPGyY024gLT88IcgGz4vnzttNynruyUJEBGJWp9XxwyZlovmfuitRK7ij6++M8XZ0vhxLOTV7aQDY4wjbq0rbsiljfdClZtKUZGvwBWtBJ8zg+SFlV7bLgasufxWpP0+8J7ayFduQFS0KN3n0LNA5fiMyIbAVlqtR5T9np3I/VShnqdHcn+pVcE61EDgp1el3HjjgzP7U6mpDXYd31R1ieuRA+w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q+xc9YXR5N1LzALxPg5/HPktZaNGgU0ZTmcr10GQw1oJ4yHec43yI6WOmHzdl/hrZiP0K/oHx/vtqbyaT7yyRw/4/HN961SwC4EAwrUMIRo30gN0upBdxyg6Szk8h8UExKuProVFZB3zsc58nwwDvtWmaM3NOtU8R0IVv4eKSxUh40lBWDjccgLBYi0pfcKjnLMmvttoWnAQRtNjDch9inpMYyvcc8ufhyEptIx3uLNOpwJXxVnVgrX/qEaT/IcrkqBC+6eWz12bZjWUgQyQjzGOoB0ZZCyo46pGyEVZTckd15rNBgRbVby//tzHsVBqtAS9XJEhrOX04mI40PwsMSII+5w7V1eZ0E9T+5GQ7bjBgakoZDa4LPmGlutZgdHRl64DpFqlDUFHDr+CM3E2nB5ozAXBtumtYvCgHF/VolsyH1kijpfcFrblgWMzBhbQtWlN7P11CXB+eZmyVCVI+SmHZ+RWcZaKp2z/4RQgc1l4mUgtws+VIVvQ3IxIzoqkxwc7zktP8telsox8Pt8DZpJxOZJb7baKkbSI9QLLXrrQ1cpawvn4zQYxtyt1ONVRj/ZcslXRK8PHnsb3sQiY7ubV/cIMpLhyiHYBVpxjwnc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8334ed4-dfe9-4ac4-f5a8-08de84a45d47
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 04:11:00.9873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfGbCA48kdiTYKCF4s257YTbkEHsrX9wz+HO3FqxrXhHb5Y8JUHBr36ZFV1dCUKMzf5/cFjp8VCEv7NKC4kGsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5659
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_05,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603180032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDAzMiBTYWx0ZWRfX/WD8G/dQ+oks
 QIEuFc1cYeLBdAsJXzGLy7Y9IR1a3+UX7edzsNPzB8C4RYv3t8ZJ29zcZDzDKBDss2XXuwWS3tE
 JRlHJk/fjKhal2alXy+1AoMLEM2ll8ZQcKpAkGffoAkOhNuDrxh6l8uJhwtJ5U7ew8yT+lTJ9z4
 snH+t/H9XSfqbxvwTh7k+IPvTkkPwAAcnzEozTFFN1tc6lsjBky0b3bk5Qy2NUaPTpTQ/BtqgbV
 c9GJALXmqYrcGOYTa77FmqwqoQxk+QalsZZTyxcIfGUJpvx7nxvWUwKPBzVko9GkTmFpGVotpYG
 3UvRYKqLV8oi8B2iaY3lDS4HiINUimaqtTUJzDcf+ENUg8blD5TKY5sYRDUrvvuJwOIrH3Cx5SD
 pKEh1rk7qhyj4R9j9zhOzRVoyeNSqhpMyeO7IuoiF2O5IJ0vHx4TYO7vgVu2tKpgLXeEwM0U2r8
 jcEPNB810DZnVFYCfgQ==
X-Authority-Analysis: v=2.4 cv=AI0/m/Lt c=1 sm=1 tr=0 ts=69ba25d9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yDcM_PQI082ALmuDeGQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: odk0HEAym06OY9B6vyxYVQEip9MXQ1xP
X-Proofpoint-ORIG-GUID: odk0HEAym06OY9B6vyxYVQEip9MXQ1xP
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36CB180005
X-Stat-Signature: y9rkgjfgm6uz1dpgqn9tkokm7ak4ikc5
X-Rspam-User: 
X-HE-Tag: 1773807085-206452
X-HE-Meta: U2FsdGVkX183hSRTLueOpRFdGX9zUXm9YNUEIbXsKzegCnTp32mQyjI/hwmZnWbm2khzS54qoj6L+F09TzIr77svBq1nSh5gULlKSoUFM21SI9AFrCxTb1WEVcM9SkagXCM1YuSZlrr5qG0yuFxS37ZjVkAHzZkNOHycfSd5u1ZKfcAOnoPmnMyeF9MJNksaSIMIfUce4MbsvO/6A0Zz3NAzlrlMKiSFKt79Ot/LQv5aTH2nSgizFeEr8Wf1yuGZodOx+XA9YX5QG8gjO4oaTRtUAzX223B1M4U3g5t/jwRgrovvrTqOPwABbX7QBFQDjn5+1z5ooZUCsZLHiLPNtQ4C+oaZq4r4whM3mvFy931ln2NoITISiEbXgIzWdKQ9fOhoaEk7TSuqr3+kw/FRnq7fcsm/un9ZQMVMm6TC/yXHXwOoeP6aVsBC/nXkcZBej0w4NCKP++bG0jOQPR6YPewkYfmg5C5XRWdk8dJizOVmHYTRzQhvaqFSdvJJ4ASHGzU0Al/vuaj8Wqbc9xZIlu8vo99nkLy1Jcqs2Vr7wfYzvkhZOzwCv9zXWiw7odZB5a+Rv29mrddaiOpv+0ITOfsv5Ls0PmouBq7MsrJxWHP0lnycbC1VgFqw2g1/zTLJV24QtQmCMiJg8ZfdJ2q3LoCQIEl57WeY8PEnoGSRx7kBRfEGuvL7zjTsdfs0B3UIntjXP+tQV3cazSJPvFRsUpQ6B4UUvCx4ElUz8yi15ktq23G4gZfJWT8MqGkPJT7QaBy03y+SG6VIcluO/DDTInuSsR7wVzuBdS0aXxrTmSSxNaxGCqK+cg5CdWH9Zw5Rbs/ccNTj91rQBcrKKCyl/nc4ddzGAlvjt2exDh71dTN2bXCq/XwEP1acNj0fEJJXgeQa6me+FAYfZ4Ge/TN3pKsUets1SNxayL+597lcsvnKLDMZUDpOkfDOUebNrd3Ci/qeGsbpdDGxna/YtkM
 1US22KK8
 0YVWDJrE+qKDVsY5IWboitOQnpPl20M7/rJiI8rHDn0y0rgl7hBhEjSRTjeRzXiHZ/CKhCTD91ld6HQLfr89dDDaTCLiR7TT/wTogFOj8Vt5aivOoeRDGKt/fnV6/7RKE5OB+t0BAHrFvcO/5WqcuZUMJhhZ0udnIA90y1bK/3+tGDYwozppy2zGa3npGUrlK1eWsQ6bISSjA4byZHPMliywgYCYvKcAZw21bIi0Ex8sSdnNtNl82zrKfibGnU/ccBb5UOF25kOylxMr5mRBULBxBrwpBQO1pJ4/zkGGsXLZ+23ryhI8k8OoKQKXz25zKfF8C4b6zj3tGzXrytsTNOcZUtCxU/K8ahQzmBioQIqImuma9x6sSgBmMuyO6+YSYTdzYbciED7ImcJE4jEJ3WVvz0EoknJbc+QdIcgKaYOZo7m6KhUnJ6sDaR8OEkxAK3Mx0fWLFtm4wBErSeoR0qomFOOIN+P3niOO8f5utdG/3yUy4hOXXmGnB03lbKVTBvFt09TWRZrSiMvWT9txcmbctnoZcfiZWDVA1cyWtYOs7sTl8xNs3zCuaQP8ta3L2iNx3RDy84anYN9nFKuCmuZCfSNZvYn45ULChcIvtWHK/ynCY+BafaiNKrTwTpP+Z2GWBHQ7P4Ul0YjK3Amko4CLnP2T2CPSXfuPw+LSFN/ynybRP1Xr7Am9o3D+AjB/S8tZcaRnXyy2BK6vtDCh7JZJgY5ZGp6TH7o7JctlxG19WqcDmknqLjFC0HeixjAD1yfXUXpszRnnMZLurtouy/mh4qXNvoaXLzAIs0BDhQHCKBpqF6UuENF4O8KQ+ECpA9VmWSBJoeJ0BJPjIv9NXj++lgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d79acf5c5100..b7be2cc1efc3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -50,8 +50,8 @@
  *
  * The kmemleak_object structures have a use_count incremented or decremented
  * using the get_object()/put_object() functions. When the use_count becomes
- * 0, this count can no longer be incremented and put_object() schedules the
- * kmemleak_object freeing via an RCU callback. All calls to the get_object()
+ * 0, this count can no longer be incremented and put_object() adds the
+ * kmemleak_object to a deferred free list. All calls to the get_object()
  * function must be protected by rcu_read_lock() to avoid accessing a freed
  * structure.
  */
@@ -93,6 +93,7 @@
 #include <linux/mm.h>
 #include <linux/workqueue.h>
 #include <linux/crc32.h>
+#include <linux/llist.h>

 #include <asm/sections.h>
 #include <asm/processor.h>
@@ -138,7 +139,7 @@ struct kmemleak_object {
 	struct list_head object_list;
 	struct list_head gray_list;
 	struct rb_node rb_node;
-	struct rcu_head rcu;		/* object_list lockless traversal */
+	struct llist_node free_node;	/* deferred freeing */
 	/* object usage count; object freed when use_count == 0 */
 	atomic_t use_count;
 	unsigned int del_state;		/* deletion state */
@@ -209,6 +210,13 @@ static DEFINE_RAW_SPINLOCK(kmemleak_lock);
 static struct kmem_cache *object_cache;
 static struct kmem_cache *scan_area_cache;

+/* objects pending RCU-deferred freeing */
+static LLIST_HEAD(objects_to_free);
+static atomic_long_t objects_to_free_count;
+static void flush_deferred_frees_work(struct work_struct *work);
+static DECLARE_WORK(deferred_free_work, flush_deferred_frees_work);
+#define DEFERRED_FREE_BATCH	256
+
 /* set if tracing memory operations is enabled */
 static int kmemleak_enabled __read_mostly = 1;
 /* same as above but only for the kmemleak_free() callback */
@@ -522,14 +530,12 @@ static void mem_pool_free(struct kmemleak_object *object)
 }

 /*
- * RCU callback to free a kmemleak_object.
+ * Free a kmemleak_object and its associated scan areas.
  */
-static void free_object_rcu(struct rcu_head *rcu)
+static void free_object(struct kmemleak_object *object)
 {
 	struct hlist_node *tmp;
 	struct kmemleak_scan_area *area;
-	struct kmemleak_object *object =
-		container_of(rcu, struct kmemleak_object, rcu);

 	/*
 	 * Once use_count is 0 (guaranteed by put_object), there is no other
@@ -543,11 +549,19 @@ static void free_object_rcu(struct rcu_head *rcu)
 }

 /*
- * Decrement the object use_count. Once the count is 0, free the object using
- * an RCU callback. Since put_object() may be called via the kmemleak_free() ->
- * delete_object() path, the delayed RCU freeing ensures that there is no
- * recursive call to the kernel allocator. Lock-less RCU object_list traversal
- * is also possible.
+ * Decrement the object use_count. Once the count is 0, add the object to the
+ * deferred free list. Since put_object() may be called via the
+ * kmemleak_free() -> delete_object() path, the deferred freeing ensures that
+ * there is no recursive call to the kernel allocator. Lock-less RCU
+ * object_list traversal is also possible. The actual freeing happens after
+ * an RCU grace period in flush_deferred_frees().
+ *
+ * Unlike the previous call_rcu()-based approach, this avoids embedding
+ * rcu_head in kmemleak_object. Objects from SLAB_NOLEAKTRACE caches (like
+ * kmemleak's own object_cache) are not tracked by kmemleak. When such
+ * objects were linked in the call_rcu callback chain via rcu_head->next,
+ * kmemleak could not scan through them, breaking the chain and causing
+ * false positive leak reports for objects queued after them.
  */
 static void put_object(struct kmemleak_object *object)
 {
@@ -558,14 +572,46 @@ static void put_object(struct kmemleak_object *object)
 	WARN_ON(object->flags & OBJECT_ALLOCATED);

 	/*
-	 * It may be too early for the RCU callbacks, however, there is no
+	 * It may be too early for deferred freeing, however, there is no
 	 * concurrent object_list traversal when !object_cache and all objects
 	 * came from the memory pool. Free the object directly.
 	 */
-	if (object_cache)
-		call_rcu(&object->rcu, free_object_rcu);
-	else
-		free_object_rcu(&object->rcu);
+	if (object_cache) {
+		llist_add(&object->free_node, &objects_to_free);
+		if (atomic_long_inc_return(&objects_to_free_count) >=
+		    DEFERRED_FREE_BATCH)
+			schedule_work(&deferred_free_work);
+	} else {
+		free_object(object);
+	}
+}
+
+/*
+ * Flush all deferred object frees after an RCU grace period. This must be
+ * called from a context that can block.
+ */
+static void flush_deferred_frees(void)
+{
+	struct llist_node *list;
+	struct kmemleak_object *object, *tmp;
+	long count = 0;
+
+	list = llist_del_all(&objects_to_free);
+	if (!list)
+		return;
+
+	synchronize_rcu();
+
+	llist_for_each_entry_safe(object, tmp, list, free_node) {
+		free_object(object);
+		count++;
+	}
+	atomic_long_sub(count, &objects_to_free_count);
+}
+
+static void flush_deferred_frees_work(struct work_struct *work)
+{
+	flush_deferred_frees();
 }

 /*
@@ -809,7 +855,7 @@ static void create_object_percpu(unsigned long ptr, size_t size,
 }

 /*
- * Mark the object as not allocated and schedule RCU freeing via put_object().
+ * Mark the object as not allocated and schedule deferred freeing via put_object().
  */
 static void __delete_object(struct kmemleak_object *object)
 {
@@ -2209,6 +2255,7 @@ static void __kmemleak_do_cleanup(void)
 		if (!(++cnt & 0x3f))
 			cond_resched();
 	}
+	flush_deferred_frees();
 }

 /*
diff --git a/mm/slub.c b/mm/slub.c
index 20cb4f3b636d..6bdf409d427e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7537,6 +7537,7 @@ static void early_kmem_cache_node_alloc(int node)
 	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
+	kmemleak_alloc(n, sizeof(*n), 1, GFP_NOWAIT);
 	kmem_cache_node->node[node] = n;
 	init_kmem_cache_node(n, NULL);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);
--
2.43.0



