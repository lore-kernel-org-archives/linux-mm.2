Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0479DCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605BD8E001B; Wed, 15 Oct 2025 08:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD8B8E0002; Wed, 15 Oct 2025 08:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E3A8E001B; Wed, 15 Oct 2025 08:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32DF88E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:21:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCC221A013E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:21:05 +0000 (UTC)
X-FDA: 84000258090.13.40E5E15
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 48F59C0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:21:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mbXxrQvX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XVZ9nzbH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760530862; a=rsa-sha256;
	cv=pass;
	b=rKMpd+YISM3Z2jilUMj2pK4dI8QsN10Pn0+Pyjygr+KzdZGm78rMBJEX1b1lPonA5Q0yN2
	Aohc3fpOEWoOVxZIvfmCyT4AkhLGhwHUQPuGX8FNUax0gJ1XYv92HvJVDUToqademYuRAE
	rSpou70OGuH6ccnF0dd5sy5bCGGTST0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mbXxrQvX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XVZ9nzbH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760530862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wm97gM/7Awlv+OSjOnpIhi5dt5jTVq5V/M3z2MmUMIY=;
	b=mN21y2gxFF1miJQQx9uptlYZJcJNiTp3OGSGYrWW3RSiMFXE0MR9MwzS9Ex2C7YCArwC2C
	LfAu9vBst5JLVE+shNt3v9I0p9SWMErW+oJ/4BteRCD7br2GcQ8+WlrDgjDeM+1pwhBkvT
	CU3WpwtkV9ENPHMDsJiTqDev6jFuH0k=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59F9noX1010568;
	Wed, 15 Oct 2025 11:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Wm97gM/7Awlv+OSjOn
	pIhi5dt5jTVq5V/M3z2MmUMIY=; b=mbXxrQvXdOpsTxnqUf4zPKPIIL11ylt0u7
	reiZsVqXF3wmgM1T0pf69aX+enP16gxvQ2GXtv4kgbdAicfCr6Yr0J7u0y79ibJ/
	y7sLqVMlSaPajlxJgjoeXotopRYQXlRPfIGbzX7Gxn0DqBVBATwYS5cziVaKFvbG
	aEUUP1Ah+OUOBTItoheZ5S/0tLTHsxbQ0kXtgxHCF1E5yhNyjFIcFRTAm+sY4TVL
	GVEBqv9dxnvpYNcK1BY0VbxI1hWuZD0PX3RNH3Y9cGmZsO/eoWWGTjWMB5O8Wkbj
	rnd88RXsF4T9Wq9IX+yK3dRdYLvy0rDTvcsZfeL0fTwYQxT1/2TA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qfsrxay8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 11:20:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59F90Jfs017450;
	Wed, 15 Oct 2025 11:20:36 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp9yp19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 11:20:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W0YBmC7qX8C6wZoEDUUDiwiASmwiXNKomF3yHBJxVqwYHBjWqoHHkq3V5kRFCMr7SvmWx/PEnB+/tDzqy9aryS0pKmJADMSKg/BGiN7MaYOGWIqwH03T1IqxmccMNYY5GgF6yYqm2pGVgskV/OutzqRnxGmd81UyBVh6z+0K/UEPtKQF6SEUNZn8pBzQLNvJxzcOcFeMf+kiepY9BRDtXwifonDRor0SlyAB6LXjJZ7Rzcsk9kDV1R8HjHatMsHdi5sn/XW3aL5fHZJd1hm6zDLY4tf+cunwo06cfuxCnstpIb4NOus1nLJnSYBIPp9THxClDPizuUU9qiSHJuJd/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wm97gM/7Awlv+OSjOnpIhi5dt5jTVq5V/M3z2MmUMIY=;
 b=t4LGU8196TzY/z+paVMfzIgZas3YiVyJtGyANnZY40Wtjr5ghE7XGhkhgam1boxspKsHLEhS/l2+YHmYTyfYsjNxc5rQJRw7Ll0/F4y4E6lcGdNri5PLz2oPqRHGTRIn+90Gwwb9duY9IBGpIa3XFY4WGIiyNA0J4wlqoD00mhPS6QvnMUdHLDWnxyX59dYci9ja5Vc0sxTNnkYhuJTotVNarYcK2Wmu0CgvVmKh41GDJwhMc9OGV2+r5yYAuxKVzwa9wSWYQwS18PTgUsy9y87pZIRPDTjTIYDaQa+7ZgoPt3G78ZJzxVsrPV5t9ZJE8YlhOOHhhwtHyPFfTfJvWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wm97gM/7Awlv+OSjOnpIhi5dt5jTVq5V/M3z2MmUMIY=;
 b=XVZ9nzbH7ZgmGI3rDpMPdI3DtFEB7MNM5KwnYGZmDhusLDKJM008ApikPk0EGWbm/1Yzgwo8PfHmSLHxO0t67zd33DEZGx3MkgUj8+BJh5/eMRaVjgxZ3EntVgDlbDn7zeBmYkhJ3lwr9K5yi3mXSjkVVvXpTpp54mieg8Np+V8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Wed, 15 Oct
 2025 11:20:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.010; Wed, 15 Oct 2025
 11:20:33 +0000
