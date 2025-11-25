Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5079D0E6FE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 15:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512096B0027; Tue, 25 Nov 2025 10:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9116B0028; Tue, 25 Nov 2025 10:33:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0CF6B002B; Tue, 25 Nov 2025 10:33:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29C4A6B0027
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:33:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C49A1A01F8
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:33:02 +0000 (UTC)
X-FDA: 84149522604.26.FF26FD9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 315691A000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:32:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IhAyBHk7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mF+ZnTPp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764084779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Erct5zOB0IR449Jw60aH9tkZ/fUXltcHWG/ORTSVtg=;
	b=2E92F3l22SlVk9vnHX7rfE1HYZvwdOsmpkl18GmCqUA9UT356if/T0HMpVMBot72D6q9nV
	hPlo9dEP6HlpuEpgIKYDI2HTO+56nkFloHrq5xpMnZzA/tLiant75ZGPyNKm0wdVcQ7mH3
	GmNqoqN70RA/7fyYmH2IjWmYeUBPaGs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764084779; a=rsa-sha256;
	cv=pass;
	b=nhsE3DTIKx4jTEFA6cXsUIkmNjosREzJkISq3bQ6FYws7g+V6alfoGMrH2TG02DqWFotq0
	OtxfFhAXJVMD2NslFQEdxJpg8TFyn/AWpkY42dis9kr3H0Ic3YF5GPmqFVHN+QIWdxxKRR
	KRAiRGRLfpBNZa2ObSUzgiCvf6znCM4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IhAyBHk7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mF+ZnTPp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APENJcO3864497;
	Tue, 25 Nov 2025 15:32:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5Erct5zOB0IR449Jw6
	0aH9tkZ/fUXltcHWG/ORTSVtg=; b=IhAyBHk7Y56iX4zvOit1Mrtyc7hm2W9QoX
	JiuvM86bo+Ttyfsm9PLITzqFeMQB7Vy6UoZtWNFxk1HuFK6l18ADtLd/Ag9Mf6cU
	ujv1bU8y+F04c4K4zM90ef2P2ycgrvryrSg6T42EDfVbL02dOzUWd6i3Ka7uziUL
	UKc/LKDbEfQpnEB0vy9rRx03af5UhqaOwlUR93ei+4qv8GYwU0aHHXywAMC/kj0h
	HcDjjilcvawziooqJ+pO84+HOyW7iXYo9yTwErkoLTHGuZdX/ZA6dN8/qY6Iv4OE
	Am12mSMqEcUXGGVvgl9MLeDX0Pg+4lXen82LWQP+ynbTOXpK9OdQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yce2fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 15:32:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5APEqX49033705;
	Tue, 25 Nov 2025 15:32:51 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011012.outbound.protection.outlook.com [52.101.62.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m9mn2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 15:32:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/HR5NdqvzHGnpEEZtgSCyLgFzbuquWh85pZaI5YmAviKzbG3U3fC5AaZuP6vi5Hy69bJoOOGCu0l9CowAx8A486/e5kqBzzELUbt5qNX/IGi5um8KC2xARiHyQW3bcoKFnjd+58dIKvyrHVZaSSdP2OHXE5zjVVEP7gvv5lEcEETi4qtO3RKyiN542H+Mi7wq3t6ZFFj9IEDsrD26yP7VAklSjcvNVtGnCTVXnhzsmqNnWlVQmc6QO4YHHmwmiIDxgUt30MOOZTSooKlgXv7sXy9TSUgOjpGBeMJI002d+8NkBlwMhNKPVCyLh/6U5gCdEoiOoVax+ewhXAQzKAzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Erct5zOB0IR449Jw60aH9tkZ/fUXltcHWG/ORTSVtg=;
 b=leb9OGcZhqNRl4JpOwDtjoUOVINXSCLXKCcz7URlkx/BTM+1HsCoUQI9bMDUPKu2DukKBIwqQFwek7gial+KXOVWRDsbOQ8XRVor/Er9OvGXYNJTsWxLxVNzj01Jpv4NYSP8O8NCTEZAuuqByYnVNr6gbiRiAVaIUCh/A4e8vXkkp9LmAnZ8KPvfV/cpjkFViI2P7nHJ4uiu+b4ZtHXzCS8GlXZ8x6dhNhYXGsslQrarfWU9dYTuWTQd6PD8Zkm+EmCLTpK+wOmfhBWv/cuENq0WkceDZ0f7lm0wfDEvDuHTUCak4wM6ZLV8J1A1kDW+6P3DHAWwOKDaHiZYO55x1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Erct5zOB0IR449Jw60aH9tkZ/fUXltcHWG/ORTSVtg=;
 b=mF+ZnTPpABG/y4leMQpnl/rFlA2q9JFTJzt5xbPDDVoeO1BjHX1SWK72lFIaH/wMLxYUVxImbhHYW4KRZCCPDBWN17op/g/5fOKTauktL0D5qEeR6X5qMAA16rOoBpNOrLgZfMjXEflAL/9u21ojMRUCLvjqP2MojUM4ztVF9dI=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 15:32:47 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 15:32:47 +0000
Date: Tue, 25 Nov 2025 15:32:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add Mike Rapoport as maintainer for
 userfaultfd
Message-ID: <0dbe7e70-6a57-4864-a0ae-b787a7c319af@lucifer.local>
References: <20251125132908.847055-1-rppt@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125132908.847055-1-rppt@kernel.org>
X-ClientProxiedBy: LO2P123CA0048.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::36)
 To BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DM4PR10MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f7d4377-2c09-4d9b-93db-08de2c37e2fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eGxgq4Y1IYr8MshWfCmzhIzmiMr1YZkzCoW7MGOADlxMRp/bblndsc8S6VMj?=
 =?us-ascii?Q?7NDr17ZNqD+asl9ixLbocz/hMd+8O2A5ivsnCw6cAusNthcaZ5Xxki2Z35iD?=
 =?us-ascii?Q?Wdjv8Z1ZYg/y6euBM1nLWre73LWPbT/HIaRpL3+K8hSb0cFLMhyrklTnGDxF?=
 =?us-ascii?Q?ip3pRgEJ0dQ4lWxfgaMjkh4HX81sAAUPRhjLwn++L8dFh5dG8TFK7vWVI+VI?=
 =?us-ascii?Q?OIbvAIo3vXbwvXN6k/lMVf3liOlZtkLepjpwatRgDXXRezWFGWJzf6YSqGfZ?=
 =?us-ascii?Q?2uD613Xf3bY8KlYq+DV08XT8lH7JuWdIt9D+XBLtJFTyn1pmDYyh2RV5zOYW?=
 =?us-ascii?Q?VNYeCyYPNZi20BE3JX9zHiXcOOUut0VM8oc8zRBj5oU7Yda+ONYkkEWZXzFX?=
 =?us-ascii?Q?jcNahdoM+Qx9a7Q69GJHU3gbN9BjYUxpkXHW+jOJO0wGJauR5QMIiBKE1PCm?=
 =?us-ascii?Q?Z2KXofebGt644sKGuGx7maP5hLs+GheJ8jJAP7S33WJr0SSzRZ6uaCW+Eo6c?=
 =?us-ascii?Q?HVuXJV8EB9tlnrtOfTE1fk/0slbck3be7RY2EVNcJp9b36Rl/mlQaTaOFhqP?=
 =?us-ascii?Q?cMkAhppEtJt1qJEexVan5KCCpllDVJGR+tqVkC3QblVbBUYgT7gnkbXgDyfw?=
 =?us-ascii?Q?x8/SoUNsxGvfyNkY9PwdfhQD2aNtiU97qRen0j33XkNr2J/onHZLZ9RR3JCo?=
 =?us-ascii?Q?cjYtAM/74Gwo0N9h/Ti/pSm5ooe/S4psQflmECywqkuD3UtCdyl9mNHEfdyB?=
 =?us-ascii?Q?ZF7EdlNEgmOrUTmjOZS4LdQo76xHJ+pDd/x3va7LN4TAbCadCMagFioiuy7u?=
 =?us-ascii?Q?HIzOmQE8VmkgMfjTulrjfazMtZ28rzybS3huuu/7q8xOy86v/DSJbcODPuFt?=
 =?us-ascii?Q?lzv1cFJfR+yoWXl4MCQzKrQJ2kFMWNsH8HCBFu/U01YzV0A8b36MK5KRySEA?=
 =?us-ascii?Q?9/1K38KYpMPpD8C5dStTBJ0hayMCxewrRJzQxc/eDbTW7jYywFBou7l2+Nme?=
 =?us-ascii?Q?zURKY9dZ3kodohbs4p49SXKflXj/spS3AdB8Ra0KO4gjr6OGRuj9TrbfObKe?=
 =?us-ascii?Q?QDqm8DTEAAjyG9/ySfocKc4NvTuZi74uWhigaUOImn+UT7LNMfd/5SmlnH9W?=
 =?us-ascii?Q?3mtduLjLPyhEIICH8uQjSIp1GQOrALxJZks8aOIV+psg+oueoEZT+gy/1N6g?=
 =?us-ascii?Q?j7ypKalVTh2AAvVyi1R6qW8hBSe5hmWbWgZiUkqfSjno34xT7/2Djceh/04Y?=
 =?us-ascii?Q?JPFwq2pJ6iB8vNx4fhArX7X3UVcJW1z0x9O7ZSxRQ541Zo8KmvFU+YM+6e1x?=
 =?us-ascii?Q?+D9/wUUaKuK20hVJWqX5y8pyYyWT/l2sl9jLxIu+BKdJbyaaSQ/kCpbWgWGC?=
 =?us-ascii?Q?SYv6OKT9B+dhQ0HeJoloeLswBTVScy58a2RcYgDaJd9wF5lCbZ51fWQ0CAt0?=
 =?us-ascii?Q?D3pAzC7sg9TYFCJzbVKKRBU4puog5clc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1ixvB18NVhYXAP7b/BVK4jt8Y4AzVh8Rv1UWpFi1p6K3yEuDOYgh7nyOplIH?=
 =?us-ascii?Q?fcdq+5dpVELaCquz06CjlHJhjiYmjqM9DCXV9QcFYwcMCzArXdkTBH4up224?=
 =?us-ascii?Q?KOwneMwudxPnli8VXx79ciGBevYiqz24InFbjrzJsWfLaJGYIIsVvuo+hAlk?=
 =?us-ascii?Q?aKXQJjasaDBqUwN0eUJEfSOXQVB/IgiQtY4Pmz3kGc1R2Qn/qjcxNcOJkkj9?=
 =?us-ascii?Q?TQfgOzkQsd7f9ZPDkKa3k0MJlji+2uO8PEmPpRm8ga8NGtIjqdSM/5sWDeew?=
 =?us-ascii?Q?XI+6vvgber37S+MepuUIdo7xdZ7jcazFLvtXl8W9o/dvbN85E20sq1X89agb?=
 =?us-ascii?Q?rV3QfU5d1fROjMUERT/7MwikhV62ouLim9z/TuLxLxNGCHA2UkCsO0XtbzFD?=
 =?us-ascii?Q?iTyCxgXzZj4UyTyFUgxshMQpNiwqLKnP6NGXj3ykjWlRwNIOqhhe6XAafVTW?=
 =?us-ascii?Q?KoBdbuxdK8hhOjvXTuFiane7I/mvVDUTtpxheUcnXzRFfbfzLgixmDdYWmn8?=
 =?us-ascii?Q?e8a3wxsb2n00TuYyF1h16fCddzON9b51AQ1HJCPs6ovAL3EJNRWUR/eNpuC+?=
 =?us-ascii?Q?DHeCPJhvKxkZwqFynK2pCtPAsc0yKc24E3w+EOUn+u7xWeERZrwsaHlVVJgT?=
 =?us-ascii?Q?bPzpCQlGW20vY9K9bwzc8DFthE4nG/1iHNOc2N4e5IBxVBg+5Fgn+BwqzK8U?=
 =?us-ascii?Q?/DyiAtyNl3Cr5TD4knMF4PU+e/DpO+6w28SaC/jKLP6A6jzB3KepJOiFBZtg?=
 =?us-ascii?Q?jCPUk/0Cz4f0qTVOrTogOcTzHlYFmZ6maQqoahsI9ZJVE4RapNyHQJl1co3T?=
 =?us-ascii?Q?weQukhn0kJzcDoSmhdPm3CWB2dBmGmpPEW59zv680QdDXuKyVBEXcERYAtgI?=
 =?us-ascii?Q?Ooy3wOSKp3tj1rOI9IhJndrNRMkaTyaehZB0R6ScdT35f/GLWEVoIW1UOLtr?=
 =?us-ascii?Q?EZBKNgru1IqjE5wIdv607UxaHkNk6apLZEaDd3iA4akM3bmoWSm668j1AE04?=
 =?us-ascii?Q?OgEPPvJNCGbeHGtqoHnFElmGG/YI8CRkSoV0JdbzxsYsiOqTe/WtazAmE5EB?=
 =?us-ascii?Q?ddUBoBxigcLV9lT4jD68pce+6cc9TlOboBmttx5brJ80alNbCZNI+1fK3mUm?=
 =?us-ascii?Q?DEpDLy8l0xcbwHoqWVTV7RfH21t2QnndoLyhSdH1Bgn/9eOfbO2b0EJ7zjWR?=
 =?us-ascii?Q?7EfehP3EvxVunfq1Ox9wX3+017fzFthguijjhKnt9jARe4+9eg3pQx/qzHcf?=
 =?us-ascii?Q?0bTP1rmVsZhcReuNXuYZqxaSSKuMgp+XtvvNt323QUd+XzakB6D7W2O3wsLJ?=
 =?us-ascii?Q?fwoHb9QcEMyeZThTgTzxOZI0dmB4zpytM/7RnvkmIRSwUEb8eGpq1CQwBwIr?=
 =?us-ascii?Q?9jytZ81LWfUFEQjjORBAGnW0v8vMIyTkICcmM6NUQyW9uVIOCwQ1RiQdx6h+?=
 =?us-ascii?Q?hU19uSGKGPFE7UIK7AUa1cWDARcU1/DNwSPA6kcR7NvXjprl+cYTwYGr3d8v?=
 =?us-ascii?Q?7qbJPh7+6SCrNWF2gszm0vKP9T9DFqThhM457y3VExt/O/yQTu1vvHQw3LY6?=
 =?us-ascii?Q?bc3TS4rEDzcg2BHQWTxonJKPcUKqpGPAt5AQv8l3YexrrvdSp1ENJsH9dlow?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BUz0OxS7ElUMx1UxKSAcBC5eKHklaXtDRsMwhF3HA6eu+Zia9XSkwJTAbqpOmoEV/ulRioxnNnWYTO6Luhg8F5ceKGbYKDmFTCS/wUM2ieUk13MmGQnPpqo5mJpwTL1M/JFuaI5XBLYGyEagxqSryX+r87hTvNWdeus9UCMpJEcPeXIrqxG06ay+5TiFY8ESC/1qIXNS/aoi+JL8AIbbFS/ugSg6BLib+i9EiHggPFs+Xi+yOXacsw+xSXbhtm0tHBXO14M3kmfISdeHMAbR4dc6yHnVljh78qq7tmGKJLbqa0W0k/nUf6uxJKZvMAqLf5RtXOQw2V+WPVdKfQeEvpeDhMJX3srqo+eYM95uoLzDlKLpG85coPv3esD7/jgjqFQkwT32kU9Nio9dw5Qd2yk9XtfEE3J9rHsqMJtBaAi8S/PgiQegyKXSqL8XxWjWQepZnz7k0GkNo4qYwmjc3rULe4XweMV+ghfDDpA83OrWqd5Yj8VbKgss423w4sDCzF3Zzb0sI8StK/UFc/8VgL4ccLvW9oftJWB8tXYroiW4tZz64YBtUWwJiiZzcSov5blJO17fBmt5N0ZatD0n7GEqa5rMb6PVezQMpgknsxs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7d4377-2c09-4d9b-93db-08de2c37e2fa
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 15:32:47.7072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +oAYJs8fPk3etRaUciED/xbtlcIZsG4ssCeYC04GwsdonyIZlz6Cg2PiX+fbLpe+o/wh/SlIYBMWYo0jWtUlhvwjCIyTD4ijT7vz5sh54m8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6229
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511250129
X-Proofpoint-GUID: y_YcVEbgPAABZp1ZWh1HXnB7nf4nSZqs
X-Proofpoint-ORIG-GUID: y_YcVEbgPAABZp1ZWh1HXnB7nf4nSZqs
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=6925cc24 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8
 a=37rDS-QxAAAA:8 a=ERQPXu6muckjs-KkJEoA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDEyOSBTYWx0ZWRfXwC4GVUbdY9Or
 ih/suC3vSzBB6nZMcC49CCgYAb01b250DR3qv+hdeT7CZIfRnhWY7UF56r1zpXfMiCF8u+309rq
 zfUiolHBnHILMbsxrdXnLNH5VfR9ONallP89DAhF/G7tqL0+QcFAjdhNk8fLsVcYhi4DfIv1Mm5
 YH1S9Y33AzVox5EZrSWw+GXo4an4l26q6OUuO7aQQxRAB0ZYV9iqwWtzTZ5LcDFVv3+5aaKGn8y
 9uos8tWc/t7eblZq69UanV1mcKBE0thKiYA9GaOLsM6WwoqCepe9C9f7U4fqPQ4QzNE9MLy7owM
 SIPsbkjQO2GpJL6e00r+90wmMoZeoG8Ls+YQy1FCqLRGjNenRmzalzCg+rPx7Qr9AmT9lS2tok4
 dmNaWWZzAzOD3NziWOOYdEekfZ/eZg==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 315691A000D
