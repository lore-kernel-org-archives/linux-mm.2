Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47531CCFA1D
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B318E0002; Fri,  7 Nov 2025 11:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FBDB8E0018; Fri,  7 Nov 2025 11:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D838B8E0002; Fri,  7 Nov 2025 11:12:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA55B8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:12:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D26612CA3C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:12:41 +0000 (UTC)
X-FDA: 84084304122.03.6081A5A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 033AC40007
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:12:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oFMw9trE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T4SPItJs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762531958; a=rsa-sha256;
	cv=pass;
	b=S31PWzB/9fvfV4BjicgYYlfYLIMLzdgnVD8XrtjKhC9nKKWNIIuG+ZAkamRSLgWqFsP9Iu
	PPKNoM2jxMkbkZ4Th29GEfHMDpCiY5MpEMrOnN1S3qoimzzmHfJztoqMXJWBZw4uzOl7HZ
	Z57QjXYvorZRXBqXQmQlmnL+tLi0JL0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oFMw9trE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T4SPItJs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762531958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AF9rlYYtNKMy4e7Dv7d9amCykDnNz3rb7Huv8qwBbTQ=;
	b=RmfkRb12UdXfJoH7rKgacKexCVeQ4wauSZfsRSohdLzqSVJs715iwxh3WfSYDLvrWbroGG
	9LPKz1QBThRowN+0gqzbgnDwv0YWOZlv6K2fbnI6FpWxV2F7AjDSjeFKEfrrbd50Orzaya
	CafqFh12UipSBfmM4rcP8k5fuMqlQcc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7FbZVP005616;
	Fri, 7 Nov 2025 16:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AF9rlYYtNKMy4e7Dv7d9amCykDnNz3rb7Huv8qwBbTQ=; b=
	oFMw9trEeIN7h8GnxB/9WrRIloYPF5cVIWVKa+OvuVXmjp3/fqE1EgoYwdU4WC2Y
	IdIcvKjdDa5uEBbKQBgi4PKlpJiGZuQHVQ7vC95X2jvW9piGIP+jb/zc6xcCRLm/
	UlTbFasp69QclJZr1A1u0+KXofyj/+vUPwRZZeQ1iutnMi3vZyXWh1UEevxUGfnN
	wAshv6WturEygQryEZ+Nsr49KM73RpSv244QkS0AJpJ4VFcBpNGR+6qFz9LeRmIc
	tPYivXjpIM3XuiItjwoPD3jYvqh/qdyAXbJoWttz9fD6im5SuHRU39395M1Jd2Vm
	rz2GFelPWqGLk33qpSHeJA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9jqmr6ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:12:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7FKe5N035995;
	Fri, 7 Nov 2025 16:12:23 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nqt10a-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:12:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDIfguAQ9mDis3aqNkqxHRopPCvuPE7jQcGWfXH5CGApG6EjSbSj68wmpamZyYyMVALrtBfGUUefl/9rK5ZoHWWuQqBCvGqipi94mw0SHca4980HkinNvVrYGCGWT4iSNyJx5zh5mHg9zPTm36CxHGuIzhcojmB76vTNdkw6GCVmgcZ/5+d2fX+AmjtbR1hCpRjnq7/ZlXT+iTMsiAIByZ46xqM301KjYtdCaV0dRYQMUrjSxXKxsntCJ2EaZxiU/vUv2voowMQ6FtY8w+NUwzh7xDvPQhjfCFVq+7+/w3SZJWI6P86MTgNIm2E5nh/Z+GovcnhrXxmrsyyzcrVpFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AF9rlYYtNKMy4e7Dv7d9amCykDnNz3rb7Huv8qwBbTQ=;
 b=u2VyCOsrLN+DoawVFcvwBMUCv+Xy6TFixF+BKMf4h5rhqLwqUBlo6BYXNAsQnhifV6gSLexDZfr5qjGu0IfA422Wi2IUnMgRVuOciBJgyUPeTV6oxBDZtec3L4Ozra5Kfhal+0fGTEqvha9uIjc226+1uyhYGPxH9BUbQESobdpmvxKwqNAokfvb2xsKzPXrcC0Czrfbd13SQpdJCkOVOQYjkDCLjw6FFqnxaV5kKaEAWcQKXKw0uSgtDFn8XIGC3nxPzurZvLTjMPG9TWqIU7MNTuIdR4qgq2bjMwnzID7mr41Rqy2S/vZNtTwRGYm4YbY3xe2LOc64nToekDnsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AF9rlYYtNKMy4e7Dv7d9amCykDnNz3rb7Huv8qwBbTQ=;
 b=T4SPItJstu3Yq8IJvwEZmGn+VYFMA9f54uoUhT19/V+zehs1IKRNBQ6HCEj1GT03hzO9x7RCaTUKYppweII+rQkCvO8xG+d2dh4+OIBTs8B1aRSNOx+BlcMO9JBZIQBmbQvHitXvwi1ZsCrY2E1qBKm/6RUIUwDs4dxDtL2ZmtA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB6913.namprd10.prod.outlook.com (2603:10b6:208:433::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 16:12:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 16:12:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v3 8/8] tools/testing/selftests/mm: add smaps visibility guard region test
