Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45905CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 18:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3C88E000F; Thu,  6 Nov 2025 13:15:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AC08E0002; Thu,  6 Nov 2025 13:15:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742018E000F; Thu,  6 Nov 2025 13:15:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8588E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 13:15:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D924B73C7
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 18:15:12 +0000 (UTC)
X-FDA: 84080984064.02.8779B3F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31C3E1A0014
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 18:15:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VfOIz1fc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ec9/w1bp";
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762452909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHvdjdplb/+IXBH+Lrl7YnPsvuj9E1m639ahbP/uBQc=;
	b=8iKIUd3gd76nvpwxQ8iF4u+d1rUEyhaprouJx/I0U3kg9iPU7MlRr7hCCsNGN8SqP/eirM
	OaMuEVpoYtF4F0LRQ2826TWEAKfMiHmDrQC20qvsohCrwQotFDfqMNKw8en/dccj95CzxK
	4i61jtMExZRoT6Li1vHFUqFfDvxbNPY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762452909; a=rsa-sha256;
	cv=pass;
	b=bX7yRiyRs3IkZ7N4px+DuxGSjWfkf+fE2cKs6oC14G2p/dZuXtQixrDMuGGhap0gjy32Xt
	2uNETQsPq3yINYeBmsuR8KBrV3r6EWmMARSlyo465kSlb+91xbwAiV1Rp8qodtngUDUeaH
	0xyunfAoerFk2Tzg5pEw5WDGIVMRukc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VfOIz1fc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ec9/w1bp";
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6CXo1J030469;
	Thu, 6 Nov 2025 18:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UHvdjdplb/+IXBH+Lr
	l7YnPsvuj9E1m639ahbP/uBQc=; b=VfOIz1fcI5m+WXRgEcvj2KmpS55aFBPeqn
	Inv0Lq1QfdGf+yVH3ge+Con+QIUiMLiprCAL/Zsju0Zm9QhrwbmjW6Jj+5i/yVJB
	8VvIBpEjvJonzgJNzH/8xFbXvVRZ3FiUNyHYtGywn45Wo94wEQFe/mrEi9g6eJZo
	1n4XAvbw0BzyFpZlQRkxG1pHQReP2eQg7Qfcx+s1hggK2gBBhUenGkjbyfTjLeMc
	WDJgqjEofprRk5DObVhjNZSJSWo6t9+gAkcpP/imKmHRzNuy5El7luglajWuzOOo
	YhjeqfkIMjLNEy6wN6bePmivPhvDLxUHCNP4dVQZyRbeyVetPprw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8anjjn7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:14:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6HVjT2010788;
	Thu, 6 Nov 2025 18:14:35 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncrw4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:14:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seh6eZVEv9HBJTIGzc59JV1Cxhw3hf5i9yd2PtcNFhyCi/QfI5GYurmEc2kC7RdTJ3qm2xda/PQQJSIWHX9tjfpxQgyVgj4Ymo/kQ3M6zVh+r7t4Ny/j3DSAgJ+S5umKNTfnPpSD+RHcOJNTmdqkblwUTMvanFpHsOriUQ5FVH8BjD4hJ/ge+47FnjzmjeMEON3Ev39qiIVNUizGeHIg99FyL/Y7TXimKcW8mUzpRD4YqoHh3gCvmXijThDFuq/NDF89o9Eh7L9QYU2F9U+EOJS36lAM9xYK+0glilHbDYGxFR9oFBHbIItFX5o0nevJ1jRDhGdmC3bKQuWnkMMqLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHvdjdplb/+IXBH+Lrl7YnPsvuj9E1m639ahbP/uBQc=;
 b=FSpeh/dP9QlcadvHocuBG7C8tRytVxzWMJEfhgm9mjw7sqgRedVBTfunaG2r1d24qPX0AQORxpt80yNcCKGvjupofimBAQsCDouzq20hvzaawZxKHY17ON+qnk9WEss1jUBq9rxsmIm6iheGJqlljmJb5Nr4R0qT/qQCAo9WpFgDh88AFzuI11zveNG9P2NBVLaBva86krryrsbAt0MRV+2F3C4SyYEUDRSHcbsxr6E1Oo+s7c4m23yuX2fa/IfF46QoUHRqc1l8/vBABDFrN+A7XwsIOyChKaXE0woFD0Jn2RAf8CgelgpIWYtsduYWYmWCnYfhWAZlVrZYIphvew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHvdjdplb/+IXBH+Lrl7YnPsvuj9E1m639ahbP/uBQc=;
 b=ec9/w1bpjdrJf1X/iRH0AdgY3SOIgs8HJrJ/3fAXe+UW++jRdB+mVryYGJrCdjgrr2JkavtAr2GtwUGYVdXuPZTKBRVLe3fjVB+FcCf0MaBZcVnygjdtdifAPaxzypqPIeE7Iuuq6zfT/qnN6cUtRjR3AyK3i5X0WrJ3edSu7oI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4503.namprd10.prod.outlook.com (2603:10b6:510:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 18:14:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 18:14:31 +0000
Date: Thu, 6 Nov 2025 18:14:29 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 07/15] khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <7b6b5c6b-0298-47c1-ae48-17d603401bac@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-8-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-8-npache@redhat.com>
X-ClientProxiedBy: LNXP123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4503:EE_
X-MS-Office365-Filtering-Correlation-Id: f065b926-e0bb-4085-b8c9-08de1d60550a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tZVJDqjLirZqov9+YLGIwOno4icKtHIauYM2TpvMpESYGo68+6G7XeBZ9M6S?=
 =?us-ascii?Q?3raaYgTYQfQRrJgK3GZ8gnLCxCJniYcPhThqO+8o7GyHpyQmoxdIHz4Q5QUI?=
 =?us-ascii?Q?TICc6CDp6svI2nCmzUBsFsW9Iwakwva/BL+TKfQsPZ6c14XE0Ur6blBcfbyz?=
 =?us-ascii?Q?JVZCFguAli7GgWlJN/ni66SM+PwPKWzKxdUaaXIhQFwGSDoYsZheXCjtd2I2?=
 =?us-ascii?Q?u1F+3BFXQm+KXXW5S5IZmGbysCpMO3mjx35wLJCXNaS6JVvCO1ANxk++uaKg?=
 =?us-ascii?Q?EirqUa/HWqNssFdwqpTi961sjT0eqiL5xG34bxmFnYO7nNfVS/BKZFQLjGq1?=
 =?us-ascii?Q?LujeRArxTY4UBbatVq0A00PZTq2l6++I6nB4FNWkHrostVLc4cMo1VqgjWkH?=
 =?us-ascii?Q?4TWACgjezuuPt7ycuD0d8mpMvAv9qdg5nMy39bWXz3HGwXEYoYPTR/U/CoGc?=
 =?us-ascii?Q?MekpDGl6nYtCWqJTb1ZzOUgYuSx2HWxgXhLnEYzzSTRKNZiw4SYutFv/Pz8d?=
 =?us-ascii?Q?7LFBnpoJHrR/DxzHXvyGYuRGDId5S7cMgbb3+WxKPEbRQ7myitknnB/V5BsS?=
 =?us-ascii?Q?GNSkzoGXXnmK1Pkw8kuIN6zhweAxaZQiALFEI8T32gEp4EZIWlWkmjkMvj+Z?=
 =?us-ascii?Q?UUEnhvF+IOTLtZpc3nVZM+/JFmbWuenubKwd5z3tWxrk95PjE6z+70gFp7Q2?=
 =?us-ascii?Q?2leqxT4Godk05W6QH2NdOxsmQTU2pm34od4CkDXQn0UCS28vZILAsoWKr4F5?=
 =?us-ascii?Q?o2uykOnrkYC3B/G0sBV5dLvya2Ap5/AcB69Cysth899g3JsHEfmcUuBIXQ/C?=
 =?us-ascii?Q?NivtDtmJK6hdL1zrGNcOhBX69sP2d4dYgyXjrWwil2dqtnP5qBWHo4699sBr?=
 =?us-ascii?Q?aN6lQEOgimE0+m9Gc46jHFKZZgZ/X/bbEScQaYLYzQpuDEpYaZYlwkTxozHt?=
 =?us-ascii?Q?GJetR83HOCYlKM+awo2xKHcVUmWV828OM6cB3zhW8izTDt8hmZfnMoNi89/x?=
 =?us-ascii?Q?uqhkZBbpq9XsXIaZ0805oMzdx3m0xtZgWTOtnCMb3IP16gjP+BkzKuq0YsO8?=
 =?us-ascii?Q?TeMjcGxVsxL+XhFSSCq+Jxvo6AbcVhLLKhUPcKvoITaSh1JJZobz3I/Vm8gD?=
 =?us-ascii?Q?n3wWaZLSLYJqYyQ9d8Kff+VfuMa4P+WQWflRCHF+HEFvjOeiBRUnrHIdxSgR?=
 =?us-ascii?Q?Ftjusi51D4E92yv2ho7dJvfra57zbZICt9yPpVp4NFMN8HPSjiUVYnVvFRAN?=
 =?us-ascii?Q?YOAu1zAuEEFzPeChNOMikzpD+oFDjjoP3n+EqWWN5PG6yHayFmejExzKQ6wC?=
 =?us-ascii?Q?qLxGj0K2LiIuBAtkq31N/6YNx8WisWdterXdnGOGQYgnBaPkh/oX2x0ICWca?=
 =?us-ascii?Q?q29Y2jEVLqZgHXSUEeA5FLdbRzv4kDja4D0Cf5K22IZV/RxRWrYBS6em1s7m?=
 =?us-ascii?Q?PsDgZRN9WTgOqQ93QhCARmJeIdHx18H2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mUnubXZ2iVld2vz4mdt9GH6a+ptoobKIuQgICOAsxqGfvE1DZhfXjJoXJ5Tf?=
 =?us-ascii?Q?XiNHNQpm3bRGvxVvZYQvzpivgjT2aK4utvwi9gYY4NRMkhCIn04m+/YLGxhf?=
 =?us-ascii?Q?pGOZge72tk9fs5lsXK7zAtnnRC11inHtWe2khhcxIi10WJF4sLjbAhQOIG0e?=
 =?us-ascii?Q?lsi2/BvhK+GoNGvFbNj0D/6jZIvn1Cc9fH/flt47/2roK9Nxa7D1qYBPNGwk?=
 =?us-ascii?Q?tU8gW0B2amZEnPTbdKB1tje/F5Tu3gQ4qqPhzzpDsl2xPDfvj4oS5h/TXlMv?=
 =?us-ascii?Q?TacO2lTpgJ0NhYSGZHVrwSVNwx7McAOLM8MSa8mH3OEWzCEyHwtD0450rDGe?=
 =?us-ascii?Q?GGZkmU8aktwauRJ8fz2DopqXOGhOHpis66dFLPEs0iWpnkDufR093P22I6rD?=
 =?us-ascii?Q?7PQnTInvlRcFeH+0NJmz5+TyoeYkcCfF71iqNMyw5fSoPhHftvSCxVyMGxCN?=
 =?us-ascii?Q?R2HhN4npZesJ4HtzYKOkqPzVONRpOwGZGPDhvCV6482+g6JmnvmjoDs9BB2N?=
 =?us-ascii?Q?gkBfVq1mdoopUCVw69UOe7B1eRs2agewAlYa3s6uqkoobJutXVeCFUq17oPl?=
 =?us-ascii?Q?o8uOpVJiZ5GhPyvHRROa6O4MYLSk79rbU6/zxmMmggdMnRoPzvu07FC/ilpv?=
 =?us-ascii?Q?sIOpRYUcTGA/UbOwFeSUGUmBjcKjl3OvfhTsB2JaE4uBm7uaN1QrIPHUamsE?=
 =?us-ascii?Q?iD4MZNF/wgjCGDX3yyqcOL8M9K0agWq31/VoN31wYEb6ESePY+SNV2KGMDxo?=
 =?us-ascii?Q?U2g/hP3Pfbh6tovvNHxIywgFwioRkMA3JFDaugX5E8shBsIyBov+LzU6QFF7?=
 =?us-ascii?Q?zePbB5hS5ee78BAujK7mRlpTydMhovbXMLUqNFtSdDPBWhnMVhn03SjcFqEX?=
 =?us-ascii?Q?0dz/dU4NVPCXRgQaXfSK4no9x9ooAk6TuQiyHjflbl2TcNxlLb7I5GU5jXHo?=
 =?us-ascii?Q?/TMlSPSLNSNW5zA6OOnotJc/1HvGfE+DyEsngBM0NPv02K83/1acEypXKJ0p?=
 =?us-ascii?Q?l/OGOdfSro7G3lmTSPYWQhTjWH94N+D0+aKxZY3FbBaIWEITbMegI9C+uUJH?=
 =?us-ascii?Q?7uweXGUsRsGljcCo1jzbm0KOWWgkXOU3riv9lK4IcTsnxmxJGaFjkMGBr+Sg?=
 =?us-ascii?Q?I/Er2GwsAdC/iwZ7lwpPKW9qSxJw+h0nqx4R95luh/EhRE8/W2+eGZAptUuE?=
 =?us-ascii?Q?iFY2lPaSDGKJCFa1pSNrQCmpzFVjee7653SDE9KU4PsNrpyq1VZSANbt1m8m?=
 =?us-ascii?Q?Yigxg+tadiZhh71qbYkvoshTr2n5iKxIAig082ei9eVtNgddMsio1AXhYRky?=
 =?us-ascii?Q?pEaLIrj6JxvEf0yE007CUo46TPlW0/0h2aW9OqPMdraYXnVZP1iWmem+5atA?=
 =?us-ascii?Q?ew0LOpMzRZmiDznPxl/xTtkVtV1M/u5dIoBUG3tkHadA0SbAz/s4CGjUJTBi?=
 =?us-ascii?Q?aHKtaI1QaP8+A9Ejum1EAGfFenOoprOxNBKaLlVfP9vg8PeWQ1TQ1JgE5S7g?=
 =?us-ascii?Q?+Qu+PAMj8xb8kRiHzbiDDPVDbt2/Rv+63qgHEG3HmhigjYef5q5Kjb32p/lR?=
 =?us-ascii?Q?EjW3M2UQiLuR7ZpivwOnNHUv2qu9Fq/FmY14VGkvTyOB4hWujZYIBJTE+kI+?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3ne58bXJ+1F2YqGcpSAwqoQSrWPWbURKJpkCZfMeKXPbsZHKVoqCS2FiSFb/q7ipYG0XaYBY6Hf8DtdICUVUqQJVJvcXa2x6hDEH94kQzWd1QdPdNMXFwPicUp50cL6kBNJifL9WPaNt35SNqzSaMUTdgF1uEtfRYu3EnFro8fXp9dsHzmgepqS4sge20r1Sgb/LRDV12E28pRq0BljCTYltHYHgtGPpegjAts+0xaeB0eVVg0UdimHHh5Deb83bmEjd24WetTog2wTVq6yx4HIAu+ZxU8OG3Czjz1wI9euUuiA+KSqiTVFwtc4TRFXUDwwuOnMfIbeOpaJMc2BVCbqWsYUtqxnbR39E2TRGHl/+DHcVoswrm0eHSOjuKDt2gM0m9KPkzjWBFIRo3Y2NkzhX4B/kSPdNQsJfHj7Y/bWd18h4jxIooYSMybdWp508C4OrOWb71LmyyRj1K81E2uIvAHpcFJ52aDr8vrGSWmxT7+T4BHcg0Vo/3kNz3io+mNPI7J32tSnL+O/oZ3+k8V2KEr0T7vwyFhg/Knbno/LpFq8c5g0YO3noB9+p9bsjKgS0IK0k6rTxfJQUP1a0P4ZXB802VoRv5X0+RekXyz4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f065b926-e0bb-4085-b8c9-08de1d60550a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 18:14:31.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09e+bLhr8HgSB0m7EOf7J5S+vm9sUrYsySRbtJ9qaRyvYkvb/FDYe+XiMvNp3RY3oF7d5fkMsTlG7c2p6uFTqoWKKW2Y/Z22R6WaaHmXfYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4503
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMyBTYWx0ZWRfX4/cecTNLJPfg
 ZoCPCQrPDUFjPsQHjo2Z4hZdxH8LZbE8Hcc5TF6zMiUoTkU+J8GYyyxUcfCHLqq1m1dBK49u7Rj
 J58Kx/iK0lJwRxGnXaCMvIORQLqDAUqIJbx/lZscZA/YQiUOC9ZaTzzv82QrbIhh2iqxyCWzISC
 Ktboo1dxGXm5TTPeAtuVIteL1+v5Kobv58Vod+kR9EaRwaOCiinKQ1eyex1HlsBJ8sGwb9hgTE4
 KEmthGB/mj8tWbynxuY6u6KIusrC54BFsuzPerhGY+JyWTCECivovHjfCQWvfTrhlgU3+NdP5Dt
 jmV3e5XoA0q1wk2cGaCRnOrW9FT5cCAbsH7Ur38S87SONgpssaKLkne4tWzw+6lyUkZZZBqYSVE
 VzOMT+xxtAtD+ul02Wmf755wlWKlmw==
