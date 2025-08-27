Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1DE3CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0922F6B0012; Wed, 27 Aug 2025 11:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A2A6B0023; Wed, 27 Aug 2025 11:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CC56B0027; Wed, 27 Aug 2025 11:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB5826B0012
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:21:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7481584DD3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:21:44 +0000 (UTC)
X-FDA: 83822902128.17.75EDFD2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id C6EFA160013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:21:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VwVVP6fu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qo3QyJVY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756308101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjK5an5I9u9vVF6TK507FZvv2W9xczGi4119IKeLtdU=;
	b=8G36AC38xyDpbbvCZCdyngHWpNWqT50PpOyD/r5A9iAyzPWbAJNryhgGSCGq/MC4YHES2W
	YwZkQw7FTl9fIwdO/LfrXw9O0Y554D7qRMRfLBnxhRZG7zvwr1h3fm7jmP3XWooHihb8zc
	uD3NyAZvgVvmAxoWrB5y14z85eouX5s=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VwVVP6fu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qo3QyJVY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756308101; a=rsa-sha256;
	cv=pass;
	b=VHZ3tiv+mUZMlL5puR2M1dnLO94hujMV+JH/wg2Na56PPsyYOdprS4W10jiQOR7xQCl9K+
	QY5dgmY0qa6a1h9fW4Z4yZ+k1pWnApxzdDiMfynmdkEvQeZH3meN/qRVsNbzl/qvGZuOSZ
	RXzWPHQwwUo+nmMO+p7cyboXpPWf6rI=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7txBc010338;
	Wed, 27 Aug 2025 15:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DjK5an5I9u9vVF6TK5
	07FZvv2W9xczGi4119IKeLtdU=; b=VwVVP6fuxUCgIdfvPxEddKANxVf+tw+ItY
	OboAa/sUizBwTBNr30MfeN6FnlOkA+AGsl7RqgA7Pv7swkIk38yIhn/iE0g4hTZz
	TnN/UjDOS4DBIr2VvnqKf8hpB0tgrNMC3GydabjwHu1Q9oi/BC03wrTBAkQj3YUd
	9naRrxDFP5VnY9fIuOSB/sveBNlQcugsAFLvl0MN/FRR/NnnSiObVwJ82Z6ImJnF
	Zv4NGC7Ipavo7HoedA5wVzQ4HLWPzwNMaAfHVB5ZVYJC1dbB9HwS6ytTVEuc8n1y
	BS5sPl4oUYtec40qkAKjqjoBxD8aqDa1zy2EYqnUJGV+IZQKmf+A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twdeby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 15:16:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RF2fNR005309;
	Wed, 27 Aug 2025 15:16:21 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2069.outbound.protection.outlook.com [40.107.102.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8b1dxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 15:16:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0RGQQ19j4WiLYaSrSFy0meJhB+hm1OiIpSYVpoLpm8UGRtNBUgBrMAadd1s4kbcbNHPZ4WN4uBIMCBtL0rsoqTbkt1sTWRgREyY8V5mZ2aom05gump3cSNn6XEwYte4Xfkw96TWy1Li2h/342nJJ6BvE9mv4Fz/jjDBTzIOJ7loZAlfefdLN2K20ERJuTG6rFRhocJzLQ5OGB3pv6Og9gQ1I9MSFurw7I5fKvz0qE58OVdFB+nPsHyrRlAOcFRKV3CcAHysc1Ro4rhm3VtgmUryUR1AVo7c8j3+1G5WXI6LeYNkXOCEzbuyaX1LF01/18KsTWYTiAYei74Hl0D6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjK5an5I9u9vVF6TK507FZvv2W9xczGi4119IKeLtdU=;
 b=ofacU8G+xzk1LYZX1lah0O/AaPcRKl02zBr+RpEYHE3MHz7elsr19AF6fwt1c7fwxb0x/+QanZB32R+s8Qg22SVUpxJSugKnLPfdD4RrWleeXlzvaOOOEfGCShNKHAnfiBebXCeWQaxIJn8ckwFjUxiWouDcMLU/9de1RYVt6evhHT/kDaXVXpVBH8Z/6Js1iWCaOLwJ6c74kLbdBVgKJP0tnH4bBMkYvrvQjPVWvCsFj1sFYa3ZQDrVI7lnPp6mbBhHvDdDLSiG4Ojv36TtVx9n3Rtgp10XZFb1LNAZclMYEJi4fM3GGB5Uy1Qw4G4MIdOvBIWV1wR5leHhLgqgBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjK5an5I9u9vVF6TK507FZvv2W9xczGi4119IKeLtdU=;
 b=qo3QyJVYPC0oSgUxrjJJ4//dm4WIsOwRv4mYSjdmUhxqQ0OzGWPOR8NCn8sHh8L99glYpIJQ83FOQRbzE7KPi2+L+C8g3IgsTgtGg1A9CX9KeG6g+NPO0SFBB8WIBtcnUV8Rv7Y4T6IbSeI2yPDp2tM2loSZhuAF9mrgFpvfMZI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4706.namprd10.prod.outlook.com (2603:10b6:303:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 27 Aug
 2025 15:16:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 15:16:18 +0000
Date: Wed, 27 Aug 2025 16:16:13 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, shikemeng@huaweicloud.com, kasong@tencent.com,
        nphamcs@gmail.com, bhe@redhat.com, chrisl@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] huge_mm.h: disallow is_huge_zero_folio(NULL)
