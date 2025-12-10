Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F21DD3C92B
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 16:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E546B0006; Wed, 10 Dec 2025 11:18:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F466B0008; Wed, 10 Dec 2025 11:18:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7406B000A; Wed, 10 Dec 2025 11:18:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69F8E6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:18:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFC668A850
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:18:51 +0000 (UTC)
X-FDA: 84204070062.20.D4B4948
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 834E61C0013
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:18:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NieCxMhJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QWbEg3Qa;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765383528; a=rsa-sha256;
	cv=pass;
	b=35RGq4xSw1j3Z0ZqmRNvZURXGnTS6lbQ9Sgv+nY2Bzsukesoz5Ct7ywGdFQbfaf79XzNPn
	+JB9WFkRc9IPdlwQOqqjyfqmy8ZiZbzFG2VYbHa8jB6NVenZsbcgWipX4Q55aLy88l1NDV
	oW4QKeYV/MLzNo11rEBhKlL4X4CuVmQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NieCxMhJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QWbEg3Qa;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765383528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Oprnr3YbBCV7TniZBVfUBnqL/LPSGCtR4O4/wbPK3Y=;
	b=22l53fZ7ZCa4a+9SxJgSIglrR5ysDOCUcKJQs6oPKLB2FdioBfW8FmE5W8g69jT4+69WNH
	0F+67/GDVIbz4sjuXygMTmWsQpnuyQRdeooGd2BYLA079Y/U7jEpeo7C/GdvJX7t6esACN
	5PPsQ0WXtGIL/4efITbJBuXPUVG8TYg=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BAFvqDk3437357;
	Wed, 10 Dec 2025 16:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9Oprnr3YbBCV7TniZB
	VfUBnqL/LPSGCtR4O4/wbPK3Y=; b=NieCxMhJpnnQiqgzfkk/fzB+7h4qTG+6Fe
	qNyLnlh2j+lldHmCwWkzaGq+y2JJEgL72dtrS9IFz5MMJwiFPoP6lmPwLbY67AWw
	2wI8vhiLZ32ZE/Yldva4eaTF+s+oQQC4s72ZPAh8UhcndMp3y2wmKZH4aXpnFvZ3
	4U/LQSZeM/mmR+aUoTFYI4c4S/j9tReNNtB4C4bExJP9JGaMAnvAn1SWHo/MzPJi
	QUzdwHKXOzVKhP6ojMa46FmCg9X3+HtuaCWipgTtwP2k9cbIyyZDmon5XpfpOK/u
	yTwLLNd7QS7j5H2VOHlkYrAlpBwRtVmH2oBvNBw8kI1lN1feQI+w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aybye017c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Dec 2025 16:18:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BAFV5Bi038117;
	Wed, 10 Dec 2025 16:18:41 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxaq5ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Dec 2025 16:18:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpVvimeSJNuamf2rhxCBtmGWSeWDgjg6H5qUxZ3d2zpXwHqyxLJgKdP5mbmHnYhLvGnHP4r09vXsIEgeATeiMh5dw7a/6KQTDceQ0tlBb/xOZ16VgLNEbTHEvngTsHXLlPVyATIk0OoEhb7SrPspnZFXSD0EmqRapK0SgEo03yNlGjQT/QfrsHVjtLItDsu176uDcMcCs2L1Qf15Dp+hjxHmP501POn8Qufrb+m/Orfp+x+1HrfLset1ywFZ0Njr82e/QZJCBmc9W2XF4+/3uYHCrbCXYwtmgH4MvoQEIu5G1I9efLRq1+aUOUtgbD62YRFSD2zt0sRHEqRRw7pevw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Oprnr3YbBCV7TniZBVfUBnqL/LPSGCtR4O4/wbPK3Y=;
 b=K8Az5lugFWzsl3m88faiClL7SSJ9SI/g6ukzDQCeGaSFewr+JkxrBw73u9hLZDciQ1YRp5EOyGuySV0rWPpib/33E1u9N5Egf34UkrEuXWcQdz3hJtmPQrxwmP4UR2Y7Hi2DiEn9DSFG9eP7o3VR6Tzf/rHf5jdotAkkmk0MjSV+Z+SbN2ZU24lwOMhTXEc22ht4UhZtt1/ArB8eriTFPiXi2RHr0dnB2d5vG2ZbsOQI2sLFLXWTrkA3h4JHUamJ+pkZDrpQfpi4u+MItKzm1QFIbQvgmdwh1+jQtxS/LLavB/65TBIiZpUBwpteK7ZeKOc4VdyjMT+MxSpOLRF4og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Oprnr3YbBCV7TniZBVfUBnqL/LPSGCtR4O4/wbPK3Y=;
 b=QWbEg3Qakz7aHrB4hBBE7UxXEhHAQ0vsL7ZMChncVh1sRrGVJfhufxM4bafLRBwyz/zPr1da/SNJSDBOQcux7IjSNA7rgB6NIXU2n0/doMyrPkcqqZ6CiJoJvk2VD1vAIZa9aGbqpOrWztxRtUxs/0Qk4fSQa9kzgq8anh7wDGg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Wed, 10 Dec
 2025 16:18:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 16:18:38 +0000
