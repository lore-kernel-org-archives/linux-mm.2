Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6F0606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 00:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=pps1 header.b=Y5i1QXCA;
	dkim=pass (2048-bit key, unprotected) header.d=wisc.edu header.i=@wisc.edu header.a=rsa-sha256 header.s=selector1 header.b=sewpQ7Zz
Received: by kanga.kvack.org (Postfix)
	id C31E76B05B0; Mon,  9 Nov 2026 19:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09486B05B1; Mon,  9 Nov 2026 19:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA086B05B2; Mon,  9 Nov 2026 19:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 785126B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:00:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11A4412067B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:00:47 +0000 (UTC)
X-FDA: 85417253334.05.DC89979
Received: from mx0a-007b0c01.pphosted.com (mx0a-007b0c01.pphosted.com [205.220.165.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF7F420002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:00:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=Y5i1QXCA;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b=sewpQ7Zz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	spf=pass (imf31.hostedemail.com: domain of san55@wisc.edu designates 205.220.165.71 as permitted sender) smtp.mailfrom=san55@wisc.edu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794268843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZH9bbD9GUjDERPZclHvZ0zM1gWko4W23XI1Szikzv14=;
	b=EGQj/s8dTQkzRVzP8COqZ+nUy0d04jBWxHB6vEO3HlHFX6IjaKxt/Mkq0OXFdkOCYxLrB+
	vswrh6I+QgeibsxHRFD0cJgQWYrl7PPBr5WJVV+NQJB68Ii16+AG+jz55TcV930BUs6/1d
	ay/iqfVN4qvfn+v4E3IMJUzhyVNvTGA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794268843;
	b=eTMuOvdMzm7I1m34NX6L+CHDRvg7/g+I+Y7bYLcLW3TU0dyqNyZPUAEwGjs8xD+Q5HtK5k
	5+5ftGWgKIT99DmdqsWpJ2nCbw+MIgNvukiCetuoJ6RqROA6I6nWxFvYr6DwfLXWpG8RzC
	Bq0mr5j8a7U23GZUwzCIMzef7RFejpo=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=wisc.edu header.s=pps1 header.b=Y5i1QXCA;
	dkim=pass header.d=wisc.edu header.s=selector1 header.b=sewpQ7Zz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=wisc.edu;
	spf=pass (imf31.hostedemail.com: domain of san55@wisc.edu designates 205.220.165.71 as permitted sender) smtp.mailfrom=san55@wisc.edu
Received: from pps.filterd (m0316040.ppops.net [127.0.0.1])
	by mx0a-007b0c01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9L7LHn3196546;
	Mon, 9 Nov 2026 18:00:12 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps1; bh=ZH9bbD9GUjDERPZclHvZ0zM1gWk
	o4W23XI1Szikzv14=; b=Y5i1QXCAvbB42FzDDXs6WUK2wfh47n+MUpCmbgpGDsz
	7UJAY6cghHJwrBHgxcL5dqhiWPfAKVe1eK4D3kxICuyuYI7E8n2MbaSNr36s3SkQ
	1La2FnB+ruTEF8jPlNr+7GaANPPzYWPx340GEB1Fzivcu5wdUNq7ePxVaaCdLlRU
	+xq+GOJwMx1TpUSxz0EYjWVWElDlTPqvqYTT9B/0hIVp8CuI/pk4zlWyNCum2yut
	M94tLWFwZJipI1icnuwbx8o96YMz7nU26sMxN/OfBA3e44J4UJVSRkB67RkQFa+w
	7YbDgu6A/lz7p5ib4vzUakj26y9S3mIKBtz9CPpO1og==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	by mx0a-007b0c01.pphosted.com (PPS) with ESMTPS id 4humm8hym6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 09 Nov 2026 18:00:11 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/cSY4RtAFkbEuKeGfjwslcW26e7hOtgywBip4WFqYTsik7hPWvlZOq5nw/Ey+7IZO3NCvR5ZdNuVGh6Pu51b+pwCqlzDJ+lRib0TvlrmVyLmVCHeQpHON40V0R6y0FQsLYjzZ8vU02hbIEfyl5LGjTnbovtjGGb2DpfTOHdgC8FjjX/0Lg5uBmrYjwFbTQ6HAAfef6x7GqCT7sPByaLEjzrplz9xfZAl/3GaixNbqyuK+8/LpLiwzl9ub6lU2dB51iDrnZl0w8Cgausa8xGu9bsHozvi/oUMqxcMhDxC0LRHJWVTq2doWSuDukc3A/XIRNysSqAswUaLCl2wOJNlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZH9bbD9GUjDERPZclHvZ0zM1gWko4W23XI1Szikzv14=;
 b=G4blHXJuFUx/O95WsGxhCQCz/v9sn23L1+6oFjRSRlEwyCwbzlQCAHlELvviIfjGdNMkhU9gK6DhlURhes0nJ2GrvxIi+kcsxhYl/GCtTisKXihC/saoX7h2FcfJC6tpQ3YZF36MBfKzUYG6z/sLTzCvRePho44RlixoXvvwy7y3fi9YZSA6RzEWT92H731MjeCktH6DvFFSFJ6MpLrBuAqZ3+nyirpJyY3z1sNGI1PuzatdyVOuu8GP4odzIRH5LsY+dCDDRiUS8ic3D+u5ymx9pevj3w20aCVtJQQpfmmdeC1OrOOLM55Shzdgtp1HGDFfnJ9Xayq2UmLRi8LkZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wisc.edu; dmarc=pass action=none header.from=wisc.edu;
 dkim=pass header.d=wisc.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wisc.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZH9bbD9GUjDERPZclHvZ0zM1gWko4W23XI1Szikzv14=;
 b=sewpQ7ZzOLGcH63XZ8pr+Q0vsIF/D76D3fhKFm3i8eqeyUJUwBQYRZ1nnDSInIkVfQwGAHeWrY8UlFnkqm2ncGI1BVRF1o/RGB05H4xn2QE8z9AUNZxWShH9nXoD4RoxDnZVepx3mVHVClywJd9Ng+db+DytZ+8kdQO7VCZrJgpgMqPThBPYJwsJsDSUPXtQ5kwPy0FiL3QHqRUDfKBGsWwMxWf9Zq4KhB4C7ey0TKorYJbHutuUDUHJ5ya6KeJ26rCC4f3GqU6UAACKKmTDGwbRf6ZhBVc6V8CQF56z006pQdUrwwy3zl+h1ijXlguAHc9haQ+cJk4YjhUIuiuBDA==
Received: from MN2PR06MB6639.namprd06.prod.outlook.com (2603:10b6:208:20a::22)
 by DS8PR06MB656475.namprd06.prod.outlook.com (2603:10b6:8:446::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Tue, 10 Nov
 2026 00:00:09 +0000
Received: from MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245]) by MN2PR06MB6639.namprd06.prod.outlook.com
 ([fe80::c7c1:6e17:5f9d:1245%4]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 00:00:09 +0000
From: Seunghyun An <san55@wisc.edu>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        "Liam R . Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] mm: avoid redundant reads of the vm_refcnt cacheline in anonymous faults
Date: Mon,  9 Nov 2026 18:00:00 -0600
Message-ID: <20261110000002.1834454-1-san55@wisc.edu>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::11) To MN2PR06MB6639.namprd06.prod.outlook.com
 (2603:10b6:208:20a::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR06MB6639:EE_|DS8PR06MB656475:EE_
X-MS-Office365-Filtering-Correlation-Id: d37a3a7c-4b4b-4695-065d-08df3ebd95f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|786006|56012099006|11063799006|5023799004|261021123027099003|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026121527099003|261026140227099003|261102123227099003|261028144727099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Wyt0kKfrMPE8mMsH9lFu87rBInYn65hj54e0nAknoYlwGToKzZMdcrctWsp0nk3+FHEU1CR4gMPH0jfqyvm9XHLU5wBcz+i/8yfAiFxclHkTH96EgAxifdbv2NvKTk0G+n1KLQ+tYm0SikOZPiTVtxG3gfBPx21pGfFuePnLxt5+OZfPwmMHXhQlYM1SUnuGgjjWeEcSoj4SvFteBZPC18KSIkD83kNHohAPzmqH3X4IJ6L/ozCfEySxiamWZuvnFlfaDgUQNbfCICn43qpeGOl62oiVwrOQKBMNZoZcBLIzL+ShsbcFfkTZGM+h3+h6EXAzgRUYBvoLtQYxlx+31RWV4MdyH3uUFtOpv+JQ2FvrlU3i1wGukKucbIbfPawuFYz2pM/EVLtbZwRUJzkdXl2DZ58iMJbpRAQSpCcdOsiJ7W1LW06RJtEbL7HMlezhtQkwglL52fKP7ecuSr8ZkSGXqQ+1B6pOC6KN1YJtXOB9jRJyqqvGdz3FwupnljscL6upYsNoo2osU+2Mvy53gPsKtKrQs0Np2AecZzfgxUcp7QgnCYfl9pIYVFcaIFYQocztGm1a5QESQhpLLM5b95Q1rFFlkvkF8rN0NxKdnhoJgM0NrsMTtRq5IVyuN2E+Z5iqyn2O70e0OlvUqF/YKjk5wNW07Z5/IqT0wCrQ8qI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR06MB6639.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(786006)(56012099006)(11063799006)(5023799004)(261021123027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026121527099003)(261026140227099003)(261102123227099003)(261028144727099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ItglMz0uQ82I5wwxDyqiFxSeBaEGFC89aGs0XzFa4/+QDldEU0IYX0S6p/S+?=
 =?us-ascii?Q?YNlW1Neo6CFNa7z2ZOikUMRBcL4ZnaMLoddIT2MmM6DwkHQpzQcvxRLnfqWE?=
 =?us-ascii?Q?PeS75HYJwk65YhQMEMJ/trFw5VYFPw/gRz10ZBSC5F6CmQ+CIVKvye6PYqdN?=
 =?us-ascii?Q?OlGpSmUAhpgvOHeBGhwhmKuxOQF+RrVVgwmmKXCgskRTUzKNQ6bOxMrxuKK/?=
 =?us-ascii?Q?0AH7YgnkWdQeKUyDXiNQLCyiUL2am74wDifsnPgJkBVDbfUTpqegeJIZzBeE?=
 =?us-ascii?Q?ZIId4mVl9TzCH2YUUdFnCenWreKeeBEiXv4QdxvtxRx8WHG3yOX9VM0T8zTe?=
 =?us-ascii?Q?AdRLh1dErT1duSh8MuqjNgoNSZKKq1of7vBPLWNOMXxiMOxkowk54IjV0bWJ?=
 =?us-ascii?Q?LePOMuaMpln+qCH4X7DtNNTrCWtZ+DVnB6vJroT8sOLhTVtbsSPxV0HU7cKY?=
 =?us-ascii?Q?Cr9NS75xo5B4Vavh8RzOT9+jjMWAnhGmgYFlcllyrVzoJaDMZixL4Yzky0U2?=
 =?us-ascii?Q?17seSXS54AaGccHdkfUhwwpjzW7gfSjygNBmonNw7p+x6SeXmHRo86SCuaYL?=
 =?us-ascii?Q?N5e/Ftc0OcZgl8fff5nClS8fABV4pTVUPVtNOyRPwPJavXjHqHN1JTsDgBEX?=
 =?us-ascii?Q?LVECeNdC2PziGTyVHy590prdmd8gZIU35Nk3PXp+pLDfaLWPhu4P2Vq91ErR?=
 =?us-ascii?Q?gojupKbOrlRUEAlI04DQ4mdNZPa22I6aKTgzIvHkKW5fXT1+Rjd2P0oSf0m0?=
 =?us-ascii?Q?I5+ibsfnXh0NDyxR+sWjLXxTRDJMax5zF3+6bguVitptgR75Fe89oq+VKpL0?=
 =?us-ascii?Q?i0VDoEBgr+FUGAXy6U/CNk+LVDDU9z/Q4FH+VvIa/j2CwcQPr1ULmUJ8ekws?=
 =?us-ascii?Q?wEdqa2ZdD6fn7VXOrM6ugZ9xAThbYclRopLciU5UUQuN5A64THc10139lvvU?=
 =?us-ascii?Q?W9yOavfGnOX0+xTl6H7BpfkBwhOvZskUuJ1wyEu/Mey8WIqRqtM8wAIzO9cy?=
 =?us-ascii?Q?k8dKBy37nldU9Kd08FEpk/axL+i+dAtZaMPgdcDKnwtC9kZ5kJneOZPcF3+Y?=
 =?us-ascii?Q?Ok7qN9V7QN0x+oixSZMo+AbAp2Fz2AKdQp7oQI1wcjZihFX5n1KReInlD2UM?=
 =?us-ascii?Q?8Xdytai4yhu1cYBltcZlQ9aM73dKCO/S0eC6/YqnShYStxVZ6R7h9KD32eLo?=
 =?us-ascii?Q?rkvXrSIoTem7OuIfqPG5965HpMZpOyAyRzqqDvHCQYr6swMpVMDkdV2N4/DK?=
 =?us-ascii?Q?vMbNz+R0ug6el+0d7IoS/AT16wQNRy+tuKzFyX9UAmmraY8+TcO2RdcmMCj0?=
 =?us-ascii?Q?Q659ihxZVdxBdVAJVfdACuwX9GIc4J/qc3zGXlxyVV8muiK81Hv/7XJ3hp9H?=
 =?us-ascii?Q?TmePzWzcvR3+QIcBH7rKeSu6xk+/bdJxUej+Dk7wQBOWqnuZyLhZMlZb5QHO?=
 =?us-ascii?Q?yNGTG9EHrJQRYLlN7yXTcTuE4DglVaYvyrFPb+kVrQZibd510MOjBxRWbdeW?=
 =?us-ascii?Q?qhdSMVaUO+C6YAoOUcMb1cuzgV5DCR4gtdjCGv2VoMEmed1F+hos6fb6VP4o?=
 =?us-ascii?Q?2LDzhKm/KMON1oUi7niI31dpQcFu7xqiUwEQvxchKJmHKHJ8IMpHtYsQYQ9p?=
 =?us-ascii?Q?AUgXubL4cLRNgDh0Mw8Rxk+M/pLIlZWqg9thmVajkHPn4XNhTTKgynK5wViB?=
 =?us-ascii?Q?SjUqzXpXtC12MKk40B1+ufRkm8tRKYWD+2I5uFcV/HGZYijH?=
X-Exchange-RoutingPolicyChecked:
	5la/NIbdyJvvpMsb35KbJy+7YdiDGGVAirLQESPDsTHZkcHYatL16MJIoFJD6qfmJky2azGzxRNwFhjDBqD9V95PSef99xE+zO4YDBknzfV0yYyGPOevd3LbFiqZFUJ3KKi2qZb3Jj5DM1n7pTZxlpOEhuNK7sYLo4kAHKxoQ/FH911Rbr6EYlX8qVAKFisxfZK3U+goNZU+TFOkB02YFusdnaKi0MEh+MJfOS9BV8f/NB/fEJOUUwwzSERCfVCGo8sUKc6EjTGMhLYEV+/G1PlJj6iIJ2lta6S00bNE29XKHEIF6HXgNUiaGSgvtx/dNAXODBSmnbRw6txbnT0Bqg==
X-OriginatorOrg: wisc.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: d37a3a7c-4b4b-4695-065d-08df3ebd95f7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR06MB6639.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 00:00:09.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2ca68321-0eda-4908-88b2-424a8cb4b0f9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dNYdquUPrQcNlo13yPy0GdjLhGYDYgPg2LrLUq8hDsr5XGtXG0PCAeyXsu8C9q0B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR06MB656475
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA5NSBTYWx0ZWRfX561l+BtIzLiG
 9/P1WaYpjUEs6mevRlppxJQGzyqwdYUOscjTjBP/0vbvdvHamVpmKiLn3r0/pcPvfkh7FV96FCY
 NkQd8JLD8xEDzImD839H3pN/HIJ74YM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA5NSBTYWx0ZWRfXyvSeSZvlYUWr
 z6ToDN13I37TzbsljdybgAMe/EOTnZWWn/LC7UBEY/kpkRwjpBzKKrSkXtyP66mc8akqslmuUuM
 YXXf3+y5AnnJxqJfWsiXyGfrSFG2l0cdiGSLOvH3ZA68H2NcLS9Y0xH079+bNztRlxLvEfMb7UX
 TdLzdQCj+X+GnhtKRRqprtlTfJs9+j1A1uZR9fzgsccBDelG1RxrunIqFYqSVv7omhC/2NRUJac
 b+3Qs73B24LQHzZLiDKxvMXx0VqYGe7gNFojVfYPOf9MXX8sc///1S+M0CxMba5tUL0nihfGm0u
 FHHpy3ndTDA9IlZPKep7Nl2sCWU8gFmVfpmYSICtIm6fJqUfBSPCp1B7WqaTUNNna9KQJcgwC+b
 uoY5+lju6Dm62Vu5Ri1YTfzpl83hZ/gpM8KZRnlDnLPpRos9tNPGkT0T2TSnQ1ZS3zj4+gl4+fn
 5Rt+d4G6ZjbfflMkcMg==
X-Proofpoint-ORIG-GUID: fWeqYPGxtbYvUyg3ju4BtpP2E4gX5Z8J
X-Authority-Analysis: v=2.4 cv=HtDjiETS c=1 sm=1 tr=0 ts=6af25e8b cx=c_pps
 a=LyZwXkN/zJaPlZXKe3eCLA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=U-hppK1rdbEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=ZyELlZqCvD1aXIDzc3I-:22 a=-L2uzytrI8BeDALVFixt:22
 a=NEAV23lmAAAA:8 a=9ycx-N_BlWucs53SZHIA:9
X-Proofpoint-GUID: fWeqYPGxtbYvUyg3ju4BtpP2E4gX5Z8J
X-Wisc_ValidFrom: true
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_07,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 clxscore=1011 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090095
X-Stat-Signature: nfysfhuzgam4twyjabqi7rds3szxecxm
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF7F420002
X-HE-Tag: 1794268843-381492
X-HE-Meta: U2FsdGVkX1/oymNOcHTq+1d5e2TkF0d1qCVYYgpIyNIH35ym3j0QQTHc/8GUjszI93pV3dVrS1lFAJJpeuwxdBmvI2cXoM97C8AT28NDowavJHRvI39egZXng+aFVYXo3xE0MBhsUIjD9/CwQ5Os0EI2ZP2ev6/KzLKKnhd/vtMR12InNOujLhHZ1Q/D84DZNukkZ4a6S5jJ+MYq0Q509Jt3mqVo9mZygnvO5iW/K2nin8l5GE+tsOkKqc/4uKI4r+h/1gKo2IhB1YHjFYfM4gAjqHAwPZrM66cqxh6zoYNk2BctGfMZVkNC2lNZ245jx+3fKg4bwf3wdrFeEpGE58lGclegYn32jVdBUlkcb+RhfEH+rGcl/KDB7051BaRNfOtQPfvbodHBnLjbGZlS2VmgdpEPqVUZ1g8pu0nSxlnsiH6lBOpnRapMm4TIi3MtZS5KnYplInasRUnsic0L3UnFSxBRvD0u5518otsk66RZtbI5FHeDb/lQ7PBsoFimcXnl+WR4HtNFcOmOtufaYIs2lzuR2S1YT9UoIhJx+SdFBvLrEJVrOFzKqojCLDMCjBtYZh6unPHpCzFBS2cncoc4qagiB9OiYcErBsREQqpH0dFuyBwFg5b1AeLcrVykr+946EpvuQm1LBjhTLVs2dZhkuY9tH57eh2EuqBj5FyytUzS+QdZVcgxfQEexhLfEwMpuCORHrkuZrPbHx1sI6satRUI9B9dUyABpAuwQvRvsPgtRjeeSK4zm6aPKnIBFNbs45fSWEOErVhy3KcL3xBSt4GDA318PA5JR4j3rs/DMuA1y0HLH0S1kLDwfjLcdPlFnRtMRu6kKkGNPCUk8qTSdKarNcDF/uv7pRti6D2MmRZEfAAP0c6PVbu2i7VG6QjP8NdQ6TrR95ASZcmVjX5oIuUC2+2XXW9pOha0Ifr2M5p6eTguGxVmopJtBFZ5ZtbBYkKUxf1QCEgvxCQ
 zr5wuff8
 PJ346lWhrtXagxuh0fL8n2UyWe3592qnkWU4+XD8JMJrUtugcfa95loXqOORDH5YgDKYhHeKDvS5S4SOO4pL+snMU14/uOqyUmEdLCM5h3eqG9LqkHSAMedwHWlJAbqXQR0CbDfl6WWoTAfXXlZtcTfFY4/iG3vWl1gUzz2zS7FTxLSWNcRVv7NM0HGUTKxmnjJigZzxRHuQ5BWjmMEOZZNLvcmWx6N5BL6LVC8QBEYIoxqUYQlVFEccUm+0G2QJlwebdbFHXDVXC9rbjBBeRdKPrjDf+CtjJHW87N+eoUtUUMrawTwUORYT8KI3QcZFepgCCeB9Sml7fuugMdgke9OyR4g1utNFu2fGb2IxnoOdtzEkYhBTExwRYy410DjldOKbeDSsX9ujFFxLpkQ7l2UaIQdMnsx/t3UX2l4xvH5QoEAHf7RPGjbbMh+Od2dwT4RYEPdK43NXVXo9nbFOfJMSYdWvozgW1NHMCx7xmnZXeFMErtxnymSubE2CDuAvZIwxgwaOzKbbxmgPcKs/3slkJ6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On the per-VMA-lock fault path, each anonymous fault increments
vma->vm_refcnt in vma_start_read() and decrements it in vma_end_read().
When threads fault on the same VMA, that cacheline moves between CPUs
anyway. On current mainline, extra reads of the same line
happen in between:

 1. __folio_set_anon() reads __vm_anon_pgoff_hi (offset 132, next to
    vm_refcnt) via linear_anon_page_index(), since the anon pgoff series.
 2. __vmf_anon_prepare() -> vma_has_anon_rmap() runs vma_is_attached() and
    vma_assert_stabilised(), which load vm_refcnt (and the mmap_lock
    count) even with CONFIG_DEBUG_VM=n, on every anonymous fault that
    allocates a page or breaks CoW. This came with v7.4-rc1.

These reads can miss, and they also make the following inc/dec more
expensive. Patch 1 computes the anon index from vm_pgoff for anonymous
VMAs. Patch 2 makes the assertion in vma_has_anon_rmap() DEBUG_VM-only.

AMD EPYC 9634 (84 cores, 12 CCDs), base is mainline d48723711bae (after
v7.4-rc1), CONFIG_DEBUG_VM=n. Threads faulting on one shared anonymous
VMA (each its own slice, zapped with MADV_DONTNEED), faults/s, median of
3, all three kernels measured on the same day:

  CPUs                      base      +patch 1  +patch 2   gain
  1 CCD,   7 threads        2.360M    2.369M    2.425M     +2.8%
  7 CCDs,  1 thread each    1.738M    1.982M    2.215M    +27.4%
  12 CCDs, 1 thread each    2.288M    2.548M    2.949M    +28.9%

With one VMA per thread, or with processes, both patches together change
throughput by less than 2%. In every cell of this and the next table the
spread between runs (min to max) is about 5% or less.

pft (https://github.com/gormanm/pft), which was mmtests'
config-workload-pft-threads until it was dropped there in favour of the
will-it-scale malloc/brk tests, does the same thing without the zap: one
anonymous region split between the threads. Same machine and kernels,
faults per wall-clock second (pft's fault/wsec), median of 10 (of 5 for
the last row), "pft -a -m <4*t>G -t <t>" (pft needs a one-line fix to
accept a CPU mask that does not start at CPU 0):

  CPUs                      base      +patch 1  +patch 2   gain
  1 CCD,   7 threads        2.938M    2.955M    3.044M     +3.6%
  7 CCDs,  1 thread each    1.938M    2.215M    2.704M    +39.5%
  12 CCDs, 1 thread each    2.456M    2.673M    3.547M    +44.4%
  12 CCDs, 7 threads each   4.132M    4.863M    5.196M    +25.8%

With processes ("-n 7", 7 CCDs) the change is +0.7%. With all 84 cores,
threaded pft reached 4.132M against 5.243M for the same run with
processes (-n 84), 21% less; with both patches it is 5.196M against
5.282M, 1.6% less.

None of the will-it-scale tests mmtests runs now (page_fault*, malloc*,
brk*) has many threads faulting one anonymous VMA. page_fault1 threads
only shares a VMA when neighbouring mappings merge, and it is then
dominated by munmap write-locking that VMA (the threads were about 45%
idle here), so it does not resolve this difference (it also varies by up
to 10% between boots of the same kernel). malloc* and brk* take almost no
page faults.

A real-world instance of the pattern: OpenJDK with -XX:+AlwaysPreTouch
and G1 has the whole heap in one anonymous VMA and pretouches it with
ordinary write faults from all GC threads (108 here, not pinned). OpenJDK
25, -Xms32g -Xmx32g; time from exec to main() with -XX:+AlwaysPreTouch
minus the same without it, median of 10:

                    base      +patch 1  +patch 2
  G1 pretouch       1866 ms   1653 ms   1658 ms   (-11.1%)
  Parallel pretouch 1872 ms   1644 ms   1658 ms   (-11.4%)

Patch 2 adds nothing there; with patch 1 the JVM already faults at about
5.1M faults/s, close to what this machine sustains for 4K anonymous
faults from all CCDs in the other tests. This is a one-time startup cost;
once the heap is populated there are no such faults.

Tested with CONFIG_DEBUG_VM=y and CONFIG_PROVE_LOCKING=y: the mm selftests
(run_vmtests.sh -t "mmap mremap vma_merge rmap cow userfaultfd madv_guard
ksm migration thp") pass with no warnings, and so does a test that
soft-offlines anonymous pages faulted after mremap(), fork() and on a
MAP_PRIVATE /dev/zero mapping. LOCKDEP=y with DEBUG_VM=n, and RISC-V nommu
with and without DEBUG_VM, build without warnings.

Seunghyun An (2):
  mm/rmap: use vm_pgoff for anonymous VMAs in linear_anon_page_index()
  mm/vma: only assert VMA stability in vma_has_anon_rmap() with
    CONFIG_DEBUG_VM

 include/linux/pagemap.h         | 19 ++++++++++++++-----
 mm/vma.h                        |  8 +++++++-
 tools/testing/vma/include/dup.h | 13 ++++++++-----
 3 files changed, 29 insertions(+), 11 deletions(-)


base-commit: d48723711bae9b8cdc56719c448ba42fef28cbee
-- 
2.53.0


