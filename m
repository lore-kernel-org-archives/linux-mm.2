Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF6E8D2ECEC
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 21:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D866B02CA; Mon, 19 Jan 2026 16:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944876B02CD; Mon, 19 Jan 2026 16:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4626B02CB; Mon, 19 Jan 2026 16:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4E76B02C9
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:00:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AA511AEA3A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:00:03 +0000 (UTC)
X-FDA: 84349930686.11.C1B00A2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3223A1A0009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:00:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rp4HzUOL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m+s44T8v;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768856400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTZV6K3c8wf+M73y0qa1QhrpLot4S5fiRZNrZI968Rs=;
	b=hfQsVELktyukOPjm/OPHiyTgdK4BJikLulAbbIVgS6YtytE6/fhgxfN2yMsN8Y0L5tPwEy
	rLWxSGTxvUUJQFdvp5PFlWAj4iryL29mKAnjMKMA0XBliNu+b0O4SHtbKw4LoUi6VK5Xjb
	fV+0uu+ePGdH+LqGfwujb5fWjmATC34=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768856400; a=rsa-sha256;
	cv=pass;
	b=uXLa+nU77YTlN5z7kdoqEnzsdgD+1eTT9N9vOpxRYwI/skqvi456B4MF7CSe1T8aCZguVc
	pWbXheqQi+K/jmfUZzC4SkZ4prRg7ft898nt19hT8ObanMVLPCuhDGfWIBh3wxiuiWo0Lf
	aMojgwPV+sX7LjAmNKFNraGS40UL6Os=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rp4HzUOL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m+s44T8v;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60JBDQ7W1341821;
	Mon, 19 Jan 2026 20:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hTZV6K3c8wf+M73y0qa1QhrpLot4S5fiRZNrZI968Rs=; b=
	Rp4HzUOLr64R13vJTPx8SkRTeFmh4NI0E5YHH1jgXaPha64WcmWBJUMtiG+9SNwI
	3qxpz+gDLzFKbJMlMi47EmP3CDR3EH+V4xCIuZyJilUevYPlU8WXvOI0OxInTn0Q
	wU5Xkt6Fxb+iYIz7QH1T5W840V9jz+2w+MxLazo3FPCOeB2IMRM386PuQWIWyidU
	ylNIWGs6KZP7C5IIWiQp3JJI1QvK39Vi9ZSRLHisFtRn8K8+OTUX+OyJ50gaV9Qm
	lqW4LdPxooNMQUyjjP6jzG/CL9WTta1m3fwQlc0Rxr2mkchtQY878fOeJYAEoKlq
	z8MSMekXR2sdQ/mDjQlh5Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br170aswe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 20:59:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60JKV8wM022439;
	Mon, 19 Jan 2026 20:59:47 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010041.outbound.protection.outlook.com [52.101.85.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vchbvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 20:59:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+JaefWyHw/XY5nhCMyGt78nkFDyQQ9x2Sy8J1vteZ378di1HinkHxQ/0uBS9hfoo3sCxeMpZrrnsNWNdZKTOk3TTakPnF2J4UdmsdVyDt+Hnrvc5pQyBosnxzHr1qivUeqXmf63Ompgend4MwyJebXeWyazxBesjisgjjNBpGe46SdiGDTpVII+eCNsrdefE1E4uvPsJwLrjhKFsLHdsozDxhxhvMB9r+J3zCY2FRzFYev3C4vCiBecfdOKygtJPfCuhcY8EOCC4t0cVv+jt/C/EGfzPdpqIw80qBr9+T7gpKzQpbzolYUisbh2SFORqFOz+GytNq091BBGyMEj2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTZV6K3c8wf+M73y0qa1QhrpLot4S5fiRZNrZI968Rs=;
 b=oxvY48aTRxuJ8O/ow7exOYRnh+O0IpsTM6cJc28O5bcJWEAwLxV1QDzbezA3iQSkiMCIOHfWinGZvEuBqKnYJlaqrjizfgrnRsyIiOKSSLVRKe4aDlPF2e0Ox/4jChl+X7Ap/CRDuynn3xZ+APncfalM6gPNSOc1Caw+Wjyl7qlJ2f7ru1H7STr3m4JGkKdSqio3/gcZvmdhtpp3ayxWU42Fz4FaLuAn4RmUXlBLZEL45VwfMO4mYgTUWWp4oAAtJ4KrdWc5xch9gIETfXmIuJXTMqH0wk5qoTigExcYjJOke9dZh51VurGhFCXIHCheA3Z4dZISsmk/Y9Z2l2NYkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTZV6K3c8wf+M73y0qa1QhrpLot4S5fiRZNrZI968Rs=;
 b=m+s44T8veH7xlLnMvDzyxUyk3D4P1MOnI8PZmJ3U+CkTBs9wpIVg4S4+Wahhx6Jzc6gKAhiVxfkW1Yjq6ttkN2Mp1sOeMqFTdUYA2OYGqFV1vRAFFM/N1qmmvQOyvNxp0LUrO1zk2tSqzZacLCt+Zn9Y3zjvFU0RLQR5Egxplf4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB997619.namprd10.prod.outlook.com (2603:10b6:510:380::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 20:59:44 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 19 Jan 2026
 20:59:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2 2/2] mm: add vma_assert_stabilised()
Date: Mon, 19 Jan 2026 20:59:40 +0000
Message-ID: <45f8b4cd77be75b095b474570487650ae728be0f.1768855783.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768855783.git.lorenzo.stoakes@oracle.com>
References: <cover.1768855783.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0474.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::11) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB997619:EE_
X-MS-Office365-Filtering-Correlation-Id: e6e880d3-3ea4-4d81-c89b-08de579dac69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Htcjjv6EwM8UYmS/chYPm6LNIgUSK6EJqk++FvQBOMYgS/Vhyne2HM+0Hooh?=
 =?us-ascii?Q?ZE49vGYpnIMrl5ZyrGvugP+64qkhbNj5jypfL3zrjMaHy1COGj1PKtDZaXr/?=
 =?us-ascii?Q?Umngr4zjg2bJdywYPer9Y+zQIjtc8DoDjT5CCHA+tWguo1eeqNEUxvlBaJBT?=
 =?us-ascii?Q?M4lAqRPbDzaUDHZt9W64OyFox5FQC8S+B1i4PwvKCduJhitBR1Dq9lUFQClp?=
 =?us-ascii?Q?o2vzL+a/rvIdaS4rcYgbaT0W1exBbq+JwAnjm9MOwauaLo9OiiPPa6PJpgz+?=
 =?us-ascii?Q?RBbYxKIQBlQ9dmYIFhKB08kSicmuLnmwMTrLvFf+DwJAJSbIaHf0B8IQnr4N?=
 =?us-ascii?Q?pfBP4D0cfb1PusRKQez26P2kkrpkKNU6G4VWGXz+e3hlWxPWTCCCUS8nbLVE?=
 =?us-ascii?Q?wFPjU75CBBRpQjro6kSg6bahD+L3Z0a4600gjVXEmhFfB5dBNEOMoivK7YVi?=
 =?us-ascii?Q?CN1i/kwPBcrjF8tANNjPG0+kqvfNAI2+X8nBAti951dhTQ3WW72Ex2MogU7K?=
 =?us-ascii?Q?UyNDo6LuVWTMO5MjwdoxBehuJaj1fQ+cLBgxfIQXc72wB4r63nYgVLVSjT6p?=
 =?us-ascii?Q?ztv5FBlecw3HUzi1CqwyLcbPsnQ3ds6YDInZ9w5ohH9Fu541wnCnX/T1sIeF?=
 =?us-ascii?Q?v+gpwWZUAtaCzpFu2JLYpwPV2Kn+dj66Jw5gEYbQPwwOsZ1iFa6hQ6sHyqlZ?=
 =?us-ascii?Q?wFbEHlxKEA17ZrSg0iWlpItmAVJ5NdaTCKMGSrz5nnWLPV9QMtdz7vQ+BdSE?=
 =?us-ascii?Q?qh4Z/ZlDcdXI/a6LT5D77FMfg1NSG3brGckfRnQ/RhVHO5ObzTcTk+pGloln?=
 =?us-ascii?Q?1hAL80SFzYIYeoYu5iznKmg24sq1OjjLYNTXS12Wk69d2JVDyvuT88oB8X5m?=
 =?us-ascii?Q?qELAAJV6ww2s+q+1hJGIp7pExupeDE+a6x6E09qoJPB0UZKyAtpw0arAtYPV?=
 =?us-ascii?Q?nUdZicbCMOjYcORpprhGurb+0jbNQLCBw44j/OX+BjOD1stTJxyleemKsA1p?=
 =?us-ascii?Q?DM8jq4bMu/FoahuY+iebkKcXlrgmMKGGjAm0ULHYFSOMDCL8LxKERYtmpe5n?=
 =?us-ascii?Q?U6+nLA2DcAEZL1n20kJKin84cZly8G4DPpNJLZKGh4vaiibybrnq8TTgQO2T?=
 =?us-ascii?Q?fdZzvGuGVLjspvNYoQPBZHLAfxZ/5yYTAHc/4mMC9hPUyW3bvMVTGg0nF9sG?=
 =?us-ascii?Q?IFFoQsbvIYAS7BO0+20naK8FH0LUUAfzvzW55K1rJkQncOSUeZB0lYMPzlgP?=
 =?us-ascii?Q?WbPk0OJwHs3RflJyJFKKpbA00UKR+XV5M71PRz5IFNUk2TvB4gEYGBU5zz9l?=
 =?us-ascii?Q?Gq9BUdMQauABm3gcN10Jy5On+yYB0EqDkWp0dnUugAMiN6gOVBo0pmspuQtj?=
 =?us-ascii?Q?PwcnCe+ESGylt5ObofiE8+/RpPeS8m20/tywByY+1Ic80v8Livfdk0glkss4?=
 =?us-ascii?Q?HZMj6aPaZewMc3+/ekNsgPlZpPCtBQbaFnaEDRlFUR1MqS8uKBqS6qtuc8+S?=
 =?us-ascii?Q?uzg3Bc/PmPjtCuUTaFnsGaAaa3M4mpithOlMJh5R+PWZjfgBUX48D/mhzWI1?=
 =?us-ascii?Q?a3zJt2z2+OJkuEwyHwo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7QnRtYexWsSoSHnPlN4iNTFz3WSsBiB/Lb10DXHovWKiODouYRrZY+7i/8aG?=
 =?us-ascii?Q?fjrCBINC7cggepnzUTlI4xc4Ad6p5URMjaXklCjThfRx7ZtFoOB2ebW7o8Ox?=
 =?us-ascii?Q?OinT06/WhE9zEpeLvVhYxcLU5jE3kUAh1B8fNTzZew7IevJ+FLbIFGkj63Ke?=
 =?us-ascii?Q?DJG1bSUiKy88ahcv4OI3QHOv/pP5rByQVflqu3Jnkup3VzZQgP614Sjqt4OT?=
 =?us-ascii?Q?RMCFl8yDt2FAy5NF0r64co0eD4aoGzMuBsHFuMWc7XEjm+5zDSfrB50xcIYY?=
 =?us-ascii?Q?3d3djQTUnWg7bptGCBXmQfrAhK/sfeOwd2/SHpNhVib15F/0dcQMCUS7wcz3?=
 =?us-ascii?Q?xUVyhN+crkc8jlio3WZxDYlxIlJnPLBhjKsql9fmw0ASeAXobXYr2Qe4Yoml?=
 =?us-ascii?Q?3k7MLPxz4Q/Gcy4aIdSYajx5zjYPDvR+tZ2JVt7yeyg6NnJDsP1mW7oRXrbc?=
 =?us-ascii?Q?vPrqnYCJ21rKfLnMrPEm9plHMnx10lw7tRwBLs4SFg4Jy5yZZLAP4ybcHUH7?=
 =?us-ascii?Q?+DJbSXtf8zaPP5E2KRvepT2iCZGOKbgTc97nYQqjuikJKSdqWtrP1DrwS7eV?=
 =?us-ascii?Q?vLXYwfMofWtTbDXcZEYScHOWUiAiQUHFXnk1DThMpAXfyRTkMsld4AM762Sn?=
 =?us-ascii?Q?Y5716ie+e0tatDgXGnPeaPyO1WUlB2BYrgbWo/8Ee7migWImajjRMta8uU35?=
 =?us-ascii?Q?J6zXQVAF9NOGHIEEv4uyQxbR/Gneb3iJid5jnqz5vc69TIridxqSztClW0gF?=
 =?us-ascii?Q?vOsQPRSh73jDcJw+nFpmThxNV7zicvC15FNKCm90l1Hx1TUuunQiHN+x2N7N?=
 =?us-ascii?Q?kTI/SwtdmK/xbqtC3cdur44UctjGku5detpKBhTdXSoY4C8mABeTKdWwmPRB?=
 =?us-ascii?Q?MBP1PWjWdEn+oLd6anMioZmkQcaWeQ85vW6Ru3TXXIDAK44hdIW4PQoANAmD?=
 =?us-ascii?Q?hm3oMmlb4VFdwIaFWRnac79VVamQMXbD3eyTDl2Khum4rHU4GyIYt6URdifC?=
 =?us-ascii?Q?yjuZ1YgRaweUgxOnFVh3d36oAo88pzPHqKyivnE+4OCIgC4grGSt31kO9ACU?=
 =?us-ascii?Q?+/f3+PtN+PBggq6G98ITYi619HsXmquG+a3TOGrQmDEi+xBWZOhKlMv6CRFm?=
 =?us-ascii?Q?g3BhiKFY/iTK2+nqoGdLAOGneucfgIP5seaQ6oSGWq6PWPmaYyaEshfSH+tp?=
 =?us-ascii?Q?TqFNDmsH9I3duBc6gMDsjZ1d1wa3JZ5XId/nc9zMfZbyee2DnzxFqTLW6CM5?=
 =?us-ascii?Q?P8LaJdl+YPhZgHlmGMUMtbTxWekUQPmh9f8DbIZZf30Z/7FPnAsBNm5bZvcN?=
 =?us-ascii?Q?jeUqPnmc6SEilIqdDYeatpXADsuhSE2n678e4wOdVJ81S+9ZCyLn4LFTmrAg?=
 =?us-ascii?Q?ZGIgan2pddP7Djc7oXqOOdBH7id3GyBATvJoVZD2FTWzil7aNuTG4GN9ZiEy?=
 =?us-ascii?Q?HVCd4InQ0BemNrkdWN+JRrVieYcTFY5qPrgT2pv18ivNwE5AVG4xmn1m29WE?=
 =?us-ascii?Q?heplcbplYW55Lb5v9y/N5jouIbx2AmApXScIF+WKkP3wNfG1RXA12KqCwZjU?=
 =?us-ascii?Q?FHBlB0IIdh4z+DeRpAuzRyB8cYMoCvUB0V+T6JI8Pig034GcVYnuY863LTtU?=
 =?us-ascii?Q?X/1pqjWtiB3Dc+CEtn3MM3jBXDGH8TXk1ea0Y2MHZqU5JgYuVTmaahkqxaPT?=
 =?us-ascii?Q?8RmGJYoFuKFpevQAGDK4hROg/RbnKeKBjs9R0fnIHaHf0GJjZRnUM/GkJnEd?=
 =?us-ascii?Q?w5Q+3ZR8xCZqkkL3HF6kEhk9PTD0WAI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r7Gm1CMiB7naZyHHmQ3FTEnWxMrXCiLjIBetzXLSGNA0SLn8iQ53gytMb3TA+6VPqAaV5hQgV6cTOUV7icUj3PEiYZEzLhotvei0v4/xplSGy2rOKcPZ2fnrzokO0/APqtOHAbOPc4sDWa5jR1quF6AqFJSWQ11tIwyvZOD3SO5eGStHLeJ5X6EYGjRvydC2ZK2a38BFrhiCl96gDciYQ4mjH+RrXD26Ey+11kxS4iscnSb80WiGWURsEeR5uu9pJCpUj6+JY41IReFzXH/wJ06F5FMl1wIVy9taDz7HoXMqxXuCdzy8TvpN17mEjO0vMDTpciVkFCL53ZPJgpLjGw8Ji8UEpCkpvqw6p9X/O+9mEXk4vD7TMPyJQQfRfziorh0r+3iYw6gvd1Y3xzMTX7014Wsd0TmtIPSttSI0j351pPCCTBn6/IuVMXPOHKnANU7Zya4W2vShkbzpJMCX0ez5Bib8mrVpv8Zm/bJTAixzIWLKRJoPdEbcWWU2/jx7CbFl+R8DpN7Ky5vwd1XEnUphj1lD6drK2jO7DLbbk2Rxjr/fXIhWdxawv74qVYlbuMrk3KLXtWXbGztAEU33Zo4ZioIHsQ4QImMl5PFD/kI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e880d3-3ea4-4d81-c89b-08de579dac69
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 20:59:44.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lz772PImvInw5BBeV4JEd4HmQ+gjYNFC1SxBarDzqpV1CoFkj8HyaU5+qMhbDmIXUhtmL08Q+U7W1juGeGujwGFA2YpMHiQWo9I3MdnMDRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997619
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_05,2026-01-19_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190175
X-Proofpoint-ORIG-GUID: uIhVFyOOfXZHdTWz5MfIlu3qXUB0XujZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDE3NSBTYWx0ZWRfX6NasXGmD459t
 BEnOm4RudTP2CHTVDk1AmKJ46uEGk2JWdibgjNZhgcp4koAEStc57l5/ZhwKaNWkmncRvg/NfHo
 vvr8WPvr/goPErwRvQ5JEqHC1e/nSCPEnD1USlRLK3jLX962lSBLz0tPInx7WWsoiiguXOxqKwm
 laQdU1wapSHHqCq0pI2IYGcqX4eAJF0jqX71faM4eUdIWP1qHAZqtshGrZwv1o7MY1IMicI8I7m
 RrWj8R+noBCt2/r5RHkW/cQ7YGH0yEmCsydEzUl58dcA+0F9kv5vwDo4qiMnNCiLIhZ6N0pdEjs
 9W+nLywWbNe/jMqmSPXHJnVW742MFvdPPE+nKsxtBq3y5KwWQ5eTXQhkOR3dv8enxn3Cge0vcq0
 DbEP5uMCZylV+UwwTK89Ie6mEfYA2duyHjiQDIKpH03vYDGSS7oYu6rdNalTT+8Z7Imw6OGwcvk
 6iK8yTC2IDGFMT8Ck4pTzap38SHfnO8kaQQaodlE=
