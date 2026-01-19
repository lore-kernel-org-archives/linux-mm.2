Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B8BAD2ECE9
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 21:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8731A6B02C9; Mon, 19 Jan 2026 16:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C436B02CA; Mon, 19 Jan 2026 16:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6750E6B02CC; Mon, 19 Jan 2026 16:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5095D6B02CA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:00:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F88657BD2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:00:03 +0000 (UTC)
X-FDA: 84349930686.08.841C39A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0B7324000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:59:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FiiUh+Tw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XNtcy5jL;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768856400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=81P6XbGZJiDBnLBSB3EPgAZU11aKCNakRQHiNH/LIsA=;
	b=27K/mbw3Dkk9YuVwOypko/RtLRcQAxJR3inLCm8Uw6m4XXdKN8Lu/emdBz6l4gsOUpm9Q4
	3tcNkcMKwd8NClMFW+Ad2c2zyCIDbC7H+HCnsfXv2228bpnp+tAx9Ax/tfKiQ6aPpqW3eb
	1B0fkj5hx+caHgMOHO3jIQezjRBkmhQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FiiUh+Tw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XNtcy5jL;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768856400; a=rsa-sha256;
	cv=pass;
	b=e6R1dN7QEMg9VJ27L2Ky7clNsNoPOz+gdfkbIn6t1UWUhH5e0O1ZRdENdSTFTnk7zzzHql
	L8fsG/0HnpypTQKIYx/iINkbv/bMWmbDseTkiduK1wU2TFkPcQ40e25IMs/6xw3ZUwxHbA
	ilftaBMiKTu5vkZHIHK5eS6q4+s1yeo=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60JBDYN41269595;
	Mon, 19 Jan 2026 20:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=81P6XbGZJiDBnLBS
	B3EPgAZU11aKCNakRQHiNH/LIsA=; b=FiiUh+TwgLU5elw2LsR499IE9XiSRgFL
	0WILoK9Rc+qmAkfZk3JRHLMGU80xIF2CjVk6gs/S3ehRy6KeReLCO8hTFn+9IBF9
	ngWXaLq94n93ncz/mHE1sghAczSneeipFZrAmZ4rkIQKs40oJJdxS4ZTV3jhjJae
	/nGcFHQOboOASiQ7L7tXJxVF0G8v5dh0zdvgGQ+MZj3AjnyDg0N9MKSCEjIW6Q73
	2FwH9eTv+GzvhLnvoIY7TygAEni+QDr6kWR2e/qmXke/3pSQaDRsEt8P0b9C/fO6
	PLqqk+KaWaPzoq1BjzUF1zFSokwGoTPrjg2Tp8LHmhQ8GxEn/my5JQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8arjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 20:59:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60JIBRSV040518;
	Mon, 19 Jan 2026 20:59:44 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vchjyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 20:59:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GP7sh4sP6Mk4+aincKNF648wEtA293DOnBR2A+eZTw0U0Hpk3ykJugIgayT990IbbzX1IrdGfZQNpL6CQOGGiBgOxAkGlZTodFA5vQxZZstay/nHPFOLXiEjsHp5aKYwmXiqjficu+D78IRTV3N1yLHTJcI5jXtT0c/KIYn+c9lHIb9/fVEOzasIaeYmbH5KWtSHQd15gY6Y4s6FwtQB3sCdQtjVYXoTwQYm3vCK6+eQeSWYwOXL391CzSlQc6b/fK8Yf9R74uEenmEhCXPCB/jv8zir8ej9jBQHs/SDisLvPoxFMGjcJ3Of696esQh/wjf3RaAjgreAWAXTL8LavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81P6XbGZJiDBnLBSB3EPgAZU11aKCNakRQHiNH/LIsA=;
 b=HfrrJGs7WiagYbAr+jjaNOIKY1f83yGeCaCJi9Vm2tV7pyus5PzFpm49iPC6USqvOMxS9nQCSSzubGfW6D0pODrArIGtu8HugVOiUBIWGAOgW8ws/BUJKVqKgQGkf/hPzjE1mrtGa+k0qcZ4pKUH78oZp4KsMSpH0OTTV9X7aiE/jb+stm0xxBq8apmbffOGAALqcwuOtQQFaUzxOR8ChoZqrWOstW/AnUK5P4ZRz34QvGBmeJ0NNMz/CNwASa/9xfaGSgbJaEQa1NmsyY4huMQyN8z1WJ3bA0aPmn2GxygxOaNeWiuA+3EDZRt55P5+Wwfr8OyruA7OlOF/oXGUsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81P6XbGZJiDBnLBSB3EPgAZU11aKCNakRQHiNH/LIsA=;
 b=XNtcy5jLpm/PSWpZDF5tjdpYErtO4k63fX/wf+C2hc0KY9YagjElwQPgTdVVzKjaOMzn/ZeY01b72Lt/fHr13NfuNGsuWF7HuUDpLMnSFHYDFSCaAOeEl0cyrYP/L1GP2fE3+pD3MnC4nW4tgcrXNR1krFhPaDdTjDd3X0b7Wxs=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA2PR10MB4780.namprd10.prod.outlook.com (2603:10b6:806:118::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 20:59:41 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 19 Jan 2026
 20:59:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2 0/2] add and use vma_assert_stabilised() helper
