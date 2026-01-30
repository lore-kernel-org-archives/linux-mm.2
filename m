Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD71E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B643D6B00B0; Fri, 30 Jan 2026 16:01:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24DF6B00B2; Fri, 30 Jan 2026 16:01:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BEC66B00B3; Fri, 30 Jan 2026 16:01:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87F106B00B0
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56A91D4D2E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:10 +0000 (UTC)
X-FDA: 84389850300.27.BE0C21A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id B471E180006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kfN/F4Hm";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VDEIcg4m;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEIeGa8s8FT4BesebaeHml1I0z9WBgn4siTvKsY8tgo=;
	b=m/NW69NiuvVua5r3MR//9mC3coqPdBeBATIeJ+fBLNsCXIrYJ3ABGSDDM9J4N5xGedVByN
	U5OvKEAyFwB5Qig4GgriI0mXvX9UHLCIN0QVVsP9KxeCcjeSpWOV4LRsUtehKDwbkQ8Wy6
	HhGmNn6BtdpRDI2ujowQHMsNpq8IsLc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="kfN/F4Hm";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VDEIcg4m;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806866; a=rsa-sha256;
	cv=pass;
	b=LGtVIa6fy32UGMfEiepKVndE2x5V8qk8z9nK0PbG6AvzOHBWi+CDDqcWoTWHZ/Go2YPdSO
	zvRWYb5eY2Xl3jSCs/Mgt4HRL83djAvpo5olf8BMDm+s1m+9Fw0hMOUBQqUQvOJCRsddV7
	+DFE7Lm0RzNlFCPQEB6Zxz/RWQpBmLo=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDR463538556;
	Fri, 30 Jan 2026 21:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QEIeGa8s8FT4BesebaeHml1I0z9WBgn4siTvKsY8tgo=; b=
	kfN/F4Hmq/aJh5qLGPcvGhrSEnzHPVbnAY2rsWRWUf3j5xpKBXC6WDRg4eW5l3g5
	Ezvfxn4H9VuMdpvT4JPbqbWQF3pBs49eZtdT8fLkfnxJ3VGQZvWTALeH7dvkjO9H
	fHGXmrmFCt7bIM3UiF+ELDi1Dv1L9c9BYMAHN1R7LBdEAR/bbw5PmMt80cMI3HY6
	IxhCgN2Fcwn3ehL1a1c0bOXRwt+QztvjMsYZav3ekF+7QXR7UfQsC18k7wOu2l/J
	6jYvUmr/nIbc2hadoazEjEvGRi28Rx8l/WtTwpbC8CUz1D70wqbsbmrdjiTYqsog
	DuUWMqV8IpmVHxqFQL+E0A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10b2rcrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UIkbKM032726;
	Fri, 30 Jan 2026 21:00:38 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4g0t-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gBbj/cQ3znIxuJ4ZVSIMW0jyKpF9Br8UFDDBGD2gDks9dgsdC9jGWLzaSSx2d3W9ZQqHy5uQgQlGMFPbhpAfQe6HIzVNRvYbrLhmXw6bIryYB9/OJh+Y4Q6vosIQlg5Jh0CcAVurNy13XtoDUd78FIZZOU6BWpiQEOhavyMuiEmW33LbAyMOac/v90YukGhlo+Cysj+yhmpopbM/8NSrrng3qhVSWiHxvKZVVERic0klI02HdkcO7xfT3jHDXzk2ZhYXqnsqBpVa7aJQbYKQIeWHIIDDuwk5289gep/VwJnFctCXZScetEFOE4qU7dL+fXoOXdPr/f2qfGU3d2cl7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEIeGa8s8FT4BesebaeHml1I0z9WBgn4siTvKsY8tgo=;
 b=fFVCfEua1tbcQxRIYqwzlKUdfEo/qoU78F0hRijCVO0+934c6C8ocY7dVUNw/6HMOTtr9vaLiaCNWD4tH77STLolGtFU1E63LgOBnhr/OK8we+krXnCbuixaaw+tb5BYpxFW0QmjqiEWf0dceoUXwjpCt4Fy6IljIQ2UhV8osoP0daNQ3zFLnI6eePZqUJ+fIzvjxHakG2LV10fVFtp4o76ryJre3pxq43KyXVejvSpyxzIo2L35DagjP5r0Waq40vKJV5h/DsFzyhRpW5EkLURLBlFHc9l4VBA86JiDvdB8T3ZqRshCAwcTwMYKoRl6CjkDiRFLup4KCjteTdLXEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEIeGa8s8FT4BesebaeHml1I0z9WBgn4siTvKsY8tgo=;
 b=VDEIcg4mJ6MppWIGAJb7wc4NadvGdL6AL5qchpCX/taN+8y26ylNZKbgWff05VA5DLk2Eg75UeGHJuTYReEdIVyhd2CuRtY03Il3ZK/IuyYdwIVvmHr2CpzwrawyjSans38PbSXZL8qhPUV2tVE+C3BlI4T8qcOOmsvGsyxyS2E=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:32 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:31 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 16/30] maple_tree: Add gap support, slot and pivot sizes for maple copy
