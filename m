Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6826CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AD88E00AF; Fri, 22 Aug 2025 09:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BAF8E009D; Fri, 22 Aug 2025 09:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F448E00AF; Fri, 22 Aug 2025 09:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBABA8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:55:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7258B1A01B1
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:55:51 +0000 (UTC)
X-FDA: 83804541702.27.BE6AEFA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id EAF4AC0005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:55:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MMvhIZo5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JZYaKYyD;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755870948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHOd1R3GbwLvieRnhgrNTEev5kOnAsb6/emkGzbWSEc=;
	b=rzTpqtemyxohH3+y25z7wbqHX1s04eippJ1FYEmQGDLsTtztacj+k0n4iw0DshW9zolWaf
	CaZ2Xiqe+DPjq4p7ercdFVeEA3jOdNlN0u3nj/yzJ1vn3f5dYi9+f6wpeWqzZp1r/pCUeu
	gVh/ebFM2phxQ8fkHLq6Nj8z3h78img=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MMvhIZo5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JZYaKYyD;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755870948; a=rsa-sha256;
	cv=pass;
	b=FznpG8A4j50BJtz0fK9VdsJU5xzRYVvnRm74bVQ4kHHa7o3UyLzRcLXq2ReSRLDYLKJB70
	oz+zzq9FYFrH47A0XFmIwQ3EXcg6edHSUNyW2JwV+r+SWDzJho+t2V9P6v3dVfXmjJIO3j
	HXd3QRVROtIxuP/Hfw2yRUBmFsWMIq0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MDmFoT016527;
	Fri, 22 Aug 2025 13:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CHOd1R3GbwLvieRnhg
	rNTEev5kOnAsb6/emkGzbWSEc=; b=MMvhIZo5swaKuqbycbMYrB9A2cBmNWQNWE
	D1anP7ZOxxTFjKEzeD3QDwsyfLZ8kIzmg1dvqdoCS3ZQglQJ4Kg0KSWEgpZUhNA6
	h1m4ilKSVMv1psa8abv/185bDJ3Gb0RcfAuYsdl8gZ1QY/9ioLUrfih8WiaDPY28
	QZrFxiSxjPYDsrONiW1J/7o1J+aC1ynsE4sLsQnJYp+rSeJ798r1nE5m9aQy3aVj
	KiZFA5AUQHXBmNLxlZij8+ogmnOsUjyxZrvZO9qjTbx+WrqQaUnGbOFx69zkbKK/
	ZUT7dhnqyS1EpglEavq4LA4T7S1sHjzi0pccMMLUXeORyVpUEt0w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48pa269cvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 13:55:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57MCGCi4030246;
	Fri, 22 Aug 2025 13:55:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3wq4aq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 13:55:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5bi5+6G86CLYu6n0ouU5glFqGGB4hdRU0rznTnfSneS14MkzchoAaPrwlDv1qGby9CWN8HRvRL4rev9uFqjFIzNwmu6zQELismdQuXHQJ1bEqjlqIzmfYLl1Hee9Hv6ng/PT38JpV/YSu2ibSLFO/Yn92HEnLjKevj05X2su1AJNqVyFQ4f3/PZJBhZMLf/cbBEnAzX/C/bh8ncLAv9omC9iTZF/hOEj/5dkn3cMHwBjoZHjd3i9YQTalaq4nJBu1C2PdE6lhzl2xs8NqPSspm//NRmkGV/FOD7BqMFN4gHeiDVXF6T8yVT7Zabil6rSac13mAyrO0IQW9Jm+z9tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHOd1R3GbwLvieRnhgrNTEev5kOnAsb6/emkGzbWSEc=;
 b=ni4H3+5klajH4FjazQ6tU+cnM32NuWuL+Y7EnjNAJOi88rzElYYc+1SVQqAboJrIKd4IN0sHK8Vo206ri72F1Lh4DxhO65z2IALzy6ZVQIP9ewt0ahHJCN7UFkO77QEaT4aSh9//m2UJEE+zcp7gQl52K2R/rnEdcZdpWfcx8oCqIGyXPe2pXZiUE8aXYnZIIeeoilenTw0VPL7bZHsgcBvx949LpDRzeG+x9OmJC3So7yfc4V+MXYqLaQRsg+M1wenHlk5UB2B14O0JhLH7DBM55CfQ79HvjVQg3Gp4AZ6ii9eHcdBgVAiOoX02v9ysjhVvAfC+vciOzIyr4Hk6GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHOd1R3GbwLvieRnhgrNTEev5kOnAsb6/emkGzbWSEc=;
 b=JZYaKYyDSwdTm4Er0Sw5G8r4yNXItLEsAWf+tD9b1Ayitszs29JgODIY7hPILyJTG+SBjRH3snVZb9EWbs+U8jqJyCHxrV2RqhuOi/a7eaw+UHheiu6xAbXmuvgyDBmss8LVzVqhEJnX6iHKfzd2ldePbIu3f9K6UXdxNKw9AaI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4712.namprd10.prod.outlook.com (2603:10b6:510:3f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Fri, 22 Aug
 2025 13:55:30 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 13:55:30 +0000
Date: Fri, 22 Aug 2025 22:55:10 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, jpoimboe@kernel.org,
        peterz@infradead.org
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
Message-ID: <aKh2vr9HtFRKcnR6@harry>
References: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
 <2d1297ef-5df3-4679-8e38-05be188f18d8@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d1297ef-5df3-4679-8e38-05be188f18d8@lucifer.local>
X-ClientProxiedBy: SE2P216CA0072.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4712:EE_
X-MS-Office365-Filtering-Correlation-Id: 740aa5f6-d74b-42eb-62ca-08dde1838e16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fBvfQIYgXKOwMDj774Y61fiqonZ1pFnR7Klnb4BrbxEvosR+FVCFZyD/62tm?=
 =?us-ascii?Q?8QGTK1c1Umf9j+i0W2gcCIUjVAiNl/BQbNU+g8fPPNsmSaxJj0mm+8Matg0V?=
 =?us-ascii?Q?9ohs6NtOw4HaCtuQTv84syN0Ckyu31yab1vSAwMrlzfA/ChzpdQNmXVPSciy?=
 =?us-ascii?Q?wjyTuLgKMIczFOkmonznliDt4095ua9LMTXF4CCM4aYwl3+ALFRaIB//sIhc?=
 =?us-ascii?Q?eUtY+sjf9nB9J6xEzLvc/Z0eWhWwnB0gyhuRHMlBn1lpcpYZnbL6nNRoilgM?=
 =?us-ascii?Q?FCStMCeXIJE+sKNuMJuQgVP7CVGkWms/zh/o3bpWuKFVeOE2pWUDcZbxThQ/?=
 =?us-ascii?Q?1cp5eeuCaf4RCI760ZUjSFRgnY1s/3oIwR+Jqm+NKkHImYEIm+S8s/MePc3z?=
 =?us-ascii?Q?HHwjFbpN82hM1vVwRJhOsjp/t401tR8kXSEqSyfCL5G9pUW6aOldgaEq2Z7S?=
 =?us-ascii?Q?/wp1tRdKrkry6L2UoJOU0xk4NBfpH6AZUpjoQAcoyMlAzDBJbtc09vZ3pO6A?=
 =?us-ascii?Q?LCCgYh1+3Fl7w0aoBVOYVDphNkOLIjXIiXPIVtfMq0NARhAxIue+YwKN/e8J?=
 =?us-ascii?Q?1CHHmHg8hJEPPtU+Wr6bekh8jsYehDGQ8dgTy30MrPysm8kwDoWEHnsPYnru?=
 =?us-ascii?Q?aSWO/e8vKyFxc6vQ6jLyPSoz10LmhOd/lN4t8a4zTcrraXnXl5FjJ8sm5vQY?=
 =?us-ascii?Q?nP0bOytcKI8hoKPqIrOq/noCXSpA2o82I+xYPBZk2TMeWK5xqtetJijZE0vH?=
 =?us-ascii?Q?zDD2F0ohUQHNS6oPe36Wh7d8uhbg6cSiSvBNhpzkVuvsTipx2DuARrqauZ+U?=
 =?us-ascii?Q?OCLEOED4SDAsq8uE788M0iJXo48kdNWWMjPHaRGbbji/vS1Nwv5ct2LrrEGM?=
 =?us-ascii?Q?PxSap+bMFg7RKmXzKQGlDDF0izJ0r4XcjuX5p0IEeeoUf5pScRjetTaTU96G?=
 =?us-ascii?Q?zTpWlbthV28pBYU4032ZdJY5T2I8vKYGUMptS+C/Fg6g3A6EtjNynGmrtGmF?=
 =?us-ascii?Q?a/7Wj7HQONE3odigFezVpErxzFPb1MlBvDjjb0xuKviUdIa61OQsb4yfQvl+?=
 =?us-ascii?Q?FKRu7/Pr64zM52Tv9hoyKbfSP0VzgZnW2F6ZAXOR2Oavg9XCyb5p+GrsKpRx?=
 =?us-ascii?Q?o5UpH0oDrBiQuPSm//XBpdiEoaPZMLO12bf3xk7ojheO8Kg725vTJPYu2l/H?=
 =?us-ascii?Q?AVh5hLdEy5MnkVvILnk4iFIp2ygK8Wbtc5hPVhP4kn068PHfYSlfgIuRRxL2?=
 =?us-ascii?Q?Tw/d+cqAO7SYxrS8rmOlEOXzE5NwEOVBzWld8jfdjOSmThijNyJW1c6flU8E?=
 =?us-ascii?Q?wjpplt6gy3mM1dm9Pb4iI+kNEZUG5GqVFh4oSB07w3QAzqMDtqs0xYOqX/SG?=
 =?us-ascii?Q?WNT0w9jnP2e4Qo2tU4GHnm15717H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GjVTu8XXtHRd6u89kLT05+hwwG/YR4ZmdP9hS+QQDyaq1MfIvAxWggkHbTE4?=
 =?us-ascii?Q?0G8/pJgciGXeBVQ6M4Alfbh9bCAECMVLV8iODqZSCISFxDskQG5AUj54/aiS?=
 =?us-ascii?Q?gDwKlTAk9zlMSiJA8PeIxDhQVKnbVuoPdVB0cQtgTlUW7ffTpXyvC7MK0N2U?=
 =?us-ascii?Q?M1sqfXXNRr7/Dd9SibRTjZJLUcANvGXJBKvjppDe6X67TPRCtQIvh57L4RcO?=
 =?us-ascii?Q?JKQFJfh6AYaZLKmVWPpToyZ65kQq63JDCSSY2xfyyb1f7J1CvPksxJ+KxOqu?=
 =?us-ascii?Q?f8WlKrRI4ANu8+m6pt1Hl7euk5D7qnpEtZeZtZDRfnD3DW576UZy/lFfR7jK?=
 =?us-ascii?Q?0aRCrWyLirr9pfX6BG8kce1sNj3YQpaOFpMFWQ96P4bKTlsH0RFnhn3oX1ph?=
 =?us-ascii?Q?DvmqeFuRNH3kGROFOzqAFeXiiyrgyAO3hAEQqqWWE6D4U3eyWK7i7qYbbtX5?=
 =?us-ascii?Q?dWEsQdVU+6ro/SgkKtbxakjlScJ0ttHPjAklOjvqKZBl7Em0OVLedkFoUxrY?=
 =?us-ascii?Q?FzzKyK//EtGyYTDDOQDGUayTvs8og65H9PkMGWK5jZIciRNPQkGw0A7HeihG?=
 =?us-ascii?Q?p4ycZJERYLw+3izNVl1DyXGSTmdOuSmY24uOPDlQXQsbPkw9ImW8Y6wrNKNI?=
 =?us-ascii?Q?K/QNpWMMlY/yuMmPXf/SCytg/+JXKocfgfbnJkWsBuDHQ144CgroXInFNIp2?=
 =?us-ascii?Q?C/R4BTVz691aW8kTRsXAdHjIMFVdoMRx59OwxqDqDflMi40Ab9Bvgk+2J6Qj?=
 =?us-ascii?Q?Qzxoh4K+HADQVRzknl0R96mjbTgJbb+znQzsESUedYsWt6zmGZW/Ly99Ixeg?=
 =?us-ascii?Q?b9WovOO6Z14qja1dyY6pcin11DarOUyiolCzP8AuJm0S+WXKbA//egktEqWI?=
 =?us-ascii?Q?OEmkSK8heBSvPQkuPJMkkw9yh9o9DXUOd0Blyb2ANMgvAY84SiyJGJJTnB0b?=
 =?us-ascii?Q?VX7TcJCgSdq3ukoKcRDpJvKGM/zwOGohtYQ2EPevTGGV/7jAQ+MgJ32p7ipO?=
 =?us-ascii?Q?uZCrFdjLohhgNAagpA2/TqLL/XOTinajD/KyoPPSVbxVPyqsOMBxzKnX0YCI?=
 =?us-ascii?Q?ryA80lqB/vfy3253ye/3B/wfQiRhopzMpmGnAjBZvsyhEte8p/Q0PbEI4ia3?=
 =?us-ascii?Q?pOJcbsiMdMt3btcmDmXllsJMU+yCPif7RFvtoSsn1BasTds48vywZznElIuk?=
 =?us-ascii?Q?waA0xgXgzLSHOIGjy2b1Q6A22oe/avb8Y26TMgIk6hRFFwajhNd+3gPqa5Aw?=
 =?us-ascii?Q?szDWNoXTLJ8+6JIkbRyquC4qGyTc77dGm+3gGqAe+pgNm5Zpa817gP4SoR6v?=
 =?us-ascii?Q?E6bGho/q+jhFKinyswfaAxdA8TlTz8FkDQsllbLDN9OOVGR7QzDw2mKrfEhr?=
 =?us-ascii?Q?McjTbpYRxTJ/JHXR80GoHe9EyQ+YOmZk2imGVA2sOD0SpJH1Yo+M7uNwqCP/?=
 =?us-ascii?Q?Z2s9PXTu+YvfbeNiORpKHZI6qS+dDPFI4+mopk0c0GQzBK/pMbKJpEIr2kSO?=
 =?us-ascii?Q?Xqbh29Wa3ZbmnEsn4B08Ri0KHsXzLnc3yeOg6YamHCvVbGgse74z7h5KLq0J?=
 =?us-ascii?Q?QZsJgA2nkgVIAPd2lCWhOlzWvoF54mzLU05ZlPMk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rbZJWs7jea+4ARBBoAwj/1Q/jBoiUf4Yl4ceZPUf8dZ+Dr8s+J42c1cW+J4pEO7zft0FTzi6G7UnCQZhtHMCw1uzDz4Jrz7Xo505UMpYrlo5FjDy9zPOhc6gpvohqVFB4qfXCymzxDHPEAmrzE7S0HTRZXOXO+OFMzwwdkkivaMLMY54PRdkkuUZbh8ufpoDbW7kp3LBEil/LlhPfCeYVNjT9CqGj0gC14y9hHE1DHv5ExfWOHGmHnDLPcXbEP1CrVqgLvuQ+kJGIm0fBt83OwhJwVteeb8ReHxKC4UkDYMIIMFS8NsUrZjEaGbJgSoamGuxbp1Com/M5VB1nGniW268Ed5ijnW6JASfVbkAOZmruyyN7YqSMDQlNQeffLoV2lkpCjF4mSPSONMyQbihCRxIV4BWcmDeIYGf6mHPqJSDmi0xOtIZQUFx0tMsKR+DEtKzvedL2mc68vBd9AzyUoMF7kljwLZFK0r0KD2eHc+LeHKj1KGkVpQrstArj1oYO6Efi5Ou42095VPDwbAWUkWKZ0N2l9BxzpzX+eh/O/OxnMKuliqrfoExTuJrojcavoUsqh1kl7HkW0eRg1ITX3aF5dgs3rgLgdbPNSpNESo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 740aa5f6-d74b-42eb-62ca-08dde1838e16
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 13:55:29.9718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdk3OG30zWg97nN7agAdQ2tDofw9QnN+m7A1UOc+b4DL35O+UxRWoJuh0fsWPqMdLIseH7+AGkYBrDTrs+58cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508220124
X-Authority-Analysis: v=2.4 cv=ZPiOWX7b c=1 sm=1 tr=0 ts=68a876d7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8
 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8 a=0zgOq92d76KTLj2kfncA:9
 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22
 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22 cc=ntf awl=host:13600
X-Proofpoint-GUID: sj1sc1EPeHJfHPvsv1vGAT-htDfn1ane
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIxMDE2OCBTYWx0ZWRfX3X8iEldjBauZ
 U7DETghk6lRAnvF4EDtwViqPEpanV0UODREdCn0PjvI02uBos6kpF/FyLIDQOI72RbJKk6l0m2g
 6KhdElbafQGRCHzeLigFHbgdAexTM01bemRvk/ZSHmHFLYWnybvHJuCPWiRvtcFG8yuUJ0ZcKkV
 114Zz8QeFMokroTkh0MlovaXJO1iSZppGBjbIIVXqsAcpzIciHkYhZmT4kHbwVJoefEizLABkAA
 aEEcra9ybxkQGym6Kj5ir3ByqvlP/1f55uqvJ9wXVZ8+KzNtV0Blw1+tRscgapinaKwcU6ErAgS
 mNUvD5ATkmNt8SzmPw17i5mAAbLGtpSdTjAqVfaCnDZigKMo/XURGVVrY4/bk8AOdK9g1wxAAgL
 i0zPV/HqcG7ldXnu+s8Lh4MqZZhT7pL0RKQdAUuaMw6HZwCfGkc=
X-Proofpoint-ORIG-GUID: sj1sc1EPeHJfHPvsv1vGAT-htDfn1ane
X-Stat-Signature: 93ic7xyh3a5imx8pnk351ko71z3meneb
X-Rspam-User: 
X-Rspamd-Queue-Id: EAF4AC0005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755870947-496160
X-HE-Meta: U2FsdGVkX1+H3junT8dT9M/s4i8TaNau5va3NYYIuAb2b8whwAKhBIIaVfgGJF0r+Wd3EL+XbfCegZGZTQQ4aCTRHiAdd3paXi7dtfgZmUcSjEu/K47B0W+TeSM3wB6N3zUvxTR8YPRw2sKaA0J94fEa5MGWfB4b92c97n6z0zRI+FdQj50BEAXKlWe0y4UpECN4dtSicTmJrTArcgSOTxKtQlZNqjwWgAtsc7v7rrP4gqFVLja79AJDw1MnOmmcaXhVAGO8Mktz83e7hH1znaffbb1OPcbZlKIAgnn3V8F7RMX+jHLwRypc5TP4gOLaMRxvfQaQLRPce6XZXUN/Eu1E/CkAjY/NGl99HsSWLcU5q+itWOl+ej24scyf+sN2zD2ig+AWNaWxn/kFu6Sk+0bwVMRKDW0fFDi51jqEDXbNel3Wn+xYH6jRQaO6sAhRQcbRGqzv8L5OzeOhDUnGDHGH6ZSqi8Xgi4J7k8efvcekt/u/SFusCLJDK6+S1nVn78kL6D7XiLDG0DxFMU4FDvS1g1eB6kABQnC83aqNKQnolkiwGr0/ptkO4ryTt3eOJWgHlLBdHJkVPZjyjejYFVXzPL5R+h7I5bx9+aVN28pxgs9xVgcfhgTHB50nskk5ovexy0HnlZQsvitqBB2H8rkGaTAqBBGbbQHQVeMDDl1fyt3m5oiMlolGly0+9LwpRguXbwzholXPwLSOtQDAR00ow7Kgkf8FlMRe+H36w3vzMaHW8IzcKGeOykpNRlED9iA/0bY/x5eJ3REJ6X8sdkKvqvMOPlK0lMyK/l/s+oUfpwSt/J+0RIT7XPy5ur7xbYHSNp6ylRHtJQY8bRpVNH00aiLXwzSz075yMH9fCXA9aGUqoc/x10Frh7NdAcsz6sYDVH1K6yLkrBy4nBBPDMLKJCsQhG/6/gUP8vaUcedDmDMhPi8KcgFRdQlCQ8sa+dOzeaaskLRuEBIeOzm
 xP3BHe0n
 dSaT8UoAiCUEwsjSiuR72kNHz892eMmDO6FaelMAN95XWRyIDaNwK161YQ4Je8z8qpN7+6iDqd6M+DeqJmqLnfoMS+3L8udTYsGARZfJN38+GbIIJEI65U0/fOhXnCHQCSdiRcDZphdNqhSq0vEpH8xWYNdsB5TL1sdQjAF18A8vZ2I6mqtOZN9ux+NErl2uwNxC7hoZfyDziwvf3TjKVPKJzlU9SP4oJykUe9dXCF+7bBs3IrOZ0walIfDnavJuDWMX3nXQkp/82aKDIHS5LzoRAikGnxrHAw9UwgU3NZp9F4ixkIXuu7O8h6LlsTu43AYZ0lrQGR5Fap+yOocXPPXSNjrjpLjVMqWHBJ9DVIPT1FO8wVdVGiZBo4nBWYeVQMTvBk3e8LBBhgSg4FZPfjUv5u5/XR+eg7F3dW+VOC/yWlOGmzm7JrM3/vXlxWFuOYSbNmAVcd8tMfubxpPU44r5iwUcL90T9jGuYOVFIPNrXr8ZrY0pPoQ7t8Ule1IJjQUSSxy1FSyo9S4ygDEwo0TuMU8+vYH7rOzQHpFpfqbJdP4UeeAcPBzb1Tyz1y1rgWlYWWhgilQfDprR1EIwsBvfstoAgbtIGKbV9JoePs62gue/1liLgYVZ8FHJOWWOF63Efcqb64eVrUHGiquJlnf5DP5HWyTApNu4TE1XJqI0sfAMtADcUgrQfChSsvL36vnklcPtMOKtg6VjWUJJaOraB3bu1bAsgfjeLRgNXCVpYhBZgISA0L1ElUwYp+xxB9jEC/8JgJwHlDBOcbRemPo1tic/aVZvYLGmMaIhhucgSzyTuVVqjJJyGBsiCLYKWB+A4QeyoKgHdxKM8lFhASqXE7A3Z3E6gKqo74Of+PVX8NumOtS/8okmwuh5R6ZMTyjkece2HP4nEihqtLvqNYTa5p1jBkXV5Nsp7sZdiis8d42LVypOGeTnCyE9TaR9Va5dJdFmXF4IyBmLxf0TcqShAT3zY
 /iYE57iG
 eNmbtiPB/zZorlbxDIwni0gv3b4KhUsiEUdydbCJG4jdqxdy+QaGxnBGYocTtf6gkXSZP3r7TQTRcnna8t5qa0hokfFdYQIFOXY5X11HvhV364kySot7NTm9PN0Zw8V16eDKTIFGb+SarLXL1zcYF9ixzCywgrfdepnpZZ4Q3l59PkLIab/1aR+/1X4yxlfbH7G+NCkEbcyXJDwXMcfU6bKXOPHJIevtK1TnNhRTbi8ioEgGwIA2cFMgV/oshEaSXiVjx3dOHB/l54WqZXwd7OIOECz0RlAaUWAV3VX3TOQfbzfqXQ9Vd7CVBmrUUOpwSYIKhF86JzJWezWxK3yIXtzCdDLUVELv1hMhwqN1KcKhNu+EC+uRPUKM5qmzXmwgzMuYbB83x0/IN5iZF5hTkqT08Dlve0qJvRN9p36Ip3AnB+ccO5Uj0dTm0wSNJk/mJ8wAivw8Og8MQzHAdWZyLgWcJA0S6MKyTK5J1lsrGHBwYwSlQ4EFSPRy9b3GYpCTrlLRWSXZfPX2W+3mzN1MCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 01:08:02PM +0100, Lorenzo Stoakes wrote:
> +cc Sebastian for RCU ORC change...
> 
> +cc Harry for slab side.

+cc Josh and Peter for stack unwinding stuff.

> Pinging Jann for the CONFIG_SLUB_RCU_DEBUG element.
> 
> Jann - could this possibly be related to CONFIG_SLUB_RCU_DEBUG? As it seems to
> the stack is within KASAN, but no KASAN report so maybe it's KASAN itself that's
> having an issue?
> 
> Though I'm thinking maybe it's the orc unwinder itself that could be problematic
> here (yet invoked by CONFIG_SLUB_RCU_DEBUG though)... and yeah kinda suspcious
> because:
> 
> - We have two threads freeing VMAs using SLAB_TYPESAFE_BY_RCU
> - CONFIG_SLUB_RCU_DEBUG means that we use KASAN to save an aux stack, which
>   makes us do an unwind via ORC, which then takes an RCU read lock on
>   unwind_next_frame(), and both are doing this unwinding at the time of report.
> - ???
> - Somehow things get locked up?
> 
> I'm not an RCU expert (clearly :) so I'm not sure exactly how this could result
> in a stall, but it's suspicious.

Can this be because of misleading ORC data or logical error in ORC unwinder
that makes it fall into an infinite loop (unwind_done() never returning
true in arch_stack_walk())?

...because the reported line number reported doesn't really make sense
as a cause of stalls.

-- 
Cheers,
Harry / Hyeonggon

> On Thu, Aug 21, 2025 at 09:15:37PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    be48bcf004f9 Merge tag 'for-6.17-rc2-tag' of git://git.ker..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=136dfba2580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=142508fb116c212f
> 
> lockdep (CONFIG_PROVE_LOCKING) is on, so I'm guessing there's no deadlock here.
> 
> CONFIG_DEBUG_VM_MAPLE_TREE is enabled, which will cause _major_ slowdown on VMA
> operations as the tree is constantly being fully validated.
> 
> This may explain the stalls...
> 
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8785aaf121cfb2141e0d
> > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107a43bc580000
> 
> No C repro yet...
> 
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/24fd400c6842/disk-be48bcf0.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/59146305635d/vmlinux-be48bcf0.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/b3e5f65cbcc8/bzImage-be48bcf0.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com
> >
> > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> > rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6029/1:b..l P1208/1:b..l P6031/3:b..l P6030/1:b..l
> > rcu: 	(detected by 1, t=10502 jiffies, g=6285, q=421 ncpus=2)
> 
> So 105s, or 1m45s, that's pretty long...
> 
> > task:dhcpcd          state:R  running task     stack:28896 pid:6030  tgid:6030  ppid:5513   task_flags:0x400040 flags:0x00004002
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5357 [inline]
> >  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
> >  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
> >  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
> >  asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
> > RIP: 0010:unwind_next_frame+0xfe7/0x20a0 arch/x86/kernel/unwind_orc.c:664
> 
> Hmm, while the line number is not pertinent, I notice unwind_next_frame() has:
> 
> guard(rcu)()
> 
> In it from commit 14daa3bca217 ("x86: Use RCU in all users of
> __module_address().") though from Jan 2025...
> 
> This is defined (took me a while to track down!!) in include/linux/rcupdate.h:
> 
> DEFINE_LOCK_GUARD_0(rcu,
> 	do {
> 		rcu_read_lock();
> 		/*
> 		 * sparse doesn't call the cleanup function,
> 		 * so just release immediately and don't track
> 		 * the context. We don't need to anyway, since
> 		 * the whole point of the guard is to not need
> 		 * the explicit unlock.
> 		 */
> 		__release(RCU);
> 	} while (0),
> 	rcu_read_unlock())
> 
> Meaning it's equivalent to a scoped rcu_read_lock() / rcu_read_unlock().
> 
> But since no C repro this is likely a race of some kind that might be very hard to hit.
> 
> > Code: 85 80 0c 00 00 49 89 6d 40 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 56 10 00 00 <41> 39 5d 00 0f 84 10 06 00 00 bd 01 00 00 00 e9 de f3 ff ff 48 b8
> > RSP: 0018:ffffc90003cdf6a8 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffc90003ce0000
> > RDX: 1ffff9200079bee3 RSI: ffffc90003cdfa70 RDI: ffffc90003cdf758
> > RBP: ffffc90003cdfae0 R08: 0000000000000001 R09: 0000000000000000
> > R10: ffffc90003cdf718 R11: 00000000000121e6 R12: ffffc90003cdf768
> > R13: ffffc90003cdf718 R14: ffffc90003cdfa80 R15: ffffc90003cdf74c
> >  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
> >  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
> >  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:548
> >  slab_free_hook mm/slub.c:2378 [inline]
> 
> Invokes the CONFIG_SLUB_RCU_DEBUG stack trace saving stuff
> 
> >  slab_free mm/slub.c:4680 [inline]
> >  kmem_cache_free+0x15a/0x4d0 mm/slub.c:4782
> 
> Note that VMAs are SLAB_TYPESAFE_BY_RCU so maybe that's somehow playing a role
> here?
> 
> In free_slab():
> 
> 	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU))
> 		call_rcu(&slab->rcu_head, rcu_free_slab);
> 
> >  vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
> >  do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
> >  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
> >  __vm_munmap+0x19a/0x390 mm/vma.c:3155
> >  __do_sys_munmap mm/mmap.c:1080 [inline]
> >  __se_sys_munmap mm/mmap.c:1077 [inline]
> >  __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Seems a normal trace for an unmap, note (inlining removes stuff here) it's:
> 
> vms_complete_munmap_vmas() -> remove_vma() -> vm_area_free() -> kmem_cache_free()
> 
> > RIP: 0033:0x7fb13ec2f2e7
> > RSP: 002b:00007fffe10fae78 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
> > RAX: ffffffffffffffda RBX: 0000562bd1443510 RCX: 00007fb13ec2f2e7
> > RDX: 0000000000000002 RSI: 0000000000004028 RDI: 00007fb13ea1b000
> > RBP: 00007fffe10faf80 R08: 0000562bd1432470 R09: 0000000000000001
> > R10: 00007fffe10fadb0 R11: 0000000000000206 R12: 00007fffe10faea0
> > R13: 00007fb13ec42000 R14: 0000562bd1443510 R15: 0000000000000000
> >  </TASK>
> > task:syz-executor    state:R  running task     stack:27632 pid:6031  tgid:6031  ppid:5870   task_flags:0x400000 flags:0x00004000
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5357 [inline]
> >  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
> >  preempt_schedule_common+0x44/0xc0 kernel/sched/core.c:7145
> >  preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
> >  __raw_spin_unlock include/linux/spinlock_api_smp.h:143 [inline]
> >  _raw_spin_unlock+0x3e/0x50 kernel/locking/spinlock.c:186
> >  spin_unlock include/linux/spinlock.h:391 [inline]
> >  filemap_map_pages+0xe15/0x1670 mm/filemap.c:3791
> >  do_fault_around mm/memory.c:5531 [inline]
> >  do_read_fault mm/memory.c:5564 [inline]
> >  do_fault mm/memory.c:5707 [inline]
> >  do_pte_missing+0xe39/0x3ba0 mm/memory.c:4234
> >  handle_pte_fault mm/memory.c:6052 [inline]
> >  __handle_mm_fault+0x152a/0x2a50 mm/memory.c:6195
> >  handle_mm_fault+0x589/0xd10 mm/memory.c:6364
> >  do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
> >  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
> >  exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
> >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
> 
> Faulting path being context switched on unlock of PTE spinlock...
> 
> > RIP: 0033:0x7f54cd7177c7
> > RSP: 002b:00007fffb79a5b40 EFLAGS: 00010246
> > RAX: 00007f54ce525000 RBX: 0000000000000000 RCX: 0000000000000064
> > RDX: 00007fffb79a5de9 RSI: 0000000000000002 RDI: 00007fffb79a5dd8
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
> > R13: 00007fffb79a5c48 R14: 0000000000000000 R15: 0000000000000000
> >  </TASK>
> > task:kworker/0:3     state:R  running task     stack:25368 pid:1208  tgid:1208  ppid:2      task_flags:0x4208060 flags:0x00004000
> > Workqueue: events_power_efficient gc_worker
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5357 [inline]
> >  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
> >  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
> >  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
> >  asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
> > RIP: 0010:write_comp_data+0x0/0x90 kernel/kcov.c:240
> > Code: 48 8b 05 db b4 1a 12 48 8b 80 30 16 00 00 e9 97 05 db 09 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <49> 89 d2 49 89 f8 49 89 f1 65 48 8b 15 a7 b4 1a 12 65 8b 05 b8 b4
> > RSP: 0018:ffffc9000441fb50 EFLAGS: 00000293
> > RAX: 0000000000000000 RBX: 0000000000040000 RCX: ffffffff89ba2a52
> > RDX: 0000000000040000 RSI: 0000000000000433 RDI: 0000000000000004
> > RBP: ffffffff9b2c41ec R08: 0000000000000004 R09: 0000000000000000
> > R10: 0000000000000000 R11: ffffffff9b030610 R12: ffff888031800000
> > R13: 0000000000000433 R14: dffffc0000000000 R15: 0000000000001770
> >  gc_worker+0x342/0x16e0 net/netfilter/nf_conntrack_core.c:1549
> >  process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
> >  process_scheduled_works kernel/workqueue.c:3319 [inline]
> >  worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
> >  kthread+0x3c5/0x780 kernel/kthread.c:463
> >  ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >  </TASK>
> > task:dhcpcd          state:R  running task     stack:26072 pid:6029  tgid:6029  ppid:5513   task_flags:0x400040 flags:0x00004002
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5357 [inline]
> >  __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
> >  preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
> >  irqentry_exit+0x36/0x90 kernel/entry/common.c:197
> >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
> > RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:80 [inline]
> > RIP: 0010:__orc_find+0x7e/0xf0 arch/x86/kernel/unwind_orc.c:102
> > Code: ea 3f 48 c1 fe 02 48 01 f2 48 d1 fa 48 8d 5c 95 00 48 89 da 48 c1 ea 03 0f b6 34 0a 48 89 da 83 e2 07 83 c2 03 40 38 f2 7c 05 <40> 84 f6 75 4b 48 63 13 48 01 da 49 39 d5 73 af 4c 8d 63 fc 49 39
> > RSP: 0018:ffffc90003337648 EFLAGS: 00000202
> > RAX: ffffffff914e0dd8 RBX: ffffffff90c5215c RCX: dffffc0000000000
> > RDX: 0000000000000007 RSI: 0000000000000000 RDI: ffffffff90c52148
> > RBP: ffffffff90c52148 R08: ffffffff914e0e1a R09: 0000000000000000
> > R10: ffffc900033376f8 R11: 0000000000011271 R12: ffffffff90c52170
> > R13: ffffffff82127173 R14: ffffffff90c52148 R15: ffffffff90c52148
> >  orc_find arch/x86/kernel/unwind_orc.c:227 [inline]
> >  unwind_next_frame+0x2ec/0x20a0 arch/x86/kernel/unwind_orc.c:494
> 
> This is also RCU-read locked.
> 
> >  arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
> >  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
> >  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
> >  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
> >  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
> >  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:405
> >  kmalloc_noprof include/linux/slab.h:905 [inline]
> >  slab_free_hook mm/slub.c:2369 [inline]
> >  slab_free mm/slub.c:4680 [inline]
> >  kmem_cache_free+0x142/0x4d0 mm/slub.c:4782
> >  vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
> >  do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
> >  do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
> >  __vm_munmap+0x19a/0x390 mm/vma.c:3155
> 
> Simultaneous unmap?
> 
> >  __do_sys_munmap mm/mmap.c:1080 [inline]
> >  __se_sys_munmap mm/mmap.c:1077 [inline]
> >  __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fb13ec2f2e7
> > RSP: 002b:00007fffe10fae78 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
> > RAX: ffffffffffffffda RBX: 0000562bd1443f00 RCX: 00007fb13ec2f2e7
> > RDX: 0000000000000001 RSI: 000000000002f6d0 RDI: 00007fb13e9c1000
> > RBP: 00007fffe10faf80 R08: 00000000000004f0 R09: 0000000000000002
> > R10: 00007fffe10fadb0 R11: 0000000000000202 R12: 00007fffe10faec0
> > R13: 00007fb13ec42000 R14: 0000562bd1443f00 R15: 0000000000000000
> >  </TASK>
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing.
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
> 
> Cheers, Lorenzo

