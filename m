Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5CED116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 22:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E310B6B0022; Mon,  1 Dec 2025 17:14:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09006B00A8; Mon,  1 Dec 2025 17:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0C26B00A9; Mon,  1 Dec 2025 17:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B44D86B0022
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:14:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FA73898B5
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 22:14:33 +0000 (UTC)
X-FDA: 84172307226.03.DEEC6EE
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012039.outbound.protection.outlook.com [52.101.48.39])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74E53100018
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 22:14:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vEsJfSOm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.48.39 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764627270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TkyCpEpF2tt3Sa+XOp56SlXlO2gYBUrgkq/MfbDSdU=;
	b=u2y5AHuFP++N7HYsiWbDwqRZ21kaMp7A+hzIyI2ky0AmTJ8NJVOT82ePVW9IrD2c36mhHj
	dRlhRYqaOgZLXnOxKiZp4NI/q5S/kXoQ+ZQ+nGU2DIZXOOeJ/LOoCW54XdXRIOQPBbKXIx
	V8ihB+ISfrBakpMCMYHT6eLSxRhPuT0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vEsJfSOm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.48.39 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764627270; a=rsa-sha256;
	cv=pass;
	b=3FYoxarJpQhtxQdeiqrUBBVgy9+0oHJ7O7ljqGps/6+SXQyXTKCL7UAHXC25puhj6Ual2p
	o5ABWtXa9rB4zCs8rLTC/OaTc2COrXF4Ixh31kzkHBuzCMpFPUuf/6dGhrYwxO8tA2byOa
	8Js+YeZaK/N8bv+VIwqj3ePYWwLlHIU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NbFcNr60YEneFN16bE5/l1ZcoUBm50KAumFWXsIJbQ8YZ3yeOwUZLZTybCgHADflYx+0x+Ju+SM2TjIGHHiQbs4Iy8+J1xybdzduenXaRNHA7tLbGe4FtAhw9GYtpf4sLbkTF9FlqT2SSpD8bob8eST2stYbUNePHVzWbrkeK2YF/ONAe3P/4Tqh/dYVflIPovGFLNxxVV/F8or35TTmSoU73FX6kdHLNjWmaYzcpiec1CRwIlKy453N4EReUslKfJ+5hhDCPqdnJ/+c+jZOFkBTf/mTsnVvEQk9qM4dfRisKX+fwucUkwS4++Yv4zKPauCfyg/toglB7PFYEYnFLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TkyCpEpF2tt3Sa+XOp56SlXlO2gYBUrgkq/MfbDSdU=;
 b=jVG21cMp7/p44jGb7OkL5O1Txh35+eG9KOWfvFHDSCp3no3fIp1yt7b4qG48cwev1UZeJKkzppoQlu/8B8EMTrSmBEtPSZx3bFN6OymLBy7W5F8GCJ5KmBBskBwRQzr+xKD12naYZ/t6HF1MHOeppS0TxAqRg9PIeVp/OQYE5YbytP9tcB+WfyJgOaiFkU6NrZUZzvkVFqw/WRfTtCtCjvFumuYRRSaWAFlu7bhWK+pB/3C8CPsl/5dUpirJEZyYno19hTJfPfDgtSd8MyIDZzVat1c/13yBQZbZAET5MM8WL9mDWO90nGH1nsws6RZI6YDguehx4A4QX5QlNUBNmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TkyCpEpF2tt3Sa+XOp56SlXlO2gYBUrgkq/MfbDSdU=;
 b=vEsJfSOmIrKZOJ4fl5JAwBvmG81Sfox66I+8yKJw5xGJcDxOzUazBw6tOcS7BMhi7Zt3QtuL5OBVZ0ZPRrYlcQrxyg6ACforBcbNEQOUgdStHRwM/0FeMoQ/8bdgbRZAC8/fxJbhERRsOQ9v+8T7+LOtbvBsoRNiMNrolGErjoU=
Received: from SA9P221CA0029.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::34)
 by SJ5PPFCD5E2E1DE.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 22:14:20 +0000
