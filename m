Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71AFD489A3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A3F6B008C; Fri, 16 Jan 2026 08:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6E36B0092; Fri, 16 Jan 2026 08:37:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F776B0093; Fri, 16 Jan 2026 08:37:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 311316B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:37:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDF6555C00
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:37:11 +0000 (UTC)
X-FDA: 84337928262.12.E949871
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 99BBC4000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:37:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="HV29G/DD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L54Ajmo1;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768570628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kzvA2Ae2q13wGEoqJ79Mti9lSrLaEQhznyUt9le2EQ=;
	b=KZaptD7bi03rnvPo0/6tyxOk0qcFwRtcYRz07n59bmZcl3IhzdejMCa/b4k2DQb9ZV5hot
	2ULcBeX8a621dhpF+cdBZcHAmiGJnBe+A7RtUNr33nKONdj1A2rr9i3mEzGKOjl3HT9jXA
	Mts9K3A3FRRRTZZ47hFojFbTdDasDUM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="HV29G/DD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L54Ajmo1;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768570628; a=rsa-sha256;
	cv=pass;
	b=ydBQ4ac6TgpKLaqJRaFO9lojQ5R/HiS2VlcKrXLACXNXC9+DJE+IMdKTi9EHLWpwyc9/j3
	JwAL+bbGy20Ti8F8yGUJu0jM3LKNJBqOss8zAEcVHnwYfc5h5jyZbVVb0UPlSQOJPCosFR
	x6S9dIYflEQDqRIYZlfnxGm6laORsLY=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNDog1817783;
	Fri, 16 Jan 2026 13:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/kzvA2Ae2q13wGEoqJ79Mti9lSrLaEQhznyUt9le2EQ=; b=
	HV29G/DDJQscCNIUmbJTpSff3iGLaTtqyHFjF8LcM4x2lsdFAPLz/8gIMPvVrMxL
	c01FOvmoCAvs9Bif1wp6GTESXHVRi8of1mqD6G3q6D6OzdykZLPPTSltEpSNMdlD
	iGghrgWtqKtESBUtGI8omoQPUpeA/Qhpx2sqYH2CeqZ2PevI+97tmeP671TB02I4
	ROqo6091prDaDB+VMOX6GQkWqxxXvSy7AFJiGrJFmyIjVwZyQDx08sBRGFh8IAfZ
	YkDTtG/WXVEIuBPkGMHByzs22Gvdegb1a+GUizbJSrdRA4EXjljqRU/cDGbXzbCV
	OwtUKsUfURuVQBkZLRR8mg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp55bk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 13:36:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GDHcSm004185;
	Fri, 16 Jan 2026 13:36:59 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011062.outbound.protection.outlook.com [52.101.52.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7pprdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 13:36:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pk54pcczpVlrXX41XGE9XmRECphXJwCn9iGMx2R6znvpYKE/4NI6RXBMEd21KzE9J59vAcjUP0aGeprqtT8vHopbfVQB+Xfx+Bp0fweepvOnjNPUCiwKGHc6Aiwn32B+0A0BwwWIkDzi+Z38Sk5oRnOLf8rmW30Zy44dGuTjxNM+giuIwZ1AD7D/2s0ZH0zs0aflzqe/Yz8FZxUGGjgbFneecxc6NGl7SVpeEMiqwXb2tTIVCCv+LoDT/2UgZwC8i9rI5P0mpBZbeKZo/J2tRVjLrkQaM36dXXBFvaVPGKpkIWTrhiYmktzT0EKkE/4zNiHh4q0kOK2rvSzhLGzewA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kzvA2Ae2q13wGEoqJ79Mti9lSrLaEQhznyUt9le2EQ=;
 b=IeyGKK9BOgWgh783/wu89LGWjzFnaUfI2pryFCowzXy952413tRLI5uqyiltRss6LKny+khVDe1O2Tav/SFsnoe8doJRlAznrslgFRJpxbVIk2hIvMRCECFTv70Crk9bN+nuz0s5dAmdl/Gpcyn3WDHalgZtrPeJQGEFsFlZ5CSY/DJMQeUB7qPG0hKgIMMHC2kLqVVw4l1IyRH0/syjdDGYM6oFfteB7sN/HuWnrH0QXN0hBgvT+rzHfI8cK91ZN6gMGne1bBWjbqnCQa2eL2XgzTc3UTN/kErn0FtqHHYPiLh8iLGknm2lUQ0qPKLTrgSTAn+yp0FDpvDjuZOg4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kzvA2Ae2q13wGEoqJ79Mti9lSrLaEQhznyUt9le2EQ=;
 b=L54Ajmo1H/N25TLWfOJ27td6h5rYI6A+1pju7ZC0VcaqhKI5ju1H5pN4Rkh5a6zor/trLwdg5dolefQtCGhnCFrl6nrDNDAusCOL0pJFqGXCo5loTeHQdEOqLY4Y/uIAe3g7BjuTiHDnC7tCFWkGCbtjhNVGwdCBiPIgEgSoRQ0=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB5659.namprd10.prod.outlook.com (2603:10b6:510:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 13:36:56 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 13:36:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RESEND 3/3] mm: add + use vma_is_stabilised(), vma_assert_stabilised() helpers
Date: Fri, 16 Jan 2026 13:36:47 +0000
Message-ID: <87b36e11c632fee6c965b944974d8dc4357b5904.1768569863.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0099.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::20) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: c814f9f2-b49d-45f9-a022-08de550450fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GkiNIBmcfsJ05WQI02e4z5S7OwGDwaNmpGsXyha6foOYVG/L9ncx2jSh+L6P?=
 =?us-ascii?Q?XRDjdZWw4yDP5XqgdBabuS1ZiHZk/vpjpepWBkOdUH9pcbPhX61J+9Up1QbJ?=
 =?us-ascii?Q?qNUywkoY2vXFNm7anbD4EY1uZPkMpXyflm6FMDk7UteenIm2aqOQIMC1muSc?=
 =?us-ascii?Q?3OOzcIzn7mNn++TyHw+HcIfLgEKgWjDG8a7PJm7vPLnxQZaUyp9hENN8Varc?=
 =?us-ascii?Q?qXTp4X7qnmTtoUqQafvun1GEzst13qr+yvMrNXccgVFlYibdSQTwnSI8lD8r?=
 =?us-ascii?Q?4B/4WrwSVdLQAVrwF3uA9JeuqX3Q4mIZJu+m8OFkdGiabHx7ZodUq+42mTjc?=
 =?us-ascii?Q?FTmIXNmR0FbZpiq5KK4zfMqXw72fwnC5UDrH6/KpHE2dGPdVYcYXGrIz5wWk?=
 =?us-ascii?Q?ME1F5DxCCVVAPEF1/fDmnbaUbrKuiU1XSVnixwiZ7dOwc7hsB/g39IpVlZeJ?=
 =?us-ascii?Q?uB5kKfFGJFgPjaGgx74oyDG8J1Q+wY4Bwi+qC4nFQ3oszcKWoik61tvIuOOs?=
 =?us-ascii?Q?o8BxOSQVHthoPxuHEONexdXsbd+occLbsVsQeAJkiZdVqx7m1xdl9g5i359y?=
 =?us-ascii?Q?BJvA5CXIloKYPvMZtgMUDP6w60CF18sr9gnc/CXAFXgXfoKsIvXfvtl4xQNM?=
 =?us-ascii?Q?wR+GBP7fBFMzzQ2OOx8Gw98H0x4NvZEU/nrTxXmLy8T8d4ZlTw6OmsWoxBrS?=
 =?us-ascii?Q?2wFzgDui+8td/TOO9j5XGvcRKlqDSMzLhj2VyXlOd0WblINPVfknPu/xWUMz?=
 =?us-ascii?Q?5W6/+yg95k+7UJDcEAIeUqbOJFgkcFcjbLJDZhj2aUxTVWzVFiK+SN5DjiJE?=
 =?us-ascii?Q?sgUyuzfO99Vq/aos5PmB9bmnd3SK5R6DctT5eNUXmiRA7LzLuJIEAbwJ4Or5?=
 =?us-ascii?Q?STyVFpfDoCgRQ9enOb9pT680LjbrqSjlZul0tZwEF7hkAqw51rxpbZuJj5NR?=
 =?us-ascii?Q?vJBtiP0Z5ElA6nZgibxtJFIXClpa9DdxYh9Hvbp3wF4IPE6dsgnnvJgRzMDg?=
 =?us-ascii?Q?0Z1LqWwPYIKnDENh1C+fJtuIFgpUj2GV+YHjCwzIZ8Vr/WoA7ULKPEM4W5qQ?=
 =?us-ascii?Q?xsrFi7yX6rAEQFFicjObf/VkJY+SUEhBTtYJ/CH1S9Lt91LxHQIQm2u7piUo?=
 =?us-ascii?Q?SlztSlOF6kd2GIqO4cOcLyeibHu2kRzYfzRxdITEB7vZh59pRODYKCDyOriy?=
 =?us-ascii?Q?vOB7K3RW8CK/0k8mN/dKlsb1nCQZ2xetH2/ZbRLjfdb2T75pMhoY8UCvuY8A?=
 =?us-ascii?Q?qK8sHThfJAXeEjs4GI3GAFWqqK7BpWHhn0bdYyXHRGD4G/h19VlFxLI+k4mG?=
 =?us-ascii?Q?QQduXV0eqsAf7eF1bvwleLndAshpWLIt4h6T2P0PrX6CTO5Da0BbnMokexYo?=
 =?us-ascii?Q?H9lNo5LdZfoOAjNhHF5oF/ByfeVP6OEJ4ukcJVCAFXa8F8Y6M1VLQaHtr4fO?=
 =?us-ascii?Q?kssVmdIisCqH4Bl9KnXSca86+2gOTvHlysQbv8BuYQ6jHZuuRaT1d3fEe6XG?=
 =?us-ascii?Q?USDSFN2dEqugrn7zwKmap5TIPuZ9iOqEDASejhSACPYLju+Rx+wh5MCPZkaH?=
 =?us-ascii?Q?JJPYLaKRJSY3O/iCKk8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/j1T4BXXC8gsdNA6/cXhn0OkTpjLclBYut9fsNSOgUFW/Gjy1SlovVnDBD8l?=
 =?us-ascii?Q?+naok3oFiu59gkUrvsPgW/EgWxusUVMoChbfeMJO/rhgJUPnKA7teB4+Q7NQ?=
 =?us-ascii?Q?fJr/pndXiEteCbWJr+ZVFklzaN0sij4EN76xOara2+L/NUqCyAewrzULzHW3?=
 =?us-ascii?Q?f5u8WvfD412oSf1N/OqZBYJp/YKLCXM7wcORW72vL871k9kDKjs3NX3DapPH?=
 =?us-ascii?Q?8XYNc0VWyPJnCMU+Z2j3Wp01Jd7cWPstg5mr/bgMZNjXCqie6I/kITKtRCJp?=
 =?us-ascii?Q?43K61Lzgblg35UQCh+fBdAO4gbhJD/WK+kYvRoB+f3nCqiPg7VSlNkLijLW3?=
 =?us-ascii?Q?ri/CArgRm4EdQoN2nn1ZUbw5Z0UUd6OWQMmeuG3WaiAh7w2NWr5YDhe4kBWL?=
 =?us-ascii?Q?4FxQNHyeLFjfnIJ2U2EDo3/4fDChdqQXs/gE34TFjFGGruPYlMAaZZYylR58?=
 =?us-ascii?Q?LE1iyWHDDVHdE9WMPchZEf8xwl+Bo6lo82bkyz1Nd/Yp4r4l67pTvbVxA4/E?=
 =?us-ascii?Q?ks7Krn3GyzesC5OoJuJ2/FxJReJKL1VDzLKFM8maNWn57C70w2ri8MPM+mJ5?=
 =?us-ascii?Q?rq4rdwxKJ5sJS5KMERTQGhkui4wK5U95zo5AnyBo+1UlkSoTOKTDzmN1fUEH?=
 =?us-ascii?Q?LplFu52I46iM0RSZddVZPUpJvpDDRxZQ+UA6eBWJYZ6IpzZjIMStfZR6aTnU?=
 =?us-ascii?Q?di8BdnpI/BY444q5L5ows6SPn2X8s16Cbofo5m/pXpYMmD6Mzi3nGuLbdBjo?=
 =?us-ascii?Q?Y0t7WWBp48UyT7zU3reCpagAmy9RFfOpzy7GZpwhcSznY80KhqY8Lbv2WWdq?=
 =?us-ascii?Q?61CAlGIcoMnELutzKtb24Q4O0kCDby2soPxGrskzQ8hc0koPM8TG7zZhLwHH?=
 =?us-ascii?Q?ZQf6Vu+vYXMPnzzIyvbjBBG9g+iiPHa7C9Q7frt/EJnBYNp8giZuAOmlPOWi?=
 =?us-ascii?Q?MsXTNf86R8znOuh8FyfD3KJO4e7RSEJFwwiOoMAQTNR3tWYR/Eltm1aJqGyX?=
 =?us-ascii?Q?K8WlxbpPlde7k39NcBdj5Jrv/Mvh+YCiVxC0ctL52pg13GxZJ/MvQaMNAWiZ?=
 =?us-ascii?Q?+ijJUspCsv1PlmHyoIqL3aBl6r6Jn5Hmln/d9eELyIG3RKd5vqAb2iIg6WRN?=
 =?us-ascii?Q?7BsbXiRM9Osy5URMdL0R87/dgQhvKF31ZfItqfYFHWxr9SzoWnpO7MgYrNDp?=
 =?us-ascii?Q?UUNG4XGkT8WIgXqCZUoPluElSpUoz0XcNiDxaX2DDAtq8X1tX+++Hw05xpPT?=
 =?us-ascii?Q?goZX40XO5rrSLBAH9bsQGvaESkjVwcdMutFhJ5O2fyd/B2lQii1wDV21OlP3?=
 =?us-ascii?Q?/nuJQXPqwRpDQZdgUAc+NFlPWECcUu/vtOLU/lrb31P25zPb0OBn21Jirrk0?=
 =?us-ascii?Q?ew3mEDrWGpzRJMB2/fT923S1aK/LyvLBAFLP7SSsi/ZZrelhJnJQ36PhMStE?=
 =?us-ascii?Q?Z+wLht/NMMGsxh+b5R35CQ4sTaSdFc0mdmxR52GQXxyDGn2MG4/rG0vDKsjf?=
 =?us-ascii?Q?c9wgBQLNSeXghEM+oiLZXEp2GDZHHU4BDtHAQkpw6oaxGg6V0j0Fw9jvUgCn?=
 =?us-ascii?Q?8ItlelMIEZ9TY4svVMwjQCH1xZALWsT5KnRhINqYSifBzmYSXDeU7KdqS18m?=
 =?us-ascii?Q?gFWSwzSVmbvi0EssBlg+4qeqEzekBfjTvlIeZs4tYboC5H+HWNtWaRgQsCE1?=
 =?us-ascii?Q?iAVJ46k7fAc+IJ6ZKLDgw53fP93NRSbs2kBNVGUQ8YhVC9I3Z6ssXmBSZYI9?=
 =?us-ascii?Q?uJWTYQUAhpNv8lhDOd799bKMmgLphCI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L6J6L0D9Ni6gycRovWnfkocq3pmwzWnlzxlQwX++RstUNJLNVmDl0I2GymI50jtsBx9+P6LavlIjJyxY+jDLym7EkeQe55sHNGjj5gbEPX7NJazjsKU7N0NbXYog6yhi8HDu/wNPfZnxzyGSHThl6Mj8gPxCQC0F4p9iVwB5en9rQarShDtvlRAHdA4mAraUIR1k/bMFwlXAz4tuwTuSQ+mISHI9IEfEXYuPtSSn7udr4rY2JRCawhKOuOUuXEDSgzqfZ3hO6tRpkDnr+FyGBAMF//07Ct6FeyB6C4x4SyVG9FCir+y7jOO8yRk++6tgnr2tOaMgTFHseYJzGVjpKI3Qdsnaynygzr54Ab90WnXjAp4GL3YjskrTPskwT+fsstXNsEEbQKo5bT1v83UHNSRaBFYoIkP6nRaJnEwcmeQCK8C0pCgZK04M97dscL/5tWMxg3PZogFmajGfaipdVX4HtKxBMDJbrjr72aEv2EHYDRqdo7GlStUaSx0p3ZZDBD72zAeAxOIvONBvgOnu4lYbiLE4XBXM8yACQEH7HuGhItaRu5Fg7mdyLqW1uF35MNIoWfLYZ28KTJqR2XEaGKhuuLyrxH2vn6t2PDUh6lA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c814f9f2-b49d-45f9-a022-08de550450fa
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 13:36:56.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXuA8CauuonC5DRtlTTheRre+KKUtmyUMkAWe6AZcTvrF6/GDSiGt/yTo132O6o4xJewhCITzwG/eBEv/LVhP6wHjcj24WXPXr7RsuY21xE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5659
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_05,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA5NiBTYWx0ZWRfXyna8VjSHecWX
 DEgzyWbNVl7cNYFzQ6cxSCXLlvAdDEV+bTqmr9aOIZ/tYjSkdid7czdeAt2bP6doKuT0QzcahWl
 Yof41v1SnItnt0rwrsWRIlZGhblOy2PZLMzFLfxWwRgAzFv1X2wdep3DabMetYKZNVTPf7Bn6Ci
 4XhnBwhnhAkTeNf5UBChsrE5HbjNnDF6ln00lVnxwOIfHLnaM7T21EnGepUtAOEdsIgKrDxdmnU
 AJq/ikMyAI2eFAxHIRqKRMy7LI3dlA6YNB1w8S5aNCAaE/RN6S3+731nX/rJUxCkGReV4GUP4Nx
 sKyEnZYYi6hS6PWhB5TYUROtF8ftO8ooBRlQqF9xsj2Pf897W/XeENcgi8LPIQalkXCMDgkMHkO
 G9MbtwB48AkSoWhVaWneGriiliyx8+B9zv8R6yHXd7IlgkfN4kB65WI4eDBTFNC2DkizXNqH87D
 H5SnnfZpGMf4J79GRMID7pMJcydAX8MbxFkGV8VM=
