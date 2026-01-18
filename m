Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B182C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 12:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27FC66B0005; Sun, 18 Jan 2026 07:31:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DFF6B0089; Sun, 18 Jan 2026 07:31:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105106B008A; Sun, 18 Jan 2026 07:31:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F16AA6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:31:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC80B1AEC4F
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:31:56 +0000 (UTC)
X-FDA: 84345021432.13.CDD4306
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6D2E080004
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:31:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NKRJXtXa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GdQ60rgj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768739512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyxS1pH6bjjE6e1sJk0eS1CMjPKbqZUN7CRTdziRoZk=;
	b=ur0ICUJ0uBHBUbeo4iSIe0iBDtrFCpQbwz98xnMyJBmVy0R4acXZYiX3T0aP6delhD8FbQ
	YofRzbllUqUa+xyRhICJc7xiUwXKTe+lEIBpTqIW2tO07fCaM41LorX3ybq+nfd1hVV//7
	V3XWglpA4M8Ai96VD+Fy7p/HxaVTCfw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768739512; a=rsa-sha256;
	cv=pass;
	b=Jfd3bhlJrA6Kpg4JL5uMe2TG6OLp20kfEKfbsrUIO85jIUMs8KERacIagjbYMGBzX8yhx2
	WojXgMQXwaxZDCF2TKkp+6M1m/rod+EzPrPTFzN5ueXSUfyzn8xhZYlcWZvkkSwpUHX41i
	lqs6fYL9JqZAZnNzXKqdcfKKyrddYrE=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NKRJXtXa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GdQ60rgj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60ICUsm54133519;
	Sun, 18 Jan 2026 12:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lyxS1pH6bjjE6e1sJk
	0eS1CMjPKbqZUN7CRTdziRoZk=; b=NKRJXtXa4lkZsKQ8ZgPr5PFBsf6/rX1knS
	ir472KYpHOB401pFtWCunXEjzyozQd+9OAqClREDrxrhgtD0FAw88lyhZSuR2M6e
	cy+x4ewYHCwlVwT8yDLfaFSJGqJgIHX4FsBCVkMq44FG/xZaRZKImnQTxlf753rt
	9G9YmJJJRVFyVF0Xo7Vvpwb2Am8cm+vkBIjITBDisOFT0kHyTwKDf1UyuaI/4Shk
	RcpbBMrCwshsexWC7qPKdWArB12FZwMYU6NLTVibBJI7mAGhSWOP3JAO08x30JM0
	5WoHmOwgKOoY8hIgSOqpa6IfKJPuDD09HW17F6ytL0y8JHiTDd5g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa19pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 12:31:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IAJrvv040601;
	Sun, 18 Jan 2026 12:31:47 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013018.outbound.protection.outlook.com [40.93.196.18])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb5d9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 12:31:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=le5lr5cSLjjqs/C1o+8Tzh6YZQprzmUNg3670K8bLDsUmoEKaU+LO3b3MVA3mrNXYqZlgltjBAJqyhWVNLh70VGdhiqEXtKV7raZUVdO06MpV2MkXkizIY/of8nT3Jc32EePjWlLKMq6bO4WYAN63KtyS7OoNlqwiXtTSrWi7uFdiEwHDGxReUb0a4QxBDUTRy555DlBZzO9Tek+D8YwK1ffdFjM3IekKKpg8A6CGD1vVYVN18GzoAMVZg7z16W6l39kqhNMnOYWffDJPi7rKpbMLS5VXYbi6ZnrXOIogkJKNtcbgGmlFY33o6IsJEex6A/AIcrC0tne8CvP3P6Mog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyxS1pH6bjjE6e1sJk0eS1CMjPKbqZUN7CRTdziRoZk=;
 b=Npe+SKN0f0zpbcfSIRlxcyCCfIHk3U8rczcJIlKBbNahjFc71bzxOTpI0idZR2c+E0zh0fWlaZ0NJipqZV/s5DS/rJNmFyHlbCMLOgp2FyGnc+rPXk2Lx1kH/u79kGlRtZ3JFYJHhSqpOiJXfqsp+MeeDwwmeTaqGavN35MNNFDNWOurhlC2mQpljaS1URrR06SIBlIIEdvdEBJJygX38Hkrs7OVsMc57Gx5/N5UruKE8zX3kkgzOjr8fJNtzT9S5jjVh30lxDlfnokd1w6xvAqJ4Kcja83NW8CCwQl+EzyMpsIJOYvg2i0ls5uMsximmcP9cXq3gnpcpXcaxfU9cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyxS1pH6bjjE6e1sJk0eS1CMjPKbqZUN7CRTdziRoZk=;
 b=GdQ60rgjJ030RbNNI2PJe1sRquHztOSHWU9U7ndAnvgjCCkCsgC3P19C2zah5sv3aMsHnxFs5+YDFiA/waiCi1JO7JKWPvbZTxTpR1Of6heOStW+rmZhvKMqtE+wV7pAwypXs9CV3dHft1UeWypltbrsfujBr8tQSyg8N75+j+M=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CO1PR10MB4643.namprd10.prod.outlook.com (2603:10b6:303:9c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 12:31:44 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 12:31:43 +0000
Date: Sun, 18 Jan 2026 12:31:47 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/rmap: fix unlink_anon_vmas() handling of error case
 from anon_vma_fork
Message-ID: <026e2cd5-84fa-4f14-83cb-d6b49053b7ae@lucifer.local>
References: <20260118105817.1270617-1-kartikey406@gmail.com>
 <0c632df4-7128-405a-bf92-083a335831f0@lucifer.local>
 <CADhLXY5pgdUP_o+zZJ0mo+kN+PuFY8E1WDuxS=M0+tuhta2nzw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADhLXY5pgdUP_o+zZJ0mo+kN+PuFY8E1WDuxS=M0+tuhta2nzw@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0038.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::7) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CO1PR10MB4643:EE_
