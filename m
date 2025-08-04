Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1ABC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 02:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CFF36B007B; Sun,  3 Aug 2025 22:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A84F6B0088; Sun,  3 Aug 2025 22:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048CF6B0089; Sun,  3 Aug 2025 22:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBFB96B007B
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 22:36:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65525115714
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:36:19 +0000 (UTC)
X-FDA: 83737510878.09.37C945E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2ECF0160005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:36:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UZGFzzmd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="YEMl/sNr";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754274976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qwiqFVSjnCvtrOOijKZLdNZKXNc9knX3BtgLSCxbFE=;
	b=jQdFMPOUOJ3TjVHIq8/PyTmdvnc1BGjYo3GUdwHtZz58P73/1KL7SSZlNGjH39Mh1GUvZ+
	9LhhZ8OLPQ5rOWhCU9VLSpUjgXmY2N4vNu3bvH7BQxxE96DySqlVYr3bR2A6vIeju6iVUr
	Zg9KIrlbEoxR40W09JwK9VnHVH2itIA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754274976; a=rsa-sha256;
	cv=pass;
	b=MBD6eD2BTtlUG/0k28MebqRw5i/in3gWGeCqK3OSHlacs7kEz1EJ+RrtNkADc0zxqXHcPw
	VYlMx/hhVlhejhE49uOR3a+EfWL9nlydMbL6B99JclqRPwSZb8O+VDDVDZt6dKm6mBFCO0
	rM1PG6ILeiZIQZsAS/vy6RdYoyI62jc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UZGFzzmd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="YEMl/sNr";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 573M2NNT026186;
	Mon, 4 Aug 2025 02:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7qwiqFVSjnCvtrOOij
	KZLdNZKXNc9knX3BtgLSCxbFE=; b=UZGFzzmdelziVErc1WFQhm1sWRytJnF3mu
	1Uu740KeRM770h/5fj0jZJrwJ5QNPZFkjsglJhvY7sSy32eprFDciVvtqKNonoHC
	f9dfcjmExfIMVCI18muAGzPC23V2u0HWRKkb1/YB1JutBBEdWjP+DzzGZNYke9Bu
	p57F2G5Q35CgvkBprUHi0AQMCWtcZrd+4S215QpUVI/NjDcl3tqeD77fWWvV+Bof
	DGmBYpMcCvYXSSoBeopLec5YhBoai31eJcq5W4X6asE7948qn3TzavFeNo/TOsQ4
	FfLYjD7ywG45l1umRLOaDehqDb961JxajNh7BWxtsRw4eT0ENWRg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899kf9tch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 02:36:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 573Mj0bu025548;
	Mon, 4 Aug 2025 02:36:12 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jrujgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 02:36:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TpQqaTO8pW43CT3HBoHQ4YL13luUGPOYbnfu4ONn7UXlHMLWIrub0YBp/YS2b6RuiE2Nw63bd+WBHW433/fgnEYVwKC9K4tG9Cm9gxbNg5aJN8n2FXUBtTMVtquQaOzykUd8v5Oq/Z23+qx90FWMXu4GONwHmfQKWXo9h9DgjESsjGj+aHp89no/qPzts2/+s8frez0Np4HlaTiFp833/ohwHtyEcxNztmWYFhPi1madfWYmEH/JFByMMJqlGcY1aZ1Z4lBELeYBiD0LL/nJJGmdRjfCTHMe5fI8+/+w8TyQu0PIqeKRaq8P8wfPrjd5PpTTlXzrXbOnkU7NddGEsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qwiqFVSjnCvtrOOijKZLdNZKXNc9knX3BtgLSCxbFE=;
 b=cRYLeQFD3aULpUS1q1MVb1kEHIax/M9o8k0WCVtVOUkVELqIfBqrujuJEWvzdZNOWXWqL8CVkMFMu03E9/ss9+iwAyCoj75mU6dY9KzcmuMpzzcXzBjQmTCXdRPDnEzHjv/3qkxekGPIgH5pQCbS1k7CXn5coo5GCPsyRWPK05kkvhlr7JVSvZiUAz0K/MaoQ5hPAl5Gw2goc+sOcLP3mlE/0hdWC2J6/NETrEiVsXnwzCK49+Ti4cs1gG+y9vsMczFYX2SzJBrBC+VaC24zqvy8H1Zd45wtd1i1KjacgRtXOo8vgPyg+8XjBXEF50gHlJjTYzgk3PyY8WG1fi1HEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qwiqFVSjnCvtrOOijKZLdNZKXNc9knX3BtgLSCxbFE=;
 b=YEMl/sNroDrXPaXRBi7d+8OZYscwjavbNlFZd5mMaFW6iq4ujP/Dh6+ND8yVzocFKOSv+VjT3C9vNOf+Ea6/uvOo9HDKAd0nLbAZ7381X4Da/My7xlvcPHxjSj0LYwrUzAbEzWYfInxt37YhMyJRKcJmTZDCsp4RYzcx5utpnAg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7667.namprd10.prod.outlook.com (2603:10b6:208:48a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 02:36:08 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 02:36:08 +0000
Date: Mon, 4 Aug 2025 11:35:57 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Li Qiong <liqiong@nfschina.com>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5] mm/slub: avoid accessing metadata when pointer is
 invalid in object_err()
