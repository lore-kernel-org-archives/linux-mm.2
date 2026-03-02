Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19956EB3622
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881676B0005; Mon,  2 Mar 2026 12:35:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842966B0088; Mon,  2 Mar 2026 12:35:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7042F6B0089; Mon,  2 Mar 2026 12:35:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E44D6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:35:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15C85160229
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:35:08 +0000 (UTC)
X-FDA: 84501823896.07.D1B3FE0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id A8A3914000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:35:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="n3If/7du";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A1WqFnuh;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772472904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHTxaBT9ppevFgUrRSSm4P2BPQHs1E2evifX/qDwPOU=;
	b=qC0epkgslZ0T9v9hwPykDoDhwnoAPeYMjwVthcAYigiQRGUI0+VbG+xYWKiT+cl2PilVIU
	1RPGCKRluQs7XSkA5q2wMs4u98+ZmlzWClPsuWb0hY7TPUPsbYccTKVHtjrhPNJHcLA6Mv
	jwmjXgKUIkQIhHbjGLp9RbXPNoffkeM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772472904; a=rsa-sha256;
	cv=pass;
	b=boSZX+kCvbASS8V9rvcm0QtJrWa0YSeqOX+EjCp02tO0YkfjzVXI4Gm7Afz/wkOVMdMgM9
	oCMfMwL9tOkwY7SEnZC/oS/EErHT7PfQXkAQoq3A40s7ysH1UBDfep6m/cHMC/vb8vxkF/
	K1CAPQGRHHx9guarR6VdT+eLMppnddg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="n3If/7du";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=A1WqFnuh;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622HCEgG2684010;
	Mon, 2 Mar 2026 17:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lHTxaBT9ppevFgUrRS
	Sm4P2BPQHs1E2evifX/qDwPOU=; b=n3If/7duFCoaM0l5QReXHrPyPy1W54nOaE
	9tYyWJzcwQIxxmoQrx4kxC4C9KO3MOjkvrDfxZACOwMz7/BXtx+SE1fBEDj/3P0D
	yNINuaY+/eq+JuEuha4W1On7OBpIjBbR1qxtzI0HW+PD4zGDaRUhNFs1KPt0fClR
	jlVk/CrjpgHydseX8d3q4Y3e/pp+gMAId5yw9mmGBy1muwun4Dn6mwFO3rzUAcmt
	Hc2vIFPkIrGEXnzep3WaGqocg1GGldMEyWG97rm4Gjw/IjRC3R9IHAQp/nFhDi83
	vA+Czv+JAH+Uv5VDSBxMJlS3LwafdVEDE9+QfBlONal0djhdSBng==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cner8012v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:34:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622HRXVs037925;
	Mon, 2 Mar 2026 17:34:53 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010048.outbound.protection.outlook.com [52.101.193.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptdgxw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GMBP30AyeTY5V5DeP41cQ4zj00x4Gy+Ar7nQ6g9GGm6HaiElzq5Sn0836aSTrYg2uGZ1P1oRfjRSYMBuYvSUzSgaaPZ1yYCwcsV6fFqqnk6VWcHPrEDYjqo2n2xbGt/vVZvBJGiPkn7oTHZCJhAJonJYJAvh51YCZ+vmHI8UbB2neoXlXxDC0dyl7106JnrIyTvDa/c2Q6ZAcnmgwiQQPmCgGFHflKcovibNSCDQhMQQEvXbR91PweAiXUmdLsJb5EfEahlqjHG07mq/dLNtgGVVtB7YmMypZjH5taCynuvG3ZM2Hv8A5Vt95CmgaIne/xYXue7TPNCwuUy8HdQj1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHTxaBT9ppevFgUrRSSm4P2BPQHs1E2evifX/qDwPOU=;
 b=M9uyU5b5M/iaBvNVv3NHjDCBQsk3iMOFbLzSarM7z3N1x2A1+PE6rH6dE5tkwx2JObRBdjFVfIux33Uxo7nM49KkuK95+lH7JHKeOiSsCIVrQ1J28L3qntK6/FgrrWS21NriAaQisaHr0z5SUX1Zg8wSCnMfSRpMuybYYeE2SYpdQNKqA4PPCngIexnTWC/PdYj+wa0n0zCP4KfHlr3yOGuqdRpfdUoRJ/V6vPq0bILY8lBGVVrqHuRmUZR5I85ZjuLF/WLB9/tp5mBkkgM2zk8OYEPnw8Q2ZN6UD7T2GlHtcj3A9S4gtPXvs3ZDPnz7WJMMiHks+Mapzi3ZnGDXKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHTxaBT9ppevFgUrRSSm4P2BPQHs1E2evifX/qDwPOU=;
 b=A1WqFnuh7IU77B615ADjpcloYyGHNoouC75xdNd0Lq5+ethw9t/C+rZcxH6ZCrqZ+YnX2IAQUN+6Qqr1o3ac0zHXedJufuSEt/STxJk9fQU7m+DaiVI8n0wSAgeoURaLt+5Jwwfe1vu1fG76YPux7FvhJZZ6iGAS4O/amooRm7s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV0PR10MB997588.namprd10.prod.outlook.com (2603:10b6:408:33f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 17:34:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 17:34:51 +0000
Date: Mon, 2 Mar 2026 17:34:47 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/huge_memory: Prevent huge zeropage refcount
 corruption in PMD move
Message-ID: <842272d9-9e9c-498b-9b11-cbad25f526c9@lucifer.local>
References: <aaBVz7eb6-VBCvaz@chrisdown.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaBVz7eb6-VBCvaz@chrisdown.name>
X-ClientProxiedBy: AM5PR1001CA0004.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:2::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV0PR10MB997588:EE_
X-MS-Office365-Filtering-Correlation-Id: d009c948-a6f2-4cf9-954d-08de78820232
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	Idb2DzRCTZYM0X09WBORQEFphpScfWUWO1S+O4fjb06UCX8LHTxAN/VkDgxsY92DD/AdABzn6wcA2laBW+R1esbZDcYNtW63SoDbFlaGEyZCT41HFVarolxTkhOD+uXF/9eW2ClwRQv4/ZlEQIK7QxujfhS/c8IWIik+KbWT7dk0Da1SYqwy8wXEoBRTM9aLNaG61O8N/OJMos47CTZLmEI7Uld9SwqZy/HbW8J1QuIEfPzJbdo9qmG8a18YArS+n7+2AasCsEPEPftj+h//LaFe5HszwAgju3yQduuwGF6TNTB6p6OsOrpRJSskIr6dJjLAE8S8MQzy1ErWp5M3oYJmDz9J0WTXVsKtRSS+5FbzuxUQduxyRc8MovI4OD1Gyb+l3/bPWYZBiMRp9GHGBH1cPwaKe92jkC+mU/pox7Z5LidcZqIijCPzeRkdIs2zEmFF+oLQ9v3+iMVs952OBrho/OVaslgTVwTbr+fHWq5jty7IhtzbF54HxgE+AZ4p4i+DueUxnbXUJhQ4D9axkiMQ8smR/YDshXG4G+/qIdOKO7E6xysJ32HLzkeLCBHdpsD1Sq1BbtMj0+gCdjIqSirw7oUQ4YsbD8qN65gIofhpVHRS4gXKlqAScMEiX+dDHrKS4j9KcIM+OtQISatQJ3+XruYWA94aWOvNxjyG1G4AHcYMi8YS62vKgw+DOMXbE5AA4m39XK/ddlGLrKUgB9znnA3HWTIWyr7jKZSZGCk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wny4gUIR4X582l6NpjBdK2YRlMG/KQ3Yfcm7AvpURUhOveAqV1bvTj3KiQtA?=
 =?us-ascii?Q?iy2qtNkm7QuYWvg5vscba67zq04XneCQJDJV6gfBtNY3HOg8VAPmqZjSRurh?=
 =?us-ascii?Q?HjMbWSLePmKvga7REBUVDg2eiiPxiLs6hNKsashuy0jP9JWHSUD5DvdeE3fG?=
 =?us-ascii?Q?3PpDsX79cQUnu4z0f5s4RzsbHkzjLaCBfW6ZsBf3q+OJKWjBOrcRzICEwlDw?=
 =?us-ascii?Q?6l59TGzTQcex6OyHU20XTKzb1C+1pZb16lHY3jwFvhcSDUFp+k6FSPa5wv3G?=
 =?us-ascii?Q?iNQoycxP2GSXvTx73mvKIH9ENG0vp279Yynr0nTZQym7dh2abJsyCV4xy5Py?=
 =?us-ascii?Q?gMytFmu5ZyoGkezN37a+xGyPkP4fBOWozk+MFtNnvZy1+eJcIz2Jq0Tw4EGi?=
 =?us-ascii?Q?qbuIfwNgBh+eDrmXnVwfUFDbH+mQBvI47Yc+CEJL7S9EydjWA0nyPYtBOBoP?=
 =?us-ascii?Q?FVJTmvMNYpWZobH3tQMgeWKaQGCZ2Yjqehx9FpeuW7S82uNAp16BXvrZOTdo?=
 =?us-ascii?Q?hPieo8RdR0qtfqSLvFOR3pBypqhdH3oVWHC16kEa401wK7cc/weh/NCc6k7Z?=
 =?us-ascii?Q?G9jjI/DvN5JI1wSEcrDNoEvT9plzxsApRvP30uvQycSaaWnAb5SVLzxboCht?=
 =?us-ascii?Q?7Z9usKUzLgZw6EZV8+ROqHFeighEZb6apY7/E8zgUNNMEBGst4TuSYLQpdTL?=
 =?us-ascii?Q?iKpqCy9LBgDqzXTwSZbVoLMQav9sXwken8hFXEbKcAkCZPe7VxNpp5CwGtOb?=
 =?us-ascii?Q?PGG9CymjKrI4CH12TGG9mqKczPr9GNeIZqZBl1ggnK/vRGoe0sEWbrIxYrrH?=
 =?us-ascii?Q?4GprEUcxg5hCowBonPmbmhmuWtp1VpPxxugn5TAO9MsWPDvfacMuqiFfMtdJ?=
 =?us-ascii?Q?tJWwCyH77Grq1SKjV4d67bIZ2SHml5V94fvTA5xMz+K/F9kkRKtATV0c/Uo5?=
 =?us-ascii?Q?lVYOjOVvSVR4ABXKXQ0Bj5+nsGzcLM/OkCgEz8VA0bDTOYbnRTheb99IgGSi?=
 =?us-ascii?Q?WTOfgmts2RlHfZvm5/40vkOUAdZv10Jvr31tHTaZoXY/royoq5Q3JZ7pGxOR?=
 =?us-ascii?Q?t/WM1niqVh7CRm71syqR6RFy1MOfOFWvwX23dmaeogsEQ2dGwDKOGoDqfN97?=
 =?us-ascii?Q?TREvp0YX7V8vAVT/l0VE/VLfybYwqkLMoRAxt861e1h1jW6nStvzZ39rvUeZ?=
 =?us-ascii?Q?rBaumwHSodMdALa3F6H4HnHhbsDLzUhX7G7AiWmY4rDAUG0qlKpHt9nZ20ub?=
 =?us-ascii?Q?3KGue1STNPbDLgKhMvccYv8Y5Zle0oF7yqXBm0Muao2rk9DvzFN87SRrFz4R?=
 =?us-ascii?Q?2Cf7gHuPBpLZzNxu09HlqksOlYZ59pYQafR3vMH6sKHC8S6oar3sCd2R9ftN?=
 =?us-ascii?Q?JKHAsdzvoj4DtVtWIRD33EEl0FyzKUZU49YOS1WXbDmTqBFc2PB2NhDO38Iy?=
 =?us-ascii?Q?JGw4HbEpEqaXZpCyA12neFiiwzLfOMIVuZghyjXgPSAsRWRzEyG90AEwZtVb?=
 =?us-ascii?Q?IY6EuZ/CjsaTeRReQutH49N5VYH5K+Iu6HKYa2wapedypfyWFdEiXfcGt6y2?=
 =?us-ascii?Q?vbL3ZtpZkxNpZuJsO93tVzTmEJpcBS6+V+DsJwImjzNvFJ6pWlIsud+r3F7O?=
 =?us-ascii?Q?VX5cPSoKFu/W4QTgrnFeauPk1lVeq6x4FgDzmAPlMFNuRFHsA/lr4oTECume?=
 =?us-ascii?Q?8ZygggAuveZa1YukeZEcwhO6OeNDkh1zFDozUi0SMFCH0lonGSjivMqjXBLW?=
 =?us-ascii?Q?GVQq8cyveGbtAcs8mGeheDPuWdCbBUo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yDAh05t4GGMHV2OJ1/vpkxsLu7Evgs+gquql8EHD8OWimyB4Cul8nACJ++48VSCFBvUE/2c3GAQw6Pvakpi1BRawn8DcFxft9XytEdsqSz4tlyu/SkUlbJl4MbJOmpRuESgN399HiMLRR40HiXc+zTrFzuqjv+cUuS8xvbbH20jjqjSRStEUNvrTTVCznOvGQtyVmyUTUnR0bdGp/ha2/vxJghEroZdwFZknfaB8VYC0HKSW6gZy67gWoOGNoTS96IO4BrzENleUG0i9vDaQ6gysThTh4bEBmqLG0pW5hnPOD2muVWys0oncbMSNImR8hJCZYkLMD1bVuTyxTrp8XuwpgpuUQY/ddWg/an+LNLtHXvpc3RDfwjkLStTLIG3yvUxPqr65YHrpOuplWtL3Tj36IEjPF8BApuKcFOmC5skxHXa6QPJhSgR/CYy/nRQadVWo/hN0sqZEyYfEgx6JsiwT6e2mGwnTtDUYe8eIR8Y24/tnP3OkuytcjpwEX1/uEJLgWev5pP65Hlbtee9TJC2jc607ziTBoch/zOUpAebfL51Usz6BYUgTAJyufDuLJAhI8GuXJ67ZHbZ6NhhVh5lfMxkZmAocJtK8bhs4FcA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d009c948-a6f2-4cf9-954d-08de78820232
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:34:51.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAKqE73PvBmFeaHNcDNYdILKPBntkxZmEgDS3JOuowy/H+hoUrVTFLfgdYMX8fiFW8sG8WZEVsom+RoNY6xF7oNGYe/r9RzhCrfKd736iiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=706 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE0MiBTYWx0ZWRfXwZbBad7RPB3T
 TJBfTIQABC2E+xklwmIcsC8JvDgsfjyEt12/djdUacUNwQtFA2qS+4vT59UWXsEUNPJvWp0IOTp
 N5++jNVLMs5IDjiZyi0uiPxki4aY+KB/Qwxm4t1ZnrW9vytvcZoGYIz6MZBwRs8gRBc+Xw9TaEb
 Gp1W3CJUTPW3J26LeqiINZ68Jb3jj9oIX1nXEpcGfVBUQ4N/e6DKW1TCQWDMziJxgPkQG5D0lYM
 2C1b7DXfX/q/Cqqhri2rANGK/dLOGaA0N4/7DW45oLDP+Kg14yzo0DlWaDKMCJHubmnnt1KgyUq
 Yq3pIyGq34kzi5BWuXQLlPkyxf7jKtT0eQy9ZNFlgmMdrX5sd06Dqhe50yZQegSXqYNAXxc0/en
 EKZfLyYh+IEcbXDithBi7wMZV41Q8kcOcgy96vo53Se+E3ijfMss9EzfM2ER9QRlc3H77at/Dnt
 CzFbxPFVCi48eSKUk05Wh1M8jtxXMfp+gqO2h7hs=
X-Proofpoint-GUID: MUL1jc8O3Fol9taVF5YU9jbxLKLl32oM
X-Authority-Analysis: v=2.4 cv=OcOVzxTY c=1 sm=1 tr=0 ts=69a5ca3e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=vjtDiOC896RkgtxD1rUA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13810
X-Proofpoint-ORIG-GUID: MUL1jc8O3Fol9taVF5YU9jbxLKLl32oM
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A8A3914000A
X-Stat-Signature: zwoxfxkij9drzqufsq51f5jcipji5qwx
X-Rspam-User: 
X-HE-Tag: 1772472904-64135
X-HE-Meta: U2FsdGVkX18vV7di/xsEpj7qoRjF0+/21+It29RBuKHkEcm7kwTL+XEGNun7a/ApsFQNuqyQAltzG3eVXGOIrAlqLucSLGNsi1oytXmnN+Ohhzy9k07bLzUnPmr3iAxhSr074ymf4uOlOACDhv5obTMk3q67j7m/zhaCcmYANP3l3n2tw0tWIBOaMfnwioSmJGZDfXJX4hUtYdqsDxjnYR1VbkRspyFFD7N6cU/tcmyXI6g7F6fY/QhvgZw4jf6TWWWWY1kOm5Zq1qYbAcvaAc5xqtf7rC1ci2P69c8nCpngw9suyRJfutLU5+ckb/47StJReCmSDSb516T+OKpfHwJMrwVcPP1b25D7eGYE0NYT7RmgCUB8xVvBdMwtiJG9d6LB0gjphGSV94tODqz9g9xC0YTY4q5sRYa3ANuf0gj4fGBFFrVmm+HCna02Qc2UnXOt+Jq93Y8eHx6wSo3VAiZU2Ud6ITvDfXvGxaN2tW8z+ZkETyrSmrw0gkDQysB0erWt5eehnr8KZ5Qm5ll3E5PSuovU+Spxrb6szkb5Sz7BzfdWwJrUM6Gv5041W7mDHr0o2BsmeC6gOVzayfQ+urUuyyqx1U53tHsJPpM/Noc7XD+gbyXkxhEjUT0cJnEGY5ud9r2ICRKsBChqciKcNn6iI4+0CT1j0OoouztssG2JaCorX+zYzsDztBQ50Hl/M320e8xfDvOXFAVAxADyD1nkksE00hBiuUk7ZP4s+4UmSDdFKEzVvR72PzNFqli2hE5v1ASkYLUqjDu5Gs7SHE3aWEYRzh3tGncLuEyWuhCiJhOK8KKt7VobnEr5c/KhrZg+38YMrVb6yVAykVxoR+7VzOT7dPeSVRovM31ARITC1NdkfAEJ0V5xkmvcvMXyUsmujKEXYpTLfF6GjgSlhK+parHokOARkRep5LtFe9+We0ut0zM+36/yJgbEXF1Rnll5dbKbsahOHTr6Hb9
 QEUVj3cr
 UWbK1G1KOjFBilYFsHQyE3A7U/hE/Y0vMcwZTTRXhUX/68oMUWjj47qRp+rDzDYKPcRRXMHdg3tc2DadWQ5GzQoqw/KYWAcrEK6/Qc4LAAugawNI83lhQkrhjpKwhHVqb74rJQiU8lfh+I2/+CtO8MoWE1otuHjQB5fGG2tiAOWY+ZNEi5OH4lX9xzFhQ7cMazh/QRpnUwXQMeewRJVBicOeqxfZ8FCOJ9uYcmgBr4p3uYqoKd2qH6ro4pGTZfCEwfdCxRIBAQE672GKYqaefDBLGukfALdH65GatFPAWOiy/AzFCcQfBdaQrOw1JZdjNW10b3eNw0EXqf4npt2M13Rnj3KuMugijqY46dhDe01T22EWZJEKSp7EcibMLHVLZPGTtO84Xy7V8TdvP2f5ZBpkwgb0+zbQRXfjShR4EIarE0q2kC4b2TF7iq9mqiNOJbU8YnUhdYNe2tzJhodrlH+ORED8ra8mM4By5sU05/dS/m6jpXEam50Rk8IvXhNeYoqj7CBL+gHsPWBW7xObOweVYCgugiQgMu29ZFiWJClrd1Po56cOh5bHm6Oi2pEWHGOjNag/a1iUZZw0sm6ElZ3Lw2yKbbbRUFkPFVdcfhhLGrCuZe6zemp3Wzpt+Voos3KjEo+cZpk4k9maIAMZuOqOJbN70lP57gMKC7XeVebe3vyoJjsdLGvkrsZnYalbvHiLZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:16:47PM +0800, Chris Down wrote:
> After commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the
> huge zero folio special"), moved huge zero PMDs must remain special so
> vm_normal_page_pmd() continues to treat them as special mappings.
>
> move_pages_huge_pmd() currently reconstructs the destination PMD in the
> huge zero page branch, which drops PMD state such as pmd_special() on
> architectures with CONFIG_ARCH_HAS_PTE_SPECIAL. As a result,
> vm_normal_page_pmd() can treat the moved huge zero PMD as a normal page
> and corrupt its refcount.
>
> Instead of reconstructing the PMD from the folio, derive the destination
> entry from src_pmdval after pmdp_huge_clear_flush(), then handle the PMD
> metadata the same way move_huge_pmd() does for moved entries by marking
> it soft-dirty and clearing uffd-wp.
>
> Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  mm/huge_memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fed57951a7cd..8166b5e871ad 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2794,7 +2794,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>  	} else {
>  		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> -		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
> +		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
> +		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);

I'm confused as to what's going on here, it seems like the 2/3 is simply
updating the 1/3 with a different fixes?

I agree with David that just moving it is probably completely fine, so I think
this should be the only actual patch you need, and you can just Fixes:
e3981db444a0 with it? Then make this a v3 series with 2 patches this + the test
right (but maybe best not backport the test :)?

>  	}
>  	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
>
> --
> 2.51.2
>
>
>

