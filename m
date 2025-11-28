Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AC3D116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 13:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872F76B002F; Fri, 28 Nov 2025 08:35:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AC86B0031; Fri, 28 Nov 2025 08:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7116B6B0032; Fri, 28 Nov 2025 08:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED6D6B002F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:35:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D946BA150
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:35:22 +0000 (UTC)
X-FDA: 84160112484.29.F38BAAE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id A1E651C0015
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:35:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qvc5zZv1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zkZCR2wI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764336918; a=rsa-sha256;
	cv=pass;
	b=rqJxEEr1m0dL5bz41XXhwDzJvDI0Inoegk937hUVZB+x8w+tMMFVR/bjmvE8xMO4lL2DbH
	mNRxMccZz5EMgxo9XQtK/pgK+khwjltN0OC13EpOAdeXFIFWYjoYIdyPWKqcqh3qfj4EYK
	5RZJ5RByMXAEEA3vVjRIGENdh23jfOo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qvc5zZv1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zkZCR2wI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764336918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ve3UhJhzlN10WoSz3kH5SJkuej5+Umlz6vWLxM2zSMY=;
	b=MzRvD7pgrrelh0UKjcF8H1LEKFd4P4xb+HsC8bhqnI2NX2zvk5H131rgirkuprR/TJBqvb
	85jr+R5PNTc3jWj9Kmwp1LbCKoP1Swm+2rHBt6xcXFrhQkS4QZBMMFMF+rmT/v2rPb5bBT
	w0M/waVNW8/J6MrNUN3YPTfQgJKZOKw=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS7uPol2969832;
	Fri, 28 Nov 2025 13:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ve3UhJhzlN10WoSz3k
	H5SJkuej5+Umlz6vWLxM2zSMY=; b=Qvc5zZv1GJaHSZaRmP7vUIdG5OT70zq95U
	6KK6bhhA6XzVtoaVShgjR+sfeQUsgb6zfQ1Q3SZqklkJNgJS8tkt9NGpLiptHlPf
	40ydAYQqP+MCvf0hA6m0UEuk5R2CBKEJ7QJ6NZmldhRxGAgagKOhxICf+ox4ZcnT
	GWeG3IAGU8XHpxTLRtDmliBkFE9xyzpbPirgdwkk/BKJwrhXf5N3xLXakdCEezVk
	ashhKiEu8nbva5itzuXuaYBGDeBNs28EDV1FcyeSvLm7lf7kAbRE54U9tglqnTHS
	nhJtnP6GScA39jUIIdr9ij+kM2JFB5M0KPL/teKX9SXlsV8xquxw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apm7vhuhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 13:35:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ASD1LX5032760;
	Fri, 28 Nov 2025 13:35:07 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010030.outbound.protection.outlook.com [40.93.198.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3md9kjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 13:35:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JS+V50XflwWy2/VLufQiRIysJUV3BTqP86ocQ2+2nIxiEFnY/N0aqYoXqCqVErT1VBRq1Py9W5V5h0wz+TMXRyqMoDVQpD+82rS85de0VNuKza6TofzqbHmQGJBrJFVJYy2kQaoT2pnCQLPb91xSFtv+SDxlAwE2IuME+HJX39727kC4AlOTgFxPZcWMzpgKt1HVVEGYH++MugGmUPR2qnfH+FYN/jodHV0oCgB9PUlz3L0L2nkHtL215LhtAnOPYVoXr8YBlqzF03ke7n9YVC7R/ehBbSDrca8OCHJhW/b8FE/v38C9kbh1BGBuYHC6FT0r+Fozeafyi9Dos0bBug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ve3UhJhzlN10WoSz3kH5SJkuej5+Umlz6vWLxM2zSMY=;
 b=iU5aiQd9fIshvIe0VoA15jFm5qEiXolaOP2+AH9RB9FUU63fHt7neylaideuYt6ucJwzNuemJsniw0+0cPqEo5d4OS9KUnrrlKenzl3dg96BSuAzXKj1SVpHwSRap8k7glsKvC/j6J1FCdCH2TlYLfraFB5y0aSTKFomPoB6nRU2u6BGeZMRDnFJpJA2oIRrDfXqwFZCzmCYiJAhR5tZJYCwofNNOz2lTpyIS7J6j0+FBtltQcsGhziBtS5ZlTvyUcCLPooWtwy0MU4QwXxaP9I40fyplH2vV7/9YKzxDSrvDYFgZ2WF6CZQiEIYwaGUhvAcKu8GZy1WXI5Q2uJbuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ve3UhJhzlN10WoSz3kH5SJkuej5+Umlz6vWLxM2zSMY=;
 b=zkZCR2wIwGtKXwgr/k2oAir4ahE5x4lpyu7B/C496W2ccJjfK8ws0zpTtmXapsr7yUbFANv/Osn2tka7cDnPp0OSOui5CwloMXx7GBPi4GsNUPkT9RmsTOgVQAfbfE4FTNzLjPjN4+7cbb5AFwIWdHMXZssQKyuTAyjpei1jYhw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ2PR10MB7653.namprd10.prod.outlook.com (2603:10b6:a03:542::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 28 Nov
 2025 13:35:04 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 13:34:58 +0000
Date: Fri, 28 Nov 2025 08:34:55 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v3] mm: fix vma_start_write_killable() signal handling
Message-ID: <ozziddwdsar7y6yby65t4jbgvf6rupxuk6phd5umsyr56szmsi@c2ubpgypvcmb>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251128040100.3022561-1-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128040100.3022561-1-willy@infradead.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::32) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ2PR10MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a9057f6-c749-463a-e352-08de2e82ec72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rhw8tbbgE11lFIJ1omcyC8n1GfzhMEkPMZZVB+v5iZCp91cxBwqsd8x5Nrdu?=
 =?us-ascii?Q?Y2kP6EPig7HVNECEU1ziKn+A9lK214oh1Yd+Fsr2IhtYFdkmzUT4jpquy2YC?=
 =?us-ascii?Q?x0JGFT6EcWO4Z7sJIG9m20KoAf2lBdiUQK29LWX6pQbslvbxu0sGfHe7Urkk?=
 =?us-ascii?Q?v1NlbDGHVy2fyPQ5EyWi4+qrEmEb1LVbHLVNDGzYashvz+OS8bPySRIt+nuV?=
 =?us-ascii?Q?aBir99dfs2Qbo3xCWkaJwd6CVMIJ8VJU8TwTHPo1ewYzbPdjfZ+GsMD8FCik?=
 =?us-ascii?Q?92//Jv8ErThAM9aF2l1uILS4SSiBg/tGHEqxLAJsvY9KX4btcXl5FEro20Uk?=
 =?us-ascii?Q?hr7M7JYowfDiz/Mvo3OPquUg86IWbqhtzOZjFpb0d0pGWUHl1czt4LJ5Ic9j?=
 =?us-ascii?Q?q0e/X3XFZUjGW5b6LLovYRgqV4EhOtzaTquIwYYzmKoIQfdHhfSY9Iebm5F/?=
 =?us-ascii?Q?NIMZH6nXrXbDxrYs4g3cOrDCyMFvGJe/h7sryUq3hay3Iw4HksiDZ6HeECE5?=
 =?us-ascii?Q?T1x386n/oG6VDDWsTHvgPHFezldfKj6Ku06H8SNOvHKFAiG/Spxa4wNtOUBl?=
 =?us-ascii?Q?Lzio0mkJHxkehopoEI1mT8r+Pz/EQttVnvCOo6ImhSC3QBOWxDm4igC/V2av?=
 =?us-ascii?Q?UmNFcKZumbVAbiSihr8pE8Z+eTEpawF6F7c4z6PJc4j29QCR35S4bVOTaPYy?=
 =?us-ascii?Q?zbU0rPfL0IQTsmdE36jpCHGTK6XTGVQAtIq8Gwyr68+NyxVEzPMpeiG7p7xJ?=
 =?us-ascii?Q?SRJm3ar16PQi09tDbtVbpD3lKmR6utNXuACWw4eFY+JeGUn6d87IvU9sfO0v?=
 =?us-ascii?Q?YSkN9S/Axfxy/4I9Kyv6EuzcumgqJfj4r2mcOr/uPDELztJh8+lvd2a+6kD1?=
 =?us-ascii?Q?kcQK9Kc5F98RSCkqYeImIfh68mv4HeGWw8+b0RBVV4aOAEHpPABjr4T6yVPe?=
 =?us-ascii?Q?gIVGYVPCh+dW8LXetfNRMFFybdbNOuRzVHr8C77R5ctNSUP79sswQ4TKWLoH?=
 =?us-ascii?Q?BE1VhMX+N2DmN/Tqz32SEgeGMezm/at3Rz77rxVjmvdouqy5aSbOhsNmX0NF?=
 =?us-ascii?Q?MlUUi3GjnW34a+/T5HSILvunJifw8D1UDqxgTVpMku5AGGmDrb7weirQKWMe?=
 =?us-ascii?Q?mERq0w++fqB7AiWYXMGNgzNt/+NIlcLYqmGRchrQ2wBVFR1cxAuz+HqWR4wa?=
 =?us-ascii?Q?7RHz269b8luW4IADF6yseMd8R+Hfee5kbHZ35UR8DohHhFx6AimOFp0eZWqz?=
 =?us-ascii?Q?WS0jaADgOfH7e9wAh0zPNZSSdp40yaY5wo2zeAAE5nueoNglFvKvAMD3Rjvy?=
 =?us-ascii?Q?+J9lG5KZOCXbDUOeLC8s8Z47Yyk4+GImvqtLl1d6/dmxGg2bIZGYOvlKOzgM?=
 =?us-ascii?Q?8zp9T8pxbgMC6Q5QIMLqL0ZCZWsVjkOc22s1ScLPCSZjgeL/dFvuHO3Pyuvj?=
 =?us-ascii?Q?wk2RmZFcMBs9WIllrWuX0D6fNDxwil5E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5YKU+m2bOzoyV65qSjiCFt2CqssMWo1v3ETeUwieWVOm/BwcIuRh2LRNnhGb?=
 =?us-ascii?Q?I2Q//zf0lP85wlrjh2HFzK2EwotKzw3fil5Ndo70RJaGQnF+uhJHaWt8iMEp?=
 =?us-ascii?Q?6uLz5Oqj+i6xG9EqrhE02Q5jjowhbcGKnT8BBC7K7Dx5gUiXLgOgTo+J2EQU?=
 =?us-ascii?Q?MgvvjCjU0p11e66A+Ar0vPJ/+tdbNiFRwOMFOy/UMdy9VhRG5//b1st+eFHN?=
 =?us-ascii?Q?wZACpXyYTWvo8tmz2evLmDD00VBkDb1IJkP3KxV6mmfesC6HuSMd4lXVndGA?=
 =?us-ascii?Q?633NQhIcWxmgdDYEQY1daZ1rnR4ZKccLYFyipKs7e7lM1X02Bqvh88Rq0EaF?=
 =?us-ascii?Q?PaB5B3FmHyzv7Zrm9lNwWWPdjDhNRxmBEUGd/CCvHFhZlPUz2VpbsSlxTG59?=
 =?us-ascii?Q?yOz+9qorFH/uNFnOXKBUIY02Ej49zdi0Clk7VdJmBotRGEE85BBnTx4v/jBF?=
 =?us-ascii?Q?FmDB63GzBiR9gWRbLJx4H05YyuonILUBRhDvzqiCkfOBzknRTCxuFrMWjkys?=
 =?us-ascii?Q?Fps/SjVfWtXHVh/D7yLVtEESO90/tQ8KBzmKfjQ9d8var8asn65yZnnjHd2J?=
 =?us-ascii?Q?rXICd2gwnviG6A5K5UpN935CCbxIzHwdMCT7KQEBB5CGdA/LCdv7/8udwHK/?=
 =?us-ascii?Q?NLBeZcCetwkk30YPwwyXy6iFq/Kl+TDHVr1u8BeijSyezJenWALMCfHHxoqs?=
 =?us-ascii?Q?WurqSBDGajfp6PIHL9T9qo2GXYROvg59/KoJ45Dg+oY2hAHarP4yW0tNccHI?=
 =?us-ascii?Q?lVz6UIb/Si+bgMRBQktqxfzOsqkSwYpRLcu412W2ksl7CCW4RYPuVvIAQSdD?=
 =?us-ascii?Q?/kFneCOm5ASUZP7N2bKr7Yy5f5Xu6uFs/D021vLf5n2IEKG7OlX4nvl4sWlN?=
 =?us-ascii?Q?/2rRbECpcX1Y22eMhqGt3nsAU29TehbaFxll3UxUYardw4APMepWfJEOPOi6?=
 =?us-ascii?Q?ZwxZnkYOS9cP9irZIdOL8SlgKrmuv8cTwmW4JRavlhlVN7mymcrH/Qhqgp2q?=
 =?us-ascii?Q?rsxs3xx8geSwWPrKS888SJEqnUmBV3e8DoG9lZV0+evevAPjunx7N6gMj03W?=
 =?us-ascii?Q?TNF0smu5nNYkX1vuuyYQWtrQQM83OHKVMF+jM6oRZUg3whKO30NUDwrOci3N?=
 =?us-ascii?Q?9cHmuKXRa4zW/2jY+DFIiOzldEbMvJbzl4bGRN+qNW4aEauIR2M/E2amaYbR?=
 =?us-ascii?Q?W9k5LXfPmXOfSYYA70EjUmLL8jRkHddnwCooQ8W5arId1rI1UGaue4PukLqF?=
 =?us-ascii?Q?UDcyPciX410nMiO9I7MlX7tloAPfdIvlF5YdVE24fLZmPMZaeE2tiu3so0+A?=
 =?us-ascii?Q?q281Pz6uA+E1+qRwpqEiEeqs/vqJSlXKb7+WPz7QURyJQU3hYHBSpzt5SdZE?=
 =?us-ascii?Q?rHac302Wfsovp10le+l8qcfXz5MAqBlb0GTP5DCbK/pyyVr7r1nJc/JihDYE?=
 =?us-ascii?Q?gjxbyxM4kNTCSpmBEY/Xr/8h36igv+Yq+D6XMDrpc77ALX5IoL6/oxG/cVVo?=
 =?us-ascii?Q?gGdp3cA36VF8sX8mPlo9n5jYDbIyaROrsPHVjk8KK6XSrm+0oaOMUfTmhTPr?=
 =?us-ascii?Q?pgT+hUyvGT4j+a61pF97+/1djiAbpVyEM7y0d4Fp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yni3H16ik5DVWF2iNcoBiCpbaLO1jcGoxVvs+D9xdXl5x11QuF0VrTsPMrBkCBMkqrNUab8f0Cz1FRUN2xQz05+YFnr4+s9G3GNOg8IlCkYXrSzBy6JLNJYVma8MzouvT9FmoI4AYg8iuamvYCqDybHXv7hnouJXNPKEqOSX5LCZdWtEjenza3mydfq0jZHzdei183lCWx5Zh/b80TMk+a77GA3NNdO9za6RjpSIuMoDhSX7L/AByX8laqjCYN0bI6lGMjhG2SrsQUYcQHx+xJZBQ6mNukx7MddLsjcNnKfD2D97IqCRQ/URcSS3u0SXUQ4P7h0npG+bKj7n4FHi9KNGIVfpPHPdzloTZTb9FB/HI+A4fc6Y7xA714Wk5lXpKsjTHWhliLrb63DCgEgKrtiU0K3jCGYXmsjx/fNtndrG1Wv/mWcqblm6zlKXWquKbgOWKp7gJJ7ZnNbbTXYYwKJjp+dDobLlgiaffUs9VihI0wlUA1OiNdl36HOV16eAzrvgMOEQXCAlPs8TQaDaF1atskGlH0k4g8mYBPBqm0GsdqyshLSbCke/AxQ3/EhEsjUg7vcyfxOF72phq9rdnKJIRhb+28f5kWAPQVij5zE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9057f6-c749-463a-e352-08de2e82ec72
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 13:34:58.2433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDy1nPJSGPBvCDnouM9MDDa6Uhtgnmt0yA6EPePNtRRNPX8CWjc4mC4s8+vnmJlTn3otXEl+8U1jiC+hi6zqCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=863
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511280099
X-Proofpoint-ORIG-GUID: uoyYr8X8myMGn9k3kkXhAZ0jI7wDD6dC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA5OSBTYWx0ZWRfX5RLlAa0ePDJ7
 hF+b4zlZA7Z5MQrqpCO/Ygqoqai13Fxs7exHQxAsG/3WOJRZx65FkTbsU0U2FS/a3jFfrvrLasj
 y3Sd7nLJZbGsL2D6/iKbCpuQTfosFdLc77/fkJ3pQNXhX1QEpsl4OlPEee4Zca0r590MuLpRGqN
 /shx7RKagwnjQ+JpJ5gaIWpABmirCxZhwmIy3GxgzhTcLhTbgg+x8yWwR0lR+LFBh+RJRK7CoCb
 o+JPaW4cH/tzgBacgwhkGGqA7Zw0Gc+jphQ/szq2+Fb4MrU2HBp782lUefK/AwSi7XguiBv/934
 Yp9lFXoJahcai4Z3StS+janMsk5W4dvqORl+gv0nitZxFw7V8aTaxx0+udS1ff9Bwmw2cX0UeKC
 McgqqZ6ECIFYwOjnpoSQP0Id3+qGMQ==
