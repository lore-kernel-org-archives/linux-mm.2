Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8AFEEB2711
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 20:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064176B0005; Tue, 10 Feb 2026 15:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EB26B0089; Tue, 10 Feb 2026 15:42:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7806B008A; Tue, 10 Feb 2026 15:42:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC7E86B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:42:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8176F1A0679
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:42:20 +0000 (UTC)
X-FDA: 84429719640.19.2EDC699
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 054A51C000F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:42:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="V6Aer6/z";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k70ixE6f;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770756137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcCoNgpZ7cZgp8HRkNF5edeGS1c9WLlSyGPDdiP1gvA=;
	b=TCiungzF1+lcQSmfnObBOh0FBLRK+mkpCFNov6+E6alv33hr1dEuz5w2drmmBZTCDj/7q3
	Kmo+ptYRJnU+GkINOYqspmvXV8cy24yo+eAle3cDPHO5x/piQaEQzYXxNvcYEsyQOsQPR2
	3Cabu+mPkLC5aNlDuSi/ckaSANnE2T0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="V6Aer6/z";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k70ixE6f;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770756137; a=rsa-sha256;
	cv=pass;
	b=7ERfrPFBMS/ybzyNnP5i0cXJ811GH9i2kmMYdU1Ok1Xz9+72NDYU6VN9m5+jCYX7qJy/73
	ZAXFVpXg05aKiFIkiZ0jLoXRA58lW+IJtTLIPp113wpGh8okbCCRo/2r0zHycTy2g8AThk
	ZQ9936kuc+PkSG5cXjZ5qNVUqO5082w=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AGeUDN1407029;
	Tue, 10 Feb 2026 20:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OcCoNgpZ7cZgp8HRkN
	F5edeGS1c9WLlSyGPDdiP1gvA=; b=V6Aer6/z1AQzFvKmD4MJkBVAwz1nn834+D
	dNcIIAqfqQL1kCjykPZPGrSIGDf1BGbVXMaEiw2m1HckqZQXKPuc9ja3HrQuPpz1
	ySq32rzOYEpdOJnXaaKnoYcy7W/Mj/t60b9FQA9tYpCB8Fq9AMZQ/5VxUUkYXbtZ
	vrH60hzHHoec4dxZINr+Q8orG4ItZLwbJuQtz4z4QpitE1ULr4t9qySGNtoLnO9n
	4xXmhtqrD7Um8Xh/8+u7pe+0IJrBmOtVKoAHVhtjnEt8Vc22xogx6hkbjVLgmWPJ
	WFs28mgc+RGGUBueBiNK47RIcQE1EOz2EmDb0DB7zxHRzgG3OpfA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88df0ffw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 20:41:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61AJUTZ4033208;
	Tue, 10 Feb 2026 20:41:48 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012036.outbound.protection.outlook.com [52.101.53.36])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c825u358v-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 20:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3laorl8FhmuKdzG1a/eVxQCCcim86jrQcI7DC5wiU2gK43VEsO4U9Pz8p2Mk/dzSJsEmYweEfyksFs2EyxF0LbgcLEgPOSNoVeJ+Z6QF0wtR18oF3QBha3YqhZVEDkUSX71IA9gzoFSZUf3bPVO8Wgvu1QDvTzQZ/lsBhM+vVsGFQjk5nZiT31nlXBS1baIZsyemjv1Dk5j3HCJzq6+4b2QvaQw62w0sjuKTq29U9j9xmJlaYeozBv5mC5dW7IhaaxBa1FsdtwxiNXreg/c7RNirDlJJ0CdHbpXkN0MuWH+Aw3L1Kjg2IptiOsFTTn8VqG3BXZs3KKCuzLI51ahOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcCoNgpZ7cZgp8HRkNF5edeGS1c9WLlSyGPDdiP1gvA=;
 b=ndqoxjtGySc/FtdeXehmowyC7HBtmjxTvecLkOwSs5Pfuajvuh+exE9M6UvnFFQit+vZM4FldJyDyTT1NC/K0nqT5f/rXqvRcxErOTTpmZogzLfi7T26Qd6pZQUSH6S2NXRwhSAwds9ErI/AxpykPyvuAds4R3cDVuqrwVT1O3wFmQVDH3tJg8LqcpFWybOlRNdKNpIATw71FEDbqyHf2QLg+poUggMgbjASne2KpV/9X9R1v6z2cyedx9tVWRdeUesRMvE+HFJ8VPfVoBtLvnBt0vXPacLRndj349I0RCNPw18fP1lYxa5eqLVJkvPGHlacGKl1t0OwRWYB0309bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcCoNgpZ7cZgp8HRkNF5edeGS1c9WLlSyGPDdiP1gvA=;
 b=k70ixE6fu901m5zPVkdpEk44fpNfNPzXjxiTt9kUsiNtZ4B4eNqdwgsfE+gWQBYZ3jGz7sgl0FZGRfHCYT8CxLD0GzJlVpRpeH0N9/X2QEXzsfdDK2ZaPgcCZIG8bPLVEs8qIvod9XnsqmgHgiUnhZ7dhcZTC7y6AeYeEOhiE1o=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY8PR10MB7368.namprd10.prod.outlook.com (2603:10b6:930:7f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 20:41:42 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 20:41:41 +0000
Date: Tue, 10 Feb 2026 20:41:26 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 11/11] mm: Use unmap_desc struct for freeing page
 tables.
