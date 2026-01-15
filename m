Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4574FD4117D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791366B008A; Thu, 15 Jan 2026 07:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FD06B008C; Thu, 15 Jan 2026 07:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED866B0092; Thu, 15 Jan 2026 07:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4FB6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:25:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D868CC188B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:25:39 +0000 (UTC)
X-FDA: 84334119198.06.F613D15
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D7BD1C0004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:25:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KghNGIig;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gH8M66XO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768479936; a=rsa-sha256;
	cv=pass;
	b=IcidkhFSdmcAWoGQiQ2h7xKiY2FJClZEWx3mhK6rxFGROHFadNynX/4xsh7VBpFntMplh+
	KaabdWSjv19+Sts12p1fYcYf4JtRbmgfhqeY0bLapYqWRvU4qkhXR3QgXSmGE3EnDdDA4A
	8lz4k0eJlU6L2JggvRxbLOXbp72hqL4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KghNGIig;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gH8M66XO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768479936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCLrgi+EunFe8vJOvCPHe/Nmm9EQJYFxk0TnEIL2qnE=;
	b=etWEoCco+EchfK/Tf9pkG6JXamtpGgkYyXEgkvCDu8ONH2HpRCTb2xXeUW2AtT2/0jkPfT
	L/ZJlXs429X0SsDdCseZrcNwRfs6RV0RNYN1yUro+zvUS64Di7EV+IBuK2+e0NsryevGzT
	WNTOWQ+kZesstybmWEwJR/LZlc/Yhdg=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60F9BxVN3643762;
	Thu, 15 Jan 2026 12:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fCLrgi+EunFe8vJOvC
	PHe/Nmm9EQJYFxk0TnEIL2qnE=; b=KghNGIigzFUAC1PBt9LgrBrjnZYGReAhSK
	0iVHefFnL6rMyQrGjsqXeIMSUqYzVTxtPXbOuya92sapNlBiOQ6G0cSpv9IHvXQN
	9vY0hohuGkpq+2iwltBEpvGYswFqaFIkPvi18w4X4lWbAXFDE412PCzBlVXp59L/
	LCIaWFaWsRuHX1G+DLY/f2/agPQMEH8ZBmC6/64esoV7q7hw1ZBpuWqDO2nNoDXa
	kXGJwlhGLest0JIvZI6K8YaNgLgB32ux2r6gfXwXxkqogFM9JMc28Owqb+GcMbub
	GQ1dMxNGBqU7VXV+uVhzRqM4gkfEm+tidmyQu7Ek06lvTl7WwwxQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc2xs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:25:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBbfCn000440;
	Thu, 15 Jan 2026 12:25:13 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7f2c46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:25:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uB/mUaV2aHCghqe2z23qekDao/qh01PAijJL4UuO9ylLbUYA/2eSffu0DCPFUoYyS9TkdPFyrm6OcXpdy9Pm1i1/Al7G/dp70/2PxoPy+5q/dByhcBUvj0jA2KW19CuhRFx19leEDniS2oQf6n1+BpekTUfkb2CIGvdZW1LpvLsILAo98T0+yzHTT5Mdr7djYtfevaVdpjPVXRPSJD0u02zfzBi6x4WDJRAdXJkJHuQlvRwIA8EBpxoxqtCp4hIi+vQordnrwMxEMu+RFpvRK2udukJzamR8hAWN/SHyXw76ELgMQTD03h8ckvUdYSUQEiNWyl1K07UMTC+Slkd1Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCLrgi+EunFe8vJOvCPHe/Nmm9EQJYFxk0TnEIL2qnE=;
 b=VnciGc1AxsKR2UKv8vkeH1Ha6wieB2zdUeWdEPiJGCNJU6bQhRG/uWsm4Q++bjwkO3oCcFM/KNKMU2H2ZeLJn2cz5xfkM79I+JjEwdLqHx9570A0iY1OGy9ey7y3LMD5XC7g66VrUv3TF2BcYpk3hfUkEMHcoxu80t3jdO8Zz844G/kRYl/SeSUztkxmz2PtSXfi7Lakkou9m9vxKlIn9wJRxmZMXVVuh6YVV7908EQcnQWBXTkfh+v6jXp3UIIMjcnFVImF++DOGkyEF11+d3JFehGF2j4F4tXMYHes1ld5DtwSmen1C4/XbOgpkzsEG/BIfMwwqe5XY78iv6+53A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCLrgi+EunFe8vJOvCPHe/Nmm9EQJYFxk0TnEIL2qnE=;
 b=gH8M66XOvzHy0Tp9YF1Gt63lAPPrsJ2OpduKCiSm6vL4I0GOtzXlctSg9Nx7TWa0uvOFzVVBO1AijAMndm2D0OOCIYhjOOh1RNE4rYTfDVKRm5ZF37YfPI+b3nqcg8PBQ1qCqFUby3SC0RFcI1t6MXa6MbpqRYD2B6ZZpOq3hsM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Thu, 15 Jan
 2026 12:25:08 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 12:25:08 +0000
