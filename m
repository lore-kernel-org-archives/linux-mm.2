Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469BCD340A1
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99CDD6B0089; Tue, 27 Jan 2026 11:34:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946836B008A; Tue, 27 Jan 2026 11:34:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4206B008C; Tue, 27 Jan 2026 11:34:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD706B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:34:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21A76160255
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:34:55 +0000 (UTC)
X-FDA: 84378292950.04.FD82C7A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id E44B4120004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:34:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=d8monSAR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aCfA8615;
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769531692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PlkVN4tWIQUp34f6IseHvSIDopnx6113rtk/tejfDQ8=;
	b=7Zix3qvlTJZhxYB+4fuS+Ij0dhI5kmlAkB3Yp8KCI0gSGR/fPl/59+8rsIp6RUw25b5g2C
	0GrOkqiRX+G//9rNzvVcGyBKEc3QwhDL4iUkz/ZDwli+cmprszfqE2ugGw7Li4IjEH/Abc
	wtaf2wbarNrz/A7IsfRuxuJ96yhaunQ=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=d8monSAR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aCfA8615;
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769531692; a=rsa-sha256;
	cv=pass;
	b=HZV9Q3PYKIEpV43/wIrRHvQe3JMC1dCeVuXKlU2XF93XejP1rqYsf2hXC50VWYaAy2SE8W
	spZiT6pXiAG1ci/nN93wT50v7/9gDRzOUL7vQy9CxcWfvTAw82DFW13L46KwvnRfMBfsoP
	5mEKjrHBxQXyRWKT3Pg0JXTqUfhDD2Q=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RBELXf3922781;
	Tue, 27 Jan 2026 16:34:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PlkVN4tWIQUp34f6Is
	eHvSIDopnx6113rtk/tejfDQ8=; b=d8monSAR5OQZDr8aqgYMgwC1BlVBydz9cP
	YKuQJv7m8YZPFZXAX9A0cJJEWGsDIzxGJddzu/rxbY6bW5QHl15KbEDF8lIZl2j7
	yP2pC5jJzR1aJw2CUkkDHKBCu/+JVbvstgMyHWtZ/9ktUNychqv9tRqEhPumYtOW
	wg5Q+r4V3RmP2PxK141P6+tWgqgb83FYhBAR7W83hME5Mno8hts6ljIz4f83UqTk
	9MuzL0/x6zBjL9tQx67L3C3KlSR0Iu2idPP99iRwbo8KLw6N7N5lDWHkoM7BWMu5
	tiN65F8zPyYOFJNBlECtFHNlQwjTC5UVYxOcEPmQpXEjDGZF34aw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmgbvbar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 16:34:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RG4Gdg019819;
	Tue, 27 Jan 2026 16:34:43 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013036.outbound.protection.outlook.com [40.93.201.36])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhey174-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 16:34:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNkVZ7ybuUDabL311x2ebno/Ry2tBhJ0SpMsTgbWoqGirHs7T3hwuoKq28nRC5kvVOyeatypls2cZui5/2/BzVXW4wnUiaMOU34s4h80tZ5CZBy0XAHlMoSDjf19LX0v4yYeWevQhbK2wOzrCqpl+ftUWzvOuViOadPUD4NRnr2pY5nonGGsheSDrPizBMDNJOXlqvBV0ZdqYe0yO2uFJmC3JxAEdlaK9G5YB2ceq5qcRKCWtU4u610feJb9gk8SzQCuBos9q1kvCDta3uX/sHhel3V5uhSQx5eWQC9XwPbiKoeIFmmNSJoXxXkRAEahJB8j1i5Zz3gXpETw/7x2og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlkVN4tWIQUp34f6IseHvSIDopnx6113rtk/tejfDQ8=;
 b=g98JCA1Zj+GS6nYCFZfb0CrheTY4wAMOpWLQ5C8vdIWKJkqChzYrRA6eg8U6B2kowdKpECtko5trytZqfT6hMucinRlClWVWhmznuV2LTzj1UDrZWTql13TlDfXcQdLbsp0h5rK7qcnKyBUzlpx/4/449DR6wdZf3TAVCWVx083leCy2mMu/nbsq/zTS8CmqWoOofaOAOuLpfqZE2VeUZfhXKLpZeyYBePVgNlX3YMegMY/dqdmSD4oxmivgBNoOoRiQgpO1T7lyKOLnB4NMcInJLyVPcDfHo81pKRtKzoWpgzQM5AJMzWzcSuz9BxFukWOGpdqEreUaPT8tTbYpAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlkVN4tWIQUp34f6IseHvSIDopnx6113rtk/tejfDQ8=;
 b=aCfA86151/loRgHcCktXFC3lNiDBut/5ybll22K9QPUgzG3/ucfo7vS6lPzWqUzPia9IDsLGqj4cMOX3aVwn3+xL5alikU0OKeAFz2dlOVln0OEmrFvuUturWQwLqkiF14pk+5t13gUYiPzD1e+bqZ3jcf/HaxMlCNb+SOfaxu8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7561.namprd10.prod.outlook.com (2603:10b6:610:178::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 16:34:39 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 16:34:39 +0000
Date: Tue, 27 Jan 2026 11:34:35 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Message-ID: <r3qfus4j6awmixdbcopgva3lx2l3lrvlvuoqqns64q6qp33qep@2hsrrvfsojsm>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0289.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7561:EE_
X-MS-Office365-Filtering-Correlation-Id: 78112687-2d41-4a25-af95-08de5dc1f723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RqDQJwNkMiqRWeldVq+8uMYgU8B/oc+CG7OKwY8oS272OSDlcPo1dmMwRuUP?=
 =?us-ascii?Q?yZ1iJOUHSvbl62CcCaiPMy21JrdwmjByYMzu16FhX3TwGxxqDIxcr1m4tdzH?=
 =?us-ascii?Q?NJz/AcBaLVikduStvOdKDmExB5yqrgosPz+LOQU04oxA3tEhBnA7KtbgdxT0?=
 =?us-ascii?Q?37pTVHju2ML9KAEHn5gnXC/V9pClPacf2LOjwJGEHvVwrnaVGFJMBBhF/pRC?=
 =?us-ascii?Q?31GHNEfL9vIH0ptL/d1E76hVEkZWCG2mo7mvrINxN658sAhbTh0AzRNukX3t?=
 =?us-ascii?Q?z20FEZT90X69Ys30EQtF6uEJsNcnssLC2YvH7wSX+dQT/KPUUwFabLRr7JFn?=
 =?us-ascii?Q?zjB6igFye8DeWywfZyREqT8kWcM2zJjRECu0h8I5wmsQ+aI9Q8KnCVYmif1S?=
 =?us-ascii?Q?t4qiKBiXIOJJSlIDipeCyPVn15kU991fh8EmRT0sdUWOYGw9CE6F/A2byik5?=
 =?us-ascii?Q?06F280PIKa+ax/XwtXuFzkRT/7UV/4xHDAl4/wQVyQvh6RmmQSqoUlJNlTe4?=
 =?us-ascii?Q?/DQLr2LuBVaCCveJcO3h4cLg4FZ3uGDS9lcxLNEVoqh2/OUs18GiyJ49MEdS?=
 =?us-ascii?Q?RJIu+Aa3BdJLjNZte+sUGtkhKvBsuR9ynuzoOvIvDUjEGPkAABdvB4c/Spoz?=
 =?us-ascii?Q?mWd8ATKczmGem9jhC4lLiiyZ8oiKeSxJh11D09QEzu+J7Loh7T/lOnyURd8H?=
 =?us-ascii?Q?8z/mF2xCe8S8yGbRQoyP/S3PqZam9UuJrZ6GPhvQfKC99NPt2gzWpIi0/9JN?=
 =?us-ascii?Q?rlR3DuTiukDC09jf+6gMEUQugf6BmUY87zEV2py3C4ezkTplublJKHm9EDR7?=
 =?us-ascii?Q?5uzxFKLl9BdRwL6k1gyg+zY3kLUjCEXXByOjxFqfbF9q7kmorDBrHoZYuL5L?=
 =?us-ascii?Q?+ESLWsHWg7IeTK95VLRqbYY9WD6eS9IYbJt0lG3Mpkghm5RDVjGntz/PD68i?=
 =?us-ascii?Q?7KR9qh/QZU7T99IW5eXTZ1VIy0I4Mueou7yftpYQZ/jfQkARwwf2ymqbfrg/?=
 =?us-ascii?Q?SXk+Hb5uNJnoPTE8agdNn/RO4yNc36W+3sGA5g3YqdBsBm0ZseNtI/f3SA7o?=
 =?us-ascii?Q?everJhLPSbhL25Gkk9s5v24rCtzNuFV5BpsvWH0eixwo1JEgXBxyaQme23hX?=
 =?us-ascii?Q?Z+/cddGmLYw72wlkSOZz/ZPmwSXD+s4yltGH9YNM7Tv0ODCryBiI6pQqt2C9?=
 =?us-ascii?Q?z8bmc69Ouchd3QK75DkdKUBv4MQtXzabyFsNfBM48l5fjnpjBe6mLkAvxp5+?=
 =?us-ascii?Q?5J+d0P4WUU8l5igwf7vfreSdx0xME8fLSey502czBYN2kUIKtV0bIzhfESX3?=
 =?us-ascii?Q?m2JgCtmBWOU4Q+UNQkRVhQO2p4yV7rM16ILTJ7r1sawXeSJo6aHcS75/28O+?=
 =?us-ascii?Q?jOqXvjkV/3B9uVzjZ8BuxVb0sl1yh8p2e8rkGbrUNCp0mdMQmdNJ4wzBXETv?=
 =?us-ascii?Q?qYqXNS7EjDTnF7W5waxeVw0viCx+oVH90AFIFkCl/zyTVgyeyF348AezGwml?=
 =?us-ascii?Q?+bn1bEp3QWItISLrQpik70zUlyUf464oDDZIlYpLujMfXKVkwKyMh8ZPnl71?=
 =?us-ascii?Q?tcBgPib7Tn4r/qfQY6M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1fj/iV29uXPFIGe6Jg/usTfPy/0J5xZ5Iairc5jS5WtOYFcXOPUpaWpbzjYH?=
 =?us-ascii?Q?XABMGf4LgemML5g9VWyZhHE2VwFUEWdFmZ6HOG5RewucyVDRebqVPx95kPsb?=
 =?us-ascii?Q?0RUBhTnLpkiEFrIYsupqHlp0aa6+mXCrqMKQNaAgvTHSU9WZBImzY06XJ4+D?=
 =?us-ascii?Q?LqZLP+ORKAIVlWWYJtsjbRmb2hFEqf2Bp4STJJzlmAM/94fZp329H8Yly0KM?=
 =?us-ascii?Q?tJiyuUx7FNdBR8scCzlw/LLdS6FLD8xovkJOUEKW0E73v7trdU/j13eJD9hk?=
 =?us-ascii?Q?Gi2bIpxtjLBE5Q4dGZ/K8+88Pf9eI/7ASoGGr5Ph1U3prbu0o2jEzcRUr80P?=
 =?us-ascii?Q?lZcGFuuS+o4KUxWLTHOLHafDOZnHIzW4XJeejmpI+EteO5XpPmfD1PbMnLYf?=
 =?us-ascii?Q?ZFuG8rXLZ8kV+wF+acmBjpu/YPfazHoZTV1kSY8uueWhiYntX95+q1R0DOaB?=
 =?us-ascii?Q?Wzxw3T9b8/FiRbm2duMMepJ1oiU3+B/dM3fzXeuwM7AGnGXlCqYo1QYNTDYx?=
 =?us-ascii?Q?8B/WGfTbBARTx0vk04bkEs3RJp+b6kZAYZsjup9FxnFYK2nhItPGRdxUEwuj?=
 =?us-ascii?Q?ws/jQaht/S+Py/TYLovysbPdvSe4cRGikfexGwUzOVGjkNaiAJfFGgXEnr7e?=
 =?us-ascii?Q?0vvuR48tYwVHYGCzQ+UirMekjDqYbKnPMQL0cv3j96PjWbjg50t4v7w25ixT?=
 =?us-ascii?Q?hvOsY562WDk1SwbhfRm3I8Qf0SPN/5O7cuv+KbOBTpED2/BrKK7ZHW9fPKXr?=
 =?us-ascii?Q?obLWInr2vMApRkiHou2is18gGAqSfhsHWMh4q4wTdJJYTpouwH+KY78s8eFg?=
 =?us-ascii?Q?NIa/ujH/thFAH1XvuCnJX6K63vNYIagdYXgDOyONLFE6qvv0XD91DBSibZVy?=
 =?us-ascii?Q?GRb0Bq3X1kBgGuAwRNmev/lp67Chpu86sz21pmAFQ88jpKoaekXokteYvxPS?=
 =?us-ascii?Q?zQPSEUAiH0zZAzMXnK/UjLnK4EEXXlzh8mhzQopi/9/vvzIek904d93oWfSv?=
 =?us-ascii?Q?jSpd4h6tcECGLI+OKdqk7w76d9XTgV1PmN2V+uz2kmL8wIcR/6cVnjII4AGA?=
 =?us-ascii?Q?gt0wjn0IgMGQ0KdGbcHMJmo+UiAXL+2jJLOmVoqJgxBIC4vuIeYv0stg5I9H?=
 =?us-ascii?Q?fXPew/h923U9RvXiPhboE1inpnyT1DIeUxIDf6NBNBG7z/izrNgBg/RxN86c?=
 =?us-ascii?Q?LCYq9goxdrtCJPPNRmq4oSCeBCOdYbBvh+1ywy8t9CSFvZQFykyoTQMmwicX?=
 =?us-ascii?Q?Tu/p+VzNZ6nq6NY3+A88RgeGyS5OWn76PAKu3bjGtkrMplQpbKycODrzHCoV?=
 =?us-ascii?Q?lroBOcUfamla9U18a5NGAjBQqA/uZFFIitqw/1IIY4r3YbRJbzxSvF0Fjlpw?=
 =?us-ascii?Q?YJt5dCuuUVmTLGSFeVCK93xjL9J6zzerJpnfRUpqD/8BQjiGpy2qKnhtw9GY?=
 =?us-ascii?Q?Rm9MCFXjpjqLdGD62j3uglfjySfSaG2WXj68dpdW+mS2LG8KNtgkWZAp+rV0?=
 =?us-ascii?Q?3Sj3u72aqAatIbk3vb7PqU/T9XhQfkujemaqCxt3cVnEuMLHO+PEG+ztJS+b?=
 =?us-ascii?Q?lZW+RUChWIpsp7pCgaWiOHv6LyfvtMOotwnAsbjZnl0igJCAew2bnfsKF+oA?=
 =?us-ascii?Q?miNyrwAk21m5ZZY2wreUFtg78TYVo3RWE2RxKSe0GUTCgyoqAu6jqIVkyeww?=
 =?us-ascii?Q?XiNNNHj9Ignx3dBgKj82t2fvTDQ7EpEsyEzs8y/p74Bx8AymGYP/qps8//8K?=
 =?us-ascii?Q?rLo0lESTHA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WXPwWz6QK3L46iG55Xyshp7n/QsqR4sM243jJBlwXuEtFLwr0mQAwOLD2196A1bFw2r4ooFWtZXce2XJ9hH8nRn0Bf0qF145I32aEgUJ3pHEjpxxIkEMmrMh4Xhghi7hQ69s9Kx7Cq7fD+eT1mpe1KBYkknBTvkkdp9nQxJlLMxVNi+Va2PN8/52Z0c/DZi0htLbVH9R0NY3dJ+d3Cd+mn45NOnoeD2GEJASYBlFFjXr3J2Hb/dQCuWlf0eyY6yeIdYmN3zAbfiur17fv9JidOwLjj1oLx4pD5EU2S4SAJ2TBO2KpgJ5fXX0bNWbPdC/ktt2kcvhlTvThX3lddGltQYz+0YOB/gwaC1W9xT5USlsN5LX/EKBMHf65Jm97tU14OAUSDYEBiOQ0HE4D3LiMYqT1H4CDkxS4uTqINjjgVSuCZzHhkoG19AMF20o7c3bw6JiNn8EcvSeoUMqYo26zOa/N+a9tkbKWzk1ZsMuHrOu5RhGMHhF/oDBdSD42jBK4x2jKPrzSr8fMqrkLTYhKyQvVuc484hF27FLFzWkuNZpdA+jZWNBblCRjIl6kd9GYjRcWywZDZOehRXX4w34cFmYS+lP82GKFWbtcRGToNg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78112687-2d41-4a25-af95-08de5dc1f723
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 16:34:39.1088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7tB9PmvNkV8l69e4vw0X3PnUeQuUsW7/DO84tGyHluMklbOGyy3wDQoGU1llUxMkvJqcf1zXvdt4jRhFaFHwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270135
X-Proofpoint-ORIG-GUID: yvkRLZMN7dGc_XRMFXn8zoaGjk3FeuuF
X-Proofpoint-GUID: yvkRLZMN7dGc_XRMFXn8zoaGjk3FeuuF
X-Authority-Analysis: v=2.4 cv=AqfjHe9P c=1 sm=1 tr=0 ts=6978e924 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=l0hdsvYX4KKQlnFdKHcA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEzNSBTYWx0ZWRfXxCLhKihyIVNA
 x/SIij7GRsbHKza4TMgO8Czm9ZYmWxGpHwp8FBthgWlU0MNYcQ5RJoXFk9SnALbca+dNqIXhKQh
 qjfShG989sUox890Yfpkee3tXD5TEh1FcvPLTBW0hxiaYe0Dv5UKcSm8tkJ7df7lTuJEho3Qyia
 h1NwrdB4Zw+o1iRBBg2jkGiylH6dd/Kcea+pbqP45Bu0e+fgQO6WttBbPAL1f+r9NxOpsL3hmFu
 tbiqAcOzApIl/Ai4oXYp+U7VubfVgtTMrQu3XFtR4yJtfNdLeGggMBL4NZue8JnESOd6MKHcxZu
 C+F26jkthxtTxlS6LHb7AwX4ni1t3uYoZL9mXfrg5yhPTdArcm5a/91YyIfBj93Dro9jIz3H80/
 ul5wziFIaeS504KrWXaZUG9zo6sXx/yDaIdPY+yFhEvPg+jrocbj3iUpLw4vJQga0i0up7vSLvO
 f8sG99Vq+AubOzGE+tmhN/XSwag4yUQ7EHCIJygM=
X-Rspam-User: 
X-Rspamd-Queue-Id: E44B4120004
X-Rspamd-Server: rspam07
X-Stat-Signature: akrkg9mydihxw967c37x63fk5r6p454c
X-HE-Tag: 1769531691-600237
X-HE-Meta: U2FsdGVkX18r1JLF+y/ysLI+ZifTmivi6BAW530OW5VfaXsoh1L4y3su5DSfeTqMcQAaMSpC3zzUzpPL6T8qEmgVMJ0IDaFvlnZN1M9aW4Os0BQfeujaVpPyBFQglRuGobszSvpVUd7SpJ54OlXyzrKqqpkxgvljWXJ3QfMO038YPOvbWgzd6Vm4r0/LnWRcb12/5ZW7NzqIY9sbNcB03DSqocPAsmiiBrDpoRaxKIhKz2k+kTnoJStJ8EI/dCe3tTK6hmKSxiPV1ISYcR9utN0vT3WIQhpjMiR2/i/WC8YLr6oMVLncctQIHln1s7PuwFhYn1ctL/+3KJxchrcvndbBsQfe0TEzeVruWVgMdpwBimIhY9EnnLST/WbYDRUQBsct9AaxU5tutcB1Tta7m8AyZf2fH0qiO8/El3HUQu4Q5uJnzuTyuuYSG2HWMT0TAJVl/VzjS7LuLxJygaXzme7JpjxEEAwe08RGUlmYxvQnnJL1UM0e/9nZiBYZGjaDec8pRTAnfCEMxI7npHbdB0jWe7tpEPDoheoof/JH5sKIJqY0EqLq7VzIn10j72B5ipPMEBKR8AVgB6uHLud+uqV+CQaGQ1N9aLz5rnHoxoGzB1oZj9MiYriEIQRVEejMsD5vxBaggv9JYbivgybo7wSeM1fNFerjCCa2jFWLU7DIbOk+i3UbgjBisD4eaR5LHIQe3gGAe02+Q1OU26YFcagGyS0isezFxVyI6m3W1wPT0VSVhfkUN+UaAdBI6QZGuwCRiO8RnCBl1FYfu85qt2y5nb2pHA1OvKCJ+f+x5qUBD1CLUIhxuHnMfEczWBEkDJz2rX/B4xhADmJXuMAUv5LynJFwq2OpIFyNeZEHu3SoAnzUfA4iV12o9tfQ9bI1OBN8QwgP3SPbT15pdraloe9cu94sZTPYsuSqaz8bgLNyRV1stXFcwEsc5Z85IMr+Frb1Qd7sW0qAR/TDpfX
 Z3gd6+Cg
 8H86dDvxfVLVo2iU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [260123 01:53]:
> In the first step to replace cpu (partial) slabs with sheaves, enable
> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
> and calculate sheaf capacity with a formula that roughly follows the
> formula for number of objects in cpu partial slabs in set_cpu_partial().
> 
> This should achieve roughly similar contention on the barn spin lock as
> there's currently for node list_lock without sheaves, to make
> benchmarking results comparable. It can be further tuned later.
> 
> Don't enable sheaves for bootstrap caches as that wouldn't work. In
> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
> even for !CONFIG_SLAB_OBJ_EXT.
> 
> This limitation will be lifted for kmalloc caches after the necessary
> bootstrapping changes.
> 
> Also do not enable sheaves for SLAB_NOLEAKTRACE caches to avoid
> recursion with kmemleak tracking (thanks to Breno Leitao).
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Is there a way to force a specific limit to the sheaf capacity if you
want a lower number than what is calculated in
calculate_sheaf_capacity()?  That is, it seems your code always decides
if the specified sheaf number is smaller right now.  I'm not sure it's
practical to want a smaller number though.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/slab.h |  6 ------
>  mm/slub.c            | 56 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 52 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 2482992248dc..2682ee57ec90 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -57,9 +57,7 @@ enum _slab_flag_bits {
>  #endif
>  	_SLAB_OBJECT_POISON,
>  	_SLAB_CMPXCHG_DOUBLE,
> -#ifdef CONFIG_SLAB_OBJ_EXT
>  	_SLAB_NO_OBJ_EXT,
> -#endif
>  	_SLAB_FLAGS_LAST_BIT
>  };
>  
> @@ -238,11 +236,7 @@ enum _slab_flag_bits {
>  #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
>  
>  /* Slab created using create_boot_cache */
> -#ifdef CONFIG_SLAB_OBJ_EXT
>  #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
> -#else
> -#define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
> -#endif
>  
>  /*
>   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
> diff --git a/mm/slub.c b/mm/slub.c
> index 9d86c0505dcd..594f5fac39b3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7880,6 +7880,53 @@ static void set_cpu_partial(struct kmem_cache *s)
>  #endif
>  }
>  
> +static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
> +					     struct kmem_cache_args *args)
> +
> +{
> +	unsigned int capacity;
> +	size_t size;
> +
> +
> +	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
> +		return 0;
> +
> +	/*
> +	 * Bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
> +	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
> +	 * have sheaves to avoid recursion when sheaf allocation triggers
> +	 * kmemleak tracking.
> +	 */
> +	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
> +		return 0;
> +
> +	/*
> +	 * For now we use roughly similar formula (divided by two as there are
> +	 * two percpu sheaves) as what was used for percpu partial slabs, which
> +	 * should result in similar lock contention (barn or list_lock)
> +	 */
> +	if (s->size >= PAGE_SIZE)
> +		capacity = 4;
> +	else if (s->size >= 1024)
> +		capacity = 12;
> +	else if (s->size >= 256)
> +		capacity = 26;
> +	else
> +		capacity = 60;
> +
> +	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
> +	size = struct_size_t(struct slab_sheaf, objects, capacity);
> +	size = kmalloc_size_roundup(size);
> +	capacity = (size - struct_size_t(struct slab_sheaf, objects, 0)) / sizeof(void *);
> +
> +	/*
> +	 * Respect an explicit request for capacity that's typically motivated by
> +	 * expected maximum size of kmem_cache_prefill_sheaf() to not end up
> +	 * using low-performance oversize sheaves
> +	 */
> +	return max(capacity, args->sheaf_capacity);
> +}
> +
>  /*
>   * calculate_sizes() determines the order and the distribution of data within
>   * a slab object.
> @@ -8014,6 +8061,10 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  	if (s->flags & SLAB_RECLAIM_ACCOUNT)
>  		s->allocflags |= __GFP_RECLAIMABLE;
>  
> +	/* kmalloc caches need extra care to support sheaves */
> +	if (!is_kmalloc_cache(s))
> +		s->sheaf_capacity = calculate_sheaf_capacity(s, args);
> +
>  	/*
>  	 * Determine the number of objects per slab
>  	 */
> @@ -8618,15 +8669,12 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>  
>  	set_cpu_partial(s);
>  
> -	if (args->sheaf_capacity && !IS_ENABLED(CONFIG_SLUB_TINY)
> -					&& !(s->flags & SLAB_DEBUG_FLAGS)) {
> +	if (s->sheaf_capacity) {
>  		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
>  		if (!s->cpu_sheaves) {
>  			err = -ENOMEM;
>  			goto out;
>  		}
> -		// TODO: increase capacity to grow slab_sheaf up to next kmalloc size?
> -		s->sheaf_capacity = args->sheaf_capacity;
>  	}
>  
>  #ifdef CONFIG_NUMA
> 
> -- 
> 2.52.0
> 
> 

