Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F79C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901086B008A; Fri, 11 Sep 2026 07:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D94F6B0099; Fri, 11 Sep 2026 07:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F866B009B; Fri, 11 Sep 2026 07:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 563CC6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:43:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3BFE80158
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:43:05 +0000 (UTC)
X-FDA: 85201295130.12.812CE8E
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	by imf14.hostedemail.com (Postfix) with ESMTP id B5B56100006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:43:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YJFnCzsD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.66 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789126983;
	b=K0/QQDuFeTXsrxt/OSH1xYuU4KditQ7cMrBx0p1IwpNBIfe7r4H09CkkUJbGeMhAz4D9S+
	3uAcA6dpsuh88BRHRxMKLchmbW2XP3utF6LMAvWI1i4+TYpHp3eOw026twpVo33aYkBvQq
	qmbPjf9U4hcgqE3Q5CjsMXYEmIWWysc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YJFnCzsD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.66 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789126983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaSdltMggd5xFw6ZjmTJfk3eUZQgy9XNJFL3yVlTJKk=;
	b=GZnw1tlN/CVhwiy83hWLdeF15qP2EtLPWA0bqCJd3sDH6NpD5d6UkkMCf6hPo3xxwJ4zSK
	gWFbBFCHJFAOvcN8fHIy/GOpCWcH6jwpf8oMpAIHDFlaHwLlbmY23RwFCynbv7RwwvPK0j
	ASYdRkaY05EHVoHOLb5LgQvLL2ONBhE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQIgK3jIiXk59a3j9k6LUQks33SX9vbfrh9RJwn36zqmKfq4oPTZR91k7xBCvHRXvOgBYprHC/nPlhvraVI0p+9ERfyU9oDvgUq8VgcNzUoL1TUx46aoA4a1P5BH+AJVFLW4uyUQhdCxU2CAtFmlI1PEXScyfFb3ZZrOsHFdIQyD3fOX4whqSm/2Zc0u9MVtHWx6WfTduSBf99+olYZJsLwTybXw43eqPnwoZNVxDv6Yi4YIj9UpDbfw7rUtTFp30tr+EVKgtezA4XGYbOKWCmb+iez51B5ABNx15SW/IJq7quS9wpTCobhpRW9y7gEpq2Glxo4dvxoS5Pb2Y6tV7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaSdltMggd5xFw6ZjmTJfk3eUZQgy9XNJFL3yVlTJKk=;
 b=TedodH3wRl1kMfpSJRj3FQ9Bwg9kcaxKPEbwTyNoNE7OVVuKbbRoLWyGk9SUtlt1TYSqPOvPlHoREv2QuKIJGq4JgSPtgbdZoDqqDq5wIWBt3U6RxzgLUGB7800DojWvkzHOmpY1XeN/35BEQy3a2j0ljxxNJLG6/bN56qbX8s9xbhkhKge1C1K1PV4MLLJruZgvaJOuQV0QlQ7k92Ozy/CPRzIQ3DcI2OchFo3kUHCmD/NPXqqQyZ+1zQP3YCh7Yk5rEjjAxqUUuGPPQomoUXCeHHAWIjqI/GnIuaIKnLNq5/+pesmOKnD7KM+W/JYHd0pkFOJpWWl/w8Wikisa7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaSdltMggd5xFw6ZjmTJfk3eUZQgy9XNJFL3yVlTJKk=;
 b=YJFnCzsDvTCE/JABGpDGDo/zEc3dqzOwJ2cJSn/VeLnU0iueVcvUeA1toWedULdp/t+V3seRGQA3+C1VTxpHf5ACWW5MFvxZAEj5PEJwzRuxzJ/kJGF/NqwUONvRTF4QqPoFXp4ILNi1TN2AfD8e2MR4SaYoOrPsmrl/vysIh64=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 11:42:55 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0406.005; Fri, 11 Sep 2026
 11:42:55 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "Gupta, Pankaj" <Pankaj.Gupta@amd.com>, "Sampat, Pratik Rajesh"
	<PratikRajesh.Sampat@amd.com>, "nikita.kalyazin@linux.dev"
	<nikita.kalyazin@linux.dev>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
	"david@kernel.org" <david@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "jack@suse.cz" <jack@suse.cz>,
	"tglx@kernel.org" <tglx@kernel.org>, "Dadhania, Nikunj"
	<nikunj.dadhania@amd.com>, "Roth, Michael" <Michael.Roth@amd.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "mhocko@suse.com" <mhocko@suse.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "iweiny@kernel.org"
	<iweiny@kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"ricarkol@google.com" <ricarkol@google.com>, "vannapurve@google.com"
	<vannapurve@google.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "Kalra, Ashish" <Ashish.Kalra@amd.com>,
	"willy@infradead.org" <willy@infradead.org>, "surenb@google.com"
	<surenb@google.com>, "pshier@google.com" <pshier@google.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>, "skhan@linuxfoundation.org"
	<skhan@linuxfoundation.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "apopple@nvidia.com"
	<apopple@nvidia.com>, "ziy@nvidia.com" <ziy@nvidia.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/9] KVM: guest_memfd: implement folio migration for
 non-confidential VMs
