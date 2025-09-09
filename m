Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F87CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6178E0015; Tue,  9 Sep 2025 15:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167588E0001; Tue,  9 Sep 2025 15:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F223C8E0015; Tue,  9 Sep 2025 15:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D84C38E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:10:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA9D486A79
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:29 +0000 (UTC)
X-FDA: 83870652978.27.CE5BFB8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F62DA0011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ThZ58WVQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Y/4qNqLL";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yx87GtOve6aUoX2ryo3xamI/rt+J4lPAQ95taV+yLdE=;
	b=Zy0XiODG94Oky0A9jBhEGSS06msM6dQc5Pzul4pnuv5AhnXyPW66hwqpomMCD5FyCC39zo
	CuXwA8OzDMzypIB2aqEToCQ9iz4q5I9uTvPQZgv7C8M/EfYrGq7xiMxZBW0jWxmDQLs353
	vmFRj5QE8gg2UzoXu8GxmAfkMGOYjwI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ThZ58WVQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Y/4qNqLL";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757445026; a=rsa-sha256;
	cv=pass;
	b=bd/m+2TJjqORI197CeIhBD7lCrs1tTZXv4YKX3mawVEJtJUv2E1k9eR+NJgZRji7c7yqf6
	x5xTUmO+BhPVoC76atQ6afcJWNs6Izd8ax+LkTWtIYQnBVQll3ui+B34MfetWWXkocmbva
	zJltDOZfQr7LfBOHNhmltqtIHBhazSw=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589Fu10L017787;
	Tue, 9 Sep 2025 19:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Yx87GtOve6aUoX2ryo3xamI/rt+J4lPAQ95taV+yLdE=; b=
	ThZ58WVQWrTTFrNnVsC7/YzChVRjHbgSWRa0ACFxbgIyS7bb29DEQxuudYGG8tYZ
	awjat91zw4aX1Q3GC9D5w/5mjPnE6yDC02g5QFDVBU6SLkjDUYvhtCpC4SvnzXMC
	EZkwXoIUdBadQJzdFtzR4koVnfTHBrDb0ancOMpwfIRUEVtwbpSu90Ud/9ccrkaD
	n17uflCDWXgD7mDsRZkmav+ss7QGuA9+yXmV6p2U27GwXEHdJOhI3m5o9KyGil2X
	ggatBkj7+M8XuRmfjYQN4gtEiJ8m/i7D1qoh9s9Z3kRzEwRxw17zbzmz4ux5QW9+
	TT6utWlI6RiWfXGFihqVzw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2tr34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589HNQnu032845;
	Tue, 9 Sep 2025 19:10:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdb1900-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdjZxjpXi213vTrmv15Wt0Rn+hahV/qzfH5ZyEn/sBzFKIURjFuB/wACwLSbZC+cfmO9ChCXrEwqjk/wCSSxdLzQXqDwP46F2ut9Xxs8luYKwvXUz5YDZoELs+naJhIgiy977nnMkM0UBXt9BiZZ+KgldqRwJk0WZdZ2WYb7Vqmv3s85kNDZsg/LQs3J14oOdusv0rwhK8EGz5CGqavmcPA8iDnrWKooUCEH0zkAP2PoEWeaI7xw7ElGVcvBVcGD+GM1Vfx1OhH95W9f18TgWXf8i+43anLUFlnsBdT2t3b8NynVYCpKFBtcKgJtSMkmKRHGj6r23K3A5sg9AmcVyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yx87GtOve6aUoX2ryo3xamI/rt+J4lPAQ95taV+yLdE=;
 b=ao/Bi+mtInVdQ5qIGn/DMctNqlKROSo0Q6maVygFAwKeUmi6o2XyJX2skDzbxu9GdHrx5onEYLrZEEoGUovsgCkgDgIE5lnr6aq8TFPwnoFXngJTAbJzvleG8sPbMcOm6zagMEJXDy+rj7iUBvRVOefgai0dYSYUwPGrZiIAxn8Xym5qij4g7UCUv/uLiNi6pqs7tOC93d23GJ16e0moAJ0mEZL+O3d7CdbTA1ATn8NHlyqsUJ0+cya9lwSL+t+WEkAAq6fOIGOAEQe+9Sy1jRUDYhYoS/0qIZCRbKsvttLiG3jM9owjdr4odg0wVbAMnpx7kNNNhObFfCVcTUI96Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yx87GtOve6aUoX2ryo3xamI/rt+J4lPAQ95taV+yLdE=;
 b=Y/4qNqLLa/GONvYedNlt0ONBG+y6LJEBmvNIpHxsxt99ZKHSNeTAFoIEUGogkQ5hs6B156U37UGPD7VJlYZFyvGH6/SXFiMqkiRdVPYWY7GRih0Q3aoPNTxwmHZ+47N5fCzgivIGumu5Zrw/85cNzJWRgHgakI8WSWTWwUnMr8Y=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SN4PR10MB5558.namprd10.prod.outlook.com (2603:10b6:806:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:10:12 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:10:12 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v1 9/9] mm: Use unmap_desc struct for freeing page tables.
