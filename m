Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC3AE6BF3A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8B46B00C0; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923426B00C2; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DA56B00C4; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 476A06B00C0
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 160DE5AB58
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:17 +0000 (UTC)
X-FDA: 84389850594.04.2C832BC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 486FC140014
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UcYwNVt9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=E87C3ZUG;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmeKxgO88hyfllkZzZCoWUJVEC/PG2836wEk2mNISGo=;
	b=g54jFwVD1t9MWB4Zsxz3YGll/YQpDPdGS4sEiS8daPpFp+OHc8cVxdFXXGQ9PHqBvM7Hof
	cjH1N2wZ4WcTDPC3Xs+UJzGziIpqcdLH9nHejwryGHOGVCeTZjghqN1g1Vd0MBNCPtG9Qz
	caYUWQ1LRPR0jos+mK4LL3rlNP+80Ig=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UcYwNVt9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=E87C3ZUG;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806873; a=rsa-sha256;
	cv=pass;
	b=sl6zcrNPg/5XKdFPA+z/i9Pwv//gx/ol3pQGSzX0MzU1lqsu9O8q5wQqVNS9J6Q99txhI2
	AoiNr79twFz+NwhJ/2IOCRLG94zXipuTfz7Xvsp/2vemmWm7KSgyNGZOvP/X5qWhxlrWrn
	b88PZOemYdT9UZlZ/sdfgczDP7nZHZg=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDFAA3538359;
	Fri, 30 Jan 2026 21:00:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HmeKxgO88hyfllkZzZCoWUJVEC/PG2836wEk2mNISGo=; b=
	UcYwNVt9WonXkg6vcpaG19Qv77127lB+nRByJpSv/SXgd79dwu+G61MQ/xHSl1fe
	roSdox1ZhE+6gOQHdeR5cmsw9OJZq0f8pdoTFalV8OAP0v1wv5xpKqzXVYIgCoCv
	prfm9my0wEfOpNCNjgqURkz9sDLgCpBySHgtLGn9JlRUct/IhKgAU1EqcDHTFJw+
	RQcwkcP5ySWiEehXmHZekwO4V+G8m7fUbjnxj7wVbcDTiHuSJvhRf+ysVDUHf6ya
	35p+u2Tco1j2VbJYDnKadQYKg9KLPZmGEL58ZfIakzk5EBQMF0eKDjmAcPbwa478
	od/RvVC3dmK9k5jCDEnSlA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10b2rcrs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UKs4rE032717;
	Fri, 30 Jan 2026 21:00:40 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010007.outbound.protection.outlook.com [40.93.198.7])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4g8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qtvHqsDyd8E6hU/4Jf7dRtOH77bEc4W78GbRtxBRRPXaKrG12lgKLpcrn5/dq/v3Gewjni9KSX4MgO7158/lL1ytTxkoCv4uhsrqoHpNgxtM2QiYPh5FhvFMT44DoSqR70++Y+Z1G9N0Tk72dG3gyPvaLWAt4tvp81LSFpWqGjvPGTj/7rrbUcPxjiWKTLvbx9g+Lbuj7wLDG3PCROcRS6pMRH1MCWIp3ecc4SvvRhGqKy+zL5xaReIF4gQq3pb6ynm98Rw41x08enmNcTJQBJPYDeSm77DaqxaMzzbkQUZiGgtokyTgC1BIhz/+SGaBH+Dsdn8zUsui8/zsZQjbow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmeKxgO88hyfllkZzZCoWUJVEC/PG2836wEk2mNISGo=;
 b=uBvH7pb7aSQkNFq/cDmV10M/gbMSZw/NqtKYZV3iSwyBsY2PyZltCxpCETE4lGWWO+llEAsH5XZazSFVCrhOJhYxcSmUjVNzmxFITXWP3QUjRGWpy/N+w+t6pVU5v0hwX1Gk8XKJ7YL857YJRt5HsP7ssqD1/2PLbIrFCz7kmVsc6rfov2+mCsyr3/yqpRA2rbEnxHvgZH4KETXLSBsZIeO4ODnFBhE6GjbBnNezWNjnWZhkl/GraXyeZXUJkSxd+lF22UtRpcNjkP1jrIPi8P3qdofmzrUgyuvyFEv14QuRJQW85LRfM/l80kSy5oT/Ud/kEFgmhdb3GmU9lzXb2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmeKxgO88hyfllkZzZCoWUJVEC/PG2836wEk2mNISGo=;
 b=E87C3ZUGG/HWto2S/dNKbzzwHTsI3TVkyCjrPfdXoq6XpU7QLyYRx63qJfTtYfpyYyN8VK/0NxHKWIle/FwfvS4UBVPGEipbsYDbHM5gw8CQTdPJ8Firy06+Ihk5LueVODY0ax3KvczJYCN1Q97r7ER5jaXzAsc2Nx+Ikclu4dw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:34 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 17/30] maple_tree: Start using maple copy node for destination
