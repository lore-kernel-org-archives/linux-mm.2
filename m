Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29787CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF1A8E001E; Thu, 28 Aug 2025 10:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F108E0006; Thu, 28 Aug 2025 10:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4105D8E001E; Thu, 28 Aug 2025 10:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 27F5B8E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:13:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D16A7B6C0E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:13:21 +0000 (UTC)
X-FDA: 83826358602.28.276721A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7144E40009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:13:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mhMOJsyF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mk5AMWXO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756390398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vwuta87SoO+OM5t4cYBUjiDWzh1pb4vYINT0cG7zvRQ=;
	b=Jr/IfIaVbTgcoqkFTlaoxCzE8lvGhg451yn8YYvJfRJrCs1s+DeM+b1kXADwvCdKprUd8V
	6MIEfefvCXXR7BwfZIms+YVbD8jBrVWfLJA0EifhWn6w25sFkBg8YWlTJ19kB0X+4HUYQH
	lylV95LIzS4QvEHMkLih7ryhhaN0G8k=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mhMOJsyF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mk5AMWXO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756390398; a=rsa-sha256;
	cv=pass;
	b=5Rs9GencDrRmGrnX8+HtUBfNL+9sNiEORExWg+OsnFjUZURCGi2b1VBkdKwtM1lyH9RM+u
	iGEOKj9zHPnhwzuqhrXavYj2GlrtPiiXZkNw1c2D90zkV9v8Tybj5Zn/+AuYLbEK+JKVbO
	3mQPW+JIleVe6RqWKYxU9BolapuUVH0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SCivfP023326;
	Thu, 28 Aug 2025 14:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Vwuta87SoO+OM5t4cY
	BUjiDWzh1pb4vYINT0cG7zvRQ=; b=mhMOJsyF4ZM0QZhCZVoOyvEaz3lJh997zt
	8EfRJP4BhEafQOHk/kvboY4K7fqnVfNWPk8a+rEUNUCQb12iNoFX3TmEW2han3/U
	aAr9Cmel8NYzQ1MFeRcNYl7RNw/1fEGuC/BsVLlzeJ/gMob7Oyd+1odnGUDISO+h
	gUOZOwJtJvCibAPG0B1rx1TyBMCsFPo1NoTjRpQUzd63x4tWFc5BGttHLNr3ccNN
	KBX38dz23YeDd29cwA3H1ZugxrlMKKn4ejqimJdsNjKxlbq1OyiXxs95BZpZ736x
	YPKZ45p0NJ0h3g33lLodJVvcWKDRXvW8C3dZYxkLgdEZy3uwfIeQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8f6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:13:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SD72tr018982;
	Thu, 28 Aug 2025 14:13:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c1qfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:13:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VLbyPs3ltHjg7E/HBFQg2TdzwtXftnPkJh6NhmwiXQPtYg2JWSZlEJvp995/MHeKO4PgMcxIVzB/BcpfsqLdrA1T7xL/T21IXEEZtX1+82A4/tSlQxngLKQ6sY0cIS8DV1aEsao6fyC31kTQRKaWsSUa+fwoveL9/XT6nWUrTlxNYYRqaCuVldsX7Cm0vRgB5DGYCcaXQt6sypkULImIJqJoOEHZvZxUaOTPD52nRJhwWyiLaidjF416HKFfatXj5eTAelwopR+LaeuY2QSBp203zB3Nk9nCfzAX9MZy2orZEhNyLgvMrMyPY2p9c4/J0Y2kZtL7XPGLZr8crIHs1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vwuta87SoO+OM5t4cYBUjiDWzh1pb4vYINT0cG7zvRQ=;
 b=o1ElHyGwN7gJySuq16jTrba3V4z8/sXayqgWVmbjfpjIuyLwdNX6sNXgMy7bhyJijzbQW0ZsvjtqxKm3qeQr+1UsKt4Gsk++FUwvcYL81yYSmxmq5b7KLr44lqLwvwBh+a6EjLGJC9PeZl49S228rgmoZGPSNgJaP628r6BzQWxXd7qTMdBSyK3JphlwsfvvYeKVqnKIa3EIIGlMKWjqgkMxjBcKuAvDu8EU1l9RPVTsoinLDOdTYfNZ6GX5jQlDA8igwsSkvterf+d7cO2oaBcxN4FibltMtwkmmJxHbRveB5TraJQYCwhF+Pjn6G47UVOJnQbKvS57PeIFLZmEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vwuta87SoO+OM5t4cYBUjiDWzh1pb4vYINT0cG7zvRQ=;
 b=Mk5AMWXOspv2penpEB/ooDt2k11nXyIpcCNGMaKK7wUbOUfkHRX0MN4m8+NAdGKqqGy5WwqbJklkMX13C3ftavZkp1tCxcloKV2RCvwwQp7JuR9CGpXTrLVvKu0tV3pTdlttIijuKF9dL1nrPWdy6sEUn1BbqAgO5DaQrKhpZ48=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB4933.namprd10.prod.outlook.com (2603:10b6:408:125::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Thu, 28 Aug
 2025 14:12:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:12:59 +0000
Date: Thu, 28 Aug 2025 15:12:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 03/36] s390/Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <6b835163-58e4-45e6-920b-c0594f97d315@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-4-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-4-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0548.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB4933:EE_
X-MS-Office365-Filtering-Correlation-Id: ec218813-1ec5-4acf-6d71-08dde63cfdea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0CXq/eF9XGlwKcZqMiCdFEVb8Yb8dC9nBuDCTbegSF2am1i2sf4lRvxJSOKB?=
 =?us-ascii?Q?8FrLdKjC6Z+PyprktXtYOojs4MTAhKAoa+uWBuUwTacC8L//pP/FKcLGtAAP?=
 =?us-ascii?Q?Euf2k3NsYySJiFrCNPk0E4dScE+rXtII+plRhFRHgUMKSFUq6QZGcv8hO23a?=
 =?us-ascii?Q?/6/cVn/e1M2D8O2n9/WcJq8sK9XMpXtyF0BWKY58wf1rECwlxtLqmkuaqMw8?=
 =?us-ascii?Q?J5TGamMNDI7YLOtkUEOSAkt3gy2IFTkKNX/Ksp+mtDzbn0rOiT6hz3xVrEkE?=
 =?us-ascii?Q?U/++AiHN+iH8g4J6kWEqe6mA4vlRyjghGl1VBbMoLWSk4PYJ14XPk40C6hJx?=
 =?us-ascii?Q?r1YslIS8Zx6BVM191jcZNg2j2I7wA2LZ+LKGRTx7AYVIesPr+y8Al+PwmJLa?=
 =?us-ascii?Q?kxCCn5DpjKf0TcoKAmMjv8wdn3UiMsb5f+fFXxCWe2MOac2ADJxdqYdUBfQc?=
 =?us-ascii?Q?C18mWhUuoCsQf3mbQM1C5KcoEhxvG0qgCiLy0UpjyPUodGFIXZ14+Z+IAZbM?=
 =?us-ascii?Q?ueK3ZvyUnQ9JbtYBmq4/kpouzykiZftcT27ofLOn0Tblxw1zc7M5P6WVgYwK?=
 =?us-ascii?Q?d0aLVlAokBRPqxoZ7npBpguQgdKvAtTE1rPb4Xi/B++J2IOQtprA4whtHJHK?=
 =?us-ascii?Q?5UUrpLwo64FICBfu2cqDpopMICQgJRNYtv28RNm2QPY3M6GXaBCq16HJNg1G?=
 =?us-ascii?Q?WNAgy9bTu+UvBVTbzrzRIpiC43ja4WqH1sSm1WHQaMvgQxWgeZ1aEXjYZtBp?=
 =?us-ascii?Q?YKZ4gHltg3rckaXHATyAc7i6Wn0bX2H7otNLU1ewetlZFicjUDp0uLEsBsid?=
 =?us-ascii?Q?XwWJ51w1kwd2hSDVHlUPaKTqcVwqgZQYJgOMx8hcHd7gwKGzoM86Sp0zug37?=
 =?us-ascii?Q?8ZV2gjaYSkiTPvOp1pCMF0aRWyovDEWhQESBDlGhuTrDY8HL9QZPcXHV1VYK?=
 =?us-ascii?Q?0aiRXFnhygtDkbFyBY59S8mOmIxBXXS+A/YUj7lOXFwLd6oWJlf9MMBhxoux?=
 =?us-ascii?Q?MbzQ8O+4AIxY5S0VHCIWHytTO8EtHZu0kLLKbPEPnQxbSyCgpYFw/87N41wn?=
 =?us-ascii?Q?koMefnfTQh0kNufGrCc0l/i68PUSAbtD3epGXjrb29OHNVVSns6uyxBHFtYe?=
 =?us-ascii?Q?6Hmjt7oh1fL/EEqJ+ZiBZvn257ZD3Dm51GTSHVW462xyUKTygdjCbVRWpHcD?=
 =?us-ascii?Q?O6yZGStq3UhQp3jpbLsmjiIS1kC7tZNbmQyuCjtVmgLXjkJCabNDTbxEDH1+?=
 =?us-ascii?Q?MrM2XhKR49R6AjQXgLXQpaJfA2Js/iP7HFAGYSwF52DmNIF1NoJH9r1IYVMw?=
 =?us-ascii?Q?x5KievTo0njgrTJH3LRvwjFi1UGvryriyNnE3TGPZaT6lT93qwK1v64QWmsq?=
 =?us-ascii?Q?uV90NQiuSChZiidIoh9n3jAtXPevauDjKqzcKw/f6KomGqTOFFC0JoHNIngL?=
 =?us-ascii?Q?9LRBt4fFPho=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u8/ooHo50V3zIfJyKxVton5d0ZdFhVLThqgpYKATELEWYo3/24y9HIVaGw9c?=
 =?us-ascii?Q?SRokc4i5Lr2AVh87U8zN4V6AZGqekfYhsfx1L+Tj4a8NfCXxzk5vfBdSCzt2?=
 =?us-ascii?Q?481AkxqJlQh4MRiiIvsgH3VD7c/t7xb38R1FKSllTsuKZpuYF+jOc9D6eib4?=
 =?us-ascii?Q?n34DNcbPJjjm+wjAZAOKbGdJfonEOhzv3WEVpxuj2PDYrmqeHOxD81x0EVQM?=
 =?us-ascii?Q?C6yo9V+0yaxPeeuW3Yqw5262IyLlr1k9jlIFPpq5Z4FcKkN/3JF6Yu6cI5ZO?=
 =?us-ascii?Q?AZZGunE5qKDa4dmxNnRkSND6HqUQE9laX26OhrsHJ+neF/xXL32UPB6Rkdyj?=
 =?us-ascii?Q?sd3TUbUKlDIEdXVsJkDIij9GuIE5fBHhlZs0aYk/BDnttOaSi+fpYPSte8ov?=
 =?us-ascii?Q?TIz8UMBZiWa9bXhpLjzIfN6fRVJ/sgHqZYWtLdhqF2SQhY4K7lKpiWpjzbRD?=
 =?us-ascii?Q?3XhgL8XEYMdglW9rzWiFiN4FAcrOZxV/gecYGuguPMGzFPqtf+9JsCtpjhsK?=
 =?us-ascii?Q?8CYwcEMOIxhJ+Q2ALWvDTycENz99OplwreiZA1nRPlfeopDz7GxR5wrLoDua?=
 =?us-ascii?Q?H2JBCFi/IuYYyFCISmrZd+ppnGYt26Epxd1m0RbWC0NGlEnVjrGkEKzdK8yA?=
 =?us-ascii?Q?jwJ6j22TR92d4twPKAkuLwljtBGHVEZ0UjoA6aA4ITil377eKba8PeiKwhJi?=
 =?us-ascii?Q?abhNWc4meigTbnLSglSmGY9oG7S3oQWxOLrdxEUsdFaoRhybP2l2+FgBG206?=
 =?us-ascii?Q?zcXoQ44ePn8zfKIp+68t22dk/+ot/AzhaNe6Y4llSvhcWneop0WF1P97pRLH?=
 =?us-ascii?Q?BH2PjG27cD3oaPzY0tdeJPw1ByJactdstWOeVWIqz8wR58AjsZVyPWYFv3L7?=
 =?us-ascii?Q?/fEdRWB+5LpsJ3DK0ISxPr+IQ3Oa+H3661ayKHnzBAENg077UmZvRE4EC64m?=
 =?us-ascii?Q?D3LupbyDK90Hj4Yj/sZtUpXUg7oH0KYK3RfHAIvYoQeRV9ytlKwavg0FCg3U?=
 =?us-ascii?Q?5P/PJmUFKdDuLGSzxQ4QbPd8Oi1VDo5a4ROmEsBTKH045NELcDnSk+7nbkP2?=
 =?us-ascii?Q?1V24LVGpzEw624Z5VK9jXSLUXiQr0r/FCInF1y9QslrbQcx7q5f8momvZXUr?=
 =?us-ascii?Q?x+eXT2oAdnlUSV2qJnaKQCHwHBP2v1GkA1gqZPauYMVPhrtF6wX0W1G71hLC?=
 =?us-ascii?Q?tF0OJCl+il3qnTKgaPYVrpgTtPI4ybeiF9srJmsp7Qb1fqZhSH8Y/vjfGubV?=
 =?us-ascii?Q?FZmAHHeU+7fgDjuAuSh8xoiXiKgsxkROnfUmqhes7Sst/VH3w85oTLqpq5ZQ?=
 =?us-ascii?Q?rEwCy4iTAuZOAJxejV168VW06JlExb7LtHTmE5sj4NuU1DiAdMVKERF/fqmZ?=
 =?us-ascii?Q?77jEHzvcNQVvNZZlEDNQVdTjIEou2GmLEuEHExOMaQPqvZ0jSVJz7lXInZKC?=
 =?us-ascii?Q?qkS+wWqA+NEUZh3KIdQsuOG5gPLiSqEJTh3G7oaklx1+mEtoziwFGNL9VIG3?=
 =?us-ascii?Q?5Oh/P9ketEqmb+HHrxv9bJR4E1fZr/BmO+jINqhcFL99z01aA2Kz5XEEXIH9?=
 =?us-ascii?Q?aEHsTK0+gNXQv4xvQp89x5xhD4MtnK7Hkrz/3QDwoQgRp6RwzAXbbAsXfbrI?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UhSoWtzdCVaQrcM49wigN0lnHiEBLOXY9+BeGwvNrh5VynFKnfQgu2rsWANqLZL3mghXMCLc+JT7MWHKsVM4+iMLNIA7ap+TOLSTXyTYe+sjjguLwFxurhfmE7XyIo2ZGV1fvvNy19U/vETXX6RYrVDxPt4kG6xobbFCmeeYoOIVjm55t/wCYVpSG+UEtvVJIquV9/qv6Btm+uYUBYmEpiuekgiIqHHsIkeoo0rr/xEXZxC1CGYqGlGF2a7J+MWHFAhd+5jex+gsBWQQe7Cpje2gvT1pvRBsonvMc4v+zdv8nwIbg2UlinPa7TxyAJL5popSw78ebmTffaSrkiYPdYWZfDhXoXF2LlxX/X3el4gjHJwzWXsTEL6vjvA9Hg6JFyu6EGLRY171lHHafqwi5BsS5TkKsjiwICuLFiUHi3/HtHerMtFDYDEesHXxqfHhO+mTWsdwPzFLHR6NeQvwh/0dQ9CT2ulxTCWeNtCK0QYUUhVwFa0b1i7Ku4luD83Dp91DEuj/NLCcicPPaaTu9gEYU8UuBFd21OoLA3GeFIHoFUIAb2zo9Ho6k8v5/1wH5X48RjxCRwwRoG/4dfSez+JKYxA+y0g/RnxwGdB1X7s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec218813-1ec5-4acf-6d71-08dde63cfdea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:12:58.9590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SakifnTJ1ZiFEF6NCafu/Tg4g3nbinV1/ygobW4RB7wePRMFenYOoF7xMwF+VZ3zMN/G0eAGJWWo0HXfBlWBp+Eu+Pk7KUQHrinoy1xVbrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4933
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=977 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280119
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX6gCWr1BwrVuN
 tMiSez95+GCsWN2bXUFReodau+Rrgw0eGtNJWl7eC1sjpTy+ffa5Y4krhl1Z+oGjyQPCGRP2rHF
 NnPwl9BC6ls7qZLX7eLymfRU2uyRiITNrp6Yv/+m6bu9lk1bMl2O5Dri1kvhpSTF066lv13xwA2
 mFIQgrXBSNosctyZippYd8nkpxDJRllPED/tNSZgnkk9NFkj6knaGBLmTCqStZAwjLJYjoq1WGK
 IEEgMZkO29ISWIVgdPfcErutdRQGd4MhS2l5UbhLd0vb7CwgWGhVwyI0lRwJ+wHWE4lb5qKWV1W
 RvZckVJZ5O/QIMM6SsF3XiyQr4nT1PLDnRz7sotdsVJP4XNg6yf5WOLaOhIjlwW98yVbVHQVaYV
 ppjOiqdb
