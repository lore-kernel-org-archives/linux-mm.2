Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0C52CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 00:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5098E0006; Thu, 28 Aug 2025 20:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254A88E0001; Thu, 28 Aug 2025 20:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF248E0006; Thu, 28 Aug 2025 20:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8FDE8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:34:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 869A51404A4
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:34:18 +0000 (UTC)
X-FDA: 83827923396.13.308AD49
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 57A3D120006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:34:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zarlx+ce;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="emOarI/g";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756427655; a=rsa-sha256;
	cv=pass;
	b=biIOlQQMbja9J++y8paxFrwbAx9C7EqoZ6/wp0X9Jk9jRM5NaGik9xe95cRUWWZUB/KW5V
	c1Pd3DJ9K6QierToTH02Z5rjGNcX492mxQDiw7gMFQJhODDfNo8n7L5htcsbXbREn1FaTs
	CQ2+lsS0/xwunugQo8UrlVV+Yzk14TI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zarlx+ce;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="emOarI/g";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756427655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DyMqQsodirMhp5DNnK4nB+KR1H4lpH2cgwvbru/KVM=;
	b=1RiF5Khyp+9X6My3AoW40aQhu79O3ZHq+srVXsTJjlRXWrbmxtli6ZsWDDjMHazd4i2Krt
	vOfwbv/vUpgRgUeLa4LzhOslK5wEPcCWwv6MIFED6KvLH+R3heiohnBW0zniarYLPBwrEZ
	K5CO3GqU2Ko/mxytNvYjQTm6pjtColE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLVaqM011099;
	Fri, 29 Aug 2025 00:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5DyMqQsodirMhp5DNn
	K4nB+KR1H4lpH2cgwvbru/KVM=; b=Zarlx+cesOVVGzGfqCKVXeGT2N3q2YYtDF
	aEvXwRd05zfgrg3HK3tb5FV0dlD3sIJgUil0t2dy9Vz3KMQTUFfO77glDCaY0iAk
	By/biWIV0H2HKyRvS4hWj4z6ql3/xCxPpUG46EsHaqrFJQU03A7qsV3aShw6Nl21
	bOwRlJoJyyYZKtRJlYutEkeS21VU0M4KuF5iNjQRUacmV7kDjuPkUAe9IaqP8VkO
	z+t9h+AAe1YKE5PqOPt8+yHgUMfHO6DXERmmOn+kqlFWE1crOETKNl/SFIsteuuH
	lk/38R35s2OqJbMmQLgANjn5OYf/mnAlGhOaaDj4GQtqh/MvdQGw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt9s69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:34:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SMsBQf027118;
	Fri, 29 Aug 2025 00:34:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cduym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:34:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F7a57bnZu/zseWkuqPQC5FudvtTaCqyAJMwuoGduaOjzhcawOK5+LVykUOg83wipeq01ImZUdSkICf+sGaAUe5fB5xRN9GlzBT8o5FpAZy1UaOmihwwZg229xaDiYjDslZG3RGZInZATeH+TnKO6Auef6pfBpU0iATvKNhH9y2vsRYL9nll3jTPiNhclxoa6RoimMbZUKnBby5R35py/hiZnIfN2jY8bgKKgc/TkhxAeBUZ1R5s3YX9Nq6Qwh5eNDY6pCWIiRRXlgLw6Tq3LZQN9L7hF6eVll5Oyb9P1WsoBqQDIFxmFpAoj4UfqvQrUhk/T1YYWa9tclOtYF37hhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DyMqQsodirMhp5DNnK4nB+KR1H4lpH2cgwvbru/KVM=;
 b=rInwaRROrpYgLE7/jqj/J3S/nZOPvsTT6DJDVH4ArCa7bC3y2Lasm3Aia/HjaYJ9VR38CEQWf2hHk7OH5QHV/GQg1pR/Y69W9kBS2a4DL43+7fpltwoPl+Dt5+QDx2/oE6B3OxN1lBBVWlcKEDSbB4rXR8Og3pJa6sEIC8KekR81VEUKhpW5M0UJ7VFCUj8LgAONYM7V1z3RtJjp86V8y4Jo2Vp3C2f9ETA0QOrnz+cKXLXBWegtif4w/Yj4vKrOjlWQnlVRFOt4ftUE4sjr9tNkyAUK5Qv2rWYlQu+SCBOCvUEWqICuJJ0my+4AzPS6Qm3RWqEVqnTevS4n8fFCtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DyMqQsodirMhp5DNnK4nB+KR1H4lpH2cgwvbru/KVM=;
 b=emOarI/g/t+CFfF230ll95NIeOpxsOx+y8LOHdhFNjDf+t3v11KKSlJKF4m13o3I9XXyFefeURaqnGy41GWJPR4ejObhI7lXkMpqrPNQhZfujBwGPCLVydGAckiP0VTD35Iegj8OlemhTleZvXNjab9eMBoVJptoUuNkZZITINI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7019.namprd10.prod.outlook.com (2603:10b6:8:14c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Fri, 29 Aug
 2025 00:33:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:33:56 +0000
Date: Thu, 28 Aug 2025 20:33:49 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 06/36] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
Message-ID: <3hpjmfa6p3onfdv4ma4nv2tdggvsyarh7m36aufy6hvwqtp2wd@2odohwxkl3rk>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
	SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev, 
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-7-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-7-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0419.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7019:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cd6101b-5c0c-4d55-5082-08dde693bd48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5sdMTlSW4ZbHbZPi6iYPDIb4dUriQ5FlER57cF4bAjBVsHPq1k+vOxSUwOHL?=
 =?us-ascii?Q?UtJsdxOEAplI1CYEB3Cbzg37JIsog7S8Bn/cbwWZMfXCmUV6AT08XOVyPnnJ?=
 =?us-ascii?Q?MTgRJ4C/P8W8xz1JbKX0+AN2lDCoTn8o02r9T/Eit+68kU46I4OvGkmP4Suq?=
 =?us-ascii?Q?4Sf0XKqpjcue3SNO2g0XQLryShlFKOhtvO5Tjwp4c71u4J6TiZlWltbomZpo?=
 =?us-ascii?Q?AqbUWq4HD0S5PxTl1jLjJeDYv+GLNbMjuo5Je4tKQte1vO4xv4/9SpPPUWLF?=
 =?us-ascii?Q?PF6vDxzp4vVM9CxTRlTB7MPZtmZhslJJqUepwvTSOrsLS6CmNEfVi57cY5Zf?=
 =?us-ascii?Q?gSQliam8zw3dK6RXUJ75b24/X1jj/e1U0ROFNaY7/CPRXmWnmkd2p7mdMB7M?=
 =?us-ascii?Q?nGxlBdi+7SEOZx0j3XuiZxvNk2HFrhEdEntyXqNu9kKHLdKtNUxHVwYQ9sge?=
 =?us-ascii?Q?ruslQ0NrUWts4lqvDpEftpSoKgeytykpXVxMKyfgZsYRmlctGKRpqhJdtmDa?=
 =?us-ascii?Q?1Mo5Hy74132zeJDPyUiU+rjSiTHe4kP9rrvw1i+1FFPsrJsNQ9l5XqNZQiqC?=
 =?us-ascii?Q?Lzg2NNVnoDLSGWvvPWJ9EtETlVAjAHz/fkMk+BjdUnQuMhap2WZimuJLegos?=
 =?us-ascii?Q?h7fWyzJQ81mIes/ZB4BE1TbLmf2EiGiyvb+wPeLyZerYjJpFi4Ca/66DdCA+?=
 =?us-ascii?Q?M+G0yqIWC+WsbnkO6//oFye46qnagBCpmj83WN9AUXXgcgGCtgY54hhFn9AX?=
 =?us-ascii?Q?ZpUkYkhy2osrRAMMUcYvwDHYpa2N1dY7N+6QYqI23ZLskO3AwK/VnvA42I8N?=
 =?us-ascii?Q?YXUoL0EJ4YWdT9ay7miJfygEcu3i7WsPdCNO4FEBMuClA+jcgUy+CPyUNE+m?=
 =?us-ascii?Q?hh2bljX/A7m81xB91hoTsW79K7NSdW053E1LcKAKLV1MZHlPcgZY10n90sAb?=
 =?us-ascii?Q?vCvp6KtkfpbIuFgMMpwonVZbFqlI0tTbYtJmnCONILs8vzTfDKZ2jmr/APHQ?=
 =?us-ascii?Q?N5ExBMAVf9AVEKPQoNwkje/BA/U1dptbIxZrXX57zN9e9p290n+5nff8Gz2i?=
 =?us-ascii?Q?Qv5BLT3eRK5OwcdXn9kAnwpHZmIYy5UZCGbJreLe8bxP7gGaUGTXnvyCuqX3?=
 =?us-ascii?Q?2E5Xi1B/dLpDs79+SSHnnMGuPP6m5AvDd9+2iiyGY6tmdHbRsfd3qzymaRoK?=
 =?us-ascii?Q?v/fi6xxnd4EcHn7pjMeEqX1JqSWit6tn45gERYwAfVxNVh8ygGLxqOeHsGwP?=
 =?us-ascii?Q?NioS+W1Mercmk66d1CJiRnEzxsmyB18MQ/nXbhLRvtm0YW2GjL42/HMCaTHg?=
 =?us-ascii?Q?dPTzhuOd9YwbMk2cJ+mWG0oT4GDheY/BZ3OCnErdxZU6d8ubw7IBtpPduvQg?=
 =?us-ascii?Q?vSg4CdFLKZ053/eecqKjtaEN5V8154bHE4zZ/htLQEvxUCgi6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nHwh9hpNo7Ii8lW9FPYYnoDONTRez2pJbPw6T7cJtMNrPB6jNhaBGUFMQZ8J?=
 =?us-ascii?Q?Js4YOfMbqqX8H6JYfuBSMyTaqfv08hxde2ptMleirxlcDwH+f4hBgg54AWT5?=
 =?us-ascii?Q?B9w6CVq5TTBU4YXAcdtfOepo9c+dqlhyy+A9avvywaBZ3ImVNfW9GLNBck+x?=
 =?us-ascii?Q?37vqbZLx0zzQp11rUf9OT0QPSdh/BoU/elzTyJxMgq9mD4dQfOkz1Hg33unD?=
 =?us-ascii?Q?PP1tbK1Z84YzWr468FLNnppGGF5Pv5qom3MVlTNWyyWS3FITOl+P6TDAJD29?=
 =?us-ascii?Q?Egqn7i5Xmm3sqLWxxBiJD0gZ4tZzxs5Q+X97+Nrjyd1HC2ictn0/qgpYRqPF?=
 =?us-ascii?Q?5lrv6braoyspxtk4Ujc3jFilxs2SUj63yCV6DgPu/orMf+Y7SQDFcwgqEq/p?=
 =?us-ascii?Q?OkGQmVnqtSgotZiFqNUZVsjdTNAylFFkyxwNs4E6dwgiDt1w63iGNv3wqewG?=
 =?us-ascii?Q?ZYNNyoM11hy/wj6VscjJIdr3jZloRenrMGXADl6apiVWKMfXs07jHSc4GcQV?=
 =?us-ascii?Q?umUoGqL43KY5uxo5cVtZJlg++J2H0g9BT0hGRut/lxA/okFsZdr4mkoskJGb?=
 =?us-ascii?Q?axOnI/VDFN4jSfvs1s82ReVSjWJ9iA47G45oYkCZ7fMl+gCGKFS/FAD0FIr+?=
 =?us-ascii?Q?3RqpF+q2EWj1hEx4V//77zRMCXMwrZxaPiZSa7coZeKzG9072RGDrE7NwoUg?=
 =?us-ascii?Q?LfsVmHxo5omvDWNFqicoCUra8OHf3D1kBaHYVUxkCiWQMnTohdx6oUq+Zlod?=
 =?us-ascii?Q?O2Bx+vNBDXNMa919I3bX7bsUby1pVq2QdLJmc3bB3aBqX/Du9VYTq66H57Cv?=
 =?us-ascii?Q?Hd5Xx83MBwjOKylARCP0YSbgFwXeDPlzxDzEtqr18FWfZVJbBLo000VPacVg?=
 =?us-ascii?Q?QtN0UIfUrdXAlie+Z9fuWIwK6AdAqC8sugLwGuFyOSu1q/ANySfVZg71rTL8?=
 =?us-ascii?Q?8rgbKEHMF8E/86Dgmw6Y27FJ5yMjFKy5pHWvMIUKPKj/jsA/RW0MUwE6mwJQ?=
 =?us-ascii?Q?VFZryClpMQILtHO9lfeTbKFk4tnwU/HDuFABK/hstQ9MbFNzR1LzwWMrHRoG?=
 =?us-ascii?Q?LC15ovq5CZwdBW9wmcUCbRVuRl2QF6YPU2MaIaPOi0PGu0blqeinR1BPVYnH?=
 =?us-ascii?Q?vq9tvWkcKApoa3s7k7GUqXKhjEpBxdQXrXE+Uz3ful5FtgZvq5YRvmOcnv6c?=
 =?us-ascii?Q?sGOxcg0sfA+zwehbyu5xsGSkZwHV5r6vJAy33ZDPvslBPonHbgNH1eTqcrAP?=
 =?us-ascii?Q?ItGjRaWxJ8FzT0k3P99ro2iDJICjiKWljuMajN3piGCmuAZ6vVlVgnJO8bG7?=
 =?us-ascii?Q?rPl5TYPcfTtPNdC8Q9t0apAlmcIcLtpUx3bOLUrDXTTga6B6v53B5zm43u5f?=
 =?us-ascii?Q?6RDdPa9r3b+XQuI9XuIqpcxJCj+EPnLfUaJRODF56DGPoEp+NvDUwVUZ6sZQ?=
 =?us-ascii?Q?+aCn1xtRWLvdWrPapM9n+JFvEVwGRPeK3NWatvyHLv3p/whropvDlXHxcWih?=
 =?us-ascii?Q?mrstq2UaD2bvikntKlWOW/O04zLXQt/8XPmcty+IfNKb/kmbhIiBGZfcBhHS?=
 =?us-ascii?Q?JTIeSmhvQwT9UBR/yfhsoAm1PI5FOxH+qv8cBeplRbnyobmqiSbFrWT/JekF?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MmIcCq0dwjHiph6do4CvQ51N7fUmZSpjxGL7Gr9jLa/oR6XYssYwztoUMeWdp9hAMxBZ9JFNqvJ4PC2Y3n4wgrQ0Vi7JZODFFIeNbvhDRE2qQWhGv2HBjC55pvALwddWn1r2yaoYdCJJPt4zE3NaZij6vmUmvEHH12TacF3x4SB9/PI/YbG1wRUawuPAAcGUbC5G7nEID77rhl5peH2XyWiuyTEnfsTHhpf95IMzXo6UCSEMw+qnExary+/iM2emrK0tILCQcASkK54nTVQQz7ZL2Mmp1WNO1OmXd4r0GIdHisD5HIbDX2wweKOu2w7BoWF0TfmGgxMFIaKviBAd5nBjUJ3gV4FBHPLPG/DbE0B6DB6hxdfzDxMZ8SIFDWYe9AZ102ES0INtZgcHgS3pSEfjJYuojl3aOiUkpkj+CB7i6CPQzDdfgGQmd/8HSsEEG4ZjPUUy+JW/u3OGje5pmimQxUf21vgH/iywOMMIbjKFNpPbVVU+Z3DDuVemL6aa50JezrG1/RqrITWNV6AGUE6CqNTykMy64lCskjAF3ynrg341dsGJLzzkhi3/HXFhJU7KbshwvCDGAr1pKuQ4l/sjK/d52tmW3wq2eyMntwM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd6101b-5c0c-4d55-5082-08dde693bd48
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:33:56.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 147TVcMbjvVC5L1XEEJZX9M7b/bzkIvRA4OOpqN7SL4QyV61w3efiwqfX31HeRJtQpP4vHDSJYB8uY9Utuhvxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290003
X-Proofpoint-ORIG-GUID: or3JsCZsHBNXAg3XvrmS9EB785PZfu4i
X-Proofpoint-GUID: or3JsCZsHBNXAg3XvrmS9EB785PZfu4i
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b0f57c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=JxS26EvbtLEMnJtdwgcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfXzZ2qyB5tnj8p
 7a3SHljsYClEnPOrMmjQ8+RZOYqWFzvV0vm4YkCxjDD+/VHruvQWE+DqpsWsnVggd/89urQBYy/
 ZP+ApsD3h/PYYMuff520bd3X4zkYVO5vZlDPQ52S1Zd95zTkM2QqcPqwQQZGyOJE/zbNGcgKoWq
 5XJJVy0F7RTbNLdOVBWDCN4wyeYS/NC8OwAU75+cjevlrqYkrrca6zi5btPleu6zcxfUxs++lUc
 i1pN3G19rA46lD514aPu1m/UPDEWm3WhSmab4on0i+Xy6UWTyvDczhepz3RCcsGIq++oz0MJ4hX
 sxB6SulVPSJeSqaNd/llQk32II0K10tT4crfcRuSyRBjy18LW1E6X1lMCRnd8V78QRpu1p6yRmx
 jPO67WC3
