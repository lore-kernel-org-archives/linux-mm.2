Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08BBCCF2D5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 20:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBEEC6B0098; Mon,  5 Jan 2026 15:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91A26B0099; Mon,  5 Jan 2026 15:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02C76B009B; Mon,  5 Jan 2026 15:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9BFB6B0098
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:12:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62AB457C85
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:29 +0000 (UTC)
X-FDA: 84299007618.26.D4C2E5F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id D94D2180003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ChrT9Y9M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PKK7nimZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767643946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scuAgwS9CEhqIXwWEDiyls3Jhbzu6h+qqUyy5rcJJts=;
	b=lVNokpZq/CwLDk8QR28lx6zriFx6T/OPiD+HV4Mrv2PWSsRgNN9wJFynYlU5X8R+Dp12pr
	GnOkcGbzJww8k3gkWyuTg0Zqvou3hgpgvTNJuDnW9OgUGCex5XEW4+Mqrj6HgrKGVFkMMn
	Id48h1lnLAkMWGwlUSO0BbpGBmgGb+w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767643946; a=rsa-sha256;
	cv=pass;
	b=nhVqZEPjFpezfNLoVAFIz0vT0pc8kJDEqnwkua34OCwlpH/TxA9HfHBieCO/NvIRR71m8l
	QN8N1VahrCFsBk4enHmzYcL/WM9P905mR5id6WEyuzz3zIeQNgv0OvIGVdF6m8uRSjQSYT
	l+CqFsdUozdx1/8Sw3VzdD71iwNHah4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ChrT9Y9M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PKK7nimZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605JKcE41874497;
	Mon, 5 Jan 2026 20:12:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=scuAgwS9CEhqIXwWEDiyls3Jhbzu6h+qqUyy5rcJJts=; b=
	ChrT9Y9M97uCe1hbGs3WBOiywiNG0bVgTVIwt7LPG6u8SJhBB/e6QCnc66verTL2
	hwB0Em+CM2/0vMsrkXB91ZymJdeASPCBG5k3vxHxHWnY7LTaCSUL7zVP4rAZ/x89
	X6fMcod8KpAtAKsTRwlgUolyTaSa0o/NSkenwtCL8x2jCXgoBqVkeH1N37QOUCLY
	9g/dC7uOc0+NBbkMFUBxfFoQ0BwBRbPF5plBq4DbJRdfaRSRu8uVaGx56qgRfkhp
	ZSeeMr2RC+oEAqUQXhsUGQ3Q9VIf+TO+sLLv/qKkMUWBbtYx7DwhbwM0JT2E/5xT
	uV4dQN8jPBa0zPC8WxTFGw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgkcfr2jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605JBCDN020542;
	Mon, 5 Jan 2026 20:12:16 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjhssse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DB8smq36KbYanMUgWd9zInM7vfJ2F1alQhfMB+40/x4aMEEMF64nPU8fqpsrQFzr2IY4h4wQo2suEGbIeLq/6pUl+GqCu85ZA1i0o0Z2zfHhwI5esuOC7NbfDjh80OfOSAogDd/dV/X3yQD35ISIHkiIiGwwkiesucp6KtaNFmUUDcLQNtJsNBXHyIGwgDHEn8nCne6bWgd/Zkpn/XDuTVhkHUT0Nirq7oABt1o2xf/S0OeZw1KJTRJiAKATqTVuzfhOIXarFczRwTwGSSWGAs6DSmO6KEpaUdu916GyL8rFgs40POFDJ+IdKa6UbCG0oYuw42EHfyn+FwY/5mnrkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=scuAgwS9CEhqIXwWEDiyls3Jhbzu6h+qqUyy5rcJJts=;
 b=hfcJxAK7hVE6O0UvRNJW1GSW971Um5kIZKGQX90hElChJTkiar7L553BhoRvYmZyW9NkhrhJLxPwxS442CwWtalmhbbtA79DQCAd9vULZ9Ni1siBQuOOlRM+8Yi8QLI9nCZ4Bvvo+UL1mCKq1016WiKT6DsmuWUPRt1GntcvcaEYju5GwmFhh9B1yOogjlwVivmy8vqMTygCbnGCjJ27JE8edMYGE1FyGQtCeJf/cSSXyT4GGdgu13Byh4EQi5LdkX7CTVTjJF7BIBiEv9T+c6UgbPfySvr2fKbUdVpghnMZsdJiX5pMQZB/5n801iGVTsOIpi/C8K4gHuXi4QFs6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scuAgwS9CEhqIXwWEDiyls3Jhbzu6h+qqUyy5rcJJts=;
 b=PKK7nimZumiQlQVMAtQVY4zQA3oRFL+sq79sYyWMQvNTa0U4pXXYUMEeW02b9IAoqqSIbH125DUrjomCp1ya5emDa9SnUYRvB7jKNhwz1WpUfDdf0KlYi+oO27TalDK+2qZzCPMuZ8Ixw20kd70Fe6WeIjhtHGcDzs5dT6yMdso=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF136884A98.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 20:12:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:12:13 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH v2 4/4] tools/testing/selftests: add forked (un)/faulted VMA merge tests
