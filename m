Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D1FECDC196
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A896B008A; Tue,  6 Jan 2026 08:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21A36B0093; Tue,  6 Jan 2026 08:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6A26B0095; Tue,  6 Jan 2026 08:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBDA46B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:01:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4AFA41AA55C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:01:29 +0000 (UTC)
X-FDA: 84301550298.02.5C4EF7A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 894B7A0023
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:01:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="eZ4mgZ/R";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dZttnwJN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767704485; a=rsa-sha256;
	cv=pass;
	b=2fJqC5M6wyRsboqkDp49Hna4xyAIW7eHvK111HVZV8djAJx14Eesa0OTm9SAsySy6hmNGJ
	+kiIJ+P+xVExVXj7lF8kCdqwe30vuv99kVmC8epLUkx89WZEMzULts5csMG7HJcortl6xw
	4Lx1yk51b9y3B5NOJdeAbg/kSD+gstE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="eZ4mgZ/R";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dZttnwJN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767704485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJMJkGOxmpo2fpFoZMEECBAlKTP9J8c9PwOHZo3Obag=;
	b=qDcjlb9oa7/iB764l0yOR98yFC8b8HwG5BTymw9MLkVIBIWqIVT5pfxRcCoOuZWWdHtwIG
	DKzZQlPD1tl+84iKgz79Flz7TmWIJyLNC+MnIFq++/EKReUoaUvYMaR1OC8i4XZ5DdrIrC
	YMHO9kuyj09P4jr4sw70NMdo7yzeW04=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606CF5BN068567;
	Tue, 6 Jan 2026 13:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TJMJkGOxmpo2fpFoZM
	EECBAlKTP9J8c9PwOHZo3Obag=; b=eZ4mgZ/R970Fk0OCwBCRJn689sEVhfqNVI
	kNPvwkIaC6wQTCGkKMLHt2WQgDQ/Xy9O/KgVVAOzvWX2ldIo7ZxqlPtZSCyJ9Qdf
	BDZFIffyAGc3M2DrqdbGO+4B5OJcwCXdQ+F1i94QRQQhYvxZAdjYh2DkIhti6Ay4
	kCSu97cIgpCnWkMfzdYriNeo5G3pSfXDvLkclmdNyFKQceR47SpvAPY4CXkC4gSg
	B+SmOJOXFDdYuzTUaeibLAzJR9JH7AirEnasHmnA+OaAC+mb6PeeVgDVx08GwVOZ
	trIHrzkQndlnXEg7z4i9LE1u0Q3ZKksXd6n/k0jJEEDB6ip5drGA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh27w01e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:01:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606CH4qw026763;
	Tue, 6 Jan 2026 13:01:17 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012063.outbound.protection.outlook.com [40.93.195.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8a3e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:01:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDgDsGwoEG6R/+icx6sRKPk5tNJV8AmFc0xxdH2Ll+iXRRoZZYPT2tAiE8y/w6U1ZkQrUsH6pj4OzradwBoTSyuUdWeEJnAcM+E/8s3k5b+aqegPPagQmsFbM0D/Lklz2RZKo/CcwxISssvFdCsI9eYkzH4zP81zk4OGDVv1qFIPn2KnHtA+zWsmq9quEUuz8fQX6/ifwTP69J9HPhXM0bhxvaHC9G4Tl28zgA+IpzGh1VHWvY0siGBNVfNp6+hylQGxl49T5vIuT2XLPC+8WqvDawHfM0EajNsVTdXzB+jRoKM6De+lyLK+aedo4VlBmeu+RCU3LY3gbd/eBMJEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJMJkGOxmpo2fpFoZMEECBAlKTP9J8c9PwOHZo3Obag=;
 b=ancYo3SNmMkWxTwXaPUwquEPezoetDLrWULsnW2mUkqrxe2rwi0/vZSJRlxjn0/IHIb6RDD8UTpwFMRNn2V0hDYtk4Mct4dTBu3u0MDJWWVEZFVBEAs3TrBZgymcZiY1aBe8d1Oxkw38NTJPFV7Z9/XE22WdrEJgA/HIgN0u3WGZXwUQe7tKLNrT/qDUgw8mL1KX/IXKAl0REOsS7NZwSa6t2uRMBd841znTCu0w1ibVLnHO7VoipxipJz9LVivi4GVk0+F1k6cfgUsrqMNqZDiZB6omVTTlaaTT670b8uGsePI8KdzlzpcmIZDWLc0DtOJg32MznNt53EGqA6H5TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJMJkGOxmpo2fpFoZMEECBAlKTP9J8c9PwOHZo3Obag=;
 b=dZttnwJNiB05FUdZghuXXXhzUgO4IMZeEYw7fKmCsAuq7TpEHajIYMe2bnyDcBtC2ZcAYyfUrMLdpH5BiDhbRP50ib6zb/UZZliBlIwHFOK5tP2CvOe5UOD9I3zBKYp06BVD6p+2h0vW+EHm+YeDhOik6oYUggN12XQiMexfPzQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5697.namprd10.prod.outlook.com (2603:10b6:510:130::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 13:01:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:01:13 +0000
Date: Tue, 6 Jan 2026 13:01:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <f5291639-042c-4ecb-8e7d-8d0fbc8b80ba@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
 <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
 <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com>
 <13c66c95-ca0d-4711-b755-676ec4066811@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13c66c95-ca0d-4711-b755-676ec4066811@lucifer.local>
X-ClientProxiedBy: LO3P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5697:EE_
X-MS-Office365-Filtering-Correlation-Id: b5b65d86-f811-493c-b9bd-08de4d23ab82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iXWnluUgldApFFS6nklgLc57QpK9WxfVulpkPPnzSJPlpCps94y5Tc6DrPBs?=
 =?us-ascii?Q?k8pDHYgSH7Mejm0sJ8V+Ke/YcoWMtHOl3WSn0hz3Ajg53OtrpSOEcL93KRU0?=
 =?us-ascii?Q?fdjfdU1BLuQaRHe1hbliveb1C1iMcJSw5zoVNSaXB4Xw6sdSQ7YiQUjqmSdo?=
 =?us-ascii?Q?DqiH8/1xebkMfh8L7dNX4sNj3k77iFD6HmndZkLjnDJuLrZ1dJaVKM/Uve4e?=
 =?us-ascii?Q?7aour3JpPtLDTa4jYAIxZtiD6TrDoxOZoc9+jIVPu0igeq20TlrmOVI8wA5x?=
 =?us-ascii?Q?ReQM71IVwx23+E4AZWAHPP6QRc8MTkVzG83Pl8iSaKS27tMeKiRtVPSRE8M2?=
 =?us-ascii?Q?LrcVzU1nS8P9BIwH+d/00VRGBWM+f27xml0acIodkDzpvpun8NpTHniRUczj?=
 =?us-ascii?Q?Kcd+hVTP4uW+Lv9Ca+02ty0VjJqd7bWZZKM0JUbRUh9z+da861FjyZeMHqS6?=
 =?us-ascii?Q?xuf3i4VnwcrbZITuaApTH+enj+ZZRmxzwd/FbkJ4U4zRcraN3CJ9irltIs6f?=
 =?us-ascii?Q?zOPd0TgPOGIWTxAAM0YvMoCst/LRvdeWYCoMJhYjEr4/XydV9oz1SNMLMd+3?=
 =?us-ascii?Q?+YwWfueYTVXpvqENOLfg/FWQoV5VdUp/PWtxLPsjQcUW9CST6smhFEXfQnas?=
 =?us-ascii?Q?LFMsdXiUujbqYCyAvKTm1gpPWmZwE4A6g6V4GqqHqtPp7SyxhjbZa1UuqZPI?=
 =?us-ascii?Q?JAaPR5gd9/PkoROkF+WRQBWbXWcYaPduZUik8ebSEb7FRiSGtcowUkSssXXu?=
 =?us-ascii?Q?W0A4OQnBZc8S8OwarsaRHJmHnpgu9PHJbvrBqx9DMAbC/4nyWaWhVufNuv0t?=
 =?us-ascii?Q?1f16cfPbQr8whK4+Lox9ZK/sz+D5oL1WGsytgayBOWoJl68vqnybPm4p5wM7?=
 =?us-ascii?Q?TERLcO9HThMLxPwpI+CNyayq7GuLkNJb4TEIAbvVpfegwskm9/TUMIywSR5L?=
 =?us-ascii?Q?lJZUFATO+bLchjacb/qj+dVlfEw5DDJRX8a3mx28QyI6SeThA83F99RLL6EH?=
 =?us-ascii?Q?tczcLjADSJVSW+LgY0hZVGwMvzJrFMs3Ru2h7a8JtREs6eEnVPwaU+DlGyQJ?=
 =?us-ascii?Q?pAotSgX8cojEQDvpvzRfL01WjewizL3PZomRGwZ29/H0+zU7JB3CTV90iTw2?=
 =?us-ascii?Q?bG3SDQ/y7Gu3sm9/f4P2yJR7YHBH20n3M2JOXxevx4RvLbXp6aAU+tqQwjNK?=
 =?us-ascii?Q?hUxidevxlXvnoyyrw3uGEc4Ytwe1204oizm8SyQU4XiusglLHjqb4EiO0jbU?=
 =?us-ascii?Q?RlYkHOfvhAAZiqJAe7B/M37fI+PxfhPsBaE9m9y9gFabI4UBPz5DOjnK0JfA?=
 =?us-ascii?Q?fhFQRYEElRguHvTnnnl06yMKd0qycM6q+dz0+UNaCFw8GlSck9h+CxTwh3Dm?=
 =?us-ascii?Q?eVZN4VwAK3a9NVsuZOuVahu/zUWyAIVHbdb+Ta0mMBrht8qF9QcOoIQ94rxV?=
 =?us-ascii?Q?dyhLIPIB1OlEQ9PAZTcEplshrymEfQIF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lz7FbJqhcXcZrzzAfixhJCX1lX4+6cJcRUE2TnOmOxZVxYq/AatoJqD22pZX?=
 =?us-ascii?Q?Fwy7WpUpAtCHhCWeOEavfMhf1FOAFW3GydvmIBDTIVWs4E/ZyRSL+on9egYT?=
 =?us-ascii?Q?2aLb22f7MR7JfP704jMsLlZp9RVYdpXn2gfDObagHIbOrYnR6soiQqrHndso?=
 =?us-ascii?Q?MOn6Ug2moWnyBsmD8lc3OU59IAaqzaOmjoF3+XAEpivB1eZscVUkQjTQIHSI?=
 =?us-ascii?Q?eDqwgEukqqB63+4CjkPqIyR/RYlEGfO8FFWr6qylMa//0PKMPrt1gAk5Xmaf?=
 =?us-ascii?Q?ren5Dfz6i9p5ryoj+QSDAbd7/e6gdD7TkoqNIDb/Sds7mQgIDzwsvjcN1UeQ?=
 =?us-ascii?Q?DJpRJElAHQMAnfslC6kfO4RV0bUJawDr1vNQ610SC0jiSklU1u7sGMNBcgph?=
 =?us-ascii?Q?VaZOnt8BlATnm3XOsWGnkmGhiu3OqTxXkZI1bdXweUMosGX97FkN00UxExCY?=
 =?us-ascii?Q?mIV/lGJr7UXZc9QQ5CeuDpyNSODB9RT9MZ+gE+svG9SsPRMLy8eoiYlgu77R?=
 =?us-ascii?Q?DVSH4PdVSeWoYUTPcKsmp1jI9+qgSqyyCFcCvl7DimWllMALNZmGCf77/5ve?=
 =?us-ascii?Q?tMkxmR8kbHx82l7EPALq7th4A7IzAM+igYqDjSv4XShJs/6npNJSjtHoa9EB?=
 =?us-ascii?Q?d/adh8MGFObRP7P9YYHlzesQ4FNXLJINg3dGOLEBKuBQj6PKrGj+zwWgpYo6?=
 =?us-ascii?Q?RS2peiIGgak+nlj7MrbZR5bvpPRxv6UpTjwJFuQ/2HIRmL5pG5EkzH+Ar4gZ?=
 =?us-ascii?Q?5J0tfxs7kuHANHR9fb1PL5I12txoOA5AIu2RMijWSMpMqO1cyLEdOHsq/Ve/?=
 =?us-ascii?Q?n7DjgWnxB96uZgKsunzPKsssapmCUoMYGchyFirKX02kpQkHfa5ahKmqFBQx?=
 =?us-ascii?Q?L/rqXZMhPgssW/7tyX/AGJNRIHBsf+nUGi2G6Sd7bnnykw3ZQXr+sVcQS/1O?=
 =?us-ascii?Q?QWBVZaAYcdUnrtzvenJ7JktBWgNea+s7obZPaFwltCVJLLKoBOBcv0GJifC8?=
 =?us-ascii?Q?F7P4zj+oSH0tzeiMMxsg+Cg4HdbhobwjPWzx7IwvLa5GQ/ksT/SODzqBXxw0?=
 =?us-ascii?Q?w1WjNd/Fr9OKXJBwVvvFQlXBad8q2AMg3+6VpU7n1QMqcz+0oqpJ90xek2O6?=
 =?us-ascii?Q?9rBFCNL7r1G7BwSdR+O7D2paUW6NRDt0oZxuF9nN+8VAgN2v0tnPPmOdtrO0?=
 =?us-ascii?Q?oW1pNeaVWWzAYE0UWkTLepMG4c0U8tOn4u+hjifkn0MyS5Gz02LkhUB2bvV/?=
 =?us-ascii?Q?35+7geNXeuolJtThEDgRyulHP0kYqtd6QXn53GFGk4ypwIBUB88nsY2hBlki?=
 =?us-ascii?Q?26sPj9EBUCXDFh0RvRKvoIKTKj2X6YNlth3K8TXheXnhokv6rQG7cT5NzCLa?=
 =?us-ascii?Q?QCR1LIalP3F2viVaFouKeLMsKuA3Nw0ex/hOWF/UBTZpkdZoAjzQFlLdpN/T?=
 =?us-ascii?Q?9oEm8Hycbtu+8/sHZvp7dUQvbksuvHJayeokB+40AwrwudKV2q72sG544hf7?=
 =?us-ascii?Q?3THmChDZ0/DWPWsLQantQBpbRgp2KkOgoyqtqk6tS0TT2YC1W7rEfX8ERoh2?=
 =?us-ascii?Q?WqdSszK+B5JHhMBkqELZGMulr+VCR0Ew38KsnsJMzHIwoUJVlHj5m5nTDNzy?=
 =?us-ascii?Q?dlI6UiMjvlHeQfhGStRtinR5Wjvi+/RFxjoqKFNSlYRpt4brdHIk8tuf0rYD?=
 =?us-ascii?Q?+8dIsBQ0ZaxRoePgj03Ii/80GVZ3ib8zD8+TeMAaEHJxxmSULCXvKKngVf48?=
 =?us-ascii?Q?rOoqPUu+ii+WPjnFHH9G67cZcC5TC90=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EUi3K+tt0BIjrEDxNgvGtkg8eGXDaBly1eU7h/OfOBwMZav6NUDvq/QjTe8c/xHmZz+CsTyOAsMd2IoD87a/SAeEiZdBkyrumh7sgrjheSPOAwYEkWIKY1Hx/dpLTeRJM1V0MWFtoZCmEYu8V8ROfNEIA51ANXNh+d+Iy1uyLlO/UIo6GiJoMkR61h1xRdLRZTgay1cG1u/e+NG3QZBvu00YSp63tppZWCd3OplJcClFGIsb2BCmobrq2axAryPuF35lYPNEIzhAEsQgeFvUGmdBg4SDpqrKz7L6KFdcWBq3suufYmvlEulGsfx0cHccoZ4A0W07nBq6QCsj3BFLZSMIalM/fFZUOGtMtNyERweJBKolW9zdtkMdJf+W2fmaBLQ8AQ7VplLN2wGose/CeobDky0/ayt8E35P7FWgFmUgMAQHLotoYe/OhlAXE6B0OjV+TJfkOeBrBRG/ezz8N+NNWi1PWKTsqgrFNaUAdQIlrDYmON32Hh2BDeDhqbkQLLyqeJ+dK1IV9JklLhAzp82trvyn629Jtx1NyfZ427xb9NAt3EZxNVm6tnP881C4jKgBzgONwL/WOD4iR8EzVTkLeFc2DRnoYBTOI+67uEg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b65d86-f811-493c-b9bd-08de4d23ab82
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:01:13.0625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tIQ06P60XPXZHbQaafq/MX+QE8EFPLKIuMN1xEwXDdZ7/yZtxV21FAC9SXZAeA9mb4fc6abzkv0Cm9NKxHQMjlRFAOKoNXSksDi1Q8gm5DM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5697
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=536 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060113
X-Authority-Analysis: v=2.4 cv=T/aBjvKQ c=1 sm=1 tr=0 ts=695d079e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=qe21HByt906zF0iqZiQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: DP6Etk-zP4HJAXUeFQSZ3Uikdz_5v5Pv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExMyBTYWx0ZWRfX2D8fNCTAbriG
 Yak7FHoOXp1bFiS9VzvNOuZMB8x2GWYMm1I8uAHEMYMI7N3qEXt1DOb0l2zN8xl5U6tGlbEFRNN
 4xsEyf4qC+T7bJs3FyPtKDv+i8wLyZfSBdHUxlAywaXeID1+jZ5U0D5RPnuDlDsZB2+Y7LKYBu0
 ON5AGbCwIuuNZtsolm9VHzl7IqqFT+m6W0MyQTyaGhaTOXeSzULpL2pKANp7bAxxdbnB3Zc7ORD
 GQxQ9n3dCLW2ngpTQJ2kGv4YT3pUqGALjmG1nk0VqytFg2bX1NoFrm8seVTGbqyNJtkcgsBm4D+
 1hnwsebAXQ4OktOOuOB+aLrgYHPEHZAu46DFmdu7ysIoBWVREum/NGrqajsLMOXn4Tq6LP6D+um
 aseSwKG6XlalfsxfszdaJZQK/N+qTI1pFEv6/eDvbLaA/wVMD2jyqUBOZeT03AjEg/5BO8y6xM6
 AeevoYs98xe+6/m8iMg==
X-Proofpoint-ORIG-GUID: DP6Etk-zP4HJAXUeFQSZ3Uikdz_5v5Pv
X-Rspam-User: 
X-Rspamd-Queue-Id: 894B7A0023
X-Rspamd-Server: rspam10
X-Stat-Signature: ap6uiz7au7qbrmk7um6czzn14986hpph
X-HE-Tag: 1767704485-722925
X-HE-Meta: U2FsdGVkX18V0+RuzJ8wy+bHvK8rgcb/h7uAKbgKgPj4H82trqlLf8uvzwLyTw75WKTdY1uPsgHlgi3SpCJMJfRR+od6Z1Hy4ONot0swqtXmTdDOErzL3ccsISxbOzv0WVuZHWYDHyqskZlMcpi6oPR35Xl0NPBD3sfI+4hobUOsCdlFaEroIzB/Jal8Hs2fX9cm6rL1aqKPhU7MwB6c48+c4ybk9jFJfVoviewW68CU79z6Tcr5Eug8XiSYodu32rHYxstmcgVgMKx7thMbJTFtqd5AjhrcdMS4udRsWMgVglhYwHVQOoPohBdrflB9wZ/SqtceJwSDGfPFKf3/8E0ORse0wtI1GdtEpFYlcqEqXtUfy3vDuFL8zAVStwZv+wtAwG/1XWC5dwRRJLOIss+2wPUB8cOiivzX37TPjhywrFTpLg4DxQUUxIaA1jmFKIqJJ5B/DmnKm+7S/QN6qE4oUZEGg9VjNxxDPi9mbVkpWfJFi2yuwKeOmLhk1g/85EmT7I0xC7E06Y1J3kMLrvHGDHj3XtNKLZlWCAgeK0fWCWwNhVantlg7KgKQ/KAeX2UlOe4lOevXhy58QXs1va40D6iT8AQLBWlGpGCJsjxIOUBIR0B9Z3HewmqVLNiutaWa5KAeyJaUig2FEuEGEvIPVGkhV4FoG8ixCjsL9eboxz/NFQZxFmBCh0a0KZsODx0xDkxzA7NwKrGSCniicGjLI+/syXebjv51PHycniQAkkdfLHZbTKfjr7OftZwqJd0XJl4jrL787utxbdArhNOzP6Jbt4R24GBgBWCyCzDVyJwDUJOFrlHTyLLqmlmUCyo5A8USgYcZ1mfQSRS6ySmYJzlAR/kL0uMyHLaLRj5xDuYdwp+3eTMg+2W/1+8fPX2WSnrxOomHU9Slrk6jaoPW/Cm2G4ZFfMn0HW3pdZuFzLXkiIwEqHwJ/wRC2v8K/jetLyNLVJhkwOjaBM+
 JojmRoRS
 rwiV9G6nA4XVBfwPsnTcHoI6vVdTxT+90pFXsS9mZwKT6LFsf251dJcFVcafOW+jlwDPKyoSJGZCpAvugapQmxcDvVKMqpTa+6PeuAQPWidUGJyZR4u0QCp9yVt3im6aUfUMl+F72ZohrlHmO6KJ2DMeGZx1Y718GsPZyYTQNNRw6DEPcxEeotCHgmjUFssbo0qxLLtkAc7GrEwmpbJ0kTLDllCm/BcTtbFgwu3PJJIepybDp+z6EymxTQTqc7C/x3pw3Wl0r16hAsK1/TuvmIpPRsYccJAtIc/z6MbkfsAuAtVtXFHt2p+E/1jdX5kvKSfh3Ag0mtm+qN+ANtyzpJPhdyPuMFXJy4y0eShK2tSN39moMQZYPH7oteI6zPS3wgrhKL4oEMLUElLkv0i5+DCpBg+NqhtoYiQZ+5PWh0wWxDjr6I1YdZ7C17ziPkw4SMWn42IRtTQ1LQZM//T9rY/JViHUdVTmeD7YU17FaIU9grQLtWh0JzoC7ZxLbdty0QNAWJmMEEg1iWHJiNGZPn15PF1ysVFZ+EcVjDfD8o6dngougbO0TwJho3amDoifdxaUtrODdWCnRT9KImWmJzIDfg9DZg1r8ivEfS/+uv5edbxzBbAFe6rBsoj6GsD/GtBkd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 12:54:17PM +0000, Lorenzo Stoakes wrote:
> > > > +     /* Unfaulted is a no-op. */
> > > > +     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> >
> > Hmm. anon_vma_clone() calls unlink_anon_vmas() after setting
> > dst->anon_vma=NULL in the enomem_failure path. This warning would
> > imply that in such case dst->anon_vma_chain is always non-empty. But I
> > don't think we can always expect that... What if the very first call
> > to anon_vma_chain_alloc() in anon_vma_clone()'s loop failed, I think
> > this would result in dst->anon_vma_chain being empty, no?
>
> OK well that's a good spot, though this is never going to actually happen in
> reality as an allocation failure here would really be 'too small to fail'.
>
> It's a pity we have to give up a completely sensible invariant because of
> terribly written code for an event that will never happen.
>
> But sure will drop this then, that's awful to have to do though :/

Actually let me just update the stupid hack exit path code to increment
anon_vma->num_active_vmas in this case, and do it that way (so
unlink_anon_vmas() drops it again).

That actually makes the whole thing _less_ of a hack as it really makes zero
sense for the anon_vma not to be specified but to be working through
vma->anon_vma_chain, and that's a very important invariant.

