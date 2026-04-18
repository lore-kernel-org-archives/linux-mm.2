Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932DAF99C63
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 02:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045186B0184; Fri, 17 Apr 2026 22:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F379F6B0186; Fri, 17 Apr 2026 22:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFC36B0187; Fri, 17 Apr 2026 22:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBACF6B0184
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:46:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E956E4297
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:46:53 +0000 (UTC)
X-FDA: 84670139106.06.9BE503F
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010057.outbound.protection.outlook.com [52.101.85.57])
	by imf29.hostedemail.com (Postfix) with ESMTP id BA4CF12000B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:46:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QuD3+RR2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776480410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BB85AgUSzvDtaqXv4Iofq3m0VJR8KQraEfGlV7Tvsfo=;
	b=wdCsafoFali3PhJsT6wlnW4kp1lAqDEqK5x1CgiFQa9RO5P7ZlTSvNWweYizP+ytKStWcO
	V98pOocPmt6uU3hJMUb9DM+X3W8liTUeroC5WI14myzzaLPTP+Y6wb3uLr1l0wc5vQLgHO
	2Kxt3fV+nfCMmtzrt7VtOtH2CfPa3W8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776480410; a=rsa-sha256;
	cv=pass;
	b=zvevrOvgXvn795AQUm3gUEorsyVqJuCkRSfj+chAIBMP8luzOt/fahV9kFdbb6AgrXfARy
	vZHrBBtwiqoWDF3Zay7EQ98nS8uI+8gHI0MCpJP+9VlFkU069K4yPegfyNmoaM+pZrfzhX
	UIroIDEzCifV4w7GCz/L+6p1vzvTXv4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QuD3+RR2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=THxw1EvnMoKyCX01fkMVFU0qbhHzmCjg/bge0JWVLlozfPsR6l/SUvJsZPSMAjWqtCcNHOJl9OaYNGAKMZmavaqgHK+7QMKCeicwbX1Vtcme653/ez1fO41qlsUXXr7oU6ocLnE+Ges75SCFlBqqRDgWJZcVOPfYjUgrSOXYFo6Z7qM5oMkcaHpPkJEhUOQ9k7ILlAUAWMLLepKeAm1ft4jNhIJYM68FSzvgGF2vdDgpFIPwF2PVLm+ajoA3IZwTpO+vlBKSAKLRPf/1ejyR+GMPYRKyJl+ZS3v0WbItX7Fs5d19Gk0mI926nd0X8Wrxg9ZzmTQvyXkBR2xVuZt77g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BB85AgUSzvDtaqXv4Iofq3m0VJR8KQraEfGlV7Tvsfo=;
 b=sYp7B2ogw3FQ+ZDaTptC100OuxnMcRFayJOO+2bLDwJgZJOnIh9QUfLNIpXdzm7WsSXOkDcc1XkE2qfumxtcKihJM8p3K5/NgjDpD5YQ5hHrKYslMqsyb6r7EhKL3fSy8W7VQzK/QS4O5a7VW0DE/8X9oStS3VXC3K35qUub8JCHiNr5hb8RDP9ukzjLVtiFdzGTflYu+caKBIcMKoOspuBnPYde99yp/pwACJcoIHhClyrDV5r2sdw/6ntrj3GyMrFMz/zCzU9DTmV6k7r3ZAnD2aC2ZCOPl0/mvTBl6qS4dY+zxuS13hGFwYZOZClbbWl4Q4nafM5aqtb38WLqSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BB85AgUSzvDtaqXv4Iofq3m0VJR8KQraEfGlV7Tvsfo=;
 b=QuD3+RR2CZuapqjbsiIM64Wj512qDRFYtD/hUJ6XrD2M0WITGAPp2FIi7nevPn/COKIGJmSsoYBmH3FqxVc9qis4wS6jRKKAYzXziaxQp3Sy+QCzsf+/FP2yy9K3DLCMLyCsR/m3a6ZWTyGwX7uLfoPOtbnAvEzgMaJsWSWfhBG2aEz/Clm4cklJ3twqjUjZ8JCqXXRFRh0owSvCVwj7raalVjTDsDFKMP91y3TDLMR93ujwB6AdKZ1+zx/AzmP81kOEafGn529aR8j06gkS9vA3Q9UoW1Sb1m/KyrcBtMp4L10H+6p7RuQgYfMmuOf62G2ETEIUKxI/khQeNJnxLQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:42 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v3 07/12] fs: remove nr_thps from struct address_space
