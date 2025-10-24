Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A1EACCF9E9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 07:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758C58E003E; Fri, 24 Oct 2025 03:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70ACB8E0002; Fri, 24 Oct 2025 03:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E70B8E003E; Fri, 24 Oct 2025 03:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28A828E0002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:42:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D76BA140D83
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:42:15 +0000 (UTC)
X-FDA: 84032214630.16.4A75DCD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 716A01C0004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:42:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sdNVfI33;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=stCAx015;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761291732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggdF/T6I0YXEYXqPE14M1nwz5EZJMt4atTt+5kQ7td8=;
	b=yMJiOQrjHwlZMShT6RiN76/cSNR7iHZJ8EkMeUK9JHeqlfsoRsHEJ1g0q0y28M3Ingufmb
	LeGMIpA8dmL8lY9u2WfWPTs3BxObCUyQGwQVExBHIzj6zW1NH71Np8Rl1yRKWIcoau3B+p
	44+G7chk/ZODeETrO3G77jv20XzePcs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sdNVfI33;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=stCAx015;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761291732; a=rsa-sha256;
	cv=pass;
	b=bkCDjmeVRyNKCKMMC8vD6e6I1enoSxmSOWdQfXlmoM1opY4dxDCdImPb6PxUBgUelUcLqO
	UefBOOqv9AGUIxNUvqPRj0LWEWPqss++wHarra0FiLlsujzTDe8HKktVZBVobW4jArz2in
	e03p7s37PiOdCqdP6UYBr9PdNWf8TgE=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3Nwjw029460;
	Fri, 24 Oct 2025 07:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ggdF/T6I0YXEYXqPE14M1nwz5EZJMt4atTt+5kQ7td8=; b=
	sdNVfI33zCV/XnMf7hCr79MjOcr8FTtQ8NDugHJ0eMFMLxUSTH8c7Bd5Qjo5fTRe
	idQzGa/K8pWRf1USZM6ByRuWdGJXwjq4OVVwXuCcygRqkU/BIEHUyX6dHyG48OVl
	CGKTFdVrj6D5stVMZSdo3/+BTwUtYK7NHS/peF4A61VT26qaHvJqkPm45PP2AErr
	eb2nrV/oStoieTl4jMbm6THT3vYhhe8BLhKDozvJN/VQPQOGLVvcpWd3LOz6PMGV
	b9kp+C81Ayd8t4KjmpN8g2oxXpptFlC0nlpKqK4autOKqhkw8IEydHxV44VXImck
	A4f+cKctUMT/U/Dy8S2jdQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvd0v4jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 07:41:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O7WQQq035638;
	Fri, 24 Oct 2025 07:41:57 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgm4xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 07:41:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ChLNUH5xeMv1isbKZ1B8SjN/yX7pM3KutZKWJ3ABCrgiEjSQbYJioBWInxh5YoxFta63mTQtZrPdfKDKHiPkmBbRCLgthyZqJTSGcGY53U3Ezo86Hmjwrr2e0mjzEQkyD+j8wG7kQ2AElWEUuXVybgX8U+Mh7JBPs/l1Tz5JxkEYLug4Mg/gi/d/7UyXvMDpF/t/ZwEzPzYaLWBSZW9LZ04I5Krmd26MREq08q1/MCCYCR4vswXFklh+4Bpf19evVuYlHUvO8DWq2/n5jDEwUfHAj0Bx9tW+m4h2HSmBy40k4vMfS4HGYNdRvAPLCqIt9yYC6I/ylcv2/r8qoQbWyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggdF/T6I0YXEYXqPE14M1nwz5EZJMt4atTt+5kQ7td8=;
 b=CgGr8S0rdToIyIPx1wY0KVBfuDvbYAfodmgWO3OsjjDfyOGGZaDiRzADZjnsjBS5fW1wZciM5jYBSR04F2hgCFAnK+d/uwxfrkFufc/0u1w9ctXrrPs5Cc6jw3borPnc4EasMSO1TYS2Z7vtS/1bHZakaT/n8gpwyNJ+4MEiITzjV7nvHun2XeHtHEPVJSbinT2MoOy25PrErMRmgKVe5kaofC7KzI/B7d7bDtDHlahZfn9rZ/uG9LuNphLs2YyunHQRA0BXDI7jpuMEz2d0ksmJVpAeGPkX0TerO7xyLVKrwQ8AAaRziI2wjVG+FnTGvUm8LPFCfxo5CN2liliNnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggdF/T6I0YXEYXqPE14M1nwz5EZJMt4atTt+5kQ7td8=;
 b=stCAx01557/u1HQqf4JIgERHFU81J+IOBu6Imbtv65Jjp5B9uU7Q46H0/C3UR/2cUQ4DgbRS8mXUaJwjAccvhu+gW5eIaEnqoRLM/IF6AR88PTjQyD5tk+aVbEGgliqvMAqiTunArQ1AKWgLtc6y/8LFTyL1zJUe4p9Fu52bEjU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB6716.namprd10.prod.outlook.com (2603:10b6:610:146::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 07:41:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 07:41:49 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 03/12] mm: introduce get_pte_swap_entry() and use it