Thread-Topic: [PATCH v3 3/9] KVM: guest_memfd: implement folio migration for
 non-confidential VMs
Thread-Index: AQHdJKV/3uLeqaf+9UC/JZyvUZ2W2bbHznWAgAGtnQA=
Date: Fri, 11 Sep 2026 11:42:55 +0000
Message-ID: <2c4a5b9adb2dc44aab9e810728b9f31e125c6ecc.camel@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
	 <20260805-shivank-gmem-migrate-v3-3-00d8bdec4e1d@amd.com>
	 <e0120f1a-d53b-46a3-9542-030212250135@kernel.org>
In-Reply-To: <e0120f1a-d53b-46a3-9542-030212250135@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DM4PR12MB5890:EE_
x-ms-office365-filtering-correlation-id: 815434fc-621c-4988-b11b-08df0ff9d237
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|10067099003|6133799003|22082099003|18002099003|4143699003|11063799006|5023799004|56012099006|921020|38070700021;
x-microsoft-antispam-message-info:
 aeeRVZ53S9uqwE89gdlA6gQbENtCki5CtazXXQOkp5XcYTR7srk33gOFQ+YNN271H8Kp9nm9UfsWYcmLAYrX9unyEhKFBJKqvbxIqaUDUzXXRgFwN2x/r3qHxd5hRdTjRP82chRYc3upxuwYh8zYLnTiKk8MjcCyIqZU3hR4cGS5wL+1SU+Wgz8cYc4WI7Q2uSCnwtFpvK4XlHDMkA0C9jDIPs3JasGSWdgVoy0TAAYsvW4IpwOzHXRjCaNEnVd2i4VeD/cHJtjZd1h/ALUo+KIBSzRpRl+YLMfaRbuQiKboAdRSjVJd8nLfFLLJYY6vj5ZfpIBsROPdm/pjh9cc3ks4SL/TzznY0C10vQatx/bNOxV4XcDYgg98DCF1/BBXC7E/hij3hNfaIaZqm8iFkg8f30xAvVcuUZaWG8KdM2Q9RPdJWIPPtXLna/10Sv2vUrawSq00GQ3XHk1pDlBL1MR32ENSxKWBO+ScS/ehJ/I/Fv5euI0wxuxmvoOmOlhXvMOEatexqACKaRH8/Df8To7Zr7CDe1Z1vFRJin6hQqw6RhUZOo4/Z4JKs+iPWA6Q7JWWYYtvDjrGokmSYFj8U3lh4fFbJd1aOEGEVRmcGfdWY+4KjqAgNNYBn84CkqzFx0QvTgYHuqpfOKDStiS9nNciszMZ2fwouOBAiqbjTeP3hiTHWLCVsgsfqvcpZ4lbUVswZY0IbRJ+kXUXmqgZf+FSQ+zY3YwsW+aGquj6kZZ5TAGGVWgm9isNPZ2iqMFv
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(10067099003)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006)(5023799004)(56012099006)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N0lwY01aalB3b2xUbXluNTBCWjNoczRpSmdyT2dBd0NScmhBK3FNeFFKaER1?=
 =?utf-8?B?NEE1ZHducm5PNG16QUE0MjJac0x4bmZRZG1aNmZGb2U3U1ZUSk5tWGhsdmxo?=
 =?utf-8?B?a0VXZkxjNjRyc3JMWGZDbHlnQmgwK1ZlQUlORmplSnQ4NjRYQ2lnQWl5ZEF2?=
 =?utf-8?B?MmlwN21BSHZHbnZlWTZrakVqRFlManZjWlBwenBrMWRXekpUanNMa3NsYnpp?=
 =?utf-8?B?WmhkS0ZWcktmaVRSVU5kTHBvbGFHKytDaW80RlJaNllIamxzOElhRHEydVRw?=
 =?utf-8?B?M0hXRkZ3Q241emRNbC9YV05DYTlrczduZnU3b01ac3hzR0VXZEk2MWdqQzNG?=
 =?utf-8?B?WEZMNjR4dDZBWDZxT203QW0xc0dHTjN1b29HdkZHVVlTRVdpRlAzbmVhOSts?=
 =?utf-8?B?Qk1ZL3R2cC9ITkY4QTV4cG9PTmRPZVVWanpQWit2MFM2OTluaDFVK3dVY05L?=
 =?utf-8?B?QXNleTN0QXVubTYwSWp6eVVlZ0N0akVJc2Vsb0FkV1ZoeVhyWk9RMUFvaDRP?=
 =?utf-8?B?NzhKNTgyYWJicFg1aWlLZDMxNEpGYlZ1bDJ3M0UyMFBBTGVPSkNDYlZTNHRT?=
 =?utf-8?B?V3ptVUdUWW54dzFjWGJWSnE2SktTbm5vSXZCN1VBZE5XZWFNY2lOcUJsVUJK?=
 =?utf-8?B?OEFSRFh6V0paeXlPdlpPOVE4RFpjcC9QMlFIZ0FpcXRxaUNGb3hBRkdlblZJ?=
 =?utf-8?B?YnRFSisza1ZQeVlxUkJyNytOY01ja1JCUGlCTDUrdEl2Wll3K1VRbi9lbGR5?=
 =?utf-8?B?L3BDVllPdnhVeVZvcldvbk5YcncxcGhLL01WYkhweHliU3grNmJSdDBFQ3dk?=
 =?utf-8?B?OGIrVVdsYWtyYmZiS3pQSVZ2NkRiYWI1VG52UUN5UTB1Smd6a253Z2paamcy?=
 =?utf-8?B?L3lhZGZJRkI3WmdSakp0bWF0bkRoekl5OTFOK0ZhLzNON0ZVTVJvektORmZk?=
 =?utf-8?B?L0NlaFRYMFB1eGN4UHcwbzQxVUdLaHNaZUtxNC9WZzE4a3RSOERKRk5TSFl6?=
 =?utf-8?B?VkdCTG1SWUhRRHdGL2pOVlU5d2xrdkxQUFViT1N0MXFndm9zYVFYMHFCZWpw?=
 =?utf-8?B?bW1ZNzYrQmN6WHY3c1ZhMG54ZXZaUE44WnlRdkQ5TVIzQmhhdlFtemJhUjEw?=
 =?utf-8?B?L0ZqR0pWWEJ1aDRKNyt4VTFBdTJoQ0RrMUtxQVMxLzFEL0RmSGIxSjR2bDZj?=
 =?utf-8?B?VWcxVjJFVWVTVE9ZVTRwVCtMbVFaejVjdUlrMDltcG9JUU9GMDIxYUxHTVlt?=
 =?utf-8?B?RHdYaDlJMnNlK0JkK2RreDZUZVgxN1h5R1BDdkY4bkk0U3RrOVdzbWNCMThU?=
 =?utf-8?B?V29rakd3K212R3BBZU9KZmFKdHVvV2RNY2pJQWFDNHRMbXNyd00raUc1c1Z1?=
 =?utf-8?B?OEE3OG01WmNxSWpCUVRyWTNYbFRiUC82cHBkclphMHFRWldVV3g2MGlzN2l4?=
 =?utf-8?B?ZDgxbElGaTdJNjBsbmpaTm1WbUdxOXhPTGdPemUrOWlHUDNUbXBtUnBpUC9Y?=
 =?utf-8?B?dlFOaEJybGpqMXltUS9ScmgvMmdqVzY0ZFhYZlMzSVBwMW5yUW1BWkRpT0Y4?=
 =?utf-8?B?NHBkNE1yRjBGQzlsL2hReXFvMUV5MnVZUjZmRzlLSEREUVZDWXBQMHV0ekV1?=
 =?utf-8?B?TEh1U3JvTEFNUE1VbkFPdWM2SFVsczVqclJHVDhRZ0d3TEdZMkNCbDdEYWlK?=
 =?utf-8?B?Y0g5WVM1WFMyOUhaN1lqbGFRV0tpeUJ3Y09BYWZhcXI1QWIvQU9vK25yamFG?=
 =?utf-8?B?ZWYyY0JrMlJmc2J5Mkp1eHJ5citRVXpRMWx1Tm1sSVRHZTFNWFRneGptTzBL?=
 =?utf-8?B?aDhzbWVad2J4SXoyelpVa280dXl4ZGRNWTdYOXhWUk1DV1c2K2V1QTNQVDFm?=
 =?utf-8?B?czNNVGJYaWRFNlpLa1lzcXYzRysvbUVva2dkMTFTbk9qdWx5SmtWRjB2ai9E?=
 =?utf-8?B?Z1R3V0hFYUtab2hLVkJmSG9wcmJEdUJjaGxhby81SGpZb2owdXpFb2JaZXU5?=
 =?utf-8?B?ZkRjL3BsWkFrQitsUTFucnpJWUZ4NlZzM2hTeXFreWRvTmUxY0dBNTYwUDZp?=
 =?utf-8?B?dHYyUS84cFk5YWxJdURlaTltSklkSlRmWXJjN1ByVnJoWitIN21DREtaZjh1?=
 =?utf-8?B?YjhQNGtvRkJuMmluaTM2UjZtMW9KMzNvUy96M2xOdzQ4MHU0YnhWRDVRNlRS?=
 =?utf-8?B?NlpSVllPeW9xdzlrQmE5TlI3Tkl2QVFYZHR6NE5Namo3V2phUy9ocm9kSzh4?=
 =?utf-8?B?MHJXTjFwRHh3NjhOUG4yVHp6OTZCNFdML1gyL01aZi9WOXFQS1kvNlNnWU03?=
 =?utf-8?B?Z2xpZUtGOHk2cS9GcEo3U2RPU3FNTjRLdVJ4cVJhSkZUZEo3dGswQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA56D88F0EFF4840B3BCAAA6AA32D2E5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 815434fc-621c-4988-b11b-08df0ff9d237
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2026 11:42:55.7750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DBtmyvIhm9t2iYuDEkltlPhXppHfCoH/6l9uiAjUFQhep/v2XvlJ36Bicst2OoqFYLF+kW3fScSsMvEuLlFo2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B5B56100006
X-Stat-Signature: fu7ewhwj4urekh9p8foguo3ngcf53cxp
X-Rspam-User: 
X-HE-Tag: 1789126982-293005
X-HE-Meta: U2FsdGVkX19ZnxfBC9pzypB46N/gFGq95+lMI5bGhJsHwxThuhFf1BUuvKZc8SlVKZz/JROHAlhRYpf1ZrdG/26hUgCc16uf6hNfs+gYV4e+0cslm6u1M0/lrqsmV9v69psrhqEips+iC6wleNApljjpV/MroafYmTQDZezb8rQ3AYBPTexeakEE8TX454N3k4cjJ1+zY8y986gtnLMFfU9bXXhdPc1yLlnTxK9TtijeHRsq863lcI0Jk5tFy+zSVAn1TFbDrDKqAKVooWp9fq4pZN7MOmGg3RuL2X/1WDJAc3uWffxC8ofoN7uAiiZ/aCYWhoyFNwhcrYmMUaItGxeu/viVSRnFJHLdsd7WJi6apY+AsfbvfwhplqHvGijYR5N+RgN+cfwTDcKY/Sgg0DJREhdiJVp6yWyiGj+9SN8sfcJqY8y0SzFhxOZN4upEQ/TwfQ6lzFKouutLEgz01yilpdN4sKng7Vs8b0Kpm+NIcjaoWQa2Mpu8GI9SR1l/WrwT08XghYHtuTM0CSYNPLx7PTln2UgaGZkwb7qRe6xnvzEEaAF1H0PoJwm9C5oSdw+NethqQ3czICZdoPJH4X8DJOG3wS2TrM0NFC4P9du7IQaxlNQHrH2OwyOVoqnWLp32XeJ4e3z/2FNEpnGXaQuQgnCQ/1Jb71lPpUEmGBH5p01EIkYyi9+Mr+xGuMaaYWFki18n6oOcNqNRSu8KNY6Lrr5RWpJZZbdCc/mpEhZsyKpIQJpZw+6zYO/dI3hAvV4CxroIsZdVEiym1ub0mtUsYArYq6YF5XsxVOrTPdn4bwWEp3OZ5EMl/m4f6nMPG9C8NCseR6qeWfg1v9k4Qhbj2qFfZWB8GxNZAYFF+2wJZ6lw1L6dzVyuW7upcFYR/e79NR9wgtPj714OkvznKwLru51qzTvZFP3Fcw0arMfD4A6qneTAWi3Pw0ohcGUKFtuqoya4zi9I8EN/b4v
 U9RSGsNr
 Wtl/F3/4l3qJ2Ox8rRxrpGDKgsUIr3WpziknEOITZ+p4SagWlFn8ht1pgBrWgDHos8aj80Jmv3Iw4jW+kWiZZoxMPdEHz7/wa3APn/21q9AXqh1sXRBn6gv5b7BTqXn9q+SaAdTq9ih5ELNcRCNc8fWl828P2ww6YlyFm+KoX7tct+tSTs2zNKEPvoBEowJUyq81vExTYdxtg0hU0JymsYkeAjmese906rHKF+bG8njzc8C2rEWkRO4JQWNYwXBlfxSrUFaatiAPb9gdelFEOruDcq7fBX9AtZg1xqZyzufKD+2zp7tKI0eyX3aUcLUUZEkTKNRqqc2LjZjHvZjF4z1zJ0QGwDnr4wxY5gINkwVRpzZpQ27sAOTBBOXzcEkDz6YVec+PZ3trpwTsW79k2xfQkoxrzXLCtUAQNLj11G6N7Gg9rDca+pOa3iXDgyFLNyNKphTgC722KniYDsL8WjUONq6Dk8kQHCZ9lowwfoqb2G6jg3/Kcwr/6XFEbK+UadeZjYCd8VRVgVAEgTb7dZ13adlfKH7CQbyuS5tNgwGn4ZKh4G5mE3NXw9/BJQmJWWVuWjsCDrQ257BzJjGYuWsRxMheJAm9Ylq3cI5wfqRLtzhDvV/xMuI6vug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA5LTEwIGF0IDEyOjA1ICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gOC81LzI2IDA4OjQwLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+ID4gSW1w
