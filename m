Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3A13FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4EC6B0088; Tue, 28 Apr 2026 04:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBBB6B008A; Tue, 28 Apr 2026 04:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9D36B008C; Tue, 28 Apr 2026 04:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 036666B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:32:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBB89C1D73
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:32:02 +0000 (UTC)
X-FDA: 84707296884.15.46EFDB5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 326721C0006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:31:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Y7/m4e6j";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EyXKZ2zB;
	spf=pass (imf20.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777365119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDa8igQGgdmNgsXlR7ezqEIK53H50Fj/jTc0eX0/qrE=;
	b=P01O2uTvyznjPh8rHzBWjNOKkifANhUtP4SNF8opacypmqMcuOIGlk/u1pzDWQTdy28SKE
	QTb6RB9zi/NBJ8xqrqf7zLhgO3RAA/Cmau/QX8oTvhSP/ByOroPd4nvuWXEq/DQRi+hejx
	iY3qd3vmxqYBNtDlTqPt/eo0JEJiV9s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777365119; a=rsa-sha256;
	cv=pass;
	b=VXVoiBGR7Luo23os2pH639FvHUfeitgfFOHAavC10E1gC2D9BmeKbicLyE8H+fZf8iMNVN
	jAILye6d4FZw2Q6H159WIFi9IAxhKk00qUYLZ5bB+zkMqHTUBbK2Hb0dIRL9iqsR3pO3SS
	tXuzadnWpkjZek6jaOdXnk+4J1CxftU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Y7/m4e6j";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EyXKZ2zB;
	spf=pass (imf20.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S8JMGY3055256;
	Tue, 28 Apr 2026 08:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EDa8igQGgdmNgsXlR7
	ezqEIK53H50Fj/jTc0eX0/qrE=; b=Y7/m4e6jyHgKCq1BkedbUMPjW2I0nnkAYa
	DhSGHvw19iSy2mdbPVEjlB9C7tarfqhofXJ2g8Mp8ZZjp26qHxLGsueU6bYTtA6l
	DRNtk+uCA9dXNfh+2Rc3N2JnY3svF7ODaSlGVmMK+yVgVLHPbVxYCEhXqxj6A6Bi
	8j9SOKpyZuhDIMZQZY3XCjMfOYT3Wp7bhOiBjHeQEdNfGGgscfXEVqV1C2A16VaR
	PvsZDBqlK/Xv4W9T+lc1Dlt72N2yK0SAGfewMcBX/jPKgLBxSc0jOcAkuXDdgnJl
	pPhNtg6OylKC+hA/M0HEY3GhdIWlwyqLnP/9EmeEhyO2/oUaDcTw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd5xp40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 08:31:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63S8QEHg019685;
	Tue, 28 Apr 2026 08:31:52 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012015.outbound.protection.outlook.com [40.93.195.15])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cp6vw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 08:31:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LcnPgP6JT0aVMF7jOCzQCpUuRqUzBbN+PERcfmUgITy20vk05kNjSEWx886edGnUmFq237Lc8m/cSc/BodDZ7FKhbXeO5snkk3qXt8JGPKFrGu/f3GAuar+jwj2d3OjCR6IQDALuWvB6M259FtwuQ7IjbjEpAVvjs/fKbTF9W4m8qdmc2BFshpXppRjkR2sA7ukj5gkzFUTMowSvm7aKtXkNUBw58PVjUkpty8vub2iuTHI5ShW8KNJc/sJvNUB0Q3r84A2pb5R0AOtZG/Afu1YOjd6qhwsBYFyzgEScOhoKLGHTE0drkbOGdrzo+Z9sYTT4xS29ddpoiClKjb1vfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDa8igQGgdmNgsXlR7ezqEIK53H50Fj/jTc0eX0/qrE=;
 b=adzJ8Kaw7itF0ygxuicFgeG2sTeASXX3k+jQmLoQo2hFselM5pTuz/xwNANjIeRe+oOBOX3RxFASlU48YG1WKRjtD/hp9gRusbew1+lojoRKcFrZchVCtQT+iag63aVdvrmQ9ObwHLqb8FpOon0cAczHBZ+U4vPNeEHEja6qzERsWxY2Ix8pswJ+djFY9hwVBri/5iAKcrNgzbQtOr2ib2lZFbPaabDZ4wT267NVari88Z3qjeziy8pMPzB3EhEh/Xhxe0r5i1lw4mVvkWTPWdchlrK4GVO2gRxdNzphcYvcHnZYfJ/S+9Byh1Oi9vLE8qZsKqNiilDn3jwAwhU/1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDa8igQGgdmNgsXlR7ezqEIK53H50Fj/jTc0eX0/qrE=;
 b=EyXKZ2zBrlP1oeLr5YXYTt72uLRacUyIFn5mgYYUPZ+I1yONNEikL9juTXC+oHSEz59qarYwxFOk5v9ZCIfht8Ri64VGhBRZZL5y7QhnL92uEBbAAowfCEwBFfGq3onX7d0FutbHlmZPLH6a4E2nYtmOq1qiSC4KdImodLLqPHA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by PH7PR10MB6179.namprd10.prod.outlook.com (2603:10b6:510:1f1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 08:31:44 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%6]) with mapi id 15.20.9846.026; Tue, 28 Apr 2026
 08:31:44 +0000