Date: Wed, 10 Dec 2025 16:18:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        David Laight <david.laight.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <0a7b6c7e-c388-4327-b666-6225bc63c90c@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin>
 <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin>
 <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
 <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local>
 <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
 <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
X-ClientProxiedBy: LO4P123CA0389.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5038:EE_
X-MS-Office365-Filtering-Correlation-Id: fb7d77da-1c64-4220-9eef-08de3807c67e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sddNO8DzpwjnQAVK7pu/oxoz+ZFq2INB0klStTgVHke0/8sTOFXxEUzvDeJ9?=
 =?us-ascii?Q?luWkPeWlgmzV5k4diY6Cx2HW1h5Yj0S7MPmI2Or/oD5PVxwiyQj9MZYsV2U6?=
 =?us-ascii?Q?5r2iWDXbC9foZAQO76W2yEiNQxne14MbSyH+gRfyTaRmiLH7eBPW/o6t4xry?=
 =?us-ascii?Q?hV0R2q7PxNqNfuH4OZTCX8EDVtcYgGqVkIM/afoMFh/oBiYdSwaRtdV8jTZM?=
 =?us-ascii?Q?rIxnpxWijBbHE3OoGLb63iRMk4y1lK4jwi1odnqsILlyj9lf+YJOlIFMPQ46?=
 =?us-ascii?Q?ue4Kqsm/naA7vty8CApMBP7OUuuw1buEKEhe8a9diNaieuQQEuBKSkn5kidm?=
 =?us-ascii?Q?dWoD15KpnjPAqqIPLiZM3XqJliQAVei/SYH1Q3uwEGet+3p3m4YLxeanrSGZ?=
 =?us-ascii?Q?pI4U9zdFFpsOsnhcQaMY5TWotrLnrI5MF8MFty48RG8NXVqftbkObBFzK+jd?=
 =?us-ascii?Q?EcetXHGwneBEchbei5ED4zGfDAC1X4usXAMsbf7MEyoupPNcXvqgz4BlS3EL?=
 =?us-ascii?Q?NncQNi3xf4N4cG0iIbyP3SgeULE91Y+q8BJ8l/pbh3/Ub28wV1vc4HvZneLL?=
 =?us-ascii?Q?dA4tueekGIVTpsJX+VeCLH6f3ZEsTBfUXSaIiTOhiUmQom3pim5bjkd0PfD+?=
 =?us-ascii?Q?50hYwYHLqM4lkH3TZvcw29xieNnvTqsAzuDbfvRILOVhVeDvQ0lcxumqH3UH?=
 =?us-ascii?Q?84ZnQaA3I7MKVgCD6hcUX3Yrz1bx3izrA84OU6TF6+LO3A6u0mUvqjHAx3eu?=
 =?us-ascii?Q?N4xXtTBSLuEjKLBuGWsQnZVHnvf36jDafOgljRnANzDr5SUFLFhNbK1V7uGM?=
 =?us-ascii?Q?GwhQP+jAQr68Xw6hG2sn/JBUzgu7pdee5Qzb+Y0jzWOQ/4jv2c2OXsL1+KbK?=
 =?us-ascii?Q?AwpNjNfjZMV5LLDkjMjVHrieGjqCCSyzpfODI7EYVJbQZ9YG0jD5rgqpU/6o?=
 =?us-ascii?Q?bg2kYgcIJsWdZyjhoF/nLdL0GRoh/YDq2bCDwq2Ke2r1RaNVRJwOA88bfpiP?=
 =?us-ascii?Q?vqpeSQ/3nS7Dkran2wfoaycyy2roW9KyujGJu5FBcUvnop2wag8iRntkEQL+?=
 =?us-ascii?Q?4W/5e6lnm3uu0pGeAZz2UpOw/4cHbtd1DwcbuWvznau4iBi/XVgCgV35PcJG?=
 =?us-ascii?Q?yl7tA/V9R8REWdYEtV6NK6BdD7fso4gcq+VdblWrB/Y5xKqqu0U3de3miKhf?=
 =?us-ascii?Q?HHWI19wkId3HIfKmjDXVUtVu53Uxm1UkMAGhtEDrwsgPl02Cou7RczZ2M6Vz?=
 =?us-ascii?Q?xgLhFuGwyFIlMmyU5Eb3MQrTi1QcNoAL6gukNOO40vrqKdP4k387KHG3N57L?=
 =?us-ascii?Q?dcQGCObyb4n25DS+rGT2dy9HnSwAS7ze5sFGkJm4D5uCG1h9Arun23509DyM?=
 =?us-ascii?Q?+pkbZ8xD4gkB67qJysEvXUByXs3sXZEhmoY5oglmGSnmO6azI6+eb0CHZF92?=
 =?us-ascii?Q?a9HAqtUpC8FwogfNxDeoClCCGJ0KuH/O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wGnKiVte6wuahll0fatiwgLM3L8J14UK08Ixltysg0FwFFV6aGF7zr4lPipQ?=
 =?us-ascii?Q?dj2tS7zYuBQqtB/6+bzqEXFe2V6Tokhi+TytXFdGXMtgxpj9pLaYwxM2//pW?=
 =?us-ascii?Q?jZaivyJ4ywX82yAjkejhUEeQZcxkL3HTS9kKZLtrdXLEBEZf5Ofmraj7z/XW?=
 =?us-ascii?Q?+GNYqQtzqNQcEBaHwZ2Epz8azT6cZp/D2A3cfXvhaqOsUoVk4BKPRAQ54qKq?=
 =?us-ascii?Q?cRyueZhV5ucVd44+NNw4gUAkY/2o9kf3Xke2ycB6VAR29n4GSi14ILbxYJtl?=
 =?us-ascii?Q?FeOTYe9ZgH087pwZw4dPCwGhsUcgX7k6BDnkZPQ2Tt5ofQnIXmlE+Ej0nlWI?=
 =?us-ascii?Q?bCAoZSQqpOTIPswpznAwPZ6vZItcTU08/9Bf5i+ESQ0edunz8Wg2RBeTgrZX?=
 =?us-ascii?Q?ONm9LgRFitwmJIq/VSl5G9ctx8OPzUhtBLDN58vJuOj3Te7epzMarp0I7nxI?=
 =?us-ascii?Q?raxT9iQWc9HazqXN1BS1kahhqDLQqQRLWRu/rcIJDOj/LP2bxVm5/U/BnF9e?=
 =?us-ascii?Q?aSQKHZUs7fRdlrC4rIqkFtoxNlKT9OEwwBdDlN3jf5KKdHOus0GXRnxuYKf1?=
 =?us-ascii?Q?VUsZCiU5xnBnUffpJjVxQ/Ah3E18T+qCzVNovrcrOe9+GbkWDGxm3u104AuW?=
 =?us-ascii?Q?CsznTQo8pB3vrtTxEyH3jzo3oWwgL7rH+j7AVIsRkdt8XeKdgOa8v3uov52P?=
 =?us-ascii?Q?UUbqPypatRO0qFJO1Ji1K0tdgaMwfQn9yGF/RvG9Ya85gVDEJiTuWqyS4p9g?=
 =?us-ascii?Q?D0sAzX+LQ9KS/hJDD3Wz3Xja1DTn8Q0aqZaLTRW2L5WsJl2wIDS9xUlic3xb?=
 =?us-ascii?Q?g2CcxTMx+5X2ssCjW1Dsa54jtNFHcK0H6nzRci7KItdOF4Bu+ogmDxsT3lHH?=
 =?us-ascii?Q?J9qiJfzqBpF5RruQ26b8cZUGPZ5yRl/+HOLc4LNP0WEJN7mCRdOlpixfxHUz?=
 =?us-ascii?Q?7OvnJopi//gajqHvumqlU4UjhAt1pF4CSCW0P4GGbQHXzX8HxT4x/40r9iSb?=
 =?us-ascii?Q?uwxDFjnqWh0YpNjHk2+b53mNoCODVJ72/RgFwF/oTdMsvIw3OlO79witnSiL?=
 =?us-ascii?Q?aSIrpTOWQyZ4ZXtXN9d28NexW5udwn8eh7w11VftaV7ROJShPCl/TPJiLV5a?=
 =?us-ascii?Q?DOTfLL5IjHUovkvw6FV185IwiAoF6MfWmUnn3zxj5BP7I1Ie58gHUDAg952w?=
 =?us-ascii?Q?k4fvG5btPzuYoXKAT/V659kxsZZAqlViQKXgY9+RG8dCOBWBLXAgGN2EyZWE?=
 =?us-ascii?Q?J03JQrKJ5R/vJiyL2J0WMc+0l/MNbdKaitmRCWWWNyqrtT8B/3Y8H7sI5C0p?=
 =?us-ascii?Q?ATTwrn51tmi5AIEeT4HaUXjgeZreaI4Xf9k7XNe/PuzCb48TR/UWl31MydtN?=
 =?us-ascii?Q?CNIJAvwJhGNzUDFjnW+ts1oDgC+z31hXR4fbDA/CTBelQC+gFbjILW+eDRNs?=
 =?us-ascii?Q?FlSTJUogmodkzof3h1kuWlwS/LZvhtqxhBrUU9nX/HvvPgHMf2z+09mARXms?=
 =?us-ascii?Q?H8EBIQ9BgCnb5mQfd4wAQDGyda3QcgHbqFTFDWb4vGYXWOeD7kvcPBMayyS8?=
 =?us-ascii?Q?wbEajSiSK5e9XFlgc+TcCyTuiPfUiGZFXrPnU3SaMZpOyFFA5j1xg5A6YmnS?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MNWL+gdMaIl8k0LfCVTuUC5BjCgxqoD4GkMv9i6aFcMUmQPgneovtIapH+NqruyqSQBD2yIGZ3FeTu3WPCg7IgXfulZCcEI8hhwjUySxMeMSdyJkHuuA/bF/a2KHxtaiNHvuUlmrCanOves18gcCz522LXVfcF+c2BPw3TK2H331ff6VeLhqMhxq7etmATiQ/hDKYg08NW8EsFcF/7OycrAShsPqIxGBrQ8lmOX4eVUoKX860m0DRmsCH6NTM4LyLxqKLIOH3z29IkV0tkTeKOSFlU0Ve12SvewcERc5eB9JxeGBvkl7KN2NEE3T5tlt43IfERGgBMJvlhHF8a4jVD0VlGypEubU0YpC4PADkYQAvQ04sH8UWdds3tA0mBkJupYXZXoj87YGO1kyiusyEknMJS4XTFhG/F9C4qEveaY2GXuGoNfZ+KBL8B0H4xYz08Jt2sLCDGMrUxv40XOcwfNvhBye6ArwlmVKi+xBggy4lBZzZNBjloYF8ddjmPlYmZE7DdIPYty1EW7ztMdnXh3A978LjgFz5DDFX0kCcQXWI92EmhmkcU9UeeMWOc98Ki0ggo+5fJiU1NYjnRhleN1/CS1eVjFnmIOpWUOWFII=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7d77da-1c64-4220-9eef-08de3807c67e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 16:18:38.0275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGxLCjHzU6N1AE/3NxH8EJBXLWON0Dyu1lSvdWFBF0C1/I6Y3/a7DdGC3wB/qISR5Mp0g1kJcNnV6tzj6ml8FeQeQYUcUTOjvY00cTDfSzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5038
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_01,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512100132
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDEzMiBTYWx0ZWRfX2g6hz5S/ns3H
 fmoRriVb6tN1miYW8sk98x77NqMsSHfn6cwjrtZ+u1GC3JONEq9ORj1cd/vxmm7uXftpeTQkcgr
 LJKXJ0iZJV5a1kvOeQWAxvhu8zi7VDIYFWxCiwInxMuDtwzvrS/2CtcpSGab1WSIGTnUDj5oYj7
 mt/C/G9THI/i9BvqrA11bEkdi8lAmLGeBADT/6lS+9c1M+e6Eg9/lB/I7y7ooL+RslYRXmq3e4v
 rl5V/TdJjw44ZZAL/gaRAQkPJjw87BP21v0xuWzG3ODolRR9cDUztYG+gxN2kVHWvbTBFwUqtUd
 ZoXWX9rxIgCeKKYNonTL+wLgryDpGM9daZzI6y8X5zxwMYobBWzKXzif1Tnm1RWvA+QCLXSukYj
 saIS9ar0yjBXKSgxrlqGf8fX0FNBpQ==
