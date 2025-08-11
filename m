Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9D5C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10448E0030; Mon, 11 Aug 2025 06:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7E78E000A; Mon, 11 Aug 2025 06:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF988E0030; Mon, 11 Aug 2025 06:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A75BC8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:09:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76179C076F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:09:47 +0000 (UTC)
X-FDA: 83764055214.09.7A9D1CD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id D57CA8000F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:09:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D9vXZuTT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wXVQ7wEj;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754906984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qwzYt+xrajbvjzhYfoGvJe80vTcvb/8bHFODGN2EJI=;
	b=GPOacJgpmG6zyHsU28fV4IzJi1dewnpwaFlm7ZeNDJkTmCAY1AEiocSmCrN/FQ31BvhJJp
	nwNlidj0PaQyDDPWa9eDqPtjIp91fM/imR22OApmII4ctR2pzToFmf/Tu+vDCTxNfkrQVE
	lu4RViavOkGKctjVDgFQVXw8f5zWO3g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754906984; a=rsa-sha256;
	cv=pass;
	b=B6YWVrxBuIZxFb5rz01dA3o3bSELIo6jxzebZE1+1TYQuMLpl5U56OXxT9QeHi2OrNPtth
	mDB/QobBVkC+xnd3rKIAG/ztUQ6Ltvlpnl9VCxJDwp88lrcYRZfaPYnN8/eGrJy0Jsy4t5
	9yncblbx930fNFJvGrXMIImHleX9eDU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D9vXZuTT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wXVQ7wEj;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B5uCN4013659;
	Mon, 11 Aug 2025 10:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5qwzYt+xrajbvjzhYf
	oGvJe80vTcvb/8bHFODGN2EJI=; b=D9vXZuTTni6dEgkk9odeJNG7h5IKfVnp+R
	etExT5R046ln2Pgm3+e336AAYb7L72N8iJASoB5egO0TGrE0D/+gNw9mXAPKN+gx
	A5tXgOGHa8Dud8O/hVGh6PWMhC6apXV4EsQXY1zFn5z/mL9k5V/aNVLw21Bo5ZZT
	9hA7pst7ZKban4J57mJwsog47fNczw40wja9eKAgttMPqFjILmsizta6xPdN5e+I
	TdzS96T6JKPCAFUrU8DwxfpwlPlnwz5t8FAeoJh/k05AZfePWuzOAUijuhX+KHkO
	0Ng9kDtbmvxci7AGr7xUeytU7l0KDqRb9/FyeIQNtw43FGuw6hQw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dx7dj3wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 10:09:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57B90NID009691;
	Mon, 11 Aug 2025 10:09:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvseqpb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 10:09:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aU39mhN3YoUv4fS1wksAVqXmbeDVmZiF370xbK+dhjGQgsC6fgBJ3jaw9iUcvcC7MlYPMW41F9bsLjknxiF8sIYedCd/uG+igAAGwBHgNADJaE8ptpjnqil8s3R6tEpD4+JsqOqRwEXXIubJAHe/mW0hUFKJINByoZqy0XmO+86eYewoPMzOc6R4DXZfDlGqf9D9GPw3TvufHPuU4822QT3JE4GoPHlziGl/h6Wt0d/hx+E6ThPNV933WKFWTdVf8sHffnkAqlVEFpTq4dAAB6FAJpHhVVXV9UyLhY6sTGhHm1ietNYlXvXA8frrnoriZiQOrMmXCKr1G+tTLXP1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qwzYt+xrajbvjzhYfoGvJe80vTcvb/8bHFODGN2EJI=;
 b=eetxOyRLWJwjEbrd7EnYeEeCjLpUmZ0JbIBOs6/AFDOkXr5M/w9aG7CIQkHfliMka/vDELRlCwf+JcINSr3cz4UXAqP3Wp3k27UWK9H7Fvl5X6DkYUTGTmgoAa0IZ6OpzfekYW1OT6zUoVOjshjF1Bdj4WHfOJWvx5+IVg18Hvc6QuE9j+3V+R8Ga+CyzXJUqrJIAWmCKtQA3a13ZfvyCoW7rltXIZ7H+Yk8lKd+T1xo3L947UDQY2LiJTEgT33nWfzxOE8s01fboA5YIU5yquV9VB8KPsIcO8vRjWdxl9/arNaT38gaJQTeuemNnJqkDAsoTPAxZ/FQGTM8XRncpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qwzYt+xrajbvjzhYfoGvJe80vTcvb/8bHFODGN2EJI=;
 b=wXVQ7wEj9KvJjEK0Ujuigyec0GGPY7wCJs1w3KgjucJ1YaolAAjpD2LnxxGiyOqfdH12n5AnYJgyiqzwzcidPYhucUFDXCp5mPxLtzKQBdLl3RJQTDcnPP8bX+AF+aU9LfBwGLoXau3vakRE+hNvdef5xKx6iVFbo4liuo/R0W0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB4990.namprd10.prod.outlook.com (2603:10b6:5:3a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Mon, 11 Aug
 2025 10:09:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 10:09:27 +0000
Date: Mon, 11 Aug 2025 11:09:24 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>,
        "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
        Dev Jain <dev.jain@arm.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@infradead.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
Message-ID: <b087814e-8bdf-4503-a6ba-213db4263083@lucifer.local>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
 <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
X-ClientProxiedBy: MM0P280CA0048.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::30) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB4990:EE_
X-MS-Office365-Filtering-Correlation-Id: 0747d338-8f8f-41c0-d7f9-08ddd8bf2807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A0y6BRw/SjWeCdzvC9Q4OiKVmYh3v4JHIUiogJboTBZolsdsn7yVF6fxp3aF?=
 =?us-ascii?Q?w6vDKNc8P7+UTnMUgp7fljMqPcBtxEUhKGxZJlqWSIqT+yCrMPVaWTuxc7Wb?=
 =?us-ascii?Q?G5z4+qTIHajxEGaDjZQ1QMPwkou44Irgh00k+lq36g4gpkOStf1tmGY0824s?=
 =?us-ascii?Q?8JOt/pSexNCgMpL30Io5YKgy4pfw0Kzi/hvsZ2+VoelIyYnDsbHAhWJK2+zX?=
 =?us-ascii?Q?0Q6O5UFfQPBxFMRHUXC1zX6zN3lPp5EuYpn8vGC8YsGQQH8oS61D9NpyhRaP?=
 =?us-ascii?Q?Iz5PoOARnyTrJmteuvGhgtTNhl9VP82QT01qOZMNDChevzGg22hydPQDrwp9?=
 =?us-ascii?Q?H/gZ2gLTDsGRfn073L2ipzLmKLT2yl5rqJtERYhKYoBHqPHxpuPjyUFA/Mw1?=
 =?us-ascii?Q?ujdPnLcWXLdORe4GblGTQWp9D0v+cd8ECT3u7MZtS+QGxm0PDsPRtXaSlK1Q?=
 =?us-ascii?Q?Lg4diwi5OHu0so4Au8EjaAdxZ4w0vhSghQ2vo8erraqJUiFiq4kE1h9TtJim?=
 =?us-ascii?Q?GkMZFYnrnPtx8ot78uNXjIxAutV1uYT+9oYIwBGs7dJnI8J6dNLhuJBrrxT+?=
 =?us-ascii?Q?POzFOLICUEy1GnjyJ4tQDRw7mLfZDSP22olm+KevmGXRhgRumbZGHoZ+b5GI?=
 =?us-ascii?Q?ZE8YfZ76sDuLciBfUxsaykjcG1fHC+wLksUBy4xC9z9r9xVvkwWuYUzTRj6G?=
 =?us-ascii?Q?M8+J2vYHYd3CGWIdcAdgBH9TuruDquK7iC2S+fyy+PFQLFYTup3jUwplTmnA?=
 =?us-ascii?Q?dOW7I/Ud5AhGoF5eSl4gnebLgwP3FcY22iTgkiRNRFzupnJHLE6wur2mxVfm?=
 =?us-ascii?Q?noNHfJCj7tHwUF4KpOm1AwDd3NAa2m9G2SE9Kp/IWevCqGeFDaFoAvLyE0eC?=
 =?us-ascii?Q?2rS95DQ7/g25ZsQnZIIu+ybC8MdEMlySgJ256qanMhYW0DuymK5C1ERUjCOq?=
 =?us-ascii?Q?EdAaHyX5TQkb6M2bnHaic3eJL7W7h8RgPwh+vCw1Rfzh0O/bAof/lcxUEny4?=
 =?us-ascii?Q?y64WaL7Qy1kEfm3tszGRx+husXTGfqiwP6lXSrA1/fP5lfgiFMFhedsNXj13?=
 =?us-ascii?Q?frqoONpldRhAYoqsEN1nAsmV/zBTG1LwAKjbY/lPDFf1OzpInr3rw/9UHrFR?=
 =?us-ascii?Q?V9xEGSTz1Z5lyFxTAEwAd13hZ+/fs/IAFOGV7+ObU3hIXwIvd+whruMprLQ9?=
 =?us-ascii?Q?NGqmpgIVXAqwsG0Yq24dU0bSgMV/u/QDHGOuR7MDcDU4eLUbeSV+fn+YexmV?=
 =?us-ascii?Q?/Swx5SV+nux355sGxHBXBl4jJPYalYmPApLgPJxrSa6lg2MWnxM5RVN2fcFn?=
 =?us-ascii?Q?7IsL3XhhX+T68CaSLfUtsJ0qXqI1FoD2s1udQO1a7MVDLXNm1Fc7sBpZMFpg?=
 =?us-ascii?Q?Lf+G+5mzkH2NYy8Pghs0UbAZRnrOTdaTj7LeE4i+CDStTRjY1OlsDdDw3hZb?=
 =?us-ascii?Q?QL9xfEpYVqc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cDUphAfnrtd+1LKeck7FsM0tsS5x3qTUti4ONtoYz/sf5HwHDNLzrEbFYDeP?=
 =?us-ascii?Q?fWDLjEEG7fFHwnwHZayDDMpdEPqx5DAX+tEeh9FKfjIyhGn0C17swNWVFjD2?=
 =?us-ascii?Q?Op5G7Wd1LgJUwIP9Gmz/2EYM/5WfQAUKtjMpstEaMZYmTF/RbnKETQFYSHZE?=
 =?us-ascii?Q?Art6mJMNXwInRABl1DZZOZ3tND45n3CdOZvoBluuXqrVniT2sBAPcFKn67Vs?=
 =?us-ascii?Q?1IqREYZx5oMtLRfnir4OUxcAn9t4zJAt8don7UPbmoGuaqKnqytydEbFiBhv?=
 =?us-ascii?Q?OMcIdO64R4s/hZobK19IpsoveQYw9YCdz+So5YLAMZ0XoVYfAbXYa7NNZnIf?=
 =?us-ascii?Q?PBJt+MgbmvkcT10Yl3251t6eJnlWKEi04oj1EfpoDjqze7tEtn+CMLHFLMhc?=
 =?us-ascii?Q?nPaUO23zu1Rn+X7ZTfHoFjVpkRxpo3wf3FiWEqFsY9J4QbwyOEloJhyR7OzK?=
 =?us-ascii?Q?OGQvObSbvT6+OwmFHnElUXtEXxxthUb9SML9gr1C+wZZ9QF5QEmZNUQLztQk?=
 =?us-ascii?Q?RpSu61YzM0J4KvqryyeBafU4dVrcBmTAMpc9YlKItqAq+Aj/7UbkPlDGUuCO?=
 =?us-ascii?Q?di/Ps3lAuA/7uRqXZQTZLae1p0xcynWMfqrpaHwbJAIvoxHjTBkU8jiRX+XX?=
 =?us-ascii?Q?0wZlhIajP0u16OUmCximrkpJVJfplgsuO3pCDjChPkASFRJsidtkSgvdycZi?=
 =?us-ascii?Q?e7T8bhRb6dz46ul3U0fQ3JMStOos0tEdbtvvKvPy4meg0CvQyGA6GJv/cthO?=
 =?us-ascii?Q?6KEZxkLhtFA8L6ETGzkXftuRXTPMzDP17FY1u9JSuGQSwVta0YxJseZqTcjA?=
 =?us-ascii?Q?YGWY3q4auR+9KT9QzJQVsKFu2KtTdZNThnUGj5s3cJ7LsqMP4B2ShQ4EV3NF?=
 =?us-ascii?Q?afOrqJRkkj1zjCt5vSbvmFpul3ZXnfZ+O+SYIcpo6zVvHlSWjTX6ZW2IsBZm?=
 =?us-ascii?Q?8n+0FoNvsdN8QKxFfNlCTg+qxQjVXJF9LDCXuZMv6UplO1dK5mfOEh2J9jam?=
 =?us-ascii?Q?iwJEGKGBC5gCl7b5xnYEpzcMb/JA9UjKPuACdV8fU1PuB8Jq1IxGU/UGTib/?=
 =?us-ascii?Q?v7fDZNxUzTkTWFkt5bHlDkimTzxA2+QQ8E2FxduYEombyOzIUBgBqqleX4rt?=
 =?us-ascii?Q?d9Yi/d599dsB10qoBNhrh4gYLFNlNY9gSfReWvdH9Y/UEjDYqZ0SpWI03PnQ?=
 =?us-ascii?Q?gXyKX2Kjp5H1AS2azcTkDzrAC17ZIrq+AZkxT7R8FSJaz1EJ65OYWi3d2QIj?=
 =?us-ascii?Q?vAAH07NsxKcmAD9VcCQ4IGp6OFxA/LnGlsLSGZeo2HWsMZ9qbqsqAafoE0a0?=
 =?us-ascii?Q?JNa89n5ZjuqDUtPiqSahq9KK3o1IiKS0dhXdgK+qUuZModtDcTHPYcMlXNT/?=
 =?us-ascii?Q?vPyUhFllrpMEp/VM2ngqCqNLKRIfQju4rwKSiGZKJQnrCl7StvqiRZUeYGXg?=
 =?us-ascii?Q?eLDcSjFAn3uw+03I42N6WBBQ/bHF4SKOrvaWYuU9uO0bqqEkiR9ZiRjgpLOi?=
 =?us-ascii?Q?DDV2uEa9l8prXZFIAoIPI697OSW4tpHER+USiWov2M8nPE4iN5oQQEFrewQy?=
 =?us-ascii?Q?m2w7va78inYd1XHeVuWhXw7W+heKQ5C5v+RXILR6muj9EhybAo2MvD44lL4r?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d10PxuHE6mPLxs8DoD2LFkp/ZEWK7XGKjIqXATRnUjakLRY0Tj627SQ+cGgh486dVBnMmqNgKI9Ph5tAdjNelNnpebX/M9W12sz7+F958k1IGVsw48qZkipdVRtYU1KaUkqG6iqFvu75oxI1cNnaex4EWvVAVM5vajbpuKl9x9d4/3LUgdoqnGSfUgiIFyN2yqTWL3Lzg2h/aH6eTibjWKrCK/1Gd2oOG7LoWVYDnR099F6JduGQLx5VXAliInMTTz5WQEV3hrykFWCEdtNHtlNa24cfcKKbqfs1HQYvQVkv5NTbeKbNSMhbBmvgrpAbW+JYG+gusKKmLJTiz2x9t/hMsRe916TtHowU7mGDrWxRtMXOhZDYzFnyh1SUvO/5uz5OK+IwiD/OFkKcCbqdO+LtbZD6MNWunwJk4K52lvDwMYgyt/HQWGmayq+yqxJW2oepGzH23VKlJX9fkHnzDXhR3ACMQeE6qIGWLriU1oPH0mQC+HQ8xPI8bveF0JNLU6xaSdIEpJK2fPt8uR5IKZrXUZRj9XW32bzQGZ0MSR+ARK+ucM5RTxFy1lH05lJ/NWHUs2TcmW014uhcv6BCVKtCeuHFT/t6oGfhaDu5Djg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0747d338-8f8f-41c0-d7f9-08ddd8bf2807
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 10:09:27.9039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Qkvug5gJFSK83biu6qs36uTmSaNzAv+QRbFjp8oefkjvxJ0Cb7lQEnEDHA6041zzoewnN/hGVzqZWKNaOdFWFECiMRyDs2lu9Wc1s5dwpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4990
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_01,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110067
X-Proofpoint-ORIG-GUID: p9bYnqnW9cq_7366UCm8Y2hP0mgu5iOz
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=6899c15c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=E-SV3J6gBjIoOLDEcB4A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-GUID: p9bYnqnW9cq_7366UCm8Y2hP0mgu5iOz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA2NyBTYWx0ZWRfX3bkzkr9Hm1q9
 HGNahWGIBZ63UsazetJh/z0Bg3o4m2EX2mPg578XgFkeT11htq90TU3aoFkIVT2i7FBxHcaouYU
 UaP7YzaYsgWU5WcS1cZ0afM4yqA37TrnuqudFWQwVSHkNQ1t4N1tZvgCc/AuyOlNVA9eUaXDncF
 dZbO8EFYj24rrNKhq1EKl6fLT4l7RQL310ZI1QESTDm40H2rOf2iS2iT1DOyvjes1Yjpvk9qfdF
 iWQnymquFDlLgU7h85JXSRD6Mj1Ngx7VU7AonTJwMGOKVRPluAgaXhB4Rs4btm89+XLY/KaMEIW
 pfFADbQ7NaTKbo1JZAEbTY+QMTtDk/PEw2moP0gdHv6t5d3AS8aVVASjj8eE4McaksVCtyr4a+D
 KFqugUwBVRe+dnS1+S1r1F6Kc9o8ZdXMSXMPE1ra7RVc0UXGTIx2lFefXJVIDxH7b7cr8Vzc
