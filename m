Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDFDCCCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 11:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595BE8E0079; Fri, 24 Oct 2025 07:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546A78E0042; Fri, 24 Oct 2025 07:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435168E0079; Fri, 24 Oct 2025 07:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA488E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:26:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA6CC12A199
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:26:27 +0000 (UTC)
X-FDA: 84032779614.15.4907A1A
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011032.outbound.protection.outlook.com [40.93.194.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id C2F181C000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:26:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ob62X4ys;
	spf=pass (imf18.hostedemail.com: domain of ankita@nvidia.com designates 40.93.194.32 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761305184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45+2YkbGU+Ct3rHZVzpRzf6PM3+zUhOxO0lgUQcMT7U=;
	b=YnPqx5AiMNfdkMPH8S471DVtFlc+vUoYKMjzvwY+lw4Oh8BpMUBl7LL9uMwPa75jJc+xk8
	d2Hm7thPE5RiJidNcXcEEo5M3B7sgalcaJa1Ouo2bKuJ7z7Lq7uW3/ciKmtcbGLWEgB/DK
	YSTbdOGSp6QmJFuUs4XEWlD9DfyqvTw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ob62X4ys;
	spf=pass (imf18.hostedemail.com: domain of ankita@nvidia.com designates 40.93.194.32 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761305184; a=rsa-sha256;
	cv=pass;
	b=ruwakOq2OL54SAjW47BGjTBp+O0V6hb6TBiik6hWtHq+hvs/ioK2RSoROv8fIaLU6lzn1e
	jIzu6sv2x/VNPuRFlJW7SMJcZz53rNsx/lAV5niyL8PYYpGJEpBgI3EGjrwpPNOAauHFmD
	Ccfw5QHdjRJwPls5TnrQtRTiJJSIWZQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VJqeuFHRGQkn7tzFx3PUoGVOqZCMK2ra6XWDuW3nBQHVQ9czX1bGtd4PoTM46aAtjQZzrb3puxJEafAaWJtI+jIj3W8JHbkbyREm+vb3PDDcVtgNS/xvLWL33Y238s5Kr2pLjmWLu9+7ydv+WqNQrWIxyL+r7X4IC9Sc7Hd5wwwbblb+tPfHpTl1w9N4X97FPRWSFpdVsrqpeV0TtoMzx+advylwxN+fHxQBoE7denNxEXIqjt7zBAsFMtNAXsIqMEnWwODxAqP34j0sRxF+q9/B2LoQiLK49e1O6KXuqhHO3a2vmBsKoqWAj52ITW57aeBxZe9EbO7PmlKuogGEhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45+2YkbGU+Ct3rHZVzpRzf6PM3+zUhOxO0lgUQcMT7U=;
 b=O2iF28bEqZm5DCzpXTOpCI2TJc5J1pynqeGKY6f9ddW2mSj00oFR9cMeW9jYym8tskkVNBIDH+AjaW9Du0mfIQF01N68cf7IB402K6Xq2M3Eg7gNTUbTKd7w/H0cns/tSg3Den/N9Ud9oK0ACHJJA+X7WexYbzsr+YzE9nO8YINSKONrGR0UF5PC+uMex4K0RvAOE0b3qDElA9OrbbZs+6og20G4/2saxd78QLhmIdGCMcA9m5NGz3pQHtlQvVApw7KyYFa5j9XBrC7gzJ1XMR0WLdZGKifRJvh5d0j0WmXmHrxsxNtY0k/XtbgZ+f0vkgninOwY+kHNhpD25R9YJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45+2YkbGU+Ct3rHZVzpRzf6PM3+zUhOxO0lgUQcMT7U=;
 b=Ob62X4ysXkjJsFBJmmaEGX+G8fVLy8qDaSHVU7WqzvyWuglUSVAo4RRqAvK8xemio2piLJet/LXu4qDpItCyFhnl06jjyVOEPgFBWFJ8wn5aNyo8JG10loxYXMgDmPWAAN199XKb9OyPRnrpx0pKaBi1w821UUvjv/VyMA7sR+JIEaNUMmnOd67L3cqqv8SMZyFLPrHoUdDHdgmQVZVAT2Vx9qRyx6FR0glBRRnNSsT+yLGlLC9VQHtTtLuKkUUWKn03Rsv/qgXXnc7zoNQZvVntE+pEIuXmWTk15QEC98NVoMfgY78QCoyio1IVYWscsxnzVi3kT/bOzaUeMCr2mg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DM4PR12MB5724.namprd12.prod.outlook.com (2603:10b6:8:5f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.13; Fri, 24 Oct 2025 11:26:19 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:26:19 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Shuai Xue <xueshuai@linux.alibaba.com>, Ira Weiny <ira.weiny@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>, Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de"
	<bp@alien8.de>, "rafael@kernel.org" <rafael@kernel.org>,
	"guohanjun@huawei.com" <guohanjun@huawei.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>, "Tian, Kevin"
	<kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>
CC: Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun
 Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj
 Nigam <dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct
 pfn
Thread-Topic: [PATCH v3 2/3] mm: Change ghes code to allow poison of
 non-struct pfn
Thread-Index:
 AQHcQnTJ7CAM8GRhqkeBM99OaIj+UbTM1xKAgAABqICAAONpgIAAiRYAgALQuQCAABSJlA==
Date: Fri, 24 Oct 2025 11:26:19 +0000
Message-ID:
 <SA1PR12MB7199585DDC589EEFC23FCF4EB0F1A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
 <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <81b1f1c6-4308-41bb-9f65-f158d30f27bd@linux.alibaba.com>
 <68f8f254b53dc_17217e10069@iweiny-mobl.notmuch>
 <134e43f7-583c-48c1-8ccc-dddc18700d3b@linux.alibaba.com>
In-Reply-To: <134e43f7-583c-48c1-8ccc-dddc18700d3b@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DM4PR12MB5724:EE_
x-ms-office365-filtering-correlation-id: d94683b2-766f-4bde-8df7-08de12f02749
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?l0Jwn0VdKBMjs7MhGOIxQi4Z4s7ihpqOzuVCUH0kkRHdBDsvypEdrxRomL?=
 =?iso-8859-1?Q?Msag28jjgDBYIBMiwOc5jq0jbA/Gq7u3YmbetxVj8at41BObPjDFjlOqD6?=
 =?iso-8859-1?Q?jAqsZWxPc+UcwDjJR512wn1le39Hb730RjEUaktXprz6bkn8aocWWRQmDx?=
 =?iso-8859-1?Q?tJxSKrmdqgHED4a7nXa+p2jDBWrI5T1ho0o26bXEJTqVJ2ASV//UQiGf12?=
 =?iso-8859-1?Q?zRUZV06dWK5lSFyQUIUT7WxIdtQJcjt4JQputb/Wwr4fN8co0Aj1DAqpfO?=
 =?iso-8859-1?Q?syGV25t0T3cNF+JUl9VjzoNhuRzxfN9h0nwRf728sm/eW/fMP0ftycwWQa?=
 =?iso-8859-1?Q?jPK9gVqjc+8g0iuycr/TITI0zgFmhIq86ZdEuPllIgQdqvXnH9u0Xo6D3g?=
 =?iso-8859-1?Q?UAvxJfagOgZEQTO+Wp8L57WuQvaRxLtnz0/h+1TEeYZrK8DZ3D5Uf1D6tS?=
 =?iso-8859-1?Q?S+VdGLftNgBugXChFSO2iHV45/o6brPRPNHj1WvW7n1P8awEtt86kJ3oZV?=
 =?iso-8859-1?Q?Zz+xj+OthVv+6KuxiKQKdOF0113rviwUHLdq8tk93qCt0M/87950Z2nzEH?=
 =?iso-8859-1?Q?hfgQ5lb7Nq14hkSbk/94IkD2e+OcdOoVeWQK6XRAL8jID8Cl/NTGc4Spq3?=
 =?iso-8859-1?Q?El+5jIlnX0PzLko5y0O99gBZQfd/CD5VIkUR9CXeXZB+pNf3EA6nDri4pq?=
 =?iso-8859-1?Q?EUeKihUReJGY/VHd0IvPV//HuR6GxaDHxQPikAyOpRqIY7FrK5RAlgg00+?=
 =?iso-8859-1?Q?hERGzpKehMwD5u99eJdbkqEbW8VtF3FuUkbmexD1aoqRGZGjMAF6TPx94o?=
 =?iso-8859-1?Q?iuMvK1NyL1+zw7f6LdVLL1X1Di5ve3T4KgUUCETJP0sdD5SZFYgaJj/s6b?=
 =?iso-8859-1?Q?SY4PKHMu2nzDriUbx4HYx2eTdISYgKap/qvakMoZEFZLxy6MwgAXXbovL9?=
 =?iso-8859-1?Q?pZ2yWWUzlSxPEYN3Tjva5i0DgWs04m95VudEu4ZctBZptHJwZ5lXIVmSzB?=
 =?iso-8859-1?Q?csdP6yIcrV24pghzRV3MwgCZnX3xK/DWVCbiSQjY1cNWTWgjqGWTCBpr9/?=
 =?iso-8859-1?Q?+deVFmE6w/cSHBRMPg1GK0dMcO1yQXOISFaixccVwAPyP9szFlgB6BvU8D?=
 =?iso-8859-1?Q?jxApVpjpRyntiyRxJVQwTED+09v+d8dLV7ixOLgkCARQwLs9McpbLYTbfo?=
 =?iso-8859-1?Q?mDKJfragMDl3QBPbJlTkhPKXUK5w5pjV0/oVwMCfoYXEVQBYOPTPGWRIZR?=
 =?iso-8859-1?Q?IlFcXLzcsop9jeMGcGQAAwFKp3N/e3gIkEuisKpfgIvCUJhphPUWu9jlb0?=
 =?iso-8859-1?Q?ibvNSy6HKDF0Wt8qGVIoBDiGvwFRhwi2U9hQrJ9yem7+Rq074mN0vymwBW?=
 =?iso-8859-1?Q?t1/ZfnHTk1K+cpMJkLPOf9tGF7DNHjilbnZD7wKQdgfx/Ep0TvWNEIsCAN?=
 =?iso-8859-1?Q?GCMpNQKCoBXdUhL/rfzDNTnnz9ouqydeaLy7wSZAyEIYDGnB39Rx+4UQFe?=
 =?iso-8859-1?Q?0WT/7MZU7jI4LBlnLGycv+PTVx7hwjxNj0I+3FFf/60bR8aMcEn1QHtJf/?=
 =?iso-8859-1?Q?D9bjk3cE3muw2pUjGnA0/o9ziZ/4RrPgrr29dN0K2YPOAU05yQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?TPbukBI15mAyK21vvnoqs1W6liQIHJJwtKCQ2KiNzo1aJmn5o9efx44MHJ?=
 =?iso-8859-1?Q?oaPhG7WeSKNdFD1pFH1RTCuHYkErRNXWRXRhy2EuLeB3zAfaKa+3kYHTPk?=
 =?iso-8859-1?Q?KdO4jiPHyI3DBRCm3Rszr7vB3+9ryDL/SwAwgK/WRjsKho4yA6h9aO2Yje?=
 =?iso-8859-1?Q?P1UU4VQeoRuR5XYsBpINUjktU/Umnwc+mVsWy+WKUNBVsQ7s0dIke44QaV?=
 =?iso-8859-1?Q?PanIu7XtBEuEp4ZqpWVWwK//sD+KyqLwEaOyth3RAIdpFyfju9IYY/9Q8I?=
 =?iso-8859-1?Q?E80+gTOCBp4atGnG8NUfraxqhE5v5DtLu11EC5q5/LdXBj601Oacv0tuP5?=
 =?iso-8859-1?Q?ffhXu9L30NE5xyz2X9QaV/En0FQzGnJlcddd5khoY/LPnD2b0qQkgATOsx?=
 =?iso-8859-1?Q?5AZ6pkeEo3mu5l9TlwhtYVpagH6mYG315uD2J3Hy3UkFAxIM+7QpFAO/Tv?=
 =?iso-8859-1?Q?vgHp9pkn5T5oA1NNxb65iLQlakwthU6cXOW2Obm4VsgGWAfv6AnU8P9HvK?=
 =?iso-8859-1?Q?tSQSP/WWts7Hd969ljZorQqb7UAbdggnX2YtkbI2aTByrfBrpXPTmndCNg?=
 =?iso-8859-1?Q?RqRTsiO087ZBnI9xG5TPC4kPmPPTXI/V6WFAnez3MDBZLNQO5pwLL6BHeZ?=
 =?iso-8859-1?Q?+NSHVmX8PQ+4eqyX6i0+EFWN74IvXhrHY9hC6GGuKIoEnSIUuhFhK5a9ij?=
 =?iso-8859-1?Q?bnx3Mx/wlDNg5TTgNIiLIPzRo4Q497U7/98KusnZ0eM8EF3w/WO8YOSqMB?=
 =?iso-8859-1?Q?72YM3Y5czKfEOocVnhHM4cKLwPyI+gXNxDdgVPVUoBMPveXC0F93pwB3Vc?=
 =?iso-8859-1?Q?PdIaLOYK/1l5Q4rR1swUj6uLQp3/bhfIIOjR6yRRhZ04D0Xn4DlLVXFhMq?=
 =?iso-8859-1?Q?CxzT5luX0Iee/RkC5NltX6MH+VTi8Z8fFd0YpuzXpT1d/L9J7WyTeEfQaL?=
 =?iso-8859-1?Q?x78v83MeU2QUtlJ+HoD66KwnGXjpt53hlRbomuJSELKcDrBHliU7v6fZT0?=
 =?iso-8859-1?Q?lbYgyJcjk1e2GsF4IpCR8CMMJU+w/NLrkfnmtaHiV8zaQlKgjnd2Usc639?=
 =?iso-8859-1?Q?ogMb9Q1SfBP5IvEcg5C8ZFZEyXFDlMdHNG5yK61Ye34FCQWanz3EcXzNtO?=
 =?iso-8859-1?Q?uxSTe4xwiAAzUpDfgqhMuhltyjkuWi2vQt/zV/pqZ8SVBLG20+OMLKbEBw?=
 =?iso-8859-1?Q?qmA9YI+aSYSfKIn90n2GEjGJemg2CRb3i44tbnyWsHmPRCL5zrXQcDR7FL?=
 =?iso-8859-1?Q?COsFu4C7kWZpjz/GAzPdaNCdcvykVDGYr57HJx2CIgqWqJE8b1MXnqZsQC?=
 =?iso-8859-1?Q?ndO8RiBR14AQMwWIRtmhYEeXjsFxyE6b2BQLACBxd6m9ratjtLeBxcEl8w?=
 =?iso-8859-1?Q?LZVGQkIF1NYSY2ROLUrHGxqCcGgMYJdRovj7Ho+izxceKB8cDjnM9uBhpK?=
 =?iso-8859-1?Q?b0VpFfuhTKSf5cTn0n9rKTAjUI4dme2Uk7BXGjG7Ii2Ji11i3qWY5mjD3H?=
 =?iso-8859-1?Q?LofqNa51Di1TZBCYshP12bDr3Q6AFKqLBpfjcXK9fl5U3ou/GB9iZygy5e?=
 =?iso-8859-1?Q?9pcVytLX+o2x+uwiwiBIUuJccVtSF+ZpE/O+KHlv/rkyfTgkc7ITQYxEcE?=
 =?iso-8859-1?Q?1Q5aAnXAlOtxw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94683b2-766f-4bde-8df7-08de12f02749
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 11:26:19.3745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NOH2L08VzvhMGnNDMwb9Xu0NXUuIHCkzQJl5vpD1Vo7YM/KSivf9EKZwH0NW5PJnQHspvr/A1jawUyD2lXtb0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5724
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2F181C000F
X-Stat-Signature: 354n6fibz9bp1pfnyrd6txg6y8bye1np
X-Rspam-User: 
X-HE-Tag: 1761305184-593605
X-HE-Meta: U2FsdGVkX19VxDY2Xpwz2N/ILq8HC8muc1kA/jqH0HQFDbz9MHIFQrlVQwHW9ld73mRKYBK/sYMtzUnoC9BxHL+NlTGHYsAJxjRlMHlidyGzFZ34BqO80wGY+HLJwlXVsCFnQY6LwfJOIHvu92xlCWP4KX7NSTlNJ2hif+rfr3pXMoWT+R7fPrupX8lUUiZIH0Y6HSrwqUH7LDvoymyJZVm1sRIum7Pt+Q7sE4IN0TeF9jEPd4BIHyD+D9bRR72QP5af3q5VjEU3V9IKr3SSaXGVPk7OgqGYyr/ugDjIlSclH5bLo3MEVWaLmDkJmUoAv076Za/LCVRVHvvTGjdxpees5rl03ZnLy2NtKtcDSxVBfxunl8YvrA8mnXtguL4DAdMKv3AzSOwLj8BdD8ArMi5+PCXxSqnca2EMu74AZwnCxEsFDN0a3h3xRl8u7BQGnghcYeWppLCUVliTTpa0zkVpMrvFRs8xJk0df6zC2n2pb7L2Ds7XJsEdvDmNvMBEgXobm17xt7PpVhywdMuFSoUMeYiiouIWd5/54yvzQFYkGKdMb9oZ9yTQOIgNb3drex81vskGRpS4YvACR9/HULlugHExDPe31ZZ0RhfPU4u/isN+5L6r9ggkQnW4N3BFci0obYuEQuqi2dlIXd29uraXU3NS7XhcwgR2v9T8O8Q+h+OWMeHODfBe8tJ+0IAmGm5fOdZjSDcS4mlNu91HC3PTOQDJ5abTd0hWP1JRMbK7swULCHYuA0UF2GLabVF5405Fmhzr+MT8OUrz7SUN3Yf4+mPJH8WhHKSNl6S7OdRcGa47YH5IAyxGLNRqkf90fV40wEodNLqkulD368V4bval56TzTuHW+3BYvI9gfQYX5kgDvAmytF4Jf8sK99vQ3UH5/FtOqE61mhv67SsNcoOLYFqJ/2q0pxqt0Db2uDOUuaCvbdlF4Q3dhz7IrusiNSBwaVZ8ksbcyx94ee0
 bhopAsdC
 WthMotdaYg72E4iPshAFEWWbMRAtrbNuld6wwoPozqbwq7zlaZ8a2QWJprYm2mt6qr9d+xE9BYTpaYXi2SSimZrrKPKRRYHNV84VBWRzBkgL8lJhxBJP9VFkeejkKRdFU1EMVHjHONR3YgK3vXjfJgv4AM3/Zr5AK5onPEiH8f8HW+Nh7+8ilp1u8j4UlrIGCvmrdztW/Eoh7maxT18FgmwYcaSgno2MSZcQPswq69TGxS/CET5CDjyz27we/RDqP0rAQjkiVkCCwy2Jj/H4od9hwOhjUtjW6a7RK2UEHWwtSpuXHXVfTLqd8FnNXNximB6NAXChgk6DZjZA1pxUhT4/+ED4bwc2fwhIOSys/laFJqlsW7MvwO2kanakCF7/+zL+2D1TCuPeL2kF0dBBO50z1ftAbhhpAuFb33Tg7LHdhknNKJ+zpcjOTeZexK2dzsXXNQu5Lm94zT15xFrrfuVW4B87+GXY7tT5xY12zDFkG2PjvsPWMDpPS+CQutg7YrZMbVF+Qke1JFHHJNkd9KlBywbAu3qb6jQBqn1urbNn+Ca0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> IMHO, non-struct page PFNs are common in production environments.=0A=
>>> Besides NVIDIA Grace GPU device memory, we also use reserved DRAM memor=
y=0A=
>>> managed by a separate VMEM allocator.=0A=
>>=0A=
>> Can you elaborate on this more?=0A=
>=0A=
> We reserve a significant portion of DRAM memory at boot time using=0A=
> kernel command line parameters. This reserved memory is then managed by=
=0A=
>=0A=
> our internal VMEM allocator, which handles memory allocation and=0A=
> deallocation for virtual machines.=0A=
>=0A=
>To minimize memory overhead, we intentionally avoid creating struct=0A=
> pages for this reserved memory region.=0A=
=0A=
Thanks Shuai for the explanation and providing the "Reviewed-by". We use=0A=
the PFNMAP for the similar reason to save on the memory usage by the=0A=
struct pages.=0A=
=0A=
Also as mentioned in the 1/3 patch, I'll move this patch to the top.=

