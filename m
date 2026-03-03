Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F2CEC0495
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5DE6B00B0; Tue,  3 Mar 2026 05:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986EB6B00B4; Tue,  3 Mar 2026 05:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8888F6B00B8; Tue,  3 Mar 2026 05:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73C336B00B0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:10:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2980513AC31
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:10:16 +0000 (UTC)
X-FDA: 84504331632.25.C568A13
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6808C0004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:10:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gSt2Fhr4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e2SUD5VV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1+vtiP6iuYRoDal4tHru9xjXhw/69MDIVP0mD//nEM=;
	b=q/x6PweudFJAXEXgcfn6SyNaA++f+VX2VQc9mZLVkMbwVx+o6nPYFWvAh7Av/7Se0SbDiY
	pDoiNMSvkQyQcQmWKShZvIFWFlf8v6u/tdLATzYi8l9vjh1K3EJrMUUYjlyFzcTJLfVOcp
	wWG915SDFJNT0oPuBrddQ12K8JE5XW8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gSt2Fhr4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e2SUD5VV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772532612; a=rsa-sha256;
	cv=pass;
	b=vLw6hEXQ/4b1L+lcZb/QZ6bOO49rb/efcltz6Xme5/jMqajp7vhw5TFZYawRH8dOVU1phH
	oMYIFXSufz0PPhCLTDOeZor7blZdN0MmE490rPuaKAeKO0i6+sq4L10KiVTDsnTphGDp3h
	h7kv5K4s9O8/SeGSTzRtsSkOYaTJK8Y=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623A2FoX3791330;
	Tue, 3 Mar 2026 10:10:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=U1+vtiP6iuYRoDal4t
	Hru9xjXhw/69MDIVP0mD//nEM=; b=gSt2Fhr4mcf6PY8uOyY3LnOqjFa9dTvhpa
	5yRpgVeCrJ6SB73TeQkghsckaiGDU39NAbsuzBdLjEIFjjdh/kMj9jzLcTHMtjI1
	5/boz8j3t/bEW/P9N3iNySQttflx0Ucc+IjQly+2Sjwz5LwlsLZ0biGxjqeeaQ9t
	3c8CkDfQJzCbW5FwbvGoAxHh8ld6Iy0ATqSH7j2+7vNiI49PN7qGT2LTpeLPRUUC
	NH0y4e0MG5MeG5eokYacGobtkEKIvfc7SBNbAlLZOmSi8E3xdQvGWhzvWp0+6ubt
	biRRDPhTCy1tQBbfRQ31RE0XLbMKJj5igz3e8lDHvnwuRbU2VaKw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnwhpg0fg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:10:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6239Zhb9023120;
	Tue, 3 Mar 2026 09:56:18 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013054.outbound.protection.outlook.com [40.107.201.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptedmya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5yjM68Mvx8kCnsf3LGTpY8h5UcPXhgO/XNZYmQRmq2ujGXC+bGj7D+m6NtpOeTxhhuJyz9vqGcv1s7/5LDMiIxmKHfLXh/3EWAPBbAnYhhNnwnfZG2xGptUqlDQ5FReEvIEA0i+Q0nBAZj3klafbPwEl/D8E1g5Zd9pif1hisXqHMBWBkMWZAJsxhu5eNoylpgiJPR8VaJoa+80FLIv07mSPDpL90XjPTk0snspX4yo2szbEWkApB5hViZj2MqQKwvXugS2iZX2zn0FJspYknpxHCz/AxDPKlEY1aqOeqH8jFw9bT3Rb6KOIyixYeoOKd46p3QEjdqDvsXdnUSWlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1+vtiP6iuYRoDal4tHru9xjXhw/69MDIVP0mD//nEM=;
 b=HEHnnyJY6tbP9oWiEBHis+RgQzAlymawhSRh3kLYq5y2xhUac+Ce1XlsFPpv9S8OmOxNEJD83KS1Rizka17TfOvm0rsqG8mEYemxfxcxNlKs9eo4KK0fKB7f/A1LTsRxf/98JCS0A1epy011Br/5Iu+Tdvk98EBm9VZEotQCdS5VvjFpLIF3PCvs9fQX2l92te0E2ZRwAd/8UCM5scyRgXJEt6g/7aZ4UmhvTeYwMDKwlZ9GhcODqP12w7ZKP3e3u1GB3x11YE7RfjY/lc16iiBrDaHCSuET2stWYiMxl+OblRbQt9QZXCDkmjmMeUSG9mdR2yqKBozYCqb/XiownA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1+vtiP6iuYRoDal4tHru9xjXhw/69MDIVP0mD//nEM=;
 b=e2SUD5VVb3owE+c/rTGqnIDPkrk0BpYOJzlSnUX3Klz1y3eJojXWcKt3PnG27AWs7mXZ7QAIRO5CVMuj/63KHrToyV31h25YWRcE4gRMGNyoA1PAYl4yc6iqHwjx9RwS6cJ/mClD0MmxTcKIcBAj7dLTFynXEkdtUmYtktEnLSI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4564.namprd10.prod.outlook.com (2603:10b6:303:6f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Tue, 3 Mar
 2026 09:56:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 09:56:15 +0000
Date: Tue, 3 Mar 2026 09:56:11 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] khugepaged: remove redundant index check for
 pmd-folios
Message-ID: <5d576931-a926-4d50-8e5a-97a20097e734@lucifer.local>
References: <20260227143501.1488110-1-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227143501.1488110-1-dev.jain@arm.com>
X-ClientProxiedBy: LO4P265CA0144.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4564:EE_
X-MS-Office365-Filtering-Correlation-Id: ec83f881-b118-4a48-5b36-08de790b1ba4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	FQ/2uHKCDDcMb87AGJmwBSTPbxlrVnRs/SI0ffYn/0QD207rRUt2wBVPODkUBACo8hbCEB8RMM24eaer1+LwOCWuFAhGJNPjcdZ2VdHcbeakniWhrGU0eX1mfw3MMuAvp+725RgFtR0zI+/0eISwQBUKMz5ahIOvn17viLbXaMBFaNfoAxwg8cyb/+RsX9htKMPdKwlEW9m45skFpnX553MHTtqtnItXQVpjyOkExW7/msLVdQCmGKDtrnn2iFTG/+RzkmIPz3h2plTHwRs0UmnlZlYpiIZWAtPWUKlwjz4QR8dbNEL0QMWIdiHNzQ+a4ywRpzkCk6+QKxfz37HqUrkRDqKRFxLY03Q44SeUMS3B6mApjBjvdkQyuF0udU9vqMZICEYrA1p4LzrrwI3KykcsGatZIU6j1c+CMmM9j0WTTIhtfo229LRx85rc/enEE1riZFgEvaOygwHsF89RTGCYkxnRYt76a5F4Qzo7kZitb6eVRkloPyAPc2CE3+srKNnUjoS4Zkbb5nyfCBpYFmGMV/jjzhLQ6VNb80LBxX9tS7PLtAGHE0vC7IHNDyAJ70NoboNzjfc+3dG9zjBh5JG5f6m31ORSMhYoXSt3njV3wRk5Ejmyx77M7wnv7uFhC3mcDWlaiFJKheTkD10F/Y7KWii6BZibmx79zlFAiEzPWbKUo12ffsLdKg6aoXKI13z1KsTI0sayoYAPn5hFfI+12jt2HGMr2CrrnsOqt70=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XNd2v3VHUL9e4+zTzAUlAAy9UOlGsRTm/ZITStjuOc1vHTbXp0kmNS0y7Jzq?=
 =?us-ascii?Q?mHepYBXwZmeBTJsDy8Z99DU9BgRlu2zXUz97Mtp7WflEyjCCLJwSqUPQ7j8U?=
 =?us-ascii?Q?mXo441nvMMVD4iKQUENTTvU2Z9sMmZHooAjC38C1FcT+Gf3EiWI/K1KzzQTw?=
 =?us-ascii?Q?vgOx5YuzLNc3tyvGIFbX154qo/6lDsUy/XdUjaRawIM3H/T+Uu7iUktT/KMZ?=
 =?us-ascii?Q?TuOWrWzcRYETQ2KASfsBUH5qJuEkegQMA8Cx9yajb4CWSvfos+DzLQMk8iC+?=
 =?us-ascii?Q?/zeFA9mV6kbDbbiJAcEG6gDoYk9Y1ustPddYORbgj+gvokW7fJVImlsrMiNi?=
 =?us-ascii?Q?HTH3tcL6Jox9KIvXutEl7LiQExmku77nXt05c9jP1AtEAf+v7O4fsXC+GZL9?=
 =?us-ascii?Q?N1oAelX0dYxBZOF0lc7vb0ZEfL6LAppJZpRqZsqOlF5jFkRSxrrWm19OglG1?=
 =?us-ascii?Q?WYrxH3WEXHbvJb0YBc2WYJf9/Pc+aWSF3Y5ZvjhFO1likE+apZ9tNWTv/gQM?=
 =?us-ascii?Q?3VP7gu/e0DhkwCYYv4emOGr9tDSRhCa+CeO2kE/wndwutmktlLldxf4bO3/k?=
 =?us-ascii?Q?flfZnD+bQ7aihI+dV1iCIT/Zs3nDbXkLu7/0FfKr+e83YC/tUuH0SCywz3E8?=
 =?us-ascii?Q?dhri6Nqx6KDD3BES9UYobFZ6TSl9tNYze0ejBDNPn4SFLaOHF63ldoQMX0C4?=
 =?us-ascii?Q?w1dLpWXsRYAkV6pPJUJDr4kfRfhDh2lAOGQKqrmPeNhVMUMhrze2rFfX3EiA?=
 =?us-ascii?Q?VHnoZIBW67dDGie5FOpyXqS9+4xdZ/DPj/OSwsg1FP4lwLzllPnFtj1EN9lj?=
 =?us-ascii?Q?TBNx4wV3YC5CK4TLkdx2jnP0tnND5M2BkgVLMGghZq9/i1xD1OY6T+Pm3o8y?=
 =?us-ascii?Q?pgsdFT/9cWvjD0+FprYhFM1T/Xs66FIj1Xb2f7LqY4679OZrt9msrQxF/QUY?=
 =?us-ascii?Q?ubWFxWh53NjXtd51jvTvHwGgrx31pHO8txDWOCIOHrduzmpEeXTjpBvbPZWY?=
 =?us-ascii?Q?qRaF8ctahDBxZ72AA7y8+9JGlL+OiN5U2w/pJ7EwMlR5XIdBwmym+/oD5FAp?=
 =?us-ascii?Q?3uszl7HzTwQ2vp3IOqel0yQ8BXugFztPG41xTgFz9su0Utvovsgj7lrYLUW6?=
 =?us-ascii?Q?/8cBS+55LbyrLvhSJfNKnSQGNz/J2Tu7RWMxNglRZSO5pVxlK4fKt3byOe2N?=
 =?us-ascii?Q?y2jWx6llWrqVs/JQdAnNc/6mSUWLZs02hITvd3iZ0ZdNKo/ZOgafirC2XUzW?=
 =?us-ascii?Q?DiV3A9j/U6jF5GACvWalSbFnYJFuYZ6ZMo+0XkGp3YeIpeJ9O2CFw2+GWTUv?=
 =?us-ascii?Q?/UCKj+bD+ZRCkqkq6AlJETq4GlG2Vv3zleXsgcax+I9d2LZ/zORQPzOE7bRU?=
 =?us-ascii?Q?bJ+LHzuwj3Ya1BgNWWGtmYNCzcHld+tvCPXI18DSrc5xM2SLDNQ34GZfZhYj?=
 =?us-ascii?Q?Z/8gpVszyNYX6oc7idInJ+FlTEkd3tyrZlaSzSYF6FXkc/qToxTHpGNT0pd7?=
 =?us-ascii?Q?K00Z8Z7zOpbiq50KuZhYLWw6C0OIahJxy8kTmupZEydKF0As4YiXHFAoLsUj?=
 =?us-ascii?Q?G0oEvSc0/+O2vUmPx5Wfdc4lx0d0d714jGfYpNkkZsOe+32uJTySHcmkjsLN?=
 =?us-ascii?Q?2ALJigFLcjpl9tWaTEqR3zvXcj8iLgkwY2fPSYKvtNWMc+7Rnt6j8qeH23Fb?=
 =?us-ascii?Q?cXFmid+fYRn47UeczIXJOn1NhN/iFt4jfBC0LE7txjotv7NXkMdS1Dm/jQcg?=
 =?us-ascii?Q?SNt3uosk6e+zq+kPrQC1T5N0P2Z02yU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bTE3KzFuMqUMGpc7hT6QlrmcnuCzwhH8T40aAlLvAnSkVjzM0NJpMZT1Fy9Y3fnZa+3PHoA5AZztDs/1Ig8QM31R5SpDA1UoxZVrO4+08Ld0mCIVr8H4zCpVBKNPVyYXjN8l/IBSVtJyB862/gq6Xs0dXKUq/4EgchBJPHVIArijiHlSkSiQLO7VcruDuhLnAHbitBRfP5mO/me3WS96RORzpmBijeH58muPCaHDYkorsAmVmvaHoUdlZx/Vb7kiK1ceLMps99avC+gpAcbxpYjHFLo4NrZ30Eypy3Hs2IQrfPmO6dKTm0SeDUNYZjq3nlZLGxwSKLmVBRVgFvH45bt1D4yPyWYv1DXPb0nqhu212c9RUHQr4TWxHp8Izeh+8dXk+xgVDb3f9uPlYWXp0edaXMxsuqx32YTh1WorGJXCngPKa8tb6+OfiJc4xqTDLmgPWR1O66zaqqirIyWFflBGKIihsZc8NkWZsADMDuygGwZgbLQ15xMkbvNTCtDxv1gLrq/8UYKCCC8HDQM2y+1e/Eul+7HBcCN61omwrj8Z4Cq888HiwyXJ1wCq3ocZTcBT8ZJmpSQzdWdATuBOCQ7+sw7HJ5IY8/DIkqSsKGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec83f881-b118-4a48-5b36-08de790b1ba4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 09:56:14.9480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +p0JuIuGZOq51pTRA3f45ceUMipuwIp0wIEG85ymVUXfSv9yADJHIpx90P0+dMgh40qu/BN6Xf824l/Czo/iCoURE7wFBYDoTKpCZEJQqqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3NyBTYWx0ZWRfXywneFLnL/37Y
 ahC/BY6p3HNqcICdVN/ClpyMvdzr5GOZ/sspU8562MkNW22pQp4KAjnvVfl1IWT6xjyvY34xq0x
 sodnCePq/OOd7HzHY7luJ+pBUag56Dh2sd9mO/u4r8guKNKnrcD6bd5u+44RZTShqohXVP+dxmh
 AdnNfTd8tl9GFTy/AitK/E19hrWkE5bqyXqJPvsWxYAFn5u6SzgO8PQO3iFXLPGun2G/ic/a++X
 wsmD84MLADFNzr9XHFoRO0AcR03UTxqexb3IlQki9mJeK/q+wo6mchUNBQn7LkLa3wAqiN8xAgW
 qbYFUFzkWwu5Y62J1IFFUSlwVO2n2YADKrGSUYKflaeno/VfSDpL3XFegc1/HvXJDnlRdtMZBXk
 8jsVoxi5Yv7u2zkzQX40/x8ENoN8oI8DdN52ffLadRR9wtqjK46EZynrL+YfxrSeWkjBJMxpgMq
 uEzO/sDLiXL54JiRSKARhN1m47iqBONib82dZ8FI=
X-Proofpoint-ORIG-GUID: T_PmQbblDO1GtDLq3n9T98gOGBb4NDhg
X-Proofpoint-GUID: T_PmQbblDO1GtDLq3n9T98gOGBb4NDhg
X-Authority-Analysis: v=2.4 cv=R+UO2NRX c=1 sm=1 tr=0 ts=69a6b37f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=7CQSdrXTAAAA:8
 a=yPCof4ZbAAAA:8 a=vlvWEJglJhCAL41bW1oA:9 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12262
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6808C0004
X-Stat-Signature: r7h8ze99hh3f7a9p86fgpi7ysgtwx15u
X-Rspam-User: 
X-HE-Tag: 1772532612-136022
X-HE-Meta: U2FsdGVkX19+WX4SN59cmf8TM8w3zgY6qJhI3KXGaQ32/Ss1mABSV6HanF2BFHlcjjAO9NQ2k/J/eigPPYdPEOMR7HR1eDSXXOzg/rOVz46yG2PDfBnZiw1Nbd9HHQUiAy4k5D3jN7DMX8erOmSb2KSPwVdVaWss2EvcKtdDw+peAW0fg/J5W3qjWTobblmrfbRUa9q6V2LtyfXPZaDlbkE3kf1zZc+aG/+8BUDRHVonp/AtRt2yfvV5P7YMCVH/XEk8fn88nakGYW7YHNNPu9mnNy9KWu7DOIPg6CEqL63pvMzP8vJlUtxldQEUizsiqCmJez6hTWa03v7UyPse0xRFihLJalc/mmA0X1dCHIZgXevToAC9yTmBxv1MfJCoIgEM4FkuvxzEIYvdwlaJwXWxEd3Q99h2JYjK1uyPkVUBFTJ6UXIbTq39g2GsJjCxmQDgCIs+NfHlUQW8EsrsEuRbchLuBzxWvZ43BHb7pkmziPyWCkbMVhP3CaeQsbYnd0aV6Odp09YIjjMgj9OB0trdaEcPphrTiHA0YwWBFQ9EMVSz5FQuGhyamO0d9ANK4Ps0GhotLxaM52NnJrTza3B438LbfFekQ8pa/lwUk3AjzInhUjgSmWXtPlCUNQK6ElSObyhOfZJQ2lBBM2hmKjhtQtvJCroqfVYc6BoCRy7RyiIztaIHdfsF0EQWeKhJhVk4obgValBEzl8m7AyaSFy5zjM6X+LnnQcR+W1+E/jOw/uAEttHpCCpxLYePBNKN2P9dDdew8zUvwzlppwQ0OKN5hRGmb77K1j1OgUAzcYpIw8u6SUmbRy5Tc6IWBR+bHPCAVC9TpXVCNsF3MONAfJV2ZjzlRZKMyhqYBVEI772kqlQdus06Mrrl3ewnJId7F4DHkpjeC7R6naKyt04VtIQgEFVm5JDH/2tNCm/4esbGUczqv8UhN8doppNCYVRicN9E1CuF0SBJKP2G+7
 Wvi65lgR
 0nxRdExXo55NZxkh5/Gv/HrrcZR2gmsYem56LLN2j3KViP24xLyTZzB4iD2i8dz7/it3VTRRUR1t66eDec9QzBPqbS0ZtV6MXLIbvcXGY1C7TWyAXo2nCRwImkH45qfoQVCpRKOWYcOmnwhDKoklenOcS/m9Og3MyT9hv46+hDdsSPvqIjKnDhFYJjdMQHDlTsC08v2ayAqXovQidwOeGHDWYnPwyY0cPRDcAkkYNq6DZstmdn4SGF3rdN8i0C9NiUfGrkqOpBiRrS8w9YIlZqAesR4WVrzgypN6wAWjfym47WoHKpUg2+V9OhFQ0rtdy0t1crzJAgXqguU3tY2tWX2Of3Hk3OV9Lg9rza8/RK5yTeP8lOLtWUBPM3RvWz7tHKyhjn/IqE+JH2YeLYzQPV3i0zvWlF5tIq3SRXWPFgpEIA5cSNmq9hwVxbW+aueRThZANp6cP38RaMzbZP9ThcRwMUK8SwrYRCGIzvG38uLhcV6dFwtARBG7PRdwi82dPbveTq5Wqt2wpeNplNyIPzDg7yA76ouXxeDnY95frleEc2Y3yLY1H2ZS2KoLjy7ovYUDtzTuu0smnhkFV9DSiPZ9t51JOUgKswswRuU6X0WSjnuKux+Xt0FgVePiYs5sYe+Qn0SKa7dvYyB8DF/vV8zc9U4dPffGtKElsb/YPN64VMPjMlH1bbNjA95Y1brC+xbzmCm90E9L1j/Kusqvn3xR/MfW2dgu4cyaH00TYz8QL2lYphoWxzMDBe9ElIQk2R9AL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 08:05:01PM +0530, Dev Jain wrote:
> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
>
> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
> iterate on the xarray, have the invariant that
> start <= folio->index < start + HPAGE_PMD_NR ... (i)
>
> A folio is always naturally aligned in the pagecache, therefore
> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
>
> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
> offsets in the VMA are aligned to the order,
> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
>
> Combining (i), (ii) and (iii), the claim is proven.
>
> Therefore, remove this check.
> While at it, simplify the comments.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Very mathematical :)

LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> v1->v2:
>  - Remove the check instead of converting to VM_WARN_ON
>  - While at it, simplify the comments
>
> Based on mm-new (8982358e1c87).
>
>  mm/khugepaged.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5f668c1dd0fe4..b7b4680d27ab1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2015,9 +2015,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		 * we locked the first folio, then a THP might be there already.
>  		 * This will be discovered on the first iteration.
>  		 */
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> -			/* Maybe PMD-mapped */
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
>  			goto out_unlock;
>  		}
> @@ -2345,15 +2343,11 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>  			continue;
>  		}
>
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> -			/* Maybe PMD-mapped */
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
>  			result = SCAN_PTE_MAPPED_HUGEPAGE;
>  			/*
> -			 * For SCAN_PTE_MAPPED_HUGEPAGE, further processing
> -			 * by the caller won't touch the page cache, and so
> -			 * it's safe to skip LRU and refcount checks before
> -			 * returning.
> +			 * PMD-sized THP implies that we can only try
> +			 * retracting the PTE table.
>  			 */
>  			folio_put(folio);
>  			break;
> --
> 2.34.1
>