Date: Fri,  7 Nov 2025 16:11:53 +0000
Message-ID: <18153d558f422bd982e2e66e723b200f62ffc849.1762531708.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0639.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: 40025346-f163-40bd-bf7f-08de1e186b7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7IzKTgQFHFFBhzPUyJntLV9+6OfeilYOpg58ZK9J1VdURkByozs6hEa907xJ?=
 =?us-ascii?Q?w+lYrnAMf5NxN+Ljtmy0xG+s8JxXq4WAIia/d3O9qa3PyC9jXL7WSnbye8Bm?=
 =?us-ascii?Q?qpzoLf/ut5Np1j63XY/1kofmbyT5Uxe6Oy/qNstTAweaIjho7W1Cz1J2043e?=
 =?us-ascii?Q?ZjOTnEhAFH/qP9hXuIwTH8ZOmXeZnFrhBFPNmvuMzqqXOeuaezZieqjPKD7/?=
 =?us-ascii?Q?SBrytk4VSjUdHSEDQ4NzkPSb5r513z39f4HHBbO8RMZNBKfXDeus2prQ/oYE?=
 =?us-ascii?Q?fJh57r3RVgXGOiqotCHmEKRbWdsY/AgQFEroenPJJFTYCpUZNzdGbTs8t5Ks?=
 =?us-ascii?Q?xZEDBzDsd5fGGD77PM7jJhbSNAl97djOEwhzfdJBVzsfUnZOcPEcg73jgsV8?=
 =?us-ascii?Q?qjUpE5QsJsQCHqEivp1JVtj1LHFULbo/wQhsraulR+RMVWdIgd5junNghQ8Y?=
 =?us-ascii?Q?Q+HN+i9O+cb3p1zoMa+4eiA3x8Tdf3hy8szcQdjAPwBZ4lYlAV69T9wgaKRe?=
 =?us-ascii?Q?RoBDOcAf4df7IgBCscbIoVmDmFobjYgMz5mz0oFIjXJH9v4x3f0yQlcJLhAY?=
 =?us-ascii?Q?WA0A8LicefEYcw7UVxiIj5RdQcXKL3mJmIxem+e6mMytIr8zew6Iznv0aEYw?=
 =?us-ascii?Q?iScQpwed0Jnxq3jxnKD4Tl+h0grT5sYs6VfB6p0kwPZu8zPhIVkA0WKdPnTu?=
 =?us-ascii?Q?i86/n1D9/l0hG5WT9xmOrLxrzbLEB0uE6m3Y3hHmicmdg4bYtedi+p/6LU8x?=
 =?us-ascii?Q?LMopVKtB21KyhRe/0Wtagfa/5ijBxMc+S7gzfsE3yN8rr8mcaJD+gz3zCmsV?=
 =?us-ascii?Q?M974r9dGBZ3iKTYxG1MT//T9zdrsElni+OlW92XTeT4j5CPKUjRCN7f/5AMD?=
 =?us-ascii?Q?Yu+DJHGxzkFakZRuLUJjnzrQVefjlSXrarxUXEcf8gLdsSBVyqxDPYaL6c2I?=
 =?us-ascii?Q?K7mEncnrPnQbQA2SoG1nWvd17NoLlhffNrW0Xw7XVVbcD/TvEnfljigdgM6U?=
 =?us-ascii?Q?oPdEIFHUj9QgV76cdcm0pnZWiAqqNHkhHYvv+XlDxOlMAjjXMV6kR3qhn5tC?=
 =?us-ascii?Q?GUV36dmheUXsMxpP7XgILAdBx+MZ9Lz99svI+gE1gLrJr8Lr7MvKrQKgsI9y?=
 =?us-ascii?Q?OkCNFWjKCHyh44J9CkbMfO4/JoUodUgLu2yahosUI7gEI1lReJiMlgBcUuX1?=
 =?us-ascii?Q?3nw7UJu7szWC0CFDfGs8TqDBTbgeK5pA8mhoUsHE1DkUyGiJHXPa22+4xFk9?=
 =?us-ascii?Q?osPKCwAqX/3dRnF0LE8OE/pHZgkNmvkR02fhaIX1vV8/1zshpWWbjw5/azN9?=
 =?us-ascii?Q?KfIhDdC8RmPYak4ca34enfRd3DhNCS18Wkc3bbtHh7EZ9NHId0wRKbSi48FF?=
 =?us-ascii?Q?4dOEa2H0CG2uuq+bHzoJPB1L83JOcDA3wL3V2Vt/NL/WpscgZaGdaVFm2tlW?=
 =?us-ascii?Q?W8Rqoti7oauMzeHMDDyBO76KurUszed4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EJz1PuCzXnlhI1h5we5lvW386CtmlyMbvz7EIXlixnnKF9Etmrc0Bi4ld6Fb?=
 =?us-ascii?Q?hNGiN+wLkF5AJ4nPps9FL35sNWHg3+bXwY7fqdxoISwoaubm0MgMkbpwe4zF?=
 =?us-ascii?Q?FJOlqaKr72seWA4wRPwGmKAco+CpLZoJrEFIA45PtdgXKvNLPYn3uvc56zM5?=
 =?us-ascii?Q?1Nxr5WnWoPHJC8jYJHSCQ8grRZOD75OisS62N7nE11BXnQSXethBPYDnGfO/?=
 =?us-ascii?Q?eZHoMHGF64P+i+xBpnU8onwOb5+dvAcjAufC1FriCMthJm8kTOErSWK71U8V?=
 =?us-ascii?Q?47sPa5oYhf1XfwqMf+5bJ7YtzmqZOCSjOA12OYOESfKDzJeRuNi5XMy5HrbM?=
 =?us-ascii?Q?3RSIbV0VBhNraLHOSZPZai9m3FT2JaKjm1HUJpRdGNZHsRWYQK2YHtkOKC1c?=
 =?us-ascii?Q?vBDhIpEmNKdJ04KfNo6N+WnfiSt8GXL08aT2mKev9ey/ZExrx5K5glO8KCJw?=
 =?us-ascii?Q?yXwKxeTbi2iTV6/mVN584OhexOzKAhnlkDJ8j3e3Q4Oa9NUd3mWak8hTvQIp?=
 =?us-ascii?Q?/iyhgBIDnxusA0Eto51xUCHPmlRO+XjmbxqL5bRwQZsQ+GZJ0SvpksxkhKC5?=
 =?us-ascii?Q?bVrewO7Md9gXJrP6FHoHxlNM+j7LNpHWDT1sH3EaZtUP56xFTU9rTU6nb6LQ?=
 =?us-ascii?Q?ka3pHfZcf3ANOXLputrVAxHp8lN7+OwlbIl5PSTFteX+Loo8sJu38cNz78zb?=
 =?us-ascii?Q?rZTgGehpEO2EedLmzbEZ61sRKcuc3TiWRhJB/PjPjoDgtqOj8nKEXN5Y9vqB?=
 =?us-ascii?Q?X3dZ/eb+TScPLXWQ8rV2ZHbdP6TOu2kcYcuLbjL7i+h4pW4jWBbsgllc4U0x?=
 =?us-ascii?Q?hokkh/kuLBk0lHqrjMYEJtBwekehV+BGAy55bV2T5NcSEun9oPAzr8KpeRQm?=
 =?us-ascii?Q?2nK9pjKEP9mwdpbLrNtvaO1IsfAvxk6fhYISaqHPVjAZeCQ0ntSIMwcZ11+x?=
 =?us-ascii?Q?OOFbzeKHjvRMNpCDr+YuC/dRQM/aD1otaW5xg4C12ShXM3N4kZzebM6Kf5rm?=
 =?us-ascii?Q?D/ncGqZzcd2SkS6MsQWKthlrvgTDo3X+B8Nu3Q9DS3MjHQnD/Jr4LxDnBh0e?=
 =?us-ascii?Q?TkzCPpfrpXomEK+hV+RUUkImkHcziHnraoLuWvzDcewsEmu53o/iAP+LQ0IL?=
 =?us-ascii?Q?V5cF+YnzvQPW02vPxK91qKC9I9nP4YGgFqa6Y9yitJF1Y/w/oWus+PzjKTOw?=
 =?us-ascii?Q?RW1V3tTiunce5eGoUbhhBNxoFg1l3GGm8+/HTiQRBEA8IqogPysJepuPnzRa?=
 =?us-ascii?Q?4kboou0ORUIXnWVucxCSCp6NNQ22cvcBLds9w0HHbfjKaXz9X9JDjxsI2wEn?=
 =?us-ascii?Q?VY0YmJli1T/XbxsCSXmMJop/NTp0MMCcw2tVJ18PvGgo/u77CrDH/XEcxQaH?=
 =?us-ascii?Q?KjMQ9AWV5C24N64uMhDAUk4qZUAOp1nVMi35zbxyMykO+RjiLia8WO2uMB81?=
 =?us-ascii?Q?4n8BeVRqYcdxdehg2efIsaE6IfXg7Zok6z9xAOAUwheH0LMonJuyhtx44AWF?=
 =?us-ascii?Q?0nwDW1LeeSDO4aDlq+8NMxfGP5verHintCttGg6mEOj4hLMoAKe6AbJg+iIP?=
 =?us-ascii?Q?Ha2r1GRroNI1kRkMXVgX8SbJdNUTYjbe8IFN/yAeFfWh1WBegVB8E0o153RS?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zLmlYw1OhFyYCoaGgYRdY1B4XOgsJ12+MvKJ7uK3HNSX1XevSF0KeGHe8QTKB7XZprHnj34MKrkrgL2sx6+oI1MaKpOeJrs1HOjk1PkpdrR/6sc3f3aM8A7qG+KEpbwxewPsiVqw0ZVsyVHIpzYSYyO1hjHKN/V2HElNjzQd7lICSSA4NOlTm/nvsv9Xj/sOmabyfLrnLi1QT85KKKvdi3j6jdFwKUhlgdxLxk39L920PK2KqEwHGnV9nHfC+yNMnx6oWTsVK/Y1EECET2kXR9EZX9RyIROQ2+tjEkjZL5abLxnP4rdTWZGOeF+RCNqvhprx/4+wZGpWGolXcnVkXWytIOd3hB1IhhGh7m+s8dlQil9ozOjdesELkf2BcjgXQtY9Q5Ekdt59hva19p87mDKN64NmADZ6/4V5h2lXJZQyfZd6Cu7svmE6FvxYCjmb/riwgO4WrFhRTcXOTN2JR9nAzZLEi4WVD6rB7nXcN3BmJDyP1Ry/v0DfbpGjVAA+Xf+N5jeuqPpJIJSRa8Y/yxdIKaEaU4lvZwq2hdmjrTdyyVaTkMCX+BIs9LEBPNSbeJ8DKOQ6oVYshr9sTuaoeSBEbaheuXmZlo+yw91NZL0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40025346-f163-40bd-bf7f-08de1e186b7a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:12:16.5421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rvI52YBcIcRLIdvTM7XAkQJMv2D3dxHqogndaTUYK64USKXYw4TpfZiOfCzm5cYOpp3Av8mHCDc44vn0gc9cEIswC55Z+RMmmsCeybtQWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070133
