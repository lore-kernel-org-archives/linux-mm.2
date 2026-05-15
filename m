Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8863BCD4F42
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 03:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B610C6B0005; Thu, 14 May 2026 23:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12726B0088; Thu, 14 May 2026 23:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D99F6B008A; Thu, 14 May 2026 23:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89A546B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:08:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 297B3407A2
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:08:12 +0000 (UTC)
X-FDA: 84768170424.29.9E6596A
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012034.outbound.protection.outlook.com [52.101.43.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B00540009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:08:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=Ch0Cx9p+;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.34 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778814489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMXmuqxxU5odHBiXnhSu8NBKyP37oW9HNgvkBeS4MwQ=;
	b=d8WahWqalccs0zvvRCESOvnux1ehRzq+Xj0g4Vwc9VaYt6hmzBOQxptCVEtL7gGudU0tvZ
	/6s4INrAtpGyMpWq/xNSZSBVomygtQLR8KyPDsMgh6xqCnR9Mw5JmOKXGPxZ9NXXYi2sbB
	6JEXOEtFemfHnI/NYdclO25JoI8YR3g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778814489; a=rsa-sha256;
	cv=fail;
	b=pOT+nj1GV2D4XWtQSrZ24+IheKx5FEB3B2wgoI9aaabowyV8I4MUjhl7LSxvBmxBMEhWzf
	5h2Ql+No9SdxyZfVi6Q0A1HMjWKCgaaUp2QDHSGSmN250qf867xNWPaN6lnelPRrMB4+xK
	7SC4eP46KFm/3Cz1ZCddLnW1byK0pJQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=Ch0Cx9p+;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.34 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lA58MJ2dHeq6HIL2Qfpj9MkiiL27/76wP6EgX0Ie24ndUTPXgd21yLGmNQ1tcRCm4wS89MTOoY3l/ZUmshTIvTjjriDbpHG4Tw3gP1WQVVJFatwbkUqSp88zAKVl1LdYGUH8EzS+n3qogOtJ8F94xF6FEMKAsfayiabWZHpijhb3DKuH0WmgcZRgA/o/cpEEqB/YTPvkEwVyj+9qx6KdTPKRibYTbWsW9UIvLSIAu2SloGuPlll7CgqqtCiLaDjFgUQ2eIcebipETTW68L8vCQkN/cpeNLWYIL5M4EzepqrJe4G8i0GZWOeO/TK58LFaeXzjFYvkn8Hnc6E9rPv7sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oUOH4oh6VU+tUOFfjWE9+VIX/tjZisMQuMWOFTNmQ0=;
 b=il6v4L/ePSx6Sf7sBuRqIYNcgUd2bEdwnATBreUoVLxtILv66XWFqzjZQa4QBJzhiK6uTgrZfFW/KYqsJHZxT193cLW9eUdGZb5T5PfNPfRc+g4KnCxnv0dE5onuVzO0Pjey+j3bX2cDvz9dW1MbUlZk6gr1MOzGrCBaDZ9sxxue7krxE925rPTtlxLRrq9gizgzZuRZt08OmdZ7WRIoHFASyTopLETLICkmaYRan0Gcv5U9v/ywwzarp/soclrwuBkYPFpbaUfsHY00vtMDTpq2hgMdpbVHXec4xm/SsmO64ojZM+01ka2uqgsQ3SQjfMmLMPILGgPbIDGhMf3d0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oUOH4oh6VU+tUOFfjWE9+VIX/tjZisMQuMWOFTNmQ0=;
 b=Ch0Cx9p+tfo6UBvoH+n+4l6GbgMxJVx6lpf4ahAkLf5YCLD/KXwL5u3heUVUQozTMmEvpDEjCZwSMLq0VXcWx3E6JMz1V7WncNxICapDUYBNRzSsKZa0SAH21janK1CHmX+VIsnauHdlqfE9wZybztSU9aEN2/kVCZ9RRGWw9c96q919+2FCFFKoFWchlr0aPmd2HUSy2P0rKNPPnJ4kdARI6G2TZoyvQ6FZ1pnQv2eguPlCrOyp1nrcBHmsX+797/5/tHULAnYq7BiPMDjsECPVwNUkAdnONGoDByuVf+TPOC4AUBAkNkGbfHyTe/iMRn9xm77TPLtMDMt0t3OG/Q==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB6833.namprd12.prod.outlook.com (2603:10b6:510:1af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Fri, 15 May
 2026 03:08:03 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0025.016; Fri, 15 May 2026
 03:08:03 +0000
Date: Fri, 15 May 2026 13:07:58 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: mpenttil@redhat.com
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v10 0/5] Migrate on fault for device pages
Message-ID: <agaN29W7hAklrCxz@parvat>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260505184421.2324798-1-mpenttil@redhat.com>
X-ClientProxiedBy: SY4P282CA0015.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::25) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB6833:EE_
X-MS-Office365-Filtering-Correlation-Id: 17b55e97-8714-4565-eb40-08deb22f2d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	oWgnfpmli8h5fQW3f33yYHFaOcB56EU7kPxnPfPupv8T9OjMPfst+gphVruaSUTQQyuJ4Bq3RSfFvcgxtqPu7skSZiV7wfYk3x20fslWePqsdJF+L8Glh4yL0vQPjyP7u++DEy6cUWV6hGxLCVCQd3BzQp3BlIx/GcmwRP/ubsOkeBT84By/2m3d49rxJDbGdJJysOSiqnGzJQ/05y1vVRVy9NaiWdH2Q5VWpi5YhB4o3Z9d28a3SsFm2RWGOMCUPdYbAnS9jGkbaCNckAVYdxN1BwCKqzVISfMBf6nVTYDqz4RQKm2QUQMvTJ4gSnhZSH5cenGlmTuAW83Waq02CaDFOQgvl6krC9P8DNvAhPVSS+XEaE6vUP8H6UNFAsxftnGVqE/fUaUDXHPuUCgMHtaGbIbo5GAHtShyZEKthuX6n4DfpV/CvhxLqSkIx7X1xiAi0rR8Cz4M+z/Lpa03HDPmQPQLz3hfFhZzgD/2mZGc0Olx6CGFL2VF1HaQZOgYzWXThXVCMYdtF9iORuSgWt0/jwFtt6Jent2gm5g/QMpYdNM944uWZVgQ/VqGBD7oQfroWkUpLn7ICPzPgQaNrKJFif8GiUnX8KzQ2+WI4kgwRnxRaZeViKw5u9CwizlLl6PtUiGHICdDLQQ4DqDwlJ5E83WRMG+1yyP1OV8/QpezVOgor5xiV/h8K2/Bq74urOPYYktVllXaCCCqqbCCIg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?ECqk9tvoawPQg99jGD5e4x7gWwQ21/ZrvHaSMFGYxBiDzYJ1x2TuJtvEy2?=
 =?iso-8859-1?Q?VjsVz1QUvYK9uOTZYgMo5rCQ5a9AmJrJtf72x7wnIdHaZ9sUvrUPvt2P9e?=
 =?iso-8859-1?Q?ZPq1zyJy1O498+pD5IOgNtgvBLYxQex3ZqP7XvPSnjn037MH1IXFXcXPGy?=
 =?iso-8859-1?Q?yilqTQ9yivAWGmS+qB2CtU8S+7qT/j2kKYL8R0/yqea1b4QIrH22KPdFEH?=
 =?iso-8859-1?Q?WO/hWVRA+g7TeqMeswjBxNMDTJ9OkSQliLH2RoTCBoyAESP0dpurNBlVIL?=
 =?iso-8859-1?Q?A4cxikLplz60fnPgTGNwqHZFZu9ZSznWbBZ7BTrm1jur5uTh/OTZ0Ix3it?=
 =?iso-8859-1?Q?5AXkxqAjdzFUlsSgp416WQzNyt4Lq5EvQBOwqO3BrjlTuSdOccIPnK1TyT?=
 =?iso-8859-1?Q?XSDP4tgLNATap2GMtTpmGblbubV1+RuIuWiG/jr/mqnRmSFTyCbgD9O5dN?=
 =?iso-8859-1?Q?vtLSzuUTw5urdt0O7Ov0RnfV5TRrETZxrRPKHyivc6vC1oKU+3hUxyejCZ?=
 =?iso-8859-1?Q?4H27WZblpnRORXzwyJ0Hy1w5Rsy9JZi/K0cC6Jg4I1QI9Ub4sDXqce0CzN?=
 =?iso-8859-1?Q?zV+HKM/EIuHPKbpKctetGngH3mNLj3EtLWLaYvOiw2Bsv0wg+Re7AFAuLV?=
 =?iso-8859-1?Q?B+R/lb3SVpP5i1Ku5r7ZBxB+FQN9B1qFC83PJPAw2ZloFG6vn8JZ+lccfm?=
 =?iso-8859-1?Q?S+SNMg3ag0RQKnjtTCrpnNd1uniYm90B5P07MxfSCMHVY5m4A7D0/aohmZ?=
 =?iso-8859-1?Q?SrM6T0SdaoK5QIjQ7ojCdf8Ytt5u69UEANQQ3SvZh3LSlx/di03DHUCM1f?=
 =?iso-8859-1?Q?lu6PezKE2RBvA0rcwM6EzBtjWxTAojlsc/KdqrUjsaQvZzeIeTWfpBCAoI?=
 =?iso-8859-1?Q?T9W2R4SAdXsFzwU6mueRbmKZs9gPwHEfVGJ+hINGR3tj5Gm1Om8RAo4nxs?=
 =?iso-8859-1?Q?Y+qPLAxS668wMpIX4JcUkgNu/T8ZQ1tY+gxXVopXXkkvA11kVqCQwVlq0/?=
 =?iso-8859-1?Q?P7iN0m9U5VjGWIhBZKEVhGonaMQFRyOw8FGMJXOwmHjZXeYyLZk6XLfD/9?=
 =?iso-8859-1?Q?328GtjLKn0LNwnTdpV5s4JsjwlfaZDr3QHgeXHvvjPd6nAW3mFezJa/vf6?=
 =?iso-8859-1?Q?mAZ4Dlg7pniHiIKJHxXqQ2OBmTey7/CWyi8QJQCf11SBNz0ABbeUaOEvB/?=
 =?iso-8859-1?Q?ZPcPiQJJsHjbe5n7rPIdLO6UaWaJofjfvkO+3CKxwIMVH4PznLoMddx1pn?=
 =?iso-8859-1?Q?mB4hObJQOrLNYljMzUEmysUR6KCIllu7UcBGkmGGILCFPsSakRXctJRoGQ?=
 =?iso-8859-1?Q?sO8QemeVCt940XoirMdlNbykO1j2fbZCnknopu0ET8ZmA9v0hVa41F39JB?=
 =?iso-8859-1?Q?6KYKmwjXc56CjlXUYpjuT8WuqrFtCW52XUROS2vIqBIvmqOohXzYIdnUOK?=
 =?iso-8859-1?Q?2Qlvc+0jGMb7UIhkRmWyU84TjpjT1XdR42fME6zsJMyFG3im8LxSpmQWpC?=
 =?iso-8859-1?Q?z7SYcXtw8hP/DL3Kk6HjuLPw8Eow6HECQRPmSm9NirPykLBxgq7BVZkmCl?=
 =?iso-8859-1?Q?JST1jI+X/vr9ceSsyu9nBgVujQv3I1jBvfDKQZv0Ygw7CHnhhTzJTNydtA?=
 =?iso-8859-1?Q?RE3LfjiAXjd69IxSvTO4Inv+WqdCqHHsSrSa+k+Vnv6/RXf0Ga+0A776fE?=
 =?iso-8859-1?Q?nvK4M7uf2qlSnlA9aKmA3BU2F7bOF2x4mrJYVIIqueytSrAoWqDRmN9VZL?=
 =?iso-8859-1?Q?Y1DI+r81KVRiJAdzJ7e1KSXqfgWuokrDnqdpfywQx6i3rDPNvo1vq0O2av?=
 =?iso-8859-1?Q?GjBgHB1ySw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b55e97-8714-4565-eb40-08deb22f2d43
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 03:08:02.9669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WW42m4TZW8a49l3AnjqKIwPb6qkAT0GtG+HZftCmWwrVAYsl8eg9jufuI202J4zXmwv+Q+OutPLpEhOS15IJtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6833
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B00540009
X-Rspam-User: 
X-Stat-Signature: 3wdp79ghdmwk3tfs8u8y8sk9ndpc6tiy
X-HE-Tag: 1778814489-130583
X-HE-Meta: U2FsdGVkX1/6vNLOtL6bCddz02MMOY/O4yQjzQt759NsM8ZjHRQevqfXG3Sq0CSdMjclLgmXiZHnR+N8lAkFSu1gCO4Fkc+FfDkTjDwT/dD+r/U6GSSVt3xyo2OdqAMjUX/1Wqdfq6phG2OV+DGPsyp8/VBU2MOoUfJ7aJVWJpt9OiqdZhMO/Cdtdth5u2T2Lzq2QhK/eyd3fqYblpeOyj7KWV1WDNtN8CrwYEaQJaLrtvg0bG2Dg1Q+JJNnSgCDOmB411+Z6xUyH6nKTnmhTSwXnubpvSpYmBE7cywCD+OeJaf8C0glUacY3YHX29qeHBgR4UarCv3jEKGbp9j8lbMKn3Mz3CbHovBYaZKii2tJ7l6xdZzCmU9wWOwvTmRjsv+ffw71k9qpIo/IIzej0llwtrGEihz8XYSHZlAhpwHqskDOtj9V+iBOoaEmmfjSeSZ15wfDVjAndAliEQCJO3xkMhEdiJddyjbmmreQQerqaKeVx/wv4lpZM98OaBM0uRfz3hutgt8BwlgOsNEMeRz5ZZ7z/GaZSjpI5jsbXraUPSN63/mEHRFk6U1OHQvSD8wSNepLX+NA8RV7zYbqTJ7NvRNVhrHvyWlJoUdJkXbT884seGRZjGZjHvGUg2JzulJRq9VYtA7b5vCormkUqISTNUkFVlNsl1JQxfUo0wakY89/h+77jmYgMhy9F/SzJ37W6vo96kqTbhK3MW8vaU1cFtWAn3uJN9OKkZVC9P48DaK8vOdqgerHneyiuLif7v71mnepj7vJX1pZdo1PytCO25GYoIv2LRx37F3+D4hbHTnSn2Atmb0Tu5HVMdM+H4vKFeQTqOzYCo6GOjJz3Hbr1GAaxehWTOfFQU9/ZjXX+mtztj58suppTEIqXfHXozu+A5UprHAqyNWohliJii6i7ZwOchWzGIIjwuq8zLahT0mzWqr7+d2OdJ0rolCVtleLNDqmNXA8/rTRYR6
 9C82cD26
 CTDGmeNzH5TFgV24mE2OdgtqBJ9e2Sy4aYhBKH+OmLNhbTUzTI6nVsN3xY5G4GavTL5EokHibyTzXHI1tDIQwsC5b7Q5tUZ3CQB/mJFjsXKDMYzyEscp0HysOW6IpuK6gTlssYsObCWTUI246TKwAykJn6RZe0IQTCqPQDJHkxbTEu9LRsQpjLcD0zcBkBVG9LzZeNMBLBh23ss0NUZHG614e2B/AkjijAjbyNU9oveoyvrXespK+9SewqaRhP/rQBP0KWgybrPA6aJqbX6ciMESNIvsz9r3VAuCYcgi2/dGpVIceXLSCED4UhpElesmLN6BuoIGXBKp2RAdAe9YFd8ZWYnH/lvH2vDkCHd1Pcy1b9XoFQxYQT4prDBw19JgwzJNPxg9l2RNl3OnHcMvCMmy0Nk7t5XW4BQoanjf+C79lrh6ZoAENwXGmv/4GJrZFC7SsUi8rQCLMGnKGs+OiTGyz4+D4NYCnYUMb8UFvCajF3j+bFSiuaE08Atir4tTDHaYgFPN4Z9zOSVnneKUNELlO5cSsEz6ogdhu2LZ9YLG2hb7JvS/FKEPU3mT/ruOS+ZOgVMwMlom2hzR7ptAFV011qlCIdV2GoI+aHBfI/L4WaO9NKXI/c2T/7wIj6S/htq0jH4/CpqWE2rRg0rCiDtQC3242oJL7johYdZp3raZtOeppcAKyQVeFIODE8ctd9XD6x9y3t1cIj5j5MEZMhJBA3JKxO+MqJbvP/4nIJX3XAv2NTmnqY+fOAfqxRblDcJlTX/g4+YjcbvDOSyK3+5x8dM+lhIMqsTw1El0E2k4cLzr8g7/ybk03fVs5bZ4hRKnsGeVZfRqzE3CvjcEbgrM9eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 09:44:16PM +0300, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly. One page table walk
> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
> 
> One extra benefit of migrating with hmm_range_fault() path
> is the migrate_vma.vma gets populated, so no need to
> retrieve that separataly.
> 
> Tested in X86-64 VM with HMM test device, passing the selftests.
> For performance, the migrate throughput tests from the selftests
> show similar numbers (within error margin) as unmodified kernel.
> Tested also rebased on the
> "Remove device private pages from physical address space" series:
> https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
> plus a small patch to adjust with no problems.
> 
> Changes v9-v10
>   - Fix for issue Intel CI found, forgotten pte_unmap() before
>     migration_entry_wait()
> 
> Changes v8-v9
>   - rebase on drm-tip
>   - fixed uaf around  migrate_vma_split_folio() usage
>   - added missing pmd unlock
> 
> Changes v7-v8
>   - rebase on 7.0
>   - fixed subject in two patches
>   - enhanced commit messages
>   - squashed patch 6 into patch 4 to fix kernel test robot warning
>   - readded dropped Cc block from cover letter
>   - fixed white space
> 
> Changes v6-v7
>   - rebase on 7.0.0-rc6
>   - added documentation and comments
>   - denote to be migrated zero page as HMM_PFN_MIGRATE alone
>   - got rid of HMM_PFN_INOUT_FLAGS movement in patch 2
>   - picked up Acked-By from David for patch 1
>   
> Changes v5-v6
>   - rebase on 7.0.0-rc4
>   - use range based TLB flushing while unmapping ptes
>   - gate migration behind HMM_PFN_REQ_MIGRATE for fault and
>     migrate paths
>   - always infer migration flags from migrate->flags only
> 
> Changes v4-v5
>   - rebase on 6.19
>   - fixed David's email address
>   - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
>   - refactored into smaller commits
>   - added more comments to code
> 
> Changes v3-v4:
>   - rebase on 6.19-rc8
>   - fixed issues found by kernel test robot with random configs
>   - fixed typos
> 
> Changes v2-v3:
>   - rebase on 6.19-rc7
>   - fixed issues found by kernel test robot
>   - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
>   - fixes to lock handling (pmd/pte) on errors
>   - added assertions for pmd/pte lock states
>   - other issues discovered by Matthew, thanks!
> 
> Changes v1-v2:
>   - rebase on 6.19-rc6
>   - fixed issues found by kernel test robot
>   - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
>     parts if migrating
>   - other issues discovered by Matthew, thanks!
> 
> Changes RFC-v1:
>   - rebase on 6.19-rc5
>   - adjust for the device THP
>   - changes from feedback
> 
> Revisions:
>   - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
>   - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
>   - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
>   - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
>   - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/
>   - v5: https://lore.kernel.org/linux-mm/20260211081301.2940672-1-mpenttil@redhat.com/
>   - v6: https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/
>   - v7: https://lore.kernel.org/linux-mm/20260330115611.347988-1-mpenttil@redhat.com/
>   - v8: https://lore.kernel.org/linux-mm/20260414041226.1539439-1-mpenttil@redhat.com/
>   - v9: https://lore.kernel.org/linux-mm/20260505051658.2219537-1-mpenttil@redhat.com/
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> 
> Mika Penttilä (5):
>   mm/Kconfig: changes for migrate on fault for device pages
>   mm: Add helper to convert HMM pfn to migrate pfn
>   mm/hmm: do the plumbing for HMM to participate in migration
>   mm: setup device page migration in HMM pagewalk
>   lib/test_hmm:: add a new testcase for the migrate on fault
> 
>  include/linux/hmm.h                    |  19 +-
>  include/linux/migrate.h                |  26 +-
>  lib/test_hmm.c                         | 101 ++-
>  lib/test_hmm_uapi.h                    |  19 +-
>  mm/Kconfig                             |   2 +
>  mm/hmm.c                               | 836 +++++++++++++++++++++++--
>  mm/migrate_device.c                    | 583 +++--------------
>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>  8 files changed, 1067 insertions(+), 573 deletions(-)
> 
> drm-tip
> base-commit: 94d56a898a2db27f841b17f6966a81ba502fe63c
> -- 

