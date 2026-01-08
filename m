Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0230D14880
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 00:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4036B0092; Wed,  7 Jan 2026 19:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCBD26B0093; Wed,  7 Jan 2026 19:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4086B0095; Wed,  7 Jan 2026 19:44:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A70316B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:44:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 461A01AB554
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:44:26 +0000 (UTC)
X-FDA: 84306950532.25.69F9D86
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBE741C0006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:44:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IftIMPD2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aVHjO7Fp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767833063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEwz/e/Zm2snSw+o665zhiXW30pcY7Exz+PvbJiYlqs=;
	b=s1kIdT0MEm0mmYMXFlJf/OvfudJab26/xi9khCVpRKMRz+l7CMtK0oASW5n7OPQYXz9qUV
	LaWvkKh1ebKlCUKqBmh2l5f+syG1jAzjhD248RA5kvdzxKtKMwgwiRUDlaQFQNDI7qA46k
	KHFDtPd9MiSypZZRJstU9HZr0MmdqmE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IftIMPD2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aVHjO7Fp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767833063; a=rsa-sha256;
	cv=pass;
	b=TvQSijtwt5DgFl1vC8Ci/QIjvcWrRovb6JoDdKvtfi0OkpLkT4id2P0ujU47/mc3tXsbZj
	L/XBJsuVvQgAogVz20LDGQkVBKjYxf+pFWfuvLl9B+aiVBgFxEHLbTEFKJLr1yilx8prpT
	8I6TUcvpZnx2uOakyhHZn29mW90NtsU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607NPfpE3583182;
	Thu, 8 Jan 2026 00:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HEwz/e/Zm2snSw+o665zhiXW30pcY7Exz+PvbJiYlqs=; b=
	IftIMPD2jRE+po2jKGRe4Ss+MHzlJECzeBcjikbkTunyKlVJWEGVmpFTcU4jK3JI
	mXvvhXO7X7UhLJdrJ0BJCwX5k60D0E3HB+9Z7Uskfi3s9mcvlUDc/49yhrsHnnD0
	CAmEF+2kpHiq6RTTE7IrrFpbM54BoCAqkBPWtRtlTgzhIwy4Ah5+HgcDy2AnrXMY
	3fxFpVY5ncVoCM2FRzh5NUS6eczWc9nsGYRVI8mbpzjNNbryM6RbUcT1E/PNHXwV
	rTKp0Cn98GicS6v3qZtA0yLHstmoVzetXK5kmAnkOySlaNljYSxy9zg9kgZ6sH++
	UpYn+BQ+ptDx/O/Sf6FyqQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj158g2cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 00:43:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607NOGJi028519;
	Thu, 8 Jan 2026 00:43:50 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010061.outbound.protection.outlook.com [52.101.56.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjeh1ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 00:43:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7A5BdobEBwUZtv5YXp6314fRYTMxw+nBP4FaeN39IBsRZiVt5Pj3e+tEkU5eS4DyIQbmp3/5OHVWXC7Xiq3vnpvKVpRIHU4cH5Kp7WDkYPp4qlWhb+TeSLv4Pql2puN1qqKCiNlTp3uBCzefCurDoCumk7P3h/yGffDUyzn3OiUm31Y0mB6kZZivHy7rl+4hTJDdGSElZQxLXymrueVvCnfM9HPLN8W898vNFUnct/XbQsbC7Euq4LAeW5SGaIowVwE/HVX+04BY7OZWB0jFfBbMlfSDv2rJpySz4f95VHN59hRNV/pKGB0b25TdGJZA3anvqX0++++gPS6xv653Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEwz/e/Zm2snSw+o665zhiXW30pcY7Exz+PvbJiYlqs=;
 b=caWzI5+SZ0QnAzHlStERwQfpcSRnHUIgwAViGOzoARyXYQWbG16APJ5lxTKEWvkB0w8WmPYbnHLcIHIO1zYsYfT6b45LxtirAAqGra3r3HWthYrEuAQJTajoYijmm3DHNv8EXdzDKef8BM9P7iRlQOKMCqINUScexMjIN3nmZwBifgbpJlaT1lbaVCNIGtRGTe2VmAgZ3r9i4xdMeLI06j2OokqgntVbZXWMU56e7hbqtajB7b72ok7ix7mQ2mzcntESV7+UY9h3YZdpx0pY8ro9siOcHG1/pDwnE7p8fjaFgFuNQivI804sLkbiDX8kXvGP3I5sZWybrM/AapRjEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEwz/e/Zm2snSw+o665zhiXW30pcY7Exz+PvbJiYlqs=;
 b=aVHjO7FpLkhWh2sv+m1MAOcCw8TWY+66o11BUEhx9MngnScmr4Dh856caPAiJsnlVMapy00fo1+rUEgJnKm48yDG3OuOZO0bZCTNT4AWaEsFAquWxQDpDFwzA8CjfyXoyoF2nSzz5IIGTyS5cJVDSeVrk5ZL/be39TDOiUxv7Oc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB7448.namprd10.prod.outlook.com (2603:10b6:208:44d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 00:43:48 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Thu, 8 Jan 2026
 00:43:48 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH] mm: folio_zero_user: (fixup) cache neighbouring pages
Date: Wed,  7 Jan 2026 16:43:46 -0800
Message-Id: <20260108004346.1652207-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-8-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-8-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0115.namprd04.prod.outlook.com
 (2603:10b6:303:83::30) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: c413441d-a1be-40fc-387d-08de4e4efc6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X1SkJE4acGqLj83X6KqOk40HO3wI6W+g5hW5217mWT5X3GRMlJw5GQ4KtdM8?=
 =?us-ascii?Q?qB5XrJAWXpiVl9bzB/MYCaONpU5azGuFRg/gpUV64ThYpfNTuWg4yjEU6REe?=
 =?us-ascii?Q?BSjNQPuqGmhjTV0AkGJEIRb3JvJ0fk8KL7ImM1wW7w8oMYVgjRztAH4UnfGh?=
 =?us-ascii?Q?plzo9+/0nb+KrpfCL7ZVz65obXF3mkDBERyqPiLza9Zs1STL7OZ/6XIQR7J1?=
 =?us-ascii?Q?qiPFlHOoKiWpBStGAVTaAcLbX/ZOnwRLTCHkVxaXlnecliQt7HAoCs6s00Pz?=
 =?us-ascii?Q?LDKxO9uc+akaa1DG4pwpC5jUVTp+pxb5ZVVkZmzRiChoGJVU+zNKbJ1IRb1z?=
 =?us-ascii?Q?x+kG4pBPavUtAdj9epCGjJJAAvq1lwWYTNHNmeT4q4G8iuTUhDsxdvzBTDud?=
 =?us-ascii?Q?qBaIElZn1HcvEaQyJk0V48dfpQpOuBZWIBe81W+tMTGwxbhHmgqgZ59wowyZ?=
 =?us-ascii?Q?cdyNzsXYH1gGyT9EkJwJsl/Y8qMiULw2QKA4VhzkAY8TDp0KwsZjgdUp9W3E?=
 =?us-ascii?Q?y52pF0VmdMNgM3G1yumcY93P0YYYQD9QNHy7bgir/+yEZT3QqlAiffG5l+a4?=
 =?us-ascii?Q?wZN3LXEHbreB2y7UfOB9pxH5xyZYjEHblZZ0k9ZOfudW9uHcEZqQe3ZEdEkP?=
 =?us-ascii?Q?Ta1U2rC8qkzDzGzRmIV3W/0npKbvsfuyJu5ZcGpeZl9o6uwEVl5iNKsvTfNa?=
 =?us-ascii?Q?Lrs7zrV/Xex2tv7wKaAqolqjdQsbVwBnWDAE7AwqPCQQbl79GP7h2NA62eL0?=
 =?us-ascii?Q?rGk7LZiKICsankRwicbMPRGJFAKHRCk1jBaHKbx9QHAB84+fkWAN3XFbhXxV?=
 =?us-ascii?Q?PM+ERx/DbgYlnjPBvk46QYH7ObHK1gZ9sRPXZ8uz0JGRijcpkHL6BqQ4XYwz?=
 =?us-ascii?Q?4oCHVLY5aSLp76Y3zUifD7EZJyPzeL8loh3aOdadRMs6ROH1G4lLd+hpKSa+?=
 =?us-ascii?Q?yP0QoUR+OGtuxJo4HrWXHh/8lGfK8Aysgnjsvk3Rrod4f2RVWaswHef4eki9?=
 =?us-ascii?Q?DQmFjFkVAMqudZ8OYAyOuR0g/g4ndqjkhiyiMc7+Fonc7oZh30EDGoVVghJQ?=
 =?us-ascii?Q?yyvd1fntzHlxcEQ2B+mSh6oLGmaGPPGE0oBV7CVbP2LCOpWBbM0oo8OtjDwi?=
 =?us-ascii?Q?Vmy4OwG+wYyjl7ojCwr27K0tkrW1fZ9o+8SWbjnxgpcMT3Eb+DcuJbmXK9AO?=
 =?us-ascii?Q?DgFLynBX2z6ICxFxD7fdvT+qzGmQgSU/QKwTYIXvKEHcKHQD98RopJFssWoL?=
 =?us-ascii?Q?FFaTyO4amobEo6LFKzyewT5PEDR55PSEOYP9ERhX5quqgjTJhTzFjwRH/51T?=
 =?us-ascii?Q?V6KHXrEHzVTK631vxyRQvoCOs8FGxMcZulICxN60LsIUWSqJaCI4QIF+Cu+V?=
 =?us-ascii?Q?jXD5fdnIHrV348F1N4DUm1+uEFdiKQhkS2vmmUCYi/Kq0cZHwN0VwkvUkaZY?=
 =?us-ascii?Q?DCqV/lz98xr9M+qSsNJ4d8l6BmVa3ODP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YOm+xTtUrCnssYwCLB4H6UGIuK0Rkm84wMh6tcvlFQXHJxMahN47KaycBZqT?=
 =?us-ascii?Q?vmk3299DliyyRQaqVVjw4md3cph5KSk0Sm6J5G6oZjxbs/wbod8W94rzUTo8?=
 =?us-ascii?Q?V99E384YZ328graX2C2BhiZQNU5q5unqi95Hapg2nWUa/ALX5qHO1PgkcVLS?=
 =?us-ascii?Q?P6w82xlJgQkU5nT+1CoMs55rN1tS37Lr9wcEhUuEoThblYkuJ4+bU9aTDU7q?=
 =?us-ascii?Q?IImcXR+U4KvSY+6tWM8WV6i0K9hA2/mljAwBibv+04DsGrdgcg9WAUr2RGPO?=
 =?us-ascii?Q?b8oIv5DiFpcgb1iZCUPhu6o4AtOeDy+ri8HpJBqMY+Gex2PWF8EMsCquxLeo?=
 =?us-ascii?Q?Pa+qNN33kkRxia6cB6p8bxCiKsp0ZOPg8tvEJmHEdGKiAxD85qJY82ZD6oS/?=
 =?us-ascii?Q?zLYT09SAfNS3gJ4B/STeEULH7THbOSkUU1Sp4+QyudNqsKNWMBBVaMiaUpP5?=
 =?us-ascii?Q?n5sCcoscCCKCg3Vj3BEZboBO5B+UoPqVPwaV0cnuGMSGN40g4ukicAqD7CpK?=
 =?us-ascii?Q?TyLCiIE2lsFHAgPSd32adgpYjqd8R+h9i8UNf4KFodAp2ws10tGvbDdnnco/?=
 =?us-ascii?Q?ovEtBsLhVTGzFacCSDyeQfCdlEARhu5qoBAngw/n6ACunV0RgKXwVm5/1H/7?=
 =?us-ascii?Q?LU8t8hzBMwOeZ0h48r6+e0FtBo4yMMXOA5r5jlcF45nYgij7XYZGCLMpQMaT?=
 =?us-ascii?Q?vo5BwH0mCWHnYdCMMVGLQjT018VE7Ngqo1FTHlURGahUoxa9YRIZ7hOsIIe7?=
 =?us-ascii?Q?8dSX0fQnh2DUIUEKwph1NlTqzGASj4W34qJ2d2UVfbWelUxfccWR24ohkqYE?=
 =?us-ascii?Q?tjcejoOuUjh9dDpvMpQAyyoG/gsRmrHkc7IKxEOOQSBW5hPO/seAKI8OTIJ4?=
 =?us-ascii?Q?TRNIv8oYXWydJlxbImFyiZW7nt4KABWxTRpIV6m4COgSIGOT1KWWgsgnH5Xy?=
 =?us-ascii?Q?rA54Dcw4MDjlmk8lg+L2ApNROhVx7S6fgvl1wGx2dnJycNhomObTV4VYyNFw?=
 =?us-ascii?Q?QPFMjpe7YLVVMq7l/32doKNjnpYsUCobBsOUdMRammSkfm2yH1UHt2v2P5IR?=
 =?us-ascii?Q?xriSW1AHJl/pENBlE/0Rpw4dTt8H93Q+puUPeOI4taKc/tK5tAVzcl3rA/Fn?=
 =?us-ascii?Q?RG+7x+C2qxhjDPasAbhXC1JENePXFMR/MtGCWGNKnosrI/CQoR2ng0HW3nAO?=
 =?us-ascii?Q?3ZGEZWSTwh/4NE/sBycWbjOtFZa392FT+SKaaqZFNmGcytdZ4DIkYPpyKp8t?=
 =?us-ascii?Q?WHL2Ri/U+GI3ZGwAjPwXJUUMzh2UV9HI1t8hxM3rlibboYmIzftcXnoNaYDA?=
 =?us-ascii?Q?eal5YTUWgnfNYBx7+KDoVRUJk5eQfFdpUhlU1BVmA7tbSq0I5jGUIC2ojUwi?=
 =?us-ascii?Q?nrC4xPZfAVsqCDlH5ax+Lzo+btpY4iMdd6PgGwRvQ9IN10R5PbBdw0t1W7BP?=
 =?us-ascii?Q?EjHFbHnX5Ps21uS22RFeBOglIzsMdCi+scRie1GuwN+Bg7r5aud7RkPLuWYa?=
 =?us-ascii?Q?UOnWprWX5AMS0IJxrhUaW4LAoCDHKLcgdGNdwsYPvIcH0ITziKIRsUyCKQ5w?=
 =?us-ascii?Q?EDuL7dH1yZhbL5N/E9UWrGp5BURjmiLQkmEgb8JbpRVYt9gY1t6WOisvq2UH?=
 =?us-ascii?Q?gBbBcUOzUo+HOTZRxD7ep9YGeBvU/nou4PAD74TVkcS6wIb1+qmjyVlQ3cU3?=
 =?us-ascii?Q?negBj32lWI/Btl+mx/IzuYEFLcMCAL9iYJps95FuzKRzDdTZiLu8qz3l+Yv8?=
 =?us-ascii?Q?+e1FKnIK+4fd1VnvJC+AZqYa7UfzKV4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	POJOIMoWo4kU9/gkMK+C/aNRn3LBKzrqTj3ST6FJ/aYQ5vl+vd6AG4vl7Asx4hSvbn3T3kfMzWZSTPfEso7/Vd1Wed3FUfdAv0XZY5Xq6HgjrvGRsV1ioC3fpmCbIlVjRtxCIo47L22vLV9x/p0w9g3WNuJMwNZsWSaQOu+Qg6z32iuKYZcaWgotQf218b50xjBqhGobWSDRDLkw2Mwrb0rqCvSy8CCUqfy2usFglL0Ctr8ois4vyMoO6HsT6bGFNGeLGZbXPe0C+kZvfzPan8WXSjTiLe0ZrzMqDBAiurTNYtU4Hk9jm3qSFEdcgGwLAO0QcWROh2tx3vBpx8KIElDpGSQwLYI7bb7Ii9k7ImlHQqig6GC7VZkSbSgmCbIAou380U6powIgt0IHUHxlDaW+H1LtF63AAiYgRQ49kH3FQxBjmxReEAfQJzDA8P646pATkzWZTmHm5D2A8TjRHvS4QHAZQ0o+sItNLxZcPFxaQVIpElRHTxjlB8O1O4ruIbQ7phQIJWcfIeZ2xZCIh+BqSyYkrWCDaIPfR7qbBV1nmxo7/4yF6dbd5Ldx6lKNksTp86mJtZIDQ8OquvehYxVcItj46bs/VL6cYXdFNKc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c413441d-a1be-40fc-387d-08de4e4efc6b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 00:43:48.3840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SeL4WaN+SL0GZlXZD/nTEaPx7XbySPDh/VBQ152o/i8CAQyysnxnl82WH3+k8d1Bz5ZjfzCzaFtI6PDKPdwXSmpRbxyo2vvK6YxXRy1RN7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7448
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_05,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080003
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDAwMyBTYWx0ZWRfX0QVrSlLXLTe9
 JWchsG87R1Dgupcx51yRXXizEO1jAs47QGjZe8g31T4pFvbU9iWBre18CEEKmmoDfVKDgK1iM7K
 lMBomD9WWE7mY19qPudAwDEwJxqCaNqnNujxJWp797P+aD78Cgo1tRGCk9SA2BPcIgqhbox01Tg
 CzBiLG/u9KL+qJHHCNrau0tmr60RzrqvKa4IqriAbKon4upATJvrl1w0/Md71Xsk+4FDWJUD72p
 hpz0Ow/ha69M9UvL97pOBs0LUT8v1iBZvZIU7OdFUkc9DQJ78tIrVOFqqCMjObG00MKhDk3pRc5
 yTseiUpag5WJqc4YYn9oJ53eagOnlKwRzQYKe6ZJ8HLX6FuOSMibt6haLVm415IldaMvJPlxt5+
 lrBdyqfjVbCMRyrfid8dGWVtaFVpjt0qHX020qwz2/HfsoujsZ+jAobRbnO2fLGBwFf07n/CakH
 v5Ahpmjx4c4d6KAhfOcyx5AL0dL+mB3WCcw4DjVI=
X-Proofpoint-ORIG-GUID: 7uIGt8g8i9qNiLLoob2euINN2f7TPqq4
X-Proofpoint-GUID: 7uIGt8g8i9qNiLLoob2euINN2f7TPqq4
X-Authority-Analysis: v=2.4 cv=A4Fh/qWG c=1 sm=1 tr=0 ts=695efdc7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=VY7OyXwhku8_IJuMVtIA:9 cc=ntf awl=host:13654
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DBE741C0006
X-Stat-Signature: xi7o58fmxr16xxetsk39zt9catuamh71
X-Rspam-User: 
X-HE-Tag: 1767833062-803772
X-HE-Meta: U2FsdGVkX1//1iXqJCCDSRI6Tu/Uf/OHX0dAzQPVKWRKQGMCeDlVHtgeJ09w9GF4oifI5gcsLfChrPiIPpr21FAg7YN50zKq5PD6R9keDIQK3OtvK6Zy7W2UyLx1zg0qca5FURFG/DtQAgMYMLjksZEDA3iuWgSfAZv7VX8m+2NKtYI7xKp2bzqyP4nq2b8OngbAbDEsnf6fwmvg4E7E9ra908v+559gqL+IKB0saRaGusK5BvbJzD+8iB9RFzEY0Gc8H7tN0RueVllYfvcwDSgeBr4rZt/FguUjuMQ3TyQYo/+P3ltjAGeddZxpGZx/jXuj7fGe67B2gwTjWwPBUh1RJP/NKBOSZrC4JPCx5zCpMT1a7PbqIXN7uJ72d2qD30mAr0lyXrNnh3DQhu6uijlVpHQOBVoDfnzPB7kiFXYPQshzVPo1Va43/r/vaKSm4byytA0PsJ/jbMZhEEtYRtu9XjW6bBi0nninn49cRnGRhOamPt/rzfeSbSJsS3I8eD3Hu/fITMR8WjtoSOtO6qGPrQUif+AVa3Afe6vuaXRL5U6q+u6TE/t8irg4wDc87789GvAs0y/Ahuwk0wk+hAzIgvWcEArKsCLZBC5MrbtfuP1EAQHWeg52ZJ4Yo4WxHil33pyPqzt01P7+SVHJ2YNT9AV6UvtpznnVsWEnh6YxVeqjMVUObcDLbRhzwEFtA8uJDVmXQ9T3yQpwc+T4cMWjaRH8a1iFl3EbAOUs+BGPos5aM0ga4k7bHNgx4rA/USbxCIKoqnOloeEhuq/oNHEZX3AdgfllKYcyaUyQu46ntUEaAjanbQfp9CFAbamXPnJ1XkSRd82C/q+z/clQJan8oZZmvAl+lPWDVkptnsIGq1wJGcDpFY0IkNaY40Q17gEWbn8xmEr0yLdyYlmFrkJotuvNgU3mbga+ApxOnP1Abh5kEhkLIlfjF6nnZ12tegRSelLDnCbAdOV11fT
 fzn1vbHd
 WQBuzihgxpM2EzlhViNulUaJjjTLDhq/3xzbi9HH6mwF9vJv6qfU1QvsYTUrDSink6fOzGGJ+6PTNnexed/xwYAm67RoQpCkqO8CHkb/a/MBr3EaT18sVcG/CGq2SQmgTlgAxzFkudqfo5/YU2svkkVPBSWZ/b6wGY3Knh1tFawqxKXvFAj8Ok32SH+HZNZd83yVE/y5W3Z4997M8Gu2K4TAblHAXnTcWQDfNJqcFR6gEffv0ru8j6Mq+xKGT6UsNKnE1kgn/AG22cfThKORTrLxqXfXOUfjTT1q9UO7Q7wfRkiG+WvqOWG2c6deTeHn8P2PTSe9CNtKXCn1MvbadbvbbHlz75FLvCvGRhN7rFKe2i691Lyq4vY07oOpO9b919dziMQ5mSbh7T98jwCUeR7XyTQOnDjyCQZVc7fuGiZ0ZiqYMas+rzOEgRA+XRxWs+nbyWZhHV9FUAjbc1y7zJapzLmVsaEHlSsMHv0uYoCsk5DqWQ5+XPcJh3skFAs7IOtXToK3uU1Of2sFZbVV3ybnnlzG2nXAoUNTqknQVWJjENWt6Y5ttHY2PLVnv3MRf5uPEpYIgVzIpI/ZoUSFjS8IlhzBIGIaIC+O+F1tYtCembSrs/7pnfENH5KhEKHWv97VhLAeav7toNmfjTNCmWzIU/0SOgjKl3nymVmhn6GnjCEy10WSZnJE0hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Constify the unit computation. Also, cleans up the comment
a little bit.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 mm/memory.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 11ad1db61929..95dc21ca120f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7240,19 +7240,19 @@ static inline int process_huge_page(
 static void clear_contig_highpages(struct page *page, unsigned long addr,
 				   unsigned int nr_pages)
 {
-	unsigned int i, unit, count;
-
-	might_sleep();
+	unsigned int i, count;
 	/*
-	 * When clearing we want to operate on the largest extent possible since
-	 * that allows for extent based architecture specific optimizations.
+	 * When clearing we want to operate on the largest extent possible to
+	 * allow for for architecture specific extent based optimizations.
 	 *
-	 * However, since the clearing interfaces (clear_user_highpages(),
-	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
-	 * limit the batch size when running under non-preemptible scheduling
-	 * models.
+	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
+	 * clear_pages()), do not call cond_resched(), limit the unit size when
+	 * running under non-preemptible scheduling models.
 	 */
-	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+	const unsigned int unit = preempt_model_preemptible() ?
+				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+
+	might_sleep();
 
 	for (i = 0; i < nr_pages; i += count) {
 		cond_resched();
-- 
2.31.1


