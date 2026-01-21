Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF35D46956
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5D66B00C2; Wed, 21 Jan 2026 11:57:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C9B6B00C3; Wed, 21 Jan 2026 11:57:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3BC76B00C4; Wed, 21 Jan 2026 11:57:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B23F76B00C2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D7EFBB6AF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:21 +0000 (UTC)
X-FDA: 84356576682.04.C923EB4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1834C1C0008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=haKPleXf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bWpVTKvm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BRZ85az23keMYfKCiwlz8J93jy7Cdd8clS28lbAo54=;
	b=8FyLrW/6I4MG1/A8tXXg7Q+tCiuz29nVbkfbTzKP5uNFqngVTfF66zTzEY4XekQnn0vsFm
	GXIkv90YUTXVp6u+WCGtCKECTKpdSgnWjpkx/W2wT/mswdv1MAu7VduLXIqV6fax4EgM3O
	FhfgQRsPg1hom5B5whj9cLuoi3FnJF4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014638; a=rsa-sha256;
	cv=pass;
	b=inR/Rfuei+wNmb4Wbm6gnKBtSsV3qJ86belGcoYazXZYsgI0O19LCw6FGgISwiHU1LXjSg
	a6hgMFQ5OUEsG92DZVPagQGl+ISmiiWwqYliHxMyLa0Q89hwyWcZoiewllLICHTOEgwY9S
	1W87CGtCiqPZTtg9fCop86a+vz9YkwY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=haKPleXf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bWpVTKvm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LGPOXA720383;
	Wed, 21 Jan 2026 16:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6BRZ85az23keMYfKCiwlz8J93jy7Cdd8clS28lbAo54=; b=
	haKPleXfIvMVwjD2Ei1Gmtn9XWEBe9+dtPpf9H1+8moMi18d3A9CrlH0yPY26Fhr
	ePBkiuG2vdtlYRVWDIRp+7Owdclc2YWuUou8Iftf37/qaCcalbMNZrp6GikLhSmB
	gl7H4rTKGoPO6Hk7dBPfmgRjb9LR2AQc23lVBrJ7OgizjBSudlGil2Uh311myCk4
	rQKGX39+T3akAmBB7xvtH97hGzUoo3SrNE+oHrOkfDHj9/JW+iihT6QrXBfhLiZ9
	afWoL4cS87Sbr+SrPl9nzinBbUiecOHRoH/9AG794Nu133geYVjo8AzSjn95Vn7/
	8bSaeUXKHyGm+JL7AV2/6w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd2sp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFrfxI032158;
	Wed, 21 Jan 2026 16:57:09 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfamkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n7K0o70/Fr/YBvG+lw+FnEGfX3TUpNXMUscwdMDqSTwT1nVFjzW87bhromCzv/nlvEuyNUjoi5Vg+H4SNw0DqsqWWaRbjrZwrGGTcvplqttmHBMqKX6ZWfN1CJqcFa25lRh7+JZwnLpFht7GvVX9JieL28VP9KAeP6UJWbDRbxv2QBgdTVaHw7Nyh+lYwddo3ZNaisqETcDlhNtDuloidYI8RKyVTb87nHlbZQyCdYZjtONG6DhYpdeEBNSvuQuWshdfY6TBaRTdvbeRknSgO8uC3YpA68G9f4kUwZ/+tNe1F6b0ccoL6bupjUlkT1nmUvlIyiDvi3gl6DckitNSEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BRZ85az23keMYfKCiwlz8J93jy7Cdd8clS28lbAo54=;
 b=H+9D0VNKoqVWptUoWwEnGmWD5vtkXPoc3/JfOBNimLsBG/NmsbYkla06aaWiHnrUUgjKAAhcWtFtDwyMf5Lgyoov7FaT9N0yAv8GevT7yMYODXXbAKrasZTmlzFdPsoH+pqu9nMGqRlDVcX2SY7gCZz9KNPrVlLPmzj87KYWokTOlWGhHnJE07wWKUuDQ9B930vj386lTfYu/9WxKHHGhIeSeZSkD9zsprGb2YebvdErLmxc5mY/TXZi7hjq4iCGtm/+fIhpYwfo20Bn2B6C4Z6KlGMD55DDneX3X+Xxt41AObfBj39ueIJCTw/20AIApwm25jWp6ni00BBpnGe6wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BRZ85az23keMYfKCiwlz8J93jy7Cdd8clS28lbAo54=;
 b=bWpVTKvmWF6A3svkTUNp1U5V7AEgSZtt8pT9jd6Ig1CgiochCWDk1zr75B+Lh+w9ZNkhxGuiQoFotAaAQOQ94dp2YXJavplO5+j6n0S1fc4jBup3IYaziOgUyLr4rElppGQwAOUQCRNdhaZ0g0HGEU1ZiMDSXN/gEIBsgKtKyxc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:05 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:02 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 09/29] maple_tree: Move maple_subtree_state from mas_wr_spanning_store to mas_wr_spanning_rebalance