X-Authority-Analysis: v=2.4 cv=TPlIilla c=1 sm=1 tr=0 ts=690e1a68 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=7oKVWYA_E11v4TV8rOgA:9 cc=ntf awl=host:12101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDEyMCBTYWx0ZWRfX4LJgDkG6UrG/
 O8VsSSXTNWPeM82idEp0WnkOXs9WYOqOV5J247GY4r0Wzhjv5kb1yOJI2qtSYlRvOFY2QP6q6a4
 vrkAYnhm4+SHNIxwFNVfWoBbrJ7hgwiFZRcW1WUzwl+ES+DGK+jKqxUO/qad5n4Srt7smp6FRFw
 +PZg1rQhQ2+gMt23/SD/smrcP+huc47jVlaZaytONKMrUZjxdWTi3b2pq+iXooUeXfRdmKsm6jS
 jXycBkDYiL799CzCuEbcmGgTOfHnA/eceN8SYLhAVJFvKdrT6ByjAgxIGa230hb6vsmw31vOHSL
 Wik/Oj+pRYuL4P8UGQ8usY1kZcXfAp/odmUlfKsduDKvXpFrQXmm8tRhJiL1uzs+56t0+ms2guu
 EQVGHDFL1WxGlPv/AcLRdxM30r+WvdLjcEXFBJu9r8kfb7sh8IQ=
