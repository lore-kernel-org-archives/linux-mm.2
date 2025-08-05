Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E488CC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516676B00A8; Tue,  5 Aug 2025 13:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6B46B00A9; Tue,  5 Aug 2025 13:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38EC56B00AB; Tue,  5 Aug 2025 13:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29CAD6B00A8
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:32:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0E8680AD7
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:32:16 +0000 (UTC)
X-FDA: 83743397472.29.09B32F8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 86352C0012
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:32:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="O/uM+vkH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qqODb9Fy;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754415133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T9OTnbzKIMIv1S4O1sNy19Ly0cpponzQ3Jr3ACBiOQY=;
	b=EwP5qQPPY25bj/J0BPopA8aQmJ4ain8Ns24MiCGX1UKrZDhHLpGdvzkl/jMebhrb1lKelR
	dOuIIHgdD96vf3S08u0+uoztHXN1JufAf1MzxqjT7MjUbAK9rW7sgyDem3GMVbxKmu9ElM
	aK1h9cxVbzeF3gArOaiMGusNz+av/LY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754415133; a=rsa-sha256;
	cv=pass;
	b=u43/VF5wJ7vK09dG7lCuquHy2RFEWqYNZ507P3SfGc9qyBSdoxamJm7L6K9z/RnUs2oSLV
	bImVZ+vYWAZ0ISfTwlDT1zUKPLEkDjwLUGo6pg/k2hvuZKLxdIX+yv8DXSVYgT5QRKUgGM
	r25lAOmkvvcPW19sEN9dnChSrWD426I=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="O/uM+vkH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qqODb9Fy;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575G194G004085;
	Tue, 5 Aug 2025 17:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=T9OTnbzKIMIv1S4O
	1sNy19Ly0cpponzQ3Jr3ACBiOQY=; b=O/uM+vkHN7cJqYMxHCgNVNl6lTQoem/O
	DJiX7e6SsB5sRUO0HaCajgGQNyoLnI/0+czlrJEdsWz/M8bDn7mgqMDFiAVoEJGN
	XsHXHUFOys8ZjsaqMnO0WaD6Ca/hICoJn2Y1EpaHAMIsDrdkwRbrtiMPvQd5e2cU
	uwOF4iK7/Zqz7SgtXbpAH8bpyjXCAIrAHOLK71TK+XVOEW3sa2xx+/dUD/S00UHE
	QyqGh4G5MBrBVFg8lyA0kdrd97uwyrzyGsZM5eTNGmjivn8k+A/ikjDmEiUq12D2
	5kllW15nYTvdEGgncAezhU+U44rCuGSp8Qcyr3aisA2VU4cxZJgocg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489a9vw8rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 17:32:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575GESow039799;
	Tue, 5 Aug 2025 17:32:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jw7ck1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 17:32:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVI/z5xIvk93a2+FIWHU8iqCuFknwNMXM/1ntJMuUI9CsPgDfKoagMskNrG1ivKovP+5gtOJnX7uKdtlFUKHMe5WAhcBJ0FxZTaH0UkvcRDDUXbJCnPisegwrFgZKWPLmwip8mrDJrF8GiaPwVQxEOfJ5a+qy067wrd52KkFjJSwfLk8Rop08yvDc+i/kP+TPBheeyph1tbhsWgmvvQ6DlGfOxlM+Hr4ExZOMtPMBGW+GgP0IuF8pFZVB0xOTrZU9jBEV17Giv5xuuRDhQ3LRcKICsTsxRzmcEoKCLs0aUVLqITaUAjTEaD5lDD6r8PQYcnMWppBMOxgM7NVswXO4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9OTnbzKIMIv1S4O1sNy19Ly0cpponzQ3Jr3ACBiOQY=;
 b=TB4ZHV+0fUgd4JtjAqRBuqlIHgdiOS14bga1tjuQp0mUxDlXo7xfl9BS1uogvaDrrmB0HoV6TPJ4yjbP56bmMBOOSeLSUMVLFUtjM/8pxfxrith6tW5V+TKTEDjFa1JFM9w5ciAP5b/DGAqjj8m+YFTZgCnk/jb6elWY6D77XpvSMNEgUwXSoM5spUGCGGCLFdqeYQA+U1otLrQpocvMd+vGv5IyDA/cSnpF/JiHjHO1kbppIREIhNrAHjWlXxuU7+RnQISTVxEvRwjeE21oI5jGwFEMVPYesd4xQ1noQm9O0C7/KTr4J+3X1Adsge3DTlm2hTWC9OrFAOWORufy1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9OTnbzKIMIv1S4O1sNy19Ly0cpponzQ3Jr3ACBiOQY=;
 b=qqODb9FyTJvRtH2K29nMNurIoCT2YZf+b0l2OmKy54+5lJJwjwCSPB7iePEc8uplnUlXZG8OL4CmG6gaD7ITTpEdW0dfqCz2NxkjaQzXr4p0BORA8BIlOVMKvd5cLDTlRgcZrJ7GXBQ/ArnkBeNFQzh0UfYiUXuTtuYabczh32A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7202.namprd10.prod.outlook.com (2603:10b6:8:de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 17:32:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 17:32:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v4 0/2] man/man2/mremap.2: describe multiple mapping move, shrink
