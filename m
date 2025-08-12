Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B08CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 15:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1EF8E0154; Tue, 12 Aug 2025 11:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAE88E00B0; Tue, 12 Aug 2025 11:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80C68E0154; Tue, 12 Aug 2025 11:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3E428E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:47:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7933D1DB8CD
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:47:59 +0000 (UTC)
X-FDA: 83768536278.02.72F9065
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 00EC840018
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:47:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RA4RA8Xz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="zW/Ue0YC";
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755013676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBhLiraoB2T2DKQeMEXAqouspW3wBSInMRRtPVdA47o=;
	b=x9ysi4s1lLrJ92gVb0c5SYgIthAde5TYmCe0o9SAodaseOFV17RAnnLrvMB2AGnOMp4+ig
	JlhABIrdVVV10AeFC1MtKMZh3pIsJhs0wvFyO1gZQFh/fWFQHIsrm1pa8y+NCva9L2XFwx
	YYCSGsLRu2h5T6UYLj01hG2h4daqbkk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RA4RA8Xz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="zW/Ue0YC";
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755013676; a=rsa-sha256;
	cv=pass;
	b=aMJMvdcRVSDyNssfUmDwlxoufEuiZrMxEUDx0ifblEyQ39vH6//PlRUsc2fHnOzbixuQUd
	bd0w2pVCFpmHasmd+5F2W8xt8PnYlvuCA/dVQrudrzNJGVLujUqfq68mxismzQ61ud5v6M
	VTWgh3YUahIjtm3GZDrytbsrvSDYpG4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CDC09Y015993;
	Tue, 12 Aug 2025 15:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RBhLiraoB2T2DKQeMEXAqouspW3wBSInMRRtPVdA47o=; b=
	RA4RA8Xz1DPmDro2SbUpz5hbfJS03bDfzLvi0tcszzvrpGEhsc1Kv9S/QyyNYyRC
	CM9M0Zk/sp2PpC/EttF+KUqU1yLkKmPTVaN7CDHfkmUT4z7G3pSokLAWsrvIG2id
	RiBTWQvybJYfAAQNAqr9iOOsWksbUjNVotXXwr/5oX7qYFERmj/aWIODVEdko/Hf
	bKsgpShwpkbD/6TBdsmWgtIpoQJHYpE6hrHgIAihsBv7YQpYQMEVlmy/BAD6rNjd
	sAnejYGU5ZRYn8ZUIvruLT7uhfUksLa+Rws2TF2xIsy2ZRKwI4escgk4U8uZPk9i
	Vtm9/OZDCiUNyLnXGV4Uzg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcf53kt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 15:47:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57CEfKQF032734;
	Tue, 12 Aug 2025 15:47:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsa54g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Aug 2025 15:47:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vGWrssWz9zJZjOlgb2cNWSXdiaVl6XpyN58QvQd+FkSRiStnv/X1qlxwsTA2o2DszBZTHgXbTRfhKjLrswzsg8tg5x5+i5kRX1SbaMyzqrB+doxQhm9Rot0VRl1JZ6SNbhB8KrmRaQM6QnVOvaDIcZlbvzSeENOOjCmRX/5Wa4ZW4a3m0630G8bmb0yEYUYlN3q529dAqb688fPQ9iF2XioujlBaaCnuFPtAKdxPJQC9eNAnnSckEPnjlPFfNH/Xk0QoAnpGNzYAlvGXmFuX7VIcvYv5O5mAC6qnNCwRhifaODoBQjNZmgI8eTwRuaXP6EEhyG2igDrM1UC3OY7xHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBhLiraoB2T2DKQeMEXAqouspW3wBSInMRRtPVdA47o=;
 b=cc2JmCX82IOH0qfjHu+u4vgJb7/DyQFyCui21eBWD8SGI1K07MEDXNEUIv5gPguGn375bmBQ7iAylqdo/L/Rzn/cXE/KjeVU3MD7yPm3evfj/U1BwqHhh4XLYF3Y6mf0in+M4rldFCMdHokWziqE5ZU+VmWifDb/DmUQQkPsVY9unSbBFT5miObCa8AXkHjsi6Q7MNnDzgWz39AQSEdPIjF1SRAFusJSwZDecWEFP5JW5VxDp5Yh5z9/YwfamkbEovWSNoZYn60rME/jUih6h8lhEkBZk16EJhruhuBOJ0v8iEqEb+IP4C11SkNeG+LVrhCpPgL95YRLFh5R+pcwlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBhLiraoB2T2DKQeMEXAqouspW3wBSInMRRtPVdA47o=;
 b=zW/Ue0YCSFZ/idbXnp6sFYe9J1b0BGwEjJbqVya9P5rIpznp780hXYXF+xyPdjD2rEv/kpnJpN0Ob0+0eq/onPzr5XjlwKEGMK4dOk9dCPqudfqxDg0xh+jCHlkHwGwzHl6Gi0lGhcF2Bj0eDGKltPHhfJsu080L/8lCtmk51sU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6329.namprd10.prod.outlook.com (2603:10b6:806:273::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 15:47:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 15:47:28 +0000
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
Subject: [PATCH 01/10] mm: add bitmap mm->flags field
Date: Tue, 12 Aug 2025 16:44:10 +0100
Message-ID: <9de8dfd9de8c95cd31622d6e52051ba0d1848f5a.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV2PEPF00003827.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:5:0:6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c2eac0d-42e1-4809-6e7e-08ddd9b78a7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6QIgemlIVx1AG6WbCyOTXd5FNiyqhSSpuGFE8+evn8LKeV6D1ICnrzVkSdwk?=
 =?us-ascii?Q?WkmC4ByS2c26rlJMtFTxkwICSai2fWz0gT1uuSsvmBg2NXq0oRcy5gg6xiO9?=
 =?us-ascii?Q?lRRcsxTy1JqWPBGBOAyVbWTLlylzIxaGbC3iUEpPPMIH0Z+tPmyjmHTHFaHF?=
 =?us-ascii?Q?2LO0Ev4BWAGcGOd9mLmr9LtAeN26ugappBF4BhMBwADJ0pCdXA6zWUXvGKQ/?=
 =?us-ascii?Q?Cfl9TKyoUhN8Yu7M8+QDyZLTm33TGCuzMd1JCX1TVtr0kDru/acX0sjdZPtb?=
 =?us-ascii?Q?zRumoB2fML2CWS1J7dbtPO2E9DxkAdg5rHUjyRIIfqa2o+ZI+SV3acVH6hfm?=
 =?us-ascii?Q?LDBSe1WMSKUJn0VERiDlYnYYi3RV7R58bfhIYU9vRrF2nrGFih8u90hStfsr?=
 =?us-ascii?Q?Plxm5HZ8mVVeBIAiUGAdd7uMNxD1WZWdOXe0mX5XGqFAObxs8PjcCF3lcPua?=
 =?us-ascii?Q?AgMYbA7KleRE+M0Jmw2lDDffY6apyjs3hgva/wHVZkkRUaio7Hr6mnDDhMCR?=
 =?us-ascii?Q?uWySTcq7jkm8/Jer0dz8l8/KIAEyj/9ozqZHbAA+Yt0uiQeOX3Q/IS47niZS?=
 =?us-ascii?Q?mdgy4D5TtYObNHy73+MzmU2LbrISeYHcdxZs35UEkQFGjM0dQgQXEZYZp0r9?=
 =?us-ascii?Q?IkrA2GX8Vm/+vcpQmaOyDGS6ujOiJbVQZnflOhE/0cQ3x/L1Dgdnn3Z/w+AT?=
 =?us-ascii?Q?Ngtw+NMzGLHNy4449K0gXZnIoDUA6T30B+7JmxAIpPsRWE0S/wAJq7BLxkgv?=
 =?us-ascii?Q?/Fv2PZgGr1CCUtbb3BP7Dg/xdsqYNs5CNKatIgGZ1VXz2r5HVHK23aadPiGs?=
 =?us-ascii?Q?P0fgmMHQsWWt1pn7JbuwScn8YuRzl/mhiqqZENXE9MGLPaaf18xKGQQRBrap?=
 =?us-ascii?Q?2Yg75UG870DllGJz/3LsTEr6+2Ii8yIeATmLL3ZPT7zaYcZA2Rtozoy7PZRh?=
 =?us-ascii?Q?SEUgEuo8knGXHaoqNUl2+mS8JMsN3/WVX0ayg47SyQ9anr6mmXZ0sEyL8fPx?=
 =?us-ascii?Q?o/clM/d5vJToeaxa/cNJUDoSMaH7m+SNdLugRu9MVYovdtPq+t9CuML8XLd5?=
 =?us-ascii?Q?j5x0racxVTnJzjsgYvinsX2jEWLoo3hSD3QIn8ObAVoCy4cF0yQ8P8TThHn8?=
 =?us-ascii?Q?jEzFagAgr6YUVLEbeB3JxoZe7W0tIxw6Uqm8nK95Z5GqLaeBuT3pzlq6fDDV?=
 =?us-ascii?Q?yjlY8HPwqOJMhmexDOxuCJMcWqBNnAGrhvCW5d49kroX/SuwDKPyWWh4vg8P?=
 =?us-ascii?Q?WnuXicH7hKMFjKHJICy/B3Q+n2fBlKqdehN3CsTq+6R4w/cOEUuXWG3dV9dI?=
 =?us-ascii?Q?9DFjmE8qoQeaQZv+PqMCmJSQQEcw4GGaS9sczf9kG0k+BcplCdZZsabvc/RJ?=
 =?us-ascii?Q?KzVs3h6kGkT20ZCvXIX7QzGZA2N1hU0eGqhk0bd65mqb3CpockMoq0M/8HzV?=
 =?us-ascii?Q?8F58ekLbWko=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D5qn/y64FjlL1umbiXCu12RGMJJuj/ZzHtBFyJnfRcOSTcvKYNrUITOUkTub?=
 =?us-ascii?Q?Dx9kcDsLQmUd7TchbrM11DSloEiezYLOYQtIOgbxpgE0a8GqPtWYi7uf4rqF?=
 =?us-ascii?Q?XxYKRs8jy88FIDV2361GVhG9EZvo0e6STNt+eWEyagTCc0C8e07Q7ty6+RgJ?=
 =?us-ascii?Q?V8sdBUPguwmVPLDPRS3Sf1LewjMdOjPU5Ig1Pe4P4nVlla2abvTqwAJJaPim?=
 =?us-ascii?Q?UDl9rpq2JDEAWTDOtMHrjAkwUo76hNzT8Zg2stfUby3J1AZKUf3IDwBchQEX?=
 =?us-ascii?Q?xfQCXppEUrEPlHTrYuux2FYtM/k2kXj02QllWUcAv62i+5Gqje+70E4z8tp0?=
 =?us-ascii?Q?PAnIhK8gcPi7D/Q7sJoKhoDBkM31UTUn15F4r9vQ2pLH0vw9jtxZfjNHbUbe?=
 =?us-ascii?Q?Q3+aDkToeJfdhqIyKHH93O/eO/VeEUlmu59s5z5QJ1wNUGexkuoqc123Dq2F?=
 =?us-ascii?Q?PvNVodZu13Igdj5+LR149dRO30XkeCYyQZ8hg1zweAnMqi5s22cYLivTUKOF?=
 =?us-ascii?Q?YGSOQJhTYaTQeM7FbLxKn62oGqvVaq6ujIe7te7hOcesZHknsaUsmXEY4Lo/?=
 =?us-ascii?Q?bUA3QRSZDYFGTxR5MAcc6Bm5sgeDMsjqyorC6dHEIqu79AfQr0MKMq18s7A5?=
 =?us-ascii?Q?Hc3omX/a4nUQ1Zuj0HqoijCvs3TIuCl4taHSnsrkBbW/VGue6bZZ4tgz6935?=
 =?us-ascii?Q?ck0QcEhhEi8e5fcx7VGzTXZgDAfT7lG2edNCwmiv8WnFMUw8yPglGGfzv4iG?=
 =?us-ascii?Q?dGfTM/F1g3+v2KC04/QAEdbLeR8Mcyw9jWe8NKzOXYHxiPyhds3J+XahJCTk?=
 =?us-ascii?Q?x3Kjc6euxcEqcI9gdPM8/slNY2csf6a0S5/xt4Cg1Z5WPX4BPifkUWS7NlKJ?=
 =?us-ascii?Q?lNJkgN0mo7XhKj7xCdiONwJSCm6H/1UqrvIeu6aqTQ8VMofq2bxN3NWQYmUW?=
 =?us-ascii?Q?GXe5mjzwqA8T4AazKdrdGUMGhzBSb2207j80ifz2TmyMx8r4Qv07qYuQmNi9?=
 =?us-ascii?Q?Gct3QeSG2c8zN6X3kmZXLNEtPQ8GjytLS2EB0SFV1KrrG2QT1lWmkmQ/ft4i?=
 =?us-ascii?Q?o3/mNIsuv+jXfNi/zjNlpiTkilc5bqVSfI3WJ4ZoW8zTn8pavXySblxePybx?=
 =?us-ascii?Q?DGGWYkbqC9DDtynCs4eYMYySNQTDQYSh7BlgK65L4O/7hyL1IwAPC8M2dtJG?=
 =?us-ascii?Q?+AjNo9DVTJ02m8ZhoTXy+Rxq4TJ9OHaxmgWQJfSEa75kbp94VsPEAav0tyS1?=
 =?us-ascii?Q?d6JB5JUXfO6E2qP6uBy/VbwgP1IwzPzRkwk2wo6Lg5m2bhh6y7c3334hs0zc?=
 =?us-ascii?Q?M4YI//Rbjkon8TAg3Hn9nxHkwp1O8ICE1dEoby/CYmHC0cC2zYV9RxXB9aLh?=
 =?us-ascii?Q?7kQLdNnvcB3YDqODfoJDGGTt3oGcNHfufgtE8EzuJsGKBdmQ1lSt3H5jFE7b?=
 =?us-ascii?Q?xVfe8XKs9/HJlO19wdCOUDcLzznzd+ev3Isr5360NR6X6isHKJCrDNSqVAgJ?=
 =?us-ascii?Q?aDgRPRHbuzihD1ilZ3dgj687wOivjUk74br9lvh3X54UqKQJmk2SUKIwErAX?=
 =?us-ascii?Q?ESCFdZoaqBV/2afxTW8OmclnErl0FjwYlEVUULqwnND7Eju/jQsAnrQeWniS?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ChogXepa6O/W5wuGIjmdTUQQ5hTPhTGTEqDTmrmYRcMcOXgbjgN1VbJ7wUz98GQq/DOdUpVaQ3q6rdVNThCOsMF0kTcu3hlQEra633bahUQtJKTt45ng5SE/+tNsmONdDsXOlmmCq3UBIPzucf6ysLcoZgf9n44tekGT8nySP6sQkwe87CCSOTqo49IO2eK/u3dLjoegHbckJ8j0ogE1TkBRSYRpxjZXOQTjJhzI3AECHnvU/Kp4hH+VtUvTusyfob0S3magU7f/lobsN+Yv6LR10O7YhEaJOWhtqWSBcM46TroZ0VdVcC8ACT2FIFKoGEQ0voJAQASyTHApgovc674yeKqkgqqtXWwUKwCAkpmnVwzk/7sgKTnzjOU9msRlLc5OMpeoFKhX97iBA9dc3qs0TYZ2FLUpwH6r/yIEeuwgCdX9a3YPkX/9LTRGCe+J6X7rquey3aUoeFMojfEmTHT0Q+52VTHobrtVEMEfUJKtD/6ILyPpHFuC4fnljUXxP/mJV82lBRLZV3SI8rL3gUw4KsZ0TwafGzuT+2TOId6nj4MOHYYGvRI7NNviYiEm25Dnxm7tWpZAWWyWPZCPaN7YNhxOiomwTItTocc3zSM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c2eac0d-42e1-4809-6e7e-08ddd9b78a7a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 15:47:28.3022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZX/UzCyytmcCiUNwlQsuUZsthRiL3wey7PVZCLuIfDbOCuGWanK183Qr1QY7Fvws91WL3cotbiQt8QzavAdpy9fQEnkZZgp08IAt0JCdFSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6329
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_07,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=629 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508120152
X-Proofpoint-GUID: wPfyRZnAJroBCTKWL7YxEcON6-WBtGNS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDE1MiBTYWx0ZWRfX+dIsU7pEqjrL
 g8A02t+kPVAb9pz5XbzrIY6YijW9XfnFGFdFNa6+/tsPywgEnhGhKJxAyZB4tbgIWUrNznh7V6z
 5G7AZ4iNitzRRHu/r77fI3eAITuL/YruJsJ/AVOsu+tu6m55hr6pSsvuZmK9Wdou21tGdP2tdXD
 9k2C90sXuCGC7brzbD3J4zunDHlGTkpjJvNQmxBSpDeruJWtmT3uRJqSUXL9JNe2diny9rBfu4/
 y+D0KfSd3Zamndhf3C1vFMcpt1BOsTlJHlZaTl6wPLDGjmAFMUQWHFYLEPbJq9tVtV/NwEgTB1o
 zpAE7laYvtjXMs64xk+678dFKFkO8OWeKmeSXi+KoH7XsxzxATRTru8r6XeBHI+muI4g3DH6hgc
 o3gFdrEGPREU939RVrRvI9bSjR6E25Z5GrHehAe3WWJDrD3LWU1OJV2dUElsepS4S7SksIT1
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689b6215 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=mgqRkMkFT7LrGRq-0ZgA:9
X-Proofpoint-ORIG-GUID: wPfyRZnAJroBCTKWL7YxEcON6-WBtGNS
X-Rspamd-Queue-Id: 00EC840018
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sj6cfz57bftnt5axa6tjn785n1ps581b
X-HE-Tag: 1755013675-920302
X-HE-Meta: U2FsdGVkX1+9JLjlvIdMgr+CyunRoYuMb5jEE9wNmnxiv0luyGwhtH4/0tc5SL7hRrkUn+zT68O2a5t8XGsNnJrbWUrhJNfhE2q6/nNh2qGY6ArrkqUEPx8AkohYiO+O3VcOXe00vYboiXdnKpPW8B3iz6Xaq8MxVXl61ruf340nz8/qdqj1yniMPkAqOy2wdlWZaMBguPMuAlpLZ8a+yeOIaCOBaIRE26YMMomf80Iz6nlc8S3D1VA73TJuokIP0pOK/bX8zdAhPioziFtKTKOFSAnQ1VNvR8yKDQiTBFGx31PBR3RuOUrU3VosNFVBlyMMW5pin84suz/ah10EdZxjB38eN319BoJ5S9lGdgZ+OH/nhEPk4v6VAcFAJZODkAva2eb/aR695iBM+NuwslDwUD2vGqgX4441wDmhP0s+xSqfmGBGflvOAVwKmw6yXaKoytyA8meCoaD87riizTuKyv+nL44I4oM+VFcIZ0SSzLZQR5nXYXKHbgCj9Ig0h1nvpRCaEHLAle21dmzuEw9GZZuLsue1V9+cAgVA3equG9dVJBE7XYhm/J3L0Di26QFDzRrh68twl37QQZBbw16pBXlm3167lRrb6w2z/F22JdbfibBXUmNtadp6BMrh26kBNcKnuXgd9AScflel5QUD5F91MWb9xCeKIgTfMPp/FoTQvzktTcmaXPTd/aO12/SQbLARMDY81WNXL7QfY6ZfJ4SSGCQWREtDig8cMVVSFLsOWvM3FnS0Hod9DZKNAsdIRtQw6IuGwZDsyREC6IoJRYvGW68W3e+6N1bftPeQtvLZNkANkkT6N58h4OZ9eDCegsJoTZh8SFYhEbw0y7+k9/xknQmucxKLvdVDk8dn7CpxTKwItAn2bUCy8Xl6cfVtUi8y9fv0F7uq75A6PpfRtiFOvloukhdZOsUhlpJ4Xq5xed3Ud0Mwf0t9wNDsPyErX9vIFQNOPADnOIV
 VhuUwKEy
 2KsGWR/12kGU/w1XRD+qI9LAJCA2Emz5Q9sIVx4H+xudLgy/imJZfpxZLvtGcu1oFqQPv7RHtrXXQrCwCkmfPzevU5U+JHSj8lMre71I2pga+0sxbJGJKhOHtmT1kzCZ/ypVYLiKZV6yZ9WTr8BrBpSpD2PE81vkelryO/MhgdBtPTTuWd8U2JHBFfau1DM1we+p+IhvL/lFgpS0pqq6kNhR0fL40m1sTQA00tVml1XZe37y3+OVL9HaKYaRSLq9QXALCXy2dSfY/xsNetRpN1U+4fA97zhtp1Hff1XsF1Klx4gnpvq9x73Wk4FbSboln2qEd2LyQjrj4bhiTWggMCT5iiDm76vcYs9Oadd74QSk7xMydhhrvQPNIYZRlYisSUGGjP8G7NkoXNnjF+Oa7zJOIEF2T/mN2vT8tWoKhX6bSkGOqum3FLcPdbdT7V4XTF8ObHSk6sdfU3lpi6xEGI1rT9IYRDR3TfFQao+NUdFKxb6zxGiXnsLnAGO6HwVdNRsIRgFnb1zzUtSLLCjjOcSoAZdU6Twv7NhI8vpP+grj02pTFbfLSGPhw+1hJ+tFO7Y7MYy0Kn71a+QtCIflRbbrvW4sCT1RWe+MPRzwgUAfOVa9gvP+A228D89SlBn3xvtCdtTlVXc1/1nCTQ6Qd9H4eU+VrHV6RGOcw+6/yG3rcgxbbkB5MtpF/PqbooS6+UJDs4mHNwsi3cFqsnhbUAOMB6nGIZ/StpHG8chQ7nhyjRXTbrl8QM4FU19FsD/lDdBEOx2sfSvM6Ew8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are currently in the bizarre situation where we are constrained on the
number of flags we can set in an mm_struct based on whether this is a
32-bit or 64-bit kernel.

This is because mm->flags is an unsigned long field, which is 32-bits on a
32-bit system and 64-bits on a 64-bit system.

In order to keep things functional across both architectures, we do not
permit mm flag bits to be set above flag 31 (i.e. the 32nd bit).

This is a silly situation, especially given how profligate we are in
storing metadata in mm_struct, so let's convert mm->flags into a bitmap and
allow ourselves as many bits as we like.

To keep things manageable, firstly we introduce the bitmap at a system word
system as a new field mm->_flags, in union.

This means the new bitmap mm->_flags is bitwise exactly identical to the
existing mm->flags field.

We have an opportunity to also introduce some type safety here, so let's
wrap the mm flags field as a struct and declare it as an mm_flags_t typedef
to keep it consistent with vm_flags_t for VMAs.

We make the internal field privately accessible, in order to force the use
of helper functions so we can enforce that accesses are bitwise as
required.

We therefore introduce accessors prefixed with mm_flags_*() for callers to
use. We place the bit parameter first so as to match the parameter ordering
of the *_bit() functions.

Having this temporary union arrangement allows us to incrementally swap
over users of mm->flags patch-by-patch rather than having to do everything
in one fell swoop.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h       | 32 ++++++++++++++++++++++++++++++++
 include/linux/mm_types.h | 39 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3868ca1a25f9..4ed4a0b9dad6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -34,6 +34,8 @@
 #include <linux/slab.h>
 #include <linux/cacheinfo.h>
 #include <linux/rcuwait.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -720,6 +722,36 @@ static inline void assert_fault_locked(struct vm_fault *vmf)
 }
 #endif /* CONFIG_PER_VMA_LOCK */
 