Date: Mon, 19 Jan 2026 20:59:38 +0000
Message-ID: <cover.1768855783.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0122.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA2PR10MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: e7619c5f-8f2f-479c-307e-08de579daa08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T4UW7M1d7XFrFxchvrjUtba0lMkkI7UxsIZWDzchZ3HDkxTph/+X8wGOKQwu?=
 =?us-ascii?Q?g3EFnuYjJrc1WwlnmnPzt9YKUt0nDdOHqTLJ572/Y5ixPiUk1UwsA7SSEAz2?=
 =?us-ascii?Q?2SxvpvdunehE/32fR5Fl2efGz/daXZ0QK0dUWyb4MlTKvMawblL/iRvYHzcY?=
 =?us-ascii?Q?VC0Tg8MBPrO40nuOuHacteRTqSLTRTQy4KQPihr+OI/KW+58VXuaXZE8ODk7?=
 =?us-ascii?Q?HkNHFf2CwC3w+nFhd8KcMcPC7AEvRvXP9WmxkhwD8FRu0oEOuxRiZ4NAXUGc?=
 =?us-ascii?Q?p3EveP+NWngGMp8Ehb8fA6lRS7bKsw6QsMu19Ko24ereNfeV/+2D+y22xqAO?=
 =?us-ascii?Q?czWgCoucd9OOlxgjz7FJXJEdattt+KXjEifD+2rX7nQHDUGBRxUe73tYn9xL?=
 =?us-ascii?Q?fZ4KAWk/gfJgVJAuGhUyntdm2StYxJVBDn5YJwpFEF8l7Q4sphXG31ohS8oq?=
 =?us-ascii?Q?Lu/f6gkK6svI6LsVpEc9BVqX59RHYjU4TxV39OtJjMr69Okm2g/BPcYX1bfx?=
 =?us-ascii?Q?2MPrm6/gPv+7185Ua/M6Z4TJPz2/mhyR4lXQwHC0nU6Jtjy+yC29NbIKOJkf?=
 =?us-ascii?Q?NPiKabfVmUoUq0gkT47NRhD88os8vpCkQvtFJdaYmkpGdeDXPrR3vpluAU85?=
 =?us-ascii?Q?lFgyfxBXSriGoWcn7Wx2TgBcPqbXfEA+8QDsEN6Nr7FRoyMziyg8OVCDSH+w?=
 =?us-ascii?Q?qb9EeCdr5E+GQqVIgmeo4BxI4y/Odo+hrvPgbXxZaLTJKq39rbN3ZarsFQcl?=
 =?us-ascii?Q?USPyCxZg17cwcpY+EKCVUvPqMj7JThMsCvEMSm+qj2IZIddagjhw7KUDR5CY?=
 =?us-ascii?Q?7mNm7E53142UTRIrbl+wnCAEK5A+V+M9J0ewNWuHwPcCTSirf7HGa1NCxbNf?=
 =?us-ascii?Q?Aj4rFkWuB9HmcaG7u4kktUL40a1JL7KSP0/jcWl2xXjAkggluFE+aoTxR2Hp?=
 =?us-ascii?Q?LgKxkTtRqoho4mVx2TRHqtunHW4j9fwmC+hkaHNNN8uqINQk9KOMdn83upqd?=
 =?us-ascii?Q?N5bhrU/jmq9sMbVT3kJI9L82qwTemh/mElJWSRXRuxpM6Jz30uXp6aiiuh17?=
 =?us-ascii?Q?f5vIMiM9sxG83G0LvpMO9Od9hwjfOTj6oLgYqFCoIAcsqEQqCjz1kq+kMqPE?=
 =?us-ascii?Q?CXG5tDaNrjpaS/5EyxdMfkcgCMIFwJFmSe3xeMfHce/0MQoA78aeIQr2dHdU?=
 =?us-ascii?Q?EP9oMJpAHH4xOn+8j5Ikf2FkmY3oqoKwEo+jf4AmVmozL7FlSsPFPHOCGxYi?=
 =?us-ascii?Q?GBdNgdI2T/tFPjKMCrtb/uR96uxEaUIm4B6THmCj7bxsCzGcdkVDIjCJgMTq?=
 =?us-ascii?Q?E7sdx20YXuW7DZe6vhOZQ7R3sM94ELaZQNuJdoCMFsGTm7zlcCTKtkwCTq7S?=
 =?us-ascii?Q?IRPf9cn9hHAWFBgcDEWaqW19+kWNNAWOfA4UufFH9fu/mXbiaMERMIa6CAxa?=
 =?us-ascii?Q?mBfAsIgdz7QmbBOeO0nmS5uQBcOhHar7I2ylU72TwZFb11X2ay7t4T6v2O6v?=
 =?us-ascii?Q?Vzyq+tjNoPtg4Jx+AWdJ+hAe5KgyA2jc4d+INsTTqx8zMho1d8WAnT/rD0Jj?=
 =?us-ascii?Q?4GnTAfxwQrxX5e6ffME=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AWMdEz76IoWwLsOIT6IhVjUamoo6GoTENQyF1WZk56idtpcZphBjWpTgXVXB?=
 =?us-ascii?Q?LDtb33moLLxnj9vYFwAifFXd2dNdWkjbiuzu7zKMYV7TxyP3DmTRpuHrdKXq?=
 =?us-ascii?Q?Jw+/hk38Td07PWrw671HiilF9JJUSZW6fzSo3EEQkISE9ETj0MasGR1sz+eU?=
 =?us-ascii?Q?4B3gn/XNW9E/OE6j4tQvnJmMkvS0Azydjn+5hed1hxgKkoDbmn/l0cXIBnhp?=
 =?us-ascii?Q?qQ4DprkrtU9/wUyljW90RNlVmQWfSRBmDNsQo8oxNqAr1ygXS0/znr+dHHi1?=
 =?us-ascii?Q?aPMW0VS4NFDQuykllxcfkwnvU+OBBr0qJ//Y/nox55i3eQVXHLeEg/kekNVt?=
 =?us-ascii?Q?9getzL9xQEEbwyqm7gTqSR9nNH3N93vRmNhS1ZOUeReTwnIv/sEWkvcAUPP4?=
 =?us-ascii?Q?tJAxcj42JNbYPyO8r6xqMMxqpVeVLbcrHM2YzUHxyrrRF40DwuNQ+bYg1Z+p?=
 =?us-ascii?Q?4IEqDrNbcthqk2ZhqPzRQV0odC+5iMoHHGom06p6RkalbVhVlYV/IaefX7Kc?=
 =?us-ascii?Q?lRoIIz4wnbFLRK62e1qdOte3UurlFPh2HM7nHfiy5nNOMa8Fh0ISIxLglHNL?=
 =?us-ascii?Q?WMQaaApOn0Y0VUvIsOKKfZML3elBQtQL5WXmHJLnUlPQFXJieZtM2K04oPrV?=
 =?us-ascii?Q?TniovaRMCJ5PzohsINoEzFbUrn4qI34eR0WDUuenvyrmbqbfa8JO+/Mam3Hi?=
 =?us-ascii?Q?pHrVCC4/L+M+5AhT5gYCQRki+8NeetXoFW2788DRg9jtG6qUVSN/L8XTb6A5?=
 =?us-ascii?Q?LRriz5wMjLjq3GW7ABieQzN5Z5dhGLxQlkuRnoP7CmtukJu7Xr1aF5yOySvJ?=
 =?us-ascii?Q?k2FptAsSNvMxmQhafWny8oK1Y7NTCKVzK026cKG8gURjac/z/OlsDxWoDZ8a?=
 =?us-ascii?Q?RIiyo5nmE87HyV1PD91JwkOF/qJ4pN7DABi9IWwoVT1f2UoCUCJlAPfIX6VW?=
 =?us-ascii?Q?u2fRJ5640mfHZOz2MP2sacN3Ib01+A9NuElKzSibiTwOyrABmwIt1spmnP/A?=
 =?us-ascii?Q?Qv635YZ77egH+0sTC9ftMUwIFfEj8NkQfFwzVcOS9VLkXNnF3GsmTqidP0QA?=
 =?us-ascii?Q?mf5H+pjJPwGl2g9W0CFoqdxDAXMdNbcLaYwwrIpD5zgwX6OESobiV9gHMaga?=
 =?us-ascii?Q?0XocWGNOS/zuFev+FQZwA2ZUgh8wIrM5YSbkxnNt3f4EvZo57AtlJzTJRYrt?=
 =?us-ascii?Q?Ix+0W8DZRodySy910BXT5NOwXTV4BH8TedAHbv4zhGwqGcRMx92Xoe0F9yX/?=
 =?us-ascii?Q?fnWt0hF7sIOmu0MgEZSzpSzQZsixWQ1sRk8WhUVF4Wk5ouOnS1q1cNCiObPW?=
 =?us-ascii?Q?N/6NIxoYE/H+Z6dDvYmjPWyBTfm0Q+O8FzHPpHuZjD0LLibXs07IWLx8PmF/?=
 =?us-ascii?Q?UuVDQoV7U4ggE02+kkHo87aVhge6nFL9m3YdBa8fQEWQLs/pXWkyDxpBBKTL?=
 =?us-ascii?Q?sg8P14h+uh4dfFB6y+/9j/GmF8+gCwuj2VIRW+UKgX30zRgEWvL89bFNXS/o?=
 =?us-ascii?Q?vSfk8BGRlkepBRi8wQtcwPiXpJUV0cF5PILDaC9xq+0eV9C5P5pYaXmgdjR5?=
 =?us-ascii?Q?N44YNu0dIZ2Mh9NEnmENdQfNS50+KjlFuBLxosEv+2AF5Niy39ShAVBfOGdZ?=
 =?us-ascii?Q?1E1f5DJUqDV4YWnwRhtxmOke/J8JUo8Qc609HPmMZDj3JVdUFDb5/eEq7806?=
 =?us-ascii?Q?O+bpl2VA64F7hA4L1wg3vqzWJU14xGRX8m/RYm40squr6bjL1VXY6ZmWH4Po?=
 =?us-ascii?Q?f+gILorfp9fTr7x0yAQJXMMUI21UuTo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pheTTftycxc30WhXdkZVpcOlYhiOX+7wZDhxiPrYvNLfmiOGkljLjYrIt03ODzIka7HycfOvv5W6DvPPh+vSNlMStvJe0A0qP9rhEbxlJx0ot4K7Nk4+Jp6p9811AUpWs92jCsmpJFscm5I6VKOYvnwjpDDAC1DMZ+HEPi4XbWxzbh+RbSpAHa+7JVpmJOV369+PisC2cOkut/ocHgylQU+Iz9BeqRGwpRf6mkL6rtoJdW5NPAkFh4QPpZ8UTlC9uSsop4HlSv8LBsegJdzel1gwQoqxt9JvU3kN/wkNB11SBO9C70j2MYzjuozNElln0IOU5yYu4a9VihQIBuLNZra3jfne8wEl/0BbNpBwT2uMQIv3o4YEP+zJIZWvBRl8TnOmebMkNihgOhh9u7AiIAgkwCQ5Vi725kyOZIcAlxSdPsQsqbWJUgYqhI3xn3Ru1z4mIYIZuXpixzZR+hBbU9FdaoZDvYDcvT3XmL5FIZ4QvIHy+qNL52sOx1/10BaT+TvQRbRTveRWdU5r5Zga87F48F32wHrDInRkWg1vVqcPtwKaMvbERVIKVCUmfD68UQv5VEudFHuDlXBlggN6z4qQa2mXx+Ldba3Tl2QLh5w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7619c5f-8f2f-479c-307e-08de579daa08
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 20:59:40.8355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pK4SQte05vGWKHixodqnk2nUQsO518sbiirke9KPnsquVv1nwLSnl0zwjZMEQUNuFp8t5NTod8KaDoBHEXwCYq++tVwbdqWN5Q3rJ96ZvVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_05,2026-01-19_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190175
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696e9b41 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=rO1NgQogUKBBMPraJRgA:9 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDE3NSBTYWx0ZWRfXwIb6yE6Oq1Gc
 OHWrGXqtZkMWck6CO7BHx/fpHsvZlQnfj8IR/jm3OpuC77tHQ5KERkYKBqROR6OVfAAjgC9ybq9
 HhBemS1m3WRGyYvE12VxColzukIBz1DyBC8E/aEscGS0SO9nY1chB3f1bek1fvzeJLmossmso4N
 BzthWVdL3UlMp2CCPy+YYcq/A8RCpEOllU81P3xP8zPskP/QrhfJad8BrcQl13aL8urp+rhYcWz
 glIbAFwOdvc5sRxfPmR3jtAZlYAyT0oWrQebxI1vMtC8o7g4auyGiQrk0e8bKBP1U/OnD3yktzN
 zlNE/9XFhk+reE74WbcUHuWaXDgJeW8gpLxi3Zx7msGPcvX6HGZ/aO41t0qAb0zpyuCLxv56tXq
 uei1IYfUJWm0NieUsFn5hkkJQn2XKHFQGvR4bp8HER8z95k9OEX7C+HtWhum3spCX/X89RFMGqy
 IqL7d4hrVi4ItmJ2b49tbtNTFKom5hG9x25cXq2o=
