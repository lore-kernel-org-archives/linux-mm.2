Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 761D8606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 00:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=pps1 header.b=KBssQFab;
	dkim=pass (2048-bit key, unprotected) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=selector1 header.b=PjwEsRKg
Received: by kanga.kvack.org (Postfix)
	id 83A466B00EF; Mon,  9 Nov 2026 19:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811F96B05B0; Mon,  9 Nov 2026 19:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA536B05B1; Mon,  9 Nov 2026 19:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2D56B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:00:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A076014085E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:00:46 +0000 (UTC)
X-FDA: 85417253292.26.256E346
Received: from mx0a-007b0c01.pphosted.com (mx0a-007b0c01.pphosted.com [205.220.165.71])
	by imf15.hostedemail.com (Postfix) with ESMTP id 24402A001A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:00:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=KBssQFab;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b=PjwEsRKg;
	spf=pass (imf15.hostedemail.com: domain of san55@wisc.edu designates 205.220.165.71 as permitted sender) smtp.mailfrom=san55@wisc.edu;
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794268843;
	b=VP5mFAYkVzVG5O7voYhTsUhfGfudvpIT/e9o6tNd4ZnGCOpii6d2xGZAUTuAZTfUJCuwnY
	ze6aXvuIT7G7XWDcMULN+0mvq1Pl2NDz7yZICnOhxRhJsQAeHKyIzS8/iqlxBAK1cgvlrj
	bZXyx9J5Yqt8hDWy8S4PaJz7rnA7qU0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=KBssQFab;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b=PjwEsRKg;
	spf=pass (imf15.hostedemail.com: domain of san55@wisc.edu designates 205.220.165.71 as permitted sender) smtp.mailfrom=san55@wisc.edu;
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794268843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRCuT5yuMVKSV9RM+g34QisLSWCR1AoigQtkhE+Eln8=;
	b=aZoeLNmMHTn6jiEqQWD51fuBXak3r/CAxklx4vbNvtFjatgFOqYJvGrqRyVZEq6UJJDePv
	n5bFdbHowZ6aZpN0c/cmblV2R2W2iW1OaXqj0pEJuCJfBilYhoFGjaBLPuewCiRJN82okx
	XUqaplmg7p2LnIAJMmglUjOnuZWbWsQ=
