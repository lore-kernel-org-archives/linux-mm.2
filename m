Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD13D5B868
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CFF6B0096; Mon, 15 Dec 2025 15:50:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25196B0098; Mon, 15 Dec 2025 15:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D856B0099; Mon, 15 Dec 2025 15:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAE786B0096
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:50:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 757DE139CB2
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:50:01 +0000 (UTC)
X-FDA: 84222897402.05.25BEA63
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id F05534000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="RoKmkN/l";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AqoK3bfl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831798; a=rsa-sha256;
	cv=pass;
	b=DasFdC+kSxLIWrpyfyDMBwUF8CYsvjvUQwyY/4atCWKnLNrhS4/hViaLEGIZ39vm1TkNu0
	/hr7KT9PqNEjHT4SLikqHFPKf3PdkBjOfw5fmEleO7EphA4ZQouMHcHnWAztvbzHBIlQLu
	ngpjrQwLekcqUXXXocxEdig3ZW1TuYw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="RoKmkN/l";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AqoK3bfl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/rQXT7qceVAudkXDvxlbtA9CoQZCHf9ReaZH6B+hLo=;
	b=KrM7SgQ6Jx6KC9RUkZM3t4ycfqmgNezvCgjXg0bZAfzu5jAENPQbf0AB3GC77vlKJh4b1N
	wcfEiT9WeUcaeReOdmgi9KX+MEdBF2UjS4RFLAPIFx3nRJRn1KXFKZK8KEn2tjULI/ualD
	wUvtRjc/NHrTDvPmY2sMWD1CR195rHs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJCCHH2885807;
	Mon, 15 Dec 2025 20:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=O/rQXT7qceVAudkXDvxlbtA9CoQZCHf9ReaZH6B+hLo=; b=
	RoKmkN/liFgJNgGN9maw8whEsHuuqnTmPpcCobp5dEcFg4r9PSit9byqeRyix09w
	oaZba+/u4crnia1UKORgyDJ3ECQR32ESD1Kyvy6yH4G1MbpnVmvYwl0TZD9T4j7L
	W5Aixhus/2XxY03+WcoNj1OynfKn5MpT47+4BxeJpRDEeutLGfmBz/e26bq1fUvS
	DjL5Gad5WIhHgfOQ763APcmyHMq1IZOAlLQbD/zDlFpi/3/REUieXVdZ5oK49Hjp
	rYn8r2JuyK0s3UKEVRAv53dBcQfvuU1vkCP8geMuWg2hfwhwaZQg1TTqvWUU9uKn
	vgTslDGPj/ZnL+8BQQKaNw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b1015tsuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFJ1N2k025193;
	Mon, 15 Dec 2025 20:49:41 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk9p1ab-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SM61j3xUjA99Rq1Oz4Idsesa4iarrD59Z66AstsIVpFbDCDP9SjZ2Bs9HQPm7y/xR9okct0fzXvkeK3IjuoxlaS4bYcMdnL1ArFdKyK/NlvdYMyw5S8gPt7Q6rqzWWGCj8euAytx5WlPkQoGVGWJvwqawvigclVCv+6CaLleqC5yjHXxXmiSDOfrt+iXgRTf7V/QM+NYYjvdBCmOOSJenInT+WDQcduW9Y3xO7Z5bihm8mVBIcnnezaHG/bP8kYWSRVCbfI+RoWb0VxBVJ8Ga1Oeu4gPSE+vVWm01xPOJiJNj7iMr97PbL5Tcz4FP2sKUIg9/+UhNuYGHprySe5ayw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/rQXT7qceVAudkXDvxlbtA9CoQZCHf9ReaZH6B+hLo=;
 b=RFlFUCt5f5rVOmKO0cBfixUdDBhAtlo2gZdpvQ7gplDCQicl/A8EyC9osX9EP9I49hnW1UOSN13J6RHNswkWjAZUXAOvgKq99TGKWOoQAfAWMHshq2OH81M1m4leFElNXBhmJR05f/2WbR1PCmysM/fxCjsNNIdsvoCTQLEn4M+YSwwRhL3LHg442/4aior5e77ROwo144WLlpuim6bNlMMLIdMUOcy9qXT/FoTM9n8AxjO9zGnbK/9sAAfM2k8wo5qzRGEs6FhZLXi4ari5pgZhxZzPWeWc70cr4eljJOxBQuOjVIHeY6SZDtNtLLJwvZZYBho6Vjxxd1iMJyfyKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/rQXT7qceVAudkXDvxlbtA9CoQZCHf9ReaZH6B+hLo=;
 b=AqoK3bfli3eAwYnRD9Ni14kXHzMI2ecl7fIZ6ywkbDu0ZpwxzOeo41UouJz0uwclw7r9G0qa0RtipOJ9oNxX589Io8zwsYBk3Hj224DLBRKPI/iboaYoatgIlZIsxiOBsKk3YlzdozzjAif3DMQDz1HIfFTBykIPMmtNGNTeoRc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH4PR10MB8049.namprd10.prod.outlook.com (2603:10b6:610:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:38 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:38 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com
Subject: [PATCH v10 7/8] mm, folio_zero_user: support clearing page ranges
Date: Mon, 15 Dec 2025 12:49:21 -0800
Message-Id: <20251215204922.475324-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:303:2a::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH4PR10MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: dd1bb61c-63a8-4169-f163-08de3c1b76a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q49tabC/yFQwebIRprMI8ZfdoZ/dsAqKzr4ggS0jlB3s0YNrejmd0taaEalM?=
 =?us-ascii?Q?15jwV0H0UAeCBRmRC9CDwWVSp5YMFF1CSJVYWbGcn78U6z7gMUsdjS7y4fzK?=
 =?us-ascii?Q?HNm0b38P2ovCwqDIw9xzgLti2fUH+3lNvugU3vmfSIC04qe4zu5cHtoCoo4N?=
 =?us-ascii?Q?6643efLEesptGEsZZibR7T/ogVWc1BxM6OBua4B2ikr39p75rPepTgQwFTOp?=
 =?us-ascii?Q?nrdGwpIrZP2krCXGkVT+y9zsp7tv2tKwwQse4Q+SzAK6KB/f5hN8juujGA0R?=
 =?us-ascii?Q?Yyol2MTgpldndbGNBl3D7ZUU5r7ZGw0j49eAN4hr4U1HQmC/EI59StKEBvFB?=
 =?us-ascii?Q?2s3ygb/gVvknDIz+jED4lbDF3W8ix2maRQCPR9Lyk3RYHtvauyh6efX3jwBE?=
 =?us-ascii?Q?XevPupfuHaX3AKx2gsuFkTnrE3tu0Gc3SCNdraCS45g1q5/kJpW2gvtnHDJN?=
 =?us-ascii?Q?1rCYbryjSEjzqJprKROBn3vqVPVcOq5B1Iy6hh49KlpFYVmICgpGQ+mYRpu6?=
 =?us-ascii?Q?WDiPzC3RR5GWfFLYMAxf9a5yn8nPzFtCt02FNwB4vQnQfwHx086CJ8SNDhmf?=
 =?us-ascii?Q?zd09iJVetIBLNJvagSj/DQJqNgmMsf9d7A2/LcqkuZXjZD0H22Q15Um0xJWT?=
 =?us-ascii?Q?633o7zddH+FqHqCuVjxcIhu8cQ7JIjDK2EboHoO+uSFR9EIw7P2/fs0GaMs+?=
 =?us-ascii?Q?qY6PSncupwP3vU7sv7OMxv1KWQrDmOtxBYvgQGIGlpAzEsjJtExMBB2qMzvO?=
 =?us-ascii?Q?7/IqTVOBzrCSM0eXHSIqHauwAhZ6wGYWIB5xLn1wEcPVscRIL++Wh4JTu71U?=
 =?us-ascii?Q?KfkGQ+senbcrrdHCvNLWJmWWMn9jigXQCLRNVTtfT2Zi/zSsB3UfSITZ4s/r?=
 =?us-ascii?Q?RoMrAsFE4k6jOMDH1k0g2NjBtPkGIT2K+p0E7sqY3xaxTloJ7kcvgmnYe4ug?=
 =?us-ascii?Q?S6FLKvgHqusY9+xSNVAVeweSj/6IZHvD2sXBQZWxxpEOzasZE4IMYTnjtV+1?=
 =?us-ascii?Q?SpeTlEw6+HYgksVjvoVIQQUmMof1PegwDW/CidxYePmrDqH8pfb3Rq8Nf0cP?=
 =?us-ascii?Q?mrmL5RqiGHU9K4TnnaiC1mPHnSvVgOSqOop47oN6LHqnl9WYXGEssxlevgNc?=
 =?us-ascii?Q?Qg9QWo+o8MsMZb1S5fQtY1QGSAMHPLXkAGYOHStl57YCM/zuA9qTiUpIrW31?=
 =?us-ascii?Q?LYlSXafNf0SxvFJiZMDTTh6510r628V1vWsdyjYjD96iKmJwTxaEtB4hQame?=
 =?us-ascii?Q?P5HV0iMqnCy9F3Xka6WrdNxxMJHHwxlH7mBwiL8rI3i+xflDjbvV75JsPz4I?=
 =?us-ascii?Q?KUm7Z3sF9UqdJwQzvxI+rWurISj0pkGFKzk/vUMv4ETy1fOXobSvgGjgs5ro?=
 =?us-ascii?Q?1lI+kgW4mVbyU4ePi0fUk1+1ZKSgKbAfr2KrNrLGd9TlD3odh8xd/Qdc/2us?=
 =?us-ascii?Q?bvvq7atSbeUsvR/K5PeqUz5c1DrbiCLA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?stzHyPs2q28o06+EoYZvqcDS/JRvaO6Ms23ZKaExyJpSp7VeT5aMRcVJWz0l?=
 =?us-ascii?Q?Wv96R1LLJZ+j/+BrtqLHtB81AQmCg5RYEPsbd6moTAojYQVZ5GF5YqWO0sXt?=
 =?us-ascii?Q?PhPcqlruEkRL3Sf4Qo6O1qzvXOlvYpzHeUaPHnk/KEJVXblDPnJnaLPJEMVz?=
 =?us-ascii?Q?DRSQztTZUyrUGeRV4+LlfX0mMt66RkLz6ahqr3gkGUm5WWNLAlSiGrBIBq+q?=
 =?us-ascii?Q?JYbqVbBmsZ2IxH7PCFMpjITkqbC2cE4+aJ9Qsz6LjSJz5z0XJny1UxVr/BMU?=
 =?us-ascii?Q?M7PW7WmCQWGKymDLz7KyQxN8thCFNNfPEWhdp6hfnne1E+JOQQPKLoPLvaRm?=
 =?us-ascii?Q?KtyUqTvhFXiP7r5gLbtOlFRPEHcjptwRhETQDN5uCtdpFQElEqXYEM9gIW0P?=
 =?us-ascii?Q?EH6NJejGCYEX0Wm8HfEsHjkrddOkuj2W+uOP27VFH8gv87a2CU+9YQTX/EJI?=
 =?us-ascii?Q?GaCzPaKxgrM2xGFKSvzHHFvrLcWcog9TqmnWviBmJGQSnEYnjwe9MTwhKd6i?=
 =?us-ascii?Q?X7BWwXUagx1f/I0B8CtZErVj6NPWUQ6KPT2kgZUW3747oqWm99ctL7kg/u/U?=
 =?us-ascii?Q?0nTxdWejY/musHiAp7OZzoKtYbOmGHztiEsnrO9e4tNyeBmDXYO44P9nBbc8?=
 =?us-ascii?Q?sW2D7AKIdvydG1N35sx32J0FmkvAiieS8yODWsNjvu4sy9hwAd3flP5fD0pM?=
 =?us-ascii?Q?wm0Sen1fpbawttHZ5wFtXZSbldsLIomH0WfcjF2vaf2oVcjz8IyB5wXwM26f?=
 =?us-ascii?Q?x6yF7/h52Syh5mu8iYVTqqVfOQ1UBV6SQC9nJpkriPPjdAu/50fYvT1acw3P?=
 =?us-ascii?Q?O5j1b0faULN0zsQTl++OwE9UUQPQ58VTjlECrs7WqZzPFVeFkCV0Rci2vopw?=
 =?us-ascii?Q?+g1rOuERWCKME7XgqTBGEQBIIjnUlA6PDHEGaPSA0SmZrbNrdQS+2RYlkLp1?=
 =?us-ascii?Q?0qnNvTnVdOClLNsZzbh5luVLBcL01q7zW4JuZJn2F8kQX/teoSUDZ87RsSEM?=
 =?us-ascii?Q?XEDDJXeC/4dzPBUGNBmeZSrFfCuTpJqfKD8uWwXv8fBDMmk2w8nI83b02v0z?=
 =?us-ascii?Q?hsc3+68aovjEaPcdV4oH1QgpL2eBZJGU4dg/X4uXM+2oFI281/JeVEoc4Q5P?=
 =?us-ascii?Q?kJtCkStAumMrFs847PWJHLW5t5ISQvw2ggLSDtslYYNmc3Ap2v1VFl0Ee00E?=
 =?us-ascii?Q?OduJmjNFRsFFVgO2kusbhpcPMfs30lxejkszi9MZZJbsMSj96HzfsxX5lekR?=
 =?us-ascii?Q?9wIHXXsSa8mXI8LaezaWrT0dri6KbdDIYsiLQ0JQWVLFKcjTCQT4PQeBempl?=
 =?us-ascii?Q?9Iz1nBbs5ghWZIOaLnpfadLgy+SAX+If5PWb87XDT7KpWC7s1AFiQH4uDf+z?=
 =?us-ascii?Q?+CR32vVmI7h9qa5kE24rDo3MYDNlNg97WSKbQrh8PYPmK2ojoWE0aqgtVG2p?=
 =?us-ascii?Q?ZZy7kqTC6TZ1sbsWzhASdeS8HtLlOoIWdGE81fXVN+Z286dfAfvo6yx48SPd?=
 =?us-ascii?Q?g6fE97DuCzu5wRA6vZkGsUEVEvW6I3tdFPE2th6RAIp16DQoQ7C2frB8PdsE?=
 =?us-ascii?Q?bOfUtohri3F7UJ1JPaui8JkBYqImWutQvll1bfLzKQszi0t1i6mdANipLYEp?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JQwGZrH+WxK7ekCLi2YjjZw4iYDjMC0d5gBuHxw75yRLuPubFKP+dgKF4mQZUxdDAUaWdXdtKv1xf8MfMJdhRwAe0ANpE9/OMFO6ONTsp4yfXmT8Ue0bLQxndcVSUZTj2WWuIsO11NJuzSstG7msNq4fANXnrOWz+L3gjD4icM6UXhKWMfOSbjM0X2QN7oBpwr7CewQylDO0i9C3XDBYKsz4VfkT9aZ5GwQ2/r5LUUGJ6avPUBxDgWHVjO8sdZCpa2UgUqDfSaqandqNbPuIh/cMaz6EaANZAtZnHsIXWpwu6oJTKyn8SbWGfkOZ0CAQ6OfNUnGiZ6AOH02u5cHSiMUjZuzn4WxMQSGCXf24GBrkWenU4CELpqjSh8PUoqkvuaejZR8G9PgDuHxbuHbdz9NEfHvgCBxoc94iNGnXBY0rr8KLL8UsQg8GL/s6W/LpGqKLJjrXWozf+yAzMbGhRCn/156rVd6fyBzi4oC6R+BTsPpEgSFaqbRiMTanvYAb+0DUq1+5LSl9IG4ik1yvrbxsYUJ+rPx0VL1j6ETVCDrO/6RAaMFyhSw1eQQsgvPjqDTNsjC/RubRc2mO+6DplfmGdcgnQWdGmWSdOex+YoM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1bb61c-63a8-4169-f163-08de3c1b76a8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:38.6816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JuriofCyJ3jw/DrKh8pxrhA2a6fu7ocHmjZ62YQtFy68OHTYOPpv2429J4+2obIUKr1rMILK3rleNDQU+WP5S1pOIVgGjmuScIhnPvPnJWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8049
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-GUID: A15wzS-fDSlLYiLclI6oIeO_tzaP4sLU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfX7KjmDqZqCVsx
 +CmSWi0do3PEHrxHmMLShQ3uListIFok0arKbs0arI7hZCNK64zNj1Jgxb9jXw3WpoJezX3O2Yf
 Uv7sDi3Emf8X+ErY4reAa80TSqzIcW3d2whQc9XLkvb38aRyTWOpe7BhkLwZjw5S+yAq3vPhSJC
 xpj8P3hMKPkUoekEjXZY0g5BlokGn1AciF/Q3QAzR5r9lYEwc5QyhPGkr1Gso8nz03NaHcuTVkR
 5mQ+2mTS2PmS6GYJ7rGoStY9BbCZCntpWm3Y8MqHRMu7hmitxx8bgMyYiYY7SE8x24s605YwYVj
 9QUdQZr/Qf+HgsbGkfPBMwpl0hCSKYX1XhLbMoHqF3LyvJmBAF6ULd0UJtYLWuqzHiylVSA4SMR
 IoL+tIaodNbdoQ8ujbjqDGAqR0QEDw==
X-Authority-Analysis: v=2.4 cv=GbUaXAXL c=1 sm=1 tr=0 ts=69407465 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=yF6BjjoBLw8LOi3scPwA:9
X-Proofpoint-ORIG-GUID: A15wzS-fDSlLYiLclI6oIeO_tzaP4sLU
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F05534000C
X-Stat-Signature: hrpykagrwwahe6ixc88sf4hin3k6cokg
X-HE-Tag: 1765831797-737744
X-HE-Meta: U2FsdGVkX1/QxoeUDwY/Xwj9gea/BJX/DTYK/ubaGRjQpEoHLLQkabes/MhB1NKrEkxm8NGzIgsNLuhYQ7ry1cAKNhwQ17y9soSw8VN6LmT7puL29KnJ7wzqHtJrncPib5hv76HwuVvxs2AlaOkNggjHsF0Rl02LxWPK7XwyaaM+/gfWf1rk0s05qToNIVwJgTh7bDxCrOACntNxj9fYRuLCO+pSogkvw3o7r8lrbmX0XgBh5tWGBDuEuxqKDyFXtSpjeI4WA/c+oBtR8Y+DLFGiwvUYTG/kYopZZ+J1mmiXK6XTglD4CxZRU0UDgBwhEWmWaIxbqab97nd7x8U3SYKuQ64P12qo8a4mHwVZQGNpkdSKklViBTu44HUXSpmiVg6jFl1Kj7Xid1T8uWSmEk1rxnh8hpAelb7Wxb2LE4RwcaNIfAkiUGlvpdNwDO1NbgKytY5Bu887MCR1UpLjp7zOSDmYm5cUXaJcFlvcQm19o6LT+B9w4fZNkBx/G959o6g7D5j96RCZj6/1l3vVuOeeOdagU0Gy3NtF7q412EutyWyEc4tUU0qjehKMn34gYjfGzrl4waapu6eXAW/g0DE72Raw+gUN7+kRTCIN6QjAntFak8GcJ9Wm7YnktEbehUnl95XkeO97FKjsX7Sbuu8S52voHPWm/M/13rwONRhrQ8TZGWFnEvL5NjmCDmadSkyhhRFA+riFzu6G5GyVM2DHbXKhIF+cFVI4YfQ5mbAbF0QaZYWgoz6c2ZyqLEPn1kVPnnzE3dF76vumM5k0wnXs+77R03Vao82X1dxn6+OCDmRdHwsIDKIWj8CeZdZcYVzBcmTjjQdabh2gb8HGYAIptUBmE/nQTtxF1s5K26LwGA4L5yBNjxtaxE3MsxWoCAFqvz9sS1QcLsrg8rAbESeynKhuVz0CAYFLhLYdT1nXAzEHWy0Wnl/BBo8rvl6dZZUKLTE9bBW/1HcbDdu
 czbjsONv
 Z2MFgjCWZlHjxnuazwQYO89IlSRc66B8vrjrdQu2g8fz4jeYcBq85dMMayTTkk7J9GV/2JJosRaDUOHa1tSSn02muIKrUk6Y4SbZFqVoZ3ZetrzQMbjItsTwODwM3UpF+2uSkf24sv9G+j0boxB7BU6UQ12HxJnOYvmKv7P72ryBLgEuPxhJZVVvos0ORqfXAjXae5JV5HyCmy4jBbzfnU5kFyG0j+saSh1BO7RCrAcqPvywxJWCZaFXyKr3osH9p2iO3bZ2Qvanqe7l5lq3YbLje3NCzGdo9+lTGnpp8gps82awxhabizQYuhiuoV208uGG0V8Mndpo/sNxzjrheL3QWnwnO8W5PyhVMm+iCypzoIaD4exWv9CKEoaJwWUAGggLZ7wYd2f5fN+eyphzs/aXifh7Nykfh6NN5AA7MYqYva95qLTrAWCzViCo/zvzqUmCPpfK9GNC1NeDsrqTRvuP//lHnXxOOp64rcv6DZYVoqPtY87rdrSq3EVNHXOYhLY2gJQ77700Km7n6gOxgGQp9oG9xg7RZwIlSgXb/g4oaDL07WzMW00/fAH7xgk/DMl8E4i7hLOHd0q7ECfHwbYEo80CMBAnBvXtMeGGzL1Nvn6aWhMt/8oL3WlnpRTAjvgT0fsl7oZkOnmrG/GDa53q9jLIlMqKvZsOL+21GXg0wJMfQp5qmrI4Nud6TSfEbpYUnNWdLZHppxe8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clear contiguous page ranges in folio_zero_user() instead of clearing
a single page at a time. Exposing larger ranges enables extent based
processor optimizations.

However, because the underlying clearing primitives do not, or might
not be able to check to call cond_resched() to check if preemption
is required, limit the worst case preemption latency by doing the
clearing in no more than PROCESS_PAGES_NON_PREEMPT_BATCH units.

For architectures that define clear_pages(), we assume that the
clearing is fast and define PROCESS_PAGES_NON_PREEMPT_BATCH as 8MB
worth of pages. This should be large enough to allow the processor
to optimize the operation and yet small enough that we see reasonable
preemption latency for when this optimization is not possible
(ex. slow microarchitectures, memory bandwidth saturation.)

Architectures that don't define clear_pages() will continue to use
the base value (single page). And, preemptible models don't need
invocations of cond_resched() so don't care about the batch size.

The resultant performance depends on the kinds of optimizations
available to the CPU for the region size being cleared. Two classes
of optimizations:

  - clearing iteration costs are amortized over a range larger
    than a single page.
  - cacheline allocation elision (seen on AMD Zen models).

Testing a demand fault workload shows an improved baseline from the
first optimization and a larger improvement when the region being
cleared is large enough for the second optimization.

AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):

  $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                    page-at-a-time     contiguous clearing      change

                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*

   pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%	preempt=none|voluntary
   pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy

 [#] Notice that we perform much better with preempt=full|lazy. As
  mentioned above, preemptible models not needing explicit invocations
  of cond_resched() allow clearing of the full extent (1GB) as a
  single unit.
  In comparison the maximum extent used for preempt=none|voluntary is
  PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).

  The larger extent allows the processor to elide cacheline
  allocation (on Milan the threshold is LLC-size=32MB.)