Date: Thu, 15 Jan 2026 12:25:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 10/23] mm/balloon_compaction: drop fs.h include from
 balloon_compaction.h
Message-ID: <6e68811c-e8bf-4460-8a39-507eb12da4a4@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-11-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-11-david@kernel.org>
X-ClientProxiedBy: LO4P265CA0254.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::18) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: a6d1d792-544b-45cd-24b7-08de54311ed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N0SMY64ffyfFKFCKXsSup9T8iCWhR3vK8Xu8ZlYWedTOn0ARP9o4y5L9GHDt?=
 =?us-ascii?Q?e4k049yaTo8M7giewN+71mJwe9ZW83Pa8BIBaphe5BaYCgZMEUTwBZziYrl4?=
 =?us-ascii?Q?puw/nUYuzQFxFaL73WUMX8IzUQXu21din2jGW6rHdxgWsRSxjDMyU5uSvf1M?=
 =?us-ascii?Q?j6xnSzC4B8RFA+BR8c5V1H9F6+dqF3zL5hd0e2BwxqJq0AgBev7fpIhw+7cU?=
 =?us-ascii?Q?h/nh04fEQtRBNkgiiLbeJX0xs8Wa2o0Ryv5fv6eCmI/XYTPt2Cw0s7E5//Jo?=
 =?us-ascii?Q?giQ7Sl/PyYFfsF8la664HvkvlDlayGlug3FDMJCVkHkDKcRj8LhsbCejual4?=
 =?us-ascii?Q?192WpExRIn7Mb1myP9oETflBHm4ufhkiALCXsymFKJjzsB1jPLNQL6w+8eQ3?=
 =?us-ascii?Q?BYlvnA+vwECpjE6KAFA/OQFUQbDPr8tB/irRmHUwGteJ58zww14jUVFO0n2T?=
 =?us-ascii?Q?J40bxaTycpJ37V6yyowflJW0MNO1sHycXeakKigEU3/a8kFylJ2h7O4VsYtL?=
 =?us-ascii?Q?2GHxKHV4skrjSIzjY2iLMe4u5L+VYYv3TcZyMhyJmcPeSZKMWegl+ITPMJzQ?=
 =?us-ascii?Q?G8EXmru58JOYTkn7LZgqxSkcI7uHrLR1Pg+/coOJDH+9ltufUy0rlq4hCz3x?=
 =?us-ascii?Q?4+BEgkZKHmdlp+ryX2UnENHu/beQt8F03q9ujeGAjq/2N1a90gVndHPFkKJw?=
 =?us-ascii?Q?7GB3njY+vfDy1QDkdP0yA1Vqxc/1Mh4VrX9ar3qczPCFWhdpEE1fA7BnoR9r?=
 =?us-ascii?Q?7iLLYzbbIU1aWsas5nCp/lYT4CzZS+X5rOHQphpQnyaSp9qJRY9m++zL5Eql?=
 =?us-ascii?Q?ESGu6f/nsnZ3MO0KWiY4ECs5uBjls2mkibvpDZeyTnmWFV/9e2PfydLtORy3?=
 =?us-ascii?Q?bssWnRcMlQKdw6E81cCJV+Ve98hMeQ2XNka9Mx/hIxe7NVGVcHYqqN4aqXC5?=
 =?us-ascii?Q?/T/hVRRXJ/at+CiNCw0Pc6cS4Lk5qFzaLyU5dThYKE75F2zPURKTLJixLCW4?=
 =?us-ascii?Q?yojXi8NEWmDluz1QTVnlcElOq+DsbTA0UxgSInOPMirnd2PoXJLQplwh86Ub?=
 =?us-ascii?Q?3dBbBAJQIWw3dXkGsuVf6VuQTjH+7moaoHoop82l80CsJ8RGZiLFSDwE5dHm?=
 =?us-ascii?Q?ZXxIRUOcGLBPf8+k7NyUyVfAC9I57uORdsTtMkNvLif66iWQECFybf2yI3tJ?=
 =?us-ascii?Q?ZDtH02w9Zb4kCE9uijoE5/XC+Ca13poB1LotRZLt1bZsnH5lG9eEk8AujV/I?=
 =?us-ascii?Q?NNDynnsMAP3hcWUgDzGEKVNIM2P5XUFEZHJvntA59P4WlZL+ihGuTQfN8YW8?=
 =?us-ascii?Q?sZwwEb/e6EBDOmWPBixwukMEwtJ3YfJcKQZG+1dLttT07YJ7Q1NWFbPfida5?=
 =?us-ascii?Q?A7JyJPkASbNb5+ahqVvg/BPETOzcmaT1/de7Nea6k4/SeGnCiTdVgPtGOBOK?=
 =?us-ascii?Q?mhw5x2+Afl73mqDPyh1wyFUMaUyzcgPXMfTgr7UTBdFohj0Wx+mJk2X3uTjS?=
 =?us-ascii?Q?pxA+qPzBkRdevYgvseE016qdQcV+O/9RKM9nhSojItf9vrk0YtMJpdJ6lCy8?=
 =?us-ascii?Q?bV+HxvrluCv+oG/+lPI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fa4074TinE3CKQCfTHWyx3bBI2UULvVxllf4rk/XyA2puXf95nLcpXstt7bs?=
 =?us-ascii?Q?BJArOL1PgvAtUqJiYYt/hSH6hAwtJlJci2gi0tGaa751tSxAhuGTNHSPl/8p?=
 =?us-ascii?Q?arqs9DKva6MRPF3MAnTPf35yEGiuoY5U3bhDFuBCHkjHTHDFPxprEqfXOKe4?=
 =?us-ascii?Q?0HIFFaaLVKOF094TWpBXBEo7ZSW7y2OUExgI52enLl4qSMWoeYzxzj+LbSlr?=
 =?us-ascii?Q?4DC652n8uLFSUPnjgpT6G2kXozh/vll2WMrg7mFTokDVaH8hpu6sa0UFCpj+?=
 =?us-ascii?Q?kA2BzFB+vM9saL7s+gG2UKb94OPwjuBptaLyFyR67mMv3dNUhU19oJOsOd6v?=
 =?us-ascii?Q?BH34oTOIhQF2d3Lrpm0JL9UnAwHG5g1QGH1dHI+D8neDKW/8Ayoy9sOvrjBR?=
 =?us-ascii?Q?/pIJPnNo1MeGWpJIMxS8o9tC2R9xDY2sMJtXazn9KZhf6CwNTde3FmlJ6vha?=
 =?us-ascii?Q?IuAJ3TO1yKmG62MQSobb+eqKfP+b4w04D7p4IXof35aez57FIAVB5tJoOXpS?=
 =?us-ascii?Q?7x41y4aq4Gqwbv7scf7X3rWtcV8qWDenppuWug/sA2oNjK54IXN4/UkVXhvD?=
 =?us-ascii?Q?ZO7GhI90TOpnzC3hZUfzvwcVhfSngM0cqbPkhcFPKYIa+L1J7q9FRkycmUTd?=
 =?us-ascii?Q?IwFHjP0wSwKW/liRkUoqkhsIfgwKOuLAwibXlo4iUdb0zZ5XU502QxJRqR10?=
 =?us-ascii?Q?GTo2H9bvLDVIcg/x0aFfbeL2isX95YUKNySJz38Rdu5PEuXr8liUGeoV1KwA?=
 =?us-ascii?Q?HwZhXPgv0Q5FpgIF1y0hTQyZwgVD2ZpluHRF5s8p2VZKcFCHQwU2OoBWMzY2?=
 =?us-ascii?Q?yzz4ZMX184310xpmrwD7rKaIAM3EGFiXueT1B7oc7+ga1JsuK9iwwrJgRuPC?=
 =?us-ascii?Q?wY5gGuxYXp4q/H0fyGyg2BatDytIpbpNhN3+zLtyAI9RLYZ5vVQEDmTB99w1?=
 =?us-ascii?Q?9imrKbX9dvGtiuCjs3Jz2LRs2DnBCGTEXxi8yDb9XK/caZkDO98A4ARkklbT?=
 =?us-ascii?Q?FdnjDmaM6c4OlXkgV8a1SFLruLTKwg+i5tTiqkqwZpgO+ytMU894u7Yg/Xb0?=
 =?us-ascii?Q?VHtOY/C8Xf39QZd7Rvzex5FhhN23D8wX6tutKPkp525DOH1q6RljmNwtolIU?=
 =?us-ascii?Q?1dyxBoEKZbhKl4vzMaaIJQJy0WFgdb1Zq2Rl0RTcJpeKXKwTAn1bNxd0odUW?=
 =?us-ascii?Q?t+F6RQ95UrBthbboeR9z5GjmvEMleXtVQuTM8JDlOeAkfWtfvC6+7hmnjSav?=
 =?us-ascii?Q?FedhBv0p95+5wlwmac+B84y1acBmoK8VOMz0+3MpuX16BIbY1scuqMnbOOKq?=
 =?us-ascii?Q?/T9ryAHxbUSkqLSyDRWL2HzqO5BXzA7XKLQhPqYEZbUrizecr6c1IpC3r4Qa?=
 =?us-ascii?Q?OIdw0SiDRZZekp8wJbgRmoicyp0ERH6eFQuEk47ezq1QRS8WWw/fH+tugYG7?=
 =?us-ascii?Q?w/z6kuJEcxA6S5HeaCMWOm6bwOxl1UTQxFCBIfh+YZxsAUzj+zIzHbP080Q3?=
 =?us-ascii?Q?z+t7CKrGKRkI7O7/q1vnxdsVDPk+Wizrq79a/yyeYA9UgB6fd2T8GPPOJeKZ?=
 =?us-ascii?Q?HjVU0FxQIVCec+zpSJuLtMc1gdFIoJhHTZNrOix+n+t9LjknJyu6JCezZYLs?=
 =?us-ascii?Q?KV3QIgbgLYx/p5KZZ7KYX0qUcDYKuTvyM9xh91yxeazlXuhdFMgxNpTspijB?=
 =?us-ascii?Q?ooAWU6agsB1aoybqXMhOTbJMZmV5ikKc8F6Xtx/eRjAWXGJMZwy7j/eW0oKj?=
 =?us-ascii?Q?KSeduo4g7is9ZSWh1M/sAVHnusBkFQo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a1O3IzHYRf8+W0LqyIiTDXLcFASAJXep3d7GkUBDfGTN+vTMz68W3sT6oTJktxPnpUdp8jp6HJnnT9Y6r51x72tw0pKeLSVL0KNM0bDsGYyZa696GwdnOMj4UwzyRf4tbf/1FKD0eZprM/NsPGpLFoPD55DcrqeXLgo8MGiSV1KP6l2cCfZQtfgAnaqyr4eR+5X7kk2qeED9MJzVvZ7HtnweH2u4HxA77DHXZcioxTUpqfiw4ReZkXt6txsZ1iuqOvMKslNs+Kx/dxdG3KPv5zTOPLke6Wn5CvldOJ2r2DIW9IytPg78n3xUJf+HLUCZSDJtX92ALM0Zxx5piIX+6+ANNcR6XJ+e3alZLnhI+7FmO7u+tqppKhba5f1Amg51ygKNPUgsza1ZWs6D9y1K+LI7ZGgAGnHeFjVJO7lhcPM6AWLA4i/1pJMa2ogZBblGjxx5TBjbt/AOA0lczEc7mWgb24uoN6Z20aukap0rY9kf3KEYWkaCNlsfo1OyM6+rCs3gHOFJ0VTqn0IMBzfzdHBV096i/tiX5srGecoPrnnSSITzTHgGo/mfEZk3486UfqjZ1fYh7jwMPzCYL1kNwIZBLceX0svioFTgKnJZcSU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d1d792-544b-45cd-24b7-08de54311ed4
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 12:25:08.1836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ltqyA4sWQUMchyESkHtSxW5LkF6kklb7H6IjlW0VQoOr2fDI8or4Hp/I8T6vY/HOpE8DILrtV9nX+UvmDDFPonkMr7ucEBM+OSdJiHwVCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=897 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150091
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=6968dcaa b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=UxYfwKLWTRXIe5eL8X0A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13654
X-Proofpoint-GUID: KLzsn9pI8RQDX_qGJ3RoarjqZpzGEA0L
X-Proofpoint-ORIG-GUID: KLzsn9pI8RQDX_qGJ3RoarjqZpzGEA0L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA5MSBTYWx0ZWRfXwti1GJiI5lm7
 9ShCGsT7ty6pLbTQXOe8kPdg2DjFnFMBSEU8lwk9ksKoTy0hG5LJuvbA/sJK6RrBM5gqzjUKVov
 3m/QMgTJ3XzCltMLuJjDfoScWld0GduAbS8miZ2nmLbrXK4qyfCdpHbs6Io16WY26sf8miksLuU
 ibWcIsXPMmBZcthtGi4I5F7Vfcu5BN7TjTVHHt2KxR4g/ANUnfQzpKlI0XZ52SXn8IrndLnTZsZ
 h0PDUnE7KyyyBCi2QTuG+4OZ5Erbh6yyjE3EbwdLY1rH4pHd2B1K0DtkH3fkx7xSm5a/HRWLb8I
 aHWTijMrAXZwrNKziAziHpFyVPUn0qL6OQJKMBmJuSO5ab1cSQexJv3QaDdKfcWxIXTlFoQ6vEk
 DUnVlE9nvT8nTaJ/wqQWbgexXuPqN1QiCvnmfvtVCJWXNodk0luQ9fXBXSavCZ70xokD4mScf4g
 uhsdhDlCNceTyPjeTbemmsPbuEP1h0Dd0CHccK/Q=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D7BD1C0004