Message-ID: <aJAcjcBOcKCDPwjY@hyeyoo>
References: <20250804014626.134396-1-liqiong@nfschina.com>
 <aJAaE9Bqb3eSHBX9@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJAaE9Bqb3eSHBX9@hyeyoo>
X-ClientProxiedBy: SEWP216CA0016.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7667:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c2c90a-ce3e-4c8f-45a6-08ddd2ffaafd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T3mUwYBG6JclWb5IrQzW8oW4tyY1TcSQ6Xd1Ksv7VcqxBDlrdf50aO5KBZBY?=
 =?us-ascii?Q?83eKW9QGvUaI86QKqEc6NlZEtaDhqe+xkMtBQz4r1snnI4hku+BP2EhbF8TK?=
 =?us-ascii?Q?63jr96zu8iUvgbHbbXxzBcOHXssCH5RkDJVJ8rc7+22UrdPQv+u92VRLAarv?=
 =?us-ascii?Q?LpGpLgT8BGjKVvokqTzF+DTxf4VShGdTYXBBwE8gRBdP2Xva4OE6MRQ+lDAz?=
 =?us-ascii?Q?rUfSS80IQA8WXK2pdM9HkOekEqyh+wJ/HX3OsRCuf94RwYrpp4yllKjwBy5g?=
 =?us-ascii?Q?fXyadYIFDTs+L1GYmqLqScXszVPtBP1pICjgwKjbYMJ5M9YpQzFnLpFFrvo2?=
 =?us-ascii?Q?59SU8HP9mF9pmjr0unmTFSPV+9RPY1ZN1VNPYM5x8mFOJVIiRCHDs425vLSh?=
 =?us-ascii?Q?6SmuFOvmIt3cxBp+uZW/nal5JzpxTAXTivp8EhvhuZPkNaPv/9CiPiUVKGck?=
 =?us-ascii?Q?pl24w0su+Vmbc8oKk9rlU5CBLLWlUMme7IdHsBuynj3sg60eVtXRb9sVYVt9?=
 =?us-ascii?Q?TgcYGqcdPkcEODGNoZfPuNcILpbHuN0CQLHJX9GRH5oD0uZB/PdJGk2ce+62?=
 =?us-ascii?Q?zjFsz1vU4ITQ0wr/cXIaehEJ+xdVxVncGZf8fZK6FzqPcat3PzMrAcHvbmW4?=
 =?us-ascii?Q?8niTnMo0s/NLmxgJ+fCzrI8gnzzyfaQBddMHP8zV3CnUyK4pm2ftq795Z+1v?=
 =?us-ascii?Q?QdJvOAzUcSyOX5d5CdJ3M4lxpv/UBDawlGTn+MFoOZPQs9cp4Q+k/OlRMSdf?=
 =?us-ascii?Q?zcQBSIPWN7lBZ72H0X4zLnpxdjF59+V+T6NQbGMfKKZ/HkFudk5pvPfnzNWW?=
 =?us-ascii?Q?8Xb4SRCatubKzKgaxOpzlp3kbCuirifKqZ74tBTy3Sn/+2IYBjjliSS5gHPF?=
 =?us-ascii?Q?khwW/TEohMD52erfiSNLAE1nUOhZ/tLtK4g8Lcx+sTMv2rpPjRc0PXZt/1ip?=
 =?us-ascii?Q?xvXYlLnutp7ooC1QZ8QNoLJtyyMOqYcnXsB8tZruNmrsQibeh8kPWRwYerPo?=
 =?us-ascii?Q?BNqO3Ee2Dw0qPiZD6Pw8XjuZcVoUy+bXK0Nie2HmjEIOSVu81Y/cIP9QAVfA?=
 =?us-ascii?Q?Zaut0d+sZLTEhiVtCJkTZwxObC5XVbEiGRJxeYes+61N983sbLXuDJV0WOrO?=
 =?us-ascii?Q?W56m4h9nfnz09WBnEvBe00IIXlg1i2JTOxYusZXkwwCmXPTIOjAV18jTjNZW?=
 =?us-ascii?Q?Nm7v6sdTCPyTB3DWyHj3iSYsS0a7VxuWbjSO/NFLYBbvQUvC4zNH2/5pcA5p?=
 =?us-ascii?Q?S/EmZ7h/N79uJghWKZkmxqT1M7S5X7/2kZO7oq6j568u0q08tJg60dgdnm1k?=
 =?us-ascii?Q?3nPZgC5ggol+uDN6L+26oPu8faf18Tt6XlRpzeLxvkk9bRudNJZYT7JgCfAV?=
 =?us-ascii?Q?27WQDXCWoFtbbYfUz6vE4rMpTmSO3QvLy1QV+qhmy0O/FJjL8KlvlvfMybdX?=
 =?us-ascii?Q?dQldj9gMLg4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yk4a7bOksyUQHgdhqOiXWlHEj1ccqC36CMl89D0lVaafG29b+vThab9Gdv/O?=
 =?us-ascii?Q?QIK0kWb6FgF58KXz8HYJpGvcu9Jf5iSLJTEiKXAcyTPHp2N/SBLiHcWHMNP4?=
 =?us-ascii?Q?hPN0FqgjcmZuLFPYFX4AqKcx5CWODnJI5zSAKggKoStcL+Be7cyjUwn8XSAE?=
 =?us-ascii?Q?qolXs6JlWqPX/cgS9MCJb67NLCH/wJJG7dmqkjxWARqWSvVE4k6/DP2knWTA?=
 =?us-ascii?Q?Z7CXTvGTDDBDJS2mN6Ts4TVoi0/I/OZztYDZQCqsOnnZ/f5313TlbxWFmq7d?=
 =?us-ascii?Q?oMuVnODtKvBoi/yKcyKAK0Hx8pldo8VNTvKlHPdhJIrvsrNau9k3H3svKiY/?=
 =?us-ascii?Q?03wcyQxLilfeZKk+F7KZLvvRdg9nWEGd/CMVngUthJSUhBzwgdjbEOiM0XNQ?=
 =?us-ascii?Q?zucJtH5imzuEm988fV0KetIVGFzTuNkiweZlm02SRa+hMBn5FJGRo4nBe4LV?=
 =?us-ascii?Q?0qi/2Sz4/SJWz8tLGtFw4M4aPkKg2R2asFrNnBbNL2BS2y2CTGyRVYxWMiD1?=
 =?us-ascii?Q?UP3PTPe4TbZHGY3aDgVkjGh8+RlzrFlLLNkPpzxEj4RiFKpjp1K39Au3QqcM?=
 =?us-ascii?Q?rmPxJf9xfwDnAH/MFmdm30Glg7mEPkgT185d+JDetHrAC82nhbrHQC2xGcZ/?=
 =?us-ascii?Q?oA8aFk8J9x+W1YJpq60eBiVghXRl3B6raoxoN43UPDMhODRPi/S7aXkWufOy?=
 =?us-ascii?Q?dCl3LKCeAZnN73Jo7jyDMZk6Eso7AMNi9sfcBLyPY3c7PzE7MPPqYFXs3eth?=
 =?us-ascii?Q?fD0t1yFob8j/C1g86rzpMbWcX52T1viS4cGONq7tk+7ciaxLfer96VDuTpUw?=
 =?us-ascii?Q?cUiMkAkCjuNyDQ0cLW1lZVZmV3Asy/wYYrSLz3U7DriWrlwfPgneiNG8WXDU?=
 =?us-ascii?Q?W2VI5rzqRQTyi4gELjQCUeFHRvaim14ls17DVk4j8X+0n2lzKAJ98Pq7U1qL?=
 =?us-ascii?Q?/Yt8ltY0o5Pbjp85V7GumXU57f8zoGwGiorQr3aVFZw61R42d0xuzPNBQV4K?=
 =?us-ascii?Q?9q09hrRMbrJOxsk+DdYfad644wjRrdDbRnw3i+UG1cMbF2I0pGvpKTQfs0yM?=
 =?us-ascii?Q?qarPx7vJXdhgS6Zc58V0a377yrBuBwwOoktNG3wB3/ooo45E0SHZb3HSx6xM?=
 =?us-ascii?Q?l9nhJ7OV6jROWJ15fAO4xd4b4NLWWEmjbuYeOUlgOMiAmLKV/AcatgY990Y7?=
 =?us-ascii?Q?x5aJDLP//kSoTA5bYySDphxdI8cI+bgBJwAWX/uG4g7XiJrz1UnM2I6tAJI4?=
 =?us-ascii?Q?z11zFlv0C6Dk/aVBWHPP5xP8BHyav87y1cz59GAFxHhj4xbYJmuSF7ejrjZT?=
 =?us-ascii?Q?KSCFAjJgB04Zouzxymo+keBuJmKmVQVtPoId3TjefTLNxwfUD2iMvXriU2mA?=
 =?us-ascii?Q?yzGb+G0oWIBMd+AlkHpMNOGMq2GGxKMb23wMVO08vqrH/kOn34Ch5YVEUvZe?=
 =?us-ascii?Q?2z5dxqkBbjU23PoX+7HmlUdCP54Ptup+IE6WWZTQ1iBZzZTVl0We8abdBSaC?=
 =?us-ascii?Q?isgLIEY9JywD2GUss/lYslVidp6l+mFob02UFf31RRD73hduTI+XgaHicvwg?=
 =?us-ascii?Q?ir2//tzqzpKFqUgub3yEzAuwwxGpVeYCn8N2VI9h?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iafdeo4g9twIhkwv48FV1j0n5Xm8mTDtBNpYp9x7nfe5bVeeTyxG6LWZ8Rdz098DhPn4dmODeziaWLKKPstA4OPM61+zrD0iTGG8DLarnxyg6dIZuzIxWonG9hRpGr+ebjbhnht8sZ4Vq3V0jjrQd16dLZCpUlCQV9RPqS/cOD2fROgQgN02fELG5QYRBE0q4Cb9iloVdB1YWqdtYebLPZPYPicB73odTJ8vHoEO3jGcLukEZX3UwIxzvhIQbS9Ti+cCy3KJ7+a4ZofyJznRvQCpHbCnoPF8bGxBOU28hw9KgTa5KJHNT2e9t5Y0nBQslZB9X257WeyUqV2F75uPJUZ7nKrrejTgfn0jTrhQuvXjgWckT0bP1dzOyafZq9e6FSv6tFH0Ar/btA0eyLaY4wEKxDj9bFxYJTZPlzzoPhsG5nu6tR8rFkDlW1Y0CTSHCo5R/TWH7CD8CjGIs3oahHDe/uhFA2AWmIGl8aOpp9rEvdMpknGumxkS7n/I71Ee7EGlTOmwdgKj8Y0RSW8OTL65OBFkuswdY19q5/x4WjsPM6xZtU5BVhytt19YvcizFEyimCnIac0J5Gj3bHDP6zQOv5hK46yPfbfxCs/lIes=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c2c90a-ce3e-4c8f-45a6-08ddd2ffaafd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 02:36:08.4855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45rHOq65jYX3qAwvyx+dP0VeFI2X0f4nhsHaUzu21GlKK3Gkb6RN1em4j5r5eDveeJgWR8gsz1+wtOMFsH9WPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7667
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_01,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040012
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDAxMiBTYWx0ZWRfX1BzvpqvL0jQE
 lCintwcepkeAqKNodBFTAJmqmDpmkFyIXUu/j+tgxjQedybcPJnSoKSyT+YHA9V6xA2bfjsjlQc
 xs/WHhTMFDkpE7+PHJqBEVquMSf7MI2A7e+USeU5Ox0MSZyYDdeiFUvA4t+DQOkirJp12Aw31m8
 T2AUUh7rJfae8jwRocaRzgNWyoM9ej832bgJkPTyO7lvcHGosyzAkmJ1TVp7RHoKwtUhv2sUSdM
 ukvWfYP6pEHt0tmR6lYFHmylLMT0aEZdjZ5FJAydu9jx6T3W+M9YZ1dMs0WkuJj1YBQanVGKZKG
 EQf5B9u7LzV9PCtY7djJ5zsb6wL6HxVs1CMc6TL+Cg10rCJNvJH00gi/LdrzEJzwNcxm1Zo0qS8
 DZab7IGcX4xdz8Z8fEAF/fVp+6RDwLLe7gjDb9wN8Xlmxj4nYXp3VGCSAJix52HuNNYNPU5h
