Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF63B1093163
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 01:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A2A6B0005; Thu, 19 Mar 2026 21:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200C16B0095; Thu, 19 Mar 2026 21:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF5E6B009D; Thu, 19 Mar 2026 21:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03E626B0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:02:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D18C1607BF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:01:59 +0000 (UTC)
X-FDA: 84564639558.09.96C0DEA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C4FB40007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:01:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LI2DIF5F;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IpgGap6n;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773968516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crZK3cfBmWcX7yrEmbWXProba4hOPqv8Ols7vVPE534=;
	b=P/RglZWbCg3K+y8KmZk+m8hDfcdasHSNBLyxPsX0jXKTfi/meh728VVTK+WNCMQjvGa5FV
	3ggtskwT4mcSU/3on94bAhjCyHpixcoI9sBt0JSXDB2e3Q6xtERqtYgp9Ov28RtDGAvAE3
	oppPt80N075hpBvIvXpkOSeDCn/JnpE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LI2DIF5F;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IpgGap6n;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773968516; a=rsa-sha256;
	cv=fail;
	b=Oiy7yMMzsVBmg1GIMXycygx7uFCjwahfSyG7Cj4wHRU/uyhT7piEULxgBCrUsyqa8VwX1+
	r1FUhbjCprArqi5ItkvyBy9dEuwzKT0/6t3K/z42PYks+1LcN127M6AdSIITYu/kSTrGjX
	0fCud78NkV7z41MDDCKgsuufpm6YAk4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JG6h4l3797743;
	Fri, 20 Mar 2026 01:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=crZK3cfBmWcX7yrEmbWXProba4hOPqv8Ols7vVPE534=; b=
	LI2DIF5F7qKjZFrie1YoMO6M92Ev0MFNCrAldAsv024v4f0xP5/J9RlXqyZAs0Sn
	xoyPmg1wWOW+sZDDs3YoGXb1DXVB1FHp2Cn/A+l21/uzkbsjw2gxxxtH7dEJtgmj
	8DKH/WUQuH3EynBP8Caj4GKGD89mQlWa0zjTiOMj6qm2K+BZ+eTo3Fk5iVR9k509
	raforKttblEqB/KOalUdYk+FB1a3db0u3nXtBMPNUY6IbhqS6dnrjlLxXDpnZVUI
	dHJrBpIfxrp6IebtxLu+dUk9JKYMhppPD59K0+S9lscr+GoQO+QNSXSrT7LeX78G
	/IFo4cF/PXU5+HIGGPb3EQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqc0tg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 01:01:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62JNQLu5030497;
	Fri, 20 Mar 2026 01:01:48 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013068.outbound.protection.outlook.com [40.93.196.68])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dnpur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 01:01:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NH86IHz2bzAaFFZaNF8YPozlFuH4SQ7xL9PAdchu09OdkacwRESYI3NLSjPktVjuEaVNAQ2XDANhBpgjIX5knZXWoNa40J9b0IVi63Wwx6NI3WylMuqnvoB9Wr8t1xEO1TFVP8epMOHwDGocXp2N4eUWyjVJs8uU8jVYUzMXKjR1qKYbdlIwLtvUQesh6SaBhG30tGrdf3TxBdMOmsOtLUSF0IYgB9ts2+KUdoW4KCBMA2FKHjemhwWJLynZq66/u1HAr9OfuhOKj6Lv7aZJWICie/kH83MlEKb9l26YlfH77+hC7bTWSi7cGT5CC/6zfVTj14UgXj8zm+pIYlgOHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRZpGgHUDQRZrWcZdFjkgr9Jj9obGN5K6X2rITcpFFQ=;
 b=LHwRXt3Ls8PxmIo2wXiy1K1lrE2ozVjfU1X8WBbpmJjHG50PAFyYOxBT2BpwNC9M5UBgxXC1/YJ4EQm5wI61pAnbPDCuTIUpYLpAfgZdzcHqU6hVamDK/IyLtdhxe7W+Ec4h8MWiPPYKsK76FjFJzNsC3jVbyIPr/dSGsYtuoqhGZwNfg0c7+RcK3DvmtMgJMk916xrIF8xInS4Rt3yV6NxTUBuH6kRaOvFNRDpOl8u7gmixdf96XEa7KLZhXxj5KGJpIogAioRfBkYOmftkrigqjgPzVjWm/ODShii4AeO/d5K+XzcSh/blOEBO0Fql9lbnf4HAictNCsWa1tAoBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRZpGgHUDQRZrWcZdFjkgr9Jj9obGN5K6X2rITcpFFQ=;
 b=IpgGap6n+6W/l6RpnaE2OcN4hc6CgKAGn9nuv9dhZcFVDlYl44YeI2PCz3447RF3zmXu3i9rwqxTTuSQPLqpVsClopOV5NZUMqB9BZD3mBq8JuryCJxaTgfayTTTyyAb6/0znnyuJW+yZGoZ67mYcyKwIm50Dn98bBaEcpU9lKM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8162.namprd10.prod.outlook.com (2603:10b6:208:513::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Fri, 20 Mar
 2026 01:01:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 01:01:42 +0000
Date: Fri, 20 Mar 2026 10:01:33 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hansg@kernel.org>, linux-media@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: Linux 7.0-rc4: v4l2src0:src: page allocation failure - increased
 memory usage in 7.0?
Message-ID: <abycbXzYupZpGkvR@hyeyoo>
References: <abtAylIlW3I8s1T-@mail-itl>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abtAylIlW3I8s1T-@mail-itl>
X-ClientProxiedBy: SL2P216CA0199.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: b980359b-08f0-45a8-eb56-08de861c3fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	NYzyetFev6WkNGB/EIs3QSO1JYojsIyHTFdFD0nRzVHCbwMdsg5fY1EwM6OfmBEKlDWv9LgsXX60nUO6pBS/DcbRx3CPAxGLmCoHFSa+5n2hskTlCwi+Q0Qd5XO2A8A3nwYuR0HiLdU3xkWYV4md5yLUrRX42EwPzNpH5ICUpbu6MWe+/35kM9G3j/w8t1+m04XoQYg5ajcOLtmtj2JQZtoo4XlWpcQGtZaJdJJimsDoqc8nk1S/Y4gzEEf4YpY/C6Dsi/hiUUyrn/cZ0Ek6mTfiuaF39W7aVtEtJRMpa7LQT8PElYz7yn3GN3niDB8tyNsMNGHkGdUXL2JOnr5y1VbP4t0YWZgCWfZ8qyRiHtKEHroHUiuAgjVdC/9N+B93gW2+u9gxo2mlA+CvNL3sF2IQp1mWij5S1R68nnTOT0o6ArW0SZmzJXeoEb0RrL8quqUp6MhH5M69dRoMx8JrX/uWUhp0ekT1t/t84bHstpWBXe/ndetNPPAKTd2Qw4Rmf4UHOIw1KHoVwwD4219Ie6nG0myuEXFQ7wgp1f90K8HdUruXIVMkYoSywnPCk853Bz+sxoJJgb5k34RrPUwPCFSW9VmIOdR0HCPOGVe/bREBfEAwdQ7nEa/omVfy2lxpDt22aQOf6sp/2Iidf+NXBsIcxhW8M88ViwNrtChIfm/petU/4EFhzwSNrfGjVxdJCD1Mc+d3Jp/bUPk+Gw/h2cvAi59zSvlfu26ixkSCqmZq8QddmiHGCP0ezcWvLvOL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?q/DNGtD79adKLWIRPo5T/elQJaMAMPhJE2mwlfmBydRpKT89DljNgvVF7t?=
 =?iso-8859-1?Q?PMOZwa3REDCZ8k0L7iZsY8qv2v0XvfOYO/dNKZNmrWZU3QEnlJoQ+2N2XR?=
 =?iso-8859-1?Q?3pcudOjAhlG1sQaPZNwF7Z7fPDE+/VJ/44JiEhS4MxpbfcBaAvieIWb+K2?=
 =?iso-8859-1?Q?9pZZuzpq/aoYFkSbbg6ZYaDuuESxtigUhtsR4SU0ne//gIkBxmL2HX6VAC?=
 =?iso-8859-1?Q?/DE/AaT4M7JhW+/geV9oCMM3543BKFRjaR7bcTrpVruU6a7Grunb7grCtt?=
 =?iso-8859-1?Q?JU2N3pFbFrTMy1URNcrzmKj5pHNsIgwzQPugIeuFeXrkNZPAfpdZxxV0kM?=
 =?iso-8859-1?Q?PkBUTBM4+btT5Gso6q2cRxcMa88ipJziAAGW0dehLkpQ/LUa2XOCQSOLLH?=
 =?iso-8859-1?Q?ZjPE74xOCUQzW04QGBhxY0kabjGhEXQF8M9hR+/QzxNPuKV9trAM/MOgDF?=
 =?iso-8859-1?Q?Ylt/GIs12ju1ZZk8u59gn7YDaXkmobQ0IWFOUNMEiD9iuapSEq2QapqIQg?=
 =?iso-8859-1?Q?2jK/n2IItC2SasMo80gCscxzEkm+MwKSCkNTZyksCdlymLoD2vxaJfZX9N?=
 =?iso-8859-1?Q?Ns1lWnOLjhRcupbrCSig6SbfVplo6uFOe7ekSjH3NjpeL78ynkvBAgQjZr?=
 =?iso-8859-1?Q?4vzRBczv6j9YPFiD68I4hELgLZSlyKqiqoZlixwWGweEwxfqwJ28j7MoqW?=
 =?iso-8859-1?Q?wy0eFq2hFDPNDcgcHFOZSOpIQCKv8NKlvw29RbhM4jtrVWYkgOI0EnWrIr?=
 =?iso-8859-1?Q?oD750wQHf2gdMTei9MQG03ci1Uk0AOaCVy7lA+zoi7OZIUkMjwDQA6AYuP?=
 =?iso-8859-1?Q?VgAFI0wDGxA5RaQ7CWxtg2NPG4i3ffQKAa2NECwUxKh4Yfz3KT/aNoFzPh?=
 =?iso-8859-1?Q?sn2bCUeoaTNwXHsBbMm/Fov5dFlto+vLX5zKylWzdq4qP3kBvkBdT46cYf?=
 =?iso-8859-1?Q?D2zytPkWURLjnNr0N6f1+aOfiyvZzi/dh+25z0VZp/rwzTr1wJxjyQbyCq?=
 =?iso-8859-1?Q?Z7N9iqn4FZB495QNHQw59h+/OOXIugPkL6z0BW7VSMWM31cB6ZjYEglsB5?=
 =?iso-8859-1?Q?rXvGWQcdFDBkdh4V2QDMjZZ3SpiB5nHwEuw6XQ74tCauT2Odb0t9PnO4jr?=
 =?iso-8859-1?Q?bR2u2Feo5RJETmzbZsBfyI6wlopPBhUKQU754u4YX4iYPAIEbEFr2BKiQc?=
 =?iso-8859-1?Q?VvJZ6/MJvBwt7jWAd2w2qASOZ+pH8zVrXmKCb97PgSZWMRH8CEgEZJhTH0?=
 =?iso-8859-1?Q?md9E64bTvtGWi4koeBAZlcvFmh4ZVSKLCNOLxyV/2ABelTv7rr2jYHuh/r?=
 =?iso-8859-1?Q?JTyd0RtgiOJ/yWxFPsls38JctWVBmJuf7QKP6lFetED5usmyVQJrPGk+Sm?=
 =?iso-8859-1?Q?DM4MUzUt0LzM6DDtnzu3LsL4fB8qHRVY6yZDMmQqYTHv9G5TzqEQm5h8o0?=
 =?iso-8859-1?Q?vi2s8jVWUF5KVmnWGSVTQ+QXOzhiLPeUKd+CvpeHNdsG7sw5CvN3M3kFYm?=
 =?iso-8859-1?Q?IqFrrrhe5u6oTHez1o0KoeOkLq52Jig2J0C9rGSQi9Fb7lF/jJYScCKXqF?=
 =?iso-8859-1?Q?Z7CfLgWRFv9S7CrGScG2TOMWG1vxYIuFM0petAFHNzqkkkcWT4aUwes0Lv?=
 =?iso-8859-1?Q?YPgzMJpWE2+CRYAKuS8tazG96UOLV+ubz89tNnWxTqicqPGeUD3L2efm6n?=
 =?iso-8859-1?Q?EF6a72eQEQUjNbrCZQ8rUf0QHkpkJmwr29zG1Fi9T/La74vABjjQBq0ju6?=
 =?iso-8859-1?Q?Fxa+I9JiYKOgWnWJUC1i3YFYw0D8CyNbDF1tf3MI4zsni/BExrQ+WP9Vur?=
 =?iso-8859-1?Q?KX7RGdVebw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Y29iOoSUjf+cXLe2GM4peRy1bmtAkuiCqUV/8lOESIxW8RopD92KE95F4yDjNqoiaaAfwKlX39eDi2welQH3NtGtqofu8Fx+axxr7L2AyqgaE1TKXszYeduOYjJReKxeiy2jzpDuTaupTGyA2A+RG3vH+PTjvK/wYWY89TWNDHCwNb2TkjMOfIeg+ULTz6ZhiHXdT+fmDMr+dKyk3IsD43JQqIK3bMuWJhb6OD2Uk5zgiIJqjZWVcKhQpkviHO3oEobwG2XbN3Uz/EN6SpTW4YrNjxRGhayJJ6j2PlC7TvK12fVSRJKvvlryiMZ8A8ZTDxt7z+R3LS7eQZvJgCzHQA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8fkEAyvwpO8D6McCn/psXczHcBufUdCYhARpgqZmhbPX1gHRKGV5Nfl2J9KgqzKYa7GL/SFXROP5+KrOkg/s9VQVjjYzgfCVjAoyc9nolcBypgjOqNVJlGA60MU82WEsA/Xy72e27Tj3xFGCR70hYfFi5MiLew7jzLWkv33R9WSQjzgEQnMwVD6dG2xDboa8VZLfySX7CReVX1PzZXhWVyrBbEW7LLp8Fe6rucS2KAzrVXZo9vWYliY3jaT7RdQDZuA54UOwUhKQSAdOxgk/cMKuyNSBmgw54yNnMBUI7wF5D6hAsrMs+rZzehnCPrhRwio649CK4owwW3aDfWYY+DuZJ+1cV7kuTPul7kS67pkfgxZaoGfpzrItLrxPpO/toNfg+/3ceLlNNXPb7C0wVgEGesqnijOTuiyVedWxzvf9BUprbutArahMpZERgrbpj3+uF+YYDdVHVm3aX3/tE5vYbGO/dgsmDoulbcKsjOh7tWqtbYf7jNCRUrG7S3Y26DNWYx+1TYplL98ui261gvGLPWueuelZKt7qD5sAab7Tk1h8dv5GqQYLvHA4yFMoZiNk+Tr6LdSbk8xVY3jJylT3KXRHamyZqvyeneLeprw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b980359b-08f0-45a8-eb56-08de861c3fb0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 01:01:42.1143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Cas4s0iHCEjPBS0vgRFBlS6X7VG8aMhznSDFK0ce/d3w8V4MaiM9SwsGwObniNiXGVeWDwo9igGQrnZp8i+vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603200005
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAwNSBTYWx0ZWRfX77ajkhpPc5sN
 cfhUEGlAUlgiB7hr48TBhbvHrAVCauLH7D4Ic9Y6UkZN9vqvjc2H2ctwinCHbX2equ+ZOl3y9Db
 QjMq1PoFOjIpVyDOKwMCSPDv7rM+wDjarBK4/pzGHYMNZQBSzJZk38IEYqsBWM/GJUWZ9WKvc4g
 /Kf33UUWLxL7khg9vXfhza5v3ml748nDp58RH7CjXeVzOnPBTRYBrSjPEYM5vaJKMAuIbZ14gPA
 U//ZX+oiuEh9simA2CRiOZH7ble3J4eXnCeQkJ6JNYEEefcqXbmjNjNYPKWvZx2QNEymLwA8KOe
 cWGBXkzc+Ew2z/i3yAwJ1BRneHyg2lqJuLR3kctZOYwLi90tTfPKoX5+6oHgLzVQ/33HWaOFahr
 88GXdKy0v5D7QpDpNwTcmLVReOJPzPsHqF08Ty1Vjh865a0plPxSCUbwGjG4D7XSyvVs6rXssVc
 MtuADwRyB/4Zyq0Lmgg==
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69bc9c7d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yZlKdwYgL9x5HG_F3WQA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-GUID: vgLMxHnIs7KovlsaV6zlCxVtvLbjZ0h9
X-Proofpoint-ORIG-GUID: vgLMxHnIs7KovlsaV6zlCxVtvLbjZ0h9
X-Rspamd-Queue-Id: 3C4FB40007
X-Rspamd-Server: rspam07
X-Stat-Signature: cs65jsquspuucpkd6jxyy7mpmhhcewo8
X-Rspam-User: 
X-HE-Tag: 1773968516-226091
X-HE-Meta: U2FsdGVkX1+2jzFJotX/lavQyBmHhIadZgbIxj5dE1jv9SafIJ90eFCqXB9QSPtdnqHQl0mzIOqyE94YvYSEpGm8qb2wxybrk13zwYbyQ0+aI40NLEsXsQmObksHLj73T9VA7XjHkx5CdoT5ulRl1ZMJZGbYcDtCyuB9DNXjQtb28XS1Oievjt1w9pai/L/RXjxJ2Fd/HzyZoVtaTMdlwVpNie/Cp3fqxftXcWub7YXSr0LpPXlGJdS5mR/2D5uraMpK4Vlnn7rwpwbb/kg0OI4PDCantlQnt4De02I6MN0hIGIJarCAz4mG4eKhC1OoxDeMmtitNRlS5qQeZ6WInfSkMidwoqP5x4+xq8YZZa2tqD3rcUm17bBa7v4zogEQcjGke0Rj6u/CyVMTeHZJeDwLO2nBpwWrBDQfjKhm5+oBet/Wnl8H24UTNs8fP9RNrJ2DsVim/zFKRYUt9BySrsyGk9UqBKSulkHJmUIJA9++W0xBC6m7yOoGByKSSLEALntNv7fmkwHIhHOLeWCx+/i191bdda7zQlODx18ScXb1L4yBX/CDINWyWdsddyYKNnJTbkkoRX6je84HCKbesROSO1pkfeGM4hFP28BsSSYRKk+9rYP2NyJviflZ6MAVnvFrLxEiGmCr1QVqbSdOK5zJFlpNJ7VMyacGAkkj0+J4H5v1My+PpKRk2oPZ2rP0jSwjfOWolsJNPWZS3g7wn0s+aSPp0QS4TSJ5oDdeK4zyjEGilsPqDpCRG4MvJ9rWmE+2FULA4/RRHNqpAItDc8p+AogGP1e3EMNepK5h0wfqRDuDudLddgXy6aM8uDeCK8s551zJ6ZxOQ61/TPBRxAnih8d/nY2QlgjiyMHZe0hUp4uD4qM4E+jpADNWdFFI3lHd9ozKFyX737jVUVqHvMw756yI7jTO5nv/rEGDKPna+skg1CzErrIj/oOXWbaclqVBzGh0tj3C3nZoSlD
 gDZCIfwT
 7Ukt8ujggSh+MR2PPSUyjCuRGaqc8TpgLr+J6gGi7CDMaHXV62FlwnA6cFHg8E8TtPO//irIgVcMxmPbfpn/SeXIZuNaeweQDw//Z01N8Rgis+2rJwC3IPYuNslBx1XYKXyxiZktteTyCJgXjUfpo+ptxFJY18QXgc5pYt4/hx6TwCTbooDutKGmkucq6T5PfaOAXFZYH17ZZABkJ+Zafp8tG3NUZ2GwmCAmq8iZgRb9iFBQtvYM3dBqkAcVs6s3UgmpAOGGJeO/bTHOLOes/TyfUwW/OhuE3iE8COOlN9Z1Lurvfm4WyedeAAH67nt8RdMrcUfCKFOFLdT3hjXJt61qmsJ6TkghzctEklC2TdXYVhivt+MY1IJWD4/5kK4mO8gzPSnpk3Yyllc1HklACMcUKugHyS5FvFySOxkO4AeRkv1xdi9n28rRpOspYgdPKAQ9XGUt9iJ//8+9VghMItNxisNS234yxfmBfM5N42TssPC2+xe3xevaB02NeXBZcx5mFsw9bcz2ToWzkYsSKAagLnIXLT0xyqgMqKTBvabeZB0AsRUgiG+v5Qnh/NmC/nsEdFQnzDqfYc6EdVkQ+Bffjmgmwdxn98rl7jx1SqlWK1DIQzRaRFz8/qYNLcmfdPjs7UTvztiAVf8Dtm5h/bxvy36GL8ezgMFMPv0FmP+1k7bqbZXQOOCCb2f/Xe+WhdsH9CHMCp8/PprIgie33JVrRKTjNbujdaGUSFkcRzJgD03iqAf4/TOwwapFxvsKS020U93qFd2YIqS53Cv+HT5co1+OLQjuWaqNGalMs6UQzmEPOsu/y6baLkjiV4aDRnXuNIIb6yKzAPLEFkvIT5wgN2fbQcBZ7WuXkw21/+AXxrwhe935q3nX3OEF/Sy58a1Zg1NbgxMqP18H1oejSyIFXLew78PbFxDZiEWr6u64KiK5L0JPnEw/jEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 01:18:18AM +0100, Marek Marczykowski-Górecki wrote:
> Hello,
> 
> When testing 7.0-rc4 (and also got it with 7.0-rc1), I got page
> allocation failure in uvcvideo when using v4l2 camera in a VM. The setup
> is rather memory constrained - it's a HVM with just 300MB of memory
> running on Xen, with PCI passthrough of USB controllers (to which an USB
> camera is connected). But the very same setup works just fine with older
> kernel (last known good is 6.19.5, built with the same config).

Could you please share what /proc/meminfo looks like on v6.19, and
also enable memory allocation profiling feature [1] and see
what has changed between v6.19 and v7.0?

On v6.19, you should be able to see how much memory is allocated by
reading /proc/allocinfo.

On v7.0-rc4, warn_alloc() should let memory allocation profiling
print top users.

[1] https://docs.kernel.org/mm/allocation-profiling.html

-- 
Cheers,
Harry / Hyeonggon