Date: Wed, 15 Oct 2025 12:20:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Yin Fengwei <fengwei_yin@linux.alibaba.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge
 pmd
Message-ID: <d748bc6b-2aff-4cee-a233-008f4d2555fa@lucifer.local>
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-2-ying.huang@linux.alibaba.com>
 <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
 <87ldlcpnbx.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldlcpnbx.fsf@DESKTOP-5N7EMDA>
X-ClientProxiedBy: MM0P280CA0025.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: fb8de4b5-88e9-48f8-50f0-08de0bdcdb39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?56ifYVBLyioGjOAE6VgUmipE/yXENxXhG0jng+xlL4/kRPInfTgwm+NcQbRk?=
 =?us-ascii?Q?1EdTpa3OE/jH4FohFb09X77N5SYdqXTBrvYRvji5GKnQZWvEJdHWvIIVqObQ?=
 =?us-ascii?Q?27Z0kFL5z0o+UDc+bT9gMbpWjSDa261iL4jkOpfIJXuKY8KbbTi1VpSxtjDh?=
 =?us-ascii?Q?z146VLYHiQ1Cr4Wp3H5DbgsDy+k5zKo+aXE26VOuPaCrR9T7bsd3AjA860+k?=
 =?us-ascii?Q?OVrH/AJPvuxx8tmnn43m6YUNlpe0F5ddhnY5aA9U35iGAwilo74toerfXyX0?=
 =?us-ascii?Q?nxpitaOFaoxO2HZXBKDlD1wqmtv/LnzBDuzzqQt5OPJQjVoq8FeE04eyXG7r?=
 =?us-ascii?Q?0lj58/007MdXx1I/JlU4L6qrzSA8TpP1HtUus6IphO7tKluiJ+LfUAUBm0fA?=
 =?us-ascii?Q?v2eZkEy02ceCspNv3vP0QTZYzyRQzoJgyBIzAu60yvM8e/By+66F671M6yV7?=
 =?us-ascii?Q?fXqginARm+DGWMLaPfBk1JCeJHbyZKdE4twD6Ev/o39gzBIO6eTiGb7Nuqn2?=
 =?us-ascii?Q?+XSbYZFYPRcgcX94zJul8wLbal+ePHEuyLkp0qDjXcqH+MAWNVvjVWFZvN29?=
 =?us-ascii?Q?/34sNs599bRa3exJpVabY7ydHkzn2iPSzVlyXd8GTepKK7ijePuOpupfyXUj?=
 =?us-ascii?Q?ryEuNbQzaxlHWkFmVnEt+jEem9Q2kSGvSbSk2cEfBzVbYnZqd4JnCxMunetT?=
 =?us-ascii?Q?/gWz6QGqYJoXTfTCVaXJWyA2d1rsjl9Q1MZ85HhBlyB8tFGS0KJv1i4lDAux?=
 =?us-ascii?Q?eY6y0tl2nt6RryJ1DbKtCqqr8nVD8VuarbODRp5VEFKHu2+IT+MGDXX07LT+?=
 =?us-ascii?Q?pEQBR6EKAxBYhjrpVhlbuRF0obsRFIfDG5eTG1J/BrYjM6aliaouYVVVfwGf?=
 =?us-ascii?Q?vK1L8/JbySbLaLB8KBSpEckApaQEtOdhZg4MgHOg9hXGupKGGX/MbRubfpq5?=
 =?us-ascii?Q?WxW+BmmVElXgWeH2MSzYsybSzt4D/NrxTPOkb+mVixNWLueiUcswqOr5lt3O?=
 =?us-ascii?Q?Re9gOTXSIvvO+MO1ORghti8pyWXcHUc6XmZgkZnI4iE4h3wkeZ1GBRRUwbcU?=
 =?us-ascii?Q?blW/VkD1RkDK04i0XRp0tO2GfJM/zac5dHOH2dvgqM86+S8kKUuHOCjSW8XU?=
 =?us-ascii?Q?3PqPeimhge0avn3eNhKMsuwKZAeTgzCVBo2Tqblbo/+XlQOZXzbHyzM0Ek0e?=
 =?us-ascii?Q?+2XJaXpBzekRszCn/34hKunYtLB1zD/Q2pukPnJLESuT2Zfbs0CyChM4T48p?=
 =?us-ascii?Q?Ejas0TFpNdzaqBpXo/LxOPeD8bOeNOizsQTHz48J3d9jP1dc+DyMnNCunWyH?=
 =?us-ascii?Q?dv/BGplW4H3XCJ8k8/csvjxbnnNugsOKSY7a34sqSM+m5F6/AP6QV6b2bbB5?=
 =?us-ascii?Q?6IqWWVg1NvD8agTK+8yjWwO+M0DPpp3rZknVEWkTQZBUugKRjUuJNjy0C+ER?=
 =?us-ascii?Q?AlbqZ//laSQQRCRM/M9L4axwFwUb74dw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zrxWiJjq/tqOUT316HB8o+jMnwPJ0Wmq918myeWE08kmH8OereiING7/XsZb?=
 =?us-ascii?Q?0MZhW0ftfSdZ6Ne1TTqRXO6sHwvxrWyVk/6aWKv620cRpz+LHtJ3pry3sZpG?=
 =?us-ascii?Q?1xdE9QdznPrfE2vatEN4QVty1eDZEsXkv0ilvKlkYg+w3qoc5byqBe20Q8eB?=
 =?us-ascii?Q?oG+/VBpXc9gGioAKNryy0a0sb64roqWSLd1wsR/K78FPrC0ZDkkDAz/G1gky?=
 =?us-ascii?Q?czgtkh5YbLuvp3TsReci+ugDWAfxVLtwBYjNrIZBlnhlzp2Nn+3cKL8+D1C9?=
 =?us-ascii?Q?1bCe9GU4OCW10boEqvU1CuvVa8FrrqEyl8p1aAkkBaSVaUlQzRPAGdrebGR7?=
 =?us-ascii?Q?2Za5UR7FEWicRPIDQs5r3dS9PxhOw5wCA3UoF1ywX7A7Jb0+SEVgz/ZleQf3?=
 =?us-ascii?Q?F6jGpdEvfhskzfAmeOttDQrpX5FakeKSg3I2g9sv7t35C0NAiy/WNXIxBQ0w?=
 =?us-ascii?Q?V6PSJb2/Z5Imu5CpjGvoCahXk5yjmg0O5AWHWFjqqu8uFoG+KWCakyBpdF2+?=
 =?us-ascii?Q?B9CA95ee6znvzNcMeKraOClW1LzD86utpo4HJ8DaFQIlNazhgRJUbSUoDznq?=
 =?us-ascii?Q?F1caLToPi/A0weTcX1VrTwBFeoKEcYc793dWl0cz6iszVH3lcu51nVmzR10P?=
 =?us-ascii?Q?p29+W/tn3q0vDScm49lxO0q4SBaBTK826NciLeOMpYI2ZQ9wKMAQxT4GIKkf?=
 =?us-ascii?Q?vgd3XOa0HJDoY22nB2diA7UE8phPsHwPfDfMNsjmNudddV1vkvAodCN8gIAw?=
 =?us-ascii?Q?Ob3ndFVIaByGJmldRQu5TJtlRAz/Z3Oti39pVaXa/lCRKrR6VF1s0EE8yn5m?=
 =?us-ascii?Q?irX1LA+DoUJw3+em3ZXwGuZKxD8cGh87N7dq761CCWfX//7Yy+11e6fUbe7+?=
 =?us-ascii?Q?ZYcG3XP/6vUy2o4lZdqe8YRuh8fcr6llo+cgNINGbDwHde+sLWgmN7w5kO9v?=
 =?us-ascii?Q?82s9d56FcORThw6a2bmfPM3kywk0b6fZ33ejVvmgSojN+SHkufO8yAX68Xs2?=
 =?us-ascii?Q?Y48+WZv2OWyXMV+DrjfeZl/9zGthy4hvBhv5WEPMrw/NRR61dJQQ+eGYNs3u?=
 =?us-ascii?Q?qXKEPIGReXbzSo6d5mdX4hOhxyVp/Dhf7m7x6sW++SRZLhakhk62OZ7pfMcT?=
 =?us-ascii?Q?U5f9E9CDAlQEj5ot0KxU/efl7HcS6GqRy1rTz9PXb1qE/S5Ns1JWbwYM10Hn?=
 =?us-ascii?Q?o5EhT99bbA2pCbejqyz996aZH4lcFXedQrk4BirQ/F4vMHxrviGDCRGiXwLC?=
 =?us-ascii?Q?9CdbEwJi9JTo0zkVUxGnoaj4/2Bef0GjXMD6nP6YlDIHmG3urzFydgVuCIYV?=
 =?us-ascii?Q?lhPdY0pEh/i4JV3WVgM7QMIr6tSwBJAg7Rtw3LjnS+bHvuVyA8Ln91rg4gir?=
 =?us-ascii?Q?cODeezR+Y14juoyC9IE2XU96VmN181My5Ne3Ce/MzWdS8n0Uc81bGih8qgya?=
 =?us-ascii?Q?ekkqlePuVd+PSX4lXtAD6t3d8BiUxQEapFIsIWHA5n85LvNdXXvZogFV6DRl?=
 =?us-ascii?Q?p35c2qjXz7trl8lpkeeRGUORIiQegAwDFD0icB7XHT/BKw3PqXTONV0hqaFH?=
 =?us-ascii?Q?SO0OPYRg1eP68hfmsh54kemoVH0AkhKvezUiwE+Md/ZQ7ITkKwbDjhbyVe64?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HfkrEdwIZrLnPoFQA/Jb3wum3x665yjCNn15dRGrbDqMMn4ruNfHhutI+q9MMlrvXYZYmwrsk5HkbYTC3E8EkDypg/d17dMjkrn15dfXHVv+A5rEihkLl2fL0vry83vJQHnVbQTAdbR5wyGE1YvR5y8nRl4TxWDhXybo3qCR376EdRCGho14HWgXqXFQQTM8zf5VAUx81UkgFfKFbhUQNrsxYBZGG5PmaWNnEpXxAy7IOyYBz28BG+Mqu2EwmTA1Q7A6bxPAKTOqCORXk7edajE9cepEWcxoBoKk9K1aPfoiVyfRTTZT6ipcqLd4vXzdddFwcXWVTQ6MkGzdXWjNjMqkMnGuINoctCM7fJ3Uifco8z5HkvGdMYU5c/j2qWEzEwUb5SGEzGHWMfRD8XUndFB+f73f/7cmlZ/LEEYAIZUTmIF7N/YfQxCwr5nvE/VwiadnCm5/R1DMKjtS8I9fCSFLLHuFntX/ogZ8Ka0BSJyAayHNMqOZ+SwbZhVMghOXvwsBtSmPuWiWfYIk5O2w70Dpowi3nT9yqynTY3v9cslSvDendKATlcpaOnMf0PoN9LEz7sWreWw9sjLdyVRsLn24CPZW0+Ido8GKZ+nB/as=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb8de4b5-88e9-48f8-50f0-08de0bdcdb39
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 11:20:33.3753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwDJ3Xg5EXPtViumH5at9TSUJ9Ml1I8f6s9zB39R/mRoEA8OeTAQohgYxtnlpJtHpu200oG4q03OPJoup+YDW9KLcD6p2rKnGo4m087Dx48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510150087
X-Proofpoint-GUID: Y4E2k9on3TqEKYLWggZp939fZ00IOhFK
X-Authority-Analysis: v=2.4 cv=APfYzRIR c=1 sm=1 tr=0 ts=68ef8385 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=SRrdq9N9AAAA:8 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8
 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8 a=vzhER2c_AAAA:8
 a=PuvxfXWCAAAA:8 a=BTeA3XvPAAAA:8 a=i0EeH86SAAAA:8 a=JfrnYn6hAAAA:8
 a=37rDS-QxAAAA:8 a=_Z6KpjNAYm4aDk2_ecgA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=HkZW87K1Qel5hWWM3VKY:22 a=0YTRHmU2iG2pZC6F1fw2:22
 a=uAr15Ul7AJ1q7o2wzYQp:22 a=tafbbOV3vt1XuEhzTjGK:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=k1Nq6YrhK2t884LQW06G:22 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22
 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyMSBTYWx0ZWRfXxFUhJpYSzFdf
 2+oSW1yWPVeDqsyayqrmFG3ceB28i2dLD9x6HAYoYorpJozq3Ho0qrgYde1Ho0CA19rkAXRCUV3
 NMqT2fA+YHcd5nRlccHOCEM7Op/y+deg7K50T4UZCYGxtczaEecgpTm2tEJL+J8lMrXbdcbVVz7
 LY9syJrBza8K3WkYY6GU4DzzlT1G0DHxUPILYPb2ndF+/o9fSpafvgw6mMBdPKlYYJ99oJbXTU6
 NWooJVje2cPLitb7WQfSBKNswmT+XUDYYLs10OAtOjtmI4OF3voXPnV/v4tnnUCJ8oqBKNlF6l6
 yvHBoI4l2xG1fxmFeFQr76IF5Y+cUFNjxR/4rcrb2zTUha5IPPnIV+BcKDoz2cIaooA9rg59n+9
 r5K0jE+jnNZoppy2ZBYtDyGwMuTJDQ==
