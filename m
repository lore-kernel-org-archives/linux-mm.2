Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14E9CE9D47
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487226B0096; Tue,  6 Jan 2026 10:13:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4309E6B0098; Tue,  6 Jan 2026 10:13:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309416B009B; Tue,  6 Jan 2026 10:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3F86B0096
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:13:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA16C8AACA
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:13:33 +0000 (UTC)
X-FDA: 84301883106.25.B06EA70
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 686C7140004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:13:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TEBOrC1L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fFRLQdfg;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767712410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1C0zY+O7l12yX6TvykuGk6S+sKiv01BgI9gIYdVgc0=;
	b=e8SoG/zQpGG8E4GRHjB8K2U73A9AUpuPiL1u1Fr2BXVYKgp/pemJgpHILaNk06KYxyqf51
	6ULdB053vpXqUhNk+u07eU8h6Krked+nz56EBqqwf5/kgcLDbnNPHjdYFFS2FArwAA/SCM
	tGiTb6DzmX798nx/IUh/CTPGcrR9DBI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TEBOrC1L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fFRLQdfg;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767712410; a=rsa-sha256;
	cv=pass;
	b=IOyTD5LCSJE4KAdABCpW2REsop30zk8WrzSrA/1AOG+7yZXLXa+KmIdTWXbnyC/yLGYc6M
	CVVyQNB53q5JhS+T+K8ZlX/A7fMqY4KiqUtzocu7WF//miLAI7Z6/y0zq1/MSsFj6yf+nG
	HheeG0d4whY1J67H42DO1q+TCy+lN+A=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606FAiN03790980;
	Tue, 6 Jan 2026 15:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p1C0zY+O7l12yX6TvykuGk6S+sKiv01BgI9gIYdVgc0=; b=
	TEBOrC1Lvl1TZu2iw7RSmaNS9r2zCOvF9uqjCbfAwwD5DcWptntXHVq+j4IMBhRH
	FDbZTKjlr4CWmNlH3pmsSE82O1H9pbD1UkPiVdO6V3hOt4japut/lj+w22dx/5m7
	Vx5Aat7Bmjrg2zbD/vWjeGkOFOIkWgnc1AgKBVe7eQT14oPJu6vI1fFQ+oIQTbWy
	2/mqgHu4eh8MOGbdb5RqJOvkrWA2H+6+MvEUq3nZemoDJCGUj4kjkN/D+1v0LnqS
	yalyznzB4oEV6X9uo3lWqqqH+LcHiJFd3zj2nDpCNB5qVjkEpmpkNaF73HP7kXWE
	QQ9rKxDfx7HJdRo12+x/Qw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh4t1804c-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:13:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606EwVlV034111;
	Tue, 6 Jan 2026 15:04:40 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010002.outbound.protection.outlook.com [52.101.56.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8pha8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IWQEuDmMUXvEYUiwMt7UlcJi7Z8w5NdY9c8hOd93grqoZ6yYK+V8fASRhviPbZnJldlo5KdUAgpd8i+ActOWH4K+B8GnoiCtCHzXlNxcQuLCSxZsgp37JRcCXucwwUlLYb72/YKKBiSW5OVe8jYffHaEZbf+eHDuWV32zbZqKclpxMoOwX20FzOIS1kbkskunnfmUxc2Hj8I7oxIfonvLfwt0T94WrPPQHa9HfN2jBY2+nerfzMNIuhfbH413NCMdOCwsvYQ+PXLxDvE21IbNzmL9lUVQ6teoLOZZUeTsbQEfpSLw+Q05bgxdIjAdJ+A4KR8YhhbbQnpjhmHrIRoWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1C0zY+O7l12yX6TvykuGk6S+sKiv01BgI9gIYdVgc0=;
 b=ZkLyt8DGl3pTeEHdQuuVGiQ+947Fq0iie9ZlLvg2tBOxBpqxZS7e0PvkxeJYQvFEhLsX2nhuIeCJ2Db9o7j2RVOjFuwIKJYTR/XeV9iEva9ZdZDOCGwx4Znwf81Op6myxOYd2EVXfFq3YS8YFY3iQYutdr3hYlQ4dtbIHmq1ht7x/i3rxdDqbNGw67KTiH/8SHOvzMiZtIV22bk2+ByTI48SjeCrBYIpM6N0z5Mq5KFxi7FiZDth3jgaAzqzkSlFW8WBxLwXWuxz/h9marKg/6//ePyZMbDsCYT+YpWlptBXt4MY3jP/EaNg2lelWPeUXneXBb+2se0zuIFCpdCigQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1C0zY+O7l12yX6TvykuGk6S+sKiv01BgI9gIYdVgc0=;
 b=fFRLQdfg/9Z9fRGSnRT+3xoY/1wcSzqEeHxaZN8Zc3lkUjX1Q6YF9QTe4uxALusLmL0rGUklBmsK/xJSb3Lb77lqRnD8bAE7j8KHq7mTr5/BgpTTd6nYj2H13I7s4JTBreTd46IPVIVvQotieuGodYJyMyrTp8TuF7Fc5WT8u+U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6039.namprd10.prod.outlook.com (2603:10b6:8:b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1; Tue, 6 Jan 2026 15:04:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:36 +0000
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
Subject: [PATCH v2 1/8] mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts
Date: Tue,  6 Jan 2026 15:04:26 +0000
Message-ID: <5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0085.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 7791ca26-6814-484c-8631-08de4d34e852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?etftp2FNLlvBKPDyLfbU3uN7SDr6OG6u9Ti+nAN5gb/MclPNFikXWWTQ5SrE?=
 =?us-ascii?Q?ajjdyP+sRfceLc93gPo5i5ZDhgYXGHLbWCa+hm3zVuDBafqx94jqQo1COhtX?=
 =?us-ascii?Q?Wo4Mlz0sXDQ81OD0FelXnmSOIIsVTFFJt0VGWBVreYfOoIlsagnV/ddQrAXU?=
 =?us-ascii?Q?RCa6OkYbsKmhwo5UXl7PWVbwvPmFOFVqwAfxS3hy9GOo86wImM3wxtYoB3W5?=
 =?us-ascii?Q?KYEHeoEeliy7S5Z6xah48hfku4ERhJ2/mlzJx5bIK2lbh5f9Vqdob6pH+maR?=
 =?us-ascii?Q?bVr2Ne9wMafPY9ZNTm4puFfVjDZP5YfzF3MmwVJrD6oBmmNQAtuuk0U0op8N?=
 =?us-ascii?Q?520R3XK1VZGtHtXZLbmVh4FBUxl4FX0RI8XXKpSMRXQZn5/yEg3OJEYdpdLK?=
 =?us-ascii?Q?zAAuYDhHgKJ5n+poq8MLIMqvS6dIwpgOIgbXbsYg7aQyopPcDr4C+8+fKBjG?=
 =?us-ascii?Q?vNiZF90ucCXMAgZcc+mtZyRj4hNf3hDI+pIYNH+g9R/y7fIUeymkFLF29Jnn?=
 =?us-ascii?Q?xpsdN9ADjFqcQnKbpZqdhOSHsJwbfl5a6NFNWG9l8rH4Oxe4H31prcMtXfRu?=
 =?us-ascii?Q?9YSaiukg1Cb1a2qB12y57g66ukwhqAZ9g2Ctq9jbGmJg6MvJlrOr3HwwIESk?=
 =?us-ascii?Q?1mD3RWUpipRTzzTQp9sXLbnsVDP8gL4EEl5Ckyt9DPV3alTbHiMOSbAQzs3G?=
 =?us-ascii?Q?In8QuS4f9PIgrgnjgdExNXLruy9CWrHTV5YUtbGqOdI2VB/5vCdiIX+7dUd/?=
 =?us-ascii?Q?ntoVZpmmnVZVCTtMYqQIxM9mMR7F7yNiAK8tuOe3nNCTJZEJIl1bccUpWf8C?=
 =?us-ascii?Q?Ocdr4t3pf5ogivPIr2bCqRtSo2m2wyhg5mlmg89ymcxcklMFGAMzO5p75JDk?=
 =?us-ascii?Q?Zw/U7KYT8mPNe390PZq3/KmEog5fx7nCOpppiC4C22vJAOykp4qfHVhO6Khm?=
 =?us-ascii?Q?2y2YgNlzZsqsPhTBpvtpOTUaAuYAr0VDEAZje9s74OsWwiQg6IW12MZ/op5s?=
 =?us-ascii?Q?M+07fd0qJgnztWDBGEADp96h+jn90NVHRRbrVNq9cLv4hhFS0U9E5gDb93N4?=
 =?us-ascii?Q?gbSnm9Nl11OT2K3cfdPLjyQ6IK/8Y0wfMnmFzzx0L9/XWmPfHLhD1rC7fA9D?=
 =?us-ascii?Q?BZsZQ7moyfjxMWIL+BZQ1PEimz8i0OSOcrwjivDEwYNJEZX+M+2UykacLhYe?=
 =?us-ascii?Q?luYwWAddkH1HYhrJ8dF78P1IS3WaR6ZNEhNb33+oZNHq7y4MAlBTBFZJwf3j?=
 =?us-ascii?Q?tzk9FhRpwWaq/OHVEFzPCVviy3/lH6A092+gouDKHE5ZBo0Nmk44qW1g6sDx?=
 =?us-ascii?Q?glGL9802ZVo0PGTepp1dQIsg3P6Em1mmCvIpqj60+lD/SnDhjGz/7uIGA+uj?=
 =?us-ascii?Q?gw5KOB3JQEUe3PzY+HzRk9daW+woMGU8/9sUdEVojLgYaOZPqfxpqdj7j05j?=
 =?us-ascii?Q?6S1OodXhkz8DX9ygBr2xzJU4LFj4nusA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?37PfKA5HPFZDkPGx8DpAFKgLax/LpXwBNRIqPPwgiIbTwVy1fGwX6w2a9KtT?=
 =?us-ascii?Q?7vDp/szJuUEaJKxEBbIW5ayG3m+Y07E+b7mPEQjK2B/Ok/zCD9NGSKaNgRIm?=
 =?us-ascii?Q?Azk1c4TeExTuzQekQ/TOaCzwDT57t/19KA7oKYkOHzG8cXlb0T8fJwJMFZZH?=
 =?us-ascii?Q?nOCPuWkqspX8EuSJCcWg4iSayzbxvePIr6TNSCVOl3PyBDdibgtMCruZ/SyN?=
 =?us-ascii?Q?CTeLg1QlzTeYUnPA6RfGxzhYelNPcZ7Dn38PCBwyAr8YtwgQ6KA8/dOWmQof?=
 =?us-ascii?Q?qw+zwW40zgap5xaEVB8eaKq2oLv0+RqqMqlKfzKyyxZd3eTb3pmKS/3zP5a0?=
 =?us-ascii?Q?RvHjvIW/loTR1QLo0LM97axfFRucDeyj5wq8HujFlNG+mBcCBEBfAV7YFE9m?=
 =?us-ascii?Q?O+81KFwnMF1wMUpE5Sy4AiIhkuVt/TwY9ICI/e1KweF4wHWvtIAw7+WaJ+4w?=
 =?us-ascii?Q?BabUurCNYo8Jux1jpNsadgkVozaLtweCU/t8Qha+XkO2Qn3YE2djGeog6kxz?=
 =?us-ascii?Q?1SSDQF5AbRkZNS+Gk9VjYoQAhu7b9KRzcS4X/mEGoWNbbGSBJBqGHNWPAwy3?=
 =?us-ascii?Q?hO2Y9DQsxNvLrt1loaviNopfgVaOBzy3h2ZNeEHg30FUMG8UafxoIqoJ/Mkj?=
 =?us-ascii?Q?zkjn+SUHx/C1D809pfv5ovfRAXbvGiOgzc4n8usFj747EDF07KskfTsOTVSu?=
 =?us-ascii?Q?2givH2qpU2yQIUj158lL+qZJC7dddFQizGUOwUa7jVYr72qikmSJufORjuhD?=
 =?us-ascii?Q?fVFaStWB+il/efD+FhNJsSCyTVKWtqA3phZhnNWa+UY0kEjkgADV3bra3DF/?=
 =?us-ascii?Q?YI/fj1oD2DpSB26GN9nfV7eEPJO55GlohPaN5BCq4WRpPB63r+iE68oS3Dvb?=
 =?us-ascii?Q?P51uwCyMfoK5KpIMLoGzj9i6ju6uouTPXFTi9zvVPm+OO0O4r4SRJ7bVLtAb?=
 =?us-ascii?Q?w+Kmc3YNwVx9Ny+EOPVNMy2CAFP3iaNKOB4UVZVv31uvgDnjd9pM1mvRkGtd?=
 =?us-ascii?Q?b3iTanjtpKeT9O/Jld/f0o+OMCG9shUDxKNqByIh8hFsldQ9OdQQ25Oc/6yz?=
 =?us-ascii?Q?doIcTVhtir1iQWmkhd/Ufi7Ikr9Pv7IFteZkIBnEHGlOD50JczdIvmtMAbCq?=
 =?us-ascii?Q?UX5sI5ess2z19WXWOCkyQG4Hq9PJpfS6FiDnUveL91PZDfJloEBg+BMLnqa6?=
 =?us-ascii?Q?sPm0szdd2pn820Nr/9uK5UL5zpAsfppRENuZuitPYjMKZHArYWHOfXUNw9TY?=
 =?us-ascii?Q?XDMYQsDooVHELXRwCA+A/cWxOnFE3wjhvch8JgoiMTgcWORpQTyBY0ZDVeZK?=
 =?us-ascii?Q?7Tsbpv+GqLoxzE5Z988YBipe9J/Zsqhv2xuE3v5x4adWbp24oe/xi6TNIX0S?=
 =?us-ascii?Q?h8L6Zl45ZWjU2408jLR5LxRO6/tKgwuxkTUIiLchp1P/o83BhnM8PLXVq1xD?=
 =?us-ascii?Q?uAJ1r+v8Tvx+C5QiXB31MY6nl5gSUcQnpp5qlVywbe3kMrg02/UACaFW3tDS?=
 =?us-ascii?Q?617npzMWOXw8wv+vaunZ2MISye9Qt1zD4epgl5R2ZDqI03Dua9WaBiyZcC24?=
 =?us-ascii?Q?gibR48W8XEUW+6W2TimDbBKcBsy4R1rxfWwJoe3WSwag5aVdTBF4K0J3/MAl?=
 =?us-ascii?Q?W1fHtDOMJZmUIQ1XyAld0iR6hrT3js4F8h+HCTvrhzVRl0KaSGI2MvQzCiWj?=
 =?us-ascii?Q?XAMldW84ezDCuTNbIhgSdSQA0wg1KLcEstPbGj+NdTUjeyGlGHyOsuMunhSC?=
 =?us-ascii?Q?SXWpchpPPRcCpAQ3sZJZaITFhjCPDJs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SOnhmUqm+5AiErWnVOtY4ea7C5oICI5b/fV1X+cfloiqH21zIijDnv6GF6vL8tuD1R1r14bBLHOn3zV2bbpyUCHKGRnqN6qtKf67vRbodtZjCa6kZJxHWVBdK9mM5mq8gCORY2XLHfVrzvc1/9RbNYR9MiYiKPRcX/DEIguic6YKFBbb3Fqcyu3ZCEi3oi4wXtHxazmXqHwTIaiUkCRKgasG93Y8vC2r+gRuDsBsGOHqNf3o5bckThK6r7mhuaM4vlu5Zkf9h84Ml1VlVc0+rAqYL7KPbu0gr3J3/6FMsXy0XGX9tdqUkJQGqbRTuPoAbG9DCFkoTjYAzaFW/aFoZHpEZf9go8b0uJOucR6yXTzwpHpiryoWKvOTXQISZV1wy3dbxDFx9vTG/7eVd81jlldx1vQPWO1js6VvvvGO4X9z1NI0lJLcOj6+9qdM8jVWBK/kb/WS83lY95OwQ8OzmXfLozL+f5Zwki/TnD7LrJnCkFci7LYOIIy68HEgfyfbrakNH+UGOIIleTKPa6HDDEWnyC77IdEfYumygeLYSlubLnupWkbBCY3Zt1k9UWtSTQHF0VVLl2YT9IjS+fApL6PGAXJkJ1zehUb+BPXoj0Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7791ca26-6814-484c-8631-08de4d34e852
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:36.5978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHdBD8VjPs00N49H1JH62nL5PtQkoM8rcL/rqD+AdcufodltMrS1/0HUdM0AddmvQqLqwVfU9r760SCITFLv8ciQVidldNyJdbCQJ8muzYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060131
X-Authority-Analysis: v=2.4 cv=P+U3RyAu c=1 sm=1 tr=0 ts=695d2694 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=TS5ZMjQafXG62o6CVrQA:9
X-Proofpoint-ORIG-GUID: C5V9NsXltHyDYUvpdzlhOrqdCsre7zQr
X-Proofpoint-GUID: C5V9NsXltHyDYUvpdzlhOrqdCsre7zQr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMSBTYWx0ZWRfX54KwtrSXQN3x
 BM4dHgdfbp+S8D4UuHHa/DG5U7UMhttkuP2tgOzFKsS3mQ7LIBZUXaHA+bLmQyBe9k59/a5/Eat
 KlsCxFRMAhAbkje1R/q70uSj7DwPx7JEOMyiwqgLOUZenlNhphn1MKJFkHqTjsGxzqMWJE1DcYL
 Zb8+vdz6qQeiKzxpWv4BZL4pg5eW8ndLcIhpmPnge496EwyIkEYRYH4w6hgmh2SyUsQUEC3KtJ3
 HJBf9kZUV1PRqg/3EI9plfFyY3UxNFlHSC6keuiKZkgB8/DQMmYCs+Lr4sHhbyTPtfeewV3K9vV
 cLc79nvU5sJbnDpmL9X06HJnqeFbSYWtPOoa9DtWbpS/QsDT9xNSSFUbCr8FLLkJcWXOMbfyKOC
 6cUkCTlNNG4sP3G6NOUPyxBV2cNKYdBWRz3pkiFh5eZAdNwbmbu4qMUM7N3wNh0auhj7O7OFx2w
 Q9fNrMG28MBwKMTFU3A==
X-Stat-Signature: 9h6ifcx4ofa4cw8bhwndb3qcrnznsfmy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 686C7140004
X-HE-Tag: 1767712410-261349
X-HE-Meta: U2FsdGVkX19KaRIhiBp5rfnmnUQEFbdYzLcU6ejdpxXIHmAfzUTD2umh3QsgIkdKodu+LoNHDX60lGcWf2xDntnSmwyHo7RSbApVQxFt6hWur90NPedaJgG17Jh/jjwhW9FgVwPSoa1KpZz1MyYBLlhVhiMIbKvv+y0GxfMXA7TfelWpUYQz62IFkAvXvkjh6t8w1iulp9JJ6aHnUD7OpDPdTtWprd5fxJ0+xGwjeosB3BbzJeEXQf1V4jfWlJusulQbcx1QN2LFutXmHKjuUKkm2RVaWzOP9S7ukBBWSChjoR9uAMR9cK7EUfwMnMsQKfYB1xI5YoTGRhLl7lH9+cYq3D9woJJF3m0czUUNQ8PBVvT8pGw+j7ZQgDxPz5D7wTpWfQILNw+a9OVfRcdFqa+6MCAn93LhY10PhWJTLJ1mn+iEpHMOC4AiEO0cTgOiF7Ns8LPkho+jf3AuY9hYYagR4uhC1hCFRnBPwe45S5hN+iV4S8EEIYEs/a76b6j1vSa89tde1u78vhq7ypTZbcDHr4b2RB8MkzGQ5cQns+StwepC2dLR9ARdyTn0JQyBaB/noVlTRH6Oa6MzQC5JPxiEvH+xaIEuCzGUFN6r7/HXv4JPf7I6F+AL2p49NkqrHPCmEW+5ntZyuU/BXxy1xnC/+xXZUVGZQ6cwrgu/oEjdTBqwBLSqXlTcKBpBDPpoWSPySmzYOuH9VgoF1W4LXzjDUMhOqfsYP2CQnOF++FWZR/Ci8Z+s1WpFifNDziAK06rM15vFFFOQLzPHYrjFyNYiIuRl93PBZWbcElqqcu6Oa+pEXCPsozae2PM//2gboDtt8hAR10A6Elg4ocERMNPg+5uWFEhy5Y8taFGTJH8Rh4zkJ4mrX2ItXmbd/uMeGBxXSTu/1JDSRgt+LEyMqsbXb4YAdgpKOvHEJ38WTXSyNCHcAD6Y4z2kDQuccYmG9qUoGZgRPXUsz0d20t6
 rOwiQ2iQ
 PHxt28mK3WPPDUj5Ghn/9Z8U6yUsa8B/9SCYyXYLXuBJ0Hs5/YwYjZtsvLIJE/tynAKG/1pRGstKMmx78qmrwMyC3RG9TvgAlp+4EB3YDH9wTB0jOseHwmZKlYyUeSk88lZyp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kdoc comments and describe exactly what these functions are used for in
detail, pointing out importantly that the anon_vma_clone() !dst->anon_vma
&& src->anon_vma dance is ONLY for fork.

Both are confusing functions that will be refactored in a subsequent patch
but the first stage is establishing documentation and some invariants.

Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
specifically:

anon_vma_clone()
- mmap write lock held.
- We do nothing if src VMA is not faulted.
- The destination VMA has no anon_vma_chain yet.
- We are always operating on the same active VMA (i.e. vma->anon_vma).
- If not forking, must operate on the same mm_struct.

unlink_anon_vmas()
- mmap lock held (write lock except when freeing page tables).
- That unfaulted VMAs are no-ops.

We are presented with a special case when anon_vma_clone() fails to
allocate memory, where we have a VMA with partially set up anon_vma state.
Since we hold the exclusive mmap write lock, and since we are cloning from
a source VMA which consequently can't also have its anon_vma state
modified, we know no anon_vma referenced can be empty.

This allows us to significantly simplify this case and just remove
anon_vma_chain objects associated with the VMA, so we add a specific
partial cleanup path for this scenario.

This also allows us to drop the hack of setting vma->anon_vma to NULL
before unlinking anon_vma state in this scenario.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/rmap.c | 130 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 104 insertions(+), 26 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index c86f1135222b..54ccf884d90a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -258,30 +258,62 @@ static inline void unlock_anon_vma_root(struct anon_vma *root)
 		up_write(&root->rwsem);
 }
 
-/*
- * Attach the anon_vmas from src to dst.
- * Returns 0 on success, -ENOMEM on failure.
- *
- * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(),
- * copy_vma() and anon_vma_fork(). The first four want an exact copy of src,
- * while the last one, anon_vma_fork(), may try to reuse an existing anon_vma to
- * prevent endless growth of anon_vma. Since dst->anon_vma is set to NULL before
- * call, we can identify this case by checking (!dst->anon_vma &&
- * src->anon_vma).
- *
- * If (!dst->anon_vma && src->anon_vma) is true, this function tries to find
- * and reuse existing anon_vma which has no vmas and only one child anon_vma.
- * This prevents degradation of anon_vma hierarchy to endless linear chain in
- * case of constantly forking task. On the other hand, an anon_vma with more
- * than one child isn't reused even if there was no alive vma, thus rmap
- * walker has a good chance of avoiding scanning the whole hierarchy when it
- * searches where page is mapped.
+static void check_anon_vma_clone(struct vm_area_struct *dst,
+				 struct vm_area_struct *src)
+{
+	/* The write lock must be held. */
+	mmap_assert_write_locked(src->vm_mm);
+	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
+	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
+
+	/* If we have anything to do src->anon_vma must be provided. */
+	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
+	VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
+	/* We are establishing a new anon_vma_chain. */
+	VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
+	/*
+	 * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
+	 * must be the same across dst and src.
+	 */
+	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+}
+
+static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
+
+/**
+ * anon_vma_clone - Establishes new anon_vma_chain objects in @dst linking to
+ * all of the anon_vma objects contained within @src anon_vma_chain's.
+ * @dst: The destination VMA with an empty anon_vma_chain.
+ * @src: The source VMA we wish to duplicate.
+ *
+ * This is the heart of the VMA side of the anon_vma implementation - we invoke
+ * this function whenever we need to set up a new VMA's anon_vma state.
+ *
+ * This is invoked for:
+ *
+ * - VMA Merge, but only when @dst is unfaulted and @src is faulted - meaning we
+ *   clone @src into @dst.
+ * - VMA split.
+ * - VMA (m)remap.
+ * - Fork of faulted VMA.
+ *
+ * In all cases other than fork this is simply a duplication. Fork additionally
+ * adds a new active anon_vma.
+ *
+ * ONLY in the case of fork do we try to 'reuse' existing anon_vma's in an
+ * anon_vma hierarchy, reusing anon_vma's which have no VMA associated with them
+ * but do have a single child. This is to avoid waste of memory when repeatedly
+ * forking.
+ *
+ * Returns: 0 on success, -ENOMEM on failure.
  */
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
 	struct anon_vma *root = NULL;
 