X-Proofpoint-GUID: L_93_aTLIgwFGmSLk5ipJwcOxwbyK54F
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=696a3efb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=mkSj5z2EsP19l_LKqfEA:9 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: L_93_aTLIgwFGmSLk5ipJwcOxwbyK54F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 99BBC4000D
X-Stat-Signature: dzkfeuzdp7gzj78zki3fyw988zp4fr1m
X-HE-Tag: 1768570628-688011
X-HE-Meta: U2FsdGVkX1+t/bNt+eqD/AOXQkmPLkQ4x9DOm4YjRYzpoxAz3cEZn11p66vBWvmGf8ZqqxHUY+iCW9ct76qm107g7MFN/F1PXVNL/iObyMbJkf9lmM8nRfOIkXSQHONHefg/dX+FDk15Ltax80T79EYlVdxl53Rr/12kuHUcacKYmHDK2Ft09aMhp/+Ke4WF0JyZT7gQ5ZgRC/1l9eGdfTmRAZ/m1f8CpY+A6owxCkQY3M38+GG2xq/bJR9eF5nHClw6t2GeTj/USI9NODQo25UT8QEtLedZdahNw4qcd4Bw+QsGOW9Roupn6Uu/eAtu9GBKYb1ZG5mK4Nqt1ljy3hpu9HlkLsvB5IOHB5/2QUme2EkPlCdXYuBgQRFqBZbn19CbDZKQ4fnpBSpK8wyM4K7dykwnzRx2raIv3jHMhxx7Lof3w/Xxh82DVn8pY7w5jAMY+pRsnTL8ZMCuUfIBFBI5/9wkXhNfIslf6o7LQadi5rLDi9F79DVxyJjvH/3vauMlSysn16JtK0tIdVC0IWqUx6Qeew5nslMX05PK3P4eWLyLiMW3GLRchFJtwkIM4/UwyY794XnIQzVsDa8DCG3tvV1QI6olA3pvEGvemMXWMsU97tjCq67+F1r0p7uUFf2VVi4gOWc2lQZbZgeU8XOtJIDtLydZ6hHsXrdR7uXomipbbAK6pj3pnDgqkRZXV+Bndj8t6HKZ7TiLjDvOC5y/1v3KbH7b+6lzjrjsnRFG89PbSigtAFeiVLVtsRHsoshRv5NhYOQ9d0zT5d0BMFbOBkErqwjX4tBTMiljuRaKpQIY08X3+YkFi9SyyFDCtdHZK2N1LHCApV0CL+RL/jbQdxxqR8Tq0hdwZUiDh41pGJPq/WVwsVrTy3OR/uTmJHGeWqHvubB/v9bJ9O4BrvYKi1GUXDHdBVPD5ZfFoqYoM1p8umQM1oiSXRVstkyXIbLdgutLAZhRmusF/15
 3SseEsLn
 1Mw/ef3jPQ8L2bXkUpiTx/hGmzJ2n45xj3HX/wy+lLAPjQli3a95u6BxSgV3WY45B0gGYSdCM+emzzMkjHyOidfT3zc9/REZb/KOX02yWPiBifL18RsEhYYBOoCC3QfLk3dS425hngYPbF4ntVYoHOjQHLC07IW2/e2962gG45rmRSuIbCn63TNSbm59iLhD2z5/u9MTfL47ECJ8N8UojOImRr9emQZM/4n4OXPD3Du+Ov6Fyyrk4m1oIs0DF1ei/KXEya5lUX5wcIOytFlutEt9mm1MmIO26UEO5w2uApdmyadbUgJWTo/R8TPSDYyS1jUVU4aFuBSUcu1Smu1mpk8E2LMpxWVCwp5xJYHqExVVwSJ23RbnuIU222yyLA4BpmK/JW0zVePTpIxW+ygOwasPNjLc5OjBX7TQoH7AbaYAxCtAVvsYbJHlYN5iAGiFDiw8zIzmChZpfeBpC22ddzKjWpVHYQ8UuAIJIOxWql8h09ewMsSqYXQqggO14gPjCK1CMgA5rf1lGACNDlsV7PSin22+547N3S0UwnuU0iiR0nr/zbE31g18MVRGxPn19816xBO1N+gbZftDK9dt1B5FGw/bUgXpk2x94hZwkYSHtV/fvFpKEdtu0igiO7fCEsZDBAm8hBUxJ/xSz1dfmV+P47d5a/2KC9jOxZD4V9ylWYDDnjeAg2e+kgWLlNrV5QpmAg3L/aeqWuSC5vByJ44A/L0UMwZNQTI3V6yAqeyShhCq0XwvHe562SJSSl8W3Yebc52Ad/QtkOWgUI/1FhukWXGH48iKvZLAptnzJbAXVm/A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