Date: Mon,  5 Jan 2026 20:11:50 +0000
Message-ID: <1daf76d89fdb9d96f38a6a0152d8f3c2e9e30ac7.1767638272.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0142.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF136884A98:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d96eae-fca3-4b0a-30e0-08de4c96b6ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uxcLNOdFGRE9n4w1qFRMV7zrqOqrDpa1/DQu0i0uVyE4WL3uP6IdVby0fx9e?=
 =?us-ascii?Q?wLIn//gVt58Bh/XSsWynQ0x2uwyixm78aKcyDbCAiIKe+F7bHYI8izL32ZLq?=
 =?us-ascii?Q?iwOskkXxd3WW8S4UcDzAsFjBjFkv3S3/ea27RD62guAOC0p0PsECwaKxpsf6?=
 =?us-ascii?Q?IXmCUoj/hAc++J/C8qqF6FoWJpB3iFyKi9T9rMQVBwFm2UaqBZfuXwbUogTM?=
 =?us-ascii?Q?zEI8mzVrl7VWnQocyJxD07Ln/IEkVrVtppW1cDTg0UT6gmRT/13+Yq/079x4?=
 =?us-ascii?Q?Xkz7MY3cxAVRIj2sHZZSRlquOuuRFB9bJ4T5rmlb94FxkwXs4Y8joTnPY9f+?=
 =?us-ascii?Q?DhUKs02CxKQ1hi0FkhH/em2LfMp2nZy7B7c058zY1QxdEPK2dqJfaTKHS2IR?=
 =?us-ascii?Q?Ij1yjZmhw2a0AIwuBEOK4/GONs45BGeAHbX37i32IVENmmJt5B2+4g3QW4xV?=
 =?us-ascii?Q?wIJD4ssadmVLgQiE6AigTFG8v3S0no/w/fNz356BRAMOgglKEOhk/VOez8tR?=
 =?us-ascii?Q?kMSZweFxtEpByxg+8ShzafgrxemDF4ozLJPr6e9pxw14HwR7tlyvDKsIH3Lx?=
 =?us-ascii?Q?ryz/4aKd8vwl0nS4BCA22U6yo7bqNfO4BhL6no57ux7tBYd4WXSIWCsw1mFP?=
 =?us-ascii?Q?A4LQGnOxcOXUdeFSYX2bcY90JMtfexGHhbW/3x/tNC9Rd4wUygrWFcvBXp9h?=
 =?us-ascii?Q?/s6DNan2ejr+Xp01JrjHKLR/06SNv2WcaOEYKb7ZoK/ASFNbYnrHyOrufhUp?=
 =?us-ascii?Q?NRWYn+2zzls7VYSYIW9sN2TEQ0QLgCELhxp6K9bWY5OqvZmaMeWLWyP5ZZFK?=
 =?us-ascii?Q?NBJIzCN6Eab+7lSq6ZqF7Jp47l+mxO0VXmSWW2usKJexdjRKjCxIXrIt6NpX?=
 =?us-ascii?Q?S3hCN/LSjbxBHpu1g2u/wn3uzqOfwFmfkD5WIG/Cz6+A7qHUt1Fp5OfKkmEx?=
 =?us-ascii?Q?i69I9hmh1IGhbsJ0lDb1czo3e8I8yfN6lsO0+HFJNcnTaszBcdDvU40X0rJO?=
 =?us-ascii?Q?VfJfwkjeHYrftuYWwHnmtVih5vs4LcGV8VaOJd9ycE4ppgrUFsfh2uwJd3rm?=
 =?us-ascii?Q?uY3Dm4yP7HjeehpCwinSyrSP0rUDWq5NOm/z4fCTGErgZvIGGxylvx4KIQFj?=
 =?us-ascii?Q?Z1ic13f6AYODrQpS9LepqLfOmFB+jEsM9+AVqspF7vvowqnNNULbFGv9js8f?=
 =?us-ascii?Q?u9OvLj5ti7nhEcLWqrkL2Nn3aW7A5E4uig/nnjz4jyYAB0aMBkex7zQ7q+6x?=
 =?us-ascii?Q?wnfDQoFOefcStvvO4L396ItRDLLWK1wxjFrJR47t42XqLIoq6QNb79u1TqEO?=
 =?us-ascii?Q?SRK3AdJNKiFIuJk5yAiQSgrh3+IoLhVbw0Qnalyt0Emn4EhktW4wT7cEy+8R?=
 =?us-ascii?Q?+wID33S1sf/48KxwlMGb5JmvHWpaSFuFOKqDBnvUf5jpGWfZExdvUPPpKiWz?=
 =?us-ascii?Q?bMTe7r6XqV4ViROZ5vPuCrHVFjKz10MF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cQmSNNcUKWHVnoc96RFMyB/Guh705EqMDrvEuIPFjn7VoAlRKCqWrYF254f5?=
 =?us-ascii?Q?N0LbSgJWKVfknYdB/Ejp9eLQcz2k2pPwkCU1zKhBrtvFk5xdtEiaoflN1eKH?=
 =?us-ascii?Q?dqCTThzhgRe6NzQ5QAAaZ/FiA7tOL3QjnWSBKcQP/xKmU+A/vUCCOe34O64o?=
 =?us-ascii?Q?G71sqoWo2srCwnCb5j6BWdCnzOj8SguCxq14ofeDzeT0F4hVNq/HyNGVpfTa?=
 =?us-ascii?Q?022eggU6M8UBS1z2Zo84ZOPflNGp6rrZjbKPCKg5Em3ZlwdLNvCwm5yF00B3?=
 =?us-ascii?Q?oG3P5KuFb1FiLxcFXPjGsvdmslHWKRLXGXpkvcXos/hOESnpTTX9jolhh31+?=
 =?us-ascii?Q?266De8OUE6t7ZTFYiZZpmX4qhSzNEFTsJGtFQ+q5P9GhhfEfEpndDlBamYzq?=
 =?us-ascii?Q?Y5GKEPphW0y8+NNC/lxAVNXw7Vfdh3EgwKSt45wGDY8vSjG/42q69i59AEHb?=
 =?us-ascii?Q?0AN4uek6mMS1GC3rzHxQ1uVKjzAF8+Ckdm+WyjszwgQt+VnQbpjamlknwmIA?=
 =?us-ascii?Q?goQGTRGvCc3PWGuStx7jYaP1IbZW3x04xbwzIb443/lK7tZZMZdiLRolgT29?=
 =?us-ascii?Q?o7FJYchxRhqxMr5XkERluNNs3z988os9NdOAwJolkP3dW4CZocn5TFEm3TGZ?=
 =?us-ascii?Q?mSevLzy6orNi3MxzXJerh/IgZzedh4bsJhsBJFxlER2b7SKqnnmL0SRasqXx?=
 =?us-ascii?Q?hQNCTDJSCFHRSDk1T7i0jwPfQ+472rH2Oie6J1ySTChpYJnLkqku4/5Ejx/c?=
 =?us-ascii?Q?LX6f4BJAVS+iP6W+F3E6q+Yjosf4P3habSI42F8RbW0dlZelDudwdDwyjnMX?=
 =?us-ascii?Q?+ExzCcUs/s58KA8/fX211r/q6nc1s6tBKpLm41UwZtqUlJge+kvO3TB5kku5?=
 =?us-ascii?Q?3eGZbES9GF+r1WJSciPoR5R0Huhop6Ec1vP4birN52MMHsaND/1xrMiWgKCV?=
 =?us-ascii?Q?t+7+Dt7l/tUfmCrR2h6wpOLLiUNCgroXbghsLwklgR/V+jRiDMAT4ewGBxD+?=
 =?us-ascii?Q?BjTpLVkFBmmiiKj252PQTNApwHrYDmUM3jUB+Y2bPusqbi59AMkgoXVvKVvZ?=
 =?us-ascii?Q?y7N8sfqHJIOuon7s7lloptvyyj7YYozh/LNA1p3j7lAYFDrM4N02Gjf3xyQv?=
 =?us-ascii?Q?rc5JJvwNaX8IoXcZEVSYSwR0v0hrUBiTSsN+TSIDrE2YQzbZKgwN2uLEAr7A?=
 =?us-ascii?Q?hYfHX+OGpSYQUsRFu54yQSoSpubPRJewrW+YWIJ5KJkz3incfFA9FCFQZ9ax?=
 =?us-ascii?Q?C9dwoqiCZPVVNsIVd9aZfLPZ4GBx7315EYWzSvL6hbIk7UKHHFomcO2vS+9d?=
 =?us-ascii?Q?ksiI89QQ2EwXSrB/AAfxVbACABQN5KNyUs4X5hkyugH4ERvyHTFm/Rw93cNv?=
 =?us-ascii?Q?sJOnLWMRcsGPj0AFKZa5lcDiBSQsrPUFDmsXqItyfuKzDvHft7fkwXqg4600?=
 =?us-ascii?Q?QCOcHfKYqm355jdu68mfpF0BCU8XK/fg+T/LkRrKWChzWvcxrDzEHkCSklbn?=
 =?us-ascii?Q?xGJqa4RrVqGakLbpfYoOcmAVu0U+Cehvi7dKAPt/l9nKSep9aXMw6QpP8qce?=
 =?us-ascii?Q?39HRntHYXAfhOcEF2aWMNx6dazN/CKCgxAdHR4eg4CgNwATROTP+iq3FHatI?=
 =?us-ascii?Q?ivhBeWSGvdZjHubmqXpmXBQDlBX5VVvb/0ZPtfGn7/nOzFJBfDBRTA2/L9pc?=
 =?us-ascii?Q?qCA6T8bnb5jgU6VgJYl70+2uCSxyd/2vi0fSxzgfRBbPZS4Ae9adDNhg3R0j?=
 =?us-ascii?Q?q4lQKhoXgveS9WhaKsD5eICKEgAtSm0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0D2L1SA1TmQpoy+f8eXCI8Fry7aKcma+8d9QoNLqjlOtLsMPuysvaEpSoJRl4IPFNbHEOjpj9Oi/kZDFuzkuSetoTuepxbTOin+OURo4wik1XyZY8kSY4cYSQkKWNyrYx+0+49J9J7z872biklR+GFDGsxWsVNqZOQbkfQ5iib9OPD8xZI/50cT0m4yvNzi8KKXhVtvG06eujJIgYt82AEchgh+1QNFIsHUZl7dh58eHHDK0gyELBTwEA+JDC9lkpUJBsQyBSLkf7vsb14nOzyQSC1xZZkdruTwnz1SzEzrlRrewfmAINbH9gHl+uDaWAcaIya+8CQGv4yhmQEJDQTTvj4o7eKKBPX5fg0b46d2s5isTno88wReuBeJDoycfHpJHz0EcB/7FlvGWDDtkbsKaRUCaWqh1vRBD3DPLst72K49HOpItSSQDd/BpUtBa+ytIDl2foGywKgzKxaBcCbNhyK98nM0r5zfwFFKj9K4Wanvhrj2fb5tjwnSokbvuugoOKHSNB1ZjZIt0vfsRiox6pwsaMSdLFvKKGOH4J+2fpTeNVdyZX4gYWQFTBArBcH6ltQ7j23VHaUIQYTR5ASilkhujewu90cH7LOxSKCs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d96eae-fca3-4b0a-30e0-08de4c96b6ae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 20:12:12.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rvi3JRFpFBNCNcwi34DIPxukSPbYFEDuH1NeOvryf+DhhTu40g78bfV8gdT2DfgRMgqd9jf7wqcUyu8qIAqF/NGJRoX1JzYe+Mn9dxQ69dY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF136884A98
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=869 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050175
X-Proofpoint-ORIG-GUID: hHTqTLw4GaE2zrqX6iIyrsi1SJWq0wxe
X-Authority-Analysis: v=2.4 cv=VKPQXtPX c=1 sm=1 tr=0 ts=695c1b22 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=24_Z-CCR0W1utOZiRgIA:9 cc=ntf awl=host:12109
X-Proofpoint-GUID: hHTqTLw4GaE2zrqX6iIyrsi1SJWq0wxe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NSBTYWx0ZWRfX9/O93ZlRWwdQ
 PtBcqnv7SAPEJTmqyTdJlwlspR0IPxaH2sN7uvVU1riMYa92jA5YKsduTTMxvTgVj9uNK1bLBeC
 oeU5kwxg1Iq5lRzXX5V6BGMnh7ksMqzb4mN28LE0xaF47ype/KkNWFwu3Anaf9qa6wFWeZtkslY
 XRmm3qZL77lLQZBGb6QVC8VKQvSWcyoyQzX1d17lmnS780eRo5qiwd7CcIYXOD4HM8C6DDz7xJh
 qfSXiE8GA0iAhHh+852hTh17tO7FPl27Q1wgJ2z7K1Y5mYdQrbSDjRzAYi2StFZMmffz1NWN1w4
 +P2wJ8IbEad8UMBjR/DeQNu2EsnuCFCxQBCyp5ZNc0m9EPh0RWvF4saIkeGJIktoJ3znvznpWaO
 H3oEvWALeC5x/UGCLKOakrwmgoqjTC+tMUl7AEAgbjNFoDRosA6RZdt5xs6K9qJRqNUfVCM4QzY
 s5eVEqToi4v2fYHivQ0uBhNdSrMkeiFCuGikU/PE=
