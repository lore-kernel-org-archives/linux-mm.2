Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBA0C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112D96B008C; Sun, 18 Jan 2026 09:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4FD6B0093; Sun, 18 Jan 2026 09:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4456B0095; Sun, 18 Jan 2026 09:52:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2C886B0093
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:52:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81451C1FD2
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:04 +0000 (UTC)
X-FDA: 84345374568.10.8977835
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E5FE1C0009
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L1ZMTZuv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ef2lqpTy;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Pbh//tMEL1Sb+y1eek1uoX6f+uV+GSsfep+yBo/398=;
	b=N12BuFGpjPuBbL6CH1LxuuszvMeRsWsJJAoc5Y1OtfiRQWXobrhWTRlGPG5RVDbU6ivwR4
	FAicJmK5ZKh2HcTDix2uukXF6s46Z/sWuxZDe3XrGxjZfzvsOMRLzoLb+ndJuRbHT+de0d
	qd3O20TQEYpaRfzqi0wdBkquGFbsIMU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L1ZMTZuv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ef2lqpTy;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747921; a=rsa-sha256;
	cv=pass;
	b=PwHRjq0qy43W0WLZGOZKBV2D5u9HpNG3gIKhggWdj0ZJyOfF41unBdzNt4iePsAppAlgvc
	CIBx51WIgXhH4H1e3ymVkb6dTCwo2zULqz0MM3sI0KSOfl+BcFA8vzE9KQYF8rtkuFblDQ
	56P+uBA0iVoHtvDwXuWhPBAiX45fBqg=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IEOt0L3741847;
	Sun, 18 Jan 2026 14:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4Pbh//tMEL1Sb+y1eek1uoX6f+uV+GSsfep+yBo/398=; b=
	L1ZMTZuvl+LF0mkzSneffczVtdH8JnYRfI1o7dqgZIn9EXUQSuyBDlthlOeTDcIT
	9Z8SrBh+3tMU1Ig427snqyNdXSWGYu8D/M4JIeCnyJtmijx+VZiszPAbQst02r1g
	BRln9mIGHpYG8MMXwhOz5jPOLg9mT9DX/tN4OR+2y/O7LMunj58jCqqhNNEHKUnJ
	h4OPrAr6B5XB1VtoQ7t9t6ERCzRdTYYSjulMRJsuAclqSnEV5vRoCiYl67R/O22X
	A+kuVde8yncnQad5xbXag+ohI35lfqH9QVyITTjJL0zXiacUHaLe2uh6tL+H1Iib
	w99PxqYJI6PBMwyHOUCmDg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21q9axj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IC4pTN015541;
	Sun, 18 Jan 2026 14:51:56 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010033.outbound.protection.outlook.com [52.101.61.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v7exkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CbjhO4P9TTEBcvjOShFhsZktT19tLE8jliTqYFCBdOI0O3kA5WmUJZG8MrfokLf026eCeQfp5PRWiG6g6XoCoJzOfiqD03l6gSzGlycbyfSgAZQ9Eklvun9IDSZlokecc3MHQgWNQuYChArqMR7beXXseWQYXufJq6iznwxfp9suISV5HBH7AEhUSbJ+9FPMxVM64S2AHaRPOV03M8KYwxcf2OgXV+80yNdxgt9S2g4S4Xw2pFDtEp+F72/hAjMDuNBr6uLI+zKs1mfcV8edZTJBfZtI4wja3WYXQ88EKQTxzu15t+aeSGEH08/908E4Ud8lzdAejARIxffHQxY95g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Pbh//tMEL1Sb+y1eek1uoX6f+uV+GSsfep+yBo/398=;
 b=ERu9W44r4f9dtJnrlo9rsbRKoNk7tbQOaR2DiJeTNtLevcFtsu7Uj5goqslm/ZfA/zmDO6FfdItNIOivTCzYdSBssFDvmJpJTThvhlKf3wjkQlO1b6EyxOUNMVP5HNwto5tUrchqKbywnP0WwJhzjDRfiEVxirap+ZD5lIyIZac45TE/tollBrfWhk/4MTTEmOyo1AyY//43qks1KaiY23zSU/xgrX0nVYF7iPBsYv+U+1qpkGBAlwl40qzFE0IC4ySr+tIjV5MDPamodHZnSauNRcg564QMsN67vWXC2sJWDIGVYaH0wHAMRRTxNA0LYB6Wf8E/JV59UOpwIcftdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Pbh//tMEL1Sb+y1eek1uoX6f+uV+GSsfep+yBo/398=;
 b=Ef2lqpTyh0NwooAlRGoSrMUCJM/c001mnu4LBvYF3jN/u4Z+0W/ifXP/1cxWmJuWdp7Zw8Ahf0CjRKyaW5h2wlgDQxSjKmk9CK5xWN+cvSOX/lrY9uTxC+HXZogjaREZfnamaa028QCoKDUNEN2rNoatWyf9LTHJBld/941zbv8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:53 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:53 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/9] mm/rmap: remove anon_vma_merge() function
