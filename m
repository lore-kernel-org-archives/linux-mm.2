Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5752ECCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BA48E0013; Fri,  7 Nov 2025 11:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C4D8E0002; Fri,  7 Nov 2025 11:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986698E0013; Fri,  7 Nov 2025 11:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 85AD88E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:12:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FC494BAF3
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:12:21 +0000 (UTC)
X-FDA: 84084303282.03.C70B21A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C6A720019
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:12:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Uh0EijzK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tWNkMfMZ;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762531938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1o/+7dJ4EIUBDVXt5tFpvjPugX92XkNMYc0uV1GsFo=;
	b=4MAQzY0vh9XrSE8ZFtizFCVXNB7qPbNc7if7xvQNbnOzKvWlq1isrkEgRlHOvscwO5z705
	mqVCjBgOI8jT+otSverdxmEkMLTlmOtRDPmxBfuDk/uIvdffP7vg+S3On89DybRdWIfxel
	WyQxLQXKAWocu5TihX1l6qJxkPtKcTo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Uh0EijzK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tWNkMfMZ;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762531938; a=rsa-sha256;
	cv=pass;
	b=ez76OmLFMEY3V2W2JyJa62DifNk/Mg1mC+wcaBfD6RWPXWP7gn1dy+eT7DU5D8DKXZOE79
	t2zj8GaWCqZiXpcW4KS7VpgLMootYpw717XcQr4TMsS+1PXDl1b8p6yob1iy3VPlT9gAUA
	SixxQmZTaapmEtuQz/sviImtLUCLoYI=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7FvZg1009211;
	Fri, 7 Nov 2025 16:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=I1o/+7dJ4EIUBDVXt5tFpvjPugX92XkNMYc0uV1GsFo=; b=
	Uh0EijzKDD4cPLLJqiw4PL+nIlxSDWajdn3XUUugs+JbYVT7sQ7NGvRF7SKnq47h
	FHLNeUCfr78ttqXXp0EeqfessDvFjkOBh4U9uuXCA2LeQw00Eyn8yKcxUv9L8Yx7
	KPaVg8WNfzW4+OuKuVExCt/SUDoKJWqr8lcbydqKN4U1Rxo5kWpqczdrVbm+VUSF
	+BY+f3xwI6ZNHSXO1MT1eN+Hot91zPE/y5X+4qhoz/TWfG5qCWAkSaEwF46vNSMF
	giFqVZBzOVZYJxSkA+o8rXo/EbPjtvksB62gYoDs7osQzAfs1vTQv9vBgnIzlnqu
	V1nMzDAjme4A56FcdHGv5A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9j7788en-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:12:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7Ee2HK039707;
	Fri, 7 Nov 2025 16:12:07 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012017.outbound.protection.outlook.com [52.101.48.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ndpvwt-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 16:12:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KReh3l4PjraH0LgRgbgOEs213bTRAgeGF60qMopmUlMmkZGOF/YC60KAjwWpE+CzIJ+MFic8O/L6bZzyFzYUkBCyEZslWz7jfEx3tTKNCXfXdLtRkSfH8ApxKm54T4ZndH+V6N+38iNmM1e+h5nfPglCE9CSuxc3OemJNh4i6GvJFyUZn9y40aPJR/ZTlAakfO4YYHgaeG+Dcu0z5AEWSOvvYSQ40SD7KDbr9s47E5c/RXxJBgzPXIkNI5KnumUKILakApfx61xNo71+XJ25qpmqiZ0j7l44C2vR7QXGLRT8a22eTiydyX4gqaZJpkPDuv4s4YWZw3yi0RtCJzTiww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1o/+7dJ4EIUBDVXt5tFpvjPugX92XkNMYc0uV1GsFo=;
 b=UtV7Csr2F7kfA7nGLMEnXFhwTJA+IFz72N2KkAqcLKtJKAjvxl7Z6+LiG2j9twaEVg1iEom5HTSRdnt/fFOMi0BmGotUmwlbExcfJLC8l9LqgIj1+P9Z8KGo8hjfXDwVi2BRtIIFhDbfwkf8Avjx1fDqBsmWvp0OvrkkobyxK0TcPXXe8yrJqR4dwWIeu5Z+yreg4E4BOnMvDPOylSfSEM66ZroiD2u7Rl234af74FX0cD1sIXxIvVj8fgD1CRd8xXZ6BVp4MBxJP6JONkZVqkhhKwwyJqiZFNIH0Z1/pwaOKHevAkWvWD9WSU6t0A4gmEZH7JBmgpxwpP+k2Gb2vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1o/+7dJ4EIUBDVXt5tFpvjPugX92XkNMYc0uV1GsFo=;
 b=tWNkMfMZ4NLB/CoeNfvuua7uc2Sx6p6OEgSD4Nn+Ky8eu0l0ruOj/lSmpxcN7JLszVUnjUfHeYrXQ5cO9fNRe9T3kxWQ1duqjTnvQp5cX3YEUhNQ5LbuYS3TiIw0SHJKuKfAj3ibHOg9+FoxEO98TsB+tSmj1awnkNdFV8e5WPQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPFADA73EAD2.namprd10.prod.outlook.com (2603:10b6:f:fc00::c42) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 7 Nov
 2025 16:12:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 16:12:02 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v3 2/8] mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