Date: Fri, 30 Jan 2026 15:59:22 -0500
Message-ID: <20260130205935.2559335-18-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0153.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::32) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eece3bd-6bd8-4fb8-34a2-08de60429c63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EZaJG4fm0YRHtxlQTVTOVUgEkLq5/TrY6AacyceJ9luj+h6UlEo35VYOfy1f?=
 =?us-ascii?Q?cuPesx6Y3uY8LpxcaRinuYL5rvWin/IvVdk89GR5S82UTkylAT17RJDO7k0X?=
 =?us-ascii?Q?O+HCMmA3WOJdyN7MmuPB3c9kkjzdboxgRkQTGgfNf1mK7uPsSEw/zmriMshS?=
 =?us-ascii?Q?X66oAhbT62E3w5irAR7bgTepWCHCjTR6as7kTJocjjUyd7ECJRmonQJo8/lS?=
 =?us-ascii?Q?eQUkFoEOATzr0zhnTTo0BTWxMp4j6qXr/onvH7/GSs51qq/IGkzoe9HMTZwh?=
 =?us-ascii?Q?uIWyxzjJn18u99dW4djsoeCgrmDsRbCT2ToSGJ1g7n4IrTajo3QuKozurYAX?=
 =?us-ascii?Q?7zeBZx7IJhXEDmQRfs/TEGiF9YGXKZoca68U0OJr37gc1o1AxaSPsydeSpkI?=
 =?us-ascii?Q?uFQSgrx9qTB2Dvr/YzrMVGCr8w7wmyLzXnsVYacmP2NKQAJISXI1N63Ny5iq?=
 =?us-ascii?Q?epjPqXt62zy3o1dNNS3Ou3L7Og8+4wrebylWu/qyvMPIS5ne+Gk5VnONu0oE?=
 =?us-ascii?Q?5+h8Z/30tgFWGU6m13y17aElQDttp9s6gFPlod+h0H6+I4GjDwiM+olwR7pV?=
 =?us-ascii?Q?UFxh+MDebxJ6hWJCWTGMPLrXE+lu/62sOwffewBM5u5b5AHN42ynkUM04iXT?=
 =?us-ascii?Q?BfTfKU84zRzV1ubi76WsZFx1fvVj1c+BipCXYEHCGPUCShx34SbbA5U8oBK1?=
 =?us-ascii?Q?umVoFSSOAu/NFe2AKVhr8s6Zz72fkYXplrOBupm/VJcc5ePC82s0Z66HYaq+?=
 =?us-ascii?Q?L/A+vk6VdYZqIxFz/SBdoJKkYAnWSxv6y8CMrDeFKnY0YToxRxJqeBEBnvXV?=
 =?us-ascii?Q?saS9RCZVZ3KYaQwCeg9oleK1xi0XTlFpSkOepHg6SLue+2HiYXQOeee3zL5X?=
 =?us-ascii?Q?MQtdsR84rlwUY4urTbKoR3n15aPfr/ixkf+vUqd4krNnBDpDZH45PKv0n+sd?=
 =?us-ascii?Q?GLPfAocRzpWuj1iakDFfgAldMUaeQmHjFlUiotwGEj9CYe6qAbR5l74XFDX6?=
 =?us-ascii?Q?9Fd9bT3ZT6skm2uWQQr5MxAtEvkORft2yz8rYStCi4BjpyZCBJpk+dygPJct?=
 =?us-ascii?Q?aZJhf/jb//I4yvhG6zEwOjeDmxtrUGXJeAV7ozojDHA4jZxlSIiwRWErtB3H?=
 =?us-ascii?Q?6kJvDhEosQCUQPCQqGWpcEVyNRXD4nDehjxu621foHJAcuwrfNNxULiIDwPH?=
 =?us-ascii?Q?T2vnO5iuXnPvYhhboIuvQh1Uf9WjSxv5BhlrSpnHgRnO66W9dfu+o3J7OUMu?=
 =?us-ascii?Q?a0MN2GDt4/L/YBWfsdzI35156yfd8tHrwNryOF9itHhoaEZjgWMf5HUI4976?=
 =?us-ascii?Q?ZI56NAp/l97/L2Cm7uO6Y1lAMjSjy9fHF89kRwoAXt2u8lc3VApj1MlVFzQf?=
 =?us-ascii?Q?JeDwyHtJvUc9JrPgtUrUaUn4nFUCGnIK5vHoGdY1TgxXuOqiS0BOXgP6n78f?=
 =?us-ascii?Q?wLVD5IH3ZaSxrvzJTosfJtBWMK0mt5Hb+oog3VBvN7AjTIOjQevIp7SYBolr?=
 =?us-ascii?Q?Fsl3EzLpQA44BVq3Xifo4z/ngjOSOxACU+JiPP0JkvSsmRgcKmu48KXEkpRy?=
 =?us-ascii?Q?lh7UP7UpO1gabQQ38lY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/xqEx4GfSF89djeiaiTBjouJrsxr4kN7ifzL2bxmO1imzWVV/4aSVZZ3hG+d?=
 =?us-ascii?Q?FB0kIf0gUqKolJaIkAo/WTL5JcLpC7jzbYj659lbTp+TpdCmh7fuDHgM6/eO?=
 =?us-ascii?Q?USndO1xr95rsmZQDBrViJEbLOc2RISvp4yXOgwKpvIdGLn+NIqvEvoEZBqTD?=
 =?us-ascii?Q?JPWYpTZ+dt8wqmWg9jCGIOLcuQYryPaSRmUC5sFb6NG3PRqwFe5EfZduQLJS?=
 =?us-ascii?Q?KbHBtSv35XKqUY615bidhvcn4NdfMwLSYSPlLULN7ZhWwZRChRCyTG8ZKJmX?=
 =?us-ascii?Q?N9eqifT+iFv/Zg+7n7u9ZP1J6V8cg2rB6zX5iX1eAOvVsotWzevQslgV34r6?=
 =?us-ascii?Q?kwX2Pfav8+N3NWhifx4z1aOrQ06MpsVHd4+DznmJfKRfCd2GZf+9KCvUtNj8?=
 =?us-ascii?Q?zNdozpqMGSclaFrhcWvPJKYRym4H9KuWLTE7Fp8jUQe0gc1C2cM8QeqJGNpP?=
 =?us-ascii?Q?QO+D2ZwR8cFzNlCr90mnEOtCFSfSGMhaBILlvwoQ8WVEOrK4gNlsPtdVtbxl?=
 =?us-ascii?Q?QiQPZZpdBGzsUMzKIxYqq/GvCD3t2FcL4DxaB+3KIFFkpXkeISrA93xVRmUW?=
 =?us-ascii?Q?zSVqZNrwzyUL7tafE8/1LdCy96LovVzE2QVkmrICkjQi7gWrKpF/rp7caIm3?=
 =?us-ascii?Q?TOzO/Fh+q1AVcnBxh08U5Aal5gUi1Kya+Pk2EKmJAibHWxGMU5v/9HLqK9+8?=
 =?us-ascii?Q?fWWfIzZecQnEb1/GYedPn4tOGsCP+1XAv0qehbgjv29XGEhgBfZl73muVWMK?=
 =?us-ascii?Q?GEQd8PIu2vPRIZIi3AeCpNelvsmJcy32ueUWV81w6ll/UAEaLzeSUuId9fmU?=
 =?us-ascii?Q?BU5liIL6T0vTyBmGFjj4Bdi+i1KDJRRFhBQj70v7h0Rkb/TRjl9WSe2pPRTW?=
 =?us-ascii?Q?Y9iHPV4FiiV2Wdg0dedXgzMIF9lsV/yv3/JG1yZDUqfUGaE2ScV1QtjIxwGy?=
 =?us-ascii?Q?JKd0KKmsR2pPoTYjMWbFzWvb+kbxxEcPdrx3924Ql9KpOkXSTvbvB52q8ZA6?=
 =?us-ascii?Q?FWmMP+Z59o/q0XNs67GJ8IJG5bCl7eqUYVj6odqgI289uVUM/ipq+ivFKbYa?=
 =?us-ascii?Q?oSKUwBNh8ODvKu1dpxGidOp5HaBzLeH6cNvS6T2fnL0+Lw4UkbPyYUns92Hs?=
 =?us-ascii?Q?xmzX+9VAUXrMY3Kvsvf+mgOoTw808uhnxhLXYs1BeuyJ2KYzVjRi2U56gLej?=
 =?us-ascii?Q?KvEDILrXQ7YCnvj0CWdsGumZMqwCU7vvQVareXNDMLDffBx8fq39hl+KOiDt?=
 =?us-ascii?Q?IcSfZV5Q1YhUYFBFgtrEo+/vPuEccyiLThaRLxQKygsMxgqX7lmIZ0quXbJ9?=
 =?us-ascii?Q?nYBc+t5F3M1WCe5f+z3WVmH5gRIIYihp/2+uh4eetpvKXtc+6YbbBvth5Ov2?=
 =?us-ascii?Q?2JBEwbNA7PgGu9QQ3EvsQPgIqqn5TvYKNuiD3PshGYLoAiPxC6vv79DTurim?=
 =?us-ascii?Q?4B/awA4z+/bvyr91ZI8JQYVHrjDHBQ+jhH9cS13Rkt3I68oflrgsla74aagI?=
 =?us-ascii?Q?1FDAeChc6Zx6d48yj3IdNwVH12RSV7yW7M5jaG4dX4RL4LsOnOK4ZdzUEeei?=
 =?us-ascii?Q?IoMia58LvSTaz8gs5nl6dtNp6h4f/FuGgCfS5HlIhBANvMdl1A8Cf8HuC+I0?=
 =?us-ascii?Q?/c91j8Ts6gIIutYFiuiI3dQpNcmA4mREWgOuBDxBWKnt18s3momDb8VDxpdT?=
 =?us-ascii?Q?xIwF0qKyYsTT2uhAWLfhiJnZi96h5zxwhCJzxk8Y4E7acW7Vwfhvlb5wyryu?=
 =?us-ascii?Q?JMfe56pqtw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a8pZYZ6wmtLO7bUICjuKTYhJfPXnwO1ZTbOimvqSkUPNCJRIg6TNCzUCwK0WQ/4IPXvAt0fVnjwT4647PC0XT2zNvHUIBdEX5ma7JE2BpAriZB+Y2+UaPR4DX3v/ioB+EnwjJ5GozwFC5w2LUhij8OtMVp0aVswAgmkx9ICS8BupYjNl1QP3mBVXbysv0mYjpQzG/Kaen8/pUIokzCXEEtYTfo5gcp2zr+vMt1r8R+a/In4Py/1OAGDsQnUo6is1TmJj0W6YdAJ9PNBtfZFxktt8xkmucnP2WTVAUgP56sm2LL+tpK7/TjSC9TjPq07qg3MOlJG/eI9933l9X9qN8GREzQNNaII+3v0gaTJ5K4N4bYuvm3eqdUh7rRI9i+XbWkzkrYn6/VaRFMmFKNe6gPEe8JLRzrpRdP16DFSMzXinzPPMJDKTKlkaebauwmDTThe7dIKjKuMCN9Z72Y+r1VzjOlZqpv/yiylOMrFvoSz/0mWsw13J0OUauXSxMqgqNM068VHEp/9fFTOJddSLO2JKGH2uGZnJZRiam+FdP2Tde7dfodRAiZuMD/qkp+mFKserU7CUHjWkkqZWuhsC9PbXxu+E18fz+h6sXesErw0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eece3bd-6bd8-4fb8-34a2-08de60429c63
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:34.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VD7fy/InQC+ObNLWJuOT9pwYJk2utvZwt7uVC7dihvpkEMibAvnCNid6diLc+367V8tgH5lPM0dpYI1ejHW6Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-GUID: EOvLayaE06tPrDhqtHrT2607FvY7Xp9N
X-Authority-Analysis: v=2.4 cv=BLK+bVQG c=1 sm=1 tr=0 ts=697d1bf8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=ftHlONicu1wf5FYgji4A:9
X-Proofpoint-ORIG-GUID: EOvLayaE06tPrDhqtHrT2607FvY7Xp9N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfXx9l4cKTzAS+G
 1FX4aK29PriavOR6ooNfZRj+yEmXwlkBCj30V8fTta2VuM8xEeISC4ysqOC9uFTG6w09DBXbv0a
 FE34IUshJrZWbHijGcZUwfSR5IIX0rNiTRaBUcdJohW05Ow8ZYV/Wj2tVT7nl69BRG2MqeGQbYj
 y9qQTdGW23s0h8iuVqeVi3hOVZUpDy0h+9poyy1kln/34zDTRU5qDjXBFtfvwTeF0z27/3u3KN3
 +9nXVEur1PRAxWIw9jhvCIr4OmJ8i8jTXXWjD22zK/5fhoGtWNJKAPDuR3VT5moEnWxs9y1H0Cq
 6xT1krJPbu0NtFGKRynM/70OQcgneFMUCyTIb4g2FwkRwVe68NvsZgmMJCbdbLVP3H7WoSlWeqS
 cJfgA/Qwq/eFD64WL+jKjonLVqLuR8f6eYgJ01YvTF46JVk/4fUtRCoADec96lwWzr4z9+2VHWn
 6my4RM8a3p+KgcUb84Q==
