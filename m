Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 286FCD1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8118C6B0088; Thu,  8 Jan 2026 12:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8E96B0089; Thu,  8 Jan 2026 12:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6909E6B0092; Thu,  8 Jan 2026 12:11:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51A726B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:11:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F159D574A5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:11:18 +0000 (UTC)
X-FDA: 84309437436.10.19C674F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7B9C24000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:11:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QyTHgSFS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=F6RQoOOl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767892275; a=rsa-sha256;
	cv=pass;
	b=Vpdl+yMS3YsydHcMHfVfzNuIMuVYyVCydq5Q+KZVdnXv/GXuP9I9Vl6CqF/i+DJ76UX+AE
	ieZt8OIv/yukQcX9spV3vtNA2EnyXV6I1y9CqH8ivZOWjCdPnzHVeuqkc1pQ3DuORLnD5J
	0MywZSNoJEYPfc3p7qQID3zXblCOUNQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QyTHgSFS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=F6RQoOOl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaQwj446jMW/I4LUQPyrbgaU4U0R9mspof6zS4dsgK0=;
	b=5HYPbOujl8NWHESmPoye3vJj6ppUr1uufo6iFHX5ZMwotJ2rOBpWKC5BqqxCPlukVo79ki
	pJVovsN1cLFadoRC8lNSmqYCEeR6J4gyjfcqRFvAGcA1tNsDNhPqmsAsWdXCiveHaMmlGa
	Gc1iciessT8pitaJXt47OMlBe7clxLk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608GtImJ984401;
	Thu, 8 Jan 2026 17:05:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jaQwj446jMW/I4LUQP
	yrbgaU4U0R9mspof6zS4dsgK0=; b=QyTHgSFSkBQaZlw7rLRA7kV9+iSIhbhTNY
	5YuL+i1TCFhnzv66C33uPtUZyCJzEJIzJNfQCLtwpcsaVTG8Nw9oZYcqQ4R6lY1j
	0x+APJh8hiR4zwQwuvPSXqF+Ju6SCKp8gB5bqGRHTV6vEqKYrHKkxo/t4Dz5HAp/
	taJIukhgMf3qxGZw4UgG7FMDr5cuxBc8t6zDiBRMYxYBRy28edhNTa6LjUe8plhH
	sksEJLFE5SMw7aBE9HhB1gwjL+CEsasrBxsyZ4mb/d9UzC/EdFE6vHce6nPT3FgS
	0EviS/DiPKwQuB0eAlr0VQoYSsOZJF8U8o/OMA1jRYk+BwxzdLAw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjgh6r0rv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:05:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608FsJTo003629;
	Thu, 8 Jan 2026 17:05:45 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010060.outbound.protection.outlook.com [52.101.85.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjfbv3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:05:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FpC9M/aBs3jsoI7vQ8i0vppAtyJXZcgykUL8f437/r+JsxmIFHznYEThLH1087NGq4R0+Jth0yymzg2jeqXW4k0h5fVMR4efmq1Aug5R7caKmYQ27OokCiDwmA1r13+W1P7SFROLIkndV8xtFutoOduCRakutfZdSBufhjvJ31LbXcHMMaICZbbKzK8+UexPb8P+bjzoeI/Tg4b4u431zXf6Pyl47l80TaOh12WEJMSNCYBVHmFJKOEPn/Z0xXfYpH3GSo6OhpU8zXtQqiIFyK3wswaLR1AfvacDGkG+9E/bfEuBX6X6VmWwHjCTDSWBD+amIcPY/jJu/5NL4DTb/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jaQwj446jMW/I4LUQPyrbgaU4U0R9mspof6zS4dsgK0=;
 b=U8lUVL1aAhLnw1N0Ym9zgt9uwi1/AgsUOC8I+kGiu1IJFUUPAz9NkqtJbnOEPLfeD36ybUcahN/DJVnSSkwWuGrgN+h7T/JWqaSGE+O3xmNzveUV7+sbTQKNusJOev+i9MERl4vphsS+CfobMgUqoAmrdViNtgTl57lBNcA1jXROkm+oQcVY+GdLoSZtz7mjrngISwxeB9v5XTMcUG1nRJgtapdXM0l4RpKXTo0bQP1AmfgvLHzhuTeLeDIIbkLcuI4EuZqcd8JbduO/0aEh3Mf5lpvfXZX5p4cNtafTw0Ploam4z3QZvlF6AvVigw8mhZhgYL4VPYMQYGGX9ixtBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaQwj446jMW/I4LUQPyrbgaU4U0R9mspof6zS4dsgK0=;
 b=F6RQoOOlHupKEDq6jdWIuTPUtOmSboZy7ZYZxDvk2+lom6bX8RYJklS8Zfy+92sqcPo0sX8IP2nG1mCtinoa2rljV6OzFF39lrBtff/05g/xxQE4GBL5CYbSg6Lrd0ziUxbdaESW4URq2cdB5uX6Cj5JDsCAtkqizelLSkTEhoM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO6PR10MB5538.namprd10.prod.outlook.com (2603:10b6:303:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 17:05:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 17:05:38 +0000
Date: Thu, 8 Jan 2026 17:05:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v13 mm-new 03/16] khugepaged: generalize
 hugepage_vma_revalidate for mTHP support
Message-ID: <048076e6-19a1-4440-bd54-12a9b7f1a09c@lucifer.local>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-4-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201174627.23295-4-npache@redhat.com>
X-ClientProxiedBy: LO4P265CA0221.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO6PR10MB5538:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dbf6f4a-8aaf-43b7-64e2-08de4ed8257d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j4nSZL1jiAtYQYqmEIdb9GlPUqt/K+FI/+VzOEAj2dEjuCDu57K54Rf0GLSR?=
 =?us-ascii?Q?125TD5Ona3KQz0CC1DfDEQ7Rom4KifF6rcmUSkQ0PvlrmrtrouumavOCKqcM?=
 =?us-ascii?Q?zIZMABj2yV0wsBZdi8AdTwJ9l0RCYxgBjsFiQ18UmAXw370siu1j/cD07jtM?=
 =?us-ascii?Q?2lOFIydKTVJWXv/ZA9KlWL4JNM9y/QMwGOTkDTcWL6g2kjS5oZHErXrKJ2CR?=
 =?us-ascii?Q?FM3mZk8Qa6Xs/CMLns192Ffsc6Gt889czN7zeNRGBJTq79danOA3ilJ3S+21?=
 =?us-ascii?Q?wooAhwiJuWP2ia0yem3LbMiXtGFydktDWXhX1OmTnfejIoTOBqXf4Pbr0Ct/?=
 =?us-ascii?Q?NHBW6RkK/0VouQ461cgBmJgPVBu67ynlSYgvynbBA5w9DzSSSAejn/6wNOVx?=
 =?us-ascii?Q?+PYmzEHEpm1KA6aeJXFBFAgWisStO6CSJ6X+c7haoQS9hWRDXsKQ1YW/z25f?=
 =?us-ascii?Q?bLnzVfNq55DKHWRJ9mEviN92aSDVPnkOFck9QoHf4Bv+4JF7v2Sh5u2JR0D7?=
 =?us-ascii?Q?brWW9kpIYvIhbT0234TbyuR9tr2A+EHobJQDo+4A2SguO95ti4pnWCYEGGMz?=
 =?us-ascii?Q?AwpSKpidDr745zT1CYRgUxzP6W1qfO/qME3IYSkChGrNnXc/TDlScjSgO9lY?=
 =?us-ascii?Q?Mo19tksgDIjOGKlogMX8+aqnT9FFOea35ucj8D8cc25kVx0ir05caduaZozT?=
 =?us-ascii?Q?UgeFPrQMFAm2IZ4INKkKCIm8uBkEuY7Wm1oiGoNy7sYm8w0/0HBd48F3L54e?=
 =?us-ascii?Q?3h0DYNR7c0uDxlgPUVaur4C2esyxIET/D/4Fr/QXtSqiq63lglkE4Gk4I04W?=
 =?us-ascii?Q?xMOMJyc1OhKptTv9m9D0qVQEgA+Lg+0+EFPjByqa73nXNWB50shkqLp9tLux?=
 =?us-ascii?Q?eILLM9VktXYsXfJmpDY+/rvI+KvRvJR5/o6KlfuMlKMIJSh8Ko7xuQt+p8ip?=
 =?us-ascii?Q?2kw1l129ilxv6p7rQDzm4M7BuliV8u1RYooorDbb1KRUxlt6Xjtye7v0117S?=
 =?us-ascii?Q?jdys2hKVPiE4tQZGJLZcWPCCRO0lNAOt2NZ8QvbXC0t+IVmGBS1h+cmTM7HV?=
 =?us-ascii?Q?jx4wso4vBgxlmkDHIq8KYpm6hoG2Mu5ncDCNqZ7PAjuzpmXEtQ4hwa+fl2BW?=
 =?us-ascii?Q?jmS7fSgQyzAItETsqx/OLn2tIPFhsNuDVCEM6+bzDEA2iji0G30EAoVm1o2c?=
 =?us-ascii?Q?nI0Ncv1fNv7tCmopHs/8omGIm6krPa6/xSbvZfk0nPcRaQ3t5RzqhH2IqUQU?=
 =?us-ascii?Q?d2DLFUL+8dBaJ+PY9ROpWhusD546pwEPasMWXblaT1DogAnWm8IWBcH4p0db?=
 =?us-ascii?Q?4e8B+14ixrN871s/rSgZuOen+MOCnm1Jv5Nbc+Hysyi1klgB9JvUO9v8+o1d?=
 =?us-ascii?Q?yJ3FZt7Oj99Y6CT0WpmLawPTUgSIcZlBiNp8VwDLm6Sb7GU+v9CEUKrr+b4x?=
 =?us-ascii?Q?cwxwml2cp4yrkbuPY77gy1KA9j7B4mLI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mCbus8zglC10mywUvuDOAxiZzLFwkvFalA/DN7lXk3JB+QXifL6Z2esLRWhU?=
 =?us-ascii?Q?6G2Rnsk4an5vRp6fATPM8Gq478IiTHSvlawiXy/B8Lbd9MMKB7B8X4xowFCJ?=
 =?us-ascii?Q?sver8bfaZydBbsksyjrYIHyvkCzeckcjploZxqud5OJAvhRcqqy03LVXtwND?=
 =?us-ascii?Q?I5ndpREeHLGxqsYgb/ePtQG94L6Kk2DRWVZczH6SNioUqitTylIySCMFUzQg?=
 =?us-ascii?Q?IAfEvY0ysM8PHJXFwKI3WAFETO16ab/Re2Lpy4+zHlZBC2HaGaeB6p3p5hN2?=
 =?us-ascii?Q?q5EUP0UCg0QBR0ivuJS/3iS3bjbQTPPdT3O5jqfI4mtTxP0eraQMTzqQmkR8?=
 =?us-ascii?Q?KLSCx76CNxDTSklGiwoC6y0OXrZodvIRrUmgqeOGbxwU2ZnrbXgP6kAlXPS6?=
 =?us-ascii?Q?ZFa/xceAp7r7vJWeLzeZE+kxJHfgZnePKzouqamwld+v13uymzubyRQ7K3Zs?=
 =?us-ascii?Q?T3TyYNRYqtNombQxOvsNAf/u0Lhi6MFW1Fh7Qs5Ek52lEMey7gvge2sfzH/H?=
 =?us-ascii?Q?bzKzxL0QBXDS3zheFndvU2n1ooBPOwILIS/P/gRkxtLbb8ZH99wz90RX50OD?=
 =?us-ascii?Q?TzUGSMnRcd6VN1MDuxp64lBN31ztRTGupcsY1UQd3P9pOf++Iooixlbx0sqG?=
 =?us-ascii?Q?/YozJzhZqyUE5cVkpoG6nI3EF7EHgmEdMIVSHwqxdqo4Ou5jvgm6L6D2i2M3?=
 =?us-ascii?Q?5PErrKCwzBrfy5TcI3OhJOk0kSFCNqXeQD62t2OSM+fD3v7bWOQsQixv9S2u?=
 =?us-ascii?Q?kBmdlWC/+YT6HLUl/lq0PSxosCpqZIT/uuC73QU0Uso8qQZ30SOpFO63DNEK?=
 =?us-ascii?Q?IYaNoONabTa28fnhKKHWeGRGgUnwaoIbvFr74wOIe+TWYWirtmnC3zyDHlJB?=
 =?us-ascii?Q?2FeE2JGsjntnFyU/3gE+n3Ohf1yPEmxZ8bQZWD063eZp32FNEhsLfUGQrwBE?=
 =?us-ascii?Q?1mDdXjpdWleI8VV9vRj+jPSh01bpGscNoSbjcU4pyr5BpcDY/hvlVYiRf0OB?=
 =?us-ascii?Q?+GPCaK3elm1pJ7vxonbfPExoWYKRsK9UUdU4pXWqqF3NGiJM761xYZ/0pMqy?=
 =?us-ascii?Q?1Up/mcXZqQkjWTl0vY1EYCMGYzcwK0z0C5U11r9v9+OeRnYBeXfNrpzI+Rt2?=
 =?us-ascii?Q?8E+aMEHamoELBqDSnSYyM8cz7keOdfZmdA15W/KGttRF9/yh91DEEqdrG5Md?=
 =?us-ascii?Q?EG9E7uF6+V/WYdgWLTkFV9rL291nLx2oQRxFTwtV9ZUmWNX2JUU1HTsQyyco?=
 =?us-ascii?Q?VP+iUpVGtjxoMQaVTDSnt773O9/C0zFsKwCWby2hQKKFjlyvMKky+dgmFxPK?=
 =?us-ascii?Q?8JSlNrd8X1ibaNAUyvyGfS6FSL6EJPD1WkBFkNsKVo7QEdRZxbc6p7iRex4f?=
 =?us-ascii?Q?2LjSz8gF/w3XdH91EvM0vUUPYBjQOmGVw1xP/sdhGjNYPyqrWJeZAqXWuEWh?=
 =?us-ascii?Q?frqa4Q6xRBY52mwr9+szvSEVLbEnC5a3yL2b4KgvP0NWiCP8F+v1iPcoctdw?=
 =?us-ascii?Q?vUUvhM/iF5tmmWYdsGexU94tDuNL9fVNGVS/jOJVsaDY8ZhiDrCF4zjYGRi3?=
 =?us-ascii?Q?HUqn+8PYrr1gsXYxU4KUBwnRiL5dzvZXvo7Xw4vEAfPB/e8Q9tPKU7lMOhU0?=
 =?us-ascii?Q?mtgh1V0yBzTAqPWlpX+QfZvol8as7B3soSAoFwYc745ySvfNw6njiJdhOAlq?=
 =?us-ascii?Q?mYIKckm6d63csbGtH6xu9+Zru0wgKSWcNMmD8lhkAqcgd4CjpgBcPdZzacr5?=
 =?us-ascii?Q?qgZWeR/U0ZBiV95V5iWrI0quRpkawGQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6HkpIiiud1ZJe/1YozHXByfYEsMd6YZsemILVMFqSEPNrFTStTLYolnBC1eHho3dpzl3+IBvKuPIH2Gj7wVpQOZt0zJZQFrPzr5Qb19yGRwiHqhsReUY+daxI2d5kL7qnG/5bSA6AdAbm1o3pzGwls+rOAbxvSys0Pksz+1xUBOFNm+tL9SrE0VZ+xF0K5bCf8Hm7IlSAKZGW3VRDYh3HUY/bfS5cb4XrSTgWTu/ihfGRGrbqVrHCASw8MTF/M59+y9DPBJyLyawjNzVj4gwa+qbi8exDnMdYZNsTeWMlqRbyQvP63LAxguahYGjnPFwJc9ZEErhrlOcO38uq+7C2MCFUsqsn/5BjnP0pPg0bok5mIsnuUkkbJz5yK1zqU/hS5q2U1xy+ALo4Bahmuhz6nXtpVpHsaPLZR39CSOOg1b8ngTkBjzL+tNbAc0H+WiJNefHLIwbddrZMNY7lXqleWr29E5vWR6MyJCuimcupaBZtOm1QiGQOseVacFlcMDcWC7yi6pgJmaA+inlgpwGKFkIIj8Y/zcp3C15qY8Nc2GJx0fln03qsz0vS5xUGbvIIj9ljwuwyyr/LBYfYUQ4hna+cEJpmgUpbfo8i49UDyQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbf6f4a-8aaf-43b7-64e2-08de4ed8257d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 17:05:38.3815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d231KL+suCOki3CCMh8oEP0z91mNSHqQxiUuxchB0Rkfm123tC756zaAOtJXQOwyHgjb5uCMAMLBSb/CeBFd9oATTY6hBv7y0DYWSw6BNng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5538
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080126
X-Authority-Analysis: v=2.4 cv=B5i0EetM c=1 sm=1 tr=0 ts=695fe3ea b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=7CQSdrXTAAAA:8 a=VwDrcKdGkBA00FcSaaUA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: ybIT2xO4zRZAgf2IPjgEOmAzpp1omAY2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEyNCBTYWx0ZWRfXwfp55KGs3U2t
 59DGYqsyJs4j9WgY97f35BktR0A/2ngu0iQXP4So+ztOm8Z5/nDRiScZA3chLs6hhP7sNpc4AZ1
 R8fLaKQNouMzTW/q4OIj2S+LbFGaZ2KHVEz2DgDIVcNChg+QI47HEeWkMKI5EcYLN0KYF8QkwZ5
 bxetp985DQOQlmz5QvHKI01C3iottTTikwMjW7AI8VmpocRdTHL6WbZJR/oJxcofuUSSNeZ7ZMH
 vjvtOQGkP9u5CFVCedypMP+oi/0HdL2wbfWzLZ/V4Dyi87bagUGKCBTHm2AS9OvL1smvIzuO9FN
 QdzJHgrOrXHaMZGXc9CBuGpUWTxOb7uJ2stDbXRPUqY2fAOBB1sk2UuIG4Dt5VmH1KY13XcDnrU
 ujF8Je3yr7C/5wWPJyGGL6Cd9FFco/HYMlZTHmZ/Efpj8DGzcF/PQwXxcS6SCXbB8D98myjqTIR
 3mpAV+Nq43nJe0R5f9G+iiMZa/v0/LuAYZzIFeGU=
X-Proofpoint-GUID: ybIT2xO4zRZAgf2IPjgEOmAzpp1omAY2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B9C24000A
X-Stat-Signature: ffaofjhtqfd1desrf76gwgm4w44wkauy
X-Rspam-User: 
X-HE-Tag: 1767892275-471727
X-HE-Meta: U2FsdGVkX19zYzsfJiLriEgyvtv33h13ImaTQdNFqyDoxjWCYBva9wf5LgMvvrm2hpMjnbmlnDtr/yWeHOwTq1cmAF6zKgI7LcMkPBGwHudw9RJGb3nWfCe3jSoHjuyre+cPonJ9+Q+voiV/kHHeC1APMATXVid6o7PvTgEQ8ioybvgaWkwvg2nQuW+a+yg/oYNIRLGibCX2EctnrX4OAFAULoGcCS1ujdspfpWt14jILLohurBGvfqOgIUizABwP0s/xtyJTOMXl/bdVkYkv2oOIgJXcH7EwLvmuOKkB8Md0AiOKlZvpNfkPXJx8/nA4piuR6Q3UXhYhLwfcrBK/izjWeyFE+twybbtQBgxU9WYl3JQT+2gb7rkUwV7noPD7Aku2c5BQ0cvsGoglZfDwUVBZgQKWcX7MSMgfInFO51ig9espCDeDfmrdLnU4P5bRXSFp/K6lNQpWQy3jHfOayyNL7O++kquXeYIjmql5Q5dmehBlfg+pxydGzF4aoZKhDQjvenTWQGjgsC3fSbcnTl7koXBAM0Al4JIXBW4qMiyQB6qUw8l/8T4LiV2uXiw/hq1Zbr9k8CDirOz2XOrzLABpirZYYRv8DCn7RlVq8vVN8cfArahGRygX4kjYeUlLKmM6/3oZbKSruAP3qJSl4YxHHd20U1KLBrpbog1YxEcDC/Fqvo7Ddrlyajr6TRHN29yHWeZihljrnqmhIByinfM0sPtaFgIYS6PTH2jg3b2aVAaZqiyhctGE3RlFbFzqXWc/1UU6K5ISR5hvoWa/E3WnJVH1hlSAZkbdn3Y1DZS4pN29Bxv+DIHAYiSMvEsxwVOz04CMG0iaZ4MFOQOTLyvVGQLMMRIWIFnq3pYbRmD6KniYLySedaLaXsd0IRAfEt7Wreuqp9dAW6JY+cnHDm/868UUS5t6VhnpsBmudtnM2+6dlCYKvQXk9AM5bvkUCg96aq20/oPS50Fx0/
 zA8sNwAa
 gk2klXwqsRAdzkWQHfkYAx4t/fDz4etoJ8qJpNMjcR8AVsth1V4SrgE+2anq+ge/C7fVOJp5eI+H9gLopCQJJ+SABd5KyEd660ZMb8ncmyEwp+CyaLJBXJxLuffqKi6el1w3IM0GM9KL8Hxe40ihZY6bVmqlxxozJmoTe0y7WcJQjPmTblouQyzkH5U8iVCxKQkeOL6FVVkU2uyUXq3hDDb1bSJ65Emge0A062Jsh/85UFQ2PihI/JBzkJXt5+BYmy49xN7mxMNgcE8Y395crMr6E161WS8PrBFClF42DYF1krHTogcaFFegECTZetkqeuFZ+qomuUuJ/H1cSOdUaFvRatT8ajplzZcPr8v7UhEnAS1lyERFhuLt7ZMOGf90hEIYXeFTnfOFgDDFtrcy4+tz0PQWed80OwuK7F8sWJZW1JWWNByJ8l8xOO53NsGPP6EdOIR4iD2yo3zVQOxCUWggT/bgMwo8JYYGKd72Ep0g9izjvfCNiVXC+sqsVT+gCfvxfg1aU8ZwW18oKDe0gvXOBteNStlTIRese/7c0nnXNL8y6LK1w1tmmQkqtb8yzFwUKKE8h7fuYmTMtLCnXM2fOvn9+Blnpx9yrBbhHz+p+0i2ubHNfuqXh+vU+qmvOW9kkQVa+2iaKy2dtebf1ym4Iwzboow1uQ4gfIxBa3wcXDrTlrxcSAm37n9B7R/nMdWxRxUJ5cEtvvdKXsuWj/7Xvl4gDqBQSMyzkg8a5gl4lcaxA43Z6XkkQyeGNS0gIIX+AP+ZTAimhiuLGCtKAKg5kyCf2AZ8tF90JcH8qG+CRM4TcKkLAR26IKnlq7no4CCkKWhr0rkJQcbi9g4xe2B+mQ2wFGzumDtmMsVlZKVgv9EVSeUAGiKPJfQZ9xKdASmTaObs3eiElLPYP2uB3IejLSqWOXDq5yuvggzCroN53k5A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK I'll stop reporting the merge conflicts from the that series but yeah here
too I guess it kills a whole bunch :)

