Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E5BCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 14:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620208E0007; Fri, 29 Aug 2025 10:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0EF8E0001; Fri, 29 Aug 2025 10:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A528E0007; Fri, 29 Aug 2025 10:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 272E88E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:24:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0C021DDD7E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:24:54 +0000 (UTC)
X-FDA: 83830016508.01.5F99CCD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72A18140005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:24:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l3p29884;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SiMfdLO5;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756477491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZGfXDjbyb+OGF3VAjezv30Z9Vthn/0XzhQZTeuKsS0=;
	b=y8D6iF+4otVLOjWXY56115Clm1VXbbpYpqj+vSnl7lzh2JK7h3UMMzAEYyD7d5P6lIW5pD
	tzpxV4vJFJsxB4mwN+RdaBF7bxX9XbAmca0u5Us65Z7rVggFO5p0IVDQfXFMr9tiz8k/RF
	sA2jEVwuwUI1A7hZUPlHWCkRzwzerP0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l3p29884;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SiMfdLO5;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756477491; a=rsa-sha256;
	cv=pass;
	b=p67YCOW6W4lxfJLYoV9uR8Do33gh0EBHnhNODuDjTD0vfFKW5nP/SIm3IBoNY76KOjtKDd
	TR2LlrUt7+Vi5g05UO0FKshQS85KJxMnWV7EIBHUoMwEQ5H4WpHBuqoYeGXt7PclFtaO4I
	xmWvWm07ijfMOor0HICe4PJmrFnf+gI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCtksT014769;
	Fri, 29 Aug 2025 14:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gZGfXDjbyb+OGF3VAj
	ezv30Z9Vthn/0XzhQZTeuKsS0=; b=l3p29884uuI03vBX88YWABqTh6KGqczV85
	Hd18eDi/29qctKgaSEsYP52CExC7qbDxs1WC0GNzrPOJM2ZTCWlDa/fFNEKtDIFH
	lYEOIoFO0bmbbHqI3DDPI7J3dO3Pd8umBD7ENQjr8jBMsKxzVNzsDrAMSQcr0lXt
	7Me6caAjssLNUauHCA+52x28xwXV3vN9eBXmelymH2qJirgfH/d7N8785/HQcSon
	6JrJz47X6VDhgQU1RzG+LcWBoqkN7FIwjlOUhKYLRGR24VpANL+PXGL1jEmhC8LI
	Et5SzWXJa1qfj3cn/qxaWN1HWpsA8pnJ/BI4ZqgApATdCV1NhTkg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e2aqus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:24:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCY1xm004977;
	Fri, 29 Aug 2025 14:24:38 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43dacuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:24:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2Sw2zVb0Meb+WiQuUojbg21yXN6CAoNmRy3Onc/Dt5leXuauReVCUSoTEuDqE+KlyRTRfgmO8swTCy++i4DWzyR0Le6bVFEZgFbslBOUfQMo65Onag9t2kp2TyVl8d+nGQxl2PMqykr/8HJE7XMvuQKSLazu6QYVu40kek/0m7uDO1ruWIKOHBACrV414MMHtROkZ2v6lurCvzGeOHO42x4wrIErWLjaGCaTWqMbyLvq660xGraYxpj2BzCmNJhxXMkniC/1Yy2tpFy6Bg5jnXktVf2onoZxSZO5IsJkStWRqJZh2ZKqj1syk3BsX+QLZgtMKFamkd3rLOs275zxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZGfXDjbyb+OGF3VAjezv30Z9Vthn/0XzhQZTeuKsS0=;
 b=ozewxpmTo8KK3episWScMRMswbDAXZHDkB0N15ktkAGfK9YUyPXeXjYQYaB53UBUI6oVs64XE8Tux1Q87KB8rsA2svGdvyD4/saPH82cZaRedIEBggFxIvcAQRmnfQphunnpAqlzH09BduacPH2DgmBhcd02L8x97qJaDhKhpq76ExA7sqoBqz9ucQaybfOUYf++PqSn4/cX9PNORbar1rmEwKTK5vvrSBlS0GCLcvMlwXUEI7ZbjOy5KeN4yU2Z219gmM8h2SQQFChrCvJQRj9KKujbqJbkiPQHBd9Mmahsv92f/lUnhpI1kSkFFlKBghR3ZuTpYcY4IyBgcmS5kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZGfXDjbyb+OGF3VAjezv30Z9Vthn/0XzhQZTeuKsS0=;
 b=SiMfdLO5nxDSBrKsKp8xkm4z3E61NoYSRWwJvd58biiCZZe2gtafCLMzSOcoCv4WlNQZDCET+1ArnAZU3dKUMVyBRcAkxVQ7SyKktOvtFnpjPzHhO/LzGna30IyyUerYb3U8NFQs158b4jpv5rLUbvf4rzlM1e6wLkrS8QGywtQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM3PR10MB7970.namprd10.prod.outlook.com (2603:10b6:0:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 14:24:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 14:24:30 +0000
Date: Fri, 29 Aug 2025 10:24:10 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH v1 10/36] mm: sanity-check maximum folio size in
 folio_set_order()