X-Stat-Signature: 48r6p79ewhiz685h8y9xacpm14mp1j9d
X-Rspamd-Queue-Id: 486FC140014
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769806873-740895
X-HE-Meta: U2FsdGVkX1/9kwrGKtlq/gN4A3lVsggyfCPYnzDDIqW7NawvLx+Me+qX0MahesV64x8u+AVhKQQ4H7vA5R6NE1W4quBnjFb00a9slfdktrPVYQASVe4TMsNlDsJwk1U2Nv4Cgtzqp26n9dtKpWsvgrW3ARVpZqjw8WVsjDmy/Nz6tfSyavUsokbLxsDDEgVBu6Nh+Dny0njaO+zYNjTWPGuvG2L4Ntx1i5dV5ir8mrWOqTxOrWngvrxGsX/TgEI4TXTteBtrAP/cOLNmPkCrc/xi4rB9EILpYCi5nTrM8DpdNEgC6oA2b8aUdRY+hHbFQ6xbT8tyIzc7pStKbNQkQCO6VwdOyc0vsgvM3klNOEik2MHxde+6EL5pqgVJVqGyiKLXpUSWGGZfj6FFpcoTe8rSGvQxPJtc4WBSsnxR1J8+sOpMDNMx7iCrilcvjeC3iXaxgEbbLybDKiaGSs9wN/egWQ/OFwA/bJOcUk8nZI53JuTbzNy/E4RUVeqHA2wUopZAhZ9fVWO1d0JzKP8TKkoSyHKFWev1/7qPg+v/XfPZpCsopwMyP7NPw7t4bGQBjHfRdMPTdhTgI6jbrJ3Vs/WuOx9zm0kLzSW9BpVt63YdrCA9pfsMVQfSw/NNx6+3D8LgIAS+d5dbbwEKLFTPNYcuTs3+HTAhh63LCl8YqFCri/5ID0efalmdugDjQKfI+txmDtw/QR/CDhmpYee5emFrGDh+zJ8DBDKU+dxmKSLEQrlmufrYCqM6aR4FI06q9VSzC+c+40wEE7d/fMF22pAYvfxl5KEAv06ba4JMNDhPGIFBb5ce6WK06dWxzeK2vC3LnpZ4i/JsNPSSIQWuiGbk2fNTxmzub3snRnEjEPA3E4Bsf1VGRf5sgDmS0XVk4Nqxfg4VnJQToFP1ooKuYpGsvC7bwGh6eDz7+aaOP40bghWJKPNEBJIIDsU8ZnO/ux6PsbfngLH+Km2wL2f
 t+XkwSda
 9ud6AeeUls5RrRL9VJr/JfA1v0MeCWOOPqe41qaqS9E6HnVjmCI4k9RyDuRJVkp2v3NwU+cfNN4Z0uAkIORpOgl3yQGLSvXy/2dEsNymyV/Ak8L9221t0cprp2kQjQlbWfOkcJoxXw+JvSW7lHFc+6TUzAQjs+J/EVk8103DOMmWthi1FG9MGfVf/Xk53cfvrPVD769H5Kc1Lr2Iu25Jbe4wTUZBXbm+3NT1N0uaAvxYe+//FbFjTjaMbhQSATdsjBxkNo7Lxeaz4oj3TEhCZkZLwtWlj8nZUATvbvsV2os4uErpQ2zsuEGSWGinerzBsEta11lOxYpLP2FiJbKvQqdBUxE++/ELbVvFdqu0xDpUM1Iox2zHpP28gFbWdU6Yv/m5tTyNIY6BowGlIuJ9hok/N8A+1ulxxhSqK99ouX3BK9MWzIuI6MlVZor2FVwxwSZBbeva2YgdohtYH9kuj2mO4k4Ipdy9EcrXfGolH7uEOp2thryMxnTc/8J5tTr7jyT/tYcg+iptYdpiU/KEUQp9TDmUFB/2ueBbLFWJuk4HqUbMmMeJ8Nf3LJbUMpr9wPYsMKHiivMZbVOHxDJJGZuYIo+nrcmUQHkdi/fxw97EgJI/nQgYqLmJDACw+yZ1aVW/xiMg6x4QhAyxcMCfWUMNxtcXMfoirwvWCdCI/Khz9N2M8ZdppJL2OMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using the maple subtree state and big node in favour of using three
