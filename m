Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174EACA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F1F8E0006; Thu,  4 Sep 2025 09:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556898E0001; Thu,  4 Sep 2025 09:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41DFB8E0006; Thu,  4 Sep 2025 09:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1078E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:33:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E181F84D9D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:33:29 +0000 (UTC)
X-FDA: 83851659738.11.9F95731
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 67DDC1A000B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:33:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bFp0Wr7C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LvOtqsPJ;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756992806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nt2JtdDY8VqOFt40yiX4q/AZbfQ3uFczHrenEYOtwvY=;
	b=MiZLt7bBObBqGCPJGOUxUVXqoBiFjoO2hsFCFwxdfTDqLNPvppQaaq29Amd31Hn16eL7VL
	sUkzBCcO7eKujjns+fAA+FZ+NXvXyFiIz6W6pl7dt1gVtn+Xm8ftZqaENV6qyTF1CZzHxz
	20ILAmENb1I2PVDydpmzaQDVGrG/LGk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bFp0Wr7C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LvOtqsPJ;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756992806; a=rsa-sha256;
	cv=pass;
	b=R/gwCC48+6vpGT6MYwCn7xZNYLShlcwVPsC1iTzWfbwA3inwvdJfqWWNPI1XuvNgs5ofxy
	awUs981/XebShZQc5B61CfVihliLKOaI/IMe1Dt91t8UC4iYJ9nlvIrnkZ3GIRcBYzWXQD
	WJ9DA23r1hRJx5tkyQk9Q0xdUoSFI40=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Cse4h003663;
	Thu, 4 Sep 2025 13:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Nt2JtdDY8VqOFt40yi
	X4q/AZbfQ3uFczHrenEYOtwvY=; b=bFp0Wr7CbdJk+mtIKTCaUaQ0XXZAAKlP59
	IYa2j3kw3HXUNcTfl9ubxX9kV4QGrxzgEHrZW/Jz1zY4P3El3/wULc9N+iGDhknu
	OueCjq389yJXTKYirWF2WLB6Na87FjWoDm1QcwEu5b387rQ3afUl/sPQKrM6qLjd
	5L/Kx00VvTmg4a1ZVPp83pRfaK4VZ3B2NeAB2K7fnbMS4piDohoHRkqWdC81xVwX
	mrHWYeu+5vHoGHZ9nnRs0Zu3+YHopRgiCevJGkCOV/NkGZk3VVTAPcg8yiN/ACNk
	xU1wX/9Zps2OixApuJx7yRdsHZB10JnC9xhrph9/tDw7Io/SA0kg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yb6dg324-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 13:33:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584BahmP031067;
	Thu, 4 Sep 2025 13:33:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbp88w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 13:33:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUopG38238BfcthclHoJovhsnAy4lxZzCosxEs3n51mwIfJ/8Z2pYc9IrHdXbWTo5nPDWrZu9xEalmRZDIxbfrXdLZL9hhtHliPlVvhPH9czHXIKmVJiLPrUXaXMCc4fi9iu7h41xrJmGuL485nT7u1A24LDAHphxG3yCca29fncBBSQxDfNZSkB/NSieQoHFNOci7B8XD+7DoavaBNe/iD0tBgZQCQ9c/xNLrZtldqHBo2XHk0ILstrnPJQv8UXEkazZrIPlfx9H67UivZjc24yOtD1wFpmVveBAfjf7wv4+xzuZffpgjxQWo1bUZ4ajpAloxwSZvZlcU4KK9LwYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nt2JtdDY8VqOFt40yiX4q/AZbfQ3uFczHrenEYOtwvY=;
 b=xQB5fAoI+sBw7Av/UbtaDCZEe7bLhGIf0BTmcpsQomFQWASLASgHfwXulsa5V47SazM034ZfRKp6dPYOtpjKeKKQvc0mqY2prT2dc9SOcQhxW3BP0NRCPnbRJh1VFZgvxExLjU/0D4lMB5A190DCAluh0sSEfci3fbVbhgfJ2vKWCX3eF2ZSTIeiw72cy3cwmH/KKOAhxxKetU8+NH001dmsOLa/SfyxioQZIVoTAPgNRuj5GcACtVp/7EPPKi3WuRLw9nILzprT9tAnoYwZGP/RaX2kVx44Prqw7HS7aIf44BZFYFDUydBbr9LmZLHTSZtqIIbZ3x+fv0zoYfZsPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nt2JtdDY8VqOFt40yiX4q/AZbfQ3uFczHrenEYOtwvY=;
 b=LvOtqsPJT/Vxz3P6RsFj+9kZgV1Mns0Ag92pYC6ZwkaLpgzhr557e1psw20ZDzrkmfVekJfnL4mlhMgvKkqPNPx2HEt7f4Az3OV4EFkXGHiAGypISRNJnA3kCm7OW3H21QdymIGaryqsxBXe2LomP4s+8KEXrxW6UDxzkIyzyD0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN6PR10MB7490.namprd10.prod.outlook.com (2603:10b6:208:47d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 13:32:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 13:32:56 +0000
Date: Thu, 4 Sep 2025 09:32:52 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] mapple_tree: Fix build error (`make W=1`)
Message-ID: <6nk7wvp2vbsc5myxnx4mfohpq4yk4ixazkvif4hntilpuz7jtw@a2q2if4nc7kn>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>
References: <20250904090423.2293933-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904090423.2293933-1-andriy.shevchenko@linux.intel.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0066.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::43) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN6PR10MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: b7f7fe6d-a0b6-4fe5-e3c1-08ddebb78e60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LrgyygX906KcM7Jka6/ozWkYuAORqDwzz4hEBLhdc2aCxZzCVVboSIgHOsAP?=
 =?us-ascii?Q?ux/DJPmXjgkYe1f6tUi2OHTXGHgn0Kgv9HX3pYtDn3gE16mBMtAcHvKbZwWS?=
 =?us-ascii?Q?j1SbbanqyxgK0qz1aMIYzJLrZ/EZ5JDMA8dVRstZ01cmLdAqfJoXw9yaVtrg?=
 =?us-ascii?Q?CcMtIV0qZdD+zmdyMTR+nX0LzSTRogUkh1MhReSO4JUoKExzM84e3GIgYTSe?=
 =?us-ascii?Q?atHcjwxMhtVCqngwKdE9dMsyE4XuTk0gNDPJgeGE+TnHj5TRQmNihqRnoil+?=
 =?us-ascii?Q?KdH+p+wh57F+otUDRx3wy2ZkuIDjDJRl0lRWq5mQnL4a8H6OcOfO9W6el3yJ?=
 =?us-ascii?Q?GQXGdd4fuUtoNEqbwXMMp4Zr6bszewVG3SkU6xn89CkLwoFxrB6u+1Gsst7s?=
 =?us-ascii?Q?TYHiAlEeEVWpt5cIsa5x6EOLH7i+QkPULuaDc0OyXY/dU+k+05blglY20W3A?=
 =?us-ascii?Q?l1Plqrz3wRJY+IIWpeiKvgUY0Wop71ZO5HMBNWUrz50/Ew8jOQ4IaumPiw9M?=
 =?us-ascii?Q?jsYY5JaZEKV6Hz46LQT2c9dHtFwc7DLkBKl/6xn3hpy5oOkXqz8zCUrI/D3D?=
 =?us-ascii?Q?28VphXMOUHo2bU5IMVlPSZiJTfZgLuBM/dfhyxNV/0fZqtcJHn9ltlHWFHwL?=
 =?us-ascii?Q?KKB8kdLeCcL0UF1m0ICJ8CzWMD0jBKTqhxmNFElIeeI6IRmumOjv55LjCRC1?=
 =?us-ascii?Q?BRJQGZsCdoYoDUmMR8jOua+G32dT/3H20mbyOhgM82etIQZjGOy35fQr7b2/?=
 =?us-ascii?Q?KGJT1KGUB7a9KsoSdIbBysuGcvjQb0Fd9+XGKkBUO6aAAhORliUvSqzrlasx?=
 =?us-ascii?Q?1XROEDc7JJzGqA+4jXvQqvT91pSUMlMI+hkUNknObfSQss1irZwPvArdIpMf?=
 =?us-ascii?Q?TuVi2snv7t2+cOocAtOahlPIJL9aCG58YlXeLpeEfAgibVJ8rGx5PHyuDM+k?=
 =?us-ascii?Q?GmxQkg/OcFNmb+Ggdhijj/wwPF/shx+2+G7TvZc0qXHz/uL/HWOvQklaaa3H?=
 =?us-ascii?Q?v4e2cpInNp2iLy3VOLJ8/L8HX4H7BlHMdfpjpd4Qwho6pFZ5C6KR+b6gKRkK?=
 =?us-ascii?Q?L7BoXtMQzZWgeQp9xDyNnYU/OcX+29/l0f95X0XjVh0gLNPvWh48azdGFCC3?=
 =?us-ascii?Q?jIswZBijN4wEWSGBfx4fqj4G11lchDz+SxVOx8ZnkaRh/cqxUH9AYqfAcXo+?=
 =?us-ascii?Q?L27S8SbCQje28w2cYk/wcVeufSUL8tQGuBl5hMU1aab0/Td3cI/+hAT9jj+1?=
 =?us-ascii?Q?ugpFd5au4acEjMrg6RFZqSe5sNeyd8lyJn3G4pjSefA4GgNe8sMxP+vctOBM?=
 =?us-ascii?Q?yE0Q+kcB4iKm1QQwppiD6Th1i1bcdDARPnf2+SGAAiTV797IML0BIn4++TYI?=
 =?us-ascii?Q?F9naLHa6cbRl62Ubq4hI+E44PEhOJcPrmaprEY0pFL2IbbSgO8/MNQUDEvn+?=
 =?us-ascii?Q?LUVykyStjQk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pXEFSL6/fg6LMkE6elAEiCoFSNZW6klQoREhjLBEFCXnZSJr+sjjI34DzKpe?=
 =?us-ascii?Q?OmkHeRrtbqrDXPOeUT6T9rcPntkIUa7a7yO/5G2Xz+RwA9VerW9eEupk4arf?=
 =?us-ascii?Q?x5RdcEYbsayeIh+HuZHttT4ziWCitenOOT4B2oOPBV7do8cBN5Lzxerd3rtL?=
 =?us-ascii?Q?fTGux2RdHiSek/7pUxwZhpyk7ZND8ogrroLLZ9cujWHa7XTgXQWx6mACxAMd?=
 =?us-ascii?Q?ORQvqbQRVrDKSJU94q5sOs4UEWwN/wg7W0jSio6g+FqAhtcOyOTa5cq0QXA7?=
 =?us-ascii?Q?gqJThWku9u8H9ba+0sv1w3aT4UzLMt4K0huypDoPSwaxDg3H2DG7+kHpCfHf?=
 =?us-ascii?Q?z2z8vjcYC6UNN+CrAZz9Z1g44GY1NKBw7nlzu/pD2B24Hoo09kg2jjrIr4hU?=
 =?us-ascii?Q?oCy5Yu9h2hg1gHAr/whuLxQGzmnUa3FKr4lfLG21kLTr8VPPeEqseWrvp3Tb?=
 =?us-ascii?Q?kD7eMO3Wyf1QHUTBtKzUmo/sJo8AFnxSeM+gcXMnjxixEaHT4fmcnXuGd/qA?=
 =?us-ascii?Q?acMpx3GdYSJKTt08vgotcbZynBdUBEVXhEqiYzyzZar6ttGeIky2uRFqK2C1?=
 =?us-ascii?Q?VQ564IfqU97jk7JwNa+/muB2+DJjUbJ9bggMXWdw0EWOH8UIq1pHD6QbIysv?=
 =?us-ascii?Q?76nWPzjtl/PoCJ3xuEbcB3lt4zlohfwuCd/4fhnLWidLPhp9bEBXfNlSHqeu?=
 =?us-ascii?Q?OkzLtnjFF/eWbGGnLD6hXoV61BtajXn7ONbtcdKe85hyONIHjjSiGrPVU52/?=
 =?us-ascii?Q?v+y+C1jLsffupsaFAL84TLjUHUBAaBnek0EKrk1/NVk0mjvTAEvQufNGdaQq?=
 =?us-ascii?Q?G+q2cgY9f9ImshT0CgDFhcJKm5r5IY1N71+0KcKQAMN3gMkQYmixvvd/QHot?=
 =?us-ascii?Q?bhcERlcHLNdcxtAQgk8cDuifwQp/6AzQERJPFO/uWUy46MzvQk7h3cenSwun?=
 =?us-ascii?Q?UZCOMjZT20rI0tS9rnXt/NbqDbiZUg1B5NMuEZq0t3cl8HDB/cDEdhA7FNFF?=
 =?us-ascii?Q?HExnuRdlNEwGZBNxRn4rDDvo9yA0M5KdA+Q83ZCXGWK4biUdJJW9NPvYbNb0?=
 =?us-ascii?Q?PfszoxlmQU2qYjUGGMcpE3rERJ1e5wJDBT0dRANz8E5Ao18JQqJI6S7FKO4N?=
 =?us-ascii?Q?VHreeLxTKR4IWFBXNAevpfpy8l5pAmxdkFQBjAC2kISrGKfwNRKUDvWDLu9O?=
 =?us-ascii?Q?Wmk9Mf3i9WP3AI2fMYxnBjXHAzLQw1fGMObHLZnkmQW0fcXmX+654rrI1JLX?=
 =?us-ascii?Q?HKMQuAekLsgQTaev008wpijNSWx0By9dr6ssEmM9DAIT9sePS2DyexubsRdQ?=
 =?us-ascii?Q?Br/jbX/hFoIkRgAyYZ2P06OkF3nRUpsOuAD5HuwOvMiVgYbss8Sp17kxGcG5?=
 =?us-ascii?Q?Gd8GblqIH/urxlIJckqQYM6tQcB8SvoMdT5vrqveT4qmVbpk9sno6j/IJjS3?=
 =?us-ascii?Q?nlg6VW4CxdybJHYzALJQ7gxz4wlVPiZae7MFt8PqBNpF2a38ObIai/BoZDof?=
 =?us-ascii?Q?6VkdE1Bi5xqyVMXvISuMERMDMGUXo7l2KyL8HTernsSPQFudb9HZgGIdvlOw?=
 =?us-ascii?Q?eB4pQB3Uimzs9sjkTNZcUJRyHhwR8Kpjh7x1xMXM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gkmOv7gnBqyKPMHzQCWzi09dHjmzkyLWT36dpHDJ5bxyrAHP0IeyZt7axJ1+denoF99L1xOqzxVxomDGNMnuNVt5EG1GJReodGy767QruaZErLVvHlqVghS9yCDWXPSeoSeWzyptJGqWnwRJQVnYoednhrheFyDUzkH3cW7Ze0sJC1oduSgYdNzUhDK/fi9Lg/DAZzRtMQ2UBnQh7sRCI86UuVp/+WmhSByDxh8jcvFfZvKOVBTKVZIjfLcUrmb82U7MI4O64uSMYJkbfFOKPTqcaSx0eYzylaUXE7wkFw5lGgyAezMyuJgktBxmIMiIGPj/OvPxORvDzPx56OjubIdj91lcUpAnFoVVq73zuaXiYxwb3y3HQHlCJMV0I+v23Iv/nbKQzPaIXlS1zl87XGQ9WWgNKZgaTzYKhpv7yVWul84f2xQ1ts1oGnPPY9R1x9ETL4AesycSnY30hRGQPaPFZG4H4zKWxIzE4XrlUKNORFRPsN5qW7ahRiUmlOKEa7iHcE5js3xKkAYI3ohKUSYjjbL3qUl9lV6OKS3JEYbD2q7ij6iEx+3e3OvdqcBCPttOQot11lsKn/yCncVkrr5MtKYOAgIkfTxlmJK1Mn0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f7fe6d-a0b6-4fe5-e3c1-08ddebb78e60
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 13:32:56.3593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HxV/RX95VhqN5P/fmdMREnRDRzdu/R5uR5Ae6A05snuL8UTnKREAOWYzRevma68v71ni7EJOBhRLPsMQcHeN5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7490
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_04,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=783 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEyOCBTYWx0ZWRfXy64q5zenkB6A
 a3+hxd8ocH8fV/Q0EnbTwWzAiEza5xywfXO2Gz5LCFn0Qux7CvU4R4m8TYovlSpqhCPNTSiyKsX
 X/cJH1XwTyWbO8ZYeICSSaiiiFcOFZNaXiruyFl2lxdH9xyDmWWS52vRoI02aqUdGp2FYKUYy65
 hkjhxJhQH3vQMfE7OWtYC2cKp4g+rai5k1EsbLFeqkwtyyqFhYyjPRxA3rNzwLfSvpw3QdKbv+I
 h5hU99G1T06oIPH9CZM5Gdne3/RY5We68orsTwZTJTf6Pwpr62C78m1hjOc177vN5Tr4cAKbIZF
 YKh0nYJrpySFBP5QwsE49BFqZTWRIKwQX10bV4T8EQno7A2MGGtHdhQ4yJg/SY9fb5cd2xjI4e9
 eVO4N6kPNx9vUSAuvl+RlDxPBI011Q==
