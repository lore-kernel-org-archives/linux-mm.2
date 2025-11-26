Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11E2D1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466876B00A1; Wed, 26 Nov 2025 13:56:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E356B00AE; Wed, 26 Nov 2025 13:56:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306BF6B00AF; Wed, 26 Nov 2025 13:56:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1950D6B00A1
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:56:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7A70C0753
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:56:12 +0000 (UTC)
X-FDA: 84153663384.25.5CF0B06
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6969016000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:56:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VezUdDq6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="k/pVjfWp";
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764183369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHMUyV8CC70bGFZ5bpSCori8qfqbhmqiR1wQ9nq5SGg=;
	b=gCu3aTHNXSXnpzsaIupm3pbt1OuANfrXwud5pV0IloT+2jrVT03DRGGj2q/N8kezY5U7Qp
	f1xEG7FqvNmpxDExM+8FOMuJ8qvTLX0u9O0kgbPy0ChIyjziIF7CiNRdS8QZKhbHX/HZv/
	FMGs470fY/EgZMaJsUI83Aod3iKvTTc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VezUdDq6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="k/pVjfWp";
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764183369; a=rsa-sha256;
	cv=pass;
	b=HU7UvdjGBMdbbzYaqeiF2xd79HkKdFeGzd8zDO+2uJWk8XEO3cm/lvgMhjDMYz+X7s4U6p
	n6UKWNl1CQODrkbK16yiTuViXWzyGHN3wtKBiXkc05XFd368GxWp7ElVoA/cF8pGHaNNMc
	0jSCZIQZLH3y+GjpbEZUnUPCiOBPBkU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQGGbpV2686559;
	Wed, 26 Nov 2025 18:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uHMUyV8CC70bGFZ5bp
	SCori8qfqbhmqiR1wQ9nq5SGg=; b=VezUdDq6VlvZb5/oDbMSg5Cd1BeuhcrUhj
	Thr/7v6ohBrQBOCfYY/FNw5o3lNVRVyv/JV37mMwVP7LH1uf6I4Oi1XBqrBGb401
	CyPTDjg5eiLoDB+2gsPO8cLkulU3ntF/1/EetiqL0IxgX+jDGCM26EXo8Kc4/vT3
	URnXh6tfgm2v4dV8n1eDax5xuoMQP9OQbJRS2FHPyU2Y4UdL8/org2I0tF4pTjbj
	G8aTQyrx1tvsXQUlMmmBFZVpNqag/Ldd5JYAtqRXxRvgmh7lsgfwXr6tFrNX/xOT
	2Wl5kneApSgrajFTZpknK6n5YTgbnDZBBmFizfJIH0hDlBaZak0A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8ddn8x0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 18:56:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQI4aA8033001;
	Wed, 26 Nov 2025 18:55:59 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbbwyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 18:55:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HyaozOYT5Vy/v+hKDJdZTCs4HlqOtGLtnXCT/h5dgUek8yvuH5k7gC3AHfafDb1O8/UfGFkssmRsmeAaJOQwlDJxvzd/7m77rsjOeim5CVU8W5t3mvruNbrte9MKdet7aTEcWybftat6OGMGVg/CMiOwp/gYKTaWperCiPiNuKvzM6f+CFB8NAPfpMUUD7tYpamKlrVkrdjWbx3Nb1NcR33Xz2JcdAFRqurcrGmqbHhAWiN3mIndSJWy8yZe0mE3YefAFWOTuyQT3c1JaaNgsOWbWYEBjTGLCripM/mpmonjDOtH91J3OEKYMkF2a54+xedmu9dgr+f/1WdM2JrErw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHMUyV8CC70bGFZ5bpSCori8qfqbhmqiR1wQ9nq5SGg=;
 b=LFo9fJrK2q2ul2FVSL9cBDXdgMGWh05cxhJsBWTH/ypultx8lE7lyBaRWGtNWjKvovRCk3g0F8Z7jjp33tbAMAbncv7LyYPtiHgF0So8sKB9h/ExjShKSaP+BDgimQvLS2/ws8lsLRccNr6bzBcTCpCb5xhX4meNOgj5ZNvqCj9zag6HOnKmtLD0LwrpH6du3tMhPBfd6C6wQ0nCWZjbPRHv+EoHAYvDvgPEOsS5Jj0hsWFSyrTtZ10q0g1zHmJwL/5YAvXYjjIaGZBZtxifDzLQ2EMKjsXJS25WMru7d9JsRhnfp6SeuvGbLyqxZcR2Ef+lLSAeCbHiwqXY7i8ZrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHMUyV8CC70bGFZ5bpSCori8qfqbhmqiR1wQ9nq5SGg=;
 b=k/pVjfWpMvgF050j6rMlRLs+topYukOL/g7sTrnvaofnqsxkpaJ9RwgRdGXE+J497lGLj9uPTapgaoVqSw9pF6FVJfnjh0bJGWW+QOC1rPIDZIls7Ngga0pQ1XM/Y0SAbszRjc97TvmeCs6KNDpRACPauvkeLUOobmRduzh2Mz8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7100.namprd10.prod.outlook.com (2603:10b6:510:28b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 18:55:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 18:55:54 +0000
Date: Wed, 26 Nov 2025 18:55:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <d70b3309-348c-4aa9-9b62-33b8191955fe@lucifer.local>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSdGvY2UzrXdR2e3@casper.infradead.org>
X-ClientProxiedBy: LO4P123CA0084.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7100:EE_
X-MS-Office365-Filtering-Correlation-Id: 848f3f52-19c8-4f22-8e4e-08de2d1d6d36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SFbnc86OW7zuRaiCIxgRz/4FgbuDRAIwPA1X/VhavzEzLXhgXKtbNH84l3Uz?=
 =?us-ascii?Q?a0MF9I/deyXUsOtFzMRn4/whbbVmuI6u0Y34DBbxSVEpWiSVCqzJkFy0uWMM?=
 =?us-ascii?Q?d5oos9I2ty0vsaFzL/Hbx9YWvaCfIgQzGHj5FXhCgqugLWRekkUe8lYTp2ZF?=
 =?us-ascii?Q?xKqIe6qJAf+GKiPsTDj4yiyIlGK7hkGMm221yVI2ckZu7I7hYmcdRYoMJNo8?=
 =?us-ascii?Q?i9zpE4Sc8OAaxJ/HWejHXbH/Q4muszKrQ1EJ1IoTtruOHcZNJ2yeazaUpn1W?=
 =?us-ascii?Q?u5LNZhYfmNSmssd4lpODCmKEWhFASZcDW2zG4ouGYF19Iqxt+kkfeTMhoL6m?=
 =?us-ascii?Q?rSICu9ikZXInXn/tzW7A7Bm9fk6maMSFSVdPwfaVG7x1qe3GyQ3YNhyiInWE?=
 =?us-ascii?Q?8Lqch1zvSii4vH1cMhavZE3HH0gkfPgJ6qqPrSzhuaNCZKBsV8fvsxBFKprX?=
 =?us-ascii?Q?KsLZZLPGxnL91MsboeE/e8zFeUK4dIOKvV+0MHTCZAuOf4dCXj/zxGTt8nCz?=
 =?us-ascii?Q?S4xziFatZ3gtxaPy8oihqJaL1aLXhwvyrc8fEbgtqKz1HlI16emD6ejRsJ9y?=
 =?us-ascii?Q?yURX7l4pzNXR4A6YWgoQIan4+2anfhFXn0stcoaP5aLZpHfC9S5mYl0/TdP1?=
 =?us-ascii?Q?U6fL6DVOu4cbbCHsclehyBfMmuSAkjeG7ATKe9B15fqNQOvx/l2nXnAGF9nf?=
 =?us-ascii?Q?KDOkl+7myi8p8msfyXxpLSmd5fjJBK/BPEfyYub+czelzzwwXgsZclRZ4r0r?=
 =?us-ascii?Q?9qDDimCgJ4SJgcqjo0eF09pxRHQqkSJbuaKJw7SE/nLbhOh76CQ0JKnoJELl?=
 =?us-ascii?Q?VRybIa+A1Udbxk9Ge/S/27xPdwsrzjkdjat5rvcFPpA+EviHT0wOQYWWuVng?=
 =?us-ascii?Q?FFfUGL9OGncTibzzRNd+LAo38VHRiBF3sOJ57ev1i/joZCsWdrjR6aGlx+Pu?=
 =?us-ascii?Q?UsVmYySdUSy3fyiNMNkup5oGmPg+kGsU/teX8MZueroOyQWoav8+QcGZPxo4?=
 =?us-ascii?Q?C0gO4TS+uPbpni+101b2CrTlfjFCbSw3Zl9i5rYIQOwnVQgCcBrTLw5p1e2P?=
 =?us-ascii?Q?MPyTRrRdLASfmau7EDnF9ntR8PONVxmUTs+xYotC7efqdYmjBtx1g45AXATg?=
 =?us-ascii?Q?1IcbwP68z+n9x9r4JzjcUCJl8THiKG4UAIKVcSJT5HoT9TB2QJJ5He8AIDkJ?=
 =?us-ascii?Q?xMYp/+xo9puYdm9CjHxvEEZh+PKjhmWGT9vvbkqxgtMVphI90uKC2Zsy6Yg/?=
 =?us-ascii?Q?FQ1GPg5l9JEaSXZLzptj6czB6ZufBt2vfTqn+Ik53bz7UDP+UMPa+6iLKwrS?=
 =?us-ascii?Q?veReKiV6LA9GKW4TPxHWm4IJoGFjtEBqfvZJyR/ds91gwocb4e8/KCHPvIJ1?=
 =?us-ascii?Q?uoc1btvhc9ZVe7O7AuBwiCaZhYeFL0IKZL6D7MjOTeLG/9v5TZlL01yvNtSs?=
 =?us-ascii?Q?s496xf09/M7FdRNPdjrd7cHDZdFrxcT0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Un/qDhDy1gZpsYD0g9g2hXVFFe1LSfyKRpW2j3PsUdWaC8bU2Jcg8oaOugDI?=
 =?us-ascii?Q?bsE5a1YS9T6GSxqtCKKzjBfVjDVcluP7QYwokiEeEhZtkd+ZqBNaD2S9qC5L?=
 =?us-ascii?Q?wkejVqtnulw3t81IhNOgIxHRW0lhgFY/9KBr9RIqJJ9Ir7bU3pUU1sIfSynI?=
 =?us-ascii?Q?dh0oUQTuJMEEv+A6nfrCYiN24R1XmBlbdK0UXjGTRxe9RpnbCOn4/2GiEiL+?=
 =?us-ascii?Q?YuVbD7L/qJMzaWGKfrsZjq9DzrWsHdmq3kC3cD7jshjm72D8TOksUsYFj2m+?=
 =?us-ascii?Q?r6Soo/Cdp7CasUaYZyt5TfpeG7kiutIdwjaaLYNPjaK9U999f3b4rFLj5jFR?=
 =?us-ascii?Q?fjI6NEOtoDVdtbyWK3rdnMGCbmSLXT5E0DZu9Nm9zQOywoBhOI3s5z2bIn97?=
 =?us-ascii?Q?Ul4hi9dECskCQj7id6WgXz008WE0IMsAWH2lMxkduFZSYoNJL5Vvmn4F9dAT?=
 =?us-ascii?Q?tMmdKa7TRzfx67mEbhyj7JOjXhIqMEwMW9h20LszsmS52gbhygxHFZ2/1YbY?=
 =?us-ascii?Q?6+dvrg50DEZGSENwcqoUeQLx+c2hLFntGrzHwUTMCZzBZItNFzdmBTT5lJ82?=
 =?us-ascii?Q?wyKtIg8IsU3618+kly/8gDBErYfiLZPmZ3+jZ7Lyr8LFvEk0dFUV+P4/IIBE?=
 =?us-ascii?Q?m3vhJG/UCqudHlKJ05GeH9IZFG7i9h8zrwItCpwDwTprRVcq8ZriW5A6Kl98?=
 =?us-ascii?Q?MlmeI9tXfN9BXTI+vORrGFW8GN4oWywd6r4/0mafGUIVI+DKp8THrjPU2fD5?=
 =?us-ascii?Q?kMmtZ668xd3/wwXtHI5Xo2yy0BmeGiy69vbTZm7u0jltVyym6VORULMFLx+v?=
 =?us-ascii?Q?GpUjcVkVgsGvjn8BpUJxJqjTl3tBFRl/f+Yv/WXaFkexKJ/cc41hJaaiJ8o1?=
 =?us-ascii?Q?CO9CAmCDKRYciU8q72OIeV8rmWAskldiFPAy5EM29/ksDui/iQSJTdEV5yLx?=
 =?us-ascii?Q?RdLb6Zc9lFlp2jsuFdmpfSCnusPO7tj0JpA/4A8Ir4jhPNIUiiaQ2yLtZoTD?=
 =?us-ascii?Q?H9JmD3Ezxyqgldlcrgn3+CHd243kM+eo3oGmLzIgGBXk3GdAGPGbgzrklBsL?=
 =?us-ascii?Q?1ZDzgJPAA6d3ordGa22DCT1XkP6eoHNhCnX5UIKJuPdBh/abwabADsQZCavT?=
 =?us-ascii?Q?QfwQsgJX0vSyrNqzj7fyIJZyLUVC8Omci5m38zjRGa2uyaf+8TAYABDqDiy1?=
 =?us-ascii?Q?LWhbuX3U3bNNkHjmHH3kUdWVXn+TPXMSu1KPgOFOjgx4gw9jQ73H91OMHO4K?=
 =?us-ascii?Q?l77iDQ6VfgZ3C2aBNRSQdE1rUzjysLXCSGnU2+ocr0HiZ4pbVdU5xFCJMzmz?=
 =?us-ascii?Q?+fn0ULeD5Z8rCSduJ60o479677akCa6H2aBNoTp42vWFABXlN2e8OzHzVb8g?=
 =?us-ascii?Q?vSBsm++NZv6ZL1gYii6IVeodzGEYSN6bVVCKwRntpk1oIpTReBPWcBs+tXZJ?=
 =?us-ascii?Q?Uwo6rrtb0+MZb8sHITDAh14v/ZENENiH5Gm8eZ6M+m4jCJTTuzEnN6yTOwJg?=
 =?us-ascii?Q?o4atcMbThXcveYjjBvgLMik7ir55GR1YUwjWWs42FJ0uxiL7KpkwPTtXPjou?=
 =?us-ascii?Q?z/5EbBUZkymRz4p5zqzDESP5RHdBdk6p41xeDDICdR7byBSgXeH2Sk80w+j0?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1eCI3hgmhmUw5qrbawnmaHNj4/V06lFbkIqj6PZFz4EeoVHW6AVOWX0sx2gpU6l+7jK9YgGRVmEDWklmB0tfliJVfEV5xA5w7dLyaWPabctFc9kGVC3lK1CKdJsgblchPtbXiTNlpmLs0HjZ/VEJWRZNo9d5Ee+0halndYkAusF76vrwNE0jdij7af7LuWQ9WLLbqw4oJUNpUFfGKInpKRfWxWFwtLyBjojxpE0hEWRfSSXOcSUZAqwb321eF+Ijey7vamS93xj5x7x4JQJMplRyG9gOUnycZKEZJA2JiXIV9LEr8zKdok1HxcF7jNZdGwwHy25m3d6Jpg72WP2WbglQCY2e3LMnwo2VPJANAUn1TmbHfA015t3uDrqbYMoVprmtnr1lpbIAoV966fd+ImmPFRSLJZ+Vi8ulzPktBTRz9rNEgWUTmpaD4sWIiUoV9U71ZZyxf91u3bekpyIYvt8uV3AKufB6I5mwmkNQTIWcRvZzR0SIbz1xh8AP/hgOUzBomT224xy0s2S91KYt2PFs0o4eKjKOi13qRzYz1NF60JdWiHxGrFqN2vHKH60M1ek3io9fj3KPiwDA5Zq4HLY57ZZAxCwiZWjKIHbExOM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 848f3f52-19c8-4f22-8e4e-08de2d1d6d36
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 18:55:54.3786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKno5h3gJ/P7ADlAWxxM2Ihc2IppaEVbukNfrDZB1bIkDeXMzCkKeevoKi3Xt7nOqLgGQ7wvt7gfioi2j8OViaH5wl8h7Hoz22GL4Dr38Dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7100
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=983
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260153
X-Proofpoint-GUID: c-6A2bYwEsQ0MVWgsqmInAHzQfNeJsnD
X-Authority-Analysis: v=2.4 cv=ObqVzxTY c=1 sm=1 tr=0 ts=69274d40 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=hSkVLCK3AAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=exPqA-NJC47qmnW-cqQA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDE1NCBTYWx0ZWRfX9MjtjGabRnly
 ofAuuy1CMh4kUVKkS/8Y9Kh81InFl5BW7YcUJdppjiJSPVdjaFiLH9Wzob59TKFmO1D6hdJHtPV
 Bcl12l/MAGQ42ARCFHQ0KzLVdzZ3An83nwahZ4M2OdBedPaF1nckJnFYBvXn35RWD7sMAZ35Qp3
 /AEhwrWPJkuT8oYwkT8gO1M42tW8mLlQEmlFP5oYFml4PVQZR37QVHRx2XGXOrfehncXcSGosV0
 C4oohWLG9dydJV8RroPDAx86PaKUgJ61WD7m+Cu7ysShes2HaQvVrifjq3/6LTAp2cEGBkw4taa
 CN0TDmyzZSp8orZqOxMDqzLFpMtna3qGMton3OVQ2eFIh+0BHdD85H6dw18gItjapzXy7rsu+uf
 km7k5GLrDCiLn2eXr9w1PGz8PPdGng==
X-Proofpoint-ORIG-GUID: c-6A2bYwEsQ0MVWgsqmInAHzQfNeJsnD
X-Rspamd-Queue-Id: 6969016000E
X-Rspamd-Server: rspam02
X-Stat-Signature: c6qasyzeegasacwr515ekpbbbxpm4h97
X-Rspam-User: 
X-HE-Tag: 1764183369-390460
X-HE-Meta: U2FsdGVkX1/iSdbo9mxVvsaGj4fezzgXYdXzYObCNR1dy0Z+I4lH26eLiYfZ4jmDi1ySBa97hqqBK0oXY8hc4u4AUGdpOUNn2gkpz4/zmfZQwkEzEpRhASq/3N2TI3++tOXLuEYZ2NinwVJx6m1KMRDzZb/CCnWbADykFZWCmb5Z5wo/iD1COjC5rTDipwk6qZyNRCYII8Ne3f1iymeRR95/oXD2B2fbUFum6WxyQF4js/9og1Zzwbr+n1j/VmNP3xVS4VicebjdCav+1kBSw+6ER1EDnXRMGN29D+HpKOTY0jCpYe/7l1/5giPVjHvyVC2tdch1cWvF6o2Djl21EVXLUtgZ0c52W8IfTTE2PuhDDJ+8f0OotDyxqHtf4WeWjbnif+0lYDEaW15pvZ9nNpXxLOevtBAkQjdnIJRbT1KW7IdIuos0r7yKwY0W221FRuOCv7thoGDqkcRb4DgWmLpPt6QxXlD9dHHdJ/1ie0NKTzCuPwmqckEuvNjoXUH2fSo5ssP+H/t7jK2LNeazSDmQHrA05q70qyGBudDFpi32B88OUC98t8V7Y51FhP5yi5Bto84gq6MvdE3a+eZrwBFiP1cNVgKp+EDMmgfhsZuR9iXfQY1KLywz6qikVZq7p1In34gkU49sY6rGa3sf/n5qsbF4VeEmyatpntf8TGasStYs6Zcq7qkkQokGy/LkLFi9jSOQub/4xCf3C15caZNSwfJDAm1L+Hvyfdcjw7QRCcijbjcId+jQyKXvNEB9n548ZxrFe3YRmfhWnmi6A1p2cLFYc5N7Hh+hlhP5aBZ6FKb104DlebKeAqdU3qlYsGCzVg/30aF7aZRfRu2ui2jUzqprJEEaOlkFh34vm+vLSPTOjK67ulvKjmh47N2tffxT4SZacCzYdHRTRRgNTShxvFVebr/6XiUHlmpWIAYcloPvj1bJHPYLSOZjnQMM3njOnbOD1OQ7fEGc0Yh
 cXr4e0kM
 RsyDhcV81SOP7/NTOlENVvtg53jbj6p+LoR/rawQ+2dKDAnD5HsK6/EcD08vweRGRNLarwBWpjFnYLLO4K/B58r42uVtk+Ozfwe4uHjFEPw6/wVbm3nJ+KY7OsATH+Qgrxu19g0NdjemTPO/uI/ETpOCvezmgGL+EP5VEs8SN0hvoyd4/FDCuzf+v2Xko2wIIoW31sQ4dHMKiH1yiRkMDGyaZzFfwd0E0Emok9dt+E70cWXPxj4zCaTpiPvS8tQLWhHwJzvtjkDRrSzIOZ5dUZzY8jXMTTnyryy1cB5VL7khT1kLQO4t2tvFsinjnLOuKIl8NEzvV+du1m6u5L4fxo81wg0yzvJzuQ/vNvy4FBFMPkXF3PJoVWOG2mrEEr1IMF4wW0RGjZ9nGlg7+LHSqf+tZ5rqzlt4PBk9ChVDXYq6/hSFEmaYJ09cpFe16sW5W+2P1dBlXzIHPREyVN7h26UxwNoa7jVpbNIZ5BZ88u8lRxP6hgJor+8h+4Mi8ViLiY/pK/onMtsHI9g7nUbS2U4g+iqm3hTbnzbHXflyAmiOPM2WbrNZ511hpXZvrQTzf4FJJ9ikrxxnwOctdGbI8qRqP929l/EOAxokfCRQhqa2ExdBaCNojINYtaSx9/vgXrziERt3V6+EgpOVYCxcDXy7deRNSC/2tlKHPjy2reNmKrK8ThPC6RscjBphAZHGF/QM7LWBr+zRs2IHe/mxSq5IBnS/GN9ZCcsWUUZP/so5Mk1JHeCv3jnERdmX2pTyEnMpp5o/yhkGmReoxlA+ydx5TdaLI1zMrhpr/qkR6CNhS414qwHtf9eQNYWWitqSHitzqfEOQBJuCSK4BOapcpAWjsUnSAnMq2uRREO8kwUDP3mMe9bQCpkNbCk7MCOaNE6Mvf7aGC9G+PhE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:28:13PM +0000, Matthew Wilcox wrote:
> On Wed, Nov 26, 2025 at 06:06:53PM +0000, Lorenzo Stoakes wrote:
> > On Wed, Nov 26, 2025 at 05:44:58PM +0000, Matthew Wilcox (Oracle) wrote:
> > > If we get a signal, we need to restore the vm_refcnt.  We don't think
> > > that the refcount can actually be decremented to zero here as it
> > > requires the VMA to be detached, and the vma_mark_detached() uses
> > > TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
> > > as if the refcount was zero at the start of this function.
> > >
> > > Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> > > Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  mm/mmap_lock.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > index e6e5570d1ec7..3c9bf2f96280 100644
> > > --- a/mm/mmap_lock.c
> > > +++ b/mm/mmap_lock.c
> > > @@ -74,6 +74,14 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
> > >  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
> > >  		   state);
> > >  	if (err) {
> > > +		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> >
> > Really think we should WARN_ON_ONCE() as Vlasta suggested.
> >
> > It's an 'impossible' situation so we should make that clear. And we should
> > find out about it if the impossible happens... :)
>
> It's only "impossible" currently due to some fairly esoteric reasoning.
> As far as _this_ function is concerned, it's entirely possible.
> I don't want to leave this trap for the next person who calls
> __vma_enter_locked(TASK_KILLABLE).

