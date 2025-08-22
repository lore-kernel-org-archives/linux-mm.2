Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77603CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 15:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A498E00B4; Fri, 22 Aug 2025 11:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DACD8E009D; Fri, 22 Aug 2025 11:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E288E00B4; Fri, 22 Aug 2025 11:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 579C18E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:31:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BEDA14022E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:31:40 +0000 (UTC)
X-FDA: 83804783160.30.54362D6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id C588C40011
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:31:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SUbHdF9r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NU7KEvxU;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755876697; a=rsa-sha256;
	cv=pass;
	b=gr8MFg9PjSe0684t4jUHrgw+wUz7tKYk3V4FERSSumgkbALTacHwnlMSlw3KWxdT9W+upc
	vbCKX2zq8JPWddrW5JVwC7RjMvqMZ094tu5QjW8sEHFUkV/TEg6wX7Xw+3X4Jsnq2KweLO
	q5slywh3ZdwqjvdMlLoZS0UuVSDHBRY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SUbHdF9r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NU7KEvxU;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755876697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0TE+XnqRM7niU3T6+bjJnBMXiRpQlENKxbi5NaYz0TE=;
	b=z9DlFRqxwL9i3mzAY/jEbVWAvtJdfrtwvCNP4g2h7fYlZbBdWsCIsEq6SYC41kZPNnG+UB
	QcOgMDqCZIHZ73X1GStwmNP3lvmrp4zt0vV84kFYFsZ/G2JyUWOMW5e//SRLVKqxxmxyG7
	M0tgVC5lfrKyuQu6xHOB2RVEOMa2kwE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MDmn8w032589;
	Fri, 22 Aug 2025 15:31:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0TE+XnqRM7niU3T6+bjJnBMXiRpQlENKxbi5NaYz0TE=; b=
	SUbHdF9rLP8d8VYlohndMtOi12jXfg5VahI2S17UOOs/u+M/IO98xKp8k6cZ5ZtH
	cZzEvb1Dwm73GKt4nP4IqBR+C/mdXHe/6QasXQhf21tNmll3TjA6jqaVA4vg8Kui
	x7GNjldyVPmTlrQtpJyJyntkFlrPjDBwAdeWiJnUNbyL+4dQCUeu/GxlG/kozDDN
	kLWZLe2X5Go+hCeomSMSaOPuLY5Wy3By6dLfHthsAp3r1IfRSR0147KYI2gPNLiN
	gVBJ5pptjzG5STdvsy+uTUKW5vwuyrd7ZqjNqPiiwoOq/g6bCeRL0SoG1yIapaLF
	P98pHhvpLUsMK0xED3Pbzw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqx29s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 15:31:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57ME6pDI020631;
	Fri, 22 Aug 2025 15:31:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48nj6hg10f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 15:31:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEcCjnT8esSGJW03hViNAsWKdBSuqnKGoROV0ioh05s5SVusockFmC6h4wIEuz7J4bPjlRjOqqdE1jOZi5TPp/Tx7iWvT99DTnVJjv6hZDSJiCLDpAItwsNHEWl7j6TUej7dqZJ5gslHjmbe+CAYoBf6xP+hmXTcBWUx0hH2c2s3nGf5UVQiErmJd8pQ7tCiy1GnVCbDjlyK4UzSarYAMZ5GkhHjUTUyv7iVziKp/kfUF8EniL+0vvfi+r01e5jWPTpXNNomrykDnuPmiavj+ZRK7BcLaWB6CYgZ2MkxAJuh9zXc8tDpo9X4IkTQNgwcy34w8OOryz/5P6XpPd5xXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TE+XnqRM7niU3T6+bjJnBMXiRpQlENKxbi5NaYz0TE=;
 b=IU9/4M2qpmdUoTVlopMNgl575FjdIerNSWFiCnedEwOm7FwgmsTIvYlKKEIaboIngLeiFUR/DKSc02f3h9ur32mQszFoW9hmssxqIWJ1xTacYnYaupsJadVXemwZOItr4xxYhMQUJxB84FaLZq64OTxQDRmbosubTFVwb78IA2m2/i4Xg6C6y3H0RRMxe7p7jO/t/82WbkxPaaDHW8Trz6ZSCENbIREFy3BChyW4U7Ge23tmVmuNb/WBsARQJ9vadNPcPh5fZ63GZqSsUDCLcHfdVzxG5cy2cOCFTDjtpwhBqoB/ZWFOBRzZi3X7TdasA5+CDhsxYTiERisrhfaCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TE+XnqRM7niU3T6+bjJnBMXiRpQlENKxbi5NaYz0TE=;
 b=NU7KEvxUzUrhaUIaRfK7gV2b/vP24JofMo7lwC8nDkn1t3owr8sw5p6jEb7/JPJSfM/oybeFdfMI1Cd5iZ4BKjkk3un2nkZnIBaZvQWDd2OFT2K20Jhg2Uj/HSb6yFRl05kRiu9cKPeuuN858Ok0eDqY2jLntfGUgNVpNQcHUIc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB8217.namprd10.prod.outlook.com (2603:10b6:8:1cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Fri, 22 Aug
 2025 15:31:23 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 15:31:23 +0000
Date: Fri, 22 Aug 2025 11:31:19 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/5] rust: maple_tree: add MapleTree::lock() and load()
Message-ID: <mrc7a7s7g4ylxvxfezwx3rf7ry7sng4adn64i443aikpjfz5ik@jq4co7zq7ryq>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Andrew Ballance <andrewjballance@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-3-229b48657bab@google.com>
 <38B2DEA2-774D-45B5-8923-C5330B975FB9@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <38B2DEA2-774D-45B5-8923-C5330B975FB9@collabora.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT3PR01CA0053.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB8217:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a3f022-3a77-42be-48ac-08dde190f36b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFY4cG0vYlhPOWxJWGVWZGxMc3E3UGtZcXlHb3Bwd0tHYmlIYXRCWlBrUGxK?=
 =?utf-8?B?TEtQRzUwaXBHVnpyOGNFVXUyUnZoVjJQdzlCVTRsYWQ1RXFkNElQVnh2WHdQ?=
 =?utf-8?B?Qm1NRUxTTFU5cHZkL3kvZ1g5aDVmL05wVlk5amVHb051T1g4M2xBdE1MeE96?=
 =?utf-8?B?RDFzaXN5eUwyYnJvKzBJYUR5ekE0WlZLUG15T05UZUl4NUZVelVKTnJRUkUz?=
 =?utf-8?B?TnFiUTJVblR1TFBKa04ySXJaQ09MV1dHclJGUkdpaDF5YURNcG1ReHVGZUNm?=
 =?utf-8?B?clRSZVdtUVNVQ3hSK0VhT3dzU2YxWCtLTVN0OW00by9xT3FEbWw4V3ZydUI5?=
 =?utf-8?B?NnZ1Ny9mSElwQzVCZ3hNVGhhQnoyVFRCVUNvbGhwV3JISDVpUkdzRi85Vmli?=
 =?utf-8?B?c2F3UzU4ekxQVHVKb0hMT3NodUpPOEhUNEJ4Nkpibkl0anIxQ0ZaRXIzTFRi?=
 =?utf-8?B?blFYM05iWVYyc09VYlozVVBtbjRiTm9KOW1XSllGb1RPdGNCTHpoeCszQ0Q3?=
 =?utf-8?B?WnpkT01SYkhXcjVTYnM0bGI5MXY2ZmNhN01DS2J0RStGMUQwS0xJODVJeisv?=
 =?utf-8?B?WU9WR3B3bEJsYTVYT01paWdJcGovU1JNMDREalpJbkJJUC9FZUpZT2RWT3dK?=
 =?utf-8?B?Y21Qb0UzS25pY0g5TTlZS0diTU0yRHE1NGJ4N3cyQVVNTnNTbnZ5aW9TVGhR?=
 =?utf-8?B?NU9kN3pCSHJKeGYrTjhzbC9lNFVKV21kbHBVbzRIRUwzaTBLbWU2SDVPNjRn?=
 =?utf-8?B?enZxcDZ1SGlFODYydXk2Q0g0NlA5RFVNOWhCM2JtS0V6Vk1IN0RyMVRxUzNa?=
 =?utf-8?B?dzkvNkdSOWQ2dEVoeUFiM091YXk2anNweWMyT21ybGh2MGlVRDZmZ2x5aksy?=
 =?utf-8?B?MjF2Vi9VcDRlQWJ5bFFWUVgvUGdYeUpvU0owdGxZZWtoLzZsSEhRcUNnT2VT?=
 =?utf-8?B?SmVkT2pJMzJ0dEdraW54eFdWRytuL1RPR2lmUEpJVlp0TjVKL1JkaUhOcGNB?=
 =?utf-8?B?ZmVSTGFwdFUrYko4cXRvcnNQRHZHbVlkYklnR1A5bm0veWxtV09QTFhqTzh2?=
 =?utf-8?B?MFd2TTNHbE1rOEZnMWxZcmhqeUVHdWpTS1lMeWNBMzAva0p6bzdRNUMyRzI4?=
 =?utf-8?B?a3Jpb0hRM1NLTmJXdmhIVFhuOCtpblBhYXM3b0dVeUMzUkJ4RzN0S1EydFZR?=
 =?utf-8?B?NTM5aDdmbGl0T3BXK0YzNkpaL0trUHJTMXo3bzdWWGZrRWRSRVpZWmQ2WThE?=
 =?utf-8?B?enhRL3JDSW5hT1hSRUxBaklhYVRWWE9iM1QrSWp2RkdOU3VMdjBScWVQbm1l?=
 =?utf-8?B?c3RNU2tvVFhINFB2eTlyTHN0MFJBWVMyWWlCY214S3BVK2ZNbGt1elo5eDJE?=
 =?utf-8?B?Sk02YmE4ejZMZlRJY0pDVDlsNWRYOWszM2RaUHBMNXd0Wll2Q3JLRFAxWHVD?=
 =?utf-8?B?VEY0bDFTcFVjS0xzbisyOEt1ZHFIYnBKeGpHdktwdlhGWjB1cVNHWEJVSU5T?=
 =?utf-8?B?S3pybUZ1SWl3NmJQd1pJMXEyOEU4SzE0djZ2TVRTTDFlSFRZOGJ0ZVloWTZ5?=
 =?utf-8?B?SEwrNTdWbUc5WHRnYTlNTkl3TmJ5REduWWN1MFptektSZi9iTnlDcFI0N2xi?=
 =?utf-8?B?SmdRbkIvTjRRVjVieFk2SGF1VlpOWElBQll3VU5iMGZITmxrc3VxSldYcHFu?=
 =?utf-8?B?SVRGYnY4TjhaSEhlTE1LV2tjTU83N21hYzEyVFdQM2pHMTFLRWFLbG5ZWWxh?=
 =?utf-8?B?dEJWUnAzWThoVVJPTHhlUWF1eCtDS2VIOWFEMUVjZTZXdXcwNjF2dERoeFIz?=
 =?utf-8?B?VnkwczhQZmJJTXhTVVNQL1N4ZFlFU2RCbU1NQWYxOExjSWdwcDlHV3dDY0tN?=
 =?utf-8?B?V29pYkVpUTJobnFHQ25sMzdxL0lZT1lQYzdiaUQ5Y1YyZVErb2xLNURvNllY?=
 =?utf-8?Q?BRB+gDqvUFQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGlGQ21YZVVCLytrbzhjKzhMTjA2bTFzUUZFY3ZJRks2RUNvMyt3bHNJWXRm?=
 =?utf-8?B?RSt5VzN1YW1jOUpFaXFHWGlMbWhJcmxwQ29KYnBZWmo5MUN2cTdIeDJlOStR?=
 =?utf-8?B?OGJBTHNEeFZPYitNT2MvVjVWK1IvZStoMzc0c25VNnNlSWl5bERBWkZPTVpx?=
 =?utf-8?B?NjcwOUwzTnZGTG54RndRQVY5OStpT29wclJESnlCMXhzVWNxem9nVGRjZHRL?=
 =?utf-8?B?OSsxR1oyYUhMWGxVNFAxeEx2NWFZMVNmOWNXVnJLdURMOVFLSFRMTFoyNVlB?=
 =?utf-8?B?UDRSSmxNdEttLzE1REdSTit2QXVZbGtlMWxOWDlRWHYyZ3FnYUZlbDR4dlE1?=
 =?utf-8?B?NnppaVp5T2hjak0zY3dDK1dHUzFvRVkvWUNPSnRWTFNCdEdCa1BBWHlhS2hS?=
 =?utf-8?B?THhsZllGSTFxb1g1MnRvQUNJSHh4NTBZNHMwME1lMkVkQzF2aFZoMWFja1Fw?=
 =?utf-8?B?WG1rakxsWWZ0aDlEWUVicExhSElOb1FFdmJpVCtGaUd3TENzell5WUpNVE5z?=
 =?utf-8?B?bEZpOGQrcXZqUFFkRTR0Z3hxRVNoTWFyMS9Yd2ZIWUVkSFRsbzczYlozdzhC?=
 =?utf-8?B?dG9KQTFlWXhFaGIrOWNOeDFleHRLWG9OQ2ZXYlZMUXQ2aHlWU0FtdGticHBV?=
 =?utf-8?B?WklwdXZyUDRHQ2RCRlZUOFdNWGJJMWRSTHBkUE9LNCszazd0cEhaNHNnSi9C?=
 =?utf-8?B?cU1lb0ZXMUVjckRJSFlKa21RYVU5Tk9kazZUbWpoRUVhQ3NQeHFnNnhsQWsw?=
 =?utf-8?B?ZG9uQnJINmZsSm92ajNnVTRROWM5UWJ4OGxsWlhhY1RyK2ZMVVFHcTZyaWFR?=
 =?utf-8?B?Vm5rcjJVczlGc1NaN0IweENHMlMrYVhvM1gydUpLdnREdHVUODRvREFtUkhH?=
 =?utf-8?B?YVZ1dUVla3RGdkRRU2ErZ2MxZkhjOW5iU1dneGpaTklTd1FuVWZ4Q1hybzhj?=
 =?utf-8?B?NjA3QUlnL1pNUXdlNzNOV1pmcnhjdFhQUlZ3K3lsTEhjZUN3NldncjNxS0ZM?=
 =?utf-8?B?SWlJaFdIT2VndldWNmJWeU5YamEzME03MS96NFhSQnpCa0xVaSttNkxXV1Fx?=
 =?utf-8?B?dnJwUnk3UEI1ZWZxM1V2cGJwN1R2d0RjNjRQZjFrZEd0UG5LUzJJTVN2cENN?=
 =?utf-8?B?QlhiMkpSbFB1UEROZDBnazhvYkV6a2laYk8zNWk0NG9ZSUV3V0plblhnam44?=
 =?utf-8?B?TzQrMlpFaTN5SVJIcHpOUWhDNXMvUU1mbml3TUROcEk2djBad2p3U21IN3dH?=
 =?utf-8?B?dTR4Z21Bcmlzb0VIQVR2aGJXK1kyN0VmbDJyMG9SMGFsN3k2SmlRUVQ0YlZ2?=
 =?utf-8?B?WGlBMFk3ZXJMaFl0OEdnemdIT0ZqSTBQdjVXZEo0MndNZTEwT2owMy9uNEhj?=
 =?utf-8?B?Sy9hbFA2d0NNZkFyWVEzT3pVcXFaRUhadE9SUlFreGxETytjcHZXblJqbVo2?=
 =?utf-8?B?UkZHdFZVait2OWFwRGcwNG5KZ0p5OElnM1NFZ1RtVUxhbXBIVjlmYmU4QmZW?=
 =?utf-8?B?Vk1nano3RGFlSWxhTTYrOFJVdTJDLzZuUHpqWUZoQ2lINmN6SzBtWVhaNk5N?=
 =?utf-8?B?WlJ0b3JSY3NJSFB4OXZrS083Y1RPYW9QcnpNRm9VaHAvS296T3BKM0lxSy9Y?=
 =?utf-8?B?aXZENXlvY2t4bEZ6K05sRG9DUExxa2RjMUNRak15bEhKQTVpYldKcm1pZDIv?=
 =?utf-8?B?YzNia3Nheit6aTIwMGRVMWNhT3ViazJPdThZMGtCYVBpTEJLcTFYcUV1NTkz?=
 =?utf-8?B?MlJJcXdFN1hDb0tja0FtQjZ0d1h0SGo1aDJVRUpWMFlnS1VuWGpKdDVycDJi?=
 =?utf-8?B?Qnk5UGhDVW9jTExCNGwyd052aFlUK2p6am9saUg1UXBiZmUxZ3hLZ1BMS1lw?=
 =?utf-8?B?dE95NzBRL05XWFphMWtsYndyMmJnS3ZnZzBzYmdnVFNRSG52WnNTZ3JHMnZZ?=
 =?utf-8?B?K3JBUFNmM2JsZ0JHMGRYejIvT3c5aTdmaTdFRlJSa3JCQ2FjNjFBZmw3TlZy?=
 =?utf-8?B?UE9wYjZDWDM2SHYvSFJmSS8wdW11WTdmMm5wc0dqU1NSbzV3SCtMYUk5UEgx?=
 =?utf-8?B?L05wdFdEbFVSL3ZidVpxSGU1VDc3ekYrbEloNHlRa2Evejd4aEo2VmRkNVBy?=
 =?utf-8?Q?qgL4y72ymMZkeARXFH3g3dxTU?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7Iqj1x+0PkdK2j+Wzgm7DDXPEqQaLTm29uWh/p05zD1PnijI16tbmVNfLVwxeaYqdpUfY4nW1mhgBmXkBq4RK9BKf5xSu1L/p2OLx7nlLhpacj3c6sxcyXccOvpO/9eAQBOx1fsyPIXZWxrsIxPuYn6YtYeTBVGlbVBZLYxFHzqZyoJ+fMhbGKSGuHnSiLJVNOSBFjf5hZMi5X+y0he5DsWqLPeHb9K6zdB5HAhdetPAjecovUdbtkTW+UXGCV4e5OF28EI+MB1/3TQylm7EIgorAVi+Hu/XrXoB1r/035aeLlXFZSER91UOT1rYKbUi90cHqpJKMO07AhPJgpg0MzqubN6ARfpsjo0HmbZUOgv4KbxW07S/hVcYYvg6YeFo5hmrYOYKBepNwVnVKxu29taJUQ/iWlfqoPqN/pmrM9x69zKljuMAMToArZMfh6lxTcVcevnYv903m9TUwynF6xobMLqNJvgISAzUMAMpZSySGVBFJnblV+8BR8D+Jyb3z5RVSunq4MdCpM/1+oLRpi4Wv0XOqPxYNfwpY+a+M0E6n9E3FFTMrDWMSk8iBABJKXmKne5Cz9D+p6OoGDmoBvH0eQb3yfrRMC9nAbtdIk4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a3f022-3a77-42be-48ac-08dde190f36b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 15:31:23.3872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cuUYmDSoeOmggpH2mJuP/LrjNnetPoOol+QhkLupGdN0PQ1O3r6DDQrohELXD5eXt7KNGqeo7meHNCjAmDMn4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB8217
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508220140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX2hSXnpe+jeMy
 T03qFrNmqEWMAdHneecUvD+tylbp/B8tPAselmQOHAV1fjzNjmS8Eci2cEpWr7+zZ1kThy1uopc
 Li/w0k4lzoKX7A0K0sjEqklvqy4uwt884tLMvpejVTGrDYvw3N7b5NptrY33Bqiy5JthTLrn/qB
 gbIdHL/LYU77o/ExCaAXF0CZcTqi0NdCSpv2FWEhm05lMuuLGP3r5va+B5M2HKV+A3Kcm5Payl6
 bv+W8GTM+QtmJyij3VG2W6/U/zOL3VI1QwCvl3YFwqofl50y1qHagyHLFisAPhvMj92Aqzn6wCK
 BK9UArMdBfyhOBEzthvFk/8F09RF/jexFGQefh7nDgWUNIzV2cDbjQfXBYxIqANGa2rdN9LVqeR
 Oubjcgrz5EFBwkcFj5Un7veauJatXdeJVNgT7nPnNqpH2MYMYA0=
