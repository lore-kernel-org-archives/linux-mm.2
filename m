Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3B2E9B36D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74306B0005; Mon,  2 Mar 2026 07:13:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A223D6B0089; Mon,  2 Mar 2026 07:13:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCA76B008A; Mon,  2 Mar 2026 07:13:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75B596B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:13:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0C4FBD357
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:13:44 +0000 (UTC)
X-FDA: 84501013968.04.8296E9C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7503E120010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:13:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sMc3fRQb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GMPepRK4;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772453621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EdLkWSXQtPijztJWNkt9oWcVarAvpvLutUhzl89OuU=;
	b=usrm4c5zkCBFvE/pW503trnFD77R0T6RuTaZmaDRl85e1z/JvXOY+pga2ei+kgdgF4YiDw
	cp/J9q/u8QAEE9A6+w/XSIcnqFq0l+/AOHsXfFgttTjrUzumTisuOXvEgnaOU+G3rElHR/
	csSj0lqybTWGrYx9P5ANEwfgSo8A6aw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772453621; a=rsa-sha256;
	cv=pass;
	b=kJ4/W5pnNFXjDKPVU/NXa7xjGelCWd+EiEug6qdwnp4COEDWYayB27DZgvWFKsyzjaAQLa
	Tyac8VHq3s6diB2pEtcrQfGfA51OEC1iR+3K/r3G40lvD/yVHHiWLWxN62dmHL6FGg1CWn
	OxvaVV6SF+4U4+dtbc02CLnCMWlgklo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sMc3fRQb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GMPepRK4;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622Ax7oA879556;
	Mon, 2 Mar 2026 12:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2EdLkWSXQtPijztJWN
	kt9oWcVarAvpvLutUhzl89OuU=; b=sMc3fRQboTwtvqbHwSp0a30bFKSNlIlMfB
	dSYZpLH/uMwUAIVPCsls8CQSlaGE5QBE3wc91Fs7z45vvEviwhfn/PR/5Diy4WKS
	MqfGocoCm5TZWWpbO2UnTHd/mIcgcswnjuazZCLxgqfGA0c5eDVvJXR8i91cmo5e
	zvkxQxB9jwz8RD+in/MfmLFgrQR/CURexwA6fFE633BJsgB5om9b8fdtqw+1hiSi
	BTtK2dJ9msLbq5T3kGhlg5CfOZNyU2hdLyd6vuWDPFUYHtmdwDKhVyB7rqi30VVq
	pZjTqKSKggP6roLewK9LGmY6myGclVH5/oeD7XnlwlQ30R59jWZw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn98v83f1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:13:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622BgtVX034769;
	Mon, 2 Mar 2026 12:13:30 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptcvm9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:13:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHCM3H5/UtaToo7e01nBue4apbNIoNxyNc722R8eqGEC4K4x7aQtey3TW4tyLsbftka94/5uXwXavPe4nqFUNmWdcr9oTY37LhFDi/GWAQa0I/pp/g+NuQsvaL9pKc9dLtW4hEkvLcsxWAS9qhVCoy34DPQ2xlg5D1vg6zPuxiFMsA8ht3tr6rSqCBWYxDNa68whH5NWdq20uM8DNpSE736n8pB44d5JIqvmxXNVDlp60dzf5qUv0r+uWfpUNvJXCV1AGkXZ2V0YuBYvwNqFqDVrZtuyGXTPJQq2WKezX0f63j1MljxiC6BlorNJ/uPQTv1GRELwYe6nFsEnn03tpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EdLkWSXQtPijztJWNkt9oWcVarAvpvLutUhzl89OuU=;
 b=nfrCVXORLWYnQn8tthIWos9wHZ1SrGy+QqrkFmlM5mBNQv+14Bow53YML5hkl2g7wCD5kQsicx7moArwRxJU8i6qQb3ousDrXUelslXDTG1x4GgHbllrxnNE3uOoEusxn7x4eQT5wQDuUt9KrNf2F57+fRH8FsGZ5X1EEqudmGD3zkyFEjafCs89XdLpxUR/fBmFdYBXrwDL21UszuiChAk8da4QhWBttMC1NECSTrGvn1qGc/PyUDlmKvcE/fmJ+f5GJDkl+ohjiGo9lsT98OspRvMBmojzCLuv83xz/vr209iXnBF9jDqx9NyHL49fh1mQj6s3x6hpJElLHwM9Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EdLkWSXQtPijztJWNkt9oWcVarAvpvLutUhzl89OuU=;
 b=GMPepRK4LQxUjTGKmXerNzLEJBS2RxiGuuiKLU93Ir4sMwFmTu9lSLDr2/FqVI8XbN9MlEagQq2Jfr2Ma9t94GQNKmOcr3LGSAgQIgp2IDPf4HwrO5pRbWFQzJ+0s87hgwEGFlqUauXtOsQGFq6vKQ6NIM14cNMt6n4krfNzbDI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS3PR10MB997701.namprd10.prod.outlook.com (2603:10b6:8:344::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 12:13:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 12:13:28 +0000
Date: Mon, 2 Mar 2026 12:13:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vincent Donnefort <vdonnefort@google.com>,
        Qing Wang <wangqing7171@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] tracing: Fix WARN_ON in tracing_buffers_mmap_close