X-Stat-Signature: bzbdcjxoznyrms9rm1ya89reatutxkqt
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D94D2180003
X-Rspam-User: 
X-HE-Tag: 1767643945-800535
X-HE-Meta: U2FsdGVkX19DBeJqaH8icSWapB+X5YUqjhZxK0zkysjvX9s4SraUkfA5U+M5SeYC30UuxuYopyBzWgJoHymw2Lu0jNjhoWPjAtNAhx0BBZ5VtzdrvrpVPpFG/wsClFklAoOP+CoKedTl10BdwA8AiUPtd/AjAe3yrr13PMiZMYEnIfHxtjHUsLoRELZRRBwXwp7WvSpuZGVXDhhcf8IyFkVPoKMZOxDk/CNp703EVlj/EUxYUraiVZLVDA8zjQCMm+TjnD3g4LHACB3QDyJgvskoPMeAjYhjHtRjr8HIU3m+8HQRDZsdfJ2i9dmExPvzU5/DQNFe2ym96Em5tN79MYkXkPnrJjknfe3445qaR9ybpD+R+qxzl6HsAeWQiQbVTyZk8J86i4RoXcKfHSG9VNEhJpRVx2XKtHWYjnzFRQQPYvTQZyhuAakcLVUzExmKFsn4jOYsNZoShJb4sSPeovixGgfO/7hZdrnR2BYgyxyKpaKgSmfb3Br7PddjCamQfZqzDDe7mqcvGq2xD517T2F0X4RzUp3DQ7o9b2lZOoaEh0LdNKegEPAe2q+j7cEkRPojeADWyCzYsRuB47iP9jP9ArnDIgpFBjFavQkUSyrKQYxoB+JAbt9HUZyiGAYDQQ9DQZEFJpDQ1PAoZt6Elpi31vWFnODgjKyxpAn5s9ApBhXn2QcHwruxskv2y7oB0XpAi1kGHFN2YSL3OArRzaAgiUxZulZeyk7Kr4TlS08QPk4GqAWLwdAVRQKtok4FV7Ft5Nd0zV/9FzZcufm4X6rVE9D3vKsqWCXqp0bNTIxj0SBKVe8fCLTi5VatkwiUfG6F7fvSa3z1zCC9WbCuCky9NiLldRkF4oIUetliyj2Hy7yMGw1yUU9NHAQKw+3VqbFmzyR5Qq3R57Iry86CjEAkTDSNtucYR2sFZUjCkXZjzO1d+SDxQgKZrDgZg188xkt1y7yW3GXZVgRMBgK
 BDMZnkqM
 24mdAjx9D86pqqPAVgS6TAdM6yIWY5xosylC+YD1uJJbURKk/qLRkjL6Jmfa/00+ObOkF2jIUEkf+C7kt9Z2jxOIR7V81x6tqD+cboT9iQsMrKXJbwdkHtNhdkT8vYH53sOjGhLMG5RJbcvpIom9dAZzYImJ+5iW2Dx1RMQZawROLJv86KZPzRjET95eqID9e85+tublex+jhGI8mLiwb9B0UeLQzORQRVbJ3n7oLLFzqbRmM9lAPLkGkRjUK+ze/sLeH1wjQQTjxwBNbK+cvlc4cbZEtD/YiE6ckiS+njVahDKehcRVsWSVExVnMfa+8qcYb2Ckm6iBymQw7/hqTfXWng2m5XUppIxluL8YLEI5WZecl1VeeAbO2q5QoR0w6/k9Vehs6jq+uUf4tF4fd4IGAs7dowdqoUJusxRyr4f7k+s1Wcz+XoMljDyWFbfGcZwaycFco1d+JQ19xRxl/YjIRqLdO/8LhJ5ILbyDkEFL2yvCDoYLeIAYVrLt6JB85TrgX3ZAl57cS41uablSddSNelwSLWZlm+LltQGbbAeBBonoxkLBwg0aGQn34Q74zMfqS8iyJF7ra9VUA678LZfO9sVcRFV0cuoZCYRKnsAu6hsucqdIVYxXFAiQfePsIYWZk3VK+vG9ikSjxjqOgsahGlqgfiy57wLJq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we correctly handle forked faulted/unfaulted merge on mremap(),
