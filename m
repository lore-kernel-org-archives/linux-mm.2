Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08F4CA0EED
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 06:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12186B00B5; Mon, 25 Aug 2025 02:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2966B00B6; Mon, 25 Aug 2025 02:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9635D6B00B7; Mon, 25 Aug 2025 02:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBBD6B00B5
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:53:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 291D1B7A19
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:53:14 +0000 (UTC)
X-FDA: 83814363108.02.C2FCE9F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id C73DE180005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 06:53:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U4iaWSFp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j9CNXeVg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756104790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLYGrF0laLRvmn+T3/PHAWipBb7FZ3dHrHxOIiY7xug=;
	b=P0qFe4UreSz234QQ8+8GgoQUOEG0EmN4Ko+Sx0miplyjVE1sDN8Lp7mp+s6ZjDZuSobz9t
	KHP68N+lEg828z3o9F24JWbyZ/ERk06NAYFog/Z25XD954K92VqprOaHtTxBkUUBh9Savf
	ZmURwEg05tlB7zxp/cQlh1YoFGS9vsY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756104790; a=rsa-sha256;
	cv=pass;
	b=fr4xoMq+Lpb9KtrUd6R2i21ZZnCur9htKdv7Cv9nhG86EwePPfus5+uEJ5jNPEbvzGxZE6
	octaoc8lpsabnJTaKGE8jHvSV41gI0emeAZ2hD7+PYctHhAG5X2/aTZsUoSOzHAZ/j3/DS
	yTO4YaA9Cui2DE3xQzYhZbO0dXJuulU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U4iaWSFp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j9CNXeVg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57P6UmHG030122;
	Mon, 25 Aug 2025 06:53:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cLYGrF0laLRvmn+T3/
	PHAWipBb7FZ3dHrHxOIiY7xug=; b=U4iaWSFpzSLf9t7hgxnovFaBIA6UhgleeR
	u3KtLRE0MUrNReyeLVVe3rXcxdSMmknKLTWDVJfakkp84nJWl6eMRe5aMHhiXbAO
	izYIqtjBsiWA6fjp3KD9HgNThjSeJkJyHdxIvHFSa7qupevr3Bs3A6GSgMbDZ6VE
	cItyR1E4QpAZ4Ul6Nkyh74TnOOVWcFXRumk+ILk7oJry4CgzcsQri02nWf1rr0h5
	KAY2uCOLNeYulfkd6iAeN0ZwdxpU/wZLBgAjKrVOLKaEIT0P6Ivhy0zw0dtc9Quv
	XsSaXIShtqWnWSupMs+EnWzlHjHtrqDcbKMwlp08KZYNT0NQWAqg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt1pc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 06:53:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57P62XRd027538;
	Mon, 25 Aug 2025 06:53:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q437t7u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 06:53:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f4h0tYNXzOgFtA5gqvxl+ivfUmO2v37xLY+GaBwMcowD9Dwn++QmsP9uLXvtcF0cxastZA5Tocv+dxc0R/0G2Lmbx5T+6gJDhEwvejl99iAS/d0W602vrp46VUFy1UzF2OQ7pnlHuwtHFJSDydp6MNha0v0rNexmyhatcilrxDIabfYaF88JI61oYoXGHaxjQsbul6upr0dgPOfziSJ7n4hcwG/OG6Zhp8I2waRF3bmSG0Y4NTZYGzaB+Bvg5CeuZH4Cvd61CWAg2KwPcZgAIMNTU13rp7JfsXJZPEQqqY70SRIKAWhHNl2spWNk9aaMUe7kPAuBrSNp9F4T77I3AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLYGrF0laLRvmn+T3/PHAWipBb7FZ3dHrHxOIiY7xug=;
 b=lCkU5XgRaHVP6y85oJRvbfbQW0t12x5XM01FF6JrhHFjEIborbS0geCDDtH+Ia6sZ+8fh80p9AiQWTTonTAqPoRPQIoAPVXtKsUjnubMgzTKyEZXJO1kpv0jWKB5hvR2ohxD6FOomn8axdsn7OqxOX32/ffhJ4FTqBD7urIVGDECqdzHxAS4ykPF2QWlcSpdj44ljVyR+6OBmWxXQ3GlB5zVVmT6cWPVPOumtmqompYZ1Cw2JNSmk51Lfexqj/rZEDlwCc7GVILpQgLzGo9lHzh+b72vra/6o67ejDy3qWnB9EEy4MTGgzROrjw7wfFC8cau//B5vasaR+Pb07mrwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLYGrF0laLRvmn+T3/PHAWipBb7FZ3dHrHxOIiY7xug=;
 b=j9CNXeVgmGPblwIhWRQDDD2Y5xkCz8zdKGLXkElEz+s5Irvb+8msx2REiSSwgBqalPZYbmgmLf0KWpjASRlzzMueG6jXNeb/JcMVBkNr9F6AG8wEl+WK76y4ua2eUk9kOdfc60qqWuqOci+CGYhcYXbBjxpgmeA9LW2Fve5kNaM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 06:53:04 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 06:53:04 +0000