Message-ID: <e4deff21-2fb5-4f37-a7d3-ede5f69a4489@lucifer.local>
References: <20260227025842.1085206-1-wangqing7171@gmail.com>
 <aaFrmHzIAkEe7ufy@google.com>
 <aaF0zS3xh5KgM_yy@google.com>
 <aaF-bhAIhCgusG9k@google.com>
 <20260227102038.0fef81e9@gandalf.local.home>
 <20260227155601.18ebd3ca@gandalf.local.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227155601.18ebd3ca@gandalf.local.home>
X-ClientProxiedBy: AM6P195CA0003.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS3PR10MB997701:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cbf0092-60d2-4199-b56f-08de78551c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	KVn49L/F4XlGK6RG5C1ZdRcVgIJplhLw3gp1Cj1jKcEPsE2GTBJcKDjom9IAFtYXStq1aEWtsMyFnvQ8sF20aHIhpfKs0DMUl6V/b6VUlRrehINJD5RCMTB5615Qm3VSBcyTbVfRacLa6uDquRswvlrZWCrKb4EY7ZDmzAXh4mHG5FLchS30CFIinNefSpL9pIx1h9gb3Wc2jWwR3YFUrto/V8oDilDVjUleE5vLVRRn7c9X1TOyvrA55FUbyDeMcZHAXgA/HVm5+QVdQcgRyvVCOuMvZrI8rKjkojG3w/nYi4IiSRT9s2gekAD2dFM4D8ebACBHlKkJtsTxlsE7/0H5PtKK0Fsr2o3LPwUiL2b8PVYe1dBYxovn5eFT0/TSqGszIEqu7BrfQnUcAPZYGj+cPxMMkffB4NZZsv/PHEQT6fHBoAPEFmdNFfQLDQFgzSpizCyJVlniS3P67zbMKe16FkXSlRhhXrPaaZamS0bGBfDyW2rKcTxiIC0CutwsTCtIt1VRpywkup/5RQwWmPZJBnNbOmUJwZT1WWXHmV7MxtzSrDj3992eWCWiA0HeK9MKHuMKE29x0X6ZLyH8+PmxS8Q/Ud+cLzCDBARt8iwhH23xBYaF97cZihE/HvIcURK6wFl1jBFXDv6jiNT0+vWvq6RjObDB1aT3PFu78lvGti/ASvi9fShuy4Qo2e1iQL386n/spThZa8/Sy1rOMGf/yPpra6Vh0WU28NBnpbM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m0xvU/HAr4ClCOpR8aaaazee6pthSEe+8igFH7qSP/e9YtMDnyRKRRlEC6dw?=
 =?us-ascii?Q?dKeZpt30jyTT02EOrpM3+30a3mYESL9ee2QQYH9buNgw3y16P8jGOXaJv1mb?=
 =?us-ascii?Q?k7DlSMoplq+aJyyOM4W//IWDw3OtjxPYZ/FHBWJ/8IBoHoCNORVVar/+rt8w?=
 =?us-ascii?Q?6En+AliEilfdj+R1TTb8lsN86jkjOgbDLWbhdjw5pSGuM0PG5cgMyWX4JOEv?=
 =?us-ascii?Q?j4g8U5xgsJ4F0f7NvQuSzRf/gYCU7VTGDp2p7nCD4PzYqI5kWxDcrGlBGcZ3?=
 =?us-ascii?Q?cPFqWni9VlAPgnqr361v80ZF9cpAarxD+nnejz59VgqRXROU7ujrSJsokI9X?=
 =?us-ascii?Q?cBAJtYNQokQtes7+XIa5qDWA6n/NWlcVM8un2AduJrBSd4AQX1uUJYbr7eNX?=
 =?us-ascii?Q?q//uTV5FMsFeYd960ZPfvPbXIXwDoK4lNRyqB82eboZI9d+G3n59OStuHmUF?=
 =?us-ascii?Q?gQf4kuAwgf5ZOv8Tautnj/Ot9w7ciLa+j3ed+I7ZPL9LluKLnLr/D2KMStV8?=
 =?us-ascii?Q?3aeWhU3zoq8/TvgqNE/qa+P1qdhLLXcloHp8NskyGiitalT9eH/OHTyPUZRg?=
 =?us-ascii?Q?eV1i08DtdNLhUiVrQkbxM/G0AWprCKlAIsYURDOutMFwt02OIunbtKO4t7Di?=
 =?us-ascii?Q?Wqeoa47pL6TIEnEANCLmRX8MyMtfnOTvwLB61ayu85H+DQ8Kq5phjGZb8Ui3?=
 =?us-ascii?Q?OLJ/DpjX0jRDnuyaFyFtwwlIUKNm3klBIbZ2DHHrqDqaC6BEolEA3FBfZ1Ak?=
 =?us-ascii?Q?6jqLTu+RL1+xdo4sDjRyAUtkU7/UTZlkVpUEy7FdDDReP1t1D2pARgu1maNF?=
 =?us-ascii?Q?HzSuG2sCHQvqamD/7M+Dj0WiQif+YadKMxwORxKlUfUcEP5jQsXP5LMbzwTA?=
 =?us-ascii?Q?AfO/vi+w2xBx1TxBOIKWAvdVzvwf5SGiLV4mhegRTNG1aQyfOhItttDKj70n?=
 =?us-ascii?Q?eXOqHZCl6LsTYvEVzwfR2GvEY656X7BA1t7x66bhw7mx7IF2ci6+s+eCN+uO?=
 =?us-ascii?Q?4OeQqS+E8wZQldFkcyI/7Ai1slsweXQr1gvx2KrWIDWgiavlU3Y6Bg9T4HYG?=
 =?us-ascii?Q?WWoT8ruWI/CeN7WVgDkIKCml200/Rks1b8LNSFWKrnfZy1Gb1qqKTf+T2ksn?=
 =?us-ascii?Q?OBF9nXOFpkl8akGY61jXMk+R8HU+0npnNEx3j3hZKc+zvxspIpHfCGmKGu+/?=
 =?us-ascii?Q?Fe8t3GiJRuD+mL46Id/L5H2dZvsyOCa8NVouFkLS8yV2uBPkyh6DLB5XX8YA?=
 =?us-ascii?Q?lMH9XrWdyhnTUL2QxUZwcVwPEVNvnlcV3bEQRCAhWpBk1bE7gOi/3Gqy7CM3?=
 =?us-ascii?Q?uG2ORf6nuVcLe4b7+T16/R3MHiNiB7wR1VOyXC0uJGOiAR8Nq78EwEp2IDbB?=
 =?us-ascii?Q?+YPymOxQXOfcwLbMCBBU69uJFNElpUy7602atyUqjRAbIHwhZkSECA/vCVqb?=
 =?us-ascii?Q?Ba37VtmJJurgfrtSB9NGmnWIPGHCdf5Uocf46sd3+GMbIRYXdSaNixSqYAXM?=
 =?us-ascii?Q?7nK2XOXmKXhZPUcFeO0oUw55IAIPcwk3hNSUf9eRs/3kDX5DXpG1KyGoRI0O?=
 =?us-ascii?Q?uZtWHwz8RRUtJey5Z5djCDUEepvX8ecdkPq9iryXWs1absgSavddiBi39lkq?=
 =?us-ascii?Q?CCqaPiboBqvPxC0xtaOu79l222uCt/yPgHD7LIED5C40CMBrJLylSplNHO+b?=
 =?us-ascii?Q?RRuto6uBGZSwafNk+bkpTcRMlSm7AZWkoewAkMji4mtb9ulrGYXW4KpbOrMQ?=
 =?us-ascii?Q?goA9pWWqhQN2Bc0tDQgljYvkllKTtvs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+VwSUZ7fqnBtcBfwpYx4LXieZ01PpmdH/T+bZZ544KdoYkKf4Tulf5OY2WVHar3dlft7DEAmF63sRALzZeCxZQDzxtgX2bfhnpWcEBWErkFj1LFQ+tQ4oiKIx4s8jya3Teah4TQtMcIv2Dm7DI+1cYvOQDyOFib43CXXuBqldtEpUTxOZl6Gj1jjvrCPBG+Ym6/ZNmAzuM0uY2om8p+d0XkoptNnycJgnVEpwmuUA2IHZpQC1clasD/PuhoTcOxdP++HHCXuX1AU8z4Qhn5Bjp6sMNXCh1QiOKcxbYrEzhclfptQOERkgSp4XA9wOhUgo3uEE5uidkrh2BlSyk+UBoJ7ZONscpbjkx3DkYDC1SaB3RVrVf+E/xUJvZQcUV5fwJSzVHnCwmWTTEiCfkBJLlbFvDiFdo44KN8CIeByYKchOwdE0bFgVIeakpDXoY2UZiSNs4W1QAcaLhvZbIuuk686leBeNMaxaNdUdcuVdAbKkReifMUMvMi5wJllb/K2qkC/o90UoEiEP3m3ZMmJnQ2i/HPPfRxgl9xwI/HIQMQFiSatkupQZDQPpYv3bjshTo1VadynkXTfpfSmuDIbgdkquOOYKLalGRDHRZmI+zc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cbf0092-60d2-4199-b56f-08de78551c7b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:13:28.0552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdtAHwn/1gGm5syeeI1nkQeLjN/O1JNagQbvbgCQEzmzBtTgsctMUp1onAaTQ45B0R8xXpyycAmyh9wTJJ9plb/djaKRBQlccf2BbOm+0Z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMSBTYWx0ZWRfX3+1bZIS/Xlas
 8028t9qK6aTQ+e/mWLV6fu5MUgeT2SSgSNNe9acyRWPWeHotiyUNO4QYEhFXmfOzt1zfPR04EW4
 bcf0rQmHfDpw/BXc+V/l2gI+V62XeiPTkC9WwqnCylqIfPLxINO+4/8uVbNVTwvZEHM3Zb5Kp4l
 GQuIS968CJRYTm+OES6R3FjCK5rKcMffQx42JqnYkwtj8v4oOriHUDgrvjNPw/96Ne57Z0CXmMQ
 RqYLrHYFzY4eQsKv3XYGItnubYtPjCbt1FcFve0YkFVgqp4xj+AiThtsiaI4B4LKmwOe3K0yJg0
 fXy5I27HE4ytOPbjUozApITYMsjYpNZBFs9nADBMMZQFhheWetCU4lhwdVnRPunIwBEcydgv6Mq
 QkRhSwVtz9noTb1LBBNhDf9vbYvNFLpGvfvzIUUQ6W/QP4Mw+63h+dgBF62vIzeCig0J1waP2Ai
 iupFQYUqwCIxkDX9wr5j+4azU6Pb/DfzczI6oBXY=
