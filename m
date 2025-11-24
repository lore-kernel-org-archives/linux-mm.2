Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA07CFD2F6
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 02:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8026B000A; Sun, 23 Nov 2025 21:31:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F8C6B000C; Sun, 23 Nov 2025 21:31:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66BF6B000D; Sun, 23 Nov 2025 21:31:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93C666B000A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 21:31:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28349877E2
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 02:31:33 +0000 (UTC)
X-FDA: 84143924466.20.A132E77
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id B8AE3C0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 02:31:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WdGMZufi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d31qZzsr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763951489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5KN89vFVpH/yEY9wMA+XR7hV/mrx5ykmvjMcoo9GdI=;
	b=tz+C0J4dExILNGtYuN8BfnRuQzM1MoiOFzbPJ0XYor9FyjZJOsTBvho2EcDBU5Y91M366q
	CMekQlVa8ceLb0wUzV8fUMzgqPwvvFqqU6mk8FWgW6D1vo62yqX3KX3pofLaAsdtHhomlw
	+0kZeOQuKj7Ldgd5TfuRjsgScLCnMh0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763951489; a=rsa-sha256;
	cv=pass;
	b=xkyPjf1S0rVs2oDzeK8WfueLZy5GTuij5Y47THc5mV6ekK9/G3vVZ8QO5eJ6E8Civ2aqji
	SiGGCgn7z8UjNTGyv+ddwxPoKG+duwg/BK8FnAT2HEMiRyqP0zb9lMzQu389AWvQF+ooKE
	uzlKFfv+jvGNKbZT88Cv087XdzrwS0M=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WdGMZufi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d31qZzsr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO0SQQW4045323;
	Mon, 24 Nov 2025 02:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j5KN89vFVpH/yEY9wM
	A+XR7hV/mrx5ykmvjMcoo9GdI=; b=WdGMZufiFXmyHCjt82c/DLPuPXfiqJRXFc
	WrC/4bKee4bOYQfVXbNRu1vmYGSaKum5lWmtdLwP2OhWsJe97eo7GdpLgeyqz1Pm
	afD099RmG/DyjJaAKtwvTQkHw9Wpo2AmSzxkpZAMLJJSCIqiH32wfZO3srXxD2O3
	mbsF/OYLn6V7kPSrI5CbeRMz2FxTa6rwqw8/BEYW55BpfXx4XzNnVPrz306KUHEH
	v0rfpszWFBAAnKa1Bl+HtvQDVk+Vm+Ue4Lul9T77B6U+MdVcF4/mnsIgYlOdGVR9
	S8jceuNOwOATjPinU9I+ldN2HiuW+6NLWFldjNL4PhEMnDMJ0k3Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fk985j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 02:31:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO1qMcn022243;
	Mon, 24 Nov 2025 02:31:18 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010041.outbound.protection.outlook.com [52.101.46.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbafc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 02:31:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s0iVHP/ArQyVIJMReNtDwIYRjHkOzTZr2BeFEBYhSp7m08RcxvLHNQi9yJr37tKjXMS8bt2j4mlBB11DNlKoSO6GEDmJ8HngNerIa5Ip8MSY3obVJ8ivL6DgD23baxe82KOL2a2a78hhljq9yfVqmZXeR8mYciQTAmeex9n99hHB3tsWPIzqxHgy2WnE2MVgfJJvZmg7gG0c4YWYoYik1WJahIhjpLJwGreDXu7FTidIZ3SkL6dyrXDgLfjfzx31rBRbvkoWXnY56xAhhLgrUXfJ2YSzZ9vMKlvfNruUuEq6D/t5HtLgt3xMDsu/Px9xcNS0P0f1MQPlH2mqGW6xgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5KN89vFVpH/yEY9wMA+XR7hV/mrx5ykmvjMcoo9GdI=;
 b=ZehkZSysGzzzil+ss4qTz+3Aitw70qmNFkOVL4WcyOYbgC2ydhhYjzigEy+bGgkgcb0jHWtMe1TQiIDEi5DVnou7NGYXdylKcSDazCm0akbkDOOwb8AqG7+MFrGSq2DtPou1zR422angmtWW9mZh8jwvmVI0w2vZDiufJIittXFTYxbOwhFdcIdN0AOfIT+TjMUvKQDL10l/RHdVOTtv80SKW1MW439tWaBPUzJ1VbKhl/ZWQqa8lI8kZy58cMJRqCkCeWp9KqnAymEmsToiRjdJc4UNv3MpO0HvW6kvP0ZJtPKnyzsLXE1GfMkNJRMZ4iZr65Qqo4YgOCg1lLqbdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5KN89vFVpH/yEY9wMA+XR7hV/mrx5ykmvjMcoo9GdI=;
 b=d31qZzsr5ywqQk3W4XJiBs4QazBwOldXvKopc96BTSLeMSRAGLNl9OR3jujDueSHQYzMcnH84yqQERBWxb1Bjn0lwkd1/te5MJyGcUJSSOMUb6+yXZ8Ofi2snxVRgqqMc3xfENShIfWLNy6PDoQ8WB+IOx3q5prgFQ4w2mQQCLg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7621.namprd10.prod.outlook.com (2603:10b6:208:484::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 02:31:14 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 02:31:14 +0000
Date: Mon, 24 Nov 2025 11:31:06 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 02/16] slab: Remove folio references from __ksize()
Message-ID: <aSPDauAEYs_RVNW1@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-3-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-3-willy@infradead.org>
X-ClientProxiedBy: SE2P216CA0109.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a0f59c7-497d-4d8e-4a10-08de2b018a1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LVsg1eWTYfXkidL8IHxedksQ8vJjMO7R8T4xiqOII7wfomLVIbXa5vfApkBU?=
 =?us-ascii?Q?s9Wo8MqI+ollVwacvRXE0kphPlgeuUemWYmATGPQPj18aUHtzCaRTR3jjME/?=
 =?us-ascii?Q?YFbB4w7FrYGfiJzMXxXEG9vP7uFunuySRtjBhzYpHh7BCz8IOzURO7j676RG?=
 =?us-ascii?Q?KemibOty1COyKOo8gK7mWsR/uMAloqmNOejCtuDVDOQU3TdSa3pnRSr0ahQ/?=
 =?us-ascii?Q?j9SuMcYuSNJRJwyyjrKvmiX8p99EbbzzdN8HwZ8hNhFZci096Zx0eyytDIfU?=
 =?us-ascii?Q?hFRpjZ6lNwxncFYy0kDoIFBMmlxe3pG0zmh13ZxeBlfauMSq4jexUq1IxKj1?=
 =?us-ascii?Q?qoiM0I3WEtn/nksfwy75FperY4LSIS7VeTwxxC/6/YRhaEpKTOA+oQgG2mxC?=
 =?us-ascii?Q?rW/lR5T6GvhPbciFX2rP3slq5KPchJEkeMBJ4qXlab0+6SqQFx33+2gcgqRc?=
 =?us-ascii?Q?nzDGwK6lh+oDjUfhRfEeBwq8unjjs9mPmmgbcviNz6NHiVGAbwUt2F+CX2wV?=
 =?us-ascii?Q?KfJeyKQsytQXAF8gk4BM3wTahtCbJOMXl95bnNYWw0t8BTTcZrRUcT36kA1q?=
 =?us-ascii?Q?rQDFJhcDmi/Jovj9qP6cDxttNVPYsRSGJYek2mWXdAH6kbGKNZzsL0gPnaON?=
 =?us-ascii?Q?xbAJptGXk/FE86qu6vfmU3f5x3aLSv/uz104GIA/Iimuplbc19WKGIxi+ZTD?=
 =?us-ascii?Q?XNJA45Im6hgfCDr0ECvnqQgjo9/F94jMNug3964mmNSUW0kfifOT+vKxD4d6?=
 =?us-ascii?Q?3lRVpcL2zntsFXsI5es4ezz3R+M9rDkb3GQ/aWsff+kWgIs0LKmZcCbDvK/m?=
 =?us-ascii?Q?nhfNbK/PBPccunOMGcKDob6ZteQg3IVl/Kn9vZlqlCR2ncaHeViiLpOwWxX0?=
 =?us-ascii?Q?GzrrBj9eKfRY9Bhsfr4Uo+Q6ueg9UUbEO2z7VkSjdosN6Xg+eNnoWPFLkBp3?=
 =?us-ascii?Q?N+11o6qY0mYOXOwa+hNcXqqVNkHW1GL6cquDjvoBuI2K+MzbaOXcZLJM/UQD?=
 =?us-ascii?Q?p3n6N+qWirD8+H2oXMuXO4Bhqr8qK1W3TI0oZN7M9KfDJaorYJ4/JRU7zo5+?=
 =?us-ascii?Q?w5kRwO/87tiV6/ylshwJHSaySW1109OvvRiiDsDKRH4KCbzhuciSFf/sflFx?=
 =?us-ascii?Q?jsImXfshf+Qd22vItVjzrl6fF96A41XyB0zW/e9+kUxOWAJ/VLjUGKyUbTF3?=
 =?us-ascii?Q?idvt2jbS6pPW5SqNt8jnziGzbokxPULqxHChBcMzq/6g2yQnSySdCa7alK3J?=
 =?us-ascii?Q?YGGQBFaOHmGI1px6Z4yRbGJFCaP0NLpAw0mFXxJB6EoIBJY5otPBbd7XoPti?=
 =?us-ascii?Q?HsoOfntDhkSbZ1qmBkZ5pUE9ZBaGXPw5bTHGDIGfabMU/TkQoXNeK1mqpCLq?=
 =?us-ascii?Q?FQTnnucHBvgalS8xuSDIla3zrxlZsWEH6oBfex0VUoSxmaU6Q1HnkXUWBl3G?=
 =?us-ascii?Q?dziPqSqFO3h7yKodQYiOQ0vhQ3WHGACc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MUcbzLfNSPWCGrwXXMjCOFYhNJ6r0hlEYSya36fk2+0WSTYY/qLZhYCUGKCa?=
 =?us-ascii?Q?XL1rti2wVHbhd92DCUiDtszzWXQq7e+drKA8SokP9YwSF/z3ryhQcwGjmSIF?=
 =?us-ascii?Q?w+Slm6bqGrim8j3KVszzZKJ/tERYsya/G4socd9Bvt6lq1wVw1lZ+ojR6qb5?=
 =?us-ascii?Q?brQzYAw6/FDrYtWQypxTGxm2gfE72UimaaZ3XTC+26h0oisbproRHVEmWV5O?=
 =?us-ascii?Q?KFndgI8Nj/jr6r4T9He4uXsUHrlKcDHlivY11yuIRGXdZ0xMuXXmGHNeuIBF?=
 =?us-ascii?Q?gTiuMKoIZbVIzZPibNMO4Wiw+JlbbxplHcTpbxfolmLiohgfAZ9Em1IYcOhX?=
 =?us-ascii?Q?8/+zIbShr/8VYbsKa8t29NHgFupJoSWi/x0miMIqTDW/hR8esTY7QyZKvm2F?=
 =?us-ascii?Q?Kg31brglerN55uGv7z7k0+mqJbiZ12rXOfDqZfngDDgwYQoJivuwb2pHP967?=
 =?us-ascii?Q?JV132Zgnp/8XGIx5mE3FZf4ZA/twxRXFPyr+nMyFq/Up9c5uGPBiGlciBfth?=
 =?us-ascii?Q?TH/0bY3RLUsJAhq/3WJDB0BW5Kk03MFudT4sjI+E6EBlpewXpZ0b2Zcpd1yW?=
 =?us-ascii?Q?bHz3+j5bWDFdTP3GGe0muacQIGNntMeCdRdPjfoyPGHrJDWDuvshMxQTrLd4?=
 =?us-ascii?Q?ElTy6MHYKOaWu7oRFlBp3My3SWjBZq3DfKOMnt+WIZOBY2qQ72F8t+r8b/XL?=
 =?us-ascii?Q?JfcDH5KBWi75EmvZxC5SgT1nsV+IK6yMN1qLUd5jE583EHwKWXjAdnq72nng?=
 =?us-ascii?Q?3rXqRnViARSxrqHpq4j+kCO+WeGUOXYQMhykRFyG8h3Rz2XD+3Ql+i2gmnte?=
 =?us-ascii?Q?Pz/h6qQlZoWbdQtxf+xemvHX3g/tQso54t6uqHc8icA/6MC6A1WzKW3cmfGk?=
 =?us-ascii?Q?zx+t2sV8yDK2UI+TWtJjQlIsAHY7GGjd6dHnmx3Xh/DJf216YFiY1B89fFzW?=
 =?us-ascii?Q?3JVR0iOlCZY1hGzLxr9SgU8YaOI5jFn+IB0bD1dkWcbFStReIfQwNov6P8DH?=
 =?us-ascii?Q?4B5LdKJAfmpTHdEVhsmcSHzCyIXqjPoRiEHZA9O+DkGiki8tYhpKjspy0tqb?=
 =?us-ascii?Q?F7ImAkxxCzC4I8UojIHOjQcZ5QDPwj+CGG8IAfUdDd1qy49NsbvXmBhwRl0t?=
 =?us-ascii?Q?PLA10kfYgUTOWrxYbtRMwDHDxw3JrnGSBSsbHycWpnmexpBOIHRackPQ9usr?=
 =?us-ascii?Q?/qj9uCwj0AU5/bJjWO9taP3ssQ1NamsBmX4YEPK6Z+wqg+ysF8ggcLMnhfxy?=
 =?us-ascii?Q?35a+0eeitWZ2O2ZoceBNg5oV4RsDoR5RbdEOEnPiAy6n1N7t1w1HKVaGbfO6?=
 =?us-ascii?Q?7YMu4Cq2i4hcVIPrOP2WILTymHW348u8zR5fDXL0pE7qEu9M8+QlsH8L2+Eb?=
 =?us-ascii?Q?FYo1JG5gePV1yqivhBR8kvg+Q8d/03LAJCJpOlLwlvnjz5htsoYIOvEart7b?=
 =?us-ascii?Q?dIuDvdH87u2nCBwy/CkaNAMrR+eKzOAPktIo5VSc5qkx/5KB1kxEVvvAw62y?=
 =?us-ascii?Q?edpvWgoeGH8UKV/6Vwq1jco8jbPaB2Nvodo8mXlc3sa3AMyRv3rz3TtSAF0V?=
 =?us-ascii?Q?UDcpX8VqHuqbIUnYQm1pf7diOe1x48WWHL8JyHaT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HAYxEe1QjcFidHSKREY8ZKHkLHH+5Kxm/J8troAVjI1sl1vB42zH8grWo50bXtrQ64FWVzy5jy5/QkQoypyilLOxqf1EsQ1M/5o7AnDjhxWSL655YhnXWdKsdlH/hfmWxG2QFawzZguzHUuQv29oXQ8ESJBG/IbIt7xepTODDFT2vc7cHS8JxL8qa0DWS1iE83qaUVfsCiElw3fOo6lBmTanMcOR4g9eS7mYWObrhO/eOIU6e14kB4ssis0jrtuQTRIakfLZOKPrTiZxkJut8Gy/EZtAxWqUIdo64G9Vduo0P5JmB1WnQOgnwBVU7DxmNcaA9PjL7vqhr7g7nkkwiFZv5uMHqqsbcWOSo+Ze2bV/pEx10YbqXGOzO+HfHFNMz2mh7NEQbbVf7JqjfkwnqB8bYSdw8r1JuNdMvSDIfQSAkL4WNYOoBw47tonePJ7Y6c5hHg8Sd1F4KrPvSaRs9eLumJ+TAgJdj5ScdR/Vzyj29Kek5MZysN6Az7gIrnzwslH0DNJf0UBO8RH4MhF5K6fNUcQfFohIgTww5ezFzQaTQljYGcYDKFcDdKeNH0kyY4dqGf35ihpVehWeJhb6zd6BDCoVwLQTUFIDcenDelM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0f59c7-497d-4d8e-4a10-08de2b018a1d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 02:31:14.6856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWxuj4DbNObqbsTbBFV1a+K9xIbHilJDPGU/5mKG2HG0PNqB+sWrqPdr6aFB7+Rrlz5rGPx9cgdP3eh8Q6teFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_01,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240020
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=6923c378 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=QsjYBvGgKg2h_TAeJe4A:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDAyMSBTYWx0ZWRfXw0lx6khNAG35
 9XIP2bjoHUSUD1FPQlLRxByzEjXBbJ1UhM4qkt3uSAv4O4I/z4DcS6yDEuDUFLgZd36R0KIjQvI
 oOjsexMg+jdbvPqRFrKq6BCay5FkBdR/tGIKFxPnpr5drX1IBF6UiB2OHyNBPU5+SziskIyu/4c
 7u++fMezjwUME9KkTTA8DAFtFYHLS+lvBUSOKaX9z3UfPWrR0a/FwfEzHZkeP66HEunyTnbygTu
 WkAmDXXqlIJgbgpMwibDNL6JUpLSIO/4RAm11Tk/yGJ37FftJYKfmdLqnNjj1BGWepIXcNDDQp5
 GPxUfwtiEra4GbhMlMzam+I85hUG20/9m9pOHQvodk2TjqoF9Ok2MV/Bp84B/HjLJcLCfiAY9EC
 BmUbYAxy4tkBaY2SO/9TZUIQCafHoYiwh72ZRBVVzQMYa5IYSBw=
X-Proofpoint-ORIG-GUID: wV6Hc2Ox2sYUuG8NizVayUGet9gd_FHQ
X-Proofpoint-GUID: wV6Hc2Ox2sYUuG8NizVayUGet9gd_FHQ
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B8AE3C0011
X-Stat-Signature: rg3mue4fsrxhewqz7r5mu8mthgabofsi
X-Rspam-User: 
X-HE-Tag: 1763951489-43980
X-HE-Meta: U2FsdGVkX1+SxDeH1V/rzVnV30fKmLFsKFYWcOb40cWfQtZAoW8TFLNmXiOuKI7jIfbxewq8QHtvf0SZGcPojcASPcWpJftClAcxcROxCIG4YR+JLZXllKi0jtfQPaj/382ARDkdTFZ7frEOXKHqhX++DhTCtH3V6eB7hs6QePWrMRbQGYJIlDEM0XMSTxk+sQmQeNmyqmM6AULEiC0EeoG4q4QwBjj1ZVcOLHErVSuwW4UGG5thonHYwL3Fx1DzoiAqoG/p9UH8ehRQzJQ+wrFuf8wZKD4gwGRfEuvoqoTvNGMJK+zuM8GWOHr2Cqz8IF4JyM4Wy6DFclwiDBQ0jgP9agmnoOhZL/CY1/x+sHIUEKbYOAJdieZ90+GKUtTW2W2hZEPLImpqRCCj0MBmgiWkLTJ+M5vorRXdUs3GOUJvXwIPkiFa6tuGXPuFW95nKBY2k71lmiOXh8bYubYc3xJeqaFn9PBHXMaW0XKqfB6Lrk1mREURNwzJZ+KAPzgPQsJxSQ8ylsbIJ+o6tggZ+H3Xqx4FXQKVPlchyQE6J2C2acTRU+y8gZ96zt3alMsR9/7nlYbrjRU3wes6hMGFCnuKqxeejT5KH6L9TS9GfQkK20EF1yY0kmlOpD6/165DgGzh7ULQR3Jfkqh4gi+2NLLL6sOKxIUiszjlSfwj5kQr+UN8tmJqYld26chOhUyGWnrB9NyBKenjursvKI2neBKsdoUT8rnsvSDub571NtQe1MPCectq86d3lXu5Jk84X7O8Vf0iFTwHob+6DCK8NkFqqn4Fvgcq2F6R8kS+PykhWngfwq0l+fpNnNdMTUzP2rr3YMD+zB1tKb9aFxW94SuuogWH5k7Ilk+NEm7ydyuujAxkqM1fIjXKkJwC6b0uDc+jUeroiCgc+c1/vy9Wp9LX2/CAIjZ68rBMtTPyQP9hBXecuofJ8E2ExBMaA/X67O9iWwIdpSclZpOUEa0
 mIbXzai5
 E9oDJc7eFWIeOm4fqiOlBm6U5UcOMnDECxnirsNyleEjDUAmVOhy6uHMHDZPBR17NtADhkkxiVNLoriQzESESslNDYBjshDVefxz0h+0XdNd1dfAcWNPlz5T45kBxJe0prBZ62XD5l1yj7IgOg/9hE313nX+Gx9CXoGANZftTifvqdYCz7HLI/wTuiqf0z6T6CEMIFFVSM6oY9/0MVLiB+nR/g31p37dCLF7XT2bxQTA1Q8cGEleBrsxSE3rfxmbIagLTBwy5fMbRhFmlPXFTS5IDbfZyxSJ5wUnnAimCZ79kfzg/RsjdtXDa4gUsiXd4rzvH0G28wdG+hNVEUdFQsz1UtHYAPZjQYGoEnpE0Bsrb7xIzPS7Ka/mVE1yjEIgt+f9e5My1Kuqb+Z/1949BUTYUlZvsQAHhPo13w03Mje06UCNzmCoVYp7D2ihqMy3Gds1Idxpro2w1HH4xgmYngDMwH7BERN2Ye/BqnuWDXIz93XkqQSmAvVKcIJuEVEv4Lpl6GMjfaNF3gGnZOPl/H1AtfoFGMMTAa91i4eC/a1DHytnwCktI7XyfM3Q+cqSMj62K5xN5hnXZZmCqK76RUx+uFQ/cw0KFJAF2KL4gOqGkwYSqslHYKlK8G0BiTx0WswSpXAgMQEfgNf+vH6UrOVx5wwlzVCZWnLBXyGLKBMqUvg/FzjXp8lpGtqsEXLYHvxELx/v8wb3Bp3s/cwHicvAaZQRq3YVQdn1LKSZwXuE3nzJKFrMeiGelPwXl6cNbpdiHiN8iDAkYVbs0A+MWglENmzciTYUtv+eS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:16AM +0000, Matthew Wilcox (Oracle) wrote:
> In the future, we will separate slab, folio and page from each other
> and calling virt_to_folio() on an address allocated from slab will
> return NULL.  Delay the conversion from struct page to struct slab
> until we know we're not dealing with a large kmalloc allocation.
> There's a minor win for large kmalloc allocations as we avoid the
> compound_head() hidden in virt_to_folio().
> 
> This deprecates calling ksize() on memory allocated by alloc_pages().
> Today it becomes a warning and support will be removed entirely in
> the future.
> 
> Introduce large_kmalloc_size() to abstract how we represent the size
> of a large kmalloc allocation.  For now, this is the same as
> page_size(), but it will change with separately allocated memdescs.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

With a minor comment below.

>  include/linux/page-flags.h |  2 +-
>  mm/slab.h                  | 10 ++++++++++
>  mm/slab_common.c           | 23 ++++++++++++-----------
>  3 files changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d2824daa98cf..236b4e25fce0 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -997,26 +997,27 @@ void __init create_kmalloc_caches(void)
>   */
>  size_t __ksize(const void *object)
>  {
> -	struct folio *folio;
> +	const struct page *page;
> +	const struct slab *slab;
>  
>  	if (unlikely(object == ZERO_SIZE_PTR))
>  		return 0;
>  
> -	folio = virt_to_folio(object);
> +	page = virt_to_page(object);
>  
> -	if (unlikely(!folio_test_slab(folio))) {
> -		if (WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE))
> -			return 0;
> -		if (WARN_ON(object != folio_address(folio)))
> -			return 0;

nit: we can still have these sanity checks even when we're not converting it
to folio?

size_t size = large_kmalloc_size(page);
if (WARN_ON(size <= KMALLOC_MAX_CACHE_SIZE))
    return 0;
if (WARN_ON(object & (size - 1))
    return 0;
return size;

-- 
Cheers,
Harry / Hyeonggon