FYI: While testing with hmm_tests I ran into

[  107.866004] ============================================
[  107.866284] WARNING: possible recursive locking detected
[  107.866577] 7.1.0-rc3-00311-g4277273ca0e1 #12 Not tainted
[  107.866877] --------------------------------------------
[  107.867217] hmm-tests/1098 is trying to acquire lock:
[  107.867491] ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_range_fault+0x147/0x610 [test_hmm] <- line 368 of lib/test_hmm.c
[  107.868076] 
[  107.868076] but task is already holding lock:
[  107.868383] ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_fault_and_migrate_to_device.constprop.0+0x3aa/0x6a0 [test_hmm] <- line 1267 of lib/test_hmm.c
[  107.869076] 
[  107.869076] other info that might help us debug this:
[  107.869415]  Possible unsafe locking scenario:
[  107.869415] 
[  107.869729]        CPU0
[  107.869866]        ----
[  107.870054]   lock(&mm->mmap_lock);
[  107.870247]   lock(&mm->mmap_lock);
[  107.870436] 
[  107.870436]  *** DEADLOCK ***
[  107.870436] 
[  107.870743]  May be due to missing lock nesting notation
[  107.870743] 
[  107.871158] 1 lock held by hmm-tests/1098:
[  107.871377]  #0: ffff888113571b38 (&mm->mmap_lock){++++}-{4:4}, at: dmirror_fault_and_migrate_to_device.constprop.0+0x3aa/0x6a0 [test_hmm]
[  107.872081] 
[  107.872081] stack backtrace:
[  107.872348] CPU: 1 UID: 0 PID: 1098 Comm: hmm-tests Not tainted 7.1.0-rc3-00311-g4277273ca0e1 #12 PREEMPT(full) 
[  107.872350] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20260213-6.fc44 02/13/2026
[  107.872354] Call Trace:
[  107.872357]  <TASK>
[  107.872358]  dump_stack_lvl+0x5d/0x80
[  107.872385]  print_deadlock_bug.cold+0xc0/0xe2
[  107.872393]  __lock_acquire+0x10cf/0x1b90
[  107.872400]  lock_acquire+0x189/0x2f0
[  107.872401]  ? dmirror_range_fault+0x147/0x610 [test_hmm]
[  107.872404]  down_read+0x9b/0x4b0
[  107.872420]  ? dmirror_range_fault+0x147/0x610 [test_hmm]
[  107.872421]  ? lock_acquire+0x189/0x2f0
[  107.872422]  ? __pfx_down_read+0x10/0x10
[  107.872424]  ? __lock_acquire+0x3c2/0x1b90
[  107.872425]  dmirror_range_fault+0x147/0x610 [test_hmm]
[  107.872427]  ? __pfx_down_read+0x10/0x10
[  107.872429]  ? __pfx_dmirror_range_fault+0x10/0x10 [test_hmm]
[  107.872430]  ? __lock_acquire+0x3c2/0x1b90
[  107.872434]  dmirror_fault_and_migrate_to_device.constprop.0+0x3bf/0x6a0 [test_hmm]
[  107.872436]  ? __pfx_dmirror_fault_and_migrate_to_device.constprop.0+0x10/0x10 [test_hmm]
[  107.872439]  ? find_held_lock+0x2b/0x80
[  107.872444]  ? dmirror_device_remove_chunks+0x5b8/0xa00 [test_hmm]
[  107.872445]  ? __is_insn_slot_addr+0xee/0x1f0
[  107.872458]  ? lock_acquire+0x189/0x2f0
[  107.872460]  ? avc_has_extended_perms+0x234/0x1350
[  107.872476]  ? __might_fault+0x89/0x150
[  107.872484]  ? lock_release+0xe1/0x320
[  107.872486]  dmirror_fops_unlocked_ioctl+0x9ba/0xdb0 [test_hmm]
[  107.872488]  ? ioctl_has_perm.constprop.0.isra.0+0x2fe/0x6c0
[  107.872494]  ? __pfx_dmirror_fops_unlocked_ioctl+0x10/0x10 [test_hmm]
[  107.872498]  ? count_memcg_events_mm.constprop.0+0x22/0x1a0
[  107.872499]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
[  107.872501]  ? count_memcg_events_mm.constprop.0+0xaa/0x1a0
[  107.872503]  ? lock_release+0xe1/0x320
[  107.872504]  ? find_held_lock+0x2b/0x80
[  107.872506]  ? exc_page_fault+0x7e/0xf0
[  107.872510]  __x64_sys_ioctl+0x13c/0x1d0
[  107.872521]  ? lockdep_hardirqs_on_prepare+0xd9/0x190
[  107.872523]  do_syscall_64+0xf3/0x6a0
[  107.872526]  ? exc_page_fault+0xde/0xf0
[  107.872528]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  107.872529] RIP: 0033:0x7f7381c543ad
[  107.872531] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
[  107.872532] RSP: 002b:00007ffc3160a9b0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  107.872539] RAX: ffffffffffffffda RBX: 00007f7381b44000 RCX: 00007f7381c543ad
[  107.872540] RDX: 00007ffc3160aa30 RSI: 00000000c0284803 RDI: 0000000000000022
[  107.872541] RBP: 00007ffc3160aa00 R08: 00000000ffffffff R09: 0000000000000000
[  107.872541] R10: 0000000000000022 R11: 0000000000000246 R12: 00007ffc3160aa24
[  107.872542] R13: 000000000041f380 R14: 0000000000000200 R15: 00007f7381200000
[  107.872544]  </TASK>


Thanks,
Balbir

