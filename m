Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23381D31A2B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EDC86B008C; Wed, 14 Jan 2026 04:04:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C61F6B0095; Wed, 14 Jan 2026 04:04:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D486B0096; Wed, 14 Jan 2026 04:04:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 651DE6B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:04:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4E11140430
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:04:16 +0000 (UTC)
X-FDA: 84329982912.11.F2A391E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7CCB6140004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:04:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SJajls9t;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="cfPu35/Z";
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768381453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ksBGD2prRwe85UCfOTgW6cHu7s8ZSYB8dR1vsfiPBQ=;
	b=kzxv73uBn5XA03A3k2LzM66Vk7DQbDnbQHjd+kIzKywLNb43xkkiUOz8qlGJnD1tJOuHEB
	f2uolyd4SVI6qFJQ22Gr6dnMsQkrNYfFCdUfNHl70I7lzHkXjwyrK8DuuTYgyGX0SB8atR
	puOmR5vLBbVDmQ7feB99IsRD6UlhOSk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SJajls9t;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="cfPu35/Z";
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768381453; a=rsa-sha256;
	cv=pass;
	b=GTOnWRr8xGaxWohbPFYzRZG1+xPNCGuHFuS2X092hURWJYlQOflbUbVp6joENBsJbeF54O
	iQe91lmhHfODx+MO/+xkHU9qOtSZPXFq7N9fXMtJvEXOpH82MBIJ0qmo3fBcKPIWtx1TFF
	3MitHpd1tmCAcW0slFckOlMQmpUmZr8=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E6fOjE2395990;
	Wed, 14 Jan 2026 09:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0ksBGD2prRwe85UCfO
	TgW6cHu7s8ZSYB8dR1vsfiPBQ=; b=SJajls9tvYjoYrsXvRCWGEQEItL+EtdFA8
	R5fCW9uZTw0Df8uYva02l5sDzhEQpljzQkEUq1qeulzD7K9JUPe8s/MgpcaWXR7f
	e1pPldd/eBt6T4XdnRPf/YtH025jG6ZKlnnOmfMEBsTFT8XnNSm0M9ZTABAfoBxY
	67s3e8BbfMpsqgAexPq6mCYEW2RWkFDzETEuP/VnMtcW8iNUv20sChU+JxQQkWrU
	0CeKQ2Q56xiPUeda2WhwaGA+1mbXj462tiP1bBOEb42lY4n0qrfVmNBcGd5g9gdD
	mJGEndzRuqYdHrnRjM1ob+hzpWuAwoPopd5raVp3iBzaXlwOXXRw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq54ucv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 09:04:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60E8u5MF032801;
	Wed, 14 Jan 2026 09:04:07 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010003.outbound.protection.outlook.com [52.101.85.3])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd79t87f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 09:04:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2+AF/lcnS9KL32k1KQbkK/fqFvAEiblCGri2wncn2Xc6T7J8WdDDBTOPpyxHWZ2WXjYufN2kzG23TAkjnWmA0WpnjbGE0zgumH27JKlQ2WxNyZzjqxLg6HsJjG46GV4bm3ux7TdssBzKw8Lnj3LvqIp8mNcoqbWrq/G0QRs0mONRtg+J5WyKJ3XeMGyyvdLqrVpC3tYw56FphmI0ONzLoug99J5t6wrVXC4h/pGrPUf9/MQy3swOWT9e+ILr731O1llB1Vm+6FvQehmX2riOxz54ANL/Cf4wY7PIa2PxtHEeT0Mg1p18tPspEJcz5Uflg/xUIqIkTtiJH+nxivL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ksBGD2prRwe85UCfOTgW6cHu7s8ZSYB8dR1vsfiPBQ=;
 b=R+nh29e4w+yhQw8DvKe5jhEL29SB46kIgQHWSIovNtWxBslU5qQ3NoLmenAumf7FbMNwbVNoffw77cHDMTkNUY7/2kM9UA7tbNxZ1CwRQZzPUJJpEOi7Og8IrBvG6WjTQXQCTcbVp0mu0+aksk9cJ/DCwNKkCeByASDh1gECp7JHN8Ncy6/mSHpVlcwrBA+APZ6eVidKO7xXRKHFi6bPLsfGs0Fvvz2C0qzgZsPhHqenLWc6ocksWpllgw9uO4ZbMbQzT/Wcq7uePQ6lhNCzg+Y3uzAGJ6glNesjgzP6tGc6SmVZHabe7aVs0pQXUd2qa11p10fep5uEqjpBCLIv7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ksBGD2prRwe85UCfOTgW6cHu7s8ZSYB8dR1vsfiPBQ=;
 b=cfPu35/ZknPMXP8USekz++gcgbbyG6VXWFeBjPAoKZYgxCamtRYXwMJe3z4cQi//F2j6sYaKf+iwD5L8mTQlddKqr6b7Ny/ktVcSEmzcCi886ATOmf7gXsmdxArRt3o+cUvWKMiOo+/7xt8wbahmhPLWjQf6BvaIEp2QZUs6vp0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BLAPR10MB4899.namprd10.prod.outlook.com (2603:10b6:208:323::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 09:04:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 09:04:00 +0000
