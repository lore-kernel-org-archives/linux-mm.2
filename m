Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6357DCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9228E001A; Mon, 10 Nov 2025 08:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9808E0002; Mon, 10 Nov 2025 08:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A578E001A; Mon, 10 Nov 2025 08:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5508E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:22:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 325AE13C352
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:22:39 +0000 (UTC)
X-FDA: 84094762038.13.7EF8399
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id D50801A0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:22:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=A+xaxbFx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=plISo2QP;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762780956; a=rsa-sha256;
	cv=pass;
	b=29S5RNSoLsr5pif/EBycLMNnQGgC22WEL/DCrjV1EJF/u5yl8QKOxcRP2Wg/6fK7Iudksc
	lwM0J8j2S/i99pPsmue0tON4OPK5gsa6mwTCAsvjyKWgD3GVjGmwIBmPZHAAwatd+6ow2q
	5LStv0qK0IQ04UscCtzGaq3QIPLoCus=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=A+xaxbFx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=plISo2QP;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762780956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbygf3JKTZxjYxhVT2V6BHETaypE5f0x6ZXQsMEayCA=;
	b=o60obadA3iNH0L6RCmVBX8Z1mdp7kEEFV5sheogsKZxiI+5smTiAyOplxrouyT6CBQ1bog
	jPUWMpxF9Q/sOqKs469wgdR5IyzhDLjB7sHELQmxeK1ZT/ni1RP4XH95SaNCsSUQ2asllZ
	MLAGHPjWiQP5xljW856/T7cXh+zx7ys=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADGT3e022134;
	Mon, 10 Nov 2025 13:22:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rbygf3JKTZxjYxhVT2
	V6BHETaypE5f0x6ZXQsMEayCA=; b=A+xaxbFxVrvzYX8FTQ+d8SROHXmT7zr46Q
	svBuIvXif7e7v0r/fkvhnYEyJTFnIDSCbk2hz8ftm1NCbMmvAf1kEaoTd3KmfWLX
	tZJpjcXV6PyWAYJlExl8d2sFEqz5+i9nsMz0gGEwymWygpnZhFZuOdO9xbpxot5O
	zKTuor3d4NanACQg8io8eCk05Zu5q65awzuIx1FBQyn40WFsQjaQkSnEyUu3E3Qc
	YsnbP0CVJS0Qa8Rfo/pY4oo5gTRy0d/16y4ntEUX8nf+GtF3RzFGeBgMwDMKVTna
	QWmgOkDdN7jVYH4qRE7aYwuEeC8fDjRJ+TAZFR+NBHFIcOyONPdw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abfp7g50r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 13:22:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAC4ugT012741;
	Mon, 10 Nov 2025 13:22:23 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vabmvhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 13:22:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f70uHj+JhRiO/v4gHva+c0EIycbChFRZwAjwcbeO1DuSCn6kdzX5CqgJitvLpkBs+H4mihvkKf1B4kg3APGi/4ATyFlxwiAzSHf4MtkaZNZuvdTBMZR4OD+VjJnHpaGt44FtX/yxfMXTZaXu+SIW4xEyq+aC51fWE7QhvKTp2lvvpSgFxnXculF41NpVnE9VnRlGURh5508NU6DB6bmg1xq08NYkmDZCXBrxbO9Q9BczKUTR4yQJyd8Mf0T1vyrSsltjphbNnshL//cAa1npmgrcnrvhJTx6Z2mAQZQZEPvnDE2QwmdOy//y93S/0LhDNrrCvFsPPuikSYTXmH3zqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbygf3JKTZxjYxhVT2V6BHETaypE5f0x6ZXQsMEayCA=;
 b=mQhRrWA8gGRHcobdDon/rNak35emCynUXKlY/mlW06pIWx23wfj1UVC6s42itX0M1Yvyy9IA9Bleye6cUnScdOQTB6J8chejaSQmOZqzl3xM9AG38FOuiNs4PsMCTy0gYymUMRRfMOv/67bm4or+zQxoGV0nJz1Mjekbad2K5e93FCWmGIqpEHo/7L2KM8ypLxR2rwEefWEyIYu+ffJVwcJihXBn4MgpbUsNlkIWhJ+WykVIJZOU5VUX9OHZ3kKgO5usbADn1J9z1OQpfvjyQXrqgK1NQqGwHDlyT4PI/bmP4W0Ip3qGCpJP4pb6JEHJW7WjYsQU1p7y7BMXNKGFhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbygf3JKTZxjYxhVT2V6BHETaypE5f0x6ZXQsMEayCA=;
 b=plISo2QPscXCw3QA2Ewyn5kzp77jkohsPdSpnYXlPDL2Uw9d3L5XI/gxgewBtFNVGNNKK+NiHMY00Vw60Ry2CFZ5ZudpVAny+GFhGvemCQqvheXY5LoztkmITHiJQLxg1lss5wFxZ60pZHb42adF45EPqoVElK0qscasG0ql1Xs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8517.namprd10.prod.outlook.com (2603:10b6:208:56e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 13:22:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 13:22:18 +0000
Date: Mon, 10 Nov 2025 13:22:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <bc07aa10-d8d1-435f-9393-6c4ab63cc179@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
X-ClientProxiedBy: LO4P123CA0075.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: 7165ddf0-201b-4ca1-3e45-08de205c2c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fBy274zTf1Cgkkr6mg6Ykzg7QBYGayGEOU7Tuv0s5SmiUUbU+AitBMvLdeuJ?=
 =?us-ascii?Q?Jrlz4mjKIBkPB7IUxTMbcWBVymELPsuO6TCoh9AytbD0hBgljQLJA5vnSPeS?=
 =?us-ascii?Q?wONVLEzBP+6PPsmIeFlCZDOwyKsyGja5wUsShJ9DeVEuSEQZfAk1AWYd7dQg?=
 =?us-ascii?Q?j8jXgOm5q+qyWOGBDBlgXsEE4JagW5oDtmcWeEG16uEh4SQEneAbDbHuGuRx?=
 =?us-ascii?Q?bbKf4/3fVg9xwaR/D6EcN+JI3ZdYm+knQJGIsGlKFXr7isbgqHD5IHvSZehk?=
 =?us-ascii?Q?zgrrZ0cQSbqcQ0G2SHJCZHm3mvKxqIq20PTO6EH87sgA1TCMYxJgqtsWZP7n?=
 =?us-ascii?Q?dcBcxKAmJbv7bJNkzIJcKGuTsR2oVOfMWldNW5C2j/B2riTpUhSjBKdaE3QL?=
 =?us-ascii?Q?aOnStUnLVd8sTp/RoWIS7H78wbwRLf5V/TSKo/DfcXULXY/Svcuyk8GdGgIW?=
 =?us-ascii?Q?elsCCbHds/S6C7qJuhuA8pDcISOuut1FF852VoZQYk5yjNTpxo0NDv0nBkVy?=
 =?us-ascii?Q?SuT/+XW5ifmCCpPwqtGcM0nmOXRaQixBkmVgYwz6HeDWKlC4ShrdLucsTp5z?=
 =?us-ascii?Q?imUlo1T3mi2p03Ra+hiCFFgOGwzv/TQ/QUoWnVw7jL7Tx/c2yKUvzSIMaXQe?=
 =?us-ascii?Q?JRoA/d8IVB4I+HqTieKmkOsqYewqighnTtY89jQCC/G8QjJf045veCbaOSn1?=
 =?us-ascii?Q?BCO4fmzq/V7Y9m7xymW4V8kGpVA+xgGI7wsApul1rk6M7dQLQwN/pqZpmKZ7?=
 =?us-ascii?Q?caCnFyw0c+O7YTDuBQlXth/OseuO4kcwwF/omMAUSu0S8OJ1lU3LBv5NifrU?=
 =?us-ascii?Q?hHvV3cRcD34ccWM6+d0QjnXwko9Sw1yO2Gwc5iqwnSKgOvvu8ex5QaqB5E6n?=
 =?us-ascii?Q?WxkPBGmQhTPHlahZMHExw9v9W/gTb9Dg/RsAq0jk18hV132wUEjdKcXhXyQV?=
 =?us-ascii?Q?AUAJgrLlOef7B17m55Zz4Ymhai0cNvPAedWkfRskMqATBPFVwVVgoEx2n7BC?=
 =?us-ascii?Q?oJemiC/W7ORJwC9+80MtIjXE+s3SC6ocAWnTJf9xwbCV3POm/PuqtbBeS+S9?=
 =?us-ascii?Q?CSOJp1FifkfnuuqyJEB/CloiPPZzhkp8ZfL9JJW+mi/vc3Fmdml6tk9EmJ6o?=
 =?us-ascii?Q?GSpdYQdVQk3f8kIBHGafiTk9b0klbnyhuRqakm9x41Fd17Dy/I1wWgFLZas/?=
 =?us-ascii?Q?GtODDzY/Wa8QUkC6twa+t9O7izvKEavsfgRY8o0+L7bn3HESIbqO7p/ojmiB?=
 =?us-ascii?Q?zujKJZ9bMqIBZ3Rvm+UJ1fsOO/t6gLj3Lad9irqJQTDteEwQ9vD6nYMjMwix?=
 =?us-ascii?Q?GO6iLPGse+AQJNXFlfsmX5dyHZGS5UlJ0ai83rAfhlagXRiHm/OoQl0hoZID?=
 =?us-ascii?Q?jSLcnJO8fJWD0n34Iv/LrAdkBg7TqHpJzVrbkym3tdfZ4IGhU4TJK+bfFE40?=
 =?us-ascii?Q?4t9r24mTL5HmfWX59Z+Fn47gb9cpZYIM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0soCpkq8n/cixOfmGVZ7Hhm92bPzn14BKlHdtQjYWqWIaflhUTMNJaV+HbKj?=
 =?us-ascii?Q?QwETNhxfxrVoE/i42XelCIRmhNJfiv+3nSOL7d6zTQTAekID/EzSLzeofgVa?=
 =?us-ascii?Q?KenltyKfH6h9Afjxb4/rusx+YfdIV8tNAZfWnpxxQ6JKn+G0ySQXl2HVbsdn?=
 =?us-ascii?Q?hSMim9h26EWbZsAQgPlb7NonA3kR17uNMwribKCYsOZ0PJnBZEOlWmdAtGfg?=
 =?us-ascii?Q?fH/s+3rdJJd6nSu+R/Whh1Kh2gTu6sVCkSLIBQ/OcN07h+vnKPJWkqYiuWba?=
 =?us-ascii?Q?4561lbhiLUkjlDusTZqlnRXOmfp6EJsLrpCsnxLaQ1sCEgkIulHezRVVJ5Le?=
 =?us-ascii?Q?T1Mp64CFk3y4v0bOsq22pqIJI14Lu25cNcIN+DDciKoM8tICVBooUHtjASlU?=
 =?us-ascii?Q?p5AlqLFPxdzXXJMPnooXAHU2pKYQFIXXIQP/oAdbZrM+G8wTsTQ9dEKJj6Yd?=
 =?us-ascii?Q?KjXdhegQp4lcZNt+LEUWT1FlCi9dVCWGPCSJSSG66THTQLhdECgfoO6lZHa7?=
 =?us-ascii?Q?wmMkqIC+SgcBG2JIX1WdgdBYtwPji2bSlCJuBdR30F3m9ayo7GrFNg7OeR05?=
 =?us-ascii?Q?a7ME9k/sdJsEyI9nE5ocmvbyfyma2Hm3TDprg+j0mPhuFsVpHSl86f/ZtZXL?=
 =?us-ascii?Q?o6jGYpAr2I1LNqN8RYL6uVyNWrKXsPe/mV93fU5VdLLpY16Ws+Pmdu8hK02e?=
 =?us-ascii?Q?h5j6TY7KmIkz3lcXj/OGs3fZFpwdl4dErg+EGujZbb2IC+DB+cLdPBpsFYNH?=
 =?us-ascii?Q?dW9MqfKjVc29/98Vb33iZslueWnZHWiLt829cc6ICIzNoPKUh5BRVnQxvXqm?=
 =?us-ascii?Q?XwCSzXqm1zU//xxetNJve/eZSvJcoCI3IeeyGvERXuvwhIGkzaYR2drNRs33?=
 =?us-ascii?Q?SXQ++j90N/V45YwRhPfNxW7K7vEJ461Z/xkZqPXQ29b16YANj9lgzniqp4ks?=
 =?us-ascii?Q?zM49HMADfugga0nJo0moyPHWfc+7TGKjHgNyCqkNRGEht3NXb/i4Tt6R7B1c?=
 =?us-ascii?Q?uEGYN72e8ZHi0p+GkhUP8NMS7/dtfaH+oFauEFIIAWCJQJUVPKSBJMgJUSK8?=
 =?us-ascii?Q?8z7qjLBYTHjsTYs61KlclHsNfTye/twwoWuMfLlf9Elg1UdL+n3G6k4h+IUg?=
 =?us-ascii?Q?LswZkl+frrDZkw1lbI6Wa4mk0YRtGc3aoHkKAI0QkZhCToelGOgNTKMlSisw?=
 =?us-ascii?Q?GYgX5icPriqwktZk8gP33ytmlUvX7Lh2uSyjIQu/P+qOx89ke6gac1b0O/Vn?=
 =?us-ascii?Q?j3W4UK2vQML+FTfWCCXabCmfdM/mSNeqej+bq5JVc8Q8PUorcvQEZ+8UaETM?=
 =?us-ascii?Q?OzzM++rj0pqU3LZpSaaeVdMYzzWEztjHbliCzCaglWammPG3ZfKxX4IKVhPJ?=
 =?us-ascii?Q?p72BMtlPnezSdUMy41T0cLDG+xREE1/X8Ni25Z2mGBD0kdSTB2hqE/pHp0LD?=
 =?us-ascii?Q?7bEtaoGrhyruyh8qlx8jfamGYWwlesbwHDGUhQ8JeCHExuAJ4/lHMdRtc6Yw?=
 =?us-ascii?Q?5UrUYGms8uh6OJNnqy1FCDISVZIcbs+HEGADt+KGmpvKm1PgEU2zoJWjqzCR?=
 =?us-ascii?Q?srtsfRZVPAf8HrQQsuYbK/NvcDtktf8ukqA93EqHiufc3PrQgcqyBuP+cJyi?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s7tkHI+nLr1Q9j673N9EqRhV2bwWHXiNaorYYxciZ6eR24Gy3nI6yYBp5vzO10lsuk3hemPebUCPTpdZGWy3rM2Ca4pqw+ez8GTIP8rsrKC9Xes5z3KQpdnOfwrrhxgLdaNSVDy08FIvydj5zHB5GPAmoyAjArA9b3X1xrpL88qlItFkon70NXdFwHDMFKx9yrN83UpZlQcD25ArsGmaYkS2kMdM4Gs1hMCWujhpODYGWg6JBVym5Kpdv0AmWg6Oje0ylpty0fCTJivHxyTFmuud5L0OMQ1E0glSNuAKQAW9IayzCYW1F3H6WSZ+C4pAOXSNr4iSZlgT/oFapzhOPoVW0fxdl9HlEkwr6KK4grbc+ZZ/CI8KcrHYll6iZKQpOzICMS+j3ncw9TOT4rPIJJx1aEfUzty7U+xtQvrbDcACQUk7uNfR7LXMzzCAlBr2mzjdLBrYR4iucTU9pyU6wDwXUKZ2gL+w38d4pwoYwWFEQNuHGaQ+cf/Cdwe+TCPJhwSFrkuOVv4sxpot72BHtJe1cW/HWtWarMOdRhpge6voWhpVpCw5xCN+mzr7Q+x3lZD6GmRL7TdL+5wSIdF2UWAY6dO5u7QFJhRLLwbX91U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7165ddf0-201b-4ca1-3e45-08de205c2c2a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 13:22:18.3913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGAnObDhjHrqsw2rh91yhjxzNm+w9Va4OgcgLQpfDnCxgPdLrbLxLC19XG0Vv06tmLuFGA/fE5O0RbF62jrrIM60+d+K6VYiemPoJqrpy5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100116
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDEwNSBTYWx0ZWRfXyuT07/GHTYap
 Ef3h032xlVBGOZO9YT83h+Z+gY6JPlcJvMpacilqJP7g0HJEcD0IB3NWKvxWbfMCybRZY/taIsy
 wiVbftJGkrOQ0c0WYfGGaGKZEiWY4WbZtRCdH/xcGOvo90mDnCEA6kZfn3xmstWPndX3+4yG6iL
 GsUsRgr0v18e3DR4YlD6uwGqmzA/9pO1SnV2aRjpXXulbdi1HVBdes/W/6apekGbpgEdWa9sw4I
 WUKTAMP1fN8hqbsQpt9fexmRMteGxabsWKtkANXQu6Y5EyEjjW3SiI3J6tTeuceDhZIClXifeyo
 OK84k8K2VkkQajCjJty+QcNZnfz+nuw4xFKwTJeYZdU4AzQDjF74fDDVa8uAojkWjC+Sov+teTo
 Ezn2crqjJmsGJKN6epT1UvxAwMSE5eEtPB0c3jQgUS3X9+zXFIw=
X-Authority-Analysis: v=2.4 cv=Ye2wJgRf c=1 sm=1 tr=0 ts=6911e710 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=8wza7qE0RQA3soKfRpgA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: Mrn4OxiMeC1T8G0JFz11OCMs1G9vxTwT
X-Proofpoint-GUID: Mrn4OxiMeC1T8G0JFz11OCMs1G9vxTwT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D50801A0003
X-Stat-Signature: i5oxrk1rw8tw1nbcgpqd4ssmjac7gyaz
X-Rspam-User: 
X-HE-Tag: 1762780955-614721
X-HE-Meta: U2FsdGVkX18FEmsNRuCUh4H2QyB+ESRVTgaj1gmd/dz1WJzRMHyAhu0N/cwfGqCgsCEunM5SptlVmelnftCtjvN10YMo5y3HyOEULGUsHlSG6RmrYfGOx4DO8Fonki0g6DXPTs9rRpqrN0RRtDWYgMy+s2vMJz7vKFA9v9DyxsDWW7vFYRS75P4ETgXh4hgYW+M5KPCJ0Bs+i6+lS/KPf5DKrX6rvww7iRaKS8k7WAmZF4zMwFUBLlAoDWMrIVkgVVllVvPWZwpzKyK2DPPc2y6ool2fF8wSaozmislSYzu33HOLkohbNrJbDEUJ2RhY5v2yCIAvVWPke+9NLFCyikz8du6dSXD+3mEBY4o7MCb87BdTQW2kQRJFC+2fjJLZSPsfFht6BRKFNISQz8/ejhYiRoPWhhLs0rHqOj3ahDhPVX+BkTdL1+AuF5ihr4PBmNifjOx/JKIwGMOnvYhbBioWLGwFbRPs9mcaxEWHL9z1y0XbV5RlUkw9S7HHVv6kiFmoz/vmdpKEz0pVmHfeCttbxtDKbGbFEgsW6L3c2Wrz4X+SQaVxaim67rcXiRfMjJw8mayW27luyLwbZAM4U1kFtH6E2YFC6RIpPIYhyxQVvc1u766UfotorsXb1rXqldXlcIOU3E0aEL2t6LsNGXgIA31rHeKytYOYWky9XS1dV8bx/a4rK0eI8mtdUrAsZdT3NevXEvQp48g9G9F7zW/7s8RvKwjpXSqCw/gbr/oRbx6XCMdJiDdr5vTc+cAojWmWE6w4lj8kwtNwCvJ+Se4UnvltBNyBD6fyCIkTv7COqv/SLhcQiUW024GrJgDnMxUIxhqtvxO5mmugrvPCAf1cnmdIRyvYmUASwvc00qaaIga9KI5DGODtexJQTUqrECTEnVXYKUos7xiUNdSmRXSusefhV0b7Mj0eUv+ioH22a/heTFmPUCTj1jiOu42y5z1L/GJbvxCvL+fd3/l
 q5umDbgg
 C2AZvONueUdH3logOCiU0SrTeTBdOib7RznvJg/yrZU+OaSWCNoS+5/V6sYt/4KLI8TGzE24943fMfGE1bBvCIgHYtRzqzxTTfYYyyO1p6lmjqs0uLZki7cKIr4V9je72UmeEGP6JBPCZ2rBOeqshq1REo0RruPi6XWcRM6teOQsuTe2bPUg9R7GMZRP4ZFrVwbUTg7+DGKL1zNSw2bdyavk1blnRoBONr76OCCz1knVolCqua+ysaKSPP4I3yh3T17BI3q10YtqhZQtqjS4Zz0uNk7qXswa2LHtm4YGx22DIjdUvIPprkAMSXnbQkZEOdhQ/x7myc9Qvig5AMoXokayLZJv8OOvDS+DTtx0/pqHcf5vnlGODeBNmWxcW1aIg2BAylp+SS7iZ3ZxRY8A8JwMZR3xhok02JwytEUagTHTLdKXQqO1y83voFHyg7CneRdVLotgs/Zb04S2Fe/w+21eJeB4NVKAGVK/9oEefNWT8GFlU0flvoBqL0y9CRp5i4y6qIwVx/B/vqvqlbUCmQ3+p+twcOpsltgUm7n3v4HjstTNngZs4FOL2VsHgJCojF5fDQIONdhu2ZsQRSZYaUE8scVpQIDDSaRPEoDz+ri6YJByl3EdnBjZKW54AxxEsQCC0SJaXuLqgYEQj/OhfR7fyr5xhpk0iFibLJ1QhwcFI65M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 06:37:58PM +0530, Garg, Shivank wrote:
>
>
> On 11/10/2025 5:31 PM, Lorenzo Stoakes wrote:
> > On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
> >> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>
> >> ---
> >> Applies cleanly on:
> >> 6.18-rc5
> >> mm-stable:e9a6fb0bc
> >
> > Please base on mm-unstable. mm-stable is usually out of date until very close to
> > merge window.
>
> I'm observing issues when testing with kselftest on mm-unstable and mm-new branches that prevent
> proper testing for my patches:
>
> On mm-unstable (without my patches):
>
> # # running ./transhuge-stress -d 20
> # # --------------------------------
> # # TAP version 13
> # # 1..1
> # # transhuge-stress: allocate 220271 transhuge pages, using 440543 MiB virtual memory and 1720 MiB of ram
>
>
> [  367.225667] RIP: 0010:swap_cache_get_folio+0x2d/0xc0
> [  367.230635] Code: 00 00 48 89 f9 49 89 f9 48 89 fe 48 c1 e1 06 49 c1 e9 3a 48 c1 e9 0f 48 c1 e1 05 4a 8b 04 cd c0 2e 5b 99 48 8b 78 60 48 01 cf <48> 8b 47 08 48 85 c0 74 20 48 89 f2 81 e2 ff 01 00 00 48 8d 04 d0
> [  367.249378] RSP: 0000:ffffcde32943fba8 EFLAGS: 00010282
> [  367.254605] RAX: ffff8bd1668fdc00 RBX: 00007ffc15df5000 RCX: 00003fffffffffe0
> [  367.261736] RDX: ffffffff995cb530 RSI: 0003ffffffffffff RDI: ffffcbd1560dffe0
> [  367.268862] RBP: 0003ffffffffffff R08: ffffcde32943fc47 R09: 0000000000000000
> [  367.275994] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  367.283129] R13: 0000000000000000 R14: ffff8bd1668fdc00 R15: 0000000000100cca
> [  367.290260] FS:  00007ff600af5b80(0000) GS:ffff8c4e9ec7e000(0000) knlGS:0000000000000000
> [  367.298344] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  367.304083] CR2: ffffcbd1560dffe8 CR3: 00000001280e9001 CR4: 0000000000770ef0
> [  367.311216] PKRU: 55555554
> [  367.313929] Call Trace:
> [  367.316375]  <TASK>
> [  367.318479]  __read_swap_cache_async+0x8e/0x1b0
> [  367.323014]  swap_vma_readahead+0x23d/0x430
> [  367.327198]  swapin_readahead+0xb0/0xc0
> [  367.331039]  do_swap_page+0x5bc/0x1260
> [  367.334789]  ? rseq_ip_fixup+0x6f/0x190
> [  367.338631]  ? __pfx_default_wake_function+0x10/0x10
> [  367.343596]  __handle_mm_fault+0x49a/0x760
> [  367.347696]  handle_mm_fault+0x188/0x300
> [  367.351620]  do_user_addr_fault+0x15b/0x6c0
> [  367.355807]  exc_page_fault+0x60/0x100
> [  367.359562]  asm_exc_page_fault+0x22/0x30
> [  367.363574] RIP: 0033:0x7ff60091ba99
> [  367.367153] Code: f7 d8 64 89 02 b8 ff ff ff ff eb bd e8 40 c4 01 00 f3 0f 1e fa 80 3d b5 f5 0e 00 00 74 13 31 c0 0f 05 48 3d 00 f0 ff ff 77 4f <c3> 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec 20 48 89 55 e8 48 89 75
> [  367.385897] RSP: 002b:00007ffc15df1118 EFLAGS: 00010203
> [  367.391124] RAX: 0000000000000001 RBX: 000055941fb672a0 RCX: 00007ff60091ba91
> [  367.398256] RDX: 0000000000000001 RSI: 000055941fb813e0 RDI: 0000000000000000
> [  367.405387] RBP: 00007ffc15df21e0 R08: 0000000000000000 R09: 0000000000000007
> [  367.412513] R10: 000055941fb97cb0 R11: 0000000000000246 R12: 000055941fb813e0
> [  367.419646] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [  367.426781]  </TASK>
> [  367.428970] Modules linked in: xfrm_user xfrm_algo xt_addrtype xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables overlay bridge stp llc cfg80211 rfkill binfmt_misc ipmi_ssif amd_atl intel_rapl_msr intel_rapl_common wmi_bmof amd64_edac edac_mce_amd mgag200 rapl drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper acpi_cpufreq i2c_piix4 ptdma k10temp i2c_smbus wmi acpi_power_meter ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler sg dm_multipath drm fuse dm_mod nfnetlink ext4 crc16 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 kvm_amd sd_mod ahci nvme libahci kvm libata nvme_core tg3 ccp megaraid_sas irqbypass
> [  367.497528] CR2: ffffcbd1560dffe8
> [  367.500846] ---[ end trace 0000000000000000 ]---

