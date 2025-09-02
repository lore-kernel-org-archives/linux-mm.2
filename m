Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236F0CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5C88E0017; Tue,  2 Sep 2025 04:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637608E0015; Tue,  2 Sep 2025 04:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C328E0017; Tue,  2 Sep 2025 04:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 089378E0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:15:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D71251A0B83
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:09:13 +0000 (UTC)
X-FDA: 83843584986.02.9702878
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 41F6520008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:09:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rj5R32VQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vljWO6We;
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4BKSTjPl8iRjzHEz8B9Ko6+raUqQeHz1puQrcx5b4s=;
	b=E7+RhGfPexwiHPTdlMULuh17v0RB4pN6X6Sb3niHkP70UladOgvmoio3ObXyoSE49hOctL
	6cELkWpUGs290m6P0RR5pd6F19Syl5E9FMo0JMfjmPGfNFOCtk2NyLcD4KtOz+dlzp/ZTZ
	Ki/3lwEal+oC42rQ0cvdzVXXPWxdS6M=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rj5R32VQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vljWO6We;
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800550; a=rsa-sha256;
	cv=pass;
	b=G5PL873zXv+WparlmlLOeohuj9AzFa1b4+e4HZR44glpFsWpQFTdgImHTs+bdERmaYEHcN
	HEuMf/kVfZaH2UHkvz/sU6Je8Z8Fs75UrlBtZv5L8DDh9zZb6DyGv7CGmHY/EZp6m5NTgB
	Zw5Btcyj349KMkd+EkJ5n2Rrb7AgBHM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826gcbk019854;
	Tue, 2 Sep 2025 08:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=v4BKSTjPl8iRjzHEz8B9Ko6+raUqQeHz1puQrcx5b4s=; b=
	Rj5R32VQukEP6WAZF5euMQyrCfDPgyBUI6yBgK8pREPAnmi4dtqGLe7syoASiLnq
	wsU3n5Nguh0BEYxELBZghaq/0CL77rvuJT76S198JqSdmYnwfvOolcurgOacpp/f
	oWmDw3W2W5/Uc6uFEsGL3d0QktzNe+YOhmT7A5aLObegST9wJupGsKTl7fNlj13U
	a8vb+sHrRMgWQEO77w9v4arpwdAfoUzjdPMsT/92tW4O2XX4LhCVYQ3DJNBe+/jd
	mk9R8EE5tpwqM75t7M75rrptjysFS1YQmtydiTJQSUut2fKTS91LVRaCfL4Rnifd
	yZWdEQCE4lZlLoGK9s8fYA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4jxga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5825ukHs032302;
	Tue, 2 Sep 2025 08:08:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrf3n3c-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CuaVRsVsWRB8UFmwf7p5K+DDnM2RGFjU/jTewvXysJ0ckP9OS3hbD3WQBquyMmZM5bziuWHb4JzSdzFLqarbvNmjq96afgWlN7yMcZU+1S/z1N1aNzy/T1myeMZieGoAH2Amx9K5kojK2KMRI05uTHIEIy6NujII/m3X+bVNJrwi3vHOD/d1sVkdSsMIy0/PA3mOrtsnbreWWnqws9Q9tnjp/ATIi83XldWhjXZ9I/209pTyaonCNPypRLDvhGz5rzHxDkPbtXvNqSRytFrY1StnjJ2x7VO5M+P2b2IDaiqxagEfT0Mvq7JukWK3TULxg4PcsUj6QW3eBKzk/RXTng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4BKSTjPl8iRjzHEz8B9Ko6+raUqQeHz1puQrcx5b4s=;
 b=KLI77YY+4ymvCSivHrbuOm7y9RcGLeD0oPcJBE7vBCt+RNBw9xmBvYX0So/oeRf7d/ROq7XXTcxckgTX0lN/3HTyeMavfXq0PhZcPz9/fErd5cYuDzi7zimvEEUD08oVx1NWxtolkqNCaAN9KzwYfxaOHbOfMruVEOhrM73kMxl9BnAmdUrnEcSZdd6E/Xz908Uzj2Ie4WlV2mkbB6ZJDz3uuclEOzhLgENhDfQG2CgR/k6qmry/k1LtFtU7THnuoQuMn7QQEUFWgM1S/OUef40faSGSmJtxEkALgxQQjRPw1DfkTmEndnvRvg04IKgxuSVumsydtZtCOPQ57jmOWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4BKSTjPl8iRjzHEz8B9Ko6+raUqQeHz1puQrcx5b4s=;
 b=vljWO6WeQNQpWK15jkOtgppODaoQat9kh5lOAMHUE1Zb7Um7oxMapst0eTT7lAIGMcqeGY9A61S7EEpm9fV5aT7mUr7hYzv06rL7hRXcEfUeKgjfnW7xHGbT99nEY6E2+sZgzU1VPpgkWF0px4UmSt0NJEQ7D39lDaW1gQQ5Y/M=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:49 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:49 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 13/15] mm: memory: support clearing page ranges
