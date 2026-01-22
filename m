Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED6BD2ED14
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911936B0190; Thu, 22 Jan 2026 07:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CFD96B0191; Thu, 22 Jan 2026 07:51:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76FB56B0193; Thu, 22 Jan 2026 07:51:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 587D56B0190
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:51:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D02714013C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:51:04 +0000 (UTC)
X-FDA: 84359584848.12.B1102D9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8A5D6A0015
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:51:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WR8s3vPO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="kx4DGOm/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086260; a=rsa-sha256;
	cv=pass;
	b=7j+LdPUqEJnWTJaIUhKNvb+ThZujuEyyAn4Na9pibFgUsxNELRfDKFUHCEEAeU7iw6HR4K
	VcwRUpR0zhE4UWLBmI8ocb3hm3d/LWfzoECaB9SO+KAtB2odpIn8XCy/7thOQdK9A3uqAK
	8+Q4yiOYKnyc9MZ4UsXy3jtsHWkj5Z4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WR8s3vPO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="kx4DGOm/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0omcCeG05KRpcGsbKGwuo55GUCBvKXjddLZ8sGvO8sA=;
	b=4GJ06OHcimUiA9js9AbiBBaqbQ2MjgwIK+qZygi7KY79vIQDvyiVGWwFq/oxQRmoLLfaQH
	xCpNIMO0KSZREwF6dndIq5dLVATQq0AoJHVj41Us+pOsGn5/pE8bSd/DaEZKY+idr3jo3u
	1a11xi8TNgf5/SP5y+nVq22koLHSbb8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LM7KnE3429899;
	Thu, 22 Jan 2026 12:50:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0omcCeG05KRpcGsbKGwuo55GUCBvKXjddLZ8sGvO8sA=; b=
	WR8s3vPO0wyg2kBAXR9+T8zhtCE7kHBn5hU37M8ZMI8JORyWCXO1agaAqI65iJAv
	z33RgRp1/LccSSXNJ65OYJpDF8Lf/FdeD2ioF2jOoFUHylhV0lRV6HpAvtK4fEjQ
	i6vsFZsv7IdGlYvDDeGDuqWje46yPuTdrziHKsG13zOfdjbwS4DQ2hqm+HH0xnfQ
	A8Wx2Qc+3zJdB334U3fb/3h6Mvv2PE4nsKiLlvdtUHstP74w0cZe+T/TwkLxf0qo
	1BnL5hmJjQhm3V7SBGm798PpJQVgdELeUq07Edic47y1Gmo6x/LEjtIOaPI3+aRF
	RE8dwBelRS9wGnsbE1vn1A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5qjvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MBt33R032828;
	Thu, 22 Jan 2026 12:50:48 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010065.outbound.protection.outlook.com [52.101.46.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgk1n2-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/BXYh+6MIpF+7kp+QRlpi/L2D4zYC/SwdOKl4fS0oxZQPpFVICiJEn9UjWMG6Osjm90bN/VBZwfi3UVT9suM3aO4JrBd9Ylah8u4e++cndj/ahrdiR/FTN7k8Ma4Mb9LjEK8xWHm1KcWjd8ZVXO77G9bJiQmF01A9cP/5UWL48rYQqebwCBa/ucbXIv/HNW8MlpaZepdD8+B86rnAjmMd5N31QcsKOy+I1I3VWQ+GZG+fA5XPsHjYJLOGfGyjHIrLMQJ5LipYUKLuvXtypxV52izXU2tNUpk2u0hpY4c8yscuRaanb+2fRLI6NIi1+lwqEREPHuC7npPCcACsFV+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0omcCeG05KRpcGsbKGwuo55GUCBvKXjddLZ8sGvO8sA=;
 b=f3/z14jfIfv3b5N8fx5BE8c31dlVp9R/NNSTuIsXq4Or+pQv+6lMuYJCMrdukriBBObKqFxD19UE6gQj5LXVjCN04UfGuq+ucsXLJle6ywAn7vdqQZ6dLuZwSNzNhVICKLiXiRQnDUTFz1h6Q/7AFWEKsVzhwqhru44fDv9sF9sTA/FBl0vV+y316fDt21xIMeYf3i3CaCx7A1GTiDtUspGfjRskX8M28f/RHwMhXixWG1AEw66rMZP+vyG/4iLdS4IBGOXO4xPl9wZa4cE+Ojm4fKoLf6LaTIWpXjXLD0TO3XYYsc8NPZnkdX6ud5WkZsdJI1QFmNexjoFdRzpVrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0omcCeG05KRpcGsbKGwuo55GUCBvKXjddLZ8sGvO8sA=;
 b=kx4DGOm/hK3Np3jnXuHbp9gI9nD2cEp3+WOv6vxlqw3yDuQhK04DJb/sfYNMmbD8QujWsBHljnIKM973gCE5Vi4CyBpxiV8gL6Z9ZgCPy1qu/8RdXcxYB+zJj6nreW/OMwtIFx9NFgFGCKn5TDahaPNmsgjH2IlZ1Dj+TTJm1dY=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB7904.namprd10.prod.outlook.com (2603:10b6:8:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 12:50:42 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:42 +0000
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
Subject: [PATCH v3 6/8] mm/vma: clean up __vma_enter/exit_locked()
Date: Thu, 22 Jan 2026 12:50:26 +0000
Message-ID: <f1981963e3c9421b6ffef19f15d87953895cd0b5.1769085814.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e5b9cc8-1fbd-44fe-cab5-08de59b4da27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VA+zAzLmBTm1UyjrRbwoPE9e/d0CuK5bPb+0Vnn55UWnTvWSyfZs3wV/iBJE?=
 =?us-ascii?Q?LdtFes3rJwRf3sOCNuOC3U0jgHjxLJ/KCFGgbD6n/+yDddGxlUKvdRITu5ds?=
 =?us-ascii?Q?snKpBp/ufg6gWDSrEVQC8JCHCcazqYnymXlaC1VGiH1l7iA+TtVR5NJr9HDF?=
 =?us-ascii?Q?6NHW+4P2dUiDqxpy0UNPRj57o7nbOY6nSiGDeG4ec9s8jWQNyoP8LtqHammh?=
 =?us-ascii?Q?sUiEVZFfQS0YknvJ99i91cZnA0DQAjVSJ2Nl6M5veOPSHmNIuD4zieOJJWNj?=
 =?us-ascii?Q?gRVc1whlUgIm8QXCOKCiCGmBKBrAMfGX+NkYcyJS6KkEwsUUlVx52Z42CEUc?=
 =?us-ascii?Q?Jw+TTEHPTWca10Fs+go3Z/SG3SGAFgEdHznXLBUgpf4Oq2v7e6GEowa4U9Cr?=
 =?us-ascii?Q?UILDVBDY0JBl/VAllvp6Oiu76fD0otwwt2Uxqwx0gcwakH2vqlgNolAefd/i?=
 =?us-ascii?Q?c86tyK1oCIFcoDn/hJ1WKKRpGil+zOczluWEyKZjLkr2p6mELembjvaLi+x3?=
 =?us-ascii?Q?uZhgLTtatzKfE63Ul13l5vRcR3QRTWF1KByIMWaDKCEOo8aW2Nj+3Eeh9Sdc?=
 =?us-ascii?Q?w4KSh5CAoxFWgXdVD7Q2skJnfuXjxx6t4CJqeiBEANxAAKFAtFGtMCCGKpiX?=
 =?us-ascii?Q?XC0s9KvXAyGXFKDzxrRF9i6SGK+ZsY0BgkE1nqB5/zOULytwuvdJ2IEfdc9T?=
 =?us-ascii?Q?JYdRvq/UydKDDbKSugFFRBiUHq+5RG5woWpWaqGxwiw7ZR2idIfQdRJKFOha?=
 =?us-ascii?Q?u7ZJ4mAxXwXGhSGCnOvbsuvz4DAFNJj5mK3x0D7JkhznkitUI74cZEnh7fLI?=
 =?us-ascii?Q?KOfKsl3m0p/tge/ihwxtx6aV210vERQZk6a+8Q80sHgDcoR9b8Y1+RsJb/7n?=
 =?us-ascii?Q?GoGJZ918iXClEZc06qcOjpaX92vMVSllO4e34NISaVK+FF+g+iCT5ohXq3oO?=
 =?us-ascii?Q?ACpxSaKTVmoHvrpY4TV70iEsALmnZxOXWeqSa1RBBvQZKh80vBQ0FoJAiaK3?=
 =?us-ascii?Q?LcHDSlzUQyqNrPpRCsWDvK/m2/GB+3ko9llliFmNi+t5ytrtsFBSdabkHeyY?=
 =?us-ascii?Q?ikMSakX1hBLiANrGsvUtWyLt6y8yCl8Kk/cJDxhDdd/a01TBUHQyTbY6B0Im?=
 =?us-ascii?Q?93nt1xnwhoYeIpNsFk1OiqiBh4/gbiS04SVIPtDJJnUVOD9Bbb16vSr9tBU8?=
 =?us-ascii?Q?+Cql5E/DfSFlgjfM0shtqW70LciDmMWfssAGKOtLWcKxBIHOg1stSKUbPE4L?=
 =?us-ascii?Q?zXGtpYBFhDhAyKkW5eYg9YnVOI+knZS4zuZQ4FjmY18i43E6TN0w8UdVdJNs?=
 =?us-ascii?Q?PTNcGQT6ictDZdHouVAW/KHoy7sPKj5UKHRRQ7dB/igQ1/9xK5pbYM66DGIz?=
 =?us-ascii?Q?v2zbETteRl3O/6Bl0lsEGm/ruYx4VfzJOKsBl4GEOiMD6Nh7n+xHVyNv66tD?=
 =?us-ascii?Q?+IgdiYS42t3adGfDbDd09N1ndGbNVVoVA3EHOZrz6YonX4Cpb6MEq/y0Snwb?=
 =?us-ascii?Q?VTTCECiibVihHDKib0aHfJtscRWzI0Sp+SbmrGD6uf2tUr0cusRSN0hH8vCl?=
 =?us-ascii?Q?ETZJ26heOQYZwLDo9RU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g4/XR28JnlIBhEet+pUVjEZ0cNefZozxqWNmFVJjjikeP2WJRTNyc2bClD6e?=
 =?us-ascii?Q?Rgl3nxcRPLrrbJcICmVkfb3eGxPA9TKZt25p6bn0HNBWSNzl+QkEaY3ywz0l?=
 =?us-ascii?Q?2aoTOZ2XXCouBbrxJ7jFqI8Zi96TFfSK/SaEItW/dZF2NRNTWHn6ATwbs9mZ?=
 =?us-ascii?Q?L2sY35NYr8b8JFC/GySLxirCaDgh2wvBrsTmNk7PelFYm0KVGYyb01wpxbiv?=
 =?us-ascii?Q?39g6qyaqSD0rddQIskC3d9PCfijvjvbWFKupAW7dtGGM2jVPJTw5Q5Hgw0DH?=
 =?us-ascii?Q?RsUXa+XivnHCGVZyJGAeMuwVVHYp6bwB1wmmihUS9prxsmoxogb91lkQk7Ib?=
 =?us-ascii?Q?fiGuI27RsrWHGMuYXLJxZG2VQMpzDwZZopAlufoEFbkCFwmq4EK4WoFTjgnL?=
 =?us-ascii?Q?8/8EfwoP4LhI7tUthNG/29NUr72ljlWcAB/9VRAXU4rFQ7T41qt9o9aiFyCM?=
 =?us-ascii?Q?4Hl+guUeRVb49l3Xeb1pU0+k89rIOYcsHY3rxZ8bPlVq2jMBW4tiNd9E9vju?=
 =?us-ascii?Q?Et+J+LyblT6j4T8PruyaPaDn0QypdIYKNrjrNmjOsX1uj3yUzB5ccW4Q6pQf?=
 =?us-ascii?Q?n19y9vxpIpzsdr8XCdzY9vzjLDzVn2luqL7SoqpTKShUXn1aqyZiygY6ZFLd?=
 =?us-ascii?Q?s7oStIM/i/gSvPjhUuvXpazYZKqhYvU+NP7C4UCiMLRdIS23x9/W+hWgpjOW?=
 =?us-ascii?Q?LsVtqC2DxM95c0wc9EgvYxd1dRdydFE2lGZ8qbKrPqm+4VE2cR7vPbSQChlV?=
 =?us-ascii?Q?1xgg1fpnNbTfQJlRltQH9q1Vg3k0IIYfvrsNJNng4ofG6HDhdYFVDkzTIeCQ?=
 =?us-ascii?Q?E1wmUJbG2+aRD/eh+WrfhKtKUfb9SWQi5giuh6N5gMSr8kGc9qJmbEbkufGm?=
 =?us-ascii?Q?klq2y+NfbQFUHHpqVBSvbqtFiNEnUVbm2MmrRuqHTAU1kgiOxWwngITcKGTB?=
 =?us-ascii?Q?b+vMNolwGr0Cu8mxnZMdYjjfV6nY3BVcOiJupqdhrAkdGbg/Zjcvuyxyt0LL?=
 =?us-ascii?Q?vW+76w3RuBFwPbbE+WbRg+X0BYYDBO9ijgFrvvD/u6ESYSJe3JFtkCqBdgEz?=
 =?us-ascii?Q?dzrzSIyAwpUJpjDwhu9ror2ToOsfjO/XNbuzAr2ricl1/VyokO+lz7uE0EVK?=
 =?us-ascii?Q?gfQ7OPUonDhuTz/CEmbrHCSfhhMQpw6cBEFD2oDBS9vBlvATXFg7OjDMtheB?=
 =?us-ascii?Q?DmWrqfRgpQ++JNwf7uUt4rrTiqaUHYajfrR9NjKea53iv6p7qYZIe7A4IHkS?=
 =?us-ascii?Q?l8xbeSSjiMKTYpuZvjL/nNz5XXVPeNW3BlFTvx/8PITO0FwkRnF4mSfGnZfO?=
 =?us-ascii?Q?5NfPmz3/Wb27xqYCa0Aja6jtqISjej+Rk1o47DPwUWG2JcXYXM5pmfk47CdK?=
 =?us-ascii?Q?cU13WslAc/QbdRrn2WlpXBbuG8tP4T75pzTb0JTsHmT/VdtjnvtyPRWqxewl?=
 =?us-ascii?Q?Le2WYXStbx7mFdbLBJukdRKKrcYK/C/uZ2+Vn3J9QfBZVOVfACPbSwwjXq4i?=
 =?us-ascii?Q?GMNtR43FRpGYhhWrndS5VtgytD6vcDCUa4enAh0uTucTJaIb9l3b2cTVZaLI?=
 =?us-ascii?Q?29yej/TJpBIbtmtFVI/WLxzf13JUpoNJgXwnsWDhta9zRknyFCTLjxEUQXJ0?=
 =?us-ascii?Q?oVai0fHK3WC3cAlUYJn47AQ9Pde+WX/YKJxvEDjhZ+Ka5XI9AMeq7/mXT/CJ?=
 =?us-ascii?Q?NT0i9ByDCGeegXGWxTgujV6CUGzcY80Nf0qDWmuWP7eX6oDLLvm3mkl7KfVY?=
 =?us-ascii?Q?/BSZLhel+Jv9NrGtKLBK21UE1jcjcSI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qhKwwu14KN7QjGTIyUpjLQtf22/Tag+YRAYIHNlRbMoqHX+M4VkmOUYnVZp3YGzix7YYrL4cuviRnVmT0lSHnlkk8L0HpUsVe6US3WFahRxGPY2C2RIHIZj5+B817k8PMngVuY+4OTMbSw/Uu6ICkhm2TqNPOcGKUG/dRJhRhk2YArMmgfXJoiMkhIArKN5H4eZlEadC/EI/ejpREA7sPSRFKYpi5GkvqvuAPl0MNbXobpzELz/4yO+n2n2OaZ9FMJUY2hWeLZxViQ4FM45TFcWuFOQ4tOdH/B+qGmqinleAnNB0VMOoUtNsRldP+kXHcBBd00YBJ7Cn88sXylTWkKKYz2fjB0wngCBdoHm+2YFDSIIzPhqK/wP0jO9corEchTRRw/YWlvh99Wyq4xWcYDVWTOu9rq8JJoYoYSzfigopHyrscJ3cdxCZu/Q5d05CwI/b/JG9x2UtYP1vmahBOJ8LbyjQ6BjqxKI7nrQADUgPKzgVGKvWHxwy35x0vQ/bBqbz+WgFhuBpK/7x6ULpKD39z31AQlHh4iOPH7PdSYINEQFgiOW3gzG8Lnb2nawSrbcHFKOTWzHBD2NfGh/ysWcbmbX+3ZiyasofaoVPY1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5b9cc8-1fbd-44fe-cab5-08de59b4da27
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:42.3401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GylRAU/9rYz8hsOVW/95SldPVTG1xcj1Fl0EWh9Z4oZHHSkA8zNfgtTgDeySCqYJlsNjysJO8Vxfv7WjEAamXFwmzVuAmqHyfc4NeJaVZig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfXyFdZOVom3dqb
 OFVntWHG1lwIg1QFg5v0uAegce8XlhUpMepYj0eUcORX5oN53KA4cqoRU+4uPcZfeNC+QQ7msA1
 6UHOjDenrh1WeE0dyZg0mHY/VGrVT2Za/1Rf7PFd4cUE9hPPXM+mnd+QYX9H4pHcGE4sBRs18wQ
 5vdW2qtk/CreiJ2dESxotIrqixSFxAzoLnjbwHbFYhQRgEVLaVv4XAC33ku3ea55PLZGvwbeUKz
 jkIRP3zAWsj6mJjS5HQyVVMtPI6eEbUxVAK98f+m1OncCjIuGn9rpPZeEbtW1MM1MLpgw8t1fEK
 ZlhxTgqbRBZmU4EfLK0gkKkTi44ohxadoe0R+WIrkx3wCcd0kX9WalAFxXtNIwJUYH3VmRYIzwY
 SwWNZ9PYr2fUjl7cKeW3bSa0TrgfKQKXzEOA9QwRilpNN1qMUXfaxE2E9KuVQWE+oV1QfpXDMsW
 F0+m7MlcmuZc6gyGtCrJ+eFT0ZPolUrERhYmc8gs=
X-Proofpoint-GUID: gApXEMuUyZbsYNMtSKwl8IJSeXuiMQNM
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69721d29 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Qfc5p1S1sjZ_rCI9KBYA:9 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: gApXEMuUyZbsYNMtSKwl8IJSeXuiMQNM
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A5D6A0015
X-Stat-Signature: 5sh9bkomckqx1kg95jwpcdydam41p58x
X-HE-Tag: 1769086260-438452
X-HE-Meta: U2FsdGVkX19B/ZK0RnXbw1nPVCdvENqPop08UP9vSe0jjHGhsRqNKtt7V8OEBKk+4RKyD4ac6XgA0DOJiI9chcK/vUMdaSNKEb0KHE0Q09Aw8cxhAwbnT1C46Zsjav+5s3DPUsTBEgkINAX5e/1HFA1Zf837r0pJby9l4kK1KnOTnmNICCkgy6/C0c84rdhgFrY36DB/Bw4xa92dNKhHBO1BBbQfyltEM3Fn25x8gR2xiPw3YilZTH3bnMhHn5Ow87sbw7DILVIxjb94lJhKqU6Y3i6Y9r6WNWbfXuECKECxDiug2xtOkfVAwZxL1yntoWCiMVTjgDRz2+82CbHdBTFJnMgnt3UIH2onyC6kWTbxCSA41AyVb1P7cBSwgWDD3xnQ6wb995wvd6dHjxhNUSCpnyu31lRprbwszr6j8mgEkWvD9Xg1gsGcd58hZ0P4pGsIRvIN6wTjL046WzhJrCD4qavTTNo8O7OfxBhIawqfBtWYiLtrKAyQuZh7M5TcnG0YOnKBlwq46RBpjiQbpRhrN4dkpG6AbHKxN6Jfnaoe4FJZO12eO1RCx/VtOocx7KZFPbcQlYzQ/3npiOxuCfGUL0AoVxWo/74LO7jNHdqwjLyCEVaga1m7ytxLw6OGZJZCKTpypz42dbBlShKxds6BvtNX7VJ+wxZ23qR9T8rONqsV9XyF7/dUmJohYfN1WC7I5yfLgRz6swlNud/pEjvzdPHbFb9Snv62PnrL5hYr1F4YaS2ok6z18rqOyGtCz8xAtpLi7cbPXCaFOlf9b68u/k/1xD5H4KokLzqE67YO0klY69JT6Wf3KQ7VXh1BpEWtHApVB+9KWKu3A9blPtLxdyELy4Yi5exSO9H75QR6nRTh4gHTI1ZO+qOBd5gYs8VQMq5zB8nz+TdsyaX1redQhyRgHA1arYUQlnc+1nEPWsIvOge9abd4X1rg6EZmNCNus0rgiFSkYJaD2Vk
 VsmLNhbT
 euTzgcnUGK+WtXYhnlUF/nOaLSCnCv2CXLsbDbPVc/vGBzazgID1E34oDv4LFkQx8GQ8YVU88SJpXq6kx62PwYzN0NN0ymjwn/YpQZ0BbUcQ/p5vpBQKE68O01s08um7z7RCcSgHbKoekuKr+/C04go5UOb1+5SKT+ie7kp1c2el33MLcwCW6bR/3KzRTQLOl5X7mKpjtJ97WpOC54U+K/BpUKpZkyxIprLAlhGxxkgF9VpUPLiHcauj+MoBpAQScYWh/s3nqLsxsxX1vdpfxQKRX1Saw54GHC9ubGzIzXnT5MBr74Vtchwp6FYH4ui2jllmCp2SdY1mdytoIdJePqsChpx4xiCgzYMsF84IoP/+wrS8miBpJzAFZBc/f32KeKOck1KqzunmckrNZHSihG9cxKXkm8imsBk9Gob5UU3iHS5Odf1SddZma3RALpL5yZpIt+2Lc5qn49g33gstuLFmoC41CKcnsCwEAnqiDhN87ngUqj3Xc74rihxkJkODwbEprlTXk+dlz6v00aQXrRORyA2pFnknjGtVT95W61EMCnWerDsGNCbGBMe4UUcsIMlbFo3Gcv4DiLY4ddDA+Kw6tncQ2NbH5A/cdYsXFpJjRPT6zWUOHDRWocWabXzEJSnE/bmeJn6XQ4q+dML/UmjGcjmplV4VIW/VoyPKLNFF5siu9dd44JT9/pBio8KDSzPkZvtIwE2iPq4o3cF3t0S6qkDxCAOENZG7MOqqpKP/NruTQIDpXa0QScRzb+hFU1WZJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions are very confusing indeed. 'Entering' a lock could be
interpreted as acquiring it, but this is not what these functions are
interacting with.

Equally they don't indicate at all what kind of lock we are 'entering' or
'exiting'. Finally they are misleading as we invoke these functions when we
already hold a write lock to detach a VMA.

These functions are explicitly simply 'entering' and 'exiting' a state in
which we hold the EXCLUSIVE lock in order that we can either mark the VMA
as being write-locked, or mark the VMA detached.

Rename the functions accordingly, and also update
__vma_exit_exclusive_locked() to return detached state with a __must_check
directive, as it is simply clumsy to pass an output pointer here to
detached state and inconsistent vs. __vma_enter_exclusive_locked().

Finally, remove the unnecessary 'inline' directives.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h |  4 +--
 mm/mmap_lock.c            | 60 +++++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index da63b1be6ec0..873bc5f3c97c 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -209,8 +209,8 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
 	__vma_lockdep_release_read(vma);
 	detached = __vma_refcount_put(vma, &refcnt);
 	/*
-	 * __vma_enter_locked() may be sleeping waiting for readers to drop
-	 * their reference count, so wake it up if we were the last reader
+	 * __vma_enter_exclusive_locked() may be sleeping waiting for readers to
+	 * drop their reference count, so wake it up if we were the last reader
 	 * blocking it from being acquired.
 	 */
 	if (!detached && are_readers_excluded(refcnt))
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 7a0361cff6db..f73221174a8b 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -46,19 +46,43 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 
-static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
+/*
+ * Now that all readers have been evicted, mark the VMA as being out of the
+ * 'exclude readers' state.
+ *
+ * Returns true if the VMA is now detached, otherwise false.
+ */
+static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
 {
-	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					  &vma->vm_refcnt);
+	bool detached;
+
+	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					 &vma->vm_refcnt);
 	__vma_lockdep_release_exclusive(vma);
+	return detached;
 }
 
 /*
- * __vma_enter_locked() returns 0 immediately if the vma is not
- * attached, otherwise it waits for any current readers to finish and
- * returns 1.  Returns -EINTR if a signal is received while waiting.
+ * Mark the VMA as being in a state of excluding readers, check to see if any
+ * VMA read locks are indeed held, and if so wait for them to be released.
+ *
+ * Note that this function pairs with vma_refcount_put() which will wake up this
+ * thread when it detects that the last reader has released its lock.
+ *
+ * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
+ * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
+ * is permitted to kill it.
+ *
+ * The function will return 0 immediately if the VMA is detached, and 1 once the
+ * VMA has evicted all readers, leaving the VMA exclusively locked.
+ *
+ * If the function returns 1, the caller is required to invoke
+ * __vma_exit_exclusive_locked() once the exclusive state is no longer required.
+ *
+ * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
+ * may also return -EINTR to indicate a fatal signal was received while waiting.
  */
