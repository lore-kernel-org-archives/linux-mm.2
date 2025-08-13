Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EA2CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CDF290007E; Wed, 13 Aug 2025 09:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CF1900044; Wed, 13 Aug 2025 09:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E390E90007E; Wed, 13 Aug 2025 09:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBCE8900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:50:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A612140381
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:50:12 +0000 (UTC)
X-FDA: 83771868264.22.FA764E6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3FD872000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:50:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MDeNhpjp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i4jafapz;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LokzVMCxJ/JPw/ikq7CSn4e3LRx+WF/iFEJgdVawRCw=;
	b=xt8sce123Az0sZm0azoS1Wv8HPzF7Qt8Fwy2yOCE5sZTOkzwtwLjraMoq8RSSl2IC89SCc
	uL49++L7/NS5ZgARelal2n2t3WTBQ0D3/Yua5gyQRSK2WA8uLez/EtC75W42O22m8pnVMP
	D9HRriuY6VWFH8BayBIbzPF9eitpWI8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MDeNhpjp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i4jafapz;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755093009; a=rsa-sha256;
	cv=pass;
	b=eVJcdZFs1OKS5QHHGjpDGI0K0LigG83ytRmHsfFnip3rY0/xY1lz+78O+QJMX2od1EtuEi
	FDELP/Q++JM2KftVGovyMs3xcx9mqfx2LHwkbTXByuKOG475tH4Am33XCRm51NiqVz0aiZ
	4PMU03sUu8MADEJK0x3QmQAFPaTcyXI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DDNChk023138;
	Wed, 13 Aug 2025 13:44:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LokzVMCxJ/JPw/ikq7
	CSn4e3LRx+WF/iFEJgdVawRCw=; b=MDeNhpjpcYfr+i1ILK8maJfulJvR4E3avq
	AYzEB3mOe9yfSxc5CmlyANMUsG4InL6zNfX3imICdCZXArJ8ZULPxlhHWl0L3wwO
	SrThZeNOU7nOG00uSRv4IzIFWqRuKT0Dy6CYJPaNRqh4wb1zhckyFr1mAjUlIbuT
	1X2ah5QEB1SP+CFjFIDD341zMcP4HlSnZLqCDzsjqNKqhg2oq8ugmnNSZw3w9Pb6
	qKVDEesBKi8358RJwDK4PUXxGJximopof3/J+tDFr5ieWFOJG1OmfhsIhQKUAl4E
	I7eXNiiHpezxOEqGmGB06U1zVm9FwHVDXZkaWbz/6HPnVijBB30g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvrfyh8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 13:44:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57DDf85O030183;
	Wed, 13 Aug 2025 13:44:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsbe1hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 13:44:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X0loe+jqspX4sO00q53H/C+wpeJCXu/GbFfFN51U/SfTXyyLeB+tix9lx66PBLGCqp7kAhRGzurPWKVSZn3A3fx1YK0fFk/RmfQbn+HektOvOr+NQ9sSttbgjy1pwl68pfeoFx2iTRL3PkR7xJXs4BRB5rY7Q+GJMM+L8rwSoROc5tL7xv8uJnAXKDD9b6SBS6ykyQvpueeGUMXSUl3Xfoi157za+BqAMWA1G4eamfLp2z9MANtw1WNg8fmejW1GbkRpBeZYVRkKZ6n1mRYy8Xj8lBQ7do84tLdZl10OVTdoCpySiGNvMZivHVpDFjECoQumUZh3ef7zuldUB2hERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LokzVMCxJ/JPw/ikq7CSn4e3LRx+WF/iFEJgdVawRCw=;
 b=eSN8tI0UtU1UtIlIHEO8kDDNf3J4AfOdCR/f6ESiuLwUa9LdJ+ZFQPDzSxbib8OkEtRSBCHu0QtCPxssp6U8KOY959IIFDQ7HQ3S0rVe21yJWdivosw07ndbgf23x+CawgWk1kvhK/wgy1GbgrufwAQytuPbLiNTWd7RVeHvg8nkx/p6MXXfa6MYaAoSOiBve05Pt5E9KTNG3n6M7C9qARPU9C2i4oxBjfuqijgMGwhCjsjXAAtmS9VZz5Vyi8BSTsDxEIsDCc7ebPjFpRA0bpVhR4JjrqEQ34RLxvN/gi2J7iLL9ugJnGcsTGdcFpA9F0kmZIFzHVXYzRM+oD71aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LokzVMCxJ/JPw/ikq7CSn4e3LRx+WF/iFEJgdVawRCw=;
 b=i4jafapz1IDmX55D7IuQ8ixW4IoQHoAGHl6J9A/y1fGms+wVGhoEUwB5W7bUnHP2oinuvd44eKEZyZp4gL1QFU5YaptZ9EVrV2m3zr+01CrN92j2cv2A5re7FoemDA1BDHyqKl0Lr7nNTBrAReDqpJRSOX0ba1garVoZ0Q9MFpI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Wed, 13 Aug
 2025 13:44:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 13:44:39 +0000
