Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742E5CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83848E0009; Tue, 19 Aug 2025 09:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B528E0007; Tue, 19 Aug 2025 09:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD43B8E0009; Tue, 19 Aug 2025 09:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 926908E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:36:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA75C5ACE9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:36:31 +0000 (UTC)
X-FDA: 83793606582.27.72A6E82
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FF2A160010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:36:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lkpna2Gw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zVSq90jb;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755610588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwYSrYOrQmitsytqJ+s1eyfLrTL1OFMch/MRXb1eCT8=;
	b=iptDtWgh5GFtlDLwp3uNkjkoYTOP1U57MW72j4TQfS7obBJ6BQNi0uiNQxwRkFuPMi6FE8
	DP1w3h0EIolLgMKQZa9yUmR5zfgxDeDA6xyC7/aJ8dDk3usdCJHE7TsDEOG/Gc2r2BGqEk
	qYMi/RNA/SaZQ9rqSfQKYI6T8bwYyiQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lkpna2Gw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zVSq90jb;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755610588; a=rsa-sha256;
	cv=pass;
	b=dOw0T5ghzsuYh2ygLCvzA5LpRNiFqdsj1AuIQvVb7HKKEQsgaiti7V258knCm98Pmni4Ri
	GK1qm5oob3DlH6YUmNSEBHk0xgLpmWYAQbEu0L7Zubxot/K4gfTABwECX4Kj6ReAF6EJ9h
	5b/R5YLmAjm5yf4+jElBZjyQSbnOa0k=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JDMsI6010840;
	Tue, 19 Aug 2025 13:36:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mwYSrYOrQmitsytqJ+
	s1eyfLrTL1OFMch/MRXb1eCT8=; b=lkpna2GwOV1dseRsY+QpN7rMoEUCo72LRQ
	zF/JR2+sB3S+RxOiVqLVQeX1XZVSAZVp/d2PVx+H6/iGjXZbxoJbU99azHsZUBJy
	QI+Qpyh+E7iyC+muhAWYeCOm+kZXVzdmGH9drNlo877q37bJumlN/EhccXtR85TL
	AfnpgFGcDG2XCbigs5n5KbDl9qUurvej8QMR5Vyc+B219ygEk7sKcSS4cIU11sF9
	h5yYvGrciksG0Sa4GVlqYSLrg72n3XSk9BvDImNN0Y67cZWi5PQsPOiE4bc6Mpkh
	KIsOiYXo7SYywu3CkclAO+eSmZM6LrETwd/p+zejHtKkH5ZiLwdw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgk4nds4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 13:36:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JDAV4p003419;
	Tue, 19 Aug 2025 13:36:17 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jgeaeqw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 13:36:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZaFk+eau2rBbIPVpFMWdFsNEbO8usX+z2Zxo+qcUpagPhyDS3zes0lbXBXw4SYc2XviW9+mC2/s03qW/fAnny55BL955AZyZ9vY8h+KzaZrqgbXkM1kDpKK1GSEGUAit1JefvrjKO9+srelwLWlsWusDRBUyB+pTlbL8J+9S/QnYFyHRT3jnq9CZ9lCMRI0uN2gFM0HCmUCCLcCXHlV0rq0Mu9twmAcNGTtcT/tia9hYsf2u2ObYcA99DWmFaxNtZP3lmExRFHTJ9elmb92mv8HpAflSlXKLnOuKSnua2Lx9I+n4IiKCOwfPpssABBSX+QonqqroSo4Nn9MrU0cDlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwYSrYOrQmitsytqJ+s1eyfLrTL1OFMch/MRXb1eCT8=;
 b=I79PnaS8z7foLdGsh/Kp23KdwwdfQvHsCll62uKDz3c/Dt0FOfUF5H9B3XU0bUqJ+1nOtfXaxs3J6CEfV59F0cf6d6tIusdrj7QbnTmuM7NRPzU51bOJDmlf2Gj0wrQPLZLBcFzFv1Z2HFV0EhF/d2nqRZQUfnSzAf6SmzqKcuusf0Zxg5h9lAowEFBEv7zQtiZH+DLqHBx116nML6gpE4L1E1vR2rDTVh0wZOQPCcleM74ethbGogfLjRgUV06o69Z7T6MNrfxnaY7HR2pfGu/O3JvVwdxI0SsZKuUP8Nb4TzRrM495lFCajFCIMZ57THmSVNBaT4r/ThEi/wr2AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwYSrYOrQmitsytqJ+s1eyfLrTL1OFMch/MRXb1eCT8=;
 b=zVSq90jbZFlE5BXkk3TedLh4AzgWxpj3WQn+kdReTrgJ5WDz2WZIqo8Ix4WhIXbi1278Y6sNPKtV0ApPC9NX30OUKFl76zdtY3kLXZ9FJHwokeT++9CD1wAp3CQ0OwFuWFtBPZfucs/GOEdLAe8aCE85AiIEq5aL9/Refnrf1uA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS7PR10MB4912.namprd10.prod.outlook.com (2603:10b6:5:3a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 13:36:15 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 13:36:15 +0000
Date: Tue, 19 Aug 2025 09:36:10 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 5/5] rust: maple_tree: add MAINTAINERS entry
Message-ID: <5ssx3vakl3enjeaygpxfqtb26ufehwfjvcwqfna4xbhc645xpj@lzuvaf3my3f6>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Andrew Ballance <andrewjballance@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, linux-mm@kvack.org
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-5-229b48657bab@google.com>
 <DC6DQKE6LVNQ.3BBD8WF8XGROO@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC6DQKE6LVNQ.3BBD8WF8XGROO@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0333.namprd04.prod.outlook.com
 (2603:10b6:303:8a::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS7PR10MB4912:EE_
X-MS-Office365-Filtering-Correlation-Id: 72c27ab2-405b-47d4-b70b-08dddf255e6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FABfYL8hegt3Ekza33bqL55PngQ6sEVmzZVoHfNp9fNBfbczxzHjy71lm8uJ?=
 =?us-ascii?Q?Hy4xA41iFOpqJ18n4gLeYRtDm3aUPahuIWA7HMoGk7n0O06Y+IE1iINdgSGe?=
 =?us-ascii?Q?A6pi0/GPOdvdVimJ4X78dsmLk6RTKeOKhmnjRcjzSuOnp1r3WEoVlxDPy4Bf?=
 =?us-ascii?Q?lM7gHFn/pzGRbeLLFHAnbk2XRnVQjEgBtC2w8JPI/G0opYhDdRK1qQr4fY84?=
 =?us-ascii?Q?oSbhqwgK4FcMSBTy40IFiwWBzGsf0+trW5zNQczIeI8eBIuYurrzE2dC2E24?=
 =?us-ascii?Q?7NdhC1xC9xuzC4DSenjKtEv4WU4wWIknMaDcecA+JSz/SnGFABIUmNWzyKLq?=
 =?us-ascii?Q?N5DcHaJ/YgtkjcaIc9x186zd6B+EJUkADPtusypO+8m7AVPsM2RiRKV9KyIC?=
 =?us-ascii?Q?r5NYJVtgkurf9CdgPkz2JD1gDzXebM05MwOIzBNPmwe4kkGJmp3PR/ZldeBU?=
 =?us-ascii?Q?liTWDnTjo7R+9YB4zx673xtXKDCNGpNUCm8N+JttWTWVGEt1SOyHGQusjKcv?=
 =?us-ascii?Q?hU6QAKMyu3MQgy0EbSPSNrnv0TF1Jf/FcWl3BAiyo66Ad/8Faj7rw1Z79BRS?=
 =?us-ascii?Q?TXFFyYWtJkAewdI7kJ0x0SbaTXPKAdXao/bk+/JPgDWNTfOLJNI2yfXMV4vZ?=
 =?us-ascii?Q?AAX0GSjSXH7CCZEwC3AYipBrCi9mPJ+B0n7xdjMBATL1d+NGTUS7mTAa/tXK?=
 =?us-ascii?Q?+ooIBVOiwvbThlUT1G91xCHyttSNq9YCQM/h232H/S3kXVlJef30z+sRUR3n?=
 =?us-ascii?Q?+vedT3xllFoRZE1WUegnmCSxjfPyzzehY1Ban758KO7vG5bADLOuTc3m2mF1?=
 =?us-ascii?Q?yHDwk+puTOiI9WERolMhUkosVyAkq4q7YpSeBg/MmGG8dtuKk1GK12CrditY?=
 =?us-ascii?Q?m2R+93jBleYzETRkS3MsZJHCd+bogvyvM0Tgqs06NCHIFJMXnjtVPmks8J5/?=
 =?us-ascii?Q?OpuqxQ/VDbLyRAkppJXrccQpShZXfXVnPRFZZvPoUV70uH3gTEjnWxmgWjXi?=
 =?us-ascii?Q?FPI89Yn+d5rIz7H6dfamxkpH2fViTAY+ID9RkbjDWpQEO+yuqSwmD7/DX1hj?=
 =?us-ascii?Q?w8HlGYnP+mLZRCpvL3SKwY95tGWhL0TtBoPeYyEt1uAxAwGKtC5mntapSF8G?=
 =?us-ascii?Q?arAN8yY1YLeWqkwgc8ksPkz0toq8ZSIKieWqD6zfVHYoP+sPLj100sHgS4Tx?=
 =?us-ascii?Q?vW/HqGf/bYUMLaBRqCOUKmKvLf2GPfZlHdUoAWZFw2RUKxJlkEP9OPkvSSja?=
 =?us-ascii?Q?kx4Fvy8AafyvocQKaRVCJRxAdEO/oBxSfJZgN+AKCDtHSoL6kIHamUtTJB08?=
 =?us-ascii?Q?12lK2iL72744J35Qw7vPs6QpIIgSxh7RgNkhcz8cdTseD6bb+FJzG27Mj/G4?=
 =?us-ascii?Q?URW041GdtITC6sREY+0Mr+gmI9d8pi5qjCHXg5IEnDF3WNgOJ85sCkgNacpy?=
 =?us-ascii?Q?cspu5AuZdxg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d43QTVe9Jh/aLO5UGU3U7q2Moz8CUlL4MCUaW4z1orkLZL8xhSg2SLB7fHlg?=
 =?us-ascii?Q?3tN8cy1I/oULufmsDUrkw4KAC8ZKW81G0nuSAirKo+ffUXhMjjW0H/OLNehv?=
 =?us-ascii?Q?A9kghE117Z4wYQoHL3JpmrfPu5kpqEFzy5yCbG+BimOaUbnm6NtA3GJmtZX6?=
 =?us-ascii?Q?EZkM0iCkorsROtSaohxzaYml13ucEdIvq07T3UhdTcnJ/DMQi0XfaWmIusau?=
 =?us-ascii?Q?UFiiQnRCTgahhSNxoZT23F7Oh1WrErWU/L2YlnJUYgZ9EEYd6bVBVqEdzRys?=
 =?us-ascii?Q?Jo9tzeIYvGzmyAXnXnmW6LaETg5tDXCGQ3Ac4ug3Ns+yKl0CP3OEaDlcJuaL?=
 =?us-ascii?Q?+JBiEoEYSdk3qf+SQjle/a0HAJk+J8dryxXbKL8RYtBA5MdiLCbkt1ulz1Xi?=
 =?us-ascii?Q?SGEl+cq1GEynrzLmVO6noNgGUFrRK0yeyzvYdn07Zye/GeulsuOm909NeibO?=
 =?us-ascii?Q?n2QDS6x4hy+VYIJX87j1Wpm9AKfpaROcneoKg0tSDJqN4Q645EAzlq6o0cnC?=
 =?us-ascii?Q?qBcbmk3j1JpP3Y07BncxNe1BaCZtOgWPAoj4FCvrVmITd5q3bgzU9mcrOE2G?=
 =?us-ascii?Q?jvW+LZZy2d/VqngLqPaxv61NNbKGCDHGHyxJTI43NqhsdyTRUZXjOab0PKiw?=
 =?us-ascii?Q?Bkzhb8vikPrV7q5lvDNE8fxefoPkLdq75+8pTrKsSG79E7ki2JyPXiLiYMmz?=
 =?us-ascii?Q?vN/XyVrmTcIkEp0svDmTp6iNdVVJV744krvL7hFDtIwesAxgwMDHCMfPaDui?=
 =?us-ascii?Q?jiwSNoi/E/VzzWIpGdUEf1M1Br4V6He01gi5/alq4aV3ryKBIrrAKdbZfr7B?=
 =?us-ascii?Q?EuYqAENVm3yT8NDu1QzkJF0HeGqosyFJo+fijAjYWfWaDw1JaTrIDFuknm4r?=
 =?us-ascii?Q?jQT0ZmxBoZ87U9YPX7r6eKeWn9PSvfmOFFOqXWNbilXeZ5vjzvkEQatDc6vV?=
 =?us-ascii?Q?SGwIM2qZ7OKbRC+UYHvlAfZgh+2aCnG6gCj/JIuDK3z3dJC4bopg9uFUe0/A?=
 =?us-ascii?Q?CdMDsqxFsvc13vqVPRJ8N+4PlLcGkiGLPQC9vCLCOuL5kZPwRP9jYjeliFA2?=
 =?us-ascii?Q?WMruHVrVffKz8xdaFM+E9KqHi17PWYZ0b8ENanGzuZYmPsjPnWWmRPg1iq6p?=
 =?us-ascii?Q?4FnjZxoH1Mm4MS3t+1kX6twLTM7xXTZ9e1kVQoFqqb0ynBFcrobAdksKEebD?=
 =?us-ascii?Q?3EPXLS7ZPnA9Ha2SSaEOkV70tzarBL+ds9GHW6qRtsYXvPDmkLnbrCs4bCtt?=
 =?us-ascii?Q?cWez1C2BlhvuxGGpKPtC2rCltKJ8FLehfHljQ4nicGgvhHfcR9i3Ld9wWz4O?=
 =?us-ascii?Q?uwt7IVsCRs/LhB6zkotmJJIPwoU8p8bH2IpoxgNUxk0aPYK6AwNyfCUvwYZ0?=
 =?us-ascii?Q?3V4KFfnQ/pPnWhsszDZxpY/xWSimNI8gSfmlevuXkvylDeNgG1MF9FuIl/U5?=
 =?us-ascii?Q?PJyUm7OnSjVhHbhAlCjdeRE5htnWgX27t+HwCbKJajJ6tR1MqvoMIxaOMfVc?=
 =?us-ascii?Q?xblag8zyO7PORXr9WWflhpJIbTR/Zh4gayjhXR0y9UAzmQiCAvOB6cyihro/?=
 =?us-ascii?Q?/qPXoJq1k1rmRqkuSoeBSGXJ1ueXpg9+1XvMR6Ln?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vwlj7MPyOqIuljnijgCOPcFLDxQ+BidqpLZNqyE1ahpkNljvlXio61BTQ+nx6432naDWomYRF8d+LvJ5UdDruqBwui7GvWSNdw9D902EPfcvzckG1e3Q8LxPw550p0uPFTtsbdWxhO5GJICANVF8Ki4MizdNOiBAijBEF18MYuVm8wARMjY5HFKH512CLsKfEBwMfmdjUo3Kp/FRmukvu45OEymPxXmG0yUC8g6JzbJ5U+QYjOrf4PVVCuwzQElIdJHRIpBW7VpGOkqMhvDfqs1TFRRruJ430FO1NCA5fUo1S+egDohJN/2ccSpHc+dz6wRWhcjYVdNuqVPzo9Y1/R2ktrWV1GNw62u2rkA5hoj1L3XunMwY9gI6MYkkiHUNIXE/drD3F/72/CTDvydZyqOo/huLSOFzVyDQ8qCfRxB8VUZKRvlQJEOwf5T+DjiV3f73fwrcUjjLcZfsNfOlVUc3oR02gWK0MbNLwBXVBaVGw7nDT9V85TOKKfbKJnKwyFfJiEEo15kleKzl9WhNxdgg66Xmcx4Xhww7RebNuKRbE9iqml2WgD6o9G35kRklfnK2VHGPMvfHX4icNYUumO259mPZKCcjZyGhhKdFMHc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c27ab2-405b-47d4-b70b-08dddf255e6e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 13:36:14.9855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hw3uGavwN9SUc3TTlAnROFOZ+RuSMzMcDNy+8atw8sXd4ZUkTMY7LMmrMRJR3uH41qFaAsZCe0PI7TNfvRHVcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190127
X-Authority-Analysis: v=2.4 cv=FdI3xI+6 c=1 sm=1 tr=0 ts=68a47dd2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=JfrnYn6hAAAA:8 a=37rDS-QxAAAA:8 a=pGLkceISAAAA:8
 a=MVICOu6PFwG8hzzMiwkA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-GUID: a9pGU1vsHoKHKTPU978LK96h74r1OZn9
X-Proofpoint-ORIG-GUID: a9pGU1vsHoKHKTPU978LK96h74r1OZn9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDEyOCBTYWx0ZWRfX8J6ZWyQWz/20
 4R2G2ZiUaIYIB5Vs2gfDkQFEk0TqipeOnT8WnqS4GXx39Si5FkqascNV221a9vQtCXt+AFzPQLI
 82Xq5a/NaTg+yfGeIljsMX9yi6nAiXsIG5tIutYec/ogIPxpWwmEcUQba8v99neHa9InP6Cp3v9
 CGN87jX1zhfRWDJm2dUWM6RjIDl9SkX0qpgQAPOhL5R0ZvN+aNxlX2zhoEY0W1Q25NiRqz8qpr6
 s8adySoo6i8QLo4j8j1cVf6FmjCLoMBHHL6yz64EQplQ8yj34OoMzSto7GphdnLnlraqJrQqVAC
 ABPnGvrY6Sf8lMZ1Mr9LXxRRQkvdVeNYQjQqfAkrzJci6cXwS9ZxBgRslaeoHb56+VoIZwH1Xak
 Xeo8OHkYd6VqjzK4qU0DkCB9bjB2hiS0eaweY6vuu840g4KEhIbQ6/jJByKC1840aJJgJl4v
X-Rspamd-Queue-Id: 2FF2A160010
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qmf3gqqsi3owarxq4n1gp3amqsq8knrk
X-HE-Tag: 1755610587-970300
X-HE-Meta: U2FsdGVkX19MbRjQZPfGKBurCXf06pLeHnewyQeCPDpT2CNxqyKwGhCvn2JWwsyshsDhLCgNy/m9qkmgDYpfNLap5vZLuj4MXA7kkAIo95nf/H1Koenz79o8guYqMT4IANPRf13OAc4TVrv7HcM6HDZxzHfMK5o88ZL3f7f6ivPtgEChzBYZ9MKq1vdykGN7FcV4NfSvQlHPSfDSDjWtx9rpIARGCYeHbLew0P3VSWYyKzT1QXDJeu8bPyYZoyiGYtJFQ7BRynkeWpCfQeaEs0bWuG3XPCMAvLEmAH+/F3kW/wvzzLubTuyjsgqR4PsMjTHEtk/DW3tetZyWnOROVlO52SX8Jb+u3vrH6o47MXxo6KXr0/mOM3qBwQWSGZpzW4BiQa84PyMKaCly4hdnr8n0nyKINQj6ILsgtC1z08isfw/36NsR7x+IafO6llZfZDCW3VsrIoZdjBOrOg75FJdI+yPuPR7e+CY0qgE5Ii5FDqxXi82Pd9zMC5mOcTh8Fqmae4fFgfjnVsRF1H3VDJ2z1oX4UH1XtzSXHfiHDkRc0x2CgOsu1Qlz3/IcSiRGGbhrNImkTR5z7WL28FOPySG/h9wjV1kd9zsvL6ORI0RdErSKlS8NTbbkKC+QtNVqtTHaUo0sKBgCN8rafSaJTua4FCGGSDNxyZowq5TGPmUgevW4ywK1T18g6lI+UO84blAIfUa1VrKfQ4aUs6WVGjiFPcpTI4mlsZ8KNFA+KDtbAmQbAaLcLaRRm1Ze3jaO4Yhor+qSb3Ql1Rk2Vl8IaB+F70442p0ma4bJbAaNuuuF2ya4fOO1tQ7wCFhkHntCkeAbzgD3RA357r0saJoRKUdaf4vAkcEJ5QNeNT2Hk3N33B6dhHS7IO4CpNm2Ee9PXKNu1r1i4Xv/aSgAltHVJ64OxS+YncUQLJsgOcKOFqCbwAPmeGoL43bUzbeKElwEEWy61cSmAJQGPNRxKoH
 Q11pwnwa
 wsu795V5DC963MtugdWJqXfElmibDNNvFU9lGKFv0RqKATZ34muvIwUCYOH4SpllYSdohmM9lFI9ZEv8umz7pDX9T3Q+dsIHYHGpQJdDMDnFDjOxsZts/hC8Z1ELTA+bpfrvm+WwmmbiI+s7CR/qPbMaeEu9q2HB3LdUPPNUUWUat+1I8kC6b+kcIQ2eLrIRY/BooW+dh0yE76zZ1z8kDDCSz+wzGE7JvaHDv/+1CfBXb4EhW5Fb89Ytk18JaDFwoOHp8NO9sHmqu5Q2X+cYfFcDWd8OpR0IT9vCiPZ/5L/ydS9vl/YCw2SfGT6L5f8vUkiZ5FzxOID3WtPmPjUY4B+HqFdLIaypNZGL8WTqzLCaF59YVuOV+EhdqK35DAjVN0+jVuKjdumEm5stPwjBYb00D8qnpY5yDQg0aULWEEeuvFdT/iPVdxN8rRiQW/SekwehVqcHvFta/zZg/1sbE9Iq5oJ6Vot6o8h8OavlGxbadLMNmVMeFsuIpJMDylCqsNmx9VFqprDvzw0uoE6l8m9/VjLTULEqIAlIKFMzFsO7WAIKRWjL6jiGB6Z6VdrI9yYxUd+2bNLSgyeP5GxyK7lGxFwJdEWzEEvzza/tL9VSh24TE7QM1MpG/kckK54HLyC0pbsVEpYiFVt6hpVHrGx7nFTOgODewgTgXcz8O57mrwtLrn1cPfSp+riaEFd6+ZOuIZfeqAux7i7iDvsPIz8Hu6whP8csb2YHF+O6ObxKz5HRXLuXCb5xSbP1qTkoMjUNEwr9/l+/w7rt9GhzNWynAmsUQGn+Wjqj7qhlS7EN2FTJHOaM0vfqRu3q9NS1oMLUYnyGctFB0Hb3uuCLNkC9hk7Ba2NFYvTTpXs5IatFaGsQZYphEToBiefOywvLZdek8okoevQDqVPIEyLbKJXiqOn8kAbDnEBUZ66iMXGX8oNbYA9gHE9voXzUORMLnuzxeEha+M2+wmcZp+OqrxWw5/XIF
 1D0U//NS
 30ld3dHPlhNq3QP7izC7vdu9zmzTLKr8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Danilo Krummrich <dakr@kernel.org> [250819 07:49]:
> On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> > Similar to and just below the existing MAPLE TREE entry.
> >
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> > Liam: I'm not sure what you prefer for the MAINTAINERS entry, so let me
> > know if you want anything changed. There are also a few other options,
> > for example, I could just add the files under the existing MAPLE TREE
> > entry? The get_maintainers script should still send any relevant patches
> > my way because they also match the RUST entry that has a wildcard on the
> > rust/ directory.
> 
> From v1 [1]:
> 
> 	>> We should have another section for the maple tree, since it's not just
> 	>> used for mm.  Your stated plan is to use it for GPU allocations and the
> 	>> code doesn't live in mm/, wdyt?
> 	
> 	> Sure, I can add a new section if you prefer that.
> 
> Maple tree is already used outside of mm, e.g. for regmap stuff and I also use
> it in nouveau. Hence, I read this as moving maple tree to e.g. lib/ adjusting
> the existing entry.
> 
> I personally think that - of course unless the affected people prefer otherwise
> - it is usually best to keep a single maintainers entry for the C and the Rust
> code. Maybe Alice can simply be added to the existing maintainers entry?
> 
> What do you think?

I'm not sure what you mean by lib/ since the lib files are spread into
other entries by the looks of it?

I'm okay with the entry below or adjusting the existing one.

> 
> [1] https://lore.kernel.org/all/aJW3L3SEVUl_AVvN@google.com/
> 
> > Which tree does maple tree patches usually land through?
> >
> > Andrew Ballance: You mentioned being interested in being listed here as
> > well?
> > ---
> >  MAINTAINERS | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 26053163fe5aed2fc4b4e39d47062c93b873ac13..4a52d884e36eafe1c819227207123c51caf02ee5 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -14674,6 +14674,16 @@ F:	lib/test_maple_tree.c
> >  F:	tools/testing/radix-tree/maple.c
> >  F:	tools/testing/shared/linux/maple_tree.h
> >  
> > +MAPLE TREE [RUST]
> > +M:	Liam R. Howlett <Liam.Howlett@oracle.com>
> > +M:	Alice Ryhl <aliceryhl@google.com>
> > +L:	maple-tree@lists.infradead.org
> > +L:	linux-mm@kvack.org
> > +L:	rust-for-linux@vger.kernel.org
> > +S:	Supported
> > +F:	rust/helpers/maple_tree.c
> > +F:	rust/kernel/maple_tree.rs
> > +
> >  MARDUK (CREATOR CI40) DEVICE TREE SUPPORT
> >  M:	Rahul Bedarkar <rahulbedarkar89@gmail.com>
> >  L:	linux-mips@vger.kernel.org
> >
> > -- 
> > 2.51.0.rc1.167.g924127e9c0-goog
> 
> 

