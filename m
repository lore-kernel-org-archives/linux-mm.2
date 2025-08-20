Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F2FCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 18:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D7D8E000B; Wed, 20 Aug 2025 14:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDF86B00B6; Wed, 20 Aug 2025 14:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E2F8E000B; Wed, 20 Aug 2025 14:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE6C6B00B5
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:29:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB86D598A5
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:29:58 +0000 (UTC)
X-FDA: 83797974876.22.11344EE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id B169C10000F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:29:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bhaQY5jR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oGvm2Upv;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755714595; a=rsa-sha256;
	cv=pass;
	b=TtpCY82x8GvLdX4WqtSoadVU99kzFgJBlkZGmEOqKzsjsFvfFZ+ebtsCGhbYR8tdwgNj2w
	txr2aY+S2UQKgkBIacJzOZtWqZt/RVkrLNqvXZKGNegynO9EJXLwaqSiOZAvUxz5dliUjN
	VLj6qL2ncUw6Vk/2Eo5v6Wtnkq/dRlc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bhaQY5jR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oGvm2Upv;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755714595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvqduhPPkSa1MkE17sK1MD4ZXEk6ZrkGIP1w28aVmdY=;
	b=gkbj6tVVD1YYGOPx/kEfGsgfiBZVe57nZIXF7J3POLUMg23lJ8Nb/oebduO70FtUbq6j1r
	WO8iVxuJ31Ra/ynT41TOqQFM+XMC9eA1aqi7qvcniI4BY+++dTbU2uUALsIqc2GngftQ4z
	qQXtq1izliFAAZsHTquGUfWPj+qF3bQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57KFupJD011264;
	Wed, 20 Aug 2025 18:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lvqduhPPkSa1MkE17s
	K1MD4ZXEk6ZrkGIP1w28aVmdY=; b=bhaQY5jRE6iWvzw0fkfiRvjMiItbYqMUUu
	WNlisr4SK3zTF9rTu2zBja+vEeK9o8QAKyTsWNFJ2IlyPT5pu+Sz8+IEU0A1aYAe
	ce2UY8FbMIuksLjfPDfifFWIEfXCfHNPU2ML/JktHDei1tGCHIfj4T7vjamo2bcv
	PUlyPOinSlVR+BHjsClaMYe/izcB5RBo3RetQXHqzu/aFLm2yK75Z+MEgkIBPI8X
	YsMSaQzovXZvAFaQwzM5OpVxzKgh86KbPcD2Sks8cBbzoj7p1s+arw2iptwqHCww
	rUkYoRY9I9kJ/0QkamAuiry1qoUfIn76mHz+ilZxAXtUo60CiIBg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tt1x62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 18:29:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57KHVFHV039701;
	Wed, 20 Aug 2025 18:29:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3r5318-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 18:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uHQZQIZcUUnC8o+0Rs+iS0u45gvGNX3PzAsc2G9mFNBCirxSssv7cyEyNZeqLqUvNrY6SSpbe/O4uvsvAPkuBXM7aviTcknBvSf2Xmp2pyh8HFyf5ocx189stn9kLwbPnZlQ46XQE+n7/TvwWq44nCsQ4p/2/cj+mRKS2GI9veBBWUgza+J1km/4OudL7h/sMK3/4gNcCnw45jKQaehxDERqc7XYlfv3I8XFpsHOhWYkmQEWVj2VOU0snEI1bQxvwjxKmK6cudwdt8xhVGsuD5IrQdUHt58I+lhlVDqP0cxGVL4TnItumhMG4uCruxgoSCX+FsDFPD7l7ZUooijeHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvqduhPPkSa1MkE17sK1MD4ZXEk6ZrkGIP1w28aVmdY=;
 b=xSFeYeX8BOwFOs4mrdG/H64jBN4IaEKdU1gxb0IO7d//wYh5rRkTnfG2rTNDzJ73sbB9aXPxqmo3sFIdWASX5/DQCBjq0a1OrL5zAiNTs18G6It48Ju6fE1HyMVVuU4qLaP7E0pmmDy5mRPeiCQxpq+x5lZkFCWAfHdlg2fumw22rygf/S+zxUtnXkrtjh684yk8b68E6/2lb3rJvuppX8kfC9PGvgk8OKddziLGW8lujq8soIco2hFUchcNvcaCI7D0h5i4FhXsDixZqGUr7tZtVunTOcI/tM2fclr90bRxWR8nMNZGtPzcKzo1nWUBUtEtsbxq4JObjZMwydIbpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvqduhPPkSa1MkE17sK1MD4ZXEk6ZrkGIP1w28aVmdY=;
 b=oGvm2UpvidMZiU3NwviVjT012d5UHWtrwh6ISG79luOw+8U5FzhR3NVS3+txgvJfXsv14alsquvyh418qbcBenwaxhPCSK2fE8NWAyqQsg1INNbTw4rF6Ka8z9CN6RloBJg/xi/71Rsrp5H/V5W7e4s9rIBrEBiwRd3G93qUH9A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW5PR10MB5740.namprd10.prod.outlook.com (2603:10b6:303:19a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 18:29:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 18:29:16 +0000
Date: Wed, 20 Aug 2025 19:29:14 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
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
Subject: Re: [PATCH v10 06/13] khugepaged: add mTHP support
Message-ID: <06d1b76f-039c-4d6f-a03d-9253b14b5e8f@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-7-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-7-npache@redhat.com>
X-ClientProxiedBy: LO2P265CA0199.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW5PR10MB5740:EE_
X-MS-Office365-Filtering-Correlation-Id: 4352e283-f911-4d2e-7dbe-08dde017786f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2kQRQu1SAfGZZCy73iI4TDeZtyKa1YR2YksAFEJpeEQVEUKaHBhAK8wgkQVN?=
 =?us-ascii?Q?+4QRQ+RUhiLdKzVzpKMB+t5Ea43a/TWRv9pF2lVJrQxuPV4LkK4ckLANlSUm?=
 =?us-ascii?Q?pR3xmPpMJUe2Xf4YUkL61J6EEngcOvMk85npe/huZyc1EwUYqS0qahxJTgpx?=
 =?us-ascii?Q?ZZAXK27O5qTqDA/GWQdUgTkxUQp3rvGFEexxf0p1wCY19oWT23joxzjRWm0n?=
 =?us-ascii?Q?yg0HQRjlu9zaAkHLc6gp4RGQd09xpK6kZisbTqcpD0fMRlMqdtv96DhIGW8I?=
 =?us-ascii?Q?XLwppUCZ4OahideAqEnzcuLChAOaEGq+8YbfZsz8hLycu1hCFVs9ZQ1ASP2U?=
 =?us-ascii?Q?SRl48dEd1TT1YPJ7B+fbWmP7VqXXT/utVLZoiJu0n/bIo+/QX+JI85BHE8QQ?=
 =?us-ascii?Q?OyuYTSk7JjwL1gWcxdjcsrvMWpBpGbjYky9rDJbIthOZJFqRpHnUFe391Su4?=
 =?us-ascii?Q?Mm76uzX3B8F893btPLOsSrcHHL6GBlYJdB9W+TEg+okoHPje2r8CuKhS9YS1?=
 =?us-ascii?Q?uIWTwBq3foiCGFx2JFYZ3zFVALmQH7SU9EV9VtVMk/f/9InD2ozpbP76NTBF?=
 =?us-ascii?Q?ZdLJ6PrUxGnlVEk8E4/tOD8/NQYu0IRyEEGuBh9OJ4WNSnS4WMKMN7nncuMA?=
 =?us-ascii?Q?1Kg2n2g1eEBsFYnKMf9zaEll4i5XCxaGWoUaROBWnjgdWFpyJq9KnjzPZze9?=
 =?us-ascii?Q?kNqp1IEZoDVBPW9nayjC1L+8HGNzJ/dB81fhnKOcxEI7e9ElyR8UQToZgn7Z?=
 =?us-ascii?Q?vQtHVpQ0xyntlmBIQ47HB/NNfSua4NS26gD/UAwriHAJEb3gURycL6BLEuQ8?=
 =?us-ascii?Q?5kIA7DuzkFnXmcRe/S77thx0sQV337kkxMXxzr8irhjAbz+L1VPCbwMAh9j+?=
 =?us-ascii?Q?UPbv9iAsz/OwQQQysSzZKtnu93LD+u+pQTAOQDADnKMyZExlWWfpMsXBzbUd?=
 =?us-ascii?Q?vHEqkbwOzAR5YDFCaDqzQy2pWMlmO/TxTOg+o/prgz79JlgDl5Ng+6mN/TZm?=
 =?us-ascii?Q?PrsOl6rv/RVhcQ8EYiftNpPl564Sd3biD8t9wl15/m1zWLaMbozAu8d+M7jf?=
 =?us-ascii?Q?s+JLCJNcfyyfBlBgfLl9DiBXBYy4uQZulyMVFpoBc6nPPLr7Gk9Or9UvpvQr?=
 =?us-ascii?Q?9vjh6h9euGx/muZrCIPDVCjtKJS+fm7C/JRvMJ9lSLKUYmW9hUxnc8q4Lx6T?=
 =?us-ascii?Q?CaKyefh0XuDQiZ5Rnjx2GJJJys7gneZNVmlNvCwN34TzYyPObOYSf31ccvGW?=
 =?us-ascii?Q?nTOkBzodum5mn4KhPdEp0L5jEQVfcX30TnJ/kdNBHzqiR+9K/LDOfhRjdeyS?=
 =?us-ascii?Q?H6LYBdK8KhN+rFOgyfVbOt4lJfgmV9POhabyjop/+mWFX7viYAvuoDMSqgTe?=
 =?us-ascii?Q?K36o6jHp7NzZnggIhLxaKaL4xh+ZOnozQ8qUcatcmYyu5EoZSQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yWV1J8TOrP6l/G+D2G56vfDjUq1XMw4F1Tu5VNpJqSYDvlq5V8br+ZtMzdP/?=
 =?us-ascii?Q?72baNP9CfuIMD1RXcj+uhDc1ui3VZUVqgNwekpJ/51q9xxXsTK23EDE3YfIv?=
 =?us-ascii?Q?yN+jUQkfzJnxRnktMo7d9PdOcRFCmpm/rS1POeto8KzyZGlmMRAwbnyTnRQ1?=
 =?us-ascii?Q?Qm4Qn5XmzSZyY4SSmJfAVWMeUENScoThTJIi0zGzAElhbGHGS4UUdXGu5f/u?=
 =?us-ascii?Q?n6JWgqyim04ysaG6aNsjhhZW5DcTc0e3EAQumaovH+iIRzum/+QTClEDOMR1?=
 =?us-ascii?Q?h1yfC7mDFQjiUdo2cICrj3M2q2qhx4XPKDMCSDvDvF+Pz9/XPS8z8PgUDJHA?=
 =?us-ascii?Q?o1EDgmj2mH7Uo/4LWNRRLCZhp1Z8mYoKDt7Mr/otnQ5Q27d1ajMnXqEtp5i5?=
 =?us-ascii?Q?f3rmO5wwMz/oWqlWsCeiuyGH08pW2hucfeVVGmeuVY9PUjyjoS3B/nRPBO0W?=
 =?us-ascii?Q?8TsRyqivZE25U4oIrBotdw5gJq30wasb8TO3zQmu+tkyRMxbNnorXShY6hpi?=
 =?us-ascii?Q?bLu28BMCDsr1YIZPlVToBgNFcTmT3mpW76EeHB/PLVQ6z0Ie/lDYSJS2zgqf?=
 =?us-ascii?Q?Sa3WXjvk1Qsk721jebvWmCYCBRB2cgdzgLhQruMr9f3SaItboIGgZsXanEV4?=
 =?us-ascii?Q?vOe389rpUBvfTalekfJgZ4hHm0OOOUlEw5823o345Hs/Smd+8T0fRNVgd/S9?=
 =?us-ascii?Q?e31m9o4hqMhw8/G8bZe7pAXcZbK9xU/3D0Kxt6TErjwPslx4wC9UaQwjDaS/?=
 =?us-ascii?Q?cE0z7X+N9pGjsuEBaLeqzlstit6emcGBnyk2XFGMnyqgD6smlY1jachWkK6E?=
 =?us-ascii?Q?izw3RQ5Zyb3Z0iNZ4YW2278QvosD1auD3V4CcxI0W7kwltMASPUaZOdinU9H?=
 =?us-ascii?Q?KjdVVCjP7keazI7UZXeLvMiCvCp8ncR3LUs9MRsuWTyrIPKM8+UCtXfT780X?=
 =?us-ascii?Q?wU3WVTXDSZYh4yF/+fmmnEFO4A4hC823jt14n/b9629H1Uwv3RDPeK/Bqj3D?=
 =?us-ascii?Q?pyXMkK9VBZnXsYvCufEwMe1HD7TQjRJJLqiq6I62W+H+3nI1/jZoTiseS8jX?=
 =?us-ascii?Q?bhD3HKP5HRpRbeETC9uFy2a3DFq8EyvyKbDKj8PbxXGTDtrZ1NH/dElix3kH?=
 =?us-ascii?Q?SLYYqGTWvEBdxa3wOMUVAwItvudYjuZmklGwRoAflgQuxFj21/5hvAHPJyEr?=
 =?us-ascii?Q?BBuqMOAN3W/I7edn9sIFMD6Vbl/IWJ6X1znbXUJfz4FhidQWDJEyOQR4Xcc7?=
 =?us-ascii?Q?kkkGzHrgTg+f/9HwoBe423NMFAdykUVnA38f9lEmcgXDHt5MwpZrJ8wHGls5?=
 =?us-ascii?Q?xdoea3DYLQN2zAKyX/jk3I7exi0PmPZw+DxNK5Ezzdpf4RROB2zqFtzNHkJz?=
 =?us-ascii?Q?BD+Opzy01IAHuawZ1SzDyKwxRKg7f9vmAswl+voGtyMJdcPIGJGrX+7ttrPj?=
 =?us-ascii?Q?09Xw2v9gCq8UdU2u9die7otk7iC2V0kyqp8fFod6XpGvZ+B3SjlVXLPPFVwO?=
 =?us-ascii?Q?fUIlGmfECtKwR99rL7CA+MZG1zj3CD/shXL7eyayL4xruPS5IMim41+bRcE5?=
 =?us-ascii?Q?LWn7VfA+akYO4mFH9JPQf3SoknMYX90ehpjuW+3fpY9wCKRNe9/UJhDgLFBY?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eeTMIuZUtcA9Xxj0SxAYzYGa93/oQXGwd+72DkqfAbs+O1OQnl0NNrOxKO3Ntj3SJOC8HhQfdIvh6zSYf0gLM1QLb9eYieLSQgWF3IqqeIYtjg30DBqdHtl+twwnMtdHyrLfCBbvCHzwr+qVpGyMwLgCdT6rrqVYb/9Gpww1hvTbe+LAuiN/KyKmnGuSeblK9wF46+JNeg6p0KdzlwGSL7dNASUQIFB+cBRvQcyperNXpdAqpo6wNmeB09DJ0Fx1K3L+u63SnW8XdNeiA+WujwEOTRgHs2QX2XN3a1KULST1uHPMRU230IoOMeOnZdQVDF2n27xaH6YsaLEh+x/fXhfHpIE1QiU5Dhn/yeQ2quQtqqttsUrqgS11CXFLdsri2W6GGCDFKBGctLkjntxg4tip3z++fnLnUkjXbTfRFLjRzfptJTAY8reCU4xgrYnlDsqwoN5H2y5uKrWGqQBayBuODzH5wFhe1ZC9H0YqFBahN7M+shy0EFDMWI0R9WXP7Otk6mqbHQJQdTpKQo1Z7ZZMUsTliDdedJdkzPDlvFCcZLv31skmEPu0ZWKIwBZijaJXhuI8zGq3Dnd8spbJED8iM4uVApQXcizqMLjO5LM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4352e283-f911-4d2e-7dbe-08dde017786f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 18:29:16.7964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYHNHNyHz5MHs0/GgVr11nfde2ajl1fzDYFFwweHQIqpnAtUhNLgP6o1R25dVl8NBFR+GJohFI+M/DLdGCiEeX0tPis3AidJmqCTQqXoOQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5740
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200162
X-Authority-Analysis: v=2.4 cv=YvRWh4YX c=1 sm=1 tr=0 ts=68a61400 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=cLIx95IMrQ9VFNXdVrwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: lHC7jPxR8WPnCzMt4wVYrOJ_aBxNk0_3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NiBTYWx0ZWRfX6X168CivHoBc
 aAsmaOBwEAu5+OhOmDx4ChMteIizjzyNMSfDCwygdW6EBvs8auW5WulzFFLk/YxfqekAZvDhQmM
 S5bFaG1DZsme6ccRMxBR+YcX0tk7kNtV78tzwKf/JZlS9KxRAB3ErIVqa+V75rj8d5A22BGE6/g
 4N3cQn42xF6d+pE2xDVIgsQzAHCs4GzZAn89HisbsirrFUlknQuKQ90WmBZOGDRi9PuCEavhfHH
 zLnFFg5mJ8SfJSgQqIh3ftSkHbg9GQzP2IzVIdfUsb9wxHWbIdkuDElo5HvWuvhGHTneBgMo0Mc
 BYMp7Q5fDpsdMiwjjnJs+fVFXKNbHM8IJPBy9w1Wrm89jc50Fi12hvBWRi13IiDG4jioaxN5aFS
 ZrgSwuB/71K6NfWYbrULy3OpIyg2nQ==
X-Proofpoint-ORIG-GUID: lHC7jPxR8WPnCzMt4wVYrOJ_aBxNk0_3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B169C10000F
X-Stat-Signature: zan7rufhtckadm8fwyjsmjxuqq4fnunr
X-Rspam-User: 
X-HE-Tag: 1755714594-662037
X-HE-Meta: U2FsdGVkX19fIObfOFqUhrsXdtx7UkpN/q/2qzTN3lOH0k1+7kBf6xxrm/N/W0Vin+DkgyQmMQxSKUGVkab1C3cX5SqLRZwmvi4QsLRwwIcwbikum/JNoIKqnXuC7hBeIBSQ51ZjneHtULGXy49uy5tgtwhDn4fuh0eE0P7abT+LCrgpR7fC8+ByJXxW3uBr0Y/ZXabdUA69FaOWFQ7WeHxEV+DBJ1R/BA4nBOvoGUpkvD2O/slfE4HJGaz+Kcbo16XfwJlWz1JyzEtPJe/U5xlMqzsiDuTXQL2IzfkhdWqlRQuUM2me7/4wxXVlFncWk9qpBqDlOlhbIUVywT5cRbR7mSdBimObnjaF0rHAFzPihhM7y++j8R8TYoVGwiS00J+DSr7A/GTx5nat1UouYsKGWemYWPmAm7NyDjz25kxRprhUI8bo/DxNRkec4UiaAVyN0xbtsFhivMzhP+zI0Vz8lugPSNTc+CMKJ5ma2j8QX9sO+cCEkKLmdN8DJ5lkVR9DlapRVsQmsu6NZpWGEaFFIASE00DgLMHTSx20eRmI9EEI9VRNMA+4lmQzxkyhxACYvi9xEmNuCOFT9jE26Zw7S31KIgAz+f3EzEqwtDzOS+VHiEy38NIRdacSzvAuUXTZFRIQP5P0MbG+0bJTDH26NIudzHxJOxQ20nvXL6s2fETmH8vnk+rqLj551drBQtK4WdKc6ARm5Vr0IMTl3ZHpTfxrEe0qPDIyMzID3C6e0EkEUvIytUGzZwP0VKCxDbmXjPzfcpZC30MpRboqZJEmt8KrcOJ+Vlyu+9FZE2LZtJjElLLpC6dEphHm9e/TdecyWumNXcMX4tZyF9+yGiXaHbGyV9tWfuYDC3n5pMtcGCCxdG4USLwQNep5E+xAOfNKE9H9HqB18GcgsZ8TwBiTEfCG1/WMgv+sv8c/NJDf2VA1+173ppyq7MXsA9NkTrHkrw67qFXNNDYpYuo
 qJGlBqpU
 gaBQxHMlfsDUN9rvoZYaONr5xgxelYQo/Jsk86hRfZ1U0hfkfvLVgxFnreKt5/24S/uqpfnD89qWv+Szats6gMTlr8sqR1epiH/jPZ9cTMsEMOpv6aLiv1E06CmogzyyESBg/mDXyQQUNgyLG2LSJfvNLD7M+Judlz4b4/16mFkox/qvBLmVWsMCoUyIEgW/EGYk8Hlm0BtwYAeF9S4AOBWePVcfye9nbgdi0gwk9mwhrdVEi5whshpNpa2ex4fwSEud5SBbqhCnAC2LOWLN2geE/P2HTdtmaQ7zKvD54Biy5cx4esxpbFvZN3GUzfat+WQGK9MC/12Gt/0oRm8JcZKgqeMK2+CLbWLOX1J37P9Fza5XO3p9TDWsSjtwitRMJq6w2861/snw0Tyrr3kYeiXUObbjrCWDRxQ875KsMuSpVDvonqmcRAKLJpFzvmFoIQP1zmFz0Q67Ov2KwD27Av9jtliRutovHM/mZjX1waDr+EtASzY+aCMqOAJmtLoZqdQ6hZIC5dCVQePoK8G/vFBQLXzgyiwyW+dtC9lNcppKZ8NSYbu0VkYK5gkooYWoFEjEOM3LMHcR9bTCz8jrvHsaUIzKEzCQNDfvzTA+7EdnYCRRSbP6dQ75sDBsC2KK1rGv2dLaiTU8cJ8R6S4T48WgJSKayBCI4zyrYvXo1FjF5LYv5BF1AjDYDGfTyuy7POdNnTE5ypnqxw2UoUBQjrKDKbX3bdm6JUPnWpGG+0dtRJ6N4dcxUGnhf65njdKINv86dmvqJOmitI0/HVQDaufjXA+hEHMwZ7oHK1l5Wk8IhOpFnKfcili4wyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:41:58AM -0600, Nico Pache wrote:
> Introduce the ability for khugepaged to collapse to different mTHP sizes.
> While scanning PMD ranges for potential collapse candidates, keep track
> of pages in KHUGEPAGED_MIN_MTHP_ORDER chunks via a bitmap. Each bit
> represents a utilized region of order KHUGEPAGED_MIN_MTHP_ORDER ptes. If
> mTHPs are enabled we remove the restriction of max_ptes_none during the
> scan phase so we don't bailout early and miss potential mTHP candidates.
>
> A new function collapse_scan_bitmap is used to perform binary recursion on
> the bitmap and determine the best eligible order for the collapse.
> A stack struct is used instead of traditional recursion. max_ptes_none
> will be scaled by the attempted collapse order to determine how "full" an
> order must be before being considered for collapse.
>
> Once we determine what mTHP sizes fits best in that PMD range a collapse
> is attempted. A minimum collapse order of 2 is used as this is the lowest
> order supported by anon memory.
>
> For orders configured with "always", we perform greedy collapsing
> to that order without considering bit density.
>
> If a mTHP collapse is attempted, but contains swapped out, or shared
> pages, we don't perform the collapse. This is because adding new entries
> can lead to new none pages, and these may lead to constant promotion into
> a higher order (m)THP. A similar issue can occur with "max_ptes_none >
> HPAGE_PMD_NR/2" due to the fact that a collapse will introduce at least 2x
> the number of pages, and on a future scan will satisfy the promotion
> condition once again.
>
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the non-PMD case this is not true, and we must keep the lock to prevent
> changes to the VMA from occurring.
>
> Currently madv_collapse is not supported and will only attempt PMD
> collapse.

Yes I think this has to remain the case unfortunately as we override
sysfs-specified orders for MADV_COLLAPSE and there's no sensible way to
determine what order we ought to be using.

>
> Signed-off-by: Nico Pache <npache@redhat.com>

You've gone from small incremental changes to a huge one here... for the
sake of reviewer sanity at least, any chance of breaking this up?

> ---
>  include/linux/khugepaged.h |   4 +
>  mm/khugepaged.c            | 236 +++++++++++++++++++++++++++++--------
>  2 files changed, 188 insertions(+), 52 deletions(-)
>
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index eb1946a70cff..d12cdb9ef3ba 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -1,6 +1,10 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef _LINUX_KHUGEPAGED_H
>  #define _LINUX_KHUGEPAGED_H
> +#define KHUGEPAGED_MIN_MTHP_ORDER	2

I guess this makes sense as by definition 2 pages is least it could
possibly be.

> +#define KHUGEPAGED_MIN_MTHP_NR	(1 << KHUGEPAGED_MIN_MTHP_ORDER)

Surely KHUGEPAGED_MIN_NR_MTHP_PTES would be more meaningful?

> +#define MAX_MTHP_BITMAP_SIZE  (1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))

This is confusing - size of what?

If it's number of bits surely this should be ilog2(MAX_PTRS_PER_PTE) -
KHUGEPAGED_MIN_MTHP_ORDER?

This seems to be more so 'the maximum value that could contain the bits right?

I think this is just wrong though, see below at DECLARE_BITMAP() stuff.

> +#define MTHP_BITMAP_SIZE  (1 << (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER))

Hard to know how this relates to MAX_MTHP_BITMAP_SIZE?

I guess this is the current bitmap size indicating all that is possible,
but if these are all #define's what is this accomplishing?

For all - please do not do (1 << xxx)! This can lead to sign-extension bugs at least
in theory, use _BITUL(...), it's neater too.

NIT but the whitespace is all screwed up here.

KHUGEPAGED_MIN_MTHP_ORDER and KHUGEPAGED_MIN_MTHP_NR

>
>  #include <linux/mm.h>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 074101d03c9d..1ad7e00d3fd6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -94,6 +94,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>
> +struct scan_bit_state {
> +	u8 order;
> +	u16 offset;
> +};
> +
>  struct collapse_control {
>  	bool is_khugepaged;
>
> @@ -102,6 +107,18 @@ struct collapse_control {
>
>  	/* nodemask for allocation fallback */
>  	nodemask_t alloc_nmask;
> +
> +	/*
> +	 * bitmap used to collapse mTHP sizes.
> +	 * 1bit = order KHUGEPAGED_MIN_MTHP_ORDER mTHP

I'm not sure what this '1bit = xxx' comment means?

> +	 */
> +	DECLARE_BITMAP(mthp_bitmap, MAX_MTHP_BITMAP_SIZE);

Hmm this seems wrong.

DECLARE_BITMAP(..., val) is expessed as:

#define DECLARE_BITMAP(name,bits) \
	unsigned long name[BITS_TO_LONGS(bits)]

So the 2nd param should be number of bits.

But MAX_MTHP_BITMAP_SIZE is:

(1 << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))

So typically:

(1 << (9 - 2)) = 128

And BITS_TO_LONGS is defined as:

__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(long))

So essentially this will be 128 / 8 on a 64-bit system so 16 bytes to
store... 7 bits?

Unless I'm missing something here?

> +	DECLARE_BITMAP(mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);

Same comment as above obviously. But also this is kind of horrible, why are
we putting a copy of this entire bitmap on the stack every time we declare
a cc?

> +	struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_SIZE];
> +};
> +
> +struct collapse_control khugepaged_collapse_control = {
> +	.is_khugepaged = true,
>  };

