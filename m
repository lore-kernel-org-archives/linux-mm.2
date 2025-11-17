Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621CCCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB2F8E0029; Mon, 17 Nov 2025 12:35:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C66D8E0002; Mon, 17 Nov 2025 12:35:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F3B8E0029; Mon, 17 Nov 2025 12:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCD828E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:35:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6DD4B726C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:35:13 +0000 (UTC)
X-FDA: 84120800106.25.19F7254
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 44D5318001C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:35:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="WzUd8N/x";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=p7IVf1Mz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763400910; a=rsa-sha256;
	cv=pass;
	b=tpuhi55ITWFej7zeNuHWGzM5FLM8HMmcWHmjsQtVJocXuH/sNxY51UPcvuZZRmXn8XKXMO
	UcXbY2g/2UQ42DpAxQ1w8mkoIqPVjgzyzOL+mzItJkPbnNVEpVrUm787GJuAArfqmOhuuK
	Rkp9XuxNNs8S25/Bg0xFjLp66Ju+8kE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="WzUd8N/x";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=p7IVf1Mz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Js469kPped3L75lsJ+Z27PKHDjJftI5M3Re49DGh3Eo=;
	b=ZbctLRo3NWCykp/VL5jpRfPluLu8b/jvcjxfj8bzsYeTt97BhzQ/pO1nzMnxpGVZGS2EIs
	L9gzpLVo8tk9cDUlvYKiqenWxXGv7szOiBNKtmUyn6UvGUeETVSdn3z2Kp05K4oPEwqHaS
	uzJ6QVwSL0EeYVRq+QSEhVN6xoecfOY=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8D26024520;
	Mon, 17 Nov 2025 17:34:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Js469kPped3L75lsJ+Z27PKHDjJftI5M3Re49DGh3Eo=; b=
	WzUd8N/xBtMY8g/7LRL9T9uWRX1U7UScv/0YD1A2GBBz33SQgCvfCcjS9Z2E14P1
	7djFwuyoZMpEmwxtsT0qxa/edEqAZQ9aqPbsp0jJnfyME+wdmluaYy/OgUajYbX0
	jfrMDuavTZZ7JF+831ygSwN7XpC9OXEWTsuFJBon2bxC8zmaPTpEexfFY7YG/haS
	kKIitXI525ZsanmJLYx3PVxXb+FcpTPlvg6PjAbVyKU1lT5M5o86nCyS27jjGlDO
	o1/uYdYvBcmMEG6xRRHkUhsoywdX+GuxBIRBKo9Cmya6i60i13Piy7a6B4ZJge0I
	oZCVVXVDCucfAFNntrNE/A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbb20e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 17:34:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHHPvU8004274;
	Mon, 17 Nov 2025 17:34:55 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7qsgg-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 17:34:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpu0KdgnlTzE2J9G7KR/HVuCSC2F1XUqAE1xZLC+KGcdnJ3IIMbRDkzcTjc9MRhZ4sMtf/nbFkP1i2F8GSyVaoJ20BqiOqPkizmzU6Ta6WCy7V16MRucmf/bZStWzQT2rJSzuPc09PFTO9KcKRmb+l9NDfTgeLU3rHUR9HhsG66BfybPpcN/vCAeCWrvwavQUFJTQd2mJftafDez0uYWhIOcFHTUXBPy56y91dPmP8YUW27cVzf1RLT1k6qJg2TJ4aaxYslFeH+/iPxAXhaBBl64YTYecFMSmyxmj5M319TJM0up9cWCYRKpLDMQYxyv70MZnzd42LxD4xJbS94HHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Js469kPped3L75lsJ+Z27PKHDjJftI5M3Re49DGh3Eo=;
 b=x4/KNl4GCGV2tjQVwgaQoJcvPx1vQEIRQ/Ddk4HyRDOCfFYUD2s8jX/SUUkjfgkyiaroaQvk5Mq3j/HFp7zJIdXHUfF1XM8G0C/F7hlTDSEYi1JRavaEYXY08EtHDR9ES34mjOYupsmKMuFLczZylYwtMMthaBZJT1asZTLN+HyQ0PBeEZeoCDEspu14b4Qk8RoR/AbJE5YDcXzW8lGn5vvqUyIjn0WBN/R72FCFzkJCcYY8A7j/yrp5iXuJT155+J93X5WFLXErjKyL/skkS4kHM7jEz30WSsVkG29G4FvdCv6DUB82G+oDZSHCWi3tXxQYdTEP+9Jjv3IuPkZtlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js469kPped3L75lsJ+Z27PKHDjJftI5M3Re49DGh3Eo=;
 b=p7IVf1MzRdIePCLVZJY+xu6oOVqSnPpfN9UsNK2j62fALjW1QMlpqouErkHrrjeOJaeL7ocEUp9ApYmlDdwNG1gs5st9y52gyPxIwMSRIQvjKoY0Dowpm3k0yYu8vcFEttTOOY7o6l3S51ltEviIWMNMXf6Qqc47tdasAx3w9Jw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7944.namprd10.prod.outlook.com (2603:10b6:408:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Mon, 17 Nov
 2025 17:34:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 17:34:50 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] testing/selftests/mm: add soft-dirty merge self-test