X-Proofpoint-ORIG-GUID: F-CIlqOJo7WSuF0c2l3D3jAAoWvF0WLn
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b063f4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=oT2u5JrfrMdI38_HYMgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: F-CIlqOJo7WSuF0c2l3D3jAAoWvF0WLn
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7144E40009
X-Stat-Signature: s4psbkyg5t789onps1xgia5htfypriz6
X-Rspam-User: 
X-HE-Tag: 1756390398-994056
X-HE-Meta: U2FsdGVkX1/j17YYqSeb2hfVqS7Wih1+Mqef/KJNgZKvkO+9sDRWtzH1V1Cs6lZL1Fgsz8M7Yt0fZGDk8ZcxA86vGZCwEsNmTRgcC59NX2fC1mqX8eepllaAJuTrEwo0pXOGjFmJi1dpcOe8gLgQjGMu5RAlZ4aVGmMtTpxNsslCivppt13ayaV618l8bdIpk4A49Gm2sWximwYqrqG4Ta5t3CQKh4ZAeCz7g7sro7br1IpueQPvnz1JLyk2NWjBz0GnThpLiB0jl8cnaYe6OlU2NeBsSoCd9A1TmRP23NhXNAlDLmmjshyp+e9qA2trWcyZ7WO9cG5yYcr0S9rX2EURybGmT4nEyc3TcTgUqW8ThvUbtmMdmuc0T9UwR8PDF04O+2MXCvovOFQgQ58EL4Gk4gOkRtiD6fFNuvpvOF7gasPp5umcCQPU/VlzllaLOysgR/piTSNOGMkH+N7B1ZsQ0AR3PoXQLo3J1v9coya7bzPB4vmLW8Z1a4wcoAq7lNOZC4qqCpSQYC7653ePAhZ6/ekTbd7fyTtb7kGJ/ValSNovHjteVqbZC7kV1/V3ep99YLe1ZnxGpsbFugH3Wm/hQITH9WnFfizqE81qGsXEAqCbMczdy/re5A01cEHyUwmRudve4Bz4Ga/eI7MKZx1cqTCl7oc5iM6eePZJVfR0Pp+7vSeTTD3AWcKEBXa+FON0/PQr/cMT5JbyY6Ch6apmGfLs0hgfZhtfTFQI6lb83SPA6OnzSGPDrpBq49zZjaxlfK574Fu+DQ2098mesFUCAQecoFycFDEmM55BFhyLz32ugPbibsqAw6J2O0vzfFRusquw3icLn/hdcj1KnNDAbVbVHFMJmmnI6RZcBrFF3Aj8zN7ygo0m4eV2MU9iQTj6xNPWr2ULDAF4V/2o1jpfybdAzvjhB+H7UlPyxECzgoqgXIS7q9IJcB9ixPOcXXLsxcx1V2XX0FtlyyZ
 IWwW0u8M
 XFvyGg7vcN0ImpqY0U0GYHkk+p96xcBr6KHrKybIqdhetTxQqvIWDEncUzMbHCKxRRi5D5z9YuFd221DWmavxtWNPed8eGRnqLDEmKYiK3AVUhfp05LjcjdZuynoymVdI/c+GmdDqA1jGSuljry2T8BCfL301W9ejEoy2AdfdRy5CMMswj97kjjW8XF22DLv6gksh05ozyiaxp3HZ2Z3ERVK+MuWADdkrYLVWi2ej38MjqDQ5N5D9cCt6Fnjx42FdLnA+IcXifkN33cTz0dyramP4+pVy9R5iW2nClvRSjI2dFiEde31TmAaEal0NjJATA6ALwLMGIRVxa57994VU6rwoBxp0Yb6q0aHWKMlpcG8lA7wk+KAE4wmYCr5lEHJkWJbgXYk+O2F3XAcnVuejfMWi9HTvZVDRry679MWms8PrnFGwyG9S09FQ7ycF9nTsQMReb+ELY8jgwRvHfSz3siVnOGy0DmeLrWqbnOFsnj9X6/5Hu4lWSYwQFOdLF3ipZV06XHVQ7MOeaZNXCKunLgmAk93aMD6vHQmJlQIAwiSqcfqav+ut9fJSzGGyjZ+FDpFSPdzSImVrOdvoSjwTZlGj7G6XCyn4OVymotgAdouFSM9Xpz8EVGYyYU9Lx/vpbL5sKrfMzvVaSGu8zxwq33LBaO9hD3Ryy+dQg8WdL2wSdygZf3Yafj0uhLGekHPdYsUDc9676BvdaBt0QYuQEgK71kUv/c6eTsOCbWPGmhvajHVkTY9XqMI+jQe60+UpnkUxc/QiPg3ToEzGFqH/nLMrGqoY6vrP1ayYXlmyPlPOUTSBKnRlxCVlz3C5toriGEF4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:07AM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.

Ah yes there are other cases :)

>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  arch/s390/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index bf680c26a33cf..145ca23c2fff6 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -710,7 +710,6 @@ menu "Memory setup"
>  config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_VMEMMAP_ENABLE
> -	select SPARSEMEM_VMEMMAP
>
>  config ARCH_SPARSEMEM_DEFAULT
>  	def_bool y
> --
> 2.50.1
>

