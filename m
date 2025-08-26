Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0FA6CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 06:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77C68E00A5; Tue, 26 Aug 2025 02:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EF28E0090; Tue, 26 Aug 2025 02:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D708E00A5; Tue, 26 Aug 2025 02:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 820118E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:59:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 265821A068F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:59:06 +0000 (UTC)
X-FDA: 83818006692.08.1F6E256
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id C110E160004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:59:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jcYZHXmU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k5MAVZ7R;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756191543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t1YNA/rzM1aXPGPn4hukxaZWxELAcC2M+VHujk6w39I=;
	b=NoCTvlf6OTvxiq9mOS8QLcXypgfsv24VQkgYhVVzmejv49ckAr55XnhkIU+oIKt/4q+rn0
	X8KuBTwNL4SiNo7HiwSGb93nxLQ6k7YNsRXkl8B5/9VccyJLBa41QoQQUZtb4ypGaRDOmY
	Q8c2mRXyBQCp8jPL25cnR0WXRuD6/FI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jcYZHXmU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k5MAVZ7R;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756191543; a=rsa-sha256;
	cv=pass;
	b=w2Ji1SarQ+zPp9zjE3xS9ZDnPJ88kJFRchnrle0QdJoxDszdSlgcGz1mtM5Kxc5uYxI15B
	iZCSXWaccQi95vK0/LEbSTaJUz7U/lb/63bXpCuOHtoCtyBjJ8itDceT9TiBrJ+uIocaHJ
	/wy/hx4D0x4/Wt8auGr9aMFijQ4xU6Y=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q6Blhv002698;
	Tue, 26 Aug 2025 06:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=t1YNA/rzM1aXPGPn
	4hukxaZWxELAcC2M+VHujk6w39I=; b=jcYZHXmUXc9x0IsixvJumPksz0w8eG8o
	ml5ys4ltj9Z7XvF+HiOT5RSOH4sdq/XxIrzsNQ7zHbhYgIk0SQCj1EVMek1ZNPrL
	Dz9qUJvZC55XDz4EW8QaHMZUthEmK/er5OyEAw5zJjPK5XHZr7RTASOAv+V/Wo6I
	fL0OasfGxd2Tpi2Nn7miQMFSMs1cBR+1cnBz7eWGIcsrYsZG7T2sjDmDk4n9aCgg
	J772ylYorkMkPXkfkSSSBe0DhpMx+EU+0x/BGmcL0UvrvDV2pBkmCbGjQbmXFrv/
	meUKg8pcz5/pA9nbykQCGMkEQJ3Caxlx343Nz4VQkQqFWw6Ej4R5fw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twahfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 06:58:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q6ncBN005017;
	Tue, 26 Aug 2025 06:58:56 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012033.outbound.protection.outlook.com [52.101.48.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj89dt6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 06:58:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qNJFQDh0zZgrAa71TRnIKp7/tdHipvBzXdB68w7xNbbWwMgeQodDslUUAmXx4xJxLhrCNM3/tKshNbhULd/n8KH6VIDSLn/g3kEpKyGr94xIWWo480+zsTjGWgEUnfTdIWFZ7KDUYCQUzI24Wx0L2crPeOj2IBN0GsD1HLGF9yZAi1kGVNFOYUmVs6gIk9cWxTc76H7AsE4jnXadDT/clDBDsGavcqIb/SoYhpsRPQ4KxzbswSGgv/uFtINm0Gsqkxj6KAN3m1pdZfgAjM96ockjkA83DqT6fI93kDMWpRddHB+6SSnuSCIwNbyDynbFQPd/YJJ75spm0TOo+VIL3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1YNA/rzM1aXPGPn4hukxaZWxELAcC2M+VHujk6w39I=;
 b=KD4ydc5VXoN9jMDnyPkESGP+4dPHgp+Hi+wRN2Qq7KrNx7EKrRc/CtycHhS7s1qGkidZHTbF8jqoVN1qRIieAZ7ulYAuAgb6xjCUEF6Ta9LomMB8SpZbhwJAcqU+6TP+O9FVdPE7YfhEtdjvHUgykcYTEKjAXnCyUc8QDyNpzyOkWs+nutebqNT8S+k3rEfwKgf5ZDJseDfi8zTvIVM3QPPkaImxp8VD2WLbM/YyPXGMD7gb9vqt9YcdYXrXy1qBP1JngVGgpmW6pswTePBNGDW/mj1fBRn0AWdin7vzmjrPj0UlQdmkFvHWeYhxIDCzqPFvPS1HHAfZanBUlUdGFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1YNA/rzM1aXPGPn4hukxaZWxELAcC2M+VHujk6w39I=;
 b=k5MAVZ7R2lHm9L2S3rPQWX4Kw3jKuF6g147AbcirCU/XM5G9O3T2tDcNhsxFH2anLn6Tyz0pqsDdIefjTW5XZDSwgsugm2N7XUWLUncxjdqvk/BxumUie02ocEJAt60cf/lWbsavK+s86/kvNZViFhF6+5ruUIVSjqRS2X9sGu0=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 DS7PR10MB5072.namprd10.prod.outlook.com (2603:10b6:5:3b1::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Tue, 26 Aug 2025 06:58:53 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%7]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 06:58:53 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V1 1/2] docs/mm: explain when and why rmap locks need to be taken during mremap()