Date: Wed, 21 Jan 2026 11:45:06 -0500
Message-ID: <20260121164526.2093265-10-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0087.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: 3068335b-222f-4fb1-6ed6-08de590e1919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bTdxjdvbqZShG233P4nMzW9lAPpolPjV1QrAwXHXtL9aCjCnEJ1CL5FRqLI5?=
 =?us-ascii?Q?itzhIfHZPP/UmbtTM8dDIWWMNhw0lVZkaPOT/2FJeQxzJ+KgQi/9C8TogTLf?=
 =?us-ascii?Q?DSJrj7Soc6itC8BV92S8NRcairGRMdTX5dDqGezLSCxgxwkKgkVXwquVS3Ft?=
 =?us-ascii?Q?81xubJpTW1U90aVGPTdIjr156yD4k3jh0Uu1sDylvzd07dPWm8JqYo2vLp7v?=
 =?us-ascii?Q?zCaUbUWa+LDKCpr+LDFY3oQBgVn0cO/AhHvdV635ZZMAW4quzp9kePCgFoUp?=
 =?us-ascii?Q?etQ6esPqd8kxi6TGf+epPzp6KRjhQWwm5CUj5x32TKQyYoh43PEDK4enyryn?=
 =?us-ascii?Q?QKkz0VkcZqcPla/ZMUQICLTTvmPAOY2AA+MelS1Velzy+mKhoe/K18Nw47GN?=
 =?us-ascii?Q?GMD4AcbQIfI9TAzUauJUyOxPLF00qhnzvjDybO2AEku2TQUL9joU/mFEdky8?=
 =?us-ascii?Q?XH6kmm0PNgTGqL0odXxvp1gybxWvx2nkOm/+ZP5PXiTt0+N7FBLLPN+YZbjQ?=
 =?us-ascii?Q?7PgxzO4nHqlREul7csbSNuIbgwQoivYf1W9u16WpmQ6lQ7BBSRWUbO0F2ZW1?=
 =?us-ascii?Q?ZCDkdh4qzHbw8v8L+6ueJ/EqeNJWntiTM2Bec2coUbUCAh2vsZXAwk9AQKuE?=
 =?us-ascii?Q?y4kHGsweQHt7Yg8ShCj4oQmZzrwmZZWfc8fFsKs2885G+YRRxEm7CcWYCIyL?=
 =?us-ascii?Q?TlA+u1CBYbWjOZ9uBIEWcbooKB2cI76cRkCAKXCTCbH78bWopE90bQnuaOr7?=
 =?us-ascii?Q?158Y9gYifmZev6kPM32hVrsMIKXTdiwVLD1nkMN6mtJvXbDzykEABH3pf5gi?=
 =?us-ascii?Q?iaMe7NwqpAVW1ZhU+vyqziZId7dfPOv5qr7b6cAR850FHrXF4LlLHkn7iKuP?=
 =?us-ascii?Q?3QO8lnGpXkbpXBnxxFMab/7czrViFmOPU7k4UgrbWBBkE5jrUEAuy/BSSpkM?=
 =?us-ascii?Q?m9W3FD49cHc+wPo+qlX3Pojcx4oWBrc4YEa/kWdIgjrFEfjWrdTV2fsupvpb?=
 =?us-ascii?Q?q1rbppMY+Ax2eKJwuvgYRLOWSu1SSAAMxglqDFu3YsnZS74gSdV55lxvTE8n?=
 =?us-ascii?Q?QEcTTRNL5nyusSwV8KABCnk6OLx/M9Xf3IFLeVVESDrk0TWV9s4hrxrpfFh8?=
 =?us-ascii?Q?oOMMO/4siFnV/REenB8JwtFm5/GD4eDb2tEcCpiVPdTfbk9CKbaympGtDrTh?=
 =?us-ascii?Q?ABQ/MVKVABzKpWY03dpK3fKziuvFlkrg44MKFoJqc5cyTUL0EkKe6vKvZbgS?=
 =?us-ascii?Q?NtLXU2Kh+6is3IevZ5rIt8Ev41n65v+9KYMohcNfdJ+UTGtJb7tgjKfWQxpi?=
 =?us-ascii?Q?DOe/wFETZi43cnY3T0LNxBBLW/giN6r9oarBZbv2eAQ8jVywKVfbiQL45py5?=
 =?us-ascii?Q?WfVWC3UUzgS9TL5sG5I+nwwREhFHlg76a1T+N4Obip+8+F0ZsBnb8SHyk28S?=
 =?us-ascii?Q?sbjhM2YRR5StOA9Gxxq827bznpl4SV1WXYcOYNqg1uNOcWgCjvXwUoXWSRyS?=
 =?us-ascii?Q?9MeCQUeF0ZXVUSy6z1qhnDmXx8ovpI4mb2u3wN8SOUlNil0YHm6daIa+w3g6?=
 =?us-ascii?Q?bTbfKZVKTKlW8h9csPY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?avfgxHuW8kSm41HTnMzMFZ+1v7vWMKBmodxvqFw7nts467mX3eHd3hKnBdMS?=
 =?us-ascii?Q?0pu2u7ahejOWkRNuqYndYJpSKXK0ZtxdttaqTvUPo8XFx9QGn48z8yr+Iri/?=
 =?us-ascii?Q?UKHafotjH4wUqZ1Z48FcsaYOBjMA7jcNE9+KkHL3zyAi9ABnNqzFQLL+9ijQ?=
 =?us-ascii?Q?W7yTI4zH1/Y9FGmQMuYYyYeFNrEuh/sLs9jlE9pubKMrWv589/OkaaqQ60pO?=
 =?us-ascii?Q?IsN8ybnmyq++PyUjmXSsNd4WGCDdcXx3s7VhVZR+Bbade6WhYKW+aNkaoR3B?=
 =?us-ascii?Q?ETN8uON3d0yXCHietzVvjHK7y+5QzvCzOn0xr5EsfJv/yBwHHpeaRddwBPz3?=
 =?us-ascii?Q?4wHTqBi3n23AD678LiegsgcOpCpvEwbCKh3a886aFUo0DMKHNR17ebkcFYEw?=
 =?us-ascii?Q?czp0Q4CzHrKXti5rfmYTiZNn2OArlw8BbzJuBCqwSrV/LDBQlqBnuR3JWF6U?=
 =?us-ascii?Q?FQiKQiJz6g33xpm/TYOWTPX8Am30VR8WXPCCIJybzujvRHG0jBHOb8fuORYD?=
 =?us-ascii?Q?RzePk1ZodShXoA02DSOL2YrNuqHMMc3CTRUpuCh3RCxGjB6K0W7obIrBHL8T?=
 =?us-ascii?Q?hXnKtCDqKtldFXXMxglKmhtkiqw/XBwooFYzCQZU9wgAhM9qjeMtyTFaK4A6?=
 =?us-ascii?Q?XFaYKv0+mkL9HG08TByYaSZUGvFC/jqEdN9tcbComRRDAeY5djaR40WhFWLh?=
 =?us-ascii?Q?8LO3SXeXq+cp3hgLYdNgIHrhtugsto9zi84UnCs/ugp2polwysxcNfkn6pCZ?=
 =?us-ascii?Q?ppLFHlOEKh8BmkVw/U/uZPe2WK/r0hGFWcg+Q3MTUW7QhL4mhOvJo9RLXo6C?=
 =?us-ascii?Q?TdMVUmUBYFK6sj6UodRjtAZ9nWFFyMmKIeLrpvAsaIK+bgbPDyuvW041TRyZ?=
 =?us-ascii?Q?S9uVe88f+uBs1B1pCiBXOVE4C8Tvz24YD3v4YFPjgWifn12pZcbMHtVwhSho?=
 =?us-ascii?Q?RleQvbo7F4fjCepKOcubGohfdUKa+1l+vVZuC+gFmONd+iD8atO3ZvtoAKsN?=
 =?us-ascii?Q?vDOZgYlbLSRWVsyT9r0ECXVKzoEnY/amBrqO7XHcpNuJ0GQDnDjmxuakrGwO?=
 =?us-ascii?Q?cVET25R4GWjDj9mEr63/ClZSI7L5PaJSTzlfXFSlhWLzpLD2rT9XicKkx6Aw?=
 =?us-ascii?Q?n35rIO4LdKRnj0LeXD7OwBrLRnkOw1hSNGtKPZYZUcnDFEUugcnuiajLM6FM?=
 =?us-ascii?Q?0Ns/tnbaQ/qkOI789ul+MuY4qc48Ag7odUlLnGhiXO+L5wtyMF2cCUggpse0?=
 =?us-ascii?Q?XMIFHKH28e9yWyxF7pf8eR8KFE5KXpDBgrToiGFF71WBn3HUsyrY6EsSlWID?=
 =?us-ascii?Q?/iZrdOREyjW8Y+tfjQrpDQtRdec9N4q9XLQcrih72UAtnLMynBjgj9Nplar8?=
 =?us-ascii?Q?rUSDWuxag11xl1MCH0a2yc8nxdtIIKsZLa/u1BPxnDRQypbTMMGkH1TW8Ckj?=
 =?us-ascii?Q?VTr8v7ZGdukDfl1lhCzoe+UAAsXApTReY0SeDYQiKx82gImVSpBITMr1xY8X?=
 =?us-ascii?Q?3NuGtYtkNWldYVSwPBUE3UOt7MRkt1dsRPKps9SbUP1bEvU7DN3AFLb7yA/+?=
 =?us-ascii?Q?YttOec/PyRnrytiwLbn/Du8pUFOQ8rW7a5vLv8R0IX+7U+tnhFDiUSlO/BwO?=
 =?us-ascii?Q?XnSXdBCeedSSYsPaIv6O/vGsANP4qtLm0fIJ8gstWI7niIQ1CP6HdqqgqHSv?=
 =?us-ascii?Q?U/IUfaVQbwKQk5X1Fo0kQ7C47Yi/EAQyfOwmXSb2px1uLmtLsd3OsbRB5WYk?=
 =?us-ascii?Q?CaL2a0O4hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5l1pNpGpQzS4IsMYkrY4DZPh7qAxMKXzBVcUmOY7vuT/83mKQl0Dbag1u74UHcEaidkV9+3/X/5y2xUYi7yw3Es4eCQ2Dd+nSPZJVmLrc43JY7dXXuUurwuQ+OVqj0lzCL4lN6hnBD0aT89lXuOkiaMsKVf2VMP8gIEHys4fZhXCf/MoDGku6yunHICZm/99/LRMlq8qLQn+ZUz3E4OcYie2riWnvHBQHlYioLI96OVaWyWwSQGVm56PYSeVTKapMDArb3MjlJro1xvCeQ/tv18Bc8oCqLnuldBf5hDQ0W1C+pgXpqGSYAw4z/Wa7cLVztxcnqMUlPOc8lmg/gXbO2QBnKenrP8WKdtL16w80088HJi4z575Jwg2aiEXQN5cCiKAzvx/OxbNQMxD2uytHM7qiU/vH33HEpCMypiawwhlIMu8/G8/tEB+osewK2oTi3Uyu1NpH9O4iEZgu+7o7PC6eiRALP23fqAygGrCdIJoNjHnNVYBJ0OXzjLDAkmEVH7b1OIMQEzcy/aW7n/eIFQ6yLCCLOk0Nltm7fEhKYk9sAcz9htSJPaGGBNuiLteDIr9+phcB859vZmqd5POHwh2eOWSSVkO80NF7WU4I2c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3068335b-222f-4fb1-6ed6-08de590e1919
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:01.9660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/DcMOSs0Mjk2uJ69gEQpNq1gDugXgzx8ZsV2OK1vkg30Dk3MoeEFq9hkHO4WIBgEiAkxrN4Ct+gq2c7CGmBZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=69710566 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=CYoulDwovmb3McnCtv4A:9 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: FCTEsRpoNQPTljiJdw-ygYIa5vfhwVdA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX3kgRUsY6E2mV
 8aImJOHGw1whPJEQW075uSTcLF8+ArizViTeS9sJUeVosS8MwXCwc2ayy5R6pGdt604waRFEDp8
 QL2lJR6tY+ZVgc0N5vYkMB56aA4g1/bftjThmHnKkFznEFGXIwPU1/Np5Vp+BNSjrRfWN5Vt7Ix
 sUznLuSnsGNOUM8K3knPWTJqYNrAvwSPCW4ZdMETLo5RWRgJ8BeMMMFV+IDtG37JSsSOvJCjVUH
 MLvd6KkQlNsurd5l7+ZBpTNk9NyDqNbqnViWbHhgARxvFBikkSv9RergCZg6TFli6r7zs2jwSo9
 lp3K/UC/j6K3DP5eqMLKjntpydZSqeY3e341mUHExIiPoVyg4CEWckId+2Kk3KgwMoqyMMU+Tvn
 u88Xo6EGfq5ItlrWR/d6Ym1SP8R6HbOfjcZCqGeuIkbAD8MrDVM2OiRCUogTjXWDX8vGWgRsn/e
 lSg4U4JpKFuPOBxmerLf95f+rGze6nRit/EiNvp4=