Received: from pps.filterd (m0316040.ppops.net [127.0.0.1])
	by mx0a-007b0c01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9L7LHp3196546;
	Mon, 9 Nov 2026 18:00:13 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps1; bh=WRCuT
	5yuMVKSV9RM+g34QisLSWCR1AoigQtkhE+Eln8=; b=KBssQFab6ujrXA83ajeqA
	OC08G0HmA0OFjORD8rnwDX68A+SzpuNeMh6kZBuQ4agcRXbtkCWfjXeaTxiyOU5n
	1W9E5uAS/n50hP3QVTM03L1K33CeQXhP3qkJ0Xs6asOQKtdU0p1TFCdELlH1/Cl+
	HnHD4Etf2kJmVecyKo+uwxPdo587VvVdloBQ8PshGdvOc+MgLQBEnhBNlvFfGqaa
	KchbJflukiu098Qr4CTZetOB9BAlY0dmyY6GT7x+Ds5r8l+w4lQq4+oxpsz3fnTB
	XNwWFojPLJvckYH9dJoVSCwcDQmLahAuDI91r+YoUZQRVmHA3CwCcn0JtLtvm15N
	g==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	by mx0a-007b0c01.pphosted.com (PPS) with ESMTPS id 4humm8hym6-3
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 09 Nov 2026 18:00:13 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iWkrj4EuiB1+WLHdLissQESmRxG0diT7sCRuAIDj7cEC9gzFhu6iJ1OqAn3YU6cv29k7IFibLHEVOrd7JM4uOBJS1TCYaBW4CihB5/4ZkLkdYY0laBTVMu0Tdg1HUOizniHSGcf7plSJH/a8xwuH3iqZJcr1lXja1cSfvtD9rBaxIog2keKMLfi/D3SzQLohVcXEO7QSXQLb0xrTGdtcU/dUwBXHw35PKrXee/0jQ4xUNJo46uOHVYwPIjgHNLdBw5dXyupL3plhtOwahdgSREa2TNAJbCxZ0AfmfqB9ZwycqxerI4nOJIU+/6LsFmH5eAn4c03SCaHYYsr1fZZ0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRCuT5yuMVKSV9RM+g34QisLSWCR1AoigQtkhE+Eln8=;
 b=HiWdMaTiWsiylMmhIDxXG13Ry7psjx2YNrKAVVCbISD3Wf98DNg/Pngz4aDAMUNxRXTHNqa+PPfR4SWk5jFSXLU5dqC+Y5rENNWyqjXBriyoO0YLM48bEWTtAKUpu5DIX76gBkEQjurCJJ9Sj8NlYDPlppIAoMOCzvfPGs7B2gJjkRc1nmRGvNNnIvEGW+D+0bmC+iWuQZs8I+cq338+zHwR8m3yLumfKDqOxrTBoHvXwgSE/iA2/mEv30aldx01385HvV6gQ/YSZRdDigXYEpm5mTyqEtxdSUQfHBMpvZjHhg/UTKyRU9P4VqDzQxOA+Gtasy+KXlQZh5B99Wzdvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wisc.edu; dmarc=pass action=none header.from=wisc.edu;
 dkim=pass header.d=wisc.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRCuT5yuMVKSV9RM+g34QisLSWCR1AoigQtkhE+Eln8=;
 b=PjwEsRKgFc59l+R9GIP9A1KYK/RHmVDumY2XQ/SnHscuuq+0qdo4ldi9Q0HfdxqgNHq0G1uWAGHUVDX6/dmTYtzKppT9h/S962DbM/QMraMrUFv0Xt5pW47dqbsfGz9jDZ0orTPpP7KMBEELAXNnyoXLh/JQjZtWjpTP47Rdq9zrMjyQJiVLVIPWNfTz7phMlO/uTKfOWBp5q+d/OHxrQjhxh9ST7dwf1i+sMsHA5DWSz3tEc3A8HVesofYgMfl5PcAyrdWXig0nonHg4DvB+SaKnXs3v+JgEMgGFioSJUud7kUvn075fz3GduyRxm11KmsqdZjA2zEqTtmrmdk0tQ==