Why are we moving this here?

>
>  /**
> @@ -854,10 +871,6 @@ static void khugepaged_alloc_sleep(void)
>  	remove_wait_queue(&khugepaged_wait, &wait);
>  }
>
> -struct collapse_control khugepaged_collapse_control = {
> -	.is_khugepaged = true,
> -};
> -
>  static bool collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
> @@ -1136,17 +1149,19 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
>
>  static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  			      int referenced, int unmapped,
> -			      struct collapse_control *cc)
> +			      struct collapse_control *cc, bool *mmap_locked,
> +			      unsigned int order, unsigned long offset)
>  {
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> -	pte_t *pte;
> +	pte_t *pte = NULL, mthp_pte;
>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	int result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
> +	unsigned long _address = address + offset * PAGE_SIZE;

This name is really horrible. please name it sensibly.

It feels like address ought to be consistently the base of the THP or mTHP
we wish to collapse, and if we need something PMD aligned for some reason
we should rename _that_ to e.g. pmd_address.

Orrr it could be mthp_address...

Perhaps we could just figure that out here and pass only the
address... aligning to PMD boundary shouldn't be hard/costly.

But it may indicate we need further refactorisation so we don't need to
paper over cracks + pass around a PMD address to do things when that may
not be where the (m)THP range begins.

>
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>
> @@ -1155,16 +1170,20 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	 * The allocation can take potentially a long time if it involves
>  	 * sync compaction, and we do not need to hold the mmap_lock during
>  	 * that. We will recheck the vma after taking it again in write mode.
> +	 * If collapsing mTHPs we may have already released the read_lock.
>  	 */
> -	mmap_read_unlock(mm);
> +	if (*mmap_locked) {
> +		mmap_read_unlock(mm);
> +		*mmap_locked = false;
> +	}
>
> -	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> +	result = alloc_charge_folio(&folio, mm, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 BIT(HPAGE_PMD_ORDER));
> +	*mmap_locked = true;
> +	result = hugepage_vma_revalidate(mm, address, true, &vma, cc, BIT(order));

