Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69AD0CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2466B0099; Tue, 26 Aug 2025 05:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962A46B009A; Tue, 26 Aug 2025 05:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803256B00A1; Tue, 26 Aug 2025 05:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 650576B0099
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:49:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C361A1399EE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:49:06 +0000 (UTC)
X-FDA: 83818435092.26.407A2BA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5816C180014
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:49:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ml6dnTCE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l449Ifii;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756201743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NSlLP5vhQOg9eJsWe2HknOV2TxdHXsJElG/LZTPilM=;
	b=0ubJJFWigsH/NrU5LxdANkjp3LLEK9a/FlnsnVWclSiCxoGlqwBKt7bQh4mlGQLbXgMgoF
	zJ1fSuz4bbyono3gSoQVJ74Faf7iC4S+XJnVw1MDGfT8nZPTNSz+x6jXO2nb4GX+yMUqEj
	vhBMYqxdxmBtWbLhfBuTHV29L8xq2EM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ml6dnTCE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l449Ifii;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756201743; a=rsa-sha256;
	cv=pass;
	b=pP9xP/DMmZmnOOD4LE4fGisbPxNDsP30kIJlJBP9JoRdEedxbeuQnFBHkXYp4iMqouUEsO
	GOnCsSD4srubHU3XAvt2DBTr+HpBfb/X5bfm8KlchydOi4ck16kyZLYy0i2ROIS3TC5soW
	opYrZWdSpK7OGDguqk3oGqE7NO1EYZw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8lvsx003581;
	Tue, 26 Aug 2025 09:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4NSlLP5vhQOg9eJsWe
	2HknOV2TxdHXsJElG/LZTPilM=; b=ml6dnTCERxGAeIbA1gZiXRMQztrzQ4gqR2
	fatF6mC+weJ8pbuJMFwq8X/Y4ZLA97wgiB/snLJcbMSlg1qtsh66pOxi+BKSyo0d
	l2DPBV7wXnG8tmULmuFYUIc2ZvUukIytiqhwUGbo0OtQBm3nrJ+1vJ4PKVh+L3qK
	JPi8viFBS5bW7QSD/IUlICJYhQGpu/SDHmyfHJoeqo4ysKDe22EVplFyiQu1YqDD
	9ohYNhiXzctrJkyVeeyNpG15i08ljOI7Wox8g+heQgnQ0BbHygdbF5jJmajYuED2
	LpW9sSHotkXp5qzN97NV30q5iz1yPtf5ENfv77DLukWwGUbaOz1A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q678v2n8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:48:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q9XvuQ019591;
	Tue, 26 Aug 2025 09:48:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439d3e6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:48:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GhIBxAicjvgIT3uGx4/nORzvjrceUYwgd+4/g8vvnrsTCnlYlaT7z2vNhiwnsYKkRsCOEI7n6DLLsxifKTb4GmlckuBjIJnpKo+idWjEszct7JRDg0ZE5GOlYPjZ3gXtpAjRlWlwbSH0yZ1S6DM/wB4GtX63/N7lcp3+F6djKvEGDe5tb93AfRSofM/0bbZWbFpDJ5E6WEER8k4/dhLnB5ktmYarOGapzjmKW3eqZMNDXGkYBY1oF20P3R/IZ0qyEqGvBD1t8d7foP/v/I3V7wIqvdjp7uR3o1Uu2mTotUTkoeFiEd/cxCFU4ZhhvbIHCAOE0a5dnEnaZcW1wxzz/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NSlLP5vhQOg9eJsWe2HknOV2TxdHXsJElG/LZTPilM=;
 b=fOBpSgOxfx003omkRi8evzy30ADOO9qCNIOEzY+En39hqGUKeK7P/9WXMSsqKIW4bMI4Stp/LO0mvLh1Ch81O4naZhi5tx2HYHt/6LENkOQGnOHBs+DIGIoL1M4EKfNn4vlvy5dsH+EdsPmiDg9bUETnvzHQDn9DfIv6VpHIAmEAClXfWkTePYdx3lo+GTJHXXd+ME4A1NGRYfmtrKf0VXgPRDP0NBqdtv4PXZIX2K7sUnQvHCXYTDgjLFxJOCw46Yb+J9l9v6R/6rHmTajxUOdGPWzO7Ztb93q1dlWyfd15UNm5gTGKmFRXQHX+7+veQwaE8SWlqM5n0FOGiGAZKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NSlLP5vhQOg9eJsWe2HknOV2TxdHXsJElG/LZTPilM=;
 b=l449IfiisLnZYGY11l3W8pXCr5zL1EOVo2H/UKWe+r98BaQImP47smGuxsQ6XB/ILE7PjCMVoUUypBX4ZP73pVOvKMKfxgHqjsut+/rJSBp9EzO+dtXlmbyo3SWm7CXVfbqXYXTgvH7LKO3AsC3oQWmh6yqEF8Fkj7WqZbzsZfQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM4PR10MB7526.namprd10.prod.outlook.com (2603:10b6:8:17f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 09:48:50 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Tue, 26 Aug 2025
 09:48:49 +0000
Date: Tue, 26 Aug 2025 18:48:41 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] docs/mm: explain when and why rmap locks need to
 be taken during mremap()
