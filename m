Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4891FCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39E890000B; Tue, 12 Aug 2025 13:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEAA98E0168; Tue, 12 Aug 2025 13:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C641490000B; Tue, 12 Aug 2025 13:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B48DD8E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:19:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C2DBB5FE4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:19:47 +0000 (UTC)
X-FDA: 83768767614.11.9DDEBE2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id DDABC1C0003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:19:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FJV51Y6v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SZ5h2y5w;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755019184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+4mhg4C4rImFuY8ZLy4yjAeFPFcyeoRvfVNlmR3jpg=;
	b=oM31lHj2WbeWW9a64FfmxxQBtuVM7ys628wMZxXwsjpq20SY49bWi1lo8PRNXv5a40K87+
	qGztKNpwT+yTARWqlG3v5Ixv98KGZGMqTA5GT4F0++aew3UkLQdvlDAJzhmPt5p8K7678j
	Zyc3GJSIM1CbNqng/q4MpE3IbMKHeu8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FJV51Y6v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SZ5h2y5w;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755019184; a=rsa-sha256;
	cv=pass;
	b=F5Vj9W12SAJz457juaLL8XkZxnPtx58BcSnIWfED5yahag3mZFUjYZ3dQBqefwEXkQsrob
	cY6iAUigUgkMe+ns9mkc0LnvLlNcIY3fLlip+GZV5HQHNXTgpVpJo78NqbKkbwbvQ8yFEM
	V2pROe9YYLqbKsL174G/7LH07JEiOF8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CDBww1025277;
	Tue, 12 Aug 2025 17:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=s+4mhg4C4rImFuY8ZL
	y4yjAeFPFcyeoRvfVNlmR3jpg=; b=FJV51Y6vumKqwtRE0M46J/xNcxMkgrK7bP
	H7JAiGfFWu2jUHJKBtUq0h7v7mcgRQ4pqas2i02nzGkCBlWZRVZSD4AHCxviABZQ
	JQVL1UdOoSPe962xtPIAYqY4JzsMcYW1SfGbOLWsCF2xU9HWLke+HK+TBBWXzNHW
	ryByY+F/Nm/Iq0ongrL54MMBKZB2mF5sp4B+snhCmuflD4zH5/T91K/kIpEfzA/u
	NmlAxO9BlC0k9jmBOPkZFWijLaWDUzpuKq2xDAhm0QwBc8roEjWkjoth0Bv8bPrP
	qQq2StIRN93zWD5etPchpYzNMh155+nIA8q7aNy3fFjvX/kYxE1Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv56qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 17:19:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57CG5v6P038569;
	Tue, 12 Aug 2025 17:19:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsgt15s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 17:19:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sWa7VrPjwI25LTFDZ8YrNJuKttPpfKLPfapIpbNK6tlcVtkmWykcTUztRGTBQSZn51MaNVNIWxDO4eOdBjznt95qVLFWorqcwsUlnTykraAlZzygpPdJKy5QOW/chw41JMdyDxTz+vztIKyaR0zvAXVlsjUv/ZvlKraJbOfG9Q3/0nsSdtsNTfjnk5SK9XhQmx5xgbpD3dMzSmA+2qUjTgiTLzxCUI+oAgR8INMyWmuDt12LwvaJIN1uOj6j8QE7jd1Y6KCqbE4uwmU+0TeUWw1m3HP2IRPC15Yv58a5KiFyWjQCF3q0fbAojaQNrW89rzYTBCnPx4aBrOC8gROMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s+4mhg4C4rImFuY8ZLy4yjAeFPFcyeoRvfVNlmR3jpg=;
 b=ORsTtU3+AUuW595WXTslCyzXL/RAF2HfT+cO+D99yFRh50pJ8xRsll5Vit9WAaNpPGsZuMWQh0CA1MzFn52ExB5yjKZpTa20QUuXoKzHBfmUG9tidbE+jbBpEZfY//4Ftwut7+VzXLPHyeyBDYZMXbCrVSRzYESj99FGntZuOwfoA3BCK1npPHRb+/ow/fV7SydhZBUppCxrEinZhoQTofmt1LJPHSO+NcP4LnjiNy16Vd3ugSR8wc/NW/r8yWz3afg+BhkraJm3UP1CJb44hzWJTcAFkxUXMhTK11rJ6dLiLD8JddA7A5WH9tCSHVT8mwW5N746pGIQ1GnWZNg1MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+4mhg4C4rImFuY8ZLy4yjAeFPFcyeoRvfVNlmR3jpg=;
 b=SZ5h2y5wdSztcFXLgklngvyekWFdl0RgMrPeqcWOWKEXwc1obYgIOG9LXYrMhFOaXwtIMHn7slOOZ5b0X8mR0peWm75trOH2fjJRjF6yCia0O1cmuZJoyxh0vuCHkZA9nS4D2Pdes15yi02/NZR1QAtpsMFnoGC+Aawcbz+BEOA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB5811.namprd10.prod.outlook.com (2603:10b6:303:18d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Tue, 12 Aug
 2025 17:19:13 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 17:19:13 +0000
Date: Tue, 12 Aug 2025 13:19:03 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
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
Subject: Re: [PATCH 04/10] mm: convert arch-specific code to mm_flags_*()
 accessors
Message-ID: <ezqmtpemhgbotdpsroeiqlgpxyc6lcwcuwzyodxc5bx55fgjyw@67dfjowi7xg2>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	"David S . Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H . Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <6e0a4563fcade8678d0fc99859b3998d4354e82f.1755012943.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0a4563fcade8678d0fc99859b3998d4354e82f.1755012943.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0227.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d7011fe-6872-4a75-12ea-08ddd9c45bd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ykgu9ni03qvnREiYP2At6F46C1WIIANraoTZSpfQkqQsdJFJGcXzcXvs/EvU?=
 =?us-ascii?Q?3nQGy8aWAt4rO0RMY7OpqL+Pb/Tludqov8m+OyCVQIqNg8IleYmmajvdwSjJ?=
 =?us-ascii?Q?AdXPbsGYbD/WaHsj9c667V0N1Q+h5tm0AnswLP8Adl//2v1plikE8bRFkndY?=
 =?us-ascii?Q?dHFM+Zolx0JaYCcXEX/NVFJ+MyZQVJn51Yyd3XxOUzXm43witXlHKRLSrPAR?=
 =?us-ascii?Q?Fs8FXQ4NPzJfOVqffLt6r+EnnYFFQvUSUHc0EdjQNWyIvnXkgp9QjvkBYRix?=
 =?us-ascii?Q?3xt+7x8QsOPUKtfb3VOR9rMkFv/Bxpy4bZT1expr+V6PDCVb8Jj+blmFz5lQ?=
 =?us-ascii?Q?qAA6qEHziELq9Dbb0mXsWhlC3CUAAcohG5ftb1jrYbHQZErXn7Qy/pwXwUml?=
 =?us-ascii?Q?vZsliMayhTRGe6K0mColLVaxNvDC05NdyhksBi0v/me7XMpksGeVZEFfcqNg?=
 =?us-ascii?Q?jeHGGvmluskEto/1j4Q1BSW3pvGhJ2yY1GIqQpPTyTQf/hC4Sk2aNNeK7wET?=
 =?us-ascii?Q?ssnf3JumaSUs9mC/HSVuX+9VB/ak8LNgQTtP83HMD3IRFNRjpRoMSeEOtpnL?=
 =?us-ascii?Q?jcNVxn2ZqOCfNnyDocdoTFtw8mO4IsdgpJQG2wH2v28MhFy1sBHl+VTJk4nR?=
 =?us-ascii?Q?vrDfXxWVB1WNFsNGZuDauZpffB6rBX+K+8y5r7uoJJtVU99vikLpjPCF4ZQL?=
 =?us-ascii?Q?gOyGV3Aupd8li3TrU6RGtZHGGGndNsgvTObqyzXC/MtV11FR2wZ1iS0ghYG4?=
 =?us-ascii?Q?qinP4cv7cFRIABaKcyUm2hoPgZYw9DwH0HFyKv6I3SdUl5PkOoQrAtcyZ6qR?=
 =?us-ascii?Q?TyjubHwdVMuM+vuvgoUML43tqcBFsTrU4cBzkxDwxizTK/iNRpkIYtqLk/+W?=
 =?us-ascii?Q?gO1q/VNxdVzBa2VuD3i0jbvWCk+cRxsJHaS29K+UY15uedhcvVszkENuC+G4?=
 =?us-ascii?Q?atS1IRhLpDPyUGHAbWuQfQS90GBYzQzdQuwEYR/tEbqZU2pXIg7qvY/0A4Kq?=
 =?us-ascii?Q?rdWmm9i1+9G9pde1rnWSOOTHgHvU2KePuuWNixjVGrSrusNamSPXKFVGTvfY?=
 =?us-ascii?Q?FMALNmJImz2n43sNmNrKpWdhu3xeiP1Yaaf8DX2avNuIbyWtulCJegYMlGV1?=
 =?us-ascii?Q?jVS5FQRBjRrQIi5dmBRycEitl8XnmxddkzF79xUVhZ514TJahl1NSRUfXC7l?=
 =?us-ascii?Q?PA4RIdoH+PY5d6Muxti1H75U+MhtVJWeiiRXhps59z126u/evhvLysfsK3Z3?=
 =?us-ascii?Q?UVR5B5Iuyv6rYJAFHPPnLIsaFDw5FR4qQbdm+OBp+Gt63eP2dJ1Bw8QKW01o?=
 =?us-ascii?Q?3Cbks2KYylXMyLzCJ+MgG9sHGizycV9b7A6hdNsryse1u8PIlI4lnElO41w3?=
 =?us-ascii?Q?1aM/GCOiheWdDaPqJA0aDHYNFTd43xv5Vsp4R7AdH/QWoBuXyn0vG7bn1NBb?=
 =?us-ascii?Q?4pFJv+A+Gms=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OD9pHfqNKMmX8NrotP/wYqYSEFQ4hr6d8DhxZg+1CmuPWjHKhV8DgX5FrqIU?=
 =?us-ascii?Q?uj/qbnZWJHZg6+EvDKyhcfANgFNGsVga/vEH3e+zJ3AmfSfd0iAcMLiLFnE3?=
 =?us-ascii?Q?fvS/DB/IQUNIBF+O6Hy3Xa2r2fm0gthqj27n918Aq1I+P8UJc895EEI0XB6l?=
 =?us-ascii?Q?1rtO5ekSzGv1ghWeyMs+SGQF46ixh71AEgV9prxm5uUbpyhqsvdDdlqa9NVA?=
 =?us-ascii?Q?KhW0wrznD0jdsjBK7svw195s7kGeb4WZCoGbRveAEU1JDav9adSD+glQRddj?=
 =?us-ascii?Q?Yq/syzCJ1ySyW5HPteXoIX/3fQfzMikV59rEnOSNYacTXwm6zQdTciJYcOG9?=
 =?us-ascii?Q?Eeq0KnuvqCyIHMomkp+j+4yQz8WicBQ8xatBBnRq7Lntc7zcSTNT8c8Zcmtx?=
 =?us-ascii?Q?jWIM6CYuU66nTIZrTZG1myxuB/lFtUYFG0mB2Ot1VRBE0/EyKmGQ4JQ9r/ds?=
 =?us-ascii?Q?7cwQheXthMEJAcT+EqlztX4hOTj6DfUI2Jzc2Fx4d0+79n4c6acA29mJSUjA?=
 =?us-ascii?Q?vgZ+ALsLl1iXhAzkuiruoHwGfzqVWD/taNzc14ZneGfmDGWI1G5W7WbvbDCY?=
 =?us-ascii?Q?EBJdvbKg8fOVEwI2ozczJ1HjY8EcZ2DpsvVKs6AawbI3H5QenrdMxaQjWfV6?=
 =?us-ascii?Q?uNtDsbPRLE+byK1aO/jtTwYHSBA70AVOreQILXZ3un/WKe9FSya/U391UYbP?=
 =?us-ascii?Q?dfkB52B1/cl38SVBqghkxyPf9wIR4V2Y07qKKQtN7W8RhYLPG+A8Laci//8J?=
 =?us-ascii?Q?zm1NZRHQE1kdivV93+X6TOc28ogOMpRhiRF3/sUa9peLadKaE08AIIGkSgIX?=
 =?us-ascii?Q?J5+ZqvAjYWqPLfkLPR2awdaf8C6EWlrxn/9m7lbrncrtSUu2gMKYCqzqXvMi?=
 =?us-ascii?Q?07Bl3DytJnzto6ogcYG2SCn867xv8HEM5ZpFTd4/TqRYz18FLt4tcxnjiEtl?=
 =?us-ascii?Q?Bq16yN8rY7wr00vndC9mo1p/sPYCZ/vT/a6knkSPfBgm53ZjKOsA8d0Cs4DH?=
 =?us-ascii?Q?JBsRgU37dscef8TKG+Zm7uNjXXj2e8JdJB1qc/9KUD3ESNx/Xd+Cr5+eVaul?=
 =?us-ascii?Q?dgFpuF4ZAIVkOkBjAqmwAj0Gp0zmF7C0MDBKHYtp36p4wBO/d5y338AvsuCo?=
 =?us-ascii?Q?GmkOHbDLriA3oqSWYckBIIW9A/rxjozoma/J4hI/WFvN6m+47zCrqjEP/DzZ?=
 =?us-ascii?Q?gcDmhiBWiqnm9nJISk+wIbvN6gE/XKGD2gDfluvfgzshC3pZ+HquJcUn/FyK?=
 =?us-ascii?Q?g3nCrjMl2aZFI2IdDLips3+Gp8DgZuVq4LeXKY/BVAXKoC5in0Vw2IGn/sgI?=
 =?us-ascii?Q?BQjnWfEUszm4+Oz01S2Ljzykd/pgTNpPomHCIj8MdHMGTfBVgE63xg6PJj9r?=
 =?us-ascii?Q?GkIOmt6a2/+FKWBRV1W5Y0g7PcIJbI1bCiJF+H5aAcJf+xox93xYpvPgmp18?=
 =?us-ascii?Q?sU5Ab4gtZY/lR9a/295dYByTQR4XkVKrq7XFy3kSsczbLi8yZ+WYlPhf/NIt?=
 =?us-ascii?Q?QvpWHkePOeKgMdIWzjAuIblU234gDTE4GDYJKCaycAcH6l4Ibto/J62ENbr6?=
 =?us-ascii?Q?NJOXnLWd4I/tYFJW74G/Mq5FyM4o1FfnpvgEQ6ns?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BL0Dghz7iBP9CdMiswCYOiKvn75kkvdGQ1Cqqyr3xNqedudKOJKhmqS+QGlPKwvGA8Z+sjpc9Q5Wzmg8r6Uz6mJIUlnC9UVUQbh3jJTfQzgBojMreu3jg65pcsVhoVHGnMkx43rdpf/XkXlbjckJkWawZuz3OCsgQLFdbpLpnKHhWoyTUCzsoT0AApeaoCF35mkvirhtTUgJJ9ZJ+IdWZfl6yIrcABB1NMl9jYLI+OiJKNCt+kwwq93KvD+vt9r2MspjiIqUwl6HF9HLG+EiYrUyCvxUGojECrzZQIl4zpm7/qDd03Mp2j0tdwzDs42JwrI/wCkrBwzRq2BlTwaU5MSQqOjTKVcG0NgmEWKNPMOElqAhhOboJnGENxcfxzsMRNL3LS+raJYrrg9efO7Q6jPah6V7aOMzPc6ovL5yZJDrmf2S3fyQEZCYTQAPQKgrTyMnOMZ5OQW+Lf/6EOoWxocqRIDeMqov0h8sNa7nRcj0/AURp6imV4JnJW0Az619S7VVdJdjJ8sXwgxksf5S7D+WsOTyLtbADxx04U0XanYT42yLMrR3sshpfo4NVI5ylUteXlBHrDTG2woomKAAdcrOtX8NIt41uU6vJjQu9Ws=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7011fe-6872-4a75-12ea-08ddd9c45bd5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 17:19:13.5563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymgIwKouTZC5iv9PVfy1HMI64PbofM13RnR9u59RyGhSbXoqIvWCq6X5xFYt/0ddyePgqoRuNDQTzMRbfNi2Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5811
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_07,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508120166
X-Proofpoint-GUID: kAxtPXBNhwseAsmDHKXXGTkRrV1S6fk7
X-Proofpoint-ORIG-GUID: kAxtPXBNhwseAsmDHKXXGTkRrV1S6fk7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDE2NSBTYWx0ZWRfXy5fjPFN41HPp
 EavVqtc9ZjSvLz0kshcWpm9aDMHTYDcAs1lEpw8N93NIKv+cUkcYeb232bp+yJzvXEhNGOYS8T0
 PJIqXYU+5n/hhH932Y8yy5LmKvXQMRvP3972MUPXLsIxyIayTnD2hnLTxnZ76v4qTMC3nCQmYTu
 yXBNwcKw8F/ot1XWNxwX6G1LBRMgVpnh5smaRIbPPnpnCQo9L1ssp0xkGoWftM0+RmMrdEF9Wif
 TkdLXv39FTIBdhJAXv+aYGqUymKp9m81oYNhix0ECsn1sHsfPETQf8X9X8SfrOGoqzGPHQJpan6
 17lNSZeFc23n0SFTSOrFpDY0yfTfjqly0yW+jbzOIqbJ9vAuaQyYYT5k6JkuA5ldOwySbzQwd4k
 PZZ7FCpZeILB/XhFDoEiptSgm6QsScEgdgPNIXnMP3WXAY/umq7dWQ10mylAP/Yv73OE4GP3
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=689b7796 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=3uKtmellvlGSMoExo4sA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Stat-Signature: p5tigbdaiztncz4way3wo4eguuujtr98
X-Rspam-User: 
X-Rspamd-Queue-Id: DDABC1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755019183-25686
X-HE-Meta: U2FsdGVkX195XPIejCKY0R0Q7yMyzjO96hVEx/pQ8pWRgnd01uBIiuIa5D8jP4XpjwcTN7dEjvI+chBsO71OzaDHUJIlI7FMH7jvjn3YaKphc2bNluxyHQVztWyLsN8MLgvi5nrM+7MLdWoz8bLahWpD1xAK5ikxMhTFsughPmefGLQgSHnKhIhFFPDRZmfNBE3OIsnXRCXqvgnYcnXGvjUbzMVFS5P78D3+TjNJC4K8Zy1z8YLgOeyU6a33HNj1ByYshxqnOc6eGMOdlJ/IRDgmstMHxtKrD3cVRokrkvq93I7rs+x8J/RwVCQOIQ3UmEY+gBR+OPwt5mSC+z0TvmDtLLMcfAWSJm+tS36inX0r++ljQr6sirjCXbz0W4zJN1utwY02rvsDseFa7JmN5Jr3yBEjHgU8C8EjHKjjnu39vJSqGrTlQ2lB5e0106aAX6tgIYL7xeVXjW5V9jmh8HItyzLkq9qy9ASFvANCq24tasVwPBHorQreN0nrPcn+MJEkob8YqYqTcxNwCPMlv1/Jr7ekd1xRsaGAk0OmLQDPaXfApE9zsh/0ccfM8yIQCjB19Gk4E2W6OVSRJ8zXKwXkrThTHND7aaTK3l/eYIn4bUBliYNwp5WrsRbhZXq4FBQwZLU/H10JCxVO63Mj1/65/oVqu7fhlDFhS825dVXetfFJxdxxwkdO4P3g+AZip3izygQsFBAFX1wMoEmpg1hr9rX668QJD/IAp5m5/A39PO3+Et9fFWRyvPqSVLCsZxlS6APR/fFMbC/gNZJK+zWfYzCd7ExygiMzjepkyiklKEzREE4Pz0ytOk62/H13/k2L0oCxy5VN3iBHXAR/s+nxYfczXy7ezIZPGU+ubRGxDGvucunePX/sQIsEq8m03PoJ7wWvZc7XS0U782RxnUVkpP6rpLx6tHFrGRORPdFLRidgo2gGSaMWeqx3929Rse6MxEtLLEsjusRrnMG
 YBDMFYf9
 +Z/XCVJ7z9jOG9wOICpfTzE5GYMWpLY59khJYkPoN9Xgrfk+keTqDOe3FQDBQuXWkrSU89ItVdZl1KgloyMZQ2Zcd7ATg8by2liybsc1Xbu6yjCGrWfLU1NrmHoWId05z17B3nO1lNA+rLbnyCl9rfknP1k98bY9O/RycpniXndo5DxfH2K/nmz6qNhXF12REYn1CIWBoW8/0+ziI9a8q+c5skCnXwj3QDldSkLHPG7Gf69I1gaZnALbu3PeSXEHPuGDZ9PZCMtG7ulLqZTgl3UYCGUMZJyAB7eRdDxqNER1JCXj1vzMO/L7Xs5xVYeb9ko9CD5jhzaIhR0yyPlErXxWKicYWgRXiDWi64FwTsnwUjZg3hlTIZPPinab7jfIWxekpWWyjIREr+wi+QDNWNcwqACSJy4vewo/iX697b04m7Xn423Zy6qAiEwpjyabraO6FO7cHp5w1/PsK6vyr2e9V18Qrj89+/M7pjiZre6j24vg2EG86T7tf4qIOA++HOQaLO2Gokogp6l5YoElj7X4AVF0kTdQFT/yK7moTCbb9Kir/OC8QZznCJzq91hAhNGR0KSDjG4V40EXwZ2u1Iq6Wl1hiNB45CZsu9YYkEp07B82zW+C6hz30GzlGRvpJS/sB2GONfThUWyysoC+iHjGCIIkEBRZOzjCW8h8QXWsUKE4Bb23WfK+7FhTrlbtoI2gGOT8CxOXYrRDkSKVPNyzj+Au4IB2a304C8S7I2ChADEOsVNuYY9C045GFubwccwvdYT3mwv5dtscPtIg0XT0HmbHTWP+orWqqcC7TUtT+AW/ANDMW22sNOhexkrfLlNrmCYdJSATyrRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250812 11:47]:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  arch/s390/mm/mmap.c              | 4 ++--