X-Proofpoint-ORIG-GUID: xVhzK4ElpVVhVyZkUXogt31CZYVEabcA
X-Proofpoint-GUID: xVhzK4ElpVVhVyZkUXogt31CZYVEabcA
X-Authority-Analysis: v=2.4 cv=WMRyn3sR c=1 sm=1 tr=0 ts=69399d62 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=urmuWQJKDZMH3rg5UkEA:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: yswq6k9paxq83q1dbkigft95nppxmz3n
X-Rspam-User: 
X-Rspamd-Queue-Id: 834E61C0013
X-Rspamd-Server: rspam01
X-HE-Tag: 1765383528-14293
X-HE-Meta: U2FsdGVkX18LpjfLEJVIRRBh9S1TX1Va/7hHQl4H3XowEoWSq9+gPag/L8l5zgYeUxIdlGcUBgBtgB3mSBNIv2R1UTYiszjo0Oxq/qOnhmlqc7X2EeHC+ePIbPi8cAF89niVglA+on9ctD8FnZRHliwuthOlg6413Yt3NVdnQVu9E8MoGTJND3Iu0QKmdcc2zB0uFjAmfhHBWLjlWWDZtncvvwjjpH20s0ULdPN8qya9O5RadvZbew5p4owFtw5hUpAm0zZz+TP8VJCwfZFuz1+t/s1r3AiU3yIKqxgSM1gYD/ia2Z8R7sPZ8Uk/yKeaVdd4JRTFwUrmak/PtZ4fWMtmdHhzfCdDmZx0XsOJNuh0D9515YEMlLPV5IFD6wqq8igYA01fGq2tVckFxI/2t69ON3xvw8s5n9alzk5uv7Xk7dUkIJ3v50KqjYTDUO+lpQUoVLOwt6I9Hcz8pb24mS+t9JVhrkj4oOfi9vnvUjmw+xQ3ya1F5yEflZxOPQLxFJRUCi15xG9mP47Izn94GC1j2QCVWukOT6S34j403Y57PhYZOWu1X/tJJt45XHhy8bfTXw+dz3kT47scqzxhHhyKuzD/PU0fCtD9RHHmT3pPUUnujvqiNXmugnWoSdpRLSCyK9ZrviBDPn8yU/QSVXA5lHgY/meapKa+BMMnx6AQ6HzlYurgLhAYO53WxPfkGRVAyjMIeBSdz9JM2E747kPGLh0HdTvxbnDWIQIpK7ueCEPBozq8Z7s9HUX13ozkQ59NPpUVku/cFQJOMgsWvWYNZk4uCXYL85vuzDPsktQgIP5q+XUkex4L+y+sUAoFSY3MYojiqELsA9B5oZ6JEptoZXVzJ1GGmhueXnY8EeYvge4LCHatYA8fih8grLzNXnEFVtTpNEvx2GmgXhGDbRL6sac4Wgy9NBuo1EhmKz7P3PWEuKKHSErvi+Q17UdEfBQ0gdSlOXDkbvWWuzj
 pwjfChTH
 mUwKBJfLIe3eUJXwF96UqH//tMNCuQyfsNEfomshJ27hdA1dJOe8S/yLyZwmG05iPuugLncA7MYHaLW4WPqnfGXnEVvhAubOpFQLsEecDAtnURP6byar+7Oc34QenXLECZaAQRGtZWEm75l29VXyBBtUzukn4Kt1nrI0qvEn8aUl6hHKR+YrALBa4W+TnKPrVDW0tmTMTepOPuS4EMYJV+BdrW2CGqOkeux8QHqAYfOpZfcIltvnJhKZHR+Y5IrcPnkq+GWFLlIcmgVh+oYxWJ0Z2cRQnq/9ux/j91PS5oTJF9+D3tAoO1qp33bi7qOwPbBZ59OqyKFqXPsYkRPjizxadb4PHgarUAsF5eMvtYbB7Xgl3Qr7JF5jBGltT5oXLg9X9kipTo5P6csGT0Uw78ZyK3mVvi3nRaG915Vz5T5ieITmQZBgoQ8hSusaqiAQHZ3nZoyg0JuN8nZDTc2mvvS69oEhTiXt+Qfe7QaJgyzCj8cApgOc4h+VHqy4uwmVRw+075EYvf6pzM3eHDAJomyFxChO9o1ohBz5xZS6dm6E/iMdxNqKXezDFUV7wIzrCRlYdS10AfLKAIMq1k6gGSfXcquC1szwKcrcOVcSj5WGM5XpdAiSnf2QEb8VO4C4trQg04qE61ZVlsukMJx7RWdSQ6ZBjU9zFOkGXXTkvbVx95M5Js4bUe/ylcZYkj0B+CkMY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 10:26:22AM +0100, Mateusz Guzik wrote:
> On Tue, Dec 09, 2025 at 09:28:10AM +0100, Vlastimil Babka wrote:
> > As Mateusz pointed out off-list, the profiles look like mutexes are doing
> > less optimistic spinning and more sleeping. Which IMHO isn't something that
> > this change can directly affect.
> >
>
> Not mutexes but rwsems.
>
> The bench at hand has some of the code spinlocked, other parts take
> rwsems for reading *or* writing.
>
> I had a peek at rwsem implementation and to my understanding it can
> degrade to no spinning in a microbenchmark setting like this one,
> provided you are unlucky enough.

So we're just sleep, sleep sleeping? That would explain it...

I mean is this an issue with the IPC design or the rwsem's in general?

>
> In particular you can get unlucky if existing timings get perturbed,
> which I presume is happening after Lorenzo's patch.
>
> To demonstrate I wrote a toy patch which conditionally converts affected
> down_read calls into down_write (inlined at the end).
>
> While the original report is based on a 192-thread box, I was only able
> to test with 80 threads. Even so, the crux of the issue was nicely
> reproduced.
>
> ./stress-ng --timeout 10 --times --verify --metrics --no-rand-seed --msg 80

I wonder if large core count matters here in particular, I was doing this
(albeit in a VM...) with 62 cores

>
> Top says (times vary, idle is growing over time):
> %Cpu(s):  3.3 us, 24.4 sy,  0.0 ni, 72.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
>
> ... but if I flip the switch to down_write:
>
> %Cpu(s):  6.3 us, 80.9 sy,  0.0 ni, 12.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
>
> The switch is a sysctl named fs.magic_tunable (0 == down_read; 1 == down_write).
>
> In terms of performance I see the following:
>
> stress-ng: metrc: [2546] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
> # sysctl fs.magic_tunable=0 ## down_read
> stress-ng: metrc: [2546] msg            63353488     10.01     28.21    213.26   6331298.95      262362.91        30.16          2016
> # sysctl fs.magic_tunable=1 ## down_write
> stress-ng: metrc: [2036] msg           455014809     10.00     48.79    676.42  45496870.65      627425.68        90.64          2056
>
> That is to say rwsem code is the real culprit and Lorenzo is a random
> (albeit deserving) victim.

