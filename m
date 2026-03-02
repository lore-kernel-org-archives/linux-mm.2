Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F21EB3622
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461F66B008A; Mon,  2 Mar 2026 12:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4295A6B0092; Mon,  2 Mar 2026 12:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301DD6B0093; Mon,  2 Mar 2026 12:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2150D6B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:44:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA968B7449
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:44:22 +0000 (UTC)
X-FDA: 84501847164.09.64BD4C0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8C13180008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:44:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Bcjst0Lh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VwVKYWfo;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBLqDswliTjCLGuBkPCW34SUX75cNXZnSSTzFryZUmE=;
	b=7BL5jn3XyVIeQpSC5OJ3wMzVAkkt3s1qn5vc6JFyko/7yRUQ9O/BwD8IyHxs4MPBGhVer0
	2TbvMD8ESe/E3lXouKNp4+6x0woB6u79G2l0+OJCDsTvUgpDgch915HAZj6pQP7oQqKBNE
	0Qm4iL65mQVQFV4yq/WN96NowvZ3mWw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772473459; a=rsa-sha256;
	cv=pass;
	b=5QQ0v1flMVRv+r3KOnG0Sw0oE2UVM5FK3Cgt2RdvAoPgEnQfsKtMJM5R9p2PeaBPfma9AX
	RQHD0zWHtNZRDtVkfFj2I3A644wsd61nYLOXkjtmijOaX9q840CgW+NSfegPpBqAKx98Ld
	jl0Klv0Rz+7GWfO3ZaxeeTAZhjCaLqQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Bcjst0Lh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VwVKYWfo;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622HWH8I2606781;
	Mon, 2 Mar 2026 17:44:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jBLqDswliTjCLGuBkP
	CW34SUX75cNXZnSSTzFryZUmE=; b=Bcjst0LhRDAl3oY2lJ426FXNkEYXb5Hpp5
	YDcFKEXX4LoHBgMEUHUdy6zBkzDelCC8HwqjL40nRhMlLAnWwy7tkGutNkzY4Oi/
	ErE0zKhKrbh7XDjghhvtT3haE8Hp1ViPf2J4tB4U532wtmQiDfnDHc9vOWRchrlB
	zQqqDT1bFSM1sbGW2xP6zeAKynmcGrvNl77MecVX6brxAgyj9m01JPXxw122UU77
	HcRzWultVdTBpV2bC8+hieTKt/cbt+ieHF/tTGI3h00fjEtcHRQwHb4wXRo6tyxV
	fHH5cwrQkok8yH4s0Soytu+W3pktqEdv6XXt4lbBnDNdalkmCvEA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnf1m80t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:44:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622GJJkM029750;
	Mon, 2 Mar 2026 17:44:06 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt98jwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:44:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rc9KIZH3ACTKfViDGNAZIztZoOpe1smzKzPcdBikV10+NrFKGjObj7+77+dfy9Da5mHw8db4773ultrCVjJGDe54Udlkg8FV1IeNzqrFxVKQHQfWE57EszYtJoINVtsPNtR/UBHdl7D1rocWq69z+olrj4Avw7yWQ9BebTUFO6sBc4OTn2shB6czLtYWtjkcGjNg3zHthhckEpyqnrMYvWQYRRTfMQg4jrF6FmO6YBPdG8X/JMaMSfIlgO3+g90ytPql/5WxRhvgKjx9nlFW+jBwi4Vutt9Yv4llpLe5ctWUnzwnVMK10fLXOxIkSaDcUm7OblFSyIK568iUZNFz8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBLqDswliTjCLGuBkPCW34SUX75cNXZnSSTzFryZUmE=;
 b=qIlBSnNN4OhIuHIz1Y2PwbZXWSL4a+SKvbOJ0CxYvrpwQiJANHa+feu8F1bISfq+QdlJjBfknPRJo1ZwM0mTVY4xa1TvjZFEcvwZhY/EDgbOtcOhP0P/sExwF5VZvg3mLda5oyR6Lw3/hjuCwcXoB+LYDSoeOg+fa+3CEceaaDhQWn5NXS/ugmmK+LvqJOiotQUyuPhLomboTgiFx+1bp/4TXbwtJG6ifzLO6QKRiQ2UvsXA4ngkoi6zvTDvhE5LQyWoDKiiBvSAp6NYkfYWRcb+Um1lGE6NBPXh0W1N5d26bQvgt49qP8+rhvDEkz/8KmYLrvzBpJdLUTsxbXlJqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBLqDswliTjCLGuBkPCW34SUX75cNXZnSSTzFryZUmE=;
 b=VwVKYWfokzJbdnmTFuvSLuV5MrTbIs7w73RCxWW44yiFCjUHYqllbC0g4yY5fGdbDBO5iKLhr1kwxHZuENqvPnnqNCU5LXsXvduyGzEf/WA3LuJfixX8kU1/WDuUkc9WMZcNGz3I+y951+jt47rIIwwmnXjWY7/2t7G0ezi9rEE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB6349.namprd10.prod.outlook.com (2603:10b6:a03:477::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 17:43:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 17:43:59 +0000
Date: Mon, 2 Mar 2026 17:43:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Down <chris@chrisdown.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
Message-ID: <479c691e-1330-462d-9d7d-25cfda1f190b@lucifer.local>
References: <aaBVg6nPQz-WvyzT@chrisdown.name>
 <27c260d2-796f-48a6-8b1c-751ab172d480@lucifer.local>
 <89d988b7-846f-48aa-9b69-c316f2179d61@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89d988b7-846f-48aa-9b69-c316f2179d61@kernel.org>
X-ClientProxiedBy: AM8P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: 82fb3174-6741-4094-c16e-08de788348ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	KGa53XuZodwbSL0Uu5cqowOW1nz/GUx+TpX7vAsUBeKJKFXmdk8J/s4d3rQ1AkjmXt+Zu7tnIBxWaFLQeaSKUiMHpdVyO9HG/asI6dgL4CSW3kZ+LUuei+XzwpM97sNyrbGk2xD+qPHjfHdFJSn7G/FmVerlTuU028Tv45E4E7gA+XuEZee/nWoiC7wRjx/QdMHb9xMZGqAcsYiX6DXiGZGSMShhx+c3wgfUltoSijFI7fiROUbqagM04oQ/+aSk0dO1ttHiUExI9+0Mx7fE1I9//Ndw46Rfe0Vdssl1tOLZPpn7MghDLuHV09rKgFg5d3dxf1VndZOhlw3SLx2Kds0EQdXQ/0yDEGXifCVQKRwUWIvq/R/WJcubck7QCYxc6/hC5JTFvSbbd4949OkwaXpnJoN6HgQt5U+CfTRayi5QrrwOx5thrizgfq6NllIMEL1N/TUzBvWEKwnVTTtzpFXdBtrms4W1ZT6iaOODIO/1kBnp9cT8wtj+eKYfFmhypmNTT98XbxCTb7oIzp0WPbV/L0X7900N6HXWfP21MaRWIhzG13R0j+pw4lSZKpX+pVFcZghbxu0YN1h4YvTk1m1w/pgKvlf5Wv01a4hOWkrqtuBpZ0lq9lOg+8pnbBZ3b1/EREqXf4eA8mwZoB6aV18g/qcI8I5kcCLOtPrMt3wHywJApmN09s6ssEppAGqE9NOFtLlhemcXAR2jzzRZ1rHzI9nnKPMgj+P0Fd5Dx7o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mGcBYu3SBIVqcQvouzm2SIuHJCjSblB/2X32SS8MYCQH/KqcG+pGJF4nMvlM?=
 =?us-ascii?Q?Rs6YygtFadxpj0BaepmyhrFA260dGRZnbCBE/ZM8xUgSvgv7w8meRjvgZOMj?=
 =?us-ascii?Q?HDGrtmlLIHnShi44yN7xfBc3IC/+u3ZL9816UaZMQOMnM4fItX4PcvMVIv4j?=
 =?us-ascii?Q?7tnkdFvRjuVIvcLpvdg6VwgtK58L+QWLNRVRcuDdxFGnkQSZEbHSFX+lOhbv?=
 =?us-ascii?Q?9x7mW6tWr3xdKbuapBG3JH+izw3MCTPHvnsJ51uIFBOPYJ8Gfhqxc8jr991z?=
 =?us-ascii?Q?ntA2OKOrqwfBLzkOEHoaxeGA+TmhvFg+E9KXdbD3LgbIdFoQ+vzCa9CyMiBV?=
 =?us-ascii?Q?qeHHuvsN34IrKkMxOEtIRMTEEwTIUlUy1D/3A7x+GJadPVoTTKIfr/wE3Jhi?=
 =?us-ascii?Q?tgNHDODCLYfiLWc5TOs9bxyE0FCkZZmHfd2VziK1oVhufXuuLgml0Fna1aYF?=
 =?us-ascii?Q?sjC9oogKPJyQZMzKSPI0fDCICimhCGfZvXZ+t+pC6kXm0pYJzh+uONMDGGTL?=
 =?us-ascii?Q?p8caU1GH2tkwwCiFi3bXh3apjJi9zcHqHNJ2/Emnd423+uchVGMHbCV18cLK?=
 =?us-ascii?Q?BjBoIRTm6S1/8Jq6fecxbfNzNsIcVuXhcqFilo2xMc17nnpd9jNexOEyA6Rx?=
 =?us-ascii?Q?IXX4Cxw+KLIchXUxqCQzLYgrtpv8IYgW4dB1uyJWBzrMj7mFuwG9YMJI0Uy4?=
 =?us-ascii?Q?CdNOd47l1x26u2x1PUDnRlcmzCxF123ADrABXkWJEXni9lTlRgcVupGAXHE+?=
 =?us-ascii?Q?pRgWdbB9P0rWBNngOqG89Vd6W5JIyq8BUfayLVMFFOBAJ4CaT85+axbS+BJr?=
 =?us-ascii?Q?fgwVprJiHcrH88HpWHNS6cdfr23X5E9m9ed5ekESz2nVqFCHTKGXRuIMzrL3?=
 =?us-ascii?Q?/Uq6yP0Yw1IL9WrVwu1fePYJAY3GJ+qSgjCMeMkdMN1+rWXg//Rep9uOR/vp?=
 =?us-ascii?Q?fRxPDN4i7HMlDZLRQQwOHpuA9LdfDTNLQoFRFp+54ebZAT5Ai7Xy9zsfodp9?=
 =?us-ascii?Q?KqkrIDbYiEuCxO7aj2rpu49jnh1aqp4dRuHYrGom2iv5zMAccCQ0wLrd/nAF?=
 =?us-ascii?Q?z+BoH5/cT91gWh2uvaCgF0e2m2HhMpnLsmoWMzZTexlyvC47pdmLBqwHwPie?=
 =?us-ascii?Q?hrlN8ZPEde6CNKmiXGKyiK/19q93qPxJ7tgBF+W//PIcbJY7ymeeZyngbQan?=
 =?us-ascii?Q?aivIXuOuWKBux72IhGk9z5v+uWQ61J5KGIPlyj6pBAs2f2w5/tXliLxOEEwQ?=
 =?us-ascii?Q?4OaC/Lw/9YX27WFP4895nGx9GOQ9x5rx0aAVOdKyZsw8ZyTXN/EVBtqe+4p3?=
 =?us-ascii?Q?xWME2fQERHtziwMSBTtPIETlBC1QNprUo9KsE/DYVHPdXgFNDjobIoI2IoIB?=
 =?us-ascii?Q?jVRBuNBHjv5pb5fBKphUFZy81jP1FtK8FZYl0c0HkAytSqoBIKLoMSOnoSI+?=
 =?us-ascii?Q?dU6sfjSmxKtJ+OXBUbqdHFYbsOb4ZPf4/IoipZbQrNERBJlN+iuGvnb9nZhw?=
 =?us-ascii?Q?nl0VCURKOOJLuADt14pEePsUiXSMA/Y1PXVS/cBdgmZLDCjwsJyEtAaC5o/m?=
 =?us-ascii?Q?/Jha48/L3cUAf9xdgB474zmNzU6It8EczFjiOQtlO+60skT2RxaP79M0ejUO?=
 =?us-ascii?Q?yvmnCLG/n5lqpcGrO4Y/Sshiq5ZBhg9SRnW/UFFgoqg6ARl2DPzPHrR+Sbne?=
 =?us-ascii?Q?glv7DEKNsmB2KeslkVDoxs4zwYzfg81sJYKEO5gXdWJAX3TnXp9Ijc26N2uX?=
 =?us-ascii?Q?JaAMUXDrFussfHDQmb6fwN5U08lGPR8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MZXvZXa6cjH2VxJhyMl68Fnlag8kQQp1ClFARHLgb4fYwkSmE+vrL2/sEw+biDCnv/+IlL3apwqx0UkMB1v5jsQRbehP/qSh6861PteJDTDWb4lOXP49vHhktgsQH9LsGkh/WZPSU33GHpND7huvh8NGLz9uN+DvvTJwE6E98SNsd/gQ2YEzQiVPThVHcQDsrsmfJK03XZBENCYC3DLRsvJkm3bnuI4lb9zPd+7zES4X1f1ykLJH8MQLEFr8EKP4Idx366eXrKNiKfLstiow68cAN26NEZqaHA8Y/1j7vDKUEnWOrqwEwgmxujjzrvOe5PdwPG7TKcPU+MVV+d/ayzu1LJ/IVxPi97nkCBhoeZjXNclX0YtA/EVdT5h3ibsAr+hpege2zfEbUxDFfzFYvfwtd7tsEFg7Us8CIq1C2cgd44rwP8mCAio1mEMbVthyG351DtfUZ/P/HPVsaQpg66p94gVjNqRx5XXQi6x9/PecoZk8ZJ9abkq0oGvdt2esPi12CaUunqZv4HcCL15KgB2zGXQQF78peUosMFLSYEjti1HDFJeyyf0OirLuBkQSQ1vbNn5yctLgjyMbho+t2oEPPXu9NUEQ8zyirePkiUY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82fb3174-6741-4094-c16e-08de788348ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:43:59.4914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRBwamD2U1DXbWXonAa0Izguvmke2O434lD4RdJ0CbxSkiUNoSkb3IKji3y2jz9B8+RF4i/8MZ7iUqbzwaX677SLFeGybukxzfLip5Zt4aw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6349
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020142
X-Proofpoint-GUID: kvfe_ys7ymGUWr-LjJRzNkxkDCAf_s7-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE0MiBTYWx0ZWRfXyhAk2vwYCb97
 5UzDw3qKc4i+enARffd1BIGhq0BLBYKdgZgDCgkqeY4e15i7gMM6AaSwOqPNmcrdQbKxUggppLK
 4LofGEaZ8Y3edK6oFnD2YsHpb/qBXYLnB0K9wCSWozJ1mpyipBLQQdLhyFkbGg7tIskZat05CO2
 TVB5VnPNbL6RrQXwJZ44KCyEamUhm0p9OcSyjOH6V/sBfn/RfIHTB6aBKuBcGuX0MgYfYfHaZrP
 bXSGPR3Ser1TirNbEu7f555197W+u5xinEjZ5H/FD8tNLu5+Trl0T97FLg/rzHEyRNHq9En714w
 lycn6WyNSdUodVJjGrYCUkYbPipzVq1SJB5cMajrLBRXUjy2fgI8aGprOaAq8fSFD2nkK4WWcmm
 TKttJVQSVaOlG1xkdBADpcugIEzFNUjGr3FVN5VHTBVL5iwIIgOuNhnsLNzduIsB/oQXYSVPJWa
 uSUxSXJJB6fvgm/NgBg==
X-Authority-Analysis: v=2.4 cv=KvxAGGWN c=1 sm=1 tr=0 ts=69a5cc67 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=jnnrwYmUVvO1Ddi_JXEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: kvfe_ys7ymGUWr-LjJRzNkxkDCAf_s7-
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A8C13180008
X-Stat-Signature: fugq6wkx9h9piswxioy7ois57j5h514j
X-Rspam-User: 
X-HE-Tag: 1772473459-637627
X-HE-Meta: U2FsdGVkX1/0NEqiopYO3HYCzFeOK04ToOW+xWHbxheYTlbpR85VGCzHexU/ZoVGXCioAAy4YO+EpiH8r17HJ5ZKjZEKTQWqv9P7RmFcedA9/0ln94vgzzNJa0tr5z6ecaSv2usUCKkBCICrQwb9pS/BFtmV4H5wieFePHerrcbdlYEVvQ7Ov8VQm433iN6A7vg4PbcHFS2MrckbvOCcims92T2RA3ccRlf30lF7ZvTlhCftHovmidB/idOJ4ixJR+/puOKLp4gNLkrSu01oj42BiL5hv7isa0ZymkvUASJf4dWoL5IU3I/45B6KRYxqyYZVUmwCmSdBkAb3t3V8tMKZ0vLHSVKMGfw0/rZGT0zQzHht/VND0QML577SV8JcV4+oXad0SoUlKhUtgfpMup0xonjiLRCjJlK50kV00taoezrWg05CCPnW+h8ulQYZxrJ2o7eboZ7bHLDnknFFf+ZOIrhixtB10t9SGCbbEYLeKDmApPFY4Vz4HL1KeFiv0YboX/l7ZK64srkJJ8L7QYhqozA8JaJIRTqOSmzQS3VcY/7SkHGUs8OVeDBqMPZ3RPNs0PZkjDvqdwzmWHxHNmkgVXHW344V7IOeRXHhd6H8lX598lkg1ekU2mcQWx7TFL+zx9vuwbY4/jpQqCjtFseyqBqSSfJYr0Q+QXPxYcDkGCqNrmzaE+cTVRQ4wcq9/PfzIAz9M6xwaWu3NMwdeoJK1hRr6kcLY32cl0KwP7Jt40JNvr66fPfs38Ch7LX9n40oJvWq9Va8ZgZOBBuFbHToIEqtYakjEIN/VBSgWw/FreKuSfs4SVEBBU39LXBjLg7BtBaQMNUStZCjTflJmS6O/vXGVubuv1hly6CPLwks+uFBMtphArg70Q3a+n7H83tVmoHZ6nrK9naom57P/r9o612y0F+HhzPEhQ2Z4l9Q4baMW3YsUZ6IMct1lpWhONfqg6WfKX297DhWmNT
 fZlVGDBc
 p+IDth9ALHGRqbPIFnA4fwdMFmUrx+ijsOYigHDDf/1qMwrru7XDmqecN6TIpcVcgGoHC5j6iUoz4JRoZo4PnzAsGXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 06:35:46PM +0100, David Hildenbrand (Arm) wrote:
>
> >>  mm/huge_memory.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 44ff8a648afd..fed57951a7cd 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -2794,7 +2794,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
> >>  		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
> >>  	} else {
> >>  		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> >> -		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
> >> +		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
> >
> > I prefer my version at [0].
> >
> > Cleaner to actually pull out the zero_folio into a local variable, and also we
> > should mark it special to be consistent with other codepaths.
>
> I argued in v1 that we should handle it similar to an ordinary move
> during mremap()->move_huge_pmd() and not split it over two patches.
>
> It's still split over two patches, which doesn't make sense.

Yes, let's not do that, I made the same comment.

>
> https://lore.kernel.org/linux-mm/0b653dcd-842b-4360-bc1c-8fe779efbc23@kernel.org/
>
> I don't think there is no need to get the folio involved at all if we
> know that we have a well-prepared PMD (zero folio, makred as special).
>
> The less code we have that has to deal with setting PMDs special (and
> possible messing it up), the better.

Yup I agree, I replied accordingly. That's a more elegant thing than duplicating
huge zero installation code.

I had just assumed that there was _some reason_ why we wouldn't want to do that
given the original patch from Suren didn't just do that, and for the sakes of a
backport no need to think too deep on it.

But you're right I don't think there's any reason we need to diverge from what
mremap() would do.

That does have:

		if (vma_has_uffd_without_event_remap(vma))
			pmd = clear_uffd_wp_pmd(pmd);

Though rather than unconditonally invoking clear_uffd_wp_pmd().

Is that correct?

(I hate the uffd wp stuff)

>
>
> @Chris, please make sure to CC all relevant maintainers (I didn't check)
> and send the patches as a proper thread (e.g., through git send-mail").
>
> --
> Cheers,
>
> David

Thanks, Lorenzo

