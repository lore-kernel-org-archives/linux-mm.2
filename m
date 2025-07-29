Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF25BC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650026B0095; Tue, 29 Jul 2025 09:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627536B0096; Tue, 29 Jul 2025 09:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C85A6B0098; Tue, 29 Jul 2025 09:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3C16B0095
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:48:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3877C061B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:48:35 +0000 (UTC)
X-FDA: 83717432190.08.3323A7F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 300ADA0008
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:48:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kf+8teWA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XlbGMxf4;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753796912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L81glduErVL6eHInaHvlHzTz9dISINXR4d+7cWDxnug=;
	b=Jw8Hw27Z0LBlcB0UpieqSoyW0W50aEKfpqKdr7DppxPBMA8xrevnDXuz3GxsH2/B+sneQU
	CoYVcjTo4DazwNLRekWrXR0O4FjV8fY+U4QsCWjsghplFNxaiV6x9ztkKT3scGPUCXPiiU
	XvOKH3/EpwUmOAEffIJq2k5oyMYNSoA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753796912; a=rsa-sha256;
	cv=pass;
	b=yBKEgKoURguxeW83Gd0slYbWB0qbB+sXXkaPyRo+NyEiQRnSSuj9UtN1fQLtK9aWNpYNN0
	zOWL4GGYfW6hMtpikaeHzDTXbBeWCs6embSyptMJQLb63vcU2vyHOd9Z9hjGWNil2P7goW
	CCxakPWQdiJbYBz7wv9JwfCn73Nh1vw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kf+8teWA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XlbGMxf4;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56TDg7l5022992;
	Tue, 29 Jul 2025 13:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L81glduErVL6eHInaHvlHzTz9dISINXR4d+7cWDxnug=; b=
	kf+8teWAmsP3s53KRHeWZ+8DFrAotCLelCnF6gDU21svkzLE7SSmgzITQmyoCiNg
	vBOC9XhttLrVoG+F5xx76ABfBVoPA05xNYuLjtQVxaj2+ok5+FdXHsQSX87qVOui
	AEWTXq2XcShcebehH/DdELuDIPh02yWhohp6bdGolB6MFWrskIgoIuKbFAxDtvQM
	5vBOnAR+wR6Wnbh1gqS6SvZLsYtSybSLLRj4uhw5szqUSIqgqXTO9Hj4fzeR6H6V
	uE4AsImAWcWR9Vq1C+MzdrFg9AZf6RfhTctEHhJB6mTISEDy2gpqy1+NT8RtqF1B
	gwwuSkv6md26CdlxamT9Zw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4e7tq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 13:48:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56TCSNJh011159;
	Tue, 29 Jul 2025 13:48:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nf9qw17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 13:48:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UokWKD9mcMj5Deimf4I1U4hej/1JIBWn/tIk1U4TTrEKeB9dqnUOxfWvZBh7C4mEMeicGQ38rqBpjdq4ATL3mRAGXByDaqVSPuHAxZftNRN1EkAX+08NDvabC14ze/Gx+o/xsIA8DOqpcLjUD1ZjDUr/AlFNVPXxEcdiYN5vCYAuTk+NNyDLRtu0ap2cIgJNSJqDz638jIpmrj6yzhKuu19AYv9DOyslRSMtDdD08kttsmejUo3ZB9T4xNEzUmFZ/LpMyMMFgEpqf4jCZudKPeEwuxpOtn/Jzi0ZikEPi8R2MCQ/FJiZKm2WnATFg2I0UzmnEvQRLJELxIXR+0ek7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L81glduErVL6eHInaHvlHzTz9dISINXR4d+7cWDxnug=;
 b=UQbYopyDSK3NbuUePg6jVoADbwt53lYXI7vzDaZSTERH72bRKft3SDN+UsgmUuZv1JTIIR5wxG1XPhq070B5FeV9UlBKNQ+X7XX8KfJXKdRy8wgl3qqRFH0gtMnPOUWzn8V3/sG0u7WRBGJyDhPheG5dl2RP2R2mgCJ29Kh2UBeNPSjv6Tl2tb7nfc56GPdfKxrqdmk3xx8G779938q2younM4CvV3dZk/Hw+bnB2MyMVD7fIgOSPlyg0OtaDrMhz9gHaOAlQ+8B50v9Sdy1ROUg3A2P/VIxR4nMGx2zPetuNfBFmkAPlS0/+qFSXCEpJ944ni8bEC2zjGnGu2tRTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L81glduErVL6eHInaHvlHzTz9dISINXR4d+7cWDxnug=;
 b=XlbGMxf4Wu4DahVv4H8FOsf52b8SdGI7pIlYgscJruYjPkhYRnhFpgBk6qMUHQ+Wkg3eucG2atxNsG22qSS60Yb4UXQULYQUFh7VqUmVo+YsMuE7Rbn6b4ro6YrrEQb+VqiH3K7j0YBoJGWpbp8hTMsvIPyOuT6SIq097UTUvaM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7005.namprd10.prod.outlook.com (2603:10b6:510:281::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 13:47:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.010; Tue, 29 Jul 2025
 13:47:53 +0000
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
Subject: [PATCH v3 2/2] man/man2/mremap.2: describe previously undocumented shrink behaviour
Date: Tue, 29 Jul 2025 14:47:36 +0100
Message-ID: <781a63ae6da11f6ade43f0aa19805877edd22c03.1753795807.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
References: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MM0P280CA0110.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7005:EE_
X-MS-Office365-Filtering-Correlation-Id: 38db5258-966b-4377-6567-08ddcea683f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?earcLRIglCUypEHb+zyCXhhXFLgsVRvl3dugU0C2ItWLeJdIQsRJFpa/sOoF?=
 =?us-ascii?Q?HjtXmHQA/wDWzWaLOJzw3vru3kjTxJax+wUaDUjydEpnccPmy6wI+k2GpMlk?=
 =?us-ascii?Q?sDRFSZYGlAoFs4zlf6eOviQoYyCTmJWC8s4NnWcsaJExW73uUodVM4JA61Vo?=
 =?us-ascii?Q?3WFDFp8GGbse4NSDyIbLfwmPeNQkLctIpDKKhMgkDXvaLgPwmPreKG0aO62W?=
 =?us-ascii?Q?yRzk8cm/IaVP+IaxXMKu1L6RbTxbT/W4EmJ72E9IfdHOEAn7spYX/ML4BCr7?=
 =?us-ascii?Q?1wKuTd4/0MhkrlPhH/pmKxDrgvG6YTgWmIuHNQnKJaGvvrk902Fj1EwM8sJn?=
 =?us-ascii?Q?ztbsU6kaN946updO8TwO3wMIVrN/Xw+clNSRyUIFggAEmK+aLkqtpI55NVWU?=
 =?us-ascii?Q?SbAp96MyvCrLsj4gQPz9HlKzHUjGVO1y3YMqfBl9byWyO6KiAVvR0z/wmzOw?=
 =?us-ascii?Q?SVX8iau+N8lo7FafyCL4GdDRjTHTaxFyfrcpLUaj9HHZs9NnJXmPqZtyqq11?=
 =?us-ascii?Q?nW5v9yKnomvKa9kO5RUwR+z9ZJOSaQZM3ors7GfjJPiftqJH6CZDX8eePhsl?=
 =?us-ascii?Q?eUzcHLWu2JzkHF9XYEItaxvZhaCxO3fXQ6JfeLTwfABUPcUems9BDBHtic45?=
 =?us-ascii?Q?HJrup1IjcfejDH0/gTJ9Yl49qN1ey3fhijzpbhue7XMQMomxkKSK47tZGN4g?=
 =?us-ascii?Q?NJOq549QIhRms2BmeCwdUaM3O4tz/2DZysfx27w3zV5nyv7C99jRRcBV4xJw?=
 =?us-ascii?Q?CAjgyErzkhilDZ85UXybitJgs/x4g3V6uOv3Y1BQ385EMkDsZN4YvU0lqKMF?=
 =?us-ascii?Q?GYoB0quWCK7Uc2IfkDuS1MkhfbV+DchLX4bb7o9YIQcTcey/SSMAWZ7+KHin?=
 =?us-ascii?Q?Jm4bSreKshsTfn4hmXs3sxr+cG354DdLGwJBx6i2fv9LfbMyS85RJt4SpetQ?=
 =?us-ascii?Q?ucuiO9oqALjtf29WaC4bJOW/S+TYlOf98YFvxs7z19wCQRJWir0Odp9Ph+j3?=
 =?us-ascii?Q?Xr7LCOqW8SMkQgM8lSm/1g23E9bpr/TQnSwp6FqaWEfFi9gyjgMaL2ww5unC?=
 =?us-ascii?Q?gKQjtDZ9DtRj2LFFbbNLrksYbeqj4dlBE/QghKIOufCS7SBca8ukb0Dj+gDV?=
 =?us-ascii?Q?10MZ1xFG0dRNH7mbp3pVKFoF7cyA/Tau5pwwJbD6pWvY2NwJM/P98FXmI4q4?=
 =?us-ascii?Q?QviJa/E7b1TgBNdxrBuJtBkWbPCvtB46zeG1ML03bPCIlZhNurIwNUqlEesH?=
 =?us-ascii?Q?D4/XDaR9rxq54QeIBkwkh8jcqlMMfygi0bVv1YsfIqZ48f5p8OKtndbh5oa5?=
 =?us-ascii?Q?+r3EWOGwH3Ia7NVib0uMOztUnFyq4zw2Gg7SPv/G3SFZpap8mDxafyXl+Oyj?=
 =?us-ascii?Q?XSVXfG4dbQYazh3tbi/nX04hj6P0fgHyIRjfGQ3gktiFaID0itPQ9pfPYP8h?=
 =?us-ascii?Q?1PSDFaEYbaI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AMpwcOhEAC5msY8MCw9NIj1gZqMMiuNjqzeAJV11ZCUpVEaBAJ+ldg9TyTvc?=
 =?us-ascii?Q?o68iOw8gPoQcDRbHK4Tk7lta+D7hRMTmekzdp/18kSIOrOoizR4Qvt30NDTD?=
 =?us-ascii?Q?FyBFeYvEHtGCij+JT5Qh/EGwoqTVNHVXqqi8V8B+WduUVaDvBLRN29aKptAG?=
 =?us-ascii?Q?mN++xnNw3howTlzssn+vIryLh9T9fEdRPi7Y7nK7HhpR+k0m8cHkeR05AdKA?=
 =?us-ascii?Q?MgqKpQfexQngm3/1lZZqFzMepCDEEgIcAaZ5whQ0fSxJ97e7nvFs5BUqE+VW?=
 =?us-ascii?Q?9X/gLBujkDVdgIuI2qc9Yv7GfWzjTJXy48ZYZ3oA2FJ1kQMQf/U1KBMHvsVH?=
 =?us-ascii?Q?GiA2Un9cpdfGn0jemKTXIWjWyfrY3Ub4oltwjDXdm3R+qtVU+LeCu6YyDtht?=
 =?us-ascii?Q?zj1Et9j6p2NR4uVFUttAtm5TpeTZ+RU6fP6XzEx4AvS0hGk+oiUwtqTL7HsD?=
 =?us-ascii?Q?2bb++mZCYSvOZvnb08fTLp5w9G2dtjDRNgZtRd3bC15+9T1tLp0ktJ/lDyNP?=
 =?us-ascii?Q?iGy6HrNKJG0zVRNFLvltUP6IIpUVtFQ3WYAkLWC1IyWCcSZZKX1QHrYDH/68?=
 =?us-ascii?Q?UHIMjqXUUEMjQYtN68wKKZRgF/2sdcpv/7xey6yMG93Q+or1eg314Sf7zhAK?=
 =?us-ascii?Q?tE3UhaW3idFFsMlRRWn8kqA/NCcVFkQhL3s3vuaCglZh45MPcVndk+cnrbGu?=
 =?us-ascii?Q?BsM7Zxhv0HdGuCZSLZ3OLWTVRa6H4qYmJnD2N5A6xOMpR0NaAmEfN9z+dopG?=
 =?us-ascii?Q?FoOaT45qYdNlncOa4APRbdSldxE7C6WWdS1+ezSNsc7vDqeLMoetNHOKMwrd?=
 =?us-ascii?Q?mcRn1kmKe8D13gvWK5Q3w9Oaf4eF1DPc5FToRis0hGCPWJeSolerwQtLz2i8?=
 =?us-ascii?Q?UPAwSdzB52sLY27oUgpc5SjHCC1ddnPwTe/rS7Y3ngKHeqMFbBBEPRZWRDVe?=
 =?us-ascii?Q?pnct96+qJH/yv/U2YipgSKxICiJhYflLhUwnWlVu0z2kKo33avBkvO0mOfkZ?=
 =?us-ascii?Q?njWEoTsh29FIuirtmv970K1PGt+HS2bGPOAtnG7OStItuxxVr6L8sFEsbbDl?=
 =?us-ascii?Q?sMT+AjPFBKOE9xpLVZm8b20Y4Zs8914eUKLtN0FAiCIYsw1PSbhs+sumU8HD?=
 =?us-ascii?Q?I0PuyfaZMy+ER5DLi3aBkfMr/ta2hdMPRHCqRtl2C3gnG8dPCJCEhKjUZzR5?=
 =?us-ascii?Q?bAdDfuvrT90/Us8Alpz9HY4ZO7t7hDxC7GFETXiE6+939KgOBFg2adpSgGpf?=
 =?us-ascii?Q?bFYUe3plauUc98HAD88otFYcYgEJFKdLnzuGeR95M0oGRH1PgDqcawda+BW4?=
 =?us-ascii?Q?+gQabTkbTL6G67CSVvbAtoLmTAHQUxa1gYCrjUZDLb7kahD1MjHeePcRRtru?=
 =?us-ascii?Q?HEh8HhvMQjIGjiu4lg0L8IWcwnicmfLsuNko3JBkiN1CctBUpYJBdueX7HXI?=
 =?us-ascii?Q?ScAzOudeVeJjaVbXRu2jSK8dfuhCEcL8DGlB/apZlaqlvMDo1i+WFgshHd5q?=
 =?us-ascii?Q?YSXG9wLbV8iBbk6tHWPMUCjTdtq/lCrhN4V+K0Ti65X6IgKvT+agYwscCc8o?=
 =?us-ascii?Q?Nvd0fbBm3WHg5iJRCl5Fga8PQVv6CPSLNLGzuekKW8cSKTpvau9nTjfGUV5/?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+MpHI3DPBEsuKlhXPYAK6ZuuGz6ol83j7Qy/Dxv9p3HDY98+Ch4TPkSTrvwFFS30EKpiEvZlpHLVay+oZns7jtt+LMjWYGv4aVkQ9AloaSLngxhgzzcbVnEAfNWypuA5XD9qCADJF/YPrxc5UxcWkaAKPP1/NqEuSe+nMGAtPywtW4ls26ptSh6PlcBwAxaF7dZ71THc4Uq/3t9/bGvfUUK6xMguqQLwuy8/G303hRNTHHlDhtWRkvOo6zl6251/uhHqQd3MCqr4KYTTipE0D0YLrY1hDgfdyfPNc23I0tQIGWgq7bUmAcVcYsqUcs+D9EzSIYp0Cr+X3Cm/h6EzjWSVBwX2BbHTyo+xolCvTTeHK+PMry/G4TnteMd/B0EyM3eUpceAtic9ltjxK0NVAU5aklYREafWCzxuL76X6OP2BFLpO0bBisFjdS8dYE2nRq52QueeJN/Zn6VXPweiyBAtDv5yiqPL4meiDUAfUGFvRlA/tHX/CFyWyQLlZNhgQK9N5diOspUHlGWAoU/chtIDaTk99hkZSiVMwUheCAs+eUPd1bZOc3CuoAcw0dz3xml2TMOemVvPXH75GoRmrfM7rnYbE03wY3/uflIsVoY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38db5258-966b-4377-6567-08ddcea683f0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 13:47:53.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oic/HV0i88O9eJ9+cflNXRBqgvx/elSgdo19tPxZuDzCRocJusp4+6SgxvMv90PZmbwQAhCOYIS5r/gnNY/8bD8vNM6rMqrIbTa1rNT/dJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507290107
X-Proofpoint-ORIG-GUID: lBMCBy-YjXrz2A1yrNQX7cGZzndn0tOD
X-Proofpoint-GUID: lBMCBy-YjXrz2A1yrNQX7cGZzndn0tOD
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=6888d12b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=hqxEFHVobavvttKUrIwA:9 cc=ntf
 awl=host:13604
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDEwNyBTYWx0ZWRfX4oKPpUxt4Miz
 GOVUiwMsJvOnrIQl354qEtphXC8PpT0ViWpyi8tTa+sXYJMulQZkOEVp6zFKsSgdo2BQhsD0E2a
 GbVRspcIUSpY6eiqNI544/rmonxM/iJhgOhZnWRPrA5pEuHskyFDG8ecvqfw89hRZEEV6fs56TF
 5ESX56G3vBVgXFYpXidNzuJFrhLeFANPfRIV1BmLBwkvzk8xD33CCZAmZxzYLZ2QDObLZr6Lmvx
 ScT08q41N8WSIz57t4zxf3mP8fGm/Ngb5rsEravtr3wqoMsp0ehd8thEih/00VJjHLWXz/vG6pF
 AqSuUjjlEKfM/B9deftyG9ggjyxlAlgXkRgzuYHHvh26RoxB1yn2t2BYZgcBH/HRNViAuLoJBFs
 Vb0hGsaSIdFoyohtkZ+0GiG3WbKIdiZAFOMubhPLEsjwTKc4y/d3BrpIUkI3hcu4GITpcgBj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 300ADA0008
X-Stat-Signature: o947cm6fffd5w895m16bbrbdijtngkw9
X-Rspam-User: 
X-HE-Tag: 1753796911-39120
X-HE-Meta: U2FsdGVkX19As8ektrrG28ZXj07W+b0YYNnHkYPXxY0nH5DWaumXYth/qp+z4RYYL+GnJ4OyGNdMLLA2Mf5QQvcq0LQZoy58HdAi8A7AXYWYIOa4jIqHqPNb+nXDYPjBjcP17CMfyGJpc+KZNjpmP1cmvPc00jNXazI1/kdCsxbcr4V6DDNI3hLKeowSrVilfSwzvX8VGtmC+sUZsPOrAY1V3dQM8drskg0zU695nWnS7UQZbL0TcyBFvvdLXKMQinwodaqRAd4aTqi3oY91XP7VHLJ6Rw1IFa3gqg5FpET8/x4GxCZUnaMCawtdwb1ZtAJGZ4jm+oy+vSFTc0rvmx6ae6jc155LI8o5LuHqzfxOEhQNzlhclGzQSjWZZek503M1Hns40s5bnk1rh2EqzD/iSodlT6ryHWIdim7rboEYVCyxf/GIkzw8PK0CrA5XpF0s4gfSPStyOsuA+k3w1rBYe3hpOb+EFwI7sgOnyeZ3ckFCt85hrYbwj4FVFIMOBfMhexhQUuLubjCbapChzOMZcjBiZ3KyRCg1pYVS7z61ni88CFYYxHih8WQjqCd+Z6cUY8RF9f6z8GqoizcMGE8mp90TOxI6/YIjNxX8p0yRQuTNJwj0chsaeHCA4BwVhZON5au2Q2as+rF483O0QV1c8u+h5qbV3pm2vCiOlEU4HQpG+8hB2URHJTBncZYLKzdhmQ9P1g+DAywsxBcCuWSd6TUKDltZD0a0ugj8XIQJ514Z/mM9qCAOXSJPmP1kaC2c1WSWxFcgX363ODTLoE9hn/I2P+gR177PoIqwbiaElP14soZYSi+fa1ELlewjFIAa6X+bDmhYoERcvJ9Yxxbv3HB95y3FVKu99fOy2dQ+9jD66ENm5BJtrXtdaLovPlURJS1dk+tx40uE1i9maLkODMXmZHhobySrPcPLG7YW79vmRe0pZatUNdIfRZG7v1HFCbFhY75XM+xSopc
 vBwZu/Hi
 /9eLnw8yOEyGuD6xDrObGtOOCT4Xoq43MzzFlBQtvtLxUy+dQ2Tb7zxVhAPGNMZ50lqryLIwa8+Gtr9Y4T/H7aGNxYBB5vzy3XAk9FMOzkGc3xOIByS1l5OxdsL3k8Lmzf7d3VgbRSa6CnT7GOGnWtvXktTP9MmRqDJ+6wd/qS8dfAN5BDO/gCFOEMjvJWG9MrFRmXvipKpXfOHbDBA4pnbvBTagHQfDmL/j5aRKFoKwahePhjjTAMhyyCWfTROwJ+820XwrWpKeQVyyVavsxjsAXfK9xSavr/ejYNl3pz2oWrcDEjQDu5j3oxeDYkNfyp9JUvhyP7Kt7gmASFh7UsYkFCeblC0vpdKA7ja98IrHB/6QE6Z3d+K5sahUCPQqBBZiMwmvSIpr1j86/CJVv2N0Yz1Okiq31RB/WOZPI1SJBgPLiD53lSTpWCrSXMgzgVQTYA0UgoD2DsC72aGy3AboUOmgs5K5PE3tFYGjcmAG4+HVSJQYEW3oo/+kJYglBDLAzKYRHEStOSDt+aGMZ5f7bDggIqFyyCYW3+nSgJz1lZRdtC1IQfHA0TJ1okk8w/HSsjq8THEgyYLy6TISvrFAEOZawPZIDNLpqQY/ZglO8ZpBGzEN12tdAW3Fs796HvmSYBXU3LtfVk7jrOAivWAbA57j9zQf4A5+yO3erbVFF1QsD55PH3b24dIG5orASDyvDah4dGv6FRKUneo/lMTWVeDUQ4bdqqcJsNI3pFJldBMyo86swRNHGWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is pre-existing logic that appears to be undocumented for an mremap()
shrink operation, where it turns out that the usual 'input range must span
a single mapping' requirement no longer applies.

In fact, it turns out that the input range specified by [old_address,
old_size) may span any number of mappings, as long old_address resides at
or within a mapping and [old_address, new_size) spans only a single
mapping.

Explicitly document this.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 man/man2/mremap.2 | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
index 6ba51310c..bbd807f1b 100644
--- a/man/man2/mremap.2
+++ b/man/man2/mremap.2
@@ -48,8 +48,24 @@ The
 .B MREMAP_DONTUNMAP
 flag may be specified.
 .P
-If the operation is not
-simply moving mappings,
+Equally, if the operation performs a shrink,
+that is if
+.I old_size
+is greater than
+.IR new_size ,
+then
+.I old_size
+may also span multiple mappings
+which do not have to be
+adjacent to one another.
+However in this case,
+.I new_size
+must span only a single mapping.
+.P
+If the operation is neither a
+.B MREMAP_FIXED
+move
+nor a shrink,
 then
 .I old_size
 must span only a single mapping.
-- 
2.50.1