X-Proofpoint-ORIG-GUID: wiMyRNr8YlnuS39kYrj0194laxtAy2zm
X-Proofpoint-GUID: wiMyRNr8YlnuS39kYrj0194laxtAy2zm
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a88d4e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=QX4gbG5DAAAA:8 a=1XWaLZrsAAAA:8
 a=pGLkceISAAAA:8 a=eCHl1Wyg1uum3Av_NTcA:9 a=QEXdDO2ut3YA:10
 a=AbAUZ8qAyYyZVLSsDulk:22 cc=ntf awl=host:12069
X-Rspamd-Queue-Id: C588C40011
X-Stat-Signature: 8rbj7nnkd5sc5oih6u8jqyz7h75antt1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755876696-843072
X-HE-Meta: U2FsdGVkX19pr4VvrgyPPeDEC/v+ju0sxkP0XbApB7hu7fwCLGJ4+TVwro5maTg+zCTaLBgD4xPWeK5LAEYjQDzal4ufRHvfbGe8ZqjVRzm1PQyn/8jaEjArm/6Ji97Vwc1YxL+S7MhMqGK0C0tke+dzKJMIGkqR/Wa60FzkP9HWwlFSAPPt1eJSO/UCAGr9uPrphLcPaWAoxr2nNhf6nLJfY0W+dr9dSrBbnWIp712/wWAfCiVB7ywHsPFTDVblTkVaM6u60nl174zBMlv0zpDaKjJVna0lo09IarIk8eXka9qdHSv3o7+RP9VjEqbolyqUsAOLb2Ma4bkJlqsNLLPN6swFjjdmbCVzoEBwn0hoDgZ7VZb3T/6TH91hAdaS2T8ccSOe0idztfFps96Y3zk53ePPdKFeNy6l15YvDmmxFYNlw2M2FlPZNijTCX4kh1yPs9q/mjpfX5Fda4IYWr9iVCgps37WAevR1Wlaph4QldmeUBNvddiSyYcfiJpO6OSfBb9Ayo78pLlkc1/nHIsZ27z3ASGu6L2AeHGNezWhGH+OC3IGDw0ALTPfEWzraYqYfZQMMsnRR7H9VOMZ5erok1aWHnSapAVO8L1v24h/ZOX9Gr2xGBVsuUVKfBTNEHzy6QhGY1DxeGGiAMf7DAEob+TsSa5vCiUROIRG79dEbhurt5H1to71shJPfJ50kvJEI1EB/Cb9f3yPTQCKJ733xrDGcev7i/7L3meCBjzBWqoDHG0te9HxLtkDE462zF/DKmqEwFpRZhYRaPHiBKKcFZYjIIARvFTjANt4o+Dpx65aErNznphNea8o2lxjCwyr3PPGj7NZjADyDmj+DEXdwtmIZsXNEfTPG+kOKUNVD2E/GtaVDU8/eavu+MDEt6pPT9EtwnWSh8lD3f03gSZwC7d1rXT6M7/9FAUgU8j6LsYcoxEQBSZ1vbmXGiAulIJ6SowpCwmK6MeBAdo
 WO5YkUFg
 CAl/XXNXaePefrOm3MPygeV5NTYCaKQbq1pIszBwUKXWc93KrTvUNyAid4v/+CRO+h6dkHeaISw+6SVuLDfd1YZz7H1j/CI24/6/hsgHQnEUdF+gHP1C8gz42bOd8Khv4tDXggoKmphbvCBukcHBsZGPKrZ0CzyyFwW4Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Daniel Almeida <daniel.almeida@collabora.com> [250819 13:08]:
> Hi Alice,
>=20
> Overall LGTM, a few comments below,
>=20
> > On 19 Aug 2025, at 07:34, Alice Ryhl <aliceryhl@google.com> wrote:
> >=20
> > To load a value, one must be careful to hold the lock while accessing
> > it. To enable this, we add a lock() method so that you can perform
> > operations on the value before the spinlock is released.
> >=20
> > This adds a MapleGuard type without using the existing SpinLock type.
> > This ensures that the MapleGuard type is not unnecessarily large, and
> > that it is easy to swap out the type of lock in case the C maple tree i=
s
> > changed to use a different kind of lock.
> >=20
> > Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> > Reviewed-by: Andrew Ballance <andrewjballance@gmail.com>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> > rust/kernel/maple_tree.rs | 139 +++++++++++++++++++++++++++++++++++++++=
+++++++
> > 1 file changed, 139 insertions(+)
> >=20
> > diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> > index ea1bd694213b73108732aecc36da95342aeafe04..17e4d8586ebad56aee87a97=
befdfec5741f147de 100644
> > --- a/rust/kernel/maple_tree.rs
> > +++ b/rust/kernel/maple_tree.rs
> > @@ -220,6 +220,22 @@ pub fn erase(&self, index: usize) -> Option<T> {
> >         unsafe { T::try_from_foreign(ret) }
> >     }
> >=20
> > +    /// Lock the internal spinlock.
> > +    #[inline]
> > +    pub fn lock(&self) -> MapleGuard<'_, T> {
> > +        // SAFETY: It's safe to lock the spinlock in a maple tree.
> > +        unsafe { bindings::spin_lock(self.ma_lock()) };
> > +
> > +        // INVARIANT: We just took the spinlock.
> > +        MapleGuard(self)
> > +    }
> > +
> > +    #[inline]
> > +    fn ma_lock(&self) -> *mut bindings::spinlock_t {
> > +        // SAFETY: This pointer offset operation stays in-bounds.
> > +        unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock =
}
> > +    }
> > +
> >     /// Free all `T` instances in this tree.
> >     ///
> >     /// # Safety
> > @@ -263,6 +279,91 @@ fn drop(mut self: Pin<&mut Self>) {
> >     }
> > }
> >=20
> > +/// A reference to a [`MapleTree`] that owns the inner lock.
> > +///
> > +/// # Invariants
> > +///
> > +/// This guard owns the inner spinlock.
> > +#[must_use =3D "if unused, the lock will be immediately unlocked"]
> > +pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
> > +
> > +impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {
> > +    #[inline]
> > +    fn drop(&mut self) {
> > +        // SAFETY: By the type invariants, we hold this spinlock.
> > +        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
> > +    }
> > +}
> > +
> > +impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {
> > +    /// Create a [`MaState`] protected by this lock guard.
> > +    pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_=
, T> {
> > +        // SAFETY: The `MaState` borrows this `MapleGuard`, so it can =
also borrow the `MapleGuard`s
> > +        // read/write permissions to the maple tree.
> > +        unsafe { MaState::new_raw(self.0, first, end) }
> > +    }
> > +
> > +    /// Load the value at the given index.
> > +    ///
> > +    /// # Examples
> > +    ///
> > +    /// Read the value while holding the spinlock.
> > +    ///
> > +    /// ```
> > +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> > +    ///
> > +    /// let tree =3D KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP=
_KERNEL)?;
> > +    ///
> > +    /// let ten =3D KBox::new(10, GFP_KERNEL)?;
> > +    /// let twenty =3D KBox::new(20, GFP_KERNEL)?;
> > +    /// tree.insert(100, ten, GFP_KERNEL)?;
> > +    /// tree.insert(200, twenty, GFP_KERNEL)?;
> > +    ///
> > +    /// let mut lock =3D tree.lock();
> > +    /// assert_eq!(lock.load(100), Some(&mut 10));
> > +    /// assert_eq!(lock.load(200), Some(&mut 20));
> > +    /// assert_eq!(lock.load(300), None);
> > +    /// # Ok::<_, Error>(())
> > +    /// ```
> > +    ///
> > +    /// Increment refcount while holding spinlock and read afterwards.
> > +    ///
> > +    /// ```
> > +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> > +    /// use kernel::sync::Arc;
> > +    ///
> > +    /// let tree =3D KBox::pin_init(MapleTree::<Arc<i32>>::new(), GFP_=
KERNEL)?;
> > +    ///
> > +    /// let ten =3D Arc::new(10, GFP_KERNEL)?;
> > +    /// let twenty =3D Arc::new(20, GFP_KERNEL)?;
> > +    /// tree.insert(100, ten, GFP_KERNEL)?;
> > +    /// tree.insert(200, twenty, GFP_KERNEL)?;
> > +    ///
> > +    /// // Briefly take the lock to increment the refcount.
> > +    /// let value =3D Arc::from(tree.lock().load(100).unwrap());
> > +    ///
> > +    /// // At this point, another thread might remove the value.
> > +    /// tree.erase(100);
> > +    ///
> > +    /// // But we can still access it because we took a refcount.
> > +    /// assert_eq!(*value, 10);
> > +    /// # Ok::<_, Error>(())
> > +    /// ```
> > +    #[inline]
> > +    pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>>=
 {
> > +        // SAFETY: `self.tree` contains a valid maple tree.
> > +        let ret =3D unsafe { bindings::mtree_load(self.0.tree.get(), i=
ndex) };
> > +        if ret.is_null() {
> > +            return None;
> > +        }
> > +
> > +        // SAFETY: If the pointer is not null, then it references a va=
lid instance of `T`. It is
> > +        // safe to borrow the instance mutably because the signature o=
f this function enforces that
> > +        // the mutable borrow is not used after the spinlock is droppe=
d.
> > +        Some(unsafe { T::borrow_mut(ret) })
> > +    }
> > +}
> > +
> > impl<'tree, T: ForeignOwnable> MaState<'tree, T> {
> >     /// Initialize a new `MaState` with the given tree.
> >     ///
> > @@ -303,6 +404,44 @@ fn mas_find_raw(&mut self, max: usize) -> *mut c_v=
oid {
> >         // to the tree.
> >         unsafe { bindings::mas_find(self.as_raw(), max) }
> >     }
> > +
> > +    /// Find the next entry in the maple tree.
>=20
> This is not in the commit title.
>=20
> > +    ///
> > +    /// # Examples
> > +    ///
> > +    /// Iterate the maple tree.
> > +    ///
> > +    /// ```
> > +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
> > +    /// use kernel::sync::Arc;
> > +    ///
> > +    /// let tree =3D KBox::pin_init(MapleTree::<Arc<i32>>::new(), GFP_=
KERNEL)?;
> > +    ///
> > +    /// let ten =3D Arc::new(10, GFP_KERNEL)?;
> > +    /// let twenty =3D Arc::new(20, GFP_KERNEL)?;
> > +    /// tree.insert(100, ten, GFP_KERNEL)?;
> > +    /// tree.insert(200, twenty, GFP_KERNEL)?;
> > +    ///
> > +    /// let mut ma_lock =3D tree.lock();
> > +    /// let mut iter =3D ma_lock.ma_state(0, usize::MAX);
> > +    ///
> > +    /// assert_eq!(*iter.mas_find(usize::MAX).unwrap(), 10);
> > +    /// assert_eq!(*iter.mas_find(usize::MAX).unwrap(), 20);
> > +    /// assert!(iter.mas_find(usize::MAX).is_none());
> > +    /// # Ok::<_, Error>(())
> > +    /// ```
> > +    #[inline]
> > +    pub fn mas_find(&mut self, max: usize) -> Option<T::BorrowedMut<'_=
>> {
>=20
> Should we drop the =E2=80=9Cmas=E2=80=9D prefix here? I think that =E2=80=
=9Cfind()=E2=80=9D is fine.

The maple tree has two interfaces, the advanced one which starts with
mas_ and the simple on that uses mt_.  This is probably why the mas_ is
here?

>=20
> > +        let ret =3D self.mas_find_raw(max);
> > +        if ret.is_null() {
> > +            return None;
> > +        }
> > +
> > +        // SAFETY: If the pointer is not null, then it references a va=
lid instance of `T`. It's
> > +        // safe to access it mutably as the returned reference borrows=
 this `MaState`, and the
> > +        // `MaState` has read/write access to the maple tree.
> > +        Some(unsafe { T::borrow_mut(ret) })
> > +    }
> > }
> >=20
> > /// Error type for failure to insert a new value.
> >=20
> > --=20
> > 2.51.0.rc1.167.g924127e9c0-goog
> >=20
> >=20
>=20

