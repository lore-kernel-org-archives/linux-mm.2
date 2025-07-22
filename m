Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41303C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 12:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD928E0003; Tue, 22 Jul 2025 08:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85218E0001; Tue, 22 Jul 2025 08:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CBC8E0003; Tue, 22 Jul 2025 08:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9204C8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:05:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4672F140370
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:05:41 +0000 (UTC)
X-FDA: 83691771282.01.79C1AAA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id A888E20005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:05:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hunlI9kX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IkA4DT+P;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753185938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEX/Fj2S8jLdxEpQbumvqcWtENVhk07g8BsFQN3DTsM=;
	b=HodX+Bo0AQ8hrKRi/1Wr3UYk6uuuFTL0Bg3zR2AoTt5lnqO1aSCJy9Eq23FpVlTZGkfCNE
	ECDSyijn/SpGBQTy/qtPjpGqKWQ8nNiGU3zK5NGyMWZB+Dumi/saffpCLY55i7Six84bL/
	zQPmlJIU7ie5BX7MYzunWU9FfW/KN/U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753185938; a=rsa-sha256;
	cv=pass;
	b=dMxM2u2TP+ChzPgHsiHC6XcI10esMxv+5x2H4fIdUZHorfeb+FSp6+V1IXN1Z8Nc+sW4uu
	vsvBONryIGP3aCaY4xODapDjPROwSPX22eAKYgvSkDEQjsxaf2gqo50FxNu3zpnkMSrnjS
	CN9CEDHE3VjwS7aagBRyUXvCw+N0Vcs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hunlI9kX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IkA4DT+P;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M5TC00021337;
	Tue, 22 Jul 2025 12:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DEX/Fj2S8jLdxEpQbumvqcWtENVhk07g8BsFQN3DTsM=; b=
	hunlI9kXFQ/rSJsZcknJlEbSSFOqt2sibzXoL0ey/haolTHq81a+xGTb2b4/9JCP
	X3Oii3AUpWMT1wlhGG6Wc63JkSBfQRCcNDkUkKn6/uFFDbUOiY/PlyabzIv/jEXU
	AP0WSxjbn+t1SzrlcjTcfr8Ej2tbe7gL1t3sh2FnK6QWkiXzOJ7JtiK8TtQf7lPY
	1XdX2A1Z5U6Dm3QpYv6S9bg77XDZnK2qvve9v5KGmtX+MJJUeeGls+zAYsJJ07mq
	ThjfnLAZbFG3PdqJYZ9b37nAPfzYWZQMqAWJ4P1/GMShbav//KOrGqprZspgcvRv
	Y5YOs6D3rZcZgJ8mqbfmLw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e9n5tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 12:05:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MArOGJ011585;
	Tue, 22 Jul 2025 12:04:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t97c2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 12:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B8Kv0APkJomJo5rmOsdEElsui0q35TzZPuzpa7eJNAfnkJ6Ma6daa+a+SpHXAnSpUHviF7miY0BUNT8h4ABl+yNP3kayGEbuKBXFXfxOaMax96RDEfocgapL9v/YKkU8lo5xSsi6zGGFwUIXCWkbwWOpeIACj4y48fSusgyaXwgyFH3C71sg9QBDIAToUEzLb8KhXL/xk6DCLsA8tCXIL+AcIZZiOencEbwuzN0hPtHcbCNVpAr9oU9sVmA2kvoO5ut7XwlvhBtRydQbKSCVAGB+VDbK2IZtAsFAesQtiud+oH+nO8KVMxHhozIJYNNR+BFoOX/3WrHLMKlbqeMLUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEX/Fj2S8jLdxEpQbumvqcWtENVhk07g8BsFQN3DTsM=;
 b=dkE+Hrb8aBZyn4zb6vpClMlOqMHDPX7CgaTm+GNguumP5uNNV2jxz01x0ZQTNMcJBHsBed75wxWJgh7ipIsROS8+AQi5Y/0FXD1M+Us5tEmq4UObLJtSp4sO8LXV557/rYC2VhfWDhq0/PNu7C/569G5ciB/89zmjHxsQK5SC+xZx3RLKMlCEq6l5iuHjuT/X1v8NK30gfWXtYlK12VfzFHqNADoARzwAvzSLMVc+e1Y+4fW+s0vCpessC2GcjJurhvdIM4OVT33hxdIf4anEsE5Z8KEYaKmR0albaVNdMjs2q7poTEvRTmKyxyix81lNYJtiS2B55BlMqqOZjdDfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEX/Fj2S8jLdxEpQbumvqcWtENVhk07g8BsFQN3DTsM=;
 b=IkA4DT+PfE1oFNSbtQIpfWdFaNpWrzepceBmPJKymu8lkBM6qhK81b+Mm2k77R/Ja+SjZDSiE/w/t4XWKgI5Oc4ZgRRDCzVamIRtFStK5b7nMVbyqh4jqple7zHLymD9o5sIMbLvpSlO+4XKzDT1I5MK75/82AlovE2H7W5WnZw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7806.namprd10.prod.outlook.com (2603:10b6:610:1ae::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Tue, 22 Jul
 2025 12:04:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 12:04:47 +0000
Date: Tue, 22 Jul 2025 13:04:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        hannes@cmpxchg.org, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/5] mm, bpf: BPF based THP adjustment
Message-ID: <dda67ea5-2943-497c-a8e5-d81f0733047d@lucifer.local>
References: <20250608073516.22415-1-laoar.shao@gmail.com>
 <b2fc85fb-1c7b-40ab-922b-9351114aa994@redhat.com>
 <CALOAHbD2-f5CRXJy6wpXuCC5P9gqqsbVbjBzgAF4e+PqWv0xNg@mail.gmail.com>
 <9bc57721-5287-416c-aa30-46932d605f63@redhat.com>
 <CALOAHbBoZpAartkb-HEwxJZ90Zgn+u6G4fCC0_Wq-shKqnb6iQ@mail.gmail.com>
 <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com>
 <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
 <404de270-6d00-4bb7-b84b-ae3b1be1dba8@redhat.com>
 <694a8b10-6082-44ac-8239-2c28b4ba8640@lucifer.local>
 <CALOAHbBepZiORN2yLvDDQWbvom38HHvCyqAqvS7uKzQqy8zgjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbBepZiORN2yLvDDQWbvom38HHvCyqAqvS7uKzQqy8zgjg@mail.gmail.com>
