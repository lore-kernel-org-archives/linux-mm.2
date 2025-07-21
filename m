Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E73C83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 19:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F746B0089; Mon, 21 Jul 2025 15:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036BC6B008C; Mon, 21 Jul 2025 15:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40FA6B0092; Mon, 21 Jul 2025 15:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D15906B0089
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 15:03:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21C9F1D77DC
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:03:25 +0000 (UTC)
X-FDA: 83689195170.01.91156A3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9C31A4000D
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:03:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=c6d0eh+B;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t4ZrjYk+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753124601; a=rsa-sha256;
	cv=pass;
	b=C/abohcF9l64Bp9jSXijNFqMmmlUXptTE065/Z3ug1sYfMwjhAb3+jn8Uq24nc+yTKcuA3
	cPmGWLZHMMv9pQXSgZFg6cc9IxXilszScEVJJmHaQd31Ht5bOv1z9a3NqTirSrUPEtA5zy
	XX37EQGHTFYrsihKQlecrSvj3xF52D8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=c6d0eh+B;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t4ZrjYk+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753124601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4FlDNX1ES2K7IcRTmR5W3yW/0FRJLrNOg6HbM5M6gc=;
	b=ojiZzfAIMZl5gLb4lx5x7SS3moUCRtwKhpW2GsciFp9o/gCm+1mk32XGdkPknli93bgI3I
	BvAhDab4Eq3excFCmFcbzvKZd4KoWwcFXsCV5dAFVqq8NnA+Em/elvwu8sh+ZPWDOtAoM6
	4AykVhBOxqMrrPe1gxpBC4P/7xtQIUo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56LFQgmb023394;
	Mon, 21 Jul 2025 17:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j4FlDNX1ES2K7IcRTmR5W3yW/0FRJLrNOg6HbM5M6gc=; b=
	c6d0eh+BuhtjPJe0TdFhJPW2DIDud0/jPASJqwRu9tSOfPSAUt8ywEWWQ022XRRQ
	Sv7r2egLqurAEt62dqjVmQUZdV+lP2KzxT4s/ij/UfolGUhBv+Dbg+s2hrwD8UqJ
	q7wyxYfj0JLBU8JJCC2sottXKTLiTjEpZ2OOEoZQEonA5T4IY0x/0sX31YvrMI6e
	OPKw6kpYTRF8FaBLGPhN1KcD6LSck5E/6n+cT+dCMbt1rB95pUpEJyUI4XTT1B8M
	c67F7+lKcMzgHi8mRjd9Ee44f/GnZ0iKrF4fw8Hp3cqOf0hlPxmwsaooLmKStTa7
	2srZGfqYVqPP+4Y/UVZzgg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805gpkckk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jul 2025 17:34:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56LGnSPj010291;
	Mon, 21 Jul 2025 17:34:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8bajp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Jul 2025 17:34:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x57NtIxfuat4xCzRUDS1QRiO0d5LLLbrEVSGV02+szzf1i0GwOYArKc4MbHEKC1LUpgHrSVTB6/OKPwIN+tidG1FYET6onvnm8FnaR/fZV3HnMx72VUmmq/wqBVE/tIFbm/57AvDJVcG1jq5pJJ6IVsJqHj1ssPC2b5jKYpWd35xDuO+4eqswEA4QV/fWGp0gPyNj39je4ONZghRWPqPBaMdIBpjy/WJYFjut1AMHKxmTU2gYwKptRjACaFWtqimMYoBkpcl0AmDX1M5u2o69xExMzjYAOZhDlA15oPtCx9V7k+LF41ZoEpJbp9zHEKLw7B9z5BLfPXJZyvllUUngg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4FlDNX1ES2K7IcRTmR5W3yW/0FRJLrNOg6HbM5M6gc=;
 b=aw/ELgQpCmQVMtxemdV8IjNHOLq2445v7TeYCI5Rc4jD+KaIkdBS1vqUbb256QRtL2KffZmbzN3rsNP6wXYSoJbo1o9HM01gpB4XdJTIsZlKIWu+DwRfVqJAsoxtAWGF7G9eG3zBUpbTIdtiBd0noFw5jA9SM5SHhJgVGFkETKXtNea1mpK2Ir0OUHCWkgiCnKwHW9tRs6nGwpsgLiulmlCJ8sPLUnGgGHnDRLdaJ7d7RqtsFhSvH64nDcFJHRm+zCEYtnTocDg7E8d9lll0dwgx6a9/EL5+UjwLSfxwxFfveHqz3NYaYzdKhfbLBe6bBnDAHQrLKY5M8ZRM4KvRZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4FlDNX1ES2K7IcRTmR5W3yW/0FRJLrNOg6HbM5M6gc=;
 b=t4ZrjYk+dgSYTZ1Q/UdPaHv1cPf2GGWsRrj8N/tXuSH49lqiVr4imfBA4txFssQWGPE7tKBDgsCs8Ave941L07WBNfgarIgf4cuZDcaf8NpsOlOeRIXe91If3Aucud02oRNaYsLUERcdDd+VLjrSqplZ4VdyuTktQysgt3adl84=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 17:34:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 17:34:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tools/testing/selftests: explicitly test split multi VMA mremap move