Date: Fri, 30 Jan 2026 15:59:21 -0500
Message-ID: <20260130205935.2559335-17-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0077.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b9a234e-2f9d-4aeb-c25b-08de60429b09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Jj5AKjdI3T+bZW0zr9TBaR6aBjWSxuWxYjpab2uuYtCSY+CaOBqGjKZrMtJ?=
 =?us-ascii?Q?o168ZQlzj0HZpUIQJyaUA1Cfj1B4vYDHKqBWwMH9tnmqJvn4oIT4cDMVqnBr?=
 =?us-ascii?Q?lJZ2gTzypSsJbl7U3TG5ArJ5YntIL1Docu0XyRt9b2+WXHAjoGNAfP1trJCd?=
 =?us-ascii?Q?vi7yO27p1o1l64znv368c1DIAJPkuGPjKCrLrb+Vlpo9LdfK4GGJ/g40+NNt?=
 =?us-ascii?Q?MLIaxLRfMW45Tsdbrn1OgD+MqzHZyzORS1C/F15nT7BrjDizZIz8OJjvV+tD?=
 =?us-ascii?Q?Ch9Qf2mK+NXz5JXkH8vdITNxXtVo4QHdDqdrrkW7l994mg0Qlkg1i5UVczGW?=
 =?us-ascii?Q?fGjzxcUhHlPcNW7uMYOI+jUWOh2oFoo3VwE6wKI6ndDV/fzVPali4P2Xygil?=
 =?us-ascii?Q?pDHV+VDVZtbeRZGUGtD/qGVxUYrL7BXW27Nef2li5I0DFvsuCp/RaxMDl1m1?=
 =?us-ascii?Q?T/PzQ9J9whSfYaJLj6tTfFa3lKTiuUTKpiwpwRcxC6KPMXJP89VG9LMHNh81?=
 =?us-ascii?Q?XNt6vf8rC0/thkdi7bKZiBwBrESOiEzrazmWo4RV34Gw5PEp8CBNNIgX6OyH?=
 =?us-ascii?Q?Qt4XZskVuCf9RGAWNECis46TIRhngWhPWbzLGhuL7JWhIHR3aLuI3t7ZIfg+?=
 =?us-ascii?Q?yD4l2a1To/E/iXflKvCa/5PYwZ7PpzwJ5wcyF6D2KMqoxeonOhsOBPtNdgh1?=
 =?us-ascii?Q?5ze4ZgI3R9jP+crfOjtDDpIAQub1BlxuidX7f3C/ra6llbEbR/YTUR9dd0u3?=
 =?us-ascii?Q?L60WwIhpngBPjUwzLduZRTStz28f5tPM01NV/8Vd8yjLD7bpAwWYmobIes1C?=
 =?us-ascii?Q?UY06rzbyiFCf5U/wVmdw0zNN3uoIA3K9T66eMETt6c79n45fC5ssGsV2ndxL?=
 =?us-ascii?Q?eiqvfDPUZw3SE6ffKilE0RrLPwHC5JBVwscLVizXcHKvJYM+/l3+Rh0BegjX?=
 =?us-ascii?Q?hABLvVkvzR7Lu+EyCXe+BdckqoJxYiVVboIhLsgWaMVYEdRIo5xZSmrlrm6s?=
 =?us-ascii?Q?pZVxV088WPdGYLJOQzKgiIgUL8UdDsNoMlsQQAb2uIaOlsf9eOr4lcdtQNXm?=
 =?us-ascii?Q?PPuJvhNn1rEcQQtsrk7kgA2Hame9MkyEUbRmoUsrAobsK6YLZDMimt91n0LC?=
 =?us-ascii?Q?kw8eCES5OEa1B4RpwmH2G3No4mXB+HpuBCh55eyu1I929cCUC1RSfPfm1NmH?=
 =?us-ascii?Q?988sgm9j0HyIMduFR1BuUP6Qzbh3tuuY6np/edGUeQiC3NMsQMpOw6+0SCRC?=
 =?us-ascii?Q?Ab9pFXM6pe9qbIYBUf6MdhXXKMj7vQJrXUCKYgkanxH1WVIXQBUacQc0at6w?=
 =?us-ascii?Q?NlsYdjAN9HuWVcPiVFx9bOyYAQiXMLYuA3mkM0jqo96lh96qcp1Kgdc+dZBm?=
 =?us-ascii?Q?Fr2yf+VigOGdhVgLb+pMPYQ1005xzKaiamWacuxrO/26DuY0Eoqqv6vFy3C3?=
 =?us-ascii?Q?BSwXZl6hEDK8CCojiZQREu4l/IjcX9J82ZYScXtgP+kigVI3jwjtn3p7PJcj?=
 =?us-ascii?Q?Rl9pgK5gZO9pQhTU61WzXLsSuu1aEIjRhahaUTmLrcUFbbEwsXPlg7NeU7zW?=
 =?us-ascii?Q?iXr5NVLwGvil+LvuKr0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T5yZrRrlpknWyYQ5T4WlducbMdERb3v6eVsfeZsywym6Le3wPZp+f++dc+rs?=
 =?us-ascii?Q?ZXchyhjD7ojwGozeYrPdVu+j+LLwQo4P+A3lE7ybGxwh5hHlMiBWSzKnfiWr?=
 =?us-ascii?Q?FHZ6D4R+53IMlKhtpFtn1oUYOQf1vzuQ/f8fmIVxKVEtjMpMJpsQaUtRo6gf?=
 =?us-ascii?Q?MCCjKf17XIWCwzau+Ky+8+GNlDSROq1TN9S19FCgQ/Eh5UI/p91T/IL/FUOl?=
 =?us-ascii?Q?lmnWx+HA6dYIYcL4Wh1/obRP/fKoliRP8QnsGQqn/6BILGghBuNQugP/1eO/?=
 =?us-ascii?Q?soc9n6xzW7aw1+KRFmd4UmQanR7DWMNS+1+SUp+XOqj+wpYZbrJC/MvY/5Co?=
 =?us-ascii?Q?sA3ndkhZWv4ZLs9ppmC6dGta0e87j7WAW+ubNB+mm1SpZQI0Y3tFS3PevGE3?=
 =?us-ascii?Q?AHcPpJleVh4wf/gsX31idDF/uJ++sJfeTY49AaAe6AbvQetu1lqoBaczSUxT?=
 =?us-ascii?Q?5/SCrBO7EFBTR4ttPHDHsYn63mSS2Mqbm06GN4W+ND5trQl2YOWxgjk8Mwdz?=
 =?us-ascii?Q?b4ZiNle8FgN+GbI0LP0Q+VPePS9cMIAgJ8sYiLQzKOvIppcL1yCUphwXBI37?=
 =?us-ascii?Q?LN3Luc1E9XHD+4Tl+U/I9f/ouzxULvD/FSuxNFIqBl0TVrBKweLF3kguUQVM?=
 =?us-ascii?Q?VDkUVsA62nPEaScUXC5+hu4xJl36f4mdXc1NadK/dfH7Tvh2UB++6QFSqWto?=
 =?us-ascii?Q?5fLswVHQm2Bmn6jNrIN9reYrNROgnWLDgbAEywc9JR8Do1VulS/o85YB/Ola?=
 =?us-ascii?Q?xAJwnpioDAo1EjWTxFNeEfuxUm/kJ4ER8L0G83s/WQ510XjDCE5PvCLtyyxA?=
 =?us-ascii?Q?NZxSto5Io865YAviPsZR1lGuqteLOTr+TLMPEIYF24Rd+xG6MixmzkDcAQI6?=
 =?us-ascii?Q?ayhldy6Mx+eoVa7C7RdJs8SwZ9lK/zQL+LqncA95Qw8CpFIaXzkHMF1NsJrO?=
 =?us-ascii?Q?Ssz8VUgoecJEayJ/qZ2NkZQyDQ0pgoX0TGSQ2XI7Sxxi26u9kvrePetZHTPp?=
 =?us-ascii?Q?qC5wth9FdL8wXOm3pgY4CJHzdAcCypewPXS5ntFDZxeDQoiV8UPjC73Cwpmz?=
 =?us-ascii?Q?hf5acPjo8/4Rne4/SaZzql5ESqPevIRtH1KS4dlEdhDVhXPSJC+QsYmVMiIo?=
 =?us-ascii?Q?LscVQTnSPEne7HT9kZ/alJ54rTU7s/cOxRxf5WCeB9IWtaokfucz2evHfHbO?=
 =?us-ascii?Q?L3hB783vi+aqRsCHQU9n2L1HmBzKVaXJL4gmebmjc5w3m9EAhFMu13aGCNoo?=
 =?us-ascii?Q?oXAM8OWBfDctzSoiBeLwJgvaT7DLzbH0hRkY9Zgr7oqOkvz2IkSN9V0Ay4KB?=
 =?us-ascii?Q?/XmRrVacxppteT9k7wXo8Z4n1YiZyKhlI+N3v5KKEvV/9JjEdreqa4Mat/Ax?=
 =?us-ascii?Q?2lAqSHJs7iOA9hV/Vg7szZJDfCU3aoAV02sDlgQQKA2CbLp5gvrq9s8KE9pi?=
 =?us-ascii?Q?gIhPtredcSYjC/n5Y7nKC7RYx8SEcgrRTUzRQpPFWmIdlX1BIW5bamlNgega?=
 =?us-ascii?Q?BF0PYOF/hZ35+umg37ZhDqfFkbFDJWNagoaovZdKMbgRfzzYdOjptLJ8X63F?=
 =?us-ascii?Q?CknZb6aIyWZ+ThgkfV/fCbCnNviLMRX72uvF5PGaBMQyJvf98+clO7g3cajC?=
 =?us-ascii?Q?2/RTgQ/j3zEr75aoDg7sORC/J4Z3PkXjg1GIPHeJK5Yl4H7l/kE49iD1HYQf?=
 =?us-ascii?Q?UZlNu7PUmqn32u+YTSizbNAh7HWaxvpi123mC71ngtnIHFWwRDI9SKoUgfI/?=
 =?us-ascii?Q?PewrSoDspw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x0FLYnW5weh9DxwaFOaH5ocCqOzU8g3hjZxLLJK1u1yyVUsW56wzSH9x9vgz/L9cBwoap+Ydk0ckUuGScfVHbmSut5drz0NcyUl8jqcLQmRR01I9jwiG2bc57+0usN+CWq7ffOwcf1fC6G95PlVBUT1NkGBgXkBmyJ+T3WY3ONkk1wJx6CdZ7JM08IM7EcbTirg4zYJob+Gamy1sDJuUiznkMNZD6zLAg4cGhY0sKZOmHFt+3mQUANcrg99gNLPUtYQk9BkmYmwslIbkoDyurryrDSv0FZaX/hMkBNNl4a3kJEDeuU2ADjMDzgvLoy4aXKL1kfLFTj3AVnGhGOkFnhRybWumqqMtLTAxngnYHqqnnCbt2/svuIZYRJsppakp7eyE9Nr6zBz1IUDpMvMERcjkybI3VUKqire+k2FEP+UmGEm44RGyWaoWkBYY6FMU/FdXn660EDEN1BhBok71IVO7Dyx3gDzDQdAJE2PwqHG3lh2Ra5ZOLvL1vT6b2EeS6TldFlm7VBhcN7vJT5c/Ux07VRR0I9wcucyuUuK8tiID8dqTjsUf+Nn3ObhTFgjhVnq2iSM0BhbOnlxUnJqG5TMbuItFl/2oq4JEcAlftTs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9a234e-2f9d-4aeb-c25b-08de60429b09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:31.9428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gA0518yWCDyJJvg+EiZMSVDyeKsL8RZuMKr7TldIr3LZL8fFTz0+4ahZESA4DoULX+71JDmx/umOsVrGpyFAlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-GUID: CUVuGpSLZLOpSIHHdVyVx5VEqhvdpH6O
