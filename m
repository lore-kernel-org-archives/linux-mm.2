Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4CDCA1012
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 02:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65738E0005; Thu,  4 Sep 2025 22:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3BDA8E0001; Thu,  4 Sep 2025 22:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A046F8E0005; Thu,  4 Sep 2025 22:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89F378E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 22:13:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EB681A04BC
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:13:13 +0000 (UTC)
X-FDA: 83853574266.22.5DBC896
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB3CCA000F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:13:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CHsVJS1x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KHip0nA7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757038389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0H25VafUl0jS12RpftVTGdzY+ROQZuSRDOQio/I2iI=;
	b=Q7aq4OHQm+eIa8x+SE0EsY/tE2lNWvWEhJTQ1napnd3X+ou9ZOOUho+DCQZ/jvCc9xQAx7
	5qNFoZJwIuZHb6qpkKfh2B/LW9HrZh40nRuLL3KeB+QML3vdmykyTh/3D41+MD5uKZGnyv
	fB/X0x5rj/Ad4swDMswHwcWq/ePHYC4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757038389; a=rsa-sha256;
	cv=pass;
	b=kbuThea1N1SNWC3RwFQ3aMMqiM8I8RT/b20aeuYwOBFhrtQ6lSjcYBot27THrVkFjEfnI4
	At9dPG+W7WYej5iagLrsBXeXF578EKRH5wvEIAyjV20J8qvU4yBd5H4aoWtyu5JfcRPDAR
	ZJqQZ7LyAzphCZMYEs2n2yq/4/547CE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CHsVJS1x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KHip0nA7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58515Znb010521;
	Fri, 5 Sep 2025 02:12:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=X0H25VafUl0jS12Rpf
	tVTGdzY+ROQZuSRDOQio/I2iI=; b=CHsVJS1xaLSyF92VeMnDETpOS6nBNptywX
	ujqw5TtgfQMYgzcy3v1ABq2+YfLQpr8gjYzXtLFby0P/qLerur34Zyw4IVEUgqHw
	Q9hQzOB9glLMsLgf0/c0O9YYGZJjLCAM+MHnof/K9sxoRrSElXAUWeBFSbOvE3GV
	XtSP70Q1BElkJGLa4dAHUXcpJ+Flxks5/HQOZXfQyhs9ktVrx75bOEWSOofg6kpk
	J9UOk5VnjoAdl993pMoeLyi76txohQe9/xRCraBNXVlFglUqdocwgcctFbEBfK5A
	KCVenfYneWZVcwIZKPFtNlLOjr4fI7THfsyfKxv/unolRuZ3L+Uw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ynvmg1t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 02:12:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58508icE040152;
	Fri, 5 Sep 2025 02:12:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrjcn4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 02:12:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AZJx/EiudXDOQkxeu+JbCVysqP1l+0wt7KAhEfF5fbqhIN+ql1VgCXG0D2GqbBiVNo/s/vV/ZbT9gdYr0K2WWPGQkpj7z7M6DzcZcvCCTpLj/8WwKoLkr0XysFhBuotV4bOq4KHISDmQbpTgO5VAeMBRlmRXk1KQ6Kbbr6zR+qMYlbA4RpfwbJMcDzrBKpslgG8dvBKDFpcShqdOD0hoTp4vFp5l7M2ugsLZh9SQqi5bgH4GvfCHaDzG0g2U04Ivqo2T/2AD+RgjubZkGM8YKbAuqozWXOhzuw6qhVj5RcX4WzZ1MQ2DIsMrNuMjEFVVoZ94yncYhZ1Ru2ulIloScQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0H25VafUl0jS12RpftVTGdzY+ROQZuSRDOQio/I2iI=;
 b=zKFf6NaZCH1DjHkTDnRUso48nPB4O39fsioMgN7JmUAqPWvuGNbPtYWznJUtPZQ9YKMPdaQ0/z6sw9h6eqp5Ue/yk6zDxfVFYhKdbwVNB0iMTqckoJysZueXO2/DVHqDg2ur+rmqs6Gj1Xlmpz9tb8jQo4ssSRUlxanpxqKwo/yfXR/4wZrr3RHb8soYDFttDbylTunQj5TfdafV5/8xYPedOqc/0afOkiub0Q9xovy8SKhRKx60PzCHzxkrWYF95zpfS+1NXHSyWc2MzpMdUiCc9tTGLE4Bj9VdLS3oEs8QOEzl5jhBCfoiGbO271YgHPkEuMB+irvao29du6NGQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0H25VafUl0jS12RpftVTGdzY+ROQZuSRDOQio/I2iI=;
 b=KHip0nA7nQZQrTK9ywHmuLblVOaDsfAs/06qH+YWquDPTlpTYoGZ74y+9tMPJAEBgAnAD9k9udXpI/7ZBjQR0blClfDO8Exx7BVvZqN8dbNpziuLbJaIwYkQXYsb+IG+O05AZUdCI0xx+SlTgw3D0qDcHdx3B6K9k0ajA3fm320=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS4PPF0316BCB78.namprd10.prod.outlook.com (2603:10b6:f:fc00::d04) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 02:12:52 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 02:12:52 +0000