Message-ID: <ctz32d6kigivl2fb5ll7as7roa6kwptjjzhf7d7ozpazifapg5@w3ol42q343y3>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20260121164946.2093480-12-Liam.Howlett@oracle.com>
 <20260124184555.3936797-1-clm@meta.com>
 <bupca5z5p4obm2u5ojnxrdgobpor6c5i7h3uac7plynumgskj2@uppkothe7bre>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bupca5z5p4obm2u5ojnxrdgobpor6c5i7h3uac7plynumgskj2@uppkothe7bre>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0061.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY8PR10MB7368:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d0e1ccc-afa8-4837-2a75-08de68e4cbd7
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?p6BdK9OMc9lZjG42cqJ7aG5X7e4c3ywCDZbzN0Zl7hjmYD8KlxY0mVxWoG5O?=
 =?us-ascii?Q?AWtKcujLpPIL5Vbc8vT5N80VkndckRRPYCSIZdFIlzrZ/vXm5QxlOoyGd6Z/?=
 =?us-ascii?Q?IIie57DofHoaAh6HjPAKhr2rveYO6rSH5X1tdFaRiW8R9Z15fIUzoNq8BmPt?=
 =?us-ascii?Q?4mSz9unJDd+mZp+IMrJJwKu0fnaO4wdJbXq1cB8N4UnA9OVJp78F1JycTrUk?=
 =?us-ascii?Q?DPQIY/0wcqs4A2/TS0j5QkzHPJ1cPD/yLhNLx36PuGOHU4DuCj73KWrJKmWY?=
 =?us-ascii?Q?2V/yuzZRL1+gvpZnkgh+mJoMQlZvMYFW8o0lDRSqwGwYD2IpV9AnDLNUGqRb?=
 =?us-ascii?Q?NdLsbwV+6ifL78vOF7ZLUUcp+G3sYfSE4uB2DDkcukzujS5ZQxeAlCLIUHA2?=
 =?us-ascii?Q?sNThNuv06NkyOv78/rGbXtcrwa3jOgoz2f0ImwHwomddggj4QyMCKAROM9Re?=
 =?us-ascii?Q?nqplQz0hrHIeG7f7W2lp/OwgLKfh8YNrx1fbQ6hBTfw8xZFqawOWherKsiW3?=
 =?us-ascii?Q?6AHCxc+7grL9FpoV2NizYqPBT/guk1UpYlXJQYjJh48cV+V+whP6da6gCKq/?=
 =?us-ascii?Q?ZQ2aseNurKPnE5BZYUDdsWsmV19OFKxp7lsd6jOogyaHp7ubsCtc3H7WtEKt?=
 =?us-ascii?Q?0NxWcnnFOJNetouqWLz7G4+ge8IWkZkzHi1SXIWFd6JseNVyu8gKESxWVNbp?=
 =?us-ascii?Q?4oUIXmvkrgTNRNX3F2rMlOOQh9bRqc9zBzIH9ubxzzNos312PBVeP3Dac9J4?=
 =?us-ascii?Q?y2spFCG3KteRbvHlb06rd3flqdpJOY11KvDVwwqiXMp7reBdlTG08H26Wkif?=
 =?us-ascii?Q?lAJo9WBSeAiqhN36YWljYrLDSzFPXk/aRvqAebOh1RiZYLwLvViz1VzOUHE1?=
 =?us-ascii?Q?SLwDR1na8zZvLE2y6u4lPkxl+LFcjQeCQtDt90qkJHfkh5lHZxfKuUl6Lgd3?=
 =?us-ascii?Q?yNkfxbX+vJ3cyV20PH9Kb0M4YdYMIGax90sSe5z8vRb+3GjQEt8pPCouIlcU?=
 =?us-ascii?Q?8sbO6e2t0qBI4RC9FUQ4ApM5zAe7FNC9fpEVdyc6DiCsE1mSCJla9EIyRerT?=
 =?us-ascii?Q?ml2xiewdhwBa7AQpZ+z3zXouFo8ZilkznGg3xzX9K0XJAfowTN17SugO6YVD?=
 =?us-ascii?Q?hLK1hMBLyaJ5SGFneqJdWEpAkpFeALpx9qm90sjCTytdtuUwMyH2blBqD4tl?=
 =?us-ascii?Q?feh4MRwEdbtc1UP7feRdlskuGahWAClVTd1B6lpn0PorcH8gMwKYMsl+bDa/?=
 =?us-ascii?Q?QMcGr0Ey2W7ijXAIjUc/6lQ4luAfzQO3bsC+PMMVVUTm39R0NWDP6xOz/dtY?=
 =?us-ascii?Q?r2FGuOzg8sZiT7udZoGT1246V1CapvuE0eWMdcgGEN+/Vkc6TLAHAWWxslnn?=
 =?us-ascii?Q?cE5fe+mXi0m7WqghHVaUU+TU5Qk9nW4qoaVm9ZwRHVNir2dJahDkrjhf+7Hw?=
 =?us-ascii?Q?9ISIVv4wDR0djn5Djb0jLyNT82oK2es+8ZZH4phIrwO3zZvYgDq/spVXOZ10?=
 =?us-ascii?Q?c9AaWG+C35N8BNuV40cl0hWL7hp5QJFmQ4vGBrJUIWofboymi3LgyHRztU9e?=
 =?us-ascii?Q?HLg0RBTZcdnyVKVIR7NZ7IrQVijPIDX96n2qJeyn0Pq5WPr59eh1pSe8UCbD?=
 =?us-ascii?Q?Hg=3D=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?UtWL/IRktiC7YZuILSrxSccZBTxXSDFt/3qodkz0Ij8SBTj3NiysfKpn/a65?=
 =?us-ascii?Q?cfBiiyeRj1aKzgfDg2leBY0Rlt5PiH7cTCrDhLnVE3pYcUmULIYmhKUwIeTT?=
 =?us-ascii?Q?H5hA0thTSu6BN5M37iRSIMIj0csPtgbgGtSpJMq26du+0cBUqsj1ojsR9PaP?=
 =?us-ascii?Q?OECjY06R0MRKKy+QMJNrcL7TmcHxLSc6sEZhi0NyGXMrrbLmRgJh1qNGinHu?=
 =?us-ascii?Q?fna9tWihutcxzIZihil9UPIr3Y2oGp/+Gm91Spy67ak60VrRtkkOAPawOWz7?=
 =?us-ascii?Q?AzPcjprDBqMO8H2eTZ6BNFUyI4mjnXZNxrWCtf1FnRnU3gvHybynC6CJWIwa?=
 =?us-ascii?Q?2aoZ4QjIB5NMxQzKa4vB/ONhqHIy3EqVmrXv13xv5+QvvxFu8ok/ot8+akH6?=
 =?us-ascii?Q?TwM1pflRPeQc+5UWFf+xvqn+nbpmtvtI0qx7TBES7NPApz9tyOB6DjQMPGoc?=
 =?us-ascii?Q?7f4H7WWGsQ4pzwm1RIo86a2zsXzzoOqacW7AKgzQasYFccwTo5WANclchl/7?=
 =?us-ascii?Q?Fs4HnHlOhqM9H7xTPzGnlHNxsXc5B0WM1XfbXf4DLqn0xw5q4LjOPo2vWgoo?=
 =?us-ascii?Q?Vehf1XAL0zor4kC3RrbdEq7JxzJMzUEs1I2bWuCQGtsVHer+sk5i26eT16/D?=
 =?us-ascii?Q?L6yCzWRfxkqOgA6+TZqY4dP4qtyNX4mu+KeiO7U0NEXBWVg5XlaxAjeaD9O9?=
 =?us-ascii?Q?zYCxYI8/PKebTE1xizCU+pcvtLoR+sZsVxrwZ2m/TNndP03qDCGrL8AduHmY?=
 =?us-ascii?Q?AWnLuD78UbSbicfnpiuqTZD+pUnweLX7+C1TFLaB/T9plH18PGLFhV4RIJYD?=
 =?us-ascii?Q?S/BCMgqFDh3XNAmqA8lKiXUwHVUQFSbUHBCoHlF0z53RFwxnadWXcTgKzM/d?=
 =?us-ascii?Q?llSnRky0ShfYQW3/UtI9CfAbXjfOssVHDN0bqBf2Enudxe96KoIkYhKR1S6s?=
 =?us-ascii?Q?kdd8qniJ1UBWGzaSV5azogc22evr01xlMK04EuKM24ri/k5t9p2Xbz1Cfxaz?=
 =?us-ascii?Q?fCwZlseLv2BW9LNqUxM66XLLAfN1EA5YprDTrQ3y8wUIrYQiXuJd6bCcMzid?=
 =?us-ascii?Q?jbXQksV1JiB3U51HqiQD1SFX3qUTQYK5QKlJjXcg2CDrlHCwuKwVZpRIZxXi?=
 =?us-ascii?Q?HvG7+5+5qEkN/05PiXkJs38hn0j4P5XypDfwhnf8Bwn9ERpjvIW/t1tKaGqT?=
 =?us-ascii?Q?udFEmLjkxrsg3ls0u5rvpwOQ2ovOjN3s/Gg62PfRd7b+LljVkIaRrtboeuzT?=
 =?us-ascii?Q?/MQ0oM18E3ndCjWXiSz9r5SfXqTtie6ws62xpTLxiQ0rTgRYcwmd1lsezIEN?=
 =?us-ascii?Q?0KRZnFRi+M2AiPuiraqGr6TWCxMHf9h343uu1bHRNrC16G6skvMRMMSiXRm2?=
 =?us-ascii?Q?Ivr11L2rwJbNG1LanYALUvt0Gqvr2STx8wkIyEZHdASyRSKomUhLCKCrIsYP?=
 =?us-ascii?Q?FwyfvXhs8kvLdOBs6KxoCP/HP9rW4ottKTfP9qgRRJIwS4x547PlFWyQ2nnj?=
 =?us-ascii?Q?p9DX/H52CVzK0LKFBzZnIk1HtA3cnYow1Zzgxa84oLklGj+3IefKWYzE90bJ?=
 =?us-ascii?Q?fW9TZRhlffQOO4WkRkZrRP9SRL/mDHO7E+1l+X15GxBPPhWF6QEUZTRqN+kY?=
 =?us-ascii?Q?3NNlejztWPK0WDz+WJtHWpgd0vviitv2dFgnEpZOBaTmW8Q2r7kMBGNz2QQ3?=
 =?us-ascii?Q?AdtvYS4CSg6ydw1dnq9WqEnOEEF1eF2l9YROgcV/dPw5lNYjVhEe1VbtWTdh?=
 =?us-ascii?Q?Iel0DvM4AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JC0UVtm9iaE65vbQ4xmiKW0N6HoBQ4A88/ymNLK9w9KJ8L2f3nwHYhdo/TnCfebKWHDgFPo8Fzh9kCd7tZkmq5TQoCHDBo0Uj3+m0K7KIyET88SnTVZ7NaavPns0AOfz8yj5YI7eDNJ7mBCblyYaU9RiaX28zUd4r8T0G2Q0WcCpf+SDxvyywdAuvXjIags4r89y+02cohU9+tMJfjCs2wS8p/tHLmdwFWAtXMuowx63S3FWI7cTOBvNZxhqekMXYVe6ITbib3+BVpgnLVKkMo856PJPX9dKuMMcrfpJvm+qqG9LNjXgR0L3Rc8GLRbGEVYZbwNfacVZ7/U0tVlNMnBOmuZb4mQA9FaorhayoDyUYHGITzcxl9Vqo92ym03gsFlzHDs7jJJS6wpz6bM5HpJNTA8cCseXQmgp/vftPIuJs34C6WjnEPaVWjIxklpJPCH0810uCrdaRnDsgLBbFt4NbooUKZBjajPyCeY2H0yr4S9DNs5sGwEvrVW6Oxm5KUJeDV/A+MO/l/D05fDwcrpXalzPkepu7H7WeAfMfueBj1qmey0H8PuIalDgI1J6qNwJzK5SHzbKSEKoUfPDxVcpQwVH2s7UXNprYQxvm1U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0e1ccc-afa8-4837-2a75-08de68e4cbd7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 20:41:41.7742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TakXYaB8e5hpRqfSNxH5T42F5zWjHPZ6EBN4bGg+Pr6/EsKXrLrqieKDMLEpRaXPPIVuHAaTgN9HY6k5JbL82A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100171
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE3MSBTYWx0ZWRfXygpGhwv5wM9u
 DGKC1vo3I4U1FiFE1lzFhEeG+7EwY2APH7E0lksT9WF+7eQmQH9F5PKZb0iAh1TFm934WDkXlM8
 e3RHF6SgUgVTqZyYHieiQDneeewDFGBzlKeQfD8b0uFtV32hNjgMNwZt05X1uR4k847AANvcNXa
 EKo+M5T032rrGCkmQ6IKzdcEKsdssD4beFI+jZOd5XrMWEkM2qb2Ww4X/9nbGB4zCQg/3XdzIkN
 ZvzAZ1q8cfvts8gdvUcGFld++8Dy2r1AUp/nCW/6JEVk+pkVFspG+tr6zuXZBi8H/QJscsZOrUW
 nqFKSNPSQdgC6VKaxxJsX0yDtaKQpcs4SLtOPmKP3ywEIlD8LwRfPcb4aPiCjjBr1r7oVnnC14Q
 SgOD3VlagxuFBtivCo3ds8GLA3TAlw4DFus8WhCYhOyr9uIvneZZmDsbHO0iNaCefJhWfMdRO4W
 ssob55R3VXOgs+mScwAE/R1bgaJsceflYtDDRZLQ=