I mean this is kind of going back to previous commits, but it's really ugly
to pass a BIT(xxx) here, is that really necessary? Can't we just pass in
the order?

It's also inconsistent with other calls like
e.g. __collapse_huge_page_swapin() below which passes the order.

Same goes obv. for all such invocations.

>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
> @@ -1182,13 +1201,14 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		 * released when it fails. So we jump out_nolock directly in
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
> -		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced, HPAGE_PMD_ORDER);
> +		result = __collapse_huge_page_swapin(mm, vma, _address, pmd,
> +						     referenced, order);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
>
>  	mmap_read_unlock(mm);
> +	*mmap_locked = false;
>  	/*
>  	 * Prevent all access to pagetables with the exception of
>  	 * gup_fast later handled by the ptep_clear_flush and the VM
> @@ -1198,8 +1218,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 BIT(HPAGE_PMD_ORDER));
> +	result = hugepage_vma_revalidate(mm, address, true, &vma, cc, BIT(order));
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
> @@ -1210,11 +1229,12 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>
>  	anon_vma_lock_write(vma->anon_vma);
>
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> -				address + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, _address,
> +				_address + (PAGE_SIZE << order));

This _address is horrible. That really does have to change.

>  	mmu_notifier_invalidate_range_start(&range);
>
>  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> +

Odd whitespace...

>  	/*
>  	 * This removes any huge TLB entry from the CPU so we won't allow
>  	 * huge and small TLB entries for the same virtual address to
> @@ -1228,19 +1248,16 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_remove_table_sync_one();
>
> -	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> +	pte = pte_offset_map_lock(mm, &_pmd, _address, &pte_ptl);

I see we already have a 'convention' of _ prefix on the pmd param, but two
wrongs don't make a right...

>  	if (pte) {
> -		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> -						      &compound_pagelist,
> -						      HPAGE_PMD_ORDER);
> +		result = __collapse_huge_page_isolate(vma, _address, pte, cc,
> +						      &compound_pagelist, order);
>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_PMD_NULL;
>  	}
>
>  	if (unlikely(result != SCAN_SUCCEED)) {
> -		if (pte)
> -			pte_unmap(pte);

Why are we removing this?

>  		spin_lock(pmd_ptl);
>  		BUG_ON(!pmd_none(*pmd));
>  		/*
> @@ -1255,17 +1272,17 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	}
>
>  	/*
> -	 * All pages are isolated and locked so anon_vma rmap
> -	 * can't run anymore.
> +	 * For PMD collapse all pages are isolated and locked so anon_vma
> +	 * rmap can't run anymore
>  	 */
> -	anon_vma_unlock_write(vma->anon_vma);
> +	if (order == HPAGE_PMD_ORDER)
> +		anon_vma_unlock_write(vma->anon_vma);

