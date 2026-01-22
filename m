Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB230D3EE60
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C496B01A0; Thu, 22 Jan 2026 08:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C636B01A2; Thu, 22 Jan 2026 08:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE9A6B01A3; Thu, 22 Jan 2026 08:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 497086B01A0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13E981A031F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:37 +0000 (UTC)
X-FDA: 84359613954.29.ADA0427
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 79C5C4001B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cn5xE1bG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UQfDydaE;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8+mmP1U02Omf0Sy4YS+DkiqRVJ4tarmQ2ZXql+QKsw=;
	b=Gxr09bs1oEEVGf9QxibE+irFOZXV7uK70WpLu/rSFa9iS2LObIPtZmRHZyDfgCMYORuJuF
	BzdP0YGhv0D3FEHBujxVdk95TjR3QhfNGdogvL73aK/E0JkCsMsxGD4XSEBSkm8GDIBWKQ
	gSmsFWJfWJwmc3GM3enzABPAPbbvl4s=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cn5xE1bG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UQfDydaE;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086953; a=rsa-sha256;
	cv=pass;
	b=10ajhVRykjFYfl/nJVVUacrtmb5HDvLtrpH5dxagJoX3wDjcvZuQa0H824mJgO4mxcDu10
	11N0vmwUAN7+2mKFkg+g6UdTU4I1RoisJhv78ESejG39HfaxcR64BpPkQjpmwz4BFCcWnI
	1hlvCcZKmrg/ORopregxav24jTX+Yco=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LNfDsc3265014;
	Thu, 22 Jan 2026 13:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=a8+mmP1U02Omf0Sy4YS+DkiqRVJ4tarmQ2ZXql+QKsw=; b=
	cn5xE1bGleRd1nbIC9BMFWSWwriCJ8s3OD+HRQnEZiVQeR48hy5o8gEhDWBH6Cxq
	f4Xwec7/CuKgOl3iK+nBTEloT5hEPP7PTN/aHECWmm/4iBLNvpWBJnZzNSL4uqxS
	ZAUawRHny/E+SCOizgBtZhCWBwbQHoULRfgytercR5V/O/fJ1jQNjAOA5bKjjLTy
	8F/kD58J2ar2Bhtb/fR426OeLA+b0P5fSUK/irRAaY+q5gDz0p+E4bYkZ8FWvhwr
	pmiBxgl1fN80vLQdSUGUV+zCuLcTCwUrbwJQ0M1PUth63H2xb/XTamGjmpckvNo5
	JBKwwSLtEotJ2PyiMYEq8A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8fp72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MC3PNA032149;
	Thu, 22 Jan 2026 13:02:14 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgkfyc-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wY5GyImbTDecGaLqeH/OVoMekslbj1L05pksnHv82C2l8DSLVVSaZ4uRrQmkHi4f9QhxL1njMLJlgljNDJNL0Q/d/wl5Klsb82U7YG8VnQhgABfE94sK82qdKTc1pf/NtF+GN2AenioQVwXy28seFLuGSfNtmrEDeRJoVUASLKs5+0E4dU7pORhbn84Xs+8A06hPEmTHBXSNVd1qe73QzyqjCroK9r9ysFG3frhhqBXpBBgS7oo+8RlgKIZdHUu0A2bMF1W3JCzFBB0TnjUQUTnDmuzLVbsfaEo8wiDgdLdkCzMd2ZfWFp75fWZFRN5CqwreGaJsWFUT9bPIab2P6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8+mmP1U02Omf0Sy4YS+DkiqRVJ4tarmQ2ZXql+QKsw=;
 b=t3ufWhxtC9xRy9zrxtYbaA8wLVCO4l7/ZVPDZTE5R+PysI0pta8fJ5Wi8+/tMict8WfbS1WhWWpZ62CQuUJSUr2sNWm+SCuRc5fPm7fv9Zp9ANMrPIdwYzTxqOH+Q8sb8wZNV+lB/Sbl+xmmNYgDxrTGZx9XmHlOvI0eEF3WvtLVqiUupBH0V9i6xey6PKHIlNHk1PYFF25ErBz8JOt/Ywcn+gi/wv98kFAEUjEtO+YtG0UESjP8iQBXqYyl69kJQ8MT5G9Ws1TqhSPkLJgjEV6isrjeZNETV+wsS8DRyOx7N4XV69F7V7h4FrmtgT2fBnB/ozIdYjYClw6yh2UYFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8+mmP1U02Omf0Sy4YS+DkiqRVJ4tarmQ2ZXql+QKsw=;
 b=UQfDydaENPCXxEjGfJQ1smkw0/dQFMVgWnbPFzQGB2SysyxK53qSjZPTxrd3MlRhEIQfU0Qee/pXTb8Wmpmcxr6hiHd64vq2xN6Kjx5+Dc6zkAubIMFhpG/qkoxxkmLub3V5+nU2G42e3oFgwwggK8GJ9tpA4rrzkuUkhEa8CK0=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB8198.namprd10.prod.outlook.com (2603:10b6:8:1f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 13:02:11 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:10 +0000
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
Subject: [PATCH RESEND v3 04/10] mm/vma: add+use vma lockdep acquire/release defines
Date: Thu, 22 Jan 2026 13:01:56 +0000
Message-ID: <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0125.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: fc85ad87-90b6-4e45-5b5c-08de59b67407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8to+MJIsIEzP6z4l+8H6HRDrxGqz3Cau1sQ+m7AwRHaTzQbsW2HG5alAYnz7?=
 =?us-ascii?Q?ljlfkCpNQgxCS79tW1oKVcZl+HuT9q8QPjdGoRI0E3dGqFx9eSj56JywbYgn?=
 =?us-ascii?Q?t9N9Sebkwkj200eTAYSwx1lUfu90F07vQHB3o2/TKxntnTV0GoXWtUwN8eZM?=
 =?us-ascii?Q?Ncgmykz79Cu6BHkvqio7vSAowkm9roSbN5r6q6Ozvr9TRicnkN6bVlXRbuhs?=
 =?us-ascii?Q?xG54ceL1zHCMLzJ97Xxnlu/4ns9iLzNv1vcGS68z7RYuva6/T9/cqllhFIS3?=
 =?us-ascii?Q?AoKaEvUGsVT7uTDU72fCgCk967iu2rWVq7XuKUXVrSgY4zKf3MmmT/GdIog6?=
 =?us-ascii?Q?TBXWAWXgH5dBeFAbC2wAfCby+22QPs0hcbrbxXqDKgQzRyxhjq6myUulnkYg?=
 =?us-ascii?Q?NL0A5/TBcoC3rgWRKN9EZaVAnpRnZS54Bt2kSTVWjE92uyjmGBAbwjV3d1TP?=
 =?us-ascii?Q?2eRx14Ce69XqHKKmMh9WcrYkrCV8+D2Op7Gqx63GWMpjDccvb1q8duJb0+VJ?=
 =?us-ascii?Q?k6ljf/p5VwNaPx3Bva1ouo8fUCuOOXx2plWuwRc4ASL8EwSgs1bj0wMuXiuq?=
 =?us-ascii?Q?2j27EccVM/0bt+7v8KqeAV+QufxFYKv7Tkdub3vw2Z1taH+DmECwcLK00MYX?=
 =?us-ascii?Q?+Qwd4p9h2dbrdZ0fbjTd06VBO71iO5zFZ/9rKVxB0kx8fP7Mf08ZmIvdhnLa?=
 =?us-ascii?Q?UEiYdtWkFyH+ifExf/qlytdI2lq5mmcNizuHfV0Syy3UCZU5vGbMR1GGgyO9?=
 =?us-ascii?Q?uT/Gl1Q7s8Ia7CXLPi8VRahR540eNGuQwHioA3mcM0OpfnNhKsq1q7mrHDqO?=
 =?us-ascii?Q?upOYBm+H+hGOe4OhIsO7entGeXAF5PIcVNH+vUqpYxqvyUYWKpAsQs4EaZJM?=
 =?us-ascii?Q?tONiBKJYYhYFjGF8dFMCSAGTlFJBhW65wqkSeQ02EuONTMg6FB09BwXKxMol?=
 =?us-ascii?Q?ZQvOzczU6Zl4WQ0RoT5q8VFawsTY97ZXjAWBDNy2QEzQR8ZzkNG4TRbL2i+q?=
 =?us-ascii?Q?akVWqVgka6LazSmEJw+nKF8THK9X4X42oJsIB0MPvK+QRZX04uX4rJ87Z43x?=
 =?us-ascii?Q?oDTDOyySKApPfLmagvUMXX+ZH4kFoM2zYnEMjWnL/6sgLz22D+IYBzeaWw2j?=
 =?us-ascii?Q?suQsEZKyunpmSqKYew3AQeyqoXx8c1a49xdc08LMlrOJ8MdoDFEYTooOLMQa?=
 =?us-ascii?Q?DbYdJd9rzbfBrj9AHSHeUJLHaRG121dF+fpyfGKiuRrGsM97b2GlePH9wsPe?=
 =?us-ascii?Q?80JWiHwpbXB1wNYJ9r/WJUJjAbviwRolnAg/V24o0GPhzcEJIB1xG+EMN9fF?=
 =?us-ascii?Q?E0O932Z/FBI4yBx7/2eyxaR/pr9IZrgZauA2A8HBsSwap0VwV0frHHpLGcRl?=
 =?us-ascii?Q?fnjFN850BdUTvbyLd24nvpTeGUdMwWnzfmq2JLDUL0IrsRBLLvnrz/RX/To+?=
 =?us-ascii?Q?wb5cGadZjItayRzusZq3Y3A010CWjzWPVS72646v4PvdySsbg9sdpnsqvb24?=
 =?us-ascii?Q?2Ptip7bV/caTKbFg0OsAhe1t66RcK/0dwvVFXuTnlXRvWKdg4sMl6xOJ3Iws?=
 =?us-ascii?Q?hVUYcjiV3F1TSPHw7fI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FuDaT5Y6s6eHNoFBXIcpEvj2SHtefKi6cwJrkbikUIFrQEAAg8kBpvBbcHuz?=
 =?us-ascii?Q?e2nYCBaLDikyn8A8hQ6O/5eH/vbSu0uQOfPskjMdQGvIeMFcVf1BRcXpZJKA?=
 =?us-ascii?Q?AWNU/FqZ8i//pP49un/gcVeUKbm62vp7w1O6ODK470KPS3GEdzEV3QigeZn4?=
 =?us-ascii?Q?WZI8qs8vPKHb4eH2mHEsqaE9Q9J5C3ls7dhugGYqeyVOf2acsqJStITDF+yw?=
 =?us-ascii?Q?XiA8h6Hp+lgVMaI8TZhByg/a+brQMvXcy7vN58UyXTw2d/yTdgQ6PjGnCKzl?=
 =?us-ascii?Q?AJ6aDCflfOq1B8+o0iZTDkIoCG1btNovIZxHmdGGjx53a38PwDXLUbTLBCiv?=
 =?us-ascii?Q?8/HwgWr6RlcG9cSZoWoiY5mJRXeZnX13YffxLvZ5vWH1vaGrdDTY8DWxfgTY?=
 =?us-ascii?Q?GZd2CI2FTM0dWOUBvqioDrOna3bcJEx7gJ9b44s9eDvj0/wp73Ssyk/X+D5p?=
 =?us-ascii?Q?jXsnZjl7BCb/BxfGXf4Lsbs108jstSxgYc5C/zzx14s3YzzPQq7Lauw4V0+V?=
 =?us-ascii?Q?a5GaFfLwb4slOSSR3Oklx9e4dC2BIFq/ni0wJqGx7bTodkW1dUyi6FOUnXwt?=
 =?us-ascii?Q?gyaUONAAbVvcv50+tS8Q+ZcJpBR/lZcEdY6AJ1jRI6EJ7ntKiqKtfo6XkGLF?=
 =?us-ascii?Q?5jUj/jZNTIWzF8RkR3oaHJ2vHrZK6qPcKcuAU0XNNVF+h51YDEnr60IWwneD?=
 =?us-ascii?Q?8beMy7lEW/ZBMCqcnrSePDmrE3JPE2nFQg35nqnPneva6mG1CyhvmHcfmY7D?=
 =?us-ascii?Q?zJkO3msQD+bTYkHzJ6mEvyr7T0kylanFuY6cB6b2S/SX+WW6/Zwxz9uREFEH?=
 =?us-ascii?Q?stDzeMkpVwTFeJUPC0oCCAdrI5Tquw/GTUDPCAFDWQrX8D/coPssLldWgv3Y?=
 =?us-ascii?Q?D2B4Vhsa06SsA3xQjMox5A+BqwpNHnu2/3+8TwldMIndk2hgE8nRTF4NduHJ?=
 =?us-ascii?Q?qFBS7RPbo1CSvYQpujLkib/lr/lVm7TCTp/rgF+p8LZFbrgzYLjI/aoWU0oW?=
 =?us-ascii?Q?lK5urbif9gPoxYiK3cr/kA0NGuwVXEQ4HkwaV7VV8YY4L5KwrYcPqlgSzCxJ?=
 =?us-ascii?Q?dp5m9U47ROhBb2bUx4Eh2iQQtSxCsl8oYxSe2ni5ThLIjjamhEWNQOl9LGqY?=
 =?us-ascii?Q?UMYsPPkAoVKKOY6N9xaknLrHKXIb0SOQ9JjlibKxWcDt8pWBsRl5XLTBwjil?=
 =?us-ascii?Q?EZMBzi3F5P6bBv/6hj6vAXpkJ/5HTJHiDQoeQNXYUaXFX2O39ai9VeT+7PuS?=
 =?us-ascii?Q?xpgaVUYQKW2a8YXOgmF3ZEt3GgY1m55Yo94H8Gopr+XQfbFryx2uQSRYxq28?=
 =?us-ascii?Q?O/YgRRyE5xPuL3pWaFf7rkl9K7W+z0J1dYHD5Hzs9dKv+Cr6OtQeS8meO21u?=
 =?us-ascii?Q?VIzyN1kamdsXJadGJBJDuQ5LVlfw+5lzGqsL1KZKTR1vM8IQxdoSXHjGm2xh?=
 =?us-ascii?Q?fYGtW1Np+KK9yif03lkJOjRkL1uxWyrsFD9eMFjtMANz6Kh+WSeeHXs2p/Dg?=
 =?us-ascii?Q?pjf6l0+PDAnI3LGrsVvQ/aGzR18EZix+uaPdKbzABN5lDbBOiu3NtQ9k83b2?=
 =?us-ascii?Q?majq0l+N48rToKXPX4O0Xqadrrzo7WsTm1hTsaJf22VBejsAeLs6Qvrf4qDo?=
 =?us-ascii?Q?DY7EAJgYzRlJRYZYvwQqsmzT0HD3jlLDX/YTZvCE8gboqejCD/VsnR0kE8RI?=
 =?us-ascii?Q?tLR2zY73LIOdYEf1DEl106xXRC3hfz36ZKDIflkrQPwZMGKalPhJF7jlGmvp?=
 =?us-ascii?Q?yMEGP+1PP+4FlpLRKoxSQNgCvXw29bg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	22PibEl85To4vLNLbEP7A7StNRbcVlKT15HgQD3HLjQ4+Fav7cGfgNGHU7gTvlwToWKMjCVDKxYZcZmTEtCmDv3DC1LYfaj9sKwnQFGx1VXwEqoG1tWt5Ef9XtN22qcw+lDe+2+LaJlMt+xfG6uUiDGDdGXkIh6Lil3WIXKG6XX/5rgxXx8HfR7iS3chKGqLQr5lKQauSXR91PaZdOkUdY5PCZBknu3a5duOJes6VSZbTGLw1y/1+zIYt6qpc0lOU4L9RUKfQ3TEi7t884XvIBUBMMPhhqXR5MJNmP0FqRQvbNGCZYTUHjxrrNVrJ0OPdRHwEgtTIkw+qLKgGjthl1HFi3JZjBW5d2bi0JqfrTjoUomvfV/G0SGmt+736fWl21cK1W0sXjfnyz3NzhyNV01gFQlDsTYiHqaQ85VerRJORkJiPuIR5hrtn1OObXXp+xWZIX5O3VqVWLSsE08vQAnpzX1PbAIdhBEDzBk2DAg7AjY5/CY1CIGSzHrWu1bLWDtyEEaUigApjUwZI3Dg/Ms8VZfyIfw4p/C0t9bmm35C23hVKoyUgaW9jvCMTnx+phba8UzY9llR4pa+P1SETh3YTU9xVFenxh90ZIzzpek=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc85ad87-90b6-4e45-5b5c-08de59b67407
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:10.0223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0qGmqpcuOerUDONnSIRuDKXhK1raPoRcc5yw6ZJl72UMvKCsSYFyZnEKZtEN1vYEEEZ1xICAG07J24nNWxC3zicwZqwNB7q1uGSdYBxPKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=69721fd7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=nIt71nLUYc_4VLb9du8A:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX4D4S6IMEirsK
 I3eKMLEpgD87S3T1laHDmr3Ii0qDzb4wYxBHt9JQb5BDB9uT2Rf2ufxlHxVmqH3kKBLKO55KaPL
 BOqnzpjICDheLAJK4aITIVoHyyio6A18hlL5NuRq2aqFspanye6jQ5KtGSeiiV4ujUQDAjeeejT
 49vJqaeMTGIZjknlJSHHUQ4P5H4WDFQr+o38ee7OeR3Iyi6yyrIH3ryfMsNGPC31msp07T1wzO1
 oD8cgefsNzRhqAaHP82zQA7YvNexraWAh+oFIU2cllk9yyalW4+Re6ZCA343Q5W7a1LwoYC9Gxz
 0WAvIE/Zxf+BWi7m655JVoJqvi7cLQiROzqmQHttD9pGmWKxbWrX97qNwtlxpgiXHvUxPu8yRZR
 CXiUAziR/7KgE95GJYXdJdxEB0JZcxV83voSeY6D9hRLq8XRHMw752o4t3cUfCY3zmWXL4KDKwC
 guIx/vym/gtgBluL5stpkyO2W/Lc8RJQxwhUDbug=
X-Proofpoint-ORIG-GUID: BTphIMq1Mysvdu0afgbOIpFxjew5Z_fC
X-Proofpoint-GUID: BTphIMq1Mysvdu0afgbOIpFxjew5Z_fC
X-Rspamd-Server: rspam12
X-Stat-Signature: dbte7o7g3b4d46phpi7zfthmskcrmchh
X-Rspamd-Queue-Id: 79C5C4001B
X-Rspam-User: 
X-HE-Tag: 1769086953-222439
X-HE-Meta: U2FsdGVkX19bQIbu9GCLR7CP0zT/0ezUqEtf+kB+ENo2Mx+a2rbipDJnN3X79oVS6SKnbGx4Fsp19uyqRg+YapM6Q28GQ8KuC45VS2LnFdwBdJS8DiAdOHrxo1yhnHy3CjO31gOKd5Rxr3jBORrty0VWyT8URw22NUWy0rbieTvDIQgMs7Qz36yW48lDWile5pHjmaFXnhyDjP/OXj01fvc85/HgxYI28QHA6k447D7iFsJZrW1yNfyOIhjFVWSDvAW5PAzKG5IJozh88Fugn4BMY7PueFH6K7w/V6P/aFX107IAZEZv+ZNG4qqrFF3M1X2jYlgwkP3X0PRBGR62T9rPRkhC2feWuz61OJZ8+V0M1DfPDp/uF+7XWB36KGxgmz8hyAktknA6clU0/Ek8Ud1zyu8jDXoZp4NwkCcnvTm+BqpVIsOU6FgjRlAQEQeZgwx5HMeQU9HEPoUijcqGGaPFsatX06s8+vZbUqIBtLirYap808yVWdbx9HAt6opSwNrjRPjBa9RfM7jhwp32AQ+QRNWAz56veFaczcY0ylSdTvkeTNouoFIiU0gTkxjWZ4IWop+719at43XxshXdYdmii8P/Q/O6ZtULgGDCpPJsqwJb3mpjU429Y0JUa0B4c38OYnynZUa3olnmW2i4uBsjtVr4NS5UVvUhxRPgdvzLjHOLJzcDJm/xsYeUNKvsBHsUiOt0D+VDjebJ8rULXQ2D9FCgyhkHs99Z0WP0ClLcOB9vG/ddbuXikHubEuojQ64FNlqTCqbnz1ZEnQ+NH/0vgfIGrup8vPqESg1tNC8d/cFv5Fp+EZOTKUVqpl3hvKOeurvxYIU23h3ij66bHjWjmdJhoMro4uf7hjqa8PbJjJEZcwpp9jygbqR5g/r4gcYHQJjQprRs7cnU0q0x8YZsEA9zKqIbEl8tswqFmkBJysHp/6YXVWXMR5KBWVTFd8Z6IcEarj+XZVIVBp+
 NQB85hf6
 lrljDPQZ+/VgnzuzZOjOmEhUa5m/i7l+X5P3dnJsAr8v/b0zIpLpRz1O37JjO6E4eqBIfBQ3CQfp7v/bgTwxv/Thuh+EB+5NpqWxbSXwlMGiGcSkCaqeHGdeu1sh/WS7coEOt+mtt/vXGolyB6Vted4XVxhmqPlrZ/DcJCJVqChY3w9EtWtxxeokoZBNrueIwBaGl5QDgj1SEap7/9Lg0eba1WOAGsoO6d+dlTXAvPVzvaJkRvt9HAk6PphqAfo8vM1mhc1nO1rSDFKSufNW06OLcHN1zSKE/YUDUa01VNB+a7U325p1pdf+F7nhbJtoxngeOZPbVNeq9vIO6OEXdxXEI6+7383CAZ6wS/pgxctvvjBwB6imy/GXdRWN80HTnDyMIug9g3iuE1qWFhqvjR1N2xkqj7636DB11ulSlNiXXwOxQbfO2hh/t5d0IhZ7jFOrAA4hcvPe6BE+RUopahRrdSJnsCDdtwlPhDepC+ScEJmxNScd5fDBTtYeT188YMR85EE9sCVy4mR/0ZoX7LaFgrhSa5uDTYwb0qC3jsT/PjRR4g/eQJWJ01/XWQvylzvu/MNiMEy7tLQcDTCWrbUUaVF26hCdbrNiNZLXrGcIbjwHEZhxSauH3ifKQq2KHxfiNzfg+XjZx6Dx9hdP/qeKjg4G/CDg08nuzgYolCrIr4+3nPGENqtqb+B6MIKY6gC6sGDgQ1LB2akdLKlmVmxTu+ZynWb0Tpwxak2jct8CjmK5hldQ6h9LDzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The code is littered with inscrutable and duplicative lockdep incantations,
replace these with defines which explain what is going on and add
commentary to explain what we're doing.

If lockdep is disabled these become no-ops. We must use defines so _RET_IP_
remains meaningful.

These are self-documenting and aid readability of the code.

Additionally, instead of using the confusing rwsem_*() form for something
that is emphatically not an rwsem, we instead explicitly use
lock_[acquired, release]_shared/exclusive() lockdep invocations since we
are doing something rather custom here and these make more sense to use.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 35 ++++++++++++++++++++++++++++++++---
 mm/mmap_lock.c            | 10 +++++-----
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 0b3614aadbb4..da63b1be6ec0 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -78,6 +78,36 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)

 #ifdef CONFIG_PER_VMA_LOCK

