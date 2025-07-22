Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10F8C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B791D8E0006; Tue, 22 Jul 2025 13:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B507E8E0001; Tue, 22 Jul 2025 13:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1EA8E0006; Tue, 22 Jul 2025 13:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8AAF58E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:10:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0D775911E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:10:40 +0000 (UTC)
X-FDA: 83692539840.16.E95E0FC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3B19818000E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:10:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hybww62Y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YpG9FAMV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753204237; a=rsa-sha256;
	cv=pass;
	b=Bxy6uBK6GWWT8v0feP6sOAexMcRuQj3EnsrbESMKAoecEutQmuRV4+lDicn7BbtDu9g7b8
	UOpgvn+38C0HnZXFm/WBOu9DWfVvXPUZgx3ZP1rZdFc69CIm9DZfIBED3bUqZLMYHshPws
	Ng46K5yWXSb+o0yfwLldb9GkcYMweWE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hybww62Y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YpG9FAMV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753204237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YYwj7Dy7LvZchDCnBu/9KmYzYaBvXXKph89lmT0qfsQ=;
	b=g1Qdp9b3OLhJnfs0K6If8rZz9K5rGZNBgY02MRb0zmh126uONCQ20yeqMuuA+u955gDLkA
	PcWdS1S5jEsX6V9zLNMVTJdIWpfuGPrLCeqLqmcd/H9tDGiIgv620Uxe9yfWqvB0t7tixD
	PBgZ2rWhWP8TB2QQ9ZSEF/+p3DniFEM=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MFXrl1028512;
	Tue, 22 Jul 2025 17:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=YYwj7Dy7LvZchDCn
	Bu/9KmYzYaBvXXKph89lmT0qfsQ=; b=hybww62Y/XdAmMcxA9evAwd5Itl5RfEJ
	ClfM34s8SoUAUwqK3PB351serhJZRO5F+kjgx+2MnMijVd9DGWk4qiml2PVJhRiB
	hC+nzQVGtbMlYHOLMvuH10RCP+omzuW2ePo6uayfnslWV0wUoZh9jT8WJIO7gh+1
	neKIOQbZIZ/uK7L4+Fy7tuEukioO61BzMY2PAxIzdP+Uz4rdBYW+UnkcvMpd+zRp
	EPxzQzua/gZmOvAcJguox+Cyz304TCklwj1MMI+t65TrLAGwU85Mo15YSwKrGka+
	75Wf8S9+HAsJBayMe46MWFsDgVRQqwejiYbLW6fQbsPWeMOlA4Kqpw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhrbam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 17:10:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MH7p2i011064;
	Tue, 22 Jul 2025 17:10:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t9kmhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 17:10:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X3KF7F/7/Cejvinktumfxf8D7tICaRGckZ2iqdEEM+dLk3edskRXoFiGNfFzKi2cGT5itql23s/6KWA21tAV18cB2PTYutr9YSnZ7EHJNfmSd/WSnkerh1nFfEyDQALt81HaH/280RlGlh/EVXxmVJ4kqUPOq3hPXu5rNNs1huXKokUFCVGbFCDZpTZWGo79/LqDiEJPkFS8RoJ1zpUIPIjHYqd7KA9nfcOLApQqBkKGBPBxTnNwUlDAGvNLJod68wD3cvBAf/ZEEzPzABHRJmHmNsmuVPB0I6AfpHPDacY0Dsqco6IkE3/L6eklStZkvVhELtQgDIhVaOP895Nm1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YYwj7Dy7LvZchDCnBu/9KmYzYaBvXXKph89lmT0qfsQ=;
 b=G+4fY3HSuLHCBeghcpeZOjK7kS6CZs11NkS7WKKtGHoTi2T45I0wmGIG+GkWRlfpma1/QGqpzor523sdSb5Sw6WMJ4NQLOq8KSBJAwWZOCldjAETUVxc9F73Lhv8dFMueEos8OBdV2RMnPHIbQs1ERvHBnppXDGisBh+MMvOmYNrsMh1roGxw3/AAUAcd5mARMs3dZBjC1gUhjfCJ1U+uGGEuz0V46b5+62tnx1gV0zqZCzjdl7pF1WPLW0i/pwoBZX75iQfuS+UcBCaEXdwx7AjpvScJ+8HTOJJxfZ7R4NMSlwVRJp/aBN26jPhYo6hEkBlv+yY8WF3ngEd4ivPcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYwj7Dy7LvZchDCnBu/9KmYzYaBvXXKph89lmT0qfsQ=;
 b=YpG9FAMVILX27154LsCsvgMS6pork/KXNita75AvBYeJThHFR8DaPrtEZhl2izqCKk+z8RjF5KOfp7eEPeEoPt0qaKt0Ac8eL5wYVgAyzP/3eMst5QNA7lL577pjO8I+OHOFzpNHHN0fOLrly2N2BI8GglxqlISYNLIATxNnZb0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB7803.namprd10.prod.outlook.com (2603:10b6:510:30d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Tue, 22 Jul
 2025 17:10:29 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 17:10:29 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@gentwo.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add missing percpu-internal.h file to per-cpu section
Date: Tue, 22 Jul 2025 18:10:23 +0100
Message-ID: <20250722171023.139777-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0203.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB7803:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f71ba7-72bc-4f21-4dbc-08ddc942a884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X5miyXVOu6yU/PXrGAal5WQ+l+y1UEzxtt7hK2PGUcqkZo8chc+k9R5t4PcE?=
 =?us-ascii?Q?8S7yRVea/QEP5kBiImJlMKvmCaYP4Ke0fuxA39bEBRfr3PsqaArBXyGI+4wU?=
 =?us-ascii?Q?zYz1SyyOWIrf7yizLsgottUxS8GH21qLgwk2rN+aDFgQfxqGUZhuIP2hbMN1?=
 =?us-ascii?Q?MB97/h5dSk0K65FbJ7xi7UfqwHeppoux/sNj1FSf/WH9u1NnJlqcLiHLwXx2?=
 =?us-ascii?Q?UOsPfZVLVP1dBc0Qf7TCv6Bv/tIbgLkpf0QKnn/0W1e5WtqkfFmTMOapUsiV?=
 =?us-ascii?Q?ASOBFCsw6ySExpC5Br1qwrC+/9ru7uS/LMycy0a4OSkfcITdwyvJntYBPTGS?=
 =?us-ascii?Q?6Bo4UYQfS+xwGULb4bkBrUbzdtxM8YrtVDlutvZ9XsqhxOcEPN3j3Syxw5/1?=
 =?us-ascii?Q?hk91TgSvT28GTkna2B4jSw1fXxwy3Fb48/YVW8BZPYByRY0g99zWF0MXogvA?=
 =?us-ascii?Q?5PKJVTkbTWaatdFHzloo1j1Nx5C+h49mWPEEup/cPten5lXpgQOgDV9O/Yvh?=
 =?us-ascii?Q?lFsZu0PtQ1eySKkEbd/I+3yCw1RabLBDsm1a/vgjDjGmPennEIdZl2RKSzNx?=
 =?us-ascii?Q?xJCecmoyyBt8v+Qf986ybRuG4BUpS0yZMgiOfz52GG6mHmm1MEAT8Be2UT4K?=
 =?us-ascii?Q?JnWzBjA6mf15aOMS40FZxW16MueCtqJE/NFkM9Hy4X57kWAjbltvmuVsDH+M?=
 =?us-ascii?Q?2KCCXN+puj1Jb3upKtRVC5p73ZwO7VXJ+fZXCPE79Bh/Uv+th9Sc5MBWayfn?=
 =?us-ascii?Q?8/ALlUeQyfRMlsAwsKrLC3mFOxfnSBWDJIpbZBBopgkdjzZEv+DQDjnaAlKj?=
 =?us-ascii?Q?W3FON9QRoPXQ2OHOGmouF8oDdZJG71FJ1JvK7oZ6G+syVXIkdJf7aAbfH+fu?=
 =?us-ascii?Q?iHrrvbNRVxvLuNwGk0eDi79tDPk+Teh4sQnL96Wg+OH5Xp4esrim3nTHU0Iy?=
 =?us-ascii?Q?IblCaY52IrTOjFNniWfS4zhQcg4yHiz2vGA+wKCjKk+LjQmdefGL3wYVCJFg?=
 =?us-ascii?Q?wjKJc3G5/PhCfJ9CD1Z8BqMbYnIsQbWZYC5n0rvijRcJqXhy/8Xz+6JDLh0o?=
 =?us-ascii?Q?90l/53En0cOV2+Jzd/YNfpO0/EW7gfed19nlKVTBcMmLAP5G7fQlvQ1jcQij?=
 =?us-ascii?Q?B3ROpmmCrI2zzze0n+RO3b338HKLCph56Hy26DsaFEeCqfQqQH2G5r05H14Y?=
 =?us-ascii?Q?vE4+trHJr4rYnaM6PaWk3mB5Tk4aHhm/D1TnEm33ngujTncweZIFkrU8DFs9?=
 =?us-ascii?Q?8BTMhhitD5FLnLhRGZaMallf/RUlA9yO6zKW6c6y8/8WozsbajOc6r3OsEXs?=
 =?us-ascii?Q?8hEmcNmmBYjkw7kFLYjq+RdIJNXRsfhMpvqNAT8EMn6aL1xsQ6ims5S2FMni?=
 =?us-ascii?Q?SBQf59HUjinImUcmFTBqr0ggLfDBuE8qZ3ERQFbzoUghTpLShq0T1A/RA3E3?=
 =?us-ascii?Q?FJ9M8iJgH2k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R+Z6AqkZmASvYIX8xQo1nxzio2KZvRyj0qVN1BWpRg4a01Z7YN93S0+nW9Re?=
 =?us-ascii?Q?RUIzq2yiAd5KTiAGK7kSgUhR9z6uBopr937fyQzaqHsT6NxT/G4nGyuVb2vh?=
 =?us-ascii?Q?x/V/hdHT7FKQxGKYQrCp1kTdPg6EzOsS8eKlCy2IgfDoPETsz4OShKUkUdYl?=
 =?us-ascii?Q?nz1bga4BuKQWZuKtbhQ7FgO7DjwDCJIHeicowV7Pfl7lalTAiCuFOZjWsD55?=
 =?us-ascii?Q?9k0L07Wpl1WxxttbnJNbCNDU5q5ddnGJ8pQyE+figY7Zfaq/kXQnbdmD7Orp?=
 =?us-ascii?Q?ZeNE5y3ixj40kBzZoN3WOdxXWkX8SGsxXpnM5nM1Pn7c3IyTc8DWxRyn130f?=
 =?us-ascii?Q?0bcWiMo8phI6rwFThjjhQ9KsRljpYPeBXCuK7gHR+Bb+8lbwk0tgNr325F3j?=
 =?us-ascii?Q?Ew/C0uIu40UkSnSSDiTjqVUr/5YSm3nys+2fbcX59eZC2VdR1MpG+gO3MZyu?=
 =?us-ascii?Q?J3KH75FmvxIKi/8nc12QcNyAft2RESLOp5GwLpHL0vno1mfb5rPnwnyD4cWR?=
 =?us-ascii?Q?GSem0lPq0ViQ0+FFTqyP3iroCWLfRbHRXHVkChVaVjDRvPiNILYTuu2b7Vah?=
 =?us-ascii?Q?mlhfw4c2itPXaUU922YKTmB9bqGk/3ynvMfihT31Ij639IsTMrnsBs/RJIeR?=
 =?us-ascii?Q?7wrXdJU1rUzAMlNZUz8olvDgEhu/jHLwttGvLm8kk5dg6MelovwGMHv1sRtP?=
 =?us-ascii?Q?kl1fc6xFJY0NNcPj/DEJhc8XtDv6ZL6/QRhCko9VOw/uEYydO7a9gXfJ4jn5?=
 =?us-ascii?Q?/++owt+r4uRhPkMU99HFzoFw9bqQMnRwXDEl97901urikec2yaVUKseLeaGp?=
 =?us-ascii?Q?UshxRE8uTJ0QJdDWDI/OXxC9UQsVoXhDCpLO2WidFok2FDw2mcNdjFYC6DXH?=
 =?us-ascii?Q?YmnFiYXevp3GLkljjOa/jiNz4is6LihwrdnEADziFXwkqVDmUTrYfVKpF9kn?=
 =?us-ascii?Q?SgbZSqKtfCdkc4WJiVuVwf8xR99EWknmUil+xqPe+RVLDD8Njn8gXBBG7B0W?=
 =?us-ascii?Q?gL32Xq3u9OF+O4FUczNq/mqtjIAIt7JGEUq072fOvK4QOBufq9C5nQQWtY1I?=
 =?us-ascii?Q?N9Rtovb8f7jxjxhXGmx758avQbN871GEtRxQ3hie+4DET5GHF+pHGlTX1ONC?=
 =?us-ascii?Q?C6a9B4a6vbmfEZK4vwGa73vYF345shuDZDnobOmjFjv72B99nHU+p1jNV9jI?=
 =?us-ascii?Q?IVJ3LTOoa7K57Eyv0tcvwlFA7FdYSBKjwz0Agw2qbJFMzlet8oTkJ8eBx5Pd?=
 =?us-ascii?Q?4ow4OlEJo93qUnVT4wNBD88aE2k4J3DqYM2lBnQHkXEjlLgWubimKL6bC6jm?=
 =?us-ascii?Q?WaKp3BQHQRkOBq8cp7wOxpME1t4ZtBBgBaHCqflV4G8mMa43B2VLeQvvLMTK?=
 =?us-ascii?Q?raMgCf7/kLQmwQiMyrNPDU+Jwi+PxGFRPWrpvPbdjp3i35uKb+c74cYZxCv3?=
 =?us-ascii?Q?HmObNyDt5JwDIOPK8IlHUPE7RqQS/IJMJ3caOolf6cPnDcvfVrtAjxy0M3rU?=
 =?us-ascii?Q?J8xfScOnmcnMGuVfW2EIGjUgfP0R3/VxxH8/pVfYaI9zESv4K2WkerYdo2vz?=
 =?us-ascii?Q?X5LU/MVp4ZWKOHhiSfTHuUWz9aSsiAWiTqTL1hF7jvX6rzNogPaRGQWR0W6/?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XNcrRt34ATieOoP6NQjudEJJLOYlbyh5C7x2UAtLT1Q/UObUCz2mXR6stxQwU/QuVPkRiBhSQ/0dTIWr4eElIs0gAJa7vWgun6QvIjLczJRKmy+/peG3yj4nDxoj6nnSaZai/X4OGcDlNse8gjOXgBxJzC74Mke0h3jZemAUyV6e2aN2X727dgSCingoobq45w+Uwxuc6odGf421qefFd1GUr5TEmPLwtn8Un78e4itjh9T9J2sQc8RGRhe0Rnkw9Z0y5cKQF+TsmvnFry6OKVyqwzD6/ql4fx+knNmgzIYodgkupNHR2PY0UdsOOzN4tiQiIx5xdxtuFGIwUhHnRgs1d08XMzU3smtzn0NZ/gkMuNqBTYKJdKLvkq0Ax3EZkzE9Llm8fGlXo3eGfiyz1yLpV0Y9ICn+dx7d+DzHYDEA0NbZDP+bt4LhftaDkt25DGWgv04/iLoDs5cJhiGzA4NzgEA9aOfgh9W633Jq5Sb81uhNsUTApcrXiI6OMI7Q/7DrMajVmMsaUA9KN3HBfqbcFIHwXmcMxvNakJaXa55qlmBiFuTSvEUnhLt6+r1OEZJ8vEt2tCSuJAPnRXAmZuHmf9SKhh8k/Fucd9KYVDk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f71ba7-72bc-4f21-4dbc-08ddc942a884
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 17:10:28.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPjsZH1zuldgUJyByJT+aMTTBoEq3LLHXuZ7aPPGV72D3mblXHjelNngwKFkymNk2PkHy2xC2rdygQ/TC9uXWnvAKU16sqejmUYapXQQrjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7803
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220144
X-Proofpoint-GUID: mOi9fE1s4EJg-0q4m9CT2LWihMrGAP-w
X-Proofpoint-ORIG-GUID: mOi9fE1s4EJg-0q4m9CT2LWihMrGAP-w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDE0NSBTYWx0ZWRfX4gUUWXJwB8cO
 ZJgI5eOIJXQDM9wX0SNuqRJhkEZDYfd8OYvy/EinuLwUFyQKaT+/aOh49Lfzqf+4zOPUYfGLn2q
 skekxtYG8iS8YzERle29hZY9+WWoWOBphRUrWstIg1RwvTFCSEdRFEl0/CZAxS94srGAhxHMvue
 zmQ4XUv4i0heRDciQmauaZl6pXHyvKMiHf+0LNbfXk32P5UJNZe5kMZSOrdIKnYVCumCG3dsAdY
 xd/wcKrnhKqdL13gEk/atfujJKUydxl4WdjKxMBy0IqhBx7zJulw7H6OQvz4IKirgF88cbATUTs
 avF2BtOa0crwEbTrr+OjRC7xsDDbT0sF0Ybd5QZqm5Jqkxs7Uenhiiv+veCW6J8i/OgSpgCKlKy
 uzecIyg0/EfxsZwDDUB2QDTpwPayQLHuGg3fLmbQ5pl1oCLeKntZUpbeZHJnTPyPjhtZrMYc
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=687fc609 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=pGLkceISAAAA:8 a=qkL2R8eei8n8AvbQuZYA:9
X-Rspamd-Queue-Id: 3B19818000E
X-Stat-Signature: sdap7j8mzkghyybe8jpzu4fyok9kcd6h
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753204236-698983
X-HE-Meta: U2FsdGVkX1+fB7jbw0ydt+Kzpsz//CnIcau8QCeL959qfMkY02THAm8mBcBZUqPCvegy30aGnj/V1KHdbtTFf/N++1aixliQHTRtVWqkyum5rMWYxPeUzRYvZbDIYrzdOkTIGXSQuc9G/WYcYbFxX+dbgcPEFvnF/KIuu1Z+MkYyZvgwA4oLqocAlhZLYYvy6JXC6dr7uUxpdPNFXxw6TIO7qSJbfQYMSTRjQd118hcLztkFDEKseF5n1aPjFnK7HxZqHJOmlMfB6lQD7zqiF0FaQhht2jRd24YBCnod0PrQizpfK25TdVIpej6fsCbH7VIQmEaLEotD/COIKyswkhgSixmhpDGdxXwfdgCWB/z6A3eQOEMU5qkF9dPmL+v1L3KzbzSfBEbfynYjKlEtC1mhBDuyjPo7h0uXor2OiJbgbunuGMTGxCsINtnapGjAF4GJ5fSW2qtGPt+qVy3dgvSUDbLrxwxUjkULgYZziKSGQob7Uv9AIU56/G/fb/k8+PWZqW/jQ1JnLdYtpbcY5ljZ1WAOODrtBWkZdaVErVHB/uF9JYautX2SxZUmB7OyB6NZLTqwkxdNk8qIXalyYTxjFSVfxfVgaRKqnQLbl9zrDo80sKP90xFZlz07bGy5XDSc3nnJ/KLMyc8r+5ACJSuXQOOdRYS9e0BvUAhGSRiLQbLV73p3Lz2qUcGRKub9/Sasc3UXEIhRMZcu64EI7caUvF232/oU9PntPya3IvLHPx4qYNV8g7VD3e0fHevuN5KlWSx29S5ql9MplLtCvOYxmXmByRO02FuaYN+mTtAmtMqOQJpKc2vtOP+bEqPVoMajgbvRtB6HuePikzO9OY1ppZW5L135CGwW1h+38ep2uTWKnqCXv8Runr0i/6qqbdhUXXTBCCleYlxWOPGehAvVcT4VTEP2n50vxKbyhx0W70ARoDUqhaDDAY5hG/4TgG3V2Nr45Cdp3qRqiUz
 Af6Rhk5T
 hodKg8m6N93+PnKD4V8ps82pK4R/bVZyoo31ASvGJC/rcj85wNyQt6yKb6Py1Z9YKi60UzIuuKfZxqtIbIFuCGIuhJi2l9eh4hE+dQOzyQly7TyoDcjdGo48saLagdIbLQCWWho3w+us8u946ceU4yaw7zvz0QVP47yZJpWZz2UDP7NVbdM+LuGaUIMspA/H9qXS4K8q8AmWwYQXQeHdsCzefkKuGPjEdQgxBtqEYYPRyczTxhh+HetXl5HNQbKFMXjzfWJcV23J9S238z5dGmv6hGsHdUSndn+3QIjwEEuAczdAZTsgBTl/J4ouRzlrzsku8GaugeubF3uEqLJSTZGyF5XkpSLGhAtBWTBscVDlBiFumoApid29LAHn6uM8SDev2j1FqTxY2JgrDQ13SUPrw/lwxMuYv5NW9J1kmpzPYccoMMlXiL7JbxSA/cnix7sCVdS+CmOQw+8xUZKhnKwFXwnw7kMWrqvfml5bkHXAlt9YfavMQ4bC2tCPp8r0P9LO04jjf1jBdTuj56Qvz0If7+i17Uwh/9LtprAW9TEwFF8co3c8Z+HfeP7yAx3e1qax/QwQSbOm4vTzw0amzdFMXEG8VlUitcvShnXMcjeDZhUHWgmGcqwI8Z8b/WPQtTQBnu3T3MXqRWHKwOSGjg7+Z2LGyP7vl+dEMnKBlMhrmJ9AEMT/MaHYVcaf9488lZnt1OjIRGIZ2MHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This file seems to most appropriately belong to the PER-CPU MEMORY
ALLOCATOR section, so place it there.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 837bc5cd6166..279c539f4c12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19460,6 +19460,7 @@ F:	arch/*/include/asm/percpu.h
 F:	include/linux/percpu*.h
 F:	lib/percpu*.c
 F:	mm/percpu*.c
+F:	mm/percpu-internal.h
 
 PER-TASK DELAY ACCOUNTING
 M:	Balbir Singh <bsingharora@gmail.com>
-- 
2.50.1