Date: Wed, 13 Aug 2025 14:44:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, david@redhat.com,
        vbabka@suse.cz, peterx@redhat.com, jannh@google.com,
        hannes@cmpxchg.org, mhocko@kernel.org, paulmck@kernel.org,
        shuah@kernel.org, adobriyan@gmail.com, brauner@kernel.org,
        josef@toxicpanda.com, yebin10@huawei.com, linux@weissschuh.net,
        willy@infradead.org, osalvador@suse.de, andrii@kernel.org,
        ryan.roberts@arm.com, christophe.leroy@csgroup.eu,
        tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4 2/3] fs/proc/task_mmu: factor out proc_maps_private
 fields used by PROCMAP_QUERY
Message-ID: <cdc1962d-386a-4b33-9876-8552fc7593b9@lucifer.local>
References: <20250808152850.2580887-1-surenb@google.com>
 <20250808152850.2580887-3-surenb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808152850.2580887-3-surenb@google.com>
X-ClientProxiedBy: LO4P123CA0522.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 01637ff0-efac-4421-85b1-08ddda6f8cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pkJpL5iVTqPv2xBR7P7LdgRdY4a4aZpoeAgACb/McScxzea1M32Cp6gJ0o0b?=
 =?us-ascii?Q?4zyzrcU9yrZtVV6rTSOVzIIkoPmJ2h5v+91U8P+n0xnL88WreJE8IXR9GpZj?=
 =?us-ascii?Q?plUKfM74zSZ1E3bJfoMIxcWc3D0imtKcG1adWhd+Em2Fo4LxFA3pOyWwO87R?=
 =?us-ascii?Q?pMf3zBKxfHCgAHPzGPEHv4ryKROCdnjCDgJTkt1xpf/R70yli4f4xE7+NZYG?=
 =?us-ascii?Q?O+FtA/o1p7REfI4/S0ZU9udOU+T27/+kEVmunKgG96rYihLCCIkES8H98EnM?=
 =?us-ascii?Q?6y3h8PEUrjOfjQG1pkyZ3M8d8cR+2nMjDjYQpFoXOqWbWYzdHL42Gh3VGOs4?=
 =?us-ascii?Q?LgesgC6Uu2SxyCseIWtJLlKPbhk4T6LPbtcTH3Z/TwT3S1xLyvFt0++TjnP/?=
 =?us-ascii?Q?7xIi1ADwja8JhVFEm0GlYHcjh3MoSMJSO+IZVuX3mdL6nuHa//F6fe5WZF/4?=
 =?us-ascii?Q?J9CEmxdxXIa0CEhYuKuZkMfElwHinbiQfnsgsSR7C5PSd5HUy3/NnoG13fNe?=
 =?us-ascii?Q?oAqOlsszAtFHJ0h/uLG7i/loZal+6wndRKXo0XLD68BYNYSWwtGK1OusxktW?=
 =?us-ascii?Q?TlzOgPZe3jtfiDHwD9soOLbPtsYf9Xq0nexyujfTQW2uQ6IaAXOpvRFvH6ID?=
 =?us-ascii?Q?yhcJfNDgPVmxgEO8WYo9/6ox+qi1eaDZcKPlO0kA0eH6HoFapAQY4ORlNykR?=
 =?us-ascii?Q?eezWsdfQizgiCffhfnv0L69Chz4KuVM1Ib8CXZAmQe0VYU5l04p/TP8fjnop?=
 =?us-ascii?Q?5MIDCBIjmXXC0ldTNjDM7K8Lzd3fz/ZdokimorjVQXrEpnwGiXvZfxyuQUSv?=
 =?us-ascii?Q?i8p94aiKJnyS5onaatGFtmPNo0vLlmOOwejoqlZXv+knHEIcCKRoaepmT6un?=
 =?us-ascii?Q?Pb3WL6zi3xM6fvAClIlQbOsPMNrgI2LZGdpKZJ5Fg8owQ/54l7oiv7h3Zmmf?=
 =?us-ascii?Q?s/zcjrsMDtfTPPKntQYpKcryASQjEDToki2SRDhrQRJroTKd1ge88YWIDwSl?=
 =?us-ascii?Q?23mLVB22GCGvA2IjGrWLX1yAPXwwhsAan9GKnOMlqUg5yBt+WwVTUlSU/RcY?=
 =?us-ascii?Q?VjmgLByJaPGK0iDC6/0JVH2IFlpTED9KZO/f336SE3ny5/Tjhawa6wgReeqt?=
 =?us-ascii?Q?/kM49jXstlOya34LSj48OPNDPUIS2C5vZm8H81nnHWMf15JE/MEJ0ZfXb4e7?=
 =?us-ascii?Q?WNyVmcapZbf2f92spw47Siy6397cyrE5czOCnn6rQ2NEmoeSxKWmyXqi7i81?=
 =?us-ascii?Q?9lrALBT88s3kwG+Ia+KQ2qPcXVL1cxNO7HwPAy2VzyNWzKLA+u1UI1tUBBQA?=
 =?us-ascii?Q?iz2s/gHcm2h5wkykmzB7107H3x7KNg2OZp32dPYiIoQGblqdmTmbBLWoWBkL?=
 =?us-ascii?Q?mTHrXH6fDPR7LubyA9EMTvlsHus19yszkMWJttchxYg0pK51pS/vlm/K7ij8?=
 =?us-ascii?Q?s6oVmIlU4fE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EQgZ8MiTajr+0If25xiROJnS0gx5UXHH9AkKdd33924MM+4H1kGLdTDiYyoL?=
 =?us-ascii?Q?eduLGBOjcTpo/vZtHcuTVm4N/w9NYfhi5lB9lV9O+uNgqGBeUVs2EanWHWeq?=
 =?us-ascii?Q?fBzdwunR2ohgS5aMjk4k2nTGlUjKav7jhzIkg8ai3fWelbbljcoKWNbCuV+e?=
 =?us-ascii?Q?Napo/I9hDEzwMuTZ3eVwo8ez/t2tA8g6WDUULSBk74/2wiQODvLIDMY+LcRi?=
 =?us-ascii?Q?3df/qB7XJdOwH3MzctoErpX0smH2lIp2LKdKgw6o+3W3Bb9kJ0/+ad1ODhfG?=
 =?us-ascii?Q?gwNEvflyMgUzGurNRGruUXIZKoRrT7UVCBfrLtiwO2qtpHrKaP3iT4cHNCWq?=
 =?us-ascii?Q?GwrsIfjJNRSsM6w8spjtNUzDR6y09MzM34f3NZX7/JR2INI+5WAWtME5SJU4?=
 =?us-ascii?Q?B3FFj5AS2rimbrQVosDcax8Bw6RW4KqVM3Vct7L5CBhxDVZLfjIyVuB5mD9J?=
 =?us-ascii?Q?BgilkMVULYS/Od51YHlMzVNFB5e0zBWTZDUpOD07Sfp8vYyfWNESYjarK3FR?=
 =?us-ascii?Q?Si/hFOD0vXqV0XiVsdrcnHxk9BmUrPQa3x16GI2xHsH5MeJyDkNtU6OAnRF8?=
 =?us-ascii?Q?dX0QVWbgu305U2nQ5E3vLY6zKxHML3KNTuuEqt7wtI1m1uivnz02yl9DCpQL?=
 =?us-ascii?Q?OtYjGGHzLWe3/PLbMVrOkGYMDCti/LHWpv/3Hj5O+DpRZUEUgYQcXQB/ql3d?=
 =?us-ascii?Q?KAyP7kcKf0+YmeOgs/75ZoFSMxj86yP29QlYmkVtStjq3o/zZpJnmbelh0ZV?=
 =?us-ascii?Q?NeMG1o8SlRY3Ku0l0THEoeN9fPhsnl4HojcqDIv1/i1/1181V/f9fxGs1ngO?=
 =?us-ascii?Q?Nf5kzkxhuzgmIZUUPOdvGLmthmAW4Qu9hYJcSoBve+fPLkXzwV9wt7IRxhBc?=
 =?us-ascii?Q?Q3pawmENcFs3zsazG9yjJ23vHtjfZ04U3FxbnoPC6LZUd0L1nJ+Z2Tt1/u8q?=
 =?us-ascii?Q?wH4q6qFzByvn1OcDZO3OXrXRdo3cfd8INpHfQtj9izwLgzq8zVEyZloVZDfC?=
 =?us-ascii?Q?z3+5wJdpjUyZIN2fAjyIUORONuNAi5jwQM8SdLtuBvYTNr7dshaIytErMSTn?=
 =?us-ascii?Q?OYaU2l5qymfiuc5k6ibvp3mVuOxLKxF/Kg2IiX6bZU28Yc0NNIJIV5psc5zJ?=
 =?us-ascii?Q?iCN8pS9JryNyJpEiaYbb6Hw27MqFoiV08pMMVjRfbCQ20Quy3Ci30FVwWp8I?=
 =?us-ascii?Q?dLwoNEMthYRPEnQNcJLTPeFOgKQJnmKAN8F3usVvKBiUB4JYdIVnOcdVAPG5?=
 =?us-ascii?Q?g+d2Kwp+ouAKNEx2HtGsNq/ovHhufawgOae9A9WatEjty81y6+Cn+X4l45cY?=
 =?us-ascii?Q?Ur6V6ywxsAO9U/+MXM0SCkMmFaXaIhX1tpuZIbzpg2lmau8iBA7I8LwzB7rM?=
 =?us-ascii?Q?GH97h4youce3AEpbcFwfZv7+Iu0NzTHX8uUQDBxDB4jduFFmKk0YaZZ1cjiL?=
 =?us-ascii?Q?Ao/iF5BJN7ZkbyCcpgJv14EvxMPaD5Z926eJho5WdGD2VeWSUW6OkNOiwV6w?=
 =?us-ascii?Q?yjGTJqEt+AXRbY2xiEmAY3uW78wn3EsVN5xuZ/AKIk0gm/oAWhYjbt7apSTJ?=
 =?us-ascii?Q?BP/iSNxGMmrC+vW7F7yA3/fJbLR0fmX2sHPQS7vMssUHtEeguDuojDmN+eMo?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iyKTCtjfFSDCM9HNBm9WWmgGBNLfo3aKGSELC6oq19wNLK74rG4OpEWJztkaHnIX//C/ySl/bbSXlIleOIytq/s5KTcA+Kc5QZkRBhG8dOo8rKNYcG7JHTgJ1jGJQEMRWYJE/MOFKltS4kHra+9SBSHukrKP+1JqLgHHB1yaXJUTdt2Wt19x6cPWnnMRuNMLdVeNuj4suSPXDbDfCB3oevByaEkyhX30vM5ybiFxrZe9+d2Hp2kk++PgF74YJMVJ76yk9WtISjyvdeiQdcr9nuGJYiYpvOe/vdNP8Wf4umwft1IoQ2z/azeTpcfXNakWtIvhYkrVLFWYfVuVvuzghkeqHuWoSOgXIgvpeNgEqUiWJlAv9OLIIwFUH7+Rnc/AuudjzHp/BNVL0NFEwq0n1vTZkvTzV+PNP+xoz78WK4InP7BBcIWgJiNFo0ACjtOv8sWedygJwXefTIMc4BDazYl50BWzWx+bGk0JtfPFrzjWJhjN+nl3tgEV3M5qE+mraoQRZvqB62vK8ODszW3YNDzHyHz7AjleNMJHobgPxW4STx2fVeDn90qXbTcJ7zazoW+Yay8iVhZ5tq2zRUYomEW6PPv/z2ABXtZXYTnfUVM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01637ff0-efac-4421-85b1-08ddda6f8cde
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 13:44:39.7949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Que7zzec64YGORCcvmc/fZ5PjhkJkk+16ndR4ogBlkJU9PHWqN59yCRsh1T5qMRmME8m1k8FoEF2gutcZC5WokXU1zd4UFuWznoOpVlD/x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130129
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=689c96cd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=OE1ZqwuXhlgXPqbPw70A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ued6EIsuyOFJsDrLnREiGJg1jr5BcvmE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDEyOSBTYWx0ZWRfX+6Izen34ukQt
 Tsc2q1IO6NfInaWVpfNaTfcvDFFwM8wN/UJ9K79Ie9KnwZ8GkKV+Gl6fUC2STR9DFNKR29jmDn6
 A8g6Bg+mxAqRXkK4a3/IVIBuKZuV2cxxP4Y77sZzE7YvrT37jGu4l7Oh2giv0ybK0xB3BCRyetf
 jscVn/+t1xoB0nERiizkXFhhoblHFcjeF3M7k8uAMmJf2xsV74Od9mFMVdWrV4czGtmbjyhdwzA
 OtGkDq4duYl7mgumY990GMXFKm0R3LnuvTNArTut4XTaKTIC03OX/gtix4V+UDy4uofWq4oLQX6
 pcz/vvqfJrLcgCMGNbw9NADNUYdeQgqO2wIa/Vv6OQ6OQgPWeLx0lmszVWAUfVwj+H6Xcfc3YAc
 W1wb9sVDu+pUHmZlf6Np5D9I7p3Zy09NQGQGKZVC22wkaFfYmUDBrtDSJTjKF93P9DT/Icts
