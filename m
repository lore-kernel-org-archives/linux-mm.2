Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF11CC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 09:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE976B009A; Tue,  5 Aug 2025 05:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F836B009B; Tue,  5 Aug 2025 05:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067B06B009C; Tue,  5 Aug 2025 05:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E921D6B009A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:31:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6654913535B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:31:12 +0000 (UTC)
X-FDA: 83742185184.08.879849F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id DFE2F40003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:31:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mMCNHDNs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gjgKsWNT;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754386269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGUyTkWCy80gkgCcXneRaOqeBnh4yKufHAdBBLiaDkc=;
	b=n0k77xCz3RwdmV0w7Qo/jO1cqN2u1z0u/ectzDTyKQyO5UaiEs8Oh9MK08Cn8W32hVqJvQ
	r+MobwWSFS7gGNHKbDJquMy5w1DSIYaWgJ9BGGhRuyk29lHVIlvhpX9Gh8ruFJj63OO0Zy
	uCl4c/6znwpymrrgwduV9CCpVf5PmOE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mMCNHDNs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gjgKsWNT;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754386269; a=rsa-sha256;
	cv=pass;
	b=jdJ1FYqd2X8V7DCLhMd6PZ0WOyL+0sUcP/XivxyciZ/DMA52xd1uboFeg5nO9gl6FB1hTU
	ZIgan/oxdynNjOCnKda9BMV+dJezTjrwFB36UDM7Kgi4uOiPaynMcVVvZQ6oBT8POHru9Q
	d95FRywZJiOTFAXVsf4OhUuJR5mHE2U=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5759GxG1003414;
	Tue, 5 Aug 2025 09:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aGUyTkWCy80gkgCcXn
	eRaOqeBnh4yKufHAdBBLiaDkc=; b=mMCNHDNsa/iYBJ6AA2VyvDuQx1eG5dCoYC
	y+j6F+NtQltULyBVHiTVp3MnkqmTPmGC6ApRkaJlMlPNMfgf7z1N0WRHtrmJKmmy
	rQkppu6Dy8BC5GuI0t1jdP+BTku+BK7ZNrsGKGmew/jj8hEml9nBOL/S0/rLh6ii
	VOWYzkUB7Dgs4Pu5b/6TyQHabpAq0cjNuPWXqUk2YaSqRa831ydSndNi3+g3fX7h
	9xP9L/lboW6f9R4z1SJa5SwRwkHE8oKl0aDaNAXtVD59qpm0BXgEorE7/cYyubjj
	dCNlroeRnq3KAS2DNH2ofev7S/hWNaZiuccf1XlVbPqCRahP2iQg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489aqfmd4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 09:31:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5757YcQK014911;
	Tue, 5 Aug 2025 09:30:49 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48a7q1qxsx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 09:30:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQaSxuElEYI0miWSIMZGV3U66HtwjTqKbS7i9vRukWN3N1P6ptS177RrRTMKZbd33PV+ZH36hHvp4HzUQFppzUml+YFDRuIKkKDBz8g0VZuTTpLqPFFOF0dAzH4dL+ySP0qHPmKB+lAuv6gvzq/sq1jxN++K5Az7BPOKnKIJFnHa5uJhK304WinKp8LBOeNzu656gX2Fmf6pyPFhRI3nCO1HLCl0keEx4ujuDn+Ztzj+1EcetVYpa1ETtRmB4ffrvJpkjC+gZy7NPZzbzrfbFK9ilAal0AxjeNs3ZfT/kNv1LMsf7HUbQ2PB2kKbFrZY/1qPIGqa1EcvqbUAFufLcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGUyTkWCy80gkgCcXneRaOqeBnh4yKufHAdBBLiaDkc=;
 b=TOYbZZOLgo8rjs60B3EelZnHL1AR2WiWTvo1LwjbrfmphXOP5jKf6BlLbhKeUpFVEII+XTMvpSjx5aU/FsLbSF9Xgst35mJ09ysRXm6V8I3A7+6M89Ktzb9n9kU03QVPcUaFhF/wYUFYJpHMNIdsYnNccggjsJKxEdCqSzZ67uDgXAskPIK7iJIe4nSwBBBq6IbPCyKuL7HcuEaKUfgv2Lk6TIciZOWnabvTVIxltpC9yE9FQrcukD4TDTssQ7q7Ca8YokLZ8xPtl++MU71f+w5WIpcfhmN1xjn8emv9XsXr1zqPoFHlzbQ5XEgMxAgGOcjtehS1rGiymdwskuO7iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGUyTkWCy80gkgCcXneRaOqeBnh4yKufHAdBBLiaDkc=;
 b=gjgKsWNTw8Krg/IuV9BnKh3NwEZTMF37jLQD6jGMoXutLV3teKlxY5EqtK/9bnF5FD0SY3LZx3s1ZFqD2rkjgwwTxFc2KbZrTWgn+euHTBkywrIjVQCRS5TFSMUVvu+tSn2CDabVt7xPU2k9lzTB20O91jhIj8Q0v6b1mDxNA0s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 09:30:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 09:30:46 +0000