destinations in the maple copy node.  That is, expand the way leaves
were handled to all levels of the tree and use the maple copy node to
track the new nodes.

Extract out the sibling init into the data calculation since this is
where the insufficient data can be detected.  The remainder of the
sibling code to shift the next iteration is moved to the
spanning_ascend() function, since it is not always needed.

Next introduce the dst_setup() function which will decide how many nodes
are needed to contain the data at this level.  Using the destination
count, populate the copy node's dst array with the new nodes and set
d_count to the correct value.  Note that this can be tricky in the case
of a leaf node with exactly enough room because of the rule against
NULLs at the end of leaves.

Once the destinations are ready, copy the data by altering the
cp_data_write() function to copy from the sources to the destinations
directly.  This eliminates the use of the big node in this code path.
On node completion, node_finalise() will zero out the remaining area and
set the metadata, if necessary.

spanning_ascend() is used to decide if the operation is complete.  It
may create a new root, converge into one destination, or continue
upwards by ascending the left and right write maple states.

One test case setup needed to be tweaked so that the targeted node was
surrounded by full nodes.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h       |  14 +
 lib/maple_tree.c                 | 624 ++++++++++++++++++++++---------
 tools/testing/radix-tree/maple.c |   2 +-
 3 files changed, 458 insertions(+), 182 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index db6a02788902a..0c464eade1d66 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -156,6 +156,17 @@ enum store_type {
 };
 
 struct maple_copy {
+	/*
+	 * min, max, and pivots are values
+	 * start, end, split are indexes into arrays
+	 * data is a size
+	 */
+
+	struct {
+		struct maple_node *node;
+		unsigned long max;
+		enum maple_type mt;
+	} dst[3];
 	struct {
 		struct maple_node *node;
 		unsigned long max;
@@ -178,7 +189,10 @@ struct maple_copy {
 
 	/*Avoid passing these around */
 	unsigned char s_count;
+	unsigned char d_count;
+	unsigned char split;
 	unsigned char data;
+	unsigned char height;
 };
 
 /**
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 9c701ee7412ca..e0929bf0cfa1a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -353,6 +353,13 @@ static inline struct maple_enode *mt_mk_node(const struct maple_node *node,
 			(type << MAPLE_ENODE_TYPE_SHIFT) | MAPLE_ENODE_NULL);
 }
 
+static inline void ma_init_slot(void __rcu **slot, const struct maple_node *mn,
+				const enum maple_type mt)
+{
+	/* WARNING: this is unsafe if the slot is exposed to readers. */
+	RCU_INIT_POINTER(*slot, (void *)mt_mk_node(mn, mt));
+}
+
 static inline void *mte_mk_root(const struct maple_enode *node)
 {
 	return (void *)((unsigned long)node | MAPLE_ROOT_NODE);
@@ -1320,6 +1327,21 @@ void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
 				       wr_mas->type);
 }