Date: Mon, 21 Jul 2025 18:33:27 +0100
Message-ID: <b04920bb6c09dc86c207c251eab8ec670fbbcaef.1753119043.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753119043.git.lorenzo.stoakes@oracle.com>
References: <cover.1753119043.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0514.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4518:EE_
X-MS-Office365-Filtering-Correlation-Id: 95906a7a-8190-4470-6188-08ddc87cd075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w9qHNzzs/nhNvhnfIFaDUGLUg30I0gXjf2om5n7ZYDbvkY9hmb9gJaoOFWtV?=
 =?us-ascii?Q?bHSK3ILUOeUIQ0DfO1ZnVRu9sBaWo21L0wIOmpUCPd5T3qnkDiGj9qp4wMvp?=
 =?us-ascii?Q?NfTWY9yjgun/H64+msDhEAyP/sQJju40XT88WrZhZjinFwjf2ClR6fkVXz12?=
 =?us-ascii?Q?elTUZtHEeP4aY5ofMsHEa+szwBpTRgIFsqUG+rB0Azq6wgylsdCpP/sOI0TC?=
 =?us-ascii?Q?i21bi5XdBjNS+K8nuDe6dpMrh7R0ZBEgFDwiWqdbFJsNlAbgN6IhHrAs4Uhq?=
 =?us-ascii?Q?Z0NBI2a5btlGP/9n8az1Si9gL1NxItrB9jqtJieAFkAudevj3XPP+4f+R0I+?=
 =?us-ascii?Q?F6ENNwGE4ZunL2/ExfUqKRjXmylvy3haEVkYrmmmDrA/pjAochQ85WGyfFLP?=
 =?us-ascii?Q?T3TosO6H239SwIPR17liVwYSo9g3eQTFx5PGPO2CMwWpJ2TNrbFn1qis9H/v?=
 =?us-ascii?Q?e1pCCMGovpajCLweNZ2fIxeqSxsSdpoMAiRfy0FrzQBxqoc91TUce4AFTkLP?=
 =?us-ascii?Q?BA8AdnfvmD9i07daN1Lc191ORS0RGoj3M4VfSqMZ6W7/3VkbJ6foc0wUG2Ai?=
 =?us-ascii?Q?Q2fMrp+VQw8fBdCfpd4xzyBNk8jUtfs0rxLCVbWrkcFHxPRzl5qxfSYM0Vhw?=
 =?us-ascii?Q?tGufvKqTJ62bD98gkiVV4X+xJOOCecUGY8e+Rgd76wvoPKVvFHBJJutnmiqy?=
 =?us-ascii?Q?LIEyXGbA4Iqxy6uvE9aTJhc9WuEDpkXykmMIOFn7mybEqnPHDPEDdJCRQ9HE?=
 =?us-ascii?Q?4X5IN90s5S/Vzj2myCRU1/UbJs26zee6m7KdCKxvhGG1w/TrKFbacYnWJ9bJ?=
 =?us-ascii?Q?ZHSvgKvuXG9vKinVj4qU1T3PLU6hRY7pLTto6RNTIiL/tH3s4l1nZPX0pgN5?=
 =?us-ascii?Q?LbsNbocmRt8BDv1kg1h/Jcf6GFnPdQ0IrVtOoJEnLP4Iq/P+lkldQCSEpCm0?=
 =?us-ascii?Q?pTobiAN4RSyYuzGWANtQhC/+tJAacyDvJoJpyL9dEhA8UAf8yK1g2x8fGnGr?=
 =?us-ascii?Q?N9z96CqNfxqibg/SFF3fbpId6/Kte+EmT9SJ4NmnKkhk6G9VF8ToxIuzivYK?=
 =?us-ascii?Q?WEs6TuBh0LTzVbPLNyF3tPl067H8LZszrnyxQW0eMO0ay9fl7s60WdXpNsK8?=
 =?us-ascii?Q?0qgW9ceh64ocyUSOIrOr4oxq8xPzTqjAzyFfbEDeQhYBF0hoo4Uy22xFfkoY?=
 =?us-ascii?Q?Q22PzbB4x3DCO69Kc77nuuCKP+iU1E3mXgTKpFp7OuWXDY8nd9YN0nImmnIt?=
 =?us-ascii?Q?WBrbd9KYcOSAB9VRJSGm37QPrMNxEao/yGbeBgY0HmtnDbs0x7XxUG2KejF8?=
 =?us-ascii?Q?M96IsG0n/DnkFsXYdR82sKX8NznqLTY6iHA1rettEm4AQnr9hpDNgKJabyFo?=
 =?us-ascii?Q?0Kmgj2PGPwt+3PxOuIIiIFWnMbagJfLvkgWo3VFFKcxLhSRc7Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m6QtQo00S1h+JGGCeaRSkgP6MgDjjkXw5Q3kkRZPwtxH+xgK6Q9O25cWCLpC?=
 =?us-ascii?Q?FQOP8Efv6r66wWawRFTMcN5dNYYhVjMXDo9ahNiBdiBPLhYq6mT15Q5O80OL?=
 =?us-ascii?Q?+cs4PecUZaxQqVfCwDH1Ym1CgDT53Fjh1eRYKYptIcIKPGUAIoqdPpnptZTX?=
 =?us-ascii?Q?aQuD/5E/SaPP22clPitDgDFbVRLOOm/p6mlThwTxzpm1n0OO5jDHh4tXzhi0?=
 =?us-ascii?Q?OJUuXeAd6DEJYjQFtN2U3pPVwOt/gWfjkkJfXE6yW3GMzpFjtwapjbXiOT/5?=
 =?us-ascii?Q?klzoY/rQaS98NEDvtZM0E5Z1Xs3wKOHfoFDKY9He8XosDOmt0Mkz9lphnpsM?=
 =?us-ascii?Q?2d8REv4ws3YbegrthWt1O6Gi4MT3AZdOflJbv8evjG5z++7bi6ZvnrDEY9VW?=
 =?us-ascii?Q?ya++wfhsYP6LKOUONYiZfAjwbMkWUe3NW4CSdTQhflIb017i/FDT9AZ/Cnnq?=
 =?us-ascii?Q?qHqxdgbIX6fY6TrtC8uE1uEFSumBVvP0Fxf9cMzMfZamDRYVFYctFsM24dcy?=
 =?us-ascii?Q?FUG2RQugYeMDQOgpyNBH7hL9gVrE3tV/j/A+2RmOvkFtrvHBV6JR9MLKlZNg?=
 =?us-ascii?Q?+G1UPaRokB5Q+jSO+W0Gi/zCzMupbCs8dVbiHDMHH1hIzlgz5nXbc8rr41Pw?=
 =?us-ascii?Q?tQpC9C50853WjIXkOIZUp3nksDrEZgZd3RSTTEMSutHV7LrD4BZ9ZvcTwhmP?=
 =?us-ascii?Q?2DLhICwLDkUfCY5MJQjyzhU6VMrjfw2rLneinX6oZedHJea8AM9Aj4CVmw1z?=
 =?us-ascii?Q?FNgBNfdlUZcfyseJkxdia4nbvXCsOrthYcPOlQb2ZrmlCFbdqIOYMsGA3K+c?=
 =?us-ascii?Q?UkWNIxU/xoXaawpUZAT3++mQQgXFvQhHfv2ma9jzY38E5weRyGVAHczeIpbo?=
 =?us-ascii?Q?8X7uimVlzpTiH7MjAgwpSoDqqJohJBATaH4E1rqM5fdkaV3zf1HTCGgc0PGq?=
 =?us-ascii?Q?ptG5SAt3sNMiESKM+AkBub2J6YOPdzfPvz96SZQYccek4YMHs4uDYM9EZwME?=
 =?us-ascii?Q?nVosz94iEkFgaYMP03lO2Ox2vC3hhPywfnXQk1MvDO+Cr5SG3Hb+SBJJZbIi?=
 =?us-ascii?Q?zqTjMbxUqthvhwO1GnQr1Bo0MukvC4SoFfusR9yemICyNO+nQuZDOdI8oBu1?=
 =?us-ascii?Q?l6EpiDqaG2BWP+RX7aioyGsRLqyfIvLPTNcvYNk1FERPobhjmXcx1wNYbbW9?=
 =?us-ascii?Q?HglbM6eSNSD7r2h4jspP/NjCuIVS6u+BjDFRjOT37y64xL3h2lEWXdkdbskK?=
 =?us-ascii?Q?n4a6ottCdViLAbHHq60yq+gtnNF7qPLr8qlDh5OuwC/3eEqE3BRfTKc7LRd+?=
 =?us-ascii?Q?4khWCxnVt5Hd5d2nE5KAMK/kIBTxuKheTB+zE6rjkaUxA+31h/N73eqzPwOX?=
 =?us-ascii?Q?MFjWlcDhbi/xhFkPCLQMaDL9MWTd6Aqzoy5iS1atl1V57iSPMPRurFU78QO4?=
 =?us-ascii?Q?aex65E1CvfBHPigDo139utkAqmbjzRftARkkV7BIVwrtZTI41yqj2lnubGdN?=
 =?us-ascii?Q?BYsMCOaxHaOjvO2GCBE3eTPLzIb/Z2kuOxkwkTOyl/uATnnfUbAvtneDKPbJ?=
 =?us-ascii?Q?PR/eBL9yvD7cgOLpx3i6I2VHit26+iM0U8ruREzsUxHmte1EDihEVEmlzSV7?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2ubR5+cjKnsAFrYN5tuvt3VEg82DzSnuqUsPHz0dORLcF6yuzLWEl0kW/5NbXlR2Fylqpof+OUnS6jRPA4JLgi+4zTUsF7NYOE3ia8UrmrXnxCGIbDED4QvpbH2i3OTemeTUTuGU/uuuxVXrCzVRUyf60dEbDso1R/i8vb8yqPYU/kmPBbOQKMDmWfrt3D9YXgQIiIxCKJQw9yYlE8LSPXc5XC79JL7lBQKXLawmNudg1wsUGs8kjokruvUn0mczjmLWKsCHZWSb7hLuQX/PhX7R5eTZUZIaj5cGoPkw3khkafMEB2ldmGKnN84pvqRQnKgHLj5nSH9OzYOAs6AAq6nVDcDaNfA2ZF4qFTMcltfqQA3O+UQrJiUQq6xwKxM+H1u/6u/9D8uWhtZuU1zIaTZFNuU00C6qhEtaBkUyS4HJQStFt4ZVFtYraCbkct4v2wnT27AGQR0xHUQGpuJZ8IA8I1IZhFPokFa4Zb9srGL8BQN4N2lC3U36uUW34STDwlnzUq1k5SJyllPwAMQFeDFHVxGqlv7IGROqNLHe1ohnApLQdKlqTqw9t0hnCRDzRaBdDFQYbS1TFV3KFeW/vppL/kEta/2A+Yn+8d8btfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95906a7a-8190-4470-6188-08ddc87cd075
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 17:34:15.5908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZkzRZT+bVRT9xp6QHrhtMaf0NauHjsK0D/xdPc9m1kXmy7Jk2zgKenNZb/JIXtMldbTjd4NpF32daZsHffwIUEZw2n20rudDVCzIIVL7tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507210155
X-Authority-Analysis: v=2.4 cv=TfGWtQQh c=1 sm=1 tr=0 ts=687e7a1c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=GuY5gsdr9MwsYxRlPWUA:9
X-Proofpoint-GUID: SUIj37OWzoiD5esOy6-25CVXPZWYZ2pa
X-Proofpoint-ORIG-GUID: SUIj37OWzoiD5esOy6-25CVXPZWYZ2pa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIxMDE1NSBTYWx0ZWRfX5v5poYsFAGyP
 ze4aP/bkg+XHWBXgV76eWhVeOUi5oCN/mjfYcnGB0+ChAU/vWwRPUCPAaq6+lq+kKLhFyWZFo1A
 c9PCrn0udR1ztPvi7P1jYwYKFm4PGidZYmkKYC0SPIHEAva6wD2I2kBH2yyOfJOc6N7lzp6uIfk
 hRmAdmI7uRrHjwnbcC9c27yYHwzPyxJFu0z2/8RW6siNwlpLWzEhXUSNx6BmZzGm0daztooCgBS
 Z+ra2W3FV2/tZDDTWeiqZ0zmK9nPiKFQlqgSTGnqcL+E2UDmy7oaxv+r6ZFElwrif/h/uH1XGsW
 oDrLFnPgt4ym2dguPcqexGDZSa+JHk968f0ZsR4yfcx4jQY0NDJ2HFs2+YK5fJu2VtE2ogHc96o
 wjIBe2xoS08utKhGpScoypJrofhXymCj7C8tjwAXyoHUvliqFXFb41jnMT6IH8XqQ+vnu1r5
