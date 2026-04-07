Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3405F46C7F
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 21:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC956B0088; Tue,  7 Apr 2026 17:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836A06B0089; Tue,  7 Apr 2026 17:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7446B008A; Tue,  7 Apr 2026 17:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56E486B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:09:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E7C81A099A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:09:51 +0000 (UTC)
X-FDA: 84633001782.13.6DE34B4
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70FA3C0007
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:09:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BCWWvqXb;
	spf=pass (imf28.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.201.45 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775596188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czUNw8x4f2edS3dSIecnbdB7s7bYhvr0I6AL71y67Ts=;
	b=MSyRz2EMkfk5T+tuOMBK7ZtTXHPItNI/6t+VzlLtEkXX0eNmgHK7Ig9pvGJnFgqdgb5D9m
	jXP76A5a3PXLUWn5h/8wU52pOTJ58o4BU3G6eu14zghnYvRyED63cWoEiyeChTwwKt6GCJ
	orTzCsI7xp1eahNkWmyHEskb/H6Hk6k=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BCWWvqXb;
	spf=pass (imf28.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.201.45 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775596188; a=rsa-sha256;
	cv=pass;
	b=0/Hpdo9UNKyAgJgHWaV9Z4Bm1vU/oNbAe2llxoxhfV/Qho1p34CBovm3s+AAFYo2YvcrqR
	5QhMoVwHizBLmKOm8YR+4Qt/tbkcTdXV/8DE0vMUAOW9yAeHIo9YW8hhwvZ9Quz0MTvfe3
	sd9PZrEYromlSM74zhNfzsUVxbdL2TU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1lF5Qd7Z3qTjYqwwBgqRNMCeVRRDP8GjClK6xJ66d+7JYv55Y2eshy3v8LLSA69pDRrU/Z0m9wTqV7A7MkfMp3gN6HYVfIkOsp/4V1Ge2Tv4aCh+hRXQTZOcRrbOnhph/7I5/Yx4HxjExFuX48yAdYn6OUkbmLWQP+L3k/B8KRZUkugib+1W7y/h6XJ91LHhlsmIg1ge9wgKP8oa8vcH96exXq+uqK3jcPsd8b4zTnJ8ia59q/+DgTqlwUn80Ve9s8oDLNrSUeWPGqv+mFpvrH7UoNf8M+vl5OQLiM4tVUv6PBufInfmd7Nrh+HsyNbVf1YGfyE2U96ZyhNcyzneA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czUNw8x4f2edS3dSIecnbdB7s7bYhvr0I6AL71y67Ts=;
 b=GmPEYqNZxKxVeWr/bnrD62zxzJi2QFfqsAzTeFpkCGYDBEGcE6vmCsWSgeE38dxBnSQpdqvScz+JEC5uvGv4v9br4rcGgvVrqcSoGI/Z8eSQnPvEhJhOoGWz+K3h1MckL/wQ+BmdHwkBOznDPXlnx5I0R35alUo+xbAfFwdqB9KiaCHLH98vowUIbAJoypFAwjLOHgmA4JOsH8QXOFotvGyIPyIdEqrYPJEs11ayuduqcB9ghGMYjA/qYKntmPABY7S0LUhjlaGkLc5lAhDu5YckJKs+zCdDSOA9oEXiKf8Jubp7vUcNeevwLvseOWXV6ZH3V/RhMufJ2iYPXFiXXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czUNw8x4f2edS3dSIecnbdB7s7bYhvr0I6AL71y67Ts=;
 b=BCWWvqXbCQgnpVU2/4X5lddsbZRE8jZTWmuHPeLsrr81WP23o7Yo9XnWC+4xNnBmh5sJb6AqMW4mzRBOMTZP/ds+ObVkAPW/sjVrSbRRGMeSaMMeJiAspQSUe9E0QANo6wA6Y8h3/jrDNt33+gnOnS+oOmqM6yD4Z5I+CSkwwy4=
Received: from PH8PR22CA0004.namprd22.prod.outlook.com (2603:10b6:510:2d1::19)
 by DM4PR12MB6375.namprd12.prod.outlook.com (2603:10b6:8:a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Tue, 7 Apr
 2026 21:09:35 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:510:2d1:cafe::90) by PH8PR22CA0004.outlook.office365.com
 (2603:10b6:510:2d1::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.33 via Frontend Transport; Tue,
 7 Apr 2026 21:09:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Tue, 7 Apr 2026 21:09:34 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 7 Apr
 2026 16:09:34 -0500
Date: Tue, 7 Apr 2026 16:09:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<ira.weiny@intel.com>, <jmattson@google.com>, <jthoughton@google.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <tabba@google.com>, <willy@infradead.org>,
	<wyihan@google.com>, <yan.y.zhao@intel.com>, <forkloop@google.com>,
	<pratyush@kernel.org>, <suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
	<shuah@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for
 KVM_SET_MEMORY_ATTRIBUTES2
Message-ID: <yvfwexsub7nrogh67hzcsupbrkzer6a7kbeao5tlq4elrzc2iz@xrwdjd7p32pp>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
 <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|DM4PR12MB6375:EE_
X-MS-Office365-Filtering-Correlation-Id: a18249f2-ffe5-4b23-36cc-08de94e9f858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RWb4OjKx6dMshFlh8RKuoAubS4lKTIe6QDH7TVtBeU3s6WAphjHpPnE8+db/23hvoAtxDD3XhblL3pS1w+V2n2ReBlJcyfRh2f//GhA6RuIH250IuP09Fcs7Yv96P3rkjjfLNTOk7Z1Hgub7beCb5KYOwo/cZ0B8qqb0FW/Aeo7hQQGA0CO2+Ew42uXQ5qoV2B2LxaiB3jUK89xbsZ9Gm27wQ0Dr3tcpCfC1q58kd+E+vgB+u22uQPXbDGjl7MrSJo1Hf5w9Oivt2gykRcz02GW0ajlRxypdPy+3im0sRQbyAMk2tHY5P+mD9PaZya6H1FGRXTyWGG6tgAao0PCk/vReo0d7K/mR3/F2M+VkMTtUDIuQsmrZLU9GE+6oGDyBhQXB744ADrW1BEdd5ZxDm0MXtLjhRc3IPuiPQAJ2uxyrcvClUbkABH+hCCScdkrAVe9y9SwREO6YMNl57OIJ8SAgqq6wBnG5pNlwrbE1iWJ3E9alG8oa/ioR30wxrmEi+Q3Fa11GpK1J8YFkBicLXAqwNHYyr40sLVXzHbxD1OAI/60g7wyTPXEj8FbVdUm1D0aMd/j2/FIkrlmbdzFPNhr7l+fwRAzfianmeBgV1hQEIwoNCYtV5Z5nYr+Hcsd51HvgN9mq/uD4cfoe33ja8SsdPgcGqXNRhIXcKLGDnCq34yaiHiPq+6Y54v2s1dwZXX9ejc4EU9wcSBk6QoJeDDdfw+EqUrC8R4iEUzpocPiuEn6mvLN1HfHVlNeFsyFl1o/vGYSSJqvqwpTbyyzy3w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m9vqMhyy8KzFPgOnoE4CGuMgcYXJ76KHo6EKReMd4c3D4eYQuLDas82SE0/2gWte9GXnfweIAejlTNku8G8DpOa9pp7N9E1gOcNYRRfedYqE3enGunridZGnMna36/IN0qV+TCXk0HaFl33YjQX1cHAMaYO5QjnssZIPGSeMik68SGXU5kFbONdY0K0cW49MLyVZtL7oy6uWuNI23e2Ubeh7GLU/7jX6V5p2XWT9/+ATLvgAawrnmXhAQ+3jqTiF8R6ZKtzp2vzbezI/EoVALQsk2YbNHeiWuD1Kjyl16ZgidCY+Z5DlQ/IPr9G4xR3sdyDhP8oIT2dVpUwtKTPftBBU6XSlBP95QTN3a/tIxIe07BonCRc5wPo1H29G7+cMWkmlVrrTv4NlgRzePHt+ZKkHPkKpQ3TlWhQvPRsOLPMkrBY96CXIjiQIUAO7pdX0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 21:09:34.7361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a18249f2-ffe5-4b23-36cc-08de94e9f858
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6375
X-Rspam-User: 
X-Stat-Signature: 36dzjmk8tj6z7ca7maf3xy7bwg8eagdy
X-Rspamd-Queue-Id: 70FA3C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775596188-189128
X-HE-Meta: U2FsdGVkX1+hg7HoN9gdN4vgSAYjT0v6x58h7/ssE5at5Wjmjh/wvLURLaA5RL8qHhkDZ3QKUNoyZWg2WrfoBxeYWbTlEAouWncsmTkfYSbT5cCTCNMfIzumuF4i3Cc1c7Xg1+s+tI3NUivoAy4onfONtRv1979mW9gFY+ORzp/wzF+2DABRPKWsOdJsz+eig5EAGijg62bcjuO/WdJwh5tmP9Eiy4zJsInsRueVZ/n7bmxc6XPrVZdFRJobJf9UAyyNbsDsuxUy0oqRdUFYDBVdMs7mdZIDqBEV3h6lS/TTLbPmSsYXL/yeyeFgvESkgYZgTjuJrGASOL6/kJIW901tuWowj1ZLivJ5geEUiXFO58R0jyw1LGJbfdBak8qXRi4tLbejHITUa+gMbKUB5YhHbIYmPavTqUpAItw5uV0JDJEN1juvd2gKKL8VHTjTD+Z8d+E6cYEL5R9rvLZTRvmMBp8cicqr9+Gd5JJlgXRBaZK5P/A9H26Zjeir+rYNonVx72rWgKwHgE9/PZYQlP0IZHaf4nr1QlbeK3FvUVwzloPW7f2L1Ak2Fq6PD+JusoTFjcgXcUgeigAN4gzTSoyG8eBjUDC8KdImYV/CjZYc22muk+Zh53t6pHZHN85Wa0BaeQff1qpycx4nqw7dQIyworONl+j3ifZT7eGxJTt6GRp+NnNyDtw6VYxCYYS6VxdeP3QtKewA7vaIQObcslnXh5+g2KK6Fx7rK3RtPokFrnORW2DI9CIfZFo+wCjDCgap975dCEjvFsgirQd8YLGUrudhiQ/+t/8L5X0w736vB07+cHNnb8sRiPRsdZqnbjqDcA+Nv8XDEOm/nZYVwqFPujPruIy9cRjj7jLIpG5fXMAwEcuWSAMJ+TP2vhq6MxKe3O8Q4jDJldw2hn1pYmL3W3brETNYbSOqD36wlALryg75U4vDVEjyRvrUp86OmaG4x67R5ZjZoEqqkDn
 RE8zgght
 798QXNh0ZA587RAeRUa+rrAoLgeble7uL2tbL0d9nh9D3koCcj/ggHzVGUyXKUR5S6Do+apB9agpd8mQjhBKy8Pjpmmh55iK59rKEtpwuevE6c2BkCmWmwJLKSHuPNf+8ehVwgPHYIFCR7KlQpDN2gjNLxVEKZJt9jy9rNrA4xGURDxvLLkSq7+YrvsYPgd5xmQQltUesGEzcW0G2mrvMsr+RfGZuaMnlOv/U4RRkobDIDdfY0ETk5BLSpqQTn2/cPSo9GwDCbMLO9ZrLhb13zu1Q5prz7h8cwlKbr7hSNpHckFNJU4YrXGWO5zlp5DVQX4Uj6Ci2xrTabU7eDa32x6MnHxBMoJ/050E+ToZQ1fum5QbG/hIKOuGlGlosi32YgZPvCORVddbM+47lNd8VvXLVwrACJlWdXW92jU8j+zWGT0bpe9h8M3PTh5IjpQFJQSbHcjlm683pFuiZJ1C1lUKAQ00zDM1CpIq3b+27fMWrOEc3Ay2hGnB8R3UtgqkF/uDZIWpHMCnBx7Br21bJD52tCmWYsYpPwBp11fmVo20JBAF4nSNKvOKyKvEtdRWjizTVFrpmYHlzwZUdI4phzJ9v8a6fC6iAv7Fc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 07:50:16AM -0700, Ackerley Tng wrote:
> Ackerley
> ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd=
ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddnnnnnnnnnnn=
nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn=
nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn=
nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn=
nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn=
nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnng <ackerleytng@go=
ogle.com> writes:
>=20
> >
> > [...snip...]
> >
> > guest_memfd's populate will first check that the memory is shared, then
> > also set the memory to private after the populate.
> >
> > [...snip...]
> >
> Looking at this again, the above basically means that the entire
> conversion process needs to be performed within populate.
>=20
> In addition to setting the attributes in guest_memfd as private, for
> consistency, populate will also have to do all the associated
> operations, especially unmapping from the host, checking refcounts,
> and the list of work in conversion will only increase in future with
> direct map removal/restoration and huge page merging.
>=20
> The complexity of conversion also means possible errors (EAGAIN for
> elevated refcounts and ENOMEM when we're out of memory), and error
> information like the offset where the elevated refcount was.
>=20
> It doesn't look like there's room for this information to be plumbed out
> through the platform-specific ioctls, and even if we make space, it
> seems odd to have conversion-related error information returned through
> the platform-specific call.
>=20
>=20
> I agree with the goal of not having KVM touch private memory contents as
> tracked by guest_memfd, so I'd like to propose that we distinguish:
>=20
> 1. private as tracked by KVM (guest_memfd/vm_memory_attributes)
> 2. private as tracked by trusted entity

I think this is a good distinction to keep in mind, because if we adopt
the proposal from the call of having userspace set the destination memory
to shared prior to calling kvm_gmem_populate(), then they don't really
stay shared until gmem convert them to private: instead, they get set to
"private as tracked by trusted entity", but at the same time still have
'shared' memory attributes as far as KVM is concerned. Normally (SNP,
at least), the 'private (as tracked by KVM)' state is an intermediate state
on the way to 'private (as tracked by KVM + trusted entity)'.

So we introduce some inconsistencies on that side, in order to address
the inconsistency of kvm_gmem_populate() writing to 'private (as tracked
by KVM)' memory. But as you point out...

> + destination address: private (as tracked by guest_memfd)
> + source address: shared (as tracked by guest_memfd) or NULL
>=20
> KVM doesn't touch private memory contents, even in this case, because
> it's really a platform-specific ioctl that handles loading, and the
> platform does expect the destination is private for both TDX and SNP
> at the firmware boundary.

=2E..yah, it's not really gmem that's writing to that memory, it's the
platform-specific hooks that 'prepare' the memory as part of population
and puts that in a 'private (as tracked by trusted entity)' state, just as
it's the platform-specific hooks that 'prepare' the memory as part of vCPU
page fault path at run-time and put them into a private (as tracked by
trusted entity). You could even imagine a naive CoCo implementation that
encrypts memory in-place at initial fault time via kvm_gmem_prepare()
hooks... we likely wouldn't insist on some new flow because this results
in gmem calling something that writes to 'private (as tracked by KVM)'
pages and would consider that to be more of a platform-specific
implementation detail that should be handled the same as other
architectures. And that seems like it would be roughly analogous to what
is being discussed here WRT the kvm_gmem_populate() path, so I think it
makes sense to continue to expecting the pages to be marked private in
advance of platform-specific preparation, whether that be via the
populate path or the runtime/fault-time path.


And for recent KVM,

; all the things we exp
about how the callbacks



As far as the copying goes,=20

By expecting 'private' (as tracked by KVM) as the initial state for
kvm_gmem_populate(), a lot of invariants about private memory (safe
refcount, directmap removal expectations, etc.) remain consistent even
in the populate path, where any special handling for private memory can be
accounted for in the same way rather than "shared, but..." or "private,
but...".
>=20
> Since SNP (platform-specific) only allows in-place launch update, and
> KVM had to provide an interface that allows a different source address
> for support before in-place conversion, then SNP has to continue
> supporting the to-be-deprecated path by doing the copying within
> platform-specific code.
>=20
> For consistency, guest_memfd can continue to check that it tracks the
> destination address as private, and sev_gmem_populate will then hide
> the copying code away just to support the legacy case.
>=20
>=20
> The flow before in-place conversion is
>=20
> 1. Load memory (shared or non-guest_memfd memory)
> 2. KVM_SEV_SNP_LAUNCH_UPDATE or KVM_TDX_INIT_MEM_REGION (destination:
>    gfn for separate private memory, source: shared memory)
>=20
> The proposed flow for in-place conversion is
>=20
> 1. INIT_SHARED or convert to shared
> 2. Load memory while it is shared
> 3. Convert to private (PRESERVE, or new flag?)
> 4. KVM_SEV_SNP_LAUNCH_UPDATE or KVM_TDX_INIT_MEM_REGION (destination:
>    gfn for converted private memory, source: NULL)
>=20
>=20
> TLDR:
>=20
> + Think of populate ioctls not as KVM touching memory, but platform
>   handling population.
> + KVM code (kvm_gmem_populate) still doesn't touch memory contents
> + post_populate is platform-specific code that handles loading into
>   private destination memory just to support legacy non-in-place
>   conversion.
> + Don't complicate populate ioctls by doing conversion just to support
>   legacy use-cases where platform-specific code has to do copying on
>   the host.

That's a good point: these are only considerations in the context of
actually copying from src->dst, but with in-place conversion the
primary/more-performant approach will be for userspace to initial
directly. I.e. if we enforced that, then gmem could right ascertain that
it isn't even writing to private pages via these hooks and any
manipulation of that memory is purely on the part of the trusted entity
handling initial encryption/etc.

I understand that we decided to keep the option of allowing separate
src/dst even with in-place conversion, but it doesn't seem worthwhile if
that necessarily means we need to glue population+conversion together in
1 clumsy interface that needs to handle partial return/error responses to
userspace (or potentially get stuck forever in the conversion path).

So I agree with Ackerley's proposal (which I guess is the same as what's
in this series).

However, 1 other alternative would be to do what was suggested on the
call, but require userspace to subsequently handle the shared->private
conversion. I think that would be workable too.

One other benefit to Ackerley's/current approach however is that it allows
us to potentially keep hugepages intact in the populate path, since
prep'ing/encrypting everything while it's in a shared state means gmem will
split the hugepage and all the firmware/RMP/etc. data structures will only
be able to handle individual 4K pages. I still suspect doing things like
encoding the initial 2MB OVMF image as a single hugepage might yield
enough benefit to explore this (at some point). So there's some niceness
in knowing that Ackerley's approach would allow for that eventually and
not require a complete rethink on these same topics.

Thanks,

Mike

>=20
> >>>
> >>> [...snip...]
> >>>

