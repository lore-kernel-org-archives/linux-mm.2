Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F31A103E16C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C256B019D; Wed, 18 Mar 2026 08:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743766B019E; Wed, 18 Mar 2026 08:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B896B019F; Wed, 18 Mar 2026 08:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6146B019D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:22:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BAB61B8832
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:22:30 +0000 (UTC)
X-FDA: 84559096860.15.CA210EA
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023098.outbound.protection.outlook.com [40.107.162.98])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9633E140006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:22:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=oYIfx95c;
	spf=pass (imf09.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.98 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773836546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vs3By2K2+N7O04VPitwDlFvry+2pepCa+9ziz5w52yo=;
	b=b/EvVa2cEOyBNF3hwm2E3EKutJzX5r5KUsoaW/ZUp0xKjsYoHuN3LDHiwdA5a7e4UmP1Bj
	IGJpNleuN6FRNcvuhje1cigx2xabt0E3JZl2U6DJ5iWhTfyyQkYBCE5cRQC+laxg4QOjZM
	DTAHZwIEWhmpEgX5cdpiOntbgLkrQDc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=oYIfx95c;
	spf=pass (imf09.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.98 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773836546; a=rsa-sha256;
	cv=pass;
	b=qFoZcL989xG3ECuPxI8W7XzEwOmRpXS5ZuCfIsh1zOh4LuHCFFGwRBVj6BveXHrOACXmsE
	PrxKIQx95NThIiVbAT5LplpVa5ZqYK6r/tNO0/wzB2ZY2o5Hws2AsD1iqfH3YmH0WHKhn3
	mKObFyUR9pR/TA3qaQa1pmOEcuELXok=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xr8M299yfl9/I7hJSyHvstbR8gwteMM2nhT3Q6SbGxcbHUV2xHCg+zuvhuIphHJs3BD5l6kMjTAms77Bu20IfU7YQ2au7bz9dcu6iR+uzud7o86fFgSNUxPVtE+ks5NDCrv7DYvVLKIVN/aJUUqaJuTmNhTc2kJ2v8HQovBAthhWUk2NrQGx+O0x1nqS0ENE39fkT30IRO6anW/2u6g+/EyCHu/+rsfnmJ3J3QfW2jU+QVFMVW8mDMSMv8ZQF0/DaFaxiCxTlG3tQzndpQnOfzFcUUFXN/tVVbUVZH80Uw1dqOg3F3HuyUjVcVESdzogM6DWMmKGkZAbrvG7Akaipw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vs3By2K2+N7O04VPitwDlFvry+2pepCa+9ziz5w52yo=;
 b=HhpZZpWChvteCcBThANXqvqxUeZ3Jx8HXKRNh+sLUxuibtQQ+xvZlKHE+HzGP/lUbV9UPuKJpe/dtWCbkYIFQgpevjQ6kUUNytEFQCic3x+7YefbvJDpebMzP7/fkHzP8qckJ4uXVh6YhIM074ss7GQjr+xbUHJAtEPwEwsfOGdTv9VCy/kXwhJAAXSgv4JJgo1/chOrhsIEUGd1SfjMRMk19S9B3dGSco5QjeCbJp2B8ZcqboyvkOtgmuI6C8StKyprhcMM3E31TwspQQpqegvY7Id4m9FWsvvbmtTdbua0L5xgYpeZoiJz0wMS12Jf7bbXPSjrCIFfPTY2bq6S1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vs3By2K2+N7O04VPitwDlFvry+2pepCa+9ziz5w52yo=;
 b=oYIfx95cN2Ro/2Lw1KmInE7KalohPXq0pwwfinBucuR/uZJ/yUeFwSGPX1dXqoT6EAA/RdhyUhrYGblqk6vSbit57jK5aoqAzroRTj21o2XW/Rt4b5ZQ9O7B3hYgyvTNQVRCsL2PFYEAmTJJYPLDIKRiKicOYQ6e2obl9yCdZiymH9qkhjO3Ydytrhevt1zunqIbTgbTv3RxDhCGX3oRsvrZQT0kbB9Bj1ryLtepsFIbNAeIDU6sfgohNMoNqe1tf3pYXGDqNFlJR49EHyqS4gBWirzDqRb2ZxioQa7WR8ce99CgZ8c1ZTUUhdqetENICZj+G2qJirHN5BYbEoRtHg==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 12:22:10 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 12:22:10 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v6 2/5] pid: check init is created first after idr alloc
Date: Wed, 18 Mar 2026 13:21:50 +0100
Message-ID: <20260318122157.280595-3-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
References: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DBAPR08MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: f7245605-f4cb-45ba-2964-08de84e8fa7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|52116014|376014|366016|10070799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iK6bCTlaU5thLPnCUNqXgJ7vGsXOi9icnix/CkHCrFoiehZpgWV/6PSiWY6V/OghJhxSku26Q1myk73I5XoRzmcuIRNkN1uMMN8eykaj7C6gKClyty9dCUcNiOfN0nrAmiTk779cw51dEsS+izYzKr0dqQqRIE7kSa24nbB8+jca2eUkbGtihDvsWAeczGe6/6qkN/SuiXgwuzY6neGMok3uzobrMHuNh9emlAI/HB5DhBydgDq1IPzWQjIDPq8O5K1LOtR6k4F2zlt1o56kwq/PW7zjzRYnV4Gie7qelaC4/mKWGN3EhLCk/z3QOpD6sGtGv9w4iozLxoaLBE2C6RulU2CNp2oIuT1JDEApQAKdqAtA/XRaiNc8EaBWMhufYwbT89L+iRi5DtFb9R6vzkHgi05cqj7XCl6ptFihPW+CmTlMLFpTt7vCMgGB2t0rQxYVTyxCUBD7PZwOHj4u+itk0+N1OspJZ4K/fEi9M6Y6vNiuORC9ELXf8raJXw5ISLCdQ/tGLwy0GhgPJZ9D23PipGNCTRc2u1atjlvouDz/+P3U68cdLfkEOfPwzZdNk1dO7ZsVuqKBwK7Zq0t6VxcZxJh0tLGnscuZ7eeDindZHw+p18i1WLXgQdpfiejnvcYwQvFGm18qUv13/w/PKEJ8HOE5Ew3EbR6vBqEJgbe6d8azDw2Rv2AJ95WLKlu6QCMtq2yHIeBgMAYW0JqUKW4pPlU7OcgexpEKDjBl3mg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(52116014)(376014)(366016)(10070799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EI8jkrVBy22s+3MX3MqKse9g6e+181nKDIcM0oYLWJYGViJ58H3HitVGgf7k?=
 =?us-ascii?Q?YIPDwPJuWxASBYFZngaGPirFlwxjyJ8OWHxuiS6uT5Jmx6G7kGecwnDkXsI0?=
 =?us-ascii?Q?GJVna0kaJbo5umM6JslmyxSdMxwEwgqy6vZZ6aLO0nOpEOkXuUXSFQR6ITRY?=
 =?us-ascii?Q?gUVtrkzgEPe7M2nbHCfc0CrgHPVStBtSRj0va6/1YbTCKvE3jS/hqB7FOCf+?=
 =?us-ascii?Q?lZXQLjzEqd+bznw9o0IZploc7D33TauM8npuz2d8BMl/4kZ7jf7FdD9XyrGu?=
 =?us-ascii?Q?GOeLuczUp3eECQki2U9i4l+r8oTm5oc7azXRKANjiDt6bzMaIgUeo6LLLAZe?=
 =?us-ascii?Q?gZCGcoEjvf9jJr1UdCfL0SE2CtLGZ1kjPyb/k8KJxgUY8+C+jjdRktr1lLau?=
 =?us-ascii?Q?V/Oekmq/o3mY9PD+I8llUqHijLHpTejdpFBMk+2KHRk2OMDF/HyIkEQwNuKC?=
 =?us-ascii?Q?ty8H9wA074B2mIiqMAp1t2feiQ5sjsonShUL+d05WLBzDrlJ5/htFGEXBEKY?=
 =?us-ascii?Q?pnWjdYqJSHwnoVZGDg8Uuy9gWFRSXi0We7W8Xpz/MjD1HBcvOUr4fd2qgp3k?=
 =?us-ascii?Q?8w/K9IXSuWiaMEg0NJpS9a3jFSM1pL+ssYfJtJRbV3QLk2QLAeUo+EYmN5pk?=
 =?us-ascii?Q?IhNo53TlQAAGoCFJW8pD6zXNpfZOjdFU9xafcMaKYdgsuVQxu9w24xU40I7b?=
 =?us-ascii?Q?7O4xSEIrPU88DLFP9uHCNwcoQPe26JhOfdxqKdBohhg43MfStxjU3GHuJeP1?=
 =?us-ascii?Q?Y3Er40ZgapKYw4rM7RYIQ/YIiPHOZRgQmZ1AVu2hByCu6YjJnATQASHAcq47?=
 =?us-ascii?Q?YsHPXJVlpQbuPpne2IikWHBFYUYKVm94AzaTJ4rm1/cOua4gCCYyN+0Vctic?=
 =?us-ascii?Q?o/IeGTZfpoYEUYHFk5VGW12iCcSv7xewTc/D1wyygVAKkphVixnYHEC6nOoA?=
 =?us-ascii?Q?wS9iT/su0+41AEVHb1O0vyUIFsrz8Y9IdBcmjGwv3iuVf+2gV1mOR7HD0zaG?=
 =?us-ascii?Q?x1wszJu4R0Zb1s77viK7I8a9lMmng4tzn2u1bPdkU8DD6zZ693qeJ3VEhbEu?=
 =?us-ascii?Q?4UbGUTKK0W4IURi4vl2e8Ys7lBo3qPZm3SH8lOKAffrY2VbhjvyOWTdFXtqC?=
 =?us-ascii?Q?peRaZt8uHzTDxGWN53mt/DiUzbIRCYLEYsxMDnhYkbNEyPjvVwNrWmVc0CVx?=
 =?us-ascii?Q?TihOoi2dG9/HIN+qKIqqtHcc1L4NW1R3zPLKX4cmlU1NslARlPol1PG8Rwrn?=
 =?us-ascii?Q?EfX7ujOG8JbHozQGlrfUycg7jLNOICxsHvR5aQ1HYMU+q8KcTrBMbEN/k7x+?=
 =?us-ascii?Q?fSu2Xrk/MFNMPAfbIg9K58iouXmrSbBBLhvamYzil2DyndNQgT9w+sdynwi2?=
 =?us-ascii?Q?ci2J3VT48U0mChRqpnZnTb8cqU2htUMeJ4jOsYF5sujvvKDzErKlVQYOxYEX?=
 =?us-ascii?Q?P7Kg90Z6c9HIXTCp2/49m9puJqDjEa4lAq4uLORdkb9SBZB1lzYFLaQp2/07?=
 =?us-ascii?Q?cjV59MTvS9pAl3rkjzSKPlPD4lgbtaECZs6sClJoaL82N7DoFl1uRs4Hxfqk?=
 =?us-ascii?Q?d9WdZv2Bw7MQqfbJnNR5cs269AwtzyOt+PXXS5RTQERkfjnYyaTKFPdCwiFu?=
 =?us-ascii?Q?i5aA1uf+BXhFf6PZKcVDj2s9WdkYEhbZKLwizGa+rIHS6ipDOOl+atxIKAzG?=
 =?us-ascii?Q?UA4ncRa0M6YXdn294TQIr1cYBwoYQyUEAZWrBUGfbKB2TKz6HUxAW4MJjMJa?=
 =?us-ascii?Q?FpbFjQLuhgX8cH3KZq25LSlKiYGEOrsjrIhDCoAgKmBgbtw6cKQggK+9a/fd?=
X-MS-Exchange-AntiSpam-MessageData-1: ++S4XDDN5Wmk9hSdJvV+6mLiH1ej39HhiEU=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7245605-f4cb-45ba-2964-08de84e8fa7d
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 12:22:10.4638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CS6WSE/UwPwZEt/wZnyixlStMRbMILg27qTUUcTAzoY+tEwD55xWtlMsx65cJUUYTJdfPz5xDw/mss793KSyagrPBk2RyX0o0Z/Qfv3OQAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5830
X-Rspamd-Queue-Id: 9633E140006
X-Stat-Signature: wzokrfksshg4yi53kdh87gbi9g7yp63p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773836546-222903
X-HE-Meta: U2FsdGVkX18fjduefcvzD6PvAvyo/gnAMPoFgSX64uwJQ8XRS4QWewdbikxAkF/wnDfz3VHMrdt4ZacTx/txDRi9EwYA1RXeSVhPhVr/Zm9bIK54/RLes3JPiy0pENa2Boh2ZdMDVXxzC7+YI2T03MupIpWif1/4GS8DsnJ+Ks8IMgDadTZ6rGa2nCMVVK6HtEibJeQEHSU1vRTH1I5p7l+aEKPda1JaWXehHrKsELOv2rQPgebXY5qOHUNHpsiw6NwDKRLWuWknpIrRajVJvCe+xpufTGHvUPYdnqqPFDvy8+fxUM31X2SbFKaSo67MEaNLHEpMa+PHRZ7kr9xwPMf8771TJ92htcl37NJ4dp61IfAGO20m1yBDwBI/eziNAescJDJLb7+RIZHxVr2Sefzbh0w0NLT2vNcI90u7229l7DyAURctXywJuZ/MtG+rsFx2wvTXZlgKmaAD2Og7KMEgvQfbFjQw0VtkQqAudpxjHw4oCDiQ79kPWgNZzw0OEbkUVp3cbs4nwWsh9U5MtwkShhdixccb2Ogwt60rI9mr8+GypciTtVo0Q1mzeXjfMLMXluWfa4YA6lZD18IXgvhyCqbENKKVIDSsOqRZ5pXvSJM/uTmM9S9TRFG5xXgOyIiWyC+zOjdksuiEpxLwT1Mle9DCgEz8vhn73xfUUzUNPc4k89A0ZXaLdDsKx1R6Q+Ni4fmBwOb/lzo4aVbPk/ALg+mLDSEFlkyT6YkEVJrK33Nfmug0+XvOzQoc4WoE1lX+aNDC3UkiKKgtUyWQRjdQQ8kN5MJu6pjO//k+jfPwxWaJ97uMh/OBY9cIEGpaEh5ZQN5UgS+RIZKipBaBSgAHSJ4lTH4d60MkPKPYGOxEFqinZCehLh1+LSpPONwyY9kj1kNBq3Q4yAOMJOQLOkusR7Rp9fijUQBUBTNs0e8IN4USuezX+BqdFSg10qWjk18+JVswhW3omxzPELY
 83SoSgAW
 ErjwA7y1daZDAiLWbLsuEydA18JkQ2KPj8965PPOIDwevmaPZ9z4bloVtHS7S7ev7WFfatUo8/ZiC4hjtj66VbZJ9sxWiaPbrCGxlBuKV1mjlLChautx1GOaomilUxV7BXMifBSL1oveBErVVmmGqvSpVWSy3ULkj42/KBjDYMSjM3X85nqs7RgcDrNmEcH4TPF9YYWZUGRufRohaJVsUcS0UKmBXk1YuVOD90RPpAJrxPfDUXKRLbAKiYhnljV4mXRYsypmVBd72EWZhtS6g2iSpLBf6qBQVH7iXzE0Tr+FwfpxAQ9eEph7+R7twl/uQNg/PRshFEgLq+UyQUFyd/pFEl4nwGjpZujxiVi2jMuT9ttDqxc6GYjXce+JcpWGGl1VZ7piA11dqqdHgLCx6GanviKAImBZKTDCTSh4yZ5UTMVPQDc1doKsjNnqNum8Gdevd6GvOZF5vjoBh75g37vEuZUiT8ftMrTvQNeYrGPXQw6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This moves the condition (tid != 1 && !tmp->child_reaper) to after idr
alloc, so it not only covers that first process in pid namespace has pid
1 in case of clone3(set_tid) requesting wrong pid, but also if idr
itself gives wrong pid for some reason.

This could've been the case before this patch, when creating first
process the alloc_pid()->pidfs_add_pid() code path fails, so that the
idr->idr_next is non zero anymore and next process calling to
alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Though thanks
to PIDNS_ADDING logic, free_pid() disables further pid allocation in
this case and it does not lead to any real problem.

Note: This is also a preparation for the next patch in the series, which
will introduce an ability of creating init from the task different to
the task which had created the pid namespace. Needed to make sure that
init is always first, even in this new case.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
--
v3: Split from main commit. Merge two checks of ->child_reaper into one.
v4: Update commit message about PIDNS_ADDING.
v5: Add Andrei's review tag.
---
 kernel/pid.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 386e51fcebb3..677c84e319dd 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -215,12 +215,6 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 			retval = -EINVAL;
 			if (tid < 1 || tid >= pid_max[ns->level - i])
 				goto out_abort;
-			/*
-			 * Also fail if a PID != 1 is requested and
-			 * no PID 1 exists.
-			 */
-			if (tid != 1 && !READ_ONCE(tmp->child_reaper))
-				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
 				goto out_abort;
@@ -296,9 +290,18 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 
 		pid->numbers[i].nr = nr;
 		pid->numbers[i].ns = tmp;
-		tmp = tmp->parent;
 		i--;
 		retried_preload = false;
+
+		/*
+		 * PID 1 (init) must be created first.
+		 */
+		if (!READ_ONCE(tmp->child_reaper) && nr != 1) {
+			retval = -EINVAL;
+			goto out_free;
+		}
+
+		tmp = tmp->parent;
 	}
 
 	/*
-- 
2.53.0