X-MS-Office365-Filtering-Correlation-Id: a12f4205-9972-4287-667b-08de568d89b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xcTF4Rnm2ktLoacGZlr/7bp/yf0ivtwurse/pr8kjdTp15YvmP7hnr3ZGU4Y?=
 =?us-ascii?Q?7MRFXh3phl8QJaJDMHEgIRCKlyb7g8EtdRq1JGAg8REXrMUXiWPZbNovPJ/y?=
 =?us-ascii?Q?tjrHycE9Y9zaD97/H4cKyLrvKLnlr5NyIwBfG+rOi6i9YyDh1VlJC/tCbPCP?=
 =?us-ascii?Q?EjjHyeSHzqyA54xIoPeEk5lMS2SLzPojI/NEauDI504HDXbkAFz1BtxgAHCD?=
 =?us-ascii?Q?f6DSm6iLQaM0wKlwuhkjj3XaTajsoJBEbll3XMcaRrwAqVSiDagcU7An1rk3?=
 =?us-ascii?Q?tPBmcXpvjHzJw9hCSNJwNna4BCIFjqf6Whhc86K67NpsJUmf8VeyoZbT8MYd?=
 =?us-ascii?Q?DTpJTgV4Lln5MR5Ks+kwtFa49zFPPPXKU6TIHUXNsdpT45pGJ0Oj099bfMyv?=
 =?us-ascii?Q?sHiKpudA1/MBZfQbnBmZDE6/iU59jhgBYZMUxslL96siM/6rH8JCfUKLMem8?=
 =?us-ascii?Q?KdfQtUoyNfYkc15ekQUCbTO/UWzjA45409JWFSpXin32LnJKbxA2ksa0SkMo?=
 =?us-ascii?Q?EcP+FZ2D7sOQcOuevuUUa4W4nBxqoqEiVMwfbc9mzvAY0I9nPR0PDt+v48eU?=
 =?us-ascii?Q?lki93ZeLnw6phFwTy+FaRZoTnSBP/FSrowvEjYkh/zBvBYi9UnL5BIYMOa3j?=
 =?us-ascii?Q?3iWP3coQ69n8kM8/PM1vOWWuJ6HLA+CcBNcsbcn8OTMtF3U2/uF5Vu81S+SP?=
 =?us-ascii?Q?tctNmTh2rT9KjbUjQZ5VMQzS786JI+a/gaRhzgXhceeh5HKoY6Toh3FcHGU9?=
 =?us-ascii?Q?QQJUPqhokLW7YmhTEJlNflK0ld6MX4WpzO8cbd7C10Y7IGfJW+jagfFnKfHF?=
 =?us-ascii?Q?p7V070+s7Ip/3qHhHxoSoQbiho65+BvTlaHE+1ih7OUznP+GSyTmkaG0i3xE?=
 =?us-ascii?Q?SIwh8jDa787Z712hraglPDR6mbs/bFdIcTYtrfz82L/NL9Hff1gQKkExEEfL?=
 =?us-ascii?Q?thA0YrWMnHK3+vwOehBBCOZcyk4mNQ+E6hvYqZzCfhc7g6o5YbzkpRFuUKCX?=
 =?us-ascii?Q?qsMp30IfuJ3uVsa+7lVeZYKP+IzfUI9Q1xb7JOEAg9f01BLdP1DiYdT1puG6?=
 =?us-ascii?Q?1xWwWQvfkMkTMeHwVmT0aVxOdYzktxDpmwYrLubJ1CBHCcxDegt6ncol37If?=
 =?us-ascii?Q?AiUAmx409OAN+6ER+UNL4YzBHXhwj4DgnOnxW41lWyIJ3uyGFYCJp0DuQGCd?=
 =?us-ascii?Q?t22QvAeUgFaAwmXfjrdCJZrtYgdNwM9I01KpsQWzicRz2tqtdSeMvi6P0ysB?=
 =?us-ascii?Q?MOmv0qPzEdcCXEfptszBV/ajx3YA7yBlwCZFtRvO5SYO3fZI0AAqJgqCubHO?=
 =?us-ascii?Q?IaADPWS+FPhHFAuFR72xWdsDS8BwxrTShch09VxdU9A+sR5zEh4kTwVpc6jc?=
 =?us-ascii?Q?4YOuv9QNKMLwm4XfRcSFs4+XTIyIpfj6DvM8cRgurKNC9+r8n8tZOHF/E4hm?=
 =?us-ascii?Q?iN11mY6iF1my6bXkZCFS71V+az2X2wJyNLZYIw0LVZglQi1zhpHEKZmfwuO/?=
 =?us-ascii?Q?+uUKq1JlVxlWY1m7bPJc7t70+4+qJs94a0Awqh7AwiQ5ljXu4CoB9dGg0mNf?=
 =?us-ascii?Q?vGTqGmXWsStAGI5t8b8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eXN6ITbg3tScLfK6IS5AG1JCtGkT64eby7IWpYZ1Phe1n/t8YYmLCrMT9sel?=
 =?us-ascii?Q?Q8v/d5DanzlIVio2NyLncixXFPl5HeHqTjfKbi4QCXjYC0OocYptEtCDjN0u?=
 =?us-ascii?Q?3hfe1f62Whyj4otyhD0gPDC3h0aRkVNPR9VFV97W8IBhL7t1vhGHW5vzSCj4?=
 =?us-ascii?Q?cWm6s1CK0vmERDL3rlnwPGcKfDoGZH8XIRdpgco5Gi+UIj0LQhrwVO8YbUJG?=
 =?us-ascii?Q?r6RqBIjtFOCJMo8/A8aDDKpJ6mnlY8ntVA+B8hMpU2+UAqnjNY3vFYqD8oJ8?=
 =?us-ascii?Q?aPLzAIVYonRmWepAN11Ab/Q0EwpPqWyFa8gHVvUTDr1GbEzNGKdMSMEFA1dh?=
 =?us-ascii?Q?9LKRAzQvHqMFbn8MNXVQuFui2xgd9YIfA2NdNmGVtodu8J+obr79KtKAZerJ?=
 =?us-ascii?Q?jr+Rbit2YTLIhBnN0UyKqoZozJOSUrxXsyQuu80dDWOgX+2dyi7WcV8WWRBp?=
 =?us-ascii?Q?1yNi7T4GCu0Jdwc93BxSrzrYbgUkQV5xhFcjrLGotEnH59mp3vDI5bpFFp0y?=
 =?us-ascii?Q?Qtf7ZOvnNYCQEsqcdBLSEfdnuNkxYHKvqL43bh0X1f7rU44GNcLBEZIwzkEZ?=
 =?us-ascii?Q?taIKeBYH9ntwXYfQGAO9CIDoxmtjcU6L55xlwymTLv0QbLuGXAwOxv9DjYJN?=
 =?us-ascii?Q?6K+p2mXo64UPoHks21/tHgky4zRI0MRsU1i7vHbiGbjch3/obvePwPD5JQoA?=
 =?us-ascii?Q?dOxdV8tQY6yPyYtTkpapU3oTiaLeVU2o4BRVCMaoiJ66Y5LYLAalyaRV7ASX?=
 =?us-ascii?Q?lxmPxai9rOcw+wZZmEQGQPDQJZGvUFlUWnh1/8connUoYhTyPWdOg+A9LhEp?=
 =?us-ascii?Q?gNVWJcrrVawZTo5LOLfZl6frAOPOJdjTUFRxvLm4XExZNzgVhI5A/P+xqwYw?=
 =?us-ascii?Q?BAVl9LC4z+8v8CEqsDGsN2JI6YbdXKKzhfZ4JQ6b1fsn5efGmgl/0ShT2Xp5?=
 =?us-ascii?Q?gbI5kJUtbo7RG1LMjdg83ubLMGeZ67IiynRz67mrN2T4Bvgv7AjsR9r8q+Vd?=
 =?us-ascii?Q?ljYBBEsGF6jCVDgHjqSiYgJDmB8KkK8QVgaTIybzQSXDuR1v1+tOo8Z/QR3y?=
 =?us-ascii?Q?PFTriCht6sCO52iajRqUoY6TOqVj6CR155x+yypyihhi9iz0fkWsrcT5JN/2?=
 =?us-ascii?Q?do5yzv5Jayif+/pJ+hqF9WhRONXpB9ZugjAi/j309OQEM/j2yK6ysj9zPCZq?=
 =?us-ascii?Q?Ofg2LldUreQZrbYksGU49b2WbxBd4sCI5jZvcGGVHdnQTLGHRrTlVt19ufb7?=
 =?us-ascii?Q?utqZ+ribPnAvQWnBoZarS8ZUjU+LMkhvb2n8jHO8KnawW1VPQItkpC3nNSLK?=
 =?us-ascii?Q?gpLp4nB8TiT8PGsBNAoV1MAfwlH/Q1/ztzVNisSFYdGim5B69YTgkrSmnmcF?=
 =?us-ascii?Q?UtGoVZ4DOgehZyjDmjexTd8xhRTXw04MqkioNLnHqYD0pjG+9tli890WustS?=
 =?us-ascii?Q?En2PkEWhxE+N0OEp7e3oGUyzrzoAU5vwBDDU5fthyCyijXmx/yEM54tRWiIb?=
 =?us-ascii?Q?iRua5Egfx5PXxPJxIQy9Yevn/DSz7d6JJ08s4IP9UZrGUNZLGM901+PRlmUc?=
 =?us-ascii?Q?UZyqOLjCT9zeG2A9/1zFjtrLoXxjWpvv1wnFG1DdHb6f106hVPhmPy1rcM6D?=
 =?us-ascii?Q?qKUOsXugsdAMhqLzqEf4rPUjSgqpVlLEDAGrXeFqJwzY8Z+pZ9lJetrrdQfX?=
 =?us-ascii?Q?P+7jVpGL9YwHfDIUdOH85gAjh5tfPYVUD9KohnEsa5h4jaoB9M0h0rV0LufJ?=
 =?us-ascii?Q?DlMKxvKlfwKJsHlyKozLUl6DTOp5GAQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R7kwhzZ3AZRPtvEGdKEwpgqi5rBg7X1Ctao3AjbXiRyolUPnmFqLQufcQn9hIqF4ws7BUhNRSoRu1VbHcBQ2MoSV13FofGVzmMvDUSAJVe1OvXlCVcgwi2DLKqevw/jytrREwhmCx/I6T/0doWMn9ddntxWSHJBO4kQ3d9J7gsd89Ksw/g5VLcaZjMNOm7eTAWu/cgcEIOiytADmVmx+l3VT0GADCWiJfI/AU8a8O7Qtb6R1QohCVtH3eeIhi2XzcnDlx42Q9rnzKu5efDw2a53yuwRb4aruKAf5Bm6zsLPXsaj8NcB4q0TBdvou4EjdK8axwhbqdJ0qWr3TzIiemvMfDQ0/llDEHZkSJKBdpr11QBr6jG11j8oTZFeKY+WT+wIJZ5xa6YvFv2Em0lseH62pdu41yDqm2eo7bSWxnkSjAXpu1Q3b0043/UV4S86HA0K/1yvn3enlev1w46YPMhlYLeyEFIEpFG4N1+VJZUQ6nFUvADMkgrBGzNGSJO5rHnxEheJVBiN8smCZSumLGGhLrWAQMQyxJknIEQvr6Ei7LfVAkpQlXTrcmJDKSa8X/y5ylDYPk2eTqfggottJvnT4TXXr8q4wZOxV96vMGLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12f4205-9972-4287-667b-08de568d89b5
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 12:31:43.4612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2rfiMDlva94Hf0P7MG+9PboMX0WE6lNHenfWZE9Qoo7GI97rXGQ1KsifYHogP3NESRKaM8EhtNbKq2BpsTq2tiDBYZb+bD0X8uFf4wVpSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=817 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDExMCBTYWx0ZWRfX/kf+IC3o4BW2
 iPPk3DpLzzqnsrIN1ousBsA455eMaDvHuCkLUnHEymHzURPqpOjXbwQWUaAIrlX6im1LFe6lMHX
 pDgDBc72UijPSu4omDy0Af1GOtI/fBIH/bp9EKPFHay5KFKWN+W1btGTwgkhyjFoQLx5OlPSMb7
 rV2gJF/Iy4coVLSPLQIHRZHHbgF1tYwpOp9PGQFc0Toc2K0Aqaez4NyaWWUD8Ov3FeKHxfwhcoz
 ulLpC0/OkrerodKgVgpOFZ1ehstTSBjh4vi0nQggAo58TcPy5Jgn5ML82u6UC+5DKzwR5MGPral
 WP4wbiAil+3r0aD5ZDUqjpsyAl65lZsIgFgCCfO26YjDyF5fv74mQoJ4fZ+Wb4iJTWwQ4rDmjDg
 XXJaeJrNmK69oONgCVel69YI+LYR5nsEnsYtF4boraguHXCcR/N83oXoypxU7D3o7yj8TMUm7rw
 T63nRhJ8fSp2Zv/f6zrWq+paOtamPSyzX1j1Ah8I=
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696cd2b3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RUhJ0nmI9FHetXxDbWkA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: jcYNESc1i-cvhF2ywiL7sMkS_8aMJDCC
X-Proofpoint-GUID: jcYNESc1i-cvhF2ywiL7sMkS_8aMJDCC
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D2E080004
X-Rspam-User: 
X-Stat-Signature: tro181iio9nimgkriguyqmjb11na77k5
X-HE-Tag: 1768739512-966568
X-HE-Meta: U2FsdGVkX1+WS1XO2umRpZicJl+dW1cUDsghOCOem3F8t5AFZd5JyLRls9AvvnZEeyaeBiWUsrJAdRbNlU6lrXlv88PHYprYi9crqEHxr/xOo+L2/fDT5fnrr9hQ3gW3t7COPzVDeKgK/Yly+Fj5Z5sSQsftQ46Lr/aHf9F7tH8fhEMiTi3ek7XbdjE2V16URAypyMrZJ4dePhQS8q/Mx0+W23Pj4GDolG4zRlRxdlTjmTxsMAVfAyLKgnpElCumuP/mXkHIztmD3UtInrbAX432sz/Ua3lF5NKQ1AkLj3piIFJjJpPGgVs8fN5PSgOdwipzAhvR6EBaNPqLli+Hj8ogLpl9Skeds0MfWb2hXuxf7I3tNEnYnBDWOjMmpO9JrsAPUnw6ropSLz+wG2hk4Koc+ZuQcjSErNfLaGmtjKYoymWtEXhcV2k2ZwCBIHlz/+QFJTn9S9oqrdWp9z0+84MqQvRW0H0h6vrNUPeVO0Wiw74a2LP6xfAQEhMI+hMbfuOSLxbKeUui/Z9+qSxWbfygBC2+1oze591/OhsQ/QhvjGmyacXF88fCxwpDADxAyp/5Miveo+FeHMgQez3jlzbbmopmczUG+gS/Rros2ZodOcQL1I2hmtAIvid0TUBCy4v+VDoKVmuUmx21lV6a/HhWTMdjm9HIG6SCXlDxAQoLHig/gWBhNBYV04rcZHHf3JRORHhDB2yR524UVOS6tXYqVBKH/H/Law+Bb8Sn2iDlSFKvY1+UPIQI6nUV86tUkF4i6PsSggxP3dNT8HC+qbbyo8waPKL5eix2ZxgKIDlA7H0fndKATvxmTMqaDOScwCcFpZKyj9f6Rvwj9pfOL9M5fRhsqPGbySFYmurUoRsp61Ka94q4PUJhM0O11vh1w+tCbLfL9BL33vllPn/UxP0oowL6n27Je3HyqMsYPzuPJRohsKjGx41i8p4qQgKycd0NZL0vuaUumoiioXS
 skZYouXE
 5pkW+ixDrcVtdVQGcaQmmJ6Ddap6V7Nnt1ITfwl3ZsVPZUEulRun4xWPaQ39m7wTNHldAoiWRg2bjatumXXf1WCELEBimzf7Kjcc16cX8tnCyJIH+w13PWsj2LvuJCRfCRhcjddzxkc0QtAC1rmMvfc2qDps8z79TYdvrgDWt92xfb9ePT6DYNOV3DIX7JdG6TC1vC9tiQXFidPEjYXlr9WKyjOLtjMEjSP8ieZbCxoblze3agOPS2jcgwLPWYByfEsoufHb+FpMsOWOBaLYcLgpNHrD7y0htKcZq4/25Kg3MMh3TioownE82pDWygfMCHtADJNRkjnIS++MPKmQG5tT0gvG+AFhvm6Th+Co/lgz8D87eVCH6MdxzYGaSEKF3Eu5FrvuWnawhjXYXciT5vRqxESpVTngU+klZlP9NinW8IlpjtEseEjXK2vybyN+dZSu5w1Q6FtCcUJfBbz5pdVudZlSQF/dp+jYQsx/cSHCDxnuK3VEtA1kWbACAJywKDHMpUgQUa3Ku75ALeN3dSpKN9AN98oDbNcOnMTJ8T7d5T5Be8Tah1ZC/e8LlWvqsHJxwPqAjUXZzsxDCPavBBy2UUco44SBdeguNV4/I384a+hQED3Vgxnn1jFed+jamoygDXTir+usIOhUi2JcRsftt53+jo1GTYUwTAKTzU+q530uut988MC4ZFg38brhibhqKeNJ0MixLuwfOieUgt5etJS24seaYN8xJSC0XlDSXE7uOG+rKdVzHBPeX5AcpxBhadvL9H+5RxIk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 05:54:35PM +0530, Deepanshu Kartikey wrote:
> Hi Lorenzo,
>
> Yes, I used  AI for commit message drafting and to help
> articulate the technical explanation. The bug analysis, code fix,
> and testing are mine.
>
> I'll send v2 with proper acknowledgment. Thanks for catching this.

No, please don't - As I told you in the other reply, this patch is not
acceptable.

When a patch is not upstream the appropriate thing to do is to comment on
the series.

We rebase development patches before they go upstream, so it just makes no
sense.

In addition this patch is not upstreamble as-is. You are getting at the
issue, but you're effectively undermining what my series does with this
proposal.

So while I appreciate the report, unfortunately this is not a patch we can
do anything with.

>
> Deepanshu

Thanks, Lorenzo