X-Stat-Signature: 7z8mwopq6mad5t1sm3sicftxwjndrmgh
X-Rspam-User: 
X-HE-Tag: 1768479936-15973
X-HE-Meta: U2FsdGVkX1/YwgtgNTFycAhnMyUot0/dI5Z6SeLM8uBXgPAnXzYqZ/vo7Veh3Pm3Q6s5XF0lGDS+AIf/by0Zb70ZtFKQaZgrzkr5e5p6cb9H+fLjcY766IZL/0hyQxnINQqrUA0RzQS+QpeUSajwswLVKCbBIg8UnrmgXI3YPHFmoJUunohSswUJPYr9vf6nV4y0mH6b+TLGu/GVGXFH1F7d9WNverryCtcl9cdGXWfsC96SnxTkGwTUIgdxaqnD86T+WtQrYWmh7N/plFTU2XZZI9VIZbSgoKxjWvFqM8O2yxdrY+k5LT94pAytW5KxwfoHhDkH5QxOZJL64z8VDEw4XXgK3jBJIjQ18xYonpgCA3IG0k6qeQatBiYFrfD8w4XkzADJxY5OkRjs7g/0WKcJquJuZExfOTf7BVdpmyKTQbIPLnTBCWTlgH+mBP6TyLDjiL/9K/S5FPekrN6xy2bul0PWXnd0ayix+oJKmLbLHfpwFzl+qKXelMCHzuJBq/4HEFeRFpjq0WkkOwXblBvIDCmcDuxOl382QuHciFE1xg7jHDM7PO/ph2RhrbKRAuQ0kNA22FftyaBUJRKTe4+tbe0YlosJUvyXVqHOMTqMsSf15L4PnmBtUzPVlSC8IIdBdDMELrh06WerA7FiIDq2CXsbHLnmlaHLrZ4WCzaIdcpIVfnhm+Lk1irhGa1BFpaT0ijn+oOOYcDktszf5mpCFlIRA2jszRhsu3KhcVmQ2XcTB8r+Xj92CVeAh2wSDmN1Rzu83x5xquaFHYtYX2PvYVcVOnVAvQaDhzcG113+k1N/CR9eDVLXxiQC6yUXcmT4XGEDo332jhU2GYUBLSW9OSWYFGugKB8seMSfidG8Cl9D3P9EZ78z1c9XGsvdk4tVIRBEYLhzPbp+AnUaMBFGGF9Dz5ikzitIy4aL4UfxlRbiMhz0jhzX9yuiL9CAqJua3xoSQxRV4oRWdVV
 n7Q+khYf
 vrozTt3mYiwdSpcdHqNNkxXN4LTbe6LK8djYDjr2etDUudhF1HtXJSXHG60nYonvwIzSMEpPsMevtFY7tOgMveClV0KQx3tpZ8joQnv4DPaCbQO2eUTtr6vay5DfPYAeuXAF4kqVXbWn4Ye45Gr1ZtBBCR+yMSUykbXDnsHU5ZWG28IP3Xkh/8fwpx2vkVHaRVExBEbYClj7dEnZntj/nJxd9wq2RgzMCR0By9EBKWEDYneAPCFk+7QOI8/fkJDXQNcCVGb6WW2nYGhNgGAANol9mjvGoImRbcP4hcQ86oSz1vU/ecvoyC6hpunjCk/K+MCPoFQ5NIp2KcxYZ66N1zj7jMgWMmQZBJZ/Y/XkU8EPuI5avQtRozZw/ZN/RmKsS3OSIFX6wkDs8X0Z6woHLoBCqQfpmEYOuuOFDsOOwa5/KIwrXE69HGdfKR4q9VYaCBDFXa2JR3Nim4n8txoDomLUWPCcgLlWztQzdZY8Qc6H1Y/lgGjHzJ583cmaNnPkpmU+kQac9Hw25AZv0CERY9R6x60CMNY6fIwBe+qRvtZDehyI8gPIIERW/SJGDNRp743MmAPJvKddxE8FLuAGj6dzbm6AUOD94GtgL99hBlzQBNfpfj9ylUgBZu5uKbEnUw+gmFEbIkZ+zCcHTgE+in4LDdXx1CU5rpPdJ+82oohYjxuOVe+f6/5chKC+zmBq+g/Vx1RwocekSv6ELA+iMdm2HwEvX5e9SWahwHPLSu2jIkqVd02IO+mXnWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:20:00AM +0100, David Hildenbrand (Red Hat) wrote:
> Ever since commit 68f2736a8583 ("mm: Convert all PageMovable users to
> movable_operations") we no longer store an inode in balloon_dev_info,
> so we can stop including "fs.h".
>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

This is a shocking, awful, horrifyingly massive change but reluctantly... only
kidding ;)

Yeah seems sensible so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/balloon_compaction.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index 7db66c2c86cdc..1452ea0635245 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -42,7 +42,6 @@
>  #include <linux/migrate.h>
>  #include <linux/gfp.h>
>  #include <linux/err.h>
> -#include <linux/fs.h>
>  #include <linux/list.h>
>
>  /*
> --
> 2.52.0
>