Date: Sun, 18 Jan 2026 14:50:41 +0000
Message-ID: <56bbe45e309f7af197b1c4f94a9a0c8931ff2d29.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0477.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: ab31fa90-c45e-493a-7c93-08de56a11e72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kTgcfBBcfxM8Oh0CSS/DyP0JcJdBVAu8V9hUfdknNvJaKD6fkpYUoSuhahCw?=
 =?us-ascii?Q?xbfvvVgTO7x3X7ilcdD/nBrOTotC+f3EkRhUKNlv6KYgVBlShhiHPjVesYI7?=
 =?us-ascii?Q?IGmjZMSHD0HWvQzBcQsvGsz+v8F61ghL/04eiquv+5wMpDXlTcEh9UZ3PvmJ?=
 =?us-ascii?Q?llt0lXJBuHmj9MFCzLIYDCGLOeMw8VqlgPuINRmkE057IF89d9SLwZUj1rd5?=
 =?us-ascii?Q?EQYogDq7IddEv7B7HgklTIQdu5/I/P+8J48Euz/zueZV0OqRpfFRGLoAvB0P?=
 =?us-ascii?Q?2lX1w65qDDh/uShOQV/KQdPKOUlay1L5kK7HpFrysrZz2AX+IovRQ5ek3pqF?=
 =?us-ascii?Q?GwzMGn8fw0JETsDgoCPot0XGGzBEdyO5rGwWpkc7swv+eHzVbpBPs/kl0EMI?=
 =?us-ascii?Q?w4GNZtfb21L2khmOXMEnpJE6yxOBrnwo8Dd+fZqcJj5zyNUXt2YyDb2pAmnK?=
 =?us-ascii?Q?b4bCovEiogkhhkomU4WRkgBti6T/4Et6HK6weLSJu/ZDG8CkYZSOTmNR1nA6?=
 =?us-ascii?Q?xi44khDjtu0IU5RHUf8Cy6WSpPccHsoKekxhAyeFqGBjlfhCEA4NMTeWdYNp?=
 =?us-ascii?Q?aT3qE1voPXZz7IpVpoEO9sW4X1FlUo7BCGSjP/qlJkUUtOIs951YZzgiYEd8?=
 =?us-ascii?Q?mvTgcfuYr4o8mRcmekqQTvkZ0Ui+lvEk//HKmcoxZw3OLT9vM9Vvjl29hrP6?=
 =?us-ascii?Q?ciOx19gZWnjR0mVJBWiHc2LNmtLhLRFnjUlF8xoC8U2uC3AnM9CNMyo7ljAD?=
 =?us-ascii?Q?gyZ+/qmyfKMxeDDqXlFvhpOR/HeuC5yBMVwOdyYc6Z4ndz5r1Z2OEg6Sl0BE?=
 =?us-ascii?Q?zdulf4WvPVJ5zWIEu4V8Zl8lvY2ZYBxMbErCCGCcVs18EBGvXlT7kDcLxb9b?=
 =?us-ascii?Q?ht/U7dw/7hv9uiWsRq+WfKMg2mX+xsFU9tYfhYwWgyZbzoPp0SUj0VTlCxaD?=
 =?us-ascii?Q?efUSKSKcy3P0JZ9fjEAhrEPyp9zdk1aFKBSzwUb6z+W/lN1g1txyV4oQTj4Z?=
 =?us-ascii?Q?Xi8I+FwHVl4KsHs3MC1v+Q+J8rZjXvLh36O1gc3mR7fqgC6ljIm4d04UKbQB?=
 =?us-ascii?Q?NxPMW3PN8ZAXttQuvcVXwXJ/R8/PnVqewmYGgmWm7ligDrQGo7JFGHGpbk1y?=
 =?us-ascii?Q?schKTzMT4K44hPHtzVJFZHsJy54GBK2YckUBkR10vKXor/PeVQufddHtqcif?=
 =?us-ascii?Q?h7U/ECM8f3WoPgfi+9QBm8BCPVkKAnPXJgbghi7SF0xOAUD8GQt69pAp1YG2?=
 =?us-ascii?Q?TPR/DCLzmbTuElFLO/IR7zZFaVR/mTaS3UBrajpNrsyuk/dQVTH+oPBHxD6v?=
 =?us-ascii?Q?zdRMo+Rpk/bS5C6jEuZzHAJT+v7Jz2/DtyIZZPkHyAPTpMTTKIp9y5cBHxRM?=
 =?us-ascii?Q?0WCZfWetYKjdv24yG1q8XLSDFuOGzro9cYiLEWe2DspAs2Bj1DyzhDBM96n4?=
 =?us-ascii?Q?mcprsCyYE0Quz/c7PwS/VwEjBRi/CmbWkfpeG9MwMGaAyiLhwdYFiYKOKOZA?=
 =?us-ascii?Q?z3e+DklwCacUaFi7BuqMerCrPyUNvTdH3G8EXb8a1Rjjav5mz2HEhCDjrWht?=
 =?us-ascii?Q?tWXIv5+fXLi0FvHsS5c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2sT8EfL+uWhaunDEeMBMwf9XUmZcSaRHFC8NEPtqMbtNZCCJ2jybLvICK1DL?=
 =?us-ascii?Q?M46NaW+oB5bIMUs9jV1PBEc3PAT7/6VCMYLKd/pMsbjWD2MkJYI6WNZ6rBCe?=
 =?us-ascii?Q?u74Tv0wuPwcvTqtJhZkCwAQtU1fLNOc0aIZYjO3P7oRDdrQzfq3zyC7ruzNJ?=
 =?us-ascii?Q?TD4LQ2jh6AsJO7UfvjcLetIk6xixovgFbhbFErMxwp8pdIU+BrlS//TA/9w8?=
 =?us-ascii?Q?X/C1vPK7hLMIR5V2XLD97ocAMbB7PK/s41NlVv9Qyq4/fcN4/nHih5J0bHFe?=
 =?us-ascii?Q?t2hoUjUWRMFMQEJnppzlEmiloO9EiCJzjzjJ9hOSkys5piNxGp5LlIjcLs9I?=
 =?us-ascii?Q?GvDJugEj3Ndls/4iegiFraf58NXla4qFCxHTF6o6QOwsRAco99tmhQ41Vd4Y?=
 =?us-ascii?Q?4z1SFjWRcCqJLo/7RNcs8CV9uoe2/Z+n0HxaMAXYE9GNaU5UPr9vjpDvxfI1?=
 =?us-ascii?Q?LiGpOZdD38LhzIR74f0MRwZuLmuff2HBETncOpCqZo64H1PggB7y2Hp6U8Oi?=
 =?us-ascii?Q?zNAq7XMlC7Nh72++xWaTH2zybhlvGWfwUIcVss6mthKyksRoL4JlR3UsofM4?=
 =?us-ascii?Q?oxM8N8z3OI0wzjW5UAB/BZe6TDs6uBqG04DWfBPsGvgCPLgl2xals/fZs3fB?=
 =?us-ascii?Q?6lif4phkVpnuIwz4nx7Il7jZMpTbJznUQHYlBiCGUV7Jj+mrCwBKu2eSOuNF?=
 =?us-ascii?Q?dCIR1fqwEAza6bHbGUCj2Rr3BsRbZu2tL9f0864BNv7Uy693hp6LjJ1C2tOr?=
 =?us-ascii?Q?f0j65Bg7/o9/XCZLWSn6izLwpdnWY3/IgpVIHbv69Ch59wO41oRH60DxF+G7?=
 =?us-ascii?Q?9u7R8sW3U1eNvPVL9zWsSkHIl7MqZyyQSBna5CMlUiMj6AwSzwzimd+W431K?=
 =?us-ascii?Q?AlcDtSaQjHCTWDvh3/c80iU1lhZGKnWVQANA2gYrj4ZgW+KXaqE+Sd3RpP13?=
 =?us-ascii?Q?LZW1uAsJTVH0Rc0F5KrNk1Trt5kSdgRRAV4yg7DyrcUttR9LvWkP6c2k1+TM?=
 =?us-ascii?Q?Dqd3QR9TSXTasUkjyxSO/PosipyETLaGeE6JmI71t7SaOrQwSi0LX+Kell/T?=
 =?us-ascii?Q?jgN91xso/6UPqJFpHK5ZQsu4QEA+OsNYBGWdlLxJY/SraHP2jPqFdqu7o67+?=
 =?us-ascii?Q?qVVie3jviKKIIfVUZkqsbiyfJL41v2aNe/DZbgl9LO5sic2k9w4SWPlWs5Ei?=
 =?us-ascii?Q?yKPvyNikupSGbfiKBJ7vaGEIIuNE1DkB+aidIEgOmseERHD/Z8SsyLrGe2/F?=
 =?us-ascii?Q?MjYiMtza6zv5nRNbqKIsdLAUF6XEixlOTCPr7vv+WIOq4k+OAdo7UFe1ZrDS?=
 =?us-ascii?Q?n0VcIv9FGl3rn7F0ME8O4rUkQEy3yTIgojtZeZw2f1PMkvDyVEPEudmAulYZ?=
 =?us-ascii?Q?dPqRWg1O5m/7mcIJGMwJMMA0HsYxCkNnmVwnEx5boTQQtN+Qr+0xtqtLeprw?=
 =?us-ascii?Q?3UYjjHsK651w/RMzeCleZGesEz3dynBsM3RKW0VlPIQyFkZcQwDRaC69g2gV?=
 =?us-ascii?Q?075Mz9BKX/piEuRmxoTFnOrGvIURVjv3NQR3xS6wdVqCC1do5v5+16yfR39J?=
 =?us-ascii?Q?k6kkzO/YnzOLo1pSzgZhCGJBdBl2qmyhoZ/BpAKu+RqSrXU870w7J4EKsqC0?=
 =?us-ascii?Q?uY1YW6z5EE+UXOKqLmT8xdpPK7MoAkc+ChfMhV6AA2MjVg+NQPgkYOeNxbMs?=
 =?us-ascii?Q?m33m5iHirAA4Df9ot56BaI9cKgGakR7PxasyhjwMfEOeu+w65akqnfcnfUpk?=
 =?us-ascii?Q?RgHp4vKh93h0WTT9AiLsoYCJq+qWUuw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pvKfHPPSoxfy6V4cUbSojvEDoV2/gwis3/iDsLjk5Sv2KsBYUP0A/Ujy2m5BYDZv7nvexQzWU2cvJcEXPxZhukanPj1IqAVPSr5XixyaL+t92Rrlsqr9p7bI6s2xQZicdCkvocPhSCWfoS8KSGDXU3IGMTbviTVtw0teSMY/ot9qrgXgRhOnWiW6WJSAn7/IIUPT805lJAnT/g6fP+h/b6G7Royn/aDbGxmz8aAwYgoLkvoivjY8q62RYXw+HBa8JWy+tPko1G+HaP4GUu8eae2SWNlLYcKUXYOF3l6gNlj0R58bruF9ban3HOB6FY6H+CdVXKVem+Hn3yKvemQ8mub2LzMOlplFZfWFudbDhbgRsMBw7YmZiqKFAyJZejowm9qILoMyULIlLka6kUkopWGsg+YzYrgosrTi1mAn9vYcMLp0LjnwtebQ7IdQMXRM8R+CTNRrHp/hU9/kPPWY2x/PLks9AhiZESNNutZ0XYlH4CCcP3ZJDqGTkHNuBzv4TTcZadRnDExY2D9rV/gRrAYLq+xjvGc5Ef3UN8k9k2yrBLRcyconusMdpHPMsfR8Bkh6+hak6cbk/9qgTVHZPsFvHvQuuL4AYdvTYdwtc14=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab31fa90-c45e-493a-7c93-08de56a11e72
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:53.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KXoxkM2vbS7iOAyfo0biPa1/S/EGKpmDLfV7i32eOHc/YQxxdR7yvHySomBCL55lyWp7TZcDNiIkWg6AhYDwRSSUsEzc7CPCrIDmIvIeAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Proofpoint-GUID: _E1j6IF7Js1DVr4REBbZZA_M54-9pThM
X-Proofpoint-ORIG-GUID: _E1j6IF7Js1DVr4REBbZZA_M54-9pThM
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=696cf38d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=yDX0O4jjIrK4UegQ5t0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfX7WrBQQuvjsi2
 p3j4XCsl/QcfafnOrK7DRy+m+czmh/rTBYjzR/L5uVm9ZZURothCvLRlF6fCX3bs0w1jzmpomvV
 9uUWyCWgw+OymOydxBjb1A2pz/cLZBljmh6sOX36ptIGeBN5RXAqnd0pE+aZnJlRWktkUyme0SQ
 7PFl2nTITbhtS5VLj/RbhqeYpWY6mrfY5FQgjDT4vcKyRcCNbhV8v20fo3Z+1tvqguVYjdwBkOp
 QSQ4Y5c8x2Ra3h1YKHBZl6FdkzmsoRtLaD2Ezav31iLpvXOTMdQJyTDdtIzBNESedTT6k6oK5vS
 LQZKHRnWcDCvtLPZCVwJE6zR/sLf8VXg8QheNe0OIEEV8DRkXDi1Z5DvuIfeL6hDm6FVST42QYt
 2h6+RAr41yh0Ww6z/6a7hamVRS3E0NIzGA0kjYn4Mo61HfFfvp3pW/kJxzOUl2Dpyr0jQEh5bX0
 LhVoJENQrWB874gkSdg==
