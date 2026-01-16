Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B709D47CC3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7BF6B008A; Fri, 16 Jan 2026 05:28:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFEB6B008C; Fri, 16 Jan 2026 05:28:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B660E6B0092; Fri, 16 Jan 2026 05:28:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A53206B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:28:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CB5959931
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:28:32 +0000 (UTC)
X-FDA: 84337452864.12.024FD78
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id BDF86160005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:28:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kY4XDTw+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=duHXrtKv;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768559309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbrnJVi24Plnj3t9QQxunZoQhalkIBHPiTuVT+Usw+o=;
	b=DHf+/sMXPPi+Nw5yQnywag5gKYi7KeDTOFaUMed9iOi/a6BRpB8S7PIGhCqcBbs9WNwyI9
	bMugwt5PALjehOAoxT6l+e6YlXiJWCOhIDGDTpZVBy7GHhMEH6QuvoOAosu1VsgfX4IHEz
	O8b7Vnrg7Pp8V6117DMEIsRTZU+Nl+8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kY4XDTw+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=duHXrtKv;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768559309; a=rsa-sha256;
	cv=pass;
	b=oYvbf86XCtvQnORc/thRJSeAaUKikHv2yHzO7WMkL0y39kSBdnat1g4LzfuQjgk/4Z4WMb
	VPE0k1NQNKLG6+B2GLtXeWquatNxCVtVllCEfsMSlSgKfZgPmyP0gQB7el5LfPCkLUnAbL
	4FuongYW2GcEoj1nKqsH1M3t7MkNMi4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNjRZ1431774;
	Fri, 16 Jan 2026 10:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AbrnJVi24Plnj3t9QQxunZoQhalkIBHPiTuVT+Usw+o=; b=
	kY4XDTw+XBNrSoF4dmpKTsjsqi6OCZo/GiXRw4JsGlkU7EaeT6vdKhgo9H69s9Qo
	cEdxk7aQj+L8Wz/SD5GkyPFviYEYYrONiEoGrj4gUPtSAl8Ohy8aihHVcSzHesIs
	nitZmUr1xzJvqZB059T7u7k2hlgczbgDjzhC4oEfcDUPxbywu9GGQnAfsA/VvtGY
	NPZcIUkQA3smUvBtuPSuaaSswN3aPvOJhfvLAb6nBMwx1MdgPwm0i8CZGxhV4Ner
	rNvItPqi9ClyVXmAVRa5nfmdstaJyxJp/3odjSjkSQ4Z+NnEckn919FMHNymv+iJ
	ThgIFYmIiZjr5gUp8KergA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq59rhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:28:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GAG4Xo029363;
	Fri, 16 Jan 2026 10:28:22 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012001.outbound.protection.outlook.com [52.101.43.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ph50w-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:28:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FVz2tmMU+4oLB0Xw26iApjpCzX8Hs7TeQRucW38CLyDTaZzBx30c7OrAznu/RK0hVbWxWQ/vdXokT3Xe0fYa8N1r/5yXJOKb1hvLwCD+Q+Xj/3+/VXil0tekWAbhGitcEuiJLyirs19BjBib+uh0pv+g89Z3BMJzBETdLykrkqESPbOuy2/s1YDYyif4Q61NO9K41JRKuxeVos4hMVeacbxbcnU01Kq50xzmYXW3GlzvM3ROuTca3xp1RF/hVddvQ4oGA/7IuScUCqASdmDic39QwxEyPkT2UmPl1cw2d8Zq1Eq7Bbow74nBmb4mwPeBGN8bMJ4WhKqHP9PMCZVHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbrnJVi24Plnj3t9QQxunZoQhalkIBHPiTuVT+Usw+o=;
 b=elzBFwkQEgZIZV4AkNBBXgjMaigRfbwCF09I6qUbVUgeOsPGnPdw/9KsKs5PUHamK5t59s5uNBI9+/M+RbZrRSk43BXZEMyrWMSXX3t2K6k0TY4YHwAKzTz5Haf/xQs7rApIT0s+jgm+aGD+seXrlI5egw9QTwXLrGgi5rY11rs0aREJebR7JU9XzZ7qzPmd7Tiq4nlAIiSm5Zca/JqoDqwqTNDtNcyIoK7cD9gwJLhQtMGH7xtXcDUI9k0UIVmIS0fC6NuOkcGjcAUs/3i8+2WMgDMrN/Wxv8fLiMZ+BdUIrANNuDtbQ9dSWcFiybqwrmfIZfaiU2m68ru6YBHreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbrnJVi24Plnj3t9QQxunZoQhalkIBHPiTuVT+Usw+o=;
 b=duHXrtKvsGbXGJXUjckmg0bpX+ZpYnHUHyLSKt3ZrEiE+nzzo9doFTUPSPxkqjqmxLoe7zcwZZ2V5xI1AvI7qEZZKBl4xywjyoLIaMvampNw/mk61jjj2YA7YP5lgRoO8+IYLQ1B0IQ6zCxK4xZ+ctrtG2rfv0s3szxFQairiuM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6084.namprd10.prod.outlook.com (2603:10b6:510:1f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 10:28:00 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 10:28:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: add + use vma_is_stabilised(), vma_assert_stabilised() helpers
Date: Fri, 16 Jan 2026 10:27:48 +0000
Message-ID: <0ad01ca9836e803bbf487716d2d750aed56c008f.1768558900.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
References: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0055.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6084:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f48c3f5-2b34-4a1a-9fbe-08de54e9ec57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xz3rMPkzI9xSOuUIfmWGpSXI1PMZZOalVyn5Jekme52liwu/igoysznlFdnk?=
 =?us-ascii?Q?SDepG7rHBazgWH7wLbqV1d74x1TPJ4fGnJ5LSRXjiVNfDfvAqdBb6gNlPVB/?=
 =?us-ascii?Q?A0cpEUA2xyq5GCUoffJsY7Gpve4emMiSMEi3MlnriRm95dVm1LDLrbXCDQE4?=
 =?us-ascii?Q?k0hLL8m3OJfezZe981x/GdSnxuIwnuP1dHIwLITzGWKUa6SnYoSIHC2lQ6uj?=
 =?us-ascii?Q?OLAR5JxSKYSvGlxB1PJ6rvj9H8/uSGJ0INDeNQL3LklIB5oj42twOk69J4Ac?=
 =?us-ascii?Q?HwFvcWgB6IazE12FexrNhLYTmLYSDSCIjWvLqw4t99oYpEpcTWkkCHt/MZkN?=
 =?us-ascii?Q?2Rk9PYcLQ/yiOKFt8iGcsA28VcaxYTqK+qCdTiamkJdUy6N9Tpm2h0LzLIaf?=
 =?us-ascii?Q?I7zNZ4C3x6e+VvEpwUq9zaW8Fep+UPdzGebYYOVh1ybFHcEpGgcM7jcMrlIr?=
 =?us-ascii?Q?myRtvi5Sg4/1TDznLHeE4DgQuWjhQf//DOrwA/TddEQkDRa7HozXQw1LXgtT?=
 =?us-ascii?Q?Co+znD1J06JNjL689aDFPl+dwGHF0bQiU7amwzK4CugfH7Qe4UF5CNO9JdJZ?=
 =?us-ascii?Q?Hec2QkhseDSA04k5pcOySwYlsa+JJuqaIQ29SFCD95AdFYtrHRTrIuMRtM8K?=
 =?us-ascii?Q?PdM+IRyY1gn7CLo9QZOkPdwWosGk2iwMV+NypjJuVPRweDVnnx4/aFFaD1yQ?=
 =?us-ascii?Q?mIrDxkN3dCJlRA/rFuJPp93qnp8Xbv5amW4vP2d7PA6XYB+nTxg4vZ6y6JFb?=
 =?us-ascii?Q?7gUMchKhjg8GFCWFNGvv3KouOg6V1WT6Z46vH54Ka4lFrujq0qXCdGD74tuZ?=
 =?us-ascii?Q?MEBZs13HH6yuOYEu/zpLsDl82vu9DpvUAeUnHFQSGOK0FuUb0uyKjh5Mm3Dg?=
 =?us-ascii?Q?QCUOpUwDJN5JiRIpSrmDlM+Rf/pQWK5ioyGHNBSLVMaXRJw6MkpEHxnW0uev?=
 =?us-ascii?Q?Eue2dJ7A9LnTa51yrRSNXhrBuPOCAIirgIl+RjhFZ2w99pK/PS874RsNyGOX?=
 =?us-ascii?Q?eBcngvse+vGk6+LqlHIRWVXVD9XAWXIfAtepu2aO75yWbPNryQIysXhZxNfZ?=
 =?us-ascii?Q?d/2Y2mcJBoHEfM08xmaxMBSPRv47t/oPks8IrD8pD2l3wqST3L/DR70SAcmb?=
 =?us-ascii?Q?4mMMaocRlByWX9aQ5sFeLKwR/l/C5ytxn4JWcSQUg34WSJ0/6zQtNPomTSl0?=
 =?us-ascii?Q?T6SDh76Q70SYeuZkyBJ3d+DyGmRPKpTGOggqNbdymTckGiDoCdIVpGMtk4dq?=
 =?us-ascii?Q?FpijPn6LdjFNDx3xmSRE7NQYW7NIaHBCYFxiBTylWnM3HzrjKwtCV64AqNbK?=
 =?us-ascii?Q?Mu+vV8lDyTTa8GkuOoZNz/1iatCTR++D2SkvTH1uPO6YKcb4oxnNstXtZUbB?=
 =?us-ascii?Q?jN77aKNbpUXh97ILKegQr+Qw13pwmU42U3XFexCdCzs0fmepAPExke7YglRq?=
 =?us-ascii?Q?2h54BBKYriak/51YztI0qyqC/tAcn3d3e/ru1hAzyDz7pDoHSfKjGBIrnznt?=
 =?us-ascii?Q?5acb/craIfFpYZAlp1r3VWyKUIcOzq5a48QmE+Y+tI2rHT2qsmOZ12nqlv82?=
 =?us-ascii?Q?AE3dDWzHzDvcEOVlA8o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?69xMkxL5rltiFYpnBCa4G3Fdl47h4PGiUicXktMVkbIJcLunYICHiM0UhXX7?=
 =?us-ascii?Q?Im/gt+pfXJ0VJkCJWQac9MyfpcHItysnJtJd0qO3FJSx+LSQPb9vjuU8hlWu?=
 =?us-ascii?Q?ceF9oizC4xzd3ndgAsyoKin6jBRx7nYYlek41q6n2srr8vD1FmV3V9vzn3Ua?=
 =?us-ascii?Q?J/65fTVE6AqW1MgZzpKko92siAkA1JeZfognY4tAIgCuHurDUahsJiYm75w3?=
 =?us-ascii?Q?9e+gyy1A1CAp3D3gqUzgf7ktrzMY0vdyCUu1aK9AJ029uZfxcxJKBjU/n2sB?=
 =?us-ascii?Q?hposdBMPsD4ZDZSHoBLWGs066rTg51+NPKY0RF2z+qK59NCrrmDoGEi7SNlk?=
 =?us-ascii?Q?j6qXPh54qfNl5MxlnDijA6z3e9AatGeTCRoC93vdCAfWfpFSPesrmpHhSXzR?=
 =?us-ascii?Q?WALBg+XnPStgGZCeoI8/FTVf0xLN5i5cB92WiLMJjKfTBx6IFsI2NR3DxZHf?=
 =?us-ascii?Q?oJ5yN9CyBbW7TYd+VPqwAqCmQ8G9orIyHNUQNj/exGXn0lNJsHV2m0rZNs/F?=
 =?us-ascii?Q?CU1+bzBmP00wk+tnDyarIxyGZXfpDUjcXiK6TpwBnTbNVoPT0ZjIsRqTkv3w?=
 =?us-ascii?Q?WIddcxNnaFWL2owDb2q90wU7v1zTZGxFnEF1IPOydl8Hy6TuIrrprQ24fyzD?=
 =?us-ascii?Q?e04wVbGIrgxvMjPdiYmFC7VN9I28+0hKzmssJLbNm7Bl51724uP3lbHq/nuK?=
 =?us-ascii?Q?ocTHgB+woImoOyPRtYg3xdlPkm4p7v3ho/pHPgcnwS8tTYTBCoencl4ABfKR?=
 =?us-ascii?Q?8lwWnBULjydbUyDwYhqEyWzi9mZLeZ3W3FgvW9YRAvVC2kvmfKQ3I/auhqB5?=
 =?us-ascii?Q?Xu13J1aR8hQV7F8EQUnL/Ff+VGZTy3UOWCM/k58exYd1j8jSba9ZibKGTUCv?=
 =?us-ascii?Q?vwjKuoEffUu65Egj1zXTMXbUdTmfPmw9Z5hHfUpKUMaSm5SDzOa9zXb+1NN6?=
 =?us-ascii?Q?m7MQb3gaf6mp7cGBEZXOYMVWOD4/LGbNQ1vOHwXKtbDL5Jq+E6ggAIBMpHVw?=
 =?us-ascii?Q?FjhbT6T7Q5rcDI0n7+0qHVeJLqUGBcDkBxSh3k5Xxi4XPYerAmvptd9g8Q4I?=
 =?us-ascii?Q?mWV228MCVOXH1F40XUWJ+7pv68OIE+JaNpNk3CwsnQbCf/vDBk3a6kP262wo?=
 =?us-ascii?Q?eArueq/buREH0OSEhN5SrtISvzLHfhj8sXOfbdQYJ70FN8MQ5Uo9QeCvLEON?=
 =?us-ascii?Q?M0DePJsn2br4DMh/Bk/ZX8lqKk6gcZIgJFDFTQc1GSCGaoJS+wMSK5VPZE3R?=
 =?us-ascii?Q?BJvPCKaZE/eDldf3GZCgyYxRgoVIY2vKHQOgjK2Bt+oTznOUpmrCVhqA3hbN?=
 =?us-ascii?Q?jrcmkCP/bZkASIm/A0SPAjVu3BQ+B3ef1WV3uiCt9xzryeCSUH4McoU/VisP?=
 =?us-ascii?Q?33v533dbUgauBvwgWoa2llZTYI7+ce1DUaE4b7oLwU1DKr9J70F9g9HIJSnY?=
 =?us-ascii?Q?uqJ7Xu5ZLJgl9l11s5u17S6WhGDd0jYEIcWrpRNtoOpqjCmW6nWM1bpsGKv0?=
 =?us-ascii?Q?ZGvi+INnVMxEjofk+QkKHTj2F3J1aGekSoGVcon4TuFoNL94nP30pPkzRmtO?=
 =?us-ascii?Q?VB8G7wfN/vJC5F1uP8Up+18cVjxmDaEZ0aP0p88ROGYVN3yUcQIldQdEMMPV?=
 =?us-ascii?Q?p6oQYhoKlcDpnwkvmk9uGe/DOEgwdN6LgtnEr+F001yKQaA9MmtRIU3jc59t?=
 =?us-ascii?Q?cc24cKPdioP8I93Kg9XXREz8H6r/61Ppqc1pSkwxt4c2qeeff1dESdx5fPhu?=
 =?us-ascii?Q?UUugw6H6dhrNBYM3SP2N0IDAsul0N3w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cldcuhXBiuEdshxNrsP+FnXDjX9+MdLxd8bpZdS2GApA/kcaAwEc93yGeaMQrW2e+mwLARhdxyPAGBQZu41PTdMqJlUEJZUcYMzpb+Z1pWTKOXtpxciCSi3joeEtssrexCCtlLv1/D3EfnQ2Y0YsvPAuhq6ytTYWJbUmtRVhEwsw1sl9U4vp1OSb1dPH9ybi0XBO+hH9ILmbW5EBNStgeMO6tAbzfKzBhLvXtYWrIqrqjdDTgtQI4BP51UPVvGvnFOdrpNwM/nQnTwSUsW9h12683bVmpd/0T10hSW8cZSlQziOJ86/uKA//2n30o7dwkgkKeppIIfqzV91UxfaPnyyGXJ/0BmW7imkElux9mq3NI85a1GQwLZk3xwYKEmhopsR0N/TsxN/FOtorgVZkWJ3iAchhrVpvLKRfGsP+iWWbsSpgn8N560K1d7R3wr2eT5XvtUdbvTT6WMouRpX3kRFOB1I12wbxXRiiWS86KmaWhJdOqDWkMO8t4h12vRjUdgwMvfBDGaeFWZIa1hg3ph4cQXJEOsnIC62pBjrcMkAMWuL+wHfQTAoQo9RJTQoFzy9p1puq03JWyNDjc//xPTamEiN9zhCZZBhCWFV38ts=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f48c3f5-2b34-4a1a-9fbe-08de54e9ec57
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:28:00.3896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqbGp5qvy+lvGcFzeJ3z0WUWf20QZ8+wT4Wh4vN2W81cDYdkT/AYG46LeRliSavAhkHhof4wWogAUGHt1IudpS2cDarOH36IEHPiWv2yOsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6084
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=953 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160078
X-Proofpoint-ORIG-GUID: D6p5f9j0U0O4Ukwkmmfwe3UoAUpH4Aic
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA3OCBTYWx0ZWRfX2ofEQLuNKPY0
 6PoblsV5BJyMkXtzs4qbGx1RLUaPvNeG35D2eWbf8wBwyc3vZTmq1zkmwFVPl6GRiwLi0mr3wep
 xCb8zHq1Q72aBfubwxwsLi/2wimbPhgYxcDN+iCTje1oxIW/zjCYL+iQB7mFdeD55IKpnHYZNM7
 SXlaPZNsqSSH6O1cGrU5XmdZjwsnNTR4uSxrE2Tb1/5QOR5OXkxXDW1shQzxDxUEFD5ueMPWK6s
 tHh4xbRYUenFoyGlHElIAJlz5zOq1oUwg4zse+eW1MTei/h7HDABKkmvR0nhdCtOW/Ug0Ao8Swa
 rN5JjROdkRbtJbOXPTnCmw8dm4doX49JNY8500vVgp5Z+4FkPg1rr1sfsxQHi2esF2R8EBBm7/C
 SEBuJnPkjN3xvPbVt/r3soXUbdKzJyb3CD3KG8maFmce9aVusI5jgdWyUdlsW1GZiAIiejPRlTy
 3pHHFyEj2uc5JRwIag1gOFdPxG/s19/xsWnlsALs=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=696a12c7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=mkSj5z2EsP19l_LKqfEA:9 cc=ntf awl=host:12109
X-Proofpoint-GUID: D6p5f9j0U0O4Ukwkmmfwe3UoAUpH4Aic
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BDF86160005
X-Stat-Signature: hja168gyro8s998wo88wmaxg3b4rhez8
X-HE-Tag: 1768559308-906139
X-HE-Meta: U2FsdGVkX18GwObgOxTC2Ks8gK6zLHpEGIHO2y3pXQNwIuhb7KJCRfh5EFatY2yI0fUaShkgc73+GiCdGw5BcGCH+rCMjSwQQ0ZfHlcVI2+w1GDPM1y7zJTz9+MNB7LqmWoq5r5u7V0ifgu/BBuGixdCDiVT/KQJL1QYqQ/XjuyNaVPH7igtFM4zy32I7QVUeADczOC/Wugz24ojt4l+KoqBpIx6Db3owRdagIGFJFjcm38GtOmAb6r8FV9CGzPHLOzDEUadS9RD7QaJkvUz7TpKSDKhaacoEF60TPrWEJddvkW5L8Q+oaGm0dYdnuegAjRzrD2d0Wdh6MgaxjDPDNSU0UDRFf/OWXOH2Mejj1+r/OxEvi9FPGBWzKyvenzyWqKtCP6gi61E3M0TlgGLsNKUermpkSJLMTFDqIBj0KWLbTRA1OgqI/cDuLasf9inTMuiXS6j0wPfbAMOXI3AM1MxQynrUmAYEDwuj9aIMmXUQeBnxco2eP872ZvKPXXm7N2JKXjS9HvZm10Qf53ANIyKiOOxEmjd6SqXRWZ9eYA9GsH/l+2hNj2qgtcPmmpoMDEIlwQpG0M+e9LKBQ6NvHdnDVjRsKDUIfYq6KBrLA7qSRl0eQop0e2G9v7eiBb8zxBSLFrvTSEN6GlvdGa5sUd86W+jM1yVWeVO/JjZu52RST5R8TsvXz/dbUut2ytMcOoFfePBCxwlc0EwcUiPLZOmGpCi5LcAIl41zA7q3fcMchdBPgq+Tx+a5vzuZDmU7iXNSHVZH6a8aZ829OUfGvkWJiVdbYBMoVCa7djrP27EVa0YHt/TxwsUM0O0XBFW4QtAf0ZO08GSZpsN0TBgFcOdqWRkRPC69mUAr92uiREG82FaoNVwRsC3xw73xjJvC6h/dVFO6fnYyB0UCCmP/Bta0VWf0fpQSuouX06txlI5S3JN/z9Um3kRptlblhTM89Ah3wayaOIHtR+W8UY
 NwqIxGnO
 +e5MnZFNLKkZbf4lVfFa4yZ85SCRDg0CUyy9ebaXn1cdxtmEdkTxUFF6TvPesVOLaweD7AzC4EVBIYB+Wnhb+GSveVunP0Nu5Sw1dhEXrReUBAzs7SGCl6/KOgVqJOWZjmrujlNiNNokYYih9HfRkuyyh2MaPjrPlL2GX2zHAjXLRGWykbc8H5drhChryKEfmuG5g4NM4IYQpckvvDEC9QI0Lf5KOOlhqsJVdBUa5lssCovPjm7r2S0ArVQdwmmWQbYwVM08c07sm04iU8O+z0vziMascbLOfLstZd6+OYSaVsUCA2n5OjbdEJFc0+IZosSKZ/+95US/8HcwrzbZM3e6tufDb1TL9tklkggxTJupMZiFq6c6wnLMYOYwkQbpKFHla4UPVxPHOHvFx5JPaxcJS0KMv2kaofMsnj0lhQUXBVBh5d8JulZf6duAEf18MrUMafYt/jff6kCHHx8dNlBCuzCKjaidAijld6fxV1lF7jg1St3l/hKx0FzuYvDcOhuXaEzaXCxTN4y7W72zrpHYd3Ap7jCO64dmQHpd8iwoSZfMEoM5mutLAWm7amRdxqwymj7SwZoqDTMpDj0J7lbftJCLXETZ4fWVH3vEXAKzlvfKhddb0SGqo9WWf+QU6Nv2j+PBt+oEtO3sElvW9jntu+RaK5z2F8cP22pizLDfsB9inO1qnA56PWWYBqLjV9DEts6bLLCSdPn4eep8YgKysFSaDuGv1YrNb
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

In order to be able to do so this patch adds an mmap_is_locked() helper as
well as a vma_is_stabilised() predicate.

We specify this differently based on whether CONFIG_PER_VMA_LOCK is
specified - if it is then naturally we check both whether a VMA lock is
held or an mmap lock held, otherwise we need only check the mmap lock.

Note that we only trigger the assert is CONFIG_DEBUG_VM is set, as having
this lock unset would indicate a programmatic error, so a release kernel
runtime assert doesn't make much sense.

There are a couple places in the kernel where we already do this check -
the anon_vma_name() helper in mm/madvise.c and vma_flag_set_atomic() in
include/linux/mm.h, which we update to use vma_assert_stabilised().

These were in fact implemented incorrectly - if neither the mmap lock nor
the VMA lock were held, these asserts did not fire.

However since these asserts are debug-only, and a large number of test
configurations will have CONFIG_PER_VMA_LOCK set, it has likely had no
real-world impact.

This change corrects this mistake at any rate.

As part of this change we also move mmap_lock_is_contended() up in
include/linux/mmap_lock.h so we group predicates based on mmap lock state
together.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h        |  4 +---
 include/linux/mmap_lock.h | 31 +++++++++++++++++++++++++++++--
 mm/madvise.c              |  4 +---
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 44a2a9c0a92f..8707059f4d37 100644
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
index cd51e0a43c76..d87a07608295 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -66,6 +66,16 @@ static inline void __mmap_lock_trace_released(struct mm_struct *mm, bool write)
 
 #endif /* CONFIG_TRACING */
 
+static inline bool mmap_lock_is_contended(struct mm_struct *mm)
+{
+	return rwsem_is_contended(&mm->mmap_lock);
+}
+
+static inline bool mmap_is_locked(struct mm_struct *mm)
+{
+	return rwsem_is_locked(&mm->mmap_lock);
+}
+
 static inline void mmap_assert_locked(const struct mm_struct *mm)
 {
 	rwsem_assert_held(&mm->mmap_lock);
@@ -253,6 +263,11 @@ static inline bool vma_is_locked(struct vm_area_struct *vma)
 	return vma_is_read_locked(vma) || vma_is_write_locked(vma);
 }
 
+static inline bool vma_is_stabilised(struct vm_area_struct *vma)
+{
+	return vma_is_locked(vma) || mmap_is_locked(vma->vm_mm);
+}
+
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 	VM_BUG_ON_VMA(!vma_is_write_locked(vma), vma);
@@ -339,6 +354,11 @@ static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 	return NULL;
 }
 
+static inline bool vma_is_stabilised(struct vm_area_struct *vma)
+{
+	return mmap_is_locked(vma->vm_mm);
+}
+
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
 	mmap_assert_locked(vma->vm_mm);
@@ -444,9 +464,16 @@ static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 	up_read_non_owner(&mm->mmap_lock);
 }
 
-static inline int mmap_lock_is_contended(struct mm_struct *mm)
+/**
+ * vma_assert_stabilised() - assert that this VMA cannot be changed from
+ * underneath us either by having a VMA or mmap lock held.
+ * @vma: The VMA whose stability we wish to assess.
+ *
+ * Note that this will only trigger an assert if CONFIG_DEBUG_VM is set.
+ */
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
 {
-	return rwsem_is_contended(&mm->mmap_lock);
+	VM_BUG_ON_VMA(vma_is_stabilised(vma), vma);
 }
 
 #endif /* _LINUX_MMAP_LOCK_H */
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