Message-ID: <aK2C-Wuv7c_yIOJ0@hyeyoo>
References: <20250826065848.346066-1-harry.yoo@oracle.com>
 <87v7mabl9g.fsf@trenco.lwn.net>
 <f64483ac-31d1-4f80-8fb0-fcf15867c6c5@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f64483ac-31d1-4f80-8fb0-fcf15867c6c5@lucifer.local>
X-ClientProxiedBy: SL2P216CA0181.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::7) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM4PR10MB7526:EE_
X-MS-Office365-Filtering-Correlation-Id: ed8e3448-e9c8-44fa-5edc-08dde485c1d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0R/gnC2XLBroaLvI5WwBkO8LBrpkHkyOH/FAxYv3dafAgZR5PyfHWL2UApEs?=
 =?us-ascii?Q?ej4VqgkEBWwVsegRIFZZrvmUIYAPDbpRuxDstcooqk1Fokszh2LnuZjGMVp4?=
 =?us-ascii?Q?EDuxvmEtL2bsQXkdIcWVi+GiALdzGXPpVYll1tjvrLspJA7guWpxojUR35V/?=
 =?us-ascii?Q?9tWd83Jy8VUHZqWt8kz91lHmWt7mAzhhubA8PaQGDAiLJvunfDuBO4QvKq0E?=
 =?us-ascii?Q?ewzsESZLIGtuKWVW2GbjmtnGnaRn6jd/c67HA4KTccc1L+z2wXbqDHhc1ZZm?=
 =?us-ascii?Q?8jjHXkv4yD+i6Vsndw/HJlN1PI61Ss8gqw2M/eiewgVi6DS/6Em/sXCYVq9O?=
 =?us-ascii?Q?fd671bWPgB2RxU4tcrZpIx1HX7mx5x93w1s+sa2gqufw9T728YPmGeecIRXJ?=
 =?us-ascii?Q?xEEOszl7bxohejbEvOVyOTbm0S32SdfDpFKZ1yMjiKWPdZLOHfOh6zWgVVu8?=
 =?us-ascii?Q?1mVLW5dfy4doFcrzx5NshhV5XHN1A/P/7KpFKW0fSbwpy9h6k2oKpfmbXqhN?=
 =?us-ascii?Q?AM4ZuFcI1OjLB4jc9B5N9Se9+6bU5HneOQCTMFhLpDgGIYEAh+mIJJ4gAGrz?=
 =?us-ascii?Q?6lRwH4xMFO1vvA4HYlyyVJ5775rWxu2efJY/XTDkrsy+XIcwpBdk2CJk2JN1?=
 =?us-ascii?Q?qRPwXXmTKUaPXo+5ZGJ50yiE1VU12GDmOATitOybU+UJZDTJmSig2B+TWz1u?=
 =?us-ascii?Q?jGCOVtFpUrqxpE8i5IcRWMwM1OCAhrw8Omvfp8RB9p40QuWosbi9gWdwbUUG?=
 =?us-ascii?Q?/v3bkyglGJ2+L9VtR3oXovSqJur5+erIwKTHS1C/vIj+WmxruyiBPQ0xFBhp?=
 =?us-ascii?Q?ZPIUwYurJs2a54zyVy1Pgnq2J6AjuMV8gHhR2Qzt3a/oN9CxelfXzm+fC9XQ?=
 =?us-ascii?Q?uC2aIKNiCbZav4eh+0AA3QHf3w4TWcfNQN0nlngFPyHZwsvfb/6yv+YO19rG?=
 =?us-ascii?Q?pcl9Hx81Qf5XoFeduGoXLv2SdpgCcFGvKo9t1h7JQocJW66TxpdVp9Og0ozU?=
 =?us-ascii?Q?R0qfIWmO8lONIiEVChPEv1LzDQbGVbtFHpYWt+SFkuQpNH/Hk7Y87RHUtymH?=
 =?us-ascii?Q?8THP4v6xITGg2l+TQKwXpiP8Jb1DE63QSjaP8/EwlLdTkrNA/F+bM+zSozo5?=
 =?us-ascii?Q?r4qWlUALXbbZ8zO1FK77qXFGhiiR0fR/4ZeCcPOLnWa8A2BZ3lJc9hvypprg?=
 =?us-ascii?Q?ULK/otgDqkeuj2jstfs2TavHTKQC4sjIYjABsSxhzM1ODPjGtE2Rt0oNsRhQ?=
 =?us-ascii?Q?3mNktgHQ97KDu8GJNcAMwd0obDVla64dedbsVUd1vq9Yo/B67RAM1D/+NCYg?=
 =?us-ascii?Q?SwYkesyH8aFQXiYG3NNlt9CTkzQDxANSiYKejDXwKh0nuxm/FsuPN1HQDzmM?=
 =?us-ascii?Q?n42+ID7VgmW27Ou+8a1yMt+tFIympV5EAk+DrB0A9Ke5XjMn/oF08wbC5+Y6?=
 =?us-ascii?Q?aur6Ir7giJQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z6wLPtPziKtE5hxGcZvPVIqOwIsxXmCIarFF+v2nCPHo7wFA39Ktzmtvu1eW?=
 =?us-ascii?Q?mrBriMsLBwKugVgEV2iuhz9USb2b+9fpaO3asAltlPivbw2CLu/P2PKTdQ1X?=
 =?us-ascii?Q?uIoQZ5/gA0Phc8MtNp0vAr9fXceUjHhNaStBXrcu9z9RXdOVBWDbC3Wsn+rs?=
 =?us-ascii?Q?CnHMThTn8pHy3a0tAssKuxH+Cv3KPaH3OBH2V73rcIadRJpUeKFMCVfqJwxc?=
 =?us-ascii?Q?AJOO8K2aAbfmSypsfFSTMg+BVAv3H8+gF6ukEZ+lKUQT3dPrOv2kZd5wDg9h?=
 =?us-ascii?Q?zvsyEGWq9+75ncmDKFVtMafyRER0lPlNYFpddOWlgmNVkmJd+yAWXPAYP868?=
 =?us-ascii?Q?ZRDxLtARlJNEd3t6ZNh10kO/+hQPk6lJceo/wPigmjBRzmkOyrvSDJExv1+3?=
 =?us-ascii?Q?LbjbwuMKJCH7R0SBJjybDhem4wy2WHx21XzdBTsNPFk50RKjDsYgyEb4zqIO?=
 =?us-ascii?Q?qMj1RMdI9HkDtUlSfHFSf7+QIVk7rNswMi4EtqlJAfNKnuvgdZfWxZXNvS2O?=
 =?us-ascii?Q?JY/Z3DN5UJW2l77oUbND/+GueXEa6kxaaSYcS7RxEJF78WlTIO0me9ioDoZO?=
 =?us-ascii?Q?l/LWvqauy8UVfzjsuciuOckTF7QwiqEwYFNVMvPOOu82XhaVGo1RaURRIQIo?=
 =?us-ascii?Q?yvrrfVz1Exj1LgSocsN75LqAjTWOABe39fIp/ItIgVdSLa/PIU5EUSitS/FY?=
 =?us-ascii?Q?3+4TZWmHPFR3l4h6LOTCKdESbiW+aaS5SJJwFt7g9ldP13opfK1K7oAwFUCT?=
 =?us-ascii?Q?vkeg+0jg4YI7egA29yzf6Nkln1Z6xCRTV+uNzAZpMTWFvZFWm6rhJDzaOOlw?=
 =?us-ascii?Q?5XQW1aqls4AzPKWAWsciKImdGnZKtOW6qBbnZlz592lYgRqvNPCxmuqzg/J/?=
 =?us-ascii?Q?slQc/yZhrwopYWCm2ti6INuEkbGAGYWdgTZkz/pj2JMqRVQ+Az7SjNgOAvm1?=
 =?us-ascii?Q?9qM3+oZYKLcZIno9PZwlQ55hVOZ3Qo169I1KDcjZxv7NipjBcZkZ4D3/tjII?=
 =?us-ascii?Q?jfgOuAkodFMvJljqyY+nAn5qLcaPpKWd7He2s2QprxG/QQrcoiIOo4oTZExT?=
 =?us-ascii?Q?bZURr3qHS+dRgcHkfKgZuaInJhi5oXfnr0ejzDP5QRCDMStijL3CNou+AKO8?=
 =?us-ascii?Q?zX9r6rsACQmtY4LDjwCeW/RtDWvVclMFQaH8Nhzge5aWQ8UCZtps9i/ot272?=
 =?us-ascii?Q?F3s1NbPecvuKqpAWTwKIoRPZuCCpR9phPBbJHHZbR25vDCxLCkhIHqLjc0ZU?=
 =?us-ascii?Q?I1p1RTbwrWZWfIc3nZLVzDgbyNVHTLcnL5h9+AyWvJZqCrJCudtM1dLZrofU?=
 =?us-ascii?Q?VpK1l2Fyw8nq1x1sNLxUik316tVvfjANUpP9rirZhXhCkmVCIF52ScitH4P7?=
 =?us-ascii?Q?b/2mdlAAaiigAy8mOYN0O/4pjOgTX4CKjcbBKCKJz5gxDmgph1PfaHka6Q6R?=
 =?us-ascii?Q?2nsQhGcLk/klXGwCDJ/Vzaqk/UFwjIGCBnWtHSXwYU+kf91I1Uy2NcsyeXgT?=
 =?us-ascii?Q?7Ru6kg/MZ2AzYoM21XBB1LrtMwER66QyOLUVhhKnPLybxIv7sx5SUWBjoMHz?=
 =?us-ascii?Q?GwgRpjAOf9JEg7aD4hICZ2q3c3b7MqVkmlHQxhwK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Qa2rslkFU+kV8afDTaieO/4j6UeQPFIz65MMnMfXsOvDHIarLvNZn2cktlWLNcuMWP1Nb+z24MOruxjXqzRYzQPYOb5cAPDAFtXlBh6xhLidrlNXASZtnwKbYBPQhA2DPCGq0r+EQlJ+/oQGOSdXrJGRqUCggnvWo1UWxR7uOdvURLH7+3XBAar7BV3NX/2lGQiZLr/bWd1w+P53BhAExbHH/FLo6+ypoKjXLEbGjeF8JM+lfIZc2VXLgzJVYRsJWJdQn/G/rF0lmKeOmBaCQ9E9E3vd1BWiyRaVwu/Ldynb6EDsovQ2d4wDLzxE/xYqHxCw/u426nGczRX41cp8woJkdWy7U0Kr1FxnBXudcXWbTBWDaM4nD04FZIPblY1R+1485EANXIGYixMJhN6jxTgox6pHeqnhMT3jbnvGRGuvSGOs6YBFW1ylAXVyLSa27CfFVRRFpKTfbPZchIofjHTCuwmCNvh0I6Zq+7Nvxie8aZwZoEgb/eOJpuf9KMnjnDw7q2NQJPXdYwyJY/OfrubSvOmEm9SQSKxiZFCj6UM8Lh50DKRhIAYBe55FCbty6pEp1Mh90qQgg4HepLr5ti+DK71ys3IKKdt/OeHN6jU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed8e3448-e9c8-44fa-5edc-08dde485c1d4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 09:48:49.6191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jr2rRCJabxj++IVizSh+60gPPaaJW9u0SMyQXp2jfSoQUDklitUew4Et1n32Rhs2TGPG3ImIHzF2WPuqpJu+mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7526
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260086
X-Proofpoint-GUID: doWImlBVu6KeE7r1o0EtXcL-4GL0qt82
X-Proofpoint-ORIG-GUID: doWImlBVu6KeE7r1o0EtXcL-4GL0qt82
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68ad830a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=uCcDdxjXjMYOMFSq4eYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX+8l8P+ohRtGc
 LNcJqudckgKDgsM4861Y5GNQGkoDbmNnINtLtrz5KWV/DDyKgr6b/nhHc4Sj4r99zYylHiQKYkC
 YJh8QhDtZTCpytaoaXppvi/jtq4mupQKNNlKyplsZq5z0dbK6eYAnueQXSn91ciECWSslZiu2YW
 xsDvSZZpt/nCnhrfA3AOCv/agBojbOODsWxNH7MxMMa7ySpJYo+q57TqH93Mdw/FN4dXZcgXhmz
 QaYEg6XbcZTvCYvp/lTUrNQfuK9bTJG9ug4zXd9CU3Ur41kGLoKw+6RiXHXGKeb1G7QD3L4IzrR
 +/CRK6B3pwlobqDm89xX03DUzxB1I9gdBKOglvPTVbKaS8GuuawcB3RtBy4ZaBVTfmYg2NFLlLT
 vWhHa2C1
