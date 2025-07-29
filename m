Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8D7C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 02:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9308F6B007B; Mon, 28 Jul 2025 22:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1506B0089; Mon, 28 Jul 2025 22:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9046B008A; Mon, 28 Jul 2025 22:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA336B007B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:41:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDB49B9881
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:41:36 +0000 (UTC)
X-FDA: 83715751392.09.9385498
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8342100008
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:41:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xp3aPK4o;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sQXF5JwU;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753756893; a=rsa-sha256;
	cv=pass;
	b=fP0VlZeeCM9SITYzorJEVAGX1K/f45mUUiWfm8DHpRMJXBezTrKwoppt8bFrgfkNTLUE8G
	rFqYOILB8H5VE0kEHc8XK8jtcyks1y6a9/sBb7kgaT77he6nR139UdrNTx2hpIkXIin18m
	zOnqW+qq0rWO54r98K6ladkRbCSrlqg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xp3aPK4o;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sQXF5JwU;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753756893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82p6V9zL8bwCN5w92ScfK0yXloKfOH1DtaJZIKR44b0=;
	b=q27LyXNKRmRwex52ANZjtJ27QXuDKbLdg83p80t2eBYMKUlbs+ji9kICIWXcAabNilpO/F
	h6FTL8M2Kk4T+DQJT1UG1vrdRlaBiBZqCpugY3v/IIRPutt4XrbCD3yVNndfGE+9eIGFLs
	1tll9JS9aGxAM0RVzrilyFs+j10GPFk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLg0dv011889;
	Tue, 29 Jul 2025 02:41:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=82p6V9zL8bwCN5w92S
	cfK0yXloKfOH1DtaJZIKR44b0=; b=Xp3aPK4oPmDHq3Lszqb/mq8dYHEQgEioiP
	q2wb07SGKqu3qRbFFFdo1M7U84T2/EsBeYtvCWoOM/ucGRJQWi5IIQ9nGCgvICkb
	8Lv5+fuphF87LcngdyC29pKPBSe8PgQ5NbHY0YF8TpNzzK6xXOZEMG/uOYG4RZsE
	oYA/prJCBUWiadCFzqN8XKtHP03Am/UhRa7OxZXU5FbqvX1XMwDAmWnKgn5583wq
	bN9ImvvjBoug29UqG4fcPqWWiwK4FGtehNgGJhWOqurcR5AivjeQLz6Bzq634kmX
	LwT+RdTzjlrFRSsJSmMJ4EZXgxf5+iF2+GBjrbc54N2CrT6rZKyg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4e6t63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 02:41:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T0FMie038608;
	Tue, 29 Jul 2025 02:41:28 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010004.outbound.protection.outlook.com [52.101.201.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf93ynt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 02:41:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpk1XexveW9ELG8mCH3T0R0rUK08J4/5xHwE0C8TYWpythNJeGDYtQfV2PNLOKHBMJnCqZZnQxyt7YnLQgyhvxs3hU8b77KFtrw6WTHXSAt2h1d8zscvnvg3S5rjBj42Z3jtNys3V4cRoDHsIZn9S5Rwuc4QUj4t2YtDWrPUXMQAA19RGLsGgzuPkQfzTkDoyiEA72RtICVV8HSO45UvO93ZmiqFcMdXSBMrcEW28lC6xLSIpDt83VDv/NKxccXa00xgrB3ZtbJvb34SAtogU0QtdpM+2ziiYiCWGVkvXpFiLPLqfB/b66bb+EaiKftZDoGe4aws8Kmx4smDcq8f3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82p6V9zL8bwCN5w92ScfK0yXloKfOH1DtaJZIKR44b0=;
 b=sb5vOJTR/xPAchcdSUn4zwpRxo57xVMWdt+1Ay9IaDQHu4++Z2LX/lmw2VldAQTYh3AmTYv2kMUSve3Jt1Y5sZkgnYveMeg2zcICzQc3Spl4ewGTh/Vc1zWo0a31mRjDPlRduQRG05Jla+U283869d0U+6EFi0+gfo1v8cJsrwGBu6I90rO+1DHKnz74Ust9ZKqaZzhB3vpPTMPuvYPVb9camed0XM19wrt17iDDv6hpMPErSzRMycria2NB8s3kIsUKxizuOTXfCoXo51qdDwttEPyD9m50juwT1IG3Dh/nPMOupm0tlbWyhRgIn5fitKGLkzkQ9yv/VvXqsAzoYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82p6V9zL8bwCN5w92ScfK0yXloKfOH1DtaJZIKR44b0=;
 b=sQXF5JwUvzUgAFxILeL36Id2v8RdEZ98tjutQ1vNyKFgITRY6GYKbLdcqWGo/McE9hNPl8ZjsToBXnczIXRbMhBu5Er3MCplA0Fqd0onjVUtH/r3Dsq9Cutlht0lf6lFtG31hTSVUITmB4Yc9UfCdoRkWQAFXeE/lHhHtgGpLCs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB5105.namprd10.prod.outlook.com (2603:10b6:208:325::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 02:41:25 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 02:41:25 +0000
Date: Tue, 29 Jul 2025 11:41:19 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/rmap: Add anon_vma lifetime debug check
Message-ID: <aIg0z3ItBtlMZQAI@hyeyoo>
References: <20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com>
 <aIb3In3G7XygrXNT@harry>
 <23b583fc-e98e-48f8-bc8d-fbf7b47a188c@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b583fc-e98e-48f8-bc8d-fbf7b47a188c@lucifer.local>
X-ClientProxiedBy: SE2P216CA0027.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:114::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: 772b55b8-9cc0-4a35-a6f1-08ddce4968fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+lN1/6IyYjrXufEZ6sKZy4gLHOpcE45BFkxKF2mvreS+p2YOuuMgtT+SJ7/j?=
 =?us-ascii?Q?VVlrrxXNYzz+6+MqZkWyM8gLoVvOBe92ClyONgjwoyjPK0dgmINweX/CpRZc?=
 =?us-ascii?Q?nWX9kqdG5a2x4Sgk2HQIfvjzwAAoZFf7WbFQIvMeHzxrrokqYWZU0tgFqjGb?=
 =?us-ascii?Q?zvHQrfcjRssakfDd1EsEQv8088iUDHwb2+cogI8diQmWH+zOSMNJqIK015lX?=
 =?us-ascii?Q?2j5s/doQ1mWJNuj8BBbDFMWpAPC3pGFMusksWh99VxRGOANzIm8QuQKYk0Uh?=
 =?us-ascii?Q?gZLThpu6iokDAAKxcygxapbAk+xbg4qy99h5OiBZ4YvIoroK84we6VQTcIwc?=
 =?us-ascii?Q?ErEgPyTwbGRjtGaEnRv103pzD6QgMEjwYxQW3anTkiOeLheQ9jIgV47ltV4E?=
 =?us-ascii?Q?IaXzygMPvTBpdDK5TgukE+lNJFuTKG4ItvEgzzCb2ezgmEk9gUhoJTmBrFBd?=
 =?us-ascii?Q?5n4VMohS8+841knNeFhY2AHT+K52IBlPcR52Q4oSpNIkMRV2a4lWhToeeonP?=
 =?us-ascii?Q?3/1DKuVoM7BpQuNHSaQcnSKweSMauof5O0ky3bZSn078z+FeobtPiEORhaoM?=
 =?us-ascii?Q?3XRDBgreie9eO3aT1W4NP7HS5dKIEUESbuidh1y95gRwlfhXLkxTwlf+QgZ7?=
 =?us-ascii?Q?dSdJ2yTKiuJF5xHBpH3/jyWkuuFSmbKqPL8Ean9mKiBvPLXF5DGNdZhbv0f/?=
 =?us-ascii?Q?l0piwFdp3PGja9xid4EIO9t5j3caJ9Qp4QZBURftTyCDkgljVq1435PGuTC7?=
 =?us-ascii?Q?YBLkOQqtATFgKZvI430ztiA0AKqa/Cxv+pfxGjkIT3GtV6HQPxmZYroEYBWk?=
 =?us-ascii?Q?fJSy44mlOuvzpNeM0tBNMbEVaKrdm/BGtFprGLsFZ8LVmOYxwbJeh4g7PuN0?=
 =?us-ascii?Q?BmAwHuXGM6ldRPCzuJdBQagaCA0ZA3QnMgmSujpl4DK5+9HQXSmYVW2Ef7sk?=
 =?us-ascii?Q?2rRV7stLcEVqGq0OG6mOJq3/myO3RohxTDiEyiMFm+Zm1HrSzWJrUh9Z1Be2?=
 =?us-ascii?Q?vylMM1v32JLMXMT5YlwfMb0fvtpJdEyaoPXn4O1J0ijOpe9/Lc7KKnaloaI4?=
 =?us-ascii?Q?CYiRT0hrSQ85Xd0EXVHT0/leVBX9zTUvmMEegruoHNLFILSTYifLkFEvbDRY?=
 =?us-ascii?Q?2tqlc+j/LlQKRQNtru2yGry5uYITrK16GWa0ORHwXsyf34eqYrH0xUugDBsL?=
 =?us-ascii?Q?KXhamTC5xU2L1sU8O+ybzeunln0dkKRnlBx6vfLgvUg5Vbtx3xi68U6lHs/L?=
 =?us-ascii?Q?pDqy/Ja5yzbl5W++Ou9WS5qocuO/p23wISXk0XqSt82nZPYZAtfGfraU7nax?=
 =?us-ascii?Q?aiSstS+H0fh3p3ogPdIb/T4Pq2IKO2AXwAesUJnRJg5GnFmDmZP/EXAX2bd8?=
 =?us-ascii?Q?u3AfzYVjLQ7SZpVlon/E4CjjF/Idsy8WCcolGq/ISydD/JIox6HrvQTk1ZxM?=
 =?us-ascii?Q?J5kng/fVcNM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AyFgXhG4lBJgwJwkDnxCGcQhfLg1SROarESUa7fW6xpMRjKRZM5jkgRKxS7Q?=
 =?us-ascii?Q?a1010IS4VxtxnzVww5t3mLYsa7adDlikSd/uVar1EPeJYso/EJuSgDfnC+iN?=
 =?us-ascii?Q?GoBfaEqmIt8FzyqP6NALhnlyTqcUYctvHNDaAePRME8U6VmTK4koyzbJLXp5?=
 =?us-ascii?Q?nzYQhsgZFg0uvhz3zkpkoaw/xFQ3EJa7n86SazRI6ChoMiYEC91pnhXZqHk1?=
 =?us-ascii?Q?hKsT9nSqAsQ2i9kITgTi9SSeWCEHWPAxQiulKqGGp8HdAuqsVkyECiQonpud?=
 =?us-ascii?Q?9kb2PHGXpwTyf2COZIftlqQ2LJGM63caXad1g5Dr4gaePCz6iU7EWZXSab9A?=
 =?us-ascii?Q?G4bVo1KknytKfIy+Xw7dOCPWw+Cz0mvqULiGbX1G0oaocNpAymidsl+kFKlf?=
 =?us-ascii?Q?jx/0LwyrgsQsmFyqz1mpQWGFRwo2aEpSDwHjr02Yp75/zNLr6RvUka/N7tfS?=
 =?us-ascii?Q?pkgTtDHAOYExlgCKGY90iFSDwNmXemByWHh2C/KcqUzH9iZ5qmzlb5DLiu6s?=
 =?us-ascii?Q?9h0AXwQrOR2TUig6mewd18NKL1Iwnvn/Qd/kpxEA/SgwdfBbOF6dXfzRf1eg?=
 =?us-ascii?Q?QJ1ME5nLdGzPf54FDzGv1VudM6HMVWNRTBpgYD/AmlwV+utLMGIj08GeSgBa?=
 =?us-ascii?Q?vywVwgMURlM08a4aAIG8ya0H71syuOXXueauhzDcYWS5HtgCO7LiVEjKUuEF?=
 =?us-ascii?Q?K78jsN7K4dOhx87cC83QBZeE4bXSrfYwwceRk8favn9/SgiVOkvmug7uluzi?=
 =?us-ascii?Q?nMFr8avdABXxK79vz5oehd+0tFl/KtFJdrqoV2Bq7FK1YpFqP1YjHEwx+b+a?=
 =?us-ascii?Q?Em2dg9B3rdhqekE1QaXeHuI5Q/O248MekE90TbdC24FO2GeE9NPSLg41yiME?=
 =?us-ascii?Q?pgDN7mVrXoccjSDbSY17mL+YDCtnz8AgjfPdG6e+aUAtse9JwzSLDpA5xkzT?=
 =?us-ascii?Q?JWVbk6hsUPChbumUx0MeTBaiWbeIWah6GRbZ3TFBOrjjiMpuUdybp92D4qSQ?=
 =?us-ascii?Q?G1xexMmTA0OEwxBV8Z21NHwcRPb/tlJBsKHZVDA3cqQgboBHw6n9eU+xwgNt?=
 =?us-ascii?Q?lpEneyi+xSsa1rvXJQEiu40MdHhp/NwP8awtcWIMe8K3n8dpj+9oz5toimt+?=
 =?us-ascii?Q?+eWUzj6pBXdoLTEcLhVZuX39UvXYt486vpwRndzVwAmb69vx13HDAw1rAHwd?=
 =?us-ascii?Q?chnx8+ZUKl9qPMM9qRPQNBfzg2ihkKH0c3duDbVIUeZ+DgpAMhJy3hJAVqKD?=
 =?us-ascii?Q?w9oL+rtyt3pbdnhbI8uITPRCbnu22cdbR+2MnkBffneA7xt/dMwHEU6euhR3?=
 =?us-ascii?Q?xPhySKLuLYKlXs5UJZNOKzCw0f8MdWpa5eK0GfDM7JAVab/M70ZIMsBjLFld?=
 =?us-ascii?Q?BANSwqVNHqH+73hqe3F91WtNT1dnmQ5mE0UXRF61rrWL77Q1WTbcoS2KVXIG?=
 =?us-ascii?Q?6LAe93k7ZVa4IusBPqbi1VKzeXB0yo+tMPMdRLpjk8+F5wYl+s2OkeXC/fUL?=
 =?us-ascii?Q?CJ8yp97BshNzxNRO4y2hP/ksppGa+g0TOsckjMSC/7W7/U/UfpcLYQ6vJvVd?=
 =?us-ascii?Q?4qSRRIsoWCuKGJ/wBI6wzEOjgdXiPg5aqJGB+7ZH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H2fTlc1Gl8sknwgEAVFqjHOHGqzg1DNlSjE9s6wD2Tt/y56SMex0oxUHomUGnAk7xh/hn67CeJ0cULF90X+DR2ZbEAS3oETzEnUvlFkuwYpj83rpySu25f5QRBuaKoxMF9CjjVFqvxIIs0catig/+tnCyxhCaq5Ko9jk39Io/87QzOwt14oIKpgg5xCpGt+ptL2uzy3GNyaitrM2dIflbZWgxdLQiD77ZTicHlywV6MrcSzYspN2BhklcvvoJ9PMiXwXHwLhJfo+m2srIMd/+kKtCNm0StLxTmn4WL6Fq8S+m+/nKprW2szGRh7Zg4aE3PjZ7VQWuvwaWaRlt63+mM9mopMpRUfo9UHROptUdaZgL8l+dIZS274pAJ87HrR5fvxK1MyxGcH3KpmXU9Iy0oCh1VOKnzxXGqyXiyZzON/VNByE+AmlLWiYVhPT616zJv3xmD8djKIzjIDoUNGTPgXsxje6EGinc+Uz+86z47QFZiliIcZnQxwRFp5+5CQgeJOaygeUkiQnjstkBv8Mlq8SSwq+VJK7SIBAqSXZ2hg54l6PWL+kmD/0BX6WH8rqki5QDm5YvAADOPEKereoF3RQYzDBBleVXUyrkzYa/ls=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772b55b8-9cc0-4a35-a6f1-08ddce4968fe
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 02:41:25.0082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYEwqbsJpjXS97MjH0O2thYDqkXGxlTeyziRK93u3V14rujWSqkCVlewJULo+CR6oAVeBZF48b9UzRohBd9zPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_05,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507290018
X-Proofpoint-ORIG-GUID: YkNNYaZl0psOLSue5yiixsRVsK13vfir
X-Proofpoint-GUID: YkNNYaZl0psOLSue5yiixsRVsK13vfir
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=688834d8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=HfXtUMgQtOy35Ef1TK8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAxOSBTYWx0ZWRfXxemlx5jsRCZO
 a7W7soauvh2XVPHeu8S4w7wG5pDZ8gOhgZe2AeUiPJBbCji5TbpLEkjRJAkTmfdoID7n82/7i6z
 /LTkPwr31u9ikPCHh1Cj6ecnejIxoMl3KTMUN1D/HWBJIzVFvlHmOtGg3vM2N3iJqkQYNhi4vNJ
 F0IkNIndgq4/gZxN/VchO+9Rd5EMyI1sdNV1KWVGs7GvWz+6bQSUVZS8vZjK3xmkYOW9IAwic74
 QfJT0e2gwCyhC7DDLCJA6blPgaElk8nId2FkKj+LhhxAn991ksvke4QY9O9H3ivEzpSQ7ysFsyQ
 VNROzQrquTSDh8mvm253i/KYC9qrUlWc89v44NRoqnbMmgdZ94lD+zWUlFP0HKMgR6g7q7xOanV
 zRs1usilhLv5+4Sr0wqgoKHtqdK1ilcUHzk76SZHVHSQ8ozHVqp3W3ACaZ2pUoxohXiN9zK1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8342100008
X-Stat-Signature: mrdcrhe8bmygt155j3e473b5tda4tuhi
X-HE-Tag: 1753756891-574166
X-HE-Meta: U2FsdGVkX181fjJLSf1Rab6rwUfvxsNdQLB+/3ZLYW6WVHIi+BXVwqf+Zm/OlBb2mYP0ZXCe6Y/eXG8a5aROZhVRVeU6nIOjslvpDrUfvGOma/WleJScSPDmOJ6FlYkdvzJ22FPeErBakAnvWO4eomWWCowat5Oxo0Bs1wNstFPpGzHEbFFeYEh27aQ05W/5y2x6u3ubPqKOvEC+H0a6rkjQx4k7tHRVJN1zSL3QemtN3nLfTBfDvEJZlnmyUKEjL3FPwYy80SWaMwruJMswQJfjnd+PHYjhY1SFqp/XmQeEJr/0diIDUyk//halHStfgLayOFGMlmH7IKiVCLYspRkEWv11H8yp4fHEF2lu76gA9Oad+LomJWY9tJgNedBwEEsIHFsYXcym18CO3JXFkOsUT4yYkXvT7K2RLxjClasqR2r3Gx3c9OiHZps4imYJ5GuhyS2M7k52EIKJCoalzePw4B3Y7H5v+er41fkJjw57tOj0L9CgpMp4ZbV+37C+7eqozpqp/wogv6OrOcufXoiCAjCbOMfNYl6YPlEsvQ4vMXJtdbGliVUYJkhaADR+/w+8aDlXIuE05qC14SMUtk8oLptDINWX/6iy6UZEKw+2TBJkNBhwy1jIFPNiB6aZPqgdAU0nFfQRrkhn5YvEnHZ5bZanHDp3TZHxoCViXEOZMWilrefkUk7MD1HQrvhszAvwTNu0O5e7t/6qoW4Q4dOi8r9OIZoDMkyF2nSNYDxju2JAiP1tdzavGzAxK2ZActZH+QylybvquwYTc/n6AYe3ZWoMzbOzKmOP+NHjNcwyhlZlY4KOXqH65Ama0Oh61f8fbMDFq+dXpmcISluj10ZEbym8KgE6eUS7DuG0mV2NcKfF2ND7Z5r2JuH4B7TRTITZjeZWcMPQH123KfPt367+oyY9mLH8ZEd+cMEE5LHv96Hdk+/cvsXlP05+6X84HyWR92vQdFP69sxlsDE
 fqgM4D3S
 NOkYTUu2RvSJ6p2iTYbsEiBFZZAsxT29hOtwMuBut7hVS513Z4ZiY1IfFWRlkyt8JrQ1wZKDDycoQOT2i6RNV76ikxj9bomiGXXthl/cdlXXZyfzzsECf7RFdAF2LDaDmue7iqoWSUtII3tBIfRjCfa+U8RtXqo6uMNWX4lopN1zfvYtF4XxMJzPHU1RGVEf4GGAxfYXm4pgKNtKJtsZlNByn06ySCoMAJQJegqIXhhFKTCKyOYhQOBBBC+smzbIxesCF4eSDSVpI0cVc9I93c/zxyzZgdfb5DhwPDBHjkBJGtD9NOYKumdHX0XLa1lUeN1Ve/U6EtJ4NMopipq7shxl4lTPAgjAX+hDDvXUCg26CO38NdXrMnl+6aQVZl15y07c6tdmGjHL6A4bSxYXyU6L8OnIZrEa8HcIdVYzrqaeGwNF2gNIqDZSS+3uqmCioP17xTh30YDndpwpMbylCgOUMs6wVVrUls5eqRWNNrus/9XlInVX9qMXPuidofebFm9fsHVS2lUEvmnW4KQXGjIBU171V7fNghvHmg9rrzbUZ6MwIfe7py7l8d9EI+AgUDXj0kN3VHQGk8evQR+35Z3nJFCK9cNuinP8Cg8clKdij7VdGELgnqOPHzM4jGkTN3YCKajV1iwCcLNOpM8W9Vp2TiMyk8BsJL5aeLLSLBA/ubCEtO4XK8WIKW11Ap8sWrH+Wa2xv8tHrs6JCW6VH7KZ0sO24KjjfvByfvzAiv18mYBmADvrCeuEi5KqihQ4EmULKYUINMzeovIBo/oOilSP97uHRe9est7jbKbouX+cy/B8wTddomwHB5aZX+C6eDGdJgLejuoz78g28n1lEWNmDLZP6ZOgQzkG5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 05:33:34AM +0100, Lorenzo Stoakes wrote:
> On Mon, Jul 28, 2025 at 01:05:54PM +0900, Harry Yoo wrote:
> > On Fri, Jul 25, 2025 at 02:16:24PM +0200, Jann Horn wrote:
> > > If an anon folio is mapped into userspace, its anon_vma must be alive,
> > > otherwise rmap walks can hit UAF.
> > >
> > > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > > walks that seems to indicate that there can be pages with elevated mapcount
> > > whose anon_vma has already been freed, but I think we never figured out
> > > what the cause is; and syzkaller only hit these UAFs when memory pressure
> > > randomly caused reclaim to rmap-walk the affected pages, so it of course
> > > didn't manage to create a reproducer.
> > >
> > > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios to
> > > hopefully catch such issues more reliably.
> > >
> > > [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
> > > [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com
> > >
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Signed-off-by: Jann Horn <jannh@google.com>
> > > ---
> > > Changes in v2:
> > > - applied akpm's fixup (use FOLIO_MAPPING_ANON, ...)
> > > - remove CONFIG_DEBUG_VM check and use folio_test_* helpers (David)
> > > - more verbose comment (Lorenzo)
> > > - replaced "page" mentions with "folio" in commit message
> > > - Link to v1: https://lore.kernel.org/r/20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com
> > > ---
> >
> > A question; does it make sense to disable reuse of anon_vmas during
> > anon_vma_clone() to increase chances of detecting this? (of course,
> > for debugging-purpose only)
> 
> On the other hand, it would obviously cause more anon_vma's to get to
> refcount 0, so maybe it'd increase the prevelance of it.
> 
> However, we might actually be seeing the bug _because_ of anon_vma reuse :)
> at which point obviously it would not help increase prevelance... so we
> should keep behaviour as close to 'reality' as possible IMO.

That's fair enough. Agree with you that adding a new config option that
introduces behavior diverging from reality for debugging doesn't really
add much value - it may even prevent some bugs from being reported.

> Finally, I'm not in favour of introducing some special debug mode for this
> or changing this code to be arbitrarily disabled in existing debug modes -
> let's keep this change simple.

Sure. Thanks for the answer!

> Cheers, Lorenzo

-- 
Cheers,
Harry / Hyeonggon