X-Authority-Analysis: v=2.4 cv=TY+bdBQh c=1 sm=1 tr=0 ts=69a57eeb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=Hj78bRjHGalHXu-NYxMA:9 a=CjuIK1q_8ugA:10
 a=2JgSa4NbpEOStq-L5dxp:22 cc=ntf awl=host:12261
X-Proofpoint-ORIG-GUID: aT4hfDIPdcYJFNNJBe74DLi3s6H5XJ3i
X-Proofpoint-GUID: aT4hfDIPdcYJFNNJBe74DLi3s6H5XJ3i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7503E120010
X-Stat-Signature: yfowhr7y5h1nx663cdy71ihnem3i67jm
X-Rspam-User: 
X-HE-Tag: 1772453621-379895
X-HE-Meta: U2FsdGVkX191pM1KXmcCq+P6XuF1agMazc7ZKRnnCMK9dujoeQ1I5cQbR/LvQeQGoHpX9f0bQXjL7y4RdMAnJ6S5PEpcMvloIeijPucVbHWyhp141VkHX/Y2IGf9vkxwnqcB9bNVzcZueHp0/ELx97dCQGR8E98VLKYdAltcGuaYD6nm9FiT9vRs2jwLwk+KwIv8WeDMxd7/M5OaEO3gYD1srQKFbyksL2sD8L+1C+bkmNMomX9x7hSlUBaINFl1JwjEmeZ1YvpJtPJkVnLDKf23VIvXmMwbey1LCXBhO8EnpIoEzBYJ1Spm6UBB22ZdTdS9WJrk+HOy3LmDh3Sx3MLw7M2yGYMwF8klg40kb4nNSEm3GSVSnVOJyFsjYfHJ/RSbg8UmMXUNNGzWfKpoznK8556WQHcwNoXIbUisdNB8wYFXQQILlnoJgbxxPIKLkfeZlt4ohUlQRQOnHkGHTsCAldclCwpHQnFIO8voPoc50caqlwFAoLybdOfWeg6J4r7S8V9ohk1xDm9tAky5+vwJFvrRRScmroarHFUo1qkGU08745DE/ZweSljvXoVR+qC9AE6wqhSuVXUuHYpEWl+/BD+mZHWC86GCnKgN89xClFEsvAlu9uVWJgDoEyP2jB/g5F5HHZMDpTXFBrnEDxrSyFCEYHtZm+CmPJkV4NQD/vpPtbQdXNw2FovOaVKknA00u8GpZ00mVEdL5quaaoecy9FPM7z2iD+EFAyL3AEF0iODC4h3c6ztfeQNUSQQiLjuePtYgdhf7HhRJcjzwZkaqzx0OKxl9Jhme2uwUFF+jADLIc66NlclrFvtkpguYCQtR4Y0cySpr55jUrf5+Xhu4egY77Ua8rDLdSDQ2S9gWtbPeAwL+905B283R/rv+xwN7RYBPEJrQpeYfVo6mDHWx50YSYKe+vOrnqCthiSo5yCSj3jIwokOyYixCnqiU8wyeaQsxfcuINTK/Ih
 LTTXTeF2
 Uia2s7TUAxGfq1Qar/VUypBojXqrP3ZNXMGzmiptG6slNpoS0okgHg9zaXfp2ofQ25f0EFBcHp3uN/MAMTwOr7Y+1HW9Og0OmGAaqBjIcoaeEFIDAyUwYMyAQdwqfzP3Yd01II32sCfOWmw1bVqa4kYBOOiS1uYXaEtsqczezNorxSoseqrEHIDPaHZc99SFmB8UuNY4wZ/AAohI0t1zhttbOQTFUHXwDs7ecfiAxGrDZ5DJc25lKllL9mLTFK03s43SW2VvOUNySogHSEuOoJQVMeDH7wgX0CzU91XQwJ0WRSOhz47GoqeyXAKGeFNWPYfWErhvfMeantsDK3gAL6Q+grynV/dxvpslewxoc0OdrU18Ifp23rxErJGaMDqRwt/z1BPwAs/eKujEVoJoPmJJNuPc5WfOz7IynfONgcKaHwvr8bRCrH0iX/nDbH5jUX8Yrb6CRTuc/EToNHclZD5ZR3EFJN9Y978PrSKPmvW/epCHptI3SkVniZ0gNnA0DdLtzTRu9FANC9xXlyjwh8eBz7aj95JbdyTPSOGBOKny4UcvA5iLD0ZfeySrEvVrKAuIPNcGf80VUeXqOo/YGk/dqO3OYmzZvaYkaAqx8mm0Ybor1pKsFAvW0NDdJWh7dTUZS0CRk+yamkLcApCvF4VMLpM00uY3BqADIqZ0vk3ZXsJ0HzI8rISJEPd+APpBnOXBEOP9LJlXF1RqZoZ5W6Zlkzg7cC056qctV4Dq5NdvSAPyFn6/1rZFvhQPD4+J0NTVEWAQsyq/t3eVxmGXiksTDCQspylVPl0hTXfcBJEThm/L+2tKsxDsdz0dM5VZtbI8XwlvjQdjZYEy/CbcC6peaMkzwc1w1DZVp2vrcResBbM6uCWxm+Nz4zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc David.

