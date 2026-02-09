Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92450E7E0BC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 16:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044606B0005; Mon,  9 Feb 2026 11:38:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C116B0088; Mon,  9 Feb 2026 11:38:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36216B0089; Mon,  9 Feb 2026 11:38:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D42906B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:38:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CE8CB7044
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:38:07 +0000 (UTC)
X-FDA: 84425475414.10.493ABA9
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010025.outbound.protection.outlook.com [52.101.85.25])
	by imf20.hostedemail.com (Postfix) with ESMTP id A6DB71C0004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:38:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CFofisGJ;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770655084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=434DhTdzT++Eie+0gUw++ljgde60fXPzXJocafLeUu0=;
	b=UOL8RQUjVddN6+WdsgP5GOMeJrp0a/SX1D8CVABmVTJlMnpTS7DO6wQ/k4leWDnxyuYyx0
	K1yuFBuUW80lrCOziFSf26VkYJ4CVmly6RcVg3nfUtIADswyPxON7jqE10DGFmz2FUQAZl
	dKKI+zpTF+yll3faYYmuunK0ayZY3/c=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CFofisGJ;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770655084; a=rsa-sha256;
	cv=pass;
	b=u+gIwC8/5v3GGEnnHlKZbM9Wcqmry8fp0cR0+CmD0mTkylDOtwNlqnESwta0YSqlI0F7p0
	Tulv1xQhFLt7ftAaop+8Spug4MjzQ2AULF1b8CM4u5QGjRs5l0Zk/0+R/m2alFl3a3Bbs1
	YNGf6M5wfGA2k/unG75/S3sYQNBFSTA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFg75mkLqXCTpi1xC7C+bx6pLUws70xCbZ6CF3RxMqXx6reC5hgyewGofV1znHQo9kbHuHdaLWKdUAPD/HreYsOhigt71NDaTb0rMPevcWaB1oVthzZL5SaRUIwMLeJpTlUmOw6SB2h/gpLcFOqNGhAncaykVlZ9b70pWIOWRJmCb5sqlSD6s8SBjCLmtGiILsoeiYiYOPT/jTI10Chm+s3c2+PMWARClgrql/TFyN2TGLMS4HUWzWobro/DEoKaGFyHyRfifn1E5IVZ0ISxLHDchwRkNR7/qiXppy04YFkS1LRt3OrOb2iXWIrp8AbDxO2QLPeMl26goxJkOmKYsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=434DhTdzT++Eie+0gUw++ljgde60fXPzXJocafLeUu0=;
 b=bRdyNOjH9Ymh/xqqmxT2HsjIzuEIiBVHoxce61FnSouMb4c83Pm4n3rw4VWBHFYhRoTSFTDPPoznyuHqZK/mM70oEJAJN48fMThd1rssMmT2+CWSfUhwciMocnoxMCg/rG+IodGXlXWgodURzozfdjAsHBHuAG8jJgtC8oDDxGOgCxtY+9HcxpY48tJTi12hMtxqW1VKsBijbKTfYO24G6y6edWxsTKmU1o7CtWqqhn1aFz8LX7V9Rman3a+iyTucCVbY2qZFu9yNgjbseSbs7BndDy6/zAiBle7CaQns0BMzkncnVaYWKoAiiaQNzckxwobJQniT+449s507uiwEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=434DhTdzT++Eie+0gUw++ljgde60fXPzXJocafLeUu0=;
 b=CFofisGJtAQtOMS+4+sDU0uuUoBPobBv4Uvvqroj4Mi6fFK2upv2K63hGVNqkcQi319J6N3CY2HcaM47ke8Q1DW3q8a1Khw1SeFsGiqd3+PStKvtaRIeWHJH7RUujh3S8yiBaHBFjqhYIPpLKIe0X/CSsBiCTV2BLJjuCp22Pifcjebx2M+vW0mMG7AJ8Evep1Qc9YxORSDvsYq4KApDJud042OxF9s6IzcLypkliiO3cwgi0mjj/KIf23WX6z+f/b/LP0JuZWXOUGKt4vKLX1Kf+1jMU9fS0ifXmXcaHF+QE9SYzWwznINw+xSJITvU51akRrC2JLTyK3j6eSHfkQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA5PPFF3CB57EDE.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8eb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Mon, 9 Feb
 2026 16:38:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 16:38:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH V2] mm/page_alloc: skip debug_check_no_{obj,locks}_freed
 with FPI_TRYLOCK
