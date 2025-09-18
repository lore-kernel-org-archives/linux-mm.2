Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF5BCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8128E00BA; Thu, 18 Sep 2025 01:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AEF18E0093; Thu, 18 Sep 2025 01:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7768D8E00BA; Thu, 18 Sep 2025 01:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 628118E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:57:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E8B111AD60
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:57:40 +0000 (UTC)
X-FDA: 83901314280.02.BF7000C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7313040005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:57:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W5IKEUjJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h0Eq3ds0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758175056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHlKxOh5+6HFbU09axLl3uNzpWZGTEf5Ki5b8Fo31Ds=;
	b=zyMss9RRkq8UA/5UYz+OdPNLXULvO2ikHU3DkM6CSkz15HpMxq9zFtsSSkAVnI2yPM19gl
	9szLgm0hDnZBN9O5ouP9Ry1v6DCwlsI8yaNPQZFjUB420FaxdcWqnoQUSaN50Cus9T99zz
	0wq2Y0ugMxOfmCndaAp+nITVGB9CHQk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W5IKEUjJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h0Eq3ds0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758175056; a=rsa-sha256;
	cv=pass;
	b=RgjU7JDNHp+GBvDrxIIc6l6UmGCaqBBb+1MsdW7VBIlGPwQPUhcXxv5QYxwy1j19NHCB6u
	Tnee5UHiliuBJC2C60t1fX1bL7fQJFRjHn8HaTj3ntCjqyHWgga2MQfst9rltPxQRFcgK0
	rNOdkXNYT0Gph4aYtVP4AMnjt0C6Qno=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HMr9bt014383;
	Thu, 18 Sep 2025 05:57:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OHlKxOh5+6HFbU09ax
	Ll3uNzpWZGTEf5Ki5b8Fo31Ds=; b=W5IKEUjJ/9T3hRuq5yMzbjDSjoh8LJMiZo
	x/+vG/UaRctLxbcs7LDUg0heHusvxiGMzVnpea1zwnuyw2IKu2sdfgnMLwvhcV+Z
	q5fK0mN3pXwm1PESkxAR1BWypksA30iAY12moGqE+PAoURILzd24NU6JuyueMFed
	udhhYmPL4FHMD7B2BPxphjvkq9XCYFhyDh1r2gVczVEguRKxl/Lb0lQdzDkFoEku
	O2euP0+R3/UAv2rgv8vSYnEqD6jbkqUv052F/metMAXSE9G+jFF+3/AP7g/z439O
	z9USf32rDVsrEl0PLD5hgFkUa6HkcoK39d+B50/rTiL7A5DS/ldA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbtrc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 05:57:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I3IjNl035132;
	Thu, 18 Sep 2025 05:56:56 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013039.outbound.protection.outlook.com [40.93.201.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2myf4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 05:56:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TnY+Zrcff8IzME6dCDKOc2C/+kk7W+pCEn5kPwyK4CGsGdBCP+XxoKkJfr1IQ7G+rEp0Zw8JYwg7TGSXGrPd1H0QIUBKR6IKm3sCgl3u+1QuWSTInqVXprCXv/7m9PnBrwKRC/aQs+pkjCEPyg86yY92xl2GNIsA1fhXCxX0UJtNUA8Az2FC1h7JfsOan84+H3oiLrmCmSclaP2H0NZCc4d2I5OWSHZkW6PQ4ZDRctYImPZTVIKGW4rgpNrjYBSvwCR8KYGfSKtfvXfU2xUW5Cpht3QLvDC4cb2SEMQUrInO06fHYe7UCYUayvF7i2+N7eIvfwaXsPOIfnHoo3C3Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHlKxOh5+6HFbU09axLl3uNzpWZGTEf5Ki5b8Fo31Ds=;
 b=Y8elBjeFHERRM32YmoHZ7eOh8uAlrUl71x99r/eO8kwP6qKUXw1ph6PLGP0m4EiFKiqYnX4Ao4hcArhqmMvehYa6Vm4nfRwTQQE3clqt4lZajjVsy2dK9S1cuPkB213SvsIBi/Zpe0mZvtuCF5NX7sD/MB3w1SLeGS5B9CyWshbUOfa7DG/p2UOrRS6vEiwJ8SAu3ch8zswOaVNZ6evbk90DR/yTowBNZvT6P04yNqhsPPQ6494hwMZRiqDF6VUUIWfdY4Mw46cIQQGz2Ask5TmWbTu63FhEIYS0nR841u9P7gEF/8b8SKWg7ymKsm9b4icOqnrkteiAGPclTkX+zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHlKxOh5+6HFbU09axLl3uNzpWZGTEf5Ki5b8Fo31Ds=;
 b=h0Eq3ds0J4ktIQcpaR4vqLb5VuPJEgA02gY4rlsL/GDxvRkstyQqULn4A3GXNfaIzoqLjKufG5EKz8e52wXnhdiMeaPeFmiX0y4MDxK/hODEs6VeYDzx2/LCvRyusYxx4a57/Koh9qxGgUnXIvHI01WRiJ4TDz9mCs1sCYvRr14=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5051.namprd10.prod.outlook.com (2603:10b6:610:c5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 05:56:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:56:52 +0000
Date: Thu, 18 Sep 2025 06:56:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
        Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 02/10] mm: convert core mm to mm_flags_*() accessors
Message-ID: <ccdd6de2-d908-4512-beba-9aa27bdff76e@lucifer.local>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <1eb2266f4408798a55bda00cb04545a3203aa572.1755012943.git.lorenzo.stoakes@oracle.com>
 <3b7f0faf-4dbc-4d67-8a71-752fbcdf0906@lucifer.local>
 <20250917164037.21c669dfcbd7b0b49067a49a@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917164037.21c669dfcbd7b0b49067a49a@linux-foundation.org>
X-ClientProxiedBy: LO4P123CA0369.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5051:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ed0e7a7-1d55-4478-58a4-08ddf6782a87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dC3hMgqj6NEIpXHRYYMBU93NfsVcH91fJReKTTiClrivu4jgqSDukY1FUfz9?=
 =?us-ascii?Q?ag6d0eHfnvBzGfxE2A3+ZAnsQbXqM8WB9qiQJbbxn2EZplrmricSW6sBMKBh?=
 =?us-ascii?Q?iyvECgsdsVeUWxVtCBnJZgXY2Ar+dRjXCeE93TL3FCa3oj9H3OPDxhnBOn8n?=
 =?us-ascii?Q?givqKanKAlJaamJJgL2ddKlfrA5I5rqKtBhpgMCsVtxdadXVxxEYbuomfEO5?=
 =?us-ascii?Q?VHkFXNzr3SPmqD7ce2TfHsu7O2Ntk9nZSfH1yWBTp2N7wwNopZUYgy91iBU2?=
 =?us-ascii?Q?tuooKvYdlZMIBU8EoI+wKl2M5Od4sJuYlOZGPg7rM8TTTrZioRiipLoxHhm7?=
 =?us-ascii?Q?A5EpShOMcOGtOKK1oSM3KSbUn+kzitgvJ86d6wZwviENFWHgxYBkCitp0IRd?=
 =?us-ascii?Q?vcxKUmuVRuaXN4dFDdHEtEYYydrsHwbUGKWCu2ZIoCZ5BYhGfEAWICfld4un?=
 =?us-ascii?Q?Tcu4/jxx3tHBs9Dy2RX7/Z5lM8TZENgBiyyC/v+MJV0ID1ujH/Cq+0nNJY8W?=
 =?us-ascii?Q?fKqB56bNHPX1pwTOuy0K4krtahWXgP8SeIHKnZdPSqzPtQ/1KwwGAtOwyrnj?=
 =?us-ascii?Q?cjaNrqB03jvt5++Df24kx5VZJ/xjsTIptO8/FU8cCke56beaBq2CiOgJD4pt?=
 =?us-ascii?Q?O5+bd+YKATfKu93h9fnIoiEzMitRbMNoGRAYj7MNnGMFTebsPvRNdynbkgxS?=
 =?us-ascii?Q?Glwoi5J/ockBzJ/4Z2UlT8cy4K8fKbhT3K+yYtqbVYSabXyJFi7s8WMVcRdS?=
 =?us-ascii?Q?YnnO/qun19WzkoWNnkyXpHC9xPSL8GpVzQfKlDT4i9YFNbcQnJox63pr4r6z?=
 =?us-ascii?Q?gu2JeXJQTg8FXNgYjN3s2QM5BlO4PcqsWC5v+rro7puZD/+DvUwMVTjGoLIl?=
 =?us-ascii?Q?crR+XDy5p0L4pU3KysRvT+rO9ShzgiAc5whMfTNw6wIC2SKSlGHCIGqLhSqz?=
 =?us-ascii?Q?QFf3JgpqwJ32GJ14RAqfnI1/P7t1yKQSpBU6mZnJ1i4/6NXxHdkKBhvOz3Ps?=
 =?us-ascii?Q?eORt9NBGWMwYSYT3PzokecK+pnhSVuKzlfQPPdDc0S4OKVOdw31csERt/2y4?=
 =?us-ascii?Q?laGKIp+SbrV+OnlRodlRkbaXBPWkKWWS5sSGTfv+9ivmSmih5x3COKsDBPPc?=
 =?us-ascii?Q?tlmCkZiB2MnexJ1yFpqDztR35LFFyBoN4pQhXorSaGmQwqWbxx+t+CzJIFyX?=
 =?us-ascii?Q?wLWpkMUjlQ6jR34YF/gct3Ii2IEYnzD4/BzLtHCV/6BsGr5YTo5FVNOrx7O/?=
 =?us-ascii?Q?wdvPWvSNs0duCc0+2pUI9EhczzcKv9jsflK/jQnaPPuqP6uoO8LW5vlvLafk?=
 =?us-ascii?Q?HEKnxWu1fTv+auxUAFfq3ot7Wb2kOAOthSwxUhCY/m54CtjEGGPyfRylloR9?=
 =?us-ascii?Q?SPH7VIS8gofe1pYYV6NJkWQ+HYFrXxUUXn0Ra683bePdBQRTCHn57jEyApsx?=
 =?us-ascii?Q?GhwGfZAV5mc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0TebvkbNEO2lQxhOCPxVQtFFsRGEaxs1YukgS4C7eo2eVz6Me+qxtaTTu+u0?=
 =?us-ascii?Q?dPtzWecXWkZyEAk5tpgMSQ8+9cnjXj9NxK8TQeNSvfqmQIk4+sggTcjeQc9q?=
 =?us-ascii?Q?lBS/nO2teqHU177kGm6YL6M0nwCgQ+qnu6uj4dcqy8NDjcPc3dtrzquDLObJ?=
 =?us-ascii?Q?OGsGmAAkmPHrop1Hq65siVLXev8NcQDhVllcdm/FW1D4/zF3zkPvnG1s1HcC?=
 =?us-ascii?Q?4/BMtuq15azfqoYhgosarF+rwL9FI5lfIkQfouZeYl4o0vkN+NiC4UsVR+2y?=
 =?us-ascii?Q?W83vsmjlcDlJOziyAEIF1Cg3fcUC7qbo+kaD6jG6yEtrpWOrxbxkUl5dtR8v?=
 =?us-ascii?Q?dtrZb8Lpl73jqEPES1CXGgcFRx4PQfI93mJGrFBaoMf63HtNASIuN+fBIGZU?=
 =?us-ascii?Q?3LaLQTlv6dBI0ckSKzAcMucG6qVTJ/fyeTC5/F5GY2s/OXfjV4PUTChxBFM7?=
 =?us-ascii?Q?JMdIy+2v6wXIfV5rXGjfrQH0BlDQefJenz1jI0xS+F1D7WymKk5ugZQ9GYY+?=
 =?us-ascii?Q?y2L7dcDBteQ4Jtu7yax2kagaV2XXqiDAWLHRKXV6jBltSjb8bRVLHzFgsD24?=
 =?us-ascii?Q?jxWNLRlHuoHx3tB7nMD3hePz2sA1LjQtzH9bvhfMkbX3DI37m0ad7d89zmFN?=
 =?us-ascii?Q?sAva0ebkNOEeGFjmh0aG62Hz37zRfjlTJESl3uoGietigDI5cO1wD0UmEX/I?=
 =?us-ascii?Q?LLnPMOAqq2+pE6bCNFA4u+oja4AJCJxwvtc3XBJ0I1+B0Itt8VLJl7Z4xtbd?=
 =?us-ascii?Q?HW/9v6aP7I/+4H7kl+CYOdQTnH/MLGEHDIv1Uch5gbyDKZAXQfA/oANzKDfK?=
 =?us-ascii?Q?/Q4gnfOHRPgY8eSLo5u6QOCvW4LpmA/QwPkAquLDh29a1O4ZBm6o0QNLHAkQ?=
 =?us-ascii?Q?7J60BB58KxuQWf+0u9LKPZpnMnJ0B2u7un11T5bA8+oQnQpSf/v5B8ds/SLr?=
 =?us-ascii?Q?l/VTuQdvC6jhrAvtA8QsJGfcKlB+3tTRt9ZkqO+d48vctbq8IicOjynmU8HF?=
 =?us-ascii?Q?eRy6CqN/30POrB27agBSgTWB+BO0Jxc33z9/zSNaWdnuSi6VvAOWrkWctlEm?=
 =?us-ascii?Q?nw5KR3e7HBLKUMDxl82ekuysxxjef5I+KOlPjagfeW4d101Tb8vdqq2ER4pv?=
 =?us-ascii?Q?7rWJebismAfWJPZyYfJVZzaN6io9XzKNeVOdHTSCDqCzgl/wcDKupZ61SZhK?=
 =?us-ascii?Q?C5L8Rba2WnxXT1H668dO8n8hG+6V5hXZMuNiPRekculYzGH+WF4nY6N5qw3S?=
 =?us-ascii?Q?605QnLQhiOjzjVAK4UV5v8ig68fwoV5noRX9O0uSz+WzYQMBzuLIUG/mXxeg?=
 =?us-ascii?Q?I4QG1P0U4TyYHYldfQFQ//rlkgFxfwNMAz8wVECYp3MNsFN73dryMM/bmkvq?=
 =?us-ascii?Q?raeiKcAZjenMnL6wOU0AfBime1pkaRS7cERwBavfTiShWKxtGYawOV9GBjFp?=
 =?us-ascii?Q?qcYQS1Q98zWaGw8mNOWAcM6bZtMKN4IqnU/Wo46PgiYW2PoiiV6Uqh2wi6Oh?=
 =?us-ascii?Q?rZc9OEfsywkuDpZsiCJNfXyIDB9vGtjmFa6FJMwK0HmXVCnYnzFVrejo6LuZ?=
 =?us-ascii?Q?pmbNKGmk130Y02qUEAGzGAlcG5ti4uSybThuxyxLlXjo5hu0MW5g7DEBzTK7?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yCG6HpqZWA9CE7/5DD0uSe1ksg4FJKeQGW0r/1Txrx78kBeZI7f9XJgEf4hTqolb+oVq4hkT92VwPtlOY1QQVIrMOAaVgaIh9sJw0JqjragB2GcykMpACkrRORRtVK0fWL+oSLTqE+yNm2baDGqXXusL8E9AXQE+jQJvx57ZMa9v7EMn9CKQjFYPgZpl8MFML2AiGc2CdhoUhRWGTxoCAgvXNOornzFvTZKZUAV7fvNQTOz8TXcMyJOWfejX7XuKwOdEAWJ/cpbXoe93VJorHoVlgpnH70KiOg2D6A4yO0bjB7a13CEUEujI25MbHxKpRzGRBM2iv/eEj63PTgLq1FkESSzY2bGaeaBIFO8IC4bjjbSnGaciRDVsxWRubDNhiDXgPb9jnLDS0lUSFMw3XDyFcM1Uq+CL/+yP0K5vvURuMF1GfuO0yCi+1zho9POwbhwbrLQ9Uck/kLXSy9LdcRivQmmNZgkGb7gQr3FZwXkt0WOB5YsZwaWnJEAjbzOnb4OGyFe/2TZ0i5sH7bxsl6DfkHpibjFZBujOunqahwg1bgFUFwVYcxSch77WokhoatIvHJy/PvdXVMl5Rhz7Eqe2DjNXbsgf08sxjPTZ9Ts=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed0e7a7-1d55-4478-58a4-08ddf6782a87
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:56:52.7264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zspm4O9bJWAKrtgqZCwTmuTauuWjipgh6WBqFGP+WAUBMvYXA3QgJFZOlZjEDIfw68Q57PrHbSOxB57JNvgN5qQZhQxi9xtqFDVUXIsb8Ac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5051
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180051
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX5Z1x5XITqQc0
 tFKuaE1kycRyaQvQuPh9VKh3qCAXUbpj8eQIMoCxHfdzuDnmiQ8xTcSeYHTj+aNVIptpxNRNywp
 zk1babRcaPluLnu1ra6VJJ1sO/oayw+xbnw8/nnvKIMEGVj6s779bt0IfYa5LRie/AE32NA5KPk
 Yeh43WkeXA2fMYdEgRdCEgWKOpipg7Q3bp2VQyfp5Uu2DQN6vN1QNMontnJ5H6CWP5fSz1Adb83
 kZahWxKBdn1CofRh3mtoQ/xF5sY31yZ9wqaUqBbsC9A57QfYedJa0zxNmdj08n0XyvA0FgbdLmy
 KLBa2x19OXgS72/9pcoVL5+djZAw5+dDr6t1UjkxoE1oWMNa+S5V7x6zNHB5nvlxhTGMMsKLm8E
 M7s9WOMqPtFs4mmOwTJC1AJByn9y8A==
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68cb9f2c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=GagKnuOkUNz-WFy8a-AA:9
 a=CjuIK1q_8ugA:10 a=UzISIztuOb4A:10 a=zgiPjhLxNE0A:10 cc=ntf awl=host:13614
X-Proofpoint-GUID: lUSj5dfAsqyZVtq6EF78cPUuMRE1UwVU
X-Proofpoint-ORIG-GUID: lUSj5dfAsqyZVtq6EF78cPUuMRE1UwVU
X-Rspamd-Queue-Id: 7313040005
X-Rspamd-Server: rspam05
X-Stat-Signature: ymnaqxtzju6a9qsrwpha88xs4o9creto
X-Rspam-User: 
X-HE-Tag: 1758175056-873320
X-HE-Meta: U2FsdGVkX18RFSKB/RwYpkvygo+wWA6h03SEOl4nQmTBLSKBckl2/Rn6gvpdFpRFlO3AvhzYilP/q1Yj4J8h+BXfiWqcio6V2oUjMLQiTOCZzRgNcI7RDCZkCDHWyPI5pWmfA6VXiaXN/SHIw6h7CWyR/22WHJTZUwVN3luWaeXAaOIMs2Mj3IpyFl68Mie0rM07pV6LCIOhf043477Oyi6VR5SKowAIvsEmTrR4TXtnMRpm7FV1EOsybNBZ3fAlm0KoCw44sfRB32+rXj6ce/HaBz+qOBrsXRcgtlctqBekt6/2uajrv6OsvNe4pbLmfLU6TIM+rXbfq8GL5tsl1L2x0/k1DKneFnufoivC16PRIuqFKSLbtZv1XhH1enIQf3hHPkJB/+u9JUkQHZMx4d/FUPSryuTqCUocTtDRNjDCfUbryI+R36gtHrWbg6LrvsuBxNJYAMP8ye9FJYSXCB+l/yw5FiVevgRZgDT+q0wtzSJpZnotgfCxaT7cnD6YRleTgJGvZhtgSQAlF0iLKaupkr56+KCIVMg4O87U3MaWj6+SGzxBha80FbHnO/aMkeyPyBIUzV8/s6z0Tq3EnNjviwiZLfopL8XCTFomSvomxW+yQm5rItKrAzTJZl1BASokFh9rqnGqwmzgmOKDPHj2Q1His3TzWrEBAytoTRm5nRiGjTgG+0QbKLgHdkary239JA+iMhHUiqMlgYXWMPRfLwkASj+2BKbTdnlUD0IhO1e1McpB+Dh2HJBVmgTnURI8KjqY2lsllUZNiEoIEjlqHUBFTEykShm5/F8F1fUuvB/fX6uov1k5pRVmCz0fHw/PD+joMKIGj+1EXaFghDJpk+pQZWeeI69TCr8c+spUKbNFOsaj/xGcbE9jsnxPaaCMeALUIGep+5Pthr+PH5OXH15y9MH5J0NAelOIg/cJQZb+bnhx9mYAlt7cHHNMGkZxaqw1o0V178aPGGs
 tLzrn1/X
 4CpuTwkfKuHt15hq1q3c2c+sg1q5N32G7uQ0d1vfxRw6d6FncGGlYasg42/E4lvwOTgSZr+EfH9vjlTczDBbI7A/BzpW8RQuF0jyMP0isuEAA+AZ0GW6SSzcgM58bU8vNHwm8XOujp++vRYDCLtv6rPEdif4lbTmrS+krEuA5m+MjM4qkn87OP1HE4C/GxiAGIVJOoeKCoBN4P8WjIs8Uc0WJ0lvibqrDA440tOpOd/MdaPHECV+uae2jad4bw3qSD9dnl7PRMPjRNt9+LhqVJ96fmgwjdeuqYUxB6xWVWwwjWsspo6kLVp0McbCRh8E2AlTlNvlKBw4DRIp3PLTObVPdDz1F7bhilKgkEgCWKGIckzgOnBsuNyfMsmeqg8gZvHe9crCO12v8mVEAMvULwEGzeo+zE4Xx8bM2Cx/qkJhsuBL61TeBeK0k5JP43xtSHo+l8TnA2Se/Ag+yntBUaj77HsVcBCQ8BN41Cm8XLO3W7CBYF3R57PhNgmF70CohEca3Ic/W+PvtUPeLKwKUBDGiEVwRj0HiVJ7ugSr5w3qZYLuqqpCbySUc6r6poUsDUwTvBpQDCQaBBJjFhhVd7OzOIb6Vkmjt51/VOUuciyU2r6Yuujn7y2N+SexhsRK859da4u1Gs43JiFF/QeqHSkn6pP7U9lHKVG9m6XHXkf5l4gimuiCDauYCbHKffov73ztHfkhRU0uQof+9BhqDnxz0S0tA+ZsZpdyD0BkkQndxLHuF/+ogP3z7unp+07BPUw3UmxQZHs8AbqERvGNLFqcPLHPLklUq6LZglJNVqyh+OlaRq76yLSv6A9LQqacaB+3rcwhqJP9xpFFnANQlVqPrjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 04:40:37PM -0700, Andrew Morton wrote:
> On Wed, 17 Sep 2025 06:16:37 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > Hi Andrew,
> >
> > Please apply the below fixpatch to account for an accidentally inverted check.
> >
> > Thanks, Lorenzo
>
> The fixee is now in mm-stable so I turned this into a standalone thing.
>
> (hate having to do it this way!  A place where git requirements simply
> don't match the workflow)

Oops, sorry :)

Thanks for fixing up!

Cheers, Lorenzo