+
+static inline
+void wr_mas_ascend(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+
+	mas_ascend(mas);
+	wr_mas_setup(wr_mas, mas);
+	mas->end = ma_data_end(wr_mas->node, wr_mas->type, wr_mas->pivots,
+			       mas->max);
+	/* Careful, this may be wrong.. */
+	wr_mas->end_piv = wr_mas->r_max;
+	wr_mas->offset_end = mas->offset;
+}
+
 static inline unsigned long ma_leaf_max_gap(struct maple_node *mn,
 		enum maple_type mt, unsigned long min, unsigned long max,
 		unsigned long *pivots, void __rcu **slots)
@@ -2507,6 +2529,112 @@ static inline void mas_wmb_replace(struct ma_state *mas,
 	mas_update_gap(mas);
 }
 
+/*
+ * node_copy() - Copy from one node to another.
+ *
+ * @mas: The maple state
+ * @src: The source node
+ * @start: The offset into the src to start copying
+ * @size: The size to copy (non-zero)
+ * @s_max: The source node max
+ * @s_mt: The source maple node type
+ * @dst: The destination
+ * @d_start: The start location in the destination node
+ * @d_mt: The destination maple node type
+ */
+static inline
+unsigned long node_copy(struct ma_state *mas, struct maple_node *src,
+	unsigned char start, unsigned char size, unsigned long s_max,
+	enum maple_type s_mt, struct maple_node *dst, unsigned char d_start,
+	enum maple_type d_mt)
+{
+	unsigned long *s_pivots, *d_pivots;
+	void __rcu **s_slots, **d_slots;
+	unsigned long *s_gaps, *d_gaps;
+	unsigned long d_max;
+
+	d_slots = ma_slots(dst, d_mt) + d_start;
+	d_pivots = ma_pivots(dst, d_mt) + d_start;
+	s_slots = ma_slots(src, s_mt) + start;
+	s_pivots = ma_pivots(src, s_mt) + start;
+	memcpy(d_slots, s_slots, size * sizeof(void __rcu *));
+	if (!ma_is_leaf(d_mt) && s_mt == maple_copy) {
+		struct maple_enode *edst = mt_mk_node(dst, d_mt);
+
+
+		for (int i = 0; i < size; i++)
+			mas_set_parent(mas,
+				       mt_slot_locked(mas->tree, d_slots, i),
+				       edst, d_start + i);
+	}
+
+	d_gaps = ma_gaps(dst, d_mt);
+	if (d_gaps) {
+		s_gaps = ma_gaps(src, s_mt) + start;
+		d_gaps += d_start;
+		memcpy(d_gaps, s_gaps, size * sizeof(unsigned long));
+	}
+
+	if (start + size - 1 < mt_pivots[s_mt])
+		d_max = s_pivots[size - 1];
+	else
+		d_max = s_max;
+
+	if (d_start + size <= mt_pivots[d_mt])
+		d_pivots[size - 1] = d_max;
+
+	size--;
+	if (size)
+		memcpy(d_pivots, s_pivots, size * sizeof(unsigned long));
+
+	return d_max;
+}
+
+/*
+ * node_finalise() - Zero out unused area and populate metadata
+ * @node: The maple node
+ * @mt: The maple node type
+ * @end: The end of the used area
+ */
+static inline
+void node_finalise(struct maple_node *node, enum maple_type mt,
+		   unsigned char end)
+{
+	unsigned char max_end = mt_slots[mt];
+	unsigned char size;
+	unsigned long *gaps;
+	unsigned char gap_slot;
+
+	gaps = ma_gaps(node, mt);
+	if (end < max_end - 1) {
+		size = max_end - end;
+		memset(ma_slots(node, mt) + end, 0, size * sizeof(void *));
+
+		if (gaps)
+			memset(gaps + end, 0, size * sizeof(unsigned long));
+
+		if (--size)
+			memset(ma_pivots(node, mt) + end, 0, size * sizeof(unsigned long));
+	}
+
+	gap_slot = 0;
+	if (gaps && !ma_is_leaf(mt)) {
+		unsigned long max_gap;
+
+		max_gap = 0;
+		for (int i = 0; i <= end; i++)
+			if (gaps[i] > max_gap) {
+				gap_slot = i;
+				max_gap = gaps[i];
+			}
+	}
+
+	if (mt == maple_arange_64)
+		ma_set_meta(node, mt, gap_slot, end - 1);
+	else if (end <= max_end - 1)
+		ma_set_meta(node, mt, gap_slot, end - 1);
+}
+
 /*
  * mast_cp_to_nodes() - Copy data out to nodes.
  * @mast: The maple subtree state
@@ -2684,6 +2812,7 @@ static inline void cp_leaf_init(struct maple_copy *cp,
 	 * result in buggy code when a compiler reorders the instructions.
 	 */
 
