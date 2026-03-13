Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434E5105F79D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AFE06B0005; Fri, 13 Mar 2026 07:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E8E6B0088; Fri, 13 Mar 2026 07:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B6C6B0089; Fri, 13 Mar 2026 07:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3B676B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:54:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42AE71BEA2
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:54:14 +0000 (UTC)
X-FDA: 84540881628.05.6D7BE63
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id CE0C3160008
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:54:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FdYoS7oD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U9RyShxV;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773402850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2/XuWtHl+ffnMzaizyYQUqW2NIrOFMVmy4UUW7Hkuw=;
	b=XUIt7YspiOfIB5/hXeLkqaym2VQTAWM3V55SKXoLhhFti/kAODW8Nx8S3zbmrHq08mkB3r
	mWzZU3fN21XyG0RlKMfT0B/AbqtMVMGi703zwn1lnVsqGEGdtmjJDUEjcsVKL5247eRMIS
	2KiGvwiVZSpxC4HNPJ9idBvbEtbAsaU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FdYoS7oD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U9RyShxV;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773402850; a=rsa-sha256;
	cv=pass;
	b=DLZ7IiW1KDGvlnI0l3aNOieCaqypHZ3YVZbfrnjTJC+Zx6V81O1i8MjTh7TLj7t1CbUY5A
	Z+Vh9NFiJem72MRZ/pmhEGfXkve6mTr1utmpCxVkuJ/ykqTj41uLo7aX5ICkdT7p1c0dm0
	iffLyySsYz8zXxc2DDJ5rGDBHmevGoA=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D9cTnG007237;
	Fri, 13 Mar 2026 11:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=H2/XuWtHl+ffnMzaiz
	yYQUqW2NIrOFMVmy4UUW7Hkuw=; b=FdYoS7oD6ys9VD3inIvdOZS0+W3LP1faLT
	OUKnXdf5mbLD3MHuB5mIo236XKNhX42beO30kz0zBJe68Chb6v3Qn7zzsoiMXDqD
	+ZeVFHileCdN2W9Xkr7xmW3T2V9vVaunIPtdokAGrmzW0bHSewu84X8ngNm93CJI
	5THFyzuBMdXRIYH0/tfIEImf72yG1NMVD8UHYk+ytkdOdGfFXw9xYQXZspPjDzbT
	YBoxF2cscTgVjzatvDyS1/b/XoF8kyGOzJL0oFmhDoL4l6SyMtGahRtr8/QOgiNa
	RtyoDo58NkQCd1L3VmzN3StnW5RMI60d3CJWjmDM51esKMJmiuMA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvg42g4q7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 11:54:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62DALdn4024588;
	Fri, 13 Mar 2026 11:48:34 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5v3cck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 11:48:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DAiGRiBudpKU6N6y3oQl14CWZ89lAtFjhW1A8+wRj5SpagbXko03shv9JUPimq4Ow8OqsixJQ4PF9UrIvvN+EGYc+R2arQAO/N92FevJdWfGfQq1HqEP1H7XE0DIR/XbWMmF8MZ5m6RNCvh9hpof+QlaYTUEJ717z3QWlvwxCqYpvWrHyYvb2bgRdSxPi5JkkqKnpUbuBhr0kY+SdEFPCTAzzm75OlUmuOrdqaY/Mk9B9SDRORmVlCMqVoI5/kd0apEv2LQlYITOX9B6LzRDkyT/6+mKQRDN1jqkOj+nrhNF2jVYcOtfcs1x3fQIAMeutlI03UmwQSFphrWF2qYJQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2/XuWtHl+ffnMzaizyYQUqW2NIrOFMVmy4UUW7Hkuw=;
 b=bT+o8NwV1HehGTWxBx1A/lbFwL4K+DzB6z4+jVV2D8adsh5YQOu0+H44EpDsy9SkzrTVurzCpeKwtYDctkIgTs70p0hGmKfODSTiI+AprNXySoClS0MWnEkbrorjerS+OCsFEuWSXw/+xHLX4T4xQD8Bbt/idYrX9y0ZA+NrxwydqAzmtYHQH+tGHZ+jXdnuPln3Z+KhmEPluOz/wZzG9+AzAxY2nNahfV3TwqTqo3l3ndrSHTRuVEV073cTj/oS3ti2ILTedNWyGtLDmjvvVpei/ZcOnFRipOdzqA0Pk/KQPTNfbJv3tJuzefTp0ILBROXYSVPmjq7jzU6HWsBiTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2/XuWtHl+ffnMzaizyYQUqW2NIrOFMVmy4UUW7Hkuw=;
 b=U9RyShxVJtC+GI9eVrvQRXlX1VDQ2KUonEST7RAGV0WWaVWhUz7h9Z+6chadpHLSed6+PQzZsUoGKfOfTlrf24Jhq1LZ2C3Z2bxWaLwv+NPXPZCCZAGikHTzocRwBpTrXSOIoxF890uKTQBdGSIWlDhaD1dM/RnY+NeOoCrQKKI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA4PR10MB8397.namprd10.prod.outlook.com (2603:10b6:208:566::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Fri, 13 Mar
 2026 11:48:11 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.017; Fri, 13 Mar 2026
 11:48:10 +0000
Date: Fri, 13 Mar 2026 20:48:05 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] slab: decouple pointer to barn from kmem_cache_node
Message-ID: <abP5dYLqkJrOYDQZ@hyeyoo>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
 <abPYaocgFylosUCf@hyeyoo>
 <94d89d84-c009-470e-a401-1ac75228cd92@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94d89d84-c009-470e-a401-1ac75228cd92@kernel.org>
