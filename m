Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AFECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97626900140; Thu, 14 Aug 2025 06:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DD8900121; Thu, 14 Aug 2025 06:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815CF900140; Thu, 14 Aug 2025 06:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4DF900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:53:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEB16140603
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:53:44 +0000 (UTC)
X-FDA: 83775052368.04.1AB3BDA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 825F61C000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:53:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=khbI4eAe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AuswNU4Y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755168821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8A0eZeqKNHXpPiBX34++i4wMwxlVCyeV2C92yL4krI=;
	b=I+IYPC8b6xMmcXiZDPLDuGTh0JR5b2xeCbG02P89x+UazyI4h7CqhSGUaJWEK09S6mitxw
	8f2LVWUaZjyFJxlIguG4Nq+v+4SQDLrX3C0xWy7uNikB7Iqjo2uO8QAImktu3slE8xvawa
	qarQly/hmc6jOQ8Lwf/tFuBlVEEPmmU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755168821; a=rsa-sha256;
	cv=pass;
	b=Sr1qaHOttF06DnBxf0ZQT/tDVFk1g/HJ1VQXHXV8/EgVyuOAU1mQDfNk4GnEcG3+gbaHzt
	JqCUXxn1NfsKOMe9RxTTkmp9SBkzGZsdANJgbz674OIhvg95tnxNLShUdTk4F2lxMCx2/X
	HY67ooz+kdkLVxvmSlpUOEMu5ygoYwU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=khbI4eAe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AuswNU4Y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EApSwT011888;
	Thu, 14 Aug 2025 10:53:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=X8A0eZeqKNHXpPiBX3
	4++i4wMwxlVCyeV2C92yL4krI=; b=khbI4eAedofj5gtHRzEhoOSVMbAqgdG8Hg
	Lmo/LF3U0IlgA9WBqQilPcF1BUg2QAgy2OLilvzuzGzdti/Nl9d4qd2zYbCws2Bt
	vFUD3TyMcazPwaT/rFcV8lTCIk95oCaf5HubbX7qrJh9zi5gKdbPJAFQ50JYhfhB
	NBSpeDTfGliorpMUlyeOSxnb6FeWD+waMvw+JGq2YaJpB8P9mabWE8cvYY/eNxtZ
	0FCQCXsgpxeVAgCrEs9ASwyD2iHqPZKZMc3EPFxiuIDgC27Kny7o+h33v8LOukli
	SmtdJahHTLnTtoXfb2McqaKzdkYmwMlV1CG3d+iKTP6pXxLWiwCg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4hp10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 10:53:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57E92v8s030165;
	Thu, 14 Aug 2025 10:53:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsckmt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 10:53:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBFFcObEW7wwa9EuCYpfnNndXhsFpzkOaIpcZE5ErS33f2AFb6iCf3eiAO33Sajgd/fPzhvQS/9yDxtAEhVvr8EB5u12cULPEqhkxr05So7ttM2UZ2aTz3ixeI1bVF+PHmCwRrraCuSb/TcmdFGsdtimppgHed0v+Dna97FCFNEXGCTC92+Nn99YYCZxofGkSjPMIlz7Mlwb78QzoNkUPWCxUv6JNvNshHRqvkM7LYgerCK4o7rkw+eIa0uirhYFnadlLOBIAw1gW9YeeOvku5poBZz2KcmpHgcxIcdHsQlx5ESQOyyb7pdzZOkYrQXKlqmlt0P/+0sklsUo3vvaOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8A0eZeqKNHXpPiBX34++i4wMwxlVCyeV2C92yL4krI=;
 b=vwf4UoGNtabfP9Ixb5n5bg8IP7RbPTElhrQhbrr3k58OjlC7keK0MyiwU9Q2gjXpDD1Am2EKDmTAfdNvXouRPDGGhVVh6c+3vYGbXMMftnbLTLsRI/K4Z7weTpUpFWSadBHSrCbArewEqk82nudWqeU/IrBn8q2NoveBXxiRQHp1dz3hojN97DHAIHVTEtCjFb+j+WfYO4oIPUaNCfF5OYSK+K60tsU60SoY6ng9x3qCGImwuP79SjbL/8tIoFJP7fgWbTfxgUGfb5tUB4+KkcWrOv4HrxjdmItVMdT3Akl1AD5vJhxdcYwx7ADbh2JJ8LuwfP9bI7kvFx9pmZ69TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8A0eZeqKNHXpPiBX34++i4wMwxlVCyeV2C92yL4krI=;
 b=AuswNU4YnbilsWjVc8K+zJU0V/Npy80jVH9GkUOB9vnX0duTYhzHTt4h3LpdS/hZCaUr0PbtFeN93UqmAAVTd9dO1XLUczMJ4xj73HHVFEGcOlINLknx3zNf7dQtwxebVbQZjPsEG2eRZzCPqzQw/x6q1VRw4dj5FhMmEL7YXPY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CYXPR10MB7897.namprd10.prod.outlook.com (2603:10b6:930:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Thu, 14 Aug
 2025 10:53:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 10:53:08 +0000
Date: Thu, 14 Aug 2025 11:53:05 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
        baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
        ziy@nvidia.com, laoar.shao@gmail.com, dev.jain@arm.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        jannh@google.com, Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-team@meta.com, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
Message-ID: <a8b0eb8d-442e-4cfc-ab79-3c6bc6a86ff0@lucifer.local>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
 <1ff24f1b-7ba2-4595-b3f6-3eb93ea5a40d@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ff24f1b-7ba2-4595-b3f6-3eb93ea5a40d@gmail.com>
X-ClientProxiedBy: GV3PEPF0000366D.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::390) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CYXPR10MB7897:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d111f7-fa1e-4a9c-9d61-08dddb20c086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RYwRnQ8N2TvfSH55K4W94Gc1PezQPZlDcHkBVbqyhQVK08hHTe2ImxCk328W?=
 =?us-ascii?Q?JCEDHUJ6PxlqJ2hm5fmLhTQhm2nRwSPH0/+0UgzVl4aoq41LLxu29vPbyonI?=
 =?us-ascii?Q?YYm/bfTLEEBXXkOxTuy6km+co4+66FCGBT+OdZI4VueYEaosMWSC3cUAx8AX?=
 =?us-ascii?Q?68yK9Onz9MSos3o+n13hj8jGmTWIIQxhHcUyyaKcESxZd1Rtu194jj6mMXFf?=
 =?us-ascii?Q?SsUfGBjggfgGuqi/r45OiMuQVjK87xxtqUbJABc0OQbD6GjghSlZO2nxPpg6?=
 =?us-ascii?Q?gQnq3n9Le9haSY4j1DA5T6gebTJhgmroZB0fZSGPMYcK0QaPBBiK/+J2KRK1?=
 =?us-ascii?Q?TTfxnqUaka/g847zkfUlY/7t878ghNoauShWoOzhskpH1kS7V0vkuCeJhUB1?=
 =?us-ascii?Q?ZRH+7iWJ56PsSSYJsPPGCJ5FWr++4drjJAHufYZK+qDQpU8p8WCxr6ZkmkfE?=
 =?us-ascii?Q?l0W5C4lYEGmUpg5iCQijfJWFBJinXz+XA59Snkqosd3jhlHy8zHkB9n3N9bh?=
 =?us-ascii?Q?D9gZ5tBnttN7Qyxx1z/FeaN4OqLITrQ2dD2F1vBPn2EBjq1qhr6BFjIWnmlB?=
 =?us-ascii?Q?5SQ2pnqGMSrSZmBdiFhUEP3QAPNim/sCi7y8ZAZb74v/D7DkGTUj4Dw9X/GT?=
 =?us-ascii?Q?pgglU2Fv0GAXhtOcksXRxCQ8gYGZ/OtJtMe71WOpFqBQ4y5PHz6XEQKqpkid?=
 =?us-ascii?Q?H4SRgKExg64JYPxsSi86fJ0QBNOGOy7JQ3oNLpWEPmaIcZNkE9S6gHfpZlDY?=
 =?us-ascii?Q?SrR8DMoxJVf77+z4MpsmukAMjW4HXqgd5uzngncvoZiIreqkfq8I1nM/fbnB?=
 =?us-ascii?Q?YA10Pd3fJtbYqLZEqDgYV9SY6yCh6/kYT/ZXsyJhQ81M144PVTJPDWyM5pxE?=
 =?us-ascii?Q?xatAD9BS/TTqHoYOJ76nEfsoXK9M77Osm33+0hGutlfzxYBxEpTbkvOquyPL?=
 =?us-ascii?Q?fahWGDt6GDTGRoWq4Nr1pxHDHMR0v2xYZ5GwkDTi3OCeMN/sa8wQAVPy8iSn?=
 =?us-ascii?Q?un1iW3LiadLJ4LKMkPY3WZJxKNbCzmi/yA+xx2YtfQQFn0VytjtFtaaYP25N?=
 =?us-ascii?Q?qbUk9G4ePrAXEc7feS/gsDoHGP192Dm9sqdYdKjKQdbpJA9DAfnAu5IJKIO3?=
 =?us-ascii?Q?diEYltnMvlqj3IRzinSVcTDNwKDepYcZREevHD62cjLkyXB9IU9A6nQRb0Oc?=
 =?us-ascii?Q?/uHL9IlBaigB+3gaPpITN/C9bgXMtqpbNspXWUMMXMijtKVkHHfmt3452e3X?=
 =?us-ascii?Q?MnoJtDLGhcc79x/tLkMgpQBxI5Osj+ky2EoOBpUHi2px/gmd+F2sHQUg7wNq?=
 =?us-ascii?Q?MolV7TVGjGkDwbbzQz/jzMsBJIpvcoCOqA+CR+wmtW17Vkf5To4eWkQSs3yW?=
 =?us-ascii?Q?eleLbv6OigL0pbviUTzw8Qzhoaq4R7eYDjJs57m8ELWDUPIrFxGWpl3gZl51?=
 =?us-ascii?Q?0ymt8okWQk0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VHbuk6Fj9mqUxNgshjAgOZugRnhIp9cdvc32PYas18HKNJpeQVeaSWJYiK/m?=
 =?us-ascii?Q?+PJ6/16eoBMhugpDAOAr7yLfldaEMr4EoPbNWsIGd2lbjezYPyJL4iDoeDk3?=
 =?us-ascii?Q?OkTaeIkl85G7c09+GBNOZjp5cFZOxVSuFPmF0plCyqLqQSsaIUgmdb91L4dk?=
 =?us-ascii?Q?k+LS1+8+sos54/hFMZlaeQntBS/lmuEmlLXsTn6Uz7dzNXt7HytRXGBzYm3Z?=
 =?us-ascii?Q?fzzSprGohQ9CWwhJeQab9O6qfl0Rxz53A04qXFvYF8z2fl0XnK4GvaSklCDn?=
 =?us-ascii?Q?NlapC11FB1NEmlo46PKPowlFQ9ZXHCFR3NFkirm0WKuPm48rM/16jaIV7PC3?=
 =?us-ascii?Q?QU/EIsG8k1/My+mVPGP+Tw2V8kszHbmYQjS4hishm/ew+9Tf3Wq3m+iUkgre?=
 =?us-ascii?Q?5rrptT1t5ttVZcOk1hlRmCdqrdvqqpsstmZmeDyTPpHWh1lWT1ywd05RrZoG?=
 =?us-ascii?Q?YY/Jzm2n09irmr9Ck3DZckfoTJrHBiFnJgH/KP1N0gyxcEqWXrkknUydDMDf?=
 =?us-ascii?Q?yY0Vst431vVsT3+DWu3+uQNzKqh9a/wHvEe8rx8htN5YYSyYk5uVe4V5ARhG?=
 =?us-ascii?Q?30B4k+sEWmFhrjccgAEKaRcAi/D8uxSmRFV/oVwmYUYF0FHaoc5c9b8bd23d?=
 =?us-ascii?Q?cNpmSD5wq8lNDUShZEUmNcvoqbIaB1lC7jsD1C5eFMDFxSIVHV3LINXj0+ra?=
 =?us-ascii?Q?YSZknSC3VXVIz8pYFwDKwQtsFR6pD9XCpTG3p1Pm8PmlWgOoJP47MsTHOMvn?=
 =?us-ascii?Q?jE8O6cPsNFZ5CkWfT7sNCOkLhTARZLWpKJ+OjzRlpO8OBDosakhJv9xAw7kc?=
 =?us-ascii?Q?Mh3kVDXBDXospwIpEqtgxtQlpf24AX1eaO5CPYGhUwJkinMiT/yODzrUQqEc?=
 =?us-ascii?Q?edK2BYUdTNoDDxNppfZInbewV/rRr922Q0iPfrSuqB3VtwGVBRpI8IC6tiUc?=
 =?us-ascii?Q?zK4xv55ebDvKEEjxHnvKSY+pGeNE9LVjB3MsNa1lmaUZ8eQUJyj0lOdM/yxA?=
 =?us-ascii?Q?w/wjkp+EoneGKbeLjun9ZCMiGAt4D2SoVe2FahnI+lfkRpZcHKasQcyLIliQ?=
 =?us-ascii?Q?pajkLb1/muqRbdL9aKpiFhQtmo4OE89ZF64m8fNTGoCzGScrEY8IuuvE9hEU?=
 =?us-ascii?Q?bQT291f9NhQTf158NJze7tUbC8hjkCWALN+aAEJEMUtjHJjHxmXfdpnKzJD1?=
 =?us-ascii?Q?KP2q6ur4npHXHQk0YzQVJNYZGYx9JRF7aRBjhlQHP9XBr4vj4a4TcADuSmkF?=
 =?us-ascii?Q?0dCBhCSeI7nT/95XLzjzRkMLo7/w6NWX1R9d/ZtSJaExqeGBlAwXyH9jASTh?=
 =?us-ascii?Q?ly7Q6uTtR+/qhIyLsjX5Bo4bx4BrnWjVjQUPONungF9pkuMb8/wN51PO8Q8U?=
 =?us-ascii?Q?MnBuKhEaXlyYedTxEcrgvbaCq1SLboxbLNT/YcaqdPy+12kNDaSfNcooX6tM?=
 =?us-ascii?Q?IZRwOSHhWiXX+TNJ7kcZLRBm8CccozE6X4tnDBpW5ZKEHsCR//Cl86b6EtN0?=
 =?us-ascii?Q?YBjg45DHAq5//xLVN+iSuEGuUuUHjQGzrTLTWpfDRgjtlJZfSV00wMpkWh/C?=
 =?us-ascii?Q?8lSfoia4P96jjg30yxfleyFQB+VO+2PQE3/omW/ehqXaPJ1knuADeSF1+xEJ?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C0kph4ZzCtvN7LatTiaT6xZd5TtjIhogdKctfNhtV/B+NceKmTfA+evQWREqVj6ExsLmbeeMmuxp20d3+zds1azsvynzWuOGN/QBESYpfwlDOf2e9XDZyohwZLbai5PIJAkBy3lrwjRYdamtPeDt0uzPPlNr3nOSxejgbxglDS4j6LSc/gpJTyJQYdlVPvonvkQ3d5zXg3mQeLQs76shQi1QWB58iO6tyF0vzjDakCLW/+OrfMv8z/7WUoM8b5mAV7xm4JrtIFtT5MdbhDVhVhgVwfpQjGCKzH9exjYjfObZ1qZvNxj/VNZSALgYW1FtoRpKboA8kFTEwDSU5MIPDLJPA4wTQmVMAtAMS4ZlmiLhGu4W6JOozAPOjtmz53EKSwGX9v4fkkg5Wwk/Peycj8oMuI/fttjE1ozB2OOgPDU1bPOL0qBGHiQtgAXvmEjvUVOWrx2XJgKcJJku2z9m98V5D6w0Lcvc7rMiSqqeFPcpAFj/DhKI+5n2IZhefL4/s167slzptJhm1lpdght4lvSE0dmKQOhrtk4PbDJmpN6ggVT9XUI8sQt280P5Er+vsAR44WAz2S7Y/rAgnwpbHo/5AdeJt1yRjDUKcdLVxEM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d111f7-fa1e-4a9c-9d61-08dddb20c086
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 10:53:08.0765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldG9fpzHSxe+ofO5waw+6WLb2WVuSFvy4sGDlLA+PySyYhBzD2V6S3buy8XbSpEy5Pc9dC8mxjJmUnbeczyOiTRUHIW2l+IGIWTM7Rplx4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=901
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508140090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDA5MCBTYWx0ZWRfX3uLps3jB3I1/
 L9FmZLRPMEFCTfW6M9WkH9zF1fL9Tl2+mMT29T82YiDdCJMW6IPPPleIFdAufcX3OyW9HbOzzko
 RzHZbHXhxukQsInqxgq7n3lpCktoc5v8RpaeMqsC1e7QdiT1s4aNNNWTxErNtyRztaFi3C0H2xC
 kM+C/zxOOGqK98dwVh1khnuBRorF3Hb3yvPAAWPXXRhKh/JnTRDn/wrwSc4K5nhOPeUqFNA31vZ
 P5qZ9fuAlWDeMq02iQBdNizQjS9b9d7l23wusC7oZWEr+gzee957nsRzS0wh6xlwgNPl0cQwZZb
 sXWuskiGvRGDkj+Q/UiP/8e3NqWr4OAcReCNCod3tFRNni7V1MkWwgoGZuBty12YxO2yJGz3YA9
 558r+fw8+oek+X5ZzM4x4xYgqV2YeGuKh2INlV6JkvFJpClL/iGS1+bPpCogHMwQn0D7CzMN
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689dc02b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=iH-G_q8OMZp2NVMiAZAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: AUvtNaofHr5x6NQGXsOAMyEZx0XucipP
X-Proofpoint-ORIG-GUID: AUvtNaofHr5x6NQGXsOAMyEZx0XucipP
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 825F61C000C
X-Stat-Signature: ffmjynff4x86gwcsy7n1u4yhs4zaqdrr
X-Rspam-User: 
X-HE-Tag: 1755168821-78480
X-HE-Meta: U2FsdGVkX1+cOST8RwJNCL1iAQ8kzf+LWH+g+Sk2EVBagdhfCdno3FeXckqFnXy9CO31xoaybf/eMigqktjc/uM1SnHMYC9yZtYS6YZdRXpzmNeJEvTZEdlm2kpLbxDUo1yJMEAZVi5dmnW+5rqyqiLhejqHEb/XNaqnO9v8l9+r4bc6cDEy4bydDc1uY/loE7Rsrx7FRsO+nCBvwUApFkPEuQ4pYEqDpX/+kL8lAYVDHX4gn5KwzJ/wSu6LJHaCRreWAvWqVfl0VNRHPQGL6S6oeCPz2VQGow/TVrrB4l6zlb4kPeyCt2q9Uopf5+LszBZxhUWzalwCMBYTuQC9gN9R0GJUdPqo7vOUlY34ul5EpRZepX6w6hsr2l7BQso4vRz7gz5yS0rVN2f/dqFz891tj2jAbBCrWcMkTlceO0lUJPH7SNrryN31F/U+2oU4t/Op6ttvsaNRO7ggL/0B8USLMVFQXFyQlLsxjR92RYZb0eGJsSXUfUTwrfymgB7iTmpLzNb2TOrMLclIhe4mOE//jQ5JpmsVXnsO6mBak8He6aIHsjOlIwCAVkl7yFG7JxBMAtweBJixLlOER14+Hx5RJwFsWfY+xmTP5fKQh/R/fyOHeqwbh81D3NPv7FMeo9l7WoLxIL18FBahCXWEkiV+GlLOszyj631myKhi9zUrBCMPct8WeEcbXP04IvQ8XOSMG1JqHQgGTQraa0Cmsh/MThiNndfLNByXE19upR+CXKs7hWdCKLEQZ2M7QHvlvoUiID31pXrDzqZjQXfuE7zlz0CSnCZEd/4wX7UOhtHHCPFGJmQ5tm7dpU2VYK2puKfeva4yK+EzCZHriIPOSUQkCZ9+IDLfC+oBA2teoUOOJTtKu2mwRYtyniV+ifsrDePNeSkoqzoQ5xHfzHzPtnSdv6IOYkoz4DA9f7rvcoigBWPmJqPtk60Vw0cPJOU3z0pE/eqZ580dD1pZGXb
 6wkzw2zF
 ZRDkkB7LClLpgisvrDclYnSiikAKp9d83/M/f1nwVHLuC5dZw7b69gP5K4/MXARj/bbKFpmQ1w4RO0RdBfbA1hO7cJvARj3YknB1fLhkr70ghkGdBr08OJq60MIe95LseIYXNfSrTktqVbJdywypckBNRuSp8sUP4Rzlp1f061kntURFjqIPGD8qNk9oXW/k8UjrjWJLDBb+2o6nApC9FwPXEE4YOS64L3p/5YTOfRBzvQBJMZeN1u7MNbx9ltzFEGZ7X/DOZbpiq9unEecKIEVitrKFoxRQNZyVj/5cN7UqaQOJ7eETh6ArWJwLHeL8xmiI3xv5z7EC+9dj14T4JR4YJDZ9qQT53G/UeOULRwIr/OGeUQkLehYaz/A+Xfc/23smudMTls5RHpZVjW013PJLExqpT+gB4XVBjxKYV80ZNP5gxZJ6JA8UY9cr060xf9MjnnjvY9MopGBtHKFrIlp5+kE8Q5Yx4Ff5wILNva+6ya7ycUNaH+D94s8fsyZQfuv9FeRTfzAKP+c1HA570n4Uqcv6N1NxiqeqJZFM+OMtHXcBlYPomI1xCXFknLC2ckVAs4bj6FWbMX4CYyEi6hedRURZ07Fq5qnYGlqdcktMXnynq/9tHDpySycQqWXLwMgyF2iDoIJi0EBfZuZH5DrD8rqSQZVoxDQBuJsCVs0K6h/oCCaUrJt268KMGI+s5p2mZBc1r55ncL1VwKIGeT95XT1WpJI/Op1ePJkfvYNdXtthpUCdQDYYF/5R0OTi7jzg6CLT23ghsjWbhjEwGTCcoc/lBjReg8ZeL95xbRfD/2yM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 11:36:51AM +0100, Usama Arif wrote:
>
>
> On 13/08/2025 19:52, Lorenzo Stoakes wrote:
> > On Wed, Aug 13, 2025 at 06:24:11PM +0200, David Hildenbrand wrote:
> >>>> +
> >>>> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
> >>>> +{
> >>>> +	if (!thp_available())
> >>>> +		SKIP(return, "Transparent Hugepages not available\n");
> >>>> +
> >>>> +	self->pmdsize = read_pmd_pagesize();
> >>>> +	if (!self->pmdsize)
> >>>> +		SKIP(return, "Unable to read PMD size\n");
> >>>> +
> >>>> +	if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
> >>>> +		SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
> >>>
> >>> This should be a test fail I think, as the only ways this could fail are
> >>> invalid flags, or failure to obtain an mmap write lock.
> >>
> >> Running a kernel that does not support it?
> >
> > I can't see anything in the kernel to #ifdef it out so I suppose you mean
> > running these tests on an older kernel?
> >
>
> It was a fail in my previous revision
> (https://lore.kernel.org/all/9bcb1dee-314e-4366-9bad-88a47d516c79@redhat.com/)

Well it seems it's a debate between me and David then haha :P sorry.

This is a bit of a trivial thing I'm just keen that bugs don't get accidentally
missed because of skips, that's the most important thing I think.

>
> I do believe people (including me :)) get the latest kernel selftest and run it on
> older kernels.
> It might not be the right way to run selftests, but I do think its done.

People can do unsupported things, but then if it breaks that's on them to live
with :)

>
> > But this is an unsupported way of running self-tests, they are tied to the
> > kernel version in which they reside, and test that specific version.
> >
> > Unless I'm missing something here?
> >
> >>
> >> We could check the errno to distinguish I guess.
> >
> > Which one? manpage says -EINVAL, but can also be due to incorrect invocation,
> > which would mean a typo could mean tests pass but your tests do nothing :)
> >
>
> Yeah I dont think we can distinguish between the prctl not being available (i.e. older kernel)
> and the prctl not working as it should.
>
> We just need to decide whether to fail or skip.

I really think it's far worse to miss a bug in the code (or testing) than to
account for people running with different kernels.

>
> If the right way is to always run selftests from the same kernel version as the host
> on which its being run on, we can just fail? I can go back to the older version of
> doing things and move the failure from FIXTURE_SETUP to TEST_F?

Yeah I think it simply should just be a fail.

Why would you move things around though? Think it's fine as-is, if something on
setup fails then all tests should fail.

Cheers, Lorenzo

