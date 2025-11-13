Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1324DCD6E4D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89B18E0009; Thu, 13 Nov 2025 08:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61168E0002; Thu, 13 Nov 2025 08:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28FD8E0009; Thu, 13 Nov 2025 08:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC2438E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:02:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8035912CE00
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:02:15 +0000 (UTC)
X-FDA: 84105597030.02.9A87C14
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 139B21A000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:02:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q1arBTdI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tPLaJUq+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763038932; a=rsa-sha256;
	cv=pass;
	b=UJnCoX4BnHRs8439tFNlNGsRFS62i9NzgDNBwat78aG5CGlrzHD3VGN7oPUFfDfvZnwBxV
	Spd4NxN1YBtt9nt1fcNxj2D4ptpJM+BdbY+ketpu1i9n+SvRxqbEThOyzK95G/1zhsZ7s3
	x9C3UVZqgbTKH8j+BQixGf7Tqw2e5mI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q1arBTdI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tPLaJUq+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763038932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHohONR3Bno+6oQ2UBiBcSgA1vz7vBNlKcdEjHbK1hU=;
	b=LpCpqMdqFdrXl3vHRTfYjl+ulpnKx3+A26pL9L9FLz8UIx8mAdm9QHlN9hdtxB4tHb3ioi
	aNeQRIeRd43tb8GN34ZbrLa/eJEUZxTpgEsqq1gNaigZ4mwpCswEG9jwIv327T+ziNQ4yY
	yBctTHF0mBtwISXH8aAUABbnLD0EVXQ=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADBdnW8023110;
	Thu, 13 Nov 2025 13:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EHohONR3Bno+6oQ2UB
	iBcSgA1vz7vBNlKcdEjHbK1hU=; b=q1arBTdI6Y5qm1pmlSxh5R0yEeiIeHR6So
	T60FUyYFtNfsQHbfYYxcErTulno4+KAu+bUEQYIfxWjY4MiAj4vbT9ab71YDxMar
	3f7wuA5p2kqJWcaWYoJR3C0fXUR/hTL36dOeaKjwkbrrs5n4Fxcut5ljFtTn3nk6
	BieWOgnFC17wnjQq3pgusmgvE6W5PiWSxh/ZH1d5enHvPeEUPwyIHAazCZdtAdos
	y+SB6+YuvSlb44iawZjCr7FQz4ib2dlqmCzoAmLTDH+4qyi6CDPpGTFK9jst1L6B
	fwOc99Tf+s3akJa6UkFSFR3yS5WtjsfOyqaufXQYutVkkDp1DfJA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqsqjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:01:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADBsvBR003108;
	Thu, 13 Nov 2025 13:01:49 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010045.outbound.protection.outlook.com [52.101.193.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vacmafp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:01:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=adLlDOU2myL7x0eUdAdRNHPYAIkU1RFW6ip+XfY9OIVeEdhRvFPQtQ6yAu/CxsoHp5UU1yi6w2XyE2+c+8Lgg4X58TeiCDriKots63A3xCdiYbJiC2o8aUGyXT0i2FEOMcheKM5Pz1aXDclfEQ0xn9wA0KtPGhbqNYjbmA8Patht45dS3AV5KO4KQKeNJ97GzxiTHdahWThRpN8jr7P20xwSIVeCGXVz2i4z7nq6Jm6Dl8HWphXUL+yy/5C6qLffLrostjzr+opCZC45HNbSpM6RC8zwP2g6UG7kr9ryLbHoEhNXwBwiMrHXD3cooDetU9gBWMjfqrEwDFcL2+t1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHohONR3Bno+6oQ2UBiBcSgA1vz7vBNlKcdEjHbK1hU=;
 b=AHmD9KnUjOYQmuR6nkJVVsdZwUxY7AJMqQvRrNSWgsivTi2ZXKOh2Ni8sXbwvZWjIi3Znt1wug2EjcVp8cH0pd9b2mcyjl7/agb9yREK1upEIT90lZNT4t5NVXnJPOsCFhOkrvRVuP9X1kPwonuRgWVi90SpR8XOqA8whiSYieKHZeYEiMkeGhAg074eiUBEnap33ygZAi/tRElHH/7xmPAMhDIIFNlBtq+4VnwzD+iWdTnl8Box4QPKrqNoKDC8l6zVmnMzA+E7kmdq4DQbhk3w8CNu8NUwuT7x9C2+YBe5Zf8eppOSM+IkTQ8qRLDbUchJBaRgtzgubZ5bAWZ/fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHohONR3Bno+6oQ2UBiBcSgA1vz7vBNlKcdEjHbK1hU=;
 b=tPLaJUq+bZ559kbieBgJwjoy4BLs4zjd9gMHgy1zMsfrR0mtBwCUExow9Kfr/XvyzM5VWtaaJKFz7YeXsqzXDJK/KNeYbsagooz0XPp27lEHt1DYNCVB6hQj09R4EPszVQJfp3sJdR21RBO6CoRYrbKuZSy2TCoCj+OTwIapvhQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7857.namprd10.prod.outlook.com (2603:10b6:a03:56f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 13:01:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 13:01:45 +0000
Date: Thu, 13 Nov 2025 13:01:42 +0000
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
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v1] mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb
Message-ID: <eaf2e733-f967-43bb-88e6-7876a28a370c@lucifer.local>
References: <20251112145632.508687-1-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112145632.508687-1-david@kernel.org>
X-ClientProxiedBy: LO4P123CA0227.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f6c9e3c-318d-40ca-0f0f-08de22b4cc5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dGRj13HGi3LZJC3FhmRlAughOv+4ztNkkscJOUUoxUqOZhfjCas0D9/x9/vT?=
 =?us-ascii?Q?rUJQ4n+H6LkuQVtOnS7vDVpULmM8nq2I3n3aO4OkTwHTdy1novwBJsC2ZBB3?=
 =?us-ascii?Q?7whkQS4wN+vu2fzmv+mX5T0ClWMdiWE9zkf3iATuqLDGyPLiIw4apTQtVJxX?=
 =?us-ascii?Q?doQFsMK+SAuDvGFCBnkqlZW+yIK4Y1F4fwO5q1wkaimD5mYY6VW8Ln90ouu2?=
 =?us-ascii?Q?orGqjnzjYw6mQborxuAoKvvJwP4ShcIILQW6xvTqnempOW7OZ8577111sw3t?=
 =?us-ascii?Q?ZgqQN/3/ZesSI4e5jWgTDKJjbc8+lU1FjzcBKL2s7DMquZTZp1UIuyvXF/gc?=
 =?us-ascii?Q?avKIjy4ApvtScGlOjL8632gsmvLNs2r5vItPGiUFmKF0DoCG/tffR2e3arjG?=
 =?us-ascii?Q?NguEnJMbbriJNKjhMYLv5hZq3j2YyD3CkkIMHsOnaQzcRMuiPEYLES0LP/2N?=
 =?us-ascii?Q?SfOZsU6dISbYh2tRNEU8WVH8QVNN3NkE3O4a2nNEJeCdkWHeGhHTgm6lMih3?=
 =?us-ascii?Q?OsU/XNTtlGIhcAdRObSaf7axH2JUmnwXH+1usnP2zv6UPq/EbZ7sxxY5PRpc?=
 =?us-ascii?Q?BH+Ab1vzV0+x3jZmgZ4zf0yyQv1aXvaZGL5S+bfYtScBTFPbLOTwFCwiJCcf?=
 =?us-ascii?Q?6Yr0J61GQLVa8sfQstmIgzcWeQLaKEL7l+CGdHQwumFc9bWlgJ06izQN1Apo?=
 =?us-ascii?Q?5fMKFrL2eFbTONTSgX1xzA+umwpQ7bbkSEnx/xgWSDybsug2vqNYMOD3pDuC?=
 =?us-ascii?Q?XIgdlW6zK61ycrVpWINCs5wwUd1+LfjbFo5vbXYT5G1OhhSmpbjzdbdht6VR?=
 =?us-ascii?Q?KqoXs6uISoBu008t20PgeqPufR28JJh/g4+adrN8d8I8D3rMLg6NryZ+yZr+?=
 =?us-ascii?Q?Ae+69ghyA69YbE+pWnMo86nxb8d/Tapy+Tg+LP5j1KPX23AihKIsrsmLXnDD?=
 =?us-ascii?Q?JBVTPNAJsDzwzZg5AdmipQlYA+kl35C/ZRWrIgKtiCQDT6srt8OUmPkyv/rY?=
 =?us-ascii?Q?z0JIRZp6Abiz9DJJ530/oZKkl0NGVHgpFmlrEO/Nh6ZBvxhUM6sEC+0Er+zr?=
 =?us-ascii?Q?muHFJg2EXnqbiIiugAovKVFwjDVVMSgHWqQ8p0WMTn/oNk9SEgWe2fXTBuYU?=
 =?us-ascii?Q?cg5jmyQerpjyiV9MAvYxxbc8+ueLIHGH7l2XkMHKhvJwYcy0red1OMEUuk/8?=
 =?us-ascii?Q?eeLYeNxvBujcZr83KmJPBzCWWTR/Ks8pb3pzN/RyIhAc3tg37xvCYp4NUPa6?=
 =?us-ascii?Q?9An2G0Omy02hYjo/Qz64WgG2dqRq+dNjARJn2VFQe15nPj1CRJK8rMvQNqP6?=
 =?us-ascii?Q?q90F7Vj5Pa4G1szpRFQkEO0t9IJ4MtaH5ZjjKypje0To5WSfiAXFC353SLk/?=
 =?us-ascii?Q?yu3GAhD3QUpvF1zPN+BacSFadoG0nLPUZJv53hvDiaz+6NkyHWJ06i2aMYM3?=
 =?us-ascii?Q?gB0L2QyZ8MA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1krif+UMqcyME1Ms+9Xi2yQL8wdogY6CCvNrzVdfp5zq++I4ZqtyxSNqO1/Y?=
 =?us-ascii?Q?Ik4JnS6e3/QIq3km6rwXLJ42pAQOW5TffFc5w+E7KjaZ6xcs8t4C6Bz0X+Dz?=
 =?us-ascii?Q?RHv+VPL2xRZvX1TVG85K2sYF1ZTvzIgIsQAET0sSDU1lQEBOIkg8it6zwuhP?=
 =?us-ascii?Q?eR+jjj+c4OUoxwcnTX1Oq351QJO9E15ati7m7Flb46cj+/b+jxPssxooLOkS?=
 =?us-ascii?Q?2yS+2Epc2z/7pw4NJR3YNI71yuknlNk03e/QgPalQF7FBxXiKdjYN3KFvukj?=
 =?us-ascii?Q?3TMakZnZ8x1n/gbEtugWDwIrjOZCZ4rvqUK5sgXfCJ5GaQjIu2tbZ9yHky/T?=
 =?us-ascii?Q?FYU2xfljk5kzd2EVbu/B8BIvgc5JgrSCLZcH2AiE4u89d3/toX5aeIJE/gtz?=
 =?us-ascii?Q?iVdGmpRbgyUrm67Q83bqHRKP22ruqOLA7vRAREvcxcqkR3lcjZOfK9i2sHxQ?=
 =?us-ascii?Q?TB6h13mqJ+SHDGR9Zt7AYmvZOrJtsXcI/DLoJ66iRmyQyQMwbR2vl4rZUOlI?=
 =?us-ascii?Q?gRXXIpKp7HXg8LAWv/FSh4J5KjmJMO5PlXpUvXoP/xCfcGhtk+pkBE3bqwZS?=
 =?us-ascii?Q?DBHGJoyLDHWC8GO5b6lFAv/kAK1cR2YvMzstsC6NXKFycAtOIr3gLHAnXY3t?=
 =?us-ascii?Q?gSRhr9ct1SxqeDnIgBlRybw1+N5Lk4dwxJs+xhTaNWUZmkbbuLDUBveHFZh0?=
 =?us-ascii?Q?itxNUR9WttUZfsab6bRPxWaqk/4G8trq5z+aqdCYAuqbFlkfDkWKTiJiRwb4?=
 =?us-ascii?Q?e/uUXoV1BkY9i85R+SGbt4NgLgIMjncemtfixSgAqbZ/UTswrUHRfc/4VgSq?=
 =?us-ascii?Q?zLKw165dpWNJp+wvhaoeY1lz+qGJCsM0PZNaOYj6AhGmPEsSGd9k+2Fwi2aT?=
 =?us-ascii?Q?oRe4u0aCpkfTkhjUG65XdFZoUWiYQgrIPIIoE5EgrIqryexv8OCZw0Tq7cJq?=
 =?us-ascii?Q?e0S6Mlebc0XNmxHUnE1ugp5YGNceL8X7iQWVGACOCdZNgOqb4AlfvIR4feZZ?=
 =?us-ascii?Q?pRA32x/mJwZk6LuWzFtYOc4IpFV0WqM8apGCsGyc+Q1AyGc9YzM43xfmDch+?=
 =?us-ascii?Q?yY0pCkW31mBCWhO9FhP3SjdqydxW8N6Mw9h/jCI5xnlzdDepOcJq/dQ5/M6n?=
 =?us-ascii?Q?Tk5bpaeWdpZ8QrygwGMeRdQcFKIP7QFOrWuD2YMZyYc7+hZi64ODspydgwCS?=
 =?us-ascii?Q?VSqYbv+1fNrplq2hvORcamRKLlFLV0Zvm7Fi4iZCpEHPMe69MDlurqc+ul5f?=
 =?us-ascii?Q?fE5Jw32dWk3ZqviIqax4Xmun7RmG0iVTwJzJy9eV6nqg7uAm0az6gVnsrmUs?=
 =?us-ascii?Q?ve1RVS3kedZ3jL2gU1eRf0U5MCACc2ZWa5rOeIqqOFMNa//a7UGo2Bc/2E6U?=
 =?us-ascii?Q?5LNoyc6ss75tFklQZNM9pH8Hc3WHYjH+rT2m0LFqN8QvB0qsqa1yfbcFUvmV?=
 =?us-ascii?Q?0veorK2dUPp2UADgEQuoxX6yc/+Y3kIzpY/5Bus/aeo/pkoLInIs6Js1p040?=
 =?us-ascii?Q?GDXTkI+/In1/Lkv8CV7rJQ2Xel0NM91UDWll5UsQk5Jk522jBcSfJzHetJ85?=
 =?us-ascii?Q?SsX509R6T0612zG2BwO/2QNpNfyu0TabtpoOMeiNhT7wfx8X8CvxuITfcVxF?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G0w0l7npcQYEO14Bprb8GYH9thEs6xP0MCuTFobpdyzkGnrczC8wXUC4BSvnGNHeyW5dbWF4k+GwZWAxMibWmNIslP7rEqH+PPMyh+x9zoAh92A6S1xuWq4tBgxe0lbM1mmFS1mqkHf8RfKXMCAjRJDHaEzhaMkPfONAPjSRedZpOYP+63fiI2AfTMs2yxle41simPAi++XLoG/TwLaMp4n38+drRheVXdsCCRH++cpBsvA78Q1WgBV3DTd0Rc+n2x1FtO2VXJrIOsfMPVe5kFVky9ow6ZDUSuqDccOXJrq7yGJOCaM9i4s4m9ftkgesJZDjH67+xWijXse7UKvHvdN9F8pSfcGFmi1y2AAN9asLJ4X14UGz24rspcLwDVWnFaR7kOzGXeEn2p5A4OU6P4x6RNHzyCpPfzpb38oyAbjabk/WExyH9FJ6yRUFe2NWp/8wubb7fhIkU5yIK/3Dm5opzH7+SLqN7J8zdyxeNyLFPsuNOLbGwZFFltgpej49jJHBhcusXobIysJrjlmy5L+Fmyf0pWwQNHMb6zk76X3SlTS7Cj3SVZyGduIMoaiOOoBT/QfizDRLkPG3APUO1cMZTWvz+bZ2A0upWS7ymqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6c9e3c-318d-40ca-0f0f-08de22b4cc5e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:01:45.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFJ4OonFw4Kep4NZnVYtxbuTt/BGHH1ueIILrzVZ2G19F2nqAN8QBJA+GDe8dYenefGM5b7WF4BoGkxpMhd2ZnUkfS0tvW3eR1uuqXDhAs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130098
X-Proofpoint-GUID: RbkxTKwQuChX0086mVCbHSRQtGSNJTKD
X-Proofpoint-ORIG-GUID: RbkxTKwQuChX0086mVCbHSRQtGSNJTKD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfXx+L3n/h8lAWx
 WJo3pF9eRpVjpcpbdhputSr5h9m1rQ6lbc7m0oY7RmiomR9jANidGROeYRAShzIKC4HwK8aOwX1
 AdlyFtZMEUsLY+w0deyGHpPrle4EKtn95NmJAMP6Rs63jBpLpbnYgP6MyR6GnNoGJl1yzsvZp0B
 5IISwOMYW+q2zWtzdfvlBk4y9Z1gWcyNzv3fx7jZT3d4N7CR4nVJdxSm0DTKi1xCUp6nyqsc8rn
 Ej2CMkko0QJWlU/SZTlJo36NgNkgIfhQG/itsBq0K21BruFk5NyESdVizatNrpgHw1khmpmgri5
 ENG/QizTHQLjHZy+o2yMrysT755mkADmN0eoqoZ7dyqyUa4N9pJofC+sUAX1ajv3wtjYLvHNpYV
 O0WcgjiMMIwUr8C1KhjqLJ7+sNvRDw==
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=6915d6be cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1UX6Do5GAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8
 a=uDd0VpAFM0u23N_P4iwA:9 a=CjuIK1q_8ugA:10 a=Et2XPkok5AAZYJIKzHr1:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 139B21A000A
X-Stat-Signature: 7zbnfaro8i7n9756tenha8r7qddpxs7k
X-HE-Tag: 1763038931-926442
X-HE-Meta: U2FsdGVkX1++pEWfeBmjo+sKB4q1PAxptz03JoTziQWIzCNrMAKuCWm+6+VbT+u6JZ4xqqbJzYki81OWrNIiyi3auExrLI45LqN5XcBqyE3HBWJtrX7BDTgZTCIqD/C7krSnLmQPzDyU/r/3ws7ZFppDVO/OEX0fSBaHH/QpMCrllu3560s/S6kntgnxXGIS83FhNa3/ae44XnZaR9mI5wOLd7EaOzUH6in9aU5AW04XDShLyyFixgmbSDjFZZntHVJNMGd7raoemla+aOl2te/RKLi4GKgJoNKjpzqfyNeFEO/T2sQr8DDtu7M3zS2CJtqu1fnalq18lfgUI1bRbFUL7/fYtMfRCOuRXIKOG97jsi1NhZqmQRutTOKzAGngzKPml8xNb5mHiqW7MelQDK3GxkkJzDYN4oiVruYG68s9XZoS/c3eYaOtVCIxVucEXljB5nNru4g2dLI3TDYL7Lkw92GlcsjwOUXfha9geuHwca5rx+ATLVtaKGxB5uEytwC3ftyM0ShOqMNv2n3ReKZhhJRg1MEc1bpsfEuioITVhAPilDttmsNomDVfRxeoRZxU7zXCRvyDYfNdO08FSxuyZ3IWquvo7vW8f95EMwpOPw2bwek1Imtp64YTEMN03UOfmcY2HTr0WbYMlS6HZwmZxuxJDtKsnFmHiJ5trfkoA5geymZax8nTPl4yaS6QMzMD8M1nimfqi69OTN+7NTfptBEubVKSEY3W0epZMXPg8cu8R3K9xDscJnzNpPYoDvjyZ2gORAZKaqz5cYhz1tQb0Iyyw5yGhP8f2qoFF+DRZUa1pV0/kAvbv5wOVC/aE8bJXsxDzk7cGns4NmtFJcBEb1p+jNoOHYibSrKFoxjdQble5UMCp7wVSo5gqbJ2qNNTuCFrKmfK9Rc6qZzQGhOjxTgvlagCVhRQGQrdVk0idQPi1abA4G4p/2NBexEPNzOfZnEN9CMnUQMFhgu
 +zRvt4cb
 1gCNVwq14yy42V/6D0/3y25FSYCXIDJB7XckX9m5VeO04sCkD3MvvrYc2+YO8bhGT+BPGWAtBwi//46mhlTerXUGOd/TAXQPnrVDTP31WjlOt8AjMXJkHp6/ib/XiM27gTC/hZX3M76zWnbjssB1x7kdLFhctkSIBQ1BM+OwMw9xPA89tLszevB/Oyp/gwlBDa+CVdrtx/ebARSB9nejCZFd7KJk6su5UeLXfYF77d6y5F4A2RJe74YZPiRmIxRcKV63nz8TToNGTc9bXjZKiPqdhMEcswuz8iJQz3FtmGYaqvnfyvv8ss2O7KCDAoboRMGAz/xmPSeYmWMoVSpDofP+3RorNzT905GXA25Iea5v4LDMtIQAxIUHYFiSIDw5Fc+6gh8sgeJEvYzM6GaWY5sabc+qP9Oz59kQyxHpzjf+Yo8G/1P0qav4hp9mjDu9P6BgPOiK76fxa4YR7QRVrseSRd2TQIGybXAIBjCzQNZae35zgn1GZBfIpgHTky2cDik6Ej+jShlhYSw9J99c717quv7eT2/T9bZum9wusnQiwcKAjrTigKgDURni5SB3rkFR2EJsG/VatVUC5tlz8qJNXKNOWwaxhmiL+PlX8sbnri8yJvz+sBMz8wChrw+tiAZwtbb9hwOkK/2LtKGhObrYK2O/l1jAsIQ1krj3x1z5lmYLM3tnv06OoW2BATp39q9F+u01YV99vJvGt3bnUmWkQSy0hViF1fQT3xZFsku8g76ssgdHKiEsucd6CLvst1LPwhNxgDPCb8XE83Ah/7Mi0aWxbdUsS4AV7VY724FZZXN120lukzevBmujmlR58hXBxkUQg9d1GK7bsokDt4oBe+n2j3eJ8VwD4vRuKm4mUefACFyFZVf1QMgVCuF2vUIxcx6xHgXvm0yg3CzfsNOfHR+55sxqpK13yyLsdhAvDxg0f5c+aHlAV+Us6bVudISVZatqPXt4pD/EbTXdOLtS2zJZI
 t9NgKV9f
 RgQP4od4z9zOjG8yYyxrwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FYI, trivial to fix but a conflict on mm/Kconfig for mm-new:

<<<<<<< HEAD
config ASYNC_KERNEL_PGTABLE_FREE
	def_bool n
=======
#
# We can end up creating gigantic folio.
#
config HAVE_GIGANTIC_FOLIOS
	def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
		 (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
>>>>>>> mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb

On Wed, Nov 12, 2025 at 03:56:32PM +0100, David Hildenbrand (Red Hat) wrote:
> In the past, CONFIG_ARCH_HAS_GIGANTIC_PAGE indicated that we support
> runtime allocation of gigantic hugetlb folios. In the meantime it evolved
> into a generic way for the architecture to state that it supports
> gigantic hugetlb folios.
>
> In commit fae7d834c43c ("mm: add __dump_folio()") we started using
> CONFIG_ARCH_HAS_GIGANTIC_PAGE to decide MAX_FOLIO_ORDER: whether we could

Hm strange commit to introduce this :)

> have folios larger than what the buddy can handle. In the context of
> that commit, we started using MAX_FOLIO_ORDER to detect page corruptions
> when dumping tail pages of folios. Before that commit, we assumed that
> we cannot have folios larger than the highest buddy order, which was
> obviously wrong.
>
> In commit 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes
> when registering hstate"), we used MAX_FOLIO_ORDER to detect
> inconsistencies, and in fact, we found some now.

Makes sense. And this is what the report bisects the issue to.

>
> Powerpc allows for configs that can allocate gigantic folio during boot
> (not at runtime), that do not set CONFIG_ARCH_HAS_GIGANTIC_PAGE and can
> exceed PUD_ORDER.

God...

>
> To fix it, let's make powerpc select CONFIG_ARCH_HAS_GIGANTIC_PAGE with
> hugetlb on powerpc, and increase the maximum folio size with hugetlb to 16
> GiB (possible on arm64 and powerpc). Note that on some powerpc

I guess this is due to 64 KiB base page possibilities. Fun :)

