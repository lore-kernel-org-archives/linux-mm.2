Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0A2606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iq0Bu1Kb
Received: by kanga.kvack.org (Postfix)
	id 5C0006B05B5; Mon, 23 Nov 2026 15:17:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F6F6B05B7; Mon, 23 Nov 2026 15:17:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45ED66B05B9; Mon, 23 Nov 2026 15:17:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 112806B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:17:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FEBE809A7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:17:20 +0000 (UTC)
X-FDA: 85467493440.17.4AFB925
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013024.outbound.protection.outlook.com [40.107.201.24])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C7E718000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:17:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=iq0Bu1Kb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795465037;
	b=w0V2HicT1rd/3/jhrhTZfr+xkQZYAlrUyPHgnPNWcQH5Kk4H/78A9xoRetDb+oRxFdXUtH
	2XWOLLe89gtjwLcstZJLIpK9Ru5k7ls2zDxQ/snI395YET+yPJujcdURiT85P/SG1P7sCA
	lGXo9IoG22A17v8ZNBuRVenuqslM1Y4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795465037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eoa156C/ExCR/OJ9hg5I/bUi8aicbJCrUtqcCscc/SU=;
	b=Ewbxvic99b6JcYefYmzDTcN+c74wsTZAjw5XoJmmGAtBDJ4v8UMIwKb5ripYbms8eQlkwQ
	uSfIpH+2JELPYmaeFMhZPWqO1QE5anXYICAoUsmK91KOEXfgI2Eb+3SkvWKlnpXegFY5ks
	EUJKJhZNxYJYE/aIjpU2ofsbXXtZ57Y=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=iq0Bu1Kb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAP373qsuyhEgdLX2LjxVxhRo5apETlpl3PkXfFiuoGe8CcqgMPJ2l6KnMDbWNtzojYDqV/VsIOaJrVyTEamAJVGoYAv6L2m+oXSdk2+lCrCwABE3zOFaIskPpZXKlFiPqygXfveTajBxzveM4W6fF12dKIPC3r5mZcjrLmYc0T0mKlMwBDMRWALhoI+VRyamihZ8zTGd6hhJQ1OdwsxX1qtdrj6wMbAJ4lKOzhObKKFWv2S0aHBolv2lu//4lMFc762h1R9Ogv2NNsYZ9pTetB6IsqLe8hJxYqddoYWpfoST3oCO1+GS1g0Cbg4lWBRO7U/Kkl8KzoekkPiJF4UMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eoa156C/ExCR/OJ9hg5I/bUi8aicbJCrUtqcCscc/SU=;
 b=xUbInM7mvDPCL2rUVckDn2otiVDtFvRFO5ZP3/OF8G/YBH7W53bbSic/GcHWsSdphPkbogSpvzod868F2kh7V5dZiJ0/J9RYmPZzjU3cLQ2FHXvgoh5+Svq4eASiTAeJVa9K6omzlG8iX6tMKRGKoRSxs6iB6gLsqwLrMDNiD+QTLklZ/C42YkUMOgWf0f1718AdfhNTXxt8Li77iPqJrYylWkVV142UH2wW55IeOqBIf+VViF4u4KeMkAgKkFNmx2sgdo57mNW3WbxK9efV5rCW59vclxXrqzIjToEy/6G+ffgZVCSWJgzWwrcZg7n27AwbA35Ga9VyuJooD3SQNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eoa156C/ExCR/OJ9hg5I/bUi8aicbJCrUtqcCscc/SU=;
 b=iq0Bu1Kb+6g29U4SGskIdw146Ky2M99b+5+Ytd0zquT2PyoHE/csXCoQeMrxK+D1/RQx//6Megz///3sBPSeC18WhRLsdlrgdWrRLi5HHZCxiigVXSeSFKKLTGSY9q1lT+XU6enn3puDgepYRD42bI56UeULKjqumgrna209ZtZNk2Elr9OjHvj+uhrqv4But+MqZ32iREBkHZ3pau3eho0TjNAk7Sfdk9UdZJFUalKGytxVtXYaGWEDyUtzqHBNxQlpMBqu12kVBOSxmOcNeybV/fnRykV/Y7DntI9x14jlSdm6jaRCnw4vz0ODBLpLG5V7B4MXklQR3JODSfW0IQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6668.namprd12.prod.outlook.com (2603:10b6:510:1aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Mon, 23 Nov
 2026 20:17:08 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 20:17:07 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 15:17:05 -0500
