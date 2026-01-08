Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99573D148A5
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 06:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE01E6B0005; Thu,  8 Jan 2026 01:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8056B0088; Thu,  8 Jan 2026 01:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8F086B0092; Thu,  8 Jan 2026 01:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C702D6B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:10:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E521C2277
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:10:54 +0000 (UTC)
X-FDA: 84307773228.13.4160DFA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1D52040004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:10:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KYBUHbOz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="T/MeZ2Wz";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767852651; a=rsa-sha256;
	cv=pass;
	b=xXb6+8RGe7m/4V3TWGcvprTRIbV3mUZmt3TSPSTvwDhVVGH5OTAahb04zRnbQG1QHHfQL6
	NjHJLzh4ssHnGMr86KEYHEVTvCX3SduPCK/1X+z3MR2M6fPOjJu689dW+cCdaTym3GndHr
	o9+V6DsV6V31KXNPG5gdoDpnUqR8FZs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KYBUHbOz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="T/MeZ2Wz";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767852651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IM0QM36mVOJtuAIagaKxKyrDE+eXqsyVuJlEcczCf64=;
	b=7vv0THukn9KQtUIZ6n9jJe1j4zJtPpD+NwFZj1f80Z7PEy31Xt92Tn+wdHdOJgyeceL4gg
	IgDtO7lDLUZTat+DV/b81hTQfu+rpSfc25YMIqXnPtgF3d78Uu9z5DVjeIWoVhr+bBOxSy
	pnngjIogcPMo8jH1BSKq7KoR8F9Vdtk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6085eLYI3651122;
	Thu, 8 Jan 2026 06:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IM0QM36mVOJtuAIaga
	KxKyrDE+eXqsyVuJlEcczCf64=; b=KYBUHbOz5+BgDfAQqayNONm8xXfINQ8Syv
	+t401CET2ZSzhTqJgmLTFuJyjy0FruAp176Zo+NQR3pRb5OR6kcUPxYWe4obRKXv
	vG7wPLAw2AlsM0kZVz4BFz2vvf8HcYYfvEElL2kgsH/E/ZDZ9gyqESGoq34kh9c4
	wh89RubNXahHBIWcxH8ljvo8hZkmLBjWqyi8RPAvNjDHCEIaO0B8pMe/YhG1pSJy
	4S6sMXXZ/P19hBBAB+hfamH+ugGrAXjMiHqdVy0RGJDyDrbu1hECcmQgZPIubvm0
	e6lKcYNs79kUwgSfm0m/i5dxjRBeoVCBnOfo3a0O0MOYUaCcImfA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj6mrr0q5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 06:10:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6085ZBQD033915;
	Thu, 8 Jan 2026 06:10:23 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjapv9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 06:10:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kXX05AGPG/TZn/F8gtiYHdz6BYFZr9k9uFmDO1eNzzYntn+Wns7QH/04be5x4/2vWDTdF9NXzBYSodv1e5jd/tbw2w2/a7wJk303xMXj+vf+T7aZWAJO0/hlEXRoOOjLOuBeCRYsXxwzxoRm+01aMBEFWF5cmpDz6ZY2ouJvcrerjuHOSC+fjS1FL3qm/qTWBGep6BbRMAA6AJy+WMki1w2Ln/80lrhGy3LG4x/Fx+7GN3oZjrk3WABLR1oGJK9mOigtaMqVHhgOZiUnQcVUwsxyHLjO7TJ6XgxaOaiWXfHUdIIhYWARK4gsnoPd+prBl0PfImZQC5c1jEZX4MV4qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IM0QM36mVOJtuAIagaKxKyrDE+eXqsyVuJlEcczCf64=;
 b=h3k0x/wB1yU7rVVtVXtOTNqzwtGHzmaB5dbytm1l4YW7zdMYS0lE86UTAFZXV+AykCspH0xDECrkihv1Yzr9OfW9nGvEegggwf2zYlSprQIhauuajxNF51Ee/kbHSSWZR1m687+LuGpYJahlTf1GY+T35gf21rsckOvHnG/FNCSnKfoG3S1uK4VJebKLoYYDPq94nuldavyihtK1cDdPfI+ip/5SMPlRcsiiss0483dZibxTOvPupi8MBscvbePq8Vx8wjbXCNgn+O5+7aUiACSJzZEBOOq0AQrRe7Lil034cCXYbc21AV9V/oG8X5y7A2yiK5Uty3xvLisgupbrKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IM0QM36mVOJtuAIagaKxKyrDE+eXqsyVuJlEcczCf64=;
 b=T/MeZ2WzK6UfLrdyznq5WjMI1CusyEBtBMkb3Oj0MspSB9eRJaDSfmV/BmbYdlQ/fbtgk8FhvzOIpa2Xz60yIOkBouMV10EVhl4LXtK/pN86/Wa/tJiPS0Z59aMuOhTo+MURyq4an+t99cb7YU+RVbgVhAb+68A9SeaMgZnI6Eg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS0PR10MB7904.namprd10.prod.outlook.com (2603:10b6:8:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 06:10:19 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Thu, 8 Jan 2026
 06:10:19 +0000
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
 <20260107072009.1615991-4-ankur.a.arora@oracle.com>
 <38c0fbaf-cbb1-4f43-9d45-31ca642d1ed6@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        lizhe.67@bytedance.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v11 3/8] highmem: introduce clear_user_highpages()
