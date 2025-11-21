Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFA5CFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFEB6B008A; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8259C6B0095; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DBB76B0093; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 451186B0032
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 556BFBADE0
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:30 +0000 (UTC)
X-FDA: 84135741900.25.70CFC99
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id D890640012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gDTlJTov;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l4oXF5zl;
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763756667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jv4Cxyq3eTFGZWfBo0+KjGguxVW6A7p8xDPAEhlcVU=;
	b=wm/SvpcCmUEXS8r9CnWU8T7rwcz87s8zBRoMKpQkAxzuCsRSAglJbvbVxF5fA4NVsAjifG
	KurL7LqTnoK3gJIb6m3uim49sQwhLbZ3GQV8VwjXwo0O6ISZjBzXxoxxc21sm98qIGIYhl
	VU0sXvTvkm8VeiPNGeJ+OGn1mmQg8h0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763756667; a=rsa-sha256;
	cv=pass;
	b=Z1FGQLSFzdoeoQFbPFO3Gkozk0jOB9kLLHjYB5UITicVAHVMilnt3EAQCr7A536a4iCAfm
	r4g82NYIkmCe4Z4+yHc3xCttsbLFK5x2IUl7xBgFHIo6d91DMqT6mAqBqldrPXFXYSTxuw
	6fqGWoTfx4Ut8+FaKb/zg2ljx1wfjR0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gDTlJTov;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l4oXF5zl;
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEgurN014587;
	Fri, 21 Nov 2025 20:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0jv4Cxyq3eTFGZWfBo0+KjGguxVW6A7p8xDPAEhlcVU=; b=
	gDTlJTovh2dGPcBjf0vt2IcgydwDnxlwMUmTWkPa9byj9Q9WlnpjeVEt6gMbGumT
	YP4N3J4XhcHM7KaLgER4+U3z2v/hR8SsKus0H4OkWgYXaOC52FwNaaWG7uKcc6Hw
	lmBp0GmTatCdbvSSecC6mFmLl9YRi6wYiqsKbb3efcqNM4U8IIpFRp8U0CtrUEnL
	zztl0LBABRIBIA9If4/iDXpN4YnY+cFSVS5mxOWtqyaAni21MqD3CzjoxKMFi47q
	wjyYopCpiRM2KhGL3sG529BXh1W4pNBfeFBAI8gS1V586hMl0hmnwwSvTfV+f4px
	+SYk599COKcj2pomCvHhDA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbuv6gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALIW30n002499;
	Fri, 21 Nov 2025 20:24:12 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011034.outbound.protection.outlook.com [52.101.62.34])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefye2tk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/nCf6LRqjNrdQ+u/bgMZ2jNujhPlLSZS6C/aOe98O59VVTBfO7AOZVr6WVjEFHWXBAyQ9v238rKfI3uK/beZWlrTsNVNm8ayODP+QScKtJIyfjeZCAcHIEvm2HGezMALvXTWaSQ6XkweM2jowc/RW7EcYAatBfhzlr9QCrM4xn+F8fFan7RPTVfsQL0BMoQdEUMC6Q6sC23H7EPnnJ15pVwaMZ+Cvx8GXaOxOUfwPWSqg6nErRy4j09tB3sYv2K//TwE1+BhYVUUu/xkQUu/b9yQmuZ19xBhHjhVQbozP+l0CaBpimXzt/6/m3QXzeA+eEtQRV7kpVQQhgJHPf6Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jv4Cxyq3eTFGZWfBo0+KjGguxVW6A7p8xDPAEhlcVU=;
 b=iolo7DzqAboFMa1PwykBHM4gjQny0sNmi3DdbfRW08M7AD3WXeN338kGAWXd15oxPGPxAi0bc92KXyFSVyQokOtOzWbRiivTXgcAII2y219VPM/arGFc1ZJh02x5UG0ose1MagL18y+zoxi7icJdGxko5pmZGLUX/V4ppmciv1mEAcN6k0YiTPxjLrWCXsOAPj3aPxonfrAZV1T1N26rRgq/LefbN9gH7UVPHmfdjcFMoslwz/GF7izkwbvSFg1YN7FkFrfWSM5xhTh/U0rAaAPmEGzm++h/QjrsqnXuambom/HHNisvqmgvflK8z+YHR++W4hoC/ZnssmPwQ42YTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jv4Cxyq3eTFGZWfBo0+KjGguxVW6A7p8xDPAEhlcVU=;
 b=l4oXF5zlI2r4a43ufiWkIHvbkMl42zZQh7dJpnMFFcUsGZbgT6353Ve2ZVtxBztvazGDkVd1uj3Mro2YML+dVfCfdANPeAgXLOLWIgSkA7oJ8IuWJ50jeHUspmN/2DqV7WZorU+FpCzIwThOoOqkP9KlwFkmkKQsVN/AoDm/E/o=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6470.namprd10.prod.outlook.com (2603:10b6:806:29f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 20:24:09 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Fri, 21 Nov 2025
 20:24:08 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v9 6/7] mm, folio_zero_user: support clearing page ranges
