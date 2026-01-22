Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 914B9D6261F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292C86B0187; Thu, 22 Jan 2026 07:50:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057466B0188; Thu, 22 Jan 2026 07:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCBC26B018B; Thu, 22 Jan 2026 07:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADACE6B0187
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:50:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 724951602BB
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:58 +0000 (UTC)
X-FDA: 84359584596.12.BB2EF40
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3CCA180009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VHIyVmL3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R91PmHc3;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Fng9ZWSYvhPP0K6LOlBniotNyDAzRnnhNzt1Kxs0X6U=;
	b=S49QtoYEQSzUxVMBsv4tPKGEETvV+qQhpA/tOYS1NnGH+4PzYQBWfjVJjUSZrYr1H3xYqj
	WJyjHcGa+YV/G9wcQIGs21GvT07LGthKGW4sXv4J2TnH1CivL+f4lc297UAGQZLI7LJYN2
	sFuyqYmUg/7oYs1H4QbE+jtzggsaTgY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VHIyVmL3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=R91PmHc3;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086255; a=rsa-sha256;
	cv=pass;
	b=zGEsz2twO/RSlPYouMnD2gWLSmbkEROIigudaGfs/teMMhx6jHaAcNSW/t5r9/vgICf4jR
	FsUtqp3/l8kAErT57dxZNtwsBmQBE7PNbGE3eKCCd8gy9uptYOzPlgo5t76gWcA1Czc3+i
	oHXjuo/mfUZm6o1JLT9Qn3RVpDRSWhk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LM4K9u3429730;
	Thu, 22 Jan 2026 12:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Fng9ZWSYvhPP0K6L
	OlBniotNyDAzRnnhNzt1Kxs0X6U=; b=VHIyVmL3+sExDbf2lhnm1FQ6Rk+UsOO8
	9609QQIPH+Kjq+qEse6nWNP2ANXJVo2xXWCmK5G+7QMBF5uB1o0qaT7Qbz42IklA
	XnnzvMlSQYFMDZFpBW5BxrVvQ/m2FsnjkJZ3Kk3vh+ydrPAC9hMWX3vXMPMHO349
	sIZSsl6mXQ6K2n10TnKGc9cB84uCL0DVss75rTB73IWDoMeetLKlFVssg5T1LBtP
	pL7HqDfo7LayDuYG9eoMTneOhDUO3T+ljCabL+2o09Jd98/mMj15achM6eGegALj
	5u5EHFrgkZIzGvPSMNT/rtL9d4JhhPqSAWkr2IdWXEzfVCEhypoeYw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5qjv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MBml6o018230;
	Thu, 22 Jan 2026 12:50:32 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010022.outbound.protection.outlook.com [52.101.201.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcss2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D6gNd2MzrzdNb5VjZ3RogbEUdj1wJ1j0G1CRZizw74TEvCixN53l+QLmqiaBc9uRw57SKxVEdu2FJcPAt5RC/uDNh7Y1pxYFTUg084jhLSF4ykPyL3zjRCNk8dFJFv4GRzn4H7pTvRN6FeJhmCxYHrQjMcbtXGL/RwvAx/Ov7YQK2QE8pObV6LGBc0aacrvcq19xsHbUHqp+Uf2vOMCCTJESke3twb9Gby0QYXclw/6rccwAM9iPeNJNamMk/uJ8wHSvjJtaeyQrRrPXFD6908yNGqXJSYUosRMJqIEjfSpiVIC8uWzbWteZkwfGJN5HpzVox6tcHrlQX5gUN93YKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fng9ZWSYvhPP0K6LOlBniotNyDAzRnnhNzt1Kxs0X6U=;
 b=M+RTanANLbT5bf2Ar6y2J1huGB3CIcLangpO9m1J98scKkuZrj0ql3h2B1xx9U3JU5RNrzQqDqpAgdpSGYh5M8Fix8Cc/s+sp7tWIbStSt2MnykPQd/ewduDF8Jsrk/gprAXrxlXjZo9Lr8wq9SnXXq20zcpD2IipuhFJvnugFYGI0D+OXWNpktAlzv3DjMAgcwg4OwSv2v1ZRcKL0atT4OESRSvg19QacjYX6r0qmCtXnCnjO3uHjwyLvVbDeMGiP/LCFoJMzhFq/Sc+FlOA2ejH7z55j4jjXniaS7VwiSlxV9dNRjjSy4pJSFUESSNvI7v4b3sESSX/2jRNbfYsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fng9ZWSYvhPP0K6LOlBniotNyDAzRnnhNzt1Kxs0X6U=;
 b=R91PmHc3g9P9gA2alEavw/Bd1N2gCoor40DZ3JxA3e+I8XlSw8CngAkOWt/jq697UnU5a53K5syB5zDUIXW4XD8IK2SRjhNxoo8dTZjcC1gRHMnrtEXm5waxSk6S1T0v/HeQ6gUbE8iLySxwF67zw9zt5WKMvK5ZvXvCRPrnlHQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS4PR10MB997622.namprd10.prod.outlook.com (2603:10b6:8:318::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 12:50:30 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:30 +0000
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
Subject: [PATCH v3 00/10] mm: add and use vma_assert_stabilised() helper
Date: Thu, 22 Jan 2026 12:50:20 +0000
Message-ID: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0139.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::18) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS4PR10MB997622:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a6ebc49-83b9-4261-3791-08de59b4d303
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z6XZyGqQjcNqfp4kiR3gij+7Zf604LInuot2DYLzJpb1+vSW7xmIy0I+FQaz?=
 =?us-ascii?Q?09YvafV03oCzviOotGjMpSLFSLc4R1sczy1//z5EzWudOavqFbgdQk3QBfKb?=
 =?us-ascii?Q?U7mKw8SGK53plB8rjpNG2FDwSu9QpwThIuXcejW0PLqPI/8qtpi195+2DRon?=
 =?us-ascii?Q?VLgn78OZ/rb1B5qirmxYDxRCTE41J+vBOX1X8kFk3cQgrOYqqXcsJ1fiWO7r?=
 =?us-ascii?Q?gQY+Yz1HdWUjlyUsm+90Q0V6JIgnIRcw6FHCsixNoiI/Sv84a+h0XbfecZWI?=
 =?us-ascii?Q?lXoHeo+Ewmcd+PWbXuqO6zzt1LChGvwK2LMJdo20OGOr+sHvpo75q7QpQl9h?=
 =?us-ascii?Q?WMX/RmRA9G5gdvXU6y1zzAP8ODOUI99OpkMYlg06W+s3hsrg/sISH2P5aGnE?=
 =?us-ascii?Q?Cociv3ldX55DsUGl3x16kz0Awn3RFgL2pUHpDF/Bt3qrfwDCJ6EBa3jlZj1i?=
 =?us-ascii?Q?xMcPWY+TB4Z6+1wqWXQPM5BeusHYnquQvBDQCnh3kb0/zNS0QkeDzZG62wiF?=
 =?us-ascii?Q?YleTyqg9G/RR5sVOe2vTVVI//XLlZK9gWf1Yy8mGMxgeVy5S9T7cJ/yxjBgR?=
 =?us-ascii?Q?ec0zPO+2A6BCxcpVRQY5aafvD6r5WYbcMxc9N30zJOiuQuzjnfEuScimWaiF?=
 =?us-ascii?Q?klar1QDqN15mN38vHegsrwDUWfghSOHdKy9o1RHNxZyTY4k+6p6woXHq5eeu?=
 =?us-ascii?Q?zGHn/x4qrykjw+QQueMLPkntOmGp+ME83c2ipCCIsOctQ6nA6KE2Z7VQanZd?=
 =?us-ascii?Q?jU9L9ScGwFAymcH7TAbR3/c4Jk5b2LKjoMZDDCn+l9Taj6kpkuq6Kgxhvo2P?=
 =?us-ascii?Q?Q+Yvl8fnxRhd9fn7IyDX0Cq0XEHBXmcFThzIFdDteL8fpsxk940XfDSwpaHK?=
 =?us-ascii?Q?xxZxpiuUjcHV+5n8G9ZNjWzqNBxBQ4XYEjuBUXeh/w3IVqrR1t88l+UG5mv5?=
 =?us-ascii?Q?oA4U7l9at2Z5i1f4xHzSpNA0Sou5Dyms+ZvdORGy57q4Fm0s5d9zNvaxIT24?=
 =?us-ascii?Q?vIAG1neMEtlju/2LR77Sq7gzcQ+sI1Ru3++sFxv0LHfLSP6yiYBvDEnO2F/X?=
 =?us-ascii?Q?egWlcXxn5VXEpT/peh0A1W3H1uGnRjawmZSqTedTfUZmUNEX8l4krZ9sie0P?=
 =?us-ascii?Q?GWkxyd9KkL7PFT49sUfPyvgy5zzd0JBimK7woW/Tt57Vr2zauNUw22az6sA0?=
 =?us-ascii?Q?i1GoSivuDbxSbf4uqSAG0JZqdg28JP/5VIIR/feTATQMk7sgFSZkss91712/?=
 =?us-ascii?Q?+KtW0rPSLt/jNmSxU9X5pz2TZ9b2XfFR99JdyzuN4hidKG6VN1KpDcOwBiQU?=
 =?us-ascii?Q?S21bcjw0WQDj9fo/7MeyVkEdvYVG1HuHH+a9TaX5tNF0xjAtMgm2D/k40HDt?=
 =?us-ascii?Q?/ZUOesReQ+zn+91lOKab6FP8hIMTI9b6ac+G/wfZlinXqZu71ARRiT3PQMdc?=
 =?us-ascii?Q?uP9ZC6kEDFju0C/8cyO3/mQEHj42KyzKct1VqdwUpZ+hkkhfJoJDTvp7z0Lk?=
 =?us-ascii?Q?iSyizWdboENSJVFKwNZCkUWfi6CPpJ0oZlGwQzCpL33Vd6kdgitcKhfiWujM?=
 =?us-ascii?Q?dEdF8o4rrYzq4sESE3KIV/vaKQ/HvqS8joIRlf2x?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lEP07ci7R6kfhaW27APvg4o/m4B6kL1R6IVltH8pj5NIUEc6r2BRN4d/U6I4?=
 =?us-ascii?Q?3Fxj0Q/tW/f79G2DU2Jr0fNxGql9TLkxMWCt6b5/4ZWL+OxSiG/4xRHx2ObB?=
 =?us-ascii?Q?92g4pU71pCWoBK4AOPRdhNCCbANbXQ17tdzcTkiXWnxL4cuUiStqIX2kDXNF?=
 =?us-ascii?Q?EJg3d28C6ew5gBa7zLtKcFeznQ5Ifb4XvksfjetS9ZsTguKQyDgfNIyuW+lA?=
 =?us-ascii?Q?w2QXg1wkEhHaoscidnNJJAOjCPobYodsKrHjUrXj5I4RBWAoQhWzA/MBV9dQ?=
 =?us-ascii?Q?7GS8PZGkZigwA6ULpyReuxwy+FhSgmW4wwnr4Rfs0YIx7NEBfs0EQRUigvG9?=
 =?us-ascii?Q?sJMzbAx7CToyvdIg9DBe5qockAGqYwRAXhKjH+jXn8WEEXoYtWv4G5o3vW2F?=
 =?us-ascii?Q?jX3tt/Hge5uePb11hxjwkjaJSAYjfxp8VbI8mIdeZZT8uuc1VMDD8SvzGVQD?=
 =?us-ascii?Q?iLThpll2q1cGWPwapuBco7v6A9XxOYkH2GV2w71MYf5rP/HwAeiWRAiILKyt?=
 =?us-ascii?Q?IzCXnXvKAhRRFTILEcRUfPv71WBhU0v1dbRdLbVABXFSaJloZ22w7ky+ssuk?=
 =?us-ascii?Q?xp8UULteINogyMJ2x8nKhAAmi0G3Yc26nFK1ZMnhpDk0ysQuloAX/d+MuQ7t?=
 =?us-ascii?Q?BIms7/tLiCshc6dCtepUPEZqsyX4UsUCOZoUWt1Msl6n9NRKnthlxxjr0dYl?=
 =?us-ascii?Q?cO41DA88w6JCBLBWiAISNmqACYqWNxdRosM3m+nXShBRdm4JoqnsS1YC6LRP?=
 =?us-ascii?Q?cMaAOtJpdqklAoF+zTnTfHtutJAGjfouUyho1bEAs2bu1HWHr5Mg2FhyRdTb?=
 =?us-ascii?Q?DlIEOTIHOokluxxyoWuiPhNLCJthiRHX0lHIowV+/3mPEoIwtc32wW2RyhD6?=
 =?us-ascii?Q?dzcyaib5N4lF1mV/TLUtw5fmIfYBBjkzilayc1y1YkwhE37uDlfh8VoZaBSe?=
 =?us-ascii?Q?UPAm+ouXAfllAI215HUlDqZveOEbH24VnISvmbjSG2Ctq8/rSB2ZxnSQ1NvO?=
 =?us-ascii?Q?VK2F+S9GX8wP4HG4hmnLWinvf2WmSXl79LXba2zu/3MY/lccEm+TNHwNaHyS?=
 =?us-ascii?Q?BpiuVM0a1VowZ1Fu3XEGdzASt29uq50OIXHt9Iy1N2u7iQJbSVHCEDGzI+60?=
 =?us-ascii?Q?Cs1MhEaQKmGXOr1dPZQjRBzMeJTJN7shUJ8LYlWtDat0fLd5ckPlDZyDYJcK?=
 =?us-ascii?Q?16w3q+f5hoxK6LoKRyVcKchORYpDC898itPkbXWGZWuj/0CeDUXYUrv90nVF?=
 =?us-ascii?Q?hg+5rdn6FtcXxMCcArHSCKy3qa7u6oh8s/aNeZSWp+54hRE9mI8IzUK/9af4?=
 =?us-ascii?Q?375BiEyg4VJmu2WZ58nj6Gue1XR0jtAZ0QAKLDW8ckmTG0C3HzR898vCjMuV?=
 =?us-ascii?Q?EiDB1E8rO1SAeOnqwLc3w9lCABZ7Ah9cXRd0xGUKUC0XWe6Ce1SnMOGPxUDs?=
 =?us-ascii?Q?YvbjrFmwsM1G2404vyn2wKkcQlMfvTEoTU5zA8bWxP0Bw08DfLOsGVbl7HB1?=
 =?us-ascii?Q?aNsq5SiL2DyNJswFxPwr/zCqN3CXqwcpZpYXAoIw6T4N6fQvn1dUvgWTPpzF?=
 =?us-ascii?Q?27ztXKADtLLxh74cmEA5PJPGbgKmUvDCD7bzEQgxF6JqDxG+89XVUOwfBGp5?=
 =?us-ascii?Q?HF0PY5Nq8Q5Pw5HYAvYRMiaOGmnDEoCohCEBKYCshtcghBM3Rzh5fMzxUxpD?=
 =?us-ascii?Q?VmUM05hQeR5IzbAEBivSfjZ1NN/oAja1Spt1t/r3g5+ltq7EuNlWVYIMHGOi?=
 =?us-ascii?Q?bHHPYfvZ0vv6sRHx9HFwkb88HWyjFRg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dQ25oQZSWjBH+NK3nx2HuNdLKzlPw3uiXcNMknNBVJelcGM1xhw3s3sBqLTBSHbRiNPaggTiZD9dh7FtiaNnXyA8ZeEpu+6JaXjAvySWrzrGKi55C70Jb4jqk1qsukMlY/QrXb7LPxO2Xtbjjywzfk5gWhZ4uJvFTzADpr3wv7b3mmTHlKGpzH4JnBdAUSnB4n46zt75JkRTz89oetiTf1agoOj+d0osrJadb3xw+FuhmkLYS7xGkUZOBFPROjHcTnSzsmac9RVl7cjqrzBymxnNHmbsqboRiAYBCzX7jmKeBUU5xSQwNVdMeTucktpO7a2APf1L+5EGQTTNum4IvdkM2/xAOMAVy2suUv5wsBxaRwQaFPflyb79g9xyC4lF6hoqI0aU8J7DkG4MR6EbczJG/Nc3GGS+fdOUYNSdBKj7FafIVqwfWf80abIf9K+S07BqqyGxw/nuvGOXzi9qYzL9/J+Z8BAgvdROMVXNwfSIM3o5DJDw10ykFub/CAunhFSCgpvaMy2t0ozFTrnGSlLyHr7RK4QK14kHWxQST9xK2VJcBNhZ9aMPN2CHsf/Amtw+UL5zLox4SxACakF0hL4aNL/0Ryyno3Ai3lzNY74=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6ebc49-83b9-4261-3791-08de59b4d303
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:30.3937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiM87qum3OCwZZlniwMjDoobCjAMhjK8lL+BKjLoP+7R6I0uDgSy1q9oo5JiYV+vO1KRXuMAInEaBesqWG29ST1QvKQ98AEwwHOI+lVB9R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX7fZYSSeSjus2
 kb3YTJc0EvFioe8a7ktSGBZ2GiDnitrR+L4FqtKnYLQ/dfo9Z7gQBfwsboe2bIHxVuBHgJwRHQZ
 JjZoszncBZWZpYibX9rvWN6Xgn1BsKlGzdJjCIgoDe4US3QoNpkwwagGPTdP4AtlAceh3wpupqn
 QUZfcHN+HwOqoob/OhaxMaECzD8Y6BWPRE59i8EOzpsj8p0q2v/ea26eiDu7D7ViomHZx2xeBnl
 JNC8Iwn8n82RoNon8TGDuoZvpT2RvGu6rdnmNst5/AU1zW12qgTQxVavHJeiHWQ6BJ+eJapfbjp
 6olNrYjUjG95WlDd/9yg2qMUJWjsZl4u26FFz/W4qtKxKbs0VUMe/PzH4Beb55GGOMeT7fLzUvu
 ujQoag0DvD+lupp1Va0Co/SGFPbM98zWzgNM/Fnxr6sYiMemwzM3yyC0qH/mGO1+0BYhIBpYuxn
 s5na4hD7Q5V44vq2TfQ==
X-Proofpoint-GUID: n6zThispUYIHBlDfNKprU5t17zgayInm
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69721d19 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=F9VmE9P_SG1h4MgszfsA:9
X-Proofpoint-ORIG-GUID: n6zThispUYIHBlDfNKprU5t17zgayInm
X-Rspamd-Server: rspam11
X-Stat-Signature: ir86c7yk1bio1qfa84qw1a1bszx9hsyk
X-Rspam-User: 
X-Rspamd-Queue-Id: D3CCA180009
X-HE-Tag: 1769086254-750763
X-HE-Meta: U2FsdGVkX18ekClbedX9OBCGsJqmS6NBGNH5YJBApKGO5FOviyugZ05YYb/b4xwV96Yh85uaMWJZvF4veMFvr0wUYu9lSTQ3J4+xKSZnqPAMKxMBQnI8WCcxAKLPb7XQ9i/UTrEuLWrwgeL1s+nsV/32eSoYtjgaQMWbiPpI9QDP6QnSLU0R83XVV2CNt015Vg2QPi0KtEQ0Hwxe7gkK/vtJLTA3CY50xW5Cu39oTmOtet2hYjyC5+AR5X9YSdEU8+IIg9DZ9tWSLI5Sj6nCuxDrGLGOErkBImdsmPDsTquVQEVzmFCP42kFTAWlHCIAlwuGZB/sR1usIMjjnWD8LeJWAwH7jpvYuGsmjPRTPjVVdS1jzLRIvV0DwLeDogKEyyvHEk455un1dWFaIyKNZa395BEQ/gA69s4yjs5SSMHrfY9ICmP8FHO3d0RKHlcnq327miGgI92QDzDu9bMWyGMIz9OJhH1MrTt5XOhnLqfsq8DF/FKnllv2MRubbaCTRy6WZC/FKD3Of358t/XxU55L8v8A6Pf+ZWThPErUqLfS/4OCYfbs17iRaXs0UsaiXQnFgksIKzb0WXOntm90rIG1IXmRGHt6gRN1uN4Mr5hjWitxIalQuYb9hbV/692veXyFsrGDW+ky3QvYcU7iCSnYcZTwAStUqL1ru+Fv1ZqI2s0AW1gn0mzvpatff0vGyz7ZpgZFQo4PB3xwHuIkHOSgDyIzUNASgSh9phGxhgy4WTBjHvFWH0eYrPdUUaxFbMOltPWxB0svURQoIH0G1vFdCcv6FVZhYNCyNmIUzmG+WjcCU/6NZ5SG5e0Zaiv+eNZsL8yT8ODj49966BENs1kZgGKtPpRp8aMQkNCzZH9ZUnqdSJly9+O1EIyY7MlyGYHyCs0LIFLasR50FrBDN17KHEO7nDLImieVyuNa7oCCS6VzuHGZvkPNq30fkp+Y4/btiCZ4D6suCje8CVo
 UpxHUkN+
 q4xrduCA0Pq9wSTb2YDYXzfOWZcszQPKxw0kFS+0Tn/OVjonMJbsOrQOKgolksIVOkBDzohy/7gweG9y67EE1jvxlL8EZVN6TzG/YhumMKq4egvYqF+0BKcn6fZEgTqH9MFbC5UtVzBoZy8Wi5WOlXN342B3pxTAHWNDxcij+8i3EcDiUHMfZDHlpI3q2HYlySe3Qo5wmt4Uwx+nVaT3rBnRucD//4QZD06UXJUfxk62A7kk+q0+zIvjMs8Xv3ecu11memSXrAQdv5JpBDtmI0ObikaSG/7R4K5h7bhSyCNSXGzWuYZIYeDuG6/MWZykhySOpyx2dpqSrWDaw7VxpkfIYvFvBthttqYbSGNlM8v3QaMUQEf+ugxjlU8NfPhQwHlvL1ad/VesskNuW8f/5r/IZqJQlrQ6ceYmYjooqXX/7aD0pVrkn/W2RN0Xvs7JdrMZG9/PQV0jftG3C3/A+irsF+2yoTOJlXIvOL8nPj+B4jZqsfeomLJ97f3085arhfylx/AVC3/THE2RkqkLTAiapZUhjGy2GB/4Jlm7d/Nn3QevbEqOmP5rMxTMXWjtT8U302qnRMLxBukMoL07WhNP9TFOJ7Gy+cBGoxpeyGUypd4zS+Aoc+jWq5TQm2RYmqtqNRkFHExFK7Sb9SqbJwJditpL9oSVKtPRgdKg2xyVsxDY3BpXKC5n13sQgllKgIKT9skb2AQOiK9shKf5DyNldMl4kROdCMBHpogcj6XlbTAAYzRD0lqyolQ==
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

We already open-code this in two places - anon_vma_name() in mm/madvise.c
and vma_flag_set_atomic() in include/linux/mm.h.

This series adds vma_assert_stablised() which abstract this can be used in
these callsites instead.

This implementation uses lockdep where possible - that is VMA read locks -
which correctly track read lock acquisition/release via:

vma_start_read() ->
rwsem_acquire_read()

vma_start_read_locked() ->
vma_start_read_locked_nested() ->
rwsem_acquire_read()

And:

vma_end_read() ->
vma_refcount_put() ->
rwsem_release()

We don't track the VMA locks using lockdep for VMA write locks, however
these are predicated upon mmap write locks whose lockdep state we do track,
and additionally vma_assert_stabillised() asserts this check if VMA read
lock is not held, so we get lockdep coverage in this case also.

We also add extensive comments to describe what we're doing.

There's some tricky stuff around mmap locking and stabilisation races that
we have to be careful of that I describe in the patch introducing
vma_assert_stabilised().

This change also lays the foundation for future series to add this assert
in further places where we wish to make it clear that we rely upon a
stabilised VMA.

The motivation for this change was precisely this.

Addiitonally, refactor the VMA locks logic to be clearer, less confusing,
self-documenting as far as possible and more easily extendable and
debuggable in future.

v3:
* Added 8 patches of refactoring the VMA lock implementation :)
* Dropped the vma_is_*locked() predicates as too difficult to get entirely
  right.
