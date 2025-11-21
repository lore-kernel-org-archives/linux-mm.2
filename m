Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684A3CFA747
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 08:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48EB6B002D; Fri, 21 Nov 2025 03:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF97E6B009F; Fri, 21 Nov 2025 03:20:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0A16B00A0; Fri, 21 Nov 2025 03:20:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4646B002D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:20:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 277C789840
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:20:25 +0000 (UTC)
X-FDA: 84133917210.08.98C5085
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id D8E604000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:20:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FLCYwo8J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fz5yz8jG;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763713221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/D2/XQFjTidRiICToYw5wDrtvsDIHXFxkxctTKh448=;
	b=D0Qegoc9ieiVFPNnOoPuII3l5P7tLFB1Egt0gPMYfugNcLM/RSQICA2G+AHksrR6C8uNYP
	tYoDDKPuCOdPUfSi61czRglkSruu/JQ97XucuWpMDUVwww0iFt2rjS4/9xyHeoTFkux2Ip
	k8TMxFzLoMo1wN7Wvp06nV4xuRDmn+w=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FLCYwo8J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fz5yz8jG;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763713222; a=rsa-sha256;
	cv=pass;
	b=mZjixgqbzjofhyPxVEYa0ZSw68q8Oq6sZJCUMfZ8nybQjol5Aer5PcXy+uLIcSwqKf6f+X
	lZR7sGhBbpnmPCRFYhZNvNCmE+NFo+6a2BzqJ/vK0mLOA+nr/UqUHBx/tu3RkS0BnlPyN7
	MpnKxHGLoprd8wf7e8dgbOcK4zBB7oA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL1uhXW024577;
	Fri, 21 Nov 2025 08:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4/D2/XQFjTidRiICTo
	Yw5wDrtvsDIHXFxkxctTKh448=; b=FLCYwo8J9MZjZWKL/TyNOE+XcpCecZ3U9a
	hyGsOIfai0q6vojsNNP9h1jjkX6txTs7MifqdqmsRS0QvhFxnGcq/dcgVDAMYuL+
	UEC+k96mn028FFldAzY8wYDRgJSgT+Koc6YBefipB4jxBOc4DGT1gjH6lUyobzt5
	NNdcfPW4St+FHUyTfFU/TLcNpQYv1kYtcP1rYT9PwoOlUOLg1K1iEcZqe7WgEQh6
	ab7yGJojkF19WiWE9x5GY1pDs88H2iKMrtNt2EcuNqvgFuZbNMtTqvUtZckipXd4
	XLFVbvZmg9GzSPMS5sslCcIcVsrVo7p5vhQTP8tcAifUISrTsgjA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbjxwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 08:20:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL6Aj1T002499;
	Fri, 21 Nov 2025 08:20:17 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012032.outbound.protection.outlook.com [40.93.195.32])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyd92jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 08:20:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsFr4fUAeqG7QsQf5XDhRPobnZdg1xuA4y2voifaEDsCCs42Pk3Rs8xoAmYmWMwXxSiXv9fG6jn/ygmWTho4nuSW4Y01DSuiuajSen5EJJnX+Jrh7EdDHElExCmEz/5Hik40wDKzHzAIaPv14RvLyy2jhcMo9ZGcxBJC0rjFsvBO/gdvDiiyfJVLfcicfwt+4ff9bKLmIP53IP9yjEWlfg156YBNRnpReEptXwt/6TiT/WXXeb7lFiJ/SMzzbDlMJRmeSRVbnrEWgaokQLw0aut5boOragUeWVL/MsDrIbZeCFn5kpRTIvfXrPJuxQM5LXUmIJluhqkOrQ/nmnoXFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/D2/XQFjTidRiICToYw5wDrtvsDIHXFxkxctTKh448=;
 b=q+i7+OnyG3Q+V2naAK74MXvcxbNfHIvODTQncMi6d4onWJY3Kkql13APbDulB7tDVAKhY+L4YnzyW9qmgnc+3emX+vA4Go/xRRk8xPNn4Gwo1iEn6cupx2QMOwJZVfKvHGlEtTkdZFsgdY6TXqkeA6dpAvji74R/tv+L/NOn1r/YNzMU9Bat1evvRaJksfU7b4CImI0V4ApiMD3uDyGN3D8WG+Luvlnu5G+F7hYClYzKHSEnveQgber3n6RBHvbZnCd16PmArUF7lMclGFak7MMKVO4xKcqKZgcdu5vnj55T4PrTrwSsNs3pYGvBYTkQyk686xuoAr/xy3Unp/Ayzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/D2/XQFjTidRiICToYw5wDrtvsDIHXFxkxctTKh448=;
 b=Fz5yz8jGBOGQ9soehVewcV3Fn7HFiC4tVwNG1mMid9h72X9RLuH+qo8fblakOsPWPwA1PP0Qi09HX8SgPRlH41lnPMo1ltOaz9zuIv0ocYPg8Tk37/WopudZ8On/imG9T8w431Evk96VPlJqOTbpnockwg0C+Pmy1Ch0bC6CXC0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5674.namprd10.prod.outlook.com (2603:10b6:510:126::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 08:20:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 08:20:14 +0000
Date: Fri, 21 Nov 2025 08:20:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] man/man2/mremap.2: fix incorrect reference to VM_MIXEDMAP
Message-ID: <0a072ec0-6d9d-4cd3-82e2-9df55ecb9aa7@lucifer.local>
References: <20251121081609.52462-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121081609.52462-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO0P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 35a3efd2-352f-4c6e-9d59-08de28d6cbd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?huxvEgKtA+KNEDA1PQY8i593GPO+0v/H53krRBnE3SbxPGtNf8/Js5/jjyaJ?=
 =?us-ascii?Q?ioLBsu/2A+vmJ13TjrLicB518Mh59L+kOHBto+/FYX5Fvk5gnvTKbXiYU5Lb?=
 =?us-ascii?Q?tusTvSYbNSantJFPYosPmOAm4KI20gQY2viLPzFkvIZS6ICypHBVe3pQtv6p?=
 =?us-ascii?Q?Zxfl5LgP5ziLXaFkmCtxthZ/GO6N7PjDyweuAzHyBG1EiPzQtw5AMb1ET1zW?=
 =?us-ascii?Q?3tNbv3hqJ+/Q3QdO1hyP2uiJizK18AR56BFiM0MlRI+xNhwtuH66ZvBJ4hxQ?=
 =?us-ascii?Q?3ZRf79OUmShhYC84BxGu7CpeMZC6CoYPh1khb3mgBIXTwQHpyFCSk7Spou/k?=
 =?us-ascii?Q?NsARC2JoJmH57TMJO+4SWNE5brmA4AgC87im3W5UDAv5Y4jHHU2pC+FxRuhL?=
 =?us-ascii?Q?WtNwXieJK25K6ETaWZo65wsEJOYMTBtCPobd03NYCo0HlgI2leNQWO7ZguA/?=
 =?us-ascii?Q?+1YKnzC7YoA1meXPxF/x8TA/4q/6cnEq0ew++eF13phpnxKdwPNT5d0OvkLe?=
 =?us-ascii?Q?SSYVBfXYFt1InzA4t4MKgqxIeUKUCYd2OQG7qhG982uL/DU52N7NQKa6aCuh?=
 =?us-ascii?Q?0bu3TlbTNuV5rxSyiPgf+wFMvkAhaDU2Sr5TCbmh95vrg9JRCZDTRUAqrolj?=
 =?us-ascii?Q?a/YqrPWyhLoRTQE2PYc/PGgP6odW41jgXqW1u462ILshkoJYEgv2WMeqLH67?=
 =?us-ascii?Q?4Ehs+hE2LIXTNidhEaug/4BdVcCBDqK+OxidH5TXc5+sI+IW2TqAAQNaV5m8?=
 =?us-ascii?Q?anSxp5kogWeyhNg6D8hSksZUOldf8KJZ84sZbP6btdr5JcBQzxJhN3rueAsF?=
 =?us-ascii?Q?XFuEy4wB1IzGt1s+encFCHm11VlRy4TlGTW95tcAR9Mf2jvOvTLYVxvq+9OZ?=
 =?us-ascii?Q?L+idhyoa1VAQq2Q7UTDrBDCOAYZy339NackLWL6dYxt66rUgsCAga9Fmv5gH?=
 =?us-ascii?Q?8uk/On5mwbDaGNZJxeBVRU5AvtBkswDn9n/iNoA7I9O3WDQX8mkVmZ5LZgxF?=
 =?us-ascii?Q?DLOeVgQ1vR5/MY/hbFTJd7RuGFG4EOS8dYaIJT9EVLTocs9cyun8BMg/TbiF?=
 =?us-ascii?Q?pgmCU0MYe7+RJAnnlkknM8zTgO2MTEyXJsnvp9WB0OljEaom5DVH8pCDLiCZ?=
 =?us-ascii?Q?D0fHoMOmJnv/uRlWZ+2N899fkIvCaot9HmhyZ147J/rkS+jYUninEu4m7m21?=
 =?us-ascii?Q?VoFNWziOrECpqoOcNvE0vwGMpkBldmCqDqc/zDLRX47nIXovBkufc2+yibcd?=
 =?us-ascii?Q?MJZBRpL56Lei1DkAjIBRewVzWi20hMcDoFd8SGVzmI+KcsSN5EwTmL/lz0OA?=
 =?us-ascii?Q?ZwZDvTrK7A93S8OJYzGzN903FaoMgeptpPX6DYuRlJScxC8VaXIlVNLRT2k5?=
 =?us-ascii?Q?qmpfEVnG3dEhJYbHRiK1vEwv/yH9mxNvLds+RwbWvKvxPnh2rTPVUbXvs2wg?=
 =?us-ascii?Q?jG0MRVYw0dPU681M8cV1+VTsVZLdpgoy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fn526PxD/jlJceRA2qiEQtvxrQtAExzGDb6knuWpDKrYZrho8DwfO/KCeRoI?=
 =?us-ascii?Q?xJUjON4bDdvEdqkg2zEmxa0LQcjMDrUYlSFzTMlQdWN70GkgRg1FOb03MrZD?=
 =?us-ascii?Q?dL4pVX+5sRzRBQEX0O3+sqfcgbUzMxso0Y1QKk+yRoiRfBdjTqbiW9itg27H?=
 =?us-ascii?Q?4I3bt8e0prUyuQhe3g60qYJmo1Z0siJ3p56Jl9amZiqcFueqY04zyCBpM+du?=
 =?us-ascii?Q?Dugr7NPmlbwzKD3hWcHs2vP1sHKP1j2hvfv9iMzE5oQ8b3z40IQbHd3qM7qE?=
 =?us-ascii?Q?lbMDHBbhm/0il7qJUeO2eMltuuGt894nvhJJQZnC+I6Qas4UEEhA/oY16SfH?=
 =?us-ascii?Q?xGECQuRuIOsdSjgJ5EBT72EqSMqUW39D84ug5fwRPZSARW0OF2EJ/3gSSks/?=
 =?us-ascii?Q?AZASCeBGpqOA6BEX+didCIDtSaO+BA0qoYI2V6REDtheJwxuvsfdjfkN4kDH?=
 =?us-ascii?Q?c2tBptbFMMCKRd0yW2dEnQT+krveB5snqrcFAsLW934pA/MS12RsAHRCyY/w?=
 =?us-ascii?Q?GZghVekn8wWC7gC2RFnmt2nBWVaT6gAmjg/hEx1LeeCu5EXnRkrrnW6bsGXu?=
 =?us-ascii?Q?6JZB8UbdBPbGk/LZFrK+5gZhZiCI645ZAUm3U/7pXkPr5UBfoyBbt1611Q7R?=
 =?us-ascii?Q?OPi1NfXtoa4VARJGwSSprVKBJqpor9B4Cyr/6xF6Kzd9X/ubPdRej+F+CSup?=
 =?us-ascii?Q?HqljLQB1w2rQ+0pEuSw3xn7VuEqAw0iEe4X6qhx1dG8XyLq362PXXXGW8laM?=
 =?us-ascii?Q?V6RsDM85a4iHoftaAMIF/afu4HnT+3Z9Du14xJpqpkghBm++UQu7A4VR8JM8?=
 =?us-ascii?Q?rVA6tEiXcJgfY7I3vdp4wZSjvBb1jggmISGvwmDinVl3DZKQ4TtpBMT2ymiz?=
 =?us-ascii?Q?XtyNW9/6xYQTuW4n827/6iyYxrwVBSC/sj/+iOWCNHJr/sTtwec9DMhH7fzr?=
 =?us-ascii?Q?Nhndy8yzIAJeVW8y151DYUdqe6mTIyjdORHpMzBpDBG8u9awT67VMgQJFECC?=
 =?us-ascii?Q?N7201Nnyox9OzzWjl6ONGUXO90bfi5QBCYgYoyR15eAQ0AxVzYwELCCzOu5u?=
 =?us-ascii?Q?k508iaY5Zr+YYmLgqk/WYaT30yuyvT5/mVvm6i5VRhjPHawmVUOrLF/qum3m?=
 =?us-ascii?Q?0d9KTsUEvoNRdZANaMaHRMXvJh3DxemfVROHQCYlMwyVmyDA8p/XIfBkv4H+?=
 =?us-ascii?Q?vj2FyhzZT6MpZEbQafUAPyt7CBltfglN9D57qdehMUsqf7/xovHFSpbCj6pq?=
 =?us-ascii?Q?Uk+nVFomodo5X4jtDKFmcg6vi4v9apUBHhHu0reoxh+eVvnPyhTrUwKQXO+I?=
 =?us-ascii?Q?2rDYJSd//v3YNG4aFlMCR2+IzbZ2ns7gcbC0k5H8rcEq/ZGMkGHqmpb3tQxP?=
 =?us-ascii?Q?TUkuG5gVpwckotCP+eskjLMr53lOgQpVKuCtkLRxZznloiD4FpOx4EtjKERO?=
 =?us-ascii?Q?HqTcN3aorR1esruN6yVUkcEUMnnFEMwAW8p+Job4pzm8UYI2ahwNhZj35J8W?=
 =?us-ascii?Q?Ne/YON5SEBY6l1qlLmtnxDnGuMS1iamHwfx1shzAlSHtDwXHLROboY+WF44T?=
 =?us-ascii?Q?f1NAY5pIYws2zEHjsDQxc+AKgLnUgEkS0yPeqiWvQMSK3FhhecHQMVUU2Q54?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FY4npyA9tnVcBK5UGslTrRHZY6+DThg38YARV/eDwvS0e4j1rxE+h7305fSbyRxTWn/kDpSxJWJpNkscVa42Yi29BoIm39zZQbYdZ/W/wIbn0eniaHley0xE7G/0ojlGPadGwnUwzc3kAV4AKAr6Ot+YSz2b60szldXTPqRdP/O2qKdHJYJHoZ+WPdtpgEmVoFEf5I3W+aYNggNKVBxv8Irc8zdcRQZUvv0NTexu5py0+I+j7iUz18FrrvgOa0o8eyJvQYbXR53WPQ7KKoNyuI6zq2VlXrnzBx1gbQjXFgjm7KZcMqCpEyOxJKp88m0OBRgFavrT9eCIIkZi9u0CW7bVXeluglW/4TqYGItwf/p/yLMykCB5DrHoUOMKe5DhvuRmH1I7C6uHqvbajZJbxjLFFQk6vJwg4621d69HwOGCGwrsZuFVI2JgeiipB38ldvk4l+GI4uoPJirufaCT/cR6+Sb9NxJZMsPabK5EdGb1HqeSgW1Tz6IzZ3XT7MH+8emon+jwBP3AClqUpGECo8M4ibxXRzguxg4ARo9xo9RvsrThqWPCHi8otP1iW7wCECLZ07K5RORK2Jbws//1GAxhFmSh2kRHHH4cIY/Wbg0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a3efd2-352f-4c6e-9d59-08de28d6cbd6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:20:14.1818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qv1sB/biD8a9NYIXR7HoNSeFa4OHISI0WAsoUVyrmHQhSZFMVh0Ewli+WqI8N3kuoEFCVOgC7YuJk/TG3XyyKz0RB7p6WKbN8ChxdaCtvEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5674
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_02,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=932
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511210063
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=692020c2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=v5QfjLzD31iIIDNQR1oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: BdJM7bGNYVJCbYVrbhnnN2JwdQq4NJRH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX/wLXZ60NyqwW
 6J2f8yzgNAL6gmLTxdsZvuivhUEkfmnGExbqzmfBQuIxdIYqpJ7l2d6HiP+Ru6Y30PbOdx8AZrW
 eZA0z0eQX5Ck8BXkb19XCcEv4ArB/Q54ddbrze1FyWNOiG0heSuHpWCBu8v3j7zppTiVNZOpgTv
 3wGs6SQgU8LKIkKNiEOS+65yzrWlGn1aZersF6EC4f+YJZWBdzHBbCiNNEYi4rXrA4RbTlu+p9K
 8z3qXz3CtbyRow9ZxTp4FLkvzoy6awJnxAKOWARw8N8w/ZNA45R0L9iutPzqbiibuwJFr2d58SA
 +k/3lA81yKyDlv60ElvkULDBxeRQ4j0na/mWAyQtga67jp5VxrjCCisv3gQezWfa1Sb9NCeftSy
 kLyuEuWg17H/HA9PTIq2U2I7ftaFZw==
