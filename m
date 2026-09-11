Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 115F7C88E42
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 06:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FF16B0095; Fri, 11 Sep 2026 02:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30F36B0096; Fri, 11 Sep 2026 02:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9536B0098; Fri, 11 Sep 2026 02:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8479C6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:41:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1E8F160707
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:41:01 +0000 (UTC)
X-FDA: 85200533922.18.D005879
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by imf06.hostedemail.com (Postfix) with ESMTP id A2BC4180007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:40:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RUzff3hl;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789108858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OpP4RVmEWuKp0b89EXWlT29yBYutOj/XQd1IkGVn34=;
	b=TxzrWqzhBKc4KMO1DKRLpHmYcIvSfPoNKSij31LgvTN1s91w6ZFW8xQ0l1inlxl97hwpuj
	j/zYDFsieOC1nLsKuE0oSh2sBAnnwNUe2Pg0odOtMxSIxv4IjJYdPmKId2QPNX9dmbWWQ8
	Mh6q1E0FaIbbr9VFNzs/IWZ/aPgLrMU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RUzff3hl;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.28 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789108858;
	b=nBlwvlMBkgPYBjEzsPwAmnrcxZScaL0a/TG7EP+bsGVRGhSxFoXeVGee5BKbHX88ndi6uB
	DNKwFJdqhXVz1e/4x0l7zdCcOnNOppB3wImab112q8MbGj9jvOJUji9gT7Da23ecQ9vqm9
	4PPsZz4Mw9UkULgDw2BcfMxn1qUVgOA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WzJ92hQxxv+pEywr9WQi3hNs+B+YqCcGTOiDcLIFqOuqJRA71nBq6t4hIPGGW5sOGIkx3SyKBFV9XnfZIkXsecnU9fx5FzqHm4B65NSGbxmHIazcjlyPo3RgtrIr1QAJbsjObzTaxa9Zrj1MtBcFNwHf32zyuObeycsW1jut+TesaUAVFeX7lQsvBdFsCnZJad7AvB7sqmKhjyLcISY+9CDZFLCPQBIfnKBFPp4cJUaTMHbRETZ/5ti3Gx9ombpg4OU/02JpQa6dCNaasMt0ycNCx+cI9W0c02WwHTJ4bd1frFwe3tPhUCIrSbIA2UTrvSYaRACSQRZ+atJ8H0t3xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3OpP4RVmEWuKp0b89EXWlT29yBYutOj/XQd1IkGVn34=;
 b=MsIbLH3oP+wwfQ6yMiBb08idfdg8PmG3q/UcgQGsLQWFG6unjyIjBH8Beqveo7LwV3hRuKXUauVS3in1w8umTriDmS1s+jI8/KwWD6nH886V6n6ekwPm352/Pg80EEQA0QSg4WqTV8wk8SSCTm7f3e5TmFuw0MQT75RNSEzh6GosmZENRHGZFyBCBb0wtbhlGcH9PwspLbqXfZ28x+Wg9ojkFKzcw6Uu73rtklJ+Po+u5TJ8BuFBscDGCY7Q/zjSsHfEBi3Rizu1xIweEO4sx/qSrNg7E6vGDJ9ugpVM84zXzktMjyFiBgozKYjSA6uiPbKoYBb+nPrXMAT1/9+ZHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OpP4RVmEWuKp0b89EXWlT29yBYutOj/XQd1IkGVn34=;
 b=RUzff3hlgHkv806JhcjXkcbS/MBy4DFI7lxT2soMl9agtguijYgeAvkQG3tOvpIEyAZYfg9rhK+01L2CMxhF+ZbpziYQ4nTKcfruM4vTf70DkOAPfmpsLkLanMHnhoMlFG863nmZKjqu7VTtI+Eb60CfIoItvzCLY+n9jCB36vY=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by LV2PR12MB5773.namprd12.prod.outlook.com (2603:10b6:408:17b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.14; Fri, 11 Sep
 2026 06:40:53 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0406.005; Fri, 11 Sep 2026
 06:40:52 +0000
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
CC: "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"sashiko-bot@kernel.org" <sashiko-bot@kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 1/9] KVM: guest_memfd: take the invalidate lock when
 unbinding a dying file
Thread-Topic: [PATCH v3 1/9] KVM: guest_memfd: take the invalidate lock when
 unbinding a dying file
Thread-Index: AQHdJKV15sg2STvrekyb2rIxlphFqbbHzK2AgAFbAYA=
Date: Fri, 11 Sep 2026 06:40:52 +0000
Message-ID: <f186fbb9fbb0590390bd226ccb5a45cb071180da.camel@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
	 <20260805-shivank-gmem-migrate-v3-1-00d8bdec4e1d@amd.com>
	 <dedad87b-909d-4d14-b914-ff2e28c414ce@kernel.org>
In-Reply-To: <dedad87b-909d-4d14-b914-ff2e28c414ce@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|LV2PR12MB5773:EE_
x-ms-office365-filtering-correlation-id: dae5d2e4-137f-4b69-c2b1-08df0fcfa00c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|921020|38070700021|11063799006|56012099006|4143699003|18002099003|22082099003|10067099003;
x-microsoft-antispam-message-info:
 KydwV5FvG6eYBI5DdL95U5DcSvbO1JyuSSaLN/id5VJ0rEVEtN4OgkORvJCwbihsYogZWUO8x8QzuAxftSiUvRroTBVnQlzjxKZ10YQQuBwQS3ngkMHIcE6m1atxgl0zHUiCrelWRiCjspr1bz5TNLRIkc40kM38tazlu3I+LIpWPBkqd547wGNHpRkqMTN0zIQXaZvv6Mb6V0xWABJLAvfk6Ja2gDNP/Nd3rqile6MWtBDfXra1vlSh2N6IW4bh1D5q/rWd5zsJuKfqKQD0VS52ZtU6rzPL9lLCe7ahwSiF+WxTjj3IGMR5ZnKlxMBjhI/JRDlRRr0KGw1kt0paMY84iatJx6jbj3vXNXhTgqyrM296r143cUxFXrdY26Sb5WWt3eUQx0VmLTCv8iuD69E+mxqK25rgMF/Ger75DuQTn1fvaCw6LXkjTNQIPAn33LDRUpMfl+ILRvvh6fUnke1l8HmaU8v8a0DzrqVvXM5WZLHQcNHL5OSpRP+3E4qbHo3LuxyH/qGrbE8JjT/HZloyq7+jv5G0mvqR3Geu8vLWfXpA7+bNJNiNyK1lPFqtGSalboLfOXCVuO47EQqrLztDqC8XAvnFfQqmpM4uPkg9heSXNakHbX0MD9+lth9CeN+diGHAK3BGcQ0puMtWHnehklG2IjYF8PZSM0LlnBnceyXmvJpfPIrEJWtRs+i0o1Jama4nw2cTju1sw8DGeU9+7Gx6QFuagpBFoBn0rfMh8zIpbnA0OUswUQoeIjAp
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(38070700021)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U2pGWExjREhlRDNHWUFrTUpsRG12dmh2by9JOFJYR3p6TXlFRWw1ZnFjKzRX?=
 =?utf-8?B?TU5FeWVGNXZGKy9oYVNvVTV5V2l5bGlxN0pjT3Q5VjhHVmJPQ0U3ZlljVG1h?=
 =?utf-8?B?eFZnK2Y0VzBjM1hUbzhUazhwQ2I3eEV2bVoxOVVoNTMxYkZLUEQvQVM3NUpw?=
 =?utf-8?B?WTR1OCtjWDJ1d3o0eUFYUEdnTHlaaC9ZUnA3bUQ1bDBMcW5pb2dNRngxanNt?=
 =?utf-8?B?d3VvYXM0Ync1TlJJTlRWWUdtQnZUT090WDcraUMrMXVWNllDZitKQUhhS0l5?=
 =?utf-8?B?eGZUSldtZHhzN1RvRG92UGErZFBzL2hQZUh3WU01aTJsdHV4Qnk4SDYzME03?=
 =?utf-8?B?dTJuWTY4VHdVbWowVGZIMEpIMGFFWm84QWxxbUJqSXdvczlMbkNRR1ZGMk05?=
 =?utf-8?B?TStXanoxQWVoWGhuUVNaaVJ6a01CSTZsOFFyd1BtQzd2aTJSOTFDL3g1dmUw?=
 =?utf-8?B?QktOVjE2WmRxTzN1ZnJkOVQzbm9CZVhvTGlGMDJyVzIzbVlOa2djeHgvWGFy?=
 =?utf-8?B?Q0FjUjRKUllVMFc1NjVucXI0UGU3QzZaQlpTK1FFV3VQaENqZERlNjVhcHpx?=
 =?utf-8?B?TFhsWVhta0hmRW1kTG1FdVowNlgxaWE1VXZXa0NEOXJQR3ZORjk2cDh3cXdq?=
 =?utf-8?B?WElrcm4vOHk0N2ZMbzljRVJZbktWaHltLzhzQUVYdHI1MHVGL3NFTGNWRUc0?=
 =?utf-8?B?bTlrZTBCWTN5c3RiT0Nqb2FUYklwWXVRb09nRGJYNEdzTzdjU0JZZ3BWM3N3?=
 =?utf-8?B?TnlhR09JeUhLaStRWlpaVmNMdHU4RFJFQzJ6cnY1bDF2eEZtMUdZS0dFc2w3?=
 =?utf-8?B?YXl6MDZNYkE4RExCY1JXZGlYUHVCNkVxT1pmamhqRy9vMC9CR01meXg5K1pY?=
 =?utf-8?B?eXprRHlSQWFGZWVMczlObDdKNFRBU3N2bnd4ODRscnI3TS9CaDZFTENJamRq?=
 =?utf-8?B?MlVWY09IUUY0KzJTVlg3TlVRTnRLN1lvVjBaSmZPNWdzN242azFHbVJScVRm?=
 =?utf-8?B?d29adG5JNUpENDJTdVlSdkQyVEFSY2pVZ3pVcU8vcWpSKzZiVlUvVEZFZTkz?=
 =?utf-8?B?K3pJMkdPdkdWSjJvL3lwaHlOdnVxRDBzMWVaQmlqbFVOdDNBSFJoWWYvdno2?=
 =?utf-8?B?dlRuU3ljdnJaOWFaWUkwOGhidmo3NmowYjdodEpjOG1MVVV3aHp0a3lSbFdH?=
 =?utf-8?B?NkxKNWQvMHhpQTVzWUFlMWxWTVdUeG1zRmwwREh3WXdXbTFjQUQvWUcrTCt5?=
 =?utf-8?B?U2QzeDJJQkV1cDMzNVBta1RZd2tiNDdGRi9la0tYeFQ1cXB6VFU0N01KQXY1?=
 =?utf-8?B?c1NJR1Y4N2VhdXFub2RMSm5NYm56bEcxS0VWcEljQ1hyZzBVUVoxek9oRVgw?=
 =?utf-8?B?ZUhORm1CUFJEeFFsQ2h5dlJscFgrZStCZnExR1NadGwrd1dRZ09CM0txOUlJ?=
 =?utf-8?B?R09xK2EydWxFL0FqNGtBUFZoaDVBbnE3M09UZlY5ZnRadG4zam03ZHhBdExa?=
 =?utf-8?B?UlA5UU9xQjh3bnZYVDVOS1AwQkxMVlpta000NDFkQ0RDT0ZDa3ZjamVUNGlJ?=
 =?utf-8?B?SFgxMzR5L0VXNkZ6SlRKdWxPZjZrVlE5Mmo1eDlrcmxOa3hWTFJCeHU5dGN1?=
 =?utf-8?B?NTdVVmdyQ1hlMS8vS3BpUk1rZ2xNV2Rwby83N3lJZVVZMDhrbmF4ZEFXT1RZ?=
 =?utf-8?B?VXNrSWFhNXhFcjkyZHA4SGRyZlVHc0R3TFNDdnFmNUROTzQvZkhoQlA0MGhP?=
 =?utf-8?B?bnQrNStyQTdQb0M4ZHE3aGVIZk41RVZGcnB4RG8wOVVyVjYrNjJVUURpN2Np?=
 =?utf-8?B?dTZpWTVkdkFzNDltU2Z3WXpXeCtXYVhPenc1aEFBNXZiTUNOaUVqbW0rejRl?=
 =?utf-8?B?b21EWFNRdTR4SHVpSXpQWlNzbHpRQnMwUG04ZFRFcWIvV29IdUFuOFdPd1ps?=
 =?utf-8?B?NndiQTQ4YSsrSVRlUDRtYW1zbmN6aEE5dms3T3lsbkQ5amoxemhpWWYzL1hN?=
 =?utf-8?B?bkRIMHZEVGdtSXdpZzZ5VjV0Mi93MlEvYW9MRDFxdFNFdVYyYXZPNU1NZmZU?=
 =?utf-8?B?aWsrZWdnSnpFektwVi9EODNqQzNrOWE2cGs1b0VyUVVqZEsvMVNvZUpRVXJk?=
 =?utf-8?B?dDUrMEQxSzFTTXVRTXdmNnJFMEZqUEt0VkxOckNOOHB6YnFJb3VCdEczVkdQ?=
 =?utf-8?B?ek5XTDhYMHRGMERvV1FpZGNhQzRvb1RRZTB0NkZ3WDFjcndUY3hDam1jaERJ?=
 =?utf-8?B?LzhkOE13NFRKSis4TW56TGM4VWtqdE5Jalhadm9LQmhGaUlSUjZRVFJqUUhJ?=
 =?utf-8?B?NXpKTTM1OW1EanA1U3FTdVdsOXcxL2VDeC9RMHlxVWhmNlJYOUhGQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB1C65BD1B891541A0217BA6EF413C97@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae5d2e4-137f-4b69-c2b1-08df0fcfa00c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2026 06:40:52.7493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2p/08LSyMI8UYbnIjD5oGCRvHfUo1VNGZtN/1XvfwTv2Sv5mAPNPh+T2a6qKCQm1cPY5t3lNFZVYYPYevDs2kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5773
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2BC4180007
X-Stat-Signature: t4px7n371o7dd7n7n8ha7dhd1p9uiknc
X-Rspam-User: 
X-HE-Tag: 1789108858-126942
X-HE-Meta: U2FsdGVkX18AAdkRyhkaR94tvArsIr+51SmQAEztoDhOvbhVntM1gnMj+xBC4vbt2e7tKDTpImMwaef5/HW+j4Ngm37ebeTsGMbh9pAzE4giiqIaNlWaq2y5kcwhBh238rxsRme8ZWGTQm577QEJP7r+RvqY1hZLhuFW9fedsCpb7yBPqhzKNJ9EkyneHVltqRE4dsRoPlK6j1IqaKYbYPjEU12oU4ptOZDsINs8JtHiPpL3gDcVBymud/Ae/ERC6Q4Wc6HICwbq3vu2v7axolhV1FANqiObYj6ljJ7zlWmleExbkNreCR/V86Fy6/wXdBBk3dQHdSTy7NrDQ34TK/hAxjF8BTKpyYXmtqvdyGFOdPPqI6lj8pv2KpDSPuX5wrkg3PBpF7h5F1yZKMMLaS4EZaXdkqg3W6Tb5jOPoNT9uES8KCG7IZj7UnJ51Q0tzBn0WLl15ZToEpEGCejCswIeb4CbabFG1XAGd1O2mVSL4ARj3Cs+i0JDjSR4YUMMLVD+HkhnpJQ2c5z15pbcgwACzkHp4FtddXGRBp7iW6S2uQkuOZl5PDw8W7xXeiFvzxWtQeIdgA+eytQR4EQ9EUt0qt1psIvUVysLHyfWtd8VNdE2OCHjdLRJOCbC8qI1wjMg2KZvH+bRYyT2yR44jlmaAawNFZPlqOITNA1imj4IEmmJs3fFuvdB7BHAkXKNJ8QMUAJF5Vjbxk6+yF/4AeD3COhbwFTQyuHTJoZf3bZnKWVkOFZS0F/YlMCHFeVvuiiMGXi2TAWaPVlktgxds0Xy1T5XNcZhFvhz3iaDJCaG8mb+JwVo9/ajHjKA8TiJyGuoztUmQeQWXICEJvgV+nqpPLH7Zfrjt2fWt33qasrjIhQiU2PeqgbhcST3E17yGmWbU1kDZizSxvEb6UzVQHTZNlXVxaQYj2i7AtaPvgsDr7AKqXcoDqzTd2C5sujv97dGEULYtE6so5+HWtE
 wyuBKDSv
 sX/jfshp18snk3vFhP22lXcwyhsKc5SDgdybUuDS3RWgq5AZGB1E6j7dTiGsn7sz2czaaH/dhaQxPgy1pUYa0AztM+6rzmmoVkYCVEj263ur8kqTjTmALfRVgknbFSMnAr1BkhUvCU7YCX8lCv2Lhsoo0p8vllTODY167l60VRX/GSIxX0OuWT2d80arMhMyHpWXF44Ak+XbNmeG8NgpFltY5X4UJ+wG2jHedhVMU2DZSRIc1slwE3RmZtJ9C1IZFKNYevbboRtv1lbqUcwo7OaqYFQctWdYAebjCAQVRiFz6P154kO7yAF54p+SydvVF4BlRbPFXXlZbeo74fXuEJDNckYVubOmcw1L+9G52G1HzsmRAlmkZYbqzsUEi6FEbEeB5D2Z1qBz+bFuGUoHMf4vDKGuIJNJ4m3Qj1E+99G0B/kbsfN6RVUrYFHQ2GJnPYnLpUoZZyobGxG40ghOF2v49u0OvZxoZouDCS26AnaOsbOzY8LZNJWSwGofr749eytkRW3jSHQQQlu3dibhQxh+cI/H9GaMlJyn/YFtycQ91VDUdkbxlCPvAmvqZeZk6z2P8s8lTBODOra0RVdxPcY2fBgIjHv9lntfOMgj/WYufMPP+PbOKeK88ZK080A9JAEqBmtrX+L0q8gI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA5LTEwIGF0IDExOjU4ICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gOC81LzI2IDA4OjQwLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+ID4ga3Zt
X2dtZW1fdW5iaW5kKCkgc2tpcHMgbWFwcGluZy0+aW52YWxpZGF0ZV9sb2NrIHdoZW4gdGhlIGd1
ZXN0X21lbWZkDQo+ID4gZmlsZSBpcyBhbHJlYWR5IGR5aW5nLiBBbGwgb3RoZXIgcGF0aHMgdGhh
dCBtb2RpZnkgZi0+YmluZGluZ3MgaG9sZA0KPiA+IHRoYXQgbG9jay4NCj4gPiANCj4gPiBrdm1f
Z21lbV9pbnZhbGlkYXRlX3tzdGFydCxlbmR9KCkgY2hlY2tzIGYtPmJpbmRpbmdzIGluZGVwZW5k
ZW50bHkgdG8NCj4gPiBkZWNpZGUgd2hldGhlciB0byBiZWdpbiBvciBlbmQgS1ZNIE1NVSBpbnZh
bGlkYXRpb25zLiBTbywgdGhlIGJpbmRpbmdzDQo+ID4gbXVzdCByZW1haW4gc3RhYmxlIGJldHdl
ZW4gdGhlIHR3byBjYWxscy4gSWYgYSBiaW5kaW5nIGlzIHJlbW92ZWQgaW4gdGhhdA0KPiA+IHdp
bmRvdywgc3RhcnQgaW5jcmVtZW50cyBtbXVfaW52YWxpZGF0ZV9pbl9wcm9ncmVzcyBidXQgZW5k
IGRvZXMgbm90DQo+ID4gZGVjcmVtZW50IGl0LiBFeGFtcGxlLCB1bmJpbmQgcmFjZSB3aXRoIG1l
bW9yeSBmYWlsdXJlOg0KPiA+IA0KPiA+ICAgQ1BVIDA6IG1lbW9yeSBmYWlsdXJlICAgICAgICAg
ICAgICAgQ1BVIDE6IG1lbXNsb3QgZGVsZXRlDQo+ID4gICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIChndWVzdF9tZW1mZCBmaWxlIGlzIGR5aW5nKQ0K
PiA+ICAga3ZtX2dtZW1fZXJyb3JfZm9saW8oKQ0KPiA+ICAgICBrdm1fZ21lbV9pbnZhbGlkYXRl
X3N0YXJ0KCkNCj4gPiAgICAgICBmaW5kcyBiaW5kaW5nDQo+ID4gICAgICAgbW11X2ludmFsaWRh
dGVfaW5fcHJvZ3Jlc3MrKw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAga3ZtX2dtZW1fdW5iaW5kKCkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgZ2V0X2ZpbGVfYWN0aXZlKCkgZmFpbHMNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgc3RvcmUgTlVMTCBpbiBiaW5kaW5ncw0KPiA+ICAgICBrdm1f
Z21lbV9pbnZhbGlkYXRlX2VuZCgpDQo+ID4gICAgICAgbm8gYmluZGluZyBmb3VuZA0KPiA+ICAg
ICAgIGNvdW50ZXIgc3RheXMgZWxldmF0ZWQNCj4gPiANCj4gPiBtbXVfaW52YWxpZGF0ZV9yZXRy
eSgpIHRoZW4gcmV0dXJucyAxIGZvcmV2ZXIsIHNvIGd1ZXN0IHBhZ2UgZmF1bHRzDQo+ID4gcmV0
cnkgd2l0aG91dCBldmVyIGluc3RhbGxpbmcgYSBtYXBwaW5nIGFuZCB0aGUgZ3Vlc3QgaGFuZ3Mu
DQo+ID4gDQo+ID4gVGFrZSB0aGUgaW52YWxpZGF0ZSBsb2NrIGluIHRoZSBkeWluZy1maWxlIHBh
dGggdG9vLiBUaGlzIHByZXZlbnRzIHVuYmluZA0KPiA+IGZyb20gcmVtb3ZpbmcgYSBiaW5kaW5n
IGFuZCBsZWFraW5nIG1tdV9pbnZhbGlkYXRlX2luX3Byb2dyZXNzLiBUaGlzIGlzDQo+ID4gc2Fm
ZSBiZWNhdXNlIGFueSBjYWxsZXIgdGhhdCByZWFjaGVzIHRoaXMgcGF0aCBob2xkcyBzbG90c19s
b2NrLCBzbw0KPiA+IGt2bV9nbWVtX3JlbGVhc2UoKSBjYW5ub3QgbnVsbGlmeSB0aGUgc2xvdHMt
PmdtZW0uZmlsZSwgdW50aWwNCj4gPiBrdm1fZ21lbV91bmJpbmQoKSBmaW5pc2hlcy4NCj4gPiAN
Cj4gPiBSZXBvcnRlZC1ieTogU2FzaGlrbyA8c2FzaGlrby1ib3RAa2VybmVsLm9yZz4NCj4gPiBD
bG9zZXM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI2MDcyODA5MjAyNy4yMjVDRjFG
MDAwRTlAc210cC5rZXJuZWwub3JnDQo+ID4gRml4ZXM6IGFlNDMxMDU5ZTc1ZCAoIktWTTogZ3Vl
c3RfbWVtZmQ6IFJlbW92ZSBiaW5kaW5ncyBvbiBtZW1zbG90IGRlbGV0aW9uIHdoZW4gZ21lbSBp
cyBkeWluZyIpDQo+ID4gU2lnbmVkLW9mZi1ieTogU2hpdmFuayBHYXJnIDxzaGl2YW5rZ0BhbWQu
Y29tPg0KPiA+IC0tLQ0KPiANCj4gVGhpcyB3YXMgc2VudCBpbmRlcGVuZGVudGx5IGluIHRoZSBt
ZWFudGltZSwgY29ycmVjdD8gKG9yIHdhcyBpdCBpbmNsdWRlZCBpbg0KPiB0aGlzIHNlcmllcywg
SU9XIHdoYXQncyB0aGUgZXhwZWN0ZWQgcGF0Y2ggZmxvdykNCg0KWWVzLA0KSSBzcGxpdCBpdCBv
dXQgb2YgdGhpcyBzZXJpZXMgYmVjYXVzZSBpdCB3YXMgaW5kZXBlbmRlbnQgZml4IGFuZCBzaG91
bGQgbm90DQp3YWl0IG9uIGd1ZXN0X21lbWZkIGZvbGlvIG1pZ3JhdGlvbi4NCmh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2t2bS8yMDI2MDkwMS1nbWVtLXVuYmluZC1maXgtdjItMS0xMmZlYmUxZDIy
MTZAYW1kLmNvbQ0KSSdsbCBkcm9wIGl0IGZyb20gdGhpcyBzZXJpZXMgZm9yIG5leHQgcG9zdGlu
Zy4NCg0KU2ltaWxhciBmb3Igc2VsZnRlc3QgZml4ZXM6DQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9rdm0vMjAyNjA5MDctZ21lbS1zZWxmdGVzdHMtZml4LXYzLTAtN2E0YmU1YzFjYzhhQGFtZC5j
b20NCg0KDQpUaGFua3MsDQpTaGl2YW5rDQo=

