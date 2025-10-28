Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCAD6CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F367780125; Tue, 28 Oct 2025 02:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E1E800E4; Tue, 28 Oct 2025 02:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5DF80125; Tue, 28 Oct 2025 02:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD4FA800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:49:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6753CC03DF
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:49:31 +0000 (UTC)
X-FDA: 84046596942.15.D349F6A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id E14CD160002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:49:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HmIVQkd6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wcD7uLYf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761634168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UMxuFIIDXgtlZtk+KSD8E1KBqM1w3deXZv0I6TY+e8=;
	b=lHQHytV9h3I89dmvBpXATDBwrNZJ5CUY4jCI7ITBfg29Ol4BaIU9tkS9WeYkDuswUP+KC4
	ZrsP4cd3rtOkyJp5BEz3uH/Vzb+ETAWZ0ht9ySF+rwixFw0NL0HU4uTLuxWY5F0SsY1w6i
	BlHP5dGsm+82mFLS9T1D2NiKW7xaY/s=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HmIVQkd6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wcD7uLYf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761634168; a=rsa-sha256;
	cv=pass;
	b=UDLgk348AR6WkNC2qgzKz4dLBXoJ39iUW0g5+jXhX072mvXutcsRKRVbVhbuzrdvU4ytCv
	iygBkZ7nTFDMBIeS4BjwhDI6DAszbHvj82us98NC29POTGnOOvfhGfH7Z+sMcztkBo3yRr
	xKc7KNEynwFTFm3VvKyBnZ1Kjgq0+Bw=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5NFkU031227;
	Tue, 28 Oct 2025 06:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1UMxuFIIDXgtlZtk+K
	SD8E1KBqM1w3deXZv0I6TY+e8=; b=HmIVQkd6e7viPnWAWNFaYMq1wrr+R3chyN
	42XNF9EPaRbK5n3pgth+580584NK3roOFg+1cJCCZ8sRJmxnzlzMWi4FrT1VeAVU
	5wSDoVbyYbcbLQEvwangdo1EVqdImuKu6FvWGTScac9jdHX0birQsl24WQrLw/1D
	La1m4I5nmmKY8NqujRehafNlT1RG1KwDZ/7eS/5lhufinII323RLq4TD7wCKQ4W3
	B3SOHgs5O+N4F+wouflX5w3Mn6ONToBtm/G9WF7kYrpyu+T4IqS4bg/XtzzDQOTK
	mvN8niDIkFXRlte4PpRp8C62EF+wfMKo+Y4n7HXhZ8i7JONo7XFw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a2357jraa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:49:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59S5txNs037482;
	Tue, 28 Oct 2025 06:49:22 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012017.outbound.protection.outlook.com [52.101.43.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n07snyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 06:49:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NI2zip7YycjWZLaNUVgnk0UHJ2LmMXzlB7W/vBcnSosr1QTtI/yjZHksPY16H5Qi/9WJ3gF5PM7pdETDBIySUSw/m7ud7tKtNGvu09gNtXE+6Nx6pFZuIEWVFS9Acu8iRiM0bv/VoVJ/iZywpfg56yr9K0/EEfqWCiV8+ZinjQ4eSX0JD1MCRwEYEQ/F0pjTfoOLZzZckjGeten1qkE0rWwhQ4mkd03MQw5G0Xn2zM68eZfsdd74ymeO0fdXbHjMcJIx8xCXRM+KbSuR2EKA/nT3RgScMD+b1CPgkVSDw1gwJM8q2uN029XjuGzxqxRRbdItoP1KQz8xKpFU9AALYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UMxuFIIDXgtlZtk+KSD8E1KBqM1w3deXZv0I6TY+e8=;
 b=fmERbiuF4Tu9F3plP3uHKhJKKCogqtPj6YtYcS25dwbnW9BBtWy6LOTnpkqHvI9g8HNA+hES9hER/hHzm2pqJe7mt//8Hg3CsSNW830AAQpFBKtfVBtdsktN4rL6Y5882Y1Nsk6SiG27BUldHxY5SxkHK01LpSYJQUvNGTK+lRC5Q00g16/EdfSxYQ1pv5gDaNJphioalntMrT1Qa6q5q2d26ssfuRCkwjmJqLWVaio7cGcqI4kquDz/Gtt75aiKqEhIOpZM67+rKP0myyO0jJtYY2so/eHPatPtlsZOhkrzXZq1TsVGJULpIlx+z3IJBgWLy7rr1NjNfTxKK1vsuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UMxuFIIDXgtlZtk+KSD8E1KBqM1w3deXZv0I6TY+e8=;
 b=wcD7uLYfPr8VSVDnk5Kl49mharvgIhr7kfbjySngO8n5PpGnJw7hjp1GhLWumjWNe6wuS4fug/P5lems8nWBpGIW+HGwWleFMK5NIvJynZCtEtzidwzAt0QUIrrXmwHLDqKEn9cyy6KrBYtSnaMARyhwHDk/8OVCBSZzBRFZbKw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6199.namprd10.prod.outlook.com (2603:10b6:8:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 06:49:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Tue, 28 Oct 2025
 06:49:19 +0000
Date: Tue, 28 Oct 2025 15:49:13 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v3 06/17] slab: Remove folio references from
 free_large_kmalloc()
Message-ID: <aQBnaSYFJ3xNzYGV@hyeyoo>
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-7-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024204434.2461319-7-willy@infradead.org>
X-ClientProxiedBy: SL2PR03CA0001.apcprd03.prod.outlook.com
 (2603:1096:100:55::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6199:EE_
X-MS-Office365-Filtering-Correlation-Id: 36d0f537-aa83-46da-c7a4-08de15ee1e9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hX0jA/SK0XPLUkzSrRriiSi+vIMA+liqea35uMSSKBttKa+CTJ1PYVO7qzgx?=
 =?us-ascii?Q?L8uJ7rtk9Ea9xqsbF5JP6u1aMIW9/yKMPRWnlsqRqcICOWXbRbzMQKzEYmHI?=
 =?us-ascii?Q?1ELU4GTpM+x1jj4WdyTrQsQdm5Ul7qoCoWnMZddtYZzRE3KMEtk8eaV78Ojf?=
 =?us-ascii?Q?WG8aHlua4sztzhWz922qwr2Z+C0YhHeITR4i1F87L/5Th0NWQ1Nr1fOtyhyQ?=
 =?us-ascii?Q?CvAr9OaSHwAX/6+qFDO0qIIZmnk5o6HuBu0/xtPk4XvvUBLsvUfU2GQaz2fS?=
 =?us-ascii?Q?tph7T8F2pb4DXbbPX3zuD7tHkIKJb/RMp9Uj06nFSeMC6/gjvn3WAswcySFB?=
 =?us-ascii?Q?4Og5+VYXaupNwVZdljoMI3tYprbTHtZkyEErMElSuYcC2RAhpbkgqJISUr76?=
 =?us-ascii?Q?VVR/exwCWvo8miUfsy7NvMAv9wuhqbKzsNsCEgkzqqs0/96hRgqP4qpJ/ciI?=
 =?us-ascii?Q?k7y5fSExPUtTdKM5mw9dwcsw2cfNizxI66PEWrkxm/hOCqmABWuUijHGZRv8?=
 =?us-ascii?Q?qpFkRr+BCHMS+BqZ54BQ8Vlcw9cFTxGHlOpUmbu32nXEn0DmgljyHoK2apOz?=
 =?us-ascii?Q?KkKue87bkasHtC70ofES6Fd/AOPdUN+Ug0MSZQtQWUL9TwgqBnjMcb1meVqd?=
 =?us-ascii?Q?aCPyyaxk2/LdojxD1HxflkVISCweNPKH2oJXzP6nNJKgif3hBTv6JzJFqdKr?=
 =?us-ascii?Q?W6twM5bZCY5PvDClIYHTwNf44gytsxGHjYU3r3PsKHv8aPDgasLyztIqRjMZ?=
 =?us-ascii?Q?JN7vXvTlg7SrqFm9V995EhC4o8GMA9SnMawLE9zOURppOHbCJ8Hw3lp4Ufqa?=
 =?us-ascii?Q?a3G6w822tkwWB9SqzD4Bo725QiqRiugfAuJbvVt16VUuycWkYpz9pEo7LtSs?=
 =?us-ascii?Q?ZJA4bHybFAuUiTntllrVeH9ive6NQOo8ZHE8d4iSPMdyXQes9WsxHItDTdDv?=
 =?us-ascii?Q?2mD89ClVKsQvz2yF0X0jtBGSUedQxlCEu9ZyV56uaeIq8DELedFytqQLbvlo?=
 =?us-ascii?Q?zGpPEFLsaUpN3NaDPX8bQcAtyJQbqpva4nnJJipy/095dqnPrLW2qL1+co9A?=
 =?us-ascii?Q?Y2Onr7g2vFAR0Rv1ciW2eISUePf/NuLuug5qoHaKKmiS+lv6idY3nc6pet/p?=
 =?us-ascii?Q?0B4FRFjaQlQhFHgSjHuOiFreoO9LzcDaG260Smx7izvbdYv1wZBtsJFQjEEP?=
 =?us-ascii?Q?VaSgJn4zejStA5eSly4HgOBnuv6E9i4IL4SWS/AWP2xEEq/ie0/2IM4jFb+V?=
 =?us-ascii?Q?C5nX0RktTnpskzQoKK8HbSShnx92GuFuU3bUDDZn5Noq/esTkgaf0a1nEixB?=
 =?us-ascii?Q?4cGes/X1xAu6rl9KR+sDbbB/QN4AgWBCuiyU0JaMtKf/928OE8GVAgvgSmOC?=
 =?us-ascii?Q?xR40KmBkRWoL2XhYYIEQyD7//F30t7xp3oiRo4+nGMQhR3pW0G0TrjQUeVx2?=
 =?us-ascii?Q?DnDAgnOkWeUAW4/wfQE93YuAOkcJerSv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/wcxozOWK+XinqC2k998oZD/D8loQ3OPbcGtSRT+y+xUMCUgEZoSrs8tw8vi?=
 =?us-ascii?Q?YHHAlBf//leXerdRDuvuJifCfDkxBg0jatF/tlMnoq7f5kud5ifvfyPv+ry3?=
 =?us-ascii?Q?Nak2FFK3mejm7IadJgAupsOlIJ6UeOvEZF9uds9lq+Q7oC+LbUx790wAfuJV?=
 =?us-ascii?Q?9q6zDB7bRoAsYKIdTJouGdGVHyzleEfX6VPWJiaBcB/BT5nae8mXoYRZgtBk?=
 =?us-ascii?Q?2gCaUPcXWJqtA5ZRsnQEu4ClpPtrLR7ea8Ruu9fN5MvAlIKBKF0wvbfalhoY?=
 =?us-ascii?Q?EvABUbhE9wv28HzfVUIYJTMBkxe3N6NX8RT0OKhQ7H/3WhmlyD3vx8glEzPY?=
 =?us-ascii?Q?gWa21fCWbKmk6IoAL6TeHByqfb/eb9WfIWXVdCTeiIT4//Q0X3CVyFoNjrE8?=
 =?us-ascii?Q?lc4Sm5HzMWl3VMOMMLV32c75vLvn4x68cuzb1AFynE43rKNsRUCBUuOwIirY?=
 =?us-ascii?Q?vy/Knk20tWzbmEZguyhHs8S3SMhLCOVhS8nW7PUiCvQd4kHTGjDwD4lDPmwF?=
 =?us-ascii?Q?lbvkrQ9KY0hgk6svZfHNDNu+2zgSs5eceDB0ZCSw6Vf9oPQ0Ul/gz3WWzLSs?=
 =?us-ascii?Q?orw1RvdmPqNeFvWr/KjGeoWGuaqe4MYz7DHsMGt4jcTJRV0gtNSbihe4gOzo?=
 =?us-ascii?Q?y4NkKDZJ8qh00JKB4iCxJGb9CclH8Bsj4QxCCueF6MIjRbur9W23RwrvAnFC?=
 =?us-ascii?Q?SlGL61NFdMA/ojz8BY4cbtzVkCh82HRvdQ5RonCyJ3qbH5O9ep9nFZGfZJEb?=
 =?us-ascii?Q?POo3Z63jHsyRV4uE6SuodgCJeP+XA0R4Q6siB2uFsEu7n3VlqOF2oZRRBJ9b?=
 =?us-ascii?Q?HE/a79p+REgE4MlSy0EfxheKckNBesyaYblpyWe2T9YXCy/0KGBtNQCjm/Na?=
 =?us-ascii?Q?J5Yhjz65PUkqIPFfSEboKfw3x77urI9MSSQv0PJJYmSeZ+CamBXX/QHaUu4G?=
 =?us-ascii?Q?bxy2tTGkpfrt15qNZo/U9wR4eNGsAS4Q995p6P2Z5gp4yIf8ETw1S4ozRG8d?=
 =?us-ascii?Q?7oZrfXbTVTY90bnXRqrUIedtiysapxPuLeAo2ppUXXQT2grQ3zjLIXzaVx+k?=
 =?us-ascii?Q?fQiA92VldkvUyt/N8aRtfLe+OdSbaarvNAQVR/BMEHkXe2jKdwTGbqsf1xu7?=
 =?us-ascii?Q?NlFs9jVl7r4l0uiLl7RPKHlZxudoTYzIcSEV9BSH2ISsfme1Jw9k0Ou79Oc8?=
 =?us-ascii?Q?Csa0/5NqWfmqr/NskquDijxNQi/SssxZ+30a/Iic/BCskEWiG6ka6TmI/kXC?=
 =?us-ascii?Q?phOP6jErpPDuRDb0V5EtZOeZdwq8/1W2pE5JQwCF9lg50L0tziU4npXHixzu?=
 =?us-ascii?Q?oBj9OKoEwd1CJr3BApXtqq/lOY73sGQczHES5lrPmioZKg39Ib2IHffGkECs?=
 =?us-ascii?Q?fp5UHZzao0uLs3crCJMsdSbgWWpKBLq3de/SkaLzGKi2T/opaLVn3BG1tLUW?=
 =?us-ascii?Q?Ll1kB16a6kKn9VLfvp3Yv9J7ZlOXEsuCn9EQceUtifFLfjFEoiCrTqk8cH7h?=
 =?us-ascii?Q?pzjViFj+gLYWxka/w6Wh62nINhFqQCqTRSj7bOayca5D36SHCG4EhV2104HT?=
 =?us-ascii?Q?iYFRZF9liFy38B/UG3IIpCuVL8r/UyJ998jXmqSN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1PpdKSO33TZTo3t0iwMw2k8Z7OwPn9Xvi+1GeciZ0SsR3pOsWRQyaI+Gp3Mw1zap7Vh2bD0qDxLZlSw6vO5DLYzLkbrnW2Uhwj8boHVba78SpAOrnWi8EePRDapn6ylkKUIKbdRPxEosODFI0EWT/ry1BboJrUeY/bgZ34Vxiw3ZL27NIhDh2U0U/wrpwU3pPPWKB9dLsMoQ0FI9/fZ7RC+zkhcT+5FPf5DmNsfXcgxQMIj8dL7F87wZuDZErZ4bzAyMP53jPjldLFI4hy3eNNYzqCdjtjD3FCM/nyZm8ivXvPBsUunlz8QcjEyC5NiMEEh0/wGOkh0I9zD9/jLaNQrtEmMortwArwMuYitg77y0ANFeists/x4Vts9dVcxDMpwkB5f+jItkrdjXI536/MUi/cCzP/HibMcydmOeLXENnb0oR13fw0nM3EwmO8Z9G6VLAUgO2O38iKcBx0qitcAD0Gq72Eyi7Fo0ytcrE3/9bxSwHRmb+ss9rFxX5OqaC2GdfpKchuhrnkWIwKgzL78WyC/bURfsgzqYhyk6CoL3FGgbw7BT/DuHJnYIZ+e9Zr8yAprwMfntU0yM3MZbwBBoZQLS73s/rmP+yICjdHI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d0f537-aa83-46da-c7a4-08de15ee1e9c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 06:49:19.5604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcNDIdtvbVzPUdGTNCBJk/2EfI1Z9PkS1pvT0R+owBMMRk+zuwkiqAgIPyHZuVUH8LW5ln20hE653+HjlBSkaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280057
X-Authority-Analysis: v=2.4 cv=Bt2QAIX5 c=1 sm=1 tr=0 ts=69006773 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=lnYYQb19Fs_rjGwmAtYA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: SSt7PFm8X9AlIHJTO8AVs258kuZdBQ1s
X-Proofpoint-ORIG-GUID: SSt7PFm8X9AlIHJTO8AVs258kuZdBQ1s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1NCBTYWx0ZWRfX3EVuuNa5qie2
 n9JcRviXgaVvApPPvCOa9f3OJ+UHszhDEFq2EoFrumVeb8X7ZBBRR5COmKal8zUPIscWJWJjMj2
 /jLiaMWjU9YDc1si/FGSvg1ZDBjXtW/qYUN12kQVcg2+QKmVMSZoFhoUPSDQlls0gxW3sM5m02a
 KtwX45uUBtBULN7pYDFVBBmcyLPMCLK2koZBIiHfgXK/ODSzFVhTe8XJkgCfkOYF9wGxWLNMV63
 3q50AmHG/6rW9tkGWjVlnGodjb4M5+NedZRFHxhHHegsPlHZNDrKD92xZ/T3FWEW+54lBAqJTJS
 ha8t58PGUnQo9wOUNLuwO73FPhXcyz5+ebwK6WsAubGofvkIwQjPFd62OlvxzddlnVBzgZhSuKr
 YFWSyZddWgbLw/aX1jGVfL2BC0/0Ig==
X-Rspam-User: 
X-Rspamd-Queue-Id: E14CD160002
X-Rspamd-Server: rspam03
X-Stat-Signature: ekipg3z99xesz8ei6x3eftfifpz9di5h
X-HE-Tag: 1761634167-553990
X-HE-Meta: U2FsdGVkX1/gQgViXpvWrye/WdCOaCS25wxd93lj+eSA59V8f+2EtkfcyMIq2BspRDiVfzq0Tpg5vfDW5BsCOEMOrVcZKuIaSm+FIxprxSI4y6VxjuuvPB4JG3lQ7DuqGusAukb+ChcQxZcDPSz3BpZujYDXZWVl04NAca0eFSZuTvH2YPYV6XYscMTdNxTI40ojk48Ds7MFDv4JKnKh34NrAEcymlon+kaqfG5rZuL7cReTVisbS53j9oz1ools7AOHLhAfF4NjcUYXe9do2fZ2uGhSgg2os0JDzvIa94Qn2uv8Ba5toJyrUUVk+e1GY17Fa/0KglnIJt2Ei8Mzz6OGA/czZfgieD2FoyiJtvhGw/2WHYJIOGILEO/wMPk3bD51+dtytR+5VLnfoxKTZJX+koFyUlTrlESl4zKS9QMhPTVd9JFA75iHcMRyDzoF0tcNgmGMB7EVqwPoysN8jug7OwGU2Oq3JhMLBMy6q7gjnEKvMrEULcOXRdPs5iKa4p9LjLs47Yzxd/3rnTfSl1W3D098XyGeGMaZ4OGHasiA8DGkpQoaVIM2b/tTU41kr+nWzaury9cq00T77j4N7yGNH6s9zRgpdB24XkFqmhIIijPZ7toXVrC+G/6BCTMRB/jW9ISuzy14y1jGxBmyzsPS/yjD4mUEtT1TnyEj350gUvHPegAbkKD+gFnZOb8R2wkHi1n3LRsWwM1zBQ2N3JmL3KF+yr8+BBIxH9D7OW45aqmxB9EUXOWsizyrTARh/jyeIgj8nUZ9BxToYxp5XqIZ0GnyK/SRwqMbZSPVjuexEkeN0c0Qiehi7C05MlhKdf+d+9hLd9XZEvlKHe5J3Z2gigFfxvvld0uKolTdUq/rcFomsj00pAXsCCp5V8Emj2qAL1InomDIvQXZI05MI9CshxyXhrec4mTIljPFWw72RsVzme2g8AgKf4hMdwVwrPREWz4hhGu/8ovNjmb
 fXFYaAyi
 clnQqwWHKKk8Ybc40htfNNLJOEGqOqg5rO9zdbMZsVX8RZwnwUQOjVQxrrLt/p0dgoeMujaCdBBYOAN/4C0snxWNSaV79gPOOp6T3B3FsXW9CiuXAtA8+u7Y6dORHmLARckKC5mENOeAbFx3x8vNj4WXadpSpP+9LTUzdsfZiMM+HtqM4+fx+swQtS/u3WvrzXCIE1Ud1rG47rey6Qt+2DX4iat85P2lyabk07lz1V4S8XI4B9thqZJPg6TwSkjw7WNTRmf0LrWYB+lTFdyn3H/MWdKrxa6XUsoygZQwqfRHNDnhprpKsABSrc7pl5KYerKfdyhwxRJrvRN/CFvWnkeut3jGrgAjJQH3KRT0NA+Gun07slnYovxJJdmwshXBj/nT4SpwZhKkKv4gWeNMZQdENm/jOqT63QQ+lW1taLNdi1LfcMMVtSIFdhh/M1vJvNEHAgxbUaiS1DGMsd6iU64aNfnt5KYb3ixN+W33Ig9hLKSrg/mh9dzQtN1n4xvVqXj2Bp6DJCgiDt8Ns5tdDFwEpszE9iv6FpaXQbBpEH3ZgixlHXIaotqA1GXDZANNFm19Gwpq178yqrwYRrlytLfNh3lzssJEBDlfq02Y0oSTbz9D4CuhI4TsLwHzxI1BcUVRzoTN6uccmzKrgxO09t904E1y5sSl7Fl43ZIkCNcbVEeiM7zfe72yoMTXoAzEzsxI5vGKf0mq+fSUod8bGa5OzN8kvePDBBC27ndZPuFS5GPHcnecz4nOlKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:44:21PM +0100, Matthew Wilcox (Oracle) wrote:
> There's no need to use folio APIs here; just use a page directly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

