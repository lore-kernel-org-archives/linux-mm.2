Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A927CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0CE6B0088; Thu, 21 May 2026 09:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AA06B008A; Thu, 21 May 2026 09:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC716B0092; Thu, 21 May 2026 09:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D4C6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:59:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 149731C04FC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:59:22 +0000 (UTC)
X-FDA: 84791584164.13.202FEB9
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 13D68140009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:59:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D98k6XXh;
	spf=pass (imf26.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.53.41 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779371959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trjSO5GfJipyfm7R8CPhLhZcYwYD89ZHHxKedA4GOqg=;
	b=lWqCKvCEnFEd+ocuevxKo0IDJ9avKT5TKSttlazGoMA6guPXZRzfZbtsz32NBs8Pf/Zum2
	sc75ga36evqbqDK0EloAceSi3OYiXtxm89IgalHOisLfKGLJYv2Sn5VVjnHTMiue/9I58f
	ei/nqgxue0O886xwaixjKBlOUmp1OTI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D98k6XXh;
	spf=pass (imf26.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.53.41 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779371959; a=rsa-sha256;
	cv=fail;
	b=vc4Ph46HzmzFX+27l2iYfycdez07uolKSlvPbDCr9FYDuIro+i6ZxST9sOSzDIaL1FtMlO
	utWMQr1YblGz+7bvb/kl23RjaDTpJjjOvMaW/g9zCzxyT1ryDmrnIqrEfXTxhOy+vPHgAb
	5/QZHCpeMqn+vfmubTtAsRfGLz1axrE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=akBZBqxtT9L3cdi+WducujlcGzui42xm4zv1zxjVH3XhDRdAd58JlL0IooQ1HgGzTPDS7DG6NbVOhMcf/kqgGXc3ctUZd+OXwq1ivaZFblhPlTd9r8MCiJzgrPDdV9IjxcGIDbw9i1IDNhQMoPJsX+Z7HAi4paCKUI81ojJt3mPEMRM1Vi662Ek7x+gwfVS59dk0gcnBEQd2uLa7q2D8jXjnWad3PrKxTBj6NFDbKj2N0OoR7zTqtkuL3LqA6rdFHzZGo7zvjjqZyp536kcb/IjZe1rgwpLKkHUJNq4QwnIeAoeYh6RMnyFSirythh2echzbqhOj9mIoDiBO2Fw0nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trjSO5GfJipyfm7R8CPhLhZcYwYD89ZHHxKedA4GOqg=;
 b=duldHl3dI9RAhRa6AX+uTH5nSiKwR9BugYsHauLncbaWFhyAwNji46IZJutX/lbvc2ScnW0eGj4eSuwBeTrNSJzJXDCw7P+GSlbxKmbYfoOGUmr8AFkxjfIESZAp75zbztBk0OA5xFAXYlvC9Gifq/S2SC3XcXOj39YbGQXgLjecaaEJKV9D37tpmjIJpdX4hSpj47n6a1UQSOWmEpYrjAaVc6ybd4rgJp/JO58+QmJUfwOT4VyEjDmoK8SFnkjL3qJ4gm4CJShZ//uxJczoKABwQOXgVEi3cK8o/Nt8KBfCB7YtKVtCf6HBmtACaLlO/dYTmtT4ip/lqgEEMj30nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trjSO5GfJipyfm7R8CPhLhZcYwYD89ZHHxKedA4GOqg=;
 b=D98k6XXhEUOTkzmE8X8rnNraj6MhdqfxZRNnRiL34SGbk+76Ie2JYt41BTrPWw9L2KP9V+u7v+2Q+Gjivi0//ZqkWCs9VOIMDJT4GkZqD3+F/eKBjy4RkLCenoKjGEnqcwEHWRJa1Um1OMG4Jkaqz7bUnr+tUBEJUcoEAqKcSw8095s/LuVEsQxMx2pEqSaV4qLgNspSFolfTpbmxqCtqKqt3/y0hiaVW5li/trxfAaBaaaLTeeY/SqE8YV5BnqDIl7DaqQL4NM+YQjGaocdboZIgof99ilCBhIggtmhakddEIu3PRyXP93WZej5sMM8mo8BpSV6VriPDUnyyUP8Gg==
Received: from CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16)
 by DM6PR12MB4091.namprd12.prod.outlook.com (2603:10b6:5:222::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Thu, 21 May
 2026 13:59:13 +0000
Received: from CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de]) by CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de%5]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 13:59:12 +0000
Date: Thu, 21 May 2026 09:59:10 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/vdso: make offset_in_page() usable without
 linux/mm.h