Message-Id: <DN2V8E26C4EL.2TU52TEVLUFA@nvidia.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Muchun Song" <muchun.song@linux.dev>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Chris
 Li" <chrisl@kernel.org>, "Baoquan He" <baoquan.he@linux.dev>, "Nico Pache"
 <nico.pache@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Barry Song" <baohua@kernel.org>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Nhat Pham" <nphamcs@gmail.com>,
 "Youngjun Park" <youngjun.park@lge.com>, "Gregory Price"
 <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang"
 <lance.yang@linux.dev>, "Hugh Dickins" <hughd@google.com>, "SJ Park"
 <sj@kernel.org>, "David Rientjes" <rientjes@google.com>, "Yu Zhao"
 <yuzhao@google.com>, "Vernon Yang" <vernon2gm@gmail.com>, "Zicheng Wang"
 <wangzicheng@honor.com>, "Tal Zussman" <tz2294@columbia.edu>, "Kairui Song"
 <ryncsn@gmail.com>, "Xiang Liu" <liuxiang.277@bytedance.com>, "Ehab
 Ababneh" <ehab.ababneh@intel.com>, "Zhao Zhenzhuo"
 <zhaozhengzhuo@uniontech.com>, "Lian Wang" <lianux.mm@gmail.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, "Kunwu Chan" <kunwu.chan@gmail.com>, "Hui
 Zhu" <hui.zhu@linux.dev>, "Maxim Muzafarov" <maxmuzaf@gmail.com>,
 <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
 <damon@lists.linux.dev>, <linux-doc@vger.kernel.org>, "Tianyi Chen"
 <hi@tychen.cc>, "Ridong Chen" <ridong.chen@linux.dev>