X-ClientProxiedBy: LNXP265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7806:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ea33bc1-2601-45c2-c70a-08ddc917f416
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkdBZ3BkMzYvVUI3NVNYOGM3NFRhTE1ZbGN4azRCM1lkK0htUjZidHRPSnYx?=
 =?utf-8?B?cGZzdFVPU1IwNjNXRnlyZCtsUUNXTUYyUnFqUHhMdFpnQjJDQ1U1cXNnOWdy?=
 =?utf-8?B?azFORnp5WEhzUEh0WEYyS2pvbkxoZGszWUxsd3hIaXdaL1FHYjdrc3g3M00w?=
 =?utf-8?B?UWtXNXpKRytRV0tHTmdPT0c0V3FRWVlFdnFCYzJ2R25GeFZiUlY1TFlVbWVp?=
 =?utf-8?B?R2Zmak1QYStlaUpwZ2JxN3ZPcVBucnBSdnRoQ3pNdEUwQnZQM3F0T01Xb0c3?=
 =?utf-8?B?WHBCb3dpYkVZMHpNZFFhRmhNWDUvN0crSXo1V29TS28vQ2ZOTllOUlp1cmxM?=
 =?utf-8?B?TSt0cWNCbW5SYTJYcTRHRW9DazVKTGtkQmwrZmVBakRaZEpMc1JwOEJhTGF5?=
 =?utf-8?B?NnlsaHdrNlJzWTl2bG96dnFqQkRuRVcxZDZnY1pBSEpBMHI2N3VKVkpwUGVR?=
 =?utf-8?B?eWlFeGZENUx3NXc1TkY0bjNEWkZOOWpQYmhTU1dmckcxbG9yWTN3dnhuTlJT?=
 =?utf-8?B?U1RIcU5Cam5ENFcrL2t4bUtKUC9qMFNHRVpKL0U4NzlLU2FvWWRxU3Vlbnlm?=
 =?utf-8?B?RU5hWkdvZ0FSZ3h1RVJQRmUxUWtlU00rTE5UZ01LY2VGdUtCWkZHR2k4M1lo?=
 =?utf-8?B?dnhReVlFL1drL2NqTjlGNEYrNTJSTWpxaGE1ZnN2WFNMdFdiRVlSTityaVhs?=
 =?utf-8?B?YWhoOUcwMUU1RnhDakRieFk2WDlrSnUyNzNRTXNKdDZzTVRuU1RaNHVHSmIz?=
 =?utf-8?B?SXN0NWgxWDNpRlJTajY0UnNPUS9FbDhEWHBLV0l4dWlXdUljSzFSVGgvazlr?=
 =?utf-8?B?OVAvZ2d4VDFLQzNOZ2k3TmswdWNBT2s0RmMrQzVpeitFdUd3bzhZbDFuR1By?=
 =?utf-8?B?NXpTdUppTFh1amhyemtpU2VyYXJCczBTaWN0UjlsSTlYQVRrY1RxYlBBWmkv?=
 =?utf-8?B?dkRZVUptRXUvMEJjc1U4M21PT2xNOU5wMlpRYjdtL2VyQUd6dW1uWFNqVklH?=
 =?utf-8?B?bXZ5VXBxVUhzbFdkMXZseSt5bTMzNTZ6T2E0bDFmNUloOEo1U3IzNmdISnhx?=
 =?utf-8?B?TmF5dHVjMVNGbUJxUnJxczlUWEdXd0IvOGI1Y0xsbWVKeHpQTVV6TWZoT3o0?=
 =?utf-8?B?OHFDRWtuTzdtZGZWcDFRYWJUN05JQmlvc1lZcngrbmFtanUxQm9HOGdHbkw0?=
 =?utf-8?B?SzNKWVI5bEQ0cXRVWDhTVENhM2t4VTd0QjdQclR6eDVuRnUyd0dtcXNIdllp?=
 =?utf-8?B?MEZ4UlpkK2RwLzNZSlRnSE1CSCt5YVFPYTMxOWtib3g2bC9lSklIWDZwWmxn?=
 =?utf-8?B?ZzhzalViSVdQSFBlT2toMG1BNm52NEtRM1NmcFIwbmNyYmtYK3dpWkJIOG5L?=
 =?utf-8?B?RGJ0NG01VUZRY0lMdzBMNThBZGRXbVJtQzlidlFRRG13VWhYQ3h1TitoL3dC?=
 =?utf-8?B?aXZDVlBUZ0pKdWhMa2g2ZktPWHpiMVBsemNNMWZTNkNYV1I0UTlWY0xOUnBR?=
 =?utf-8?B?TldmNjF0bldVN2pFN1IzWTkvR1VTdm9zU1J6QlJUc21lbEtxZE56SWZlNUpZ?=
 =?utf-8?B?cThjSnlwVWZ2RXZ0WlJPaUtUSjJlSTBhQnRrWm54SzNjL1djRjdIbTN2VzMx?=
 =?utf-8?B?U2lzUDdVSVU2a2d1SEZWanU5a3hFUE5RayttQnA3V243aTVMZEF5OHFxT2RG?=
 =?utf-8?B?NlZnY2JVNkdUT1VpYTNwQ29nUnZ1ODdzQ1ZsNkF5Z1cvL3ZqQnBvVmVwbHdy?=
 =?utf-8?B?UDRRd2xONUFRWUEvZ1crU2trZmd0QjlwYkdGL3o0RnJtVUxhQUdDRWlSR0Iz?=
 =?utf-8?B?cjdWVnkzbGIxRFNYeGJlNU43T2Rqd1h5N0hNNDNkUU9ZN0lkOFhqeWhjQmJu?=
 =?utf-8?B?RlpnQ1R5TEtwcTh6WmgwN1N0VjBUWDZ3dkp6cVJicm9IYmpCY1YzeDBqU1BS?=
 =?utf-8?Q?/dLb6EE9bXo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTlGSXBsRjNSalNibTA2TkNyamkrTlAvaHUxbGtzQzJQVnozTUFtSlh6bmRu?=
 =?utf-8?B?R3dtbkVsL0MrM2EyTHlpekwyVkhCRTNVVThGR3NSczl6b28ybUxUN3RGQXpW?=
 =?utf-8?B?UzFzRGRiYmlQb0QxYW5PaWVPUjhWdkdVUDZ0amJHQVlxUlRib1VXYzhKZmRm?=
 =?utf-8?B?eHpuOUxmVFNISFcvU1dRK3FBUEthYlpTanRvUGxzVndqaWV4N2c3emlzK2tm?=
 =?utf-8?B?TE9MdUlxVkdjZXJlVTB2MjNJblJ1NXBRdkIxaFhBRERMKy8weW1tMHNmclBj?=
 =?utf-8?B?bWNyRDgwR01ydzZ2QUpHUG1QcEpaRjdhcjRGZHkxY0RSSWpNMVUrYklGQldr?=
 =?utf-8?B?YUxqUytqdHdYVHFYajlLNHk5aHdlb2U3aVl2Y0VjTmZjZlY3dTRHZ1dXWTho?=
 =?utf-8?B?MzNaWjBsVVBSdTZEV3N5clp5RlNLYzh4NmdPTE9pb3krOU50WTMwR3NGRnNn?=
 =?utf-8?B?UUt5TlhYc3VIRklWc2h2L0dxOEx3eko2ZWxHanJOVXZ4c0ZSRENtbmozUHAy?=
 =?utf-8?B?cnhmZVBWK2RTRTl1WmpnR2MvUFduTVhab3RyR0d0bTZPTzh1bTBQV1JHRHUy?=
 =?utf-8?B?clBsYXZtempYb3lpQmRJRnAzdzl3dWhzNjRFWCswbmtZL3B4NGpXSGl1SWxS?=
 =?utf-8?B?MVhBOGdhTitHWjRxV0hFRWpFMVB3ODByZHpHRTIxVUgzVnBZUVRibG85K1dz?=
 =?utf-8?B?NEc4cGNOZGJVOG96Tlg5TCtrL3ovbWpjWS9oTEprREhuWStmWEhZK1AxTSt3?=
 =?utf-8?B?QlJNWVMzd1RjajFKbFowU3dqSlVKaFlYQWhOSzFObFZUOHZTS2Y3aEVMNzh6?=
 =?utf-8?B?Q04xRnM3NGJTV3pXSEdnc3dlVUdMc25GT05weXh0ZVlTa3N1ZWgxcG8wSE4x?=
 =?utf-8?B?elBtKzMxc3FocEtQMWYva0Y3N2hVTTBrczljakNaVXQ1OVc1YXIwUWRISnZG?=
 =?utf-8?B?akhIYjIzSVYxUkxLTFVicEVlR29uZkhqZjB4Y09ueitEQmprd2VUazlSUFZK?=
 =?utf-8?B?dTJSM29ONFRncm1vS0g2OTlFR0ZjQ0hWZS9wMHZXL1BiNll2MmtrdGYxYzNZ?=
 =?utf-8?B?N2MvazV3Mk9KR3Jya2ozMzhFbzkxcnU2ZU85NXcyK21HdVhmWE83RXBvYzR0?=
 =?utf-8?B?QjQ2TmVFY0VzOUR1YnVYMUhVM0g5SW5YdWZUMDJVQ0JSelRoWVh0cEtIendI?=
 =?utf-8?B?Z09xYk1hOERuM25lNlR6Vk55c3l6RWpvbHBMelJLMDBHREp5bjFsZUExRldC?=
 =?utf-8?B?T1hOUWNzZTNYK1ZvOHZJeG52QWtzVUtWeGZuRENOVHkvVEx6dm9zNjAzbndH?=
 =?utf-8?B?UEJtNVhObGJFWWQ2SVd2Qkp2a00zdWRBR1M0OXF4N0wzZFk1MVBDVjhUNmxY?=
 =?utf-8?B?K1ZYTWY4V2JncWRLakFUNm5vRUhOT0NKTEVGelA4N2hjNi92L25KUmlkRVlW?=
 =?utf-8?B?SjhUZ2wvdk11amQ1YjhMRXFDSkJ4bjNwUnNRRExhZDBuMkhQc2pmRGpUWnIz?=
 =?utf-8?B?RzVWUGxUSVdSb0syYWU2ZXhyVkMycVNnK2VNWmlUR3pLd21uUS9ZOEdRMlYx?=
 =?utf-8?B?bTBMTWtUNzZpT2NORjcvaXVvRnllOVRIaGJYUkUrV3NsakpxZGJmeFFzc1dT?=
 =?utf-8?B?QjZBV0ZER0REVUVaRXloK1BYRlUxTXVRc256QlVsbVNxWVlYRk0zUTc1aFhT?=
 =?utf-8?B?MWx6Vis0SHI5Zm9veWs3ekZ4V2RmbFRBWTRDMEVDN2xydXZ3SGhHcWF1NnI0?=
 =?utf-8?B?ejZ2WGZxRUkvdmRaY3AyY2lhT0dQNitlQWVzRk9WMUxKTGcybkRucVhLVlBz?=
 =?utf-8?B?cTZhcVRMb3dodHFHSE8wQXVUTGQ2U2pQNE54a3Y0S3R2LzRZbjUvVU8zbUFz?=
 =?utf-8?B?M3lydGRudWsvcnFaeUJyVjhTVmRvNXZOVzlYczdTRGxuM3BiMjVZNEN3aEZz?=
 =?utf-8?B?MkNHbkxOc3VYZHMrZ3lTck9IK1NXR0QySmlQdzM1RUtUczZhdkErKzkvU0lz?=
 =?utf-8?B?OVhPemV0R2ZpWkx0eE4vVHUyL1IvdFhMWmV3MUU0bUxqK1p3VGJlcGZLUStj?=
 =?utf-8?B?ZjlWRHRSdDJIVnoxZUx5UzhWeVIzR21uOGgvYUVERGVwQm4xd25uL09WOHBO?=
 =?utf-8?B?ZndrSEl0UWRvb2RPUERTaGxSc3B3cjBtanBkNS9sMkJCblh0V3dCRkp6RlJz?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F2sUoyV8BE58OPVjlrlL9KP/v/EQQQkEf7pVV4E6rnxWqtiLBegUd/OySzGpJ4jDGAxytMHbFC/KxyCHA9A1o102GTo+kN4ySb2GhUgX6ROItFjCy16fVXu0h4jyGy0kJud80WFq1MBTy08HQFWvQQdtkfEfNYAJY+RaQPFBHVU1RiOVmqx3YbDmvJlBvinK6YH4Wk6nLXhJBuHlOTCsRbV0Vd8ZtHRT4LTPU//sDJqTvxBk0q4UJvSs7d/XTEFc3ErGt5EGTkqKzaJSf93z8UgbFRPiM3LyOkrr9NW2aRI2qogabFcyL2Hn2pvIxIidjMm2xEe9WkXwAabXdEwEaVgt319QrPclOO1uFSefZE8CN+685iN9wpXga/btbDJy+xBZCDicGu9UzpEGdMhVBXGvKm9VIw0lZjXsla+VvFLmzbcrDoQJ3s1hwR7GULlegqETJUPkljEk/J3teUuJuSp3lTvgtPRXFFHNJ+IQaItgXS8R7ZVatrklgJQrIsa4bJa1vzFTRpymYFNx6FSgy31YkTvWWEViA32aKR0lHf2BP4vEgOVIUiGadNJnGlMiGpUXwIhcw01jMdyIc3kbxjCmUReerEtUlwzTXBZ0bpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea33bc1-2601-45c2-c70a-08ddc917f416
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 12:04:47.3752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4P1ym2PPZyJ9/Tj35Zy9i1U4qkg7ItJ6g1e3C3z9QYZlpcRduD7rNXqYbJtP5qViMrzx7lxHUsTPqQkEaqDTvmW3JXbq3X9AoZ5HaDTDtiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220098
X-Authority-Analysis: v=2.4 cv=eqbfzppX c=1 sm=1 tr=0 ts=687f7e74 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=oLE7uoPewADck1pK9SoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: o_8s6KJzQZ8E57022EkMYxN1fHV2VB-a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDA5OSBTYWx0ZWRfX+rQ8Oa+ppUD5
 9KguQe1xE2vyayPXauyvHXaLSI2nPYeVgRKq1jPAO0nOpwZ7UODh0Y+YSPFlB3kqjoHDQxHRlDv
 OET/07pI0ma9vXUrebzJq2eBOFVb9r7qCtXAol3WTxJ42F3nlFDkL9j5fqiAkavSe4GP90ChH5D
 To6HdmB1rAullAIXm378x7xDTzOTdBJr8YSChlFXgbCPRKp5MyEDuH70aNDScmZMcCXm2dpkR2N
 kC+WFRnIQX+WvOvXPOkbYJ8r4dEkwxpFqjKTQapjoCbXMJbZ6Z0Of383bAfoLMEIa4Sxu9MVqzt
 thadj8V/TC0VYsqjvk4ifWp3QZSVE4mW7vcvoeaoRMR/0okKjGrhnSzCkxFz3yJyyNOFs/ZnD0G
 9kwwZDubVC2fWQ7wSnxY/EvuB4wWKtDqIusC7v0bDC+tgYjpQjZXO34ZXFs9If4tcZ1dx0Z8