Message-ID: <30f52bf5-ff37-4e22-ac57-7be0b03b1f51@lucifer.local>
References: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
 <20250827150330.280399-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827150330.280399-1-max.kellermann@ionos.com>
X-ClientProxiedBy: LO4P123CA0585.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4706:EE_
X-MS-Office365-Filtering-Correlation-Id: 35943b90-4ccb-4f21-98be-08dde57cac06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pybY4Xs1WyvOzK4X5gVtPEl3BFxgxZMOiFhERVOAFIEACh/Hu7YaD45bNqkr?=
 =?us-ascii?Q?3pN6wZJFgDN1jDcf3oA9rYsOq1Tg5OffMbaLScXUQPK/Ccm4AY4rVn5fbSZI?=
 =?us-ascii?Q?e3UsuOs3cEbW9+NcGDqU+zdlGKvLwAX2f+hRK+cFYCfvG8uQhcxw+jn5iou6?=
 =?us-ascii?Q?QnAPOKQWMoEKFrw00tphKUWYynOhh421W4M8KRqewZadtjIKe+7WLeWX0X3B?=
 =?us-ascii?Q?6EGO7TmArMkfpludWnviPJR4MrJPHtrepABV9fAeLC4IraRHjldt+ZvSLqX+?=
 =?us-ascii?Q?8PYmnjXlJ5He/UDCLxXzsgsXouOpjDSdeC4cViyYsnkz1GCIZ05BmJ/iEENs?=
 =?us-ascii?Q?1MY4pBBY10hWMuaf+b6opMgzbC8hJ1yr2PdqPhOAU6oTVS1ovQuJn1egIzG9?=
 =?us-ascii?Q?vWXU5+DXKucSCVCuUHYbxhWSQ3CaK5+f6Ad5J5mqz9Tm62dAyNrjtYRQcleT?=
 =?us-ascii?Q?1mhDUOQVm76KP5oUCpC65DPLeTYV9RVWU0alqgPpUraWYpXSN8lMy+aJ2IWR?=
 =?us-ascii?Q?iX8Wi+Ph870AWkWtqPey98OluGVRp9zRPj6Hf90ZB94KVMmwMoB4036zMYKb?=
 =?us-ascii?Q?0RgFgSEjiLfzCbcspUg53RYVISTLkQ7tdR9RIW4FOqs+b+IysxjGPiPuZlcu?=
 =?us-ascii?Q?kq3UiH9APWgCZeEP1ZdfhOhFzK1Km0rTLF62OjQOgu+T/uqHsZAjU73esjkK?=
 =?us-ascii?Q?MMuYGznG8ujYTl+ZKW8IEEc57CxsU0Pcd3PlWhqVkG5T/IKKNJIMu3eHd+6H?=
 =?us-ascii?Q?AExw1gjXqviGV5oziLUUQH7xldqOUEYSrFGgEvqxEzj2+5hZ2gIoOMyJL1CW?=
 =?us-ascii?Q?RWAhi4cpf8G7DgOv4JyPh1Myd+sYUWEU+iMtl8ypFaWL+QN9ZB0Iy5QlmiTz?=
 =?us-ascii?Q?enBeX+vhYb5lGDLoAr4vDc1nu1wlv3LESOCEYMQRKxh1Ks8saBVeI+lFmB07?=
 =?us-ascii?Q?G1QJ6q3b/y9IvHtYc1Vb/jdjWsi8fQDj7mlGhBSXEZYWCLCOQOMzx238clYG?=
 =?us-ascii?Q?DMyod9EnFbdrZZW3OSLcPo5oUdEGT/sBICHcF7aQOXJkGDjuZ/xLpNOeGLTZ?=
 =?us-ascii?Q?5PGxJSWIjaBItkQaqbf4FKQ+OkiJKyE9Ld+U06Rzg6wvm4a2n1Ru6C8BFbKZ?=
 =?us-ascii?Q?ZqD4rW5BG3SoFqWLylCu6BfzldQ2+HAeSZxXhPxa9WXnZeR4CMXUyKWBHGhx?=
 =?us-ascii?Q?GlXTOlNzXqwPDmhKBX+RwtSjpHevh/NVAxo/LvER2uvicGLue1usFetX3Zsk?=
 =?us-ascii?Q?iXHkqj/l0cKrzos7H3U69SuPWw99t2vjHusa1OhwVbEP/n2d6qFVwFbYJPZU?=
 =?us-ascii?Q?Y54DL27kNOxIgpYZSuYf8zM1db+eLiBwMJboM5ONiBRuWN60dOvUQDCkNiEf?=
 =?us-ascii?Q?WX84LW0p0968KtQ7Srnql1sZqyzNhgzudIF20FB71aCZz0/1w1kW9fuNYhSo?=
 =?us-ascii?Q?dEa++SjObUk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r7mBPaKx1o4ypWeTbShIWbIAxQoUVOEslexgZwTS1I45hn7hNQNwtDn8CtLv?=
 =?us-ascii?Q?XPxuPyU1Q4GChvkT/8VNmhXZEXd5PDFd7hI0B0uHq93q6WT26x0puYbSRAF2?=
 =?us-ascii?Q?4mMdosCaFxuh9j/YTNBtTG4yvZsyyENcDm64cDpxhgk/TEIKduEYIwrTxGDs?=
 =?us-ascii?Q?Q9Hq2eu/wQFzmEDGOVrRa+C4WeJ1Zf+n3Dn1h7+FKT1R5yLkdMT3qJx/pHhw?=
 =?us-ascii?Q?jSv2r8Ct54vcui+FUCV1wXA6EGMU0rTbcl7UigcMVG29uji2t0HoRFg5T86y?=
 =?us-ascii?Q?cnBTnZy5piA7tU9Mm4A9uhH38LZGTR4n5bVEDDLjMHRfDVC34jXJXClPT8ji?=
 =?us-ascii?Q?VvMmhSXim8nmDeGctAOkJF+i4IPBNWgNh+b1A0c1r/07xIJlQbWK31+om7uV?=
 =?us-ascii?Q?tPZatlRA0+oXdz1p6p0lEM0VegBw84quFItO+Jwo/LWMSOovZ6sI5n0+wkKq?=
 =?us-ascii?Q?4YltmaMt7HGZUi9fiiFAVKCwEfqYe4O2ah1tXOAJaGeIf6pqHhzoGhr60q/J?=
 =?us-ascii?Q?y7Pw9BCrufkcZMj9sfN2/cMHjlGdwunlviQ6+8HzqKEwb86uBHEgeyatT7Mb?=
 =?us-ascii?Q?sg2d43WJaOJJ7wj669lRBqqjg3tD+01fPWS6bT8DMqiRylK4IcdUVh88Gjh0?=
 =?us-ascii?Q?Qo0MB6lE5XdunStsAUa+iM/f8Tpd0UqyHCfrpXylrNTG3lwUwE34WCqjI/BN?=
 =?us-ascii?Q?mjclQB3b8OMEMf4AtXB1QzMyadt4obfGa2gLGGCZvpOQOconAaeLWoI8wNCX?=
 =?us-ascii?Q?atOcIs/l6VnPsMFngZ8CNF3SNrkCom5eQ2u4MwoOmCCLAZ8ZreXxZKlYVwmd?=
 =?us-ascii?Q?A4C0LTX2uYHrOzIrraVTaijKNPYu1JZ2+TtUw5XMCiPlE934zuDmyJpHTAkL?=
 =?us-ascii?Q?8hokYwHFuVbcBBtvLaJ1dpGta2r/awzTG9QgXtRPfM9Ou6+uQFkUtPUxvI44?=
 =?us-ascii?Q?5oBBeiPqjabEKLJ8ha3MEs+T8XGFWkC57ymIOXTtZ954aZm6JleziJLEukfu?=
 =?us-ascii?Q?6wrXxXoF7Mw0MlOjsglCd3kLXIYKfRt2MjzVDtsg4Tp50nZfX5/CUeCME11N?=
 =?us-ascii?Q?DcXcV9OrRvRv9/+ZZMq0GFLAAi/SFBvzjNh1jtvNDyCcwjFGev/0c5qb6GrZ?=
 =?us-ascii?Q?N3ghFnuCrqXRFi7RwTbEXUprMbAygtRzgGCdraV92HThowSDKCXgomzUAPjM?=
 =?us-ascii?Q?KTu6jLaVnBavmCR9qmG9QKnwdntJ4m1ic7IiZR3Zm0n+G99+XkXQT0uJFFgT?=
 =?us-ascii?Q?xFedPBRoT3hrZbnZE2aKdcMUVEU11WXcd6RDYwhDrYYbWiWDeraCfE8ldQhk?=
 =?us-ascii?Q?5G/X0uaUwNukdKKthzZqJkw/+Zs7em8FijAwI/pHC8YY+7kmsJg7jyj/sCdC?=
 =?us-ascii?Q?fMPOApsQEOMD1L3pterbkoxOBcNAvC9D8tMU4ceYl2B8T2pw2dYaGqIAfaKj?=
 =?us-ascii?Q?XUnboRDrDUcH1eMj/ZBX2craDJxQDwyByteih9izOdQb3PGJ8gHulHo2oYF0?=
 =?us-ascii?Q?7PkuApQnyZWwDZF2ODPX92n3uZ38KordQ99MnxhXmQBc+wGWHvDPBLigOv/u?=
 =?us-ascii?Q?LRw87fmyx9d2fazrf17nNUZ3PpahVo4Caf82umJOFjpO+FZ+zZW1bAEJ4/eF?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VCNnUCqbKSN/0LLiL976onwckXvOnCWLQATrTq9TNHpSn8+4k4y2fIjzWC+S6aTw7c1tG4xChChk5Zu424st40owbG1Z+zkm+bYfS5jbleAmrbxI1lLpxKQwiukNFK4nsG/KNjCuadcoeQLrGUxNvL/qFTC24Bw+gOAxn7UM3HTDtnxg9WhsO9J/taEW1OdTfJk3Fxka1pNj12Nk3yxFnqtY2hO5TGnEjN/p2Yovt4kcWXxLLBh0N/wSKytIiw/PKBCeSUnIMiKIA7QrVDYpDzF1V2wK6OmIB/fVfOY/HWfQjLKPiGbAqw29dqy1PZF8omAEjWMpmF/MNRVdlhQ7ZDpDKTzmZvKH9wAReLPY5Ktg6WWp9fpK5Jzu1PSDvzjLUKKCPH1avRGRsD9KrTu6EE/h4BbUNPRjzW4JzzchgUutCoMFqiicM1oKu6WeVXzPEbP2w+g9EsOLL/9G2PXqa+vVSXwm23JsJzzgyTugl6V/aj5KryXK69xgXUYKpf0BzxEZLkKdN1x5SePtxT1eX/DV35q9v4IFaQTj7CaLhHlvTDbEg0TIbKza+xQpf4vTjG/Axo1xBpmhd2zitBX13znKYXfuF0lioWlUcQgoFQc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35943b90-4ccb-4f21-98be-08dde57cac06
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 15:16:18.1880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XzTm1cjQTMz5YNtR65VjPi6ktcT1TqZFcjIOVhYIxodoYFt/zeHdUQQX4HkHAloUzAYaEtfEwTrduwUkQgtSuDvvhAqS3dh2kwnOom5CWAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4706
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=489 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270130
X-Proofpoint-ORIG-GUID: p-M3_DDbI6IeJ9kdGsWMBSSplz3sE0TN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX2mC9ifLdZaWe
 FcvypcPOJOqnQ2jT4k+ObeAxfpw3ikR+iA/gyu2ZSaGGU1MB04qYbwrkci52Izj3bzLgpGhNRhj
 99DpGOO5LTAt5kvALM9kO9cmW6dM4CSxCnaOid21AP9pkmAj1JTczsoeVQBraWTl55rVGJDD5vI
 T+OTFaWW9lHPsyx6ozk4RmYvXlTZtk/4FgfxUIR9rLquMQFIDLfrHoR/tSqZNdbtuMuMd/AtjoN
 W2TzA2yW9WGCiBnDBKCkwzmKRrOB0VEQLjvsEblcLGkiuMQsPdNNMk7AN0nUwLQYtyMjkYFms7t
 X7LiQmT6U0ncLtBGr24y6+UhtYfSPkPEdqJFHeITeKanYDLPqT3r+SIckhijKMtvDkctI23ikPK
 T3elJ/gJ/Vs5YQXghOeqcMd7YxjOvg==