Date: Fri, 21 Nov 2025 12:23:51 -0800
Message-Id: <20251121202352.494700-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251121202352.494700-1-ankur.a.arora@oracle.com>
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0058.namprd04.prod.outlook.com
 (2603:10b6:303:6a::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 16f27778-02c9-458f-1b6b-08de293becd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HT4kNQunqeybh8vRJ59fgELfPN/yfcXCo5cYyl5Vmg1rxEXufDIQzj3NdA8/?=
 =?us-ascii?Q?gGyTGcO7fqVpB4JmY3vXJq1Qvh67+HU2K15leQ9A7U5lvEQPlxs7x1pQgGge?=
 =?us-ascii?Q?v1HRyxyDgLS4pI+6u+EC8ZvYLinDlt61tBcOJB/pffHEYwaKN4uwAHRoZQPj?=
 =?us-ascii?Q?jnc+6JmmCJK/RN9U0c3V9odnpyJY+iPGYsQAjHLHnSGwEt6eHrTrpBUR+0Du?=
 =?us-ascii?Q?M+LJYJMyn1inqry3AS+dZ/f43Fr4NgsSM8hCjwRAFcpMX1R1L/mJEkqRZnfP?=
 =?us-ascii?Q?IDqAX5Wm/5QBvw8Ytv59b8gNsxvZdrrWhBiPZsDz2DS/j4HbrIEtKX3rGCfK?=
 =?us-ascii?Q?INumyswUPKCws58PXWW8KHH3/KvN9JaRNPZBNNNj7/24XjcPOnGaNjqjFbwS?=
 =?us-ascii?Q?Lk0i6mHyMLUAYMJFZMuwy+87i171yg39tnTBp5kqLw+kWYSRNtkhiJTYxX6f?=
 =?us-ascii?Q?slhd8UD7lY4nLclXfPHH215rIRrK+71PDrNUM2U1oqBIRCgcirRPPuIlGQIW?=
 =?us-ascii?Q?4QSFvwPMGShpg/Xgzrk2xfujaPmMml6EauspZ3y+4cOBgg4S4Vc5X59lIjrT?=
 =?us-ascii?Q?pOGAK383o+YrwurP2q3mS4VzmCDbky+Psx1ytVzNAHVXAr4Ssf+uFLqS6i5Z?=
 =?us-ascii?Q?nnlFPCTPtQxFoewM3zy+ytr8dI9f06XBzzFNixAOHeDGTIgzFC7VVhotR8Nl?=
 =?us-ascii?Q?pVwHSQo1LzHda5dW/ka/NxyLOXIevomwzybJJSg1NJBFnNSdFgymPsrw3HbA?=
 =?us-ascii?Q?ljzYdUE8SdjrZZH86qAmIft3xEwEyyzF1Hw03Zxw6DEiZiryM4B2lsSxhBi4?=
 =?us-ascii?Q?L/BA9/HxSMFVyHqDqyhUAlagJzcayi+xH7rfi2yZwOChwIfvlGTZs0izqHIL?=
 =?us-ascii?Q?mLhMYuBxMsbHffrHrOP8iXyhVFx1GmLx5GkfQwAADboVikXoqgTGkZJtz6s5?=
 =?us-ascii?Q?lwBGhPKVdXlpP6uq/gs0010bSMCOhDGPLUQbkK0yV5MaNFavkyl7gpBmWq2b?=
 =?us-ascii?Q?DzthJnP49y4928inwB0dwCqBNMTFCAjadn7aXPdGzu09011zU97IyCTsa9/L?=
 =?us-ascii?Q?T75YQ65y21ErjDr0JINLQTbXxYjGVrsd+x7Fns8QiXzZ0z/dKQzBcL6O2ygh?=
 =?us-ascii?Q?35WyiIG0dBqpzoEGHda7BCVRcFVecEWb0j971C/WdZouzf2FfCjLBxKRcyFc?=
 =?us-ascii?Q?MMUBo49L/0K7iHM0UB3Z5J/1KLYsBkizb8Z0WoeOQUzQIK3m5SVCW+0BHsVM?=
 =?us-ascii?Q?DfSp1IaT+L25Arbw4pVe78s5xFFYSLSe5mDk9J2VzdxQLI338NY7xH938QnM?=
 =?us-ascii?Q?RvS+ioy5fDFCChfTz1TBR6/wYt8+UDwTbEj3+PYJ6317ZWn6vZlgbt1QE33g?=
 =?us-ascii?Q?DPqgpNVVS6WpghUfC9YUbq4c3fhgy6TN6IbACh1qdwrZqClnDhaGamFhqTLr?=
 =?us-ascii?Q?sDZmk0yZK/1y1CT5JRr2yZOqBbuLzPxe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hoJ0WIhU9mqHOepdz3hUrBHSZvXwIxZ85JkHDU//Xz/aGgYz9Ozlr1f5lszc?=
 =?us-ascii?Q?pzWys4UN0pJGlHyfNvA558WIbVStdEZ2bODJt8AHaI1a1oRrPEVX9nb3uJwZ?=
 =?us-ascii?Q?4GgFDxuWnM8QY4O13zcZAIiUPfl/AFlV+RNz97xqrzFenxVKJgNcU6H+tteo?=
 =?us-ascii?Q?ILDU/xUwfFmp8N7LPfuq1ctsLh8du7wi4UlpqRSinUs2zd4ytbwfcAznI0do?=
 =?us-ascii?Q?5S6ixaXjfXFngezV3laHflD0T3jvBiVo5jMJv5hdUuXoQD0p8X0WaaVV5l4g?=
 =?us-ascii?Q?P4cqD5JzB3byJ0jyPbiBKuhr4SvqLSKOfg8B42gZNP6h2c5R8fcb+pePhqxf?=
 =?us-ascii?Q?V/U1b7r/Wk38oKsFlu+rnWq3JXZLueosWeowyfePftZG3IRnNZCWVvcjd4Tk?=
 =?us-ascii?Q?dMIFKw22qJxqdPbcmTULskcT0oRkviy8lAqVji3a0zrOOYFXdkB4BYEmcb5S?=
 =?us-ascii?Q?S1zAr3YsZa+E4+128pu/ptmgXommyf6dl1RjJnewyyWPekmOkk5H9JvcXS9i?=
 =?us-ascii?Q?ZpCNt1m4tqtBSDBfoDpM2DBbIyah/CzFKVaaQeVDlxNj3r87wRNhIoEgHDLa?=
 =?us-ascii?Q?WeLzh5OxptrBV7zDkm6HaZ053iz9gbpEcmLPFF59njbt2asHqIUJpWmauZru?=
 =?us-ascii?Q?ytHPflvhFrQkpAwcOBp/UiwKRiqJPj0vMw2GEGRwrTeTKaBp7qVpnGuSBEKp?=
 =?us-ascii?Q?ABJvayQXnIAxr5S5/zp1iIfEs/VdxBWsKESjbG/os7llhghDdUbjE8ouCXqd?=
 =?us-ascii?Q?TsXmPubRabQC+9GUxdXdIb98B/dB+LcIaMl34QKvMwq0R9nsz4R+raZ2Dhfq?=
 =?us-ascii?Q?+y3zqUiM4OetNHlcNKYRXRoQfofc3T4Sj6yMgGN9XXpc+bhhruBYoiP+zHDp?=
 =?us-ascii?Q?jDBnyKbPcnOXlmvQTWKolunJ0N9NtV60YES0xw2bMzZ3D49Q722aXEmFS2Rg?=
 =?us-ascii?Q?hWaRH34hk7pUk0sFW7u6zKXBGtToS8JEtVeGmZXNZRviun/xtancKnqMnIo/?=
 =?us-ascii?Q?VbcvprvGXerMStzkz/uB/IpWIhfsnwhwWixSJBlmuDBgi3V0BMYTsDDbDkPc?=
 =?us-ascii?Q?ET0YatoiGiWB9yIGIZ7xRJg/pHAywrV5j7PXpvVkvgbAGhZksXsstL8ugPA1?=
 =?us-ascii?Q?oJSkq310ofrYlMwwBlBnLgBKibK4h5LoIJ7m6KDZUvHnU+SLjdfIrVM/PoeS?=
 =?us-ascii?Q?5/9FmLSy24DyfhacFaYdRwbDDIp/3/68AbQG09D+kEeEVKMdIummO6sNTFO2?=
 =?us-ascii?Q?FAwyXhllrZ3F0H+iOMp2CfAdk45Lx6igtq4bfr3lt+JnWI5kTuNWKnjgSbXL?=
 =?us-ascii?Q?qGAdg+N9qw11ZpoJSlkSBIJnG/n0mIlzZ6AmN0E+YzYrWityPZbWTcvdKH0J?=
 =?us-ascii?Q?pZ2nXhhZBKvp9PhoIJD/gUfM26SiFomdVeb75WQOkIfQydmSFK8BS9BJQd4/?=
 =?us-ascii?Q?AkDc9FRG/Qj2ODXVLXFsoKyNf9KRDVPMnNB+Runz4NmyWqVMPehviUkH3wa6?=
 =?us-ascii?Q?a45VxqEEPoCLfbxinEzZ+rPnesep3Vq1SZytQfFqL50+4W+vUaSiUaT7GCfV?=
 =?us-ascii?Q?BlonRCVh1T+laTP2dG4JWpA22tmedsPkm1fK7dXwfZxQ79TTj5rxj6DUQfim?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cUi5GT6CBBG3Vhepewe4xVSCqOABfRBmEjVvzeLkEkdiHPfjikvPjU5wV/noxGTTy1HFeFIQbdln4fhiExGCarWcHp/1kRTzc7KuSpZIOwAZ43AaPa0EaucpkVMTyOZjxLKMS3oVV+32PIEwyT6I1fTR6DGqJBD7BkKPYWWrAWeqhrxBu4d5iZPMZGFn7UALUmdiCEsmwO0XuMtiTo+IWjmA6am5LC3pcQiuxGg/AmO4ZjxQ81WFB2VkmItD5TOYgW0LgeWY30wdbGbeMfmyuLPQLNMChr98LXKqcgj7IOgkb3Zc9RHDHfhoBfzujiunGBRcjDQNSTIypaGOevDIG2eJC440rqVfaFZx5LFIa+SfVNlIQsoupVK+C84pxSWUpnPsY38CnFLAizPdPuXyyCFT5yiuGdvJj7NEFLRhMAvNBUpYcGwCVVWkaTQzITzc1+K6RTQ+eLQX3iG+xxijTxr1Xkxrm6eLNdf+4eN4fG7hENC4OgxQl2/t9xYur/Qck587SRXRpbjgY+ViXJ4R2agHGKFdytBQzItQkejanElh9hfonzth9TSJ0FyvZWYSGulQdy8KL3gLArarCnvuHM6vIGKHNHv/7SC6xV6WHc8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f27778-02c9-458f-1b6b-08de293becd9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 20:24:08.8074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDADFWN4U1qtySV3VM/LoAFgxHlZc5vWQzBACapZnCr3jecb+ALyZJEdtpCiX6y8ncM9ZFqaa1+DXAtsnSdPk7CWjYK1uXbtTs+q6YuN9fI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_06,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511210155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX17I1ff8jPppY
 HTzo07luRj4JawyjaOD1qIqogPiQKtQuvBpOYLoKDTOwx277dytg+FD+eQqzTAjoKJ6QWQCw3Nd
 pPONIJ07LOuACsh5Ydhgea7T3WzKBykZB7Kn42wMCsB0oDIARUxox+yE98DoP/eU31SjYOdj8sg
 CI4cbajJ+qRqoojD3ZBWi3OOZdtygjt0GBg7jzBdQMGe7tqJUVFdE+kp2MEhNE/YEiGydGuMWNe
 StAA9paVTc4AGsQVyo8Stus+225RQmMmkPfR1pbPAAXof1iG1SgL3rOUrie+BocfitfG+oRTkWz
 6+NmUKHlty0Ydcl1yl+qwGi4aIuVgpqSuvIp9D3JIO1UATqrYzcnN5VY9cGJgm3/ySlXyevZWWG
 qEdmh7pTg+Av5oH5FXsXyQ4E+TgsFw==
X-Proofpoint-GUID: 76JV7B0pcwhJbhHP6JKGa__a4tYlTI9B
X-Proofpoint-ORIG-GUID: 76JV7B0pcwhJbhHP6JKGa__a4tYlTI9B
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=6920ca6d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=yF6BjjoBLw8LOi3scPwA:9
X-Stat-Signature: cq5gk5e651m1e33zhyyc5rf6agfxoxgp
X-Rspam-User: 
X-Rspamd-Queue-Id: D890640012
X-Rspamd-Server: rspam01
X-HE-Tag: 1763756666-520443
X-HE-Meta: U2FsdGVkX1/1vgME74Jk23yv5RqiyPI3hKFoiaKCsXauf/a1Ljdu5Q0PBwidyVYElK+f7LW/+aHs1qDd6YztEAj6Z6r6yv/72Fb77O516vY6hQ7w1/e/Amd0WjGYUqn+4E2pcifSGNaTAG+/YBP5Jc65JLhkza/zkgU9mvzDfb0goEhb1Wb3mEo0pslylfINulkMhJ3xUzioJMqRBrNdOj8GEuKCDCRcZiii1f9xoAIzvA5bG+auDi6M5m+81Gsi+QLTlsTo2QwcBK33aAhprzlfDcgh9c/ONPht7f+QEUtZyYyipDQFgChpIxtmBW6sKdNIgMCSzlUhay8ALpXbhtGPkzfjhvHZ6r6p/5cvp2H+QepFd27PE+jQmvRRhmbWrz4O1SqqHnbAP8X1pKhiCdqS6Q5hwSzg8e+nWpBzpGayZ9P5Iabes1jC/N4AOydkFV6YfcHyS0eJwn//D7eFhTdd4WzxYA81lU4vU9Dsdtl4gGpqd3EH48BEcvoa4m084zUnORFuxgDTFlDxzxOP5baAAVMngF4ZmbK2/K2Z+RED9WLK10afH9AC1ivELJlFAXpqJG2IREmic8E+nT01muVsXU7oSnMzmnI0y0rQiJiNeb4X4ZzcKCauMTxLzGkyVwSyPJnU008VXod3DqVaixE99SO/OWb2QE6K5WtS3pNYyYxNEkoqaYpsabO52mSHi6s7fklk736b2VCHedSjDOZXrDbm4QiRvWGXKTs2RsYv/eSBqE3GWreMLy0vuUEm+MRxMV4hr/hXjoArWMVr/E8+GRnjB+8+2/VC7+DPfxZfuM+RdvOE1rXJ9thmIssSbRRwrL3UGzDBCjAZakGSbCcX4GzaDV92VoweHz+Bdbz2lyxQf0ohSUabwVXsNRdxFXraOepRN+4emm/S8O7bS56JCgiw64gAEVsjnPF28gRWv5FxaBhhlURyhpqSNtuMRut02zvC35U/gHyK8rF
 IIx1Cjt6
 eK/jFpQlNKAmzSGcG0RuGYZMITQVbvrXIUh4k8zNb3UkD8Mfm5xudrdgp6QFSJMNeW1svfRbZCPdS3/S2LWl2cWmiyU1gPq8Ba5aPsh5vuQlJFbpugB7tSC4kN4W1M8JFr429Sw02otI0r/y9uTKBHc45SB7bHHF1SPD6+PWeHGOGDO/4ISCrcRfMs/W7DD4LYz2hI9OchytoHyTOU0UDtL+aAl8uwTjMJ/9JpEKLyuMVRwInrYx6j1RYo6+25kjjSRMIO3Hszcw1vw9KMpRqsprUF1OL95dh+V88976iTF4fYky5E3Y2gM4qIjycMw6QkdyBs31p/HHRrWzJ1Sx+gsGc6yvsizqZQUTYZ3ePNbTWDRm58pwlDl4T6JxBJRxJ9Mmxk9aC9R6BcQxtyxWz/+M2Xr5dMavP4VdBImtKxJZ+Qw1GNHSo93HlyZ9KoVx9MxtgeMjFwvD9MDjKj8oafb2ImEgaOeXPNvMDmlcl3GX4WU+zneCo0NhH+/alkK0Tu4HldR7oqcxrSD/GDpqg0dYtbHFK9a/h0ajQia6kdAbDTMUeCvc3hqs/YuV6fQtrC8B4DBwvHVykhQve/KC8dgyHzD38sAc36Z1hQtOr1ODcpSnYgoq9cw3tXJg3VNTpcYn+eK3a/chSwPiJaL3gY4ENqi1Iy8WNzJXdEz9xhrpWrOsfJ8BwAuXGZ2wVBgHiaFyBrpvc1Co1tlRMdWYfWTe0ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clear contiguous page ranges in folio_zero_user() instead of clearing
a single page at a time. Exposing larger ranges enables extent based
processor optimizations.

However, because the underlying clearing primitives do not, or might
not be able to check to call cond_resched() to check if preemption
is required, limit the worst case preemption latency by doing the
clearing in no more than PROCESS_PAGES_NON_PREEMPT_BATCH units.

For architectures that define clear_pages(), we assume that the
clearing is fast and define PROCESS_PAGES_NON_PREEMPT_BATCH as 8MB
worth of pages. This should be large enough to allow the processor
to optimize the operation and yet small enough that we see reasonable
preemption latency for when this optimization is not possible
(ex. slow microarchitectures, memory bandwidth saturation.)

Architectures that don't define clear_pages() will continue to use
the base value (single page). And, preemptible models don't need
invocations of cond_resched() so don't care about the batch size.

The resultant performance depends on the kinds of optimizations
available to the CPU for the region size being cleared. Two classes
of optimizations:

  - clearing iteration costs are amortized over a range larger
    than a single page.
  - cacheline allocation elision (seen on AMD Zen models).

Testing a demand fault workload shows an improved baseline from the
first optimization and a larger improvement when the region being
cleared is large enough for the second optimization.

AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):

  $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                    page-at-a-time     contiguous clearing      change

                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*

   pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%	preempt=none|voluntary
   pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy

 [#] Notice that we perform much better with preempt=full|lazy. As
  mentioned above, preemptible models not needing explicit invocations
  of cond_resched() allows us to clear the full extent (1GB) in a
  single unit.
  In comparison the maximum extent used for preempt=none|voluntary is
  PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).

  The larger extent allows the processor to elide cacheline
  allocation (on Milan the threshold is LLC-size=32MB.) 

