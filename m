Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A600D2F32D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8DD6B0005; Tue, 13 Jan 2026 14:30:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66606B0089; Tue, 13 Jan 2026 14:30:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10336B008A; Tue, 13 Jan 2026 14:30:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E45C6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:30:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14BD9B7848
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:30:22 +0000 (UTC)
X-FDA: 84327931884.25.1EF0867
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id A6F08C000F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:30:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X+FqIhPK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PsMLsMtV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768332618; a=rsa-sha256;
	cv=pass;
	b=kQ7CHc5DVqzDbC7hfr65/5/M+0nypSi9K4p2ID/3uFarKxU89Gsa9E4dsDRU0kaDdoIPf5
	oLY8KLtUcRTfG+FtVV6y+uYlGQkmdp5wRtxb2vAv1XT6YO8pTNR1KzF43OljrmcSnXRk14
	s02sjsYpL+VlLmAhv/aDjQPhPW9zTMA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X+FqIhPK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PsMLsMtV;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768332618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QXR5v2K3B4Y2V6GBJB1Fe1OeTd5VS8eKiEohgGkFeTY=;
	b=8PSp4O324jSV1qYg4khPH2a7L4qqcNQH9+XEfoOFhLRRVdox/MB4ZAm1Potcbg2hVk2jgJ
	Sk7gyTopq2T3cbuMzsX7UzKlTxCfZeS4+KkxDJc+imrPt1jIz6iOOvXZkFlOiJwD39PAod
	pAJMTWRaEM+wbNNcO9mohkdv/71rB6U=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DGH5eG2811623;
	Tue, 13 Jan 2026 19:30:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=QXR5v2K3B4Y2V6GB
	JB1Fe1OeTd5VS8eKiEohgGkFeTY=; b=X+FqIhPKaCKd551j8rmcMU8O03DOfz4A
	1aAHhpDqpPxKyrM3rapgyC2OhqV1We68nU0YyOL/9q0t0kGC6nKFwXrxIwer6QYB
	gefOTH6cxpmL/qN5O3KIS4au1eVZ83iTlUvSzn+fYmqk0pKPy2I+zYlTVTf3QvqQ
	PWaLwnHCwMV2bvIrVC5fxXZT0pOgRLxZ22sergO8AF4ZH+VBSKbWs037V+jBXErV
	AY/wvpiQR0fL88bpNgWv8TSjLh31bHvOs+8ktuH+quvFvx1PzSyQsCEo3ovH5fRS
	tjjFINX5VztbADICL2gsCLHwSQ9/9MR+GhQPn1ASRhph1Nyluywy6w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nm744-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:30:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DIUxLD004635;
	Tue, 13 Jan 2026 19:30:04 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011053.outbound.protection.outlook.com [40.93.194.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7949ya-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:30:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gerp1cho6iLUuZXqvSw9Nb+kO/00WlRMGg9MaXBzzr5NJnRTIxcJRhLujcGa6JL8xozdesixt5gDq9YDZQPF0U8sGkn03DuNPaXmts6Qjsi9zO1BCIxdTt4ixGSu7Dp4jYUUNyOc+wwc3QXL4FMfXTX7VDjJuj6+GrZneN1gY2Qe3x+d+qHel2otVuE5Pt8k4RBdyt+jQFt7KSXIh7K0cOraz/WsgZ8ndAh4U4bVxmUBaChSGzSG06kXN3t3hzSTe16yWcDca1dzcui5Z+FWhRDeyTqU/0JNELMvocndncPJCGq8MwERxZJlg/FvZjdIpAVRT2thVNN5xB/6G/jSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXR5v2K3B4Y2V6GBJB1Fe1OeTd5VS8eKiEohgGkFeTY=;
 b=UjKHjuaL8GRE3pQoEIed7zQGZdbMcAfHjOlIqOm80yPDWQsvtrcBlOe027+JiqcIEnw4iajCgF6z4fj44pzzb61Fe7s2Emg1GiDVJBV992fSDKXkCQ4l2LfM/xJS3Rv2ODuL6i20NLq+UYHo5hEJyt0dRMiQCJ1tk5C6eoMssZG4Z//WdH6HMvjR+uzA2LGP4IkGaO6uRqE1jx6f/4gWa3Pek0Yt0rm3w/UuFjaGMbOF4vrupTYgtu90v8qhoCjIho4tK0siGIP+lJGgey0u0dhzjXgbPM9ErYH5LdnonLuNAnCDcOBb1dkCXsk93a5Vjk/12rJyf58aJiJwUmC7SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXR5v2K3B4Y2V6GBJB1Fe1OeTd5VS8eKiEohgGkFeTY=;
 b=PsMLsMtVc2nvyLLOdZvr9tMwt09S5WMIB2SdPZHIhdgDI/YHYHi9Lm13ms0iR9IYWSqQh4uvR7nDWAS0rCjbvLNoCcw7WiOWbgg+Oe17Bx9N1rTGFSvtUOaC7hbQUzjFZL6V4LBYJfixJnYfWPCNEqnE9pDHF0CQeArPnPNFjJk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5016.namprd10.prod.outlook.com (2603:10b6:408:12e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 19:30:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 19:30:01 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Chris Mason <clm@meta.com>
Subject: [PATCH] rust: fix typo in bindings
Date: Tue, 13 Jan 2026 19:29:49 +0000
Message-ID: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0350.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5016:EE_
X-MS-Office365-Filtering-Correlation-Id: 1156a6f7-8b57-420b-790a-08de52da255c
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?9dblkydp6k25RiV342kCSwsavz12pYjpCOVWz5/uZp5yCvMkT3AGyhNjfVH5?=
 =?us-ascii?Q?o0cQuI+b4XyeJbpG65KIWkzVzv5vGIGikBTdsjUelcD7GFjdtvmS9EXxsoTs?=
 =?us-ascii?Q?L4qlBGXdnj5yaCmvcl23HVwttvep6KSdJQtcRHmm4ddDyvkunAol0kML6v7H?=
 =?us-ascii?Q?DAeFbNomBRPCsmTX2hb8+5aJK1FN104vCMiRhS8R8btkO3qOf4GiTEoM26np?=
 =?us-ascii?Q?Flsh0IxS1adgt8H1arU1L96sTMjAJP6CoYqfo+CEtlkeCdXtZHnUCm8QStHn?=
 =?us-ascii?Q?HWJRFSR8wQBVWmCzzoKhpeJwy2kKGe7VSmh5Rh+DAYnuEDcfdrKvaiJpN/tF?=
 =?us-ascii?Q?21PLX49PBPEh4Z3Oi+D5N4UJIlNiFHiMKFO08ZDZR4mf4JnMJxoC6OXSOG9u?=
 =?us-ascii?Q?L//UqAoJNSgoYVGx1+349zCXtFaeSaPAM36aZn993SYcaWBBVskfS6soRx6Z?=
 =?us-ascii?Q?ta9I0P26/uBmbhwqU8mOkXUgFZreA5MJhNcyv44W7PpFQ8bmazd4PAanxags?=
 =?us-ascii?Q?JiTZT5P2cf0ko1kVVjl6cabCCofJvhTaVVM+vcONWAKgzCXju1s6v2+prset?=
 =?us-ascii?Q?+K2rpsMEhpUyBMzdD9UpyqGORHaFj4CgJ5xoVn+aJrIDzXzedoW83FX01DBk?=
 =?us-ascii?Q?c3MWls7jODJrUX0bUe5ftVVuW4ImQYcxMB2EPqb5gU4+J4USoDPrukt27K5j?=
 =?us-ascii?Q?JdeCvHnaXF4cRuXmBS6oGrR7XzuFoogq8M8aRteE0QG4w2HPdm7HhVJN0bsg?=
 =?us-ascii?Q?sdCT/PIcx1yUrLOI5dxnyYkq2cn4Ox5bi9btvn+an6HpN4YCmACd1UpGi8iQ?=
 =?us-ascii?Q?uJ/wPLlWV+e4CgqPlSL4Yno5uqBHHCgHKPiUXgOqz38jt0/ows9B7UJBmLgT?=
 =?us-ascii?Q?gUKjCIzDaann/FS/7UfYDymjrS+ud0Vvx41M838J28GeJ0sfKGVHf5XT2oU5?=
 =?us-ascii?Q?4f0l1e7WzTidNZhFH3F+mZNJ7ubAVbxAn+cZ5mHXfhodbBtj5DT3Gumkh5wP?=
 =?us-ascii?Q?BWoB8r7Ml0CxfPPX/fPqdEPYgA6WWO3TqUl8Z0lIO6f6tDvSXxaaUxY0aSyx?=
 =?us-ascii?Q?mjkZtkdF3CA3yzE/MzdTxcxMMVMslU6wl4gpf50mzmRrYsc17Gx7lPj9Fkp6?=
 =?us-ascii?Q?MPAjIHqSpfefOKI5EjmFETo8PQpzfuIbjFWd+eLhbbFVfd12NoIlWKp3S/Y+?=
 =?us-ascii?Q?/kDv4CfIAVehFa1fiNlhWtBzEkauURHwZ9pBX+hAvOXON4zO5UT7xXBbZfDd?=
 =?us-ascii?Q?va+rdb45TeEOYAky2CID+gYbKT0hG+x1qqZhi4Bp4HIET85iGpPJ4VU8r9Lv?=
 =?us-ascii?Q?H029h0dFwBppzpGzikiHCSLRxqt5M+NeyTMorMzIhFdEsU28ACVOLZAgZ+cc?=
 =?us-ascii?Q?0yp7+wviC6YXU7NX+S/fZph5To5fg9O/CJRazWchVTPwv5Sb6t/8YX+cisyz?=
 =?us-ascii?Q?LxoJjq1bz3k2VcNtO3m7Ix9bEnJveuSmGF4swrvAVwIWRUtrkQEcjg=3D=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?yD5aLwNGB9nN65kQCXeV/aBjJVPzq4ue0Z8bm+HYLVcWrjMnxguBLlqVC3pE?=
 =?us-ascii?Q?F90eqc1fTrVz7GBwb4DVBdgIsIkQk93EUFtc3g5yyiETaomPWBRBCZCeD185?=
 =?us-ascii?Q?6xGegJV5SYPLJBjggUMEK0HQOnL2NPWv7iU0Fx+1RRzyl62J5du5UgVCGF8j?=
 =?us-ascii?Q?wNZZsEee0gi7o0MDWbfCVjPQZfxTQj9KWi1gBM1J8sie2l7ko4XsVOUxHEKr?=
 =?us-ascii?Q?fDiW2jVOXly9CojXm11egSSEF/f89racEXn3LaYk86DodsFBCVn8v9/ZrDtM?=
 =?us-ascii?Q?LgkSWyL7i9sxGkJ1Aidmu+pENpGZAZS/fJdUA19MWVveYPA6FUXAsue5XN8l?=
 =?us-ascii?Q?RiAAzINsChThrcxPKToaG6ZjzoFQt8WVhHh4h0vT9P/ujYOmZ7Pr3rKlqBBQ?=
 =?us-ascii?Q?A3Y/rL4C1H6uGlwTa7irw/sCE09wljlfEoRq25m2FsuEVO6sEHB9aVOzKFn/?=
 =?us-ascii?Q?OFIoqPB27Gh8W6FjpXea9i8KhXGC4ct+rpLtwnlYA0PMPVZEvWrtkygzW2cL?=
 =?us-ascii?Q?LGgeCNG/zq4QIKL3HiccvfsrXqr7nQsC1eS4I3l690xKAPfmWbCsW1EznX6V?=
 =?us-ascii?Q?mb7ifx/T8mgAApBE+zV1bPDkFbX+lSKHx3hDwedqHb6r6RdvyW+VNg9G/b29?=
 =?us-ascii?Q?B6oFdj3gQmn4jWUK5VDLIbrywkUQ4VAVwE2B7Hn5LwDCWaUtgZ8NO/AIrcVv?=
 =?us-ascii?Q?crxDcOiLsNHtgbsTdUjHmHkmgQuaAAhF2ITKza3vY33VeQxQqdsD7Y+crkZv?=
 =?us-ascii?Q?s6tRMWtHpPJOd2KnSFIPRilmOuCFDeexH3vM20C2hM6FY6/r8qutiMaIPs8I?=
 =?us-ascii?Q?pwVSmPESghnLXV90TJNOOUZ9cT/ciJbDnnB8NeIbzWWLE7Gtbg9IsKSsBPuP?=
 =?us-ascii?Q?S0E06I7L0tTfDYrNGGW9dM6BW+JFwXiJJTiXcwZQy7EENJ8eoBAixk2YKma+?=
 =?us-ascii?Q?b3dppYdEWOvumGpwMtIkYyL5QSDEMIKqOX0IAFHMRFWaTRza8kLzeTbwbMbz?=
 =?us-ascii?Q?yITMFbxlj79MgitYAwkoQ1NfDUsalYO6n/nhDOyV54nC0jSDugdFzJEfxVcJ?=
 =?us-ascii?Q?e7OTSmFFfq8+AJmZd1IdR0Q/W1cjl5sc2jNsZGrY+SOuMN8d/LsFepAKdVby?=
 =?us-ascii?Q?ovHzGB9RHFPg3XwFpMaB7V3BwMoPCUBl5LvvVMadnX9WXjKPYOwAKKrkpTS8?=
 =?us-ascii?Q?5A2vA2g4rf+QL/m+6qwgEwrFT+wCcJFxX9Nsj7yEvwzgmJbz/hrTVItcVJSp?=
 =?us-ascii?Q?KoFzm8x7yxXXz9dp28/867b7MC1CDnqMo/IaHVq6rmKxdq4o/7FUPOeXa6EW?=
 =?us-ascii?Q?u5As3JKzOuXO4zmgPpsUmL25B+s89bCvOLlVt2ILzxWmR3dmz/SVDPjaVszp?=
 =?us-ascii?Q?Ds/BHvP2icoODsbmAfcZbtAhJjgYDhq6iJmYqDgrF08AeXK0utKoVQVLxdQl?=
 =?us-ascii?Q?lw4NBitQjRdyntMLgfXrE0vmR2/XX8uYWF6iwIkrt6zX6ROid62j63jHZh0R?=
 =?us-ascii?Q?79re4ZAYatlZodGIdIgSpnnMZFnpMbcBcTdEVmxtgOIX14+Enzs2dGIREWit?=
 =?us-ascii?Q?HdGG9qaf2JiCol2hcvBCSNUqnlGqz5o0z/1nIXc0o2XzDDXxAu/R+2af7TBi?=
 =?us-ascii?Q?/jLfSfwjIKC/d/SnF2ua9rhX8brVwIeIF4TTCPuCLyujGQXNVwIInLiFitJv?=
 =?us-ascii?Q?Pbxj5+5fI4Dof7TsEtqn4QgdlbDYBl8z5ubvRVJlUIgUQq3kWe9iEEU1qkv6?=
 =?us-ascii?Q?uuG78yeGMryxjeXt1UxpJZh9iBZMLzw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OHRhgu9i+Uwm95C9JjAVH4eowr0kV1nQjxLt2EkleegPNcbcUtaoQeilPlwhBweaQ9LQjieVbXSXRdbY/HcrXLe2b1wFvmvkm9ytwmtiJYb/PVoKqjtEU4IYd8et6hefP3EcAMNAgaFMNOBneU9va3KzSGMyf+c/jvuBGjivAQinoJC2HEqsXTBbry877HKGvL+dIUwWEkqsBGvhahvBP9bNzsHnE//1fn6oO1/jMgiK0PJQJahqDD+KhuCCUQ1c9SUD6Udjd+1ywhJGwca/eEee+jKxSScHrQz0zEwlBk5vxJJJjtOBfoLNZYSDWJ/E3/qjORw9ILaktQ2OZm8SLXgl41Mc5GiJSW3YTUDS4csHQKPYSYQFVWhVx48I9eBMcw6FEmwwdXJXRKNQBVLjCW52A/DI+KflPTaMMlPOx27nDAq/+6j5JJWHuXoC59eeR/puz2ssoA1PTre/Ef35BaiHW+0IgPX4aI0ori0rIE5Rrp1/NC5F2loUtNrkr2Fi4lhq9wwpx8DUS76T+L2i6R3mLXUcWFm8QhEN1k/3pi6rr0PEugV3UgeBfLWWAAL5E0JAj1oTfQhlcpHn3tkMM98m/Neq2XCG9W0KuXsk9QE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1156a6f7-8b57-420b-790a-08de52da255c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 19:30:01.8347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0o9dQVmPoD23dslj4x8pYhAGaB33oh/IMtmWMLZgUMDQbfgKW9azlFFlePTU2YyUnQJZ53AqMwpZcTN1LBeTehDtndy+m7zgI/tY9nNOv+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5016
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130163
X-Proofpoint-GUID: A3afhUdSZg094A9krw4bJlvGX5uzquRU
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=69669d3d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=yPCof4ZbAAAA:8 a=YIo5fhyuh1y7nX0ACykA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE2MiBTYWx0ZWRfX2yvi+hYfuMmo
 IxqBfLD5LxLRfddb1EMZBoMVKSThHtvLtLGjCYCdd5Tb2dU4ExJSbJRafg9Zfy5hGMgGbvTJLjj
 tva0lvYgdbi6Wc6YEoiaVbfMc7AnthIyp+n8VUE2ELC/QB78vv9mhwCh0Ak/03mIE3r6WdBs+eJ
 gGBcOuW0Trt7dBMQgmt1bQUc33zsQSAJmcp6vQln8B4v5f8vOX5+uceYd9167u74qXI9NF7At6H
 dr9P9xyskT88Bm0LzKBThq623ugT76QZfBxyF4Q5Ik3c6ugYpDdyJomH5qXdaXjdAjzFD1Et/rb
 iKeDBS0QkRIcUn/ZPu0fRgS1vud3G07BcwvSRkETVVHJxLYZpSs9OVw5z2EzWeIeah2YZ3gJ3n/
 kwbsM1yT/5ak2xhJTXH/Og11y0Kic4waOhrxSXRjLHLqnDk4ndAuUhF9EdHOV6io5+M+AyhXvkH
 7foYnmkj5G3cd2LOSCA==
X-Proofpoint-ORIG-GUID: A3afhUdSZg094A9krw4bJlvGX5uzquRU
X-Stat-Signature: kou6nhr5j77s9fk194jooyjrcgzmfir6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6F08C000F
X-Rspam-User: 
X-HE-Tag: 1768332618-461566
X-HE-Meta: U2FsdGVkX18Pbxt9Q7VTanPJEhx+kG8pxFOP8C1YD3bNYGWJaX4CtwuEnomyGARLUfPmOYZZk7/5YyuV+RcFfsYZJ2B/FAedkrsVSYXM2U8aOuqAbzIGDbaeM7AsezSgHKqeFXijviJMKGk4XEm3KrYsm4Iw7WAhmigHeN87CUITChP069+BiVal1wQLS1DifvkIDFm3XurpygcAxV0sPZfpreVmuyBW9B64OSzJ+x++3a3VIpRFyw9cnrae+Frurw0WrGFuYYbiuzrMbnvijJql4pS5sKBbi8xl08HaDfjBaDPn4ssq3Ht5kOkbBqHHyWc3xXhqOUfJarxclYryKnebeOzPXpFv+cfCcRcccTifoGLWa3T+HBVCV58Yifak881GQ1WMOzlLIIkWNWvu2t/ufBBIAXG61QlY5OXdcqmykp3btVG9FZTosfAeZNpofutgpOSbf3gJ2maSi/Kft/EUAVFM5iMOjB64cUV/hs43V0nFv9brMquu3f1A0IMMzmfESo5cZHA9XakBy1SEewb8bKtkHv2MiYwNfrY+nFgzIv5e6LU+ID/SqjCGN5JoPBRUDbSvIOhe6ZD2CtDfNJhNLd2195epDtO0G12rFx8Amcgz4+C55ePc73lNGw1fhVBSAODMbCdGw5WuHN1FxBb7lSDqIOrlHRG39qFMNLw78Whh65xSQlUGkZpDSIP3Rho9aIpz4+BKmOm4wMb/5MZhDZi0wPgzLrG3ec74W+BNNlnh/wcf2SJ4trQTozGQqrDiACTjOtBeF9w+HLi1Z471i7gcGczNFoXzJSW4DJJzr4T+oX3aBTi/bStcsEk2jBFWVcMbQzl0EUuElOikWFStovxWsBgQqG7hA9+6ovLABWHuT2ZK8klSqWNGvq15d1u7uYEJLUC3+WVw4vd444qr4qssBZXKVUHmp5I73c6MS7Fj6WFE0S7rOfL6QbpRRi0iSBsQ+wJQahhnsB0
 z+5wIQiH
 6dhHM0y6rJ+S1c9DgXqkZZp006vJXbytNCU0tM0G02PDU/EPlYV/Wpes/0Joja48RrjQWCODE/RvSBZs1BmpXd83coMy037U8MY5Str44djTCcGTG/8obnTZUd7pDYBIJ4to0o4q7JbrRd7iAuw74mxgALZDSWdInUhaFtgbzfLvvA0v2lyYssPHLoG22nEwd/zL5wLKg7v7w7tws+9YclKx9CKpUcS8xScJ2DCnjbp5l1N6VShWIDi9ATDjK+8Oh8fKjSG/Ez1nZPZ72OEEkgb6BPcab5nc4XdClLCqD/vFfpvoGDJGRoEXCdcDO/VcAtc+RQsBTqWjRhxlY1t2ZN3y7znQiZDNQ5S3y7UIDNIz0eswrY9LdmuJhh4dcDjWfQBbAI9G2cMSzXWYvxpPfAVI+aGIFoseH2kmPa7UcNc8GtG1cHPK+jqHWZR9yJxehlvs6qxFolfP/DgXO8gLC1PtbMhTOByCv5pMXHSoGrKFkoV8FZdfWVMZl+ObCaaCtXyfkKk+0vsRNJ3uFRtCpoerFz+AECTqRN2MdfhUDKZTvOxLaRgCfhVAqBlEYRBl29Kh1lKGnPjzdy2KEaSwDmeIAP8Ib06eCBj8o9uQfd7mPpKg+46WZawB6nP8PsghvlfWzBtVQGC7FpZgFP4b8NTXtBYyEITZ4NEh8y8buKF+gdzDyY+50P2Wbn+ga8P6MO+vbvFKrPzp+RLkLPLgD3kM/F0q5TxfJWO+43trgl1IB9Npgw2atlvOkLVqaure1cndw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added a number of
overrides to the rust bindings helper as the change performed in the commit
caused the rust binder to not be able to automatically determine values of
VMA flags.

However a typo was introduced leaving VM_MAYSHARE to be incorrectly
interpreted as VM_MAYEXEC in rust code. This patch fixes the typo.

Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113185142.254821-1-clm@meta.com/
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 rust/bindings/bindings_helper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index a067038b4b42..25a8f24f292a 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -126,7 +126,7 @@ const vm_flags_t RUST_CONST_HELPER_VM_SHARED = VM_SHARED;
 const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD = VM_MAYREAD;
 const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE = VM_MAYWRITE;
 const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC = VM_MAYEXEC;
-const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYEXEC;
+const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE = VM_MAYSHARE;
 const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP = VM_PFNMAP;
 const vm_flags_t RUST_CONST_HELPER_VM_IO = VM_IO;
 const vm_flags_t RUST_CONST_HELPER_VM_DONTCOPY = VM_DONTCOPY;
--
2.52.0