Date: Tue,  5 Aug 2025 18:31:54 +0100
Message-ID: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7202:EE_
X-MS-Office365-Filtering-Correlation-Id: 4943bc52-d893-4d2b-ba47-08ddd445fde4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yR8eP1VnXessWkl+N9mM+BgMEUJ8Apv4lmSYLMbLzNVabpLqu4v3Rc4MLaqX?=
 =?us-ascii?Q?/s7VXtaObQb8/XwodfoDOCGM70KP8T1PmQGgLzKuiaRcYDzvcWX16zSocg0Z?=
 =?us-ascii?Q?NVQ2rcczKYrsy630sdBItWFoNVCi1cj7MtstYczQ6nPZAmzUUMRRIkre21bn?=
 =?us-ascii?Q?hop9aSRGNkI2tobeKEbFMSvWl8f4LNCu6lpkkIwBsToJpF3pBvIniPcK5fmF?=
 =?us-ascii?Q?isxcZOij5h6Nqs8Bj4bfa03z/Sc5hKiiTLP+ACcvUjihSUb2jGdcnemnBpYf?=
 =?us-ascii?Q?vrZjeI7P3IXFBX1qliHyekGpKo6vVZQSGLRUb/5vkfkodlv0vqzfodl2HVUb?=
 =?us-ascii?Q?mCgcQMTw/NrMzu6/47HbQCMb3e0d8Z5LfIvCiRf+rve/YBHiVau2v4h8Ia7H?=
 =?us-ascii?Q?rgpZa3y3GlI9S0/gnk+XDUAPOCQvoQ/y65jGh91ivAEQkTLOFFqoa4sznB3W?=
 =?us-ascii?Q?jWzKUTeqN2nJi+s+WGKBQwBWoQOtCiM3vf19tYLM+xzql6gVtiMNUvRrPmY6?=
 =?us-ascii?Q?cSLvQdQI/3PgBG+hgdKd6adzBrr33AqbfIyp8Xx+FklGEGqi1uVenVNfCY7K?=
 =?us-ascii?Q?va39tId1Qgbn/kVmEOem5HEDK+cmhdGd55GdXkwZGYHXApu/nctPCjwMAvgC?=
 =?us-ascii?Q?Jsi9J0c1ev9RJRv8SVjnBteqFnEAAZ59oeOhWNqlVappEd0lFv6Pe77BruYr?=
 =?us-ascii?Q?eLFILV7LNOYsZw2GZutU8BfJakqqii0q6oPhBYXq1Utu+VUgvPLha6p25cvO?=
 =?us-ascii?Q?PBagUq5IcRDUf+y3d/V/D26qxvOazWoHxFk7l98bIc1709I/34dPdpbileVC?=
 =?us-ascii?Q?pkWqhplmjfbXr9ZMLNqw4mZ8pWocvglouJQzwnUqFq9bShulCyaeurvpOZBr?=
 =?us-ascii?Q?RcRg1kbU+OIp6sxQ8TATgpVDYFfIThkU080elJbPy3Kx7kaRiHZr0oR/k/ce?=
 =?us-ascii?Q?jnpjYOC5q3c1m+PlB/tHTAJHl5DYt8zjrWld3L798+j8r3auXsOWyuDYcyFG?=
 =?us-ascii?Q?j3P8B+LQiYfWWLMIW/D1jAfWzaXwftnisGqxI/+fbU33zqh3kZmdTtXBDaDS?=
 =?us-ascii?Q?LOn8TljqvxXRZffUOCV7TQJyEPgQG9yiRhJhymGHL8rFDutUbcYILCS46/6U?=
 =?us-ascii?Q?XmlCErfgiIwzXV7xF2uAVGuz/E+dikrDcCCNsvx6zBVdLfbc2OMm03e9tdkD?=
 =?us-ascii?Q?aR9LTKfB/AXLShIEXP2A6TgFw2oedGiqBZslNW3cRQZVY3EgownmIQ2ys4HM?=
 =?us-ascii?Q?Fh+OY0iceLD2TTiNi9Tu5wCiIojOUORkv5rqo0r28V6lLCyhT7WJ1nVM0Nln?=
 =?us-ascii?Q?rFBz+ThIjWLjc76ve7SgMJj3+nSXw2qWeFMkp81uENEPJRLlAN2LB6NEM5r3?=
 =?us-ascii?Q?wEFVuM2s6YanDvbWhXfe6lolHheDt0ntcRoEAD3QJsVK5BBewx+TlX3WCUK0?=
 =?us-ascii?Q?BnlZCa9laQE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YyC47JQV9WniePjxYA8VlX153HH97uH6nG98SofdUkO/sA9m530iMpgKYVeW?=
 =?us-ascii?Q?KAx0Po+iu2Nh1xlNeUA5FBO/I/sA1oXzu6NckyMz11GYGx4+zDN0GHVzgU4x?=
 =?us-ascii?Q?uP9NxOU1dvRXYd0q7Km1AO280VQ8qsFwtYn9q85UUTh21A7qJgk6Jss1OdrN?=
 =?us-ascii?Q?QbZIdNxRQUgtXoC4ifQB3wIWN55bjp7mU2Ei8R2e/lY/DqgCbljsDFSkTyq5?=
 =?us-ascii?Q?h5XIUS4dSQD4uKRQ4fRYoMn9xrpuPoea/rhMzaSxzTs4UHh3S6XcNTiCekgC?=
 =?us-ascii?Q?6otZZ5VjmNnCAqT4ZsvvDbyDRiij4dxZ7sLtF0ZBbuk1L/W3dcQ6rO1tZy3W?=
 =?us-ascii?Q?sDGFH97358xjHvDvf4cJaTCEP7Wz2/J0lAUnA9BUbTpO+CSemhi43PH9M7nn?=
 =?us-ascii?Q?yLGxRqPSTerxupUGohR+LXd4fUF9S6FzQEc7Aj+ZavIf8WAmwg6sv4S3La24?=
 =?us-ascii?Q?QtSqZ/7KrhUurdeJ/vSZRBNCwCS1haM+VtjQhkaSys42vbN29MX3OdQBmvFF?=
 =?us-ascii?Q?o1uUHQ0LCh46j/IqYTjXstq/qGeJH7OoQTlyvMp5Tj0H0mMdwjK5Qzq+s/V0?=
 =?us-ascii?Q?LlFQ1zTjZgqYuYGZKFs9t/mntKGvJyi+41L+3slaCw/ib1UhVpIJwjNnglZS?=
 =?us-ascii?Q?IZDyn1wqMsnUGeqHUP3bBy5cH/k1mqHNdBMBMZ7dPsM9bz233f3z6/GCY6ED?=
 =?us-ascii?Q?AGj6qo7V6BuXJdQljYWXbzlb34ASZouAFXP9gLXd0+btvn6DLQ53pVK+3IwZ?=
 =?us-ascii?Q?RkbkhUl7J/fwpKDBrUiUuQrFmnjXprAzqYhn3jvnG6TdvKEvo/EVLiRl1//7?=
 =?us-ascii?Q?RfdNyaxL9h+vtwH6CVUsL4C29rKNF6dZ8knOGwj8UpzdxvtO8T90HllIPr5e?=
 =?us-ascii?Q?TNgLhrw9v/qATXwcD0g0+JZKfUzwE0dUZ4uHLpNiZuXuWwTVc/GdOFZq9IYX?=
 =?us-ascii?Q?a5sXkun4PIXDlVH2RvEL7c4eiUE4B6MyzvzUT/jr2RbM+s7JUV6yK/xLPZU6?=
 =?us-ascii?Q?l8gdgsj+uCVt97+UULRhJWIXXoq39f14MLSi9khP+/FURXn0YlYgYOayQ0Hj?=
 =?us-ascii?Q?ZGiCHdu6q3Y5xi1d8AM1Sr6vf4vhK4eGAG6H/ccg+QcnaO2V4h+t8FWqN3Fu?=
 =?us-ascii?Q?hPFtXLJd9P4x15dAzlYofwg/TLmI4OJPoOQQuENL3qPUL13S5cVlJ8cnVwgd?=
 =?us-ascii?Q?PyQD0i1q5Qziald4JNCZfXjN41T4Pb4FFSsULGTdNc9TxsmDz9fWNtXdcr/F?=
 =?us-ascii?Q?WxNLg7vJ/KClGy2lQdYsX0gfelj5Y6hKTY45/Pbl+GZAd6//b06fssEaPDPB?=
 =?us-ascii?Q?qamOR0PRcorfjEU8ikG5SIue7KCBeXIwX5aW3rL54Es1nlp3zN/jNomH/VUI?=
 =?us-ascii?Q?XGT+jX7z+fn13kuvC7jOFx56y7Y/jFMlzDbWTlLS7ylqg9+ljnOhYqhsO1qY?=
 =?us-ascii?Q?+/u1yA9nUgkjOcBu5ZFZNluP0NQ15fBPkIPYqOCAKFBrUWRZT0iMAdSC1cJ7?=
 =?us-ascii?Q?+kZLLyeqoQmmPAax96Job0qpcHINHC4N3aMekXutSQOZBRJbUkIY8gOFNyhV?=
 =?us-ascii?Q?ZdzvXo8Kd4nbZYZ10JgHkm3rAOBx7onwba/hFzWlid7QKW1/ZLraBpj6VVpA?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N36fq3cZtlZLidEvRSMDa0GAfKCGrzF0LJvPGjmPewHCfAbXB+vjTvQcnlvVbFimPsrofXEvSpPM5QDcjrjOyV/6L0OX/i/UbUqs/ZCRgFdU6WQztaOxnnKmTrZOj+iLbQ9DYiv860aER2b2/aYG6i9+GfKBYfNk/7xocJu4zgrq2jYDS4Z3DBmq0oruxEvCtgUbsDW+RHlFiYxgBhvfgfo0NayYpTeYWDDKvktt2qfw8DGYowqvdOjO3BPbgeR+AzKcLsAPIUsG+uKD7o/8pZMdl5Cw0i4hR941MkKNsy2KorAEDGufLYS78Jta4RA1iC0U32dWnjfdOSOFjQQK/iLTrCGKS/YkCBnqpfwjlLyf8G425/IQ/HFpz7DRDvNk4uq0U2SwFujN2BDjPa/9wIozzXQPYoA4Gx+BEti6pRlTu9mnBMuzcmXIXnsLRdKeHCsmuGSjZSsvX8UeD6f4CalYFILVZ6rVYBl2wLNy+WPluc6y9SCqMS56gxeZBk//3zzw9Xc0CYrltU0zssCKuAmW14ceCDfUZk6quVnSKc+J+5bQvLIonufwLcNIfr+zgsk+xc8URtSu4vy325tH72DzpOUhEVjpJmMMegs+WEU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4943bc52-d893-4d2b-ba47-08ddd445fde4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 17:32:03.4659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxrN2R52CekJ+VYlxmYraYnieiWKxhY1WieVqWeLmRL4q7MyU3ctXI2PqPRopFtxNI5XC8wzZC5j32W0PjkBgOOBWePihoeErYqaPvsZrVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_04,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508050122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDEyMyBTYWx0ZWRfX1VoU+7SiXEuJ
 wME3esX80iGz57rS9jJHtivFwtLRXCUhp9ftCkRtHlQbnNnYCuZy7zNNvUvb5Jt5wQS84ut/Oiq
 y/pwTMgcokjgLfLmIFd7jNpJtI8uTYD2iJy/TZdz42UNY2YPrjKBe8fZx0n7+6kFe/4yCQXB8He
 4MYPH6VLv0oWQtx5IJ9VEkuDRXzCqm0cjgk2j+frr3vueqkCyAdYVG6aUSIRdHmIFgbtAWs8wXN
 r3JgxF5fQX02WkdWqo2a8DkfB86iAN0Oi6iCxpjVUTOInH5Pqre48pnVXKNlheywG6AMWvkHufE
 YkteELC2Rwbx2ZRPWyvMYeyl5kGmDohESbZ5tKG5ssyrq8swrheg05aLlqf70R8AJeJPzbrBS8R
 AQ2IDykfGFioCrbiJv8XKWiduHwjbgodrHKiWhPItbqhw0Ib2IgjKYQYli8U9Fyv4LfsMZnX
