Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930A9CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07EA8E00C1; Wed, 29 Oct 2025 14:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF9A8E00B2; Wed, 29 Oct 2025 14:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7938E00C1; Wed, 29 Oct 2025 14:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C741C8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:03:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DA011A08A2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:03:08 +0000 (UTC)
X-FDA: 84051923256.22.5761161
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 06216180013
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:03:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y5WGNgA4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=csC998FL;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761760985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3o0f43ZFlj3ybzNiPNBxEzF3r1vIkzxRQRWlcoU5Zk=;
	b=hg2k6DzXVDZgsw56Doet/JedHPzI6bYY7oUDMYFujcNCpdTHA82NSADi0rEbRFbrNxyxvb
	rOURP6HWmDPMnAF4SzG7Hi20TV1d50wkwyGuwegybAvl2276SU8WeG7lDK5UtjETLcsAMT
	hBa7A2by+5d+5rtdKqBQ7lgNPazYBbk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y5WGNgA4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=csC998FL;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761760985; a=rsa-sha256;
	cv=pass;
	b=Bk5jp/y44DD2ZlTy9wiLoRSFn0KlbDs7APG+nSzDWVnEizGNX2eeAFX5u38sdKW1oThuyP
	nCXdcb0lkGx+TfP9Y6UUcyc7E1T3xDjFfxi/WNDtqvEYZ+3VbLliOnR3OJiftjvR0seaba
	6MArVtHxlRQCmij3UXXw4F85p/f81hA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TGgJB2012713;
	Wed, 29 Oct 2025 18:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=T3o0f43ZFlj3ybzNiP
	NBxEzF3r1vIkzxRQRWlcoU5Zk=; b=Y5WGNgA4Hm2Mnx0hofKBzv3JS0qNP0WTTR
	Tf9SniP/vAbjoFYTqR2lAM2UTnk4E5/eagz91YJoyIvi5Um2VKrT6Eadpl6SZcQG
	J/7hHIprza5kjlFqdBd8p0zZuuhTF0xb3EIAJ4uGrXcN6GyJfyiEdJT5Xf5EVP90
	urRllmp6pWh0h1aolpCAhBuQKEm4kZoc7Hx9YXxZbf4MhsD1XxL5nmOQ3PL9nrts
	UFQuQRxWy0mEXsFKucXmbLofSM3DaNIeZhYU6C7YKiGsY6Y8Zu5ofGdcewmyuOrT
	uLtzAESEaplgzEexgo/pnkQKrglJ1SEEdCTY56nQ7+AuGDMyDbdw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3b4w1w8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 18:02:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59THhfFU021173;
	Wed, 29 Oct 2025 18:02:57 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a359u7hpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 18:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gE87jXOjRddQiKyuNTjDg0QR6ZcLuV06XOa5n176L4+F/E8kfaB/VrBMYbhYeEMOiH7bkQZadFefTB7q5deqzpLUkyYoxIXhLizqyWef/fabtcG/7fwHdDjmGX4kwnP59Ia6Mi4bC4vxDBbd5zQ6jfbuL17BZlTanVFHUM6UKt7LhB6pzkv6D1NEVqElJd6EJR13SD+xv+Tl6oJ24a3GKoGXsj7yVStvHCKJbs2Ydnz1re+KxP7YZj3Ip0Kp/jaHjdV+bsc5QlwwHP7SyNcw+Raaxdr3AB6DAf33JqSLRqpVneXwKps0ejMBCaGN/cKP0ug5DZbY+shETt4C3gfUWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3o0f43ZFlj3ybzNiPNBxEzF3r1vIkzxRQRWlcoU5Zk=;
 b=iJlTFS6XVhypTWwnzAwrHk+bgjM+xKK38VIsJk1HY+aNAA9dUEkhbyr9gjhMFT5O0CKLzjRGQVrYkutj5XGOpwRK6MQZ9SEm+t2hvTAXhXGBJKkXysZejOshgZqhax35WON2vw+/kYLkk10KM8uUK6yl+jffF/Dx2V1ESi3ZNoHLZsZykP6l/BNdNvwd0S7zv4dP98XV31vVkaX80wIfmMcEoiyJDCM3nCuUg+qewPjk2N6cWgQtPb/8AbYA64rBqxwZ1M+dOBYwH3Tq0BsmaHg3vdhmUKn+0m54Qgx/TdRKBMvGWIRnFXcmvwEqPX/qR6YZ7LA117WAy/RrXsEv1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3o0f43ZFlj3ybzNiPNBxEzF3r1vIkzxRQRWlcoU5Zk=;
 b=csC998FLwkGqALp91B/i1pqjD/75jTH/ZIRrwZJsFkLXF+ph/tcDBDCA6SvB8jP0ifbRySjzO5k60VypCXDDkhWcnOpE9JrgJBlGUuTVB5VTcpY+7Fe1qd6vTHNq/rG5eeHnXpGOz4U405QPNpdaZQa9ci3DWwWqGgGwmtHia78=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 18:02:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 18:02:52 +0000