X-Authority-Analysis: v=2.4 cv=BLK+bVQG c=1 sm=1 tr=0 ts=697d1bf6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=WDoy55lLVV0zyn05J78A:9
X-Proofpoint-ORIG-GUID: CUVuGpSLZLOpSIHHdVyVx5VEqhvdpH6O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfXyM4CHf8YK9dl
 3exvzU048N1sIAxicfM7lZMyDk6ludxrpVvKfTJli/sUJfGKz+C7lvixYFPMBj+Y4NRPMI+CSMo
 imOuD2+TgXYSTFMIuZslznxpu96O5l8+wN3eBp6xuKsn4T0CiRyz7pB1PTOckeCi9nrHz9vIkxe
 x0rbJA1ap8INda4M3GniLWsl+oVlOXH7hRJr0dmQIctKwihoQ4LoBFnDoKfVrLQNb0crE/qhJ1M
 rsOWyULIhgRkEJPR6MfXu7+sHj30mP07BRKcIcM7Snqj2tnqPak9oCcAkkz24qbAMqfGxgXnjF5
 iy2zStV1hnKuMvJB2RnszmOg1rDK7Kct0apWA7nUBu/1R9fNPgHnwB5i5mG2Nu8E1KUFbqJPyHe
 cQDKmoADvoWGnkQeMy2SwTFhgIuVxcLrF48zHDC3VA5qZrBgJp4yZ0eElcQINc7pRhKBWCVXAXt
 Tf/nWikKgazNk9PNd3A==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B471E180006
