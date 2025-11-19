Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F93CF58C1
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE036B00BB; Wed, 19 Nov 2025 13:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A5A6B00BC; Wed, 19 Nov 2025 13:04:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EC66B00BD; Wed, 19 Nov 2025 13:04:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8044A6B00BB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:04:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE33B160602
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:04:34 +0000 (UTC)
X-FDA: 84128131668.16.D938D0B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 40D7916000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:04:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BSMyGV8c;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=z0Uoy2FC;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763575471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQBpwQMYE5AtI4VyORZjd6iFzNq5JZWagMwmrAipeZE=;
	b=PkoBxmOjJlL2htK3Nx38YF+v0RgDitgsfg/gXNcdAE9+cYm8VS8we9/JkwOvzzLeAzdX7U
	+0MQDc9fgPiLMby0PY08I3Iw4th0dc0guwL0YqiQzLKopjTcAx5jFvUfeB78hdFs7Hz6ch
	XowQyT2EMGfN4Oxd+Razh3eD0n45EjA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BSMyGV8c;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=z0Uoy2FC;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763575471; a=rsa-sha256;
	cv=pass;
	b=LRWLGXgsbntd4gx4HNH4eatd3qhNwMucBuxPTJvLcS0imSbWtdudR/PNZlPE6wmj8y6pRu
	D1C/wbHJYi7OYE1Shdlh4sUl0n8ERDR+TJHyTAwlVLX1QNLb7GHNLf6CeUgmxnRSttP+Bc
	Di2HiREocUDS5D6+Y/ivBHjaK9+HaKs=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJH1Q3j006456;
	Wed, 19 Nov 2025 18:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EQBpwQMYE5AtI4VyOR
	Zjd6iFzNq5JZWagMwmrAipeZE=; b=BSMyGV8cIhESbCkQ6dWUpjKvOr9vEJ43Iu
	yWynEVJTxbfBUbD+IXfWf0UTqzT8dlImFhJ4xCp/D8aX4r160E20J/zh+zRp/XAt
	uo2/S8SQxWsm5P7ScsoMY9nrRbXlUDFoaIWdHY8HR+nVLmT4HaQXsx28jTShGWeB
	7FhUJz+lRExB6S3tG2+RTe2qf5e2t2p39rXU0war2hOYAnOK1E0LGWlIRJCJh94R
	iLN2YIRJj8RJj7m3eVw8XU9JDm1KMt7ZhY+9NnECqPufjdSb/ZxdrDTzyDWVn5V2
	65IGI2lv5lHtjpUutGdQeKUa9P7Benpy/pupoZV5rsrnzUaol0rQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbygr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 18:04:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJI1onA035973;
	Wed, 19 Nov 2025 18:04:25 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011013.outbound.protection.outlook.com [52.101.62.13])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyn7nbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 18:04:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mGuzJSmLO1cjZnBevJ6ZYCONeI33yJ4o3pogqRxjM0P0l0MY/kIqp048PgoPVSdRkc7u+lE3K8daCiw7GQ2q8qoWwOyrvCUDC51Xzv3atFrjpsYOOuHHz+Q0LN1shvMy1Ob2pVruJvXkN3JUlnQ5Shq2NbEv/Md8AWLF5xMfPF5UVXibA2+ECFPxR3AC2rDOJytWy8mwODu3LYgUEiE/Hj0lOAgqa8Y1A7zBxF1fWOxqOJ8E1co2RgDg9IeWPk1v0PYH32o/Sk/nSCgefnKrFWzYrZBNqHmoX8sS1SZYjwBIbcu8M91Y2d0T6bH/hEHmESlXeEw/Kidn4h7e0vIlEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQBpwQMYE5AtI4VyORZjd6iFzNq5JZWagMwmrAipeZE=;
 b=Ab0C6oygfCHks6mjiheSpQ3tc/xWGgSmIvE6x8M0DNTQMEnEIXfTi+RIdNOrzNLWG64Y4UykPi8rlWXx2LtMQagNbhlP9ViD9p/SdRjYjlBQFKIb435EVwtGz1KxtieXR4HStILvSEAJq5IvtCaxcof1TrbitU2A07G15gckBZwHzgaj1KtJMtBVzMzTzYm8LagXWmKq1aTFZGF6kRzLASy8sg0DNVDJJ84k5I7Pa0fyXNKZxmMvlNzdMvEfNkWx7U9uSvhBzpjaKlpiCj2cSBNBQCsyEVJCrc9mTY/W4LABSoXC27OsCjRYlZm/MQqUKZseIL0GBJbcBTe1K4fhpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQBpwQMYE5AtI4VyORZjd6iFzNq5JZWagMwmrAipeZE=;
 b=z0Uoy2FCDXZ5o7K/hI6CarOy3IIQSMMUlRmiKBVisL7w70VQnpMlJCyKdFHWFZ5wbjKr8n+6ziqyVhUKE2DUF7yMB+A/N5lS4xp67vQjuVjrbqzP75pwcvjLrTj2g/rVLyjLqyeUd1/TKNNSjA2Ar1ViyE5PZYenG7DnysDSqJk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6900.namprd10.prod.outlook.com (2603:10b6:208:420::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 18:04:22 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 18:04:22 +0000
Date: Wed, 19 Nov 2025 18:04:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: propagate VM_SOFTDIRTY on merge
Message-ID: <0019e0b8-ee1e-4359-b5ee-94225cbe5588@lucifer.local>
References: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
 <955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
 <20251117145413.badc72b4bbddc0978c64c3eb@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117145413.badc72b4bbddc0978c64c3eb@linux-foundation.org>
X-ClientProxiedBy: LO6P123CA0048.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6900:EE_
X-MS-Office365-Filtering-Correlation-Id: 87a1e104-d16a-482f-f2c0-08de27961120
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b5pIzEkkfCVbU5rngoW+FtR4H6QKp5kCQ5qnO9JSYhC/sa/OnI50FJhM8wUC?=
 =?us-ascii?Q?9jVxQCD8/dJrmCMnkKzg56nCrYrQTIaVl6KbLulFgSukgn9JeGTpCMuham9A?=
 =?us-ascii?Q?0rEEEJwgHlLlsRCMwWuQLovFz42sYEzqm8GG8nSq8836Ixqi4DhMOMBR12eZ?=
 =?us-ascii?Q?QitMHywG4hTllMEGgx+x9yDOJT/L1c4y9tUcFb+wNKXg4Kqg1kbV3gRt1QWd?=
 =?us-ascii?Q?HNL+NJWgl/QM2GEHGDq6Mos7+kjk4sM8c/+nox7qLDXJZz3q5pthqkH3/F3w?=
 =?us-ascii?Q?yEcllnixY/zaKY8hfEuE6Oh7fW2V5pLEaG7tN9UPs4EdMfsdmHyhvl9RnJXW?=
 =?us-ascii?Q?uDW94rdEkuruSErV8C9JbhhCn6yHi+c+c5cB7jmFY1NKVEe/ip8QyyOtTBjb?=
 =?us-ascii?Q?2ZKva4H656L+fvKHU6D4kuDHbQIgEa7HzrilH1WPRXNj6hKCwZJrpfR1BWWA?=
 =?us-ascii?Q?/yT1IhY0/OlAZMvEYxWceQBag8od8lRBXOGgBiVieEi+Yh9ghVvrOIHBTbIL?=
 =?us-ascii?Q?9fOp8uRWOCW+TO8DMp+gngB61GHJwlXGnj59bYmkQgko4+IGsuts6oh4yHPB?=
 =?us-ascii?Q?7VAC4fOTcNzC+KZtq8ZkFkOLZKKCb0wnqWNmCkrDqXar7nGOUknlV90fX2sy?=
 =?us-ascii?Q?pmGhbjCE+4uv8A5NdsCKxRbdu9QbedfGpSpgAyZBwPAkrZxHcI3oTDPnFzGx?=
 =?us-ascii?Q?ORaMMylwOiFYrmTIdweckKE7Cc6OS25TlUiXppLornECV0afrsKlaniurT/R?=
 =?us-ascii?Q?axV9YJhlptH97ArCJXZpDI+p6XT2TVNlZnoWlKfiOux0iFNYI+IIo9UD/h9q?=
 =?us-ascii?Q?CEwPITU2EQdavjeWHIfnp4n4ZGoW8WCtw1+Duh1tPqNIGj6OKww6tkXitOx1?=
 =?us-ascii?Q?7q7ou+SrQ1h4XdJVvYHzfNqpZye/nuvZPNxIeJicK6TivyCSTEnz16Ea2JmM?=
 =?us-ascii?Q?OAeqyag9V/QjWYe7BAbSN/MRfcnbJ4hST4lUaegn8+dFywtWzT0wmoZkMc8w?=
 =?us-ascii?Q?UC4G/uxM2Go+cBqyrcf0w9xptiwOXMIgxlU50FnzP9zAjjI2LwY5EGLoI9WV?=
 =?us-ascii?Q?OnuMZtTb6w/cqtbvAWB78EcGMOICujYbi2vM+6zztdBDCJ0WgX5Soao5HPkc?=
 =?us-ascii?Q?QJ/l/iuR7p8X3o12ydZzRigdIGDfylBTwRXA9h/6QW6IKQ6EcZRJlSKznqWL?=
 =?us-ascii?Q?d1avzyWeq9j3fdhNrK/p+WCKjhotCkn+Gf4NxNnT77RpIqM59KEvr/SRpjb+?=
 =?us-ascii?Q?nVVxxqB6Coe6hW3f2uykJ43CmlmF1HAFB+YXi61YY3Wg5EdzOxcd9hQV723q?=
 =?us-ascii?Q?iVgfaZvWZXG68gK5H8VRCJRcvai+gS8+B2H4ubwW3hq0dHNT5QDTpDGMTyj8?=
 =?us-ascii?Q?qKfJThcAGMszYX5516g9ycvd2tiML/LjXdOCjEfeMppomIxB5LWyOlL8tkTj?=
 =?us-ascii?Q?rVtoHyOIc+p3kkRpqIqEJIUpbalSEpcu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3j3o7LSP9ruPpSuW48OFoKncO39IDuTH6Wx7pym3/sDJVanto+4MzwuJr7zS?=
 =?us-ascii?Q?WOESjImHFlRSfAtIU8zkLAsIK6FyyuhDKuTcTcAeuiz/FJaEE4JtUJrZJhlu?=
 =?us-ascii?Q?UJSFjPvOstwcqoaPCxnSTwIGby9LghQ4nMML10yv5DOlfCw+vxKQDJCDukcO?=
 =?us-ascii?Q?g/QWMW6xApY2hKXhc3V9AiEwvHXY7HajWN30/R4MpxTQqBqTHkO9qbgw5HJ7?=
 =?us-ascii?Q?nZJAt8V5KeN90zjXT6Up5sH2N844GqfOMhs7vMl4tSObpRm5mbuRK8tH0giW?=
 =?us-ascii?Q?+D7llyZSlqEk6oylAbw7cS5oK5MZ/G6m+lgEi4gU4o7sa5sQ5KE3p/r65ri4?=
 =?us-ascii?Q?eBlzZa4Z+vxMdbTTiqruCnGNllNwFFn5OI4OuIUTK0J3hKRMmUKalaQUPpWc?=
 =?us-ascii?Q?uzlkCJnMXDiBrQs1W4t/ptEYOW4bnsiMU0h5jHh53CavOkZmbZN+/NRW8+9O?=
 =?us-ascii?Q?4rJKFxHJ13FjyUWIU/boLoxI0AHDrilUiPAaW0piAUeoHJ6e7nPJgx9eC6Y0?=
 =?us-ascii?Q?TynjKqz5vXdiBO7DdOQlw32QZlOmcs6A2dgPXpGbl325+wqwbJ8UQR60M2gK?=
 =?us-ascii?Q?nJH6HB2YKDA4MjC/DNZeqCmGJAJzgs+XvEMuYv8M24uRZXMe1z66gci2DuW/?=
 =?us-ascii?Q?vErt79LjQxQpoj/6qV6R9R/Brnq3Ot/DHnTG8WouBW8+r6RcTog3IS+alAMi?=
 =?us-ascii?Q?GSrcDJRn9qq62WW3zTd6uXZAxrNApV72OvUgve3msZCgcKrWDiKK2cXvxlIv?=
 =?us-ascii?Q?/CrWsNbp1uoexv3fyzFw4swALT9LgPoM90bW5aE8QneIupPG0FNs2+m6bOCs?=
 =?us-ascii?Q?ObXUR/k81UpcFZetRi8X2VxPwF6qA1BUfkndnXLwg5hslUjcovsrG7CzImAu?=
 =?us-ascii?Q?dY3qm+273nyvNXXd3hXRF2xH9TgjDjLWxHBqMR/JZlFiaxIdrPSSy0zYZJQ1?=
 =?us-ascii?Q?wNCHyJoQ7L/ZLDNhZ8rW7Xm+vXN9EgLgczSGbdsKeY75NdXOddFhCUxyMOS3?=
 =?us-ascii?Q?dY67SaMlbwpfLug4J3VU9mEg1+xmRQCDEu2Hs+BsjYFvp9Qt9invDEY+nhhX?=
 =?us-ascii?Q?P6Mh7oX/xQRMQSw5k+igdCzf9V/634fI5Sxu8oyCEIPDxTcijgFqitsk+kWI?=
 =?us-ascii?Q?tb0Rl/kMJq5WO7xm9W9Ft9C701H6mOWPgFnfsH8Gn+BxXy9DUwcXxgMPjHkx?=
 =?us-ascii?Q?vixGU63AClIN2NALMBqOnywuUFuadRLgY4UKzv5avw0634BJB/7KgrRk2IOj?=
 =?us-ascii?Q?iehDcXOGvUWetz4yLEnGpUTPtuXQKjFOkCOGdPRAnJCk9ldpyRBDZyKBSV3H?=
 =?us-ascii?Q?wMXClldVdx17j0UPZHDYeEhzSK8XcWKmf5hgBsMnKfJ9d0XJbHJQzEyIU8Gs?=
 =?us-ascii?Q?0/vAClCFyAK615llUigRS9rsgBuGat3xV7vZ4/PpNjktVNnAYRcMKtBZf8+v?=
 =?us-ascii?Q?joTiryrUD4cU3G/qO0txVN861YeS2nUh84+USC1i003gJY+KLXeGFNfA0Cgz?=
 =?us-ascii?Q?P8f52MTCnLuLRA1R2nwg1sDklLuuoW6w8YxwfJKr4NwtU5Ki+EgsVFNF/9iH?=
 =?us-ascii?Q?3PXbO4t66SnzUBl4VsrJcpPc67YEfbL61vBxrXAccDJGSL8mvxjBPAfufJN1?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XYcqN+tcwL16kpgrJecH5/kFKFL6xFlq5+KplmxUKCtHUMEdwLzeufNZJYrSnbg3hRwxhDM1nMKVtVkM1ZTEO/pCWysEIc/kyMdhRhlwuabF0voUK4SOdUgqqFM1p1Dri4xAQhCLxObFRyaOd31OqYb+sO3tIuUClfqiLfeEGZVDtYoiyfoeMzR0icrD87PupH6RUHx6mRJPlrXxZJaZezpPn5wfgoqOv7usBLqlwmQfF+ltJLIb7A/Rr8jDehiwQc1hIkMdztkN7UC/bsvML+S1MRcBZwWoMF3kk5mePguTqvW959sYFrPEq0/HdJMN0c96dp4UGpBgDjGbZF/0KzHhd3ck7fu6No6n2MGK4fE6esHzR0BcdCDg8ZCe0RurBAljJp5hL/qBRw/fB8/HyW+6djMAkmpPw1X7rn8HemkqHBiPuz1Rh0m2BZ5l7zrEFtM6chI8qvTGRkXg73jzUXmlA5sbikf8MjNEkZhvt8DU93aFkhiQ4aDmw8VsTCokC+CbpOqqMYLeq7nlF3LBeNlrYhib7PxgXLUKJwFn1AK3b6ZBluKSfAalzCAo44HVyz/4ZU+qQZU1CSem1c2yoBwkkd3WCS7rENF/9vurzjU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a1e104-d16a-482f-f2c0-08de27961120
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 18:04:22.0676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fzAuZwVHJ/WTYNSxxzch9Evjbt4vHAdLjtvdZJQeIEof7DB1X+ypb1HS1hgEqOAtGwA+0+wRazRvY/ggAwyrGgcYSSvzDPuFjUtWkzCQVLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6900
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_05,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190143
X-Proofpoint-GUID: U5RZ3H8v5Bk2zrjvSP5KBVyEJvIR2dBr
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=691e06aa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=azuKysCBzrfH_OwYvIIA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12098
X-Proofpoint-ORIG-GUID: U5RZ3H8v5Bk2zrjvSP5KBVyEJvIR2dBr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXyHFPrHc+uZB/
 csTq3D3abeEujh2udIibCy09zl2Kg9FBVwMrlvznQiEVrt9xE9uazHmQs7Y7xvsIqAvNBp+WqvE
 k5lQp29g7QKxdPr5xtxOgGlQVPKkLtd2b7/3FGESb+wa6x1e5UL9nFJcD1i3GmcZqdbGMeZFjNg
 myB228JLYdTXWtXxokWdcvq51hS5YgS9EBy0ugjtmGyBm8qcby40krHnIf/avy+dJ/ZH5D4En7k
 YMCqcFzH8WTne3WH6j5ERZyQAhWQoRq4ttdCsPIHUx0QDPZxM7kuyIi8tPiHP2SH3IvP5BART7N
 4RGXt/eqhzDx8+tNPj52FwJfT5VZhBRy59+fxrqRfmnsZVQFTPwcubQpE0s9PoFTCr+isZ8gg/k
 s9lyCf1qITqz8SpB5qAZMF8gvIUkQ3dL2+OZ5tzIF9iCOnUvHdQ=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40D7916000F
X-Stat-Signature: bf1smoory5jhs1x5nihdhe5yhwxsqrjk
X-Rspam-User: 
X-HE-Tag: 1763575471-12252
X-HE-Meta: U2FsdGVkX18zNEu9HmGdp4N083cmVKUE4XsWtTfSjdNRh6pf4uHatJgHAB367xNvEIPoxflDQx9WPj49Cp0t/HNjqsPhhWocvLbEIMA5uhQ/4PLpkDAMkdIsY9glC1W4Q/gZ4g9wbC6t3CVm6thvn9f8dE6f2SRl4ABcSpPYR8uPdzEognLMLsFBvHZjhdDOHT+mJSO5BPQbDT1n4rp6hC/ATapk3LtySZ6cK45QPV3OIhzhtrxrGYsIrn65oOBRKwe3boAjdRuUh8oxmqsqByBz4hrTOq+dc3fhqxn0/884ixvCNrzaJNubCK7dLKnk7D+kX5k1EAAOKyZyX2HvHxR2zGqXcIxnVOtnEF+x9YjdZejnZ3vDFfSCcOy83peiOkOQHOpd/pk/tEl8mQ3sYZC8d8RBFjC5OeZkwfsJEvA62YAZbJbSdma1ADdcLU0hTpDMEqH48YmtJXHpwCNgaK2t8ym/TlINXeiXbWxS9D30eJVBMfeAnuzHCozTflyvb31y4vz08WuEzdi4a1snlrE8ak9zhIxDfJUAdN2WZUKKI2NmDSB07wraowSUBZPlDqmKlrtx2U9LqAl8Vi/Mx887Tw/l2Qb6o0UHgnDj7ohe+NbKygFTugjXrNay0cs5O9osZ7XSIQypKIM85aCe48HdZLB7fijam3N5kHw2k8lECWF+MsB4SwPyWA16n4/VtCeFzCN2/PoUmBsPegemWEc16voYGCRgS65f3yU+4a5nwkTeg9N4Y/z2b5V2adSKwBF+ibmZL3F6PYbGVP64MiKoG/NDulBWhxtnk0AEpsPsgFQ6kQxUd/C7ZTCQfrYOWA8ETcx7FHDhsDA3mtE1nQmBxdApLPguEqY1z3X1DGplUjt44eQd6y/IB473fvhRw5+cA5Bj9BZa97bw1+vN73zMbSt7eJ6SYBMuACp5LUed6QipyKOk92yqcTh1Au5iXBWie8XrHQMbURhHJE+
 ggB9GQot
 EAkwVTdHiYW158LOir0Ou4TPCT2k46XXjRyWhDp3xg5W4hoIorCTDjVtb4SXY6cK+kOGvWTADXWdIy5IM7uXLCHBoLlHd1yYbO24WVmC0UiDsfbtXv6thX27ko/x0ZCIhGG9teD7tvfBZkV8kujwABFq732JNt7TtO3ymFTUmmu8edsUEwVGRLltZMjDsyfQ6Aqul0JZKq4bgXM8uu49JfUI7eYP/YqnrFcQvDojv8zrxLKUuvavmjQYAJ0eTi3byNki6EeoQXPU/9/fixefuykiL4gnJy3Y9Jq8EalLIknXjbpd5bU/zjb2hqejDc2AhQPD/lP1Rnk3JGEKzl5iCUeL++c4EeVNhxpHFlSjbuIwUcyF3MoWQZ1euU8l8lkmukfWgcIirCQbNlLNfmWqsC3OzJ9sniCJwxOXw5MT/MVZ3OKsmgQ7LbiOc4XqIEUoBlzrjvXzK7seyv1eC68sRsP6bUcndDkLesVfgNfr5dIsjTTrrOZj/pjz/9uRVoeeHpiM3eyYbqjh6ycJyUwUzN5X10OndQ39RSyLIXcl97Qh6dULie6yHGQyGfpiwWGVE6nPLH7dC2AJSyIIhwPIAESR/EfHPa9o++ScoGwO9W3vQFdT6DSoWiZVnP+m5wRCJoO+QOnCrKn148YQJ10TVxiRSUVkVUz3sXPptg5cDFfI5L4Or0DPAzbCLz07JBGyfNhxF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 02:54:13PM -0800, Andrew Morton wrote:
> On Mon, 17 Nov 2025 17:33:38 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> > establishing a new VMA, or via merge) as implemented in __mmap_complete()
> > and do_brk_flags().
> >
> > However, when performing a merge of existing mappings such as when
> > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> >
> > This is because currently we simply ignore VM_SOFTDIRTY for the purposes
> > of merge, so one VMA may possess the flag and another not, and whichever
> > happens to be the target VMA will be the one upon which the merge is
> > performed which may or may not have VM_SOFTDIRTY set.
> >
> > Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> > which solves this issue.
> >
> > Additionally update VMA userland tests to propagate changes.
> >
>
> Oh.  This patch messes with the comments which
> mm-implement-sticky-vma-flags-fix-2.patch just altered.  Not sure what
> you intend here, so I left it as below - please advise.