Received: from SA2PEPF00001504.namprd04.prod.outlook.com
 (2603:10b6:806:25:cafe::cd) by SA9P221CA0029.outlook.office365.com
 (2603:10b6:806:25::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 22:14:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001504.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 22:14:20 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 16:14:18 -0600
Date: Mon, 1 Dec 2025 16:13:55 -0600
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20251201221355.wvsm6qxwxax46v4t@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001504:EE_|SJ5PPFCD5E2E1DE:EE_
X-MS-Office365-Filtering-Correlation-Id: ea11d7fc-2500-4c3e-c5a6-08de3126f9f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VfsQRpQruZkQdcorQyAzkAhsX8kwpsOBHVkIcBKMkgvHcRW9s4RtRIeu4D+t?=
 =?us-ascii?Q?MwrWVLEyXhcLRLHKI2ztKQemDIDYUxuYNe6NSvDR+frggr1n/Ulp39TfOzLY?=
 =?us-ascii?Q?NSb5Lry2Jlv23cQEK4PMzexUJvN2SxWsU5dTn0B5ZtEHakUbDEumLQ3o4Gx0?=
 =?us-ascii?Q?irhnNtmMrDzhV+Z36z1gMFAddLdK5HRqU4RnPfN5NUjwRW+WwtP7BGoyu5Sn?=
 =?us-ascii?Q?BoyV7aRg0RwY0lVGqkqH8lZmilOXibFWUh/tbX8u6JQ6kAQEXPbHQM1y/IOG?=
 =?us-ascii?Q?J8AzWkD3Z60KlrZwvsJszM7T79rid2NF0+Q1B2MY8aarWgN/JjSzuN9mcyNp?=
 =?us-ascii?Q?hgDw+d0IVuKKsjmKNEjTApXrELshtNYElaG0S0klQClTmoUTuoDNcc5MLgWP?=
 =?us-ascii?Q?AZB0L93BxhhATRfFZBO9zPJ+75IRKot9pA0qgL2J17TO1u+JkAgsDX5HD62x?=
 =?us-ascii?Q?hV+dAwS7lsvXqIj8zxHq7UtI2kQFoFhXQuMPNGsmSDh+XTIl6BZ5XYWMDxTH?=
 =?us-ascii?Q?ODStn1U8f7ZLMN8UHUECejc6smApEtuUUd70S5qFYgODApXhBDMiuYJtpPnG?=
 =?us-ascii?Q?cmaSNbY0qneOpqjavxesrVORS8gxKhENg6Aw8ICSY1f5Na9rr86x07odS6Cc?=
 =?us-ascii?Q?Bm5OAP5badq9fIvhr2INLoPJvKF3bsgNRe7i6XMm5u//KbDYrmyXqn1lSl9K?=
 =?us-ascii?Q?n0TU9gNL3YWVSrQ2xg8lrLROcy7lkmgeIwljJnDMg4MjfotYox9ftkAu3wRU?=
 =?us-ascii?Q?5/x2muF7sH/pdhcI/vImYRkvJqMZj51aAZJAjzlKj5g76/pvuW49MRvlsRZt?=
 =?us-ascii?Q?jyY0cfDV/cw/OA/GH8OuRqN+jJFGG75SD3ZmdGTNXvfkoxbXI+5K6c4JQ0/8?=
 =?us-ascii?Q?SZn+IIq1MkN5b115GC8B+ZMFnxggqdBYWLAwxXWt8j0ccR/KbUKXeX65EXPK?=
 =?us-ascii?Q?KyWtHbIRnRHEsvbmAhSluqpzqxS7ysYDlG6O6dhjRe1SJ52Jx7Y79zEdxrpY?=
 =?us-ascii?Q?Mgfi6BmVS3dnDueUA5HFvSg3uUmMGX62uaG/VA+iuDUy8+jfAAA526OiOjSa?=
 =?us-ascii?Q?tGZkcJYKqn+6RIuSJ/mfivBFfrEguZik99Oket39WoKFczpX0qbR9sfLxMhK?=
 =?us-ascii?Q?RYeYZBqkc4hkV/tEiu5xOVx5tIE55GGxINzy83L+d14leGN5Pl9VpVCDM3MN?=
 =?us-ascii?Q?vZ8uFzRkzgAtZtsoIJUQRC9JvOvu75nS4mF9fuxL3Rh6wSmfmnZTBemULIl3?=
 =?us-ascii?Q?p8VToR8nB4JsJDxkORu9TrZYP0KuBcrYMuF8JNqzPm7AwQOsiF8hTaz+L+rZ?=
 =?us-ascii?Q?wHDkrJ0uNdyoNEDJPMddU047jyOYNB4fCfklnRElVO1yK21mFksn48N3TDCk?=
 =?us-ascii?Q?uvYh3+PvDc9JaX66eBBXTX28NFt9czXf0HOo1kyBRM1JO8czkl1Uwn7Mhyb2?=
 =?us-ascii?Q?KeZF2AYjgFrIxX+Fw/BgxudT/TS65wrD7yxBaKp4DqpGzy/1dNytw4rKmD5o?=
 =?us-ascii?Q?NSKLFxDmBRo0pX3ILHYFLFe+pVEpoc23DXZe?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 22:14:20.4481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea11d7fc-2500-4c3e-c5a6-08de3126f9f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001504.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCD5E2E1DE
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 74E53100018
X-Stat-Signature: cgihj6ngk7rnkq6swcue8ez1bbxd7uiu
X-Rspam-User: 
X-HE-Tag: 1764627270-33074
X-HE-Meta: U2FsdGVkX1+MpAG550YQnawNCi7/y4R6jGEjl7ghz5vgUgqocqeiHmYlwWENIRPWGZxcQMaeBXnbQS/p+z4cQbwDFZei8yyX/4kosTvlx04sgWkzdxbT4cfIzVFsoI8QFqV5F/y44Cpyhy7iw0vXwX9aZGZun1sh2B7Pk7Kej6wE0CvMA+3oP2LngXiujHr9JMF/+fu/kQnX97GB2EEBOxRMJ1o7SJKM1qUxFclu2CUu+Y9fVCPBD+AQhRPadk4B/acwbpJ9SbWjag2bZkWYVAQPrB5mRdhIlo9ZzhOV4EsNOYzRi6SRTXjWsrTVU+aQxFU8HkOH7ysnBUsOQbzpWruJamyh/GYV4XH+GAc7PYSTxkIl34J//7Ad8ZM230HqDgPeYiinYOKH2Rj6ZR+c9nMy8bcT7GcYpsjEM+qxjfIHHcCwZTf56VCj+/Z2bD45UHAB/92ZZ8syABtTQjw69wSWZtsXW/Qzyw6fjJbZIm2Rf98zqi0vGZ1EvLYkpWpK20muL3J4Zmn73anZeFFc3U3qz8JsFaJoA9J7LZF4OPiIqRPFDIhYUh7dbh9CivUfflltnbt2peYD0PytkjqHspQ0WnVS9jRhb8KaKfZEhkKLLqs+V7T2z42KfNFDWYsbbv6maCQd1Sa/ABw7o5By0FNr7B72B58orX8RiTAskFnuZMiA6VxhthQBgrIZUR09MYp/jLWkEbfTuKexaABGzL9OLBQWAzNGwsz31QVqnUqgMKB/qJQ22ypjqWImGXcOtReDBo8nTVY981eX6duRBzS/C88xiZhCcwqYG6fg7VfgngqXoux+3JS2+oA6jFZDqv6VrWwkUTNmNcvyBmbfGW2XAn1grUDoJuBS67dSmLu7FSkAQ/oN5xglmWbDmt38bBzz9J8OcDKCTW5ev+4ZruQ47Y0nqABpEeMkaYbq42/ExDKw6cIVB0JAD3D9oElsxLQlzPC6Cc4fqy219oQ
 6ozwFouM
 cdOI3M564KmrdYdH0mYvCoSJ7ir2cRMkOf4Rb308Y9wmq/mxr4jfJaqSP6GPXR4NRlqnFCUMpK0kzX99vByqxA0LubJ0BGiRnIc4VcOLWedRm58wPQ3N3IYZrmuw3ke7VoZkz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 05:31:46PM +0800, Yan Zhao wrote:
> On Fri, Nov 21, 2025 at 07:01:44AM -0600, Michael Roth wrote:
> > On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> > > On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:
> > > > Currently the post-populate callbacks handle copying source pages into
> > > > private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> > > > acquires the filemap invalidate lock, then calls a post-populate
> > > > callback which may issue a get_user_pages() on the source pages prior to
> > > > copying them into the private GPA (e.g. TDX).
> > > > 
> > > > This will not be compatible with in-place conversion, where the
> > > > userspace page fault path will attempt to acquire filemap invalidate
> > > > lock while holding the mm->mmap_lock, leading to a potential ABBA
> > > > deadlock[1].
> > > > 
> > > > Address this by hoisting the GUP above the filemap invalidate lock so
> > > > that these page faults path can be taken early, prior to acquiring the
> > > > filemap invalidate lock.
> > > > 
> > > > It's not currently clear whether this issue is reachable with the
> > > > current implementation of guest_memfd, which doesn't support in-place
> > > > conversion, however it does provide a consistent mechanism to provide
> > > > stable source/target PFNs to callbacks rather than punting to
> > > > vendor-specific code, which allows for more commonality across
> > > > architectures, which may be worthwhile even without in-place conversion.
> > > > 
> > > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > ---
> > > >  arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
> > > >  arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
> > > >  include/linux/kvm_host.h |  3 ++-
> > > >  virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
> > > >  4 files changed, 71 insertions(+), 35 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index 0835c664fbfd..d0ac710697a2 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
> > > >  };
> > > >  
> > > >  static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> > > > -				  void __user *src, int order, void *opaque)
> > > > +				  struct page **src_pages, loff_t src_offset,
> > > > +				  int order, void *opaque)
> > > >  {
> > > >  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> > > >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> > > > @@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > >  	int npages = (1 << order);
> > > >  	gfn_t gfn;
> > > >  
> > > > -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> > > > +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
> > > >  		return -EINVAL;
> > > >  
> > > >  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> > > > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > >  			goto err;
> > > >  		}
> > > >  
> > > > -		if (src) {
> > > > -			void *vaddr = kmap_local_pfn(pfn + i);
> > > > +		if (src_pages) {
> > > > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > >  
> > > > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > > > -				ret = -EFAULT;
> > > > -				goto err;
> > > > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > > > +			kunmap_local(src_vaddr);
> > > > +
> > > > +			if (src_offset) {
> > > > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > +
> > > > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > > +				kunmap_local(src_vaddr);
> > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > > 
> > > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> > 
> > src_offset ends up being the offset into the pair of src pages that we
> > are using to fully populate a single dest page with each iteration. So
> > if we start at src_offset, read a page worth of data, then we are now at
> > src_offset in the next src page and the loop continues that way even if
> > npages > 1.
> > 
> > If src_offset is 0 we never have to bother with straddling 2 src pages so
> > the 2nd memcpy is skipped on every iteration.
> > 
> > That's the intent at least. Is there a flaw in the code/reasoning that I
> > missed?
> Oh, I got you. SNP expects a single src_offset applies for each src page.
> 
> So if npages = 2, there're 4 memcpy() calls.
> 
> src:  |---------|---------|---------|  (VA contiguous)
>           ^         ^         ^
>           |         |         |
> dst:      |---------|---------|   (PA contiguous)
> 
> 
> I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
> as 0 for the 2nd src page.
> 
> Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> snp_launch_update() to simplify the design?

This was an option mentioned in the cover letter and during PUCK. I am
not opposed if that's the direction we decide, but I also don't think
it makes big difference since:

   int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
                               struct page **src_pages, loff_t src_offset,
                               int order, void *opaque);

basically reduces to Sean's originally proposed:

   int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
                               struct page *src_pages, int order,
                               void *opaque);

for any platform that enforces that the src is page-aligned, which
doesn't seem like a huge technical burden, IMO, despite me initially
thinking it would be gross when I brought this up during the PUCK call
that preceeding this posting.

> 
> > > 
> > > >  			}
> > > > -			kunmap_local(vaddr);
> > > > +
> > > > +			kunmap_local(dst_vaddr);
> > > >  		}
> > > >  
> > > >  		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> > > > @@ -2331,12 +2339,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > >  	if (!snp_page_reclaim(kvm, pfn + i) &&
> > > >  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> > > >  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> > > > -		void *vaddr = kmap_local_pfn(pfn + i);
> > > > +		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > +		void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > >  
> > > > -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> > > > -			pr_debug("Failed to write CPUID page back to userspace\n");
> > > > +		memcpy(src_vaddr + src_offset, dst_vaddr, PAGE_SIZE - src_offset);
> > > > +		kunmap_local(src_vaddr);
> > > > +
> > > > +		if (src_offset) {
> > > > +			src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > +
> > > > +			memcpy(src_vaddr, dst_vaddr + PAGE_SIZE - src_offset, src_offset);
> > > > +			kunmap_local(src_vaddr);
> > > > +		}
> > > >  
> > > > -		kunmap_local(vaddr);
> > > > +		kunmap_local(dst_vaddr);
> > > >  	}
> > > >  
> > > >  	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index 57ed101a1181..dd5439ec1473 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -3115,37 +3115,26 @@ struct tdx_gmem_post_populate_arg {
> > > >  };
> > > >  
> > > >  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > -				  void __user *src, int order, void *_arg)
> > > > +				  struct page **src_pages, loff_t src_offset,
> > > > +				  int order, void *_arg)
> > > >  {
> > > >  	struct tdx_gmem_post_populate_arg *arg = _arg;
> > > >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > >  	u64 err, entry, level_state;
> > > >  	gpa_t gpa = gfn_to_gpa(gfn);
> > > > -	struct page *src_page;
> > > >  	int ret, i;
> > > >  
> > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> > > >  		return -EIO;
> > > >  
> > > > -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
> > > > +	/* Source should be page-aligned, in which case src_offset will be 0. */
> > > > +	if (KVM_BUG_ON(src_offset))
> > > 	if (KVM_BUG_ON(src_offset, kvm))
> > > 
> > > >  		return -EINVAL;
> > > >  
> > > > -	/*
> > > > -	 * Get the source page if it has been faulted in. Return failure if the
> > > > -	 * source page has been swapped out or unmapped in primary memory.
> > > > -	 */
> > > > -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> > > > -	if (ret < 0)
> > > > -		return ret;
> > > > -	if (ret != 1)
> > > > -		return -ENOMEM;
> > > > -
> > > > -	kvm_tdx->page_add_src = src_page;
> > > > +	kvm_tdx->page_add_src = src_pages[i];
> > > src_pages[0] ? i is not initialized. 
> > 
> > Sorry, I switched on TDX options for compile testing but I must have done a
> > sloppy job confirming it actually built. I'll re-test push these and squash
> > in the fixes in the github tree.
> > 
> > > 
> > > Should there also be a KVM_BUG_ON(order > 0, kvm) ?
> > 
> > Seems reasonable, but I'm not sure this is the right patch. Maybe I
> > could squash it into the preceeding documentation patch so as to not
> > give the impression this patch changes those expectations in any way.
> I don't think it should be documented as a user requirement.

I didn't necessarily mean in the documentation, but mainly some patch
other than this. If we add that check here as part of this patch, we
give the impression that the order expectations are changing as a result
of the changes here, when in reality they are exactly the same as
before.

If not the documentation patch here, then I don't think it really fits
in this series at all and would be more of a standalone patch against
kvm/next.

The change here:

 -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
 +	/* Source should be page-aligned, in which case src_offset will be 0. */
 +	if (KVM_BUG_ON(src_offset))

made sense as part of this patch, because now that we are passing struct
page *src_pages, we can no longer infer alignment from 'src' field, and
instead need to infer it from src_offset being 0.

> 
> However, we need to comment out that this assertion is due to that
> tdx_vcpu_init_mem_region() passes npages as 1 to kvm_gmem_populate().

You mean for the KVM_BUG_ON(order > 0, kvm) you're proposing to add?
Again, if feels awkward to address this as part of this series since it
is an existing/unchanged behavior and not really the intent of this
patchset.

> 
> > > 
> > > >  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> > > >  	kvm_tdx->page_add_src = NULL;
> > > >  
> > > > -	put_page(src_page);
> > > > -
> > > >  	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
> > > >  		return ret;
> > > >  
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index d93f75b05ae2..7e9d2403c61f 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -2581,7 +2581,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
> > > >   * Returns the number of pages that were populated.
> > > >   */
> > > >  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > -				    void __user *src, int order, void *opaque);
> > > > +				    struct page **src_pages, loff_t src_offset,
> > > > +				    int order, void *opaque);
> > > >  
> > > >  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> > > >  		       kvm_gmem_populate_cb post_populate, void *opaque);
> > > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > > index 9160379df378..e9ac3fd4fd8f 100644
> > > > --- a/virt/kvm/guest_memfd.c
> > > > +++ b/virt/kvm/guest_memfd.c
> > > > @@ -814,14 +814,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
> > > >  
> > > >  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> > > > +
> > > > +#define GMEM_GUP_NPAGES (1UL << PMD_ORDER)
> > > Limiting GMEM_GUP_NPAGES to PMD_ORDER may only work when the max_order of a huge
> > > folio is 2MB. What if the max_order returned from  __kvm_gmem_get_pfn() is 1GB
> > > when src_pages[] can only hold up to 512 pages?
> > 
> > This was necessarily chosen in prep for hugepages, but more about my
> > unease at letting userspace GUP arbitrarilly large ranges. PMD_ORDER
> > happens to align with 2MB hugepages while seeming like a reasonable
> > batching value so that's why I chose it.
> >
> > Even with 1GB support, I wasn't really planning to increase it. SNP
> > doesn't really make use of RMP sizes >2MB, and it sounds like TDX
> > handles promotion in a completely different path. So atm I'm leaning
> > toward just letting GMEM_GUP_NPAGES be the cap for the max page size we
> > support for kvm_gmem_populate() path and not bothering to change it
> > until a solid use-case arises.
> The problem is that with hugetlb-based guest_memfd, the folio itself could be
> of 1GB, though SNP and TDX can force mapping at only 4KB.

