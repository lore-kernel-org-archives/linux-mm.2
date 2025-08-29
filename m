Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB16CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 00:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00DAD8E000B; Thu, 28 Aug 2025 20:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27C58E0001; Thu, 28 Aug 2025 20:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF648E000B; Thu, 28 Aug 2025 20:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCD458E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:34:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C0A711921C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:34:58 +0000 (UTC)
X-FDA: 83827925076.19.54D043B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 218BCC000B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:34:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=G4Gpk46i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="kv+qBy5/";
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756427695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bf+dZtkY792uznI9Dky40qn+EPBn7tT6SvULiVUBMDk=;
	b=xRNlBp3CKvclvjuEgzg604DBn9Plk0uPhZ49vtteb8YWYPxoGv8j/ZAd4ObOUL9ASmcowC
	P4SSx+9Koewg/Fp1CndmurHe5UxCLDRmc/VLjS4peD1cO0gr+nBdk3M3GpVkrnPAejzM1i
	c0GsLjCj2PAHsZIBeaWiRrE9A9oZKvs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=G4Gpk46i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="kv+qBy5/";
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756427695; a=rsa-sha256;
	cv=pass;
	b=gmSdMM33nTjD6g99QTooGGm94pJXaVP++zaeGhDoT4d1Gg6tJjxfCJDifxXUK5lLR3AwBD
	DBZs7LuuWhu3IsKYlW0uVpjEve6QWKAYrP10/t/DY08JC0OWfB6NvHOvuFPLh9wIl3iymw
	cJZ8mQzdRuyIRdq2z/N+p0InygSOWNc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLVCvl007464;
	Fri, 29 Aug 2025 00:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bf+dZtkY792uznI9Dk
	y40qn+EPBn7tT6SvULiVUBMDk=; b=G4Gpk46ice1E8+n9mChbyg5VkrSxqHV8LZ
	ImJIUIOypzONV53E0UWfXF1qsN7vQ1EGJAmtKJCd1KUI+BV6dEsbtkSIONOx9dN+
	rD390hgo+PHx+Ofmspd75E52LUeV9zfzR6hGV3iKty/2c1mPAjVZE4B4vsl59Cx4
	c47B+2qO43Hz01dE0DC/p5J1X9U5jodugkzOlyn0zRaw0DNbEJrX+zaiZa6wmLt8
	c4PvwoipB3msn/S5J9+/gaBpKjOVzpihIKlH9QmAaRT1FNDLhogw3s8nowhrRNWU
	rYGUjD2W3OaRTL6oFfGP777nhi847t+sn27iSg6/wEhUbuImZg4g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e29qa3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:34:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SNK8FO027318;
	Fri, 29 Aug 2025 00:34:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2084.outbound.protection.outlook.com [40.107.212.84])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cdvcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:34:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kh6Zn6DRO8Y3Uk5gb/TLb2jw+JGHWqT2pgIc/IKBmHpRVedURC8HKUcs0Hn1Dk6W/RqN5PQFY06CPzx7sr2EdCE6/nCpQ5UZ0p30/3Mx7wVDtc/puIY3nw/KKtfp7+p9Vt2AmA/gzppUgamfM75I764q4wllrkyxyAYmi0SLU8UWilsSIkGRvUeyOFoEMldI3tnuOE43MkeBYg5mMAZl1duNbC4w52mjm9qMu7/mwAFltVZxdq+0RZH5rG2m9XyjXiXwVtFJFaHcJ6s6PiXlbYJhppXSLbx1mSE9LE/nwkpmMXz2mCUeEH1zeWc6goWudVWnXhE9FVVNOwYguBGDXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bf+dZtkY792uznI9Dky40qn+EPBn7tT6SvULiVUBMDk=;
 b=RBt1amcvCu3DnqOHdNoW6YJqVJM3f11Z7xDcuw2o3qDfWOPi57Ea9TFYfARQt1M7IKOhXpbHy4lY/oLZtg+ZBbMpDA37TEt+YGwU2YRZrcC9zL+P6TOCAVksmBTyu5nDL/fz1ht8id+P9Jvt1+9jLajF4PzxQw+AiRL2eMhLcVTxzjGtUfDoXwef4czm3Y/p5rmqKov3tQK3d0jQpuDzoJqFW8+GPSFcEdeqqY4ClDbQrppyAaGrnja5SQip7TIyNzXfJaTKrVdyW6V2cYlj3CLBVYUixeNiBQ8HSG+C0fq8X+e5baDNShEumdiVZCvoPuWwJoJdz1hrcxNku8QNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bf+dZtkY792uznI9Dky40qn+EPBn7tT6SvULiVUBMDk=;
 b=kv+qBy5/jkdN5FQ1ZgOz11EuYBmPOrTO9kKSvyOzyBkMO2mcPq3URgKMp6VcPJGGr21zqmQuS/xezsCDBv1yjR49O8mjB4hJ7cfS2Rbh+TVHJ4Qwq9LWae4i3b6MN/Hxrfaz95cWctuF9zP08n9OG9DGX/qw21n0AqcmY4IELaI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7019.namprd10.prod.outlook.com (2603:10b6:8:14c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Fri, 29 Aug
 2025 00:34:37 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:34:37 +0000
Date: Thu, 28 Aug 2025 20:34:31 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
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
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 07/36] mm/memremap: reject unreasonable folio/compound
 page sizes in memremap_pages()
