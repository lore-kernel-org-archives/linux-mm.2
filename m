Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1432EEA84E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 20:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2AC6B0088; Thu, 12 Feb 2026 15:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80E46B0089; Thu, 12 Feb 2026 15:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37996B008A; Thu, 12 Feb 2026 15:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D29D6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:56:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 346041B3CC1
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:56:11 +0000 (UTC)
X-FDA: 84437012142.05.BE05AE8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8CF4BC0008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:56:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="LLrZz/JD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nGP5tRm5;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770929767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYK8U74+DDaUBDrdmbZA3vQzrUtKgdW3t/dglzaD5K0=;
	b=3tG9BiTyL9fni8FjLobsuUzVG9Se/Iz3XBkyN+pXLqcki+T16k79OrlHrUM4dMEZ0k+z2n
	kNs8M9rUmchoDw173/TsVSQMpmZzjiLdjRCDaYSZjc/yQGfhscAy5xVoHe1yC7dbN3M+ca
	dByusJUYk28wTToxsC3ATuGmWNbtz6w=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="LLrZz/JD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nGP5tRm5;
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770929767; a=rsa-sha256;
	cv=pass;
	b=2DoAvnIG6ReEeRpsQxS80RAxENAFPVUKdbcqmmA7i4JmgSAseDp81NonEs35EO+OnDNKra
	Bf3PPxviXKv3YsDDgnGZUdiRNQq9YG+DKMDr3oZsfwGdL3zQ76oTxZauYd9WLZmed71dGj
	W9jX6lsznKifjdg9blPKfFyLx/HEjQE=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CGNP5p592151;
	Thu, 12 Feb 2026 20:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IYK8U74+DDaUBDrdmb
	ZA3vQzrUtKgdW3t/dglzaD5K0=; b=LLrZz/JDvh9xt/26XUjj0yj4sXBHtRMTA/
	oRZ/sLK0iGEM9J4CxG0PQZO0I7PaNgBxJfzgWy+5xABIyPviKecx9NzpS9lUtcSt
	A28jyio9RnUL/xyhn3TtPhGvXkrvaGsrq/SNE1qSdPyMxxptOryYJzbbHYY47Ark
	hULxu12qrjNBZYA+reTc7PJ0i6p+avdawggDf5j47jZtdncjVOjA8s06/6XDyL3C
	GxMa58BdvFMAdTILCYN2/YVyZZ64lpJxY0D7U2MAqSUU9xJsFAGtc6UywnnW3E31
	WC6j69PkZNTmaRJdGMVuhZdgCWyrdUeRKiczIeTlz9JBjLyIjnZw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88qt4824-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 20:56:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61CJe6o4033004;
	Thu, 12 Feb 2026 20:56:01 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010009.outbound.protection.outlook.com [52.101.56.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c825wxub8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 20:56:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DZOLNiQiXAfIatkTrD7oKSROp3e9/P8mtfMaLba340zb0xxd5UaiJDijBxQd20Gg6zKzRg6H7j5YEBCyiZfOoplpIx38xVLFxzXC3sqy2Lyu2C4SZ0LCD+ghPM5XRTHQm8lOWo4dWl2GzrDu0FO0UW1XAnHfFTs7ld6mDV5FbmeKhg4iuGYxEurPII8TjxBwCzhe0Zng44SerTMZHDpM6meWCk3Xox6PvZ6kuI7troCXIfhasQx4WcFxVSkhfSM7IRmjVdOMq1MiUuk2iHzyibG9mIEXcN2w0NESjazB6SP3/ssC6yAWJI+MkaAbcaaOXUOA9c4ssV/som4AYsuuKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYK8U74+DDaUBDrdmbZA3vQzrUtKgdW3t/dglzaD5K0=;
 b=Nwg+6udiTsJPdTix2yRB8td/HtmsHKSaRuf+MYM22Dlc39TURGlGT5asTZAiZNSPcH5RtPfWEQ0E/BKtjWM4eVgtGGS+vhq6tU7SHovlhvL6XyWgoqE2VbwKsL3b6FHBkLdpyT/76JH91AfN4tQzR7dKLMgsBvg3ODkLqFFviYN6bkZshaz/yrqCWimwpORWal6wkZBr/QDVyK3giQj5BJuY/3VYRUIAYH1FJ9KCmliRVX+LZ5XsMuL6eXKBt0OElTtiv2OaoV8kk377aMGnzDJEopQUxn8vSfKOO0yRaUDVJDMuLC240bNAmzQvVGyhkJy7O8tH4YmJx/06MNOrxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYK8U74+DDaUBDrdmbZA3vQzrUtKgdW3t/dglzaD5K0=;
 b=nGP5tRm5lNikeFVr7I0VrXD2pd9J6MfxQ2/ae3I0KErQJY3KRqIq9r9M0NKMDiJmWvduJrkNJ+/sUDmTcLJupA7fmpyyrqWbBfswEH+Xn0NlOEGQJaAJqbdtqSD2jKAo3ZWE6IAA692PHTKJNk0oFz9posz2Exsw+zO6PS3AbMw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BY5PR10MB4227.namprd10.prod.outlook.com (2603:10b6:a03:208::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.15; Thu, 12 Feb
 2026 20:55:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 20:55:57 +0000
Date: Thu, 12 Feb 2026 15:55:38 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev,
        surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in mas_walk
Message-ID: <muuhcv22gzsr2a3g4lsu4zqsjkdbjqxn7bszh7r4nuqgq2oc5a@7jqpwr6v2vez>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
References: <698e287a.a70a0220.2c38d7.009f.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698e287a.a70a0220.2c38d7.009f.GAE@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0353.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BY5PR10MB4227:EE_
X-MS-Office365-Filtering-Correlation-Id: aea97ef1-051c-42c9-c062-08de6a791e8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/afg3hs8+d3GEaVjoc40AF1ozVJlzjkvAlR5l1IWQBCFrmQPZAVYSQwq2VjX?=
 =?us-ascii?Q?xprxwR7LnpLe6jc79O9GMKHh00yxd+JUltaBWGsFxvPogypx2+gvfdqiE9CT?=
 =?us-ascii?Q?7tYdZilvmevej9R6BxHaRcCCvUwsjgFQYJCTWj021JIWQmGPIpOknktc0tDU?=
 =?us-ascii?Q?TfO985XwlSRPTN3gWrzNSXb2FIu2Hyng+UmNGIKgkH7to8iNNB0NPSfSo/lv?=
 =?us-ascii?Q?C7VI1zGs/KBY0swTKUfAlAK8fp1kqt/vcRWFT1MG6CZhFW2+YsH76Ap1Ixay?=
 =?us-ascii?Q?XZYj+1Fnp1raWHsZPmncWNw/8px60OEaT7waNMLN+IysscrZZfCnGq+NBESW?=
 =?us-ascii?Q?epST6NLcOkjGjaMTPvE2Ii+qDNPYGO05b/Kj3hJtkOIA/bnCpHXvYVvLrgp1?=
 =?us-ascii?Q?3LgvTs+UQ8uTgEs/tH9u0iqK8AlDllnl0PaYKAmB5a86hQr5suDSe+flo+st?=
 =?us-ascii?Q?5PU/RFt58VU/RjzVPuVxxIbx+DwHIUtDflgtg1WAgaPwV/JnF2gCjJRjVQAI?=
 =?us-ascii?Q?R1bGegS4Nzp45BPErWUB63ISqRDdXdsS44wo/yZ8TRXs92O0FB003IO4PhyA?=
 =?us-ascii?Q?AZ1f7auzXzxXwUxdECv1iYK1TrtSWi+Kj3/enNU/ctY6sy7ysdWY8qPKzok1?=
 =?us-ascii?Q?mT1DA3AR6E28bKZicneuUHggUIz6UpmpNL+/l/tEJbMDyy2dJAEM/6Yuc6mV?=
 =?us-ascii?Q?6TLpCvZGBaDLXXPIm7PGbNYKQvX+a6Wb+azuh/BzX9/Z5icTQADkUhYYaUDI?=
 =?us-ascii?Q?4ki52pVosnC5oJd6Jr1g7atVFGeoMltuG4+bcr2f56MiwuphcRvPlQz1IxU8?=
 =?us-ascii?Q?b0FAEhDYT5j48++d9ih8Fynlr+Sb4mpa+KavvrTlluUCNf9uE/SiACyGgf46?=
 =?us-ascii?Q?h2XabfXcW+n5ZYSN9VWCjsy+pKmMhmmNxQqGWN5aHm4VF3Vd/Ytb0KA2lyKI?=
 =?us-ascii?Q?fegjqLDQH8Wofbk0jkKoxMPGyI9PtALjSZNCpradtfcHtbFLIiMucdq/dC43?=
 =?us-ascii?Q?b8hfbTZQgoinGncxu2pAEt7khsx2u1WC1/0QkhjW8RAn8jBbpY2ojzv/xhPO?=
 =?us-ascii?Q?/7klOyPAFwvAAgIcz+ijt1p5tGRdu6V8KvrkSaRIysjRSGReKoIpYMjqgdN6?=
 =?us-ascii?Q?m+baoaVbZ6UdUOhwXFj8S8/ybdvduhJsoraTiWF7G8mClbtXRTzqBeQlQxh5?=
 =?us-ascii?Q?1x3EvOVJGT2mAyZgzPliMvOgmaz7SIeHCPLbNvOM+ga3YVAY2pSUfudxTwOO?=
 =?us-ascii?Q?BNbXoEq+z2Vpria1JDJCcmKbOmnVVt2vyJiLX2M2sWfWxkw4xjN29dzxR9+0?=
 =?us-ascii?Q?VbYxOR090jtyfxqsufIwbwr7pqLtY+u3mUxXKYaroSKzt/uFBEnkI1zYvbAQ?=
 =?us-ascii?Q?HwwDk5c/ZEXwfGnKafdkGiw5CUbt7Ihm00Pmcu3E818A3hKBhlcm/+mPK2AS?=
 =?us-ascii?Q?/a4KavyMxdpz0jZKKoVOa6Z6cgZENzKnwH05DEPNeskoy2OzLrTLbJkyCP6G?=
 =?us-ascii?Q?sKey5k/f0STbZhSd/Y/pEaP5RMWqXK+gHlW1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rfFswGmxHqSumVd1Mkn8biingYqckprph3vPLyhloyca1z/kI7qob4WOoyDY?=
 =?us-ascii?Q?BhlwHjzVU14KygNTafc5YdVcxvpDnRcNvC7CECOWq/sduMwqdKD0ZghcjKUj?=
 =?us-ascii?Q?ZEyibbOM0q7SuQO6fio9pzOj1mRgWAOuSzPA41gm+7AzxfK6iHCs3Z6bRtuI?=
 =?us-ascii?Q?+8+Y3B8BWRqas8+/FY28vd7k9ghBnxHwD64K8DZEIeDSuPJwZ4hlw5y975vn?=
 =?us-ascii?Q?j2A8y/GqYKvdTlaYR7VSiI72yAjJzwc+jZSmQgDzBbbVCmjG3+b3b5JC6yJl?=
 =?us-ascii?Q?dGvfrQ61NnJw1545DrOdYj9ZLYqQwtxlL/NwQXSZZOU7vQuYMEFwqbV19kA5?=
 =?us-ascii?Q?D4uOVI6N/9XrpEXB1Hug5M+mwzBp4LuiOlca3IV++aSG4NukD4ueNQTkkhk8?=
 =?us-ascii?Q?t12y9MfR6pVE9EkKN9tnGZ9ybyHT4z4EkLkT2zyA//+JgOrPQ4zo/roe6A6I?=
 =?us-ascii?Q?OcDflwkF3MfBC77nrS6z9TNzOOGAYIhGtIXZZbL/yX5PDzheD7VrdacyVyht?=
 =?us-ascii?Q?QsEU6bSrk/61yLiLru/rHgMUgEdOcMBMyJTi0i5JhQZ0zDaNRmeuyzHuG/h7?=
 =?us-ascii?Q?P3bZmi2lurTkliRTMUbNANElIDTJcvjVf7fXCK95/GiMqsYxtbItcO50WBwi?=
 =?us-ascii?Q?BhASLr6Ns6ZOa0EQZ1dgSRHQD+hh6d0JxC5AOX2BIjeoslizi67pFmGco+hF?=
 =?us-ascii?Q?YO24WvlBjCUVNdTjht0SsY/mDYIJUif78LYqSRX+5Froj90iLcF1kJCXdhS1?=
 =?us-ascii?Q?S99faGTFoQ+HLwxnbAmglxLWnH4qZD0bc/1AeseYOmCJJxEGRK2o3+E86kJf?=
 =?us-ascii?Q?M1eFbfKV0ET16nMjPwGVWTRcxt0qzkA/fNBa+qNTjaL29/n6kxQsEMjz/WV2?=
 =?us-ascii?Q?BjA4vw8YODXSwjLR+ng0X0fCajVu2YanGKhgFgRbKpy2jdXQ5q6W+T3xbykZ?=
 =?us-ascii?Q?wcxQxVROXeFH2F2tEkNm3l5Isb945c+nSWq28a2wQiVALSaXpsuGFPbX0YMn?=
 =?us-ascii?Q?khUEIxheBNWV9veEnM25pEZnxzDXUwd5gr7jLbPKV0hFgEyvlz3dzA8JCKjO?=
 =?us-ascii?Q?kxuJ0pjHK7hJhsMs0fErvvrdxE9ddgeeQDLT150Umk2BKmvnGa3Pai+D38u4?=
 =?us-ascii?Q?FnKupBMbs+Ia4QmOQzJZJNdl9NKj5S/AInOgyUm8tvaWin/Uo/EhOie4E4sH?=
 =?us-ascii?Q?Zin72W4eA3qSzE9hFSHFGbhwofrMuT1rzpvVrKTURywFrVNJ0n7APf8b3sut?=
 =?us-ascii?Q?gIgvrJ/WxoK9YiGqUKWjFFz7Pshnrj4N/rSm38WtkwZYmbmE0h3Jj6KRhfw1?=
 =?us-ascii?Q?y+hyAfN+SpDzhTwm+er/y7ew+OWk69k+ATU3HrDjBpgKcTZV1cVt05jl96iF?=
 =?us-ascii?Q?/Q+YZBBkWpkP2d/0Wu3mIjxu1aUdxo17IyAgFfESQWVf2jMx0/PfXpdGTBb2?=
 =?us-ascii?Q?8sbo3e/U/axri11wtn3o6o40J7xUTFnjNuNzVqpe/anLABoCoG5BTlCHrIxE?=
 =?us-ascii?Q?G2Ef7cSaWJdsWSd19UYJlV3+s29i2N+/MN0co3ZlH3APUjERtPvMWVvOv8aC?=
 =?us-ascii?Q?utRCT9zhrrqgnZ7FxwpQ5I60a86j8efqHI4WGh74Kv+2pjZIwoNwDxeflEoe?=
 =?us-ascii?Q?OheZPcpI7w5DT2XpJLI6rvtZ6ZcvZVNSBdqWH0ZEEpFlNDxEkea12t8kG/hq?=
 =?us-ascii?Q?xFu2Gb3N01JCek1oBRKdyXdLXWkzCENB5ds49W6uokx0JBvgnRd/3jhEUaBn?=
 =?us-ascii?Q?W0tEzTtG4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DbCT9P/DerzjE/4pNJlZd4k5BnzZOfEZYoSfeyF0E+SXlJ2ka+bu7tUWx7G8K0GL48KAtY6AUXdWWDYq132aCdcAY5JJ3/iWrqZGSOnqnMfqVc/jQbOyxR5R3pcOf9B5w+GLcNMTjj4MwUzMTDKKHYRXOU+7x9Tl04nUrtfLPV+9h7W8zPhEg3M4K61Nt8Z1Cx1lvdf1MIkfm6jxTVRTzD9k8quJAOitF2cpmH5HS4FAZ8m6G/q6EXpM1buR6V/jyDY2vH1ukDZohe1Jgkc3W0G8YwDHtcU2HAyzr9ER1jEdsNVY43CkiAR/8u4oEuh+oyHFKuzju3qU3dQw9LVwpjHlmTr/9nj6DhB9SFTAKQcypmx5G6etGJCkpjK5eHOARwzYijn1J1aKHFTxKRgHgRLegHaEwdwxhsOh/k7bm6HI5zqky2FEKfzcrp+rlJ1s/t7T/J830vlSyxTc/8JFF0znAKB48bKcF2JtOAM2QUVEmlo/laSS9rnWbb52ABEobR4biAviNTY07fCwce7tUGrQu0TKI8/kfAi+hk2toYT1fD9gkdWwtWL+w2fLfmwJvPqGKkovqFLq9QPjfDPqm9wcUu9S1pwIzskvnenfBwk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea97ef1-051c-42c9-c062-08de6a791e8d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 20:55:57.1075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoEzQIX10iEOFY4meNjS6x59ZIF6OqKkGB0n/C//NZvpM0on+CPVzZt8a+pyuhUWA8ISlnJH6clZ4dZfIicD/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_05,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602120162
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDE2MiBTYWx0ZWRfX5fsSsN4KBcwm
 3KR5YNmBajWWmFhSFOq0zabo8ZqNucehdy1vGdCNSoOHeZP5iv/dCJhH0N5PRLJksCNImavTRXh
 DjvwXURrObaBdS+h6RpLYIo8wHm2b7a3iLdQD19CJWLDYM6WTRHyz/IM+V99Klr9NsaQzDHtokK
 h2Te6JwjkIxYmJ3HfUrJZH01SvbJHCjN3qwfJYJOVbGWKdaQ2LvmwB/BMcN6lEXWi7rQIKMIf8L
 nhFnS0h3pJam6x33eA48j06zcDDV6AKaZT9rI7rn5Z23F9E0l1nEKzI3IrQ11AXxakBTorOldtg
 0Iy2aRBRQbJD8y/nsftMXDNwt4MTcpYgzM3cvMVUJqlpMK75UQtVEqh5tbzNPRxbkP28WUC6ike
 ++aVJnwc0JuR93PdnmfRERS63X0bu6cFCc8n0FOo0l9Q6Olz48JON3w4FsE7zMDf5zxkdP1QuPY
 g/v/A5krJKHsNjHxYFXpNkokLjC8TZKqt4vMQhH4=
X-Proofpoint-GUID: RDhzDYe5Jaonom3lIZ9G0R6unf15W3Nq
X-Authority-Analysis: v=2.4 cv=Mehhep/f c=1 sm=1 tr=0 ts=698e3e63 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=edf1wS77AAAA:8
 a=3g80flMcAAAA:8 a=hSkVLCK3AAAA:8 a=VANuwJtaj1VicIRuzXsA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 cc=ntf awl=host:12148
X-Proofpoint-ORIG-GUID: RDhzDYe5Jaonom3lIZ9G0R6unf15W3Nq
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8CF4BC0008
X-Stat-Signature: eai4kcyyxwgez9d54carwymqxd7rrt1k
X-Rspam-User: 
X-HE-Tag: 1770929767-362368
X-HE-Meta: U2FsdGVkX1/WeEXSMZBqCvfHkDDBi95Ows2FwBKCcm7CsFqQkkdgp2GgcZ+C/Kc52tfcl633HiMlKo80VqqIXkDdfio+KO+hPsCdpeJZ/4fvewxkuLTvRNHZR7GPAdeEN8qbcHqDQZJyrU6A9d6a3bk7DQed3ypB02+6n8yhNxI2dD+GYqEjO0CupL3VRl10H6NELpMtf6ufeN5Ij0fVQFdFLaXE83U4g3MIHzyd8cKgJ/PqCDJ8qJFQQnkiO5fwf232ZcUy9ByOHZD/O1y1CrWQRUPL9Dum8fVTncZCM4azh6EPKXGoorB55XNEG/hWDkvNwHVQpkyAxSsNqPKG70uwXkK4dDbZlfW0O19tMGX4gS1cImu68JTAuyPt+YzSXC2BL1fCexMjZjKcL5JBQnrAUy/9cGK/KU90YcaPycl8g/204IHpGDGvYTbYq9/fOHVwKu2fFYOcSoX6CR16bepbAZQjuRrxiEYntw+UWeNhdz2ZCLUjirD2CjGw8ynbbdPsvyn3v275npCpUBsQfUV8yw0abB/0eLWSkCtxLxbdyT+0fpBSVS5TnlpQWldpWYwumPBy1bojZ4kCRvlT4np8OaRhwaac8bQ4yKznaQsChp2URzzkw4hZ1Jrz6Of1JEL6dKJdETUHYMSJqSPMfvUqsR0fAO1g7xSjAn0JYpqIVMY1e81H+ODao9U8Xo59a5A+ZFQsOgMWY1cCU69zk0eg5OM7ydJyppzIwwSdG3WKCSlnkmM86VnH+EBm/wuGEf17EcsjytMmv1CGgWKUta52qRoRIR78gpWj+kJthWAmSGpFmhE3ZgUkYbaOuZxGDvdU7mi2kvOMPvpweeOEOsoZ1qRFyFq+CSWLJclyMvSwWnZ2IN3nIZfKJg12LcM6lW9EasHF/Qouk65aqlWW/Y2OYD9CEEFxzwX7DMFdfUmntUalrxuOlokn3wo179FmHaKeyM2EwJq11SXgAz+
 Y96GEC9G
 Y4NWluMrZ5Xx6hH9BpFOtT/m45HpJknPX54Ki1C96vbw7uRbePTvMq2bPMi4azxi/prG/H4UJPmxR1nBQkyBWh5XXkMXg/jyUQeEWAcTmGMaxRS4cs1SEUpCC5hHLunyHKlTTdvaiQa3CVCOczgoa8Hr3Ct/Mo/jRz068/PmXupVze59+rMz/TSb6kJgWzM6dg6rGwmNb0AJJYPCrUtqefAw2eaUGySXLCbA8+bVgddkCRlViF4/ZP/lDnzWv8hTOfESosJp7avW3NsWMwxo2gvKjcDjweBHZhJ3up+A1NLfxpYDhIMMDIU4G/9QRNxb6CAB6+cClZntyCuCcTWNniJAftV7Sr0JlfBDpBz47MQgBWz58APVVdsygXEHhGOQf3VhwftwZ704LxH7aPc2agId5MsXJExWA8CECNwEMD9NPaMe2yCcr6mnaPhaieaEZ26MYaLpXqd4pOfHqN+oPoOHt+skKiCgutgVf7L/suzYqlmWdnVh4jbbmV3OaTg11CjJC+9zzOU5R+bGAec8Z8N3nn0i+21W3r49vOdiHHgaPQFP+QJ3mjDxd8tNxhCho9gnQEHogr4/YfqmiciwZHXmzfO41gDmEkUVstLlOZrAvG6e569802o+UsEycQcx6QS9HGeEceVl84mIZEkMhZ6Zt2THCVXVJXLgiMhXVFPdI1/owmHlbFJWv/R5kGbZeI8bRx0sqeAJEO3c93ehqfsTArJHzni8BDnkoeEN+78jXk/cBGPh8RojXmPmfoLblM3ayUJ/DLngLf1C/fsvqR8IsKBffLKghFmJv3Wr1r7XXKN55MiSdd+5QAG11it8ik2pon35XMxIGXNPgFHFnyltZYKFeigL81wWikSISkFS93OtHfqBYvhW+YC47RgiXlxIPG9Cka/qQXjLKVkliJd4/7ZBA0ZTB4a969oLZN1U6MbmyyO7kRk/GT+QZy9QZVE7SYpnOVaZXLU5+cTUiWkE5ef6r
 a1ThzYTI
 H2k2e2l74o0dhSZxOiNCQExyl/O2PVTV47dvIkjdnSPSoOG+ty9hw2uZ19u4KxlOHGiOaRodItAVeU7Jk+lRlctavFTv/wZlY6FprufCPDdAgDmQoK23UQu9p/FVna2A+VGFndnNJwvAtmwMGugCIL6O7Xa46EqGzf5CU1DvZ+FuSw45vUQVlHMv3QfEZzsk+tk4Hdc2t/4UGo4hazm5VFEXTWI1TiowV3AFB+wWQjw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com> [260212 14:22]:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    192c0159402e Merge tag 'powerpc-7.0-1' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1304cc02580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=aaa1d655bee4457b
> dashboard link: https://syzkaller.appspot.com/bug?extid=54245a237762e7cbecf0
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d40ffa580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1704cc02580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a42150718371/disk-192c0159.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4cda72c184d0/vmlinux-192c0159.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/404b09fd74ca/bzImage-192c0159.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com

This looks like the mm is not reference counted correctly.

The maple tree has been destroyed via exit_mmap() while
do_user_addr_fault() is executing.

> 
> ==================================================================
> BUG: KASAN: slab-use-after-free in ma_dead_node lib/maple_tree.c:572 [inline]
> BUG: KASAN: slab-use-after-free in mte_dead_node lib/maple_tree.c:587 [inline]
> BUG: KASAN: slab-use-after-free in mas_start lib/maple_tree.c:1207 [inline]

This shows it is the root node that is incorrect (which is stored in the
mm_struct directly).

> BUG: KASAN: slab-use-after-free in mas_state_walk lib/maple_tree.c:3291 [inline]
> BUG: KASAN: slab-use-after-free in mas_walk+0x8cf/0x9b0 lib/maple_tree.c:4599
> Read of size 8 at addr ffff888078907400 by task syz.0.18/6008
> 
> CPU: 0 UID: 0 PID: 6008 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0x156/0x4c9 mm/kasan/report.c:482
>  kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
>  ma_dead_node lib/maple_tree.c:572 [inline]
>  mte_dead_node lib/maple_tree.c:587 [inline]
>  mas_start lib/maple_tree.c:1207 [inline]
>  mas_state_walk lib/maple_tree.c:3291 [inline]
>  mas_walk+0x8cf/0x9b0 lib/maple_tree.c:4599
>  lock_vma_under_rcu+0x101/0x5a0 mm/mmap_lock.c:253
>  do_user_addr_fault+0x41f/0x12f0 arch/x86/mm/fault.c:1325

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x342000
> Code: Unable to access opcode bytes at 0x341fd6.
> RSP: 002b:000000000000000e EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 00007ff2e4816090 RCX: 00007ff2e459bf79
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0002000020003b4a
> RBP: 00007ff2e46327e0 R08: 0000000000000103 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff2e4816128 R14: 00007ff2e4816090 R15: 00007ffc4f622688
>  </TASK>
> 
> Allocated by task 5934:
>  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_noprof+0x2ad/0x780 mm/slub.c:5270
>  mt_alloc_one lib/maple_tree.c:174 [inline]
>  mas_dup_build lib/maple_tree.c:6299 [inline]
>  __mt_dup+0x5a8/0xc20 lib/maple_tree.c:6382
>  dup_mmap+0x36d/0x1e20 mm/mmap.c:1744
>  dup_mm kernel/fork.c:1530 [inline]
>  copy_mm kernel/fork.c:1582 [inline]
>  copy_process+0x7371/0x79b0 kernel/fork.c:2223
>  kernel_clone+0xfc/0x930 kernel/fork.c:2654
>  __do_sys_clone+0xd9/0x120 kernel/fork.c:2795
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Freed by task 6003:
>  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
>  kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2540 [inline]
>  slab_free mm/slub.c:6674 [inline]
>  kfree+0x1c7/0x690 mm/slub.c:6886
>  mt_destroy_walk+0xc0a/0xfa0 lib/maple_tree.c:5028
>  mte_destroy_walk lib/maple_tree.c:5049 [inline]
>  mte_destroy_walk lib/maple_tree.c:5040 [inline]
>  __mt_destroy+0x2d7/0x390 lib/maple_tree.c:6446

__mt_destroy() is called with rcu disabled because the last mm_struct
user should be gone.

exit_mmap() is only called when there are no mm users left, and then the
mm is write locked before removing the rcu protection on the tree.

It appears that somehow the fault has the mm without holding a reference
to it.


>  exit_mmap+0x5d3/0xae0 mm/mmap.c:1312
>  __mmput+0x12a/0x410 kernel/fork.c:1174
>  mmput+0x67/0x80 kernel/fork.c:1197
>  exit_mm kernel/exit.c:581 [inline]
>  do_exit+0x78a/0x2a30 kernel/exit.c:959
>  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
>  __do_sys_exit_group kernel/exit.c:1123 [inline]
>  __se_sys_exit_group kernel/exit.c:1121 [inline]
>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
>  x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_64.h:232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 