Date: Tue, 26 Aug 2025 15:58:47 +0900
Message-ID: <20250826065848.346066-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0096.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::17) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|DS7PR10MB5072:EE_
X-MS-Office365-Filtering-Correlation-Id: e09a7893-0a42-4cd6-34b9-08dde46e049c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5OVTsSezSOraMVH0F7gmIZnWCHwfKKwo7JKGeT9hOH/4P4zAt9gMglXYkzoK?=
 =?us-ascii?Q?ipHBJS668/MrWv9WqNnbcYvaFBKlDRxWt4wJRd5AfnJSLfwhziuyT4IMJh+M?=
 =?us-ascii?Q?eoRoQ2Z13y0EB4tTD7tbqNKKwgSd58b+EXdLCddJP59LsDZ+/I2nyEQfMjO3?=
 =?us-ascii?Q?S2rhkWNDvN/UF6rJU+WiVW0aDz/Km5Lsa3deIRve4pIxLPm7LjUwLAc6mESe?=
 =?us-ascii?Q?H+tnrjsKIyN2/PHq/cdFU5IXfBgKjt3G5V0nXuH2jOku5Wl2rco5GV5OhCtV?=
 =?us-ascii?Q?0rg9YEEgtl6reqcaY5aNKDw05eBo63JLo/pNRu2Iav+YDvjmkEaC8KXVaL6H?=
 =?us-ascii?Q?l3jrlCqPTZTACoq0rkbhwSZPSnPa+K0S5Q7uoz+Q9DxmDiZ5kCMB7oDirCHd?=
 =?us-ascii?Q?ciajNPa82M0r+oAGJ84+rdiVE5c/yNP3kU3kxdJ4oZW2+0qjk0GQ11svZhea?=
 =?us-ascii?Q?vm8D+lXbjyot7Gs7cBGh5jeGnxT41rtJAdFn25z6Feh9vSsDSx7N3KuCdBDJ?=
 =?us-ascii?Q?irbk5CGaWYJ461KqE1sAAAR1mKi1XKgA2Y1gN4RlImch0tmnHka/cRfp02Q5?=
 =?us-ascii?Q?pD1DNMtx5Rl6u691Z/nbF3fpMceYt8Zn3el6vpnQVGza65Sg3S3WikOkkJUT?=
 =?us-ascii?Q?t4VQGFbmUWUYkEbs31BGTDcV/qa+3ymUPIoTggu6R0eJz9OxxnOc0LJXvk0n?=
 =?us-ascii?Q?bFwBWIpZx/9Q2w15/PUCr3WEhxOG88degSzq1e2J+LvJdu2Mxq91F9W0Ibe8?=
 =?us-ascii?Q?0a0AiAaoQS+k+zsCh5rcw3pf9E4CVZrKZXTvrv69aTscpFvVhP+SvvOgLtCm?=
 =?us-ascii?Q?ZOqH1xz5jvq3TXXaoGVW4V08ConaW3M/go6vu2AiRXcllif6Yx4ynFYfp5zM?=
 =?us-ascii?Q?yyqyzjGGjhCKFgpThDtHukN/XDQ660hEjFqQUN1xQSU0NUR5vfWi4ei7Q+V5?=
 =?us-ascii?Q?vavXcFIQc5w3NcP3a0/L1UHoaNGdVy8md4IL8dm9g7jCwBYE12r8MZSG6J7d?=
 =?us-ascii?Q?3E+gek/3U/MpIUYXtY8WVGVAEOXfBpCCEnn73GBQ7vZ6rg4QEWgYD2rhnjbZ?=
 =?us-ascii?Q?sArdaeiPIHclUqWEwTO3H4IvgN5yTkmhBo5cja5hyX/7beyMz2mxzrB0hlZ3?=
 =?us-ascii?Q?rxpBYgKV5nr92UnWXzwPPO9uZBMCEqkw+GgcWH1HnVwd3K64JxrKYH8LKYaO?=
 =?us-ascii?Q?Oq8VlVmILmaclcvt3IsxooDdeerq/mvMjmndWa6R9MjdYvF015USbxi4CWVG?=
 =?us-ascii?Q?Y7Uq5+FyAqWB66FrIwOMyqTlZu93Nl8DqeMcHCkZ5qW1QAzir1ZkudLkudgj?=
 =?us-ascii?Q?m0j5ZIDLolasVN3CNIHQiL7flyqj5fWIZz/Zx8KDWt5ThbYVLOoviuTb5rsI?=
 =?us-ascii?Q?J46lVRCCZR44KR8VdYK4A8dv86KGXL2OGVcGdfkX+ROVSTgnJhXJqdyd8q4L?=
 =?us-ascii?Q?Bh//HzOTk4A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ojV8FY7FrsSQW65Tyq3JE2y2NUrCjFkTFw/mjvaQ1y1vYrRMEZqQ1sNHM5Il?=
 =?us-ascii?Q?UV87CrthfpoK5PVtAxhnuCUCuVq38+nl6FiuOFOOAMXM0psUEXbUNfbWY06r?=
 =?us-ascii?Q?7qVWKlLnCzmsaQ70lsYUg8JSh2y8n+jKJyHSzMpP7/aPz9GCzilXAHrq3t88?=
 =?us-ascii?Q?CbpyWwS/biZ0YO+9KaYIA3gYLb4soAe71c+i2uQ/7FD7DsvuZQB98Zfl2J04?=
 =?us-ascii?Q?lI6r/IUMuI1P3d9d0fjugHomVoXoYks7X1AIBeA6+Zd2R4fJZ9xNWZF9Rd2I?=
 =?us-ascii?Q?nWzrP+WSsfCE65Ua0fhUhbqo6wODjqGU4Zd0UeEIpT1cU1qWiCGYigeixGmt?=
 =?us-ascii?Q?Dc+ninS3bSOXvUMnRoWikllkPh4FHAIfzR8je4flKOuZii7FXKyS+lwSV8xg?=
 =?us-ascii?Q?eHO3LpGcGHSDRO/MIk2LfEb6dhiEApuZkMbyRlknqNDdSPQv3le51wqj0CRN?=
 =?us-ascii?Q?Ji4EQAzDIdWWvVdz54DtfLAu3U0ofbDoOV5xhFqoa11KEalkujnPiqosCXtc?=
 =?us-ascii?Q?LoaCWqWi146+ms0GQxemJCJi2FONB54z9rJVqjLHjUSkl9uE2coUIun+SWpq?=
 =?us-ascii?Q?FJLwX6st29+y2hyQFsjzmgVGcftD3eU0BOzZwLUMSdNXVLUv01YqzycS+tXW?=
 =?us-ascii?Q?Q69rdMP0CoSRiNezOOC11PpZjsP6BWPs9mQJfw/wZPIlIlkSs2AlYt7rRCFS?=
 =?us-ascii?Q?UH147jCWcQQFe/HrO22zmI5aUB4ger9xG4GfEP5QOg0PD9TeYcMOSAvTv6+7?=
 =?us-ascii?Q?bsWvk80T+679nGkYGcfXq21dnPuGbgVR5xnXiKRVUeF+Ih+EUKqBdDC/s2U4?=
 =?us-ascii?Q?VYmrk419R2IcDS1B6aKFo9xutz+ix6oveFddGewyeNCvkEuBUVJjcjO3nXrP?=
 =?us-ascii?Q?h9MaDa37Up+jWOmkqzO75PJFwg4FMoVTzExAjEcwywODsAv14qtYVxQoWOpH?=
 =?us-ascii?Q?qvbNXwCM47nT6gAn+iiouGNKWddtRCqDVfrrn8RaWx2po9gx6GDvWaXCnAFm?=
 =?us-ascii?Q?+pxT0RQb3J48n5GuS1vc7Le8RhffwslZMBVogHWICKPCppjeYpzSC3+wrfLX?=
 =?us-ascii?Q?7Gr/yeNzPpFFNezeBWEAdW21wfhrTqHUnjNIsFlonkHm2xvnJurtGHiBFxml?=
 =?us-ascii?Q?na8F0g5ImazhF2AESFYcE2Vo5AZC7qUXRBOC+2o/evMsTtKEMHhclPbP3Rzv?=
 =?us-ascii?Q?VYFpHfM+24dF5u5gbIkEOZB6C5XZmC0lgpB6azOjqLM73wrRTNCSpe4cLUIs?=
 =?us-ascii?Q?UfsSGdbEggbWsKig4O9pm0OG4y3s8MiZ4CN13O5kDUU82ZXDkVfFjsdDWAGq?=
 =?us-ascii?Q?alTf9RzqgNu8JjZ9Nt8jiNNyR0kBaBtHxuhXz4AO1zJyWM9r1N2BW9zjoN73?=
 =?us-ascii?Q?ehjaW5wztQcON4hbh5zInG0g2zJDHzjuGFuZYBcY0H5kvcVAXj3NDzSXemHI?=
 =?us-ascii?Q?ueewTJNhmqPDDM+4yJdvIniDmUcjQR9VmPeSsN8bc4e0ljwo2ro6TmaWUzp8?=
 =?us-ascii?Q?bO7NsH1kj6Dsn/J3Wo9Jv4dw9/4oUF5bxsJsVXLAvf1sQT2cnnTOjTDWdNfn?=
 =?us-ascii?Q?23pw7APJPN856NMtRrWWg5pKwzpKFYGF4tZ7xK5q?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tqe6R04OAqnkAhvHnkL4JrGcIMy3AVHMr7RWAHXElIOzxZpshx/d17zc8zUTptaqLN6bI8FQFrr/kWDHCJjt0JHBib7iGuVJn48T3UEwC4aXl8foB8blGaeY8NUlH6RNPm6GPBk+7v2GE2r9RFtFsF1Gq+UDvWPHtKf/uZCPjFYRwxpVV9ZvkHs4hGD8aT8snZOI1Y4ovkulex8opBpdRnbzoS8KgIqI+xuM0KCJFKACqnN3NXSAucfGqpedA+8cPU3aNY6A58NzcmCGjAGxvBgEA0HK2f0i0fHW9kxENiGHpmsaUAurboeWRpBMheewMx2FY5+QMmE329/CKiXIVMKI8ZnWW8EhvXIeEBwjb2QTFpGxRCEgKRhmVXjiH2KZQMMnVQFLDpsg9YKd4Q8XCEsa7oJv/HA4FpIeM4+1dzxNKYXv3xftGv1huUu6hj+j/qW9RlH1l2KMD3C/B5alSqhueiEZGkQjeGR6WqR4Fgj8lraTDdrsBumqFu7goDaCwQIUgEdj3yJTpL3wUtRDD3PlClU407w49IP8JxRb/91idx71TCHXY33tbS5c6MZjMZNRyDRQtD+KxlWrchVFsd0ErZbELAtLnNKI9MLTsjY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e09a7893-0a42-4cd6-34b9-08dde46e049c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 06:58:53.3146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSn86iAILlfwazra9rIEVtXuTQdWoEZjRoFAaFZ9avcpV4/n48YnbVtsjbdMdTjsu5sH4m10Z9b/vBtpe3yYVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5072
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260061
X-Proofpoint-ORIG-GUID: HaQpP7WogurndviT5WVPQRk_KYcMi44q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX4s1O1BFOHRI/
 QTA687JSfIj5ygJ52Y5Tibnjm6l7gZARjchhXxf99TrjicgbJqkRi2ScvN7DIadrTJBFQ/LbBNo
 S3aXVlTchCFasboj98x5FPWWkkzHxpdIKq+LZGr2goT4Sdt7bvCdsFIeW3LH1o9ccyw3+qZZodb
 D3yD36Lr3WSmw3RcqmFU0eO26lj0qs2K2ZJOEpmN15+CDbrPJpztXW/bwg92P2ZT38jnZYkscmE
 0t4bjiraUjx8Hb/DpN5K4ZF47oJmj1bVkusGiJjW2ZP1zIYVXvXm7Dpa37T6OQySohYsnBDaRAN
 i2s39KOSqhXFI7RfmXzz5WThQxaldFD8MEnMMlyuthyZ7ObUd8Sgz9WaHCd3AwG4qp85NTAZ/+G
 x4SuiGXA2miNXqueesMDRLPGaZ5T4Q==
