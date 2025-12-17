Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A74AD65C40
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C04D6B0095; Wed, 17 Dec 2025 07:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308746B0096; Wed, 17 Dec 2025 07:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181BE6B0098; Wed, 17 Dec 2025 07:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05AA06B0095
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9FAC136DA5
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:44 +0000 (UTC)
X-FDA: 84228889248.04.1A9ADEB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3DBA08000E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oUsp2a/O";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tx4shwJh;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7A/MFiQPkv5fgq++rp7qNeYBq32yCXRy7mZILSJQmd0=;
	b=3tdSsBp3w59p6dYMBcUK+7gqV/fmaywYVjgNCowDMJ8SGwghW8ixCGmBpMP/Rx359nXxxN
	CC3gx6xFh8FlBR8+FPBC+/IeTuGLhQQ0Q2D/+PllGP2C1nUy/UgJu85OC59CCCCo7wDxMI
	AT7ggIAJmxhdkyMvSt+HA2iJwTQUc6g=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oUsp2a/O";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tx4shwJh;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974461; a=rsa-sha256;
	cv=pass;
	b=X0+oUJ4PCkoAO5LoL+sI4Ja1pIf+0KnADJ+e/4uT9N3GH7Nphqz+XEZ2OnEJuirGwbqOv3
	lY/KvvUlRI0gxB9ZrOQxNrI6cq8maPUUdxRQlgJ2aRc8uIF3FdYU2sAJo5TxKZOrp5RE/i
	KhqsX7gg7VCwMR1dI+Nw2CovteYKRrU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6Pu1Q2143291;
	Wed, 17 Dec 2025 12:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7A/MFiQPkv5fgq++rp7qNeYBq32yCXRy7mZILSJQmd0=; b=
	oUsp2a/Os9RTGE/o9m/pL1zEyMT8M0n3ssu6gIXqtmUx/Z8NKOnUYECZkWPoocWG
	wwmkDmMTdC0KOEwNpRvSuC4T2HeWrsVQiL0Ywgm4O2TXZGXKdb9bFizeb1RHyDCZ
	/sKLEoj1KeCStybVek6x1cxDi98ho5rzqDh46qF9fa5LmXcVA1xet4aT/pwuZ1xk
	ARlIH2QgWwWPcsWiL9TsHURj+5aLEMVGApxZYMTzKIQU//sShfdY/Ey6S/dLNtaW
	bhtWxDHnOMvRuGRGY7ihI9hzrPJa+Fjum1jp1vYOj1iipTiHiFQnklKVycG+pxR9
	Sx5ueYP1w7dC9ezV2vkXCg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28dtxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHBUJju022508;
	Wed, 17 Dec 2025 12:27:34 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013030.outbound.protection.outlook.com [40.107.201.30])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkmgyq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w5o0g7EPNCcDH3JI3UzJihNJ2dOMXWl5FCWfutuA50o2e4d2zp8jYqVrr+VvXW/6AzZbKg1Ku5ZT1hnSh6rK+9zLoDU8Y+1kamIqmiVaU494O1gwvnEWlJmye8OMk1VtusJ2e165QS8uX9sYhvhbhtzaFYNBnJjFpTf9vnMzzvxfqAbKcdvCQqzt+F+2wInK9XJtv7L9akDWta1Eiytpm+GeU9wAwd6h4cXlocbbVrDMz8INXbgXZAPuebswHXaSzssH5JEEBHkvLx5qjLnp5sgk60vti87RglEEyZapfNfqQfhVsGdVb/CCZxJLayCMU5Hu1rIGMZ3/zD8jhhJipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7A/MFiQPkv5fgq++rp7qNeYBq32yCXRy7mZILSJQmd0=;
 b=wP1j1cj9/aJce9pJzyLKnmdtIU5XQ9savkfjbCReibc53L5BTOwUAV3x4/dRlaC7MH0Dlfz5+/EAfr6+V/tTjB3CDasTm9xudmYiiHuk5BtDTiMGo/yE78zuCy38b2PBa+stuZaxdEB7LVB6Ohf3LZ8nL+2Or0KSErZDYzTtZShEgD+VneLYu+WiiXxLYnJ9Jq+jjz3+5nutEcXM/uzPcwqscQYg6rqlyeDKLy/Gam+qv3wCNFkjocVoLxDbdavUF4Ev+0/6TGL0VUJtNtxw9JojiaGBzH37qv2e/t8hknkyXgIGR+P1DlDAX0KaVIUEAsxW3OSklWDujzNhUXX/fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7A/MFiQPkv5fgq++rp7qNeYBq32yCXRy7mZILSJQmd0=;
 b=tx4shwJhugwgD+qAUyAN2ELyubTBeU02ixEi49VqgtmkQzwkV3ifukAVV+8GgM18VWFNYnU6oDGqsHuAnQy0VvqiQFIP7iIm/5ZSsII502uAZ8bHt0jSx/qUJhJu7gnJ3mDFcIy5BBHT9TieQGITVamqqsK+kvu8I6IUUFXixHQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF545856187.namprd10.prod.outlook.com (2603:10b6:f:fc00::c27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 12:27:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:30 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] mm/mmap_lock: add vma_is_attached() helper