X-Proofpoint-GUID: uIhVFyOOfXZHdTWz5MfIlu3qXUB0XujZ
X-Authority-Analysis: v=2.4 cv=FvoIPmrq c=1 sm=1 tr=0 ts=696e9b44 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=4B3B5tqJS_rRqnj7e4gA:9 cc=ntf awl=host:12109
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3223A1A0009
X-Rspam-User: 
X-Stat-Signature: huq8gnozu7gusumw9sftpimtdzuftgry
X-HE-Tag: 1768856400-546000
X-HE-Meta: U2FsdGVkX199k+H0FSijMYAXKIaKbgEJSPcVBiLb2JBH5783FJZiXx1zEiH9n70m6o+TXcHnkiThP/XY95uIeVyaBVpVgx/YRgO5Il6YXpJ25ezl5z5CABbbrH7j07go1V9Eyk9wv9VzPCK+wqxTV6uGAtyHf5dSqKNzzcY3dauD/4ufJVBhUmhGsYuwvtBaZksng0+7H7GlJvbAaUHtk5QU33LEoyPluPF+hTsbvUAQd6BOyACuQyAy2L0tqKNDA6CueveA+fABwybrNRPkB6bP3Tdn5z7d90Irt7YbERPpQQ6gSJpVmqAJe5FTOp1ZrptVxPlD7JYRr4GsKteBVAMosYYR53LUhAqVmopeoVxCka1HLAFA+I7qGlhJp/snkp72Y3S+kiNkpLKYocEBUNxGhCy+sONd2EROZx3VgfvetmjqZdMByQgwC0feSvS9s01a8Xf7Baqx4gcyCU8NdgF6UsbG3PDQUgTCoigUzTYiXoORpt9TRvsmX4W5MFAqN0NNh3zKy4z1kBxAufxetCLAmxviVwx/NrkvzZ4epTP/nXCWcpbIOrAe8rP4a9GgWP90/g4gSKL5KLQbPsH2ph//ubPRyKDr12O2G3Gz4X86D7Wm/WZKa+t3GdVOdf0x6dvLcQ1YEbqGUbYL4WSntaALW7DRrJq3fS02BPcBPLlcSf3QwsbV8p7pciL/G2GMsZGJNAXxLHpxvOmRl5JUlQU8p3qc/tucIGV3rG/wfqL6zVm8LMNTo1ttXsNh4MXg8jqa6NyXZJpqga0uFzckPKa7TkO4vcFl2xQqMXKXEm0YjEGlviFAjxrSNRo3io5iIQrQz+hRFMt6zHjwX8eu7QsrFTXB0oVmTA7FbNw9lJZfVqLOEkdxvmpGGZcVoJ9bIZs/3pY4xuCN4/f2sQdnc6B+TuNDGDeKqap9+9oZi1GAO8pbpJ+gy/jYn1FxDURlYLvuB1T5l4xm5nr/q9o
 Nqt5+eBH
 6q+1fnl4JAxTHUyOHjMgX5WYubyyntySVTxNwTqZt3aw5qLLn5i6ap5RPvde/dmHNicLfi/rKBg16l3baPFn+CSbimdrCTwSsJpAbNLC6S7xXicf9zUtzE6wP21XK+0tv1BjjNj6h1e/Hkx3hqPpQrKiLSy8ybPb+1IOBWzfdLhoTV0qWxAWW2XLPJ7M4uij4mFHjbC/MoVJGa/z0QrvScmGZyyMB3mO4DJy6RM+6JO4krqgm93kaIijb8PeLtR6+A71qEfvHCd2HvzgRDpvT50AvMWQ1MAwaBXvCr7TQLQ8EJawYhfOZ42e6RaGPSb3gZaPImnAiI/GfVMfgtisMA1rXc8mMA8wY6SGYSWYqynlkU0RFGKxfnIWYpJg5og1Xu7kHne97E7dnn53fhTHaOOJ1Ryk0trnPHKnB1fstZM8mhV9sZtb9d+/Cpkzmk+yZFIyjR3bTgiQ4rYAY7POmOHn7fpyqf5rei6hF+TswQr65ei+l+/L0G2DeSsGKYTvGOObJVzzKBhUlYlovrYbpX0/n1rRh8BCVtjwt6z15JZWP0478yGD7r+9x3MVwzx6PA7PSvJdIc9fKDnvGDYDeMu2AWxDa79hEShPrmZQHRgdbFhLaK1lgkDnzYkKeZ0NlGy4nbsr3Mfc3JnEIFwxQEDIHQ2oWdgDzPWCIErZrcu+9X2KJ6ggeOGehOz0T5XAOefzSZH4o9oFhzVMWoB3zpTMHn6Q7DbXFYvsF49odpP/ODgwBmkGQTarAVhkzppsTY3fJEeXS1qurv2xNGVkMkICSnFG2jupQ/Wmn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