X-Rspam-User: 
X-Stat-Signature: igjb891ufzyu7mc78csgfjr91xfzgfkq
X-Rspamd-Queue-Id: 1E5FE1C0009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768747920-750770
X-HE-Meta: U2FsdGVkX19wB5pauoIeJgLSX27IwrRgAcQpDk0czrwHRnHYIEZQZFm0RfHf+NPpnQ/FcMcoHfOTbzmqlQyXwRwmRTV30O8gGE7vCX0m8c+9PoiWjy6kKlmMT2dMAe9tgFhuf1vwyll4eXiEtZdruH0Voy5gAivYBmLR28ApaaxUuvZSc0z/DaFrt2ZeyzDlalSIFxEqc+CIrByJKdYb26phZoEuZtibwFz2CDBtHf/PW5dNbX/K/rWP9dFmyFn6gGDWNaxXfUwULCm5uBd/piQOTPDMXjDnEI2n96tu/OtIGquscrhE7zpetifkJm2nwdahAodZxQdfypZpOiomhjLDNv4CTVoy/jFbd4ThRUjHEuHrXY42a9ThXIS9iz037e+gTJ02WR41oo+hinF8dpexiS9H9jwgy3Ca8dy5LbxE7mh3bxmvq10LGqTp0Yh4U0/AcbL/XdyPwX8za+Q2KifI8of93FXMCYx9k5vANd8CLhB8PFK733eVcA0anp8m5IFRJOV8ItAGjMOlT3ASQY4vyGlwm/OynXfqGn5F8inxwjn5uHepxQas0qAe1VP+e+Yk16bC3XtX+WvPX2ZBNmMk15cdtM/Gnh5UeGK2419bga8DuKLa6ibs/YjI5HbR7XRvBYdTWqlNvyO4/4Ld2gkwmxXn4SQifcnWW4LDzDAUW+HG46HgfCet1xyzMbzEHabytsR+02IEjNE3JdXdu+UwadWI7GzKdfCi0x6Npz06ZLR21ampjHIcQzwCS4BtlIbwgUraY9u3FpfU0T3tB4n3khpS6ht+ARmNXn5UyMQHqYueH/mNEdAz2jZitxC7xj4ynsj9k4wv/IW47iw3OsrzL/oLJYY66JWY03M11UN8czJoSkclWh7MrFRcX6OaP0BBV4GpUfhOaD658sLRs7nHOm5pIzBV7Yat5JPUlxCjbr4U30Pz73+N9N6f05x40dH3Av1i3FDSjCyKfeA
 /8kVRlvE
 RELb06l6WY1Hx2iJLUdXmZ2a3P7sy/jS5QykGg+3OhwD2QKfE9W4JfBQ9Nx7RGwRL1PGeDNGH0V8q1T6fTgYXgTiyrIToNNvnRJLLCU69pyEQv7PCmvX9FFKgwLbm7dDFi1zQ2Ob1oXvpBi1CGBBgEXgThZUzZ6Mend7Wp3sgGy8jUe6VX06OptY5O5kASuav0Mu16xaT5fVluDi6Unpnv96zNLnq+shV8BLihP1Hc5mR453wiJo6Q3gzo5L5jYCezoUQlL0FUsPV5Jhk5HY2I0P7+mPPoMlKL7FBf49WVe4hN10ERgRbJNxZUMN92PswERw0zn/VOHVR37JaKmHOg9xyfOYXv1Aens+buPaBexpYytai3/y1q9lSdmn0uKNs+uw6JV06A2wy5HjQZySMsWWkwd6QJNpKGy2UB/dwhGTqFyHtoe/JF0ggaYwFn699jA+5mQ8LD0mZBIvsgVdyfrfWBXaIjGV8Iu2A5E0oicSU5ybXSaso+BxEHUb547KV950HkrVK2bEkpj2pKU0xLUdKsKPP687diDbJqblHT9bydXJmOTW9iVko5iMFHZMbECzmEkQSjeD2d2ynCoQbwbO5gifhMcPP4dD+RwoicZMzXYWcYErP0A1gOfCq70iId/m3r4fV35Ldx/Svw58A4pjDci+OIuJ9pUE61wpV2/LNNxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is confusing, we already have the concept of anon_vma merge