X-Proofpoint-GUID: 8S1ouID_z1UnLtpv3WVgH2UzE6irWnnF
X-Authority-Analysis: v=2.4 cv=Z5bsHGRA c=1 sm=1 tr=0 ts=68b9951f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=QyXUC8HyAAAA:8 a=kfINhHBjyIX7GFQOMfwA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: 8S1ouID_z1UnLtpv3WVgH2UzE6irWnnF
X-Rspamd-Queue-Id: 67DDC1A000B
X-Rspam-User: 
X-Stat-Signature: mn7kye1jdje6493prsiaej16cn4qt137
X-Rspamd-Server: rspam09
X-HE-Tag: 1756992806-170097
X-HE-Meta: U2FsdGVkX1/Lu2SKBQSwesIAuSetu1wG8MUXhYkzsYrCVsMohrcDx5dyOP4wkgQqH46WWbInRTJerWZt4DRNIOd6xwosLgV4TgzCudZFb5cYghnbwRBRvJL5mwvLoIBB3hI/HVNVr6LK9SxCnKg2E8A3yYBAG67407nm9vtce9seUDfRZkTBI2d2FvU2eW9A7ij5oHvTzRhwbA9kMC8JCva2F5LVJ3wbeVH0TWEq44GKtmjFnGzA/p3c7NjbPvVXLwj/jODylYIqQMt1Go2K6uHZh4ygMwVn+M33kTLGRkH2ha/iXt9Kgu1eedc0DqpeHD+waJIiwo4oeROuQWE/qWxRwbhYlqA2aWn/WgQeGFcRBx63rzwCOCsSJ8EoY3twRbzmNtUAnOaOwg8/kstlXb/T/FSSm3AO7cnY+TXQRDu1wwMXsVugFqDSWOMO4irUvi8U7VD4+PclYe+ovqjgBrgO4WN4u3fDXOt/JHMKIctA+4J/aMiuu8jiKzZvXptPefTHqTJi7znKkzMqyCMRasshEIXrgKqC6Tw6LhjXyNH7BV7xPFOcKa5VY9MHibgb38QeslybrPw/feUZHbaHsKmYuORbM6vrMRtL5wU9nUurfYeRzvs55oXT4N9tCoygHDYgSeb2KBsHo+SqsRCzhX0mXpod2HVfVlmjMiAYsNrGZxVfIzq1yvUADU4/g/L+vke21z2cya0h0j0CgzzHQtAhnoZ12KcHpe/ysd9c2/UK8bjySGelYJcFpACYLv7wtj0HKCAM6uyiMANWJAQmGHBym9T97SsefvNs2pN+A2pxtqwOB4cArSOiat4gOIjWIJJFvo2NqVEb1Ew0beHzEjrJsxaHT6Vba+i92L37SAb+Ir4Gwa2lGBqqECm4T7TdJEtS+58n9MwzlpCGhwxj/+ODtarGuffyrW1krmvwMFOPGerXziSEjKLdsln07njgwwrLi2e4ydGKdw2F25/
 xhWfki9k
 pTFySOkfxRmkvVtV2Flpmxlx4l8z1pTYyTms8cHq8um7Ve2SkTQCZTKyTd5fbMfCeN2YkYy+297/kIWfqnnw14SJX4gjobwGZ/GBZBLz9NWl9CE0sH2ycGWiNM9HRYlKKszCoaRdNuDTW2kl49MWYNuIn3VmFLuSOvuMQgtQ07bxYs2NLFa8JLk/rVpYx6aI4TemuRiaAA6FbPtUVfTt7QdSS0dSVyegqJ+14pqeSBmpgk0EHrFw9z7Wv4j2FUa2Nshcp36uHVOJDOmMR2F6iYrrZ0kuR0WmPrPQE4e2HRV/HwAuCEClUHUfWkc6IkjofBGYjIDs9LkYf9nd1QZBeCOHoqTvMlUNbQLeOm3pqqzGBNcsN/Vhlqosi3WiaEAQbTbU0c9kgzZIPF/8o+WHgqsMgvrLmJwRrRM4w3BpWy5C4kl4xl1sHX0tfMTKwx2YIUjHblEzkGvQuMHBXeE9oDg1WPLVL+BbAKyy7F3bAVj2Y3Ysrt7voAEObmfpH0MU447wIMcjW6Ac6R4ZQuVDqZ7og6l1tq53S+5DDN37c6vvS9sWxw9ChiQjMXxz1IjXQITd7v/0XnDQPhh0W2TyoASPHAxZK6AtCl05Tp1wG67tRi7VvJDEfsAJs9ykDdwyzZfXet/zh0MSpAQ/pM+8ac7b6/B5Xpd6auu0R0DE22416hVJkOnH1cG4NyBkIzB/2vpolJBK9AuHWnRDwkmibeAvNgODL9JfwYsSqj7BiEpUlzrmMsNkhlXdvh/5YufPi3nXROtgs8QLa8QTBJWIKNKMAbwYA1L4cv5xnKvG3eTk4UIfIMYRfXAAs54P2mpV/oz5buM92p77U9cY5ppw9kmF/k6CdAi+wKrgz/7MTpNy2/c4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andy Shevchenko <andriy.shevchenko@linux.intel.com> [250904 05:04]:
> clang complains about unused function:
> 
> lib/maple_tree.c:179:19: error: unused function 'mt_alloc_bulk' [-Werror,-Wunused-function]
> 
> Fix this by removing unused code.
> 
> Fixes: a48d52b2d21b ("maple_tree: Convert forking to use the sheaf interface")
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks.  This should be squashed into the patch listed in the fixes tag
since it's not a stable commit yet.

> ---
>  lib/maple_tree.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index fce329d6c1b2..ca8b3c2e0362 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -176,11 +176,6 @@ static inline struct maple_node *mt_alloc_one(gfp_t gfp)
>  	return kmem_cache_alloc(maple_node_cache, gfp);
>  }
>  
> -static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
> -{
> -	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
> -}
> -
>  static inline void mt_free_bulk(size_t size, void __rcu **nodes)
>  {
>  	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
> -- 
> 2.50.1
> 