Hmm this is introducing a horrible new way for things to go wrong. And
there's now a whole host of terrible error paths that can go wrong very
easily around rmap locks and yeah, no way we cannot do it this way.

rmap locks are VERY sensitive and the ordering of the locking matters a
great deal (see top of mm/rmap.c). So we have to be SO careful here.

I suggest you simply have a boolean 'anon_vma_locked' or something like
this, and get rid of these horrible additional code paths and the second
order == HPAGE_PMD_ORDER check.

We'll track whether or not the lock is held and thereby needs releasing
that way instead.

Also, and very importantly - are you 100% sure you can't possibly have a
deadlock or issue beyond this point if you don't release the rmap lock?

This is veeeery important, as there can be implicit assumptions around
whether or not one can acquire these locks and you basically have to audit
ALL code over which this lock is held.

I'm speaking from hard experience here having bumped into this in various
attempts at work relating to this stuff...

>
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> -					   vma, address, pte_ptl,
> -					   &compound_pagelist, HPAGE_PMD_ORDER);
> -	pte_unmap(pte);
> +					   vma, _address, pte_ptl,
> +					   &compound_pagelist, order);
>  	if (unlikely(result != SCAN_SUCCEED))
> -		goto out_up_write;
> +		goto out_unlock_anon_vma;