Date: Fri,  7 Nov 2025 16:11:47 +0000
Message-ID: <cda9d4c073d773ef6c2cf2939d66cf80544cff40.1762531708.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0463.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPFADA73EAD2:EE_
X-MS-Office365-Filtering-Correlation-Id: cad12624-3a89-4d88-7b55-08de1e18633d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2ePCFMLlGUqHAjHdipDeWkqitcJ9uLKx61hXsdAOnM2sWutZwDlkQeWRjJeg?=
 =?us-ascii?Q?7JCyFj8kF5+Xj5LejiuisL7+vs0CeutzoXEx7VSZXIToit4f18uHeCIUGJHy?=
 =?us-ascii?Q?Zxu0LKl9fHsPUVKcdD/cE9WHR71qnjt3neWVohK3sXmYJb2FDwjjSP71lWPa?=
 =?us-ascii?Q?u2lDyXxljgMuMOBuN99a7BbZvIbYhb1sMLoNjh2gfLwiOV5QcEXYzyObRioc?=
 =?us-ascii?Q?oUc/RTAEaZRH1WptnUGfWMoFr5Fa/9cRd+0ms5K6VczfRapE3a74Ev/AP5JX?=
 =?us-ascii?Q?+LpBjN7gF4++HqbkjxNUfBn9L9Yh65ed4bqc+74/+F/+ks6IBpIPekaAjCUo?=
 =?us-ascii?Q?l9pWi2+M5C7HIUgltpZ2rSVDaKl7Uf5KXx01XNw0h1s6RG9eg7MaZL8BPrLu?=
 =?us-ascii?Q?QO9mXvJ1pgD12BWbukKIiKTxvVhFp3u7nyuwCp+lFHgfqCgzbG+xetdQMUSo?=
 =?us-ascii?Q?I/VHq3NdcIr9e+J19HNbIYHfWqoNa7R/yETyL1X74dFB8onXxnPi3PccTdCW?=
 =?us-ascii?Q?FKse4W+P0p5txhJD6aY1SZzx/tD8kD0v60ZYlydTOEXK46fcGOEfhTqzlwHm?=
 =?us-ascii?Q?0SqNJTlAR5mAqqTp5dlKt7XIx8vJoqRFfXOwNUp6UhVb0oq6EtWRpgp0wK5F?=
 =?us-ascii?Q?MDwIDvfH9+1smgbRPBktgW/N0AvEkKl5aOgDCmMqZjWc5f9ti/hys8z3yn3B?=
 =?us-ascii?Q?wWRUDwLm0/kTfGQfEfS7ZsFwXcFoLxZzXz+uqH8U79JREegdrQ591DbrDJnD?=
 =?us-ascii?Q?7Pp6wCB9l2X5h9M9yE+K9GaKuT6m9Z/7/s2b21QNo1go2nfQQq+Ynf2/YYvM?=
 =?us-ascii?Q?MBeE/lbAxc5bn+e4PtFAWZeXu4bNM/YGIONY67BLIk1GI61H8+RpsM5H/EGs?=
 =?us-ascii?Q?NNs7QRaFpTR/pfWu7EzxDME1LrX7UKF6xd/heWewmLJnRZ57oLN5WBBis6zn?=
 =?us-ascii?Q?dgZZw3PXaXeTEwntDgE1l8Kpm36/WR+uGME0lgFNYYJqlt2ywazID3zyF7SV?=
 =?us-ascii?Q?iMfJs3CYA9vCci5ef28daNVu+8V/Mnxl5IkCWFq71Vq1eOU+jsW6cZgHzbUR?=
 =?us-ascii?Q?RXVGu1fOd5PUQE5fFCuiRb1m5Jbb8jERb3tjL2GhJVYKGUX5Ptzs6KVmFVK5?=
 =?us-ascii?Q?wgRJ1ODRXDB2d3GCXQ79GTIuEKAOBiVWRfba5an/7xubHyF0Z7pnn11uUOzQ?=
 =?us-ascii?Q?bW1i9rQ3CK2tpXM+C0npkmgqzONucRWXalbK7Jq0idpJqX/8PbEBcwx72VnY?=
 =?us-ascii?Q?Sh9eYj87YzWlGAgC/cpg1q3cAr8XrR3baVW1CvIQ2EKWvJ7vlPsFYIJuTNpl?=
 =?us-ascii?Q?jfWIxQok1xBRifbGwvjr4GRornWZx5eyLG6XP7l08MEU9p8RcoT/4DrLOdo7?=
 =?us-ascii?Q?AhJAgjekl5GGDRexsik+CpXWLGBeiJq1ytOmGwQ/eGgQBKrHPdCVtnSOd+Yx?=
 =?us-ascii?Q?uXMiY6C9akDEiXsPG/oob8QX1eeBXRUG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RGlvI2cvUUbHzedcq9nZJy9l1qBAETnq6RuPyJzhbBugGcBUI3S0F0Swp4aU?=
 =?us-ascii?Q?OG7gtnTNbI6DZEM6iqa7/Ihx3HjstwSoVu/rtlleZh2jWt4G9nRdpnXJq+0N?=
 =?us-ascii?Q?apXogS9qUFQYrWLmF3zLjgXAxZR0kSMDX50/qUe3luK0IU9J1YZ0/A9Taa1w?=
 =?us-ascii?Q?XEl6IWehHyN5jKAfQu9Dc/eqriJ2FlmnKNkaC3HVp+gEzEBuDzVF2zyzsrVw?=
 =?us-ascii?Q?W3zl2yeOACjbX/+0STSk58CYdONMuvijsz/OsSMoelbLZVtas2tBEATi3V0w?=
 =?us-ascii?Q?hTVb2645eddqtFnEqXb6P6+RXL3dolCiVtTQTuaPXC0IP0Resar7OEYuOsj/?=
 =?us-ascii?Q?JWIMGesifRpPkwu6Lp3on8CgupqbAwLbImSA7ArwDsb8MF1gQ19AKK6nC6WW?=
 =?us-ascii?Q?Yj2rguil4yeLwDD9BjJzhnOqrOso3CyukT/Q1CAcC1usMmh8C+7zniUQOvh3?=
 =?us-ascii?Q?kxxUqx956dl1fZMtxqQb76gFaEAr5kCsxSNKBwWX/6vqP3YGzkgvYnKbn8l0?=
 =?us-ascii?Q?J0c/hGGOSZJTFlRNHCKYL8xIUhqGo2synEoqsNYfCqVYLI3nU/gYTjc43S62?=
 =?us-ascii?Q?3/RXussCwIfGKQflho73xdpUri/zWb/z54JemjrbOu4XdYBCi38PW1TUK6ke?=
 =?us-ascii?Q?InFypqClWrfA9K9mNhHqmVNDmGZC7fwzPTWykozIJFMY6GmzRqUAncYt0GR3?=
 =?us-ascii?Q?FUFU02CreFuQKpjBSI8FoupRxkM97sPh8SZG4FmHvB6bM7kYwS1OpEQUAv1N?=
 =?us-ascii?Q?Ktfn9g0o/+LyYfdZEkA6Ucv0TJTr5TyDbDfZ97JBoXAORPBa2QdS4vMvGp0U?=
 =?us-ascii?Q?Id8fh1fs5IqaKcWNzV5aQ4y6/zWOnf8vqv2wfrfqiRnMXrfXBfNIyYk5An5V?=
 =?us-ascii?Q?FZkIh1YllZjfbSVyU1W2H0mjwiqQj8PkUNc0f11PLrrUW2BTg1HCDggrQyTH?=
 =?us-ascii?Q?ZRRC/b5Kt+sRdn0ONB+OogPWSS7RLGzz/2IEdWMZIVtcbO7mE6asVhaiyz1X?=
 =?us-ascii?Q?ikRMW6Hx9hhGJf7A0HQdXeYvwOO9+V729vJRyQRKsa6ZJF3d/nGgFNMtQBiX?=
 =?us-ascii?Q?f5tXunuxV7DKbmU859Q6oIaaLNuPWoHK6f7lKvK5Rfy7DRmi1QoipLao141t?=
 =?us-ascii?Q?d48CRnnahsNRmzx/bAPCtj7I29YB344Z6bszIrEO7qxx38W+efM7ShvMO+JH?=
 =?us-ascii?Q?kP1DmS2te5yfHt5R1w6LI2NyazKfWd6voDuESF5l1rXdEkohoj0+BglRvba+?=
 =?us-ascii?Q?0nKMT7B43BfS2K/XaXsZtiEIgJpAvq5ZwsA+X0XgxR4GVriCywyAnKMRs2R4?=
 =?us-ascii?Q?MPNnjlKm01C8oiBzsfQ3pQ5t3ZsAH8KhAWWejlGDHIiR1CW6L/xbLp8IrmHu?=
 =?us-ascii?Q?x3OyhMaolBMP5zezZOzoPI4QUsAaIwsz+Y/FCqbQlhYy4s5tHL4kToFfBa53?=
 =?us-ascii?Q?1GBi9BLb2Kw4mMVD+I0xm+gS9KvZ/pNUrkVEM1Eox8Epfj87mGvsHteUmCZN?=
 =?us-ascii?Q?ZVdy40ARnGpyQk3z+bhMx8xF6yqDbqAnoFcMwNwARRcyT0DfShsx0HUELQrj?=
 =?us-ascii?Q?S+dYl2JssDE4DCWnTITwQV+u27t59Edj82WoZV7VvjdyQBonNRXB/KWK7FYt?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qZFpCJHG7DkhS9KvvD3ZQ4o5CDMtu2xOpKLH/vaIgg7hNbD39YaUBYoBXHoOaI8XwONB6wnCJv49Wqh+nSPceC//V7bZIcSVmyU6HQijS31KT4ILa6GiSMUJ2+85jVVmetuPK+5ykx7rhq+BGAzSeojR902GBQfhP1m6MQ+7sZDnmIgznGJbBkJc3UM1z3hMG/bDil0kE7UfNQEQLkyarQhyVrvGqLYU925F8k6rzx4ZnSDt9/wp1DZ49awJ5oRbV6AoZh4zMcsCdWFbXh3nrgsKqTd5JZYmDfrpg5so4IBc1iiLKKVZjtelUACjWO0nZ+tlIXnBUR34G6gL0sTQt2MPdfzzrJIOz+c7f1uFyPsqoieaRn1fCnGRWuageODvFPS60LWav2H1Ff/S3/EWITr7FFwXPFYdI6BlR/EFv78RvoVSTno3BI51bnE/Wh62Xa1De6pR/Hy8ERU3VQU6bfBwRNa9HZHf8a9dbumUZJUx6V6PuC6ClVgOfhWhqGAl9TVPFZdmKIibB84SLctYV6e+temkCDQ8bC+9srz6f/DS7cNxnRGpPQsVQKBiZS938c8YSmCBMSqQJsCXuRL9pIPdYVdEKsH/B29IfhG0UXY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad12624-3a89-4d88-7b55-08de1e18633d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:12:02.6799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jsSC/OCpQRrs6JvQlRjaJPlMoCap64JzfLYli8xYDSulToGkdxGUEJf0gMfStJjRVBhdUGKXQlBjRb/qf9hHUUM3BD9gPu7Gq3e+wvQnIIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFADA73EAD2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070133
