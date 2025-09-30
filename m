Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A85CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A74D8E0029; Tue, 30 Sep 2025 06:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0584A8E0002; Tue, 30 Sep 2025 06:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88D48E0029; Tue, 30 Sep 2025 06:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D07738E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:54:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 625DEC063D
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:54:24 +0000 (UTC)
X-FDA: 83945607648.26.6F1CBDB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 01C5140006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:54:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dbI3cb09;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ioCBsjAA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759229661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFPLMzWAp4iY3q3lryDyPxM0JSfpGSTwqVA/CkIUDAA=;
	b=JxQm7SyLK576exdQ8OAO/6MQRz5a3YlhE6+rCppfcA165Goi2ZTaUK4440/fUf9XLa+EVP
	kRjRE6qw+v6flE7bhiR9U3hsnAPvnzlI/lKKQwCtyW4M0vBa0695kj7KhMAlKx5FHuVnCJ
	xTOXf/M1dz3NCqLDHAEdBQf9DZfkvNg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759229661; a=rsa-sha256;
	cv=pass;
	b=NapLrg0wFao032uKbDI5tepadvlDmiCIRgvpc2XVEmdti27wXI9wWaTuQf/CHZ1liLRuWg
	ED7QjOMQdKWQVQCCVNh1ylLJAJWlWeHTI0qkpEyPpExOWj2EIycrqiUvg9zxCWiICNgfxg
	mZFnJu4TGOxyQqHGJhYz7362gebiQAs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dbI3cb09;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ioCBsjAA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58UAdR14002528;
	Tue, 30 Sep 2025 10:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HFPLMzWAp4iY3q3lry
	DyPxM0JSfpGSTwqVA/CkIUDAA=; b=dbI3cb09FGgOY5YycVXoQxNgu+OiQrFfOw
	dn13My1c2VHxFjsmO2FGuSj8C9tu7UvaPZwalbFqAVwGDbrua/wrKt+n/McfD1Mb
	Z39weKLpNxTUHplkSBlYUUSjqRtDMQoF05h7r9K1UBUBeWZUmvkFLX+ykl0n5xEL
	igermcv+nDlz6cvuPKdRiGrsFBVyuRKPipvyF9U+r1/+7cUaXw9a3UzWuKWZuW+h
	GyFkuKJUpRkfx4KuZ8XTxdlDLBc9n0gQhYithXO2wprwcIQd0lX3c5F59OwrcwuW
	jg9gIBdly8JlRjgWS2zbYZf45G8yAeIKN6DWUxJC20N28HaMzLbg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gdn2g109-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 10:54:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58U8UG3t027037;
	Tue, 30 Sep 2025 10:54:10 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010028.outbound.protection.outlook.com [52.101.56.28])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c7n4bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 10:54:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUxxuhdJ6oDSoHPg41U4wD5UNCFyUpZhTCivVEAVyEi0M01FnXS58hP9cYO1fZytvmtOjIMktwLr6oVLlxHPgp1tLjr7mP8YLEQPlxspTsJxEYknkoIB8P5gIumu948U2yDYiE2YkZFl+3Nl7EuF466uicQHSIdMoBRGufHLvlSwWvoB4xxtGIiDHmzGusXqKhBJ0uAu7Nb8FHB9NOq1ZOA7N45diBpmVQpzjBqj8OM3p3EYV2RplONGZCUtYCYev2o9rPXtXIlkxLsBpNl1IgC++vrcnVDXgtVuBJ//ScO3gNtGxTk1lWC1jc9hH6FgV8CaEUi2u+Un2HBGSKwcaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFPLMzWAp4iY3q3lryDyPxM0JSfpGSTwqVA/CkIUDAA=;
 b=diFdKi4sUeRJ10FfTV9/mpprIYQR7TCEbPcWTwJ//a0aMlL4/JYo9QSctxdpTKEl/MFNNTrNDvTUxStILx/uYLV84WApzFJk6HjyZ5wJc1Rqd+cS32w6h2apEFsJ2B2k4Nh+bAiEdwyhqTd0xLQuowvDOHhYjSJ3mB9ycmJfQsNSgLaS5lIecMSzv+rgqD/eAY7fRFxWWcyulqWalyG3G64EQ85Gby0AZzaDJIqtcFfcsgR3oLFiWNEjjyTbTlwtdgvaLQPA2TA9E0tUhGkGx6IDMfrZ/8PYZ3vy/OhqvXTBvASuamoOFCdngueWceyuRuSboRcSRk4yMA0Z/EpASA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFPLMzWAp4iY3q3lryDyPxM0JSfpGSTwqVA/CkIUDAA=;
 b=ioCBsjAAM6dPArSJT6LJoKGV/QSLR5Dh93Ne3RfieD8fpe8l1B6OpwR+ryb8XSkQXK8z+eIlbe+m0W8a3omm6HToVFpPHLvaIZPllEZVeQl7U/gKXhrxAil9Vede2IiRSAybrGCos73jVnDQV9yFcYMATAYUZC6jn/HyggTXM3g=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH2PR10MB4119.namprd10.prod.outlook.com (2603:10b6:610:ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Tue, 30 Sep
 2025 10:54:06 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 10:54:04 +0000
Date: Tue, 30 Sep 2025 19:53:56 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: ranxiaokai627@163.com
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ran.xiaokai@zte.com.cn
Subject: Re: [PATCH] slab: Fix using this_cpu_ptr() in preemptible context
Message-ID: <aNu2xJMkEyYSdmW6@hyeyoo>
References: <20250930083402.782927-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930083402.782927-1-ranxiaokai627@163.com>
X-ClientProxiedBy: SL2P216CA0141.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH2PR10MB4119:EE_
X-MS-Office365-Filtering-Correlation-Id: e1deaf80-70f2-4eda-a986-08de000fabcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kewn2roiDPcirGSj66115PgiUK7kGInyKfJNPGc3hWYOUAHsRL500KftXg1y?=
 =?us-ascii?Q?ajGripicm+LuhmMWhE+Wp86q2+tlDbAws0+d8MpW0q8gawmlW0DKWOMmmyWV?=
 =?us-ascii?Q?T4bVGFK7j5LwiA4Hf1C/bsrROW8U63yANQjVN6wpj4XK30LNzJrvrvKMh0he?=
 =?us-ascii?Q?b5q/zpKfwcyc7HT6jXi/397gJCsYV9LPz6RbaHupb/yYyzabLex1w8fRpq+n?=
 =?us-ascii?Q?c5F1wqhwyP4/RqQXu8aOlrgExKCockxtQg8NYkTWKyO5xLjeC76jUNC5c17T?=
 =?us-ascii?Q?UmhB8qysWMRD8HxQ4sFY4Tfc9R1kptSl2HBXz0buQVREbisD/CAmLBDUrBOE?=
 =?us-ascii?Q?1TtsYQT41pjPJucv/JhuRVWL6nGdyW658RSQgUIR+wLP05YTgG3COAT/PIZ1?=
 =?us-ascii?Q?9T3lvfiSLq93B6a723JRp00IGShoQG2RJSnnREmbyIFFJlxmyLGMd20aZPX1?=
 =?us-ascii?Q?EHwE+4ngbQLCNvPHhEqhlAKqCAy2LZ78a2YD0yi9vjjoSCr9L7WU5yxBmBnO?=
 =?us-ascii?Q?V5c5KNoZ394efRqMyMCGYt2z9JyWwCpU2534Y39yrAgwWDiHwGeISWt4kSk+?=
 =?us-ascii?Q?Gnkemib/GP/5A5yqIQ81sMlAD7LhnCBLUtcnRfeWFYn7qE3b35eK/gLUsjzk?=
 =?us-ascii?Q?NX2clPOUxUHy9LLG0fBupUtJEt89iSW4G6QCojtrzUGGt5ESTToK57w3Nn42?=
 =?us-ascii?Q?k/fmVGPVtS8lB9vIYOcO/ljVeTXF1SOnd9J8764R2POUOJyZravHumG78GlK?=
 =?us-ascii?Q?lTKY3BvycwC8HT8jIMfpQiCUTFW7NER+Jw/44+Wz/kLYo+qqPClV+cWzwsnu?=
 =?us-ascii?Q?7K/zUxtEGyTHCY6JGSoprA0BgIOQNPEUWC6C57WuXRrd28pNcQqCJlQyIdEi?=
 =?us-ascii?Q?6Xuh9y2jvPysnxc7qE4ZI9Voa2oJ8apim8FeNZqkb6mZyn61HdVNlm0/+wH4?=
 =?us-ascii?Q?O3VL86kNpPbMY6zLikhCN11rDMyH6glnT/nrGeMChwFinQZI7WeTkhYv8MZJ?=
 =?us-ascii?Q?L0Kxd/eUuYoM7QY8uUpT5EGckFO0XNAXO/CHx/ksQJo9Vwu0mbOdrcv7ZyGH?=
 =?us-ascii?Q?eAxi0I1t54cMSCKUfxfDNc7dH707BGpDJhIkACWH2zoXxz3mk8iCLM8AbVYk?=
 =?us-ascii?Q?stNRrR9PKjRe+/YiHsOMbXRge3ZXGv+sONKZt+KgFs24HBMHBBpCzIdjNmVl?=
 =?us-ascii?Q?BkZTb5eKRLXNiDsN0b6Vr+MPFA3H53p2wlWEmOLSosL38OPrfingX7kMHsaM?=
 =?us-ascii?Q?qmHyyiJn57EAspDkaxNkslstPws6kLB4M7VO/goGUji+zL6LwF0Jq8OpOGFP?=
 =?us-ascii?Q?A6RtEyM9g2olZn2Ln1y1+GMVXW92SY8ENklJ9WhkbZhdw4Ql1GTYfCveZ/z6?=
 =?us-ascii?Q?Y9pRGVPHNtv5BG2JpJQX+xkyTq5rHWJf+piWE8j4S5machP5DLhXhSJq/nri?=
 =?us-ascii?Q?x7Zy7Xwg/a7mLy8LhvQZB/8R6LLJTTZC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+PeyEEa9lexM0krD5tTQSY3xRpel+0gF3TXknOMdzBzVMBVxPiqEYgDkoZM5?=
 =?us-ascii?Q?gblHM63kuv7Rr0Whz5cmyjfVyW4PsU2ByaxrUeUr+FO4bN60bKAeyCZYqkln?=
 =?us-ascii?Q?nob4nX1mr3EjEy87M5rSnAad/Q79YI2F2W5AWslz18gOtCi7Rco4JS8v/NPE?=
 =?us-ascii?Q?UxYbZqetVCXkZ3CWJgxMA16DR2Cl+lrrrjhdfXs97mi73ujGeWQG8iz+JcEd?=
 =?us-ascii?Q?D4IhUXMQH3d2hln3r+08UE0CKn1CZr73v4BNFM/iOu0eAatr6V0gqnNp72ZA?=
 =?us-ascii?Q?fOKPbgl9/iwevxJ5RG6YB+UkcvX+u5j8WIry1O8twplyFzhl15UVsvm1WaKT?=
 =?us-ascii?Q?cbANmV2UhSu3n0uqaHrn3rMRPuObYgSzJEGMbaREc8SyVPE6A15AXjrP2zE4?=
 =?us-ascii?Q?8bpdv4vRmxGoX2SEBhuP5yIbGR0vBKU5rOGXU3OdtaZV5dKfUnurd4cvd8BR?=
 =?us-ascii?Q?SufOMII2QUDN5UOkFd6rbb21g327pPuy9fF0UPh/TJOdh4TdB2V5v+MzJ13T?=
 =?us-ascii?Q?IPHfYxHXm1Km81ZRa3zqiOWm46l1+/uSsDEFndc6RP09jqyg34JY3Aet0EPe?=
 =?us-ascii?Q?lrvn6yr3QofgjKfpo3MtftjjmGbeFY201MvqGptWaPUCm+HSADqBAbNoFLpx?=
 =?us-ascii?Q?kiIU9sOvBAhwg6amSSErSaxKNT1UPds37eM6KecFCvvYk9+9Jlgpxgr2caMq?=
 =?us-ascii?Q?4C5vXNHaTDk5kr5c0FnkziJT8ESt48kb63AwI5KKwqvqUXursufDr2JPpylh?=
 =?us-ascii?Q?YUKv+6Obi7qPoUzFQEZ7IMypr7o7BIbJhL9suM8UZFWvKswp0xTUX+0pzQV9?=
 =?us-ascii?Q?2LZkCdmn8/87pjpDu2nEjBkoMdw8DJUU1jYiin9DvlDmeo9WjlAhx3ejIumQ?=
 =?us-ascii?Q?pPUh5MNxt2oGXd6lehNf8jFZes7/F+8Nr+ucZhbFUxfcPiZxksxP6xvar0VE?=
 =?us-ascii?Q?iIBa/oUZg2EJvJxneZ+UdwrCMvo+P3/VbXwA9szGbOgTpSL6GKc5kBjgoM7A?=
 =?us-ascii?Q?OHit35rM9rYie8/WMA84f9nn1ZfZj0bC8BvOQ+4LIN3FEjOyqdaHw/uTyGEZ?=
 =?us-ascii?Q?xh5RZGI0z5tvg9KFgVcrvLA23cYe4cTRb3SI8f/FXWUlb9D4MjSJnR9ZnS5V?=
 =?us-ascii?Q?2kt/PInH3tRu3/8cummm3mD2ozBH+dJgDKSOk0yftz/Ro1XKDNPXPp0aG5th?=
 =?us-ascii?Q?cEK3iYCAwnJqsu0qoAfDVraiOtvVPn0F7xTbhxKPmTnfRln1PmmMAK9twM9P?=
 =?us-ascii?Q?FcaPy1kDBmo/HLovhr4UzE72PC4K4f4QWJ9h8XjvT7zW7P0YVZnbJQJJYqkq?=
 =?us-ascii?Q?EEP8RKzsnIi0/cHfJ3IzQUDMGgYqNJwErtV8pBJzljXnq9u5+SpvVFc74YNO?=
 =?us-ascii?Q?wQMghvsgmeYpjC3otrwLLxmcudaLrGdYfuuJtnaWyrzRsNoW+0ECSCM446wN?=
 =?us-ascii?Q?a4A9xWrxLELAZz+/XvCdsfzq5wukmfjZgX7l6LrtUC+xXoTi3OmVldRFPS/K?=
 =?us-ascii?Q?sVZJpPG8ALba2Ict82gG5bJT6SIqTy9erEeJ4LByXjeh1b1z5LjxSXLRmx/P?=
 =?us-ascii?Q?O65tjiFdwJHKR6XGTUwBNxuFmwrPXDojY5coszXJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kZAjxJsEhbGjh6/m4GMY7XtG2e2fgYc8ofVt6jA6dZRY+cssL61uSb3LnDJXpp5t3X6xQWMnVqWg+3PwL6ca12W1/JKNrc4vxwxl1i4TnkK33/+gFSMNU3ukXt23w+xnOnsaLk2F+cWW88JNaLyEEOD4PvL90mgRnPNiFkZolDyopBpOWBluFNim3M+a41IkXCQbTUGEseFPLS650r4NMYOVunoGVVnVqxh1jAgOsmPnd+iPwl84Er+TRLFArZXt8MeM9na3U2GaAHsmc8MphO5e47Oo+XHsocgysTv5YLWBcwJYT1XWd9Zu8X7osnX+nnOay5YXLqCcu/H4T2NbkZscZStYrhNfofcW99W2ISZK/1KYJjyoLV/YNAlswwQ9KR1ld57qhPpMIM0DuicdgtaxIhwlzPsX04TNPqnoZdB3Zi1q2xiw5foUMbqegG8X6dkMlxraEqKQGfhD6kIT8vC7tR5cahrX2IRPw+a7tAmV3RzZBsUhejypLCHAl+bKQptfAj6/slBju4tMfR2N+sGMHI6cP2Mncu9DR2USHICQaTB+jPjzsxW0utlDKOMl2llPc8j7Z0zHbEI7REOhqgiXcWXzOHQU2D64N6djKXc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1deaf80-70f2-4eda-a986-08de000fabcc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 10:54:04.6192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuvRvPtUJ7rofUuHtMg51/JFfgO7z9zp1vDDvUgmP8MjS4x1V24FThdXRz5ZfhttIylv0C2Q7HIvfGqOcicPcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_01,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300097
X-Proofpoint-GUID: GCdVB0AnNgG8X6Q7uNWvgUbm8RMTfisF
X-Proofpoint-ORIG-GUID: GCdVB0AnNgG8X6Q7uNWvgUbm8RMTfisF
X-Authority-Analysis: v=2.4 cv=JdexbEKV c=1 sm=1 tr=0 ts=68dbb6d3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Byx-y9mGAAAA:8 a=1RTuLK3dAAAA:8
 a=iyIyYx8JP-pYJ0xQ2oIA:9 a=CjuIK1q_8ugA:10 a=kRpfLKi8w9umh8uBmg1i:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDA5MyBTYWx0ZWRfX+eHpguBBp+TB
 3o1p3VbOqwUxn/su+5EMZixuM9M1HgwsgMqkNufwzeZa/X+nnKaBCnbt5dJzztXtXb2SFJE2d17
 mgsGS6E6QyPhncoEK9FDtEsWuVAGrXjBqq2vN5WF5OX/3oTKpg0SpaYqkw+F9ROWDAeVAHUXmVk
 25chu0YXwTXbWEoF6LUPZZwe6nZV8AxD0B9rmUu7D0fKPrM9GMXX3PGxDIAwcilKxjCdIk4I110
 rUUbk8wHrLPHT2S6hWF/a5r/Om574Gh1F6tgpRhV/0VIrljIwaC9XhfwXBGI62oi+O6QAb/+e6d
 N5iU5tYFQje6ZiAczS1WzatYZb+pc89RzktwFVIBDqOD5W4jGZWrFnHwi9reM47LCimpMH3eyHP
 tdRRV9+fF59TdTrkRMXU70hdNYAJmQ==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 01C5140006
X-Stat-Signature: n7ydk6587f17xyatpmjqd3t4czrkatn3
X-Rspam-User: 
X-HE-Tag: 1759229660-760606
X-HE-Meta: U2FsdGVkX19muglssuXHLpYHAc32SlgsIsZ5vjTSnbpLvw/jhBR20gGWvX+2MhIMkBm4a5WSl+7TFIwHx9CUV4foHoMh79kkXA+txQC+wByZttMcUcL7E9fsGdaq/QD1J7sZZ25VDEgOBRWIqMF74KwhkHghr9OBtvn7DmMQqmuBJ7rDakGqDmtZF4m99ii9n+tHueMCFGQL1/5mmQc2hdNll9Kmcmm3q8SmbHvcUfPWgihKWt+FkX1F9O/yo2QhPjV9Rct1bI0NKyqXopt95O7fauZRitm9K9dYPAJwx98m56V6X4kRvHlQQZK2WBVwbeZOKqmHJ/7sNWTHGH9ZfPmzKduL5pOJU8vvhBkbw54zKrZ+AArVPhD9OFcyNdgDaKcMGFD3twpxvtuajExhC1HJcwEykicRPAqBOKl0u6HrTcWxLwXPbn+3Qxzujch/ZdrVM9Twr0W3GFQ9/vp27buru8aMV5OyahTg3Un0SVky51cSe+d8+HmeiMQh7YRl9O5atwqA8rZMDZotPE+wLnXDwkUgd/Z4tu0RidXFyvNMuM/vwsdAwC/4Ga1KyMJ6PXkxha+ttuI7jyP3PAzGtVx9m8/MZjGc5gtC9rYc321lUG+xVBW8d9/Dqdlqx1CSsnYdFUxuMKIb+E1tp5QjVFSTsTkYG6l69xnPxhPOlqE04ChxihKboLn+QCcx+krDd/Hq283Fvh9XDSu9bTTsDVqTi8EvO/TzWfI3HAbGzed6Q1s0etFkMOHTf9AObOz/gsn7+QAFXTRnAZNNADOCCGdoXyQ3+mLPHyA22WyMmP7l6/vHEd1UoLqEhDY/dut19K1cyRsQ+KgGC9Ywsi7vibzxhlw+l/0RVAez9g5mudoth6rRV8aA+4GAzQfUR7j4E3H3bpAN8XJ0wI8F4GVECDbP4NteIbz6WBO1qxPLdQO9NAw4YBKBkm5ezMgnUcBAP+3SBu63MIUg/lmnQ5n
 gG9kYfNd
 umH2x+IjYq904zyiiERIR65WEnBzElwXSOcXu+nQHOjmTJWQsM2Ew64IsMPFrdl9fP8A7mj8QNJA9EBg5fWp8EkyRzCNWX7Me+B7wifcjHKodYg8cG/wWkHClgF1WSeBLIPmD2P1o2narsJToXi7F+h75cWABvHHyFsFsVRZ9OqS1rg8/ekj2NFPwGfCpaoYPi6kc/purkJCx5xuwvvObe7FkVyC9wogXH+cOabEOWHYwAzqjrw2HQXPzBqoPSqVqh7a1I1IOfcOoTnw2tcr4jKoV7MEaW4qEzVikFCQsW7Lp9hs4g3nZu5DcLrv74BSesN5+ITXZakx48kQM+YMoqq8Gg+yOZHtM2Pqg7HlT590o1ihX2hUyT/FczchRjSnNxx+qMp2JZ4eELxN5Fh3+mzHXfbI52Zr8n1pHK+HP53YB/QtCoKalPO4+VHIgoed1E7RtJ5uB0+idgVkq3bC3yjB9lrR4Qvw2RX1UK5N0ZiPN/k81rNsbLDoqxQN07w5IBfLlggia32+78fhVOd9QsM5bc89YmnMOGmiQi8sbvffRLg5Mu4iu9X0ZSq140nxnV1sgTFMWcSMc0wTKQh/JEgTc9Bfje0GmJSK1uKv+wMQXMRZWTUXLIJA5/DfzIfDcOtZBALWDLFCy6bUDHgnjgX3DRq6qMRk2+j1Llk93NWNn8fli8Xy23KL8hf8gt2YxjQ03SE4kUbskNzrGIcjVpUE84aofhP5ifstI2QQ2XJhvHtYDGZMQIg1+GBA2dr6uvq/bGOn9vfc7sBI3mf3jmp/tafJVdqB2qMIAhjFxtBlh0tUnz3QMGE/EkS3XiK8zThoAl3zbSDmLznZ6hSJ9t4r1Sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 08:34:02AM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> defer_free() maybe called in preemptible context, this will
> trigger the below warning message:
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: swapper/0/1
> caller is defer_free+0x1b/0x60
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xac/0xc0
>  check_preemption_disabled+0xbe/0xe0
>  defer_free+0x1b/0x60
>  kfree_nolock+0x1eb/0x2b0
>  alloc_slab_obj_exts+0x356/0x390
>  __alloc_tagging_slab_alloc_hook+0xa0/0x300
>  __kmalloc_cache_noprof+0x1c4/0x5c0
>  __set_page_owner+0x10d/0x1c0
>  post_alloc_hook+0x84/0xf0
>  get_page_from_freelist+0x73b/0x1380
>  __alloc_frozen_pages_noprof+0x110/0x2c0
>  alloc_pages_mpol+0x44/0x140
>  alloc_slab_page+0xac/0x150
>  allocate_slab+0x78/0x3a0
>  ___slab_alloc+0x76b/0xed0
>  __slab_alloc.constprop.0+0x5a/0xb0
>  __kmalloc_noprof+0x3dc/0x6d0
>  __list_lru_init+0x6c/0x210
>  alloc_super+0x3b6/0x470
>  sget_fc+0x5f/0x3a0
>  get_tree_nodev+0x27/0x90
>  vfs_get_tree+0x26/0xc0
>  vfs_kern_mount.part.0+0xb6/0x140
>  kern_mount+0x24/0x40
>  init_pipe_fs+0x4f/0x70
>  do_one_initcall+0x62/0x2e0
>  kernel_init_freeable+0x25b/0x4b0
>  kernel_init+0x1a/0x1c0
>  ret_from_fork+0x290/0x2e0
>  ret_from_fork_asm+0x11/0x20
> </TASK>
> 
> Replace this_cpu_ptr with raw_cpu_ptr to eliminate
> the above warning message.
>
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")

There's no mainline commit hash yet, should be adjusted later.

> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>  mm/slub.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 1433f5b988f7..67c57f1b5a86 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6432,7 +6432,7 @@ static void free_deferred_objects(struct irq_work *work)
>  
>  static void defer_free(struct kmem_cache *s, void *head)
>  {
> -	struct defer_free *df = this_cpu_ptr(&defer_free_objects);
> +	struct defer_free *df = raw_cpu_ptr(&defer_free_objects);

This suppresses warning, but let's answer the question;
Is it actually safe to not disable preemption here?

>  	if (llist_add(head + s->offset, &df->objects))

Let's say a task was running on CPU X and migrated to a different CPU
(say, Y) after returning from llist_add() or before calling llist_add(),
then we're queueing the irq_work of CPU X on CPU Y.

I think technically this should be safe because, although we're using
per-cpu irq_work here, the irq_work framework itself is designed to handle
concurrent access from multiple CPUs (otherwise it won't be safe to use
a global irq_work like in other places) by using lockless list, which
uses try_cmpxchg() and xchg() for atomic update.

So if I'm not missing something it should be safe, but it was very
confusing to confirm that it's safe as we're using per-cpu irq_work...

I don't think these paths are very performance critical, so why not disable
preemption instead of replacing it with raw_cpu_ptr()?

>  		irq_work_queue(&df->work);
> @@ -6440,7 +6440,7 @@ static void defer_free(struct kmem_cache *s, void *head)
>  
>  static void defer_deactivate_slab(struct slab *slab, void *flush_freelist)
>  {
> -	struct defer_free *df = this_cpu_ptr(&defer_free_objects);
> +	struct defer_free *df = raw_cpu_ptr(&defer_free_objects);
>  
>  	slab->flush_freelist = flush_freelist;
>  	if (llist_add(&slab->llnode, &df->slabs))
> -- 
> 2.25.1

-- 
Cheers,
Harry / Hyeonggon

