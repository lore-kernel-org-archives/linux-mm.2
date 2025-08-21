Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A21CA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A69D8E0012; Thu, 21 Aug 2025 12:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255C98E0001; Thu, 21 Aug 2025 12:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6588E0012; Thu, 21 Aug 2025 12:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA68C8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:55:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A423D590FC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:55:27 +0000 (UTC)
X-FDA: 83801365494.19.437423A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4FC9F14000C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:55:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="NtJVU/Gz";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qz9nT2rZ;
	spf=temperror (imf23.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755795324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/lDadDS2YiqEWhF5YjzG8xdirXxNELpudJ8nf9iJd8=;
	b=UTvftV9kM/AP+2m8dcFzIMdlzCGfappqQJZzD949ZWWt1q+X2VnYGjuI5gSdk/45K7WAap
	UP9amw7ZZitD/NKQvnv6IjKLnL/8UHgq+UCnOcF5dDBLDWdGNI5gBC0Wqx0cdjszHSisdf
	+FCA4PjJoL07dOLp0XYEaL21tJCNqJs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="NtJVU/Gz";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qz9nT2rZ;
	spf=temperror (imf23.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755795324; a=rsa-sha256;
	cv=pass;
	b=Nankv0FHxJ+1c6XWzlQEkG4hmnTp2XvMPjon7HtO/ImUqlZWAjUWT6mVicXILaUtoPk/uw
	N8tQ5VqipG/yQ28MUVxLFl/V24fxfgv5oNbzNP/9SYgvj4LLXy795l5ltDLiM+2Tu9Vbr0
	IBAMRuybagGzMYvKkqe6LTX1z9v9sWs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LG0xal023180;
	Thu, 21 Aug 2025 16:55:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9/lDadDS2YiqEWhF5Y
	jzG8xdirXxNELpudJ8nf9iJd8=; b=NtJVU/GzukTA7OpnwbT8aVO8gQ6P0OP7Nm
	sWR4gyoopNcGWhCuXvCoXLXtgWA5aEg49kIH4tcwdznWzvSrf5vzDbRIlcu54Sba
	bRTv5+rdphRbNimWysr0B5bIgMXvBU1b1FElijOBilcpPGRporxz2vKG2viM75bS
	sTBYS14+I8/jrinV6w5f2vc5iuz0vbpw/CHEiEM18tQhTCw0uo284/Oip4pcfGGG
	7IolIt5bsfYgjYPx34YYaIxwfjfm1A+dOlrdeEnqI8dgHsRxUeprPtuVDWq3pCsX
	j6DRDhm8YArA/1VLlxEZJebKVqrR3c74E21irl2dSf5lwRqcdU8Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqv3y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 16:55:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LFmL2f039447;
	Thu, 21 Aug 2025 16:55:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3sba60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 16:55:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SKcroiaNZ3Ru9SYGyryXtT0AFDzic8OzpL+uMQHIQY4S1jVYr+psyx5c5LCAJwjAIX4agzeIWMoNDqAzc1UyU8gboKn3atMc0LwFDAdjiPyGVscdhyK2VnXZucJ/qYWKNlDyQB0z2ahVm+JdbZRe92jPoLyGs4cNDnjHD5WTLs4wKY9yJrY9s1yN3ToPD8OWdI0wO3S4zL46r3DQaQEyAZVp5bvPebNLA3l7t3PCtnmGmRUI/2ixz2G0RQvwRvG73zHPfogAO+01ayS0Zy4/5gKBtlcchNaUCFga4NJXRFwBa+DbkUwJGZ3B2YNLcwXF3x3I/PRW08MkbGvnmI0SWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/lDadDS2YiqEWhF5YjzG8xdirXxNELpudJ8nf9iJd8=;
 b=WCJJJeV3w9fqfrf2E03KgCdOBwo7Q2UuJ4+YiRJvUimakaFxawgsklWo/rSaP+ndG/VUYifkvp/XeQpUXeRv8UtQoVR2uoGWW2SAGFZaCV/UneYBrh+pezUp+c+kYuWZLj6wC7i8AM9OUa4zB4VyqnHpQVB1H9HzmYoFMMjKRM91GbpmG9/XksADfk9zitXAqOtUiPyLZ3c+2O3BvzyPlbcMuR2FYSkN/pWexDlfn6p4GZjk8E3q6y+wejBmieJSW3NXru0w3BNoA9U0Qac1rMOuV95k2GuA/WSg8a8uzmGBa5nvODRa1h0d485qw4BTWqCieTuZ6Kkhe3ia8aYJcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/lDadDS2YiqEWhF5YjzG8xdirXxNELpudJ8nf9iJd8=;
 b=qz9nT2rZzLqF3sTuhuuCphjT+UbYnGRTsM8RLjApOTRKd75Kg3G7CFABJa6wVZrd8Z4Lru2GT9VT1QIaM6eXjyBPBcf3PJuJnemSZ7TD+B28f6eXyB/z88jWI13bsqD0G/f/ykH7ySn+xI8hmJtnVZL3ZrDifaV6m8Z1bGgisLE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB5885.namprd10.prod.outlook.com (2603:10b6:806:234::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 21 Aug
 2025 16:54:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 16:54:58 +0000
Date: Thu, 21 Aug 2025 17:54:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Message-ID: <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0066.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:8::9)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB5885:EE_
X-MS-Office365-Filtering-Correlation-Id: 4933de5c-5065-4ef6-fef0-08dde0d3767f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KIFq/IFgDRpWn6sKAtKAvfjF++8ScVYv4wRH5uxdjmtlfHgOUrRSUrUO5Cuz?=
 =?us-ascii?Q?IU5tZc4Vw8JWiiAOh9hy3LprQZ0P/Ui+VQ0QeirPH579QLHnCAr5WG9u/vW3?=
 =?us-ascii?Q?0dUHD5ydjfrdv0dB7Wf/N7G5DRDC0JLkp3rL9aJNndLBHbdaFgXnBrPk0BNo?=
 =?us-ascii?Q?R9SvE8XO6r605w/K+QVtGYDz9q4+Ce/gfswVtL18K8Qw0QJzWsTkaSPzbG3I?=
 =?us-ascii?Q?OYVwlacYE9O6EL4OWLTFLXZVPLEPCA+XJ/YfjNOHyoRM2LMEGDiBbJQyqMpQ?=
 =?us-ascii?Q?VrHkE3dD8PAIq9uwIJZoROdwi/0flONu/Wvj9oCBu2i8woZlus7yoSGGKZAc?=
 =?us-ascii?Q?1WFm6Bri/XkUUHav0ZXgELUrsCJ6woEDq+Be/tGF9fMgJIzsaFi86/SqUWMf?=
 =?us-ascii?Q?9jTTMAUdGIEJICjEd3VbsUaMnXDfD9LxDEGe6Fng0gsypQ+H7c6GRXhzkxsi?=
 =?us-ascii?Q?nct23xobsk3ZJbqDdqTz8d6oD8vXETCORgk8uXqk+H3IcFKShY47WP6wjvIn?=
 =?us-ascii?Q?Kbgxi4MVY6N3fUzYEscsySz5oOCxImcTIvwN8cA3TpnlLe2j+Mu6+K4PwZQZ?=
 =?us-ascii?Q?o5eRyu/kbzgDsDmkCEu021NTQZUErOFlxueF7IZgj6MZbnKaCYmZEfM++Txl?=
 =?us-ascii?Q?EUpwfsJ5hnlwKL8TY+IBuLx+qx628sIGMldZjavIKgORuitStl+Is7mRaR/2?=
 =?us-ascii?Q?rpi2oeSLUERE1OuM5aKpdIpTgwdtWGG7rnTDA7z0XZJk6bBfWL4U55hK2RlW?=
 =?us-ascii?Q?HU2qpXtT76Sn/OHKWdoBB3J/7laXaFsptMZkb6LPiSUIMeQtWNdtQM/PmQEL?=
 =?us-ascii?Q?xlQA8GM+VlIVpmqwebrDpFc37OgKCJ3NNoMqCILZ+f4VzNZ5Tokg3RdWLdwQ?=
 =?us-ascii?Q?UCwywPCRTnLViNXHwrteWVWC8L53h01Yc6tPOtNVw8lXn3/Mjeq/SYG15cTZ?=
 =?us-ascii?Q?nQ0qoG2rd96co+uE4LWegSie1Rvj/aoUbtx/JS1/fExiyuCbsMEEXmO1Vh56?=
 =?us-ascii?Q?lDdDoxoyIVvUXwlvba272M8WfFYuHYkBySf1VYgQkm1QyVJWoEAwdBzMO9It?=
 =?us-ascii?Q?IWpuDpPZDlCE54BIdX9Jj3LB19K216sg+aXrEhfRbu4a07XHdSZUqjSSv49j?=
 =?us-ascii?Q?e6T7dFxRyCa92//nsRQiv21t2epfeF48S89XF2Ll1KSk0+uHq0/7X7jrMixR?=
 =?us-ascii?Q?AVJEDJPltGKALKavKWR9sO+mrfFRI/q9vF1rWXIi8azhYYk0qf7oayR+AMjx?=
 =?us-ascii?Q?ttAyQvHoiEfxBNFzqQdjfkHL+IbzNvxyX7A4Mdvk3ITU+lKYd4c4hBhiKCCw?=
 =?us-ascii?Q?mrSUoe4dBf5O68tRodpRdMMh+PiKp1Hy5uskj6Iq008Jl9Ax0yjB1s23Eaq9?=
 =?us-ascii?Q?ZACOtsZ1zdUlScFoIh2fIkPQlT0XJFG8xK6f/okooLcxgWDPIPlx5ckVwSr9?=
 =?us-ascii?Q?4WDqYGkBm7g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3VEN1P6wrIL4DZEs3d0yccrDgUSRN+IioiXZ2d4ue3LRVO3CEEOi72u1T4PS?=
 =?us-ascii?Q?jLXB7V7sWdGR5wFxyqan7kRtUPrKPwSWQjAh+r3WYjgPhJNxRCh3BNbTVdWu?=
 =?us-ascii?Q?17D4mFPMfN3QPK/FhdRR2aqW2f07+jSGXaZhgF0YhRuSEzmJEjp1oNXqRRaU?=
 =?us-ascii?Q?DIhgP3UZ7ZHY5K7VqblGO0mbpXmKJqFiA1geetNxJZS6ku9laMKSHSQjCjP+?=
 =?us-ascii?Q?J1+q7qKFD0CayRBBGptdfZlSZhY3+PlY3O8azWX60TiuRi1DnID0i9jrdK+M?=
 =?us-ascii?Q?r7R/eeciPjq4o3Eq71pik1MyLWHYpw+UyFK2QefmYa5dV3/i/jKRZL4VsSKU?=
 =?us-ascii?Q?4Dej0GZVGqV9cDnokraRMSZnz4detTR0jkBQAoJgpQFSJPNiSShPLw22I5s/?=
 =?us-ascii?Q?C3RhfGqObeiMk9a+JcytpXakBvkomHbNoXR+PcrY37OooSHylIIYAqxT2S71?=
 =?us-ascii?Q?8PYAS0of5QJpoM8xWFB6kZ8sYbqM2jhuasj29Jw+pnOwVOY/svGjDVjifWBC?=
 =?us-ascii?Q?EXGKhJgeXf+rFtYmsJQ4KHwau/2NyQ6uVXocG5AS79toLDSjQrnhQTuBar0Y?=
 =?us-ascii?Q?irEI3UFalbFQah79cDqmDOZCE2PoBNXzcPh1j9OxPpMiZy16ovBDlFnBDxmW?=
 =?us-ascii?Q?uAdo/JbKUymqDzFf5hSTZmB/CFh5u3Oh58J3HZtmBDKzDTUrVvYt5NhVovPh?=
 =?us-ascii?Q?IyhNieJtnCYUVj/+l2L0Ojf1opQm6AgGjokkGruQ4/QREpOvOxDMEYDoNw+X?=
 =?us-ascii?Q?uHINF69mW6UBSeGhAYZUT9SWvvMmh058sQGsPW8rxqBFcg5v3EyQkPe9p/10?=
 =?us-ascii?Q?+41PPGfRQAjdzu7dUN7nVR+xONRC3xsE/aC1OCtNeFHQb5zsXPSsXjp0YJMK?=
 =?us-ascii?Q?hcco9u7Eb3FHKIQeXUYiwsOOnFpNMhjDfXP5x/9fhV488iqTOYcxPV/QCAP4?=
 =?us-ascii?Q?Dp+/OGOg8FJMUbIZpuhBv/IcCsK3g4Y9CM4vz5YdAQShpzvK22/R89AOsWbZ?=
 =?us-ascii?Q?P3Hfw+F8Tu/+1AC7PHYuP/mlmeA3f8l69TafHDkDhDJ2tYW5LQlRBFevMWiC?=
 =?us-ascii?Q?jv/ZzcCxMfbrstzM63XLWN8OL8tdx0k7FLu7skpJQ6RY7QzACsDWO7AReGyZ?=
 =?us-ascii?Q?WWrdHmT/PGgwniDH35gesJ8jwfpcPj5XRQyb2vlrz94gHAlfkAFNLIrayMjE?=
 =?us-ascii?Q?9krDWErp7BVr4N2dAjsSWY/2utN055B7eE7VesLjFR1x5e7YmFHs0CWx4Yql?=
 =?us-ascii?Q?//9/JskQDKN1S5gi8cT4cH/RdqWyMTqGgdto+E9pLkE6cJYcyG9sclDclwBg?=
 =?us-ascii?Q?OfgSgXfMsAd6NZqrANpTaKxFoH6GTglhGdN3w5Fn1b4W+Ht1A5rW/cw+aMh1?=
 =?us-ascii?Q?RJ7vplMemt2JPIsokrBYKikLVc7NydxlQhzw4jMZ7uCpTBXfBFfT/GAzRSSV?=
 =?us-ascii?Q?P/jM5HfGO+9jmfrYWkyoHKQ0JNlbMjmeY8PF7Q2JGpg4n3gpdIKLlr85dSQE?=
 =?us-ascii?Q?haCs4XiCQRsvfkTbh7swgNhecPPDytxZeB5OkS3To2dNpRb/Xo/jcOrmOwuD?=
 =?us-ascii?Q?rlszTWLVXnQf5lWpV0Dfs+5uctAdPOqBvRNfnz7bqJ+tgwlNo9rvNFgj1Cu/?=
 =?us-ascii?Q?EA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6PB8d1UgXYeoNiDZMTVA0KB05nY+HiOY90ugdAwykIR4gzd25iVMtZHfkdHfIGc12XYpk2D+9aLPFz4fcpDvBseHl07ggPbOWBQtgQsfZZqLvYoTHoKIR7hNadLW7NlDE2TScrdLnShZ0yf588fsK67xrfwQdtSWJCMdm/uTtm5obyuq/8sBaGaESb0E/vSNJJgu36N355aJCHGEVTHFoZe1h0HJ1/IBxx99PTnk6nhd5uRwTDe4MiDVTqrO+8dqkuxuJZFyeiSHbFsykVFxxQ0uWTOSnhSOYJbUcTtwZhT9B4hR3Kqi7yVwo/8mAdVcMrteVG7OlkEe/fLX+UWx7IhVvcNI625k+rMfndg3qv0Fs5zvcQHnQE9gcFmolbYP9HKIbbhKGBgp6zhMvWF0991Li/O2ADvVWzmwj14fq0StSZalj8DYGZjRJfYGHDHnJg/2B5TMucN1dCecYHI8RlklPViGQT8tA8v64WMsDwTJiQT3bAp3X6R8QWi1dn4ZdebSf+7DEls19MR3G5x8AfoGT1yIWfuWHQxMq4oWTej5wTdGLiSGG2Uva09B8auDKoffPGCuSdZCbdPAhHQOS5bakv8iet+9qf1OPhJh2Es=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4933de5c-5065-4ef6-fef0-08dde0d3767f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 16:54:58.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrjsK/QaYQ/HbF5zmjEfWEf3EIr2EFDfUMKD10DiQdb8v0cWZ8vYW3IP7hnGX2j75VDg/9LlskjB99H2YIbugvkjFaekISqczRQj30HGT9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5885
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXwqEqwwpwjErO
 MGrIpfwKHzL6MYB0bFLD2M0S9g95+mGl2iz5a+krmwWt0S7CuTTou9rKeVNCKtZkSg1Vs4ZFjxN
 Ur7fYcKkUclkvBnfcYMpZcc67MdinbFhzSD4yO6sYcvGMtmyV8Tnmu0Xs0+pBxWqWO+D4hWTNTC
 KB1cAIwBa+JHpsCEqN21e2nsTdgH6e4WU76Ya7dj5zgHNqDEn/ngOu6tf4WMKGDtweXG5iIA3bn
 O67tLU/V1orPtCLFHr1P9wMSbQ45rfGoKhOq854B6kqt4oucvDi9R+7hZG8cu3mofLyGE6t/DHJ
 H9/WM9xWQhlDQGXtHuYU+boFzlsATkxdD1gfDsyQriEGWneV8Vkv2Z/8tzMUSyIxxX2PmV8Mu5Y
 eZyY3LLN8JtX5iBnuEjYmhfa14bDdA==
X-Proofpoint-ORIG-GUID: bnm5UmgrpGbq3JZyktfS8PS4_OK-wA35
X-Proofpoint-GUID: bnm5UmgrpGbq3JZyktfS8PS4_OK-wA35
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a74f67 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=srA03ta9SO5_IzUH8ZIA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 4FC9F14000C
X-Rspam-User: 
X-Stat-Signature: 8uqoo39spahjdumcnyopynzufa59zrnr
X-Rspamd-Server: rspam09
X-HE-Tag: 1755795324-514937
X-HE-Meta: U2FsdGVkX1/FSbo1WCKoh4eNglVRmzoghRQ3wsFin5TmXNffslespqOe6vRk67BX33y5qDuURELYIy8HAIQz+C/85HMzq+MNEbLMGu+yo6QcqvoXutSjdy8uIkEB6Flzk5SS/nYxs2cNkWntr6M5jBbk9ih7XGYASQWjqHTKd7UwcVuqLGuo0zbNY0BIrv4WRlW3HGOWQwOcZ0F55zmB82m+PNuVpReBxuLMxc8iEmBC9oaStJDCJQpWnSYRDE7Nn73e1l+LmRpOtlSACgp8d351xBN0+H73U9Akmn+n5sCr1CNmJNelI2dfBtZqlzWLqfjMUTKq61Ete03QBLvzSad3TLaO+ixWQ0Cd0tp3bJYydzANQskkGVH3Sosicy0dD9EPn6cqtAU2peTBjWyaTnQej2JgFRLGiVwcxUd7MUY8PK2czl/1ORTtj+5RVwR2QVEMPQZeqAvC4cqAJcIRf9ZqpmLoszUa5gLX4cCOOU569xiyofMy+LV3HPrucU5CPjwCQ3HueGjeXbmUZNy71HjQf5YpSpxXG28AsscOosXkszh3bycytCixsx8ftEzG+21pM/6q49YdldRUpbT781LhPL8PxUFnY+mmgKxBY7HuWr2xz0WUU/AV4MiWTQx0Jc9FcZW7rmni2G7YWQ7i1WzoNHtHAvc09Ozwkojw2G4PTN3bdkuzz738RRwhYulC/e/Wg5V4EGvUGELfclZnpm5CAJ+vH8bX34wZk/Cau9xNiQ4RSruy6V5BUyAPBmb6yPvhbZoc38aKhopOJdEPRA6aZmE7NbJDPv20177NExaXVrLCTq3uTUieQJfPuR66XfOACaJYI+bTtDk7impqQpnpOGYh5GNTO3SgJayLT8/biHFYC1k+WZnEQ9BfaCs696xwrjMYgMrXrdOFCyafP8PY29txrcZN3QfhZg2Wmj+T//1A6ApPlUfb20xVKpoDLNu2VT+hQMWbtj8riRc
 Ppozt/A0
 ATjvkSYdOmnhmhfsw0fdz3mpJabAa36lFgiZqRqhLgu96U00BHO1fgg8ZOtmRrLR/bBZarpFEi3VII+4eXc6sDt40WqDpFZTg2lY8KetnIrx4UUzn4BbkdSunCV3peT5TfSYiKbNWT3Uhxj14ppPVU2RXTAVWtRjjbXTzQ6NzGVhgiXHtjjhf7sgMy9PgKTDUw4YssQCm3LfF/a2ZfOujfBi8yVDwWoM8+qvavKxOOBJjQI3tCerjan/aIKhRJ+AMxoywlmUheSBRZkSDxdxqGHYL4Ta/ILuM+FreV8n4nzI8m1u9JZKO8TyRqlNWVCGaC11tvbAf1ka6FhHwOn/mhbJk4gjhj33NNULSy8uG+nU0y8jyiIi8GDmNEWneAW+0oWAfEX9mSjbJ+/DLjGZoTK0AFARofYoOmjVyHUF0msDvQ7xxtx6zbLZz0x3mQrnliRTtXDaoJjd5e1Sm9312iUP/IDRslV18pgKltEHWLeBuqzlRZA1VNEKaTe6sTn87AbE38kKp3+MC9CbzG8ymQO3Sczpmf0mvm+Wm/4VLak6BN5HNcKgFSbUZwUxc5QNGaAEKwRvJKdPR8O2/ov/0gz0rrMIA4iMeyiDCjTDK0ZAyAgT16i+u+HMqHR+frS1Nvi2OxQkH8olQZV6JV8OsMXfWKn3po9/Z/sxTeRpH3AqjnjtIK6Ix4Opkwm2QgShbCS59wmNs4l3I/jblDSl2HyWCwKnNHzM7m8lvYKOPrFbAHGoZlQrDNNXsBSOOL58XIiZ5piGn/F8DD9LHh2/FfJFt0gse0cgIHCm6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:46:18AM -0600, Nico Pache wrote:
> > > > > Thanks and I"ll have a look, but this series is unmergeable with a broken
> > > > > default in
> > > > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio
> > > > > sorry.
> > > > >
> > > > > We need to have a new tunable as far as I can tell. I also find the use of
> > > > > this PMD-specific value as an arbitrary way of expressing a ratio pretty
> > > > > gross.
> > > > The first thing that comes to mind is that we can pin max_ptes_none to
> > > > 255 if it exceeds 255. It's worth noting that the issue occurs only
> > > > for adjacently enabled mTHP sizes.
> >
> > No! Presumably the default of 511 (for PMDs with 512 entries) is set for a
> > reason, arbitrarily changing this to suit a specific case seems crazy no?
> We wouldn't be changing it for PMD collapse, just for the new
> behavior. At 511, no mTHP collapses would ever occur anyways, unless
> you have 2MB disabled and other mTHP sizes enabled. Technically at 511
> only the highest enabled order always gets collapsed.
>
> Ive also argued in the past that 511 is a terrible default for
> anything other than thp.enabled=always, but that's a whole other can
> of worms we dont need to discuss now.
>
> with this cap of 255, the PMD scan/collapse would work as intended,
> then in mTHP collapses we would never introduce this undesired
> behavior. We've discussed before that this would be a hard problem to
> solve without introducing some expensive way of tracking what has
> already been through a collapse, and that doesnt even consider what
> happens if things change or are unmapped, and rescanning that section
> would be helpful. So having a strictly enforced limit of 255 actually
> seems like a good idea to me, as it completely avoids the undesired
> behavior and does not require the admins to be aware of such an issue.
>
> Another thought similar to what (IIRC) Dev has mentioned before, if we
> have max_ptes_none > 255 then we only consider collapses to the
> largest enabled order, that way no creep to the largest enabled order
> would occur in the first place, and we would get there straight away.
>
> To me one of these two solutions seem sane in the context of what we
> are dealing with.
> >
> > > >
> > > > ie)
> > > > if order!=HPAGE_PMD_ORDER && khugepaged_max_ptes_none > 255
> > > >       temp_max_ptes_none = 255;
> > > Oh and my second point, introducing a new tunable to control mTHP
> > > collapse may become exceedingly complex from a tuning and code
> > > management standpoint.
> >
> > Umm right now you hve a ratio expressed in PTES per mTHP * ((PTEs per PMD) /
> > PMD) 'except please don't set to the usual default when using mTHP' and it's
> > currently default-broken.
> >
> > I'm really not sure how that is simpler than a seprate tunable that can be
> > expressed as a ratio (e.g. percentage) that actually makes some kind of sense?
> I agree that the current tunable wasn't designed for this, but we
> tried to come up with something that leverages the tunable we have to
> avoid new tunables and added complexity.
> >
> > And we can make anything workable from a code management point of view by
> > refactoring/developing appropriately.
> What happens if max_ptes_none = 0 and the ratio is 50% - 1 pte
> (ideally the max number)? seems like we would be saying we want no new
> none pages, but also to allow new none pages. To me that seems equally
> broken and more confusing than just taking a scale of the current
> number (now with a cap).
>
>

The one thing we absolutely cannot have is a default that causes this
'creeping' behaviour. This feels like shipping something that is broken and
alluding to it in the documentation.

I spoke to David off-list and he gave some insight into this and perhaps
some reasonable means of avoiding an additional tunable.

I don't want to rehash what he said as I think it's more productive for him
to reply when he has time but broadly I think how we handle this needs
careful consideration.

To me it's clear that some sense of ratio is just immediately very very
confusing, but then again this interface is already confusing, as with much
of THP.

Anyway I'll let David respond here so we don't loop around before he has a
chance to add his input.

Cheers, Lorenzo

