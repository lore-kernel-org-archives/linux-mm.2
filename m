Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7625D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A01B6B0095; Sun, 18 Jan 2026 09:52:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279216B0096; Sun, 18 Jan 2026 09:52:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139506B0098; Sun, 18 Jan 2026 09:52:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EAE0C6B0095
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:52:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA5191AB79C
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:06 +0000 (UTC)
X-FDA: 84345374652.24.3C108D1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 574D6140002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DcXa6m0v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RuD5GVWo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747923; a=rsa-sha256;
	cv=pass;
	b=CB2es5LBRgA8KeS3G9EN4rifZylbl0NsLZWCBLyCJCr6XpYUq+ZAda5qKqQBxmXWFQHScG
	KBPX4VB0w4izByHg83f2RW3YzYh+n7/gcprzj5edDACX+qhVw+KFtHItiMdpdfIyKOf+hl
	3FtY4MdD1r/PDYhBOG3PhMAStHchTaw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DcXa6m0v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RuD5GVWo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2M7++oq4HJyp8gpczGnxQPqEc2qyAxvqLtJu8OG9Cw=;
	b=pnu4arfn5rNGCa7oi9HeC3ehn1lU035dU92dXXkWOxNlfnix17xgqmFrYxQIh3lirbB6cK
	cB4IB8Pxo8uSajZ1RsMaYFxJMXU/cx1qF6NlZjAp/oEu9hlAJiqChP1PbeAp4qflawRx4G
	mvjZfqjbxSxJ4o04aZ/M1CFi1QxuK9g=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IEIZAL105754;
	Sun, 18 Jan 2026 14:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=O2M7++oq4HJyp8gpczGnxQPqEc2qyAxvqLtJu8OG9Cw=; b=
	DcXa6m0v9YwXzRimnWK1zS8avXhsOg9hbD1Wcr0nOZQyTlOhuSPz+GNX8Qzl+L2R
	zxMEuEzxoFnspyEEB0KAJwJBJqoKb6MzGiOX6qLcycYfKGjWyz5IQYzDG/sGyZ2b
	7k3NV7VYh+CJKT8/3YyvYZQaFaxClEO908jd5/r/Y2xMEx53HgRqwWZv5WRAVXuy
	2RGlM9KKITmYWgqis+RxHgRBCuu3NrgIqXSS69EM94nCSqiFK0MFIgi5oC97plSu
	NuatAJg4YgAkaESwsMWWuWAdtxWec843REnAoFwV573MbfcEWMLhr03zwOjNPqpl
	WUNDpFA/miI6oYhUqfxHMA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa1b7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IAs3JQ022573;
	Sun, 18 Jan 2026 14:51:58 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010004.outbound.protection.outlook.com [52.101.46.4])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb7b1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yC04pMVJ/V/GW2hdhkX72KsMrbj9UxoA5ssFKHOzhvfXbisiJeOacrCu2zmOJGa27FUbqABvPwhLGmn1U9NG8XhhoA9x/ml0yjqcbj2gvpcdHomXTbZIPxdrwJaxrQwtzvDktA0jXEJO6PNN+xtQBfb7cFfiS0Niv4taxbfGbH8qCwRFCxXLIlWkCUtNHAkHzeF51Jytiz2zyxWHf9J+L0b/5tcY+N/zbX4gnRstONcHVDFhdI4Ems4c3EO99fVxnhT72gpSarVDSmd8x3T2cykSeIhqu9MSkr2F0kTK5NEjF+jOVD120l/m8DAgO4FVQFDSJoSaAG2ez8apO56ebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O2M7++oq4HJyp8gpczGnxQPqEc2qyAxvqLtJu8OG9Cw=;
 b=AK3omLzeQQmwEvwbzQKf3B2Sju9m4ZZuHNoI2I8X3u/ZyvFAhujz4lJTlV+KO9dNIgjwyu50V7dclnJtNxVs9rtVWRLzb2kbOzXjOCAO0D5PbOInChUUeQ/geAzZClLny4z+ROeyfS0D8/zs8dM+n2FYCUc1CIKxFhVhmIq8TBd0Nld65IwXnVL0J+lmWAbTptMbPCgog/nfvibjIVENEnhFurgZS63R8TMFYQsQXFRu+LtJyuaRoG2n8wgHEiMwegOiyyEuQMXmvFHF5rJVse2NJ2txz8uw/b8ou1siiZQjMgwJnhVIMsKO9jkk6/nhIIMPevtjIXyaiRoHMdS3VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2M7++oq4HJyp8gpczGnxQPqEc2qyAxvqLtJu8OG9Cw=;
 b=RuD5GVWom8Cadonc6HxrhPs5sDZS5T748UIN+LCRtFGtUQ5XaM62dXJZEgh/iR7eU6BYSlkfZ27FVG9ZPn1A1PJy0aLAlDSt3AqmLEvspMe7oMLs3gbhHff+GMuvFMjbl/fXFFqXEueVZOIals2y60dxIF8cyDldGLBNu11LWCg=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:55 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:55 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/9] mm/rmap: make anon_vma functions internal