In-reply-to: <38c0fbaf-cbb1-4f43-9d45-31ca642d1ed6@kernel.org>
Date: Wed, 07 Jan 2026 22:10:18 -0800
Message-ID: <87pl7kr5x1.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0188.namprd04.prod.outlook.com
 (2603:10b6:303:86::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS0PR10MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: 798e0031-5830-499e-9688-08de4e7c99dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HlzDncnb11RVGEtSRg5VJaqxt691Br1z2wkj8G/cAIXiwd+1Uk5A27bd5Htm?=
 =?us-ascii?Q?UCDhHTevAmvWv6I5+hPtcxMgIlx0ZDJ/WVgBOdIxZEQ5pUGyyqbI8KzSko2G?=
 =?us-ascii?Q?VwVCQOCUyStRJ8hlqF02ypUOXl4wHFZtj7lSFave2EuI5ZH46aG4u/Nz9V2d?=
 =?us-ascii?Q?vZ5Kex5DJ6ucHe7fO12jYmFRulJErTU83Wkhlbi4TWz+yk5kvBUJdw8SlSXP?=
 =?us-ascii?Q?eNZxaUwsInjurzfGpG3ShYonCjiRbqaVFpPFV1ZOq3wmm/8F4JCukGJjDXrJ?=
 =?us-ascii?Q?imc8f1zziQ2JueRtwlGFLe6vjt0CdIXNEWXLXa7/jOHFbciGZ6sScch9UbTG?=
 =?us-ascii?Q?oU1uNl8lBaTXYMixEmVj3Yde74ah2hYkVVwPnBgel3evUy88Z5TGmptpsxpi?=
 =?us-ascii?Q?wp9KDfvDwxpxxQ4tKMo3FVKxbEPZhNYu/Rb+rYtXDJEQLQGEsMVTGvM2vR3s?=
 =?us-ascii?Q?g55zVL4b21i379JuuIJxLrJg7ZQmPmz0y5NSbU86Ruu47tdDh978NFcQidGn?=
 =?us-ascii?Q?Oe9EvEdVf/nCOgY/JMY02h2Tlby1ibnomP5NQqtXlv/bRavlujRLG2XbuV8w?=
 =?us-ascii?Q?EmQjNPYVb4WZ8KWByD950wV9mCsUPXUB5PbTXmzC1ibF+iot2FwoZir7YkYJ?=
 =?us-ascii?Q?zsUngC/4tAY/x6yLpVMJB4tk5VXiNweiecezhhox63c//pXYHQU9nNX51VTJ?=
 =?us-ascii?Q?GU5psRcHMLG/6TT4M7QmF6+h5lOd8Mfkrrc5z4gjtuSpk2qcEiWTFXnJeq8H?=
 =?us-ascii?Q?3StvGeUXP6H6cwedA+fuZA5GydtqgFO7J6pgc3wx45v2BmfoUb1lw1gO0R/x?=
 =?us-ascii?Q?lkxbrfRInjRTpLw4oZsQ6SgV/WvfsMrLUHWzFJyxoQHfSGKV2lX6+NFOtre8?=
 =?us-ascii?Q?8GL0GfOHA6XqYDNFIOsfagBeCIo21pTt9DktzAFi62bbnF3Kl1gBWcBjEXVA?=
 =?us-ascii?Q?DA8xd7NdGM9BuGykewEp8TVgp/XBlgWnvW8urQTTCES1JHr2eCpHf9Wo5Tpo?=
 =?us-ascii?Q?zWQwoNhnS0lCIpVnsyu0XevVCVmU98wGX+pdvgk++pwxDqLzhaf8U5cQCuGW?=
 =?us-ascii?Q?7l3VS/N9IOdOLJj+8oXmwXIXPL/kepyjmI16/LqH40sLHASnETM1uU3LZpMi?=
 =?us-ascii?Q?/z5HT6NJ9TAUBQ42pPOzLHjw9V3n76F8LoDZJjt1Cp1fiKjcqtzIqSjpOFvB?=
 =?us-ascii?Q?pIoW35zcsgdXum+MlrkUswzpFCBW4vl9RkzDUsRe6gz7GgxEglF3z0dgpXgF?=
 =?us-ascii?Q?ZkUShxdkLWdHwv+HOqGOiMU7xPuiEk6aMf+crXIzwC01hPhTPQGOftKQlgto?=
 =?us-ascii?Q?UIXgHPDESUPS8ap9ntiohl9XWoYu4N/D9Ewv6+9L4quie5iAe846ChyZR+Hj?=
 =?us-ascii?Q?ywh0Yh8crpdgzVb4zTbg0uhVlT6QCENY2Hb83xyNxluCXchE00olimkBHMzG?=
 =?us-ascii?Q?VtLQWvaYS4q5J0TNhtpgMPf0Uu+ZiqLt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sRcqE7Qxq+CTljX+b1imQxrrUwzLVbMXb3IsfxrdX1363mXP8OzFkYDuJqZz?=
 =?us-ascii?Q?ZGD+7mOM9XixHpZv/sWzxOpqkxbhRrZfIJDAkNHXfTqsVTkffoS+zgMoURLR?=
 =?us-ascii?Q?Pa19KrWsZ4f1qIUKm48F5bo6uCMG0cPpxJMXZlLFf561jGc2dXLV5o/tCK/g?=
 =?us-ascii?Q?JseL6QIN/3rEj7vNNTpvXfdA6iHj4Ove2d8KN/X4u8E1CQRTUdnbw2kxgSJa?=
 =?us-ascii?Q?2RhjSaB3YnLSxE1DsEiVtLTjOCRRCwnvbSzgEkXX5yvjWhqSGGMzD/MvwPsy?=
 =?us-ascii?Q?gGnV8JEpE68ipGRqak3W79+AxzI7KShWnrEw3w11kfQbPOJxGO52UltMLBN+?=
 =?us-ascii?Q?pRSt5A0uv22/DX5VZU2Jt2kny1hbBy9DV8cxF39OzcE61YEPQ0rKsy2QesqK?=
 =?us-ascii?Q?vu82FgEFYRPTfl8XyfxINuvqb0lM/TtkC37+qsZ5WBRa1AqLujc9LLUMBU+F?=
 =?us-ascii?Q?wQXkMb5yB+L95qFGNc2IZ4c4/rPV31Q+Op38nZvr1T27RjDuGRG46GAXr68S?=
 =?us-ascii?Q?SvLPdoBrAtBuRlY1KRyNfzRug0klfc3PrIElP9KlfLck2dYu3ACOoJM32jhU?=
 =?us-ascii?Q?Rgz6qRtRNgNWmp3LTqMxSpwsgnrSCMID7eTiiGRvPXyoZEfOc6dLIqobEAgj?=
 =?us-ascii?Q?2BHcTyCIxJhtUzU6eNz9NJXUztu7pW03D2768047fz2veMuoNjlrgSah7MMF?=
 =?us-ascii?Q?kYXKUqoPdWrSGZiFsPr76SdGndRWHa2VD4tVVW4LqE2UDod5XOSWQG5/KgU2?=
 =?us-ascii?Q?DefJIaqwfKC6vcGv2CHPU+ipQyeyPNbVtEK9pteb6SZBtmXjLuVfItX7cnPN?=
 =?us-ascii?Q?lVJqfB/tr2ehpAMPHH6NGwnddyCBlzzhXCGT+lMo1dlI/F8MhmTbjC8z3688?=
 =?us-ascii?Q?ivNNw6+QAIpUa4fZyo7RCu3muktxd8L7fUmKJ0RUoHSabPvPQtpYUCm25LBI?=
 =?us-ascii?Q?OCDtUD2NAWmXmBMAlCiYdAPKdmQTcT0/VMvJFGcYP94crHEBaz8PMjcjot+Z?=
 =?us-ascii?Q?JuAqGXEmmeGR/OWb5C/vD4JZVOr+kwa3PpvlNNLERNZaklGN8bnHG/YumMrQ?=
 =?us-ascii?Q?jRbuyxXX5JXChmXGjq2zsUpfZqrZXar7qqbW0xdewqrhZe1hFba4IM2xpXPH?=
 =?us-ascii?Q?Ovf3TDp8Jl3qnJItkLrFkR2Fzv8QSVErZuuaUXeeRD+gtbm0A9iiUcVXf+cj?=
 =?us-ascii?Q?ITImTl5idKk0uAFPWz2g1Q2BVtyMmsaOyS6hPiiQxXQmN0EPjKZH6Yd9oEx2?=
 =?us-ascii?Q?iUODhsAOjc/Anb1+a4S8+bjI7TRrv9wvEDLRIp8wMLzJBjSuV8H63ztSYnQ/?=
 =?us-ascii?Q?Xiiq/f3go/lQjpcQlB4YPwcAFZHSUzx+YW6Fu3zFyUmLPArMHQJ+n9gOwLid?=
 =?us-ascii?Q?xhbAoxCAEh75CQilWMvfkXRS2EsSQKTPxMn+zuHbL1iPvAo2pYQ4xCGbkuvb?=
 =?us-ascii?Q?lVxakDPB4AkMHdu0DGeK5J+S8WY8OeP+EbQjAxfPj8zJqPns6lMpztyU3r/c?=
 =?us-ascii?Q?z6kZYbF4ql6BWQ7X2XK0cXkOe2pHOQyv4oas0I5eNDrzpJ1o7/YIeOVsRijV?=
 =?us-ascii?Q?FhQzyEZJwBJLSA855Ogr28eYCVyHtTHb9Tc5c9zIetNoN+nbfgV3i3zbZBF9?=
 =?us-ascii?Q?8zV8LuYu4etd7fR734Ole3uUDRaqX72qP8hSInqe+aRGZLVFwM99N6f6HQO3?=
 =?us-ascii?Q?e4uSZEMpbpF4H2SL3GQ5WsbxUPu3SF1reZIlySd1yuR0f6RjC4ubGp92lXbO?=
 =?us-ascii?Q?hz7Ce6zzdbq9hgc1xwe3/p1gX4JMzlg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rBo3Rtwq7HZnVY6W3tnECXl+0hCRJUMZgKNFYsxaiSQGfrqGhJ0D1Uilrk6En9Bk07oqPEGxCI8FN5AqIxnM9BMN3BE+gCZyF42iTfbX+1MsducRE4Qxbpe8GbkVRVBvxlOQ8YNw/2z5wfdqhuI30UtUgIOcgf1/ZowxhkdB1WFWy+FkgBgr/t/8CPOLX4UckDqXxN6Tu/vRGNvPHq5KLT5UvUqC32+TDgHyU9u+hFmEALuRsVi2E05+vnpQhxa+AVwbHFd340WAUSAxC9PQm5+MNGH3r2QD3NTPrdVwS6iklQCPmkWrnTwUsZF0Ij9KvYSPZ5NyO1dzRXp3jTJKXHOkl+kQDIz62LKkqbxZRV5ik2lA7JsctSCulc+vjJWyqRfRjrL4gAaT7xFW6OujdLOvyieOVkETmEql4sh6AF5JGgUi1r+zwlZAgdoCXN+TpEUdsyEQO6vtYfuLu1zNEUihS/3abD2nXX46C+pWWBEOFgldFgaJ60R9M00Cw1S+GZr+R3si14NiuxbyVs5ZPKMAcXhQ/u2EHUsJu6mVpBrESsHOAwzu/Aq7H6WAapcyFLW6NOxOLMM3iFY7fG4b1YBiSfkub8tXb/rQ8ujyaTU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798e0031-5830-499e-9688-08de4e7c99dc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 06:10:19.8866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDvPbodQuV28y9Tz4VZbquOwY4RTzrzgu5jif5TZ/D3lkblPX4uSPofc9hwoEtIApYuJbB2926uh0HvOCDjiejPW9K7QK1Q/f7QdGjH6ucE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_01,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080037
X-Proofpoint-GUID: aCEc6-5n0E3MzkYtPa-4hBfMCVxnec5w
X-Authority-Analysis: v=2.4 cv=L58QguT8 c=1 sm=1 tr=0 ts=695f4a50 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=aXLDQx3-y55d9ecWuI0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAzOCBTYWx0ZWRfX3QJedDSIOY3h
 7SKbubj59Sa0Pd8zYXnfO1MrD7+6D03UNaDlIMfhACG4yQ4pIed0LLBCmtdj9xK5Jdc+n3OHxt0
 TcPXWNHywtnj3QMSLQC7vNfJZo0tDUauSvZ5Ym2qZR2c+UZn1pk00YfglYhZ4eVGDZuCHjl5/2D
 3CV/L2A+WW/h6pFWeiZhiT8HoWUCFMuKSRJDefkW0EzwKv7n9W6MfQr5KEViHnNCUo2ETnXz5SA
 0g7+/3H8Zlk2M0LgxNxpitL3V14iEZ8oNq4yGpn+GpQPmb426vaWtPnbTODY+Ki4A5mg7jwHi27
 bDmKmLY8Q495genwBbBHNwasiI2QBvGT/JGHUqZvje/aGRHxYZ+nuj8rbwNYzegs6Ot9zUfacvz
 tDYzbca2MABNo8kPmbHX4p8UWNgG3RlMXKVM/UyA2cTwZNs48Ce4NBeSvTLC4yWYu7ZNgN/qmb9
 E6ZlhUHzZL+7rGmyyOA==
X-Proofpoint-ORIG-GUID: aCEc6-5n0E3MzkYtPa-4hBfMCVxnec5w
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D52040004
X-Rspamd-Server: rspam10
X-Stat-Signature: o4hftkgzy4ty7fq13acrghsmnndboboc
X-HE-Tag: 1767852650-466664
X-HE-Meta: U2FsdGVkX1+LegrayjZjBx2Rv50eAFJZprUL27yjRtCKx+W8v6DVRvnhf7Zsfosp5CEbajzYOzlXdI20hg3GKpl0z1VTyq6aI1Dccrgn9untf/hA8ow2sctY+nmsEX4tXwMtDZ7sMJ8aMK2svQ1nbB2YPH3uiKa6ejHRFnfnRG02bG8y6csBUyhB8YANNNeq7X0nedf5ZRnrGEclyZPwrQJQBR6Uu4Mt3Cj5CMe/4IbZU2WmlpmlNZa69ttRe0icPEX00Q5cmDQwXNaEnmEZoWAMjuWumlGBtqUznBukp+gzL27pxDhwRANHriYvtSuaS1hKyADwSDM6ICqHXcSDygV9cDJ5mO9ynHitnrcFv5BJ+mffQF2cbk2KsIpDCGZNbHkVDagPhvqSdCtSpSgPZPdn+Gw7bc6N5yhDDfmDTNUCWn9nR0W3UtVuNL8JIPqmAD+jz4YfITtB0vfj/0RGTFZyFMe5OgAvW5IAjnVtSFMxEqRwhGGnGmWE5ox1avb3FFSSg1jEhADWanRuZHMb5MrjQxj8Xl2K8OCf9bOjZcAJ+BTUls+zhNvsIVj/sCeeU3XmHdYqfV9nxvRWnyAewJFSlbOSZPH1/GtgBKfLbOacgRks/h8DbW05mpTOrbXm7osznzxjfmiaft2yG/i+1YwlUBMM6+1cw94+aEdZz7flB6kUqK654wHZQwqWLzY1/Gyz8kH/i9t5hfje0IQIKMli14a0EnDaTnVYF0AEAc/5OqnqLqkaUp0bDRZvAKTAsHGZhpPQq0rLr0yLXInFtjMzxnayILJnHkVz9CtnbxDM7OGA0Gyjll1Z9YUlELHhGXGqJsELUJZC7OuJexyYsIjga7F7ZyZHrWQQc9IRV6wM6tZOFjeHIdjsRCd+aVZtwlw73bYxVaWTR3EyrEvkIzsc9sysH6BfKkLdl96MIw/UPLYHy3/LgM+l7w5oIvI6+2Cb4K21q4SucG3AyDO
 6366PjX7
 jfwPJ0SWtxQ5NyqRULcrzwqnxBZ/1LobU4A5aZlGeUekSMQtIzrTl59plbSVxuZUbn8nk4SnhR4h2J0RF5xayT41pn+/YmQCZUcRhV8R+38cqdUsU3SRUMc2/I9Dkz1w8xWU2unXolzGgJJV8Wipv8FPmdijpaRPZsyzkT70x+K3gfz/KzJY7eFIX1rk5KolFPifHSsWXMoGJaSDB5wgpOZoPm9erMIR1VYfigbsU5ySoagK7ZCkyK0EDh3jCk579kfmIhK5W1tExLOLYiYybO1cIW4Sb+HqVumxtFfuRmwszivYdhs3LE/FYiZMR/+csXnqlpzaJ2+2dAylxyM4fj1vXVlObQZdlhqdQoPiarjHcoFsnD+8Z/Z+12cNt8UIXZfUit50fvlahi7BXjfdVsqAfHHYAmLoahqrkRPz/vWm2yPjXBX2biBX9ejHxITrqIQWF4QsYipkjABLeMg05QbuMu+PJdeBB0n/Ihe4dMDIjP7ahwL4Dw9AX2AXpzIncEUPljTRfE16IVVQqrVKG/3Cnwp/d9I6elEmCDI7yZ1gzaHSmbDglthDriBDEpDEU0DrGqfLiX1kemjel92hS4hhYuBQmOArrFnWD2KlMULlHpH4OK6mn2oKu996Gc6tyTPKmUh3sGctspUvZEEiK2xT76f+ETG4xyOPHHyDR0U8P5iMDmC++V9vvy9SXyH2tw2LAOANYQIhGo6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 1/7/26 08:20, Ankur Arora wrote:
>> Define clear_user_highpages() which uses the range clearing primitive,
>> clear_user_pages(). We can safely use this when CONFIG_HIGHMEM is
>> disabled and if the architecture does not have clear_user_highpage.
>> The first is needed to ensure that contiguous page ranges stay
>> contiguous which precludes intermediate maps via HIGMEM.
>> The second, because if the architecture has clear_user_highpage(),
>> it likely needs flushing magic when clearing the page, magic that
>> we aren't privy to.
>> For both of those cases, just fallback to a loop around
>> clear_user_highpage().
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>   include/linux/highmem.h | 45 ++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 44 insertions(+), 1 deletion(-)
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index 019ab7d8c841..af03db851a1d 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -251,7 +251,14 @@ static inline void clear_user_pages(void *addr, unsigned long vaddr,
>>   #endif
>>   }
>>   -/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
>> +/**
>> + * clear_user_highpage() - clear a page to be mapped to user space
>
> Just a minor comment as I am skimming the patches: I recall kerneldoc does not
> require the "()" here. But I also recall that it doesn't hurt :)

Thanks. I had assumed that the "()" was required. Just now grepped to see
which style is more common and found that I had used both of them in just
this series :).

> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks for all the acks!

--
ankur

