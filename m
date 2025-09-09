Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D375CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9A18E0012; Tue,  9 Sep 2025 15:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278E18E0001; Tue,  9 Sep 2025 15:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEAC98E0012; Tue,  9 Sep 2025 15:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B94658E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:10:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56F6B11ABC4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:20 +0000 (UTC)
X-FDA: 83870652600.24.77E7C98
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id E89494000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VhydMWvi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0EMo2xuw;
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gamh3OdT7vRc2ZCrijDSxydsSx7xWa9HjplByP0cSMo=;
	b=mVtLAS48rcafuyaiLbGjbQhZzSnTU3XqjL80gl68pPvdyJSaHMHVoksVMGDrElubEbKc2t
	Gn/A5baiPFkTwVEj2r3dt8EMI7j9NliDHKb34y4XMQZW0tBh+OUN/88yiRIBveBHVlNOn2
	OKOUhxmBKNp2zn95GZ+vU1v0Rwb74Mw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757445017; a=rsa-sha256;
	cv=pass;
	b=xbyEamcykV4P8DsrBBJaLqAdpCzlav9RXmhrKU0N8kyLVzeAK6cjaaWqFDA+jq1LmSshEf
	vT2+XabsxAvYwXnBiMhk3SS2HUnw4Spk/xhtjhK5ubC0xkVViVGiMvNL4KLxvumUYLXDPo
	WP1YQaaOxhVL4T8H7WCRolOvQwANwB8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VhydMWvi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0EMo2xuw;
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589Ftfn9014118;
	Tue, 9 Sep 2025 19:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gamh3OdT7vRc2ZCrijDSxydsSx7xWa9HjplByP0cSMo=; b=
	VhydMWviR/Vw7/jnguiyGsjgNOH1hqG9AIHmzfC0btX9Xj+KZxWeTkYYNpLpu7xe
	RXHtAizaBjCWwZp8XEjwu32wAxmK6ELeqbY+C5CbUGSg/9mjFF1bGJL7dEVLXX17
	LI6PGXYJmSm/5DYU/kiudsyCwHvg/mts8ocbzKXOl+mmFIKqEYul5ayWQ5VkJBy1
	EFGCIsm4dDdf3fr4m8VNAwQnsJqv9ow/SPJ7t9id1wqy/qFEnLnZiK74jfccdwC8
	vqcF1zhrjheZYg8d4nzavcwmmOYLXY60URKnMcS5TLYLbyY5nKgSBNQNh+U4jipp
	X9fCTldwAXYb40QX0GmNWw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226stnxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589IpkQd030247;
	Tue, 9 Sep 2025 19:10:04 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdb18q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZOCv9cEkVFJKKZiwCQf3JbYQCn7NnnTj+rT6+4rskMZF38YJeOB2LQx3XovDuR2PdtdfK2mFEl1dHKIRNFO8jjo/CEssKkLYiSLw6lOn1IfOwEtS7RhhievlG3hxVJWmIYe3SVSHFlO2XZUoE7YPUzUg7XGncDjloR97BNSMzRLYYO3G9mcaJEAKt8FL473rYbK4BJLltG5My8l0+irQECkK/6liUDxyxhbOAH27d7cZEh7SCAq1tkoy5RyC9fbDbaHhEKTmzuYIi1YHNiPelgsoywndhkhH5JVNVEXAHJ0udeyQNYQ3Jfd+EnWDiHfQx3xxhHijoRvCHXIDf98ufg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gamh3OdT7vRc2ZCrijDSxydsSx7xWa9HjplByP0cSMo=;
 b=bI9ScbJ672IlJb+iW4xa4cqyc0sz5qbWS2M0G6mpVuyMnXDhlc5c7qEC8dl1q4wgtzGArDjSa73yGGytvmyMfJyh5MW9Wb14LyQ347UZp7HDHKlJpQaY4fmEUCkmqQ/sfJ7/LkoPKFrNfCcwHZ3Wmk25xE23jKqP7C3KsYNkNq6/AqEc7XDrwIrn9m9OvFxLZF9D0Q9+NSE2P9AxaEPOkuaLpW/rEegVByWUQcz1V5DaL3QXID/7/nVRviEdJ19xt2SXr0nN8TTwqipIXvHJUsG/dM8F828aLoxmhP1FSnP+7t7lPbF5Gp5OtwwwaXy2UtXNvOMaJ+4gl96bn5P1Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gamh3OdT7vRc2ZCrijDSxydsSx7xWa9HjplByP0cSMo=;
 b=0EMo2xuw7DUBtjOrMuHvwPXEHiGJtRwG1UTmm6RWIVEf3kBbSGLf2W/bPl7bF7rFaaEqljvay3jISq/FoWzGFhZbsEmgV4jXL8UN26MmHnwBu8SS6hYcxHjDJN+GR3ulweeu7qbyjcaCkPX/Jgvv9IcGV6srDLoEg8Cjg9gRdyM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7052.namprd10.prod.outlook.com (2603:10b6:8:14c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:10:01 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:09:58 +0000
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
Subject: [PATCH v1 4/9] mm/memory: Add tree limit to free_pgtables()
Date: Tue,  9 Sep 2025 15:09:40 -0400
Message-ID: <20250909190945.1030905-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0035.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dd01aae-ddea-4ec4-312c-08ddefd47819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tnn4x79w7tFro8RyZ8ilvqPVdEkXEoILrXjL7YuxDlIEIeA3ZyqJc904HqhE?=
 =?us-ascii?Q?vPU7DznDRUHjBCzZx2367bvxgeA0PzEhCw6uZ4dxDTfzwmG4PfveZhdCKWS5?=
 =?us-ascii?Q?anQq4RUW+B7ceszd2QHBv01tOtTEGuBuoDhJQ1DELZHUQ/93GW+H6yPYImMz?=
 =?us-ascii?Q?/iXRvq5KZSkr8yInt1eT74STbh/lcB7z5RdqAhQ5vtthegO6eRROpc6U1Ilj?=
 =?us-ascii?Q?Qjzcx3oG8g9mDLEWBPskzb4i+SuaUI65hkOALKX/ry3Q4+Q6N8GB/kZV5slj?=
 =?us-ascii?Q?yM8CDzVwi6TjDicKsrhPLDM3qBc6x7gGf93mkga5TQq0C/j8x91Ou/63v0TA?=
 =?us-ascii?Q?SvoXFdISixCU4vgEOyHqs52CKpBJeR1zUCAiWQq9lrbTwLRoYX+31QKnX+CJ?=
 =?us-ascii?Q?4kulevGboaFC2OWXdY4714+ZsHnJYXXYIoBixEaPCNLXnxm1We8kd7QdV/zN?=
 =?us-ascii?Q?asL+D5EG221A7W7Tk5wwiZv9gqJgPObX98Zh2F8XzkDVycSQh+pVDxtyK7Ec?=
 =?us-ascii?Q?EXGyE/O4+bhUb4zgKrI5fS9AwDkuNNYS6Ic1mrLz9JbOViXpYEOGPXwIWDij?=
 =?us-ascii?Q?D1HEsKzns3ZK01tnwVoHkYI9PU0dxMrkMbV8OzJ9RIW+jofKGF3cBiSOvpuS?=
 =?us-ascii?Q?X0SwgFD4QlRRpmCPEEw7e25aB7wXhQEVXiEhUb5JAauXr9NxjOE4LksnPipi?=
 =?us-ascii?Q?7jwhyNWU4gYAaLKmoAn5Pu6fW7BUbTMjkSPlyb0jWwhra7ZGU+RjtGhpRA2H?=
 =?us-ascii?Q?rVNnXUd5XOZNLuz8HsayWbis8e8733Sgt10CjiTwSMCDcyGg9ByNBUhq6Y+0?=
 =?us-ascii?Q?FxwA0+G57nHQTnTYZ7lhWkdB4XjLuXTrGaOGrKAk8QSdmYSp2lQWAVWudFQ/?=
 =?us-ascii?Q?JyUwBgktWOwyaRziUSNiylus1SX3Ou/jlcI8vQ6pmucO/sZcScBlsM8vTNXQ?=
 =?us-ascii?Q?uYclbsualQNqapUX0kUSEBJ0dLusrZ4WfHimV1bROAb1gkE6fTfk+ZszH3HB?=
 =?us-ascii?Q?Buj5apMxpQzilI1o/8iBigp8kNDfrE4WFE4ZxGhKTsmJziRbflCB+IDkwpOR?=
 =?us-ascii?Q?OAp8O6BIXzBq4973Piua3FYZPvDZuM2edq9vR8xgh49ONPdxd9O7b00Dr9Hj?=
 =?us-ascii?Q?zvyQPVvWyy6btutYozidqYEQlUQuadTdsBV+Cmty8oM/pHfSQMCk67TBAaLc?=
 =?us-ascii?Q?lRQgZl8ksmMSj+oDxBwt646ROwRunaP8d6jk24jXAgntlcyLAEEmhxLsAvFU?=
 =?us-ascii?Q?l2pZChwRnpYG/b4aSRlCnlKNOcXb3MPDb0k0bQq5erFoEEdyuBaoJx5dt1Za?=
 =?us-ascii?Q?d4BV3XP2ItcYKC3+/pvLZegauJphHvYRcb7sI+OoGr1yQjee4nvsZVzMD8+U?=
 =?us-ascii?Q?BM0y6U8k1ZM5REsUa7wTP10DELAVVZqhXWadCdSTSmcKiZHWgF9H04P3pl1t?=
 =?us-ascii?Q?bPzpNMg3x3E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WoqK8+X0JXPm8EnyWfmO4hvpUDDyMZYiNaUXnpxXFisfsLwEhU98XIvzjDss?=
 =?us-ascii?Q?D8Uc/AzCtDCa4xL9f7rI9c5qktFBNTT0oFoa81uhBNb9ISQ3VKj2W4Y+XpEL?=
 =?us-ascii?Q?PxzVUWm5qlFE0WQ/1pAK5sFLpC3YtkzgHDf+5tF9Fd/ehUrsmTMeQKpAeaJ6?=
 =?us-ascii?Q?jViC/6+XtYXlbkIJOyNiKrRl0dz4nh2D7qr37HEOrJ3puZHlGh5Sx9CBp4pE?=
 =?us-ascii?Q?1Br0bzBJjY75cfcoZLlQIJJ0VM6Wa71rzKYevnIjaO9Ur+N9kkZqWSf/cKuG?=
 =?us-ascii?Q?wQiW2pdvFSQVvwfL15PivT8Hq/GdianRK7xjg76W2GE9lGetxfO7rLb7WHYN?=
 =?us-ascii?Q?SBsE0aGXGnHp42tXKdzn8/cGJnuFI+PBdSOL4UWtVXpRByIIWadVYQqi/mS7?=
 =?us-ascii?Q?8CtW4LyLWwQ9oYoCLuUu2MnBvWWaJq7fgL0+IlJpaFHvfIaMgpHMVI4iA+Uw?=
 =?us-ascii?Q?anVUqLirSz93aJLgvZ0fg67AAJoUb7lqgw6AlGKMaySofsOpL7VVC6BpbDu+?=
 =?us-ascii?Q?RZxMshyuWMD9obn8COL2vKNsSGbrPK+RMfyHWsZuQ7vVGhkR5p/yTW6Ku5Eh?=
 =?us-ascii?Q?NBZ1qpOjs8s9QfbWuxSlJ6kil3g2I0SIJ1MvXSyvhBbCxUjbCAg3Tu+NbQn6?=
 =?us-ascii?Q?8+klQuVQ3OYPnsx2iGQiSMZt7k259k7na+ibstx2D0v4R8rMuWzzq1llzYKx?=
 =?us-ascii?Q?4Om3lCENSkbYnlJLJwjSo+SOjxdDgYwjfqfxbdNGM3YSV3mRLQkzSkaKvNe0?=
 =?us-ascii?Q?MYhX+iuGB0odeeYWbe0CSjnhHyD31kvNc+FjBvv8TBrRqojzx2IY3rbxmnpv?=
 =?us-ascii?Q?vrH4ERmaFfovOoNs5Txn9i+7aKLphry9W/6+72rSD5GsFEtjtqovZhnujxIs?=
 =?us-ascii?Q?EYeVvqmOsahSQ7qcXqtuXgSSo9mCAAVtCTsH8R68spOLCWjgMbx7dhFa4uuP?=
 =?us-ascii?Q?cRVj3+yDWt5Kj2YrTEDPCL8toMQBsIQkC97dOA0M/8id2r6Xam/boHCkBVQV?=
 =?us-ascii?Q?FlxAoUOa1eC5y1n003xsut6+GVqgq6KNdHpG9Tr3g0cg3IooxUWe7Dbv/5nP?=
 =?us-ascii?Q?daHHVAGD4ZVts4HBAYYRLM4P73z38+xkZczAZizckJYl/b5EUdtdJnLylf+y?=
 =?us-ascii?Q?XNerq4XUCirJM9wvycPG2FXR48e0rWqic9wb/PHqJR1jX8GLipZQ0W6aY3U4?=
 =?us-ascii?Q?PzhFql9knZVMfK+VrIICxswoLupv8/bTmih6pmJjv05da6K3bjoOy31BGIJ5?=
 =?us-ascii?Q?G6RV1SAnzEap9EDRcgJI6nBGoEE1lwdvGUrWDZt7UN2MAuaOIZGxrDfVqI4X?=
 =?us-ascii?Q?Bqh/FtrR7VOScwhUA0OvTDa/OiP2khcO15Rtr/vhy67wEODuBUHf5zSwNtl5?=
 =?us-ascii?Q?94JPmnJXb2gyh9+eCdfXWVUu4Y7mfSV9M6d/5DLhKPQolEspPDjeL5FTi0Zj?=
 =?us-ascii?Q?Axyoj52R/A5/4l+z81tcA0JR6S5YFeWwHNIGBfW8h5OCOAZ8RZH3+G9PEdFm?=
 =?us-ascii?Q?6olAodk8nN3tvkYyA54c5UESN5LHd8e/gVqgaftc1SwoGxJvl96rOk62oJUZ?=
 =?us-ascii?Q?rpQdZb8YoVKu/uO6MSM7lRWCu8A8ifeodMXU+aQJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6kwVuH5NWruhuJ8WbEjJUlL5EZGijv6C5mvRb2X1lVfR+jp5cN3Lau0apwZhOITxAiMcgo+CH8mN94ZjDeXBq5N37qnnZHYOuTRff5bfVmHjUhI7GoFt87wKXEVGygt7z4uhHacMWYoRPwT7fNQ7VR1vorvnoA1dBXXjkcr4Gr/qo9RU24dEiWxMUQrBOYBYQ+rTk2EHwhtbiIh6IO5zq2LYJitHpEiGzcdASRKUt7xlCbnEycBAVOB/2Kw3TZSkJdul/bABXAryPXYZH6MMCx4BrXfbUt8dMnt5WC9i3+fombmhVIHYxPcXz5d1kaGb1DhTLkcn565HtGueXKebE/zbtxcAoxebWjELGNhqkPnrkVr3DdBaLTRXXyGQgtsw/TLknkNq7ugfLnTJtCTI1cIhxSRshhrbNJkDrDnPi4nutRCc+dXbpIkis+23aUCvadEke2zckxyvMQwxyH1ecFUswBS18q6Ms6R7LfOVsNU0nAUPa3Ldr6WNSm4HvpHam8mnvTasP1acg1PvbEAW7wppkXXCv7GxrHokDXAZ5WKcCkFXccNID2TrKrCi/+fyCkzZrz8xYmgl+u/sVGzzj5+AHLK7LTTmO1t98h3EMvE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd01aae-ddea-4ec4-312c-08ddefd47819
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:09:58.5915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jafm+i4Xp6kdEY013kybKVb6nNPbKi1lv/tc1guPOkF1sV44/8usNTDPuaeM5bmxAYguhKkOzStTIlte/zb4Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090188
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c07b8d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=q6GSRqQfuUaAh-TH8e4A:9
X-Proofpoint-ORIG-GUID: uhnxaAZTWEBX-OZ5YB7cwa338bln3Sgu
X-Proofpoint-GUID: uhnxaAZTWEBX-OZ5YB7cwa338bln3Sgu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX14fBThcuXWBa
 dFbsvbKEHxtKiZ8aIWSM7972tykOUh0j8cfP8nRz30kRSxwf4jK3iU3YJETfI6genVzR231FE3H
 2EL1ibAYyIUt/zV04bo97MhZ2SauCRGyqnd/QK2pAGGVk+dCwi/yv9g2unUKoisSvG9i+Nb+q9u
 L4ciTRbJSn3KeIyx5Hxa1SiqGnkbdLFNCEiR9O5IqtWJ7L9DDwr00N+daw8vGp83XtPEAFny6jx
 cwvqvWsP0SKwEzU3VxmldxnaXPYAEhECR4JJZmtAzZJatUg1XhLoApFh+P04difblNmbxo9OyNN
 muWYLfZzq2FSXAtq/Pcl20PPGLcbFmsgzcgYXsR6rLMeVrf9mgTRq2iVh8vdau2bXPj0NHuYNlb
 ZMRmmrnf
X-Stat-Signature: s1ahsiougqaf47xfxq6j48we6m48kwoy
X-Rspam-User: 
X-Rspamd-Queue-Id: E89494000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757445016-896298
X-HE-Meta: U2FsdGVkX1+ItG+lKni4ZSXxf7wbAwls3wx7PDJJUdeUto8IrDR53MRIEd4kxXXco6iCWHFWAZnp5bIvt1CXglqueu/JcwinUHyfQoYmqZl/3ScIewKOpnzSo0veiWTwtrh41DnAhS5mJE3NmAt3p4unMlea7+ji6zsawsbCHbBgqRVw8c6HNF6K0fU6xqVOvxaDf1WpIrms6lc+V7jR1+PnbujvdyOCh3YHND4fG6wkfaVCwiTdnVMDARngx0yH029d62S0NmzJQOGJt0vvxYYIonFTrgqj9rjl1pjOWs1CywPYYemY7QU4gdKCidT3g004W7BTuvmwk3ZQSV844gXGELINfdvqWE9dWgxfV/VLPwh0tXhaKfiHeIW3p3QRYvjUqEUM4bH9csU9G+BbugoT2JcUBw7W9qzTRHo6i2L34uWTFdHXG9EiCHqe0DyBQCV6bu6E3kUhzDuBMTfo/qxBgy93i1/dOcEVq/6FgFgHajzjelukFGqDZQgncAMZgFohZwEGn5PS/rdhE/PuNwvGGQobJahgu4qklVIrMGezpqHcu4sHif69A82NkNvzyjP02TzVjLiwxj74tkRT2v4YXvggCYwtEFsKOPdLdXiWXFBmxJra3xkkORSw3j5S6ttS0mPNYKHzj9eQvbvNziYpP0hrmviRDBX74f2h9QAF3nLKOCkfA2C2Hi0oDFgDVgkRv3w/3pwxO3oqG4teP1OnSxnxTEQYzwfGoVEWV8lFnXGkfuN1JX2GR11U3saKG0iNBtiq5qCkcIiBWTmCBNVYpifUOWXNRmVENEuhN6PHP8hznIzAcMq7WnL27aubvB4oydAGO5KlZzXE8qH0e6PCbC/tLWoVlbL9zFRW/NKV1pdhhMhdP9V1RFVm+n9CiGso/lGJE92wWn9382RQzjaf6XAyzM/wkDx6uNt4gH3Toa/+JK/O/6n37PSuhz4u56pOJaX1qvaTgw+9TWI
 HvlOdTqV
 ejE4RcJGbQVM156e969v+tywWWSVmhtTj8/Ijiv3j3EINA3PROf8s7SssXVBvlNqdJ8KwGMlJM8uxQSI5RdyMZQmskzxvHkznZ5Z6Pzq0WG4gTFaxs8fAdGUssiQAj3GrbKQl0z4fd8kdPUfMRnuA3XCNciVhXGt2KasURog89PxXBhITh45KkhyVNxYFfyTEPrYHZ1Jao3bTasjxU2PW1t0/YWmHoZuG7otoJF97Mf/CKi8Lo5xX2QdNr2kipVyAVK8aVX3zoQSJwVs17fgfcRd8I51kJaxaXOgV7upwQ0CelDoRdumKXbtfkG672AnJe1Owb0wLjXO5wSZHyTcvx4wNjO06s7urQxQDcYTtnuxNGSYFCdzuPpbEtKp5JtBAvvMVnQ8HnLENqgy268o764Jmyqm/Cc36Ez81MhTD1c7CbXir0MBaItqD6RyL4qJ9nQeo811LHhy0b4V0B51avjfLW3JOWxJzzfUHsYPWMY7Cz0pWncr7XCKwx9yAoUKORx6aXns8EDzEpGP2gEH+uOkMot1ThvPVqSAKER8jRrVSIIIxlSjeef2F3Q2PJko80Cf8AFNZW+84lotXtvIVBFF7z4cY/Lyc4lCjPVWhBaw4YHXJ+n7NK2RXIdWEdh02NnPQxl3Xp1Uff16tbThPSdhpzNTK4760/2IQVOxytEoIw7AE9gF7TQ2gYTLnpYQ+YO8DFP2wLQfoSBXjb7S0CJ5shiTCEQdRZJgbMgJ+25j1kfujeNCqHZo7k23Fi1gGYH8cY2pZYdzTNE8uy2W6hW6o/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ceiling and tree search limit need to be different arguments for the
future change in the failed fork attempt.

Add some documentation around free_pgtables() and the limits in an
attempt to clarify the floor and ceiling use as well as the new
tree_max.

Test code also updated.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/internal.h                    |  4 +++-
 mm/memory.c                      | 28 +++++++++++++++++++++++++---
 mm/mmap.c                        |  2 +-
 mm/vma.c                         |  3 ++-
 tools/testing/vma/vma_internal.h |  3 ++-
 5 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 63e3ec8d63be7..d295252407fee 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
 
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *start_vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked);
+		   unsigned long ceiling, unsigned long tree_max,
+		   bool mm_wr_locked);
+
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 struct zap_details;
diff --git a/mm/memory.c b/mm/memory.c
index 3e0404bd57a02..24716b3713f66 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -369,12 +369,34 @@ void free_pgd_range(struct mmu_gather *tlb,
 	} while (pgd++, addr = next, addr != end);
 }
 
