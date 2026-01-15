Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FA1D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EAD16B00D9; Thu, 15 Jan 2026 14:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0736B00DB; Thu, 15 Jan 2026 14:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0306B00DC; Thu, 15 Jan 2026 14:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D49CB6B00D9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9552B13AD7A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:43 +0000 (UTC)
X-FDA: 84335208006.30.D90A3CE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 398321C0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mnACjkhG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RL7PhsFx;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4IbyE7V4TEdEvFh1/CuA1p3x8WcJN2dNnXD3Bfijhk=;
	b=zI5xB7vMXjP8RDL0t4no7qBOyibjAh8n6GDAdf4WNI9UZSACHw7Lg+AbQEcMPdJryUDIKg
	7CkeV6FpKuS87uye0jb3P81jUR4uklOuj84KMxySzSrgNUTVB6HMLy5RJbTZzSiYOEpPny
	6zYrMC9H0IS9oLp0O1H4PzA1oAsGJyQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mnACjkhG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RL7PhsFx;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505860; a=rsa-sha256;
	cv=pass;
	b=8gu5lTDecJyaYDrbSb6KnPkoNtecfea55x7bMfgyzAzr0f0rxtnWxa+RfB1IhAVWoVKvyv
	+IvdHAb76ZnKyspY2/Dk1wPN8t9r+W0Dxkji5ppBuKOI758u4bf96N/y0Af8p1Y4xUf1Qx
	eWD0mv6Uz2bzcSqT8SRIBFOWFOAJ8KE=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEoA1V1362590;
	Thu, 15 Jan 2026 19:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=x4IbyE7V4TEdEvFh1/CuA1p3x8WcJN2dNnXD3Bfijhk=; b=
	mnACjkhGvoejXrYgFm+BHvFT3oR8RZupKiRiDAx3sGvR/2QDEJhAE3yFTj26RzRm
	KzVGFXuOfKLJ40KJ/CBRzmk3/BvXxfULtpphjAJdYW3NDeLddWMZUX5bg7h9tTvc
	s3sZ+3FwyVnOUoC9rkfyDs2HP06FymKjYGhJ6sjuu7tgqjBKzRox9qC1wBaXnOQU
	FFoe0hXlEswUAl8tQdbbczib0+kSaoT9FRFUENDIw+7ReDW0NYq1TKCLOvI6TRIZ
	C4e6ZGkljI8nrd25dXVhGC9TF57GCLFY9dwvwo3sJ4wiX9tbmQ54DWEz7YG2LVpV
	16Th3jGNlRiWekYQnLC6WA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp3s50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FIbfU7000463;
	Thu, 15 Jan 2026 19:37:33 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fgkrh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqEvceu67V9iTESms/uYowijfBSxmYsHJn8FRzEveGX5UoVoLSOkShQfefZpt5NuDCwBIXRMchK93f/I5JPkOdpIbIE5Gf8y/I2NhZo3fB8tdXlSi3Wkj44pmlB59OtbpaVyp5jn9ai4JGzTheUYkegZW8XQ4P2p+UpwiViFsnKW8PVVbaYf+0aaPY8E2WuPuuC8571dtLTzOGeyI2zc38Xf+vAfttGqlOPVZvQt5AM8pnHiLtkm50Z6rVFF143ChIawqCzTcZ7UNyhV+6sW6tq3Uv8lZfiEryY4vb79nI0mpmgWJf0lU3xbH5aDYsw+T+y8w8yYxY+oGwoeK2zzwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4IbyE7V4TEdEvFh1/CuA1p3x8WcJN2dNnXD3Bfijhk=;
 b=IMtqJpPtuFMl3mDb/TZm6h8N5V/9SF72PAN+D1Vx+/Tg5mdDxUmBqq7jmRpHgBES5u0NbjJbd9ZHS43MOGf05fYfV6dYApvBqKaw9LCT0sN1jhkEMHA3rTzBrxqn2vANnnDE5cxn6lhfNfVdRS2IOWw25TuE8abidHpXwv5BT3yfZTnT+J8cjuQqvOwhXjK1KU0wCCCIbSnWIVTgSKj39HsB0wd4ZBoynun6SE7GAlYzCztJDL1/2u1tXt8u3yCSu2lkNLQqICihMWDTdpVOvY+uNPFffFd0DA/O6K2LOLcKDmfsahfmvVw7+1w0QPJTHJW5oMwZSxllz9C9y/Iung==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4IbyE7V4TEdEvFh1/CuA1p3x8WcJN2dNnXD3Bfijhk=;
 b=RL7PhsFxstsMXe5wtx3coPDlkJqDKLPkcgc/3470799dYHYFR1u+ipIBh5zHV/NVWbV71RSYMksC4VViu7gDGmfoUQl8tHb8c4zFD6bKNwkzMzW5d0HSvyC84pe6RLGor8sG3LRiY4P6mY6jHIkOPScaKwQjc30Fzl4KjXnmhu8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:26 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:26 +0000
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
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 13/28] maple_tree: Change initial big node setup in mas_wr_spanning_rebalance()
Date: Thu, 15 Jan 2026 14:36:32 -0500
Message-ID: <20260115193647.1695937-14-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0345.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 8605e0e2-ed10-4e32-d694-08de546d836c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0sJmFmVgpbfUOMNmQpwrHrFKwfdFT6oloLJIiItgrJvGJdtpFWsxHzhRxzx/?=
 =?us-ascii?Q?zhuiDAme2qCQAu4y5swIn1Gff2BhoO54pfwECVaeKOCSJD6a/w5oJ3jvmFck?=
 =?us-ascii?Q?O9x2VPTgtY8cCWLfIXD8F9ApRV24EQFKCYuKWqN8Innxc7c9erSCJCoZG/MU?=
 =?us-ascii?Q?wbX2cCh+i+AtviWEJnEUkXf0hEGApy70GfLter0wI3+VE3tXPXJHRsU8db4C?=
 =?us-ascii?Q?cuLF08ANCM2h0oWxxoknFXCDmal+KG2n+Hcj0DOhImXYBXjDL/zNDm2YgKYq?=
 =?us-ascii?Q?sFT8UBi5TQLVtripUO7ldjhiRpRXHAkDRWExNbHHJodzAjymkTWj4Zx+lBtj?=
 =?us-ascii?Q?HuQSt1lkvINTzV39/hmnHWKEDxSUrXfhXyTrVRSDnETgvXB4N1FjBPIt6rBe?=
 =?us-ascii?Q?CEQak/9ptSaKfG0wjSpLHds5tr/HlrQhY/oSbsGPpJgP/uBHncan5Y7V8RNV?=
 =?us-ascii?Q?wi3I7DHgHdwVXpEL1Gbw147w/2ffOqEfwwqhZcq39+AuGdzQsvZeWRdSz5R5?=
 =?us-ascii?Q?SM7UvfizeabS+FMDIQKggU3agFtFxyqEgKVIJ/LOIVVv6D9Dy6P1777vQRaP?=
 =?us-ascii?Q?Y+mn6BKRHbYPqvl1Kw0JGhR/vqd2Ab3wmo3mMIcBdmlEKE4TOd6DA1R8zeHZ?=
 =?us-ascii?Q?5CvNmPvaQNZQiJNDjVw+Ttc8VZHzI17lqp2hDpz4dgkVwH0SafCzurRLtlh5?=
 =?us-ascii?Q?O8SktsQiqzj/WrgSXs5kcYlXPXnYoA4KScgvYueMmFE8SK2Ah09VvI/3dY09?=
 =?us-ascii?Q?I06ZVoRG2/7BcNOO8gzj2d3wZWTtKam6W2BER8NEYYNdm1JD9uEYS3eJVBMP?=
 =?us-ascii?Q?g15T0m4PECLHwIGLWdj34ZTJch98k2L34aMUoGh8ryuffKdKV/0uCYu1ZKD1?=
 =?us-ascii?Q?ruXvsnaaj4+r2zWc9FSRIVe9Lo5yCc2WZtNMJpfkULntEDGEfi77N8lvQeyJ?=
 =?us-ascii?Q?3xKqXcwG6SmtO7D3HYmi3QnWtvMy8PzCiMagjwsZsC791V2bIh1qHzSsJSKH?=
 =?us-ascii?Q?GNn+P5jy6TbaK1wM+Wa92KDsDENpFXq0o0fdEJHHJqqrTsQdXfKfn5OVIN0z?=
 =?us-ascii?Q?a3WZRERV9vJZXjUfWjPTSgSIIp1GGsUmYmhRSMhqiwzCoRtFm7ERedB74+gG?=
 =?us-ascii?Q?aixS2ztAqGbt2qUjWr3OR2024HojR8IJXKFJH3ga7eusKiEXMxnuUybWCMz7?=
 =?us-ascii?Q?/l9gdrSPd9KcLUcd/hC5BSC93gFFS2qLG6S9sMAa3qTs2yi1ZkuAUtU7CTyf?=
 =?us-ascii?Q?d5cuiJZmex1mUpgTNKFOOfs5WJlktJuAZOcV8zXLUDt56AJVtjvyLD5j4Lur?=
 =?us-ascii?Q?iM64dhKRKoglRWomQEmuwezH6Hbk4fhejfsdNL9MQNbSTn44qYdBRSPbFENH?=
 =?us-ascii?Q?k0Lgafgztzcs+uWuJea4YPA1YMpW3iQnD7u2E0hzJkC3q97fp5hm0sUwG17a?=
 =?us-ascii?Q?XaGxiwbyiV8gBKwVkwHt8f5en7DekmUgL+g+tUKqJnNi4OnfK8Wv9rYulXRj?=
 =?us-ascii?Q?OCJh8twwEGZ80iB7jqSBioxPBREamUrupfPRH6XWxmJHKHeauEIvlsm2IKiY?=
 =?us-ascii?Q?pew+AKiy71JiZg9t9Lw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZiKGP4H1dlYfCTDImWeahJXuaNUE4rvMhI7mq5cT1Ie9ikNJ+v4Kjd9/qzNJ?=
 =?us-ascii?Q?cRZc8vZmBMwiiMZF7hoHoo5HCW8hNJrQ1f1FOXmahT4+ts4xzVbb/TBs7ST7?=
 =?us-ascii?Q?RqJYrqUVsokI+dOzizpK2+ibysp3D51ifW9pV6EE5BoOn8UGKgPfd8QvtQm5?=
 =?us-ascii?Q?3cSxSqcU9F3JBJgiZuOvLs1L8lRWFI0RVsaYEZRJh1ovJfPhVxxuvDHIQzrv?=
 =?us-ascii?Q?r36KkhWnFcZDixe9hYIDCvKkHNVoTMpwqOc+B2WoxfnoSYSKyXGmnLmMv31D?=
 =?us-ascii?Q?DeRauq5nARXZ4x2GK9mi79p+I4v+/RZQepTRo3FKtTIa32FSeIP2GfNGZ0vt?=
 =?us-ascii?Q?ZeR2FHSZAR//dpzEerIWIbbh/IhTCHAcsP+BvHrWWEvXECIaoJqQDFgvL6Bi?=
 =?us-ascii?Q?qCk5HifpF2Bqbf3efWhOovmvjwQIroJZ4UOM7Jn78qNDnAt2B0LE8SPmMdyT?=
 =?us-ascii?Q?pCt36Vbe8EH/JgvNndZXNO3p/4p/KK9h4aVWEj7LAF7CRIRbfVeflnwCRBLm?=
 =?us-ascii?Q?UEYGJFHGZGhoyUvlLQsfYuMmEdzkvnke9AqFFQHOB4+s+1iqH9SrcY6182C8?=
 =?us-ascii?Q?8I1sxDFDihuFs0JSj1a2aSvzu25lKIdsv3rFlHSzUliU0x3KINzF4MvuAvMz?=
 =?us-ascii?Q?k1fmwLkE71pfThUTVu7f1/14DcpsSYXHAqgdxRgRmS3F2SLYo0X34PcmWTve?=
 =?us-ascii?Q?gDEAqxUhH4naVj3OG54Ly6hJXKT5TkZdhCUJ094TfEjNwOSPHiqswmks/DzX?=
 =?us-ascii?Q?g8r9mCZOCVV9pSKwbeVMnsvXTvjnwbjkc1oi9tm51Nezyc4+8CpTW3t5m/0z?=
 =?us-ascii?Q?ppOWnpxrPc4ucO0m2s5ze57dfyf6urO34ydoDbyRQZDAZ5c8n9KavoCcqWAU?=
 =?us-ascii?Q?ZWAEzqDmppFXJ/Mhp8ujDQFzP/NUVdv5EL/aKUDsWj37p0btHb0uUEGKqLzZ?=
 =?us-ascii?Q?gw/qyu5K0f7X74iJmhjyGsq4BiLYsQ6p+g6xY9B87dEIeNfFRZdUoYQzycsG?=
 =?us-ascii?Q?GnENQ5CqVyHMV2SUVIGmcs+MrFhWKLGMsnktZLmu4ps2q+M2D/ca0a007h4a?=
 =?us-ascii?Q?Ss/OZ0j4Bk1mbPlTS/KXQOye73KYlMiWiQLvCVeIZ4du1w06dbdqPtnEC+dd?=
 =?us-ascii?Q?02DBLXKf3zcJl/1sHAF0ynyT5VBJuFJ4VJg1huTgnzSW6+BMYc+gsYCvXEAQ?=
 =?us-ascii?Q?2ALdm8HBnc2RB4f0xCIvWvDsXBVgbeXVLzhkfCAAMzKG+RBBJ6JH4wkNRE7g?=
 =?us-ascii?Q?sfeFOTDcCT1cyMMPn03K4agPjQOixRW/ZkpFnp1aTh/j7zLCo4hEMS6CWmTG?=
 =?us-ascii?Q?ZQ9bYjGZzGkc3iQBpsLFi7W9BoMRARl/ncznS8jD9WLN6qsIUfUTK0Jr6f3j?=
 =?us-ascii?Q?jc2vIvWS11/L5Ourw5ixlGh5GzxhH9zOfzdny601aKQkwf0ZxSe4xzjDBC3E?=
 =?us-ascii?Q?LyODTAJ2zq07NMO+4wmG3rZzKxfqqD9AWKVSj6od9hcJbdmmdvbcGILo+MBU?=
 =?us-ascii?Q?ZHkI+MXtO1UyywXUUIYx5eUTlyUzzUnI85utEt47y7QL2EIz2g1rLMuJ7e+C?=
 =?us-ascii?Q?frgkLPp7iSHSVOsLTKX6b7+GIw8+LyTbTIRpqVnRxF64KDKEhR29u5xnHyof?=
 =?us-ascii?Q?EGXnmWBwquTqSDiwXMio7F6jZZrZfLc474cTbYDf+gyomxqee/JV6i1z8Opv?=
 =?us-ascii?Q?fEYLE/yTfgcWB31uVlks0sK7QERNvrECguGnbZNIKiH+bj62Byq+o5+Un+Is?=
 =?us-ascii?Q?cDAvteJKHA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y4bbk8euoITQw2iuDBA84Wt0udIHpw+Rl2mWh7jw5dpk7cA1Ht0P7gcWMQhRQbaM01Fpv+a3UL4MqoJGa3ayGvbMuvX5WcCsfuchw68eCDUf7PQsMuM2gg+k+jog/JBVXmclj5iHnpEstsQ+5BWg4mw5zKwwz5H58+yo7TJHeSbLqeGZFyLaOpOBnpX77aqBnZ8ShdrnRUD8ohYmHj5a8Sy5+eo87X1SJ88Iwxl5X0Tn0yJxZpbdHN1ZA8nGXJSczNGdhlc9RS5jAq5TGPJTwVbChVeYRv+FBNR/Yzt4SIbnN2Ae6X6M7YqlhWWkUUjvZBYpu8Zg+N1aWTBr/19BMTPEkBgUTD+AWv0T+5ZTQ6wnsQNIZ8kieNhqFYCPLlQShugq//XuwxtuxZXP2sgzG2lP2aum1OCHp2n7eG1PF+UVOSwirUvDSXHgMr34EaUzJnkl0iLl/ObocuPKrzBtsdb7W9heyv+jDv7AYV2OYn+kHv0rF+msP2Bvjo2PM4jwW70wflpPxUa8nHJ3ZZJU13GR7dAkAqn039rxJjTZG9FsYAc9gAL4dCBCFVSK4ujJ1itNMMz34t678UDBwwp0nuZtHz5TXSbHJ7H09v4LV+E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8605e0e2-ed10-4e32-d694-08de546d836c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:26.7320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JX1pJnU9EeKoXU99fTqrZXubv2IntHT62GemiJIB5UbYms3/alfxoOyhJep6wZAuLDCpe7ZHQnwLrJr+4oO/kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX4qkEII7X9gCc
 5HEGWZDkXNMS4gqtEy4tFAzNtsEr8qK3Y2Ywq4NT6Jxypes08Xr6Ytha1LDo7+A8txKbqXg9EL7
 TmNm/AY4WVBfJ6cC2n89x5uUEoghynMaOqfwSJ1IKV3herktSP97gE8op3vGhUSzzQGswGseJWr
 9nI3ti10B2p0CGzfs3JGHKf9LToiLm/ihJe0W9GPs6VOPLldLfmqjTdscqkTV2GdfIJA5i9POtZ
 xAxw7ctMt2Kws3d4PE/L1NfXSek3eN4rSU5afw6omaMWvdBXzHRVCR5FtUy2gHg173Q+23ToL0J
 BO9xYlvXeA2M8UPZOClcW0xe4kRkUj2hXlYehwYOmUosfGxvf8j1hoDGqPG0wbyPtB8n20TJCiG
 LBPTjKPT7dOhPe8ApxUgxfLNj4gePnVMGng0x4e8ygoYOUTHHnx6QqUoFSp/+lZSGCnRlOAOjku
 IN+DJFDV16b0XNha8cq510n9EOFaMPrIZkQBHtiU=