Message-ID: <4rjh3rjhz6c3iov3ukkrhwm7yyma6vfsbfynrzaciw2jkdw3f7@mipp5xo2zqbe>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>, 
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
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org, 
	Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-8-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-8-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0064.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7019:EE_
X-MS-Office365-Filtering-Correlation-Id: f48655be-60f9-4c8d-48cf-08dde693d565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u0edYF7STD20ATHZ1jIw01TST2Ai0Y+jMGnTLvOnfUKcM7G7YL7WGNoHK253?=
 =?us-ascii?Q?bzJHntFFVUVH0bwPQq5FAQ5OVDjAJNsKJWARN2tXNiEGjjZPpDUIwWsRoqnS?=
 =?us-ascii?Q?0ppKM8bAoMkxlP6ckARtiuJCnDC2+JpHBHBtp6SamNhtg5vxEzdcNZsXJsms?=
 =?us-ascii?Q?D5EU3jRaKDkZ2vVWiqfv1uaUrYfzv3udInVMZqX+ceNzl5o6mqhznla4YHzp?=
 =?us-ascii?Q?LUPdZfhKx8g2b+Z9ubvgVwvOTK/ryy7xiq4J3/uPGMqk5z8ndSk0xrRg+jav?=
 =?us-ascii?Q?QcFErQN2kJNTKI4Ag0Z2HNZnL//HzOrv+0PO1Xr8Qj3tLPEzTr30leEGjM3w?=
 =?us-ascii?Q?GkI4Vcgx5Tps/NERFyLLxHqzD+MHpTaOWxge1mPdAeFjyggz9pBWDc0+o1CY?=
 =?us-ascii?Q?pLwVC4+jeiBsJXkUMfYpN+9keZUjIs2D1QerkF/miCPSRDTXaiXbAqByOppa?=
 =?us-ascii?Q?qTDutptiXVIwLtHjTA798lO5xLFkMTHvzt7I84rWKWSkg3sJ5+1IOHUUsm6h?=
 =?us-ascii?Q?2x4DWsNT3typDDtjBhd4MaUbJJ8wb16QatAHo+BFb//iIuNFVNfPmjDP4HY6?=
 =?us-ascii?Q?zNhkSzXB2hAoKKPtW88zpwmz8al3K9tDhGvib5e04qzR+PJ6uNd6eZy5ddZE?=
 =?us-ascii?Q?qPSd0sTQHc3hVcgW89HB0tNUgpr/Zue7q3tO+c/y1LHIeJe0XRs7Rv/39MC2?=
 =?us-ascii?Q?wOr4n64ntBQ0KGDKbcwyyZbHAHrF/krTdbli9qAyOJMzHcApM1B5oYdU1SpK?=
 =?us-ascii?Q?8wrZkeiZN4h8PRLlTvr9eBpTeByDplYEsqd1uNqritALVoAB4kQZqo3/D5GI?=
 =?us-ascii?Q?FpM+AWr4NFuFKE6xZheSLQ67w8DU+45IehG/SELtuW3dAWWgUWR/U4jfViCh?=
 =?us-ascii?Q?etfR2Qd7WxxX7DjmHm0rZj8P38x+2WliaN4thulf5Mv2iv09w9Dtjiq0ei2l?=
 =?us-ascii?Q?tWwEOFF7o2eGfyxgOyRPozNU/5ZBFrIXpaewCgLCKLnWObx6ECU+xOrmZGIp?=
 =?us-ascii?Q?iCU+UsbvSarO++sFZUvVg3EOchJbaIB/l+1CkXzuoebnCaApd9m+3rCJozZU?=
 =?us-ascii?Q?Vc6bf3Ift+UkuLLDvBVMbjpylXO6eY+b/UmqmNn3vUcB+IOBcBe0+nmFXf97?=
 =?us-ascii?Q?DukzZNMv1vPsWus+Aa+01dSdTHKFihj5TiERz27S8G4hlFe7bHjb+YX9twfl?=
 =?us-ascii?Q?Wn91k5+ZUnCiRHvYUmYQem7cAYn7LQHIIlB1bZ007jbLtfpeZRL9LVZ4oV+Z?=
 =?us-ascii?Q?aYzNs3WGdJi2Tm64o2UpsRkq2JUONC2FrWtDzrjfbJiZfTJy79WRCD7yqBj1?=
 =?us-ascii?Q?K0suClL/rsj+wXrDexemsG8GBS/lOOoB7i7R0BQhEuzmU0bLnQP2+XiJ6XmS?=
 =?us-ascii?Q?SZL7c9G8ooQCshkzoV6tKjbOPIjaoOqX2VUJmHYM/F4Mj5Pa1X41hFgMv4j2?=
 =?us-ascii?Q?g8yLBE9plbU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/MmsOcHmbQPr+BWY2S7jRV/h/Ejdq+Bn/6yS/vuaGDao9Xoe5HyVHex7vv0k?=
 =?us-ascii?Q?aiFh93HSTr6h320K2eozRRW1x4ijpDXLw1a22/3t1nmmU1Oks5/nLPDYi4xU?=
 =?us-ascii?Q?UUx09CgBVlG5eKcw0e5VSt0QArHPsQhAT5+LEi7hUpr4JVjP8drpdNTEf+50?=
 =?us-ascii?Q?HMbd/egCM0Dzb+1M8OACuG1jRcHHb4oaQt7Tiefzqh6wxju9dr+Plk3HVkDg?=
 =?us-ascii?Q?rOovJybX1jF2J6hsvzmKiQPOE+wM/jOvbNpkhhlB0w8mASq5Mh/bkHfNcIA0?=
 =?us-ascii?Q?rIjouPt0+tScGdh+AC91PgxYhdIrs2ZS3Xuj/peSdHzmcRfaTOo00QlfJOQ2?=
 =?us-ascii?Q?NdS7a6JBcvsO2CO4mXa1jyGRDlo5GFcEHp4nUYHXMbRRRsIoxZGgH+I/qKEy?=
 =?us-ascii?Q?Uy44OEQJwqkoX6f6K+upXK2AA+QGtTX+pCedV4FEh+SUKQYSQu0qyGwqz8ns?=
 =?us-ascii?Q?lSMya6hTXT7OUuhxmjD00PCtD7XO0RdJMyZIItlpMjNDCvV0NlHftE6BYCar?=
 =?us-ascii?Q?djqr4xfrqJgGzzKBpX1BukSZcZa8rjwphn/VNAP/D9exc8kRArRxaLqaikkk?=
 =?us-ascii?Q?Fes1+9tY1QUR3Vk6vF9z5npEubD2Su6NgxGYDCktT6UnOdl9kPspIqCiPcXh?=
 =?us-ascii?Q?ZKTT/TrCax10nT2/l5RG8aU8P2YZkFls+OCwrSRuIFYVQvT0KsEoM8lw6K78?=
 =?us-ascii?Q?NE9cfL7i36UVgeX1qwrILlhXoWHJK0yrrSmwjUcaMGXMaZ2oI9D850XBBJ/J?=
 =?us-ascii?Q?LySdXVM2TatQ/wOo9Uw/WW5WCjyZhc28r36rcc9e8EazVLlADWz/LfpOIcvH?=
 =?us-ascii?Q?LijOe7IxtvFj/8BP9P5nXMz4OBVKyyScnQyfbnfC82x1yZvrTKVHpBj2caL9?=
 =?us-ascii?Q?1WebMDsGUlZ9dLseuFass3Xep0EYQfsAi1Co1URKBm3+O2PtzcyR4n3DNun5?=
 =?us-ascii?Q?rHRzhU/QVu6QoTNIDoM7lRQnBp/WQvN1eTQ0G14hDZGpUz3035VPCak8Ko9w?=
 =?us-ascii?Q?uxn/lj/hPFHnPX2h+EBbLNoR4aiukXzd7X1xcLysxo4ntgKk1YwsNbgWxcHK?=
 =?us-ascii?Q?ZKh6cYvBir9dHyD9UAIIvLF81kBje+Uy/NXL10L6drNK2oNMb5noHjM6OYNd?=
 =?us-ascii?Q?XqOt8Jm330yGFvt94i93m21v1SrKxB/PF8fhDscFZg7mTL1ueU1lwUCll+Tm?=
 =?us-ascii?Q?SrtLl/j55MprTIz8iPxPO2w2pBr/fAR1QI8kJdjFNxVMlk6vuqCx1OdtEOzD?=
 =?us-ascii?Q?dzb/PY8yUtbjMA70/XfBbFuv67Yh4UfAzgkFFgleVkA0huCu+8JC7t4hOUAP?=
 =?us-ascii?Q?0zwwECGuXsIJ6DVRUO/JCmQ+ZpSrb84GNPAF75qFJcwpKciH9aRS4rJdAGXY?=
 =?us-ascii?Q?Lt2ehpk4hbTx5G+HM5nKekAeN5sjlu064HxvDd6P+gU0OyuNyDY5dIIF4ONi?=
 =?us-ascii?Q?v0p1Z7ageEM2ziudGFohNM63wOCRHQgWq2sLSHSKVmZaNQdh8iBzzarWo2GK?=
 =?us-ascii?Q?ALN75ia+Ov/OY/HGkNbLyspIpKxohF+8gVneZyqowLrgxJ5bsF+UYLg/SJgf?=
 =?us-ascii?Q?9WTzwNgjGRY9FjkjYQyxrmFfXAE50n0o4Bw/CmOJly7TVq2yIJYlV/GklnRY?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yG6GTM/cbFzB+E7q7DZ1foBX0T+XGCHi5X+jKnW/2Wfj48qWr5UWRsdbivkbxhx0GSBbt4CO7yyp6mOUnNH2PRk9hbqDkDH1+h5hsbde8/zUYxAvhkq6hBbZZtZu6HgqkaPE/Ywtm4oxiyUyftvEN/Zk3Gj9iw2Uc1EUrWelD7W9F4Y77UBf4poexyobzj+w2ogtdStH/idiYnF3tbbib83oEdTb6tGNPnlCMV40LsdOmEZwlapTpnEKcXWP+S1q6fpt31C7ghDpz+6TBcpuLJuCAwNto0QQ7J0If01zX9MkKXfnW1d6vPG/KO3ZpEi2QdUSbgyQ8fwxzHoSe6PJbeLCsZ5zG3IeetMLDhocf4L82+zShqDBtHEGks2Pr7fQNHk30Sw/1Jm11RLu6oNgdm9MiFRnkvQmoiA1QSnYthhIsNx6T8C0YDIy1/pRg7TxJX0vZQHtP9gS6qDzmV9M0pXRy5QdmI/+NmPtechmiNRmlRMD/2NtaoYWZFt023DF//qumLm/IyAKda1t+KtwMDcz9DH3Gxj5lGuAyuQ0eO33mTM1pAGalRjsfR7tAXvz1JnLyVxSglobZQ3uT8jaL7oLLlF+7spr6yqgadf0KHw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48655be-60f9-4c8d-48cf-08dde693d565
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:34:37.2640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PYPgQBLppnAsuLiOvcauHEdZZjdXB3Nn5FR54GPZrjcPUnNXd7+sNTMCQx2/o/qU1y38uA2bRs22HvEZ4kJeJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290003
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX6vs+dLUxMQla
 Edo+GhDja4Nj0gy6ZxPdUdJ9AqLock2a9Y/3lHZojNutNBqTIKmpLXTlina6O33PDhdtdbimYmp
 fNZh62FVcaikLeIY0s+oINzgt2jE3j34U+uOJhrCGd1TWT4GFwAxP4qid413IsLPA4a4Cl87CLT
 V8gYv1dfQLCYtbbWtBvHCiFyDUv8vFS+7tH0zAz0wd9rQDc0W+dS4iA1w8EfSgSPLxYczTzIjrq
 3fXtbp2G0gIcp/p7yQyr/mdutclOZ/NAMTUERxRPtsAB7ibG6V0LdMbMvPAVnqmm2ximz/cBAIf
 VTrxZXvenuC/3UNkpsWXZY8YlSOYkXKX+KYepzNNspjbreJbGK9IoBTqYyGwjHxC9eDgje2wWcx
 virkeK2u
