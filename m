Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9497CD13DE
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 16:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECD08E0014; Wed, 12 Nov 2025 11:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6CD8E0002; Wed, 12 Nov 2025 11:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C3E8E0014; Wed, 12 Nov 2025 11:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3AA88E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:10:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6206A89675
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:10:49 +0000 (UTC)
X-FDA: 84102443418.22.D621A9A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9DBD24000D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:10:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AT1DTrQt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sG+ikGKi;
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762963845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01IlYPXYbCIzYljjSEPqRhSs2fjOonpIMFEzkTZzpoQ=;
	b=a6XAxlUP3NrDPHruX0HhjLrIAOcAC38+uIY0S4kWUrmaYwUMh2VPnpFxKrQwIOwT2bMSn+
	oyGiutB2U01HrbxPwZZdse3HOevEe/1R3Xuo8EP8nYq4jZAriQnwSR+lMXMuq4dIfNlYCg
	ByMUsve0AAb85fJgwP5QqTZtfA0LxMY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AT1DTrQt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sG+ikGKi;
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762963845; a=rsa-sha256;
	cv=pass;
	b=2sealVNAuGt9fcgLy3/v5V243LaFYh8x1wO7U8qBrixY46M8Zz6xn47Skqieep5VTA+5ba
	9Z9BOkAkjwsI+W5uEN7Kakjz53rsuivcznaGTAjus2avqwwPY9QvcRgVFi0fhc95SGYnca
	pFPvbH1KFwFUixha0KbPWUX98ZQM7MU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACFj7Mj006355;
	Wed, 12 Nov 2025 16:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=01IlYPXYbCIzYljjSE
	PqRhSs2fjOonpIMFEzkTZzpoQ=; b=AT1DTrQt97mOzK/SYbw2MTPeOa0AbxT+PX
	BHR2nKWS05ik44raQMUrXX78wko4UhrnVr31Lz+7WZwi0HHQPhn0rTvW2l5SX08T
	bshAbkZgkUhTXOfAqP/p3/sENPhanlbsfUvHtGL/bXI5JabqxGo4xjB/2reCrfJO
	V8/5JhuzfGQMvxVKlmsXA7Ej6FegR3zumYXZ8lQyGVsoyRhuJVbjVM6l4IgCudbn
	WHb255VaOcpi/ECHKsiH81JPAi8HW/uc/DfTHzS6mGXFJNjJE+evNNlwnufXqfPg
	wv2/fzQ6Pkl69KYuP6NallXOHmZHz3mnhQIj1m1UoNOE6GABRHQw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acw5f02v1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 16:10:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACGA7bw011406;
	Wed, 12 Nov 2025 16:10:39 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013013.outbound.protection.outlook.com [40.93.201.13])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaedpjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 16:10:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WlEidhtF5kJ2zH4KkBV1mnqTjaNVEf/PENxEXgcEeDUgwdIJ4mXoE1gEszV4yvYwPGeMt/IZz8lVDTXjE3JLntlrnY83kzJDAOP5kaO9F5C/fpmykrYgsAB2Yx2m0N+iIM/V5A6I7yCN++gFzUh0HKOYTPOhE5siHJzpMdMZ8+tO1zMrB5ooQxvXpHxVhwLsHQhGXRWTMhli32+gAXV9U0QP5Gxj3geeEqtmOdAdbpVzq/8f+U4nkDh4pJ2zcqu6auo32UV3po/eMyFPt27Wx4T8zAZYe1907gui66Hfkw8mMth/uOABHIGlF0HlDxlBSYxX3Dr//WPCraOUJvTXUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01IlYPXYbCIzYljjSEPqRhSs2fjOonpIMFEzkTZzpoQ=;
 b=aYW6uYKiwJUdV6ODFGG2hpMLMEklNM30a3RKg7qfcsTpoBPR3++7yXaHkOuCU2mYV5vf5CFg2u8hnsO6R9zz3qvcg5DY9LGDYqUBwu5FqRrfaMKp85mS5oOXDmheTNfZEDdafnHgBgncgdYTs8IdetROD/WzJEDpnkNaQlMi0l7VvNTA93MmuDIGC7hyVYotIZkzbS0Henv1sP6G0jNZ+4zwBr80VwN4zp/F/6kjmP1KdGaJW1mPE28p0O7i20WBEZ+qg2j1Gopk9N5fyRztewGTWe8aIPLz4fPvEmCeB5UfPj959uIoolcvNDFvX0pjgaOfg7pRkh/oRFCVQS1joA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01IlYPXYbCIzYljjSEPqRhSs2fjOonpIMFEzkTZzpoQ=;
 b=sG+ikGKiq9V4XvzN45SoBPQpDdn1nmb+bvzYDylkBEAu685sT01kPkl2KeKeDng6iKdwYZCY2rNXKgIeMGEtqwWFoGeaxbiUhuWooBDMT8EspOy+96sOFY7UJEZ8POQkorDBrdFXHOe7TGr6fxvNT6o3rkoPzuZ63K6OjTK5SuU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8638.namprd10.prod.outlook.com (2603:10b6:208:581::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 16:10:35 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 16:10:35 +0000
Date: Wed, 12 Nov 2025 11:10:30 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        stable@vger.kernel.org,
        syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Message-ID: <uvsjfodaoyikufskxriaycxcydhhgzndhs2hp4ydbwbgivhna6@h7svwhivantw>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, stable@vger.kernel.org, 
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com, "Paul E . McKenney" <paulmck@kernel.org>
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <2d93af49-fd76-4b05-aee7-0b4a32b1048e@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d93af49-fd76-4b05-aee7-0b4a32b1048e@lucifer.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0283.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8638:EE_
X-MS-Office365-Filtering-Correlation-Id: ec6688cd-f84b-4c06-106e-08de22060280
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vNVIPylnq8G4KUwiL7zxg5Gt4izY50+2g7xQguYSoC4L0JIlAyEAicIhwLjl?=
 =?us-ascii?Q?YVy5hjf9qDCCMGkWH3TS/XsX+T8mCAOcWgQ2oCks2JkK8d10Zf8iUrv716iI?=
 =?us-ascii?Q?1s5UtDCfvBjBgTmxgw4n1Ol1H0mDyy+O7ivNWeMEmZBh+bzZjce0UrnVxuc9?=
 =?us-ascii?Q?pU+S3J37x+AibvT2Yk51kMaeAC4y2fj6Wpc9KRXIsm52aapBIxc+KuikkMEV?=
 =?us-ascii?Q?c5HFcfI45uA0xJ+ohs8n7UFP4MCkWayL8l83MUbTGOmO5y+n5qEr1FJODL66?=
 =?us-ascii?Q?norCr5iYlYS+o7rbRYBhvYAW91d3WdWi67Ae0WtsNLyxUvSxQe3l/6pZpEu/?=
 =?us-ascii?Q?DWQmHgq6FGDDyGdVDI3pGbecBNMqOUz2JFSH+ui+Ij9yIlY4G9RZvURjaAeL?=
 =?us-ascii?Q?NHLQTPgxENiQ9m+rvkHA5bIGIGotxH+x4aS6fOcdSl3V/Z9Vdl1R4eYuB4rp?=
 =?us-ascii?Q?PibRZ0F48NuxQl64BC01hdzgNnIBiHY6bsT9ywbbbuIHEs9juaNQpfH43utH?=
 =?us-ascii?Q?RmJ26vyj4M+RzqSzwtBxtjDtJmxsluLFw23Vgtb4Vl+fu4aHtAAshc0SsfVs?=
 =?us-ascii?Q?KeDcUjtNSOzCh5/6LHJDctlQbce+nGgsddY+OzYSbD531AuL98KZ5SF8z7Fr?=
 =?us-ascii?Q?j2v2AH8l5oUwDEKg96g8dyw9WbwgjR3perpTtcRhNZ6vIJNKO+NlPJ1eJOwN?=
 =?us-ascii?Q?QahhlxMUhG17KLwNBpe8gUJCMwECM8hpkv0WZ+KZ8n7cxsrn76TXhNaPQLkg?=
 =?us-ascii?Q?ZPog5qaaLKdRmreMqG/5LOKC+mIskq4osnlw1/ykIEvWdL+Z+hfui0A+Y6kd?=
 =?us-ascii?Q?X+ZqvlI6qkTACCu/S8SzQwxOr9r4ad+8wAripKOMREdxdhoFLvzkq7TR0cKt?=
 =?us-ascii?Q?9PLtTihtKY96JgatJ7K32Um65qoLRxPk1fFrPXaEwZopX0JlbxNJ2PmZc6CT?=
 =?us-ascii?Q?c2s9f+3hZ8uZdf5362G+V5/9GgWTcbYymwhirYbRRQ+b2YqIC58wMhaBZzzr?=
 =?us-ascii?Q?nmYey7uF49zsQvFLQC/bEukYN/0cE8+5oOK6lxC9IoU7R05Y4EcmsAxkvvyd?=
 =?us-ascii?Q?WI9Horq93wdfzHT3rq6ohLlCKzKL4LLckofX7eIGg/O5KgemXfYVBt+BIyWy?=
 =?us-ascii?Q?DVeA3F52cTT63i+33QlL8RZyONH2MzxLndz9C5+pjqSAsUcypbrEe+hK82xw?=
 =?us-ascii?Q?jrHILf7b3rnxV+9g4Rnwk1t8BQrs6DbGbKrdhPcEL+kSkMXMge5Cv66BfD7k?=
 =?us-ascii?Q?T0eXB4TKrDo65EGnwIujTV9YHdWogSHpzCglyWu5CYS8VzOpbTvzuwDmFa92?=
 =?us-ascii?Q?ABp9ozuUKmoEJwekHgGfOXL2pYIKLhFCry59sngkGjQHOLoL8epSp6MEmni7?=
 =?us-ascii?Q?wYDwNTtzycwDachnpRKmUonbVukTp/G/FJhhV4N+uWnh4PI4YQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?njzf3v9ys8PfK+hpyT3ibOqeDanyaFWEACPrftP1L1RgzTn+p6JBWoRlz8LE?=
 =?us-ascii?Q?udEc0rWg1rXqYxswNdFN7cgix9aYfIOewXecfXdIEqV1KmhEHcymOcZg4qlT?=
 =?us-ascii?Q?YC5Op/nSxcPZha7rzWCxwDLrp6I7hDEWVIlR2lA5ZCZUPviGxZnDF3UoefvO?=
 =?us-ascii?Q?0ko7JrQ8k5/S07gGYw2DuWAsJpokPFTh9KissJZbfrYU9j8Ac6FFyxtLEuPv?=
 =?us-ascii?Q?jWTQLrDYdC6q7ypJS1vIsTLR/x6TwJRqluKABBtJxxjQX3tGCT5IRU3RPKdV?=
 =?us-ascii?Q?qNFEHgPUIsOf8ZRVYePG29tEjBGUD7sCHXcGT1DHG0RwfC4SihLcvRHAINzw?=
 =?us-ascii?Q?Ui3yqTo/yr1/5zhrtL+kznu8Cl5rJy2VhaRYbPV+p29Y+SSbG4EUfAPRktyx?=
 =?us-ascii?Q?s+7Xg592JCBEBkKLjeZ6e2hXtOyyn+NZ2D2o2vWJa1zRSrff4j5X5WAbtYXq?=
 =?us-ascii?Q?lKfCF7hMag057/gZSlBbPdYKID7tuoPOQDh+A1UFlRcRVIknQeQ64nsRkFG+?=
 =?us-ascii?Q?js2i8WZTvF10jXs/bS9u6iUI/OA4wfqCbEbVl2buNRfLR7gk5VB5CVOLsPAD?=
 =?us-ascii?Q?qHX5yuZo+uMUVzrFTnroPVdoaJzZa68NNQQku7WpWDtwJ+3KWO/EShgJWXIs?=
 =?us-ascii?Q?qqzw5wRcTGULHKYDtRLWf28UuW/L4BeOuRqxcBvQR+I8i5INKS6XBFh791xG?=
 =?us-ascii?Q?ZupZTP0KLpBLoXOfdWYwbpNiYaand/d09qWbaVStyz1IFFFCLHaVUC2qjifh?=
 =?us-ascii?Q?3wQdBmPm35/4ZDlMaGQg6GYmlvPQdydQ5SvPq3lEECk6hTz9DCjjAfaHR1Ub?=
 =?us-ascii?Q?xetA6QatndYlnvoixJpt2AMsIq1uoMgYQGH3wV+zfjmqhHY7nmkVuD4jnVUJ?=
 =?us-ascii?Q?ZOHcP/1eiBwIZ6bxdSjfeVAW2VjKEh2nGI74OdbT3zAEpdLuezz3dsxcUKez?=
 =?us-ascii?Q?u1rCfQfTXPpWw6U5xTn+nl2IwNoCTapY2lZT/OGcM64c/E4IEs4tY5555HmU?=
 =?us-ascii?Q?EGGtpmwTSuhVwc2Tx+24XYedgLAMoMsx0RWxowbFL4lBwujnnc+v5gvHEJW6?=
 =?us-ascii?Q?FN5T/B1W8Ei+h/DVD+/nm9hPsZNvGiS3zej7qPCs9pqLHjDUQvQ4gz6liF60?=
 =?us-ascii?Q?NHSYuj2v6sIOCQwQpFovSmYDlX4E37PNF4SwHuej4NwnY4n6/4PeSipHhX4G?=
 =?us-ascii?Q?4bvtscciReRw5cTl22RIl8RvXMlA3iMGj4Opa76UmW2+Vfro9gCMA6l4/9pW?=
 =?us-ascii?Q?CZ9z2jadnIkZbJ/m2RIWpBOqF81mFGsiuyFd6cRlZmYWV9nzVZ2S6Nl6tMOo?=
 =?us-ascii?Q?vLkeuKeEoCqU2CQCZPNujxn8+uwI61hZ3jr40hgmSSyjvgFf6Xy9dkfw8Ztc?=
 =?us-ascii?Q?22bzcIMcCbbqPeL4WVpohm1OoWcSDV2rrw0SKxwqV3175tqDAJRzsvJ12VQy?=
 =?us-ascii?Q?vn/fLkXBkAyPYh3oJlrFV6xgTWvLJCYiAfWa3u0sal/Zhf+4UHGZhyQoDvLL?=
 =?us-ascii?Q?Ba96LW5fNEHqRvDzNTcvx2Z3bUWfdIiwCLOrL0o5/araffKwY3eDfnlVHYfQ?=
 =?us-ascii?Q?ef98cXCM+WocEhLrAndIq0DQ3mXM9xhNo1QE7Z2f?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vFu7u4bOy8BYkNDaZ+v7tmCm5ICmmb6+rcCYKc4j5i9ozUkmndZ4rG2ooGXSpxiPESH5xxPR6bh7fUEgr5bNWUcDFBy+qpLml4/jUR81Kd0vYScrH3luHKWj+fJqzbYBaDv8bvT8piaVmBrmdeU25XlcihSnRwh1qmpn9VUOLwAK6Dg5vgfgTYeYiIfDpDRdpHA5OobNpwxLSy8OHvzpcn1jIIBjlw1B7K8KnBoyarynY0qh0r6A6kHR5Q0c1EEJWmeVKC6oK9BPmPcBoobJJA33eRRKVlmVsnRjtv9G3Qg1EcNFsUDZRh0qYWIjqVsTmj5mbCK4LLgID3SA9nXeEpvo52VqTrOdtKad+a9dwIQi687E8nn+Vc/IUdeQehXQE4a+6qP8X+Absh/NdZ0D4zbdX56GXl3/rUL4bfqL22//w0kLV77EkskaC2LsaAyVL+2ZHXTl55MF2k7lrgwrqFBckIf09GmnU3u5J0lYa929iv5GfN5CotRImVzL/5QrWuV9rtA/SagjZDzH93FDOUPxLuQLkkvhP7QzY+BXCHTqMaWcSc/be08SYto8XlpsZTnJgd8ZAAX7r8N44/O3+VguF0OoJVbTyjwbIWraGuA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6688cd-f84b-4c06-106e-08de22060280
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 16:10:34.9029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVzst0R/TCHrpLq0iv4b73lE5b5i8zpqU73zMMUMADRGBoga4MdcZaeYs0+5xLDa1C7Kh2dedt1uGd9OEZ10nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8638
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_05,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511120130
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEyNiBTYWx0ZWRfX+VBbAcpuOfPc
 h3QbAWiJlKiD0xpdcT+v0w2gTr4AtR3HqpIXbUOIvJ2xShyVTxJcHAaZvvwKARvsP/nJN/9Ujhz
 LARtx+snRAroW8vJQtS3V1eW/PZ186klf/E1iBM36HsxinUO5PIv2k3IVvERfRMvXttZzW4Hvbw
 UcRDX8+bHdBtv76fgTFmJrlBUPUv/cCBCYLgmE+YT7vlhlmsX8ltMqgahv1uuzNga76a0bE+nAX
 Bm6JJ9tlx4aLwmKLYvSDDnWHsmUTLxDCg8jFSrDTdyxa+ffF1TZ6TeHjZXdggLoMBkHn/VG50Dm
 bjhPHMCKXv1lAA0CmQcctms1NvpTZvNu4jhfLoWccS6+Z5JpO8R3mcvDJx7P6AwQ+is14hyE2wo
 u75dDK/1B4zHhF/3JZxILr+2baMwD/145kn2gfsmH11MdFSWH8w=
X-Proofpoint-GUID: glfY-WKMhWnLNKLuvcqXzlD-Cfw-LGz6
X-Proofpoint-ORIG-GUID: glfY-WKMhWnLNKLuvcqXzlD-Cfw-LGz6
X-Authority-Analysis: v=2.4 cv=Ju38bc4C c=1 sm=1 tr=0 ts=6914b180 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
 a=hSkVLCK3AAAA:8 a=7jtmr7J8IhXo0RXn3EwA:9 a=CjuIK1q_8ugA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12099
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9DBD24000D
X-Stat-Signature: k63xpb6jppg1k7w5kafy6idchzx7j881
X-Rspam-User: 
X-HE-Tag: 1762963845-357342
X-HE-Meta: U2FsdGVkX192g97lzd9HoaoBr/kpVz1E/hgReClUZUWv+JW/8WfcNGh8Ob60bHGrjr2XO4ojaiDuU3mCf70rVtESdXmUZWSgpCaZIQWELHOhc2N6yilxDko6IkpAVRGu45Rw69O+S1UQlfTvhd/7JjAOyNypARNEqIwN8TCEY/t7WfLMtCsFGpGCHUHj7ZqM6dlGebkp3w456CTbHVQBOCx27R9LoUIU7JR+M/Uirf6o7T/69MRy4udF6irQ810XP6+V48a8YDzltlNhukccJsHGME8fDMRA39Gj/igCUsu9IW2jep0Z7iDnCKiiXJ34rtc4aKiGJxpexExLNQa1bw1vvagter9fz9PBdUE4vt+eyIOj/VwYwAnStzjaTlIjvLhHKAD0asEicDSGU+ietiLr5nayoBdZSLnmd7pIyzo31MjIS62DS3Jh5A66FelLwz2j5VOUfPHyXkjaslC0zRW+s9mEBwzmIADlZydRBvkHkRRMtpDiUqHIDyaPhQaA3hoBcrD/yqMZ9VY/w6V4w5zBjvp1Xs6fupeHGbPUM7WQxQks7r0hWwkWATWZAUFVVEbCHgSMXc6xrMl6MOD4c4+3r/23Wi2Zdl2e7c9qKBUZAgptQDW3IjJi0BwgERH2unzJAXYg9ssDobYAddC/7SSjsocPPYY0yuFonT8yImssWVyqpYZeM3WL+gF5fKDMaEg1o7lN3VJXg1LcQKc9MejCJfK6xcFBPFVE6v7R4VB5gu6k5ElZvGZMayNbkKkpHUZoZJKb2A8jopoMSv3+j3ON6diIBVpa/8YTTWWJAKDa0AfRU0Dw7keQZ2V5PdY98R+1QBmuwedKoH7ETbfGqezc8ce/rlUAErkWL6rYt3/GugkzmA7PX0RCsSD7DKPyU5ql441ZL92AZfpSgqnbap8jm/vhcZuztR+cjgHI4VCB6/gRPDmYwkN6rNAC7/xkuwRcwHxMKbJcMVkHTZa
 +TWQljvs
 SxdDqUx15rjL+KH43JuulfmdC8z3mtXH1RPMhzxScAy+7A4vjAWbVmkSdjWNrSZlPWrslx+QcClGGMsb7wccUI68XpHPeN6ea/JTMFMYPcsJfprx7ZNfsSdsH+YRyHSmKVHFLwnW7d4OELpwj4RjTwObXUQono9TsyXdvv9M9SsopVcVLERScyyDrQ9FCh5xmad3EAUEHk+Ja5+oDqd3qJetRlI4D1K8vBxQrCEMeKE2jmOP7BHQ3+Uo4ontH6rHJz/MUbyf5rn8+jxP367owDRpstdClv2ZQbz8WW/dlvE8oyMwY4dakYTlG4TFc08yFwwvXzH6Ku+Om0n4xsM6pvqiIjjIbSOT8b6r8jGK0rUvWSBh/qlFlSZE7vI9ANCgv4V8/T4LS9TQSSLMxWIr6wrBS1pQK2qZkyxbWyMP5Glf9tscIggQHHj0ExzHbjhTdfh/adIsmWWn5g71XaYuXwSmRLRZxqgdDL3kcPfqoyEbP94EPDC/0brWDe4vvH+dsz2nSUcAZAUmsCp5IurDSlMII4ctjT2xDM9+L9jqAuFkStF7NxpRVVbdSNWM0soNgUD3k00PdN5DxoQixzxWm151mIgtnoV41AMPcbC0UgJRaxv1H0Lok3RLdObczO4pVklxRNjhDSLK/sFuagO0eUrLgXLoxFOLob9nH54v1ZR/nzsyQUvcHNKhGfMkgSqlp40SY2vD4UbJ8pfni6mMMhS2jxJHyl3jyZlWoxpsdWzJ7qHHTaFb2myhp76b/kfkpXSCvnPItfgPzWi/Zb34Ry5qzpwJAXVivLKvKcfTiLYEYzClSeUlrXI4gMHsv3Re6Rnh+KFasjX3kvRVmgBarpAMC8GT2xqWXOdRQFwLR4Xu1UE0M0YZsSc4XUlfbVzlX1n2PeJ2J7/NpzHSq/v1NzvuRz4/uR6xOlnNZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251112 10:06]:
> +cc Paul for hare-brained idea
> 
> On Tue, Nov 11, 2025 at 04:56:05PM -0500, Liam R. Howlett wrote:
> > The retry in lock_vma_under_rcu() drops the rcu read lock before
> > reacquiring the lock and trying again.  This may cause a use-after-free
> > if the maple node the maple state was using was freed.
> >
> > The maple state is protected by the rcu read lock.  When the lock is
> > dropped, the state cannot be reused as it tracks pointers to objects
> > that may be freed during the time where the lock was not held.
> >
> > Any time the rcu read lock is dropped, the maple state must be
> > invalidated.  Resetting the address and state to MA_START is the safest
> > course of action, which will result in the next operation starting from
> > the top of the tree.
> 
> Since we all missed it I do wonder if we need some super clear comment
> saying 'hey if you drop + re-acquire RCU lock you MUST revalidate mas state
> by doing 'blah'.
> 
> I think one source of confusion for me with maple tree operations is - what
> to do if we are in a position where some kind of reset is needed?
> 
> So even if I'd realised 'aha we need to reset this' it wouldn't be obvious
> to me that we ought to set to the address.
> 
> I guess a mas_reset() would keep mas->index, last where they where which
> also wouldn't be right would it?

mas->index and mas->last are updated to the values of the entry you
found.  So if you ran a mas_find(), the operation will continue until
the limit is hit, or if you did a next/prev the address would be lost.