Also as mentioned earlier, the baseline improvement is not specific to
AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
improvement as the Milan pg-sz=2MB workload above (~30%).

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---

Notes:
   - Define PROCESS_PAGES_NON_PREEMPT_BATCH in common code (instead of
     inheriting ARCH_PAGE_CONTIG_NR.)
     - Also document this in much greater detail as clearing pages
       needing a a constant dependent on the preemption model is facially
       quite odd.
   - Minor loop reorganization in clear_contig_highpages().

 include/linux/mm.h | 35 +++++++++++++++++++++++++++++++++++
 mm/memory.c        | 46 +++++++++++++++++++++++++---------------------
 2 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c397ee2f6dd5..ac20d2022cdf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3889,6 +3889,15 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
  * mapped to user space.
  *
  * Does absolutely no exception handling.
+ *
+ * Note that even though the clearing operation is preemptible, clear_pages()
+ * does not (and on architectures where it reduces to a few long-running
+ * but preemptible instructions, might not be able to) call cond_resched()
+ * to check if rescheduling is required.
+ *
+ * Running under preemptible models this is not a problem. Under cooperatively
+ * scheduled preemption models, however, the caller is expected to limit
+ * @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
  */
 static inline void clear_pages(void *addr, unsigned int npages)
 {
@@ -3899,6 +3908,32 @@ static inline void clear_pages(void *addr, unsigned int npages)
 }
 #endif
 