;)

Ack interesting.

>
> I see two action items:
> - massage the patch back to a state where things compile to the same asm
>   as before as it clearly avoidably regressed regardless of the
>   aforementioned issue

I think given the fix is so trivially obviously correct and not egregious to
take, we should do that for the time being.

> - figure out what to do with rwsem code for read vs write spinning

I have no idea how the code generation could have varied here, I did wonder if
somehow the changes somehow pessimised the optimiser for heuristic compiler
reasons somehow, or if somewhere there is something that has an issue with a
certain incantation of cast (but only after a certain flavour of nested macro
expansion?...)

>
> I'm not picking this up for the time being, but I might look at this at
> some point.
>
> diff --git a/fs/file_table.c b/fs/file_table.c
> index cd4a3db4659a..de1ef700d144 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -109,6 +109,8 @@ static int proc_nr_files(const struct ctl_table *table, int write, void *buffer,
>  	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
>  }
>
> +unsigned long magic_tunable;
> +
>  static const struct ctl_table fs_stat_sysctls[] = {
>  	{
>  		.procname	= "file-nr",
> @@ -126,6 +128,16 @@ static const struct ctl_table fs_stat_sysctls[] = {
>  		.extra1		= SYSCTL_LONG_ZERO,
>  		.extra2		= SYSCTL_LONG_MAX,
>  	},
> +	{
> +		.procname	= "magic_tunable",
> +		.data		= &magic_tunable,
> +		.maxlen		= sizeof(magic_tunable),
> +		.mode		= 0644,
> +		.proc_handler	= proc_doulongvec_minmax,
> +		.extra1		= SYSCTL_LONG_ZERO,
> +		.extra2		= SYSCTL_LONG_MAX,
> +	},
> +
>  	{
>  		.procname	= "nr_open",
>  		.data		= &sysctl_nr_open,
> diff --git a/ipc/msg.c b/ipc/msg.c
> index ee6af4fe52bf..fa835ea53e09 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -474,6 +474,8 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
>  	return err;
>  }
>
> +extern unsigned long magic_tunable;
> +
>  static int msgctl_info(struct ipc_namespace *ns, int msqid,
>  			 int cmd, struct msginfo *msginfo)
>  {
> @@ -495,11 +497,19 @@ static int msgctl_info(struct ipc_namespace *ns, int msqid,
>  	msginfo->msgmnb = ns->msg_ctlmnb;
>  	msginfo->msgssz = MSGSSZ;
>  	msginfo->msgseg = MSGSEG;
> -	down_read(&msg_ids(ns).rwsem);
> -	if (cmd == MSG_INFO)
> -		msginfo->msgpool = msg_ids(ns).in_use;
> -	max_idx = ipc_get_maxidx(&msg_ids(ns));
> -	up_read(&msg_ids(ns).rwsem);
> +	if (!READ_ONCE(magic_tunable)) {
> +		down_read(&msg_ids(ns).rwsem);
> +		if (cmd == MSG_INFO)
> +			msginfo->msgpool = msg_ids(ns).in_use;
> +		max_idx = ipc_get_maxidx(&msg_ids(ns));
> +		up_read(&msg_ids(ns).rwsem);
> +	} else {
> +		down_write(&msg_ids(ns).rwsem);
> +		if (cmd == MSG_INFO)
> +			msginfo->msgpool = msg_ids(ns).in_use;
> +		max_idx = ipc_get_maxidx(&msg_ids(ns));
> +		up_write(&msg_ids(ns).rwsem);
> +	}
>  	if (cmd == MSG_INFO) {
>  		msginfo->msgmap = min_t(int,
>  				     percpu_counter_sum(&ns->percpu_msg_hdrs),
> diff --git a/ipc/util.c b/ipc/util.c
> index cae60f11d9c2..c65c8289a54b 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -771,6 +771,7 @@ struct ipc_proc_iter {
>  	struct ipc_namespace *ns;
>  	struct pid_namespace *pid_ns;
>  	struct ipc_proc_iface *iface;
> +	bool writelocked;
>  };
>
>  struct pid_namespace *ipc_seq_pid_ns(struct seq_file *s)
> @@ -828,6 +829,8 @@ static void *sysvipc_proc_next(struct seq_file *s, void *it, loff_t *pos)
>  	return sysvipc_find_ipc(&iter->ns->ids[iface->ids], pos);
>  }
>
> +extern unsigned long magic_tunable;
> +
>  /*
>   * File positions: pos 0 -> header, pos n -> ipc idx = n - 1.
>   * SeqFile iterator: iterator value locked ipc pointer or SEQ_TOKEN_START.
> @@ -844,7 +847,13 @@ static void *sysvipc_proc_start(struct seq_file *s, loff_t *pos)
>  	 * Take the lock - this will be released by the corresponding
>  	 * call to stop().
>  	 */
> -	down_read(&ids->rwsem);
> +	if (!READ_ONCE(magic_tunable)) {
> +		down_read(&ids->rwsem);
> +		iter->writelocked = false;
> +	} else {
> +		down_write(&ids->rwsem);
> +		iter->writelocked = true;
> +	}
>
>  	/* pos < 0 is invalid */
>  	if (*pos < 0)
> @@ -871,7 +880,10 @@ static void sysvipc_proc_stop(struct seq_file *s, void *it)
>
>  	ids = &iter->ns->ids[iface->ids];
>  	/* Release the lock we took in start() */
> -	up_read(&ids->rwsem);
> +	if (!iter->writelocked)
> +		up_read(&ids->rwsem);
> +	else
> +		up_write(&ids->rwsem);
>  }
>
>  static int sysvipc_proc_show(struct seq_file *s, void *it)

