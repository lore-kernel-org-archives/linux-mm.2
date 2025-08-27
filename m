Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F7FC8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BCD6B035B; Wed, 27 Aug 2025 03:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0227A6B035C; Wed, 27 Aug 2025 03:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF276B035D; Wed, 27 Aug 2025 03:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7FCD6B035B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:18:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78D85118E02
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:18:52 +0000 (UTC)
X-FDA: 83821685304.06.89EC0C3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id F3783120003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:18:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZRiQbvON;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KzElkXbI;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756279129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zn15SbHkaxch7Emb4ER8vYRo5WUKLjWhiXgVjEfQi6o=;
	b=rKZ+3m25reHLDFfQixJyoZMbQVIA/TOc91EGrfP3/GDmkSz5PnCB0unV2Z1Vkmi4P7LtsU
	2ybcXeBeOp6xnRPdtvyB44HXMLvmSwdtx+E4mp5WNjtiTQ9aQWKP0Q4eyBA9MNNYFLwKdC
	DIljdxo7RwNsmiG3BjoEmF0EE47vZjs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756279129; a=rsa-sha256;
	cv=pass;
	b=VSmAQxriHmyWHSQYu7hQHiDMDRwqZS3kpECp4eZh4E2HyneHR6pZLOJ627HKFKb1ZJi1fi
	lIyDcfVBM5ZJtSH/o5PsFfP4utYDQmoDkb9KD2oG0JkhVN8hpUjTVCywUfcq+RLWYMgaT3
	AScHL3ajzhXAAtZ3DDDHPFeIDdd1s74=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZRiQbvON;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KzElkXbI;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QLLMgF006402;
	Wed, 27 Aug 2025 07:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Zn15SbHkaxch7Emb4E
	R8vYRo5WUKLjWhiXgVjEfQi6o=; b=ZRiQbvONc4cqFWkhpIW38VJ0SrlFPEipzn
	6SyX5GmVm0KhNLgaJxgLXz1W4ArTeBZ7Desd8qIl9zX8YY16KJWhwQWyswU++eYU
	6a/7IYXHzAt1666IgPb186AUke79H+baBnbFfeVd9Zvz+DUJKrx8o3xUmJHBiJTz
	VdMigoL9w14N99ocD9LM3m4dxmEsHKELXUK6RObdCyZ2tDi9+nvEHEHvWzHxQ6YS
	1p49oXkGsp4EmJRVPWqkI8c7nHiJIu0q6DvSBxvWgJ1nCuaCzzpVCsZoOacBwezV
	l42sESdvVlR/6A563a29zXd3Se9Cdpb5e9J7lKGIqzqRbI44r6xQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twcpv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 07:18:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57R53pe5026739;
	Wed, 27 Aug 2025 07:18:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43aar6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 07:18:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MO1Pfj3T3JPCmw1OcXsb/LuJBBrV1KA/dGwWjseysI42o0bttg3mg7ZP7HvkR//Le7e+f3llUucI0NrE2Yz1emnDgusR4MP5Ynr5jt0IoVC2iU28oD9jU+JDQ/bMf8EG1Tpq3C51hem/NymXBBntD3ufr0mnYWScyzSBUw9FUI9auMcpfUWKKnV574To7flE2AumbzkIrI3cJLr4wQCjVkSolZljD/rS0+63IpAF/JZ/CX7kr9BEEyq8qEpIKP3gtXQAFYdVGKSWMULjc+4r4cRR2VYLAEEIzyDWOWPRhWFNo5Zt2s7PakF0ANjQulX294gRb4sdwnYejvLhaGAwJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zn15SbHkaxch7Emb4ER8vYRo5WUKLjWhiXgVjEfQi6o=;
 b=pc7+lXa1hOgcvBH5wLG2R3hweiH0EEOdHqke41+nSMttdGMAqSF0cMxKN0ko/DUUv9q+NdzMHS7Ynn4ort8k1KiXUI3KBXI0tu23oTJH6RWQ8TwzGR1SY1AfRn5VDhScvBlL8xWDOOs2wMXzMlPOJrSA0xstMjzT0ww8wICpJw4shNZufxnxuDyABMS/6OhfTPo8c7ZhuPFYgmWOL84AVWvcRAcn3aD7ZJo35ufFUobPYWIjDROtXbABY70cx8veSSH7DDXRBaQOCfKKGN5KX/nSLGFyX5Z5BvtAvRyWHLf9gSNM+qXmqpYPvaU5cEULG8y+12ckTpSLG+KNkrjcBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zn15SbHkaxch7Emb4ER8vYRo5WUKLjWhiXgVjEfQi6o=;
 b=KzElkXbIX5Vds8/0325GsncXlvLEV1aZWY8CQyvYATFrDXoz3BAya7hkY3vgglKeTsFpXoLY2O2WTh5lGpRLuD37RGgqDzJoQAl43i8r3NK+4ILNIgOhOV5yb6N3lZnPsEvZw4yRJun4GRc6jYjiCJ9qb1WjAz4EebzCbhaUbtY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7139.namprd10.prod.outlook.com (2603:10b6:610:127::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Wed, 27 Aug
 2025 07:18:40 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 07:18:40 +0000
Date: Wed, 27 Aug 2025 16:18:30 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] docs/mm: explain when and why rmap locks need to
 be taken during mremap()
