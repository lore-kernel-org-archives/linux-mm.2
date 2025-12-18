Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F721D6E2DC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 20:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522DD6B0088; Thu, 18 Dec 2025 15:02:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9F06B0089; Thu, 18 Dec 2025 15:02:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3836B6B008A; Thu, 18 Dec 2025 15:02:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 296E36B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:02:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6698413A808
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:02:11 +0000 (UTC)
X-FDA: 84233663262.04.7C40DF0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id E300E100017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:02:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ty5S+1VS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BzBeLEy7;
	spf=pass (imf05.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766088128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbi+m8GMbk0gV/MuadM5W1ER8iY1zVLTM31yPQDIefg=;
	b=zsiLxAS83mcj9ivk+KLfNwKMwu6MFxUSV5WLmE+yVwugrdNTXVkZY4IadD748cDbhRAx20
	TOfPaZ3vPzQzOpgLdWuj/sOsdkf6jfvVLr06MrQUO/Sxf38WXs+EHmV9kcW10gQHOyPfec
	AVWyXkMpl9YElAAaZ94TOCE9rR3JI+4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ty5S+1VS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BzBeLEy7;
	spf=pass (imf05.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766088128; a=rsa-sha256;
	cv=pass;
	b=WAGTk+/abjjmqlq+VYFFy16s2x3jdnLkUYHtbCZPr89/xjd8ANxDf3YhvmUiglndT6GHpH
	mqMPQi/J0lzNgC3r6sBV8S2Ly+iHJJxc1A+ocYj0WLpi3Ax5PFwsemM63IqhusCrVt0WZ+
	isKR0vqRwMoX7VDHyDYqQvy2gN/bt/8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIJkQlM1671065;
	Thu, 18 Dec 2025 20:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hbi+m8GMbk0gV/Muad
	M5W1ER8iY1zVLTM31yPQDIefg=; b=Ty5S+1VSmRZU4Lon5/vSG3BCqwUTUJabWY
	aNIz4Wu/1d8k84U1OZsvDTSNHcIY3w2PryuHJmKO7UafROhRv7DV0OKT1SCWorj8
	1XhV7USxp9kXZJ9DiJ5fdaxdQz0LUQcv8iKrO68kQaypNOC+6dN6H427qpwZbZDb
	I/WTK0NzgMbmXqHr0Wyjy4tHYTrh3XSq6HBAi/C+yGfdVXHlAZIqRybOsXIQzw+9
	t9rCozYXmwilg22oA6SwfKjX/TDcmKYx76ssh20PRSoUq+qoaHZBVCHXeFZkLTUH
	6bJUgyE1IURKxj2RveWw8I3Pc2mlAc3MkH3MtjIq4Gtz0scNQp4Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2f00yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 20:01:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIJT13m035054;
	Thu, 18 Dec 2025 20:01:48 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011017.outbound.protection.outlook.com [40.93.194.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtchadn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 20:01:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sAtZG5hwsxVMMXO3fSCKFBcme8ZskvrVhoDPA5E8B5+dsa5plygMwMGs0kIzcG8uHhZ+o8GHiIJMiaZNZjKQ6vja8g+r6Xqi/4B5T42MnnVWHXMu9tCpnYf2GnJdRieW5a5pk5fqLixq4rTRhXaIrDCaVv/gj4F+7foMoEWqnKPnWkdh3OBRmm2p2COaSis+4kYB+yfA/pSFSqk1ZeY+UUAckBhuz4ZaqlfXNx11oi9+IqWHZKnUl9UEoy9y4E1MT2WSunj/QjMFbSpQOla40yP8qTH8W0Me9tl8+rMSN7li3aJv04S7YinsCt6fCyp5Mrlc/ammyY6UcACif586/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbi+m8GMbk0gV/MuadM5W1ER8iY1zVLTM31yPQDIefg=;
 b=Km8npxno8zal+Nz4q24A7fag1PhtdoOoCA9P2u3DB2C9Oga2z+h3Ng0EVqC3i19ghtpx/j8HxdBpCqsnFvZTRLtOefHvUMft0AsKrOPid2iY6Voz+XK5cJ+PaTsijBxGTBFTRVwMFhI/STbJDCvcOdeytk9rwVd98V/QHWuGS2MJw1Tf7uIqB1aBBLYDiW4elHASxc17deICaNf1RPjhndPm3dnyIXnzspjLnWXgYmSXWU1L09LWiZQ3ZvWYM7PWMHh3oa5mn6V5ZiPtjKVduMlNnPvVkzPsKnOeLp+3Vuxi4GIcDxspgXWQ86W9O08cdC14st3ZQ7RCJutqp8viZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbi+m8GMbk0gV/MuadM5W1ER8iY1zVLTM31yPQDIefg=;
 b=BzBeLEy7A5ioz2I1NWAbejj0rMbS/rajE6r/adhzNIoereFYyB+X7i8Q4zkauC+lvEIqGM8+4IY/EtLyTjt0sVyNuf1hecgK7qoL18oWzjM5AcR7QYCPNW0SL5i4uwRJAr0Sqzr+S4+U3eJdfSFGzRKPJ00l+quzqPl5L6HKdok=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS4PPFAFF9EAD68.namprd10.prod.outlook.com (2603:10b6:f:fc00::d41) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 20:01:40 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 20:01:40 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-5-ankur.a.arora@oracle.com>
 <e9033bc2-9a85-45de-a005-b9d12eb81f66@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v10 4/8] highmem: do range clearing in
 clear_user_highpages()
In-reply-to: <e9033bc2-9a85-45de-a005-b9d12eb81f66@kernel.org>
Date: Thu, 18 Dec 2025 12:01:38 -0800
Message-ID: <87ldizy2xp.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:303:6a::19) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS4PPFAFF9EAD68:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d683be0-75a1-48ce-846e-08de3e704215
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WfMO5Bt0TGVMIKdlCm96xdCkfyw/7YdfGMHyPKuoKnKpTBMhKL8xGMTzshe1?=
 =?us-ascii?Q?qQCjXzoqHJ/ig/hnnpcKgxY1NDnqux2P31YP5UqQzpZKPH+uhjTqI+oBp7rc?=
 =?us-ascii?Q?dI19AZbW+kMDE4mql08Lm9UNF9F6g2VzA/00BLHHgxljPWlKvxkOwdH5t70M?=
 =?us-ascii?Q?rsV+EpFCoioh5APaDpZdeGIE00+vE869Qeei5fALRuOF8kYyQX4/P8nIxBZK?=
 =?us-ascii?Q?jLTGdl3mmsxK/UFXE4bwWHyze3xhp8ynwr5ZlW3qPUon/aTs3O4DssugOkoy?=
 =?us-ascii?Q?A51S+7fC1rEGNk38IjrFa2hfaHEcQ8PoFweDsUJq79aVk4JMarwwU/9CU0C6?=
 =?us-ascii?Q?eiwOzDg9EYMkhBbPa0ZMVOSGM4gdtx0C4y+h6LuwJTuGlfkmr0A1iPoq90Lo?=
 =?us-ascii?Q?mPQor2rGjQKQCL+bNlJ9JvV8Js1gA+Zn2xgH64xLy5Klfm1PMIyrTWzMtHZg?=
 =?us-ascii?Q?GusWGgA/1nCkr2CRAc6gLqC+lqp/y/5LzLyZxYRy6L4ogiqUP6GvetO52yun?=
 =?us-ascii?Q?D8nDHY911DT+d3N8bMJCIp3eaAwRINJYI24I/9TTbMpsdJjqMSKg4yGUl2Dp?=
 =?us-ascii?Q?xznYDf+MTEf46U45Wwiph6LpqC6Yvv8dMPr7PMZmivmq3Wh+Qdc/3z3L0HbJ?=
 =?us-ascii?Q?iXpM1BvgYigirSeVOsVxrMPWN5V+5qeU7rGNPWvS0npc41DNJQVnq9+/qRPS?=
 =?us-ascii?Q?rJHayZHuULdypfLUtnIWeYLiNYq+13UAyNYN03ByzuNQykPB5UWlEuGTNGb0?=
 =?us-ascii?Q?ECS33wA1cXB2QmVEyKF1mXndqrU0GkRNJNE6Lt7s7riSuPJVHrD+7lqP17X5?=
 =?us-ascii?Q?xQRtpZ02ZJwpo7wkc/tGs21m+Mp4F+0AbG+JG9kO8hVgftHG94Oz24RRFrnC?=
 =?us-ascii?Q?8ydXnFYro00Ao082P4V6f5MBx5Ryc/1TIvQzNzvTYPjIV+HwjLEXi6o8E0on?=
 =?us-ascii?Q?koaxaS9mt7kdVhkNgdrqF+KHJ/UrEO2DzQEQC8Dt3VZGfTmG6jS2AVLPt1SE?=
 =?us-ascii?Q?KOhPB5MbUGRY1mXxYMQcMTlhWHeHkVJJX1SgxOhpt52VPkGowFKfty85lZs8?=
 =?us-ascii?Q?9gcQC+ZeW1B9j0HkOac/fNnlEq1e36kRqgPIP3h8I1F+a3Wv3eWaRfpNYnxR?=
 =?us-ascii?Q?W81Z/DnLBeAb6n5KMzkGugr+77T6t+6zMBtk5ITZWDW0cPOzVQUjpjd/LJed?=
 =?us-ascii?Q?9tMDBQMKUkhpYxC9AK+kvKvu7bRNh4rtHG8D3uH4O8oMTHcULvPpodhgnEnj?=
 =?us-ascii?Q?E8xwbwq6+XsodFynCo3BHB51HgrqeC5mAnR3cwJm+8CdBRz6FRJNQKImC6BA?=
 =?us-ascii?Q?R0h5o0b1cQM3WU1fI4aijIIiAv81eL6XrosJrh/Mo4Lr00fdDxjospNDl/Be?=
 =?us-ascii?Q?yIpGvbGiaouDj7ucexbqoRLZsKqRtRe6mpKXR6DRtIQ6hjHelbKWQ7kREgSk?=
 =?us-ascii?Q?k0Aq0Z2y4DDR8Tyk5sC3kl9JJPQEccJQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HQ3vUXUby64ypGnvDAoBbfYpD7JYQJmCY7AJnA8RTMii15obMweTNWqH05a1?=
 =?us-ascii?Q?ABVVpzfNJwVfIjTv1tD4KZWco1h9PrybM8ZutdBqKuG3QVVmv+QLVbL/6Euv?=
 =?us-ascii?Q?vGgItx1BhlLC8/G/ceo8OOZdi8qMMlcw2/5+FVF4yIpkm4zXZqvQnYCZ4vGO?=
 =?us-ascii?Q?SgTctLHeeiOcgn2+GR6Ua0baSiSSBTA5m04CzCkzGWWXD5qMNMDvZ+tQ1MDL?=
 =?us-ascii?Q?NZitjHxqkp01S0FdaqGLY3CtxQCCdEa+GpkEZ5FitfeFAmZ/hLZtq5Kp8W/V?=
 =?us-ascii?Q?8s39egzom5TPncf3/OyTWZlXkp/EJP5wnKEhhe5e3n3HmT6sfsjLM/KbRp8w?=
 =?us-ascii?Q?IMXmLdad6LE7uChC6DA0zbBaNDwWp/BHQhuq3v9AFIjzhfMepEWmfYqiQ7ko?=
 =?us-ascii?Q?0fI2QEvx079fWtjQGbqoiJ2XPU+T4wDaybso3ht7k41Hhez1oI5n8kjb6NOO?=
 =?us-ascii?Q?q7GEL1VVDQp1afWlOjc3ha1hjzSaH2Tlg9OYyZV4qDT961l3oT+Gb+m+wzzd?=
 =?us-ascii?Q?NxZpV9Vqu/wDmocI0Xi8KqAtohac1Q9ai7FFBIplT5mKR6MKYHj253QpYWad?=
 =?us-ascii?Q?dB3O/El9JYunJIdYGi3vUA+bSE/TGtqdziC1uGC+KhEJ3v5TpPm9We1lCtuN?=
 =?us-ascii?Q?A2dsnumaJXwoe7eyuQq0pR5IZzZaEVypnh89OiEm0bHDp8yIFwmzQnqyC0vb?=
 =?us-ascii?Q?0MiIqJY0YttoajD0sPQnRLi9ji0aBGo70+ATktTVhswvqJbFOHfMSbzYvDa6?=
 =?us-ascii?Q?dMG4tNfwRc8d1I50wjh3TAPpwwTBgdBG8yF7tQnVd1APlrwoq5z4aun64fqx?=
 =?us-ascii?Q?nw8XahxmTh2AF4xawt9ikS80k37yeWNlcucfi5p+60mNuLpdQSq1+kXjE5Dw?=
 =?us-ascii?Q?buCK2YjODZHxj+6XeYgNtSs/joryD9WwUJhlmH/lzpglPP4ZxkxIPonftE06?=
 =?us-ascii?Q?kgMB/mIP4UCn95LMOvh8VhJwWYAPqiS1H3pKZmVeU75rtMedcuTWp0+8FuKV?=
 =?us-ascii?Q?aH6yU5jYjTW0KeM6NAHUyDuz8tVgdEG7npbpK5P6OA2nbVmqsLPgKHfkfmFD?=
 =?us-ascii?Q?HWbpckWJxfiXRlWOUYiwFOY8JPVcfHyoyithN2GNFfvH9+Yp+M3ZFd72TH0c?=
 =?us-ascii?Q?D4KXAl0iFDaxtxEn1vakp3FzHwBS2jTBatJxuCRfjH9iLZRcTyU4VPcOKJXN?=
 =?us-ascii?Q?AlvU6C/JOesRanfwmdYyZH+BYmfr2c2gl2ObMKTXyYUgt+imehGyB+pSrsAE?=
 =?us-ascii?Q?92vf/45F6xUsRwUsThKmnRE5vupZ8alzigSyzVZIZgs8pWjcUKCwZT9U43ns?=
 =?us-ascii?Q?Z140DXRcrVFiFQZTcjcqt6lQbtP0YdFURHf4vKaIks/kysPO4+oKRLmw1VgY?=
 =?us-ascii?Q?H+W9GVroqv9AW1gAjF7Shs8e9UK2ubMr1O/QJbe1SNVdCJ8LHaAlq4VTtH/K?=
 =?us-ascii?Q?jbhQ6/bBMSDJvxEF3/V/un/0AxoYn9gZpN+FQmffz74ZLT/s+1kXOVp4XY4W?=
 =?us-ascii?Q?D9/xSEPPm6Z50wAiZZTgBXBWtCS5NQ+4OUEKkF8+l9WVTW1qxIh9MvrEBOH7?=
 =?us-ascii?Q?4NS4eKka+j3TbI0/ar+Zhz0NIh4lir2E5SHnAR5FOd1utjWPOs2A93H257rU?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PYY/QUGUNgC+KOdOLhBgyC1ArBNOTUl+tqy6SqXnVMWSswBe0E+lxpQrpSZ1X/HwTbAnlyW2qZZaWfk/H4w4ATezomwbYxat+CRz5kRkGUJAhi3yPQtjaUTWt4//Zbi5XZ53u1PKI0+442fnTmupqmzUz/1aVUt/4xH6djKxav5Yz9yBIwolzp9yP/wFVvnMLKsP4bkUxbV7pK+6ehQMSJCn5ogtK64c84JT7+Fuylif1t7UjGQMbYC8abUzWhKxCT5YfJJbQ/PagzU5IlRt/mSEnFxW/TL91BNO74tr/uUBnsMdwqf9Arn69Ra7l8ZSiTVtevxyXfkqoyl2NB85f4VeMfjGsocU0PCfS2Mr1nqT0a4WPYcL1YyUHft17DXNLp9wWS9lVK6G023zeIfPLAPv7wLQeCQ0hXtM2P5qrnIVGh0QBKEwcmQfRaddtFpuo211kDr6gOjSOwl04WDocr5WlEh7WG+vaOo2GUVC3mkkq3YliXl9DBX4Fwm3JCav+WRNYvZeq3wNkWEd4+a435Imf3kFs1bVpWho/L5+dlP5gNkLYDEBtQsMzBo+YZ6gT8UkFmaKaASvdmW1aFeDfEE3zQ/B5tOZimF0vxpnznM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d683be0-75a1-48ce-846e-08de3e704215
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:01:40.0490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAFeldlM/hWFdtS+nj3C2ZAtgzkmmDpeNHpMZbOMCw6hT3YC12WlagTWXNyyvpHImny9tXqEYALZmBFwYlwbbwEfoJK9Y2aokY7/48HOmxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFAFF9EAD68
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512180166
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE2NiBTYWx0ZWRfX85wl/9l2SR+l
 9crjE5mIZNCzZNu7yMH6bqsivfsBLd/LoAOHrz8aYBPGUDJaNPmSeHCFWCJf2/yevNXkZKxkWmY
 i1NUEgSykZUSyNfej8I97zHuLvKzvLIssD8imqC9POz8RblZyVmJa9+yf5GTkFMeAqj7lv3d8bf
 rzHHtCPDk3kA75rteko01hbW3qLuD+Ww12Px6YApXtWSRWvQzBeQm/aBgIGRHBnGxUGtum9NSAY
 J8HFiVftLomXpFNgB17Rdh8grMO6Iz6Tmygzf+Ei2nrJ0dL9/DIHj4wY7P9dTuL+RWp1Dn+vLxc
 cULHUa23n5CiDAbNriyFfIb8wp3+UFjc6smEVDqt1b3SJQSRaPK4gRd8qwjcxdtehJFtVXb3xvX
 IAB72AMut8CgKKkPvMAJo97iPDSRL75wNG6ICvd8a+hc/FcnDW6QX6xcQ8mYAtEnvdwYObk/sDU
 7/SsLWQqqahchUTTr2Q==
X-Proofpoint-ORIG-GUID: vyEcK6xwT0FMNS6Aqw7IEaNIGy0TRp7B
X-Proofpoint-GUID: vyEcK6xwT0FMNS6Aqw7IEaNIGy0TRp7B
X-Authority-Analysis: v=2.4 cv=OZGVzxTY c=1 sm=1 tr=0 ts=69445dad cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Yr7H4L6NP2HbKeyx_G0A:9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E300E100017
X-Stat-Signature: biyuaasu1nyqs4te3izuginik4gc8m6o
X-HE-Tag: 1766088127-465972
X-HE-Meta: U2FsdGVkX18/Nr47OpT4B3D6snyLR0RV0DJpMyZOEA6XhlE68a6AfwL5rhXK5w2MmG5tEp38zz2UbSzons6GLRSKaCga3LfaYK/d8hCTvRo4SMsbiuR0h/oSarz/R4YG4G/wR3pN+9DehBqjvZ5fFNEwwdNGNyWyZPFeET9S26yq8WBgzzSEuewc4rf9Al48D+t0mqm+9mgEZFnPcC/VT6dJ+XKcgZhcQq3SvjpP8t/QuX4EZbORXv2cjhgm+cUyF1EvitNCdQlFLWpLJxEveTypSM84iW3cLrNmxpFHm6D5Kk3GyZaTzGRctHCeKCUe6YB2m0EpMs7fbpeg6I4Nj8b+D3PxcxiEVqRmRnTXeCiavpHtUKYUludtxuN1cIEscqxibQjjF3c9X2Zj3qszC2UGj15zRxLdauhWjMvEhOzW7pO26HdYKBsBTINQLLaMyEoUr/qcQbgefTLhraVlRLuAHOrxrnv/+rMtV7imZK6K5q6/Ws6P3w1bIZHhHIFXNI3P9UR1gvcQynCoD55Bf9cx6Ve+KmJXSEtQFbex4WihMS0Zn0cj2Lumw2tx3xSXK5m1GmCDlpRg5A19aee6iM5IdLb02KuV8SlsR7XayHWL7c5t8OVc/wkoU31TnVRxXqV7ydTPe7qMXVJT/y4g6AwlsBG50qjHgSWkBfW9uc+7y9BSVlQgEpUNNmIDpzfr86UIgM7t6VZ5QJgdvnuSgMr9daIu7mQYt7F/va3ZYBpjahtYlqQuECSHU6yLwvMc80dNS5g9BfzOLnFt2LXwi0ryUve5LeFAWk5y/BoPxbDctbyXIBhv/WUFZFKokEyhTllkmke/Itl1yJPgaPySthQ1O/eQ5w6UdBhlJMLAZkHsu/ttTBrdTfNN6fapyXyx2/773vkYrMZHisQbxt8mWZ/SzhtUpgxjdeFRl82OyOlJGTi6QI2UgYDBCfAEF8rqjzgXmn4dLE8RO8aEqxt
 9lqKcxs7
 2p08cmvHt39dm0gejyEG04XUWzPHFKqTVDLd7cPlQJGOEaq3CJ8A5NdQQA5Ys00iRtb3Y1qyx2F8SbZ23BoFxRMn5YHw83OJ7Cr0lAqwYO6NQEWVS2vtTAv3nKab+LcCqFXxvDg7tm2ohRUzVN0f9fr6oI8961Obvc1Ik/1bz7PU6vsZlW79oALzUcHQdYU+zF59AeeLRm2P7/piyfji3JdvOTRVCW4kf/DrA7lbYEF05gJiGuf48tPMFz5TVkK9cRsFZolEn65uazttTLkln1dZGuUZVa5QjgdPF1dWzH7em+msFlc5DCDxgB9foqxW58EsCtFIv7VSFbtA1kJ8hEsDFO9sdH9SE2/cO7Ay0deM3I7Vpg9LcwPkAxjLWnSVU/kQvf8Dfrr1UWg+qqirkq3VQFBXaeLgkNDXxZQ2H8OAaL6hDuuV2HHqs1SMH4Iiw7Lbc3OaVXXIJejpSsLeNo5mXggXJFQIWshw6gW5iF+CPgmipRg1KnJosrJIjrAJg86HlOGd/m0ocnW1HFQRN+w4ExzL1pncWrElTIaEGiiQiY2wXddDAJoUAYDQUK0AUd0uoT5L2f3nxdvrKjvtBnbPLtKun+bK69f0a2fKu6HyMvNE21ebjvh/roBVKTwc2azMu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 12/15/25 21:49, Ankur Arora wrote:
>> Use the range clearing primitive clear_user_pages() when clearing
>> contiguous pages in clear_user_highpages().
>> We can safely do that when we have !CONFIG_HIGHMEM and when the
>> architecture does not have clear_user_highpage.
>> The first is necessary because not doing intermediate maps for
>> pages lets contiguous page ranges stay contiguous. The second,
>> because if the architecture has clear_user_highpage(), it likely
>> needs flushing magic when clearing the page, magic that we aren't
>> privy to.
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>
> Can't you squash #4 into #2 if you move #3 in front of them? Or is there a
> dependency with #2 that I am missing?

I thought it would be clearer to split this into #2 and #4 but #2
is completely obvious so doesn't help much.

Will squash.

--
ankur

