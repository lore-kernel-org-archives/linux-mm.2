Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CADEDEBF7
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 23:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E2E6B0088; Tue,  3 Mar 2026 18:54:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31666B0089; Tue,  3 Mar 2026 18:54:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D209A6B008A; Tue,  3 Mar 2026 18:54:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3F1C6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 18:54:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6921A14027F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:54:25 +0000 (UTC)
X-FDA: 84506408490.04.F1C2909
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012066.outbound.protection.outlook.com [52.101.48.66])
	by imf20.hostedemail.com (Postfix) with ESMTP id 820B51C000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:54:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q4Ve2gg+;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.66 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772582062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=av6TNz3h9+F+nLpoUjThEWhhirWL3ChPArkBtRnQKcc=;
	b=L1GsOK6cHAjYOV9FIrx65xFbBqZqO9x5tpESzNsByFuQ2N4f80JJ6z0lBmHeKSezAsibg0
	GJHD61fJithX58Z8rV59y3Gp/7dVCo4h9fEUK/Fc5eKSfunCdlxExm3GAlFaXeqCDfozOS
	0x57og6uZaSQvt+cAsNSR2vMy9k6rIc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q4Ve2gg+;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.66 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772582062; a=rsa-sha256;
	cv=pass;
	b=LBlFBc/KvuLA3keCxmK/IIvm26BmDIZeYN7t36y9JRgUaPzxCt1rft6Et3Th0c4tn0PuGf
	429PwLRWec+FN7rGCrvGxsuJJM0u0/VUG1S1sCNsCj60H8CYXynhJQd9dUKSp553Z51s5v
	HSFe5KowWp7Va6/5LS6l94UVeBVARmM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfYJfRTvLFjtBbebxD/PhgbqF6yqsLlHOxGSO20QvrhGEhXKt9Fv9cGymBoYWw2ZN0h56dezPjbQrgbCCy8E8d9hS5g1whtWCxqqv0CaV/7Mcm8xh0EHseJZ3tQq23ByrhHWm1RKugOCCwN7X36EcdlfjTvuMPss4VO6/LOD++Mx5M8oNG7clw2dYdSLMTRkF8g2WQ/Dmvec8ONx9xaZCSDXwCpTYPz9oQ69Mb6TJLEM5r2fOBr9WZ+M2U84ue6vufXNH51Do8BUrmustVfaXoRwruPmVuOJd8WngY95N9mG7+oQUhcIOa86w1+jT/fcFYsiq+Km5kqzkjSuM2OqjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=av6TNz3h9+F+nLpoUjThEWhhirWL3ChPArkBtRnQKcc=;
 b=GHbgq2myZizRhWEsg7pWRW7+LlgHKCnVQX49o50Xh/Qw63U8zAPKWd6b0yZm0CxXxj30K7f6FmT9gDjCUd2ZrHAloofVgnNWK/cRIUSuGySrvFna+KRN+eZL/IukQt+JsqdJU3opEeChXIbtA76okYllJa6oNhPdJp56NrhJ8aTvUTMqGAZKyCdSnaIA2MV8esQo43kZnKaaFgd3Ui3plWDwqjEPgGvdusikmgpCka+PvdSU6cf94Ttm2LvHIh1N0M9XNRWATRx5qjcvGi/pdIWlqu56emDjswC3q/34o4AChFgtFFDA3XDIPtx2N6rvilArRb64nwn4MCtC+TNgIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=av6TNz3h9+F+nLpoUjThEWhhirWL3ChPArkBtRnQKcc=;
 b=Q4Ve2gg+bfE/IapvNPkghXS3G7B/UpZpUuwQVnrIU2k/ku6VYJZDese/QVDRH48C/txAM5VuTIDEaFpKcm/pXUh1JLh6dSwfXm3/7Kuhs0PEKRLlOu/qN4L7UTPjUKPdf5MB4GmEIITm34VQlxt25JXX/lXBHMFbpL2eKr1of4aGSb3WF7AOrts427YRSL2eWiA7RddI0O3mwc1isOfp+VkpcRJQ6ygiPjBrLJeTqCgU/Dsw9EF7ugpgs1vNN99JdifycD705o0TaEjpyO811H9QTKlf82JulNPEMqzqP8ERQivejnLGBgJyQh5fvREtH0N/8MrIrlLTfwMNRDBjsQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8143.namprd12.prod.outlook.com (2603:10b6:806:333::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 23:54:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 23:54:15 +0000
Date: Tue, 3 Mar 2026 19:54:14 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <helgaas@kernel.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <20260303235414.GJ972761@nvidia.com>
References: <20260129212510.967611-4-dmatlack@google.com>
 <20260225224746.GA3714478@bhelgaas>
 <aZ-Dqi782aafiE_-@google.com>
 <20260226144057.GA5933@nvidia.com>
 <20260227090449.2a23d06d@shazbot.org>
 <20260301192236.GQ5933@nvidia.com>
 <CALzav=eJ63gitLatAerrjEc+o3VXcRor3XwA7_o2PmKYnMwCuA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=eJ63gitLatAerrjEc+o3VXcRor3XwA7_o2PmKYnMwCuA@mail.gmail.com>
X-ClientProxiedBy: MN2PR15CA0065.namprd15.prod.outlook.com
 (2603:10b6:208:237::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: 54738d48-11cd-4eb5-991f-08de79802d33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	okBrQKGgWtJjPI7NIGonl25FbYVhND3sf2luRH2o88CL/GfvVOLDtlzGq/Pt6nChAYvUWWP1/Q3ka3J36G2HbDoshj0NJQkaODNC7JGMHOB0EvKNP1PMcyHI0OewZaU/5BGCB6bWHDqqaMolmLtnS1TcT/ZyfQEtX1k1o8k2E2RoMkFBxt9ijzf+jsPhYNLXPHxajvrUWosGUyoXNvGBk2ADHDWMwOL3Lm5lRjzMWF7ZDw1uNty8S78AOhlpVqBz9j0KOHuIVkyZTluHaPGZp2/LZilBTM2s9LE46fzdU5D+DsqBXhUFTG3Oux20RrFd4vM+sKMm3RpW2/f8xDiyn+qusBKh+hYl1Yyb/oUztpJxVLwlrOp//0H/EBaAKQ3idlDg73J1SyNKCrpEnTo7E3NsQSNe70ASTbdpayY8KsU/7YCh+kj1KHFBPJQQNgM3p2qfs72636Mi4gAeOup2fBOaBsVocy8Qg/I4/u7IWYGCT7gw/9TciwNsfmXo+kYpdAlbmknJ/QAXodmU/DS4paRye0W/tbbCod87elAh7ixd633e7jvpoNdfXwerU54SmZT8IhIJIwsDTO2rKqqiPp+ksbZ4mVcvg5LOgFr3Gce41Pv8LTyBKCRShVFzCdq5gVKF8gefI5cx7b0lNdqF7isVR/Rqm6tAP3rx1I2oIublWbru1yAF9oY/xGS0CTYO3HqQ4v7VTM3/fZl+/YgjjOE+giHSeP8oIm5Rb1XN4XU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mVbVOKVseOfUonbB4QofY6DPsh1TrWr77x81ie2cCethAEgfAwK6U6njKyxD?=
 =?us-ascii?Q?8FaF50yr2ZYDlOH31BkhiW8BO1tTVgshHJzq/l9TawFl6lSYaUL5mr2m2Y3D?=
 =?us-ascii?Q?d6JIrXPBnQpGeXoquJduYzwBrIcHt7KljaWIIV8+OXNKLeD0uNgeExg84inH?=
 =?us-ascii?Q?72cMnxkP5iFvrpAxyZ84yB3CfWSLywISc/f0J6Ck0yQBkoXBHZCZ1izTRIoG?=
 =?us-ascii?Q?5OubA/rD2KTqZBHTRK2+ucc/IX/KsY6TMU1wgMwugYXUh3cR6i6VS0SQgbNW?=
 =?us-ascii?Q?utJYorCJI5SNJX8MNkewbE53JP2Ao+I9wdGCw+oRFPLANJAg4MQbuhfAdMRx?=
 =?us-ascii?Q?HgBBE8HP33BaQr6LjTuaPPo5+tL1tqA77/PG2iC5obofeJ+DcU/TgKKZWjKw?=
 =?us-ascii?Q?LqK1ZwnWqf4Dx1/ngtf8XGXEsEkRYE1C3aNt9gGGG6hOLPNMmZGTXRoHDzM4?=
 =?us-ascii?Q?7AMK8/ZF9qwh/IF564K48CJn5EdorIXJF5MQyWolT9Gl1ZjutTyEocIVfek/?=
 =?us-ascii?Q?yrw6TL+Fvit0RfLA2mv4rGoY8dFPrTfQWixZacTZmPLi4WgkSRswFGlkn3Zk?=
 =?us-ascii?Q?741+/dQqAJ7QIiHtqdg7LIlZiq7RakD3/XYeDmt4Sh1dE9k9i56WXUwAQ1KB?=
 =?us-ascii?Q?zo8O7ItaBUQ+YobiYxtjzBtaOyeDZ4xHBPkIVHseDkpAXzmLgyHPuWCleLhm?=
 =?us-ascii?Q?VSzwBBj8yAt3QO4iZdKIoXxlw5VzewOokoxiLHovZGtGYp791cB1GxaG5VUk?=
 =?us-ascii?Q?sMII3d6zeb02RAejVwqvZjPDTaS9xhxuZKfvoypcOQhoWuFXeNtldXP49vxG?=
 =?us-ascii?Q?vAKKSHq0onzTmg3rwI/KExk57t7NtOH65CQyRNXOgfGLj7au8HuJsYWChzQN?=
 =?us-ascii?Q?6WDDm68lLep0DdLth+jzZMJzo93rzDi80rlUwlzUWcPpHBo+xSB0xK5WiX2i?=
 =?us-ascii?Q?mGFKN4TnL6y6riaFXSDz56jaf9hb5vGGjjy6Q0Rj7EmZ+SSw8kiDAhEYkfJ9?=
 =?us-ascii?Q?dHi4JWtu7jATaOm7sPqq3O+uphgNbX5/Y0EMdx3pD7ZwEe6C7WXcTN88PrO5?=
 =?us-ascii?Q?Edpifwom8XhCdUPhQPYtZL4QB0IV2PRw1qUFfGAMcOkfAtBnVcmccvxONMeN?=
 =?us-ascii?Q?x7xIQruLedDwXexXhc/DtgBdyX8bi1LTqykVZW0zc4cdwPuKa3uE59abf5J6?=
 =?us-ascii?Q?JMkTdCpFrAxnx7yMYa2+OBqC2plV9dd1ft95eN0Ht2qOdtQP8NHEX3YgvT6y?=
 =?us-ascii?Q?Wa0COiOXOkSHD2Ooe09EKDQ2Le7a+1L53PYP7zd0K3ho2EomZ/5/XkUyWm30?=
 =?us-ascii?Q?CuqHIBp+Cy45lqcgf2tKWblbCmp5fn2IGgfsBA9NlpR6Z1bwgq7uQgxPJIyy?=
 =?us-ascii?Q?GC+dEZqlf+6/PL3Bz0Nw2DgnJtAlhloCcgtXrO+jltJUz60yGa5nZgBTssw+?=
 =?us-ascii?Q?xOtzvhXuDpY7mF4G5RCGNIh8cnM0ecl343Oyl60MOwHILiEonO2x2wHEYWKH?=
 =?us-ascii?Q?xy05GQYHPysZhuFMTGnC9t2u7+jAjKN51fWQmMa3jct/ehBcSE4gasTrpmig?=
 =?us-ascii?Q?EkaamjkUHIpKsrM0p9vVOWPf3vpehltD8pwxCaiK13YS29SV9Tdu3+W1QVED?=
 =?us-ascii?Q?w395tRT0eUzi+XYxs+R6TIvcdQDmUBHatZ9eqgLgLS/aGrywXyXMp2tfb5Pt?=
 =?us-ascii?Q?45A32Sy47X2jw2tHdLFTdfG1bvbuWRjy6X/l2H8/ykGZR/SNYEbu31C5frT0?=
 =?us-ascii?Q?NqLHVH2WBQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54738d48-11cd-4eb5-991f-08de79802d33
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 23:54:15.5897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDpav5BvCf/dgpll4PpjhakdpvxfTMBW9PemVOL9DYD6FGqJ0GCm5JdBIaWpXNpf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8143
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 820B51C000A
X-Stat-Signature: adr4sbbcgbqwpukjgswpbfkojoffshbj
X-Rspam-User: 
X-HE-Tag: 1772582062-676565
X-HE-Meta: U2FsdGVkX19tZXTBJ/kCUf141d0PoQue5sf329kMW8mfmsYQ8do+JelSEYVlxK1m+CKX1Pamb2N+UvzmikLjCyr2DM8aBKX5f1o1ZbyCcMsoCtO57D9/y7Rvcz9gqNWPk1cBHje3zLHByXYUeNqqBPqeGh+p4vLz+wxEmBE+Rk78D2uCAGhDjbY36LeqgiCl3Idf/wu7rh393WdruglKf9XLkhULLaMVxLikn3SFRPjtao/VGkCfhHoV/DaLZ8R5B+lwaFKOuLzczqo5aDasup7IBvBeIcG1FGgapCQcRh2a9ZDHrsjVlkmsUb8CSfXawndkeFqoV8zPnv5niZsiK9ReOMZaWQdG6H6/RXj2YojR9pcrTGLWZWkmxp2ZEcFscj1REFt4IkfC+zx5jw1PGhiMz5yc6A2TjbYZ+k9clfivHgTqCswWinHRGlCuXzTdCTirvAJDuuNN2oe+CT5I9aYIjDlkrtDUXTwqesQultfHXD8fTI3xuSe2Yh0buR+4dz6Muj77cvxRaWVZQbTSt0NHVBOby5EaLVRoIWSRgA917RrOhLvZabH4AQaChVp9rGU9qSbBUYSlJWcOCtClAZODi8qr70r/toiYoYAGruQm/QSglesMNj0yd0QuAtT2FPUugLzDdk11YF3vqw+VDC6NtsmhC1Hh+p37NWJ/+ud3G4S0aBEBFE+L9d/CTlzPwhAITbrGisCj30YTR14wYwh2We4gB+gj7AAHrXTW6nstd7gSTis6OZXem8oZLoBnPWorMMntr9wYHBzXOEKlOUvbKYP4kcZtFuad4m5N6+Fmnur3822+kt1r0u0cpIOAGl4osENONfMMPU4VWioiweGBOhqrFK8dMI2yD52eKnclwfV3rjbEHfRTptsGyETxz4gDttS8Kj3sZ12vbcDJAucVN7q4Pk1Jo7UrAh419r81fZK0+h2xh0l+etzcVqSSMn1t+eEJxbzsLaLsyWR
 Jv6ABQZY
 EbpyieAbwto0axssKiozxsgatESTKez10sANfEEodIdQQXn2GjcZovVWAWuxqKI5DaRzhsktT2Q1tPbYakuYZZYhw3r49GedTbni91yHY43Xve20ntUYVmFQ35/u6dcgz4aBMaVd2K6kwsaLr0e+l9XiFLW1OHHeetuLRWKQ1huEaiTNzhb4OKNyceLuM4BrFSchhsaIwv2ikBvr16+VEbBHSd7T59PYNnGPwXDpPyF1jICAcVdPJf+7pATzS2L8snA5WGG3QsLWcpaV3MJnYNCbOY/pPhTsrPHdyxvrG3sMzSo2Pz0kTWlUicinRbJyWMBJMJhcfoVnI1+Hx2uvO9QYZ9+fbOsCl06keFUNEhM91IYEBZEMoYBwYYxG+MUE/Xmlvz+gqzEKmEnIa/dQXPD1PBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:14:29AM -0800, David Matlack wrote:

> I'll look into this but will probably defer it to a future series. We
> need several more pieces in place until we are ready to support
> traffic to/from preserved devices during the Live Update.

Even traffic directed to the IOMMU is sensitive to the ACS flags and
they can't be changed..

Jason

