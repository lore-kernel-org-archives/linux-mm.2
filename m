Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EBECF64AB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32386B00A0; Thu, 20 Nov 2025 04:58:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B091D6B00A3; Thu, 20 Nov 2025 04:58:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D11E6B00AE; Thu, 20 Nov 2025 04:58:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A53F6B00A0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:58:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35DECC07B0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:58:54 +0000 (UTC)
X-FDA: 84130536588.11.928EACE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF09F4000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:58:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="TFRQjyG/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lGhraz9e;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763632731; a=rsa-sha256;
	cv=pass;
	b=HkN5Z3wJmK+LCmrNEj/04e5l4g/hoPrn2SMEzPhfIm81hDo5f3Zu27MPMHQkibPUkU146C
	5wbWRgdfAO8z36vSHE+dKXQF/1zPCp1zZ0/8V7TzEltlcOA+YCFfMHyHQmZRqP5nmwAY5M
	9+kh+4obzOU4B9Gd9ktwCr1/Dbp7sY8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="TFRQjyG/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lGhraz9e;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763632731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1riJefKwOqdArZ6JV9oLPezv0kzZNkEzPPh0ujH3Y8k=;
	b=DYj5IhvYYR2wk8ialHDfpXAyKz0sCaL7mVZN5TGa7lv37lYxUPNbgwWc3kgiK3KYmnyAso
	qVGnekYDDofCoz5MElp88AQAytx/H8NYXJJiunyx0Q+p2gHp8Oo0CLeb48cd7AZKcNK9Ds
	s8JOPsc2nrkHfvRLlFC5DfMkQQMFFS0=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK7nkWd014314;
	Thu, 20 Nov 2025 09:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1riJefKwOqdArZ6JV9
	oLPezv0kzZNkEzPPh0ujH3Y8k=; b=TFRQjyG/xlOHx3YB65+k9xej9NJCdd9zR5
	MTG+jfpLVWFBlOwJClz6JefoU8Mo6mLbmLVXxr+t5HaNIq4nNjUPSSwdj9u5PFfb
	9PlXRynZ6q82wHcz6ZSk06syN6zM12m1seNPSV4bQ6ivNJF5pZHjZ++2JtglsQFA
	jMUrp3PnzX4zbuJBBV8arWa4KNqQFkE7dQw83sK4KMI8XH5ynFc8g4mLEnWKEJDf
	nzqlUrwI52FE6I7pjudR8JROBwdyMvdsE1pkSJ4irk7gDWStuEv3cUHlWhtyS0gw
	Qr+UTl4Vwt4q3zV1DIy7MtUTAFIa3FdWmfu/7axZZacvfUrZfizQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbgy7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:58:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK9lPmr009447;
	Thu, 20 Nov 2025 09:58:43 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyfvuxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:58:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oq+kwZfktt0TKvamzQ6l5RStB6m/p3OlNYMQdY24nsZS3e4QnzGPLtSgisEtI9ThgR5YlzgDjRJfasCx/Ng5TesPKz4ZWfEyuw2OSeV2BS5a/yhAXrKjQrP8kEUk6xjaREPF8xVm7oQLL2EYHGVz5hkVCSlvCcTB6LUPyT6UvcOhCWZwRmGfL/MkZHkTNFniOCkbYLt2P0GknP3sjhnnwPBCHATkbrc7RmfNEKpT0+eu/EUZmHneHQA1qexIBIsBvhsWFlp6YhQVJEEUYciIwk0pfYGY9rxnthbRT0yc+pBhBm9inGSVTSGKnmIpW9xl91f+nC9+SqLxUTjRNTowYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1riJefKwOqdArZ6JV9oLPezv0kzZNkEzPPh0ujH3Y8k=;
 b=rgtfT1wXP8x3ZSRUNT0O1hpduniuKuFXEJKwa2A0NTYPOgHfwepPFYb81rJfy4688q4qtvMEuuFoysvHvLrdVR0Vs3zjPclDENsaKbJecwqzg3VdoBoMdJCnXONgleplN1APb2iKZ7lGYhej+ST+Z1GxxAHeeUxfuBAF5AzglLQrLnEZo7ZjMliyT4u3x7NMrWaLvUcW+ft9RQ0Ulb6pKnIrjsj89g3WAkZU02U24sQ2EzO4w/Vb2HBOK6voiK1ra0fpsnQKpTYHblCB9h6BkoEMxXRu2LTCVRa8N0Yl+iruN6YezaWRGZjVOa1m8qC9O6YEgAGGe99yU3WCaQxgVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1riJefKwOqdArZ6JV9oLPezv0kzZNkEzPPh0ujH3Y8k=;
 b=lGhraz9ebyn14OmgHr3ja7j6XDGs0+N9b7KGA4ZuBEcxfH4kst/XwuOXaAm7DKABkLaH6z8lLFnK+TS6Xq5LkXgk/DhOMdgSP3AMfMl7g0nXcM2zB4wsx8/IfzuTD3WMkxtgZu+ckPY4WqP6cA47MHG2PN7c3sm5qO8A2NIVPR8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF972B28679.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ba) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 09:58:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 09:58:35 +0000