* Updated vma_assert_locked() to assert what we sensibly can, use lockdep
  if possible and invoke vma_assert_write_locked() to share code as before.
* Took into account extensive feedback received from Vlastimil (thanks! :)

v2:
* Added lockdep as much as possible to the mix as per Peter and Sebastian.
* Added comments to make clear what we're doing in each case.
* I realise I made a mistake in saying the previous duplicative VMA stable
  asserts were wrong - vma_assert_locked() is not a no-op if
  !CONFIG_PER_VMA_LOCK, instead it degrades to asserting that the mmap lock
  is held, so this is correct, though means we'd have checked this twice,
  only triggering an assert the second time.
* Accounted for is_vma_writer_only() case in vma_is_read_locked().
* Accounted for two hideous issues - we cannot check VMA lock first,
  because we may be holding a VMA write lock and be raced by VMA readers of
  _other_ VMA's. If we check the mmap lock first and assert, we may hold a
  VMA read lock and race other threads which hodl the mmap read lock and
  fail an assert. We resolve this by a precise mmap ownership check if
  lockdep is used, and allowing the check to be approximate if no lockdep.
* Added more comments and updated commit logs.
* Dropped Suren's Suggested-by as significant changes in this set (this was for
  the vma_is_read_locked() as a concept).
https://lore.kernel.org/all/cover.1768855783.git.lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/cover.1768569863.git.lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (8):
  mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
  mm/vma: document possible vma->vm_refcnt values and reference comment
  mm/vma: rename is_vma_write_only(), separate out shared refcount put
  mm/vma: add+use vma lockdep acquire/release defines
  mm/vma: de-duplicate __vma_enter_locked() error path
  mm/vma: clean up __vma_enter/exit_locked()
  mm/vma: introduce helper struct + thread through exclusive lock fns
  mm/vma: improve and document __is_vma_write_locked()

 include/linux/mm_types.h  |  54 ++++++++++--
 include/linux/mmap_lock.h | 129 ++++++++++++++++++++++-----
 mm/mmap_lock.c            | 180 ++++++++++++++++++++++++++------------
 3 files changed, 280 insertions(+), 83 deletions(-)

--
2.52.0