Date: Mon, 17 Nov 2025 17:33:39 +0000
Message-ID: <d5a0f735783fb4f30a604f570ede02ccc5e29be9.1763399675.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
References: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 212ca658-28e8-4942-9b86-08de25ff9c5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/OPiHH68WfYr+w/AWCaaCNMdvL9ESqMamn1yOkQvVwRy+Xdw3AxJwslFNfoL?=
 =?us-ascii?Q?XCIAmL0bekFHlaKQ+kOrFzF1FSTyoRhHuk30MBZ+xk/6vKId4i817ACyfdW8?=
 =?us-ascii?Q?VuKkrZLCCBtFk7ldh4M7yj3fhy6Ise1YvZFschFuHG0OlV3f0BXze+AqLu51?=
 =?us-ascii?Q?cDqIxpY2jndKdVSp5UEmtGJxNe4jClvGoAuWOnuLP/nXKjq9B4yoFMkT2PAQ?=
 =?us-ascii?Q?8ESytlRuSjo0fescE9lw2Or/TgZGzpqiiFDUqUIhdlpkrVzvKm6Nl74phtmz?=
 =?us-ascii?Q?2ix0kBvGoYAihNiQw9OtOIf9JG3IDI6uUNZEQ531Y5sNkc9v9IBjtk3UVcob?=
 =?us-ascii?Q?52SIRjP4ATe4Fs5QLH4RwbAQRxpAWmHePovPdYr4yKncKvD19xQyH2PJuOqd?=
 =?us-ascii?Q?5JNBCfkdOcD+FstGncukgqgPa7onfZvYSnW99jzM7qLLpDueq0Had4wqv+5t?=
 =?us-ascii?Q?VNWNu2xoPW3j16FSAN5gBskEVVDHYIYFmHo9/P4biRrQWbXjr/Ffzqy6jPfL?=
 =?us-ascii?Q?D4xTisIAqKW9i5yhNzO5/vIfTogCK02qB0RCUEQZMARVipF4SmU0jwtp4xeH?=
 =?us-ascii?Q?58bE4f1lYbbj7Te3/whuvFpdrjBYUzDAiTM3l7hejZibZBn+O2SWCZGiAgiQ?=
 =?us-ascii?Q?7KowOW8Lep4xfAME0J5Co6fB07N1PE6l2emraBqHtnL6ydA2A2ufBXiDmi/g?=
 =?us-ascii?Q?ILuiCcLVInJhmGjSDdopFbcXm9OIcb84YckyIfUOoJ+Hv8MroV/Vj4vXCMO2?=
 =?us-ascii?Q?bKZNMpt9c5rOPJu+nNd1oKGxgzGbzW3eHf5+G6B2synUH1SoNiFiOB7UhHUV?=
 =?us-ascii?Q?3Jw4eKvra+EFWQ5hhz1G/sYOOXfTr30ccV7vUyijGBG7sYIK1bCUSw9wloKm?=
 =?us-ascii?Q?rSUDacvS+6ewf/90HGF+xxwmHytJk7N+0qqmvYa3sH6oEVdVcSYZwAkzMCih?=
 =?us-ascii?Q?daJDrnNcKd41A8EIJ8cvKOf98d1lGLeXTd698ccBKpdsvVleXuFK++3zCkph?=
 =?us-ascii?Q?gQRcWpViC5AJY6T+N5c6jBaH5jOWo5rdEF1xBGZE6kQuYU4P0alTUnAlOL+D?=
 =?us-ascii?Q?2PHvJhmo6nXQXM1bnLNprzqg9hSGc2YZ3UNjGhcS1HnbWtc5E/6HXqgOj+hO?=
 =?us-ascii?Q?eZVsvXpWpWk0HMI5ju4swhf7n+OGLVp4IV502CaDzie3Yz3/+WHx+XN+LAsJ?=
 =?us-ascii?Q?AjwXRnHsok2upkKp6oMOhiK0wnyn+dBKV104n1J37KsJ1Hevq4KsXixbdcgY?=
 =?us-ascii?Q?WFn6qpZAziuDdbXuYoysGHvxVphURCHVjIFb9BBIk1pQB2SgsFEmj9f2+vPe?=
 =?us-ascii?Q?F9nF4iz0/FKO4IWo/KXDR+13VZ4jkPDlVTCT6JMddSMpmvhN+A3M41RtceJX?=
 =?us-ascii?Q?jIzPnv1kzYKJ6N+PTH6B3i5mQrJ+6LQpEuJTCNXnZVepxr6PWuvWaX/kO+bO?=
 =?us-ascii?Q?xyJH6bk4yzYpNqKqdXSEqgoJebu0M48A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q2b7fR1DZut3v/5v1KJMim3ya60Nw46awVxFfTA2pxZTnSrZmi73LUszvZtI?=
 =?us-ascii?Q?mCGnCzYax/hk5E85PqxG5jD2ky3saO+KiVr+LtTW+/csVV4vdZccOXkbUFqi?=
 =?us-ascii?Q?GwjsBovOrbJl90iNAs9oFdliDQzZoTgG25EYbKt7N9LFdCKDMAUx+rMsfjRL?=
 =?us-ascii?Q?kMPglcVFcJ3emOhJG63myO/k3ad/DBWRGhmul+ENdJzMPi7gXZMlbXsHka9K?=
 =?us-ascii?Q?MJYjIQdmCfHVfcnQBfusl4ZqP7N+lMXfI3RYqZtSVVIh2+V4FFCICDLWCqum?=
 =?us-ascii?Q?mY218mo+NiSxsdJP4bn64Yrz9YYED5PEY9743Wlp8JzdtRTZfuIT0ukyDonF?=
 =?us-ascii?Q?bT2dYkeZvbNgZfhEAN4x5jGHBwu+1VUvtZJtfr8+sp6yWjY6VRT0UNoOxv/H?=
 =?us-ascii?Q?0j7U9hVVl+tBHYBKJoJiVZPXtGLb4fsjILOwD7Cp4Wj+H+NVXJuBsa5jwsly?=
 =?us-ascii?Q?AZSL+9Q2yxBNC7bOLP/Hx5efl1c2y5Nc+J7ixciu7J9tj4ivFw0Ytuv01ywa?=
 =?us-ascii?Q?oaceoW8d9GNK0uIrrBZgGO9QQ9l6ODMTBZPDqvjJ6CC0JYa1mB8ZIBTc3bbI?=
 =?us-ascii?Q?9096r2GW51yQEbgIpWOSq3eiqGtdxDl+LTg2hlr8ASkfBd8FwClW95igs3yD?=
 =?us-ascii?Q?opWSXUzmLfpt/4pFTA0Z+CEYsO1ParctKiHiJME2rqPg0lSuxGOWVFFJbyKF?=
 =?us-ascii?Q?eRbqLxu9YJXeo2KrTMCUe8XUaTBBNg6uqksQtVIS6NltQPu6N8dhahUEWWRM?=
 =?us-ascii?Q?6/FI6OwNFG5MUouJLy0Crh2kFS3B8sHlCaPFoKVSGzn8ac/8zXny+XJ/nsCW?=
 =?us-ascii?Q?z+mz7rquizJt6Tdz9I9Tj5Mqec/bxMq6uu/oHr7/rhK/wO5MM/BmtNN1fUP1?=
 =?us-ascii?Q?Y3mfkmE4txctvShQ/nN8zDNCg0vDx2q40g4wlSan6cYeP8cwgvcu8D8/xkOo?=
 =?us-ascii?Q?8Y7YBj86ZVnL6ZevbhgzjApM6IkAX6qBk+tdjsfvUR6w0TgKFWXejAtfZY/N?=
 =?us-ascii?Q?4PRQHjNxNmmSWYuFC4z5YTfq/jt7GukAKAsaUhI8R8wXYz4OHr0t2NLEtfHp?=
 =?us-ascii?Q?XBZyi4E9Po5Y8eNeRzDLNJyN3Cd7FqV5fdK8kAS6i36ttw32oQ4Y+cIFBiLu?=
 =?us-ascii?Q?aXHd7wc8YmoWR8hJJyFrUbh+NsvYH54qVfOBgofG75G6bhQbw8ga1KRMxiGe?=
 =?us-ascii?Q?UumNg7J0fjWQ1G0NUEChKDhCh1eSxUnl3GnyK00wFbxgh53T3gWkaFcqD1dH?=
 =?us-ascii?Q?qApWVsp46JE2xo/LNHhEBsWEpD+p7PJdM5GHL86/9V6/AGzHO6OJ4iwzTJTn?=
 =?us-ascii?Q?S8OXoH42oDDx7Bnrj59BH07rN4phbh3hqr5bRkNaaICu1Fm7tkeGPe0B4nNc?=
 =?us-ascii?Q?apXGwMb3W+6llptkUzhI0OYXV49j/kgjB6SYDExtcTeo9NCSO6hAc6sWRA8+?=
 =?us-ascii?Q?6uDME+NXW67fEnxZnPOrJpZDiZCKVvcvHIFsDYF/PbeseY+wUEwNKYXOwBxl?=
 =?us-ascii?Q?RYuTcU1Fnlf97mDb0rvisxsUGI0vaAxDwkFIuUl07dvqbvIq2fVDuSZi4JDa?=
 =?us-ascii?Q?kkVzRIQnD6k4lV+7CupGOWeogx7E+szOT413T0J/xi4FHrxoYnb78+y0PJJ7?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mA2mBykjQQvA+7Kax3Y6OPGK/LGSTTvPxgeQELTYq04jOvR2xdWmFblFpXd9wlkGM/8HSL1ax03SLlHPOuOkj9LWcsRlSqEFoff76g8i0OlCKpQhABdrQvN4y1PNSX2lSvOhWKOp2xdDzYdCAMQxXCpnqmX61181wbe+AEYl2ftUt1PDyDHe3eVxBNjeEfrzkiAyPHl1+5rN3RM9oMH0j17DlEjUU1fgAb9Sy0Fb7xx6CF+wISJVivr2hU6MgP8mPR/vksce03zXaPPpH3u/M52IdLBEj7s5fFlKe+Svh0YUbPsYFl8aK9s0R77VvCQMBPB0HW78wF5KktkJ2p6WO1mf5mf51+OgRonWjxp60LWm5tF1hhu9oowhRCfSiIxLJmKGYzxRPLivfCbQWAs2Bo0dJDSOpU9vCKWgX5jfE/rGvchGl+OYhkeV5f8hGTe7omsazU72CXdUed88e9rr5ThrxjBQGjkAUQcC+PuLrX/PXbuj2/BvAAAsol+s15Updu4Mi1p0axszCzLmoo7DxwWZwmg2adO/VSRLhX9gQMG8DoO2YWSZKZk5M7lXsvBu8sUV+ksLlQODBpSAIdauw/Cr5wPNmd0j98nHJ6P3lRc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212ca658-28e8-4942-9b86-08de25ff9c5b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 17:34:50.4249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+RsQ0mLM6pJG2ENAXxxBh7hqlAn06gg4fTk5+bMNcnhOvg4R+igzcsZBwz71g1kqPxZJGAe4KQTgLc65lZMw40mA+y2vzzravhZ2oXOD1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170149
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691b5cc0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=MxP3qkjiim8sQrE-1FwA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: aRZIhcY4okGby0hVTEvJeLmIby7QayIK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX3KeZt61izqgC
 vL9XKWVBrCpSgGzKPXxEc+83Isk1bIE0XL4HPvxUTOBORVREnLFIuJBiv8UxCiZT3d56z9Df2mV
 cHXYM6tVnc9rrL+FdQ49VUXR5Wq4gRKNFui08pUCHYzwTylLNK/k+mgYG/6rNrGNMJ6DyWDoTGi
 +tBBsOeC1tjuyoSdNlUxX8WTInQuFoAkiJ/NgCWYA+ZXg3dkgFmhcRVapOXL24mecikTg2V3vBY
 zOUqGDzMtihsVmf7YrmLDJBeVvlchOgirK9ntgwRkH/qLm7bgMgNTmF/BaEyZa6RLbD1DC2aQp+
 qdsTtWlk9I9KNPlH653NMMuCNXE1wwjHGjsNR/j4uCcO777zR6MUc6kWCxvT2+YR1V1h0i8h13X
 upaNYl9MiYYB1BBSLbMQ/LZzMdRZZg==
