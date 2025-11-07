Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF296CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 05:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2078E0003; Fri,  7 Nov 2025 00:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072C28E0002; Fri,  7 Nov 2025 00:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56818E0003; Fri,  7 Nov 2025 00:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA95F8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 00:34:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BFBE586E1
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:34:39 +0000 (UTC)
X-FDA: 84082696278.01.A3D450F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id E72D94000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:34:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EzchlCE6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tiJxWBgY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762493676; a=rsa-sha256;
	cv=pass;
	b=QxQx9cSK5wdaCL4gk6EUFrKxsH94fCFCL+KU0gJfLPUIQCtXgSQI1IJyaQmnDOLoBlAsFD
	dWpfGFtU8kv7STpTrePtWEntznHozL4edvyYmHieu+TmDGPC16aLGF387Embzu+uIab0C/
	2UvgI646lgw7ekA9Kpq7XbCY5XYHVAs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EzchlCE6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tiJxWBgY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762493676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4X5i8HkI47K2W73tiVo7PUgxsZfbaFMFH4Z6tlApxjk=;
	b=myK2sZUZ9uQE/SoLnOm6LZxcIpvhZXePaM546o83KA4FkcpkdvHFF5kT6wLHFkqxwnJ9/p
	R1UEsUTlkT8DnzaVkW0Yd50gtqS8qef0ou2el8UXUQHOEwU06dQqtA2YqXgzh3/e3gV8FM
	r5PWfnOG/uFXkz4YEIHUp6ZC4s6gAgM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6LNNeb023343;
	Fri, 7 Nov 2025 05:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4X5i8HkI47K2W73tiV
	o7PUgxsZfbaFMFH4Z6tlApxjk=; b=EzchlCE6DX+2jGQ2wSFn6r6YTTf0dhMLcc
	9ppqEBtjkrE6wVPXy0DnVr/s6MZvJ4STIXcqapKFoKmcYjyhzKm/ksciwPYP+PmY
	ym7Rrgyqhgedkn2ZGxWvft21lD7+chA2pJsrGvQZgQH2f6qo9jaQNO1PdBu4czcm
	FnN56yZyS9YG5VdD5iiMzCQdwakUrchOFgdereHT0eH7b5ADKuTTw/z5o/iI4lqn
	oN1o/8BzQ17Dl+LGKFaTso6P40W+D2gSs7+/EIM+jRT1EdPeq/VYaXHiOlYc4Szt
	LGhJu3wERXxquV0KzAFW1QgF1DuCA8xOJrhpyNQyX8u4UXyteCqQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yw9s2up-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 05:34:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A74nvZY014903;
	Fri, 7 Nov 2025 05:33:58 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nd3drt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 05:33:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNK849t/z5/UcR0KqQE0qwlKAkbS/vdRLXd2aM+28Ahna+EQQbEaDViamEufSGg7T/4m+P3//EKRJNQSEBXQsJ+c6j4yQu1g/1ksrLUsp8tdXpB/K8QZsYEdfLn/exoO62a73KhZxsu0i/iYcu+/IFycYEShdFB9Ymd0l6eGha0NQMhwDsPnVIAYxyFtGUMrx0qHJW0aiyGRG36yxtV6A7k23zojcz7Oj7ndp5b3tXcl9APbNy52LhdHbcTmMTD4xEhi1ZchFu/1VGhCD2HA+OHM2cTJWs2j45SxAFDi89IHisH9lc9rdGuZuYMt/gFFhS2n+5tGRDMei9PG9kotGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4X5i8HkI47K2W73tiVo7PUgxsZfbaFMFH4Z6tlApxjk=;
 b=kjGtNWsiW/si+/6N1eUGZfp26OkDRfVbTfmz9Sam78EYswRO0WDYPuD+jneFRRw/1v4dzJXAAkwbwOr1bArNti473EPkwV4aVSqnqw30PSEtLsMJMbF818hbhK08ElpYXNOMePpyTBTF37AP1nHL7ZsGMEBEOxDnpoN3NK9UAzAoEY3WtkYIzoO12wzJ16xBZQtH9tMzR9dO+nqDBEbTAGj98YL40bXoGIeY9NZ3kV7rC98oDC4s/m2UVYKAh7QJmJ9x6MssM6mSD3qjWYFByjbAvWur1PczcUc44pbnLtL21FTBkrWVYrf125JwKe2CW0CZlOlURQ04gT27u/H8Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4X5i8HkI47K2W73tiVo7PUgxsZfbaFMFH4Z6tlApxjk=;
 b=tiJxWBgYdvsQG6e2g0iHFNmleI2Oikc2osZUP9XjoDldnmwdQfCoVLFmFfcYKtgIAw8I1c6+mNynQQcf+gXDSvDreYnfUcPrbQOtX3EJ/LEvCWuln3jWQ5wHVr1Zo4wYiqLOp1sKfbETL/d4r8i9O8ajBLCdfdtSHYl6R17ZL2c=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB5552.namprd10.prod.outlook.com (2603:10b6:a03:3da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 05:33:54 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 05:33:53 +0000
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027143309.4331a65f38f05ea95d9e46ad@linux-foundation.org>
 <87qzunq6v4.fsf@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        david@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 0/7] mm: folio_zero_user: clear contiguous pages