On Mon, Dec 01, 2025 at 10:46:14AM -0700, Nico Pache wrote:
> For khugepaged to support different mTHP orders, we must generalize this
> to check if the PMD is not shared by another VMA and that the order is
> enabled.
>
> No functional change in this patch. Also correct a comment about the
> functionality of the revalidation.
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 433ea7283488..69fc6b41f010 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -892,14 +892,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
>
>  /*
>   * If mmap_lock temporarily dropped, revalidate vma
> - * before taking mmap_lock.
> + * after taking the mmap_lock again.
>   * Returns enum scan_result value.
>   */
>
>  static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
> -				   bool expect_anon,
> -				   struct vm_area_struct **vmap,
> -				   struct collapse_control *cc)
> +		bool expect_anon, struct vm_area_struct **vmap,
> +		struct collapse_control *cc, unsigned int order)
>  {
>  	struct vm_area_struct *vma;
>  	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
> @@ -912,15 +911,16 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>  	if (!vma)
>  		return SCAN_VMA_NULL;
>
> +	/* Always check the PMD order to ensure its not shared by another VMA */
>  	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
>  		return SCAN_ADDRESS_RANGE;
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
> +	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
>  		return SCAN_VMA_CHECK;
>  	/*
>  	 * Anon VMA expected, the address may be unmapped then
>  	 * remapped to file after khugepaged reaquired the mmap_lock.
>  	 *
> -	 * thp_vma_allowable_order may return true for qualified file
> +	 * thp_vma_allowable_orders may return true for qualified file
>  	 * vmas.
>  	 */
>  	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
> @@ -1117,7 +1117,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		goto out_nolock;
>
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
> +	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> +					 HPAGE_PMD_ORDER);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
> @@ -1151,7 +1152,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
> +	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> +					 HPAGE_PMD_ORDER);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
> @@ -2814,7 +2816,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			mmap_read_lock(mm);
>  			mmap_locked = true;
>  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
> -							 cc);
> +							 cc, HPAGE_PMD_ORDER);
>  			if (result  != SCAN_SUCCEED) {
>  				last_fail = result;
>  				goto out_nolock;
> --
> 2.51.1
>