X-Authority-Analysis: v=2.4 cv=ENcLElZC c=1 sm=1 tr=0 ts=690e1a58 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=s1wohkeVibn2gu6f3vgA:9 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22
 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-GUID: 5A0fiR8cNHFeco0Qlxc73jnX5ovci1kG
X-Proofpoint-ORIG-GUID: 5A0fiR8cNHFeco0Qlxc73jnX5ovci1kG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDExNSBTYWx0ZWRfX6+RGQdzSAksl
 Iw3EkIVYToW2LhadL357MlmXl9qv7/wKkt9v9CZpXcx88ydjT1P71gFZT0X3US5No0WrPeVVBMa
 AgtzIWSmk2yN5oKdDRZtb9ADF0T0MdLbLAOyL6geC5a3FX4aoxJHOieQ0gZzvgYBmrlIUW+Khk6
 xyejL8xv/i8Na7Qgchpvh2xoIwtEuIJqQFKerAEGKZPFeP6QZKk1SPzhs7ZoqV71e42qwe1SRs+
 st7i5v9DlCyePTO98QSrRQUAWEGa6nhL/7qDWY0sJo9j1MM/KbHUjf+MQNO0nSWNGBM4wFgRAnd
 3EbV31ZJIbOF276c4NJs847K0mtwRZnpv9SPykIUr/JTdPAcw9aa0N2MeQidUc2EKJcfXiSvSsA
 Xz72OyCVcLrMqnZGGT1j1Zv/t4BFSw==