X-Authority-Analysis: v=2.4 cv=dfqNHHXe c=1 sm=1 tr=0 ts=690ce58d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=H0hI4RFCXMuf4eaQc68A:9 a=CjuIK1q_8ugA:10
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-GUID: 1dCLBxgA2bURcpx2PKWDO3AeVpRnsV-O
X-Proofpoint-ORIG-GUID: 1dCLBxgA2bURcpx2PKWDO3AeVpRnsV-O
X-Stat-Signature: xtsth8pwgd6r4hmgrww9i3e57zc7kefd
X-Rspam-User: 
X-Rspamd-Queue-Id: 31C3E1A0014
X-Rspamd-Server: rspam01
X-HE-Tag: 1762452909-213644
X-HE-Meta: U2FsdGVkX19HXTTxZHzmQNuCuenVXdtkB4pLdDf2NYTaFGpOE/5phfJXgCI2Pcgv6E55cQ/TAVMQ1b0eIIFeCE2ZWQGSbWqCnBdLq7FqTOTYSpahrCVHAmCKp2JptHUZE7Pjw+Yr2Pt4NFRHdql+YaI4fMrT0nM9fVjaUv+pv8rfyLAUzEeJ30JEXry9+Pk4dKR5P2wblmKhytBLFJ62lXKR8xmclRBEKthBIpXX00xFyGt1z5VHXZhw5kRLQp4qgHcOjlL+cLaR4O5T/UxHaesiMnmKFGqh6KIkg4HOKEgiFUayR+kkNsk2+xn/ZhjdAPuBgREj3SplTE+oCpwpiA4SJlOFyUBQqP81KhW2isnH7kCRvGOqSYHM7ZG2H2YkMpxTqGeVShuoa53H2K1/X0h4+UhWmYvaTxK/dQlkTBkm0OFw3Xt77IgnH7FzQ59dx4ej23sL5gh/2k8ahBNwCEb6Og2zY+jdj/jZG6Q3J2Ph/7cq4EdeeqNPYYHm5lzM9Vkb63s3PmuWPeUDuyQ8XMWfQDR2ZocACZ/xeUtsv5RU/t2NJ2tkSQ7dbbwmdAW222I1fAvStXAQ+XxtScltZvf+DnwdHY5byfp2NR1mGbjlpwC5cNYTf0czzcEtf6J3D0leBDaDR3rMikDjCg2209B6N5wQfWGKv4DZx9Gezm6PM/nYnj01xc6bSD5gWllceJBWzBxDixaeHFzvb6rZOY5aOYj8bgO0ngT+z7VTsSfAR/X7WQkuBcVaOI9voTamc0Ovt7zKLIGfjHEOR/DcZzZrOYBEaQp5PREORQ9Rc3cN+kPAjJK3z2vWSCI0X6s0P2njHSuKwFkPpeH5Wjm5GI0iQIgASwONyhB5kqvs0gD71QYtPzAJctK6u3UFzTWNSROawRCdBDCR8MdomOCNeGtOW2yHFm+lkQsKTvoblN4wWoyiiGQSJcqtiuAYeiesVo6/HgBkAgiFcKiEZ/0
 1FgOw88w
 UbixKzCnxQq+qqlY1mAwJXvWRm1ZKNkv70FZu0eqMp/9wtlPR7uhGZxNMDFT5MW7lfVxNs2gRMn+1STRje4nwYMFFR1Bth0gjtunSneFLPqgAXB3YfmQd3dElqocCAuTusKpmPxdZFCSrEhaBopKnKuWuSLwdPXt/898P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:09PM -0600, Nico Pache wrote:
> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
>
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in

NIT but is this -- a typo?

> the mTHP case this is not true, and we must keep the lock to prevent
> changes to the VMA from occurring.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 108 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 67 insertions(+), 41 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 286c3a7afdee..75e7ebdccc36 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1142,43 +1142,50 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
>  	return SCAN_SUCCEED;
>  }
>
> -static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -			      int referenced, int unmapped,
> -			      struct collapse_control *cc)
> +static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,

Presumably pmd_address is the PMD-aligned address?

> +		int referenced, int unmapped, struct collapse_control *cc,
> +		bool *mmap_locked, unsigned int order, unsigned long offset)

It'd be nice to pass through a helper struct at this point having so many params
but perhaps we can deal with that in a follow up series.

If PMD address is the PMD-aligned address, and mthp_address = pmd_address +
offset * PAGE_SIZE, couldn't we just pass in the mthp address and get the
PMD address by aligning down to PMD size and reduce the number of args by
1?

>  {
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> -	pte_t *pte;
> +	pte_t *pte = NULL, mthp_pte;

mthp_pte is only used in a single if () branch and can be declared there
AFAICT?

>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	int result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
> +	bool anon_vma_locked = false;
> +	const unsigned long nr_pages = 1UL << order;
> +	unsigned long mthp_address = pmd_address + offset * PAGE_SIZE;

Do we ever update this? If not we can const-ify.

>
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> +	VM_BUG_ON(pmd_address & ~HPAGE_PMD_MASK);

NIT: Be nice to convert this to a VM_WARN_ON_ONCE(), as VM_BUG_ON() is not
right here.

>
>  	/*
>  	 * Before allocating the hugepage, release the mmap_lock read lock.
>  	 * The allocation can take potentially a long time if it involves
>  	 * sync compaction, and we do not need to hold the mmap_lock during
>  	 * that. We will recheck the vma after taking it again in write mode.
> +	 * If collapsing mTHPs we may have already released the read_lock.
>  	 */
> -	mmap_read_unlock(mm);
> +	if (*mmap_locked) {
> +		mmap_read_unlock(mm);
> +		*mmap_locked = false;
> +	}
>
> -	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> +	result = alloc_charge_folio(&folio, mm, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	*mmap_locked = true;
> +	result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);

I don't really love the semantics of 'sometimes we set *mmap_locked false
when we unlock, sometimes we rely on out_nolock doing it'.

Let's just set it false when we unlock and VM_WARN_ON_ONCE(*mmap_locked) in
out_nolock.

>  		goto out_nolock;
>  	}
>
> -	result = find_pmd_or_thp_or_none(mm, address, &pmd);
> +	result = find_pmd_or_thp_or_none(mm, pmd_address, &pmd);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
> @@ -1190,13 +1197,14 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		 * released when it fails. So we jump out_nolock directly in
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
> -		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced, HPAGE_PMD_ORDER);
> +		result = __collapse_huge_page_swapin(mm, vma, mthp_address, pmd,
> +						     referenced, order);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
>
>  	mmap_read_unlock(mm);
> +	*mmap_locked = false;
>  	/*
>  	 * Prevent all access to pagetables with the exception of
>  	 * gup_fast later handled by the ptep_clear_flush and the VM
> @@ -1206,20 +1214,20 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_address, true, &vma, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
>  	vma_start_write(vma);
> -	result = check_pmd_still_valid(mm, address, pmd);
> +	result = check_pmd_still_valid(mm, pmd_address, pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>
>  	anon_vma_lock_write(vma->anon_vma);
> +	anon_vma_locked = true;
>
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> -				address + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, mthp_address,
> +				mthp_address + (PAGE_SIZE << order));
>  	mmu_notifier_invalidate_range_start(&range);
>
>  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> @@ -1231,24 +1239,21 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	 * Parallel GUP-fast is fine since GUP-fast will back off when
>  	 * it detects PMD is changed.
>  	 */
> -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> +	_pmd = pmdp_collapse_flush(vma, pmd_address, pmd);

