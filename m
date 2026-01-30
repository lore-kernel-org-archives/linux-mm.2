Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EEE3E6BF00
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D18F6B00A1; Fri, 30 Jan 2026 06:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D5F6B00A3; Fri, 30 Jan 2026 06:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4A46B00A4; Fri, 30 Jan 2026 06:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 380E76B00A1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:12:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFEE858B8F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:12:55 +0000 (UTC)
X-FDA: 84388367910.27.8B18476
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010055.outbound.protection.outlook.com [52.101.46.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 289C240010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:12:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pw67ipv4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.46.55 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771573; a=rsa-sha256;
	cv=pass;
	b=xu4I8kIg0GOHkjl9pGsGDGHR5VvpZE1igGIOHYB7SD9Z3sOMFaS5G37v2yalIhIaJTGGR8
	FEyATkPW3Y55EuelLQCeRCxVyfULsh5XDTlxYW1DOQ8HROKEm8QfAs1+AXJeNJBLrzZmoL
	nYcV0m/SVWRyL7zsojPLe88CuSBLafY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pw67ipv4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.46.55 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ryEkM0R0UgEq3cYLafI7G0UmhxmDw/OoeGOVdZpwls=;
	b=AxUL07zR81+sqpm1w7NS134RO8NvSBwQLSu83N80WVyXXoBQ0E7EyQoIdGg4vHYAleFm7f
	qoeRkCVHtOcb6PJRKd3eXMopErvGp06X0CoG8LVd28Bese4jogxamenOCFtkgPhGI8N1Pp
	1oIJJLsWDXbNUGXfQAOD3oOZLRXwz/U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iAtiM19e+stax53cHhwdMAKGvRAVXU3EDAI9oSL/6b1uybPEZAL+8tCk8iS4bDnvarN8tE+8XqROw8a2tGZoiC1DFmfl9lR1y+9ZuQqvy3T108eceoZOx36k0NADB896PAsG3yu08CF8f61GyRQYSAPmH/VsXa+0xS2tZzY0t0Ks2rh27Ct99S7oRvKEaGMPChLaMajWVKUjSkdR2kS2M9QkSTYnVfEZC5bG6Z29UC75jhbBkjN7cEZaA70cGESlfAdfS/l06NkvFoDcvdFtAWvkkvmUxRZ85UunrGPNM045GqG/Wk4ncpT9liOdSJoogc59CB24H4EO1WVYV7Yb7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ryEkM0R0UgEq3cYLafI7G0UmhxmDw/OoeGOVdZpwls=;
 b=sR2f9nsrLEKWxAOjxNa/VYO3IR1CHdu6jk8oz6fL3pdmXHz8fv4KvRybeCwI1dhKjKSNdBXjKzKCg0fVP5ty6xsHSBNZc9qLe894eM5EqyvnOKnK2nz4/SSTjpVNvJrjeNQwYN4cXa97Tazq2h8Ph1TxPdH9uLf4OasLm8Dpv02hvgtc5oBSwtWVFGlTO4T3709BheOBmpzz/3OdYc6bK63Fur5fbY7Kos20jpUcOZtGbDtUEb152lEK509D1D7mMPblsUxB+qeU9puivqcHfBar9u++PgobGPx02enY8T58x3wfmtpJSFhyq/xEN9YQrvkPsYcyTuQn/RRFJ05M/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ryEkM0R0UgEq3cYLafI7G0UmhxmDw/OoeGOVdZpwls=;
 b=pw67ipv45gdljweWaA53PoaTQaB0B7cjD1r34y4BHLst5IBT9Kdp8jmhFXDaEu5DtV6Pmt1QtFO1me8tFwsDABX81G3fo7Wh6AbhbuXAjyU+eTBy1baoJHB+PvzMoKYaBmRYfBITbfNgXSORuwYKPigpfPI2DIOoYlTpXzC6FUpZWeCLEPpba12uJNo7yn6HSokEhi2Ps7fBhJQHM/cpcc8JtSWPoqjJ9BRiMiR6ZY8w5IkS9A2SStO+Db175oPNpEUskSUZtEAT0RIItgu+Xj0UYezMFWEYnLVkCGhBsh1FMSH+nJ0OurymL88ut/5XK4KjiroFqDq/bCXxUifDvQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 SN7PR12MB7836.namprd12.prod.outlook.com (2603:10b6:806:34e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 11:11:20 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 11:11:20 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v5 07/13] mm: Add a new swap type for migration entries of device private pages
Date: Fri, 30 Jan 2026 22:10:44 +1100
Message-Id: <20260130111050.53670-8-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130111050.53670-1-jniethe@nvidia.com>
References: <20260130111050.53670-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|SN7PR12MB7836:EE_
X-MS-Office365-Filtering-Correlation-Id: 43b08d12-91ed-45be-3a12-08de5ff04bae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NdujFQm5hAtxP3UsC9AuNmlE45kbbbHWLrNyXj/VtnKflzhC2/BxA/NtAfnR?=
 =?us-ascii?Q?my9BLXABsEWfzzYYf5iPYOt+VlmoLaJofUh238ZcLoCWcYrQUdP6Sicka1+v?=
 =?us-ascii?Q?T3Wu7bAAQLqKbtxDuzKCkPllKxIyVHiSzIh0r0iubfrspdlsJ0VpIjoLyO8M?=
 =?us-ascii?Q?V0PIjpXnj1u5IDHBkBDXi1OBIioFFhXhdeYtcFa9xMnM0gex0/o6J72/2DLi?=
 =?us-ascii?Q?3FvnJzR0wTrXamAhux/tnmPtEyOHJX2hD1D966YqLKdohme5WIaBiOyaBkyo?=
 =?us-ascii?Q?eEhHb9YE2jzsZpzpd7vnUDefeMutOhxzb9qwMKKX3RzQZP5+eh7gO+I7OdxP?=
 =?us-ascii?Q?ljvXN/rIzgOvqPcrSGLSqfDb8zM8wR6j8zDE37Qf5koE8AXyMZqjem9ThF0y?=
 =?us-ascii?Q?1s+bwYaV9TYZ/OIIm0CAtVwm5owyios0lLSuJ+HqB6e2rSO7RtmrCpqNz7SP?=
 =?us-ascii?Q?taFJyukp/mGfRaGCnXJOp53Q7XVASvUr1WhHOBmg7ahp/5Ap+dkZoVpHANvq?=
 =?us-ascii?Q?wx9+WZz8Vx8H1k4WQx9CCIMlU85gY4s/8p7K/IGu3ufBv0rlR//m7/m5OfDp?=
 =?us-ascii?Q?3xHbgYUwDiDiZPPj40dJKkXP+/U7MJnVdMjFkBIhg2AirViWgNEsy3iIY6LY?=
 =?us-ascii?Q?QEdYO1tKj1l78IqBihuW04jOiLYO4UCesKz4667a4/Rxm+lz27Hw6Ecwc3iE?=
 =?us-ascii?Q?nHlCLAepW6KFxbkvydQ+Ng/vi9PMHd1DBS9kISf509qSSiSPQoyVyiQb++Ff?=
 =?us-ascii?Q?wRFLcdz+TfaKYVezZpaMpN8GyHj7ehgMW9SGb5cVBd3RfyqkT5tE9KTCo+1u?=
 =?us-ascii?Q?N0GGB42rmM2p8nVk2qjuE3B3OJ3cCbdfaggQL0oHwYyXavPMhaIxhvvngI6I?=
 =?us-ascii?Q?ZPKUWgkvllWhoWJU9SF9VZIZYrsRtaHG3nrMgS1g4QCUtT9K8K9IJpxCQv41?=
 =?us-ascii?Q?8GO17Soz0ahfm3kbGwaFfGTMjlFJygS323Ea+ivYPMILMSr04qp0cpsLpDNO?=
 =?us-ascii?Q?zQhdngLjW8Wz7QExpLT6zUWsrvPr95bX4kzkep3TNPX28rz/djygMbzRP1QZ?=
 =?us-ascii?Q?EId+6wCr/9iTNiEgWT+f37h+HgWPgLfJqkSO48FmD9sHIYHmP04ILwO8rHMr?=
 =?us-ascii?Q?Z/T+seKsBCgGZ1MTnaP1cK2vPlczABUxPfejMXV0eM8bjSk5CjmMzhL4N5sC?=
 =?us-ascii?Q?Of7QtF2jWT90WVOqxoJizL+zPzdrCAJegbFWL5igOyoDz/a7L/3PTY1wO7fV?=
 =?us-ascii?Q?fOZ7JescqC7muielkrrU7djqE6cUDfypVzJSV6NfDAHv8/tKdT/TuVAthYpB?=
 =?us-ascii?Q?X1fdkkypooopOlhZ2DAC1SptN+mDQyDxv0ROg+Pa+zfZhAL7zVNZ5wg/V2mW?=
 =?us-ascii?Q?XjW++f23LtMPm2BRnLK5c4SaSz43vornzeSwq2EpW+enxavQB5AVTfelLI3K?=
 =?us-ascii?Q?Ui3/RewQOauH4nfRTylEnDVF3g+K3s+xg0Kmkish6zruRR1zbXmmNszvUZ91?=
 =?us-ascii?Q?6dhsymSfIxjQI5/l8ySKg5zHt1ijcolttGhNFDRRETLNpSPMg/NKCjt1utN7?=
 =?us-ascii?Q?k/U4LedoswB8Zt0rcl8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9es2Ntvz4ZBLF4gawTvxGiOWGL8tw1XFbxYB0mn9I+fzljd8H4CG6kFrptfO?=
 =?us-ascii?Q?u4wpHbf5ZjZBjGqxeL2DOA/tZMUvKEFDJlBYKi7ZnE4hhQCdfRxkv3JrqlVC?=
 =?us-ascii?Q?7GQylG9yOiC4PjbJsAIERLP4Qdtbw5KErtG9o4KH+fYZklPR5Xll7bUpLZ4u?=
 =?us-ascii?Q?pwLHrooB7TDbGfXr1+++7lpWwWZe746//dhw8W+QP2MpQcQDeBiiLSch8u3S?=
 =?us-ascii?Q?F6pcUUdJEY7Tx/y4IXz5oJNMRAIYwAulsPWMDAx5CtBftZyQ+sFjPFnKNeHc?=
 =?us-ascii?Q?ze13KuJdsEngGXSJVmu7A6AyY35FUUR8ySduvvmSJQ5Sr/QIahtigH1Heh1S?=
 =?us-ascii?Q?hPW1rD4+eHhZc71BD1cZo91XyETi+vQiLqvfZZM+YMuhCn/FQoMb9HxWHqet?=
 =?us-ascii?Q?wUZ2VurYFS9xHGkiwOOrrc4kAl6iOLRze35VM8HDcjL989QhN1+F7ozobZAN?=
 =?us-ascii?Q?87HSoWWluvMt8xiXyE/xi0xUb7j0Lqo9DLXBBoMftKUt7uiA5dGWWE314tH+?=
 =?us-ascii?Q?HRiRlOawur2COVJ9E8SNbFZznfXF5e90fmGyn1UeJtifxC2tlkDkLZ9ncsyt?=
 =?us-ascii?Q?IPgi/QNmAe6IJRf3kuDeOXq7tMd112F0Xm0zABgW14tqpzkyMfsB80JlbO12?=
 =?us-ascii?Q?KB8YhhDPA33Aml3DLrIVe2hv6K4QVfbJxVjvR6/hHUayakC0pUc168WMe9f7?=
 =?us-ascii?Q?DJ6ZA4QXaF5D6ssVCBbj7OPAuljmXl+hiBN1Cvlluj1oGfdD5ru02PKWmohU?=
 =?us-ascii?Q?hsJ2JeZokRunfIeCnmKsDy3ND/xF1PgZzIDHGyaTaADW8T3lTYhyOTlwevc9?=
 =?us-ascii?Q?akGEZMwmFWnHHbvwj5YSIRaNtJ2Dtaz3Qqc2sNwfAoB2OVdUigffMsHaI/e2?=
 =?us-ascii?Q?pewz8dd1XJdSEvPX6YKmw1XF/maGaBBHWjltqVIgcr7+YpRJkrobC2UPi/dd?=
 =?us-ascii?Q?qCTGYyuHN5/KwmQ5GmkjTtlzGUYtkqLUTtN3lW7B/SbCQ/UtLBmuEVGRRBQk?=
 =?us-ascii?Q?NV3oazhZkFAkUxTm72H1GPcCpJdI63h766uv9beDFGZx67rT7y71HuJKUOEj?=
 =?us-ascii?Q?he/Y5Y7AdXHaqyp+GKGl7CK7tDZhGcgaDEBlsi46y28NV1/YMtN9RZPyrFAh?=
 =?us-ascii?Q?rM7xpj26kHtaxV9vjWiwAJZUmaP2OpUuxpe6/tmclIwebeTGulSbElEmAW0d?=
 =?us-ascii?Q?QB4bM99apLIemmLSMDHigy5/G64QKnUzDC6ikB/Wa1Ln1gFVU93klx20rk74?=
 =?us-ascii?Q?BV1lLgolYDaCTfokAlHExZBCBg1yTnCqpVfHCp2lveHw0G9kZeI66zGDAMZ0?=
 =?us-ascii?Q?MindkWZABuWHbPJr5b2wuwnxRy8fGZGKsJcNO0QMV5O2NpUGuDj/X0lk+V21?=
 =?us-ascii?Q?/tRb9D2iGv2DboCZYbDVH2Zda9re7Fmmki2aek+5y9Yg/o7i5hUn3xm8xHfF?=
 =?us-ascii?Q?/vlAYXk1tVV+wnBWPlrlMfq1H7814Y+fgrFIEdZL4BQCU2OSlUXn6LAwYtDD?=
 =?us-ascii?Q?5/0DVn4sIOhYN577RFjeARNiSX3TpJnRp9/PCPE4cDMVgs2C1MzMFc4n1+xd?=
 =?us-ascii?Q?6XSXq1YpWnndY2rEwlQYgNNPJ+bZ18gtVntM5pY6r+dfcoZutCmmIspM9jYF?=
 =?us-ascii?Q?FcPVHQ3OhbtpL+B/aTbp7JgdYN2O6DaTb0frVugBuGqE63EaYHDk2agfKgq+?=
 =?us-ascii?Q?ReLB9BpTMiu3z/s13EjNmsu2QYpmxv3gRcAzkMTTJtUhXWdilMPAXftrsU4M?=
 =?us-ascii?Q?BRgpwtzkKw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b08d12-91ed-45be-3a12-08de5ff04bae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 11:11:20.0912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hb7UOnLJKMgE9jRm3soDtUK4mSN7kZCZrdmVZjobN++6F8WHKW3B6yg/4H1aS0b9JVxoCthe7vEWbVnzsr/ryQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7836
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 289C240010
X-Stat-Signature: 5qp5u9z45rhf1zd4qzcs719eh45urabi
X-HE-Tag: 1769771572-426939
X-HE-Meta: U2FsdGVkX185INtdfpshUA0kIdguEWHQmGtgJE52X+Z4meNP4rubNWlNjj93XA7z9sxqQqLeoFnxGu9kj61s6RlA8+ruJqBiYbQLQO1vrIoUsMkzFkFk7sx2sgsoYoY9jZdhRjNVEmXhaqjY6uMKnB2Fnl7LmzGzx8b7Ys6/vidH1u+KqJTiMIO9lnp3DHD8EcUzjvsQHBuhCXnQuRnTZu8kSJM1EcngSdzGuodw+Idq9nTPgyMKPRsNm/haJi02G1g4RcjTReb12f6dBl7RVXFuaa4TjyR34DN2RbEJ3kZd2cS2ayLHNMOHNTXnNhgb5O1IEw03wWr/LnSjptT2JIhROrNuLwJoEOThfOx4xlCJjbK8WmYMtcqiUCwAz0PX3KGrygniRQgXOtNdr38CkA8+Q/T0CUU2WafUojLuUTKvDiW+daURFoohvQTArTkcynSTXYQPklqrS0PoaSqYCe8lD9CNo9qhhHvmVkdUngnnhqtN7GZY4KFgad0UD6Fbm/F+7suy34nfeBXiR92235W3F3lPPZDlMjxZItM6Zp49yf+C09OnoKYNqkri7fMjK/7MkVs85FW8SstPWo+rOTEYdz0scdC6jIoCW667sAfvdiaQUXlKzble/NfTfdX4EnnbpTfDN8iCC5Xa3QEVMF/SDAS75xPKiYr3LbpgWomn/CgSlruZRuGoKaN5T/WACIGZIhHIB+MfzVLvX4TT7E3HFbgPgkbCi387s7TVMu11muONUfwmZ/+5k26gZLjrhLV5hQnvUJ1e/TXagJDBLofZpYEjeM/tz1ZjYE1FW+HuhgO9K10HOsVF/5T1iDgFoUSTd/kHNWEPSGLkczuxmUUa6jdrnr7DKZ4X2NeAoOLOqNl881KIFTWnqJyYZ3WlZ3zdocunqPpob9lQXeGhTR6NsKlyQjYqhBeetrOW4DateZslwxAciSZ+5ZkzNumfVxs6gLPtpxuQETwKRB8
 2cNdaRSs
 OtQSSf+TBSn1+vyfk9jWUZzAd3H2ICiyjMtobPvgFwyhBCsZifsciE9UY/VFOh2K4W/LJ5cJiqcMiQaaN4E9b13lwg40rUf/P0jgpOhwPYjCd1QSFF4ZZlvwyBOS7havgfakm+ywHcsQ/tQvNIrm+zoKVkacsPpYZkcQ82f6wpTwuN17c+fmHqEEv7uahre8yDQJ56hNLhpMGn6AjSOc3qxU+4VoZPsf5Yw/lqNfPdFPpvRKenQws/onT0JDpLjRxXCjb8vrPknVSgmCBYrjuRuUi6ZngKnitTtaUsb1htgaMuJyqtWeYw+ZY55NLip7ixLcd0Agi3tTlZLMF58ziBqNSVYjZdi0Wy0lXQIsVardv5C/rmFjP917bX1LwAho4bupdXo+FdR22vWbCqH8YFDvaPZ3eEkEJ/Kl+gSXzkHRcPScJJWLodGlXQQaKg9Hp/GUmI/5vuMkHzmm22/l9SyFCGw7z3GChjdQNEH024hE3XEYLrme0u0sxrHTYTsIndsLL/FGP1AFNxhJ/b/bpTn1SGd7JBgyDZ7YN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
pfns and must be handled separately.

When migrating a device private page a migration entry is created for
that page. This includes the pfn for that page. Once device private
pages begin using device memory offsets instead of pfns we will need to
be able to determine which kind of value is in the entry so we can
associate it with the correct page.

Introduce new swap types that correspond to the existing migration
entries:

  - SWP_MIGRATION_DEVICE_READ -> SWP_MIGRATION_READ
  - SWP_MIGRATION_DEVICE_WRITE -> SWP_MIGRATION_WRITE
  - SWP_MIGRATION_DEVICE_READ_EXCLUSIVE -> SWP_MIGRATION_READ_EXCLUSIVE

The SWP_MIGRATION_DEVICE swap types are meant as specializations of the
SWP_MIGRATION types - they are equivalent except the new entries
contain device private offsets.

Forgo creating new predicates for these new types in favour of new
softleaf predicates that will be introduced in a subsequent patch.
Currently the softleaf infrastructure does not have the means for
creating new entries so provide swap entry helpers to that end.

Actually using these creation helpers is deferred until a later patch
when the softleaf predicates have been updated, otherwise the existing
checks for migration entries would be broken.

Note that SWP_DEVICE_NUM is increasing from 3 to 6. This reduces the
maximum number of swap files in the worst case (i.e.
CONFIG_DEVICE_PRIVATE, CONFIG_MIGRATION, CONFIG_MEMORY_FAILURE) from 24
to 21.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - Update for softleaf infrastructure
  - Handle make_readable_migration_entry_from_page() and friends
  - s/make_device_migration_readable_exclusive_migration_entry/make_readable_exclusive_migration_device_private_entry
  - s/is_device_migration_readable_exclusive_entry/is_readable_exclusive_device_private_migration_entry/
v2:
  - Add softleaf_is_migration_device_private_read()
v3:
  - Move softleaf changes to new patch
  - Update commit message to explain the change reduces the number of
    swap files.
  - Move creating the device private migration changes to a separate
    patch
  - Remove predicates - we'll rely on softleaf predicates entirely
---
 include/linux/swap.h    |  8 +++++++-
 include/linux/swapops.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..c15e3b3067cd 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -74,12 +74,18 @@ static inline int current_is_kswapd(void)
  *
  * When a page is mapped by the device for exclusive access we set the CPU page
  * table entries to a special SWP_DEVICE_EXCLUSIVE entry.
+ *
+ * Because device private pages do not use regular PFNs, special migration
+ * entries are also needed.
  */
 #ifdef CONFIG_DEVICE_PRIVATE
-#define SWP_DEVICE_NUM 3
+#define SWP_DEVICE_NUM 6
 #define SWP_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM)
 #define SWP_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+1)
 #define SWP_DEVICE_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+2)
+#define SWP_MIGRATION_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+3)
+#define SWP_MIGRATION_DEVICE_READ_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+4)
+#define SWP_MIGRATION_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+5)
 #else
 #define SWP_DEVICE_NUM 0
 #endif
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index c1d3c0e8981b..220627cb7fff 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -148,6 +148,21 @@ static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 	return swp_entry(SWP_DEVICE_EXCLUSIVE, offset);
 }
 
+static inline swp_entry_t make_readable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_READ, offset);
+}
+
+static inline swp_entry_t make_writable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_WRITE, offset);
+}
+
+static inline swp_entry_t make_readable_exclusive_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_READ_EXCLUSIVE, offset);
+}
+
 #else /* CONFIG_DEVICE_PRIVATE */
 static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 {
@@ -164,6 +179,21 @@ static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline swp_entry_t make_writable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline swp_entry_t make_readable_exclusive_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 #ifdef CONFIG_MIGRATION
-- 
2.34.1