-static inline int __vma_enter_locked(struct vm_area_struct *vma,
+static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
 		bool detaching, int state)
 {
 	int err;
@@ -85,13 +109,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		bool detached;
-
-		__vma_exit_locked(vma, &detached);
-		if (detached) {
+		if (__vma_exit_exclusive_locked(vma)) {
 			/*
 			 * The wait failed, but the last reader went away
-			 * as well.  Tell the caller the VMA is detached.
+			 * as well. Tell the caller the VMA is detached.
 			 */
 			WARN_ON_ONCE(!detaching);
 			err = 0;
@@ -108,7 +129,7 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 {
 	int locked;
 
-	locked = __vma_enter_locked(vma, false, state);
+	locked = __vma_enter_exclusive_locked(vma, false, state);
 	if (locked < 0)
 		return locked;
 
@@ -120,12 +141,9 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 	 */
 	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
 
-	if (locked) {
-		bool detached;
-
-		__vma_exit_locked(vma, &detached);
-		WARN_ON_ONCE(detached); /* vma should remain attached */
-	}
+	/* vma should remain attached. */
+	if (locked)
+		WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
 
 	return 0;
 }
@@ -145,12 +163,12 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	detached = __vma_refcount_put(vma, NULL);
 	if (unlikely(!detached)) {
 		/* Wait until vma is detached with no readers. */
-		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
+		if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
 			/*
 			 * Once this is complete, no readers can increment the
 			 * reference count, and the VMA is marked detached.
 			 */
-			__vma_exit_locked(vma, &detached);
+			detached = __vma_exit_exclusive_locked(vma);
 			WARN_ON_ONCE(!detached);
 		}
 	}
-- 
2.52.0