Date: Wed, 17 Dec 2025 12:27:08 +0000
Message-ID: <d3d98a5fe9ecd0b17acfc359d0c92b9e929cf34c.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0358.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF545856187:EE_
X-MS-Office365-Filtering-Correlation-Id: 22832b9d-2fb8-45eb-96e5-08de3d67a5af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T+5L8QdvggDLM0FE6L8DpERt3B3RbIy58VcoE98+0lvNkhkwjcvUAxomgVjC?=
 =?us-ascii?Q?yPGayWYTR3cvNKwOAsO4OMmo1I72ayuuPRkv596RnPxC5Pl9UqBOaRev6tTH?=
 =?us-ascii?Q?zHAHfZo4/7NQsJx3JaXQfnOmlvcj+2acxid+Q0S0nHzcEsi6z+j0V5gCXtcJ?=
 =?us-ascii?Q?nCEErBExKvyiNqaSEqhBW/e+tQdTE+LCNiLxRs3Qd4siX0oCIkW0wJ5HFbOO?=
 =?us-ascii?Q?fodXHs96cbMMA6FkN/RXALDzxIMHIddjCGJhtz+92UydUwYEUGbNcu0Wx1BK?=
 =?us-ascii?Q?xaSS/C9yOPtBBp1MtR1tML0xN68up/5K+/YHrGmjdAMWI1BSjT5B2xfkTWX7?=
 =?us-ascii?Q?8iwlVvyc7xORQG5Q4PXD3LavJCJN58UhI2bHW4cbJOClHp9dx3O+7pfE/om6?=
 =?us-ascii?Q?dL1QBn5MA4lRGAJ0vvOziTtkqtby+l91ofC57EemEYzjmc/jf/QuPr9pp8Pv?=
 =?us-ascii?Q?Ywi2t58yFvApgH8gkyHkooSlTZm/Xz3eR3CLvixIbLaH0lruNkvLioXqysY5?=
 =?us-ascii?Q?mXNMlDiMofcjYBf9e/N0XkgHs2u8tqfdNfSs4H13xI5NX2otzSE5j/QL0yld?=
 =?us-ascii?Q?G1QytYKoB3zMvUGUHB9kvBchp0nHEkGktUsO0fRNVdt7/Z4eBZAWc0DJcgjE?=
 =?us-ascii?Q?LjDzTyUNXmJ4/JNB75YgGifLx1eiOJz//7RZsGGP3/3Dchaqd8uk7d7Tne3e?=
 =?us-ascii?Q?cJQGyZmweSUtRM4nTKXt6G6qc0EMPqth9ljQmnve1ATNolyPVzwSkosgqpd8?=
 =?us-ascii?Q?Utqof/gSIfFEkkmnWZjA+wjob3pO2l2fmRNU1+95qI85N0YJDkrZwMPk350Y?=
 =?us-ascii?Q?nf6dPYoxbPmZvYZRUDdteAeRvFaLJ+/zUAv40I5VEIOaJxLKnwVSqnLSFiH7?=
 =?us-ascii?Q?eGZ0aeRQzsiIwkxorU09hGMbdT+ZjZP7LtyxP1ktUmGdjpbytaciup3zND1v?=
 =?us-ascii?Q?V51DI95hQwEd3jG9IfdXj3x0B7tX5uXa83mSjt3Mhd2X0dswhqPYeghm+IzE?=
 =?us-ascii?Q?xrdB6aiTFtxOfcBVUExPZERUc5rTQ595Rgiqq4HsKSQJti5BK4w+EB+jm8l1?=
 =?us-ascii?Q?2gcZUE3ueQF4IRTKM38VX6YamhsPdb6P1t9hn4uRIjYBenE02orri2+B4Olx?=
 =?us-ascii?Q?azUb2NHRjIc38nrraChOpdp0seBgeFaN6IhU5p3To+8z67cRBAFIVnR2lsRY?=
 =?us-ascii?Q?eClmxPPPdjBPRUS3KHkhL8PdtFaIPU8svslSXisYhOqjHOGujLbH7U45vCFs?=
 =?us-ascii?Q?8gLrNfpjXzAHXvopTryrC8EDh7hGK9Xp5JC9KmxzmIReT50Fkt7d4Pue1F8E?=
 =?us-ascii?Q?ExhbFGeen9bBvX5qigu5PUmxYASzLgYb7YHYbfhz7r/pcGxX6MQ9L0HZ9qFI?=
 =?us-ascii?Q?a5t51GX8xXIGPL/Vj2OgleNw8vY2r7MVNXSHFsx//7ziVAgKjQ/+SPn6W9c6?=
 =?us-ascii?Q?OAQjknbux3z/WeST43HJLYxVnj+uqsme?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oAZn4QZ7rUBTeyWGHSlEvqZ5cFWuKXyQDpUSkmnd1BJhHWAKuf+bbEkTXgNj?=
 =?us-ascii?Q?6TG2hjhMFOurYDKM3Ouyn4pm9yDHz4U5VqzcgFFOETFUEmhlqamZL434regS?=
 =?us-ascii?Q?N7Z2rESFSD+sjnNWMT1EjNGDnZuwZ+YeEAAha1W+RPD1IuSEdmzMcOhC+czl?=
 =?us-ascii?Q?qEYuu1b2z1XWwCtkogEM2iGoGJ4xX0tgOcYxnhYQvDP0F0hWmR3YtuUbSQL5?=
 =?us-ascii?Q?W/9TKic4E1C90Q9WHorm+fRdkBddExKkiq3Ip/Xqj0eNp6ztpgBH96keAGtt?=
 =?us-ascii?Q?D8t/Q6s/QXy35M/jWIL0/OQZD/hEhpitQ9E88/MTuqkwmM9BiHyNWNhtNwL7?=
 =?us-ascii?Q?NLKrbK02AgijcqBAm/6DhXo4TMzbxYyBuonlrBbttZm6pI8RwDpIaOrdtRqx?=
 =?us-ascii?Q?3Ml9WTC0X5wvIbPr4NY65UmO7dysEkIJMYsGvv7CK3vFvOX7wuh767OrvMnb?=
 =?us-ascii?Q?tHp2ome1sSiwE8lyCl/a/KsQBY1q5SVTnMz169aWNxBYO7C0URP6pv8JOiFa?=
 =?us-ascii?Q?0CCuxkpBYlD20aloVD82Mcs+GewC1vFdmFBUb5UoecpTeV4I2w76oSaYWRFt?=
 =?us-ascii?Q?ZfADrCsl6lcWfnxn+yoBShswhYgCruc1TxhEUqBH/VfAwxVecQEtmri5uqYO?=
 =?us-ascii?Q?0V6b6pznzJjdOZz1as7I0lCX59gE98IoHbLx3PYwv4ncIMmG9VQ1CYZ37dw5?=
 =?us-ascii?Q?CYGQgRq7EuwfA1ba4dJX/0wHlEev/AlhyOfMlLwDdR91dMM7gDkConDOIL3r?=
 =?us-ascii?Q?Wq2Y8gC7bRWTK8BCCHHS/eU0Ngo6ZdZzTv14FA0X479Md+Hf491uRZMO92HS?=
 =?us-ascii?Q?VhpYZKyaDPo/aVG21fohT1ZHgFJzNoHXCumgz098HjxogyKUav5eaxqu8ldt?=
 =?us-ascii?Q?oIXaSdeb9cQVUOtH94rPfv5Lwlt5nLCJKeRVzdtJaxwfIuZgeFSJOrGh981N?=
 =?us-ascii?Q?rdcRsuVLppfFiYs/Bn7J6FqpdRjIHiSmtbdnuEUFFRXu47nnDZm534wmRLBc?=
 =?us-ascii?Q?qLlYK/uZ9CBW9AUiwpJwxNPQGdyF1KeSoRQgmHJ2VBFDsdp5RXfSu71kxzHt?=
 =?us-ascii?Q?z6pGGgG81VYJz11X6NmQmGoUUlINVy8vWBo5tA/65dzZ9SQUx0LHvzFaswvQ?=
 =?us-ascii?Q?fEgCOyEo4Mhe01kC2fYHWYT2z5grRI15OV/hk01WyNMsKaAn4DvnZvC6iKYt?=
 =?us-ascii?Q?rcZ23C4raTplhUCzCWhfAmRWFeNfnG9L40uT/wGYiqPWnwIFA4WxO2wT6CHS?=
 =?us-ascii?Q?IvTH8gyIkxsovE0ex0vkcAn5Oxm91cS/jim0Xm4voV03O2Meu2KskxKZKsgv?=
 =?us-ascii?Q?kCkfEmGlb0GR8hogXbTcY4b0efkvmlaLt0t4es4aHmClDaQBwh/kC71WxPRQ?=
 =?us-ascii?Q?xm+IaeYgraROAYhfl2jDmAKVwz8KyzrygX//mRY+As4gs75JjrOkGocEH7To?=
 =?us-ascii?Q?m7aIwZmWbZPPwq4fA1uriSNiEa5hdNYLz8wjwfZh3JjN9Ky/GwCvOAUfXmQt?=
 =?us-ascii?Q?DP3hx7fFrDSDF3pVHjEt7lDDmjjZp24SRfbnUQldTePyPUIqqnVdn2GA6SuF?=
 =?us-ascii?Q?Ag7vl7k+XxMJheqNnebRepfRhXNzJecr0DEEri6azQABolTisdebBLedNAPZ?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HHg8yJzbXGfBwcMfEnVVF3rc2ujBAGn7Go/p+CO6EI7lRyxrFXmaCiUhgM7ivzvIk1teNVuMmOLTY9ppUM1QdiBdgCMRfa4xAfjGTO+9bc0xl9pqCuffIzQaid4b8LuHe3V2Gabw79ryGALWF6dseGwXys2XKP48ORhXnWtbytfHXQC5BYTNQ4ayzeDXjBSqP3cULDGPRP26VXknUD7mxKVUoW3fZjGgDwxZHSe2RF2OPdLJ0MNYsy4oUi12M5p28rMaJ5W45WM7VMAAgZakTRw/uKAe06YZFLRlRCt4XiH79l+wlX6f0sqwo5VdKsxPh4f/dE/cCaSk77h/IV4WH7Ar/qO5iUkv6AaWhjcQti8m8QWDdOTgH5qxDRzlP/MFyDpjI1PsyMbgVchZWWXcBIC8ncXaMWq54ua+IC6hU1Qly2SdGaKAOSqs+m5iE0YMPFk+dx8fCcsD4oJbVk1y5meGmr9PKB1eGqqlanzWq4WIgGANn7p7jtOOdhQsjVznBkfQ0EkrlGaUR+cwmH/qXLbfV0YbfTNnst3CLpWH4QgRte3TDpTpr9rFa3DQufsyEuN/CKvwgwFDlpyQV50B9XMWd6Ao8wRSIl1DExAhkMo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22832b9d-2fb8-45eb-96e5-08de3d67a5af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:30.4966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DGOqFlG+PmgVKcAmEZaYYkRxdmYj2fEMPUPTqpvfyMqoqY47vxaquOqlVNFPW4ALqrQx/J49ihhO2M0DIBnnyOfu+DK9bFNLEOkT/NTFujg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF545856187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-GUID: aQhIKXdm9lKXYqLlK8BBQYEOkRCDPUTs