Date: Fri, 24 Oct 2025 08:41:19 +0100
Message-ID: <a48bf5fadd66059bbacca6a5f2eccc60eee3278e.1761288179.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0022.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad025eb-7c54-4fc7-f97e-08de12d0ca5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bEcLPyj7GVPDK6Ol1tQWpyoKb7KEfak5hFm5a8WA0kxOTil6lfwmY5rkkJfo?=
 =?us-ascii?Q?oHusp4r2Y+kSjfWektEDBuW7G4hoorPqQpZA/TXgj131FWToiN9iTkaz4pWB?=
 =?us-ascii?Q?Ot8aNG4DgXp/39u9IZ43D9TaO2QnlEZzlJPhJPNss8A8lrebm3lP1bQiqzNJ?=
 =?us-ascii?Q?7upyXoIm59/gOT9tjKpgKOlFlt23q9sjB4tJz0ozS1mnF2dPsLNw/5pyYErd?=
 =?us-ascii?Q?i6bdv/tvKzeQ1q8CMUkIy6Y7l+78fjlUel3tfB6Yc0OS1ONiKHyJ5NIDdRPM?=
 =?us-ascii?Q?rQlYqVKpy5xNkNhY9iWiy3aWPIcG9lYX7lz1x6QvKmYu7Bjptz2XcoBDQ/7r?=
 =?us-ascii?Q?KFEl0eJjbwpv37DrHkQhUVN09NroL347kwPSfqiE+QIAsB5Vs/E4CNAtr6la?=
 =?us-ascii?Q?6H273Ww7R1Vr93cJeDoDPGcWpdxOZAX9uBHnVUzqhxIaJslacLMYoAM2saFi?=
 =?us-ascii?Q?/lcAI+ypCSBjVBYle9ymMrqx1FJXf8vtN2SUlkcc/7J8i2lQCFsT/TS14shn?=
 =?us-ascii?Q?6IA5knQ4a3Z45s1bOGF5JX9j73BzkfLfP40RUZRdTEURZkDxxeHPUYe0rdE7?=
 =?us-ascii?Q?H7hlMMokUoz8UwCpu6wb2TgfRWnBvzY+caEIiEOMJlIdXXxYzfCIUnhifmlk?=
 =?us-ascii?Q?zeeG0Nyf5PXarKaM43mQAR9ZyQ4lXN2BbQ/ym7gsE61S605H0nG26F950ZMy?=
 =?us-ascii?Q?TU40HKj3noaciCtfctPyt2Ehe/eM7+k5iLPA8Qr+59AxMFyb/BI/hwZCIhbG?=
 =?us-ascii?Q?fdXsqu7IrCqJ0yFSEQor9E3TkjvIoXmhwTS8qxKBYbxspoPq0sxdTZ9yAcDw?=
 =?us-ascii?Q?/U/13qp/YyusAkOCsMU6THDV8PZmbHEphgT02f6H+F0MQXnnd2JS0JqYsBUG?=
 =?us-ascii?Q?SQkmEi8kJ6/fvKfDPep7oDjYP0Z2P6KL0GNIUjri9jqOjogX0yhii+cDvUmb?=
 =?us-ascii?Q?9BMacI8GhCGZUmSUXLHAtfGKJ7j38GIh/lteYagHqxaKBJngoAAFZiS5rzCi?=
 =?us-ascii?Q?ypMQDBH+kBUO1orx+pCJwXuafISES4cv/nzF/mhjaV5KnWeKCi7GIdj7cize?=
 =?us-ascii?Q?MhxolEXRFFRUdy7u2m+WpowlHrQjwEzDlRoP77+GS0Q4GAgroM7edzVQwMHL?=
 =?us-ascii?Q?nqMJUCUBDZGoaq/1HWVCISPvADhUEXyvj61cLyPBlWuprnGC4j1PukyqxZmO?=
 =?us-ascii?Q?AsOiIWiqlWFR31+MP020D8sM39zD9p9qwwWslAfnYSMh/NwD1GYyNqRSwLE6?=
 =?us-ascii?Q?Y3j727pFQDDGj6eItcLSyp2k7UpgSiUvUOpgLnnHAmhOaOneFFFIB9uCGyCF?=
 =?us-ascii?Q?g3GypB/CVgJxU8s9y2nEF2XtGk1WPEsYq3YVs/by+kC8xNisYw0aSgk9sn/f?=
 =?us-ascii?Q?IX335JJhnYcnRxcgrv72xVPy5IpFwjCJJg8zZa0WvNWKs6zTRSw1YFv7SWU+?=
 =?us-ascii?Q?5GG7AmHVd3aevO6Z8iKhe7Kt0OF2lDTM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uQa+H5p1kyljTLBm7DYucUdKqZNUGVu71/1Jvj1AwusKwV5pOREKuYzBs1zy?=
 =?us-ascii?Q?7VSZkfYS00nPVeUSgX253JTYWkEFBwzNFcRERKNeJs+ZfyOmebDq3hjoubU4?=
 =?us-ascii?Q?6y5ljk26MF5eR8++8rN7TTRFJRW5BF3HNVmrMGrVk4CuJwoFlRBwtgfhgGiZ?=
 =?us-ascii?Q?Xj5bS1ZOFu7n460AZvXVKTvvbcXw+Ro14D0L53pC7MzeFe8IeYVEX6OW45yD?=
 =?us-ascii?Q?Ca6Tl98dl7PhpPx371WSUOe2TBc+cOXh3LihLLgZkrUQNMqgXrzpLH/PBkGL?=
 =?us-ascii?Q?zbn8eyb3O95wkNlAgvF+JT6YMJzWFjnUXd2V/VP6U6+zsUM/IpqqaKWAS3CA?=
 =?us-ascii?Q?gWvWspElIuu0PaMNv1atTm7m7BJR0FCkzYeQn18cJEqhNF+43To+52npsyEX?=
 =?us-ascii?Q?IoXWaWD0KuYXTV56ZLsntDY6vSr5iv2M/w9ymUcFCvxPEY7f9l4jqW3OMaWx?=
 =?us-ascii?Q?V1F66toj52egsWui/GHWp99fln6lh84QKPMy7Qs3+wA1LMTzacCvgWP1SOZc?=
 =?us-ascii?Q?ijmy7Iehnx04tOLlKNjHu3GpHJXK2L0bwq/A7YM4LwxMzHfrEkKHXcetH4zX?=
 =?us-ascii?Q?OtQURx1rAh9Xh61z/WYJnD1UbAfAJ9De/iwY0QDyhIpyDtwxViyIX+arM9Wf?=
 =?us-ascii?Q?zH6iy276E2sCbTfdCOUEqvoeLDrTxTLH65Uys4zmoPQnR65/gr8xYSDGaveJ?=
 =?us-ascii?Q?vWMhEFpdBVJNuFQl5PEaUO0a2FEDvRJT/r3lqtMll7AiQyUEYGHJhZBReD8R?=
 =?us-ascii?Q?BGWVYi4CblDmO6eSqb5XshPIm4nktzvgJFcF0vRR5291p0iXEmAwNO4PPlzD?=
 =?us-ascii?Q?VnkL+cOn9tSscwsT1m0wsbRLIpmahm0QQHOhlzgIWCOgTqT6pgvuHXMWTEjs?=
 =?us-ascii?Q?0zgasCTHEIY8NaFQDRM8rN3WTJndziQ6yz+fj6MvLtedIjjrVVZSSDuL7Tih?=
 =?us-ascii?Q?Lzxa0ZEX41iYHwCn8XGx8lS6pseEzXpu6c56BcK1IPNqwTnbOA1PW/bQrbta?=
 =?us-ascii?Q?AzzSZWJIDSyQxaG18hEj9JEn6sly7T1Clhdtp+QcQqI4d4hTBAdMCKoI6pLC?=
 =?us-ascii?Q?qxAcQs5fiiJbdJft1Op/7CuGDBpo85UG90FKAZiT5SUgaASQpPiAZn9ZIbgV?=
 =?us-ascii?Q?c+vTDB+UKV81amCrImFx88rTeBctIeIGDl46jI08CK7T7kCePJUVIE3HHR7s?=
 =?us-ascii?Q?N8MVi8E6k4/VGkL7OIzXqoHvGk229Q3Seh/bMSU5+/x5ONcf447go/i6wfJp?=
 =?us-ascii?Q?RbUTKxNd+bMaLOI5QGCZbs1VWa+ABOQf+PN3cCzZp4kcJDE8GHBuPI7s1vIH?=
 =?us-ascii?Q?0OLpf76iFLuvwZItsWI1hcZD5jCvrm6MT7cI5L/5bQUlFV0EMUDeiV265dEG?=
 =?us-ascii?Q?S8tCi0jjAlZoJx8KYOp3smoZUifQNdRwFY8sCwTLPKwW8LwnNPfoL7zIC7Vs?=
 =?us-ascii?Q?/7v3JZqqOdG0r/1FtihKGeqPEgCkJRwG+fbum+7EypbQFH0onVsRkmxO8dq3?=
 =?us-ascii?Q?b3q4UmrgPbXx9ambDk3kmklR8ggT8m+TRbdl1X3Xe9RHw+TvE8iqE9hYCtfl?=
 =?us-ascii?Q?zvxmN3PYnu9pMoLo4YGx02B+M6VDX5S7xasaIAzpze7X3Axe85PL/6Jrv55w?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qRFbsWcmrOMfzsNeE2U9vmYpek6Z1foIIIMIC3j03DfSpkO7fZhXCNKPXp2gqCo7bS3Q8/GWUO0DGt/NBF0rV/0EQ5fWM1Hgvh2fL+cddMD2lCRgBkL5IpOeO5DCvJiNbMBPMVX0vaAP+tSVFu9KC/PXAvAInJyjzEWotvJxsUPWr//fyH3IQTu2sUiJMIKqFDe6JSTiRN+KXe2olP7sJGaMkSE0egkpInC/vNTLhh6Hs3dP9/Adc+88lEG03WNl3JblQq2yVTk1kbW9kCiBlGpS1q0Ul8K0YzJlOMsMzIOnHtsNWQ5dtmdFOubbnabnRe/iNEBeJocq6VG2yYfRsp+aE937GSMRxcuVf1QQ0AlS+rHdXCxmCRtVME91S6vamxB26BI8ArZQPOdQQWYVSeWibjXEU56BZza+PttE34HR3+99iwWRKeGh0z+6YUo230OEJyts6+W/rw9ElGVtDi5s0EdwTX37sgVJDMZjKSnhdh/YqkKRpyTcUN6EWW1GFzeSLt8BCVk8g+ZyGcSbuCpM7I9f2xFRmb7K8+vWo6Xk9pTo6f0XsfZ+rVhEgwcQdPmEAhu1SO+yBiQgYldE5SgS2vc97VuxlP0uMPWrZnQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad025eb-7c54-4fc7-f97e-08de12d0ca5d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 07:41:49.2651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAYbzcHS2ZNmeyoXgubum8R4ECYzeSwCmHx6UTy5ZYFKATEfaHpIFHOJu2ZTuHDiX5Pm7kdg/YeK0bunOre1iSflrjlLvqbHsgr1anKbi1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6716
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240066
X-Proofpoint-ORIG-GUID: MqZfYk3cWjL79c8_Afc76aKNrMQr5lpn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX5tv7f0q+c76i
 82C1GW50c4+zlRzC5HqCAqGxzYAhPAIPhYNolTybOSEFm+o5bzwP3/IewhQ5C3oszC6LY189JWP
 610Tyfq1xS+8UVs83C117Q6O+3vh0kkxQX7VK5fHM+NJkL3Xk7MRSb/QLSto0hf0iIz9T5dlTnA
 Vthn9xI2rlvM0c0zfQ2QIxqs+vsbBH0Q7YFxIKBQwcVWjHCFCdfluX1q15Q7T6JF9Mr9KefBzwg
 7qOGCl15MO15ujiqaGQHktv3wKceWo14uHrGbcsaQu7Ng44xjq151NyHM9mtd7Gtdju9iS/nTBS
 GxAWzML0J117mYIE1D8ZRcrhqZSPHFxi3Qu1Vgv/3pfXUDZAVwWFtoXRxNwtJL/fz69HioMR4cM
 byqNIw/Zw6WdrU/RFw8kOUt+z7159ayT9Ipwy99PUhpzYIt3HR0=