Date: Thu, 4 Sep 2025 22:12:48 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Michal Hocko <mhocko@suse.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com,
        shakeel.butt@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        lorenzo.stoakes@oracle.com, surenb@google.com, liulu.liu@honor.com,
        feng.han@honor.com
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <a3hgvhvix2ulzfof6d23f7kzk5clsnea3grmd2wowjyhjwuiyn@ymzvkqf7gcsc>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, zhongjinji <zhongjinji@honor.com>, rientjes@google.com, 
	shakeel.butt@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, lorenzo.stoakes@oracle.com, 
	surenb@google.com, liulu.liu@honor.com, feng.han@honor.com
References: <20250903092729.10611-1-zhongjinji@honor.com>
 <20250903092729.10611-3-zhongjinji@honor.com>
 <aLg7ajpko2j1qV4h@tiehlicka>
 <7rvwvuifkav5oz4ftfuziq23wek2bn6ygvrfotpaweypuy7obv@hjuf3eknscii>
 <aLmENFH-g9MUQAsE@tiehlicka>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLmENFH-g9MUQAsE@tiehlicka>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0363.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS4PPF0316BCB78:EE_
X-MS-Office365-Filtering-Correlation-Id: 4157fd49-376c-4f8d-705e-08ddec21b7f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LSddZYAlc20eJlCsMot9fZLDz1eSS2OIGi9j5ploDI9OSsJdcfqDoU26CLGP?=
 =?us-ascii?Q?KPqsrv9IMeJ+38mEMIc/AVckqvPnidAcuKkKAe+rRfkqqR2hSNFldGbIAv2j?=
 =?us-ascii?Q?eyhzvwq9HzxXY0fxSP7JPAWffe+h1lldlYFA6Yh6g9MDBpDZtx8gOMCkOG7R?=
 =?us-ascii?Q?QFO3DBTl4CC1s9MTDmOC8nk9ymkx4jl/9jCjx9Azm1mGG0hbYbGqXl14bX4a?=
 =?us-ascii?Q?mWPVH9ZVIahtMbXdnJutMZ3W9GLG2ntSe4Fg1E5mbxI/4/xjoLEEzZyJ8gWz?=
 =?us-ascii?Q?wzd+KqfQrHTb0FEKwFLtcFGxWicql9mawVQaSUdGaVI/JWAjtRc4MawIzj3x?=
 =?us-ascii?Q?/yUsrwHPAlUpGFyGYQUEiVZpS667m2O21nHYRSEWTRv1apP/jvNlWbeShcuX?=
 =?us-ascii?Q?7lAzNeZ2EJnTGc/5Id6Cde4I8Z4brvAPRcr7G6HRwH5A1gS33ZCYLMnezBX4?=
 =?us-ascii?Q?IWxfVpCzuvRiNxeHaAcyMaHtOxpejoEqqghNK6en1YBEzjvZpwud/AIlpTsf?=
 =?us-ascii?Q?i3eaDBI/5mZJ4yllxDXLxeeaJRH72eBUrdRD5YgzAOWFVKMxMwM6A/Jdv7sP?=
 =?us-ascii?Q?pmTgvwrvR3VfExiP97q2rBEfaaj2DXxOzsA9Uf8uj+e4pZ2tijCvMWONYWUB?=
 =?us-ascii?Q?uAvLAdCgGI19jeSdroBTslyO9s6sZNdFokal1jjyHuGtToKE/7r3zIVRtI1v?=
 =?us-ascii?Q?aZ3Lz51uj0q2HCTvfYLk0+z3nQ+HS+bYRCjrgMwlaQcTtf3AKyOgyPNqTmIZ?=
 =?us-ascii?Q?126GF9qHgGwEYmMqzDeLpc5r2GMHLssshVu1xs7v3UA5jSnLQyT3TWsFOqsx?=
 =?us-ascii?Q?XY3JSAXyQTnpwa2vjb5aRGG4KOJ1R6JR26ViLVZy9eqPyS172igPVCdqACTs?=
 =?us-ascii?Q?ni3JGCJ0/+qRLzX+8lYUmm6I8DVtOsJXjRbxtV5/omvpgVdsQ/u6a8bq4pJ6?=
 =?us-ascii?Q?TKtBske2bINJfSieAlg7vRoOmEInVfAKfd1WthE2ZZlKEOCclo7nik4Vn0Ze?=
 =?us-ascii?Q?kVRZBJNNXyK45Vbw8QCesZPDNphT9S/VQBX+4Fb2AdXpfFpZwyMavK4c9JuV?=
 =?us-ascii?Q?BVmz2J8SDACZlULRKevbdbB6Xq6k/LlQ+UkInUiII5KFIwedkYXv3IOTozoW?=
 =?us-ascii?Q?RSFEBPByL2vq/2qWtYbX78PcPvDIKaUU8I75+Vf8kZdV1zPdBjxb6dlxOwS/?=
 =?us-ascii?Q?8vcJWZqIVKVo9gIadEjMdwG7JWAdeXIps294yCdehydA6gM3wmX/P0AGgPMq?=
 =?us-ascii?Q?sLEUmFf+iSuDtpA3IEMz8Tuna2jfGBWFq4Ym8SPWqq72CsggKABnbEoZVC5n?=
 =?us-ascii?Q?kVldNQKt/E/TU0zH0sLiqgEy1z47Fc6IgkCI6132yxfj8pe+PnYw3Mg/DZFl?=
 =?us-ascii?Q?W+1VuRz0Zi8/be/KWrIgLtoBy1Wvhem5Q/mA1MzGMpvj9uMotA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MYnDVh7l7Uiabif6JTb4Q3lZV/9VwtZQyWV3qw0zMojr8YN+Ih8KJHWhE6aJ?=
 =?us-ascii?Q?o07JcNerd8T+928MLLnexrECuZw1yOUoOgfRaIaeTZNO/p0e9DbX2wdwZwG0?=
 =?us-ascii?Q?o3yWBB+1MIzC9a/FgcwFy+Q9+Ow7xSqRE4antQog6M6EzRhhpNVXv9c/MduS?=
 =?us-ascii?Q?ywyGovTBaDnQCvz59EAMBSYA4Sv/bT8BNCVGwmYE5Z0inLg6NVV5RqOUzwOa?=
 =?us-ascii?Q?uDeWrWpud07/S0QNZhNN0BCGA5FpAGVWHeA/jV1OcT+8U2P61lm7PcKCf2DT?=
 =?us-ascii?Q?P05HbOXgsZBIWRYpL4DBwim1q8PCZiJz+IYawXJlOTUjBDA4sj6fmYWk1Hav?=
 =?us-ascii?Q?YsJqD8szZbX4QQZxjK/iKvZ5sOHay76uqoCvlpFHnVeE4+Q7JE6zUI0qEAS8?=
 =?us-ascii?Q?eU6UBwWER6Y02ZqRzWFXqDAWsbPU9Er+7KfYvsYUvv/ISZ5UDmiuzpeNUXH1?=
 =?us-ascii?Q?YSKU9HTDsjgYX/PKQp2yIWbpKw2py+dNvMuFvEGDhJMZDVq21wpjAUerFKwJ?=
 =?us-ascii?Q?5HKa2NjyKILWLjLPw3ZfC3ya+KBMZ4nIyq+J40C8EqhYX266GRpEEekkM86v?=
 =?us-ascii?Q?oEYhP8ffetSFIbZZUYjuM3l8YrTYFVGq7rVlVQy1YHxjKKYpa7jgdAzt5Phn?=
 =?us-ascii?Q?mU6dI+csyiWbtLKv6qerBh76TyceKR8f9CewlBGUA8i3y0xiftJhsApTxPMB?=
 =?us-ascii?Q?i0DuZTC23hRO7K03ikE5BQDc85i8Dk9q9BYTyDpEsWyjIaZivQBYO+act2MK?=
 =?us-ascii?Q?pnJCftUMRFL6fuPRcFRiEhQSFZTz+WT5288PTBBx9ZuNvMSXCXB/Qf5i00P+?=
 =?us-ascii?Q?Cfx8OGU3isSGUvXFmT6mPPkgdOixsMX87Chjs0HAI5Oebg1jYtJURr60ofOq?=
 =?us-ascii?Q?CPzkYjmvObJce3m5uPW9DfzN4WI6DlYZ0U23YLRcXLTndkDgDJabSfklmxJg?=
 =?us-ascii?Q?I/XoHv3vU9cqXhku0ADhzm5rzM1srCakXKtl7yRBrB2EyzC+ib3ut0wjUTxZ?=
 =?us-ascii?Q?60HoTvBJpv5w+9wX28zKE1K3d/Cc1FRk1QkvxGoNEMxBT7ngNGS4jDvRHUYf?=
 =?us-ascii?Q?DmfASDmPgnKUCfBn4cZJ2HRX4gS3chYX4KsCXA+9yGW+Vz00GNHQrQaeikJL?=
 =?us-ascii?Q?6Qj6RYU9p97sDnEcS8efEMtYeYbRWcQ8xIOsj98bJXYzWJAuZ8oTgzxCiBPq?=
 =?us-ascii?Q?f6JDYxyvCPLMpnrZ8M5UT2QjaIPbLuT2s5rveUk8k48YqboVeije03IX5i4E?=
 =?us-ascii?Q?MN8m2bwBcd1x0VjHFpp35o7akJQ+zu2DToXwuNxOFmS9PsnXdFLmXaO1bnbk?=
 =?us-ascii?Q?r5Gt4fwvnx6rHC1RxaPeUQ1nNNIiDifPlyyHQRgLvIN59xd2eZm7LWUBc5Wd?=
 =?us-ascii?Q?xmtJvNUaehIiJXT65QxRMxMtvq9QUlDigH0f0Y3+IXQAIEcVaqPmqv5qieyx?=
 =?us-ascii?Q?snMS3NdI2Yo0Syk8pSlbVmW4iJluxrz8a9sax352WzTizVNGx52Z/aJCja1z?=
 =?us-ascii?Q?/mdBTHdBmUJr1CxA0SIGyHQJMtFpHIYH15x4F1mVQWFMdiUFpoR0T/F782RA?=
 =?us-ascii?Q?KOHIq7Ns8s27J0B6lvXD/WDn+W0+W5N3GBcG7UHA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BMSUSd5gHrAsjTDj8SqTx2Jf+haNgtjdFKnML2qoxt0tY/Kqk5jDonCd7Z2kkiWAgLBjAq2/m/vRvqh2uRB4OSY9+P4zcTLtMQF5+2nLFkRz4zoX47A6QPsu2sGv4/W1y10O3RwlSSSJHARyrhmYzosjWFz5pJ+3Cjpvzb7FY5T7Lbeq+ET3C3bGwSZM+P9IuNuKNs/KFA523vjEInuGqLNHLUByUJo+QnQkuAi5Un3A/ejZCOHWKPx8mVpG8x9fbpLpDkCBFakO7yX2cbFL+FdVKqdjU7ExNUF2psBN1jbRoYryvljPIyBpPIwV0IEpV7E33vsy6LYulOfyvNGbOl0Gta44HhnuJcqmkgo/AsaAaiUVqDwevwfnZnjvmlnyu60I2L+ElC8Vd/6XhbmWQWgwR2zjzZcOj6zL17K9E+h25kqrdOaxu9eTtpT28mXc4oh0FVJFPRWR3hsYKVDoen+GlR91bIKo08tSeMdnlS9D1heXYvddd7hdJeATTzwpmU/KeG3XZ8kkmVws0WVA0YH9BegG8+YeYOKZsm0fz5t8QlyA8Kx8eMZQ7gxCS/5O0i3CfJkdUbRm7sIHgkjM/nDdf1YnqhtbmjhOqEYf6lE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4157fd49-376c-4f8d-705e-08ddec21b7f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 02:12:52.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULxpfND5OfF8/2pUHdhxSKXtPdEWcuUJq9kJXVdXevEQ77LqZU3nbhqp2DaGZyXUvXnJlNlmOs7iLScTykRDKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0316BCB78
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_01,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=647 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509050018
X-Proofpoint-ORIG-GUID: ahUYCspeAcJCtGeHn2Zx9mYeU42HsjFe
X-Proofpoint-GUID: ahUYCspeAcJCtGeHn2Zx9mYeU42HsjFe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDAwNyBTYWx0ZWRfX2ejEcfo15zuj
 jZK3wj+THbM2GJBMW/igSxJ7CMpt8orulNvb3mzg/E2UNH8nGs1kJXlYRulj7+hMcQXvql4yHov
 f1ZAknUMZxMv/9vV/bHWLHgMLZLNfU2SKsn7IhkegJZP3SoJz31h2iIH9KvXfDX2OvhvRzhaChD
 zDqVE4zc+5yKcj1r5nGJAY5oiXcjIDZMeBgJTVLvY8yvgeYH7KF6IzGM/7WZyWJc5XWEw4yAIeR
 jhjxUChB2BdOdPoBylPxg1gDst+nIi8SU1fY5pZuap4kK2pAeXQeXR9mcHtQ38JfL+FR5RmMqg5
 xEZPHMZaTlfynj1T1+f1XBzJUAUOc+9tu7TSyqxLBMjfwTRr9pJpWcp0/N4sVeC5Uq5OfAbyqlU
 1eDzeqCkkoRy6rHTl2ovjrmGujqAfA==