See above...

>
>  	/*
>  	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
> @@ -1273,33 +1290,115 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	 * write.
>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> -
> -	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
> -	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> -
> -	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
> -	folio_add_lru_vma(folio, vma);
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	set_pmd_at(mm, address, pmd, _pmd);
> -	update_mmu_cache_pmd(vma, address, pmd);
> -	deferred_split_folio(folio, false);
> -	spin_unlock(pmd_ptl);
> +	if (order == HPAGE_PMD_ORDER) {
> +		pgtable = pmd_pgtable(_pmd);
> +		_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
> +		_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
> +
> +		spin_lock(pmd_ptl);
> +		BUG_ON(!pmd_none(*pmd));

I know you're refactoring this, but be good to change this to a
WARN_ON_ONCE(), BUG_ON() is verboten unless it's absolutely definitely
going to be a kernel nuclear event, so worth changing things up as we go.

> +		folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUSIVE);
> +		folio_add_lru_vma(folio, vma);
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		set_pmd_at(mm, address, pmd, _pmd);
> +		update_mmu_cache_pmd(vma, address, pmd);
> +		deferred_split_folio(folio, false);
> +		spin_unlock(pmd_ptl);
> +	} else { /* mTHP collapse */
> +		mthp_pte = mk_pte(&folio->page, vma->vm_page_prot);

