Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B9CFDEE3F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 19:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0686B0088; Thu, 23 Apr 2026 15:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A610A6B008A; Thu, 23 Apr 2026 15:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928706B008C; Thu, 23 Apr 2026 15:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 810B36B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:37:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22A70404E9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:37:57 +0000 (UTC)
X-FDA: 84690830994.24.CDCD27B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012059.outbound.protection.outlook.com [52.101.43.59])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E3B218000E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:37:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cMUgpk4p;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776973074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JredVyBM5nlEpUZvgV3+9G1X60D2FFGS5jipuxu2Y8U=;
	b=YmSNUz5GF/5W2W/qlP0gb5l8IkmmM6PlNUrYmK8CIbWqOveFu7I+gfOGsY/5elQknUdS6+
	0/Q0Le0gPLnLrjSMNN3LJ7sbissIEYrx+l4z0DPS4Bsdz7TJfnkoye9iaVZIFxmcsHXnl1
	fKc+LgMWoajQpw8LH3urNR7S3QHyufo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cMUgpk4p;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776973074; a=rsa-sha256;
	cv=pass;
	b=bBfYPJqHuWAjjETAeNfeaSz1Omvybps/DTHDtFvhWQ+WUkggZikwPx2U11Nb2USUT0ZsJX
	TfAjgOEyWqbzx9H/bZ9q0xdg2MG+V5IGS67u48nojOGo96bNjgdxknWLmC3WJCdyzmy5Yg
	dCBRlIz/JPQ/ykfTAvL5od9/C2vEhZA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rcLIW9FQC/2ZPqh6vlCEDX7eMJk7niOhnCL7ifO4BAtrKNJ9tvvhMwRYNzS0czA3mNvc6aBD2TEp9Z4D66klRclMJlC6x3lIz1O5wThv+ddfhKP3Ac0b237PS6r/nLU4StAz9Roqv3qBCiJksqV/q0x9bTQN+tGerhMLMKcKbKdgmtqfjeO/mxGq5dUMtVacbRvoexxctux1LoMig38wiJCLZiGu+i17d2/EQSPUNeVtWBLkVbJeRTWPdQIlHAVlBgwPXqLIAheRvDckUALk6cjqVlkg7Jbi5wAetJ2lfoP4yN14HnesNuBWWs8YyALOM2MzbMKKtfL5+xwuC+MOfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JredVyBM5nlEpUZvgV3+9G1X60D2FFGS5jipuxu2Y8U=;
 b=djlH/rNXPFFdm21CLFkAXDXYU+mto5X32CyJDpPnQlq4gk+Guu7p2dkQXd6dE3cHLgDNRsqdnFpFiuAk09ccbrKrR7VgdkrvhiLQSs2+dM5C7ppYAW55Gg9oD+Y+s9ezDpt02JmNI07FTawkFFNDIijOLHcgb5jxo18ta2Y8+Au1WlK8dPahGF+FPyvsAgnccvZuOtFCJjQkv2BlVdmBqGSd908edh+6jF7Vzdif6sNqLdiQwgm1aGliKDY/IW4lXXsOnFpJdLqal3DOVoa0o8RgbljcO6lGRBSWOCvy1rLbVpicZwnQU95bRRFieXHihks8TlMxkHU4O2QNlEEQOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JredVyBM5nlEpUZvgV3+9G1X60D2FFGS5jipuxu2Y8U=;
 b=cMUgpk4pFOnRSMJfgf0QfNEHuQC4tpO/Qukf8+s8c03xap21k9IC2+nJe0YfaZeJvkKCpT/TLyJ5xQV4OKggzPnWaufRGKAuZ9S42oWNrNdkNmZPTNNjXF+Kjc1Qvv7gJBNitnYdYg1VeDpiH4YNzJA5gCStClXxRGNxXWY+Mo/N8T//bvSUV7Sxn1V3eYufBQAZgax11JFW9ogKIV4MlQe/57udZwr9TUvn5UFZhCPI6GC2FdFMva7ueADZaIpjZbxBRRI9d2EwsigwlxXmLETIgXsxbxwI2ufKt0VQ8FZ9RhR3yhZPKUUDPwJmdkMcNSrCnn8PHlh1qM+0pkxHVg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB9104.namprd12.prod.outlook.com (2603:10b6:510:2f3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.20; Thu, 23 Apr 2026 19:37:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 19:37:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Cc: david@kernel.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baolin.wang@linux.alibaba.com,
 gladyshev.ilya1@h-partners.com, harry.yoo@oracle.com, kirill@shutemov.name,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 mhocko@suse.com, muchun.song@linux.dev, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, artem.kuzin@huawei.com