In order to do so, we introduce a new assert vma_assert_stablised() - this
will make a lockdep assert if lockdep is enabled AND the VMA is
read-locked.

Currently lockdep tracking for VMA write locks is not implemented, so it
suffices to check in this case that we have either an mmap read or write
semaphore held.

Note that because the VMA lock uses the non-standard vmlock_dep_map naming
convention, we cannot use lockdep_assert_is_write_held() so have to open
code this ourselves via lockdep-asserting that
lock_is_held_type(&vma->vmlock_dep_map, 0).

We have to be careful here - for instance when merging a VMA, we use the
mmap write lock to stabilise the examination of adjacent VMAs which might
be simultaneously VMA read-locked whilst being faulted in.

If we were to assert VMA read lock using lockdep we would encounter an
incorrect lockdep assert.

Also, we have to be careful about asserting mmap locks are held - if we try
to address the above issue by first checking whether mmap lock is held and
if so asserting it via lockdep, we may find that we were raced by another
thread acquiring an mmap read lock simultaneously that either we don't
own (and thus can be released any time - so we are not stable) or was
indeed released since we last checked.

So to deal with these complexities we end up with either a precise (if
lockdep is enabled) or imprecise (if not) approach - in the first instance
we assert the lock is held using lockdep and thus whether we own it.