Ah sorry, missed this!

Yes a couple things to fixup below, sorry to be a pain!

>
> (also, I fixed a typo: s/most/must/, both files)
>
> --- a/include/linux/mm.h~mm-propagate-vm_softdirty-on-merge
> +++ a/include/linux/mm.h
> @@ -532,28 +532,28 @@ extern unsigned int kobjsize(const void
>   * possesses it but the other does not, the merged VMA should nonetheless have
>   * applied to it:
>   *
> + *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
> + *                  references cleared via /proc/$pid/clear_refs, any merged VMA
> + *                  should be considered soft-dirty also as it operates at a VMA
> + *                  granularity.
> + *
>   * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
>   *                  mapped page tables may contain metadata not described by the
>   *                  VMA and thus any merged VMA may also contain this metadata,
>   *                  and thus we must make this flag sticky.
>   */
> -#define VM_STICKY VM_MAYBE_GUARD
> +#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
>
>  /*
>   * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
>   * of these flags and the other not does not preclude a merge.
>   *
> - * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
> - *                dirty bit -- the caller should mark merged VMA as dirty. If
> - *                dirty bit won't be excluded from comparison, we increase
> - *                pressure on the memory system forcing the kernel to generate
> - *                new VMAs when old one could be extended instead.
> - *
> - *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
> - *                'sticky'. If any sticky flags exist in either VMA, we simply
> - *                set all of them on the merged VMA.
> + * VM_STICKY - If one VMA has flags which must be 'sticky', that is ones
> + *             which should propagate to all VMAs, but the other does not,
> + *             the merge should still proceed with the merge logic applying
> + *             sticky flags to the final VMA.

Could we fix this up actually? Sorry to be a pain but better to have the new wording:

+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.

>   */
> -#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
> +#define VM_IGNORE_MERGE VM_STICKY
>
>  /*
>   * Flags which should result in page tables being copied on fork. These are
> --- a/tools/testing/vma/vma_internal.h~mm-propagate-vm_softdirty-on-merge
> +++ a/tools/testing/vma/vma_internal.h
> @@ -122,28 +122,23 @@ extern unsigned long dac_mmap_min_addr;
>   * possesses it but the other does not, the merged VMA should nonetheless have
>   * applied to it:
>   *
> - * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
> - *                  mapped page tables may contain metadata not described by the
> - *                  VMA and thus any merged VMA may also contain this metadata,
> - *                  and thus we must make this flag sticky.
> + *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
> + *                  references cleared via /proc/$pid/clear_refs, any merged VMA
> + *                  should be considered soft-dirty also as it operates at a VMA
> + *                  granularity.
>   */
> -#define VM_STICKY VM_MAYBE_GUARD
> +#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
>
>  /*
>   * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
>   * of these flags and the other not does not preclude a merge.
>   *
> - * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
> - *                dirty bit -- the caller should mark merged VMA as dirty. If
> - *                dirty bit won't be excluded from comparison, we increase
> - *                pressure on the memory system forcing the kernel to generate
> - *                new VMAs when old one could be extended instead.
> - *
> - *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
> - *                'sticky'. If any sticky flags exist in either VMA, we simply
> - *                set all of them on the merged VMA.
> + * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
> + *             which should propagate to all VMAs, but the other does not,
> + *             the merge should still proceed with the merge logic applying
> + *             sticky flags to the final VMA.

Also could we do the same here?

+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.

>   */
> -#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
> +#define VM_IGNORE_MERGE VM_STICKY
>
>  /*
>   * Flags which should result in page tables being copied on fork. These are
> _
>

Thanks, Lorenzo