+/*
+ * VMA locks do not behave like most ordinary locks found in the kernel, so we
+ * cannot quite have full lockdep tracking in the way we would ideally prefer.
+ *
+ * Read locks act as shared locks which exclude an exclusive lock being
+ * taken. We therefore mark these accordingly on read lock acquire/release.
+ *
+ * Write locks are acquired exclusively per-VMA, but released in a shared
+ * fashion, that is upon vma_end_write_all(), we update the mmap's seqcount such
+ * that write lock is de-acquired.
+ *
+ * We therefore cannot track write locks per-VMA, nor do we try. Mitigating this
+ * is the fact that, of course, we do lockdep-track the mmap lock rwsem.
+ *
+ * We do, however, want to indicate that during either acquisition of a VMA
+ * write lock or detachment of a VMA that we require the lock held be exclusive,
+ * so we utilise lockdep to do so.
+ */
+#define __vma_lockdep_acquire_read(vma) \
+	lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
+#define __vma_lockdep_release_read(vma) \
+	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+#define __vma_lockdep_acquire_exclusive(vma) \
+	lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_)
+#define __vma_lockdep_release_exclusive(vma) \
+	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+/* Only meaningful if CONFIG_LOCK_STAT is defined. */
+#define __vma_lockdep_stat_mark_acquired(vma) \
+	lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
+
 static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
 	seqcount_init(&mm->mm_lock_seq);