Date: Tue, 5 Aug 2025 10:30:43 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Liam.Howlett@oracle.com,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Feng Tang <feng.79.tang@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Adrian Huang <ahuang12@lenovo.com>
Subject: Re: [PATCH 1/1] mm: Correct misleading comment on mmap_lock field in
 mm_struct
Message-ID: <437e07b4-e973-4600-897c-96f67f8ec8a4@lucifer.local>
References: <20250805084726.2054-1-ahuang12@lenovo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805084726.2054-1-ahuang12@lenovo.com>
X-ClientProxiedBy: FR2P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 0476b187-1375-401d-002d-08ddd402c1f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I+uMw6WpejgopahRdVtF4CQzphbDgjykRDEyJ+wJoX8rQvKwvDCpM2MQ6Ssh?=
 =?us-ascii?Q?GfS18Vt9irvGTLw8qA8Nzdlua7Z2rG/yWhgxzyC8XmouS4yvkKgdiEJIPGJX?=
 =?us-ascii?Q?vlbDuoxjAzOngK+9N69bd3p6TtrSXMaq1xrBQEFwYW4Uav9avKzbaQrA8og5?=
 =?us-ascii?Q?cpprkCh/32DJ9o2ASk5BlTMFUx4iQVz8sLiUOjaqFL1VuWLxEhnlkPDRhUNE?=
 =?us-ascii?Q?Lqy/dRnwIUuNbF7Foc2LSj76XFAIkMHVxJhSvVgcDPytBUm1DHWQYOGNIrNY?=
 =?us-ascii?Q?LUogR7jxcqjJd51byq2JrVPc2W4vAMz0+N/5WFgIry6hANgVgZtkJDmBevm3?=
 =?us-ascii?Q?P73kxF0JIV9LzW0DO7Cfac6XF++WLNwp/WEwHMPk5/gFpvDRex/RCQbRpN3I?=
 =?us-ascii?Q?EgeDPA7Y1/28D7ghMVUR1ojglcfaCgB1FrQwLGFjVn7+c0Eu3uBOQpB06vYk?=
 =?us-ascii?Q?/fqh1k8id2lcr7gfBtS4Gxms36eSWIqJqXc4mk5BRrnQ4YhXxk/hJpspFFCR?=
 =?us-ascii?Q?tJUuNZfoxSLy0irkvY+KbofVTTuzg2bDxeyR9Uml8VSUJh1NgsLUZ5sGTHz7?=
 =?us-ascii?Q?L0VfJ9HoVphiF1XIU9A8dPuLg7B5VENvdIFY3DAR9BHFaOXyYErbWfhedSLE?=
 =?us-ascii?Q?oSSC145vCE6ugmw7QZI99xKIQdjL+NMgctL/adAsmgHQK3dVmdnAZnF/oJ7k?=
 =?us-ascii?Q?Da2pS4sqegB0KDSD1Np9AB/5X1asfm8PVVt6TbhNOGerkYPxj3etRalWMj3K?=
 =?us-ascii?Q?ZM661tDfa/X0ypliPgJ13SDiX1LDXrS0gbOSQnliqp75XoAb1TEql7Y6uuAw?=
 =?us-ascii?Q?U8TsArsySkYul/HP9gdR/H8lp62d9B7x3SpI5HJCc3EDOw/70Che9mvncMcB?=
 =?us-ascii?Q?HuvBrNuWCLKR+dwHD1z8Lsx04i49AdOd+uZaGaVxmQ5UKju1jxf/eKbCPyt2?=
 =?us-ascii?Q?4ZfLlxY21YSodg/jHQ20icnaFNLmROcXzlC2JKS7n7O+4STcVuVtcfddylQu?=
 =?us-ascii?Q?qoRN/xRiDRtOvWts9CZOPn8YP4A7XFwVXIMimRYI2IzZeW+GvbFp6jmwSp7t?=
 =?us-ascii?Q?Inx+rLtVATZMBhxptySYpwUKtw4yZ0cGAVKozR441N6qQrkvXY3Kn0sLuv/K?=
 =?us-ascii?Q?G1BunxMbzMsEwnxmcVEFgrzpRCZR1vX9m7EWwMf5wfrz61qomB/uK0ogau9Y?=
 =?us-ascii?Q?FhQzv1aoPS3cun4glLkx0gDorVFMRitb71QooaxUw1H4SNj0rNxzpN/HAlN2?=
 =?us-ascii?Q?07gY4zXgBZaGyaB8credA3773T0NyXod8jgzwq79ksHmN4HBr6r+V1PRaObJ?=
 =?us-ascii?Q?ekZ+wCtN4WvvDvxBGyKvGXUkS5+PF0jiYsMctkyY28r/skiSZOBcTFwgK+ZL?=
 =?us-ascii?Q?S6bkRlCcn3zYOqNFla2YwY4YcBUp8xSCydTwOstAxWS5Z16iASIFhMq9CIBg?=
 =?us-ascii?Q?BiORKKy14K4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+nxNYPNlmSCTHGq1zVTsWW335DbDCetCTixyzcPDRXoUs4HhqsnBzK33k57f?=
 =?us-ascii?Q?SD7hr1K3d+WBNXkEWq/YsnM1e3ohfA3jwYh5bW7/KD7Ktk9MruHfcRO0yIo7?=
 =?us-ascii?Q?VKXytVHE3vkxNbIrSIEbZFoZfxQk2yO9hdioyy7V/MuiPKyOsoRm2msWiBT4?=
 =?us-ascii?Q?5MGbHuKrpSw2jhboOG1a0wRNufbAGDdDvizgz/8W2K20mPjECSJO8lwck4yc?=
 =?us-ascii?Q?VoH6k8hpqhsGGpid4xFCeRCX4Ee2xy7X30IV5mQMLq+TOjy6pwnDXxaAfnTd?=
 =?us-ascii?Q?w76+7iBVdJqlMklMBZM9MI2+y2PV2jAowUTgSeeuic5/K6wHyr9svqGXoQ+6?=
 =?us-ascii?Q?QnrN0GPStfcmpblsdEANSEMIPjJRihvssI9dsJFqq5/AriBkO7TP9GheVrO7?=
 =?us-ascii?Q?X7hSlVxVEWBskmYVIZJCXzFyontMbLdGJAnO7sLxWL0waa6SNmOdiiag/3Mg?=
 =?us-ascii?Q?qcU+88saWWVvEEeWjR55CtMTvZDdX7UyUv8n+GVL+Xq6XIFqOVm0xjnzQZYD?=
 =?us-ascii?Q?0Zu/HQzhi+W96VHQ0d0GpNh6e6kIqjap4XIKEKGw+d7LNiASKrRdc3+vRq/Z?=
 =?us-ascii?Q?UFzGMDD7S7aMBdstZQu2yKisE40BkzLZEnU+eDmEfvKoH03HPZfln8T5cKis?=
 =?us-ascii?Q?ml/JqdT7ftMV+ZCbseCIP88uTQmfyeAJxGRiw1vPthN+BHmg7xV9zP046cix?=
 =?us-ascii?Q?3UwC5kKw4GJZWMIhG9vqV+llntcdHbWJkvCq8OPTgZJoo4ZC1QHQX4cDOX4P?=
 =?us-ascii?Q?Qtork5tAQvGrxJ/GMdV9FskJnFZAV23QHzizZrZa2e2yxPw56iRxJ4W7y6cX?=
 =?us-ascii?Q?iJ9vV+oz418PQ4OyDUeri8GBdltVFg9oj9woYRi0fkwqLCeBxNyhHvICZ0KX?=
 =?us-ascii?Q?mieGAVlv1QHb4AcP2fwp6l8P6tQjMHkPHQshmOGLKbNusgltGlXX+Qbh5Zk4?=
 =?us-ascii?Q?q2W2WzIdXOMnbt8ZUa46Wf/a+bEawdh7zvwyCvha1KNIZobjI5iq3hA1ZtNn?=
 =?us-ascii?Q?kY8jun4rAkdg3ZgkH+tbqV38EIBIwObdcTnxwslb9GQXQq+8iQMS+IBCQKKe?=
 =?us-ascii?Q?J0aqr5MCTfB0ZgAcG1YWWQ/FkeKIEe+79J5FlQxkBI44Ng6CXudiaQeQ+i64?=
 =?us-ascii?Q?iuJ6sgftyBloXsOLuSx/DreEDWSIHxnyzNFKj6x+GFE27ks3skyYuFPfJBo8?=
 =?us-ascii?Q?q4QZXY+YXncjphnZ6b2LCa6rV25SA6nsEgORORHB0+Z9k6HtYjj3lQ5BU7Hv?=
 =?us-ascii?Q?Pv0BbTpD9cf0z+ke+4YLUuEDpFjAmoTEK3dWgbgNJ7Kez2b1ftnwamj13Kgn?=
 =?us-ascii?Q?W7xAF52lXLl+5dc/vDTQ7hcKo9sJKfraHRszwFDe5g5RipdSNw+Xj9wGlMp4?=
 =?us-ascii?Q?iBHNs+WN5i7cEcTgkg4JO6wcEKZZ6CDNYMp9BLWsiGa6jDnmA9SaKp6wSz/1?=
 =?us-ascii?Q?Ln7RB7DWcjycwA9EfTpeQ+K93RIMDyVLR0pl0wyYONsTY3ZayiCkqWnIOBCK?=
 =?us-ascii?Q?qXJnDxUFfFHOZZh0isYgfSNfzMO939tbzA64u1Cpa8cSRExdlueGjpf9FieP?=
 =?us-ascii?Q?aU3TTr6rZCiCYdpp4kQDfdndvb1wPBff+qJxnTPhzLU1kmQtcv0zQWi4d3x/?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mT6T5DqQUtDNxgrxfzE61zuj4fiBHIw6xnNPywAoYr06OsN8fImZjs28Hb1uek1Hk7XckehtyPglyehIa/9rIlq1N5iJsqYMhCGLiixs6hVuXxgzMFicrACIcCc6Jem1hr2d7mO0jANBneati1G7jQykuSTxCPwx78gp/h3xuUSGcmXz5VsELHXjXvu6SfPClvm+heTeINfEZJo+qxn0cfK6zNA7kxRB+1Ho0Ilz6pNxwm2Fptk6IqRAhd7tjLxEDbdUFo/uKlXffRTtIsDW7/PhkCUViMOdtmxDadaEqIWKCT1Gd51d/8DAtWBaqK/qXcJRN6Y2UJ/47vyDrgdB9e9muAg9QdjpWLfVxlV5A5rRo/RSk62O4dSTUhpLdp2TRT+pv002TIV00BbafeJfUHEzneNQf6v9x1HQBQYyjg9TcAc3+wHlmxbG/kg7VY59duhT/QtT+oqxoILJ3Zs6aS5xVxu9dGkgvl6LFrzi3sHSyHJqZXYQ9lJfw8SamlAiEDBGZ1q3GzkzZ2UtOmYOwlsy9r89+QHNuYE3/H3qgWZ7StNl0RXckdzdL6eoVTGO62nvSWwYRuhuglwHQJN45SOjaVSHKMmsw/saK3g5dgQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0476b187-1375-401d-002d-08ddd402c1f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 09:30:46.6395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDhuENZwuISm+qAm51zf002E+Xb0dqA8a2VGMdW2iaTIb+4B2lek8isSUdSQEuHm5s5IxZ1iVSgSmazKC9cLf6YrIJhTAZDf7PLoF8PiqbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_02,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2508050068