Date: Wed, 14 Jan 2026 09:04:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: wang.yaxin@zte.com.cn
Cc: akpm@linux-foundation.org, liam.howlett@oracle.com, david@kernel.org,
        vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, xu.xin16@zte.com.cn,
        yang.yang29@zte.com.cn, fan.yu9@zte.com.cn, he.peilin@zte.com.cn,
        tu.qiang35@zte.com.cn, qiu.yutan@zte.com.cn, jiang.kun2@zte.com.cn,
        lu.zhongjun@zte.com.cn
Subject: Re: [PATCH linux-next] mm/madvise: prefer VMA lock for MADV_REMOVE
Message-ID: <29af26de-7339-4dda-a3ee-00eb19993493@lucifer.local>
References: <202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601141124178748cM66DJW2fzNea7Uym1mG@zte.com.cn>
X-ClientProxiedBy: LO4P123CA0144.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BLAPR10MB4899:EE_
X-MS-Office365-Filtering-Correlation-Id: 14e876c5-048a-4cbe-3773-08de534bdb2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qaDTr4uIiRMmLc09HDVokwoAfInccYVFBFECqMj8pa/ipZRRvYl6wkhQKX/S?=
 =?us-ascii?Q?S0p6IyVqbD3ZFgQpgXZc8AIdxDGqykdM9raVhYOdK8sjiGlhovKGIPGng9cj?=
 =?us-ascii?Q?mUDfUfKK5kz6sKhR5yi+hXaDNObBi0oRKEOAzXrlL8aRLnwVcejtmNAJMJON?=
 =?us-ascii?Q?QVf7YLTzJbYJ9f3AlDPw7Mo6j1Z1xZUh1yDxESJ5p6SsKiuot7EVcyOouWZM?=
 =?us-ascii?Q?4YzizfXrIZ+qgvsOE5F5NlhhV8+9mb77PjsLq8wIijoPWtkT1b7Tc5TWHEDo?=
 =?us-ascii?Q?/jKy9VjJO2xO1CVU6ycvJjL48D0fx1cUt9VHLbyM13WA+W4esglxFgHckh6m?=
 =?us-ascii?Q?4Murm2KK3Z24Hi3IMuEuELrUD7eIREKgNjbUU6Ek3p8bA415B0qWZSpkLzVB?=
 =?us-ascii?Q?rzcUSZhg9WBXAOJER2H65+lO23UE5q4VNlGJnjf3rG3AWIu04kXLZnDgoNY5?=
 =?us-ascii?Q?gkF+BXRvnoj2L8OdkIis69/8F4fs4Feot+OSPvAn5BPoabEpHnAHcnnveChI?=
 =?us-ascii?Q?Y6mpml0AZhqO1VmKs2azzcO8QujwPBW5MoqZBNuDAPmRA4oR6jIW976JnUMO?=
 =?us-ascii?Q?wexVXQ+2J293vo1bEpyWdmd+3dE/c1ioWiDaEFiqCYxkyB0dCaRWAqeExLRp?=
 =?us-ascii?Q?YJeghhFji1RHJWZ0y3zYc39I06d2SSUgQpbcG87GkZjb1fypMSVZMwm+exnn?=
 =?us-ascii?Q?Ew3gPWAWUuBdkURcg4Vpu3LUeqhQDk/hs/xJrJ4XJX4ondOlLCxmk+l14/KT?=
 =?us-ascii?Q?p/JT5reiBTN3HLqES1Uy+BELIJhodvOXO5Rs32oFAe8MzbgCkiCrBWx04Uc4?=
 =?us-ascii?Q?zkHw6V4biz3f2RYcLaYHWz/G3mmK1Bue9w2pxe8845fMJV4CgIG4dXwjkgc+?=
 =?us-ascii?Q?lx+JM53vrhzoPNP0L/phbetDCqstITr2xXu7tt+GyYOS4u3T8Wkd99iJl53R?=
 =?us-ascii?Q?gaqtd6v3Ko/uWkDphnF8OcP5LpoPCxbjlFfw0YrTHre4Us8pa3CrI911Z9Vj?=
 =?us-ascii?Q?IhHNVeq6wQVC/y92m1Yun74XItRLecq7JWwOvk//PY6tfqkN8HJfXaKd83Rv?=
 =?us-ascii?Q?LyN5G/QAhHcjF2JB1ORgZ/TPs1RKCjHzk4NtbE4Np+QO6VAd7KgfdEGDtNyd?=
 =?us-ascii?Q?KelBolG772M2S6OgmHSzYrz3W9tzKJtOo6sf+Uczb7UPCAY0YH6uJp2C6vuS?=
 =?us-ascii?Q?E4JxLH7n0RTHeVpgZzSC2pnoTpROwuB7+GrIx+JZ8HcXlw1Gihy46l4WIaMD?=
 =?us-ascii?Q?P00+Qr8BQWkPNJPfh70AtXODE5Pg7eUHkQYZbPxSr+EVaNiUtaRXN20bJ0df?=
 =?us-ascii?Q?/y2sjV10sk5Y6LF6thW+oobNsXu5OzFpBa6Scj7MmszlemWKoLDHsEPvjSB7?=
 =?us-ascii?Q?fi3e2jJErpcfwMNqjPd1tOtANEJGqoKuEGc1jGplYHh+JDEV/TJ3qToalwS5?=
 =?us-ascii?Q?qfzsn1vOThsUW5+/QgKU7Vhacq7kiRn+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4SB+QKPBbUIG/EJg5pDKsdf8+cba8sQkzYZnSX/MEfFKp8ZeAj2vcTQ6ScHN?=
 =?us-ascii?Q?m0ewG74dk7mZe9t9QjnK86LrQjqrelM5rTPYIUbJ2VSTrchbrsDWAO1F/88L?=
 =?us-ascii?Q?8In61j2s+YirCUbmMsmzsbFSpA6cw5M0Od3nYXlMHr4YoG7LRvhkha7TEllB?=
 =?us-ascii?Q?/2WGrDlYZUINOr8hQYDdPmjoGYR7V/c4qn+qWHPRIWAE2lZqVTPcBZJg4QxX?=
 =?us-ascii?Q?SpXI9deMdzlL6A1cUeKnssChfG8UGCLzBB2GPnOwjra4zBZt8dLO2ATavWDr?=
 =?us-ascii?Q?PtAOi085BL2xhG+JGKkBQgb5Gg9OzDNfCSNiBsPThXZJgJ08XiHLD1zfoCcZ?=
 =?us-ascii?Q?g1pHfZj52nmvz39RHk2cKdhtxEEoDZW7a7ME3E/KoSaQTef1cUtxZ49BpZc+?=
 =?us-ascii?Q?9QvR7OnEJzmNAKW4N6o+B7ECDX1t9JxzzxOlFeYzfvFNc2YtH7WPead5YULd?=
 =?us-ascii?Q?JzZFOgZGQQYqSLx5fq0Tjrr/4CeF/UsK5j5ZAqyaD985113AhMTRhWhG/NrX?=
 =?us-ascii?Q?iD65lps4+Y6bTLYvhNzPeYD+SVwS1CU+XudnN2OXOvFPl3tCYLaSMBGgxEgL?=
 =?us-ascii?Q?C4Lt9Q5ccB85cHkFwDUtC8dGTHb2w0pPaz7dFirtDbcXpwC0sU5LUOhV43df?=
 =?us-ascii?Q?4yBBNgSwlzg2PiqYE5o14QyHXacGAAXx9FT61DPr485VVJOMZFKwwsaVe5ot?=
 =?us-ascii?Q?VyC5e0ziXLhJXHV47nMBdM7fITLYuaN5of6i2XNZGLSuF0AMd24SBFApi6rY?=
 =?us-ascii?Q?tkzz6jZOzCiinTJuYMXnxSR+rN9yxDRm8YZiUGJdYbzfPA1sOoTHnzbtz/2E?=
 =?us-ascii?Q?uGm/56n9odX1+UcNtPdXDUNIXXd06OzYD/yu/W6XGS8q1mrUpy3c1dW2KsDM?=
 =?us-ascii?Q?IPI02skhwIN2II8ITjqawImJo9LIsuPkNTsIB1cacW9KSCj54NmlSCLZlm+Q?=
 =?us-ascii?Q?lJdQC5rux9lhN7k0w/R81MgWuOonm4vA7T8KWv1m/Qgsm/VafOA44tKw5+jP?=
 =?us-ascii?Q?2KynqIAzv9+gsyuJ6kW8WJknyzpwwkz0qqjG01a9DzASbQ2pD7UYBjR4Zo/C?=
 =?us-ascii?Q?pYULaOjiv9+Gj3M24JBZjL/XbWGB1TbrLaA3P0Kj974fjTpvQKTOKIapZUGD?=
 =?us-ascii?Q?qJ7RBbzPvZa1M6Ll4R1FiHkPigDdi6tjM+IKXueaOfVUTzi+mkZNokHoxnlt?=
 =?us-ascii?Q?nswPLcTD0eIqbmUe/KHDkQmQzgJHGfSAMgwDZwntGhEe2xXo+W8WkOK6CRl8?=
 =?us-ascii?Q?YZ4dMtJyLm7soL7fifb4k2ogewEnOIpzQfqtPuumWK1b3dfisR8EUM3/yEh4?=
 =?us-ascii?Q?EXEkfUe9MSSdAHqjm4POIbVHKij5Z6v7ex/Z/cG0EDoG1CiE7KdaW4ThJZA1?=
 =?us-ascii?Q?aEaUo9w4SHpE2QaY7LKM+eT5ZPOq4wqfXsrlU2csv0FZQzIvtpQi+MGjGpqM?=
 =?us-ascii?Q?PWqkf42phpIXX2VltnG6ix2YPi9PU1qGaL6RD8c+h0LJj6chxbb++kYNsBHo?=
 =?us-ascii?Q?L/vWDGQs6NUm68HdBuAT4ONm51Lx2Y0hNFtm18QpVEpJsZVNTurvFmfa9MFl?=
 =?us-ascii?Q?v3yL9paZ0f49GhiDWFMWu8RHBWZUlANMPySPLI+dvS6ZUTb4M4IQNXDpwpyw?=
 =?us-ascii?Q?sWBgTyPxa8YxbhGEeKoEJEUZltQwjl7P5zsVmzFRlPaUfyAW64O01L2A2/rj?=
 =?us-ascii?Q?i1U6KDNjdm3XVrK6pp3ewvIdlRIGw8TBVDIUSYdtzUv62XafvfZiuEEtvcec?=
 =?us-ascii?Q?7wf5xMA8isDsZZsKdADthc2DlDHhstY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LV/zU6vHh73qDOMBf5k+9aQUYhM+xntrQsiYjC/UiTAAeW4xM6Rh+i2mNEw1qjw4tKhPRF13xCxaeG4RFC4I3PDRVavUJPGOpiyQkxP8qszLpJNT31U4CM3xp9To4+f6BG0BdAHfk+hAZ1GUPbLIgr0OtADiUFwRHJk7GI0jHapminIkz+h+oDfsiJzPkjqzPydu0XVvTJS2dvSTSCu0QnvaT/3L7PIYR47lnjr638pAaeYSJCgI1xx5M9Cf8xbGp16QnDHu8/0FhSAafBO5szRpWeEblTK67Ao67ZrCaLFremCQm7XIeBIJNuU8TlVwGAWYeXFUhXFP8qZ+6ww8oN6U3BWkVzOhCaVaSXp0/jc2Ihu3CPooSuXBO1IUt0pO5pEvlaqQRb9vEw7oM1mHf14KG/LOGJmSgLEXSWunhsWmVGOcvbJ1pYqmpMghYIbc6lo1Miiwx2ZTO76RiU9a6PIVDQOKH1vzStuYnJWvmySIfVrFgRdqOOD/ifdG1lXHAfQnB9ItryshP6Z+BrGa/b9aGhmfjKdxw0SxlmhXDt6Pu/8JFnDj8jPP2g8wL8KWD8twRglVjrVZtDiHt6Soe6/YfMUqOXZsk2qjJOUC5ig=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e876c5-048a-4cbe-3773-08de534bdb2a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 09:03:59.9197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Trlzp8C6l7F741Pmm4wJz5kMsNt7ncDYb5odtmembmCKYq0Htzrmst8veKS40EZ6GzWJWAKlit2SJu5lIMWCnOofzxnuqv9+ah7hrCjkCcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4899
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_02,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140072
X-Proofpoint-ORIG-GUID: RMgzTUGtWO6WfimOG17tp3QJI6pIXRkA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA3MiBTYWx0ZWRfX1OvRnyJLOD0u
 rGcm0fI2PYt16frDXHLdTg+YiylzrU1e1DkSxXZxAE9tCAu9D+r5bWDo8hhOqPcSGFjPTtDwnOi
 5fSq7uIRLYhXvNoXnFx+pz0hsK6F9shfiEj7E2PeRncCpE9gmW3T6coGusJuhZ7aD9zhnJsP2av
 CIUs1zkWfHcBYJ9ncqfIRSJ86FyaJLFtdwi4O4hiTfcGuNh86SqtbGtaMmRb1RPWfWOF329QOrQ
 1rjshOxfgxdV8yGkUs1Qt0dRaxJ9goQXdzhZklVEuB+c0Fyk/GIEU8qZ1F8hhhEpNx4Ib1zVKNQ
 kHQ6i5MyhCw2O5ew+4vUF3xHYo9IXrnkYqMFr37nLx+n5SJ292woYaWyDfiQgJMND4F41+dkG3X
 gZCMoZJfegx+dSs3A6soOHxQuwjCq3yk5hQAYFt+SAoor+JdK9MJZIM2yjLQ3PTAy2MC81G4S4Z
 HAe7QdHnUH4S9ZTxc5A==
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=69675c08 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1RTuLK3dAAAA:8 a=hPM2QORjzOoQ7LCak80A:9 a=CjuIK1q_8ugA:10
 a=kRpfLKi8w9umh8uBmg1i:22
