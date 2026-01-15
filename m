Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B21D4660D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32AB96B00A2; Thu, 15 Jan 2026 13:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB846B00A4; Thu, 15 Jan 2026 13:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1205C6B00A6; Thu, 15 Jan 2026 13:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC8DD6B00A2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:28:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACF461AE4B6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:28:03 +0000 (UTC)
X-FDA: 84335032446.20.4653C25
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20F14100006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LsYSiVtu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xB7WKgKO;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGfpH/hgveKKVaptQszPzRFK49ayroIMv3Dz0MEQOUQ=;
	b=qt++c2FEsyvQCSEm+K2PpvvDIYU2CZwlNZ1Dai2Z2gW+1en9IVOO56GMB2YRwzrrXjZLJg
	OtCAs3Zn9NRsM56krcBrmvy4gtJ05zrB8kuyAoLidp1WntywGMPNTZeta4Vq74gT0tkYkU
	K44bqS6VIkPS2x/Nse7qMYGD1rLNVxE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LsYSiVtu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xB7WKgKO;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501680; a=rsa-sha256;
	cv=pass;
	b=RTs8C9ssKHmTJ1VY9QFYPhW38Q8d13rTq50pIKnbFssRufHWNnFI7i3PphkiCL0VgJgolc
	xq6gPdvY+I1WaI7Rvfufr3yUufjyov1p0vF+WDT7TAlzQhZbK7eVRJjhjQpG2nq2RIEuWK
	mKZ9u5qrn7d2YwbBqpPwpnkj96AOQGo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FE35qA2753710;
	Thu, 15 Jan 2026 18:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SGfpH/hgveKKVaptQszPzRFK49ayroIMv3Dz0MEQOUQ=; b=
	LsYSiVtuoZE+6EuVWCJobmYhfMTyGkODDT3oMn10YdLuzKs1s74O3ePmjh3RbfT2
	c0mGHbXwjclpzgUklOqaPpneHSBslfuF9M6Z9upatyuafWX12wUIJqJzmGGpv0r/
	shAr5m9E6P1HM5p4sIKwapNm9olClZK0sQiMl4xQWMVLeT+u68bLpgsgiPWTW2kP
	ZERbY/B+e8LA189vFeUlJIZ+rMNv3AfpEE+S8d14VRZ8wQ1+xD7+5V6B+a9Go70c
	539dVoo2KwyS/TBRe+Gk00d81Gf/MavoN7JIW2g8ip574vuO8U2xBb2RmdZORYUJ
	c1fnVOwSExu2X6OoDF75dQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrc9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FI44wQ035388;
	Thu, 15 Jan 2026 18:27:48 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bn9n7-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yMamIsKLWF12IwJqSUScGm6oOmQM0gLGL0qeYMnhwNFNwHOI2SAz6XgA0oxrMj1+O1Yeb0EP8IJJ9PnsmV6/k77cAljAdBZ3zL3CoBZAh+XUInPEofWMR8WmI5h7EOzxzs7LEgFO/NBpqOIpa1ewB+F6qRvZ/g3APU3bNdUdePjlyUf1CpOxC6KWrY99kTtidJb4p52kgjsUQ+CS7B9rIfohZ6eYSK5HwDBomOEYcLNY+A6lXvwBojNkw2EybVCCxLMCPODZAVf/LyJOE8vykkgo7AHqs8PVeIzKAHPovtWLrSHulSwn2WxjXg+d/Ec1OcovIabaq8NA9K4lpSv39g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SGfpH/hgveKKVaptQszPzRFK49ayroIMv3Dz0MEQOUQ=;
 b=beuhKC0dlaz+wpfMsm+gcPE4b84WCpXcKlgjnV4a9VScMgINvMNA5zHYWJzujPmEeLP4u5LDdIiDR+aTm2ikWKYmaA1oAWJgaP+4FW+1ShWC7R9uudzH4fVKzfygQStXO9r37WZ37GVrLM1Zk1+IKC27fBfb1Hw+bl0i5ArCp12KF6XXnucLfCzBL9i6RE/mcR7Us030uvyA3nLjzDN68GInxXHd09RO1VYeRRojS4KvRXF6ZnFWkiepKBkhBdFK8jASkdFifuzQ01vLj+VTYJOQrnAZMGyjRAojjh2NqQrTVNOvCscaw+yod/xBo4YRAfioOBz7+uVhw8r8JdTdzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGfpH/hgveKKVaptQszPzRFK49ayroIMv3Dz0MEQOUQ=;
 b=xB7WKgKOrfH1iNsEyUIrPfgFyT1o6Z0g+Alwjc4i5tl1OphKTeKmok2Hbhg9fSzXGH2QWPG0XGZ+3LvUzfCyHQ1IgN03bMIVWdBFQRY/cc+N0cfTedA9+qsnuQnd+Y7ktAOoUFJrH4bWHMAQBV0EaRW6v4NVSK+q1+tCHxcRiU0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ5PPF0BB87A13E.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 18:27:44 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:44 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 09/10] mm/vma: Use unmap_region() in vms_clear_ptes()
