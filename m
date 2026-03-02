Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9B1E9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245486B008A; Mon,  2 Mar 2026 06:48:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF696B008C; Mon,  2 Mar 2026 06:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C40C6B0092; Mon,  2 Mar 2026 06:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECF896B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:48:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B47198CC6F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:48:53 +0000 (UTC)
X-FDA: 84500951346.18.DDB04D0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 58BB7180004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:48:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OIj/jTD2";
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JbcpAvCH;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772452130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UYz+5bvjqRaQKNe7khyJ9jzop4hQzPyovSiycDYUyI=;
	b=RHe+jA5TwcaVJJksWm/vbhBO51As3v1aEDgH45sHYns3fcHkP7TNSG1NZ8HIKoLkLCHU1P
	DJ2HiQQZPsSjhSKMUtddaL9QYTTbBfelfPY4g9gBmW+Gi/9mdUefyLVKpuBKw25CwPt1kX
	JtxtaSP05+NrahqpsR5oKKfL+PH6fC8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OIj/jTD2";
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JbcpAvCH;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772452130; a=rsa-sha256;
	cv=fail;
	b=e8ap8nNfTdXSVSyo9sbLNDFnpCNJ9HL4Qaz3nOIUujATnkVWs+HR8UV8oYaT2RKmupPMlW
	HVxu+wRV/St7SANXH6aqmCnihBSVhbX9scfrmsz8FYYen+Texd7rYMtp1yAtR13IBUAhmn
	EFoI68n+wCQe2itmojb647YwPK5hKh0=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622B3ckr3252901;
	Mon, 2 Mar 2026 11:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1UYz+5bvjqRaQKNe7khyJ9jzop4hQzPyovSiycDYUyI=; b=
	OIj/jTD2Tj002zmj/LT5X6UqY3ugVEDYbkNl9YaTfbVXXjPHGnz3MH6sU4UlkooP
	kCope1JVE0uKqiV2cZ+FUJLVOb3Is6wlGvjRx6j0VTY526j5+CyfBPYP7mJwoP+F
	JoBv+Ny6CtXmpNj6velvQ7jCx7BE9hZlXWtm6902ECpG6nryvHea9ZFMPp1Uia6D
	PuMzEixDGt7ZC2yBUkNnLds7QDomQLeRCI1o7dFdQFM9xNNP8KWFSqBimVR7lfI4
	c+m3EZU6i6UrneZUHAwFbUDuvHuErctaiBI3ERQRGJZSQDLQywdWd5yTuJOp1X/2
	7N3npPuDvc5h7ZBufpzJMQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn9bc0220-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:48:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622Bh8k5034783;
	Mon, 2 Mar 2026 11:48:43 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptcukyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:48:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vM1f6Z+AG/SqbcVp0EjnCY/Zxecy0teJWyzzyRLQIBsl99NUVc8SjDdyDSURfM8vu7ONYksHZlVMHau6YJn8ABXjRgKZ+wy1BSAxpovCYhgv8lTlHp1pkwYYudLguDcH84xfXbN7mHqmj11VXwbSu/9Y9GHruOvqYkVRyW8qMRFK1V+zHVAYcfSN+M89z94ztOKV3Y2Kol/6iwvUuV/chG75zMIurv7P2qmpzQrlMP6unHOywm8ubcbsEiH2Jx6y9MgVMaRQW1RLE4YFwyN49Qmg8uBRCqNdBhsboJccIPrLPZhjtAuDg0KXBvaTLC7W/UCAY8a2s0giY2JrxjY5/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNE9mQnGeiDnMj0HGiikQvm/7dddNJFm+guNxC949e0=;
 b=VpTT2GEQvrJbKXtFl0RfR7r1QCJGJphBtu1h6htaJkdk+QPZLghfjGQmgRCVHYGh4mOC9PH/Qw1bes3e41upEo/ct8RQD3jtHvh86GX/FbX3OZZT15KT1HaZ+RwdTau8kao2VflQj6CZwRWTneS0fWkBg/9PRNRdCk6zhAie9LNsn6KuT8FJb2wWmVh6V+qSzQZ7JRvgK7FY32AaWVI21FuXLwoEoBZVNKtnuzCBZbPByPRuGp8e0tJRmcJKK3pYcaqFJwnznkbLPgjlhPVfidRO00ggFhKSHA+GsUDJc1btMf6xY5yJI+VAkWmZz5wZghblfkRxoChHvCeyWpksDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNE9mQnGeiDnMj0HGiikQvm/7dddNJFm+guNxC949e0=;
 b=JbcpAvCHOSCswe/4a09XryfQOy0+aZJag5u9OM3gQTBUB1/9pc3uzhdw+KcxliCyAipkU8H9G09+u92lxu8yJCITPX/eVW+S0cj0RYfaNcba1KFiyApg27X20QAstI3wYOSVTGA5R7Nv9qslUJ+ULF/njK3VqSqQEFpV3xqYenM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6218.namprd10.prod.outlook.com (2603:10b6:208:3a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 11:48:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 11:48:38 +0000
Date: Mon, 2 Mar 2026 11:48:33 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andre Ramos <acastroramos1987@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH] mm: add Adaptive Memory Pressure Signaling (AMPRESS)
Message-ID: <7d5da04f-600b-41c6-8316-e86b0c3d00cc@lucifer.local>
References: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
X-ClientProxiedBy: AS4P189CA0007.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: df3bbbaf-a9ff-4317-222c-08de7851a444
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	cYgWhwW81QeVAZCdSBLxopUWIUSRMdR26wZwteBAnaOC0TFSKMf7q8cvpaa3RxPn48vIQ/ZbKP48cQ/np6HlzdU5J7gmxdfTjV8l6PTN9s9T7pK5ccB5Nb/oA0WFYLlhNumzlLK7/8gOf2NAyJBXqrPTmqcr6FEvwG6Hf/lzccBojCIeTtAYdtaN3DajMX3OedOifL1vIv472MzusGJRWlf4mhWNcnZUlwcKpbaAcREaojT0pNQcIl/NqpdXQ6AK5Utku4fhh4EEC20OQgTyc1EaU5RzNxhR5dcDZwdAe6A3Ue8R60qMM8kwey3Lru62muOdNSPVwxtCKOkA2XPpkcVVMBuKzAj3L99M4Ce/coZijPcgcOQnMSbd3BDBHZk8eJ9bjvy8B7AV6mKRb1d+D4+2XyxRnE9vhGxApOrTPayKCW3lWexrfwu5rcaImKttCtsY9jF6PPbWMsfblw5gPX8tQwOi86C3inSBSQPoi6XQGQWHtrJrEmH1Hy0PQAu8vnIfbdJZ0oC2isYYuMVa5CbCyI1lFKazzPj7CiCDB34jjAJ+J8ZfgRFvTW+DyRTrtc1yWeHldzkNd60NODY/szkMpXHb1y/dXYYf8MfMGkhiYwdPRAy3IoecxOg6Zjz9sLgSPWtwpSg3iFYLZMpXUrJT0Czk2kqPkEC8SqufKEzeF48r/w3oNTdp8YNzD5S5Jq9bbEacjEt3oruUqDr+CSgwnxuLc87NJptz3OFIltQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?Ls05IbWOvLyQdMUXfezSYFJ9+q6aKFuuoLrnH/cgiqoyZ+rdVVOAZuKOl8?=
 =?iso-8859-1?Q?glk2kBJZ5wgV/AeTaIHY9abRKHn2uatsOZ0YdMSfw4wViFJYOMOlzpENUy?=
 =?iso-8859-1?Q?Co8CK7HiEBqwBcHS73BbtwKyWdanZyTlvaDQaV4Xb3U62K92TG0jQjwQAj?=
 =?iso-8859-1?Q?zi6NsRn661KHi30mlv5ENkhG7QhjcBvlCPkDgPn7kF3Zseu9P4VGcDZdvm?=
 =?iso-8859-1?Q?5Xk1Sm145gsf6ZMfs0gK/GcxKVZ21Hz1vhxHuykIznLNhx8fOc9b+zZzMS?=
 =?iso-8859-1?Q?a6gAnino+1+gNZvxujKOdPLWc+AH5UyF/xet8rQupjhfcMy3M90ZqqqB5N?=
 =?iso-8859-1?Q?tGJYzsoSJShfq5E7bIicbkp9JAFDCYVzr/9keN9WaEPeYpz25vUOz4Txrk?=
 =?iso-8859-1?Q?WjF1aibroPArcyLFDqI2R/Y1sa+W04EtSJPmYudA45l+j0MRmhpkXeIk1T?=
 =?iso-8859-1?Q?XTYEx+6H9v9Pz3biZVgVy31MO582I2v0nnK51hSyknzgQQgNCfKCkd8r3t?=
 =?iso-8859-1?Q?kFAMrZ2XWcYhLGh7da7idlBxY5mgpla6HmYq9eP1UYtbq3hmLSx9hkUNfh?=
 =?iso-8859-1?Q?2kySjjgW5kPC+NoQ7sjR3zvG03SaTC/0sGZ5dOaBCd+okUex8BP6+/dltw?=
 =?iso-8859-1?Q?iQ8YqX0b4tas/LvZGYBBmsbQAWz5dX61toqJyabU/TjLRxL5Kc0C+jPd9E?=
 =?iso-8859-1?Q?4zlO7oyeXstiWV9OgVatydH6tz0Yli7fEPeE7yn73Kb5eTH+FuVj3fdeTX?=
 =?iso-8859-1?Q?4USV+//fKmW6J3LdsWcCVfkVQUX1yPx90Hi5JfSvuttSn6xF0dKELOFF7h?=
 =?iso-8859-1?Q?QOmfTC+PhfcQnq86Q67vk2vuYV84bJSB2Hxx7uPOEdEkgaC58xnqPFGaqG?=
 =?iso-8859-1?Q?Th0v5iP0N2A2qokWbZlQymKeZpHAg+lI/ORTf067/sjGqTLO6Fzv2/Mtl2?=
 =?iso-8859-1?Q?c7Ao0SVBBdX6GVBn/paAe2CncQ6ilygZCODRrgagExQjbTOkkxn1oa4ig6?=
 =?iso-8859-1?Q?gCIWd6Syk6da+8d/d5096NGIO8E3WgL9ooijLjYUAdJSBJ3kdcGAYtsKIa?=
 =?iso-8859-1?Q?iW+0Q0FFOKB/974RStIYUhChEyJrFJ9BXtPtpmG4AGgWp3SjBuc7nApoDb?=
 =?iso-8859-1?Q?uRdc8LxiaCsmcJXUPgSd3r7u76ohQlOJARuo3WkYFDP9TlEJWd8JH/HD0+?=
 =?iso-8859-1?Q?kwe36Lqs/OZGoe+Efw+w4REGhahxnlKzl7zHcysWRFox2qdDEtculjxc1V?=
 =?iso-8859-1?Q?sqwWA/A1/EhO0pRe/pNrGDpRRYtzBWjrCq20Yzzd5Sj/Sh+ZsYF8QRRTpE?=
 =?iso-8859-1?Q?944dmV8mDlOW7QD5JfaeHg/eO8C9u8q7Oo7twsYgZojEbv8/XHmojFt4xQ?=
 =?iso-8859-1?Q?+ZjbAONpEEtTskojiLRrJ/lROmhacPBRLYuoUJ+5VW5gXWsrFi0mvYqYAA?=
 =?iso-8859-1?Q?MhVTrWmBUT7F8u27TdRcM8H+w7hSxKxfn16x6brtKAF9J0YSqKXdlV3bck?=
 =?iso-8859-1?Q?dFAgrVoxP/jl5r53w8UWPgLASnt5ztbjzdv7vvf9A77xEYMFBUrvVbtqkH?=
 =?iso-8859-1?Q?tE5khT1+nPI3OPWM/CrorksQyg5rOpqkW8F6pR60Xn3eCuXmPaqaMu9dZD?=
 =?iso-8859-1?Q?Ullj9yfpGf8DSipTkgT/3SvKYGd+wt6j+8sqX1RtAYtFSO5pezmotVsOhd?=
 =?iso-8859-1?Q?fij99z0o1E+Pc8tdCue9AHPtTkDKO4+kPw0dhRysGRcNcDGJASkY0YCO91?=
 =?iso-8859-1?Q?hP0yJnXo8sJYzkyaOCBVyhpdKjDHISg7M5D087jZg0nEBV/NFpm76ay4a1?=
 =?iso-8859-1?Q?spF5eaKFQ1qAAln5O6Kwzy1c8ztDq0A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Go3AuHXUzPD/bsOAAKffqyNI4rIGTu459ZiXpzZPOGUWNaY4MU2ahO4kkMCPBo0+HCMZyEP2tLH6St2RgNIXLJLXji5jnvoNRsB6LYoWVVjngrBaOFrhNKJV29PyUleU+MxmhJf7+78ez8QGUyP40vAMrLwqOPbKvh6qpYVDc3PzPyQHDBj/jdwg/QcvtVGpXVoONg7vrFDS1tJBp3+BB8WLd/XJarl1yyjcPNEhOkNHjjXHC5qu+FTH4Nqyw8CQ5RjS66fNGefnu+CxtTk5B/2T9eXhMnO2p00fjn945PB6iqXdr9UwVdF8G32PfGEAuHm96KgyCxt2Us4kP12t1rtE6p+qdw5/nQifAqzEwrnXSjm2EnXrGLx1rQdw817oXhO0zrQ72ykQW0NPgizFpsE0ruUoMSklhzjS4JJHDRG/HA81PsF+B7e00xUQ9YxVYzL6ez8nTT1IkVb6VcVZCj5c7QP1bK+ACB1QiEoVbPFfHy4Oji38vTrAplvlhJa9yABM6X0NTH9RHc0Z2TtDY6mKLvIBgf5P14R3McgQi6y0oODDGhqjK/TG5uka64oeQP1QXInyGs2c8ZbcGSY3jPNRycv6cU30Krw18wIpZq8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3bbbaf-a9ff-4317-222c-08de7851a444
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:48:38.5914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcudPNrkPMIJqODS2Cy3oag3zJOesI7A9CI99KoqWgdLPLJWVyLepijaMfvQ4NMkgVawjFzLOsATq67HS4WBGhzDtoiBkdELmQUthKEtwwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5OCBTYWx0ZWRfX/eTn5GiA96LT
 Y0ekd9XkcwJ30mFgAhC6ArE1n+HkF+hu906D63yhf+2CLo2TWX7TnbLi+pu70ocPyX3sDJlEpzB
 8/ZYl+0Plf4beC5T4R8eU3eKzILpeX376ncr5d69vkLIBANPqEEBDx5hA0cVseZPl+CamRmfkNr
 2Fn1E4IzdFgx9hM/hvKstrsftpKxHqqrsjEmvrYSFEZ/HEz1xEld+qJt2JpmKAsxaXaI02ru2Zo
 AT7uUZLGysXTpAUrTXFutRjwwmb0r5LNT9Pz+ct/OxXDuZbljxBhs4tJAc6dzlQB/ww0baj7Gw+
 sbdGU1XRoxOuezSksSEs5dixlA+SzJ7v1/mZhSnIBBVScj5LbBgl7B2VEtvr3xgNTlPZJ8+XgxM
 C8u+Bl+YlwrL7ThZIgaOttHKoKlrWpFZ75J6H7N4xcyZQrd6rTC2xiZunp06HxjK4aEu1Spnomm
 Haa/8ghalfUFueOvPSU+Jr8Ckz2BB12heC5lwgz8=