X-Proofpoint-GUID: XinTYSmA9k62zgaAwGWtUoqpt5_VR0B3
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=696941fd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Dk5oX4W92Jz44JyhfwQA:9 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: XinTYSmA9k62zgaAwGWtUoqpt5_VR0B3
X-Rspamd-Queue-Id: 398321C0008
X-Stat-Signature: 917haitnw38a7cabasyfz896xs91j7ei
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768505860-421856
X-HE-Meta: U2FsdGVkX19SLrIbUPUyTd58AWaQ0y4sBzXrov+3OgiQzw3VgtbjftTdYARZTe63ttkRPhwr1RAC1yqb32JDE8OgrWcgAN/2glfIc0xRYpNLtMC9I9BFTw0R4eXgXuYt9WM2ngw+BP4SvR7YrE1FngEnrySJvnOgE/MlbsvmOAGOOs2kvUzU3T6HEikKCW7EtDpD3d3yxVyem/JXDbRDl83CBBGW4bvu5eRI5Bs6IIo2IZlgLgmCYVFr/+pZeaJwpl2Sj4gWPRLKLWq1j5WuRihBf5HeobOkrZkTwOw7pDCNzbMQwD6byqGzgKqpUuzJ89poyRxBiLAzAen85CIE0oLZj7lQukimPZvrT2fKkVZEWColjHnyDgQ/c4M+WHtZazZaDFfnVugbzQPHnbs57cSHLH6Io1tcLyUVUheAojt4NYO5ojzikH+dxsX9E6uLZuHJ2TJnf+bqZKePcbiKQEJ1h2uQIJXy4TdVxaK0Mxr1O9lOBZ7OUPyLRAPruW1Kge9aST8764jsA9vkUzAn593Qo5kVRpJQoNPKK9h32RrJqYk38qiv0959Faf1AmjKjg51kCI2o6gTrCifV3Qn4SDKZYrn6/KowMH4w36unCasjRqoPM3sr4Rjs/ebcbr3hVT5fU0xNUha8XmJZR3wyYRYSJeLeui6YE58Sbz+YabVxgm/gsYuKrAlb3qHx54Sn6RSIdAZIVZ0HfcQiCQpWLBg5Bl8/kBUcXMeYuKG0V7o6X09Poa9SjmH4SUGRqqAXyR5mtoC+hINbURXxU+kGPm8ywhTCuup5dJXJCdw5R6+85NsOJ7TGA5mlmedAKrCLJwWQ9uvVaz3AXJkk4zxp9ICo9+plEYrt366WjCysbaLmRjGeQKtrVvdESLhLeqKsSxBbRZrHuX4lMYagc0V1HemzF3+A7PUKYpDh6wmpgC8YOWjsyQ1aUGA33IDihbthMCVutwpbWZesUlcUYm
 KQBM1wiI
 OdozSLpHD+HyJDGWhIik9LCL1Zvd4975GKQVZnRbwQ7U8QwohpzSdJY1wIksgKvdzAe6vpX+3lzKPkCB7iTLp/Io0ZBYU0KQIWnFnL0M5rdgKtOTQAotbz7sx5vTFkKTS2umyJFOa94f38EusZqUFAeuadaiFyy0RBzVgH5I5QFdKLqbXy2NHqNFIGij32K5CwaENR6VBxzAM1ZVN9FMWaUabg2EVparpo3MirDpITixrGIGxwZwxygcPWZU6OFCuJkbKbaq3XxnbgEc3mUNaqvY3HoXcMZBhxB+KQofQaHaoCHS8VI8laYQmro7pR0O81Uo0t1vPoeuwljlWIMBmETZuaC3xy3wyklrhrAIJbTCtoIEqh3ogYjMH2OlYXd3S2lbJDPW8ZIoqQAinxlSGOwAX1czlkUxHMbQH4pV4VKXlEh80p6C/hvmje+Tt6jSjGh38+tqW3ieIXMzwExv7f/XbME6wXmsIJvrg2n8QjY0dEHgzHXxYlrdH5nNWogfP15hisovBkejUwsYh3LEwdhNaLqbQPHIWcqEF+16kKq+9hNVeel2taMMzz6ZOQvARdvKh7qjBUpo8fpV2OllGRfCYTuu8D/QJfaRqwUFZ+BL42mLDWNJa6gklDB7j4s89hte1KH9Yjyj5IqgzlUqpHayK2ioO7j+Czyd6ParBCqMSwAWWRX7rDRq81g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of copying the data into the big node and finding out that the