Date: Tue,  9 Sep 2025 15:09:45 -0400
Message-ID: <20250909190945.1030905-10-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0157.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SN4PR10MB5558:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d41bbe8-0904-49c3-5544-08ddefd48060
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FawFjkFQVoxt5J/EaQkI09GroptaLOuZO1gxiygxCBq3J9aXFstQnmbo8QVQ?=
 =?us-ascii?Q?mtKr9yv69Kur4qOtIRY5AUtkcLS9Chvi0a1Uqu8PznfhND5JqxqPwHcyuVy7?=
 =?us-ascii?Q?jcikaCg+d8QDSgl8RPnbfNmG8yzF3xGxlg1ffzFAUw7a5NPkgNX5bxm3s8fq?=
 =?us-ascii?Q?OIrGI9hMKHVVRdcWzrglsMdoFsZjpWe6XT9pNjC2qALNcFfBkDUYBRXMvfZa?=
 =?us-ascii?Q?TyXZew0kIzoPcfcdFYIBeGOIb2uO7KNuDv2rkwprsF5Zn/Ha+KVFlE4nFoRM?=
 =?us-ascii?Q?Em64b4hCBfBflGKPMCFbo2LueWbd24gevMg6cqA4Rv+G0ClI1CN8wIb7ODXy?=
 =?us-ascii?Q?3N6K39HT0k65g5tq3PPgi2UScJqhAMYsFqkIIXaI6OBRYQ/eLKLbIFI5VMfG?=
 =?us-ascii?Q?5AQ4+eTEWEQHVerbCWYdj4Y0wpyb6EDIuNN3M9YyRWLzT42xldLhxupR62/+?=
 =?us-ascii?Q?xHEZn7gngn32pBGy1RrAMlNSP39000Pe+IUsenMVCWuYXmhoVPWQLcbIt4of?=
 =?us-ascii?Q?19g+h0+CjTvOIAcMtMjrZEnHqmADgK8HUp0/OIgP4nPb852HZwiMOLvn555I?=
 =?us-ascii?Q?BDXGm8ZAd3grWXe73CJsJvDvkQqlUdPE4mlIP3pnu+R7VYX95EzUl12bEooc?=
 =?us-ascii?Q?Ozjv2wNg5wHq9U37onHXnLJsjsUnBuUJYcnv+cylhK1e+ZkpfHF9cWzklqv3?=
 =?us-ascii?Q?HTreplq7e18g1ULx94zI7xzkTHlb8i9IH3AuAQEu2PRI8CRNE/wEdTQiYScU?=
 =?us-ascii?Q?oiCN79JYRqT+dxk74wxKs/NGo029Wr+fb3PDXyBqhG4T2Vq8uLJdQrQ6QDmk?=
 =?us-ascii?Q?ztFmJ7wXed1IL0+xjUvgWAYR/wouuS0PTEGQhELHBJTNHTAcC4TWMVSyUZ1A?=
 =?us-ascii?Q?hI+q4G5iUrfheKXjWtM7ukEQtwAIG2FuzeuPOpFNstLCT16e4MqMX7I4c5Ld?=
 =?us-ascii?Q?TqsF8qU6nXRujSA0obWBHvbJcbwSY3Cex2ExOz2zujG2f4donmkb3tzwr0ys?=
 =?us-ascii?Q?xpuiG54lsHgF+ASNKXN7qVzCFSeOE7TEs0a+BnCF4Zoz2nAY60ALLfMYmY8S?=
 =?us-ascii?Q?9ZsWQH/H7rPHQWcdfj59Oe1MY9xJS63XtU2Vz4H0PEhMawD2ClGDOJQBFjb3?=
 =?us-ascii?Q?pxePbRDz25rR7Pwq0x3syk1As9kxUiWyC59Cmkh6g15TR92IK7xKXbgGky36?=
 =?us-ascii?Q?EtdtOfcFvAfwFDNweuxB/hvg/HolI7TX9vd8BIs8ypapo7QB2TZHB7kQMqZM?=
 =?us-ascii?Q?L9kLE4BCvWvEdGCsaa0Azry+qP9Ap+Kgznha+5yDoDQ/gm+05SiOGjf5QxKE?=
 =?us-ascii?Q?jRbHAFQP6mv7lgIECLrRXgbiMw8tHa24Ihl6/Gp2hxM/OmBLHShErGqRtosk?=
 =?us-ascii?Q?qkl3ym0Gbw5rBFmPPw22PYgZ+jmXiGYzWzIQfSFyZtnLxnIrlND0H+7UKyNl?=
 =?us-ascii?Q?KMc2aArFM2Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?76iN2fZl9lwsfZ9mfjP/b+XfNmXgizlIHcu699r/RCENXsg26ZS8cmvuJ1TT?=
 =?us-ascii?Q?84jxpDydeE5pD6ocixMH9S97pW/nTvkbyMbvVy7dVl0aREHQBzSgyqf/Cjln?=
 =?us-ascii?Q?BzH6EpsY28s2NoQqeMbvQRybhuwHkw5/PurY7KDMgPBEXdaUjDo4HYAOgvl/?=
 =?us-ascii?Q?jI9JaIrbubOUV1xX/L6pWW03c8tAlOVVxtowuEVwtF7Or0xZhrG+VwDUOHj6?=
 =?us-ascii?Q?0HON88r0TYQqnErF5hUdchliV7K4XDKfkp6A21QK9HiR5eGttGwmc5Rg80LC?=
 =?us-ascii?Q?IG/hozxm4JEGj8IgK8o+OrCpWTF6SFBBB/9MJ6xn3cBKhPpLTKrsyC22V4Qj?=
 =?us-ascii?Q?zzIj6cyLx4AmDpYi7ZTXYNO4RIS4fk7rqCVTA5gOM4zxlV7xeqOY3eOMZAZ9?=
 =?us-ascii?Q?PKDWN/4epDrGLHpBS4om55PbeR2p6uyqRmJal/qdd7iVLGAzg6sPJCIjAGFd?=
 =?us-ascii?Q?QIVuChKndkoopaPvQeZoJYqlvtmX1BsrB4eD8kW6qpzIPSVGC/UYd+9aad88?=
 =?us-ascii?Q?62ojVB5Bv4FKDYhXfzf1CWzPQofdiP91P0JDtUxpF7b+9IaroQ9tR8LrMmuR?=
 =?us-ascii?Q?D1plPvHXz9E1T+UM1lfvYAOdrxaloWx10StTIFWq2OeQpW2SV+Ap9aBsHTF4?=
 =?us-ascii?Q?cJCMdlHhFVsGI4e5Fpkko1gWRQjmf6Lgtic7bqTIhh6og0ODXJBhVzQhHUSx?=
 =?us-ascii?Q?Zvdd8NZZxrUcL1N3SxxBm093E31sjM6VAF7K7fpxCVr9FIZqrZrVXRQyv3Ay?=
 =?us-ascii?Q?k/piusGqJRr6OJ0YVV0BVB2G1Z2j/nd8QBiL5TxBIlqbTaCHzVWttjPhe7t/?=
 =?us-ascii?Q?mkeSZhnBUgT2sLebmv96IbZsILBeRumQgeRySeHb0fxuBNouYzxKniIk1GNG?=
 =?us-ascii?Q?SCv/Cm5qdvW4N8zQe04MO5u9OxuvKvHXC+DZCYMxJYFiDIPrPXac0LlttbJj?=
 =?us-ascii?Q?f++B0OYNQrnTxxGQEft1qXtj6JlG1scsKAfOT4ISREabc5kFwi23mAeqDcNn?=
 =?us-ascii?Q?jbohdG1ppOASVm6VNSn6TCy7IxONJFvzTSgCQGSCMfyLe+wM7PHKNJwqHckr?=
 =?us-ascii?Q?iwU2sZCIn/YrgBWnbCyTm1+uh8Y/pm8giS4/I8U3N3Imz9xPqcwbpmmyvk/u?=
 =?us-ascii?Q?w09jj+Ev+zrksyMNXJZfS2fNk5aXDD8HeWpExrKnVr722vUGlJnm4qLGrOk+?=
 =?us-ascii?Q?5ciRty6chuaYp9BX9p6n3sym6TpSdTPywU6pPhq2pATGOGMTr49ljnidBByw?=
 =?us-ascii?Q?xkeKY3VjxXg0rf3SDGEAPNZW96Ru510tTrar8yzkc9TcGiUhyXPwuJq1GFuY?=
 =?us-ascii?Q?64Ak0yQ0NHLIkx4SpNcI5VDElrJqexyEekHODvaSldlFH9tNWfetgw6u7Oed?=
 =?us-ascii?Q?pwc+KyfFuta9b/nVYoXJ/VECYpbiFivR8F/Z0648i2/5Fqq8wUMsUWn/LRzp?=
 =?us-ascii?Q?jt/fZtXFGMQ6nmolwaxKI3xgp+FWjbBhcFGFqDVir2JItd2Xu5UawgswZxD2?=
 =?us-ascii?Q?Ht9P4bzAyiBhN1KN7IpltM1w9NmVsWTFB2vUUhAsCDmOFrW/zxQEURye3exj?=
 =?us-ascii?Q?4laDUzq2WJnrQX/+lBQKEZ0xQ6sA4McyNighpWA7GryaKwegYAXVG4vT0DF2?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EFCO/nKt2Af2kV8JBUk0AUWqMGzH1CTZXl5UGxdsViES/tCrqGP4c4VeUvlkypv7v/QXjPjbzh4pDXGz+LmtXNuzHeq+9HipEz+4WePiky+xirXFyVkKb+9vcLrWNDHnMMnGCqEqgFlU9kZBaSZQnmndtyCT8TCB6RFuRNuj7RfwkOl/yj9NQWab6nDu/lDmbaI6neHxgj4jdVoBn0x/9M+qzIb7h2xEh9OLIcT1kY6m3M0AGhA6UsG4nobDTFLtSG8WI9DwaIvPHrHOZzMcpK4QSkJUmNTtPKGeTA58Oz3xtUMI/uXXefsiknQguR8FPhSBVsk83LnIj7uyL4ThmWvvSx3Ag1/vzH/zOCBf1+VSaVY2wRARvbK0HKhm31QL5ffvBzndmZnYB4G+iCjV/rNeterF6QrJ0uxrfFXrGNHwXsNq1T/CPZhiioIVfR74tqo9pXr5+xctOSR7yQTsFmS+TvDm6iJAOP3Gbw6nQD7ht3JUSTfqwI+uTKNPqQ/aZQjZBHU2wQ2wm755PXYGbwEzrox1ICDtzyRP9mVTpcYAhVSeahu7hlc2pHi//DAdQXIE+QQrBGdmkJVkgAHZ6y2L+uDFROoo6uc27/+S0NI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d41bbe8-0904-49c3-5544-08ddefd48060
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:10:12.3458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HUoVO/TxUH9pgDsNWjaY0kptmM+/iZfcwK3Mz2oKuS9OZS6QVmbFdi4zlSo9waeOzjYMli3/JqLVqnuP5R7a7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090188
X-Proofpoint-GUID: vKRiWJhKKDU962EsRloS99Rs9FSykU0f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfX+uGZ2Ca2nveN
 V85m9f/DKb+EZ7BQC6D8nNNdic4wQxkl/Y9mXXZDJi6MKqyrQTm8vF1ExUVEqcOadkPXFfksRTT
 g3Dcscrm7OzEWq5pKhDae5nqfSSjdsNWQaaL27wBdGtqq8ai/XrtNWQp8feGzf0LtqkGgUIzTvX
 F7ABvkcmzFH7ThC7YgCUgHRO9cr0OxLBXgbRJzK2VFt3AwvlfI5MePe617OA3f5TYpwsGU7jwxs
 sqtM1p6qUa60l8QpKLmKgc/O1mPcTpYrcloiFvJ2VhKdl0+hJuvS46+SDX//oYWmyv7GaaFrJub
 LSkpa2osPhJ8QJVd4LQk85KVLBmd/i32f2SzjivZr665ORuXO0gwE4N7fjGUmbxzcIfEnld0SaF
 XtLwOmDO
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c07b99 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=ao0Za0JyZWCtd7aAlgYA:9
X-Proofpoint-ORIG-GUID: vKRiWJhKKDU962EsRloS99Rs9FSykU0f
X-Rspamd-Queue-Id: 3F62DA0011
X-Rspamd-Server: rspam05
X-Stat-Signature: ucfkwrdp9ox3jqq54f4pbi9x315hju8w
X-Rspam-User: 
X-HE-Tag: 1757445026-682363
X-HE-Meta: U2FsdGVkX1+TZ0CJ06Xxz92B1bA6iWPViNyiRiu2MCvutEHJU397n+6O1FlN/o/I1BhjC6DSfJSweqQHGdRPLoulPYx/Ms8dG3IVrUwkM6AOCniIa0+qI6ffs8IUK+NMW9m2JPcr4nvCY1d3OIhtizUIRK5U+ybYOdddg8LAQ51C4/F8EwHbFd3+pB2LCHqoZSI1/Bac1uybHB3LAhm3iic9RnYB+3NJi9mJcSqOZ6RELbjnkqSj8RZcd4I4cjsKr26lU3CfWD40rOT4G3wTNpW6yfiHI64ugQ5O3i8R5RuOGv6BC7hvA4A4rJaKeEKPeX5JOKzbFfeYrlThFuMj8bLvZTEL6Typ2+5cYfgeqpVzQ62btZh/2J3EY29Lk85Wiox1DovAEF+TW3Atw3WMJpAcNlwsyL6Rc2l+9UFxFoV6Pp6dM/nJ2z0mRA2a1QdM5LfksPcJKAZJbr936FGgagO5TGl3bGvWNFahH3YwB1sqqg/gkSeV/disfDZxA4zjbBJiJzW6qeLkgBqcnQBm6hbW8B5qKHLBOTjrPcZuoO1TOsovsMCvcwCr1nssJma7xX11NOpVJZWS8T6JnzGEiNYcWnpqyjCFncVlCPzidWqHEPcJCvifnlkQvwW4nuM7fgVKygJ4sFq5jNcbJjk9+Azbq0Z5v1++OvQR8wiU3e931+WF2xmO56/6HXPhYxxTCQ//pLY0suTMrSVEzNT+hNefCYZs2AcHbGsgFhmcFBAa7H+hBZJmW8bk8utcuYHwN+5uI3iv/hHdtmQszmJNstvNVOgXEsaYfUD4P0HNzp+82Cm+SVqLNUEHkMn1JZJBPChqbpR3MUOC6/S6zhj8PzpSqnXauVfUB/HlIDQpgT8SYEO0c+fzeuEY+6eUbIOabHLyAS1UBl1M3sL1Y2q4v7CvCtaJIeckGu8AoN/zISMmebiCgZBtB0EiTA4oEP/f5boVQeu+BOxi7+FMCrZ
 Q/oWhV3M
 QktUAyNYLUr5JgYtCOsv4H914oCuhZ2Sux0qOVfjdynbgn/Ep/SZxIQH4eABHg1FMy0p2EJHLoXzjlS1penS+vEEyNYM4JzPQ+tqhADZoIG8832t315BrtkdCL9LZqOWbrFa+Eapnc+hi2VvlXuLwRqhRng3W9+8/tF5biy2lqOLGBNBA63/Ahk9/pCm6hNpnpWiGzdHuEw/MrwQfkbrLfUdkmtSGi89c2lQiRRTGMjMIfirKNyoW3IddGWPBxNk0wWnlpJixrrYB5M1dvAYZDEclB5tYzZLn2sT7pKUDB+d+9LwOyw6rUQphVYv9s1KPBhRRDjs4SjEWdhEhXMVhzjgA+dPKYVWHVn+8g/+0HQLiHm97kietxhVDdkYpzj4OWAxkwdVXWxUxErvpPSrMxAlQlvpfDQ4kab8C8FXYHgtFh6QRXRHb2oXigJWabNSHoeV2zhn1RDbOKDfFbM5Fo9JSkH0uXw6N1ZOzuyk+SZGCNB+sxm+Z1LyMmhM0xyK8SDvQl89d7zwnchPup6xCMuha0IFN2A2msQqBC+kAOavBiGJN7AGcBbyT1ZdJHi3BDCtuLT4cffOgCNGMnijgTuSxAudhg2wFukvkayJ+t24Ta1GXd7SAR/rqvkVFu6X2+FYJKoHK66FX11Ha/rluIxPu388oKJk8H7Bv+x6vvjwATnTlg6SMMQDHTb3kEJ/YI1VkjVYoP0C9yU5xKHp6UEmRWJHAByM1SjqolDot4EIAoI7d4RBlA89AVkDcwD5Wx04z3HmXuO9aOGBU4pgmHz58+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass through the unmap_desc to free_pgtables() because it almost has