@@ -176,8 +206,7 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
 	int refcnt;
 	bool detached;

-	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
-
+	__vma_lockdep_release_read(vma);
 	detached = __vma_refcount_put(vma, &refcnt);
 	/*
 	 * __vma_enter_locked() may be sleeping waiting for readers to drop
@@ -203,7 +232,7 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
 							      VM_REFCNT_LIMIT)))
 		return false;

-	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+	__vma_lockdep_acquire_read(vma);
 	return true;
 }

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index ebacb57e5f16..9563bfb051f4 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -72,7 +72,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;

-	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
+	__vma_lockdep_acquire_exclusive(vma);
 	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
@@ -85,10 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 			WARN_ON_ONCE(!detaching);
 			err = 0;
 		}
-		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
+		__vma_lockdep_release_exclusive(vma);
 		return err;
 	}
-	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
+	__vma_lockdep_stat_mark_acquired(vma);

 	return 1;
 }
@@ -97,7 +97,7 @@ static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
 {
 	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
 					  &vma->vm_refcnt);
-	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
+	__vma_lockdep_release_exclusive(vma);
 }

 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
@@ -199,7 +199,7 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 		goto err;
 	}

-	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+	__vma_lockdep_acquire_read(vma);

 	if (unlikely(vma->vm_mm != mm))
 		goto err_unstable;
--
2.52.0

