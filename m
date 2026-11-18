Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D232E606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Gt+On+x7
Received: by kanga.kvack.org (Postfix)
	id E08186B05D1; Wed, 18 Nov 2026 16:40:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBEF46B05F6; Wed, 18 Nov 2026 16:40:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A416B05F7; Wed, 18 Nov 2026 16:40:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 880DE6B05D1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:40:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 298E3A08B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:40:00 +0000 (UTC)
X-FDA: 85449557760.05.881AAA2
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010009.outbound.protection.outlook.com [52.101.193.9])
	by imf31.hostedemail.com (Postfix) with ESMTP id 53D862000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:39:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Gt+On+x7;
	spf=pass (imf31.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.9 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795037997;
	b=WVR18ruNDyeJx/BLU0FUajCOCn+vUvCqd0OnyhOjmTBljjZxLl9Arcbj/FDfRmwyusUx5m
	MA6tY/6QFB0OYvXwqduSC0IJciK1bYMwLtQn2qh1KKBBwhPsiUakkMHVxkchrd53h0v5SU
	vLBtncl+QDW8K9uI3j4ptnka2GBbhsw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Gt+On+x7;
	spf=pass (imf31.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.9 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztrc0Yp2eDQ6TZtAfPMQ1bmjQn8htzBnLl23LuCPLh4=;
	b=mQVr00nL9t/XBPhAjcq480DTPeXk8gEbKDOldTr06hJFZvEqZlfPglzHN0WiS4YQxW4Uu4
	7Z5Qerm7qMe/4y7rPyDXhGmBrunAlduF0ExARedQFJOVzyzoXXXYMIwtArEavofkRLo3en
	GGX44xqV/DDJNPhnlcfj/QVHvq1Jo9w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sU/qXtJl9eMvdeVta6xtgiUqhc110KbAjiZf4J8ejEbLy0EtAip3BumfqrWchuwSlMSvVMonhKHAjS92ZDd6+z1sRA40xaIkZR+I3h7oDgATF+bEQXg2S59YqQT4Fe7DCtDCdQvY7uxoK6uihgPUnU3uFWgu3JyEXcJyKq8bouvfqqb3gpEzD02NozdLzQsZ6M2sRnFc3pUB2vh6pK0Gc4RhF/oYVJzd7enulwQxCBVs7TIoPDv3IuzigenbOxQfC1rUuMkuZTk4pJvhB7J72SKh1+IJpskqKwMAPIVCCNpVkgyD+QLXc/t9yIxPTaiAXAIY+8bXFaXI661iJ7vTog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztrc0Yp2eDQ6TZtAfPMQ1bmjQn8htzBnLl23LuCPLh4=;
 b=ZT5/zo+Wp50hopyDBCJ6mdPHAZ7u1bhav0if0+PN4dDcusYCRiW3DcUQ2zJekuZqZ0jWckzsW+gc9d+GPPBNLYO70haRTxUsHskWso4UXJUyNviRxbd3QBOvBSkM/hsmbEQm/oRMnZF8OB2IclcNyTFBbJzAnYS/1/p+LdaT4SebcroeQTklXRL2dtK/5efa3j5HYOEVAq5/Ye1W6CEuTjQgu7ThdTeCzH1n3PMKrROnI2nRHXV7HW1mbgDBHoKUvIRegymiyBAXaEH0EZ1TcVHnPdrkCUVfklHmS6u2dh+ZwibNlnQ1yT8CsabZjELqGFKSEGdrwT8z++vjtk4YLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztrc0Yp2eDQ6TZtAfPMQ1bmjQn8htzBnLl23LuCPLh4=;
 b=Gt+On+x7LN274xI0eFQJmxK97SaDZlc6dJgFqhxUAprJ++e9RSfhXZ0162Y+BC78sNPGDajNR6l400NKp/CtU5W36Ariq8GR6l8gU0BtUcgsEjNlaTGofwZo3bXCp0WY/pIEWTbEu2e48bSdbVh+56QkXY06zkR6RaImKKYTVTXw5SlHtjHBxgJ+gZBx+k9kYnvEVcLJz/cETPKO2PYmsvj5WCe17vJy2+Mluxzrgo65Hi6u/v2h0TqCWkp3MCo5iP7q4cLh+KFGQacXOZKeN0Wg/b2OUNqAB4bAdAPYF2H7IePOxWwp9C8pHoHBGW27ZvSDV+w0gEX/w6eqMUzDGQ==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by MN2PR12MB4287.namprd12.prod.outlook.com (2603:10b6:208:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Wed, 18 Nov
 2026 21:39:47 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%4]) with mapi id 15.21.0615.012; Wed, 18 Nov 2026
 21:39:46 +0000
Date: Wed, 18 Nov 2026 16:39:45 -0500
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	rcu@vger.kernel.org, virtualization@lists.linux.dev,
	linux-rt-devel@lists.linux.dev, llvm@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 00/17] Treewide: enforce static storage for object
 initializers