Yikes, oopsies!

I'll try running tests locally on threadripper, but ran tests against yours
previously and seemed fine, strange. Maybe fixed since but let me try, maybe
because swap is not enabled locally for me?

Likely this actually...

>
>
>
> -----------------
> On mm-new (without my patches):
>
> [  394.144770] get_swap_device: Bad swap offset entry 3ffffffffffff
>
> dmesg | grep "get_swap_device: Bad swap offset entry" | wc -l
> 359
>
>
> Additionally, kexec triggers an oops and crash during swapoff:
>
>
>          Deactivating swap   704.854238] BUG: unable to handle page fault for address: ffffcbe2de8dffe8
> [  704.861524] #PF: supervisor read access in kernel mode
> ;39mswap.img.swa[  704.866666] #PF: error_code(0x0000) - not-present page
> [  704.873253] PGD 0 P4D 0
> p - /swap.im[  704.875790] Oops: Oops: 0000 [#1] SMP NOPTI
> g...
> [  704.881354] CPU: 122 UID: 0 PID: 107680 Comm: swapoff Kdump: loaded Not tainted 6.18.0-rc5+ #11 NONE
> [  704.891283] Hardware name: Dell Inc. PowerEdge R6525/024PW1, BIOS 2.16.2 07/09/2024
> [  704.898930] RIP: 0010:swap_cache_get_folio+0x2d/0xc0
> [  704.903907] Code: 00 00 48 89 f9 49 89 f9 48 89 fe 48 c1 e1 06 49 c1 e9 3a 48 c1 e9 0f 48 c1 e1 05 4a 8b 04 cd c0 2e 7b 95 48 8b 78 60 48 01 cf <48> 8b 47 08 48 85 c0 74 20 48 89 f2 81 e2 ff 01 00 00 48 8d 04 d0
> [  704.922720] RSP: 0018:ffffcf1227b1fc08 EFLAGS: 00010282
> [  704.928035] RAX: ffff8be2cefb3c00 RBX: 0000555c65a5c000 RCX: 00003fffffffffe0
> [  704.928036] RDX: 0003ffffffffffff RSI: 0003ffffffffffff RDI: ffffcbe2de8dffe0
> [  704.928037] RBP: 0000000000000000 R08: ffff8be2de8e0520 R09: 0000000000000000
>          Unmount[  704.928038] R10: 000000000000ffff R11: ffffcf12236f4000 R12: ffff8be2d5b8d968
> [  704.928039] R13: 0003ffffffffffff R14: fffff3eec85eb000 R15: 0000555c65a51000
> [  704.928039] FS:  00007f41fcab3800(0000) GS:ffff8c602b6fe000(0000) knlGS:0000000000000000
> [  704.928040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  704.928041] CR2: ffffcbe2de8dffe8 CR3: 00000074981af004 CR4: 0000000000770ef0
> [  704.928041] PKRU: 55555554
> [  704.928042] Call Trace:
> [  704.928043]  <TASK>
> [  704.928044]  unuse_pte_range+0x10b/0x290
> [  704.928047]  unuse_pud_range.isra.0+0x149/0x190
> [  704.928048]  unuse_vma+0x1a6/0x220
> [  704.928050]  unuse_mm+0x9b/0x110
> [  704.928052]  try_to_unuse+0xc5/0x260
> [  704.928053]  __do_sys_swapoff+0x244/0x670
> ing boo[  705.016662]  do_syscall_64+0x67/0xc50
> [  705.016667]  ? do_user_addr_fault+0x15b/0x6c0
> t.mount - /b[  705.026100]  ? exc_page_fault+0x60/0x100
> [  705.031498]  ? irqentry_exit_to_user_mode+0x20/0xe0
> oot...
> [  705.036377]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  705.042200] RIP: 0033:0x7f41fc9271bb
> [  705.045780] Code: 0f 1e fa 48 83 fe 01 48 8b 15 59 bc 0d 00 19 c0 83 e0 f0 83 c0 26 64 89 02 b8 ff ff ff ff c3 f3 0f 1e fa b8 a8 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d bc 0d 00 f7 d8 64 89 01 48
> [  705.064807] RSP: 002b:00007ffd14b5b6e8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a8
> [  705.064809] RAX: ffffffffffffffda RBX: 00007ffd14b5cf30 RCX: 00007f41fc9271bb
> [  705.064810] RDX: 0000000000000001 RSI: 0000000000000c00 RDI: 000055d48f533a40
> [  705.064810] RBP: 00007ffd14b5b750 R08: 00007f41fca03b20 R09: 0000000000000000
> [  705.064811] R10: 0000000000000001 R11: 0000000000000202 R12: 0000000000000000
> [  705.064811] R13: 0000000000000000 R14: 000055d4584f1479 R15: 000055d4584f2b20
> [  705.064813]  </TASK>
> [  705.064814] Modules linked in: xfrm_user xfrm_algo xt_addrtype xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables overlay bridge stp llc cfg80211 rfkill binfmt_misc ipmi_ssif amd_atl intel_rapl_msr intel_rapl_common wmi_bmof amd64_edac edac_mce_amd rapl mgag200 drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper acpi_cpufreq i2c_piix4 ptdma ipmi_si k10temp i2c_smbus acpi_power_meter wmi acpi_ipmi ipmi_msghandler sg dm_multipath fuse drm dm_mod nfnetlink ext4 crc16 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 sd_mod kvm_amd ahci libahci kvm nvme tg3 libata ccp irqbypass nvme_core megaraid_sas [last unloaded: ipmi_devintf]
> [  705.180420] CR2: ffffcbe2de8dffe8
> [  705.183852] ---[ end trace 0000000000000000 ]---
>
>
> I haven't had cycles to dig into this yet and been swamped with other things.