Date: Sun, 18 Jan 2026 14:50:42 +0000
Message-ID: <79ec933c3a9c8bf1f64dab253bbfdae8a01cb921.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0118.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 9adc538d-5ee3-42a8-b0e5-08de56a11fac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N4jiBJyebATRjDiv5hy3MCBUfAMoxkjyeDmobr6jK4bMYbyhkFUP8b65JOQF?=
 =?us-ascii?Q?x/l0DODCHccZTzUwGtFYQYHRdjFndObwqYRyrgyDl0AQHtBz6IBPSgS8KF+p?=
 =?us-ascii?Q?Ha7G0M+2ByY4vsTBRbEX1dBVn0SqtYzh9yktQcxzhdf5gh+wzZ006hBJUWd8?=
 =?us-ascii?Q?/1gb2rNC+Ix6XTegQu8XYvL5ZjCic2Ehd09VjxsLvVadRVMbgcJ+HU4AYpSb?=
 =?us-ascii?Q?8jHvZShpQy+lgs5af4yHYyNqrSumgNV7I3u9snatmdiJ3rN9lMY0jLNI+whV?=
 =?us-ascii?Q?Vo4dfnM2X4hOaBEFrn2YbvIERisYqv1pDtnAQX1060wcv3doVu1g+tCOuoQ9?=
 =?us-ascii?Q?kcEiPl/cWJyMd5+sTE5Jr7zTZ9hp+g6vbik4ZgP2vmtRE5VKDqyL1bGOCOZj?=
 =?us-ascii?Q?zFmdQK0mNPjbajw/UabTn9Hi4PnBbaAVjB6Jb52EjT6u0mpSCbehNmGNSkXd?=
 =?us-ascii?Q?gzr1VRApj4Bh7b8foocWOSRt7aP0IkqInwvW6Q3D8VRn7uzP21antA7XDnRJ?=
 =?us-ascii?Q?Oa9eY9AC37OaavhKL3QosuFpMwn/i/LHHGe5SS+4NW9hkxHYvx9LPXBfYnsx?=
 =?us-ascii?Q?Dc8JtT+PDMeLYpSsIXz1Jll146/f3VqHP8yTzLlS9VdQeHD1ama2UMSgYN84?=
 =?us-ascii?Q?Af2QTZ29COo5oVK4lIs9rRcdDKwaWWPTSjvMMuVN88EVR7+SZI8jhffnimuD?=
 =?us-ascii?Q?0jIk+4FYj2FDAbSBbJ2EbfEGqhgGRyZ7YrSAN4iTNkHdV/+7Ia4qdocMwQ9o?=
 =?us-ascii?Q?qlnJ4BrNTvNnT5Eb5dlESC+kpN7btUdqzts39baDicyxOe7/TBPAnk1rtLaA?=
 =?us-ascii?Q?gmGaF2DTLT6FSz1OdJjjqdRcnY/dKpKTcJLiFgedY6L2pbOU9ZXugtUsRjF1?=
 =?us-ascii?Q?qMYZT2cB+DfNnCOWsqgsJ508XMKbwAc89lz9HT/34augJysjduFcsjC4KFeK?=
 =?us-ascii?Q?ifijkPw4dk/1MWLmuDbtpfddH89UB+pTjWgFu/5dAQ8xXUXDq3Wz3+1RsBgl?=
 =?us-ascii?Q?BSG1wNilLSxvE1WxraSac0V1+9gPKCioNqlq1VnYgtnGy3LX9NipaJrWAxLC?=
 =?us-ascii?Q?unhHZpEGx070Y/q4bZKfTBdqbH7YHaNbiMgWCVf2LSstE4GK2W+BeY2JDbJE?=
 =?us-ascii?Q?fUIwalUfWjJ6ZRz7eTj7btHKNdCIlSS+feUae5dHq3XfHRXkncQQFAx8QtVX?=
 =?us-ascii?Q?YUKBQZcP6UdWld+ivfA68leHHV0g6P3xHNY7VOlTqpFP5Kq3JoU0UQrTQS4P?=
 =?us-ascii?Q?HGPN5kZw8JFqphWmlKIxkCx0BKnWiGmrxML+ZVcs+4Rcvs2GldHTv9+aG7Ts?=
 =?us-ascii?Q?1vzOybezL6aUKCWhFEiMGttCZTB/phURyIV4EMbE2VLpiXAjwAaRmxy3Q7a9?=
 =?us-ascii?Q?Xr/7mv+dxQUGtC7kCkZPzo+tmWK3QN4W7ACsvzlYQpjCH8Fad/l82EM/LwpY?=
 =?us-ascii?Q?zQ/8NsY2NNQBAvYD1/lUv7nAJo1Wl1+uKKm0fi635R2tWs8v8t9VZM16sG6w?=
 =?us-ascii?Q?8peOLBw/s3iGcJciDLhWVc1qasK9mU6/14gRiNCDm1qC3k3P9IzNWYYLdTKJ?=
 =?us-ascii?Q?b0s2OY2tI5Ef2kFyBhU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3TbmFi/QLRRx+6GTBOWGT2/mUewrj9r2HtDTuKbmZoUYTjW5UOSa3aHuQQGk?=
 =?us-ascii?Q?bXemE1J3C7bEc2azkIi67h6pTL/KHz3fOVigc7AQ3AcWc2sl1oKEpBjy2t/k?=
 =?us-ascii?Q?ZX0oJDawXl6tYM6yrJsxb1eYlTEIOy2izPWlDHUW2fMd5fsXP781cT++pJiC?=
 =?us-ascii?Q?aZlfoZgR95hNKUbBtyBZrehqlsLrR7sWFfR675qc7qqqWv9/mXht+JBz1Zjr?=
 =?us-ascii?Q?83MpxI+K8G2rBNV3rFcQzrz6vMg7FyKL4C+Ig3ZOMJWf14N6EkdkExvw+aiL?=
 =?us-ascii?Q?77yk4UdKOu8j0u2CZtUPOcJ6nZdxMiuLn72tBWZ4wCVsxPVkS5bSC2mXkNri?=
 =?us-ascii?Q?SZglYun+mj1daGM5AzHlG+RoZr1NcG7R40ieBrvYDAVsWnsbaeulKGJMRNSL?=
 =?us-ascii?Q?Sh1W1KaCsZofebZxwDn+ETpBs+/tSS8DGqYjS336Fx3Fijcm6589LEpIpkxN?=
 =?us-ascii?Q?x9FpAT/DXdfxsG07qjaMlGv5W6moWj/DeXaxR07JXEhZSGb9WvNmUungcLJr?=
 =?us-ascii?Q?LaCoyF8sHlX/sqxxobHicTODOb4ezVNq4xWGYhVozSRdk/caaOHuVK/K5A7u?=
 =?us-ascii?Q?czTEXSLpNdjYMh/Tg0vNI8eJiarV4/OPIoD08KNUr4UuMkHl4HaSQfZ8HeGQ?=
 =?us-ascii?Q?tDcOqKoCfWVurwC+2Txq7HGcDDUGIvuTuyd3dcNUI8aRzyTQyP0BazoeGyT3?=
 =?us-ascii?Q?yrfANL891JINiG95+o1AN3LTpKQbx+CU366Ql1zth/PZsWlMBQIlgUziCVO4?=
 =?us-ascii?Q?6lcqjrIBA1cA7W64o8pOqnSFOljgU0de30lPeurM0NZTbfyrvZiMs8XYqz7Z?=
 =?us-ascii?Q?4VynORoNKFi2sLJObK/EtOm81cIgFCDuoabGAyLtl2smQfdJj8avtGFnQ/0y?=
 =?us-ascii?Q?rmPCRhf3+qx7KyeXPZWyUgfo/0FGEQTifTANfP7mAmPmWOcGgKlxmNqQJ+Ev?=
 =?us-ascii?Q?rJYPNzr3Jim3T/FIn7wEjM6+aA9Tv/UGn4etl5uv//myRsX2XNqGFBA4RKmp?=
 =?us-ascii?Q?0gy30PgCxPfGee0VUm+y55kRLbBYHwDSsf4ZhXdoQOQAug2ealNOFkCVMgUt?=
 =?us-ascii?Q?DgtN7WlewR9/dzw/5Y4/kAbFq42qoy6xoiuMENF2Mi3UufKn8aW0jnpUqv+U?=
 =?us-ascii?Q?t/iCzp7tunRJFEand3LGWhrCdlsUoiw964Xwu8cqqHailLiknXkQypOXLI0U?=
 =?us-ascii?Q?GRal68Wjwz6uu4+exoq1EfUxNV6XwpnORk3v/B1FnquS7zJYo+mogLcKNcF+?=
 =?us-ascii?Q?0b+6JklbL2zq47/3ajrNKK6raTNwrzmUyXXLsi2V24KsnjCFF0i3Tw1gJvVq?=
 =?us-ascii?Q?PcSxg2nBAfbFOv9DgKzi4DThwfRH2PW7kvMYR/i15ytrPaq6+Jw40NMAe0Oz?=
 =?us-ascii?Q?0m7dW6CJTnV3PglsANQmpGbJrChSAiQGzDLQe0HFQOgj0J4jogUV8BUB06yN?=
 =?us-ascii?Q?Ok/YwnKu81OZKGk5yOrSjRLNOFbEoOyh3JF2DHC+HSGK8+EkNx6n0A6OJNco?=
 =?us-ascii?Q?5YF2jWXCeTnwt9yWw2ULcD6UHd04fxbx4b5KM2MDq/Z4yYsqENMNhxD7nrpy?=
 =?us-ascii?Q?DmxtwLv4nfa0EJhTYRE+1U7OcbMKp0GlMrNqfIFTKxIczu5HQ9YsotPbI1xd?=
 =?us-ascii?Q?GJLdY+BkjQW98fWpjKI+jzp1OF40mbDaFzETbPPMdINf/9H1kpBmANxixHQx?=
 =?us-ascii?Q?YOFeUj+TNPlTnOq1y/624bwQrmri+Ntdtzm+45MfY7B0PlK4ONLvlWuG3Rx6?=
 =?us-ascii?Q?N3ERRmWfe0NhsdFZAFfWPxyS1hhLXn4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QI4tAgH2DYLnh10oV2qDljAMWrtePGdXyAB+i26rzCeODFS0SHxi4BMLBe+hopDywEjEBtOF9pp8v81uQJM5VO+VJ5BSTT4Cy9s3n+UHjn+PGi5wDuoGmo+/VZucpAAnC8VikEKBOfwNRFBxaYdZqghDwv79GqSZ2lrLrqo2+cXBX2cpR40zvwH1wboNZ0hCnF7N4W6Cv0rxtpcUgWuBu4H7sFZ8ycUR9pIXY83/HaOU1P11bZN0NIS0oHg1KOriUKT087YdPozLuh8wHaI9R+Sv9/5jo+tdZW/XZjHh7xmoXUPRHhfCG6HMW4Za6l/lhLCRHAim9JtGkDESmjLz6GK5AgfOIgSQYem8VJeARrnC9tgDyrQ48YL3GAZLJbm1arDoSI+PdLXc6SmdqAq8XRWNSIoLjBcc9x5FWM7mv237l2iTU1fFqWcBx2ZUq5GKBlNrNnFGYpQtDk9ShrYuSAaQZYbNy1v+KukmOW48OiyAfcz/KzZ4RbZzLXxbpAo+vsl+aP0NMEGxjdTtsa8G3w16B17wud8is3bDoozo/l9th6cX9VtbF9TlBKKioIqk2n4l04kPAg50iN43rnYcBxC6wuQwDeRxGtgVR/rPVCU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9adc538d-5ee3-42a8-b0e5-08de56a11fac
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:55.5090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ju2Cnxil6GMwoG5jvEGFaaobzWumrb+hj3uMrn3r44mBtl1ylijjj/kF5lGWoulbNyUKecN/sWszeMCiLmG9rsfvnzTvMyfNPo4qln5zBqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfX8IcaI1X4gzXR
 cfHJ2H5b6Uzikiz48slNs2nxfrsJXEcDA4toAADijOjnTPxl4V3v4U5ytTpHfVy5/SLjhwwtKpp
 e1ZaZEIua4deO3Yp30dB8TTH8cQkVonSHOlT5RATRuVs5G8CHBSrDjJ/YF3FknNvlbP1OrR0FUU
 XOBrphtAV+YUpxv7wzq7gGzJ+wdl1+k704K2YWndVqY763DJMoB8p7Hij5zP+TgoTzE4cAgM/WQ
 /J5wwIabo4d9Goi0SRpz4qtnVL/VW5wldSJFi8AGU97voQ7cy6mMsdoZLtRYVYFW6E/QG2VdwOL
 WPF5O9gncKU9PYTAjWUWVJ1zSDD28gxTpSuUy98HvAUn+w7BR+BeORS21aF8Y2nn1Y7aPStK+MI
 A1icdhUavmj8Aq4O5VIRdFzsLtBPxvk920cg9f4ZB3lLQh+UaKupo/LlBJ9G7N6JMZEMeGKdNsZ
 CUTSQhlAoRodLCVdxPGXlN1CyBMQnaoxCwQ7auZw=
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696cf38f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=3nh0fNsjLu5yX6a7-g8A:9 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: PtN2yKfQCTaLFEiN6rq41Pwpoc5dcsnZ
X-Proofpoint-GUID: PtN2yKfQCTaLFEiN6rq41Pwpoc5dcsnZ
X-Rspam-User: 
X-Stat-Signature: owotf58xgtgxwo6bm5bpu53qnw3cpguj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 574D6140002
X-HE-Tag: 1768747923-328793
X-HE-Meta: U2FsdGVkX184NYEBPuIQILNxyA74zT6EwMZjOaBvVqvhLjR+zak4OahBDOX9hmTNeP1l4cb374PXBNGIFfTrCQrREj2fX8I+JWU0suGh3bpN4XKIpYEoMbmaMqgZKONYCEFxoyqFx8AojADqlNN8R9vRBy/bBQmvGL1/jNVJoYyLSjKglHJM207gh6GGF+t7uIbkJrLv9Sk032WWzWZ0VDx8z2dBkPUfHZJ4i7LgmSpT59d9NJ+ot1WuiRFpBoTH5FYQf7Vw1fb6glsEaiELYBcp4jMfXWVq8zAvUUvnmAjzDiqzHlwKG/pS6ZD8nhNXuuF0BYNDgp20dcClbeof51DLevmzp/Om+LsFGS+Pp6ovKb3o6hU0VBv0RaqASEjMX+Hj6+GoLneOFc90V7OZwIag3ffPcEami4rfHa5rRA+hOCUORLEfTPWm99uYeZlo3PCEVUaP2yTjVrzp4XxpivGhXZOvNNDur9KwnaovVC6mIeIvmO1BL4hr+RM4Yu1XUZnccBIsIThZ7WvU6Z05Ucd6IWyz8YQeLmneMDW/gw1qbppeue0SPmmtO/iVMJw0NOK3QYGCRe6yr+kAj0XC4n+8p+9Vfx4XWwAidEfPXoJh9T0zOnXJD4bnvLUcckyhCPBa5CQz4zhjltl8/CvbfAaAKCDAHVGNVJWWEHG7/1vtlb9g6f/Hx18Sqv40tqjmVOtZLlZ1g6RsZGwKDAaIIZWGUrSobdl3Zorr3JBSfHJc+8qnBMdqDKEgYF9eUoldDATHEIHPEBn6A/OB9Qc5Kp284AzFtHvHCcUP4cyeXnsIeErMGitN9RtAZat8rUdQbomfoA3WUKzPk3+/giZcfUa7GmD37F8xQlTZbP/gdsJ98IAIPLgQyEAXCXXTwMF++kKyttVJQZWpEh9oM8/vYott2M1m+3lIzNpp/eaOiFpcsZKUph6EQDUyPzpHn8vg2f4OK3m2vCxaPZ33oSN
 kt/EShRi
 pHZ55940hQI/zSBgJKtvojqppQeGouXcY0GjlAXpVPOL0IEY+Knt/j3iy39PBOY5V05qGPKRsJGhPzdjReveflnrLHZxndVlz9prMlBJeDvnyF7ll+oLVJRtbA2HLXlewfIBQp2kkpCnVdyTz/u8puK8eEHvQdRHedgJGUSrAeQzQqYOw+NfuQXl372RV6dsnlsp9LwO4hNpZoJTYJDGDHo9VEGVwY/Ggsel9twF8LlWes0ns+mdLFfRa1DtTGhAh1b7klyu0T9QjwYpijOpXrJUg4gN6/2oCoJK5jKnIW7+YuEncqsFxVF5DnWz1NVrkxtPwbzgXKbVwYCCgFPkQMQplUw05E56pAS1wC7TCrfJLshhd/TqcOygxom1iUnRRaNjlmzSYrz3kkFYfhhRjBEsA6WkP9UMP9yViAJ3tndiqAPC+nLCSgbdNPnEeam4ID+HrXXlXZslnfu1Iq4FJtGS7ut9yeg+ntDTldTk9+1QcwzhyzGbsdQaP1eDeON28W8IR5CbPj70iuZDTA54rR06hZRFR1KTdeVsTgpol48phXhpjF3bsP8oziWC+oj8Zfwoao+QTtYwOwdbRbmiZ6aANvyJXYYmeqX1BmJmVpJwoocRjkvIU0BSTpjKW4wLhPZfmpKVzoO6AT8syu2zknMXtGZNO7cdSAtmh20Fx52d36NCPdc5niSZS+sMwKzFai1qKao1o5FB0Uo6a0HmE9hhCP1gZGl3hkfy2visq1oEMbDfHoef0t9L9SA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bulk of the anon_vma operations are only used by mm, so formalise this