I guess it's a rule that each THP or mTHP range spanned must span one and
only one folio.

Not sure &folio->page has a future though.

Maybe better to use folio_page(folio, 0)?

> +		mthp_pte = maybe_mkwrite(pte_mkdirty(mthp_pte), vma);
> +
> +		spin_lock(pmd_ptl);
> +		BUG_ON(!pmd_none(*pmd));

having said the above, this is trictly introducing a new BUG_ON() which is
a no-no, please make it a WARN_ON_ONCE().

> +		folio_ref_add(folio, (1 << order) - 1);

Again no 1 << x please.

Do we do something similar somewhere else for mthp ref counting? Can we
share code somehow?

> +		folio_add_new_anon_rmap(folio, vma, _address, RMAP_EXCLUSIVE);
> +		folio_add_lru_vma(folio, vma);
> +		set_ptes(vma->vm_mm, _address, pte, mthp_pte, (1 << order));

Please avoid 1 << order, and I think at this point since you reference it a
bunch of times, just store a local var like nr_pages or sth?

> +		update_mmu_cache_range(NULL, vma, _address, pte, (1 << order));
> +
> +		smp_wmb(); /* make pte visible before pmd */

Can you give some detail as to why this will work here and why it is
necessary?

> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));

If we're updating PTE entriess why do we need to assign the PMD entry?