X-Proofpoint-GUID: HaQpP7WogurndviT5WVPQRk_KYcMi44q
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68ad5b31 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=ggdqdG2_RkFc4mgGnR4A:9 cc=ntf
 awl=host:12069
X-Stat-Signature: 151cfan88dnawp418f5mfr6o88p5n4n8
X-Rspam-User: 
X-Rspamd-Queue-Id: C110E160004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756191542-830773
X-HE-Meta: U2FsdGVkX1+ClvBh7ZbkU6el0nA/SKPxPFGIxj7Ata72YIllM/ZY9o7TFChOoxXk2Lw5bM61GwuZZgoR9DsJ4w5fKlOW4ctwvkYfdM+UzUg8d2SPCxp8dqs7WC2/UbSLW6DhhcfVYqTetrswqProSQi4FviXmX/4q82FLwWqtr9XODXsa+IH55yQJeIojlPYyWbdi+z4SCDiyp6LFodD9j2VTFDbLcwGLWz3qG1Z6ipR5jNG9/wJFKX06eJ7v9L3KqZFTCkLKZVS9Cc0YPSikGIUOGZ9mFu93qoMNbMn2Am86au+Xoa0SBX8wsxfiuD+XeQ4ekVfjvzB215bzH5fCUiAfEfAY/KA6ZQtgv3d4TUZcnYbAQZuFKwTLm4HBPnvC2an+YSlvlE1UqKzwrGTX4ny1Yh8q06TKqIRmLoa2ikd2xgEq7oXoxlm0B2I2HyM0BRRW1HCxoCT3qL/g/41QnQj9FqsGF/tiuo2KML3eV9gjbD/FvoJDWtNgRKOUlciNiwEqmGeOipH4J+A3PxpYl2D+gYXK4VJek2XmiP2r+f5qdFTNIONRm7eUjbFjARWNO10Pbij2UjGowIE/3W+EI9KO4TFEDOwCEmmXDvT6xOeVupw5cucfy2DSoWEU6Zkpf90zTyFYm7ez2mW6lNueyWW94LVH0Ok2T3aD7jBkSQ6cbtjFIQswhF5GzPQo8Z8zqRqPav5s5/QLkKBigtlCHBGuR7CI+mLpofpcYhX8leb0wk3J4WyWLRivPxBWKJrDb+jFrSwRNBKS/Et+Y3bkTYKrJaX4yeJnUWu7oUZjKP8BTxhK55x/TrN/VQ6SPgCle/0AgYPMiJAJEBzKx9gK5I6+URBmq5riORUUjzWXL1L4oqHCdkcjPeXrnWYrfgrn117Mz38U5xzDEgxZBkqxlJ7m9yWWEu1Z1fSq8tK4mEFrksOWa/gjrQTM5fM1rxnePMRGQli6EXTCc0Yd/q
 cYLQmhbt
 giSsXfE7P6TLIoFp1tkQKKzcNykzBmwbxpy9GXQsUnxtw5EABJGcO7+3CqIkYUQy+MHGJVSAxTTsUoJ8JckNThjsz8An+5Aq41hlFcLikt9R7XK479orxWjI0qAuMo+nHAwqmhpu4CqiiKz80tD6aBMnHU3mhcO5TJ4ZvnTNWXRzk/PMo0U/z8mkF33F364IlEgoHnfksVFffN6ihOa092w0/eSIKplchwcKa4kAEIuA3cZSSRqWF8tgZ3X5prLy8cy/lAKRJ9KUBDPmLRqnF27X1OcEJliJOCsY3gbOEt+rayZ6q+V7M081qDSYa9XpoCapZLm9VjYeZ3O0v5ku7iuYtyVewz/y6HGWkDm0wgXzEGjBBDN0ccB/Bbwdzkpz9KbL5r3DoaHfBIeoRmZeioX/2Fm9+lNEZvstsMup8xAnRmIme73acy5l/q7+49GqtA61lTMiL9L1ggWo0OTHL6c5sxmJA4WnOcWra2eqciV68RogMoJM0avAt4aywEnF7VLfIqHL0rpjcYPIJtPdmx0hqLu0emfYz+uuQ7aUPcH+S9js51f/OI8T/UFeNRuTck4JW3/U5OqM0kk/0dJNBzizNcaGknAorYrwxejseTF+CGkmW6KIkvidgCgV5jo1+RxRvAI/QJ7yIXYize8sdPYXN8HZnLpDJMW/HVBcT1DIe4pmn6KalSlfmWPzKkuwg3GWx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While move_ptes() has a comment explaining why rmap locks are needed,