X-Authority-Analysis: v=2.4 cv=Ie+HWXqa c=1 sm=1 tr=0 ts=68ba4727 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=iox4zFpeAAAA:8 a=LRGD1cGKWB8DCKw1omEA:9
 a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22 cc=ntf awl=host:12068
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AB3CCA000F
X-Stat-Signature: h8w3dcufmh86sdfognohu76mjh1x54xy
X-Rspam-User: 
X-HE-Tag: 1757038389-81341
X-HE-Meta: U2FsdGVkX1/UKYH20NfPScYaaI5oPUnTL7VUHl9YqsXhCjKG3DJ1LuYYMSREqMXSkT7q/vN+ib5rHsW13kxG0TmzomoOxmNvaQ39R0X7xSRTFVRNV9zemFq30JngoXf5DTMCPG+GWkePrP+zB7djGP3ONBG1IY598kji3PXpxKhjRDthlBRRHIjhS6QRh2FvZ5NAD/EwutmJ6pNbV/4UfI9S0wOuuovNJE9XFg7ABMgZbXORcGP4UFXJ0me48NHaQOpaBv1zvoao+SuDD3ykPWpdBOc7tKHbX9wRHUCwDkOvc3ifLWF4K10azkv2L7BO0fDekjtRZOuLwCQrV4E0WwofEEkR9wyeQZo67NnS8XAzU735Q4wQSr+9l+8rDcpw+dXxEvvWdKy6dsIZexvsqlMnaf8+XwyqZ5X0IYOFOTHu2nkReiUc1HIMuh4/v9kj3MxqZf+QKVxfxivFSZpFRUTg6EINtNylnggqECGBI8TjHKdMnYTQXxM5A0ExMeO1QDYIP8o5ML+J/KVsjr8urN5dV/KEfX1Peg8dEiyM8iMhnJV8m3SULaQzo0YKkgWadDp5HZl/XPnxrKEXiw/WY/779oQqEx6QtHG/a5DNAvPPg0rfcLpPpFwU/mcS3JTaLq1vWyC/kuJXe6NcB/NKcXer+NARJRaflkP10dOfri+X80gZnPCJU7UV+aLa9/mLAvVP4E359/8HAWhpdA71eVSEgEJqzdULT8KSoQRn5N7VaRf9LBC+yJmxQ7Db45ZD67i06GBNpESAzwTCdELqgsZZtxF4q+S5bBEyk04aVIVCPg2/lyuqaGNrkXUjXCqZVgz3fpinQ9JUjBK883PpP9o6QkTIDtuODSowil0uoeCaWSmoY+OnZ62QOAHNIO+fneIYrN7W909DR3Gke1B0t6P1/7wAyVnO9nlhYjI4o3RPpW2KkrZGD5ZpCsQe7Vd23YsmIRivkkjBAoc3fbM
 kAVUF1ho
 0Ye9HLanmPjxGBO+Bvhp+Q5lQH0SRGhxkZ0hLfeaVAYd5KYDE7no/3/+8SQIw9JfcgX8rIlax2wVH8Urf/nGhuFeQ3fAL0wtjb0EsAJXje/NNTb2uhNQs9323XnrCAQt97WqdODiAb+Ppgb55rKouKx+zUADNzJsaP7bAd/ijtxa+VrvlniYGwCDvlgA4vSAQf1Nu2ycrDsKmFqP95X7q4dUtE10A9pdTOgRwstMnqUV9fddGOaCchebAi17IT8lbgCBN7s8XcwWc25Q1toHl1BjNhVV3IqQgyTcA8XQeTdwOUYaVFmMtmXCzIyfHOKbRRLvnQFOJJWiN2kmf5TfONSC1OM/rzIo3ZI3G5fsUx0dMdnCtQWiTNe37n+M4KEuUCUMiDdRBB6igoBZGvbLDuVFN4U39Pi81gc3bQ9tUrkNPPAJjAmBj1ZiQhLH/QrSr6KWh9105bPOhHAig9WDjg4sWCpOjnDF2cv2aSzbXs+Z2tiSIm2amOXALbbVYlsLhXVN80vVgkxbSLk3MoLsZouyiA49KKj/Nfk5NK8je4fcG5D/MTof1vaoHNSJvBXhwujNrL9AMzNsrvXZu+IQ5Qy2uXLEEtv93sDoisT/NNjTudwWJFvLzOkWzw9PUN+MfXq1YcnHr9h5K3k1q4J+i51ryDRCRh0EtPwuiUN/7rCqQCtD/DXbjysFUluK69TloWKZB9khbCtZBDbgy9PNYijwNY8F+o1DC0jjhpzXja/qjAiWV9MPEXJy8gwLHwvDIq4F65Lnz+O6lSa895Z2TEYmcK/EUiKiXj5VlczxO0uRxny9RO/uQC55TMKjBYjYsqHpeMOWspZXK6hM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Michal Hocko <mhocko@suse.com> [250904 08:21]:
> On Wed 03-09-25 15:02:34, Liam R. Howlett wrote:
> > * Michal Hocko <mhocko@suse.com> [250903 08:58]:
> > > On Wed 03-09-25 17:27:29, zhongjinji wrote:
> [...]
> > mmu_notifier_release(mm) is called early in the exit_mmap() path should
> > cause the mmu notifiers to be non-blocking (according to the comment in
> > v6.0 source of exit_mmap [1].
> 
> I am not sure I follow you here. How does this relate to the actual
> direction of the address space freeing?

It doesn't relate to the direction of the address freeing, I think it
explains the perf data a bit.

The exit_mmap() would have a decrease in mmu related work while this
thread will have an increase, I think.

If they race, this thread gets virtually nothing while exit does all of
the work.  If they don't race then the work is split.

Does that make sense?

Thanks,
Liam