Date: Tue,  2 Sep 2025 01:08:14 -0700
Message-Id: <20250902080816.3715913-14-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0326.namprd04.prod.outlook.com
 (2603:10b6:303:82::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 7db6ece2-a305-40bc-969b-08dde9f7f250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BBz562LPq777vF7VxauuD6snoH6NFt0N8yz1XsdC6aTEmJCbP/Z8X+YVl/DH?=
 =?us-ascii?Q?kh6GDIb52s3+iC1MkA7J1Vm3zYv/jxZPTgq0gxxzGiczndfBbRSgU3uatU/k?=
 =?us-ascii?Q?xWOoGJeS3d5KaR7yItxpCK9OPcdCDxD3eyJJd+osb4uenvlNiufa1V+Izh6X?=
 =?us-ascii?Q?oA6XJ11fLGxoM368d0d1XYVmG6hDn122YDenqadBi1VNv98+qg2s7kfwPxcK?=
 =?us-ascii?Q?sznsaj7otsDCj8O/Fmqy8rdmLSACpFtdYEdB0Ddby7cwiHTEsxGT141V5GK4?=
 =?us-ascii?Q?pm4G0TSdogWSqNe70uvpVTqjiVUIJjJ7H9h8i2uIo6Zd0ant2z68m5Vf98Mj?=
 =?us-ascii?Q?DXTySDN/of6EPnnwsJcL7/vr1eHbgsGbYCKDK57oiiID1z8awPMv0NZe+yBS?=
 =?us-ascii?Q?bRYwB623jb5i2hR+UHPZUn1Q5KLTgaJNkvGpOQQbOhKvkNAMvLxPLcVDcInc?=
 =?us-ascii?Q?DX1A1MTMaG0bTFk3AmpM30U/8mXbNaMTFGXhNOEfHni5ic1AQ++Wbhz3Gfod?=
 =?us-ascii?Q?0MlkikMJonZDki7qE4e4tQt39HF+iZ6ztH8HUpCo01svhbNiwx7loxszES0C?=
 =?us-ascii?Q?L+w5N06HixZfPpRaMbVFejTJqaLf7WGWHPN/umPkZyvj2oJSLca6PFyDKOYF?=
 =?us-ascii?Q?KIi7HoRXjwBMfKmRVog6lg9Xj5/Hst+oeQQFWnn3zvnENOWCreTW2vgWBhVE?=
 =?us-ascii?Q?1HK5snP95hEY//BuKjo3+dijenvQHKCgbHCjQWiTgDdrCMvgEqJfzp0veqV/?=
 =?us-ascii?Q?muwTjrBxJegLPZNKHOEPRLA2dwEMt6wFgvnKIlQVwZc/vLOKUOkIvVZFsMZG?=
 =?us-ascii?Q?8unrcoPMD8GzE3/Qwf9U/9J4NcWuJvLZ3jQq5vUI0h5VCNBTQZxrz6xWpr/T?=
 =?us-ascii?Q?+UPLKyn1xhRyBZFcgerMXzX0zEcRmuzhEHEC6oa+05NTeVFdK20ppWFoCgGK?=
 =?us-ascii?Q?RN8h+SzoJISs2fCT9U6oUOr6VxFy77Zb0hdL19XmJlKmHH5jQ1aee7YVvORp?=
 =?us-ascii?Q?RYBzxrtR+uRq2zx8kXx6xUKbiXp6sMWSR+7KFY8EtUM8uHNjIKYpMekLv19r?=
 =?us-ascii?Q?otk1SNxLyus1XIkWUzkbZA0iXWkjz59v6bjtOLzrB6CeHU/bU2n00Y0yXMof?=
 =?us-ascii?Q?mIPJb+VU1jmlSHPwuicN7U4JoZApxnpZurcMJpbC5wYh0hw//itCYh5m6R7T?=
 =?us-ascii?Q?NvT8MYC8QXINECWMlbuuDftURfPH+Dh9cK1A6XpPSHmW+AhUX+klVRuWdIk1?=
 =?us-ascii?Q?ChpOx9dkA1uAiHLMGQaqioHa52IQQGy1BD+tJqRzEYuS2Dvv4osmL64XCVcR?=
 =?us-ascii?Q?Dln/b5DPtGHhfrwgWWei8Y/AGs9ZOWgrxHgHWt96Lcmog0rx4NF+rJ0tAD/f?=
 =?us-ascii?Q?ZTC5eZvigoVT+YM9YoltYyjN9jjdlm34P9UrXULXtgOrV3SwnA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6jCT/JjAZkM2TEs7XaHPpHZyPb2w0kahj0cWVK6dF1u+KiAkaLY9Tp5Sg/K6?=
 =?us-ascii?Q?ELwZ2vU9lmXSnvzow/qURgA4Lae2bFKqqDoVdlGatqF9J7gnTBMOGSmIeGSV?=
 =?us-ascii?Q?N37DhiALvczS4TLGDMx03Zf8IwcT/DtfPEPazjsqnGfIvuvDLII/X1pvI3PA?=
 =?us-ascii?Q?G14yGz4gLw0EGRn9oFubLHdo3PcU9F5Dkq7QScmKKowyKuhvraJvye3c8YVK?=
 =?us-ascii?Q?iodZDftLkKufmAtBgFcFM7ohPYxLe0UwvvFBx46S6ibWyn+ri3MoceDx+80T?=
 =?us-ascii?Q?qejgT87O4VOuMumNvGrOjBKYz7eGQ5xsGUmja6sK/5l5h/MpmTH0E5y/Pto0?=
 =?us-ascii?Q?NTdmgMAX2VkAa6vdBxcuSRm/iCr6DdRyJsDv7WEfuFsQS4fbyZkp/41aD4ml?=
 =?us-ascii?Q?JCtL5JsrsBzCnbLcH/aGcS3GMXNq44unpj1RyAeCi5/eIfR4yMnj0f/zY49R?=
 =?us-ascii?Q?WtZFJMIvyBEoz3j+bh33AsQjStiuefoz7JA7IMK+suBshK0Dkz9yuWK7FNQe?=
 =?us-ascii?Q?6K88yPnBAQU2R3k8mEMnQozrPd8zxOiWiIdfJQHd8VGDr4EJL7txKdQh2+rf?=
 =?us-ascii?Q?iXmTim26hTnXoiVxJrw1IClJN7seOuUMkESSYc+F2UxdvrgzaLYwFvTX1Ul9?=
 =?us-ascii?Q?iM5OXTCiSHn2hkvEbBTRc6Y7dDVdBZmlHV/ZB0GGdl7ETXkGumRrOkzlQgE0?=
 =?us-ascii?Q?2dSJLyWeW8bwNLMfAO00HvVLziDnCrrc17ypuTaCeY+i/R86px2cNsEiij88?=
 =?us-ascii?Q?TxnmpGZpk7dnC5yAiO5qLspB/+V5nAjh6eP0G7SoXfGrLtcDUshyqK1rp83i?=
 =?us-ascii?Q?a9BKqsi4SdeIic4adWxyE54SAX82SLugJz05k8nETBjP9roC+eTrpb9yG4dD?=
 =?us-ascii?Q?KTFctOdQoITQ9IhDOcFNUp/VAmLnAgn5g55F78LucPlcM8qx6fe+/d6rxOdO?=
 =?us-ascii?Q?jrggyNwclU3jIVoGVFwIFcmIdQjStGhh5c7RwU9d9RLXr5B15M9BCHrwHGPV?=
 =?us-ascii?Q?xevNvOCylIP3/8mRLO+8KB/reFKRBTeDJ3lT+KCtSD5x79p2BS++EwGxJWDQ?=
 =?us-ascii?Q?t7KHBvt4Wh6riXk/viPoVW3vD07KM7W0JKtB13G/2zw90LZKLBAd+nyBQ1mn?=
 =?us-ascii?Q?bzSqjob8wN1PoJ+qmK2eX8H1Wjbnt6DyX1eUrWAOxDkKShNN5d6k80wCU5WL?=
 =?us-ascii?Q?/CP9/vx0L8zBWfLjaTRWKNXeCRfYthbCyH3CX3m7qyJNoW0x1bFHlk+lfdhf?=
 =?us-ascii?Q?DaTH39k5Hdd/K/2pmydYdVZN0ctd2Igs/r14rfh5TRiS9eN9g1nQ7duUzD1r?=
 =?us-ascii?Q?haQAqiewVJhNFlDJGrOOaDvRr85AZukq30n9SjA+YuiZW0jr6HGzdYl19JE9?=
 =?us-ascii?Q?pf44Kc9xW0sI3YmpvPcMBVKXZEPVU6GkK8tks9/POHoq2eDPwUNUH45MhJXI?=
 =?us-ascii?Q?SzgDiG6+ZiKLlaHTPJWmsJqStgU5eYc/hLkiYoHLOZ2+iDvXyyfNPSQZeffl?=
 =?us-ascii?Q?KZBrZXSw37g/xDTrI9iLNmQk1vB4dcHEDuLNEbSJbZgS0q3oqaI+ZJPc+iwf?=
 =?us-ascii?Q?k13K80Rf6pTf8RaMf/PXL8MtfGA4gpoaK8zmWafGNHp5ePuDWWItym8b/inH?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7uBypVOMfcJJ96ZyJTXiSlSnQQeQNxhCHC4IGeOkprRt9dt714pqU5+FuwHXI+ANZJCO3cfNjVXry5OWG4qU2lMA3fX/hPZXYmt+aUzttY3kkCMXx/6qUZ/uiMkoPA6xLbxOYuf3DuRGzNcdWT4xOznEukwCCCb+9ythlhcn6lLGUk/bjPJuTU0mduQgHNO7+Pi2dDSlPjatfPjzec4P+oA+ZdpnWuJ2cdFSoZuRha8F4mSC27pB0C6U2eYEgpoTw9q4Xggk1jwsLEY86SV1WgkDmoGoEVoxNSQ/K7apasBk6ZPD8SszSgcwjhTHOqunrpeVIf4E+Q4K26rzHZGG0YYZ2vXcFtYE36oODyzJex9piWaYrUGPWXR3Rkhl1QiSv+HED3lkej5+0V0QWq74kjNV5XqD5/kwhz5We0f4fgBRK+ZpYxe0Z1XTTjx8j8UJH/piV3VBW794IGlKe1hqcwO7pj3NXvEHhG9izzVv2UylvpGnOonogXA9qMc++y2nf0DO2mPvEadK0FRWWiENWf2JmCoUZHJlSmpKGH7xOAms8pnd6uih6nVqp0+U4HJMhCvz+B/HteaX4gQdDxw4jsJR04BN06hFXpPk4YJU95w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db6ece2-a305-40bc-969b-08dde9f7f250
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:48.9503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqj5SJUD7lGnweDIq87Qu8Kn1xQtLnggOEZidKkJhYgPal50GELJkyVd8pVifBfxOTbx5QCk3xxMLUVshP35BufoBwLNadGFJ3jmf54LLd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509020081
X-Proofpoint-ORIG-GUID: VNSjNORUExRITuI2LNixWIJce1d_EhcR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX7tcSxICSvimm
 LK0NaF77bP3J5up2r4YdMwWHe/MlR1HS6m9nondTRYDlB5PpoYzdOnjyKRyCRxqJwsqABaDS72H
 hqc5Y/3Y99pGwVjwEJxffCXQRYvtdkBes3Fd13hKwwV5astJWdOoOL0wjP5NJALsucjmgz9+yc/
 Aod5/fDPjRMMO8oXVsFYd5bi9NGrEqSMMq5reGQ/wbNVFE0fg0TeKDocP8bF06RunUOfjfItoWu
 vYIyCbCPjTcWK+3tCzXfabDg6cJv/lfmyeZ1Jqx2+fyInWG6whnL2LibDFF/UnL19sYNTycwlhA
 E2XXwIke0VQ9UCFtfKHbuSCNrnZBKse+fjcDcB+oIAW8wJwgLMA8zt21j6k9kjzQJGoGwUcHhMB
 y7e4rNNNkzPIImdhLbjjyOBWdSEjSg==
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b6a614 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=D2IqL1M7U9ufldF9pVwA:9 cc=ntf
 awl=host:12069
X-Proofpoint-GUID: VNSjNORUExRITuI2LNixWIJce1d_EhcR
X-Rspamd-Queue-Id: 41F6520008
X-Rspam-User: 
X-Stat-Signature: gghp3k8i7h5akzawmojqg63jyr1tjg1o
X-Rspamd-Server: rspam09
X-HE-Tag: 1756800550-788851
X-HE-Meta: U2FsdGVkX19qnClB3ZfY518A66SCc8REe9vSquvK9aJi0ZZLtLPKzmgMYFesUNhTdkWo4cSFe6FLhokABT2SRPKcU7vVCrqGcUWZe4DUeSfkr1gXClh2BebIQXA6jDnXspGnfHqznj5++tzHHa/p22RGhuZuLUlPECxXwFe7oyiaoi/CxRtqpX8Y/ATFfJ3b4JArMRJPueHKqwN+NBrkBSpSASI26GN4gMaPR7/bSmiNakgFIsb/seGLTZdYDN8g6dIRW1ie34/hikUNRG47uPR3M9/GZ4qwM3EqBtriXwRulYjStMEJMFQZ3u2GaEhNH4z/Y6IVtWIo5Pa8jLnkwEK4zwvOqlqh5HVNNtLaDEclr5LvnL1sz5pg1Y+mqM44MERWc3kiYe55UNtR2YdL8Uy0aqwkwwEHaK9qYa/Hnqp08rHfDd/DEpYkGECj2t554C/gadIK0RSawfkBFYRTVT2Xu72TNKEUh+/mTODQ/GXW4cBAtGfHyyOya+dyPDaSx0ha5CQwIFCrLHde3cYsopwB7YkxhprM6jOMoIXCCQpwnzxqvFnAjLEzVeR7QH0Xj33+QSMmaRBWzHsTp1dSEKDJhos3BMafh6mBV2IWj//UOhH6FIiyWr7GGb/WE+8Hb1aAw+Wwb3khxEDv5vTqbL9tiiPFUKThD3z8i2n8mmT8zUwy9tnoT+g3a3MPm8PFNqYO7kbP8ibddMChlqA6RhjHrPmejTTuUXccooH69ozp/LZmfgu/G8gFII0DqZkrQJ7AK9lX1uGp3y1pVj6+KFHimDlP9l+9J2q2PHwaNEOuSKUg8GZrRbvJ1Jrf53GbNBB8kGa12wljzuMN1s9Oxs1rmB4TussYaQp5pbHYR13fZ1r4t2qn0l4YXVXunmJOWm4bnrF6RJfnQVb9oQSX6VcZUCT77V7+RQEaplyWAD5/Bn0hv3hl7qa+Omsu60KcmR7uEOpDYmGazjLnGHb
 5l1yJIU0
 dUZ5pvWgKphbVE61/TY5+/e7D5miFlqPF8CtuRFMmBLSx7ommkLCxTdtS1M4TfptTxhJORlUnxBISHYBr1ZSgBxxKDnwUqIiFfWKoni2L67G6Ihb07PX/DejOJka4RUy433VB+hIH+57zhucanol2p3RQ4zquKdopA6sHSlrAS2wLrhkx8vXpE0ThDW8jSQMKE+5rjzq9j33uHQyz1Sb/vkeIsW13rrIPYd0asn3gMcwLFTqASggPvUYtM4fPeVBXX3VO76rK+Jg8K/ZkT3SWsRuZcq98BEPnVm+5ake4VIxyKmL7pe3gEwh0Z7SQVTwXGcHUwJD2l53pKU0x5bJYOXLr62n5lB3pIm0m/5nSnzHV7SYRVYQF7XokjCozRK5bX9DFcAsRbijEL0WpYdXOqO213KtL7u8agNgmy01KZQTenUyUMVg7fxfWk6eMkFDAOaX98fKWW3WOFNIYihGeUvvBIXPLt11RBPE/C8BLJ6DiS8DQpxNA+LntwgG6/Fwtw6LQRtuxCEholp93ssa3h5xXaPQTLzR2QTNWIEsn9Rb3IzzM8Jyk2ND2gnX/qPfx/FMSQ53ShtuyheqGwfTZAPCPwZQ0CoZ7Vh7FwlXbQFtmsP4rKmzulwX1gPpRKJf9zzAx/nrYx6xhaNz59x1bllewhsBSpJk9QzEZavBl7tPYV1rRbtMWw2JhZmjmZdLCcLS1uNbzScZGkgzdLY1z19SwD3u2hCfxPr6YxH44frwZspM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change folio_zero_user() to clear contiguous page ranges instead of
in the current page-at-a-time fashion. This, when exposed to the
processor, allows it to optimize clearing based on the knowledge of
the extent.

However, clearing in large chunks can have two problems:

 - cache locality when clearing small folios (< MAX_ORDER_NR_PAGES)
   (larger folios don't have any expectation of cache locality).

 - preemption latency when clearing large folios.

Handle the first by splitting the clearing in three parts: the
faulting page and its immediate locality, its left and right
regions; with the local neighbourhood cleared last.

The second problem is relevant when running under cooperative
preemption models. Limit the worst case preemption latency by clearing
in architecture specified PAGE_CONTIG_NR units.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 mm/memory.c | 82 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 21 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..0f5b1900b480 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7021,40 +7021,80 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
-				unsigned int nr_pages)
+/*
+ * Clear contiguous pages chunking them up when running under
+ * non-preemptible models.
+ */
+static void clear_contig_highpages(struct page *page, unsigned long addr,
+				   unsigned int npages)
 {
-	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	int i;
+	unsigned int i, count, unit;
 
-	might_sleep();
-	for (i = 0; i < nr_pages; i++) {
+	unit = preempt_model_preemptible() ? npages : PAGE_CONTIG_NR;
+
+	for (i = 0; i < npages; ) {
+		count = min(unit, npages - i);
+		clear_user_highpages(nth_page(page, i),
+				     addr + i * PAGE_SIZE, count);
+		i += count;
 		cond_resched();
-		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
 	}
 }
 
-static int clear_subpage(unsigned long addr, int idx, void *arg)
-{
-	struct folio *folio = arg;
-
-	clear_user_highpage(folio_page(folio, idx), addr);
-	return 0;
-}
-
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
- * @addr_hint: The address will be accessed or the base address if uncelar.
+ * @addr_hint: The address accessed by the user or the base address.
+ *
+ * Uses architectural support for clear_pages() to zero page extents
+ * instead of clearing page-at-a-time.
+ *
+ * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
+ * pages in the immediate locality of the faulting page, and its left, right
+ * regions; the local neighbourhood cleared last in order to keep cache
+ * lines of the target region hot.
+ *
+ * For larger folios we assume that there is no expectation of cache locality
+ * and just do a straight zero.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
+	const int width = 2; /* number of pages cleared last on either side */
+	struct range r[3];
+	int i;
 
-	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
-		clear_gigantic_page(folio, addr_hint, nr_pages);
-	else
-		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
+	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
+		clear_contig_highpages(folio_page(folio, 0),
+					base_addr, folio_nr_pages(folio));
+		return;
+	}
+
+	/*
+	 * Faulting page and its immediate neighbourhood. Cleared at the end to
+	 * ensure it sticks around in the cache.
+	 */
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
+
+	/* Region to the left of the fault */
+	r[1] = DEFINE_RANGE(pg.start,
+			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
+
+	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
+			    pg.end);
+
+	for (i = 0; i <= 2; i++) {
+		unsigned int npages = range_len(&r[i]);
+		struct page *page = folio_page(folio, r[i].start);
+		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
+
+		if (npages > 0)
+			clear_contig_highpages(page, addr, npages);
+	}
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.31.1


