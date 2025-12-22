Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D4AE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 11:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346426B0093; Mon, 22 Dec 2025 06:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EDB56B0095; Mon, 22 Dec 2025 06:09:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D296B0096; Mon, 22 Dec 2025 06:09:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 048386B0093
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:09:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B800D160AD0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:09:40 +0000 (UTC)
X-FDA: 84246836520.20.4F15820
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 417284000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:09:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rmldqctN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rMoAMZVw;
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766401777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylU8vG/Xihj44WDXsxfjDlYJGKf66p/JMT9HIB9fQs4=;
	b=hswsk/ZKvlos9EXItkPstE+Ih/7pVGSswlQJjeTKnOmGLWGemMioAavFQSC2KNDfAZbHK5
	YLAkMaW+++WkJpL3n9wQMXtsGslCGI8v9YX7lSV4NZXEIpKqE82UYlWnLiNT+va+ly3/6a
	cQA04i85ACRm5sclRflG3AFpIwooK2g=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rmldqctN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rMoAMZVw;
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766401777; a=rsa-sha256;
	cv=pass;
	b=ehgVAQcOiGuy4umgMmi+MSsia5XQKLXHX7pAWr2bKf7NqWUjY4ZUi8VvTN/idUDfNpdpec
	imQ4c7AMo9ehqYRo7A1R7VyNTQxdhMThLgzpBhhOLtbrRM5asTWyL5nwoPooEJ3H/MKsXK
	s6yafIAHH2bpxtkqKDBnHGv3YAzPTJ8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMAZWNP1909108;
	Mon, 22 Dec 2025 11:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ylU8vG/Xihj44WDXsxfjDlYJGKf66p/JMT9HIB9fQs4=; b=
	rmldqctNnHmJGOzPGB87J4MzgFTjgR/pcwEVgMmrx7WoUYcnk8wK7n4DWEqd4Q9p
	IyZjczCMqvzWb3nIia4vugsTSliyHJHyNCNjWln6XngEl5OVBaoJtEYgPsdhIhcx
	LdQ7PYRHIjIL6fhXM6fyDj/8fjElOaq6pi9mfIUxzwyfxtKZLP6Y/5lGRDSVS0xr
	msgz6gRVfXCZ+GD6nTzxhErN81KDoXbgHnJzpuEZYBkE/Fq2QCk0pJGZxCbHXDB4
	/j0PWmPEH5j868KkVCRw2wci3EFYU92eBPPAH39KEkxBKo254NDdr9u3ZtTNK7YE
	va62MzYUn9zmmi2Mr79C5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b74ccg16w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 11:09:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BM9Vw5i032709;
	Mon, 22 Dec 2025 11:09:21 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013059.outbound.protection.outlook.com [40.93.196.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j876hyd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 11:09:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4TfhGDlNSxy9mAY5YNSZMwdmKcQ5BdGk8OjyqHf4xgK+zdPATeD14xbC3Wwiqa8iDyRDaMyhPqMioYOZU4PUpDlIkyqnKOrSAbexBnwts53w+nbBT4ftC0JzT7OCtJ0ksRz0Vg39aSSKoTds5sHF3FnDvczg5B1Lp1KBjanLmcXbTLg0IIyHNtN0XtFZrmVPLqJAAQ9jgmNCr4A5Mu0eyKT1A2/lT9dL9cZ4/hHIy5KiFTwWnIiIiR8/AMcOFL6AlEkvx0QTe5rUHpR6yjm2GanI7kdiIRpiaHomMYgvGnHWCJixp3/761DBGrQxCrXPWHacbZnUYnCZi0h2TyPMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylU8vG/Xihj44WDXsxfjDlYJGKf66p/JMT9HIB9fQs4=;
 b=EiGgpLKKVUbAiZU3u5gyIFbpb+8a8VfJcFHsa/jB3hdU6rUsta56cgrHPJ0TTGkamdyFHalfuI8iqZ4/HzfKXqotBABIey9tfW1hFVF3ZG1asecEXuxFYR394LaLBqCHGspIJaO47Hi+nLDqWk+2bJUE09IixlsqH/6WEunVFCUGlqM/ac9ZsOALk4F8YZGKU/MeisCfjW+irPm1YSICUEYNM1J+OOaIm6gEI1vbIeUyhn1mxoxmz+oE04TmY+eBZ94OJCsRIuaf71KyWrgBNHphS9sIbzwCq33JlI2gJbeH3nzu94d9Vyj1JVV480rSn9pq1SE8E1HVHRR9hLGF1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylU8vG/Xihj44WDXsxfjDlYJGKf66p/JMT9HIB9fQs4=;
 b=rMoAMZVwxj3yAptIIH8uZp8Eh6o5IlMVSpPUpYnW4i1IBD/tJQI3HtkIEvJKwQVsRRa7tgkmgldQb9HEsZvR2LhS5HZ+0EYTTLRnw7cc6HD1HTXydg7siv/5FrLcXzGolfAoOjRvuzk+uXYhWYy/1DC5Pj0FOYWfqjIb89xnl7k=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4741.namprd10.prod.outlook.com (2603:10b6:510:3d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Mon, 22 Dec
 2025 11:09:15 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 11:09:14 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        hao.li@linux.dev
Subject: [PATCH V4 5/8] mm/slab: use stride to access slabobj_ext
Date: Mon, 22 Dec 2025 20:08:40 +0900
Message-ID: <20251222110843.980347-6-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251222110843.980347-1-harry.yoo@oracle.com>
References: <20251222110843.980347-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0134.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4741:EE_
X-MS-Office365-Filtering-Correlation-Id: 5794a51f-e06e-444b-ec97-08de414a8adf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gNVZPkY2sOS7omIBgWGhiwSLegYyrvw20w7nZWbWLwhDc0x4MYTbB6FTmfrr?=
 =?us-ascii?Q?RfvbVSfX3V+5O5U6RNmLGO/uA0AhiKShN6J1Y6daH85I6awmHoC5z1WgpMWF?=
 =?us-ascii?Q?iF912QetSv2Xy9LIDRP/IC78tYkDQKPrHdyOIhBwE88w9kkWzpUsleo/42QJ?=
 =?us-ascii?Q?9MWJaRTxPFVz/lIvw66zLwmv/wcf5l16Vn8HSOqFXTU9uZUog/5oVCgwfqUR?=
 =?us-ascii?Q?fblspzb4vbC9fIKHE30KncMrOEGD1rAm9VJ0e2u9bGv4cPtkZKz66DkauSRa?=
 =?us-ascii?Q?ntUXMqz99Ay5yeNRzV91mLDgyA5QMCjg4jWDEC9ctV4I1UWBIRlA2OyzvySh?=
 =?us-ascii?Q?+K73iAR/yV0rBh39Rf94uGO1qn7PEG1wTjd+o4HUnZ+NkhiKzpEY8r222ITb?=
 =?us-ascii?Q?uXXumKOhd/4m5fRbiXGZy2376HXJw7LOE3PZEDme/dQblEGMvbUh3ivkMpmD?=
 =?us-ascii?Q?r0P6+njAbLdpJKuLkLIBZ0l3GXRt5VB2jMfCYgt0Epg44R9yCjqm3I6eGeDA?=
 =?us-ascii?Q?JTfss0h0fCXk08pcj95AhFnBOPgz7ddmKRovXmG4RGbk742/DWcLKs1bC5nQ?=
 =?us-ascii?Q?A+QhadgA/KXVMzcWTuM6ZZwC5L6giNVMlsqdLdu8rt4BYdr0Yd2DHo6eS96D?=
 =?us-ascii?Q?am5k/abzn8avSnmxvqFBmeWeaRZneHM9A80QohPkh7Cm8D+BwJMKvyM6prp2?=
 =?us-ascii?Q?T1GOFISRGfCqaidKaPstEuYGhnD7uH9EEzSNBM+gQ11sYVjGMJO4AxrXWyZz?=
 =?us-ascii?Q?uLj6oVq9gATaAe2ibTYGCqmolyTpIk4t6gt2krmbGLa3d9g85gLUeVdFC/O9?=
 =?us-ascii?Q?ZbScF55R9WpWEu9BojuUcJw4ukdbRW7OkCXGMNlK1rHS2Wo7gwxZt6cDOjFH?=
 =?us-ascii?Q?S7mzVphhAU3FbRQbodppT5QplDdnffPMexHMk4HNnoJPO6Wawve+33ToXx4F?=
 =?us-ascii?Q?FecSyMD2v9XAhAsj2cXEE23LDhZMtlvU9T1b0GtJh2LQfe05HthPfnpaNR9I?=
 =?us-ascii?Q?Xh88Bv62mRiFaDXomgxRLBJMS6dxlyONA21r17TvIe0YqrVN03GT8/1feINy?=
 =?us-ascii?Q?JX5ONLDHs4JYfV3kzYQUWrW2LZIi4fS8QSv6u1B/R1KpOgmuac/NCCy83LUO?=
 =?us-ascii?Q?zKliHIPyM7z9CwNNkb9iZri9rybzl1CNjJq1VtFagxImDT3yZvABWAUpvGde?=
 =?us-ascii?Q?sZeuaKjJu6GjemzNUe+fu5Kpd8671QPfbqZrHt5s+EBcjrbAsM5rnfTm5Yc2?=
 =?us-ascii?Q?8s8yIRnca+Qh+7lUe0T1yRGxyxf7KjvMhx28JN8XBXVYmbUktu/S65IfYY8Q?=
 =?us-ascii?Q?7Sbtf0iulYeef8rw2Dz8PHlq5AZxs7OfSn1KmYkkARFnxgdYzfRLP2bWEDgM?=
 =?us-ascii?Q?kTE6nxCL2haAJzVzrgYE2h/PbA2gA9QKOD2t7jgU2fiEAk9ESHGKMbw8lQjW?=
 =?us-ascii?Q?fLt2fIShrvdkVVWZfX3KkHMZqAPSzaYf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?09HSLfa6RXSL3WpKanP3XAIPykj4t507IYi55tWqIC9BcL9updPZr9SwZVg4?=
 =?us-ascii?Q?GMrHYlPLzjAqWgf7JzSiUh3yu8g2FCENi+1QUpJ592ElG2Er7ts8skQ0usts?=
 =?us-ascii?Q?nqhsM/jGfBW8l22YgN9sNpTonp/46VvfHaOdVH2tvDF3DBl8EEmj9IF6Og8u?=
 =?us-ascii?Q?yhJmxGO6l+8/RRsc6QC/6yS2gXfSbSG/2LGGDV2K5eZeI9VN61a6NdEBvqCI?=
 =?us-ascii?Q?8MQCn5v+WVaPo63bGXJ2tK5boDAjzsfPD7o4Z4TXR9IpQkMYtzwmVxMU/KJ1?=
 =?us-ascii?Q?5zJcF9+SgSW2h4KH244BCKxf9rsxWtkUOzxy8jIqafB3kObQRlJT/m5R486J?=
 =?us-ascii?Q?bJg83tVSwUQzmbu1b5KLtSaddtSZ6TfjdNi9LGN3Wbw9Ft8s9icveP5BnmCE?=
 =?us-ascii?Q?+vfx0tN1leXECpD8/x8FMsxRBpyDA3kFvD+f7xibF6/1Rd8hAvwcYsJEfooy?=
 =?us-ascii?Q?AhLJtbEw4VYU/3k/OYxd1oQ/qgExRVCFIcI1orAmeSg71d5e1qewuBl3dldq?=
 =?us-ascii?Q?7kdgFpmjl7z3Pj7g9KfJwETi5NI2RxPdxZjR7lwCQ5r5UDVXNrOSvNhUe0DG?=
 =?us-ascii?Q?Mx0wb8c9Zopw9Vbu+8bsaWkkbVRV3IvF8+WTphIVK0Ix49RXVvS5MoFRVgkz?=
 =?us-ascii?Q?r06pCburUbs0ZR5Uwl9lZQEcDj/HKfTxFtbhRiBsuPrPQ6fngaDChdVxRJeR?=
 =?us-ascii?Q?uF8gNe3lBW7Wv1BXlzDpiNNpVJ3Zkod1KEkO9I13iG1EjbNQqfOEdBV6UibZ?=
 =?us-ascii?Q?SH3PHq8ZhOKC/+wuFLEjGl8ANVlaWEWbYJPGPJpSL4I3iERheDf1Bd7H0RUg?=
 =?us-ascii?Q?4fIBG+gRFgXx1bKC+q8bK4N2zZAsqLqrCK43mAb5VJCGYBMrm2rH4ihIqJe9?=
 =?us-ascii?Q?TYZIOvmPEklJkVAckHoxPlZeTEasb/XK2NmrAyEP20KiteJDZN2YfBUSm0/m?=
 =?us-ascii?Q?ETwi+TZEGR0bXflFNzUJWv6wYHXqbVm8AOxhEe3FkjsDV+siDa52WJZDbPEr?=
 =?us-ascii?Q?LkcjNJ0AVq0gDMf0CLgNrlcK446HS/nIyoxyFSjZ6/jENNC+k4A0xImAAtSt?=
 =?us-ascii?Q?C36j1jLrNIKvxmX00/FY3bXNhW7Hl4pI506790LOfD1D9glsgkIwVWZhKsI7?=
 =?us-ascii?Q?c2qpJqO6AH05FsMGmyKL7vUC5TjTRuySq3fq6slEIxQSG3bZdNUNoFlgdSLA?=
 =?us-ascii?Q?pio3+yujczAYXBTPWNA6TcWlkyNGM91d7e+K5mu3DYwiqWwJpuNJCjVmlhs8?=
 =?us-ascii?Q?nhq6pEEJnqLWCmOt91QrjCqkTh3RJx12nJhyaU5rrLXgL0Y64rft4iY3w5m5?=
 =?us-ascii?Q?tmqa2gBue8gAiqKGXLOxhhb4qTAymUVtiZs8K5ZiX0rdPw9j5qRn63RYyUN4?=
 =?us-ascii?Q?QVxtTFxbhPP6Q8OeZFjECgpgmU/m8H+8MG1CLG/JCE89zWWd3TN2v3/frS/O?=
 =?us-ascii?Q?0rD1h1DatcysF3yLQXWvMymnBHYd0dN7vlzK2ma9heZTS4Z1Kgnqb/W/TpYC?=
 =?us-ascii?Q?eDDn+/lDh2XnGVofBO24PwkF2jCEafrFfhVoDikeE2IQ7mF5Zf/yRCfLB9rg?=
 =?us-ascii?Q?UGD3sVCf+ZNcY3Odu/NMscUDw6gRuIRW4qqF8cCtrm5DZU2hq6X+/KQTklIq?=
 =?us-ascii?Q?88BBlRHhCNUtMHRKOR3pO9gNvAhLPmqLYH805+tkcGZAEG0O4EEaiabb2ebI?=
 =?us-ascii?Q?4IqfBTx1iMgrkNNeErHiEFwZUMox/BXj14mIuQ3GXGZRLYZIOhEZeQYqcxAg?=
 =?us-ascii?Q?4tl0Prsjhg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+EvX/BbuCZq1cTVv2gp9FbqwcjPoQN4G5aqE8z6yPq65fmKo08XEEq2Ek1AAx0iMyD1jr+fX+Um1SZOE3RyIUshWgW98acaHGcjlYdQX7nOUWeQQOL7BtIOX5wkpoTCTIRMO8JGUY2YUHICKZ2fQ7FiczUc2zyKryWWJKRnwqzhX4+HTKL2raJG6h83c5fnM8ajETPO4Lh6NK4LzMAYF6rX9E+1N/c9vJf9VmRJXxYDn9JHelFNosN4/9QgLQylY/iexPYZSWRRI58i2Th+J0pzx024FqErf210tnCzXvpFRjGZjz5BBbuz8KRgIuAp0iskD+u9RGx/iNAvuKiWXDbRhaNOiKit+PuXRCpKKyzABPc7QyoIVvCRmbsGEmSRNR+7mL9A0ren0w2QGQa/SzijilK9qqlPgPcicX4I4EfDmLEPE14lU/7ECizeS+n2cYACcJl/RdG4XyG4bPnjBUjV2PzC/1NkKXrcDa522lDueRxPVTX4VzY9cqYyiDqpVdShpJKL5Irsfdl3J1DwWxLky9zUUBnLtVBMgBtH4s+w1bkNlEhhjW8eCVbji+PUY9RqU9BSCNCIuMRznWQermliBMagA8S+aoX1gtArUOEs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5794a51f-e06e-444b-ec97-08de414a8adf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 11:09:14.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOeUZoq+YcFmN/GyXcahLEofQ1y9y5pVjZORb2u+CmH50R5I3o8jyXwQcTNqffuIKLGmf34gTX/ziibriryGrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4741
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-21_05,2025-12-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512220101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDEwMSBTYWx0ZWRfX7rWGFhpOQ0kN
 aM+cjgYmVvZAtfv7y7mOBrD+HhabU6lss6apFCJxa0r3P2pxi778smvvHjs4eHDPZSdBzFupkhz
 o9jfUx++Ir94vphGkhcT0jsUmyth/osixLG3DrMvK0wKH/STcABnPngbOmn4uf2brD02XJ1NxTR
 xaPXQ+BkrYkO8eyi/RMfLeqWFvPORCN2i+yKkiB76V/rzYbRxYynjdbvSxEQ2aC0rhbzROXclB5
 r+t0NY71VH36ZQEuBGQZCu4DdhRTQMW9bcCxWnrnzOONN+KQn0c/+agBdRSAQBeVxEgrmlBnvEH
 9kxXmSll7T8AhI3kLAsNK/Aztwd811dPERNHRh5Xj2SLPytofkNsw5yKmekHjDAVGr7zSOwurOm
 p+UYsx6ZOrhle4emdkqSDJmOIWluENwOqSR7WUoIEE1SQ11BUMVj6jZ8Rq/EmNvlhqhO2RUlEj6
 jMGS9Sb2khKFqLKv46g==
X-Authority-Analysis: v=2.4 cv=K8cv3iWI c=1 sm=1 tr=0 ts=694926e1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=UZPuyEf3i8-D8iXyNNYA:9
X-Proofpoint-GUID: dnB10f9jvJ4GVfRrVLzz4bo_nT0L2nee
X-Proofpoint-ORIG-GUID: dnB10f9jvJ4GVfRrVLzz4bo_nT0L2nee
X-Rspamd-Server: rspam02
X-Stat-Signature: 4qhdrf5uaogct9py1si1ui47w5fc8t4x
X-Rspam-User: 
X-Rspamd-Queue-Id: 417284000B
X-HE-Tag: 1766401777-821113
X-HE-Meta: U2FsdGVkX180uIC/8Os7f+AIzoCpaQokw7ysGH5ldC3LrFGKdG7vjADh1Bb0byogHwGQdsPVVX1bMU+/PRdwnRj7osCp6RRI+tTk/W4SbdhsZPrZxWaK92tynRlbWGpkkCB3x6OvSCxD1dOU5I3Mrz5ikw17KRzzL37m7IaK6sn9bV7Ox9epdDi7oU6f8aMY4vCAXuPNiUnn64Erhkhmnj2v25VIp8MD6jEVXt6GHCyswAQt0ThYUItVAWIJ9tAWWZ8gsgwOm+1ZXh2RdnmeqCf2EwezLfjJU4HMdfbhKsIp0qBRWs+LhIb4u3Ul1KIYZmnBpFY3Nfg9tUpreWZiaCP4VfoZAVQp/VNvDE3kwAtAA8BS7wq4MqnKX4Q6T9xEFIsyzU7vsfC1HPt9lRpGmH9HQ29cX0KMKaPhUCTwP8SC2Fwy+bSydWLjzOcgiHVVnPZjdGPLwK9JZtB2jbfrXfche3DihpMqZViBg8L5l6mNBkdSECCkzwNQqvgn/AgRj2v4H5bMr0uc9ttS7qY05d+Ad58az5uMg+OsL6Us+5du9rSMLw6eN8jeJIWJzst+mJNx49jvBChz5z7COzYk+vtdiWG3AcNQ2qp3jC+LegQDBSl/fVsrDIo/p/XvusiTAC8xUPrdFMwjLGjpZKWJ4K1V4fSr3RAUrwh5U0fMmcs62r9LgVanSP/w1+WL2pH3dyCoDKoJCGOo1eW7LdBwZJTAlN+52l1B+kyT3vXbAGl/wOUceptnH8RxTuInHTxiSnE3N5UeZe6esoiQHbyT0RZ9kU6DDc+b6fAbiKx/Meq8cGCNG7OdxLRKYzYxLBO9TXaH3rr5zZSN6LNe+RuYCISms4kk9WO4S5eCwo12vbEC5O+T0VVQOYMCUkZ7UrGSFoP86M41Y4FMPlYq40UqY684+APjXvkEE1LWRBTVudEfA3n+6IoKJQt4HO8J2IqpS6PBs5v3VBnq2h4nfSo
 AvTNQKlJ
 uQUU5VGQ2Mlpt4ezm9d7rD+5jiOKj9tRqlD1sSf27Odvwku/b7JC+f0up10EiRe5e0Ay9ODis2nEATynkvcpWL9qFPWtvy+POqYJqAi7AvrtNcpZVyQ0iV+GFM2aAbHvOTxoKe0W7ZKyGbGRmNOIHkVLMdCwq3Y6V141Mi0I85wjdxmani4ryMfTjdhATtrc6bCKJXKMpnBkxLg+ngMsvFCYdONCs+Au9YARMHE0ilEMy0POHhgZztJ3QLPfyV4R5/jHmim62pD398brc4s1HjmZObk/jy3gMWm58RpboPZ+MS0O49XeJeCS+LNUWsZZL0uRnWWfRTk5Qk5shYAWzyD+knhpxxzHHLw0fuBfRCTyI+WAi4GJNR6ahcv7ByPTFEfo2MUAtu6gv5Jtr0ZXcT+W7eFqTo7hyCfuCL3RroCasOxzGGEWbTL7Q8hEtVAb4juhJCMzY/+IjBv1463k+wB1/IYJy66FMPljleKAhJZukYmL2ivhAnfYLluEBiMDgnSbVRIthInEvMqzLVCSF92r//tdtAhS7pbR9MZu5MePgna2sICyNV4OYFSuJkoMtbXuWl0SlLzLKgnjXM+bkyDpRO5TZJpVZ2aJP7TeS6Bqh/TZTU+fNL6ZTS7VNo4vU/Y040TnR6r1393FlADCHEbZ8rJ4SmYb8xZ63ZyVIUWbnWxhY41BHVJD2HaKonmzlsvkMW0t7/a2yS48dnJL1GQOWIg5wRCztxcTVb+oPdXGcxIPrMglwQyGfzw/U5WjkMpze6KDMFfc3SdIlq/wTwilvqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use a configurable stride value when accessing slab object extension
metadata instead of assuming a fixed sizeof(struct slabobj_ext).

Store stride value in free bits of slab->counters field. This allows
for flexibility in cases where the extension is embedded within
slab objects.

Since these free bits exist only on 64-bit, any future optimizations
that need to change stride value cannot be enabled on 32-bit architectures.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slab.h | 37 +++++++++++++++++++++++++++++++++----
 mm/slub.c |  2 ++
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 5c75ef3d1823..38967ec663d1 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -55,6 +55,14 @@ struct freelist_counters {
 					 * that the slab was corrupted
 					 */
 					unsigned frozen:1;
+#ifdef CONFIG_64BIT
+					/*
+					 * Some optimizations use free bits in 'counters' field
+					 * to save memory. In case ->stride field is not available,
+					 * such optimizations are disabled.
+					 */
+					unsigned short stride;
+#endif
 				};
 			};
 		};