everything necessary and is already on the stack.

Updates testing code as necessary.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/internal.h                    |  5 +----
 mm/memory.c                      | 21 ++++++++++-----------
 mm/mmap.c                        |  6 +++---
 mm/vma.c                         |  7 ++-----
 tools/testing/vma/vma_internal.h | 11 ++---------
 5 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1239944f2830a..f22329967e908 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -445,10 +445,7 @@ bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
-void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *start_vma, unsigned long floor,
-		   unsigned long ceiling, unsigned long tree_max,
-		   bool mm_wr_locked);
+void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
 
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
diff --git a/mm/memory.c b/mm/memory.c
index 8d4d976311037..98c5ffd28a109 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -387,15 +387,14 @@ void free_pgd_range(struct mmu_gather *tlb,
  * The tree_max differs from the ceiling when a dup_mmap() failed and the tree
  * has unrelated data to the mm_struct being torn down.
  */
-void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, unsigned long tree_max,
-		   bool mm_wr_locked)
+void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)
 {
 	struct unlink_vma_file_batch vb;
+	struct ma_state *mas = desc->mas;
+	struct vm_area_struct *vma = desc->first;
 
 	/* underflow can happen and is fine */
-	WARN_ON_ONCE(tree_max - 1 > ceiling - 1);
+	WARN_ON_ONCE(desc->tree_max - 1 > desc->last_pgaddr - 1);
 
 	tlb_free_vmas(tlb);
 
@@ -407,13 +406,13 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
 		 * be 0.  This will underflow and is okay.
 		 */
-		next = mas_find(mas, tree_max - 1);
+		next = mas_find(mas, desc->tree_max - 1);
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
 		 * pgtables
 		 */
-		if (mm_wr_locked)
+		if (desc->mm_wr_locked)
 			vma_start_write(vma);
 		unlink_anon_vmas(vma);
 
@@ -425,16 +424,16 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, tree_max - 1);
-			if (mm_wr_locked)
+			next = mas_find(mas, desc->tree_max - 1);
+			if (desc->mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
 			unlink_file_vma_batch_add(&vb, vma);
 		}
 		unlink_file_vma_batch_final(&vb);
 
