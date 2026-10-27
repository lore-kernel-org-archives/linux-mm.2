Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D0F606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IWS28PhO
Received: by kanga.kvack.org (Postfix)
	id 405906B08C5; Tue, 27 Oct 2026 15:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B71F6B08C7; Tue, 27 Oct 2026 15:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27EE36B08C8; Tue, 27 Oct 2026 15:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0606B6B08C5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:44:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92C3F40B07
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:44:59 +0000 (UTC)
X-FDA: 85369434318.21.52A2717
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012003.outbound.protection.outlook.com [40.93.195.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9B5B7C0003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:44:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IWS28PhO;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793130296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOyhHcOrShRiWitIyCi5+BpmWjQhn/WL/3TaThbOR5c=;
	b=0ekaZQmwA7WiqED6OjPeOc2GTqLVm9WtKr39H+WaXPhcEAE6yreAWl+GC4wzcryOLO41f0
	kzJkrHvyJnBD/ZxONcbQHdz/FSWyfAhlAx8qnmFipmf5LMye9gcxdRBNqkNhRbrBhVhttM
	wUQ2RED5yxm5Et+BudOQlezxh+Jqtjc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793130296;
	b=YJp3RwxHHhF2N6X1BhBcbzr7vvkqVnz9yAE3ai/RH7VTk8Msoq2EsIPaCXYnKuBtjIB1OS
	DVmKdAiv7Rb7SRRb6F3yAXuTwfz+zBjuU8cr+q1AWu/RYXxWSUstbzAFAczkh4O8RyleOt
	HTPSNTAfnEG77L/NDCqoAzHaRh4ePwo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IWS28PhO;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BvpXMRIkERGT5dKlTCeOpR+O93tc+rNSUuyJsHZgWvPWZYFkHVif9Fw8uJcRblruoa2xLcZzK8Wm7cZXjRWVGEKqqpMpLbMNGMj0pobiH5Xqm6eBvuIbuQLE8DzYk/QzSaaNzh/9ndNf/uMxf/09InagrMBKe/2J816yb7AOi/Hgz6geqgexN/1S2a1G6gU/RGmzu7uOi6KDyvcvawgYEmoudAQ97vmj8MjQPWD9bECcpdnUDj8bU41dUApcJ0vgaghny2pS0PZKPR7itXHrJPuqUvu+t8WpxjKq4od9Dok5Z/yYCNKvOSDR9jZeEk2AvzIU7h1EuRm8nEfXM4jn/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOyhHcOrShRiWitIyCi5+BpmWjQhn/WL/3TaThbOR5c=;
 b=xb+GomyGZZa1TfqFzC1uG8V9JE6sQnFN2gzZL7/C7urGZgEtgGUw4sEyYsYqWRQyDT+9A9eFCvJtAOO0C8KrAHwR9gGYRLeelH9jxivYHLgtUANfp1mUzDXF/cTQi5Uumvcj/n2H4e+EaU1O9s7WP1N0zP6TBhXPYJ9mlA+Hkn89hUU0/OpFiHGRAp9jyLdr//hVs/Eai1RSgHxPJDPrkVuNew58OL+RmucIODBit4nDSC/9L1eOBvzawrFHvBS1qf+jKb4yDRyrivAMkdggg3sgGcsGzCW4wcF8Em2icchfnnls/F67rKby4x81HLZ8FIWUZhx4ILbUI8Hr/dc+FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOyhHcOrShRiWitIyCi5+BpmWjQhn/WL/3TaThbOR5c=;
 b=IWS28PhOquvh7bz+mG6dcKcJZ/L50s2g3r5AjMpNOrVFnZo+FagAaf/tJIXu0gRRXbdCtcg7pOK1ewLlWQNJiMWbytGJ/9i0rG7hxUAgsqO2fdnIBaAzxfjyU5EA1tqs4YgWStJaYwF8JY90Ot7nFqx5uyS3xfF4gnVtDFiSzxKdD8kO5p5OJGShMLJ/wvAGXf17AmZSIQOdgidY08mxbxVgpAC0ajwGXVNRE8eXMyWheEIyXweMxSmuEHzkBrW0oIk4+XmJD7IIDXAudFvab9/NJRIl/CBLTkWsu8iNnAOI6Ys3ObUDpXha7sNNlIpdyNd1kAbqUdYwlhaNuXmtyw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW5PR12MB5599.namprd12.prod.outlook.com (2603:10b6:303:194::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 19:44:51 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 19:44:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, kas@kernel.org, jack@suse.cz, djwong@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, hch@lst.de,
 pfalcato@suse.de, ngocthang2710.1999@gmail.com,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
Date: Tue, 27 Oct 2026 15:44:47 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <12CF5D0D-A16E-44CD-91F4-AC9CFABDFDFA@nvidia.com>
In-Reply-To: <20261026152013.10511-1-lance.yang@linux.dev>
References: <20261026152013.10511-1-lance.yang@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW5PR12MB5599:EE_
X-MS-Office365-Filtering-Correlation-Id: 69a05196-6f93-4241-9aca-08df3462c323
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|7416014|22082099003|18002099003|261026121527099003|56012099006|11063799006|10067099003|261021123027099003|261021121427099003|261022105027099003|261009223027099003|261022075727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	0lgXPiVdg85m1P2j3VrOLJgEzwqWuABdzgxmUuK7VKeK4siU1KuQTqzC209/e5vpNCAPk+tklgiyZ3aexfvv5AtTWM4tv15iiaxl7d7/j9KrrSPsI1llzoKzgQpfkmzFt58Tz1CdTKNEpv3zstik8UenCWZUC7Wwrn4rtlYdyNbJG6iRs5o4mXzLeRcN3l/Iu7+chNP7jyQyssrOWEaLgQPipj93tdMc4YfXjtHre01RwOYOjlpArpRyVFX/oimFO3r/Mqzz6UfB7g2WN1XIgtB2Z2eGYlyeh6EUCQnOiTGtcjVpPFwSIxEK21i4NFQFE2i8WvkQMZANN4SFrMdntrMyt8MDSkAEOlsf+RSUO+dYOc2CJtDqjJICUZPaY14pKw1it7IsEb+Ygd80JJYjJgHS/sSgw/D+Vti2CLjLppD84qe0JIjSwjEYy4dB+QLW+7azCEa3rBTzrQTn1MqZBkyxFcCCf/nh/u9eE6adO23gVfUlsRUSJuco+WZ2suS+RxguRa5C9ot1pFmVShxpsbgSUZ9LdsFEGNPOPMovtYvXfAaf6YtVB4hoX9Bz/Cqfkv4T/ydzVi4XPBWfLLdW9ZwuVhheNiZu6bZv0aaTlXq9YkbRroI+jLRYccJyHwz2c8vvMp5gb9ZZytQiWrYYBHfBxemTerEGeT2mwyKPEvE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(7416014)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(10067099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(261022075727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KYU3tSL/kO8d/8UItUoRFPZ+JlSWRZvJPAuKjpiNa8Wrc8Cu2mpcoAadnT66?=
 =?us-ascii?Q?x/GyjXBdDzezcGEq9itspN9Kz/hpTScXp2Aadh9wtr4AW3G3FvExHfcolFrr?=
 =?us-ascii?Q?Ha8fNv/l1AizZDzFArC3Leu/FCgL2Rh8LAMkeRBBVBcEAVFKZklosPj26ToC?=
 =?us-ascii?Q?0u/kDeBm0uvF1tPt+2I8F4TC/Nlm1bJnAhkY87sgJMJhqooUTpqe5unQCF9s?=
 =?us-ascii?Q?cQaiDq7FbHnV7snfcXxJFYXOcNWIgwQDBlNloavIrDLL9U765TPsoA+h7vgz?=
 =?us-ascii?Q?niTqdTKwYWpvk8FuCcqUycXsjrcgvF1y1F1XYgh+0Pp21k0ZiSDpF3w3UJlb?=
 =?us-ascii?Q?FPAocX2PZ4/WsO6tQc/rqnRSLjFkA4q/R0xbDoi8a9bbqVGd8b2JxDfUldlw?=
 =?us-ascii?Q?00Reu4XcjSUfPoAFJ+fGwSfEgR3EH1YTthjs7TfMZR7udbGKXWFSFudM0sxu?=
 =?us-ascii?Q?w1xCp1xfCFq8cAE2pqhkMgU51fcNrUSP6FheBK2v3bG7XCht5F7fCCy3awbz?=
 =?us-ascii?Q?xWBalyrRNLZQbGPQgIGneuSRi+sJ1JoLU88zgBYnPyj0SLCUU0BpdnxxOO+C?=
 =?us-ascii?Q?RqhVmdKofzb0dO28Kr5wZSx1IymEjO+//9OvV9wHcpuxBqR4AdcKTjrTkOaA?=
 =?us-ascii?Q?ij0KvEfwUooDjAd7Lvvj7qWbhnnvbGjDNXlPi5tX8MACzKm0s7+i1Z66Scv0?=
 =?us-ascii?Q?JEOqtOoa7WYeFGvLpsKBZJkmmyY3t3HRkL1zL3SFFGzhj937I68LU8l0859S?=
 =?us-ascii?Q?9DMzs8yItGL5sUsV1x9fYTWbfAE0fNVZSC2n3VQeIHsWy42QrxtjqLmYWOCW?=
 =?us-ascii?Q?iFKvSchlIspaoLrxZAn4viNy4y8MIDkhb9OTE1fhN7slsTM7XEITnGxK+HDU?=
 =?us-ascii?Q?Xd6a2451jUJGZeIygHREOO9cYdFGA9+JTtLmRuaEYjo4PV555WwCiZJ/rrba?=
 =?us-ascii?Q?b/2wJZbBnHUYE64nczKpN3hfG5Vsul9ZanRZTDUDIfZMyxT0kJzfVtAUX+Yl?=
 =?us-ascii?Q?Xa+a+EjZURVoLe5sHgLZ4wcLSpufp/WR8FxWFB6ZGzMPDGjJc0QMESgb2aPb?=
 =?us-ascii?Q?yOZpvoegItmIw13FKCDegEHLBBlwE4oslwdYrZR3Jd3yCnbkXoDCWnxt2UPq?=
 =?us-ascii?Q?cy2kERH3m5XREzJr+S+gmcAxlMRZgHLKJ3sZOxpy5zQIR9bUL/lsDT671rGY?=
 =?us-ascii?Q?lYIMhBYagYY9YjYfEBXhy274o0KCImwoLdUHaeY0Z1pkv6WAozNYUO1csqDt?=
 =?us-ascii?Q?A5XMj1cWa0WTN11fznxHXN77sEWbGZgdEMLSbiAaDX28CBv9H2jV69Q3DTW+?=
 =?us-ascii?Q?jI867g8prtlm9cEg9hLHMQ6bVYuPK9iCzTnYBJVVQagZVjv/M8j/UL1Nfdmb?=
 =?us-ascii?Q?oii1EuOi134cjn/AbE/K11zM/q/Dg+Ug+j6ZjdW06m2UVWiNNwOifz2rGMwZ?=
 =?us-ascii?Q?4usEWUkefCIUrRvN6CG3ItK02/VfkJJu1bxKVdJPGxbGb/Q/kibe9Gnl91QN?=
 =?us-ascii?Q?nuIo38yk1ks2nhYiFMydGIQOJ8qS3LtjLIld3xkRMPVTsEhK6rqhXuU4D0tS?=
 =?us-ascii?Q?yalcubEDGHCswfxci3VoWyiowb6SN+7Hqz3roP7b79jhvSdDvVr1Hyt13+WP?=
 =?us-ascii?Q?POiDBstQAP/QqNvJY2tqFxs0ufi5DyuVnaYJoeKkuDP6uPz7sR+Kjq+4q6rg?=
 =?us-ascii?Q?6RrQQvxggb5xpRiKCHfw3sSjlCWm4LUvLgcBRAoVevzEv51eqCBe9HYx+mMz?=
 =?us-ascii?Q?OKhV8jNLyw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a05196-6f93-4241-9aca-08df3462c323
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 19:44:49.6432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xcXybJWghmTSK6l2TsZctlzVzwVtqicRgOcXz0L7diEjmH29lew4orRKQ3mXMDMh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5599
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B5B7C0003
X-Stat-Signature: h89topih8c8bhfpgzrgygnrpxkgas1p5
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793130296-896829
X-HE-Meta: U2FsdGVkX1/2bVv035oAS2hzPGeGBLTlDeAuXpXeuLodYUtNymBEWBeCSYD/PEWU5YhSnkW+iTHYAaPysJIZxR8pUxbskOAS88Dluv4cpI9FBH9aHK1MmS5mYu3Wgsd4KZvRzG/SSiTu5L+KpjCEJXL8cVxlHljbvOWUaq2cISJrWtjGw6g+tfWMySXpKlgjRDxX/k4UW+5USyQ3/5vt7CmbKQDUJotm5icZIbPhqDz74Zb0pBW70bQuplEB4lS3Ek69RqZjsZmZBdjT96mSkKG88J6nuh5sHeznRJiBZxvUsTMfbFVrCvQj8WNK8zsjLo1fv8kyVKir1Zag9nBIM5MZ5CuJ/vJAm1wUyPmb39BenP8Nx9tf6T7wmDipugXo9ZjWnquA/Y3bMFhtCKzFCUesrVYkUQfiB3o8AxPDmqcvhMRfEVJZzdzd6zdCzI2IXIF+tIF5kObHVWwH8DorWJeUbqSOtPFILc17NrDyj2EbUztU2EV9pT4DS8XyM2G7siseVDZfkh8HjhRYD5JWlUbjs/rkm6CfdXBT/CodqdI/gHlUyHQvoO1yTeqagi8rOfRMXHTrXSSLDynw9yaw66BfL+bKe9uV2btcpQNcycHoJzrKN2CkqierCfZRSvkKZgGZL+/Qe25yPsohbY34dcv2ovffjKMcl9T1CACw4pTsqP088cryB3/u5khz/jSfyK1ij26m8YdwWyOsdqufspkOqtf/MOjI9VBsIORLF9X/A+8SC1FfB2ZJ7sy96lYSDGT7sNweIrEwrWYwYJQqB4kNNku+KVzJcZvZ85GC233di9/EQUenCZ0loovsRy2YWSE7Xy/UhgOelV0jLwn9qD/NKhwugq/rdNYQJ7vkruOZYlkFKJfnbuebZFnTH8BD7zYEFSnSfRsnWFF25X76dEPSDRiMmMbyt4x4KdRD5PlcBpfNYgmPplOo5KZecmvLm9ac+0nXYMOUFjs6QNO
 2B9Dijwo
 TUAeeJQvpoUpPbwN4hTRjOfNIDy0xQcDsuO/6B7BH4w088Z33lzhY7a0qHnX8OHAIhZNyxoT40Q7Wog/3UmZgSdNFhHx3No3s2aoKt1yQe7QbaueDHkv5HvwT8QQoSWeqvbiTzCqzc9ydW4UPaHPefRODhiWr6RNmVG1XDRKoqPDvcW3EYGAgmSY++ublSqulQMhYOLWmqVY8xmm4dZNx9bpcL2bp7LyZOemUjDwmlNBbmP6yDf22D3kAETereRGYWWG4vezNfBEDLD/eeTF7lmtLHPsQH37p0OnYyXbOv9ECBFAWYJFndm04eMN/r6Xsgooq8PX8J3Hi5N9Cfw4uTcsja0saOkyY1cM3XMC5IQLh+nayBb++BCZd9rWnQQDJ4I6JeKjd+Jgu1YGV5LdphmFQQvu36E8IL079t3knaI3J17N1G6RWpBwfzdNMZG3xFhrlEA93iKbf4p/uqTAWJaLq8QKloyWHNlUfqnjDqxusaYh2MGEVB1Q9wIQfWfQQGYCg+soxKFLGlZR4h+AiPPO3sYTDQrOzWeyBB9k1AdY21/rKgrfBiQy9FROfk8txOiwNV/6hyTPfsp2GN8BYy5iSYwTM2zeVrv/t1chON9YzcRYo9+VV3mHyYiSY1OkwlxxJGzT9wYJNwv1zfWEKlULb364UrV3OTlvfGB/vlTGorAfBLGB1SfgWx5DShSHuYytvgijrFD+QD74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26 Oct 2026, at 11:20, Lance Yang wrote:

> collapse_file() can call page_cache_sync_readahead() while still holdin=
g
> source folios locked. If truncate holds mapping->invalidate_lock
> exclusively and waits for one of those folios, readahead waits for
> invalidate_lock and neither side can make progress.
>
> We need to release those folio locks before starting readahead. On a pa=
ge
> cache miss, roll back first, populate the collapse range, and retry onc=
e.
> Doing readahead after rollback avoids an extra pass when all folios are=

> already present. If another miss occurs on retry, give up rather than k=
eep
> retrying while truncate or reclaim removes folios.
>
> Keep page_cache_sync_readahead() and wait for read I/O with
> filemap_lock_folio(), releasing each folio before moving to the next. T=
he
> existing uptodate check during collapse still handles read errors.
>
> Shmem uses shmem_get_folio() for swapin and fallocated folios without
> taking mapping->invalidate_lock, so it is unaffected.
>
> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D16bf7cd0ebeb1de93aa5
> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache=
 with invalidate_lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v3 -> v4:
>  - Move readahead after rollback and retry collapse once (per Pedro).
>  - Drop the preparation pass and its redundant uptodate check (per
>    Baolin and Pedro). Thanks!
>  - https://lore.kernel.org/all/20261016065920.4153-1-lance.yang@linux.d=
ev/
>
>  mm/khugepaged.c | 44 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 11 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