X-Proofpoint-GUID: RMgzTUGtWO6WfimOG17tp3QJI6pIXRkA
X-Rspamd-Queue-Id: 7CCB6140004
X-Stat-Signature: 9h9ihnkgsfg9e7m5ttwcgi3x1xxeggnf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768381453-193041
X-HE-Meta: U2FsdGVkX18ojQfFhpa2Kul2CVEl2zZco9oWBs836iTQiUsM2ZJ1X5SWES6LDB5RqGDmRjYCFDINRTDpINYktLTzbvyICqeDvyUxeuSZy4IhBD+XD7g+/PmGDrad55FAeQX/rdjCsZVGXVM6zkkV72gygpT2sInE6mKbvkOL4SuUN/Cx8i+8PnBuhbJHA5LG43CS+zJElobxS4C+EJDdsIBSI7JnsQ38AzMVoF+jtsvklSkAfkPrfyKZAvxFOlDOtBFh4el0znbb1+OBJt4wdEX4AAjCsM2miqxnmATGiHE/B6c6nzSBOn84xdgGeC6kWh9BjPQ/qM59QYr7Z3seH90pmimo9rGC/Z5HxdMNAKm8dcNjMYDp4XNG+NhF3hlL/MQZYzHm1JnL42LNfe8/LbE7Z6CHIT3kFbiMGYp0hnP7XAu3PXZ57RifXnJDCJgJX5k/blQDaJZDg3fNQU+D1/sx3C1lpWUBDBelUKVpNktIm9F7I8IDkqRvnL3hu6RfmpoDJklFQtXf86viT/Xam2iCyX6Nx2eUOwGsm3NpPUpjJt7hkDYGLbc93Asx2wbDgF0HqPbPkkL6iuYZ7wN4xc5PZLXEM9Sh88wtxjip90vLDOEMMjjww5gibVW9m5MFWRUujhukO1HZK/3gZED6vs8XAREwbjF/WyKlXbeCW0Vm6yuSAsDpqWUIbbC1snjwyn5Row33I0dEkrDqGEZBESDYX0zq0I5qEeMKOQ1TWHzrKrfKGRWlgB2UgJeuUUpK3DpgeLAcud2ka/ZhaFRSQCxly5oDguQsMxAPeiDXPSErwrkrjCzUs2ngPQqWxKpHc6IoUw63LLIPDRMp8faajyVRuhiY4d3dIJbI2C2gNzWYxcG7kzBsDoNkw9vcVpsQQ+1rcNUJJytOeQJq3hGsEy5QwCG7dWpaCWw9fSRHpFhJYGG/fKr6QCmjk+8lR/2wrA/xISA3A9Vxgor0lPR
 HLbtBqjx
 C1Da1jcvqT4O8IN4iJvaftctDgUV1UXmgvzhHBPsJJPexb71bakXXlTAQrbkpmt+3j/pzmFB3R2XzykGZJ3hmywZfQBomO0xMmU4Qic4q0NQ62I4XheTsAUugrKBj8wR4WkwzvQiI0xHLPLTgLxtbJjr5ZaX8xcMnkRbcd9dm3ZGIhHzp+acVnPdXyoxYizToj4uVtrf94bDmCUsqFC7hpKJrArXTTwBR2bVsrBfF/AkJw1XyyTEURMOm6MD0HzZQ1DyTavJ1ZgOKthEuvNftbk1KtklI7kUvjW1grxn7f1TwkvvS+QewBhNfZQcr0DVRWoGehqAuja0CgsgalPMtmeqBdCvLwZYoidX5R+Yk1/Ens4haPkjIKovulkNh7bLZU2jT2gL3taA/VFQEYFkVMYcf4n3R1RqKChbGV8AE7TaeO9UYybyJJqoLc7X14Ofl9UAuiAeKGrzACFRy6GVbDOQE2Pf3fHHtre3oIsgs+V4/2IrK1mYvlYR9ifbljce0tQ7ldKeRctyDDZfRjLyqJgXptMgK54joqkdJVzuuDsE/odkcEqwM5XhNNy/7pGpKpe3b6ngg8087Di+JWGky+MTSqUdrSuZQfdkIN+8+mdwwdfXm65A+xpb3yAPJA+SgUs//vXwm8x21RXTCkdpw/22ucp2coC/flnAEvcfhMFaImlcFwJcmHp6ei9KeWWGWikKgp7eyBImizWilu7AJiNw9iWo41aNBwlEg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not sure why you're basing on linux-next, use mm-unstable.