Date: Wed, 29 Oct 2025 18:02:50 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>, "Uschakow, Stanislav" <suschako@amazon.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "trix@redhat.com" <trix@redhat.com>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "muchun.song@linux.dev" <muchun.song@linux.dev>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
Message-ID: <0dabc80e-9c68-41be-b936-8c6e55582c79@lucifer.local>
References: <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
 <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
 <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
 <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
 <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
 <2bff49c4-6292-446b-9cd4-1563358fe3b4@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bff49c4-6292-446b-9cd4-1563358fe3b4@redhat.com>
X-ClientProxiedBy: LO4P123CA0301.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e185476-6ef4-4fde-018c-08de1715610f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I12/u/3dPkX86GidmAsQLMm2EgCC1dIl8mW+bCMJX0EmNM2iNcmhcyYHwMMq?=
 =?us-ascii?Q?2b+gOpicTT9JS/JkThIidJLHRTIz4AI7sFFRgYt9l4MnD8hqri9uf11nSgI3?=
 =?us-ascii?Q?SYFODsO4lT3oiHBrUccb4K3DMdXREUTB8BHMD77XBPFiYT0iCDkXCDpoJU9Z?=
 =?us-ascii?Q?4vUqFAdLdZZDUjZcR3T/HmYQ3u7zh4Rw96QzG6UCULxr1Tajw1+nAfFUK3dh?=
 =?us-ascii?Q?MKuU7KKTOs0W2OEDBycN161X/sVklbYGap+t5v5wAfx8VQzLejF2cmOWlpiG?=
 =?us-ascii?Q?1akMpOUt9hjxfMz4qjd4lTyBChJg2fkE/VTQ6g4PbJxUjlm5JB1j8VfHgDSi?=
 =?us-ascii?Q?jEOcEsirBxPKK5SEonD7FxLsgugbrD5FzYw8TtGKAQEs8VuccUmbyDtdidRx?=
 =?us-ascii?Q?V8VBhAWptUlcMrjs9TRkorELWuQrxjBap8GppJR9T1Kbrc0Hoii3vAFvDoXs?=
 =?us-ascii?Q?jaoTRKDk+SkCpyqg9ndg8zyG01onrj0zTbGSHp/IPWeRtAFeU4fY/3OUUfm8?=
 =?us-ascii?Q?8UfPBcKxbvDBM9NnG4OwCdH1dOEojIJ6PZ7dxv4UPq0WxKLLwKgWXyOMLW/L?=
 =?us-ascii?Q?8IKcGViXkm2Zy0oo2cBSOs+ir0J7K8IlodRntnC2oHzWb52nXQBCq3+B5KdL?=
 =?us-ascii?Q?u9QH8FvF8//0zwc1ix81V4wK/+/5wKH6C359r5rMQUSzU+zykxOFZdOXNVba?=
 =?us-ascii?Q?s8ySVL4VIoGsPn+Kp2SWONzI9/3/NA0RnXNmDE/xdEqL2eGUhXwo0eJ18fcJ?=
 =?us-ascii?Q?Pfufz7o6mwVZw9urL5yBEiatyaM3xbtB35c7YNQX1vJjX9PpCyUgdCiltVb2?=
 =?us-ascii?Q?nlyi5CMOvBAM2Wmp4czxPmFLtkb7RWD2gF7MIwePpp+PmYC1zG4VuSOYAiBw?=
 =?us-ascii?Q?6lcC0MRQSiGR6V5zpCKjtvZ4DLSLDtH+rJnAbaMWsn/J2fVKVS5Py27ktkbO?=
 =?us-ascii?Q?QvSa3PY5nATdyXtWr3tO2n7NWUE+ukXqR3AeEcdwsy8BdLB+uAHyWHEaa7su?=
 =?us-ascii?Q?4vbe17JTPVUkFwcDptiNUyD6PkPkJ1le2SHWPiFYjSNH09jqXE3zTxgms2we?=
 =?us-ascii?Q?67TtZsssLYhKRVFXu2T9+AJ1l11KeoKcY/0+GfUJ01GGHe86iKK9Beik8VmV?=
 =?us-ascii?Q?yNh0pOQ5DK2RnjGPPbM4q+pLa7lmM6fVTImG4WWGEMkArS3e/QQiXvXKL0LQ?=
 =?us-ascii?Q?Jg7YXIqezY0U8G31Zk3mtWQHH7gPIgCIJ5v7OOUWgA8e++6rUm55k1IHOCee?=
 =?us-ascii?Q?u/poEJhdiBwRGdSZtXboWaxZt1QgXh9q/hY1R+FULD4g62pui5OAQNr2PRtR?=
 =?us-ascii?Q?18M9Pu3tcLeFtoq+XsvuTH+BzO49rUo3MgRuxxzFy2+aW9pzMaz+5WYw9gIl?=
 =?us-ascii?Q?RdJCGz+9TUURL/r2PIJbfhfnohykKKJF/jl/57THHOxeN4DNBFNn1ynI61j+?=
 =?us-ascii?Q?3rFv0cerF4bZTA2+fXsisxXwaIGfY/in?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2gmL8sSapQJ15brXP84gN02qTIfmV9vny6sFElBtH+dS+d4wdH/FrtRXVpbg?=
 =?us-ascii?Q?kkyY5i4jYpz5fiKsdhObkZ9xXHrLi/qbdUVJR278JTN+61Ec+jYLEtOc+exz?=
 =?us-ascii?Q?GR67McDm+zjsWBXRZb7r5H9PUTvyqU4zvslxOzrYfhMlIrps2vlp0sg5gai8?=
 =?us-ascii?Q?ftze0Lyky4kl2bg7v6D6O9pcMi4C7iI+/XUpGekEcXpAzYkJYgYrw4703vXX?=
 =?us-ascii?Q?uiPK+uqU0/l5hVqz9RzRy2XSfofvvaFeJ0ZvavkrmgF0gwsI42I9Yukb/UI3?=
 =?us-ascii?Q?888R5DKrQjlkZfy5RyMHWngHwnZWbpbuorHAZ6AwkEqRKcwAKo1v3wt/mhwa?=
 =?us-ascii?Q?yE2vQVYABmFYeSen7rT8wGY0hhLzOLNsekL0r6/CGMBHvexzMph8RwHHYSdL?=
 =?us-ascii?Q?l/BcSBcztgiKq+Rtrua6ckdq6/0RODznyN4Y3a4uvJjTICM4IpOh1i82QWEH?=
 =?us-ascii?Q?h8ie4mqE19ZGlOpyW2l83ur3f7de5zkO+ghnFFubFQf8rxza6sQVE/lTrJxp?=
 =?us-ascii?Q?jSUACFDIIbBjgq215dBsMG6HStmNnHMvRqTwiNj6Z+ri21Sgw3OmoWe7YI1C?=
 =?us-ascii?Q?SpR7Jb6LSYM6/8XJvYN6vVeKAaVmIMN1BmW7BGcZkUPfQrU8xUElqkyl4iLb?=
 =?us-ascii?Q?w2mWz8oITf/Js0Jw+svX11L54zxHs05IffbzCJy7D6GQ7Zh8iEei79YVJPRo?=
 =?us-ascii?Q?l/SYminD6m44qZSp4BopzMz/WjzakKTf+RqqK1+4WGDoXEX9K/YDfacSlOUO?=
 =?us-ascii?Q?jnTxeiGCLMy4pvG6mHJG7F73MA4mHkXiTXJ5yH9vPZes7/CIlJbVdPFgA4Qb?=
 =?us-ascii?Q?Z4qs50cLhRTS8RRPtZSz42YVu04G6v3TkQhzV3HIWGhB2RwBm5KBKflTeYsR?=
 =?us-ascii?Q?d4GkqjOT78aqXtc091tw4yu57wUPP+NJ49qnoUmo47U0vbkxKNbH151XQngR?=
 =?us-ascii?Q?rA8pammwtJq3d+jkL2at9MQIliSVlGCFFcJ5marnxKeACR22tzq86KTHu7bp?=
 =?us-ascii?Q?EJvzVDXCmZULlapC4uMX6AKK9nPDk00tg4tGVS11h4Dp1bQDk/o5rzX0iN5l?=
 =?us-ascii?Q?XzZd5rk3kbOZ7nTAv7OCX+qx5dhI/6cHHb55bZhCksVXvtet2sHsHtTqJ3/0?=
 =?us-ascii?Q?MDiPEYcZf49UKFthSmUl7NKJCemm8UOQaHQjw58Z8Lg77aW3yIL6NeQpMqcO?=
 =?us-ascii?Q?8R1HYozxo3Vt0BzJxJ4UltrJQKAmZMqTIP3CQiiJ0ulzww4oJ9Y12EfJi4u7?=
 =?us-ascii?Q?Q45YPAv4/TpgxOstfEwtAjy1163vOWdyres3g2U9pkiLJAB/+mRlrutMX3hB?=
 =?us-ascii?Q?2o8vuCtZdlXIR7EBQVxA/xYApkWrq+P/6J2PJcaaG54qFesa7dh2tzl3b4FY?=
 =?us-ascii?Q?FKTQcOWnIGuB80hoTOHmZDZQy9eTJ9NXaV+40lheJSufKpJmEv35mXX8fapO?=
 =?us-ascii?Q?8pKTTkArgO5akKC6W8xA8GNDBh3PD1GsTuqrVa9XsuIWQGXd5bQbQLIr45YF?=
 =?us-ascii?Q?xjo7yuCuNM2nd5hu7vguu4Su2bIo64s0dABN/pEEnK7GciEUykiS+/oB4R60?=
 =?us-ascii?Q?JhonnPtVSOLhc/1wTC2N30Rf0wfeY537rm/LEGWwH3CI5xNkjDS2XEHpOUP/?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lQi0bj9TCPPkkrYJhz7FNCFRwleNV+c4hKYalbDH1j3f7OYFzImMZWTcikJxg8y+kIklnsxgnxnfw8f9ErsvKEldrL45ssVNEpwNhvB6JSJYOLXJPIJavGCrQD3oFMZXWWa9oiXpFccwa+fO7MB9dWHnvYnWv9VXfETGRYsdXhd9LQqSh0apQj/3Y+281E58Sp0EvIq2/T/6KhFIpHqEFMWF6RIFwnEKdNtHRWXItoQXoQGVF6Fvg3j7gzP+pSxaWM4WpegG4bH8j3WifHiQi7naXoeWw2mRhoXisGYUeC7hHljVv2hpsQCzobZ/YXTaMPcmNrPrAsq18aIxZEeA4aaQVwjSWJNX3Z6ZHfqujw+9PulvBZhomINeAhztHHObshaBM720s+rJvm0nX+xiaC1mHivL1qFDT7jHEoGtcHN8EcsfzeYtnsL2N+b7GE2MppNWZuR+98ilEUTlqEDTo9vswBK+AAzIAH2I0IenT/hRLKeAuAFyMbUKUE6XKvptB64WXuGNAeH/QDGZKvpO+5MpOqOFPjHQj8i/xxZwwcC8K4gSZoZnBNP1pWXoNSxPLm7IDuZzR7hfHJDOttgCm75kHZzku5DpzJJyf9xzSQA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e185476-6ef4-4fde-018c-08de1715610f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 18:02:52.3932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4lzJ/Xnk8EXM+OlzjT7ShCyi0q1h0DWCRg0QEqT7mL9qtvCuz8SqvcV1XwmmDTUaGyt1oweKML/wzHi/cz1H5kQx6Mtsg+YJqRKNNVLBg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=373
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2510290143
X-Authority-Analysis: v=2.4 cv=R9YO2NRX c=1 sm=1 tr=0 ts=690256d2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RrTQ1NEvnBZ2AI5r1LwA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDAyNiBTYWx0ZWRfX1bxkB0pjoyIa
 P6kar7t47v/u+NF16ZQ6cJvv1GN93/yzBfVYFfysFMilOFw/NQ/vCspE97DdRHuejSeBc9TyEka
 YGQZRlgyrMDcow9M41bsTJZ1wou9dRQa4qmzzAapALx+YXn6/1N3Fhe8ptFa9zSra0Wewk6gd9J
 jeB8yUmQEm8zBzET10XggdKngyPgQgFxua3Tnc5bFudSPlvRC5X1sQnhNhaIX1XfDgjcGJbthN4
 V+zN6Xmxw+VmTTEMR2ecpJOAx1chO8JvMWKzkTqSXJaBuugMeCQ+hCNNyg5uuqo110P6c1Myymm
 qG5hCN0BRGcuUlEvoJv4IlgXmsZA7o4aOd/xG1O3+kqrv7WBr1JR+0jwviUfjJTVc0HwUeVrWUp
 wyHLL3jpQe0/PrkrPorCadvrsK83i4vuLOIGR68vJmXDJ7OrQbM=