X-ClientProxiedBy: SEWP216CA0077.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA4PR10MB8397:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c81f6e-227c-4550-152c-08de80f66691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2OKKIEMNpjXLkR5N+I95W6rD+E1GoTcupF0yQpvN/o+Wk3wNvhPtSTWMCKmtNo7UcskJd5JngiN9NNCLzODIjCDVhFB4ls+QCBjHHbAfzJ5nvBb8U8rT0UTjh0SZU9VxqhKfz0/lhBTKBBIFQem4Cxwz+oQewM/s5h58dJ8l6sYEmqOXWSYTJi+GJIRFGCEmc9A4OFwuOrNJxgCFoARNKtIA/8EIhfdtIU/KZ2Nnp8t1G3hLBMLJ37NlozDQQLICJQbFynnAoDm1MKIMf8VfA9k3Hv41PTVr6J6wMOWZdrPBvZXNdHdondkTgbTbu3WKOpG9azqow4Rn9CCHUa1NIY9oLqs2diWkxTU8GdroRCQ4pnz4eXpbYjiarwRjA2YkrvigRuSIdndDk9mAXzxw78S7zdTNcgkTOh8C20tQVBLDJmj2k4DPttiC8ljMRyqwuzVA0AI6kgvsfMqLgn+xfjSmEmW3OJC6Jlb2WFsF6PfXWePQ1+GukEW6lfdj0Zj1G4M+CWrD59BEOTCEqfOSJd9Gt/g/gIJmm4EkMVpMVOGb4SPMAm9QlJkOzO4eK1J82CQDJPeyTmwyUk588/FdrSgIoo2FuryS06KoG/phr2uUzcGwO1QWbz7XkG5+2wfWdX/GRkRV6R4qoIccZxY9P8/5d7SDPML7FZUI3lzL+Q/ktQ1Cj8paeJrsqevrle30qNOFn2xyjfEKDzyY14xJSssgBmdRCvwfO+I8CCv8QAg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4zS3Fc6MyOewwKWoboNmtpr3soiOTTbl2UhYs8USqZvhcC5jYwDUX7vq0V6q?=
 =?us-ascii?Q?GllUpbNnt0tEXwoLA470aNkgj0VOOpEvzoPFKrttWaFqjzqoAu73Q6/FGhpP?=
 =?us-ascii?Q?ADWon6sPTIY3D4QonJxPFMq1DAPqmvrUACAgq5Mq43DxWuZV1c9CI/qsnRmM?=
 =?us-ascii?Q?yFwv+DT0KjnhFLDpLhS+ZECoA5ogSfKz05KLRrGDFEx7nbcaGfw4RdIispjh?=
 =?us-ascii?Q?NXqPOF9yabKmD0yEi5K7PR3X963m6izKLc9BC+nGzwIVSN08aZMUKSrm/gzt?=
 =?us-ascii?Q?x0GQMMLPwqH3b/zKKT+2KzI9+uqzSScazMdvR+0H5xIt+U+szIw7h239QqJ8?=
 =?us-ascii?Q?YWT+xkvLyTeEgMGVNF9FPreIZTkA2DD0C5CX3Sou0ona1F2AgZV77AkoHZ05?=
 =?us-ascii?Q?b8JszgAmgEP/4PmopIo6X2b43j5KCFNJuYpH7KXZ3ovV/CwIp+noBpV+WKZ8?=
 =?us-ascii?Q?plu3tG7fbJGpn5AONqYE7TbPWJIGNfW7B2FDp+mK/NU1ehjpz4WVVT6kaIqc?=
 =?us-ascii?Q?nW5CKi8m+OVHrT5JLB5PwH8tnl92RHopZkwcn01ihR3Mb28rIBEHb0AHUYFY?=
 =?us-ascii?Q?32RgCIA6VeKoQwFTIc/Xzd0YbZKx04GRWtmjjpfiELSmMBJimNAmEmqszFDe?=
 =?us-ascii?Q?WiRRQL9ff/ql8wovITWVutyBvh+oNv9DDer4iEFs8kKB97eO5IQyqKihMPzB?=
 =?us-ascii?Q?BpEJGk6M6FFqvAZExlm0GU8yxsBIUhSrMehFf1SWp2XaE9in9mB2p2VDJceW?=
 =?us-ascii?Q?pQQlMORV6SW7Yem1AMMoztfOWL3E/YCu5U1kX8HQGcJNA6TQm2l5ZH+qHhU1?=
 =?us-ascii?Q?CoHGO/tJlC3T2K9ytk78q73eiDXGEivSz2EwZ+TvRv5Gd0tgzrGGg5yUPug3?=
 =?us-ascii?Q?a+ytN93ps6fuQ985WxfCORYbijCe3jY2Yn7HlveeNuhEtMC762Z5nvgwa95k?=
 =?us-ascii?Q?Ns8p43AzrNojwnf7XPQglmwF1iv7rz6IwLEzDJ2M+7M+jLtouzwr4ndwIrNz?=
 =?us-ascii?Q?+itpNSeRXCyuWU4qRXI7XVtuNxcRJEUoiLQfsF4N8U0IyxuNJLTIp460/MUQ?=
 =?us-ascii?Q?Z0DvdC1lxsYqluSGS4pmBzqKpvhLxvVvo7ZzDB6RCcE+zGChYlXWBHC4DyaB?=
 =?us-ascii?Q?mB88uz6PnoCoHcnJSwWFeotNmVTvbPGljtE5lZ0cAAKyxbxGLrmTE9d9sazO?=
 =?us-ascii?Q?EOLGnNE3TmMZeJ6rmWYN5wiSoA2FerHFIByMw0K209eV1OvDhJfTOQO6suSo?=
 =?us-ascii?Q?/NSeeh4VkOOxKtFWdJb+gPMbovB2sWPTBQ8oKfeH6+HrSD6R5eFi9U4PhJjZ?=
 =?us-ascii?Q?U0/65QN0GBtWU9wUrC1IyuolUog7ul+nfUtMu4solJjEMyR3PStBxnby9HSD?=
 =?us-ascii?Q?T+3GBlzqlUdIEwWa7WEcchcFTeHVS3T3DEdJgUt/wlnJBo8xXMVhMzaX5rh0?=
 =?us-ascii?Q?no1uSBfp12c4I2c/H0p1jyaeTCtemgXXTNH8gmTN4tJs9H7/LERe1uSobDZc?=
 =?us-ascii?Q?iavE/meeGt5vO68Xq3e/gjVysB0HkdBY0hPNrPuQKu0/bQn1GzuN2TqPWo/h?=
 =?us-ascii?Q?HROf4nj4nvB8Hpmz6o9abz2zPe4JSG5EuYMmk+j900ojnZXbkMwge8BwfAuw?=
 =?us-ascii?Q?pN9UgVOguBR3/PuGHToZSkxlPOhbyVyM92sj0LCLBKbMY8QFJ0/ffINyTqqB?=
 =?us-ascii?Q?tQcyw6rssUCdVJpsOhxwS1miRO2JaetGs82mlDlguyI5Zt6P+3RSvrue3ebe?=
 =?us-ascii?Q?s2HfatH1pA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	RD7Sj+MJux6RgegLlZjjpY1bvfxSsLrSc2U2zhIyXC5xT4pVJZ3S3aeLGu6rwm53pSsh3HHv7/iFPtRXjEf60gQGw8yArd5OEdfYceflcwueiGhG/FsMuIwZhfTi23OORjfzEhTO3naL36kRfImuacMQ1/Kp9X5pB5kTDmITn2qitFo03GxY2kR4Ns4qpiolO61A6Ofwjoo/PlBgk8QVJU6UKdMxSIYX7kAPXAnUrI8wsQC8B2gVysgygpf+5Yup5rkJhKCadqm97SPDWWqohRe5baMKE2saANBk8wo+SRXgfB5x4f0K8/5A4stbmkI5wCvd+P555IBN2K5TlXHbXA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WHnhKqsjT5IDav8DSEiNTDW/m1uocoBo/F78p3AleVmyQjqJWt8FJBtsUUq8dQr0+8H2b0Kcr82YYIInByLbH6ZQmPwNtd5+Ry4SVBpHIid/V3DnrCg4DfhEf4n6uMS3TF1oneUp3yUW2X2gj5TEYQbJ6ik0wyGQqb5Y4WMQ4ZT9PuoQLjObVBTOMK2xlOVeO2Fz9IO+1QBHLiImp8+Zhth8QzU2+8wZCAKIgXPs9nO4A4zXD1q4jPzIsmFh+n6EENqQWWLl/ANEhrVLjQL0L29URR0PD6ZajA+mV9A90yfTo09zXDl87Dms7EgrfZHWcWFlKIjpM4qYa9g1kLXKFvwvQPNT3gNoh+iUVOmcM81dmeJFgN4H1DgildHy3UDcONPc0ETvG8DqxfJpBrJnu/c+9J3zoJ81xXqEDUsJZQZFQSLJ8JiKh+Bqr530aQFT/WPhske437kk5rHhRlDXNDek7Fpm9zuRV2M1/kGeGXBGHQPq97x17vdqgBCkXb8tm1dr4yINQcx1cEp7wRlXHcLLs4yZYrtbwFSv+Bj5WkJMP5cCAL0FO5rwR67zMDTJHtpIuYsXFYELxgcJm+zMOT1oAaS41uHfFonyAZZtWL4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c81f6e-227c-4550-152c-08de80f66691
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 11:48:10.7994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAcT7gRwHw0AMaKsw+XUTAMoa16hQrn1ZWHLsYNxuKTaMBU7AsOIL2hTUo1u2OR6NQBtsJXhwg1Eyumree8r/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8397
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603130093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA5NCBTYWx0ZWRfX+eRXJ2KkgGAK
 K/l3bo2eVXwIGAI8v3hT2A7eVwDKV1/6fasS/tPeJeX1IA10nig2ZW0JZ6i9BA2x8O3J1z7fnku
 sk2V1iRkuPtwO+hcYv9mZMdzVv2HGJwAUsJnAgfTR9jfRs61fdmEgZCd9VIJROu22JfeTsaqMWf
 iYq8C19q8IKLqSshCpn/5YVixj8N/vF+NgW7QzVbEXYHfT8KrpfSaYzK3j66RtkNeetKrtnTm6m
 HUecZ8BFw4afsfwxAunA/XQpk7iEPgkWbEPlB4AwEXgEQcJR+HtV23A/RZZof5SbXSR2LYK67iw
 5h0glxcWTVbL9O6ZrfzsRCv3fSpbCY+TD6e4W3jdW94uNs4Jx3HHQEtKUXMpDRQEeMmL9KOYA0q
 xD95U9owo3L8qgpMH46ddDlzw76+v7y3uk7krDm+/gCoX/Z6o+F5HE3bKwFOS5590ssg5ZRgXE3
 Q3dCfULclGsHl9c3p2jCY0hubxQCPxT9VeKxEdU0=