However, syzbot is immediately reporting a deadlock bug here. Maybe a 'neat
hack' to get the bots to actually check things...? Very strange that
happened for something not in any tree.

See below for my rough analysis of it.

Also can you make sure to test changes to _really fiddly_ locks like this
with lockdep please?

Overall I don't think this change is justified in any way even if you
somehow resolve the existing lock mess unless you can provide significant
justification so am minded for this concept to be rejected.

But obviously this patch as-is is broken, so no to it clearly.

On Wed, Jan 14, 2026 at 11:24:17AM +0800, wang.yaxin@zte.com.cn wrote:
> From: Jiang Kun <jiang.kun2@zte.com.cn>
>
> MADV_REMOVE currently runs under the process-wide mmap_read_lock() and
> temporarily drops and reacquires it around filesystem hole-punching.
> For single-VMA, local-mm, non-UFFD-armed ranges we can safely operate
> under the finer-grained per-VMA read lock to reduce contention and lock
> hold time, while preserving semantics.
>
> This patch:
> - Switches MADV_REMOVE to prefer MADVISE_VMA_READ_LOCK via get_lock_mode().
> - Adds a branch in madvise_remove():
>   * Under VMA lock: avoid mark_mmap_lock_dropped() and mmap lock churn;
>     take a file reference and call vfs_fallocate() directly.
>   * Under mmap read lock fallback: preserve existing behavior including
>     userfaultfd_remove() coordination and temporary mmap_read_unlock/lock
>     around vfs_fallocate().
>
> Constraints and fallback:
> - try_vma_read_lock() enforces single VMA, local mm, and userfaultfd
>   not armed (userfaultfd_armed(vma) == false). If any condition fails,
>   we fall back to mmap_read_lock(mm) and use the original path.
> - Semantics are unchanged: permission checks, VM_LOCKED rejection,
>   shared-may-write requirement, error propagation all remain as before.

