Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22EF5CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 22:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83FB88E0019; Mon, 10 Nov 2025 17:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DE68E0018; Mon, 10 Nov 2025 17:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F01F8E0019; Mon, 10 Nov 2025 17:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEF438E0016
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:22:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A89315849F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:22:50 +0000 (UTC)
X-FDA: 84096123300.09.2CE6771
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1CAC7A0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:22:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aYTMltRg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HQUsxgcC;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762813367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VW1rVEDry31QDVbfRseXtsv01MYxQ7aH996ZkSCtb9U=;
	b=Xj2gQPnlcsAT9eESUJxOcCEzr+OyRMTNJx66rXj41xTGTigHu5wrnhNK/IzoRDiJqHQcNH
	1gZWNNxEWqbydlRHesQH+skj4QdIjkelbfUCkqBNf7//xN0lSUcrApNRRto7wxtfHpGfx0
	OvYBDBb5qAvp3vS+5ZFKNLfXrFNYtsA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aYTMltRg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HQUsxgcC;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762813367; a=rsa-sha256;
	cv=pass;
	b=xSF8jYkmbbC4IONreO7onnvi0cHDOASXX4BfQ8tl5bURTeKhh2zp41RNsuIK0Bvwnwgzjp
	Gm9xHmKQdw6qQ6yxD8wVnBPFs/xNJvgSv2V/JWTuAlPlG2wuWg/WagFXITFYtUf0jk6n3R
	yxCCnvA5pghrjzt5qBNTMxN85cddX4I=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAMIKUT025943;
	Mon, 10 Nov 2025 22:21:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VW1rVEDry31QDVbfRseXtsv01MYxQ7aH996ZkSCtb9U=; b=
	aYTMltRgp9YiSPPyaqMTEQM/Ky4RuxrMO7JRoeLoTQPvxNP7c2LaIb3xdgNkWaer
	XrczuDiUc7akV0qF6cqdgXxO7A+7B6DrJJAqabNeTwktrdpJbh8DiwVAoObva43Q
	Uer0c6X93MZ/xeuCZrTT2TRppd0cwG9mEU7OVIxlLtpfJKgf5PqkBFeFAOB5sL5a
	u4nZkPf695KjLUcWtONu51bn4dI3YzFuH+sVuDpUz0ia6L/NJKe1vqBypk7NgOJO
	7BpSTKcHwKRJcM7AyaQDLXVyISghN7LQVJIuTsBP/R0MyzZhWu+ZzSHBv3X+n4lY
	8BgBxMKj1jw51f2hcV9rCQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abr5vr2ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 22:21:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AALo2I4040096;
	Mon, 10 Nov 2025 22:21:51 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010061.outbound.protection.outlook.com [52.101.201.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8rypg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 22:21:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OtOj2C6mvDuqLVGdAMue/IFR8VS/CGw2pwyIGWMm41KwTWCGaWAgo10Vb+6R4fa3HRsyCjLr/c2Mm/VNhFjA88pMfqgPLkQ5va382WOODkPdDAiVYsVEUFan9ilNw3HrUb3pamTl75Zkp5/E9F64ppaAXV0I8qAz58yQjpfnAy7NYI17CzApUYZ6Gp3HjUR130yBT8PQoeKtPKB77rERn3XO/lcEKwFazQlmMnMJv6tAans/CMUpqfSg/x12kHGidCGMl0DTVHFGO0Yt3oEfzKQOI3Bx9vU4g72IQSSe4kn35JiC/PCmWpHKJyd5lQ0tikEUxQj0zdCNZwaF96K4zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VW1rVEDry31QDVbfRseXtsv01MYxQ7aH996ZkSCtb9U=;
 b=T48HDB3ho49W6PqbQf4D2rgveWw/WRMIdqiBwXdJwxcS2VXTR6f3BoLCTG54mYVJEezcqQVtH+j5Mp2P+WzulHrFGEGn4jrtS1D1BbsDKkRH0Hy1pGOAEGdwrlEa4qtKno6KkSDkSZPsA1YijoN1Qfji8eOGDTMKnkSHgn+u5pRg+W41iLOBGc7N95KSfVEEdUNFFNamTeaq7jr6VXYcFPm5A0hIjI1CEy2Yy2IrF305n3CWigPVhackwF/6KWvXN3qqWoxSQPVR6KctBEaNkxBR1lShm9+95y2Z5jGXjISByrudN0CacfA0OBkiPqNUMF7AfdA58xifXEoMLQ7NVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VW1rVEDry31QDVbfRseXtsv01MYxQ7aH996ZkSCtb9U=;
 b=HQUsxgcCxq9WkLSgOuY/F9vJHoMhaQYpgenb/b1IFsZ1p47jAhVQG7K11oI00rCGkGytrYD+Yj0LPSqQJ7SDyu+4Zo7Xlc8sBgS2H7JFB2Ba6zOPw+nCtOo801WqI7JA4U53qHsAMYDheg5ayrJVdHfPyEQMdCTVWxa6d3vo6S4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7622.namprd10.prod.outlook.com (2603:10b6:208:483::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 22:21:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 22:21:46 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: [PATCH v3 04/16] mm: eliminate is_swap_pte() when softleaf_from_pte() suffices
Date: Mon, 10 Nov 2025 22:21:22 +0000
Message-ID: <92ebab9567978155116804c67babc3c64636c403.1762812360.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0032.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 68971286-5a6b-4a2b-76d7-08de20a788ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6vwbNIFUjPKEana/ji5krkpAvAEnR77MNInpoPvsS3dyvkW7V6n/WlLG5RfM?=
 =?us-ascii?Q?4vYN3IVabWPRa480RohncOhot19NK0g21CCQAtaAmMcaPc2dh2DjGWynlkbH?=
 =?us-ascii?Q?C4cDx+Gc/CsckluY+n8+gvGXCZsD2fGFaBO9EJK+zKgzaiSXp/YX/Mf4Dtjs?=
 =?us-ascii?Q?wRG2147YO3JoDNnO4lbjZz5g8KRV76lc3HKUUHj4S+Dup4CZ5uwAoyWd+nQs?=
 =?us-ascii?Q?ctxVpTKEnB6gZ2m63eEs65NqyxF+4VGSX1wrKMM9GOtoqzgK7LLN/WkKUFGn?=
 =?us-ascii?Q?3IqmIXhNSf04NEGwPaA9P4MM9g3vRKMyioodAvFbmJ3BsodpU3xSnCJWDgrd?=
 =?us-ascii?Q?iP7FJbyn/sqBliEwb+nhmK1GiBd+If1WI0lqGgBhDpW4Ly1QVh2k+G/dIXK4?=
 =?us-ascii?Q?934Yrkb+PrDUxL+SQj9lIuWrbyvSg1com8+saADsI2sd0zyo+pZU+/yhyDaS?=
 =?us-ascii?Q?4DDUniKsjBn3dJLsoxl1zhoMBT9hOMDhXFwqvWqMHrrf/7mOqCMygqcTRvxA?=
 =?us-ascii?Q?1+undE/nsdfb6on4PGoH4Xx1EKYP9AlTRwuvxHOpLxyZzLeq/0rttPrFLAME?=
 =?us-ascii?Q?d3uULipmCOdOhlB2pNYRneFbOC97cLMFTdR048m9lLvEpnt4yC0023yNi86A?=
 =?us-ascii?Q?meCO4uXtX8WlHrLt312dp8EyEZxoe77cIMv+7ELSgl297O3Tt4YY1kq4jmDw?=
 =?us-ascii?Q?Yjxi7NNarXhANxUG9eN5sW9jKD5kEEV0ysZ3FmxJTKq2wYrHv/xfMVbahcpa?=
 =?us-ascii?Q?g7vU6e7m+PKjrRk4WJCc10ON6HAz5oVG4AU07E69I2eFmlAmSNmbdt+4l5Yx?=
 =?us-ascii?Q?z4stW/H7BeJbVbraQnt15nXWEaGqZ7f2lkRVyYhiW+yGYdRRDoWGheXct6jx?=
 =?us-ascii?Q?fEdBQbf2BeTpIFnujoxQXnZigFw4/QxLaAh6Q0V5b4fq2yDT0vzPHSUrEP5o?=
 =?us-ascii?Q?AZw7EpvG7JtCiCQVYEYTXYFEqSpA+qITQ9COXQd0ys72t5fmEuohYBm/HlBo?=
 =?us-ascii?Q?whOa3Puw2XSzzxHWeGaYh6Y9F0IiO7xXbg1xAMN8FFUblUhLW6NuaHzkINak?=
 =?us-ascii?Q?SDwFgkw2CyJlN9nOC6/zrzZra0KZlt015XMfCfUACsfceDuSB/m6i1hdTkQ/?=
 =?us-ascii?Q?Q6tlEU0gt0mdcaGljwc4vC4YL89yWOIbf3A4xwFaqQ1EU968eLa2j3OzmpVJ?=
 =?us-ascii?Q?jV37L8KES1F4JPEaerCRLUsVA3Y1aRVQQBgpMUoGus63cR48xnshBLserWad?=
 =?us-ascii?Q?O78FmS0gbBTjKcGQrISXsp7lOV4IVqSY36xrCBzCnYODUMyq+c8RxB54kMAK?=
 =?us-ascii?Q?KNv7Ft7a/uY6LkOglQxxtN5p2Dlj4iEGIrJ2MlEqumMqlAqGSJPXMgiln28O?=
 =?us-ascii?Q?cDA2Br1ciTHZ5YoukJCyT4oL3G9oCDJc3zg/vFyMM0XOIa1JOUySuCWBg/XR?=
 =?us-ascii?Q?LWs2CGjLzBk9tkRh2GiRtS5UZ/MJIZVI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kUxkDVzqZ7dCROhieK8dmfw5/fO9vo2DntD9n6BBU+vcMGjXhsF8/VyjC8vO?=
 =?us-ascii?Q?+La8p0OYDcvq5lHOE6QwXZYAYNUDV0BlAsMFNI6lSAb3LRp3zZt1u/xaNr1Q?=
 =?us-ascii?Q?+421gfGSPSgCbxAKTqCoKuJdTrmzwaypks5evOmyOgjx52/W9Y6nZgZiXB+5?=
 =?us-ascii?Q?Gji3BY6vhZdecV6x874zXk2kod+62SAS8Bk8ZXrzOlTAAdzN4LLpZIMLuF2w?=
 =?us-ascii?Q?vNin7h4+FZqt5vsnCaf/s81hZ+MYbzQiW9C3CNFrThMu1sAyI/RXZ4gHCLrM?=
 =?us-ascii?Q?7dCyI7c+14IgD9fxSmJtbQCuWN2KVK5Pylu5QhlGiQQGfWdGsht0QZbWoAtu?=
 =?us-ascii?Q?FwYEhL67Egwzlfyn7Stz0fePvLLbAgF9dtSQ+t6bDaWg+zEtv9wJ8lNHiFoD?=
 =?us-ascii?Q?X2Caca+ZK2rlixV1Nk5D9TFhy/lVd6VvYUMh5nzKbubQJrs9ENBud93RPgH0?=
 =?us-ascii?Q?9QIz7uJ1/fQcdMl1NgQ8wzEx7xSDrdMbH8aCoKPfUjXOoPvh6XRsiS+3FXF0?=
 =?us-ascii?Q?TA5KKmO6ye+Rft8juGU63KgO2+pU/bYFDk+6ZvoA3CAMoqPYytvxq7niYEbl?=
 =?us-ascii?Q?vl7wPFMd9ShSBlDhTtD+6BikjQgoZ5cFsL4PAml0VmepkhU6WHPM3gHLd5EN?=
 =?us-ascii?Q?vSMqNE0QUDXT9IU3HdmOS61pj95vovvV/mvkbmZHjawcMD7jIzrdMpGm7hnd?=
 =?us-ascii?Q?oqN56f00Zjg5uD/HAxiUXbdhykF4c+9VdDC+dg9PvZAnxUUh3dd4QiCLPigq?=
 =?us-ascii?Q?ZZCl3T9XbdGDJ6cR7jFdXh4KP68HsthwCsM1WIcWZXuPvXSU46xozL4Tqv7x?=
 =?us-ascii?Q?/P7e04sMd28S6r5LMHydVJzdYSy69sI7zw40brSnyGGK41/4TObLQBlz3CWL?=
 =?us-ascii?Q?XLJ8WIxN5KCRLFGCRD50UnAYyEWEr1cWETLUmEoIfXOd1arKz1d9eq1ha8kq?=
 =?us-ascii?Q?ZqK4PzAYEwcEdncXWZQwkZklStgmR0i7doW8L77SFfM/8J/NNQox6V4aLKX7?=
 =?us-ascii?Q?tG5Zv2AYO0X3XEMBeKemNCCtiLplVDsNyDrVesYdfUNf0uGbaqnrGeRLDgl1?=
 =?us-ascii?Q?i7FBPDxouXxcaoZaH0IE8owxfC680HF74egcWKZba2jIVvNNjh9ftumra00m?=
 =?us-ascii?Q?BsIzMNr6onSNxumuqzl28nBQyFp44jIz23UFwu5ZCSJstDlfAbJc6h76Su1V?=
 =?us-ascii?Q?oupbePaxBVzoJ7MQWUnbHNRQmojwMqk74YNY7q/hFzbOxHyeqJ5Dim+XZJf/?=
 =?us-ascii?Q?NANOOnK00yipYhyFvbuBtk0X9PnCOL4OosS8/2AajTRbKWGpblt9KAPadlTv?=
 =?us-ascii?Q?RvSnXLeYpKs0Phg7v9Gsp7v8WxLKqcBmX+340dBcL0GRL872bZjZainaWJsJ?=
 =?us-ascii?Q?jD1SfuFunvlAesyWaRl2ZSEHeBJFEomea0sXBjmQVnChTqsJzvqepRoe67So?=
 =?us-ascii?Q?W5gRWrcdpqOzaFYvnW08s05peYqQmSFOux9b5LFWCo5n/179A0leGfBF0mJ1?=
 =?us-ascii?Q?FYDgILfnvNWU7v4pixATm2Wanqd0mBfr0km4giH0dJat759c9WEZ3yjwbLrG?=
 =?us-ascii?Q?t0tJkeX+2T9fvb9MsSwxDJCtNsuXvJrMeCSnIRpB11VTRrTAYZXAwXB+2QQ/?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nZQt3VfhrTKWOoDiFM0XJqOWCOx/NP8F72kZqu8j3AFlUeT+d6IlmgmytyjzNL+Es+3fe2tcJOqaqFwEjKi8sbAZAKWopB7rU97qUKrrVc7nQ9+KgrhtH79wcVLzhXbA8cdJLbDofiV6fHd8FOAklK+nNeJ5NTGMz/B0xy5gvs5T4O72s6h0cxHiUfxGggZUMiBCMII2l8RaIImX2z1e/9bJbad2njsUzNnv3bU4GagZfwz11zVBqYxVc+r3uLYjcACFXx1g4vrSl8JxheabHzG5Jx3mOqLDN9HtQMYafyHsZUKVBzkQhXhpItiYwyGj/wljnSowi/EvmCLhduI1f1dt50QLz1zL0b0CYeomS5Th/rgcyZIerdOBvpR7E7VP/jKjUg55ccW84NZAperSqI1to/NaVniYtEwrXzpwbsjlvQMyTxnCsRLjQ4SH6vLWMU7kUjbqCn093+ybTwmjeG+OyUQvMiiZz3jDJ1WnH1plz3uGptLMYLYDk5ZijGMXMf0ZJ5epSfy01yBuaTGpYcZxLcooGg867k+9O2XSg+Wu8IvF+kGvBpDX3EobpYaclin/pHk5AMxfQ8EWLhuPbBwQEJywBghWS/tDPu2bxxo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68971286-5a6b-4a2b-76d7-08de20a788ec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 22:21:46.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vfYouWY6f1CIC6VUBUr6kKvD4AdFvvt2GNGwXF9eXj1Gr++pL4qj/VLWWaLLe1ucN89/k9iRb5JXUecMlrVvwAee/5J+O0NKMiCz74T65g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100190
X-Proofpoint-GUID: J6K0JQeCzL56HZuvwCHTmCCcY15dATRM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE4NCBTYWx0ZWRfX4F+W3hWa6N2m
 Fe6VV2zNOWuTmjo6eoRBxMX8JIM8jdXtE47onYwpj3nTRumWvFT29NaMyQwmn1k7VQbFhrbV2MK
 T/Tb3kwYe287RpfeWDmSSNkf6oJMlNUcKs/QKSn3ICy3dxdw0dFvNGJMlCedG93KF8x0xUMvQ8y
 NbnuV3uL/EanplSr5zr8MI9ey5JU8JF/s+BrqVw5SC9UjzepEIvnBkWB1cb19aLOkY6/XvjbpF9
 +oIY50fXdg8t4pSmq7NhC2nJAqy9uEvX+w0PaXVgPXLK+6iiow4F6WNyDW9yoAwMnprQQmOT0RJ
 SknmTlAQprRgk1LYpRd0Fb4yL46DVcgWj+ygjbQsKqrZF9bcwZv0RiI2qgsK09RaW+t6opoZngO
 LZFcv7x0paAoVDW9NvUH5bUK8rCmvw==
X-Proofpoint-ORIG-GUID: J6K0JQeCzL56HZuvwCHTmCCcY15dATRM
X-Authority-Analysis: v=2.4 cv=YN+SCBGx c=1 sm=1 tr=0 ts=69126580 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=x3qbZFVQRPWiRpXx7eIA:9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1CAC7A0003
X-Stat-Signature: ydjsphoxzukpfwunsn7g4nchsick4wh1
X-Rspam-User: 
X-HE-Tag: 1762813366-716590
X-HE-Meta: U2FsdGVkX1+p/Wa44Cz6B7RFKwUbgthbTbU8hq9zK0jNdnNhpRvASZVS1yoKr+mgpw0sPgWku9AQzrq0j19QzpbwzAdEq/fCaEM4wfcmPNvK5536+ZCIrvjohM7MC7uYPQOTLEa6MERmMctua+n+ijyya/VKwiv54V/DO1C7eUOULXeTUxIKipUJwDiynP59wtqFVSKpn3tHTNRCKXW1x5VsimC/rJEFqtYFPJKkbS0yeTdvyIIEMw4LuFpHrgmShDgu/bQp1UYAcZ8yqYIg+l0c5YTWMnIHneyd20SVNMt3nV6Q5G8eN72+tiNxYnclESJ4mJnBZgOtNC0tJbnJ2NaBegXH/QLHpudbxzUtv18KVfl8PWSp9Xa23QPg5CiHFuhHM88wnIr8vFFha0NFdyCZ2/ylwElGeoO5syoeMiAsC5+OfBdkrjZ/ji1ReKuMd4i3jZ2VBAVX1BRapjxj1LZhxRrrmN3T32xsWFxXV+0fQbM2rOfsuPULmi4sGFzHfmAyjANUgJpvzT779jRwtvSaPdovqNfEre+gIInutioMftqnc28+xBl1pwL57fEXXhExefhTkKUKzmgnHVz0TC7QpBqWu6M1aesWPGZFNMbDmxTWMb8KLV5hl1jJelGoOVsOOWcEg1+JBAHfs+AIdHk1S4JZJfMzufjH7EeeUhitW1xjZeoDESKQcpAQrnKSEFaTOHlRE+520O4zoNwjEQuzuG79fg1VVSVhq2shmxfAcArlVS0YuhsWTaVD39ZAyy7Z0DkFdLDuHs1wqL0nGp4IELw2P+tof3CcGw/eO4lYTUQsynm3l8jHOgvN4jOOKeEQI6T7TFZqjgKoi6LQkjTKDcRTW0uomOJm/GoCLT4RHCoAd7zPcTz1USabMWKFSLfCd5ChIn89BeWFwkwZTF6XpKalJe83IIMFUWPzPAkeWlIIVCiGqvO0RP7swZ2f2Fql74BtxHiZXznJlhK
 5LCaKyMz
 KKitoASCAlv9zDgeawGwovE/njpUbC6cEI8mPpI8KKAbkBLYgTg9WhpRybd5QqUSdqiN7LAmJrT1lwPaMN8/SKPLr1rHwK87sTFIVtocuCHZ4q4oG17Ue1PXnxZ88gOZYStRH9VI2DpAZ9PPvE42GlVyCL1OHkh5f3uU2G3J/86hk465/bhtr1jC6u0Es69RTvZSrJBV2mvUwCxZ1yfwmQ27UBYHOgy79xsTh2LoHKKXrscB6YpF1QkeNL/bm46axdi8sC1kaxzfLjxJPfwyHDCs6f2iaaqyFB4InLrkvmGz8xM34t5qprQYe4HLrpePNiGV15s6NnOj1rUUYi1Ubjm1V1vpc1gKDY76d+RnpY3ut38JwuYiNa/fcpaAWVohGj4LMJ03N4PgjNtac8NAxI4gfPqNzzH55nFSWKvrqQ0wx8kFTZvuuHgu45Ft6N+dswdhNRb+qXSjQjPi4JnfIZnO9ojlDSPQkSBUgNqs354coBQ2dJt3Whz3x6sdGyyL3zZ/jZbONYknR9FfpFJYZSRLArUdEVupizJcBNW6hAWxrt/j1xGnVGe0uqhBayhgAu128kXU75zVLSPNxOkkGgNhg15C27ahTBSHLmux8oxralaRMIjAYvLlTx1UtglTy5YKLCOk8pWSNutf+2xv9wiMuoS/diLHQqZmmcIrYxSwP8HfGk9jOGMSVYLKFCnb6Gll9tk3FbcWfQja/xExwZ8x81n7nSQF9OafwizRu6kLHIib6XzljOE9d6WOlCTazUlZGBbroABCI8iOU5cy8VcGbCUlhp/cBUeLU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cases where we can simply utilise the fact that softleaf_from_pte()
treats present entries as if they were none entries and thus eliminate
spurious uses of is_swap_pte(), do so.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/internal.h   |  7 +++----
 mm/madvise.c    |  8 +++-----
 mm/swap_state.c | 12 ++++++------
 mm/swapfile.c   |  9 ++++-----
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 9465129367a4..f0c7461bb02c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -15,7 +15,7 @@
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
-#include <linux/swapops.h>
+#include <linux/leafops.h>
 #include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
 
@@ -380,13 +380,12 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
-	swp_entry_t entry = pte_to_swp_entry(pte);
+	const softleaf_t entry = softleaf_from_pte(pte);
 	pte_t *ptep = start_ptep + 1;
 	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
-	VM_WARN_ON(!is_swap_pte(pte));
-	VM_WARN_ON(non_swap_entry(entry));
+	VM_WARN_ON(!softleaf_is_swap(entry));
 
 	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
diff --git a/mm/madvise.c b/mm/madvise.c
index 2d5ad3cb37bb..58d82495b6c6 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -195,7 +195,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		pte_t pte;
-		swp_entry_t entry;
+		softleaf_t entry;
 		struct folio *folio;
 
 		if (!ptep++) {
@@ -205,10 +205,8 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 		}
 
 		pte = ptep_get(ptep);
-		if (!is_swap_pte(pte))
-			continue;
-		entry = pte_to_swp_entry(pte);
-		if (unlikely(non_swap_entry(entry)))
+		entry = softleaf_from_pte(pte);
+		if (unlikely(!softleaf_is_swap(entry)))
 			continue;
 
 		pte_unmap_unlock(ptep, ptl);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index d20d238109f9..8881a79f200c 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -12,7 +12,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
-#include <linux/swapops.h>
+#include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
@@ -732,7 +732,6 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	pte_t *pte = NULL, pentry;
 	int win;
 	unsigned long start, end, addr;
-	swp_entry_t entry;
 	pgoff_t ilx;
 	bool page_allocated;
 
@@ -744,16 +743,17 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 
 	blk_start_plug(&plug);
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
+		softleaf_t entry;
+
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
 			if (!pte)
 				break;
 		}
 		pentry = ptep_get_lockless(pte);
-		if (!is_swap_pte(pentry))
-			continue;
-		entry = pte_to_swp_entry(pentry);
-		if (unlikely(non_swap_entry(entry)))
+		entry = softleaf_from_pte(pentry);
+
+		if (!softleaf_is_swap(entry))
 			continue;
 		pte_unmap(pte);
 		pte = NULL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 543f303f101d..684f78cd7dd1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -44,7 +44,7 @@
 #include <linux/plist.h>
 
 #include <asm/tlbflush.h>
-#include <linux/swapops.h>
+#include <linux/leafops.h>
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
@@ -2256,7 +2256,7 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		struct folio *folio;
 		unsigned long offset;
 		unsigned char swp_count;
-		swp_entry_t entry;
+		softleaf_t entry;
 		int ret;
 		pte_t ptent;
 
@@ -2267,11 +2267,10 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		}
 
 		ptent = ptep_get_lockless(pte);
+		entry = softleaf_from_pte(ptent);
 
-		if (!is_swap_pte(ptent))
+		if (!softleaf_is_swap(entry))
 			continue;
-
-		entry = pte_to_swp_entry(ptent);
 		if (swp_type(entry) != type)
 			continue;
 
-- 
2.51.0