X-Proofpoint-ORIG-GUID: Y4E2k9on3TqEKYLWggZp939fZ00IOhFK
X-Rspam-User: 
X-Stat-Signature: 6qa5fonjog5xbw8te7sr9baokogiaa6p
X-Rspamd-Queue-Id: 48F59C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760530862-636001
X-HE-Meta: U2FsdGVkX18tok/4+IP6vUXzk98VSFauA5sSOLrb3M60JEBEes8uqwDboVj2O/eiRi2ba9Fc8gByEzFRhE7aUEd3+rVCa48eM58f5OFq32UP778I5eS0qk4iMbIHbpz2OUfqSJzyJiSDpwZEDNc4pxw8Fp9MS8N1J/PzUBQIeEXSTzIz3NoMWuLiDhEtBGXlbH/e+LNwnW69PQz+tMFmvvHJgZhE/0BYn7ChXAd0SRgIdLbya09nzgk/qot0B3pGb6kEEAR9xzIkBUZSlT+yVYsVMIEuOT+CB1Jz4qPJP11x7rjm1g027Mi/6SmkcrXDI+W5gx4GpAgbB1JBnOzcbMzwjjIf/jYgeWC17e0WXZh7Zm4DBizXJ8Yh/lFhT46+XwpZqiH4vkU0pkXT/U06U4fCwMiiEQ30QqK1z9SZpzvTJwVefoZkSHmwLR3lomwTOxuuiu5oPYBiDnf+BxuUSBimO8qZBKVkLTa/CJpeEtcZRq2+m+uHRo5/z9Wc4geVRiMVZCsmHEMVfhWgUcSRcfBBezlxOo2fUVUMlHbmqZPvZGPj1Ncn5j0BuhWrYQW6JwUjD1vHtPXGlr+7jzarN9SAbtrMJquJH+gFb7W2yFbUB0Y/dnWaHTrmvLmp7ifhezQByPzW3/8db8nsTjjcZ7F5BR5fEU3fli4leubXm6V2qsH8aCWMk2XTcfi61jaFmFS8X250rY1Qp5WWhxNd/28gU9HXsxbkf6Vlh5QEM/33gAN9zF+W7V+aHQfKITboR7DMAmRrAciaTjAOElZ19dK5ks8IGX/vAISpiWKG+C9b+rtNfwZGk11Sg8mMjZPvy/fkqxweT1eN+VnuOHAqFfklmOtWRSZZGpyQ2c6Lh2HZC9l1mVAdhdqrnhlpUx3UbldLIxuENJsaqYkALfa+fyhcworFMQJDII+UO/xYd9folO7vu8rt8RKR0q7ejWtwEn90LMo/d+rbjx7qJJf
 Vof1lRPr
 kaYdyPzE1VJQLwuOoBt5jyYZeSxkiTlTua7V/9kk7w61k668WRlO+60qP3az4pJQ5l/jNsvg8/Or+DvcDy9frt6kPk17Z21XzvVN1Uou8S8auHesOQBmvbvi4iPayzaBmyPSKCtR4LJowtTBba7MHAhT8U1R1kPJg2CdLH1LqauELzrk1FQMDRE+XiyYmZsVa7LDApGLkDix9LKNzxv5a3Ba+p7RdgjwgVX2I6hEfrqr6qgdAdEJNVVz2yj8yJ4WTXPzmalr0NwGbjfD2qFXffycQWFco0elOEMoT6nxajEZ7mWesMm/xXOZNqI3HNGUIaRZYDS0SOp1N2hv/ScfxCt78Ryqqfe6GmBwWWtcmU+TTXBxisQgx2rn4ZVlKpPwV5g5nbeTizQ1MmRWnwFA4Fc7pde6nxJdL1AM/NkKT1t/ISDM75CDsD1PVTduNDEAB1cB8Qj7eReIJzD+FUfdHrUZQ4Gx+mJ12fIazplNAq3YfnCY9oGWZ+Ilpe2eeqqPeSWu2TmJY58azbLbYBifUdK9adTuFYJ0HzgkC+W2FwmpEqTTvn7tZ2jQbDsdKUun13HcdzlWGMRhLFunXD4h1k+PpVOPdYCcyWPu18ZnZLC/pgxrbYw0UpE3iHKnKn6r6qR4PFmHiGb+22vY80wSYbvFuigopywr3+D89bjlaFc7JANzIiOcGm3XCkAiQAbg9xpp/RJ2ZzraqGiba+9HGV+V+hmXebM8rsZg/e424/anreAyTU1o0HOu95a6ox7IGxAB0dm9m2x+C3sE0/xtKWBbQX/p1lRbUzvny+kqGEIG2CnQd8M95ytE2Pe05h6mipwa/oqCBXViX15fdDX/LAwgLKOuWwzCnxomXH8VwzEhg2qMjiIJHIaJCeIOS/DgL3PTDGfSlRtyepQGtchMKVsWBYNX77FyY0QcJLiGgYaqoVO50pXvDDgnnmH/wFDoFuL8ddA9KZlBv4/Sv8/PPuGgBCs/r
 sbfBdOqG
 zDFiIxSXZzhF+ES0apB47NY5SlfhT6v/+0N2o82zcmHVHeHzQKFxJ5abptsZdeTBM21fNWsCV8rmIbwk0244JGdw45DEBMghPxtWhdZK11hmk+yZQGDP8kpoQr01aYAwwrIV9KGMiGnVyALI+iqh7fYsThHUrHtFJmhgOQPc1nY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 04:43:14PM +0800, Huang, Ying wrote:
> Hi, Lorenzo,
>
> Thanks for comments!
>
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:
>
> > On Mon, Oct 13, 2025 at 05:20:37PM +0800, Huang Ying wrote:
> >> In the current kernel, there is spurious fault fixing support for pte,
> >> but not for huge pmd because no architectures need it. But in the
> >> next patch in the series, we will change the write protection fault
> >> handling logic on arm64, so that some stale huge pmd entries may
> >> remain in the TLB. These entries need to be flushed via the huge pmd
> >> spurious fault fixing mechanism.
> >>
> >> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> >
> > Right now the PTE level spurious fault handling is dealt with in
> > handle_pte_fault() when ptep_set_access_flags() returns false.
> >
> > Now you're updating touch_pmd() which is invoked by follow_huge_pmd() and
> > huge_pmd_set_accessed().
> >
> > 1 - Why are you not adding handling to GUP?
> >
> > 2 - Is this the correct level of abstraction? It's really not obvious but
> >     huge_pmd_set_accessed() is invoked by __handle_mm_fault() on a non-WP,
> >     non-NUMA hint huge page fault where a page table entry already exists
> >     but we are faulting anyway (e.g. non-present or read-only writable).
> >
> > You don't mention any of this in the commit message, which you need to do
> > and really need to explain how spurious faults can arise, why you can only
> > do this at the point of abstraction you do (if you are unable to put it in
> > actual fault handing-code), and you need to add a bunch more comments to
> > explain this.
>
> This patch adds the spurious PMD page fault fixing based on the spurious
> PTE page fault fixing.  So, I assumed that the spurious page fault
> fixing has been documented already.  But you are right, nothing prevents
> us from improving it further.  Let's try to do that.

