Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5EBCE9D42
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0E86B0098; Tue,  6 Jan 2026 10:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC0E6B0099; Tue,  6 Jan 2026 10:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E556B009B; Tue,  6 Jan 2026 10:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D700C6B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:05:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9700A14023E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:05:09 +0000 (UTC)
X-FDA: 84301861938.11.45F57EC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id D665E40002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:05:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dpJRRn0b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CbkoKdDE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767711906; a=rsa-sha256;
	cv=pass;
	b=keYQOidqq2jmEvfvZaidmPDioh++5mflqexVLXj8V3gTFce7UPTRJeSoSECvYh0Yg/QIWv
	DJcBl5rxQYa9CCnuZJAt7Ewo1RxgMvbA3AHgeLM0eJ0MIAh3iXxkVOd5oVatFMqivb/+0g
	PsCuRNfJEsgHsCYuUGdQ4HC4I88cY/U=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dpJRRn0b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CbkoKdDE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rf4oD+uVrKzB1mT2kVVckuYzj/2Pe0x1avPRPkKr0sw=;
	b=R3rsHr4oTdLwYblYgn6L7FWIOXRMPpne457tWPzykXh8g6HMaOC/snXOiC836NRFSBBifX
	qK1VrpU+cy7ZMiJ33m1zSIPjf+fJuKGX2lZXfHj/Gxc1gvAfJNaZRNwPNRCirYATfFeHXn
	0UlIUu5pZYlafCuo5qbyPyYnWqOJKnw=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606Euelj4108252;
	Tue, 6 Jan 2026 15:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Rf4oD+uVrKzB1mT2kVVckuYzj/2Pe0x1avPRPkKr0sw=; b=
	dpJRRn0bfeomWoAzMInjUv6DYw8ec0R7XV4AX5oxEasRX4PtZLtpbDrsQW0Wbasy
	IxI9OX+Cm4uZvCoYtFRCHl0+kLaoCQpHUV1z44EmkCUC8IVzhrQcAb5klQ4Z9QMz
	Eg3FqaEDcKN4w4EqXNl5bElvg9KdVVpbsZ7drxFU+dZS0zifHZ2V+7EJ2ZwOtNs+
	8NGvdu5SJ/cKLlNtR8/qZvYWOoCQxpMVWiotB93E9sxW7bZWeukQJISzIfOnFEdv
	kXubcTHn+7QoajjidOM+FfN/N3OeSINosRLa/Dda++sXU/6yWuwjXCZF4YK3HYkF
	ASo79hr4zCJfxwDRhCkVdg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh4kh80br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:05:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606Eipfj020440;
	Tue, 6 Jan 2026 15:04:59 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012031.outbound.protection.outlook.com [52.101.48.31])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjpx72-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UilKCWUuvzaY7Y1Q0D2LjPdfOxQ452F3q0jyl+eom8LpOQob9WZW6J8sTthz0Hjr4dm27Asc4xBarp9DI7riLIll66qFJ0H9ZEQHFJpqXdyblbzaY/P3p2D862lpWaj4PnXCEAIHsbZVgSzObAXciYEmZcjM29ngju/Z71Oh2hg2i/1Y5FY0+Ky7pAo+ENGhFe0DMn6a/hiOL+yGz0HKYDzY8JQa0/R7uPWDcoHQZS1vTjVjTGdzVVAk24JCfSEXYqFTc60rLHMdpO/vehuT/Ui34Kik+4Ucn92G+MOJJknjs42B5FAllrGVeIL4b3uxbkUJj1zzZ83KCJPQM1g/Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rf4oD+uVrKzB1mT2kVVckuYzj/2Pe0x1avPRPkKr0sw=;
 b=RfsDf688PU5BshdLoN6ho4Kx3TC2N7CthLsGtHLplTvwWvURGuFVJBamuapCT9BWgL/7EBqLHzu8ZzUAooYWoWXSfcr796K5H7lZHFO/IMeii7He2wP2JvZ0tFTovRi0a6zLMSZ52rptvLeQNBaIAAyhayMtgDOfRIi4OE0d+40nLu53KQx9Lvo6WG3OJxxIN0HHCwXrZvq+7UAl2j+HBENLaY6FVJIf3J60+UeDxGIODVKI3t/Fv8ZvSYR7AZdoFkfLzxI6MQlebnwlmJDZYE0dSCjmU3gpOV0v5vHRbqNkIyjUIdUS8jro3+sKqGLzVpZacjXUhYGXFCSg9D520Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rf4oD+uVrKzB1mT2kVVckuYzj/2Pe0x1avPRPkKr0sw=;
 b=CbkoKdDEs3q6TugzQ7zZakuToPthzBc5YKuNaek2n7NoSPug4fpSEOhwtWYxv4g6bYK5ShH4O77ZPnNgN91GSBX3zdoeJ+S9BMSXBSy63TzDDoXIgah8oSBTWocpPGQ6np0aDnDy6p2V/U5oR/81TcNweTnEBpjWOHOJNtXtDig=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6039.namprd10.prod.outlook.com (2603:10b6:8:b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1; Tue, 6 Jan 2026 15:04:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:56 +0000
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
Subject: [PATCH v2 7/8] mm/rmap: allocate anon_vma_chain objects unlocked when possible
Date: Tue,  6 Jan 2026 15:04:32 +0000
Message-ID: <ff2651a4d5b73c7cc8160c55d46d6e5385996e62.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P265CA0014.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 6206e132-f6ba-4d63-b2c6-08de4d34f415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k1k9H7Y8SIFGpwcfkIoNw+wGRbi/ge37XJtJm/+804+2QRxGYstUH3Lji2Dn?=
 =?us-ascii?Q?KLYDa7kVckkDsyWGbyPWVcsswTr8ATh9W9LMk3DTv0kaLEMzM2TOFj3KnHhq?=
 =?us-ascii?Q?j3iELXZ23YsLi0VpT5OGffStGRo5/aUPCFzJaUeaj8SvQBD67o2HOnUChZ5L?=
 =?us-ascii?Q?YtsEV1TuDYyig+glwN87ySjHv+Jh6X9jQJA0NAeoWS9/Rfm7tSRfD4ZcQ4Vl?=
 =?us-ascii?Q?bOzgHbpTyTwbj2YarfhyHzlB1sVZX13+Hn5pAMy2XWqCHo2zcl8p0Bxm+0dO?=
 =?us-ascii?Q?zC2zb8x9Bi/c/osKvQkZzQHFoLS2B4Tds2ha0u3o/wUf75f8TD6POqH44XJh?=
 =?us-ascii?Q?jMqgiuCPy83W2XBhf0gOPjP6w126vG+zy9Cgz7QpMeKCTDjSzwetJ29BrOXF?=
 =?us-ascii?Q?GPzMxQrzFo7EwyNGGWlpprJ0EVxasauoDGvtOaK/Ox3HZoq20NL/gfpMcSqm?=
 =?us-ascii?Q?SEpQPrcYIfGbke5MHYswdkeMGXhi3ZzufI+12MK0NkjJmJuDE9bleoawUPni?=
 =?us-ascii?Q?x2RL/Q8WIkFiwhNftp+R67s/6lWq3b+HKjyoFzykTeIyvhjDLOYNa5pnK5TX?=
 =?us-ascii?Q?bvpqMqsLzMQGinxPmMC4MOBZ+Mj/fjzS9+/aTun6SAPwfg/jJFTBPS6kVEv3?=
 =?us-ascii?Q?HsRgvkJGGJUHmej27NDSLKavhMB4jivY0GZ9KIxIOGW9TWRXE7Kv21YqVjgS?=
 =?us-ascii?Q?klyGFSOVrxMGWT/M3qblevu2Y2XyxlF8sYZ0XKx+v+lnsev5sPfFC1Rb8rph?=
 =?us-ascii?Q?2I3AosfdgfeK5VTW56PHkr5uX7H1H81b5EI6z5cTolAzbpSZ7sKT94CAjtBu?=
 =?us-ascii?Q?5DNQX9tCSFpuY4Ti3dUTeocKCPNLjTS9F6ksJfAiZCQrjwKLu7AZMWBF+pmY?=
 =?us-ascii?Q?V6b45zLpyiLN52oJgVWfGD7wcwEdmRy+oTVyE7R5Y/OP/oWk0FH5/714p5kh?=
 =?us-ascii?Q?VIlOykx1KzYDRS0ut0ijoyAT7FH2/AxwY6q/RVvHooaGj7hR9UJ0y2nfNQpp?=
 =?us-ascii?Q?8SyjeN/9M4uiZCkM3hh/icR+xFhQqZ8DfJU76x/pHfET/Ar12oT0F3QSLGSW?=
 =?us-ascii?Q?eg1iboUNCCwgvZ0qwbRTYAxnHvBkRmdCQuo/axPezWbjBGbw8lYAiWJ7hzXt?=
 =?us-ascii?Q?a0ooiEj+uIxZ/7H12qjhVEKCXnKPNWldEmQyvjHsWtfY2wYbx16/Hxv+EvCu?=
 =?us-ascii?Q?bkuzibTn+NbuQfkriPCc9+NT0GdhpD5chF3bHiybZqL8eNv+i5Qds71rWE8d?=
 =?us-ascii?Q?IlW6D7/5rNsTzGG41acjpCe5DMtmiDcf4Y33MOHMM+uBu5BXLH0smpETXfWC?=
 =?us-ascii?Q?f0tj+Ei+T0dZk3lWn86pAphq0CxhsYPhkbJqtU4luHq3HjufXFC9QzoYE98Q?=
 =?us-ascii?Q?zxn+M9BzM1XwWvjEH+3ihKU//nuay3Kn0SQpxnJw09NWAbj7mt1asl4MGgTi?=
 =?us-ascii?Q?7UAnkOpmdIdlL7U0KKaXW6hUrTEQt6T3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4oWzuIdezl8aJIEtBD7gho3WEsQ/3pCFKe06es3wLepPv98V+hIXiqHwRfVx?=
 =?us-ascii?Q?EmCKnO7hHbVVS8829epOfwhi5YWPxUPgag4RrZEnnLHKGeD5i8Sn/Qrqwi7p?=
 =?us-ascii?Q?f2VnXspLPlqV+bX4SjilKH1UUMLzpCGQYL0T333PFgAQ+LjN5q5uTLC2oDAT?=
 =?us-ascii?Q?Mj8QWixZrsf7gw1RzezYMwpTrckQSB0/owgw4L2+1bdif5WQAVHP21ghKj35?=
 =?us-ascii?Q?Zv1cNcm1u/YnFILrOkYZYOrKFEZnhoZgULNUQtyMR6TejB88bGmCpZj4Og8Q?=
 =?us-ascii?Q?KbaVsBDsRN59zL7zl+pVEWit5Zi50bJn62gxbHAKXh8GHcTVlcTSJs5hyJpk?=
 =?us-ascii?Q?sYr9jEMw9gIvkJofen1KKtudTuzEOma+I1+d3MuPH3GJUhRCzt4m3zzzYd/8?=
 =?us-ascii?Q?1AQ7TikoOPDQd3k8L5vTbcN74SWy53oGGL8+QZTF9bgwmCAFg7itWChH6IzI?=
 =?us-ascii?Q?tAI6klMIILOxKST/gruFgAwVHs+wLnAS3vfNNEsO2zNG09yyIQ95INpLKS3i?=
 =?us-ascii?Q?JSoxxIk388ukWlm1TBwPL1Ir07246kLzzYSFjM9eZ6Acps+U7m4eFVmOTxZi?=
 =?us-ascii?Q?qe6W90NBxPJd/3TAQibsb4MGC8Zhlt/N9PRvxVZLr+N4c/P0ANSMVe7TkkI7?=
 =?us-ascii?Q?g2MXAG0HTfUSXbUUGobrr8SSsJHcAvhgVfT+dJWUvWqOfD7vy1cyeTnymW1N?=
 =?us-ascii?Q?NGs2HOcqvgEKMZvwHF67BghaYsshrY9ctf6j0Yj6FK28I18u6YtROaEJvWja?=
 =?us-ascii?Q?uQmoR4ccM8I2VsY12IJ+ufVVxyOJKTjS8bsAl4Eu/zjvNNj8Ji1101iLVGdf?=
 =?us-ascii?Q?02IRJri8UI5qw/TO/9M1ydX9Z9gp8FyQRN3acCfEf++m/cpzyKcj+QTqPpwL?=
 =?us-ascii?Q?QrX5KO+WP5Ir1H0ur5Qm3he7buk7BNGG1JDHK+3A08wVdxDYZmrLCrPaum5R?=
 =?us-ascii?Q?PKJfGXWIu7Ke5HQ8r5tN1K7c8ZdrvaL2u+opVUCbatuiDuTGJgDnQX0/zOk7?=
 =?us-ascii?Q?2k75g7rRQngepnG6n2wAGxOhRw7ERW4v9A0LvkFkXONwEEhvETUm6kRhaN46?=
 =?us-ascii?Q?YLLKte0pts97RDZYuIfzV3/F4Oy+VD9zYNYimLG/Zk4jEc7QIa0FRwZk0bdz?=
 =?us-ascii?Q?mBrNeTmpvsynXsveQkwo5s2GWdtOXdKx7NUh/GTeI9DXNR6S6KUMThOJlmsm?=
 =?us-ascii?Q?mdhtnBcYM7Fj3ks+0+4P/GuFnsssU8UwL3OCWb+mtBfZ9q6tccx+kUkfIJKr?=
 =?us-ascii?Q?DTuqnBh97cG8xcXv8duaXnL7olVbRFtyAKZQ5sC7M46QUDh2D//Gt/lEW8X4?=
 =?us-ascii?Q?+lXr1SiZuJbHj1OdYvyyr+EED8AjBQGQjpMqX7xdyCmcBxuzJmUoHtId0Sxb?=
 =?us-ascii?Q?hZ7qfUsxiCKNZNma8u9J76gvv92Kip1463KoA9quezH+hudBckTh8TkNlKe1?=
 =?us-ascii?Q?3vqOAg+NDCd51atTwTFvolJMupEKQZFJ27jH9y8HHgzt/adlzN20CKYeMx6m?=
 =?us-ascii?Q?UsmMPYj2gJPMidT8ypQyy0NUCnDuF3rfKOWYA2j4Whr5OAnARV7OSdxpNyzU?=
 =?us-ascii?Q?bXD3qF6tpcfPujg/5sIA0Yz7l5fr9FyCPg/e4P00VA1Zk2niBUilsY5YKRFY?=
 =?us-ascii?Q?VwcmD+5bYWHhqtxyPvrxumSuAnqx0jgjn8pMsj0iZ2hTCx6EOPyH9It+MAWe?=
 =?us-ascii?Q?rZkrU6joTu3l1yMBMIVKEjAFt0JVLZ/16RIh7oqO6xsET2vyYO5DgP2Z5H0Y?=
 =?us-ascii?Q?UKko++wJbn3MQoRh5SEySOxTCADlsrs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z1y//fsgOZsOikQAV5b52IxJPG++RApQcc9CR6f9AVutBE2V/XlWim0qKOKXxTmu6rH4y7ZkpETCDdnr30RBizozM9rCVaRhrEEd1HQ/aWQySc4fP905BvS0wh4hhj7aj+U1w7MjLqAb8gJ2MYQvQIE7b9iFxqyu7gd0McZCgbwF/djAWmaXQOlCCE5tF28APqitI6yF80QsW3vGldEkc2r/lcNMW33Py0ITMPfp2al6bQP/1i/HO80ZgveaY88PMUfOLM99h6t4+oDXU+8kYNa78FzcbAV/LXaDNh1Zeldu1yeEi6Dtg4+STS9HLpl/JbNrMncXOCEXnnUtCJu9IQ3jzGs7g5foE1j91YLakXC0VAoCw9/Jjtdc4WjUShMkoHlfLC4Hhe6Ely8nj4SwFzqJlH1vIja4OVWjel+6J3Ib3RiTKzKlSZeCtM445kHKbFhpbv5MdwnDkLXnuogsrBc+/12ciK1O/M/Cn07u/pY6TwIDWLiuqQPRz/Ln19ey3+Qq64VbmW7KbnUkSdwHzlc/IFemSlpo/rhsiPq6wOt1Glh7klA2+K6nvJqykasUUaU7rxPo1LBNLcsFY5ZjQD53scoPEFMZ3R0ieDvealE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6206e132-f6ba-4d63-b2c6-08de4d34f415
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:56.3993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ygGHEYJ8zYpXZ0C9rALl4kGp3ngV5gAKPUQz4mhOH+60VvHoXWrTvVX/jHxfqHj7vVYuDQNhn12YrnSZ5bJZogi1KzOs9cr6yD7hpY2n4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060131
X-Authority-Analysis: v=2.4 cv=MM9tWcZl c=1 sm=1 tr=0 ts=695d249c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=9ItZGrRR58AQ08t9q70A:9 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: EcgPwpdfkSNLi1BgN9jSjFkjw7r2zO5Y
X-Proofpoint-GUID: EcgPwpdfkSNLi1BgN9jSjFkjw7r2zO5Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMSBTYWx0ZWRfXz03qXu5Ka381
 hm6w4xdkHdCr8tadCSq2p5rXUrcE1l7UmDgqU8ZTRv99U4GjYFkNjDo1EBXfpZ9DbmAJnkHzZcC
 JXXrsWDWQi9etd/X6hp8NanfKCe33QBw2NXmMPDOoTGvLU5GPoZH6Kqj+lWL9SrWBScCQHy8dB1
 NhQOVWL7Ov1mbv158Buf7ZZRDbZ3o7KJhrpFcNl6U9KQbOJ0QTHsPxw2HA16aOVKzN0+HMyLKJM
 JcBD3EObACqArGSftMnmIZ9VCki0dXWZym71PInIiL0pmcljYvUUsDEMLwL+CRTRq16moD0bPz4
 v/j43zbjjcKoRHvBX0nmggEA4O4lZxyJKXkwCjTuVMLMrLM5AgZdBnKk9qc5v+wBfJeSXGUfVKr
 ildcqVS9jLCzrvq+Aja3o/fp8tGIdJVWFv2cu0S6HjoM0wd/awQFNW6+FEENRPVcadTkFYzOs3A
 G2SjUXhhlS2iuft8XZP2ykZkYVdwBE/DAbq36ayU=
X-Rspamd-Queue-Id: D665E40002
X-Rspamd-Server: rspam03
X-Stat-Signature: ktahj39yc1hag51hojrgub3cxyfcg755
X-Rspam-User: 
X-HE-Tag: 1767711905-370181
X-HE-Meta: U2FsdGVkX1/QNrax83mgIno3i0+nU1ilgc+Kflo+Mgr6qzUoBnxY9Kgx7f0swVix0OidIQGPfd74UCNPXpu0riFwg3qaervzheVVjj4lrBd7t+l31JmDIoyGvTIB8TKlZDes5ONarNAZxX6t4duHZfJ7T9FafYLu/LY0ZfpcZP4yH2c5+R3t+lRcoYpILE56RcxeZB5v1INFDEHUwLlfubE4eCrLXmlFSplq7jVTUq78LUp8UQ5iuNJQgQB7rBbBEN+J8mqUDzdlFMAalf5aIr91CXScqV1X6Ik6MdQ+LZdbsEee7YnJ/gCjJ9JIiV3ZE1+F3tE1LBrTY9HG57Nx1dhit4vOBkKgo/8ZtrMnDZ0RCO85SpZ52E6OFnDR4TnIDkCYa50Jp2l5wxeu4wA7hUm5hx3+3FC5zdws6kzRP+QUGHk3DuN0ugcm13U3e9j5hipas2Xg47jP9qKfW8PEsbYsq5Hj+0ZiedWh+G4twuNMF9jqsKunHOHZZ6e72IAD4S93rw3JVtdszSl81gBB29bhKC9+2MimyMZFpwpiM8fCLnrE70OU74N8Dqt3LkNE37mHOfPORP7ML+SGsFrWfXQLr1tRpYR0LUFFJU/r6A97ROxYFm1oKI1arVsDe6JcG47byXaIGKsOxlyL0/KDGHHHptdnze/qAEfQUu9DbZJatPUw5m5kdoGW3COs/UjAWqAhaJy3RcID+jdGPTxfkui4iReKt6VvEoVmyjTWDfYEFZ2qw2Y3QSc/qbNXe+wcCDSD5QANdQI4x0gHytPoLl/O50/zriqCUT+yq5WdCN1gsSaQudK6spU70GsuJBRgYpEfcHz8YXUTjHZ6XHprbmm3YUk7kSP7099QBqX81pBHh8ptsHbP9vM1VNiHvZANZEv1dxKwNwTdbteQsWCy6HatH9EqDWjTCXn3F8uHLkSguWZ1tBXv2S1THXRxZPHl4vE/5cKLl7eukpT3BUY
 8a2OC/Gd
 AnQ/PVMDf3stypotyPeZ/4VoBorVGhWvwCrM6OnYYdY0kWRZWQ3Kf14kS8FidJzhsO5vbnUJSAqvxDonYjat1gag2riKiySFk9tHAEDTe08SuZ54o6lmUyOvZrRX6nOLSEt5jVGXGgMsEYx99TzZdg1pf+I26TJDct1UZy0ogN9PlyjnIdz5P3kGIYq+o01BBJW/oMN5HWnxdHsyV3y/dmtR2+O9BBhHhg0aR2mxCCDqSkbdQ50pONZy331FCyot7ZYhZGZd5UyD1w2PyHrlc+PGuhVblItu2hy37PKZjNlhjWZ+IO7kFJI3U7VAwg866o8nDwZFn4lmkLwJFYnFFW9FhyL3MUAYx55gFMlKgsYG5bt1d+s5pi6n/0IVSHCZItAWhy4Vt33OQwVOpmXoyk02cm/OHMJvLZy9fKWNmaPHsryTvMiC9RQiSEm3AQWpD7PZDkV2jyfy1UwoejLAHrQSOYwJ8nXeBtYCXc/9e3pmWnBLt9wWH57gqyJb2AEgUDO9IW7fxJMkmxBnJvsPKTitGMd+sR6t0dO3XlQGOGcQtJSUsDPa381orUA7/jwxprTv4fZEpFt8lULNPkD9AQTZLWVUqUKjGqaByKFd3PpNWBymCdiKqwdm55rxJJNsP0Vb9hCJGShcrgzsupoQmDRfx1jcTpKmVQ2lQQVxAhKLJF8hF9yeRfOtFJ/QvQxfUg3OeG0cJvJ3eRctUuj525C1nQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no reason to allocate the anon_vma_chain under the anon_vma write
lock when cloning - we can in fact assign these to the destination VMA
safely as we hold the exclusive mmap lock and therefore preclude anybody
else accessing these fields.

We only need take the anon_vma write lock when we link rbtree edges from
the anon_vma to the newly established AVCs.

This also allows us to eliminate the weird GFP_NOWAIT, GFP_KERNEL dance
introduced in commit dd34739c03f2 ("mm: avoid anon_vma_chain allocation
under anon_vma lock"), further simplifying this logic.

This should reduce lock anon_vma contention, and clarifies exactly where
the anon_vma lock is required.

We cannot adjust __anon_vma_prepare() in the same way as this is only
protected by VMA read lock, so we have to perform the allocation here under
the anon_vma write lock and page_table_lock (to protect against racing
threads), and we wish to retain the lock ordering.

With this change we can simplify cleanup_partial_anon_vmas() even further -
since we allocate AVC's without any lock taken and do not insert anything
into the interval tree until after the allocations are tried, we can remove
all logic pertaining to this and just free up AVC's only.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/rmap.c | 78 +++++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 43 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 6ac42671bedd..8f4393546bce 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -147,14 +147,13 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }
 
-static void anon_vma_chain_link(struct vm_area_struct *vma,
-				struct anon_vma_chain *avc,
-				struct anon_vma *anon_vma)
+static void anon_vma_chain_assign(struct vm_area_struct *vma,
+				  struct anon_vma_chain *avc,
+				  struct anon_vma *anon_vma)
 {
 	avc->vma = vma;
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
 /**
@@ -211,7 +210,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
-		anon_vma_chain_link(vma, avc, anon_vma);
+		anon_vma_chain_assign(vma, avc, anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -292,21 +292,31 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 
 	check_anon_vma_clone(dst, src);
 
-	/* All anon_vma's share the same root. */
+	/*
+	 * Allocate AVCs. We don't need an anon_vma lock for this as we
+	 * are not updating the anon_vma rbtree nor are we changing
+	 * anon_vma statistics.
+	 *
+	 * We hold the exclusive mmap write lock so there's no possibliity of
+	 * the unlinked AVC's being observed yet.
+	 */
+	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+		avc = anon_vma_chain_alloc(GFP_KERNEL);
+		if (!avc)
+			goto enomem_failure;
+
+		anon_vma_chain_assign(dst, avc, pavc->anon_vma);
+	}
+
+	/*
+	 * Now link the anon_vma's back to the newly inserted AVCs.
+	 * Note that all anon_vma's share the same root.
+	 */
 	anon_vma_lock_write(src->anon_vma);
-	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma;
-
-		avc = anon_vma_chain_alloc(GFP_NOWAIT);
-		if (unlikely(!avc)) {
-			anon_vma_unlock_write(src->anon_vma);
-			avc = anon_vma_chain_alloc(GFP_KERNEL);
-			if (!avc)
-				goto enomem_failure;
-			anon_vma_lock_write(src->anon_vma);
-		}
-		anon_vma = pavc->anon_vma;
-		anon_vma_chain_link(dst, avc, anon_vma);
+	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 
 		/*
 		 * Reuse existing anon_vma if it has no vma and only one
@@ -322,7 +332,6 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-
 	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
@@ -384,8 +393,10 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
+	anon_vma_chain_assign(vma, avc, anon_vma);
+	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_chain_link(vma, avc, anon_vma);
+	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -402,34 +413,15 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
  * In the unfortunate case of anon_vma_clone() failing to allocate memory we
  * have to clean things up.
  *
- * On clone we hold the exclusive mmap write lock, so we can't race
- * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
- * anon_vma's, since existing anon_vma's are what we're cloning from.
- *
- * So this function needs only traverse the anon_vma_chain and free each
- * allocated anon_vma_chain.
+ * Since we allocate anon_vma_chain's before we insert them into the interval
+ * trees, we simply have to free up the AVC's and remove the entries from the
+ * VMA's anon_vma_chain.
  */
 static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	bool locked = false;
-
-	/*
-	 * We exclude everybody else from being able to modify anon_vma's
-	 * underneath us.
-	 */
-	mmap_assert_locked(vma->vm_mm);
 
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma = avc->anon_vma;
-
-		/* All anon_vma's share the same root. */
-		if (!locked) {
-			anon_vma_lock_write(anon_vma);
-			locked = true;
-		}
-
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-- 
2.52.0


