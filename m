Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9889BCCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 18:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9B38E0005; Thu,  6 Nov 2025 13:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC09D8E0002; Thu,  6 Nov 2025 13:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88318E0005; Thu,  6 Nov 2025 13:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A5D968E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 13:50:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 501E4B74C3
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 18:50:36 +0000 (UTC)
X-FDA: 84081073272.14.55DC32E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 016531C0010
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 18:50:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nuOzVxKj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hIS1ceMt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762455033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZlNQtiIZiAPLWpAq+uCxpzVzVEQVFd+SgbUVZnAUva4=;
	b=5hQMk1hYu4UYUJLofESrRqkQ6znJXyU2m9iVa8NcX+sj+XHdVwvmQrjmzo+jQLZHQJlUSh
	sJxicTviyIfIQFWWwYU6kSiw1g+dApoEkkOb1h47zyzZISiXwE/reGYe4G0oD0SCqjjMxE
	BI3uxqu9eozS0IYF+rvJd5XopHdX/ic=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nuOzVxKj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hIS1ceMt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762455033; a=rsa-sha256;
	cv=pass;
	b=DRdWnMNcE2qLDXG1rDiT7YpL+BGXXZND0C/uDtc7hYTXtMSgzQRQ6ojj3TTgCRuUnGeGrA
	wNzbeTwNS3T0bM1ENC1eAP6Cu8ySXFrdUiwViI7beJWvoycqfryWdHJr8jX28dEWKHMa0P
	/2IQ1VicOXYBTkCV0GtQJ7AgL/DfyI4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6IgX7p018083;
	Thu, 6 Nov 2025 18:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZlNQtiIZiAPLWpAq+u
	CxpzVzVEQVFd+SgbUVZnAUva4=; b=nuOzVxKjriB7yijrZ4RA+PQgKiy9B78UgO
	7Mji4DFWbhPmyb6Kuv7Ijhl8MvmnhQEa7rTmDZ4LHfLN2wsIYjnUcDjjSxEul1nt
	WlBiTPi4Lyj15yrPKnBTn9OlGZy63ITlR/BE7MRG+xJiowGb0xoY3yHhTS94f29E
	ZlbHEMgid27wd/mjLd0yhftPF/ZQOMxWXKCJptPrRto1DcisOfmzv+/z+ZMlszZf
	NLOtpU5TlZsPlqnvtEhqoEcrMA3+S6F56y0FlBHi2yRBpkFcjBy0oeBxl15C8SNg
	6Y4YsLK2zam4/8SXR5ZVLt79rTcQh/jqBPj/qxBvmiy/OS1z13gA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yhj090e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:50:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6HA6FR023067;
	Thu, 6 Nov 2025 18:50:08 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ngbh90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 18:50:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=krIjcRRAi3AIP6o603SsTrb00dmkWrZ5JC+3b3xyPhs99heF1M0OhlYy+tyZ4D5fi96aXnLUvUbOhn3c7nFrAZOOBXZNOgOCLRfu3PfLy0z/LhHxdDJLmcjmMFMdnPonLTwFcMmjZydZSpfKboTDVcepht3sbUpysMEMuJ8KBZ/flXkqdUCdCblwQE/uduk4czUGzXWLcyNC4ClVu5alAlAnf4mMv6T4vYQ/qjoqM/TVmaAw2mDvyz2sCsdds6CAjpRREpGElwUBXl/UWDLB28Ok3gWPj2QuITGPbRkxLaj/MO5N68yfvaPDR6ZB6fr7awh5I1P2k44pBPqW0cwGfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlNQtiIZiAPLWpAq+uCxpzVzVEQVFd+SgbUVZnAUva4=;
 b=pIJZbPbyW3zfnrrdYDCr5JmvvJUaTm7v+D5c9ezGXoORxM4m29DsJpW6IIRkSJcAfNfC14eeNnrqDEP48Fp3X/Em1SU6iimEYKXFoPGbIFxcSqSRPTJM7j1FadOWYvkveSeUtOV+q4OjBL3fx/7s8sK1ZWKv7NlbbVYN9shuj0P2aFZa8+j6FRPTYZfJi68QtiwSVRzLFwcR7pyiG8c57tPHd+oTr2zGsIssI92ZmRSlAZnzx3PyWldoIyOP/wkSKQfB5xvrFi5iMG1AnqjN0GnOz+M+MF//355qqYApKuWWoYPQu81FF7h1rpaJLs+C9UXswYbAoTyoCgbkYcPHQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlNQtiIZiAPLWpAq+uCxpzVzVEQVFd+SgbUVZnAUva4=;
 b=hIS1ceMtOFVE6Ca4nM97t+H/sRCmsuEz53aFaM5YAWH2CsSmNzpdwWslS0e/+R+jib8mHMu2hECKgODQ+HQaog8IetTJcdY77Z1RNzIT+voKIT8hprh2AiJNqPlbUAzeXFNBACYbjDeBJWIGuLPRUgK0NthYGmP/WfO/6Up6kjA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Thu, 6 Nov
 2025 18:50:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 18:50:01 +0000