exhaustively assert that we handle this correctly.

Do this in the less duplicative way by adding a new merge_with_fork fixture
and forked/unforked variants, and abstract the forking logic as necessary
to avoid code duplication with this also.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Cc: stable@kernel.org
---
 tools/testing/selftests/mm/merge.c | 180 ++++++++++++++++++++++-------
 1 file changed, 139 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 22be149f7109..10b686102b79 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -22,12 +22,37 @@ FIXTURE(merge)
 	struct procmap_fd procmap;
 };
 
+static char *map_carveout(unsigned int page_size)
+{
+	return mmap(NULL, 30 * page_size, PROT_NONE,
+		    MAP_ANON | MAP_PRIVATE, -1, 0);
+}
+
+static pid_t do_fork(struct procmap_fd *procmap)
+{
+	pid_t pid = fork();
+
+	if (pid == -1)
+		return -1;
+	if (pid != 0) {
+		wait(NULL);
+		return pid;
+	}
+
+	/* Reopen for child. */
+	if (close_procmap(procmap))
+		return -1;
+	if (open_self_procmap(procmap))
+		return -1;
+
+	return 0;
+}
+
 FIXTURE_SETUP(merge)
 {
 	self->page_size = psize();
 	/* Carve out PROT_NONE region to map over. */
-	self->carveout = mmap(NULL, 30 * self->page_size, PROT_NONE,
-			      MAP_ANON | MAP_PRIVATE, -1, 0);
+	self->carveout = map_carveout(self->page_size);
 	ASSERT_NE(self->carveout, MAP_FAILED);
 	/* Setup PROCMAP_QUERY interface. */
 	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
@@ -36,7 +61,8 @@ FIXTURE_SETUP(merge)
 FIXTURE_TEARDOWN(merge)
 {
 	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	/* May fail for parent of forked process. */
+	close_procmap(&self->procmap);
 	/*
 	 * Clear unconditionally, as some tests set this. It is no issue if this
 	 * fails (KSM may be disabled for instance).
@@ -44,6 +70,44 @@ FIXTURE_TEARDOWN(merge)
 	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
 }
 
+FIXTURE(merge_with_fork)
+{
+	unsigned int page_size;
+	char *carveout;
+	struct procmap_fd procmap;
+};
+
+FIXTURE_VARIANT(merge_with_fork)
+{
+	bool forked;
+};
+
+FIXTURE_VARIANT_ADD(merge_with_fork, forked)
+{
+	.forked = true,
+};
+
+FIXTURE_VARIANT_ADD(merge_with_fork, unforked)
+{
+	.forked = false,
+};
+
+FIXTURE_SETUP(merge_with_fork)
+{
+	self->page_size = psize();
+	self->carveout = map_carveout(self->page_size);
+	ASSERT_NE(self->carveout, MAP_FAILED);
+	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
+}
+
+FIXTURE_TEARDOWN(merge_with_fork)
+{
+	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(close_procmap(&self->procmap), 0);
+	/* See above. */
+	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
+}
+
 TEST_F(merge, mprotect_unfaulted_left)
 {
 	unsigned int page_size = self->page_size;
@@ -322,8 +386,8 @@ TEST_F(merge, forked_target_vma)
 	unsigned int page_size = self->page_size;
 	char *carveout = self->carveout;
 	struct procmap_fd *procmap = &self->procmap;
-	pid_t pid;
 	char *ptr, *ptr2;
+	pid_t pid;
 	int i;
 
 	/*
@@ -344,19 +408,10 @@ TEST_F(merge, forked_target_vma)
 	 */
 	ptr[0] = 'x';
 
-	pid = fork();
+	pid = do_fork(&self->procmap);
 	ASSERT_NE(pid, -1);
-
-	if (pid != 0) {
-		wait(NULL);
+	if (pid != 0)
 		return;
-	}
-
-	/* Child process below: */
-
-	/* Reopen for child. */
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
-	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
 
 	/* unCOWing everything does not cause the AVC to go away. */
 	for (i = 0; i < 5 * page_size; i += page_size)
@@ -386,8 +441,8 @@ TEST_F(merge, forked_source_vma)
 	unsigned int page_size = self->page_size;
 	char *carveout = self->carveout;
 	struct procmap_fd *procmap = &self->procmap;
-	pid_t pid;
 	char *ptr, *ptr2;
+	pid_t pid;
 	int i;
 
 	/*
@@ -408,19 +463,10 @@ TEST_F(merge, forked_source_vma)
 	 */
 	ptr[0] = 'x';
 
-	pid = fork();
+	pid = do_fork(&self->procmap);
 	ASSERT_NE(pid, -1);
-
-	if (pid != 0) {
-		wait(NULL);
+	if (pid != 0)
 		return;
-	}
-
-	/* Child process below: */
-
-	/* Reopen for child. */
-	ASSERT_EQ(close_procmap(&self->procmap), 0);
-	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
 
 	/* unCOWing everything does not cause the AVC to go away. */
 	for (i = 0; i < 5 * page_size; i += page_size)
@@ -1171,10 +1217,11 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b;
 
 	/*
@@ -1197,6 +1244,14 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev)
 	/* Fault it in. */
 	ptr_a[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMA B in position,
 	 * unfaulted.
@@ -1220,16 +1275,19 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev)
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_a, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+
+	offset = variant->forked ? 3 * page_size : 6 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + offset);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b;
 
 	/*
@@ -1253,6 +1311,14 @@ TEST_F(merge, mremap_faulted_to_unfaulted_next)
 	/* Fault it in. */
 	ptr_a[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMA B in position,
 	 * unfaulted.
@@ -1276,16 +1342,18 @@ TEST_F(merge, mremap_faulted_to_unfaulted_next)
 		       &self->carveout[page_size]);
 	ASSERT_NE(ptr_a, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 6 * page_size);
+	offset = variant->forked ? 3 * page_size : 6 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + offset);
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev_unfaulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
+	unsigned long offset;
 	char *ptr_a, *ptr_b, *ptr_c;
 
 	/*
@@ -1307,6 +1375,14 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
 	/* Fault it in. */
 	ptr_b[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move it out of the way so we can place VMAs A, C in position,
 	 * unfaulted.
@@ -1337,13 +1413,21 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev_unfaulted_next)
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_b, MAP_FAILED);
 