X-Proofpoint-GUID: sU0yPnka6mGLE0ke7v29V_4yoTYEVGfe
X-Proofpoint-ORIG-GUID: sU0yPnka6mGLE0ke7v29V_4yoTYEVGfe
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 033AC40007
X-Stat-Signature: wx7dnqx378hits35bbccknc3dshkbn4g
X-Rspam-User: 
X-HE-Tag: 1762531957-668544
X-HE-Meta: U2FsdGVkX19T8EgJ54dWLh/cx5FahxZo3dW6MvcX/ektv7FY3cNBQ8WLdWZCqZh+WmLUwXOVmPfJPYh3chTUyoxvnx/sQvoop+2IErQeviwjfzBdPME8RzujR5w/Tu43ewpTRimyD5HSM3fybjG8LM/5ixzjmU+QhAkllVpkB3JyQDRSpk/P2lFVy3nqXmQ0LxKmusfgU1WLoMgRDXE38NcAf0BdcGGsvI7j6HF/3K92s7Rk0WqTWpvePvwVPmKTmHM4OkQckuMI0wcTvZz7ZeJUXO4uQ0YALujrpVeyZkLkO16ucxBJTom6hwPgKZ+1D8UprOy6GiplQf+CeXTNwyVNEUspZfLVjjb4hP/BPw/zznr7bXJhAzR32VKL/xZwL/FOnEBVrHeLu51gNJ3phYMNvSatmieXJcl66X6IiKDXcW9avqhTsHMRXBxduzR/yAyjS/ntsD4s9DisFJ1BTPZNaTXi2XiWL/5lo8IiVNmnSWfE6klP9cgTGdmHFnvstblojfbTZ5zIyDb9QA8gDR+Wp2fq/urLasdNksY+3M1eN619TyjMpWVtU931a9DEmBhRrFh2W3HCd7EnJZpWvQud7IedaNMn/ACKNRNuP14WBU3jep3UjqiIsaK80PyaVg8WXO5LwkqnRFAsXCfsTofQmmXfpFmbUxYkcuGePX9euvkgS2ASQ5gb6Z2Ff91NKDMdlbkqX7RWK8NXOBCf5A4EMkqkdonCpCEVxoJF/wKAGeyTqAXZlyecpVIJ88pJGcMq2QRH7qoIgnOXpzzTH4ECaLs/jHwp9VMqiw5uSLHFEk2xEPzqBBRqdJaIkfj8kn5RTxIGOvdm3FR477ZfLhaLiH42vJxJikm7jTKIUKHUEe0OrEchPIWTysrfhXtXRW+lcBAvLH1AFNz7Snc+0XnZgrWJwac2In7uLb9Azc1BUPtHuHjYqEFXj6o/mngstCWsCkhWR/JD+0lbu1e
 H6wB2AIV
 MxGD7Xkw8MGXZM4S8ntZsPOSPNo1D4u8Jtw6KP8dNet1AzJq4AtXuuXZFiXXs2euWDvy49aXRuMRFRCccZn7bKP1F8pWw1/HGreFaRqNOiJ2w6D/5IAkfVbMU5dMomenNuLoWAl80nF1LQpVtvWsdeyxuexYpLa78vNkD5Q23NCRGGInM9SDYd4MU/wBVfDxyJ834ty1E05Uj14cX8r4NkAJFu0kfdS5wBGtUMdM84QYM5rC6f3jdu1ElHt3jmpRqfpsXGoxnWfkbSSnILJMUi0U3PPsM7bkN0JbrN9hESDiDDqNie8oQv9b+dV2DozcT3tHYv5n0QTT+cHhyoe52ixXMjWHFVhHAPwRVo+GBRA+ZqvyN2wwqjCX6b+0lby1EEqeCXo1RXrVymX69jHXI0ahwUmMH6hJjID2rbhxuCM2Nha2aj8SPMLeL27QtHTdzZZgN5pdT2vaxeK8IW6DQYsl4qG1RTMcbtq1vCl+FFK+fCgP+41Zv2rRho/Yajkymzw4U/4e4ewbkNfGkFr0OVqibkqrueWJPrTntvpyRsriUdGBogzuwvekTL9GLw9G3zs+AP7v7LtCJWsvDTbDZFQYIvt2cH3T1eDJPc3msFmcEe98f42GfUtzcvMH5lIHzwDgRiqunl0U/ZAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assert that we observe guard regions appearing in /proc/$pid/smaps as
