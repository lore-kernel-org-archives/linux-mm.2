Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD097C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA2F6B0179; Wed, 23 Jul 2025 14:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D23E6B017A; Wed, 23 Jul 2025 14:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673776B017B; Wed, 23 Jul 2025 14:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 499316B0179
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:14:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF6A1801A4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:14:29 +0000 (UTC)
X-FDA: 83696329458.21.D0FF286
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3BDB180004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:14:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fDSGeb+n;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pI3qbwY6;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753294466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1qeVLL3rszeaz92QIlsmOjUtMKdajbF9ur6rcL5748=;
	b=AR5UH1RH8wqUBPsSmHI/KX7KRaFNeHjs8GUhITdfwmdsAETRcjdZYedl5WLrUVjSS5pCEg
	C4DEzLMUmrMjd1k4CxRi/ZxFhj2McaVGrXwfQrs6Bz1ycPqzUIqxJiEx6tf1CoRRCXX97I
	ngpcfqwcP0MVFseij1e6OVPsyMOzh/M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753294466; a=rsa-sha256;
	cv=pass;
	b=U1M9wqvtzoSAFwRFa1gDYeVc3YXsm8CgINfPHzGSDTGo+O3dlGhi17tyihFN0p+WkpMGgh
	/2tBybRtSDh+JeaJGdpPGqntqpECSLYm1V3/1vbxOa/sJAV4G+EB1eqRoE1RdgHwUfmM7i
	A+L6JCLJckVjCNtIphE0rtu2cowzklk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fDSGeb+n;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pI3qbwY6;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NHttEr009436;
	Wed, 23 Jul 2025 18:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Q1qeVLL3rszeaz92QI
	lsmOjUtMKdajbF9ur6rcL5748=; b=fDSGeb+nGjJSsJ/qlLNAu1OqqJE9lFNuAd
	18AHr4dPzI1/OkVpNj5H5bktH+cFwaHiSSaJWsBVM24fq6qYNgoXbFAXNe8+XMhP
	+RVS+WxaLSmmKsliQaD4H3np9FNsUr6MnPmOkVBa7cVW+xIJaZfy6rA6f/eYvDQu
	U6+iTqTCdCeFyPRJhh7Bferjmo66c/ZyLHWwyajYUKMSzGYOH+4MmDcGjRjNq7PW
	SNS1kifPuV/4nFzY8vCqD4vbnBsqkFw1wlMp6izuCQa3dX/bkhx2JFKdqh/eFm4+
	VO4brGJSU6x1PNzQE+Q5EYepKq1UuCfVIkEUtaZGgzTuUtJvw2Vw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2g41m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 18:14:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NHABhW031483;
	Wed, 23 Jul 2025 18:14:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801th7yjn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 18:14:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xToOx1KJxWaTniJsjxY9HE1CpjGxqjsmLi/86y82Wkw+j2mDOpV8HN8sbEj+T0FVy/AMvZuQUXqct/EaZ7x9cpsO365pFgf6HpUPcVZzaOjbLtXpgiMR5vLm/fp1b+B4Jin95eI1qmfsvI5HOuVvup6reB0lANhWArdat30zciDTQpPPCJ5OyGijYZFLnTFH7mNfPuNa3KB7Tm9zKhLWx7e4LX7X+XNAZQiUFiSv0bsWi1vgVRs0zoztBTjzFkoDyJb8DnYMepYGBTV/ssIAfQE54TxqlEl83Zb5OwZXSSPtMSHMwcH6N1vc1IlZ3LKs32FNhaT2xUTX94mI6O3mFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1qeVLL3rszeaz92QIlsmOjUtMKdajbF9ur6rcL5748=;
 b=PzMIOAHeSlUGTM8Q2riBswR+N7F4pH/eNf/aEfKMkJmaLq8YUdMcVUD8xUi3jim4wya8v4tTZnKeQ5Pk+7s/w80DLNjyi2h7bA1QDESi1QYALeVoKweweqVV+s/hwWXimEGqwS1oGrXQYUTD6hVle2TERtcMbtLcrkFbbAeNx4FKuDgp7ksZKM9oOfWQ6w56Mq0ZM5vLbHeZvQ33VZwgTG2Xgzvos2AxzhZnmP3xTuXu5VbtZI+EaV8j7+dgmF++RiwMHic34PYgWttEDSHbjjSy8tK1NFljS3zlAEp1QwSBRZ0r4Rkfpg+W8ETIgQaNaL+5jZJC9DxgS+ogBaEKzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1qeVLL3rszeaz92QIlsmOjUtMKdajbF9ur6rcL5748=;
 b=pI3qbwY628afjh/+XYb6qXgncGyCVSA9saIyIf84DaHUtekhR8YrYSERWGMShA+NgeU4WlGzKn7oFZp+QrAbMWDg7uhBzOxuH3Z20k1zJz5KGr3O2WIAxA1p81GpyfjcT+8KgJPaHBGP0P8YKdSsJfLKABKINVsYWf9SkGSgx4w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7247.namprd10.prod.outlook.com (2603:10b6:8:fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 18:14:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 18:14:21 +0000
Date: Wed, 23 Jul 2025 19:14:18 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
Message-ID: <6df9812c-96a5-41be-8b0e-5fff95ec757c@lucifer.local>
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0198.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7247:EE_
X-MS-Office365-Filtering-Correlation-Id: cd870af4-1899-4b84-7cbe-08ddca14bf06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hts7sFVnkI5wudgudbGXwvqkPEd1/98YCxt6B9peWZDoTKS/raaAYQFiGymh?=
 =?us-ascii?Q?QvTHR94hoAaNq39nnIuqNzVz2vkAwgCSzRQxLDM1PdEYxThU+biZVSz5xm8x?=
 =?us-ascii?Q?GIuNAIvvliQxK9HDUFhujDjvF0TgNkx+AjBr7GL6wx3mJqAVZPmtAkqZoPmg?=
 =?us-ascii?Q?Tj+6pGUjRNiNiGNnQ4abaeFOlkhYkuoBhZ9Ytib4H5zpsi8/Z2xgV0zGHvYp?=
 =?us-ascii?Q?RSsav0dJqgyf10ylNKhFHddd8TgeP35t8xos6KdrGPC2C+rEpU0Iq2SdDwZV?=
 =?us-ascii?Q?RZO0WMnI6G7O/L4xilIpUddVprr/Hfskau5DJiKWLX0o9w/T5Qwtrc/16Fvg?=
 =?us-ascii?Q?5Kj4lkhI8MCXrs/iYFqRUm31UtqyELLl8gB81Nu9CFJtUJ+XYt1EOtpAGjw/?=
 =?us-ascii?Q?Rxj5Mw+nA1Oics45a6gJSleKQln3oJ3jA3FmG5tMIihnLal8GYvRQlYPfGFE?=
 =?us-ascii?Q?9Ck41PPBQ/TAe488/MlBECkEB8RlT7a5EoYQI2YLCGE70YY4l1/pTnCMg8Kh?=
 =?us-ascii?Q?QvFFDjx79V0DDvADDcBMPkAKKyGUjY/Puy3J8p/t9WHifiC5+zCXfKw11AL1?=
 =?us-ascii?Q?7r+VlkYDeVH7QTNdmEGd5tvRZB2WVUJYDqLizYmr6wjNsWu1eOPxLWTA8R0A?=
 =?us-ascii?Q?FffRlEmf5w9aMQ2fRKP2uQx8jMF1HgztK7ZjKVSyKca3ESvJykufehg2wdXo?=
 =?us-ascii?Q?J60ovIyvvXRQi783Gj3gQ7jCYZfFrm6Qt0VTIh8lgZWsnYK/EKze75/WZrNw?=
 =?us-ascii?Q?oL7hxB2WDxnUFA9rN6tfPptwUz/5OF/lPf2IOi1713aBj02RO4YqWk9OQsnC?=
 =?us-ascii?Q?PcMXjE295kykWysw0qLYIEUJdltLALJOI5NnDuUJzu2QNFaPvtneHN5XyBHI?=
 =?us-ascii?Q?Pfm/GrGI5iZv9LQEI/7R5ELo/kX7V/ZjqcNXa8D8G7fOwqlShjsQiNdgt6dh?=
 =?us-ascii?Q?FLv5edsLA6nuQfk/7Vuz6EmPm8Fbuf45VAAGQmWcbxZM9VI8CQjvN3Nelfxp?=
 =?us-ascii?Q?azqDDs6TbT8Svly9RE62dvtu7CtUCTzUpgOKnDEsHzf/SBaRVBynGXtOtypj?=
 =?us-ascii?Q?HVfLUx885JxJnwRE6Oj7CkFkdvMlDmg61DHCiVT0xIT4jRaXVbmucNAHAgGv?=
 =?us-ascii?Q?7kZiKpBNBGoqgUnKWT+bMLA2zGo6LvAAxwjbiHLfJKwdf4p71rzB8NEZlYlK?=
 =?us-ascii?Q?1N7zh9jaSpnJp0rXeE7CFqR8XUC6a0u3NSKJXLLLWmI3MQMZhj189Bf7eCbR?=
 =?us-ascii?Q?m2IASvuSUQxybBt5MpkeJfvjZrVYzR8A7pqwHiJVwSV6yvu3xmyu9oZw8BeB?=
 =?us-ascii?Q?XDy5+Z26X9+RdMdPa/kqH1BT5WoBWl9QLdhVcY2sRf6eaD9OZxaL86HVzEcg?=
 =?us-ascii?Q?9uvr0zdf9AK6f5zPauxEMIc1/4RgTKy7PN6XP67K+Teoogr0OvNMJraGHZoR?=
 =?us-ascii?Q?7JIv+l4W9WE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6inKmQcUmCXcN28pe1zCJcexPeC2lhvjbGm4+PzTkgToleKFt2wNVktuCcJs?=
 =?us-ascii?Q?9AFeqbt1gHCB5G+r/awL3jNalsSm5C84sS0PhS2ehGf7NQWqpteFDuyJ+mt0?=
 =?us-ascii?Q?+zrq8Ax+CRcbzuQmK26xTMGyNGGcqMSEJDPml7Quc5VeXIohmpDHfQR3U76u?=
 =?us-ascii?Q?KC3KGQ9t6vhsqJBstJVTzDPnZcJvCcwH+ZFzuYGAhn0MzeEmQ8RuWJClPWB0?=
 =?us-ascii?Q?avmPK1LWU7CasLLN5+68jYpIRGhZ3xc0OHrJ9PFmBgtg2u0xuC6Ij12fbtPj?=
 =?us-ascii?Q?3nouguVGLR1wUw7LmtL6y8/mh813QEA5Sx3sn1X1MdNIrHj0HDuZvoLWSe0H?=
 =?us-ascii?Q?etxQ/m8zbhDiS+czNUgEfWjqiLA1n03OsZTficOhmvTcZuG4+EJVaR5EqHZS?=
 =?us-ascii?Q?3pqRgoFpjB4QQPCabTDe0y5OZpOiu+0ydPcDXFNtDASgV0O58ENuvmVlF1HZ?=
 =?us-ascii?Q?TlKnS6iLECoxNzzB1Q13s9dmnSJp8eglgZnPwTA799L0ZPP48aLLDWWIf35j?=
 =?us-ascii?Q?ebL8E9qdZuhd0583tgCoszKwc1htWfaO1BVuIkvl89FF9ewiBhpOPMx/Mj7Z?=
 =?us-ascii?Q?Xb5n83LfnjdSJiL3Fd/U7YSYZnHe6d23Pdd3rn30J6s7pRruCdQ4dJg+apnM?=
 =?us-ascii?Q?QOy0OMMtrcPJgAHYb4CWUZYYEMJQxXZGWbrxfzxCrOZG2Vbno06UYlrtvTIX?=
 =?us-ascii?Q?mwEuUpL70roVZg9sEk7GnOJdPX8C9vLufgci29jsO8seK1O23gJrsDdxYnik?=
 =?us-ascii?Q?3nsDmlic3yTXx3DJWeXEfjsKIUca7dH+NUF1rZf5p4SS8zfMXgTe0eLlc5lI?=
 =?us-ascii?Q?be3Nw9k0BHhsFRbsvH47sGkfY08s+9n8d1/IOw9wuBHb5Mnl5FEx8XqUU6oS?=
 =?us-ascii?Q?T/XzQKaIWmwl+wHQz/NAlqdAMUPCFj4Y+KUaq+O86pGofnSR2Vdsb3FsIGJM?=
 =?us-ascii?Q?n3Hk3M97rzuAv7nD4Xe856NHgsJANJecuMjlXs2HND6uzl3PB21nAbQALbg7?=
 =?us-ascii?Q?HPvFfvwmor1Q4JUF63h9fqhj3wfzWXJgHkQT0C1xVgfsYwS7puDhKLIKO3/d?=
 =?us-ascii?Q?lSLdQ5ice/6tZmPPdQ1Qy+dkaev8TsYWduv9BtlILUJVe0QC6d7/ibA43PZG?=
 =?us-ascii?Q?Bnmr66Etmf7pT2PqCNezHueWiRfiZzFWZs6bETpoxqgUMGcDgVWT1RTUQHDQ?=
 =?us-ascii?Q?w9kwAwJPhkyIxEBu/vC4h8T8iKTKGxATh9FUyPGbsXKx171IJAm9QRmKa8z/?=
 =?us-ascii?Q?+f6dA1FF8JWkC/hz6vDykRS0Xv2js+A8iu15pUVfbz3zw2f30BgTW+r+1j4d?=
 =?us-ascii?Q?KQ3ZCE2MIeSyr+HAmsMFLLd4FHwInZSa19bXQYIN6rVxn8/IBGRVqJ09dyr2?=
 =?us-ascii?Q?zuK2OJEf862r9g+VSIjLDzHvpe3pVF3dsVUjZ08Cg+mGBt5cg8q2ljAV0pB6?=
 =?us-ascii?Q?XYO/HrJ0vpFUK6pytxNGbanCr3lTI9wiToPxzRCFkfyVpXTG297BfS3xDB9x?=
 =?us-ascii?Q?mxXEucuyiiolCPC9QZkKlNA+PMrzuittAZ6vTuWc39buZaC2Mv82Ka2ZrwIU?=
 =?us-ascii?Q?TkaAM/zjfTAifXNae9Z4h9y70yQi6OukCM237I3QSIs69/IDCku6Ngy05QZn?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s0mAltCH2/KCLrtDzmAIKMww8JdCZwYjTUIpBYV/+etPIwhggiQIlGVaCgGHNnNh88nW9IlUGwGnIV1Zmm059PrZRvlnfyW94ol1iqY5lOV16d4CrOzT2qJbh4hYtoGLz7NSZtA5W9GRIocspGppoP75BcEP8gpXCkrC8UGB0QWZsl3axxFrgSp1KlpHT9fMMMx3oWQi1XSDTA5eLYAFPBcjdRByYXS/lyIPwJ/pAwtJziZKRnGhU15Z4tzJKnFlMj8vcvoyU68Vu0JhUdjROmKZewXTNsfHJgtHWoirE0c/SssHGMHHqs+iQqdPoL9a9tydXlO+9WfDmIA3AMtMqZeGLCBo1YWslCIS2X9HgGrIwewakwifNmB4dbh/+Q4cwYh4fJLmFMKbc5JvJAuiKZeX1YDJPKjq1W2qS7XSfOBsmLOyMK2nfzGjHb2o/aeMko4WsUclUvl99bboJTKZdKC24iM6LwasJZVWIOxxcMrzGupvBMxSgiTggVta87TQfhWvwnQ2/ttINa4j9LNr0pwc9msKLwUCnEd8DkL/zTm0zzzCNPLwv9fRFZV2JQW2OvZpdwf64A5A0jEnbX74LtgzJ5fsQxe7vs6d8kNGkDc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd870af4-1899-4b84-7cbe-08ddca14bf06
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:14:21.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9xVNSEr6IFX3rkyET7JEC2OEV/eXtKsm0b+wENABF80IBJqg0VUcyCS6kxUjVS7SqfQ5o3bljnIptxXpV/gOERWbIxVo/kpWLREcPwfmOWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7247
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_03,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230156
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=68812680 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=WM-lATvdv94pRHHaGsQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-GUID: -9ZrTtp4HaxWJlX031u5ofJb6hXc3Gfz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDE1NiBTYWx0ZWRfXww8QY34eDj4f
 B4TW5ey2cPvzDjUfoSuD5SUp0rfLoW4Kh0Z4KXoVg+A4aOaEu7JjIUvAtZbaBnwtGJaoDR3ltRF
 4lQGIVo9vqCeZbVWxIzDH63MtFIUa2QqfAZKr+AxR3Y6NRp3eZePutji1E7ywrMoHrRCu0Cy8KS
 C0Sm5/4U7ufQeVUVIYewJURXSkDGarIMqO7faZQomIp9nnerMnrNTe7trBdaGOsjte+8ang7772
 ky9b8WE0sasykZwwdPlqfglVVHcUXk9D6rq03m+CEqNa0c7mp5WDsrQspD7n/Evz14BAB+ha+nQ
 el2PTHVDnvl5O8WOO1Im8YpfDDrmTeykNxKU1lVPJxm1c16W5CpFyGotLxkYDz+U1IDbBMsoN9T
 xvIq0CJYiODCrA7NvXguT8ViGljGtwTaMHzgULMf0iIte5AzLt8kEnr17uEwAE2KWulM3xo5
X-Proofpoint-ORIG-GUID: -9ZrTtp4HaxWJlX031u5ofJb6hXc3Gfz
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A3BDB180004
X-Stat-Signature: oskjihaaeueb84zujeooq8okznxak59g
X-Rspam-User: 
X-HE-Tag: 1753294466-392559
X-HE-Meta: U2FsdGVkX1+Q9Dn+BUAe4RWM8OisTtkD+5T7zOWsta6NAkdik0mKOser4BxHGPXCbd3TViWxQi6EWMtPjgNgzu30qRRPLrMWY+Q9xEDc8EYwAWdAPysdo/gncl3D9vGzDuSiwEN1B2/c3v5FwF4MA7CwrDAbZoNLSbZ0S2RoJDnSKsjq2pSextef325EbqRgsFlFCJmrV0zdk4voyU2Ww5+aGVd84/O34GmQP0PZVH8nDmMtuP66ml2RrSC5ZO9J5z674Om3thvW9J9eK55+BaLevxOIW47cIBH3z2FhGyg4mk+tiEDSLelnyTTFh+AunAoho8JfTAQwsPF6Ua63oIQkkSRcdcGWozynvKaT6qOXhn0dOSOjBV0b6gX/jdp+wlod/RtWgXfFi4ne8HqI216f4GH5szQqAxstEK/mcxG9Wm0SCglYDcwZrd75rlKC3tgKQJ5npDrnTCthehtOacGYElwEUgj5bgCT6W8HBfMatvddOJGV9AnJvPmKnopOZs2bpPjvQ8lluch03y++lE3ruITEADCcH6fLx0xix8BsUfzExn4aU3q+zfGMItXWpA6x5vy2ZsUGgJ16ct/kKMmth6QZ0VFbfyMDNjtSXRWThCBjo3zbS3FlFbQa40vGXIozTIwfz9Vn6yKJKEVKtLZwtzwB7+2RteK1AZDEPkcwSz6PIXiaw5XmZw4EIewy8lmGRdIN3+py5/FfbiS+mRcIaQ3ZfnM2TgUwNx2JrjaDsdbuyYKnq6NbDdHQCViZE42nI7L5QNpxKanVRq+wghHAGWrdFt+uvUbPLy8/B6kCtOdQoav8d5IzAptU+9N4Zu3ZjUXVkK7nEjtD5P1L8knSu0BIPgB2UKZSfDatvDHxWcxyiTweEko2QxX+2bGjG6whGoErwiwqdxeVnLWYVIJ76UCE5NJgqhWZGSytq5BTf+62gIEdfNHNFXgcgm3oEWmLrCMqVAAhzVeWTlp
 mxWX/mdx
 fNifGX9paOi7rAqMG++haPRCtxAbKzYIS+PIrYrtPQhvx0M1CW7aLMysgUvtsEOlq8zfb+EE2nIkv6EY5kGuZbbNXqy2QqMzFQQ3UF9SQgpXBvXZ22uQEQhjZcA3TcY2zR9YgM8kIgwp6iLaicGplPxkWwXvHThg+yXRS5P1rgUkPuPKm6gpDAw6JH7fh5joOqDHgdkr32ztKLFSSU9qD0BXt8VB80SAWni0/5muUjCW2fM/H4yZKbGZ6Ne06Zjd1qvUa3WZCjGJnbyhJxf84M3Wqqfys2aqTgtvxPsEmKKL/MEfYyBbuEWt23oXS1DWANOeE4JaRXp8fKodKpRF3hLJd+ajLOD/P/Hi/44yAsmXYmy3ge4ysg+wyG94Hv2w/NbIvRhzzvWFOiRDgqKYjJfsYtKhnhFoysXmRbqBCZQMf4/+70RV+5v0uJ5xSP6K+zmTlQtqZkX9MvqkDS0TMXrZHblmFEzH/UdfikZHO6ne84YtHJcpzJtm1X4QenCb3XmalcP3Rk2yOJ2UP/pVZBWBwdUVDdzKWfdm4KhKnuBz9tyzI/XHcfrlfTB+FkMdHpbsQtXLTwUVfVUrmJtPq7328YGG7m3Nje54Hf4UbeuND3LBPoNWQLaKU5mnkkGy2tx4Cyj3pe8f1L0VoJW8MrQgeyk/HiNWl20zxRnDSEWTkfuRDitqJg/Zr6fjdWoJd9K0xPs3V2iwC7lKi3JvH0rkMemxwhDn/sLTc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 06:26:53PM +0200, Jann Horn wrote:
> There's a racy UAF in `vma_refcount_put()` when called on the
> `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> without sufficient protection against concurrent object reuse:
>
> lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
> rcu_read_lock(). At that point, the VMA may be concurrently freed, and
> it can be recycled by another process. vma_start_read() then
> increments the vma->vm_refcnt (if it is in an acceptable range), and
> if this succeeds, vma_start_read() can return a reycled VMA. (As a
> sidenote, this goes against what the surrounding comments above
> vma_start_read() and in lock_vma_under_rcu() say - it would probably
> be cleaner to perform the vma->vm_mm check inside vma_start_read().)
>
> In this scenario where the VMA has been recycled, lock_vma_under_rcu()
> will then detect the mismatching ->vm_mm pointer and drop the VMA
> through vma_end_read(), which calls vma_refcount_put().

So in _correctly_ identifying the recycling, we then hit a problem. Fun!

> vma_refcount_put() does this:
>
> ```
> static inline void vma_refcount_put(struct vm_area_struct *vma)
> {
>         /* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
>         struct mm_struct *mm = vma->vm_mm;

Are we at a point where we _should_ be looking at a VMA with vma->vm_mm ==
current->mm here?

Or can we not safely assume this?

Because if we can, can we not check for that here?

Do we need to keep the old mm around to wake up waiters if we're happily
freeing it anyway?

If not, then surely we can just do this check, and not do the wake up if
false?

I may be mising something or being stupid here so :P

>         int oldcnt;
>
>         rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>         if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
>
>                 if (is_vma_writer_only(oldcnt - 1))
>                         rcuwait_wake_up(&mm->vma_writer_wait);
>         }
> }
> ```
>
> This is wrong: It implicitly assumes that the caller is keeping the
> VMA's mm alive, but in this scenario the caller has no relation to the
> VMA's mm, so the rcuwait_wake_up() can cause UAF.

Oh yikes. Yikes yikes yikes.

>
> In theory, this could happen to any multithreaded process where thread
> A is in the middle of pagefault handling while thread B is
> manipulating adjacent VMAs such that VMA merging frees the VMA looked
> up by thread A - but in practice, for UAF to actually happen, I think
> you need to at least hit three race windows in a row that are each on
> the order of a single memory access wide.

Hmm ok this is confusing, below you reference threads by number with
letter=process, and here you say thread 'A' and "B'.


>
> The interleaving leading to UAF is the following, where threads A1 and
> A2 are part of one process and thread B1 is part of another process:

Err but you refer to A1, A2, A3 below, should A3=B1?

> ```
> A1               A2               A3
> ==               ==               ==
> lock_vma_under_rcu
>   mas_walk
>                  <VMA modification removes the VMA>
>                                   mmap
>                                     <reallocate the VMA>
>   vma_start_read
>     READ_ONCE(vma->vm_lock_seq)
>     __refcount_inc_not_zero_limited_acquire
>                                   munmap
                                   ^
				   |
                                   OK so here, we have unmapped and
				   returned VMA to the slab so
				   SLAB_TYPESAFE_BY_RCU may now result in
				   you having a VMA with vma->vm_mm !=
				   current->mm right?

>                                     __vma_enter_locked
>                                       refcount_add_not_zero
>   vma_end_read
>     vma_refcount_put
      ^
      |
      Then here, we're grabbing process
      B's mm... whoops...

>       __refcount_dec_and_test
>                                       rcuwait_wait_event
>                                     <finish operation>
                                      ^
				      |
				      Then here, the VMA is finally
				      freed right?

>       rcuwait_wake_up [UAF]
        ^
	|
	And then here we try to deref freed mm->vma_writer_wait
	and boom.
> ```
>

This accurate?

> I'm not sure what the right fix is; I guess one approach would be to
> have a special version of vma_refcount_put() for cases where the VMA
> has been recycled by another MM that grabs an extra reference to the
> MM? But then dropping a reference to the MM afterwards might be a bit
> annoying and might require something like mmdrop_async()...

This seems a bit convoluted... And I worry about us getting the refcount
stuff wrong somehow, we'd have to be very careful about this to avoid
leaking VMAs somehow...