Date: Mon, 25 Aug 2025 15:52:57 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 10/14] mm, slab: allow NUMA restricted allocations to
 use percpu sheaves
Message-ID: <aKwISYm2MO-zftfv@hyeyoo>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-10-b792cd830f5d@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723-slub-percpu-caches-v5-10-b792cd830f5d@suse.cz>
X-ClientProxiedBy: SE2P216CA0105.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA2PR10MB4524:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e00da78-dc69-457a-deca-08dde3a409ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?llzJBebl0J/ZaeltlX/zvwlirZAfAOj1Id38ypewQCmDAijiSHjvMdAP6Kc2?=
 =?us-ascii?Q?1NeZLIaCV4ldt0StrTD+BG/xP/x/rLhqZesLrGMznvZn4xnw547mfOWXyeZX?=
 =?us-ascii?Q?8sdLESkhHP6ueB43VAN7n6PT1p33QCfCDFXCNEv283O2DaK2FMxVRvXSBkKQ?=
 =?us-ascii?Q?4X57FBeCDOCcspFcWe2AbQb/EqpwtEuR/d/DO2cb2h/IqbDIB846gKY4xPPe?=
 =?us-ascii?Q?VqCWWjc4TxE3dWchNktzDv94IRkGahKzsIhBjYsacLew1nQ77fy3bmZSbLTq?=
 =?us-ascii?Q?1Po/HApYex1FJF2AnFpE5eeNzk1DmaY6oW7wpMOolCN53VYpJguJG2F1ZvWe?=
 =?us-ascii?Q?vR1AfUHIozRJVdg/yvA3NiK7Xi01Ve4DHJP4cSI92Ks+mG7qkr8GvrJG5Szr?=
 =?us-ascii?Q?pbFwMAX+hI2YCKQS4ELafXFbH990JPptMOyo46+E7yBz9JhMpYBGKCLKL8Mp?=
 =?us-ascii?Q?+UV2DuMrWL+I7XAai9bxzr9ye/GpP1wFydiWl3wkSZiuX1mgVsma/KpBWC4U?=
 =?us-ascii?Q?aabQZTyP+nmHfZAV3D19MxvRKfRQWX5q23xzOm9AKhb9kVopS7F3doFUVHma?=
 =?us-ascii?Q?uwm8FuiMuqkaP9VWfK3jsu2bOdUiSQvQAAOIYpQni+Xc9F8G4Y9R77I3koCG?=
 =?us-ascii?Q?ZPWmjNkzrEfiZnsqfH8Lg9dr/IVgYWEyHvQ61ssKYrOs6htTKU5v24KriR71?=
 =?us-ascii?Q?4J8V6BXVbAANgkpRbMw/JDL7Yxs0IxYRgxsOPXT7LRBt/+wWcLCN2ejvobaN?=
 =?us-ascii?Q?e0Kh8nyzdCH56Ws3BP9g7uq6XMuotloTe9ApDAr2/ysGLe9K3hILvxwdVmyk?=
 =?us-ascii?Q?TLOLl45sCk+RZC57Yk9lYK22jGXF1Kxn09xDQwSurQ3vR29wwmsd7CsjeWlj?=
 =?us-ascii?Q?Bt8ZHOq+MIMtG3XTM4zNyCHjKhZDbwzLj2KLQaXL/yJ9nqgDcsHQYaogWw1Q?=
 =?us-ascii?Q?wT/AM7dmjpjTu2PbsKIpTXRpXEgpPVPGlfnsmYesUeAMczOP9fzRX1HC2rwz?=
 =?us-ascii?Q?ifmncAG6QsDMGHpLPNkTR5KLTclwLLwOUQEfkkbGwsKmLTXmAJJZEtepOj+P?=
 =?us-ascii?Q?SXIzAsB0YSL0zRQJH6z65xGQTmCwM9S3+gg5ntJX7taRHCVW8Tx6HqJCW2XE?=
 =?us-ascii?Q?/4YwqaL5RMVv4JzQb2RJradawurPLKqwDiIIP3jpEUTjKOBaxL6XUce4RWyQ?=
 =?us-ascii?Q?Nmfu0B3fCh38nCkiQ8VO2wkBm/7T+XrWp0xdQDnFtOvuJAqOc4BTxC+ExVhi?=
 =?us-ascii?Q?QkDENh/k5Ir9BLNK05VQ3Axv7rqyWwGidFdSnVv5zCnEkFxrNrUu5YXResRo?=
 =?us-ascii?Q?cohkkYoGN3D0TeuUjs9y4C3YczxamDociE4LFBCjrbPnuTqZ65BPv1OKoLd1?=
 =?us-ascii?Q?vCcDurUlorlWnMg2lNC4TcFkpjVKEfNI5DO3XncER90YIrZN2tSnoGCKU/6e?=
 =?us-ascii?Q?X2KTU9DBVFY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DEUoNmQ+ydXPnymkw3XxGxsYDh6bYSnO/tHX9DcQB863cCm4KNe8LMbavVJY?=
 =?us-ascii?Q?41VhLs0salhB4H4YN7lF8wHPfhAeMcrB3t1D9ddvf5U8VmfaJyiOGLsYC6MC?=
 =?us-ascii?Q?cYcoYvW+BPY/IKt/uK4xgOy4H7+qL9XhzPK+lBWd95tgiv1G0LDd8slOqzVj?=
 =?us-ascii?Q?0n9zzvzUmz6CjST5ZfeLJ9sQ6fta5guLqhv5WPbEYmn2WHKdcq1WkavuojSU?=
 =?us-ascii?Q?SXsqbrlIzV31pRaAyoCdTFAqA43pMtsQ71aDklN/qEfRU6lVouL1vVtV0pZP?=
 =?us-ascii?Q?F7aKO2qw1LOESQjoNpScRLLqumASnpzBsxrb1/EEkGjZLHRPKrbyhBi+ycOC?=
 =?us-ascii?Q?/irPZ75/DrsyLs5yI8y4CTmgYK/3hdc91qUMooUJt88kJZDBza9HQeaefubM?=
 =?us-ascii?Q?e5vAV5WfRg7/0g7NqVMIg4MdgWtQZRmuCS/lLB18lXeXdem7UL1NrbybzKbL?=
 =?us-ascii?Q?WD9vyoherXKW7fKX86l6l5lP4Q56zuAZY9Nl1Ui8xZxmHz9HdkglRZIWyZda?=
 =?us-ascii?Q?fDZ8eI8ZBiYFkrSF9jkN1/444z5rL+6EdRld1KfS02PStVUgIsoqYvp99lPq?=
 =?us-ascii?Q?qkDb5o0EDk7IL1FIiAXnwqmK55C78PZlpmvQDBIMNhBgEpaVxm8sM+ZqaQuU?=
 =?us-ascii?Q?G/oePrwu8dEukJEeC9nYQLZYvTNIK3zGU4KHC0tx3q5SmslAliqKtoUgQVP6?=
 =?us-ascii?Q?3iiIIza1GJ6V0capJMGqT6w8YlnZrz+WVR342LQ5OKzHDnNaKWLuaDkBw/LM?=
 =?us-ascii?Q?qpdgcCsKeSR6N4HmzJTihOUkiRw5u/aZsyI96lIhrJPl60kYhvFljpq31+JY?=
 =?us-ascii?Q?G6Tk4/PLkmxnIA0HLz8JfTLc3Ohh7z8kkl1Y03z5yQwxRC82+l3vr+95sT4F?=
 =?us-ascii?Q?JQk7oieCg3nKGQGGkJPTzcUihyR0MnVeo7UdMnfELLTT/px64Pcpc2SkKB0S?=
 =?us-ascii?Q?K30Qp2lfTuiiGY5JWgzSn459uryirHZvX8vmg8AHb+xTzlKkuL1lXagM8ZYy?=
 =?us-ascii?Q?irVA2XDVbiTY1IgbuSMgapAktUvKaeTW3+N0nTFeSob6OXqIvrPV16FS7h0k?=
 =?us-ascii?Q?D85BgX4BJ8JLQVvYLd1m5faa1IVxWBdGOnljRJ3hfHaoeRq+2v/5gb9YBOJF?=
 =?us-ascii?Q?bi0TDdYqZCyCoRmoLxoDLNjMrr2sGf13uCt+wUVJoq9a++VoqmhybYT90hP1?=
 =?us-ascii?Q?i8hTrgPLT56mbf2c0BqZ8nYaJFWl56dNw7tC2M/0EJHSJLwJiMcjkosLZBON?=
 =?us-ascii?Q?21YIBLfa8LmavBYLBQxd+pUBWXI6GW2ESLU3wtSe3sVpy+2edPfuEf/m85jc?=
 =?us-ascii?Q?SJf/dWliSTHhGFCh9huoZO2BJbrg57fSFkfsiTu0XUKdLHqAdMqYaoEE6oiX?=
 =?us-ascii?Q?MUIbv1wzDpDPqR3Dk/1j92qetwIKNwuxiqp4+0q6vxuGL1Q1yOK1pCgFIeVu?=
 =?us-ascii?Q?04BC6p07UG4sZIuKFPlFLwbhjvcmMLmXmrib1KF8o8vW8LDUKUtbpkVPDaHN?=
 =?us-ascii?Q?NRSQ0h1iaga7Yg8Sd0i7pfgRO874Xi//suNVLlegPhkA4c9bsIvlTrjCnSTQ?=
 =?us-ascii?Q?ZEt6ywFerc2OQUHCOTJXlBUNsPrSfAPE//vz6hzS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xHqVUxJCJowRCuG7pxZniErV3nPxYFP1ySOb+83PkOZKxu/f8YSRzC2x9lwmsk7cwUb9cN+bSCG9/Vt3f76/uCqs4ZTvC+Fzur9wXVTE9sciR57a/afQYOLUCFy72YN76J0ZT742KIagQCuxgt0NCKHbQjzypCP+AawNDHhqhUPLu/W1KUW3pVYwkogxqtiJdT0NvE3T6T+rrCLkq4qM0aVuILR9Jq/JiCxUknBL94cp7GxnDiOEfDQc1QS5DrGOy1ykyrFTWqBKec2KDHUYb+rRHt6NKgBxP1+QOTZeO9GMAeuUn7x64Dnm4T0bPqmshAbLaJroYyV10tS9xj8Pipdp6Jc5c/QgRe50+SoV7fsoidyVM5vLZjBQJemGIm3ikaB3tZ6ewpLPNwAdzBh9Lw4uODPqN/LdZbH8eCMXUCI6m6pzNVnsbrE6EgYlER6uSg6xlv2n8daVRA9pWfaU+7lCIbmOKFjtlIyxyEwclJbfXK5+SVuKqWP2TfI7AtC3DF0C9STOHvgvxMlr61jfyWl1xM7NHDcJ/VFw53duB0bqtjoFyaqNJAVn9UFWEOMFaUodUC4N6pI/mMv15O15VUGmr2zdWf7Qq6si5dDnDXQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e00da78-dc69-457a-deca-08dde3a409ca
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 06:53:04.0079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIgKpzk4ielkeQvdRuXEYRLz2RzV9SoawwJc39anyV2MRB2FBT/s/um9ExrBcW1aW92Ddqisnh/G4SFgr1mIEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508250059
X-Proofpoint-ORIG-GUID: Uvx-0XSknxoO6IVr4Vunn5z7Wdh8MrXA
X-Proofpoint-GUID: Uvx-0XSknxoO6IVr4Vunn5z7Wdh8MrXA
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68ac0853 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=8mucIKZVm6iyyPLtviEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX6Q86/RiAFF4K
 EyUy6e/okxrztexJvg55UtMAgRAUGFZEINJxVqIUtnHiz5syWgLWe2ERxTd4WuB+8Lf19nPEH+R
 0vRbefX3XaIV+qIptEZsdM9KCPG8VAyioAskeh3/XVdG6Q84FftCWVitjZE76RaWg22fXNi4QCi
 Xf7s8PGmUIYPUE18bzX1RF7XRcaSgsnL/3fHV7caGtCP7Ho7dFpsHPNbeocPf2Gk/06FknDkcOO
 hv2YdqpaP+xDAUPMUrE7tztl625x6NV637ahsnWB0Gj0UvmcSIS8jjq1JRITv96ReJRTtPr1GmD
 KAELgTpTgtznGXe+K9SUUAzgD/uIT7q6jknYk03uD2fWm7xksaIlOiXnD024TnkdgmR1FgmRzVf
 sVElNdfB
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C73DE180005
X-Stat-Signature: wojm9n5o8on1yn7saefa1yikz64pa6a6
X-Rspam-User: 
X-HE-Tag: 1756104790-659588
X-HE-Meta: U2FsdGVkX195R4dh1WkYbld8MA0wkBvFkeSDT/0NAJxCf5j5wxTHM630GCzpp1OVpBVnxIBaSHu/kxsxCxJ09re6phM6AGcZHOGAtnFfuXMUNPld7mrxZQFepJ8g4swSNEZTVUklCGWz1vQHYcmxxR2gVNNnRSs4l4f+2wvHNyYTHv9DX52Iz5N53m27N/xX0Gkf97pAazBC868E/aMYJoo7U1O99cLpML6ZcyL/SqLuvWFqmXxD0gTKcMGWj0RdMyfMOSkNTyzYBuLgq9R4daRbEwL7OFKZtPi41WT7x+55pZNOi8bmu7D/iorb8k1C5QxFBhxmq/f/aE/m//jc2t46EujgTnK+HZvR2JgFz2PT3/8S9qDlAx3dogEBeMJ5BI7faqdDsQESRLG31TND7mnVic7suotZgQALktXfL/1mu2BLqyJnCcJMz5GMJPg6VXEeXeeMWh0iV5aFi0ggdmo41SpG5zBPR1UfE0pD86tCR+BO6uyf6j9c5RLnJImUQE41aXIPywxGbKKOO8x68msesf5ablUC54B3VO+9aNiZKSGXiek77katRR2/e0biPcmL+6o9L5b0L0qjJgnGaXKzJbCMbCx8GbkElvi4pR8yRQ+ZG0uuD7xCqm/fuYhfXiQYlcXp0qqAcCgIxPnw5v/fZiAeLb48usnp+3CDkQb/tbqgFcwfMDWyRaMFf2NxJb2GM2gixW1Sf5Y2oAtm/mstcd7dSB6Hy0MzdF4kD6FjavoXtkCa0rxB1Zn8pSNxizZZ2sq43zGUdsMzRFsTqJRn1t/YmUlNnhTC5KrPRc3txCaBoxGeDHvrhdqr5ysnVkOCD4arose6Aen4Kh7bgcVjXZhCU5E6sj4Gf9oZkFl+whl8614Bvb95sirg+HRmWpdOH0IJHRJKMfs5QffxBTWl3+FD8fMLCs2kB/ddddO6S8DE44IIhKOSk+rN/5tYs6TZqPGUAqVEPIpNw4h
 G/aNWdYj
 vSfpSwwLshXhLZ548XOpaGxT+Ml+reyMFS2jnwqPKRG58Khj/o4dXoCb3jI6X/ZqmV5aT4VXTSZ45kCZwQRIPCOufgIsJbw3QqVonn+Nwn5m/t963zVnxL8sl+WXf/8EAQGprwqpyQDwD7eNbl5n26TqBRgAnJq6uV99wqVCHCyTdi30nUFYfK7N4iyTDjB3ZQIeDnodMOnY41CBO8B+CxUE+Wzpa5X/PAgSh1F3yeGd48uvH3/tb14RLta0Oyrx1kh3qwIYv0h96jTqpLs0PtqvoOwrV4XGqwEpzeWHqZOFgp5OsQGDLawgaTZTzE/PkmJ8NDHcPB3NJ/OI0Qv4DRgaGULUKCKKSRa+nMUfGv9tDLRVwhJ5+mdLUsVm2iTbFevLAZ/RcrW6S8JmyGstKGU4kiHCMdalFdnAKVy2KSU7L9+0HakWI74llLOrwyphGb1L9uWfNpbklWPaynRZOYUV9z227vaB7CfndJuB0NS4sox0PuRT7+i3jwf9u14U8RJ9VzOsEwqKWpjM/kT2cOKfsgi38IAYP0RkzVkG9QO13A1RWGUn4qPRedMftG0UiSAvVEuFi7PURMa6WOOhMgrtpHXXnku9EqfoAxxH9GvovQEhdqGr3hQb/Rv8UoH5MOPT5p1zgSXCn3w/KpEG5tIFogzthJMYh0xlqicQ8Z+Wsv/gRcF463ZdsuMquEdgp3nFtsfArMaDaGTHa8frD1eRcJWmvN2alXbn1a/yv5cayBEI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 03:34:43PM +0200, Vlastimil Babka wrote:
> Currently allocations asking for a specific node explicitly or via
> mempolicy in strict_numa node bypass percpu sheaves. Since sheaves
> contain mostly local objects, we can try allocating from them if the
> local node happens to be the requested node or allowed by the mempolicy.
> If we find the object from percpu sheaves is not from the expected node,
> we skip the sheaves - this should be rare.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

With or without ifdeffery suggested by Suren
(or probably IS_ENABLED(CONFIG_NUMA) && node != NUMA_NO_NODE?),

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 52 +++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 50fc35b8fc9b3101821c338e9469c134677ded51..b98983b8d2e3e04ea256d91efcf0215ff0ae7e38 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4765,18 +4765,42 @@ __pcs_handle_empty(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t
>  }
>  
>  static __fastpath_inline
> -void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
> +void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  	void *object;
>  
>  #ifdef CONFIG_NUMA
> -	if (static_branch_unlikely(&strict_numa)) {
> -		if (current->mempolicy)
> -			return NULL;
> +	if (static_branch_unlikely(&strict_numa) &&
> +			 node == NUMA_NO_NODE) {
> +
> +		struct mempolicy *mpol = current->mempolicy;
> +
> +		if (mpol) {
> +			/*
> +			 * Special BIND rule support. If the local node
> +			 * is in permitted set then do not redirect
> +			 * to a particular node.
> +			 * Otherwise we apply the memory policy to get
> +			 * the node we need to allocate on.
> +			 */
> +			if (mpol->mode != MPOL_BIND ||
> +					!node_isset(numa_mem_id(), mpol->nodes))
> +
> +				node = mempolicy_slab_node();
> +		}
>  	}
>  #endif
>  
> +	if (unlikely(node != NUMA_NO_NODE)) {
> +		/*
> +		 * We assume the percpu sheaves contain only local objects
> +		 * although it's not completely guaranteed, so we verify later.
> +		 */
> +		if (node != numa_mem_id())
> +			return NULL;
> +	}
> +
>  	if (!local_trylock(&s->cpu_sheaves->lock))
>  		return NULL;
>  
> @@ -4788,7 +4812,21 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
>  			return NULL;
>  	}
>  
> -	object = pcs->main->objects[--pcs->main->size];
> +	object = pcs->main->objects[pcs->main->size - 1];
> +
> +	if (unlikely(node != NUMA_NO_NODE)) {
> +		/*
> +		 * Verify that the object was from the node we want. This could
> +		 * be false because of cpu migration during an unlocked part of
> +		 * the current allocation or previous freeing process.
> +		 */
> +		if (folio_nid(virt_to_folio(object)) != node) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			return NULL;
> +		}
> +	}
> +
> +	pcs->main->size--;
>  
>  	local_unlock(&s->cpu_sheaves->lock);
>  
> @@ -4888,8 +4926,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
>  	if (unlikely(object))
>  		goto out;
>  
> -	if (s->cpu_sheaves && node == NUMA_NO_NODE)
> -		object = alloc_from_pcs(s, gfpflags);
> +	if (s->cpu_sheaves)
> +		object = alloc_from_pcs(s, gfpflags, node);
>  
>  	if (!object)
>  		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
> 
> -- 
> 2.50.1
> 

-- 
Cheers,
Harry / Hyeonggon