Will this cause powerpc to now support gigantic hugetlb pages when it didn't
before?

> configurations, whether we actually have gigantic pages
> depends on the setting of CONFIG_ARCH_FORCE_MAX_ORDER, but there is
> nothing really problematic about setting it unconditionally: we just try to
> keep the value small so we can better detect problems in __dump_folio()
> and inconsistencies around the expected largest folio in the system.
>
> Ideally, we'd have a better way to obtain the maximum hugetlb folio size
> and detect ourselves whether we really end up with gigantic folios. Let's
> defer bigger changes and fix the warnings first.

Right.

>
> While at it, handle gigantic DAX folios more clearly: DAX can only
> end up creating gigantic folios with HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

Yes, this is... quite something. Config implying gigantic THP possible but
actually only relevant to DAX...

>
> Add a new Kconfig option HAVE_GIGANTIC_FOLIOS to make both cases
> clearer. In particular, worry about ARCH_HAS_GIGANTIC_PAGE only with
> HUGETLB_PAGE.

Hm, I see:

config HUGETLB_PAGE
	def_bool HUGETLBFS
	select XARRAY_MULTI


Which means (unless I misunderstand Kconfig, very possible :) that this is
always set if HUGETLBFS is specified. Would it be clearer to just check for
CONFIG_HUGETLBFS?