> +		spin_unlock(pmd_ptl);
> +	}

This deeply, badly needs to be refactored into something that both shares
code and separates out these two operations.

This function is disgustingly long as it is, and that's not your fault, but
let's try to make things better as we go.

>
>  	folio = NULL;
>
>  	result = SCAN_SUCCEED;
> +out_unlock_anon_vma:
> +	if (order != HPAGE_PMD_ORDER)
> +		anon_vma_unlock_write(vma->anon_vma);

Obviously again as above, we need to simplify this and get rid of this
whole bit.

>  out_up_write:
> +	if (pte)
> +		pte_unmap(pte);

OK I guess you moved this from above down here? Is this a valid place to do this?

>  	mmap_write_unlock(mm);
>  out_nolock:
> +	*mmap_locked = false;

This is kind of horrible, we now have pretty mad logic around who sets
mmap_locked and where.

Can we just do this at the call sites so we avoid that?

I mean anything we do with this is hideous, but that'd be less confusing It
hink.

>  	if (folio)
>  		folio_put(folio);
>  	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
>  	return result;
>  }
>
> +/* Recursive function to consume the bitmap */

Err... please don't? Kernel stack is a seriously finite resource, we do not
want recursion at all.

But I'm not actually seeing any recursion here? Am I missing something?

> +static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
> +			int referenced, int unmapped, struct collapse_control *cc,
> +			bool *mmap_locked, unsigned long enabled_orders)

This is a complicated and confusing function, it requires a comment
describing how it works.

> +{
> +	u8 order, next_order;
> +	u16 offset, mid_offset;
> +	int num_chunks;
> +	int bits_set, threshold_bits;
> +	int top = -1;

Err why do we start at -1 then immediately increment it?

> +	int collapsed = 0;
> +	int ret;
> +	struct scan_bit_state state;
> +	bool is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));

Extraneous outer parens.

> +
> +	cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
> +		{ HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0 };

This is the same as

	cc->mthp_bitmap_stack[0] = ...;
	top = 1;

No?


This is really horrible. Can we just have a helper function for this
please?

Like:

	static int mthp_push_stack(struct collapse_control *cc,
		int index, u8 order, u16 offset)
	{
		struct scan_bit_state *state = &cc->mthp_bitmap_stack[index];

		VM_WARN_ON(index >= MAX_MTHP_BITMAP_SIZE);

		state->order = order;
		state->offset = offset;

		return index + 1;
	}

And can invoke via:

	top = mthp_push_stack(cc, top, order, offset);

Or pass index as a pointer possibly also.