If TDX wants to unload handling of page-clearing to its per-page
post-populate callback and tie that its shared/private tracking that's
perfectly fine by me.

*How* TDX tells gmem it wants this different behavior is a topic for a
follow-up patchset, Vishal suggested kernel-internal flags to
kvm_gmem_create(), which seemed reasonable to me. In that case, uptodate
flag would probably just default to set and punt to post-populate/prep
hooks, because we absolutely *do not* want to have to re-introduce per-4K
tracking of this type of state within gmem, since getting rid of that sort
of tracking requirement within gmem is the entire motivation of this
series. And since, within this series, the uptodate flag and
prep-tracking both have the same 4K granularity, it seems unecessary to
address this here.

If you were to send a patchset on top of this (or even independently) that
introduces said kernel-internal gmem flag to offload uptodate-tracking to
post-populate/prep hooks, and utilize it to optimize the current 4K-only
TDX implementation by letting TDX module handle the initial
page-clearing, then I think that change/discussion can progress without
being blocked in any major way by this series.

But I don't think we need to flesh all that out here, so long as we are
aware of this as a future change/requirement and have reasonable
indication that it is compatible with this series.

> 
> Then since max_order = folio_order(folio) (at least in the tree for [1]), 
> WARN_ON() in kvm_gmem_populate() could still be hit:
> 
> folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
>         (npages - i) < (1 << max_order));