X-Proofpoint-ORIG-GUID: aQhIKXdm9lKXYqLlK8BBQYEOkRCDPUTs
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=6942a1b8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_f7RAM-W_OM-GOxaregA:9 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfX/lARvHUEQo50
 Ui5Flov33fTxwEvlzyk+RqyVGG7Mv/W7IzqsH88D8soDtx1R5+Qa1NMB8eyLe0RH7qyotqtmGAk
 DwaPwCkzqQfyEsCWz1GOv56ZreJClB3fakyBMpQ37asNVl8o3BRUtgVyfv3A8b0rFWCRFmhg+vx
 1IVj0Pli+b+Fv+Vgm9pEzwKeLNOp38A8VJ8TesREuqt6KUKglHSX0qqMkb/7suTTVf0tQ4lHqCB
 SC1iSbI4DkgD3fmb2UX5zoHKAYn9x4MK1PCJBSnmXMydXTOx2kS81ZNNxxER0CVOX3beYUe1qR2
 dKTIyN/mmjrpjQ1Kc4p0R9eC4Nag90O98665UWSG27d4JSrS5nkyIvBL8ALbLvQHC+w5HpvfkFF
 B7UjIkJ4pLoLJ/sTAcyymuMxbk92RdK6pAHGup8z4U53SzWJcHE=
