Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3496DD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 12:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A38D6B0005; Sun, 18 Jan 2026 07:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7515A6B0089; Sun, 18 Jan 2026 07:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608AC6B008A; Sun, 18 Jan 2026 07:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47AFE6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:07:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8B6B1A0529
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:07:09 +0000 (UTC)
X-FDA: 84344958978.10.844607B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6916E140002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:07:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WM67TLIb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZiPBeC9A;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768738026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAVhcWiOPxZQqsOlatKz9lIjM+vPHbyKTVkZrNbyeTQ=;
	b=1JYBpQLx+Y2uMvH806XfoSW+emKeHHzZF2FM4KwXPoIxfuF8QwJDnVWJ6iuEPayhOARAtx
	Qvy1ofHYTungRzkGmd0Txqi8DNJ+JzCP62FfCIXqz92xEdJoUFvrxHLBXDC6+F+XVLwjXM
	H9dNc3eBoeg7bGSOSm3xEmxVEnrpzZA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WM67TLIb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZiPBeC9A;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768738026; a=rsa-sha256;
	cv=pass;
	b=p2RMpXmWJfPXKTHZbUaQzVL8m/L8K1iU0cfTNhGB0HF/a2c+Y7E5R9UCY76i6jJ/Ta/P1e
	ZmRQg7dwOsGQb7fGMjJhvaKKPn8Kvy9CJ+jsdOZNj7BBU4FCYE82gstuwMjKYDMJ+HKHk5
	/45pSn/GuSbYGqW0tuhJBoK7VqrzkDY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IA0de02859631;
	Sun, 18 Jan 2026 12:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AAVhcWiOPxZQqsOlat
	Kz9lIjM+vPHbyKTVkZrNbyeTQ=; b=WM67TLIbjB1buQKADMskxNIbwPouIGajly
	lTw3ztPWN4fdUpP0zJbz2hOMLsfQH3xf1hhmHr0k1TE7OMWgW+AxaZF8oB6Y1MME
	dvc8Ayoc2D+pZleoyGHWKmksIc8n15xmegms01lh9ZjCchG2LkUiapcYSsXRXtMY
	sfbCwPIbatGle3c67bi6r78ZXieqJkLKMBdoU7SM6nfBi6yirlvGITzOXvnqnCxs
	JcUV9x1lBw3MU8oRS/U8/561n9Mpwxw4kiiP/hu6IC/Q53v7aETolgg49xylt2ty
	AaHNUAZVa9+Jnz5vhSHd3t0Be4FL3kT6GcJgPNDSBiUCKS7uHNbQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vs9yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 12:06:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60I6fMaO038750;
	Sun, 18 Jan 2026 12:06:52 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010021.outbound.protection.outlook.com [40.93.198.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v7chw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 12:06:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpKKdq1kR3m++kxMsqKZoAOh3DkkMjap31e/tz6/7E/GFY92WSASNED4CMf1tOrWEFgJO+w7XGzW9ddnvNIQgdTZs/E53tqxptSkO4SgTSdQ1HtkulWNrMEZXyBybgt/xCckPxR7DF+RMNmT4YuZQEcj+yf4FlFUttgshf5bOHyN55zU97m0nBtTphZZT6f8BIekiIxgalMdrylDm1ozu21w4rtHFyovvUcfpuoVxbjONprondbf5sV7lPhNQpJ/wncXFl9L0Nkrl7cMv5ygxzLvJ2lYdqB382EtwWn+mQXnT1Wf7aRGXhMhF/q1IwCAOhmQEMK66Oj0PL1b1trAEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAVhcWiOPxZQqsOlatKz9lIjM+vPHbyKTVkZrNbyeTQ=;
 b=OYbGl2lTEvER9OUZ73I6EH7RpX9XocKF1GyFiCtiPwfdKq/J56OqxIjCOBBp1kDslfkjcr2IkQNuXB8vPAtzQ6emrRxIBYvmfVghuwtPxJdxDG8kfTjnQ4v7g1fwGrjxC9iEXuhQQrhX7Xu09xun6ZvJGfw3bjXz18iphSYjWeYNorlNO+ILUGeo1yAC+qVRvZ89Tr87ZveEbxAAHSwk0qJPZxXtsNFJaxn4OcFRIq5ssFxZo2/WSob34ZpRqaNnmFpUPq0I/nAjR7Z+MLw1p6WDY1h860xWFuah/g4kT8rmqPg+6jmRvYd9l2NK9HGzMGkcWmDlfR1AAP+P7Qnu6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAVhcWiOPxZQqsOlatKz9lIjM+vPHbyKTVkZrNbyeTQ=;
 b=ZiPBeC9AQlWZOze288MWgbmo6HcG3gxsi3rVzacYSKAVIWoavcLBlKyviHszoyHpsAx7/xuGPHYmHCqDWRq+E5AitDcSj5wHpTzSv7tGkwA10X/qGoualn77K8zNK/BY/3GAicit6PKqLrRAQwPlEU79X4mnoLrKlEm+8s2cbIQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BN0PR10MB4855.namprd10.prod.outlook.com (2603:10b6:408:122::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Sun, 18 Jan
 2026 12:06:49 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 12:06:49 +0000
Date: Sun, 18 Jan 2026 12:06:53 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/rmap: fix unlink_anon_vmas() handling of error case
 from anon_vma_fork
Message-ID: <0c632df4-7128-405a-bf92-083a335831f0@lucifer.local>
References: <20260118105817.1270617-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118105817.1270617-1-kartikey406@gmail.com>
X-ClientProxiedBy: LO4P123CA0462.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BN0PR10MB4855:EE_
X-MS-Office365-Filtering-Correlation-Id: cb4337ad-9076-426d-9510-08de568a0f33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KIte49MhucxPADLS6E60U+Pr+xVYyDiTaFeZxoL8Lm4QErO4jUPErv3Fgjca?=
 =?us-ascii?Q?MYf04qVJV22X5sT9/MIV3FMntHX6roVL6xPfnF2LiKYIJ8dVs6rO1SM9oOJI?=
 =?us-ascii?Q?/N/B52Wdy8hItxr0z/hKXPlZhX4DNKjvia38TAwvNKM9RL4gN019vkSz+Xy2?=
 =?us-ascii?Q?vcHjv+VcDRV4Bl9uYMOMqlAuFNArqjnFCe2Q1hQ3Dr3SrI9K87nTRtzfVc6b?=
 =?us-ascii?Q?+8DPapVG92V17Pd1qh5gYYgDvxWQmloWhurPzPN93XphCYee7t6S0CbnvQyL?=
 =?us-ascii?Q?32niy3KRNq1stQfxrOF2+aqgCjkvwhSSew6L4UzkbTKvfUuKKMicEZPj+fOH?=
 =?us-ascii?Q?cy/xSzJxwERc5nGKN2cXGHetJL6QL6T+d+rTU601hHCn/USdoSiWYIzjV/Px?=
 =?us-ascii?Q?aD2WvrtaL0VYV64h7+ynrhqcIXCrQuBzW6lKq5xguwPkg3DuJHf5h41wy/7C?=
 =?us-ascii?Q?bv/TWvwvI9XkNZkU8LNa3lLHaEbOV0+EeRhL4CyUXy97wcfPZNqCpvhj5k7y?=
 =?us-ascii?Q?0x4qJ04bvFTX7c8NHOQDCSUuooLqXxGDV3fFzyAqXhYS6quoPxTF/SHtv2HH?=
 =?us-ascii?Q?gkQIKJfoaNbwXpjTCy2aXomk4XPeEONGHC4YTm0XG7jxEmx3/5yaDpcvcECO?=
 =?us-ascii?Q?PHydPyGTfZYuA7jlG5WyKgGMBJVZXUxj/dw7Jfmh5102C5wG/pHbQfbC4Oa3?=
 =?us-ascii?Q?CDvL9ESO+QPI/MNrwrizRkbE/dZJtKfm6xuODaMpH0kUITNgZxKj3H0EjlMt?=
 =?us-ascii?Q?5vRznbcoVP9s71+79RAgf04EL608c7xP4rSQYWNClXFQYQE1zKffAhoB2Kz/?=
 =?us-ascii?Q?Bpn8gqGbpQkBbR3ptPkh9Tobv+DKwPV0ZuLbhkne0lW59T7SHa3biMgd/QI3?=
 =?us-ascii?Q?h8BdT4GhNKg+xd/EepyUDf0bjWVsuYjFZVzbDIuGMli78tI4dG6kR5xCVxEp?=
 =?us-ascii?Q?WfrclGpcqjtiaihD1+JVp1ME05A8m1VzkPy8UlkJ+qhZUhiskFqfud5dNTkL?=
 =?us-ascii?Q?3oXLQoUxG85u1HzS7IjsLsevTefH5TyFCSQNddEYGVkZ1djGlNOWToP+G6ed?=
 =?us-ascii?Q?JZ4JcNHzBtL1vBgyshmamN/cP35bnkJAS2AyE5PHUqB7hwJl3obRk8+3z5im?=
 =?us-ascii?Q?r7fgXkjqVJ2mvXBQA6wlWToJ8zLH8mg9jBpZTr/VhaylaWkCffR/tuL2lDWg?=
 =?us-ascii?Q?t9iEK4ivfHaBH2A21jrevwag08/RYlWV+B9DYiyXUFstgtZZnjwYtaKTtqqY?=
 =?us-ascii?Q?FHyY0IU8lvKK8t1U+jS5kFXTV4tU2vmkVB6/oNk6+ahLH2wbOSTYN8R9bJ5x?=
 =?us-ascii?Q?aVRSrGEXXx316L7WkOJT+79V3f3oAX3ry7a54NUG8m6fo+GCi7oHzYfK9mJX?=
 =?us-ascii?Q?fIo5wHGvwL/eTSCqIRzCiEwr1yX0copvDqqXlaz/2jeIGgbCAmkI7SlNRl2P?=
 =?us-ascii?Q?RiSGBq0/oPUhemIJ+TOYhdJbwv5Bngo2ABFG3JZyf8NPKEl7z9edspaFeQfH?=
 =?us-ascii?Q?PWlBIbz5D/LZMnmrvbkwD8ybndN9/NkaKpxk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2qMzq+9Dm9UiyVKfA9m8ULbEDMhxYBdRDZNtCREYQb1uAnmA5VcYnbfvntUk?=
 =?us-ascii?Q?42WELIQRGef4SI+hem+0cX7skEIJDGE+Q2sA/pxe8Or2GnBWiD5XO6D7L2gK?=
 =?us-ascii?Q?q6P4T588SJ/Fpa/G+4s+27kKCkhKK1ZhQ22bY8313qKRuOcRlPwu9xkOppLn?=
 =?us-ascii?Q?45LDFfgeRXE2wGnhz20n49kQNDF5MUpcpUVAKMUUtpTPty26iY+7yRrF1w5A?=
 =?us-ascii?Q?z829h+sMIDrCNVAdwboLVrlSIR1f5ZMCY/yH9r2wmW5kykvagmO1YXHfh9J5?=
 =?us-ascii?Q?HO7KjmtAz6jNPeVrQ2hvWB2uuho+rL3aj6hF4TI7caMJGT3OitxiRD+1Z1rN?=
 =?us-ascii?Q?83/H/AM08QqrS9XJ15sTFiI1yjj5+vgCHXyy/BVKK6WxLe5+XwYP9aBZWqMH?=
 =?us-ascii?Q?KaHDwlXDCibRQoMtel3FSe/Ntsr0JFAKCqxyJbN9knpt5nkCtdf8hYAyg8v1?=
 =?us-ascii?Q?IKtv9fxAgrnlHuBR5olqb2igxIflbBjKjJLu/y3vk6L1QuTYRIx9bNF/qkvD?=
 =?us-ascii?Q?3KvSvQ2HJbLUxcxYz3rRELjKki4r7PEUGTwa5Uf6eINJmEtn0xWnmps5zyvw?=
 =?us-ascii?Q?NAT2KfwmGqAlWPrS/kudXE9t8+WGrjIKzgvpnj7LWd1SX6ZKHyeWX38wUjO7?=
 =?us-ascii?Q?ECy3JdlXj5Zk1bIG5ItiZbA+d3i4I/NkO0NvqDVICw1DjI1LEotBAcI6X6Wm?=
 =?us-ascii?Q?EMpmXRbjAK3kE9KmY0jJ289s/rdOD6HBKgW9s888SZkM6cnFZLccFbXa96bN?=
 =?us-ascii?Q?enpQItPaTaj6rUPXirW1zALIsjv51UUzm5cDhtnZAiD+3jMBYZRFz5IGD3Gk?=
 =?us-ascii?Q?z71uP4T8zp8Y6/sckzzuGTbBYW42uNVgt6ENvPL63y4ytF3rzhd7mbvJFmAK?=
 =?us-ascii?Q?982rNu3nOVVTCS0dPBq8VSGl8EfqiJWrtwSXmPlP3XVuy+U9dtjqwxBJpD4W?=
 =?us-ascii?Q?aZ5dre6yOT/6cckg6hLdn8icjUpvOtL5+XvMVB0OUkEtV0+M6Q4LSITtuWIk?=
 =?us-ascii?Q?t1J9Z+IbCLztpQpVofEEEAkIKtC+x/3qEYUg49NcJBNssEIiFXkVPKewH2D2?=
 =?us-ascii?Q?DNo9YI55YsyrtBAsdTc4C0LQW1l9wgdgBnInR2MLntaK14IdLTe52DS70/M2?=
 =?us-ascii?Q?Z1ZnJ4NIhB059hVKEgmhpuno7jy1TzietWkQkeBghA7w/StK7xi5LWSnBXbR?=
 =?us-ascii?Q?60HSZl/WVZHjxsASsTHzIpdY8ivFKaJ/swZlXDwM/tCXDVJ2JfL6Fda0cn7M?=
 =?us-ascii?Q?zo2av4nix4jI3SyLqNSZAiOxzgeCavyExxB1QAv6VK9Upt8ws2/1dDp6/htS?=
 =?us-ascii?Q?Dz3ZjG4hcbczdzOXHs7lEC7dV5bOlowDWA1sjCH8nswX6OtA5QcPyAiQqtdY?=
 =?us-ascii?Q?CNsqsgp6P2xgK+UMCuc4V8/Mq1XjP+qB0kZfJoY1mDBqqUYFxwi7629BDTgf?=
 =?us-ascii?Q?euLyf8IdBd5JXjd9KiUOW3iQbZVEERvjo2h9zKiU90cawJmY2hJwr7kwbIs6?=
 =?us-ascii?Q?YF5V720dFD54uSIefO0n3ho3DffMKTUT7xCXl8IcLTRlug+Tjx+ZFs+JAHpL?=
 =?us-ascii?Q?K3SHogUQX/SsCl6ewBRHNLnsD9Z0cxrz86LkVF8EZ9KrQNJ2owDSpYIfXlK3?=
 =?us-ascii?Q?HnC8oRj7MQJZTuvgFDxJsLo0cJ1pJfSV4urWuXjBXAgmXJDe4IAZmekaweLO?=
 =?us-ascii?Q?WFcLi6y+KABBeuxlJC/e/L/2n76FfuH7d/3W17Ja+HkTzR01AymccUmIqPRL?=
 =?us-ascii?Q?Gl4p4Ekj/GFUsvGo4o2kMxlNoZiZhYs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1ZJyydWWIDaLgoJFqQfbcn8FPe0Lz6d8Oj6N+5aRqmSFghDzu03oQm1NiXnMsT5QGoC/URTHlssRPgFbvpOb8SS3n0ACd2F/2mqCptN+ID4JVIIa+MRZcE/Z7wP2qfuArKMF35Qg/+NA3uE7W4x+D2f6oVyXdVmenSCGgSUBZIpMzaDbaplG2jsA2g+ult5PJIpW8ar5KIQK/bfOxZBjBabp1k2nqWis+um8Ow148VQMH587WoOv9dTecXpnP4vdlonA5GsaGBc8KPT0vvvb12He3hNBDaUT9SFqsB+w96suYljriN/7jkE0rtz/zauZlVTBzqzugnrxaEre2ic2lO/bFYamwhEkV0t4EmwhzOX94y0Up+ehvBVIsH7JjXtIb2SSu43mi7pDbXclUXx0jyv1Cg9uYtl/pVs2MsDyI2u45iNSSjX3NGKdU+1GiIWrf7STTPvzJHOfapEcT3+RTBjiK33B+zKlnhaFgfcgXzItsKk+GqBfEYeOZVe0nxout9MFzFBV6NdrwDRPGacNSd8eKqX8zECjOC9cy89A0JaandfaPWtoXPjow6xexhZgiDeMjBT+r13dgR+FKJxxJtv3SzUTJHtQO0MJrvmbQuM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4337ad-9076-426d-9510-08de568a0f33
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 12:06:49.4427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySLZktLfDnWqIrwcOlbBIFk5LfVOlpguoJnZFp7k8WOo/3Dd8LyVwRu6hXu5zEIEWLfcgrZ38c1wwuwwxYoW77JWtMmC4TF2SXg0qprm6W8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4855
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180106
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=696cccde b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=pGLkceISAAAA:8 a=GNQN5rfjZXQ82vXdiyYA:9
 a=CjuIK1q_8ugA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: l7F_0K1M2HlehLaHJdj78w1vFiSEyi0U
X-Proofpoint-ORIG-GUID: l7F_0K1M2HlehLaHJdj78w1vFiSEyi0U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEwNiBTYWx0ZWRfX/2WNt3IpsxIB
 aFuanSs6c2+tgCST31RV0dnDvkgn+QIuifMvvblp+mVEuowRgNZ2cXJWnRsTPkxcOUjL6LMj2ye
 +vmVYgaNAsEOrg+zgnZDKqTbdUArj9L43zrTNXDtffql76jBmpOzr3qld6C0wbi7Zalu2AmmA7N
 f8bCcmm6h9LdxutB7IrTqNfYWysmURUgNRnqkoCCSNjLdV3M3Cwq5GpYfIhzsNr/9l5pBRvzk0C
 oNgfVdS6DKIPO3QvoTUaKA5Zb1b8UXHYcEO6ZhxGn/0BQb4/P5JnCAaCXnTIaEauKrTpa3tz5+l
 SgAw77b6ZrFFaJXRp6ouQAarVrSMFiJEKKpovpZuJ2u2B7eBaPZM4rGUvFFp32jb8oyb5QI9jQy
 1kA/XBEgTQ5msjW/kma8SGJCncdWL2TbUNSlzTKUKvqMrnqbPlI2in6Hj+ARugUKJM578Xp7sZ1
 A0oiDVKdfnCctZFO1Zw==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6916E140002
X-Stat-Signature: fatbdhfm6p96nyka8aue441a3h6qkjpa
X-HE-Tag: 1768738026-130921
X-HE-Meta: U2FsdGVkX19lp2EuhDYcL2W+kXp9QGqxU9igBvzxVtFNbBZ0b/Z2OtPoFmqrWpkaYFmFaqRZjdCJt7H8KMd2Eb6lqeOkIGflU0zqAkjR5qFJaT63qb8ZFAfHxDgXrAYLIh/L5o6PaT7k/t61rR62R3i/rW9MuGdmG09XdWwuZk6Zdg3rXLBEgz+dirwxynd7I6c3WFELWNUB+PsT5ziwyJFLxXDizF71npQKVhHtK7jAz/fQyeg/fRfVk5RT16XDYaXG1NWAt8U+vyxqvKhSOKGu1w6bc8vdJjaqA1+3fBDAbYvwV5bvCZZMIEBKUixBgFO7Lb+E+Bmq/1ZKgP38OMGIJbk/4p03+eby4/vUjUU5kfYLxEU2tY6HG3eAf0XOrtHefAa6dNRndBsqUvowiDIwG04qnonvGYQsKs4TLmWQ4tMK4SPyhdQVa4qDhlH5uNUSgxkUQG67wOuaMIr6lqqWLmssmPuapj28xoG58fihAGQm/E4CJEvHKapweJLv7iSBLqzbgsniu+3Z1Ek5VPKITgrtYHH4No7t0HD5ZV6hwZ90vDeqba5di4CgwMlySEovZby0dykEC+ldJkxBv7XZiJKsKhJjZh1mC5kV1D6MiNNsLhf2/tIjS0SFY8pK3Wk6Peaqm7yyRcZnB6t5fBMVrGvXvkyWfq3nT5iWZIa1cmNOGT2f79ge3OBPSVhMd0gdDzgb6Eita39ifnA5wxaZw2rklc+rwSRMYSdTeTlL3tCg+XEXfeRNXyducqrJSmOEfL/Ox7bNL7ILxJ71ZcCNikBT2Vv34iUwdEg7IfC+ni3hncwikqFnqah+IeiVC1tzdSBpNTdPBWfkJEybzrAtR5V4GmIbKlE6FRsJduFFJ3PTAUp+0LLdEeS8LvCrvut/oA0q6r5+4ogyN48c9LfTEL7UwWACASQ7DUL93dshZDhuzfUPS+I3p0UVmEASgf3HfnFiMwCSQqDNPap
 YT//M2hU
 MIo1aEz+GqF6iGv2Zer5NVp3wNpPclaTG6B7WYkJk1pkV2hodNPtNeR/Lnbcf4yceWj5UtrMTs3wxQWfpyBuNIUGFYwNtZ/jF3dFHqNAkKj0F1fTjhjrK5NT0xxxtvHJ5YMBfb96KMSm1K1QoyUOqQAl1wymxnpkTibprNGM3q+EyvP0EC5IoaKJktAnuhEVoUNtrNsYbPclootuin/QIcBQqlWvXroNhChOiuSs9cd+qlyiQbC86VnG7tL/RIevcTNOJYiT75lm9BZ7MBo/4hPlkKXGxwwoevg2vu9/fM1/oRiJLKm1KI229b4Ud1m14ETnx/8Qi7IX/UZjFBYbs8DDE+XKqnUO2ltPKs+SizhUTv20bKNFm5+CC4TJK/elpF1qsKljQ7D2nGziIK9hAUUsrIr8M8gU93gXSXKje+EFXo1bCGm5CFVLl2chADgryLhbHObtt55idl2Of4ox6bjmoCVw88PAqUoVTj9CCFH5klYn7z4jZXZNflvuY1PY0KpEgaKQT83FJmEtLilR9FnZsk+jv2ytec4Iisl+xhmQOPApc0g6b7IsKlPpZ2kk1BQJwTtUk6u6ki9e32Juj1UcF2zoncUxKHdmHf5zvnJmhgPrVwqNqlqTUzVgl+8JQ0EjUQittWfm99NJiB7+k4OXnGM6tulHloqlQUL9RJNGMKH94s5yzxSa9fLX7xitVbrGGOvImGsI+gRtEc+0IYPMDpVaF2fr37q8WWefv76CCyIFeAjQeNXgYgwXbR1ZFND5PdKtzh8NiufrH0H7L8c7NMgWXU8ovNHGzW4BaHfbTme59pGNL1yCB6VmiYlNSLgcQQ/jNJt+Zq2a2kuH9G6vvajPYiFvViVh/iMlI1z816dlf9ySQ46113w8xsK6i2UttRXXhV70b1I9o70sS2z9zgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 04:28:17PM +0530, Deepanshu Kartikey wrote:
> When anon_vma_fork() encounters a memory allocation failure after
> anon_vma_clone() has succeeded, unlink_anon_vmas() is called with
> vma->anon_vma being NULL but the anon_vma_chain populated with entries
> that are present in the anon_vma interval trees.
>
> This happens in the following sequence:
> 1. anon_vma_clone() succeeds, populating vma->anon_vma_chain and
>    inserting entries into interval trees
> 2. maybe_reuse_anon_vma() does not set vma->anon_vma because reuse
>    conditions are not met (common case for active processes)
> 3. anon_vma_alloc() or anon_vma_chain_alloc() fails due to memory
>    pressure
> 4. Error path invokes unlink_anon_vmas() with vma->anon_vma == NULL
>
> The existing code triggered VM_WARN_ON_ONCE and returned without
> performing cleanup, leaving entries in interval trees and causing
> memory leaks.
>
> Fix this by detecting the condition and properly cleaning up:
> - Iterate through the populated chain
> - Lock each anon_vma
> - Remove entries from interval trees
> - Unlock and free chain entries
>
> This prevents both the warning and the resource leaks.

BTW this reads rather like AI generated it, can you indicate whether that
was the case or not? :) Thanks.

We generally require acknowledgment of substantial AI-assistance in
submission.

Cheers, Lorenzo

>
> Reported-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c27fa543e10a45d4e149
> Tested-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  mm/rmap.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f13480cb9f2e..acc8df6ad4a7 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -477,7 +477,31 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>
>  	/* Unfaulted is a no-op. */
>  	if (!active_anon_vma) {
> -		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
> +		/*
> +		 * Handle anon_vma_fork() error path where anon_vma_clone()
> +		 * succeeded and populated the chain (with entries in interval
> +		 * trees), but maybe_reuse_anon_vma() didn't set vma->anon_vma
> +		 * because reuse conditions weren't met, and a later allocation
> +		 * failed before we could allocate and assign a new anon_vma.
> +		 *
> +		 * We must properly remove entries from interval trees before
> +		 * freeing to avoid leaving dangling pointers.
> +		 */
> +		if (!list_empty(&vma->anon_vma_chain)) {
> +			struct anon_vma_chain *avc, *next;
> +
> +			list_for_each_entry_safe(avc, next, &vma->anon_vma_chain,
> +						same_vma) {
> +				struct anon_vma *anon_vma = avc->anon_vma;
> +
> +				anon_vma_lock_write(anon_vma);
> +				anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
> +				anon_vma_unlock_write(anon_vma);
> +				list_del(&avc->same_vma);
> +				anon_vma_chain_free(avc);
> +			}
> +		}
> +
>  		return;
>  	}
>
> --
> 2.43.0
>

