Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36399C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCC26B0096; Fri, 11 Sep 2026 07:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2316B0093; Fri, 11 Sep 2026 07:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018ED6B0096; Fri, 11 Sep 2026 07:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B806D6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:37:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 217ABA0207
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:37:42 +0000 (UTC)
X-FDA: 85201281564.28.6778A0B
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1551FA0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:37:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yFXWBvXl;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.28 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789126659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+LluMcVSXRAiFIKIAwbvNy4flUtA3RVmmij6cUH3Do=;
	b=hLiWD+JfWWsoksDhsBPiNyW7924Q4nS2/gBY88BsKzx2vGNzuHjEjOuTttY+IdZdVtSwbc
	qaSU5z6hSyubgGUgt4bT2YmPprr4MNJ4rFfEGi2x+Pm49QtF5Ajz1GVbW24T1OSxk73ln4
	nZrDfiZkuR33b8jXEFUoywedEF8ExUc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789126659;
	b=p7fCmEi7APmCceThNEo/L78daRbXqwLbSczeJY8Rb6GldVzqef+Zf+L6HK5/uktXs5U93V
	BKMuN7T8ZsLbFu5lu2cbcD0g0603adTvEjc5G6FEYLGvvDPN1scFmNSr1qxocuYXxTVGGx
	Lye/s7W7Ipv4j1dhFlJRNJRmcewX6FU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yFXWBvXl;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.28 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GhCTgb0MIyIOoFV0dpJ6d/vTLcjYlfxoYcLb4v0bkDTXbF5dlNuXN7pwBMZ5O/oni59J7obIDB8DyqBeTSKJ9YVZZK5IFK/ZZGhGcsVwH/oXOfpQZHAvq7VbiXFr0PjuLlkzrpqbDm0rTp3eVrhnqV5gx/dvQFWmjpqHrJZb67WzPgZjoueGFF9uN7SOKcIgAZ7uVC5fb4Awj/pR1mUGpxqIv8teW0glOymn7M1jnTtt+xZFVBSnxTPcmlNpMI9p4vxYC0wSEv3FLE2jzqv+yvxdlyVGdHCuDC8fcLK4roWDkb+VmYAelgxT1hH8bK9cg4gUz/1MkqymsB5qz1Aukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+LluMcVSXRAiFIKIAwbvNy4flUtA3RVmmij6cUH3Do=;
 b=RzCQlzyv4Rsja3Aqcyf4g7PefWkQpAiIAm2R2cAJUR0TS1z2LzbUhTaUsYQCOkFVqmIdOUjylEzlHc07I5qv3twlqjWH8jiPy+ctXEj33amh9X5M0LRFIir3v5Uyy6494qnC/h/ArTYXLrV+HaBBHt52J0A/UT6kKw2VzCI6i0v+CDoA/uxAyFKeVdsJOl7lhkLeT+MS6d3nG15pKOdJW/kItTj1GExhagRPBDV5+11Lp33LU/Uw0Utsoy5BQX9yJ5JUPmoVrRoRIEgPbTeTEQplbbnZtZ/oXEs/D8nzITFc0raeu1xrRqKPEh0t7dqTbgds7z+OikDkDF7Yy7rqvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+LluMcVSXRAiFIKIAwbvNy4flUtA3RVmmij6cUH3Do=;
 b=yFXWBvXlsjehZ8EnzTAZUd07mMXMdFXFbXmD5Mzacvd5BORvinXr98BBdQvZAEYTQlpZ1qscn6fwvwP1t1inN1kPOAtWkAzSk9O4CYP7U7kID069aHlJD7uF2xwkhM8agkys7+uekjw+zOnMCRT+X5Uag9ttP8uPL+SrzXJWv4k=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by BN7PPF9507C739C.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6da) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Fri, 11 Sep
 2026 11:37:29 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0406.005; Fri, 11 Sep 2026
 11:37:29 +0000
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
Subject: Re: [PATCH v3 0/9] KVM: guest_memfd: folio migration for
 non-confidential VMs
Thread-Topic: [PATCH v3 0/9] KVM: guest_memfd: folio migration for
 non-confidential VMs
Thread-Index: AQHdJKVsctSiOu4P3kmuA1se5lvKxrbHzHmAgAGuE4A=
Date: Fri, 11 Sep 2026 11:37:28 +0000
Message-ID: <4f190c4bfd90ce93b6ebf898fc39371f8aa8e6ea.camel@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
	 <0b8c746e-544b-4ec0-91dd-d5e10e1920dd@kernel.org>