References: <20260422102729.166599-1-hsalunke@amd.com>
 <20260423041249.156eb95889696ccfaf23dca1@linux-foundation.org>
 <ef5ad58f-0641-4017-a199-defd25430bed@amd.com>
 <1253ca14-69de-418f-8f94-b08e8105e924@kernel.org>
 <f75e03ce-68d1-474a-9b85-157f73af48dc@amd.com>
 <b0243130-dd6c-4c9f-bbc2-7458aa0615c9@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Salunke, Hrushikesh" <hsalunke@amd.com>,
        Andrew Morton
 <akpm@linux-foundation.org>, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rkodsara@amd.com, bharata@amd.com,
        ankur.a.arora@oracle.com, shivankg@amd.com
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with
 batch page clearing
In-reply-to: <b0243130-dd6c-4c9f-bbc2-7458aa0615c9@kernel.org>
Date: Tue, 28 Apr 2026 01:31:43 -0700
Message-ID: <87pl3jmqog.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:303:b6::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|PH7PR10MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: ccb0a65e-2c3c-4a2a-60d1-08dea500944c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RFZ404a0ozUDRjtjuV1f5TqwpHm7Fy5AuuxLy9lL5TXUUD+kCvKYbONWEY0bHorxxm7cb92Q/uMPDyNWQZX/gZ18OWw5tJd6taAOOlqmqwBSAvzEj7MSEOzo7E3kSJjAdFNaMgW6FnKduuA6Ohw8J+1FAcCg5WOWtoH5xiTfwQkXjZ2TdHnrhqMAXtXSvyN/X2/bNy7W5CHF26soDqcSyHiyG9B2FEjwGyp92d7LwiUXsmUFjIkG9YJAeCwbK9aBCpsIHxXNs+yEVhZ6jhQZ8u7stYGZ6DfciVyzvWLGU6IRJYODC1FfeH0ztcviufdNvqdCTzPbN9ZGFcpxK4haJQOnGeOdHmWiGjjA38HdN56d0N/hokiUSFUf6Gd9u01JevjNwf0EJNPzt58S2KdC+q26d7Z4XIEYo2Qz6vN+IKltO+p0nXCv40H8j8JEhu1FRd+UuYoD2UAeWQ2TfKIfCTFSi/yug+btj56jqvIvCIDkfntxR9u5nDNfa+WcSLsU5eqs6D40e//Vv2hL9QM6+94HvPLJkQCGddxej/eIOUohBNs93T0c+DidI8e4IZNGW2ihYXIptyBSyin1fTsp+6h+dyCe4VAbF8H5wVfc+n7JfpChtdxsRf25GiPBp4vyCdfrLchEm69aFnlblPNhE9bvOnS6DQO8dWWEEe23155KM19H7rp2fxMmr67fQQyAenerkuwWWTZ88h0/GHJi8AfYxhHUh0NTwrxsYE2Dnfs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BckjU2wDkoFAYpnpAeOIOFyzo7ITJOrT9KTZTqAzk5YvbtBdTF8wcGM4oscW?=
 =?us-ascii?Q?NsRkhwMPZOJJVaUMJUGxAAAwNvF4Pc96jqQgHR9C6yv8lzK/8aqaqAuo6GQs?=
 =?us-ascii?Q?yvRU0UIP6OlomB+Dtd+8Rxwas5fszMHIBZpa9UCK6CLgBAVYFdBTYVtbSDei?=
 =?us-ascii?Q?VtE2zWnrPW+3NMQj2dP9zMOc3+nlW05cuDhOIvJJE8Y6DrMl1Uo2qXrFHqrd?=
 =?us-ascii?Q?9SeCSAlwX+5X1EyOov5HOom99yPC2YM9gLv8niFeBy7QSUcO0exS2Da7PLBl?=
 =?us-ascii?Q?M1YhDCD5DhnUQlQAyK+GmTCvtm+73vNMTdaQkfp1ctKZn7uZR0GXkg0kOzWE?=
 =?us-ascii?Q?r0CnUZ//ZWKjiHStPDpCSz3O++KYRsk80QA+CPV3ZSePlnAcJLma1lairNRd?=
 =?us-ascii?Q?42ijsXKSWPojDyoyfvesH1c7xPhG6keC3rrvLCDYzZl3XQMtsRPKJvsg1NGa?=
 =?us-ascii?Q?7kF2TKPkrdpYDDdfhYpKfrSuVT3qcUr5EWNljRmYnLz6HL83O55Xcr5u5MvA?=
 =?us-ascii?Q?iKtKLb6wEP7OCCgr0qL0VMc8jb/idmB0r37TYzzeRCynpvt2EYl23n+ngg0O?=
 =?us-ascii?Q?R9J/fkNSSZ3mnjqKeULRJRzrYz7WdgR6hKSAFrC0rNove0cMCIpwmRk/5KmK?=
 =?us-ascii?Q?qPPzmN8cNS5jhBQevemIei/mv3ZNe+Ey+q9OEB5nZ3gjrimvUfJa9QRNr2Km?=
 =?us-ascii?Q?tL4wo8F81ldS7H0y29I1xSpII+A0prW1Orjh23U92kCH6ejc6hVyjdcyUhrW?=
 =?us-ascii?Q?FK7pWLgbJXErKGqExKt44pGaYb473KVBo/fUgNjjHfIqDRPnTWDYBsZcObzu?=
 =?us-ascii?Q?fv2OdifkWbkqajRNAOcu5SdtxN6/g5SNx4I+sG6iixiQPG1ZZsZKZGMcIc3M?=
 =?us-ascii?Q?Mfzyd9cKVT02QGjcjMEDk01GmX9d7PwuNZUAyZxhBj27Vu1H8PUpu05amO4R?=
 =?us-ascii?Q?XFz+Rttxvd6VrWX39c8Wu01MJSpeTzdg7Sh5cazr5bEXOXri47441+kVNG6X?=
 =?us-ascii?Q?0hoUg85wGPYijuOZEPDZGhvuHgI0T8iA7Bku9a+neaOfqVe9Tzqb6aDw3Wkq?=
 =?us-ascii?Q?K0MyA7uj0fhbXf2VSA3tCu54lWMEyvhIga+72JaDSTfqCvPD+HWUMgFTJ2Nb?=
 =?us-ascii?Q?FI0V6KTTaHKOG/Bv1AF+C9ZxTv+JYy5uqXxiHCX5kmcFATrF8NP/fI6455q9?=
 =?us-ascii?Q?5Q9VbRsgzx/FXSWt4ZRQIUTgIQX2GHb4SUj0Xm4qHlocejmupBJgmfZVc2t+?=
 =?us-ascii?Q?67Jpfehtih3bWq8/rx1Rm888dAbp8u4MvL9tY8d5vxL/ksX5Jq/aDjcXYEqt?=
 =?us-ascii?Q?sEQm4K9hQWvRnwM0e19oQR5JoaCnhQS5txUrh8S3kkzt4GESwPud7lJuPuIz?=
 =?us-ascii?Q?IKgrkZRucwNiXnyMlOFPHc1veKzAe6caYWjGHDtB1X0FBm0vjTckCfI6DXH1?=
 =?us-ascii?Q?7+3PIOn29LkkKAVp8epneEJMIau93bDIBvOGHXNm/XdWFGGaOHKiah1ltl+x?=
 =?us-ascii?Q?QYfsA4a+TtsO2zpmWZR69qnMD51ho6lJqX10PEEX/cO1DHAKha2bOtGCd6LU?=
 =?us-ascii?Q?46YjunfJWVkmuCRDceOZDGwiCEUJtW2ioob1+khbzlgMlAx6AHfLFCm4Xeui?=
 =?us-ascii?Q?IFZhN9EDmMGXFcDMJ6KopPSTqx4UyY4lOChI0HSar31Z2PX6fLAgQ3Fb1teW?=
 =?us-ascii?Q?HOEaL6sAqL4oL1QAE0F8BB9RI3Fa8dZRMvxXyGxrTGyq0k4nMQj6eMoFNK+5?=
 =?us-ascii?Q?AeMXJOe1jOiSLopq26c8FbdSlnabAy4=3D?=