In-reply-to: <87qzunq6v4.fsf@oracle.com>
Date: Thu, 06 Nov 2025 21:33:51 -0800
Message-ID: <87h5v676f4.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0315.namprd04.prod.outlook.com
 (2603:10b6:303:82::20) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB5552:EE_
X-MS-Office365-Filtering-Correlation-Id: 696b81ea-7b0b-45b1-87a6-08de1dbf3c55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fjri1PuzbWLtk92GFLxr2gCcpXDWPdlTEQjk3KpCKPMCLAwNiDgBHeUWCRH2?=
 =?us-ascii?Q?VUdA/fEUE4fhuL8QhX0tlYKSdDrfukakXmQEig+MYKtmmQGZkXkS3Pcfc5oA?=
 =?us-ascii?Q?E1dZBZTXCQ1ca2WyyuroettLMpPXeCZe4ws+JpfT35Ot2LYy2ydfpDVT4Qvd?=
 =?us-ascii?Q?6n5rHGNppXXumiwIhJ2nGs9sDSnkwRo/GeeD1x41bvDZAQfR9Vd/Korr1P6X?=
 =?us-ascii?Q?VLTbT8TQ2IggmCiZ6qm78/RXVMPc2rxUqFICsv7J4SLXt0CfAj6x4kVO4iYN?=
 =?us-ascii?Q?HcFMrJ5JJsP4uwhfdCNRcUVvmfRwlUBdmgqp4sgpizwiIPtMrpUGwd7B96yc?=
 =?us-ascii?Q?/jzabz3rN5nCRFLXsPgFDk4gUywS3iGCLbOcH5noUmjcsNHVU7CsRGC6Z7pu?=
 =?us-ascii?Q?zM5Pqo6xmQiPgrrLeZjbKrEpajEU/AK/jJKv5HeAE97BH5SwcdxNlcTNoHt7?=
 =?us-ascii?Q?1tkX+fq9geNfm/DtdBs8xs76OKdkPq0eSsB1TGlWPydBP7c49JiutL5aAq9x?=
 =?us-ascii?Q?0nky3GppdXB3EJ665p8BhnwB/uD5ChlAIrhc0j7+HIpQaNANQ+bl5no8FGd1?=
 =?us-ascii?Q?Yy/4XEEWEySB3qioNlcwSlAWLL18XTWXKTfEK5fD69goFaJSLAg0rk+okG0A?=
 =?us-ascii?Q?6TSoWJiBWjr6hJnyN5S6d43gDL+Ce6WsLHXsUtmQ7AOz8waCEaaHfVBPvNMI?=
 =?us-ascii?Q?utB+mEmxxtis0HXsDAIbtScLXcQasfBgLCG6HtqBbO4GHXZEcfJkVFz0Ryv1?=
 =?us-ascii?Q?NIHdEGQIhd8mmrJ9phIZ5vCdP1YB+a0h6ed4yelBWBgO2EheiBcRj8N/MlRS?=
 =?us-ascii?Q?cECXAqymdaciLhKY7zwXGLQEJBfgdvksZReqpxy7/z5YQ93igNDGroAsWZcy?=
 =?us-ascii?Q?/nuxmPwSV+kG2QgJlSo9VgjbPhbNPAl9li8fwZGJhJJdMmO4TAtElyosXwRC?=
 =?us-ascii?Q?w91y+KVZU2LeZBfNAgPPzN5IpliMo6idfDUISnWhBi7mpP+SGyVB/82IiUWm?=
 =?us-ascii?Q?WaQ7OfbHZPFsDjEYuMbzazc3b9aS1tGj9Gg3cZPSoLni1AmnYIjEN0DW0GR7?=
 =?us-ascii?Q?1hO/stIVoylhYIGO0HF83YSpinnUPy3Z29xH6n4jdWq1os3X1tFMptAqrzKM?=
 =?us-ascii?Q?3AODWDtwJ/kmTdx0bEKA31FLNnmBisNsXNoY/KHwnqdeDRPKHzpK5uBdY+yK?=
 =?us-ascii?Q?JAFYzPxFhNlArJP8cgHKGIcbaDo+cMBSgyUluTz3Z7nnHfqeP+SE0txbWIj7?=
 =?us-ascii?Q?qvZqr9jC4KXFmANWguBFcBxxcj7k+/wh4U/S/hijEIj9P+el3sIu+umwEE1F?=
 =?us-ascii?Q?f4VGgWqsaq8duj8U0RjT6jqXKoPrw9lpjxIgFe4RXG6fZ4IFcSDISLOPG62r?=
 =?us-ascii?Q?KJCt1qDFvw7rVS8hDswodjm5JvJ4oeSqWsyNZBDTivxHtv3Y76mKhIXtvNDA?=
 =?us-ascii?Q?8on+vF+CbRtPRHkDO+4Fdfv3rUE9GlUeYOAs6gAjnDPS0P6Rzr1B1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NOJ499S9k377MWnREwDwZYaWrabOxoKjz+R48knAVUW/owJ6/CfwEE7muWNs?=
 =?us-ascii?Q?ayuu/TvSnTYEguwEeOMI4T2cyxy4u8WUBzf087RRqnxHIMrD6XOCP1N5YSK0?=
 =?us-ascii?Q?dT6BsX+hfLcWRWHEi0imMjM0HU2jcFsELI9ZIyN80SzvwJ7PMSExlcMiurXd?=
 =?us-ascii?Q?ZSBqHBu5xxsanduILerbeWFZwfSmUz7V9UcRZ+6+8TXM/G8qOcecpP2pKdgv?=
 =?us-ascii?Q?DxTBkhn3H6MMDcmLU6AuuwgX1GDiNofsIor5tgjwHknbHDeZ3UkpgbW6wH7t?=
 =?us-ascii?Q?0np9pA68mZLymb5O7vvRdf9bQvN367dLFxu42JTw4O4Efs6+tT381aNv1Mxz?=
 =?us-ascii?Q?oJOAh0ofE8nWYcM6qvkpkoS7ASrA1R16XpzF9x8pd5cFpw+3SK5+rCKBo2IQ?=
 =?us-ascii?Q?bBsurjbQKxMYLj4H18/KxFq4kIGLvRzy282q2DeiqdireP/540gT7J07ysXJ?=
 =?us-ascii?Q?YamXItHxe4glWjhduqMzn3Bsc3sB1gcX/A+FZ6jMpz0eI/EFQzPG57b8PXQd?=
 =?us-ascii?Q?jdZfCVrRo4ePHV5x0Nq5DNMJQ95X7+0Ui9h/WOb+HlZe2CXQn6fq7pMd9wcb?=
 =?us-ascii?Q?7RV6LuDv5QHP8nALZRGpwDfLrzW/ajepjhbW9rSzRAdyLBDKP7sDNVWzSaad?=
 =?us-ascii?Q?XGhZzQPuvwsuNgV2gVoUqtoX9QKU3gBpu4AVDnxhzXgAtSkc/+I25ai11uez?=
 =?us-ascii?Q?rBzzDi1HzctAefEQpZZqkxcBojYiPnCGNEZAzOhnduoKBgvRI5WwQk4G0fyv?=
 =?us-ascii?Q?qBw2LE65CdClvW/lnZ9//fG7w7pH3jZ1NO2xYFk4QkoaTV8TrKVtXEN1Xlgw?=
 =?us-ascii?Q?9naHKInMOF9HABkFAySULgMTz+xwG2TkjBsYDBBenHcPfPqEw2xRzfCassrW?=
 =?us-ascii?Q?bblFjGYX9JOBREZD3pL0n5f0bijZocJFUIQNsM4Z17AdNf65c83g5pfu5ODZ?=
 =?us-ascii?Q?ND0s/DTaUN2+AXEiXNApFDaCCoxvO2WPAZUAKCap9Ap5uzOlki7kdJdBMb2a?=
 =?us-ascii?Q?iw7xJz+gQGaB55TM/d8TEVKZ1rImpLk/jbpKIqLMyIL1stakFbtHeOXnkVXc?=
 =?us-ascii?Q?wW6HnlDGZ5WykC3EKbeEBnZ4ejJXDYu9DBV8A/NWfkp7ad9TxgVPxLccwC3s?=
 =?us-ascii?Q?UZry9DQ1IzOdoX968rYo4Gt9I7EF+YPvcuk8Lz4OLhSqC8YJp+i3dcXNqLnV?=
 =?us-ascii?Q?dH2VqILsZYbb5fzi4yhYVokV6OOPwDVOCBIVn5KaKVbSfJBH06FFcSRJS/FL?=
 =?us-ascii?Q?Qf7pWMP3ZvoLKT4h+K0iRVo4AaADyUberAIEVSmVDdTi1giq8adNiB4WSKR8?=
 =?us-ascii?Q?l/N6cZsb2Kt9UId6ECemg8W1E3uhAERjlIM6wnHbF9K3XzKzplSRlM0lzQ6A?=
 =?us-ascii?Q?9yfTYD53eOcdee/7MlB5qopVY3HLD9JBvPuveN8t624r7UNtRbj1ylGlQQLJ?=
 =?us-ascii?Q?pFdVzMBF/zdyNVFpxQkdAhciqXiQN92bAdbrez5gcjp8PqjjCOrI4BbZztCe?=
 =?us-ascii?Q?iiFOJrUwmrDmVtURBWD7WCHi5mVsKtmMrJzpFlVubEA+Konfs8U6HBjIM/nT?=
 =?us-ascii?Q?hQib+wvONL11a9s3iUEH4H11sr4dSVHEN9fctItjcbz/x6AuX0PXakArLDhn?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jwm33hQlpju74epte6oRcJlM6IIe4QgZ97nFXH+UTAI5nf9eEFkYkJDsQVg3g4YL63I1s13zV+EIBNtrxUeIupbXKHj48/+9PqLKiu5BT4dLQ/i+Hgd4f7BV0gn4QvPfz05VGksCcW2TiLWiLAPTMkSgo3fdjeEm/IUlhYfeZeN5G6/uipNaD2s3j3MKKLx7TfpVkxqqy+WYJkS2G67fPs60k0j6AeGgoOo8NzwSztVQ3YF4kTA6iuwj0DZXTpotVXidSuphEha4mWTwVkO0ToB7U8tcwxddTvJV95uFqFPTeDO1WRrFaQsoSWAoBnFQiUCW5UzFyZVlYJpg9aH2M4cPZG6vBaDjJjBJEVnHYdWpKK/fpNLWUZCQYNXh6oRwbG/2xNaIprJC2s2UX2W2iUgyyIc/IVrWuY6uLQKI/fun47Z7YYoE3Fn6xZWDELE8djW8TQVqjHpVU/gkGuk7pI7ZWJyqD9zF4+T0/H9hwCamUQBBJvkyy0/0/bthI3MDEjEPR3BxZKWNx+tiu+rFW3KOlwG84BwELMOZwwgZ3nFdwNPSw8o619OgYMwuPDmb9nRY5OfgiUsi1u/I2AxhmuKSjnBQn+0Gr2sNwcMvylU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696b81ea-7b0b-45b1-87a6-08de1dbf3c55
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 05:33:53.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UneR++f1wLE0uEzlyB1mxDJfdJ860e2X5L4QMND5luaXcEKJXKFeBeUV1cbYkpZVSPXVPlaRupN1mHwoXRA1PZDl2iYlPga+VxmgaS0iCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_01,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070042
X-Authority-Analysis: v=2.4 cv=GJ0F0+NK c=1 sm=1 tr=0 ts=690d84cc b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Z4Rwk6OoAAAA:8 a=QwbjNL8QkAw3Oz8Sw9IA:9 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzOCBTYWx0ZWRfX07UATT0al2WI
 uKYxGzYchZX1x/IXL3C1+81j9K0ZsMyFbS86YNvCdj7yxZ+Pm1km1R4obUpYHdrWsFvai/o9GvW
 IlBqzlkwRo2+zh4quwYRHuygsfi1lpn0fMd3OgeYuQyJpp+5spMplyrdR+Hbooe/iCFcwQWL5G0
 xFj0NaVcARCLZ3g/w92afevf2WuM87DgwhHffRHoOlMHuI02BdO7WlJSWaYaSk3YsFue7bc24IR
 q/HO98CbF3d/BM1Dp/eIPzx9qjIHFtGgZQ0vBoyXi1vuCbsRxYmmOFtZWG3phTZqgosI4N/Unwe
 mMT5ODWMiGQh73WmNQdTT53WPYR58gHbobBXXG6FUbAt7A84iy37STvb9nepCgFUUhPFnLgTj4h
 888u7oUxGQAst9UIsH09G+hX3SoyMA==
