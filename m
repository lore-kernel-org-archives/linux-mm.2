Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD46DD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113706B0010; Mon, 15 Dec 2025 07:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4336B0023; Mon, 15 Dec 2025 07:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDA56B0026; Mon, 15 Dec 2025 07:23:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB7646B0010
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:23:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83E04134A5A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:23:39 +0000 (UTC)
X-FDA: 84221621358.22.F5728E3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 149CE10000F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:23:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jD4UzOMl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wYgAiPD9;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765801416; a=rsa-sha256;
	cv=pass;
	b=i0apwgNavsND63Q8NeMawz0bP/Kdr5uaRu7pH2f9ff+MYRRLazV9EBHAUqqaVpyYUssCXC
	Pdw/2oiLXA9PHnXOtJMIPZpD2YXpaQIjbiuFQQ7Ywg9ce+Fm6ktK+FUe/uFQWHY5Cx6Ank
	r0OYtsQREiVIENlP1aYALZDVENOJLBo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jD4UzOMl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wYgAiPD9;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765801416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsbpYxtJSGQSlPrTwlXg/hTdINsZHsBVrFA3zZyM5jg=;
	b=y0B1Hp0zwongwbPCdqubgbKYJT9B2uGyPIpeFlacWMxNxhQ0b+WEbdFtZDbqzsqVJ6iy6+
	6vTu9Z8GP0AcgB/fRTIC+1bx59aH/5ERqDzUBFyaCX9FMW7Bsz541WdXWl4gZsO/mEZhnv
	gHPfldGcJ6FehEg04s4WoS678c63wes=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BF9v3VR1785175;
	Mon, 15 Dec 2025 12:23:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MsbpYxtJSGQSlPrTwl
	Xg/hTdINsZHsBVrFA3zZyM5jg=; b=jD4UzOMlhZW2j99XfGLUMvHOi3xfZJ6amt
	hxD7OGUckkUCiMMiM1tEcnJyzXWP2UyZ5nSS/jQSeyJEorGH4Mz9D0X9wao/fJwy
	mwLkpq8ABk4El+L7UkLUbIhLeeXDnAIPUFvKVmI3i3+FPRjsiYKRuJY3fScojlbh
	7HZqT92o+quTSaixPsFCvLmKOEsN7vA6Phw1pwTs1cqa2MMvcnD5EILCyjKyUk9f
	yzMHzOQ51TsdEdXegcOLQHyRNIYAzxtS7vjwbnfVpImxKhZ3O/fStkIx+eJB39Ry
	DNHb50ShHGk2S5Dt1JJd4wAMEEok6m7UUqxrBlGtAPR8xMjZKsvA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xqxsy6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 12:23:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFB7Mrn006048;
	Mon, 15 Dec 2025 12:23:20 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011027.outbound.protection.outlook.com [40.93.194.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbw4sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 12:23:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X0c0+pIb9r3cReu0zegOvHyzcO3SF6rWX3veOmOBoUQ8AwjZowTaPzvM0XRfYS1pejICDyGmA5ieBobK836UUKn/VJV2pTNgD/PzkZA/JvbZ8AbcSJKDJW1fHugV3IgFUKkyQkhkTBnLc3EA/1QfSRvlVvrShcL50n9ACICAVQPHHhOUsesgn/LtVDH9qJEcmt/QYgznKj4h7A8Pe1T/71mU+XBMoqpwWp1BRqRIje/LVaKmP5yEHLY+MF35SOC5yJBFD8cEXW3TQCdhYcaG7WpTq7NT81yynMni7s3jlKiGyOBr8D81gfEbk40ad28jWjOH74Cxa3vRpDITrmF67g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsbpYxtJSGQSlPrTwlXg/hTdINsZHsBVrFA3zZyM5jg=;
 b=SYmDVn/k4nTce5aP76mufmccOK0htF8EVjyYcg3tKXLeV5rhboFHS3mmpaPM79LHjZ08TUSJJoRPklVpN8MdqgTW/zQR64aTDY+2Uq98WpSJuuyzI6fbVsTLX2v0i1nRRVUAi7XozfNqTuhZrrbisG3U0mBFy3vxKFrrq5aDtrQh4OKfpWJ+RAQK77r+94Aq7rVPebDcipsIxlxYYt8manQEBH2/LZeHpAb8k6PJniTQnGLchBTSGRu23z/FM7xzMZos89x0qxjWjLtVmhnj/L148t+aLW6Yjt53hQDy7ybN106ylwcKJMw7zjj7U7OxwZnBQe32i/uUvjjeyBo53Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsbpYxtJSGQSlPrTwlXg/hTdINsZHsBVrFA3zZyM5jg=;
 b=wYgAiPD9W0OHsNS62cOJzhNI30U/xJu9z9H1DTjVAaq2QK4PiOvBjiejiFBCa2XytGE1Y6g5oZw/lmHgBWyZbsjwOFSqslbEUPiSeEJBb87/fpXTpFZiSvE2bm3uDlPvVFrob8THnA+L/HAdgtRIZS0/K/ChARAaTMjO+PICnLg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6648.namprd10.prod.outlook.com (2603:10b6:510:220::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 12:23:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 12:23:00 +0000
Date: Mon, 15 Dec 2025 12:22:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <4413d7f4-7734-4715-a450-2ba09db5ed22@lucifer.local>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: MM0P280CA0015.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6648:EE_
X-MS-Office365-Filtering-Correlation-Id: d6caeb2d-93e2-44a2-c33e-08de3bd4afac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zHoU4vwSGT3NVGpPoK3m29IJLYC4Qolj1y9TUHWjGFS/2TOIAlTs5h8SGBJ5?=
 =?us-ascii?Q?PkAVZMqq7jkYMhKFPSSbBzmPbzN0v0dT1xnrkFWcNaMB/VhbPcNXmPVvL5Su?=
 =?us-ascii?Q?PsnCxBmd/GNY+Wa7j9N09eXt/acZuPV0hcI7nYTedHDUzE+SknNwA0mmX9pO?=
 =?us-ascii?Q?lUt4HZ/WxBez+rwO+ZscYZVeAiNLwgWx/mgJP9Y3EB1nAAtH3/xUHjSqIAny?=
 =?us-ascii?Q?fqCWhxMpK7IMi5rn0pS6XRJLy1qlGfrlVzoxbudVpb+atCA2GM/vCD/2vj/4?=
 =?us-ascii?Q?5ogk+K9IYm7mYb7ddbfapc6JViQFERbLryAsmRT/YR3aJ0ZlTqbhqINhhNdr?=
 =?us-ascii?Q?7H3GMAx+xvKVGUltbXh9i056+CHXfVZHcGm49p4pyCdA7XUVY4ZO7eKx2yaa?=
 =?us-ascii?Q?59b0yBt7ODqRGi0FLCXRa4gkReuSGJCCJEWB0GUSQ1zqJ9Lwk3XEEdy1biNP?=
 =?us-ascii?Q?YXVKkTnrCuB2CVG5I66KRKJ4RNcZ1Fv7vRTxKN/6YPKI7i4flaerJfnecl7R?=
 =?us-ascii?Q?DPOn+ySxCWoTvTNTn7u6mJ4bZ+h4W2dMXBTL468d6xMhTnJFz7OuJ1Ok7cO3?=
 =?us-ascii?Q?8bXSr5gQUpdxgLVVBlicXi2lApAnP+JZtB6l54EngfvyeVfCCVDfQnRx/QMz?=
 =?us-ascii?Q?rx4pKEZS8naFwLQPwD7PyucA3Vjaua7RzjN135iMLhFHRY2qIq9Mfq131ol5?=
 =?us-ascii?Q?apy7cZOE3+3cbX8GQHMX+jL3TEoDS8J9XzjObIImQI0vC9Ou7zrUtTFltE54?=
 =?us-ascii?Q?ZNa/zUBJUVIoIZ2ArjBw28qmYfhfFn1JmfN2XXdaRd3dtTwzNfNdRWtut78N?=
 =?us-ascii?Q?swoIPsywr+KV8+FCFGD2cCDytSFPAvniIJv2w7y11y7GWTlqJXb0+4Ab39zy?=
 =?us-ascii?Q?qfeajT4RISOAQAaEb4BzO1UmOGZjhDkPb3EbzilGE3mM4Kez3KOIFyw7MSsC?=
 =?us-ascii?Q?VNlVSGHGLyNQBxQxL8O7gSZu6XrzjtvUWztp/s7x1224qP9yg2NavUD5tqvE?=
 =?us-ascii?Q?U/5Ov0GskaeaPUQvCXQdmS/waqHiyPzsMVm6HjdEUNNwzaGH1VdZ37HFw00X?=
 =?us-ascii?Q?WNc5UXnnE9xNUpUfD1hnfmuHcD2469u66LXP72/hz4p179P6NjOu2b5y5xN8?=
 =?us-ascii?Q?ilfMbmo4sbCdliGOrYOOprEmCHEvty7WP5mSfFFkhJCjp/vX/UvBPq5Q+3/v?=
 =?us-ascii?Q?bLxRR27CAD4DIfTC2wv6WxHDJfKtH4apkcRXEs+wyJDflrg32tPAqECCZjmz?=
 =?us-ascii?Q?dIcqrh0mtmcAwnBNuXKo8K0AxCimGaUj08y/pmlo9/iPPn6fvRiBJm/7IqkY?=
 =?us-ascii?Q?kQ9sRZ88WuhoW7aiB6Byra4vMTi2nv3BuDo5fpCiJJZKId1baLhZ7UnMWbji?=
 =?us-ascii?Q?GFgusWiO2AYc8OGB1u5Tr08rT9TGJnTDCOmIpKZ7MPnfuMZBIBEKj284BolZ?=
 =?us-ascii?Q?/azWNA/VN22knx8uZ/VpCmeTM/IsGqCx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nRhqRiWPE0andW3eJjxhaiUlMbJ+ApXnAwBDHwkP/kDbD8YwX827MTods/EQ?=
 =?us-ascii?Q?X+0m6k1m3glG7U7ngqx6Lha7BMSGwwO84MlrCV7rY0cr6hhEfGhR/JzNZ2fO?=
 =?us-ascii?Q?e+FCYrStAOZPHffQn/Q/NOXzSjAN/k1A5sRky+GTIGF0QmTAlhzRsaUQokiv?=
 =?us-ascii?Q?OesyLFb/XUINB0Q7OotRs5na5cZLQBv0CzpqN1DGp60y/ocnebX/34aJubuo?=
 =?us-ascii?Q?nBpVqw8wR+9OIBVcKRGGkpUOCOBRowNOtyx/d6ujYokPjExXOAQfOXvDhwIE?=
 =?us-ascii?Q?wqqiIYc5PVMlUZGb4C72bGRvHWSPsDdht+5cdFr9umLJRBUtSMlWbDlqv+lm?=
 =?us-ascii?Q?Uw4o7pZgJCtRtTygc4tj8+wWYcvMCDr2EahSr4xbk73YzL54QDvY21xP6Tkb?=
 =?us-ascii?Q?5g5D6u2XOQXvxhySifDhjbTjQrsbbTExfjfxvJMRrGuLNumiFWZ/oT7/jrzT?=
 =?us-ascii?Q?aIFgSGlaTlytjp3R4HAH80A1im9OTuLMfX43tSd+FSVmfuLQFslzQQ7Z77hQ?=
 =?us-ascii?Q?zZWi1iOvajw5XeTMtamIWS12ZR/gsP8tQvBeCBxJM2MUMQN7u5oL3H7qilL0?=
 =?us-ascii?Q?0m2y6JlGVBrVWoj8BomYUs1H9rgAloqygon7aYkIxx1VIJVYsSrARrKpfGr7?=
 =?us-ascii?Q?mh/UY/YfZxvAYhNGuHTnoGQPlhw4VSIOKx3uVBmv7Smz9SxoQZRMPpZ2CVvg?=
 =?us-ascii?Q?CXa73PWq5z786w9+kzhj/J92hbTFbCv9hP+RQcGJtopdzo90EyqAI4uqeC7h?=
 =?us-ascii?Q?luQuXRu1xiH9VBedVThQAwt/tveO05khFhb9X7nhZdaTu+5VQZ1IEhNdmo+G?=
 =?us-ascii?Q?cdLngzrXQuDvyiBb6iX3I4HRpwPc+Ab21zCYE9jInQNmXVRfhhEzLH2UqOn4?=
 =?us-ascii?Q?rZAMDMLvjjk6T9+hV2b7kej7uaGChHbg/UPnrI1/7u2yZYiwh5uqWU0rhwdJ?=
 =?us-ascii?Q?8/IWIYAU1in4rObMR+LkgDmA8gAqwKnbIhMbA4m9sB1nLCqRC9oFQzThvAS9?=
 =?us-ascii?Q?DCeRWbmgvCpwQrM1VuWKTmb9b+yQFaldhk9xiytKbpOfHjSDvjJqeG4TJE8C?=
 =?us-ascii?Q?KZtzAOuVbhNUNgPXHMpxTjwtwCc2WUwSVU9y+WoyrwQ9F70CUhd/Q8U9495A?=
 =?us-ascii?Q?ofK3PePmAj0jNslK6jQdxgQx+lzSoWxa5E64luAzTTq0R7bqIqZ4KbYmi+zF?=
 =?us-ascii?Q?T74nDDYSYN9Ky/0UXG02OO3+4BM/sp2jl4GL8kbQOix2QhsVzD3z57LTlWSs?=
 =?us-ascii?Q?hrL41K5q0u2I8g9OVWtfN/i3HrfzpPdUQdDCDDqUwn9SR3yZBKViMty9Nwuv?=
 =?us-ascii?Q?YdqeGpXn9k7i1FHs5gVZdWSVOeRN540aPX7H5GlpmJFr7zG0J6yqbBAUNoHs?=
 =?us-ascii?Q?E4/gFse0V2qSSC1QqGqEdTS3/KDNaNrPYCJr+6hqKZKM2wQktKLTB3vWXgRu?=
 =?us-ascii?Q?0aibM/W6qxNiCAG9cCAIrMmE0e9fjVdt+4m97+vM6sRGbb2l0yMT8s4YdzY3?=
 =?us-ascii?Q?0m0tBREG58RJn9k3oSMCsazN9xGB5EqrI01KBr4Di+SDOG2zEmXrADIVZmiI?=
 =?us-ascii?Q?30PUd7AmCdo7KndYDrbnroQIoUCDi3138WQgxoGSmn9/6LSxatCHc4C04jAI?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	83jV8szMju7B5Vjb0A5/O6xd4BFEy+gzKYwFVhoNzC0aZg8I4todGnBe+LoeUANwxI2bjGg0FMkA4REgSDJ3RpoesEYrU84lZpAjb9E+SgwCppaRJFvG/qnzBZvQ9aW91xjL+hY6HbZdBmwEz8YS9MhNCl+maEDg7w4EmqXNvLmqIkUffx57FHXIy/yFmVq6pxjZw4EpJuh4+2ayEiynEgJ60UnrMBny4JxS1uDlMJCTnCYg7y3QeR7o5cWXNhEuiiymb1KNe+48CMG1LpikM4E9O2Bmwk7bbUx4ZurfgHUCgskKhr4g/motiW+mOJMKVLRZnL2Psk+mC4Omtoa7YW0RPnBSvBIDzsvxLUIHovxJ0+BJtHd8+YcrMXN9+QOQFZdHI+VAj0Jp4UnEKH7UgZqKmLF/lGUe2qpIILl63naQ9pEfZmaiLqibeH0cqHJN7g+0/aJaKd5S9CegSFzKz9ldp3YeTflZ8NHiyfKVGN7R5ycut7lC0Audbii5HhvBV2QRoZjQV+Rofk2sWpzOTf91KJy5YXYXz7U4rB8kU+e3DC1TBBZnJMPm/yvvBIBbc91sZrF/5ntChP52elXyPxQVhs2EeC+oISegxvQ1wXs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6caeb2d-93e2-44a2-c33e-08de3bd4afac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 12:23:00.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tx+fEf3/mAnBi3J23zNPl303v61rlzlCY8Q5kfIc9jdZQpC0DYMEMZliJ9x/8bamABJkoZGOEGDWVxNWpvtZHmJkeKApV+QDFu2USRHtqHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6648
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_02,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDEwNiBTYWx0ZWRfX9OZRvOHE4oSH
 6Xb2gzRQ1eht8nniCTekB1SF1kBV+eObFnb27Unx5Xk343tJ6nnh77fgV7XQb/DbuhlYPjNjKNY
 avALR+/zJ+abTpEl9nZiJbq9d2CAwuUOjAJADZfrzKNn8852O9qdZlYhV2iKSE8zS30RQcwn0Po
 dmLNJzfceOe5iq4A16BVHaXB+ik9JKGJgJ1LNrMp3MfaA2ONs+DC1j52cV8qE8U3x7rGyzEjsO6
 iNmD27fev2OIkVfTe5WTD/6GNED03FeGPcWTp2GrWYtM7yS1ttY203eht+9rE+V5WCAOBjIpqRu
 Hmm2Ebgx4Yegiaj9K+rSRzNoEwxFflDkngiRzx+ize1IrY+vE+Qe0LUhPtG+3/RJ9tMHkekmQFZ
 1s1rHX2CY2rJVEfYdP3NyNkZGUKbMiqbdZbcuTVCE6+yYFxGS2w=
X-Proofpoint-GUID: WknUQHKe9IbkaHL7C1zuaiYFGM3saJI5
X-Proofpoint-ORIG-GUID: WknUQHKe9IbkaHL7C1zuaiYFGM3saJI5
X-Authority-Analysis: v=2.4 cv=BYDVE7t2 c=1 sm=1 tr=0 ts=693ffdba b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=blihWuLfCjEVxaARxj4A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12109
X-Rspam-User: 
X-Rspamd-Queue-Id: 149CE10000F
X-Rspamd-Server: rspam04
X-Stat-Signature: zpaqeywcwcw9mj9nb8ypucfjtks78mt8
X-HE-Tag: 1765801415-998628
X-HE-Meta: U2FsdGVkX1/AU0OykVeZ9fC7RJ8pq7iaXxcI8CRw3zDAoFgNQg53ts8k8OEY2alb9Z2zSdoDwRrboM/ASUSpquLOnd+YG82wbWYlI3cdJBUYLZMgHvhND+/6ZhkAc8dCQqVMVJGZ8Psh/jEAbjQbxG433UUn4gBaVZk3O+p8uJ2c88G7v5lUOOZ77NENBxALq9bvayeWqnVVMA4ED69UHPrjaTH1nI2x+B1J9xNxMYfMXpm6CjyApO4ow4QQt8DTVK1Eb7XmRukAswlkZFGk9dK9y13eWk/MX6IIQ81OYtFrgO8T2DXxNs8LbAYK3pmztc0ruJUl2t2mIVhPbPjqZmKEsze58PXO/X++4DNBHWBgEFukFccQfd9qr6+khSHBXA4V+qSvHr62H72zyVvuQQvqSO6UrO9//eX3iCWiGk42goL2bxLs6yw+45tILp3m+cx+78fwfBqGTHnvRqUPcGNGV92Gs+uVPiuYTY3H+BNHDR0Fw0y7bScNm+wWUBji3ThHQrHk2bi26sLW/rOa9kt2XEvKjxvG6vwIlRTSff1oGnGfVEqhcL34kjkumWRwAMcWHk+2PlJI1W0GUbaXaxWhEQsnV4SU7YzwAHC2ZyQfjA4SF+/kF6dO4ufcSyh54egFU3GzCXW8r+bRI+c0F9QAhD3Il1Nh/E04hrRtOo8eGeLy+V4w7p1KiHHcxeUQcn4YAjrTlbiddHT8Zonn0F1K+qCDUdnulz4yLW5REDDyE11sDh+2qp44TF661gv8K+2Hrf0eH0JFmC18LR01DkPIryOnEj+itEccDmQCt1XT6LOO2QIsfCY5aHb30K1Ot1/VekaHYP2Q09k6tGltL8b+eEmitu24krtdJLmsStRLh7JcE57L83v6L53buFcTxdd6zLmOYPHNcLaLC7dlE/ARCdv/CCsSikhQ8P3SctFOFL5t58uozVhsSVhSd3I67/NYoP9kBK1b/UOY0aL
 Djzd6auK
 tSkGG2D1oeWkcyaEocD78YVEFvCukj+PazExovGZAEVGnxcrvMmjXidrPZWPKErLBNy0d+74ojOR0q5UoniieOxLpSOPr6lY1GUfZqHoiIogkaVn+/PjToDvvzA8w9Sy/B5IA6IVgK8hWINlSt2pVR31iUgpKlerRtHYLkT+SxZ9fkICGFeZeJsX7NwcXHa4mDPAuXWyzj+Wt/OyL4KqPDMj5hr+ixqdUey4xrrzGfwd42OwDReZCMzd6NhspFFgeZDRaF1cAYnRpPNTRs3ZkMUGIKfeCu1AkXA+3Ycsp0J++5EFWoZVqM1khdruvClje/lRiLkwaXMbjiE8UP4U2dnpgRXtaPsP49DP5gzSAnDNi+Gw4fGVG6xEuM/VBNIDiAYC4IoeLb8MPzSZFGe+8I4GtFMHquGgbt0BwXGJqEvXKAWKDrfk49n6Vs3ppTAQ0dgu+rLTAk2SePY7YNycBOp+bK4BkFVtaHFYjgCKy9IZE5h/xOqmqFwUKP/F/CS1V2V5ajAza1PmfPnftOJdh1YnCueAGSS/OEXEHs+3TOgugUZGJwDX/t5vGuNCXybRwjiX5imYkGi6WjA0mgcECZCb7C+pbyp6nDQ/2zGEgUMl8hNmbajTcOYh6I9CV26HshVxJ1MFNHFToNh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 04:16:55PM +0800, Baolin Wang wrote:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
>
> Moreover, on Arm architecture, which supports contiguous PTEs, there is already

arm64 you mean :)

> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
>
> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
> of the young flags and flushing TLB entries, thereby improving performance
> during large folio reclamation.
>
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
> from approximately 35% to around 5%.
>
> W/o patchset:
> real	0m1.518s
> user	0m0.000s
> sys	0m1.518s
>
> W/ patchset:
> real	0m1.018s
> user	0m0.000s
> sys	0m1.018s

That's nice!

Have you performed the same kind of performance testing on non-arm64? As in the
past we've had a batch optimisation go horribly wrong on non-arm64 even if it
was ok on arm64 :)

