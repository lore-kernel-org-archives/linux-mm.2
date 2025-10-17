Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D823CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EBA8E0074; Fri, 17 Oct 2025 05:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30388E0016; Fri, 17 Oct 2025 05:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A829F8E0074; Fri, 17 Oct 2025 05:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF7B8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:19:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3153D1405B5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:19:35 +0000 (UTC)
X-FDA: 84007058310.04.5C45897
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id CF2331A000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:19:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nHptGOdm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nE+1TcXR;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXSaUAqwVvOCZN/HYs94EEOrHhXl4D05bJ+E6lpO7lg=;
	b=eUjHTJyXN6Hov0fmfEx7nuFET1U5N1okj3RO1Ah7qYquN2ranN3Aj3nuWvpGih9QRrf9Ac
	TNDMyO6Rs8iCs2hNVD2BpaZ89e2pVhkAM6/YBv+HlGrOEbBpmLeqmXYeEQQQU+Ad92Im4a
	uOIsGcTWklIYjzmqHi9JUvXmjY5W6ps=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nHptGOdm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nE+1TcXR;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760692771; a=rsa-sha256;
	cv=pass;
	b=iffMN3fjf7qNfl7vXf8Xx1bCtWahYJCQtgHl7XllquzIawTQYxrQ9g6owT9YIAMYKXz7D0
	2oWDK110GJWmvjQiCTiFI/E1e2vT68K6jo+1brcPJ20FpP20vabrWi5hzeUbObv03Ck1bW
	NkDYqN3XyB0185TcTIbKWN/JFXJhozY=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uiFd029529;
	Fri, 17 Oct 2025 09:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dXSaUAqwVvOCZN/HYs
	94EEOrHhXl4D05bJ+E6lpO7lg=; b=nHptGOdm1n3yBplJVhn+YKaIkewenPFg37
	J55bP8UJpHnSqCExXv38v2B/uLZLVjLmBKts9sDQI6RBBMo1hiDgIpRbxKRNZxma
	5vXPf7DOtXShXU4CAUO3542gJepZjYX7bBXjbW28ArNHABhOrZ802pOidGeYfl5M
	983mCITZD0K8ww4AoQeSRzeOh8gnFBujuE2CE1/91TBldJ6Wo/IMLDO/PU8FD7Rg
	NpOdoSMbiIwyhL+3Snf5wjJza0zQPD8Syk4KlPxPQmLOhLr1ZQWqisb8PkAlzMYr
	rg0VwIzkpVmNnLUbxve74ut+wo9HhPDwe1uRWYlFZw8V6baRhdlw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdncahyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:19:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H6uCa2013756;
	Fri, 17 Oct 2025 09:19:17 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012064.outbound.protection.outlook.com [40.107.209.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpck5qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:19:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B1iNA+PWWQsEwQYPRIRLU7IfPdQTLcAqNqaL/NuvhfwrIZJIg8eKQN4zOt3v19km50elGyog3c88+3Qdi0txyILGP65bGfGfoiwT1HMuUoaS0OT4hQEYfnqR6I7KenXt7xbmElRORYJ6bcCuGBFgkc8K0qkGPsvDp4yPwgrQZ2B/XS5rukcKh66BCb3xaDWXGZ1QCZiZLuYdeDX83Kece9mgf//yFMcX4tn57k9dP+AiaqQ0pwcO98BoqWqpZgoC9c61tyn2SzpdIqS2CsulH/1WqJLgghjXR4j4gRZ+ZUI3MAMzZREz+JWsFtpk9r8DpONMng9VWQtT4Y6G+Vb/1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXSaUAqwVvOCZN/HYs94EEOrHhXl4D05bJ+E6lpO7lg=;
 b=GmR67pBQIIj3N9cuPq4KQx51yYrnGzZSYkPzSJ8Xc+nuuqn93a97MxS+1iC/FJ39+vJJ2FLTWPAd1/rO2cvsTO/kJAIWFOBB58w22JH0lX3jVlDut4fM4ZqRvrSKmJcwEobiQPny0H//IrDoEg6TtAvI8wZGDkdTKWFpVpPCMvzk13c6lmKXC67n76c+9repKz3Cm819O88iiaaaQ0QEPdVK4ajQlNoNRsWORTrvvbnksz5Ai80jH+KsByxGYnsT762dvbIGJVf8dlQ4HRKmEub1aIUqDLAdKlvkjRHMk2NbR56NmJXv60qSkfq19LMr2dkz0wwVxZoNCSKRv65bGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXSaUAqwVvOCZN/HYs94EEOrHhXl4D05bJ+E6lpO7lg=;
 b=nE+1TcXRwUx/FJzeUxXnKVCcZ0Zo5iHQTHszEosGhiexdneKz8EopFGkSujOikg+2tM4LOyx0lNEibpEb2O1YYgscPcZyvPXIS53RnxRpuo3urzrkb74y1A512Yr+PHX5+ibSBCjwwYmoKdhFIsN3VKmGSU3P+6R8V5nkIhXh5A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8544.namprd10.prod.outlook.com (2603:10b6:208:56d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 09:19:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:19:12 +0000
Date: Fri, 17 Oct 2025 10:19:10 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
        kernel@pankajraghav.com,
        syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
        mcgrof@kernel.org, nao.horiguchi@gmail.com,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Wei Yang <richard.weiyang@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <24b02541-d880-4a48-a11a-23e3e0427f54@lucifer.local>
References: <20251017013630.139907-1-ziy@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017013630.139907-1-ziy@nvidia.com>
X-ClientProxiedBy: LO2P123CA0049.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad52640-a0ce-42c5-df9c-08de0d5e3c72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zEh4t5ifKsejOqMlpU/3O3zCoxaaD2BJnPIVsq39XcZQiZyzptU4hp27okLu?=
 =?us-ascii?Q?jOMYTMfzMgjog2nYmLeCOajmCbwYt9/9CxKLjCqale6Sv/JHFePpIQiy8Iww?=
 =?us-ascii?Q?4qBH+UOMPcg6AOtppW4MUxPlbr5uBnS93E5mfg25BieczLQBKdX3Pf/DWbdW?=
 =?us-ascii?Q?Ry0aiFy2LktAmltWK4ZmK7iHuV6pjIBQbjj4RHh5IO9XqhrGij2qBiD8zegQ?=
 =?us-ascii?Q?pdXZoglv9buqbT8bodURsGwFp8iFf+f5BTzL9ALjRSr4RIwTUpBJtQN9jmTf?=
 =?us-ascii?Q?yJglE4T8UIih8wWz1P7uiXUKgKrEmxx4v81BYwh/sUslj+zMUESPhBic+ZP2?=
 =?us-ascii?Q?7O1BE38NPREfuJzPqRXvRYYP3BT7+zLNqWzNPp/ficp+a1qEaJ7XiatCDpJ3?=
 =?us-ascii?Q?6wFDezLwnr/KtCDmLxK4veGr4lugZB94CgKB2bL8fIXCuzMGkRwdQ4I45+ZW?=
 =?us-ascii?Q?OiN4DJBg1UyshxuMhkD++3tgGJUZIOuNLR982huYakQEMKI2esI56pKkRkvq?=
 =?us-ascii?Q?QXcOadwohCwFAoLsKd6DqJAeMnFaA6DhJB+YYUqcRA4ikZx9jIqhUXfFWHJC?=
 =?us-ascii?Q?nvWkhElAfN4Zx8k9V7qIFDYl/ubXE9lKddI8LsMr1u3X3AHsegXa9cJY5OrX?=
 =?us-ascii?Q?wXzm42+1Gus+TgyLvACe8yGefTx2dhyNZ5vvTs4o28iJEYgbISboVo72Zpc1?=
 =?us-ascii?Q?fadyQjSrzijM9dLRcqRwtEIoEcoAHnCeGod5/yL4Dvh4lCiDroe0YEWHmFxs?=
 =?us-ascii?Q?bywI/bVL5SaG3ieU5cmLDiqTVvK8qWgiqmUwZHJ0Cn6x5++Ap6rc0XqoSa5g?=
 =?us-ascii?Q?SSTMo5w6YinEqNl9kU3YT2SK/GsnluKxZZ+MSmhIDj5z0SyObSoKQgmYmVoW?=
 =?us-ascii?Q?l530X53rnAZI/sf5o3cUOl+J4eIYWAEtXVHzzbti2Vog6Mss3pM6SQJZQE1O?=
 =?us-ascii?Q?OveTRTeR7yZTF0KIkWpzJjZvCgwj4FnyWMKVRIEP3mwoxNniyjcyA84mjnD/?=
 =?us-ascii?Q?TDth3FI2U+J0aQJCHm5dkiSvZxKmzTM63TnrCKfhIc2WF2wYkQ8FTlLG884L?=
 =?us-ascii?Q?P3vlY301V41e8JeRNFEhWD1cQIZkfepvBWc9Mlg7rbi+vE/T6Bx8dpTLFsNE?=
 =?us-ascii?Q?+fsCcYnMe6Z7qiS/bSq7px/UO94xZJg7EJEmeJD6UxJ8a4gWGhPySRUKuvHN?=
 =?us-ascii?Q?2xocbD9W289YDA7B9v7APyyXm/pb80CJj0kGXZRSZTP8GWZl1IMlTKLGBrxT?=
 =?us-ascii?Q?yxfVHY74pIBNNnp0Kvynjl/wvIO9ipZJakYw6EZqJ/EGV1BjFkNNsRrCdXxI?=
 =?us-ascii?Q?B1jjhISLqIZOvAWFbqXeibyh6jM3zdfeDDp8Y5jIcaRtcjfXrJHcnLnERn9D?=
 =?us-ascii?Q?PyJYJmFrHqlU05eRxEGCdpfz0TgAJrAHaV0Txjj64qCpSq6skbHu1kaIxAmS?=
 =?us-ascii?Q?T9JAV/pXvhw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9PDN13Ks+KUtePMugLw3EpsgOvBu0sTEIb4KofYDQ/17skgsf9KVTz4RfrWr?=
 =?us-ascii?Q?bAPy3BkMTJrVWLNDXK+NSs2oRsUO1h7RcMP2xWW7MHvVo+0mUzQSSTE83IRS?=
 =?us-ascii?Q?Ia5fUpzKLhxYGRCoSQt14fwlSbfAZ3946uwSP4s4P6rlXRt/YvCtqVZzGo5h?=
 =?us-ascii?Q?s/gVx7RzBUusKSlwXGYGO3k8ijDcPtulRn0caS3GzNZp/qZJxqEP4/Mwacv8?=
 =?us-ascii?Q?bO0Agy79IyLvp4phDMAIf2CXyoREKd5JATsSrNHdbQHd706+nlJVcd5zHE3a?=
 =?us-ascii?Q?xBoAG3NUuV2wUwDDNY0tAOBylhVriiWAGIMlOzoSta9icP9hB2acHfYddHe0?=
 =?us-ascii?Q?Mu8cGGJV0vy8SvCKN+SxZo8e2p563UzfXg+m0N+5Me99JB7MJnVH4WWYLaGd?=
 =?us-ascii?Q?BS5BEF+CJtvxqu5bqyZFpXEQLHJMbeAmonBeJ+2wKXO1JZ4QMg8ugyd8eaKd?=
 =?us-ascii?Q?cvYHv/66BC/FO5NFJA8o/XTQ4xeVfHBHFcJtChU/gY/DBy70BcHWnGB5LaLk?=
 =?us-ascii?Q?wVHOfNpoZRkw/x9a8d+Jf8OQj8aBgfzGIMFRulFeKlKSpi7Z/AUa+wpgyz7y?=
 =?us-ascii?Q?SNnZPD23jT5U1r9gPNgW1GV9ic1SXtwS9FK238sOcOMsQvAuR7hfVWkZXjuT?=
 =?us-ascii?Q?RmBfA8gIo6GRbcZP8Bi5ta4wKVXh3Ym6p2RhDt6ZZATqj0OnkzVBIgFVNKSw?=
 =?us-ascii?Q?o87lzKr+hPaiObHjhzdO3l+9kF+8Cn6YFCVTo2CW2GwmZ5JWNnm0yU/h6vUU?=
 =?us-ascii?Q?SDEiIJUs7iPPs36DU6Syo/kS3DzSKndq+WcmU3qYr/ejO+qGberRAAGdyY5B?=
 =?us-ascii?Q?wAIOQpa4O6kspZVvGseT++J1dETQ3NMONfFfdswtglwmD/lXGOH1Qz57gNoX?=
 =?us-ascii?Q?M6MUejWdgH1cTYhON/k5HRhKzBAwUhqWuubmpi3M+HE0/LHiRQzqKDhwpFmR?=
 =?us-ascii?Q?+kz5DQEvCDIL33dylG29jKV0XozPsAgbNV/qLr59O21qSDpRO7vlKjTC0eKv?=
 =?us-ascii?Q?3GCNjQhROZOxkv49KC68U//8UnJTzJxOGkXN8aZXLAR5RYDakcNW3Dag/6rU?=
 =?us-ascii?Q?xT32lSOO6Duq0NBnTHmzCOeN+dHeMHGbkqEtAqexnrIGAKxPy4mTLh6q/svT?=
 =?us-ascii?Q?n9iSA9mlsgSs3AALY4M1qIuTi0nS8yPwewk4IlM6fhBG4GgGzfXcljYSMQ0c?=
 =?us-ascii?Q?nB9l65qWPYnEensD5421jGGe4nk2G21g/QIWMg2q+8yV60dVPYpv9GQyP4DU?=
 =?us-ascii?Q?6MPjDqQneaMxkq8cxULxK5keQEnU04nkEb8Gk4nvHOEuNnNUnbYEvlntQv2F?=
 =?us-ascii?Q?AKxM/Fa2KBoQSDVyDSbCTEI6Jd/5Lsd0FMz6HXduFD6584B3UEc5PVds+j+k?=
 =?us-ascii?Q?R3n0XJ2+uBB5cK3VZL20lzfLXo7jyNc5udhgCrVrGU/p8k2kAfbX0lhWf7HR?=
 =?us-ascii?Q?HKdP591czEYa8VxxVMNiEPKCcpkCjFYNBHF7Z7+wXUWD2SjbmdR8MlcnQyMc?=
 =?us-ascii?Q?nDm93PRfxddVGCTQHAGYJWq7NadfOuW3fy6Su+/U8RkAZlrvdLAnSpibJcHj?=
 =?us-ascii?Q?i3dVib02pVQNXldN3PRWOy2jKZGkTxdiYVvfSpmkICvsSAzlHNt0mKMFKfHO?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	alOsTC20sXH6Ls6bptZEtJp4aeWsrXeUxaRxHJhsLzQ/jeJJYrkhtuZj/FXJQz0+gjUHp0o1FyhCChcTMzYsVQZEFeOfNu4IzWrlHZ/2Gvx20wLvbndBckgMd5LWNXaIoXGSkD2l5sEZOtrtIfqWeI6mMp1sjqKlIt4wFjdJQBkahlFx6wlgPS8IEOmCfn/ym52lfGMMMtB3C+cxHqBh3GEPOQLAVx6Nksj3Jz9LZ58KS4z5V4iszOAVQtxcTgyFrOHMS9MwGrX5HH7nTb3JNPavDx8qB3sHzBfFrt3tp6ECugPdrAoy+ugzbgvPivy0a6v7OGHP4MY01jYnFNy3kGfG4jgqzJP+fgdIMwaiEoVg+rMIGX6qduy63UFjVke07a3coh18XAB2qA4wUPC0+V0CSdv8uhO4KRRoEaUunHrDc1PXdjWtvYUPXFj0zYEqCw8bj56216FljQlfYKEBZR977505dY0vkZgTWScgCMLC0rZ5tVgbLCD85iazb8yXDiz2CWS8Kiw2uDTAvnbJtpA6Z80iuz8T1Py9ZF/wSKe2XhBDIijuKU1mNmeaI69PSY4wUxT9sm7AoFZeuki9yOMCSXDqR7Gyibt5+1vIU2M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad52640-a0ce-42c5-df9c-08de0d5e3c72
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:19:12.6049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17PPW5zxHTZZmq5RdVByIaQZCaNXX7FyQTPmy/Ib8a2sCLOMgeYCUhuuLbZnPVGFGe+8k2+NcaRy3AB8/8rlrpvXnj3Ucea0b1pJVFeL7tA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfX1tkRL4UYAHTb
 lxPlvxxlHlNj0899s7kkA59jpTLPkj+PyFtBj/L/jpm1YHTzRojcw1XfT7Vvgfsm6iRom05hT4L
 A72M/UEMUDh8c+I27ZmKx/jFkJZ/Gt46GC2pfXd1Sth+I5/0cP6tKVRULEELHvkJroKui27pvQZ
 79gCkT4lh5/vToFgfb1gNiIOhg6Qs2VarWvlYfW1/UtWFOVotcLfBvkw1/dfXekUfIXRXUI26y7
 Pnq2wpmSbN1qevESGKdDc/d6XLXiQfptMTnv3F+NGApIp4CJkxkwmxs+shWt94/uuNOjT6jAz/Z
 o9tCIZmzvBCfmYpEqIKBuMGdHdUIz29gXzfuPkdvLRTAQosPBt6dZodh6DnlG6k/g9X5pYDuwAM
 mJyHD/Jejqe8+9QiHrnc5Q/coQnTEK5SjvTEHOtklEl/lpPBMYY=
X-Proofpoint-GUID: aDrtvw17ra3VmW6kGSqq-smHycsu9Qz0
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68f20a15 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=Ikd4Dj_1AAAA:8 a=hSkVLCK3AAAA:8
 a=yPCof4ZbAAAA:8 a=hD80L64hAAAA:8 a=pGLkceISAAAA:8 a=445Qu6hnVZvfol2FXmQA:9
 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: aDrtvw17ra3VmW6kGSqq-smHycsu9Qz0
X-Rspamd-Queue-Id: CF2331A000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nqdyypg4wwmnfpo9hm4r6ctqkfm1efo6
X-HE-Tag: 1760692771-934207
X-HE-Meta: U2FsdGVkX18UGraPQpAxTXZhKvALDjNTF4X2s6N+jM9QKYsgnSEZBSGKkXH+xAgZG6Ozn4yJXe31wZCi/vAkdtHu6IYgeAfzgv0533h7Aicw37KwWKtQktgPvF64E+g0JXCnybibjZTB2+oFqAMPBkdP3yWas9AATiDEMTCTqrc/3JexZJHPlxuF605Au3HmGvtnUC93qihELfUhK6hzkhMim9ckP+cazDDxmP07NIv3sTHSOeozcpBntVy3PVkz0vRK42jUKEwWdVU0yIV6G/tK1ZQjZtGW0+JvS4Tlvhug4E4NvMcZqUn4+jVPk1j1JRIUOhxSnsCj3lX7RXgG66pyKBZRhu8aze8eWIZr/u+SWREqN2dKuXKkvv1gDCkusBdqA8W2DLffoWBOd1Pc+xDjQNVf4XAoxZ+IT/sEb+f9bwpGoTJZa7jUGdUEuVUtttNrvyv0jDSIrxDtWsDsZa3TnM7Ntk0DQK88afNzjFVAK2rkapUS3BXqlnIGwhRro6dH5HCA+wpi+29MZcMYl3Dcl/wYQM7qcgDQ7CgWxjZwKom6oBE1ji5uKjDdA9LOsamaph4O2s4gCdvHgnub2JhsVIFUSL4Hmm8PGVX0eURJlFPjducsSFExp9VocnE1MN2c2XpJf8gS5sjt6FCGhqGh91VI1DSG1sEz5EbEVVvqFk+qq7QAIKBcB1o8uP8n/Vz0iYFslyxFFmtXSHqZCtGR5MPL1GFexWj9cWr4d6SrE825ey/EWj4kh5Rq05wZRi1aJnJLoXnnz5men18ZAcO8O4vZZRulupYSre+epj5vMzgyrjqV0BNsva+5viftsBNK+rlHT41rmLzz6SZ+pr4HfDzwUmgcTk3roRo+FOJwgT+SZGlq5quI2N6ZWDOIBbZ/9Y4OF+2VWL9JTUJqs53tLmAjyD04ax2u0S6QWzs4TPIgyWAyqhIhSPPvokZ8GBasCdZl8cGzRyNdLNI
 Q7ivsQoM
 h8Er8zFgoBawgAMglAi0W+2pNDrHB5nwNOY7XvKTsQBlyEdmWI+cSSCRqAb53q37/jbeauAiHtSh96CQkSnUJgOp8VYR1JI2Krv85xvJt9f9TMMb82wVbUJ32dhYMV5TDBpgsuxyfRAFIPW7CGYOC4ESemyHdoWC97ICdz1cZ8ySt1j2+H+CXjnYxakej6W4AZGiUU4vlJbcMGsKShSH8IoNub+mbX3UM5X+2Www8zuevmkXBaB4XAYdnTjl+TpCxBapPtoNOgiWmVHUvXa5x7ZvRaaPPKhkYb8TK8HmWt4OoByqAr1Fbxg0WU7YBbS+c4+Dfzbl58yRMkIC6sET53KdLw8VX3R10JmQXop8A3ax5SXRIrGoomomjarH/t8Mo/C9wXckwCL7PJBRyrT8oIITBJV4JFy9exGCAG5bjmb8LViRyxPVzEWTNea6MaV8bnvtPjD9piM90VNCAOQb7OeeSelL9EImaQeVY7hI+IIt55OjO4zYCGGo0rvtuSL/htUksSSdQja2rfWkcnJ8K1Lh/p/bGrMw/uiB86lNOCmJKE2Qkd9Lw02xVzc9yIkh1mzF9qh+KP5VBGPAKg/jhydkoGfbXHS9vwdsotn5y+FWkJo4kNGYdv4m4DtHW3oLdIt/Vg/k1gUiXGVCiU3EZtsBu7AW3pj8EdPeauFCpANtf9jIAZGI879HZjGpsgDlSr/NBycG9hPCvflM9va7YTbW6tBklLWmnUxIEh50FYPD08rYJ6yKq1TRme0MlJ8tQT7yxH/TkuszojVHOdspzcnQyoqbnDCVgBfFDpP4wyGr+PTQw3E4a4V4N+xvU7T3yf4wcXxULscZtGx580lGuRa6lOmroRgs+YmD4fwEMaxnoCQvFixurGxo+5QCzWnhCiq4b1OC49sC5NOdRpSgabLs3MXmulg9lQhr4uWcLL4Lale9fEr1sTfxZc69mAhKaNASn+1o4T0v/4D1w7kGw3rjZBWiD
 mCvY+6sJ
 orSVFE4YqewMdLv4GyC02g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 09:36:30PM -0400, Zi Yan wrote:
> Page cache folios from a file system that support large block size (LBS)
> can have minimal folio order greater than 0, thus a high order folio might
> not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
> folio in minimum folio order chunks") bumps the target order of
> split_huge_page*() to the minimum allowed order when splitting a LBS folio.
> This causes confusion for some split_huge_page*() callers like memory
> failure handling code, since they expect after-split folios all have
> order-0 when split succeeds but in reality get min_order_for_split() order
> folios and give warnings.
>
> Fix it by failing a split if the folio cannot be split to the target order.
> Rename try_folio_split() to try_folio_split_to_order() to reflect the added
> new_order parameter. Remove its unused list parameter.

You're not mentioning that you removed the warning here, you should do that,
especially as that seems to be the motive for the cc: stable...

>
> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
> [The test poisons LBS folios, which cannot be split to order-0 folios, and
> also tries to poison all memory. The non split LBS folios take more memory
> than the test anticipated, leading to OOM. The patch fixed the kernel
> warning and the test needs some change to avoid OOM.]
> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>

With nits addressed above and below this functionally LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> ---
> From V2[1]:
> 1. Removed a typo in try_folio_split_to_order() comment.
> 2. Sent the Fixes patch separately.

You really should have mentioned you split this off and the other series now
relies on it.

Now it's just confusing unless you go read the other thread...

>
> [1] https://lore.kernel.org/linux-mm/20251016033452.125479-1-ziy@nvidia.com/
>
>  include/linux/huge_mm.h | 55 +++++++++++++++++------------------------
>  mm/huge_memory.c        |  9 +------
>  mm/truncate.c           |  6 +++--
>  3 files changed, 28 insertions(+), 42 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index c4a811958cda..7698b3542c4f 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -383,45 +383,30 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
>  }
>
>  /*
> - * try_folio_split - try to split a @folio at @page using non uniform split.
> + * try_folio_split_to_order - try to split a @folio at @page to @new_order using
> + * non uniform split.
>   * @folio: folio to be split
> - * @page: split to order-0 at the given page
> - * @list: store the after-split folios
> + * @page: split to @new_order at the given page
> + * @new_order: the target split order
>   *
> - * Try to split a @folio at @page using non uniform split to order-0, if
> - * non uniform split is not supported, fall back to uniform split.
> + * Try to split a @folio at @page using non uniform split to @new_order, if
> + * non uniform split is not supported, fall back to uniform split. After-split
> + * folios are put back to LRU list. Use min_order_for_split() to get the lower
> + * bound of @new_order.
>   *
>   * Return: 0: split is successful, otherwise split failed.
>   */
> -static inline int try_folio_split(struct folio *folio, struct page *page,
> -		struct list_head *list)
> +static inline int try_folio_split_to_order(struct folio *folio,
> +		struct page *page, unsigned int new_order)

OK I guess you realised that every list passed here is NULL anyway?

>  {
> -	int ret = min_order_for_split(folio);
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	if (!non_uniform_split_supported(folio, 0, false))
> -		return split_huge_page_to_list_to_order(&folio->page, list,
> -				ret);
> -	return folio_split(folio, ret, page, list);
> +	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
> +		return split_huge_page_to_list_to_order(&folio->page, NULL,
> +				new_order);
> +	return folio_split(folio, new_order, page, NULL);
>  }
>  static inline int split_huge_page(struct page *page)
>  {
> -	struct folio *folio = page_folio(page);
> -	int ret = min_order_for_split(folio);
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	/*
> -	 * split_huge_page() locks the page before splitting and
> -	 * expects the same page that has been split to be locked when
> -	 * returned. split_folio(page_folio(page)) cannot be used here
> -	 * because it converts the page to folio and passes the head
> -	 * page to be split.
> -	 */

Why are we deleting this comment?

> -	return split_huge_page_to_list_to_order(page, NULL, ret);
> +	return split_huge_page_to_list_to_order(page, NULL, 0);
>  }
>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
>  #ifdef CONFIG_MEMCG
> @@ -611,14 +596,20 @@ static inline int split_huge_page(struct page *page)
>  	return -EINVAL;
>  }
>
> +static inline int min_order_for_split(struct folio *folio)
> +{
> +	VM_WARN_ON_ONCE_FOLIO(1, folio);
> +	return -EINVAL;
> +}
> +
>  static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
>  {
>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
>  	return -EINVAL;
>  }
>
> -static inline int try_folio_split(struct folio *folio, struct page *page,
> -		struct list_head *list)
> +static inline int try_folio_split_to_order(struct folio *folio,
> +		struct page *page, unsigned int new_order)
>  {
>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
>  	return -EINVAL;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index f14fbef1eefd..fc65ec3393d2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3812,8 +3812,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>
>  		min_order = mapping_min_folio_order(folio->mapping);
>  		if (new_order < min_order) {
> -			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
> -				     min_order);
>  			ret = -EINVAL;
>  			goto out;
>  		}
> @@ -4165,12 +4163,7 @@ int min_order_for_split(struct folio *folio)
>
>  int split_folio_to_list(struct folio *folio, struct list_head *list)
>  {
> -	int ret = min_order_for_split(folio);
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	return split_huge_page_to_list_to_order(&folio->page, list, ret);
> +	return split_huge_page_to_list_to_order(&folio->page, list, 0);
>  }
>
>  /*
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 91eb92a5ce4f..9210cf808f5c 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -194,6 +194,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	size_t size = folio_size(folio);
>  	unsigned int offset, length;
>  	struct page *split_at, *split_at2;
> +	unsigned int min_order;
>
>  	if (pos < start)
>  		offset = start - pos;
> @@ -223,8 +224,9 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  	if (!folio_test_large(folio))
>  		return true;
>
> +	min_order = mapping_min_folio_order(folio->mapping);
>  	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
> -	if (!try_folio_split(folio, split_at, NULL)) {
> +	if (!try_folio_split_to_order(folio, split_at, min_order)) {
>  		/*
>  		 * try to split at offset + length to make sure folios within
>  		 * the range can be dropped, especially to avoid memory waste
> @@ -254,7 +256,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		 */
>  		if (folio_test_large(folio2) &&
>  		    folio2->mapping == folio->mapping)
> -			try_folio_split(folio2, split_at2, NULL);
> +			try_folio_split_to_order(folio2, split_at2, min_order);
>
>  		folio_unlock(folio2);
>  out:
> --
> 2.51.0
>

