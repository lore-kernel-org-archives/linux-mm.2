Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AAD3D2D108
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039CC6B0092; Tue, 13 Jan 2026 09:07:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DBE6B0093; Tue, 13 Jan 2026 09:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31F56B0095; Tue, 13 Jan 2026 09:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CBBCD6B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:07:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8886186D74
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:07:42 +0000 (UTC)
X-FDA: 84327118764.02.0E4209B
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013040.outbound.protection.outlook.com [52.101.72.40])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0FDF0A0017
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:07:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mobileye.com header.s=selector1 header.b=B2432PzE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of Vladimir.Kondratiev@mobileye.com designates 52.101.72.40 as permitted sender) smtp.mailfrom=Vladimir.Kondratiev@mobileye.com;
	dmarc=pass (policy=quarantine) header.from=mobileye.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768313259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34yk1T24umx3y9i2caPHTk53s8AHsbviH+gy7PvPKDs=;
	b=j6YDcnleaFWNe+nJpJkDK7c0CWiW3L0IWUXpeBCG8820jBaKp0t/OU9LFArVaFHg22Gj70
	iICVLk2uWQXbyoGWV4vClFLi3TxPhTR+YbMtjipRFZv1oHKFo7u5TnRW+QwTjntNO3Mchy
	G6DUww/az6vUxifpwOCoYXiM5rq1IvY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=mobileye.com header.s=selector1 header.b=B2432PzE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of Vladimir.Kondratiev@mobileye.com designates 52.101.72.40 as permitted sender) smtp.mailfrom=Vladimir.Kondratiev@mobileye.com;
	dmarc=pass (policy=quarantine) header.from=mobileye.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768313259; a=rsa-sha256;
	cv=pass;
	b=GGp5m9qmSLvqb517DO5gqxBiLS8/y7sIT4ZsGe4hAGqIcFJLDIny0KJn7D9fbC4MwX1wWm
	u7jqi/wavoy8y4e59uUQOT6Jia8QPhNiEzt2DsvJfHPN6Y7Jr2aQxFKzeOGitH/Ds1fy7A
	+KFJf6e5dT7yUQhFGcmvr8kLVLyhsRY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZkSB6lm6dPb25gCLHviBynVR9Sg/TyR/jRdzRlmQgxiEffF9nRYC0GalAp+lboOibDVtAy4oXk7LpayYQ8FGydczIDY0SvfCx2NPRANtZe2X3nDjN5oIAmXFmX22CcmOX54lPvhzBtlBeJIYnV8yZxp6bS3OOfRKuc5/lsl7xzhTEbe/p1yGHaMINdc6BZMkTmp4JexnXkuJluSd7E1Z4CG+Ex09QgmIElQN0rA43UAz45UxScRjQpKKYh+dtqqWpBj7Jru2Gbt5hsw1wWPbOKj2jW6nKbls2N38NnHgiPBKjJaXNsMwAfXN3V+gVx8xhjdBPdUAIFWB+f1UNASeZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34yk1T24umx3y9i2caPHTk53s8AHsbviH+gy7PvPKDs=;
 b=pOlJF5Ayok9EwINBTNiirkS33XmpTv/+UFExhUASC84O37Kc7nuZwgA+90BTZBNLml1aAOUw/2FlLRKRKfbg2mdQNwtCmdYa3Z1vaMmJLeTle0r1CBXoKamw5eElP5eGSonJRwNIfIcRH0rH3NeVHFW07y7S+qL/SJFk8k8GDJTvVCL+kjfe2wfm0xVQV2p9vP03KdDSJ/dpMQhCUhPCobbOl0QIdogZBcncy5V9H7lHKtv2cCJwlxxQ4Urp40WYvt6/j6sm931vOJektF4fDsp47H6l7g/qOtcPr2j05hbwjz5+998TF2YpwBz3aoF6TC1XLSRSEsjkXZgfbIYa3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mobileye.com; dmarc=pass action=none header.from=mobileye.com;
 dkim=pass header.d=mobileye.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mobileye.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34yk1T24umx3y9i2caPHTk53s8AHsbviH+gy7PvPKDs=;
 b=B2432PzEO4KdlPzgZ4fX/X+nIzs1FnH1QijQScpUuJL/MJvHPUoGNzGYwvl97ZRAd+5m0oL39hPs3jUGkttuCdUTnWD+EiFvzQLwo+eiXBmdXv5Sa0MXN3j0XvHVOETMlO6T0C8Cr9u91FnX8A9WoycaimyibzgxUHADUeW8OPw=