@@ -531,6 +539,26 @@ static inline unsigned long slab_obj_exts(struct slab *slab)
 	return obj_exts & ~OBJEXTS_FLAGS_MASK;
 }
 
+#ifdef CONFIG_64BIT
+static inline void slab_set_stride(struct slab *slab, unsigned short stride)
+{
+	slab->stride = stride;
+}
+static inline unsigned short slab_get_stride(struct slab *slab)
+{
+	return slab->stride;
+}
+#else
+static inline void slab_set_stride(struct slab *slab, unsigned short stride)
+{
+	VM_WARN_ON_ONCE(stride != sizeof(struct slabobj_ext));
+}
+static inline unsigned short slab_get_stride(struct slab *slab)
+{
+	return sizeof(struct slabobj_ext);
+}
+#endif
+
 /*
  * slab_obj_ext - get the pointer to the slab object extension metadata
  * associated with an object in a slab.
@@ -544,13 +572,10 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 					       unsigned long obj_exts,
 					       unsigned int index)
 {
-	struct slabobj_ext *obj_ext;
-
 	VM_WARN_ON_ONCE(!slab_obj_exts(slab));
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
-	obj_ext = (struct slabobj_ext *)obj_exts;
-	return &obj_ext[index];
+	return (struct slabobj_ext *)(obj_exts + slab_get_stride(slab) * index);
 }
 
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
@@ -569,6 +594,10 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 	return NULL;
 }
 
+static inline void slab_set_stride(struct slab *slab, unsigned int stride) { }
+static inline unsigned int slab_get_stride(struct slab *slab) { return 0; }
+
+
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
 static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
diff --git a/mm/slub.c b/mm/slub.c
index 84bd4f23dc4a..8ac60a17d988 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2147,6 +2147,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
+	slab_set_stride(slab, sizeof(struct slabobj_ext));
+
 	if (new_slab) {
 		/*
 		 * If the slab is brand new and nobody can yet access its
-- 
2.43.0