bGVtZW50IGt2bV9nbWVtX21pZ3JhdGVfZm9saW8oKSB1c2luZyBmaWxlbWFwX21pZ3JhdGVfZm9s
aW8oKSBmb3INCj4gPiBub24tY29uZmlkZW50aWFsIFZNcyBidXQgZG9uJ3QgZW5hYmxlIGl0IHll
dC4gZ3Vlc3RfbWVtZmQgbWFwcGluZ3MNCj4gPiBhcmUgc3RpbGwgbWFya2VkIHVubW92YWJsZSwg
c28gTU0gbmV2ZXIgY2FsbHMgaXQuDQo+ID4gDQo+ID4gTU0gaW52b2tlcyAtPm1pZ3JhdGVfZm9s
aW8oKSBjYWxsYmFjayB3aXRoIGZvbGlvcyBhbHJlYWR5IGxvY2tlZCBhbmQNCj4gPiBhY3F1aXJl
cyB0aGUgaW52YWxpZGF0ZSBsb2NrIGFmdGVyd2FyZHMuIGt2bV9nbWVtX3B1bmNoX2hvbGUoKSB0
YWtlcw0KPiA+IHRoZSBpbnZhbGlkYXRlIGxvY2sgYmVmb3JlIGxvY2tpbmcgZm9saW9zIGR1cmlu
ZyB0cnVuY2F0aW9uLCBzbw0KPiA+IHRha2luZyBpbnZhbGlkYXRlIGxvY2sgaW4gbWlncmF0aW9u
IGNhbGxiYWNrIGNhbiBjYXVzZSBhbiBBQkJBLWRlYWRsb2NrDQo+ID4gc2l0dWF0aW9uLiBVc2Ug
ZmlsZW1hcF9pbnZhbGlkYXRlX3RyeWxvY2tfc2hhcmVkKCkgdG8gYXZvaWQgdGhpcy4NCj4gPiAN
Cj4gPiBBIHN1YnNlcXVlbnQgcGF0Y2ggYWRkcyBhbiBvcHQtaW4gZmxhZyB0byBjaGFuZ2UgdGhl
IG1hcHBpbmcgdG8NCj4gPiBtb3ZhYmxlIGFuZCBlbmFibGUgbWlncmF0aW9uLiBOb24tY29uZmlk
ZW50aWFsIFZNcyBjYW4gdXNlDQo+ID4gaG9zdC1zaWRlIGNvcHkgdmlhIGZvbGlvX21jX2NvcHko
KSwgd2hlcmVhcyBjb25maWRlbnRpYWwgVk1zIHdpbGwNCj4gPiByZXF1aXJlIGZpcm13YXJlLWFz
c2lzdGVkIGNvcHlpbmcgYmVmb3JlIHRoZXkgY2FuIG9wdCBpbi4NCj4gPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBTaGl2YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+DQo+ID4gLS0tDQo+ID4gIHZp
cnQva3ZtL2d1ZXN0X21lbWZkLmMgfCAzNiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2d1ZXN0X21lbWZkLmMgYi92aXJ0
L2t2bS9ndWVzdF9tZW1mZC5jDQo+ID4gaW5kZXggMTY5Zjc1Zjk1NDMzLi41ODMzNDFkNTkzYzkg
MTAwNjQ0DQo+ID4gLS0tIGEvdmlydC9rdm0vZ3Vlc3RfbWVtZmQuYw0KPiA+ICsrKyBiL3ZpcnQv
a3ZtL2d1ZXN0X21lbWZkLmMNCj4gPiBAQCAtNDg4LDEzICs0ODgsNDUgQEAgc3RhdGljIHN0cnVj
dCBmaWxlX29wZXJhdGlvbnMga3ZtX2dtZW1fZm9wcyA9IHsNCj4gPiAgCS5mYWxsb2NhdGUJPSBr
dm1fZ21lbV9mYWxsb2NhdGUsDQo+ID4gIH07DQo+ID4gIA0KPiA+ICsjaWZkZWYgQ09ORklHX01J
R1JBVElPTg0KPiA+ICBzdGF0aWMgaW50IGt2bV9nbWVtX21pZ3JhdGVfZm9saW8oc3RydWN0IGFk
ZHJlc3Nfc3BhY2UgKm1hcHBpbmcsDQo+ID4gIAkJCQkgIHN0cnVjdCBmb2xpbyAqZHN0LCBzdHJ1
Y3QgZm9saW8gKnNyYywNCj4gPiAgCQkJCSAgZW51bSBtaWdyYXRlX21vZGUgbW9kZSkNCj4gPiAg
ew0KPiA+IC0JV0FSTl9PTl9PTkNFKDEpOw0KPiA+IC0JcmV0dXJuIC1FSU5WQUw7DQo+ID4gKwlz
dHJ1Y3QgaW5vZGUgKmlub2RlID0gbWFwcGluZy0+aG9zdDsNCj4gPiArCXBnb2ZmX3Qgc3RhcnQs
IGVuZDsNCj4gPiArCWludCByZXQ7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIE1pZ3JhdGlv
biBpbnZva2VzIC0+bWlncmF0ZV9mb2xpbygpIHdoaWxlIGhvbGRpbmcgdGhlIGZvbGlvIGxvY2su
DQo+ID4gKwkgKiBVc2UgYSBub24tYmxvY2tpbmcgdHJ5bG9jayB0byBhdm9pZCBpbnZlcnRpbmcg
dGhlIGxvY2sgb3JkZXIgd2l0aA0KPiA+ICsJICogdHJ1bmNhdGlvbiwgd2hpY2ggdGFrZXMgdGhl
IGludmFsaWRhdGUgbG9jayBiZWZvcmUgbG9ja2luZyB0aGUNCj4gPiArCSAqIGZvbGlvcy4NCj4g
PiArCSAqLw0KPiA+ICsJaWYgKCFmaWxlbWFwX2ludmFsaWRhdGVfdHJ5bG9ja19zaGFyZWQobWFw
cGluZykpDQo+ID4gKwkJcmV0dXJuIC1FQUdBSU47DQo+ID4gKw0KPiA+ICsJc3RhcnQgPSBzcmMt
PmluZGV4Ow0KPiA+ICsJZW5kID0gc3RhcnQgKyBmb2xpb19ucl9wYWdlcyhzcmMpOw0KPiA+ICsN
Cj4gPiArCWt2bV9nbWVtX2ludmFsaWRhdGVfc3RhcnQoaW5vZGUsIHN0YXJ0LCBlbmQpOw0KPiA+
ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBGb3Igbm9uLWNvbmZpZGVudGlhbCBndWVzdHMgdGhlIGZv
bGlvIGlzIGhvc3QtcmVhZGFibGUsIHNvDQo+ID4gKwkgKiBmaWxlbWFwX21pZ3JhdGVfZm9saW8o
KSBjYW4gY29weSB0aGUgY29udGVudHMgaXRzZWxmIHZpYQ0KPiA+ICsJICogZm9saW9fbWNfY29w
eSgpLg0KPiA+ICsJICogRm9yIGNvbmZpZGVudGlhbCBndWVzdHMsIHRoaXMgd291bGQgbmVlZCBm
aXJtd2FyZSBhc3Npc3RhbmNlLg0KPiA+ICsJICovDQo+IA0KPiBJIHRoaW5rIHRoaXMgaXMgYWxs
IG1vcmUgY2xvc2VseSByZWxhdGVkIHRvIG1hcHBpbmdfaW5hY2Nlc3NpYmxlKCkuDQo+IA0KPiBJ
ZiBhY2Nlc3NpYmxlLCB0aGlzIGlzIGp1c3QgdHJpdmlhbGx5IHRydWUgdGhhdCB3ZSBjYW4gc3Vw
cG9ydCB0aGlzLg0KPiANCj4gU28gSSB3b3VsZCBub3QgY29tbWVudCBvbiB3aGF0IHRvIGRvIGZv
ciBjb25maWRlbnRpYWwgVk1zIGZvciBub3csIGFuZCBsaW1pdCBpdA0KPiBvbmx5IHRvIHRoZSBz
aGFyZWQtb25seSBjYXNlIHdoZXJlIHBhZ2VzIGFyZSBhY2Nlc3NpYmxlLg0KDQpSaWdodCwgbWFw
cGluZ19pbmFjY2Vzc2libGUgaXMgcmVxdWlyZWQgZm9yIGNvbmZpZGVudGlhbCBtZW1vcnkgdG8g
cHJldmVudA0Kd3JpdGVzIHRvIG1lbW9yeSBpbiB0cnVuY2F0aW9uIHBhdGguDQoNCkkgYWdyZWUg
dGhhdCBmb3Igc2hhcmVkIGd1ZXN0LW1lbWZkIG9ubHksIEkgY2FuIGRlZmVyIHNwbGl0dGluZyBv
dXQgQVNfVU5NT1ZBQkxFDQphbmQgc2ltcGx5IG5vdCBkbyBtYXBwaW5nX3NldF9pbmFjY2Vzc2li
bGUuDQpUaGlzIHdpbGwgZnVydGhlciBzaW1wbGlmeSB0aGlzIHNlcmllcy4NCg0KDQpUaGFua3Ms
DQpTaGl2YW5rDQo=

