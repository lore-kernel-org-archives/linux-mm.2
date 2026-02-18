Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3AFAE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 16:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C757C6B0088; Wed, 18 Feb 2026 11:16:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF96D6B0089; Wed, 18 Feb 2026 11:16:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D036B008A; Wed, 18 Feb 2026 11:16:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA1F6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:16:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0EE12160201
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:16:51 +0000 (UTC)
X-FDA: 84458081022.09.74E6041
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 850A3C0007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:16:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=msNfIJoj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="OAi/XA5F";
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771431407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7kY0cgRaPXEwx+ZGmvuWk8hdA/eQEG+wmdTELwn6HM=;
	b=KZARY09xdh7c3U0zZu50q50yxfEZpKfp3pqRy4e7y06R24A0L2CpNMOyRcRoo9t3WUgdw1
	zb/9b87P2NhXsCW0kPEk1YQbuYmauday0KYBGroddmYFluGepEtgE9EgDM5Ealax10cGGY
	nBEJbXhsegh/9rPGKVqP45YrhGkdeqc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=msNfIJoj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="OAi/XA5F";
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771431407; a=rsa-sha256;
	cv=pass;
	b=akpzdalXjChpiCfteOllCLf4c2tESYenpY9Qax8m2+Az6O7YdTsVBMVqDpJfrZkLVU/aAX
	bnoKNt91kSvVCKrufh5Wb8Yw8ZpA1dQup162HQZ20/fxAfLSkh7IiAI5ZfOhEZSa8zwT0p
	SiZj0IvI6pWUIyqEdYSyKaH2wDIG5fY=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61I6OeOK066770;
	Wed, 18 Feb 2026 16:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u7kY0cgRaPXEwx+ZGm
	vuWk8hdA/eQEG+wmdTELwn6HM=; b=msNfIJojigitfYz1CXX2y0B+EDWiSZrQHJ
	THuyeJIg0zj7+gJAwrABLFxaaLJXEKA7sNZUZ5moF+9kWRrZGU70jmFNTD7FdUFf
	5gpQNYqyAc00ImFPETvwzzIaK+9RoB+3ia8lfAQGux2UuxljL5142yxedq42kfl/
	MnorCfLWY8P7H10Q0If8vmOUwOU1oo7FMRJiPAwBHkFdYGOdMO4vno11WjF8LJOL
	OTDwNtJxiXVOuYG6PJyllmUXuA/Ks4ItLqnGqAEtJYr4o6P112hNv2ZhuyNSypsu
	rWjfuMaw2ppfy6Afx4MtxkafmBYmQcImi+SRiwaxCfeYUP6yoLjw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj045sn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 16:16:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61IEoDiq022918;
	Wed, 18 Feb 2026 16:16:37 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2ds9pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 16:16:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nSkJ0QWb3K7llx3IwwlL6lEOm6i1K1WCRSvpY0+wKkVQMfYj8IwsEnv6j9DIPeJ7T3R2trNjvQ55UQ4LUU7ypIvISZouvr6XU0AOai4W/p7VTiugexHZ4bOIOKPbXIDiWwq6xK89KMJdWu24z21bZCAe9/sATsHkDLEGeNBdsfFT6c/70opf6S4BqiyZXJsWXd7HWb44ApxxeuS0aJnkibwjVYf74xBsMhr41Cq4AZMvsUUGofnoEhS8vDJx112ox32LOtHD+iIuIa5wPIlgv4JVtbtpSR2pN4xmOmHFnv0yp0n9HuTxpQH/M2ZCEDAQt5SKsKtT0TaV4Q+LFnlojw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7kY0cgRaPXEwx+ZGmvuWk8hdA/eQEG+wmdTELwn6HM=;
 b=KLLLsE12JHnselkobqjtCpBEJHXF1uHc8H7LP3hWH4mVVmUurm9RQdOCTNbBl1foGVbCSCxH4RMFzCPNCoTeRTaDWBoGB7fo9bDOe5fR5kC27UWVhRDU9j+QM1iN5nku3FR8SfMvELqsOlrQoSIQ0p0a0lAVFf1MhduF+VtpPEELnWxXfTqH8K9fH96cg2DkO3PeRGUnBCTulRMdSbUNlWNEXLCqErZjjlEDg9YPIUHQolHZEsPaiPbweQAdN8xhxxVgivicm6TJgIbmSgwaPyNK0FZb8gFLlxtxezMDnQjt+ArxlVKwvM4Nbw4df4J5KpEzshT7EgoVJ81ouzZzXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7kY0cgRaPXEwx+ZGmvuWk8hdA/eQEG+wmdTELwn6HM=;
 b=OAi/XA5FROQ4VbkHP0omFKZLSa57DCyQvyR+zo7Byy2ZF2ojWcBgCT6MTiNRJQK1xsBKTzQ6KCly3X4x1CM6uzLvA7nKd9FEdiV6w2Bpb6nzJid3IEyLpvbDkUnMtNNT0yGxXJs5H33Rd6sOWCieyb2k0aJhOhFs2Frd4EmN5G8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA4PR10MB8517.namprd10.prod.outlook.com (2603:10b6:208:56e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 18 Feb
 2026 16:16:33 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9611.013; Wed, 18 Feb 2026
 16:16:32 +0000
Date: Wed, 18 Feb 2026 11:16:29 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Carlos Llamas <cmllamas@google.com>, Miguel Ojeda <ojeda@kernel.org>,
        Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
        rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] rust_binder: use lock_vma_under_rcu() in use_page_slow()