X-Stat-Signature: 6en1s7fzgzauqjxdct7upigb8ju6a36n
X-Rspam-User: 
X-HE-Tag: 1769806866-759834
X-HE-Meta: U2FsdGVkX1940diHkPS3p/L89YhSHnVZApvxjh8wh1ljYxy4bZ0akG9VKFWVWCIRZlcL5O8LDsdm/InZzkh+NOXudeQQvH8/17/muFZz6o3CVCP1ve7R1uNHzyvoQdw/X0jRlmzMnSxj5kQW0/s8S7fvm/My2VS8Lq+OdijhdRX6cY7QTrXfSh6jSYIpPgRfbWes7uxKmKCTF2WcmzLPkYv65Sypa/EdJbw7eP6Vxy/VX6KWMBvoLY5suy7IzoyMatVty60mempLzsYKF8Vl/meFOHYtSFQByU9TrZwg1QYijxOqd3esBt1nqBGDLDqyH/nktWkygxC9X5g/LPtBnJkb9ro0gpZdJekv36SBvXIjGjl6Oi+vVGkJdf9jmsLEpHvCq6mzAVsKXae8v1g6i5eviwjkhf22U+oKk+Zc6WUNOQEgluZc+Ux6Ue2yg/1q6FWdJSMGMQyBP9xgroUGBgA9WfN/QFQWCSIihT0O+sErwc1LFzqGh7k2Z9Sgl49Y+hCiGIhUhgOph/I3W6mxWZ/r5OHHQAulbektFiweCqToNWIXd/kN+bZGzOGTJ+e5TM/3kvP7OhfSwwRCqe/bb3TXRrGpjttlAI+voXCpoz0Dj+GvC6Nf+gRfh0/6Xl9y9VcylMVNWD3VlZmmQ3qE5A7Y+AhzLEeNMRW7gjw+eXJvzAFO1bDaUM0nqX2gBVM5xIF6u8Od67m0KxH8M9lDfvrF6iyoUvYt8G+SoGB5tizI/9fZ7RuvzaO3rxHzhA5OnkuP/9+dOQ/4HKWSIqYmuQLz5r8NMYTzK8y/Y2dKLJPHuZHINOPAPv4oZYoYGn2qpJkv/sR4OXCDDRvGQj9rXNgwmgBW2+qLGKjEFmWqDVPhZLm4zS3v5g7wVnwwGDE8JXUoZW56QHfsjjz6doLV7bSYnDwGxyK324d9O4aWmI3+3W9S6SaAw+aByGhLeWxVwkSY8qcht+aCtG/j5Zc
 Jlp3oJyF
 kyPTieb1HKO5On7yFrxtTCOeHQZl89awPhqHrfQPQtIlkPuCLPLHRINsu5xFMUpD/0thx0xunhogPtO9ShfZuMRI+g5mUfadVITpyyRqXF3Vviv+H8PQUVaJ+Y9m0GU8FjpYV/wiYJjOs/mv9Lu7efrSZJkrUVfKM+vbH0R5eaAifU6LujJl/zznXoAt8vCB2vQdmBFlqyq0B1qmFRUCrsPtSJCIGKeL5V6AMVVUSH7zkyHlS9XM/Dun7qHfn2fmGjoX0z2z80vmRGHAQtd3rjHKqZZhtzCq/2Z0eQkeugDL8OWKgGfJt73pEFVEVSWmpj9gekfMKQlipIOZ3jzG0AXCNDYq9rgh1Xo2OUtF6igk09iMg2xNGX6XLTi0kFXa8AAsKsqGLK2QM1MJZIZSKuam3fQG7GQAp55S5tEgdFBr577iciNf4azcfuF2SUspnrR2AUim5QhNNtHXC2ygYTAodXeBx+3zdLHwk121Gw3q8bJZd+rh+jnoCRYAdeBnBv6/kBIDRVWpaPZW/Mu+vLPP1UTCx40eyeul5Cr2N13jbnauS77UZ4851Ik6ZaG4DsmNkAzwBuaQWXFAi4bj15ns6ajNZTCH+CzMwwQ39Ljq5Hkz7wykyD5o0kZP9c+uUiZ64KD8t5A9GE8MEqKURC3jFEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add plumbing work for using maple copy as a normal node for a source of
