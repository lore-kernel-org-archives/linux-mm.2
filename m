Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ADE1D778BF
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 00:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98A06B0569; Fri, 23 Jan 2026 19:50:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59C46B056A; Fri, 23 Jan 2026 19:50:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2ECE6B056B; Fri, 23 Jan 2026 19:50:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0306B0569
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:50:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BECCF140186
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 23:31:22 +0000 (UTC)
X-FDA: 84364827204.03.4D50C12
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3D842100010
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 23:31:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nYRj4dvb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hac7oK2U;
	spf=temperror (imf05.hostedemail.com: error in processing during lookup of ankur.a.arora@oracle.com: DNS error) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769211079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmWvCri+lHed85zS4DWn2y37rXAZAy2Pj8fwCt9xs3k=;
	b=vOZHRcws4QNFGkVVl6YLAeOMxI+R7yuy1jc5GRFQHFOiDGuUuw4LyP8Pf7xUh0UiHOH+do
	bAebPM+nGfUIKwaWi0xfDfUDUBAcZf4aQMtl4MLLRugyYRx6u+VqgMN5tBMQ9t0S4igHXk
	YinwvB14Uh+qjlIdaQbQ7cLfVc/wLTI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nYRj4dvb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hac7oK2U;
	spf=temperror (imf05.hostedemail.com: error in processing during lookup of ankur.a.arora@oracle.com: DNS error) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769211079; a=rsa-sha256;
	cv=pass;
	b=6ZR3xSyjlOtWZe4fsyHqzZpOl3cGvDPAoFgjbu38xN3McCqLs34QAjdcnzSssHqn0JSqLl
	5lIG7XTfuKdHiv11OoZBEWxCaRKsC72JmZ4aolH+nM5PNRDFc0uaG5CxEAbyVnxuoJAyQs
	ufleBI+gY+/+SDrwHDHDRvzIbFimPgs=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NDovRo1884098;
	Fri, 23 Jan 2026 23:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xmWvCri+lHed85zS4D
	Wn2y37rXAZAy2Pj8fwCt9xs3k=; b=nYRj4dvb9qOe5R0Kl6YZRaXVYpQ31ySN46
	QOMuRYRi5oaPkMMAKI9+mdZxgNKRXIaPebnktmnF72T8FHl0fs5p7jCHr5R3MCdL
	qA7zS69viusf85s9eIWhp1khNweTHOq+1F4OXGg/KhfVeR9/x7pvg7Ro/zrSoC3Q
	oYiga3xQ31rfIOuwkREbKLcaecvFPEYRz5RqcQQXUCx317zUVVZrKtNukcxso2Wx
	pRNSbyAx9wD1m77HgJR+Ch9KNQvgXD/1Jc1YNXEVd7/Xt8ygqz1J3lULxwfMlCvl
	188eZ2GmeAXiglSqypQT0bGQoK6Zn/Da74TMZ8vGJ4ChBOeE2ctg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8ka16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 23:31:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NN8sBP035862;
	Fri, 23 Jan 2026 23:31:14 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010006.outbound.protection.outlook.com [52.101.201.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bux4ywh3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 23:31:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8uvFX7U7dNhre/m43a4pmO9tFNmJDX9Gfc5lghngo7L+5rc9NwZq3E/ktft5pnnp+CpIgNUAxLOF0FK1U4V1H02h9+n1aBEzkOJ0gHdFRTL+DeE/ZwUIRXuChTC5Jaz3zBEUVV1kB9G8ng2qMCbktTbrYVObCBTd2xO0vLJjB5xG88w6wnzda3brRKbYaZwh80uAsrZq1/mVl3cpESfQDoMIyQGgCcm3tKUT7JGnacP7Y9pUQ/gXeKDUiQjYbt55bAYfGSXDJR8JNjS5vc605x28PqquYYArHJcEWvMMHO9Q4JPCuESMzGHdZ22SkyMUH4ZrDOTLVWfgbIOUdlidQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmWvCri+lHed85zS4DWn2y37rXAZAy2Pj8fwCt9xs3k=;
 b=Tu0LDWJ5EJ1M32qGXeyRqK1WZgvyfsnKKHnCD/862mLltGdC6aDITrAFVFCijrc0pokuWizvFAcmhvYi1cytXHt1X9ZbeKgCyYZJqERrU9xS2tWyZYu2X4mKNK1Ib+2FkWbYcxa0sdCa3uuslu7G8dUBYz1Ivs37cNSSA1Ieh92kR4ofqOJ80RuvTmsLpvzX++GnJ7iqglHaXwAzW4gc/O5LU1nXQj4bYiOqEvOgRnSOKp4CbH/AAGSjAfZFvDOgi+x8L2fgfnKmiwFg8m1Lxqefhv975f0iR4mMPjlbu4S/CY5XD2QgPFoqdFMOfEFD1rALbJudm3ctyWUlxTrYYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmWvCri+lHed85zS4DWn2y37rXAZAy2Pj8fwCt9xs3k=;
 b=hac7oK2Uuw0nmo8VFW48mfgcID5TO0be9p12o/c1ky1Fz4s4vLiKo62/CHZhP1B8+VGAjFvCmgFcrnpXh7BXdyKg1knAi2NsHzAuoqxPU8ZCIC9P6Ub2C7zEpO1vCKWCbbl+ADMJVgg8BhsKI9sCYQ1uket9ZzSF/YURTYABp8o=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB6123.namprd10.prod.outlook.com (2603:10b6:208:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 23:31:09 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9542.008; Fri, 23 Jan 2026
 23:31:09 +0000
References: <202601240453.QCjgGdJa-lkp@intel.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List
 <linux-mm@kvack.org>,
        Raghavendra K T <raghavendra.kt@amd.com>
Subject: Re: [linux-next:master 7919/9290]
 include/linux/compiler_types.h:631:38: error: call to
 '__compiletime_assert_639' declared with attribute error: clamp() low
 limit pg.start greater than high limit pg.end
In-reply-to: <202601240453.QCjgGdJa-lkp@intel.com>
Date: Fri, 23 Jan 2026 15:31:08 -0800
Message-ID: <87y0lnewjn.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0267.namprd04.prod.outlook.com
 (2603:10b6:303:88::32) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB6123:EE_
X-MS-Office365-Filtering-Correlation-Id: a9638dd5-0a6f-43ed-029d-08de5ad77d04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h3W0/kav+TJZTAqMuTSzW6jfouWtwUhKzsIZNtaHfVlE8O50UFNw0FCdTCSS?=
 =?us-ascii?Q?05HOyBcOS27dPVK+WBQEuzSj2go+YruTFGQdTwfDduwggo426AlCrQiZgbW9?=
 =?us-ascii?Q?nSU21Eby/Hmtc/OYUYWkWBBdQe89dP5aX7LsVRxvnR3PGR1MJwPFCNvEmWNB?=
 =?us-ascii?Q?exE904EpELXYAJQVrcSMEX+1hHwxB0lfYvwLpGNJx5rHPfGHvWYTJpwdT7oa?=
 =?us-ascii?Q?Tdj8gvkKQozNKCVhDB5MCVpmbLXWBgWQeyOLWeBeECK4qkdtr55xHuJk0aCq?=
 =?us-ascii?Q?DhWzCNSOhChJgvBDPSgYVTEqtFFS5F2gSE7sbYRYnAqqfKGkPEE/7Fn9MnMF?=
 =?us-ascii?Q?nj8gpbQ3BOYM3gWNnQ9A0H80RyCT08oeYCHvdmgYIob0+naqSzfuLKK2YmYP?=
 =?us-ascii?Q?pmRGfQgculoKMax6GTcGidgW8Ze9/ucKrBksLWG5Mw8lKwPlvo+yFPk4WhFR?=
 =?us-ascii?Q?KO5H8m5Veu6ojqFpxVkYUEPqouTyP/7EkG/U2gVwYlH1Pxgo3lxj6WZ6j2Qg?=
 =?us-ascii?Q?rjwDpJAyiWPCFCkkttJPYvTQ9WbbAHarGACdwfE/W+ZgicIK6MPVp6Yl+xUs?=
 =?us-ascii?Q?xA1IfwCWaQywnbO4QbpZp2sMKrCP8qIf/0U0WSZuEWlwMkvo+Ftz2BBBHEcY?=
 =?us-ascii?Q?79HJhaq+EfuRR9PQ9BRVIx0DcyoLADHF4takMYBlP/oulvgOjabpZqrZJNA/?=
 =?us-ascii?Q?CJNr0Thnx5LBDQgLNJeavemVR0baAG/dYvnD3L7FkPgyjsS7KCbs7IncxEe8?=
 =?us-ascii?Q?SrxKEMs5t2ikr+SFJRhfW6D0dMf1//OX1lfZhRamAFnQipOGYZnHuVgSHIzs?=
 =?us-ascii?Q?ZVDk7oG3d1vhUPN+deCMgTbVEMnpFckM/Q0okkM1sOD3aB7NFHocRQ76okRa?=
 =?us-ascii?Q?D0zDjdIkwFB7ltQBYVqBCxzKsvOf4jYme6JCj3O8xVtpgmxbO6V/kZhNezgo?=
 =?us-ascii?Q?pk5ArBMsCd6b63rux+i/AJZ/AviuVkN4jvBZs34YS9gyhYXjIQdfFP9yU07b?=
 =?us-ascii?Q?0VKC428Y3o5YCeh9Y6Pi8h+cxIC9kP/pFla8Ifo/nCK7vSfiTvHS5e9JdfwP?=
 =?us-ascii?Q?DfuTtAv/7mcK4abNAXJE6QNbiezQbMFDd9or08+jRqg0jMy83xfBrjmHnjZ/?=
 =?us-ascii?Q?YrU0LeWt0XgZvbE/f/0LZmRgeCMqdGLZfXWXSxnxhLVK+26snWfilBbW+So/?=
 =?us-ascii?Q?UxLO/ol2js2rzKInL31bo+RPjzEW/4EcCHf66bi5eM/+5h99gIBbTNfoufen?=
 =?us-ascii?Q?VgWhclpH9CBQZW1JGLfMY7aum31PgdtNDjmBU6RzdUjC6UxFQvTSLjqyy+Ie?=
 =?us-ascii?Q?kg/pJ7GPGGuf8xny1xlhaOOoChac5gVZhv4Lfukj3/WREY+8XEPelvKN2NyX?=
 =?us-ascii?Q?MI9jcPQlzJiEPeZsJ4YeR8OYmlI7NtlcPhiZ0nqENZgCqm8Lmq3xFdZEb3t2?=
 =?us-ascii?Q?HjOV62Szo8x5qxQw/jUKXov1Uligyf+7n7KjwbLQaVItKuIzuYt9AOUgjfg4?=
 =?us-ascii?Q?XSwDxJWyQpXgxibNZ6kbs+vEf6hb6/ScvK/z4BuNMemNfLnVhX4XXGSkrTLH?=
 =?us-ascii?Q?VV8PW0oeYjFLTrVnO2/bzTZKYIef1fnF8pmACSQh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ph/4k9nVIfEceLgVLDse17E2zky1svvzQhe0CYrh0VT18NO4TenOwfRrJphl?=
 =?us-ascii?Q?8mEx0UkgiUMhaQmzepOCADuDz1+oKnucThQc2yALCb7LAYqXiEABc9sP4PEk?=
 =?us-ascii?Q?NiEJruaRj9FleMx9RKyZUMtkF8Rhy7iOAhUQgmJXkMkytycaMBnYIGcpTALd?=
 =?us-ascii?Q?Lix3CR/NC1e1JPyf1awrVkX67J4dvk2aufmUpc1csLtNY4vBrvBaZJic1vz8?=
 =?us-ascii?Q?ZTbsMhqmBS5KHHlPW6Mpj2BmiXBftQffozgeE5/Y8qloXLiMNMffzvgANnpI?=
 =?us-ascii?Q?y7587remYbu7LuU2hZmT8dVkN/5KLLonZqDI7Rzkxrm/qQRw96g8vEhXHop5?=
 =?us-ascii?Q?UTNYZu1WTQTCWLHpc9nN89ttZP3hDj+gzeI57RfYjzuQBLCVTFL7a4QnNO48?=
 =?us-ascii?Q?h1P9WUGrqPQ52FA87lBKRppAAzJgl0CE9EssK2tCo9frZfejlJj+2S0ptLqt?=
 =?us-ascii?Q?7P3Md1x2NRP4BaVNaWUAj0RszXYTtyF/OPTp5CE5fjIariMgFvnXXCMiYfs8?=
 =?us-ascii?Q?ailyqupekxgrZ+DlSC5qdYUwA/Eh94P8VkMPX+LHuLsUiIQg2ZFdnylmz2d5?=
 =?us-ascii?Q?uzVk19XrxgaxqCaXYZ2P5hFXe9/9zUURnJVlaB+VSV+Xw4Jfo5/4jKFrD0kI?=
 =?us-ascii?Q?qu/8u7ZWPkXKTB+3ltkvbszfg81GYMKu4Ojcf8upmWmyyZYbkuuKKuwrm2j6?=
 =?us-ascii?Q?PJjRM2t6SIZze/hIoHOTY7cCJ5RqjI8Jw23+uPwqne6SCRiVsSah1J1D4TGL?=
 =?us-ascii?Q?54RRtMIJZ8e/nZaEgdG9kXbyklwhNAhSE57WDnsoXTR1coWocLimRR/qGZkz?=
 =?us-ascii?Q?5fVDjXiG5M8xApHBU8kspm6X0shCafpkq6f9M/khDwfCyTNuS03S0TgTWLxe?=
 =?us-ascii?Q?XdZk38iqlbxm1GXPVUPv9enH5eO8JGsm1+WBp64z1/3AEzMl7P/V3mqxticl?=
 =?us-ascii?Q?KHBUd3QF1/b46e7KHlZiHp9ovRjdtnxMtDRNaqXKSpw/2q4ChHGWSMJstAiB?=
 =?us-ascii?Q?qyITYFAMUAB3iFcqqahdVspaBAw08NRoF9PTBjAvh/5xokp0i99g7bB0gbL7?=
 =?us-ascii?Q?LhLno9urEAj4KVHceJ8h7Z9dsx/GyvFnsTxZNOIzArWnKOc51N1pBV7FIJQg?=
 =?us-ascii?Q?AQSQdRXJ9Y4G83TG0hL2lGW9pEyl3eQPfiSJt4NaQaCCBAnlI1XbozA8480H?=
 =?us-ascii?Q?rivDzIFgE0BWIzKulIWTw2M6U46XkNVg/IuDDYgs9YDyZfNlc0MqYSmvgKSJ?=
 =?us-ascii?Q?Bii+7EED+Dv0P3V/munn7sUtd45PNqrRcLx4FnMprIfi0u1zMpmxuRJhoM3x?=
 =?us-ascii?Q?nbfhewbTN3NCNkq4AvsDgoOzAtsXt5RzXFffQHwQ/Mgb/RHV7MfAJZBjIJ5/?=
 =?us-ascii?Q?gHEEJkSNKQuonHOhB6YUsK71Szf+6kmrC60wU3baR7rQanw+EptNVRDAaC3B?=
 =?us-ascii?Q?3BsbsCIWLxht5b8Q6pUzee9HhoYSooT0oNhXrTo2TmN+qWvFuL08mafmHypv?=
 =?us-ascii?Q?/vFZFWqXiRGJe+MPVMBjP/7iIrizw6ZPJ5wOVKS1+eJLAziN8KFKXuG1gHXx?=
 =?us-ascii?Q?jieKFdq8Ad0NYJVVwhHPpTNrBaI51ffOtNxsWQlD8zT1h0dS70f9MQ+ArysQ?=
 =?us-ascii?Q?R0ge/t+0tM0dgwGMiOg87UJgNtONbkjokYfVFZpEBbdGnnjrvtWfDI+e/FDU?=
 =?us-ascii?Q?Zu0Tk/fz+JVt3BmA2o2erRH8p2SXja6Mf2hcQ+EYaqwiommge+KEaon6RWiP?=
 =?us-ascii?Q?xH7JKQWdT2ECkOmB9TU4r30xueQae4k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XUordkKgeFBjx0D6U6c8dpaznQkllbTlLtwd8dP/v7HeA9Xv/iVDfzNcmigUdA7xEg3wrzVf136sZSsFTa3PPOjd25nth7tefx+0DsgwwgIW8y6puSSCPF2DxKlDKFl0TurRiaki2rLUHha6I8KvVGbMErWPY3vk1/+v3fma15wy+nHLrhG51XQ0S3IElu/TdqyeQJeiGVvUpGZxxkaTFHAaumo54PSnU+wwWpVZQt/oY7e5jWHL9m3/z+++6ofBYQtABy/IjbNB79GD2ti/rUUAgRfA6IYD5/qyswpqSzkHw9J9OSe5seyyv4mah3kSx8xGmiwJ3RBL/CqI9NPFBlMe0MNO8qRqKPnhtfUihaR6ZB01jDd2SvF8x/sS5nUOI6RQmfaXrZ/p/0GBmojcd2SXWjHiqnVjHeYGxgYPBcjAv0n6lLaeVie1xX4/lSbBAoTXHqyEBjrgM0kDxmIiQ17REN/DSNTBoEdrviA/GyR/656tapZ3RTsxtrG+rqJEDTfWS4cUyczjVvQ44WjcMf1SLlzb/Qdhn2kpdICcfeLZUmWpf4o4TywNReXE7+0wmEhs+NNGHh85PRzOHFUZ30LDL/1D/Q7WBEvrBumkhms=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9638dd5-0a6f-43ed-029d-08de5ad77d04
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 23:31:09.6693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eI4WEowQ2RLNDgjdvR3k39A9DmknQ0dNhDDsnE0lyYMnctfuAeVd9rQ+E6NkJigvk91edAjxDfHFl9ZdensDbssgfLetkEyXJbiXGZrmJ2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_04,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230183
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=697404c3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=evHaNpuu1cDuUdYjmOsA:9 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE4MyBTYWx0ZWRfX+74C379OWPXf
 FZRqzHmJ93nEoq2smkuj+UIgWKqVnKKuJaxC8ELDndICWBc5L0UlJerGUsPLVaxvPLdn6R0/2Yg
 KUVx9qObO+UQj0DRUgywXAy4d1aRoVbAY/9ugDlRBB2LJrXqUhYa2MC4UNuoKX6Vjqw9Sepp+FU
 yrGBFaBFtSomqns8s4lOnbWOkFtA/OAiewyb+Dk6y3OVvY9Kau0TT/3GJrs/CqoLnmF6UO7vtJ/
 2VWLuZEEtiEwlw7iH3vQLo5vY8FfYd2NqIYS86up4O+Aw/B5+L1IpDi54ip5nvuWG4X5zA6rCQV
 fs6awcVPyv5VwBGiISTT8A+wrDpLSN193M/YruDK5SG/upCM03EcCqPjVrSRP6ZNFMe5ItzRa7h
 7E7RjVq9Jv2IGtUFAiiCTeoHLnJMqbtb+ozVmrm46K53qsjIex0IRTQGp+ryrgS6OCRshVi/OmU
 25pOyRSU9xz9P9DcgBw==
X-Proofpoint-ORIG-GUID: bqnqT-liHYd1Lr9tFc8kfYHO_J7hIQaM
X-Proofpoint-GUID: bqnqT-liHYd1Lr9tFc8kfYHO_J7hIQaM
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D842100010
X-Stat-Signature: 63o9h6zt9i4rjbxznnxsanwapfx47zjf
X-Rspam-User: 
X-HE-Tag: 1769211078-944122
X-HE-Meta: U2FsdGVkX1+4QlyJtZNNMh92K8WS/nd/5nW75xZmqEAMeirI6M8nNprl0vUB6j/NpcXxKCnSwRvyxinrTDdIgf04QoRqj1IrIjYmvn89agQeN2fHGHZCVoEy1wKD5P27UiIJ+evtnxDay5XhbtQwL4UjTN7cXu5dAs1FBzpJYvwvcwP0cNBBe7qQ8OU0WLPTW6gIxM4cb/SoAhJXFHMjbef1UKJG0msKctnX5ct+szKGIdMHabdo+fVGj8UpPmfe0xvtll7NbRrn4HOtmV8YBkAhTvUxZtefkZJdG3ZLwaHI40z0TtfdxU7RN+11D9ZOlg5/hUUfR9MXPWvvN+/t3bqTG5c3y9WPT0FfKeqZUiEt9fggX+C/hHYIEFpzfpvpAUV2NHJh/GfYOgx7ZRmx1dIPRDXjgy58vXM/t3aiheFkdeiIMgeEamsRz1vu2eydCiG0dWoMmv79KQG8I3YVR88YYlanZSgYA5iq1rzUr3O1oE5NIWwgv2jE5ZPrqQLywbgolKwTR3V0eioD/8uKQBGQ98sJVf9ZfQVzOlnHw9OL2YSluTcsNv0aIr0JnIxYTGpUZ1g87D7bEHfmoQv15Wslm9WQr0swmh1reI4wF0VrHpjosm30YUhSkxKfAW7hbKcCGVJ9kStCGkx6Zxyc0guUa2Qna72C6HsXQDlPGycFfjP19gnYWIdn7mxdmEZyWhhnexvLqIWpNAVHTiqFNTDW1EfUngsnjvIVksLJTiXak1J3jq3Z8nrTZ52c5q8/nDz9NyzV4Vv/u6I4Wrj+bBCalZnt9PQpJ6Jpj4A68j9dlSMB52L0p+lhaBYSIo7hgjE4yv/ISD85sUTR0QKeMAJimiWf26hJV2+yG1uilRPzb6kRfdO0BTyqbvIQZKjBSr6eCjVTRcuGKwUOWyp9U708gmFi/Rd7H+5k0VSBrY88Pk9w/qA3qMR0w2EgutqM8HykUajQjxLryFT8YC7
 vj6D2Vrl
 dNff6wmJFGKCFT14HFucHlBKeOKKTrvm24aGCVkT6WmyASB6v8dhXA+XVaMeuLC+qzHw2OneG1eeKWSAadXXreMSTjosBCuFKkuxOPdt5QNTIVeHYb6ovMovMOKhACUJHxYTC5lNFMcXly0MT/FpvW8qLxpCmJwgMWIJTvjOuW4SE3CDLax5T0D41Jq9pacCv7lmedbZBr8Fqqic4m0Kqhffb5X5qCLfPCdYq6CUcAT3DRfLeht4L4HyupdqTLHwINvlV1cm4oKpyEeM8BWd9wetlH5Uv3JzVZ1YS9S97cMwoDhrtvSWcmVIHYq49AbNyDPbjYY+SEhB1Y4ekj4PPQgVk5MjEhaamh1r4EKYl5TZtXhkigrrv4vnypohTIUNXSLWkl67I/sx6u2WaPku46POhhPRWdXkzs05efUz1wSKV/3p307cxk74PKX9WMk77xafWO3EoolNX/mGhH5+JfWgjL5Qdlw5iBSGwSobCx6oUlz3J/pOwMDXLAd2NPPnPW8pllr9MxadV9Dj3yaudWY93+RBBxzbQtPSkYsgaSuSF/odDX2Qy4v1VHIhFxWmFeHW7O35oXO+2TIfy7uZs8lVr2eJnHiaoah9w7YgazsE+3DSVqXJhftXtf8r3m1uH1/RJ/9TCnbKK9dImUz5gJTG9aJ5UDUZ6OCixkwc6+d+NMtz6HwMJ8F2WcY2tqFH8f/qP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


kernel test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   a0c666c25aeefd16f4b088c6549a6fb6b65a8a1d
> commit: 93552c9a3350fff06543da18e4c80d3e804191ca [7919/9290] mm: folio_zero_user: cache neighbouring pages
> config: riscv-randconfig-002-20260124 (https://download.01.org/0day-ci/archive/20260124/202601240453.QCjgGdJa-lkp@intel.com/config)
> compiler: riscv64-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260124/202601240453.QCjgGdJa-lkp@intel.com/reproduce)

Oddly enough I'm unable to reproduce this with:
   ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- make O=build_dir/ W=1 mm/

> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/mm.h:18,
>                     from arch/riscv/include/asm/sections.h:9,
>                     from include/linux/interrupt.h:22,
>                     from include/linux/kernel_stat.h:8,
>                     from mm/memory.c:42:
>    mm/memory.c: In function 'folio_zero_user':
>>> include/linux/compiler_types.h:631:38: error: call to '__compiletime_assert_639' declared with attribute error: clamp() low limit pg.start greater than high limit pg.end

I'm a bit puzzled by this assert.

folio_zero_user():
   {
	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
	struct range r[3];
	int i;

	/*
	 * Faulting page and its immediate neighbourhood. Will be cleared at the
	 * end to keep its cachelines hot.
	 */
	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));

the cause of the failure is that the compiler decides that pg.start > pg.end in:
  clamp_t(s64, fault_idx + radius, pg.start, pg.end));