In-Reply-To: <0b8c746e-544b-4ec0-91dd-d5e10e1920dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|BN7PPF9507C739C:EE_
x-ms-office365-filtering-correlation-id: fb542f87-fd0a-41a7-5f37-08df0ff90f6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|921020|6133799003|22082099003|18002099003|38070700021|11063799006|4143699003|56012099006|10067099003;
x-microsoft-antispam-message-info:
 OpU+tALy053nCp+hAGBFGUbKWJQQcP5H6a1Y/VRNHGCad9xn5MMM5rHDGIroFLhHZxAQ7Pv8WP+LH7DttTMoL2aIEfJliXdrOxhhp8h403THhesKNKgQt2fJBRAAJMdCsisC6eCxUewH7d0Vj1guhMOpLe0Zay9XVkYjxAMAHW2Rgao5pOvdzZ1IZskCt70tt/yM5AcdZYjn7ZUOzYu4dTK+8NrZSaXeJzKF8WC0dplBnLfZmm4B3pqRrVRmYgGIZQ2yc3NDKGhv1ZUDd69yev6YtgIYTbHjWJ6fRWW4bGf4Jur0N2tQlcDRfgh7XbUAVKg4svpXAfrZ8njIhLhqRHWFYUqbVWHLXqx73c/tKQB64+wQxsIAbXk1gQt+PwY2DhObxu0F8LgOztU+NdhMxRJtZyNQAOR6QQH7hwYjE1zs4SllL0tzbSLzRm4TQ7+F3ZTBxliVbrJ9XPbILVrjYnU4JIMWRjT1Xs+8uIrLIBMfD7ln/pa2iYRj/QtFdcyacSDROpp6uJgOKva92xZEgy3AOfaKHADw2GnNFsk7qBNBSiWx6lEVCdsLCdYk6Pjs5QO7G2ohcQMZBitThLi9k7Vgr4a9REAJgx5MMUFpJYoTarWC5a3ED44WiwpveUWM02aColq8lRJhJQohSoGUiK2JtbkA+JSNMsz9mdr/S2YT4XG6pXE/Yr0fR1yl1Wc/
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(921020)(6133799003)(22082099003)(18002099003)(38070700021)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YUVia0VBVS9GL3lITlY5dFgxMWFVb3N5OXRYMngyV1k5OGV2NHNDM0x5MUxZ?=
 =?utf-8?B?YnAxT3VlamJzU2Zyd0MvRTRLOUpRU04wZTVLTElqL1JYbmUwNEl2cUJXdmNh?=
 =?utf-8?B?bnB6akZVRzhWS2d0d3FiRE5ZdTdFcmRyZFA3VExsajRPR2d2TXdMc1JjTWJO?=
 =?utf-8?B?UTVWMVFGTm1wME11VWZXc3dzMjJiQkl4UjVLWDB1R1FjblB6V3J3OStTMFF4?=
 =?utf-8?B?dEZpaWVlditFeVhIbDJNbUFHT2lGdFI0T2RPVFhBVVdvWk1WZTcwMDcvU3Fh?=
 =?utf-8?B?YXc4MEJFa21oR2pyVC8wUlhrNm5OVVVxdUJKSzIyUld2RUt6Q1prcWVkTWlX?=
 =?utf-8?B?UnhIRXpKZkxRTGJUMVpZZ2tjT2wwRDN6RDk0VGxpWXFrd1loSzdyOUQxeFZ5?=
 =?utf-8?B?TmlSbDdGU1pjTjVMUitjRGdEaEFoQmg1cDhTajcxVXljVjU1THh3OVRRWElt?=
 =?utf-8?B?TmE1QUdMUDZxUDl1TmNSY3g3MTRrUC8raXRoQktvT05NNGpJVm5MeUtZV21Y?=
 =?utf-8?B?aHhtK0IxUi9nL2VOS3hVTWFLcEdTR2hDczNJK1FjTUZ3N3JucHRxODc1NHZL?=
 =?utf-8?B?aVRnRXUxcGFpeTZGaTZvOG9CZ1ZzMjVqZTFxaFpXaGI0TFVWWjAzTkp0Y3ky?=
 =?utf-8?B?Y2N3UkZVdnhXNk1aZnU5Mmt2QjNudkM3TGNpY0JBUTcwT1dsbFppRUtpS1Qz?=
 =?utf-8?B?RzNYakFDeHc2S0x0VGF3eFlzWmN1T0lDNjFDdmxteVptTGNjdU51QUhuSkxM?=
 =?utf-8?B?NisvbHcxU1RSSTlJTWtIdXVuZUFHcWZieStTejdIREtEMnMvNVpHZUgvSGtj?=
 =?utf-8?B?VFVNMmErekNCRy96TjZhR1IwM1NPcEU0Y0tSWlhTOTZOVktPRFU2anUzS2R0?=
 =?utf-8?B?OFBwcDA2eXFOeVpVQ0JWck11bE9rWHVCaXBpR0RUNy9nTXpJbWxUdDBxZnVB?=
 =?utf-8?B?MHk3eDZLazdaZGQ3SGs4SndKZnZKb2FTZmdndDcvY0wzZGRlTDEvUWd0VytS?=
 =?utf-8?B?VEpjZXNpS0xGUEdMUlpiUXF2SVRLekROMERiNTJCK1llQytweWlPU3BFZEdw?=
 =?utf-8?B?Tkh5YkJzNjFIQ085czRiWkMxa2VVdVlrakFVRkk3T0RoaFI1TkdCbWsxU3A3?=
 =?utf-8?B?QWpUa2lVcGFsRjFGd2oyb2pSN0o5VjlpMGFXaDNkVHQ2R3lqNnFaZGZZQXVG?=
 =?utf-8?B?WjZnMU50YWZLMnRkTVpPN21RekY1b0lhUjNqOFlXZW91K0xlTXdQUi81a3Ex?=
 =?utf-8?B?NXJBa1NIWTUvKzUwb2RnWUdvcU9HRGZsbVlNUjBoVDdkWWRkeGcyUEdHMit4?=
 =?utf-8?B?ODdpbCtSTXBOZTdBN2p4RERkUTViSEZqV0krZDhiWmpWdkZWdk94L0JRbDhy?=
 =?utf-8?B?dDRHTGh5enVneUc3eXRPbXE3aUd2dnFCaisySEVtWm9oQVhQQkQvMW1wRlBO?=
 =?utf-8?B?RVVnVG9oRWVPMm5Lcmt3Zk9hT1R0V1hHcVdJaDN4bDhySTI5dUJPR2VWeDI3?=
 =?utf-8?B?aTVVdVVTaURnZzVOd1BUSm9XWm5Qa3d1VXhXSnFwYmo0RnpMRDNYQWZ5M1M4?=
 =?utf-8?B?REcyVkREMmRKcUhGR1pPSVF2aWlyZE1HNFVzdGNtRm83Y2J1cnBYSDUyaWRN?=
 =?utf-8?B?UmVndHBYOVQrMGFNUmk4Qnp4a1Z2TDNhMTdNQzdkZXp1Z3VNeXl3czVUcktN?=
 =?utf-8?B?K3VkUDBqem5zdGwvaEZPMEtoSU9UaGlBV1ppS0N4dTZEQVZrOGsvVmYwc09j?=
 =?utf-8?B?elhvVlVsNlNia09lWGkyTWp6T0ZMTUlxTDRFd0lkcHcvaVhXeHNxWVZJaWdT?=
 =?utf-8?B?eHd2SGVoTU5ZbndtR1RrVWM1NnBIMkt4U2JUK3dNS0NtOEdub0haek9EZncr?=
 =?utf-8?B?d2Y3L0V0VitwaFVBYmF0VWMrYlYrd1JSYVlCZHpBVG02OFhGaHMrV0lNZzFy?=
 =?utf-8?B?Q3lVN2tHNEVHd0FOQzBqbjhSYmR2YWxUdGZna3NGV2txbzhaMWpCTzlpaU8x?=
 =?utf-8?B?eDBBSkZkdlVzQ0VZdElYbUU5N1h6di9jbkE0clRrTkJpWEplVmVSWVpnL3Rz?=
 =?utf-8?B?QWcvSDQ1bFpmQlZJYk5HNDZxd3Z2Qlc5OUtyY1NGVGEyaFZHRDdqK1k0M0Nj?=
 =?utf-8?B?WjZWUVhQNHFFbTZBRlpHRFFjKzUxZTJJQjJQRGJxbDBtVVlXSTBObGR5a2Rz?=
 =?utf-8?B?OXlGV3NsY210NWFza3hiTmgxcnVsc05XTjdqNmtSZXFZSzc0VTdtRnRGRi9i?=
 =?utf-8?B?cThKbXNybmxPVkEwSCt0eHNPaHM0M0wrNzIrMlRYQ3RQVEZjVXlkN3ZUWXhY?=
 =?utf-8?B?Z09uYVQyczh2ajJLdW1FZFZ2WTEySEp5OGU5MklBdGM4N2MzTStMZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8F764A7112A6A49B8C3C4C267BC7DF9@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb542f87-fd0a-41a7-5f37-08df0ff90f6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2026 11:37:29.0087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h4C8e+NBEBG6RgKMOUaoMLzAAgliW2vgSstx0nCLLTqCKrN6xs89HJbl6g0ZtRP9ayHQ+m126d84Qznl6qoZeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF9507C739C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1551FA0004