Not your fault but so hate this _p** convention. One for a follow up I
suppose.

>  	spin_unlock(pmd_ptl);
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_remove_table_sync_one();
>
> -	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> +	pte = pte_offset_map_lock(mm, &_pmd, mthp_address, &pte_ptl);
>  	if (pte) {
> -		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> -						      HPAGE_PMD_ORDER,
> -						      &compound_pagelist);
> +		result = __collapse_huge_page_isolate(vma, mthp_address, pte, cc,
> +						      order, &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_PMD_NULL;
>  	}
>
>  	if (unlikely(result != SCAN_SUCCEED)) {
> -		if (pte)
> -			pte_unmap(pte);

OK I guess we drop this because it's handled in out_up_write. I assume no
issue keeping PTE mapped here?

>  		spin_lock(pmd_ptl);
>  		BUG_ON(!pmd_none(*pmd));
>  		/*
> @@ -1258,21 +1263,21 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		 */
>  		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>  		spin_unlock(pmd_ptl);
> -		anon_vma_unlock_write(vma->anon_vma);
>  		goto out_up_write;
>  	}
>
>  	/*
> -	 * All pages are isolated and locked so anon_vma rmap
> -	 * can't run anymore.
> +	 * For PMD collapse all pages are isolated and locked so anon_vma
> +	 * rmap can't run anymore. For mTHP collapse we must hold the lock
>  	 */
> -	anon_vma_unlock_write(vma->anon_vma);
> +	if (order == HPAGE_PMD_ORDER) {
> +		anon_vma_unlock_write(vma->anon_vma);
> +		anon_vma_locked = false;
> +	}
>
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> -					   vma, address, pte_ptl,
> -					   HPAGE_PMD_ORDER,
> -					   &compound_pagelist);
> -	pte_unmap(pte);
> +					   vma, mthp_address, pte_ptl,
> +					   order, &compound_pagelist);