If we do own it, then the check is complete, otherwise we must check for
the VMA read lock being held (VMA write lock implies mmap write lock so the
mmap lock suffices for this).

If lockdep is not enabled we simply check if the mmap lock is held and risk
a false positive.

We add vma_assert_read_locked() for this case.

There are a couple places in the kernel where we already do this
stabliisation check - the anon_vma_name() helper in mm/madvise.c and
vma_flag_set_atomic() in include/linux/mm.h, which we update to use
vma_assert_stabilised().

This change abstracts these into vma_assert_stabilised(), uses lockdep if
possible, and avoids a duplicate check of whether the mmap lock is held.

This is also self-documenting and lays the foundations for further VMA
stability checks in the code.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h        |  4 +--
 include/linux/mmap_lock.h | 56 +++++++++++++++++++++++++++++++++++++++
 mm/madvise.c              |  4 +--
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a18ade628c8e..4c0104a21d0b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1008,9 +1008,7 @@ static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
 
-	/* mmap read lock/VMA read lock must be held. */
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
+	vma_assert_stabilised(vma);
 
 	if (__vma_flag_atomic_valid(vma, bit))
 		set_bit((__force int)bit, bitmap);
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 6979222882f1..17e5aa12586e 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -277,6 +277,56 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 		vma_assert_write_locked(vma);
 }
 