Date: Thu, 15 Jan 2026 13:27:19 -0500
Message-ID: <20260115182720.1691130-10-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0027.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ5PPF0BB87A13E:EE_
X-MS-Office365-Filtering-Correlation-Id: 27354d30-f3cc-4d30-43d8-08de5463c6c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dIQ1PK8eqoo3rXj48z39oCHa+gP5zBBBrtwbVo86lfRrwCEiCzQnUkMf3d5i?=
 =?us-ascii?Q?UVbnMsyj6ZM0tCel4+HyrCI8YU+WPjyi/i5kcpOYdVn3+nG7mONv1VMz/mjC?=
 =?us-ascii?Q?y+fa0TRK3Q9+8+UKuLEjjn6emfLb7oC0+u/L+WZL32cnw46szTOoD6BOAqov?=
 =?us-ascii?Q?uBk3lmVNSVSFSv+Brw5iagnofO8quVrr6jO5Cc2lkMSy6N1ZG1Fe3c/V2iR9?=
 =?us-ascii?Q?HZZqH+2RdW7nqt2HNldv0k2nfSlmH6fRlri6SHzrmYiML/r+EQ+D0VdhoU1y?=
 =?us-ascii?Q?8ztK6u6f1HKUKOK/5fjwi9VhLNsEC2hfOkuYuWG+uzjBhBOUPVB26+YL/bZF?=
 =?us-ascii?Q?rosUBcFcbmolJ/9adOjf/uHSDqWpS0eSVY8uFkjKGYo9JnNejnj5eFuLjO4o?=
 =?us-ascii?Q?/ENFEQKAh7DqorS2MkR0PaVbab3qH86sBU0jcSafCUoJz5zMHgKcPVvxiD0u?=
 =?us-ascii?Q?cfD4V/iYzYUYu7lmlZFdB3T1J2nS9gzJ4/hki1DqIJXu3MSPPaOXLbDqG48b?=
 =?us-ascii?Q?V/UXTky4OSJNB0GxAlHHAYOciszMMuSmIQ+5Mb4v8/tEVij64GzM3o7gNVOz?=
 =?us-ascii?Q?pWmvkVIcWcG9U1PUWmzKHiUyRV5Jih052P0Zi2kKVm8wtkttuBfO+dW3Hk97?=
 =?us-ascii?Q?DrEVoSja5+LDeTFMQaVgzn0qiiFyVUSu2Bs40FbFLWxBsWslYcCnAT4jiMJY?=
 =?us-ascii?Q?Do5ClnXC2SQ3J3Pfoesk/jMjEIhI0RdwBzWGVPPtkOoXKL0xPQnKofJNUB3z?=
 =?us-ascii?Q?QVumPEkiN+Xf2pxZEwz6dA92co+h1MUT6fyCGWYWO6dtcGxHn18p8qHm7NSr?=
 =?us-ascii?Q?DI9IoOYMSe5o9jRCUK4MhilB32g79l7uAGTbpOhrgLuBAu7yITPiKBBn7yUk?=
 =?us-ascii?Q?oE6EGQL56ibZOeV57v+Wtth6y9NspQoxa7o5UCoWAeoMf42oyJyhilNuJ/zF?=
 =?us-ascii?Q?n/e/y1dNMYDBfH/bhbUG7AaLVS9GLeicQAOerZKHZyjUDmXlZrw8Dlw7Sbm3?=
 =?us-ascii?Q?yGZ7tbpx6xFze7SkK4fzoRDvQWe8/B26o+ce7dGIOOPZcHzCyZzeu5HxEZI4?=
 =?us-ascii?Q?tzdhKlEJ5x7FqeHTri3toopv4AHTGMxXr8yFq+IQAj/lW8CEA3u1N6Ejlpd7?=
 =?us-ascii?Q?KLNsPvRbr7DxeqJS07HiqTBgNl4/TM2mqvbBMVDOSjFsayimVf/+6gWThtiw?=
 =?us-ascii?Q?eDasMgrMQjczcySfODbE3215Njik5h+OBs7SHOehdn7PZEZ1Lm06BPoHy8Fj?=
 =?us-ascii?Q?5LvP+AE6LNYWoDF2pt7RimUuUNvidHAagqWcrozIgc6iBYDmqf+Pz8t70qrD?=
 =?us-ascii?Q?M7su5VpUuXrEaP6Yrw5M350MEF4RAnX4JU8AMgTU7e379jD3a9jqueQVsKUg?=
 =?us-ascii?Q?J+BNnP/fG+zWIzmwCM2PnVYzOr4SFPEgYA00za9u3SX6IarQ1OrTK4N4Ro4D?=
 =?us-ascii?Q?WjFZ5m5vzDbgRBsvLYj8ar3pHoZ3w9y5yns8pSRCiynaGwsdo66UR2rfzaht?=
 =?us-ascii?Q?wyhxEDTRNkFlTS+nxsPX25i6yMkjqSZsGfSROkSl1qXyz8ZdCZBda0s4Xetj?=
 =?us-ascii?Q?Q8q1mmg1vxwZvolK0Lg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FiKq8Pnx9oYJdoDvXbXuIO71+BbAMgkmcDfv2cOFOY/Te2guPCe+YGp3JJs7?=
 =?us-ascii?Q?Q8CLy4tRMN2Qp7CD5gec3AcFp8SNWkxoyNZuwZcishVxegI183xPOpfSLwHD?=
 =?us-ascii?Q?Y/ZOX3LGfCnXx9EtjAHw2p0l/oXOHUgLoXHg2nfXYdxvCuTmFhXfVyOIR9Bl?=
 =?us-ascii?Q?M5KCIjajIFfsQ1dbF6IVok1FMws8b9pkLMw4dX78DyQRXHi0uMnmrjEO2NMb?=
 =?us-ascii?Q?EjC9ZXNQK1Qyxk8iWS9M0emUSDOmfmId1+Gdk2A25w4mohaMzjHNXkptvnai?=
 =?us-ascii?Q?dHoDXNYr8Cm6MOkvGmIKUg5pk9WOJF1mvivWB9FiGONNlU3F6zfM7s0Zmw9E?=
 =?us-ascii?Q?By/SFEzO4TRVxjVZ8TZQLtHwABskoSvVVD4kD4O9KxIsa5UQyROKUuDD3Xy7?=
 =?us-ascii?Q?bW43ZXoG+q2ZZDUppyqIAodW2aOLzJnMShAFUt3YpANCNH13b0OuFoJrS8Z2?=
 =?us-ascii?Q?9GR4fB5YnKy0nwnUk+Bq79gIAETrhcdEvAo2fyUwV3b3y1uoS36vd6ZtTg6w?=
 =?us-ascii?Q?cUzMRa+eo+NQsu2N822WD88jbjmFSSB8Lwox8up8yDVAO740Bygn7IDTGttb?=
 =?us-ascii?Q?kLu5zePqh8EBybno4RN9hIurauQQCMpC6X5BBfVUY/N5rWrJehBEH7ECpg3p?=
 =?us-ascii?Q?o1TwvUW4eAvGVVS+WcfYS17jMyLmUro2ayw4g4wyg8NW97OEK+KUDz0nm16T?=
 =?us-ascii?Q?zWN3pjYDGy1c50sa2Z/0hl4LS27mw6Liiwl5SUB2v6hfyj5VgVMonsesYLXY?=
 =?us-ascii?Q?4fjoK4il4DXB8ZuARfb0KKjEATTKxPA4d0OBZejJh7C+PugaoIUdKgfzpsN3?=
 =?us-ascii?Q?xlRJlljFSW0NxCDhDXzYDfmBtipvdlX5DctcP7CCYpycjFQ+l3U+uK3WoA8r?=
 =?us-ascii?Q?6S4gzkXzjkElTJyd9uK8Itj2TobEKh5ditBPYcpYnO7fDmlPIg6C7/1+MA7Y?=
 =?us-ascii?Q?17BWal33KK+rBmluUSRav3zKgfuwHoBuGvUYdY3nJnuJUWfmDxq7V30uFRRL?=
 =?us-ascii?Q?+HgmL/mNiAfGl+M/wcF30IvMyIYbJF4RQMrTP3G6qozDToZeMWyfoKtAuddm?=
 =?us-ascii?Q?nxOM6+rEavaKrmplYf+JKd8Jvq5+77shxQVnSemygA3lh/wE3gAjejuU4xsH?=
 =?us-ascii?Q?fG+hE9e3On10AhFMYm97di4fKdo2RY8w5+73uBUfyLN/KcxzuBimsAbjr3yG?=
 =?us-ascii?Q?5BC1G9Ij0gVuDMdBfZxsdcNsmJwgec41HOkNaU9dMxe8gxgZc7ini8A0LjJx?=
 =?us-ascii?Q?0G7HUA/fFlUdqMZ1QcamIPBw4Kfsqg2OGZ+BJ1lTu7UBWUKBGcvzrxsFW7pq?=
 =?us-ascii?Q?rWn6a6EicA+XdaSzWDoka04X1UEIv/9ge79kz/2Ei+FJPUh7CuWLAHYAZYaO?=
 =?us-ascii?Q?528G23RT9Oqpvq5xIPniCa9uE7dgoWR9P4wD/G23ibw0AmQlrmAn6AnV/9P0?=
 =?us-ascii?Q?zuhHbXo2RxFu9hmCan/A9EgEAOpbsI1Iflb0Cl7uVXdcxVuqo8m3/w8c+dEJ?=
 =?us-ascii?Q?2Ron9niO20kH/4UnxjbxkyJJPrxs1Il1pXZtNtDUDD29su4AQLajhMYsV+Gt?=
 =?us-ascii?Q?/R1/uoH0cUSyTSTofOri7OpNEsiBkt1WM+8fBM7dyvINz3qKAwuI5h2HizU6?=
 =?us-ascii?Q?xuoDP4T8VI9ISnvgdgnRJcLOXXj60iXWpXq+vyHLq/VMRa87sOEUVh5/zFlw?=
 =?us-ascii?Q?5B+P5sSQik8gJs8WBXGlD7oBKeOtaf/FFQZ6JLnNViYshW2XQsZyOUnrhSx4?=
 =?us-ascii?Q?8zarWBTGLA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XFAQUlv77h50m+LM/RYJ3zS0CmvmR+lppgWmXe74+px06Jc9EFH8RBCqgNElY8phsPXma807DUp+1UYypM0uqsdSrXUONWdlmghlJETW2SA6GL3Q2wIXToERDbbHuhNcj4v3oIhsC3kQ7NhLaDmE+W4UoMoQ5vEcomlHzEiEVAvPPgcgZ9ZF7ia5bn8NLlct/xQQrK6MRT++uxhQ408uK+thgPxKubxUENVjQznDcW885h8xDaulrqSbai6N7PadKoyURpiP86KatgEovnHoXHvGI8aDx+hWClyBTI7iVXqIA6Ba950QCEcXuHz+Fixs6wGnTwZegqNn5qEudujldObTWcrITLC/cFWa862mSxjFCYcYQEay+JFP+SvUL0rEJ+Fts7Y7+Cm5MH5qdXFD1vrdsv/JwsIesHIG9eykUqqHgkr/vPqfnbl3Mr1c9SO9kLPnVCIsh+KshleB2Ui1AI6SD1a9TiQmiF5v2DwsVl5u6cCIFWPgQ2j2oaHmfSgqWycfjxKVSTcwdxRQILuq8kNuHQv3nymscJOxWauPIVrv7NY53FWTWuK1c8h7Ci+R9i06asRy2oS6Bx7eHM7pA2SShkXedkdpPMwbeLKc7Fg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27354d30-f3cc-4d30-43d8-08de5463c6c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:44.7343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tSbTIQ1KQmNSRcgBM1C1UETQky/qW+Aic5O8MT7ErhRks/HmnKjk8juoGRI1buVasmFTC2PGgdz1hTVLudqRAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0BB87A13E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150142