X-Authority-Analysis: v=2.4 cv=TrvmhCXh c=1 sm=1 tr=0 ts=6891cf54 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=8k6WQxmsAAAA:8 a=J0XnSfopwLp_YGKdOnUA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12066
X-Proofpoint-GUID: kILfZGRUrBmkz8mE-Bczkba_IbzJrbwK
X-Proofpoint-ORIG-GUID: kILfZGRUrBmkz8mE-Bczkba_IbzJrbwK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA2OSBTYWx0ZWRfX6ZSota6Czumd
 Bo4QLjhHzuEOqJcXKNwX5/SWOZWiIf71fI7ulL+dx9fp8i/JSdT2D3K1qsL/fB4g4qiPt21ibee
 S4qw5yZYq0KnBF/o8m8PMnJ7qczxtgNzM2M8WpeCGMhQWJXhshguhMj+H8p4kcxqDq77MZK5HhX
 d5QoK/6S/BFmMZ2k2kZgqMPvW+zA6I6PJxxC8Da1QN6gzgJ6MnU5sYuEhc5OCBfBpLBp9rl6cEP
 N85oBONWKd9vTBVP9YIkID72DgNzxvbmeBwWZIWcXcEwIaKg8+zTauMe7zQ/Xe1zeq05ommwD+n
 GlF+edeORF51mCevuzmk6jYF+WwVKQwLlHJ6xBVXoIR9TYkxmG7SJz1ZbVWxuz9ENKmph8ypMSr
 rAT4YteksS+KMHGpCQNHIgCQ/+sBXTZrjV/IKue7+KQ/Ia3WD74yaA0XEzvCfqPiJKyT6mjh