Documentation/mm/process_addrs.rst does not. Without being aware of that
comment, I spent hours figuring out how things could go wrong and why,
in some cases, rmap locks can be safely skipped.

Add a more comprehensive explanation to the documentation to save time
for others.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 Documentation/mm/process_addrs.rst | 32 ++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index be49e2a269e4..ee7c0dba339e 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -744,6 +744,38 @@ You can observe this in the :c:func:`!mremap` implementation in the functions
 :c:func:`!take_rmap_locks` and :c:func:`!drop_rmap_locks` which perform the rmap
 side of lock acquisition, invoked ultimately by :c:func:`!move_page_tables`.
 
+.. note:: If :c:func:`!mremap()` -> :c:func:`!move_ptes()` does not take rmap
+          locks, :c:func:`!rmap_walk()` may miss a pte for the folio.
+
+          The problematic sequence is as follows:
+
+          1. :c:func:`!rmap_walk()` checks the destination VMA, finds no pte,
+             and releases the page table lock.
+          2. :c:func:`!move_ptes()` moves the page tables from the source to the
+             destination.
+          3. :c:func:`!rmap_walk()` checks the source VMA, finds no pte, and
+             thus rmap walk misses it.
+
+          Taking rmap locks in :c:func:`!move_ptes()` ensures that
+          :c:func:`!rmap_walk()` sees the pte in either the source or
+          destination VMA.
+
+          There are two cases where rmap locks can be skipped:
+
+          1. If the source VMA is guaranteed to be visited before the
+             destination VMA during rmap walk, :c:func:`!rmap_walk()` will
+             encounter the pte in one of the two VMAs. VMAs associated with
+             an anon_vma are organized in an interval tree, so the src->dst
+             order is guaranteed when the source VMA's vm_pgoff precedes
+             the destination VMA's vm_pgoff.
+
+          2. When :c:func:`!exec()` relocates a temporary stack VMA via
+             :c:func:`!relocate_vma_down()`, there is no separate destination
+             VMA. Instead, the source VMA is marked as a temporary stack and
+             relocated. In this case, the folios belonging to the VMA cannot be
+             migrated until the relocation is complete, avoiding the need to
+             acquire rmap locks for performance reasons.
+
 VMA lock internals
 ------------------
 
-- 
2.43.0


