Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC54CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A8D8E0078; Fri, 17 Oct 2025 10:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E627D8E003B; Fri, 17 Oct 2025 10:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50F98E0078; Fri, 17 Oct 2025 10:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF6638E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:45:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CDD21A0214
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:45:12 +0000 (UTC)
X-FDA: 84007878864.21.50EDD0B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB05318000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:45:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b1GFJ3MY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MaWal6qz;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jv9+H49lK0fHZZaJoGjzlUP3hYkcxb7eH5xRJlwx6Pc=;
	b=P1kbLgRGxGhXmO+0SvE5vPy1obj9JooM3bGBzvoag3TGmT0J3np5FWqOQdpmbhRlvEajVz
	z1okO1UcibK80hVWUcxIO8wi1suQXlSkuGeUvD7Kaf9fLEADHFvI1A8QMNIbjOvWaapLsA
	iuDcmluKntjUkeikjLQ9QchmG9RK4XI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b1GFJ3MY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MaWal6qz;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760712309; a=rsa-sha256;
	cv=pass;
	b=I5zMJdYA7G7O1Vx5gUPewfJkasqTmLLjYk+Zm8UAkIeP1u/iYSowurAneEhjk+l/csBDlo
	d9Ov/k27Qy8+T1BpfaPgNCoErqOBUzrr8pLAaCqYmkGgeZh5Cw+bwy/Nm2NNnBE358k6Vu
	JtOhweKoPetAIVxwFCIPq0tNguQ/GrA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCdZ87018857;
	Fri, 17 Oct 2025 14:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Jv9+H49lK0fHZZaJoG
	jzlUP3hYkcxb7eH5xRJlwx6Pc=; b=b1GFJ3MYkgyyT85vS6izGr+yORcvumLf3B
	dMON/tuh6zETOETwSeVTg162gWQ+5mnHsHGjtzYTWmC8SBz7BND0Sd+AeFiQ4Jry
	indbFovqhUJVhDcXWbUFXKS6NjU97s142tB+gIIu1PPujU311PL4Pq4TOuK7Sbdf
	8jP33uOWkFtQ3rpr8D8N0baIcp+kV5ka/nLNl8sPv4/mvLuc3WyFDa7mRmWF84sL
	ScPcJeugj9/yaytQWwMZ+lHwcuQJZQJYnwHTQAKtdYdMChVg6TFtMAXJ1bpzGzSU
	x1RhhFJxjti5/mHPUuqbsS3Im182oKiU+mreOEcA/n0kxGEs1/8Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qfss31f0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 14:44:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HEKs0Q024868;
	Fri, 17 Oct 2025 14:44:52 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011026.outbound.protection.outlook.com [40.93.194.26])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpd6ebx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 14:44:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nr2IIeyWucMyCODeR5vvQJ8QwhsmGLKTibyGF2v+ZMBR3QERXXwnOJsAP57kN1QVmziZrgtM4wH6x3TVzSGHpgp6nuyJ1T/TKgxpQqgDEPsvURpXF9a2A6GBfDnlJV2oqJmd3jx7D0W67O4+uqCSgfeZFuuqcPlxumekMIwt33nZ20hZbjRgHCFv7MB/w1xbC89qFDrfjrD1b75SaYeHPb+lNYTpw3yP8IJudPD28LXfvMEdr6Zifj+x+72yMx8/HUlKmHxS4P7jWpJDJKIcOlVGPS+0HRx3hjfkHIfVNANM/ds4BPmPritD0AtjeWUY9MSqNFFcxmAvKOgPDXEgSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jv9+H49lK0fHZZaJoGjzlUP3hYkcxb7eH5xRJlwx6Pc=;
 b=hx9DFesbGzvwhpDFUccd6rNGfITco5giDLPvlk0vFkXs8apII+Uva07lW4s/Px9kQw5RsnDjf2fSgXMrOuK89KSeM0frHs2yq4Ax4vWwnacUTl8SgguBymo9WbCPxrDyUp1m0iP/j7JuD5okFK0707H4vncqAyLlUa9et7v0/xMzR8ADuKbn5HX6EoRyEwUDP7FAvMiucBK3HN2Z6yBaAUZzRyBRrT33slqrh+UFMJVXMt7kGrJmVg3NmedpMiHNpInL/ZcEgm2w+j33K1EHUNiQdBIddhgSZ0cZQs/tq2N08k6pQFCXxaJ7DRTvvo9+yVCPer+36Dh20gJ+DuBELA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jv9+H49lK0fHZZaJoGjzlUP3hYkcxb7eH5xRJlwx6Pc=;
 b=MaWal6qzkQUD4zWAnTTgUNZtZnLme5GG0CWx1Se/zxyRtXBhVKFYkAbH5VanQI2i/NdxwPOBe4a0J0RexXaUmOcMguFzlgQWRioti45XOCrJi9gMvEaJIO4aBgUl00ymefyye2hwHYCYChLRP1Vx1Y/exAfAiPWFHcng4BsxWaE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB7840.namprd10.prod.outlook.com (2603:10b6:510:2fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 14:44:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 14:44:49 +0000
Date: Fri, 17 Oct 2025 15:44:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <10a00349-b01a-42d1-ae73-44662c8d9a94@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
X-ClientProxiedBy: LO2P123CA0045.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::33)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 98baed3c-3266-4be7-c4a1-08de0d8bb905
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iW3G23UBODB3760QVuRZQP8nZB8UA/JE6GNtkRqkDYgiU2dtwEZ5fWlHOQV5?=
 =?us-ascii?Q?yeHU6/Hip+ipN8QY+MbF07DUZHZyDzfAIJYIL9H0i//bSjJpsPJ+5DaUyDUw?=
 =?us-ascii?Q?fHfeoRPRRN1l1VlG72uS7kMxeJmzGG9km3v2xQsB51XcrCBTPpJ75Vfw4hdB?=
 =?us-ascii?Q?sQBq45mD9J5HgMs0wwHf4G2a81xQbZ1ddLK4v71xbfz60jsx/Bne7CC56SB9?=
 =?us-ascii?Q?4N9976F68qzLdqi+89zQqScZsABvoU+GLDF6Z2iTWf/L8aleORnBAzTPjxM/?=
 =?us-ascii?Q?Hf2ioJAKF6NTsiXnN6yXc8rqkw6rbrlGL8EB/aCwEYVY3PLJlP/l4+ZeUPeh?=
 =?us-ascii?Q?htzybxxhO0HCHTq9CoWcYw9QjA92T5vJEegUMuYhIsM3b93GH6L8mYI5T4m3?=
 =?us-ascii?Q?/+AigR9pYkQud8yMt0Ckf7kj2n5M3hFYEGmWzi3RYS3lmNHnaDr1JufkO/xu?=
 =?us-ascii?Q?EuMyFpnL0oBqiqHGUPijreJD6hRtS45+uAcK9o7y4jYJTFXN8BLqJIF4MDPI?=
 =?us-ascii?Q?ATkg/UFzPkJ+vg0+Id0SxnROFN6iaj25b6TsC+C+h0knOsRwQ5/NN4c/Z360?=
 =?us-ascii?Q?8GSeucT6mX4QqKgxM0YSYIOwS1Oekr8XTMalj+FhQSqTjn5bKvm/7w+OGZmR?=
 =?us-ascii?Q?ETi0+skhE7fU2VavarFPj2JAm19aqQYEkxdryn2hdmOmz+wNUV7TEiuoj8Yd?=
 =?us-ascii?Q?CU6Kqe199/1BPEtC6sm8+IG2a/IdKkYS9WadW/D2bj/uAUettp5JuoMxycce?=
 =?us-ascii?Q?hOvB6a0jXodQ9y/cm2FY2PDDCCK4hJXugiYUYxOXsfSattyT1fgM4TcAE2XB?=
 =?us-ascii?Q?edXZ2Hf2DdWy5hGpcrjTYVrexeMa+hLH6hdEZ4IGsNJnySiJhmGWSVqFKdGP?=
 =?us-ascii?Q?W948jpdX0rhN4KIlKmsX4bNZxUps5P8XftXV6LohmchVI0ATdngyZp3bEQAt?=
 =?us-ascii?Q?vBhUXbY4cqgsSXYA/jJj0b7cEpjt4ibA/X/wFksYoSY2ZRk40Vohka6HzL3G?=
 =?us-ascii?Q?v3aC7CqpZmpKWoVuckKbFBSaz8HHLIyrP941WcVYPIrQUuryT0k965m1hcNV?=
 =?us-ascii?Q?1WaWLuvRlsF4x1F1nPzgf9Ba40sgreduWTGKrpQe5fhj+LYZnzbjNgt4RZzx?=
 =?us-ascii?Q?Fv8HFf5FhmYxtqGxMMS28N+eXAuqoSc76dEOQ4dHZl7p8T5rg3P2zZgLMX6d?=
 =?us-ascii?Q?LnaLqJLFpTwASUVZieEgbH5AmiHho9cX74r43q6jeDRjgGmrNiZckob9JiEJ?=
 =?us-ascii?Q?0JUxn5GDoQx63ZLGi/afEbGS5PTA5d45GJlIFqzSBcOuqbSJiXkzhvZdkVs1?=
 =?us-ascii?Q?FR/IvQC/S6B9gTVjXNKUSLYbhwPLZOhu+Ww2RIYIJgy6IYi0bNIpcIXeRf3Q?=
 =?us-ascii?Q?jiff1dyVRS5/BZl0lhletFJEf327bMOFyQh6ueFWJg4r/ly2vHc4qgh9Wuf/?=
 =?us-ascii?Q?A0V1qzWZC1v5UK8dqVBxG3UJ4TSm6t0ruY3iTXQk0INKN6IMesczhA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MrPohJRYI4t2/lS4W3cpNwGx+71x5GSRACQTdyL6z0Nki/kx7oPeiG8uJhoj?=
 =?us-ascii?Q?ugK5tBYzY9Skpx18rLFXMb9M8boYz2a8ds4381xscn0iWHhOxU/CWJXb2tg4?=
 =?us-ascii?Q?YLrSLj1JF0OolPD19WX7MYHWya3JdGTq9tkd7rm054OV0oxz9Sxw2Mpa5JYB?=
 =?us-ascii?Q?3RJaYOIh+gs8G/6K+m/iTWNTqNnnbNfVUhso/OXFVTuuG9RTzjNFcmHq+GZt?=
 =?us-ascii?Q?sY3aQUcSwbmExSgT/OCcNJgV4OGGHEJJx735m0ZKH37gXJuSacBGZSXjW0Wt?=
 =?us-ascii?Q?ivtp+z0rAgr+o97R1abRFsS/1Mlh3Ua/FeZJJZ626FPdv61H9l1BAiGOCuCx?=
 =?us-ascii?Q?noHW/PBNjTVVRL3w5PjqqQUg27AMeedrAvi+/5Z35bvBhvt5zZgUmlVJ8k9g?=
 =?us-ascii?Q?9afCXIEj3rauJ2mHwyIJc2zyslCy3d4REtUosYg4wtTi+w5ctjPZ/kgU3CgH?=
 =?us-ascii?Q?FHoS+E6teEk/QQHBHWC4MCTkdlSsN9a1hJBfiIgljQwXxUxYMl6qCWPOYAoN?=
 =?us-ascii?Q?FnzvIXSTkDImx4NCOXTMh/lmiSVADeVNvJ2RmMp7CFNb+IZEHsyK9EUTS8G+?=
 =?us-ascii?Q?u1Hc7HP/4gbHT01c7JszCeVU0w7HZiotZb8hbq5bLQv2F42qMPa3jgpKAjM6?=
 =?us-ascii?Q?3Q2o+GieeO0hfxRLZwVfXFOHK9kzkNfqrPGxZL1h5emuvsDpqIaNLtbGcWMf?=
 =?us-ascii?Q?T55z0pnk/6jdGjH2/S+lCpX5Y7vVthE86zwLuq1cCAce5PsoIkQfoH7EnP7N?=
 =?us-ascii?Q?3hRm0I+S5A+ZESE7xGCmmfCTbujqRJccoBANEUy1epPMWs7+8uvsDYc7SNXL?=
 =?us-ascii?Q?dAcxn/xDDNd2KtcQN50BlPG7J3GMYO1MmqSJEMsDGzMIX40Oj/h+xJbDjPo4?=
 =?us-ascii?Q?PZYrX4exyo9OORyIQYO+M3P2cuuN5RbivmXnVgxihdKZI0fZZlzWAGjRvIeV?=
 =?us-ascii?Q?hYZBn9dw4Su/M9/zwF8gzWnvuJI0NC8kV4WeqjnZhwuypP7TDORIvNrAUe0e?=
 =?us-ascii?Q?AR28nitKaJ2n1wbseEjau9K+DD/tdVHLfosh6MbmEIksS2nOEouTMayTAx0r?=
 =?us-ascii?Q?JGTEooa+8Xed8zdLZM07E5kGanxvgmrSI4vFJ8uxkpbfaRw/rZ3oSu1f/jIU?=
 =?us-ascii?Q?cJ8hGoDgpctOCon04wM83FQzuUeAu69RHD0w0IBRulGHweWecKMT43RCRcwH?=
 =?us-ascii?Q?CREYOWCC2nuHdlMcHtfUVmJS4oIc+TjQdqZJVTfeQRWwOGWCWGVYmzTD5kRH?=
 =?us-ascii?Q?7kXkS9VYb7b9U5xxxgPjTXJ11KsxA/k1bg3OfIsHUSTwp6y4HeJqMgsBUHB8?=
 =?us-ascii?Q?yyTs39+TLPAcvIeEHVWfeVW3hn39LZsYvZmx7q0FK5gqJ5f+Thu7fdMvZ2Z4?=
 =?us-ascii?Q?EVW1qsioapGBUIPnjmGjjw9hLy+QqjHo+di1cqIUZG2LGLGeVSlfvxRqgsyX?=
 =?us-ascii?Q?hrbHtL51qN/mPcsIiZi4WfRHYZwJ33ym0Ye8uRUcbAhAJIe63jkYm974foRR?=
 =?us-ascii?Q?WSxPErUd1jRppuynbgHZGQ9ehJtKf0IOytd1c4YneyQ04nSja7Vg/rX2sT40?=
 =?us-ascii?Q?lmoGLv2wBvvVAc17UOD/29cly8ZNdKF7eYmwGvg69gFIVaK7Rlo1W/3a1DGl?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cs+yUj4gfiK3jJ5y1lRhkbmeF6w+f/Kyy5W2OYPqXOYQ30bJEl4F7SxkrCVBHy59FN6obCeYKuSGDt8DWX+dbyH6H5EKqpihOl88scrplpa7wHmhxRoPlh7q8hXZqKDDIvXW7T1OOM5VY39zy0JsG1DUWYWwF7zp1w4nPgve6nVBuVdODw8+RL/S9qBe76WWMqZ5hHGxtkEHcQZgng9gBJjZbyaGCMrWDN0W1M24uunCnNjzvYvhK3SvWi8N9IkmvA9POGCkwxNsxfDfqQklWG6Hk3Sasool9gzzNfuOi0AheYHm99DF3LebaNt1RbX6U/Q91UqEY3NY0frsLPNU3Pnho+MyBN2ns+mCggpEFcADRP1j0s/Z5MTPj2SQUiULuKc295qtjgTpumeRa+uBMexOj+C+JPqFDARCn867G/w8/16FbxK1WpiF+jC8zmYpRWcHBs5UX/+7XdJVziQI8YWXbQ2D7WHZytH4lc6EVSc1gspWAE5OF7EdyE1nnAM57FZ7XPDli81ZvNfqAoS5d7oJpqMLA12d8j6Wh76SAcJTvRjSAgefGb9FBbQqxuTBMFkby9yZPv++sWXNuoshS7+FCu2mS6c0kgWVfd2LdUU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98baed3c-3266-4be7-c4a1-08de0d8bb905
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 14:44:48.9478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNJ5PFXvUm7VTgRV02hYP45749Oybvb+0yub5jI+2GqQKnHPaKt1PPp36B2VmNYw7SYeP3WvPN5OBdNaBDGkuEgifLATFeXkTWb1IizEezs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7840
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=867 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510170109
X-Proofpoint-GUID: alfkixc6KfElisSecuLeYxlhzQ5XbeI1
X-Authority-Analysis: v=2.4 cv=APfYzRIR c=1 sm=1 tr=0 ts=68f25664 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8 a=uhsIHU2bWCJy-z1RawsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyMSBTYWx0ZWRfX+yFhOqjv+467
 XGKFrmiD2pCWnE+Vrv1xDGQon+eynxgyfj7DsjyTqPV2tdmnbOMcVWNODYI5PkKFp8bPE5nGMJa
 p1aHLoGrIXVlDWWq4+7McJPtaGAIFstnU8htG6lFmmrmKSrMzHQsdmZwFQk3ny6eJN86J8CrnqF
 gNMNNHJKGPlCoQjtXWaPOKApZap0HCggMwNvrs+pPvduJBFrane6oMmq5tsE3aMpaD7eztqfRGs
 G6VVgJ67vbZjGIY3CB1tBtDoieEZOBqb+cgTjth+lnnW53iFHrGO5T1HsJyQ9xg18Cnnh+fi45T
 6zj1PziG11DDBmZIXQTdw0T61Va+ZQKbrZcq9C/g/Gz//6L1LnkP9elVPa8j09A67/Os+Z4bCbw
 7RiDRY3Mon9DYlforulflsNfZ1kBtw==