+/**
+ * vma_assert_read_locked() - Asserts that @vma is specifically read locked.
+ * @vma: The VMA we assert.
+ */
+static inline void vma_assert_read_locked(struct vm_area_struct *vma)
+{
+	lockdep_assert(lock_is_held(&vma->vmlock_dep_map));
+	VM_BUG_ON_VMA(!vma_is_read_locked(vma), vma);
+}
+
+/**
+ * vma_assert_stabilised() - assert that this VMA cannot be changed from
+ * underneath us either by having a VMA or mmap lock held.
+ * @vma: The VMA whose stability we wish to assess.
+ *
+ * If lockdep is enabled we can precisely ensure stability via either an mmap
+ * lock owned by us or a specific VMA lock.
+ *
+ * With lockdep disabled we may sometimes race with other threads acquiring the
+ * mmap read lock simultaneous with our VMA read lock.
+ */
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/*
+	 * We have to be careful about VMA read locks and concurrent mmap locks
+	 * by other threads. If we were to assert we own an mmap lock when in
+	 * fact it is another thread's, or if we were to race with it unlocking
+	 * when asserting an mmap lock, we will fail incorrectly.
+	 *
+	 * If we have lockdep, we can treat OUR owning the mmap lock as
+	 * sufficient stabilisation.
+	 *
+	 * If not, this is an approximation and we simply assume the same,
+	 * though sometimes we might be wrong due to races.
+	 */
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
+			return;
+	} else {
+		if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
+			return;
+	}
+
+	/*
+	 * OK we must hold a VMA read lock, since a write lock requires mmap
+	 * lock.
+	 */
+	vma_assert_read_locked(vma);
+}
+
 static inline bool vma_is_attached(struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
@@ -353,6 +403,12 @@ static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	return NULL;
 }
 
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/* If no VMA locks, then either mmap lock suffices to stabilise. */
+	mmap_assert_locked(vma->vm_mm);
+}
+
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
 	mmap_assert_locked(vma->vm_mm);
diff --git a/mm/madvise.c b/mm/madvise.c
index 4bf4c8c38fd3..1f3040688f04 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -109,9 +109,7 @@ void anon_vma_name_free(struct kref *kref)
 
 struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
 {
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	return vma->anon_name;
 }
 
-- 
2.52.0