Date: Mon, 09 Feb 2026 11:37:56 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E2F7802B-F549-495F-BDBC-358A233D0939@nvidia.com>
In-Reply-To: <20260209062639.16577-1-harry.yoo@oracle.com>
References: <20260209062639.16577-1-harry.yoo@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA5PPFF3CB57EDE:EE_
X-MS-Office365-Filtering-Correlation-Id: 35054c42-3f6c-400d-e285-08de67f99659
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RSEHM7f5DVa0U2J9hNHIwPc9EY89JMvSLGigvgIIvV2exR8xqGT1MkI5Gii3?=
 =?us-ascii?Q?GbmVWMvBuW7c4f4hiSRqDz95b3I28MQrHP5kVUMU+jx+Y92+TMK8d+Juh3/D?=
 =?us-ascii?Q?d4m69/cGPmobPgtj5FwqbqHmyQym8WhkbVQzHH1AnsPXgCtlRhnBSAXWX+Ds?=
 =?us-ascii?Q?u5w833rh/Jt1FKGVjPc7URk/06J5B/FA0P8J1PSbd9SJGMXb2mRtdzcB6kp7?=
 =?us-ascii?Q?YXVS8PzSwzLyeRpuq/Q8176Hw0yOpp2yFaYDrF8hmamPEyHB/HuipSoMpQ3r?=
 =?us-ascii?Q?X8AE0cU8TTQRpPIEF1PIt7jeDCpLKKhfQVNzAdMDvic01vazfmwOLSPwvLYR?=
 =?us-ascii?Q?tnkyT18mrM0VTjS9QvYIBwmW1DpvBKJqJihrLFSStVGzRESuIyguS9sRMwa+?=
 =?us-ascii?Q?x7bY989rtXGp0Mk5HdlDhLiiwBAE58wRLlZm1WQLbbEHYGlWVR2DvkywtTon?=
 =?us-ascii?Q?YwBBrdnleJSppYzDHmN8aUwTBaPb/ItnMtgC6gRr2ANVg7w9rWFLr3/Mmb0R?=
 =?us-ascii?Q?yWU9GXIIior8DcHelToMCOH9hgYwIqnRgd0uYJzXkc05frzdh62+jq2OHVXp?=
 =?us-ascii?Q?hoddD4PjJ+7chCbIoVbKygCsl1/19NLJZKT4T+n/2irKosE3brbJd7rxDTxx?=
 =?us-ascii?Q?ecg1AlBDTtKd/dbyTpCrOf3tCnj3d9klcACUTVmQgiutzhuo3ma+3clEQS9v?=
 =?us-ascii?Q?yhpzXmew/6P4aHwKPwoVlA8L8x7kfiu3XAUta4g+MxGa9d6zum8noYzWCfBe?=
 =?us-ascii?Q?WRtxItZh0dEihsy64ng8162rqE3WbVyqmxJa3H1TIjVicjsnl1jDbopFIVjk?=
 =?us-ascii?Q?uF9MfC/i3ATjfnIOeMr/UucoKfUN0ziaQ+4q2QoL1kmkLjTk/9PLSqZwUDkO?=
 =?us-ascii?Q?sTDGEehrdkHrXvr70TNFdjepBY5g0HcYvS40EHGKkhA8HAg+R2V1FnE7dfgK?=
 =?us-ascii?Q?h0YuTlAsRKSbmn+IvTeE3DtzQvM1K6+kRjg2IM9vSqSUQ9zhZPA2I+EXDmKY?=
 =?us-ascii?Q?XRUIA4P/AuESCrjro7XtqjiBoptexMQXfeCibde5fmfH78BlPCjNGSOwsImL?=
 =?us-ascii?Q?hjFpIi/qSfS6h4KmJ4gVAUjsLjbrOpmvsx+dKTtnswpgGjHKY85vVNZK2k47?=
 =?us-ascii?Q?tX/3Qs9Fh79Y9xCxVfG7f/2JqjpnmlnHHFRL8OOTvHy4eKfS5Kte6knJlMln?=
 =?us-ascii?Q?CNsemavOZGlTq4k/83T+SAEmo0o11FKeMGPHzxn+xB3MwMRpP86XMpC5SMyT?=
 =?us-ascii?Q?+jAbRg78CsKlxZdJJB5Yu6HIbguz2hBwu14JqvtPqHJh+xjhhuekpk9lZOMp?=
 =?us-ascii?Q?qM2qhc3Zl9IkK5cCVgNEdMy5YHs2y8L+ddzCtUeClXeEscdqq4Zqxc0j5hrn?=
 =?us-ascii?Q?fCQessfjo2kn1AGmjXY5WdzwTlNty8Q6EUTi8oD82h8ZAXqeNgbVrkYd9D4Q?=
 =?us-ascii?Q?MIsQ4CawmJwsHmCE/74Ta/t0i0uqNrEML7iz7RnXRCKWGQg1EaBOzv1ucMpo?=
 =?us-ascii?Q?Mc6bzQTiAKfXmpTpP+nus5mkzKQ7mOJzgDicmzZ/oPPppU97FVojtKzEzoaA?=
 =?us-ascii?Q?3kkup0svd4cuD333Ivo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dx+2uJkE2HJjA/d1Lgl/IQzjgmCs+Y9BD7WIHPA/L5KTlXXgM6XdMiP0KVMO?=
 =?us-ascii?Q?epoqRRskzMyvULj0TfPyq1x53MPlDf5s81X4/Ir6A4ajuj3KZE6fzSyyRQz0?=
 =?us-ascii?Q?kIeHEOB3BIdene9mBErjzJo3MfrW3C2cRPOUlZzYSKOG01B3ELD7M0E3Ghtl?=
 =?us-ascii?Q?j5kGYYMXVmRXDnyvIzigg+5n7P3tZn0N0rBYuwqnD4WgLBO2IUYSqBnN7Mr/?=
 =?us-ascii?Q?Q1qVONzAQo43poVq+pLO59zB2DBB2y1b5awjGycR81E4EeK8BWMo0CAGg3C5?=
 =?us-ascii?Q?w6m50/xmS9vwoKYDf5nXy131E4ZXvy9b10BJMCcrUqhYmLRWv8Wg2Z9tTcET?=
 =?us-ascii?Q?70gYv9m5Tp3VVIhAZVKbXycdtm1n6CZvLkjLAYjoOhlzBM+s/++/HJ/ELjYm?=
 =?us-ascii?Q?WIBQ+LvxFOtSKe4pB55n2Du55htAyw33krjUQkEFuFtbJk6r2H7Y/mgWGOXA?=
 =?us-ascii?Q?kcbyKCDp/qu3lVoKjqt0jN1DpfZEj5PX1FNiED9eSB/YnO8Qci0L5FWaPs8A?=
 =?us-ascii?Q?5qym5M7OJfxCUT1zwJFeB3cLf/ir5VMM8Zk1ldwb6WNJqCVdxPj2XIb11Ncm?=
 =?us-ascii?Q?7shLov7L+89Q8DnA/+b2rMM+9Xv2s0D86JNt5Ql29VJLSJ/LHoIQaukkeGku?=
 =?us-ascii?Q?IQOiA4Wn84I11x5DOrt+QsynDCv5sXMtPXT/7pE1+umANg5zYMmfD/CwblBr?=
 =?us-ascii?Q?30SgEyzz7FfK93i2TDqLcAn5qtLBrwNq5yEWJO7eBt6ZHkijoMt2xKiDt3VC?=
 =?us-ascii?Q?AdO1wl2vkfjs1+Z1DeCfVRSPW2fHiztZmxLI7v6x40RzP0bZKoNHJ1sJhrCR?=
 =?us-ascii?Q?dkuHG5w6nqAp4cFpa0Z9t8h0wtfAbzS9ainJI/v9DRlFlHBz6/0TUsWreX+X?=
 =?us-ascii?Q?9kjI+41WUSXvzlwwDMfFdmvwLVAXYk5iy1hkYmST4bwrA5WaaPbrwvbiTbfo?=
 =?us-ascii?Q?ll/v7kj3m7uZaGN+H1edzp4/iCIIuxKKyEMVw9fkQA2rBnfwwbgpmPu6R2TF?=
 =?us-ascii?Q?oRzNS825L2IE4z24q0+mM3SlOFXCyj/lOL4Dqgl3oaT4Ya7UowOtJLVSxtnc?=
 =?us-ascii?Q?NevBNf09eOuksY1BbUwILy2J3G8KthsUXS5vOd4MHtkT7gb3FFpqeCOkro72?=
 =?us-ascii?Q?KUNg7pOTVY1yMUt5WKmv1xU93xS/lOD+dlenEUmEObpro6gOuPfRoCNZB1t+?=
 =?us-ascii?Q?CZnDHJINf8qhIAjVM+ND2SjjjJ3ok5lNq4AjcEY/L4NswxNOf83lNlJ+dw6a?=
 =?us-ascii?Q?lHbAluOuK8F6kFe9FN/YT1IjYZ5x5UBKkgBEXcvP47CRjbPKHwUVtAUIPq89?=
 =?us-ascii?Q?rR9wxZEXcKrs4HB8oGxXcd0Sg0teNYdVRBlJ5WNj+d2pveTj7CoZQe6voiR5?=
 =?us-ascii?Q?acIFpxaWzu8a/omr6BzFOK9d0hDx0+OKgz84zqlPGyz8eViLrw86gl5nAZsX?=
 =?us-ascii?Q?eYbOGS0/cdrNsNBPjDxI0ILrBMRoYAKO5tv/h5OE4COPI5fu526BGk1Qif3K?=
 =?us-ascii?Q?z7XfE0fQ3gdR/fz8agUJlGfN41A8rIFAzx0EBpU4ctSnZSCwUm0koB3+WlzL?=
 =?us-ascii?Q?HkBrVJPlvKgLFjQfRetT22c2JOr7XGtkrYcZlxi9aG8EVCvH3NH/MWu0pV6w?=
 =?us-ascii?Q?EZZSpHjIcXwwph3Lx4uGfkoxBm3c1IRoL6ek7jUnndzSYMuE4m1I6cJTw8Ff?=
 =?us-ascii?Q?HyNfjUWqZQddDfWVVmwdMT09uOmjrBvA/gUSRDig5mB1kBPN2GSoVrdYho1h?=
 =?us-ascii?Q?gxKoydQouQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35054c42-3f6c-400d-e285-08de67f99659
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 16:38:00.1460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLW9nSNjUjeDi79hyf7qVt4INjRHXoTYYyhGudDxhoPdf4iCL6vNASa6MDHaktzD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFF3CB57EDE
X-Rspam-User: 
X-Rspamd-Queue-Id: A6DB71C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: u5hmuiaw6dpsrmiao8wr69j5dgfpsi6h
X-HE-Tag: 1770655084-254312
X-HE-Meta: U2FsdGVkX18i6GU6Cqy2oNok8rJEJiQ/kwoQkk73yoNZ0Pvl8DANcSxcFAJqxK9dwv0k1tKM+YldVTna6X9eH6EoyhDD63Rb3yyXQlhD7jBvueecqpO+GZ17wM0WT6osB2F5KAyjO93PY/41IX1+NTC/k6oUezIkN4ofwQVKGdze27NYSq71qXh+E/bbCBxzjc77sy1mtEEftiaMytcNLE+lKjapRtF2oD6t2E1G+JThhnupXlpEUSgp5OOPzqhzyB7vAjYmKCvMbfqHvYBRrSoa4bwlU5lDVS7MylxYLDw1O9qFWp9VgpxrZtYaJVm5GVR+5Kp4MUt4sD5hSINQL0rmEg2Q7uDDFHIhU4kquFQRqRtj7lSZlXqxtl6ITGbY3SseLlxPcx+dmtTb5p2eDOzpXqeRXMStNX3cL+avOpwqH4CaOf3X8kvoFX2nQ9j4cWSUVRVUb4D+gmmITWNqAAprQawJq+ak+7g9a2NQ0Fhk7n2e/LUb2ucFLRthIZu0fUGJh9cDTvnIfpdz/6ZhYsKPy54dcM6a2cqOPL9Fdu1A2E0oY7hlO6yz6yts1FN1UBgHtbQ6OTAeqA9uVFOncOTIy6EajM3q1Zsg0gcC9fcPTtMPEmDyXLrAcjT2TPTHTfDE3C1nzmScIkN79UQBxB+US4ej37FqcgXvFd1hEKHEpa4E7fOdhi9prQh4/3y8BvLGCSpZKKDxOr/KMbA3YKe8cNPIUGqhI0FzQZN8gCOKr141r2GMIhfZlGUC6qGcTH56mRsVVAF9qqfEzFgibEbDNhfdrrRv0wKlH16uZPGPL9Nl28JZv3Gy00SLE2zBT9NhqS7WnflFlRIXgFr+UsDsVOqbSFLZdMbMAthLh13N+8wDDQw+RpSE0prpNEYz8nvlJaHTuZTBV2OtwoN0N3FGDYFPBAB0Cgvf5pG5RgTD+q2PB83mifbGmqw8pS7vZtbZLo1QO7rVxwlEZVk
 l8eY5I5N
 qFMYA87fdpj/lXVyydFmDr7msahYbnvxlawBiMa4JrkLN/uGpffj4wNEX9jx5SV9sMWIPRwi6OvV41iiC2fSDw65Zv6ROqx9AB4UdvCiIIWzdBpXmlgjwfgb1Q66JrelseLkcuYVNlhTG8lwnritVBGUVK1tGP3cLXzdt4UL/W7aXu+rL8H33w88+K4xGsqeArXtHa7CKfy2ZwNIYNt3RrgV4ASZQjCtbi+8asSy7TR6FRpBvkrzot2muLasK9saSUzHJ5FJDbMDysD6dHJlbkdn8rynhmXXdxtn5eh8oRCXgwyV3r6xLR13eTrN7JVj0P2rq/SEU9ii0+qUhxZDUIvFK7dn6iWI85+4B5Qb3V8V5zqPthtXxdZzynAKAxQ6auu/m9MSUoiN+c2JmCjgjLJ5wSbX3EPlAF99+b6u7cdijhW6EAH2EQlLFLtIxXDZakwi6W8Zt+EZUIMcgCd+BFdL2yC4G8hPJ4cDe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Feb 2026, at 1:26, Harry Yoo wrote:

> When CONFIG_DEBUG_OBJECTS_FREE is enabled,
> debug_check_no_{obj,locks}_freed() functions are called.
>
> Since both of them spin on a lock, they are not safe to be called
> if the FPI_TRYLOCK flag is specified. This leads to a lockdep splat:
>
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   WARNING: inconsistent lock state
>   6.19.0-rc5-slab-for-next+ #326 Tainted: G                 N
>   --------------------------------
>   inconsistent {INITIAL USE} -> {IN-NMI} usage.
>   kunit_try_catch/9046 [HC2[2]:SC0[0]:HE0:SE1] takes:
>   ffffffff84ed6bf8 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_check_n=
o_obj_freed+0xe0/0x300
>   {INITIAL USE} state was registered at:
>     lock_acquire+0xd9/0x2f0
>     _raw_spin_lock_irqsave+0x4c/0x80
>     __debug_object_init+0x9d/0x1f0
>     debug_object_init+0x34/0x50
>     __init_work+0x28/0x40
>     init_cgroup_housekeeping+0x151/0x210
>     init_cgroup_root+0x3d/0x140
>     cgroup_init_early+0x30/0x240
>     start_kernel+0x3e/0xcd0
>     x86_64_start_reservations+0x18/0x30
>     x86_64_start_kernel+0xf3/0x140
>     common_startup_64+0x13e/0x148
>   irq event stamp: 2998
>   hardirqs last  enabled at (2997): [<ffffffff8298b77a>] exc_nmi+0x11a/=
0x240
>   hardirqs last disabled at (2998): [<ffffffff8298b991>] sysvec_irq_wor=
k+0x11/0x110
>   softirqs last  enabled at (1416): [<ffffffff813c1f72>] __irq_exit_rcu=
+0x132/0x1c0
>   softirqs last disabled at (1303): [<ffffffff813c1f72>] __irq_exit_rcu=
+0x132/0x1c0
>
>   other info that might help us debug this:
>    Possible unsafe locking scenario:
>
>          CPU0
>          ----
>     lock(&obj_hash[i].lock);
>     <Interrupt>
>       lock(&obj_hash[i].lock);
>
>    *** DEADLOCK ***
>
> Rename free_pages_prepare() to __free_pages_prepare(), add an fpi_t
> parameter, and skip those checks if FPI_TRYLOCK is set. To keep the
> fpi_t definition in mm/page_alloc.c, add a wrapper function
> free_pages_prepare() that always passes FPI_NONE and use it in
> mm/compaction.c.
>
> Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>
> V1 -> v2:
>
>   Per Vlastimil's suggestion, rename free_pages_prepare() to
>   __free_pages_prepare() instead of moving the fpi_t definition to
>   mm/internal.h. __free_pages_prepare() takes fpi_t as parameter,
>   free_pages_prepare() always passes FPI_NONE to __free_pages_prepare()=
=2E
>
>  mm/page_alloc.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>

Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