X-Exchange-RoutingPolicyChecked:
	sDZg6BpUIb9OOO2S+L2+nnsRT4ogAqsZcvYKRfREAS7f2SlznkImZ7uPomUzmC8/BxGyC589MpOFszthcfpF8a8LotgNtKA2XqThZZaKriMYoKEzk7m8G792hVHppVJbd79dfHha4Wmg1hb1u2H12N/pCD/FMdaz79XSHioHB5jGjEYQjq8ulMqNWc81cOVRsi4SKfcGStZw5A1tH8DhzgHJ9Ddi347mQmNpkEqiBkVdAzlKm3ltS6fM/ap+ohPxKq3fbbAPmOLicOHwprl8mGzB5P6Qnx4ZesePkniOVKgA56XmM7WeRBGB5Dyhk0+2TuQL1qzhojNjkVcqN5W0pg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PvjLoylDW2J3FwQl2vc9q/N3jV18D9c8ZXXOy85n1kPkKnjY6ljpCUiUSw87rW8jvbESY6bf5NrJGgHcw4jwUAMsw7D+tzHOqfT4OB0PfpebejOFfoJ/QzDUlr3X626y/WrSsW31xPMruEKpxiX7C3+CZhT0QNGvSIz9vBEIk1HromQ5LUvTrKWwNGBzwvOyqgys03drXlR2ETd3KR6zio5KyLTbXGcI9gwuvpG5S4h7T0OwpwsrFojyX/hB+Y65MIanHywICMhgoanJuG0SMN50XM9nArM1/I32Iq4VVuHbnsbhYzeWq/I6e/LhQay5JV13rkbZaVKDK99q6hpMQcqRcI1TjitjjDWaK7opURqYtvDzBmRqHI9RmXYzGX6yWkM/B3yh/8CCq3f4pfLeVl2TwuXWg0rxzLQgibPpmv1Ykiz/LpydWXp5LxGjgEU+FnrFHSY7peX8OZYuxvWHJ6XEYqEDPfPZf5TSG97KJNbHj84HYGRiYqK+RhUwdtsWP7JmDl11WHCz7B1TOhiaWmVAg9joqMNEaCC9Z7yhGilBBFDcoXxXeVAMmDM88YDcx+SjnPOc6taUJCqFDkNb1+FqnLEjPucXIEyOzYyJFLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb0a65e-2c3c-4a2a-60d1-08dea500944c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 08:31:44.2761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lK0UK2QXAjiigCMSsgTFrqeHeozxDRNMM65cZGK1eEDdnYDQAenFNPJ+KyWaRF5RO17PyYvBqm807zAN9nVaHUWwhAPnefT540/tjJorJzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280078
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f07079 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8 a=8jEbHYuInRpzOZzehe4A:9
X-Proofpoint-GUID: aWsUfBgrsK5dMrh6Hj60swxJpL-YtHJE
X-Proofpoint-ORIG-GUID: aWsUfBgrsK5dMrh6Hj60swxJpL-YtHJE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDA3OCBTYWx0ZWRfX6kfLVSSdeCH2
 Chc46D8pZOnbgfVUkI3Vkxmch2hvDXd4nqY8hC8lQZc6W22myHxy0YdlyeY4FXq3Xc9FlIeoS9E
 IEcgMLGTY5X0nbdUyCzbqaKD4Qv3I/h0A7Z3rBW8uTcofR6a+dO3cJ4JI6UCHRsz3NN8ZnwNB7/
 tWBqQzT7iRtSAWtzhAKX6AKWsSzw2EqCzDv4R/ZZawRRzEjvx2UQuBE5j1L/KhD6qhKcGNVsQIZ
 YLXoolm6b0UQYJKviDtBYDiPhURxsqiSUu9vJ6k+a3GnnsEqzyQzdgVTXeqyBPTALEZ1CrF5D7J
 wpeQhzLtwZ31dcsVEsD0jJXb9VqVGXuCEy5PbOyp4lEs3ibVtDTRcfOV65wLUbzCICsmlfghbax
 OtREJpPJEwT0ZmBf2QZQ5WBgq+i0Erlppx5oQwGCz/wWbKAgV+xejEiTjNcGOLsVP+WgDbRcjxS
 AlqK4KFLi/u9C76WugA==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 326721C0006