I wouldn't make any kind of assumption like this in the kernel :) sadly our
documentation is often incomplete.

>
> The page faults may be spurious because of the racy access to the page
> table.  For example, a non-populated virtual page is accessed on 2 CPUs
> simultaneously, thus the page faults are triggered on both CPUs.
> However, it's possible that one CPU (say CPU A) cannot find the reason
> for the page fault if the other CPU (say CPU B) has changed the page
> table before the PTE is checked on CPU A.  Most of the time, the
> spurious page faults can be ignored safely.  However, if the page fault
> is for the write access, it's possible that a stale read-only TLB entry
> exists in the local CPU and needs to be flushed on some architectures.
> This is called the spurious page fault fixing.
>
> The spurious page fault fixing only makes sense during page fault
> handling, so we don't need to do it for GUP.  In fact, I plan to avoid
> it in all GUP paths in another followup patch.

OK this is great, let's put it all in the kdoc for the new shared spurious
faulting function! :) and additionally add it to the commit message.

>
> As for where to put the spurious PMD page fault fixing code, because
> it's THP related code, I thought that we should put it in huge_memory.c,
> so I implemented it in huge_pmd_set_accessed().  If we follow the design
> of the spurious PTE page fault fixing, we can call the unified
> implementation in __handle_mm_fault() after huge_pmd_set_accessed()
> reports nothing has been changed.