which come from:
	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);

Now pg.start > pg.end if, folio_nr_pages() == 1.

Which would need folio_test_large() to evaluate to false at compile time:
  static inline unsigned long folio_nr_pages(const struct folio *folio)
  {
	if (!folio_test_large(folio))
		return 1;
	return folio_large_nr_pages(folio);
  }

But folio_test_large() is only defined as a test_bit(), without a
compile time constant defintion.

Also, the configuration has HUGETLBFS (which anyway guards the
definition of folio_zero_user()):

     $ cat config |egrep 'HUGETLBFS|TRANSPARENT'
     CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
     CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
     # CONFIG_TRANSPARENT_HUGEPAGE is not set
     CONFIG_ARCH_SUPPORTS_HUGETLBFS=y
     CONFIG_HUGETLBFS=y

Ankur

>      _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                          ^
>    include/linux/range.h:46:11: note: in definition of macro 'DEFINE_RANGE'
>       .end = (_end),   \
>               ^~~~
>    include/linux/compiler_types.h:619:2: note: in expansion of macro '__compiletime_assert'
>      __compiletime_assert(condition, msg, prefix, suffix)
>      ^~~~~~~~~~~~~~~~~~~~
>    include/linux/compiler_types.h:631:2: note: in expansion of macro '_compiletime_assert'
>      _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>      ^~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>     #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                         ^~~~~~~~~~~~~~~~~~
>    include/linux/minmax.h:188:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>      BUILD_BUG_ON_MSG(statically_true(ulo > uhi),    \
>      ^~~~~~~~~~~~~~~~
>    include/linux/minmax.h:195:2: note: in expansion of macro '__clamp_once'
>      __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
>      ^~~~~~~~~~~~
>    include/linux/minmax.h:218:36: note: in expansion of macro '__careful_clamp'
>     #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
>                                        ^~~~~~~~~~~~~~~
>    mm/memory.c:7296:8: note: in expansion of macro 'clamp_t'
>            clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>            ^~~~~~~
>
>
> vim +/__compiletime_assert_639 +631 include/linux/compiler_types.h
>
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  617
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  618  #define _compiletime_assert(condition, msg, prefix, suffix) \
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  619  	__compiletime_assert(condition, msg, prefix, suffix)
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  620
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  621  /**
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  622   * compiletime_assert - break build and emit msg if condition is false
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  623   * @condition: a compile-time constant condition to check
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  624   * @msg:       a message to emit if condition is false
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  625   *
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  626   * In tradition of POSIX assert, this macro will break the build if the
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  627   * supplied condition is *false*, emitting the supplied error message if the
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  628   * compiler has support to do so.
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  629   */
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  630  #define compiletime_assert(condition, msg) \
> eb5c2d4b45e3d2 Will Deacon 2020-07-21 @631  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  632
>
> :::::: The code at line 631 was first introduced by commit
> :::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h
>
> :::::: TO: Will Deacon <will@kernel.org>
> :::::: CC: Will Deacon <will@kernel.org>

