Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C6710F9303
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 22:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244D86B0092; Tue, 31 Mar 2026 18:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5FF6B0095; Tue, 31 Mar 2026 18:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BDC56B0096; Tue, 31 Mar 2026 18:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E85AD6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:55:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8939EE0821
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:55:31 +0000 (UTC)
X-FDA: 84607866462.05.608C7AB
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6CE9D10000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:55:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jh1TqH22;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.201.65 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774997728; a=rsa-sha256;
	cv=pass;
	b=qZmtKYwuPkiIVI5f4Dhq/okijUE/NuwJluGmLWKem8cwxUwN4N8PrDswVVwPvCwbgfClyR
	k+Fq+chR4zr29PkWIMY/hcIl75YQ4G9AV3nPPjTMZ2GJZ5S7OcJxa0FBrBdd+r6d4WSl0a
	snrHx/hhIeWZI3r4TnfDS4Ls34hvswY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774997728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFbbXXSVz573XWlHhiXn82MDK06HAPpzQ+47UHDnMDo=;
	b=GOqkpB5/XDRJ/zKFLKYNAMl8QEdV3LJitx+u+tHOXT18A63LWmpZ6+m+x4XIvR9TExga47
	VN/F5fr/fJhiGY1p6W1mU0hbyRIgN4/XbbsSlqF199i626uu+0cwBg4Y7GjXhbdDn2AOQV
	qksWoFLUKDHtj+AGqJPE/jRAwrqjPsk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=jh1TqH22;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.201.65 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wM49eExtJ2WtYrAjuMPPFLabozGsemZ6adFEQ/NMOlqYO9myFbgh2hlUA27Ax5o8tVTSk4ElB0NjVc8TovcaiZPA71shQiixBYl70EzT2LruIMkQCn7S5JQ7pBvwwP51q4NSCWS5J3i0gw1UqQLFK4Nb3EcOmI/S6yF4b/49tg+bvzGX6md7xvN152EySdo10fLQQDVDDbuZbQ9BuJWbsv6yXvsiNronoOTNX59TUY+6Q2teP03/yZ1kunLoYGes3PqGDMj9vwfX0nHUlMx2DEG45f9WbjchChe+qVSc2fCh/HDDTYsCeaQXbQAW6ZODo8PfqBvCpdYXrmpqB7dyAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFbbXXSVz573XWlHhiXn82MDK06HAPpzQ+47UHDnMDo=;
 b=cI5bqvX5Uenqw0KmqM4lgPvPu80+60hf4AEGXCQQs1+W6Tz8o851Tpijz5yc+oskFDAKm+OLyH5B4+cSBuDdIpgBjn6TTKg4hv8QTabkL98eij8TMf2htmfHXUmWRR4xXQxnUlgEZwtkGcCYrnHMgfCJqSrLFVJRw1AUSC1TH5EJO6kJTl62QegCVTUFBaJIqvy6yStb/RA85ffovxLx7xXPyixEc0LKGjSyUhg6wAK5+MN79bhfjEWXFNc9tUSMnoyESA5mbpHxNPLLX7rO3IKEWR8Fo93+sJ5GEGvJV6PWg/RsOtXTq1THGE3LHuUbSHgrKAbUX5LWvHMi3Xf7vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFbbXXSVz573XWlHhiXn82MDK06HAPpzQ+47UHDnMDo=;
 b=jh1TqH22L7C9RM6VGgiveyMjyRO3CGSpLAMsgb2BS0HzOu6fATp5Op7uNcnQlproCYwQHqpt9sNMXKpGN6yA0iF55euXvemj+eQZDZvrFBifAWnG5qAY6Ean5ZEmTgbVLC/29namdSD7qn2SEuebd9XEXcMhAaVqThngib0WWs0=