X-Mailer: aerc 0.22.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
X-ClientProxiedBy: MN0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6668:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b619d27-ea4d-4fa1-d684-08df499ebf5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|22082099003|6133799003|18002099003|11063799006|56012099006|261026140227099003|261028144727099003|4143699003|261021121427099003|261102123227099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5wRZGc5T/wKdtsBQT/wXVuO/6kY+7qmVrLaUfBFKaYaegZJI0fzznJhq/BGH4d/qM+YCGyCMnClDEXBOT5JDJ4YI3BzoM5t00OmtxfopE5h9Ykh9QHDC+AMvWRjkSzZ5yhcBTWFAp0HuodUToDdidaNWnM//MpM9L9k4LkM9QAVHh7b4ZK+WE3Aja4o8b1Ye3vl6JDeg8Qyl78FGQQjNzUlC2oa4g8hUCUGDuoeQMygKNXdBqAUXosBWxlghhUAo5Jnh6QuegtPtyVczEHTlrwU6gToCaGUYLpiSq01NFHKJbBTNKd7SB285UZHVjPShvIOuZs1WbISnWfYdA/zIiyTYp0Npx1Qck3HOGYI3yOsIFKBYIrU+rBszjMeVaqTF2zVmGI0izEgiIpY0qm1NlrlrAubh58wv58LVEER2NXoANJ1lYHa6Niv5+QEM9GG7gLPrJMj071LKBr/Pkh+vrxsrLByKIvQnIUNMCiWkcB+Nl/qgUKjfj3YLbZXxiMIx0ZfAhM8XMJk5T4uYwpmZl5tOq7oEe54jr2mQ1U6wgMhOhidDTEUtXFz9Ib5cvxFjIn375K2swzbijXe/lG9JAdqN3DvUS5OEHOx+iBHWlD/EbTJe/ic0ucSoErVcTfLhItAUmCLZFDiOlsP2ZTZRaLxc08oV5yytiAW+B9H2KzU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(22082099003)(6133799003)(18002099003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(4143699003)(261021121427099003)(261102123227099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1NNbThLeE9HUDVRWDdEZVhhZHdGK0dVZmd4a0J1OWxzeUhtYUF3b21XbHZk?=
 =?utf-8?B?TmF6Sk5wcXhtVXlueFR4NGZGblowRm9iNmRKS1RNRzE0ZkNDWXZoQUFHV2RE?=
 =?utf-8?B?TW52OGgvUTYxQ1RqbU13a2xsRGhsM0hORGk2OUpGM3FZRWczOFZwb2Y1cXdi?=
 =?utf-8?B?empFUS9MVnhFdXFyV3liMUJpNmNLOWpCSml1RFRKaFg0bGVleHQ5V29NYUpU?=
 =?utf-8?B?UTlMc3g2QnY5MENJQ0RSOWhhYlp4Z3U2TzhoTGJEbW9qZDhjZTlnRDhOc2hZ?=
 =?utf-8?B?U05FRTd1YXQwc3NXUGxCcHVvc2xwZ3puaUppVEFBV2JhWktMaUdtSk5CcThD?=
 =?utf-8?B?SkpkWWlzL29RcmM2UndmWUJ5SWttaEpwTFpYZFh2a3FxZ295UENhV3dIbzZu?=
 =?utf-8?B?dVowQW8rd0FsQVJ0WDJRYmxBQ0JPNzR1ZUZQMEJMTS9PcTBSSVVzQ1dvejNF?=
 =?utf-8?B?SDd6YmZPR2dLb1AvWXUxV2toaHZVQUNadGRmc0FCWm5uZ3JnanpPbHJKUlNO?=
 =?utf-8?B?WGtmWGhpZHNnS243Q0JsZUVYWG5BdHpJUnZ4SVBYaUJNQlA0cGdKbXBsV29y?=
 =?utf-8?B?QWY3Vjg3NFUrTzJ4QitrQ29PNW5lWkd0MWJ3bVMrQUNWejdPa2F5S3V2dnM1?=
 =?utf-8?B?UmtJSnVMNUVIMHVtWE9MRTJJT3ExS3FIblBDamluNDIzNTdQY1p1di9SVkk5?=
 =?utf-8?B?V2JaUGt0QXlvMjhWTmdMZmNucG5QeGNET011M1JkWENUNVRweG8zeVdpOHRE?=
 =?utf-8?B?WGlnODNFUlc3ZFJodld2T28rRGZ4ZU11V1owUjJGKzcvN244VHN6ckNVb2Fz?=
 =?utf-8?B?N0tESyswMjNmS1NheW1aRDJMYVBrUlRjZEdzNkZ1Ly9EUXovS2NyTkgvQXhw?=
 =?utf-8?B?TzFSUmw2N0trbmNYVXh2K01sYUZ3STNNQ08xdCtTRnRGRHhPQmlsQjhjVnJt?=
 =?utf-8?B?WSttN2JqVVNueFMrb3N3ditUSk9oQis2cnpEM2lMNDU5TnplNldqMXFLaFhX?=
 =?utf-8?B?OW50VzFlN1BkRDdxd1FOMGZ6bTZDcyt4N1B6WUJnU3RYRmRWTzYvcnFuL3Yw?=
 =?utf-8?B?bmNKRnFqa2NqaTV6eHlTdGgrY0VTZVBEa0RYUUNBRWYrMndwcXg1eno3T1pk?=
 =?utf-8?B?dWlDc1FyUUlNajdGOURjeE9tR2ZOTXJsdnBYcVlvRTdFTUZrSEtmQ01pUFRT?=
 =?utf-8?B?NloydmkxVUwydG4vdTNxc3BlYVRGaSt2aWxMR0pqV0lFY1hzUis4b0sydUhC?=
 =?utf-8?B?ZlRwSHNFcU9FMXZqUnUvK0Q3Z21BRlIvRWlWOGNlRUJJalg4NzcxQkZpRnM2?=
 =?utf-8?B?NWE0cTJVYk5jNncvWnBNUWgxaE52VUJscFJpR1UyREpIOTdIYmFNdmhHN2JJ?=
 =?utf-8?B?enhtRUhscGY2K0I1aUtDdnU1RzlPenJyRXhyaWJPZ2Ztdi9FUXpPZk9mbFR3?=
 =?utf-8?B?aDR1ZzhwVFhHNytTdXN1UUtHWVI5OHVCK2lTQVVGYmFQdEk1OVFFTUtIR3g5?=
 =?utf-8?B?cW1RODVvWGcycnE3a0dLOFRhMkVpRlEzWVloTDF4STlJWjdUeGR2dnllQmJn?=
 =?utf-8?B?ampZN1hSZ2lWUmJKT3IzbnBwMzVrNlRtOUc2SVpmSHEyeW5HSURyaUpzb3NG?=
 =?utf-8?B?TnliS2RsNldsL1dLZTBhQW94TE5zNUU0ZUMrWE51TWR3czFJT1dSYmdKZnpT?=
 =?utf-8?B?UUowb2ViZkJoYUJCOUNWQXE3dlQrcGJxZ2Z4WHFndkhoVTFVOFl5TC8rNFdG?=
 =?utf-8?B?Z2FlYjkvSlI1TkI4dE8rN3VQdDNuVHg1ZWhXUlFZUmxWeEN2TlRzSVVWNGZt?=
 =?utf-8?B?WHI0aDg5YWhxaC8xYUFaMnhNWDgyb2R1WXhmYlU4b1lpWEdVSW1nTlZXWFQ0?=
 =?utf-8?B?V0F2VVd5VUNmaFVkV3gvVFdRYmxTQmpPbWthcDE3cS9aajVCMkpjMFFtcEcw?=
 =?utf-8?B?RVVFbll3QkNsNVNZZ0tyWkZTYS9qRnZKS0FjTHQyZkVRUE5mdFRrRmZzWVBK?=
 =?utf-8?B?Q1gxUDVkTkk5RHptZ0M0R2VrNDN3eG16WGtFU1p2cmNnRGwwZktvZC9Cbnhn?=
 =?utf-8?B?N0dXTVpUSFBTNnp6V21xaGpjczJXS0RpVElMZGhpdCtZYlhod1NEeTJkS3dq?=
 =?utf-8?B?dmM5RVU5dDA5STlNcElXR1I0bDZaSHJoTWdIKzM5a0VyNEQ3d3YwTXdnL1M1?=
 =?utf-8?B?VjlHa0g3Z1ZDRWlzdWpnUjFLMXQySTFOeEJFdVNrUnlpcUFEWkZOdlR1bTlt?=
 =?utf-8?B?VTc3MWhwbTY0dkszcG1TOFNRWEpKd0luWmNkQXRTak1wc0NnY0RybGVWZDhH?=
 =?utf-8?Q?DErc+v/oWUEp7nJ9M4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b619d27-ea4d-4fa1-d684-08df499ebf5e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 20:17:07.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ta7jsfzqdBKPqK2+fTzVIttY3FyD/72HVQ8y0kGZstXd4AcN4CU7C1FNi5O7/mqt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6668
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 6C7E718000F
X-Stat-Signature: qb486x61nm7cjca9pmnfuo1apyt3185s
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795465037-280393
X-HE-Meta: U2FsdGVkX19Wru5tyZi+7N1oCevIIDNIYLbuw6+57GTk4zfCloN1PJtGqRtwHWLYEr7sN/mQ8OlW0B8oadWDqL02CbFr3VNcvnxLfYMYlptn1RhppmBBb9kpNNZo3BkgqiIt3HhN8JQmKuzXq/TF2EPOV8uSG1v4dQmqJYqKIgPuK7TtHP58u7UeJ1DDppCcNGOkMN8nw3I9q+8NwnMuqa/5SnHB1iZfwmlt5pNJH1puLNfZiEatlZS8zLyqIkLjyVumt6Jv+GjaDqPMW/nzYtjAFYctvw+nNHs360rJBqt2dOa16qCPmD4kRtbs3+dAxg3449LvvjqwIdAJ1oaflu+R7mh62nDjJnZzNcdYZZ/bWFZ+X/6Ikqab9lGv04yBZMcFBaqPIqCHtXXjbHvvpdKQQkyh/hGiMXhU2Vjji4mifjq+XQiWob7GNLbJE/NL2nVFvGMvRLMkyM9lmy0MtgcOE/V3486WxopAuoOeIVj7nCkZB9zU4wmvBGAPlB2eGDrx+tL6wJdsvHjTvH75TI2HX+bAlBzylGuaABTyB2gbXSYSrzSzHXDBEX/MD24Mmo+jVp31S7eC5l/L3A0c8z6OriUBYDpZlFuLLHyJBSHpxWpGgUsngOgqg49fPVgXWWW/AFDMXFg7YWEOxWLAmiF1TVCD1VekMedfwLJC2DT95aFZ10MvGL/4DJzPw2tvFLOPH0dm7PW/7/pdoGuajwv8a/APp81LYOCP4+DevbrkP8zyK1rJtwjUXvonInOma3OSERkkbp8tzvNCRZ1oTQQycdqW5VV9b1wIxaK5cXtU496w1fpWCujQ0HU2H38VITYHCE5iyqaZrtP45XHU1vAMAyBPZD60JTM41gtjMpouYniMjcGXlQkXCyfo4WNM1XgXS5joJowjeytl1cZHDxxeymgpzsvJBC3euEKp7Jct+tkiWDZruxPQqVRbsCSGuxgBsJmJAmLrglWLH76
 MY2xhH+j
 4M78jN4TuxfGxhKBdUJnKMTY+yp7SaRU/1QDKkb/f+HElugKv6oATw0jUrDu89ljTnX78iHq6qdjkjXIIwLrzFv5YnOH/XTK4QYNRhhX0/2ejDrwYupInXJucwlObz5GfUJXaSld0soDdyPWRsYbEs7zXBztFL87aA/LAFoBQTvVgashGGhYtTUs7zo3kzVc05Sj8jgpeRjJ97anRRuNDgU6mLDJczXCcripRVmwDBTrU1RcQp20fI/SJMNWNsumL3sk8QBn1m/LMw2VC0vZS9LcZfxCjueh3EldwPwdlThjddxJT6LqXbNpX/EqAA/krtWIqrL4IcSyi7zp0EI1kZ89dBIk5zjc61xOsqY0+p7C3gqotwJ236LXFA8O0N6/8D0B+gRC0qSNO9BCvlroT5HspfoEPNfSowG+mbJiT4oa/b8PGkDGxtBMsAyGXgoB40Vitqicz9GUwB6KyjKaAUYkp7tO0oYnJgJykq1n8+zcWvLsuCJ/LkVMLow8hQowJTpmZjTjx+D9tmjuaHUKexV1T1n/WOqB5UnWFt1Dp1Cb4mY+kNtyPMvVs84cryecI6G+MuXdclSyxZlRKPccJkAwoQaS0U+LmjjQajv556gqOfYpwx2w9ZxoAbbH6AUY6VLoUiURiv40bvIgrGc3gHpGr9djJuIBHPivBcIIxzIqZZW7nQbuwLNZd6XMq9IjKhQsDPYqXUaAqDeJ+dZVy9E27HVTvpa8Sup+la91uEip94kL3k/SaWnaMOkNAaIgMEREDqG606qxmvI7S0soikabYN7EBW5Ncy0mem5mbZLHbXeC5x5D1WJsojwLmzvqL6NwBEBEEHwUhN4myUurY9nUVs0sVl0xCHQzoQLtpKtQFLn3aRByYVKlXV0TwnXRQbV+ELRPu2TTGYcnfHce+BEBWMSlXPAIbulWRlkMIbhRFjExoUrfh7lqTYM33ZYV7mLaP3mGSXdBmwRkk1AbraFX0j0iD
 teAKEddi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The behavior of updating the folio's access info isn't consistent for