You're not giving any justification for doing this, you really do have to
for this to be acceptable, as Matthew notes. Especially given the locking
complexity here.

>
> Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
> Signed-off-by: Yaxin Wang <wang.yaxin@zte.com.cn>
> ---
>  mm/madvise.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 6bf7009fa5ce..279ec5169879 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1015,7 +1015,19 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
>  	unsigned long start = madv_behavior->range.start;
>  	unsigned long end = madv_behavior->range.end;
>
> -	mark_mmap_lock_dropped(madv_behavior);
> +	/*
> +	 * Prefer VMA read lock path: when operating under VMA lock, we avoid
> +	 * dropping/reacquiring the mmap lock and directly perform the filesystem
> +	 * operation while the VMA is read-locked. We still take and drop a file
> +	 * reference to protect against concurrent file changes.

Hmm sounds iffy.

> +	 *
> +	 * When operating under mmap read lock (fallback), preserve existing
> +	 * behaviour: mark lock dropped, coordinate with userfaultfd_remove(),
> +	 * temporarily drop mmap_read_lock around vfs_fallocate(), and then
> +	 * reacquire it.
> +	 */
> +	if (madv_behavior->lock_mode == MADVISE_MMAP_READ_LOCK)
> +		mark_mmap_lock_dropped(madv_behavior);
>
>  	if (vma->vm_flags & VM_LOCKED)
>  		return -EINVAL;
> @@ -1033,12 +1045,19 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
>  			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
>
>  	/*
> -	 * Filesystem's fallocate may need to take i_rwsem.  We need to
> -	 * explicitly grab a reference because the vma (and hence the
> -	 * vma's reference to the file) can go away as soon as we drop
> -	 * mmap_lock.
> +	 * Execute filesystem punch-hole under appropriate locking.
> +	 * - VMA lock path: no mmap lock held; call vfs_fallocate() directly.
> +	 * - mmap lock path: follow existing protocol including UFFD coordination
> +	 *   and temporary mmap_read_unlock/lock around the filesystem call.

Turns out this isn't correct.

>  	 */
>  	get_file(f);
> +	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
> +		error = vfs_fallocate(f,
> +					FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +					offset, end - start);
> +		fput(f);
> +		return error;
> +	}