X-Rspamd-Queue-Id: 9C31A4000D
X-Stat-Signature: nk3qhzewuobwqkd8ehwmbcw3urh6sbbh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753124601-322223
X-HE-Meta: U2FsdGVkX1/7FxBnJnrCVsHDEkoyceLTwmtKQtTnaDe2C9VrP5SextLPFlfFXt2UwpywznBWp/3xaPIYwlBw9BrKfrIE+cBb87ES40NG8+8TJnbJAyycXxRr00nJE5kDYBtSsatTXjYb7+y+Lo6MM87QhN+zEkOShZpQZVMXve6rTPP5jxXxnAaBB4ZGsIMMY4dHnpmwOYEXlXnH4Du1jShhu9KfZPSLfUyBQJBszMHacsHTpDyJksP3XAMTPfjax1Zr6vvj/jQl4zEc6PelIGvjDN9u8YKyokd+PP3QV8nQBtvsUsy41UptG4OswYpi6gZy8QE66v7cH4rRajHdQvrhbTPI4cwRv99IwvOswyE4dlGz8aHK8bwblC6JosV9Rfi218PZ0z6gjiCUU8h0t9I/9lzfBgSSCjTq6nOOi2MVbvEjh/TZKMLtfgM1u0CzfZCoLBsL5ZTZfndFNHWicCIgOvHCMto9vyE4N1EyxcsTP+uXl8Jw7mObR0Lls5AfPmxcpUHF+4hWVJyB86hBxQ7vl44opwVvG/lbKafd6WmWX1G8AF5ctMglic/fFzEKewhTOlONDApUDr8iTLFjAUvErAW+qVQax0B275/On4HDPnM3f3klwH0uiWo/VwMLmEGJST5BGQIl0pHk+6kUCvOd1icO8QVXrH5DRHUr9FBENyenedLxbD3SJ2wk2H2lUk1LRdMHOK1h7Bd9L0D9v5rsOaiJuezPyRldgl7sYcHdzTdpqenwLvaYFjqHiM75AJPetPhSH9I0m+zQRvP90KStHDGu2fe0ef2Jmz1yl4Z2+HWlWVDRAb/THbUVc+O6ZInur0Nc2N8HwJ8nhumDu8ttAflTff489lzUhXw0KocZonVhZN2PKtOwL1ifvkBTmM86e3wpoq10AidWbiv3xSN8FJWXJhGRg4hqkUGSm5v32NVityz2Sxd2K49zI6qnIIj47AGam3vUhgtbPp/
 ShQKNp1P
 hUxro75krw9Iy8Qmj08Jl2Jc05CY39bUH1mOOhZEjkqZkL9MyOysyjSMjOcSdf6/d0abcsBt98mXfBm8ItAiJFMlQl+SYCoq+f3Fd3GxgV+8JJBZOUHU3Es6bCDd4xc/2Mp7RPXlD6p24C57hkbAmnbyrC7feeIjHipdTSk49tuuBlRuXSqga769RUDB38efRrlV62coRAZRALb0EwaP4gJNQShibclFgXxcwLIFE5xlD/fFa+sbrPe9e7xsUp0+P/ihx66MspI0W0GfFV7EGQ1R5l/tU6GXcpn7S7X0612Qy/N7whK9LbzUZknL6qyySpyi34328Vji+dzGlJt6axZPEkGyL0HS2ynHNu0wsmwHM6SBAB4/xzqJ+6tRShXBkQ5BPerNtgKUxi2SN3q5NBfHyekvqw+9KqSCljAGERFJzeM52JgSvG2FsoP6QXM7kgOu7QFI47PsJEaRomWmgNq4rRE3K/bIkQ/TfZl7FLsFQZ6RpM/Dzx/pIJvqq5K0WmQCJ/AdAMPT2qHXR0gcid/Is6Zgli75OcCDacbYvCLZLsnKic7TdbUqHWxF1u1rw/SNGa4kUvBMAZ2HHIPvAk0D2w8v0U+loavX28f8LN0/A8FL/TLv0qpR7PJp7oYCroPdRCYG5FHC5Jeato0jAtLbHIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check that moving a range of VMAs where we are offset into the first and