Received: from MN2PR06MB6639.namprd06.prod.outlook.com (2603:10b6:208:20a::22)
 by DS8PR06MB656475.namprd06.prod.outlook.com (2603:10b6:8:446::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 00:00:11 +0000
Received: from MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245]) by MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245%4]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 00:00:11 +0000
From: Seunghyun An <san55@wisc.edu>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        "Liam R . Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] mm/vma: only assert VMA stability in vma_has_anon_rmap() with CONFIG_DEBUG_VM
Date: Mon,  9 Nov 2026 18:00:02 -0600
Message-ID: <20261110000002.1834454-3-san55@wisc.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110000002.1834454-1-san55@wisc.edu>
References: <20261110000002.1834454-1-san55@wisc.edu>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::11) To MN2PR06MB6639.namprd06.prod.outlook.com
 (2603:10b6:208:20a::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR06MB6639:EE_|DS8PR06MB656475:EE_
X-MS-Office365-Filtering-Correlation-Id: b1d1f706-6aec-4324-61e2-08df3ebd96e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|786006|56012099006|11063799006|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261026121527099003|261026140227099003|261102123227099003|261028144727099003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	6yoySY8aNlIUUllWQ4YuAcPD5bIYP/is9PP6qtAbRrhRMvN8DKK/5cfci0DLcRFTmNGeNllkgNNLIykLguhCTWZj6A7dFf1gkZ5Qh8Eft1N/T9YD9wBbcFOzavLzd7LcrFUQ1K3rkCf4iUNtMusPz2dNyMFc5EiGjp0R1gr3v91uVeCwvYjraxLGxvcGT3n0s66HkcLFlvstAAv42vxgBKL7TdZkSqf4Jrrjr5evsvczIIYyOEpR16y7NARZKvKyeEp5SlJv6iYeGbQS0/n0q8OMgezYUdoPwUBsSaxZ2JEgk/RHsMOr31h7czq8Y6qLT0K1pfYmDnCwMJdFJ0oAasAcc7UZI8Bhy1Hh3fbmvbtFL8exnYDLxHU2ZU/HXEaaLdrr9wzJ8xtYQJ1f78eB9zcNSTuBPkJCJVQXbVh2nxrX2e+mfenhgpx8PQQoWBzG8HZlYFRxFRNbk0Ld4mQUa5LPxkU9F/Nz//ubWLF6q8T/TZtkk9M2Qa81dW/wJYndiw/TNUBInmlsW2wcs9bkwxXd89ywrP9MASo1N+MDRkgmqtYacEEBZMfTKKsBJc1gCnH55EKpjABDda98naLOnkV3Dq7x3sq/5n1RYHRTx2E3QpuRH3IudMqsJ/X/3yo6NekNoU6LtgFNsNyBW5i8dqr2sc+g4QJ27TqEUbSN7OE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR06MB6639.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(786006)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261102123227099003)(261028144727099003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r9B3q529pVgiVLNVjEYe27PIjvL/w7fq4TEQ1aCb+agpe631LBNHOJITZx06?=
 =?us-ascii?Q?z5uNnh2FwxamsUNG8dhzoJp760encpauWY41IzWKG8/eDZ6tKfQZZAQj7bGS?=
 =?us-ascii?Q?LnZA3cQ7BqPid8wLOE4GN/NPw9ouf6B5oHgPSyVbp7kM3jP1aWijf7Z1NYtt?=
 =?us-ascii?Q?mbrFNodo4iexmCWyplK4GW/6VGDoFOQJyX9ScRAw2rp2m+qKGbtlwso+vtup?=
 =?us-ascii?Q?MhTKMni03F1q3NKwoeqx8kb+AEqGlaJkc1fSgnDnXxYO87I+rIrbF3mPVesJ?=
 =?us-ascii?Q?0KNfn3y812Tn57dZY5y6yPp9N7GEyY7Ygh6ijH50hsJ2GCdGpIGLslOc3lhv?=
 =?us-ascii?Q?rlI4zSCfRklNGLYW7HPjdUJnuEzgcPVcJG/pyWdkvWKoMhDitcGs4u6apiLw?=
 =?us-ascii?Q?OqqaCTWo0+DJsFLA3wYCUddJAqU1nfEW72UOd39wfxI0tm8KkaZOHX87gyOH?=
 =?us-ascii?Q?gFigksfFnAVtWw3Qa0y/fjuT93ONZXlLLlwpO2xFRlcmT40mZTeuYvNhUFCE?=
 =?us-ascii?Q?TTENltdrcEpOQ/3EJYff9HOJNELJQ8H6pSFFX+nUpu2R6xmB/EWooLDLxsXn?=
 =?us-ascii?Q?Oyz42rNPvZ9PXcNXPLQUQmrN7Dl3sCkHDOPUMjV6BG+uXQ5R23fIN6W1EY5U?=
 =?us-ascii?Q?aoxuZ3iqdyo2sZu0OFNzRPRDBY7o6jvZ4ZdbVD7VLYDuf42lNg+MDeyq35mh?=
 =?us-ascii?Q?52t4Hatp8FNtPq8DdFRPczk2tU2E045y5W1J/HmVzdimz/ntJQa83kUzKHZC?=
 =?us-ascii?Q?zHKiND3IJsViDW6fB8DMtGb8g144n08tkF9xQD5HHi9zYB1FBGuaxsxIUClf?=
 =?us-ascii?Q?m1QWhy4me9Rv5rzEmXpmm/9WvL0bq3dMX92RQEUrmZQ0iApYLmRlADyxWab/?=
 =?us-ascii?Q?Q6eEm8Qg4zyFLSVJDO6ojDRW4HUb5yL1oQPF/TC6o9hRcBO9zwUVxZgblDMC?=
 =?us-ascii?Q?cNpZnlnYNcmjKKCo/6myGKpwujOmC6pRJ+FWKtxQDKF36j7lxBvpj33tkHnY?=
 =?us-ascii?Q?E2xdBWNBymYkZWlH+pTF6f9YcdYzAvirbAHqDx7+wUgtfDX35HdLYG7MjRNR?=
 =?us-ascii?Q?sMe3h0ElorIkwee96k9NNh/E0mE3X79P1q6Y2MBPuxNYTfj1o296AQUGdkYo?=
 =?us-ascii?Q?s03G9boCpoJCTyitINjyxhM9c66IaSBPA5PRm3eV0NXDzNQmxpRBul4Oozzq?=
 =?us-ascii?Q?PwuNZIPb2zxGXxCK18TVLLk8mCiF65wy+KjPYJ1f9GMXx5h4veESpFoJGvp3?=
 =?us-ascii?Q?S/DbHbSYj3e1g/AgJ7sWNn0CIRZiFuXadGjul2VnVGzOjPDgd1kMkFtkMwZk?=
 =?us-ascii?Q?hfO/N+NSgC0H07JFs5DtWfEME7hZ+jnjKyn1dxR+c3AUabTKHLbsDuOQ6+iX?=
 =?us-ascii?Q?F+ZjNAiVQS5C2oBO46/P8AOysFwKx49oedW3VehxI7KzjM/enk/I1WYxOmw6?=
 =?us-ascii?Q?pmE2hewztspJ7rIM7YyA+5cKHtvzRiQv4NaZkQ6aQyHKq7fRAQVJBOdI+AKX?=
 =?us-ascii?Q?JdGPv/FrTIBV21E9v81VtNGL5OhmkjWotCb7Btj4B10UwzwYSd0MsDHVxJoD?=
 =?us-ascii?Q?jVUiXQB4uVgxWVo/z9MyVf2CtoJ6at9iUIkuQaW0drAnPh2Eyfc7pSqbbWY2?=
 =?us-ascii?Q?gjE/CLvo8zit557fz8lSTu9bIY4UjLXt6lBZ5I09URL2181+6rOMg3Z6DMj+?=
 =?us-ascii?Q?x2g94OtKDSk8KpcWDmLTwxNr32sosVg89FrvV+IezxdTAOBT?=
X-Exchange-RoutingPolicyChecked:
	u1qx8LQDqw58yu2AzSmppHe988pPQVzkCm7jvkOn550Rv1fKz4LejUBjpGCTpmNmxuhgpcz1djqnjRVjib5bY49nEIL3thz+ZW6U+ljiAKPHI6X52nEGzaSIZQPmk7rPdXNiSBA8tSi9Z3yp36SKzSkhDkZA7p9F1mhUE1/ULgNqpsliJeCAjLhGw1jXqCbTftim8tDPuLV1OqBV2OMS2sSR+AiIEHjUDSNDN6lud4Kq0TJmWVGepmRqXbTaW2XXOttfIHc4gOO+X6d2jOORlBk4TMQp7/66TvFgHjJAdTGd3NVTWa2XWG10E+wYIkcCd5Mt9xDxlcyyNyqiU9LdpA==
X-OriginatorOrg: wisc.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d1f706-6aec-4324-61e2-08df3ebd96e3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR06MB6639.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 00:00:11.1904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2ca68321-0eda-4908-88b2-424a8cb4b0f9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rRcreRhF46m0t90xDk0wGMgWePyaWDDd3yAmxjeGt4CrRliL7et+am0+EPnHxxnI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR06MB656475
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA5NSBTYWx0ZWRfX/t0g5S0BQn+l
 ZicYTAZbo4bu7Ozw9Qt53mKQpiznFCww9CmKfNjws50oqcb/XPBSlJK8iuSRAC7d7QQVD4+Xhi5
 B8iZhM2SsbgLt1yHhhNpNHkfcx8ymeg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA5NSBTYWx0ZWRfX39GPAmfX73bJ
 /lepWbzzjRuZ2E2rtsXOwBTmYk7bUdmkUxjlLMB1jGCT0tkWAFDjdBdfP2quugnTxk/plWVe1Ei
 wZYowwWqxFc3KsNfYIxrW18Z5LGIvZLNZo/XMpIzpIiMLFFAV8Mk2KMPYwVqsOtIs2LWN0W1AEq
 0l6eQfP3ZfPdS+2PgN+/1n8rr+0RS3JZcp0Z0vLswNHAJJEBKB1uTV3lZyCY1o12FcVuw7qdVUt
 E0y5NtyOfwCt4F42ZKOyj57fdUEYsjPBh8mHpb+zuOoxu/7SL82vi0LX6cPtCE1oJUZFfOdt6mm
 wLjI8eHcl6jqyZOtog76S3grFd3uamaWpDCJ0roRfo78USATw/fyGxN46+0hOxT67El4mB+n2Wy
 DqW0FN2EO/YBad89yldoj/NStn5BM0C9kphDPqZuq9vIGyM8s0+wtlBdGpi2CxcaBoJGkSmeV75
 CZNaOyATIGMzrHrdOvQ==
X-Proofpoint-ORIG-GUID: 08yeMdxN---xN5swRpw0l4KXB09rvnxT
X-Authority-Analysis: v=2.4 cv=HtDjiETS c=1 sm=1 tr=0 ts=6af25e8d cx=c_pps
 a=LyZwXkN/zJaPlZXKe3eCLA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=U-hppK1rdbEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=ZyELlZqCvD1aXIDzc3I-:22 a=-L2uzytrI8BeDALVFixt:22
 a=zjJ8_30hHowVf6qWvpIA:9
X-Proofpoint-GUID: 08yeMdxN---xN5swRpw0l4KXB09rvnxT
X-Wisc_ValidFrom: true
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_07,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090095
X-Stat-Signature: eo4bo4fzxeuqpdzneuw18w1cgm5ox8nb
X-Rspamd-Queue-Id: 24402A001A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794268842-839731
X-HE-Meta: U2FsdGVkX1/2vsoVweP9+kAX014GpURhhVDt0jAofRYxOrGTxl9SdJ8TXmfPVmQ5xjTazoaCuwONrRF1Dq4ytuVuIGHhRCcfH6f5xkLYnI8qloyv8g4QkHUDXUCiyqmJqhxcxgXSnAgyRg2iDSRyCKCT97FctePizUl2/JGof9GGq8XMnEsrk3A58Ix6waMAKjA4BFrjYwyinEeNVppHdbBr2k6eS6x3kICCb5IPZTdp/a6tgOqUztWXiUyi3ew3rr0RDYaGn8jnUTJGJsBYkGkmlsv/ideq75OhcLCJoI991m936yA+QRJCcKarouEAExeUYooa5360sECEvKuE+//p7vCPVPC5OFkLZgAGdbOmRNw6SRKk2HFJJCeiC0hxSLr+KwxStPUNGNqeizHDZnOoQcloWecq2fKOiAHF+aBEOjPKDczvLPueB5BYGa/nMrtif0JsI1k1LI+IMOdSLVNMjJZrIlI/rGgiPT8tJzpTRnrHc0AvaWd4dCHJ/7+9RHW6O4yAQcYaiFJvtk3ExnlxTqdn2Yiandh0IuQ+wqap7oEXhn/nwRDhbYyRrK8jMKYqREQWNE0y6lZ4ciKlSqS8UGFwwpBuS48617s/i7qwfxvbSKZA/oW+rypc3dBI6TlTP2qSJjLyCQVqb5rG2u9a4XWLAhi+RJYU7s8Vag+49aFl10h2p/f0aPYLApx20drWjX4RbjHKq5k5gmT1NiYRw0zO2SWHneWzJpiqnmZASZW+eXmi1B0FnE/4wBryrhfC9jhs3KYqlr7llw8QvZOwA2gXSUzk3ZmpWTTPqi6DNYtOKE5v8CaR+IvKurDPfjChG+Bb9soVddjLBZG07keSEDet+ezS1FDaxdJPMm5yRoVnMgRf5NmjUwBK94ScIenigGzuDKGC/WRR8SI+1N1SubqAzxSGgka+/CNWIuxJSn165nZZQabH9t1z/HBl+Dh84cklmwAU0udA89U
 hps7x0wH
 3/W5w4ZxylNsO0P/Huv4I1E1qBHlkcJxl9a/7PrTcUlbz7Vy+/YtKAQFuNNwx0yrHtuCwclO8qYuWhpXUDqLylCTSxtb55x7byqKzRHECOMVCMa3gkJ1JNIG7ePlfrl4scjREgb45ho+O87boMIXFYi/SVP+2OJFtXl1y0kcxnLhE1i2vu8LmPqBhQjjYwkkuRdKZSp+73uhRarO+BUIVyCv3TS4mEQ3Tsbxmc7NRj7jQbtQVXNAYE0qeHpfE5rAYdjaHCdiVa56GM0FN02HW1AwC8GfEjhonCU8HHPjjSNDwOz6bEd9GDfxTkEDL7zkfMzB8SspP+/SkRqB5K5ThEYBRlqzrnz744W00n66I3q/8VGgifx/5kytDayqWd5UpvYsReXi4dnS48lpCV7+/EADyee+M99dxc4XQgsE4JwTX9oAU+i2eC0mOGSNC7NjIp4SLWvuftzZhRNz7D/ygjQhvT7RcNODDX+jbMTYNwERYg1SdEagr9CgscQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vma_has_anon_rmap() calls vma_is_attached() and vma_assert_stabilised()
unconditionally. Without lockdep, vma_assert_stabilised() reads
mm->mmap_lock and then vma_assert_locked() reads vm_refcnt. These reads
stay in CONFIG_DEBUG_VM=n builds: refcount_read() and rwsem_is_locked()
are atomic reads (READ_ONCE()), which the compiler has to keep even
though the VM_WARN_ON_ONCE_VMA() checks consuming them compile away.

__vmf_anon_prepare() calls this on every anonymous fault that allocates
a new page or breaks CoW, so every such fault handled under the per-VMA
lock now loads vm_refcnt twice more, plus the mmap_lock count. When
threads fault on the same VMA,
other CPUs keep writing vm_refcnt in vma_start_read() and vma_end_read(),
so these loads can miss.

The assertion has no effect outside debug builds, so only do it with
CONFIG_DEBUG_VM. The fast path is then a plain vma->anon_vma test again.

On top of the previous patch, same setup as there (AMD EPYC 9634, threads
faulting on one shared anonymous VMA, faults/s, median of 3):

  CPUs                      before    after
  1 CCD,   7 threads        2.369M    2.425M   +2.4%
  7 CCDs,  1 thread each    1.982M    2.215M  +11.7%
  12 CCDs, 1 thread each    2.548M    2.949M  +15.7%

With one VMA per thread, or with processes, the change is +0.3% to
+1.9% (the loads are gone from the local path as well). perf c2c no
longer shows __vmf_anon_prepare() on the vm_refcnt line.

Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
Signed-off-by: Seunghyun An <san55@wisc.edu>
---
 mm/vma.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vma.h b/mm/vma.h
index 3fc3b47a95..4562bd4881 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -278,7 +278,13 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
  */
 static inline bool vma_has_anon_rmap(const struct vm_area_struct *vma)
 {
-	if (vma_is_attached(vma))
+	/*
+	 * Only check the locking under CONFIG_DEBUG_VM. vma_is_attached() and
+	 * vma_assert_locked() read vm_refcnt, which concurrent faults on the
+	 * same VMA keep writing, and __vmf_anon_prepare() calls this on the
+	 * anonymous page allocation and CoW fault paths.
+	 */
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && vma_is_attached(vma))
 		vma_assert_stabilised(vma);
 	/* KCSAN gets confused about the optimistic check. Silence it. */
 	return data_race(vma->anon_vma);
-- 
2.53.0