X-Proofpoint-ORIG-GUID: o_8s6KJzQZ8E57022EkMYxN1fHV2VB-a
X-Rspamd-Queue-Id: A888E20005
X-Stat-Signature: 8sqjhd61w89jrweyhwf5ykgcizxd986k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753185937-736350
X-HE-Meta: U2FsdGVkX1/ZGCzVCYAao9Wo7Ro6VV3PFHIpiIlSQqbmygWnOpWmnfLQnMUF8SsPaEhBun1BjsBaqPZDsUFC0mqXj8wUrvX89EiJwbmWu1tXXJi9wfIr/6RSPk3p5l87VZrIV11SHK9sRoLtrqFio1j9GFWrGR23x8ojYeueLR/VuGdLfPxZusRe3zIGOCdT1UmVOeT0vM7O+5Dl939JPxiapRDs1ZnfeYGtbHMzp4C3AwZ4rrwwepr7ekrnJmznVWDgeMMfhvGY5p0mBuzSxtTkvek+TAF9YAUwX63aJmi8h/ADrxIWTYu//wO6r/cvOfkc3VHwUs19o0QN34WCHWW3FjIWRAJK3xTRBMXnC/2DddHa40hb+g3JJLt97hx+5hICNF3iPrc2MHJcg6KgMnhbhZtj+ktpfEtajkLw9/VqX219Qj6gzv8VakJI3nMysfcoEzfDliWDNifQn5EubWaur5RjzxgexuMHPviv2PPAZEkk6QHi4ozFaPIofqoyxdockNJhyQQIE7xeqU+r656quMrd9MIfXBTB/B2cMngCp2G10KMZsPrQOFK1K9upxwqnlY8McjpoW0Oa6rvWqDrcRu1lC/14gLiEqfKv7eT6R3PT6NaXiQEGh0vk1MnTIdEOkxXcHnPbh7Id1b3CyJrALS4ZMwF7VA9nFy5TA6q2XNEhsm12Q/mEwhrMQnudhMttQtgCYpGdJxqYazOIHhXTpqA1axMwrKGXLEhsfRQhOCi/wk0DoS6lItk8RUJednkOjAuT+L31zaiGr4nXVo2O3Kxj38zxSuMkJXgQQvVfS7GpS/Fb+2yVyNs6lsOJsx+V1kRsZf3LIZrT03Esje0xv8k8e8WaDJDrCxnc7dBeiEeI18bwW4sPFEQmOo9ad/e9hBAhaKz8IWFamp7mIwcrqexEh1MlkWnnFgkLleHAq8fX2t9pa0tbjwAc1MbiV+lsy70eCR4eUI1e8+o
 ryl5qNkX
 vA+hT+2ZmXsqxMvi4od8/sCjZfziWqX4SoyBcUjr8n/ioQggytBSmBz1G9MDJfUH40BrsoFE8mHIL4ihcjXIRimx1eBVyLvjWTZQaHwaRooI2+NDyYTqRX9ODVAFcJpye9s9OQCCQxJ++DpN+YQkAnGRiSvJpQuJNQESWt8xDl7A5V64r5YoAmb2hPNYjxiP9KP1PZE40A/7Bbh0f4TXzRe+J75df4koorxTcow8fHMft25ThvkdkER5FILLdP5sMmLHPgaN0UzBLW7iW373hjUuuK4XZIkuy4nteWO6qQAzNexybL3mqO/iU+nMhuxgMQbnoNM+YsTsSiJ56lIPAytl/KjG+VWIiZpUOvOEDjFp4ZO/A7P9OdqKoEXU+9t9w04yhcggj519ghTj5Cf8JrY/ezzVuxcaIdDguOvq14FHMIBV8dYxefjGOUL0y2qHQ6Ur2LEWRjDST9wqjHaLs0EFahMjA6UgKm0P9BZ0w0CNltUz8TLO55M6BIsHxDWJw2Tq0Gu1iLoJ5jynKJWPOOzkYo4P1CuJKIvN/kigFTM7RSLxjiVjw2132Ibu9ch2AMylM38PvhzUOzAEpfBDYon+2fDJ6BcHG/hmk8C4jeNTx3zVlVBFz80RHzkHw1LRcJPvhG+farHu8v0B8kmhgN52/Mv7D0P2yrHL72yQtd8OI3yHInHXc+NkoaBPzDnrLhjKH4uwlIFXhtC6hyK3jG87PUQeYuZTvclO3ftp/7ReHzHwfgTj6+z8B/4jvf3bYRoiyVVpIV1pmKKr7hj9/Iyo3BPVJwrEzCZPlCntPl9A29xFVUckJaCF1EGvhx9fDoIBj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 07:56:21PM +0800, Yafang Shao wrote:
> On Tue, Jul 22, 2025 at 6:09 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Tue, Jul 22, 2025 at 09:28:02AM +0200, David Hildenbrand wrote:
> > > On 22.07.25 04:40, Yafang Shao wrote:
> > > > On Sun, Jul 20, 2025 at 11:56 PM David Hildenbrand <david@redhat.com> wrote:
> > > > >
> > > > > > >
> > > > > > > We discussed this yesterday at a THP upstream meeting, and what we
> > > > > > > should look into is:
> > > > > > >
> > > > > > > (1) Having a callback like
> > > > > > >
> > > > > > > unsigned int (*get_suggested_order)(.., bool in_pagefault);
> > > > > >
> > > > > > This interface meets our needs precisely, enabling allocation orders
> > > > > > of either 0 or 9 as required by our workloads.
> >
> > That's great to hear, and to be clear my views align with David on this - I
> > feel like having a _carefully chosen_ BPF interface could be valuable here,
> > especially in the short to medium term where it will allow us to more
> > rapidly iterate on an automated [m]THP mechanism.
> >
> > I think one key question here is - do we want to retain a _permanent_ BPF
> > hook here?
> >
> > In any cae, for the first experiments with this we absolutely _must_ be
> > able to express that this is going away, NO, not based on whether it's
> > widely used, it IS going away.
>
> If this BPF kfunc provides clear user value with minimal maintenance
> overhead, what would be the rationale for removing it? That said, if
> you and David both agree it should be deprecated, I won't object -
> though I'd suggest following the standard deprecation process.