X-Proofpoint-GUID: MqZfYk3cWjL79c8_Afc76aKNrMQr5lpn
X-Authority-Analysis: v=2.4 cv=D9RK6/Rj c=1 sm=1 tr=0 ts=68fb2dc6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=drdI2bGYmz5d-Dgk2eoA:9 cc=ntf awl=host:12091
X-Stat-Signature: phw9w67iy947dmbqjrrid5nw3tri7bgw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 716A01C0004
X-HE-Tag: 1761291732-481005
X-HE-Meta: U2FsdGVkX19bR7CmBkGTRysN40qqQ/9Ofg1/L1NpEf6PHC0O/fxwjdcyp3ZOlwUGaHuVJAsc8X8D/bJ8eNo3O+s3Ss6FqO8dCCI+Acbh6beaj4bPpPeLuTywpNeTRCs0Hf6RnAcQR7H1J0WCviJ67/LcNlW/+EYpVsMc6ALi+vECAPl9EOt3QyDizfe/XUmsktG968ew6ncqV2CWy4tCGXgSFLYE+R1qlJSwGmaorxlgQd0KLPwNjd9u0+5o++jngHGLn9Ga88G+FyB3D8jMU9N5zg8c3omd0G4fizgZHPUAKnaApxO/eMclWk/HDPxiFwgrQHyCErFd16POojChAyQCh6LAVa9x0bTV9GUU8Rz0J14C+9hjsKF9WzEG9xXVTuoUGZB6QYd6OH8smSigPZb1/mDR/EPmPNL+iGXMLZsyaI7DhXq/8A+0fx/KY+INRcGhDEQG5cQqxFoSt4vgRDDP9p//mg2RxLkLAWcj10UcBw5S0Lgz3i2nIzkIvG5o6g0JEX4XkmodJ34VbOrx0SgKE+gqOFhGNyUSPJRANhFTAs3vzotvZVEDp3ZGZBEKa+uS9+tjo3BFrgTNd+ctTjek2u9wcnKAdLL+rRmSnyiJoJo8Q60N9z8AOSm+H33dVraARzZiTqENHKpGa6lYA0hyKGVi3oYtXY+MpqSP5yf8sVIRQIUZBsYHI++lR0kQSPItlpoB/DTyKJh+gz3UGCqDiHYKKbeCUHyxFwg0IEEDGjlogPk7X/y5uauvpR2rUPr/1n3bEsirhxopY+cRmQjRnsV20dkPWl+uEzDCgG4OVU9++yvLCTMXZOBfk+YwNSdjA3tzHoH5hmqvcU/8LgahCYqzeq5V+r8QXXvUyvxLDN8/+998iZHl3ZrH0TQfTzMiaSK8IJwUrejAzhDfRT4Rv7QG0dYqECpQyGKBMLUYZ4Dy2VTSVy9ellLOl05kYtTPeNvy9ZYycr0VjOU
 jBB3wUDl
 KoMlm4FeK+SLfcb9VQu5XmV0ghXbirJnDlpRmgGUJxK2DnZ+gZga/tPGWbJ7o71rS+TiPYdkCtFDmB0YBILSLoDQlhC1A881dF1bFnwvtB+eHnnQaVT3OXd1nkQt7vZQSvnbiT4EoFqnl3F4EHD8cf0DCvYhs4d8TnCOFlF+u1nr7RYvyP2XSZNX3nRB1Z68d/NZO2ZY/WPHyV8Co51U0yarOu1CUnNMuRyvvuXY7ZXqg5kokyxnCqjzPhQU8Paie2kIn1kar9kJne1JCO8/JQKQGHZgPeMNnQtJ4df+pTnLEbHdS5k6/N4podlJ5Z/WgP0Gv4Kq3JeWMeTREY1zJttDN3+xTQzLIWYpEvLwWx8lmwSqvqZ8qdjBHNBQ+qvPQzx14UsD22+Niv0qH+hcqdfPBv2/A18dGm4/fk1zq7AxIRCkAJKWfbOrrejciJGVpG+QRszc6fLaU0Qs9srtSP3JzlCWtuLi2nKUffv0/MlVgnWCU0tnzffPosoO6rJSyFiGjq9QHELEGL26bXznl+T7vSrLXWPkCDipQ/xrSK/2NA7RfZuhv1oq8fvtAK30OyW+GDLOm46a390TI5yUBRCTmlue057D7a4OWOCxBmFt18lPg7dQuSgQuEuPUHXuD/3PspBFFzEber5XuYsJA/vmg8k4YKS2f1ifV51gvGEi8sXgp80JehQR/+GmxTvrgdxFAkGcQWr3VPbZjJYmc1mOa/jcK2ws/tR33/j2rBrf4y4ifLS1ajs7P8chdSymudP1+6wfx1j1Q2hC3Lhbz9FTXDohD2JP4CD8Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have a number of checks which explicitly check for 'true' swap entries,