expected, and when split/merge is performed too (with expected sticky
behaviour).

Also add handling for file systems which don't sanely handle mmap() VMA
merging so we don't incorrectly encounter a test failure in this situation.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/selftests/mm/guard-regions.c | 120 +++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c       |   5 +
 tools/testing/selftests/mm/vm_util.h       |   1 +
 3 files changed, 126 insertions(+)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index c549bcd6160b..795bf3f39f44 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -94,6 +94,7 @@ static void *mmap_(FIXTURE_DATA(guard_regions) * self,
 	case ANON_BACKED:
 		flags |= MAP_PRIVATE | MAP_ANON;
 		fd = -1;
+		offset = 0;
 		break;
 	case SHMEM_BACKED:
 	case LOCAL_FILE_BACKED:
@@ -260,6 +261,54 @@ static bool is_buf_eq(char *buf, size_t size, char chr)
 	return true;
 }
 
+/*
+ * Some file systems have issues with merging due to changing merge-sensitive
+ * parameters in the .mmap callback, and prior to .mmap_prepare being
+ * implemented everywhere this will now result in an unexpected failure to
+ * merge (e.g. - overlayfs).
+ *
+ * Perform a simple test to see if the local file system suffers from this, if
+ * it does then we can skip test logic that assumes local file system merging is
+ * sane.
+ */
+static bool local_fs_has_sane_mmap(FIXTURE_DATA(guard_regions) * self,
+				   const FIXTURE_VARIANT(guard_regions) * variant)
+{
+	const unsigned long page_size = self->page_size;
+	char *ptr, *ptr2;
+	struct procmap_fd procmap;
+
+	if (variant->backing != LOCAL_FILE_BACKED)
+		return true;
+
+	/* Map 10 pages. */
+	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
+	if (ptr == MAP_FAILED)
+		return false;
+	/* Unmap the middle. */
+	munmap(&ptr[5 * page_size], page_size);
+
+	/* Map again. */
+	ptr2 = mmap_(self, variant, &ptr[5 * page_size], page_size, PROT_READ | PROT_WRITE,
+		     MAP_FIXED, 5 * page_size);
+
+	if (ptr2 == MAP_FAILED)
+		return false;
+
+	/* Now make sure they all merged. */
+	if (open_self_procmap(&procmap) != 0)
+		return false;
+	if (!find_vma_procmap(&procmap, ptr))
+		return false;
+	if (procmap.query.vma_start != (unsigned long)ptr)
+		return false;
+	if (procmap.query.vma_end != (unsigned long)ptr + 10 * page_size)
+		return false;
+	close_procmap(&procmap);
+
+	return true;
+}
+
 FIXTURE_SETUP(guard_regions)
 {
 	self->page_size = (unsigned long)sysconf(_SC_PAGESIZE);
@@ -2203,4 +2252,75 @@ TEST_F(guard_regions, collapse)
 	}
 }
 