Date: Thu, 20 Nov 2025 09:58:33 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Message-ID: <75dc53b9-bcd3-4271-ba7e-2762bec36e3d@lucifer.local>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
 <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
 <584eeddb-9a21-4eff-a5c0-446204f9e59d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <584eeddb-9a21-4eff-a5c0-446204f9e59d@kernel.org>
X-ClientProxiedBy: LO4P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF972B28679:EE_
X-MS-Office365-Filtering-Correlation-Id: dfa8f209-4049-4f28-56f3-08de281b5ee6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ah2TiL0v/OS5dFLZMejoN+jCxUY+nqT/P5oLjlmn99n48UOzDV+H5eXJ2Bla?=
 =?us-ascii?Q?OvZ7UQ9SY8HGTi3BrMdmqNO8LmRkcD2NL2cFy+sPsWmuSuwa9LH+hQ9dfs2r?=
 =?us-ascii?Q?sjgvpRuAvYfEIk+/CLGguHxC4Rt/VfRZEwreHWUp4MTh5uW+rxj2X7UUbA/P?=
 =?us-ascii?Q?lCihyFmfjZRVTHnfSBumAzWDe97GnwRIQODT1KNtjmYFvC6oW2dhhV+/m3gV?=
 =?us-ascii?Q?XGYp7i8X+bmvEyNfvP3Y5lLi82gRtj2fVzeu9qIc929mwTZrx6bW2SdcaOzM?=
 =?us-ascii?Q?IsPCeusZXFK4KunAWqDwd+dNDSXkf4DY8LnL4OBvZxnatpHYfaTZcotRw60d?=
 =?us-ascii?Q?ALUNG/KuqVCddQXSprxaCvGmR881eKVjhBzAPWOLmGD9mZmRK/wbjfpbcH0E?=
 =?us-ascii?Q?B/XDTOW38fchl9BrCEAvUwFe8BibS77igihPEY2n8UokUxdry4s2O6LtwmsW?=
 =?us-ascii?Q?ibczrW9vP3+JyB13pq6mnsBjKX33zte0G0vpHB/aWXJcz5YpjBlK/SmDeKCJ?=
 =?us-ascii?Q?3Nl51xD2Rt1hpQUHX9SMjyiIIIRn/FauJO9K5ctkzvYT1ufOb/74zGoympio?=
 =?us-ascii?Q?LiImWhfd0S0HkvBF90tGwgg71k4qQx2xfYeSg4lIzKaTxkuv8H8tqudCCJSn?=
 =?us-ascii?Q?qHeQDaGGyZkbTQ6o97ctc8WD93UTGtyhzKyjLcROu+MxXToqaqU3vP5Nxtst?=
 =?us-ascii?Q?fLQahAnurIhGihAqxjCLcnWV7k2O3sRBVlrosMVXvIi7LPZWs4Eln2/yCBfH?=
 =?us-ascii?Q?xGvIka1wrN5ouQJ57c2AorAF5mXulsrPIOwQZvoT8rCfLgIJ2vkkKoSX+MxB?=
 =?us-ascii?Q?pcEqsa1il8dUEf1/4oHf7TF0qYm1/IDZ+mgm6W6azhRvN/AqIL1D7gRXsrE+?=
 =?us-ascii?Q?wVbms55aIwZqObSbHnmXVFpEbRkElt16vpG9ht4JuSNUPJXqDVYP0DjeD/Dp?=
 =?us-ascii?Q?Z0QjJBhcDafqcyZNgxfNS7fhQLTnwQuMDb3vTPaBBRwvoS4XlDYGf/aBqElW?=
 =?us-ascii?Q?LCsNBVhDwEwCurdcuO+eTv/my5zgO6iPFQeHRJmGHFo/mIsx0mElFFcTGAMs?=
 =?us-ascii?Q?yXGEXT9x8hanI7A5TNjUH3znirdwZPygKctoL1wHpOdICdyIqx3vBgFfjros?=
 =?us-ascii?Q?uhv7Wrl0uSkhLS9Rd8VOdnrkV5Uku93DofNOcl1jMfENpI27qgB6SyLtCcSr?=
 =?us-ascii?Q?zwQbpWI2evk59Hbs6fZS/uuShdvKIiekH6A6yUpCrque94q7ocspfngGrvqp?=
 =?us-ascii?Q?kYK1hkDVRyklsE4G5YIJYP6/1AtQTar842GAWoKTV2VOc/fCpqVR7lke4WSe?=
 =?us-ascii?Q?9KEP5Nt+rTE06MhGS02cB7ej5QAmMkbyLwsarFFPQlQTntmD9v/Nrw7dT/1c?=
 =?us-ascii?Q?h/36k6ZTvgKc8ZzadkrNeJ/zo/LZvTD8vC5qjSWHZ/1Aym1VmhZThyxxXRNt?=
 =?us-ascii?Q?JVWeUlJF1DT5Ki2F/KP/u3cuigGYMLmv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0l1mMBwdTmRCORNvb0Mz0phXj6uMKpPfG5b7LYNP0eN6sbkSmR1+WmdXOASi?=
 =?us-ascii?Q?5JYemNsr28Hd/LfkMuotMH2kzmhflLa2/heZQWOZidYJda7ynZagifAyshtK?=
 =?us-ascii?Q?gLLANgsg5MelasLFTfckdm18rk7Det5i+I8s6yWY52Qj2Rb3wY0SiZm+FbKu?=
 =?us-ascii?Q?BQkf2AboBgjizzAqfzUmN+OVQuYpCOmenI1Ll7ApME/wwTnpK4FtkAQx/RMd?=
 =?us-ascii?Q?x6/Ggbz9KAhoAds1iuR+o/cPp0o35DG5OAFdzPzdyDemyXLTH128KE4pLaoI?=
 =?us-ascii?Q?lqC/fiWaHyYyirYatijYPy60y4CokQnkETvN3raifOFz2EUj53p26B7He2wr?=
 =?us-ascii?Q?+0IfTF9KSj+d7dpIsdURYqYnou+xyp66txb/rEqetKxzUqtpORkqIg917u/T?=
 =?us-ascii?Q?DXZqtFoKXwT90sjOfftOiEUKJMTiQx2BIQ5c0eG5xuh9F9o2gdTCMYh1gd/k?=
 =?us-ascii?Q?rgnlUus3jAkQYX1g3qRkYE01Ko6WbsOk0lRnTSB0GI/Ue8LcP6lXVZ+T2Rh/?=
 =?us-ascii?Q?cOhHdd0KotG+1FJ2dcQPr/bPwY6dqsK6Wu910vJG+Oywsjd/m3KGg63n0Ipp?=
 =?us-ascii?Q?qiPqdPfnRydNBLtFVAkMrarBpT44ltrcSOFfh+fBkXi+vYSrmDdcruuupyGO?=
 =?us-ascii?Q?+B6pzYdw4nGfMzHlQvLZs9GJ1T14LfDWAVNkZ/RfNYr/t8Ud53Nt7zOEsBTw?=
 =?us-ascii?Q?/eORC6Z0VNDvGI0HmH8eLChmXFEUAiG0EOyidS6TiCLjaiC6u56IcOvfuVwT?=
 =?us-ascii?Q?nJZoPWzYjNAjZqgB2OaTHVvIa7zql+4JgQDTqkAjaCsty0MyafRk+xlVtBdT?=
 =?us-ascii?Q?wDO1RwQO2bBuuSmbplZxaf6LtT9ChjGq2P1tguSOJtVRUq3wJ7K2+6MAd/KX?=
 =?us-ascii?Q?GU9I+F6H5d+tEECXlprDMCyQXButbgdwE8MpKbMv3fMSugGqU66mbR7vd0tT?=
 =?us-ascii?Q?2f7/J0drE+iNrZ7w+9aQzyeI5UDeyBZ/ziNk1guiF40OpaJo9XyLOyL3iA/y?=
 =?us-ascii?Q?Fh788o/N6SNfeHf+pPHNbIJhnyTEv50CxrJvQpxzQYa+Gch5YBEKS/IpRWyI?=
 =?us-ascii?Q?DUaHkhXBxNCuH6fnuBr4daTKvaXVjReOFhKlHc6Wmmt+uV0kkKSxjyLxj+hP?=
 =?us-ascii?Q?J3i644On9pLP1vJtq31q9L+CWlGJyLw9F/5yNPBeP+Upyy7sDVytQmLs1PlQ?=
 =?us-ascii?Q?fpKYCflmT1fMnQDjsyXmL1u+2B2utX5JpPLQ/T5jEGv6diCnQnlfEPzKkHOi?=
 =?us-ascii?Q?k0xzrklMyHw6HDZGCgbp6gWbt4sjeQr4WHSMQjeVoh+lSL0i0VjXmJN5PIOE?=
 =?us-ascii?Q?pczp95Zaz6QKmCc0ODHP0WRRf014pLyeoVLWlD3kAusNFdk3REOeRd59sUyy?=
 =?us-ascii?Q?uaRN5iwAZydfqbG8fL7vK9qZa3/Xh0xi9DOWHYh5CsvLJ8g5bEeHR3eJpwqZ?=
 =?us-ascii?Q?r/AkxsZ6BTk3Nwas87orPe/sHqMYSY/Fm2WPHDANACDQgJhyS0V1lZNkOphw?=
 =?us-ascii?Q?v1Yi7Im3u1cvagfudGFVYniJ0QwBG9iW4Jtj8o0yxHO2SpkqJt225KpTnWGC?=
 =?us-ascii?Q?DrhyHg9iNQUC19PqTyd+KoIzSSn4FcrRE+55F7kwOpaKJIM1P++axemK+qMD?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FuSgbGuH3sO3g2ztpZb5HxZ08Wae3KZPeGMOAY1wQI5lWT9ti5cftaqG/j1jECPLlJ6+U/zNhUORYetUfjFxcuxms0jUUlNB82dYs4+MDjbBumB68YRH7LlRNxfau1fucele0E6sEvIjhCX0CrQgj1JZZVqGPWHDRIAF8Ai6MFa++D1oYJvhbrwPtRdn9vU5cl4SK8SAbla8wA3iyJDV4qlnlAD+P8oJ3eW26ycXiLkqab0PczPgUdQPgTJpCh4aTSqvkrkBk9dlFci+yQGNHx4nZrBhPxoOOaMa/IWpdlKkZNOj52zXEVtww7kZgtyTOzBODJEhxK0UVRqw/OBWoXFULVQB1TrFF6Fdy3+p4pNUENKkMKPzC2mq1/93I0p/pD9oqC1/AQHsrZfSrE2cMVetvJjGeR0rAuKqnoiqbZ1//Un4+6e5nuzJYjCU8zNm5ci75JMnjckAWOk6gXbSw4OZUeOZ6y3ykNpfYRdLtQs5sB0bd5fmGad9t5VshFu1ndcCMxg8d6aMzPcsJ0FDwBgK6jkZQO0k2zKs9TaAgiLPHlGl5NN4L490edY7daZp7kbekPxAeC35qvsEGc1GS2yyExUkTEGqW8MVLbLC4jw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa8f209-4049-4f28-56f3-08de281b5ee6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 09:58:35.5414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LAurymp3yEQ6yv0RxM/mbb8Ii8lxLbUi2YNveVvlMGb2T8kydOKasEwft2sNstJWHbCstOuUZNxoJaYpdF04NiTW2lG4VtN/TO5+1AXpvq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF972B28679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=966 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200060
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691ee654 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=YRa7Hh6aQDUDBQHqnZMA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13642
X-Proofpoint-ORIG-GUID: 89fLFK6Hd19jdCpsfjkSD4xL5EnA0hYp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXzx5US+K3ZF0o
 Jh+pLgtsN/n13KWXMRvk5KBC9x8v99KLG9rUPsy2stTUq0i0gFClbIIQCxN/6Wgbae+HLTLBhuh
 9tvGUKsaZV9/3kM3QNtdNJMij1BT20CGt/8KtNJTUFx2SWn2mpHGzO9Id+WqoDcbBwEAxXgm/uo
 zAc2opkHzoQA8bO5LUdlZic79KUyTYy6EU/cQiiowPjSp//uVVgq8P9j46TlBhxLbG8qc4NWdEQ
 F7o16ADehk7ob4RUDhWMx/I1o65M0Cu3PwRF0AZs27pkoAkf0Y6ZmNET2OebXaEClbnNhJFqEbR
 5e2PY1qohAQy4Ko8+OntXRzftwlH+SDd5+LZTxy2Dnmi47vpf6fB019cmSToGQBW5Wkj9Lz4fx1
 +w2JIi+kiMNNRoRXUNBqXeB070otk1z9YV7lhmKWceSIHEZeVVI=