Message-ID: <av4bISGVaQNwRUmG@yury>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915030336.1192299-1-ynorov@nvidia.com>
X-ClientProxiedBy: BL1P222CA0010.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::15) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|MN2PR12MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: eb494a5b-8334-4ab8-733c-08df45bc7728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|23010399003|1800799024|10070799003|376014|261022075727099003|261021121427099003|56012099006|10067099003|261028144727099003|261022105027099003|261021123027099003|261009223027099003|261102123227099003|18002099003|6133799003|11063799006|261026140227099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KsTh2qJIbrnqyR5HtwOmanaUdt5Qxxb0Im9OtFhIeiEe+fAV5dx14R9WUXxDwAeD1gYw7tt4duL5Lb3HqKq0bCpWsAGxE0N2WlsjxCTd5sTMWI2CV+vNp3VuHbOv8xzSrzDsgRhf3WfRg1m6sZZM9CFdWz/SORtddSzqHiVzb3lTIi276b1kjKeMTTokQnlDo/9jZsy6bMSHKjrphvp575wwP1wWDIbIiZfs7iDW+sGzD8gLfuj8ccFaD1akAHU/4FMgR67SH32yB0iyp5ltWf4afz+buam2aadgcYYP6BOkcqi/CP19OL1q7xUPJSFqJ87EFveWV26f4Sk55bjAXIRla8wJ6rPfSZNiH+88dz+GMMhUwErb8C+xxLpQjHhvUrUbtMMYqhg50943kuk03OdxP61zIwrbJ0h9tcEWbxEz9TOwZDbCg31y7/TqeZEl50p+yM4CjueVpwHnGYuCYUroH/c09s9ZVt5zcbHl6dlaJ9ZfNizAv+KfTgPVwDhqpZ8Fz0A96UsCyeonNx3jFXaC7U/5qrQz+VnsYGLJLPDsSYGVSmrqu3CiZyrcQMVwFS2vLZKC6cRW5iz67kHxv4AC224VhXIMTDuM/HBEHKl8jNSUUoLR+Cl8vtDSgcPDnhxSgB7mWnqMXtbz1RFdW/7jEmPbzenlvvl1h49kgHk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(23010399003)(1800799024)(10070799003)(376014)(261022075727099003)(261021121427099003)(56012099006)(10067099003)(261028144727099003)(261022105027099003)(261021123027099003)(261009223027099003)(261102123227099003)(18002099003)(6133799003)(11063799006)(261026140227099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+HZXWlztPnrA5ZFzmksOZgMH5WgHrJnQHSH7tRwGXb0ozDMYBnJf5U/1EwFg?=
 =?us-ascii?Q?qS+wmI/og7Dafmf9Sk5wgckkmX3GkCIwpIg9KS1L5znF8mQz747hSjCrpXgq?=
 =?us-ascii?Q?vjNEosmbbvUruz8McHeUW1yDnhyFGuW+Z2d5U96WPKBeb9L6+ZwmP7TIWF4Y?=
 =?us-ascii?Q?QcNuWMahBfJXbGU0Ry/CUIybNWxbSEe/cGAQju67gU2WSZ+52V+/17WqMO/y?=
 =?us-ascii?Q?j2UBmd/KiQermdrZ8gf/DUkZ88xrF9fC+NAlH05dUPrfiHFDQO6E1/wJW5C8?=
 =?us-ascii?Q?2RIgCU/fd3IKrKOUvd1pGtae2wOgIy0NqxAqsqk7dB66hDct8cXpYQlgb4VU?=
 =?us-ascii?Q?dXRwSspuqu6KY3Z/yp4kgDj/EsKsn1u5nv4aJNEo6xaqSMjeqpQLqvW4hwdQ?=
 =?us-ascii?Q?lzxw7MM2FFutMP1IYMlKHseHzD9C5IjSRWF0xy9YZZwotE/uYy1gvfjHrREP?=
 =?us-ascii?Q?IF65bS+QPxzLXjzwFU72P773cesKRKykaxTD96etoa14C2/XyN7IwSmGxw5j?=
 =?us-ascii?Q?tll2PTRlEXAC10z6h9l1u/8lrtGNv9NTNo0sV4weyHlVfs5ly+CCT3RmJLEO?=
 =?us-ascii?Q?nP/kpk8+X6nSPoI5hVDEonxvV/ZY8pz8tWNTmvXCiv/HU9Dfi0iA4CLTOwHI?=
 =?us-ascii?Q?0jw/0zdDpFdklt2BgLUHzuDOhY+RP9jkXXlPgu1v5q04xlO+GyCVfOGsB49j?=
 =?us-ascii?Q?vZUe1o0Pi3eJ0LlLnlJIfAo1g00uEQor8J3w896qarzG1A+K0Rp4wMfM6wuo?=
 =?us-ascii?Q?fJUGLOe0Bf0U1zosf8uf3uXWb/WtGCJp4PgkJXeHaKIJup+R0N8AbdAo38Zo?=
 =?us-ascii?Q?fs8gQ6jcwPIH56slC4KO6jhY3wIiS2kQNOf6bPtewdF8FchrTJRbrxT/90oi?=
 =?us-ascii?Q?Eithaw2D8et910vIUBFlUSpUQg6G8BBtKGDGGxtJPbB3dkAAdt6Iu6um0PP0?=
 =?us-ascii?Q?u0hhAPLYaQ8P7m+G1hJugl3uhC+dUYquFQ10IRoaPn0N7mZ7LSHNHtDvuHKj?=
 =?us-ascii?Q?JupTeqcreoSsSvq/Qhz6CPzdDFZKObzUaaje2Ok+O7K7xT1jUWD0Fg/KsRZX?=
 =?us-ascii?Q?5oRw+Kog2p0q1Q98i87eOit3D89hB0atSxmWFt5vTFSAlwLQEVUhsJA6DEDS?=
 =?us-ascii?Q?+GKU8xdx0yj9grgfRN8Aw6vHsk+CB0cC+8er9YEFW5HvJ86a6i8fYW4WxQgB?=
 =?us-ascii?Q?zuttoOrGunjzgcDyTx+ki2UdGX0Spie22ZkldM44n2QpcrfB2eGE1ryZ/8JT?=
 =?us-ascii?Q?KQdvzAmM9VGshgUqqQSlB0h2I3RQP38WZzup/UfuUz0ZOMtw50UV3ZiOqe9S?=
 =?us-ascii?Q?b3ubPqL0Qq2WxgtnZJpibdnW4Ogp/3Fd0NoyZ/ibn6qHlqwz8wpXsuhBKe9j?=
 =?us-ascii?Q?0VMjcGJuyu92kqQwqHL4DeuSYwBLN47n+ZDrbn0aoi2VhSlyjzH5l0obumhL?=
 =?us-ascii?Q?QB8NvLaJ4/98rw6rdqjmDeJXka2I69poxAzUFwzPOX78tu59gu2eIIUmDTZ2?=
 =?us-ascii?Q?Emfg4EMS18l+TMRrDTiTdce5+cGkKX59mjrFNZIw3Th+eifVvJ/fi/LICXvV?=
 =?us-ascii?Q?wFkOICJknVoTe0SY16SSqrTwpNkbhalN4IAQk1//t3YP3k1iNCZQjMng9evN?=
 =?us-ascii?Q?yj5nUuUMdaaBXB81NUGBagQ54Eu/tToNc8NkqdqNJJI9jPk37kqebLpaOYC5?=
 =?us-ascii?Q?Ss9bRUIQT5k6NDr1aChYpRP0dvgaDrRftnUZhpq9oZXxoQXiMIy6DaKo3ze5?=
 =?us-ascii?Q?ZfVxfY6cf4W3L2SJdnUgxl9skE2wQAj+OmRvFqZjGAoa/cGjF1y7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb494a5b-8334-4ab8-733c-08df45bc7728
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 21:39:46.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VuIOe8u6/T8hb9ONElnQ3MlOXvUx5QSohWUO+1liFdy0CLRjlqwlOMsPzcNRnRUreEXQwc120y+3217IuxxY7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4287
X-Rspam-User: 
X-Rspamd-Queue-Id: 53D862000A
X-Stat-Signature: s1i1dxpmgub4nkgu66bhwmagu473tjrk
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795037997-133906
X-HE-Meta: U2FsdGVkX1/VOQxHrhfNCW/arge7AMTmt8QK4j4hgS0cuVA/2uVsmxRmfjMp/Y+szZPUrX+fL/DgGb/hS/Sk17Bw1CuZp9fVXEoHva4B0UMhiG2tKlo41bh58WgULdk36jnh8IG/mQikZ25V8C48JTs0B9QhFpk3LI1xAE1NcPI5dHcFF5zYdHjuzAcyvMv4SqniP19A6VbwlhzjLXo9xuvYjcdY71tHX0IhYI3sLyACaDYj+jH/PHjzPAcfHNc8pA6iktuYT3RSSXssVD2J87PMMt3kVO8p4rmuWsODbvgWlny4caEcommqEgyXfQhhT5uh/1xdvOWDVEFVA+5cB+4y/vTYPTpdHVgxyBJg2hnCuUeDERD3o3/ptHlZpAMKOUWrBZ3MdoT4kZX/TUCGmNN0tlhR0Ouh0GTmzxXYveUapY2RiQA54OEVKOUDMamsEEanHoOjWaMNeArpGUxm6moPSmfoqtbXK3dPVrIWp6EcEL8VJ3yXGxBiD9RFj2N898HAXgwhNBmH9lr+v0BOaNlD2/CEUmBw3nlEYEecX2b2/O4EWRGWyTho+V4zj1J9YdQUyY3e0Nd8aAHw0U1HVZNLpnz6rVEHbk9Zw/HRowZ2K7z8v08RZLtqRyCf/48imgH8I2OYuF7BN2ZjjrpF4aJAXIjMEgQS/RVuXsPDxejealHHH0FI4ZQ07bcwYezvSxjojeZa7VuZ82aRPPzmWh0iEMavEUu+TPXyLCASqmfpdtfHJKdjWjef8VW0J8EBLk1LlHJ7b843E5alpjkFvRq8O+M634OB0iT6r4x1ddzWpPbr/H5zainWIv/eZXTNacVZ1tqaWugTqVXc+img9s4Tg8/uJ2NUTdHD+Vhhcb6f2oQC/7twoS29fKm8AvjDyCjCrQopaZoYoubEojpolRjKu0/+IoXQFFD//gFYuaux2l+92CRdpMM7zSong473k7suU9cwoa5plYNQj2Z
 EvH+9UKV
 0oXQGFhcRewX+QtL4oQyhBGWDcbeip2sLUrmsLGWS5Kl9nktIiVNhIMlxHyVHkgdSb17OyXbMGqFCXdsEBLR/AtQbDCs8vry8BnRJU+vfEvbcvfID9jcw56PF3jt+iabNpHESVQk/ZIKIVmd95zG8FdWZGNab4asqIt17olkqgO0q10/3gpVPSLEA0EDgdHvOSpzr6aefkT2dbZpss1Ts0TF7JTjM1NtRa0kw9J3lIc0GsRsSD2e2MXrtBwgJBv2b22dLYK2GR2M9fGR0HjBhEjCreujttbWTG7fiN2d0/W6VdFcImN0c9PwB4wM3YOLXAGFEJ6JoSpQPqqT3HFNNy+YRIgnWAZpnhdI7+FplW6/SdHOQt1dnslygm71xdKkoDE5JsuMBJBDnnv8EkWDzVM+EUbALvGI8nWHkslC/RTh467JaShOtP3KX8sHefnlKuIn3yMcGhGBiepA6rQ+JcSC9nHXuB0aaXyBzjj4Ebgf+SkD0S+LGVApSq7oNPVgK5HEBX16nKdnbUIGDnf2eaqxaIH6xNQ1TWB48fIBNdjVs82ubOkwkorQOmaSOfgMX6D/l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

So, any progress on this? Should I rebase and resend, or we can merge
it as is? Andrew?

Thanks,
Yury

On Mon, Sep 14, 2026 at 11:03:18PM -0400, Yury Norov wrote:
> On top of [1].
> 
> Declaration macros that statically initialize embedded locks require static
> storage when lockdep is enabled. Automatic objects must use runtime
> initialization so lockdep receives a persistent class key.
> 
> For automatic local objects, lockdep cannot use the lock address as a persistent
> class key and reports "INFO: trying to register non-static key" before disabling
> itself.
> 
> Series [1] introduces an ASSERT_STATIC_STORAGE() macro to enforce static
> duration of an object, and applies it for DEFINE_IDA() and DEFINE_MTREE().
> 
> This series applies the same mechanism for the other structures of that
> sort found by Codex.
> 
> Link: https://lore.kernel.org/all/20260911221444.1523311-1-ynorov@nvidia.com/ [1]
> 
> --
> 
> [1] also describes the preferred route(s) for the material. According to
> Andrew's (and mine) preferences, sending everything together in the hope
> that the relevant maintainers would ack the corresponding patches or
> simply take them in their trees.
> 
> Yury Norov (17):
>   locking/mutex: assert static storage for DEFINE_MUTEX()
>   locking/rtmutex: assert static storage for DEFINE_RT_MUTEX()
>   locking/rwsem: assert static storage for semaphore definitions
>   locking/semaphore: assert static storage for DEFINE_SEMAPHORE()
>   locking/seqlock: assert static storage for DEFINE_SEQLOCK()
>   sched: assert static storage for wait queue and completion
>     declarations
>   xarray: assert static storage for DEFINE_XARRAY_FLAGS()
>   idr: enforce the static-storage contract of DEFINE_IDR()
>   radix-tree: require static storage for RADIX_TREE()
>   klist: assert static storage for DEFINE_KLIST()
>   workqueue: assert static storage for work declarations
>   timers: assert static storage for DEFINE_TIMER()
>   kthread: assert static storage for delayed work declarations
>   ratelimit: assert static storage for DEFINE_RATELIMIT_STATE()
>   notifier: assert static storage for locking notifier heads
>   rcu: assert static storage for RCU sync and SRCU definitions
>   sysctl: assert static storage for DEFINE_CTL_TABLE_POLL()
> 
>  drivers/macintosh/ams/ams-pmu.c              |  4 +--
>  drivers/net/wireguard/selftest/allowedips.c  |  4 +--
>  include/linux/completion.h                   | 10 +++++--
>  include/linux/idr.h                          |  4 ++-
>  include/linux/klist.h                        |  4 ++-
>  include/linux/kthread.h                      |  4 ++-
>  include/linux/mutex.h                        |  7 +++--
>  include/linux/notifier.h                     | 13 ++++++---
>  include/linux/percpu-rwsem.h                 |  4 ++-
>  include/linux/radix-tree.h                   |  4 ++-
>  include/linux/ratelimit_types.h              |  4 ++-
>  include/linux/rcu_sync.h                     |  4 ++-
>  include/linux/rtmutex.h                      |  3 +-
>  include/linux/rwsem.h                        |  7 +++--
>  include/linux/semaphore.h                    |  4 ++-
>  include/linux/seqlock.h                      |  3 +-
>  include/linux/srcutiny.h                     |  4 ++-
>  include/linux/srcutree.h                     |  7 +++--
>  include/linux/swait.h                        |  6 ++--
>  include/linux/sysctl.h                       |  4 ++-
>  include/linux/timer.h                        |  4 ++-
>  include/linux/wait.h                         |  7 +++--
>  include/linux/workqueue.h                    | 10 +++++--
>  include/linux/xarray.h                       |  3 +-
>  tools/testing/memblock/linux/mutex.h         |  8 ++++--
>  tools/testing/radix-tree/benchmark.c         |  4 ++-
>  tools/testing/radix-tree/idr-test.c          | 29 ++++++++++++++------
>  tools/testing/radix-tree/iteration_check_2.c |  4 ++-
>  tools/testing/radix-tree/main.c              | 16 ++++++++---
>  tools/testing/radix-tree/regression3.c       |  4 ++-
>  tools/testing/radix-tree/tag_check.c         | 28 ++++++++++++++-----
>  tools/testing/vma/include/dup.h              |  5 +++-
>  tools/virtio/linux/compiler.h                |  9 ++++++
>  tools/virtio/linux/ratelimit.h               |  6 +++-
>  34 files changed, 176 insertions(+), 65 deletions(-)
> 
> -- 
> 2.53.0