X-Proofpoint-GUID: YBywAPHHd0Oo49BbXyuoQwUlszkZ5jN2
X-Proofpoint-ORIG-GUID: YBywAPHHd0Oo49BbXyuoQwUlszkZ5jN2
X-Authority-Analysis: v=2.4 cv=T5eBjvKQ c=1 sm=1 tr=0 ts=69b3fadc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8
 a=Br0EUSHKqzhpGy1_YzAA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13824
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE0C3160008
X-Stat-Signature: oigr4zqadg45nau5ruz6n64bbna3m5fj
X-Rspam-User: 
X-HE-Tag: 1773402850-430911
X-HE-Meta: U2FsdGVkX1/Oiir89JfqAaH/XDqnXW9WmdmyULXBdUk6n5wH6illnQWQj64caPGSwhUIPRKPnlH+neAKhwdduisvA3ZcpUKdrAPI7PZUHoBfw5jZvqDsJYx76xMWFPEQFnOpIe3Qc4JC6JaigpYp4Mi2DyShpH21h5uw+LDqQQ4PmURBOgHxVxSkch4FA6HNi7bkTB+hu6ch9HvwuJzxZpeEZzWL+onG39qL+4iQlB79pZJYtsarSCChnPrVkJ0BYkyaamfhRShDOrjuIWHnZWdHpTxAlDAmHz/+jSgZkYwXycnrGZiqdHcdlPqGFCX7RiFubXUB1EwpNE9YEfp1KZul2Fc7rsh5pYm7mRZ09fqmzDRoab9GGGNsyWQvY2a0uGN7Ss4/JDqke6IIUKptd92SStJSp2ghVGXhsOlh8PfcPSGf4x7RrV88+lpoI3JbXGOtabrtzMNDvSTtifj9/QiugF607WeAqdSMU13k0zmJ/BqeXflrlm/Pmy9POfXtz+GyjAwhtgXZX1vs0buLIgUJh9yT7V3goHIH4uQVffd63yg9CmUkKt0tMekYEyj6L2THQJgXZDN5ejYxrNyYbNptR7xfhh9zircTrEjjJ5L1PHyPAzERWm/mPcecI+IfwjsAg6pH2ANETmOBtDRhymza/XEflqknARGv9hPET75X2ubiECHEGbguBxnSnhJSgQCQfjq9MpFaAtrO71G29D+hefdIz+SZ/l/PBh0hQdhScJfv+klLtUlbWFIa3jkzj3dSmWWoOAlk0DxCAdI9DDmQbZbA2+na7YtlG2eMk/fJFgVfbk4gCsB+I3PTXkud3vX0/wm8rU+n9LR4O838aPbHxHfBUea+iyElKIDaAdzV/rS+Vya1S6imAmwVRojk5EyPwivw+oYOWlBVLKLqBwYGr/NoQ3QYBFIF8v185bYcbIKLZUYzILPLvzD/vo5Vh4U7C6R5UY3EFw0kamy
 zDArbYtq
 kGNEdkWeOeKc9w+ZXdl0e1y4QwsUp91HpS/Mcs5WusQs601yYBw13OTpW901JKahDjogpXBdEmRQvOKXPgy6fcTpm7+R4j+t31AAkKamFZF/ZcLB9ovUcCId0uekfNQZ5Y+a0ZtGNAKwjNc/3ek1dSESJYZweChqP67j8FnaOWbns8ssCZgTHjddWUHflnDAW0XIStUrjiQcNhL10z4Id/CO7YbylLQA5gfgR8uJBETsLa1TX9jqsFVNWKuyi8vIKhS9QN5bn/FkYdkwkKXn3/x0p4ux0Q5ug+IEyG4Oq3qrAfG1fP0Dlbwo5mYTsxRB7w4ufmgLQIiMbfzquClc5g4WsnZSiBvnNvTObvTCR8FZMmbEvA0cT4JFzE3MgNLCTyZMoDbYi6dGizLIPaF4teg1/XRutvkpKfB7NfyohaeF8Abmg19W1ih+AON+PPcvlGZ6paBY0zbnDFDWvn8wFZLoVYlFcKtENVzgTTC/AhUy66OuH+XZoQ9jILn/vgxgBvk4uv4zsYRB4S8HbTSbrSbPTtsnHEt/Z/RUDjmMsTPrpkGuhxftpQXhdx2tcf308tcBRYqbhsw9znA92NF6bQEeYOvEjpNRBD5otVFOq36f+gYpP2Dq5ySSoY9lVhDOUBXpLgdF/N0Qkk4B9L0+2ZjR6tm+mtqM8/J+vSaK+5SZkG8S4ZJs/hedtsel/gu+YONDb7Ow27aNEaq4a1bd5h1bqff+yA9OLKQ+3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 10:46:15AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/13/26 10:27, Harry Yoo wrote:
> > On Wed, Mar 11, 2026 at 09:25:55AM +0100, Vlastimil Babka (SUSE) wrote:
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 20cb4f3b636d..609a183f8533 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -436,26 +436,24 @@ struct kmem_cache_node {
> >>  /*
> >> - * Get the barn of the current cpu's closest memory node. It may not exist on
> >> - * systems with memoryless nodes but without CONFIG_HAVE_MEMORYLESS_NODES
> >> + * Get the barn of the current cpu's memory node. It may be a memoryless node.
> >>   */
> >>  static inline struct node_barn *get_barn(struct kmem_cache *s)
> >>  {
> >> -	struct kmem_cache_node *n = get_node(s, numa_mem_id());
> >> -
> >> -	if (!n)
> >> -		return NULL;
> >> -
> >> -	return n->barn;
> >> +	return get_barn_node(s, numa_node_id());
> >>  }
> > 
> > Previously, memoryless nodes on architectures w/ CONFIG_HAVE_MEMORYLESS_NODES
> > shared the barn of the nearest NUMA node with memory.
> > 
> > But now memoryless nodes will have their own barns (after patch 2)
> > regardless of CONFIG_HAVE_MEMORYLESS_NODES, and that's intentional, right?
> 
> Yeah it improves their caching capacity, but good point, will mention it in
> the changelog.

Thanks! just wanted to check that it was intentional.

with that, please feel free to add:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