-	/* The VMAs should have merged. */
+	/* The VMAs should have merged, if not forked. */
 	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
 	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	offset = variant->forked ? 3 * page_size : 9 * page_size;
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + offset);
+
+	/* If forked, B and C should also not have merged. */
+	if (variant->forked) {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 3 * page_size);
+	}
 }
 
-TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
+TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev_faulted_next)
 {
 	struct procmap_fd *procmap = &self->procmap;
 	unsigned int page_size = self->page_size;
@@ -1373,6 +1457,14 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
 	/* Fault it in. */
 	ptr_bc[0] = 'x';
 
+	if (variant->forked) {
+		pid_t pid = do_fork(&self->procmap);
+
+		ASSERT_NE(pid, -1);
+		if (pid != 0)
+			return;
+	}
+
 	/*
 	 * Now move VMA B out the way (splitting VMA BC) so we can place VMA A
 	 * in position, unfaulted, and leave the remainder of the VMA we just
@@ -1397,10 +1489,16 @@ TEST_F(merge, mremap_faulted_to_unfaulted_prev_faulted_next)
 		       &self->carveout[page_size + 3 * page_size]);
 	ASSERT_NE(ptr_b, MAP_FAILED);
 
-	/* The VMAs should have merged. */
-	ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
-	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
-	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	/* The VMAs should have merged. A,B,C if unforked, B, C if forked. */
+	if (variant->forked) {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_b));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_b);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_b + 6 * page_size);
+	} else {
+		ASSERT_TRUE(find_vma_procmap(procmap, ptr_a));
+		ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr_a);
+		ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr_a + 9 * page_size);
+	}
 }
 
 TEST_HARNESS_MAIN
-- 
2.52.0


