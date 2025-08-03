Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9CCC87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 11:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F31A6B008C; Sun,  3 Aug 2025 07:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBA26B0092; Sun,  3 Aug 2025 07:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393346B0093; Sun,  3 Aug 2025 07:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2618D6B008C
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 07:11:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA28A160A97
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 11:11:56 +0000 (UTC)
X-FDA: 83735181432.11.B0E16DF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5C748180002
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 11:11:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NJO2iAUC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OoBK0TDw;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754219513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPOn95B/ziXDJRjjN1LiBoImQkcuvUnUe4uMyBf5nE8=;
	b=O08e5yHzpOuQIZ7AnqugswTZOGeO5ssTt+yKqeMrlLqAmzYhAhVaXO6kIsd91m9KZ/qIyO
	LzSPdefPRDbhcradjkV6jgfr/eaLZllYi61ew4veIl+xhUfGrh+aZlAZI6cQtEh+noY6g5
	VyISpUtgDxzXEh7gz3UVFnF82a7rTp8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NJO2iAUC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OoBK0TDw;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754219513; a=rsa-sha256;
	cv=pass;
	b=4f8tBReDjnJ9IWeNcb6oPTf03A4LamkrerDbgrMRGXlb/K4vWYOZqgFnwRMxzKNPjm3qqM
	EdnXWec7LK5uYUwMeZ1vdv4YQWddMJ8qP86fwehSoiGWB0pdiVp9vUeBigs1+KN07umCdz
	/I2Beo73yhmBnbF39BGG+ksZ/Fu8R4s=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5734JMIU030417;
	Sun, 3 Aug 2025 11:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UPOn95B/ziXDJRjjN1LiBoImQkcuvUnUe4uMyBf5nE8=; b=
	NJO2iAUCE5JuxDlMLLASEIOJuhY2EsHag2N3UFPTWOU/jx56j0jOZNltP70WnwaH
	KtUxqc88Y6cRVwMz6Ux+zNifrmpIbbEirYuen5v9G81gsT1gPwnXJZAgqev2fbZV
	GPegON3aPvgUEsIO8vM5I7csBNb6mxjfQ2cfof7vrrViwiVChElNrLYw2GMTWUzh
	n351vEVsRAodmlaBzmTtI19QyJJIklRItvbvtVdwBvpYSlKITr/UwJoY7EP8+JZn
	dDI9xMKj+LaNdBzwxHr/LWbG/RCp1nf6pT9SYg3k9Y0x/dy3n/pS1Eqqsgxrh/nu
	7U4wZx8alqooEvgrAq9Y6w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489b7xh8pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Aug 2025 11:11:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5738CcJg020538;
	Sun, 3 Aug 2025 11:11:48 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48994741a2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Aug 2025 11:11:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XO1OXEdR5I7LRN/jBHe/4ngWRPAum0h5twOHuOxrOjwtAtxWXEFTnv43RHLWSJPy3cboRs5MwlYGuq+ptYrq+tmPXUklgR0+cyM8O7j1h76txSZGzQPhkB0nM/58tED9g85we0OKNgHiJnQS1pAa1lbe8eA3SJCj7xhxmUGhXTG5UXZAbvPFgfFp6oUAmi6zZaz9/tyxJvWpxnFavPJLGpaJIIfxxJGEMQtqFUhD23GuLLvjrJ3n0rWyhUD+gswGN35h7PDx2or0hh8TVqrEG3wL0ALfsjya/baTDH8OHYfnKPEHCp6s4A9ZPP5Dl5/vb7GIjhUajiHPxDttrHSBZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPOn95B/ziXDJRjjN1LiBoImQkcuvUnUe4uMyBf5nE8=;
 b=gmCBxAKYKz98cYwLBf/BYe6ZXspFtzQUuoNeQEIIaw3RZOWdbXLmdLFzqomekrpD4Dc761Sv8hbwypeFqh/xj0stOybBVBYCxpT6YP0TR59OkQ/4CINUxA20xTgOZoVMIKDkVmUROtncx/wWdW4NxnzZT1qn2w0vzfK7+0NhRQLx9smGkGlNUWQ81b39Ov4nTI8IoGfQPp2x/eJgSpsD9oSidKfNxhIGh6S5y9FzFO33htJJJltuujbTo/GOlvhaiJ96j+nLKJADwoimCDbD6uW41jXeaVBjX7lAfJ91kqN7kkk2tPLEuQp6NP78iLOJr+xIgbT02db7AJ3zs5wn8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPOn95B/ziXDJRjjN1LiBoImQkcuvUnUe4uMyBf5nE8=;
 b=OoBK0TDwwB0ySQIu+P8cCp+wOToHCxq0q0S76352xHvds3u4xGM43mpi9I7PP0kVdGK8IXoKogm80QMq7eQlf8vNOUKeP29wyzC53xd92gQwCqFQJ4TPAS0sgCteuEaQ6mSDzie5DITZwX1/WBLSUubQEuWLCMOC/OYYOd5eG6o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8732.namprd10.prod.outlook.com (2603:10b6:208:565::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.17; Sun, 3 Aug
 2025 11:11:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.017; Sun, 3 Aug 2025
 11:11:45 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6.17 3/3] selftests/mm: add test for invalid multi VMA operations