X-Authority-Analysis: v=2.4 cv=SIhCVPvH c=1 sm=1 tr=0 ts=68924018 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=9mf5EtBIIUb1FQ0h8DgA:9
X-Proofpoint-GUID: -621CfDK1AxXjOqnsvq5H2REENMoD5XG
X-Proofpoint-ORIG-GUID: -621CfDK1AxXjOqnsvq5H2REENMoD5XG
X-Rspamd-Queue-Id: 86352C0012
X-Stat-Signature: sxidbphsh3x78aa9hu4bfpk5i9rpaqfu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754415133-905646
X-HE-Meta: U2FsdGVkX1+gfpA4ypK/4IMbKaZfcOrHSsQ+QTpEesAeLLwOW9FnBWhXuprLcUCmM3isY9jP9Zby5znkwV6HpqiUIinfwPvtxZ9zFiP30cj3cEK5aqsomDfC1e3YYhf7cN6s50K4NpgvEARnyuadiX29a6/LcVyXDJ3uEELpZ33+zDUmLYqr7h9kTMUQ9hiRKfBAFpRcedw+pZryeI0xveRy1T+lF3NmbTWWupyLegeBjeSS4W591N6+bML5KtTA8LObNxN1+s7bGeQEI3iHLNBQi64hZ5ZM6uGWoc09JU9Sfm7jOjdPzoovdz8Opyd0FmMpoomGQb4xcDNxu6ORSG2OBBtgVtlZCt6pFmpIijQ4gsErFXpACA58fU+jQs1+lyY7x2BRexvzNQFmd9Pxsr/oiU9julYJu6pTMjfyRdG6v3G32lNdIQ0040c2eMXUmVId0Fa4CdFsn+SMxdkX5btI0fHib0/MQ3PndncRdx6eqZQEGCem7lIlapd/cSgNytpjBBAuCfbzvSDrPmHWIjcsYNVaOquB+phnXTMg3/Ddml9H+cXNSwQ7k5X4CXgshHTLltAzRkZwFAtOMIixGkqqnEDB5t+VV2Gwre7F1oVTlCBRRo5nJ3Qz2/wVRqy1jFoLEi53QuegNJ/TnnQExF7qx+Jv0RhEeepYuu40vo7iqrbR7Tu7mcT3SjSxSZM2NCRVuOLRkBW1n6L+nJ1I0Ibl25NF867d8q9BUjOEGgoInMVMG6yCv5CK8/86XP72Ly1b3w83tUeQRweCa1ffq7K+JMbopi8Om30pPZeKRw0M6CcNeS44mSP4L7kwN+U5DiV/mgTDG+NfZgjBBggLMaP29T6QMMcNFEV5SsSzwpn5srew2o7PfL6KJ31UwmGxBPlke+ay8Zh2ah0rViOGYJ5WQ7yhLjPEooti7ibpfF7C58OdLmWSYBDpS06iK/Pq8ORsQJn0uxEgYQTJ++3
 HAojFjXO
 4d9rk/F7GEoK1/TytL3XtBN+RGOKy4zHpozLYrTF46bAHXZ8oyhyWjIlG1pV++yC1eol54Zv29xRCBa0/XzG3OC02wmEHS80qQhug+s4aTomYILf813nHCB4YxFOvJy8Wt4aUSKfdcqGhxNWQHWIlcW2xkr7w+vrpix51SEhnvnGS6TkCCwaIMqoDC4ASBbs0JtmpNXMtel3ZUPNxVyBeialEpwBVxEt4ZqClOnelUYni1iuoezU1bJd+RU6sCYMKWGuga8B+WCCV4YRdV6gO9KjEmMPpJ7tImGqd8Y4mKBfJgm8vL0S8z4uFi51w+FC42lp3S5LJw7/LQuUIbEnF8e1xNmx7oHG/0B/T+5eP7v9kovtRYqnw8/AUcn5MYtbnpytxaUPwchiIA5gLUlpFSmlYAT7gOdMcvig9kJDatqMbDCiey5cMz25lOq1aojumVbG4M+bXugDdPDtmLzkGg4KhbpebU6R2+NP89P/U2qvfNGf0LxkAoYHLMMpReqBpQS1Jh9ynjrpC7sho4spwj55zdTbA5NOT+IjRPedL9vxGBfS7TnQ3tMSRw5hGuOT/wsiHYYcCdyxAVsYfot1TNYixaPdZqk4E/BBgrz0ak/KaPefOHabWhayu+O79UYjd91R5o2oS+VZ5q51DVZ8r3HTW7st1LSuUqbLJm7/cFzRkAL5t1IVtxjsDWjC4rsa88axwxKlewzel6idIalZYl4AL4jOqHGWZGu9YVc00nHWTnZLubplcNHybz9Y3gBzj/9lt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have added new functionality to mremap() in Linux 6.17, permitting the
move of multiple VMAs when performing a move alone (that is - providing
MREMAP_MAYMOVE | MREMAP_FIXED flags and specifying old_size == new_size).

We document this new feature.

Additionally, we document previously undocumented behaviour around
shrinking of input VMA ranges which permits the input range to span
multiple VMAs.

v4:
* Update description of newly discovered mremap() behaviour to highlight the
  fact that, if in-place, [old_address, old_address + new_length) may span
  multiple VMAs also.
* Fix up commit message for 2/2 to correct typo on specified range.
* Added code sample to 1/2 as per Alejandro.

v3:
* Use more precise language around mremap() move description as per Jann.
* Fix some typos in commit messages.
https://lore.kernel.org/all/cover.1753795807.git.lorenzo.stoakes@oracle.com/

v2:
* Split out the two man page changes as requested by Alejandro.
https://lore.kernel.org/all/cover.1753711160.git.lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/20250723174634.75054-1-lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (2):
  man/man2/mremap.2: describe multiple mapping move
  man/man2/mremap.2: describe previously undocumented shrink behaviour

 man/man2/mremap.2 | 111 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 100 insertions(+), 11 deletions(-)

--
2.50.1