X-Stat-Signature: 1gawcrm11nnp6qd4aoksiz9rnqq7jsy3
X-HE-Tag: 1789126658-922536
X-HE-Meta: U2FsdGVkX1/O0t5h2zZpUoiHRGp+tcdONclE0aR7jQ9ydUKZEOzQYsclEcIk81beo2OdOevPS+/gGYpFH+VbILlaNEXabSsyNQvC6gqZJYDHXaI6qB3NdubAEW5qco57ZHrkOfhUC7mJl5Ou9VqYvNBIrjxYbC3nmnyOMmk/RttdGy9AN4neA9kMQeR8Nt9+CkxwgKyeisfmuIgo246qOvgbdtd+vLzf852SxW9W7UY/7x/sjxOCi6hy9EtLE6C2t0DY6SYipXo8OetV+tg7bmDVB5sU+c8at5rt3Miu8PFsfCNozcl2xy+k/nDtYciLKGcrnX4ClZjdO0dlUrpQSuuPqQH1T0pI5Cdk6P33ScMobL6N+hgA+6bOf80U3ifvYOr9bIKl9QRhr162BE15hf4ZTe+gPffaPcp3XvUw9T8ymIsE1jmOXLWmx5SVSuFnxsdpe4o1XKX3ClcKlhwrJ1ZAMzLYSP2LirJf4WOz6CDJ5hRil5eJYwXVyh+Ne85F+imd2sEFiqm/TUypmZs8ogK9XuV75CWB6Ci+2N4epGVwATEIs35iBNSQFypM9/H5SE3cpu0/89HlzXZThNn0tUkLepj0eON9hIYb2GpUycHoquG19tCTgV3YAulpOjUioQ4upOQlPJiPDXRXh2kHFm/nou8nLGmruXM9YLHFbC6PSBV2Tr/rCYh9uvfa1em/vlH8a44Va+i4zc2RRk/pt5Q81qzCG7kNJVmB24tiU8CuEuQL9V4W8W8tLAttXyT3Eencd26zkfPteqET2e4lHQ1Fs+AVTy78b751OrG0bkw7xxi7GIPYksSogMTvA2bWRQnGuMe/3B1kr6FcKkppd2r2uQFqS22lW+46yvM9ED5JQPGAwyTOio0sJcIcteSUn+7Qg4S/Y+zfZP1/zRB9xUeUgpDkI6dF8v6HTegdOQOB39n8v2XY/bi4o9Vywk1clR9+piN+uxCjfq+WM7v
 3p0XLh/1
 KWzR4TKT480aHZI/QFVfqdBN9iAow+SjXLoHZp7CR9TFIJoTA+MNpA3qAoJp47hvNuatZF2n570bZXZlhXI3ZlK2jtoL7abkJ/s7b+iWYh70hq2661ckbdsTzO5VcMcJP0AIPsVyU5fy+VwNMZIo/c/z2gs1I7tr7WwMC6P140QdR5ItqRzMpER5n62UmYHf7ygEPB3w9K6rdqDOWyY/Ha26XiXMf9/ZUJNFWufr8XoakNHNgDezUeN9qZqOk0ejUNIBxhm+R+3D/4NpIXqbQ6Oo/pITo8jJkajFeA78JY12ijmvFiAzNrtkH+kSLgrYWo0VpmAv1b+Nyd8Mc5YAroHzp9B/diNPIwVFTK3FIptOmpyWgX2pmRP6eHOFSZf0aobXN4wybUD+rzLL7FvsrUXLuHKkIOJJyJ9LC61MDXmeEVsR5VdK1zBz+R0k+wGrgVjFqGrFy+iv8Z9ID7poPbieXmrszVRFww4NZLzIIQab8lHbL/UlUz9NO0YlUO9oW1bh2honb6pJYyMknS8YmHRaEkOGdF9lvg5IDqLU50MvKOceZbdt+81NqExzBVgQh4nHHlFndLSK7NaXIyJ89OeKl24F9bhtD0tildDcD/pU6wyn1X1vGsZuASPT04izv7YhksV6DwV5YbFpPoBy5h6Gb0RKJ+cMiz1NuT/1pgh/RFeBVBxsllnOIGJMfIOBAMisLyKgyxLBQiQas63q46+nHam0swMd96F3Gey4DoGeHDKLndQb0zuYjKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA5LTEwIGF0IDExOjU4ICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gOC81LzI2IDA4OjQwLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+ID4gZ3Vl