+	cp->height = 1;
 	/* Create entries to insert including split entries to left and right */
 	if (l_wr_mas->r_min < mas->index) {
 		end++;
@@ -2726,6 +2855,100 @@ static inline void cp_data_calc(struct maple_copy *cp,
 	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
 }
 
+/*
+ * spanning_data() - Calculate the @cp data and populate @sib if insufficient
+ * @cp: The maple copy node
+ * @l_wr_mas: The left write maple state
+ * @r_wr_mas: The right write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ */
+static inline void spanning_data(struct maple_copy *cp,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
+		struct ma_state *sib)
+{
+	cp_data_calc(cp, l_wr_mas, r_wr_mas);
+	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
+	    (cp->data <= mt_min_slots[l_wr_mas->type])) {
+		spanning_sib(l_wr_mas, r_wr_mas, sib);
+		cp->data += sib->end + 1;
+	} else {
+		sib->end = 0;
+	}
+}
+
+/*
+ * dst_setup() - Set up one or more destinations for the new data.
+ * @cp: The maple copy node
+ * @mas: The maple state
+ * @mt: The source node type
+ */
+static inline
+void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt)
+{
+	/* Data is 1 indexed, every src has +1 added.  */
+
+	if (cp->data <= mt_slots[mt]) {
+		cp->split = cp->data - 1;
+		cp->d_count = 1;
+		goto node_setup;
+	}
+
+	cp->split = (cp->data - 1) / 2;
+	cp->d_count = 2;
+	if (cp->data < mt_slots[mt] * 2)
+		goto node_setup;
+
+	if (cp->data == mt_slots[mt] * 2) {
+		unsigned char off;
+		unsigned char s;
+
+		if (!ma_is_leaf(mt))
+			goto node_setup;
+
+		/*
+		 * Leaf nodes are a bit tricky because we cannot assume the data
+		 * can fit due to the NULL limitation on node ends.
+		 */
+		off = cp->split;
+		for (s = 0; s < cp->s_count; s++) {
+			unsigned char s_off;
+
+			s_off = cp->src[s].end - cp->src[s].start;
+			if (s_off >= off)
+				break;
+
+			s_off++;
+			off -= s_off;
+		}
+
+		off += cp->src[s].start;
+		if (ma_slots(cp->src[s].node, cp->src[s].mt)[off])
+			goto node_setup;
+
+		cp->split++;
+		if (cp->split < mt_slots[mt])
+			goto node_setup;
+
+		cp->split -= 2;
+		if (cp->data - 2 - cp->split < mt_slots[mt])
+			goto node_setup;
+
+	}
+
+	/* No other choice but to 3-way split the data */
+	cp->split = (cp->data + 2) / 3;
+	cp->d_count = 3;
+
+node_setup:
+	for (int i = 0; i < cp->d_count; i++) {
+		cp->dst[i].mt = mt;
+		cp->dst[i].node = ma_mnode_ptr(mas_pop_node(mas));
+	}
+}
+
 static inline void append_mas_cp(struct maple_copy *cp,
 	struct ma_state *mas, unsigned char start, unsigned char end)
 {
@@ -2813,38 +3036,153 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
 }
 
 static inline