X-Proofpoint-GUID: rsKayfsegydOX7_HCRCWn3xoqWmExg3o
X-Proofpoint-ORIG-GUID: rsKayfsegydOX7_HCRCWn3xoqWmExg3o
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=696931a5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=uX-LFyyL9tsN2g4AakUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfX1J9wRZlu1taY
 xJ2UNybXIhYOc11ent55b/DynZ69PKqb4R699lBp87JAS8KaAD25wUdzw3iY/zAW90f22b3ohrA
 UpT7g9hAa1hn2SwYMIl+ibaQihdrIP5tB/eOkHCRzhs3wXU3rXHaDIWCjfSr3J0GXuhcD0AERVs
 Xawm8k/S7eHcTdHvvhI87EQzGc2g1UOsWr5jALYFbTAuenh+vZRHVKlY8mq4hwVXWgbHkVRaQDr
 sPSq28/BqTwSHWpRWJkVIo7WQbUX+Ge2jU769nQvurC7Gd0DPz4VnoHaMz6L6IdjqS6uwfK/Bfv
 80pySjN+Yh4X5tD5NkSrEFmeyr6IIQW37YzYQrzhSAPVmlwcBOePXzomtFvhTwLK7VqNozxWDBS
 zeJFxJKgXJdMFGKPxGMJ4q/9pjTW/ejW7O9c8QDoksgymzrDzF2e5/R6K0O6DYb0ayTQcrJnTxh
 6PWL7MvygCymHMrUbqQ==