+static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
+{
+	return test_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
+}
+
+static inline bool mm_flags_test_and_set(int flag, struct mm_struct *mm)
+{
+	return test_and_set_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
+}
+
+static inline bool mm_flags_test_and_clear(int flag, struct mm_struct *mm)
+{
+	return test_and_clear_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
+}
+
+static inline void mm_flags_set(int flag, struct mm_struct *mm)
+{
+	set_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
+}
+
+static inline void mm_flags_clear(int flag, struct mm_struct *mm)
+{
+	clear_bit(flag, ACCESS_PRIVATE(&mm->_flags, __mm_flags));
+}
+
+static inline void mm_flags_clear_all(struct mm_struct *mm)
+{
+	bitmap_zero(ACCESS_PRIVATE(&mm->_flags, __mm_flags), NUM_MM_FLAG_BITS);
+}
+
 extern const struct vm_operations_struct vma_dummy_vm_ops;
 
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index cf94df4955c7..46d3fb8935c7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -20,6 +20,7 @@
 #include <linux/seqlock.h>
 #include <linux/percpu_counter.h>
 #include <linux/types.h>
+#include <linux/bitmap.h>
 
 #include <asm/mmu.h>
 
@@ -927,6 +928,15 @@ struct mm_cid {
 };
 #endif
 
