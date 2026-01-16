Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89C0D4A609
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4786B0088; Fri, 16 Jan 2026 03:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0822A6B0089; Fri, 16 Jan 2026 03:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B0E6B008A; Fri, 16 Jan 2026 03:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3D476B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:27:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E507BA1C1
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:27:35 +0000 (UTC)
X-FDA: 84337148070.28.1F4B44E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F6474000F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:27:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KlaetxUf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JI3lTWGn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768552052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOAgfxI3IxgSw9DyrnYn2EyrdP3yVIqT6oNfzhecS58=;
	b=LDH4xfGniyntYvpwrrSzJRXyBwxBWHPd2bYAd6EehQEzrYxsdyndaRCso4ZtZfQQIlNCmY
	AAvWNisnmiSJrcSnN14gh+vjYDm4xmI+0TcB35IsPBDAdlIl2F1LYaYjJFnZxkhkv03ebA
	1jh0qWuEc+mFdjR1JdC81BZxFQZT9C4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768552052; a=rsa-sha256;
	cv=pass;
	b=wC/Oc7fNExA4d/IUtBVNgPnnk09318gKooy+APzxywai48sXNnW14utPWA3wl0cGfZqbAK
	257NF9VwO1Z+JtvvatHXdt266hBci0L8wyl9K97tTgkoWV90YgJoanEbHThIIOQ2hECGau
	EW0EyC6YjNiB5UHi0zRDEQPntaJLbe8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KlaetxUf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JI3lTWGn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNEwM1737536;
	Fri, 16 Jan 2026 08:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hOAgfxI3IxgSw9Dyrn
	Yn2EyrdP3yVIqT6oNfzhecS58=; b=KlaetxUf21Xpt6cTwPqGRK0Sw0xb5WqrD/
	Pewdq6OiH24tGAAaGEiwemxpgXyM9NwSUvRGNbxVIgSm9UpUIY9TU6pnkX+cq6bn
	umZiDQ0vPasucj3DFsxpCeHynVtkbZ+jaIGkAegiW3jT4nqRDs4Pc61nSi5cF5sk
	y7ErhIIyNTODJbWqTV3rs0Pvbx2u7AbpJssEGd47xVhp+e6q24dmU6ev2KOaNTZh
	6VJS65uK5+ID/rITGZAtsFZLznBUYb7IuOL1HSCkv344QSjTeaW2LEqdNPUItZeL
	18xBjIZ3u8X4T6WYolDvrHOjG2nR5h7da+gEJzylIC25DIEGsTnQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb9mxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 08:27:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G7vlw6008167;
	Fri, 16 Jan 2026 08:27:13 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ccsfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 08:27:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qdZEsuPYhm6Wib01+Ejpi28iouiAnw8AhH6U8sjr9Zvyqgc1UVrlj8c5CilHF3aotWIMKln74izuytM/whU1VNrEMH4dHnJV7bLk31kz27nnBNJ62MzH2P6UuJ+g7fiBil2/2fdrtkBkoo5m0U8OKPHnrmkTHbwDIICjHV9Uxf1lhYhX68IFieBiX0juYgjwBafu2QhIrJKl78RGQV6MlykagLltDMl8SM56p/dJTDU+t2RRN3z0xyJBze1UAOIAxiOL3NRBF7/KlpCBpF3ksWFZpn077Zy4CGwtLms3Ts2Gt8176kSpbKpDa3tR6vbcxSE1kZD3O80O9UfSOLNgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOAgfxI3IxgSw9DyrnYn2EyrdP3yVIqT6oNfzhecS58=;
 b=AY/tiYGvZ24wPQ7//6ivUeJn4r4vxS0vJBE6uf79Gz2jTLbeE9h3hPlZtAdffVmY3vzd/dO/i7byWOOwzT9VGda2fxUdf/LyKxT2MkToZFuRryQpJySi/53Y9tRznuYI2ag6UL0M1djNSl5ALIzxGw1BaNJkzyg28rBonpNdFqpKURBBHCvkMJIFB2uO42IhIbG5uq9g2lOY25xbfslTqBNZwm3qw4SOyfwhxOfFeobqk27U4eDdhMVNncCMpBCBLWkEgb5yckrxo6LeF6GEoJSaH8pMNqG9SJEcOtTzkuEHKitdFrSO01JR0tct5KP2w42hh/LPuEbzWhOJUoG1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOAgfxI3IxgSw9DyrnYn2EyrdP3yVIqT6oNfzhecS58=;
 b=JI3lTWGntTxKiuhUZNynhVTSPNu4/pzUXs8QJR6cXAwR4q2I9nOzaJpijuSkl7LRktjDbzeXRUbQcGwMoXHpphq0oHYBzobPEPQCbHvMTMK3L7RerTym/g9VI9C8DKz+JcvSoTFVx6fl9dtl+YcEEbuRNcASyG3t86K3GXOt06o=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Fri, 16 Jan
 2026 08:27:09 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 08:27:09 +0000