X-Proofpoint-GUID: FCTEsRpoNQPTljiJdw-ygYIa5vfhwVdA
X-Rspamd-Queue-Id: 1834C1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gyqk5hzntxuskf83nrqdiexzj5thgxxh
X-HE-Tag: 1769014637-455196
X-HE-Meta: U2FsdGVkX18XSpuXP70BGIPSvlyq5E3cYbS/YrU0a4cQUsLFm5OJBu6k8M4Cr+Aq9IL38K2ASEl/C4tYhJUwyEwho1jtaJvuj3SuQjicD8SxcJq0WmX2EYqe9tUkQqKVeuhKyKw4OJmp78vboVXU4c7MSqLX5Vzycl2+EVf3/lbndKQ6FTrkcSEiJHWnmFKV9nrmykUXChKKgnCB8xAPRbv/zTBfud7mkl6DTbt0JobxYOlIaKy/7FPWy+idpLA5YlfPmVxmEPmWUpbIe5nnjU33R9MexUwkgwoCy7mksnS/TpLxHDTU2axcRX05idTqB4LqqveTGoVY3Wi63cPzlkCtCdErbu90JWj0i1jlsnGOKt7/hORKbcfFd0RcAn88Utp1keLNbovEQKKOIY6ZS2UTDqOFNSqEmtrO7G1PMsteaTgGfxNfduoE2dUwRRHfr+r7aNPKiGLlXWb2/Gy5EN7rlehRU+YXPjDNc+zeZnORfQBhfCLaLkg3n8Om4Q5MQMANixNaYRNfwEKrXlAFcuXYGWT2lFFScP7ddy2X0aF3YMxfji6ICPVA6sBIxGdHs6nfLzgu46eAfYNxh7+sDS1kj5sO92z96yvpnvVILOw8nPg8yiQHhkrE1V2gm3L9+sNjdW8TXKMtNUTjgCCJ4Ott++f6Aznk+3A/QKs996dk3obS5rGHz9MGA0ojMHVfuu4csJflzoGSshKt8TR5nN2pKwgf3/B2LUZ+vHOixLIMOKvEyDUGE3QuLgYCCLVwvebwlthCwKNEaGdplKoZ1aIwots6crh39zrEsI/Ee0yLXRgAIV85QmJwW9EBc0UToAU8hM0I0A+t0akuPl5s3FGhiCpao813fFHZ1Dc7R+bR0lxTmBFBwHcC2eKUjsad/+OeCppY0t7RB44tzTOUs5ON0sfUdr6dDY0ZRwwH/IVQJwzXhC8MdjLx7CcXset9+YDglD7vNIS4RhDTdMr
 JYXHHdEi
 nchZN30JTGXA9U+wisPsJo+FbdiOGp2fHBRRIg619AyJQAYiSivLqCItvgk4eTIxeFD2mRkSN8E/bZFOJNfcmMZde5uiAt2Z4CyQOLOqOHbEONfFG4FgfGznlKXAkcNOB9+IUu3SBNI/q6CSWYFJrpL6o6tjEgLISG17fbCQFfK6BhAC0YUCfI99D9riHkYleSe7iY9+Li3UCUG7FLAvFuwB5UzRjXOCsdOVVQVCUuhb/stgbzFtTQ1f/R1zUxoQaEB13sUhMZwRQ4alk29a+KZSrOsjFHuBZBuOAHHd2x6T73p3whe0qCA551dJ7K5NWl4iHuvB/o68Vh9culngLnygTkd0gjwu6N4uaE5umdpOsvJ6gy3VDwhAuHcXPUFI2urcQmtcIG9X9eRnas+ykfQSyz0lb6VScS+HiFVFBFAZ+b9Mun4t9j0Xi10tN5ciBUZvMWASj2QYXPJQkxM0GaDl5QInhznE7UYwGb5sntz1mMwSaJzdrTCFoJu93EVC7U19bIDN3pZUKXeYCh20dFXDpozccln/R5oh8wfvr+ZdZ/DMEw0m4w53beUrQXCvcfT0D7IDmKwHG8dMgcy7ZQXGdiV4b+ezu7FIFttDMgEQTr/6Uf30SDWMNunQSRNEuRSpFiDCqr45w9kQ4YO6RKE+LdUDf+Zdpwsx/BQc1tpK9QHUSR/Sp24Bs91Pp37FwfQOT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Moving the maple_subtree_state is necessary for future cleanups and is