X-Authority-Analysis: v=2.4 cv=bNQb4f+Z c=1 sm=1 tr=0 ts=69a5791c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=pGLkceISAAAA:8
 a=37rDS-QxAAAA:8 a=Lkxvbzx2cOnklkAGRmkA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=k1Nq6YrhK2t884LQW06G:22 cc=ntf awl=host:12261
X-Proofpoint-GUID: ehttaYZ5FU5eiyIulfEERdjbJ-TShLkd
X-Proofpoint-ORIG-GUID: ehttaYZ5FU5eiyIulfEERdjbJ-TShLkd
X-Rspamd-Queue-Id: 58BB7180004
X-Stat-Signature: prcgsat9e7qe7q1om9gi8ady6ht57g53
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772452130-607401
X-HE-Meta: U2FsdGVkX18jJNwESYB8t64gdnLmyAU7x7uO1AI1W82WIaJNtqvin+00iNy58s55chqIaEbmTOw1h3Rz1G/XsBXNGm3JhARbV+UtA/cIbdIEGbENfdevMAv2aeUNgtk3Nuc2C619eWyNHKs4k37GLxs2I9pzgHXH/30LLF7PKav6GXuozHbmoPF8Db4Tu9mjbAOjQKoBOQJMfQFuvqtHkl+dK7lBmfUXMkoSQ3tP09NU0bdCFvdmG9V3YzV7SE7NH9S1XPyciy8qeGMnue5OV/T2gggo9ei8puIN5Nf/z2iP6BjtO5QvfI+YmhcIcT4kJTU35nSCVNico/xwVc7ro+CZLCHmX9CyL24DW6USACPFUBy+AkIRG4FXwE1jRBUOtkChkUIncnt+8cXhY7aNRXxKbpa1EilyXvialVhESvQhPo0fRm2wqFQc3YE3utcRKFLtBD1d7SRndhyFGvNXPQURltIEf3c3dx7Kw1UwPsBzcLHNpCq3zAQMQmuWHmf+oCtFrqNuB/lXjRxWcWQhKu7/npNWgruv04J1Vhudu2eboqLkmOwp7136Gs7R7NC10HwEVqoFdNlXu457bzgJ8sh0tf8vDdrCLpHrSIqEN4ygc7BMtE2ZXeik+fIwVh6Thns3zKvZiPuysLJDbJVFVeoQxjvAAuGga/eP4UsHPWMpuOnWiRpVdHSUxm0u2ivc18PqdLQCCE6HLtBWLleQkOJeBQ5AXqRn9G8KKa6KH5efZhm96sUwBE2a9mbT1QHHjS3+uI9/XAeqYkbeCE7Tu1uufOgYOu9ysVWLG4fFCskURU7WMOWzW3O+P1fHkN9/sfAd/fHjE5qg3R3gigMlzx3K2/GFsateSgqZAxTpwQ7ioSHel9y3Zb/b9xGj5u9f/ZaO+9dCqt4jOtmwTBgE0GSbR8hqZnbAtUm4YrPSKdi3CWrlGyx6ykTjq+ABs+LoZfVDH/gePEG6Yqkz2Bd
 s4rn/Som
 qXSuldxeBdngZWBuOq3yiI8yagzQVfuBkJW08nOlUWMAo0Tese3i9VVcdTcZR4mzp05yu0V+ZUpp7sg2asI90ZYwBmahTSXWlUfoiXUTX0zNjSqJTT1ibALBKPCBJ37PzJ9FureIRFKPowRJrSpizAg5rflpepFKfbQGfBU4Ryy8LBxYQJED3Va60kZFNxhoETpM7xHcvJUkdqmNKu1PawXSrg+2VOsnZ00UlyXOy+Y4dzrUcA+TldIrdO0rYhqTf7NsQYNApdqmQghUiuZ1YU/Et7o+ECnsnaaDSYU3+ezlgAFeG/sYZrSjW10eo5KbotrblBI7fVy2OSZ443JvpI4w7YkdOavkKPTwxHvhz6ChhA/zXbffZzjlms7hWH0WRxLPJJc04/RducZKNS+L8NnF/am7qJAi2zn3YVYa9HBKK1hQyDrOuhYKVJjcAy8x9ImQtDs3e9BRxGbeno5s91TZqh6+9kmh09AC/7I1ZI6U+2bDj6qVnk/OSq69/1TwSzl3y0IByzZFVpCHprlrqIwsD9KB1lJ0yxc6/gCRCSO455Fxpt3efQfq1Udq4JLqZvV9NfYeG4gdbuBCY1t5XjYuvZnA/tuDzVl+ZH1I87p/UKzjC3yCuVSnsad8mUCLs4JgdItb9UXu+jQLmcFUbpVAcNwut1DTXy/SYdO4mKc+UQFL++jleEI4dQ7iarObQzPzzAqRKRRL/rR0Tn+24TLvcuEQdkrk1phnKXE0MPNPYsWvivmpNgFUnZfpxfev0c4oSy09hNuZ2aFZ7PuYMvZoMA9qdy2v+c1p/O9EF6DXHjo05U5ykBUGXo2HkHBOAwuwcCsfFcV30ZeyrRUFWdTVPcir2sgmPilDx+GsV0G0junxYevzaJS2PeAHEtEsSuK/F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