that is swap entries which are not non-swap swap entries.

This is a confusing state of affairs, and we're duplicating checks as well
as using is_swap_pte() which is applied inconsistently throughout the code
base.

Avoid all this by introducing a new function, get_pte_swap_entry() that
explicitly checks for a true swap entry and returns it if the PTE contains
one.

We then update the code base to use this function.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/swapops.h | 29 +++++++++++++++++++++++++++++
 mm/internal.h           |  6 +++---
 mm/madvise.c            |  5 +----
 mm/swap_state.c         |  5 +----
 mm/swapfile.c           |  3 +--
 5 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 24eaf8825c6b..a557b0e7f05c 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -649,5 +649,34 @@ static inline int is_pmd_non_present_folio_entry(pmd_t pmd)
 	return is_pmd_migration_entry(pmd) || is_pmd_device_private_entry(pmd);
 }
 
+/**
+ * get_pte_swap_entry() - Gets PTE swap entry if one is present.
+ * @pte: The PTE we are checking.
+ * @entryp: Output pointer to a swap entry that will be populated upon
+ * success.
+ *
+ * Determines if the PTE describes an entry in swap or swap cache (i.e. is a
+ * swap entry and not a non-swap entry), if so it sets @entryp to the swap
+ * entry.
+ *
+ * This should only be used if we do not have any prior knowledge of this
+ * PTE's state.
+ *
+ * Return: true if swappable, false otherwise.
+ */
+static inline bool get_pte_swap_entry(pte_t pte, swp_entry_t *entryp)
+{
+	if (pte_present(pte))
+		return false;
+	if (pte_none(pte))
+		return false;
+
+	*entryp = pte_to_swp_entry(pte);
+	if (non_swap_entry(*entryp))
+		return false;
+
+	return true;
+}
+
 #endif /* CONFIG_MMU */
 #endif /* _LINUX_SWAPOPS_H */
