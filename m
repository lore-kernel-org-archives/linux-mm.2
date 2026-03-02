Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCA6EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2991E6B0005; Mon,  2 Mar 2026 12:23:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CA06B0088; Mon,  2 Mar 2026 12:23:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9AB6B0089; Mon,  2 Mar 2026 12:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC4406B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:23:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AB82140239
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:23:58 +0000 (UTC)
X-FDA: 84501795756.24.B78AF81
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A4E31C0014
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:23:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XXjsSJEZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nNHnT+lZ;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772472235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gfzvobo8XfXb+hvlG1jmYrZPOZmjz14+z85sgVMK0sQ=;
	b=mPnUDu9/JMkqmt6vNw3MBMxxcEqDkdsO0i/ZUqAvMlHlj+WCGoxIg1Q5P6kp9jYBLH+YBv
	hoUY9O7zetpCarRWxHVzVInPE3ZWOLtSOYvVbHi0kNeFPvgk97L/eiHYQQV8yEA8D6CxHp
	8lPuZ6xMH5y5quBX9c89wbFqslcTB5U=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XXjsSJEZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nNHnT+lZ;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772472235; a=rsa-sha256;
	cv=pass;
	b=NHWvr/H3Qes7PHl3khucYVhbljJLl/5vFo82h+8z3KObVviQBLB/mhfVU05+Rzy5BsEo2u
	ThfLknA+m5B8Z3qv4RGpLxE/KPBWPVFkEva2LKcqfUTTyLtSMnYHcOjqbkrb/DJpSP7PKS
	dbrQAXmNTVvWnODSYLK3cQcK2v5yf9Q=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622GuBg72546187;
	Mon, 2 Mar 2026 17:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Gfzvobo8XfXb+hvlG1
	jmYrZPOZmjz14+z85sgVMK0sQ=; b=XXjsSJEZkUytY/Dj6vVUAABezPlN7JJOaT
	HBPUJBnwH6d6OCZTboZajl6KylrE16VxUS3lI3lyZoqsEeSSpnadVpMESf9HgGtS
	QGFgpfRarnPJHNakUHFPQqgitBRNrfNO6V9v9mVOK5It7v405UqvzNhcHsmkHSpa
	3DhPBL2TtCmxt5DSX85AasLcvpe6madEu/5WJusnyQ88WfLzXxZQB3SsObIYqISF
	aiZbRDWltUih2SOVyUWzfZ3Mk5caAqlLE4bRNUO4HW4wKrDleKXi5sQPFlzyFrek
	i+2plHdyvQAjnqeZoTpOKDbBGBfPag+Ox+1qCzdRLBgb7Q0c1rAw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnegr81gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:23:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622H7Qux035428;
	Mon, 2 Mar 2026 17:23:43 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013052.outbound.protection.outlook.com [40.107.201.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd7vhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:23:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mgc+Uxygc6kETdGYxzBfUExDv+Mu46AGet+YvpE4XlAw1k3OLrxrrYmqTGa3yq5UHm98cmRZ1+5lBCI7Qs3jknQ9IqyVBYi3RAuk6fvGrMtPz4+nMMG8nw5rtmuxSMxrgN/NKCFaU2uENoiYQYlaQIegY/j+WZ5Bx+s3Ygq6nIoflcvHuxtQa4htiivF6om50EwNsfLvhjcUqgSinFsvQOoGihH5JEJNuhgupRky/Q20Vy40cm3tnlRCabBAAHx/9SC1rZpgk8GToCDT4PPmGCnIa3SEAJsuEW1V4QUtx85zY2jL8A+JZfUYEl8jWDbEE8rd/iAonKAk9tguApEe8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gfzvobo8XfXb+hvlG1jmYrZPOZmjz14+z85sgVMK0sQ=;
 b=arXPqLo2EU6yTDUji2QyLWDfmOZsn8Kw8DCYU8GG2y0G9kBabOS7tIX6Ld8bSHM9cefctKtN75kmUBcWL3AcHBKoYNzUFyuCIsTEHeo1/0CT6OC6hHeILSj9YfNzAMXWKG9wGPmWqwaqTZlzjKYpg0D615+RwJgTjRPDd78j0k1PfMz9CnZsZcQHe0OJ+57b+PRHxqyAVf0eDm0sHHPDEAxCfRLGWEl5cO8TYDJ6t0rq5BNFc86SO3n5RLGZ4u2CHEsYSh2+7CPyi0Kebmii71zujT29UYaTYthwngaMFlFko94z+kSI8pvpHptW8zF2aTT19StsNSBIGsVt8CtjxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gfzvobo8XfXb+hvlG1jmYrZPOZmjz14+z85sgVMK0sQ=;
 b=nNHnT+lZFiCUMtbCGTdotAUoeznP6lRDuwavQhdTeM07dMyHE9N4gS/XGjEjfFnsdOkdl2Ilw8dXoiqCKoCpTbr0z9wQYpwZJmpDwY4/SQfaIBYydKu6O3Q5Dldp8L3vDODusg6vYq+jplL9eGx9Z0K6iWQ23J1KpY5PMCLpQok=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB6836.namprd10.prod.outlook.com (2603:10b6:610:14f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 17:23:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 17:23:35 +0000
Date: Mon, 2 Mar 2026 17:23:30 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
Message-ID: <27c260d2-796f-48a6-8b1c-751ab172d480@lucifer.local>
References: <aaBVg6nPQz-WvyzT@chrisdown.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaBVg6nPQz-WvyzT@chrisdown.name>
X-ClientProxiedBy: AS4P251CA0009.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8702a8-7561-42b3-f4a9-08de78806ebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	EDOAHGPAjr0XiLsN3wFyW3uPUsKCsxSOMjJS4o7+iomQzLLVDVbbQt7tIqUaPjQXS8RjH2xg6/sOgTrFb+VyMAU+CmzVsGWubf99MNosfw2hnLxNcY2J5fpAK9WRWLogdi3r9Xznoa6DadS06Y+0eA5+s/EAjAlwTfThYspP37wP4aZf2AidYi3ptEEvaey52axmXbHxJsff4/NFTP1zeUMtBHtFKGBmGW7DhZnLqKRqF/pBr9W3VUipSN1zCDwIMu/LBfHPVK6GtP8+X8bp3z5O8SybtheM1pxDOUOmlcS3eAnA2hHOdWauWE1QxE+AG9D3Tfln2X9lFLwWkb+fx8V/QinnW1oVOYwLSaNbuxZY9wEwBxl63oRJ/sb9DOOoPZqDCt3j/eyJ9z7mCYx0LA9Beag3pOpP2xR5/QkqZCgmVn4yhCzhx9Ek0fanW3OZgqCvYzoPIX9TCXCMOuAPZ/0HdmB+K7f42LXd6WaVA4+d/HjRnzfxPRhE3L9eg4XxknWFrpmelXMrin+92Zu1iYo+zdYAkgBVyFjtUCpwWb15VQ8rlf4nD12c75t63WLanrCX5VKpqED/SC4LE6LRekGUgAagU3pyE4Pe+pnYUPCCw5Q9bXCtugelgNG2TFQ2pWph3RyEo42NY13hsYcJvs3MvBJ2bDUdqE92ujR4rqoSlYMczyB4L+RYSv7VasPJSazQPJUXTof/B3IfzpN3c7nGStL7cR+IMDR+HoFkvx4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ob6q6srcKMNTnkAvbpJGAViTfjVHoqMhjkXGZrD0CeIJ4NTtkoGLLqlr7V9N?=
 =?us-ascii?Q?j0be7AKrrKKRpABE3VIdNv677TswIoRHtLKoNYylgIU7jr4+HwfgsHvNOLGi?=
 =?us-ascii?Q?jkK5TKwwKjcm7y7bWh60jlXAdU7I7ZyPwkefdXejSRFizo56IJq5DukPDZD1?=
 =?us-ascii?Q?dhthellenQaOnh/8HHA0qgCs6OKpeW3tJunTN75kU7xO7/0EmgoyCEyKM5nQ?=
 =?us-ascii?Q?hRdMoWmRtUrs9TjQKiI4wZm6uKn7Zli6mA5A9fKoCT2wU0ffSM7tnLnGUMhf?=
 =?us-ascii?Q?Xr+dbLRccYHTwfaei8uZGmJe494jyB2n34IH3lw2yLfaNzFrEKkRe/TEXTcN?=
 =?us-ascii?Q?WKNyhG/byYMjEqlZk38O0zrodHtZ3tbbgSxFzdfFW8YCfRk5Uqmlz+BPa7wm?=
 =?us-ascii?Q?yKkxJFCticnMPir7BfSJaR9MSglTvhu4lpctqPEHrRESxosL1AU0rEBDyt+W?=
 =?us-ascii?Q?sUn2FhEoI8YVwarVUKwgoGmIVxVdgaAhj56uMx5CB+msvL2MtYjFtfwbZqz9?=
 =?us-ascii?Q?1WGSvxe+LTZ7YDGC4hxidYLdfzM3Y63fRhgwc95q759sYu8E+lFNm0ew79ZN?=
 =?us-ascii?Q?5GboIbgdFh3BPXg1+s2inUoXpet6gPUSHhAKn+vS8PzOtr2kXVgIiu0kv/de?=
 =?us-ascii?Q?580tVdRmodYs2Gcok87UCpG5VfwnOAX7g9A9wWuNQuTrQpwk4E8KeFUhuBDr?=
 =?us-ascii?Q?UfLYbmL5YjdnkgBs0YuwFLps4GX447ugP+mP4B4iZwHdmNoaUPWd0l9Ubpop?=
 =?us-ascii?Q?HKXoqDeAPUIvu9Dm1THC8Hb9u1DP/G61TsWKzoWq9M7ACPhJrUiPWc2oWGWl?=
 =?us-ascii?Q?KI08PmdA2oLe2lnMELSyymi9N0ir1RH1NEaIcLUZ8bZo8eF/ILAIZ0+OEe/c?=
 =?us-ascii?Q?qKxJz0oTvBFrHLyagHtD9/ud224DwG+Rc0Akw1seGya8+OTAH3+DQOwam+YH?=
 =?us-ascii?Q?9SDUEfc74OLNBAQKMHdTgGMwXOxcbCBVr/4cENZ/2NEfJy9al14HdHmJBhHZ?=
 =?us-ascii?Q?PJi7giFPLicF+9pf8MjwV2hEOdtz7SuQ0zKEqx1k03uY61VPYUGHb+qbGrVg?=
 =?us-ascii?Q?08AoG3HGgcjJeBE9t6Du1xFz+CvGd3e0H9VwNq35LRBk2hrgMu0Yq5eHpAgx?=
 =?us-ascii?Q?P+APmZZS0cVINvduDh8Mv5ozaSsnc5LfX3Ihd21LfDQUOfkHB5zMYF4o6JOs?=
 =?us-ascii?Q?nYTorg9+F6S7yXWKvnXZyA0nX7FNrNHGeUWYJw8eoeZzCk6eU2gf+JNfK8dP?=
 =?us-ascii?Q?btMhvjH32wiOIJ16uUqP3UyCP+WrZl0PnHokLw23BwfrQxIDkT5q+wFwmrcM?=
 =?us-ascii?Q?n4sd9uN9XBRvUeBskQbS4qey+X5ojztM55xFrK1wGKiGoB5jRqMHdXj6crMe?=
 =?us-ascii?Q?BaCOUY7UQE5JXR0CLGDk8TZu9ydlZB7+1zUj9iNtIs0lE5zUSMGfHqm7GdBh?=
 =?us-ascii?Q?9TI5NUpVlm7hKQgwAPkfrl/lMV07r17MTQaxa+ixAgWBfdhAztb3dhe8jtz1?=
 =?us-ascii?Q?bfkKJPz4wIok3v/EE+RWlagXLbwBmJBnTOd3xh+wEdb0+mJjw/1oV+mXYGKN?=
 =?us-ascii?Q?WJD15NLisaQr70bv1kn3jz9cn8ONZuN2kKwyajcjZRMYHv3r+vx7xcLwxyVJ?=
 =?us-ascii?Q?0m0dF8hwSLYOXrWgf7T9rPK+hPQJ3U1mqYJFzI3dGu94pZzZeZmRSD4sFhTg?=
 =?us-ascii?Q?PD5kpu0h3IHN45xoGZNtMWqtoW7SykHdotTLhvlM+m88TBFExT9lWLNbeG4F?=
 =?us-ascii?Q?e231nJ6LYD0tnO/Ue1hG1ZKFbQw+ZJw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ILQse0Xd5A/6QOPDMe1AdRw2iUpdv/KiqMu1WGJScL20rquZW06gtbjXYQIHZaqDsa678A978Bq0/BiEUr6CL+bYSSK1CqUTjkbBLeXyDmRAU2y84Ft2aKWA6aNut+RcDmMc8NL/QQPSis3uq5aS3SWsdq6R2rOuPGbKLsMeSA3yMcAjGK2OFPUaY/Oqiayg+AlE12nfu9MycAzEKSVAx3zZd8AY1IRbs0eCkF0Ool8FQvpM4aIhTmqAVsaNLwMKJE4LWnOKbjHQImRbB6wBa6mTayW3mj1FFvTqOG0o0wIKS5/VLj2+Be7LubdxfFlabRwPa+CittqL93zO3A1o6ajMogupb74/koIVvKN0dClBCngsUIeBVmhwB8ijNq+5vlXCYbiOoRn6tIiE5SACSO4Ekv5PWFVWtc4qQXko7LEB2rIv0gQh00fTY4G5scZZrCDZG+PQ+O9kbVJL1MUVIDnabzgZtFepEYx+/V+hoKadiybbbikBTpmBbFYYe/Thf7HbDNC5fI6/0x5qWUEASZ2QivfCV6zvGU4zcyWckMO5yEo0QD8daosqIF2SFpSl7fAAIGI6+B4L8a8BzA0DUxAoul5XP6KJOmdNdOj1a10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8702a8-7561-42b3-f4a9-08de78806ebf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:23:35.1258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0498iHLVIWutKi+8hjDsOjpKf8P3gqS4bw3GcpiRYV2tcOnnmuDHVzquKBUa5qV/5Jn0C6dVAHbcnLclZCToqefyYdJLrt/RMS6rWrWHF8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020141
X-Proofpoint-GUID: QaXXt6z_Sh9LiGtEcOq2OaIWco77zecU
X-Authority-Analysis: v=2.4 cv=DrZbOW/+ c=1 sm=1 tr=0 ts=69a5c7a0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8
 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=uYnsTo723GpWaam67iMA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12261
X-Proofpoint-ORIG-GUID: QaXXt6z_Sh9LiGtEcOq2OaIWco77zecU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE0MSBTYWx0ZWRfXwGFO1nmbwNek
 vQtwFhS9+g5tYrluXR8gR+LdC2NKGDpQuoJvEk1D5zYh1shM/EqDtrj9zKnAEjhVObSLlKGEFgG
 T4oCxY5yl+Cc7BYQm7AuESGlC4t0+1AilBFYPgUZmWec+OiTsWznRvClvSTdE3LjXhtYZYkAPh/
 GH9NmipwIc7yRLd6BkrBnGtvfs8ryARCLIHe3s0C2eWLkrOBySsBVnsxqaQogcXQ6fTxP/C8RpK
 R7UOm1HeEQahMl0kBKEQfW2+uBHhlpJVZ+xopmz8cu+IjZgMEsOp4mkMmThGHxLHftyA7UDdxYi
 KX+iapBnKM3Lri2oVf9dw02uvPuLp+6zh3xa3rV2WVTSOIUALLdHhmzDVWy3GiBS3I1+BJiHDVW
 XpoaWoE2s5GNsjLx11YDT959kuZzYVURuVjmrDmH/rfvoscpv9ZuBnjEYDtNEm9XOlWbNi4l1uM
 gRuPUpu4mA1P7/Dh8lOlMqGoJz/x/Hz4LlCRNKtQ=
X-Rspamd-Queue-Id: 1A4E31C0014
X-Stat-Signature: htbgy9qoarej6ibbxwta5wd58g8xbm6a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772472234-467681
X-HE-Meta: U2FsdGVkX1/uKeJZUS+jSRDg9lq5IWVlmNYS6EgQ/f+rJ7AMqII6TpcSkY7Az8Unt/KW/JCwxyn9d8xy5s01zRvp465aiQ6g6NuosCk6hvsQUHiuPk/vSthT4sXjz662XvsJp/WFHSSgOQqS5gxl5K57PFgbaPzZZLLUe0I07eSXWd1kR0vsvt5RWFI9ae02767fiAPOKJBVsFDFrL+LKZzgCHOITRCtJJZ3doa3oPwEhBJAyz05IzAOHbTirPn866XM724hoWM46n3oJ7a2bzPy7KVz/ybprJBNUQqbWQMXvi60jsfqC3aQ4a7fy1kMr3XtR7lXgPgaq/Y8qHjeJxB3S2Zq8XyV9IpR+HnkIq3vXthuQlhDE619ICCUasCCtTFi8EiN6p49j2STNF5xLgkoCqHerEWgeqTzLad0GQJWisK3DkvTkdwl3ES6TykfkyHBoPH5KyNfUS5J13xOrGFxG0TXbHlZb9j0qp109LhW6YhRJijSGZM1dZEHbdGKGckAYXPgjv/TLzPbdA3YV+zb+pzOzz+pdr07qwum0EBk4yZleKpcD+oc63SWNgfR4h0tjEZ/Vh5Q9Xgc3ExqpdUQtZegwVISYWJHbWkOXrY3O8DL4ocu0ESrNZhamFnj+7NgBQ0FTFivoZohVgirQiSwRw4vB4x8bVP2zZFk3wBCuqxOyVib+GqpelgvhpLDspBZ3eODCALn6ARo1ngikktZWHK4Y6llAOSMLoWI56aqqHR9K9v9RsIlFItPRfjhL83/XRr0lHZtmH+hjCsDfG6TO32nd878H78u5RDVtHB8xvcGPSHTgV12EJ0jckHyL7bQOFhmMacpNmbMFdGKfaEluXzfIdkAE5GCSq/QY5a6Hd7WD5IOOjKT50Jhfj6pMIJPavfmo7ff1KyMCvuhh9yy5/s5VbLTsQkeqOgWfX5IhsL3aGpVqHpprgkl+GbZ+77WcF6AJ0+rsBhsy5p
 Oztr5CmK
 /EU+a+KPiT2G4UwTv6GjAhmOY6BDpnvipvI+iX/WTEw7GSPlB9CLswRf74P1yWpuBcknBBzon1wiUsutianmGW2SSkdYTjFbmFK4g5IMajM6UChrEhiMcqEiCeB1xMjotVQWdqD6RZ6+2I/AMLL70jEzUJRXiW+8ngGxZG00IEGguiJP7G1Xt0KJ1TQ96jqxA+3AEE8soR+h1SmxTV/+eaE8fFfZxS0KcAvP4yYsGNxpMd3ii2eC7K0aHjA50OoO2103gM7cxReMHQpKqRVW8jxqwZ5dJ2Pqg/vvN8t2gxJymk/ufjxZDQScb7gC7WdUlvt+d6c/xAXaq5VmerVElzvweXcHoibpguxyUk5LkfDeFQhJUPf8QRoEDIT8YHVctq3qhpwe7B/AT/JPPjfg9qlefkDuO4CfUaxbxdyjwffK26P0zGO6uLlVDJDX1BKBw+fpowd4d4aUH+5m8mdtV0RTJxBhURz8BsY4VgD/R7IeHBjED/qaNt90nqnAuqR/3BKtMj2Sxorb8O2pYNS3/d6X4p9tKHaSaQFCLlN45UYSVKVvIRg9UcDBDoABQ3Ej2s896fJHdC8VBV0g3NNMq6/TqimyEuHKiQ1GdAZbeLRvH5KdiWL6WaJzX0/KBGiIkbBd0z9WiFpXUoy/WRkTPbShy53SY3tYErRFlBNEV1X9HcDLd7uLZ6koiEe/XS62lNXZMVIA9qCJKfIksxUd/tp0PQhYSyg7cPgZCifeWYsPtz1e+PO5k/0nsOPMlQtf148fbucm4mg4WP23P7dHVCbsXs9kpzH1siCfiR4JrcXfVGLq2eElrG4hmz6+lbIs0rZ+3WxZBxJ3K6oqQYm5fjTF5BpnDbvPZM0fz8C5emGCPPvq0dOeBHGm1wF3URxkUOHzWofU5ee1EKdr80b6m5FnHgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc THP.

You didn't cc the right people at all, which meant I just spent a few hours
tracking down and fixing the same bug [0]... PLEASE PLEASE run
get_maintainers.pl. For the love of all that's holy.

MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
M:	Andrew Morton <akpm@linux-foundation.org>
M:	David Hildenbrand <david@kernel.org>
M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
R:	Zi Yan <ziy@nvidia.com>
R:	Baolin Wang <baolin.wang@linux.alibaba.com>
R:	Liam R. Howlett <Liam.Howlett@oracle.com>
R:	Nico Pache <npache@redhat.com>
R:	Ryan Roberts <ryan.roberts@arm.com>
R:	Dev Jain <dev.jain@arm.com>
R:	Barry Song <baohua@kernel.org>
R:	Lance Yang <lance.yang@linux.dev>


I'm giving review feedback below, so you should respin, but in the next series
can you cc everyone above and _please_ make sure the threading works correctly?
As I can't even find all the patches in this series properly, it all seems to be
broken.

On Thu, Feb 26, 2026 at 10:15:31PM +0800, Chris Down wrote:
> move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
> zero pages. For the huge zero page path, src_folio is explicitly set to
> NULL, and is used as a sentinel to skip folio operations like lock and
> rmap.
>
> In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
> pgprot) passes NULL through folio_pfn() and page_to_pfn(). With
> SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
> pointing to non-existent physical memory. On other memory models it is a
> NULL dereference.
>
> Use page_folio(src_page) to obtain the valid huge zero folio from the
> page, which was obtained from pmd_page() and remains valid throughout.
>
> Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 44ff8a648afd..fed57951a7cd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2794,7 +2794,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>  	} else {
>  		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> -		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
> +		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);

I prefer my version at [0].

Cleaner to actually pull out the zero_folio into a local variable, and also we
should mark it special to be consistent with other codepaths.

[0]:https://lore.kernel.org/all/20260302170619.867056-1-lorenzo.stoakes@oracle.com/


>  	}
>  	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
>
> --
> 2.51.2
>
>
>

Thanks, Lorenzo