X-Stat-Signature: zpcwzohu7cfu95s4x7fdxowduzixgufx
X-Rspam-User: 
X-HE-Tag: 1777365119-121709
X-HE-Meta: U2FsdGVkX19/kpk4lt5bU7na8EiDwT6gQROhnt6//nj2KAiXaXa4s2slssv+9IrNvKKFE/+AXXcM4GmvE7raN+7gtzSLj8PGr6khEMorZtlyRxsesUz2bI/KchJajrJFPVakQuhshEYKvUyR2BR6wEj0LtxJPPaw3vtMIK6HtwTcsMmIUeQIljt3yS7cm0WLuML8+VV2BTbpIil7MsmEdx9FOOke2vmtjmBEHnsJSZPRd3HKO1pxHdAaal6+AVlA5wBjEazO8j/ZuXePXFm0r2DqKdEqGFceHB2h3pZ5BXDpfD84hEJ/gGy3QOprs9K9Ph+8efZdv9ZRgTxPvDhZ7xuXFXUQndOFq2DqxRWXmlNG3zT1MEiyw4qwxs8YS1L2Y30VX0vKBomCaAQuMEjb+K3HUxYJgbMFHIwvl5cxqpwBgqclxWRo6I/fzlj7uO/CP2RDA5Fiags1a3D2D+ia7rXEIvkgXGkCtSy/55KEWx0nj19KxG/HRaNB86FNrtNXg4GVqpPFIXGGA4wbKrJCMdI27cJH6gVIMGrP19Tm5lOOkxKU7VsVG3/kMFOsnRCTRG9A0MkTUhr0sanuHtDsZuZDPFUMSTSHIQXT1cafXzqheZPbzAx9dgCZ/3K3p0FsCzpaxMqO0MrBoJ6WXmiy8tr5mZCf3tSVTZX6VGqvCHMemr5vbvhiCaJdpWtMGEgGS57IHmDRo3/6PH7gumBNGmJfHcIfT3iGxOAzcYB+HIldEBA6MwVQEpJCYluOHCdFdmh7fh+yXOc1AeYgzqKNOo0bb3chR/b4i2U6VzYHWF7H6wyyIXSQ9DEvyWRaFSR1uVwdZnTReIjjSEBMyGd4sz6ivpS91uyetzeHmnACHdCxmQDba4mlVVtlzeGVoROLWZmlBB+pqn0eXZoWcBPrl3CIAAQxMDSqTEmfzuzxPZ5R3o8TnsLgWRn0z/QXnrbygfoNXj9QQFrWFcGIT4/
 wGX2jP8W
 Q7ox+0oeXKki02Trk8kdrc5t+Ga7nvbuszTwSfjQoeBap3GfNi/nfC0H5ghou42QP2Unt5QseyHS+hXQY5SFlonfTuLrmtEdgxFG41KOL+3cfucP9q8EPsO+fLTFE6T5edvUdNiVkrLAewsGLoe5u+42Xu6RGqRe/bwDjNIwMo4uHROAsrCu1FPRDawY9WQNiLDSBi9Co99xwWqgJEyeMDSyZnV8vWCVdj3zspvCTVL3scuZZ05NQhmprWTBGVhqnYxOwxZMJcGSnjc8KXJ0MKUjJIOoRPG26g5oUAxhdaeQQ82mntz9L8GD0F1iqaV2AGuH4C14lNOkmeVJhY/OpqTAL/BfnocOHxDMV6b+ewppc9ON0T0tn8RMYncH+eP9RNM2LObc5GgimDUJLZPIz+r5V5LS40SQgaUYrXiIUuUe1b9uynY1U+2fh/niJJBosmc2R+j9qqqoCQT5toMkdop1ffa87rKpmefB8jF2F2AOLxS+pDKn1fVvWnZ8iCkfHgryZ+aktL5QfqKRvdLcuj+XnmFIxMj8yvvEQkTwQcayPmBnC+h221D9y0oZkfv12SPJB8ca0kzOYXhW9Dpj6gjIIuhPn2eJ3do5DcWi11EXw4MEyJ8TESjwpD0E2OsufFyifGr+uLSBrtlAcQGh7BZOtYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Arm) <david@kernel.org> writes:

> On 4/28/26 05:55, Salunke, Hrushikesh wrote:
>>
>> On 24-04-2026 14:22, David Hildenbrand (Arm) wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On 4/24/26 10:42, Salunke, Hrushikesh wrote:
>>>> Hi Andrew,
>>>>
>>>> The idea was to keep it alongside clear_highpage_kasan_tagged() as its
>>>> batch counterpart, but currently it is only used by page_alloc.c.
>>> Right.
>>>
>>> Looking at init_vmalloc_pages(), I wonder if it could also benefit from batching
>>> if we find that pages are actually contiguous.
>>>
>>> That would require looking up multiple pages at once. vmalloc_to_pages() or sth
>>> like that. Surely, doing such an optimized page table walk could be beneficial
>>> by itself.
>>
>> Interesting idea. For the general case where we only have struct page
>> pointers, we'd need physical contiguity detection and a batched page
>> table walk as you described. But looking at init_vmalloc_pages()
>> specifically, it already has the vmalloc virtual address which is
>> contiguous, so can we just do following and potentially skip the
>> vmalloc_to_page() walk entirely:
>>
>> clear_pages(kasan_reset_tag((void *)start), size >> PAGE_SHIFT);
>>
>> What do you think? would this simpler approach work
>> , or am I missing something?
>
> Good question. :)
>
> That way you'd be operating on the vmalloc address range, not on the direct map.

From my testing (including when using userspace VA) most of the speedup
was from CPU prefetch. Which we should get when working with the
vmalloc address range. Assuming it is writable and stable.

> Is the vmalloc address range guaranteed to be writable at that point?

What happens if we get preempted and migrated while clearing? Seems like
the vmalloc lazy syncing should be able to handle that?

--
ankur