diff --git a/mm/internal.h b/mm/internal.h
index b855a4412878..78dcf6048672 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -378,15 +378,15 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
  */
 static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
+	swp_entry_t entry;
+	const bool __maybe_unused is_swap = get_pte_swap_entry(pte, &entry);
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
-	swp_entry_t entry = pte_to_swp_entry(pte);
 	pte_t *ptep = start_ptep + 1;
 	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
-	VM_WARN_ON(!is_swap_pte(pte));
-	VM_WARN_ON(non_swap_entry(entry));
+	VM_WARN_ON(!is_swap);
 
 	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
diff --git a/mm/madvise.c b/mm/madvise.c
index f9f80b2e9d43..578036ef6675 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -205,10 +205,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 		}
 
 		pte = ptep_get(ptep);
-		if (!is_swap_pte(pte))
-			continue;
-		entry = pte_to_swp_entry(pte);
-		if (unlikely(non_swap_entry(entry)))
+		if (!get_pte_swap_entry(pte, &entry))
 			continue;
 
 		pte_unmap_unlock(ptep, ptl);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b13e9c4baa90..9199b64206ff 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -754,10 +754,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 				break;
 		}
 		pentry = ptep_get_lockless(pte);
-		if (!is_swap_pte(pentry))
-			continue;
-		entry = pte_to_swp_entry(pentry);
-		if (unlikely(non_swap_entry(entry)))
+		if (!get_pte_swap_entry(pentry, &entry))
 			continue;
 		pte_unmap(pte);
 		pte = NULL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cb2392ed8e0e..74eb9221a220 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2253,10 +2253,9 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 		ptent = ptep_get_lockless(pte);
 
-		if (!is_swap_pte(ptent))
+		if (!get_pte_swap_entry(ptent, &entry))
 			continue;
 
-		entry = pte_to_swp_entry(ptent);
 		if (swp_type(entry) != type)
 			continue;
 
-- 
2.51.0