Message-ID: <aK6xRqeOgocTr8kk@hyeyoo>
References: <20250826065848.346066-1-harry.yoo@oracle.com>
 <87v7mabl9g.fsf@trenco.lwn.net>
 <f64483ac-31d1-4f80-8fb0-fcf15867c6c5@lucifer.local>
 <aK2C-Wuv7c_yIOJ0@hyeyoo>
 <88b41934-2c3c-46a5-a86c-0c798fb7d2d4@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88b41934-2c3c-46a5-a86c-0c798fb7d2d4@lucifer.local>
X-ClientProxiedBy: SE2P216CA0108.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7139:EE_
X-MS-Office365-Filtering-Correlation-Id: 36540975-2a38-431c-db9a-08dde539f299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UraJO/rWeJ6jbN8KQw8Pzgrbg+svibdHSyrVWKnUEpAuq26XvPIiqOUWkXx2?=
 =?us-ascii?Q?tZGoFIECOS32+BMUw76FvWd+6ilDqoLRvkvEdcn4ciP1NJTWb1M2ynGpZCDb?=
 =?us-ascii?Q?m8WHGyIUom+BG1ADDBkbdsFIozFTqLnS1O3+eDemM8nBaBzTmKBiLG2z4Fl3?=
 =?us-ascii?Q?WyOo6zC439zHs4QbXRIaSUCdSItVN3CMBKsHyi9YApixJZy2PYG8bDGm4spk?=
 =?us-ascii?Q?TeZvKWs/jH7UPKZ43r/45sLly3hDA4arojtHsGF87SWJ/S/kFBnQft4gRYWn?=
 =?us-ascii?Q?tpInGbMJZZolqpazVl2aop20zQD05HPbRWw3aZFeGzgzAymrT5L4DwlL4sk3?=
 =?us-ascii?Q?D/AEm8f1AYbTtEVBCJRlETUkv9WyJ1LGIHTsyle2DpfBTkWyHy5YFHIWywur?=
 =?us-ascii?Q?D42zBQ/5Wr17/esBO0jcjRvUYM64iQnmBvPuo9XgTWarWxqJ48h3uXEuWvYs?=
 =?us-ascii?Q?N7ofr/1f0TT+1xqfcSPWM/kqTr01kcuVOT7wwkNAUbDlVmniDhwK2zUK6UlD?=
 =?us-ascii?Q?ie4C9WqOKruDxRaEldsvh7KZybdrJjEVNBfxNPxb2a2N2A86XZ/GUo9/zgMr?=
 =?us-ascii?Q?LFt8DDOIp47UGtiHeZsJQEhPUZtoLDBHN9DZqbjHqlak5w6U1ku21p+VHkcp?=
 =?us-ascii?Q?yBp4Gmq1oA9SY18qtAYHZGo/j21jQ2AeI6PRftp+efM5J0fLX6U2wul1ZtV6?=
 =?us-ascii?Q?SGbZFQV1azzVW2td6TAhBELc2YAKSIlKU0R/zJYarg7YzP7uX7JAYl4/AZ62?=
 =?us-ascii?Q?JMdfBwH7SRE97VAGsfz+Tj75P0476yxp4kDWOkeewE+M/YtmjGYSihmXkQhN?=
 =?us-ascii?Q?/EC4EUPwLNUKoXcqoAmz7eDAtULn3SC+AhQyUlOrHZQzcBAFL/SprOIAfXln?=
 =?us-ascii?Q?44husFRhmMJsqCxE/RyzkoX8S3M+694mReiPsJA0YATwY/AZCMQRmmzYnrIq?=
 =?us-ascii?Q?CpVfcOr7v7wuP9hKZMbsFReJvFDtziW6uThwLPuGjZ/bk7T3bIP581TeuPbM?=
 =?us-ascii?Q?Owd92vNzW6DcycWBOSOOACAGNbz9KzhuObkGnvXDHjC1oacSQYmKjYuu6Lqu?=
 =?us-ascii?Q?lzHMNSBDKRiEcqghnMUNi6ktKtNvAwhNMHnus48NBB8NZ2B72dARkbxVCv4Z?=
 =?us-ascii?Q?DoPBCuc6/SRMY1ezHV/cQYRYqyJxRPMhwlVc5wSzOwBwzUMlJBge8M61uuWr?=
 =?us-ascii?Q?Lj5zlfWtT0cXROciPqNlrrzG8ce9MJYte5bu10c8aXisURQiBASWfMiIz89d?=
 =?us-ascii?Q?F5snstBT2i4sI/I/wJfn01pwC2FLi0vhixg7zSCa8/bNw2984PU+zjQiIdJf?=
 =?us-ascii?Q?UQ3rfAhFWX/7i3pdbmqkmttse89APNxW1A98wQ3o/x0A9tHSufc3Lps4UYKG?=
 =?us-ascii?Q?vpaG8jLQ2O+IBZai0ZwExP5YSLd1DXCBDfg3rn4LLc8az8oJgVX6EzlaejLg?=
 =?us-ascii?Q?tTz6hPlE9k4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rDD9aFNJBaOxFkzRig3D+Unw6UGfcugXDJ5gRs3Oyw/tUgGPFZauNPz2hhxU?=
 =?us-ascii?Q?2/PpgPLaYEWT/C1dTVu5m0YEoduu8+RkJx0+7WYUeuitdJVTN6UwCEjRILJC?=
 =?us-ascii?Q?7VwobqqsQcxOYYmnkLtyt84K/tKCIdH2lkPeg5a1iyOdtzIqQBBaT8GgxamO?=
 =?us-ascii?Q?6wv9fWdSvZbJF5fzMz5B1y9yR5KzSLw1l46sjR1tGZ4hY7C9SQpSJ1ZATOQO?=
 =?us-ascii?Q?kgZCaLrmNMGi3p5+8TcB9+w4xX1u/r+0+NULVa5gg/ifDXb118qOBQ2EX7Aq?=
 =?us-ascii?Q?HFBVNaFezSQZtTvZOPakRRh+InY5C0FuK2hXSo2tntZAwpZCVu98EjDSD8OY?=
 =?us-ascii?Q?Fjgt28rjq+t96jrqeRoQHuHtjizbCSnGtvrQpcdAfI5+2kHdY+D8bSgNw4tQ?=
 =?us-ascii?Q?tnuEpvyzSlrn0BDt2Lk1GxaJr2BmG2PJUK1N9CPPBNgCeOK9Q/ETiPzKB6J0?=
 =?us-ascii?Q?nCd1r0V4rP8bXawukM0DMp+FvzrocR/AA95DLZK+NVRLplwR0RAwK1L0/Okm?=
 =?us-ascii?Q?dT+w89uVHcXkbpJvxKgSDTNWFsyjlIL9KOM0NB4FEqb1e4l9JofjSiSaqoNj?=
 =?us-ascii?Q?gZ+PcqZ4ODewPD893dc41uCFqXLtcbfWOeCBv1Cbuvx7t6GG5d6mZtgtBSUx?=
 =?us-ascii?Q?goyC+RECDI4CFgmO7MCeykyvVdxqpB6+LWOtjhwsOWoqqV7l764kaznWmAjy?=
 =?us-ascii?Q?O1hC/irZDtNRx+SzDeLNlHU5BwB95TOpbO3X0ueAvu2OlYPfnESKhS3y0kJY?=
 =?us-ascii?Q?/6cnBa7gtznDJYahKoDh18NI88KsbL+YEJpzEt2lHG+dC1A3MN0/G5kbefFt?=
 =?us-ascii?Q?LHcZg9EmZyHqulfERIC3aCfTO++m5qvNKgPgsxpG8USef14jj7iG8ocL/bEE?=
 =?us-ascii?Q?xQkHTKnbckC5MfjOK4hUvK/thU4gGKx57lpixVJq6crSvXI7pUrFPt5GDfhz?=
 =?us-ascii?Q?qGuB00PIZvPbOiixUh0MEaAq0YrHZzE/lZoarR4d2LIbtDpXzr/SWgAoWA9z?=
 =?us-ascii?Q?buZqyP/eC3cbudb6b6IgzSoh1o8SUx6T6NYQa++Mf2xQ26oy0yYvLKlG0c6K?=
 =?us-ascii?Q?32jL4sXt26K8wgGIuIr7piPa6Gs3Oq8xVvqeUoHzx+0qSwRgg9q5A9xwwrF+?=
 =?us-ascii?Q?GaODha50nIjPJOMIUiwLLokU78ZO0GxZx+zCdkMzT7vHDDZLshzTYWjoQlPB?=
 =?us-ascii?Q?yYtnUkRzUmabNoNntITcOGwvFHGuW6kcbZtceiqoaCDbWudzEh4QA7ZtcFAp?=
 =?us-ascii?Q?x34OMzMyYbsvdJqAfZKmDdWSc+iQ6BocqftL9hmkIHPHxQKFpTELpiQffO5E?=
 =?us-ascii?Q?Zl2EcjxFsD1FtMw/LcZNOTFqapCMBPWoLONCc88NMdF/1Km3aX7pQdTx8kIl?=
 =?us-ascii?Q?hMqEkBMQf0jZtriC/SwqBZv+9n9Ef3efHP/hJraYukF2mbjrctW2fcBMIJJ7?=
 =?us-ascii?Q?b5ZUQwWPX37ljiYVMNRly9sGnljHwqcgupF3gQFC4Yz4CDUy7Wy+ZvGWwppd?=
 =?us-ascii?Q?oulASBSsFKkC6lvS+B81fj1UrwKPO/NLzjd+b/VNDikWrcJwW4fXZslaPs0j?=
 =?us-ascii?Q?ZT3r8iwkBY0JlIDT1JDuZr/ZRlbGqQtXWA0lPZuL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RlfMXvZBQFYujqrokcan+Wy7QULRER8jZLvptZ6g07/xTT6Z5PjoJJsZTDvJqoZbgMKUNt7yRYrXEtfsUVBwPZZhsWyTLYuxYeP7hZT05v4lBWo5w3Pzn3c9mX1vwSTSmbp4NW5o4b64dAjmPkjzeuB8oUb9Yo2yF83bXPGU+OnHuQ8uG99P/bTi6GlpOtvXHI8h2OUiBaklzVnvHl6yLcOPykuGmn8/1bb4KXkNyFYn+AcJyQuImVqUgJVq5xWJafeQza+sJu0Ujx0IpptcjFqja/pumfMlfpOI81YQqbPmVKX199+kp1X6YBVLBrzr9JUXXnNEISNGg8LYps/WQxieHMUvPCBJ6c5RpFpy5azv602YlwJ9nGTnu/VRvkiiEs5oGS0QkRWARvMH2q8wSIlJvPI4MBISQuMEdBE2djC+t+Kqe7lDfY2nt6+X6vqdmmHEyCcmEEczgrByMkiRsl5blf2lX5Led1HcJCNhmUMeTftPOfqhN2DRlEfLGABocXwnxK8hQlCWf5DQNqBnkQFcJ59vZtU2LPvvaz7k/Yts5/90rgnDEEsZRwS8touODbvezvLOUK8KvsJbphn/UfPMcBGtXxQO2a27lJEt+Lg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36540975-2a38-431c-db9a-08dde539f299
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 07:18:40.5560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31A61wNylcRxP4HX3AcvLCc+f5mzrKtB8R4gC/vZE2WRkeoR4BjyIWU3e7xCiQWzHUDv2Z+ISa/SbUC5IBXEvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=873 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270060
X-Proofpoint-ORIG-GUID: wmc7dXC_LEn05BOT-IhYd6Q57Rt1kXvy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX6mku22Ah45Zl
 ZKylyPE8h9ClyY66xdSnsA9DiW6WYkfYFa4N7IB4mXu6zLATBTqqwQs4t7MvzMpDK1BDEXp7yrc
 hXpJfpyGhaAEENowt70VxIdkzYoB5+lENSwnqiUaBZPlLNzhWXSzUKRuTnfixUy9JagD+2HMjif
 LNjbnSIwLrkLi3GvrMA35zsytOSQNiUYuDBMzYrO+8tr98f/nGzfr0w1+03P/YqITKh/pKVZpVF
 91H0szBCloHdTjGozM0zxRMnVuCusujwQURBpwiMIHHXylA/9Pk4EQSS/3cPIxdRixl6WsmkQ+2
 Z1+5h0eWiTHZXqYTSK+ilKLgx5YihXclEN5AhLXpOwXjFFBGzoiDiNmbQajRXXB58vrDCWihVOO
 nGQvFgo7