-		free_pgd_range(tlb, addr, vma->vm_end,
-			floor, next ? next->vm_start : ceiling);
+		free_pgd_range(tlb, addr, vma->vm_end, desc->first_pgaddr,
+			       next ? next->vm_start : desc->last_pgaddr);
 		vma = next;
 	} while (vma);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 6011f62b0a294..9908481452780 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1311,10 +1311,10 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	mm_flags_set(MMF_OOM_SKIP, mm);
 	mmap_write_lock(mm);
+	unmap.mm_wr_locked = true;
 	mt_clear_in_rcu(&mm->mm_mt);
-	vma_iter_set(&vmi, vma->vm_end);
-	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
+	vma_iter_set(&vmi, unmap.tree_reset);
+	free_pgtables(&tlb, &unmap);
 	tlb_finish_mmu(&tlb);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index ad64cd9795ef3..ba155a539d160 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -476,16 +476,13 @@ void remove_vma(struct vm_area_struct *vma)
 void unmap_region(struct unmap_desc *desc)
 {
 	struct mm_struct *mm = desc->first->vm_mm;
-	struct ma_state *mas = desc->mas;
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, desc);
-	mas_set(mas, desc->tree_reset);
-	free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
-		      desc->last_pgaddr, desc->tree_max,
-		      desc->mm_wr_locked);
+	mas_set(desc->mas, desc->tree_reset);
+	free_pgtables(&tlb, desc);
 	tlb_finish_mmu(&tlb);
 }
 
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index d73ad4747d40a..435c5a24480bc 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -892,17 +892,10 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 	(void)unmap;
 }
 
-static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, unsigned long tree_max,
-		   bool mm_wr_locked)
+static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)
 {
 	(void)tlb;
-	(void)mas;
-	(void)vma;
-	(void)floor;
-	(void)ceiling;
-	(void)mm_wr_locked;
+	(void)desc;
 }
 
 static inline void mapping_unmap_writable(struct address_space *)
-- 
2.47.2