Received: from DU0PR09MB6298.eurprd09.prod.outlook.com (2603:10a6:10:415::12)
 by AM0PR09MB3892.eurprd09.prod.outlook.com (2603:10a6:208:199::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 14:07:34 +0000
Received: from DU0PR09MB6298.eurprd09.prod.outlook.com
 ([fe80::73ec:d77a:a02b:d98d]) by DU0PR09MB6298.eurprd09.prod.outlook.com
 ([fe80::73ec:d77a:a02b:d98d%7]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 14:07:29 +0000
From: Vladimir Kondratiev <Vladimir.Kondratiev@mobileye.com>
To: Robin Murphy <robin.murphy@arm.com>, "m.szyprowski@samsung.com"
	<m.szyprowski@samsung.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"david@kernel.org" <david@kernel.org>
CC: "bhe@redhat.com" <bhe@redhat.com>, "iommu@lists.linux-foundation.org"
	<iommu@lists.linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "s-adivi@ti.com" <s-adivi@ti.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "ziy@nvidia.com" <ziy@nvidia.com>
Subject: Re: [PATCH 0/3] dma-mapping: Improve atomic pool behaviour
Thread-Topic: [PATCH 0/3] dma-mapping: Improve atomic pool behaviour
Thread-Index: AQHcg9quJEyBld1VoESnF3P/c1VY3rVQIK5B
Date: Tue, 13 Jan 2026 14:07:29 +0000
Message-ID:
 <DU0PR09MB62984EFCC64DB724F3BC8CD8948EA@DU0PR09MB6298.eurprd09.prod.outlook.com>
References: <cover.1768230104.git.robin.murphy@arm.com>
In-Reply-To: <cover.1768230104.git.robin.murphy@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR09MB6298:EE_|AM0PR09MB3892:EE_
x-ms-office365-filtering-correlation-id: f2cf9838-a5b0-48db-c7fa-08de52ad16d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ULR7jRoQqI621uWd3o02ZJKRYUrAvgevpnqqTu3DfN+9uixySWqwrj7NYy?=
 =?iso-8859-1?Q?YDR5lGMFjxE5BOBDYfWjXCrhMqrXtJhV0+6fyWzYrc1eX1BmPP25upt2sx?=
 =?iso-8859-1?Q?QYiG5EnXZtKU7xNNYdRdG0c3CnGtFVJ5IsgmB8jC+QC4wQgsrZ/EO1Cc1p?=
 =?iso-8859-1?Q?ZZIy7aoFc4NFZDkTP72ByQTfDI1mjSHKJNo+qAA50VQfBZEFp81Qbn+Jx+?=
 =?iso-8859-1?Q?p4xSd1qqlveIDYR4yZ47aBlLe4jUSQzmHf9FGFa78HJbbiMNgXSG7IgnDZ?=
 =?iso-8859-1?Q?G1ak6AWhxsCL5iJ5uT6BHx9Yo3qB4DT0Ey9f3s4BsAHfcNd981K50nGPrZ?=
 =?iso-8859-1?Q?z6U/4m9HztoUQiA36BNX/4SroHqdftgJmKitjJIQQCbf84h6zZ2Gey6TB2?=
 =?iso-8859-1?Q?MjIsRqQ7NxOxUmLUj6P6VnqpePIifxZLUTmuiiTb8I07ccIU+xlN0Dl0/F?=
 =?iso-8859-1?Q?KX6GZz3FxjLsrHcxI6z7vDo8X7v2ZGLFQJbdH0ccUpvHyssM06sKg6q590?=
 =?iso-8859-1?Q?ce5rOCokpOfl3GVLrB15W12rXOV2i7ZC+BiRl3cnjWLvkgExv4S5h83j9/?=
 =?iso-8859-1?Q?QTTYjRyAmckORdXK4l724ohqfMI/yr6Xy7rZUdYHHnM7m4dGwtlzEsRpCK?=
 =?iso-8859-1?Q?b0k1wcSiitlzJCopN4R+ynCBOWj6BQpakFansi81U78RUYcL25bPHTMqsh?=
 =?iso-8859-1?Q?Ke3Eper5UaoeM3tC08D5mCb9hVwVT5AKt16ROESUjAZGevqeAhp8sZKxi9?=
 =?iso-8859-1?Q?l2ZAmwJpKPjVOaFEt42sL1R1YQ0naEV1CwywQyXjqKD6i+PtLZOfZe10T8?=
 =?iso-8859-1?Q?5uBoLoizg9gDk81QnPCpZDv2F/EXL3XuF5N8VMKI06/YdfruZiuTSEtXAZ?=
 =?iso-8859-1?Q?JUxVhkmG0u94UlnVNPmyGdAOOV0aHPxk5CD1/b8X4QJZ7tEErlJn0bvOW9?=
 =?iso-8859-1?Q?A9Blvnu6y8sEUKcNAILgfPsueW9w13b/8MxhFfgaA1QiHp9APzmhWp8ruR?=
 =?iso-8859-1?Q?4TVVtwroxSiMTJiybJTwq9yhu+RPoVqNKw8MAgjn5xY4RF/HhefzB/IR9I?=
 =?iso-8859-1?Q?Y9d9GK9hGJuUqF+6gJc5M+hsW9pYQfWIOPYmRHs+w4sxQrezjBlH9N5ui9?=
 =?iso-8859-1?Q?dSKWojnhNlW0cPsnjAOJnKMlJJDYR9tFcOd+L/XrkXAy27zNaXfn+/hyPA?=
 =?iso-8859-1?Q?hKUOItjTLUOLXw59dl0Glps8QRZ+CiX4J9Nwi1rbyDJasXhAR6O4P608ne?=
 =?iso-8859-1?Q?YnpQSD5d9os+i6GK3whtm5alhmiZVJFzAsLjKjiZkYgNmz75wykzeb6sRH?=
 =?iso-8859-1?Q?z+gDuamgTwBP6JBejUcBIjvPoqF/uKXR/GO6Zp5nYhPd3s1pdCUr+U3l7c?=
 =?iso-8859-1?Q?sW7m5+7FCEg2wkoknlQ8+lf8bEESwJQXezq29ZMQBOBPqtsS9bgbl9nrA2?=
 =?iso-8859-1?Q?MngBpnlUt+e04oCufJBaPt3l2YSaFcFweTMgAdkideeyXtijEXc8/7dOj7?=
 =?iso-8859-1?Q?N6w6NdhYh/T93OX1751OtsNKshhU9QiHDAQ2nZ3lxHse9tmcfCSw4lmu44?=
 =?iso-8859-1?Q?KeI++ypQOjpfgDFeaSsLr//MToYL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR09MB6298.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+SpiGAUPPaF/ykCPXFxG8/GwEuU5+OtAJw1+Nl4UnF1FbEEmcnRNcQy5My?=
 =?iso-8859-1?Q?PmBiPnbE4OEeND6tbvvJxVDirFEABY5Z/4xVdT3O49FtjEP4ru/jGK/pl/?=
 =?iso-8859-1?Q?J4stKQ/q7sq6PWOaokZqOKPVvK2jbx3wkTy0iupknpFLuLvvAT9HBL+tCT?=
 =?iso-8859-1?Q?vF46ojTXxQY7axB6/ZUnDeeXQog/mpox7He4sTAH2G52fv+Lc86zrJ7cn9?=
 =?iso-8859-1?Q?5aICcdkat9yULEgTbIMcSNKLVE4zjNcGXtGNPr2Vioa1NvZpcZTKqdBXo0?=
 =?iso-8859-1?Q?U1KidTmxjWsCxmTzixVMNrEsU/eimcm8J8/JJt1OLdR+P6qW5/YWA0q19L?=
 =?iso-8859-1?Q?rfYAUHnmuFlHZOPzbXxTCmDeHrbGM7747wrsX//tNaqiz4Hz869MH3Po9j?=
 =?iso-8859-1?Q?behx4LjDdHPpAEi53OutV7erjm+v83sLDOUlNvzMs7j+8J8Nu6/FB5Auqe?=
 =?iso-8859-1?Q?Z1e98h5f8AyfkvnR+NU4LBdOu7BmnwlkJh7EGUHL6wbZwVap84LvpnOclu?=
 =?iso-8859-1?Q?/7NYpX29hACNzCZU2Tp3ppumVs7p0l9YYK9v0Jfs/ckvdYT1jUuoUZ/wc7?=
 =?iso-8859-1?Q?hKTT1OyoYQxcIRtV70iAXRb/BP2Iy7VgPlQQX2VvB5GLCak5wWc9I5u7D9?=
 =?iso-8859-1?Q?N8skqeUNbS1oJXBxtMfldQ1Ert7OCfslzyEkNvYxIGE6j0gRSjgVLgexrn?=
 =?iso-8859-1?Q?xC4h/Hi3hOH/1disFR2t9MkN7v5xKTOdmnoTFWm+6YSgTIViDYljzKNxHs?=
 =?iso-8859-1?Q?P5yYA5SH7A51TgF5uD9AMqWvZd1TSQeFnT9nQNXYg1EkY2B+dkvRrW9UgK?=
 =?iso-8859-1?Q?CBlA+soRmGG9B8UzXmkAcjgEUlVtGEQUQLDt0cSnTCNDg7phN0Sg4p/gAy?=
 =?iso-8859-1?Q?Se7sxAQCbHt8M+fiJiyqkIXwHGOt3EBV5Lga/OXuhw0IDCCyU6e2RMorc+?=
 =?iso-8859-1?Q?gJuzUFlO2UIukivhGY5WNa0ViEHHSJkojrmbJ5gy6/ErrtTtoDyzJa8tup?=
 =?iso-8859-1?Q?yAcV1ajM81wI/ApoCzCk34aI7DqlAJsDX5QOua8+Ts18bMojQ61PswIUZP?=
 =?iso-8859-1?Q?Igs8l9imP7d9ZcZU/J/FDkdCbx3V4gbZCBxuEvGrsxFA/hgZMPvkkS7zPJ?=
 =?iso-8859-1?Q?KvNgUZbTkffJHay9g47ayFBsoaBJpSVdtVyHro4Ll3A55exJ4DAPR3hYrH?=
 =?iso-8859-1?Q?gP2bOCuulhBW8CIPSHWwjPfgKltF3r+wnxFW3smE3M5CupnDCxYWEDjAoO?=
 =?iso-8859-1?Q?4FEjZadWyDPh3h7Ui+QnLFiqI67uA4WcBCTyxpmntAWL5+aSSUQy64+qMD?=
 =?iso-8859-1?Q?FUWF+of54WdRSNTuX4HF0rioLvPE7v9ykbldYlxFGcar5826iuZVBQKi6w?=
 =?iso-8859-1?Q?tvSoYD6M8EQolaxS2G0G4FmOX+LYFWdSRtTETKzAubHE9H0PPwsyQqHIU/?=
 =?iso-8859-1?Q?pCHGqtgE191lfAYSpkwdrYOxG6i2EytoOE4syr2CwpcgkWtD79fQkzj8AI?=
 =?iso-8859-1?Q?DQaC/mVuQRkel4Z59qotemFbZEcO7eYoW8JIVuEFfyJFx0qN7AAnwkrm+0?=
 =?iso-8859-1?Q?lGMZqYoJrzz0uoS5YM4IPN49StVuEY44yH3e38vt0vvGWkouUgB2iEMw20?=
 =?iso-8859-1?Q?ZvbHujaKonCWiRP1xNx7uOOeW0Yf/vcqP4T7vi5udy/rxaksSbNoQbodrC?=
 =?iso-8859-1?Q?xU3byzOtgnngZ24oiFNTx0x54sbbCCnXtbw71dnfW4fHHPsgVRvQ6DCl/h?=
 =?iso-8859-1?Q?34QQi6T+SfDXrn1b0YvWSfLyBbzzJaW003kax0CcZYT2yi?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mobileye.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR09MB6298.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cf9838-a5b0-48db-c7fa-08de52ad16d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 14:07:29.9163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4f85ba13-6953-46a6-9c5b-7599fd80e9aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EOvY2rtgELF+3zOCq5x3HmUcLXv9AeiV9/B7CLfinBxPLOPFgab/ibnKUd7X7S5fOEU/kHw3qmUpTBcIT/ypJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR09MB3892
X-Rspam-User: 
X-Stat-Signature: o1nn7c5srdcfn53emioqy5mgtmyojo3b
X-Rspamd-Queue-Id: 0FDF0A0017
X-Rspamd-Server: rspam04
X-HE-Tag: 1768313257-220022
X-HE-Meta: U2FsdGVkX19Qma9Ic37VL5VLLc7mkLEQWJjZVl0LUfsLOgnDLqU22q7WR/lgwfHc7Ak02gRnf24fFQvS8wZiCYSl1Yt1x47lJ0h4DZEMRfX4BNxiq2e/pLCGwrogAjJGsbxVFlik8QZEQeEYGf0L7CxNLt4a3I8FClrIM79feizYSOAX/u/uProMRQHAkbHijUf9+lSaSBMitAka88/VOsB3dHVy6mcaXLvD5yINUIRqeBETXX7EeVIYP3g1xhMZ4oTpyPrKFqIsnR+K/kSBwQpDxH1chFaAnB6YHR5QilQy4SRQa7uzLrkz9m5d6IeXXOceYohDfJoXIJC14rg22ujeuX1sloQ+AbMjP6ZoD1lcsXKHpKSL8vMifk+oVvDFgq4IzVwrYQhIbSQoWJptmTljXyOTptdWT3koQYmtZ+F3K//wywqims9RBr6K6vMlzjgIbobZijORZSTQmwG1JOLGgnHy+KyO4ytgB/nDx8PMMtxoIv34Kmxo2bODVN9D15aBplxd2WrWFNZl1IneeYa9cTnYGZsqdA7/oJO5rh+ECpTOTG6zv9rqyZlkSzGxzadNZfOpQVFM7AAPlNP5XxcIMt1lW4QraRj6/BwsBsfqHMdS2t3W7oHamAJQgkfTPHJfJM3Tepy7OlOGhi5XHwifD1k3stPfZVpwVNZnF6tlroAjPCqkucMN2lk0HZH9d4bk1boRJeUcAbElyCuUI7v07DJysc575OPHGDFbgMwUl/vCLheO1A/DZ+GsJw/8SN/gIgCvW/zllleV4XCsR+WExuQb/unPsSOHMH3X9d7R7KSx4xy7xIODxYohff0EHs/oebjojf164wr6GsNxwYsr1KBuvY4I0Z+XNMc/v7Tno25cHkePqgXKlMyLe1Zth7Mz73DDz1jscXwsaONMdm31gMvaRzR/euzbupub/S762ZwFFJYasBn13mbyoMbFbOkE99WIE0x1S505JpI
 lxW5+nuB
 cInIm/Gjmt13Fwf3LpNUtfUqXolZ14XF6bY2l95qGpkvYFPwjQFDbz02IL6/WQ6IjI47uiAY9s6c0JR53mgpKnXWKSUXabvJJVd7PDbP2iOk66IITmu7F48LSG4/wf0mqWvKF1mibsDOdGwzoLKUWLm5BwKvU45TjU+EoKjiR8I7PjSd0K4IuQDbOsWRfBjKoLR6UzdjgE9/oz7/kl57IMw+QN7gED2bmPYEfi8bdKBNXeFBU1xplOa7p2UQQRHL6hwjl8cz0amFj6NoxYAQQAt0OOD+SkYJIVwzE7h1/YoE5XLQxWI4UBx6/7AbW2WqdHqOd2KZyKF/Vk1+9KjcVHDPqswpWS7cbqNnarvXRGAQNc+KPJ0alvo12HBKtKNu8+4RkvHICozlC3DQs9thk28tgwG2OZsRm68+2T0lAafdgV+apYxjjc0bd/RDjnNgTXQV4lY8ZeUr4bElFHwZOktArJSOey+XcJmyeG4272DS8WeZV+I7UwbDMgkBx3fI+xHwMWlIM2couTXw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi all,=0A=
> =0A=
> These days we have somewhat of a matrix of mm zones that may or may not=
=0A=
> exist and may or may not be empty, which the per-zone atomic pool logic=
=0A=
> doesn't actually handle all that well. It's not all that difficult to=0A=
> improve robustness and reduce redundancy, so that's what this series=0A=
> aims for.=0A=
> =0A=
> I initially wrote this just because I happened to be looking through the=
=0A=
> boot log of one of my boards and had one of those out-of-the-blue=0A=
> realisations of "hang on, why *is* it allocating pools for zones it=0A=
> doesn't even have memory in?", but coincidentally, it seems that others=
=0A=
> happened to notice related aspects around the same time[1][2]. This is=0A=
> my attempt to sort it all out properly.=0A=
> =0A=
> I guess this could go via either the dma-mapping or mm tree, whichever=0A=
> maintainers prefer.=0A=
> =0A=
> Thanks,=0A=
> Robin.=0A=
> =0A=
> =0A=
> [1] Suspicious Link - Removed=0A=
> [2] Suspicious Link - Removed=0A=
> =0A=
> Robin Murphy (3):=0A=
> =A0 dma/pool: Improve pool lookup=0A=
> =A0 mm_zone: Generalise has_managed_dma()=0A=
> =A0 dma/pool: Avoid allocating redundant pools=0A=
> =0A=
> =A0include/linux/mmzone.h |=A0 9 +++++----=0A=
> =A0kernel/dma/pool.c=A0=A0=A0=A0=A0 | 27 ++++++++++++++++++---------=0A=
> =A0mm/page_alloc.c=A0=A0=A0=A0=A0=A0=A0 |=A0 8 ++------=0A=
> =A03 files changed, 25 insertions(+), 19 deletions(-)=0A=
> =0A=
> --=0A=
> 2.34.1=0A=
=0A=
Tested-by: Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>=0A=
=0A=
Tested on platform: upcoming Mobileye eyeq7h - risc-v platform with memory=
=0A=
mapped to 32Gbytes so DMA32 zone is empty=