+	check_anon_vma_clone(dst, src);
+
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
@@ -315,14 +347,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	return 0;
 
  enomem_failure:
-	/*
-	 * dst->anon_vma is dropped here otherwise its num_active_vmas can
-	 * be incorrectly decremented in unlink_anon_vmas().
-	 * We can safely do this because callers of anon_vma_clone() don't care
-	 * about dst->anon_vma if anon_vma_clone() failed.
-	 */
-	dst->anon_vma = NULL;
-	unlink_anon_vmas(dst);
+	cleanup_partial_anon_vmas(dst);
 	return -ENOMEM;
 }
 
@@ -393,11 +418,64 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	return -ENOMEM;
 }
 
+/*
+ * In the unfortunate case of anon_vma_clone() failing to allocate memory we
+ * have to clean things up.
+ *
+ * On clone we hold the exclusive mmap write lock, so we can't race
+ * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
+ * anon_vma's, since existing anon_vma's are what we're cloning from.
+ *
+ * So this function needs only traverse the anon_vma_chain and free each
+ * allocated anon_vma_chain.
+ */
+static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc, *next;
+	bool locked = false;
+
+	/*
+	 * We exclude everybody else from being able to modify anon_vma's
+	 * underneath us.
+	 */
+	mmap_assert_locked(vma->vm_mm);
+
+	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		/* All anon_vma's share the same root. */
+		if (!locked) {
+			anon_vma_lock_write(anon_vma);
+			locked = true;
+		}
+
+		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		list_del(&avc->same_vma);
+		anon_vma_chain_free(avc);
+	}
+}
+
+/**
+ * unlink_anon_vmas() - remove all links between a VMA and anon_vma's, freeing
+ * anon_vma_chain objects.
+ * @vma: The VMA whose links to anon_vma objects is to be severed.
+ *
+ * As part of the process anon_vma_chain's are freed,
+ * anon_vma->num_children,num_active_vmas is updated as required and, if the
+ * relevant anon_vma references no further VMAs, its reference count is
+ * decremented.
+ */
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
 	struct anon_vma *root = NULL;
 
+	/* Always hold mmap lock, read-lock on unmap possibly. */
+	mmap_assert_locked(vma->vm_mm);
+
+	/* Unfaulted is a no-op. */
+	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
-- 
2.52.0


