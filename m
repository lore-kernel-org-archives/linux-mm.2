Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15303D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 05:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B706B000E; Wed,  3 Dec 2025 00:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB206B0010; Wed,  3 Dec 2025 00:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D146B0011; Wed,  3 Dec 2025 00:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 114BF6B000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 00:46:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D33B14048C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:46:49 +0000 (UTC)
X-FDA: 84177075738.24.FA23246
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA231C0011
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:46:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IevfRNaa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Bpd8Kslu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764740806; a=rsa-sha256;
	cv=pass;
	b=Xag3ypqPQnfXhwac3tWVSqLbMM84/aokCTk5jbeXJUwT1vobFw6iPGTZ090QqvzpQ8X69t
	ZTAhEmNdAERQrC1s68SFWZ8k0UZ589UmtHwpbnWg+fvMFna1GVrME5ItL6+nWUEdr4w2dY
	+dMSIsZoP1jgCgrVVvQKYympG0d2nBM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IevfRNaa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Bpd8Kslu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764740806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TiyYHVU6o7DVGjscMs2jBx8mMmYJfUMePUTPnIXzxxo=;
	b=sotZJK46fd6RWtEjvQM8f8RoA6qwQWNOG8UcHGjalPhjStKrccf0dHCNznJRfuhMuEy+bk
	kP8YB/ipYHutWmuFsWa3zQ8tq+Ml9plsuOPOmV0FSjHbvDun700BVTLVpg99MlNtAwfbk7
	cT2XPdspFckKhBZUvQh9/WM6vCR9DqI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B32uHVb1706984;
	Wed, 3 Dec 2025 05:46:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TiyYHVU6o7DVGjscMs
	2jBx8mMmYJfUMePUTPnIXzxxo=; b=IevfRNaaiYeFSGE/uAvSZRCKadU3Le+sUe
	yoM4UhAHEI2A0gGYYj2uxyKSf/kRhIXvZOHnTQxaatMf6wMCg7UDU/mMv31mnunn
	QxZgjUjp2LL5Qeo3S7XLIlpt0odhl2OoOjIXwfbKSV7aE3U3Hd47hkPMRl3aYlFO
	/8KrhdPvLI7FxJ7w0lCbnJI9HvFjhDebvq5MlOauSHtvK9fD/Og3y08aQXJ8/tey
	kkN41rnqaM8xJgolbSzVMyf0yW6+ncMUJQQsvIvXLDyevehUSCqvpuKinZNeSTDd
	nWjto64BLQf2MGrmWjX7Y+SL2g/sEBoYA3gVlSk3qfWsa2+dIwBA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7cp4krh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 05:46:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B33AvM4016427;
	Wed, 3 Dec 2025 05:46:40 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012028.outbound.protection.outlook.com [40.93.195.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9a14ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 05:46:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XzDKJ9CVFANO7CbJbVt01pIdntv0+JBqD7B+ynagbSLk4AAkARY513ACJqgcSo/iDBBV/n3TUl94YWsGaoWSCbiduDkdQwUmWpixHNPIsHFpXRuxtiyNVL8TfDbGYZF4lcIsbB6i2bVKCLPAmOkcWMR9/RlLz61fVrWj7Oc1R7zfLKFgZn+f3NLfHxvz7a7ZBd2vqyA98hI5i9iO4xhWBSE2ofqM6cjo+LeUmrtYCKgK0mwYMJs5mWHsD9gXVj0PtWV4RNo0BzkWucxnDVoB44gCKDXG3L+gMGR5XFkzRDOeNhKPW4EjzTQg3suWUqrnJb5NHN1J3aMjmW+ZRml3wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiyYHVU6o7DVGjscMs2jBx8mMmYJfUMePUTPnIXzxxo=;
 b=rAtuDrm4gKlQnA4dmY05fFoRyfn8ln1DB2pP8HKV+kKQW3ECEPMN+zy9si9YdwB2pmz1syAdGfGuTnymKJLoFxlywsjdsGcVYeIZxeGku7N0ttA+ymXeFjrJFHWXmq5b8PPlurmN3wlJVXwDXAULPmx9pxvSiVu2V078oi8LB71gJmrO1tviyGp9K0iFnLebF7tBZepKHGDEmpQwZsV8+FW9HEuw4GbexiGdjupqBeptUGDO0T9Kp0L3GBVl806b2IocVYIGszbWuCjUpCumkLTQNHIelEccl9i4yO3j+GiY1m2t0DRVoxDLLv/xejxCCpB3Hugpdyl7MacvyqYAVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiyYHVU6o7DVGjscMs2jBx8mMmYJfUMePUTPnIXzxxo=;
 b=Bpd8KsluIbRpwCJc+riiVC+M3caXl85prlfKT2cqgpE9m+/g14bnl2pI7dnOGYYUajr0e+XKkjwXk88hEZ+S/Gq8cajl8NHnaC94uFjINNZC0Dgy4oLMl+y6aNI/1DwWySRPzHBQ9t4wdu43vvyTgNO7ESxWxbFnPfEnuePj/OA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB6250.namprd10.prod.outlook.com (2603:10b6:510:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 05:46:37 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 05:46:36 +0000
Date: Wed, 3 Dec 2025 14:46:22 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <haoli.tcs@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: slub: add barn_get_full_sheaf() and refine empty-main sheaf
 replacement
Message-ID: <aS_OrvHmgyhQzQIj@hyeyoo>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
 <lvagftdnxgpyafafl2ish6x6phno6xstd6r3zxffs652lyxzyc@2pbngufu7wro>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lvagftdnxgpyafafl2ish6x6phno6xstd6r3zxffs652lyxzyc@2pbngufu7wro>
X-ClientProxiedBy: SL2P216CA0200.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 539d3df0-8290-4ff3-7e6d-08de322f52aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TwH7gIJ3aunzL+HVOWxbRBly6i8Le/c7IrR0aoUYNwpsdWpadwJjqPL5JJYY?=
 =?us-ascii?Q?/MVRJwCSfnc4lgY2hFTr8GCt2FgjlKNgAn+o/DTvU7ERPqh5sVQYVi/bnA91?=
 =?us-ascii?Q?OupCSaha8jiXYYcFBLrBmOLNTKUVVCClWfoiV2xFLU5XaUa1XtIt1p8z+/z3?=
 =?us-ascii?Q?E5so8Srp4oy9gczW6dqiXQJg46DU20ND9AuVipEmMB/VMy4Xs9JeHfRFLPOq?=
 =?us-ascii?Q?LbAM5jFNAE8RuZDofQEOwFQNJcrnG8Z6vayKq+P/f/3qV6oevDF+v5up4yMC?=
 =?us-ascii?Q?IfAZVDk30if3l6ZjdLNsyt2Mm4n4z9jvEDeyP2hme3YfhQht9a/h/3n57sQR?=
 =?us-ascii?Q?8xQaUeuaF+EbvT4aON7n11M3Y9cHuLctnuX98p681jHTZi/gGE0+FL6Mc3KY?=
 =?us-ascii?Q?6ZN1g5EXTNsIhAu65ZcHEnhjaBeBDmphkI5TDofe+y2RAADGHwYtWrMTHhGd?=
 =?us-ascii?Q?hkWXKxj/WIwaXGQjurmpYd+bcZZfnNSg/bV5kBtKRBN84aYACfJDyQogV4+W?=
 =?us-ascii?Q?eNeBwkakY+wuno6aBTl+z9zOwY8WvDjKwKJerR1JngTzGbonyDGqP+1+MQX4?=
 =?us-ascii?Q?PkyRQSrOSp1SZf19ZyBmXI7fkBlpypbmugTyYxdn620o8UZSiVepn/jK50wI?=
 =?us-ascii?Q?T9zviw8MWxAJMam9/1geN7trOYseMmoK+PmKBSPP70Jmg4T67jWgtc9GuKSb?=
 =?us-ascii?Q?h+9fV4Iw4eib3Pmx9g29zxad43OqN+yZskXRQJP4IA0ZY7MjD6xBXH5rvIAv?=
 =?us-ascii?Q?0+uLp6dUSQs1Rw3LKrNhUTmTWsp6Uub72HUp79KZ8ZfUQErrEqT93QOKMeYt?=
 =?us-ascii?Q?UmzgkWS0J3ONSQRAHtfJOGqRIWejXwaGMBsZ5HOSegHrHCBRi3hrREjECnIl?=
 =?us-ascii?Q?2M85+DeTM0xBrvQYSW/MfokgEPdWSs740YmOdIz3b4v0oKBdBEI7u+l/oN82?=
 =?us-ascii?Q?SYL5pDeXmNbV9PShmZkDcQlh3nFg2NVg+hQGW5kmrM8S1R7x5BvC62dWq+pO?=
 =?us-ascii?Q?cvJzuf/zckyCnnhX6G4+zf2TkscjM0Edh1BSHnUHcNGAZGJLkhz0VB+TYHTB?=
 =?us-ascii?Q?N/rDHJONPDFlKmqGTaoaVdfnIqvLNEjvfPe2+InY439ZbRO/25st2qvSx7GZ?=
 =?us-ascii?Q?yCAuqRt+SBD11VlF+3bSBzErxZ+U8KjBifB9KkgFpBoF2r58NXwfTImFZtN4?=
 =?us-ascii?Q?1A9iEja3hMSpsuzCnIwvYbUcNc5JBEOtTbQIkW9zRrp/u7jRF2spZcq8eWwO?=
 =?us-ascii?Q?bKXrUSPH+n54aemAY7zOErxhYkiSq54J+/9r6i0wGRcpbsk9TvHrlYI87+8t?=
 =?us-ascii?Q?MxDKduiUloMbvYTfLocru/dh8BKsrt5Zs62/aIiBGeT0okczMqKyZ39r9JtN?=
 =?us-ascii?Q?TaHtmMUcbsT3TCUdbS2aZ7w1NWp4zxsiWXL7BtLNeixOsTrhRuhcKX5641fy?=
 =?us-ascii?Q?1rvCL7ps0IC3BxQUuwpAxHfjRMPXkG46?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yay0Znig6rqDDQmbscs20yHAdkBmyBldsw6fcI2p6kQ0UFLxpAP5NmIE+st/?=
 =?us-ascii?Q?bllMKnBbuZPP+uew6FgHzhbfeu4swYq3uu3fZrx95g6Tl/ZCelp7fNyVZO+p?=
 =?us-ascii?Q?5/MBx169ZwMZWdTNzq4nudrthEzKXS+CsYXnVp+/BicbdeMKWn0KPaAurraY?=
 =?us-ascii?Q?+AjvVRjzAKqBOqqbkP0fblD+Lzijc7fOpOf8zcCHzC6o9WzY+6nZxRivS7gy?=
 =?us-ascii?Q?DxaFN0Db9Ob7ykt5jFZahmuXlUeCERgLz3ejeTL+fG8r4ofTARL/5UKzBl4/?=
 =?us-ascii?Q?pvK/9qVhmnk0WBf5uUlmlMtTazMFyl41HRp8Wb1QVjmEXHcELF+KQtL5TkBw?=
 =?us-ascii?Q?QfCrG+90vUgejYTlzjXLVv+D0/Wq07mo4PiBS/vQwli2bITqj/5ygdTTJ4kO?=
 =?us-ascii?Q?n1eQea+fqzwYEdpoMQWMLuBJ31GuORCXG9VWUjaBbRyiw4NdVW0CrhWvyfS/?=
 =?us-ascii?Q?GpFrxu8vhJEYvp0NdThLfQKi/D3wafgyxTW/jzFICKRaKQyzLBGZujQoSd1l?=
 =?us-ascii?Q?KDUGUtvjJhSEDvB4L8EWcX/OSw0NVAE+MUMas9yfqRqAQyDaKlIt2lQJy+HO?=
 =?us-ascii?Q?TW5uuLS5o/JzV0jCgxQb5QijDU+fSlgxVskUdz2j4lcbylvbS3C+k7m8rODL?=
 =?us-ascii?Q?5IjORONS2viNS0NRsWUTw8i1pC46XiJXCbI96POFzr077umrn6z/5EPeCTGw?=
 =?us-ascii?Q?HV7OoQaFWg1o3NH71PRg3cfcNiDnIOYITftXcZHGV5Kh79aQFobkQk/nfZ4I?=
 =?us-ascii?Q?keIt4u6F4+mMzoR4MXeI/BFUf9kY7I+lufS8MXPEXn9FgWUDBvIDRNllusfl?=
 =?us-ascii?Q?abRkVe2VhQ1MYhSXtloKVtxjtmygeOcTKtkQVUg3q9Lpe5x2SI5x+81rvWep?=
 =?us-ascii?Q?tye1rkGYcJsvJervO2R4iq5Km0kWz3JHBSOxOqUlgaGmAHmWvYElg0ICe4gZ?=
 =?us-ascii?Q?oUR6JyW/p1DVZQISV7iZZ8x9T8QNbbxYqSNkvAeeUbqNqtso7W25KThUmBhq?=
 =?us-ascii?Q?iteq65rE5vnL7vWUBxI61A6nFE7fCYmBlZyDMoellf3UrVOi6/g+XN7I8WE5?=
 =?us-ascii?Q?2BwR8Ns/ILlzAxZNHgnMeytsgc7qnr2/wQy76sWGZV8Tz0MLUKy5Im6ncMPE?=
 =?us-ascii?Q?HBRLSHnHpfxjC0JrJC+FpIUbk6XXrErpfzqTIsi4J+Dz5n4ueDoaBWGNgeO3?=
 =?us-ascii?Q?MERR2SGwbS5NBNI8zWYNCKEFPU2JczvdzJudoVAnB3XTBIbDT3Ht6oKCvu3L?=
 =?us-ascii?Q?K3jcrrUSICDfwysKwIXRWEv91yiTwRXHgb9OKsNCQeDQQ7GzxeZESomkPluZ?=
 =?us-ascii?Q?AXNyl+SoIB/RovVXXdo4+lmwagHp9OliZ7KRAKsLi2NbeXyDEpMQfpFJF030?=
 =?us-ascii?Q?odVpx73/xacazQxl3H+/hVHy8biJwebxKjds6hxv6pv6ROddScZYrQVuA5fB?=
 =?us-ascii?Q?98sKlXUFDmdF4TPsQXfqsc4ra9IE+CxeZn130M3QLiBm+6rXpRV988kixE35?=
 =?us-ascii?Q?WWU2tHKVgM29iuMBUAj6vuF1nqhajtpSsdlXmVj4+TM26iEP6nMAZfggEwTt?=
 =?us-ascii?Q?m21vsZXjgoyY7VsRxlW2uzZnlt0bSJydsCTyDM+w?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dX4mK9PPBtEdSPvSdAppqlVf7+ikKdhzSQio6z4KHzSJlW2L9glsYZifiszN1vsN8z62RsnIrveoxQ/9YlJprTF1IeJ1pJQfkFlGqOGhsVxcSXQ8H83pLY8EdEQCK4agG7G1EWq3/BzAjTZvOKcTGKrbbS610w4vonAcEyiSq7Vrm1WGgPLYTsemG8H6mHpZAMRpHwNj+TG+oRkKusPP8KGN8f3bfnFjo/NFxyDnod4hU+Ka4OPXy5vI0nwCTJWA9LQcqBzRNUx0M+crIG1xCEZ6aPJfBbw41f8zZ5FlylSg7t1gBjADqdNL3kkw0zC3PuZ3C5VbVOWW5gtksbb9YC2TZKSMBnByvi9MijfO/pl9c8lNGo0EfgWfJGkwnYII24ZexFiYQ5bwZKtnzE/CDAQnADezb+c4THUVx7+2EpMjdKzq/t6zDUuDlySGKYzhQKhPuBRoLa6jNmcR5yohSDXBCjzWU4Z6p5dEPqCpVZm+ixs1YmBiZtbsDFlfYsxKe1uh3z2HHWcuPzM76vlV/6fJzNCxihWXaGdYccC0xEVppdK4eauAQYUpOGmCjQWOGIZ7p/dp3bgluD09wqTHl+J30fdkTIwDnkXfq2/r2W0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 539d3df0-8290-4ff3-7e6d-08de322f52aa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 05:46:36.8144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oT+S75yeh8/GUWntyOBWcQFsdjH0wo8hwJKHMwAMKegp1ZAPtoTMKq156A6z6aO91HSiASYdkLwspekMcgbW3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512030043
X-Authority-Analysis: v=2.4 cv=ZfgQ98VA c=1 sm=1 tr=0 ts=692fcec1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=xh1pBFeA50VaQeRuJpUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: wPuh4ZDuk2X9tjp_DNbTvqippkBjE_zf
X-Proofpoint-GUID: wPuh4ZDuk2X9tjp_DNbTvqippkBjE_zf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDA0MyBTYWx0ZWRfXwGejYZneQEUz
 Hyp1JrXCDgBbqlhs1zj4oe0GIJsPBOo+ePuH+v6dXsmzvZkYbXZlDUAguPPzldSAqbpXtGkAOMI
 9UDNi2FUTMKaJUmPRqbQOhpms+cnLerFVAxFe1jNoWjelZTgACbBh1TOBVnZPMx0k0LAn+pvY6g
 /H87H7w2D4AN8bt5oGOvD9HU/1DEfdLnrGKX94SIXTzNyHnyyU/OyqHX3AAeA972dD0CPu9x6s6
 0GXhDeX++eCgrypYLWaUn4uyIwSj7e03oiqPUYCoOT0S/K7pQWdm/hIwG1znL1xkF/zflgF6vx+
 cqYL1FPFumhbX9K4EJeooL208KpsPFskc2kTHZgdWlOj+q02czmzdstc0/fiBsZo5/3WRlIIha0
 HHV0xiLSqFT46M96ZFEBlABBMdV40Q==
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA231C0011
X-Stat-Signature: xc3zwxrcqrkzf94oi73ce8rgrmhebaj1
X-Rspam-User: 
X-HE-Tag: 1764740805-594104
X-HE-Meta: U2FsdGVkX1/upMqtjDoXG1dyKHlr7aFOWsKNF7k7bBpCpULJpSSA5tJlv8PtyPEP7cFsN2XK+9M9RDkqLCRYgUh2VTvAb6V6EeLdiWiZTMN0ssoHsCcg5dXw9w0HmkYMDnykjgbvzwztNWP0qvo8ri6/QzlcbOVSGwgjQTbfzmvAo8l7CHCgLcmSJKTxU5a/1J144/vUkcNG05RirdJm39M8owWtElgknaBlmNzkx86efnc4coIoMJp2t0IEE4zhTcj6ilL+MA4fFXYmXtA9CHFL6iiA1VZze8qeYv2trHmdC5NBgnDPvJTOplqzco0scio1qiRukLHPMMBXrYOENIT01izDwVNMcQqIrfnjOneUontku7yMQZaJcQneumB6Ja+VyD0rjOrPELnl7Ezwon7g0Os2WbSEibDJbvGpbtS0RiuogXM6yS5WAjk4t6g8eGRwTTUFqB6LvA6lrcKa9/VzZps4iBGwaMDIsnmLUaLNMOXHCeu20Afhhk2k13SjEsCIE4rImpWAPs8iycbiKlIJ2PfU5Y+u2/Xx9fXC2KvHONy8IcWWHR4Z9wHDsiA7iGmaIsuToZNZcXNPdgnAkuh81lkzqNGAYcsB5q8bM7V2gaCq9PI+x5XQvTDfYAI/FfjT8lCEvfiFB7o/KXhfhigwspvUn59VxK+EjnlcI9ZjbFeS28daAQ6O7MvK9OJ5CXL1fQq8t6Jm3GCOUBgz6gjbZhRdevGmm87Er4GIgj4dl6SuqGnM2dV1sxcAmX/v9u/PhSuyMmgTPJbP1fkscv+l3KLmiqL9Wdc/IKIihMdxfbisVa5vNDDVDYWAdik7oOMAwyuZ9xjU1+Y4Hbuu2ZIPAhhWuF4Ps/22dBzZ5XyXh28qKaQEkn8xLoAAGCNlR17ZlxyTmzQzDbVO6hnyO96QZ9qHXHFFrtLWk/dX7M5HHc6l8gCOXj8PiOdffThxVN9YE0E0IFeg/JZOOtZ
 7ZJcZplc
 HJEdb/OTHgG+pvG+bj1oLhXsOEhejky9+rAOH4VoDnahz3gtoZWKAjsF69YlIxYdWarowDI2o8X0tunvDi7+aQT2QR58xu9LYA0YXji8+BsqW1sUQi2yhhFxP4MD0pnzYEiOssUx0RkOkqgoXqX7xo613SUdbXfLK9YBqf6cV4Cnz88siYZ6PVfvgSeEyahZB29cEO7V5Yrze+Vg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 05:00:08PM +0800, Hao Li wrote:
> Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
> the per-node barn without requiring an empty sheaf in exchange.
> 
> Use this helper in __pcs_replace_empty_main() to change how an empty main
> per-CPU sheaf is handled:
> 
>   - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
>     full sheaf from the barn via barn_get_full_sheaf(). On success, park
>     the empty main sheaf in pcs->spare and install the full sheaf as the
>     new pcs->main.
> 
>   - If pcs->spare already exists and has objects, keep the existing
>     behavior of simply swapping pcs->main and pcs->spare.
> 
>   - Only when both pcs->main and pcs->spare are empty do we fall back to
>     barn_replace_empty_sheaf() and trade the empty main sheaf into the
>     barn in exchange for a full one.

Hi Hao,

Yeah this is a very subtle difference between __pcs_replace_full_main()
and __pcs_replace_empty_main(), that the former installs the full main
sheaf in pcs->spare, while the latter replaces the empty main sheaf with
a full sheaf from the barn without populating pcs->spare.

Is it intentional, Vlastimil?

> This makes the empty-main path more symmetric with __pcs_replace_full_main(),
> which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
> empty sheaf from the barn. It also matches the documented design more closely:
> 
>   "When both percpu sheaves are found empty during an allocation, an empty
>    sheaf may be replaced with a full one from the per-node barn."

I'm not convinced that this change is worthwhile by adding more code;
you probably need to make a stronger argument for why it should be done.

> Signed-off-by: Hao Li <haoli.tcs@gmail.com>
> ---

-- 
Cheers,
Harry / Hyeonggon