-void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
+void cp_data_write(struct maple_copy *cp, struct ma_state *mas)
 {
-	struct maple_node *src;
-	unsigned char s;
+	struct maple_node *dst, *src;
+	unsigned char s, d;
+	unsigned char dst_offset;
+	unsigned char data_offset;
 	unsigned char src_end, s_offset;
-	unsigned long *b_pivots, *cp_pivots;
-	void __rcu **b_slots, **cp_slots;
-	enum maple_type s_mt;
+	unsigned char split;
+	unsigned long s_max, d_max;
+	unsigned char dst_size;
+	enum maple_type s_mt, d_mt;
+
+	data_offset = 0;
+	s = d = 0;
+	/* Readability help */
+	src = cp->src[s].node;
+	dst = cp->dst[d].node;
+	s_offset = cp->src[s].start;
+	src_end = cp->src[s].end;
+	split = cp->split;
+	s_max = cp->src[s].max;
+	s_mt = cp->src[s].mt;
+	d_mt = cp->dst[d].mt;
+	do {
+		dst_offset = 0;
+		d_max = 0;
+		dst = cp->dst[d].node;
+		d_mt = cp->dst[d].mt;
+		dst_size = split + 1;
 
-	b_node->b_end = 0;
+		while (dst_size) {
+			unsigned char size;
 
-	s = 0;
-	b_pivots = b_node->pivot;
-	b_slots = (void __rcu **)b_node->slot;
-	do {
-		unsigned char size;
-
-		src = cp->src[s].node;
-		s_mt = cp->src[s].mt;
-		s_offset = cp->src[s].start;
-		src_end = cp->src[s].end;
-		size = src_end - s_offset + 1;
-		cp_pivots = ma_pivots(src, s_mt) + s_offset;
-		cp_slots = ma_slots(src, s_mt) + s_offset;
-		memcpy(b_slots, cp_slots, size * sizeof(void __rcu *));
-		if (size > 1)
-			memcpy(b_pivots, cp_pivots, (size - 1) * sizeof(unsigned long));
-		b_pivots[size - 1] = cp->src[s].max;
-		b_pivots += size;
-		b_slots += size;
-		b_node->b_end += size;
-	} while (++s < cp->s_count);
+			if (src_end - s_offset + 1 < dst_size)
+				size = src_end - s_offset + 1;
+			else
+				size = dst_size;
+
+			d_max = node_copy(mas, src, s_offset, size, s_max, s_mt,
+					  dst, dst_offset, d_mt);
+
+			dst_offset += size;
+			s_offset += size;
+			if (s_offset > src_end) {
+				/* This source is exhausted */
+				s++;
+				if (s >= cp->s_count) {
+					cp->dst[d].max = d_max;
+					node_finalise(dst, d_mt, dst_offset);
+					return;
+				}
+				/* Reset local src */
+				src = cp->src[s].node;
+				s_offset = cp->src[s].start;
+				src_end = cp->src[s].end;
+				s_max = cp->src[s].max;
+				s_mt = cp->src[s].mt;
+			}
+
+			dst_size -= size;
+			data_offset += size;
+		}
+
+		split = cp->split;
+		cp->dst[d].max = d_max;
+		/* Handle null entries */
+		if (cp->dst[d].max != ULONG_MAX &&
+		    !ma_slots(dst, d_mt)[dst_offset - 1]) {
+			if (s_offset == cp->src[s].start) {
+				s--;
+				src = cp->src[s].node;
+				src_end = cp->src[s].end;
+				s_max = cp->src[s].max;
+				s_mt = cp->src[s].mt;
+				s_offset = src_end;
+			} else {
+				s_offset--;
+			}
+			/* Set dst max and clear pivot */
+			split++;
+			data_offset--;
+			dst_offset--;
+			cp->dst[d].max = ma_pivots(dst, d_mt)[dst_offset - 1];
+		}
+
+		node_finalise(dst, d_mt, dst_offset);
+		++d; /* Next destination */
+		if (d == cp->d_count - 1)
+			split = cp->data - data_offset;
+
+		if (d >= cp->d_count) {
+			WARN_ON(data_offset < cp->data);
+			return;
+		}
+
+	} while (data_offset <= cp->data);
+}
+
+/*
+ * cp_dst_to_slots() - Migrate the maple copy destination to the maple copy
+ * slots
+ * @cp: The maple copy node
+ * @min: The minimal value represented
+ * @max: The maximum value represented
+ * @mas: The maple state
+ */
+static inline void cp_dst_to_slots(struct maple_copy *cp, unsigned long min,
+		unsigned long max, struct ma_state *mas)
+{
+	unsigned char d;
+	unsigned long slot_min = min;
+
+	for (d = 0; d < cp->d_count; d++) {
+		struct maple_node *mn = cp->dst[d].node;
+		enum maple_type mt = cp->dst[d].mt;
+		unsigned long slot_max = cp->dst[d].max;
+
+		/*
+		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
+		 * documentation.  Since these are new nodes, there are no
+		 * read-side operations that can view them until they are
+		 * inserted into the tree after an rcu_assign_pointer() call.
+		 */
+		ma_init_slot(&cp->slot[d], mn, mt);
+		cp->pivot[d] = slot_max;
+		if (mt_is_alloc(mas->tree)) {
+			if (ma_is_leaf(mt)) {
+				cp->gap[d] = ma_leaf_max_gap(mn, mt, slot_min,
+					         slot_max, ma_pivots(mn, mt),
+					         ma_slots(mn, mt));
+			} else {
+				unsigned long *gaps = ma_gaps(mn, mt);
+
+				if (gaps) {
+					unsigned char gap_slot;
+
+					gap_slot = ma_meta_gap(mn);
+					cp->gap[d] = gaps[gap_slot];
+				}
+			}
+		}
+		slot_min = slot_max + 1;
+	}
+
+	cp->end = cp->d_count - 1;
+	cp->min = min;
+	cp->max = max;
 }
 
 static void mas_spanning_rebalance_loop(struct ma_state *mas,
@@ -3000,173 +3338,97 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
-
-static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
+/*
+ * spanning_ascend() - See if a spanning store operation has to keep walking up
+ * the tree
+ * @cp: The maple_copy node
+ * @l_wr_mas: The left maple write state
+ * @r_wr_mas: The right maple write state
+ * @sib: the maple state of the sibling
+ *
+ * Returns: True if another iteration is necessary.
+ */
+static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
+			    struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
+			    struct ma_state *sib)
 {
-
-	unsigned char split, mid_split;
-	unsigned char slot = 0;
-	unsigned char new_height = 0; /* used if node is a new root */
-	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
-	struct maple_enode *old_enode;
-
-	struct maple_subtree_state mast;
-	struct maple_big_node b_node;
-	struct maple_copy cp;
-	unsigned char height;
-	struct ma_state sib;
-	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(mast_l_mas, NULL, 0, 0);
-
-
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mast_l_mas = *mas;
-	cp.s_count = 0;
-	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	cp_data_calc(&cp, l_wr_mas, r_wr_mas);
-	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
-	    (cp.data <= mt_min_slots[l_wr_mas->type])) {
-		spanning_sib(l_wr_mas, r_wr_mas, &sib);
-		cp.data += sib.end + 1;
-	} else {
-		sib.end = 0;
-	}
-
-	multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
-	b_node.type = l_wr_mas->type;
-	cp_data_write(&cp, &b_node);
-	if (sib.end) {
-		if (sib.max < l_wr_mas->mas->min) {
-			*l_wr_mas->mas = sib;
-			wr_mas_setup(l_wr_mas, &sib);
-			mast_l_mas = sib;
-		} else {
-			*r_wr_mas->mas = sib;
-			wr_mas_setup(r_wr_mas, &sib);
-		}
+	if (sib->end) {
+		if (sib->max < l_wr_mas->mas->min)
+			*l_wr_mas->mas = *sib;
+		else
+			*r_wr_mas->mas = *sib;
 	}
 
-	mast.orig_l = &mast_l_mas;
-	mast.orig_r = r_wr_mas->mas;
-	/* Stop spanning searches by searching for just index. */
-	mast.orig_l->last = mas->index;
+	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
+	if (!cp->min && cp->max == ULONG_MAX) {
+		/* New root */
+		if (cp->d_count != 1) {
+			enum maple_type mt = maple_arange_64;
 
-	mast.bn = &b_node;
-	/* Combine l_mas and r_mas and split them up evenly again. */
+			if (!mt_is_alloc(mas->tree))
+				mt = maple_range_64;
 
-	/*
-	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
-	 * Rebalancing is done by use of the ``struct maple_topiary``.
-	 */
-	mast.l = &l_mas;
-	mast.m = &m_mas;
-	mast.r = &r_mas;
-	l_mas.status = r_mas.status = m_mas.status = ma_none;
-	height = mas_mt_height(mas) + 1;
-
-	/*
-	 * Each level of the tree is examined and balanced, pushing data to the left or
-	 * right, or rebalancing against left or right nodes is employed to avoid
-	 * rippling up the tree to limit the amount of churn.  Once a new sub-section of
-	 * the tree is created, there may be a mix of new and old nodes.  The old nodes
-	 * will have the incorrect parent pointers and currently be in two trees: the
-	 * original tree and the partially new tree.  To remedy the parent pointers in
-	 * the old tree, the new data is swapped into the active tree and a walk down
-	 * the tree is performed and the parent pointers are updated.
-	 * See mas_topiary_replace() for more information.
-	 */
-	while (height--) {
-		mast.bn->b_end--;
-		mast.bn->type = mte_node_type(mast.orig_l->node);
-		split = mas_mab_to_node(mas, mast.bn, &left, &right, &middle,
-					&mid_split);
-		mast_set_split_parents(&mast, left, middle, right, split,
-				       mid_split);
-		mast_cp_to_nodes(&mast, left, middle, right, split, mid_split);
-		new_height++;
-
-		/*
-		 * Copy data from next level in the tree to mast.bn from next
-		 * iteration
-		 */
-		memset(mast.bn, 0, sizeof(struct maple_big_node));
-		mast.bn->type = mte_node_type(left);
-
-		/* Root already stored in l->node. */
-		if (mas_is_root_limits(mast.l))
-			goto new_root;
-
-		mast_ascend(&mast);
-		mast_combine_cp_left(&mast);
-		mast.l->offset = mast.bn->b_end;
-		mab_set_b_end(mast.bn, mast.l, left);
-		mab_set_b_end(mast.bn, mast.m, middle);
-		mab_set_b_end(mast.bn, mast.r, right);
-
-		/* Copy anything necessary out of the right node. */
-		mast_combine_cp_right(&mast);
-		mast.orig_l->last = mast.orig_l->max;
-
-		if (mast_sufficient(&mast)) {
-			if (mast_overflow(&mast))
-				continue;
-
-			if (mast.orig_l->node == mast.orig_r->node) {
-			       /*
-				* The data in b_node should be stored in one
-				* node and in the tree
-				*/
-				slot = mast.l->offset;
-				break;
-			}
-
-			continue;
+			cp->data = cp->d_count;
+			cp->s_count = 0;
+			dst_setup(cp, mas, mt);
+			init_cp_src(cp);
+			node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
+				  cp->dst[0].node, 0, mt);
+			node_finalise(cp->dst[0].node, mt, cp->end + 1);
+			/*
+			 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
+			 * documentation.  Since this is a new root, there are no
+			 * read-side operations that can view it until it is insert into
+			 * the tree after an rcu_assign_pointer() call.
+			 */
+			ma_init_slot(&cp->slot[0], cp->dst[0].node, mt);
+			cp->height++;
 		}
-
-		/* May be a new root stored in mast.bn */
-		if (mas_is_root_limits(mast.orig_l))
-			break;
-
-		mast_spanning_rebalance(&mast);
-
-		/* rebalancing from other nodes may require another loop. */
-		if (!height)
-			height++;
+		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
+				mt_slot_locked(mas->tree, cp->slot, 0)));
+		cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
+		mas->min = 0;
+		mas->max = ULONG_MAX;
+		mas->depth = 0;
+		mas->node = mas_root_locked(mas);
+		return false;
 	}
 