You see herein lies the problem... :) from my point of view we want to have
the ability to choose, fundamentally.

We may find out the proposed interface is unworkable, or sets assumptions
we don't want to make.

So I think hiding ehhind a CONFIG_ flag is the best idea here to really
enforce that and make it clear.

Personally I have a sense that we _will_ introduce something permanent. We
just need to have the 'space' to positively decide to do that once the
experimentation is complete.

> > I find this documentation super contradictory. I'm sorry but you can't
> > have:
> >
> > "...can therefore be modified or removed by a maintainer of the subsystem
> >  they’re defined in when it’s deemed necessary."
> >
> > And:
> >
> > "kfuncs that are widely used or have been in the kernel for a long time
> > will be more difficult to justify being changed or removed by a
> > maintainer."
> >
> > At the same time. Let alone:
> >
> > "A kfunc will never have any hard stability guarantees. BPF APIs cannot and
> > will not ever hard-block a change in the kernel purely for stability
> > reasons"
> >
> > Make your mind up!!
> >
> > I mean the EXPORT_SYMBOL_GPL() example isn't accurate AT ALL - we can
> > _absolutely_ change or remove those _at will_ as we don't care about
> > external modules.
> >
> > Really this seems to be saying, in not so many words, that this is
> > basically a kAPI and you can't change it.
> >
> > So this strictly violates what we need here.
>
> The maintainers have the authority to make the final determination ;-)

Well the kernel doesn't entirely work this way... pressure can come which
impacts what others may do.

If you have people saying 'hey we rely on this and removing it will break
our cloud deployment' and 'hey I checked the docs and it says you guys have
to take this into account', I am not so sure Andrew or Linus will accept
the patch.

> > I wonder if we can use a CONFIG_xxx and put this behind that, which
> > specifically says 'WE WILL REMOVE THIS'
> > CONFIG_EXPERIMENTAL_DO_NOT_USE_THP_THINGY :P
>
> That's a reasonable suggestion. We could implement this function under
> CONFIG_EXPERIMENTAL to mark it as experimental infrastructure.

Thanks! Yes, I was looking for this flag :P didn't know if we still had
that or not actually...

But, yeah, putting it behind that explicitly also makes it very clearly.

CONFIG_EXPERIMENTAL_BPF_FAULT_ORDER relies on CONFIG_EXPERIMENTAL makes it
you know... pretty clear ;)

>
> --
> Regards
> Yafang

Cheers, Lorenzo