+/*
+ * free_pgtables() - Free a range of page tables
+ * @tlb: The mmu gather
+ * @mas: The maple state
+ * @vma: The first vma
+ * @floor: The lowest page table address
+ * @ceiling: The highest page table address
+ * @tree_max: The highest tree search address
+ * @mm_wr_locked: boolean indicating if the mm is write locked
+ *
+ * Note: Floor and ceiling are provided to indicate the absolute range of the
+ * page tables that should be removed.  This can differ from the vma mappings on
+ * some archs that may have mappings that need to be removed outside the vmas.
+ * Note that the prev->vm_end and next->vm_start are often used.
+ *
+ * The tree_max differs from the ceiling when a dup_mmap() failed and the tree
+ * has unrelated data to the mm_struct being torn down.
+ */
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   unsigned long ceiling, unsigned long tree_max,
+		   bool mm_wr_locked)
 {
 	struct unlink_vma_file_batch vb;
 
+	/* underflow can happen and is fine */
+	WARN_ON_ONCE(tree_max - 1 > ceiling - 1);
+
 	tlb_free_vmas(tlb);
 
 	do {
@@ -385,7 +407,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
 		 * be 0.  This will underflow and is okay.
 		 */
-		next = mas_find(mas, ceiling - 1);
+		next = mas_find(mas, tree_max - 1);
 		if (unlikely(xa_is_zero(next)))
 			next = NULL;
 
@@ -405,7 +427,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, ceiling - 1);
+			next = mas_find(mas, tree_max - 1);
 			if (unlikely(xa_is_zero(next)))
 				next = NULL;
 			if (mm_wr_locked)
diff --git a/mm/mmap.c b/mm/mmap.c
index a290448a53bb2..0f4808f135fe6 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
 	mt_clear_in_rcu(&mm->mm_mt);
 	vma_iter_set(&vmi, vma->vm_end);
 	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, true);
+		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index a648e0555c873..1bae142bbc0f1 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		   /* mm_wr_locked = */ true);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
+		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
@@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
 	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, mm_wr_locked);
+		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 	vms->clear_ptes = false;
 }
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 07167446dcf42..823d379e1fac2 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -900,7 +900,8 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 
 static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   unsigned long ceiling, unsigned long tree_max,
+		   bool mm_wr_locked)
 {
 	(void)tlb;
 	(void)mas;
-- 
2.47.2