X-Rspam-User: 
X-Rspamd-Queue-Id: DFE2F40003
X-Rspamd-Server: rspam06
X-Stat-Signature: 64wdpx5nb4b7z7xosx4k4oeghykf5ham
X-HE-Tag: 1754386268-541387
X-HE-Meta: U2FsdGVkX19eQGlgHVoSyCclL7KVkeCttD3p5Mc8Bq+mh36RJdsilRX1/sHZ3luMczHVAQMZnXo0CgROoC3JOLoYsQlZpE3+4VDUHrg4cUgd68o/U63T/VUyMv1sC0+/gI8f7qYTLqPG1ZtAUnAMyPwjdlS0qOSr6QBjiiGAnYUdrdDLLzyXLbiVGfWIDedhcoxRRaHyZGKZHHmCk6AUs5g6Xzg/rb4OH8v/LL2FP21jETFUbW/XPRJWqM1y4vTnZMc5cYxdFRJBmllBLDhxIVrSebd3lzqJBY5E71bM3GikuYuK7R1hfQLqKlefeg/acX83tdPkLuI5tQf+1qxrvsfPoz60rxNEBtIf1P6+DrRvvK3oNZpIX+wMuFQxO1LPYzCi7cLwbsfK4tu4ZBGoBxbaNJTB6kE6HaPK91EQ0mE17iu1TJJPXXMS5qg6WGV8Ccj758l5rLw9g1RhoCQ2j1sZdcCZW1SErbFSjtTqcOZtH67LfRmlTechCbojBBEUvU90PJ7FqL51r5MXHsrgblj3GvhuZFP4Fm3JvfYnzzrGHI7RDnccTKnizaPOG0jUqBBPR6TFUO7vP3xCYSmX+1fWTKI4NnlLfVNjkk34rAz3RR4XKpOa3PRetpk52PwnzKNej1aC1cDxzPLk/UKafrJMdA4g0M0bun2MH3nyDJrwnw/MgViat8chNCR8PZCM2kUnXRl+7a8OjhIdXFvjWlYMfzbmb/bQPEeXnnCYqim2AhTPBFBzayUz0UfbZx83qPOLx3SLHGsP6mCo8Eih+cCFIY5lwWi/7Diq3UPYAaP2RDO2GqHMu1lh9BmngiktFJxr/Rhkn7Mwmn4km5aEUUKZJcNTPDWnqARJlHQ5OWbvY0WpAAQlAuEm5ZDx7hPQb9WU9A/dIdmjdmfhj5d90FVWYoKawxjG0s7WAXs1LUYsk+6Nm0x71aUqc8lXxIaEJh/KjvuDXeMZlU2IAEE
 xb/GkA//
 tYwIsjTGFrS6av6FSy4MVjyMjNNqmX/Ox4wCW0kOgv4DFCAm5ZlbtvW5y+2ek2Vlz6nl/KB2ybNRC3nFI7J3YfR+cieZxRaQgsfCytuB+6swED6FOq4hyrm/tfCHh/bylSgAq5bfJdNNhco87ULxEzXBAnKMU0YXYBuI7BRniUVfTlG3tXOjfT8cQAxQLVUAQmeDInwAgLAmnw0dMm2GKFOfDxTqIkT9ocIP+tgF11HXbyTRbLFJ/f/jcJEQkPhCpslGmEUQY94pc1yBS58ugRhnMfmjtd3I9kZpK7J+0JmUoccRycYfkgaS9WAghg0A6C0zN98UKgN+Ic0rXxIvkbgrZ/Op4swrTGAQKz2vlQBPqO9c2wDwzKm1rU2SyYvbvGs7FNuEMxuDKR8WewkxElMxDyVO6M9PqdGSkySnB+L3uKYIqScwWPLNiIrbZ2wyScC8n9aKjVuzu/jpSp7bryefVi6v8HbKOmIAJJTOK2dgHiEqRBiFJ7dXPBZe16KSjnQkDdPCJYHxF+CHv3fTdkpGSfwJ9YCZtG5y6QSMKFJL+OI5zok83c1BLT3KrSPlDaofeE9hXHyGDE+nSpu6MwERl7gTPMW+eL16sLKbJ0MGh3lWOgx1j2L0wFvukEh03qR+bHj0s8o0r/x/BSscGWwjB4tdkjrFhBCLfPwelBOh9tchsrsslXDNWPeKEf1NkcGNeeK/3FDlvjr+9IXSRDO5O3cJ8RJD8kea8krmFSFjqt41f0OxRuP1i9JqDXUTTisQeWek2V9hLGGJRVDij2R+MHF7D+ofTjMWutDfDfa/rX3Qqkfpp8kL/q7KoQ+lcrJnQLtz9sdTi2+vduIpKYHg5MtHf3mn2SKzzvKleMUp/PBCsIAL80KHgLeA16a/CY5+W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 04:47:26PM +0800, Adrian Huang wrote:
> From: Adrian Huang <ahuang12@lenovo.com>
>
> The comment previously described the offset of mmap_lock as 0x120 (hex),
> which is misleading. The correct value is 120 (decimal), and using '0x120'
> could confuse readers trying to understand why the count and owner fields
> reside in separate cachelines.

This isn't the case on my system, pahole puts it at 184, if you subtract the
first field + cache line padding at the start of the structure, then 120 from
there... I guess?

I think it'd be better to say 'offset 56 bytes past the start of the cache
line' rather than to give specific values.

E.g.:

/*
 * Typically the current mmap_lock's offset is 56 bytes from the last cache
   line boundary, which is very optimal... etc. etc.
 ...
 */

>
> This change also removes an unnecessary space for improved formatting.
>
> Fixes: 2e3025434a6b ("mm: relocate 'write_protect_seq' in struct mm_struct")

There's no need for fixes for a comment change.

> Signed-off-by: Adrian Huang <ahuang12@lenovo.com>

Thanks! You're sending from a gmail account though, please make the email you
send from and signed off the same, or otherwise we don't know whether this is
the real you :)

> ---
>  include/linux/mm_types.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 1ec273b06691..ec90bbf22e2b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1027,9 +1027,9 @@ struct mm_struct {
>  					     */
>  		/*
>  		 * With some kernel config, the current mmap_lock's offset
> -		 * inside 'mm_struct' is at 0x120, which is very optimal, as
> +		 * inside 'mm_struct' is at 120, which is very optimal, as
>  		 * its two hot fields 'count' and 'owner' sit in 2 different
> -		 * cachelines,  and when mmap_lock is highly contended, both
> +		 * cachelines, and when mmap_lock is highly contended, both
>  		 * of the 2 fields will be accessed frequently, current layout
>  		 * will help to reduce cache bouncing.
>  		 *
> --
> 2.34.1
>

Cheers, Lorenzo