>
> Note: with enabling CONFIG_ARCH_HAS_GIGANTIC_PAGE on powerpc, we will now
> also allow for runtime allocations of folios in some more powerpc configs.

Ah OK you're answering the above. I mean I don't think it'll be a problem
either.

> I don't think this is a problem, but if it is we could handle it through
> __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED.
>
> While __dump_page()/__dump_folio was also problematic (not handling dumping
> of tail pages of such gigantic folios correctly), it doesn't relevant
> critical enough to mark it as a fix.

Small typo 'it doesn't relevant critical enough' -> 'it doesn't seem
critical enough' perhaps? Doesn't really matter, only fixup if respin or
easy for Andrew to fix.

Are you planning to do follow ups then I guess?

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
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>  arch/powerpc/Kconfig |  1 +
>  include/linux/mm.h   | 12 +++++++++---
>  mm/Kconfig           |  7 +++++++
>  3 files changed, 17 insertions(+), 3 deletions(-)
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

Given we know the architecture can support it (presumably all powerpc
arches or all that can support hugetlbfs anyway?), this seems reasonable.

>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_KERNEL_FPU_SUPPORT	if PPC64 && PPC_FPU
>  	select ARCH_HAS_MEMBARRIER_CALLBACKS
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32b..63aea4b3fb5d9 100644
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
> @@ -2087,10 +2087,16 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
>   * pages are guaranteed to be contiguous.
>   */
>  #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> -#else
> +#elif defined(CONFIG_HUGETLB_PAGE)
>  /*
>   * There is no real limit on the folio size. We limit them to the maximum we
> - * currently expect (e.g., hugetlb, dax).
> + * currently expect: with hugetlb, we expect no folios larger than 16 GiB.

Maybe worth saying 'see CONFIG_HAVE_GIGANTIC_FOLIOS definition' or something?

> + */
> +#define MAX_FOLIO_ORDER		get_order(SZ_16G)

Hmm, is the base page size somehow runtime adjustable on powerpc? Why isn't
PUD_ORDER good enough here?

Or does powerpc have some way of getting 16 GiB gigantic pages even with 4
KiB base page size?

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

Maybe worth spelling out in a comment these two cases?

> +
>  # TODO: Allow to be enabled without THP
>  config ARCH_SUPPORTS_HUGE_PFNMAP
>  	def_bool n
> --
> 2.51.0
>