X-Proofpoint-ORIG-GUID: ulvE2alG-PxX9sYqQ4_sYhYs93PFpcWz
X-Proofpoint-GUID: ulvE2alG-PxX9sYqQ4_sYhYs93PFpcWz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B7324000D
X-Stat-Signature: 1y7opmje6cca1w3nfz97ywujxaidjhih
X-HE-Tag: 1768856399-800084
X-HE-Meta: U2FsdGVkX1+VAAZtRMsA5iGoCR9Rw8O6e01Ym2BsCbG7UVpHUG0nLJYqNiGEbMC3HYXCj+FIjW9dTl4i0IsTXEB+foHXBPOX5YIakbosD2NaASF1mXiwVZSpfJ4rg/w7EQIRhBqwcDzN9NvoeDDMJkm/WaZZcLBtiWF7eEHo9vuix/R90prXN8i6phGh/aiC0cxH3Y9tW72p9dtNWG+9JCoevqFOf7yhg4jTJDA6ZZfRlEwBkmjloUNCZ1Ige8kLDVDnwcZEl3NYdYYEtXCWDWRvVGrsjfP7ydTp3vyhLuH1qloJKsKDXnvJugZzVgP6KcFVSGxsjDun7AnF2WXcaXrBUjEibbZCbA0mfpbHaXIakjTGZY1nUm9CpCfHOXXhdE7cNpdZX3u8uOBXwu50qZZg9LLH1abE5qVEOM6BPZ79K8+1VHFfB5dJ1WbilWbTTfr4bLWN75ItggDYjkQ+ANi4OoHIgvVmxmoZ/N+iBiw+mGqvNDi8USLnvpdhOPFPgxSdH4+IXnUJ/LaYullF6V2dea+WeGxo1lnR2/Y34hZj5s7qPx7wHrB5Wx78MJ+351pMiZvtTFFBluW1coOuNjAfrfF7Wdab3rkLsX3FsIaN1d+1hxj4lzvzbBoqSjjxGURghPKn6vQuGwWSqP7+RBJIjywGjnFfd8c7xrRZpVfeLjladzZ+zidFC/rcdPTCGmg7KiFxJCzLXqivJiZ81DzWcwIbmffTTbGeWe7y8kSqBnG3GZ2TdBYMujm1ZAYl3zGq3egLDTrfZF037gGbKpH1WwRNvFqKLtv1bS8fwSH6ozr8egnia+buZ5Z/Z8zts7jJACm9NFNnepWmzk6R8bz7zZk4pcqszXI+ZwgnuW5K1yRPToaCozv6PSStCAypngxI2/KJ9Sa/+WCj/kdhj0pZyZcRiN1Hrlb5g+malrt25S3Z6ovXjZuYfzPh6F326vchuf2+JJKft+Fx1wq
 JBGfK3/4
 B3BZcoortAJG09seMjtO4IrKwBM4xUP+NBiD7Zas9Qel+reUowGtbkYmFYBPnbmGmvq3QfrZCoQEao9a9tvDm6vdWqKjp9dvPyTBjRLq4VCuiFhZY0PC0kqmuMME+wYb8VYO6YtVrU6zwm/v1tJSKa6o7gwMyVcKj+mJIT4lvz7Ieym2VuqoqWxtS/mSN+m5sn8gTphW0OgRtZCxbWT2tCIZ5ufYM7sGM8+t7R3Hsw1yJvwgzzR9jAzzE4jdxaGmJt6/+zEi/4W+f8slmy0rV63vAfz3/NSlr+yiI5zzfP4tKEbixTogrhiqZEJxBWLBqOWtl16zCdobgqLZqBdDVno716bglUp5CAKcztwlNcrH1V3VY7CxjGq/ukbP+eYCjYoZ7kWtG/aZysuZ8Hah5Npwf89wlw35e0Wq61DaIFhiNBH2YOrkefDZiMprXN9RWQbWuhy333xjzs9ThXCLY5y8X+o29f/MkpiXXMfqj9dNNVbfBBqzxo+Unk/ucun/SCeqoNKp5QEE6fVrR1zZJu11S/s0s4nkBt+h54iFXe9MG4VGH5vgyLHaN81pDgtoYNKXoca5q0aZqf4rQZgo/0b0XSe5/PpKOEfWT+HkRecveld/WW6pyo7+U1jhznOUUIp/zMnHHR99QHxOT5kYl8RRJMgAgMPTRM6s7DaCSW+eXUNcjHe1lTzpFXXWQTAd5OoFd8W9LzvM2y+XSfTWGUsToe+c1WPZOUNRzOerC/YqNIe8gwi1v7P3jYm6nu0s4XRXC25rSotAhg8BEtfHGGZkHRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