Date: Thu, 6 Nov 2025 18:49:59 +0000
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
Subject: Re: [PATCH v12 mm-new 11/15] khugepaged: introduce
 collapse_allowable_orders helper function
Message-ID: <5b2dbd05-094f-452a-8067-d342b2819af9@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-12-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-12-npache@redhat.com>
X-ClientProxiedBy: LO4P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: d95aeceb-c781-4847-3a7a-08de1d654a80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?orl+ifaH86AimtB7x8poK+I3CeHKdT6tOt5Cv2MDi6LZprrk5RNz5C4QAZqI?=
 =?us-ascii?Q?OZo3HFqMKF/QWqRX9tTvjt5FKFJaWrJUv9aWL87a+Mq5gRscQA5RgtOybKHQ?=
 =?us-ascii?Q?EhepKvJce0mmKbW+bKbIukqqtcg+XQwNY8PsrSxUdUK3ak0jsXEBccFb70vc?=
 =?us-ascii?Q?5XCsGbPuqJcd2iFtc33JvoltLtWU0oQ+kf+obQPy/XUv2z5mn6QbPuHE7a8p?=
 =?us-ascii?Q?TcRD3E7W5XKRBkgTep+9dW/XqBjcEqDvEfOVS035S5ttHY1F3nsfk+SeCuSv?=
 =?us-ascii?Q?WWsO6ia1I47wuNpybMRa97dXgvQLttQRUu4OawbrC640a+WzEjrGfvBhT6BJ?=
 =?us-ascii?Q?FyhNDfeHzQB9/MiyXSk8v5ZVpfnqq90ZUKCGEwMg0DUljgbQchiYWSgJTlmP?=
 =?us-ascii?Q?+9UtoCgo6rbnGm6NH9kr2qWzSJBaMs5jJPZtErWemYxYBe8VGvjV7rhllKQW?=
 =?us-ascii?Q?8CWJJGHi490EmVlOhtMjNa96tVXQiyofbZpyIpdra3JF30BLOSVHVkuRJK4W?=
 =?us-ascii?Q?RRCy/dg+ysFkUqxfBqEwSijP87UA6lx+4JkFI3FvrjR5f0qjXg/FNU6JBYxo?=
 =?us-ascii?Q?hpenli+3biHBupTQQFd2KUpp+WjFqrwduoYxEIA3KZcb59PkmqMPe4B5VKs4?=
 =?us-ascii?Q?Rx9CStUECjzfUSwSKJCaeOHkySwNEsqjmRF34/bMnFecFtvWFw3wYEY+xTpm?=
 =?us-ascii?Q?T7bxZMvbljY6fWKKmUj+YQKR01W5qJuKgn43JOdjDZHFsFfiC5kqkb1NUKnE?=
 =?us-ascii?Q?BQkKwxRgV/IeZgnUd03tSbfVtohxxqVP/9HonW/wwE7DTnAdItVVpe1/WHGo?=
 =?us-ascii?Q?dtOQIOlapkY6lNdjpwU7IqEkK/Im7Rky+Oaf2BLNC3G5O3ak0m0rCi+ZD1pO?=
 =?us-ascii?Q?4/XjOV4SeVSYPDG+aDFZ2bgHgLMMdHfXDubllqw5oSxybw1PMdsqzAtNsfHP?=
 =?us-ascii?Q?3jbteJ2jupS2oz1gc0b3mqtVM/CurELs3DSuCtVFCcrSRVsqHUMsbgthxhlF?=
 =?us-ascii?Q?Gjdh0sILOJJaAudFQSjXKcdFrK9pAgbzjoBYYdNCRtJLcIeWlgfLAjZjC847?=
 =?us-ascii?Q?Pl3gS+w8HzBESiCiAB4vZjI+Mz4mdcKH5hrt/7Ktr3/Zb/czbs1MU9I4RPV7?=
 =?us-ascii?Q?Tue3VgqsGpsENOPIzvYgUvsvRvvbOe7N0jxWhiiPI/XWR0gFAWoRvvhfmenv?=
 =?us-ascii?Q?sbWrLb1usnXTV9Z2vOpUEgdrWxBA0ZhqK0j/zDQleHusOQyP5SjMRf1o0n8O?=
 =?us-ascii?Q?TyzkMdICgHxlHPExRCH+2RA5WYEWVfS+Akouuf8qGhy05Kk2u+P3CppEacAd?=
 =?us-ascii?Q?mqKZ5BlNLsygHjbp21/5VTOGytKQ1Uvru7U+EulkEAHnbnu2MUF3DMfcqoU9?=
 =?us-ascii?Q?/i1JsXXX59DNXe9GRyRcbvfwnMx+vludYKJSs+6aA0N1JHvOgFiNFxzFPxeF?=
 =?us-ascii?Q?psuo0a5dVQfP+xt9gKIcwaMKf97Vd/VQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZULk07LBNF+haZnb/hXX0qEAUlYpWNoydx6LPlHR1urqHMMlvWRKfxUdCxjp?=
 =?us-ascii?Q?1CuLv4SCBXLKGibZyTKL6ZDuMa4wZJmWFleT6t/R+iN+R9CCnsPtshr5ePux?=
 =?us-ascii?Q?NbIHbhH+vBphs99f3b1iaSCz1V73yPuSTGhSNXHvvnrKhuNJULXaSPAWJr6D?=
 =?us-ascii?Q?3RqUJO7QrZbVvzCg/0sG5urPWVhkKtczJRREax94quglnf4jv0qcuQ9HZpzH?=
 =?us-ascii?Q?I6pquJD5XdBZhqEI3z5zmUEdvNpddC2F4EUgAqGjG1jpvMDfx9fFNVx7HTp/?=
 =?us-ascii?Q?hXwUt0+oa027V8KZOLidIwVP00gcJNxOs4qrOw0oRoccAgO/04IZb6NWc4W4?=
 =?us-ascii?Q?jpROhLLLPU6/oGbUSK21UAXZTxFUGScVOaO/TVZKDCQXPZmtv96M4phWPs0y?=
 =?us-ascii?Q?qXvdcSS99c6nwYuygGt+Wz8XBjjZEX2OvQ3E1GdwVvsLA+HDnZuEhpfCAEfR?=
 =?us-ascii?Q?29tbYFAYWhu2wqzICGsZRy9oZ7WSGKniMRTvxNdtoCHLzuCjSHLZCVV2jbNl?=
 =?us-ascii?Q?vmt2uv4h/wkOeDTHAyZxUUhio3QzXnlT86Pt9QRQ0X+hKBNaKQvXV83Y4DKc?=
 =?us-ascii?Q?aV7qr2E1Xx/mEfRuCwVUGudQSXmz73QWfT4w0e/pWYx7Ic4HI+fr0YA/Xl/s?=
 =?us-ascii?Q?H0dWKLXk76dcJpSmkKkoEYhDcoiA3oxWEA1hUb/D989PiBPpLwbjfIkjBVFy?=
 =?us-ascii?Q?SuCw0bE63zsfx9XpV6jCSps3R1iDi6fBtr5bj5qjNggK8oWSlfa3A6xAXAoX?=
 =?us-ascii?Q?r52j/zxj7qBLPvoetSb0IBiuI0fK9OLm/37J6unSYo3nx1dfAmoD/vqhELNf?=
 =?us-ascii?Q?pJ5S4vZKbiFhkEdBA9rfc99bASvaJzcghqOGF+v0l+50txe97iTeNOZeHZAd?=
 =?us-ascii?Q?c0CjM7TCcRjH/OFbhWTd/gBKot8DhN9x5cZQ28Ilv+OSxJdVrl4YSnjD9WoS?=
 =?us-ascii?Q?616dHzvEfwi1PwZczJqGZ4H4JY1iVRrZs7I97cN8szoqlOWXJSpI8mFW0KQx?=
 =?us-ascii?Q?4FEOJ/4AJKLrmun+9sqsdHksl9HD7pkejjrGLqZZcKRRwj1CAhL9YUfpEp6G?=
 =?us-ascii?Q?1l0QUp1cGJ102ee1mC3EMoEmZDU8lDsGEvAANuD08VtQy9WURAusNqf2qYXI?=
 =?us-ascii?Q?NyOIbDSFocS1+Qc6HPFVpnfukEHEceWTHRPYIx/BAeFWJQX9ClE6g7bNNjx5?=
 =?us-ascii?Q?qNrad6KfzRUXRE2S5q070bNZfSZKi5wa3O4QbBn+p+OJN2UZcYdHik1WR9cD?=
 =?us-ascii?Q?SbbipxCYFqZF6/61LV+i5Q4TdPu9w23Lnf6AoAAeGybKoDZN1iGo57I9o+CS?=
 =?us-ascii?Q?7GTPaiSFtueefpIv1HFld7k4aeZM3L7CmyigGcKnYKsVMKgEFqqKx4x4olVp?=
 =?us-ascii?Q?+ymAeirmX3ioUjqEGDDZS+KHYz22cngpaOGXIC3QrghL67MkbBiLSzKH05xg?=
 =?us-ascii?Q?YI7h8XH/A3YDa3JWVIumzwjIAevoTz4NOvCYKx+OvshoPmubFwEl6+Ta7RQv?=
 =?us-ascii?Q?ak/kdI6IhvQVY2orrjGT6g+H+BUMWRwlqykHcO86jkqhp1kkVfXcxIHItmla?=
 =?us-ascii?Q?bwQkKRH9SlZuLp+R6b+udh4EMAsGIl+tYtthEFMj3ZfnF2pZtpzYoUTP/LUN?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KnnlSRoQHbh0buOeEPQZb61ks8U5BdmL/OrDuG2qgv+ICNvXRt0zxG24Ju5keraS/kkFJgFqGdTyZiSvIsQOa7JO6KK/7Qqwsb7cx13kE/VWTP5z2NWlkm1bnZEPF49XgjuAOw+66Guc3adTgOWN26nz6PpwrqBUgr6xM773cwz0qKvYMcEZ9TRYnulkopAdvyIGrChBSPgTbKw6VV65qjr3StOVHo6Y0BKZGsizOq78kIWCnBVyuytBrtghoFSl4v/IAazPshv/wgw2dX5bZ43IVqByoJ9Ek+j5AZaYCLE3yOGnOX/gDvSVAwr6FNsiZ3pwEnrgXi4Ui1p91Tsxe41oz3fVUi/Mkc2w/78BXsi8qw5KyPIUYo8IeP3RT4D/aDdxYYLnXjciZPSRvNvcUVZH8XW183DBOX9/DB7hsupySCRskB8qXWS0T/YCT1OXx990RwfmS3Lv7SdOJTifS1UTAalrlNUNYfm13G+GyB2fdZ/wZo/dT4i+8nkvRWqeTXqidM8U3RRPtmtzf6JdCYe1RjvhKD9TZXI4xKDMpNj1cWzTFf2EofEJwtgShHmRv2yLapOyqZCn5Df3hAqJpy4g01x/C4v/VadnFfk21Vc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d95aeceb-c781-4847-3a7a-08de1d654a80
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 18:50:01.2738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QB3UIdGYwfX3VBQg4xLgC/ukJNEDpG753AxHua52tE4/3wStO4GEIH0O/TaH2+K1pa51vRLVLpbUtQ8Fk1K/zBc/poSyF1JZSwAGYtz3XT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511060152
X-Authority-Analysis: v=2.4 cv=BdrVE7t2 c=1 sm=1 tr=0 ts=690cede1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=bv27XuDUiYcUaJ5gn-8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzMyBTYWx0ZWRfX8kQEnEdJY0Vs
 r0Xh6FA/hlhUF2C1C/YX522YRawcbZwlp54I+3Z4A1l+fS+IGWXDLfuJ6ytIUgHZLRMl66b0+a2
 uS3U0xOukLhO+6rOSCLGGr0gJcuyussR+ri7/HlWbg66I05fqQHTAtWFEX61x0bCM6RONg/961T
 6CxONhDmjOg1wesZCZDAsknWBmCssIhs6R/TAwxhfqbw6hVmIDDjK4z0PVssbSocckCqEFS9dw1
 94HsbhbTFJfnwtRXpFr3C2QMaMjp0Ziuzkf8u/L68y7o+yHLa4kyXv/yzszj6DZ9usoYk4vseb/
 SaFB1KZKsnGqFXBckzHPB/qwPzyPufMM3evsmzHBe7Vcx5JQZSqOgLT+KgmVD6tUl8oA3CQZdwR
 Kf5txK3Cpr3fbGFmzZb3eBfGhg71YclKbDerMM9+jdNBbw1yySI=