Date: Fri, 17 Apr 2026 22:44:24 -0400
Message-ID: <20260418024429.4055056-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0013.namprd18.prod.outlook.com
 (2603:10b6:208:23c::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: f1b3a581-08d4-45a4-bd71-08de9cf47172
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LBkJE5dO2SCSijcaObDiuemdcUvKdsyzAsdlPTrx96AZI4qWepm30oUnQioEOvUoMFgAwqqOms7cKULHyQzIqmBqRTYNEqEIxRubLMNrGOYSROFUcZqDvstSa5zijpYI4a4KUoniH7HyptzDn+o82nW2wKAe3ckjvVScjxZME2MrfMLFjbUrSUZibaEw7JVO4Jw/oc37hBE7fH5GF9Ac0CjY0GFuYF9wtBrPQ9swTHWsK220dcqazL38FEs2yuFMjY+t+XtLURadJ++KZtAFWT7PfUBQrrEj5ohDBddWfgJ1uvpePf+TiXZeWzUdMm2w9RI+DFOuwl56N1Q+yuTSP+gk029IbYFzceL4cXCnNr3wluG8kjJ0bf8yevqNNuRJzSkGDPwKaQujEI/l87AAg2n/uVNx/DcYWabp8/xVxcTnEl8IjsR52DueSjOFMhM+dt7rZZ0AxZyBXsYH+kHZ7LWG3sh1AhZFrC+pBH+5S2kVoh9atPFWcNmpTpGvEhdBcBwIa6hNmoRNEOwSYsdMIygnlnJ+/g08OzAB69U/nofGwWwPv09wiRBC74obmSp2Z7BckuaEpGj66yj0JzEVyNJqF9dA5Wt7RHQ5VVklQiWxLXMB2m796ltvuGCEIn47Oa8HoFnyCAcMA4c02AhQxbegJCNvxAZ+PkLxdjBrPY0047cElW/y/edZaHy1YIjsF1HPm7fgr6iVTUUhxqJc35KI0t9t5ub9AZTj9welS64=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u3Q694dioW/uCRgMkfk/uIx4Pse9jPwDTiwDrQCdTB6EMqkcKsK03TokzJa1?=
 =?us-ascii?Q?orFUAGaOICkseYkVNMnKB4453+gxpcl1BiU11XF2LKxX6nVx7EUN/QVePEzs?=
 =?us-ascii?Q?jZxTYDNduy7z9YA14BhRyp2idLT54/SaOL1tBthNSnycUZn1WLWbU3ZHY+Ak?=
 =?us-ascii?Q?psHeU0Bra8viVrftk+rSXoOzsCor4UjpAiLRcTZJ8AAq3jxTojt7lww6Anka?=
 =?us-ascii?Q?t6lR+VxZ0SVDPi80UK5nKcPZr5N3s26Etz+UhHu8d4dZ+HG/S+Wz0H7M3yk5?=
 =?us-ascii?Q?inOiOKmw/gcT3II/hjw9q2/2d1St+v3wjxH+Fb2F7HVIobsurdCaAabo7Lbo?=
 =?us-ascii?Q?VNUxuq/zUCC80wkjpCzPVeu61V/WZy8mAfPw7BhNFAh5fJA/aUD7NXQAV52h?=
 =?us-ascii?Q?eELd+qp0vjczjCN1u0ZyEkio1x/SoqLGKG6NkGGJJVr10eEJ1NslwyrvMraA?=
 =?us-ascii?Q?JVlDuDPXkUBEDZfZopmnMq9R41SFoHej58c9AQpsFAE+YT6LnMGh//tX6tWq?=
 =?us-ascii?Q?vmKLDkZHZ+bft3NtoSl44C1bbYcOnOl4CZznuqdhUg70/ApicYkVlf/iM1Bl?=
 =?us-ascii?Q?N3dblDLjhp4g+pCAgICTD6jQOxQTSkxBDF3U5OyO/zFkTZZhA/R3yexKQIKZ?=
 =?us-ascii?Q?XQm8X78HKD0AL1JvUSo4RxN7NU01+ASFWxEmhrC9rlIg+Gw4wrRAVJXDMjIz?=
 =?us-ascii?Q?lhAsWcFDEtW0lXbL2bJD0ydpmFenL7fMq5cn1x/qE65NN55RkvJQkUsCFJSW?=
 =?us-ascii?Q?TewLI38gEKkHGl8+b0XjBnvb4V1pDeIlRJ1JLCcko+CXlPryqyo0E1Q0U2dB?=
 =?us-ascii?Q?V8RXLRzJB4WsvRWVZjRUy4okS1c/pKSvOvXklw7dz7gwltjQAVcnl+2A3d02?=
 =?us-ascii?Q?7okhXO+F1OCQ0hTBN+QbAAHze0GMpCCeTmX5TiY8MwYZ9Mj31PwhYy0dkMwz?=
 =?us-ascii?Q?I5MgK7wp/V8jrYPWcMCpj1BaZsiHCIPy8VuUu2s1SnuTjSrv+eObWrJ7PnRG?=
 =?us-ascii?Q?O+RjtGL7GRdO4brD8JFyrUY39Ex1FjQWTdKxGLZSxPK6KtuN24HCbP3ggwJu?=
 =?us-ascii?Q?eU7GsxG5vT8RoIq0YJSBroXzKBaO9ov1/kRuUVJah2PqAhw//jBUTEw3hzRD?=
 =?us-ascii?Q?hYmVARKopxnqm3F9Xha3jmWbQbdBRtfE7IMSfVKqsCAKEH1FgA34q485qz9F?=
 =?us-ascii?Q?fd7EyTgaIEJ4pVKxM/6heW5xJ9/0YSmQjYSWei5jUJaxenchVEFu89YpvhLV?=
 =?us-ascii?Q?HipvjipmbDo0kF4YRzK0vxCJcYN2YvTO76jEcUXJhVOEcNhr6gAQefOS6rhx?=
 =?us-ascii?Q?tiSB3QpXSzod2yHctsIGci/cK6VaA59FKJVo3w53f4LK1ks9mtiDxcoP0lBS?=
 =?us-ascii?Q?8iMX5OdHgaATxkQkG1nfzFe1lparJh8sGv3Vecun4Y1rmuPy2GHwzUn68jAZ?=
 =?us-ascii?Q?KohOl7fQMpifakE8L9FjwvNAuYRiyfL3efGP4UiSNSaQTdFcXW0/jlOcV2Ku?=
 =?us-ascii?Q?u3Mv3pVw0xf4EDQZJav1wmetMtHwsvoKjtjvz8JBmJz2y9etq0Nd8uQPAb36?=
 =?us-ascii?Q?0r9TKAq1nGRp6xcreT9ul06i9EJBDr1cHpsbtT/sMZSXPFpxUwQCNCCX7NHD?=
 =?us-ascii?Q?HcUdrTyeATjJEPI4PlUaYLsXts/aDX1Y21ZgxfzSgql3tbw35Hk5WYGz7vqG?=
 =?us-ascii?Q?znluMli4hyX70SVXVtuyulo+jCLkB7ymR17PNLyZ88JK+eCJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b3a581-08d4-45a4-bd71-08de9cf47172
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:42.3349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u2PAx4dlTEUojZPrKNegzhaoV3+ZUKxVzlMZpsBH0lMG/nEX5SFwzT27oRn+p7FV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Stat-Signature: 9ahoumhkzw8terpefyh8f3mkdmset4jo
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA4CF12000B
X-Rspam-User: 
X-HE-Tag: 1776480410-123962
X-HE-Meta: U2FsdGVkX1+dTwbSD9V+ccm6yH01YXUJgf/wWXTCnopPh4paCdqi/wBPhxNqDD0yv109QF++HYSTH27vKB1sWNLgVqGVt1dQUpxDA+9OE8d2cgteMe0e/j3gHAKg/aqGTmUr7bbkPhT1O8gwW3zGmgXwSR9GL1nyB9mG+7E0cPtMNIH1QFK+1WV95fKU9FQ6FE+if7k6umr+GGFOfIYLJIX42W+JSBiJTDymroSoht6wzYrdKlS9VufQ3xPqaMQHtId5r4f5SgL+fMtYgQFirepNABzdVLwbYtxAEU24uIGQgn1aXSqqNxChmXEUEa+jIOxbU6QPvijCfWX45NCOGmve2WPFijT0JPLhxi1DbmncbccZJWTnqQ1u84hm0HA9OEEK6I1yOWa+BUrdX7AuTPVBARAsRCJBVGZjnOoQIodGkLpbf0Pg909KMgWBdmGT6X+IsIZx889jP4IuQdtXGReUTQ8Y36h2d2x8PmLei7Igu965D0WusE7FIHTh8sIKkpETMhPusPZNbret04v6TatJxQ8q1RaQx1EVg3MqzE/Q9F1l5Z3Pc4EeFmfKGr4RGJ7YtyyUf6NF6uyJqouems4x+ctUCKwH9Or2RxZLktgSxji2W6aKHU2xDLpWlE4oTzLs1dJ38l5PmQTGlzSDhKj4tjD1anMmWfJ+K87WRbj4YlRIKseKgjNBVt22ic2lxpLy+70HQJsXJEMjhTYix5etALtx7y2Crg2SDzhdiM3sQVPovtFtRgg7wyLfDLf1aTKoZVGoBswzp5RxJPRqTH+sazKmp2qzTwcLKRclt42njWnXSWNYmWWxRpOuMGRvz/t6GsrExWGlqZbAW0X+04gMPyGf0WvuGTVD2jKxzAwWCxcQbK6kG9DUrUrc0xk6xdS4xdEqd1dTsy8izqY1CQtKxPiIv2JYVipnvld4vt6rZIwPS+YkatcL2tA2pKOv3/n1HVgEpv8l63U6mmv
 ksPm6P3F
 TwSGgxtjV/fkCUyCeXIUmlxkwHkMchGvcRQUffoMLVdRsSb+m6rHflr+Ib199TI0nnWPsA1BRFZEKvKlOtDIjOhvQdofdGjL/e6zRrI43vBz2tKy3EIGfebt1E60k3sHHpiU+Nbh26hZVFYWLYSTWQm1Wj6qpQvJoTjP0aWrm3heEUdU6gu/VAXIHpc+Kbc5ZP8A2JfU7ltTLDdfeYDfwuDHegyRPMl/A0oeEj/i0H2L+1IrOWHnlxYt+FOQiEXGiFzXODoWF6QjeIX1IrN9xLxGSDjqMaClt2CE1qZhzIyjTyYzf3YFiHynUUP61QWaifalYBrFLIbspp6d3FfggLT5y5hEm5GsAleWAGUCd7642s1YWDn/js5sBf9s2cBV8S2HZmJdQ0kV+OuICgtK1idSpFvNeSeVEFOZDi+BDy8lq4Ds3k6kK1hy3znEvNXaEsUORRn0fXX26hfvipt/MjdtzROSdxYKloSMi+ZZIkJk5Hfo/x022NzneBydf9kVC2NpWULHkRUY8PqHvqeFFWaiQKFD4oW/uDfIQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed. Remove it. This shrinks struct address_space by 8
bytes on 64-bit systems which may increase the number of inodes we can
cache.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 fs/inode.c         | 3 ---
 include/linux/fs.h | 5 -----
 2 files changed, 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b..16ab0a345419 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -280,9 +280,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_set(&mapping->nr_thps, 0);
-#endif
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->i_private_data = NULL;
 	mapping->writeback_index = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f3ca9b841892..824625d8de1a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -455,7 +455,6 @@ extern const struct address_space_operations empty_aops;
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
  * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
- * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
  * @nrpages: Number of page entries, protected by the i_pages lock.
@@ -473,10 +472,6 @@ struct address_space {
 	struct rw_semaphore	invalidate_lock;
 	gfp_t			gfp_mask;
 	atomic_t		i_mmap_writable;
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	/* number of thp, only for non-shmem files */
-	atomic_t		nr_thps;
-#endif
 	struct rb_root_cached	i_mmap;
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
-- 
2.43.0