X-Proofpoint-GUID: p-M3_DDbI6IeJ9kdGsWMBSSplz3sE0TN
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68af2146 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=UgJECxHJAAAA:8 a=X7MIZ-yHMupkJ3wKAToA:9
 a=CjuIK1q_8ugA:10 a=-El7cUbtino8hM1DCn8D:22 cc=ntf awl=host:12068
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C6EFA160013
X-Stat-Signature: 41rs7x7sry7197mj3cmoqksgqu3taixb
X-Rspam-User: 
X-HE-Tag: 1756308100-630737
X-HE-Meta: U2FsdGVkX1+vByZF4mZkzfcVwrZdcPuX7EidiCJGA4HaZ/A+FksGAGYgezTA5v2YOohlLGof4uvaipe3poQuY4DbS5NpcnvF1skV/jJ7KBluELuM3uYuHL56h0GaTM7r1KmvzqsSk6T5TVZV8+0LGt/ObyKdsAypOSacDjtnRS7es1wJS5VCd7vyYAilv+BqmIpF9iwX5wM/NHKIXVAuHKFgLinOdZC3yfYIZ4efzWw8ZvAq9xGet1NpLej5sqwZ79xGqUSOfUW/d41Givl3p4msutn0aovPyrXjUnegwCA6v/UOIgBunrnJ9hZfhO/tyS5MEjYF74WfP746YY+VE7Wd/NZgVhQABwQm2l5+Jw8Ej4O71cNASb4UR1Modc2VdmzQv1pa9Qpzc05mJpa/j5JDFQud6xm7Vp0+0HxMZvWHKnhvACzRPnaFrOqLomPjiUoi/lMUPbAy7QOynEYBWTW3E9gPoVckp1CHipxKNuksvgapB122bhG9NO3qw7yDePERI176YMgsc6D/wbotoJLoxg3pzlnuJ6CSpDH/ViDTOcsLZ4YevkAhuGIo4do5taj0yV4Sh55yLeKw/Arl+LbKRlqeBZZWc39hTmrPRoGdZ3npSK8N9ir2RGP+0pGljkdmTNwArSmyy+UbqnIUbvNp8XsjLX/WkjrSX5Q0XdGgo4Zwf9oR+isbhcRq/dzWMp7Jf7xgytCMuchwpf981lpsrg1Qhna6KHVEv2N6U1cvkYhbrky9bPzpV5wkOX1rgEvdhZAKXmB1ZZE57XKkc1Hz0gyS2tBtULp9+ZAulvaNVwcqcsUvKTD/YQ/Rel4kEwHMYUgmIOW8CEom063SYWxL8uXcJ1s+o8rjBBTniw7gXjRg76NvKJAblZltaddjykYKvn/82TAtrofen0mFGPT+XZshDY1oC1GoDINb5MT0FfNl3rR7h4kXM29D9LO0MIcnWXbOMLbghN9Iv4j
 Zr5mIzl4
 +hdtgN71ceJaj00Rmy+gA0X1BWs8V4RQPQbEODcmZDFRsGvhVhQ/p2eCfZElpV5iaZRHCzujju9nvWXMvogp9IhWnYTjTEgoQY58aRxurhWtLTVkrwSL1aTwLjq/yXJSdw2AbHj7a6HK5pV7C6X/UJQdc2H9Aj2sRAXCbGW+jJqKLCiREoPqZCuNkd4QB0d/HPUjzfXguLltxMWwrsygifKUew2iFx72toZPzr2qi4yywEY7qysG7NL+ASOPb/2fFUUJul9OYjkVBL8ZqJVMqsR07DhHWMaE9UiSxe7wRvQ2PNDU0f9B/WvfebghkjdkZtwCtYW2W46XbyTya4JZfnTj8opBGJSUW4u2twqJRF5qZ5nEkQXTgb16CXLem5LBZapwkB8LW1FYHpstqYf0121lGjVtglaAYvzmJatCnrzDDN53yipn0/Xo4NCaNu2QJuXLYZRe5XR12ntoi9r7OzI9kenZqythWWls2yPyHUwGY88N/FYGCZdJxVTZwYoLKqG4Gb9GRdkS7ynpK3P9KJRT7deNsEA+2rupVx1IpPurD914a1jJPvcVvqmWJ/sQ8Ie9S/0fwC4CBZFeaKG0QlKBK8ZLSetGnFVUii2Ot+K3x2qynwfxCEzNp8F07aIGt4bpZ6U9oRL0y0+nDFnoQ00cWT/yi1UAGgcZbOVc89oDa/1MvveglViGprLI1NEq/EK1eM/zqBRGI684+J79E2Ya5r8BuqoyBpeDTD7dJrYp7/J8jnPhI0uo6r8DY8Cw2OLFRC7hI9FUmG7LmkoRzSRZ7CymtjUbqHExHrSR2mwRe967aHGQFNyLNy3dF2sODPP1/fMBxBd1sBybQwPkjvRzOMYmVfiwNhc2sSELQA/f8BGbKuoB10uWQDz4OFYm8UcG2NMDiRpyiCYo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 05:03:30PM +0200, Max Kellermann wrote:
> Calling is_huge_zero_folio(NULL) should not be legal - it makes no
> sense, and a different (theoretical) implementation may dereference
> the pointer.  But currently, lacking any explicit documentation, this
> call is possible.

This is true of a huge amount of kernel logic though. We can't always cover
off every single possibility when documenting these things, and there's
often an implicit assumption of this not being null.

>
> But if somebody really passes NULL, the function should not return
> true - this isn't the huge zero folio after all!  However, if the
> `huge_zero_folio` hasn't been allocated yet, it's NULL, and
> is_huge_zero_folio(NULL) just happens to return true, which is a lie.

Hmm seems like this is a bug under a bug. folio_put_refs() shouldn't be
passed a folio batch of NULL's.

Shouldn't we just put the VM_WARN_ON_ONCE() there?

>
> This weird side effect prevented me from reproducing a kernel crash
> that occurred when the elements of a folio_batch were NULL - since
> folios_put_refs() skips huge zero folios, this sometimes causes a
> crash, but sometimes does not.  For debugging, it is better to reveal
> such bugs reliably and not hide them behind random preconditions like
> "has the huge zero folio already been created?"
>
> To improve detection of such bugs, David Hildenbrand suggested adding
> a VM_WARN_ON_ONCE().

But I really don't think passing NULL to is_huge_zero_folio() is a valid
enough situation to justify this?