X-Rspamd-Queue-Id: D57CA8000F
X-Stat-Signature: 7fg5cd5udd5p1q478adw57kq45w3wgtb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754906983-111087
X-HE-Meta: U2FsdGVkX1+ATwU9CaTTtWy9XPzUnGpAifNkp0YPBg8/l57Pr/wc05YCd7VGsjwxkkV+dJSoyjIoRnlwasoXWX44zyyEhO6o0YgzXB0CFfFZqXjUNw+2xyerZOjDEGmf7ONTVwquyi+jsp5arsYmHhruTa5JHpDEQ4mRlEOd+3+jTdQTIAd67qxFBhuv2TjprOBFo3ygTPz4Cnzk5PSxMbP1hnBBvT/a86minRBLgt4BdqD/5yr4XB7FzCA/LXwvQOJE2SSMg74XaOb/4noBLVeDQ4e3UVZ0I9WXk6btzq/jwMVmicIFpxU9iB8U43RtS04dNkQaYBawELNNK5p2xXhtbtcJw3QJ5fu9c3Un8+d3M7MhZc22267RmOOWNPyZlPHQIM/CPtlpkqmeVddm+rwKJadZTbIi6X+zeUqIaGdAqiVrGHLggIjJAyehq0OEBDxbLjasnGgIW0fSz8GjVgElG/6OtwkRKUtx57/Ofbi4MQRbioVTY+Iu6ecVMvCc5K7dSZY9LO6vcEa9ZGA78zSEREipdQJ4rh7jSqGpKmpEqq/WzhhAZ5vrFX3sz6vNInq2L6WaV+yxnnVdotxLLRA4NvN0xwJiqfWUuY6e6uJ/MtxtvCpYPHFSLBqdtvU0FCgsqWgHjNY5iMlK7XEfoJETyO5s5+IJg/KWfIOYuwhUKPeecq68e8KI/PHaiNZCZs/Ahzdv/scw/NR4WEV0j3LQZVm697yustKVfHe/8vTmGUQ35t3FFIMnC3RYMW8TLUS25HFenBCm8/ZJ+v2syPJhj8YlrN8smvC/vyy8szPX12Sqo3u5h2bbvACmR60v9r4RZvkFU5ll+J4p/w7nl7CqQSSJtQr2rdwiy7r83pynBFgvUJFa2eE1q3f7VeLgOusoLjFzmf6mS76oXAgO6356N43hbLbo5MWkrOPjdnHDZ7YRB/dd8omAkSf3x35KFsN+cqvXFDlNRe+dWg0
 CLvJswNK
 c9Ikd3NnHShfD+TKNMCUbN22L01mISdwm9B22jgq4Ydr/fbomICz4hvzQhWPzePn3Jq0Y28iw6jvmvH4G1OX87cn1hodyrdThj8h+yzLhtoRcwAL3KD6nu/h4C2rVrnCcTZ7OU5XC9OostvBnn84XNRGJ91hoUIQibjsvXNIQ2lDvZbOa2xgV1dlHp5YNXITnDFmyR1nFigTsDxzk8/t1xemW6W091R0dVOlubvMR9UhjxMgj/tZpg4n8YhnFqJUh7y24l3Qbe9F48YVqHI2WJhQNrLgYO3vcPQ2zr+YDJxl2uUyvWwCz8Moktj1y66KlvPKDoD9co39NfZuwim1UaWARhIGH9gcqJIa7Bv8cYoafmYv1xPA+8VKV9i6qoj061ctkBg8tfUrijdyx/f/svyoTJSho1Hn1GVYANwpcNRJc37+IKZHKWlvHzlwECAEy0WOHvagsqD3pgyBmLqB+RqI3It+a06SLIwIQU0Gyst+MTTFA31Vj3l1Iqhz5KV+h9jT1MJEUWdhjHIxJpS5208FtnYsTgK0SDSIZnSFNQnsAc1ddTpgrYKs2tpCPJ4F+F86MEbhiOeBsO+Fecd0/JEY0tN/wPVWj+uUgUoNa3h1a49BaFg7HqYJQsKRYbgDnyygaNS0ZAgrGKJT18/LUn0MT8GRcdWhbNSech7HIOcV6U00l+QceqeQ01GAADCdpqHvbAucWffkLduB+U2c/R5HcnVgqjPEVjHUNKLkPVZj4NbY3afMDd9D48PPMbWLrIvZFv6tAPECJcULHvA8IWMnN7NkEMBrFmXV+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 11:07:48AM +0100, Kiryl Shutsemau wrote:
>
> Well, my worry is that 2M can be a high tax for smaller machines.
> Compile-time might be cleaner, but it has downsides.
>
> It is also not clear if these users actually need physical HZP or virtual
> is enough. Virtual is cheap.

The kernel config flag (default =N) literally says don't use unless you
have plenty of memory :)

So this isn't an issue.