X-Proofpoint-GUID: _9pzKWf8CCDxjCLYGaoFIHMq3nVSq7OW
X-Authority-Analysis: v=2.4 cv=AqbjHe9P c=1 sm=1 tr=0 ts=698b980d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=VabnemYjAAAA:8 a=1-UZzCTIf-G-U3n_HSsA:9 a=CjuIK1q_8ugA:10
 a=gKebqoRLp9LExxC7YDUY:22 cc=ntf awl=host:12148
X-Proofpoint-ORIG-GUID: _9pzKWf8CCDxjCLYGaoFIHMq3nVSq7OW
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 054A51C000F
X-Stat-Signature: 1pafddgmp9ir6hrpmat54st4wz6xza7g
X-Rspam-User: 
X-HE-Tag: 1770756136-429851
X-HE-Meta: U2FsdGVkX1+aD+TbCEzgJ+JaH62VzE2AKo3CoQKt4IR3qEl0WnJdeJ9abGwqbVYagJKX8MpdtbMnnRm4AWAWT2Z0qe1P3CJRFeu6DiHiCfUGkYYZNLbqNS1qBj0tLNK0w26rNMqfXKHVFmZ5UXxDvxIdtVKN/2h2ZDXBL0uLpyC24xBToo19Mrt8xGipVOvAW+GLlFFpZ8L1JlQeJ4akMgVJxo82OcQGJes+4BdXiwcVJ7N2+AoSj/hlBxoPb+NEx+3Ju+Co99cNqBF8EyAYjARQ2ENEU/lYfNJHNv+6SdAQ3uDIWKExhZ7F7AMtLbfyRAJ5rGFq4hHrU/glkOJIjo77B4uqV6V+7JkyQHf5kpLogX7oUEeJgxFeN+u4ucP9Yxyno8FjnsvhkeUKzV02FjcbDI0ofFb5jbLEOpsrlAQkMxT56BV3UcL5uONa/jMa28XNZf+602bFWEBYp7veYUIBnEoFdD/lLEn0PeXVTmWB15Y3cvTepaPHcOQtJaDIyiJ7W6czTK9nvhtqbeiAdqJf76yrMY2r6EayixzhnicspFOMcG+ORRXZVvHq52M5KEkwNq/vpGjjlW0xrnr7IBGLde9T1k6RgnxBM1vUhshCSYdc1iIyKQTP2EVJl40dk8otJ1XdE1I/rp0bLd8jYRP6y75y4TBm5wvQ+buq09rdfzMHWggMRVZDSff8psrybAY8Pv4C1TbfRh7UbNNY5a54SnOJVsTRGfvhFnzHHGdqUrxVMEMmIKNDZE0GS4BqSWFog5e5zOE7x25pWfXMB7JQL3lb6yGmwjs3IKp6VXaUwDGzdpEvDWDpqDz2xyADT9dCIj+j4JmBTpbuQBlhVmC96a5vKNj4/qRp+gWRa6RlmSz2/mk8PBT+x9PlFH2CyBuNdVMAHynP497Md+n0wYQ/GcYVSlUw0QLBKcU9lKq3hh/KKzJsO/kZyTWJbWBucVUhjCiER7hM3pW+LMR
 5MyDSmWE
 drtsqkzYrRPJfhrFMf/pN9jKv/bRSUrA/xik+TUVhNX0Zbjlvc/ekcCXBlhwFuV6voIDgux0Md8jxw3ejDWYFGEq7ti+iwOF9mlqJXs7+/NZ+7Ogui1bh2+cyNfoIlG1eN3euhg4PbhN/gvM/3VgOeEvUJkvo8Gxw24h/ockc//XQiKH1T84PQ0eyjB9FQ6QImfN7Br6tA2urr1LzT4d9XA3n8Trc+TwlZXvtf3P2srxnQ2bkOOG81twzNMhvg5jlXMKEbSjZne4MWrDjoaZ2W0MwsPOEVIFT4BD5ZzLRZ9v8wUypYkLkorejG6WTrdXc4sAfBUhmichNrW1wcyGgjg5e+ngjgvRvMtkQl9qEA0vX7fM515luya/gcNaMJcUrqwc1g1s29GE+IeMluE8AjaP+1ZjOyZgMCKr98Bo264Go8U7Knb50zswvqkUCMQ52A1UMloEhG4h+PLLORNdm5X6bueF65wDTGtBueiIWjbhnnpy7GCzljgkHbOOCaxTSQ7HsKm0+6za6+kZhtgrjLOLmNQkLEIr6qvI/d+6Vw6b1eWORwEqOu3IpCNqObZpiP4W2FnDtJBSYZxLk+LXvpGZr+cKFYaMMNPSYNyYwWx2HQEqFvgtkAz2sSIE187RrSNEVU9kySR3Y0MvvYDI2RvpZNny0266nk3JC8tA8nvc8zRHFGMHWE7PTsnvyoi3iesuURlpSdaYqtpAayGSyqjopHIlzsInSKUjuIiB14aZGeuE8qo1nsuJ/FYw/hXhaPfkGrvuXfyFpyPSfS+k1Msqd0a/5tLfXn7Q7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Liam R. Howlett <Liam.Howlett@oracle.com> [260207 12:37]:
> * Chris Mason <clm@meta.com> [260124 18:51]:
> > On Wed, 21 Jan 2026 11:49:46 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> > 
> > > Pass through the unmap_desc to free_pgtables() because it almost has
> > > everything necessary and is already on the stack.
> > > 
> > > Updates testing code as necessary.
> > > 
> > > No functional changes intended.
> > >
> > 
> > Hi everyone,
> > 
> > I'm running some more aggressive prompts through linux-next and this one was
> > flagged.  Apologies in advance if it's way off:
> > 
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c

...

> > > +	WARN_ON_ONCE(unmap->vma_end - 1 > unmap->pg_end - 1);
...

> #ifdef CONFIG_ARM_LPAE
> #define USER_PGTABLES_CEILING   TASK_SIZE
> #endif
> 

This does trigger on arm32 with ARM_LPAE set.

Dropping the warning is the easiest fix, but not the right fix.  The
code will execute fine, as the upper entries are not in the vma tree but
exist in the page tables.

I think the right thing to do is to reset the unmap desc vma limits to
only include the user pagetable range.  This would result in the same
numbers being used during exit_mmap() and during the unmap of the vma;
that path would still use 0 - ULONG_MAX.

Thanks,
Liam