This is a super questionable conceptual idea that isn't appropriate to submit as
a non-RFC patch.

I'm with David on this.

On Mon, Mar 02, 2026 at 12:45:33AM -0300, Andre Ramos wrote:
> Introduce /dev/ampress, a bidirectional fd-based interface for
> cooperative memory reclaim between the kernel and userspace.

There's just absolutely no way we'd expose anything like this as a character
device.

>
> Userspace processes open /dev/ampress and block on read() to receive
> struct ampress_event notifications carrying a graduated urgency level
> (LOW/MEDIUM/HIGH/FATAL), the NUMA node of the pressure source, and a
> suggested reclaim target in KiB. After freeing memory the process
> issues AMPRESS_IOC_ACK to close the feedback loop.

This is really not how we want to expose kernel interfaces. This seems like a
hack you'd implement internally rather than something we'd consider having in
mainline.

You're also inserting some new lock acquisitions and a linked list waking up
some unlimited number of threads on a core reclaim path - no.

>
> The feature hooks into balance_pgdat() in mm/vmscan.c, mapping the
> kswapd scan priority to urgency bands:
>   priority 10-12 -> LOW
>   priority  7-9  -> MEDIUM
>   priority  4-6  -> HIGH
>   priority  1-3  -> FATAL
>
> ampress_notify() is IRQ-safe (read_lock_irqsave + spin_lock_irqsave,
> no allocations) so it can be called from any reclaim context.
> Per-subscriber events overwrite without queuing to prevent unbounded
> backlog. A debugfs trigger at /sys/kernel/debug/ampress/inject allows
> testing without real memory pressure.