Message-ID: <ag8PrpLzeuWmnfIW@yury>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090655.160282-4-thorsten.blum@linux.dev>
X-ClientProxiedBy: BN9P223CA0030.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::35) To CY8PR12MB8300.namprd12.prod.outlook.com
 (2603:10b6:930:7d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8300:EE_|DM6PR12MB4091:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c11c8f-34b6-470c-4758-08deb7412345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|10070799003|18002099003|56012099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Ch1KenSPEueXmBj8fI9usxcovh8SOk2x+fQwdiW05cW16s27kexn3Sm/uYjSf9cbBxdn4lhZ0lWJ0uAl7nVpGakkTR19/seVQLVKZO6alPtyxkI0mFKC4QdmE9eyG9EsuPw2RIkvf4sLYY6nJs5eLT61+qTXr3V45mw08EEmhGaaCNR4OeJ3ajH7IgYBW3cbotpjVcLqQHKdmucofFLcyYPX1pMKDkX8zvDDomeBoExYF6bKObgj0E0tkwsHw/C+z6gzMuj1u6LcXzbgMhA/AAz5wFlFEgF1Vn+q2GHp6mzdIuMH66SDqKavjPOV94AjiwFjNmtnycFqqKg+GKw/jfEreQbYvn25iZUQaESHHyRMdNdKJzw5NV29QUfd74gxEhS2kBaAIN5ljD1f4WQ/203LQvtxGPVlOSt2QhwAN7V7AYjn3Nn9xSHO5n2XUkR1a9Rmpd1ZTDcA2RiBZMVif7gADd7akyRz3dpGyRdGTjNwejQBEG4WlpO4lL4u8WsJ0p+7R+aMpecXaPSZiu2cq7oVtUv1l6Qr51gGjmfRRmFAEd31tTAsPeMMaYmKo3IEy871SYhrAUUpuQS67wUCVkXQaiaRHxIEj1r93HvfmiTVrCdmg20l/kk2LLtJdfgbk5mkOVsmFfMWDs1dXBE8aH7Sc+xi/5M+Hgn5SiFHahxVBftMAFX6zwBEMLdG9UT6e+CnEBVMAmU5jxzOoICLFQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8300.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(10070799003)(18002099003)(56012099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WBJRcz99s8o75VJDj4V2O4fjnxLYTED6I+cL2Z2jZl6GfzAcO4G+vrMTvgYR?=
 =?us-ascii?Q?9mVKn8qz3wLVeClwZFbydt7s/k/applJmQvqlrTTIBJD4/nC1vnfGaDwY2qY?=
 =?us-ascii?Q?0l+4cmpTjirqaAViJXvwvkas3ZpBk0zt4Qik72RQMhkNUkOJIAzXdyG3eOa5?=
 =?us-ascii?Q?xCaPCDCUpUubXztHM9QUU/FTqyem/R/oub1S8hduCCbKH/tN2SUTO8/CIOq+?=
 =?us-ascii?Q?yqwGm9cNyqpUh7YfcwTTE5NGJsn8GVd2M2RBpNhPD7iZiC4oYbAHooMDa8LD?=
 =?us-ascii?Q?7CIZhdQEXYuY9iwYxDPIPzprsvIGO0fLWKOml/AdziS+QzTLWpeXUwhZZy6M?=
 =?us-ascii?Q?ub7vI0PoHcviIHypEAdTOYNqXPvaVC55cpwqgSYnAuRwn5jzm0Lnq62xgNhX?=
 =?us-ascii?Q?2H1+6AWBwWDeI9xfd8d6h9OUgXd8m9SSpN+Qb0AQuK4q8msRdkkvMqDxwvIY?=
 =?us-ascii?Q?iu54hjh5/IHsu7KJLJ9w20CExfXU0G7rasNlLHyjkVtz+/Vdnh14tE9jbdkU?=
 =?us-ascii?Q?aaiojnIgO2Ya/KbqT+MSTDtCgmoXl808FcSqJ+dCfRvhWMBlhVAmmQKFDhpX?=
 =?us-ascii?Q?EP9v7eoh9aWv2DKD9GtIGhWo9ylZ+Fg+euCfFC4TTNb5ncGjFf5gA2xls/Ob?=
 =?us-ascii?Q?plZ1CD8Aw9NgqjEMNw8km6ipC1Vg2jweWp9wct762Ds5dYZ57/+77VXA9keJ?=
 =?us-ascii?Q?95tG9BPm8A7iTyifUpB9w7EXxfUf+aj/j3XfQdDpRiWWc492GfZZNqEMalvA?=
 =?us-ascii?Q?C1aqYa0E3cuSZAZ0VxpKxDLKqox2pJ+UhR56x7fYFfQv9DEo+r+60+YLxRzZ?=
 =?us-ascii?Q?lDIerlniEjojSm7Vl9oRSDGxo4+kX6Rgue3u6QMhgyN3QrI9hUz7XuG8XJWt?=
 =?us-ascii?Q?uJqg+WNS8ZgovTY03aEc3hJilXvE6ravvLGVyJHf+qjgNS7OfM5Nli44AlZE?=
 =?us-ascii?Q?ZC5EsHpv++PIMMprAZSFwAGdY2kLNTb3qI+JquPJaMQMzBH70sFAXF30ywa/?=
 =?us-ascii?Q?0UE8LwVuftf2vMuGXs/ual93ZP+NZIwPAJQrqyx7uMkzOo6tHOdpuMZx7QkA?=
 =?us-ascii?Q?Ti+57vdpxSNaVLM4g581b1/Zk7kSgMzq85pnuWfziJbEedvesL5lcAwo7BTJ?=
 =?us-ascii?Q?gD/YViK8Pl399OVvzH1v9opfqdpf01yLBwGe6ZDpxPr4HEaNKA36FM1h+KN0?=
 =?us-ascii?Q?ix8sXjJJCnn4J9wQQHWCVBx/ofPDnJhrDB8D+ad5SDcGTpsfvm3joyRSVpQP?=
 =?us-ascii?Q?1yx0t2oBgG8+yEYHQWTVszxeYGtr30EKs3gDoV8gZsx5S8VCtJut89NntzBR?=
 =?us-ascii?Q?lu5hR5GyosxTQ+jE+wSYejmhSDMZNMfL2uXtgzZdf8sQnx2rQ/SRg9lAtmZM?=
 =?us-ascii?Q?uwZFOQYR8ry41LuKMe9JtKlHxDJM1MM1ekK+Iz9FU33moUGDrHM6IXs/7qDC?=
 =?us-ascii?Q?H6OdnPaxinC3xUU0TLhLFt70hLgd9U/+hBGzriUnWDmOrOWA7sHav8eI1AUP?=
 =?us-ascii?Q?Oif7rpOxN0Iq/mVMXN23v4P2fsNnOysdtbpdkHu/GqavE+p9uIaZqAJxdIms?=
 =?us-ascii?Q?Xk0n3GIK9BziIa9Ry6iMvCYaBqshJ1Ofetw4A38ef4jiTn4KjXE3bdEjt/SN?=
 =?us-ascii?Q?IUNuVHaVBX7SsXnuZ7f88T7o7MMFkNhu2AXvKhTSaklTbltUt/Eeczig6gzw?=
 =?us-ascii?Q?RbSD7pcH+NB4+d1a+DOiEAtln8qC3Sk4v/zgb/NI+rY+g5Qw4xdmXiLkZDIE?=
 =?us-ascii?Q?gTf4z/rWeB/o7CVuUhKbpnq0D8G2jTjjQ2ZdHgiEMsr77OtSvCz+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c11c8f-34b6-470c-4758-08deb7412345
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8300.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 13:59:12.7775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XwqNMNJziu4eBC5HOIrGmQ8+EWj+OCOw6k2CN6slM8tPBlwSRhP13hGEmK5bhaaFRb7BE8PXke2/ZWp0Rz9Ldw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4091
X-Stat-Signature: qo7brzdoxromd84sfsis3q5ii9tr7w1d
X-Rspamd-Queue-Id: 13D68140009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779371958-939382
X-HE-Meta: U2FsdGVkX1/TyKEdtUEAysHJvVmGK+2XmZmDEs1KqHHe7p2LShej3E4Eyk6cpKMC7Bho7K3NaM3AYi7mSVKzslkPOG+sMC6Tl11l+7k2/mauBmCAoAD7NvKOk3X0v8MdSqn1qdqArSSSP5737pKF2RYHryrK253aPmMRTDtI8p73Gk19ebW8zi0eacHmyoohXitO3Sp/xxzSK25WjF7GthwxVE/hzUis9IPq4q0p/WYJDAF1u/0gGl1TNpLn7XwwSbcUvukGUGZVhQgxaHErdmmlASy+uIOri0NGSQIQRWaJsL8OY6+pqnOWR2Di8aj1cP/Oli5vcHV3gEK4A/5B8Hf7JL/kNTWm01a7hzUMtVJgcOSZkmJ4XDHJx3jal2yPeAHP/zAWx/4gPWukIgPNC1VLWcLUbcSVRwTmJmlV7QnIttOhK57wjP8BYZpPtvxpNjD8BwDaOAwY8P2KvNzImAnUYqJTOvBrwlOyyWxxzQrz4XSTje6l5eZcVk7x3wQkudTSuajqOpumrBbT9+3cxOrMnmNJdz6cyXKOZReRAQfAiYKzlLFcmJ/sK2SV0wH8rYloMt1MA9Rva+EYlxIN0pprx80/1M39E2Dw9XGJXhSXbMRSV7xLi6UQvxaT5xtOZi/ph9bO6dDxq5o0znfWfHMtspxXzJifx6Jt2WNF7VCQCTYM/qiepvvbsHl3elGvjfOxxnuezxqtH4EyfXR0Wy7MS59pYCP1hujYL92dzvc5lbvoqdvqxj/Ct/lDDoMl+6bsnBLajgmfKLaykpiJI2rIf/HhKo22RFt39bRitZff10qRM47yGxQQUkimbp/aXSbaxpEZAQ0mSlhOHyIvNplqjevxLbK2d8Ewqmd3q6+xi2AvUOBRkNvBfwYGjE77tUAqxOpInI8NAZhXoOUSv2kCRR2S8HFwHMLvdZDFDYik7cC8JPrESMqSlY+FWD1pO9wstMxmV+EQ7Qw8xvc
 t131OpkK
 ht/ssdOjEGZ6e5pxPEjgOQBY9pcgheT0/FJipzS6oEnnRw60oSlWglc/AN8P19FWwF1ig3cMiqtyPfCNudJ6F9MCm/W0QwhBqqsWzpHSjMPDmARGAKf9yHmL7L+3Pf6XHatem8vEIA3iMdRB9Fegkmy9yx8WzztK89oXJiOdNyM1b92Ww7r+oBzFfkqvwB/MXDJsQL+uHWCSK1tn4ATsRs60GFqWexRa/RKIX8zRPI6MzWEqhwR5ZJYIk6L8cOK4UVHc6gl3bz/EgMwAnidVtPM50jNA/3imfr9zRjVb2RnVNPIpiZjsBbt/czcX05gVckAe21hYqCkWqT636uVk70JYtQSHGrMgu9uAFyGGUaa3iFYNrduxYHqkWtk43V3VelL1chEvPxrGh/H1vd7rIZhiVfp49XbAPRDYDKe849HVOBqBgDSyzKJzVCmz5PzT31xcRhc73k4kcxRLl7id4cufWZO2USa4/aSn4zv8p7PoRYchxdnCNJ8gZh6SstNbbQ2QV3RG7DbZ79kKDk5IybLwGxw7kmr+/CeniVVAEhk9tXsDocOQazdOMSZVDfnz2Byei5hMqMRfl/iqI/7n0/R1eJoWtfM7OvaUM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 11:06:56AM +0200, Thorsten Blum wrote:
> offset_in_page() is a small page-arithmetic helper that has been around
> for 20+ years. However, page-offset calculations are still open-coded in
> many places and in different ways:
> 
> 	(unsigned long)p & ~PAGE_MASK
> 	(unsigned long)p & (PAGE_SIZE - 1)
> 	(long)p & (PAGE_SIZE - 1)
> 	...
> 
> Some of these open-coded instances may be due to offset_in_page() being
> buried 3000+ lines into linux/mm.h; others may have avoided including
> linux/mm.h, which is a large header that pulls in many others.
> 
> Patch 1 moves offset_in_page() from linux/mm.h to vdso/page.h, which
> keeps the helper with other low-level page definitions and allows users
> that only need offset_in_page() to avoid including linux/mm.h.
> 
> Patch 2 shows a concrete example where including vdso/page.h is
> sufficient and including the large linux/mm.h would be unnecessary.

mm.h is already included there indirectly, otherwise it would be a
compile error, isn't?

--

Example for who? Are you expecting somebody to pick it up from you and
cleanup the whole kernel?

I'm not interested in 'example', I'm interested in a broad picture and
an estimate of how realistically would it be to switch kernel to
consistently use the helper.

So this is the broad picture for you:

 - 660 uses of offset_in_page()
 - 570 uses of & ~PAGE_MASK
 - 176 uses of & (PAGE_SIZE - 1)
 - 135 high-confidence candidates

Those 135 candidates are found with:

$ git grep -n -E \
  '\b(offset|off|ofs|poff|pg_off|pg_ofs|page_offset|page_offs|start_offset|dest_off|src_off|from|to|remainder)\b[^=]*= [^;]*&[[:space:]]*(~PAGE_MASK|\(?PAGE_SIZE[[:space:]]*-[[:space:]]*1\)?)' \
  -- ':(exclude)drivers/gpu/drm/amd/include/asic_reg/**' \
  ':(exclude)include/trace/events/**'

If you want to go ahead and convert at least those good candidates -
it would be about a couple dozens of patches. And it would look like a
meaningful commitment.

If you want to move the macro out of linux/mm.h and drop the header
from some inclusion paths - it would be another meaningful commitment.

In this series you move the macro to a questionable vdso header, and
convert just one user, which leads to *adding* another dependency,
instead of removing some. This doesn't look like a valuable commitment,
sorry.

Thanks,
Yury
 
> Existing users of offset_in_page() do not need to change because patch 1
> also includes vdso/page.h from linux/mm.h.
> 
> This series is based on akpm/mm.git mm-nonmm-unstable commit
> d067a83c8063 ("string: use min in sized_strscpy"), which is also in
> linux-next.
> 
> Changes in v2:
> - Add a cover letter and drop the bytes_to_page_end() helper
> - Move offset_in_page() to vdso/page.h as suggested by David and Lorenzo
> - Use offset_in_page() in lib/string.c as an example since
>   bitmap_print_to_pagebuf() in lib/bitmap-str.c is being removed [1]
> - v1: https://lore.kernel.org/lkml/20260517123428.1181981-4-thorsten.blum@linux.dev/
> 
> [1] https://lore.kernel.org/lkml/20260519163058.953690-3-ynorov@nvidia.com/
> ---
> Thorsten Blum (2):
>   vdso: move offset_in_page() from linux/mm.h to vdso/page.h
>   string: use offset_in_page() in sized_strscpy()
> 
>  include/linux/mm.h  | 2 +-
>  include/vdso/page.h | 2 ++
>  lib/string.c        | 3 ++-
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> 
> base-commit: d067a83c8063d1bdcbd9af8e1326d846f85138b8

