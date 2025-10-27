Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C11CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 20:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2872280097; Mon, 27 Oct 2025 16:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A2980096; Mon, 27 Oct 2025 16:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D6B80097; Mon, 27 Oct 2025 16:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E421180095
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:21:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF66913A131
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:39 +0000 (UTC)
X-FDA: 84045014718.07.3E70AEC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DD9318000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X8hzrSCW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ft1ZIybz;
	spf=pass (imf06.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761596496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EheJ2EBscKrw6hhaI/SM+sN1rdYzgxzEwuE6frU4uVE=;
	b=LG9x11T/t2Z0L3UKPZKZ0Wa08/+nPX3bALeaow9FAb6SQzx3gfbYma+kZmme7ZUG754d4w
	OpzcqoqzIY5TLBQuE0kuRIYcLtlvRrvf12E9g5/jsaMxlZihaYF20kMj+WF7cb2bU7GNva
	8/2xKNw+ZCWpSDFd/n2pdLPi/mEVp/8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X8hzrSCW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ft1ZIybz;
	spf=pass (imf06.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761596496; a=rsa-sha256;
	cv=pass;
	b=nyesq3kRvXwluNEfacpoa1gvXPnBab635s5yvzi4xuxLF1aQHuoN96IAlUIrz4KJG2OlP5
	QncktyzkUvRq2tXW3BuuFu2rMeq5LfZ8QsTD6mHvHABOJ36wHN/pvQRBIZcDCbZVHdEb4O
	eG5U8b7OTi1eybRjH24pxkvPbH8gcuI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RKCSKA007978;
	Mon, 27 Oct 2025 20:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EheJ2EBscKrw6hhaI/SM+sN1rdYzgxzEwuE6frU4uVE=; b=
	X8hzrSCWbB1yI+nAs/6ZTcNXct90ACJku82ofq0YQT9UY8id7haD6LknlJMyNDGm
	MXBga1Y6pjMsF1xvd4sMrSBlsKdMuU487FsCs0IVqHyIBE0hcQtwsAeljPTYoePG
	6xwB0o4+zJC7Y0lt/SvoLzptTFd1AhPm0Q23LAj3z8Mgqwv7MbL/SRyHPrYtFZqd
	NMrM85AhCEpK/B9xg+uFdCBCiSfVDWRRAbXYpvmbWsSf/YFIcJzeP3NU1b8ikNyf
	TnAeIBmHNbJGHBqCFww9CdCRddD1IrLwqHbeHKOHsqu6zuddPmMWpws4fC1WrU6T
	/rsXodPIU6iJuth/cR97DA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22x6sv5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RJ0BMc030492;
	Mon, 27 Oct 2025 20:21:21 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010005.outbound.protection.outlook.com [52.101.61.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n0792r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wH9soKkoonhZxeOYbrvmOEHD1Ecv+nBFCRodIsTnAzsiFFfy2AXd9oAjGWSBOxp28RAKnxvNUkoQHGzkIttKonTiYPtbTVNlF9J9OZo3nAgUS16tVKsOpz85Pxexij6w/uyILRsEF6UczoI2WiP9Ewu2VTK6CGrck1h79N1NIo+/8xYGB6AAKvHsd+9NKaFbQF6UsMY/MM27lTR53b2IzxY1JhW6q8H7eber3A3n+sHyFPXa4V86u2bwX+TWSh7aO4ZckeK75mozaVS7iWR4l6w+pvfdQT+TMbGt3Q4sSsVeuZD2cLe1cR0qi34fo4CpCP5IfE1/JEicEUm4ohKDEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EheJ2EBscKrw6hhaI/SM+sN1rdYzgxzEwuE6frU4uVE=;
 b=rTx9OVNtdYJg0Vi4hdeBDCdHB/P1kZULQ77WYKcnmGblWAXaSPFH9l+Abu+E8MOrEmWwIavQfIor53Fz/W9Es0oM/jePMGq348yD25TWytwlxIK9vQYY+FVKAJIweZ+pxDlyZm2AKppzYVQ7MBZlWbCI9uq8t6WoZ6fsmgfyZlJvICnC1fAS5/FsuMF1pQW7sQn24q+fc/rugXBGIAjhb4rzuxFQwoicB2PaTF1vfddxF6EEp6/DUnEr7EH1bKnafp+DqbRpWVMAS/aWeKbQ+V0wXEEMF3jhfHrhmo/9uVkVslEJtB/TNy4y1k1Rv//x32i5perg3OR7J3tPJtGN8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EheJ2EBscKrw6hhaI/SM+sN1rdYzgxzEwuE6frU4uVE=;
 b=ft1ZIybzdocnJgdJre1ULq52FTOo8w/arIJwRSEU1ozJkBOhf9rxfqGvGFVkWeRz8xsRiNtzEeeNVSU/xBJvyecQhgBp3h8SSIKA9IYsRwVFW6VkdQB1wMl7dFOV5yY/9Uo2Se0z8iLsCUn//a6DsVQvoW/XREv3hEkKVNA0gGk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM3PPF1A29160CF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 20:21:18 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 20:21:18 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v8 3/7] mm/highmem: introduce clear_user_highpages()
Date: Mon, 27 Oct 2025 13:21:05 -0700
Message-Id: <20251027202109.678022-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251027202109.678022-1-ankur.a.arora@oracle.com>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:303:b6::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM3PPF1A29160CF:EE_
X-MS-Office365-Filtering-Correlation-Id: c63caa68-d5e3-4138-90dd-08de159662b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UJJ5SltgBktymmoiL8hK9DT6AYkwJxSQU/ixvpeqn4zBJLDknV9W8SSpkRCG?=
 =?us-ascii?Q?POiPQUrM/5bP5uNqae5FJII3r6yl028SQ8kFzUTwIN+ORfNXgHRnYIBUbFKJ?=
 =?us-ascii?Q?y5y+s/F2sysjBMo9EitOhnTA51p/hXmnVLYxB4lD88Wqco043J703Yk5rxFE?=
 =?us-ascii?Q?fP0Y80D33mL1q7uAeN2mjTPmkBaUVsmIHMIh+Wd6cGN2yltqnGu7jMyjiQEh?=
 =?us-ascii?Q?QeNL+u1cvX6TSeTUBDSdi4+ClbHDyMgO9nPu6afMv1cQo+5VgXMtDi/JxbCi?=
 =?us-ascii?Q?bXcvPVhbiBxCIs8PFuS8aoSqbzrgjVY/iL7OJrFRUSvgcJgCxlowpo9lnYi0?=
 =?us-ascii?Q?Xhirf2/6Kuo85ULHD0xUtBBxKRtKu7GRWSIoFv/Dlntcfk8Zwi3KyTNl3jZz?=
 =?us-ascii?Q?SBWF9gVH50HZGj6Uo9N1qhgqpUx6lIugVs9DvteVN+jwVoZtMyC8I6i6G6pl?=
 =?us-ascii?Q?62LqmlPaaAWDR8RAY6VTq12EriEzq4E13E8EdVK/3jbtupHnF48tTC1bchzE?=
 =?us-ascii?Q?HiHlwgWY5Cj2Sh+ijA52CRnN8fZICDbiteo4/IpXuDgzHOCvrb8229dmEbLX?=
 =?us-ascii?Q?hPO/ZeKIzNlEaUE8bjnBAYkdr0W9K2zcZKrXQK8WQt08H+SGh6v/iKBLDBjr?=
 =?us-ascii?Q?aOvKpwqY0MMddZxr6lFA0Irq03uB0Ejs1Ntz7DC4QcQzw7Fo5Td8iGlDhGKm?=
 =?us-ascii?Q?O8dzimvrqHJ35oI59TnMsRwfGpuX8g2AU65XMSI82vapMORx2FlouR5QUIQp?=
 =?us-ascii?Q?CRznnhs7+j/SxHKrdmpuEq6s3LPT1W1vQnyybrqWMvoCGStgQCCiCTmDW6kX?=
 =?us-ascii?Q?HBGVuFiarXV3mSsEicAaKmv0eY2CgiFePMAxh17uPWYCfO8EAnGq/9ub6z6J?=
 =?us-ascii?Q?fsGVwwzgk1F1fcgJ6tcypmfClDsGI/aN7C3NTjO/QwigjwkN4Vs2kPGcP69R?=
 =?us-ascii?Q?mKOTOVFmr+7FTcjnh0R59joq8vsgzXUMcMukxeVxkE21ofVKFZk+HtcGXqpy?=
 =?us-ascii?Q?wS3ABr+jljcIqjaa5RsrmK0qD6BIBER1qobWsHO2At26jTfC4jbxNgoc8zC9?=
 =?us-ascii?Q?z4UtZ164fTbQX7cVEZqkDEIMzfy4CipNZWQ25iDtmc3pbLRvGGsPVv5bdvGA?=
 =?us-ascii?Q?5L7z1RgUjvzqJ8b7m+Oxd9qNBEY2Ej/4uCY177wBTFOpRDq1bgeGNDGIV0x+?=
 =?us-ascii?Q?RV2rgQCMn7XDaDUW6FuUa6HFVlN/Pn6jqNeGMv3tzexfgmkt6xRLlhXrM1wb?=
 =?us-ascii?Q?NFe4ic9LPdgu9vkCneGhfg555Q86PPPZ+qS6PO2KTAKPD5DVeDQ4GhNoEXFM?=
 =?us-ascii?Q?xhFfns1arGe7IxawaTH2Piw0cFB6fUEeJ6fzv2wGOg5TQqxCaIt1drdB2OPi?=
 =?us-ascii?Q?s8F06++sR2iBg6GNOXiiJt+de4CzLnD/EfjkUcZEbtrUlGL37clNoVr0x+Nm?=
 =?us-ascii?Q?/U/KUKhI08iMSV7r5K4J44DyrrA0Fw4U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8iqBh2rfOitAocysCm9nzVrKXfiL4dp1tW4X1Uij7nbNj5mgr14gKSxkXLW8?=
 =?us-ascii?Q?L19og2IomgIb0qUhGkBhjzDr0JfNtudjsFYc8HQ64NlakkoEsV2byKyx439H?=
 =?us-ascii?Q?AR1ZBoSFK23rUGLhLL6MlZLkY2lAX00t9NTr1kHToCn9zu3VPgon2OvnshOO?=
 =?us-ascii?Q?F79i3Bh96UR2iKbrQNikvc1eVUv50lwsmdRp21qEpRao+GvByHYQdsXZBsVj?=
 =?us-ascii?Q?o5741BSnINmk81HerQQoQpXXYFAFXoOBPjwOuN7gWSGSNM1wpy2xvrUx69QX?=
 =?us-ascii?Q?RrEo1wtVtFO/nBwkB45l5BKhIWR2pJ43RsxoZJgLSd73MPAO2GkNeaibBICv?=
 =?us-ascii?Q?40tflmYNuStJao9eL0Al06KAOieJOsOKs/SlIsvsP0fpMMcfaB1QoQSo3Xph?=
 =?us-ascii?Q?TFCaY9G7lMtBPfjilb4MafzxI7zXhrrQJXSzJK00yZSCochGyD6nnrh+l5DA?=
 =?us-ascii?Q?2uefRECimFTh+kkqf7KpG/dRinGt9Qn1Nzeb5DqC49jf0iyVbyGOI5X+cKNC?=
 =?us-ascii?Q?sp7o3noAk7Q30fOxiQnBLTxdNPf+Ds6IpMBZuYJqeghmPKV2Xi5ms+/j+dKH?=
 =?us-ascii?Q?1295nmGxNxJgnbWKDJ7gu279OBXHUi7hnrLmRlNDGtJ7MzrZ9lkQLv9na2xd?=
 =?us-ascii?Q?MlvecOGNOP0wJHlqMzipfo6jxc0B8TWbgHInqphnjaM2IO4D00VoB0AEtuhn?=
 =?us-ascii?Q?+lnRGn8Io+oWc1kGFXkyrUTxEiEn+SZiMFmfuwuZ7xQ4dypTviGMBJOnMjvk?=
 =?us-ascii?Q?yUjDiA/QQL0nxOVU1KD1c5pAo9RE88qZ5t+IuFSBGQbxHdh8vqaAwRid0xd4?=
 =?us-ascii?Q?ojB80csoDw8zPBcnyFpbRH+C5RWmtpq0I/P0T0fY22OHOld0WJ5UtFFxXLME?=
 =?us-ascii?Q?1MfV/8TuP5ak4FgBcii1iwWMxmy9n3lWBrcmVRTi9v7cpBAp6/cytz2Acym3?=
 =?us-ascii?Q?DuCaBBkcln/3FKtobFjVtuyl93+gAEFx+aiOmqHox8/tRU5cZY90h+t9Dye3?=
 =?us-ascii?Q?yBPk2JTovufgdw+CyVAhLJSICBk6ThF64XP3IY8g7qGMoumjCMoSx5ejxL7w?=
 =?us-ascii?Q?N28EZCVenV4JFCVFCrGASTlit7xa3E28h2gf0rDjPdz/QsQt93OS7S6cY7Yh?=
 =?us-ascii?Q?ZP+2sraSRiEUd4hmRZnNAFhy+Bun4PNCB+elNiyY+a4PdKQIJ4Jpq5BQX+dF?=
 =?us-ascii?Q?ln49j8XZS43n0h277b8Qz6AQ8ObpJIhl3neH8cv0HFxHLyWrZekGXMYVVPeb?=
 =?us-ascii?Q?m4JnXFFnvevvrIwrG2apdowrJalTSOP51YrJ8ySH5WENz8BMOs0udiGZlJON?=
 =?us-ascii?Q?7zw5kWwhvx+WeKIYToxlJohjxTwzy7us0cBW4EKgTTer46M+PjbPfvt99gDt?=
 =?us-ascii?Q?ETY/vGJnA3nhMQvibMYDZzVZ5VWKzpPpdU0XeSJ0chd5ie1lq3VTV3whnv+I?=
 =?us-ascii?Q?a+sXTUijYC1Md2UlVZnJNZaoGIizk9/VQThxLIpJXnH8E6wom3hT7Pcheh2h?=
 =?us-ascii?Q?LT9jB0WTccjhyQq5U7w0xf7ocBimcpv2KFRSWoJPp0ZDjc2LbiJev13v6yUT?=
 =?us-ascii?Q?x6PvOXVLY6c9897J6U87DfFqQjV/CX12gsONF3Xty6FEseoSE1KQrzb9nQxg?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yZsU0yMnFdW3XD7xClRquDXPJQRTbpkxP+lb0jtSoGKS0QBwXWgO/lV3OxzxiW7gDq3n94fL6ttD6Royr/gZRAg+eBuuGHCxLMU/XH+CvykvvI8dueryA3ErWvCJDov8Bn/nlfki2YUc9cqcxCLxesWKwO8gYCzBPmIeubAqhp6zEzf0ymZuoA/03LR/2QzDK1hBiIQqQPkvmHyu/x/9YCT0o9nh9kjy9kcEquWH5VNEmgyT/dOznSKBkhdbUdmY7qgLkhlefOWgVQVcQjOgPyYOZ3mq1PtsIt6Av6JgvdNbTyDwNYJ2n0QSOLNw7rIj4DXWJSlG73dOSWuNQUpWDvqHMkH6skM4CgSqewqWRMlHRydRkscjJUaMxjiJLt6VuZLoNtLfBuk+CxsPWaTb/g/D1Wv5PsOuyK6YqMpzkStHAtvNOB9dWkN24DbEkdsRPk9+8mW+hyIP1TijkxnylhG3MEX5oZj1LiAWjF+ZJ6ntHaF1T+obcQ2siDpxrzaIhbk1Ee1Wb95nXJl5kCSnpKboCeG78iMV0/OeKZTz2rtnBlQzrMHAJfbNndPljMOu35bhe/Cd0FXti542E8kRAd8K93ErzHAygARpDVKdYLo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c63caa68-d5e3-4138-90dd-08de159662b3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 20:21:17.9936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebxALk1BL9+vL/1kdEX/jx2eNTeZQQrL9O6cjMij93FHVWgErMIHftXBPozTKGt1meCy9N7NYkJV8ZA/QaYKiqwE5PrpFPgPVmoo5FWJPVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1A29160CF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510270187
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MiBTYWx0ZWRfX2mukphO6GWMr
 N3T/kTSIxRnmxboLYWC2SRkgcYeQrMp5FhcYE1UvMQGiSx5Wl8GZXRkGl6YlhUXr05tQgJLEdeF
 JvUsYtR3S59nknvgRlDu4TrJACCO21UscDdrWuh+3p02AIrJe/57MNxfC2W2xCSD8ljO5HU7uZh
 axw9i/zDni88XT+7YWS9iYbbfNlRu3iqU4xt8bjSuzcDsZ/PetTY+rryfmsLxfNoWvn8esiouca
 YSgFCk5egFmpCNeul8BIFx8lAdgxXTCp4o8fQtwxx/AURckKyUX1frnlg3m+OHPBrWz6fbTv++/
 7PDEaC87KrxrG2K7di3PylKDwOWGC6BEKwCxFihfRI2KYMHRPV2I+ocdExedWQhpkh7Xq+lYjQH
 XGeMOYtutaZ7gP5gUhKGyyDokUwQZg==
X-Proofpoint-GUID: QVkGVScFRqmJ8SNZhTPBIXw9t7sgS4Hu
X-Proofpoint-ORIG-GUID: QVkGVScFRqmJ8SNZhTPBIXw9t7sgS4Hu
X-Authority-Analysis: v=2.4 cv=dbiNHHXe c=1 sm=1 tr=0 ts=68ffd442 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=d0Ruhql17P3IiE_7rwkA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Queue-Id: 4DD9318000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kihq9oqzdys35hr9wty7injjtud9onxd
X-HE-Tag: 1761596496-876556
X-HE-Meta: U2FsdGVkX19TnzuxqcITyXMbE+1HN7/TXllnZfp5+2r7N++yQfe1NTJG12CpkzXhgFKkeMXPs/NNFoGef7rq7mxf0hoMLHe6tqfM6AAjdnNIbVoSJXTZYibrY/4ZUcJK6n7ULrmD4FytRtdrlTQ+GDaP7knks0GLGnj/tjpPsy6VDbb5SwRxudDK8TJG+w17b4UbKWz+6i4Bx+6LG56wHUGZOUihhWXu/3i0qjO+QccmmYqNjRVq6MmjlLotONmnUVIhvd8KdGhiYexLfu1xX7TMymOsTK5ROPx8duBLGu70HCW78/Wo5WyS0bwUE/u1BBPWCVPNhs9NTjQsY2n+cWOLKSOZDvL2C5iORBryHmI7RhORlaQGTMVOY3RizK7e0y+B1MWlIYfE9GgYBdOaGistXFZlAt3n6W+9QJr/o0fT9NPEe+Vx107TmZHnoKava/Cp0+EjixehwKaX7w3i7LN13zEOEQOYDmg6NWUgKJqYR6NcaD7O0F6EmI5ESdoQby+EcGaOs0a0hj0EADqMg8G81AiBAlbvTYX3+lK3YQ4d+HNdKrV2xrMYe8vyres3us3CWYtgG65slTj0FOsRM5j/b4MQG7cqAWThoSzoEt6NiPlRhYjO61IetQ2jXLWvr1HUY9ynMHX3w1gNXci4fzn7Qw2Q3OIdY6XWlNfuNJM9dtVsDB1TUKw4CfGmcTVoCqV8Lrd8M6z5LGASF1Iwib9aftzBxAE+bTKSroy/XAjkvceOl9Rh8Il0uBeOvTRiKH+MwHRiJlO8rBFlMzUzf0qTRxuPruCn6tqzeFMSdQc3O3DIfpGwjppEEC+bwL+8D+a4BhVAIF9kApZQELjbArSYBpZH5Wt18VSLKkuXshGyVCXVB0qBjMw+hzLnNbb5sygn2ahvYguZ20Q9PRcBOAF2Jx3YbxI+rc9z8UszOyY+ZInFuRYpVbu2NteRnhrtPDZxHeJ1dVz2CGbC4aN
 zNnFcrdx
 Th8CqQBRZQRGcN4lKOSx+KD/XQutIJlEzsspk9/F5cALl+30U0cn02GWUIiifIrBTV3BxIrez49IhLewSCxcdjEL+5bYNoYchog2kuQ1IaGT54R/4AV5W2MT+J6KqmFibJ1x/QEtKqbhg2KZJ0nhK9v/lk5pgzbshLP2eIJNwfA9OgQWLVmEpptpXT51RKtREApiwjR6wUQc2gnpYZIMtkrER09VA6OpqpxKzVRaqvrSYT+1IiUY5B4im+UTC7PCMFSWHGUX+EYBtc6EQfX14jfSOJcY3yOQdMll60asEZgo0AZAJI7CJLJ3kqLqg76GNeCmj4W9mepRJ46qAAPtoZ3Ziqi8sPifuzuK5WuU8UvBCxxZpYHZ5QbDQ0C624Pl1cnxR3pSVu6KA+jjlM72b6mMFJKEb90vh5wzlV8prKNwf96s4JXYWe9c+uwGm/XD8l9ds0NgtsdPrMKY/LjRn6dunEdNL5bOAnCXRdsF02qilBMK6RFKs9CsSaiWha4hs6RkT2tkPWRWLHDNbwB1+F6OBcGOwxGRQmhxmeaGX87tXwej9IvGDU+A/TjZakrZqbHxXYMUp9WSmUsRaFoNIgWM2altRBu5AMKWyol69jT+Pc04560BCW+abwoDVX9fJIfpSDE9dVF/lxEVYPOiww/iQ5h6u2OsHMuH3cZO1QVTfuilmpY8eGZhilQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define clear_user_highpages() which clears pages sequentially using
the single page variant.

With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
primitive clear_user_pages().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>

Note: fixed
---
 include/linux/highmem.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 105cc4c00cc3..c5f8b1556fd7 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -199,6 +199,11 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
 
 /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
 #ifndef clear_user_highpage
+/**
+ * clear_user_highpage() - clear a page to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
 	void *addr = kmap_local_page(page);
@@ -207,6 +212,30 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 }
 #endif
 
+/**
+ * clear_user_highpages() - clear a page range to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ * @npages: number of pages
+ *
+ * Assumes that all the pages in the region (@page, +@npages) are valid
+ * so this does no exception handling.
+ */
+static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
+					unsigned int npages)
+{
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		clear_user_pages(page_address(page), vaddr, page, npages);
+		return;
+	}
+
+	do {
+		clear_user_highpage(page, vaddr);
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+}
+
 #ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
-- 
2.43.5