> huge mapping splitting or ordinary unmapping. The page table's young
> flag has to be translated into folio's access info.
>
> Right now it only checks and sets the folio's referenced flag, which isn'=
t
> enough since folio flag updates on access have their own rules. Ordinary
> unmapping (zapping) calls folio_mark_accessed(), and it also checks
> if the VMA has recency to avoid false updates.

Can you elaborate on why vma_has_recency() should be used? "false updates"
might be too vague.

>
> So first just use the right helper here to be more consistent. Keep
> accounting the young PTE as a cache access, sticking to the current
> behavior.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 75e8641bf9ff..fa9f6d21e786 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3122,8 +3122,8 @@ static void __split_huge_pud_locked(struct vm_area_=
struct *vma, pud_t *pud,
> =20
>  	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
>  		folio_mark_dirty(folio);
> -	if (!folio_test_referenced(folio) && pud_young(old_pud))
> -		folio_set_referenced(folio);
> +	if (pud_young(old_pud) && vma_has_recency(vma))
> +		folio_mark_accessed(folio);
>  	folio_remove_rmap_pud(folio, page, vma);
>  	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
>  		-HPAGE_PUD_NR);
> @@ -3245,8 +3245,8 @@ static void __split_huge_pmd_locked(struct vm_area_=
struct *vma, pmd_t *pmd,
>  			folio =3D page_folio(page);
>  			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
>  				folio_mark_dirty(folio);
> -			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
> -				folio_set_referenced(folio);
> +			if (pmd_young(old_pmd) && vma_has_recency(vma))
> +				folio_mark_accessed(folio);
>  			folio_remove_rmap_pmd(folio, page, vma);
>  			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>  			folio_put(folio);




--=20
Best Regards,
Yan, Zi


