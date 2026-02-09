Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFC7E7E0BC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 18:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CC96B0088; Mon,  9 Feb 2026 13:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA806B0089; Mon,  9 Feb 2026 13:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757866B008A; Mon,  9 Feb 2026 13:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6239E6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:01:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08B0116026B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:01:56 +0000 (UTC)
X-FDA: 84425686632.20.6AA7072
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 00A70A000B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:01:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oxxbyy/V";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nXO+MrGN;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770660112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggR+vEjSGZZ62/DbWBz7NuyRSg8up4Q4uGVAojXQnQQ=;
	b=S0ZZCCyCAGVtuZK0ggTYEHfa1XHHcQrJPsJVG/Xj7EThIMVAzZeV4Dy51shCs3An9/oY7J
	Az05ls23G0c4Y5KWBFwwDxwmSOsag0u31rAGpSLIJl0zGcu2DMmp01yVTodY5T4d5FtXfb
	V+HzIbyKUE2ZNmRL9J2A6GHvW85azXU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oxxbyy/V";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nXO+MrGN;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770660112; a=rsa-sha256;
	cv=pass;
	b=ukO5vcqesBH/qHfR8fY+YZ/epPs89ci9pMLGl7meRSyaf+fS1GWnULAZRzT9ximrsKCdHJ
	vd2Cva68hoTNsM6CAy2lyq5+FkxImHFcV3fvBPJjmdmrZZr4Hz8mviJCwqd1JUq/VWYrH2
	QU9SVYIpPARYUtQzDuSCzfEN08gM4Eo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619ECcLq1822568;
	Mon, 9 Feb 2026 18:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ggR+vEjSGZZ62/DbWB
	z7NuyRSg8up4Q4uGVAojXQnQQ=; b=oxxbyy/Vm0DEjQ8uV0EJr96BjdtGfqgf8T
	taDMNfyV/LLSZIrh1oCP+QF4cbZEj3h11lJ8AkP87atDy8Ax91bIYYekafQmdnSv
	WwYFG/zXPoxKHMU6YDzg4uThMCRGf4uwlFXveFnJwIVosKKEEsaHDWke03GRMTJS
	lfpAtEfVurMedQAho96psnwJ7A/zFJCpepeAgTqmQJc9BRMQlFMHasgfYrV/pD1J
	WKR4s1dfT//CaVq+W+ugv1KMNWhMmlnPExN9PU/qLJzFMNwQe24WbqG2vS+txmxY
	kdjnk/lxp20Zw+nJMpBTGo9hqqRT7Pd9iXcxqCoi5hCSZVopEhKQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xk4teeu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 18:01:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 619HeuHn035326;
	Mon, 9 Feb 2026 18:01:48 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uu9cfc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 18:01:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ur4dnrO09mjrUx1Q89T6Rg4xqOKuNisuUpbkmf49JCBkQfjauYh4SOJ/vjHP62dieAJIgp9MMAe6a+KESTJX1cz6BljSTzGWqXzaVEkRxuo5GZoPQMSdjK3BRmgprNGsBBgbUKuvoGDbGDUoiE/jdJSi2Nr1KrGh3YaC5Ic0nQgv9lC83dXQ9pj+xy0c0lZPRmza6P9ZWx6gohamwijKeq25A8zmvb6qUZGw8uo2VW2THW1t41VCGx+0PiOcqXjQH7xkVAyDZ0cfbWQ5+CRLXbXCcHRtEa8elacfE2Fj+oc9BbqzjB3mp85lBZQ9GlzCRSKuD2f/SUs+IFBj3WLPpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggR+vEjSGZZ62/DbWBz7NuyRSg8up4Q4uGVAojXQnQQ=;
 b=O/WDMuponwDWtXFkeh/c5ssyh8a+bjgeGFEKzC7dhGnlnu+rIgN5onWw4pAFiFSUHBpfZvgq1bjR6x8mZleZpp4mp4DD+rN/dDtt+x/Cmiw8ydA2wlZ47XkFAqxp2vjjFRLPWgOQlZDAwKop68t9vY+JYp7outm+qEs1lCdxPFiUryMik38B+cLmYcBTpmi4vwwbONgZDWivls4te2l3r4UA63YJGHrbnt5fcD3z1geWcW/HpIbN66BxDXBEdje875m3mOv81Zu/4QvbfP1pSRZEHSS5OBNFj68tNzv0KwmhPwHTjyUhcc+qfzI/o1Msa8yJNL+DbOIDZJCSfG7rnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggR+vEjSGZZ62/DbWBz7NuyRSg8up4Q4uGVAojXQnQQ=;
 b=nXO+MrGN7J9hst+f40FIpvphYu6iRQjfBULe+Lesr6hNXwymFY7BnnDJCwtcYOvMjQOyzkfuGy6lzaJH1otWmD7mo6r5vewjw2c3uE/cfUZXKwlOsqCp8GPlTRFUDeCyFHeUmgkmVojn90qxG6MV1ocLMeO58vAQYJa7nnUEnSw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6815.namprd10.prod.outlook.com (2603:10b6:8:109::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 18:01:39 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 18:01:39 +0000
Date: Mon, 9 Feb 2026 18:01:29 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: update mas_next[_range] docs
Message-ID: <qc63muaz2hq5pcew3xecs36zsxeui6qs7govowmmraj2jdbdxs@cra4qe552lfj>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com>
 <tal36hph2g5azjk33h564bllr2n6bz2xhdw4vcvizkhptedfuq@56chjersnkfe>
 <aXCiv9vOrMTbiJtb@google.com>
 <6fgs2mcvwlitkjza5d7cpu3mk34sqqn53vqazkicyge4gtqt7f@5dvqmpubypip>
 <aYNlvQmpL5FVpGNz@google.com>
 <6agwmmfv26g2ljxv2cvd5sbskkjgurnu2mhbsg5ssxkdikxpdp@xehzjz57omb7>
 <aYmZYRyY2emr9I7W@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYmZYRyY2emr9I7W@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0488.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: 01644816-472a-4740-f3f2-08de68054623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4RyVuJH5GGl5Rl+HhrJtUG2Q87Ey7dncY0H41pldFmZtnrM2CiGCOkwei8ih?=
 =?us-ascii?Q?MuPhHhBWqCj6s/zCHav7Xffq1DVO1a88fFczb9Sys8SDJXgTSVQA2Zdp/zLv?=
 =?us-ascii?Q?fPTOrVQDt5+5U4amDyRMpgxeBMqxsQxxL1b5E0l4uiLZrEScyG/RbNlt0lA7?=
 =?us-ascii?Q?Elh6398kKnhBcEoQEDdl31atKYQZko1DHvFOY37Y+4Dt5t+7itDII7w36N9k?=
 =?us-ascii?Q?XJokZoLLsOeht/eB+2gQMERVeW039AI+sMfS863PDv7VqGIrakwKfxlAjQGo?=
 =?us-ascii?Q?nrUM1equ01ieRcA7/I/9OpcL8/dVYhBjZ1M6Nbxcr9cdcKPVA7M0WCenQMdc?=
 =?us-ascii?Q?/XfkirpBwwJ2UeKd4fhvrTUptISE4j5jWq7o07X0sZXJeXzEtKOL0uSee4RO?=
 =?us-ascii?Q?ENJTWuKcdoimf4nT8JrsKI/LxjM69dJ/DdcHTOuY/Dy0O39PvlP54QFg/whH?=
 =?us-ascii?Q?+UMKrb9F3whWDAWUns1IZ2wP2GTBKPyXMDJQ6n7lNvGSxb8m4JiSrIIbtLhT?=
 =?us-ascii?Q?kj8mf8l1jMHOqj6udsA+ZGbYg2v4k9KCt3YxNVBf2nIHLdC0T4VVZ9QyolmW?=
 =?us-ascii?Q?sdNDe3cHGwM/3Akpy0vO9HSNIFXsD++Yt7Vgd3SdUs2fy7PhPKSW/N4pbdAD?=
 =?us-ascii?Q?hcU2IKUem9eqxpHmxx9+zf8a/ThvB8DInXDmU0inB7Qa8vph9+ZCSvf/XOIx?=
 =?us-ascii?Q?fyPUKeVnA3WnbwVAT6zszTZrFgvfmZ+J1zK0GjDrp5Af/xfo5VnLP7OhC6dZ?=
 =?us-ascii?Q?JHh9OoIRIWmiTN/3J+XLvw1/NQBy8k8Te4xw28tjvza54n6KoBHw0Sx55zw0?=
 =?us-ascii?Q?dP2UyenT0RiE0CEUFIEj9tbJ8aYo4vtwPi8/wYEfSSu4oakEigpfthsLmHJe?=
 =?us-ascii?Q?xTT9fGKncsF4PrFt7ShyjzvKFlT0uQCdjjCUJ8sj1tOj33NJ55mrQ4xv/s39?=
 =?us-ascii?Q?KBdslcbOHqcoeaSUrcGzSAjMf/I21WrROHAA901tnlHsxnTstfGQsJBtM8W0?=
 =?us-ascii?Q?/elHZuBqOkFMKsl3lg1fMc3keBiT4Oh+Quxshobi1k9lprtT4B+pHOoEFxB3?=
 =?us-ascii?Q?fCQLaboHC9Zp61JDkxR8AsrodVRM/euXk/pIhdoU518RRExQNsiZeVuI4J6p?=
 =?us-ascii?Q?IGWbLy85ivgNpwUeXtotTiC27mecCqFbmSgR7jq61ni5MbZh+qWwK0Gn5/kF?=
 =?us-ascii?Q?sGm6mAUOBLjQxqOv0KO3ssiL5E41vowgwnjPWzjZyNTpDOe2H4RY3tlohn8z?=
 =?us-ascii?Q?yPnXpXW0pdBvjabnZYSFzkOEbrO4nop5pJpPRm6Tl2FVcY0khpx5/4Z2iYN8?=
 =?us-ascii?Q?ZfmP7xDvBrjT8y8921PdUKT+iIOVUhC531ztr3eE17lnhgr4P8yaenQwkx9a?=
 =?us-ascii?Q?BodDtHrrt04cMHOnVe4e1VQ0umQrjXVJ1+24R1wwcyaq98GMyrDRHd3TtsPF?=
 =?us-ascii?Q?9qtBoVy9MAIpFA//pnyToZETtIUEM/8L18RCelVvNS6aG0Icqym8ivY1GXr2?=
 =?us-ascii?Q?MuH6ZRnPChI4UkhQEzYboy2z4/z7BL4NlZDXxqlcYjJe4h9AY72/3kEjo3Vi?=
 =?us-ascii?Q?fLczSYlw175bfI/c7C0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9CnOdZ8YnE2GR6gbcgSfy+vub4HLeuOjbR3Ro1jPnKJ3GQeGvsgO/nDBicm8?=
 =?us-ascii?Q?X0SSBUpDVq8yvgMbOlZB5tFSTIuIPRiC6JOS+nXaPIHTuOZQdoRGKBxM9UJe?=
 =?us-ascii?Q?IN4Z/aKsRe8PSs2iZ2LJ65awe5WrKheeIcNO4V0rD2kL9RgLvUtLQvYboXyJ?=
 =?us-ascii?Q?KHHYBESPS4iIyCb5lOhfRIjQ5L/3DiVNHig826aPZqxdSy+7Jp8pwZyFIZQR?=
 =?us-ascii?Q?WUb2KYcVJSHYQoUfwN5mJrxd3wvFo+4gBijhozmOEiNPfTSN2lwFKWT94aGI?=
 =?us-ascii?Q?zooATudJgVVbkdDwvQeGYIK7USz6t6jbrDQIzQecPoqQAaNjU4AQvQHMEzSs?=
 =?us-ascii?Q?jmc8VyXN2F5AQjXACnXuNkjUqGNiPmCZaeq6TMJsG8eoRKf/opLHI9QAOE9W?=
 =?us-ascii?Q?Cdird12klsKoVau82KQ9QL4tibUIXO0Kb1bmsBWtxV+fE5XsS2C5Na9Gqy20?=
 =?us-ascii?Q?3JBAYQBqlUmdt/OAvT2s4W5SYxqYqjGSgvnELqJppn0pLzZkQnZcHAGcfQNj?=
 =?us-ascii?Q?J596EDveFMEaMnptRE58lRqQJN6az2BzYePKHZPgNG4XlpA4oklFWAlb9wwH?=
 =?us-ascii?Q?w8C+7kcH73ngmXrdL5knf72zVmS7oy1KHGNOauxZcalsnIb7/8z7YC+c33R8?=
 =?us-ascii?Q?lEAaozTI45BSuQ5LJq8506j+avEVSh6EkP/GCl8GLRxSG5dSwBDK72KWPK10?=
 =?us-ascii?Q?LMaaHMwqlnK6z7n7QTxaynN0B99emtaIYWjQdlBAYMAc4tpYVOlfRJ/15Ij8?=
 =?us-ascii?Q?49z9wJhk0wZtXbHwcFmwQ40czYwjvnOj/ftbFz5c22AUkOlwOcp75J90oyV0?=
 =?us-ascii?Q?Yg9CvShRmQhWmP40amH57v0zNveTHkzdIBWFKPxciWjUn9TdUZX9LTYrV02L?=
 =?us-ascii?Q?idEcTfnf2HZpvqob0XFf1kdba2Si71enFr2nXo9/HXMMdtrN/bHgB9yNrE6X?=
 =?us-ascii?Q?LBX/92qFcDvX3NwD7ckrxu0+T4m3XnAhZ0v8TI3NuH4ooSOQ3K9pBqDW4f8A?=
 =?us-ascii?Q?nM1y12aEEQ48KTOGDYh/GIHWSxULDpcQI8J0a0F2ETHFBMiGU/9/C1JuDaip?=
 =?us-ascii?Q?ls1zavbQrwek5RC/4EkGdAs1lp4FDQzlv6xmljmcFiqvlHQHhvXWgM1mt/xb?=
 =?us-ascii?Q?bN0ZzOmihTCNHBi6GDBPBg8v++zO8EDwRdEuYJ8rISkyHx78XCCoixER9927?=
 =?us-ascii?Q?e1JHjGMJKV+aQ6BJFATi5742n17b7QwdFgUueH0NjyHgdzCsdUod44xGPDuE?=
 =?us-ascii?Q?29lzc2QA8VrSfrj0OrK7MKh6BMHRy9uoN2WdBmkEudh00Y52ixd8j50tMfYK?=
 =?us-ascii?Q?szg5sEpoOddYsnKM9aprq/cyRSQkUAec/qjesS5xgBKxCPSZPn1UmMnQo9Qx?=
 =?us-ascii?Q?NkpIIGs23gbVFUPTaRzp1upRzFEWFmzGAV4bdHQ392+dJjw3eZ4898dLNf4W?=
 =?us-ascii?Q?ALQX3wfah5jvVzKK4SKuxI/wZvp4rVNURS4xXqC3egJrv/PSQpB43w3uvrUE?=
 =?us-ascii?Q?xZcMXsYOd5kNocHrO7t7TQhTQu6qb+SkLLImUg4bL7bzEvTHcXvFwfpXWpzm?=
 =?us-ascii?Q?uOIZVtSWRlf/4AHLHWZwbrfr8KLdDc18rOLwBB4/bW54tDXhLkT1S8hHsWh9?=
 =?us-ascii?Q?ulhp0iSxh8cxm1XxGJ4UwYyuD6u/szpH2g7JvDs76p5skZOEMNqyEHTUPi3R?=
 =?us-ascii?Q?1qSfnVwIjOyPyty7ro5Qkm1Yuqs20RFhdVahYCEllMAWlEJOWpm7Amxs02Pu?=
 =?us-ascii?Q?1RsKipx34g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vlJ2tq5Lo9U0q5xgavh40dBLV027pJu4+9ZuuRZS7LlzXkn5boe2mHmBqDnXobFU48k+nwytvzym5ngBR5vEWffu/McODJIfDbv+HzpdKAP24knFY9wdoTjmjr/5wrCxjB7CgJ6IWAFgAd6X+AoPXfEIYThGbJqdbRgBc2dvErHbn6/d5IYiW9lOyHvNiriTMbY0uMSozl/9kjabVRwQNqPGi5qeug/WZmraUO17fb1E1VAQImRgjm/2BQkq5w2eybiOZzsnpxterExtAMhHE8QwhwjQV16JcQQaxAKMGbV4cOUbeeeGbYcf3oBMN2yyX7Y05iL8CIqS8eD91j+fj9C8kMa7Au4OBfl2OmtH0//NOFIU6DGkwbQ4PRc0PZkjr2FZlGwnbOIt3x5lvNxWIZry/OywpVgbAgOLGPz6VzSIkzV50kJmqs02jmTM2v2aI9MSol7TikBi6yMnWQuijKQdMXQCdhC0SsBDgJAf8Q9I9ytSzId/Axrd7NSj3TmB2ITLkKS1E0cb8/1fXPscUbFFTAk3wduaF6qPRArQm2aNK8bqHR8OHgeH++PvJqSxadAVmyKkMFseJGJ12BcU9hnJgy2DfQKfVR0zj5NDZfY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01644816-472a-4740-f3f2-08de68054623
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 18:01:39.6013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kavLRhdbdxcmaJ+uqIug/vi5bf9MgtYNc/KanGeY8s8V8+eqR398ZypAUpvEPA1xvYlCrUJ3+l/4jEbssIkvZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6815
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602090151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDE1MiBTYWx0ZWRfX0p+tmF1mic32
 g9YWwen4CNtr6N1AVBelLRzM1Lqj59Hcw7c+jXcGpChrN/q7SNQPGWZrPaLnLJwXLaB7SiRXblH
 Msx7yw2y1J5l1/2pXfe44XSHDDghxs6dGCyof0nb+FWF+xPgbaY+PDVI5pF5VqatklBgaeSZkWj
 joGTnDLOlEcI2HY9zybiexlo5cPgqjP4XkA9dzt45LwmRHOM+3In1Ynf9HruydQuemeqOWnbAwJ
 2tw69QuhTUrJpPmNgpt05pfl3IpvYAqa5IxH6Xnhk/+XlYmD21hi38g+K46u/cVkXLcQIIoTgr/
 21E9n2L6V2X4m9WXD4eDipqunp2l/IcPAvfZY0Kyq3G3GqQj3MYUMc6KJ1tXdxfYMGvya+mov0f
 lM3JZSBAY8GODV3JlffKYXOS0D8s8bDgloap7Q5NKgBi2YuqCU8vJR+u5eGpQnHLcmwx17s0ICF
 6GYBGxh2Ei6GUEflF1Q==
X-Proofpoint-GUID: 6jt83qAz-UNpwu5lb7LEJWyPFLhZ-4b7
X-Authority-Analysis: v=2.4 cv=ccnfb3DM c=1 sm=1 tr=0 ts=698a210d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=1XWaLZrsAAAA:8
 a=0CNtm8MpUFG7SRAWq1cA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 6jt83qAz-UNpwu5lb7LEJWyPFLhZ-4b7
X-Stat-Signature: sd4o4ht5ohs7sy5onb3d8ysbnk5145cq
X-Rspamd-Queue-Id: 00A70A000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770660111-365390
X-HE-Meta: U2FsdGVkX1/NzGzB9whkwXdsTYZOG7qo+KcaxU5nkujm6cTR5hjAAzRVndEfb8F/kYEeqQlEVXYFaDCOz7P27YIsqT5+DLtuCL4KNTA5joJ9KOfe59tTlug2BoAb8cm0IFzCf0HOYS7YAV4llA2IXepLGwqHtokkqoy5AmQIAgKraty930UaFdqC0Ntx8v970LRvgRQO7pZnfe0/eUYxJI8nGCgMY7083OmXebVcdYp4aJK3qkw0ze2kkNp+wX0kPPycSZf/mc3OuX6AtofSyK/oiFG1sdAhpmU2tU1LOeUk3aT+yyyRakXg9UTbDJuW2WhUdXTuUb0beHj/7MgkDXuajgS4YHmOQOwVtr0QBfxZVzkgTaO/SzyzNBdfAHTsT2FPwdpjWVmgHpqU5EAI71GHva0SBUNS1Jn+E/GniAwgNnot+jD5XFjyMWH0IXZwpJGJMCRszrEY3a4Hz11nt7P0yvs1iOMZ1cTP2M0hfD9c6kjatnak32rfpFpnI29yxrRdoynPiJZoTftSN1gnRUf4uGdXf50YqPKvZd3k72vC5FZYSU1QDvEQhEKf1eus5mDnYpXP8INq3Bqitq7adclgXey/Qz4PVaGgK7BhOdV6WoROfBbV2RO0jfhvX7BxZEFBp3zab8N9DSRZhU23qdklVJEp0SpX5205Hsk+w/ATGa6I0uxmcGo8DMNRmtwIlSAzOtn/S8g2lZuJhLIg9IhwliK/SjXWrd6QFitCQw6I7IlAbCQqkIxG6dPycqT4+xZMHHKgTjjKDYmhmLszhbtq3B+IFCEge5VhkrrZBLetfRxyFmBP4YHfHFibd2cewj3lD+nZye581K1P7jSRJI/jNy23LBh/GO+FPAySuKivAl6XHjyvzLl6xuItXeLCcENtPxiLH0TnkY2a3u8DmwEIccEOTVXHUdR0J6FYUumeuczB9tZUSyFIowxmXZljvklo5M0O26pi1EwhGhU
 0rwbBHya
 KTflXCsW2DzcKiLqgFC35TrUrg0wCefKrx352Rrd/XpgzfMdF9jKVTSAhfwqvQJneWrdvRDanPi7YyUOdvqJPtfSfNP2rMr1YWzLZ5kGgYcsXENH9a1EjWUPGC6V5b2STWXT/KrIK6247CYf0mwBE0QvCDsrcOx1nt5PJKdyajXKLwofRPgKJ9HIxxeqOaegqXjkzRlV9LzHUhGmaYmieGB5tmc3JJGKUG4IIzhW+XfPRb1yId2sgCpTyPJasXYptJIS6PbsYI1v6XhE29TKSIQ0C8eNuucIvjciUptaCYAQqIlmMoei3Iezn//V6bHF3uf6Fa6k/82vXCjz985WK579sHqwt/y1dwCBs0YxcCqDzGHORdKE5vIAGLMR4vL+FR0piywH3w4vtFquj9UFMmRSrsXBevvTfaneECPwt9krIk2Tyna9GlVr6AGohtWDf3qmXJa/TQDYrE7yj1WkLat5wZOReftXNWP6SJGKWZCnH3PT2cG5QhEasLjNe1vbszX7hd6bPiUNDUB0nhgcFfMX5XWYb4uqNmhEQPBrXUJ5Ok3Ga/EQvoeGMrv5cTu6MgKbyQroMQ+V6XysP5MAFrUuX/m83WHxhRIUXqxDekxFD9nlzuXrJLPIrYYPsbvPWYGFzsCs+4rBxee9laSzfUUYo+GTWfbbKKY8ciulvX+O57bWhLukb3GW31siN/upLm2il
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [260209 08:23]:
> On Sat, Feb 07, 2026 at 08:16:56AM +0000, Liam R. Howlett wrote:
> > * Alice Ryhl <aliceryhl@google.com> [260204 15:29]:
> > > On Mon, Jan 26, 2026 at 03:20:17PM -0500, Liam R. Howlett wrote:
> > > > * Alice Ryhl <aliceryhl@google.com> [260121 04:56]:
> > > > > On Tue, Jan 20, 2026 at 12:54:47PM -0500, Liam R. Howlett wrote:
> > > > > > * Alice Ryhl <aliceryhl@google.com> [260118 06:00]:
> > > > > > > If you read the docs, it sounds like the difference between these
> > > > > > > functions is whether mas->index and mas->last are updated. However, if
> > > > > > > you read the implementation, you will instead find that the difference
> > > > > > > is whether NULL entries are skipped.
> > > > > > 
> > > > > > This is not the intent.
> > > > > > 
> > > > > > mas_ should return special values including the XA_ZERO_ENTRY.
> > > > > > 
> > > > > > mas_next() should get the next non-NULL value.
> > > > > > 
> > > > > > mas_next_range() should advance the maple state to the next range,
> > > > > > regardless of what is in the range (NULL, special, or a regular entry).
> > > > > > 
> > > > > > Both should update the mas->index and mas->last values, if it moves
> > > > > > (ie, no error state is encountered).
> > > > > 
> > > > > I guess I'm a bit confused about the difference between XA_ZERO_ENTRY
> > > > > and returning NULL. Isn't the case where we return NULL when a slot has
> > > > > been reserved but not inserted yet?
> > > > 
> > > > mas_ will return the special entries.
> > > > 
> > > > mtree_ will return NULL on special entries.  I think this is just
> > > > mtree_load().
> > > > 
> > > > If you want to use your own locking and use mas_, then you can filter
> > > > out the special entries yourself.
> > > > 
> > > > If you want to use the normal api, then the special entries are filtered
> > > > for you.
> > > > 
> > > > This way you can mix/match the apis but the noral api still remains
> > > > simple to use - even if there are advanced users that mixed in.
> > > > 
> > > > The idea is that if you're using the advanced interface and storing
> > > > special entries, then you probably want to do something different on
> > > > those entries - at least sometimes.
> > > > 
> > > > > 
> > > > > Like the docs, you use "get" vs "advance" wording here, but I don't
> > > > > think there's any difference behavior-wise? Is one intended?
> > > > 
> > > > On return type, no, there isn't a difference.  The difference is where
> > > > the mas points in the end (mas->offset, mas->index, mas->last).
> > > > 
> > > > If a NULL is encountered bu mas_next(), then we proceed to the next slot
> > > > (which must have a value, if there is a next slot).  So, mas_next() will
> > > > always return the next entry until there is not a next entry - then it
> > > > returns NULL.  Note that mas_next() takes an 'end' value where we'll
> > > > stop advancing slots regardless if there are values.
> > > > 
> > > > If a NULL is encountered by mas_next_range(), then we return the NULL.
> > > > So, in this way, we can move to the next range even if it's NULL.
> > > > 
> > > > I hope this makes the difference more clear?
> > > 
> > > Yes.
> > > 
> > > But I guess the docs should still need to be updated? Right now, both of
> > > them say "Can return the zero entry.", but one of them can't because it
> > > skips them.
> > 
> > Neither of the ones you are updating should skip the zero entry as they
> > are both the advanced interface.
> 
> What do you call the entries that mas_next() skips? You know, the ones
> where it would otherwise return NULL.

mas_next() only skips real NULLs.  If there are special entries, then
they are returned.

mas_next() moves to the next non-null slot.  Special entries are not
considered null by the advanced mas_ interface.

mas_next_range() moves to the next range, regardless of what is there.