X-Stat-Signature: snw59pnrjsgzbp4yqeraz9wa8enkmhyq
X-HE-Tag: 1764084778-768403
X-HE-Meta: U2FsdGVkX1+kX/tkWYqkMuSxb2EO1eENiOUGVEx/XTpEc/WAcqsMbdq9+z58iCCC+Pm6y/MWCqUM2TS0IX2AVWTi/6ntZBKM9g19mlEaVHxXWrvlHJPJK4iN66rch/wbcnkn/nf3b2euyKVkLFhvBiitzfUJPn9QaRlF3o04pJs2VVUmiXROF6VpBeu4cEacXPhxkqbi+Z8e7sRaWKmpOaJFLc3BZSIsukZn+d0TWZRYWFlFFttfAMB+RAFTH12mU2o4C+eiuNIvQfPqxr7xp9bAm5TfDxqClHARk1/M1YerP+eOe3h6UAmP6ayL88xupKlZOxiK+2dHr9rfZytU0SR5Zc36SxpePRcC0F9ESNrB1lKu5TgkH1Yvri+SU+IIOmgqx4RgRY1nYuTR80pCRMhxDaxfOPteWcYhVZXg06NWVGZJOlHmBnWahtuuWHdAqhhTxAgexBh8OLTAd7VaKA0JQ5O8VZxDj7L1vWU/rG376OZIM0aocvZbo0a2fvQu9M3HsP/ohePkEjwn05HrHZisoSgzBqLh87GQYslkiTuZ0AUthRtrjTgHUkjSFpdijoJpIiTPQGiRALiaNiVlrqOto24lN2q+myXhowl0s5/6+bZ/lvGD8o/ZDoxyUr+gJISSMMeyc3iVT3hC9o6XhjWcRpy745oCV5fe44zClTrgqQV8W3mHt5LNN3REkHwaEQfBHD7VhgNpb8jqCxWLyOoqgyJmIOUfGUbhRgztJMKXq4b2W3qhN5FrTYJYpICd9x117SfSUUhbZ+I/++FISnD5Il+eDatrpUjfePbv/3+8a6QDfHtJNc4gqX3lqVE03+utakSDbz9gJIBygyUJhteHPVeD0reSjbUtIpI3w4rMOv6SV8HKlIfNlwiY3FWahzWjvADuc7doD0uP+avJhKwEZV1sCGlRzu28WVvb0DEjiqgk6OH7CLGDatdaLTkQaxgeK7ntkt+zVoPdty4
 wxwwK8IH
 epu1wWOqHMRQUhRvuCyXN6LOgkbxISYLiE0VT5iy/d2MZ/X/eNBHF8y5dmqZzioZI/vI6RBPjxeUWGQT6WaHxGBRSVU9VFm3iH2DrQEWxYWPO51sPExvFP+4SboP6jodpRpUktjVaRncMlpfmObrGHomlowepqKKTUXIJbvAykmT+FuWnIOuyYFIV0LSP+9IhXDzEe343+dHwvm11N5tUEgt89Wh/g1HoRGWZ3/BqF7iRu3hX6R3PJovVdNW2AWn9KVsr/wGjqLtn/VjvQroui/Bdhbv3rdMkZ7R4s1XdzNkpd29We3XQS8tNOWteUG6M7KR0IUTqPbSS8NuRbjSmIVaqwnRq+jpCDSHMZrRnvLBkdZR4SIUcbKmuSyjqwsWZhUGRYic65Nsq11e+dEnR4vBS6PrxJHHXPQeisoHm9ObHoeixEx2aACAbkOFlNXzf9E28tT2T6nl2q5ya9Xw/7sOrmTSQfApbXYSuFeOSg/iicv6BNpuQ6Bx6PTChRMnD/71PTMl3IfMbQ/BS6+byALWRS4urp+gubr0ZG+F6I2FEONOrOolEMMZFn2Gx8GhqpFUPtgYB0uovpL48JhQxcLebwn3Na/6GnhVoR9n16MK/98KAq78+dLGVCamroIjGPUE9nU9ze/xmx4IMi63lhrxs83zGBIgAye0Yc+ZaEq8twIBVA258TO5Hwhcbt0EgzQQDYOOZ4E0iS51+dxuvayPLVCJW6cvNfU+WrmpERNIyLBYb/KrSycBjwEUCqhe121NWDb9x6CNYKaBshyzmVkEguQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 03:29:08PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Great thanks very much :)

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6df89b14b521..5243fd0eca74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16547,6 +16547,7 @@ F:	tools/testing/selftests/mm/transhuge-stress.c
>
>  MEMORY MANAGEMENT - USERFAULTFD
>  M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	Mike Rapoport <rppt@kernel.org>
>  R:	Peter Xu <peterx@redhat.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> --
> 2.50.1
>

