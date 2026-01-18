Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED2CC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 11:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5691A6B0005; Sun, 18 Jan 2026 06:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540636B0089; Sun, 18 Jan 2026 06:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4C86B008A; Sun, 18 Jan 2026 06:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26B686B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 06:45:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9872D1F1F
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:45:33 +0000 (UTC)
X-FDA: 84344904546.26.693F95F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5F0092000B
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:45:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nm6f5+0t;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BbMH2pkA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768736730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLqhq+7tcdDau+GTfPnJkPgzLHsqn+AxDbyZZA0005M=;
	b=6sLO+MViTYnvkUUgeTOWv53kmpcxqKhA7bPEnIqeEpjvWhUs8lk6Q/wenfP2XvYiOmxEXf
	LmQxZgN22Grb/RV4E9j+Gg99G56b76RNXbBBIdnzChMJpDCNl7R96qblZTGBMiOQ+kSaHO
	SxbHKKGe9xWXqcHLtuvafiQMRY8UhfQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768736730; a=rsa-sha256;
	cv=pass;
	b=Sla3ed3Tmj0GJjQP1VBMIy8urlnBFGW5gBccxWBrqmZvV0QmeUia7Zgpa4pdN4hnl5G4Mw
	VpVP3jOjRlgOj2VcUhRkFT/Nv4XQFgtuNw0NEY5mvLvpbjHy5VZx4e2SGWZDU1R3ClsSv6
	uCg091kuQqIIO+k8vFZxasSwRBoZ6v0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Nm6f5+0t;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BbMH2pkA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IAne5o3976291;
	Sun, 18 Jan 2026 11:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gLqhq+7tcdDau+GTfP
	nJkPgzLHsqn+AxDbyZZA0005M=; b=Nm6f5+0twLAFYYgMaAK/zrXOK36KeskKNu
	yz6RSSFPxhyPsM/7D/LfaQPmU/tIBae8KF4DxvJgKmrtGe+nowvoMDFFmf4T9Xvt
	+X0vHT9kMBAnNjGLx2RASiOboR6Zm0UJH5KC2um18E0vAenchXRThWbXSibHMIGj
	24CxEDU8ms8O/9ynuHL/k9SRuyim+Sbe8SZH8+1b947b1lZcFqVTbnXF7xXMLcbb
	4TUaEvbukdSxeBDhGxTZWdR1fNamSqrEnKIEGCXDZ0utwobV6d7Ueflc+fHGrqT0
	N1MQA6fg+t5LpIMiPd/JsEI4bsrbLy+IOIijtyDQ5nQSCmOHjodA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa196c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 11:45:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60I7Xih9039307;
	Sun, 18 Jan 2026 11:45:24 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v7c762-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 11:45:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hOfPicYq3ekd8HraKBHctlGQC2nJW4XypQwCEhRXGWpi7U5XMZ+Q09Cd5RyLQe01NtGnq2sebh83qW+oXdTa/1Zu0638QC1sgfHoNKvW9jDfO2U1SqbyJDBj5tKRI3hyDkplkYWdBmAXwnPTzxyrOfJo7mXpr5hXHPGefhKbf/obUMu207M31t3NmDxJgxCHHVATUOdqzTZsrKnEKcUtjboGnQAwlX8ICL5YTyobMEvmMCOff9C8VGxaCIrM63A9Jk06p6n1KHvURpnBf/vNnU4aWMK4HnEtJBhj8xBH7mk2bCrzAkOL65vWwZMctoL+QJH6NYK6k1k4dWCLL7chBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLqhq+7tcdDau+GTfPnJkPgzLHsqn+AxDbyZZA0005M=;
 b=NeVxLil0W/n30oA8txEcHk1msCfRxbwjwVHzWe2T5ZTOe+jloOFWyuWBMjZIs3F+w8HohjMLdaVHpJnZsYSlrTmpUCC3iyHR9C7Nr1wPuhHMQqEw8KXc6PW+IGibk5QzqK8IPjdoGsCtSRbFhC0B969sUzX1xTUHyP1t+V7gEZZvDsK0c45CN9S9mIzG9OdJy5Z6oxrIm4VezwRXe8Ldl3y/ZhNRW/2pIfSStwAAqHXt6bmmaVDHRhApuL2zuIPpyZBs87QUyGf0rGk/OSbFPylsg5Jdqz8KDX52KoS3Sqz0RouqgHB255virXa4fAJv4vKyHzivAqutZwAD+opO4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLqhq+7tcdDau+GTfPnJkPgzLHsqn+AxDbyZZA0005M=;
 b=BbMH2pkAtsB8clrUIH5zg07nxBlsyZbU3OD6hLlYTmj3R0+XZfFsvNdKq4kCJDtEMIQdBqniWlIkM7pQ/mvYfaof2K21efZmxrw5WXiTQWd/zcPeuPQ52iDeLgewyNsnBZATbkQUbnzH8TiJ45PMDzf6vdXQLMyHIGUJbYSiJzo=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BL3PR10MB6185.namprd10.prod.outlook.com (2603:10b6:208:3bc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Sun, 18 Jan
 2026 11:45:21 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 11:45:21 +0000
Date: Sun, 18 Jan 2026 11:45:22 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/rmap: fix unlink_anon_vmas() handling of error case
 from anon_vma_fork
Message-ID: <99510e0f-4cd0-4e90-9d0e-2fc8210e56ad@lucifer.local>
References: <20260118105817.1270617-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118105817.1270617-1-kartikey406@gmail.com>
X-ClientProxiedBy: LO4P265CA0327.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BL3PR10MB6185:EE_
X-MS-Office365-Filtering-Correlation-Id: 15adc470-82c4-4a77-ed9d-08de56870f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kK4Rrmu5rp1NgdaOAAjD2GO43+iPWNSKG3uDhSURNCz9WNDY1ZNfnV71h3RS?=
 =?us-ascii?Q?YBIJ/ObpgvcLTCB00YC7M0DU6KeF3vCul6yL+F3isVT8Jwk6m1YQDPnJQxUr?=
 =?us-ascii?Q?GxmY+UDZtoCg6fZJFsESQg00MzyVO0jDo/owYTzAqbtEC9Kx39A7szjqENB8?=
 =?us-ascii?Q?T8yCBM9RGMX9c+k1n4f4/SCPQQbYchJYvLDAKSsibMq5sog0hlH4uZVRLTVR?=
 =?us-ascii?Q?8kIXy9RxOw4tZQQlDdzVFqEbvAaVeu4kn226b67epRqEenpyC2Wq73tAdDxF?=
 =?us-ascii?Q?RROHltJDbCQ0esfEsRjoUNZITla5w68kc0KtCV4Uv1PjESvgEyeWihPzL48U?=
 =?us-ascii?Q?H3Wro5dmsQsvFty0nx12L+mVR1Pfl89MAwfdYM1Dcvjs9ZFgJ5MywzScdhjY?=
 =?us-ascii?Q?7VB6nkTXJMCLl7Rn8Ri8SttvhfkjDWmJlBBfDsPcZmhoqH1MMIFME6nalmGX?=
 =?us-ascii?Q?XRxZ7iUeShW4NwU3lJMClJmTLYOxzxze2bQyG7byWPjOzGyyUSW8Gv8dvIIC?=
 =?us-ascii?Q?IXw0ePqIInKn2yB5kyoysStzRkhIUPTl7HHesdTOXlr5lzh7ffzulmZlLjL3?=
 =?us-ascii?Q?Us2n9D1J186cURJblPj2lxHU3kZkA50fv5tx6uxNYQ49VmmFF6ohH995aaT9?=
 =?us-ascii?Q?K+anB4wsymzvvkM0dnKqyOO3LUByfKi7qsftLOXq8QH9daHUMAsqIqDlVyqM?=
 =?us-ascii?Q?uGBgt+S3WH3oaof3lWndqGm5BOfIeyRwt37i5DVRqrab75V2yxLH3yrHvWWE?=
 =?us-ascii?Q?59lgOYP8QshOMjQNvQSbemFkygeCKUlLuC6kD37vTH2HGkgJJziGEQ9XXcVI?=
 =?us-ascii?Q?rgjhV0nNzOgkT97xZK9eEIQek/k8pNGjHSDLbWD6yKHbOlTHLqzGJaxRDLQN?=
 =?us-ascii?Q?gAdsmxw8F++2yKlayj83e+pnVFfheYrHpGNGMj12/MjaCWIpB0g7kDpZsTBX?=
 =?us-ascii?Q?GXgFdUWVAeaqNvNqNdXO9qeEAzYV3wMJ+GMG19WCdFkmDFRYHTtnwbd3FIcD?=
 =?us-ascii?Q?7LGTQhVDY9WfnWdoqdaJl+nNAtJe7k8U6BvTevD9xRWZj7DVudunHYjUu0yz?=
 =?us-ascii?Q?6lM70XWPXDMGlBT3QI3mHoA1gt1B3slOmWG8bAUPtsR+L8WnQWI+yS0an2bP?=
 =?us-ascii?Q?Hfkljk91HSdgQh0LFUGTmpCWgN4di/SNQ7GJGRuVj9b/oxplHk4+hlamtP2u?=
 =?us-ascii?Q?f+cKKjrXgQ/HEP2f6vp1UPhrvBMblgykoN7H9wvSGMA8RW07edG7TAqRjv8S?=
 =?us-ascii?Q?ax3jj4aKLFOPYpj0gHFlA5D4VrcLpfh+QXlmu3OguLiF3BaU1wcokvFODF9h?=
 =?us-ascii?Q?XK73AXJ887eKygf0B+9BX5YfpHBIH3I+97QxhbSF6tSyWJEwi3FedfcK4xvc?=
 =?us-ascii?Q?7KYFAzvGZsvS363YebeF+lQJqgpv+pfawe6EgvOJ5xcPtXcnRhlNe4JlLsRL?=
 =?us-ascii?Q?3AGd0TYO4Jnt2nO90gcBtncSKr4FZbR6gqg1UEaHoKP3d1jqsGHuEtq1wzRR?=
 =?us-ascii?Q?9hZr01wK1U/OQZwpnICSQtE/3o0R+dmpXqrI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F6tKSLOLxIAUF4P4p+Kn11IrbITzabivF13c9hURAHu9S1LT2Vu8wqshhHs8?=
 =?us-ascii?Q?2k9HgleCrH1IQp5/9ZHLGOmA5gafbIPCTNBr/VyC1CNfbC42vg1SmIF0eYgS?=
 =?us-ascii?Q?o5fJNTq9pWn2ULlCbtl0A3XQSAbbkZjsZAOFvX/rBfG4u85Q8/oZkiBp6sVX?=
 =?us-ascii?Q?OLyEcx3nqR1iMvfwWxnHUl7hoJkfLnhjZmgHIFfcN6KffCLskl3qBotMFfv+?=
 =?us-ascii?Q?IESocRm2omm3Vmu/NFgO2kKmgm6OvHXovEXKN3FFJUDNGrBqXnGOZMY/XNUn?=
 =?us-ascii?Q?VnixkZKXSX7Ze4oijA0Eo0WhJyjA0bZIxUjkoNDAEL8vXRim2ChxkJzyTzZ8?=
 =?us-ascii?Q?qCdm8Dr/fS5kYzW5rnnvVFrPRcrWQpJf1pqOyDP20B8iT/JtzdoaehEEJlkL?=
 =?us-ascii?Q?k4+vdtaRS7GJIEAq74sZuzgYli6BsFe6pm7wUz+mNYzxThOBjZ1rOofz9CRA?=
 =?us-ascii?Q?35Gb492Tj5m4wSjKyGnX+IA/RNMjrCiIeQRj8e38uto37n8fSqINbkOLJrnt?=
 =?us-ascii?Q?uBPm30GRYYNWQRDAT0pWm0a9Q4ML6D/Y6myvUQkjWKGYZwTb7LOje/dyOA64?=
 =?us-ascii?Q?RiKAaBNyDi0Iwv5Di11xbWebXY2HMHQQI4JrF0EqOMLu7+UZy8UkSglQ9+Ad?=
 =?us-ascii?Q?nzV0yzQQ2xLtBJoZa+qlAqV5WuQA+WzSNUaowUryVZEoMiKoeM22KQx0IOEV?=
 =?us-ascii?Q?/470pcBa0LTyNi3yVTKOLWKT0Lux/B9uLNvT2UBAK4l0/SrRDXNUwUE/X4xo?=
 =?us-ascii?Q?V4xEi34htGNU62w3fVJwR8y9UC72At22IXEAfeakqYLJ+cbHb/lBpMKRsnSD?=
 =?us-ascii?Q?7unmLW+tLaE7jTml6vC4a8G1g60pdZwZ0Cm/42oUUzZOreei/Ghu66kntJfK?=
 =?us-ascii?Q?PpD7IN60PkskUCLM0bkYnZ3CWVMgVCLU4U3pckkorpR+FeN0jlAFqPL3SDGm?=
 =?us-ascii?Q?h+tvXfBT+ebUp+onj0bRb0odRp6X+OXaWybDjwzMOl0l4Cik/NShnNz+aB99?=
 =?us-ascii?Q?mJmBdVBA3LeLmnjrY5hK1wPGHjA4Cs/m/bqSpkRTMKrO7hrCdQu8AtUQtvK0?=
 =?us-ascii?Q?O4LgGOWAfq3FGLr7+4q4awdkat9sFbfjRykQRgl/pyEAr65ZnHUb3EHnM09J?=
 =?us-ascii?Q?GiysaxufA3NYlvzd3ZMMUzQfwZRFJ9apU6JWel2XE1TO8+sruzJ435qhPsYy?=
 =?us-ascii?Q?kaOc6Py7bs9LodhczUKJ3XS2Qb+dnU8feCYJtuna1HufZWLGMsAUNZY24S6f?=
 =?us-ascii?Q?vDtbtaivB9ItlsYN4xHgcWBkrbEzRd8HwDAEMe/pKn0QD9E6oAxdHWCHxCn9?=
 =?us-ascii?Q?0IaUIspm8EyYyVoeVwI1Am0/cLPkH0ZZwCL/3c3Ha7ovyNEgtrhAd02m6w6e?=
 =?us-ascii?Q?WgxsLoZnRa8EzFD8/X3KMOBXfCHpWaLgjysDvY9V7a8/lx/sRHyZ4ec4U7x3?=
 =?us-ascii?Q?eWEneNOdrpPD7T7r7/jFuHVUP56qYxoQiEAfDTQTe1uOFaezcG2OpAV/Wkhw?=
 =?us-ascii?Q?bPce8LyLunkksZ2fRFQMXM/WjPIbIMTSEdXFXKM/fPM5i7F2+EjhngQt+li5?=
 =?us-ascii?Q?QEBo5qjwfmeHfw/JuPL3k0GRbZ9u+CreWVH+jlK0/E2E3NCOGi5RJCJKOovN?=
 =?us-ascii?Q?QqHfcLh+H/IseV69YvpvfmWNT43vFcJvpVw13lQ2oPSQ58PWDr6i2wtXwM59?=
 =?us-ascii?Q?hMg5KKdFm5M3uMq8YHgq0p7tEpXD9gQyZRhuMZM3QulM073qpiuiNMnShIKo?=
 =?us-ascii?Q?Tx7TCo4RtkaMpv9dlS0iXeJDA5MLAyU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3N1zL7eom05bkjv/frxAWsPxC8tSM1zIDZZjXz0cqK7XtJWaDOXSJR90YO/IxzbH/nf0ujGGxhB5woD1SSNI5Lphnj/VrtEBP6J2g3/mJf7Q6FooJR0bV7GOavsh6rKehYp3acukVkZ+cD77kpWsOq4QRgfWixmIaD+EHN28BzLKX+n3rsn+143DdbcumEyJIK5czVNf0cgj8LIBeiYy87LS2J7RNbF8jGK4EPGOag+t35+MAdXReOUCSHJOov2TqUrAkzpm7aaJnd1chFCbJLhY2bUYmRn2uy7GEWBRsN4ZH2Qq5HMLdP1J6U81wjyTsQZsRz5uHZ3eAvy/0mD6iePXnmrt+tMYrhJDtM6PPdhdXywRMpbs03HL4XFJXHOoHnFo93hO2nFyx0Wv8Abv+EjdaaVhR2IJGbldJmc1AgAUQRS1toEQrZBgVDSMcoNEC5LBUsw7t6X4r8mqDcLnB9vzyvCZzWkYy+aQc+PKN5h9paJKm/QgUg9HhoYhoDR1O9Bax3U8MTNkjVkzGPZsi57LQ4rFC/eqg/0gypjl1IBIc0XBQWrQ6t7FY9oRClZKFnvYGBqRkbKK62C5NGsvRogTzPBB0jDQZT4V/AgF92I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15adc470-82c4-4a77-ed9d-08de56870f70
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 11:45:21.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfjnY+93fyvvdvjT/C+iFbFsM+Y59bjb22sR28jh24ccCuDMdarecUOM7WLdMKEqei7y+6E+gtilGbSUWhaLt5LJEWT4EpUZL4OPreSwkok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEwMiBTYWx0ZWRfX9VW6bME6lf5+
 383IGPACcr+nM3rJ3qXlI2HLfoUEUA1jFIo/6FzrWTbQrSXgFEPU/xuBtV5FVeLs/g0oZKsXT66
 V+fIcHH+8TAzRUWbr2AcUUMOahfeSwBsC43Iv/E5BQt01m87+mh5u20oaRYuCRbfWLX8iBf4fkK
 IKePfrImYgdAMyZP58uga6ob8RRMPDU6zxl0+sgT8w+ibEZ48nTs8pZrrNVrn/hEmJRFiQ6MbZ2
 b/HamwFVI0J6bAu5EPjERZjAvMQUmABmJYuscBeJmpEf56VEO1x12CgJvuTR0zgMTdb82fnUddn
 r0aev0kJxDRlTQpWJ2KoAgAbq/LSt83HtM1vjXxlTLV33/4LMHZggQpZ2GRjOU/NCSX67IkxM10
 k6Ix/mvVDHtcRKW6nwA+QHCN4nH8lsPJibH08UqdMDFDWEqPi1kvDcodI94oeMS8RGB9x2toPmD
 clx5XHy4cHeHuucH5QA==
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696cc7d5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=pGLkceISAAAA:8 a=ukq55DKO4IELoH8-yuMA:9
 a=CjuIK1q_8ugA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-ORIG-GUID: asJfU2xLTQheKd5ksGGT_7pNxOUN5rbk
X-Proofpoint-GUID: asJfU2xLTQheKd5ksGGT_7pNxOUN5rbk
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F0092000B
X-Rspam-User: 
X-Stat-Signature: hnmymaq58ah1ruigg7anudbeuuzbuyb3
X-HE-Tag: 1768736730-947937
X-HE-Meta: U2FsdGVkX1+U9WDGa5GiH4J6XnrXHaKPM74U4ZAmrkhCINZz4WgeE/H9gyRuS7eDmvxy91ryF1yPBvsD7b4GySFrZ6E1g7Tk5r0DLONYXFRgwGdSPUQQ8FfpuxiUs0VmqpJwXS1uYSGZhs0GHEoohs67SOuU9MovtR0NUMurPeYXRcUgJSkzyWHMgL5JxA8mrEnWcwLLAMPhNKnHTOfIjyiQyeRhUzfcTtrptz75v/G3KyKSLDYp1I80dGxo8Fobg3+exi5Om1e+YVxN/eFSftVA0EdNKjdKwVUtAW55faf0svfG2KmRWCeB51t4cwI4190CMAcpambZ+FAAeklhm/ALmvH6n2QJqEYPRP7e852RU0c1jCBHtfSSCWrkQbGPOIoC0JxWyYITbJLiVZjp4dF/+GLe3nA5fFOzqK/xve0k1FgYze6A/x0kDIe8p3w9dTZBwWmc65vVzSgqKR8IFPQmzT6yRRdKm+n1dzzD5XdIRxgpxGRcHY1KdZ1y08Y9z6vOWm2p6fhstT4/bx5uxkF8G0TwFxOUhqvJ+46Q79nonyne2siwiF/9+uTv8kFwQzmtqH1SWhdW5SVPlaM1HPRrIJx9CwdbzbDrFmL6o00eg1MVA5O5YlESAl+P6i+wkwFavcDBW9WewZXwQg/3EqpJguMVJv5vSOO4m6v7pbmLxIq5tyk+/xi0U2MpvsXNyefS8UACOLM3eSMSTLp0NGHVaT9xGQ1pXVMEBAGWP8/dPYKpWWM/yfDEJg4If/rgjOCiCST5jlKwkZ+3X3aDfnTuAZ+IrwKUphLa30Y7xpjil7+In+s2Wkx4KxmtF1AA2+rOFHCucJ5Prr+9Yb8Oot/X2vcBcghhKXp6iqmfY3eXoYIpWwLpxEJgvzUmKhGOQlVDyP9UZUTj1PoqFlN7+vmUup3ZibdI6sBoPtv/2jg22N7aOyCqI/+zxX0Y854m2j2Mg7FN/If2f+nW87J
 v7DisNh2
 IworB5S01nA8+TpcC5VXBh0Xh/2d0kwiMaNNjJ766StahQ6P8ICX6stb2b+Xc/LgCbmvJlHU4XVfHT8Mp96u98A43oFJPC09ouxvdCaFt6P2QZW2c83HBlXNGivkfgBHEK3ZMJDCxmlDqF1WjLo0Gc77TpN2b9YJuBxVzynW8hFxjEFubfsZWuEljXqbKS1w7QTGS9PQWTREZgZZG36IsirSuzFg3y+ji1t69EJJu7f60eRv/wXed5j7gejWrLKB7LdPEJ4tNlfxMoKoCJD2U9uFRwIcn+J/+rpH/JHlZ0Q2VefCnoRK2cKxorCyHJWs/SJtElZUcLJJ5ooVCPZrsoOgD8Q/gs7pDiEalDjedlaCmjXtxn8cKRe4Wf8KaHd5q8YuSzu6B6n3KGuCFQcbN5oYOmaASUbkjnbDmWN2KPWu2kxeiXd5FeEBTLFWxhUHLlYP/CJS08dX6CGa0HK4BqGkbRPJ0vnD2uG9rTiWPNeDJPYNnBk0r74Hh1ICwZIDupx3oZWl5vLAsFlgX0kR9OrHgSTnq6I0O/FkboRjbt0aRgUZSoDPR8cX8cxJ5b+BnmJMNztpRovPgP4hIT6LFLMF5JmgxQhv9BGK3NkJiDHFk3TLyA+3xfixs+2Zxbz5clwHuULJBxcciRAIznVqRjFQzsjimy7FcmACRFAn9UdHb7bbzJZFYlpPoYv8WbfkAF05We5Tv0pPLRvz4TxM5d2svw3xm2tC5nfXjM9nb8qJlGIe2ujkK0+FsofDd8iT77r+kaUQmJctywrzhtrV1+8tnZWFYnXjXbkP26lARMpgaZnMoyhGEdyxowkIoN5eu+AQUqq3+o4qSahbfJjU4L6sOrfhp3LZ6MSXL0jcHo07CnFRg2MmMyhZsnTL6vA/1Nsl1J7h89NYNrveQan3grN8o9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - please ignore, I'll update my series to address the issue.

Deepanshu - thanks very much for the patch, I think perhaps you are new to
mm so you may not be aware of how the life cycle of stuff works here, but
in this case as not upstream a patch isn't appropriate.

See below for details.

On Sun, Jan 18, 2026 at 04:28:17PM +0530, Deepanshu Kartikey wrote:
> When anon_vma_fork() encounters a memory allocation failure after
> anon_vma_clone() has succeeded, unlink_anon_vmas() is called with
> vma->anon_vma being NULL but the anon_vma_chain populated with entries
> that are present in the anon_vma interval trees.
>
> This happens in the following sequence:
> 1. anon_vma_clone() succeeds, populating vma->anon_vma_chain and
>    inserting entries into interval trees
> 2. maybe_reuse_anon_vma() does not set vma->anon_vma because reuse
>    conditions are not met (common case for active processes)
> 3. anon_vma_alloc() or anon_vma_chain_alloc() fails due to memory
>    pressure
> 4. Error path invokes unlink_anon_vmas() with vma->anon_vma == NULL
>
> The existing code triggered VM_WARN_ON_ONCE and returned without
> performing cleanup, leaving entries in interval trees and causing
> memory leaks.
>
> Fix this by detecting the condition and properly cleaning up:
> - Iterate through the populated chain
> - Lock each anon_vma
> - Remove entries from interval trees
> - Unlock and free chain entries
>
> This prevents both the warning and the resource leaks.
>
> Reported-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c27fa543e10a45d4e149
> Tested-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Thanks for writing a patch for this, but this is not upstream yet, so the
right approach is to comment on the series thread, where you could suggest
the patch as an idea, not to submit a separate patch.

The series will be rebased to account for any issues found by -next bots
before going upstream.

> ---
>  mm/rmap.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f13480cb9f2e..acc8df6ad4a7 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -477,7 +477,31 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>
>  	/* Unfaulted is a no-op. */
>  	if (!active_anon_vma) {
> -		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
> +		/*
> +		 * Handle anon_vma_fork() error path where anon_vma_clone()
> +		 * succeeded and populated the chain (with entries in interval
> +		 * trees), but maybe_reuse_anon_vma() didn't set vma->anon_vma
> +		 * because reuse conditions weren't met, and a later allocation
> +		 * failed before we could allocate and assign a new anon_vma.
> +		 *
> +		 * We must properly remove entries from interval trees before
> +		 * freeing to avoid leaving dangling pointers.
> +		 */
> +		if (!list_empty(&vma->anon_vma_chain)) {
> +			struct anon_vma_chain *avc, *next;
> +
> +			list_for_each_entry_safe(avc, next, &vma->anon_vma_chain,
> +						same_vma) {
> +				struct anon_vma *anon_vma = avc->anon_vma;
> +
> +				anon_vma_lock_write(anon_vma);
> +				anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
> +				anon_vma_unlock_write(anon_vma);
> +				list_del(&avc->same_vma);
> +				anon_vma_chain_free(avc);
> +			}
> +		}
> +

This is very duplicative and works against the intent of the series.

Also this is a 'impossible in practice' fault that requires fault injection
to trigger (a typical syzbot scenario) and adding a bunch of code to handle
such scenarios makes little practical sense.

I will update my series to address this scenario in a way that fits there.

>  		return;
>  	}
>
> --
> 2.43.0
>

Thanks, Lorenzo

