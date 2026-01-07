Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9833BCF6BE8
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 03:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3456B0005; Tue,  6 Jan 2026 22:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D606B0088; Tue,  6 Jan 2026 22:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DB86B0093; Tue,  6 Jan 2026 22:28:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D67926B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:28:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F9FD1AE008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:28:33 +0000 (UTC)
X-FDA: 84303735306.06.EB33846
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2881CC0003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:28:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Gww7+IW+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xg7rV1S1;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767756510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrXhYx4R+0Y9nVviHXIUhiG7dSLqG08CFK6ZDr+tavA=;
	b=IJwO+yhiClml2OQC8yCrtnzDGLwzDK8ORO1sGPl0aQKQ9t+6m+2g2XZjdUAtmX3t8X6BjD
	U2YFkKyt3YGtaSmuwZLmNcr3+unkF2qvqdmiiyhZyDFv2F4PiAJ8w4KhXWXTwqCEEqUq6u
	pIWCck/ukEuBE/q2aP9FibkzAuPfVO4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Gww7+IW+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xg7rV1S1;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767756510; a=rsa-sha256;
	cv=pass;
	b=y4lt542AyibIUH4nsrC+0fvmrB0qGm9k0j0Ap0eC09b4FlJwEjCRFHLpYbM6hup5tb9wB0
	9ldntTNcuoY4nyxvr7JXPb5Xjf3j/wGY0MMsbjDfi74T7/7ecxQdS4MjbI0QKbsYtsOKdb
	OtwwxCsGgss0C2K7W8IYLlby08tm5+E=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6072tjDJ764645;
	Wed, 7 Jan 2026 03:28:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nrXhYx4R+0Y9nVviHX
	IUhiG7dSLqG08CFK6ZDr+tavA=; b=Gww7+IW+fI5iqOfZZC2RAh2Uo6CDnPv7j1
	ORhW7ExM63bZEeXAFzGMH41aqY8oi2wvsOS6q6+941kOeC8JhfqITJEfwF/lRoBp
	k2mnL2EgvXCc66aP6HV6HO73x7wQoDLMokt2dJF2emNdDOB7+Lh2q0G9dVvHD6t0
	hLBA/4THkdFZY8Gz1rPqP3wLg4vemzvVYfh8xHvylRhDasZB/U5kfRJUccRQHQAH
	SxzmVHLWcnyajYGCSYcRTQOj5UkOSTn3CEGuqlbBN+Kh3vyP9kw820WWF+19Sc0A
	h5k2m9GA6A9gYoLSdVnDsJo7HSs6kTUfMRLSXzzjvrfqS8ZMSYrg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhf4cg0rw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 03:28:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6071EeGr026751;
	Wed, 7 Jan 2026 03:28:22 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj93k1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 03:28:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VIFfXYd4TKAq3PnxHZXmtOEWqW2tg7sIFlj0cZZxjtYAk2E5fe7nQ7Ibx8OaU4fPSq6sAocy5FiFxwXD90a298s6Rh5yJ1KhZxtQgsm56Q118X/2yv+NDKevxzhXl8e67Zdj3v/M5PtSfv/7EkL3iEDw+f8g98Qzq71A1kTyxnBGL99RSshJYqqeVYo4NwHXcGnU0EvOLKb82rDkBapPCCZw6LRfUlS80tqnofZtF54k2gOCpwHPXXbrszw/mkKyNstgpvKMgrY5hTSUalzPFMm+GJY4O68ik7rNOgoWERrOBGajYBkwFp3UPXy7hjEoFabhVF3BHcUHuJ45rYlnzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrXhYx4R+0Y9nVviHXIUhiG7dSLqG08CFK6ZDr+tavA=;
 b=fYsqx9PH7lyeY+HqzjsB7/NUIJD4LL1zA4CALqoqrgPw9uyOCxmg0lYtCJQrssYg/X6FTBLginHK40+WB1Yg8Ra/H2ARVMtUheQXkiP0ZY6ayXIF9Yuos/v0190PnywdHBlWh2AiVGnhiEB94HKFDYRFvjb0LV+uFOwEcrbTdm0Fmz8SikiFXyL4CjJQfCyQfYmIm3pwBO1O0Y5EGvbesXEvGVNLAJsfr/TVn0+2DmPrC71ReolRQFeuaVKtRBpSbP/t8y/IPxwFEqN2pgB/gA3fTydOJmNA2zrRZMVfTPbLdm6ipWlwfPFOcerGiFj51p7chhgMQqsmYKJd+cD+pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrXhYx4R+0Y9nVviHXIUhiG7dSLqG08CFK6ZDr+tavA=;
 b=xg7rV1S1NgraEXJLbRFxLE/YDr9NWNT/wyq/SB/WLP4w6/0yXPHR3P24YJFd7IctVLX0U1OAe5Kn5sviMUzuNJk4M0b6xQpVg6xMWFsuqq58OmxWo8jfAUzukqAIdqEnvpk71wLqQ2ag+zZ0Hpnz75JkBWG2wweMuK8EaUuxWWc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB8204.namprd10.prod.outlook.com (2603:10b6:408:291::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 03:28:15 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 03:28:15 +0000
Date: Wed, 7 Jan 2026 12:28:06 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: stable@vger.kernel.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
        hughd@google.com, jane.chu@oracle.com, jannh@google.com,
        kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de,
        ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com
Subject: Re: [PATCH V2 5.15.y 0/2] Fix bad pmd due to race between
 change_prot_numa() and THP migration
Message-ID: <aV3SxoHzSy-5vo69@hyeyoo>
References: <20260106115036.86042-1-harry.yoo@oracle.com>
 <3c1000ae-6c4b-4b03-a458-e74edf64db8f@kernel.org>
 <aV0ixeDusgafhonV@hyeyoo>
 <6e17dab8-cc85-4d68-a7b0-c187754572df@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e17dab8-cc85-4d68-a7b0-c187754572df@kernel.org>
X-ClientProxiedBy: SE2P216CA0064.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB8204:EE_
X-MS-Office365-Filtering-Correlation-Id: 759c7dbc-e1eb-4d97-d201-08de4d9ccad1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?35pyWs1lyhry+hXKGKpYIvzJHEYysfFDsaxU7rl9YTeL4lwJPhUdQHR+T+wQ?=
 =?us-ascii?Q?UX1jtQGVLcB7+/JFXo8/OLc4RVREP+pMVgM15hpUTqEezURH9+wI2t6JY+P4?=
 =?us-ascii?Q?RDMgHIowgejyuYvKZBqHzVHx8uWOozClH/nRwy46ZEASJ9x3TGfUa0P2zE9L?=
 =?us-ascii?Q?UoVlNiZAsH8LK8FD9Ib0gVcBOUKhcflsThkMTFKeoui8qqAh7EW/a7ftGtdK?=
 =?us-ascii?Q?dqURqEfc9P4a/sx32ivFwk20EtK6bU4+t91jQEgmRz+jja0bqI6NPr4IB6ZV?=
 =?us-ascii?Q?EbDDV836Vvw7tWJ6lWiZ6xzjNOE6JdvYhCkazmYZximuOXzpsl8s4cIZv2MU?=
 =?us-ascii?Q?5ODPW4/IngnaJnFZSylN4g9Tqf8xYkHX7hEU6RjHF5JGs73fBxR2tGMbSFQm?=
 =?us-ascii?Q?LFRvAHC1H6MCyWJNm1L5BHISbjUkFfMmakYr2vX6NIS60VYRq12E9JPFCoNr?=
 =?us-ascii?Q?XPNm27JmnF4XLvhLQFAYFoQmqTnkFTLrx2l8g0vw2wV3wkrhgjfcprrWBV6u?=
 =?us-ascii?Q?34UnsbfRq2aBdQELW9U7jsBSI/23YA3EeFf09x8Mlrim32aLwn0JGfv/XI7Q?=
 =?us-ascii?Q?PL/RZFlHlB9YfGlk08AfiUa5mb/TsXo4AvOa5hYwX6CIyN5R5+Vy30hrXTKx?=
 =?us-ascii?Q?HNWSewKEdS7fSXJk2JuRMrh0yh9GrVXWO/j+kOs92cIze9J6ZF4lglnBwSyQ?=
 =?us-ascii?Q?C5Wo/sMFpXST3BKBZd6gxO2X0Lrd9dPYp3iVqtNe6kuY9HcxxmZPlyUySD4P?=
 =?us-ascii?Q?JzwgaoJgCnyJmCKKrg1LDo4vE/k0K6rX9BY3kvOs4mel1sGTlXBnPLeOudV1?=
 =?us-ascii?Q?Aed0t1hR7VfT2nVYUwt6N4F45HUGZtDr0flJCam4R0nkm11C4fM08SKjjh0m?=
 =?us-ascii?Q?MEbvisWmSsYIUBJZjITMLb3bWB+Ee3R06uKwohzVopANjj4Usxrkwz7kBq7m?=
 =?us-ascii?Q?Axdp7xXnEGyrA81H7gJZbc/GWy2cxvDmN1PpmFPvuPHc8PZRMUQ379IlOdtw?=
 =?us-ascii?Q?kANs52cAHdbkDzO19W2dpAjQZf54RgH0RV4NJcHY5WeamcLWgbMwP/nOQ08n?=
 =?us-ascii?Q?L9mtCxNOKt7if9ERUop8zRsY3ImqFcZyqsVLr06GtTWIdWhiH02o4UFrGQw0?=
 =?us-ascii?Q?P2doNs5yPzofNcGXvpp8mKvmhjlYic1X9qSVHfpZ0VQKyo3XSZqeQ2z2mFWh?=
 =?us-ascii?Q?czbd/iO5v7FY1O4/2SQG6z12gXpjpCJ6dxgXkLI5LZ6K8vBYS+EEX+RhctyG?=
 =?us-ascii?Q?a2TO08/6aKgc9f2kONLFxqEGvqoQAWAql8hPFAAqMmjLlllY0jlnSm2eFq2q?=
 =?us-ascii?Q?s8DDRzuEXmkolSOYuBH7EsfMfl696sRRqfTVVtXhc/YrCZylF/rPfzWhuoav?=
 =?us-ascii?Q?q2WHk0fEz1eoiby62nhHCgrp9/6CWXbNWWV8/woFvCHrQAd79Ee8K4LarM3n?=
 =?us-ascii?Q?UbKzirF5Hn8G9dqFcxL4l8R28S7LRxLoM0IugpTVbo03eR2s2rc47w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PZArpbUuIZrOidSreUvK55j/77v+TgK/DzUZGEiyGZCgxLPLxjb8DpaNcIub?=
 =?us-ascii?Q?uZLbjkiyohcChH66iB1V2EdqMVEJpEEyg//TC8ggJCpp93LJgWGXg1dVUw+G?=
 =?us-ascii?Q?QBTakKxixxnjzX+nONSSyqkzEM1HsLt9blm9gxZcHzqLrHBbqJLBjyxFsOIy?=
 =?us-ascii?Q?Y2l/2DioOxjvSKYuSPbJYdNxYVX71mrjlpvAyP7IAwbjidrYV+OCUEC0Kw5b?=
 =?us-ascii?Q?qSAeUOUfE08UFNa9TdFvo8VgHIzhR1bfXrMUPc0Dc2TcF5xj1qi/RkrfPlH1?=
 =?us-ascii?Q?HbNBIL9wubCOrQG2uoWdU7qJH5HimmqaKzfBjTZ1MvZmIp53K+A3k6fHw98W?=
 =?us-ascii?Q?FjnM4x8ONcFA/LB/W23LSx18FKjGFKltmgMOsQVCP2ULbmwzJPrpaqA5+LcQ?=
 =?us-ascii?Q?U11qgTIFU5JL5U/tZxMyGV2bpjzs+667IB9xdfC9UCNLaG5ybFkgOK95619f?=
 =?us-ascii?Q?qGnMIRL8V61SskAeet1U5NuOZhfp5GZS4y802YhSwg4Eftl8qxMhJDNg/gdI?=
 =?us-ascii?Q?zbzqw0NUCnH/MoOKvuhMgMUdTAL8Of0CVLaXv2hdXimFtfu9QDH5P/0Mh6em?=
 =?us-ascii?Q?7TUEt56MpiWq6eEOEXFwH0A+klWcVDNdWbbgsriOozVOBpwX0i71wfd1h6E0?=
 =?us-ascii?Q?jOrTSAKlF9q1UY9GdfD8SVpEZFsIbXXdGUB5PwTkp3wWHTtniiJEqNO6JbUN?=
 =?us-ascii?Q?KWAyXjQ9/Z64lu3u6L554nFOCN7T9/XbRXeDJsYD4E7OJN7fPUMW7olWwT5b?=
 =?us-ascii?Q?Nz9lL2VAXyjnUUj8Ay9BGXGDsbRs5ccP40bU+8Hoqg1f71eOVYfJHwkSWAJX?=
 =?us-ascii?Q?cGn+2dng8G4B1008pXB/9nT3DWsofcQipAFC++HBI/AC4cB3+QuAxgg2AAzO?=
 =?us-ascii?Q?KCNqnF4KnrLgP00XuwYDiZ7PpFtb9S/RkWt0E1KjRJmqVxh5rte9TwRrNUyW?=
 =?us-ascii?Q?LFyaXwGRt+plEfdZYjAuIMgCjqa24m2AKaNc+64JK31V3bhCkC6eV2ALuI+i?=
 =?us-ascii?Q?zDF4Hay0KqQqyuuRaVy/DdAFiXBr6ZXbkJMBxKU69oLD1YkSIvQ3gFHCiTi9?=
 =?us-ascii?Q?VCBpY4b59Nbwdlj/atxf+Usy5iLP/IYKGddOafWyMRqGYYcPR7ZI3yktqBpR?=
 =?us-ascii?Q?ndP4jZbelwpZXWF3iB3/i1ZI+E+tS0iTVyxvbEW938NT4Aj2T87MNkJnXylN?=
 =?us-ascii?Q?hlJKeeeP4vtjxeVcNkY4PJ4FYxtZMX/5YBa066kViXBvKQ85IxQHkE0F6xSz?=
 =?us-ascii?Q?3XHKBowlEYtrlydN/lcHq3G7vOZdNm+KMSFW0bKCicvW0TKwOrqjYtzVgVLQ?=
 =?us-ascii?Q?UjTOuTSqwpv5XjhbC5jlsOFWigQiuoLVYKENQZ1C4AFk98tER02vfWDBKQiV?=
 =?us-ascii?Q?gln2p5/uAT6ToqUxKv7QQXGhROrmZqo4ztSgD/i+7rikJKzQEEkqg9SVJ/mI?=
 =?us-ascii?Q?JnM15tAUomU3L/gLwFWWLSWZR+iBz4x8I/MqAtC/tgnOZHmx9oPPokFUYrWN?=
 =?us-ascii?Q?KapHqhMw4ty2/tctNRTq9cgzlisfSk2FUr+ZhF44IenFZltukfqY1O8YzISl?=
 =?us-ascii?Q?WrRP+cOL8H7G07ALozECZKXlWoL/Uu3tAGjQQZXVKi3AwP0SD3HcJcy7nKhH?=
 =?us-ascii?Q?vv2TtlpDgLf8enh7EaZxmQethjXrfXsCUJoQZi0zFabrvIm+dRIQ+qfaTiH4?=
 =?us-ascii?Q?2C8EqgzBeohPSIv8tfacn5ptTOaL5SlaoE6r4xHTIkUrEoZrt5e7/z4lYKtl?=
 =?us-ascii?Q?4jW5Q/OXtw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M+1cB05J2y2q6xJPrw6Ue/E0n053DLTBYCAXYWRDCWpAIoCKr9O4P8QhVaeZEZ9mHxu8WDe/INIu2IRaD3SCeg/hQAJrPgOAP7uCTPWnVmTgnOEmUKNFrSrHOmFBtBMR4W2uzbE3pZsJcLuVRTh4TTWUETBtcg1IgSQ8T7jo95gJcWqBGwglkewg8hIN5DT/kbzJjPamknJTk+cSRZ1dRilQDMjPbRZMUEmCrtulkZADkS1q/ViKEaw7Dao+nUB/Xq7mZPFYkh2Nt1+do8vPVIah7da+8yGVcd+32RTqfZu74taKMd1YrwEUwlJ1CS3ZaHKrYlRt1jYOfhPMwbuy6kEaaflzb+gwfy7QacC029llcPTd3aq233oRGyixzn2uOLnChW3xE3zsKa1awvOew6qg3Vqqk3UBQGias48BaxaamJLXUaDhlhyBEpRag5+PESCNL623sf/uXfG2w7BmeFFmsJLreqX1HxjZZjLN0sQOo9n6K87N+0OSLxqgammYhso10mrffNrZ4KkEi8XxZ5g9wzZ04iZ+WIu3Lrt5rUkkKvk2Oh3qiN0rqqsGBVFAiKES4CP+Owzz2xweNfEtEM4gxHITJKPUPZngNjWRiuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759c7dbc-e1eb-4d97-d201-08de4d9ccad1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 03:28:14.9264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQeQObrLGJymEVqH2aR4w/od/uG7k4TSNXEc82VeBBI920/6NiXQEpNWaEJ7f8zLiWeBTFKCFBFnENWIhTq7Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070026
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDAyNiBTYWx0ZWRfXxcQAxXOplzMF
 fTyJjLY1PEG5hwEsAiQFaw9NXGs9O7kk0vTNd/O32rTgLguJ6tFOZb76QxnHyB8sMJq5JJPoWni
 lB5/WRYQPZEpz6xbloioqtHUZSYWUTBUQd8cHFjkFURSt0D1n75SmJWKVY5W/pdMNrzopAVl0Ff
 Ogd7/v8NQ2bDIp/8YLrVZqrFqL0+Fi6kcIInS4ZHs7AuxEQJBtMbOcLA0pLOD8+j7nfqAKJsuRw
 AZah3B6pkA2Zq6WVdTN/Fki2RkDyUUfjHwsGA6GjJpRZtcfALvh9f+97Luy1Oy5HVsl4viXbcnO
 xm+8gxAXMVo6wxLGTfBP4elYanJQX4EZl8n+wqTEyL3GkamqOPZZqbAjoQulC6lHWKsSXxJsF+q
 BP6OIHADlUUK9jF+ay4hqZOQ/5P1q+YwD7xVmug42J+osLqz0JOYEGoWEE9QouuBo2+s463u8oL
 CLLUftbtulUyQP24sQA==
X-Authority-Analysis: v=2.4 cv=NMPYOk6g c=1 sm=1 tr=0 ts=695dd2d7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=DY9598DbBXQv5yfWTB4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 91w4H4kcmG76yjMh2X4wPCGc_ofLV5t4
X-Proofpoint-GUID: 91w4H4kcmG76yjMh2X4wPCGc_ofLV5t4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2881CC0003
X-Stat-Signature: 3mziugii1zb57ee1tdxgzheqc1yx7kzt
X-HE-Tag: 1767756509-376680
X-HE-Meta: U2FsdGVkX1/zBWiKMOWyHhmxsOY5cwk1BTzqmWenjquW4726pjIoabXOYbpOBjFRW13j3FJbfE1MC8N7sJxsSs7wQvmICQl/ds37fnh88Cuqpuk3WroBWMgd1ulRMHT06kog3uOMPhOlfPMswDq/qiUP5pi5tB6J4xaUZqKVtcAgyb1MsYOJIFkBPWq6coSFTpc2aKSgSwWjresSYdJW+CMTniqavzctEnnFor3N7IYe3+xVSzBpketKlhNMypDmAGaBMWB+ayxLlQeha5HwIRRv6DBywGruZpC1h6Zg7htZfFxky9LbE7PI3R1PT+3AA7eQ/kHjo1Wb1cJMzCXh9Hk7GD+gZQNlTK5OtL60XxD4+Smv+J8yBVUdxhXXJl3pVCmeFcoTFEYmaaROVJ9AMQVDWomgyIxiNj8zcJ8qD4ISTOayglV3bA48Ig5PY8jYybkU8KlwD5Fw8k4Y3yJi+60L1NHYzKFraoFmPn1ND78WL9qRhd0dQxK5khLc8B3mt8KAFVVyyB0dXPoWdgX7lDzpCtVGIt/fWRwNQJaZqcJ3L6WSlPLuulSBRFZxziaRDCANqsWzl20n7yIXUPrC89QL27Kg/TGVlyAaRTbrD17IFmDe/+AHPecUg8myq4tGhooa/R4qWHt6ocbMSn/wRiR4KhW2jt9nc3IkZmaBpbYk6MgHbT4I5KZ61gB5qAoX3D7GqCX5Z4og9IUh/CJBLHRWanaEO8yFsYxHu2SKYxHUbYcSV34YySf5x/F1rN+ib9VF6Uz/R9f4bMIDceP7K0UcWzOzSJYzq7AgIcMfxuwlqhkhjqCnGhgMD5qhXnZVmhwheUI+T4rYiLQwS711uVWddInPi4zEWfSRpVOpd6GPijEc/wV/2j6J1ywT006ZLcRT8zX4Grlu5l8a+TIL/6aQr0tkQRdHa5rn0drhLi9nsODJEMupLWWfb5bYltqqprJjjPwgFXGt+N8i9E/
 /HIGOSPo
 PEetpwlVJEAme7pSvIhbxF3AI/6tH3EgLdfzkCpWF2lLf/ON1s/DnYO82DTXHz2j4HDY2bI3k3PuV+AFSYoHe8cesb6Pc8wFwnz0KA7Po0bRvcI4eUspefeU20D8x9qWmFI79e00RBCNtmtNz2dGsRND1JppzHkdaVw/wOUcUg4Xxu6FcMixlOdTZcVuRE3vgzCtV4afTXaKdkj/FB/7cZb3hwGyBqjRBWtr5XxHxf6KQ3nupHH1hpr9bSvpYld7UKgwUVfai87XBklBz7jmSddCrBRFWMdqrNf1rpi1d/SczY8zjCRkhQ/WkwHvbV4fFhQR1f4hwLH+jbDE8w7FoDAZ1Kvf87eZXolg5hSds7RflQEIYnSOIAzwdsZtuJaZKLKp04GhZrx6gx0973xqP1VB48t1sPLv4sg+diKUSFba3VCRlqK5HuBzT+gDZrQm6cA8fAmpOyzN+zsPgsD4/j1zaDWXcddGSGo5JYFBrvhDlZp5mECCGpU4Vef3EWn3qFQ0qg8eK6wAVGTLtldZw5ZUzBQvULtq1oOmi/2cmmhhkqOvC1/eoBl6cg+24pTflF7w33J2wE6KCL5ZmBUomh5l0RAr5r1HLv01L10Y84PliNlPMMkkI7lmXW1PRkYGQ1xtFgZjyOO9EBnqWjY0yMmKlZU1fBtAH+SiZ8VQIWWPXV+gNWE6/16Xg1bnUIW8gHeml
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 07:47:54PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/6/26 15:57, Harry Yoo wrote:
> > On Tue, Jan 06, 2026 at 03:35:32PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 1/6/26 12:50, Harry Yoo wrote:
> > > > V1 -> V2:
> > > >     - Because `pmd_val` variable broke ppc builds due to its name,
> > > >       renamed it to `_pmd`. see [1].
> > > >       [1] https://lore.kernel.org/stable/aS7lPZPYuChOTdXU@hyeyoo
> > > > 
> > > 
> > > Ouch.
> > 
> > Haha, it was really unexpected :)
> > 
> > > >     - Added David Hildenbrand's Acked-by [2], thanks a lot!
> > > >       [2] https://lore.kernel.org/linux-mm/ac8d7137-3819-4a75-9dd3-fb3d2259ebe4@kernel.org/
> > > 
> > > LGTM
> > 
> > Thanks!
> > 
> > Perhaps I should have clarified if your Acked-by:
> > applies only to 6.1.y or ealier versions as well (5.15.y, 5.10.y, 5.4.y).
> > 
> > What do you think?
> > (planning to send 5.10.y and 5.4.y versions tomorrow)
> 
> I don't expect there to be a lot of difference, so feel free to slap them on
> all, and I'll briefly scan the patches when you send them around.

Gotcha, and just sent it.
Thanks a lot!

-- 
Cheers,
Harry / Hyeonggon