to adjacent VMA's anon_vma's to increase probability of anon_vma
compatibility and therefore VMA merge (see is_mergeable_anon_vma() etc.),
as well as anon_vma reuse, along side the usual VMA merge logic.

We can remove the anon_vma check as it is redundant - a merge would not
have been permitted with removal if the anon_vma's were not the same (and
in the case of an unfaulted/faulted merge, we would have already set the
unfaulted VMA's anon_vma to vp->remove->anon_vma in dup_anon_vma()).

Avoid overloading this term when we're very simply unlinking anon_vma
state from a removed VMA upon merge.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/rmap.h             | 7 -------
 mm/vma.c                         | 2 +-
 tools/testing/vma/vma_internal.h | 5 -----
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d..832bfc0ccfc6 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -165,13 +165,6 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
 	return __anon_vma_prepare(vma);
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-	VM_BUG_ON_VMA(vma->anon_vma != next->anon_vma, vma);
-	unlink_anon_vmas(next);
-}
-
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MM_ID
diff --git a/mm/vma.c b/mm/vma.c
index f81a5cfcd7cc..6c458c8656b8 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -381,7 +381,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 			fput(vp->file);
 		}
 		if (vp->remove->anon_vma)
-			anon_vma_merge(vp->vma, vp->remove);
+			unlink_anon_vmas(vp->remove);
 		mm->map_count--;
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 9f0a9f5ed0fe..93e5792306d9 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1265,11 +1265,6 @@ static inline void i_mmap_unlock_write(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-}
-
 static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
-- 
2.52.0