Message-ID: <cl5xxuaplouphtllsar2qlkgoirltdv5ctgmghjtnh5jmpphzy@upmmvcxurwex>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Carlos Llamas <cmllamas@google.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
References: <20260218-binder-vma-rcu-v1-1-8bd45b2b1183@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218-binder-vma-rcu-v1-1-8bd45b2b1183@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT3PR01CA0051.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA4PR10MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e469337-b164-422d-35f3-08de6f0914c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2r85ehPIsg0GYArj00+bpKtNPr20MeMUKjYZO7NMy0YlV2SkGUFLdLsoH/Pv?=
 =?us-ascii?Q?EfDgrbdr5qAY+fMWg8RMHR9boHIHceZulu4YSzaWMnNharSOlXrwm2v3vU3L?=
 =?us-ascii?Q?0L+ZJnsbqLJtrb/vY2Y0Bb/Dou79bKIOTx1YKwGt10nIf/HN7GEuwTi708NV?=
 =?us-ascii?Q?azElfTpsVGOB35pUMHqjrdeyurm3KW2zwalzRxXRSK3V7JKRcSaWFQPC92eJ?=
 =?us-ascii?Q?BS/PRZU+W41sIUm/kjCiarYqDW89e0OwE66KaUayZSAaY8VOT9mp3cB2Xnx1?=
 =?us-ascii?Q?VBhRXM8cJHegoNBXfaBMAKnGWTKhSenbTfEQ/xzg+8lvAWqFo1JVjLhI4K3z?=
 =?us-ascii?Q?pBMD4aOQgz2dnIt4CIVuJgzb31N8LhFOujVogPjUz8/HF2/Z9kOgxv9Ip9Kh?=
 =?us-ascii?Q?OhS58ap94dF1j9ZMm+xyCS8js9Pc4j0VyIR7qPjl542FDPVKia69YlphnrNp?=
 =?us-ascii?Q?iXPLxb/LsG62rHs0WN3m6chyHqZ+TnoV4q4YAelgIV/U+NtfGLLVBpPgpOpb?=
 =?us-ascii?Q?Czbo2RLsBXwY8IK/Q2h2SBTGtkJQ1fDOa7mmrFkajIFfDGgHJRFbj/2Wk8CP?=
 =?us-ascii?Q?ijdNzZPM/lNNfUi1EbnqcO1yoi/3ABujLR7YZGH5TfxhuMPWKxiel2QmpR5b?=
 =?us-ascii?Q?yl3hexlrTCgi8EuVGZt0kjanbGu7itX53qUNELQvX+NqSj9OPWTiih/Bv5Zl?=
 =?us-ascii?Q?Kd7xV0rKQJScnFIyeJmR2B/bvj6QlCdBuZFUH/mFw2pbk/pCeu89twVc7Nlo?=
 =?us-ascii?Q?otGuAAknxmaQr/1+uE3a+tLlU1Jt5xSLc0CMiU3NJ0BrUklBqKbG+AssY//0?=
 =?us-ascii?Q?fKjyKN2qATU4uA/I0CLtyOxTgDSZexRWEuKsdD15juZkEB4HL97tL0s7CMtp?=
 =?us-ascii?Q?wAjXI38+qKIUMF+wz39oPwW6W9Q8V0bzfen44TIi+WYXot/d5AeW+Cx0Fj+0?=
 =?us-ascii?Q?fRRm6xtCCFtZ8Is8BhyE1NEV9zzbM08rAcomdJ5bj6jD4UT7EAAaeS3lD5IF?=
 =?us-ascii?Q?FBrkCwZ1rubjydUgHzqJl/wfeahHJssFUucIcbgAxU3zpqWqkuIgOfZ+/t2t?=
 =?us-ascii?Q?PHEMnRxFIj5rDAlFb+PYvn38XJXF1DjU+02vNZ8x5EdBFZlakl3fYXkFUoy/?=
 =?us-ascii?Q?LS4HRIDreZndwFPbuNl46Jm0/4ylDIRycOE160cGG2HTP9T3/nmgrLBBswdX?=
 =?us-ascii?Q?BbhEqcCnPj2ZjZDfSoFEcRahqIJMS1mSGziVOicWseSg58ZaReEEyvw+AOTV?=
 =?us-ascii?Q?OFsLIysA4+UJ6Z8tSIPyW/p5VxwFTYBwycGTe/Aaqg6j6+TICQa2WqEvrSKO?=
 =?us-ascii?Q?eaLD88hFn+K2X4AXAc9fZ2jo+CMuXXTPh7wPixEq804QIapG+4JZ9CRvANvX?=
 =?us-ascii?Q?D5ZL/iArrwY8/LD6nn9sLusthGUx54HY15Wl046+o035zJjrxvRYg5SNtr0C?=
 =?us-ascii?Q?CdMUkA0IYnkDyI5NBvtczfn7MjTSpBhqiMEL+S45o8iGm4wLoEZE93ZSjEK6?=
 =?us-ascii?Q?ynq+nHqUV96IrdZI9DNiKCjDitU0XM1g17serIvSdpOoc2/iUtLSG/c3CZnv?=
 =?us-ascii?Q?ZAA1aChWVUtMN5C0XwQx4iLpHi5Y0tzmY+nn8DgWBwsd4OiZRF0cJi2eiruY?=
 =?us-ascii?Q?Z1eRzKR47AuzcedgFcx6Wo4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fLIUNTIFFucIF5wqsAkrVPumcVozq21EYP4yGQZDVho8iuKwRGM4jCCa5zfS?=
 =?us-ascii?Q?S9o1oAK+RsNRujyx61DXdKlfDNEXkGeJ/wEV8GRcphaH6QFMxhhjEAKyuy+N?=
 =?us-ascii?Q?w0GVNdlCQcPEurLZYQxGxeFOPnSGlf9Kqe7ViW9M9MaYL32Tq/i0lAlyt+4F?=
 =?us-ascii?Q?ap+LjGnY3pFuErcLosWIHT4e48lMS9F0iDkB/bBytFpA8sr79ugkq+SFWPey?=
 =?us-ascii?Q?Uq1hciHqJoPDGbHMhOO9xoeIgu7lPWQy8Klhyc0zRnTEmKFDYvA2fwkE/Utf?=
 =?us-ascii?Q?MwEvkYwz4uH5M5V6j8VZgKG8u4FppxOL7/A4vEtfZU/nv+DKdUOWBodgBMBf?=
 =?us-ascii?Q?aPoB1oGk+yyvAZW5pbgZXNN3OkZ6l4x8x6B1HG3oVsMZdM9o+K1PqgtSXNl3?=
 =?us-ascii?Q?MgfGM1Cr4JekZwTVILvmS45sBZp3I0syKFwMyFICzq1t8QWaVoRl2vHw4DqR?=
 =?us-ascii?Q?J4YWjAMS9/VZlRyQiM+K8hGR66/CaKdy81zHel6aJyfRsm2IRnsa1GPHfblA?=
 =?us-ascii?Q?Vh6Ui/a/Wp6k+tnqjTfpSbBl9d0CrG7wzcaJ/Xs6+rFCtUCqU74+Wuo8y1lo?=
 =?us-ascii?Q?HL8RSS9+6b6eXosrEljJGIfq0PoIDtB9Du1tyOgaKumdwoGVqE3J4VJT/g+/?=
 =?us-ascii?Q?7lg8I6l+WHVeU1ocbJU0H3p++pgbwY6BEa0/vVR6fHWHKWLMC3jfXnq+r4of?=
 =?us-ascii?Q?WR3nxpy9UehfYU5Y9ktv8teAPD+VLiPk7g3PX9QJHevT6BgnKABBFMBdCC7o?=
 =?us-ascii?Q?ogtqFLKdTWI2Ib4OxvChy5YMZr5JiyNFd4nxQWKhoJwdAv5zpP5KwflEZ61J?=
 =?us-ascii?Q?R8Qgm2WTJLupsF3UYugKqELcqoSoWKXtvDOKHSE1iTohATDXG6z365C946Co?=
 =?us-ascii?Q?uzfoqJbsATr28QKHXFJMya0FPVMYcSAXduOKzT/WbDJ//o/UyqBl/tjHApEF?=
 =?us-ascii?Q?U3R6D+98luYDwp6gf1utIKsrKNeA6Ln/dl8ep3yFHufdtvEyw0NyiCNBUWb3?=
 =?us-ascii?Q?PIDNiyJsjYtpcQLTZc0C7jEWtGU8jHh6lTxa/uXbNftVHR90pfQxg5huoMN3?=
 =?us-ascii?Q?aHaLghn/+DmevCEtBQ3ce5UdnLr8k9lRnUFScGVxdQRmROZGepR4rrg36El5?=
 =?us-ascii?Q?APeYUCMucFb6/o5sVkXOTC4hMoSnJ/zVgokPV+X+b4FShYRPF7A5UNtGWDR9?=
 =?us-ascii?Q?10DWa4Xvc1PBXyW/nliAZ0FpaY2l6znFJ0Y8PrZvOXjdYBEf4Pp/WMn4dl7j?=
 =?us-ascii?Q?xAiSDE4e39KvKWqy4kVzaEWt+EZOKCieiEviJyPewCvqXL36tqIWkUFYtmgx?=
 =?us-ascii?Q?uDz12eaVttxTGW5jgCDUfCvhDyOHpSqSK7apvCi5Dj5y8yjNyromr6HMpjlR?=
 =?us-ascii?Q?tpL8TIExLbhXB8mGam7Wkx7T/kuYVjVIm2UoO+8QDqUaAxBZg/QS9s8Cjr0e?=
 =?us-ascii?Q?/4Z2KLjUS3jJQCRbkETAIXebvy1s9sVevkO/jy/coJZIRyfGtcqdrjc6I1Lq?=
 =?us-ascii?Q?ifF3eKZFSAWErgC7FrwOQ2yLqirYG0s/wK4wQZEuE5OONVdvRBa8gPzYnSB4?=
 =?us-ascii?Q?mVVkZ8U8WlXYOluvIxjUS1KSj//B4vwtzta/sapFLH7IuOmI0cKuV6QBIs8S?=
 =?us-ascii?Q?YMWVCKAgXUEli65qxTifEdKtyhTv5JnDvGsaF4aASSMNrFVDC8WqaDdtKt1N?=
 =?us-ascii?Q?q9XAUyApLVQuH9pXMj/iqiFE2pm7ZA1MjD4JOQs+zzh6zAVMNg9PFqNMVcU0?=
 =?us-ascii?Q?9OrCvOMGOQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f2dlZ6Pw+fWkHW2Ub0kYy2H/Kg1ZDz41gRcpnuosJDPS6T9zCY6jLmWskAF/MkETWOe7N2V/5ZZQWi6nXE+2ZEjrmCXHcTc+d3qvGfKCkIxO/hzeMD04nZxoGa0QEacCGMxXyPPS6skWmXnhuMt47hq4W/7QQJ2hUIzqk7vdigxLyhZemYju62mTRR/o/r8KvdWxJfrbscFpTcO20VrjNqVxZIV3tPeIJR2KkJBPJTi9lJ7EM1TxgPzdXHLKGRG12ir4Em7+8EmbwrjZZQP1SGpKYXS9MhkKf7mDFL4khm+58Sm9nwmae0vYMtXkzbSzVOp1dGha1IxtRcHMiW/Fn1C64dk4ps8IAFfjePOUhyaTnFNi8S5rxYLu22zVx6rzv+eHYdSt3R2ESNWmyNtjmFaUMNKmx/LLIK5vh9NvMQnZsi2vlnZI++Vq6LUf0mL6SQmaSO02trZ3tf/PVcqZeDhqxghoUlLSFy5QSozuJrvxGCy37IRyQTw/VHfUBZl+AA0tnZ8vHg1Oh7Fbov2CpD2UpbABb5fQCKcDbPtoCqQsBhquBHK2O8m9htT4MByt1hPrvnJ/AiFYKXiPBUH63UuZbh+qeWYlXqb1rWgul8k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e469337-b164-422d-35f3-08de6f0914c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 16:16:32.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TXLe77z1lg5sRfROYkUNtwZio1Dl9hQ1gNDUU/diGimMIo54pCdIVSf2jjIgfWMe2Rf81nvzSDhtMqdRvnq3hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-18_03,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602180138
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDEzOCBTYWx0ZWRfXwdCMoeHimUB0
 DxxOrlXJWQKmROc3v0q5xcWozUvSUX13khFIWsigdsncoNGA+VENDin0owFOi4d7LZ7OwQI/WMH
 Dc2bDji4Q6XNR1V4JV7aGQOXUUVNhufpLet1IssWRNQLcLejru/SLlOynlZ9faO7fRVy4LZGE+B
 mUnf/GED9XeAURBhtSGN/xZCPsQDeXYVpU/+ZhRPGjn3w9iGa8IEaTV9gue3eYDSb3hc+JkJ8dj
 njwY6znBhlEVok08nfmeLKHRUBz5c6iLCQri17HCL1lY/PTrdRODXg+Yfq1R6uMVH2enRWrlx9G
 Pu+q7PMuy8rZ9lfHdRq39lzXlGJcJMKum5sBXxjvOSulKH9quOsyC0EsWesUW86EP09qXY+VxNd
 /FJqltIjy/YacCyaYQUIfKuoxDL/uwtfVeBoh1lMspyYiaOkUvnO7UC8n5JgoNDZ5BlD/V7eGz7
 klbIlZfUISXDjshbBUTT9iuh0PtYGCYzEqYJLCzA=