c3RfbWVtZmQgZm9saW9zIGFyZSBjdXJyZW50bHkgYWx3YXlzIG1hcmtlZCB1bm1vdmFibGUsIHNv
IHRoZSBrZXJuZWwgY2Fubm90DQo+ID4gcGVyZm9ybSBtZW1vcnkgY29tcGFjdGlvbiwgb2ZmbGlu
aW5nLCBldGMuIFRoaXMgaXMgdW5hdm9pZGFibGUgZm9yDQo+ID4gY29uZmlkZW50aWFsIFZNcyAo
U0VWLVNOUCwgVERYKSwgc2luY2UgbWVtb3J5IGlzIGVuY3J5cHRlZCBhbmQgY29weWluZyBpdA0K
PiA+IG5lZWRzIGZpcm13YXJlIGFzc2lzdGFuY2UuIEhvd2V2ZXIsIGZvciBub24tY29uZmlkZW50
aWFsIFZNcyAobGlrZQ0KPiA+IEZpcmVjcmFja2VyKSwgd2UgY2FuIG1pZ3JhdGUgdGhlIGZvbGlv
cy4NCj4gDQo+IFllcy4NCj4gDQo+ID4gDQo+ID4gVGhpcyBzZXJpZXMgZW5hYmxlcyBmb2xpbyBt
aWdyYXRpb24gZm9yIG5vbi1jb25maWRlbnRpYWwgZ3Vlc3RfbWVtZmQgYW5kDQo+ID4gYWxzbyBs
YXlzIHRoZSBncm91bmR3b3JrIGZvciBtaWdyYXRpbmcgY29uZmlkZW50aWFsIGd1ZXN0X21lbWZk
IGxhdGVyLg0KPiA+IE9uY2UgZmlybXdhcmUtYXNzaXN0ZWQgY29weWluZyBzdXBwb3J0IGlzIGF2
YWlsYWJsZSwgdGhvc2UgVk1zIGNhbiBiZQ0KPiA+IG1hZGUgbW92YWJsZSwgdGhlIGNvbmZpZGVu
dGlhbCBmb2xpbyBjb250ZW50IGNhbiBiZSBjb3BpZWQgc2VwYXJhdGVseSwNCj4gPiBhbmQgdGhl
IGRlc3RpbmF0aW9uIGZvbGlvIG1hcmtlZCB3aXRoIEZPTElPX0NPTlRFTlRfQ09QSUVEWzRdIHNv
DQo+ID4gX19taWdyYXRlX2ZvbGlvKCkgc2tpcHMgdGhlIGhvc3Qtc2lkZSBmb2xpb19tY19jb3B5
KCkuDQo+ID4gDQo+ID4gVGVzdGluZw0KPiA+IC0tLS0tLS0NCj4gPiBIb3N0OiA3LjItcmM2Kyhj
MjFiYjQxOTM4NikgKyB0aGlzLCBBTUQgRVBZQyBaRU4gMywgMiBOVU1BIG5vZGVzDQo+ID4gDQo+
ID4gLSBLVk0gc2VsZnRlc3Q6IGFsbG9jYXRlIGZvbGlvcyBvbiBub2RlIDAsIG1pZ3JhdGUgdGhl
bSB0byBub2RlIDEgYW5kDQo+ID4gICBiYWNrIGFuZCB2ZXJpZnkgcmVzdWx0aW5nIE5VTUEgbm9k
ZSBhbmQgdGhlIGZvbGlvIGNvbnRlbnRzIGF0IGVhY2gNCj4gPiAgIHN0ZXAuDQo+ID4gDQo+ID4g
LSBGaXJlY3JhY2tlciBbMV06IGJvb3RlZCBhIG1pY3JvVk0gYmFja2VkIGJ5IGd1ZXN0X21lbWZk
LiBXaGlsZSB0aGUNCj4gPiAgIGd1ZXN0IHdhcyBydW5uaW5nLCBmb3JjZWQgaG9zdC1zaWRlIG1p
Z3JhdGlvbiBvZiBpdHMgZm9saW9zIHZpYQ0KPiA+ICAgbWlncmF0ZXBhZ2VzKDgpIGFuZCBleHBs
aWNpdCBtb3ZlX3BhZ2VzKDIpIG9mIGd1ZXN0X21lbWZkDQo+ID4gICBwYWdlcy4gVmVyaWZ5IHdp
dGggL3Byb2MvZmlyZWNyYWNrZXJfcGlkL251bWFfbWFwcy4NCj4gPiANCj4gPiBOb3Rlcw0KPiA+
IC0tLS0tDQo+ID4gLSBTYXNoaWtvIHBvaW50ZWQgb3V0IGEgcHJlLWV4aXN0aW5nIEFCQkEgZGVh
ZGxvY2sgYmV0d2Vlbg0KPiA+ICAga3ZtX2dtZW1fZXJyb3JfZm9saW8oKSBhbmQgdHJ1bmNhdGlv
bi4gSXQncyBiZWluZyBhZGRyZXNzZWQgc2VwYXJhdGVseQ0KPiA+ICAgYnkgSGFvIFpoYW5nLiBb
Ml1bM10NCj4gPiANCj4gPiBbMV0gaHR0cHM6Ly9naXRodWIuY29tL2ZpcmVjcmFja2VyLW1pY3Jv
dm0vZmlyZWNyYWNrZXIvdHJlZS9mZWF0dXJlL3NlY3JldC1oaWRpbmcNCj4gPiAgICAgSW4gYnVp
bGRlci5ycywgYWRkIEdVRVNUX01FTUZEX0ZMQUdfTUlHUkFUQUJMRSB0byBiaXQtMiBhbmQgcGFz
cyBpdCBpbnN0ZWFkDQo+ID4gICAgIG9mIEdVRVNUX01FTUZEX0ZMQUdfTk9fRElSRUNUX01BUCB0
byB2bS5jcmVhdGVfZ3Vlc3RfbWVtZmQoKS4NCj4gPiBbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvYWxsL2FtYkVkU1BqZXJaSVZOMGJAMTkyLjE2OC4xLjIxNS8NCj4gPiBbM10gaHR0cHM6Ly9z
YXNoaWtvLmRldi8jL3BhdGNoc2V0LzIwMjYwNjExLXNoaXZhbmstZ21lbS1taWdyYXRlLXYxLTAt
MmQyNjZiZmM2Zjk1JTQwYW1kLmNvbQ0KPiA+IFs0XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9h
bGwvMjAyNjA2MzAtc2hpdmFuay1iYXRjaC1taWdyYXRlLW9mZmxvYWQtdjYtMS1kYTk1ZDdlOGI4
YTJAYW1kLmNvbQ0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNoaXZhbmsgR2FyZyA8c2hpdmFu
a2dAYW1kLmNvbT4NCj4gPiAtLS0NCj4gPiBDaGFuZ2VzIGluIHYzOg0KPiA+IC0gRml4IHVuYmFs
YW5jZWQgbW11X2ludmFsaWRhdGVfaW5fcHJvZ3Jlc3MgY291bnQgdW5iaW5kaW5nIGR5aW5nIGd1
ZXN0X21lbWZkLiAoU2FzaGlrbykNCj4gPiAtIEZpeCBtYXhub2RlIGhhbmRsaW5nIGluIHhhcGlj
X2lwaV90ZXN0IHNlbGZ0ZXN0Lg0KPiA+IC0gQWRkIEdVRVNUX01FTUZEX0ZMQUdfTUlHUkFUQUJM
RSBkb2N1bWVudGF0aW9uDQo+ID4gLSBSZXBsYWNlIG9wZW4tY29kZWQgc2l6ZW9mKCkgKiA4IGNh
bGN1bGF0aW9uIHdpdGggQklUU19QRVJfVFlQRSgpDQo+ID4gLSBBZGQgZ2V0X251bWFfbWVtX25v
ZGVzKCkgYW5kIHVzZSAgTVBPTF9GX01FTVNfQUxMT1dFRCBmb3IgYWxsb3dlZCBOVU1BIG5kb2Vz
DQo+ID4gICBpbnN0ZWFkIG9mIGhhcmRjb2RlZCBOVU1BIG5vZGUgSURzLiAoU2FzaGlrbykNCj4g
PiAtIEV4dGVuZCBtaWdyYXRpb24gc2VsZnRlc3QgdG8gdmVyaWZ5IHJlamVjdGlvbiB3aXRob3V0
IE1JR1JBVEFCTEUgZmxhZyBhbmQNCj4gPiAgIG1vdmUgcmVwZWF0ZWQgY2hlY2tzIGludG8gY29t
bW9uIGhlbHBlcnMuDQo+ID4gLSBEcm9wIFJGQyB0YWcuDQo+ID4gLSBMaW5rIHRvIHYyOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYwNzI4LXNoaXZhbmstZ21lbS1taWdyYXRlLXYyLTAt
MjY5YWMxZjg0ZTJiQGFtZC5jb20NCj4gPiANCj4gPiBDaGFuZ2VzIGluIHYyOg0KPiA+IC0gTWFr
ZSBmb2xpbyBtaWdyYXRpb24gb3B0LWluIHRocm91Z2ggR1VFU1RfTUVNRkRfRkxBR19NSUdSQVRB
QkxFLA0KPiA+ICAgcHJlc2VydmluZyB1bm1vdmFibGUgYmVoYXZpb3IgaWYgdXNlcnNwYWNlIGRv
bid0IGV4cGxpY3RseSBhc2suIChBbGV4YW5kcnUsIERhdmlkLCBTZWFuKQ0KPiA+IC0gQWRkIGt2
bV9hcmNoX3N1cHBvcnRzX2dtZW1fbWlncmF0aW9uKCkgc28gYXJjaCBjYW4gY29udHJvbCB3aGV0
aGVyDQo+ID4gICBHVUVTVF9NRU1GRF9GTEFHX01JR1JBVEFCTEUgaXMgYWR2ZXJ0aXNlZC4NCj4g
PiAtIEFsbG9jYXRlIG1vdmFibGUgZm9saW9zIHdpdGggR0ZQX0hJR0hVU0VSX01PVkFCTEUuIChE
YXZpZCkNCj4gPiAtIEtlZXAgZ3Vlc3RfbWVtZmQgdW5ldmljdGFibGUuIChEYXZpZCwgU2FzaGlr
bywgU2VhbikNCj4gPiAtIFNwbGl0IG1pZ3JhdGVfZm9saW8oKSBpbXBsZW1lbnRhdGlvbiBhbmQg
ZW5hYmxlbWVudCBhcyBzZXBhcmF0ZSBwYXRjaGVzLg0KPiA+IC0gVXBkYXRlIHNlbGZ0ZXN0IHdp
dGggbmV3IGZsYWcuDQo+ID4gLSBMaW5rIHRvIHYxOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9y
LzIwMjYwNjExLXNoaXZhbmstZ21lbS1taWdyYXRlLXYxLTAtMmQyNjZiZmM2Zjk1QGFtZC5jb20N
Cj4gPiANCj4gPiAtLS0NCj4gPiBTaGl2YW5rIEdhcmcgKDkpOg0KPiA+ICAgICAgIEtWTTogZ3Vl
c3RfbWVtZmQ6IHRha2UgdGhlIGludmFsaWRhdGUgbG9jayB3aGVuIHVuYmluZGluZyBhIGR5aW5n
IGZpbGUNCj4gPiAgICAgICBtbTogc3BsaXQgQVNfVU5NT1ZBQkxFIGJhY2sgb3V0IG9mIEFTX0lO
QUNDRVNTSUJMRQ0KPiA+ICAgICAgIEtWTTogZ3Vlc3RfbWVtZmQ6IGltcGxlbWVudCBmb2xpbyBt
aWdyYXRpb24gZm9yIG5vbi1jb25maWRlbnRpYWwgVk1zDQo+ID4gICAgICAgS1ZNOiBndWVzdF9t
ZW1mZDogYWRkIEdVRVNUX01FTUZEX0ZMQUdfTUlHUkFUQUJMRQ0KPiANCj4gDQo+IEFzIGRpc2N1
c3NlZCwgd2Ugc2hvdWxkIGZvciBub3cganVzdCBhbHdheXMgZW5hYmxlIGl0IGFuZCBub3QgZXhw
b3NlIHN1Y2ggYQ0KPiBmbGFnLiBUaGUgaG9wZSBpcyB0aGF0IHVzZSBjYXNlcyB0aGF0IG5lZWQg
bWlncmF0aW9uIGRpc2FibGVkIGNhbiBqdXN0IGZpbmQgYQ0KPiB3YXkgZm9yIGt2bSB0byB0ZWxs
IGd1ZXN0X21lbWZkIGFib3V0IHRoYXQgaW50ZXJuYWxseSAuLi4gb3Igd2UnbGwgYWRkIGENCj4g
R1VFU1RfTUVNRkRfRkxBR19VTk1JR1JBVEFCTEUgb3Igd2hhdGV2ZXIgbGF0ZXIuDQo+IA0KDQpT
dXJlLCBtYWtlcyBzZW5zZS4NCkknbGwgZHJvcCBHVUVTVF9NRU1GRF9GTEFHX1VOTUlHUkFUQUJM
RS4NCg0KPiBXaXRoIG1pZ3JhdGlvbiBpbiBwbGFjZSwgYXMgYWxzbyBkaXNjdXNzZWQsIGl0IHdv
dWxkIGJlIGludGVyZXN0aW5nIHRvDQo+IGludmVzdGlnYXRlIHdoYXQgaXQgd291bGQgdGFrZSBm
b3IgdGhlc2Ugc2hhcmVkLW9ubHkgKG5vIGNvbnZlcnNpb24pIGFuZA0KPiBtaWdyYXRhYmxlIGd1
ZXN0X21lbWZkIGluc3RhbmNlcyB0byBzdXBwb3J0IFRIUHMuDQo+IA0KPiBJJ2QgYXNzdW1lIHdl
IG1pZ2h0IGhhdmUgdG8gdGVhY2gNCj4gDQo+IDEpIGd1ZXN0X21lbWZkIC8gS1ZNIHBhcnRzIGFi
b3V0IHRoaXMsIGFsdGhvdWdoIEkgcmVjYWxsIHRoYXQgbW9zdCBvZiBpdCBzaG91bGQNCj4gYmUg
dGhlcmUNCj4gDQo+IDIpIFVubG9jayBndWVzdF9tZW1mZCBpbiBraHVnZWFwZ2VkDQo+IA0KPiBX
ZSBkaXNhbGxvd2VkIGtodWdlcGFnZWQgZW50aXJlbHkgaW4gY29tbWl0DQo+IA0KPiBjb21taXQg
ZGQwODVmZTlhOGViZmM1ZDEwMzE0YzYwNDUyZGIzOGQyYjc1ZTYwOQ0KPiBBdXRob3I6IERlZXBh
bnNodSBLYXJ0aWtleSA8a2FydGlrZXk0MDZAZ21haWwuY29tPg0KPiBEYXRlOiAgIFNhdCBGZWIg
MTQgMDU6NDU6MzUgMjAyNiArMDUzMA0KPiANCj4gICAgIG1tOiB0aHA6IGRlbnkgVEhQIGZvciBm
aWxlcyBvbiBhbm9ueW1vdXMgaW5vZGVzDQo+IA0KPiAgICAgZmlsZV90aHBfZW5hYmxlZCgpIGlu
Y29ycmVjdGx5IGFsbG93cyBUSFAgZm9yIGZpbGVzIG9uIGFub255bW91cyBpbm9kZXMNCj4gICAg
IChlLmcuIGd1ZXN0X21lbWZkIGFuZCBzZWNyZXRtZW0pLiBUaGVzZSBmaWxlcyBhcmUgY3JlYXRl
ZCB2aWENCj4gICAgIGFsbG9jX2ZpbGVfcHNldWRvKCksIHdoaWNoIGRvZXMgbm90IGNhbGwgZ2V0
X3dyaXRlX2FjY2VzcygpIGFuZCBsZWF2ZXMNCj4gICAgIGlub2RlLT5pX3dyaXRlY291bnQgYXQg
MC4gQ29tYmluZWQgd2l0aCBTX0lTUkVHKGlub2RlLT5pX21vZGUpIGJlaW5nDQo+ICAgICB0cnVl
LCB0aGV5IGFwcGVhciBhcyByZWFkLW9ubHkgcmVndWxhciBmaWxlcyB3aGVuDQo+ICAgICBDT05G
SUdfUkVBRF9PTkxZX1RIUF9GT1JfRlMgaXMgZW5hYmxlZCwgbWFraW5nIHRoZW0gZWxpZ2libGUg
Zm9yIFRIUA0KPiAgICAgY29sbGFwc2UuDQo+IA0KPiBJdCB3aWxsIGFsc28gYmUgaW50ZXJlc3Rp
bmcgdG8gZmlndXJlIG91dCBob3cgd2VsbCBraHVnZXBhZ2VkIHdvdWxkIGNvbGxhcHNlDQo+IGd1
ZXN0X21lbWZkIHdoZW4gbW9zdCBmb2xpb3MgYXJlIG5vdCBhY3R1YWxseSBmYXVsdGVkIGludG8g
dGhlIHVzZXIgcGFnZSB0YWJsZXMuDQo+IA0KPiBjb2xsYXBzZV9zY2FuX2ZpbGUoKSBkb2VzIG5v
dCBzZWVtIHRvIHdvcnJ5IGFib3V0IHdoZXRoZXIgZm9saW9zIGFyZSBhY3R1YWxseQ0KPiBtYXBw
ZWQsIGp1c3QgaWYgdGhleSBhcmUgcHJlc2VudCBpbiB0aGUgcGFnZSBjYWNoZS4NCj4gDQo+IFdo
aWNoIG1pZ2h0IG1lYW4gdGhhdCBhcyBsb25nIGFzIGd1ZXN0bWVtZmQgaXMgbW1hcCdlZCwgaXQg
bWlnaHQganVzdCB3b3JrLg0KDQpUaGFua3MgZm9yIHRoZSBwb2ludGVycy4NCkknbGwgdGhpbmsg
YWJvdXQga2h1Z2VwYWdlZCBpbXBsZW1lbnRhdGlvbiBmb3IgdGhpcy4NCg0KQmVzdCByZWdhcmRz
LA0KU2hpdmFuaw0KDQo=