X-Proofpoint-ORIG-GUID: O0jGPZaltfM36xCGokid4lLnlLzZn_UC
X-Proofpoint-GUID: O0jGPZaltfM36xCGokid4lLnlLzZn_UC
X-Rspamd-Queue-Id: E72D94000D
X-Rspamd-Server: rspam07
X-Stat-Signature: dtjd44cxmpyjodzzc7nb1ygs6bns39oo
X-Rspam-User: 
X-HE-Tag: 1762493675-765302
X-HE-Meta: U2FsdGVkX187WrlW4oW7j1QgBW7An1ttbjNmlH4xxuI8/X/KJMt8yUJ/FxmIEQXj6dayz4ny4YGCFJggfJMbimz0FiioFHS3AQe4v/MsaA29gHYjM1BMWiTCP9C8K1atLtpXetllZ0a3oy2pp0wgL0CKkz08BoKA2GAE/CQscifRF0R8VmHy9dxkibdF4tk4l+RX0xwUiYhCdRegCkZ5EbOqyAWi9Jj0sQtvB5MzoNMb51rN+GczrNNTmxLQJyhASOfur5l6u37wqZ7/cPBfFvjGbpAIsBaWiQegFkQiI6F0CUgTpTnpYXF85o5CMipj5od+7UCPOIor/pIz2k1nkfSI/2R/CjM/4GAK+yKudPgdNKqLtR5huIQGJ+++T4Dl/wssmvJBveNUliFa/dozRKV4ZeAIZzLEetWOc4A7WgFbTdAYTQNxc45c51rcUv0uEjDyB28MvKM/RGDNAv/+X/QGryGEoCMSB/g+pjXVGYji8A+Au6LipseH69ymBFmUxOQsfw2CgLCzyMTEM8KGXDZ/UOW38YA8iCTdxNsnhs2AxeSPy1GioETON8ILZMcTbrT7S8CdHFdFwAGXLlneoUfrEQEBqyxiNTef8o72VTezAQ5DXgnz7E1eR+JOIM43eTV/l41m6nfIw81Y1WT5ecxOK7fl0c8cn+Yg/G0huAIMxZBb8ds19qWiv1bm8o3nsqBdbe/aJM8EZQNY/2hr8MKfRzgY7+RkKuB7dkXTza4we1IkMhoTsiPkoAAI0Mlk3Jw+5oItB5LcnrzYrsRUWve/24NOJs8I8jIl+cX1TAKVCQbaWdr4bUD17wOSZLJy+5/cgfRlQILxviFon3OhVzQlh1C/8AxjHGOK8mcB29sBgS3q8kIQII3ZhZ+fDMKtKKM3wuaaAlVBoJ5R41DR7QwxYhAEKiP/B0njOoOu7ZL29204VTVXMC3CxsnW7pWfd0RNVITb2Sm7japR0Pf
 olhzzjTi
 uocoMdOqjYESZja+72sJM7UskfzpWyKKLvJi4Rvnw3kyigtTNaKojrBJKqKK3bvdlXWHm19nmUyoVXB5ASGkKABY4THK01CfPtDUsWNKDErUFbRBW5EoXrNNZOr5tqvpznrz6RjWPw5nwDQ2fIKtWpomG023/hhfFpJTkSA0hX23xFfmv6n8IA6ILpaF2U1Lnul/7A4FNN2SGXOQ/+K0B4+WgxtsYXRDhXhKSX8aY1ke99ffVG8zYM/JEs3UBYk7lgC1mygXE993cb0ASauocJyF/UBjMpl1DINpyNnFC5ko+i2ZAuM2onJflR89Ad30PwUX5uTXHomXZ45kSlU5QzCLWTmlQcTSHwJzUtVRagYcrrzzKysJKY/6aay0MDhrmiLtUWcmjAwu+pZOY3VP5nNaCNaTGOQGrKnuM4G5Uiiab/zxXGxBH+6o6O+7hCNCRmHQ0+cS5V4xFZ8DkeldQKZw1z0bny2q8oZY7ldUm7csKm9fJ9BrQQzSP+X+BDDsUOa3zbHFEBzDW2L07L4PK+f7csdm8wvWY7ssB8/pMpzPHpyZDYfFKoWyELDKjRFe98cwUGNMz82DfDYSsmE80/GHA0Unug7iLAh9MvFjUqndKM0AVahzb4MLHarV5xkVe6iTj6AhGjqDMfv3woI4yFWeC6kgvURFdY/loYz2wyMwaFQknIEGJV++V65MGVA71b0+Cwm3AGnliQzOenrxxlvwyb+njzaJpHgKUJoCtlwmgT3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Ankur Arora <ankur.a.arora@oracle.com> writes:

> [ My earlier reply to this ate up some of the headers and broke out of
> the thread. Resending. ]
>
> Andrew Morton <akpm@linux-foundation.org> writes:
>
>> On Mon, 27 Oct 2025 13:21:02 -0700 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>

[ ... ]

>
>> It's possible that we're being excessively aggressive with those
>> cond_resched()s.  Have you investigating tuning their frequency so we
>> can use larger extent sizes with these preemption models?
>
>
> folio_zero_user() does a small part of that: for 2MB pages the clearing
> is split in three parts with an intervening cond_resched() for each.
>
> This is of course much simpler than the process_huge_page() approach where
> we do a left right dance around the faulting page.
>
> I had implemented a version of process_huge_page() with larger extent
> sizes that narrowed as we got closer to the faulting page in [a] (x86
> performance was similar to the current series. See [b]).
>
> In hindsight however, that felt too elaborate and probably unnecessary
> on most modern systems where you have reasonably large caches.
> Where it might help, however, is on more cache constrained systems where
> the spatial locality really does matter.
>
> So, my idea was to start with a simple version, get some testing and
> then fill in the gaps instead of starting with something like [a].
>
>
> [a] https://lore.kernel.org/lkml/20220606203725.1313715-1-ankur.a.arora@oracle.com/#r
> [b] https://lore.kernel.org/lkml/20220606202109.1306034-1-ankur.a.arora@oracle.com/
>
>>> The anon-w-seq test in the vm-scalability benchmark, however, does show
>>> worse performance with utime increasing by ~9%:
>>>
>>>                          stime                  utime
>>>
>>>   baseline         1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
>>>   +series          1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )
>>>
>>> In part this is because anon-w-seq runs with 384 processes zeroing
>>> anonymously mapped memory which they then access sequentially. As
>>> such this is a likely uncommon pattern where the memory bandwidth
>>> is saturated while also being cache limited because we access the
>>> entire region.
>>>
>>> Raghavendra also tested previous version of the series on AMD Genoa [1].
>>
>> I suggest you paste Raghavendra's results into this [0/N] - it's
>> important material.
>
> Thanks. Will do.
>
>>>
>>> ...
>>>
>>>  arch/alpha/include/asm/page.h      |  1 -
>>>  arch/arc/include/asm/page.h        |  2 +
>>>  arch/arm/include/asm/page-nommu.h  |  1 -
>>>  arch/arm64/include/asm/page.h      |  1 -
>>>  arch/csky/abiv1/inc/abi/page.h     |  1 +
>>>  arch/csky/abiv2/inc/abi/page.h     |  7 ---
>>>  arch/hexagon/include/asm/page.h    |  1 -
>>>  arch/loongarch/include/asm/page.h  |  1 -
>>>  arch/m68k/include/asm/page_mm.h    |  1 +
>>>  arch/m68k/include/asm/page_no.h    |  1 -
>>>  arch/microblaze/include/asm/page.h |  1 -
>>>  arch/mips/include/asm/page.h       |  1 +
>>>  arch/nios2/include/asm/page.h      |  1 +
>>>  arch/openrisc/include/asm/page.h   |  1 -
>>>  arch/parisc/include/asm/page.h     |  1 -
>>>  arch/powerpc/include/asm/page.h    |  1 +
>>>  arch/riscv/include/asm/page.h      |  1 -
>>>  arch/s390/include/asm/page.h       |  1 -
>>>  arch/sparc/include/asm/page_32.h   |  2 +
>>>  arch/sparc/include/asm/page_64.h   |  1 +
>>>  arch/um/include/asm/page.h         |  1 -
>>>  arch/x86/include/asm/page.h        |  6 ---
>>>  arch/x86/include/asm/page_32.h     |  6 +++
>>>  arch/x86/include/asm/page_64.h     | 64 ++++++++++++++++++-----
>>>  arch/x86/lib/clear_page_64.S       | 39 +++-----------
>>>  arch/xtensa/include/asm/page.h     |  1 -
>>>  include/linux/highmem.h            | 29 +++++++++++
>>>  include/linux/mm.h                 | 69 +++++++++++++++++++++++++
>>>  mm/memory.c                        | 82 ++++++++++++++++++++++--------
>>>  mm/util.c                          | 13 +++++
>>>  30 files changed, 247 insertions(+), 91 deletions(-)
>>
>> I guess this is an mm.git thing, with x86 acks (please).
>
> Ack that.
>
>> The documented review activity is rather thin at this time so I'll sit
>> this out for a while.  Please ping me next week and we can reassess,
>
> Will do. And, thanks for the quick look!

Hi Andrew

So, the comments I have so far are mostly about clarity around the
connection with preempt model and some cleanups on the x86 patches.

Other than that, my major concern is wider testing (platforms and
workloads) than mine has been.

Could you take another look at the series and see what else you think
it needs.


Thanks

--
ankur