Ah ok great this is a better place for it for sure, thanks!

>
> > Otherwise this just ends up being a lot of open-coded + confusing 'you have
> > to go look it up/just know' type stuff that we have too much of in mm :)
> >
> > So please update commit message/comments, confirm whether this is the
> > correct level of abstraction, and address other comments below, thanks!
> >
> >> Cc: Catalin Marinas <catalin.marinas@arm.com>
> >> Cc: Will Deacon <will@kernel.org>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> Cc: Ryan Roberts <ryan.roberts@arm.com>
> >> Cc: Yang Shi <yang@os.amperecomputing.com>
> >> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
> >> Cc: Dev Jain <dev.jain@arm.com>
> >> Cc: Barry Song <baohua@kernel.org>
> >> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> >> Cc: Yicong Yang <yangyicong@hisilicon.com>
> >> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> >> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> >> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: linux-mm@kvack.org
> >> ---
> >>  include/linux/pgtable.h |  4 ++++
> >>  mm/huge_memory.c        | 22 +++++++++++++++++-----
> >>  mm/internal.h           |  4 ++--
> >>  3 files changed, 23 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >> index 32e8457ad535..341622ec80e4 100644
> >> --- a/include/linux/pgtable.h
> >> +++ b/include/linux/pgtable.h
> >> @@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
> >>  #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
> >>  #endif
> >>
> >> +#ifndef flush_tlb_fix_spurious_fault_pmd
> >> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, ptep) do { } while (0)
> >> +#endif
> >
> > flush_tlb_fix_spurious_fault(), when the arch doesn't declare it, defaults to
> > flush_tlb_page() - why do we just do nothing in this case here?
>
> Because all architectures do nothing for the spurious PMD page fault
> fixing until the [2/2] of this series.  Where, we make it necessary to
> flush the local TLB for spurious PMD page fault fixing on arm64
> architecture.
>
> If we follow the design of flush_tlb_fix_spurious_fault(), we need to
> change all architecture implementation to do nothing in this patch to
> keep the current behavior.  I don't think that it's a good idea.  Do
> you agree?