X-Proofpoint-ORIG-GUID: g4Nj1TYNJT5OoI10xo6wrOm9MzAqKl_1
X-Proofpoint-GUID: g4Nj1TYNJT5OoI10xo6wrOm9MzAqKl_1
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b0f5a5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=f5y_YdlGBkd-IoBHTkIA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 218BCC000B
X-Rspam-User: 
X-Stat-Signature: sbgih3df9wq781ipncz1err5buz4x9q8
X-Rspamd-Server: rspam09
X-HE-Tag: 1756427694-655565
X-HE-Meta: U2FsdGVkX1/B47lGXlaYGTnl1WfQZNzTUL7Lvq9NK3iTwQW2/WAcnf4tGSi4ZI+hkMF+TOGVTHhJD/JEp/PEJ8o5y+jz6yxzS+tJ40RmZ/sWfIC851BqzfNw+4DSnLO82Nsl4gJohgwxo9rUuN3SgDcVA64YoDI9xgBxWvXxOt4D2I8LG9gigwT7ub2oPTjP2V/ZKipT7TAwwVYM4Db7IcJjRr1nNC8G926bvYDxy3rAEkSl1O+vfqG0woASAeG1Ye3PsTQ42lQFH7u92NBjZec6UbF46mIoykzGUcWhRZ9oP8AmRzg/DPzJkYX2q1rfxRmqKb+38TiFib43OvGKvH/ttGw334BoQZMc6fVcFgIX0Pz9iydmSfTTLPRS9H51oHClG9MVWD57KT0cqo8CT65uPh523i7dT9xtAUTsR1IApGgo79Eh9bQWYyOIcpPJsk/kQnOmUKYiuyGkPOun4uErMYoBrrZ+jXYAROKiGRPYNF5cBd7t0tIwgCCxIzorvTf1DHXbL46CCVMv8epVAEUBP4XUreCofpPAt2FLsFC6Rjz8+xxynynFMyDX0ruCAlhf4TZDVUCdlXdJQiGWmnjcNE2t9k+NLdiy0iwhefDr06SFRRSIFTYoSIBneka0/RqKlz1QcRRx7K9df8ywKlueGqi2aHT9mZMmHx0BYzibktgfyYZr6wJ6zphsLxtCam+cpTiVC3Xhn3lX/f9+2zwpqrhia9DtA66WeqeKKLkAyOx0fmCFJ6JsjgBVDOvHwVEhvHTEUVcHJgXKebZ/YIv74BJLrhG6NWyTiFjIV5FnuglrSAJ3g8oKEa5IqJ0AgKCs6fQzv5zkjsGVHsFPgNNVwRyqf01+05WXust4kyjTwk+3Pu7HLJb6Kui8uQiCc4eaxcwjnHYXjMv01gq1R+NmNQDEUZFtRf5y/RHS9e79Vg8P4+K2UYW6eGLQHQ/CAxOO8oKRx1vJJtL50vI
 L6vtz2rd
 ozl/i/GTerKNBkuGcNy0FJuBYdVfOzfJkmwg2JCUS8V/P6xpX+fd06ZHbujt1R92JX7hb7KTC++TCwgc+1efPNhcHHSdU9KHnmdON0YvjajNrf8B0qByd9QnPwASvDB7o7ofDrrhxpvm9xFrmJ3nsAEUTvOaAIXUEUsg6irlX3g8kT5CIPtbfBQkKFht3WhcgFYS9fK0LVrf3Puzmff/8ShnXTYffDoHRDtZPzOZjkxw5r6IgGKIIfoIrcjIhqNFUnYY909Fm44s6dNU+Epv9ZnPWIdqg6Czt6yPRuAYRqKbM4Rlgz98NylXWap2VIFKFcCOiK68FbtJX07LgYXYgEhMeoLoKD7W5OcBA3EO7XEFDZqsXa2oPUyREHeTcBU8L5A28QVQv4hEcpy/GkDa9v14uF1ZJGuXn9+IMH9/F+HSQVqkDpc+pvhU9nNqatIP9xYQsp1SjWBD7XQG5EQNGJAZVxvONf1x/pbL9d8OWWp+SYWPUP+Ek1nqqKI/5xpvnEhX9rOjJs+ssBeWfwsXaF5LSP5OI7eBYPzuJWszBnkrPAlQs3jO94cNwar5mlvVIs1b06eadcCG9tShDVkB9N/F6PWo5QmXaWdfD7d4/5k6XMGwHO47RnjToyb2ctoxh74psLV8yoP9A4ANzZatoLlHL/xcXFND3ifXmLPeYn86QgZ43aIY4mL19yt1uR9dEE1R+onnLvmpPI8ZAVtj+cFGhEQF/wvQl25KiFUgH9shMdJkxUZOfS8z34tVRzt6BuuuZPoiHPESQGa82vWGBbScZixYE8rWPAZzvrJTcEgbTaDM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250827 18:04]:
> Let's reject unreasonable folio sizes early, where we can still fail.
> We'll add sanity checks to prepare_compound_head/prepare_compound_page
> next.
> 
> Is there a way to configure a system such that unreasonable folio sizes
> would be possible? It would already be rather questionable.
> 
> If so, we'd probably want to bail out earlier, where we can avoid a
> WARN and just report a proper error message that indicates where
> something went wrong such that we messed up.
> 
> Acked-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/memremap.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index b0ce0d8254bd8..a2d4bb88f64b6 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -275,6 +275,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
>  
>  	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
>  		return ERR_PTR(-EINVAL);
> +	if (WARN_ONCE(pgmap->vmemmap_shift > MAX_FOLIO_ORDER,
> +		      "requested folio size unsupported\n"))
> +		return ERR_PTR(-EINVAL);
>  
>  	switch (pgmap->type) {
>  	case MEMORY_DEVICE_PRIVATE:
> -- 
> 2.50.1
> 