X-Proofpoint-GUID: wmc7dXC_LEn05BOT-IhYd6Q57Rt1kXvy
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68aeb154 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VMblobFrIAWNFx2kmEUA:9
 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3783120003
X-Stat-Signature: yk3z9emg5kbj8z5qkns3ehn9bm61xka1
X-HE-Tag: 1756279128-80859
X-HE-Meta: U2FsdGVkX193Tela2z6ySCthl5pVyZ3/UjJC4u//D+narnxFYFTh54hZIojEsbpO3y9+sDldUWxaho5goYApNBZ31hps8DDk2adApluT7+EwkcD/dRp3DvA3Z0aiNCPMtc8w5JZ7voocKG1beT+HIQ+/g3L42nVqXXE1ee8sx5Un/ebQ+CfFD2vG1pksYKGGdoKT859eKZm9soh4E+fkEn3n6TfJ0E/prI0xU4orp+dV4RVxtBaOYk4RTYfo/lF5sgWFlnmYVzyQzeCo0N8sRxue0U4iLZltolKcCiIPU7h4mq3WuG2/l3Gy+0pc5Fcdte6lLNHzaAH2yo13EjAIvQnsqO0+fQzkzpUoIj/O95WtfNkoIz6rBMZv4KvNx6IvahrC+HQcesghh1og4fSiNgzah+YHpdwkOZ26AoUKqec8OeH9yxrtK7IkMyvKcfKqTO4mJuTf0PGKdj52ZUrqHPcx6tx4TBkzwBimepVw2OB2Qx0zYfK/n+/DdBNHKjpVazninLVixkbQ9OkxigxDD11sBu3JN3FoMug0/cGOJQmXyBG8u5KZVdAnDQKL6ikBzewqusD+1R+CZ11k4dWHmj2Ia5I8bnq+9YI+vXBLHKUmu6HSLT9KAuUEPXdA+Pgqr5SqgSUSfp5Ier9v6gkV0VAJQqpRmhn/1+eq19gzdUjpuaeg2L5xIyh1mgTASq48ognvt+ucoj6+EYnuclzx8nXVqz1+wpdfuCGQPyr0KNUSiDcxl9xWUsgiS0f6aU0R+FXrNzTu5afypBA9aLIQWEfiV944ZqfYT6I1Lw5efjNikDvEWMFE61JYMOPKWgifGzOp/B4L3F93iQzFU+endJVfhHPtTEabjLaKnJJSoYoZ56/nVbhghaWlmEYM3l++j9suRNoyIWZrN+0vT4PQPocuzPvZ+2OOUS5AUIM3Lda52PmSHvepgeNqVktMesQoISu9hnSQQb1juUNIvy7
 bYlZe2mx
 Jij1rLpGvw1Em+17IpwUxLQdaBY9nSsK3vlAdFS0t4THVa91CrYBAWM2CUtXm0RbxLajbW0tSQ2o4YkeWAHUONY3J5kiG8XBY0rp7UczDQCT77He1UI3/fyK513s1dol3XMGCudd9O8oiFvqfuTNJAsDEnxEERR3iBotAuQ5WQg4+3d1Cz9FveBVpZ1xuvP+lALgU75BEk+xZFJ059uCbjyGRd7aWhrR2574eE8yg4xJ18ZXvH6Ov2E7b0aujXysq2MBabFXTQY8sghBxh0ohQ3Jd+RQo4zGBN1mQTT7KJ0GRVLSthaXxv1962lw5+jaaj17GIgcNRMk6V69YW1o4ojbem7FvzYsRBEMrnLqHy4+xcbRViIxdDERhzjtPRaZLOaL9Pkiqh5Af694FcWBAgv4nS5Tt/PJlOMYbiJyF2XSvtuyViTJmWysBTDiAMSC6aBhAoHq849w5bUcaMGP4mW5fNy+ZTfJZ7om1kznMqt9Xwn1ecmB+cI3nyTKdqglfYklwVBniv4f/en9O1H6trB7gxu+gOxXlrSBPEAdM2odj6AXbDPTixg04uJ1leMAX/74vX9uCT+Hp5xD4/cT65MGj5NGPYSilUpEzgCNAdYmZgfV+B5Z8pNYc9aztGq51wp24UUIbKF19mEUheHXpDJPwwy6EBinYFOoH2ochUXkS7QpOL4BKSbJeZkq2FYqyKW1OFr5MwCkhIdkUc5pzHMEH2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 10:58:58AM +0100, Lorenzo Stoakes wrote:
> On Tue, Aug 26, 2025 at 06:48:41PM +0900, Harry Yoo wrote:
> > > Yeah sorry Jon on latter bit, I did mean to get to that but workload
> > > been... well you can see on lore :P
> > >
> > > I have a real backlog even more than usual right now too due to daring to take a
> > > day off on a national holiday here in the UK :))
> > >
> > > Harry - more than happy for you to do the above as part of this series or
> > > separately, will sling you some tags accordingly.
> >
> > Okay, I'll do as a part of the series (process_addrs.rst and memory-model.rst).
> 
> Can you please though make sure the formatting is all good? That doc really
> needs the function names to stand out, so that's key.
> 
> I _think_ Jon fixed it so that should work fine but do check first!

vma_start_write() works well, but it doens't process
anon_vma_[try]lock_read() properly. (only characters after [try] stand out)

-- 
Cheers,
Harry / Hyeonggon