X-Rspamd-Queue-Id: 2C6A720019
X-Stat-Signature: zot5tn38559dgaqaesep3dpstwo7nfzn
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762531938-138757
X-HE-Meta: U2FsdGVkX19/cZobCXWSztDm7xXz0gE95yAfWUT8Nv4meFxkim58j6uDEjUmREKhbQl7yhuSxjbXr7Pg0eL3GIv/U1WxSHMtqbtCif3w22uetnIkerlwVEZVIrBnSBsv1uhVi1TiX/H+Kyk0X/GolJSqpnrXPFSboFZ85Ykav7ydAQSfIrKwEoEGHpsi5R1IppNsSq1Gtwydm4YPxJYzOWjH/jpz7W5YWwk189pGz/O8t2Y7PJ8nKZYhR3CdOeJOU5//uHq6EldcdyVDhC5OsMNqYvV0Cj3xxbBl0dUEJdnwSX6d+P4tTdvNpWQMcAmOZGoKROiGcCx5c5h0Jy/QCDuhHPPfzJlzbJ/pFDSArelYLNo8hmkZi9fF4wuYPBXnvqo5MpXvqq7Z64fu5XJO2+t0aZ2P3PxaNr+DAQQWpoeCHkZvIEPPTYg2lCL1m7FtGM+SbJpZsSANhfVOlj4+B0BZtgjfmItdLVmGWMiNJ70cCMHYyQ5mlLBCYzASTMvYZsyvSovfHdC52SuTtmdxyLcT4IBzqhY0ityjGq0bHqw5sIbe8CrX+8g2wjhSV8lAYcdhFGSzqfzh4GptoxAjSOSGzp4r7kkPv+KxZ4JVES9REaFaXmwroZ+dxZ2ypwKf/M8shKmMnuYG1he6XuIRBKWtCkI5hlzmIIF1ff+qXBBOcGuBHds0Hd6mt0oovo7pmvWCRzNb4Z0QtPYCTKmbfvnKXFKcMH1ZB+XcGMo2KwwyBEJD41WlDXAvLTa0dyGkOycLnFxq2PqPZEMMgMqmqWig+y/hOVS40q1W2epDyaRTMbtWAzaP6bhNZXsFXSBVlSPzHTEQTvgdbN1zJ9KTvW7sgBkHycNzCflr32yUxfkiNwd9K3kGoSS3q32S2/ozvhgzzDaxvh65q7rCYvL/PsT8tLeXuUgYQWKk+FE3LGUVwQoUo0OSLAed4yhN+KodIgcqN4dWaLkBFnq1vgO
 aomysIGT
 vpz/BHgrwTURizR9LvzbRk0YARIWNF0QiO0WdgbMbV+gSgRVYgunaxSYcKm3D+5xtpuvsQ8QET+7+LrCs3hZHvepez2AgzcjW9KgofryoGa0J4awl+v+4cHb0PVLNTz+ovh+XcpeBPwtaYaxhY+XQSoR0V53VNLDclj4FY1NGTqnlWfI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds the ability to atomically set VMA flags with only the mmap