Yeah probably we should keep the same behaviour as before, which is
obviously, prior to this series, we did nothing.

I guess in the PTE case we _always_ want to flush the TLB, whereas in the
PMD case we otherwise don't have any need to at the point at which the
spurious flush is performed.

But from your explanation above re: the stale TLB entry this _only_ needs
to be done for architectures which might encounter this problem rather than
needing a TLB flush in general.

Given we're generalising the code and one case always flushes the TLB and
the other doesn't maybe it's worth putting a comment in the generalised
function mentioning this?

>
> >> +
> >>  /*
> >>   * When walking page tables, get the address of the next boundary,
> >>   * or the end address of the range if that comes earlier.  Although no
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 1b81680b4225..8533457c52b7 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -1641,17 +1641,22 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
> >>  EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
> >>  #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> >>
> >> -void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
> >> -	       pmd_t *pmd, bool write)
> >> +/* Returns whether the PMD entry is changed */
> >
> > Could we have a kernel doc description here?
>
> Sure.

Thanks!

>
> >> +int touch_pmd(struct vm_area_struct *vma, unsigned long addr,
> >
> > It's 2025 can we use bool please :)
>
> Sure.

Thanks!

>
> >> +	      pmd_t *pmd, bool write)
> >>  {
> >> +	int changed;
> >>  	pmd_t _pmd;
> >
> > While we're here can we rename this horrible parameter name to e.g. entry? We're
> > significantly altering this function anyway so it isn't much more
>
> Sure.

Thanks!

>
> >>
> >>  	_pmd = pmd_mkyoung(*pmd);
> >>  	if (write)
> >>  		_pmd = pmd_mkdirty(_pmd);
> >> -	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
> >> -				  pmd, _pmd, write))
> >> +	changed = pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
> >> +					pmd, _pmd, write);
> >> +	if (changed)
> >>  		update_mmu_cache_pmd(vma, addr, pmd);
> >
> > We can make this simpler, e.g.:
> >
> > 	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
> > 				  pmd, entry, write)) {
> > 		update_mmu_cache_pmd(vma, addr, pmd);
> > 		return true;
> > 	}
> >
> > 	return false;
>
> No problem.  As long as David is OK with this.