> +
> +	while (top >= 0) {
> +		state = cc->mthp_bitmap_stack[top--];

OK so this is the recursive bit...

Oh man this function so needs a comment describing what it does, seriously.

I think honestly for sake of my own sanity I'm going to hold off reviewing
the rest of this until there's something describing the algorithm, in
detail here, above the function.

> +		order = state.order + KHUGEPAGED_MIN_MTHP_ORDER;
> +		offset = state.offset;
> +		num_chunks = 1 << (state.order);
> +		/* Skip mTHP orders that are not enabled */
> +		if (!test_bit(order, &enabled_orders))
> +			goto next_order;
> +
> +		/* copy the relavant section to a new bitmap */
> +		bitmap_shift_right(cc->mthp_bitmap_temp, cc->mthp_bitmap, offset,
> +				  MTHP_BITMAP_SIZE);
> +
> +		bits_set = bitmap_weight(cc->mthp_bitmap_temp, num_chunks);
> +		threshold_bits = (HPAGE_PMD_NR - khugepaged_max_ptes_none - 1)
> +				>> (HPAGE_PMD_ORDER - state.order);
> +
> +		/* Check if the region is "almost full" based on the threshold */
> +		if (bits_set > threshold_bits || is_pmd_only
> +			|| test_bit(order, &huge_anon_orders_always)) {
> +			ret = collapse_huge_page(mm, address, referenced, unmapped,
> +						 cc, mmap_locked, order,
> +						 offset * KHUGEPAGED_MIN_MTHP_NR);
> +			if (ret == SCAN_SUCCEED) {
> +				collapsed += (1 << order);
> +				continue;
> +			}
> +		}
> +
> +next_order:
> +		if (state.order > 0) {
> +			next_order = state.order - 1;
> +			mid_offset = offset + (num_chunks / 2);
> +			cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
> +				{ next_order, mid_offset };
> +			cc->mthp_bitmap_stack[++top] = (struct scan_bit_state)
> +				{ next_order, offset };
> +		}
> +	}
> +	return collapsed;
> +}
> +
>  static int collapse_scan_pmd(struct mm_struct *mm,
>  			     struct vm_area_struct *vma,
>  			     unsigned long address, bool *mmap_locked,
> @@ -1307,31 +1406,60 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> +	int i;
>  	int result = SCAN_FAIL, referenced = 0;
>  	int none_or_zero = 0, shared = 0;
>  	struct page *page = NULL;
>  	struct folio *folio = NULL;
>  	unsigned long _address;
> +	unsigned long enabled_orders;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
> +	bool is_pmd_only;
>  	bool writable = false;
> -
> +	int chunk_none_count = 0;
> +	int scaled_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER);
> +	unsigned long tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>
>  	result = find_pmd_or_thp_or_none(mm, address, &pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out;
>
> +	bitmap_zero(cc->mthp_bitmap, MAX_MTHP_BITMAP_SIZE);
> +	bitmap_zero(cc->mthp_bitmap_temp, MAX_MTHP_BITMAP_SIZE);

Having this 'temp' thing on the stack for everyone is just horrid.

>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
> +
> +	if (cc->is_khugepaged)
> +		enabled_orders = thp_vma_allowable_orders(vma, vma->vm_flags,
> +			tva_flags, THP_ORDERS_ALL_ANON);
> +	else
> +		enabled_orders = BIT(HPAGE_PMD_ORDER);
> +
> +	is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));

This is horrid, can we have a function broken out to do this please?

In general if you keep open coding stuff, just write a static function for
it, the compiler is smart enough to inline.

> +
>  	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
>  	if (!pte) {
>  		result = SCAN_PMD_NULL;
>  		goto out;
>  	}
>
> -	for (_address = address, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, _address += PAGE_SIZE) {
> +	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +		/*
> +		 * we are reading in KHUGEPAGED_MIN_MTHP_NR page chunks. if
> +		 * there are pages in this chunk keep track of it in the bitmap
> +		 * for mTHP collapsing.
> +		 */
> +		if (i % KHUGEPAGED_MIN_MTHP_NR == 0) {
> +			if (i > 0 && chunk_none_count <= scaled_none)
> +				bitmap_set(cc->mthp_bitmap,
> +					   (i - 1) / KHUGEPAGED_MIN_MTHP_NR, 1);
> +			chunk_none_count = 0;
> +		}

This whole thing is really confusing and you are not explaining the
algoritm here at all.

This requires a comment, and really this bit should be separated out please.

> +
> +		_pte = pte + i;
> +		_address = address + i * PAGE_SIZE;
>  		pte_t pteval = ptep_get(_pte);
>  		if (is_swap_pte(pteval)) {
>  			++unmapped;
> @@ -1354,10 +1482,11 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  			}
>  		}
>  		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +			++chunk_none_count;
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> +			    (!cc->is_khugepaged || !is_pmd_only ||
> +				none_or_zero <= khugepaged_max_ptes_none)) {
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> @@ -1453,6 +1582,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  								     address)))
>  			referenced++;
>  	}
> +
>  	if (!writable) {
>  		result = SCAN_PAGE_RO;
>  	} else if (cc->is_khugepaged &&
> @@ -1465,10 +1595,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
> -		result = collapse_huge_page(mm, address, referenced,
> -					    unmapped, cc);
> -		/* collapse_huge_page will return with the mmap_lock released */
> -		*mmap_locked = false;
> +		result = collapse_scan_bitmap(mm, address, referenced, unmapped, cc,
> +					      mmap_locked, enabled_orders);
> +		if (result > 0)
> +			result = SCAN_SUCCEED;
> +		else
> +			result = SCAN_FAIL;

We're reusing result as both an enum value and as a storage for unmber
colapsed PTE entries?

Can we just use a new local variable? Thanks

>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
> --
> 2.50.1
>

I will review the bitmap/chunk stuff in more detail once the algorithm is
commented.

Cheers, Lorenzo

