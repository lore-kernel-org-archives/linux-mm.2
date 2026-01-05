Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAA8C2A088
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 10:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2356B0121; Mon,  5 Jan 2026 05:45:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD696B0123; Mon,  5 Jan 2026 05:45:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57B06B0124; Mon,  5 Jan 2026 05:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCF1A6B0121
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:45:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EB735F8C9
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:45:40 +0000 (UTC)
X-FDA: 84297579240.08.BD894B6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id B29E0C000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:45:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="H/Gi0OHv";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MLBDQaSr;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767609936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K47m4dauRcbhUqH28GRORODR/YUsexSqXah37ye8gQk=;
	b=kjYK9To/M5psXBHB6ySeLEWB2ZHBcLpbflpYYDXa3NtPFs36MYkzZtEaLMgeCbPG2Gc6PM
	vTFoIrfr6uO3KUKEBVZoK8wWyyzeEEjtmC5Ggdee38mVsTFpXGTO5k2b5w+2giYIks3Si7
	kfb+C3qEM1QcSMMX4T+6ftjBmVIa7eE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="H/Gi0OHv";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MLBDQaSr;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767609936; a=rsa-sha256;
	cv=pass;
	b=lUju1A7dP6vgfGnNvziuBbq0SOfyyV6Zjdvvv5w8GUg2F16vxmUAcEh5H9yVxVg/gqLVNg
	uX6oUz6FGZuhnvxVyI5BSuwx/+XOzRXyYyIykKgpW8JEZ7PDOSPV1aBAguOyaGp6baMmLB
	nZwqyl4prdjJJUq5P0ZNbozP1TRkQ2s=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6051Beo5303509;
	Mon, 5 Jan 2026 10:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=K47m4dauRcbhUqH28G
	RORODR/YUsexSqXah37ye8gQk=; b=H/Gi0OHvP5Gy3onYlh4u9u2d3Bj8pI2APT
	uVA7TXWDq6HB9CddEaBgjf2ebtMOLGt71jBv/Gx7EHMId8TVVoSTFULJ0C+NXj/P
	wI/jVwUyv+Y/LMOmbCUnIhcwW/12xayTSjCIF84eNLZzzjcwHnJLwuCgqfoJmEHF
	wrSuIAybrM33DGjHfBjuUNpceipWI6iX9g5JRsnZT2Ys4LqEmS3e7HNycq8P6ZaC
	JelCDsx6I05fUbTFYJ0JamX1svf/4mKHcmJ7AUbK1920XTHgA10uyXsWU28c+u5o
	slKGoHfO3p3FbbyOWZ3t0G9l8/vMcf1Qz2zuIBKig4sQdmVyU4yA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev5qhh35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 10:45:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6058wwQn030878;
	Mon, 5 Jan 2026 10:45:28 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010048.outbound.protection.outlook.com [52.101.56.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjb8c09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 10:45:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BT57H8hSKSpHrVSj2dKAGJHu+oWNMWxNrXG3dkWOdjRGgUum4z3/TmAgoSFgrIDvLifczOk1XyVXRv1U0UITWsySoq7oRXZhiUSmkKDNGyQMA1po7yDGhrTusC9IS/Fq3ejWapGOX8hMQIWvElWQAl4z0beD4UOKNv6hQa99dzG8+Z+t/Z63xsChvVStdEqU8hOa0OSZDWCna9vOrBRa6VAItY4QEgpXU0JyNd98ZsrAE9y05G8GwYtmo1fCBh4NOnoHsGxjXYDQDP7wQk+7yuIhnMK4BqlVv5GuYkOzEOEjL1tHtu4XnanIGxt5p17Gin4rtBw1I8xioSAWqcVstw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K47m4dauRcbhUqH28GRORODR/YUsexSqXah37ye8gQk=;
 b=kM4/wto9BKSTdvNEMa0KCjHM2n1/M00i7ngH9fochMxjmGdFcYi/RWLW4CrDlocKV/Hp2n4REtt3rl4T3RPN+Nc20dgdpwtu2AC7VD5hLgFT7I2MDqnT5b0Um448nSPJfJCp5ZRgLrAz93p9QDN5RI3NJVxo8TU3aZaVYlRItNDucfd1yY0VseMnf0y84Uk/rjLcEzxS4Kfma9HUI3fxj9r0HUzaXKt/4YXCc8ihq3JFcjqkwir2FKggSp9aHKrE003WwFHIwGmk6KMiXiuxCapLlwB1ivBZf/RjrWYF42ByUMGFcauIkGbc/xP2AqlgiFK+YBhUOMb54VRCojNu6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K47m4dauRcbhUqH28GRORODR/YUsexSqXah37ye8gQk=;
 b=MLBDQaSrCwNSZedsbm1qIVL6Bk9tKegWcMZeCkX8L/MhkrZFPWAPxB5ugdaZM3SeRxo8lR4T24C0hvU8qiHyd6T4e6TZE0bfCstIRfz/Erd/SzwRS0f/0nori+Vxgt2zul9uOHwnxzZPpo6V3iRproL1DDCJLhPaCFAlxOcm8cA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5812.namprd10.prod.outlook.com (2603:10b6:303:18e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 10:45:24 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 10:45:24 +0000
Date: Mon, 5 Jan 2026 10:45:25 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <ab116128-e11d-423d-9ef2-dee0193f7ca2@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
 <0826eb09-216c-4d00-b4eb-ed1a2ba204bf@lucifer.local>
 <4e45bbf5-29ce-7cd6-8b01-8fb1331ac758@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e45bbf5-29ce-7cd6-8b01-8fb1331ac758@redhat.com>
X-ClientProxiedBy: LO6P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d3507f-3885-48bf-bc9a-08de4c4787f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yzNXFxDErT8gyrSQrxnioP4cUeHHQr0/5AmIl4HCaemRdbff0WXj8mjX+wS9?=
 =?us-ascii?Q?TNxTtn6FTyuEbVw/nDavDMJCEHfA0nqmgk/7NJHlol4OygtfMvUlv0ueEdN/?=
 =?us-ascii?Q?yoL2fUD//upWAeyR0QyJEd9J6uEC971dt0lglvrZYcx3cpFasbYjmxW8P6ck?=
 =?us-ascii?Q?ftR53gRQITNQ/JlOWLNBoOX5QldDrHmFgEM5umZWyci0IZhXYSecyjG2fFo3?=
 =?us-ascii?Q?iSeWF8PcXTcOZLn4y0Wy9uDxLBYDHzrKrk1n0kNRaSeuXXuvNRyJ28MBqKVZ?=
 =?us-ascii?Q?GNTFaX41BNuAXYlec1uvbF0ET5b/ONF1GEMJZE4C4tc+YNfLnIy+tmZkWgL4?=
 =?us-ascii?Q?U+VcjSk3CvzAXpnHB5yhEvpUXh7fxyfDoIHssgWo+rtvyAVx4CWziD/fbSdI?=
 =?us-ascii?Q?lBnAEyoyh6fA/E4DXTFd5bBWRnxK6I5FY3AniDF3ormj//muK5v3d8zDi66u?=
 =?us-ascii?Q?HDMFQXEyfc9bn8xIeU4Z8dla06F/wV+05Co56hlvQOdzZLpPcQFyq4sjXWNP?=
 =?us-ascii?Q?GEzzew+6V6MPLHFLGSwWHy6a0HUj0+bRqhMurWYwbNwW8Bw9Yy7pv5W3GgT1?=
 =?us-ascii?Q?pjHebcX3hzITpgnMPTUlPsiXoMUXc1IFpUyTKaW4kds2ASrsca/vmtO43FnU?=
 =?us-ascii?Q?bj8Lozxv3cCjanlesfIaUNOZMT2Jh4Znwl7mS0hYc7DzLSiT3X2lLYqMrXTo?=
 =?us-ascii?Q?4biUgwrQ8V90m7pu0f5i1zrL7XN+amfqP1753rafZmpudL6um7hxQv6sLXSh?=
 =?us-ascii?Q?SzPqGSHGXGfhMzr+UxH8bwsf/W1lOBy6cDpcQpA2XWlG+Oeq4OkB/uvfr9FZ?=
 =?us-ascii?Q?2QrMUdpInMKn0JR/RV1E6kHFTXyhC0SsmwD4knFGVLVxjSRkUCKo7KAl5hkL?=
 =?us-ascii?Q?j2saqaUPyhMj2+MXe5ao0h0swDo3PxMGumKeu5V4dn6jtICgwpnDp2FbZ7WO?=
 =?us-ascii?Q?W76smYRiBM76Kk7iq0XbMMwx5+FTJLZI0wZ5PNehYO7n7jW5wveq6Biod6y1?=
 =?us-ascii?Q?fmBeRBH9aGTzgkNPc8sGP/SsXIS7zczMHbnIINa+m+yxlACoXwMHWPZ0ZjI6?=
 =?us-ascii?Q?xn9ePZ5FG8+lD99LietHAOuN3athqeE6yMTrgzDRnkY5M5a9Oyh4Xkmw3q2R?=
 =?us-ascii?Q?FGAvbMo4VNXzVcSly+9k7w8tkNZ9n48LUkSiVVKITo5wFLMAENthDPboIrfe?=
 =?us-ascii?Q?dFcCKguOwKB+/AcUfj4DYG0DF0wg8k5/H3aLPWZwHfaIXcq5PkVgRvOt6C9d?=
 =?us-ascii?Q?X+tLEX/Rs19vpe5eFZUOnkxtGTOlKe9NKsTad2QYUF7nxS9yoUkW3UrqzNiA?=
 =?us-ascii?Q?RfgYORLYUml8QwqygAaIOglgxRXXO7/pE4SIy5DRP9vvdw66XkyGI8WAmG+f?=
 =?us-ascii?Q?ck0ZJd5f/gMjxuetu8wv9Gf4ucOSF2PT7yGRzBRVQmlNjBA4gw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gQ+brrR9tIIwPCuynusXaReNhBaERTG8QnB22rXVwxkt206iRoIySVd99Mu5?=
 =?us-ascii?Q?sFz2o2YW056S2tbbYGdv+XNSKRiLu4mJ0Y+r+u0vMurf0X/y4OJSIs9scQEb?=
 =?us-ascii?Q?VrbhwrxrUXUYPV4tgjexZdMO+J7TfLTI8H/NdFpWUFJSwHQ3Pp68VlhMfk97?=
 =?us-ascii?Q?zmtSzj98UJMjBfcw5/3QO6uEOfiTiHkHPwwmW3HdSLqXFOhSAeyU54+uar6F?=
 =?us-ascii?Q?jphVQux/eFvIoHog7aN16d7QEjylVNNLEi7zXagDkWJefTwVZYx/+ppk0UyD?=
 =?us-ascii?Q?nDaBTCKnaB5A96f/XHBw9rJOo7WhYLKgqY418g7b1kUMhI0BBdAZv356tiBw?=
 =?us-ascii?Q?rT6jv73/R/Epf2uQmuTkicCovi4eUgDE03OK9PvUCrcgTtCkDfKmuH6Zkuf0?=
 =?us-ascii?Q?wQsEWibcuvTNSekXE20A+yCNmPyiBBpP8RA5k5bMR6xBXQgVori9k0OZ4kHM?=
 =?us-ascii?Q?PJ0oKR6O3N1+WMU3Y7oGX6vCRtCPB0hD9LI7/rtJBlv7OF14ULKhjrvHM5Sp?=
 =?us-ascii?Q?9cZCkKQjNECLE2lsBi31ftnGWQUuHht7nFTTnaz1XFw2aVjPeCighny9RId7?=
 =?us-ascii?Q?wFsdV9qmumEcyHY7ctmtUmxlyEqwM0QPNjnMDh9ikzXmnffvn3a2LcJ0Q2zU?=
 =?us-ascii?Q?HDMKDNjYJ1j6VEY6fFj7kGNeZdWbqPOvn42DzbNYgKWg1JLZgN3Srh0LnvR9?=
 =?us-ascii?Q?vKGAW2EIPA8MwBvUsKG8GRwGskqgNupBiKiFY6l5eN2Zp7vF5RO8bMVcJT6T?=
 =?us-ascii?Q?4VskIJfBBVXnrjFgfXpB9+5zpbXkj5lAFCIbA/y0yfc0QGwMESbaMWhEUtNT?=
 =?us-ascii?Q?UIrjXK4MJDwG9KI22Jt6ayVrDtMxbsfVMZoN1lS0YZqYBgwLqezLEInsvkDe?=
 =?us-ascii?Q?/qHHyzXWMJw9BJnVjBDNzwHUXXFGFvyWYjjWbLM0zgxoUh8RerWbaG/qSngw?=
 =?us-ascii?Q?qXDjPV01frFuRcWSRUPSTQkfoJeba/4Y7cunaM9G36cGATin8utgyiYoL9V+?=
 =?us-ascii?Q?+OkuFcSXgT9BN0p37hzHNLjzPRkikycEbvFXru2Unnn/usMaR4dYVzn7gyzi?=
 =?us-ascii?Q?aETyiygmt9fmfhoVRs/CseA352zOGMguqYZHT9/LJw6+76oQdsZ7EFdtdEtt?=
 =?us-ascii?Q?WOqaQDuMRojlCVERQnSPXtPIauLuqyRzxcvlAd/95kGyaqij5JKGshYepp3c?=
 =?us-ascii?Q?Q363b8AXZn+VI+gWX+oAWPDmGlhWD+sIW0/u5ncB/VeDWP6HKReFnywrUEnl?=
 =?us-ascii?Q?8cLOo+zdvbrnijneAsIthQy9fyLvOhaJDt/j5G7Npd2TE6S6Au0IFuYbQPIC?=
 =?us-ascii?Q?AlIa9NOdn7NLA3eHGbDIgjaUR3xGZPivsvJ/iQwxU9JUMskr1Q6mYIDx4QOX?=
 =?us-ascii?Q?Lf+8fM/DKmnA/F64wNwIxCoM3aFTdMY45N/8A4B5j1dYD2JUgyhe/vPR2YAK?=
 =?us-ascii?Q?SQEfhI/PMSZInvJWgwWUAHNVbF0oc+JVVD77o9I7oxmf/+xaT1dUU3e+2EYo?=
 =?us-ascii?Q?AMeVlkqhexBSPRUXUadaTwdugbXVJXHHSZYw50sGIBhyWsqHfDR885KKYZGc?=
 =?us-ascii?Q?mjJHgkcQIeyOqbT4X1mHcq8BN+0fXVAXLnpI8STynRayoVU+hvVFPLrBo+U+?=
 =?us-ascii?Q?D+1QRuWBJFSYf+AOYimryeDvekhQsiziuwS8y+fFQB8PXIIhnyJf0JKpVNam?=
 =?us-ascii?Q?e0MuUI6KeJRBlWacFMx6mOgP420+0TibL/1lY7LDIWnvAvqzioc3LSaewo7A?=
 =?us-ascii?Q?baNKZfxgHnuz9NaPGltz6pcKgA7g08s=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A4vlwTasrMrGEEigPLe33gsdCntjs1F3fFYjbwGevMLjGF8i3wKiYsPfv2BhQPiM15lnrZJ022fnCdomVWk1cQRSUL6CGofJnrC2sbdEIhx0WpnPlsUe69R+NCGZ1OmR5t1uxlm2aGHcnDpb/ln+zl07k1TEQHtgO4PmrIE+k47WHca+DNz7WCf3/ZmeBK0Kc47kuw/I0UaTIo7b1mmeoUF3DokIAOm4axRinqwxyjoGrYj8yqLE+hPphmBML4o7HinJMFPpdMxo4AnjyJD/9vwZojOhkECETzh25szRvQ58PPoBm0ZBrv+8Ybjvcwjx/T0dFHog7tOchwbmAZDh1o5MXOfSsBZyytZK4B16jGPvtvWm3cNCgkiF3OIvVNI8E3NQj0Embj+8sBBiG1DjX2uqkuj3ERgKlqW0m40Jizvh0fjYArFmCaxD2k0Dqkdv9VDBUCCmSeR+EPpW0I6Bkk9U3xud2m+5QQHsooV6Jey0lA+SY/b3KvnXUUfuToinL6R5npNjrvxImD3aoTgbqqubiAdNB1fOsUr7nh4dfGELRF4RiC9a4wgIRZ9p07xT5sl1wBhlvvehPp63zN5cz+BOQPt+2LpiNWMlp6auovQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d3507f-3885-48bf-bc9a-08de4c4787f9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 10:45:24.1801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwp0WIkSjFmEFj2ByTFszMF/FfqIpPdYK+i1ziE6uBOa6zJu2HhjRn/OsMIOrIputYkl0Tp9mqSBIup4/C3NqPeKzhd05QG6cykDGJwNtrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=455
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050094
X-Proofpoint-GUID: 3y3XeVFUrJR8yW5QKqNAUKnk0H3WqJoE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA5NSBTYWx0ZWRfX5QVO0wix15ui
 j0SsrzFa56rh7G2/6HiVcdTaQvZ76kSBA+vJ8KuVGQryUrLHTzrrVUpa9h9Oce7uLnlxo/Ubx0j
 GVN/Y1quWphpOJDU+ipDzuCaDKL2M7VbXKGy6OvDRaTCuo9rOeHwsqi4h9gkJJFpfUt50UELEPN
 7aeiLnxAzO17raOdHkYkFeLyy31/3OuNQEcP7mRZUeE1+SZynNjjcCxOgf4c0Qvgs2i19JPF/ZF
 zkswY7XePghtxq0JdZujzRFVnMphBQ8ofjbPZr4sqhEQ8E5a67agXF8OLF29xK2NKPR0GhS47dl
 Mv2jwO+CqzJQ9T63DT5DyZqV+WbmC1K30XeiAh8jdfZEq9hASpCf/HEhONs7iiUKWNwbvATnv6J
 fT7KGMFrMVkBPl105I7o3MHgkbkjm5APJAmPgT1jbKc8IHckSOhpEY5sCF9F72Fu6vIwNPfx4YS
 uRZrjjxPN8R1IA4sQqJpepNgeHUA/lcBsaGZ5pqk=
X-Proofpoint-ORIG-GUID: 3y3XeVFUrJR8yW5QKqNAUKnk0H3WqJoE
X-Authority-Analysis: v=2.4 cv=cePfb3DM c=1 sm=1 tr=0 ts=695b964a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8 a=_FFHNvDLAAAA:8 a=0Y2nGxMBhZHtcWKkoCAA:9
 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22
 a=c6drlLOehFC_xabKdUMl:22 cc=ntf awl=host:13654
X-Rspamd-Server: rspam02
X-Stat-Signature: g4hm1bm1xrmj7pjtroc9ug6spxz5wqgi
X-Rspam-User: 
X-Rspamd-Queue-Id: B29E0C000F
X-HE-Tag: 1767609936-564753
X-HE-Meta: U2FsdGVkX19QCM1T3QSlxIg1K/sLJuYymKksG0aVQ9RC8HsXRrQfKUwD/yACnirHqa1Gt3nhUdWRm+HBUzyCG/OeeMckFq7QLH7e1DGIEKKd7zsX/5Snkm4mvT7Ozpij/Uxquf1vOMB4BgcOXrgiABsWVqLna7JIF6Fe9i45jWiFxb1gMwhCAesKlmjfyF0J2WJU53W94IPfGjV/RavWHFfYw2WBosrrq9+Jp5zYwcmJXR2FB7vOapt8uPZU5p3riMa6dbIfhBIvzgIjlkVZG0gpYZsbIRgo+wsHbV0TsFbMvIihZAjRPFmDacqdVwKmqiBuHIb6fLQ2A66DGYLlfCoT9MLYjcMjiqPE6er/nXGRuM5rrXoY7lrho57aVNF00JMZLJwSx4TosOKkMAOfgn+iUMpZTJ1vzZtYZctu6I2SeYKbEZ2WFp1FTh+HXtZtTESEdEn0zuDoJVAExeXah39YBpaFJaC256inmVK6k2j+MQuUNkhEM6v5QZGRE/rjElxitEnSqC9TYQVGOc/K4TPD7BeB4fOfXVfXzsPhPk0gA2+g0u1ppUwbKOwjBcFVCBeIiE8sXK44un2x+aNfmmKzt01dKZuclJfbhLvf7cZy5qOtTz5GlLIfLo4cc0uhNgA5Wt8E4DdzoFFvNRUHIl0FluYgg78i+sL/Z/7RcbWVZDlXKxs2Wc6OuteampmDIwy6N8nh68J3GHg86fZAVl2hlyvRwDnIfIGQ/jWuL7IxKczSOi2+nW3KsdkpCIvo5jKM0VMNhG/sLV+Wv2utbQ3r78I8Bo+cWSp3EgYRxdGiPBHDEl2VovwkTYGPSMtXobLWlcf6ZXN8b5UKFwuJJW+4Ax7vty09UGCsj/z03VV0Msi/yW46DDiwjuegl4bDQsavlQsQOp2MZAlxqSrQHFW3L/NhrOm7UlPeyG1Ey+gGJiguu+BTrGxPLhzc+Me16VUXu04V72JedVAJPuv
 VekEECs6
 amv6pTsTTws154KCdfgQBsd/toMEIhKzQx5rZR3WJADPLTpAmWP+MSuXQw3+OsAo8zA0VeQW4u5BJQtRyXhWIkMQ4Mv07tOxdiad22UOogdPanlLWdrCEp7dzYuz9UVuiHk92J13e6sG+nAxpIZao+vXf9KD3fwYBPabjiLyzCp2XHdC4UmedXQuAUAYog/5Pca1JX0lKOcJixsSWtHm5iOwvuvOtnn9SQCxxLUh4A0HmHc0gzA0fMbtBoDuJ/B4grNxCkMXVEh2sClOzkpHHGhAGhfd2109ldDvjaHSYnvLTWeQrdWdg7hyklCMcUz3R42WDqNhIxV/XYBf5T7ZqoD2RMkCpUkI4UfxHayEo2y1kklOaxZnZJ1nXae5KdLp48fBNTAmi3w5VGch7MQ+SrIx0f7iD/tjD+jKEQXWx9yDz3P0edq1yR9cfjTORJP6Ue5RilzzM8dh5D2iE2k1Hb9hPdYywOuSPd6Gch4ssTpexVRtTtYbKVOBZmkUoNQVssNPxqlXxZzAhXUSCxfOXBolW5STmR0NErYRRfVXrZfjpthFvjg90lMI0QU6fvtfxW0YYn7+D3qzanm7Yzk03bJerfRf0qhOUcgnI6El9WXUXPgv8AmV7E6bIvhgzffFaHbVJSVO8CKtsBdo30k28/Z/EycsO+jiZ6DsMNqt+bpIieJ5ahxiTP5iKFxK6HEyYRS83tQjvw3BBx1FDETKNxcwuJcE+HGNZStT6Q8Q/q8dHXA6nTu4inLHdN6U2TC3KDsuF7/5umVLOdp7tenY/VlTVoK/YWGs6bmf/ExcwMvbW1Ic=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 10:12:50PM +0100, Mikulas Patocka wrote:
>
>
> On Fri, 2 Jan 2026, Lorenzo Stoakes wrote:
>
> > +cc literally everyone you should have cc'd in mm :/
> >
> > Hi Mikulas,
> >
> > You really need to check MAINTAINERS, you've sent a patch that changes mm/vma.c
> > without cc'ing a single maintainer or reviewer of that file. I just happened to
> > notice this by chance, even lei seemed to mess up the file query for some
> > reason.
>
> I saw
>
> MEMORY MANAGEMENT
> M:      Andrew Morton <akpm@linux-foundation.org>
> L:      linux-mm@kvack.org
> S:      Maintained
>
> in the MAINTAINERS file, so I sent the patch to Andrew and to
> linux-mm@kvack.org. I should have sent it also to people on the "MEMORY
> MANAGEMENT - CORE" section, but I missed it.

Yup things have changed :) scripts/get_maintainers.pl --no-git ... is the way to
be sure.

Understand if you haven't touched mm for a while you'd assume it was as was but
now we really do try to have people assigned to each bit.

>
> > I'm confused in general about this patch, you sent it on 7th Nov? And it's been
> > ignored until now and then taken without review to the hotfixes queue?
>
> I'm developing code that translates parallelizable loops written in the
> Ajla programming language (www.ajla-lang.cz) into OpenCL and runs them on
> the graphics card. Ajla sets up a periodic timer that sends a signal for
> scheduling purposes and this signal interferes with OpenCL, causing the
> -EINTR failures.
>
> So far, I worked around this bug by blocking all signals around the
> functions clGetPlatformIDs and clGetDeviceIDs - but it would be better to
> fix it in the Linux kernel and remove the signal-blocking hacks.

Sure I get that, I'm just confused as to why this was suddenly taken to
mm-unstable-hotfix out of the blue a couple months later.

Anyway I sent another mail with review, please rework this patch accordingly.

>
> Mikulas
>
>

Thanks, Lorenzo