Date: Sun,  3 Aug 2025 12:11:23 +0100
Message-ID: <c4fb86dd5ba37610583ad5fc0e0c2306ddf318b9.1754218667.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0311.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8732:EE_
X-MS-Office365-Filtering-Correlation-Id: 885f75e6-7cab-4f92-d147-08ddd27e884e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hhcG+jRX1uwf+jdW4SV10yusIpPDb5BKIDlZl18zsCEforMSMjHL/2eZJc30?=
 =?us-ascii?Q?mCml5s4raQy/Wh6WbowAPLeWIs8CC0rfRcikVwmyGx2wKk6knztnVYzeTJau?=
 =?us-ascii?Q?DCm4+gyR0fpNZkJJVMlpDlL45UPpq8cNtIIVmwfHAPibN6ZtAalwZruMDhAC?=
 =?us-ascii?Q?GV/YGXZU9kx5eRooLGnyXxrFnsF1I+7WbMVKiRXT+qlHsGVuEIr6Bk5dZO/v?=
 =?us-ascii?Q?Ma3GRUFqYgYcm/jXLMaVUEMplyrR8mQSuDkCepFyNDGxnFezifxl/hquxUgf?=
 =?us-ascii?Q?o67hA6esdxEfemftgCBP/v5AOsvGAHHuVKaGHnK+dw+qm4vpl4B92e4SL11q?=
 =?us-ascii?Q?CuLsEKKql/KrPzE54Tun4uLhsX549H9b6dcxEUWtWJpnlkt/RgD+aC6RDKPQ?=
 =?us-ascii?Q?l2je+ooSpulTYRhwdcx2bXMLwfzhgXMdL2cZr2IzYLEJDkWgxXtDSaGY+H7O?=
 =?us-ascii?Q?mygWEGIQd7E76TkXCRmis/XEle8Y1OL8qRxA4EmR6CocRslBduK3EqBghd2B?=
 =?us-ascii?Q?Hug/PtpEGx8TSNH/b7wfaYNCkZfMmMZ8tDpcatxX/UeWL/CnJwcAhbHlN9Er?=
 =?us-ascii?Q?RsRYjAabo1zYor4Xy4pn6kIwjaZdQ+YTF28X2F6C2TDfCTS50y5Q5pbDwUgE?=
 =?us-ascii?Q?GJxSvJhtcwSE9cLOVNjVhv4d68dIFfssXN+/cfZY7dnsU1tb2G0EN+gdyrsg?=
 =?us-ascii?Q?XivgXn9OgoqrH2VB7I9STj2aqJsOvKxzM0vCKOqUd6ElVGYCUFJUtDpb+8dZ?=
 =?us-ascii?Q?JR/dZt6XU5jVbZ0ugj6RhuxjIn8N6K7NdOTFmNDCHrWK2CUlaCl3KUY0PvNM?=
 =?us-ascii?Q?O0FjgPuBbcedCUFYEaMyptH6bedjOg7HM9bSrRGBWZmUp7dfPzyewDtAnHbi?=
 =?us-ascii?Q?vjbQ2XpzbvGOs6o9vOGtPTKFDwvZGlKGt+rdv9xiviwAuSYL4byBxvFlGBaS?=
 =?us-ascii?Q?U7+0pABP2JDDFEy1Te7hKjlOg0D1Lu6LzSrAdUqor/MKXFdk6jd63jnQkRRD?=
 =?us-ascii?Q?USwZVzNs5YnDUPgqHXKZIs3fypFcQ68KCgPuq/z6+FqUbwB9VSK6rM0ZRJDF?=
 =?us-ascii?Q?i+ZEZDsyOD5WklaaptMDWqzDP7C+vCq1MUTLqfmIoh7ofTcmSfAx2kAD6Y6z?=
 =?us-ascii?Q?9n5bCM1sCqpzIJ9zVvHG6jAGQa/CqnMO64DRkUfQ2z5/y2+m6ChbvuD5lUSZ?=
 =?us-ascii?Q?4zkXpg8LsO0njWaO9rargK0UvE0dvP9zEWZgrjVTgGgkcjaYP7CqdgW0C35F?=
 =?us-ascii?Q?/jD+5RDNa4nMYWjga5IIQDwFvNFyzynASCAjDJJwdxU0aPmKfW4gstVoH6GQ?=
 =?us-ascii?Q?lcory69gyyiutLSHWW/4CUIpyo82pXHS7DnAM+xN61M9DaODdQ309j59xH+6?=
 =?us-ascii?Q?EhTl+JbPv2S4GXGVVzLCNQqfpzQV0jK/pUTfitFd88A2vK5/SMUU7c61FHvs?=
 =?us-ascii?Q?l/tVq8utZl0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OxV+8WR1+E9F76qTQml1NtQSmxa0XrQJ2i3leC+3XEDdJ7R7ICNJoyiHZBOS?=
 =?us-ascii?Q?cK84AdEyccf5QuM2MydFva2X3EYajyB6Vt0pBNmtH9gFqans4xEySgtJDBAQ?=
 =?us-ascii?Q?W5nV04mUhFc+ke2JsWjECcPhO/WTZejBuLHqJBzuh/d3wka8VxXXZ4N/BXsX?=
 =?us-ascii?Q?k4YO6UWdrewwdkDzeyDAM3Jx0jNmMVXG1b0yyvx8tbUtSEI2KWrZInP47nei?=
 =?us-ascii?Q?vJ+1X7iKJkmfrcYaBAXXCw1QK9vG3CQXwgz/tlSXUqse9FJ5ajZxTMGUkssU?=
 =?us-ascii?Q?exVyg9EZ4po9WnK08f1K/xBok5eOJM5wRs8F0YX4vHKP+VU8/gQLnh6pec+d?=
 =?us-ascii?Q?7YZEpF6up1qhrMC9gyrzxA+y149XsjVaFNsdA6coSLThy+Spqe4TEVtHD36j?=
 =?us-ascii?Q?kQcaGg2e38qqG1vromh/S5F5xvNglY/01uxa/Efth3CLhhaEC3qEJhlYP9lx?=
 =?us-ascii?Q?iUawxRVbejmTYNjbl1gif5UMokVf24wAKfJ4QIcEsAhZaaV3DLQeCj6k3zA1?=
 =?us-ascii?Q?dme4gJhJYmoQQB1OCXmzEYs+7H73e98Q0QJw2HsPFbn65P7+n4O4UfD0zdm6?=
 =?us-ascii?Q?NPxmKBfqn8y1e6E0LIKzFfgxmByBi6g3GzK1dXjepp7X0vVEINy6h8O1oFnq?=
 =?us-ascii?Q?vJdR45fj/2/LrJ44OZaGsvrgj3OIpVaGzypHiWkEA7wYrX6eJ3L9eJyMLQia?=
 =?us-ascii?Q?W1avnxgX0TAXzi7IcS1gnsfHY9Lwmd3DP0O4UVzvvVuJ/KWBYtINWWNckvta?=
 =?us-ascii?Q?l/dkmDN4FPLVTqpvg5faNLdKsmuU9yemDmj8WKkDDssyizR0C5thWqGSI2fl?=
 =?us-ascii?Q?Ns+u6JCUS9BD4e9043ZY2M7fBceu1tGHMTkELe5ARQK5qLX+a2zmolspoYrc?=
 =?us-ascii?Q?eBmJRdkYWSQbhYSvU1MVomOSVWFDIPPckzmyi8JV540LUo0TDkB9wCVu3gx9?=
 =?us-ascii?Q?9k1lyJlc2zUpjkmMLC50xEBlH6DwSqh/rySBhYPmbhg9onzefCHRZ6Ldt2RL?=
 =?us-ascii?Q?MVdKVn+GYUT5BVa01G3Cald73JAntSMh7We4pl8O4798ojE+RF/XCP4yFYA/?=
 =?us-ascii?Q?J//JFAHa8cji+sxReo/Vl3cHyfopnI3aKqb+gIWDjP1Ce13T27637I85JHHm?=
 =?us-ascii?Q?BAWYuHk/3nP05XTiTa5BHHmxCdj41287SyczXK/tBNNlkGGRZ173wcyr+cIR?=
 =?us-ascii?Q?Tq34kZBPphSYHICbJnygw1Rr0VvkQhA/VeiQQuhoE92tEhQzLOKgwy++t6iV?=
 =?us-ascii?Q?HbScAFunpecdcpEDH3Eh9rFf/EXnPcjkvpltX4uAs0QQUSglJ1LlRsMNo6IB?=
 =?us-ascii?Q?xXKJ9G4M911bK+1riNIOo9hQtRHjIcV/78KBJ4A0fYlEPy4INqqKHcUhUOze?=
 =?us-ascii?Q?dZ7loe/oW/xzJpn4nNbrj6RCT7zkhmc5yW3E0S+JfNPmQSeTFh2Z6v5rd3PE?=
 =?us-ascii?Q?S5MvyZPvWcRvts5lT5xDVma/mJU7Dsn/eTMxMJXesVpp5+iB+fmoz9ShTntP?=
 =?us-ascii?Q?znr2d0F+cLHxB2adwA6XtSqfd3nhPoXme6GhuX8kyQ6TWWfeTnBO3Kt2u4qU?=
 =?us-ascii?Q?vEKqaYgZalbOyMWZS48XyOa65pVdZxXZzZdvDPpCXE5aB3kcgIbYPSJ1X4Y5?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qDenG66Oa89Ll3MB+ELdZ4BPwspKWkje52/C7t8MysgbCm0bjPlIPxrXzmZGx1n+E+rj9eFtLpUYnm6o5PkgpQzMbkCpnZMohw7mTkSArdFFIYWaXcqDGb6BEymEPtwbQgqzFioraAaBiy6pCS27bXac7W8xzaMof6tM0aoxTyaLBNRGJSdp/R9XEkLiRvBTT6oqyXBk5/6pp8wMdrSfHtcIa20eBEyTjQJn2ukaUrkQpHsw+kygb4d/39d54h49bTvilgEw3WCnqV0Ooct2yoknk/Qp0cc9F5cZtxvED1jhRdTt/8snLcFzk5+YvmHKcxNQ73a+Ek69FYGUojChk2pxNdkD0MVVm/jeSrw1SQkcnGd6qTGvqBFB6BRWgFicC5kQLNQlEh0Vjex6oWoh+AToB6kc8UWC3AjkLvsvZPNOeH3tiPy4pBCm5IZySU5hmTinlTVkq9EdfQhvYZOYaO0THbKFJO+ZGII1M4RbyXGgUu/rMbzNZigd2Hn43AdPVygzKkRMT2gQbTKu8XHCCxFbzIAfBa4mmIHRjJymSQfN3CqHWDMSgb367sli+0qZQK42XmbJ5ms8G/icUDj+AoXBeFNXbzLy8U/jCU7BIEo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 885f75e6-7cab-4f92-d147-08ddd27e884e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 11:11:45.2953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqSz6UE+86RWGxBMN4jEap2QX/gIUHuE/Db0dT1//Xi1o7TT5kynaVsUnDX66HeJTh2nWjNM2azEwVX4WlJUdy57lPei/m3I8zaF2m9xKBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-03_03,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508030076