copy operations.  This is needed later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h | 1 +
 lib/maple_tree.c           | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index e99e16ac1c6da..db6a02788902a 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -165,6 +165,7 @@ struct maple_copy {
 	} src[4];
 	/* Simulated node */
 	void __rcu *slot[3];
+	unsigned long gap[3];
 	unsigned long min;
 	union {
 		unsigned long pivot[3];
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 499cae720251f..9c701ee7412ca 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -101,6 +101,7 @@ static const unsigned long mt_max[] = {
 	[maple_leaf_64]		= ULONG_MAX,
 	[maple_range_64]	= ULONG_MAX,
 	[maple_arange_64]	= ULONG_MAX,
+	[maple_copy]		= ULONG_MAX,
 };
 #define mt_node_max(x) mt_max[mte_node_type(x)]
 #endif
@@ -110,6 +111,7 @@ static const unsigned char mt_slots[] = {
 	[maple_leaf_64]		= MAPLE_RANGE64_SLOTS,
 	[maple_range_64]	= MAPLE_RANGE64_SLOTS,
 	[maple_arange_64]	= MAPLE_ARANGE64_SLOTS,
+	[maple_copy]		= 3,
 };
 #define mt_slot_count(x) mt_slots[mte_node_type(x)]
 
@@ -118,6 +120,7 @@ static const unsigned char mt_pivots[] = {
 	[maple_leaf_64]		= MAPLE_RANGE64_SLOTS - 1,
 	[maple_range_64]	= MAPLE_RANGE64_SLOTS - 1,
 	[maple_arange_64]	= MAPLE_ARANGE64_SLOTS - 1,
+	[maple_copy]		= 3,
 };
 #define mt_pivot_count(x) mt_pivots[mte_node_type(x)]
 
@@ -126,6 +129,7 @@ static const unsigned char mt_min_slots[] = {
 	[maple_leaf_64]		= (MAPLE_RANGE64_SLOTS / 2) - 2,
 	[maple_range_64]	= (MAPLE_RANGE64_SLOTS / 2) - 2,
 	[maple_arange_64]	= (MAPLE_ARANGE64_SLOTS / 2) - 1,
+	[maple_copy]		= 1, /* Should never be used */
 };
 #define mt_min_slot_count(x) mt_min_slots[mte_node_type(x)]
 
@@ -627,6 +631,7 @@ static inline unsigned long *ma_gaps(struct maple_node *node,
 	case maple_arange_64:
 		return node->ma64.gap;
 	case maple_copy:
+		return node->cp.gap;
 	case maple_range_64:
 	case maple_leaf_64:
 	case maple_dense:
-- 
2.47.3