Looking through __collapse_huge_page_copy() there doesn't seem to be any
issue with holding anon lock here.

>  	if (unlikely(result != SCAN_SUCCEED))
>  		goto out_up_write;
>
> @@ -1282,20 +1287,42 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	 * write.
>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> +	if (order == HPAGE_PMD_ORDER) {
> +		pgtable = pmd_pgtable(_pmd);
>
> -	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> -	spin_unlock(pmd_ptl);
> +		spin_lock(pmd_ptl);
> +		WARN_ON_ONCE(!pmd_none(*pmd));
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_address);
> +		spin_unlock(pmd_ptl);
> +	} else { /* mTHP collapse */

As per above, let's just declare mthp_pte here.

> +		mthp_pte = mk_pte(folio_page(folio, 0), vma->vm_page_prot);

Hm, so we make a PTE that references the first page of the folio? I guess
the folio will be an mTHP folio so we're just creating essentially a

> +		mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);

In set_pte_range() we have a whole host of other checks like dirty,
uffd_wp, etc. I wonder if we need to consider those?

> +
> +		spin_lock(pmd_ptl);

We're duplicating this in both branches, why not do outside if/else?

> +		WARN_ON_ONCE(!pmd_none(*pmd));

Hmm so the PMD entry will still always be empty on mTHP collapse? Surely we
could be collapsing more than one mTHP into an existing PTE table no? I may
be missing something here/confused :)