Fully understand, I'm _very_ familiar with this situation :)

I need more cores... ;)

>
>
> >> +	if (!is_shmem && cc && !cc->is_khugepaged && mapping_can_writeback(mapping)) {
> >> +		range_start = (loff_t)start << PAGE_SHIFT;
> >> +		range_end = ((loff_t)end << PAGE_SHIFT) - 1;
> >> +		if (filemap_write_and_wait_range(mapping, range_start, range_end)) {
> >> +			result = SCAN_FAIL;
> >> +			goto out;
> >> +		}
> >> +	}
> >
> > I feel this is the wrong level of abstraction.
> >
> > We explicitly invoke this oth from khugepaged and madvise(..., MADV_COLLAPSE):
> >
> >
> > khugepaged_scan_mm_slot() / madvise_collapse()
> > -> hpage_collapse_scan_file()
> > -> collapse_file()
> >
> > ofc you are addressing this with the !cc->is_khugepaged, but feels like we'd be
> > better off just doing it in madvise_collapse().
> >
> > I wonder also if doing I/O without getting the mmap lock again and revalidating
> > is wise, as the state of things might have changed significantly.
> >
> > So maybe need a hugepage_vma_revalidate() as well?
>
> Thanks for the feedback. I'll incorporate these comments for v2.

Thanks!

>
> Thanks,
> Shivank
>
>

Cheers, Lorenzo