X-Authority-Analysis: v=2.4 cv=MdNsu4/f c=1 sm=1 tr=0 ts=688f43f4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=LpX3lQZTHYkSynK3PYcA:9
X-Proofpoint-ORIG-GUID: kWEajBmM0QumUqCC0w3MMJ7pFtm3gUww
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAzMDA3NiBTYWx0ZWRfX+rQrFGL1bXR0
 MfOX3Jtz/Tpjhx4+Oz+gNXIP16ItG6lh0+QRHFVg28gOcC75xZXen4aXFO27vnKJQSaI2wZSvAD
 HXafyYLdOMX0mOFKc/OJ19hJb0ocuFDWxwTFoHNfVHyf0pN0VLGvSgfLPlJCLexFyP8rqsJHDEU
 kOSoOe4GQNf37+bBfhf5xsRqqoBGIkgicSARmp25p+0wAednEndX0JzIAYWwzdSRxCP1S1AlG5U
 N59Y3/1gYkIkIYVB/rRBDpN/lBD4epHbEjC7ozBxKAN4c7K/BgdCXf/hgiqmuNxO2XwarrtrRkz
 aHY0JjIRd04iHnSPA95yLX40nj1Lyr+bS+KczBREDp5RFaNZaDHYjUrGvSoFo1EFqZXEUanh2id
 nCLnlta4ppr3+e4c46tWVsfmnNSmLjihAI4jeplKRjymxSaVO4QmCbwu5h85R8mHO+CqVp+J