X-Authority-Analysis: v=2.4 cv=O+w0fR9W c=1 sm=1 tr=0 ts=6995e5e6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=kwRcU2RkSJITvpPzbEIA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12254
X-Proofpoint-GUID: zQ_wUJM4o-6RTniUWZ-Go1pH6gisYs0e
X-Proofpoint-ORIG-GUID: zQ_wUJM4o-6RTniUWZ-Go1pH6gisYs0e
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 850A3C0007
X-Stat-Signature: a7azg4psphp71mq7xiuzttz959chftx3
X-Rspam-User: 
X-HE-Tag: 1771431407-803877
X-HE-Meta: U2FsdGVkX1/o6XOBVL6UKXtpzpLAe+z+qxH/bATrpeuj3FvwFeRyLxh37frS25aud55RfX4zaaCC5xdwawtJY+01ZegVYwRnVnt4Fc/lrDsdzOo6QpdYd/WjgvKYazWzYNrvg+sj8595AoWTHwi5PIZOGh9Wu6tXxjHSvkWd9U6nn3oRobJ+ad7FtlsW6CnKvWjwfr4+1qc37mxhHVBu0a3LVXIBqJI5xJJA/aK3kznM0sv1al0lkcdD2NgN9EzBqAmt6KlD/ilOMaFb2WTCd3FDM7ry8XLoNPJFFakKGmlIjlFLtaVFnwNLYJ4JoGXHySIK1T9AiCvJ/hYoDXqqXLDUrLRnliqGxLlkxes+e9Fzfyq12wPJixf9MdN5phDZ3IrAYnvWt1L0WF0UpjzrJb9c1ptXDGgRKY/nk4yfjdzN0wuKiaw72oBYkgm62onwwSbh7DQCcqciZQFB+aXr1yciADFD3CVysq1FuAbMsyyQsJ/ZKXp0OG5I/RQeoaL01F03IJDnZn1P7ba992AwgCsY86g0NKqdF+dVJ6PpAvJ4dhA1mVQGeFH8t7TC/7jM9X5q/AWkWImmYq215b8hSijUArIf6dxFFd0azFGEe/uS5i+iyN7pVlmlDHICCwRxi2ROw5gX+b1leO3VXbDP6Z/ldlWbFjK2xdCWcBovcXifpCG4HBLiYwfPMgHjSyF5LwtsfWbhRTPMht7xMlZu97fyU80Vz5bxMEW6uE6wChJQCkzZ89p0stAw+bugXXzgOZY5YPT+dPmMuedH4Lys5C3tYAvnuc94PEvr7zmk5Zry11HXfXwH/3Fs93tkl7ypDEhT8f2LP0eBxX0kAxymwPbeAgX2fG7hYN6U+ZfUoAeiN8wGaub3yDFGxNvJHtnkMz045TSi+LQ6ZSM7sHtSr0WVhL7mKjxXWuHdGsem3mEtrbVZSawuIFj+aJRtQd/SYXPTRw8YIeZWJ8XBkAE
 6G5kJV2x
 Ng4zJ2xUovpuNGZ2UwemNczlim+s3VIFQGma0MY5oRkfMoByRXG0ThOV/DgAW0her5M+B2tTgEACuurclK8TWsNjCSeeI1LRPxrC+k9OEgzNhOwpPObmnfSDt877JBsJRbNfLXOH/KrMtlaZR1mNuqHbUZq6HLFTQ0Eg6HZyKA3rN3GUCrG1SnSWia1MxSFJ67rG3i1/p0pCVYStqSCiuEuikru6MLzF/yllDDze7v7+rZrXFg5oSZBUrsk15MYyt+Tcnmq3t23WmUtUSL+gFi9fTNkG4A77AVw8kIuTkVjEU+Slz4XUlEsFh0EXdnV/jU971zQeLNyFziJUqEu63nBLCnLG6N9qIpF6bnrvripW03Zc6QH02rX7Iv1BxfqUVH68ofAr9tFiWUnfJ2nr1lCp1zctXeMhUNVcPs9J/nd2E/UTeJSaRPU5vgoVlf2LPP1R1LVN2dRtvyaubptfULvC/LpwJqcQzBON8wU6LQ1rb6NODPVHVrBKFQQVxKuS2QmKGjDbCMnvMfm2jVyNfYuK02p3rrTQRxovw+aJ41k9UNx12WHFCutU4NpcJyeDhjOFOkIBoJqBOUZAkOapCM+YXE9UIKuiiFZO9VoABan0aw5W8KZIoajPDvCyJQ28LylIvA4xzaP9q3vR6IrC1q3wlCQkUnk9RUSQeFahSpsVB2I5g6BFPb4h9LTiiutAlLkn6/0W1s8HH62Kd53xr7Eng4mqmhkeigB2FnaIoFaZhsSo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [260218 10:13]:
> There's no reason to lock the whole mm when we are doing operations on
> the vma if we can help it, so to reduce contention, use the
> lock_vma_under_rcu() abstraction.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

FWIW for rust code..

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
> Depends on:
> https://lore.kernel.org/all/20260218-binder-vma-check-v2-0-60f9d695a990@google.com/
> ---
>  drivers/android/binder/page_range.rs | 37 ++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
> index 67aae783e8b8b7cf60ecf7e711d5f6f6f5d1dbe3..9dfc154e5dd4e889c4f3aa89e5edb89434113e1a 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -435,24 +435,25 @@ unsafe fn use_page_slow(&self, i: usize) -> Result<()> {
>          //
>          // Using `mmput_async` avoids this, because then the `mm` cleanup is instead queued to a
>          // workqueue.
> -        check_vma(
> -            MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(ESRCH)?)
> -                .mmap_read_lock()
> -                .vma_lookup(vma_addr)
> -                .ok_or(ESRCH)?,
> -            self,
> -        )
> -        .ok_or(ESRCH)?
> -        .vm_insert_page(user_page_addr, &new_page)
> -        .inspect_err(|err| {
> -            pr_warn!(
> -                "Failed to vm_insert_page({}): vma_addr:{} i:{} err:{:?}",
> -                user_page_addr,
> -                vma_addr,
> -                i,
> -                err
> -            )
> -        })?;
> +        let mm = MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(ESRCH)?);
> +        {
> +            let vma_read;
> +            let mmap_read;
> +            let vma = if let Some(ret) = mm.lock_vma_under_rcu(vma_addr) {
> +                vma_read = ret;
> +                check_vma(&vma_read, self)
> +            } else {
> +                mmap_read = mm.mmap_read_lock();
> +                mmap_read
> +                    .vma_lookup(vma_addr)
> +                    .and_then(|vma| check_vma(vma, self))
> +            };
> +
> +            match vma {
> +                Some(vma) => vma.vm_insert_page(user_page_addr, &new_page)?,
> +                None => return Err(ESRCH),
> +            }
> +        }
>  
>          let inner = self.lock.lock();
>  
> 
> ---
> base-commit: 2961f841b025fb234860bac26dfb7fa7cb0fb122
> change-id: 20260217-binder-vma-rcu-e699d5752ad3
> prerequisite-change-id: 20260217-binder-vma-check-b6fca42e986c:v2
> prerequisite-patch-id: 4ca86894150aa7ee26c04440100cb71ce599ce80
> prerequisite-patch-id: beb72c0aa2ce3d495dd69817507ae6885e5ae1e6
> 
> Best regards,
> -- 
> Alice Ryhl <aliceryhl@google.com>
> 