+#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
+#ifdef clear_pages
+/*
+ * The architecture defines clear_pages(), and we assume that it is
+ * generally "fast". So choose a batch size large enough to allow the processor
+ * headroom for optimizing the operation and yet small enough that we see
+ * reasonable preemption latency for when this optimization is not possible
+ * (ex. slow microarchitectures, memory bandwidth saturation.)
+ *
+ * With a value of 8MB and assuming a memory bandwidth of ~10GBps, this should
+ * result in worst case preemption latency of around 1ms when clearing pages.
+ *
+ * (See comment above clear_pages() for why preemption latency is a concern
+ * here.)
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		(8 << (20 - PAGE_SHIFT))
+#else /* !clear_pages */
+/*
+ * The architecture does not provide a clear_pages() implementation. Assume
+ * that clear_page() -- which clear_pages() will fallback to -- is relatively
+ * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
+ */
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
+#endif
+#endif
+
 #ifndef clear_user_page
 /**
  * clear_user_page() - clear a page to be mapped to user space
diff --git a/mm/memory.c b/mm/memory.c
index b59ae7ce42eb..5e78af316647 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7162,40 +7162,44 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
-				unsigned int nr_pages)
+static void clear_contig_highpages(struct page *page, unsigned long addr,
+				   unsigned int npages)
 {
-	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	int i;
+	unsigned int i, count, unit;
 
-	might_sleep();
-	for (i = 0; i < nr_pages; i++) {
+	/*
+	 * When clearing we want to operate on the largest extent possible since
+	 * that allows for extent based architecture specific optimizations.
+	 *
+	 * However, since the clearing interfaces (clear_user_highpages(),
+	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
+	 * limit the batch size when running under non-preemptible scheduling
+	 * models.
+	 */
+	unit = preempt_model_preemptible() ? npages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+
+	for (i = 0; i < npages; i += count) {
 		cond_resched();
-		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
+
+		count = min(unit, npages - i);
+		clear_user_highpages(page + i,
+				     addr + i * PAGE_SIZE, count);
 	}
 }
 
-static int clear_subpage(unsigned long addr, int idx, void *arg)
-{
-	struct folio *folio = arg;
-
-	clear_user_highpage(folio_page(folio, idx), addr);
-	return 0;
-}
-
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
- * @addr_hint: The address will be accessed or the base address if uncelar.
+ * @addr_hint: The address accessed by the user or the base address.
+ *
+ * Uses architectural support to clear page ranges.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 
-	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
-		clear_gigantic_page(folio, addr_hint, nr_pages);
-	else
-		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
+	clear_contig_highpages(folio_page(folio, 0),
+				base_addr, folio_nr_pages(folio));
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.31.1