X-Proofpoint-GUID: kWEajBmM0QumUqCC0w3MMJ7pFtm3gUww
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C748180002
X-Rspamd-Server: rspam06
X-Stat-Signature: z69dyqpuy7rm8x37t7rswssgb779fctp
X-HE-Tag: 1754219513-682297
X-HE-Meta: U2FsdGVkX1+biz/bzh2aGkx2FlUf0QmXX/7ixRw7ll+jnCSO33yYEneTEhLJw8TYIBUJ8py7OUhmbzYq4x4qEtmWdy1AqvVe7wJhjWWVZeWIOjfkxxqNaXaGVWAUAjs62Ml8pccSCExl/qFnlwLRbW8KdQQ5saWRAOa1dSBzhdOX7NJ6tap8hDIG9pumsSbwp1LgoW8JZFO4B3kI4OEp3NlcnPr8Z83gyFWSq6wOaDU8HQB9/CSXFzponvD9NxBZYQb1rnjaYgXLMZuhkobLHc2wZRbIsuoeT9kYPUCN/3HdyukKtWIuC6dD2flX+gsSD+PoAWCVMusY3rJykBwXvj0CO2At6M2F+5Q/tlgaNWGPhqnYd9iWdZaa57zbSQV/likXQiWikyjYVLzwoMdd7RNzc++7mkuZGhp7KvR0m92oJZfvDMA4wVN+E/ZA/Q/pJsPLDfLm//r5Y7664d7hVOFszmYEjPGVcHX+P/MuRD2uEu6sTRQaJXZ9N9VgUmSy0Ky6AXigITjn+WFNiA0qelMyPFlPMDu2qciI6pcWmcVQ7Y2E1h20x7nWAI+Z94QpH4H2igtjVmRQGoS7dkTFBlCll3m/w93YLNP1dq2FU49/C3YtFylEVwnaUjdlImDV6dB/m6Swdin3lcT5uHDXbN2skNVRTRXr1RUdjmKz2YkP++fwWhUL7Yej31/K7bMs5yrgiAO+h5xWjn52owwPfckujkLcZYr22T0811b4DZHPQgzmiZpyttxJtq5ynl6gmbxyLgdpP25myKrRwWKG72bebl5tPo33SQ+nejfdkU8wly5DZVqbDJF3pTfpF8Udm7vcmHxq/qlGiRmReXro6Enz7bT4mNhqeqqyzl4TuRkKwrAIkbqGo0YVp7d+GrGm+hN6W5al64y7VBDemAsZMTvWWeDICTBVhfUzF76XLdp3CMJv6uocrCN8Aow52RLRectPpucU5gusKF//9f5
 chvKh60s
 Om+77fMMT/8BJk4fq1Klj9AgQ5sAMZdZw+n3hLIC4wwazdTJtfsNPwzDy8jhEEOmbF9zqJ9oy4y95DVs/S/GksXPShwR748aM4tF3mviUYQmen7g3j3Bvi29bNNjqjSbNbzG42PaKEMoGNWi13JPzinMaFnW2KfEYSeKpWBYK7L+du4dCvCrypZz9f+mYL/Hd68UPTxqU0t401eTfzYuTS6BEsegTpwu+BnkAHVufcsLdO1TpQqZcNwendqEuBQ3HeIe+yg4fmMzKAZH6UuaaVeVRJnYsIaaOZWokxmy/ioJtdaoOk21YCiBLP/uKS1FWbvcndnE8B5zOjFwKPlTkSWhxPOvUbsCzkeO3xY5K5Vit1SVf/28o+oDLVUGQK5s3mlGoQAG6Vv1b5YDuQY6HLJcN0hd6R1xMJcjihLNTsWcdv6/5BpDX5+JaMxdkfGOuoujikJf5G6bp+SN4H8molNxi0qAgUmXBGkmRg6qzDnV4H2h5+pH9dWCdG4gI5wfhy5SqgZ0XZ2VQ5juJBKYNstZqgNP+Te5NMR5Z0ZgdvX1VRhX6uM0a4+8teSWVx2CM/wHdOoMpQaB9O43P3DdbKSm8BKkOqz1DQprtnxXHUJEPZoLYeB4i0UT7Z//5U5drTg+8CbTpZ+CFF7ndVWREcaqXRcKsTYwiALKR7e0xpAVr0Nj1w5LPMiCNiEMYJ7cNg15H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can use UFFD to easily assert invalid multi VMA moves, so do so,