X-Proofpoint-ORIG-GUID: alfkixc6KfElisSecuLeYxlhzQ5XbeI1
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB05318000E
X-Stat-Signature: 6cq6z56ekhse71gd41noo6jepiouxqhg
X-Rspam-User: 
X-HE-Tag: 1760712308-444053
X-HE-Meta: U2FsdGVkX18L36tOHSnRsQvggwtsIBarnhvtNNymYgij2pbL0JLCLTvfu2B2uVHBjUYlTZrftc5bHBP4Rd3YVw2/xYqS8/mFW0lHoAXHBQxb2XF9ghcUNjyvhdxC6NoZxvyvl3IMMGRGCQb5C3FaeqRg0+OkcoXPx8X0KEsXyPsudLQMH0m4IZwzc62/mwWSpaTyNzqaWbLnOJCOn5sSz42hAn9B2cbrwP9DuCDfhbXFqCate46w+23Tq0PIFqI68xkG3XHfmwLPRMyiFFqsEVRghanA4JQgFBCYAldKul9+7OIErPWjhpSNSpt2iZDlC5+Nmz95m9ifj8mUUQwQ9Z5AX6qwqs10TpgeLcxRc6pMLn/Twc/upMCzvagdlvshqJxQWZ7xkMAFRsOm3WlnPunskgr5QK0MpI03vUGl4zjg+uHlvxQfF5wlSHievXzpgmrqO8F5m3ScrFc8lxntt8uMo0Q/81XRSPPTmcC3ImgXRYkt2Ok10DyhyJjktmlhCA2aYa7w+Rj1VkhGHYAPrB05uDlJmml7MAX6oAoTs6WehPpIryvws0hHVpGwXkkyid/l0+/3SwEVelQDauZLAq8gAj+uwWo4ZoEtL99lZLLFm5BvsmK29auDmmdb6bkUhmCiOfdAHAuOaq5Ol+bquAwlSEnoSCoZSV5KrsJSBu9O3vGV8Akz4TxJ/oC+6JxxsbdfNTHqqf8QxA8ek62Wql1TA0Et17rgYqQdPuKSAatw16jpwiMW3acT/cNNX/btG8wA2JjRBWwhd7fHSKbq3NUpt/u8TBIrhCg5XNNJQM+ZvYvDwIrHMnZ1BLXHSLeeXq0HH6qC+5WHidISpxa9BfpkBoHJMdlskk6TPBb0u88uAcpw9YRCws9UpEB1faV8OZNPFzzu4n65RN0LBrzSqG8tUlUS8UeLUGKuOlTjyCCZq1q114iNb2SvuyqvGWN9oLvwo196Q67TOvOa1iz
 RJ9MsHRb
 WRYcwh+8Sslj/275N1p+O1T6S3FFwZSi1JnIRYjhjI4bs1j2lvJIbtYOXA0dRGHCwWmFEcEpDOfpiUjB9/V+8kuqP12D9qPlBSNv82NjWJ55xRCVbCpW2YpFvprfHbMz7UOuxOeWC1c5W7gBijL1TE2E7B8/yHTezMakTXh2N47xlFyMk3ZlIdHAEh+WVPAv7d5I32oUtIjLaZXiliPU0+RO4J1/FxcPv/Kyo/pxJ5zMa/4KiJ9R74551sEupmqM8cHQQlVYLxulOnSg88XLOBRQX7XnbE/bJ3gYO5KfBxyXeEwqmp9XR/fU+FMvTRjsZSBvwDax6A9DV4hOkeDGnYfAOWZwmvKfBYvgKsD/d02gTClU5goDsSxBxFy2PMIp5CMSu/cxbCV39o8MRziNuBFFCz3gwTGXCkTd1AwlIxpPzeTSWwJXJLoIFsKeINirB4ZL9+ZL0tZOIZ2anzRLk0D4T7HW+dQoQM27IEnuocNfLFQVxByVq/lfuoCFjIFYFd1F0Xqt+AJUpT0MpF5NivNJ1qZCPloD6wIzWZ26lyPnym/iiFHjuyZ8hNhXGcFF54PkZAuGPwKxNbh/Liesrz0lfi2wTBuK/TVHCz5ubI9onjUfaDaLEwqamK4uWXp/5gGSVSbyURLXx0t0nwUQ4c+C7RY+fARfnyO3dSWwZr3znHuP+7Z39r/JpneQWctCrtowvskvCbQlYtNX3oj/nJuVt6weJ2bN9PWXSHD8bELIn6wtG1qJoFPMj+f6wBhpAHGOXnTpRFmbttUvLCNOay9gsFWU4grFkgrfJMAf8jy95WUnPiz1NCOqRFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 10:26:13AM -0400, Zi Yan wrote:
> On 17 Oct 2025, at 5:44, Lorenzo Stoakes wrote:
>
> > On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
> >> Existing __split_unmapped_folio() code splits the given folio and update
> >> stats, but it is complicated to understand.
> >>
> >> After simplification, __split_unmapped_folio() directly calculate and
> >> update the folio statistics upon a successful split:
> >>
> >> * All resulting folios are @split_order.
> >>
> >> * The number of new folios are calculated directly from @old_order
> >>   and @split_order.
> >>
> >> * The folio for the next split is identified as the one containing
> >>   @split_at.
> >>
> >> * An xas_try_split() error is returned directly without worrying
> >>   about stats updates.
> >
> > You seem to be doing two things at once, a big refactoring where you move stuff
> > about AND changing functionality.
>
> No function change is done in this patchset. The wording might be
> confusing here, it should be read like:

I made this assessment based on David saying 'why are you making this change?'
repeatedly.

That doesn't sound like a refactoring, but if you're claiming these are all
invalid...

>
> After simplification, __split_unmapped_folio() directly calculate and
> update the folio statistics upon a successful split, so An xas_try_split()
> error is returned directly without worrying about stats updates.
>
> David suggested a change[1] to make it clear:
> Stats fixup is no longer needed for an xas_try_split() error,
> since we now update the stats only after a successful split.

Right isn't that a substantive change?

>
>
> [1] https://lore.kernel.org/linux-mm/518dedb8-d379-47c3-a4c1-f4afc789f1b4@redhat.com/
>
> >
> > Can we split this out please? It makes review so much harder.
>
> I asked Wei to use a single patch for this change, since the original
> code was complicated due to the initial implementation. After my
> recent change (first commit 6c7de9c83)[1], __split_unmmaped_folio()
> can be simplified like Wei did here.
>
>
>
> [1] https://lore.kernel.org/all/20250718023000.4044406-7-ziy@nvidia.com/
>

I mean I am not sure why it is so problematic to split up changes so we dont' do
a bunch of complicated/not complicated things all at once which is harder to
review, more bug prone and makes bisecting harder.

I've done series which consist of a _series_ of 'no functional change' patches
becuase they logically fell out that way.

But if you're really confident this is functional-only and is a simple and
sensible change I can take another look.

Thanks, Lorenzo