read/VMA read lock held.

As this could be hugely problematic for VMA flags in general given that all
other accesses are non-atomic and serialised by the mmap/VMA locks, we
implement this with a strict allow-list - that is, only designated flags
are allowed to do this.

We make VM_MAYBE_GUARD one of these flags.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2a5516bff75a..699566c21ff7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -518,6 +518,9 @@ extern unsigned int kobjsize(const void *objp);
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* These flags can be updated atomically via VMA/mmap read lock. */
+#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
+
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
 # define VM_ARCH_CLEAR	VM_NONE
@@ -860,6 +863,45 @@ static inline void vm_flags_mod(struct vm_area_struct *vma,
 	__vm_flags_mod(vma, set, clear);
 }
 
+static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
+				       int bit)
+{
+	const vm_flags_t mask = BIT(bit);
+
+	/* Only specific flags are permitted */
+	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
+		return false;
+
+	return true;
+}
+
+/*
+ * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
+ * valid flags are allowed to do this.
+ */
+static inline void vma_flag_set_atomic(struct vm_area_struct *vma, int bit)
+{
+	/* mmap read lock/VMA read lock must be held. */
+	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
+		vma_assert_locked(vma);
+
+	if (__vma_flag_atomic_valid(vma, bit))
+		set_bit(bit, &vma->__vm_flags);
+}
+
+/*
+ * Test for VMA flag atomically. Requires no locks. Only specific valid flags
+ * are allowed to do this.
+ *
+ * This is necessarily racey, so callers must ensure that serialisation is
+ * achieved through some other means, or that races are permissible.
+ */
+static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
+{
+	if (__vma_flag_atomic_valid(vma, bit))
+		return test_bit(bit, &vma->__vm_flags);
+}
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
-- 
2.51.0