-	mast.l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
-				mte_node_type(mast.orig_l->node));
+	/* Converged and has a single destination */
+	if ((cp->d_count == 1) &&
+	    (l_wr_mas->mas->node == r_wr_mas->mas->node)) {
+		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+		return false;
+	}
 
-	mab_mas_cp(mast.bn, 0, mt_slots[mast.bn->type] - 1, mast.l, true);
-	new_height++;
-	mas_set_parent(mas, left, mast.l->node, slot);
-	if (middle)
-		mas_set_parent(mas, middle, mast.l->node, ++slot);
+	cp->height++;
+	wr_mas_ascend(l_wr_mas);
+	wr_mas_ascend(r_wr_mas);
+	return true;
+}
 
-	if (right)
-		mas_set_parent(mas, right, mast.l->node, ++slot);
+static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
+{
 
-	if (mas_is_root_limits(mast.l)) {
-new_root:
-		mas_mn(mast.l)->parent = ma_parent_ptr(mas_tree_parent(mas));
-		while (!mte_is_root(mast.orig_l->node))
-			mast_ascend(&mast);
-	} else {
-		mas_mn(mast.l)->parent = mas_mn(mast.orig_l)->parent;
-	}
+	struct maple_enode *old_enode;
+	struct maple_copy cp;
+	struct ma_state sib;
 
-	old_enode = mast.orig_l->node;
-	mas->depth = mast.l->depth;
-	mas->node = mast.l->node;
-	mas->min = mast.l->min;
-	mas->max = mast.l->max;
-	mas->offset = mast.l->offset;
-	mas_wmb_replace(mas, old_enode, new_height);
+	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
+	do {
+		spanning_data(&cp, l_wr_mas, r_wr_mas, &sib);
+		multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
+		dst_setup(&cp, mas, l_wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (spanning_ascend(&cp, mas, l_wr_mas, r_wr_mas, &sib));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
 	mtree_range_walk(mas);
 }
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 85fb5616c133c..dfd7099f0d8ef 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35508,7 +35508,7 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	/* Store a value across a node boundary that causes a 3 way split */
 
 	if (MAPLE_32BIT)
-		i = 49590; /* 0xc1b6 */
+		i = 49430; /* 0xc116 */
 	else
 		i = 49670; /* 0xC206 */
 
-- 
2.47.3