Subject: Re: [PATCH v2 2/2] mm: implement page refcount locking via dedicated
 bit
Date: Thu, 23 Apr 2026 15:37:44 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <33C9C8BE-E75C-42A2-BE0C-E5331E3D785E@nvidia.com>
In-Reply-To: <9936cc799ac8b637ee58ae3bf6ec0e5eeb5306e9.1776350895.git.gorbunov.ivan@h-partners.com>
References: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
 <9936cc799ac8b637ee58ae3bf6ec0e5eeb5306e9.1776350895.git.gorbunov.ivan@h-partners.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:408:ee::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB9104:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a9091ce-72a7-4e7a-7d36-08dea16fcc28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GZgjtOd6IWetC7iPVeJA3bB6kFd86O1kDi+JfEKcRl8ExDbt4mL+JaV/YgQk0vFG+5hIcabkv0vg5A0mt+itoot2/UwhnoAEcrsbfG96EzngoOTsjnZ3mkVmp18q1nvr16CUji7jTTL/jgZMFv1zh2i0Yx+h1XMJSs6mOXv6da3k0/onIRkVbgoa+aUfClOm3NFbufaTNJVMnfN33fAivrsUE9xw6mGudXQxgn+fQVJLx+ZGMcgzVgWQHX+rbHbdoOcQI0G6o8R8BSq2uFlN9W7Jy7Eilj+/ACgf15Bo595QajHeLPPWRcFTbYEMUN0sq5nCR7M8wpG+IkzrXVo+7kHl5Yq2qtS5MGdWlGw7N+TR5T6RdpGlZG5Fke8HxFPZbn4NHu781YWeJwsEmvi8p3PEXvB1NQ8QxfCQVcQhbxfkKrZ0sdg/OoHUt0IH+jpy22a/2tSTwr5L9WbDNR9ABPXrErISS16zO5MqQ+lmw9N28BOtclILpc7clGIS7kGM02AzYqB/MfMVZ9/PJNKy+TFsndOmrU5rlmfoiUI+5kDaMVor/ZUU/6EualJIzCgjwdMG4dq+zvJkixsixaImBckYKXtIUaOcwlWKWhjDcIMxn2dns6tTOkW1iMqULAIlCvgLxxti+keLHyGcSOkJ3GwIwNooHexCGKud069bkwTFFvH/iKSEPmTnGjBC086AL0naHWMr2iODLMdqyiOVwPGWkKz+6ocU0Aa1fDrImuM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qPW25D38FnGwcEmElcGTH2VInHICvu+fZvN8cjE4fG+5dTxdGJP04w45KuDd?=
 =?us-ascii?Q?OLF309gxUBIU0Ke1ZEUiu22L566AqObZVa87biF1McATmsEotwN3WhU40qo2?=
 =?us-ascii?Q?0Dal6kzzrUzDp3YV/030sLQdh7j2lLbdHAMMzGr6xtbRgKQTkhtYJPn+eW/Q?=
 =?us-ascii?Q?cypupubPsy4IL6IqvLm51AvcNQ8EnLJRSxkcaeB4nsX2xeI4DWhKd8IVHeOI?=
 =?us-ascii?Q?6k0dzDl/tRpasJEwuWTnzIPowFNkjwCek/4aobyabHu3bWX6VQIHHxuSaXQr?=
 =?us-ascii?Q?xv2PypPY6kIosUyXPgbA5gue+gnE3swteK6MtZTsyH75kqOcoVTCDHVtwrK2?=
 =?us-ascii?Q?dXdXWSt0heKqmYLW+lAbWVX2g0aJGUvyf/jLsWQT4/KDFVbuhPWECCenthI7?=
 =?us-ascii?Q?M6E6RcnHozoCbHNi21okhhKe1NbTOkH5eaTh/iANDHPzbr0t4ZMG/OZG+l2V?=
 =?us-ascii?Q?J/XvuM7VOCLAhOKGKNv9emPBNJdEQs7TUicrZIa8NChaZk85ILQtF8asVqTy?=
 =?us-ascii?Q?P9gPMc2sN+ldSo3FdjcxMQpS6Le0OonZUTKua6uWuDtBVGxoMTo1169U8B2u?=
 =?us-ascii?Q?lxfNKnsEzaYgAtMfv7KEMS5xPGuYTpQdOmZmlmHPR3pJFGlcKyKbBruOQtLJ?=
 =?us-ascii?Q?O8MdmCAYbSZajBkZ2cla4sjnp1G+AxM3Y/AzBvAtPhDaC+5DLQFBeBLwB/GD?=
 =?us-ascii?Q?JZUvVRcLTDKLiVXWI50p6MtVGtkCAruYTaFHD0BXx2E5/gPca9kva4RJVS5j?=
 =?us-ascii?Q?mqvHB3LWZ65Mg8W0kBhsTQJwEpsa8GGIGlpoCrzR7oHY0BrAAdcx3SFhphwV?=
 =?us-ascii?Q?u6/WS/l0l+5HbEoBuTfb/+DmNSE0vhuGNh9U7O3kPDv7rzo/VuSYqWq9jqo8?=
 =?us-ascii?Q?ZNtVjqrmEf3xJB/rcTkqil8Q3SUzcMcVhA5IBEZighbZVOx7HsvUkejtee5T?=
 =?us-ascii?Q?yHuQky5sYrfAc6xwEAZyDLIVS1Y4zZuxvJWm7KKRDtMv/DaBzXxk7SLY4sAN?=
 =?us-ascii?Q?aA6dswbWjzb6KVFCpwCzoHiXfdCLuyZrfsxWE1cgkO0EzkS0wE9kxguEdOMV?=
 =?us-ascii?Q?4q5cFzyWfRc4+GWgVaWrrPUBsb0bVAnGPjUxc39eR7cXzaNmUFPOctwWlg+R?=
 =?us-ascii?Q?BgMb6KDfnUO6YvFB1JrjU+VfC0AQ0dyqhtYPO9v7zPMcvvVGLNvi6IwGPfZ0?=
 =?us-ascii?Q?5NnlnaDbcOnSc15NcYaMi8qed8rGnTaDuHmHwyrsHom8GgNlO1RMhTu3cw3S?=
 =?us-ascii?Q?7UvCfEzuCyVcM9vXYSuxLjw++CtIHWM9bBy6RKlLo+IJLZ9RySVnAzyxAAhE?=
 =?us-ascii?Q?w7FuvHB3lYx2kg950bdjPPeu5V7aRI7TO7qBAHVfoPKrYePPDVjk6TLJfdmz?=
 =?us-ascii?Q?/nshKrwtDEyhWpGBJlbDprjbgnWn/c8ddiafLDp0N8nlUw9PcI9eqDR9q0lk?=
 =?us-ascii?Q?siFXQMqCkgpOi5gfG86MS0iR1BvFQoB4lUcYCSZLHquxf50eD2flgEfat7+e?=
 =?us-ascii?Q?3Sx73vBaCGv/oYBwpwPzY7z44F7ojOZU0TtqxCrPOzZ6IqzMuM2R0DUgJYzf?=
 =?us-ascii?Q?FjbKWJfXLy1CpHwyNLZO6Gl3bEKh1zYFU9iRMWyVstcXSkJwoa5Kwq9woFm/?=
 =?us-ascii?Q?0ekYFBHoIwqn75AvQ48epu1B+dnERq9qdCF8UoYhBaWNabSyElD4rsICV9zY?=
 =?us-ascii?Q?kfP4sMIlgpPpzKZaVjIAKrQ9QWFRxKG8kpNWgnAJ9v++94xM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9091ce-72a7-4e7a-7d36-08dea16fcc28
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 19:37:47.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZFOqa8t9xol/ijNh4b1xqLxscFMNSsZyHCjNlSmUGS/pnQSadiNsXNuZe/lvuyE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9104
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E3B218000E
X-Stat-Signature: 97ppyz4xndoqza1jidh6cye6nrwhuqkj
X-Rspam-User: 
X-HE-Tag: 1776973074-482367
X-HE-Meta: U2FsdGVkX1+SpQ/CiiOGiYAmbf3LcapP0VHAo9H3Y4ivzbJkJNn0mFcgk2NtdZcYvaVExrgkzTcyT+oGYb62qV0J6Zd+co4AHAzMtdy9KX80Xt4451I+2z2UjbyqqZ8uF12eTfFBt5wACBi4NzGRyPXdduP6XutPQYqnmLfwGsShVrwNmv/WifIEPIXd6pJQb6f6Dj+zjR7DQ+U1pekq58XTO2kNOMVzrZ4kzowNd9DhdzO3v2IYljeBzi6s3rC8pcK2R9Vf47yqO9LMbgtYcjJcfDZnNH3OJr5pnzSNKeXARdAbQzWRB0sll1qArqIZ0c1Z4YPkjPPSL7wFc1Cj+lK9p/zB9fvqH+1S8D4eZfQn3ceRh+k47VlmR28N1NY6FsKXRcHVjDN79O/1mFMjrKawIdnT/a7hPLNw+mH+6M1MiRQO1hQLckK60ZjOBaTJgdlMG+3mWt1YXkiBoZt08+WsltC25t0cZBggClWFZ+4f0cl0gpwa8nqcKjQl+sgZVHsWT7QYnYvXw3ifmd4wT3E9mrz6UMFMFlQCbd6lriiALz05VKG69w++0L/vB/Ru0ZNwIbhzl7TI9l/XgD/JwvgllNmS+A0gamom1mptI1PIHNHP4B14CSk8aTd6HJY5aYKuuPWCJz1O8AB0WzlmbIaSeo4R1SEuSEG8EG08h2CjggzSGVSSoGHHER8CVH2cbOOPd4m30oTuT40um+z4Ik/McEGsbcYMb1IXPn5mCh35Q8WcofmPU+h29AWABvJrUrucX4lblQErAy30CN/TBcJofJjOEY28y/xJ6XNjqzrAlmyGcNS1BR5R+PbJwP0nbWPJPEvpqcT4noiNMUTjYorZpiR1Aa6ddIdK9m2X2FOzlFzaleduzG2K94+l6zbqfkBVdmm3n96RLckkKAdBStSLaTCFYeuGa64boqxlQSdg+sk7a1k52bj9BophAQ5wuArNYMuRSuteCT6FaYh
 E2cfMI7U
 LcmmxxntpJXAeSOoxPtB/N0QKTUefEMmMxFlowQkI09fv5skh/VqozaSRw1XmTsAJPLKqMzcwIfSY0eP7XV+WZI07NkyapFhFl/rJVDyhdqNM7VgZadszMnnbW3NipPZcmss4cZObgwVrpX0TKX6vsFRC9a1N6OFpqdo22HipG/GtkRwhwvnPpFnnrixm78SVuwgm7pevgOjxMPtEFFuQKheX0ygY8vmUyvICq+2gWZWPXu0+kzyod7t9aOu+oM0PGw/1srduAOjmR7Sw6XiWMSomfOA7jQQGXi8p2/LPxX6IQdhnfbZdZTMYMTQx8kpOheDJ65nAJ0QkLhpNP/lPO3DBXwrYC+BdifDTFtiBX4OieRdZUqRnSlGgmCKKcmzZ1PkioEYAqpa58MPRhGg3GMXbEJearvwULA9Jxr8xTl1mpsyP5agLXwdId/+VvVgVFArKzp6Yz9LS39eSUU2l3vRlCKvIxYeSDjWP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Apr 2026, at 4:01, Gorbunov Ivan wrote:

> From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
>
> The current atomic-based page refcount implementation treats zero
> counter as dead and requires a compare-and-swap loop in folio_try_get()=

> to prevent incrementing a dead refcount. This CAS loop acts as a
> serialization point and can become a significant bottleneck during
> high-frequency file read operations.
>
> This patch introduces PAGEREF_FROZEN_BIT to distinguish between a
> (temporary) zero refcount and a locked (dead/frozen) state. Because now=

> incrementing counter doesn't affect it's locked/unlocked state, it is
> possible to use an optimistic atomic_add_return() in
> page_ref_add_unless_zero() that operates independently of the locked bi=
t.
> The locked state is handled after the increment attempt, eliminating th=
e
> need for the CAS loop.
>
> If locked state is detected after atomic_add(), pageref counter will be=

> reset with CAS loop, eliminating theoretical possibility of overflow.
>
> Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
> Acked-by: Linus Torvalds <torvalds@linuxfoundation.org>
>
> ---
>  include/linux/page-flags.h | 13 +++++++++++++
>  include/linux/page_ref.h   | 28 ++++++++++++++++++++++++----
>  2 files changed, 37 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0e03d816e8b9..b3e3da91a90a 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -196,6 +196,19 @@ enum pageflags {
>
>  #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
>
> +/* Most significant bit in page refcount */
> +#define PAGEREF_FROZEN_BIT BIT(31)
> +
> +/* Page reference counter can be in 4 logical states,
> + * which are described below with their value representation
> + *        state              |         value
> + * (1)  safe with  owners    |   1...INT_MAX
> + * (2)  safe with no owners  |         0
> + * (3)  frozen               |  INT_MIN....-1
> + *
> + * State (2) can be only temporally inside dec_and_test.
> + */
> +
>  #ifndef __GENERATING_BOUNDS_H
>
>  /*
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index a7a07b61d2ae..32194e953674 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -64,12 +64,17 @@ static inline void __page_ref_unfreeze(struct page =
*page, int v)
>
>  static inline bool __page_count_is_frozen(int count)
>  {
> -	return count =3D=3D 0;
> +	return count > 0 && !((count & PAGEREF_FROZEN_BIT) !=3D 0);
>  }
>
>  static inline int page_ref_count(const struct page *page)
>  {
> -	return atomic_read(&page->_refcount);
> +	int val =3D atomic_read(&page->_refcount);
> +
> +	if (unlikely(val & PAGEREF_FROZEN_BIT))
> +		return 0;

page_expected_state() (called by free_page_is_bad()) checks page_ref_coun=
t() =3D=3D 0.
This change alone means frozen page can be leaked into buddy. But I think=

buddy pages should have ->_refcount to be 0, since the comment above says=

(2)  safe with no owners  |         0

> +
> +	return val;
>  }
>
>  /**
> @@ -191,6 +196,9 @@ static inline int page_ref_sub_and_test(struct page=
 *page, int nr)
>  {
>  	int ret =3D atomic_sub_and_test(nr, &page->_refcount);
>
> +	if (ret)
> +		ret =3D !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_=
BIT);
> +
>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
>  		__page_ref_mod_and_test(page, -nr, ret);
>  	return ret;
> @@ -220,6 +228,9 @@ static inline int page_ref_dec_and_test(struct page=
 *page)
>  {
>  	int ret =3D atomic_dec_and_test(&page->_refcount);
>
> +	if (ret)
> +		ret =3D !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_=
BIT);
> +
>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
>  		__page_ref_mod_and_test(page, -1, ret);
>  	return ret;
> @@ -245,9 +256,18 @@ static inline int folio_ref_dec_return(struct foli=
o *folio)
>  	return page_ref_dec_return(&folio->page);
>  }
>
> +#define _PAGEREF_FROZEN_LIMIT	((1 << 30) | PAGEREF_FROZEN_BIT)
> +
>  static inline bool page_ref_add_unless_zero(struct page *page, int nr)=

>  {
> -	bool ret =3D atomic_add_unless(&page->_refcount, nr, 0);
> +	bool ret =3D false;
> +	int val =3D atomic_add_return(nr, &page->_refcount);
> +	// See PAGEREF_FROZEN_BIT declaration in page-flags.h for details
> +	ret =3D !(val & PAGEREF_FROZEN_BIT);
> +
> +	/* Undo atomic_add() if counter is locked and scary big */
> +	while (unlikely((unsigned int)val >=3D _PAGEREF_FROZEN_LIMIT))
> +		val =3D atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_FROZEN=
_BIT);
>
>  	if (page_ref_tracepoint_active(page_ref_mod_unless))
>  		__page_ref_mod_unless(page, nr, ret);
> @@ -282,7 +302,7 @@ static inline bool folio_ref_try_add(struct folio *=
folio, int count)
>
>  static inline int page_ref_freeze(struct page *page, int count)
>  {
> -	int ret =3D likely(atomic_cmpxchg(&page->_refcount, count, 0) =3D=3D =
count);
> +	int ret =3D likely(atomic_cmpxchg(&page->_refcount, count, PAGEREF_FR=
OZEN_BIT) =3D=3D count);
>
>  	if (page_ref_tracepoint_active(page_ref_freeze))
>  		__page_ref_freeze(page, count, ret);
> -- =

> 2.43.0


Best Regards,
Yan, Zi