asserting expected behaviour when VMAs invalid for a multi VMA operation
are encountered.

We assert both that such operations are not permitted, and that we do not
even attempt to move the first VMA under these circumstances.

We also assert that we can still move a single VMA regardless.

We then assert that a partial failure can occur if the invalid VMA appears
later in the range of multiple VMAs, both at the very next VMA, and also at
the end of the range.

As part of this change, we are using the is_range_valid() helper more
aggressively. Therefore, fix a bug where stale buffered data would hang
around on success, causing subsequent calls to is_range_valid() to
potentially give invalid results.

We simply have to fflush() the stream on success to resolve this issue.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/selftests/mm/mremap_test.c | 264 ++++++++++++++++++++++-
 1 file changed, 261 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index fccf9e797a0c..5bd52a951cbd 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -5,10 +5,14 @@
 #define _GNU_SOURCE
 
 #include <errno.h>
+#include <fcntl.h>
+#include <linux/userfaultfd.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
+#include <syscall.h>
 #include <time.h>
 #include <stdbool.h>
 
@@ -168,6 +172,7 @@ static bool is_range_mapped(FILE *maps_fp, unsigned long start,
 
 		if (first_val <= start && second_val >= end) {
 			success = true;
+			fflush(maps_fp);
 			break;
 		}
 	}
