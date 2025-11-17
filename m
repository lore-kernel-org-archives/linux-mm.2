Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF88CCEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06D58E0017; Mon, 17 Nov 2025 05:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7FC8E0002; Mon, 17 Nov 2025 05:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7FCB8E0017; Mon, 17 Nov 2025 05:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B95718E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:18:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5240C13C2B8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:18:57 +0000 (UTC)
X-FDA: 84119700714.18.12B049C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id F1E894000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:18:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lBMsE8Fk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rAzNnZ+Q;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763374734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whSJElc9QXLHM96Y4WkKkf8sHFkdx8KhmtZEBjI9Lj4=;
	b=lI/B8ZIQs7eo3vneCVsfoDrzYY5rndJeb5om7V2/8TVTV2QnujTxEKbQXzd1xHtz2lxs60
	sVES91sQrULheEf07KEAYr9mN01zzT+JB5sise4JelvENuiqN8otRt7N4BozvmfiY54WnF
	GD2FbCVLASYLx4lMZiin7/JlFJf4mvE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763374734; a=rsa-sha256;
	cv=pass;
	b=EIqID9tMdDUS9QzAJ4le+ZjFKP5B2qV30fT5hF0lCRcibwC6gyaEJDw93EbjE/wGFTAvlt
	GviVy5DOpekwdff2Lnhs/U/vWXZ5JsXFjHzbsjJxzuNANHGxugBPtFDXbVvHkkWxpmZxxW
	cTOkaueEV4n4GpVSCiio1oq0hRrjmI0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lBMsE8Fk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rAzNnZ+Q;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AH9uJHO011525;
	Mon, 17 Nov 2025 10:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=whSJElc9QXLHM96Y4W
	kKkf8sHFkdx8KhmtZEBjI9Lj4=; b=lBMsE8FkyOH4uoAFgGdmG8b3O0j+IN5ryJ
	8qbnoQPz26JpHfETS4ZqhaXJtHFJl+75PnHpuviR/ITag8mODr4tnyJMhRBHXXgf
	+vx2ljWNJjkqVrD74NanHoABwpkO/wua72mAt6z0nyw9US0yi+//BBrd1Vl+7WSr
	xK11BJq2ouCDMZHJ+TXoPULFZTiTQ7dWDfTyxLFm2l2Fhjau3V0iDXIZoZ7toZ8z
	jxHWL5pBMlwRngBBIYCJ8On+Y+9msHvCj9WZdXETr9WKd8hivNdoh23PDrTNA2nb
	0uQRFc/BicJ3hN++w15MTfFNUgDbsK9toLPxnh1Xd3HyDMYMOQNw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j277u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 10:18:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AH7sNYx035884;
	Mon, 17 Nov 2025 10:18:37 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012047.outbound.protection.outlook.com [40.107.209.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyhqtd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 10:18:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M5xp/7H4uBrOKcTycicbGjhdtJn8SSeNy3rYweCDwFlD8HHF4+mwxctDlFB3FLVuSWXlhjov0pd1HZ6OVE/7lsklBv/O4Qy94QovnzKh3AUkKb2+kat+fj2RQ0829W9VDLNg1AQDRi4BOWphHv0kI8SWDLizglXPG5RIzMC8O6c0GgjPD0J/bEb14sy0pBaMB1pk7qUVeQHr6WkgB1UT6uqqDCQyA5AWkkrYm+5w4ib/bGh37kK0H5UvJ6KCcBoc+ddP27Gy3ex/XjximUD1L/rJG0KBVhYH2cZt1IqrIL1rpvjfa3yc2KeihwxDhG7kHUK868JdpxBuMT4oecRcnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whSJElc9QXLHM96Y4WkKkf8sHFkdx8KhmtZEBjI9Lj4=;
 b=IanF4lDg+79YqMRJ60slvRdS09Q7jaMEJcfL1dpxu1Xh/Mt8XiwoJfpDdr7vQ5mv6PgQVQF+Y0A/fqD+tIRi4mdV8iXXEYOnqIcRNbu+TWvHoaaGzdvDmLPc21NoAM/HKlXX6KjYZ4BdzF2DcH42dH1b+AZj1Aw4KTZIkpQOox+6WX9wGPaTkV41MUwVBpfiz7RI0qS6P5Q4A4ehUbt+jkPpeQJWTIZ4xVlMjoXH5U5un5OyjkdPddnDZ51x+RbUFITQ8hkIWHIXnNaUbaYp2pIH9svrcJlJD87mDcMu8APvDE+iP9dIB84JJjHcNe47bYnfEUVLWRdsH8WLC4UjEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whSJElc9QXLHM96Y4WkKkf8sHFkdx8KhmtZEBjI9Lj4=;
 b=rAzNnZ+QG9HTLL53XpKylQR3yQGDYsBF35F8R2mIyDcZfIjtIz22+jeDy6q6boeBZ7MtM+PnzGTOjMHn56ZlA8Ocu0yd4v4sIoc4DPmpoKqQwQuerolVG1fjs0V92oHZws0C3k7x3vslfDfCvHxMMWryv0vWc6t6PYC3MX4y79w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7816.namprd10.prod.outlook.com (2603:10b6:806:3a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.20; Mon, 17 Nov
 2025 10:18:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 10:18:32 +0000
Date: Mon, 17 Nov 2025 10:18:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sourabh Jain <sourabhjain@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Donet Tom <donettom@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH v2] mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb
Message-ID: <a85680e1-ca01-4e50-ab16-2544480b85d8@lucifer.local>
References: <20251114214920.2550676-1-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114214920.2550676-1-david@kernel.org>
X-ClientProxiedBy: LO4P123CA0341.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: 609ff2ba-ec10-4251-83ed-08de25c2a937
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+9Q21kQN368Go+uT/PW6/FD7AiS6tfgXjdZp/2HOdU9sP4EZ0Vxi825by9T4?=
 =?us-ascii?Q?FKai4vKNvx8rut3cwcMigk1tjhS4IpNR6qlqbwPpDP1tm6MtSghltSzbyATN?=
 =?us-ascii?Q?JhscqOP6RWve+78hEhbwoBCUbBTrI1cQt9vkLcTewgn12kUzgXimH8kORZVt?=
 =?us-ascii?Q?GPN2DiyLlqAMI7GfUwGeVkmaBG4mJLxifO+ycgWgNC26ICyJtVVFTWUYdnJo?=
 =?us-ascii?Q?B5p9Lz0d52GQvfUxp3asujZ3C81y6DIH1Ry/GDFiz/9epPIJAd0Z8iGM/hxD?=
 =?us-ascii?Q?2Rp+cEGTlslyGKPmQRWYFgn2lxTNhm6CV1Gfm8z56/hotOU4nAOPEPNVfqE3?=
 =?us-ascii?Q?CEtl2LHy9d1UL1iapas50jjK76+L2qPGsmCcfnoU7tQahXUOmgQ5pnfh6U8h?=
 =?us-ascii?Q?s7lehztPKKAZDZInTlGpNdt8dICzvAu5sG+QMcLRxa/ILVM0XnoD1lKneEnQ?=
 =?us-ascii?Q?Qu0ygN5piUcO2byKmLLgjlkbYYGAtDyAAdvbL/tS8/iFAk5BjWZuKWKnrRv9?=
 =?us-ascii?Q?kJO2gaxc0RY65df2n744gRoi36cMMYlIlR+j3qJsnDTm6l/LVNFnHzLY2fY6?=
 =?us-ascii?Q?raBIbzzVyWYsJQ/l2Vn1RoXXngjFYZzJQRzT+RqhYN25yyHPRwt1EMk19srM?=
 =?us-ascii?Q?WmHhk4uyvY8oumQAC18la0fbH7gFsmNuMR3MaSaPdVLd5B5l0MH3LWdnS5cL?=
 =?us-ascii?Q?W9Ytd2FDbczA9PzGqJeUzNROxzG2ILT1iNONEu29/T4N3E1mp23Kel3JcTvV?=
 =?us-ascii?Q?EK2cc76wAiB/Zkpgd01/0TUUogQKSfvyAmCXBNwXwAyX0dsREjXZE1/hVyFm?=
 =?us-ascii?Q?qFjVLICiGrV8QzJjhCknBElNIcxlWuQqwjzU4F3bYaWrPjLKalEHSWNEtiyW?=
 =?us-ascii?Q?6uGYIP2pAzdnnVLAyn+GvDJJL+6+DrAIbHidEbmFHfyBcPddb7Z41aHmELfB?=
 =?us-ascii?Q?/0Zj0m2TOLak5Zl1ZHHd11cJ2qSDtXL4vRFtgqreBTv5sCdkTj8EzqbWnl0c?=
 =?us-ascii?Q?sRbVkzPRfXqMk/yyKCdVj2Q+owfc2vM4J/J982wxtwJzC0CZ7WtouKxAPuUX?=
 =?us-ascii?Q?/pGCEnnr2Su2+gPkRNc5/OyfE20tZPlU0THIy2Mep1E8l48XZfeUF6MnXPMX?=
 =?us-ascii?Q?O7QUPes5+YI2PdaezSpAl2sF9lDN+CTiy/P+FTKkYF89eoROXLHrcbiUswE7?=
 =?us-ascii?Q?T0h6rLYWMHe5VmNaLlwnDmUfEwBTH0FsarpxHHQzdAJlXRtrW/yTN5X15dpt?=
 =?us-ascii?Q?mdo0RETM/BiwDcnGifzF04+6Fukjho6syfqEjXoQAmJlqtVpE0Zq3QPFFkj9?=
 =?us-ascii?Q?SeyDt7s8HVkgcQImDyzrx/Hmbfzv5DYav4XWlzVTKf4X7xViYYqcHNI0+daq?=
 =?us-ascii?Q?QHzfmq5xJzYpkWInmK8hsquVIj0h35zzIto6raZvwvzvD+bbpwT9hkM4yvrD?=
 =?us-ascii?Q?czM7rRSzhrJfWQIOTbQ9MGpcawzEwkR0ehxNm8S112sMMcxWM3VUhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z4mTxDtrVdu3fidKtFBoYRsFjZV/Sm9uiexbInh8UpRL8e8U0AkMyhTYKHmj?=
 =?us-ascii?Q?ayRsfVHzuKr9+HHSCH1vpki9pug/wg7GkzsLqELQbeVdV1fQ6O7TYCpgTs/u?=
 =?us-ascii?Q?SUibcsahv9yfT/kMjMABiW8wDmLzQIfYV/AF6UtNqBd+ZvP6YmH0018JYIu5?=
 =?us-ascii?Q?N6VUGP6hM8tCAqW6uaCJB/5JyDfFOpfjHHqOQVCkZjTONQ4dVFsBoyRBxf3f?=
 =?us-ascii?Q?fFD2mhL0GBHW5Lhk0+IJNChbqAYpxAN+U3bljD9INl+1Ne8TipoVU0cYkxzu?=
 =?us-ascii?Q?pJUHXWOldfHnGl1moyQspz2ml5pNJJoODOTNdosDmhalXA1m//Y1fvDjozfe?=
 =?us-ascii?Q?UGD9gLX5XLYr4NlGY31WAwqaQWzo5ofzb2kvPKYSyKyr5ffYGA9sSQ4kUZs/?=
 =?us-ascii?Q?XO/GJ+VdmGIdG5ej1Ij8AiCEo4ULbGVyRe0GU6+6Avx18W1xhqpu4PCReaXC?=
 =?us-ascii?Q?Ukt489v9V1jebjVFovgTdHnfyanrrk3aOJOdVurqKADOC3rWBBoZYopU26sP?=
 =?us-ascii?Q?JJKNPbeMgQNOMXM24222ik6zr0/BBNWZpTs9kVKZ/wyjZEJPjdqxl1Cd+mGt?=
 =?us-ascii?Q?1yZjt/4KuyHg1+CaO5ryX5ZCEdP/dBR9F4jjefahKVO3nEUqhnRutYYL8LC4?=
 =?us-ascii?Q?nVnZNX+6NWxVowhdPf2YUQmetOfOhv4B+oQr+LMv4y6OXdSJFGPhkClhzLRN?=
 =?us-ascii?Q?llz5y2CVmWDZ4864KIchpSVBVPN6P7yk7DJw6RawYKP7kiTXrTpTHMveIaNE?=
 =?us-ascii?Q?WITIZ0Kqcd/dsXyvCqlaw4wm7TIMRHey/NN5p1y1fzi4J+CQO/GY5TU6JJ/9?=
 =?us-ascii?Q?oMj/xMfsyuGXRaX/TWLGSgJp8MLnTk79vZU4nKr4C18/Z3udz3kIyuAmVYR1?=
 =?us-ascii?Q?qyGvh3dx5k2I+gUQsnGHm+kY6BxCun0kb+JPaBA6nakVLwsnP6M+Q0BPiRrj?=
 =?us-ascii?Q?00vWEnpnVu2nnmjjzVqaKf8Pvp5Zo1sTw94P+rtvsEqTL2kORz/xOXl3h+vC?=
 =?us-ascii?Q?ccUfvVghPb17evHAZ8XsfNCafbDMzmn1hTOvpBLA9pOhfgVBmKL0EZAVa5iR?=
 =?us-ascii?Q?KSO+G31Bc/BF1PHf92RFg7WJEyVJC289OTb6kxIsCSL/mRemec23Y1rgIpjq?=
 =?us-ascii?Q?dXb9jT6E/ez7+FtW3rnzWaggerFxY0KQsSuwJgSX1R0hfQtqOhpf23OM4LZ8?=
 =?us-ascii?Q?DBrCa5FPoVhCRccZxDxgaHMQSd80Wu66qk2LpEnkmEp1y8MZcKrruMxZrvTs?=
 =?us-ascii?Q?3FrP7+yLuwf2796M1dEsh7VpVlrn78guzx0ddG/m8fKQiWAAEqh6YEvA26C/?=
 =?us-ascii?Q?APfFErzSL3wxypHsJtZxZKQZ9AcM2SUyHmCdDM8Dx4IxWNLa/Fbs/JQR6Iuj?=
 =?us-ascii?Q?+IsRis9DuIRjNkpO7gTfoUqqf2twyLEvMDsyk65Zv8VYYyC0k+2yHeH6vcH2?=
 =?us-ascii?Q?kP/VyOKVHKxFvQIxmFyU+P9MbF2Gzw9r0blG5TCSdRxWhz4kxoUFIVam2l/r?=
 =?us-ascii?Q?8RbyabFPhxEA5zQAc2JdmH+iFB3FqqVhJsumOoin43ygPps6+thwbCHstu3d?=
 =?us-ascii?Q?n3rTnFCAwhTe1QHFY79R/1EYZ1LLLqMAt9SwRrT+65E8s4Na+H9NOstLGayO?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vs1fLFV7wcl+FKHwG6d1lTNhDFgEKlNebfiLXvx+LIiM3wibK5JWWxpWToT1F9gjmNVo+fI/T5GSHEIpgsGha/tQ5GXCx9H5jreE9PkamgMr5zmVDNhzbCvE4huISjh7i1NWtv/eHNx39fPaOzZ7CPZlSvJEnpGlE6QRdZsxAXvJOyc48fWAunKNOYDIqwnms/FmTbh7vDAPi1ypxuU5nWYZEjQ0ANcT9boS42xG0AgCXkYJ6YOxxrqU8+w7xOJQC4Awkq12dYK43ibtiAI0GJZ5/vGo44iPgjqtlqiovonFzr76rger13RRrDJevvBH5WSacvSrr8+O1XhyTnHBxZ4rdMIAhgZ5SjhM1XMm45NgQL5aoM2JpNnEdNB0VWI06qtFaiDCWwLYPW4xdpGUzR1FfBt6uzKHwGJPnLZJME0/06NAkKxKxyhTnKvIabt8IKv6Os6gN837cJxXt+MmYC5CUTObLzAKjLGMMXtD0yP/fN7svVH/cIYXs6TMOEisoenKmSN0F0W/GrbUH6G1WGpUZK9OPrn6h1E7UXwb9ang/+Ec0SDr0y1Jg9ymbo8ckyGf+vFSJlkIBq/mB736Omn6WbYfhM4tbShJDRkpcaA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609ff2ba-ec10-4251-83ed-08de25c2a937
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 10:18:32.9375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySAc1QaZ5Z/rFHeX7y+Z/b44THE5EJJmFkGfJ9w9M2w/Bo5WIjwFd/HHYgqHQ3LMx2mdX7T1vaAF4sNklJ1G5U0QzCVB4wia9nhakPJKmnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7816
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_02,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511170087
X-Proofpoint-ORIG-GUID: oNJHwxgAvoN0PEF0XJG3AD4XjVw-F0si
X-Proofpoint-GUID: oNJHwxgAvoN0PEF0XJG3AD4XjVw-F0si
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691af67e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1UX6Do5GAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8
 a=_5h0iVJzMp2VppeC0vEA:9 a=CjuIK1q_8ugA:10 a=Et2XPkok5AAZYJIKzHr1:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22 cc=ntf awl=host:12098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX1OGsv8hhCZ0K
 7p0S4PZ4JRK/cG0r1JuVvkVM0gs7zFINh0P4BIeuvGSOFTDYvEuEHMvX547jLY0Kr90bEIaBL4T
 pdJR2oQ1jGErmBXap1Gq2mvGxHoNNsm37FG858lTRbnHw/JV1WYNr0a00ZgrogeM28P9h56XWy6
 SqZ3Bm2LYHddC4HeiMeXPpeLh4eBcp2pVIbwBCW7AES2Hb1G9lvMyDh0Fc+Mp3TOIXX1GbrUsyg
 r6c+PPHRwfLvBEEEqb2QcLp/WogwGSOaWdZK9QEnUSEO/frnDr6EclzWEpOam74czINEc9ZqsEq
 aSx+Oih4xxpsaHZe1PewRdDXvEh4qq08pVYTrnkhcmMfnwp/fYn2xqWVdR7SoKbv5l0XbGUWevq
 buz896Wwjf/pwNnf+Ys/XsostAN3L9gyJtxUBHtyKXfVXdbF2hs=
X-Stat-Signature: fkbocmf6zasm8kznk5q9uscntu55fj1s
X-Rspam-User: 
X-Rspamd-Queue-Id: F1E894000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763374733-367845
X-HE-Meta: U2FsdGVkX1/krE27ZFY2KDW/97M5VPU387bdTCeMJ2xqTm64FpLBp0tEVKEGyz9OX4lyl/yI3W4+vYibJeXHzjDeTe29oiRiWvQ4AIim2DAWP+aC/4K7cGIJxs4MBkchDG77+OBn4YdReqeIgJ91Dwviq9ZEVccvu/ZEWKI9hUUoBhH7xddEOzuHB/XVBy7VtDXC5Oj86ZOmptgsdALn1FtpKE7wtMA/3Y/Qbr0q9SMWcdeu9ZrSMcbVjbTIGjMA1tS11aGQZaPSaJFn1owgry5zWYYTh6oX8KxOPscYYLQfCm971cRyaJl21JK36srOjxOJWk8TP5HjVMAA7VnEPMNRCkHlzpZF7z52RcIjwdoDfLEmxH8qt+Jpox4Ie43BGDf4uHzjpi34RSbWGNezjuCtq8LDhqv0IHGQml7syRXLtPd7ZTg1H0qTDrabqcxejOo9laxkKOdGJGFMcEPZcqCEvWBdaEdt45No1BC3yZwQegI7etr59xdQwpZ2yudR6ZZr01iwgWBFN3mtT0/mzZoJiKwJBxsYajgj5652Cy5NtPFE//+QLUldmy1uFToJ2teupMy8OyMbdAjMAo+lqXwfSKd8v+iTmg01WdwSSgVQc74qtx9t35c64AsVj4kZsGmfaa03SiGgWlmprKBg4UQJ94C1R5Xy9XDtmNx0CyRAbelXdPIr83wrcfNSwWDZcJ6Jur1d5vRIbJdB+xGYFG3ATCsXIY8T2MdE23dmy5Smf+BBMvNsdVD5nypExiK2qS0Y1YHHhPWBMWrbizr929NA24vxr5TyMuVaplJK/iiRQgNBNotEYKPgPaUNrHuYahhBvXKU+AKcvK4idiicx6MLlXhW1afLoRco0AbNUWQVhFJIdBhgMeKv1MN/h3SgFLa/Zx1kzFTmAYIpajD5KFCr3Ia+LW/SUACMRF5aJahw6k1E5DJqx5/3u9oxvfar5EtwiHGJ9xrHLU4eW0i
 6CmcgrML
 7Fhhrdf1+FrScrgSjqlyc9C+5cYMQYRlJuao2SvHJ64j89G6BuWTW16Fax2tVEYd0L6eGBUEc5pIAfT4Ma3Xzix+avB7KTL1Fk7B4IsI1cltxuWzU36V/D17Nh21uOUA+n+1QK2j4o+vxP9TgjEW+t3VwbRdOvLp2Oo9wMu/rlocRIlBLB+OOP+Nidb3gB8nLUirHlCsvl5l4EMmeH3cPFKOBHUvgt0XLEL6NpviSCzKJHhuldTH5mHVSUjNb7kOdwFJ0UQ9Y6mt0D8I5/xN6xLKYrc/Ufj5qHAARot5+WwYG5HpgnEIh8fcbbg2If0egnZ0iU54N5iENXUrvgykSlBSs5bxiBa9hZ5wAYVd9Uzgi1sB5yYiKSuVGKoO+ojbhMyTKNcgLMyPZOj2yg1C13iDc7HG/uQgldec88bsb2dp3Bdz8HQWsPNdRB5VTH1kfS7fgHoVPVXPJJvpGsAxKNfZoTTeAkp6rtmXe44qPCA4KMGEnWmp9bbX6EpUGR8eYVzW913MoZI2N6hlrsp4Xeckv4AtvJUFV5mh1MyV2kCvz6pKc8NSdmUvy+Z0S3oI7sgb3Oz6/pVrWFr6UVIZhuC/mHacuj/q7Icj6OPHL86iTiIs4TYz56vNtHHdbvJN8wJTJSRiI1N/ZJgC7xjtnnQ04mDZ+pOo6N9Qww/UsVqU7IgZXyNfpdhkT3eMIH0DxYuLKYs/iejghPCvTwdvsLQJtXn7/yZdQAYFzqqKVu1u2cISk9MEDoT3buoO2pc8hkbVHim5ii2YDRQI+yHO2finyGV1N2mZ23LQn2g4XcbI5fw8VMo08jdZrBCI71PCPVOR9hdIrbTuooQnB/A1ONWoCAaMhL3Wa/At35RAnMOIIp8lP1CKYwTpJUy4OG3DBtsxv++D4XEgNaR4xABggtxYxmj07HVgIpUTeOh0Do11dZh9wZd7W6ck9/FtVZ1YWRyIZ/cqRzjodkiGno2INASErmXP1
 SZu+fhUL
 PSX47jbFb7/wMM1qUxHZiN0NvZbKVXXbo488jSSvuQCYt8GL7Wxk6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 10:49:20PM +0100, David Hildenbrand (Red Hat) wrote:
> In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
> runtime allocation of gigantic hugetlb folios. In the meantime it evolved
> into a generic way for the architecture to state that it supports
> gigantic hugetlb folios.
>
> In commit fae7d834c43c ("mm: add __dump_folio()") we started using
> CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could
> have folios larger than what the buddy can handle. In the context of
> that commit, we started using MAX_FOLIO_ORDER to detect page corruptions
> when dumping tail pages of folios. Before that commit, we assumed that
> we cannot have folios larger than the highest buddy order, which was
> obviously wrong.
>
> In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
> when registering hstate"), we used MAX_FOLIO_ORDER to detect
> inconsistencies, and in fact, we found some now.
>
> Powerpc allows for configs that can allocate gigantic folio during boot
> (not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
> exceed PUD_ORDER.
>
> To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
> hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
> GiB on 64bit (possible on arm64 and powerpc) and 1 GiB on 32 bit (powerpc).
> Note that on some powerpc configurations, whether we actually have gigantic
> pages depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
> nothing really problematic about setting it unconditionally: we just try to
> keep the value small so we can better detect problems in __dump_folio()
> and inconsistencies around the expected largest folio in the system.
>
> Ideally, we'd have a better way to obtain the maximum hugetlb folio size
> and detect ourselves whether we really end up with gigantic folios. Let's
> defer bigger changes and fix the warnings first.
>
> While at it, handle gigantic DAX folios more clearly: DAX can only
> end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.
>
> Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
> clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
> HUGETLB_PAGE.
>
> Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
> also allow for runtime allocations of folios in some more powerpc configs.
> I don't think this is a problem, but if it is we could handle it through
> __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.
>
> While __dump_page()/__dump_folio was also problematic (not handling dumping
> of tail pages of such gigantic folios correctly), it doesn't seem
> critical enough to mark it as a fix.
>
> Fixes: 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when registering hstate")
> Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Closes: https://lore.kernel.org/r/3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu/
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/r/94377f5c-d4f0-4c0f-b0f6-5bf1cd7305b1@linux.ibm.com/
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

LGTM from a general point of view, obviously dependent on PPC guys confirming in
general :) So:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>
> v1 -> v2:
> * Adjust patch description (typo, 16G vs 1G)
> * Remove ARCH_HAS_GIGANTIC_PAGE from arch/powerpc/platforms/Kconfig.cputype
> * Mention CONFIG_HAVE_GIGANTIC_FOLIOS in comment
> * Use 1 GiB on 32bit to avoid unsigned-long capacity issues
>
> I yet have to boot-test this on 32bit powerpc. Something for Monday.
>
> ---
>  arch/powerpc/Kconfig                   |  1 +
>  arch/powerpc/platforms/Kconfig.cputype |  1 -
>  include/linux/mm.h                     | 13 ++++++++++---
>  mm/Kconfig                             |  7 +++++++
>  4 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index e24f4d88885ae..9537a61ebae02 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -137,6 +137,7 @@ config PPC
>  	select ARCH_HAS_DMA_OPS			if PPC64
>  	select ARCH_HAS_FORTIFY_SOURCE
>  	select ARCH_HAS_GCOV_PROFILE_ALL
> +	select ARCH_HAS_GIGANTIC_PAGE		if ARCH_SUPPORTS_HUGETLBFS
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
>  	select ARCH_HAS_MEMBARRIER_CALLBACKS
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 7b527d18aa5ee..4c321a8ea8965 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -423,7 +423,6 @@ config PPC_64S_HASH_MMU
>  config PPC_RADIX_MMU
>  	bool "Radix MMU Support"
>  	depends on PPC_BOOK3S_64
> -	select ARCH_HAS_GIGANTIC_PAGE
>  	default y
>  	help
>  	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32b..7c79b3369b82c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2074,7 +2074,7 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>  	return folio_large_nr_pages(folio);
>  }
>
> -#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
>  /*
>   * We don't expect any folios that exceed buddy sizes (and consequently
>   * memory sections).
> @@ -2087,10 +2087,17 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>   * pages are guaranteed to be contiguous.
>   */
>  #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> -#else
> +#elif defined(CONFIG_HUGETLB_PAGE)
>  /*
>   * There is no real limit on the folio size. We limit them to the maximum we
> - * currently expect (e.g., hugetlb, dax).
> + * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
> + * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
> + */
> +#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> +#else
> +/*
> + * Without hugetlb, gigantic folios that are bigger than a single PUD are
> + * currently impossible.
>   */
>  #define MAX_FOLIO_ORDER		PUD_ORDER
>  #endif
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0e26f4fc8717b..ca3f146bc7053 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -908,6 +908,13 @@ config PAGE_MAPCOUNT
>  config PGTABLE_HAS_HUGE_LEAVES
>  	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>
> +#
> +# We can end up creating gigantic folio.
> +#
> +config HAVE_GIGANTIC_FOLIOS
> +	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
> +		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> +
>  # TODO: Allow to be enabled without THP
>  config ARCH_SUPPORTS_HUGE_PFNMAP
>  	def_bool n
>
> base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
> --
> 2.51.0
>