>  arch/sparc/kernel/sys_sparc_64.c | 4 ++--
>  arch/x86/mm/mmap.c               | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
> index 40a526d28184..c884b580eb5e 100644
> --- a/arch/s390/mm/mmap.c
> +++ b/arch/s390/mm/mmap.c
> @@ -182,10 +182,10 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>  	 */
>  	if (mmap_is_legacy(rlim_stack)) {
>  		mm->mmap_base = mmap_base_legacy(random_factor);
> -		clear_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_clear(MMF_TOPDOWN, mm);
>  	} else {
>  		mm->mmap_base = mmap_base(random_factor, rlim_stack);
> -		set_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flag_set(MMF_TOPDOWN, mm);
>  	}
>  }
>  
> diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
> index c5a284df7b41..785e9909340f 100644
> --- a/arch/sparc/kernel/sys_sparc_64.c
> +++ b/arch/sparc/kernel/sys_sparc_64.c
> @@ -309,7 +309,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>  	    gap == RLIM_INFINITY ||
>  	    sysctl_legacy_va_layout) {
>  		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
> -		clear_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_clear(MMF_TOPDOWN, mm);
>  	} else {
>  		/* We know it's 32-bit */
>  		unsigned long task_size = STACK_TOP32;
> @@ -320,7 +320,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>  			gap = (task_size / 6 * 5);
>  
>  		mm->mmap_base = PAGE_ALIGN(task_size - gap - random_factor);
> -		set_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_set(MMF_TOPDOWN, mm);
>  	}
>  }
>  
> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> index 5ed2109211da..708f85dc9380 100644
> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
> @@ -122,9 +122,9 @@ static void arch_pick_mmap_base(unsigned long *base, unsigned long *legacy_base,
>  void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
>  {
>  	if (mmap_is_legacy())
> -		clear_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_clear(MMF_TOPDOWN, mm);
>  	else
> -		set_bit(MMF_TOPDOWN, &mm->flags);
> +		mm_flags_set(MMF_TOPDOWN, mm);
>  
>  	arch_pick_mmap_base(&mm->mmap_base, &mm->mmap_legacy_base,
>  			arch_rnd(mmap64_rnd_bits), task_size_64bit(0),
> -- 
> 2.50.1
> 