only set up in mas_wr_spanning_rebalance() but never used.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 91d3fb7ac39c5..c5bb341da5e9d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2750,46 +2750,52 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, struct ma_wr_state *wr_mas)
+		struct ma_wr_state *wr_mas, struct ma_wr_state *r_wr_mas)
 {
+	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
 	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(mast_l_mas, NULL, 0, 0);
+
 
+	mast_l_mas = *mas;
+	mast.orig_l = &mast_l_mas;
+	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(wr_mas, &b_node, mast->orig_l->end);
+	mas_store_b_node(wr_mas, &b_node, mast.orig_l->end);
 	/* Copy r_mas into b_node if there is anything to copy. */
-	if (mast->orig_r->max > mast->orig_r->last)
-		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
-			   mast->orig_r->end, &b_node, b_node.b_end + 1);
+	if (mast.orig_r->max > mast.orig_r->last)
+		mas_mab_cp(mast.orig_r, mast.orig_r->offset,
+			   mast.orig_r->end, &b_node, b_node.b_end + 1);
 	else
 		b_node.b_end++;
 
 	/* Stop spanning searches by searching for just index. */
-	mast->orig_l->last = mas->index;
+	mast.orig_l->last = mas->index;
 
-	mast->bn = &b_node;
+	mast.bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
 
 	/*
 	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
 	 * Rebalancing is done by use of the ``struct maple_topiary``.
 	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
+	mast.l = &l_mas;
+	mast.m = &m_mas;
+	mast.r = &r_mas;
 	l_mas.status = r_mas.status = m_mas.status = ma_none;
 
 	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
+	if (((mast.orig_l->min != 0) || (mast.orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast.bn->b_end <= mt_min_slots[mast.bn->type]))
+		mast_spanning_rebalance(&mast);
 
 	height = mas_mt_height(mas) + 1;
-	mas_spanning_rebalance_loop(mas, mast, height);
+	mas_spanning_rebalance_loop(mas, &mast, height);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
@@ -3447,11 +3453,9 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
-	struct maple_subtree_state mast;
 	struct ma_state *mas;
 
 	/* Left and Right side of spanning store */
-	MA_STATE(l_mas, NULL, 0, 0);
 	MA_STATE(r_mas, NULL, 0, 0);
 	MA_WR_STATE(r_wr_mas, &r_mas, wr_mas->entry);
 
@@ -3505,10 +3509,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	l_mas = *mas;
-	mast.orig_l = &l_mas;
-	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, wr_mas);
+	mas_wr_spanning_rebalance(mas, wr_mas, &r_wr_mas);
 }
 
 /*
-- 
2.47.3