X-Proofpoint-GUID: BdJM7bGNYVJCbYVrbhnnN2JwdQq4NJRH
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8E604000D
X-Stat-Signature: r145mcx8iwtoga6kj6whhos7cqn9yu7w
X-Rspam-User: 
X-HE-Tag: 1763713221-936130
X-HE-Meta: U2FsdGVkX18Vdn5CinM/RqoRxQo/0Win8o24BVb7fI3Ab7FwOMKbcGT3X1Chzfpw3pRtzmXcTtmrmdlnZqDYDNrzHX0NmG3THgIo873fRlaCVNCbRUtyJqkO43iALr/zX9a49BXrQGinHP8f6ljT5EP64Z3kppNSCiSKn4/WFDuIjCFhBNJ7gYHZIPjHKiDVlRyW84kNWsCgf1nxxUGXG2N6z2WRPaApkZ7M4VXxeekaFYQp2Ge4gBLDCfpEYKT5ScKX5v5e8w7hyWuPLRvsk6hwo2vLinMLWi4LopleH1N04/MtIWRNMRjdFvv9iShQH6alIl1UqbJ15/KurVgNz0c92OLvwzfM0FdFUzHEQV7f1OcJ+UoXC9ATOJimh9jpwlQ2yo8gCQ2qNwDysToxiduv5CKlvOESeJTvxDSLG0idw5qwKrwfrHyUNIbMpPZGopef+NZIJBBGZOWe+M7VyhpKat99M+SxXB92uYaQkXr/iQ/kRMiwxQdM9wVsZAcfC/7SSGQp0kPjHJEc6BSUtiIu39CMlMC+oazlo3lrz59I/fMGnsXWQm91rcnTlinhlP9a6c3BZ7POKxfZER8D9YZoSPTSFHFTklpreJ4+Cuk8Hii9qLgn8/o6GA7MWj4YrKGdbl+jifnJ4PT5EZMAcrf0QtnzqF9WdydpynWPCvG66jFFwfTDin/L3OttU8o27e8nh7uamxFBfUZXZI+kd2ZhJ7ldRUY26RpsK12Ms3N2trBsQmvgT54Gp9XZ/B0MR0GFhioW8TXmLiiBj6osoctuRPuIFUE6vY/wsfoZBEC0RVQX7MT/J4PeFvWDDnL3Br2sKS68PnuZ0NkOkFOaPTlxMxbVAhxLhZKQt1WBSrgSX46m2nEuGfwaQ3TNbdghBDcZYh1LQFe9KcSeuA42MdULdL0H3WA3A8UHqQ1TIIlwbroVz6D0q4DaUlrZ4H986ckmZ5HCElKCx7fYe6B
 9ojP1JFR
 sumdRY6eq10OKKV6sbRDi1UQjUPNa9t6QAuWFBL3fF+5w5n9FqkUSk+ezX8EglG4i6MUYfB8BK4+Qzr+uWZJZz7MHWQXU+CsevC05AKuhoPbePg+Vgx/t9DREXBvlUN7yTpOV+vD3cfNoFFUv70ARFuklz+oquZiKHDp3qCQz0bUr4FY255H0MezBzrYuGgKOAij9SSyx9xltUTKph+BlAa0Xo9s2Ra+775IRvAABlFA+zY1bBv2pvQTYMSfqpvVIvLlGEwizPvxqacuBy7Qnk17wgPN+D9ijH+Cp+zEbY2n9WwOyKZ2SfuFRzwC7yVFScllHR8Yo0yiesfnOMWlCNpAY6oFkIDjjBrq6ldvOIbQJIYS9HeD6Hic8+AAqvyfuirxhN5Mnus+/75ngJJ6rfFXtdjxzNBLBUxacTzbSSJcN+KMOjZDF1OHl1S1paBOqw2ITwgJSEDBcLdoij29LTuWc1m89mTHJsR9k3UbteK6ohgAc8nJT4PFVkAYiRkGIm/NYObeieZPwNyolXqz8VnPJCtCdv4kW0jBgq95N2/PH7bNxGphK+g6cp6x1Qq3kTV18xWbXyawRnMkWCiPhheiYqs8dTLxtOueEOGtKXffShYeVbwOo8oC7ZABr43kR3bhDJGI//aVTh6Y60qRHhmp2Zz0BMe/GXfJKDOxiFGQzTppGpHAgFf6zMaYvPTjmQHhr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 08:16:09AM +0000, Lorenzo Stoakes wrote:
> We actually disallow VM_DONTEXPAND and VM_PFNMAP for VM_DONTUNMAP, the
> manpage incorrectly references VM_MIXEDMAP. Correct this.

Of course I ironically typo'd here :)

VM_DONTUNMAP -> MREMAP_DONTUNMAP

:P

>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  man/man2/mremap.2 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 6a6df8601..cbe960f77 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -206,7 +206,7 @@ The
>  flag can be used only with mappings that are not
>  .B VM_DONTEXPAND
>  or
> -.BR VM_MIXEDMAP .
> +.BR VM_PFNMAP .
>  Before Linux 5.13, the
>  .B MREMAP_DONTUNMAP
>  flag could be used only with private anonymous mappings
> --
> 2.51.2
>

Cheers, Lorenzo