Calls __vma_enter_locked(TASK_KILLABLE) _when detaching_, otherwise
refcount will always be >0.

So we're only looking at us changing vma_mark_detached() to use
TASK_KILLABLE.

As this is such a subtle corner case I still think it warrants a
warning. Or at least a VM_WARN_ON_ONCE(1).

A killable detacher is, as Vlasta points out, kind of an unwise thing to do
anyway right?

>
> > > +			/*
> > > +			 * We got a fatal signal, but the last reader went
> > > +			 * away as well.  Resolve the race in favour of
> >
> > This is very subtle, I don't think this really explains this clearly
> > enough.
> >
> > Maybe put something like:
> >
> > 	/* Couldn't wait on readers probably due to a fatal signal, so unlock. */
> >
> > Before the refcount_sub_and_test()
>
> I think this falls into the "saying what you're doing, not why
> you're doing it" trap.  Whereas my comment is at a higher level --
> there's a race where both exit conditions are true at the same time.
> The rcuwait_wait_event() picked one option, but we would rather resolve
> the race in the opposite direction.

I find your comment unclear, and I think it's too succinct. I was trying to
provide the most succinct-yet-still-clear example, but if you prefer higher
level you're going to need more detail here.

It assumes you 'just know' that:

- refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt) means unlock

- err can only be set due to a fatal signal in a non-uninterruptible task
  mode

- spurious readers can cause an incremented reference count

- that a race can exist between a spuriously raised reference count and the
  previous reference count check between read above and refcount subtract here

- a reference count of 0 means detached

- err = 0 means we are treating this VMA as detached resolving this race
  'in favour of' the VMA being detached.

Let's get some of this information in here please.

>
> > And:
> >
> > 	/* Shouldn't be possible - VMA entirely detached, so treat it as such. */
> >
> > Before err = 0?
>
> Again though, saying it's "not possible" relies on knowing all the
> callers of this function behave a particular way, and there's no
> guarantee they'll continue to do so.

Again I think we'd be better off with at least a VM_WARN_ON_ONCE() given
this is a rather obscure corner case.

Thanks, Lorenzo