X-Stat-Signature: pnxz4t4snii1nc33ane6i87sqnmbk3hx
X-Rspam-User: 
X-Rspamd-Queue-Id: 20F14100006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768501679-39661
X-HE-Meta: U2FsdGVkX19eO3GsNjWU9RdpMo2WSe+eNMizFwNdteiydVYFqPfQ/BOr9d1srO/2ubgNY5nnVzZnvSN1i9vG5JlDAdvRLhpgcz/lQEmvxy0ubh+GP8Hs0Lk2w+UEGOak6J5Y/cE86Am2BRYkQ//asIMEg8pksOd/JNqVZdHJ5W4si08+fyHxeJVer6++68iZ/ocQkkCGQpXK3ALidaEGN/pVuMp3z6bBSEExtNucdgT7TiHgF3zlB54Zl4uHQiRGH80el9Y397fHSZm53K8jPvQB4BAD6tbpVq15RkJ4Cx478hMZYfXK+djkFVx6Ev+4i8Iqec8XY6tN3pGBHptBY8M/WM39ie2kICEooOq3djxo4Yp9obe4SHFuxyVLo/JciV9zyNvqSliZYioP1OvVqZFRcF9SkZ55gajwrius8GHS9R+7y4Szbt1yltjr7AUTY3JeI6HPwHwBR7ptp5uRtZrC+Kw71OT57k1dI1uLMUsAeQkGY/2e0e+OZUizb/F5bQERE+u3chNaQW0GQhAITDmAz38wc1bReEiGNPbG1UxTq75oXAjVmjSvIl9J4OjD92g/dFH2PmoE6+Au5icpfsLavuCSFjx6RL6VT5wuSJavB0latF2V/vDSeP4qHeoul4VERWiCee8ZJeTiLheEBmbuGbr9LA39GuYU234JFJ28XCO34ex5lkZqcm/eQ1yOdKY0sbirwvgC2OZ4KF6+ZjzEXXurNoq6GUcAmLKJ2Kg9s2ZHoRe2FNmVehCuN9GW3JQXf+Gig/q3fiWON2TSc1YcM82gyVrnmhsudmTKNv+xFDMbCTdKrKUY7XJXnO51GAfKiWd/5n4Ibw03r8auPyDTHPNl0E2+rnXNPu6L6maaDObkwUSaV4Pdt/5V2RmTZVHcBD6Dc6WertvYCDYbzJueCp6GlIjCPa7wVkc9VMCzjlfx7ZVMIhtm440pXrdeF3O+hFbTVamnvhEFOwr
 nKw+XZym
 q1UKktGnXVMk5izoT5VHTg6qC2wNqe5BrrMrNAC6ePONwDju0ZGBqhf0ZFw+emVz9yU+Lj1sou6q/vA7TM6vZaC8Hzjdx/qFCIRBLhzFXywG7W/zUEe1j4nqs1Pz3KbJlAZA25pt4zE5A78JmolgQZosYJMw2H6a1y13yF7cytMJgQ+9t4pEIe0XjQ15ArPfDPSzPelUf3hvlAKbd8gRNGp/S4TO6vmRBL/y76UMov7SdmeJs5SZ+Jpl5s8p6GjHawi+6Hauz5HmjIBGtk+gXWmoUk/lgACwDO1uQX6+ETjctXiYGW9OxW/w9gCWOVkb3ftXkDP2GygEfYCiGLVBi7F5Sba1ssSUZFqt/Cf5uvpnPrfnDKZ5Rg8a+nm8h0aQyluhLixkApptNjtYx9taioqU23sAHVygfaCGNkag6F4/DOQossl40kXrVz0w0yy+AA7EB50ubShRhPO6vGq+75FMp793aDzX5vXm4XTRXi5PqoVL9+35lhkv6o303AAe+o1zeThcaIpTTFaZidUlnH2Ef9tTgyUMW/7AuJdVEAFACvTZt1QvSujqHeIQiOp5BoBG8ZVNxGpatkb9cVnP0MlbN7S9LAzORN8pf3bZd8MHGLZ4jLEqDQdZ+zjxKOP/Q3C/m9B/p4SPsh2lF0MDqKeb7wKBLrS2voDCJKKtWBzxloQU1ARhneIekyRZuJvkKj+9Dt1qErduuSg/3DS+qdqcKS26cptScpli1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no need to open code the vms_clear_ptes() now that unmap_desc
struct is used.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b46c869d4bb07..876d2db5329dd 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1255,7 +1255,6 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 		    struct ma_state *mas_detach, bool mm_wr_locked)
 {
-	struct mmu_gather tlb;
 	struct unmap_desc unmap = {
 		.mas = mas_detach,
 		.first = vms->vma,
@@ -1280,19 +1279,8 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	if (!vms->clear_ptes) /* Nothing to do */
 		return;
 
-	/*
-	 * We can free page tables without write-locking mmap_lock because VMAs
-	 * were isolated before we downgraded mmap_lock.
-	 */
 	mas_set(mas_detach, 1);
-	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
-	update_hiwater_rss(vms->vma->vm_mm);
-	unmap_vmas(&tlb, &unmap);
-	mas_set(mas_detach, 1);
-	/* start and end may be different if there is no prev or next vma. */
-	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
-	tlb_finish_mmu(&tlb);
+	unmap_region(&unmap);
 	vms->clear_ptes = false;
 }
 
-- 
2.47.3