Also as mentioned earlier, the baseline improvement is not specific to
AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
improvement as the Milan pg-sz=2MB workload above (~30%).

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 include/linux/mm.h | 38 +++++++++++++++++++++++++++++++++++++-
 mm/memory.c        | 46 +++++++++++++++++++++++++---------------------
 2 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 12106ebf1a50..45e5e0ef620c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4194,7 +4194,6 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
-#ifndef clear_pages
 /**
  * clear_pages() - clear a page range for kernel-internal use.
  * @addr: start address
@@ -4204,7 +4203,18 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
  * mapped to user space.
  *
  * Does absolutely no exception handling.
+ *
+ * Note that even though the clearing operation is preemptible, clear_pages()
+ * does not (and on architectures where it reduces to a few long-running
+ * instructions, might not be able to) call cond_resched() to check if
+ * rescheduling is required.
+ *
+ * When running under preemptible models this is fine, since clear_pages(),
+ * even when reduced to long-running instructions, is preemptible.
+ * Under cooperatively scheduled models, however, the caller is expected to
+ * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
  */
+#ifndef clear_pages
 static inline void clear_pages(void *addr, unsigned int npages)
 {
 	do {
@@ -4214,6 +4224,32 @@ static inline void clear_pages(void *addr, unsigned int npages)
 }
 #endif
 
+#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
+#ifdef clear_pages
+/*
+ * The architecture defines clear_pages(), and we assume that it is
+ * generally "fast". So choose a batch size large enough to allow the processor
+ * headroom for optimizing the operation and yet small enough that we see
+ * reasonable preemption latency for when this optimization is not possible
+ * (ex. slow microarchitectures, memory bandwidth saturation.)
+ *
+ * With a value of 8MB and assuming a memory bandwidth of ~10GBps, this should
+ * result in worst case preemption latency of around 1ms when clearing pages.
+ *
+ * (See comment above clear_pages() for why preemption latency is a concern
+ * here.)
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		(8 << (20 - PAGE_SHIFT))
+#else /* !clear_pages */
+/*
+ * The architecture does not provide a clear_pages() implementation. Assume
+ * that clear_page() -- which clear_pages() will fallback to -- is relatively
+ * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
+#endif
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..974c48db6089 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7237,40 +7237,44 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
-				unsigned int nr_pages)
+static void clear_contig_highpages(struct page *page, unsigned long addr,
+				   unsigned int npages)
 {
-	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	int i;
+	unsigned int i, count, unit;
 
-	might_sleep();
-	for (i = 0; i < nr_pages; i++) {
+	/*
+	 * When clearing we want to operate on the largest extent possible since
+	 * that allows for extent based architecture specific optimizations.
+	 *
+	 * However, since the clearing interfaces (clear_user_highpages(),
+	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
+	 * limit the batch size when running under non-preemptible scheduling
+	 * models.
+	 */
+	unit = preempt_model_preemptible() ? npages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+
+	for (i = 0; i < npages; i += count) {
 		cond_resched();
-		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
+
+		count = min(unit, npages - i);
+		clear_user_highpages(page + i,
+				     addr + i * PAGE_SIZE, count);
 	}
 }
 
-static int clear_subpage(unsigned long addr, int idx, void *arg)
-{
-	struct folio *folio = arg;
-
-	clear_user_highpage(folio_page(folio, idx), addr);
-	return 0;
-}
-
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
- * @addr_hint: The address will be accessed or the base address if uncelar.
+ * @addr_hint: The address accessed by the user or the base address.
+ *
+ * Uses architectural support to clear page ranges.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 
-	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
-		clear_gigantic_page(folio, addr_hint, nr_pages);
-	else
-		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
+	clear_contig_highpages(folio_page(folio, 0),
+				base_addr, folio_nr_pages(folio));
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.31.1


