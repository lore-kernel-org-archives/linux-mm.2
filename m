Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C46CE9D5B
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74CA36B009D; Tue,  6 Jan 2026 10:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717546B009E; Tue,  6 Jan 2026 10:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE0F6B009F; Tue,  6 Jan 2026 10:25:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 471B56B009D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:25:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D65A7B7CCA
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:25:20 +0000 (UTC)
X-FDA: 84301912800.11.CDE3844
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6EE1D100008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:25:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CwD1n0Co;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Z40K04Zc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767713117; a=rsa-sha256;
	cv=pass;
	b=kDRv590VPS5f0MMpMgZxKTtWbhSnkq/qqwr4ruzhLug2FjJzZBYpwyjSV+8EYCKwQWN+wK
	DZKVtkAmXgJSpmgIr7O9PrBOfMPlM6/+sKaU7036MS553wnEedUi7gHnIJUJ5DLEEksRjL
	206FpqMCTvQUsCSPxq3oHiMMUmpfA7c=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CwD1n0Co;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Z40K04Zc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767713117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzQHNw9E415st74yAbQmtScUd6pNiNxYH8IMJYdEMPg=;
	b=l3h+Q/ion/O6U1GKJmby03rxxotpjm62lZ8AX4CrYWKp8qbJHrhy4zKYwaz82MHxQ739uX
	BdSiSfX7+syglJVwnHkdGTIYkzxm1tlxMHI6qDq667q0xPrnbkfZEePWMy+vPjoZe2j7HB
	O8wWD/YB8aaya1sDvFx73LpH1fSNgO4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606EpWm14005578;
	Tue, 6 Jan 2026 15:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GzQHNw9E415st74yAbQmtScUd6pNiNxYH8IMJYdEMPg=; b=
	CwD1n0Co1MCSd3wtA+Kcal/9iWwDtVGvS0cPXhRZqIOpnKz3nu/0aEcPBI2rdbhK
	t1CU7xPLwLuQuZdU0SH7jqtc3knZA/6oGt+lNTwRHzUkgk5OPhhnScmRVUIe/78y
	I/LKvF/LZWR8p0c2R5olhu9nW5w7w+Qw9QpJ7LbjhCDLAvsMgC24pKxhBrMxDBtW
	4NVCHRwMiwivNrwETRkqcB+sUTTD006MBckimrxaGw7GKoJKasjZJCgIAOmOqEMd
	F738qDRDUZy5Oz/k+9HpoKjpGs0uqW5fopVTKXALvLdBvP7YzQH0uA4Kkhb1QXBG
	NVBZUp2a99la4l2fifLv0Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh4hag1qj-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:25:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606D4pgo033898;
	Tue, 6 Jan 2026 15:04:50 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012001.outbound.protection.outlook.com [52.101.48.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8phg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wAn4u+4rFPMQYGbDfMQbB5CmFK6oq36BTaJRxfhUl2uoPW6H+xRCi7VaKo9ddmRXU09C32vCOKQVMEWx9xoxqRQUlsyUKZFgCydCq69y/XiGj4VIA/0U6+bVdPn0rU6PjoDczeRJFrHgZjv22KcXUfFa2LbOZ8FiEjqsFWj/Jv1qy5P5c91kkoBbxV/d+N46xpQPVhPDt9kA0hZVw81QeosD2qje9xO7XiQYujLGnLk9o88OEMBl+3vJWRo/57E69QkmS9zTrupQeVJTdES2lL+VyGJLblp2rbv10MRrm8pjmVtX/7i7yX3G3d9hy3VDc/jx9CDholH09XOJuPLBxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzQHNw9E415st74yAbQmtScUd6pNiNxYH8IMJYdEMPg=;
 b=ucvIuQohS1GADimn21KpvmfXt9bZA9wImu4+uiTt+f4J02gsytGHwJ5GoDGQHue+kBxWtkw2wZuwvlhUc6vQ7RJLGz261ojg2z9JXEAWwW7doa5m1kG23em33xJdyQeBmxefeR5Tq4JSwuKhb038unZp0dqcjfCH6rzqr/g8ls1BEa4m3i+fDxO/EIeUDUUe3OM19+AchuKO/KNolY6FM6Sz31TRGhFQ1fk3YBTCD0wJmj80X7ij7nkESpezGLv+BmAKNxjzd1NedLkS1xIyK4S+X+BYcyT1OyrHgLYi05poM771D0C2ANygaUY1mGAonVrvlzymQ6eXYTAYrJ8y/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzQHNw9E415st74yAbQmtScUd6pNiNxYH8IMJYdEMPg=;
 b=Z40K04ZcaeuYrN4crEJOjouqFtFQtDlrsBHhoErC7sZjIj8AhZ3DmakbjH85fv0rBR+iVCj1+6IAGhsDMch71uk/CcdNz3dQXjEkol6QKOuP3s8LXAPYMGTpWN85wmsFZAj2yMzpEiQ7z/inwjgNRuRGI5y720mIIZHZkmewbiU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6039.namprd10.prod.outlook.com (2603:10b6:8:b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1; Tue, 6 Jan 2026 15:04:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:46 +0000
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
Subject: [PATCH v2 4/8] mm/rmap: remove anon_vma_merge() function
Date: Tue,  6 Jan 2026 15:04:29 +0000
Message-ID: <1f5d605c2b35462194782fd17212a4d6c060e278.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e22e03e-9fc3-4a3a-eddc-08de4d34ee2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f0+lMOJVrw0jKsopvvz0BUgWBaLKgXFXH+3xblJEgitw/1d4cvOIsirTyCsv?=
 =?us-ascii?Q?5S8JLlyIUW28u/l4wpmlZo6NKNWZ98YqS16k5mg6WstSP4Th/4ZtObKdctja?=
 =?us-ascii?Q?Xl06ZXwBZLx1js0Vmn0YWsl41XqBf3Be7adbm5fzFBn1Hp47xWy3Lbhj6NgN?=
 =?us-ascii?Q?nnfX5purELdHQIasbqImFalAihk41PAXtCveEG0eSD4U/1OKHbziPMUHjxQ4?=
 =?us-ascii?Q?Nk/9K7IM3KtQeYHXGxnfHvOjwame5NCN0EY0mr5TJVZbEPvMn+sUPTYj1tg+?=
 =?us-ascii?Q?yDHsaUY3oldj5CERxQWDYofSHCgpKcYioViDjP4Ol7vK2JEV+c9nFvR/HPV6?=
 =?us-ascii?Q?3ukbR6JB/OW3ARgxAF7+SGEDh0o65ogPOPFQr0NBfMivHkvo9op5PY3FXkjj?=
 =?us-ascii?Q?ajPFKIW0HUBxrbElh9AzQL19h9R+V5W5j7NHgqeb0tZic7+Swl3u3Q2hwhgc?=
 =?us-ascii?Q?tXBqrPOY1d6lGlIiN0s3JI02tuCUm+zFyiwd0A8dgura3gRZTxpN3OaJBY9W?=
 =?us-ascii?Q?e9AT1oUBQucEhBXfy8upC6XPjMVl9fGYtlP/Ukan/y6pQUGgGzDs5yikCnop?=
 =?us-ascii?Q?ZlN94VR7OIGoA+vWaF9jB0B8N3z7+nv8FrSRtPO7boxiYBE+WyxdiN+TFQxZ?=
 =?us-ascii?Q?SYJIyiGkD1whiv2cqKPROkVgb5BAF8JKbNEzTKm5r99VKRq65duBiKdQkO6a?=
 =?us-ascii?Q?u7QPhNuSCdqyLrKmZTo2trJm2AWdowxn218Fi3J7mnPU3v2eaa32JcnhpYCm?=
 =?us-ascii?Q?RHBIAcNiqVFx4bzxFbgIpqova/dBoyyfG1A3rTuyry12K1PGY/59QbrQ/N8K?=
 =?us-ascii?Q?JaTRBapmtkYEQYfwNfZY9cHn8vn0SooLsoWm5jdON3wl9F8lJ/SPeQczPhM2?=
 =?us-ascii?Q?ZQmVM75zUVKV5dk5p5wE5ddZF6BYuf5vftoBwl4OrE23qLfVhFpwgwIzNF3/?=
 =?us-ascii?Q?j+DP1jtbmTUIpeRdtRGGjhL5ziasO54TcTgpT3W+9AD1JRsAINzuWBssZ1g0?=
 =?us-ascii?Q?B+7m4O/wc+P2l4F5/02X3S9CqX+aE3vJZBUsh+tKb7NntiKPO47oo1ruiSka?=
 =?us-ascii?Q?HB3ACQAvs4ZHfrsjOZgO8eD5uOTVWVaFkgkjIubbFGV4YgBzOV1/2Idx2TH1?=
 =?us-ascii?Q?EP3Y1M6nNrgcJjX9EmkVXd03i2dCWsGtl7L/D4DQsa96VWOFkyZ5Z4FuP9n3?=
 =?us-ascii?Q?fsfEj+jhl2cvWJPGVpUTOVTNU9aAeazdK7hhA4utZPTHLib/ZSzV1gsLSx6E?=
 =?us-ascii?Q?c6cF24OV6n5Sb/fOoiOeJJIDqXFA+GLGssuGxhObNxJ18vYMyvYvtGVeJeMB?=
 =?us-ascii?Q?XDDnQN++A19X3/rbwnKrVuGV0/K2OjxfBX0h6sTGQw2+LJCur/TMRb8oLPMY?=
 =?us-ascii?Q?L4wWUrrjSEwPTVGU+ctvr+8cnzFmZ+MDq3V1hQAi+TdfnKNgFnYoCK5E0ujW?=
 =?us-ascii?Q?GEEwMdId+K8Zkx2Rc5eeBbC/jm9tdaBF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T4PTRrmH3N42It/qjRej7dFtxNlGawyBLYfwgPnR5dJ3FXLr7j9DnSTtfBxk?=
 =?us-ascii?Q?X5fjz5VLqQ95wjPrlzq0efd3Kuj2S6Wp0aPaf2r699PNwZUX8H028SAh5mZk?=
 =?us-ascii?Q?xpD2Tkza6czgB1pCxiWcrIhQ7qoAxGbnZ37Ey2MFg2z40VkWLBSuFk8jXlqn?=
 =?us-ascii?Q?5sCLXAY6m4/ccYKUQehCMJwu5Q0MYz8U17yWkRuCKWrmUxmXiJ1BA1ySUCAW?=
 =?us-ascii?Q?PkSnlS+dULi/k4T6ksjFyoi1ZTt7KzNLsJIh5U0AqVStBCglsHeQJG2SN4B9?=
 =?us-ascii?Q?YAiAB9H+Wn4H3XbT+gZk7bkgR2TSLkOztK9le5rZsN9b3G8F2xH1NJX1a1nu?=
 =?us-ascii?Q?nuI5giAQIJ4ZEjB3//8ZvVpJCZYO/ZIw8FI4luISgUCJwQf17S+lBt/Em6cK?=
 =?us-ascii?Q?6cZhsFTvq66pZAUrav5xOrGfHyt6g1GjKfsoplR8aw8DIQidJihA9yDrtPf5?=
 =?us-ascii?Q?u+0ZzaebTWwMcLj0lZ+e8QgdoGN5SjH3R0ND6A1ANInyle79KG8PUDAwDr0G?=
 =?us-ascii?Q?8Tw04lQ+DLlBMO/WvzApI4yxCYZ9KxLXo2dgi9Y406ZXixBL2wQLSrko0qTW?=
 =?us-ascii?Q?+uzGUML1Vme5OAKenL70tC9aIqgf9ZZ7F2kzlBYIv6cwCJpM6aJLCyYr43KK?=
 =?us-ascii?Q?a94DV0rxV+JNJiGaSX2TB1B3T5Wib3OXqhvQZDELGZNI4GkGcOvp09Lxvh+7?=
 =?us-ascii?Q?41YTZuI6gSIX2aKSJjG6/1qh2d7qdwqhVTKQxMnPUNTXvXSQSk08BPuaC4mK?=
 =?us-ascii?Q?cHWy/JOlpybpag2414PGWOzcPaeUnKqGQB2Kwzv+onZMX2S6SvuszSRCspPV?=
 =?us-ascii?Q?re4+tKmr3TPnSFjCGXCP5qAJGGsVMBFIJGQrvdm7Ibue0/z2d2Vb10HupQvo?=
 =?us-ascii?Q?5QJZ1jDnXFGaoZunsfHoQPIgd//PdVq+3N7XeI45lMwnjdmM3K2oKlu/19v6?=
 =?us-ascii?Q?9x9jPUroRIE73NokEQ4ioAKBCvbAkNbsfkQpSraKLXadB8f9lVaYqUA7b0LF?=
 =?us-ascii?Q?4Ow4CFvLWX21XOtpaln0c5jIhcaFH+tBneZRjJC+u+WoLRfnWx7RWuSuJ8FR?=
 =?us-ascii?Q?I9lbYFGHGz+KGjP0o+sytfZKBIRZDHUxc0UTC1To7KRAu0bj3XOvW4q3eGQl?=
 =?us-ascii?Q?+oYa5hC4wHCETSl0izZFmIrnINTt/gue0xE3Rm8YtwZ+/QKKV4wkZXptXgim?=
 =?us-ascii?Q?aE1ruNwLX/JpAu/+tdMvfH7mnt+I6NCVsV75GlOdHbeFxuqCbUlSQTriRnWz?=
 =?us-ascii?Q?CiB9OkbMdiQ2tKPuZOBDKY36hODQRg9FxDnw562CB9bOmYqT2wK9RaOEexaB?=
 =?us-ascii?Q?j3ZVdwTqCHv/QqY25RyKM3HB+c5gV7z9nBUEayhQ++AdoY4Yl0y196CyHqe3?=
 =?us-ascii?Q?261g2MPzTpoD5VTZlMKmQD7vRbbl2qsfJ/TJM6KrFBVA0AKFWJQbkBng9vjN?=
 =?us-ascii?Q?lmGVV6nZBinayY45SHGeCzOYrVKN/2Yxr12Dzlp9Gutw1O+pQkCZLVgXGGai?=
 =?us-ascii?Q?VDv+sLb+nFR12FzteJwWaP1P1MwxjYGTXmkG2Q9/UaOU8YQ2LAwT3kutokO+?=
 =?us-ascii?Q?8EmuQxFPAyPP/ugX9H4dRwAe1USrjy5STMZkkQF5wnckH5nFk2GbaGlpQ22V?=
 =?us-ascii?Q?/nZbwWNPh1TdIRXJb5hPnplWU16L7b2wqomYq0+mXNvYlOSp4mLJCMuNI29w?=
 =?us-ascii?Q?0nNFw4/NVZ42h6mUG2cOLETUUxOOZnuWfBwPiWnsIB1+toBMmp5pMo3WISl5?=
 =?us-ascii?Q?xFobr6g6buTqXf5kHoHNhwyKrTUnJhM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7XBdRssw5/DbQwu8KEyLOxs5MqUKk+HhrE9EZsBN4WpWoHNHobG0bKMpkF1aZP+L93GAtv9BWEJmWsh4UkDym4gh4i74RjQEQAgha/3wr0nG37tI9SceOJJV301uZMnh4d6tl82FoQKWNqCOlPU5xHDWunDXb3o/+7W5JRrtyyrEXlXlL2pcnuCIINw075VuN8pkDv4aimuLEBlq39a6qznL3kvzL23YSoSwDtQInxIhnvJqb4WNrc2AGjQEpK4Oxj+mevhTiEaufPG1AVDAG6WkSVC53Y9C4kXvFKoKTfLvTJBiU7YFNUN/XELOy5vhz6gPROkqw5xeshG8yOyF2yUFLi40WhYk8bXDpknhzTHUjE0SSIakR6rpts6S7e2BeZYiPUPF2zom6ukx+PGF9cJfx1qA8mhQWVJE6YRcI+JYd1srNXadfe7HiGoLzWbh04krS52LcK95wE8eLE3C7BK4XU1n37LL8R3IJRtbJ5aldtDypkDGkyxRc9QmbSyeIqYeGK3PKhJ/E9a0zM9ukGWNdUIl0fRLlgLHBR/sBUOXcT4LEeZtkcEwdfX7XLfzvtn8+h6rCZavN4HWtCV3wvMm8uu4i5tCOW6Bp8H44Cw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e22e03e-9fc3-4a3a-eddc-08de4d34ee2a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:46.3693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PZjohiFp2HyhBUFbvy9r0D6Stg5pSUZKph3mMDtd8w9hS5fXrJyi2ZYJdE7GiZnu145Jx9y2tav1rXJ1WCc5Dl1I1jUDwju7Z7ZRvH03MU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060131
X-Proofpoint-GUID: P26-YnZutkBAC6Jp2wOT6USVFhFNRD5r
X-Authority-Analysis: v=2.4 cv=M7JA6iws c=1 sm=1 tr=0 ts=695d2958 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=yDX0O4jjIrK4UegQ5t0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMyBTYWx0ZWRfX5GKqfepQeZ4f
 OlFcWYrfz1idslUfYzIUonkdMuuryQVY/kh4m8M/Iz5+aGy08MHsrTzI25NHl+XWA0ukqg9sFM2
 wbS77bw7yB9YXlBFL2P7fMx7cxm+Mw5z5xpiP95LbKoTpoqp3S/DTPW9aRc3n/iYw9yTOUMcGE5
 6kTmAYnaO5scq5X/Kyf1L6/pkBX9jX0as2mklHEgKQQSuvyH4ZCASRno4eq+1VgeHkNbL9HXgT8
 ZnfiJSH3xFcuQO8Frs5XaBwDwoWN42jxzxrVIsDg+2YrjsX/hY0YtO3Oy2sDy4qbJezmkwr1kkh
 2ohfud3NPcC0TtaQSowjbcDPGYk2L9XCyAnp4hDLbZJGrLlbjSUwD/b4k2aaEmyTInjQmPaPC5s
 3ZZ+z4a2o9egmqLins7vzxhN5mKJ8kxfuGuc7h5syRdkXNfOagv+4lDbD/8MQbequan1teI8p4O
 Zff56i/t/b9RBXj+hFw==
X-Proofpoint-ORIG-GUID: P26-YnZutkBAC6Jp2wOT6USVFhFNRD5r
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EE1D100008
X-Stat-Signature: adf39hfx6npkcrbe8fyqug4j9w6zepbz
X-Rspam-User: 
X-HE-Tag: 1767713117-535995
X-HE-Meta: U2FsdGVkX1+IHtUdf4qNlZAsCboSmxlKoT20qQtCzO1dTfK565V1wKjwXTtzSp7blyFGiXPwcXX+M3BrtZl90f+YCjcxs0NHayP9hBB6ttPTUiO01hKmSTo1kUbibSt0ZedahgPYqIntMb0yt+B1DWCWTz9OCazLJ0ItNj6w8mAux6C987M83PuvHp8QJHl6KWwnVy1rz4v4k7NAfLOCgVXgZ0AIpjfZXRWOeOZnJqNwe5wm6/WvlvCBs791/Do0slyQBarS6k68jQINIAebI2dMYR3vVBous/HAQgmNQsbOVMJ+gS75YGjbcUlDjirXQLwWktidRHH4sXDYk74DqDq94vAIauc5QSSnPbiqzdxrbldgwIQ9SEFFXXvKu6gNmmdH7uPl1FkPK/i6htxPtavZRmyA1C35ehmjMCuLjQRSNbfqWTQEBDynRNLtDoBcy+5f41iHsOUPMo8+QBy/VUeuFlqYEPxZxkTvv+Kn9/BvZn7iywjtNw9pixu+FCUt6/dQAgp1NVJKzKf8v8YIpFN4uwAJWFByUQpo8B+bU4hxzHtgrKmqwG9ggNxdN0A4iEbCjAbmYLJBnTA0WfOXQDWAH9turgxHC6S/ScsoaLcxacmW2+o9m7eayZjXyptMT7jmAhjcl4qS0FHfyuMttQGFjGNHJwtLO9IPx7VQvzc1fb2Vd0GMlV2aqioIcJvKI6hnjAPWMQ+sXHnFL4uQolQPMC96tBJwIU+JHHDgx7TJEfOzCUA3NAFgJn7W2gQWWR+X4HhHBiCX7tlNYJytxdDvgwx7dGxZe3IVaP3XO/qEZkTRl6vRoejtF5V/Z2H/4rasFB9hV9hWNy0LDyHMVY/lMOudayVj4gQr9p4byGDMRs0yfr7O8+z45ke1D5gKr+qzJ2ocQ1GeERA6YTFtcpBC7dMZn+okBbMbmF2fOfUUo0Ncaqp6fLpDTmfLLqAohNh2G4mRgxsfAQw6ZeR
 bSrcmCUt
 arzh7NBG0R/vKes2qGx7bJSvPpqtMQJfUpxavGzTAX6DCQxp7K0TrCDpLoB1nIlMho0X1Ft7ikUihILZvf80QSp4f2UXY14f5cxkE5Q0CjpHsile/ujYldm0vlre/RTL3XC2XsCvQOepyTXD7OsWL7FBEVTcrMgIbtmuxdZWtccue2l0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is confusing, we already have the concept of anon_vma merge
to adjacent VMA's anon_vma's to increase probability of anon_vma
compatibility and therefore VMA merge (see is_mergeable_anon_vma() etc.),
as well as anon_vma reuse, along side the usual VMA merge logic.

We can remove the anon_vma check as it is redundant - a merge would not
have been permitted with removal if the anon_vma's were not the same (and
in the case of an unfaulted/faulted merge, we would have already set the
unfaulted VMA's anon_vma to vp->remove->anon_vma in dup_anon_vma()).

Avoid overloading this term when we're very simply unlinking anon_vma state
from a removed VMA upon merge.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/rmap.h             | 7 -------
 mm/vma.c                         | 2 +-
 tools/testing/vma/vma_internal.h | 5 -----
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d..832bfc0ccfc6 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -165,13 +165,6 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
 	return __anon_vma_prepare(vma);
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-	VM_BUG_ON_VMA(vma->anon_vma != next->anon_vma, vma);
-	unlink_anon_vmas(next);
-}
-
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MM_ID
diff --git a/mm/vma.c b/mm/vma.c
index fb45a6be7417..4294ecdc23a5 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -379,7 +379,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 			fput(vp->file);
 		}
 		if (vp->remove->anon_vma)
-			anon_vma_merge(vp->vma, vp->remove);
+			unlink_anon_vmas(vp->remove);
 		mm->map_count--;
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 9f0a9f5ed0fe..93e5792306d9 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1265,11 +1265,6 @@ static inline void i_mmap_unlock_write(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-}
-
 static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
-- 
2.52.0


