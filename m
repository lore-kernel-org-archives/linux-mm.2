Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0CEC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 11:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E808E0003; Thu, 28 Aug 2025 07:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E0F8E0001; Thu, 28 Aug 2025 07:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF408E0003; Thu, 28 Aug 2025 07:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 882938E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:32:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A3FB160116
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:32:31 +0000 (UTC)
X-FDA: 83825953302.12.F947BD0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id CEBAB180017
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:32:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dVM0Q+3x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KYuPPNqT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756380748; a=rsa-sha256;
	cv=pass;
	b=W9+CGKDS19FeVfLXevkIksa4QeE3A5/vu3h1OxnyWetYyG5OyqBur5IvUJkff68K1c5TG0
	ob8I8RV//wB0uhQWyv+8+lSdlErhdBqwQ7lmEYofagaU10h3VAprvWV8nQ/XK4KoKii9hI
	hcldqYzroL/8PRUAYnpifgWFPhJypyg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dVM0Q+3x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KYuPPNqT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756380748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXuWj2RnDc3vS2WWBYQqA36L85Gjqp4XQbCsZFZzVBM=;
	b=iGUz5uVbINxRGgB5JNXl+rvI2CSWD0BCa+tOQsO1L/nD8ijOYIt7OrWPdlwU+mW8+duAX7
	Hpd17eEcg37Z2oFCONn8KEhDNww8DIOJAxI+Je0NIIlD2Vq/6p2LuJX3N5s0nxTOhVoFsj
	4g+S9axNGz+5jmf+meqB7fg7stsGVdQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S8u4UW014282;
	Thu, 28 Aug 2025 11:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jXuWj2RnDc3vS2WWBY
	QqA36L85Gjqp4XQbCsZFZzVBM=; b=dVM0Q+3xUXMo3ASSRpg8Nxye9VDgD8uDWj
	OtahInu9j3/bLHUTehF/Ov5iVzxCnmxBViHFGpPG/Q3ppjooBdTsQKAcKHeGpS+2
	/re5nW6oDqMYWoOSsHm9asOm7v5RYM8lYcPjjPb+HjEwXT6R3lW3AunGXhbDp/Vb
	Rl4qrXuPPj6gDkxsOfQglyVMRY3z1B8AYL7fZkNxSzm+5LHqbrhsBoSW/B2b8Wcq
	SvYi0jZUtnAZMyjSZcmXHvGPs5RMNUsQZuFm0ev3HUXFniWu6zQr2QqoeFrGeEeN
	H3NH8+JiQYb0ZvBP9Bt1bfxu5Zb9g3ZyplhH7rtWH2Y/5cmvEjuA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jaratb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 11:32:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SA93ff027115;
	Thu, 28 Aug 2025 11:32:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bn5n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 11:32:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yeebBBEGxdCGQwuHnM1AIsi8msAmZIQ3XNAfAeEZ/RrnOUW5kmljkX4v9N1zuOrPgWmJqdia0CD2JgQfIoZLLpGjRUjX1LP/ZqbqWeixXBwBITClo893+qag80V7BVxuT5GkJlhpxSmUeR5i9+ri2iCA8ZvGClGzwEizqJ8dQxs8sGtPGdXYldHpz7fzLsQKqS6L/IxPhGhChrbsrvMVbL0pqTgHS9+4+OyvUaFJOCLMQU105/3n70oeL2tNkY4UxG6VYoKpCbr+NDxbnp0D0hl8XIw3uDIU0W6tQlhOg5Xz/E12DI+dGH+wXARed3V+GGJBhHNlkzJESqLAQflKUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXuWj2RnDc3vS2WWBYQqA36L85Gjqp4XQbCsZFZzVBM=;
 b=ETYhA1rNYMYYo0g9GusA9gn+6xuQUg+p3eZBFfyfAfLUA7BjdtHaaKRm3y952joDBJIT7Zolpfh3ODVnpp9NAqmG5F3DLJhGIWFYbSl73yd0P4cuuTpwXjfZ3XT3d4qAKMz75uVvoQRaWJmyzFDDMfKjU9v7ETsP0iLhErDbMUXzLf7fB2QIvyRaJoaxjg+aVgt1bYYRbThNQ9G4nr5mXRK7Fz5BZBb4Mrh9hswH5ntwiy6jFpyiRs1WrbjK5MjzMVZVCTw3r1ODPdAD/G2g/wILTECMPWqeMOBbuvUWBW5DJUAmEHF/LC6gwHKJDdFhLWJ75KnpCtYZsvKSxhXU1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXuWj2RnDc3vS2WWBYQqA36L85Gjqp4XQbCsZFZzVBM=;
 b=KYuPPNqTutd6FevbTGTciVGiBMW2jpl0kRlMQrYT3reok2EQ7B0m2CLTAjXUWxGClVVhgmqWsjsAxpfROD6y2pKfWGefMA7jXAOyC6kfji33cBLAK6tQsDfQ/UQApqOzCrVjtsxjgU7RaZBnujY3C5UeBwKyjhsnJgia2SzTOE8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5679.namprd10.prod.outlook.com (2603:10b6:303:18d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 28 Aug
 2025 11:32:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 11:32:15 +0000
Date: Thu, 28 Aug 2025 12:32:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>, Zi Yan <ziy@nvidia.com>,
        Barry Song <21cnbao@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        android-mm <android-mm@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
Message-ID: <cc185893-dd85-4571-9d0f-23ca3b8762df@lucifer.local>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <CA+EESO7j4dY3KjBWybTG6uQmXJ8kyhBrid3rTk5XAP7poZOhYQ@mail.gmail.com>
 <aKqjWqn8lrITKI7P@hyeyoo>
 <CA+EESO6PFJ9A0kbRWd-ARBLmQ9pwNOF=GBuAzMCOyFvps4euGA@mail.gmail.com>
 <aKxAWqvTxctPoumF@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKxAWqvTxctPoumF@hyeyoo>
X-ClientProxiedBy: GV3P280CA0082.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5679:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ce58340-f3d6-4555-fcd0-08dde6268a26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DBpeHtdgKRZY1GT3qEx+ep7CBE7hCnFTy5C2gpeBRQLZmIeLQA7JyRtnDcmW?=
 =?us-ascii?Q?bLmxgzH0robParzLoxgErQ9mph4qCB//GmebsG3g+OqU/EGiqFNsrmXPD5nw?=
 =?us-ascii?Q?I0/Dwc0K/HxQZ20l8h1tfD9ZSIWM/8F5lBQgQ+g45AhgcE9LBMoZWcylEFxJ?=
 =?us-ascii?Q?jJJ03k1Q+7HeqWV4k3uFGI+ua0oHjYW7NXRnYY30oDO7YsH4l8q9QQwUrK0Y?=
 =?us-ascii?Q?HSx579heZA4a+Hh12HjBnzrlr5WqKIw+PMwsniYsO6chBw+HEI1lwc9+LTB6?=
 =?us-ascii?Q?ZBUGy2VhrwOVXOzfrePgzEJlt8fUHUSN0gKoNshYgCLVJLrlQrbBcMEm38Fk?=
 =?us-ascii?Q?kNApapBixq4E5LVOVPiwCni+7smzX1yzA4tXl2gChLllP/VXEds8y4A4yIbs?=
 =?us-ascii?Q?3oa+bc9ECdyp31JOJKNVMERDc5nRYZv0zTRAMYyBL8DvoN1tYodGg0loQI8s?=
 =?us-ascii?Q?kFMVKtAg2DQFNXelf1E+Bc7mt4HbPMIOT3XvOkrGMatx9CLlfUuVAMdwBkxs?=
 =?us-ascii?Q?8XlI5/oBpGbxzD4znu7ueg3aEhCgGp89so2jPoiyDmdCRz23wrkT/c9zA5Hz?=
 =?us-ascii?Q?VY/BVOo2eDDdl3H7ILydRkGMkPVMb924dEjwxlffULjomFqTP9nTgvH5fCe+?=
 =?us-ascii?Q?f01mjCftV+xFWxZlU+U+Nbkqgp3FsaTf19Dp2o5S1kfzGLkugp5vUgKs01VN?=
 =?us-ascii?Q?DnwHWqn6Q9lKZ9EzgywkOKiwJwCkpN/p110JtVJ2kpR1moluOeH35NRLO15C?=
 =?us-ascii?Q?FFH/+158MVLWog3ecltsNgP9Ie2gfQkgFYEg/4ANJ8j3WLDwjbY0tGqVvo92?=
 =?us-ascii?Q?Sy2ka37Kfb4xYRZwlW2ttYCZojXmj4yD/bq9ybmiThp0q2mSvLnens32F8Tz?=
 =?us-ascii?Q?Te5vCZ5IcdwkuOXcPLG95h2wahgznOfB30whTyDmqRl+plmJBclnRgnICnl9?=
 =?us-ascii?Q?EXrQY4LXO/s+68UmF4HwPo43hUG2zj5rcr07z36yCWWu22np9dGRz0l8n7yw?=
 =?us-ascii?Q?tIg4oH+86/iR0ovS04Ry2vXotkiiNdbAAlbBLk/SmTIKsOnXPjJP1tTjNVGb?=
 =?us-ascii?Q?V0jBr6an5V5VW5KE+yxnWzQL6Lp0wscSFwGe56pjh4NMWrbwBtyTs5hbKj6r?=
 =?us-ascii?Q?BNtjINghHpOSb3kOT5TAqzhACz73StuVSCam6TY/MfRB7gE9BV6M3qmXHPWg?=
 =?us-ascii?Q?neIHYPaa6ybeM3yvGVDYqx+V99sfENvmDHiR0wFmRbl+3QeeeYmLr3Zrvxof?=
 =?us-ascii?Q?oCUh1YTZfcNcvc0c2QDxqKAOt24jj7gxsl2DQ4SgKm/EtsKmwhKC1yZWiexV?=
 =?us-ascii?Q?bTJk9I40BgzAfmrFpsyUTsWlkDfFBMzpgQFHjCt68uJi5TC+KGD5tLJVzY/0?=
 =?us-ascii?Q?7/5DL21yMuwOfJsjqyvdMfbc75Ze14VEY9mY8MwsT7QzwbbDjg1dk0raE2dZ?=
 =?us-ascii?Q?JGUX85DW/eksm8z3jt4Fcowp/DDRmaYj2RG3qqAUOIk7jXtqcl1d50q+Qyd+?=
 =?us-ascii?Q?e1iUjDMSXACcNbKHV1fgjtTaOUVBHrfL/zzfXuKOzl6DwpWNhvs1wNbRq7aL?=
 =?us-ascii?Q?av5/v8vIqswsUHH+SfOyiNNplrLMgNpcWxRPOF73E2/f5mNzXVbuKk0xmHkW?=
 =?us-ascii?Q?SPiUz/1vVbxxPKTUnishyQf3snQUPx37vOWmGkJfmo+n3+vRdpebiib1sjch?=
 =?us-ascii?Q?olRmpyObSCXzA4socNhM/Mo9lMZR/Qy94ZHuDz8CrGcs8mxI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6EjHbdvaFPj6/v2FeVc1RAceQr68fl9C5OpaJj6GtZ2cwp+aGzeFEQt3JaVd?=
 =?us-ascii?Q?5Ot3TrxncGZHMti58nj/NW2mV8nshksg4H6BZC9KR83hYK6szaN24MndxVrH?=
 =?us-ascii?Q?RAxJM5j40dqw5OmE06TKeIuQQDmTDGnzUiiVQ+/L7h1Aj8a98KqKcCm0UJoL?=
 =?us-ascii?Q?IBMN6GQyQw5bkMdyCgHEt/7alsAfUwrVgT2kPd83BVqrHe+VpB5in/07ANdi?=
 =?us-ascii?Q?Qw+qtaykMdln/ZjwAcw8xTOBl9D31TwmgSutwZj1+nQSbrpcjMIjsvte5fGM?=
 =?us-ascii?Q?cqKdqF6rRTIKNUDVG8eIhj8MzbNZ+TpzKtVt1/QbfklsX9NQ/tOJzaWl2prG?=
 =?us-ascii?Q?9zTmuxCUGRU4+48poAORrj+il63rKF2bJEKjScMM2ydYMTkMAfp3558paJoF?=
 =?us-ascii?Q?dHYTaBuoNKYW7Z0HuaNTRqHHTG6R97p4RnxAq0D69DaArTXZbfUs1X0Xtnix?=
 =?us-ascii?Q?Cf2bxqwnD9CoHjkvTpjh91DnpK7/0HsPhyqjz+26O1BsAeJbTQmeMk/QFIRZ?=
 =?us-ascii?Q?ILFXxkTbvyByJfZaR5nGl9oCnv6Y+PdPuiNKdwxX3E1du0UEDCUXzbooYOG+?=
 =?us-ascii?Q?fAbfFedW0u9mXhqHs0ktNTPEPGWZnDbYXOevks5yzWwX1CrsnNodi7o9x8ej?=
 =?us-ascii?Q?U9ART9YuwtF+IeVA/QAXxNmvcrHTBQTRpM6wLs9Z+7jZ1W5cV9YCUQp5WaEv?=
 =?us-ascii?Q?3cBzwgj6rSMVCAV+t/l8yxnm/IJQU3YxvOE/a7mBBYJvDlIbuJ66CtDqZL1E?=
 =?us-ascii?Q?kQlWbBtSg70RE52SM+g+mpHMwoAaBsBNc7p+2mTB38pm8Mt2B3V0OP5LnPa3?=
 =?us-ascii?Q?iFW+bDVY7KZPdRuGSizAYjdmLL4ZEt2qvvPxDTNN5QtH7QsNJXaBfdGtHGgu?=
 =?us-ascii?Q?HszfKe9lZhRXnw95LwaarfKGuRmPPn44+pYKQc59h21pQqKilz8y/4HFEnp0?=
 =?us-ascii?Q?FoNu27Wr9xuVljUijexFQK6ch2MQ4cGjEhjM8buYL5tokQvJVbLHBFI23rK3?=
 =?us-ascii?Q?Jq0H7aDKJztfElUhIwU8SjYNZ9fcbEN7wjnhKE8/dggAkn4zytC5lvtPXgY/?=
 =?us-ascii?Q?bmrj7vsPgv4FusRYZXHHewO8L1dzs6a9RdBKAHQ/7lKEMs5VGYnv1VTCRxcT?=
 =?us-ascii?Q?Mmm8cN/N92bfJto5uU6lUzBJZ0I3kK5vQVJ6FItePm45suKnPukiDemEmvJh?=
 =?us-ascii?Q?F3fW9sVb5NYxOIg8Ve+QNAgoOeyqvaby6coI/U/RkF3bKDq7mZfXm0GYLrLm?=
 =?us-ascii?Q?3nf8mx8qsfxMCuL9pa5kW8lqEyRDEdi4b8s7DGmjpOWbCqRHJdVotKAg0EIO?=
 =?us-ascii?Q?98ZWFyyJsJNnPP7i4N7bAioFcp9BGvEDiprUe3uM7tQ44nTPreT7x/ZE89C9?=
 =?us-ascii?Q?Zcs/oP5CXKQvl2Hroef+n+c6rmUzBSZ/fgzsWuOYYz9QzLuG8qPMUqClXgD/?=
 =?us-ascii?Q?2Lok7hxabne9qFJ8WrYAZulHJuqKErrhraCRVfPysiHSFUmxg/uX17vIH2eK?=
 =?us-ascii?Q?jV/copCvwgRIhEs+H2B+Uf5lcZiuXa62YI/hOG0x1A/fyHxugmxrCpEwueFl?=
 =?us-ascii?Q?71EpqX8YNDDY8jbTxhQN707FGBXnrwc9HUrKwaSBMaGj8IHDTSvZxrsz3WHh?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	59PMVFfX04dNJtoKyMvHRCXFk/vRqdI1ax30K5kAikzbYFneqX5Ir8xEmHEFGrzU97bo+mbvk2htnZTWGnBiDK9TG0Go1cUK1yl4R+D0uvawDtlR4yrFcye63iszL+GZgM4nbQtj/TXjd9OPp5oKp6NUSG+VrcbRtBFnx6fteQydZi87mi1XmAIdDk/nVbopSSF3quVmMTfwj1GF1C0yR+70xX7tET3fmiwqfKzMlna+hb2x6wsstwR2fv15JV5mibURe1tCNyRi4IGCpcEooH8HWs9+qwSJu9JWE2B1dedViBCKvBFRWJ8OKPWjRtyrZ0juqMDDdlR8Aaa0gj8TbMgSE8vOFVRoI2FnnUvbkR2IXg4fXoN9j+EH0FYOfXvaGqYY3mzDIo7hWZU4ez+KLcqYMc7UjqaQU3Qkg0k4W3pQqyOsV9yRUe3DozE8P8T3xZxEOyUuPy5JqZdv+Gpny0EkgzDUPAvCQJc1FBx4Vw0rSN75Q9n+cqQS0fLc2c9C8N1yCZe+GE7Alc/gCJZ0s4DJ/Kt0PODtFFjwm0pqguiAPVO4+Cik+wr4GG3EN8fOi5W4oDr7FR0+S0KfSquBgcfdF6nAo/0Os1Z/QST7wLI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce58340-f3d6-4555-fcd0-08dde6268a26
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:32:15.8030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quYcXGiNCpd5b6jYl5EorGaJ0BKHZL6dJeXtrEgGlnwxLPtfKRG3OhDcIh8s6lWrxqm0slAvOHxctYoVG48LhwHGRmv3D6BUhN/kGrfQpfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX7lFlIOqtc76i
 3GNfZYLsWUMSFCG/RlbujgrWKOTBVEFg3B65qYV4/eGRTvrWkcBx/wc+eYtePS2cVXRAbaWLYzh
 E07m0I4C/yDw1rH3W/tGI3GOcTEqqZ2q5FKNUgzNXh5y9Q6Rkx1NBV8Y/LApNMe4qN265ALgf7/
 lkMENJJCJN8cFDFN894QYoMLrP/wS7Ej2QSgZIEWtx4DKJ4eHEqUUMSoLOXmUJV32KIEh3Lbv7f
 ejodNJ58sKqxvE674PnIIgOXiqTpNssKJrqtfqmaeXaye1JiEkVNwi4s3CmygpcPymHEADh1TLv
 v9E5QEsqDtnyfXg+PqkA6wM117yaGsV+fUcOsciBrWEH7o7s8ynJdBsnbwPQoQjGNgJca1qmBW2
 NYdkXURw
X-Proofpoint-GUID: J_-l_AcuEsEsIllKLZVYqaE4cWhQetCj
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68b03e47 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=xoyz07IAmwPdV2KO5dcA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: J_-l_AcuEsEsIllKLZVYqaE4cWhQetCj
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: CEBAB180017
X-Stat-Signature: px6pztzkewg98xdmerd4m7yzdh1kiutm
X-HE-Tag: 1756380747-412981
X-HE-Meta: U2FsdGVkX19bXEPbXPuBbhEjr3gAtKZSnvkVUpCXzeCWuj2iFq1Qc5x5i5+FH8BOEYzbLLK+/+hyLKUzUc/dM1l6hzUdw+Edf9dnZnGHb6mXv9LOIcLvCdDX5CUnBO6Tq/SnX2+Y2sS+D2jF1jWUVTx0TWVidQxNRnHv8lJyL2DzlvmUfz7DoIsHuH9dI6J0XPOmwuCXgNTImc+AuXmgSwz4QXRN8pe6aa+89wIzrCFrtqEk6JKPjLP2xsIBGw4FDvJ6ofKd+EG4fAp95N5U+VQWr5HHcbNLdtntLev9HR0XUlQRWESzBYmfhypoAYyv+EN9z7iipnZkfZE/qF1b+k3/2P1XxvdreUO9acT+soDtNdW2R93p35J698ZMQBZEvACF1KAvGDNZSyqnrJnlmUiLjeRMdjoiyDqM4/wsJ8FTrLZ3ZPOcknQni/n8MKTwZQgzVaH5SAXsfTIYBafdJIp4q2iLx8pnK8Aqt0+Pm088yM5ipD6m4Ypr3uAmCQh00HRbyL65qi2eEiKcHQgtXR4ekyr1iV0/c4Yw1if+E6RDPLEGxCArQEBAyWQ6MhPu6PXNzfa+wNpY+anVW9CFRwKom+XmWEaYVn04dViVkFUmbYPY/q7LKp5Ed4iH4yh9rVPY5PwXVo0q/LjQq8MOL3Xt8v455zZ4Vq1j38JHE43Drydwcv+pF4B2zNRz1IakqbTtUkaQPNkjqrvQSeNQ/6yctpS0dsIOO80nrvCi0F2xPZqb4/XDZoXJRxHVzGKE3pPNUgb4B+8Np2DC1l4+zDToF+W80oeciJZlSeESd71D8k3sTuJKvNTmZJjoQBP1AT6kAWg6W4+Uf0+Ir2senNDcgjqNvVlTPQUeJAfFsrXm2JQQR2qzImyeijpLOgwh9pnal0TKPyPrplxiOSdxsxnGo+MOWCxSvouUIFcrnL835ZX0bW30nHAY9IVXs6dj6avrHerZCIo5sbClUjm
 kDO9h00+
 cXsj/xPBkfe4Gbpl6O58hySpY9YR1kgFlnKzbgmr8S1uI04M5F71ywof7dFtMMLsTStdfj7po71qA22h55afWAonJHJmCe/6FmbfwRQUoWKRcKud8iIeiyN8C1ZniAGAmHfFIbPfijD7TVwrOWlrH8oqMQC9HrpJr3DxpRJ75BV6c6WD8ow3sYzraXHzwChExUbVVNu+6Ra3eVUDiwW+jzdEUYa5Dhf+SzNrzOUdPdKGZvWN36C5bpp3NKrUoUE4hY1bcm9wJQBuGV2S+HZe6wj848e1vBMr7pGloKi3KSs68T5GfMmHf8IropzyZjoog7Rgc/G2fPkNJUwQqrOZhGS8uZi5m/6ks+UHKBWr5qft3Duhkv/dzjPViHbd0x1/FWhe2NgoqeUBJAN1ARUg75XnfFHYmA/E+Cmq/05ChHrs30bdl7wXP7SU8qeOZKfMW6NK66ElZS6X87flgzOh6JDAQokCycN1vdT1m6tHAEcuyUdDXXSP4iplYRDZXuvqMaq9eF0zVvlgBiPnuTBOSv9vDKxPG0t5PRqHViTosP+eXD1UT9tScs4ThUCAujAMSSw+kZUpSC3gFPOOVAk86genn2ipjL4RbL5rbkUn5rGoGoMdHGgk9kshBoxUrMlKoW8+q7IKVESrKbJOT8xzEHX8CZMQj29l6wVekrVB4R2YqjFc3cbBImRpRdetHEzqRQuaIj2usTrQV/rdIeyipUoLwIpeZoO06hooJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 07:52:10PM +0900, Harry Yoo wrote:
> Adding folio_lock/unlock in folio_referenced() is likely to affect
> reclamation performance. How bad is it? I don't know, need data.
>
> And adding cost only for the uffd case might not be justifiable...

Exactly.

