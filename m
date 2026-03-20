Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8232810987A5
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76BA6B00B5; Fri, 20 Mar 2026 12:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E546B00B6; Fri, 20 Mar 2026 12:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16936B00B7; Fri, 20 Mar 2026 12:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1306B00B5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:38:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AE86C174B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:38:40 +0000 (UTC)
X-FDA: 84567000000.05.CFD9E78
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011012.outbound.protection.outlook.com [40.107.74.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6FC6F4000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:38:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=wmirH38e;
	spf=pass (imf17.hostedemail.com: domain of tommaso.merciai.xr@bp.renesas.com designates 40.107.74.12 as permitted sender) smtp.mailfrom=tommaso.merciai.xr@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUaF2zBafE5XhIkxuCF1iSKJA/iEaQcMcv/2oHHRx24=;
	b=YuQ618QHnCL3G7ZYeK2MwHenUJ36KsQzSZbAdr/+/UsDrcJF3xz6uREehC6YsHSiQLo3KP
	CatAF/TnIYe78QVwy6hG/Rz/tkyJcaV8tX1Yuk6KiU3cGgY9KnpQV3E5Xlq++9oHzvSuVz
	gEl4XeNmWe8lTjhprHHZYh1ksFYnIQ4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b=wmirH38e;
	spf=pass (imf17.hostedemail.com: domain of tommaso.merciai.xr@bp.renesas.com designates 40.107.74.12 as permitted sender) smtp.mailfrom=tommaso.merciai.xr@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774024717; a=rsa-sha256;
	cv=pass;
	b=2DY8qBG1uwJ3fnYtB158w1cpB25ZG51R2b3mL+o79g2Z4ssTuBcf2vBK1GLkETIgMRV9c+
	eBMltUWltupKg8yBswkuVXcFppsT/IhyyQiX4f/RX1Yp6gZtKKnbN3nNBv3hoLpN67vvaZ
	txC0wNP5+M6p1PC3fqMSe+uxqDN3nOM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJMKJbUK6AcN1oVY5erMf7sGiUwxHJJJWlmBdV5XlGp4RZ2+QAR3TCM2pbude3z42F3LxWmQhWuLJIFgbLKg8kxoZok+U9dIog+CFUNCvdPnD2qSkUaJs7l4GETCTszyhEw42Z56j5iz40JDwkIrvgnqCEC/cfTPYOg2OZvWY0zYO7SrW3s4Rf/yMj2/CFNXYgiIO+AGw8UvV2SS+2IUp8WAa0b3yigpqxvAg2eqCZcrx3/uWJ5Hmg0CkW1uQbU/iPe2rsSKvpF9D7vz1htvo1EGbaE09/bexq4Sfc9mByMeskTPqJMX7b72GY9pZULYcpCK1rjdkOue+D3R7oVD+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUaF2zBafE5XhIkxuCF1iSKJA/iEaQcMcv/2oHHRx24=;
 b=alSsrcPIADoVQhY6r1npjJ9OQcrvwoLoqdNbNyiNl0HOY/THwMHyBfwtQbkJPq4pNBxs+wEil+4dmYI7a857oH6WcLHOsBP6bQwX8bpyplIFsc8zWMwS8Se8w+bhQz7fn1e6Btx/a5Sl7GOW7dIUIMKhiI+LASBxcTj/a92CBfMhSjhI5JBVQPXnN1mSkF7Jc6C2SOqomhCanvWaGyree6ILDl6rvfbiXlrfqaXN3rblNaeqdHrw7MaooUTQW3NsZFI5mxqXNYcpxKQyGlEvQyv0VCCXSXzWcgCtoszVU9mBgnTNo2cRERgdwoOHJ9maljuKAPpZafVqCv5H6jigxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUaF2zBafE5XhIkxuCF1iSKJA/iEaQcMcv/2oHHRx24=;
 b=wmirH38eISH3O1K3J+LPr/3wcyeieVM/WswC2zAbPDxj05DUAQ6fIOjN21935E08ADkWKJo34lAxP/kEhAnjQj1ia3CzYrWLSsT1vWivibX7oOg8+EWNkxfxdYrIBo3/xSYaGOAyoG5FI02Dev+TCn/puatKxjJ/3lDme20oJyg=
Received: from TYCPR01MB11947.jpnprd01.prod.outlook.com (2603:1096:400:3e1::6)
 by OS3PR01MB7215.jpnprd01.prod.outlook.com (2603:1096:604:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.22; Fri, 20 Mar
 2026 16:38:25 +0000
Received: from TYCPR01MB11947.jpnprd01.prod.outlook.com
 ([fe80::33f1:f7cd:46be:e4d8]) by TYCPR01MB11947.jpnprd01.prod.outlook.com
 ([fe80::33f1:f7cd:46be:e4d8%5]) with mapi id 15.20.9723.018; Fri, 20 Mar 2026
 16:38:32 +0000
Date: Fri, 20 Mar 2026 17:38:11 +0100
From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	kernel@collabora.com, Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH] drm/shmem_helper: Make sure PMD entries get the
 writeable upgrade
Message-ID: <ab138_jW79ZaNC51@tom-desktop>
References: <20260320151914.586945-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320151914.586945-1-boris.brezillon@collabora.com>
X-ClientProxiedBy: FR4P281CA0305.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::14) To TYCPR01MB11947.jpnprd01.prod.outlook.com
 (2603:1096:400:3e1::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCPR01MB11947:EE_|OS3PR01MB7215:EE_
X-MS-Office365-Filtering-Correlation-Id: bca257ec-3fe5-451c-0d35-08de869f1f56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|1800799024|366016|38350700014|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dQlSdCmdMFvQdyxgj9oVfGH+jREZ5RETqKz25VZr0O29U6sYXM4q1Wuc0t7/q5/bJ06kE++G4XXZcHwwZDEBN9+wP2FQ2XkvsBUUwcFE2n9jd5wKfF7Nqv6CJ1VVgt7+y0Vr2S4CNAKIBnNr2NFcixMMaqtdqPqjVWfh0iGgNVJkmjGLLsNZeL6noB6wuEo9EfLeYivT7zNDjW9nc718Pb5363pXJ87Fgd9erfaDzF36Gbo6vLq+pbB/ev1NtysnwuE2czUkE6mRcr5wNZ9FiWtX58Re8976Gg8Qh6KvbYlW7trEeuwmtm56s+bBjm9HNzexYsiYA+1CKhpXDh2a6rNzVWWTY7mF8lredXWr5L3c8FRtXb5nruVViVLJ1Dk4hKUVEFHa1YVX1jDovGg4/dgAl1iMAa+xF9+Fh8uK31VWqU+m1E1Mf/QIVP5YZMuYn0tn4DQ9lpSpBI9SnwaPWQYDddhUMg6Pceln+wa45OxarZRFGnlrV1OEO55LesoKPGJxb9MSDWZG+1Gb59k7V30W2JGmIpxNyMLKJeyv3SZCX7PkUarQv/Q9YukY5J6izLqQYOEamft5ZFdvpi/zf+tL/Tx533m3LjSG5ef0zo56DPdET6qs03BeTk5Hr+wpuE3bRQ3Pyq5uyF5HxaHhfC2mOn9UE4euF2Yl2yztR9jTCooLNh+2cuGv0NdZdxD4IznuD7mLdRx7G54h72N0xb47ldElBJia4zDVnIGTwFIdi+gr7Hsg/+QUPuIcgPLD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB11947.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(1800799024)(366016)(38350700014)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7FfqC2L8NBSrEwVFQetZZV0DAL3lN4BqkTA83c2Ut1O4SJr7+JavApNBdqJ0?=
 =?us-ascii?Q?uDMeNJzB0+cY7zFAkM7jYxVVzgDZ6AyWaPgq1QjLf2bU6rKd7xmYQ+xwQu5P?=
 =?us-ascii?Q?9sptKPeDU2UxuhbgwgHG1uMfW386NlVoF+nHgXXrj4w6tEj9lKhvinEXlig0?=
 =?us-ascii?Q?COysEPyznv0HEAuDbYB2Y0nY71iJPvp5E8r5eep7R3Nu4c/v9R+Jo7KWDOoK?=
 =?us-ascii?Q?/SFOLx8u9T4+mMegKdrgAjSpp/x7NDzf9l888JBvEeVMZR8NJZl6KkIkjdVl?=
 =?us-ascii?Q?+IriyJbjtx25G5el0+dT/M2Z+mteYiCa57sLOAixYQ7sSvcxZa+w5F0R+8Np?=
 =?us-ascii?Q?TYyd0Mw6qKTrrqSxuoRPIZJOX+PZxzFxVc/PSsMi8qqqN7Yw3UF0YdCHjgcq?=
 =?us-ascii?Q?/2Z7IBQRzTYSq0syAk4HAXDLGspSQ3nk+PvIZaXvBxpW9C+AbVZFngxD0O59?=
 =?us-ascii?Q?APqYsCCGBhgVvDBnzdQ83YgYE5tyvdU2lRhtgoMqEJjZjE21XZ7Ac/6BzvKv?=
 =?us-ascii?Q?cNaz5lmSdwIgF7i6+NrOW12W4Kg9ZU4PjPCTmk+bLbCb0ThQdL4ERoaOXW7h?=
 =?us-ascii?Q?Tgg9+nvtJsp0Vz6Ru7F+ZBl5k2kxuTHPwQJ4LisNIrVHdQTjLuzNtDeagAxN?=
 =?us-ascii?Q?QuSBQqrUTu6C/0iNcvKhcuUynz1svjrFxoI6Qn1bMGL0eybBeXt6VnOQASFU?=
 =?us-ascii?Q?Kp4cppBsGw7ld76h0XHe4cezkijn2DJrDGf735UuxgfhJne/jTEmiz3rh6Jj?=
 =?us-ascii?Q?oc2QvgvlHoQwrACyviXi0Sx3F4ITUqWbOS7m8pZzVRC0rz7EYNzVX+rRy9Ok?=
 =?us-ascii?Q?V/6ivmYUo6FXPKNDJL6BLQiAzM4OYz0gYAqgPh00Tc+YnRoq1nt4M2+PmmwD?=
 =?us-ascii?Q?NcVuhNcvLBLK8744tyab52L3qH9LAOT6989voK2eCR3sYqhCjzKvOHdazWDd?=
 =?us-ascii?Q?mc/jBKGAOrCjIPtVf0c5jDTIekDQxtoo2laTw5Iz0xAwvvUhNbHukbQojT3f?=
 =?us-ascii?Q?7yVDlZra6gOJshFYL0/qZY+g8A1e+4ffHgRMTP+CdkLSSQElgIqtE5BHEWxO?=
 =?us-ascii?Q?4cRU7L/txsVRk4wYRvXj33ErSgnWMZAELwCGKZhH1iVbpBID/nxAmfOzDYbG?=
 =?us-ascii?Q?QEFBHzGW66xpLc7/Cv6Ahf7bp/CxlpFTZI/P89YtRAsoOyrdaEMox1kbEvig?=
 =?us-ascii?Q?k5PCsXbCQqTUT6YTkNyqHZnlNxLxdQtfMK6WhCnOMPlqRu7ZGq64S329qirc?=
 =?us-ascii?Q?g8cPPlsPhFsqGwDtj4Cl57cN6q50QhVwyFM3slsVVXSvXjD4bz6hcBgXn73/?=
 =?us-ascii?Q?Dmr8Yi7HcMLfUiFkbpgtOn1AXZF4hhk16/VZSiaBwXAdFzuMD3jXFqRe6Pym?=
 =?us-ascii?Q?lBqsXzMPfW3BvbrxysadxznmdOrVKAqtldfmBQ8WepJInx/DtoUvN8/11/GN?=
 =?us-ascii?Q?v0+gbuBmuwGYJapKUqUZZuwlVZaEPYe1eG41RPcUHQXVypIU5gg2V6fP6pLU?=
 =?us-ascii?Q?jbpQJMD6Qac3AgJmx6+GRYPJ36YizihIqp6RtBUfcUVLScUuZCcTEmZFSCmH?=
 =?us-ascii?Q?vpae22UJjh/35kjlIuPAV297Hxwg0JymUq6K3MjqeCKxDGc/m91S93thvrUa?=
 =?us-ascii?Q?MNjMl57VA5NNHMHn7ymxq3qN8fwmOGSGwPMdqvpj/VGFgO1SbhrUNVORWO/2?=
 =?us-ascii?Q?8EfaLHNlN/RDMhOrhyBUncnM0ut7fytCTGwmpV+kkDmT+zniD2ARM9gVJ+f4?=
 =?us-ascii?Q?PRw7f0r4OV8+4xm9UmLTXoeSn0bzDbcMBRmugTWXoG+Qv3yhXe2F?=
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca257ec-3fe5-451c-0d35-08de869f1f56
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB11947.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 16:38:32.0284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RjWH6I+e7gnKRISsyTARogezrwJdBaV4bIU6C23M2HR38vBlEHKfhjnO9GY3Co/PnLAVRnGy6bS9xTD4963fftk/+bA++GylOIrR+6/aDNFDHO77proByVGCTY7yV87H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB7215
X-Rspamd-Queue-Id: 6FC6F4000A
X-Rspamd-Server: rspam07
X-Stat-Signature: woxwj3sask8mgwsjk8dopje93obtfj5z
X-Rspam-User: 
X-HE-Tag: 1774024716-782325
X-HE-Meta: U2FsdGVkX1/+n3t/NKCnGTtoiBzQXfApdeVRqbAucGQyg7klfn5RTmuzbzz4mQ/XpM5qoMIXukNHDqZoF92v2i8E1a+K+QVtUWb09Oo03IOvWdQhFtkPOCEziGX0t9o1JRxOphRI5U8gujC4ODCnG0Rw324OHkoTpurS7MCFfomHZJcKCJc4uI6DLrrcQD69hbkGED9aZuy5sWIjuEn3mK/3IZ0oC/sFGBJAugWaZRVIVZv+b17W++H/tscP9UkBWAyTZe6cC5zcUtcX6fTfT9Nz40kIRGNrxF3W92RxWGldZR4yHyZeAYy91bJYKBqr235OgIqb2Oi5rnJz7poXzj62woxcq2zSfgzc0QBQKAexfrV04E5UWVWsuV3MAqhHlqJzhFWQy35MTA9ceLUatK3ftGECPKWfxMnOxy57m//l/JAIpFzptyaeL4Zi3n1NqRz5+Q35m/ZGTE8bNFSWs/rPgEoWL9Ck9ou6FyfuMosJ9+YTT8hAe0BxUfILDDvYQfG8TjSaTGglzbMZq6qU8ieKT8nJKXjjDnzAQViti1v7atlh2QrqxJrCwtjkbaC0TqMEP/TApQ1yPfVuc7vjFREkm0kV0/xs65RW7slcT2ubu9lPS46TfszBcpL2tNhmKs93hEQ1lN734m9Kc7rkSeCRL52R4eMuw22OB+iCCAy5L+gwmLGgivl7ZDvNNh4diWG/tJM2MxW2OkcNErtDB3aoPTsKVmvLTDQZo2JwEFvh03jP5p1eybCjx5BhyxG2M/ghpsGBrAPgmIWSdG9rwA/dHVSENrkixfojNLCT6Zsho0KjsCVRLdkteBj+JEK4hFghPazVgN+X0oyx7EMGe1QRQEKodQvtzaMDXA6u2dNq/wanD7wFIK8KZhFIhxc3sfn2IsC8stalkZbabxR8mjWOsbbzmpe5q8HBa2dXD5Z8kWG5PDDYvLS/Vegr+QFZZ59k08aiupftZsIWmo2
 TqytH004
 rm3xNLnP4oyPXx2vsi0vyK05W2ihcH4V/q2XNzApyjytO5OH/WELbpTm5wRPCeTyrSO5hEs4binLj9cXc0XNu79fGwqgIazfdgSC8OQZwFo4o43LmC0oczlgl/PKQl0GwL25EbLuafXa07sYb+7YlS/JP4bgsfQg1pwEj8e/QkP5yjQYbkHs23UH/1hCwSYE7j0BwaFBhUUzuIjHd9FyiPy8pBl+tK1pTV20XT1lpLfC0RKJO0EBVqBpcx31wa8+NeY1eZcF2F8xUpKAjh1S3uxZ1yxblWXZOvDrAMql/Yi+i8ZtVZxIDCWx65Ip5WFe4ZXKj2shqLWUoEPajg/6vixt1CrzB8XD1DZKr9ZeaxmgLVhr+rVksrq9lG5K4IksQ2/30bZWSutFVSBliZpRX3vTj7CKxnDHRsy5t6V/AvmCz6ECgSRbmiWjWNbxzYC2hYDRrNjk05akHHC+TsiPlzLgk7GM41VBlWzrWnOqb7gbMVFugmIforDEJ6ApJA3//L3xjUwKfV9jscMQfddo1/k0zfle7Y1DCckPNKzDw8DahGt9ofiuoLPHTWwCDe/MpreuThkYVyQOxDdiKIbKaOMa76+Vq+/mIUpMgHy1flftK4wRcML13kGJYWzjA3sHKUOWhQvFWWo4+IK65NB3/vtHiFd0YTVUBOqYDs8DohZ0Z2Zwsub4Cv4DbFnhBry0SxEtDD3KLXi9LPmCGvc29rKfmqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,
Thanks for your patch.

On Fri, Mar 20, 2026 at 04:19:13PM +0100, Boris Brezillon wrote:
> Unlike PTEs which are automatically upgraded to writeable entries if
> .pfn_mkwrite() returns 0, the PMD upgrades go through .huge_fault(),
> and we currently pretend to have handled the make-writeable request
> even though we only ever map things read-only. Make sure we pass the
> proper "write" info to vmf_insert_pfn_pmd() in that case.
> 
> This also means we have to record the mkwrite event in the .huge_fault()
> path now. Move the dirty tracking logic to a
> drm_gem_shmem_record_mkwrite() helper so it can also be called from
> drm_gem_shmem_pfn_mkwrite().
> 
> Note that this wasn't a problem before commit 28e3918179aa
> ("drm/gem-shmem: Track folio accessed/dirty status in mmap"), because
> the pgprot were not lowered to read-only before this commit (see the
> vma_wants_writenotify() in vma_set_page_prot()).
> 
> Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
> ---
> 
> This patch is based on drm-tip [2], because that's the only branch
> that has both [1] and the dirty tracking changes that live in
> drm-misc-next.

Tested on RZ/G3E, this fix the issue on my side.
Thanks for your work.

Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

Kind Regards,
Tommaso

> 
> Also added the THP maintainers in Cc, so I can hopefully get some
> feedback on the fix. For instance, I'm still unsure
> drm_gem_shmem_pfn_mkwrite() is race-free (do we need some locking
> there? should we call folio_mark_dirty_lock()? should we call the
> fault handler directly from there and have all the dirty tracking
> in this .[huge_]fault path?).
> 
> [1]https://yhbt.net/lore/dri-devel/20260319015224.46896-1-pedrodemargomes@gmail.com/
> [2]https://gitlab.freedesktop.org/drm/tip
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 46 ++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 2062ca607833..545933c7f712 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -554,6 +554,21 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>  
> +static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct drm_gem_object *obj = vma->vm_private_data;
> +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> +	loff_t num_pages = obj->size >> PAGE_SHIFT;
> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> +
> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> +		return;
> +
> +	file_update_time(vma->vm_file);
> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> +}
> +
>  static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  				 unsigned long pfn)
>  {
> @@ -566,8 +581,23 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  
>  		if (aligned &&
>  		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
> +			vm_fault_t ret;
> +
>  			pfn &= PMD_MASK >> PAGE_SHIFT;
> -			return vmf_insert_pfn_pmd(vmf, pfn, false);
> +
> +			/* Unlike PTEs which are automatically upgraded to
> +			 * writeable entries, the PMD upgrades go through
> +			 * .huge_fault(). Make sure we pass the "write" info
> +			 * along in that case.
> +			 * This also means we have to record the write fault
> +			 * here, instead of in .pfn_mkwrite().
> +			 */
> +			ret = vmf_insert_pfn_pmd(vmf, pfn,
> +						 vmf->flags & FAULT_FLAG_WRITE);
> +			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> +				drm_gem_shmem_record_mkwrite(vmf);
> +
> +			return ret;
>  		}
>  #endif
>  	}
> @@ -655,19 +685,7 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>  
>  static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
>  {
> -	struct vm_area_struct *vma = vmf->vma;
> -	struct drm_gem_object *obj = vma->vm_private_data;
> -	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> -	loff_t num_pages = obj->size >> PAGE_SHIFT;
> -	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> -
> -	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> -		return VM_FAULT_SIGBUS;
> -
> -	file_update_time(vma->vm_file);
> -
> -	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> -
> +	drm_gem_shmem_record_mkwrite(vmf);
>  	return 0;
>  }
>  
> -- 
> 2.53.0
> 