data may need to be moved or appended to, calculate the data space up
front (in the maple copy node) and set up another source for the copy.

The additional copy source is tracked in the maple state sib (short for
sibling), and is put into the maple write states for future operations
after the data is in the big node.

To facilitate the newly moved node, some initial setup of the maple
subtree state are relocated after the potential shift caused by the new
way of rebalancing against a sibling.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h |   1 +
 lib/maple_tree.c           | 175 ++++++++++++++++++++++++++++++++-----
 2 files changed, 153 insertions(+), 23 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 9bc7fa89bc2ee..e99e16ac1c6da 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -177,6 +177,7 @@ struct maple_copy {
 
 	/*Avoid passing these around */
 	unsigned char s_count;
+	unsigned char data;
 };
 
 /**
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 969be457f6df8..4dd1cc73cd27c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1304,6 +1304,18 @@ static inline unsigned char mas_data_end(struct ma_state *mas)
 	return mt_pivots[type];
 }
 
+static inline
+void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
+{
+	wr_mas->node = mas_mn(mas);
+	wr_mas->type = mte_node_type(mas->node);
+	wr_mas->pivots = ma_pivots(wr_mas->node, wr_mas->type);
+	wr_mas->slots = ma_slots(wr_mas->node, wr_mas->type);
+	wr_mas->r_min = mas_safe_min(mas, wr_mas->pivots, mas->offset);
+	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
+				       wr_mas->type);
+}
+
 /*
  * mas_leaf_max_gap() - Returns the largest gap in a leaf node
  * @mas: the maple state
@@ -2258,6 +2270,44 @@ static inline void mte_mid_split_check(struct maple_enode **l,
 	*split = mid_split;
 }
 
+static inline
+void spanning_sib(struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
+{
+	struct ma_state l_tmp = *l_wr_mas->mas;
+	struct ma_state r_tmp = *r_wr_mas->mas;
+	unsigned char depth = 0;
+
+	do {
+		mas_ascend(&r_tmp);
+		mas_ascend(&l_tmp);
+		depth++;
+		if (r_tmp.offset < mas_data_end(&r_tmp)) {
+			r_tmp.offset++;
+			mas_descend(&r_tmp);
+			r_tmp.offset = 0;
+			while (--depth)
+				mas_descend(&r_tmp);
+
+			r_tmp.end = mas_data_end(&r_tmp);
+			*nneighbour = r_tmp;
+			return;
+		} else if (l_tmp.offset) {
+			l_tmp.offset--;
+			do {
+				mas_descend(&l_tmp);
+				l_tmp.offset = mas_data_end(&l_tmp);
+			} while (--depth);
+
+			l_tmp.end = l_tmp.offset;
+			*nneighbour = l_tmp;
+			return;
+		}
+	} while (!mte_is_root(r_tmp.node));
+
+	WARN_ON_ONCE(1);
+}
+
 /*
  * mast_set_split_parents() - Helper function to set three nodes parents.  Slot
  * is taken from @mast->l.
@@ -2635,6 +2685,49 @@ static inline void cp_leaf_init(struct maple_copy *cp,
 	cp->end = end;
 }
 
+/*
+ * cp_data_calc() - Calculate the size of the data (1 indexed).
+ * @cp: The maple copy struct with the new data populated.
+ * @l_wr_mas: The maple write state containing the data to the left of the write
+ * @r_wr_mas: The maple write state containing the data to the right of the
+ * write
+ *
+ * cp->data is a size (not indexed by 0).
+ */
+static inline void cp_data_calc(struct maple_copy *cp,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
+{
+
+	/* Add 1 every time for the 0th element */
+	cp->data = l_wr_mas->mas->offset;
+	/* Add the new data and any partial overwrites */
+	cp->data += cp->end + 1;
+	/* Data from right (offset + 1 to end), +1 for zero */
+	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
+}
+
+static inline void append_mas_cp(struct maple_copy *cp,
+	struct ma_state *mas, unsigned char start, unsigned char end)
+{
+	struct maple_node *node;
+	enum maple_type mt;
+	unsigned char count;
+
+	count = cp->s_count;
+	node = mas_mn(mas);
+	mt = mte_node_type(mas->node);
+	cp->src[count].node = node;
+	cp->src[count].mt = mt;
+	if (mas->end <= end)
+		cp->src[count].max = mas->max;
+	else
+		cp->src[count].max = ma_pivots(node, mt)[end];
+
+	cp->src[count].start = start;
+	cp->src[count].end = end;
+	cp->s_count++;
+}
+
 static inline void append_wr_mas_cp(struct maple_copy *cp,
 	struct ma_wr_state *wr_mas, unsigned char start, unsigned char end)
 {
@@ -2663,6 +2756,42 @@ static inline void init_cp_src(struct maple_copy *cp)
 	cp->s_count++;
 }
 
+/*
+ * multi_src_setup() - Set the @cp node up with multiple sources to copy from.
+ * @cp: The maple copy node
+ * @l_wr_mas: The left write maple state
+ * @r_wr_mas: The right write maple state
+ * @sib: The sibling maple state
+ *
+ * Note: @sib->end == 0 indicates no sibling will be used.
+ */
+static inline
+void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas, struct ma_state *sib)
+{
+	cp->s_count = 0;
+	if (sib->end && sib->max < l_wr_mas->mas->min)
+		append_mas_cp(cp, sib, 0, sib->end);
+
+	/* Copy left 0 - offset */
+	if (l_wr_mas->mas->offset) {
+		unsigned char off = l_wr_mas->mas->offset - 1;
+
+		append_wr_mas_cp(cp, l_wr_mas, 0, off);
+		cp->src[cp->s_count - 1].max = cp->min - 1;
+	}
+
+	init_cp_src(cp);
+
+	/* Copy right either from offset or offset + 1 pending on r_max */
+	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
+		append_wr_mas_cp(cp, r_wr_mas, r_wr_mas->offset_end + 1,
+			       r_wr_mas->mas->end);
+
+	if (sib->end && sib->min > r_wr_mas->mas->max)
+		append_mas_cp(cp, sib, 0, sib->end);
+}
+
 static inline
 void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
 {
@@ -2866,36 +2995,42 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	struct maple_big_node b_node;
 	struct maple_copy cp;
 	unsigned char height;
+	struct ma_state sib;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(mast_l_mas, NULL, 0, 0);
 
 
-	mast_l_mas = *mas;
-	mast.orig_l = &mast_l_mas;
-	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mast_l_mas = *mas;
 	cp.s_count = 0;
 	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	/* Copy left 0 - offset */
-	if (l_wr_mas->mas->offset) {
-		unsigned char off = l_wr_mas->mas->offset - 1;
-
-		append_wr_mas_cp(&cp, l_wr_mas, 0, off);
-		cp.src[cp.s_count - 1].max = cp.min - 1;
+	cp_data_calc(&cp, l_wr_mas, r_wr_mas);
+	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
+	    (cp.data <= mt_min_slots[l_wr_mas->type])) {
+		spanning_sib(l_wr_mas, r_wr_mas, &sib);
+		cp.data += sib.end + 1;
+	} else {
+		sib.end = 0;
 	}
 
-	init_cp_src(&cp);
-
-	/* Copy right from offset_end + 1 to end */
-	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
-		append_wr_mas_cp(&cp, r_wr_mas, r_wr_mas->offset_end + 1,
-			       r_wr_mas->mas->end);
-
-
+	multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
 	b_node.type = l_wr_mas->type;
 	cp_data_write(&cp, &b_node);
+	if (sib.end) {
+		if (sib.max < l_wr_mas->mas->min) {
+			*l_wr_mas->mas = sib;
+			wr_mas_setup(l_wr_mas, &sib);
+			mast_l_mas = sib;
+		} else {
+			*r_wr_mas->mas = sib;
+			wr_mas_setup(r_wr_mas, &sib);
+		}
+	}
+
+	mast.orig_l = &mast_l_mas;
+	mast.orig_r = r_wr_mas->mas;
 	/* Stop spanning searches by searching for just index. */
 	mast.orig_l->last = mas->index;
 
@@ -2910,12 +3045,6 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	mast.m = &m_mas;
 	mast.r = &r_mas;
 	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast.orig_l->min != 0) || (mast.orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast.bn->b_end <= mt_min_slots[mast.bn->type]))
-		mast_spanning_rebalance(&mast);
-
 	height = mas_mt_height(mas) + 1;
 
 	/*
-- 
2.47.3