You've encountered a case where a bug caused folio_put_refs() to be called
with an invalid parameter, then you're arbitrarily changing
is_huge_zero_folio() so it would deref the folio and splat.

This seems not so great.

I really think the VM_WARN_ON_ONCE() should be in folios_put_refs() based
on what you've said.

>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  include/linux/huge_mm.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7748489fde1b..bc9ca7798f2e 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_HUGE_MM_H
>  #define _LINUX_HUGE_MM_H
>
> +#include <linux/mmdebug.h> // for VM_WARN_ON_ONCE()

Please don't do //.

This include is suspect though, huge_mm.h is included from mm.h and thus
this very easily might break some arch that is weird about this stuff,
because a ton of stuff includes mm.h including things that might absolutely
baulk at mmdebug.

I've had this kind of thing happen several times before.

>  #include <linux/mm_types.h>
>
>  #include <linux/fs.h> /* only for vma_is_dax() */
> @@ -479,6 +480,8 @@ extern unsigned long huge_zero_pfn;
>
>  static inline bool is_huge_zero_folio(const struct folio *folio)
>  {
> +	VM_WARN_ON_ONCE(folio == NULL);
> +

Convention is VM_WARN_ON_ONCE(!folio);

>  	return READ_ONCE(huge_zero_folio) == folio;
>  }
>
> --
> 2.47.2
>