X-Proofpoint-GUID: 89fLFK6Hd19jdCpsfjkSD4xL5EnA0hYp
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DF09F4000B
X-Stat-Signature: 79m8b68fruftoq7wqbgn75ur3jzqo5hj
X-Rspam-User: 
X-HE-Tag: 1763632730-699781
X-HE-Meta: U2FsdGVkX1/rQs80cinMSALtWlDF+t3zX9/SCOmEZPhfyyUQrWJyLf90hl5WQsJl8RLSKtlfbFHJs6cV+G1MFPVnmwAy6i+KSvvhto/u2y6PmoP6hpueCcT2Mv0a/fnnd28jELAovymucxud4hR15boa4bFgFCL9ica1LRmdgRJjvG12VUmXXrviVG7cv/M304l7AfOTg3R9NfwwEdr5av8i1E+gMngbs8GPx75bCSLFacR6MCp/9GZiepmKyXd9fBJix96uojSqpZVvd9WabOW8JlaDt+mv8GzejTKXTEW2azdHaC/m6/w8fWkUNcwgklEQtrk7nPHj9bfKl+/xjwT/7fzxIZ2+dDglCdce3N89bs1ZduxJioilKRIaNiwGchebkR1sf7qDx6scOEbpG4pAS/A5aIFqO9Drseq6Eh/pSATLCTT4ZGKDnmgZR11zWzFpCGOcGoLy/4R2NvJYzBLJZ6qw5dViRGG2a0G1rEkeaZboGPxmvI3CtF4m6juOtV6aV1XA66nFo2QapkeLkjaPIrerfAte14TIyt7BYeJPN1nR6j0yBujrBxxh3BBDuO2XKQ95RIN6fIIHjZY5o1bHnQi2Fb7III5ltUba7HxHgmevB/9+92FlztK0zZ2JkEgX/fksS4+/POeQliFQ7ct65uOcrmF4MhQ5U+zESTtQpiLgEhHUZP0B2Tn9ECHBzLrq3jl0gglNjqGS7szsCrhGDilsrYRAQD7jxMlbWeTSEEBLXEQa3v9WhM8Yg02PhnsyS1j/pVxU5L/r0QSuV1TsFbv6TT0g1leB2ypu2VoynMPrlUOTBK5fKw28W+CRL6FA9rVB3jRVtS617U2AObqAzfv52JQo36bkWKqVTeu48X2qq0CLMfdXU3ul+/ON0VrWml9iR8XqPtzqQ5Phu/Wbm5YXwFTDo2RZQKo7K6sdYY1DzXQZT5ne7BAkL4dE3Hs8hCJjiFMVRMkwfVm
 B3L0LZL/
 QJ0XOLiXhOCms/LaGeryt5NHrku2n0h7cJrf+PpiPsSBUUtXtn/kMpQ8+YOH829iaDsCPPr92KCZl8i+MboknzYqDxMfPPN7BN62k2nJZsaUiqLlRsuyo05PMaZt3I8csFfmzjldil0+WPTssJ5QEeacvSvqFxU2ZNrKR6Dxp6RcO7XXpGfeaqlPaomf0hbBah5KYVaVWKFsUs2AeqgfUo5sByESphxQX6Q+QwQv661Y+JUV6V8KvQlRu9wTX+T3iyWH7XftiGz/h+ebXkLE+3AqfiL8YRibt9JHwPlFS1mtaeE8vTbPi5J1A2xhD3UAKtKsRNjXGILD2QPCz9X9XGIYlS8DBeJ0BRcjdShc59dNWORqtQj4s/gKReL94enDI1iINdb1iNwg85t90Ix30pYDTXOrMUdpPZY4RjguZZJ7pRHZ1MNX4ugGe05XVLmqZiiTNryzvDfLbvi6NbbC9NbX90cMNTN9ZoBEzHsXZC30LMI7u3LsHm0IpCKj7v+FHni/38UmTjAXAuOb5gciOSjgNDjjE4Pf0gfwsf5VI3263uY4lRLvkPh1nm+1MGCYqIQH8Zdna/UbbHTavDOj0AP0tIdK74jHhQfiaKKSdbCNWXZmp6SCcv10+0YRgGATxtMz9EGXDNPiKHGI3GR1PQ7N3Iwt//0fIKVN+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:49:59AM +0100, David Hildenbrand (Red Hat) wrote:
> On 11/20/25 10:35, Lorenzo Stoakes wrote:
> > On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 11/20/25 10:04, Lorenzo Stoakes wrote:
> > > > Hi Vivek, thanks for the patch.
> > > >
> > > > In general though, let's please not make a fundamental change to mremap()
> > > > behaviour in late -rc6. Late in cycle/during merge window we're really only
> > > > interested in existing series, series that are less involved than this.
> > > >
> > > > On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
> > > > > When mremap is used to create a new mapping, we should not return
> > > > > -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
> > > > > the old VMA would neither be expanded nor shrunk in this case. This
> > > >
> > > > I guess you're trying to be succinct here and 'clone' each input VMA using
> > > > the 0 source size input.
> > > >
> > > > However this can't work.
> > > >
> > > > This operation is not equivalent to an mmap(). It may seem to be for
> > > > ordinary mappings but in practice it isn't:
> > > >
> > > > (syscall)
> > > > -> do_mremap()
> > > > -> mremap_at()
> > > > -> expand_vma()
> > > > -> move_vma()
> > > > -> copy_vma_and_data()
> > > > -> copy_vma()
> > > >
> > > > Essentially copying the properties of the VMA to the new region.
> > > >
> > > > But this doesn't work for PFN map.
> > > >
> > > > At _no point_ are you invoking the original f_op->mmap or
> > > > f_op->mmap_prepare handler.
> > > >
> > > > And these handles for PFN maps set up page tables, because PFN maps
> > > > literally do not exist as VMAs which have properties independent of their
> > > > page tables like this.
> > >
> > > vfio-pci is a bit different, though, as it uses
> > > vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
> > > insert PFNs, not at mmap time using remap_pfn_range() and friends.
> > >
> > > (see vfio_pci_mmap_page_fault() )
> >
> > It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
> > bug there:
>
> Yeah, I am all confused about expansion. The example code looks like all it
> wants to do is move a VM_PFNMAP mapping.
>
>          if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
>              MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
>              goto err;
>          }
>
> I guess the expansion is because of iov[i].iov_len is bigger than the
> original VMA?
>
> Is that maybe a bug in QEMU or why are we even expanding here?

We're going from size 0 to iov[i].iov_len, which is saying 'please make a copy
of this VMA at a new address'.

There's never any moving, as input size is 0 :)

It's a cute corner case way of using mremap().

We're basically asking for a _copy_. But you can't get a copy of a
VM_DONTEXPAND/VM_PFNMAP because you need to invoke mmap_prepare (or legacy mmap)
to get something sensible and you are bypassing that on expansion, even if it's
a 'clone' style expansion.

>
> --
> Cheers
>
> David
>

Cheers, Lorenzo