This is far too little description, especially given you're submitting
everything as one patch (which is not how kernel development is done).

The patch doesn't deal with MGLRU, and feels like a 'let's hook into one
specific part of mm and just dump out information to a random place'.

You could reasonably obtain the same information from BPF no?

>
> New files:
>   include/uapi/linux/ampress.h   - UAPI structs and ioctl definitions
>   include/linux/ampress.h        - internal header and ampress_notify()
>   include/trace/events/ampress.h - tracepoints for notify and ack
>   mm/ampress.c                   - miscdevice driver and core logic
>   mm/ampress_test.c              - KUnit tests (3/3 passing)
>   tools/testing/ampress/         - userspace integration and stress tests

This doesn't belong in a commit message.

>
> Signed-off-by: André Castro Ramos <acastroramos1987@gmail.com>
> ---
>  MAINTAINERS                            |  11 +
>  include/linux/ampress.h                |  34 +++
>  include/trace/events/ampress.h         |  70 ++++++
>  include/uapi/linux/ampress.h           |  40 ++++
>  mm/Kconfig                             |  26 ++
>  mm/Makefile                            |   2 +
>  mm/ampress.c                           | 320 +++++++++++++++++++++++++
>  mm/ampress_test.c                      | 124 ++++++++++
>  mm/vmscan.c                            |  27 +++
>  tools/testing/ampress/.gitignore       |   2 +
>  tools/testing/ampress/Makefile         |  21 ++
>  tools/testing/ampress/ampress_stress.c | 199 +++++++++++++++
>  tools/testing/ampress/ampress_test.c   | 212 ++++++++++++++++
>  13 files changed, 1088 insertions(+)