@@ -175,6 +180,15 @@ static bool is_range_mapped(FILE *maps_fp, unsigned long start,
 	return success;
 }
 
+/* Check if [ptr, ptr + size) mapped in /proc/self/maps. */
+static bool is_ptr_mapped(FILE *maps_fp, void *ptr, unsigned long size)
+{
+	unsigned long start = (unsigned long)ptr;
+	unsigned long end = start + size;
+
+	return is_range_mapped(maps_fp, start, end);
+}
+
 /*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
@@ -733,6 +747,249 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 				      dont_unmap ? " [dontunnmap]" : "");
 }
 
+#ifdef __NR_userfaultfd
+static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
+		unsigned long page_size)
+{
+	char *test_name = "mremap move multiple invalid vmas";
+	const size_t size = 10 * page_size;
+	bool success = true;
+	char *ptr, *tgt_ptr;
+	int uffd, err, i;
+	void *res;
+	struct uffdio_api api = {
+		.api = UFFD_API,
+		.features = UFFD_EVENT_PAGEFAULT,
+	};
+
+	uffd = syscall(__NR_userfaultfd, O_NONBLOCK);
+	if (uffd == -1) {
+		err = errno;
+		perror("userfaultfd");
+		if (err == EPERM) {
+			ksft_test_result_skip("%s - missing uffd", test_name);
+			return;
+		}
+		success = false;
+		goto out;
+	}
+	if (ioctl(uffd, UFFDIO_API, &api)) {
+		perror("ioctl UFFDIO_API");
+		success = false;
+		goto out_close_uffd;
+	}
+
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out_close_uffd;
+	}
+
+	tgt_ptr = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (tgt_ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out_close_uffd;
+	}
+	if (munmap(tgt_ptr, size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Unmap so we end up with:
+	 *
+	 *  0   2   4   6   8   10 offset in buffer
+	 * |*| |*| |*| |*| |*|
+	 * |*| |*| |*| |*| |*|
+	 *
+	 * Additionally, register each with UFFD.
+	 */
+	for (i = 0; i < 10; i += 2) {
+		void *unmap_ptr = &ptr[(i + 1) * page_size];
+		unsigned long start = (unsigned long)&ptr[i * page_size];
+		struct uffdio_register reg = {
+			.range = {
+				.start = start,
+				.len = page_size,
+			},
+			.mode = UFFDIO_REGISTER_MODE_MISSING,
+		};
+
+		if (ioctl(uffd, UFFDIO_REGISTER, &reg) == -1) {
+			perror("ioctl UFFDIO_REGISTER");
+			success = false;
+			goto out_unmap;
+		}
+		if (munmap(unmap_ptr, page_size)) {
+			perror("munmap");
+			success = false;
+			goto out_unmap;
+		}
+	}
+
+	/*
+	 * Now try to move the entire range which is invalid for multi VMA move.
+	 *
+	 * This will fail, and no VMA should be moved, as we check this ahead of
+	 * time.
+	 */
+	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
+	err = errno;
+	if (res != MAP_FAILED) {
+		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		success = false;
+		goto out_unmap;
+	}
+	if (err != EFAULT) {
+		errno = err;
+		perror("mrmeap() unexpected error");
+		success = false;
+		goto out_unmap;
+	}
+	if (is_ptr_mapped(maps_fp, tgt_ptr, page_size)) {
+		fprintf(stderr,
+			"Invalid uffd-armed VMA at start of multi range moved\n");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Now try to move a single VMA, this should succeed as not multi VMA
+	 * move.
+	 */
+	res = mremap(ptr, page_size, page_size,
+		     MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
+	if (res == MAP_FAILED) {
+		perror("mremap single invalid-multi VMA");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Unmap the VMA, and remap a non-uffd registered (therefore, multi VMA
+	 * move valid) VMA at the start of ptr range.
+	 */
+	if (munmap(tgt_ptr, page_size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+	res = mmap(ptr, page_size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+	if (res == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Now try to move the entire range, we should succeed in moving the
+	 * first VMA, but no others, and report a failure.
+	 */
+	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
+	err = errno;
+	if (res != MAP_FAILED) {
+		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		success = false;
+		goto out_unmap;
+	}
+	if (err != EFAULT) {
+		errno = err;
+		perror("mrmeap() unexpected error");
+		success = false;
+		goto out_unmap;
+	}
+	if (!is_ptr_mapped(maps_fp, tgt_ptr, page_size)) {
+		fprintf(stderr, "Valid VMA not moved\n");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Unmap the VMA, and map valid VMA at start of ptr range, and replace
+	 * all existing multi-move invalid VMAs, except the last, with valid
+	 * multi-move VMAs.
+	 */
+	if (munmap(tgt_ptr, page_size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+	if (munmap(ptr, size - 2 * page_size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+	for (i = 0; i < 8; i += 2) {
+		res = mmap(&ptr[i * page_size], page_size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
+		if (res == MAP_FAILED) {
+			perror("mmap");
+			success = false;
+			goto out_unmap;
+		}
+	}
+
+	/*
+	 * Now try to move the entire range, we should succeed in moving all but
+	 * the last VMA, and report a failure.
+	 */
+	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
+	err = errno;
+	if (res != MAP_FAILED) {
+		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
+		success = false;
+		goto out_unmap;
+	}
+	if (err != EFAULT) {
+		errno = err;
+		perror("mrmeap() unexpected error");
+		success = false;
+		goto out_unmap;
+	}
+
+	for (i = 0; i < 10; i += 2) {
+		bool is_mapped = is_ptr_mapped(maps_fp,
+				&tgt_ptr[i * page_size], page_size);
+
+		if (i < 8 && !is_mapped) {
+			fprintf(stderr, "Valid VMA not moved at %d\n", i);
+			success = false;
+			goto out_unmap;
+		} else if (i == 8 && is_mapped) {
+			fprintf(stderr, "Invalid VMA moved at %d\n", i);
+			success = false;
+			goto out_unmap;
+		}
+	}
+
+out_unmap:
+	if (munmap(tgt_ptr, size))
+		perror("munmap tgt");
+	if (munmap(ptr, size))
+		perror("munmap src");
+out_close_uffd:
+	close(uffd);
+out:
+	if (success)
+		ksft_test_result_pass("%s\n", test_name);
+	else
+		ksft_test_result_fail("%s\n", test_name);
+}
+#else
+static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_size)
+{
+	char *test_name = "mremap move multiple invalid vmas";
+
+	ksft_test_result_skip("%s - missing uffd", test_name);
+}
+#endif /* __NR_userfaultfd */
+
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
@@ -1074,7 +1331,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 8;
+	int num_misc_tests = 9;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -1197,8 +1454,6 @@ int main(int argc, char **argv)
 	mremap_expand_merge(maps_fp, page_size);
 	mremap_expand_merge_offset(maps_fp, page_size);
 
-	fclose(maps_fp);
-
 	mremap_move_within_range(pattern_seed, rand_addr);
 	mremap_move_1mb_from_start(pattern_seed, rand_addr);
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */true);
@@ -1207,6 +1462,9 @@ int main(int argc, char **argv)
 	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ true);
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
+	mremap_move_multi_invalid_vmas(maps_fp, page_size);
+
+	fclose(maps_fp);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
-- 
2.50.1


