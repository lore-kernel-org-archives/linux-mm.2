Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFF1CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 19:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24AE38E0006; Fri,  7 Nov 2025 14:12:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB368E0002; Fri,  7 Nov 2025 14:12:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09BC88E0006; Fri,  7 Nov 2025 14:12:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E92C08E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 14:12:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DA854BC04
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:12:57 +0000 (UTC)
X-FDA: 84084758394.10.65364DC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id D8E1710000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:12:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mvmV4fn0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OJyZ76Vo;
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762542774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wA9zj3hZvYfhB8OA5xfX+Wz/QUl6Tazxq7TLGsGGjDg=;
	b=3hFovT20pXygZJ0/ejdnHr9hlpRrwrl0PUlVM6GA0BNd7YaGINZK0XIyCfL7g3eJLzWf90
	M0ETS6o8CghnPF9A70mCiU6L1/cOc+F+BDc/UeaPD5qz9Ehz9eu8say8TqQZeguxgoliik
	UMN8ToRo1gLRRam9Gk/Sv0nPd3jeNLY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mvmV4fn0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OJyZ76Vo;
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762542774; a=rsa-sha256;
	cv=pass;
	b=f7XPdGn/CTQGa3lLYHDgK5Ak9ysNYapT+IfNIuZollK0ZoWDMjHTqo7+WeW8xAbFzanIc9
	xmq+GM0PflOwA6C1gG/gDrj629v8ERtLMKWbyikRXBttTlmMjPFPYf+XYmmUcCEJkd2Bs6
	6hTsARBe65WqSS5qFm1cYk/2uq0f0z4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7IVQwX029204;
	Fri, 7 Nov 2025 19:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wA9zj3hZvYfhB8OA5x
	fX+Wz/QUl6Tazxq7TLGsGGjDg=; b=mvmV4fn0AmuigZ1Hr9y8odXOtQhstXh6JG
	JSa6zeQm42/UR8/90XC0WtedAFBpgg0jQbBSHD/ZFwF0YIm74ZAudDWv7qCdOPwW
	q7g2E/8V5I1W1KpCWfk1qCTVcjPKbcamc/qMKQkvFti8SfaumNeTj0bUCLFPkSCX
	/W1w29PwlFuMGFNa+4kzI709DU5RVA9ZZ4m9ziEwSyqSK7VT2ByS/P+IUqec6oJp
	IHDkX42P74sZLCckZsHjXKpSgdk6fwq900T2ZAUvYA7Oaqjyprto5gRi4ENyXYrV
	qJhKPov+ZOWi+12+2bZe06goFjtTGzkTnc1aZ8fCKKEcH1wWO+Pg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9ngpr56c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 19:12:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7Hmr0s011077;
	Fri, 7 Nov 2025 19:12:46 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013030.outbound.protection.outlook.com [40.93.196.30])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ne5nm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 19:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i/ZWZLMnL/fvnbqv86jWrSXKfzKzMy6St/QVB8AkcBhpYGPNtxfxBjHaweovpnqH2KUyzckYRUPgodq7MzqoHhDkqkGIRWOSVw5khI1UoNQu2sw49jjLKfN7MZrDx2wAtPkTEdV/OBfjRxeZ6xVNy7d0eVmH5ubV4FdQI95kkjtGRUNpth8mQTRk++wEoUuGYP+uKMu97usCEgSrzTrGe8yQ7UVkmCGqvuXuCguxpqfOu43ZFGpCGajnVCedL8kWbx01vnAkcPPjK44ElqdvamueK0zrQZElsjNVqhMMVV2VG2orvO3hHFURHv69RtN4UUDJmmghbPzDHgboJO7CuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wA9zj3hZvYfhB8OA5xfX+Wz/QUl6Tazxq7TLGsGGjDg=;
 b=vzDaMh9QfJOOstSrPwhwaLwMlklIDIECy5Ao263i3XGfBXqGXb+KijVMe6WrFuGkD+QWiShkL/ZtogPvXKedbY7aJ1S6mzVmURU8B1LOGH5Np8dwr5fHaqkoPbXV+sEOahijY/HDz4t8GpmMv+Lmke433sgl0kFR1pG3+adMojJ+lZ+1JsIdnUwapEuesfFp1UaJNfWtQqGUM7wUn7ld2qN9Fe44HtsISZ7bFamr0bE6uWKC/9fcgy2cpI++SDc4C7TL0mPkt5QqrfkOUAQhgohf6kBy3LHLFNObxLb7+qGe7ojXSz4meqwDzw+P461WxGkYE1gCAAajdROy6cAfcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wA9zj3hZvYfhB8OA5xfX+Wz/QUl6Tazxq7TLGsGGjDg=;
 b=OJyZ76VojYXg6s4tbWu/evyusj6Sz9j6PvxXs1+Z9acsWCE4FyrI7I+C8Dtd/xoogiIz47yhTSmB5ekrfxTNjSCW0MOJUerfaA18d1pvMzxur+s36BRgEhhaiUhlwU4tdcJi+YMcyrv2riL6iw9vMN+SKY5zpqSfGi2G3gL8TcY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB6190.namprd10.prod.outlook.com (2603:10b6:930:32::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Fri, 7 Nov
 2025 19:12:43 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 19:12:43 +0000
Date: Fri, 7 Nov 2025 14:12:36 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
Subject: Re: [PATCH 2/2] mm: Use vma_start_write_killable() in dup_mmap()
Message-ID: <pyl2j34ra3ljcxv4woli7jqvm3k6fygitycvhsb2chsdgvqcza@ypcj373fhv62>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
References: <20251103180348.3368668-1-willy@infradead.org>
 <20251103180348.3368668-3-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103180348.3368668-3-willy@infradead.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YQBPR0101CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB6190:EE_
X-MS-Office365-Filtering-Correlation-Id: 372a4531-08ac-429c-05d5-08de1e31a093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6krOgCv5JNz/rgPc6GG2/EApFebUDS7TJ3QL0HzRCQQu5fFhzf0a/ZQS8JD4?=
 =?us-ascii?Q?0/0oteUK+TMwrn/SU7woCVp/YwK8Dq7Y7HsrVq/Sd2gXucGsGkX50VhZhVYP?=
 =?us-ascii?Q?+U3Tx/W2l+L/5iE8xt4TQPq2QWkw/CYdZbrVBqGLR/AaF91+Bh+Cy8MyBHc4?=
 =?us-ascii?Q?ihWFP46qkzmQyarQ9WY8Sme/PEJeZrNQtc0Y53rFCjiR08gUEAO04Sk37gpb?=
 =?us-ascii?Q?t1WviuyW3ec2IYRSHZDR2aFMK/EedjKM++NxonGHMm2DlEbWXfZLKNSN4KY4?=
 =?us-ascii?Q?qAw05XML3GX4HarwnsRaZtTYeBtZFJ5Ayb3RQItq+PAzUpmjtH1j9Ab6EGnh?=
 =?us-ascii?Q?Xd92tCG0bSfAvqZw+PziWjKdBM6crpdpXf70luLQjbwiU9PpAUMON+J44Xb1?=
 =?us-ascii?Q?BF7TsmbKs3W3eFYHe0WpxmJAxsurHjVi5TOCjfsI1dW1/itcwZRKVM77cpus?=
 =?us-ascii?Q?3hjnB2HhvzOOz5qop+uiCk+lvfUGvb6DHx5DsSEekalXyfIrrJJtV7muSwPI?=
 =?us-ascii?Q?1qJc+yBFWqz9SH72T1BB9sr4G6LgQDaL0/USF9WiCZ+XHPSsyEQMx03SP3Rs?=
 =?us-ascii?Q?4RvVjIetMsSoOD1FX54HK68gez7bE8tZ/y+pcC+XCk7EqF9wxy2RGSe/A34H?=
 =?us-ascii?Q?hD28XFJN3haq1DeuLnGZXbrN2Tl8Fw6nxQK+h8+ccPCiHUnQV5BCl/wVe692?=
 =?us-ascii?Q?G8PNNBx8LjzmWoXG7AZfHTz9rc5JqDfpGxmtHOB6dNsT7j2GU/NgkQQDfPoe?=
 =?us-ascii?Q?aN4bgn2rM3USYOUhVR0pr60O7Aj8JTFiaCLfy91sFHU++phnC6WIFxN59kgz?=
 =?us-ascii?Q?8V79REEuQeVV+UGe/mn7z6tTupArhyT5MN7IXdY70DTTPfP1aBEPr52HCeqP?=
 =?us-ascii?Q?oxzsvwf4djnNB4KjWtDRzX7Llh+nN0AAnjVGf1K0IxwB81nMc26aE3VFmVPB?=
 =?us-ascii?Q?dhgUCRRtsbxvVPH7RAdBlawLwU9qOZZHU9WiaZ9dvYME8lAdxZlAv0EEWASu?=
 =?us-ascii?Q?zFuGSc9Xe67hr7IqfOXlHwqqnEnB2CHZhwAJ9zrYUn7w3KRejd68Rm7oVQrN?=
 =?us-ascii?Q?bk38crP8F0Z4Jz0ShfOJgPjRqu6pf6qkHBJ5q3zD2O0HcBZT7mgH94wOOQ0j?=
 =?us-ascii?Q?RlvTh19aVT2o51ubaoGaF34vZSkmwKKFfQVALMzC5NfrNVOZWUMtg0fi2lfe?=
 =?us-ascii?Q?J82AclK+2tFWAMj+kv0PfUViB+vJ4pMWor+YQjamtP1TfdrUpxV03OHXPayI?=
 =?us-ascii?Q?Petn4AU19qWV3AVT0unRs3M3ISfPzvnEjFD9KsJ7Yzwrj2liiSjUSSzVweQW?=
 =?us-ascii?Q?qIZkZGO08l1L9jeOCw+uxBsmiMElqrh+R1T7he4J1kGP46kEr43H+rwheb6o?=
 =?us-ascii?Q?k7g3sMwLws49NTH8KSMwrBM2Vmb4OFMVDmFPi62orDESYeXE5qP1QjwLDyBv?=
 =?us-ascii?Q?zJ034xKPsGsAbTSmhKijaTbVGtAnm3rN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?04pJ/fbrsXkbgQITf/40UU8tGlXNgo7QOHaOfnG6VI3LimlrowrIQaFKwjQr?=
 =?us-ascii?Q?m9Hg4QODlH3/yoM6fZbGOAt10VJ1xlzZuKGGk1jsGtu6vvYkGBY27O3oBigo?=
 =?us-ascii?Q?se+ndMupfYqVYhz6M77qsMY77kJrt1aohw7xkqNonIND9qCQWon/uy5mzJ/9?=
 =?us-ascii?Q?KqvxqqNljlU1enw7g9gXLlfJfQhTgfyL0OKVGH4cr/BoMDD9/ojW+UZAOkcX?=
 =?us-ascii?Q?aSRr0U9YJgYpYPI5kZ19EaQOJnVuewN92eHl0nqLD+5skeC7sqOLmpBd73Fc?=
 =?us-ascii?Q?+vaCmEoKIemj5zyMjByZLGSKQaMs+wFniutG0e5EUKDXwUzzXfKA/xgVhCyW?=
 =?us-ascii?Q?+XUzbJYCMyemaSK0GQWa557zQyxTNWUcM9eX3RMRcneTMxIVSoBTF8xfqT4q?=
 =?us-ascii?Q?vyHpM3dDh8M0N22Vl9IBS3+/RpnqBRrnWTvSHS4XXOOlHcDCQhpZvpKwL+bG?=
 =?us-ascii?Q?6L/RdN2CjYnezzkWXsiLlCT6ilrO6EUOwCO+K89i0QOJiM9dkjpmu/mTsg/U?=
 =?us-ascii?Q?0o3hYZgge4cadTP6M8OXOa8ELM+m/idXg0QCv4BfFey0dIKR6qzxdqR0Y8Gy?=
 =?us-ascii?Q?qDnExKEIlPLHhTnXXuTM7FaJafmCOLbNd+2yBmCNnZU3eU8ctNxbq3GHJ2af?=
 =?us-ascii?Q?sWZC6R1LIJJnIhxLTiZwNRrLbz3Dz6QhZU7H+270Coi2MU5uFqlkD1NLS3it?=
 =?us-ascii?Q?8tNhuIoFExTZtWCUg2+E5v3Ukjjracr+tkuFnrBW2tRZqb9DE2Zt3C0iqbTf?=
 =?us-ascii?Q?d44e8FMk+AXEXgTbENgy7BYHmobYPO6/c3fH4o960XexdR3n+H2UTlomoiUk?=
 =?us-ascii?Q?zmDdOiVvnxHBL4vcVoyAEqOYP54Bx6n/MrsHAVDCgtbYeb9mHGdIbmsGs8Ey?=
 =?us-ascii?Q?FLUHj3BYiRiZ9Q8la8RCm/GAqwTxGR424DfbWfmuOAbQsY8nChvNehz6dpKS?=
 =?us-ascii?Q?KnuJgu0zySrkJCg/LP9ApHrpswHKqCnpSpNxxhtAV4/QZP+oeiK1tU/O4D7g?=
 =?us-ascii?Q?3IHChN6JDgCGKsi1BL0cqQG9jvt4cevR4rROQnxr+sK7FqhOORJoeyu5H5Ov?=
 =?us-ascii?Q?VEMfdWm1+Pv/RAqMiuVVqbISU6Ds7+KKWtf4oqp9c1+M+dg6IGljNhUNH4JE?=
 =?us-ascii?Q?c5koPTfsZNr5+MPK6bYAB9xK10SJp4xm4piY/qwpysddNvh90l7/3LZdYV/S?=
 =?us-ascii?Q?qw+RLiC1/3H9Y5all7ZtbqKgU5SwiCLKTf1R1VMS7drduPRT4ro4MW6YSrNb?=
 =?us-ascii?Q?eaHRZJn2VR/9aUR5BLR9dNbe4cIxQ+H7cvH7sbpy87gQpBFYwbo/ZWAgVMjw?=
 =?us-ascii?Q?nUf4qcXltnyBlNNr/fCfBcp9eH4wbpGihtS6MTP7P0k8+nLKtUV3+IMTOCaJ?=
 =?us-ascii?Q?fjL6Fv5kNMbKRPoQJ61TQT7PG8dm6+LgaUC7B/gUtX99acJgi3TphsOHXQRz?=
 =?us-ascii?Q?/5Ep89Ab6FezUhOdIZqeEQ3aubxM0bxWUE5kTFDRPAAAihyZT8CiNDCSZhem?=
 =?us-ascii?Q?FuGsa+HhCHun64P3tpXGQzh38FT6xONfJnrI/X6Ongs9WCSORlS4ngSrs0Ra?=
 =?us-ascii?Q?muwcvVetsvBg3oHoIDM/X2ZT1GDqfWhngQBEdrX5JUmOZIv037tODNARqvqV?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mIqiTxv84gjRIIy3BbPFRkSfxnEpJnCwyJ/B3zA493ilQK//4mjdsVg/KUseIvXIkiSunniGCZU2IA/Uq4NlJU+CIVeeb2L458tOggF9V5DLJMmndBiEgZ3AM2lF4OR0SQ6PNYp7a5981x3w5qkdh6cSQwcWiS0gJ05nIarKBgcuwK8hX6qN9OCXFVcDuqEVhbkbU4MTK181m/hDTi4lvcdmZQ7cMfjmHOZrjtQEIC45TzxvlC5UTTeaWiov6L9HbXrDdhQm+C7HtS1N8f5D/IxWjqV8eno7++/FhiRhcp8j1CJGv889wXG6KG1O4h+fyVSP3JOENHIJcRQkEVo2bga7o0cM4aDoxBdtKcyuIrJ2fGAU7AsNqnoMZWqrRmOatJ1mcRvNeWsotfkakE4BKO2JNymUQt/8Cjimi9mrrfVgQoHmFmMpbU333UD4JAkPN79k5nnwfWiniDK58hMbCA24eGqGoHb25LPlclUou4jHRwpZHGAmBmKw9AkOozszLSebcuTElJIrlRgkt6mB5yHWUw0biwBmAlU1rTSB/VTnNMImXeMOOphu2FgDkaEiUz6/gd9TWw7HhDBGJZuRTEIhbB0T9+X/kaVn3kFUW2s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372a4531-08ac-429c-05d5-08de1e31a093
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 19:12:43.2087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tyqzg1ocm4Lg4jjCEggpwvnc4n5yJ90CYS+tUQMFP9g9ieikws025t0LbnU8hIepecifpw9WnsHRsMRg6JR2FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=645
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070158
X-Proofpoint-ORIG-GUID: 65KfuPqii1xrvNzrL0pkpR_eLAwJ84Zo
X-Authority-Analysis: v=2.4 cv=dNirWeZb c=1 sm=1 tr=0 ts=690e44af cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=cy3os2EZ37VOcKC2S50A:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDE0OCBTYWx0ZWRfX/GVCPmngYIkv
 4IIjI4LMZqOWFTLh+bVATpkEqQ8mVyMmtTjCJ6G6M8tv6295Y5t4HEi9h2Zlmnl6fsci4cf6+2B
 Zo0lvppkjMr285HPsMR2wJtywWIJpKZE/4GSmxh5xDF3BV+GY0e8afDyLvcKQaB2OiD1nOyab7W
 qijs38SmO91jNeh3qahGfjlUXeUKERIX4WvKZZHmXYp+R349V19kwO/Rdm7YL67F7UVpwc6D5s7
 jjTzlEwhDbnB5Tp47w3troF2HIutIO/skWucVwGeN3DoIlS4UFTP9AHP9xdQBNbfyIS8z7Cdkvr
 Kuj6Cu55QR8gbuEfEcoOJ6tJccr3m1yLCQLFgtaFE/GQF+02/Jn9zNbsCejgPxu/xBIt1qSzxgJ
 KVpBcVT0eVSJ1ufB3h0O2FOu90/VBA==
X-Proofpoint-GUID: 65KfuPqii1xrvNzrL0pkpR_eLAwJ84Zo
X-Rspamd-Queue-Id: D8E1710000C
X-Stat-Signature: qzm19krd3q4ea3mezm9ms5tces7zoj1n
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762542773-151428
X-HE-Meta: U2FsdGVkX1/IlONUPSu7Bwh9SIc45L+wqw3GsR9K9aKwgVUUd3278GW01XRgHAhV+NM2vZ4+2AEyr+wxAzQF+sFpE5d+12ndDzI24E6W0lWBWZboy5u5cQIPbOgaRgXz08nITvyjRYMH/u8GO0KkHOjtYOn26s8QoQlto/MTafBWtegosZ2wUER9gbdqQXwpyNePFuz//2kKiaQt3tClKusElOfBB3m9JqEL7Mjp4/DkFzo6CkHj5LjjTrt9dVbYesFzvYj9h9xHmLkcRNOjZ++9oKLMcvxosQYjxxjJPZVfu9ZmFKZXNqAAgyGx/l306coemsOF4tlBbiQluQ5SDCf4YUpvjuxBiQkmOHmeXSSPj3n+vPa1HUHst22F3+VdG1a3ZdXmR6o8QKMfFBqbLiH2Ra8CqN6qmfBqnZMMHzTPHt+3n1IHr9fZ2A7OV/k7axbs1ynN2o4VR/+HiucFFWfeNumNoy+2/kLvM1dndXzljsGMLa4TWKVyK9316X3n9u9ACpLqmSyO7zBVugX2tpSu8lkl6GlxaJLBcA0Z3skQHjb2faeFb954dXv0yW4YZc9aTbWEKAnTbaXfe7M/AjX+MjGawzqkjen8EEYx+Dwp+GKRiMiS4jxAY+5058nz8RsprejYUJU9s/i1HjX04//YNgKQO3+Giv0Xe1PuKaqzqfXJNGNOL/x/whtqNy7EGYhooxOYaikkWLBIP7SG6ZCTjS6H+stSRm2ujtFroukD5WcDe/3bwfS9kqn9Xfo9LVH2zVHow7UatZ2reRADWSxffCKu4xny2UzYqhTCbR7lvwZzS74NXJ02896OQcruoLGsad4ukoj2AXLBP5rmuibtr1N/DCa3zKVBf0r4hnHCOTBnF5acu2m7XiTcLqm7c54ai88ElFOuhASCtDjUeV3ztQi5XVrhznv7ICq5oduAO2VaLwVFykatTD3uFfIIZ+iyJ0CPaBhp3QLHZBa
 PkvmehQh
 p0g24pOwNvTL3KgmcKkLsoW7gBoGGAidga1mm2yhwOrmoIqj29Aciu1sgGJw/tJIN7wClj9dHBcwlTiJMvCPtfsdXlqcPUJttmMQ4TUTgjFoEo5nxjYmRB5hnLni63Ph6c+G/b0glwTvrgJWX7/0rKN9vjQGlL+MrcD+ttrRDKgdLvv6kBrrxLsFhGtAmm5Fo55uH/iYHb+5tlVNJqm7PlbOqnn+DLyV3TlRPu7Y4mxzMsPqfiJU4oTk4Alp+dKXmSKecNs4NQZOZX+wkJ+gbuBtgWU951OQrFuFeAk4mLcS46E5hlbluEzdCSu8v3Pk6Ii5lvEL29M+40iyRt+ZAbK6JCCD0LK0hUJuNl3z/4gQ3cXEabLYsXmdxo/K2TsD543KLKRqheVxYS5e6uHFmXVHpJcSWcGNvVPvAlickxPjDjKKqB4JjSwgt7TZ+f78TUGsMjPxKCgyneujEQE5m4MArYvqSbrmLr6HfZ3BINuPBsRPZSo38aTpgfYmhb3OMQasXyvz9vVKQm9SkSJDc5jw+/kbcWyQSJAgt1w8TV7aH/Gli5GDtJibwlFSF1IE06QKVEqoTSV37BUHZ5Dw7q8F0+4TLqUT9Kj1DCJ+eX2VNrn9wxVwHq7z7Zl9OJKfmsWYqrIAe4Bd2iO/1Hm+VaJKqu/Zmx1AwOFap1PbREImk+MKhZ/ysAHzCSlSrGu78SwymcI1uf/tJHzzlvFOxuXrkuGEOMdf8GNlTbnnmNVyh80AFNdBs/WwUYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Matthew Wilcox (Oracle) <willy@infradead.org> [251103 13:04]:
> Allow waiting for the VMA write lock to be interrupted by fatal signals.
> We can remove the explicit check for fatal_signal_pending() as we will
> check it during vma_start_write_killable().  This is an improvement as
> we will not wait for the reader to finish before checking for signals.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/mmap.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5fd3b80fda1d..03773fe777b7 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1750,7 +1750,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	for_each_vma(vmi, mpnt) {
>  		struct file *file;
>  
> -		vma_start_write(mpnt);
> +		retval = vma_start_write_killable(mpnt);
> +		if (retval < 0)
> +			goto loop_out;
>  		if (mpnt->vm_flags & VM_DONTCOPY) {
>  			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
>  						    mpnt->vm_end, GFP_KERNEL);
> @@ -1761,14 +1763,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  			continue;
>  		}
>  		charge = 0;
> -		/*
> -		 * Don't duplicate many vmas if we've been oom-killed (for
> -		 * example)
> -		 */
> -		if (fatal_signal_pending(current)) {
> -			retval = -EINTR;
> -			goto loop_out;
> -		}
>  		if (mpnt->vm_flags & VM_ACCOUNT) {
>  			unsigned long len = vma_pages(mpnt);
>  
> -- 
> 2.47.2
> 