X-Authority-Analysis: v=2.4 cv=A9Rh/qWG c=1 sm=1 tr=0 ts=6929a50c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=hSkVLCK3AAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=rOcsonHiq5rjXXyXXnIA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: uoyYr8X8myMGn9k3kkXhAZ0jI7wDD6dC
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A1E651C0015
X-Stat-Signature: r1fmzjmyz1copxqehb79ih3xzhqp37mq
X-Rspam-User: 
X-HE-Tag: 1764336918-234566
X-HE-Meta: U2FsdGVkX18NWoBCmpn9BaXrArQ5db1TPOjCbD5mHv0DagJKsdmVh8JXe0p05yEv++fqC/3KVuQtdP3kRhE8W1zJo6wmuyK1z0LWu3gMMMsmQs5n3EYuZIsGA3AdHsP38PTTOPe96hWc+iyhY7uD3kLcGZdGYpwEYIcEyTGa+1ffGiT7XkF3H7ZgaiUIpTfohRuLTuMikqw9U4rWuwa0gvoJkSLd6GcEDB12J13THi4ATelwTE9uhY2t5qVrGXUrVGofYD1W3K1k0Gnqxo8GTiWIIScfbqT3Rzbjfx7nxD8ptYb0Hr1C5/YtXOP9+FaqdQsKiHLQAkaSZvZUvD8hHgWcWFlOjoPodvfGboyh2ggH4iRqdLzrfpmWWLM8RUOiPXVF80QoOdPDZQ+J83K5EY1NEXyaHzbqofENm3MCjjbLHusEC64IUUuo2FnDwXiEs+7pVMS5d0+iv+36EfGdcceVA/viX7explLGwgHzJP6f1Zym5VK9KhOLZ2iAlqN9/CefH7ltjLmaimSlgjxI7uCLhHAzSXdCsrA2aRImoMmI4jSgPXvnmOO6n0Z+LBYlEcjSVvmD3wxdMTZPZEVQWWw/XjjpUzPE0mXHv/hVNqMHs/uxC3MsuWE1S77DC6/tFXqaH+/TatvTHjETwUsdG/GRZWT4rEsCA5uFM1usMyahcvWHF+3MekYr6huBT3jgZpgivR6Rc4lNCjKinYAVEKs2PpnL1l7jTroij5kEstL2LTTMQ0hsVq/7BF1ShTEk4ZbN0+HRAPQkVbobSuhld0nymsaLEHpH8XsvCzfakuSebvociS8lexD1Jz3t805CybtkMb/tJeta5m7hxyUVeFhXec2zvz4ACeEzdTUgO8hKErvrkJ6tF3sSfRzmyTS57KUfkBPh1FUtbJ5wb5oFLCqKrfU+Fa88VVypaZJg6c7bkOgGalO0dusHmQl/qs6XLOwGPcL8pEzytisbNCd
 /rVQvAxC
 yYvdtpDeP88oRc05go1Ig2hfsx4846cXj6/ahchpDUdJk7cM6d5h5sBZwehqfcsUcStIgZLS+CmW8NcrUcbPy3kXt1Vrudc1s8dIBDVJkQWsAG/RKIR+TTqdqZKMCKu98zJDw5bNbGBbluzj4S75LKGaOx/MNw/U1/2NcU73l1sXPlvH93H16ullY9iLdC4t/3lKCmGtxp/Nf1qtBhEIzN+7YjoqVSz2YXEEMLiQ9vUKatbUIbmPxMeEfp8GZBVRmpo0GyT2IdfWOLGbQjRTJo8Dft3ASDWVrSON1yddaXiJx6DKfDvHLKE7st8XNGpyDcPMLryr+6Scyx1c+D/L7eSjpc10+ALLgGyKumsqFhviCx4INpF//7OZMvmub7STr+6kC32tulkkvUESLRelQQP8gsQAUj8wL1UO3ZPQlRA1QdHqm/eGUCdMrmCfHrunAlcJ2J+vIYr9laILHkG3EhimvtNPfaCDkNaKzuRyHwtP6QwLscYQq+EQtOjf958lGyiv4iCxhuoAoqlPiNm8Cg2SRQWPImF6rqhagZWj8TLPZSXVNAbKthq487BEUosshzWupFiIIu8psoNhMr6/0p7m2lVSEs+oxJq2ccG2QdQOZKvbi6aJtJ6+/uVz3MAiddY3fQ45GAHlh2CVCMwVd9czyT9OPKiP9ExiDlyUDJVFzTuTRyuVF3HXpOLpiuhGL2mfVBQIbAkhqH3MkRbfb0mQdnTkGodnm44x7dhXHHJivjJ7waEucQJ9eDVlJUva73vh9nLBUpykuMs9bJMwsNa0Oi3mVfIaZePB56b8iE3bPOFcWuMKTloMP8FaZon8/Ye2IdbJtXWpzv59mPhVQmYPepm/WgB+97d5yYqKTL6FIy6v2xhXVuHfei61QbuTUNEki/H7kxWOfCQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Matthew Wilcox (Oracle) <willy@infradead.org> [251127 23:01]:
> If we get a signal, we need to restore the vm_refcnt.  We don't think
> that the refcount can actually be decremented to zero here as it
> requires the VMA to be detached, and the vma_mark_detached() uses
> TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
> as if the refcount was zero at the start of this function.
> 
> Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/mmap_lock.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index e6e5570d1ec7..7421b7ea8001 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -74,6 +74,14 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>  		   state);
>  	if (err) {
> +		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> +			/*
> +			 * The wait failed, but the last reader went away
> +			 * as well.  Tell the caller the VMA is detached.
> +			 */
> +			WARN_ON_ONCE(!detaching);
> +			err = 0;
> +		}
>  		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>  		return err;
>  	}
> -- 
> 2.47.2
> 

