Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63629CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 19:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B3B8E0211; Fri, 15 Aug 2025 15:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCBEC8E020F; Fri, 15 Aug 2025 15:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F0C8E0211; Fri, 15 Aug 2025 15:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A028F8E020F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:11:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41D9E829D4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:11:21 +0000 (UTC)
X-FDA: 83779935162.03.5962D5D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id E181C160008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:11:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VjWJmLI7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y+1GbJlI;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755285078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxa4HsQyjCDbSgSGhu1S1rdqYziYP9dK0uKaD8t38Ac=;
	b=t9Uqe26qJQw/BFC2bcmgeah1//cNinUmmW7VLhWTottaPVvV1AjZVkUUrt+tCESFVnEVBb
	bBQkzmkgaoQQMy3XDhvjaiB7p+Vfuz8xkKR7vaBa8cdthkzE63B87DrrISqgA0e8gKP1dk
	GKR4NezMUigZoYdkTR3xhD93foJ1v8o=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VjWJmLI7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y+1GbJlI;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755285078; a=rsa-sha256;
	cv=pass;
	b=Kqx6fe7LOoymCHB5v4N7V4tPHguiU5PJyWp+tmDD0qM9BHWThmQC7jHQWFx9fDu6i/VtjD
	Wvs3gug5Xd9GCAhL51htBeEtAc+pHnfh5qw3dZ2DmTOFVAVm5fMRkDHpdMwwiLUFahq/j2
	ZGJ5jraXq3sAgvCJZBtR6J7wLWosHEs=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FHlKIq026403;
	Fri, 15 Aug 2025 19:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cxa4HsQyjCDbSgSGhu1S1rdqYziYP9dK0uKaD8t38Ac=; b=
	VjWJmLI7QyhA5V9WBfiWx9Iczn1rxUc+DAEZ7y9rFwPoy0OS/IQdYS1GAC0M2Lze
	lDmbL590huM3nokI3+3gGhCsruOZlMhJUfTfU1AYOf17mMn6o6XZ9Gm1Hk8LeYNo
	vOZxIxCLF+CvvnN0tf4IhX9Rd+bYR4gHh1mDPE4xBxJ70BDlELmUd7RTg8GL5S7+
	RRYPsuW6VmHVCcweOCE1x+y+BMNnWe7BrQQq5U6RHcRk1bo55blqbhQN7Xg2Tssr
	XAebX1c7njAXoF2ApRIP/yZnWas7m8+TUCR7nAty/WZA6gza8yNF4vBpUX88O5bs
	SE5C1sgsSkuwby6r89VG9A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw454hmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 19:11:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57FIkCXf017404;
	Fri, 15 Aug 2025 19:10:53 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsea96v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 19:10:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAPslISKWwfnYNksEkw3udxhB7yGDJEOkiE7RiE3eQfX3e4PL08G93XOg1sQDTvw8xc2v0U8ju1yB+V4Z30VhvgS/JnIP/R5QOZxUbEFXiKjWtoXRztUomYTEXxO2HGs5p8P5Bn7tPjanBCs74V5ssMRMoPEiHQyzmh4RrH7PuLAwJvv1fQPmVvbhMW3Th3DR9uU/8QxVxWpXRYTA3/d0pIiVinKVst4omgB1Q9DWdwLceCRP8klPzEWgnvc8Si6mrtPX+VJJ0WXazlVwLU8lEL6RE0vnyOb1pYnYF9XQ0ukogQaIqAmYmj6uDLcnrRG9afHsc/WNkqRxzGWdVFEYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxa4HsQyjCDbSgSGhu1S1rdqYziYP9dK0uKaD8t38Ac=;
 b=QDVwSzBWidnQfphMHvDp/4e4hPzKaThuSbpZqwVWeaGkAXsVpeza8QksAGgmexl1QwUTnHTbF1Pk333RQI4zJbN1iXqiTXhjYXySWCm9CHe5k3GGZ56D5Kuo8pWpTCdx3xWURqMXGYuOWafR8b0gFTptYvKsDXcVpUMIUr21b+05ZfnTeQV3aOtUksA/NKSALXa2NXZWgZM/WLGPiC/FzR1APkXEYiKUzTaJim0XYmoO5h0TQHtPIpVgPG8tDZbZAO2lzBx3+jEFBovgX/rrQyYm+9wtmNm0Wide086AaZwZlLySFvDZZmO8UZZxxHG83ewn+rb3REcmuGPhZsESxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxa4HsQyjCDbSgSGhu1S1rdqYziYP9dK0uKaD8t38Ac=;
 b=y+1GbJlIHMKpw0mYbZ9BPtu3q2nfZ8WJu5aqClKe3t4csMWLIbzEYFvUA30UQWKx8e0DAHEzcjIW4/keaeiLoP99EJEVfGtGqYKhv5yZwXKosJS+KgvRfX+OsiSo4XoWpRMlRSCwuqIhb7KC9a4NYODuHF7+kEY/DxLISaZx5t4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB6464.namprd10.prod.outlook.com (2603:10b6:303:222::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Fri, 15 Aug
 2025 19:10:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 19:10:50 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [RFC PATCH 5/6] mm/vma: Add page table limit to unmap_region()
Date: Fri, 15 Aug 2025 15:10:30 -0400
Message-ID: <20250815191031.3769540-6-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:303:6a::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: 75fcc72e-26cb-468e-422d-08dddc2f72f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G5Oa7jjj/NG3EgdA4Fe54IRJixGrgMaPrY/GeSfcpfN+kdiJGTka1hvmX1g1?=
 =?us-ascii?Q?kSi0tTqw7FSAOTs27yNAqVKO3uFwxdaVCF+CNAzNUxQ5yjct1N96My+9I3mk?=
 =?us-ascii?Q?uFFxeVAPwin/0Or8nmxhmQH1Zpaa/Citqck4k8DVYKxnKPQvu7cLF4jG4uT8?=
 =?us-ascii?Q?kGvbFiICVSeZc3Ydnoe+DzNbEQA+8u+4V500Zc+8oFJTnfwjm3DkgZlyvyb6?=
 =?us-ascii?Q?ewRTLuVpcDZJIPvO4yebuvPV8KabaRsBeoMOqLzIqp/pCBLbqfE0HDfWndYu?=
 =?us-ascii?Q?p5TAiGfmlaFmWx78sLe/mqsXAG7gc9RfUyp8ewLYN3N+PZbl2fACHGowvlgT?=
 =?us-ascii?Q?F8bRXQ0sPF0vHX+H9w9ifC+LcE3HnirE/MCCy3PexhbcRa4PjK1NMFK9LIeE?=
 =?us-ascii?Q?8KfRd/Ogxjj8AZUkJJw4Z2fz4dh8sAEIeIMWFH86QPFRZjOx0Qdt/euDjXgd?=
 =?us-ascii?Q?z0nbRkpTExcYjzsQ9pEuEJPF9FULwnLGjcxiCGlmGR7dJ0I2woULNp2gjzOR?=
 =?us-ascii?Q?cOx8FUx4SokpfMaGhBvqRC4eCBJweBVKqCHRSKRZ6/JeQXPDQGel/ynBJ6Hj?=
 =?us-ascii?Q?faIvAOFhOoyHwDqOQRo5/5G4BP9nhgaYAPfzP2OIUMwCwlebA1aQ9ErioJT+?=
 =?us-ascii?Q?5b24rNaQb+YHNT+OQKOaba0crO/hs8IjyMfbTTiwDpyZAPCYc+47k0avD27e?=
 =?us-ascii?Q?DHX6wHCzSynhP5EWR9F1faBJzE0DGXsfQv9PXs5evQIDhDcMxyRgHk9MupbQ?=
 =?us-ascii?Q?g+KqABW3tIH7WSUpYq5YtQHzONK6baIhcicyOjhsqZXHjgrdtiuj9lvdcnmY?=
 =?us-ascii?Q?JKwixD8Gnp2lQhJlB80QVZiCGHSQ7iPogFN0IxPfSlqjdhl7i5bk1l2g3NiS?=
 =?us-ascii?Q?9AfSoh1puz3dQ6WvQ8xS8fmKIb3bnpsnxR0CdT9oaEy8bN+8g2uC3riwTFAB?=
 =?us-ascii?Q?r2XWL2vQXh2zK7RdoYAMKvvvZifwiOQr760b+rZCcqj8kUqW6HFc1OG+RO5Z?=
 =?us-ascii?Q?/dFJOz6UScZF1PcCSJIjiqpfCCJsj3Xb2qYkklaeJxqfVLbOkYLBKkazbDgm?=
 =?us-ascii?Q?RLFGt7eJC3LYIUqZe89HqYSZwjyhN05rQFYnHXyyTOBQXIHlMncFEifpFByz?=
 =?us-ascii?Q?ZxQ71dGXNhwjJ71mKiO6L5p4xlmigbqQIBVmblJt9xkhUiT39X+oH5koe/tk?=
 =?us-ascii?Q?+8olWoZQvbDtgVzfL1Vg9S4xXvjikOVFgT0dbauSwn8fkm/QkloNB8/m1R7N?=
 =?us-ascii?Q?QDxAFnk6eXiSdjN3WztqL5poKDUSyEvgkJwins9WGnQN2/njI2zULusp8poF?=
 =?us-ascii?Q?Occ6MnGEq5xRkjt7eTFPCaTN1NdmpfgkL9CHoTXmY8ZH2Q2UlMnoczUb0BZC?=
 =?us-ascii?Q?5sf8snKGok8BcSFvkWWs92O47zNdNpWZ2Y9l75goXCCyQdb/2OuIogIExOLX?=
 =?us-ascii?Q?9Ym4xJeUekM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KP49liB8kooayILQA0+LHNDdSmY6lfoD5J+1qrojRd0xTx8B5Hb9C6oBb0LB?=
 =?us-ascii?Q?CHBeOVQ6DLVVZqSBusdaQTZBnfRDMNsBm0VEN7unqDyKcdX+qskF2DLLf8R4?=
 =?us-ascii?Q?vzzkc6/JbnoCOE3JzQhitJqrypIXpUCcpitlmrq3tSBGTNLukCi6gSyhqCEg?=
 =?us-ascii?Q?DqI2Lg3z2vZBcJeP4gDzIz0DDVF/rAtBNdhuK/hGhJTZWculCcOE8LT2zBtV?=
 =?us-ascii?Q?wMGhau+XdM+miLzDD5fJXoYQQB/a64f/hD4XUE9T+TQpD/g/SZ/Gd1dFvVqw?=
 =?us-ascii?Q?FzbRD1Mnz60FHv82MV5H1EAa60ybezB18GJxSs9UGFLyFKAH5XGQO75LjTWz?=
 =?us-ascii?Q?tmw/QjGY/tPpbHbv8f0HwZaRnFM4rcO/qLc4MF4wZZvUsLt3widUBroqkAL1?=
 =?us-ascii?Q?kjwugOoS0AW2UUffYZys02+rMygZ25lviK0sEa9HPsbBMypwXEEKnG51eBkt?=
 =?us-ascii?Q?Tm5rs6V8UJB+moRNPJZeCYaa/SMdTWeMPO8HAVSzaUWGaZzpCfggnOL+sotJ?=
 =?us-ascii?Q?Fe1S/ya/yF6JNKFFmwkCZ0ZdFYX1vqgOKgFBU8IwdUv4T8Q5pma0sTcocj+e?=
 =?us-ascii?Q?NQ8KHM+iy3nlDZwPVQcEB3UeZ5saYEYplWFuILtb4coyeUTdz7e+RTjVN+/t?=
 =?us-ascii?Q?SyfnBowNzpCJGAcw1XmzwE0ZFph+HJ6FhlUhy/JIe6yEeAetnTMAZNQHlE9s?=
 =?us-ascii?Q?1alYiYgzICkqmLmO3FErooJ/Bt3s362Xx0aEqFe3KM2euJVvkSE2/nStRu8q?=
 =?us-ascii?Q?sxsbRy7hffyLjnGFcZMoMBu9rwTDPpljBEh0nqzHHCNoh9DunWwZ5gcgSUDx?=
 =?us-ascii?Q?lQwd4ZgD4SiJFO5zIfW6Ej6jk29Ka64DwVWcHLZ5ElNCiY/LaQaek/1GHlOI?=
 =?us-ascii?Q?pYXokF0U16pErKP2qvAzU4lzvxzGIwygNSa30jFWEG6Haq9F8YmxGgKGZ5rd?=
 =?us-ascii?Q?R/kcOBx6pnLn6KRde1etj6D8IhsM106pzudGMIauuINNjq5zWzRUCdvgH1ml?=
 =?us-ascii?Q?3MW9Wvf9f8wSGh1vPx9QATGAFd4KM4RHx+BfMz7QX4VmZlAso60wycZWyCvj?=
 =?us-ascii?Q?cWtPEWA7mmUtC+l1jddl7GPhG4xurou/lLkMyURUOQrHo5pmjny99i1Ew6iy?=
 =?us-ascii?Q?AGeXTx227o/NiJQs6Ju1qgDX8Dg1r0HwFpGbSZC8h1miEgdhSsLjVp1jJwdO?=
 =?us-ascii?Q?/ZpOx8ZzW5Zn/k/m56sdckfCIZz8SUaBIuy6GcTo8NujzvCiR5yg7yE1zz34?=
 =?us-ascii?Q?XMoY5oq7PEJG57y3jBSWXo4Dn6G8Ry1rZA6GoWI+lnyzQC0VTMHDQ/48IA0/?=
 =?us-ascii?Q?7rhN3B3XvW2pTlrDD0hE99UjSp3tqKsh4mTiO1GGaWGEop3F2f1CLhJGpMzS?=
 =?us-ascii?Q?96E1OdPvmdaw7TrILihtf+q9bUlgsaU3Yr0E6KhcxyNWQ9xEr+9EvWo3Pzxy?=
 =?us-ascii?Q?z5aB88ZbdXzQMRgRTa5aRqDR8gqR30XeZ6Ue38QkAdmcp+3Hy6uwuzEHOMRi?=
 =?us-ascii?Q?Z9QurcTlbFKRPuA/O8fUuQaBTjzUkTIUU84y0RgVzaOY9bvta99FQ1RptgxY?=
 =?us-ascii?Q?i4YB2ELUEse76f4LfA6lJlTiDFJDSgEJyw1JnRtq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zOUFkJweytRPLNntmzi6ERBPhwqy943gAlXniR61ShdvgpN7LnJlgZTqbkL/tQM/YSE3FBrNfP1hva60bn5kK4XfHBb9E9BH95WermL2TuYgDZOdKgrVULI2ekaYEysI/REzFizVL0XRf4oZGzx/4x/lTytbv4yYxDu9RJgGCCCpt9rhuUyK18CQ2x5pkogV+Ki2M884azpPjwrUoeMe6xhIRtHTYqUQOgf4IvHZQtgCUrLVtSaz+cKKqLjBsogNfOZvRchAAw6Qg4G4E6GSNVj4SiHThvM4I4Qsiv5bGo3xn3TBx5B9QV8+KH9T/1WFclb1YboFhAfWmA72Hy2wITX+EzQ/kFbfs5AkvmWYrvs6steV/PVAyNc1eIJfipJkqSoqqoh9vzK9pP27JEndZi11TIUuRJpX6O9ZV1QP5vbF71Tx+2VmdW6DL/nWyaZi4ZjOmqakZKWk6aWN/TLn8+Dn+hsypYJII2zdCeRwGF/hN0TjfESF7u0JJzcOrakK/7tjI+jEucIO9agWrjJlR0jGTuoRuCNS3G12m8N0Oaix1DV4LLlHf1cKE0QRbQ1RayBQun9RF++9yUH/Nj0FEv2mfGGbKNupcR5FL/sjmp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fcc72e-26cb-468e-422d-08dddc2f72f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 19:10:50.8026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PycBTi66qFrYqE8mSCjpEE0UxmqXsAcJwG8NsJZCmX0Eb+7yLh2rWGUGjZHgx21I5w2C18YGFtljLL4uUXgV2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_06,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150162
X-Proofpoint-ORIG-GUID: y5jD6G_-GPCNE1HHiPx6RjjQffioepNI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDE2MyBTYWx0ZWRfX/xW4smhKeliO
 Gel7COO2jpls4hYYY/+fkNqNP5EuLJOxfgNh+uZZD0v+/XPEhrKWuLFGxVCk/3juSi16Fvq1TEN
 bTZNk34Dd13YZjaXPNom8go2982GbBiphcypwlngYMOHhsz/q9njKCgQaS3b2ZdukgVcQK7kZll
 pDn5VnQ3BoukLhYWKbMweXpsBAfuN91/s3jsEVPGUq+6eGrezvl9e8dyyKz6+h2KJLbFCpnEeb4
 CaEuNoq2MmNryUqbCyOHbc1Vt8Z/4m+IcU+EFLm2Wm3ibC1I6OAe497ymhyaUalf+1TqjnvYLqw
 exOlDnFH7WtdeSaiiE6zkrqthpy9iB56l38d8QaXBuqRFPnRChWs4VKN/PFZ9JGLXqahEAN0Tjh
 7Y1cxkaU5dVpdOrpJbuigL1QikjIgjZEopqjaid1Ex0jSksWj5W2DxZWbue9uJM1RYy6SMmH
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689f864b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=mRhb7lE__WOmgSHBrkQA:9
X-Proofpoint-GUID: y5jD6G_-GPCNE1HHiPx6RjjQffioepNI
X-Stat-Signature: ptduggqzeoamotiqarz5hmyq854kt35j
X-Rspam-User: 
X-Rspamd-Queue-Id: E181C160008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755285077-91179
X-HE-Meta: U2FsdGVkX1/fP+He6VTH+m7WnLqF5x187h8IHG3TIz4cIJS8BISEAjPNAitJqLBUxidFwI/wIeYPDGRf0i4kG2Cxuaok7VwKYoo9cGmP7Aeh62+kqNg9MjcPWFX1H2B5ZeJJYahYCals/s1qhktDUUcucNtNxyowLigmQwqRW/Mz4Oxgd/bcXORfJg0nKfgAq/h/BDzN4W3dizhWuolBA0BxX5YdLj9j1BgKLiz0ZozyUlOm2y6LSbM33Xo1WX0TyROtschmrgFonanhiCZAlEc/bWoVzqAnhDdJi8wzMOnLhE1QXLzAmXRIf9gpsuFxSbj5708pLzLLLzR3PXvBB5WolaNgtPUz9gNEkhys5jDe/gOg3Nq40CRMy0SJz4/vtcU3b0kIvETc0Matrtx3X2efeXFjdt0mlMQElG23GHKbkqDTPVfsKAKUtOgVmxEviCrSulZ1OInnUwULbvyDi7C6f7fB9bbLzUzASSYSgENr2u2gRPUHr+G32h4DxeL5r0E7t9KcI/VpBL8PkkWf9/EttUmGmm0czceHG1D/fU9eNI/A2byo0r5Xm8OaLUr+5V/1Y+B7jzVXY7vUDBfdlDmvv3YGPCWWjj8mGhTWBo0IYFDSwcaKIzIre7fwOXeoRCZ0a0O2vWEqU6VZr4BQqVtQLdB8JQcJcknES1aqaRbtyt0yPijYyq/JeVyuAyESa7rRU6dmc099nCI0P3Vh1bmzKUvqEt1EbS/cWZS7yj4AX4ic/OmSvnzKw8xfsIUI2Sz7zJcNOPBeOacNUjsOlB3EBdXXxk2s5lt0eAFUkvcT2Z2Zy1ll18A6aSjO7DMl/40ROxA/OOcH2lnqWCXweJcYblhbEqmbKAx/cdRklW8do3iTNikHJ/jDmKCa2DXMoZePDAJsA55dCSq4wLdWJQZlbAB3+oi0XErRY3W6w98XV3E4chZYjDyG9c6UYFXSe9KeItRjWnAyKv6VdHq
 bwnd/W3N
 NHLIvCo9GPFZxUZkRzMFeB0QZW4Lh0W2PZ7zsqz2bqnqzXjRUyHhswf8mc8Lho4iO6M4oFn4yOK8XmZ3ZKsatOqvvZC6dZXcW1haqT1J1v8vktU3G6uLEVrYi/DwsEXUt94mrIye9w6bkhFKo7n4Mi5e2vqRVQj6ISPhz2z+sk13bl869yyxuO8nMortoy9KHD3FTJG9j5Ei7MBb2IKZIlJMBg5a4wGMhzwug5eXRKtFyDdb4LjcU1a3xxMNPTLI9c18zmXDmc7qU0/C/joO1iq0sDT0Ge20SvaW5Z7IJjo3mPVqz0TtN/AaoPNG7nfFVdoEi9zCJwIPxNel7QOJBBdqFFq1jOpKpVMe+QnN7y1ZHRwqo+XWUrhEbWAD3d4Hm1VW56d94+gTt4BnqXCobY4O19YRjmTc8wNp41hWYNUuZ+UhcUTy3fVZsQwGMyv7ZfZ3hNzJsbUgxuAJZwilJebA8ceVHUjzbmZRtCGzDDm1/bGCFyQsmRQDj1FaQU0utYysPfB1eP0bHTqtH9ISvr0cJu1UZ6u84DTmaUsxnQpP/SXo9q7ZTVMX7bC535RP65P/wBVQUZLiosu0JAMtVshg0x5kywhcKzaUBWUdMQhFlJ3h/iNr9B5Ari56r8mCA0Zdk+VpdGfhGpKJk8vmcjdZ3b3cfgwUhTeQHz2s315xZDnv68ZeuThdy/e2PwUGrmUYGfoQ/D1QdbxCA6+KrHetzbvW4oT9i8sDu4Nd+1MAvOlKenjXArbjMgl87NwVePcDIfLKlvxb0WMGo+lI1uNpr2P5dQgYQviPCe2Q8NS4ZBGxFB+Q8lGYqPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unmap_region() calls need to pass through the page table limit for a
future patch.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 5 +++--
 mm/vma.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index aa75ca8618609..39f3b55a020b2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -474,7 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
  * Called with the mm semaphore held.
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_min, unsigned long vma_max,
+		unsigned long vma_min, unsigned long vma_max, unsigned long pg_max,
 		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -487,7 +487,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
+		      pg_max,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
 }
@@ -2420,6 +2420,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
 			     map->prev, map->next);
 
 		return error;
diff --git a/mm/vma.h b/mm/vma.h
index 336dae295853e..ba203c0c1d89d 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -281,7 +281,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long min, unsigned long max,
+		unsigned long min, unsigned long max, unsigned long pg_max,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /* We are about to modify the VMA's flags. */
-- 
2.47.2