X-Proofpoint-GUID: yW4xnxeUMgn0X8tpf6W0WfhzM2Df2oby
X-Proofpoint-ORIG-GUID: yW4xnxeUMgn0X8tpf6W0WfhzM2Df2oby
X-Authority-Analysis: v=2.4 cv=VMvdn8PX c=1 sm=1 tr=0 ts=68901c9c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=SlVAvriTAAAA:8
 a=yPCof4ZbAAAA:8 a=riyKa_RKWOJBo-HcjdQA:9 a=CjuIK1q_8ugA:10
 a=qesGs21RGGeVIEdTuB6w:22
X-Stat-Signature: mkwrjnr768mxiqkd9ucg4i95n98mbnqq
X-Rspamd-Queue-Id: 2ECF0160005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754274975-33711
X-HE-Meta: U2FsdGVkX1/HspAv/cSd5iHEqfEY5bDquiLPln2XBUybow4f68sTKJWGprcLUyahJuNbnvKcdoKb+TsBEPt34Z6ixX0q6IJpAohk5ohYXRZcrLinb3IJG/5KWE5wigkLN4my9U44DIVCihZDrrqx0w42rborzjhgfyv4IghTC184stDkO2/yusBnWaGqR6yquONRAKRNhd8UT/c5f5w6vLgq6Na99LqgpqruKuAGGkCE/z08lCIzsP7JIJvWg6KpZpoCKNXgAhnqU6rXh7KDT49EwOa5eJxdrCoIQrWFEfsIagaBAZV91wepVNN/nbSRSU7tkZGN8UMjBzdQkF+RX/NnSzAAc3a2VR2C86NtjLNS8Snh0M6RKdbR2wlAvkgnh33XsfRM/3iDHv/kCIFfyr1ry4UKkshJeint6ZwIv7wpWCeKW2HJi2ycZFq7X4PlUKN75yTUmRt85eTW6sSSVPBzQl4+cpbYVe7ux0sQDdBdt5Ej4hV10dDFzquMuf+fTlbrmmOL/oEmSSbSwH8fWnOt1EeHLmvOjlat78+ggt8u/poRlu7Govwnc4D0qEDiz1/ehH84giI9OgSK8G4aWqn8Z69CbmZTQpafUzWLevUEvq1QQlJ3aX/YuD+xvIGLyzgo1yNlEIV6KH3XbIkqJPRqYS6Gjvoe6YGyOK4gpPQ/3C0NT9NaQs5w1PTxIoU3ahaXRJbZvGnmvINnDDmvT35tgd29eOo/4OrbrayRc1eQBJ2XGj6iWeInh9vIvfZFt6nsHwkJP1POAb7FATSkWwQTRjbuAb3Y3qwOrDJ1CyWiH3OrOO4WX3Uz+787nhZ2vX8L25GMx7kHsuoaYFaJntLfT10s8hOxSjOZ+f2zI8xJsGjXOtzrtZcWC2PXeHAFBl+nYo8d/49/+GF5wMa0CRsUOUTXnnwTlijPSCzHKcLYrTc9dxUj5BrQMW/b7K59An0On0FyzhwMCgxPw3l
 VZh2RLle
 wB3SJWD2I5DjnccJj7nyjK6RgFf7D5/QLbAhyAH9eK9pdKjSiT/d0C6xGzXFmEPMfewYqNqSrdo0eMZFK+lzGBLsj6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 11:25:23AM +0900, Harry Yoo wrote:
> On Mon, Aug 04, 2025 at 09:46:25AM +0800, Li Qiong wrote:
> > object_err() reports details of an object for further debugging, such as
> > the freelist pointer, redzone, etc. However, if the pointer is invalid,
> > attempting to access object metadata can lead to a crash since it does
> > not point to a valid object.
> > 
> > In case check_valid_pointer() returns false for the pointer, only print
> > the pointer value and skip accessing metadata.
> > 
> > Fixes: 81819f0fc828 ("SLUB core")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Li Qiong <liqiong@nfschina.com>
> > ---
> > v2:
> > - rephrase the commit message, add comment for object_err().
> > v3:
> > - check object pointer in object_err().
> > v4:
> > - restore changes in alloc_consistency_checks().
> > v5:
> > - rephrase message, fix code style.
> > ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> -- 
> Cheers,
> Harry / Hyeonggon
> 
> >  mm/slub.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 31e11ef256f9..b3eff1476c85 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1104,7 +1104,12 @@ static void object_err(struct kmem_cache *s, struct slab *slab,
> >  		return;
> >  
> >  	slab_bug(s, reason);
> > -	print_trailer(s, slab, object);
> > +	if (!check_valid_pointer(s, slab, object)) {

Wait, hold on. check_valid_pointer() returns true when object == NULL.
the condition should be (!object || !check_valid_pointer())?

> > +		print_slab_info(slab);
> > +		pr_err("Invalid pointer 0x%p\n", object);
> > +	} else {
> > +		print_trailer(s, slab, object);
> > +	}
> >  	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
> >  
> >  	WARN_ON(1);
> > -- 
> > 2.30.2

-- 
Cheers,
Harry / Hyeonggon

