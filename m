Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B80D25041
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687EA6B009F; Mon, 12 Jan 2026 11:34:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615396B00A0; Mon, 12 Jan 2026 11:34:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4941E6B00A2; Mon, 12 Jan 2026 11:34:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36D706B009F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:34:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4BD2D1433
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:34:00 +0000 (UTC)
X-FDA: 84323858640.21.055D0BE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6D1018000C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:33:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UJl4Aj18;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FXCBqTzS;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768235637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aN3ufIYQ5kEAGV754h6hUy6C4zgc3CgjcyM20xqQ+FE=;
	b=HPj80CQ6ca6xjMP4NXNiZCzHHSclCPTQfDmQYacQR2QlYdDsRphFb5zrKv7xH8+5fodAZp
	Sd46NAZi7LT9yUtZo7/XqxX7AkN9csYgDpbgr8Fu0mtRK8TN0RRc+xcwPIeoPDgozFSDXd
	k64oqEN/1jGKNsk1BihXBDBJilQP1PI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UJl4Aj18;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FXCBqTzS;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768235637; a=rsa-sha256;
	cv=pass;
	b=Ymq3AvTXSH+DcBPawzxVucW5k3sg/jGKkq3BPiJ9W5Cy2m1qcgh/nLTLxkH5veHaqUjdi3
	ibU1KlFxKEMykNpwS5F0lVUvRJVcvU3litzrmWXUaebSYeKLCjr0WuGxqLoQ2LvRpG4P13
	vBb5gNTuHJvcWKeH1BgF9CM8NFgHgg8=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C5QxBP1308421;
	Mon, 12 Jan 2026 16:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aN3ufIYQ5kEAGV754h
	6hUy6C4zgc3CgjcyM20xqQ+FE=; b=UJl4Aj18Wc2uTaiToxCeKDt6e1xTs71app
	snl4PQEjvJ5BU63EPLN7nG7NpXpEGmFI6UIJiWEoJbO9N6mhzUlux+U7EINC+Sb5
	J9+8QSSXBWalRtRZZ1g38FzojmsGK7bTZV2jDPiQ5yApTE9H7VznxTQMo8qi623i
	MY+9qR/RGPuMmMxEdBNesWtwCzxEL3esXmq6u/XC+8sVtY65rSFBjFHQfLPMNdmi
	Lx4/flLmeda/p1gI+Q/nhMSCRA7pACZPHMQB1Bw4FEkDq5tDrec/6VO6lKE+7LDm
	ImADLN0u/fhlftbtC1bZhl2Ghqm99uHQpGyX5A5XOi3+zduy4Quw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrp8hy19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 16:33:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60CFHBhK001864;
	Mon, 12 Jan 2026 16:33:41 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd77m4fd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 16:33:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Szbg5g3jUefh7k9rW/cyb/Yk6fFKeLBirLCVIhHpjETDAUxRbKguh0YLnzm7t1eH+20RBUD4Xsn8ye9k73+pzNQtAkzOYua0mPf+yJ53WbQvn4LYOSUCBXJLFb3hspEIdOv7CSc1l8WqbA6OQozo00XNfPAc8KQ6xDsHhq4UCfY3VnR/o7JxigWlX1OT1yF9/zmaJ7b+5oamQT++9JllazksCuF6kEHbjI0RH3vzY60fDQg+va6ZH32/2PJ5g0d8yWBUBJz4lYF+pWXUQM+9p/lwEW+MquRq424J4PrPTDMlBC9D3ADTYJJyFDR893VNFoQEZofF5VtbfR8jCsnZ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aN3ufIYQ5kEAGV754h6hUy6C4zgc3CgjcyM20xqQ+FE=;
 b=RciD9ZEctrq8jZ31OJgRU0M4jpfTSTthi/kZeCnnyLHkbBCeUhh+ughdVLCEXbmuyzSSvgDp9wY6MatHB1BCVfqwkLoSEcPSmeTdFZBMdOV7S8Ew5XsxCL9Zo783Tpto/jVUSsAjJ69Y3I0p1rgCXkqacL2KU03uK/aWtFG7Eu84Oy2h7fj/MMQa6E3FZYBt2gOGAsOPwU3lD54UpKtyxkwSHcCKlUfwTuVWyCckijlYjEF3sp47IdbXaGqVa3Kh+LL4QdMiEu9hvoDWsmkiTny81FAtkfelWpuX27nxM17ZMC/OklPjToFMbcHarrMri1Q1RCfS2h22rE0SHtdOaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aN3ufIYQ5kEAGV754h6hUy6C4zgc3CgjcyM20xqQ+FE=;
 b=FXCBqTzSHuHvjenhUyDkT614+jw3AnViXwqT1TFzUp83eG6iC6PQccSni0tkdbQkVJbd3rGLgexFa5FVV2XdS88xoOBpV76F+AbpP4950YCDFY4KHZ3knAAdFXKusV9JhEG+Yka2k0wFDg8ckOQSims0ng6lBK+zlciB6mPnGQU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB7772.namprd10.prod.outlook.com (2603:10b6:408:1b4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Mon, 12 Jan
 2026 16:33:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 16:33:38 +0000
Date: Mon, 12 Jan 2026 16:33:42 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org
Subject: Re: [PATCH] mm/khugepaged: make khugepaged_collapse_control static
Message-ID: <49229782-acf5-4e33-b317-63399deb6f6d@lucifer.local>
References: <20260112161820.604669-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112161820.604669-1-ben.dooks@codethink.co.uk>
X-ClientProxiedBy: LO2P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB7772:EE_
X-MS-Office365-Filtering-Correlation-Id: ec8a8fac-044c-4963-d738-08de51f8570f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/6ebChU7l+l2LESjT4eY552C67Z7crxyMhnb3vuMsk9Ej5SOO0hsN+7W0boz?=
 =?us-ascii?Q?bRoZzewXKUgZVdmcTSp86dVMhQ3QGVTlDZ+ndqb+wwRIN/XxACo2kgEHxJSw?=
 =?us-ascii?Q?/jl2Ghk98VqYWvryeQR0pO+Xz9bbg3qDGV9mZehUs30UY25x4F73brTszc3i?=
 =?us-ascii?Q?gOcp/C4JUmqJm2HT+GGC1or48wtBljUte19p5zGc4if1VR8I1i9VH/OI89Aa?=
 =?us-ascii?Q?9pHN3W+mc/3NxAXdMGtHUd4r0LWuAj1Gcl00auBIHMA3QPE+0Oak4gYSu69p?=
 =?us-ascii?Q?LKCSgMxSajcGJ4/+sM2bA+AimHgdZwYnUyM3DrJZPV57lst8quwWk1qhhFVw?=
 =?us-ascii?Q?cme94+mNmzHq+Jye0vavR0DkY0ZyuHiz7tDoYYNxCDy8OLXIzR8VSEAthRBn?=
 =?us-ascii?Q?LDkQzl7+8xERWdGEZs+dCjIaH0R0oVUcUBzRI6AE62wfKN9s9kQ7/fkXEYR9?=
 =?us-ascii?Q?CQyIo4PQgJKtrs34xPPEC+z7ZBg1btfnbZj7B/TK1WB3DXc3k16BzfrDIh1o?=
 =?us-ascii?Q?ro3vzEfzLxjgW8VAAtROGXtKY4N/WvLg3fdMqgMK+V8uWDq6aAZcCkDcB5Uz?=
 =?us-ascii?Q?4Tg2LGPQg2RoILWejnjd36pUhrnuHGoct2GXWqVc6u9ipK/kmH47ykB2WaCY?=
 =?us-ascii?Q?y6uN0BntBJGgRzFLhtAVczi5gcitOxd+L1bAZhk7eFsOzw0ik95aHnKD/yEP?=
 =?us-ascii?Q?80XL1hqgKK9rPRyP9XRee9wfh6K4AxnMrcS7z/2yqA0ldpGS2A3N/0MY2k7E?=
 =?us-ascii?Q?9miWwPapod0LhOufh+AVNcnrKBNhSaGFaF+AnyM0C5i8j+6FWXwMDhFxPFrb?=
 =?us-ascii?Q?OcfUlmS5rPEjtlTJm5YrHMJxeb2NvD7DMbY59CFKS0YRaQwakhfIh4glEYj/?=
 =?us-ascii?Q?BLq9eGifKY/hvcpjQ7cPZhUAdqecVarpIVDYqg2ydaZbavK6CWzMld5OgLyw?=
 =?us-ascii?Q?M/gouMeYo6Bh07810HoiAEQdB2KmoY2tLbxSSVIYbdnObrUCy7EHtbZQ+wcr?=
 =?us-ascii?Q?tOlzusA1axu7aU3/po3EPZdZdDoj/N19+r0K59T9nPBO7RCKXTPh4tK26pfb?=
 =?us-ascii?Q?H5I1u8UOsn2JNvx8bTBQ3QQI2m7aonYP8t/bp9PhO2ilOC9CgInXPfMbBuGg?=
 =?us-ascii?Q?iJNm4+J0wOH4dfvGoAxS+jUy90gbxG1/Q8xKwGrOzC4btXnGXOY7B5syFiGd?=
 =?us-ascii?Q?Di4LruZ2Kf2loFxA6k+EGIhVdKF86kzrDorSrfCuJ68nB1i/4XjEyzQLH7dm?=
 =?us-ascii?Q?O+lTqo82TVD9bzah08yP7sPtQ7F7POt72A510WLvsW7Ckhf3wXwESmA+eWo3?=
 =?us-ascii?Q?/8rxL7DenloDSfAHd7WDRxiZ+qQciFTziKNC73zgWbLBWlC8SjepODEq4O6S?=
 =?us-ascii?Q?T/8b4cblo4p1VXtXIn9LEy2kEw5kZ5kAvtz0Oi0CyZEc7i5vkOZjM2XhADqd?=
 =?us-ascii?Q?WhxHVXGJ8drRyEvHPp6q/r3zkEyOdTaOf3d396pn9eC2kdarlSwUiQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dGamAKEYZCdoptKVL7wLQrexOe2S60TaVEzt/lUR8PrJ+SVEW5u4U33XB2Js?=
 =?us-ascii?Q?gVGVHyG0myqS/dNBr/tgvzxWT3Z7LKWKD5PHGNi9fYB2+DUYudHttDiDgMJk?=
 =?us-ascii?Q?TIQ3FlfokZqWPezwXCGWlmN1iA+KU9A4N49nUB2RjBIBPZyRePzoAQkUK4jm?=
 =?us-ascii?Q?sNhEzKMx7XDKJWCq63JvPI1+KROt6AAgSZKuXVQWYEM2pqMGEh+YwKI+PhJW?=
 =?us-ascii?Q?wGLHsXy+YUGWsp5Jh2P0nUefv630YISPIiLWfTRYPa4FGF13VqFh/HUfQEkJ?=
 =?us-ascii?Q?rhlJja1g5+aAySaHrkfYoptMflCCm3E3ohQS4YZGYKrf14ZIYY2mQIVA1H5G?=
 =?us-ascii?Q?RwOioGO42hNExPHaGXcgA/6BsFyTxozSxjB054jWoqvPH5tKPTMuQD3Gq3Hg?=
 =?us-ascii?Q?CQpcqWW7D4yUXj32JiwHXaT3Nx13xUrst255ze9FBkm0tZcSWnhqPlDxjAze?=
 =?us-ascii?Q?uo3yghhYLxCnyJ9i0Xa25bX5k8o8lTrF0Gkw9eAYPi1g9nBfL35EFI24s1JV?=
 =?us-ascii?Q?UFYDRE/fIbM4nh60kL/dzuZhRtHG1Mx/KFlzsjOIceEkpJHev2BBzWMmq827?=
 =?us-ascii?Q?spbjkuhAOGS0dq0YDntQRn/UQcunkeiGLMLfJrsXPjRB9GxdnepttnLHqVRF?=
 =?us-ascii?Q?bLOgNvxxfHvrPKGTiWH2xpLUeogyep1DxTniu1cI//ZNserGgFYeZE0IwFGO?=
 =?us-ascii?Q?F1kM6sv6VPMaATnCwPPYP7Ytx0DaA/SvBwyn6AEB+FsaczPmNXJRD/LTax3Y?=
 =?us-ascii?Q?evYV3njmzRtFVhD/lMWGYV6DqXcw66iUCclbQLOZfiU0L3oO0u+W3PU95FLL?=
 =?us-ascii?Q?XTBMHr3BasPexJiUdL6ChXdi81QA/mRQ/AVsAJYzcgjf2LyDFYCuq84A0Ov5?=
 =?us-ascii?Q?5ZhxVKOpZk1uM53AVLZZxBZpxehZmxubUbPEfaJKeb8/CuTqSnzWwv9Jn4Tm?=
 =?us-ascii?Q?/hDNJnaPDpVDSrlvZumiVT3PS4yiZCVkZ9TrT3QzTwTFFXv2MZNATpA6968O?=
 =?us-ascii?Q?MKSIJfwYRiNvrc1vr2XzYeHHeGIxcnrl3NMONs0Oqjf+VhojlxWi8y6wIPUx?=
 =?us-ascii?Q?v7uTN43z6sYRQmg2LuFvqepvCS7XEMKgG6lq/MFR+hukBPbTIgJFuNruN+B3?=
 =?us-ascii?Q?2gHuHskjpVFZnsp4MXvU+UjuVtMCX7z7odfeqajdi2MqAAn4IWzQpIcxCt/p?=
 =?us-ascii?Q?vjgybyz5BKcQZphX/nxshHgljuNleD3qhv4xU1SIsQW1U8r31uU/NkRNHB0y?=
 =?us-ascii?Q?ySc2tsDH4tcJfJCKDsJlKgSY4yiRxZNXa9W7wQeU7ZAfWwrI3H8p3s2BC3hK?=
 =?us-ascii?Q?tt6jji+qgF+Pw0Hixa0AqaXpZWxGKCUUkEifZmJe7ZLqcYzUdn1e2P0qadxr?=
 =?us-ascii?Q?TZ6luCtM7DmH+kbHcZ6sSj61LvrnFGU5UhWKmIfQ1G0wNJJNYjgwr+1IFlu3?=
 =?us-ascii?Q?iHlXNquTG+f7M7urWtRp4xlNLRdQfTG1UyWTSfpdoKmQ5VY/LZR0YbWNYjv9?=
 =?us-ascii?Q?A84WdzvMsMFh0Ee/f7uxJWLAOB/pU5rymNlxADqdaoXRHwXBDXAoLmUU4orB?=
 =?us-ascii?Q?SwOytLofqj205/3GsBQn5VDM/8BT+anaXPfTZcbM0xQK32vwlw7ZplPk8jm7?=
 =?us-ascii?Q?Y/tsjwyYTCX9rFO/7E/ek0IXFfAOF2jWR4KY9Aq1lAMFd2d7XjOHzZzObtgU?=
 =?us-ascii?Q?dKWWExFvsWjbJ8rDJJ/yMXUkX/w7wrXt0eL6T6MqAd9u8Jw6PvNjEl56QnEU?=
 =?us-ascii?Q?XKLoPXAYC4e7Wwq/ltn4DGRGlK85pG8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7vgfJh03mWUw74rubbSXlnbOfV1NaJzJbxLELleM/vFjqHAeCytLk/4Z4a3pniH8HPML5epWFbQGhcB8SgwmiQwxv6eTTxBCumJ6wN1OqSlGob4zuw1nkDxlnYWTvzVXVKySnEfpZ2Hn6j+IMnDlDcgELpBnFpCZz4qNYzLf832QP2tRtHUT19673/cpUERxunyJzeiJUx7Uar9syW4VvRKRkuu2jjb0WpA6JLujEnGl3biTp8czwjT31OP4S9DAhlrQ7A7ib3mNOWsDoRwneS9Kgehuwemw4CcywmwKTb+yEzCqNuTwhTXNouXTU8PoP5Q9qNgS1qcUbW9gtiihT2mRJKrQJgVllec2CaQOLc5w+J7WwbX1xXexjMvNEj34fag+I6yoWtwNUaTHvONv+kL8gVPPJF8eF3d+/jrzmbinNU8WMXXkB28aGD4JBsduIx2draFLdjlP5zJm5z5KDG5fwuZIL20y7/kkjwNkAuvs3Neh32fXo24fPzkSl9Q0GWOLjvVdeAptCNFaFBNQNIuMznwd28FCDgv/Z1bLQpKd48rIAbCOOq1Rn0whfwWYhHmAxhhms5+t+CwgghUNF8S6QmxGRiz8D1D5CXzdGZo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8a8fac-044c-4963-d738-08de51f8570f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 16:33:38.8641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSBXWF1ShiebinghjVRsKtZmRAiwIPiAjfCgsz9ZEb1ah2/IiCH9/vo8xAd0xm788WMNsbGNIZkwjnNA39AygWnl/t/t1wK8PoICmYIFviQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7772
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_05,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=716 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDEzNiBTYWx0ZWRfX+EPLKG4x0xaM
 DHQSNQpLgoQeXCtcHm5Juq2YNgbTVamtfLbmdnx8vwqH9SF1DqSrKM/lqz348EfNMWJ/p5LwROC
 9EW0udq4LyJMijjqtIxMeHM0p01sgvjrI7SE/qya10MP52V0uGPcycw1yx/cauuDmmeC7xIGtfn
 DIdSzFhXRyiLoVy2yZN1kb9SI42163aEa+FPPtJs+8QVGbrryIPr6xBW9PoGCjV+JSZ7t6LkV0F
 CwEdc0UMHR59kLbN+flI5YD9LncgnnECDEuH4yIyG7EzPVvZAlRjkX5n53K7U1BwZ4vwKz2d6Zp
 SXSFnqBsu9JF9zXIasrXmqCrgWfViRjSVHqQ/m3amO19Xem2jYCl8QWipBPe8fnqSVFIEufjhX5
 uqgybF8KhWV3oSGKAQCF8OQaiqGvSlUzOmKzALCR47kOZLd/LMABVDuFl5TrMePQD8W7RD7JEFP
 dV2mkWdU+ViXXKuMy+A==
X-Authority-Analysis: v=2.4 cv=YcGwJgRf c=1 sm=1 tr=0 ts=69652266 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=1EsaE_6oAAAA:8 a=-8cD7WoxZdaw7SRXPskA:9
 a=CjuIK1q_8ugA:10 a=3ZumFrijQQ-2J9H5h8ct:22
X-Proofpoint-GUID: 7MMsZHu7XB_8mLYw3rx2uUIXiEg1Wedq
X-Proofpoint-ORIG-GUID: 7MMsZHu7XB_8mLYw3rx2uUIXiEg1Wedq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6D1018000C
X-Stat-Signature: mwyontawbiq4rwu563yijibmse41y3mu
X-HE-Tag: 1768235637-882607
X-HE-Meta: U2FsdGVkX1+ntKS9IkUUccRppGQ89pSLn1bCu3GSc0dnegjG4mmLMMHmqTYcaqU2rBncdpPWaxeHASO0O8gfmCD05VLeI/Co3x1W0yBapeqh1aSA6mU8WkX4qnPzC8vpCJPxYYQqK2nDpR0rwzk/q7S/x/dE0ostqtic8PJ32C9rs2Y8YN1shV72SukCAr/rVwIQoCt0+D0vhqlUNAu/gBRRL3BrxO826zjwPombeHDTMShQoPlHEZTDBItgx+UJ0wL8Jk3pQ0b3FixrPEXWQ/yiTBeZy3bHQqwtjvST+MCbe2m/oYvRfPS7I8+RiP4HrICNKUG/0JZw60iJidNqCBVmIC8hUgdb7glCFUnZk+0Gf+WS/LNw9qPrApnoAyboFFUxfeO400PpWH0PxiJmj0mmFqInyu/XzMUTQj7LwVh+E8dvxFxfrGcPN8cKYd2RR3iBeST7aOtVQcsiFZxhUA6CShmDqHNQBGRRblhUyf6g0yYVWvXGv0J0s6+2lFnBg8OrVyGSHcir/ZQaNrhFvu/Dou8AyMYkl0QnZ+yiiRAxYxETtq2NAxyt2PFuSOVqVP/QW6VINoxoc/r8XJNe+BPO+aYpLQpNEWfwjuP8m+Q85VGhIHSRtxQOYxCeA6VrLWk2aKuEpOmF9cYgS0TdqcJ3toBVXfRWA0BLhg7Fr4yuRdUDySde2bOh/LNs8Zs2PnzG34YWniUPTRMXB9VCzLt/dmtfjtA+unyhd3dUUzGxBpXKqGYtHvebIzks065h2e2TPZO8wKXVRr78t1H1f5NsESaUqu1QvkSv6jaBOevry1f1236TkU3RPQUgNvP25NLtAF9RngH3FuWrBFYNpncgBIZKL3eomWIouI1TP/KWwNojNxgZe7hPQY9/guhuLEffl2gjE9J1JQX97OqHQnwbdfv/BSORpCouoAPOs6GHsx/I0NPmLh2cyzkCgzSQQ2eSXUVx6HiGmRi1sWP
 sKl7qkcb
 JD0duIphhrNTGfcfDSH2ltQh4zsS1jXC1HB9+demP7NDm8xvaq61QbhVbGoyA13frEQPkFuky8+VL5u7HLKeFf4oxLguOV5jYM4JFE3VkX2wfBkpZzJ6gfe7UjlKu1VR1vA5jVJS/1m69+RQ75sd3eHtIdRkhkKptP6ww+CLG/gqRzXIM6S8gNvAPu7sJFEXZCnz0tebdmRnFAQVldF+KN10w79e72DwyyiC7dv4xczE5BlZDw2ToidUUWMjihsZzeYcdwtocNIRm7Fzg1J5EM0v21a7mVMeYgswHBRTOi9C3LhHYyPl+Gr4kB8+RGs6BYxhGjfLSA/4g5dqNHJ/RDaQw0LVfDp+SIoHXdcEictkV21qDd5RwnEiWNTzGPbTP62Eh6UvmPsLf5QRAp0OrWV2W5Z6bSXOjrLVIeIcB06OBzRWVEKSHsnf11elAgT/6YUh2Cvy4dV284HgrMU4Ao6DMaeBkTwdGTVypC+JQUgdvC2fNi8Qu1+qoBX+42WIfS/Nv8n378kg6Q8HgMmRpoCiiWF9cps/HFkVY1eD5DVoh2fNCIBULA4lUm2qwqe0+eGnEbvUGKsq2KBHHfZLEXOi82PK2+2igmpFBEnHmBN4skTtKili2H05IvF7aXtBRfpjUbwwWFWuB3fiaUiGdNpBl5VZ3P5ktjKxNEsICIOCTHW7QVPoUiV/NBTMK8rgMGMtaHrtPbxcN4gbRcTfN8hElUaHHUmHRq9W3xIOejxtzexs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 04:18:20PM +0000, Ben Dooks wrote:
> Make khugepaged_collapse_control as it is not exported.
> Fixes the following sparse warning:
>
> mm/khugepaged.c:829:25: warning: symbol 'khugepaged_collapse_control' was not declared. Should it be static?

Thanks for the patch, but sorry to say that this has already been addressed in
[0].

[0]: https://lore.kernel.org/all/20251224111351.41042-14-shivankg@amd.com/

>
> Fixes: 34d6b470ab9cf ("mm/khugepaged: add struct collapse_control")

(Small note: for something like this that isn't fixing an actual bug we don't
use a fixes like this).

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 97d1b2824386..c9bd0df632bd 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -826,7 +826,7 @@ static void khugepaged_alloc_sleep(void)
>  	remove_wait_queue(&khugepaged_wait, &wait);
>  }
>
> -struct collapse_control khugepaged_collapse_control = {
> +static struct collapse_control khugepaged_collapse_control = {
>  	.is_khugepaged = true,
>  };
>
> --
> 2.37.2.352.g3c44437643
>

Cheers, Lorenzo