In order to be able to do so this patch adds a vma_is_stabilised()
predicate.

We specify this differently based on whether CONFIG_PER_VMA_LOCK is
specified - if it is then naturally we check both whether a VMA lock is
held or an mmap lock held, otherwise we need only check the mmap lock.

Note that we only trigger the assert is CONFIG_DEBUG_VM is set, as having
this lock unset would indicate a programmatic error, so a release kernel
runtime assert doesn't make much sense.

There are a couple places in the kernel where we already do this check -
the anon_vma_name() helper in mm/madvise.c and vma_flag_set_atomic() in
include/linux/mm.h, which we update to use vma_assert_stabilised().

These were in fact implemented incorrectly - if neither the mmap lock nor
the VMA lock were held, these asserts did not fire.

However since these asserts are debug-only, and a large number of test
configurations will have CONFIG_PER_VMA_LOCK set, it has likely had no
real-world impact.

This change corrects this mistake at any rate.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h        |  4 +---
 include/linux/mmap_lock.h | 23 ++++++++++++++++++++++-
 mm/madvise.c              |  4 +---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 44a2a9c0a92f..8707059f4d37 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1008,9 +1008,7 @@ static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);

-	/* mmap read lock/VMA read lock must be held. */
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
+	vma_assert_stabilised(vma);

 	if (__vma_flag_atomic_valid(vma, bit))
 		set_bit((__force int)bit, bitmap);
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 9f6932ffaaa0..711885cb5372 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -66,7 +66,6 @@ static inline void __mmap_lock_trace_released(struct mm_struct *mm, bool write)

 #endif /* CONFIG_TRACING */