X-Rspamd-Server: rspam02
X-Stat-Signature: m3xcnbahjrneorqcf1dzex486mtfornc
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DBA08000E
X-HE-Tag: 1765974461-572496
X-HE-Meta: U2FsdGVkX1+x0eG0D4BDlp8l1BVHpjKu0WFI56OryuQqH68Im45QRgXdH09V0BK6b8k7axgiAMbTxs6gVZ7pZpp91lTdQfUiOkK9GrvGHXZ8loHKoKn3JulmnEb5tKkaVwRfsyUisO485DHtkUj1lEpwJ040X0v8fDB0Q3pSxsL9940qOlucauDEo71sD3O/0FXOA6yYoZyRL/7el97/BEQBnY1fIDX/ZzDNwFn+klxyHijrWOCcB2TMjrVQJlgWrvOxjlkLEIngKxjnPvpF45HffgMM9npwm366malWWReqtARXPloUERB5nDkwq6hRpvtWs+3rTeVasKkPUXRFd6sV6KYKBctgWhDISm6fCbs8fN35xw1QMjCdB/4Kb59ErsyVImxUlo1xD67p2zGkY3YgiimV5yrNEHCz756c84vA9gmC+k8CRSQJWNV15h1R2SxEuDTCMWotvrYCe4xxSC8iS3am7PL7KfMEzuCqfugR2NUpIhDfpkMUrvIo6Z8M3WvEvy/HSQtBZNtWF3ZFFh7QimvoxCCzHfCE3Yqk4Drel+NrDnHBnPAYoGZfRfAhg885fVQgJV9RlDIjWroZdG7PB4TBBazZIx+uxdD/aMM2vBuraPne/qbTl1Ab6SToDatCMpumnu/ayARlU6WO/JP7iNkIHiFouyYvR1/3CequkI1AlZJ+vo7NRw3O/fXdcFjQ4NT2XIvKgDOL7ptbcSFw+I3W9aqzhAQn/xZ6uyRu+1f0M4P7MDjVrLuA1EYDA7mWzwv7hy8+q7YxsWj9DSeWQg2omaEUZJXer6PTNWzMP5Y9cOloU56SJ9lfTQ9kwtij4OW9CQnz6Y+oqI7LtLQ9GViId2QGJ4MmSO+7BbB6ZbG5i8e/pWwz+dIb4RI1CeOm06pne5hXuECepsqqlsjq89FKuqiwEiFwOuwvbzDItLjvgdE2lL2Xlt++rQUnbl+OIpLs1SqnFT07xee
 PH7crFYZ
 /4BUkNyrKTGJ4DbSaofUHi17DlB4yPfltVpunvm78Gq/YYQi7W5m/fJkwza+5QRmBu84rsIKz4JXt3s/RRFQDz2Tmb0Imn3W9gXgV8MKEdi7xquzVVKR2nKJIwAiy7ed4oGgVsv5+FtFe5BXBE7CggqDTMFqTKo+YMOHCqBIx9uUKVgrob35g/Z665sTvtrUUpDegcQ3RTi4W4lXGTNVANh3F+4XnMschylKNpB62rfzZlnZfkxozb3LdjMYrum555Y3Vl+PMPG2JeMKx2X1wQrsKVq2KX/O/dwpUzTvk8LM5CUe2Rg/PiE1NWPqm/msbVEwKNotW81gZjT5QaKo2GiZR8PDhj85j+fCzIlfzBNPHzU64/7xZVh/vwm4rcPSn8FTnEJOgg5VReWWY1HPqjkPR0TlntDRW+XY88j28f+8UNsAfomEjmnw8kYWZpK2+GBWqXngWxobyvcSHEUntUVWqu7/YOhrzSfVKOTSTBO6IOvzm1NgG666u74IYIvzF/8d1xXSovjICUcLjjmKQJe4PhF6EOEjhRSPT00/klJ2WhGSG0v0tb8aV3KnoK+vgqLJCkXyugjvYJGIAK8ErOntgJ4JZM3LFEojoaI9/hEfvi5Pe6aIyenJyIlsd3wT1hhxkscl5hp5k2Tgcg4ymNvQ38AukJVU6M8tCyVuPinuHRndMoxUvyJ8af2JuYAzO2pXzI/7ecqHiGfHnQVByhw70dLPaSSqQTnGu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This makes it easy to explicitly check for VMA detachment, which is useful
for things like asserts.

Note that we intentionally do not allow this function to be available
should CONFIG_PER_VMA_LOCK be set - this is because vma_assert_attached()
and vma_assert_detached() are no-ops if !CONFIG_PER_VMA_LOCK, so there is
no correct state for vma_is_attached() to be in if this configuration
option is not specified.

Therefore users elsewhere must invoke this function only after checking for
CONFIG_PER_VMA_LOCK.

We rework the assert functions to utilise this.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index d53f72dba7fe..b50416fbba20 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -251,6 +251,11 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }

+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -258,12 +263,12 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
 }

 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }

 static inline void vma_mark_attached(struct vm_area_struct *vma)
--
2.52.0