On Fri, Feb 27, 2026 at 03:56:01PM -0500, Steven Rostedt wrote:
> On Fri, 27 Feb 2026 10:20:38 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Fri, 27 Feb 2026 11:22:22 +0000
> > Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > > > Ah right, Syzkaller is using madvise(MADVISE_DOFORK) which resets VM_DONTCOPY.
> > >
> > > As we are applying restrictive rules for this mapping, I believe setting VM_IO
> > > might be a better fix.
> >
> > Agreed.
> >
>
> Adding MM folks so we do this right.
>
> Dear MM folks,
>
> Here's the issue. When the ftrace ring buffer is memory mapped to user
> space, we do not want anything "special" done to it. One of those things we
> did not want done was to have it copied on fork. To do that, we added
> VM_DONTCOPY, but we didn't know that an madvise() could disable that. It
> looks like VM_IO will prevent that from happening.
>
> But looking at the various flags, I see there's a VM_SPECIAL. I'm wondering
> if that is what we should use?

VM_SPECIAL is not a VMA flag, it's a bitmask of all the flags which cause us not
to permit things like splitting/merging of VMAs (because we can't safely do
them), i.e. that are one or more of:

        VM_IO - Memory-mapped I/O range.

    VM_PFNMAP - A mapping without struct folio's/page's backing them, e.g. perhaps a
                raw kernel mapping.

  VM_MIXEDMAP - A combination of page/folio-backed memory and/or PFN-backed memory.

VM_DONTEXPAND - Disallow expansion of memory in mremap().

You already set VM_DONTEXPAND so you get these semantics already.

Setting VM_IO just to trigger a failure case in madvise() feels like a hack? I
guess it'd do the trick though, but you're not going to be able to reclaim that
memory, and you might get some unexpected behaviour in code paths that assume
VM_IO means it's memory-mapped I/O... (for instance GUP will stop working, if
you need that).

I'd take a step back and wonder why you are wanting to not allow copying on
fork? Is this kernel-allocated memory? In which case you should set VM_MIXEDMAP
or VM_PFNMAP as appropriate... If not and it has a folio etc. then it seems like
strange semantics.

Are you really bothered also by users doing strange things? Maybe the solution
is to tolerate a fork-copy even if it's broken? I presume somethings straight up
breaks right now?

Without more context that I don't really have much time to acquire it's hard to
know what to advise.

>
> The effected code is here:
>
>    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/trace/ring_buffer.c#n7172
>
> What's your thoughts?
>
> Thanks,
>
> -- Steve

Cheers, Lorenzo