+TEST_F(guard_regions, smaps)
+{
+	const unsigned long page_size = self->page_size;
+	struct procmap_fd procmap;
+	char *ptr, *ptr2;
+	int i;
+
+	/* Map a region. */
+	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/* We shouldn't yet see a guard flag. */
+	ASSERT_FALSE(check_vmflag_guard(ptr));
+
+	/* Install a single guard region. */
+	ASSERT_EQ(madvise(ptr, page_size, MADV_GUARD_INSTALL), 0);
+
+	/* Now we should see a guard flag. */
+	ASSERT_TRUE(check_vmflag_guard(ptr));
+
+	/*
+	 * Removing the guard region should not change things because we simply
+	 * cannot accurately track whether a given VMA has had all of its guard
+	 * regions removed.
+	 */
+	ASSERT_EQ(madvise(ptr, page_size, MADV_GUARD_REMOVE), 0);
+	ASSERT_TRUE(check_vmflag_guard(ptr));
+
+	/* Install guard regions throughout. */
+	for (i = 0; i < 10; i++) {
+		ASSERT_EQ(madvise(&ptr[i * page_size], page_size, MADV_GUARD_INSTALL), 0);
+		/* We should always see the guard region flag. */
+		ASSERT_TRUE(check_vmflag_guard(ptr));
+	}
+
+	/* Split into two VMAs. */
+	ASSERT_EQ(munmap(&ptr[4 * page_size], page_size), 0);
+
+	/* Both VMAs should have the guard flag set. */
+	ASSERT_TRUE(check_vmflag_guard(ptr));
+	ASSERT_TRUE(check_vmflag_guard(&ptr[5 * page_size]));
+
+	/*
+	 * If the local file system is unable to merge VMAs due to having
+	 * unusual characteristics, there is no point in asserting merge
+	 * behaviour.
+	 */
+	if (!local_fs_has_sane_mmap(self, variant)) {
+		TH_LOG("local filesystem does not support sane merging skipping merge test");
+		return;
+	}
+
+	/* Map a fresh VMA between the two split VMAs. */
+	ptr2 = mmap_(self, variant, &ptr[4 * page_size], page_size,
+		     PROT_READ | PROT_WRITE, MAP_FIXED, 4 * page_size);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/*
+	 * Check the procmap to ensure that this VMA merged with the adjacent
+	 * two. The guard region flag is 'sticky' so should not preclude
+	 * merging.
+	 */
+	ASSERT_EQ(open_self_procmap(&procmap), 0);
+	ASSERT_TRUE(find_vma_procmap(&procmap, ptr));
+	ASSERT_EQ(procmap.query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap.query.vma_end, (unsigned long)ptr + 10 * page_size);
+	ASSERT_EQ(close_procmap(&procmap), 0);
+	/* And, of course, this VMA should have the guard flag set. */
+	ASSERT_TRUE(check_vmflag_guard(ptr));
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index e33cda301dad..605cb58ea5c3 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -449,6 +449,11 @@ bool check_vmflag_pfnmap(void *addr)
 	return check_vmflag(addr, "pf");
 }
 
+bool check_vmflag_guard(void *addr)
+{
+	return check_vmflag(addr, "gu");
+}
+
 bool softdirty_supported(void)
 {
 	char *addr;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 26c30fdc0241..a8abdf414d46 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -98,6 +98,7 @@ int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 unsigned long get_free_hugepages(void);
 bool check_vmflag_io(void *addr);
 bool check_vmflag_pfnmap(void *addr);
+bool check_vmflag_guard(void *addr);
 int open_procmap(pid_t pid, struct procmap_fd *procmap_out);
 int query_procmap(struct procmap_fd *procmap);
 bool find_vma_procmap(struct procmap_fd *procmap, void *address);
-- 
2.51.0