X-Proofpoint-GUID: aRZIhcY4okGby0hVTEvJeLmIby7QayIK
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44D5318001C
X-Stat-Signature: im1aqoxxt5u67t4kzxyryx7zm3gjatuy
X-HE-Tag: 1763400909-868142
X-HE-Meta: U2FsdGVkX1+kul4HmBcceWDLoRniNJEF6yonJZROKBJ3j/teXE0F/8KVn0AoVWrs0kZpZUY6p3ce4+Rz7sq1nl2NkhHk3NsBgC6zT9Xenj7HUI/ugF0r6Z57Pb6EOQnd0TLzSX8ZDKtFtZACXYg2nnlFeuukCA3Dh27GvkApn8iRE+0iU4jiR2n0fk0M+95hnygVMA2YKnBcJiVoESUB2jAUQUEMqlyxkZwbOrwY3pBdm4uHruN6nxjfHx60w6lU9Sujs/TOTD+lYETqXufIt4v3nAOnEkGeJr5bSbKdubXYhHl+Av6y//KagwMD1fRYWGnYy2nSVJ+sKQZrvsE1cd8iLGrOV99Vku3yC/7xrIcNresl3IvU3uC15k6oYnP3h9lKOGgm3i117KNZqQ7yI4+IlDNT5BqHo8IpN7kiFIQe/tde5VCCw3aa8J3MGcEbFQBmulS+KIwrDIOglF99YDWEr9ChL8/khJQkBwdvjTnMSqKe/DHMrOInul9I6SeCCTA1WOsyPKIH8h7z6UrsrVSk25lWbdylJEPUntFocIq1fz6CBWdjIq9KYMwL2623xj6rqJe8oFsmlUOcoCKeM7pV5cFCy4zmMYcTCgnI+cLmtzeGQAMRxjkYPqUgTfR08gRrQJoKILqHxq+sWRNpvZjTC/BoNQjyg8zsw0xsewefk5l8miyMf9fWReevggy93Sekn/2smnhKJ9W7R7PolqvKs6J+WdHJTs/mH9UNRkqSz8vk+QgzDTQB0YyXsz5N+cLcSS6npQNpy+BOCJUc5Q0T7OmTAaysnq/r15JBnEO3MqCzFFil5g5YqNy01vJdz96z8qlmCssyheW3aUwh1KLNNj5B527AnUDl+WVAOeU/r5TrNPFwXeWnSggKD+gNg4mDwlQSA9E6A7TMm+vxaXCrv/egDGYYcprLGD6EfJRW10dgnkazlKkydLYrr4S8ghFui1qYX7UKa5H4Anp
 niZE22S8
 6leKCHj+4bZgJLoQKZsRildgj0xCNmYslHMNSIrjEa7TV+HPf9OnrdNbeYcU29USosNPAgwhlP1xUg7vDkDxJGIt6YNvUWjH68ixz4ifdspED2CG5Db3hpscejSlVaar8uRG40bi07Aes9WmgHR0meImrGfG+oD1jGzfLoB6lKIN9cRoiyBW+WLTHNjUeZCqIrlbmir8PRk/Qigwr5cXftzGyWYOizWs+LdyoljkM8fFLmjPI6ckRHScYEwviUk8xY6qrb8ScpJMLrEgme7Arfzw9v82XTBerCUvldyHli8MBvfdvuzECfFYZ3R71/qWoYMxldDgxNn9H3W4utwnMiLCuYUeqnZqLdznnh5UgDevl14eWehQPDvGuhGnIRjOGn2phLy0/C9See/XUw+Gp6e/41l3ujD+9J4oTg/kqSDKOlJyLKnT3fYkJTi8YJDTLkH1PFqX2z4gimW02B1ASg4ASWvXPL9r88T+ymHu0lEoJmqlBinrE99fdKfb0CBdHU00uJhGw3TeSnpaXvF0zNH5Dk7JiOg5qbXkk65Ui5S3lk47SReywxN0tIku9Q36bulTJX9pFduKwjWnDN6XQ3pAdgTp05vJ4WChf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assert that we correctly merge VMAs containing VM_SOFTDIRTY flags now that