X-Stat-Signature: 4u59kdgq7iskjgf8hsddseenzwrzohdj
X-Rspam-User: 
X-Rspamd-Queue-Id: 5816C180014
X-Rspamd-Server: rspam05
X-HE-Tag: 1756201743-908225
X-HE-Meta: U2FsdGVkX19/pmId6hgbwG57vGVT2BRq97DOoikdIi9DxxvpIQF5TkS8Lbm20hx5EFg0B8u1L9lfBdulnaJax5Q3VZnwsb8LwnvMs3BTbUgnrG5o2NWOYq+UafxasXzq0tZCSBjmLMzmRw25XVoDNVqs7w2OBHFndj6fg2FQ6Iaanzpmo/c+OujE1VCpwjYjzWnPqg/YLqw/ex4tTHTQrt3d1bQ4XR+2bpbE7fRQb6h12OucUNR/CXUf2mZBUzuBIKmATgCbUgoXHYK+NxH/yrmKovWDamxF3kWUveRXd7aNXflk3j4Qmf/+9AB5JbLV4Lrgof5mJFKcvAKMn0PcUMKT2GfLVw1PbQjje3y6ag4VYGU7z2FkSxQ7Fzf/dkdU5TSttoJ5YknMCfNC6PYN7whkk9h3i0KfX40YAzzrFGn/cy53NbyHLVAhVzLiSt17+feEQlJ/Y7Fii2fr5F8aN9u72GlYgQ/LX4o+UGxVqLZp7wpwSXqsKieWei6aLG6cWwUkrjmXVSSHVTz+lswJ4RgdECYXDRnt7iwI5AaQNccsvpXGBZRHDFzUbbJ3Si0JJWyIwvelQ2K1oxl/dQwaZOjB2VhJQ9mI75uYztT6nQtciqj+53+014D5S5jBeibHE0b1y0tLifikgIn14TvEoEFSFST5wJD1sFcVD/swR68iCC6aT8FyZZ1Q0ezmghb+B4u042b/e1QVp2rPtuFfKgsIZBFvt+Htcqnvm+D56b00YoAXUkAlhOUzlInNOuEkOM7UjYeDJYXhDPJFsYQRAthe8KzhZvociSdD8pXPqt/5GkoW4Xqs71z3Gd2qTCoVz3y79bGlL101KKVYaXrltJStFcXnYZ4ZOycfAY1D5fJ0Lv/AepK03eFFArE8SHsbEFpymrCwNbCO2O/lOJdjXpAx112diPRKxicqXqddHJlgs6oNqYfFBEM3sRQFRK3aXwddwV4NpYtLVVQzRYk
 5CT1z+OE
 fYToK/Ykp4nICGjySCswUfDgxXrGyWpJhpmGbFpJT1vSRQmjv5/1+cevjBvpshRGZBPf096NHZRWx/epwH9hVsP/ltR8AZ8T4yy+ibWaRCAromuuNs6vz7As58sKjZeHOe0UuW6dgLIOi+IzLXM7qQrhYAGcmc6j9gRsbxl8t9Ho75UsF1d33yXkJnMYn9P9nZ+ENrOs9yPhBoP/j/1ikxwojwqZBBhmOPKAbQMcKzPc+xYLrL7wtRzt6xdwgcA8zLx0U1GbDUaz51c0YxXXZUOxNx8aq45H+NUl4cNFJPucPH6aPvpF6AWXDTY58dpv9fB14ztw3/C3YzJGLHHhyYZf0u12E7LnyLGSLUHJr0TabnxDrI+y2TKA974LMTQzyUu7AqmId49NVV8JYNndYCZ8+1SFxNIPSRNZUv+X1PkuFoSCfXxfXQNbqTJdWGXgQrj//ZEgOqWjBBw7fzxa0a9QZ5nhO8Xi6HS0IbfD6ig6uadsI1IAHPRjs3sxWRO4qicHosoyGTzVdiA9SqN5/c7PXl7HEojM4UOEzRHKrn6U9Nv6MS/+PGQaB0/jE/HC8JMCuJ1Mg+LbtpmnYeWAGVwT08lbQKPEbGrEhGtGwYVYYuBiSl+aXMff3pd4QYTBV5RUrEP+2J3+e2MrCWxFpCoG3EHSu2iG87XYhaxL0f7qMgBFMY+T0lyCDz0AjJy47LI3QYQaYyf8ZS+FMCQt49iL11hYtHuSIftpURQA/CPl6lhKVvtFfYDaySw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 09:37:23AM +0100, Lorenzo Stoakes wrote:
> Harry - one brief very nitty note - could you do a cover letter even for 2 patch
> series?
> 
> This is a subjective thing and literally just my taste but I prefer it :P
> obviously this is optional as a result, but I feel it's neater.
>

No problem! will do cover letter from next time.

> On Tue, Aug 26, 2025 at 01:22:03AM -0600, Jonathan Corbet wrote:
> > Harry Yoo <harry.yoo@oracle.com> writes:
> >
> > > While move_ptes() has a comment explaining why rmap locks are needed,
> > > Documentation/mm/process_addrs.rst does not. Without being aware of that
> > > comment, I spent hours figuring out how things could go wrong and why,
> > > in some cases, rmap locks can be safely skipped.
> > >
> > > Add a more comprehensive explanation to the documentation to save time
> > > for others.
> > >
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  Documentation/mm/process_addrs.rst | 32 ++++++++++++++++++++++++++++++
> > >  1 file changed, 32 insertions(+)
> > >
> > > diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> > > index be49e2a269e4..ee7c0dba339e 100644
> > > --- a/Documentation/mm/process_addrs.rst
> > > +++ b/Documentation/mm/process_addrs.rst
> > > @@ -744,6 +744,38 @@ You can observe this in the :c:func:`!mremap` implementation in the functions
> > >  :c:func:`!take_rmap_locks` and :c:func:`!drop_rmap_locks` which perform the rmap
> > >  side of lock acquisition, invoked ultimately by :c:func:`!move_page_tables`.
> > >
> > > +.. note:: If :c:func:`!mremap()` -> :c:func:`!move_ptes()` does not take rmap
> > > +          locks, :c:func:`!rmap_walk()` may miss a pte for the folio.
> > > +
> > > +          The problematic sequence is as follows:
> >
> > Please don't use :c:func: - just write function() and all the right
> > things will happen.  (For extra credit, fix the existing usages :)

Hi Jonathan and Lorenzo,

**blaming myself for thinking**
"Hmmm it's already there, it should be fine to use it..."

> Yeah sorry Jon on latter bit, I did mean to get to that but workload
> been... well you can see on lore :P
> 
> I have a real backlog even more than usual right now too due to daring to take a
> day off on a national holiday here in the UK :))
> 
> Harry - more than happy for you to do the above as part of this series or
> separately, will sling you some tags accordingly.

Okay, I'll do as a part of the series (process_addrs.rst and memory-model.rst).

> If you're not already doing it (expect you are) you can generate docs via:
> 
> make SPHINXDIRS=mm htmldocs
> 
> Then get access to generated HTML in a browser locally in Documentation/output/

Thanks and yeah I'm doing it! :)

> >
> > Thanks,
> >
> > jon
> 
> Cheers, Lorenzo

-- 
Cheers,
Harry / Hyeonggon