X-Proofpoint-GUID: ued6EIsuyOFJsDrLnREiGJg1jr5BcvmE
X-Rspamd-Queue-Id: 3FD872000C
X-Rspam-User: 
X-Stat-Signature: zcw46cbp65o4aiw6mn44xyggpepmse4e
X-Rspamd-Server: rspam09
X-HE-Tag: 1755093009-323336
X-HE-Meta: U2FsdGVkX1/RjK5ummt+NKcBG6rXPjzY6f1HU8nCo9Ah6+6afOIjcH8UqzQRb555QuiKp5hMk/R4oNE7PnrvHt3K8Y6ca1dQmtlXBfBvn4qFx7WSji65gTFTmZJQWmKIz7JzBRb83SThZsX/Y3BQz5Ym1otgE3F3p9ABZw2lyCUIDkolEDlIED5ZMehQJqhTZHVzG1aNBnZfAghwmnncX51mHI8IsgvZPkV0FkO1IRV7TxJ6C3/LxVfNFYXIrC8dAOqS2lWd0uodF/xtjM2l03n5qJvZP81oKumE5GRxWYhsG4mu32wCw1dUdsjok2TawNW/9BR3xbGL3rp7z/JMgzZVeVQDre/RM6Vi1rCj7ITkqnGDVuRUIrAfiu1ykehbzrS6nM3RfMmS6dMRtYsQtlruHKHNpWlc9LC0OHMxK30Pn+xPFnHDcxoIobYQyBGV435PT9JfpHaYMdpjWMaHbYzA2Pyo4iT6Z/wo0Qj0uWfZAK2MyblLgXhdtkNXjH9MgB0vJ6nnP54TXm9AAiNbr6S5sLQTw9vGQMwbViJHJeI6GAx6ASjS1dUM5Cu2L6HqZ7IoaJxCZnS21NdAP7MdkYtLy9GQ5kqsMI34qegCBBxaCcn25Vn8mO35wXDJrn+OcEjYqf1EYMXcisdTTmQuO7tRte0NUXdOFtZWw7s8cGTwuxEbFPt8XOAlEPKs8JLY4OazOQuG7C/qeX/7+ur58CX9QwtqLL1nt3PUORxiQTMcPslnWD+CMusb480n9YY6HW1ThFZ2tMA37TWWM6j2Y1Z6/gQAG0Q6Mp/bshNw/fv6UjAPedEX1f+nhJhd2tJSSWuOZVVYapJpokQT8QOUlPNqkk9PkDLQN4vzDZ1Nv993rj4gSFEEQgm1Vqye7q7fE7ZsxCRREhVaYdkWh/RYAcAbsbGfP2nuXtdJFzSjiwfu0NkqGiRp8H07eA7AJtpyyf3IYGYKlT4W6ndCcKc
 pVGe/79w
 p7ozXoxfBL2kTKGwCRVeEAGh45u0hJ6Saby8aPKSM//zak2DF0zyz4lDtnxaHlMT+QMJR1fZ+F2R1hz3FzfFZ04vdPQvN0LSdL4OgN/7hmUhT0riv1YYr7R2AoOp46LNTzy9Ftwldai3j8UvRV2ZienUeBq89+fdJUP2Imsr/fWaWF7oLa5B7DLZpLSg3TjnJFtAZwOzMnGyeLTZrprgop1gEIs7Lif9SIWej+/y2KTzZr8WrCk4pVLk19ipOgV/fk4RFfRa49AqSZCtz1Jk1zh/h0vol+2PgBjS6mM59EL+iukUU82t4cPH/jJumtLoCYDsVGSCKt+NbvL/VLgqeeihoLn75CXIHakwZgsz+dCSYccKuBKMCEktgpgn8KsjGzJwxGSU5M7e0qAnDbEh9XJ2iMcblH1RD9b5Vkyh03uUMG6W87fcmfLYGdh/l8pspCDa4CxsjSMg+O7C0EE7fzPmfm8hvT1uIl5zUt39rOpU7zhV3AKw3DDBG7ZLPA2Ch7oMdLrz/fUf2xdBE2q8im1DsTnbf3Q7pL2cgU+uxA91TRWzlujlFrW2QRtmlvWPmGiKMIb51tKrAH/EB+ykzo5ZxhaQff1gt2Une32tgmFCU5Q5Jchf00hU8/MDiFUDK6moX8Kn7F190f0/nVMQZAIxTXlTTZKds8brr2Fat6UJ7pGFtLKwyO1m3MhlzP1kObjYtEjRhiyALfwZiQJS7hDHY8xQrz6BclL++IbwcV9pGFukECvULeLiK30Gw/KoStjMbnoBb/mYCLOFOofoTyRyMTpNf579Nw2Oikae5qRVkjrmzMd165XiUwUnVUGYFz4hP4B4TVTDpP38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 08:28:48AM -0700, Suren Baghdasaryan wrote:
> Refactor struct proc_maps_private so that the fields used by PROCMAP_QUERY
> ioctl are moved into a separate structure. In the next patch this allows
> ioctl to reuse some of the functions used for reading /proc/pid/maps
> without using file->private_data. This prevents concurrent modification
> of file->private_data members by ioctl and /proc/pid/maps readers.
>
> The change is pure code refactoring and has no functional changes.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: SeongJae Park <sj@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  fs/proc/internal.h   | 15 +++++---
>  fs/proc/task_mmu.c   | 87 +++++++++++++++++++++++---------------------
>  fs/proc/task_nommu.c | 14 +++----
>  3 files changed, 63 insertions(+), 53 deletions(-)
>
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index e737401d7383..d1598576506c 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -378,16 +378,21 @@ extern void proc_self_init(void);
>   * task_[no]mmu.c
>   */
>  struct mem_size_stats;
> -struct proc_maps_private {
> -	struct inode *inode;
> -	struct task_struct *task;
> +
> +struct proc_maps_locking_ctx {
>  	struct mm_struct *mm;
> -	struct vma_iterator iter;
> -	loff_t last_pos;
>  #ifdef CONFIG_PER_VMA_LOCK
>  	bool mmap_locked;
>  	struct vm_area_struct *locked_vma;
>  #endif
> +};
> +
> +struct proc_maps_private {
> +	struct inode *inode;
> +	struct task_struct *task;
> +	struct vma_iterator iter;
> +	loff_t last_pos;
> +	struct proc_maps_locking_ctx lock_ctx;
>  #ifdef CONFIG_NUMA
>  	struct mempolicy *task_mempolicy;
>  #endif
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 29cca0e6d0ff..c0968d293b61 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -132,18 +132,18 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>
>  #ifdef CONFIG_PER_VMA_LOCK
>
> -static void unlock_vma(struct proc_maps_private *priv)
> +static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	if (priv->locked_vma) {
> -		vma_end_read(priv->locked_vma);
> -		priv->locked_vma = NULL;
> +	if (lock_ctx->locked_vma) {
> +		vma_end_read(lock_ctx->locked_vma);
> +		lock_ctx->locked_vma = NULL;
>  	}
>  }
>
>  static const struct seq_operations proc_pid_maps_op;
>
>  static inline bool lock_vma_range(struct seq_file *m,
> -				  struct proc_maps_private *priv)
> +				  struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	/*
>  	 * smaps and numa_maps perform page table walk, therefore require
> @@ -151,25 +151,25 @@ static inline bool lock_vma_range(struct seq_file *m,
>  	 * walking the vma tree under rcu read protection.
>  	 */
>  	if (m->op != &proc_pid_maps_op) {
> -		if (mmap_read_lock_killable(priv->mm))
> +		if (mmap_read_lock_killable(lock_ctx->mm))
>  			return false;
>
> -		priv->mmap_locked = true;
> +		lock_ctx->mmap_locked = true;
>  	} else {
>  		rcu_read_lock();
> -		priv->locked_vma = NULL;
> -		priv->mmap_locked = false;
> +		lock_ctx->locked_vma = NULL;
> +		lock_ctx->mmap_locked = false;
>  	}
>
>  	return true;
>  }
>
> -static inline void unlock_vma_range(struct proc_maps_private *priv)
> +static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	if (priv->mmap_locked) {
> -		mmap_read_unlock(priv->mm);
> +	if (lock_ctx->mmap_locked) {
> +		mmap_read_unlock(lock_ctx->mm);
>  	} else {
> -		unlock_vma(priv);
> +		unlock_ctx_vma(lock_ctx);
>  		rcu_read_unlock();
>  	}
>  }
> @@ -177,15 +177,16 @@ static inline void unlock_vma_range(struct proc_maps_private *priv)
>  static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
>  					   loff_t last_pos)
>  {
> +	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
>  	struct vm_area_struct *vma;
>
> -	if (priv->mmap_locked)
> +	if (lock_ctx->mmap_locked)
>  		return vma_next(&priv->iter);
>
> -	unlock_vma(priv);
> -	vma = lock_next_vma(priv->mm, &priv->iter, last_pos);
> +	unlock_ctx_vma(lock_ctx);
> +	vma = lock_next_vma(lock_ctx->mm, &priv->iter, last_pos);
>  	if (!IS_ERR_OR_NULL(vma))
> -		priv->locked_vma = vma;
> +		lock_ctx->locked_vma = vma;
>
>  	return vma;
>  }
> @@ -193,14 +194,16 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
>  static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  					 loff_t pos)
>  {
> -	if (priv->mmap_locked)
> +	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> +
> +	if (lock_ctx->mmap_locked)
>  		return false;
>
>  	rcu_read_unlock();
> -	mmap_read_lock(priv->mm);
> +	mmap_read_lock(lock_ctx->mm);
>  	/* Reinitialize the iterator after taking mmap_lock */
>  	vma_iter_set(&priv->iter, pos);
> -	priv->mmap_locked = true;
> +	lock_ctx->mmap_locked = true;
>
>  	return true;
>  }
> @@ -208,14 +211,14 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  #else /* CONFIG_PER_VMA_LOCK */
>
>  static inline bool lock_vma_range(struct seq_file *m,
> -				  struct proc_maps_private *priv)
> +				  struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	return mmap_read_lock_killable(priv->mm) == 0;
> +	return mmap_read_lock_killable(lock_ctx->mm) == 0;
>  }
>
> -static inline void unlock_vma_range(struct proc_maps_private *priv)
> +static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	mmap_read_unlock(priv->mm);
> +	mmap_read_unlock(lock_ctx->mm);
>  }
>
>  static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
> @@ -258,7 +261,7 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
>  		*ppos = vma->vm_end;
>  	} else {
>  		*ppos = SENTINEL_VMA_GATE;
> -		vma = get_gate_vma(priv->mm);
> +		vma = get_gate_vma(priv->lock_ctx.mm);
>  	}
>
>  	return vma;
> @@ -267,6 +270,7 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
>  static void *m_start(struct seq_file *m, loff_t *ppos)
>  {
>  	struct proc_maps_private *priv = m->private;
> +	struct proc_maps_locking_ctx *lock_ctx;
>  	loff_t last_addr = *ppos;
>  	struct mm_struct *mm;
>
> @@ -278,14 +282,15 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  	if (!priv->task)
>  		return ERR_PTR(-ESRCH);
>
> -	mm = priv->mm;
> +	lock_ctx = &priv->lock_ctx;
> +	mm = lock_ctx->mm;
>  	if (!mm || !mmget_not_zero(mm)) {
>  		put_task_struct(priv->task);
>  		priv->task = NULL;
>  		return NULL;
>  	}
>
> -	if (!lock_vma_range(m, priv)) {
> +	if (!lock_vma_range(m, lock_ctx)) {
>  		mmput(mm);
>  		put_task_struct(priv->task);
>  		priv->task = NULL;
> @@ -318,13 +323,13 @@ static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
>  static void m_stop(struct seq_file *m, void *v)
>  {
>  	struct proc_maps_private *priv = m->private;
> -	struct mm_struct *mm = priv->mm;
> +	struct mm_struct *mm = priv->lock_ctx.mm;
>
>  	if (!priv->task)
>  		return;
>
>  	release_task_mempolicy(priv);
> -	unlock_vma_range(priv);
> +	unlock_vma_range(&priv->lock_ctx);
>  	mmput(mm);
>  	put_task_struct(priv->task);
>  	priv->task = NULL;
> @@ -339,9 +344,9 @@ static int proc_maps_open(struct inode *inode, struct file *file,
>  		return -ENOMEM;
>
>  	priv->inode = inode;
> -	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
> -	if (IS_ERR(priv->mm)) {
> -		int err = PTR_ERR(priv->mm);
> +	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
> +	if (IS_ERR(priv->lock_ctx.mm)) {
> +		int err = PTR_ERR(priv->lock_ctx.mm);
>
>  		seq_release_private(inode, file);
>  		return err;
> @@ -355,8 +360,8 @@ static int proc_map_release(struct inode *inode, struct file *file)
>  	struct seq_file *seq = file->private_data;
>  	struct proc_maps_private *priv = seq->private;
>
> -	if (priv->mm)
> -		mmdrop(priv->mm);
> +	if (priv->lock_ctx.mm)
> +		mmdrop(priv->lock_ctx.mm);
>
>  	return seq_release_private(inode, file);
>  }
> @@ -610,7 +615,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
>  	if (!!karg.build_id_size != !!karg.build_id_addr)
>  		return -EINVAL;
>
> -	mm = priv->mm;
> +	mm = priv->lock_ctx.mm;
>  	if (!mm || !mmget_not_zero(mm))
>  		return -ESRCH;
>
> @@ -1311,7 +1316,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  {
>  	struct proc_maps_private *priv = m->private;
>  	struct mem_size_stats mss = {};
> -	struct mm_struct *mm = priv->mm;
> +	struct mm_struct *mm = priv->lock_ctx.mm;
>  	struct vm_area_struct *vma;
>  	unsigned long vma_start = 0, last_vma_end = 0;
>  	int ret = 0;
> @@ -1456,9 +1461,9 @@ static int smaps_rollup_open(struct inode *inode, struct file *file)
>  		goto out_free;
>
>  	priv->inode = inode;
> -	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
> -	if (IS_ERR_OR_NULL(priv->mm)) {
> -		ret = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> +	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
> +	if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
> +		ret = priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm) : -ESRCH;
>
>  		single_release(inode, file);
>  		goto out_free;
> @@ -1476,8 +1481,8 @@ static int smaps_rollup_release(struct inode *inode, struct file *file)
>  	struct seq_file *seq = file->private_data;
>  	struct proc_maps_private *priv = seq->private;
>
> -	if (priv->mm)
> -		mmdrop(priv->mm);
> +	if (priv->lock_ctx.mm)
> +		mmdrop(priv->lock_ctx.mm);
>
>  	kfree(priv);
>  	return single_release(inode, file);
> diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
> index 59bfd61d653a..d362919f4f68 100644
> --- a/fs/proc/task_nommu.c
> +++ b/fs/proc/task_nommu.c
> @@ -204,7 +204,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  	if (!priv->task)
>  		return ERR_PTR(-ESRCH);
>
> -	mm = priv->mm;
> +	mm = priv->lock_ctx.mm;
>  	if (!mm || !mmget_not_zero(mm)) {
>  		put_task_struct(priv->task);
>  		priv->task = NULL;
> @@ -226,7 +226,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  static void m_stop(struct seq_file *m, void *v)
>  {
>  	struct proc_maps_private *priv = m->private;
> -	struct mm_struct *mm = priv->mm;
> +	struct mm_struct *mm = priv->lock_ctx.mm;
>
>  	if (!priv->task)
>  		return;
> @@ -259,9 +259,9 @@ static int maps_open(struct inode *inode, struct file *file,
>  		return -ENOMEM;
>
>  	priv->inode = inode;
> -	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
> -	if (IS_ERR_OR_NULL(priv->mm)) {
> -		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> +	priv->lock_ctx.mm = proc_mem_open(inode, PTRACE_MODE_READ);
> +	if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
> +		int err = priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm) : -ESRCH;

We could abstract out lock_ctx here also, but I'm not going to be picky about
it.

>
>  		seq_release_private(inode, file);
>  		return err;
> @@ -276,8 +276,8 @@ static int map_release(struct inode *inode, struct file *file)
>  	struct seq_file *seq = file->private_data;
>  	struct proc_maps_private *priv = seq->private;
>
> -	if (priv->mm)
> -		mmdrop(priv->mm);
> +	if (priv->lock_ctx.mm)
> +		mmdrop(priv->lock_ctx.mm);
>
>  	return seq_release_private(inode, file);
>  }
> --
> 2.50.1.703.g449372360f-goog
>

