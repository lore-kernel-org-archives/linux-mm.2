Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 584B8EED60F
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 16:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7468F6B0005; Thu,  1 Jan 2026 11:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC696B0089; Thu,  1 Jan 2026 11:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4D16B008A; Thu,  1 Jan 2026 11:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A97E6B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 11:32:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6528140AC5
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 16:32:47 +0000 (UTC)
X-FDA: 84283938774.11.C6CC67F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9E9B160004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 16:32:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YbPaJ3Hb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SykuBvTc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767285164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFNRmn8vAPXYMq16pP7hJcOY6dvgCf2i0UNHyhv6WRQ=;
	b=vz3TLNaG9rSavcc6b9+lyKbUtPSXXab++y2CaEmQR75QIBvXDqPlNLv9kZv/20Ibx5GZmz
	gHwh9EShoC0tclgT1ofnmqPyA3E+4PQHEIRFn4hZ9TpiMc7Ki38mhenqMGRMoYbQX2d4HY
	kkmqaPPXytBfO4zSZPZ5WuAPwromlTw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767285164; a=rsa-sha256;
	cv=pass;
	b=pnXzR3G3hL7xtxqEbGHi9ENc6ST5H6NttkFb2jwEyKYAmlUaaJbaDwH96ROi5TDQfy56oj
	oh9m1swpHYANV9hpUVN/M72qQStm0Q2UHALm9fF7Eyewh0YVch8qHLwl6Xf3kecQf6HAxR
	2FR06KHWGBw+R4PA/LGIwiNbCTMG9uE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YbPaJ3Hb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SykuBvTc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 601GWb631220848;
	Thu, 1 Jan 2026 16:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LFNRmn8vAPXYMq16pP
	7hJcOY6dvgCf2i0UNHyhv6WRQ=; b=YbPaJ3HbkkLiGjB1CxLHA0J/R5hMN+2wU8
	xd1fzbvCso5H8sb3RYn2YhNtaBZe2yah8aMWhLLBpUHEPFXpDunXbn7ihYEWJg+Q
	9Rc0oW+UWkBaid9j3513l3wFtQgqdEAYKU++wuuT/aFixMiragO/Ju5MZT1Mub48
	nTD21Vt9Q5P+uR3GUybFuhgMIjaXqT4jUpE9Am1DNtD/UqQXiZ70oLpLzEDt38fv
	FmPnLloWp4JuQuMvG8Uh4+hFzq8aT7kRzKm3TVRnGsWeEvpXHq6F1lI4zWqcQ9HM
	odkeLj5YyPgh7c39EkTZwsG6XF9NEzTuTDm4sR0/griyyAjh8OoA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba7b5me7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jan 2026 16:32:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 601FomxI024404;
	Thu, 1 Jan 2026 16:32:36 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011064.outbound.protection.outlook.com [52.101.62.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wkt6g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jan 2026 16:32:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=il0c7Fn8jD+sOwgcnCZSqb3//3IIIvqeeGqnlNKObx4mIVCVAtq08tyFDKP7aX7ziKwh8J6CBNajA4p8a8ciE1teeWnwkmVfNjIlsWC45o4ny1bPjoTxQB1rJYdJyNNvXckPy1E/E3g3uRGhTOJSX1hf7c+qs5A74FIHiufa/sWumzL9eD7gzMhJSe+AJsQIyzfU6HGwzidQrgAGtafPyih7TfkRDNWEjPp5MVjcqGaj6g1rAn02xiYjgGy7IUtnxFFYRCccJtvvY6eTqlmNyCXyb4/ko6RvAkzwb3mAl3WKa+Jn/YToPr5Xc1MaAi5x9Nr+hx9H0uYOyopvC86hRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFNRmn8vAPXYMq16pP7hJcOY6dvgCf2i0UNHyhv6WRQ=;
 b=sZHs67IjlhcGwpPTajvmvxqDSVqI1oSavS14V6haEJ5dXApeZaMegC/PwqH10dzWBENZGcXaUS8ZAFzjA8NmdYWqnoeZexn0yJtIIzOpPS7BjF7aNc1hGSPXSqF8+9xS7EkJHQwqrlJ1W47BvFO+Mo5pMFPjVG2TGxYFUUwJXYtWD2ddBXDWpudfflNKJMqotIBPW9yPHptx9aNUH9Xefouhaj8rk1FBmhgQVT2qYE0ieR3ER/GwreRaXZhhSyF8wgGpETNEhhv3fLAfxPRWDahVFsrP944p5YylCRhU4HCIpbM9nmy96m5DN3sAd08M4ymFgvQZn7p3uW3az0AOnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFNRmn8vAPXYMq16pP7hJcOY6dvgCf2i0UNHyhv6WRQ=;
 b=SykuBvTczEndDhedSIa1sSDVH4z2p4oTlmrfV56T04/cOjnt5XgbZnvvkGOak1Jh2ha16l3nFHq4GhAprCM6H2BZxmFxAPeQ7dLGNZe6FYUG0rK25aSNHW1O766aISEuz0rwbGng2ycne8M074fwzSIXVhA676QWX7QQqbi1KrE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB4860.namprd10.prod.outlook.com (2603:10b6:610:db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 1 Jan
 2026 16:32:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Thu, 1 Jan 2026
 16:32:32 +0000
Date: Thu, 1 Jan 2026 16:32:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeongjun Park <aha310510@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, david@kernel.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
 <aVZ6b2ri1iRpM-7y@hyeyoo>
 <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0436.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB4860:EE_
X-MS-Office365-Filtering-Correlation-Id: 55a8c87f-d451-4b2f-7edd-08de49535cfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U8BJFJfflLYnLkfDNZoVdl88fVoPVqaDygCNDxCyE0bj3pV2mOiKG3xMJzUS?=
 =?us-ascii?Q?SIpP3YpE/FxQN/m9CTiz2zYuplbZtkwZ+djDTs3YvBcq0PyE4GaFf8xl6TFp?=
 =?us-ascii?Q?iVDjDSypf54eacOTwcQVMr2mzwCCQp6Am6Cdrz7pq5/TjNhy9TJhOa+16fCn?=
 =?us-ascii?Q?7YSLIaP0E9dEQjD0iOnFTG7mAqUypnNkaINx8eHxbm63qxxI5WtUYbLspfHl?=
 =?us-ascii?Q?gtdsyPoXW56NCZ/uZIbj+fXuvlpfPhm+cAi6pC5Utj7Vo3preD91mvd8699D?=
 =?us-ascii?Q?GRWfiY4vqG5K7EiqHV1E0yyR3M/f98FJIfbdAuxC7p/DoUbLoIif8GSz2gV5?=
 =?us-ascii?Q?4SAVNu9IMPPRgoKrj2vHTLOWSLztLR43juRDpGckTMnrMwu11I7Ou8bPftyU?=
 =?us-ascii?Q?qdgxzfokqlOtaF62TOZLMGDJAmWscg5wJ1qvagXZdQm1JfbUDMEqLJV7h1Z+?=
 =?us-ascii?Q?Tg+eGgI2e0q2cKRbnuS99djA+uUDqMH48+QyeNUosHPCU7elOG3xP/9mmOXZ?=
 =?us-ascii?Q?WxMr5OLdxBbuKbFuMcjpB1tlJVGvrxqy6v7uiyPgq7ScG6udP1C4JszhhZVW?=
 =?us-ascii?Q?k0lxymVvERmNsgmhhFABR1EzuID9V4Ou118g4QZp3hXbjV5ti6KbHYZ9vUre?=
 =?us-ascii?Q?v7KM3DPYn6TNuXhfPv9SY4lbGbE0nFVnL4nXLsyCYrwSQicwDwL3PJQJZAmm?=
 =?us-ascii?Q?1R4w3AJeKaGLvd/V0BJvMEZ1h/t6PUplbHBpmf35CKYh3DDizE0YqRHl1qgz?=
 =?us-ascii?Q?rowbBdwd7Xzf3hCWuTj04Zo5T1mqb596uILB+aIuneL06ztvUA0j8wEwsQ9z?=
 =?us-ascii?Q?TMbwt4MP7Y9WddtfStuSVYhDeKgRsu5nDYqDVfBs0s+56WwH2uF4EcMbVIPH?=
 =?us-ascii?Q?V1OEmDNByBaNC7y0GS9e0DpHIAZm2Np7ZaaYhpAH/OnAR6LQeRZAqrgKwyXE?=
 =?us-ascii?Q?iNf3pdawHqEOzxD4CWqi1Q8hg2NDudkZpgfCe+qfOEwRgJbj9VkRcVxZK0Pp?=
 =?us-ascii?Q?+Og83kttpcTzzSgNOTa30BmhIIKhGGiXpvs6fYZjJbUYT4fj9qEMMJxuRtUa?=
 =?us-ascii?Q?CW9mFYf5ifRRiIEO12u4/ihf1s/t5t3/i0tMsM1DcWv/zkzUw5hHqkr36/QG?=
 =?us-ascii?Q?CHgOHCgmuSLhAS1PqQKr5Hx9Y584nVqyMW36pJ9WeUw2nrQ64GLBhz6d86ou?=
 =?us-ascii?Q?8PD0MXCYPUWl9sW+RT2PvgK0mQXQnpmjBTNmGNl5y+1gnj3nc9g4Or4UKMxz?=
 =?us-ascii?Q?jbwEiDo4HEcHby3RJ4Ke/KT2ciluD5uP4f3RzBNxLpzByRg1I2lRPwxpoDMe?=
 =?us-ascii?Q?oaFCFdeLoM6CbIYMAcZVl+6mxlYvmmXVrmqXGDDWFXBdF+fAjcenCMtP1q/u?=
 =?us-ascii?Q?zqOnCUYaVmFfrJVnP5s/WSJIyq78JGxtjMzwibZBnjwvFtEiN0NsZH+Gk0fF?=
 =?us-ascii?Q?4sREwh/3OVV7fATGHhUZkfATtN+AT2Zz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XjIcLCUpUWUV4oTucY+yVAVSHXD8LetRdrVC2aqCxnm6mF4PE5qOFkJNFkty?=
 =?us-ascii?Q?byirQdlAXXFiLphH77NZFy1LMGb0dT707f3YK+M5ngQLkM3GVhar8kigonxH?=
 =?us-ascii?Q?dPysGXXVDfEAeqV6xQnXF1x/H0Ycgmt5USjMy1HfricysqnYlRRvHGWxbkq7?=
 =?us-ascii?Q?dBcgE6k12uYrUAUMdd2mf1+pSqYou4BrOiLbW3O2urtwtIqZAo+JKPgq2IRA?=
 =?us-ascii?Q?5D7w4K8um/GKCblrBBTkeZdVl8OiZc2ooedG+k2cSr1YvtSWf+HTJs7NuwaQ?=
 =?us-ascii?Q?DVytQ9ydIyGjAQf5UY2QpbyfkWNVyFZ7N4iiDUZkJKo7QgLWEnGQQRrRsXfB?=
 =?us-ascii?Q?iHl2XJCgqlfzw2DclILGvtx7Z/CCS/hsfh9dEi+XZyztbMML+DeZORCuDOjZ?=
 =?us-ascii?Q?jMA8jW326dSG/oinRo2fcE2MLfXg0r/vZhqKQY04vGmiq0MH2WrVFSHpfWrQ?=
 =?us-ascii?Q?qHxsCJ4PPbtemE+YxEBUj54LPy0QJ7t3xlu7UOxikrl+amzmUnLHZmML6NbV?=
 =?us-ascii?Q?xvWIUkqhpOAApvIsqQTaEvfg/8tqfqA4q6mOQCfJmMY1QjKEGZzhqSm6P/1E?=
 =?us-ascii?Q?Fwa9KAhP/fULv/nxqJFvBZd54S0HX0aL4YSj36BVlHMQOMVcH+4GrlIv7Kz/?=
 =?us-ascii?Q?aeA80jDj4he1UFw/IPCRmUvqUPUg/Rk0mUurg2G/zeuBar1K4xQPJthjD96V?=
 =?us-ascii?Q?/Br7TXc8Qc2qz9drB4JtDkOo+1aFMhVOzSASUN496w5ShdGIJvI/90Zf4qU2?=
 =?us-ascii?Q?BIKaBovpTYMzQ7Qzu40ztmhx4DGIpunCR2uAdzcF1NpgASAQZhMvOTmULoaY?=
 =?us-ascii?Q?62pa2M40vZXKsPdfIB5GpCed4O1ETVPnFMrSTqdOxASD/x37k0yK8aVs3FMD?=
 =?us-ascii?Q?Ob9zv2kS5AyUiaf7XZ9burQ3zvsZW7T3r6czgJgUltM3ME65aFuLopZuIiDc?=
 =?us-ascii?Q?idC45RCOFz9Zq9Ww2k4kDwghUO7AdE0Rg8g1rP3MaBs51ncVtf3wVgGhMbrk?=
 =?us-ascii?Q?I1+XRa6rmwUwXXQTYEnYa0n2jlgsovucV9Yu4r298hmq0YAD9YqNF+ou+MR4?=
 =?us-ascii?Q?hJqumx5gEuQ2beoVKx2oktIuBFh5m8iDPv7k5YSR1V6hLK5Mz/MnOUa0pHYs?=
 =?us-ascii?Q?viG3LhwKozBrALeVlJFEGljE3FHK/I68+T3l3xoncZFsZuPSPuv1qj0xR98o?=
 =?us-ascii?Q?ks5f8m/b77VbcWv4yZ9FSRcGezstK4M/waH8ItDnjkzryF4dI3LilxHv2lmQ?=
 =?us-ascii?Q?TItk2VAN6ZQMu4DsLCHfQ9/3+iMv7AZO/2Jgmv9vaaS4pkt18+36r7YVDTkM?=
 =?us-ascii?Q?mi1wGCw4vzLrJTh3NxIUPA3ltDm3HPjNnK5mO2HjDAn+8R+a+EuN0GlFDzFU?=
 =?us-ascii?Q?b+9ZzwXNklqCKzo6gNdqbIfCXUtHBaJp7gMcsF/j7rO/9nu5TagE/a42uO+9?=
 =?us-ascii?Q?nhTB1u+JNmw2i+J0YeHKG1PIovw0PidW75Cw+V/DOjdm+c0F8sirlTcTqzNW?=
 =?us-ascii?Q?SrXXYe420hcrO142M1B62bojLclQqQoGa+9wMNI8icdAAQae8X8VJuucUSIT?=
 =?us-ascii?Q?gupOFR1TnTKClSNRrfToZGmvW4kM9wtdWUqfog4QnZhQ8e/qwmHMpjmIUgeM?=
 =?us-ascii?Q?th88SAJacO7xQvwIPnd0IOaFx2wdu6hK0xuLisBeBvwnVLn4u2pseiKNZYhq?=
 =?us-ascii?Q?LrxK8ZK5bqsSAGv7ELKhUzcNT11nNK8ut/GrIdqsms7lQiOrFsiEVIJBAcyf?=
 =?us-ascii?Q?9HML6PqYRO+HGnwUIhAjA0XyMKopnFo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BGyKZFjEf1aVpOQC2qjJAPY39TOiH058/H6eFkXPLWJJfBTvLjugAv3Q677QI+EhsCwjPe83IzzHZJjuENxv9I8cbIg69/y98LoWwQHlBsaNKvGbUnYND4LQyFV+Iw811KXHMUJdI+Pc0Utn26pmgeneJIFuApwZyLcyaKm+EyDdWBK8Xb6PE08EaIBb9mVblMjxm8KOqAvn7O5SArLLgoSV7OzZSDti9zIo2rRFpbfSN8gT7hHD1J4J+gnki+Ka0qrDvRZ/qIpQoFQ9zK2rYodJzE7XlR1yhxkiF77Gd5Z5mx9rGvevO+t+LBQAviqZ1FSjDCOYRIb67lm1Mrego0bJl2DbQ1RidcCvrHc1zDnNgz0hUotzXtaS0Dt69Lyyn8QsaytNXME00Xk8gqKuCSbqnq3ech1PY5BlxId6hBSP//Ir6or6K7d9tAP8GoO338L5leD7g3fror5VsAQWBchXq/qWyIZZfvri3TfDI1kihm+E7ePw5mSpYB1u2a3XyUKE0NnO91Y2trX2ETxptzBr32qYijjNm6VADWTmFrdk8xhqOB4D2IPilK2c0DFZqR2trrU/h1k+NFiBSbeK/QNHL1bzYhicc6BwdSUEPCE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a8c87f-d451-4b2f-7edd-08de49535cfe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2026 16:32:32.5829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qi5lpvOYbKOYXvjmLH/CnJAxZCw7wnW9gqBOS6h+vZHM71Ytt7WPxF/ZTA0G396KDmW6tGtFkQSu9OVE26w7p5B8tUswXm499g5fmoqR/44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4860
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-01_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 phishscore=0 mlxlogscore=721 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601010148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAxMDE0OSBTYWx0ZWRfX8iTANKhYdQIu
 IU+GVUdfjMBDdUVw28eQLij3PJfsyZ3U2nXYSvVZEbzZL10wwJn40Sy8Py0EMU9HEB6KPxXvLrJ
 vyKVJEzf6W8DkENEHWny6dLDnYeeamYoOUTKfHRrBqujknggY3pc1oN1Z/tEeCeKzIo5oxneEJ4
 8xfwNWJk93qMahjT+NvGoHzyhiYS4yR9t4rGzzm768KFvKU4ZHj6KDvK/bhNk5SmtnCGSrqY1Oh
 RkIYNJ3wxQUbaqapnQs+lwcIoZ7QAgbs6BWVfIbhavOqH8ez9kWMKpCl+FhFW9BltU8BIpNf6SW
 xkchqTBZ0g/AJIE3GSiGgmGB997cr1Az24hTuQIKOOvWRJR/6E4grvtCxRq7ocdMvZrOOc5tjn6
 L2rhcQD59W+BYj5PNYuUCbsM4bqGWzBbGnHMtq8/vgjM+GOeQVMTsd5f7rpKbBRit4rpLpsv/qi
 kETJLURB/NEONYBsJDyubcKSkfUI/+Gd67eOK31c=
X-Proofpoint-GUID: RsDDU5ZU-J_FexBOE58tyfMwpTC2lHR3
X-Authority-Analysis: v=2.4 cv=ccjfb3DM c=1 sm=1 tr=0 ts=6956a1a5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=aGFytVHtiCAEyVRFHaYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: RsDDU5ZU-J_FexBOE58tyfMwpTC2lHR3
X-Stat-Signature: 1eq15ig4zekhos1awfbxfibu51w9k7f6
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9E9B160004
X-Rspam-User: 
X-HE-Tag: 1767285163-924834
X-HE-Meta: U2FsdGVkX1+WkYNlbAJbGjIbFhblQxXh1xAdvqyVijKd8si1L0Jx/0UY1e/MIKXLn/6AulY/Wclgtphv0wMLEienJ4sTe/HNY4AEloMa33trqJQ8CEDQo2+ghK9JhNN0QaQCaWNHmihKIdXKccLZAWhpOzoSD/xAfoP50FdFq3Kd93zW574JER3ajAeK3FVTQHPLlxXbYeD2u0IrIJWnGLiZuFlDSJPAXygSBZ4h/SgfffzVoPEpYCW+8htjY5YP7loQs5JyQ7LdmfsU3i/fqPD5ZuUDEwA8WcRplqMOXI4oW0ZhxGmKvm6A5ZaKptpwqnQuS8dbwdZEweTXE0fMam3e5D1QsVfIF/b0pPexYSWc2AY1HJkVK5sdnXehlD9f+/e2abCeC32nWolW2tUwku6yg3njNreTF5zaJpd5UzfsYnn2A3ye0HJOalM69xW0kmupj8LS+1UWa1sJWFoAbTS1mudGgtxRdGugJ4Z3r81wbM/VglLm++6en2SG5Gu/bXWrE7hcTVOOmDNJFcBR1VL2IXg0jVqMLXldBk1xqKu8Opx21ERW/In61zko6V/IDHzGpY+S+WDF7QGDT6ZEYtxSOHcDeSXtZN6AhndHfsPtFU07lDkZDgvfYJgSPJIr+UOfjV+ZoyJ0TD98gplx+9hsUlF6ZguMwDz/hmNB+0924PBE9IrDlqKDfESzGrstVkvFNGgQPdyRgt2QaPtomimWljOMdVRflSisVePXIwcc+mhjIFzyRma0Rlh/fWQTsjxrinGlSW+k0TFeeR1L15OmfG6TTqnxe4a9rtD+pfunlg35d5jfsuwnNsRZJq9HurJKS/ijy2RZjwZ+KwCH77O1xvJm8OofY/SrKz7ZgJoMbWfr1DcyNDO8KyJviErrBDIdVNbhdbQAc+NztON5omKePEW17MTlt78JasNFKg1lek2A9RcXKLnIU/fH4+DvfvD0sc7YIesqqlmSdl9
 JavaUoxh
 GUKU7nTLa4xEj29/spKKPqPDEnewHOopt/p4uUQBu6FVkKL3/m3NjHu2gqPhvKOtKFHW9u+7AilcsngWnMtgDeX+RoNpWRTvQPvpO84ogKUsjG3Uhr3ZuYTk7ZsAd3Wa1FYtTwW9BKUMDItczlMueTacMca60ts3//eeuzwTkkxEvB5xv06iTOy2RD6RqncAC0OGhmKy9+sVDuqZyKEbNygx5qmWQuF/pWo5IHfL/LQyvhCPugTpY6veZnpVcRwtNeju+VTpTkDOvsqQhoMP5gTU534AKjsDZPDQy7/cwuGj1pCiWgLUWs/J8f7bDgYx0TU834OC94E4PyiPj5AI8KXWY9VvJp8xbQyNlZPzenNCzN4svY0phm1F0KmZZhEZAFYvdYdZgluVyB3gQMdqFLefTb5KQgY+UP6N9U0XpYwhuMXiB9mEc99osepu1CaYjk+E4MXhxxYCbSfuKyEOn2zsrKx08baULBQ66DK3rsdZq+DQ/F54B7VacdsFS7159HXtNUXObMf895vtVb2Z+pcwD6HbzCjJLaUOulzpnToGXiq5x0UmlmV4jW10M2FQra20UbDQMjH90K1KVJ2or4gSeWV+VFTmdFI70sJEBZEqCmcuR9guT2ZgvaoPFCjKORgScqFbYfTZ8KM4h/Ota8+xW3rSiuhXSvsLzGcnK0aIPb+3OEzOBlfpufMZcJinGQOGrvMyovSVlp4KjEWTkUe2qchTIuvHoS3cPX8jwVMmLmhIgLMrbFWinr35VQFiXIYxgACII/5mCMjFNcumoUd2UCnnJ0S2KDiZkNUpJl6QgqacEIL9YFOqtLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 11:30:52PM +0900, Jeongjun Park wrote:
>
> Based on my testing, I found that the WARNING starts from commit
> d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs"),
> which is right after commit 2cf442d74216 ("mm/mremap: clean up mlock
> populate behavior") in Lorenzo's mremap-related patch series.

OK let me take a look.

Thanks, Lorenzo

