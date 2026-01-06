Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39841CEFD01
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D36C6B008A; Tue,  6 Jan 2026 15:07:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981286B0092; Tue,  6 Jan 2026 15:07:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838C16B0093; Tue,  6 Jan 2026 15:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7296A6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:07:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 056A3C315B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:07:44 +0000 (UTC)
X-FDA: 84302624448.09.C20EE2C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 68B0C160009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:07:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fq8uL3E0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CYygJVpY;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767730060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCuDZZeMGu+p+vbgi78ZvagG/OYQDpQx7Iru4FxLBVg=;
	b=eSYkJqUzKfQco77Lusc3PcvwVDJZUFtAtYIaljFvwYqqWWTmcZG/50zeUOotatD4bfvi40
	8vaj1W/BsWFwy/1Ph8XEy257QCM9o2HVY+qrDlQucd69RsYp2S3P8VNRYLmUJk41ffo6w1
	DxfQa+WXEJi8a3dUPpn4NiXDL7kvQrg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Fq8uL3E0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CYygJVpY;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767730060; a=rsa-sha256;
	cv=pass;
	b=yXhiR7s3h7bxhUm99iVXTPamtdqkkgEQFmxomt17g8bZPkNptA66YsKwgJ3n68lLdwry8Z
	t4JspYAAnvbsTH28Z3lB38JkoJjz6z43iRGEVgvrPsU474lOyXCYCbmfnDhO65zEexC3Js
	d6iZLTDIL8ABGeEUPpB6It3Ixg3V8sk=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606HpHcf4066323;
	Tue, 6 Jan 2026 20:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CCuDZZeMGu+p+vbgi7
	8ZvagG/OYQDpQx7Iru4FxLBVg=; b=Fq8uL3E0qkw6xkPel4BK/ao9gaCMb0f0D3
	apbGtG7lxuKuO0NtcX6H93WK8a5tBdOaUViXNyafyci6+Bxx3DN3bnHIEZ5tRUKQ
	4NUhkHUaT4a/Zfy94tteYNO3o18+yeHRplszz2FhUk68Vjg07a+GFf+45jREjYeu
	H93GIlsbNVn6MT2FzHIa//Or09iSn1zBvruRJkLvYpdEciNVGVfvhFwTn6OIv2o5
	c/OFQdPEF1z9Js5sklCrtC5mcR52cUPD3u1tIeY/d5vthmq1t/ghURpe0eVSaWgP
	27ASoPLWkKaMNUjWMt/G5t4tUaXxIYvFMXl4uzJ5VQztSwNJgkQg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh75h87fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 20:07:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606I5iqh026312;
	Tue, 6 Jan 2026 20:07:24 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjk9wjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 20:07:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDpo6jREsTrmDYsBitu9AgoXhBbySQgc2aC9qu0j4ZcUY9KuSwaCD/Gg/yVLsFVVb8b97m1rTd112LIwnoVcpkWvn/D5yPGzrReckZf2ihAJ6RQe3I2bRodyROlOxCxsApLmCwbwWf6nrqKCKVJGwrsesuMmvLL6TX5yJD3S1HOcrcuNHfSaw3sDkPdwIOpZOtA9xlYee+By1Bawt7r57RpH3R03X/WE6YmydfNDlQyDsulHQLPRHwFLEm2KrD9HcgKECuJ99XyU7IGCvw7nZBbywFDDeGFOMwOjNXmhYfMLqYvdqCu9Cv3FkgFVGnbPgkJupeH7j96k6NWtqCdjFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCuDZZeMGu+p+vbgi78ZvagG/OYQDpQx7Iru4FxLBVg=;
 b=IQ6OrZdRTdpYFWLvpApq1wDg10JqVG5AZOyem6p8b9Dc7Xm1QQutlRK6/zMua5cBRBwx6INiWo/CnhHTazgdzdEiigDW2weYNI/nnNTuw9BSj/Bnn8MaPxxI53DKPEokQKbpFtpXWl8KgBH1vSpQ7D4RhFGID93YPIocvFgsCdAnguyrm7d2vSIHy794rVXmK6LCmkJlIw4tj2FrFvy4RAHkt0twIJlrOEycsadjvDwUtTgkc+lqFyaraKP590hIgIJ+15hygZkOWmNeRMUJPm6pU3CU2snUiQTGJByGvUfDRElVqj5B1yf/BM1FQFSSKGEmMeFb4y2w5PiaAJUJvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCuDZZeMGu+p+vbgi78ZvagG/OYQDpQx7Iru4FxLBVg=;
 b=CYygJVpYRiKMW+c1Ep4nJjLYb4Ri+M04TXhlDqOEEThtp4vzmA4xlRBnDE8acJLMc1h0BoMFWAL+as7hY9W3EBOekzhJJdN5BjFf/nXSibLsRbXDJI8B4ObFERx4s7UgiQxpP5YQS4kx1EOVFSknm+kzyrSJ6xrhN+xXAUE3Ku0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA4PR10MB8424.namprd10.prod.outlook.com (2603:10b6:208:56d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 20:07:21 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 20:07:20 +0000
Date: Tue, 6 Jan 2026 15:07:17 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Boudewijn van der Heide <boudewijn@delta-utec.com>,
        akpm@linux-foundation.org, aliceryhl@google.com,
        andrewjballance@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Message-ID: <rl63ujj4oubstane6ydibgxithuovo6wqzhnjpiv2yatagzecx@vhd2ieobie5f>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Boudewijn van der Heide <boudewijn@delta-utec.com>, 
	akpm@linux-foundation.org, aliceryhl@google.com, andrewjballance@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, maple-tree@lists.infradead.org
References: <aVx4PjdhG31LfjuA@casper.infradead.org>
 <20260106132418.57408-1-boudewijn@delta-utec.com>
 <vaz4cykqkaa6qksfp6nsnta4rkzqpvaorzdsgy5orapkwx6mil@knfau4tgxmup>
 <aV1UiEdL-YUd_2OT@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV1UiEdL-YUd_2OT@casper.infradead.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0106.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA4PR10MB8424:EE_
X-MS-Office365-Filtering-Correlation-Id: 45de8c92-c8ac-43f1-0a42-08de4d5f32c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HzHZGx60AnD3RS2rQyG37yX31sK8+j3Lj+OLLfSX5zkabutAnbw9VC2q0vBA?=
 =?us-ascii?Q?MLHTMahlbvSAgDFlCgXqMVgZxLAtYXobaZ7A326CVsB+l387ffshd7VtCIWp?=
 =?us-ascii?Q?ITvNRmFOIrFW+u8SPOr9kEkHZJHwemOmBzHZOLrVdVMC7mG5RtFwjmtsWymB?=
 =?us-ascii?Q?Ev+/2lbZlrj6j3/JZMVQ6ZBfke0FeFbBw1SvBdcsF9SOUmjjprHnuUCEHipH?=
 =?us-ascii?Q?j7dVSnXs/zsBRoNx/B3fITNfT0sfGTzAwp0vbrZMkD4r4+RA63KBhkl5EPio?=
 =?us-ascii?Q?Xb1Ox1HdPjSWeROZ6r+g7FpHUULLcUwy2+EKX+w45ue9rAoLuCxyKQSicR6k?=
 =?us-ascii?Q?5hl2xPQDVYmaKyWcZ9JDpb/b/F0t36mXAgxE4CwwDdCmW2vnAE8in7t97BH4?=
 =?us-ascii?Q?dlHoN/TMTdyP817Sqjjub4ZN/ZlphnqRDuCkJcRA+AzIGAmE7YmKZd8zcd+H?=
 =?us-ascii?Q?FBXKzRW0pX1e+VDCz4XNnsUjPs5eWFMjiBnYA/vl05KilX5wk2ib8u7/9JZH?=
 =?us-ascii?Q?Jb2A1Qn+bCYA2xcHjPbI3RV1Sz4g9/yTSynl/dFCLeUEiz41Ch2O29F+W3TG?=
 =?us-ascii?Q?KZhp3YljRnTRBLHJUHzTfGDKloVyL4xz7SWtOxV6TiIYhi3ID3plAW5F9NRK?=
 =?us-ascii?Q?bd8rLy++B4AvbvF00yzbaoXpabsqXWvLjufc/XTOMV0Mayl/CvOLOaQp8tz+?=
 =?us-ascii?Q?kfVgbV93lgS/q7u1Z8f8clUfwCcKhQVHQmJP/HzqyR2n+x5caC1Wp6+R22BP?=
 =?us-ascii?Q?RvN8MaNBebV26W6OeL7ycTH7istT8l2KOCjDpHUj+JJ70Y1rkvAxrTWP4ccK?=
 =?us-ascii?Q?iJqM8GeSVbaJxFU3dSaxH5R0Kqp5tUQNz7z/TLGHJdI+HDi3VDfQ007KOoCx?=
 =?us-ascii?Q?pGaogQOwOs49Ja3yIZ06HRVSA9FIo3inGuYPQwOezhlNOmNGG7cM4t2hd20w?=
 =?us-ascii?Q?khjXIVQFPmH0QFQsnW1k2VpxIfmdoqMMOIoOyo12C5AJqcz73mh8OtPIMvMy?=
 =?us-ascii?Q?cEZGNz1BLOMWSK7ydSpRi2LlOLDrFNBpPnrA2tpk2Zb6ieYCaX8jRpNFjhRZ?=
 =?us-ascii?Q?G/TQbCRz7z5q5LZthjSa5emrkeL0k5Lt+LP5dmf0kUm+YQ8CJ1TnpRuz4Jl4?=
 =?us-ascii?Q?Dcux4Iafpex8EuAiveSUb6zBEMgBleNOkP33RqhQi4+RgmduHBlUtJ5XpuOR?=
 =?us-ascii?Q?0eH7LoF3GGsmGvuSP3CCzwB2KQoPfHuEtPyio/m+zpBAadDfyOlaxJqRSTrZ?=
 =?us-ascii?Q?WLhyr9KSjj+uAvIEJzteIY7B3CWVeqNAIJD7YAmIybS70nhTDj3Cfea/gKe0?=
 =?us-ascii?Q?ULsK3reYb8+pcrdxyS0rlrieUSC55prcHo8JrkMKKLSiSXJTkn0tWLqTM0+Q?=
 =?us-ascii?Q?qAt19ZfgxijS/LVppfvTy5NZRKqxjWhviyrlto9STz3KvYDo2pVPDLj/Z+ga?=
 =?us-ascii?Q?zrPTlr0djTTR4xaZ7/JwOP+avtlJBjNC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9dDPodG2TcQGDCiYcP0bEE2piuquXAt9l5IKG2/G6g/44H3DioOSG7yiIBXO?=
 =?us-ascii?Q?Kwg+qAsIQjDzo+CeAJrgbV85s2Kvt2eM/L5Gfuv97OEVbbeOmV22jyohElG5?=
 =?us-ascii?Q?ba1QWsM9DLtdtRxLeh9ypIYB+HjtcpCnPtBjI4abxvE2aCCLKRJLWqdEYYJu?=
 =?us-ascii?Q?hJRIcPkz2Qs8A3ysM2qLZWuAzk0GxfV818+RpyzATl71eRgnq8lhyZ8NnXRv?=
 =?us-ascii?Q?AlaWMz947NtMJxy5VuOV9X3PTGfXqA+3XwCNfodIg8UaMI03RzlntgB8VK1J?=
 =?us-ascii?Q?T5RKQPjz7hv8i+acOvhE9me862UVqHBOL9odNTR9Yuc4nHzZy4diYjeF4KiG?=
 =?us-ascii?Q?ksT8ClXz02S/MfAFXSItBSfQrKXYollZ3JtntWAl5Jgw7R3hfDQJ71pPmQQ6?=
 =?us-ascii?Q?oBSuu4mAuivbJD3EmHhg723tqwxp66GLE4xUJpkPu6Hf0jA7lluQvIm7Db9d?=
 =?us-ascii?Q?93UI599ewEIuT18QhlYxhU2RxUm66V9qiZdNTFOR2mbFQJvOnGTtnXOBvLfQ?=
 =?us-ascii?Q?ZbyAGtfuURyO4pKRvqBzh8Lo1rQzqFEvBqmtmDHXhUP0AS3ysBuRz5lhet0q?=
 =?us-ascii?Q?q++0nkWCdCqQL/KNlq1zHEmUe92EybIj6CSyRGABak3X9yuRP+h16GZ5nEe5?=
 =?us-ascii?Q?6hSrwouYxQZD1tI9wi9TWGH1RlQaavBdD14IPo8xbpzyGW1tOSsMsVlolhuW?=
 =?us-ascii?Q?Vm7e/wJtiZn43TUwXuPcp6fMk/ir18f7i3Cd61tAAuyrqihjmPoHP3L0PhVV?=
 =?us-ascii?Q?8mP5jpuhqZzKT4k5bDqGvFTMkt2Q1Bc38m2Avi1I5Z2qETujYoCBFOqwpOdG?=
 =?us-ascii?Q?IIRu2WwUgraBItGrUXO71I8v6sZZDdAI+wIZgWXGIk7NLIKMKYfaAOiOw0Qs?=
 =?us-ascii?Q?6duCPUpDARnhLy+Ng89+O19kiS4GQ8xJJfPlY2pTwcA/Qe46tkDWcS0nIUbQ?=
 =?us-ascii?Q?N1a0GonQkn6gcGes7WxX1kJmYzHHaxg3IbSu5riry8bmMg9hZShuRX5YKNN5?=
 =?us-ascii?Q?B4POlDdHrNUZn23isOAcBIyPvcx/NQ32ypmtK4sepJm8PRfFZgON3BXMMHpP?=
 =?us-ascii?Q?q/GcIZHma2fD+4/2ED0ovGD74QD5VGygnPY2b2vp+VRZD+8nIR60cNeQhtVu?=
 =?us-ascii?Q?1Ozffl9wQEbw4nAfuygdrWxzlJhMD0kJUJ6F9NAwQmsUUG67Bp3fAqOHXLjy?=
 =?us-ascii?Q?xMhd2ca5gHLjTnicESRu3IH8Hmb6GiiagB4eFJtHFY/1q5xi7weiIEAAPh2W?=
 =?us-ascii?Q?eMarKVoKgOQoGGVpWdjaJkkBRk7qT8vQvhCac/xIDD/GyDhkplC37YddiDNe?=
 =?us-ascii?Q?eTMH4Y8qpmzvn+a8Q0gCi5ygncDX1naPZAJlkALhk/NAvu6FzsvndBmlEwtE?=
 =?us-ascii?Q?2j3OOLL1aBWci+qB/+Mzxyb1RzJY46O6COUv9KO6JbMbMpYD7ulAftm5/UcT?=
 =?us-ascii?Q?26BtaFyo97a6IynL5Mf2dXE/vShMkuOZv5zIvHc1KYh5vQMJi02W9vBiBn1G?=
 =?us-ascii?Q?acDWEirHI9dzseOsPIEYIvwGPqi4q5tfjXuh5LT2jOueX0wjWeKQLqd6nxBB?=
 =?us-ascii?Q?86DkCQoTa4sjvrm9nA8NxO3swV9MxFljFlgMCPOP7QsJiudgrF7vxiN3VXxF?=
 =?us-ascii?Q?AfZlm6GLKWnm6xCRi91A8DBk6w53NTNJYY3jBeoK6ysBaZJ9Iaq9vvyfIWxD?=
 =?us-ascii?Q?23Vhq+OTrX+UuY0A9a5jRKmTbSTk3FwNjcV2N3SDlqv//640lzNwseAs7pVJ?=
 =?us-ascii?Q?VjLNwUnrpg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2c+xrYyteCOiFGvMHP6dvnDkeB4y4Jg2ggGK0afMKG3nXe6/QrKLI21FZrjbf5CRF5Tbhiou7mxxdVphEL6iWtzaDWSTouHN0Xp6mXC+n1P7XqAXYBmEeNDZFQqg4JIxm7tB1xLMZWD6BJ1VhuvzNTrpFgXI57Upyv6nV32o4zpmvEC7gA7PirBWOVHjL9x9SzqFFB2OyKg0Yj0j/thccIeC++bhc4dhpce511iRqpT+Fb330E1+HZCLJBU0y1QXPEoimXFYz8IB14nLqPMgEXSPE3oRFH1CJKbu4h7mCKwIT3/xe0MLudbnK+hdKz5zqeSgVhhnCaQvF8JkeBSUEYfBZUYajqPIM2KZ8iLcoPk52j6A+JnLCFBg+eSp6+WgLI49rFz97soP+hgPVzegmV8ozUhtmZNI4vOqtKFCxJRnkY4SN37pQISpV3tDEP3zerG+3PqVsrYy19KlexNe2QSnxUVfosOERM3/C7JitcoyTpTyuEnf/X0tBeA6R4Q2/1CTwBkHsoyGHH6fDLhU4yMgeLHeG3/uWsea/TrXCbbfFGaY9Dna3jttW1WhhQUGkziHj00ofDm84A5BTTvQLhXmPkPBIMkwt5JH+iOULjk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45de8c92-c8ac-43f1-0a42-08de4d5f32c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 20:07:20.3385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1L8DQfgSUEIclQ9YjLpvzQOZ7/wjjRzyNba2AH9IOFPMeGw2vxLx5Y5ntbccgmJnGyMA5hMvCmZkrLzc52+cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8424
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=603 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060174
X-Authority-Analysis: v=2.4 cv=evLSD4pX c=1 sm=1 tr=0 ts=695d6b7e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=sR29IfAUcxGsQ9wXezEA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12110
X-Proofpoint-GUID: GH9kF4hMlMPrfL9y2GnXXwHe_Lid3Rue
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE3NCBTYWx0ZWRfXxyH6Sfela7+p
 izcn5+72fUDoKQ+RqHSv9qJM1dmsES4MqgqceM+w7OQQc3YQlPFsdOh7abVY2/4OSIpuaVPqMlj
 JaIeOT3+ldJRWlEzu4el5WDW2bMLr9MW0vKah1xq0VpcsE3Wl734k/rVJSkjgM0GxiqAAmPpkVN
 /I6TTfLXN9PYfSU1yUjhU5ljDbi+Ype7G3BpAsRPJlm7bwCVq6/O5jDmRQZaGRv3dsiLWCYh3/C
 uQm079/Pd7QxBYfTCewehlMsRcD1Xc+nHmkNSdGR4YufT42VplLDmfNRx8yVU3ckQQM099SJMRZ
 uZdXyM3V/KNqf/y9GCjyDQpVoOxBJG8uJ47Xdu1IKHXbpfsk8sHhlcOY5edr2Ts1Hm23rOR6CaZ
 rgrGO3/u+uUhz5psgcDTO5CpMkQyjWdz6M5G9morDAIoe228B2KF1ZkSJPuCRUCpy0gzMZy4twR
 HiNuH1fzz567c+/bYsoWHBGnmjslbFiK3/k44L6E=
X-Proofpoint-ORIG-GUID: GH9kF4hMlMPrfL9y2GnXXwHe_Lid3Rue
X-Rspamd-Server: rspam02
X-Stat-Signature: t8ur6hjapkpfx85xi6i596kysjez39ze
X-Rspam-User: 
X-Rspamd-Queue-Id: 68B0C160009
X-HE-Tag: 1767730060-386686
X-HE-Meta: U2FsdGVkX18hQWrOsFw62stSLOfjptyaQ8IlJ3Nlb/5RaOQGfwt1gBaM+rySwBSmaWdA2Hj8egDoAEiA7E+ImxmAAkMvM3NYmBFaU9h7VGWFTo+n/Vkr1Q2MEyJ6/GYdBHz4oGlLy+TwseFKGBlsZWnv2+ZBy1+faO2KMQ97b+0ojt/Cfp//NrdcWUmkkzHh3fB4WbL8/MSjxtrsg0oqmpLMMiwx7Ev5LlCF1LleH2L55d3tmWknQqCJ+YDAbAQysnrlWSuO/uVATyPVL4wyNZq/zEw1NGabkIRlFzAGsi3+gba4I6FBM9fp1BXe1I5CcYsRha4aVOJ7S3sunT9V2mqauz3ZVO98wplevIbWPg/QXD7iAmr7QoA9mMwCXFmGnB4GeZ2Tz9MckzhHw7DTFitRt7KKkv7sEglhZQDttpgcYQ1twrRKUs/qqEry5yI6nurEYZkHp4IzrwzPEvhLuAbgWKOPPbcdqomq13xwQ2YNSL6Eqyv/iMnC8rYI/KedjO+DyButqfI9S95RNxJyHLcoZOyBxZoJyJYXEc6PZl1NQqtuU5B0+hmmkTtSeSTsdVuIzDkHnOUkNF4DMWy/TTboaatqEAdMG13c4DGAdlddN9FgJv5fltktwpmASknjERqm1rMPEGZzyDjqMSG+xWNsaW/peqdhBsWjGGuiyw6Z1t7MSwRTFU3FRKU8yBYafG2W8kSl9sYah6Qh4NweOAYPude/72NzGroWjhtLNLT5aj8prVDBuinTwqT9xZVPnYB3OeUSkKXA/XmbXI/eVDoKvi+9qVWDFWV4AbepWabQEmXQmKWoZzfkiA3Pm4uprOkWmX5beGunvF5yiJxf1lQq1KjMoAjNxHe+KUUGHLNqt2Z45oR6xMke9CX6RIsVeY9I6F+iJN3SEULb6sXAXuwPv78LbPxbdVQEqPIm8Fwoae+knWaTDu/Kj+m+ZBNEn8ZB5kYPlxsdX1BseMJ
 IWzSUHYQ
 U2eBXG9m9nKWv6XyPe+QHFLNi2pvWW3xrSQwyGRwSrjJNJ4+W1LVRP0PJkTeBvsDhvs/VmQLfjxgq6yarXiklISUxRwAD06WioDRRdL9z9D6BGTLf0wN3rAdG2rVn+KwmMogTMQwgS8e3Mj8fPeMMHlHc8flmSbx2hh7OHHuJF5K4n+zNp4tzdEVEtTnCm4FXZPPFlZPH4AZH4o+N9ULArxcDy8pxQvHVPJXmOaATUXKXbIHWh10KLJmmpZIF0YSTar3OcrVqQr2EedGIn2jnms4+ObNKxvykJKfIbundtK+jXV2O/BB76VOGhyUSP2cWNLoZcLUFwga178cPqCN4sVmTt1u9g4/djEjeWOX0GITwIo42Fj5Djkw8ZK6BUjnHxO6g2heCrkDr0qvmc7ARStOil0AK8srWmQ8CV4eBE6vlR2fm0nQKDsVZFqPSjxK94v2JWzESoOQI1q70XHJyn9bAI8mrxcE4IsY78nOHLwnStPMa3JvNLaT5fe1uzAYQfA+oMUqvV1YJND/gK8y92T4fL52akv5Q+Y2vZnsajmwFXYgiWNL4eqnbs5lvgHnGrqmNA9NqdXuqTa+96iwtX8i4jmU2ELoQKi/3GYmH669ZQE1M7uslR14SWhzC0/x2XIDqPktZC4wPwwVO8xBDLATTfkiyfIV1PkocK+dESOIxPGfcO6a3VaqZg9rGXU6f3XYaMSore5GRHVwKe7561Bl/aH5xHH7IczQdakqV2dIR4Us=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Matthew Wilcox <willy@infradead.org> [260106 13:29]:
> On Tue, Jan 06, 2026 at 11:01:27AM -0500, Liam R. Howlett wrote:
> > The fact that no one in the tree uses it incorrectly means that any
> > backport would be for the benefit of out-of-tree drivers, which we do
> > not support.
> 
> Should this interface be EXPORT_SYMBOL_GPL to make that clear?

I don't think so.

If someone decides to take the technical debt of not upstreaming, then
they should very much read the documentation more carefully.

The locking rules are stated above the function definition.

Thanks,
Liam