Date: Fri, 16 Jan 2026 08:27:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and
 vms_clear_ptes()
Message-ID: <0a97add1-2ee1-4a0b-98ba-c1f576c58477@lucifer.local>
References: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
 <202601160925.VR8a2hUw-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601160925.VR8a2hUw-lkp@intel.com>
X-ClientProxiedBy: LO2P265CA0360.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::36) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: dd6517c7-428a-4978-5abc-08de54d90a9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oy3rrfsR86qtmQOd1187shgwzl6R92GO3JXiKifUzPM4biv3FleenI8rNNCM?=
 =?us-ascii?Q?D/UTzunzW5r9/sry2IHZggQHl0iRWQM+ve4vgEDrg39UxK9NmAs1IaeU806o?=
 =?us-ascii?Q?KaKCFyMn1FuXFSvEWm7u/BHaBZdAiUxRJhtegqmLLI4/gq0VIUeFpJTUj22L?=
 =?us-ascii?Q?U3E7B5kb08RS059obbr+COYd4l9XqMPQqrCOb8NjFK4Hf5XFOqWDVZo4a8v0?=
 =?us-ascii?Q?DUi2erUrfhduf3pKIoyMbckxOW7XyoH+2YnuNUhz4ODrsL91LSHFDKvHaHNK?=
 =?us-ascii?Q?t1+XTYGdBb0aMYNy61QX694mrmn1Dzs8kJzl7/kKQMY7tjbN9Iw/nCdcmJuL?=
 =?us-ascii?Q?mK7pMwqLYWJKCUvLPN42dgIXCwrRQ3SWfD1nWP+z/yrioeBRhL5A0E3ye2Ow?=
 =?us-ascii?Q?NuKWwTUSgY4ytJktUdbpi24jnrBvSenTds378WbOdzTmiK8vEDRd0nuU+wqu?=
 =?us-ascii?Q?X7GbtM5TFkuSxfpnfqVBr6gv7jf6bR81R6oHvDtalCEwz5DR3+ntNZFsdpqv?=
 =?us-ascii?Q?rHhD4WjXuU97sowGBewiLufaYlEM6kpa9lTZEj0HMEfsX58eXuulI8fEBJqs?=
 =?us-ascii?Q?pe0+GBEv4fJ00JrewmZv7MgoyNTF0w/pwJ9NgVlCyMcr7J1zXyGfh/NcYmno?=
 =?us-ascii?Q?Q06H6dokpYPkJtNgFdJxBDb6j8Ab/4belY10o8N+hzMsiv0LY3u/tFaF7/od?=
 =?us-ascii?Q?ZawJw6g9FEswdCJCyO+zH/19w4MU2BJzbyZLE5jFVglbDN4x4ktwazsg7smM?=
 =?us-ascii?Q?NRNdV07Tuuj9Bj3Df0TbLCC3+7a8Vm6QVAt8JZ+tgGtsGoxnVt2yY/Dk97dO?=
 =?us-ascii?Q?GHjoIEGKlALA6VYXiZVmCC3rZfkG//3ZHp92eQEUdkT/ZRzv6BMx50xl/P9a?=
 =?us-ascii?Q?Xynp/B1s3MxM4O3GrQYKCJJjEM49yXhVSXjIaEoQn4mQTTOn+PAkErxZeYcg?=
 =?us-ascii?Q?F8QduZ3Ew1HAeXGzFSnOHUr9De2maDfcRDzcXXyZoGpHxVYbK3jVA1z19Ys+?=
 =?us-ascii?Q?TPMf3hcWv2sO7xNJp7eidf0UmwITRrty7fMN1KezNUu+vw4R6gSlnrXUVDGX?=
 =?us-ascii?Q?uvpCrDaIcT+lbmTyLhtmqeBb4SxlaM28zHXHAUgLs4attgkydnMatQdbhypM?=
 =?us-ascii?Q?GqV6mESJrCL6Z0GxwbuE2QE3QI1wun5mRCUQ9OoYvzP4CWoDCmfgheZaPUKT?=
 =?us-ascii?Q?M3vyvnKOpNNPunBzJ0Nz5Me0+MDW8CyjxqkFzD/d8YT18OKx4Vz/urbFRnu7?=
 =?us-ascii?Q?bdamz9AohzkULdClHrYKjC1zI01/AtHfTdYLjE7OYAlJTkECbZ7syKNYikW7?=
 =?us-ascii?Q?/0vz7plKwHzQf+bmFE/7PxJJ5yX8pp/q1E5vilK5n6ExLFr5xYF+1YTbUwIX?=
 =?us-ascii?Q?nzSdXDVPY1Fgh2AFW/Gz20hS2QRbFbyfck81UjpK6YPP5ukUzVCodGpKlIOv?=
 =?us-ascii?Q?Jy+9YRpoSLpTnhBddoRLO55O3+NLWF58isa6ec5xtmGmDPM5VYt31tWTKN+6?=
 =?us-ascii?Q?3rNrgUpmBOmqKZwstqZQ15SuGAcHsf/u6/jxL3VQb7HVsCC0mRQw1h76wiqL?=
 =?us-ascii?Q?Ogolf5AaXyAWxDSTyrpAkjzDWA+Wmzi4ZOr5A9hf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GRUnLa27GQ71TAD+LE9hMH+j+XWwO89duVx8aZQrW6l1ls/5mLer9KS1CbZh?=
 =?us-ascii?Q?n1UxjxI4saTMMMUdQgugsKzkgNjZ3cOS/8ys0dq5wcX3kHDKl/Ynky0rCVWv?=
 =?us-ascii?Q?mfzjEj5zBmvskEv0STXZLqmRU0HLiDJuiVrGXfiB/k16hJzQ9seAxkJLol2c?=
 =?us-ascii?Q?HaFxrwERRkmmFteNtN9N3iJmlzHxkCZKz3+P93UCAjU4me8EC86YB4wHIWuG?=
 =?us-ascii?Q?z6NWgodGReU1mdZ1CQ6gfv5TiPYcjDouMQzbpo+OxD6XgqSznylI4zto5Uqj?=
 =?us-ascii?Q?PM9GHe76pWycmBNXEHoXzTlXGcDl7QwxtVjRAl+0hAI61q1oUCWf/RKviINM?=
 =?us-ascii?Q?2TVnAGZwUCNqoEs9Yqc9pfYfpn2DvbV5q31NrbOYwJ71O+sTF+tMwAaZ5vj3?=
 =?us-ascii?Q?wH0nDuPxQ44M9vhha5g6Q9ymBZBX1purQ3lkAClKI3gJ5ZHnyt65sHN7wZ/K?=
 =?us-ascii?Q?pL62sOtIpmcb21pylDptOZvcZ2T7EP51dEhBynFcz26aONK7IXtmf5th0kGt?=
 =?us-ascii?Q?HYlZSIcWB6ueZQvtQT3cNZSgOaMILmsf/P/TkoiDjBvVtfsf8jnVr3FJj2NE?=
 =?us-ascii?Q?czTtavUK96B5FuwbiPklX4IeAaBv5igOyykRpym0PoQWPNQ7H1YKC2Ty+nQb?=
 =?us-ascii?Q?3G1KA5trE1siunhzvQv7QQv6lKZhr+jyYmYBkBkgqUq2crhoS5om3ORkEnSF?=
 =?us-ascii?Q?5wS+dyl8XdFiA0W2yIWjqR1ajcTJNovtZkObsVEFufT3Z8Vmv9PzeZjN0NnF?=
 =?us-ascii?Q?KO94gnQsUT2P/vsuEJR8B//0OmdyLnaC1cZy42XBI7Ii9CPQifjsjVndu+Ty?=
 =?us-ascii?Q?oTpUasgUplmlJ5IiQKYmoHcld3K5jlqs0zw2rNA6ygQkCKj3UlpFYBhO0g1H?=
 =?us-ascii?Q?L6GESVc9B3gPewrA+R5VSRmu+RjLXht4aqJY8xHnHJ3+eNOGePbLhQnL0mC2?=
 =?us-ascii?Q?4h00RCnmTkUFEqnp6EBxdgFzmpKAMz19W3VeHA0TYHqoi5yb/gsdNUmsHKty?=
 =?us-ascii?Q?pFHEASVepLBUg7E6KzUT7RJpFbRj/qQdCjjpA/REaPIscz3K8m4g4WRhEJYX?=
 =?us-ascii?Q?wtuf+Icg4S6tyHli2MljsoW9B/qUe4jhb6mdeNwyY2BpXHuDVNLVy5kHEBux?=
 =?us-ascii?Q?G4hKnp6IqeV1FXHPtcuoyC1Yk+Zy27+PI8+fAJTFfsLBpX0aKaHfAyJ2lAVl?=
 =?us-ascii?Q?RXrzkgI9buYTvRbdUAn4ZCan1/P09LpH86ZXgi7gguQ1QCxGNZ8Pn7xxDTEy?=
 =?us-ascii?Q?W1MB4ccgsMYf64VNLdXcSaT9DtFMFTzv3ZJ88whka62gY8hCBufK1OcQr+vZ?=
 =?us-ascii?Q?JEssh2QStZBao5+XWS/0lNhrCqdlU9fRF7rfU19ZCXYvkkxHMUnKzlOBatYL?=
 =?us-ascii?Q?Jom/VER2CCR4lElw6W/CmqzOJb2gHd8dp8CfMvZagLpW6KjazCTtoLo3vcKM?=
 =?us-ascii?Q?DTCITuMqzUFThHu1lvlwmADWlTwP8oG7Tu3/IrcSyAh6LtMBF2lYHdXcshsk?=
 =?us-ascii?Q?8HwSQrupvo0QyhDF8Sb1GdQCo4JOuk6id/zNL7BjmowhsEmcustG0mhV/98i?=
 =?us-ascii?Q?a81aek9kwvACC621oEXbDz23CWbEBxMu1NgwA3EX+fkR0JjfIWIqMuNmOwAf?=
 =?us-ascii?Q?yPLwVfQe8QjLutBdNG6G20pVSdo3+VE0kUoNvpnX8pK5YDe1Qf8j2UXrOdTp?=
 =?us-ascii?Q?svlzwqNRHMRUSIJ5Gqk50HC1wbWnq2NQo/K11i/Vgkb830vVc2YLbkMdSCwY?=
 =?us-ascii?Q?UnlzL6Nmv+g6U+iVdRQMtuhGettbQLg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2TN/PJWipPOp4/8NvHhBCC3EF5f8JvyhC9BLgC/P90JRkKpBG3ymmso7TDli2kbTirMV+0K1ouzyObQKDLfnNfJesrVSjl9qa/BtnDht+clmOBsY6T0NYv7/M4EpWu/Aop0t4WcCYgxL9OkquBMhc19siH8PejcxieFE6tgaMt463MBHoQlEf1wQXz3E+fZ0dquKLmiY5Ec68On01IASwzSWLu/4Ce3A7BReLi6qaG5gfi8a24/GiNg3NOWKoxGEDrg6IOuARBAgjc04rnKo3McdVLFcwKe6rwhDtePsJHSxM3TNoPVcUKm6z6YhFGnVxZoi64OR1NrCmSxsBSLQGDMTXP3omar0L/ydy9d+WiynfyWibHIXbzmrIwy9VbRUnYea2goBYaLXWwwDXvHA+/SmVVctEqjDloPFn7MZ8AtPj1e5B5Eut9T1bHqPyVcpmGxeZTH+OniiOO6Y1KvLE2P4m+L5XEv8chy9+FC4bwld3zsCmvwMInq2UY3fCVVW2fmM3Xhwygz7sq58QAMmdoQivPolM9Z+zA2u4VDssb4rwEy6+dLGQdFHjh1uflMWNjx0NtgFiRGBZZ8gUnio1bV9VE++t6W0d8to35/JhS4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6517c7-428a-4978-5abc-08de54d90a9a
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 08:27:09.8324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UrHwiBfShIWoU4yJJ3Y0lchQ9oRKaBr5qoBLoLgbD8FByqjBgadLL/MF37+RswNm1t3IZgMqQtrIcdvuhVQ5D9BZdYgpHAz3DxPVkJoJsi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_02,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160060
X-Proofpoint-GUID: cWuOreF_hYTRLtapoDIzD2TqUXLIw5Je
X-Proofpoint-ORIG-GUID: cWuOreF_hYTRLtapoDIzD2TqUXLIw5Je
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA2MSBTYWx0ZWRfXyTbApxqD8UuA
 OkFMKu60rlECI5MtEohIbaTCxxz6UUz/gEwPha09TRnEIEpbP64AFzhreHsBZegg/I4kttsYrNG
 Eo6PtHRd25LX9T3OslcXXI0uK/krBFNnKdX/7z5qQOgv+l0x6ShxZADlmFxfY5Qv5WclYqJpz5R
 4M3aplG38cEyMVNZvtiqSbDonDmQiQqLCUA3ZU/v/UHT5M8k8YM+bC7HogeLn0LuMcjTjpjMdNz
 fW6KR426yzjtVUbUdqWIIUs/FWzM2ldsLyFhX6SG3gQGPCBoIZB0sWEtn9pGxqQUjD9Oe54mA1T
 R/QTwLSBBDrlLXuDIwwryWMYFwbxijBsES2wFehRIhuzaiFhDJq2j6RhyDh+o1SRd4IUKGtkpYq
 gnpo7R+FJKLk5SIyGmJCsNL32RjDJYUcAOlGZfWNykz2DnOunvOxh9IL7tzv3AztIsp9Nr8aoTB
 lbIcMG1Gi29p2mugoDw==
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=6969f662 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=WIYqKQ7X0FcCRfQEj9sA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F6474000F
X-Rspam-User: 
X-Stat-Signature: s7zyd8wdwfrmdojc4c5n6gehhm586t4o
X-HE-Tag: 1768552051-24273
X-HE-Meta: U2FsdGVkX1/LEJkHmlWPHgAGckUdTxyp0PAHtOmTruZIuoAgMHEro17J4BwFYpPFQkZv5aQmsCvLFt+Fr4ZgLvODMPB8iaFCk8olPV04TS+IZ48Sx5hA92Yby1/+gRBleb2WZOizNht+OpRoeCR73CeHetXoqH6+5fWjkJodh40suaczk/T5DzZ8ZdofWCK0gbpwSq0/wRN42/En8JUiTNiYTZfqOEm93zKEZNnm8SPHAClmoe1qJyftzgKdM7LjnWZczqfgbTKXrPXx+kpewgSOzHkEdaiv1sD+EaFvExCgaNcua/32dbrQg1PGwt9G5GZyDIv7nEDiz1Lzo5Ka5dWmiEXlnlHAwQ8ZlpAdXUD9wpWZb+DV0hWcx/RHaySslwlgUsd4pNU7bKAUzydQ/lj1yqjTg/RPgwzDEVLW6GStFjjQkHHZ3ju9hfPtQNpIrQwFgNqxChDg5cyr78skPHD3Gga3QbFCpgmo2BhH2qs99dLjSiw1Vxg5u2NpjZSPlAYGNVxHMt+QlHayrfFSnOVZ761zJMhbCh5ff0I61Wgd0qMBhoQydExbtv6N3v+vhDgd/bwcgGwxF0ObgPLLvwyvWDDPJsMEPpmlFwQ4HG4amXC2U22Ik00Mwb7U5WfYG6k/OySncyYUWCIc57GTQVxAzGFVIAwYqrunU/ppubY3RWiacytYfGlNcPhDVSE5AIZnHVtQHM/njdk2AwkPyR95PsykH/fh/iNubvjKcZlk4JcJUz7INl5mmNgc0rLU+kIOo8IONp6Z5u/FSh0IJer+xI9h4h4wCpZfkk8iqOS58kbckHW1ukq7Y8XgGcK+dGLZ3I185sAmdE5xuhrnILNhMr91hvLIVLFci0lUaUFYHmMIybFg22rANuvNE9rxTWn61yT9tYRtLsYy/rfrSNzJ9QE3Q0cP4jH1NfW972cWKC2TrJu5UBk1dVTs3EVCkBf+Qwbbw+bfzLxCONJ
 uBYi4fKw
 qtBCOdHLExzRAEo0W3nhnWPg0kFlklYS5rz/DcsM1URbd4VCJpbAHGJhpDsVlBcbQGPogT+iMvv81uHjokZQ9whKI16LtCcCAc5rf/ReI2bOyI39yGHXqw6pI1o9ecB7aVDtgtQbLDsuj5ay7vtilQLiKzhbMCh4ggmhqOHzS+7G1noPY+mVSH/1E9Bbjy6k9fv01SimGp5B1afitzDlQREkNUx9zuZTk59ed3evsExo9y8ILlk0G7uA7VHvL4Kky/wQF61ZZWAaC8ZCYB2CU6a7PuMF95tUnsTuUFaWXJV8yTyFFTJ99xp/iU6JGqSWz16ixB2p+6fpX7LKMTvdKepaSfR5kqrcyNILT7CTCuxzhBoi01ewBGKR2K+qocmaiqQtjoras9+nAWuu19337hXu9Ye357k5rdkxGvI06qVQusTAzBK/TlynCQyqga+TeumC0gXj/nVF3eYaFEZXno6BporkV5RNDwhqPb/pKz8Q2ZddC8TZu1s857rLFyK4IxjPPiLsWuSm+3sE9eFm1IHcutaagLKyoITSrqGj27a9shN3Sa6LhxXkbh2+/qUD3yJCVa6KTWn6jthIdHssamNLpQze+kLlTkSSEStChxJjP5MCfTsd4+Dr9hEAe9sZufohmQPtVtdU3hCCeDqXf0zYa7TOh2h6pDPlpqCitSGhpVQKFn6lmqBQHuZlORKr3bOgSQX1SjIQEXGdZExegWlpmhG+CqGH+q1+iukx8a2MCQmQVQ4I7kH7VuCFFeFFTr3jZgNUqpyYLTvltZlpDddbgyBFgMmsYHDOmlUfQHI7lhXgJ1p9ueHplxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 10:04:27AM +0800, kernel test robot wrote:
> Hi Liam,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on linus/master v6.19-rc5 next-20260115]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/mm-mmap-Move-exit_mmap-trace-point/20260116-023126
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260115182720.1691130-9-Liam.Howlett%40oracle.com
> patch subject: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
> config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20260116/202601160925.VR8a2hUw-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160925.VR8a2hUw-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601160925.VR8a2hUw-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from mm/internal.h:23,
>                     from mm/filemap.c:54:
>    mm/vma.h: In function 'unmap_all_init':
> >> mm/vma.h:175:27: error: 'FIRST_USER_ADDRESS' undeclared (first use in this function)
>      175 |         unmap->pg_start = FIRST_USER_ADDRESS;
>          |                           ^~~~~~~~~~~~~~~~~~
>    mm/vma.h:175:27: note: each undeclared identifier is reported only once for each function it appears in
> >> mm/vma.h:176:25: error: 'USER_PGTABLES_CEILING' undeclared (first use in this function)
>      176 |         unmap->pg_end = USER_PGTABLES_CEILING;
>          |                         ^~~~~~~~~~~~~~~~~~~~~
>

Suspect you need to add:

#include <linux/pgtable.h>

to mm/vma_internal.h.

Some arches don't define it and that header has:

#ifndef USER_PGTABLES_CEILING
#define USER_PGTABLES_CEILING	0UL
#endif

...

#ifndef FIRST_USER_ADDRESS
#define FIRST_USER_ADDRESS	0UL
#endif


>
> vim +/FIRST_USER_ADDRESS +175 mm/vma.h
>
>    169
>    170	static inline void unmap_all_init(struct unmap_desc *unmap,
>    171			struct vma_iterator *vmi, struct vm_area_struct *vma)
>    172	{
>    173		unmap->mas = &vmi->mas;
>    174		unmap->first = vma;
>  > 175		unmap->pg_start = FIRST_USER_ADDRESS;
>  > 176		unmap->pg_end = USER_PGTABLES_CEILING;
>    177		unmap->vma_start = 0;
>    178		unmap->vma_end = ULONG_MAX;
>    179		unmap->tree_end = ULONG_MAX;
>    180		unmap->tree_reset = vma->vm_end;
>    181		unmap->mm_wr_locked = false;
>    182	}
>    183
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Cheers, Lorenzo