> +		folio_ref_add(folio, nr_pages - 1);

If we're setting the refcount here, where is the ref count being set in the
PMD path?

> +		folio_add_new_anon_rmap(folio, vma, mthp_address, RMAP_EXCLUSIVE);
> +		folio_add_lru_vma(folio, vma);
> +		set_ptes(vma->vm_mm, mthp_address, pte, mthp_pte, nr_pages);
> +		update_mmu_cache_range(NULL, vma, mthp_address, pte, nr_pages);

Prior to this change the only user of this are functions in memory.c, I
do wonder if this is the wrong abstraction here.

But maybe that's _yet another_ thing for a follow up (the THP code is a
mess).

> +
> +		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */

Feels like we could avoid open-coding this by just using pmd_install()?

Also are we therefore missing a mm_inc_nr_ptes() invocation here, or do we
update mm->pgtables_bytes elsewhere?


> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));

Why are we referencing pmd in PMD branch and _pmd here?

> +		spin_unlock(pmd_ptl);

The PMD case does this stuff in map_anon_pmd_nopf(), could we add one for
mTHP?

This function is already horribly overwrought (not your fault) so I'd like
to avoid adding open-coded blocks as much as possible.

> +	}
>
>  	folio = NULL;
>
>  	result = SCAN_SUCCEED;
>  out_up_write:
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
> +	if (pte)
> +		pte_unmap(pte);
>  	mmap_write_unlock(mm);
>  out_nolock:
> +	*mmap_locked = false;

See above comment about setting this prior to jumping to out_nolock.

>  	if (folio)
>  		folio_put(folio);
>  	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
> @@ -1463,9 +1490,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
>  		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc);
> -		/* collapse_huge_page will return with the mmap_lock released */
> -		*mmap_locked = false;
> +					    unmapped, cc, mmap_locked,
> +					    HPAGE_PMD_ORDER, 0);
>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> --
> 2.51.0
>