Yes, in the SNP implementation of hugetlb I ended up removing this
warning, and in that case I also ended up forcing kvm_gmem_populate() to
be 4K-only:

  https://github.com/AMDESE/linux/blob/snp-hugetlb-v2-wip0/virt/kvm/guest_memfd.c#L2372

but it makes a lot more sense to make those restrictions and changes in
the context of hugepage support, rather than this series which is trying
very hard to not do hugepage enablement, but simply keep what's partially
there intact while reworking other things that have proven to be
continued impediments to both in-place conversion and hugepage
enablement.

Also, there's talk now of enabling hugepages even without in-place
conversion for hugetlbfs, and that will likely be the same path we
follow for THP to remain in alignment. Rather than anticipating what all
these changes will mean WRT hugepage implementation/requirements, I
think it will be fruitful to remove some of the baggage that will
complicate that process/discussion like this patchset attempts.

-Mike

> 
> TDX is even easier to hit this warning because it always passes npages as 1.
> 
> [1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com
> 
>  
> > > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> > > 
> > > Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> > > per 4KB while removing the max_order from post_populate() parameters, as done
> > > in Sean's sketch patch [1]?
> > 
> > That's an option too, but SNP can make use of 2MB pages in the
> > post-populate callback so I don't want to shut the door on that option
> > just yet if it's not too much of a pain to work in. Given the guest BIOS
> > lives primarily in 1 or 2 of these 2MB regions the benefits might be
> > worthwhile, and SNP doesn't have a post-post-populate promotion path
> > like TDX (at least, not one that would help much for guest boot times)
> I see.
> 
> So, what about below change?
> 
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -878,11 +878,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>                 }
> 
>                 folio_unlock(folio);
> -               WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> -                       (npages - i) < (1 << max_order));
> 
>                 ret = -EINVAL;
> -               while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> +               while (!IS_ALIGNED(gfn, 1 << max_order) || (npages - i) < (1 << max_order) ||
> +                      !kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
>                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE,
>                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>                         if (!max_order)
> 
> 
> 
> > 
> > > 
> > > Then the WARN_ON() in kvm_gmem_populate() can be removed, which would be easily
> > > triggered by TDX when max_order > 0 && npages == 1:
> > > 
> > >       WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > >               (npages - i) < (1 << max_order));
> > > 
> > > 
> > > [1] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> > > 
> > > >  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> > > >  		       kvm_gmem_populate_cb post_populate, void *opaque)
> > > >  {
> > > >  	struct kvm_memory_slot *slot;
> > > > -	void __user *p;
> > > > -
> > > > +	struct page **src_pages;
> > > >  	int ret = 0, max_order;
> > > > -	long i;
> > > > +	loff_t src_offset = 0;
> > > > +	long i, src_npages;
> > > >  
> > > >  	lockdep_assert_held(&kvm->slots_lock);
> > > >  
> > > > @@ -836,9 +839,28 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > >  	if (!file)
> > > >  		return -EFAULT;
> > > >  
> > > > +	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > > > +	npages = min_t(ulong, npages, GMEM_GUP_NPAGES);
> > > > +
> > > > +	if (src) {
> > > > +		src_npages = IS_ALIGNED((unsigned long)src, PAGE_SIZE) ? npages : npages + 1;
> > > > +
> > > > +		src_pages = kmalloc_array(src_npages, sizeof(struct page *), GFP_KERNEL);
> > > > +		if (!src_pages)
> > > > +			return -ENOMEM;
> > > > +
> > > > +		ret = get_user_pages_fast((unsigned long)src, src_npages, 0, src_pages);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > > +
> > > > +		if (ret != src_npages)
> > > > +			return -ENOMEM;
> > > > +
> > > > +		src_offset = (loff_t)(src - PTR_ALIGN_DOWN(src, PAGE_SIZE));
> > > > +	}
> > > > +
> > > >  	filemap_invalidate_lock(file->f_mapping);
> > > >  
> > > > -	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > > >  	for (i = 0; i < npages; i += (1 << max_order)) {
> > > >  		struct folio *folio;
> > > >  		gfn_t gfn = start_gfn + i;
> > > > @@ -869,8 +891,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > >  			max_order--;
> > > >  		}
> > > >  
> > > > -		p = src ? src + i * PAGE_SIZE : NULL;
> > > > -		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > > > +		ret = post_populate(kvm, gfn, pfn, src ? &src_pages[i] : NULL,
> > > > +				    src_offset, max_order, opaque);
> > > Why src_offset is not 0 starting from the 2nd page?
> > > 
> > > >  		if (!ret)
> > > >  			folio_mark_uptodate(folio);
> > > >  
> > > > @@ -882,6 +904,14 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > >  
> > > >  	filemap_invalidate_unlock(file->f_mapping);
> > > >  
> > > > +	if (src) {
> > > > +		long j;
> > > > +
> > > > +		for (j = 0; j < src_npages; j++)
> > > > +			put_page(src_pages[j]);
> > > > +		kfree(src_pages);
> > > > +	}
> > > > +
> > > >  	return ret && !i ? ret : i;
> > > >  }
> > > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> > > > -- 
> > > > 2.25.1
> > > > 