You're duplicating code here (including the god-awful indentation
here... not your fault but still) it's really not good.

Please do not send patches that literally copy/paste entire blocks of code
like this, it's not acceptable.

Anyway on to the deadlock... far more fatally the syzkaller suggests that
you are now in trouble and deadlocking on the inode lock...

You have:

- A vfs_read() .. inode lock + mmap read lock ....
- A cheeky setup_arg_pages() -> mprotect_fixup() VMA _write_ lock...
- And now this vfs_fallocate() which is waiting on the inode lock DEADLOCK.

This is my rough reading.

This strikes me as rendering MADV_REMOVE not amenable to use of the VMA
read lock.

The locking here is already very complicated due to synchronising the rmap
lock, so can we please just not?

>  	if (userfaultfd_remove(vma, start, end)) {
>  		/* mmap_lock was not released by userfaultfd_remove() */
>  		mmap_read_unlock(mm);

I mean you could have done e.g.:

	/* VMA locking doesn't support UFFD here. */
	if (!using_vma_lock && userfaultfd_remove(...)) {
		...
	}

Anyway it's kinda moot now obviously!

> @@ -1754,7 +1773,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
>  		return MADVISE_NO_LOCK;
>
>  	switch (madv_behavior->behavior) {
> -	case MADV_REMOVE:
>  	case MADV_WILLNEED:
>  	case MADV_COLD:
>  	case MADV_PAGEOUT:
> @@ -1762,6 +1780,7 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
>  	case MADV_POPULATE_WRITE:
>  	case MADV_COLLAPSE:
>  		return MADVISE_MMAP_READ_LOCK;
> +	case MADV_REMOVE:
>  	case MADV_GUARD_INSTALL:
>  	case MADV_GUARD_REMOVE:
>  	case MADV_DONTNEED:
> --
> 2.43.5

Cheers, Lorenzo