Sure I don't think he'd have an issue with it but he can raise it if so :)

Thanks!

>
> >> +
> >> +	return changed;
> >>  }
> >>
> >>  int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> >> @@ -1849,7 +1854,14 @@ void huge_pmd_set_accessed(struct vm_fault *vmf)
> >>  	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
> >>  		goto unlock;
> >>
> >> -	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
> >> +	if (!touch_pmd(vmf->vma, vmf->address, vmf->pmd, write)) {
> >> +		/* See corresponding comments in handle_pte_fault(). */
> >
> > What are the 'corresponding' comments? How can a reader of this code know what
> > they are? This isn't a very helpful comment. Also those comments might be
> > moved in future...
> >
> > Presumably it's:
> >
> > 		/* Skip spurious TLB flush for retried page fault */
> > 		if (vmf->flags & FAULT_FLAG_TRIED)
> > 			goto unlock;
> > 		/*
> > 		 * This is needed only for protection faults but the arch code
> > 		 * is not yet telling us if this is a protection fault or not.
> > 		 * This still avoids useless tlb flushes for .text page faults
> > 		 * with threads.
> > 		 */
> > 		if (vmf->flags & FAULT_FLAG_WRITE)
> > 			flush_tlb_fix_spurious_fault(vmf->vma, vmf->address,
> > 						     vmf->pte);
> >
> >
> > So I don't see why it's so egregious to have the equivalent here, or actually
> > ideally to abstract the code entirely.
> >
> > In commit b22cc9a9c7ff ("mm/rmap: convert "enum rmap_level" to "enum
> > pgtable_level"") David introduced:
> >
> > 	enum pgtable_level {
> > 		PGTABLE_LEVEL_PTE = 0,
> > 		PGTABLE_LEVEL_PMD,
> > 		PGTABLE_LEVEL_PUD,
> > 		PGTABLE_LEVEL_P4D,
> > 		PGTABLE_LEVEL_PGD,
> > 	};
> >
> > Which allows for sensible abstraction.
>
> Sure.  Based on your discussion with David on this, I will add a
> function to do the spurious page fault fixing for the PTE and PMD fault.

Thanks!

>
> >> +		if (vmf->flags & FAULT_FLAG_TRIED)
> >> +			goto unlock;
> >> +		if (vmf->flags & FAULT_FLAG_WRITE)
> >> +			flush_tlb_fix_spurious_fault_pmd(vmf->vma, vmf->address,
> >> +							 vmf->pmd);
> >> +	}
> >>
> >>  unlock:
> >>  	spin_unlock(vmf->ptl);
> >> diff --git a/mm/internal.h b/mm/internal.h
> >> index 1561fc2ff5b8..8b58ab00a7cd 100644
> >> --- a/mm/internal.h
> >> +++ b/mm/internal.h
> >> @@ -1402,8 +1402,8 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
> >>   */
> >>  void touch_pud(struct vm_area_struct *vma, unsigned long addr,
> >>  	       pud_t *pud, bool write);
> >> -void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
> >> -	       pmd_t *pmd, bool write);
> >> +int touch_pmd(struct vm_area_struct *vma, unsigned long addr,
> >> +	      pmd_t *pmd, bool write);
> >>
> >>  /*
> >>   * Parses a string with mem suffixes into its order. Useful to parse kernel
> >> --
> >> 2.39.5
> >>
>
> ---
> Best Regards,
> Huang, Ying

Cheers, Lorenzo