we correctly handle these as sticky.

In order to do so, we have to account for the fact the pagemap interface
checks soft dirty PTEs and additionally that newly merged VMAs are marked
VM_SOFTDIRTY.

We do this by using use unfaulted anon VMAs, establishing one and clearing
references on that one, before establishing another and merging the two
before checking that soft-dirty is propagated as expected.

We check that this functions correctly with mremap() and mprotect() as
sample cases, because VMA merge of adjacent newly mapped VMAs will
automatically be made soft-dirty due to existing logic which does so.

We are therefore exercising other means of merging VMAs.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/selftests/mm/soft-dirty.c | 127 +++++++++++++++++++++++-
 1 file changed, 126 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 4ee4db3750c1..4c73820070ba 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -184,6 +184,130 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 		close(test_fd);
 }

+static void test_merge(int pagemap_fd, int pagesize)
+{
+	char *reserved, *map, *map2;
+
+	/*
+	 * Reserve space for tests:
+	 *
+	 *   ---padding to ---
+	 *   |   avoid adj.  |
+	 *   v     merge     v
+	 * |---|---|---|---|---|
+	 * |   | 1 | 2 | 3 |   |
+	 * |---|---|---|---|---|
+	 */
+	reserved = mmap(NULL, 5 * pagesize, PROT_NONE,
+			MAP_ANON | MAP_PRIVATE, -1, 0);
+	if (reserved == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	munmap(reserved, 4 * pagesize);
+
+	/*
+	 * Establish initial VMA:
+	 *
+	 *      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* This will clear VM_SOFTDIRTY too. */
+	clear_softdirty();
+
+	/*
+	 * Now place a new mapping which will be marked VM_SOFTDIRTY. Away from
+	 * map:
+	 *
+	 *       -      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   | 2 |   |
+	 * |---|---|---|---|---|
+	 */
+	map2 = mmap(&reserved[3 * pagesize], pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now remap it immediately adjacent to map, if the merge correctly
+	 * propagates VM_SOFTDIRTY, we should then observe the VMA as a whole
+	 * being marked soft-dirty:
+	 *
+	 *       merge
+	 *        S/D
+	 * |---|-------|---|---|
+	 * |   |   1   |   |   |
+	 * |---|-------|---|---|
+	 */
+	map2 = mremap(map2, pagesize, pagesize, MREMAP_FIXED | MREMAP_MAYMOVE,
+		      &reserved[2 * pagesize]);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mremap failed\n");
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after remap merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after remap merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+
+	/*
+	 * Now establish another VMA:
+	 *
+	 *      S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 |   |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* Clear VM_SOFTDIRTY... */
+	clear_softdirty();
+	/* ...and establish incompatible adjacent VMA:
+	 *
+	 *       -  S/D
+	 * |---|---|---|---|---|
+	 * |   | 1 | 2 |   |   |
+	 * |---|---|---|---|---|
+	 */
+	map2 = mmap(&reserved[2 * pagesize], pagesize,
+	PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now mprotect() VMA 1 so it's compatible with 2 and therefore merges:
+	 *
+	 *       merge
+	 *        S/D
+	 * |---|-------|---|---|
+	 * |   |   1   |   |   |
+	 * |---|-------|---|---|
+	 */
+	if (mprotect(map, pagesize, PROT_READ | PROT_WRITE | PROT_EXEC))
+		ksft_exit_fail_msg("mprotect failed\n");
+
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after mprotect merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after mprotect merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+}
+
 static void test_mprotect_anon(int pagemap_fd, int pagesize)
 {
 	test_mprotect(pagemap_fd, pagesize, true);
@@ -204,7 +328,7 @@ int main(int argc, char **argv)
 	if (!softdirty_supported())
 		ksft_exit_skip("soft-dirty is not support\n");

-	ksft_set_plan(15);
+	ksft_set_plan(19);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
@@ -216,6 +340,7 @@ int main(int argc, char **argv)
 	test_hugepage(pagemap_fd, pagesize);
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
+	test_merge(pagemap_fd, pagesize);

 	close(pagemap_fd);

--
2.51.0