>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>  include/linux/mmu_notifier.h     |  9 +++++----
>  include/linux/pgtable.h          | 19 +++++++++++++++++++
>  mm/rmap.c                        | 22 ++++++++++++++++++++--
>  4 files changed, 55 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index e03034683156..a865bd8c46a3 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1869,6 +1869,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>  }
>
> +#define clear_flush_young_ptes clear_flush_young_ptes
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					unsigned long addr, pte_t *ptep,
> +					unsigned int nr)
> +{
> +	if (likely(nr == 1))
> +		return __ptep_clear_flush_young(vma, addr, ptep);
> +
> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
> +}

Hmm again this is a weird way of exposing a contepte-specific function, you
really need to rework that as discussed in patch 1/3.

It seems to me we can share code to avoid this.

> +
>  #define wrprotect_ptes wrprotect_ptes
>  static __always_inline void wrprotect_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep, unsigned int nr)
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d1094c2d5fb6..be594b274729 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>  	range->owner = owner;
>  }
>
> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
>  ({									\
>  	int __young;							\
>  	struct vm_area_struct *___vma = __vma;				\
>  	unsigned long ___address = __address;				\
> -	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
> +	unsigned int ___nr = __nr;					\
> +	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
>  	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>  						  ___address,		\
>  						  ___address +		\
> -							PAGE_SIZE);	\
> +						nr * PAGE_SIZE);	\
>  	__young;							\
>  })

