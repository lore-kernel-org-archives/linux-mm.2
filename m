Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951D1CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 13:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0178F8E000C; Tue, 16 Sep 2025 09:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30708E0001; Tue, 16 Sep 2025 09:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F218E000C; Tue, 16 Sep 2025 09:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0D438E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:05:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D2AF1A012E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:05:24 +0000 (UTC)
X-FDA: 83895134568.16.9B6E724
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010003.outbound.protection.outlook.com [40.93.198.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id DA849180004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:05:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R6gJHoNt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.3 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758027922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBlNXv9w2MFDe/4wwY3xOsTqkgSA5gMrcq9Y7mx7zFA=;
	b=Sa5LN5E3+cG/sbaDrCqEirV1+IbCxjTbqoB9iLMPHjTX1L++8TSTplMpyMImnipURwIrBK
	kB2LJFCgOTOTQxtUHdNNKaGWEKKwoQhUjrOk7uN4P303JzywQtX9Cb0YlXMQWFR1SjZX7d
	mSaIye3ShU+cXO/eP3+4fULovxrA4PI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758027922; a=rsa-sha256;
	cv=pass;
	b=f+DmRLkunv6LRHWGsXN4+ewKpOAGDPeoWhKX3qdX8uMAJ6jPb8x4xJttnqGQDM6ROwVpXS
	um2qI0cWl5jcYOdZFK6bfp8KnNDfQe41YEAGMpcrToXosvrBfpk9OxNZtZqlMtPbCVEAF6
	GIgGHUa4Ubh6IxRAkknCKdDnpW9E55U=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R6gJHoNt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 40.93.198.3 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8xUiIlnxKdiQrSqG2eFsqoNft5ZN9P/nRRmWjuwiQhNnolmsrLSx81QQDBGObCKlyhhHyPMXQbsbU14D0C1qIxlXDILOk/Qqn/kr9HDWwTHwrQYH+w/hmcb+qRqk7B3QP+NH2mo3L5XlGOnLRXoCc3aDk7HOnF53R7LFIPv+OXjgFtR12A52/IBtS8xnZ+Q2fipSrTf3kJregzXaHuQiJa0E96gqrm9eQVuckF4tMjUfXAL9oF8fN3nvpehOTbXBpM+E+QOr29MJcYShlPXi19V4dMAF/TUgH5ovVozkqy3Wcck4SvwtdL7WrlsnxDzNEZLkxq1YUuKnr1AuHacZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBlNXv9w2MFDe/4wwY3xOsTqkgSA5gMrcq9Y7mx7zFA=;
 b=IlwYmbev/Lf1sKzZLu3ocpWfJvt1tNoSQAz72suallwdau8d3qAJzaOe8AoJpwCJiLbdxZz50/OgwxTTb9jL2Bin5FWlDJ6WHdtLqPpYC5493VxPl61y/zWuXwsyI4PmstoERjVIa4H4Mb1Tp1NvKXoLjhIXhhBRuB8zcx0px6aCOn2VqEo8OZ/IVhlYtck3OrexoKwSlsnc8UVEBZ55Lk9xE2dExFARnQSemWakuWoOhLava07W/HKjX9JQnyow19Nw0azpQqhe9WfgzxGCELAJuD91HHmDrVmx25PxkiYVhJHUZVsqdRdJJ0u4NLkygbxIoxf6AT81+detU6ixwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBlNXv9w2MFDe/4wwY3xOsTqkgSA5gMrcq9Y7mx7zFA=;
 b=R6gJHoNtom6xnx3yPAVgbqKWGdpH1YPCDvfZruTO1avjJwflliBNcxJqDfifeTMfBvdLwdxZwS1s+8JbQqNOgWcrYXFoBJZt0QAvYb9vc9WrDyQqhse7dIamvT/DYR16yJ99miMvPz2TT8ErpIhqE3jwAYJJn2GUb1xpAH81C8B7psBdf3JyFaw2BoYpXd/IHXBtlrsqEC/oeoKczT0NX5TnYFzezFaFQXYujkoeki+c+16b6FgDVVBafKWQQaHOOZoYiprO/8NOUNGvT2IHXkw3NA3e0wEU6qGwJH7gqfsbX2uwoGMI0nlax5gITqj6zuPh/bpfECaDFkdeoCypvQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by IA0PR12MB7506.namprd12.prod.outlook.com (2603:10b6:208:442::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 13:05:18 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 13:05:17 +0000
Date: Tue, 16 Sep 2025 10:05:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <me@yadavpratyush.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <20250916130516.GB1086830@nvidia.com>
References: <20250908103528.2179934-1-rppt@kernel.org>
 <20250908103528.2179934-2-rppt@kernel.org>
 <mafs0ldmon784.fsf@kernel.org>
 <mafs0ldmnlmq0.fsf@yadavpratyush.com>
 <aMgey9qEC_XUejXm@kernel.org>
 <20250915144335.GL1024672@nvidia.com>
 <aMhAiR6qnXMA-c8r@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMhAiR6qnXMA-c8r@kernel.org>
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|IA0PR12MB7506:EE_
X-MS-Office365-Filtering-Correlation-Id: df4325b0-8815-40bf-f7d8-08ddf521af1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6QAXnYJ5VltH6dWrNn69GeogfJf83gAIhn4BntYnr25UojYMJSWq0xRnWs/6?=
 =?us-ascii?Q?vWBY2hqQ96jyMdnvvh/BnHP5JxPaBn820Yna5acsskKAZNSwEnY3p1yg2HCX?=
 =?us-ascii?Q?IdaUOzJmohND+8M+gbMZiVByyOD+jpjCDWAm7izI5tebKrZwGk2dL9tph0ue?=
 =?us-ascii?Q?+sYPLwxADlk8NoG4p2B99+D4tG0BQMPvAQPZFyPffDKnxDUNPp+dk36bHIwF?=
 =?us-ascii?Q?KO9d5kj9d7m8v/p7KCsKCL6+Goki1YRvyyq92K786qnqLpfvgJqJSSnAAgsW?=
 =?us-ascii?Q?SmczCStAaAHti/7uXqu0sKIXLtapToPqS3Smadg2WvIZ890sxbvJ4bauF7dY?=
 =?us-ascii?Q?W9WDok3hu7ELhTV2g0lRt86iBD0PxXD6YxH1Ce1tsAt01H6itNuWvYyLd+eZ?=
 =?us-ascii?Q?d8E34J0fZflUZmvcLesqzVb0F2uMco5qr448mc6r1onR+d0zH7KTpxMP5YHa?=
 =?us-ascii?Q?tIVcrWnPfGaZPZ9VWxufbvNXreZho/HKSto+kfME3sE2cK5duz072ifUwZWi?=
 =?us-ascii?Q?ihfD+zHkjAfA1jcqJQgawj3JoDeSn7I7PfcxljVLw7X0y4B3yuiFsOVVqvw2?=
 =?us-ascii?Q?gp6HAN5UtBpBldOCqA3faLztKBbEg86vUdqJjLsNSb/SmigaBB+rmysfHtCk?=
 =?us-ascii?Q?s+9jZut5iXUB++42Ox2cPmsO6e5Z1bu1/b+CXZNdBAJyUIwzIPnVODOlyRTC?=
 =?us-ascii?Q?SqnFaknl7fTgORSiqEyFb4NSYJNQF80Vm1i7H589yitIPSn+m2SbC4fxyx+R?=
 =?us-ascii?Q?UBDAniI1Y9YUKc/qB4/y/4RiEjnLWiL4uQzki02/92MPTJ23jJP9+Jg0DG5A?=
 =?us-ascii?Q?k1WiDez7g2zqhpcebD8OireEW8iUNIZnRMDZPYNwU1M3Fg/QiNfnwbLs1ayM?=
 =?us-ascii?Q?kW+/sHeytBv4zn7NkfVxz1DVGyCx5NAPHIU/i7Yhmt6QhpvLppVSZTHuv2Hp?=
 =?us-ascii?Q?DfA+JdObgzR8t0zySR6u6sr5GEuW9SoV4k3a/GGUsmNba6YfZZeJ7YQlJ1/f?=
 =?us-ascii?Q?+WskcDaYYJQSQC5hBnm9fTJEyQmJzFdHkilWjoMqNFYr+cLEs3oJWihh6WJx?=
 =?us-ascii?Q?5xpHgJ3LKo/L3Lxv8pI+iE0PZ9C2kaDW9pMPEffXh8NybK8mjnxdTI6fYMXq?=
 =?us-ascii?Q?xwaobwtf8FifJMyv6EV3p+F5Lsyb1Rrpp1cMgyoaor/IzIQmuwA0XYmm6J1P?=
 =?us-ascii?Q?wbzxNWF31yGRrJAgpbS+Ddu5YHQxw2UWcGk9KRjSDkWP1Gc+DK+MiKWmbnJ8?=
 =?us-ascii?Q?xE+1eWpuh27KoWYJRC/rBmzP3XDulvw0fHlFXGne4KYfo4W5s5mbCh5ZImcJ?=
 =?us-ascii?Q?rH2I0dDWi8pgw+oi989t1ijmUEPQSSw7/EP+q+NLzhPULRf2FqTPoBnWApWz?=
 =?us-ascii?Q?kTa0VVi5UYlq+RuB7xSsd/i3FaKzV0HVYIE66RxVbcJqcjDjP73dtFegGc5w?=
 =?us-ascii?Q?cdaI/jI3Bmw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JBEdX8gV6cA8feLY4z1UN7G7rnl1lfIOCJscB/EGUQEIkCptCvuQm2eWWAhi?=
 =?us-ascii?Q?799yzXVgxsYR10+jZvdNr32J+OgpLZJl5Sd/8zsZVamShHeNcgfUxGxwPfkI?=
 =?us-ascii?Q?8TwueZgDZY+ZTY01zsXDtRwy3a5zmPaiEiSTvyPjDavRrA2LkyZK9eC4NKWO?=
 =?us-ascii?Q?QRoTGrn+lPQfSHg0Wj071E20JKJwuzEDQjsbCIGHK0aB5p0seA35kCl6Oow5?=
 =?us-ascii?Q?jUIoR/5iNrhLHIXx0x92S5N4jS11smxYMX0fh9hTrF84sS4ckYJeRevYoFOA?=
 =?us-ascii?Q?v4njsX/iFlK7/U5ny56OkZ+y6rnpvYPFp7flG3d27GoKE4wNIJpVH6HpG2/G?=
 =?us-ascii?Q?iuQDTQgy2SkATIJJxxhcbl02UDvrnayL8fXrnH+2vIxWjwZhRc6aalAjMShD?=
 =?us-ascii?Q?joYV0Dwk60sfiryY0kQkGoodO1Lf2NfGz6AjMrtnpHQdBtrpE06md2OJxcje?=
 =?us-ascii?Q?iqynkZDTgztksfXQHb3cv3f6MkmS2Om1fuZgbpTLWMz4wzHdgU17K+YjN7MB?=
 =?us-ascii?Q?dCRbafMY6YqZ8i7G4qm8JV3cDY6sU6VcUlPdSAqjt4CasoDcwiURlzuJULxh?=
 =?us-ascii?Q?s46Sh31nWCDdeOGnzzVEL70FRUgBP5sFy7XYA9ovXSRjxmoVyqaLlHXd0+Xw?=
 =?us-ascii?Q?sVPKirLGKO5irCNttCGfiK2w4ePypyHVd2O2awtUX3LT/albVgVltAmJkxtJ?=
 =?us-ascii?Q?kk+EnJfwm5Ao2kZYKveLsgqzXWnHYtGUfvLOWyrj9qL2PlmHrb5jqAo5ZsFR?=
 =?us-ascii?Q?TWsUuRDIh5hYJbXoUX0cvcIuyIcLlpPpPWD1jIL0GJ4/JiGjQNLP7eo8UtaT?=
 =?us-ascii?Q?5M43InBBu4UNK1GG9ckDPM72yNLjyeoFutedAchaKEwSyLvX7MiR0xcP4wKy?=
 =?us-ascii?Q?tI15APhwZkix/pRQf2tKNxaB/5OoBuXIZqyA/RHrD9v9qG4Q/Rean5q71dMl?=
 =?us-ascii?Q?vnU8mI/1lBYt3VM24N1f5Ni+s6VrAa4HZmxdM4qUQHaf31uTiAPkns7KNghT?=
 =?us-ascii?Q?eQQjNH0Rnf8m5mtPTCWoPO3P0g+mdfMOvuV8cqyzqI1fL0D6sZ3HqPAVTbaM?=
 =?us-ascii?Q?u8Um5kxpG4uAfmeadCBnH7c27Y/AzbOLvQeWCZF5p47mP4Bki51hFYnmiUnd?=
 =?us-ascii?Q?5soi57IBiiwq5aANojBjlkE7cCj00NgHjLHvawbW2pk7MLM/JBy1gNmZ+VYL?=
 =?us-ascii?Q?3czYSL82PdMypIzLbk4Rgca/L/F6fc9eU884bf7srkU+2cmGDDKU/xAU2TIC?=
 =?us-ascii?Q?zLjVikn5k4u+qoBAqOI4EXO0/hWanzdR5D/NRq+49EoeCpcTodVp5tUf2E8Z?=
 =?us-ascii?Q?XWJKjticiac6AMrTUt8Wv3w+8CGL9ZeeSjf3VW+ODkH8FWsoDfJCEY/VicvL?=
 =?us-ascii?Q?6DgN7/XLNWH/c4+2pVLb98irbmCZBF61nF7u3wJhVVx471v6dk/hHe2Pecz2?=
 =?us-ascii?Q?gRE9eYN5en0Wi3KdP6ERTCauATol9W5Zan34t6UEXIHmt1AfsNqEssSSwifz?=
 =?us-ascii?Q?c3mFe/LokwpHfV3BjdQBp4nUJKz+wj5oJu1G4ran606ppJFg5XQdPpeelm0p?=
 =?us-ascii?Q?noqeexUVihus5SpVn8OYxz8kXhWU5vXdoyPIrLuk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df4325b0-8815-40bf-f7d8-08ddf521af1f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 13:05:17.8897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlkLrwnNc7fJ8DtZtyYWmb/jBzTJ/r6zkUv4dafOAIVTmYVfUrLhnbwe96de5no7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7506
X-Stat-Signature: oiz59fzqsnaosa515e1mhtswgm1qrif5
X-Rspamd-Queue-Id: DA849180004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758027921-741745
X-HE-Meta: U2FsdGVkX18Moqg1R1tD/uDEipUD2fsfobYZBXAJjQPpVby1ahYXw21eEqoTMdfH8MAMl96UKmQjOZOQ/N17/BBWa8817IbTEKKhD/p3r5yfK344JzHTU0S1SK+kZcFd6JJ0bh9U6T40AcdBvvpcKlFoShMGSYn+WA/idJy0oNgEVX3glxS1+bVl4WaM26vNCajDaokl7RsMEcmB8ROwMRMYrNssxwNSa67ntWmKNcp1oFzGsZxLrGIcQU0e51SykMmU9lQKvDez5S3Ke2EAcc4z9/QbFe2viJGPF6XiR5FX67klESUuALXtbIGrUlbp90LZM8mfog/DKK3pIf0W7ZY1+Czfma88O8BrrZ9g7aR28/pT2mSLtHd+kG/KNM3f0ywkMwdsyAa/LntXVlott5v2o0PRM4Rxb1bDEWPDZ5VILqujNI9AYnEZxLex8J3OJkwzb8qin7XeChl6E/hI+AWhEgCvfqXBxTc8COXfH81KOGAkfjkGCbEJ9uQZqEVzFyiXZw+5asL96fGWAVpcURoxKKmC2g2eXiCPCX7R7jYu/y6poNhNijjA1s1Tk9Gu7nZLuzKWHcDeltLDmbc+ClQi+bgEn3Q9PeYtB12ysDH8EM2CMo5CTm3gP1dVS5duiHO+5hr2cNTHzdRnlNX5JRxO3+N5bvUFT6Aa182HDtq9pNMH0CsmtZDE5LN5oHSLIT6a2lg+lPdLxkOUn9o8zD5NYGDJ47k3QE2yRhIbKzk+yFL4EIQlfXX3GTTXoMWf+SxX6TH/6XSQ2nwNi0IAA0em5Cooh5jK+MFiI9OwuOQdLTsoycgd+xzrRj4seJIVlun/exoVEv15Fo5UqNYLV9SoY1y1OYTcVs7T6TSXEUmzc6iArKdl/Gzvw63sAnrOAJxVWfY1daoD0YVB+gJ9sM0fjM3KJveiQpUmZvBd4J5wVUqBrAzHww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 07:36:25PM +0300, Mike Rapoport wrote:
> > Under the covers it all uses the generic folio based code we already
> > have, but we should have appropriate wrappers around that code that
> > make clear these patterns.
> 
> Right, but that does not mean that vmalloc preserve/restore should use the
> public KHO APIs and avoid using internal methods.

I think it does, the same way vmalloc is layered on top of the buddy
allocator. Why wouldn't you build things in clean understandable
layers like this?

Jason