by putting the function prototypes and inlines in mm/internal.h.  This
allows us to make changes without having to worry about the rest of the
kernel.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/rmap.h | 60 --------------------------------------------
 mm/internal.h        | 58 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 60 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 832bfc0ccfc6..dd764951b03d 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -104,68 +104,8 @@ enum ttu_flags {
 };
 
 #ifdef CONFIG_MMU
-static inline void get_anon_vma(struct anon_vma *anon_vma)
-{
-	atomic_inc(&anon_vma->refcount);
-}
-
-void __put_anon_vma(struct anon_vma *anon_vma);
-
-static inline void put_anon_vma(struct anon_vma *anon_vma)
-{
-	if (atomic_dec_and_test(&anon_vma->refcount))
-		__put_anon_vma(anon_vma);
-}
-
-static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
-{
-	down_write(&anon_vma->root->rwsem);
-}
 
-static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
-{
-	return down_write_trylock(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
-{
-	up_write(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
-{
-	down_read(&anon_vma->root->rwsem);
-}
-
-static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
-{
-	return down_read_trylock(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
-{
-	up_read(&anon_vma->root->rwsem);
-}
-
-
-/*
- * anon_vma helper functions.
- */
 void anon_vma_init(void);	/* create anon_vma_cachep */
-int  __anon_vma_prepare(struct vm_area_struct *);
-void unlink_anon_vmas(struct vm_area_struct *);
-int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
-int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
-
-static inline int anon_vma_prepare(struct vm_area_struct *vma)
-{
-	if (likely(vma->anon_vma))
-		return 0;
-
-	return __anon_vma_prepare(vma);
-}
-
-struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MM_ID
 static __always_inline void folio_lock_large_mapcount(struct folio *folio)
diff --git a/mm/internal.h b/mm/internal.h
index ecb6020cf313..aac4ec53fe15 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -199,6 +199,64 @@ static inline void vma_close(struct vm_area_struct *vma)
 
 #ifdef CONFIG_MMU
 
+static inline void get_anon_vma(struct anon_vma *anon_vma)
+{
+	atomic_inc(&anon_vma->refcount);
+}
+
+void __put_anon_vma(struct anon_vma *anon_vma);
+
+static inline void put_anon_vma(struct anon_vma *anon_vma)
+{
+	if (atomic_dec_and_test(&anon_vma->refcount))
+		__put_anon_vma(anon_vma);
+}
+
+static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
+{
+	down_write(&anon_vma->root->rwsem);
+}
+
+static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
+{
+	return down_write_trylock(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
+{
+	up_write(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
+{
+	down_read(&anon_vma->root->rwsem);
+}
+
+static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
+{
+	return down_read_trylock(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
+{
+	up_read(&anon_vma->root->rwsem);
+}
+
+struct anon_vma *folio_get_anon_vma(const struct folio *folio);
+
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
+int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
+int  __anon_vma_prepare(struct vm_area_struct *vma);
+void unlink_anon_vmas(struct vm_area_struct *vma);
+
+static inline int anon_vma_prepare(struct vm_area_struct *vma)
+{
+	if (likely(vma->anon_vma))
+		return 0;
+
+	return __anon_vma_prepare(vma);
+}
+
 /* Flags for folio_pte_batch(). */
 typedef int __bitwise fpb_t;
 
-- 
2.52.0


