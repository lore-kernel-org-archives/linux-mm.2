Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F70CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 06:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B2A8E000D; Tue,  7 Oct 2025 02:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24ADB8E0005; Tue,  7 Oct 2025 02:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4BF8E000D; Tue,  7 Oct 2025 02:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA5658E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:18:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87801C07FA
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:18:26 +0000 (UTC)
X-FDA: 83970313812.16.DB6CC8C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 17ADC1C0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:18:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nzNovzh5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="hGCyGE2/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759817903; a=rsa-sha256;
	cv=pass;
	b=tsI5ErKzROMlVtLOhcx5qHaylvPOW8EYAFYL77nQrd392nwXTy4aVhMo+wZoDJDrPISA2Q
	idDXH5PdV9I1f9W28cM5TE3rblW3nFRkbxkkVE9z6YbvdF89Ql/pVnEW2dbN5YlD9zN3VW
	63bGD8AD6vCAJMaznrF28rexOO8EnaU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nzNovzh5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="hGCyGE2/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759817903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex9zjkK4vRV7XVyY3EhAgjim3QV2BZGHFmT4o1drYzA=;
	b=VtgoOgtFMxASowhIkdOWTEzM8seycXcrVQ+WTMpzVjtZ2+Atj7QE5qF2Yu2/Sq26U63Q+9
	Op35ieJlSfQm9GP+J8PPH6hIo/gQSAPbiGPbivRdN/eXLllEymHyaGeKcq0gkPmMC00Nws
	PhLKEnyZlpGNHFd0JqFF6J76xBYFBhQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5975dXJj025867;
	Tue, 7 Oct 2025 06:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Ex9zjkK4vRV7XVyY3E
	hAgjim3QV2BZGHFmT4o1drYzA=; b=nzNovzh5RIei91DQJrm5+tIpMX/oPN7NG5
	/804QXVZ3+/BrxGMUPoZslWx36iuU4GkAMR3oVcdafhSH953bneem0OT30v5fWGS
	ozGl2kLHYKaRnIVQ0V9wVWKCCfUXl4sr3/WEwGF5e0HfHeD8WyOcylKCIUh2HQzV
	aj2pwv3ULyHkRP7UaLy2PyBGXyMISoR9gCKZkF5hEKoKbk+OUwL4huJXIf9wTcFZ
	uxG+sPyXysL3SUOY4/rq522SkJ1/QgVsy9MTALk5LcS0RwRaKe37ZRnohIQanbyr
	Yl85pKaHPtCUPqgh37QQp99VMlz/NYP3urArVcbkZvMHw7Q4TG8g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mvwf01xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 06:16:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59755XEm028646;
	Tue, 7 Oct 2025 06:16:00 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010061.outbound.protection.outlook.com [52.101.201.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17sbg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 06:16:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pjmEErZg76jYjB3lasAVMkAXirmp2XrdaOsSRa+spqX9y9JwIyNDtsTBbVLUgG2Fry67f/bO1nfqL1X4GUt1kGx78bnLtagLq222dGzu7gslb9HoJYI9WysNE45hLaoQnZO8KhMOzh0cP3hpwwNbdw9dr3qg8soHonQBqiWS663S2yoLI69B7KMmH0J8fcgn/Qah8kVsOprjZCfdwvlycvAuoOfcJCuphps0ciRmFgRG381loDWlst/1OqnCFfe5MV+xWuhvZwhy8LDTOM8Z41uWOUBktJ1hn/wvf+qH427lIk3ipQPVPFJKoG6/6n79w94NGJfc25pKkhF+7boTcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ex9zjkK4vRV7XVyY3EhAgjim3QV2BZGHFmT4o1drYzA=;
 b=rzhfnRjqdF6KZZKP907XR5T/8fQ2skJSrAI0cNYMcJzNPTSz1vhr9v5ET/XGgFR1N39j9TJq7t98jklcLz5rzVAw+dCpHd7phw6jMyihYQ09bjzoZGhNq9mCUJRvHC9XLxeV3q+V6bfUUwLap3/LAlN0QI1AlzurcnMjVedRokYh8D9rYJSvjf98BFaY51NeG3l40RcRnYPJI0KpHNnkTvAat6Fgy57DJpEHSSzPmleoSus96HSckdm/wHML2vprkfdBr3A41sn0NIvqb6r1FwRRfm92LGVgbtnDq3/+qrF4dTaSo2mDWCD7+HV+QszjeDhsUmbiVZUKNVnlK2kqhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex9zjkK4vRV7XVyY3EhAgjim3QV2BZGHFmT4o1drYzA=;
 b=hGCyGE2/sELTBBPL9BKZBVDvz+5ASuXhgfbtQK1vKQq1ildumj1GaQK2tLgLvsUUjbaRA5wQ6y2j8WnSC34mqMOpos+HQvXOktHOsruqJGQN56oNsYTLBRLh9DIuntMZnqbj66NFVhshNYMDo7iBbHn8OLbmcBoneMlL6cgbYdM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB4975.namprd10.prod.outlook.com (2603:10b6:5:3b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 06:15:52 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9160.015; Tue, 7 Oct 2025
 06:15:52 +0000
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250923062935.2416128-1-raghavendra.kt@amd.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Raghavendra K T <raghavendra.kt@amd.com>
Cc: ankur.a.arora@oracle.com, acme@kernel.org, akpm@linux-foundation.org,
        boris.ostrovsky@oracle.com, bp@alien8.de, dave.hansen@linux.intel.com,
        david@redhat.com, hpa@zytor.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        mingo@redhat.com, mjguzik@gmail.com, namhyung@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        x86@kernel.org
Subject: Re: [PATCH v7 00/16] mm: folio_zero_user: clear contiguous pages
In-reply-to: <20250923062935.2416128-1-raghavendra.kt@amd.com>
Date: Mon, 06 Oct 2025 23:15:51 -0700
Message-ID: <877bx7gru0.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0334.namprd03.prod.outlook.com
 (2603:10b6:303:dc::9) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB4975:EE_
X-MS-Office365-Filtering-Correlation-Id: cdebb86c-6736-48a6-6f93-08de0568f7be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DranV6A6+tMUHSDMBiWkiDodRDxwqBLI7/gk8xGtGd6opFOSP1CSPu6XqYUc?=
 =?us-ascii?Q?S1XXrg/g3oV7Z1VhpJOQlF2Lcht1VtgVkNuLrlKk66AN8GOz7Ncubs9xNAJF?=
 =?us-ascii?Q?O7NtA1T2zzv+v7ht1Tq9IMbjiUTKgNzKNBaMSdI8l5pHwuNnggAw9JE4CMHL?=
 =?us-ascii?Q?Jobv32/BTdv8GtruK1vfU81JrKPN27bnaaQ+TDUvk8G4H/CegKMvomINKu11?=
 =?us-ascii?Q?s+z3+4oiQH40OdwguAkBCrJ5fzwXqzDM4/eWHvVr2sM1exOmLMDjfOYbpbGU?=
 =?us-ascii?Q?M3+fIAeJeRkqj06hKdiPrrT/x2CYAZsoKsJ/otYLBDm20epOZTYC1trG/OXS?=
 =?us-ascii?Q?Nd7Ep2SSMpG/5b5DGYv15BAHBKPGvSw8H2v6nMdnJkX2/Fi7BueVm92qwcQY?=
 =?us-ascii?Q?Tkep/ntO/TOBAk7H5+f/FX/UdkS165vBkY0NyKbQL3gQ1/J77pLcfoscA3QR?=
 =?us-ascii?Q?CGzwUMeP0C9lWCP+qCLnQaKIrAdPE50Cbs3yGMZtwOMZ4VaxkTwKwHAn/U7U?=
 =?us-ascii?Q?yfYjPTGp2Pd08jnIh/dOxZosCxzqWLzkjPH9IWqLKJqmTDPOAbX89hkPiSuN?=
 =?us-ascii?Q?9U05MIRgZK62O+ursU5whdexaqvLEuqZaKW3mSgpz32babMOoIs0KPJx57BT?=
 =?us-ascii?Q?VPUnZDlXKGVQO7MDeI19ErQlXD7VL12isk5hpkVqY0XnJbayikyWUnhG/Q1c?=
 =?us-ascii?Q?rc2B8QCUSFgUUCxZpp2YZzWbdwE6f4fIJ/EBlucG71zJvuM9rRwdhEyS+FAI?=
 =?us-ascii?Q?aDaNiuAx1rGS9GLh2aGr/PDmj+uuEdBK/gExSKj9QWC8+9ZiwQobXHhIdpht?=
 =?us-ascii?Q?GzlQ0jv37m0Yr6rvxl9whelM7cAxqS+3ocUMsVJdzcPQ5l/LpLiv0HCxXGrt?=
 =?us-ascii?Q?XqskQewjoz2mx7sTxJkFr7GQs+GCAn+4vnueXPyBKZ5WbGbqLpV+cFHYKc/z?=
 =?us-ascii?Q?xUBa15MjZMsJmFbke/33eVkQjZ9FnXX6e49L+iNvVaR7iA6vXZ+4RzEObEZt?=
 =?us-ascii?Q?n15vNJouJV+w0uMCRgeVenZlXK/2odaqRgh738AaGTO6pjmT0Zh/xwdBVe0R?=
 =?us-ascii?Q?EUgKzM6B04E++YygcT5hqOzXI0NMRRcOUICOunMmnmaFjUBY7GJYrrI7bJ/i?=
 =?us-ascii?Q?Ub3Y2ev2gWzOtiMMlQF12TbUaYFaAQFfmd/eayOIEHTgRgjSlLZZ/8dC8q3n?=
 =?us-ascii?Q?4ugcvk9m4qLJBZChuwSPpv3PO9Wv03EfWPBlx3B0IVtpM9VNkFwLHFAS90su?=
 =?us-ascii?Q?7CvkmYeyrzBX3xm0Waj7k3KcrIRdLIleJpML5aQcUWMRidycMtM3uShqmNBf?=
 =?us-ascii?Q?9sq/lxjvZrRG/ggaRAfNapGD+PBk3ZgEBZpxMLpuQRLbQymo2Iu/asST9uKW?=
 =?us-ascii?Q?IA/6okDTAUMAViuGeOU5NKrUkRUHnknAm/b/JuenDAWVlTcN+5MqHo0MoQB2?=
 =?us-ascii?Q?+fHHYl9oR9gihtiYw3ixwLdz3QKx9bJF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4xnm5w+is+//5x2huC1cv6wyZVfSYDTu0Vo6nxn2oYhrpXPyY7wgZdxLsWxa?=
 =?us-ascii?Q?Ot44MJk55rYEls5dC14ZHulY2NUd+23oZxHqIjAX5iuunBYJOVCNqz+bOtDB?=
 =?us-ascii?Q?w+TxrAvAmGLWic2w5azULoIrqWhj/soBNhq1bOFaI2j0vRI+bWy+0Kcoa6w2?=
 =?us-ascii?Q?R8K6o/JKXMxs1fr4dEIIvYf0FDhHn47PiArG5SocUk9PQlaCaFRiovNa3CoF?=
 =?us-ascii?Q?aX6m+kcGOnHzoFwErRFwIw1t4Azi1qpn54YPTHhhpa0fTX0arEC90+68PZpq?=
 =?us-ascii?Q?PZ++hg+msupVEQOLE/J779PPov3kTVh3iyXl05m0lR6BYt4yQuwWFnSNXrfA?=
 =?us-ascii?Q?LOLnR7qoiHsBGjvjY5TxSCULHB2Cz9+ipF86/9VbcaS7WxNjZtrQwPwdUVQK?=
 =?us-ascii?Q?DcP+LbdYCnRb+qgTAF15JPxb5cdz5LfwisIWyT3a4XpDZ/xI3AdRbs5ZNoqN?=
 =?us-ascii?Q?z6kyHQ4tWKDDoQZCZjlgcTUpZLNXY/sJBWEsvEtGVdAxnZjZ0WIjJBeMS4RA?=
 =?us-ascii?Q?+pxMvAMm32GQ+I3ZfFAaTTU4pzAe8OS0WiAtGx+q22xkDLHJA1RKBaNKEHEB?=
 =?us-ascii?Q?6LPBgofzpLMPDyfCBe1Vvqr/Av+3XNPB/Rt/KeHGM94lNYHiCtcOLuatvYNZ?=
 =?us-ascii?Q?EMu0MaEPxMRDo1fJ7uJFrKdta8DCjVKXzokmzdYYRUnSPIJt6xiPiTBARlXp?=
 =?us-ascii?Q?VBiNoVpjZga9+0BcEr+DXmXfuZ08dcJcEt5y7UryJQ0zWOf7T/kPvgUwzdlc?=
 =?us-ascii?Q?1eUAeE3FDwKEibdvN3+yLnUFFl2JoR9zbQMVHhEdzjypETiUKLlAzWAYJFlO?=
 =?us-ascii?Q?SmA0ekGlsxvKOq3EdQCQf1WmOpk8iJBDv77HHBP/cytJp8l8UaZcr5z3Hejv?=
 =?us-ascii?Q?jszmu0MzEj178CmiUbOTSZ0o6vo7w6iJfEweTspMJPs+Ic3BXe2zB6dNLEGS?=
 =?us-ascii?Q?IuAV53GmPy730lq2xbyPzIbyfgy7lDBSpEfpO7Ai682k+F+w56RSOlTt4hrn?=
 =?us-ascii?Q?gfoTA4xROj7WZSDCDq7+cgeHOKcQJvhqRcxtcpOGkJV/N3ApC/PUgaLzT0iJ?=
 =?us-ascii?Q?ZGpMaB6v89cGP8BONryPkwNQ+2DYa9SkTZ2tjXq4GYAunqpm4s6D8H+uTbqU?=
 =?us-ascii?Q?/gNaxLaQ/ABTYo0CAMY1uIMqMdGxROHoIQaoTcxAKX1z/3KxwFfr7MECM7j0?=
 =?us-ascii?Q?JWZa4nUvllBczOC206x7uLqsO/jJGn0kcRvVkvmtB47ovqtWgokqTwPRBckT?=
 =?us-ascii?Q?WGzL7EQASkRTvFuJrBQ28GxISC0uwlaGyLyNajn4vQM0So6SJeMab3R2oSnN?=
 =?us-ascii?Q?cvJ1Nw6XaomNymH1isXWmtVIgqjgfhiexRZjDZALTxQKT6baIqTKBNRGoRkQ?=
 =?us-ascii?Q?j87GVb680YZcbUpSgPi/iI66rW9yOKnNo9ObIiiRHRRK/6L0cXj1IAauTgd2?=
 =?us-ascii?Q?SHPyshtl9XS/nVczWjFsnoSAdCgn4dfgv6r9Ib/OoQRDIiSMs1t3iaNiVtif?=
 =?us-ascii?Q?R78FJ8EMtybRCv6QMUOXFF00oPMUVSH3hl4G90HhfdYpdQtqSrQXdZogGCmj?=
 =?us-ascii?Q?+4SseovnfB9sbak3tKzRLAqNfISMi4U26KYC626NaA/Ko7fe+z1rSMOsHFf7?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E0ZVI4Q63GOqdoyrw9Utm5NAYPH2fFMvbSVg3lHPxET9UG/RGOreI9DhfwfPN1Ksgipma34Ud+vfqemVJx40ezIssoHg/4YFRNyuQFzu5tdIXn7IEtrLhpTRXYrB27OLYiNRdPmYBpPOJqqXTw02xL8G4xRgvqHbYRw8HiIt45vQ8SMMEYiFU58bq1t8ie93hPt5sqOZ5ZCaO4ExiVjX/dCagEiNv63B1yaPDZDXCPGKildzYPAAfLDb6SRcC/26GmFlWbFsPysrq6MvRhWnIdhEu5xSV9ooYc8nHMvUETqsYz/VEwwJf9lQHH1x7zJPvFUzrR2yVh126yew1kiKqzmmH+EO360/GbeCWJ7yhARDURtP4vypZy58brDP+hC5n4B9sRVIUO0iBCDyhzYEGwxEFri8X8gTCPDPR2PNtaW1KZh1pevu0vFm2wEmEz37PtmILWrL3uvzVz0AecGqPf+b4tVpSqvfJCRNIA+So44XY2nA5Jc8nLYJ/VR4o7hVmS3+rTwir5FG1YTSd6/zz7mpfC35cmhrUqHcJzUBCJJzWon1gbKZqUdpqqT76RYjgbF2YP93Kag84Sd0ql30t8kDhG2QZlz13rujaW8aEsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdebb86c-6736-48a6-6f93-08de0568f7be
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 06:15:52.7788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dY8sbdJ4xqwZrFNqrCqdvNJF618BMuHWJK9s1k6xyVQOyJWHH4LzVV5mtZk88Eb6Ff9q2+V372jqltIKprxiI3Lrw6V5qK/4CRjZKngirsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4975
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070048
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDA0MyBTYWx0ZWRfXyNCRiDOcLNv/
 sqCptPb0MwP9y9+a4o75tkcx9Uvz14qVzppsNHSyYebkull8BZ2KYw22y79C2yZs3HZ7Of8ivrF
 d7ukXgNX5XoCaQnrWbmXQ4mCKrbj5nXnx2Jn2jCQ5LzuTBKHVeSbfTKWdMp/ns60bqwE4Xo0IDZ
 w/LtjZWVRuDz3rZyE61f9dS8r9OY9WLsal/5mCiZi4uDwbv46C65LoBezOyepcmYmkcOo4iClIg
 dpLC+HsT5+cIgAYNhSjmj3DPCMBnyDf7a3m/2J1Bi0mscmHDVp11RBD028AhP13L9jMur9boZUp
 kDhmLcU25q4wbrMcVHq3nm6VwyAqjerAPvNV6jfypjXDi5CHILwpCrDiawB1aJrbjIf26UEMp8g
 +SK+5EKMD7sOQOlouuFUkbk194I1wB4HZ2+P9H/wS8XMHV40x+c=
X-Proofpoint-ORIG-GUID: VmxlQN8RHikxefF0msbnfgg8IOrD8EfF
X-Proofpoint-GUID: VmxlQN8RHikxefF0msbnfgg8IOrD8EfF
X-Authority-Analysis: v=2.4 cv=PMcCOPqC c=1 sm=1 tr=0 ts=68e4b021 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=zd2uoN0lAAAA:8 a=n-WBVzomqE2Cf-J3H8IA:9 cc=ntf
 awl=host:13625
X-Rspam-User: 
X-Stat-Signature: e6nnwndupih7akodds9cdjewm3fcmhpo
X-Rspamd-Queue-Id: 17ADC1C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1759817902-731342
X-HE-Meta: U2FsdGVkX18pSBY7htNRT5aOgd/OHxaMVsp+pyY5NmZ7A5Z7jLcJi7sxYavgtcwvP4ZDTbsShdQKQkryer27IgUk33FcoeinIvr5dqOONGvDRjnibu3GfmiAvKPXNdT5yVYxpR+hq2mdRqnLkX/BUzjjuxtKGNoCYKbwSRufHbAg6ckg7OdfcODI2DBLjV/Pp+qweXhYev7J9xVgE7LCm+fGb2AjFna2NDELLynfz1N7L/wrsGWyj6IOROV1cDYMVP9I6ImS6KV8JocKv5Sd5II5DvXhDT6v16CE/UxSJebRKBVbUgJs31XDnx4cKI+4nlgXdi7dF4NubOiPcZ7NaZ3EsKIuZ8bd4R0VxAkpb6WePJzZEdanIMf5e2X/1zXX5QoFojwV7dpiBlmSDTLeQIk2GJzELFlAIW46GYWFe/Wt2jqFr2y/yqsUSjwf0N3L68OW+u77ZTHXV3SRcXUOGHAwSorezDfH1djFljWcjJLjGVjne7lwv4GY9hIhoJbkpkz7R+BwlzwWGxhvCwuGAiY83sz2QpUlLghig+WuEsJhqGTxenRo1HKfYDHNig4lZhjRljXe/kdJ2oXeFMN6pTAHDzysJYudtGf0nObWajc88coYVZL3H1MdbZrAV2y15Q/z5lthriPtHddoneHOdPzaGYxq5jI7kULGQZQOISkq0KXmYcElumdkRqer7lj9xHYceGDpTOnFU+TZPjwalgGeLpjKp5f8iZ63FfXIu8eN5Bq0Jnv3cfNW1/RTnsJhKPAjMRB2Qi57oC6ja5cZKbGYwnMN2Ke8gRPpN7ma0MysvVW0W9DzqQFtSgaEPfaJkRKFRMSvC3MXqer/rB5PcWmTsH+krb0AQCpVBflA/O6+Bo2TTjT2YtcTwU9jNcu5HoX0ArljaqlADtr0kJ5Qhi4uRdC+sQmi6oFPE49BG1g9SjhbUTarvcWwtt1Sj85s4mYc8m42ZRkm2S73L9X
 zNhbJ1Ux
 MjVThbCLrb3kG+VqlFvMJheEDpgQZB3cbJIeyd3Z05i34SOw4r/y3I6jRMgRDkPOtMoUO69a2EeNt8OdBXZhsGAXaoeuBoup9Kyf+1DVRRUsqUdEu7v109uXeT6ESG13yRTc0okIloYXnEnzRx4vdfPm1fiqgw9vZ0ithbW0rxp2qZidoln6jXW+i9Ic5hPgFVuPnzjqtAuiiLJEeGvc2qa20lcy+dgJQnvIRyVOJYO8q25qLsolJSs7c6HHZa3xXIYGBaBhgnQ0+vvFjiommrpyXdzT5cxWdSpd7RilZEgtVHTFZ5fUqzo+gjlXUUXR2ee0rJ9IxIXoiQmcP+o79Yj3M6kxfpXraA29/1M7tFzowgwJ9Uk1ZSCg3KzNlcTp1imYEAIYbDPxtec+X5P4T4LeB88ymBDeFoDr2biLarrFZLHEuEB5EMwqO0ydMV8Giu1EcabjCgqVy1SomTXBucba85GSaiDBNWdlebmaq50A1KueVGuwFhNwX7RR1tioor51KlbCn2TXBjWApIz/iiQPgYX3+JuAXt1KUliJSZoFuwfQ3EZ+q8eFqOmGJokS2G75GyqEShg5d+Utyu9Zsyq4kxacYSQ7Xv51fQ89mequsg3eWW/mIFeT/M+yrCCGph2Dkcl9gxV8MSTDf1k1/Rfj3YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Raghavendra K T <raghavendra.kt@amd.com> writes:

> On 9/17/2025 8:54 PM, Ankur Arora wrote:
>> This series adds clearing of contiguous page ranges for hugepages,
>> improving on the current page-at-a-time approach in two ways:
>>
>>   - amortizes the per-page setup cost over a larger extent
>>
>>   - when using string instructions, exposes the real region size
>>     to the processor.
>>
>> A processor could use a knowledge of the extent to optimize the
>> clearing. AMD Zen uarchs, as an example, elide allocation of
>> cachelines for regions larger than L3-size.
> [...]
>
> Hello,
>
> Feel free to add
>
> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>

Great. Thanks Raghu.

> for whole series.
>
> [ I do understand that there may be minor tweeks to clear page patches
> to convert nth_page once David's changes are in]

Yeah and a few other changes based on Andrew and David's comments.

> SUT: AMD Zen5
>
> I also did a quick hack to unconditionally use CLZERO/MOVNT on top of
> Ankur's series to test how much additional benefits can architectural
> enhancements bring in. [ Inline with second part of Ankur's old series before
> preempt lazy changes ]. Please note that it is only for testing ideally
> for lower sizes we would want rep stosb only. and threshold at which
> we need to do non-temporal copy should be a function of L3 and / OR L2 size
> perhaps.
>
> Results:
> base      : 6.17-rc6 + perf bench patches
> clearpage : 6.17-rc6 + whole series from Ankur
> clzero    : 6.17-rc6 + Ankur's series +  clzero (below patch)
> movnt     : 6.17-rc6 + Ankur's series +  movnt (below patch)
>
> Command run: ./perf bench mem mmap -p 2MB -f demand -s 64GB -l 10
>
> Higher = better
>
>                    preempt = lazy (GB/sec)  preempt = voluntary (GB/sec)
>
> base               20.655559                19.712500
> clearpage          35.060572                34.533414
> clzero             66.948422                66.067265
> movnt              51.593506                51.403765

The CLZERO number with page-size=2MB is pretty impressive. But as you
said that non temporal instructions need more thinking related to
thresholds etc.

> CLZERO/MOVNT experimental patch. Hope I have not missed anything here :)

Looks good to me :).

> -- >8 --
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 52c8910ba2ef..26cef2b187b9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -3170,6 +3170,8 @@ config HAVE_ATOMIC_IOMAP
>  	def_bool y
>  	depends on X86_32
>
> +source "arch/x86/Kconfig.cpy"
> +
>  source "arch/x86/kvm/Kconfig"
>
>  source "arch/x86/Kconfig.cpufeatures"
> diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
> index 2361066d175e..aa2e62bbfa62 100644
> --- a/arch/x86/include/asm/page_64.h
> +++ b/arch/x86/include/asm/page_64.h
> @@ -84,11 +84,23 @@ static inline void clear_pages(void *addr, unsigned int npages)
>  	 */
>  	kmsan_unpoison_memory(addr, len);
>  	asm volatile(ALTERNATIVE_2("call memzero_page_aligned_unrolled",
> -				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
> -				   "rep stosb", X86_FEATURE_ERMS)
> -			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
> -			: "a" (0)
> -			: "cc", "memory");
> +				"shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
> +#if defined(CONFIG_CLEARPAGE_CLZERO)
> +		"call clear_pages_clzero", X86_FEATURE_CLZERO)
> +		: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
> +		: "a" (0)
> +		: "cc", "memory");
> +#elif defined(CONFIG_CLEARPAGE_MOVNT)
> +		"call clear_pages_movnt", X86_FEATURE_XMM2)
> +		: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
> +		: "a" (0)
> +		: "cc", "memory");
> +#else
> +		"rep stosb", X86_FEATURE_ERMS)
> +		: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
> +		: "a" (0)
> +		: "cc", "memory");
> +#endif
>  }
>  #define clear_pages clear_pages
>
> diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
> index 27debe0c018c..0848287446dd 100644
> --- a/arch/x86/lib/clear_page_64.S
> +++ b/arch/x86/lib/clear_page_64.S
> @@ -4,6 +4,7 @@
>  #include <linux/cfi_types.h>
>  #include <linux/objtool.h>
>  #include <asm/asm.h>
> +#include <asm/page_types.h>
>
>  /*
>   * Zero page aligned region.
> @@ -119,3 +120,40 @@ SYM_FUNC_START(rep_stos_alternative)
>  	_ASM_EXTABLE_UA(17b, .Lclear_user_tail)
>  SYM_FUNC_END(rep_stos_alternative)
>  EXPORT_SYMBOL(rep_stos_alternative)
> +
> +SYM_FUNC_START(clear_pages_movnt)
> +	.p2align 4
> +.Lstart:
> +	movnti  %rax, 0x00(%rdi)
> +	movnti  %rax, 0x08(%rdi)
> +	movnti  %rax, 0x10(%rdi)
> +	movnti  %rax, 0x18(%rdi)
> +	movnti  %rax, 0x20(%rdi)
> +	movnti  %rax, 0x28(%rdi)
> +	movnti  %rax, 0x30(%rdi)
> +	movnti  %rax, 0x38(%rdi)
> +	addq    $0x40, %rdi
> +	subl    $0x40, %ecx
> +	ja      .Lstart
> +	RET
> +SYM_FUNC_END(clear_pages_movnt)
> +EXPORT_SYMBOL_GPL(clear_pages_movnt)
> +
> +/*
> + * Zero a page using clzero (On AMD, with CPU_FEATURE_CLZERO.)
> + *
> + * Caller needs to issue a sfence at the end.
> + */
> +
> +SYM_FUNC_START(clear_pages_clzero)
> +	movq	%rdi,%rax
> +	.p2align 4
> +.Liter:
> +	clzero
> +	addq    $0x40, %rax
> +	subl    $0x40, %ecx
> +	ja      .Liter
> +	sfence
> +	RET
> +SYM_FUNC_END(clear_pages_clzero)
> +EXPORT_SYMBOL_GPL(clear_pages_clzero)


--
ankur