X-Rspamd-Queue-Id: 57A3D120006
X-Stat-Signature: ajpahkie41mfnpwybw4p9os3tm7uc93x
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756427655-130709
X-HE-Meta: U2FsdGVkX1+J/l7Pu8aKoDwWDGFzBwzR2Z+xkNGWlnTFNgFnqBWSjDCNrbgyNgnd+kZWWoPQz24VXp0K00QHDDKEW9WQbkYI1XB/HGu7XPQVBtaZRfBy7OlBgA/4/eWWbuNeyC9QNzLmIlA7uEFhTHZ/Y81X2sgKObDyAw7t+9n+Xms7ip17jFqGpdGFCj30dm+NAGRjWOAdaKwnm/fpSIsaGsheyLGtNZKWHiG5QhemdKnEDhUGcKBXBVGvrSQIFzOvUqrBNmPq1vNH3lMGg4WSYAgC0nqe8UO/pWrJ/OI39XR3tZa8p4m+Nwt19m/THHe9BZtkcCwYV1o78bo9NwGPSKHRvGevNhECwKGczEFPgiXtt0ysckPnb1oMoBLvsQH+zcW1iOVz7UzCApmaw/EIWG+d/SSybXnNsh7ULH/nRJiqoszIapgNZEA9wH0vNu/0VIFt9wDZ5GA/+Srl/lNDdmWPj8Jdvqp3CAETo5AWDYu9Hq+eukAGKnwrWbFBuAHWisBfs+RvuT9O3EEw79DR0kQX/n+Zja2iQuBMUkNJjkcKkDr7QDjNlJki4dnKTATF9tOvflnLUvq9+EJCEvJ6TdFfzg5TFD3AJzhK6KAi/Q+bS1y5MbatL5M/bZbrRSPcUNIlfvX2HjaSMy7w+fz77VAb6TFUvrqEouIv2QBK5nFyv8LU9SgU1liPYM3jytB1tZ0JhxAXLN8xNDp3O0I8AQ1eKG/DQCviiTIDMrx8wV5ZhdNJ5QsH+LEFrExHr/LzkRgULZkclHkahxAkSKnLsVsz/HODgU/LUGjXc6VEF7BSKdhtKm3OyulzD8JYQnWRqz9J469OiY33NByLqnTi/jdDkZ1MSYmV5OpG3ZP/Q3tQ71vF4MwEo24sUls+dR9wH6vHhIzozz+0Fhx4HMnAjUQbwFvAzc9zsZ50MUbDdR59e0XrKQ+la+He0mpPs+ivZKdFwsjKUyxsns7
 KNcpl0ej
 cLe6fMtX9GH8FnIkP6fMRYhjDlEmY4kZ4X8HSJP+v+rwt7gpD84WYO40MGu05qdAqr6grJNEHK/D76JPaJW6M2YeimnmR3d0wDIj6X6298DgNbbSt94w5rNUDEtHeP0bLQ8EY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250827 18:04]:
> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
> them properly.
> 
> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
> and calculate MAX_FOLIO_NR_PAGES based on that.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Nit below, but..

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/mm.h | 6 ++++--
>  mm/page_alloc.c    | 5 ++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 00c8a54127d37..77737cbf2216a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
>  
>  /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>  #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
> +#define MAX_FOLIO_ORDER		PUD_ORDER
>  #else
> -#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
> +#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>  #endif
>  
> +#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> +
>  /*
>   * compound_nr() returns the number of pages in this potentially compound
>   * page.  compound_nr() can be called on a tail page, and is defined to
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index baead29b3e67b..426bc404b80cc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>  int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  			      acr_flags_t alloc_flags, gfp_t gfp_mask)
>  {
> +	const unsigned int order = ilog2(end - start);
>  	unsigned long outer_start, outer_end;
>  	int ret = 0;
>  
> @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  					    PB_ISOLATE_MODE_CMA_ALLOC :
>  					    PB_ISOLATE_MODE_OTHER;
>  
> +	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
> +		return -EINVAL;
> +
>  	gfp_mask = current_gfp_context(gfp_mask);
>  	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>  		return -EINVAL;
> @@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  			free_contig_range(end, outer_end - end);
>  	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>  		struct page *head = pfn_to_page(start);
> -		int order = ilog2(end - start);

You have changed this from an int to a const unsigned int, which is
totally fine but it was left out of the change log.  Probably not really
worth mentioning but curious why the change to unsigned here?

>  
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, 0);
> -- 
> 2.50.1
> 