-
 static inline bool mmap_lock_is_contended(struct mm_struct *mm)
 {
 	return rwsem_is_contended(&mm->mmap_lock);
@@ -272,6 +271,11 @@ static inline bool vma_is_locked(struct vm_area_struct *vma)
 	return vma_is_read_locked(vma) || vma_is_write_locked(vma);
 }

+static inline bool vma_is_stabilised(struct vm_area_struct *vma)
+{
+	return vma_is_locked(vma) || mmap_is_locked(vma->vm_mm);
+}
+
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 	VM_BUG_ON_VMA(!vma_is_write_locked(vma), vma);
@@ -358,6 +362,11 @@ static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	return NULL;
 }

+static inline bool vma_is_stabilised(struct vm_area_struct *vma)
+{
+	return mmap_is_locked(vma->vm_mm);
+}
+
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
 	mmap_assert_locked(vma->vm_mm);
@@ -463,4 +472,16 @@ static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 	up_read_non_owner(&mm->mmap_lock);
 }

+/**
+ * vma_assert_stabilised() - assert that this VMA cannot be changed from
+ * underneath us either by having a VMA or mmap lock held.
+ * @vma: The VMA whose stability we wish to assess.
+ *
+ * Note that this will only trigger an assert if CONFIG_DEBUG_VM is set.
+ */
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	VM_BUG_ON_VMA(!vma_is_stabilised(vma), vma);
+}
+
 #endif /* _LINUX_MMAP_LOCK_H */
diff --git a/mm/madvise.c b/mm/madvise.c
index 4bf4c8c38fd3..1f3040688f04 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -109,9 +109,7 @@ void anon_vma_name_free(struct kref *kref)

 struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
 {
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	return vma->anon_name;
 }

--
2.52.0