X-Proofpoint-ORIG-GUID: SdLHRtlKyVj1TEheES9vx3JgUIAiEwlP
X-Proofpoint-GUID: SdLHRtlKyVj1TEheES9vx3JgUIAiEwlP
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 016531C0010
X-Stat-Signature: dtitodeh3m3msj5jg9cn9ir65zh5osyy
X-Rspam-User: 
X-HE-Tag: 1762455032-478581
X-HE-Meta: U2FsdGVkX1+xzG8+jelTbNFX+1XDBf3TQ0PgYZLmr9dXprx3LnRHl9O7avY/8c7RzeyNxy/Wr+liwxtkd3kGCXizXtuapFxW4bpxX2lf4eoyUNpD8hNvVbkme2wE0Wmjk2Ubn9MWT9cCa7BDV9Uy3WpooLGadovtmUijj/SgKCmORyLSuCZ1ZVXPuozX9t3x9+h/cKNKIeoJMl0MHGgMt57EOUPSivEaWIV7NydVh24EXvLu7wxuvfjGUP0+GeFu+J+cE7+QA0k2b7Bkkz3UFsmTO2TqdiO03CDCX2EJEBVeLDXUQnbO71Oyj1TxFdDov5H/UJCmywKt16E+W2J2Qdrsw+/qDQnfVzKGiXmPrs7hmSB96fUf0z5jrOuxfjkbHrvuOHkbCiwRF2QoD1RWaq8IHSjzdqe+PdFzGFpw1N0cmWKZd9J3njjHOBsniRZQlRZKT/zUkhUNImQA2sBB3NsE4VYjMosK2NmqFvJVZrIKwyF4I3TIYsktG53jmzQEyAl8taAhJ9+uSCEZJUH5YNevoSb4HSy0bdqqTG+IemVQKCFM3XX+cus62k7anYmF3afKrrutIpIAlEtKFItSLfULl9+mggK4/LHXKF/wlwKy0Lc6fqDu8Hwl3a89xaxLmLUANAvYdDMMGYcD35gateyYkbVnLXDUgY4RRm4wlBux58FP+H9zGc1qd/BIod62V48n9HXeos2h+UzBJb+d7vax/69r57yIvmEdeqxsQ1gYjmvpDow0YLJWsXAe8LpbQg9dvVX2fIsZ/W6KYxfZqax0pEBvCVCUxIDyoy4uegQJdeTPnE7antoPnaTSHVJQ+ALMKmr1ccxBBKHNoR4q3gG1RPWCjwf2CJ7ulhqKQqk76WUBwYViCUrsUB9bfAqXv7Ez6+mQ20RY2g/FOkgp2xAqffERRfLHWdM5qYZTGYIyCGTRHd7RLkfcuYQdaWdz1cCHGMSzo/t2y8O3r3C
 8MXFxA8E
 a8YsvmaiKSQe5We3Usyo/3hAAUAHD4Q/71gqtPofsA8X0Mv4CPZGdDj/RANT4F/xOZqzwQ4Dmh5h6YE3XJ4cFy25MsAW+j56vACE858ykF5EzpygPJgvJetMFH3cn0ihLECOcqQCt54g37BOqpP7/Agno68C4atvHU3H9y0DNDuwo9vwWTiwJmKYq0CDGM8ALAeeBaXK+ubaHcPWYf6v4s2rsQskGd42YBG2mCLsxwL+ZsNygnIFrrnbc8f8ZrVDZ7Rl+5xHSpvK5yaUS5+PpKJ9ihoyiux0OgzuL2jWiWzzX0CnvtJY20tx7dZvgWv5DEZtnUjeRJviWME0RxaEF7sJTYIkR42FJNd6KKKacKUuZMIF8ns/D3FBctj/c2v2hX7sU/SUUP8w0+MyxEQw+giWfMsraTEA+C6yZsHgqEDDkXgkUjXoZspR0DSE+2RNODChL3NZ1fxhBL2uWgV37f5JI8yF4YxXbQLLghHWt97sNFpYSeQNk7WKVG8PK9utNXPPSUKke38BBXpZe/brk+tLr+m5sT1r9l8gjzoio0scZaEzD95P9lleIkKEYGclTwvHbegQwuY1KXJVvohi+1qgm1P1XBq1Ycg3D8OgC6oTIo9t8iUpJvjU5u1z4Sxcg3oqdYXr4MEY2LZOKmSng7FRN4iroQ0AY+iyFFN1FR2uDijI5g2wdnXCShuBvCfPuQD4ECDDs7TXDKbvfThUWwPEDsRwogK/CqgKWB73jM4aGTaPxPK+zryuxvM7/AE4QyWULRLLoAbQ4oCE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:13PM -0600, Nico Pache wrote:
> Add collapse_allowable_orders() to generalize THP order eligibility. The
> function determines which THP orders are permitted based on collapse
> context (khugepaged vs madv_collapse).
>
> This consolidates collapse configuration logic and provides a clean
> interface for future mTHP collapse support where the orders may be
> different.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

With nits below adddressed, LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 0dbbe04c31fe..89a105124790 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -489,7 +489,16 @@ static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
>  	max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
>
>  	return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> +}
> +
> +/* Check what orders are allowed based on the vma and collapse type */
> +static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
> +			vm_flags_t vm_flags, bool is_khugepaged)
> +{
> +	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> +	unsigned long orders = BIT(HPAGE_PMD_ORDER);

Nit, but can const-ify.

>
> +	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
>  }
>
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
> @@ -497,7 +506,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>  	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		if (collapse_allowable_orders(vma, vm_flags, true))

If we have a 'mystery meat' boolean parameter can we always use the convention of:

collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true)

Please? Same goes for other invocations obviously.


>  			__khugepaged_enter(vma->vm_mm);
>  	}
>  }
> @@ -2567,7 +2576,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>  			progress++;
>  			break;
>  		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!collapse_allowable_orders(vma, vma->vm_flags, true)) {
>  skip:
>  			progress++;
>  			continue;
> @@ -2873,7 +2882,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	BUG_ON(vma->vm_start > start);
>  	BUG_ON(vma->vm_end < end);
>
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> +	if (!collapse_allowable_orders(vma, vma->vm_flags, false))
>  		return -EINVAL;
>
>  	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
> --
> 2.51.0
>