Message-ID: <fbfswjohgqohj32ibefqp22rz5xvbwiry6nxusgtjoxm6waqal@4mo4gske35eu>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, 
	Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, 
	kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
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
 <20250827220141.262669-11-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-11-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:303:16d::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM3PR10MB7970:EE_
X-MS-Office365-Filtering-Correlation-Id: 52d091dc-a522-4740-ff5f-08dde707c46e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4wectUMaFmYqYWV+o1aiRksy3eIZ8zl56VzHcOsdfZmkM//I81/dN3a/dGNg?=
 =?us-ascii?Q?JoInkDJBHbyZg7Nut7egzdNdFErfc0LAec5ufzy2IBMa+T5SpCdMPqOLtURw?=
 =?us-ascii?Q?5zR01a6yApX7LRIxBWqvKwaCkA7TnFVmHJYiKiSEf+7tgdvRNsLBZwgoYibu?=
 =?us-ascii?Q?gh71rjQl0FHCPCVPOtFeRIaq3S5fnY4ltIw+A/QSgAA9Z53/EnaPVmBR7nEV?=
 =?us-ascii?Q?pCitbA2msNY4hAqmpSwsN2RPD1VT64qMUuqeex8TdkPJhck4ydQ+E8BTOEy6?=
 =?us-ascii?Q?iiQFM0Mv2inp5nIbi1/FoMIFXRrMjhX69A7D+y4bcJfWn0Jdt1jXsxq8HjUf?=
 =?us-ascii?Q?iLYW6FAckZiVUe7RTppZMZp1WioWtnJyPNwzfqt5SIqwYwEmuwQXMuNmFTI9?=
 =?us-ascii?Q?mpnWpRuTV9NIUBHu2RLlaIPRKZlVcvS7sJsYLlxKP7M6NwPd2mC/dnikC/3l?=
 =?us-ascii?Q?RAhjLVOx2YiupHMS3AXz8gkVVEo+EzQncHQqulW4iUqNh7gwEw+EKZP6Ugyd?=
 =?us-ascii?Q?9K6o+sTriY4t2wsEzzseW17gxZDhQgOurlaVW1Od4prL438Io+jwR/7iWLGa?=
 =?us-ascii?Q?hPkIcpw+RcC/pE3Ianvnk/5fXPjmVAdY8LHOjSg7Sl32DRZ+VTkqhyheoKY+?=
 =?us-ascii?Q?q5eix4EKUr3vNcrFwC7lYEmkeRZF/T/hykB9hrt+VjFQnAYzOcTqKGRTsY0L?=
 =?us-ascii?Q?twZu1apAmyOgbAz9bIOSykZthCWXFDxS9WSRQhvvH97sZOJNvltEQ03E/+5u?=
 =?us-ascii?Q?6ooUkzQYo2kE51I38Z6WEHq6+JqMAva9tl0aKZfVJ0ukIfqdzT3OWm4QGtN1?=
 =?us-ascii?Q?UqEuyFW5NxYIFVtbtfph/xPqRYGWvbvAqDe/y+YiBqYY/NsQgh67dPSn/dA/?=
 =?us-ascii?Q?N1auCk5kpzOWgFr/u4VqSAnkm6ObuR0IwnoKFwGzJP6zDTBuKNmKLwFgiK7k?=
 =?us-ascii?Q?s3CUKJOTcj0aLyTn23VScQoS2Db7wxi53+K/W3bEs/S6BYgh5sJMyA10lz86?=
 =?us-ascii?Q?Gp82M142mM9aEkOMAd7nc6LgvEli+HxA5mwulGXzo9vQO+dDNGit+WWOf36o?=
 =?us-ascii?Q?YLgMpvQyQ6FUxRHdVxUShvjG8PzWNOwp1Cs6fYuuLdRw+RknZDoG98MMi0t7?=
 =?us-ascii?Q?javnxRC3IOsUlFYBZLWe036kjPdUOWe+rjdzYtHCcltdEbV/37lNZP13D/UE?=
 =?us-ascii?Q?hsZE0lpqX9nw+d5xcoonqMp9q2E0z0PSDzITD+eZbhNHVfwfrynuGO6CzIbi?=
 =?us-ascii?Q?a2+irtuaTvSq9B/vHG5dby66bwq5r7NqoWPISME0p/V+Aap654lCYVZfZqNn?=
 =?us-ascii?Q?Hr2QZd3C8sEVBtG4uyrIAZ73uJid92I31gsU6l9jO3GqOap1isxrKEGpPXn/?=
 =?us-ascii?Q?2Z0t494ZKBwprGrF2MoUrJ1KH4byRPVtJxzOEvsiBwpSdouzdn3VzyYbs31/?=
 =?us-ascii?Q?toJK+jiCq44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sdcCm/2E+uwce1L6BovuRZrZslHBsLQYyDlzqHgk+bhzschxXtWTe0S9bTl0?=
 =?us-ascii?Q?Vq9sl/hVQFlJxOufSbnGzTdXb/W2MP3xweLP9cTjDmyx9Kft09/caboC2Edn?=
 =?us-ascii?Q?lq9RUOJBYz+vxYP+GzN34sqkUMnsy8g3b64t++gguBbhBr0t+oj5r5sPZ3QK?=
 =?us-ascii?Q?z70dimOAmFUBTOsLr7PHUXLOdQ7QrcrbjK0tLV8YwQnrLxM+nIGA+9PSuL86?=
 =?us-ascii?Q?O5OR39ti6gCk6ffAyFjWDUieh8KilV/tUC/0yoebH6Lc9Cg7B5mnL4oKR+Vz?=
 =?us-ascii?Q?g71LlUrcVQ1+1LnkQT8e0Mj02iQSsBmSHCIPSeMCLz6iI+URcP164w68Wo+q?=
 =?us-ascii?Q?FyE91OEZI6Iga1sN8RG/BVOikwWgcplHyAjCatm+fdb5exmyFMiPYVOkwRsq?=
 =?us-ascii?Q?dDrove8aKAy8O1aAfClBYsBAxo/CmyHRHIvFM392DcGeuwFzOPdlummnXgkk?=
 =?us-ascii?Q?B0kAlwNdXCwQ1LD2MQ4ZsK7ayt7LdnZ9nZNz6DZXYoYuxbseSfx19R7Hby0E?=
 =?us-ascii?Q?RWlxyUGrWZ7tkd8Y5rx9/WJoMi063Dtsj+SjZpFyYY/AEvVOfyBVJnkkeVSI?=
 =?us-ascii?Q?djxn1sjnEup4KSEHGSAFWbJNoz91aVEnAoEW2WfHfOYDYPfBLw+1r74o/xQu?=
 =?us-ascii?Q?mxw0irhdpOE+ioLtwfqyQWSk7SPBaUqDdTdQzmaJDmpuqBUZfC+VwHRDOL6c?=
 =?us-ascii?Q?TiZQMH4SEoNDlY42UY8jnShl8kEO//zhHPC0FNSQS4FVGFPDvQB9/R7n75YX?=
 =?us-ascii?Q?U2prIEj/+mbbU5ve99hK7iMVLMnkANHF7TlF3+YdGIcx46CIO89OXbFnciQj?=
 =?us-ascii?Q?RynPJky1Lkbg8OWl6aXYOBuNGKjSPwCdLpcMkgCLqOPuLWJdVCkCq2WrpshR?=
 =?us-ascii?Q?Coqr4LGt1gucg7kt1MHLB4dKSG6aAOVOxJM5LBwdlPImFTxFAM48fHSkEmzl?=
 =?us-ascii?Q?wI/Yff4IHSV8BH7VkNRNOc/98lnv70vz8qAkjYG1qMcYRVkp6VgH9gFItX3J?=
 =?us-ascii?Q?Evnn/grhM0LoJnO/kp5NXgiJSB/kmOsMmkyf7S+HtHGuqsGO6uHwUH6Zvljm?=
 =?us-ascii?Q?CtNo8r6ivX9OqIdSeHmgk5s4/eLEgDdbhwLKsTAH3XhwwMa/wsq3gBVJNVcC?=
 =?us-ascii?Q?SiqT+Nx1TOPDZ+3E3hGYDcM64xcZdkpYTgChz4973mVWFlHf5HmajSFhZKcs?=
 =?us-ascii?Q?UT08KVGaCF1tYPNU7mbzztNmGj3LpNLfxKRFeuoRBu8spJWJ+DUs3f0a6JlC?=
 =?us-ascii?Q?bFbsqDQXfRFgtWSp/AShwCFC66tdsTDHi2f703x6aLJlsyFsBlMjznz4rclJ?=
 =?us-ascii?Q?5uUpJ/95X7KiUJiK/Kutmdx/jJ92446iMixe3YjeT9I0LvCE9pGE950qGAsw?=
 =?us-ascii?Q?wrNv16pjNT75E7hnhKbxvSTTZmPkr8EI7cD68stISvaoCn0LOTNaCP4m/u8V?=
 =?us-ascii?Q?ulsdUEVh0tR/ZL+7I0pajiIlmZHbTAb4XGqSV9qyysrjeN6EEomhLR65QgRk?=
 =?us-ascii?Q?ChVh70Vbrr7goiDcxItG4H5jiqsABl2UJXGg0iuq8QkBbZzrK5LIoXgCCxMu?=
 =?us-ascii?Q?UmSpmK+JMtSc3kRs6krZUxaIgSKB3xskHErLHl48dtBDgyLoEDeSXkZ5T8At?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YBa8ZvktNmaxKQkTgGwQGQq1pr3JI8CoI3B6YDnR1oaupgeU6qzodXmOR+hawRlQRkgYcRUajBt8geNkyuC7ZlXiYwU+AuE1uJ7p3c1m5PFeg2MYbokPtL6Y/g/qXlmr00EBtVBUlyQ5ftVor9mlHFQ4LnMqBG4YKg4dDUlTYsXExEzibDR8gQn3W9h1Fw0Eem5nu4a3BzMr8cKJ0YrQkxUrTSZWzCzX9xPN1pe9MSMqeW6S9CXM9P/BWXJ4uMG5IoBqshZczVrjMmEdsLkt6NG+wne8cZAX3N9I17gkBpRf0dgxNhj+sDoCh8n3dmS9PqgyyCmIc/6kCjDkrMYhbW2T+ZM2vJunMT7La0rk+b9fIryxK8dO1G4Il4T9pAOypKYXemCUeiAW1xi6NFYObzHCloLUb6IYYeUMs6bF7xsOAX8/OMY2fO2qLzf5uzQReCU7Cwq3y0JyzMYJ15o3CxcuyfKSq29rfBuV4WiRwNyjScVS2WBCnz3EkputRNtihwRJOKDJVe4jmC7yJBJPhJfmkaz8hI4dpeXzym8mI8CoUqwRne7FUJGVZXjE1UZ8rp98jMMi6UKnryax3BoySr0pBjIpQEPyrGz8ptTcbZU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d091dc-a522-4740-ff5f-08dde707c46e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 14:24:30.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhZm1Iaek/a1MhLPzRXX5DlST8hrcFJdugqmzsj2cMZ5q5LnswYFMo9JoVjBOOjd5+EnuebgURU36lwlCCL22Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7970
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX6fyMu0StlB9j
 AVpkjLHIDVwe186EyDOTuv9VWa611XjG2z9qCA2jYQm5fyXRCEru/XoUCKGoiIps5Yirfd+3WlO
 hhbqE7Y2jKTwQZoM0duQeFgja/0oMdMf99gt0quDnWCFADihZ5cQJmQVoCVlMcmT+xvx7lab/QO
 jO4XIPPlxjvxE/37nxnOG0hmtEA2af5pJ3ogD50t2ideAsuE/NqfRPYFbs95k4Unsk7/7GoSmUX
 6NJ66C7NPWPIGmT6Vz7M6ED2RRiBeecCi1yg/TWRJ5hS/c8qVutVuIzUcTS7MAjm5gMm/DfvMGT
 E09aWcLdKmX8CoZ7t0u+YFBOmYFtF5ISgam30b2WQVDonzEj7omJzrY6nI28vnFRrhnmjO2ccBI
 FLtNiono