last VMAs works correctly.

This results in the VMAs being split at these points at which we are offset
into VMAs.

We explicitly test both the ordinary MREMAP_FIXED multi VMA move case and
the MREMAP_DONTUNMAP multi VMA move case.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/selftests/mm/mremap_test.c | 127 ++++++++++++++++++++++-
 1 file changed, 126 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index d3b4772cd8c9..fccf9e797a0c 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -610,6 +610,129 @@ static void mremap_shrink_multiple_vmas(unsigned long page_size,
 				      inplace ? " [inplace]" : "");
 }
 
+static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
+					    unsigned long page_size,
+					    bool dont_unmap)
+{
+	char *test_name = "mremap move multiple vmas split";
+	int mremap_flags = MREMAP_FIXED | MREMAP_MAYMOVE;
+	const size_t size = 10 * page_size;
+	bool success = true;
+	char *ptr, *tgt_ptr;
+	int i;
+
+	if (dont_unmap)
+		mremap_flags |= MREMAP_DONTUNMAP;
+
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out;
+	}
+
+	tgt_ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (tgt_ptr == MAP_FAILED) {
+		perror("mmap");
+		success = false;
+		goto out;
+	}
+	if (munmap(tgt_ptr, size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/*
+	 * Unmap so we end up with:
+	 *
+	 *  0 1 2 3 4 5 6 7 8 9 10 offset in buffer
+	 * |**********| |*******|
+	 * |**********| |*******|
+	 *  0 1 2 3 4   5 6 7 8 9  pattern offset
+	 */
+	if (munmap(&ptr[5 * page_size], page_size)) {
+		perror("munmap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/* Set up random patterns. */
+	srand(pattern_seed);
+	for (i = 0; i < 10; i++) {
+		int j;
+		char *buf = &ptr[i * page_size];
+
+		if (i == 5)
+			continue;
+
+		for (j = 0; j < page_size; j++)
+			buf[j] = rand();
+	}
+
+	/*
+	 * Move the below:
+	 *
+	 *      <------------->
+	 *  0 1 2 3 4 5 6 7 8 9 10 offset in buffer
+	 * |**********| |*******|
+	 * |**********| |*******|
+	 *  0 1 2 3 4   5 6 7 8 9  pattern offset
+	 *
+	 * Into:
+	 *
+	 * 0 1 2 3 4 5 6 7 offset in buffer
+	 * |*****| |*****|
+	 * |*****| |*****|
+	 * 2 3 4   5 6 7   pattern offset
+	 */
+	if (mremap(&ptr[2 * page_size], size - 3 * page_size, size - 3 * page_size,
+		   mremap_flags, tgt_ptr) == MAP_FAILED) {
+		perror("mremap");
+		success = false;
+		goto out_unmap;
+	}
+
+	/* Offset into random pattern. */
+	srand(pattern_seed);
+	for (i = 0; i < 2 * page_size; i++)
+		rand();
+
+	/* Check pattern. */
+	for (i = 0; i < 7; i++) {
+		int j;
+		char *buf = &tgt_ptr[i * page_size];
+
+		if (i == 3)
+			continue;
+
+		for (j = 0; j < page_size; j++) {
+			char chr = rand();
+
+			if (chr != buf[j]) {
+				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
+					       i, j, chr, buf[j]);
+				goto out_unmap;
+			}
+		}
+	}
+
+out_unmap:
+	if (munmap(tgt_ptr, size))
+		perror("munmap tgt");
+	if (munmap(ptr, size))
+		perror("munmap src");
+out:
+	if (success)
+		ksft_test_result_pass("%s%s\n", test_name,
+				      dont_unmap ? " [dontunnmap]" : "");
+	else
+		ksft_test_result_fail("%s%s\n", test_name,
+				      dont_unmap ? " [dontunnmap]" : "");
+}
+
 /* Returns the time taken for the remap on success else returns -1. */
 static long long remap_region(struct config c, unsigned int threshold_mb,
 			      char *rand_addr)
@@ -951,7 +1074,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 6;
+	int num_misc_tests = 8;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -1082,6 +1205,8 @@ int main(int argc, char **argv)
 	mremap_shrink_multiple_vmas(page_size, /* inplace= */false);
 	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ false);
 	mremap_move_multiple_vmas(pattern_seed, page_size, /* dontunmap= */ true);
+	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
+	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
 
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
-- 
2.50.1


