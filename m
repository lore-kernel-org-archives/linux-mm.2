Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF6BCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B336B002B; Mon, 24 Nov 2025 10:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452CD6B002E; Mon, 24 Nov 2025 10:19:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3DA6B002F; Mon, 24 Nov 2025 10:19:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1961D6B002B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:19:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8B17B9235
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:19:06 +0000 (UTC)
X-FDA: 84145858692.27.3BCF155
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49C72160007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:19:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XoiLy2+1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ReXKfgzX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763997543; a=rsa-sha256;
	cv=pass;
	b=W1C7gaWwBSso18Hta1TGLmvKwdW8RN0G0YVe8rHP2qwZXEsvJrTstXgN05kB35RRmfa2qv
	drmSiVyx/n9/8scY7FQSqv/a0lzB5YIWNCTni4Kt4EcV70VrTE53AsW2XTsapT1F/hpNvu
	zYvHAtvNZpeWW306xhytj4/m3I11vlo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XoiLy2+1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ReXKfgzX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763997543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lynVlDx5+1rwWwUj0W++oQVpdtHlYS6TWfMCKwEQC0I=;
	b=HCH3kTKVkL4ABZfpHXXcygVi43UfptxQmDsTlcEv506ROzDu79c8oi99eVUKEO9+y0bOEG
	N/Ahl84PF9SD7l0rR8TQ0nEO7viDvyXaDJoM1gCfo4mwrlM3oUVaSVuNQ96Ga1/8HlsppC
	YpmZvvPj4gmOSDHFBMdxc4hHfnT+H8o=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOCVNWk1121075;
	Mon, 24 Nov 2025 15:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lynVlDx5+1rwWwUj0W
	++oQVpdtHlYS6TWfMCKwEQC0I=; b=XoiLy2+1hWLoEJlQrQvl/GIVtJmWYqw0EJ
	KI2Us27JjOLg+KmpIv6aONMFS4kc/WguhdLb9gLj8yWqBrJiWGFYUN8KzlmA4z4H
	JeCaXkk3DNcdzkEZQbvtCCER8wG+A0LAxhF9ah+Ph4dd1S9CubifEUmujRXq7VE2
	OBiH1Go115eOGfv+5FyH8RgxDguTWmRQfKxqW83ExyseZ23M2eIfz7qNZ67ehGI9
	w7BnoIMdMr0/hKYm+Emi7JjIkkcMOovb/6NX/GsgL+nK/n74dM+EfcJV7QuZbsmQ
	GAYeJPdy6+X9CHdgtDj9g+MKYMpKbZXH5NtyMWD6pcwsVbSr5eTg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yca7mj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 15:18:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AODIweD022511;
	Mon, 24 Nov 2025 15:18:42 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbyv51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 15:18:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1TwOj73LEvu5K60JOZoFfh+soLJErLK9wlaRQSek3y2kTf4kc1q4Ir4kp2IdsYYIIBqdkGmoCOKBcAtJfKmOW1Ygcmm0CS4YUhRe28tpQkVZDm8+cnHvuTLZkV3C9YspyQ9MFqP5bA3BbwBvGwZ5Uh5ocMf/vLvRdW0fYjpuDR2gyP0+Nckq2zWpECmCsRnthkcu3ZDdaMgLkzrYUepseWEMGiZD5vcjXCg7wSlOc4QfSddsSFKo4kLCx0izhGGu69kEUC5S4wv+9AZkLvsLGdAfr7haFt9nX3rKCBHsPL4Tvo2TznVCzKXQyzCIq0geTgDjSUsxslNufka32JZ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lynVlDx5+1rwWwUj0W++oQVpdtHlYS6TWfMCKwEQC0I=;
 b=ot5I2WgXcfdvWN/cE+Ouq3SHfsiGZyL7kf9DgdAuQewDFeCBKZz3efgJmE8jGUQRDVI0zf769BbdgFRvEEfNHiy9gyi6Fs/prx35GYGk98zdEMcrIR/DpOAEI/ysYzdgK5ECLXb0Pi2t1z/14XFBSQg6i+nCSFKkMTi0nUMDQgDJND+j/Sk0FNeKZ0+aN3qebEKuf/gS6xEu4kzrlbWZlyRupNKh/tWvx2CgNfNfZeno87OHlc3fRnpGFcWuyvjOZ1YLAfrxmDHIfnLe7af2ca+m97KRl9gF5l2IIdMHXuZHUYQOizIrKGK+rlPzOgMwCmBzTzEH2/h+9ndTvzeFAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lynVlDx5+1rwWwUj0W++oQVpdtHlYS6TWfMCKwEQC0I=;
 b=ReXKfgzXHcyqqWoIzHeE661CVLYDx9hUYxvNlmL1c/qXVSypHePK1W1jJJP40F9O1P9bRbkBK4jQ1z44wHXZGMoYWLn+KyZE5a+4sbwtCBgE+fvty76vS/uZHgmJxxkARA4JJGufJI7GytUlU4sSAtY7QCXkU3aEFpCPc5jIT1U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6494.namprd10.prod.outlook.com (2603:10b6:806:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 15:18:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 15:18:33 +0000
Date: Mon, 24 Nov 2025 15:18:29 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm/huge_memory: make min_order_for_split() always
 return an order
Message-ID: <4a242eb5-dc7c-41d0-942d-4dd3dbc7ec14@lucifer.local>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-4-ziy@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122025529.1562592-4-ziy@nvidia.com>
X-ClientProxiedBy: LO4P302CA0031.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f9bc232-5218-4e58-d231-08de2b6cbb8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D/KBZgWlnReqc+lL5CB8ASG2uESE7GPStr8Ml0QkBxLkG4p6lhRCjIKFPz/b?=
 =?us-ascii?Q?3fOHaSAwosw6C7sHOe7xA5VWYhQI90DA4PLZeTbbqiz3AgkQqGYYPzvIVbd8?=
 =?us-ascii?Q?mif4AGcIKcGSVXHmm6nN8HJxDLvd4FXGtdyTy9uzR5tgM/8u2vVrRgLwW/oT?=
 =?us-ascii?Q?noN2pG+1K9sH3TboDCICGeEKl/3YaUhIsnlhANligvhUPeZP48gQD+LE4BAL?=
 =?us-ascii?Q?yK9FzDdyB3bKcsQfz9F8GmcPDDkmyDIWv6w1h6AIjZHY39zm/0xj7gFE2xF0?=
 =?us-ascii?Q?uoucFoER1NLeYy+G034mrOs7t70OEXsmMNo681a4YQzyplB3lT28UuWfw6wh?=
 =?us-ascii?Q?eHRLDAoxB0MKIWfqS9j9CmUkzDV4NMUkW+FbewvJTUyLdyE4P5XPGFe/qPPa?=
 =?us-ascii?Q?sThygKQBj9OC2Pm8Gg4FIzEv19VmBnZF2AWrgz9cM3ADbyNT4sTPvsVIaBns?=
 =?us-ascii?Q?hDgSo3I7/LwyK+fPc0YHuXD9ntthT662u2HV8IVGWVOdfLgMAoCiFHJ8OplM?=
 =?us-ascii?Q?BORXRIXeKoNGuNU+3qFJg8e8P71wlqJ67psv4cNjff/26wcYh4k6r5+6UXIt?=
 =?us-ascii?Q?H+2NUWpRvPZAyMlYFZRrlU4p1Sr8DHV16WdpO2JcF11OuHx76a06+K+02tUx?=
 =?us-ascii?Q?VXJC7uual8IRfyvNQ/CUxEA3pvTKQiYNx5WJzObMXR2ROFLympY+ZlR1hC1K?=
 =?us-ascii?Q?O09YGzGqSnmDhhJTdvxm96kPVUS6R7mWQFL9tR7jeiA+c8fkUutFKySXC74T?=
 =?us-ascii?Q?tbkGaesJRZ+3YT+aA98VL6VzU7tC5WjU/SIp8iDNcwjq1j33QyYH1W9l9mc8?=
 =?us-ascii?Q?lLTSuiqk60ScG9wxvTlKjZrD3BiXGPsHE+RswkcVSiJ4dZDmq1Xz9jCZqzPV?=
 =?us-ascii?Q?y//9l4x5A9blAEjhv4uRYDgLLCZJ99g37iGe59mwGvKAKsDouRe58AqWkcze?=
 =?us-ascii?Q?YaL8E5h6awkajv6YZKQA85zI81m96U1koET8k9TLWpgxLYFSJRl20733pO08?=
 =?us-ascii?Q?uK/9xTlsnq9x4vu12xUO45H57gsnhho0XXp1mnWtTzWUsQpZJkK6bUs7OhjB?=
 =?us-ascii?Q?iOXRoakq8SQZicmIc896pQ3y+OWDTdgAdh8fNCkHF80A5sWEp9zU3oik8Zg0?=
 =?us-ascii?Q?pDuG+x1dkP9P3Rh+1U61KSZpmSvJabk0kYHBLKHqbjTru0XYmTuhHmY/DzIJ?=
 =?us-ascii?Q?fc7GPdr2AAKVCmCpJRY+xY5lf5Ok+szA++1Vcn8OuEzmtBHLN3oSoXYZA22K?=
 =?us-ascii?Q?DJMJI+tka0VFtrbFEM5NQAP5sIkaViVWsn0ge4Ceisqqc8zzfasuY0y3mpuL?=
 =?us-ascii?Q?CnezpJ1zN9zClAQ4GiAEHWnIwBotW0ZyvFZ3hptXq+iVJ/cRwYk5iJ671NEj?=
 =?us-ascii?Q?hRvuBgEwPWBsAmuiwl45hML3drNJOLLanMQgnEss5nCeUQZeTSkSnuEubrWN?=
 =?us-ascii?Q?b8Mpsj1qgQUPCYqcs9mHTkHe0WNfBwXY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cR2mF3Ysgl45nsek0poipph+o01Wmpbi7QTZeZBBy2p4srU7L/e9kLkulEwK?=
 =?us-ascii?Q?CyFb8KREGRBZVlP9LIEmnUE8oJ0SqmTJGVrcDXeFJAuyLzyw+Vw7/8F0buAu?=
 =?us-ascii?Q?uJNdQ7w+5HtrhXzcU9i1Jtyfa3V3Iu34jWzX4n3lS6aJXnyGM49JuK1uJW+H?=
 =?us-ascii?Q?hWcggfGs89Vks4yYD4pxemuBf1dOVCccdVmGz7Z0lZkDOWwrsUgQ/A7c1fdy?=
 =?us-ascii?Q?r+u06jYqLWMKZKtckelB+oXz39YrVacYEJocSsWDQuMSLkkPC2k+mkCKVZ3h?=
 =?us-ascii?Q?emLEtPEeu/ZqYUjpvR7cFZH/VHuxNs1y+Qcly834OASYyxSkMWcKZtj783ud?=
 =?us-ascii?Q?jIyOP0sW0MNDofiykZGHnW/R27gic+SAdguqY9oXOxjzgyeuAp1y/mTQZBc1?=
 =?us-ascii?Q?YJSM2dP00huqFC7UjBNkTf+9Ua3icj9+2HUPWJzojH15Sf1lEJYRrMjWDRhb?=
 =?us-ascii?Q?bMw0caN8kJweyAuk/Z/ojhpwnt3aYX4d5gpIHais40M1vpBZjCCYMmcWux/n?=
 =?us-ascii?Q?nyEe7OgTCIHU4JsFMM0EacadCnYGIYiqViYpNGpa38Jdr/wo7Sv1mgLiZlEe?=
 =?us-ascii?Q?/OsERs1NgndiXzaCx+dg2CyqxntAOOCtbB9z/KTfhcN7ZzN3CWHyts2CfJVx?=
 =?us-ascii?Q?9u3Fn3Bpy4GERGU/63u6X1M4rNErigz03ttmVNdIpoGBKcCtDKPB1wCgOM0z?=
 =?us-ascii?Q?1alkTC19dd1XJEOKeag3ojBmXHrpAPkNFQPRUEV4GebZWlW/4jqjS3aJFvCO?=
 =?us-ascii?Q?5I7CapohMqoRDlGHCSy7gQCDbKEfeqXQ5Dr7Yzaa+nzF9P8+pyvzjQwvKFEX?=
 =?us-ascii?Q?si5WGAprYVtmahNWGcIVOF5pbyEZJ5GBeRptGfpPQTRodbZ8hJ4a17yvbMI8?=
 =?us-ascii?Q?M0JX2hNGIodXZ0QuxZoo2J0Gp5zKuh8YYDKAL5hM6c7geWJZM6PZ5y76hh9K?=
 =?us-ascii?Q?XsBZOwzI1NrDC6h0Nvif2o0G5GYbEvvsPQSjUTPSWdrcIbRRMtpqGxhdZq4Q?=
 =?us-ascii?Q?bo/BfS927TMn/6AyaLje7q9ZhMnkNMRmxZu1D6c6Q3Dhic7YZPB1Xbbwe3lq?=
 =?us-ascii?Q?DN0Uu+l/YiyXf8z7lzfe7StccQPMJz8U8YnsNFhdffT7uvw3d69V8wzoLMm9?=
 =?us-ascii?Q?2piApF3Tm+cupFZB498TahTmkulODo7/1FkgGmheKL7ROOY0koO+BBcpJBGC?=
 =?us-ascii?Q?UCchH/9rcpj10Yv8Qju5ckJJohbadH3At1S/VctvYbjt4vafg7xk6syFODmH?=
 =?us-ascii?Q?lwPukj6pFxk2svkvaDVxFmjLV2iAjIGqzkqliSFcaO1A/BWNvbuViI2Xq983?=
 =?us-ascii?Q?9heo/qCbUD27KSuq8JOHTsOA1Pg2aZYty26Ll+0LCJU2FR4wIMeAPcXdhkRW?=
 =?us-ascii?Q?8LlFfzIn/xpdso+3oODR+Vg1KF2HtTboG1IRyBdR86p87LC7ScuD0PMENDsP?=
 =?us-ascii?Q?/DzqsmxbUjFQdNO1dXtI89R2INnWhAbxvF2zlykagXb/ezEAK8n42qtshT+P?=
 =?us-ascii?Q?jk21iWw2Ga/RcK6zzPIUnUVxN/ud4ak0reRuEg61de8HTwLVze2ld/xw93Vn?=
 =?us-ascii?Q?+2BVluuQoK+QEi/XOZpbK3tQw52sT9fxyfpYKwLQHzvq9h61kVhsxU9sFL0N?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2gwQItuUlNEiW1p6lv4gK5dYJ+eu64dF0/UmTnf3nmZORI0lL3BiOt+9KKKI4qICP5ywbDU8KhFveTwmfCrS9c0SqkRS4UrrBxhjfkFw1U8UN7svYP4oI5+WQhBaO7G8kCijrKtX+mpPUcKe/69D2suOWE5LoB0YKCsknSVVWnOCJxfk9DDtSzARcIENSYgw8NyUN7Ubw8IZZpwRWXMR6GsMnV+05U1Z52SXCA6nmw/ldZkJD/MdGNbMrKAr05Xeb6TDvszbKEUeGAYGtrnjTrKTHFIJc5cJXkmManvLdsmbtJoNlI8Tt/EYxgo1uVl4tNXC7I1i1DDw+903esR7UoGjMgunZP7PdMH6RbVOmjcxijVusH7rbiqMkJTQuPAC+V/BIYKp+v515vw8hbQYGw1fyHDfiPl6YdLblQt0LOvetbh4yQwJVEXaxf1IeMnG9sRaEfwKLAAaPJv9B8x+hanMYVjWsfgsxSL/m92n2QiM4klEqKMaXfT1lWvyMF6PxsrEf9IlQLuJ2o7OfeyB3Y8+C96D88U9u3LVb00fOIdFo/OBFIlZWyFcSEswquAo2bD2mSPvsTZGZWfYPBEcrpyEMOU5qD5A31tJ09UYptc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f9bc232-5218-4e58-d231-08de2b6cbb8a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 15:18:33.6809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmXFQ1qrA39cBHT7LLFMVQfSovQ+Xii7krHCDIW2rVI13iNg8fgHRePB9ySHuUMcNWFHpa975DYU+UAfmaETLnHmKh7oU9oDfGsaUW2/0Ug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6494
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240134
X-Proofpoint-GUID: y0i057nwaCB0875lEw4HDbT9Ug35XS7v
X-Proofpoint-ORIG-GUID: y0i057nwaCB0875lEw4HDbT9Ug35XS7v
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=69247754 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=Wm6ZGNYcDuR9PUHJ414A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDEzNCBTYWx0ZWRfXwfr0Mv/YiRA+
 i+znI9deZ4iK5pz8n/IQ3mAfNPGZODuu1bSWZMa/cWIL8ktV0/miGgT3ktXcxDB35FjgUIekgLS
 LBFponWRzQEEfT+8aD9TIfbugjMys3yLikVwX8lNqDyWJsS/MIGvDNW9oXwegLm9yWpPLDjldzU
 CbKEPCzF/zll8auSRGfa8tVrRUK4aS/pkF9pLIA21hXC/lfCC9VYK3hgJXMdEVrVy9a+u5n5Yw8
 5gOhwtiuavELDJt3U5frgI6iKp/syuYGVuqyKV8lAuvSGZYExruqDZqYcisRW0/zqqZw/VqhM8K
 GfDGJNYYL8pOAyEjTvlurd/qX3LxJPjHe74EJp0W2yA4vX1R+IJVrpQXIdL4uBh/D9D6/eVam98
 EZDS3h2ZA4zxoBlUU3KpgkeGZBfMhsR7JrwGydUGdWd2D/s3qkw=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49C72160007
X-Stat-Signature: ikd45y4bogaqkqcy17wxcqfpiyztc5un
X-HE-Tag: 1763997543-622735
X-HE-Meta: U2FsdGVkX1+6bgYC69GTcfd7fHPx7puFqvFEmvF+DOAhXGQVkJYMRBQpBKZn0dTX7UpuxfMZIH/t/KUd/DRHze6yfIgGe9Wl9pz+T1gfvfveyHyY4FgfOOdZ8Jx/RunLWG8NlgFLDY281mTVzvpLHFTPZUd/sHhanwM0gbi0F/Sb2qsD+yOaZzIgd/3fWKYWjnN1qvENFdU+sGg8jclhhvfwbSh3+jw4OzYGydalJJE+0VPy4OYaeEcDrZfD0EI7UzZxcTVrcel12G5u/+TDRlTJxZf9kqp+z7h+RwL92ff/tQ4vqBnNzQNRMsbVqU/8mzdaZYqnlGQ5uIh1ooiBLcOs0VKhdyDTBFNqiFB4lbqekORB4upF47yr8LDbLkQHCTD33J95uxLwNK5HJDzZZvGl1CFCkZYjLrhKlzm7mianh7qZNjKzHdjD+A0UEcjk3J+DR/wn7KKDZtw4ltJTXehUiKBx2iKFrbCt++aL69TGcJ8i8mjsvbnZY1JJm7WKyd/iDrfjULp7bmWP7whfNZ5tTxr/2Dcy93qIqvKqYgNHKnK16bW4UZfhtOKksmUfvvVO+x9skWqhJSp9187BaP8wr4m2P9pvO7Hz9D9pI2cJJqVO4S2a/R+F4T4sRe8jALuhAOQa1cAbJgati2sOvEgz9gjkN/fA7fDasyEznTaPLnqNyy3ympkdYAa5W/CXdPDSn1U/B8MHO5aB0Cx5TJ1aUct9+lZSSDit9ejSaUqraC2/khlr5w/11VAaWiDIqvvq3LpjLtz31rkccIhEUyoGkwUY8Zph9nMfEDFexI04nn4VZdb5Mord8MkfGz89COF6QY7o0Pjp6WjdXVVlTTNXhbIehPGuyRuFgdhyRSQyFgABkHXXiXhc5l8f/ZLl2D5q0hMLdzQnWJOccgLtGgjhK3aXH2GePVgIIAm9aGXlTMbB320o4x/qtkgCkklY4Bi/0FGPw5ohf+toaLC
 4e17dZHK
 28jSsx7DwgROzX1THb1ZTWRZm825ABZYsfq0vUH7oiHdODxhGbMJUhAQvCuv2UBznMxmqLtGIqCS41ye0EJqk0hL9b7G+Di1c5O/HPpc1jG0aYaTF3egpn2/T4PUX3uQtD6UmqpAsH+HY0JSn8wlO0M/XPzYs0MwDJa2dNI3fJ96Z0IlRQqOKVTaVI04us59VNTxYRgmJ+tzB2kMLz8e6pZit/Hn+6H2u1/npyE4lqogRTRRZIQqSUso4gxyxfVRJQY2iKmkwbLnRH/OYnyryC75papi0tRyTQ76o1R+Nm61PQY9IuH+DZpKHkZYLhjmelPWeWX77musrQrtMbVTfKpnWPUsMnANBGlTqXCAUnrenh/JpJFXuzJML56n39bSZbdx7vpkAlydv42Y72S1KBVJEjTYOVSyC+8hTyDaHYW12+SI25N/2jUJltBugNRSd4UHhe9XQdk5Qn4IKJUelcsIJM1K9Md5av7C6zc+dWhGex+ka0vwiUy0k3vCe4g6xWZXT/BzN5nHBQymXOb+loBID49OS/i/9KYBW98gZzBCKSjIhi00rEfUjkKtOMZfKhosyyasVVObEWv/kCk+Jv7nBhP4uWd0p5jDn1fdlg+LrTAMPzhmoLUyaE4i4Djvh+Cv4w4ps3gFCyeZzrlpVzeCdIsBY4MF7JxlCbo5C+YPKSS4sXXTsxOerhFEmpVa5d5v2WvDam3+wz9MxJMifKUkC9eEVKW3fL0c3MP2U84013sAIJvEZ+Uo50u+2sRkzxkvB6NnCvIUim6bTpyfS8hEVALmwdRGs7KMH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 09:55:28PM -0500, Zi Yan wrote:
> min_order_for_split() returns -EBUSY when the folio is truncated and cannot
> be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
> split_huge_page*() target order silently"), memory_failure() does not
> handle it and pass -EBUSY to try_to_split_thp_page() directly.
> try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
> new_order is unsigned int in __folio_split() and this large new_order is
> rejected as an invalid input. The code does not cause a bug.

Yikes!

This class of bug is all too common... 'unexpectedly returning an error the
caller wasn't prepared for'.

> soft_offline_in_use_page() also uses min_order_for_split() but it always
> passes 0 as new_order for split.
>
> Fix it by making min_order_for_split() always return an order. When the
> given folio is truncated, namely folio->mapping == NULL, return 0 and let
> a subsequent split function handle the situation and return -EBUSY.

OK so we allow the split essentially or rather give a return value that is
essentially 'we don't care' because any attempt at the split will run into
something like:

		anon_vma = folio_get_anon_vma(folio);
		if (!anon_vma) {
			ret = -EBUSY;
			goto out;
		}

In __folio_split() right?

>
> Add kernel-doc to min_order_for_split() to clarify its use.

Nice.

>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/huge_mm.h |  6 +++---
>  mm/huge_memory.c        | 25 +++++++++++++++++++------
>  2 files changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1ecaeccf39c9..9b3a4e2b0668 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -372,7 +372,7 @@ enum split_type {
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order);
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
> -int min_order_for_split(struct folio *folio);
> +unsigned int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  			   enum split_type split_type, bool warns);
> @@ -634,10 +634,10 @@ static inline int split_huge_page(struct page *page)
>  	return -EINVAL;
>  }
>
> -static inline int min_order_for_split(struct folio *folio)
> +static inline unsigned int min_order_for_split(struct folio *folio)
>  {
>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
> -	return -EINVAL;
> +	return 0;
>  }
>
>  static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6c821c1c0ac3..ebc3ba0907fd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4230,16 +4230,29 @@ int folio_split(struct folio *folio, unsigned int new_order,
>  			     SPLIT_TYPE_NON_UNIFORM);
>  }
>
> -int min_order_for_split(struct folio *folio)
> +/**
> + * min_order_for_split() - get the minimum order @folio can be split to
> + * @folio: folio to split
> + *
> + * min_order_for_split() tells the minimum order @folio can be split to.
> + * If a file-backed folio is truncated, 0 will be returned. Any subsequent
> + * split attempt should get -EBUSY from split checking code.
> + *
> + * Return: @folio's minimum order for split
> + */
> +unsigned int min_order_for_split(struct folio *folio)
>  {
>  	if (folio_test_anon(folio))
>  		return 0;
>
> -	if (!folio->mapping) {
> -		if (folio_test_pmd_mappable(folio))
> -			count_vm_event(THP_SPLIT_PAGE_FAILED);
> -		return -EBUSY;
> -	}
> +	/*
> +	 * If the folio got truncated, we don't know the previous mapping and
> +	 * consequently the old min order. But it doesn't matter, as any split
> +	 * attempt will immediately fail with -EBUSY as the folio cannot get
> +	 * split until freed.
> +	 */

Nice to have a comment here to clarify this!

> +	if (!folio->mapping)
> +		return 0;
>
>  	return mapping_min_folio_order(folio->mapping);
>  }
> --
> 2.51.0
>

Cheers, Lorenzo