X-Proofpoint-ORIG-GUID: l-KXyxxOJUi1-wfwu5RA_OIiZP7CW6p6
X-Proofpoint-GUID: l-KXyxxOJUi1-wfwu5RA_OIiZP7CW6p6
X-Rspamd-Queue-Id: 06216180013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6opcmj1mfjiam1oixpunweknriiiypzk
X-HE-Tag: 1761760984-475370
X-HE-Meta: U2FsdGVkX19VpSu2XaIueKZvhJyghHQ5df2D6S3qvTngr4QgWr4b97H+TCijTRwsswBqE6YKZyZp9jFY64nN8uipxTY+oIm+EleHVcu8dGMjpOrfzct91ogUCF69EWNuAe3+wTt5ZjT9hNIRVUL+lzD2RoKOCWNedKoqqSp/nai8UWl05SOtC0VW6ohr3nDivPIM5FQG6V4kUd2AbQz93Q8FHPeqKw0E9iDe41E/0Or0Tf4sU+zN32kbqqsCqddudGGs3LRTZvptmgYscE2+GIoYOCW/KihRisfYdNZ32HgsZOPTGd/eZ3kZYKd1Bfb7CbniItGUeJSAj76At7SMwGy/N2K9/kn9U84kR5Qz/gpleMRLsOz9kK8lBcbVFGnQB+/Rx6lzVNtKynEl4E1DHVCSaeayErmELDdRVjrtNF10hKghObOkT11vVDEcDAf0oaKCFr+YyRgD8ICT7XsHpHr6J2dFaVB0Wiz6ABJyO2Y3jJQ+lNbXlvPVkHzk/A16gkhilEGbNqHvbDJ8Az2nXrG3upnurLtE+QSDAeFk6iabqzKsZBgm9E9+7zUv0/G5Um8pDpYA/hYZjVjVA7dNcof41MgrEvQKc1dtcdNBAxvsscHsGcfn5B8Ft91pg8AQtmjTW3/GB4KaTHXQMa8icbF63bSkesDghbMNzEdguRSq+4Z+6ufzD7f84QC34UOAy2ZddXYPE7AAU9j/9ctedFpM4F88NzC48ruzxmV8z5/ViPVDdft1lnudvn6GpTZo9xVQSpd53maR3OfOlU/NX4oppK40pDeBlF0ut+ycEf4rYPJRswD5xYNwdCw7IKqzgcmoXG3rdg84r2aWVuCmpxdngWt0GxpymV0rHl8tO76X2OcgIlM6/0KLa7O0eoD9wTe2jqvCaRNs9IHn+hmsnz1UzLo+o7kL1Qo/XN8JxmNpirMku3T3AxomC7L7mm/spgpyF81hFc+uZC78Em6
 Q3SQXCgb
 NyThJZprvEdRC5nAL1eoBZWDW4CW11Q6zMt0SXUKIF/fImg/rLIWxPRUDI4/ylABT5T+mIiUjRtlfZ1qArKfGJnnzlfM3b1Xn3W3immu8+ErlNK/jQ9Cy11OwMKCvMA/4b5WRCuQDug5Ff5mv/kA12jeyzK1fOdi3DdIGOMCz7Xuo+6H3C+MeWJSvSFdVlaMdamlv7/50CfdaHrwx3LLYCyoIGSOfBrfl5Ei0q1MZdyiB/azuQ/lvhzZp20HJyyBMxDz1fjpqbMnLX8WkHl8z61xCMQPWhoA3HawXFnlbHm2ygI0xrRI9142GiQsiM7Bgi4bYZt9JOZpnS0gLcdNEwaclntruwxOaxmy6ocUM8ZC/hAcmFx+kwd+GoydocbUII26HLpVbbbkpsSd82rfEN8u3tsKHB413z1IFcfr1bQhIEiDYO64IdKBrb65kMb9s92qVA9JEvo/QOAIhQFSc8BJPUbQTn2gV1GmMrDBbBlvoIPBS3r1IE4uqtugFtKA/4OcKFuSIB4js53HFnso+iWLRFDFNb4f+554ddSoBJ0FXKkcM4fTa4bQbqdrRtS8x/AVMTpmbKS8ysjr4ToMc/koKrXWLqtSJ0mqHCvJmq5KjSi9VCv1WRfUrYh3NbiohkIaBjDQEY244NbADOutjxI/t0UfbalFdlvBluMMyv/QreWi9YsnE1ViAFje4Q01ks9A25PiDYwXsS2kccI6AqHz1kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 05:19:54PM +0100, David Hildenbrand wrote:
> > > > > Why is a tlb_remove_table_sync_one() needed in huge_pmd_unshare()?
> > > >
> > > > Because nothing else on that path is guaranteed to send any IPIs
> > > > before the page table becomes reusable in another process.
> > >
> > > I feel that David's suggestion of just disallowing the use of shared page
> > > tables like this (I mean really does it actually come up that much?) is the
> > > right one then.
> >
> > Yeah, I also like that suggestion.
>
> I started hacking on this (only found a bit of time this week), and in
> essence, we'll be using the mmu_gather when unsharing to collect the pages
> and handle the TLB flushing etc.
>
> (TLB flushing in that hugetlb area is a mess)
>
> It almost looks like a cleanup.
>
> Having that said, it will take a bit longer to finish it and, of course, I
> first have to test it then to see if it even works.
>
> But it looks doable. :)

Ohhhh nice :)

I look forward to it!

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