Received: from BN9PR03CA0893.namprd03.prod.outlook.com (2603:10b6:408:13c::28)
 by DS0PR12MB8561.namprd12.prod.outlook.com (2603:10b6:8:166::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Tue, 31 Mar
 2026 22:55:20 +0000
Received: from BN1PEPF00005FFC.namprd05.prod.outlook.com
 (2603:10b6:408:13c:cafe::cc) by BN9PR03CA0893.outlook.office365.com
 (2603:10b6:408:13c::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.29 via Frontend Transport; Tue,
 31 Mar 2026 22:55:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00005FFC.mail.protection.outlook.com (10.167.243.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Tue, 31 Mar 2026 22:55:20 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 31 Mar
 2026 17:55:19 -0500
Date: Tue, 31 Mar 2026 17:53:10 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<ira.weiny@intel.com>, <jmattson@google.com>, <jroedel@suse.de>,
	<jthoughton@google.com>, <oupton@kernel.org>, <pankaj.gupta@amd.com>,
	<qperret@google.com>, <rick.p.edgecombe@intel.com>, <rientjes@google.com>,
	<shivankg@amd.com>, <steven.price@arm.com>, <tabba@google.com>,
	<willy@infradead.org>, <wyihan@google.com>, <yan.y.zhao@intel.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH RFC v4 08/44] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
Message-ID: <cxmtst7txfodp6lo4ipue3trohx2ge7nkagkfzfixfdnlf5qlo@e3jw3tmbe272>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-8-e202fe950ffd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260326-gmem-inplace-conversion-v4-8-e202fe950ffd@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFC:EE_|DS0PR12MB8561:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ef29d9-6ae3-4532-d666-08de8f7895b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	e0wD2t4shNlRM5Kt8mpEzuCOk3SKT8SPf3uH5+pU6u/rk8ipokzh6hdWLAeiO/fyVJDhZL2Atwx4dif2K+EtWdBo75GrENSC7vF1xRC410aIQxjQzJ+K4UEEi1HUXYntJw7ofdqaTny4GaOHFqmFYyrF5nWojhCYbAtxDnp323fpxOZ3ZPVfn/tZxqsjKKwW7mPvH3nO0eE6xDLHXCIvMxazDVMZQ1kOeDZW/cyACCl3tU44FKvrHsBBgxpRI1LIgnpOon8RrSQpQg+bjLNw9AQILAE8AoTk2h/oxN9vqhH0fvj8txcJTKTLaw8FKqB3Y4Mzd9RPW0wZ5DKg7AMzQv1G5b2tEId/0JxTN1UQgTxBzRnKULFTA3wruITD9MP4lD77L14KIaQsSmd0oUdD/l8ZUsEqaf8PdfzrE1FTPfZkWtDLw4kFXWh75r3tqbHiru9s1EJH5sHUp6KaSd8ynmcD+ggiFYJ2mnzI3yHd49Ztf93S4wk9YaD2ETn8eLFUv2Gg+u9Aq0q2vkwS1PYVsU7yRGdgBRGrAlHslGr022QzGlORijFzmO8vz+okwE4CFhIJH6hI7aNudkW4vK49LRaVPElY5tRez0wrszuR2qMuBm6/bNj690lDjWYJEzBgIx2+/UTAgxWPUlR9/sMBgaCdeHflI0Lzh2wvuOsiexPqcBM8wHKfZDNPt6ZxM7e6t/nwQaonYjDawBf8y1zKDxrW0EZca9Zpx2hTFx4+UAPVMee3gX9ZD6vokOZWtjLYAMIifgDm4h7/65FnGiImuA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xiqtZg7r1vdeHXguBqkSaDPbv8FcpCbvjwG1MW+DIrpe6SL9zebH0hLHGv4NoYVCGt9XBEnUoOCbPofaLRugbL1nYKu4z22SVZFL397tB4FjSr1eTdK3/37VdVq2D5eVX+/snJjQznKFACen0BD07Hm8jX0Akr07urkBGcUVrECwP9/IwEF5Di+cm+VnEkYninwhLyg95f1Vqq3XPCyk/3Iffi2c3Du1nrQWCnceOe8LG3axqLTR/9ryzhiuVsUL6gpYg4ZJjgnZOWz/FdM70NcQYxkCqi23+ibyxBeUmuZXdb1PraQIJfr6M29u5a/Htq8qM6NEcY9WCKunHqWQqJRwcqTwiRCJJsvtiAp/WueYdaJqxWRx57jEF0wHFR64FFpzJbXfzDC8XER/d0/7TphljsWj3jEKVSRRiIGYcyHZwqQUIkAxHvuwkv1LVo9k
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 22:55:20.3390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ef29d9-6ae3-4532-d666-08de8f7895b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8561
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6CE9D10000A
X-Stat-Signature: mmxktpcsh5wa6bgd8rifh7unyf3hjih8
X-HE-Tag: 1774997728-526702
X-HE-Meta: U2FsdGVkX19NcUqoDteYst3+usdWgD84Dc6nufHePRyku192+etZ+W+Nm32QH/j02rRsWglalUtthY0OuWFT/BTJrFCQNqnp0lGt93MojkO3ouzdiuJrB07AiTB9MeTIW1xRHBziQpUPLnUcNkTVmwexswf/VCzmVeF8Ud+yTNpOusfwWAn/U7vwyapoGz796fHhZTWysQ9hv2XTMI5J2+rzyhNZ9JpGcHUFl9INVZFQxbqxgpbq6UK9mG0du8p2CKRkJH4zykCk/b/cFLlRddFU/8bt6trEgBHsMorwir//4FLC8kUyqnHWI1Ll6WK8+cofDqZF3IdON/ctq1Av7ssi1lnqRo9N0YRvg1ndE1Yjq6ETKE0TmQv0OeqtKL2wyC3jLPGjSW+4fvVeoM8CpTeTGyGfZIOSJwE1XkH0AnBmVct0U+wwzKSGTUe7B9T7nBjhNQgydJ0u1qQRf4pkXQqYdiARZ/pc8Z9OH+cECvAota9Gtp88kYXxoPedzqzpwo8l12ZvK05Drm4l3qVJYFMmz0LWC6uQUP3Ta2Uc5gYpQYR8khut+clveW9vbFeDCXAw1KaAWA1FWxjlBzb4cE9fODHep3Qx0XGqIAxnGKp9j+7tmcKScv0Tf3PMnVo/g95SmMZ3cBHMYdln4S2KNDlN+IHXr3WPnYZZMzF9oCMBbMQFujL/N4LtXL+B4GJYcCh27Ir8v8ktUXpsTruJuWIDUKqyWAHDPxjhOm1y5HvVs/gsJERUnJayU9RBQNSR3Agrxp5mBoKUaAY7BK3abOLAgrUTJnw4rhRSnWTO15qP6KCa1MLmuHyakVss4NBLYFr0sy0TcomicMqiNEAaXykh+1C+AxFraZeShOcpYP805uB1pzqssnVnZZfa+KJkt9T7NaAAMGLEq6V5B2CY97zagZRbT45oOPRmfxTfN0wHT0/zEcVr0InGhAfIwd3i3dGbj/c4W8OSyhJaKLh
 Bk71YHyC
 c5UIY5LJW5sf7d9WQSnIREFJKoydu/40mty3ReH7UY8oeocefmhcqY2tzRlruSX+FnFDZwe6uIn7uO2StyOg2gW8JF0QOqZNXQnXTKNRIdypdA0Xl6pcSxjv6FmNHzsNDD4eraDmg3KR+CrzLJu6X3UHgIGy6ie3BvSgxK+B9mpZ/PPc21jHB8MquRtpG5pugn/p7hrryZ40vtenEWLIOLIaXaVAbN85CYBeByrm7VqQMa61F0Nq/V/sztNFrOkH8TxqNsBA/lTuqnZDwXjtzLl9hNKKtCXthNEtvAPfqBvQc93wXhyUJ1LQ35cwh3FweaCYnDvzIim43yxrJ9KcIfbA26iJK1IcoCC7m6vQ1PflselDZvHfJZTtd2xEl+1n1X5WBGwLTTW/UHFLSUSoDGTLss1EXmPZqZN37aSLrR5cLCrJ9nQRyik79qoLXipbbStLPyBKQ9nh7aYgmNqQdo8sprxZbfkNOdon/LC7Rd3hzE6o33tDEWh4NBnEEdaTVroGnjoZWfUQ87OVg9kop0KMPHX+Vx0RQnOTSdFIM89rL3zNWP/mHPgAcZalQXNcQp2NB2/yy+yJsugwr0pc1vmfjDCZ0/RLirhlX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:24:17PM -0700, Ackerley Tng wrote:
> Introduce a "version 2" of KVM_SET_MEMORY_ATTRIBUTES to support returning
> information back to userspace.

Hi Ackerley,

Not trying to bikeshed below, but I'm working on getting related QEMU
patches cleaned up to post soon and was working through some of the new
uAPI bits, and plumbing some of these capabilities in seems a little
awkward in a couple places so wondering if we should revisit how some of
this API is defined...

> 
> This new ioctl and structure will, in a later patch, be shared as a
> guest_memfd ioctl, where the padding in the new kvm_memory_attributes2
> structure will be for writing the response from the guest_memfd ioctl to
> userspace.
> 
> A new ioctl is necessary for these reasons:
> 
> 1. KVM_SET_MEMORY_ATTRIBUTES is currently a write-only ioctl and does not
>    allow userspace to read fields. There's nothing in code (yet?) that
>    validates this, but using _IOWR for consistency would be prudent.
> 
> 2. KVM_SET_MEMORY_ATTRIBUTES, when used as a guest_memfd ioctl, will need
>    an additional field to provide userspace with more error details.
> 
> Alternatively, a completely new ioctl could be defined, unrelated to
> KVM_SET_MEMORY_ATTRIBUTES, but using the same ioctl number and struct for
> the vm and guest_memfd ioctls streamlines the interface for userspace. In
> addition, any memory attributes, implemented on the vm or guest_memfd
> ioctl, can be easily shared with the other.
> 
> Add KVM_CAP_MEMORY_ATTRIBUTES2 to indicate that struct
> kvm_memory_attributes2 exists and can be used either with
> KVM_SET_MEMORY_ATTRIBUTES2 via the vm or guest_memfd ioctl.

The guest_memfd support for the KVM_SET_MEMORY_ATTRIBUTES2 ioctl isn't
added until patch #10, and to scan for it you sort of need to infer it
via KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES reporting non-zero (i.e.
KVM_MEMORY_ATTRIBUTE_PRIVATE), so it's confusing to state that
KVM_CAP_MEMORY_ATTRIBUTES2 means you can use the struct via a guest_memfd
ioctl.

I think the above is trying to simply say that the corresponding struct
exists, and remain agnostic about how it can be used. But if that were
the case, there would be no way to know when KVM_SET_MEMORY_ATTRIBUTES2 is
available in the first place, so in the case of KVM ioctls at least,
KVM_CAP_MEMORY_ATTRIBUTES2 is advertising both the struct and the ioctl,
whereas for guest_memfd it's only advertising the struct and not saying
anything about whether a similar gmem ioctl is available to use it.

Instead, maybe they should both have the same semantics:

  KVM_CAP_MEMORY_ATTRIBUTES2: *SET_ATTRIBUTES* ioctl exists for KVM that utilizes
    struct kvm_memory_attributes2

  KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES: *SET_ATTRIBUTES* ioctl exists for
    guest_memfd that utilizes struct kvm_memory_attributes2

In which case you would leave out any mention of guest_memfd here as far as
the documentation does, and then in patch #10 you could modify it to be
something like:

   4.145 KVM_SET_MEMORY_ATTRIBUTES2
   ---------------------------------

  -:Capability: KVM_CAP_MEMORY_ATTRIBUTES2
  +:Capability: KVM_CAP_MEMORY_ATTRIBUTES2, KVM_GUEST_MEMFD_CAP_MEMORY_ATTRIBUTES
  -:Architectures: x86
  +:Architectures: all
  -:Type: vm ioctl
  +:Type: vm, guest_memfd ioctl
   :Parameters: struct kvm_memory_attributes2 (in/out)
   :Returns: 0 on success, <0 on error

and *then* add in your mentions of how the usage/fields differ for
guest_memfd/KVM_GUEST_MEMFD_CAP_MEMORY_ATTRIBUTES case vs. KVM ioctls.

This avoids needing to issue 2 checks for the guest_memfd variant vs. 1
for KVM, but more importantly avoids subtle differences in how these
similarly-named capabilities are used/documented that might cause
unecessary confusion.

Thanks,

Mike

> 
> Handle KVM_CAP_MEMORY_ATTRIBUTES2 and return the same supported attributes
> as would be returned for KVM_CAP_MEMORY_ATTRIBUTES - the supported
> attributes are the same for now, regardless of the CAP requested.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 32 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h       | 12 ++++++++++++
>  virt/kvm/kvm_main.c            | 40 +++++++++++++++++++++++++++++++++++++---
>  3 files changed, 81 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 032516783e962..0b61e2579e1d8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6359,6 +6359,8 @@ S390:
>  Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
>  Returns -EINVAL if called on a protected VM.
>  
> +.. _KVM_SET_MEMORY_ATTRIBUTES:
> +
>  4.141 KVM_SET_MEMORY_ATTRIBUTES
>  -------------------------------
>  
> @@ -6551,6 +6553,36 @@ KVM_S390_KEYOP_SSKE
>    Sets the storage key for the guest address ``guest_addr`` to the key
>    specified in ``key``, returning the previous value in ``key``.
>  
> +4.145 KVM_SET_MEMORY_ATTRIBUTES2
> +---------------------------------
> +
> +:Capability: KVM_CAP_MEMORY_ATTRIBUTES2
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_memory_attributes2 (in/out)
> +:Returns: 0 on success, <0 on error
> +
> +KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
> +KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
> +userspace.  The original (pre-extension) fields are shared with
> +KVM_SET_MEMORY_ATTRIBUTES identically.
> +
> +Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
> +
> +::
> +
> +  struct kvm_memory_attributes2 {
> +	__u64 address;
> +	__u64 size;
> +	__u64 attributes;
> +	__u64 flags;
> +	__u64 reserved[12];
> +  };
> +
> +  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> +
> +See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
> +
>  .. _kvm_run:
>  
>  5. The kvm_run structure
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 80364d4dbebb0..16567d4a769e5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -989,6 +989,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_ARM_SEA_TO_USER 245
>  #define KVM_CAP_S390_USER_OPEREXEC 246
>  #define KVM_CAP_S390_KEYOP 247
> +#define KVM_CAP_MEMORY_ATTRIBUTES2 248
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1637,6 +1638,17 @@ struct kvm_memory_attributes {
>  	__u64 flags;
>  };
>  
> +/* Available with KVM_CAP_MEMORY_ATTRIBUTES2 */
> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
> +
> +struct kvm_memory_attributes2 {
> +	__u64 address;
> +	__u64 size;
> +	__u64 attributes;
> +	__u64 flags;
> +	__u64 reserved[12];
> +};
> +
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70b594dafc5cc..3c261904322f0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2621,9 +2621,10 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>  	return r;
>  }
>  static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> -					   struct kvm_memory_attributes *attrs)
> +					   struct kvm_memory_attributes2 *attrs)
>  {
>  	gfn_t start, end;
> +	int i;
>  
>  	/* flags is currently not used. */
>  	if (attrs->flags)
> @@ -2634,6 +2635,10 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>  		return -EINVAL;
>  	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
>  		return -EINVAL;
> +	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
> +		if (attrs->reserved[i])
> +			return -EINVAL;
> +	}
>  
>  	start = attrs->address >> PAGE_SHIFT;
>  	end = (attrs->address + attrs->size) >> PAGE_SHIFT;
> @@ -4966,6 +4971,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  	case KVM_CAP_DEVICE_CTRL:
>  		return 1;
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +	case KVM_CAP_MEMORY_ATTRIBUTES2:
>  	case KVM_CAP_MEMORY_ATTRIBUTES:
>  		if (!vm_memory_attributes)
>  			return 0;
> @@ -5191,6 +5197,14 @@ do {										\
>  		     sizeof_field(struct kvm_userspace_memory_region2, field));	\
>  } while (0)
>  
> +#define SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(field)				\
> +do {										\
> +	BUILD_BUG_ON(offsetof(struct kvm_memory_attributes, field) !=		\
> +		     offsetof(struct kvm_memory_attributes2, field));		\
> +	BUILD_BUG_ON(sizeof_field(struct kvm_memory_attributes, field) !=	\
> +		     sizeof_field(struct kvm_memory_attributes2, field));	\
> +} while (0)
> +
>  static long kvm_vm_ioctl(struct file *filp,
>  			   unsigned int ioctl, unsigned long arg)
>  {
> @@ -5373,15 +5387,35 @@ static long kvm_vm_ioctl(struct file *filp,
>  	}
>  #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +	case KVM_SET_MEMORY_ATTRIBUTES2:
>  	case KVM_SET_MEMORY_ATTRIBUTES: {
> -		struct kvm_memory_attributes attrs;
> +		struct kvm_memory_attributes2 attrs;
> +		unsigned long size;
> +
> +		if (ioctl == KVM_SET_MEMORY_ATTRIBUTES) {
> +			/*
> +			 * Fields beyond struct kvm_memory_attributes shouldn't
> +			 * be accessed, but avoid leaking kernel memory in case
> +			 * of a bug.
> +			 */
> +			memset(&attrs, 0, sizeof(attrs));
> +			size = sizeof(struct kvm_memory_attributes);
> +		} else {
> +			size = sizeof(struct kvm_memory_attributes2);
> +		}
> +
> +		/* Ensure the common parts of the two structs are identical. */
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(address);
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(size);
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(attributes);
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(flags);
>  
>  		r = -ENOTTY;
>  		if (!vm_memory_attributes)
>  			goto out;
>  
>  		r = -EFAULT;
> -		if (copy_from_user(&attrs, argp, sizeof(attrs)))
> +		if (copy_from_user(&attrs, argp, size))
>  			goto out;
>  
>  		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
> 
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 