This is why I say mas_set() is safer, because it will ensure we return
to the same situation we started from, regardless of the operation.


> 
> In which case a mas_reset() is _also_ not a valid operation if invoked
> after dropping/reacquiring the RCU lock right?

In this case we did a mas_walk(), so a mas_reset() would be fine here.

> 
> >
> > Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
> > lock on failure"), the rcu read lock was dropped and NULL was returned,
> > so the retry would not have happened.  However, now that the read lock
> > is dropped regardless of the return, we may use a freed maple tree node
> > cached in the maple state on retry.
> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on failure")
> > Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=131f9eb2b5807573275c
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> 
> The reasoning seems sensible & LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> 
> > ---
> >  mm/mmap_lock.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 39f341caf32c0..f2532af6208c0 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >  		if (PTR_ERR(vma) == -EAGAIN) {
> >  			count_vm_vma_lock_event(VMA_LOCK_MISS);
> >  			/* The area was replaced with another one */
> > +			mas_set(&mas, address);
> 
> I wonder if we could detect that the RCU lock was released (+ reacquired) in
> mas_walk() in a debug mode, like CONFIG_VM_DEBUG_MAPLE_TREE?
> 
> Not sure if that's feasible, maybe Paul can comment? :)
> 
> I think Vlastimil made a similar kind of comment possibly off-list.
> 
> Would there be much overhead if we just did this:
> 
> retry:
> 	rcu_read_lock();
> 	mas_set(&mas, address);
> 	vma = mas_walk(&mas);
> 
> The retry path will be super rare, and I think the compiler should be smart
> enough to not assign index, last twice and this would protect us.

This is what existed before the 0b16f8bed19c change, which was
introduced to try and avoid exactly these issues.

I think there's no real way to avoid the complications of an rcu data
structure.  We've tried to make the interface as simple as possible, and
in doing so, have hidden the implementation details of what happens in
the 'state' - which is where all these troubles arise.

I can add more documentation around the locking and maple state,
hopefully people will find it useful and not just exist to go out of
date.

> 
> Then we could have some function like:
> 
> mas_walk_from(&mas, address);
> 
> That did this.
> 
> Or, since we _literally_ only use mas for this one walk, have a simple
> function like:
> 
> 	/**
> 	 * ...
> 	 * Performs a single walk of a maple tree to the specified address,
> 	 * returning a pointer to an entry if found, or NULL if not.
> 	 * ...
> 	 */
> 	static void *mt_walk(struct maple_tree *mt, unsigned long address)
> 	{
> 		MA_STATE(mas, mt, address, adderss);
> 
> 		lockdep_assert_in_rcu_read_lock();
> 		return mas_walk(&mas);
> 	}
> 
> That literally just does the walk as a one-off?


You have described mtree_load().  The mas_ interfaces are designed for
people to handle the locks themselves.  The mtree_ interface handles the
locking for people.

I don't think we are using the simple interface because we are using the
rcu read lock for the vma as well.

If you want to use the simple mtree_load() interface here, I think we'll
need two rcu_read_lock()/unlock() calls (nesting is supported fwiu).  I
don't think we want to nest the locks in this call path though.

...

Thanks,
Liam