+/*
+ * Opaque type representing current mm_struct flag state. Must be accessed via
+ * mm_flags_xxx() helper functions.
+ */
+#define NUM_MM_FLAG_BITS BITS_PER_LONG
+typedef struct {
+	__private DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
+} mm_flags_t;
+
 struct kioctx_table;
 struct iommu_mm_data;
 struct mm_struct {
@@ -1109,7 +1119,11 @@ struct mm_struct {
 		/* Architecture-specific MM context */
 		mm_context_t context;
 
-		unsigned long flags; /* Must use atomic bitops to access */
+		/* Temporary union while we convert users to mm_flags_t. */
+		union {
+			unsigned long flags; /* Must use atomic bitops to access */
+			mm_flags_t _flags;   /* Must use mm_flags_* helpers to access */
+		};
 
 #ifdef CONFIG_AIO
 		spinlock_t			ioctx_lock;
@@ -1219,6 +1233,29 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
+/* Read the first system word of mm flags, non-atomically. */
+static inline unsigned long __mm_flags_get_word(struct mm_struct *mm)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
+
+	return bitmap_read(bitmap, 0, BITS_PER_LONG);
+}
+
+/* Set the first system word of mm flags, non-atomically. */
+static inline void __mm_flags_set_word(struct mm_struct *mm,
+				       unsigned long value)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
+
+	bitmap_copy(bitmap, &value, BITS_PER_LONG);
+}
+
+/* Obtain a read-only view of the bitmap. */
+static inline const unsigned long *__mm_flags_get_bitmap(const struct mm_struct *mm)
+{
+	return (const unsigned long *)ACCESS_PRIVATE(&mm->_flags, __mm_flags);
+}
+
 #define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
-- 
2.50.1