We already open-code this in two places - anon_vma_name() in mm/madvise.c
and vma_flag_set_atomic() in include/linux/mm.h.

This series adds vma_assert_stablised() which abstract this can be used in
these callsites instead.

This implementation uses lockdep where possible - that is VMA read locks -
which correctly track read lock acquisition/release via:

vma_start_read() ->
rwsem_acquire_read()

vma_start_read_locked() ->
vma_start_read_locked_nested() ->
rwsem_acquire_read()

And:

vma_end_read() ->
vma_refcount_put() ->
rwsem_release()

We don't track the VMA locks using lockdep for VMA write locks, however
these are predicated upon mmap write locks whose lockdep state we do track,
and additionally vma_assert_stabillised() asserts this check if VMA read
lock is not held, so we get lockdep coverage in this case also.

We also add vma_is_read_locked() and update vma_assert_locked() to perform
lockdep tracking for VMA read locks.

We also add extensive comments to describe what we're doing.

There's some tricky stuff around mmap locking and stabilisation races that
we have to be careful of that I describe in the patch introducing
vma_assert_stabilised().

This change also lays the foundation for future series to add this assert
in further places where we wish to make it clear that we rely upon a
stabilised VMA.

The motivation for this change was precisely this.


v2:
* Added lockdep as much as possible to the mix as per Peter and Sebastian.
* Added comments to make clear what we're doing in each case.
* I realise I made a mistake in saying the previous duplicative VMA stable
  asserts were wrong - vma_assert_locked() is not a no-op if
  !CONFIG_PER_VMA_LOCK, instead it degrades to asserting that the mmap lock
  is held, so this is correct, though means we'd have checked this twice,
  only triggering an assert the second time.
* Accounted for is_vma_writer_only() case in vma_is_read_locked().
* Accounted for two hideous issues - we cannot check VMA lock first,
  because we may be holding a VMA write lock and be raced by VMA readers of
  _other_ VMA's. If we check the mmap lock first and assert, we may hold a
  VMA read lock and race other threads which hodl the mmap read lock and
  fail an assert. We resolve this by a precise mmap ownership check if
  lockdep is used, and allowing the check to be approximate if no lockdep.
* Added more comments and updated commit logs.
* Dropped Suren's Suggested-by as significant changes in this set (this was for
  the vma_is_read_locked() as a concept).

v1:
https://lore.kernel.org/all/cover.1768569863.git.lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (2):
  mm/vma: use lockdep where we can, reduce duplication
  mm: add vma_assert_stabilised()

 include/linux/mm.h        |  4 +-
 include/linux/mmap_lock.h | 88 +++++++++++++++++++++++++++++++++++++--
 mm/madvise.c              |  4 +-
 3 files changed, 87 insertions(+), 9 deletions(-)

--
2.52.0