X-Proofpoint-ORIG-GUID: 9SMIN6-sVjjCbHbjwd4dIYLLyTe0Whk7
X-Proofpoint-GUID: 9SMIN6-sVjjCbHbjwd4dIYLLyTe0Whk7
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b1b827 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=yPCof4ZbAAAA:8 a=SJHYMh_qAkJed6OffD8A:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 72A18140005
X-Rspam-User: 
X-Stat-Signature: ghmsyc41hdm64omr469prn3dtigs3rbw
X-Rspamd-Server: rspam09
X-HE-Tag: 1756477491-834055
X-HE-Meta: U2FsdGVkX19PT8fMinZkI1S5x2vyzNvWUSUZwYaEa4tQFclQBNXunLui+FGzvXzrsoSNQZ0vKGojHhF1mto3HEDETUztjIpnIwCk8fpPlBPETxm0MhZ8ev9mrWFCKffLPD05UeDHa0rqUOsVw/pPo9ZBQhH+BSTrT136adEzIp7OENahwy96Jhf9lkL+7EvDhwmXIa5kA4EFPK5GGmrYVEOANVcmWqTKx97lgisEuTfH3rU6x+Egz/rvcJo7KVEDDHK3Cp7IN6cT1CKHWL2YieXpeP1B7qtgiURPRgtE2w5bwYLrMz4ZINwNyS+Luk+9mjWfuJ5GdietykeBUXcNrFaI+wmdiH0CV5jiSZ3b1DIBM9NYHpjmRsqP0orrMgxbI+WRtwpnfWgQ4ovJBqfVrN2SWAVWImXwTejDxOz5QBaMlQfQ1DiKNA9VRfIMma5wD7MdZx4ZZncLbKp/9tRlly9mmH5QH7PCGuiA8NUocG/L2Y5OAcxkGDibygOrq6qG2MLJ+VfSnK4XkD1gtjzq0dQbFOfJyLw7+F8e51ijYrfyipJyMFihCC8w6DcrATQdvgUeHBR+lsxAxYsf5QtY7wQIhcadz1lkIG6S/B7QLRnAAGKNzdQ4PLpvuXJQO+iupmB33ps0ghqgbpTmhbwq+1zdvf2uLzLrZtAmVdfj4BNcn0JO1HqcrVhYLzSfM0/swx2mrW/LlW2OHdCIL3C6+iDWWRYAT4HHXIKpkh1VLPzM70fP+zzZH+T2DyTpefNqKjwcz/grXDUCEZMdhQa3gM9WGInp3h4p9vUjjw+PmLEVoHa6TaB8BRaN5Pe4CYzpnmm7SU/2z1pHOy/ylmkVwlhF2d9fq5RUGqs6vaNrS4Kilnup/ZNrgQRZHWW03Gl9kBcbsYRTbM35HFec5F19iGovC3l8t87q1Xvd3Tld/xhdR8rRQhG6RKofSrYoRFj9EOJdNzba9FHPlIVpM42
 h6iuaOH8
 TUEig58noZ1bHPc2sA9Egd9fEZjq3J9QwhykNMDaGsDUdyiXplyGo174tliLNcyWZegrRseKE0sSytR7Ty8yGw7DlUOqkNtF2BpjK4zAalmSblSIxhl4oMd+SXBDkH+zYrBtJymgUsfXKT3YSqLPXpu+lNejAp5DK6+PY6aYCMmhdMpDcxvJBj/pnY732VZUgvhynd5IX6VByJabwkmH24CmdsOrkDw/8NvmVzPIIbVe6m1ClkpfjrULQn8QcNsR12J/qxyo5HMaghLkcHm5ba47Hh+CGGlBVTTjvzpBbbJnXUO1dO1S70yYQ2MU82X8M1tsBA4m0EPHI64DeMcIwMoz8gfUUm8k09s3vUAlcQT2rHSJV+Ag1TPwTedfuoOdkr4nhHJAnlghp2guV9AFhl2hxihzgj9cnB7BzNoFGYq7smXpzSogIQHzLAg2DAOFRM7sUUrczxezULt1oNXmLaAd6ovM7av/kGPZufaAC5zEh2qtl8uUdi3zTF3pW2SC+RPYeiTzW1A9XtxSeNgW6oxI2Sjt33Rr2iu0KchMhxMGYrZSDenqUyjoLMcTMr/WsXiaYV1EbqE5YAVkHrcdUZrlnBbZ9Xz5mYN2jU4lMyvX6sNFOu8//f/g0SJU2Nt+d2ftrjCbMPHZYWTv9aNLabWecBwUTHVCKlUhPA6aABhkRq3SPGK8Glf++BDpza5Yr5y2iiyDauCHDCKgRMjlPv1MlmZQXTZYkNGv2nWqSimlReuyc70jw8iWlpu2k4DotJRZA1R9PbrKlyXOferQT1uNg3I+3J2ypK2ReiCCmqaQ+hlh2GlnMT9wwSnIP3qa/v+UlrfKzRLa6Djs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250827 18:05]:
> Let's sanity-check in folio_set_order() whether we would be trying to
> create a folio with an order that would make it exceed MAX_FOLIO_ORDER.
> 
> This will enable the check whenever a folio/compound page is initialized
> through prepare_compound_head() / prepare_compound_page().
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/internal.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 45da9ff5694f6..9b0129531d004 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
>  {
>  	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
>  		return;
> +	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
>  
>  	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
>  #ifdef NR_PAGES_IN_LARGE_FOLIO
> -- 
> 2.50.1
> 
> 

