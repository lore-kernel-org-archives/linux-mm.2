Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F1BC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 14:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 697376B009F; Wed,  6 Aug 2025 10:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F4A6B00A1; Wed,  6 Aug 2025 10:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E586B00A2; Wed,  6 Aug 2025 10:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 459F86B009F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:16:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA57EBA9FE
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:16:34 +0000 (UTC)
X-FDA: 83746533108.17.61E8045
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8C55D40003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:16:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hmhZoQNH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t2do0pZ4;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754489791; a=rsa-sha256;
	cv=pass;
	b=3uSIQvtWWBe5w0ZPBJpP+byxdHz75KGOo0F+UOS+kQXIhkIuGSh+7mi4sHjVdQRj7bAfBy
	Zt0IaT+EqUoZldB5e1N1wheFv3aTnM6EHrAw5eSTVnGaDxQLmj0rVTXPrSmKyODP4VQ0Wg
	lxOuVoZGvAmXZ3nYXSXTmZ4l0c8h21I=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hmhZoQNH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t2do0pZ4;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754489791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4m0iR0gB1mmygjr6yj1zweb0dkhKiDl3D2+h/KjlYZg=;
	b=L9THe1l5e6DkgI2ofK9LPNwEuRW+B/8aCIvXrB74s1eNw2uxVy6bLKdjGAfEq50GmMGeSI
	uA28oRFYM2DGcOl29+YzfSFvMF2PYTrFSFJ7Cw8MGowUYB3uDahiYy7VuUPd8bYmCRPXvc
	y17jVzewxsuDkVgZwSgWp/eJh4UXZnQ=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576CRQhK006868;
	Wed, 6 Aug 2025 14:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4m0iR0gB1mmygjr6yj
	1zweb0dkhKiDl3D2+h/KjlYZg=; b=hmhZoQNHXJ6D7k2RxTHdbD1x+Trd5WbgSJ
	MrWLQvsgyk2jn1ga6hdIfRGOf5dLh5LI4Gh8cOQfNuPHuQfaDDLZmhznJpRgATtP
	xLbT0RfG6KIz+erpm/j8+/g4FiKpzVJE+ApjQTHv3FEsTaHUJb3zopaPK+6+dbIK
	Bba606kFwaAtrZ8FMfos/Kw5Z/40UjCJ7aixGoDCK+TXSOcS20QYzUuXOSDCYUBb
	xiIDQnMFAiWFDYF4qof2Qnc3N8Rml7B/yzxbf0KXrQt5tNvSU+ERkSBtOxFQrfC6
	sG/EAV7m3IeCTv3Ul09abV7ZiVUq6J6zejUOHRLxcD4L5u/gUjqg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpxy1vsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 14:16:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576E69bq027144;
	Wed, 6 Aug 2025 14:16:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwn34vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 14:16:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6u0qzL2Ar70pMGbvJfoh75XA/ye8cqlGNC/7GYieocEODomN76dDHWSdJua6LIvHH3bAB4GsMug8Cow3GmB3zRqYju9bMrJeue5O1ZFA8/9SN3tB8M+Y0YSTwyM1dot2kWoQsjDNR4u40Tiu/wFOGTs4+VMbOsLAyV0/H0d15oIJoBtyOPz17vBJEi8V5FhnHSECrxGNqkqNo8Ie1XCrP4VmFnBsO0SQnR+ujY6CPmlWiU1TmBZIkrAgwJvamfwfvQYwjm4yeEVBxCplHftIDfVIhnQT3/EKeeuVL3P8DgqBmxEbB6cZ62cO0ja6zQnWMSQdXJ5nRXfOWzSl5Da/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4m0iR0gB1mmygjr6yj1zweb0dkhKiDl3D2+h/KjlYZg=;
 b=leKmI0O1/Vq7eA59ofk1+iCLDBChcGATJPeB49UB1XioMa8TPcsXrSKgKei3kUzu/oysi7OCrIC7gC497xyP2yRgnEGmJulmXQDynuLXhIRc2umId9wQhce9XIGZQ4dgUiwRKH0OWkzXg81VG/sWc8cjOPmvmrxk9SvwdO+HZCtHaBOY8s5tu2ek+8RWtV/oWeL4F8e1rmGTA73EAgM/DVkuU6hzc58fKypyNOj4Mk3QPW/X3gMnKHt1vFjHdLYe/JVhlC6SM9768vh/OqlAjOcLCVgssIsM5oCxV40EqFMVVc+o+5JPNYje90cUmeiqDudGug8RBR2WcGTuoDKGGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4m0iR0gB1mmygjr6yj1zweb0dkhKiDl3D2+h/KjlYZg=;
 b=t2do0pZ4LGLYL1p2vAJTeATRLR2EKsQ0yMbmlb4ojTBn/m2sd/fp2aTlm7fb4f2FBbI+b/NNJw2M1mOhIaegZTgOKj2kDPb8rE5XRwt6cbUznCGrqwc9N5X37Ec3dLF7JKN+iqIgLcmfajSnwEKqYKN/P3avLY/5dXTdSXvNsUU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6674.namprd10.prod.outlook.com (2603:10b6:510:20c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 6 Aug
 2025 14:16:19 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 14:16:17 +0000
Date: Wed, 6 Aug 2025 10:16:13 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        willy@infradead.org
Subject: Re: [PATCH] maple_tree: Remove redundant __GFP_NOWARN
Message-ID: <ovpvaeadvegfuhzl7a3ttnmwok7qwn5rs5o3ohwww3byfqdbkm@jky5zrvvj7lb>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Qianfeng Rong <rongqianfeng@vivo.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	willy@infradead.org
References: <20250804125657.482109-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804125657.482109-1-rongqianfeng@vivo.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4P222CA0021.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: f770c55e-8fcd-4ea3-0754-08ddd4f3cebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ETjmbs0BXivSDLRFUsocvT6Z0/1uyZYa+sqRn5ZGzAVPxKj0kqPU7ABa/kx/?=
 =?us-ascii?Q?kU/j/ws7gk9M9JCRTCOFzN1Q3wiVOrq4+r1K5ZOyJDjYu70D+PEnMBE1tRgQ?=
 =?us-ascii?Q?wmCZkfblFrd9HqyHoOQeawTgrtZ/nppFZEA5sEj4tfRXwHSYZ4ROOcgsWIb1?=
 =?us-ascii?Q?4E/txZpxZyzlR5pRJZCnm9bjeT47Vmoh7QS3KT9dQM+4FLtgcg4NpvYhKsMY?=
 =?us-ascii?Q?nWuw+O/zVsb548eWLaA5YioANQKAjk5uSTLoI6OYHtg+9HjTkn5JRFUnfLNL?=
 =?us-ascii?Q?qZTCGASZj88lRoU9zotFawXidTigbwsvjTAIoW9X0mjuFz01EY8WziBDeXzV?=
 =?us-ascii?Q?v9IxEs7mxVWHIOP1DWIYUnI5VwRgBX6YfDY00HWnNXLPHxTkbQVhw0S/QbvM?=
 =?us-ascii?Q?f6R/w7ivnPCex292z+I7uS7YD/VCXbzwb43qwhD8f6utgSLjC+QTu/9GCLZE?=
 =?us-ascii?Q?8LXaQOVXwmHqiqdR0RIXlHBiDRvue5W3eK6beflc/PlDzY7kdC7RkXdMcupC?=
 =?us-ascii?Q?EkB+uWrbnrbunMXwKL7sL0kgHEFFTgloTqt67Ja6f6vZRGTixEsXqpRSlnqT?=
 =?us-ascii?Q?XhAHNJzjb4aCrtt98uoV9dCucHJRUYSlHnj012M9pXZpVskYvHERUctUbj4G?=
 =?us-ascii?Q?pLyjLuVh8P+3abvRrlAYFUeOMm1MtJOG3NQNgj+CrZ2fivo9uZk6MrI7hl6g?=
 =?us-ascii?Q?haEAa2WH8vcIiSq/4dYX+BE86BbxnhylQ5pWdIDxJ4hgcqggFLsB5wqM5leV?=
 =?us-ascii?Q?4Uw4djxfaBqYFzRAHYPHLSZ284qei5jrxdZaCJKjfGvRUR2Kup5cTLyf48aa?=
 =?us-ascii?Q?ug+CqdWlAyDRU9U/S700tbd2PCarppS49ktXYUmMXe/wpNgVjHt8ICELOWP1?=
 =?us-ascii?Q?BfZe3ecHc0HLdTgIJCpUyQzly1RhCxnvf2J3XYAB72wolYypE2fDf9trLnDD?=
 =?us-ascii?Q?yXZaWqALUec06qt83NQ9peI/FAcPApyNlkRWoi83Rp1Tw4nLL7BCp8pKUo4h?=
 =?us-ascii?Q?fGlQhk4F2417hzzslM3FaHYz5BhgZohbT0jhii5snkWud5HysiOGuQs/3p9W?=
 =?us-ascii?Q?AqAjL6OUNigfpbX8aSSpqQKLht+KwMe02pb2b9Ywmo9WB5natWsXClhCQ4Si?=
 =?us-ascii?Q?2kyhMEuvohOfBt5KFH6xw3VzJtEUwE2c+XZ6Bpdnba0tvny4Ms9Om36RMmnE?=
 =?us-ascii?Q?QlTV1v+IpOULhV+m/B+1TJSAUdqOzpK80+mvq3c9qgW7Jc0gOBwB8ZiPS+aw?=
 =?us-ascii?Q?JO+g1j6JUtslZbL06E5fr2Pb8ntyYj03Hm2ugyN0V/IQ+bCBWsJVXSslH3bk?=
 =?us-ascii?Q?Wt3EuD3n2zc7BSL6dLiRZKc9FGpQawotJnU61DPQn7VOgybkV4pZCDFih2wd?=
 =?us-ascii?Q?rNhLl5N8CwwePedS/CGeHXfbYrDpDJ5KDjSyXaZbK534oGSWaBMC01UBNGOR?=
 =?us-ascii?Q?vSFcGYVdOwI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qhqx4wQITDe0HIaJbjUsE5tgLyhZIVkfAbnqW8Hs2XzLgTwTN7cxjGELM6iq?=
 =?us-ascii?Q?PdR6MuYxqaDmJiInQ/6yR6fzsHbKXLnZzaPIifxsLlNnhawgkV96GhomiKpb?=
 =?us-ascii?Q?yEIrMgWZv9m0gVrITaenXDbP9gn7MnwOQUI2+SJU/EcuDWjdwnXAlk/C/9zX?=
 =?us-ascii?Q?ad4N89QhahD6Sun7q35XsBWA12CC5AEs3LvA8EWtpzgKS8KTg3NMXeCAEedq?=
 =?us-ascii?Q?bx2Ltlsqo6wUAB9k6/083ia4VgiShZkdTR8YIC0nKKLPUTT1WE5B9nch6sYJ?=
 =?us-ascii?Q?0CWXV1sg59ITtioNyx+SHOzwuKSxKygXKYFUkMwAOsWMFUCgx+wQrJeXqfZ4?=
 =?us-ascii?Q?yCG4LED6qTWAC1MfoRkIiSV0NFMIX2y2cZhup6naB/ZSYKX8xXhZeeWL4gwB?=
 =?us-ascii?Q?FRYlmwyUlptXoa8kBbbrShVeKZAFxlkAXn37G54ecgNBtNDWagVG3840YDts?=
 =?us-ascii?Q?gtBT3K0E6dvfseMABXe/gTfySdBNoBl5eXgu2/Gnd2FwZmkqQHX96WJqCfVw?=
 =?us-ascii?Q?4Zi5/tFadvAPAD2ek7FoHqix0oe88b8WVTgQMl0XzqpudCdFPM0TFPXl28o5?=
 =?us-ascii?Q?A5iOlqRkK1YoQob51EPNrPGenNAdV5jE03sQFCa1l2NTIkNBrHbVW4vXd3cT?=
 =?us-ascii?Q?Fc5WKxdD0erySGUI4J6Rmp1ZwG6AHOYcIFAGsYIa4qed69D0OnaACPKv05xu?=
 =?us-ascii?Q?WQQ4lrBuyq6pcHJE6neTt0qYuFLFI6RhJNxOH/IMEctpv7GkrM9TQWZZUZ7w?=
 =?us-ascii?Q?nLwr8pFZPiLr2UPrfJVcVIL00yWkvBz2+l01DQ5W86CouG2ZCz5FjJnaXkHe?=
 =?us-ascii?Q?C/Lj/s4vbMiy2eBVraBboGtlR7DgQUOfdv/uFPJzAEAi/3LX6nqcltEKGHgl?=
 =?us-ascii?Q?wsERMdAVSeFEzGJ9Ty7bU7MrzeCioYud994Anfee71tby+HfP3AD1OAALuq2?=
 =?us-ascii?Q?n1Dn4H3rGEvOapRilAHNC7hwH8X+r/DM9y/DrTUqPk97oEJ0Gay/k9mtZu70?=
 =?us-ascii?Q?swvU8HwYK5eI9y84i4D7XKEUdYl5VQ7iw3tLPgr0UQ7RMflh1xwqu/lBw72M?=
 =?us-ascii?Q?phGKhWDAZ7MvvbmfD776FM1z7YFztFIANsGNOBtayQvxIwcnXxg2QXoTqZDP?=
 =?us-ascii?Q?t8rtzj9narcYRjEjtztaUrMPU7T+IQaTbedakY7Oa77MJA8KbS8UlceJjqFi?=
 =?us-ascii?Q?78rSID0ERk+zZLq1Y3diRm1M4Rj+yM6r2RcOzSJEIFP9E246y+bzDglLWzC3?=
 =?us-ascii?Q?ZiwP8x6Wa3PcC1BwLOOIP77Mr6avs7bfh+sEjZR7scg3WInscioW1Gcl9Kjw?=
 =?us-ascii?Q?vxbV3TvWu7ENqAj67A6eRg3VH0hSHGuWvfBG1M87bl3vrWEm84mL5qlvd9pl?=
 =?us-ascii?Q?w4GlNdZN8q5QkUgdajhH3eqeef5Ge/r6taCes05RgKLgkGDtU+kqGBpk9Kj6?=
 =?us-ascii?Q?R0lr8bwzQ20H42zJaf34fPIbM9XCUY6L6+0Ui6P8J279yjm6dD90B5Wy2Xsa?=
 =?us-ascii?Q?X7azzR9XN5nbCocgg4pbSlxfUqmNmVjeO3WTRz0210v6+vhLKoon7kplk8Oz?=
 =?us-ascii?Q?TpCHDRas89+O3HwVjuh1siYIFjhguSRW/pWpFZsF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UDG1WISxgP2FDIOqj6IEPzG+zHmeggkp7zbC9+dnvR3md5hYa6X6+tHipSs4yL+KudQzEKBfrSLmwtveygIzw9o0AHqJdlAQZ8X3cZKfYcqGzyhzdWyWNj29R21gRPMzXPDpkPCNau9cO9hjPa6MAr28Hw6BE79GacHT0mDnC/GQ4D3fKPmltDFamkNGtpRq0kXaDsR+/1ZxsY7VDFrK6mIjZTlxweSpF+5jXllN16NfjelM0F+o1X8PNrqhHYnIMsC+IguoxBQ7lGf0VgQTR+Ln0PAW4Vq5c6n1xGlmnlNzj9H+TY5u7yXtAjbdQxB1DAIrvNVDHoys0mNmt+1jPumd1fRNAsn7Nua71Y/EwRfEx2YuS9XK7vuOzqh9bQx+IJuzLgsmfLCxdzjpwrNzRsrr9zzQ1XS5eDtES4uwq7sYX5FDaoNbo6u3l9H2tchAYUumuHfHqIExZLaGaoxo+U4bd33Cn1gqgc+sgM1zSRtRsYT+am4qHoGvgi4nFGjr+7btVgaFkjO2LZyLguL535UumyrJfVqg4+dw36xCkQth9nuU1atsa2qQk9HCdVsjMktLcU5oz4PY64tQsTD9qKeuLNv0ivuCDMhqkiyJw8s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f770c55e-8fcd-4ea3-0754-08ddd4f3cebb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 14:16:16.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csC/ZoAxFb1AZpiqC45bkzrF/yu4IIhDoownxkpRYq+lJwtXYZR+y3H4DkJuYReEhrRcgsaGq8S6toMi98HzOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6674
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060090
X-Proofpoint-GUID: NITs7GbsWmvox8pHE9grhDKZfAZivu7Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDA5MCBTYWx0ZWRfX9ThBYyBW6nF4
 qsrguj3dnNge8qzreDpRG0W7bn9Tv2fr8Ocl7pOA7AInV0rEcjXEesk+/KABqSw8gi5Q1ATyq1u
 JvephqcG/H9hZHG1ZxgfzmsjEA+CgLXoXdP2xOlVQcCGlkWYLla0MzsGVkw4jgKkx7E5307Jq3S
 I4ncbJAw56xQSEDjbgBByg2IWNC34R44+X+TXkex+rozOXZOhpNpvV8cS4WVQ9SUuedwMBIzy9d
 /Hj+37D61nf5aj0UrQdsQopK4+6jI7dNti1HA9OM/o2vT+yuxwc5UcXNGs6riT2EHJLZRHhGzdG
 42wj0GztmevNxlWj+KwQnhYCXVtzsFzLoTETemLJ0l7CySSk2T7yngWC7mph1kbhsG8ZDwlnPNO
 D5Yinin4Qv+2fwnaTFT9J710t/Gq1feddq861LvVRS8NSXimBbsqrJ5ZCpZOyIfSxksZ0+Y0
X-Authority-Analysis: v=2.4 cv=Y9/4sgeN c=1 sm=1 tr=0 ts=689363bc cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1WtWmnkvAAAA:8 a=yPCof4ZbAAAA:8
 a=nQGAWNjRSsUzQmxo_8EA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: NITs7GbsWmvox8pHE9grhDKZfAZivu7Z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C55D40003
X-Stat-Signature: ds39wux4j8busyzzgho97yey5ingf1ub
X-HE-Tag: 1754489791-821842
X-HE-Meta: U2FsdGVkX185pM5Z67WscM3mV2PNp3bgoPeJkNzkvn0se34Oomr80bZN/lBW3cUP3sZrhzUBqBi6k0C30/K5RdiZdGp12QUJ30RKfX+5qqcH0Qrfr+zfHQKLkaZesLFn9snXjy/QBIaKWvuKKzH7ZpZ5kkCPWpVHwgOQ+NYi+cZZyDTesp9a8pRlCqI7kzaqyIiYuK90R1JK8f7DlU6sxO9ryAHFv+h17Kaoh2iEMvnklPGyP8JFDHlCX5lDD0EzP9Gl47QtAR45GxS9fgjlsH8phYDXZdM2lBcXjnUvB5fwU0KjpXda58lTncfCJVGxMllTfiXz/G1fycZlWYvRSoVVJJbqIUdIFaCOn/Kn8dzYdpKxuQvnHe/gH+iej9gkJ18mwDRKDkevcjlW4mzAcaMom9LvzApOKY4RfdnPx7Sb481o3KbP/Te0YDaRE5ssCDDHru1Y13RFibiTxpyTJeRgiH7HccJgJCGiQMLzFSlOpLSTSVV0+s2NWhDNb2zzK8eT3AHVwuTjRH2CRgnGeZNlYzRCM25jB6S6OlXwLVuEGgTqNbqXx+9irX6XLmvFaSxUeb2RoG69nNqEfXD+Rvt522n12p427HsPQWyOgQq6v5LUMpJiknLjnpsmg++c5/QZ0LFEkIZwpWOWU5HLeQIAMoBhRvVNhTtKfjRTPQkI/fkHaOyQbMNSKl8cdhoJKLSkgY1LaRmSwJu1LQtlZfiY6gqOPP/rPCd9KjQdLLqS3lEano//CizUh6kX0OjLLuUZ/w8iMcfDuYQTLBi8JZQOK0qSGP40dzPhFgtCvQAKESUX8xkNo5ZY1SU5MEIBgK0E/XvwmxC8Jt3HAPuD00IxM33R5tdT5doulixsB3G9iQqX8OQt4RK1I3NbhKGJy6gK3DBDfwUZ+7YPqe8o316IOd5r38BxFgIrfkOSw5+kg1cMsDemJECNMbT3zpLg/HCCzNcb2ThxSs7tOrq
 erCKeSy0
 yPJwhT2olU9TZWKUQxzgerdJ93Y6SygxkmqetRedR62UGmZmNfZHzd7rG/uv/8QX6MVKmfaq2wCHdsoskYntCZ5icxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Qianfeng Rong <rongqianfeng@vivo.com> [250804 08:57]:
> Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT")
> made GFP_NOWAIT implicitly include __GFP_NOWARN.
> 
> Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT
> (e.g., `GFP_NOWAIT | __GFP_NOWARN`) is now redundant. Let's clean
> up these redundant flags across subsystems.
> 
> No functional changes.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  lib/maple_tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index b4ee2d29d7a9..38fb68c08291 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1344,11 +1344,11 @@ static void mas_node_count_gfp(struct ma_state *mas, int count, gfp_t gfp)
>   * @mas: The maple state
>   * @count: The number of nodes needed
>   *
> - * Note: Uses GFP_NOWAIT | __GFP_NOWARN for gfp flags.
> + * Note: Uses GFP_NOWAIT for gfp flags.
>   */
>  static void mas_node_count(struct ma_state *mas, int count)
>  {
> -	return mas_node_count_gfp(mas, count, GFP_NOWAIT | __GFP_NOWARN);
> +	return mas_node_count_gfp(mas, count, GFP_NOWAIT);
>  }
>  
>  /*
> -- 
> 2.34.1
> 