This is not how you submit patches, this needed to be broken up into a series,
submitting a single patch changing 13 files and adding 1,088 lines isn't how
kernel development works.

>  create mode 100644 include/linux/ampress.h
>  create mode 100644 include/trace/events/ampress.h
>  create mode 100644 include/uapi/linux/ampress.h
>  create mode 100644 mm/ampress.c
>  create mode 100644 mm/ampress_test.c
>  create mode 100644 tools/testing/ampress/.gitignore
>  create mode 100644 tools/testing/ampress/Makefile
>  create mode 100644 tools/testing/ampress/ampress_stress.c
>  create mode 100644 tools/testing/ampress/ampress_test.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61bf550fd37..ea4d7861ff9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16629,6 +16629,17 @@ F:    mm/memremap.c
>  F:    mm/memory_hotplug.c
>  F:    tools/testing/selftests/memory-hotplug/
>
> +ADAPTIVE MEMORY PRESSURE SIGNALING (AMPRESS)
> +M:    Darabat <playbadly1@gmail.com>
> +L:    linux-mm@kvack.org
> +S:    Maintained
> +F:    include/linux/ampress.h
> +F:    include/trace/events/ampress.h
> +F:    include/uapi/linux/ampress.h
> +F:    mm/ampress.c
> +F:    mm/ampress_test.c
> +F:    tools/testing/ampress/

As David said, it's really not proper to add yourself as a maintainer without a
track record in the kernel and community trust.

Maintainership is a serious responsibility and really requires that you have
both demonstrated consistent technical understanding and an ability to work with
the community.

Obviously as a new contributor, neither have been demonstrated.

Also there's an existing convention of 'MEMORY MANAGEMENT - xxx' for mm entries
in MAINTAINERS.

Thanks, Lorenzo

