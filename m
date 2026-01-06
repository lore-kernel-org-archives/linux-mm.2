Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D65CDC19F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3EC6B0095; Tue,  6 Jan 2026 08:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8617F6B0096; Tue,  6 Jan 2026 08:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718956B0098; Tue,  6 Jan 2026 08:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3E96B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:42:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F35D1A2E2D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:42:43 +0000 (UTC)
X-FDA: 84301654206.13.90D5EC9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id B1F0440002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:42:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KuMxlIg0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T8IEtVva;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767706959; a=rsa-sha256;
	cv=pass;
	b=sDXTEZSCa1KQfrjVFnDtTePL8WFEJFyjDj9DpeWmkXLxapK32AxqdBQ05FX3fjq6+Yh/P3
	x79IyLD9iK1t6Zo7LYgDel8otICEbPuUlZZaCTsK3lRvZfJBqq7DULb3zabYa0snSJ2TuY
	V9Eile6kuYQA7mpjXW+EgzKuj2uB/MQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KuMxlIg0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T8IEtVva;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767706959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j5Dys5dhGofUlWl6dJSHXIgLFl0R3D2YFYGxhDz4BI=;
	b=4guZ2vjgrSfgnRLSmmByiTIKAcXExe6eaiFizoJ7Qntip2JwkKNrui9JLZC+Zrfes38Duv
	lUdXrFbiwAYuRktLoBLHk1QOKJudG/8RcPBpc2KDf9XdqNma0fN+SaI/J0wgbqlEzcHo4o
	VQCioLDqd2oF/uAhTCRneAyCy/RM03I=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606Ctp4d3789876;
	Tue, 6 Jan 2026 13:42:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4j5Dys5dhGofUlWl6d
	JSHXIgLFl0R3D2YFYGxhDz4BI=; b=KuMxlIg0s8YPUDnnFjG7rEUw6ls8QUu7B5
	g2YaatroftJggF0e/shdvScn0PaSxzjDTZpG07E0Bn4BdgG352LYgu7t2gADah7e
	THkWXUyNMK4qdsa2Je7nRJLivPFrhQ8xBD78A8QupqKuficr6XU8Tyl6bAmymq+I
	63ITVVsELvyj3fUuVx+1O1TdEohPSHdAu5rauFen/OC1yAc+Jz0rQoB2sTVlbzJq
	RrK8dt96YwJIunrv3rdqrY8p9KOVwtjnEbIO9SqFxV5ugVYLQj4lsRSEcL7ehcV0
	jLrgtcu7191fcwe+vB2Nv2FDUWKMmOMu5oy6IGNlfTfLIk+/EwLg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh2tyr1gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:42:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606CkSZ0026309;
	Tue, 6 Jan 2026 13:42:34 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjvb0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:42:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bXlV4YySCLi1EK0ze9qSmYRtKboZGohU5znd5u1ikohKhDibhzHFuBLYkOvwkJYfdkXZYA/HQ8rP5lp37QsPNWbmepp1QvKw8zbq4kBlLDPUdzUFi8vLxExEU0U6E/LK+3ZI28i3ghgBZF9smonB9yc9QrhLQY/5AyjzDFe2sz5Vui/ITEE7z05H8vSoPnxbbxRDdaVnEgZN6U2PajSgXei3414eXpPKmSAuC2BuQqxOgQOU9DxqtoDHcBl1zkKCU72ngPkHnEvgxOE666xyq0ONDdThroTEOHniZtCC1hn00DXBxYfW6rkNvzF7NWD9AVDbszOHHo3QP+1GtUe24Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4j5Dys5dhGofUlWl6dJSHXIgLFl0R3D2YFYGxhDz4BI=;
 b=RizAA5qmQ0P0qM7GBuIxcfCv9Y5cu37AAw1gJGInyiFjPuMdy/eJm26i+wZZzZgSWYJOy07e5FQs4A1TEUm4eqMtCzSVADcxMt+08a70ucWHHTFt2jiNx4WJDdiurgy8VbKjvun7hqcIcZLdUB3mH3kJMOmuX/6Jdk3Vs01gzddHOw5wl7g8vs0NfAOfdQhWrOT8Cb1jQwUgumfs3F1riQkqHzHkmxjW0VHvGaQuW2nx5fZ+vQujDp+eAstxcZM7qylUuAOxO0Ijlsmo0+g57ZtrnuKR0eg1vw606f9IJ6tuL6I1/r9JZNyPuHvHk70tevHFUsLazshqW4+xk+Yicw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4j5Dys5dhGofUlWl6dJSHXIgLFl0R3D2YFYGxhDz4BI=;
 b=T8IEtVvaOxHyRWyIv7SBsJwFcBbIY1Esj/bdH3tA+uNU1IoHlnvGAEjIeGi8Jm3+lUmaNdYAYcW5X7rTcidIiCp8sUUwPd7u0dXcHUoe2pEbmJkR9vLCTQ/aq4JdbO1RWZABteEqzRDjlLOP3k2Xp4SaU95dkyYuizMC+GZozno=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB7171.namprd10.prod.outlook.com (2603:10b6:930:75::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 13:42:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:42:31 +0000
Date: Tue, 6 Jan 2026 13:42:33 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone,
 unlink
Message-ID: <a078e419-9b22-42e9-b4df-654841550449@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <b2b22973f761a97751487144f7726bb0cf868305.1765970117.git.lorenzo.stoakes@oracle.com>
 <nmflwd25h3zz3vrdpfgaztko2dcascl3bbfyk6slml7n472kms@ysxtp4xlxf6r>
 <945a812f-07e1-4d43-ab23-c1dc330a0a1e@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <945a812f-07e1-4d43-ab23-c1dc330a0a1e@lucifer.local>
X-ClientProxiedBy: LO6P123CA0025.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB7171:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bf3d0d6-9482-4d16-11a8-08de4d2970b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gqWca/qVPDHUtzRoYKPbz4yYw483Yq5N2keofaNLBtHRCtQoP9Zt+CQTN3qw?=
 =?us-ascii?Q?smPY0AQv7TH50rf9Dh3XwgDdjuMm07vQkNotahQpUbzogMgqsPzgbvU6U7zF?=
 =?us-ascii?Q?P9gjQR9SFLd6HPktcg8sdxDBcBJ05sIRF8ViwFo3qPBlP+FaTM4qI4r65JM/?=
 =?us-ascii?Q?+IreiowzBgLlr9ws6BXxyUbkQF0VjGC/J7PT2m3ozQzCfa1hE//1gJlNXMnQ?=
 =?us-ascii?Q?+hEm7e1E1i5CDec5jp5yr12gbrmdPalpTm19XHboKKdgpK/3LB8Z0gTD8Hr5?=
 =?us-ascii?Q?kuU9olGMOtK4ynFdlerDeNBB/tgI9LsL7Bf1yTSHG/r1NP/GFTpF0bDgs4wO?=
 =?us-ascii?Q?riYKJHHgCTfDa9P50K8A6ibmJo3zs6VLSgvcMptSuxUteUYpTwNDsPLYmLoc?=
 =?us-ascii?Q?9eZoETvIfU22nMVM2tx/Riuv/YhcuYNwtd3bAVV68m/EgeIerv+njJ3IIUN+?=
 =?us-ascii?Q?Ii1LdM1LWwqEwOXbcXrX2LXe09Iwl7EzoVpUpyzTC+kv3vWWp+bq3SFB/lFX?=
 =?us-ascii?Q?li06j/+/SXWhldUAv0lNAmnVd9dkVj61LCCNsraPmu+fCf65NfXxk36RHuUw?=
 =?us-ascii?Q?zhRV3zwV/NgWK7VMYVWWvUWInSXAYOFH476qhIpoGthFeApAnSbv1Jlu5W6E?=
 =?us-ascii?Q?+RJnTB9MXAbtMaz4xcXhNbLUzXxcA9QI8Pp58mRiCyigRor0DXHNzK5u0cLB?=
 =?us-ascii?Q?3ancymK9uDlwsc58PCf3petoMpwFd/US/Lr2yXB6eQi2n5yRRowMoW8vNqLl?=
 =?us-ascii?Q?eSUIIftF/lpb0JFtJy7VAaO//6V227PiUzZwyxapkAgEEYFZxh7Pftk6V7u3?=
 =?us-ascii?Q?wAXt2r3pC3gfWo1ahGkkTd3Eu8pgm6+vyfBV7Oijors1MUtjFSuwGmDDHR5I?=
 =?us-ascii?Q?X1E5Sw/AKJ3aCbIs33nonz53IdkumofZZePZaWg/eIZ7CeJX7HNIzgRAVkJg?=
 =?us-ascii?Q?aCDRo9+fePFD2FN79BD+gDVPlVtSEdZl0k+vtjriKcQiVLg3A2icw+IDjjNj?=
 =?us-ascii?Q?0L7JcaaK8fT43xzdupoQapevZik3cz/X5nHSbGnQoabk7FnaX8ge4f8fySgz?=
 =?us-ascii?Q?M6JTxXpqktLe6nmf/o0agSN6YQ4r9qPZ87wMd/1I8R1RSBazX+VWlfOW18Ow?=
 =?us-ascii?Q?mf8Sw2XyHTKLxmVRChrM/rYhcegu6g+DxJZGSmk3/thHZT7hBmXMBA/5ZJSM?=
 =?us-ascii?Q?74QALZ34Gnqx+bDM/Zo8PEdCGPS3kuZBGoHl4/rYPvGYOMGpdnoHrz+obNY3?=
 =?us-ascii?Q?XsP3Och2QCUfFW7hBJXIXASM4f3LOxBOuQMqkKZqQw6HRs8MmO7oYJiAwAxU?=
 =?us-ascii?Q?Ebgd/jU90WLemG0STFKjkDO6s4WEV2jjIrJJ5wTZTXdLpM7a7VZ8fAdEPDQP?=
 =?us-ascii?Q?Mf+WVAQszr/gOcZVYWSYv1SS1+i6YchUbyFVqUIGuMeuwUoQZa5o5xbNJwuE?=
 =?us-ascii?Q?x6obRos3fxD2iSDdC7+GLRJe7DAyQe3MN5J6gRIUf+jdWB8AvmpS6XAzm+a2?=
 =?us-ascii?Q?jyUJ3HDzE3uKVHQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1UdZ5pzpTrHCszIMl+cA+W0pEOfm/QU91HSluJz22xchObKyYTvwcC4g79ex?=
 =?us-ascii?Q?f9R5OKVWXJEaBhe8SkugyhUCQN6W4RTE1ohH4e3ADq7O9xpqFNCtxJdgYZAc?=
 =?us-ascii?Q?75g4pwg1umBDqMtSvSKz9mR/p+NkdlXvhA/iOBYBpuL8pe8gpZziPZ6F4zFw?=
 =?us-ascii?Q?wjr5WYFq9OH7CFaS71c8teNnqpqjUwLPEUXrlzpceHPCS81gcC2Kg2Oh1Z3W?=
 =?us-ascii?Q?/SGn9cqGcGrcqODqmfaoQsHME68xslpPeia9Mcbg8xjbOw/IAQkTT3+15jSG?=
 =?us-ascii?Q?gqs5r2Wn8JVfLCO1q88GMEMheHSQbgl9QF2kwwZDuauHVPvWqCKBzOCD/WLM?=
 =?us-ascii?Q?1y0l3pM9Swrn0OkCYBrWcE51Z8UJiXqPuWXiOS/gRsNq6GfJQ0la8EMoPBxj?=
 =?us-ascii?Q?j9VenWM4YCrYFEmnexVKYbYbApMZHLWRECwh7IiiFy1BTX4hocTUyCxGXKfS?=
 =?us-ascii?Q?5VvaiTKn1cvaJnc0JLWW7aGsFPTaMg7CWFlo/ygF35Qtq7BTqMnaZDCSCcDi?=
 =?us-ascii?Q?IEvkKl45BTiP4BSqabmquhIBXcWpswtcejHnemoqKV3hh241Ce0O8WJTxOwM?=
 =?us-ascii?Q?wr+uYR4fDNf93QdBEuX6vuO0dsu+31yXwOqwmeri4f2+0Xp3vceeflPfzpzp?=
 =?us-ascii?Q?3y7EYDCdYA8b8r+5VmwmifsBLGuT6kxaYVslTZ8YW+RTDs/GCYO0NPE/a/Fx?=
 =?us-ascii?Q?pUzpGHjXoFByZ0AQ3CoWpfuQeP1etgHrKvYFtWPcvRyyrmG1ZIv0hGFPtnbj?=
 =?us-ascii?Q?JTPgpfB6jenaH14aOUDtX9p9fBFDNU9eEPNI+tnGymGN7FMiEdX+kWou/g7K?=
 =?us-ascii?Q?w5yoIvVKL1KOzBrLGnNBywk3Bin/YWpVxsV9a3HZCDmEJBn7er5UVrFxle4V?=
 =?us-ascii?Q?Akuv7Qy7hApTUu81M+tu0TlkKGXkGdbx4HcMrnENChEzxeKt9uMaWUL+cQRP?=
 =?us-ascii?Q?WBSKZ5JsXwQoGtfGzCmbMsU99EuR0NHz4jl5ubCjMadw/tU1JcEbAL9LvZ70?=
 =?us-ascii?Q?gXlEZVHz0OA/flqsdeMFYi82phiXyoqFbc+eSncDHs0avZWx4UwVVouI6neb?=
 =?us-ascii?Q?9Deb+e05+1ZS5fn4F7ap0XpnANWzLECVVydNuc09kdhOp/CIVHMMAzt+HC/4?=
 =?us-ascii?Q?Ke5x3BS5oYp/FMmzGkHWd/CqEgX5gxfIc8FTZ+uPP0CK230Xm8DYBX/oNa+2?=
 =?us-ascii?Q?fTirLWpf4GT/QYEIJ62FYraMM5g7PcRk16+vIri0V0MGv4lrWt82vKv2eGK+?=
 =?us-ascii?Q?73NWnzwYT1vfYtHIN23SO3X3CPB+Kv+QI7FgWh80rRFyYu1LHzLoRWCSo09K?=
 =?us-ascii?Q?0XW55dY0SP8qkTUvhsFXj0l2//GfY/dNbqEcaq+WXxC2QUzXHY+xK21YeLJT?=
 =?us-ascii?Q?fvrmVt5LtXN4NvBIBUZxbL+tY5gPGskrwz8KQBrVopmSgEaCbjWNfpXFK0Lz?=
 =?us-ascii?Q?IG5jdE9AiKsDbrrKFiBHLXQweGhMy+ZjjvxQzWWbpYXGZ+XRemcBUdnpHIFO?=
 =?us-ascii?Q?7Un4saUjrI1aIJo8VEJlo1UKHgabWxhkZE2XZ7v+JWDEeKxfNSzt+H4nlmf0?=
 =?us-ascii?Q?XDQKs67aZRbiEIqBnMxYRIrzU7gI7jJSgAh94H161xDRLqt5F+79fLW7iSJd?=
 =?us-ascii?Q?9q3HG4pHDSNOM4uH9ywO+W3eDbGOBvMT/imz3gCBgpNsqX6iBSCShb+IR15k?=
 =?us-ascii?Q?y1B1LO7AV/JWx3+HZmong7aQ6uOCmz5nRadY5tHPCWHkIn+AVrIfdyIk8258?=
 =?us-ascii?Q?1anAT39hwYzYDj98hRqZiEC1kaZjNFQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kGWWmxXOVZBrjbixtL4Qbp1konXfoZdFo+8zqpJNO7KUAOCMUW6wFb7SnXtpKIo0FllZIKgMwBKOCIMvPM4Jog6FM7W+Bn9uBQ4B6zGu99yL2mmgEsv6j1q46X0givbCxI16aYo/VYjdxXcE8EfESZo85PgWBmhmgS+JLSiVF1/Uc1QWCySGqigIjFfyZ3IedEvtOWUyuijqOwXnNVNldo2beFcQcrOLjuaei7oHeEhhrYgLefU63q+bITDfFWdoay+r886k6qNK10XQjUpfjYaTYsQdUB70Uku4NbOwJvVLmo8scJUaq+0BPeuAGXDrpYcdo9I5vsjsvpO4xnMTdDLfS/00ejoGHGLBMEB4EMbsXAoXSyQa9WfTXrjV71YZaDcxRkh5k0k6IlR0HAhioBsEkZkzGW0y56bMwpCj7C7lwuVxJ0U3YeiwrHVUqJjjvk3dJeKs/yFqu7AjkGw3zT7/H8CfyAaL8ewcVgAT702wXy8zPj3sd3DNq5L8CSX8kOGbQTmIGjNFzV5/ItZNETOG5es1NolMmeG8zj02Xlm3TY2hzPEmoYp5lAkruYR0n7HGc+5PqCGCGMcP1xy6npLyN0M92Eoe9OaR28AEtSY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf3d0d6-9482-4d16-11a8-08de4d2970b7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:42:31.4273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PX0EEWBVEyEjCHRjbIf1gYsVPcElcaMNTMDrXfk/JZ6bzNofGVsdwuxrjD4Rzb/lIrqyOVCD7/yXlPtdPsWn0slLhS6lFxPzC1KUXkgh7Lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7171
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060119
X-Proofpoint-GUID: JFDv24DW_sfT2vb4ElycMS3iXInxS-52
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExOSBTYWx0ZWRfX1t3jGuzx/Sjt
 Ud1UXvEdJM+PBuh6WrHT5npARTrDoMP77jhwTiR1X75gyNee19ctYnUpMri+z+KKzSspK+O/m8H
 NoOxzyP/LjCeu/ZLc3T1AMwkVbUbRx2AlnodQ9PlEXuk7r35p2t8rOZNuhs1CCqOvs+87s2c5gF
 BS/uqXWCZ2PoUFcw3NW04IOScb97KB9Q7uQAROgx0MYktDI8HWPpX5Ga570UlMNE2oUAIOfGWXe
 vFlxKKAN3lwqxsnI1Y6Ci3GNMUESz7wvkn5vDFECXuqB4CM3nRV/5xINlfZONry8GoI/wAEHmZH
 h3zentmDkkL1Azg/riWH5dnNdhYN/ASD2nEQ98Qw4z5TKTC17ufs8VbE+yr5SOaCP/eu13rYcSN
 V9t5G/zO4sXr10OoywfiBdxiXGzkKooyLYs++jHHopqX0ejrjZxsRX8nbmfRXvh0DGG0s0QVn+v
 18CjMODWRin9lLttfy2g7slLIAXf/jFqowrXn5dQ=
X-Authority-Analysis: v=2.4 cv=Wt4m8Nfv c=1 sm=1 tr=0 ts=695d114b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=gdix1b2aGXSi2z46mnkA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12110
X-Proofpoint-ORIG-GUID: JFDv24DW_sfT2vb4ElycMS3iXInxS-52
X-Rspamd-Queue-Id: B1F0440002
X-Rspamd-Server: rspam03
X-Stat-Signature: 68ijxgxg4467joyzctj7ttitx96phuyq
X-Rspam-User: 
X-HE-Tag: 1767706959-439154
X-HE-Meta: U2FsdGVkX1/YaRzWonKwZfMWwJC8Zmw4oeqdukBNanGx5YdNzFVncCKTzD91LLYvSgy29elaMuphE8G6rapp0di/Fn566VZZzPlUEfYHVrJa4UWc1VZ0yFBKmlps0UVj3kyGsHK2tksErrJCzbGu7Lyac4Cl8JICkVCi7M6AKsagdPxWDLr1/8px9VFOuz6skGZBIdmsYEFUMlP5V/g2TR+95lUif2iRJ/3xOy75zvEs8z0/4MMqWvt5P8WGaPiBtN8PDW94k4cPUh/blC5vggb1RzfV1MYOuS3BaeTTwm9Mrbx9eK+zPVfLwmuwC9B2GJerp8Tg+VLYOG/jteDZJN7LyBSOSZ+bQW4UydsqhNaGYHLodQIKLRFp7J8R+AZ1KmLEk+xjDohtJPrKnXxRsIu7yphg0ct+HjHTmM09LxIHZ56I9Ii6ZT9p/UE9PW3IChoDZ8FHAJ2Zu86HEWuP1gYT1V0eQj8JYDvHceAsCAmGv//1VLpH8LvlLOqSng1w7M+zTErTmPmLZW1DqJAA48vqoK6YDQMSKZca7GbQFDwnUMqJimw53U1yxjEXyUNEXUiIi24j+vXEKTq0/NHWxtqdSiW9oll8YMIrkm7kwgEVKafT04kwL0LLEhEu48uINxdKjHJqHrxvWtss4+G3p8djDocz1AzFg+LNxyBez2EPdSHmnhRHhFJI1mgD+qExlFpK0V9Q3VUI/zlM2b3mtELSu/90aG5UgingoSld6RzgTI/9hb5gb2ATIwto5yLYtissFWEljuQvODscvtRf+yk0OeFhM2FLwZb3vnMkpTHY8evrPToK3m+1WzhJGmfpKNKnDakYRAZHZcZ3x62lShomJSPnAUDSQoXcoajvS6XsfQuUrNSFoBNZMw173AWM1fjJRHLuHu7S0ZSVqhFGHEVkkKhZnjRg2rJZc+oD07T2biwnPB/N52+6shyFaMGbGPfUw1RlLWRtayiRgYA
 bT5ccVdl
 JWy83efnH3w2d/HV+0ELULUD7IrHfNscinUAWGDztCDjDOl6rxMzErpe1UGPPJ/fju4KGg2bSaJmZNE2mbZGOW/JHEsYUlqexMUELm7e3bLez9dW8YA0UP2SITATLdYOOi98dH3W0357qyRu2VxYzGorhZHc93DzrzmmMTznej5jUvGbWWuiXpS4O7nRG1PR+NXGoa7rhap5QqEqagowuKbH0wsR8am4Ko81ygL1lgxL8VRKSy7G0kZvufpq8a8xPN1PI1FxqXNrOmgTdIqAgw6yVlt436o2Km4nybPhH4psjh41CxOiOy7/cvy6amsS6GpFo39q0zRsAm3rQQNeUAk4QSuGFX4KmP8GSGW3IYVkZoDseW49h12X7WHF3PllUW9xEIEeMkznQO/E7f1x0ahGkfIqDWCSOB86tQuj/fK383zGx96aBSqSJYPZcjAJAli147Ya0NO5eXHsHhnD1iNvfvGcYl++ZoGT2CSblf4C4kcvz++Xo+xRz18hAS0ZgGeLlyPl0j3rdC9b1qDAjnGZB1X8jS+dHx+z+0hJtaQtVdxDbSvmHoZinFStxs7Ni0C0YmXd5m+hCxlEPh4SZ+hRT3lf/AEcyZJvvl4mTbWjesswufLdBxJCLb6DgUe66xgtbUykYVoXqfuDFId4ZZi5jgbGv8PzHzvO81oEAv07Z2Lw+6Yub4jTh8aIgr3R3X5fD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:14:10PM +0000, Lorenzo Stoakes wrote:
> On Fri, Dec 19, 2025 at 01:28:03PM -0500, Liam R. Howlett wrote:
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > > For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or the
> > > VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the functions do
> > > nothing. Simply exit early in these cases.
> > >
> > > In the unlink_anon_vmas() case we can also remove a conditional that checks
> > > whether vma->anon_vma is set.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  mm/rmap.c | 20 +++++++++++---------
> > >  1 file changed, 11 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index 0e34c0a69fbc..9332d1cbc643 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -309,6 +309,9 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> > >  	struct anon_vma_chain *avc, *pavc;
> > >  	struct anon_vma *root = NULL;
> > >
> > > +	if (!src->anon_vma)
> > > +		return 0;
> > > +
> > >  	check_anon_vma_clone(dst, src);
> > >
> > >  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> > > @@ -441,7 +444,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> > >  	mmap_assert_locked(vma->vm_mm);
> > >
> > >  	/* Unfaulted is a no-op. */
> > > -	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> > > +	if (!vma->anon_vma)
> > > +		return;
> >
> > I guess it doesn't matter because you just added the !list_empty()
> > check, but did you mean to drop that part?
>
> I did mean to. Really this doesn't happen in reality, the assert was more of a
> place holder I suppose.
>
> I don't think we should be falling over ourselves to assert impossible things,
> really the debug-only asserts are intended to essentially document what's going
> on.
>
> Anyway it's moot, as I've had to drop both the assert and the condition here
> sadly, because of the fact we (of course) use unlink_anon_vmas() to clean up
> incompletely set up anon_vma's on a destination VMA.
>
> When has doing things on incompletely setup up VMAs ever gone wrong :)
>
> As ever with anon_vma, there are always deeper depths of horror to find.
>

OK scratch that see 1/8 thread... I will add a specific partial cleanup
path to deal with the anon_vma_clone() horror show and then we get to keep
all this.

In which case I guess I'll reinstate the check just to be super careful :)