An aside, but I wonder why this needs to be a (pretty disgusting) macro?

>
> @@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>
>  #define mmu_notifier_range_update_to_read_only(r) false
>
> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
> +#define ptep_clear_flush_young_notify clear_flush_young_ptes
>  #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>  #define ptep_clear_young_notify ptep_test_and_clear_young
>  #define pmdp_clear_young_notify pmdp_test_and_clear_young
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index b13b6f42be3c..c7d0fd228cb7 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -947,6 +947,25 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  }
>  #endif
>
> +#ifndef clear_flush_young_ptes
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					 unsigned long addr, pte_t *ptep,
> +					 unsigned int nr)
> +{
> +	int young = 0;
> +
> +	for (;;) {
> +		young |= ptep_clear_flush_young(vma, addr, ptep);
> +		if (--nr == 0)
> +			break;
> +		ptep++;
> +		addr += PAGE_SIZE;
> +	}
> +
> +	return young;
> +}
> +#endif
> +
>  /*
>   * On some architectures hardware does not set page access bit when accessing
>   * memory page, it is responsibility of software setting this bit. It brings
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d6799afe1114..ec232165c47d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -827,9 +827,11 @@ static bool folio_referenced_one(struct folio *folio,
>  	struct folio_referenced_arg *pra = arg;
>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>  	int ptes = 0, referenced = 0;
> +	unsigned int nr;
>
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		address = pvmw.address;
> +		nr = 1;
>
>  		if (vma->vm_flags & VM_LOCKED) {
>  			ptes++;
> @@ -874,9 +876,21 @@ static bool folio_referenced_one(struct folio *folio,
>  			if (lru_gen_look_around(&pvmw))
>  				referenced++;
>  		} else if (pvmw.pte) {
> +			if (folio_test_large(folio)) {
> +				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
> +				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
> +				pte_t pteval = ptep_get(pvmw.pte);
> +
> +				nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);

I do wish we could put this fiddly logic into a helper for each place in
which we do similar kind 'end of the PTE table, maximum number we could
have' logic.

> +			}

NIT but we're running into pretty long lines here.

> +
> +			ptes += nr;
>  			if (ptep_clear_flush_young_notify(vma, address,
> -						pvmw.pte))
> +						pvmw.pte, nr))
>  				referenced++;

I find this referenced logic weird, it seems like it should be a boolean,
but this is outside the scope of your patch here :)

> +			/* Skip the batched PTEs */
> +			pvmw.pte += nr - 1;
> +			pvmw.address += (nr - 1) * PAGE_SIZE;
>  		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  			if (pmdp_clear_flush_young_notify(vma, address,
>  						pvmw.pmd))
> @@ -886,7 +900,11 @@ static bool folio_referenced_one(struct folio *folio,
>  			WARN_ON_ONCE(1);
>  		}
>
> -		pra->mapcount--;
> +		pra->mapcount -= nr;
> +		if (ptes == pvmw.nr_pages) {
> +			page_vma_mapped_walk_done(&pvmw);
> +			break;
> +		}
>  	}
>
>  	if (referenced)
> --
> 2.47.3
>

