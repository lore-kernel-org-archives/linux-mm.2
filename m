Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF8FCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51CCC8E000D; Fri, 29 Aug 2025 11:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F38C8E0001; Fri, 29 Aug 2025 11:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB0C8E000D; Fri, 29 Aug 2025 11:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 284528E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:39:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1C1785728
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:39:43 +0000 (UTC)
X-FDA: 83830205046.15.B283AB9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 49DA2100012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:39:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oO0G1Uhz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="jdJ5/WVE";
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756481980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84bG7QzQO9JtxmZ5Tn918earlX5t6wmMhPRUoAfiq8g=;
	b=VouW/KYhRQTTxSIp4A6T53qlxX/wk6WMDbs84i963+SxErMd92XH2odtdz6ty9cf14m0UU
	izRvYIi9HCAIFlWpDlbGi3vk5urkX/6kmPby4bIwiKb8W9rnT9GS+C9KGyHK2lmKxOMJZY
	q+eTuJR1jtHHzsA4HyM7QI2O5tSAx/U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756481980; a=rsa-sha256;
	cv=pass;
	b=Mdfaud/SML2vClMbG92zCwhGasPgGzZ1mT6WcgC1nlcVO9hGH6vM1y8G7IyYa53+i7ErXy
	MKjzL+cQlGdrWvxVTN+A8cTNlK+nZSDBRWOJkNrioubQz919qqbwTT/pn0T/JwC2+Zfhy8
	kR9r2UA1+eOJ2hc6xS3QZqKKflloPyE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oO0G1Uhz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="jdJ5/WVE";
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEuLxd007073;
	Fri, 29 Aug 2025 15:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=84bG7QzQO9JtxmZ5Tn
	918earlX5t6wmMhPRUoAfiq8g=; b=oO0G1Uhz1L0GIBjM/ebhitFJKawXHJHcK8
	C+YQ0GBZO1EJnoktxJUf0Hg1weM3X+qgJpozhoFJrK3pguCzK7B0ULc0CoX9xFFl
	2UCsoNzGMb2rNbCG7A/mtxV8M1UzMtzq6nmJfkSfngNXmXNXZdCRoQLnC/Co1Cfn
	8fM20M2EiaMN0PPiRmzs8Wxc90YPBkoxpy7pov/WeXnpuU+1uWKQoT+VkzK1foEK
	eGTzJBAFeu2uoeXf8A0u8nrieLWGtSZt1fTIJu4MHRKCp3logxeiYYoxg9DZyfFs
	iz30HUcFRz5dU4QsPy7ue7gjr7RBVG51bZ7CHRLhTaxz6nofI28g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e2av3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:39:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEcoAl005138;
	Fri, 29 Aug 2025 15:39:28 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012022.outbound.protection.outlook.com [40.93.195.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8dhnpx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:39:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CWM+O3pDBp7trAYkRYtfMGDSFX7PmjeC6kWBwpQ2GENjtGhEbb7kVib5HDLajpjZI6fQTv5CFLBfCF+HpXByDf+olHNtuFYqBUYOr3fatx8NIsWx6CBT/DXRlubtcNmF6Fx2uaJzn0wXlD3A/FiFFKxDW7gf3VTCNXzKSwclt3FXORTiWFyh84Bdw2cXukSafLHokqnmWyGEB0BsZ10gzLVLxoKeVJZY7bw0kAwPBueEN10jLyzlZ8RsuXEiZPBAKkewbJJyhNAcBq+a0ugHgWhm/CY3s5dx+XmgibAahv2uUvB80Mt9Tu4kORQRKPrTCRfWG1ZtVO4gsAccb3jMFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84bG7QzQO9JtxmZ5Tn918earlX5t6wmMhPRUoAfiq8g=;
 b=s3zqQA4iS75o/5DdgklfpVXhIhbGx8eH+0lU2h3l2p20MU4AqKtc1kYj8BJ1KgkSXnbVb/BBQzj4RvHjqq5OOH1PeHMZQI+5NRe60YZPEWSGxhXRdWx7kgjZ3v399Bg4tulYCTkf3/7INS2CQjReGPCGtTG/Sc38ZMpboxgWM7FrwnTBN+A4MYNWfFvl7uWSQ5kTNzAgUPO6OonHbbsWyIs49MChoMzDN1nr8Xg7i08cUJ2DrCgHlT7nYj5oHa8j6wKqArzpgquxT0STnt9SWn5+xV/GyRlo5hKURKvOzdXpzPkLi9U6EpGf9hIjnXBq4inDTIDX5Zrb4kih7OgrbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84bG7QzQO9JtxmZ5Tn918earlX5t6wmMhPRUoAfiq8g=;
 b=jdJ5/WVEKHu1VwIq5dChx9Ar9Q3vNm2yRI5/ifBwyv1R05/7g2KGMGy4icd6pXBjJff8qJ+bSGNigCwFFBUSU2JyjZR0cFFUiDpb1j56Ybz5GWxtH3TFGO5yleFk7LhBHjx1pbulrvZ4OA3K8aqNdPBcbc1lBVzo8W5A9HQyNB0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB7694.namprd10.prod.outlook.com (2603:10b6:510:2e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 15:39:21 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 15:39:21 +0000
Date: Fri, 29 Aug 2025 11:39:15 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] fork: check charging success before zeroing stack
Message-ID: <f6gjouakla3aivcersitnmlmcjel3kl5w3ynatq6qgmpcyddke@pzu2l3m3vmlk>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250829-fork-cleanups-for-dynstack-v1-0-3bbaadce1f00@linaro.org>
 <20250829-fork-cleanups-for-dynstack-v1-1-3bbaadce1f00@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829-fork-cleanups-for-dynstack-v1-1-3bbaadce1f00@linaro.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB7694:EE_
X-MS-Office365-Filtering-Correlation-Id: ea00c172-0019-479c-0227-08dde712390c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TV8/vFlYhZR6IIvqUiZKGw4mx/dF0RJH7/RLTwTNWz50dU9zsF8qmipoLeZX?=
 =?us-ascii?Q?hgOSDqeCz4MrQssjJExVWeOeAL/ctdP1wo0nrJFBKWcz7X0Bd3RO0gv5VW9Y?=
 =?us-ascii?Q?fq3K8x+gqIqqjG8jsUSpAzcoH2KNAlKA714KHXk2ze9UqOJK2HNtJsZ01au9?=
 =?us-ascii?Q?Gfsp6w+j7unFqrIfiXMAL8aj8jujTB8dgtZ7ZlPQhg/1U46ELhltyxFIXK2y?=
 =?us-ascii?Q?uLdQCch5G7pl6gEgPv+fQYr8u5kqK7naZoIoMOBsha1Ltc/GYeNKMVW1gU+D?=
 =?us-ascii?Q?RmdqI8g2qRMZ6a/7WoXoKjYD3OtVLmdkk68XzlouINauquBzylyRTWp2mYNz?=
 =?us-ascii?Q?5/taIHs8TBB0wOtvQeTMVh68r7cizqCjX3FKO6vVVXhCcnm10Js8uw+UUtXi?=
 =?us-ascii?Q?A/fkUUOJpjgsAWl4m1Nggs7xHnYlfqpllR03Xvei0S1Ft75d2aFX7qiNAoD+?=
 =?us-ascii?Q?WMHlau7YAiUVd4WXM+sbPFmbYwcoD5xFgeDTwBAB0PRy3vlLmMMoCaX51bJE?=
 =?us-ascii?Q?c2IN7DY1MbpoB1Ql0eCrRSUiQLKs6cqYtA6keBGXsvoJgVhoZL6Yu24JK9s6?=
 =?us-ascii?Q?CaCnGj7e9uKA/Or+nJcCDWIHzYAo67VeYHM6C+wpMKGoNhs3VXu7txlv9gHY?=
 =?us-ascii?Q?+u5bms6bCF6c5GQGDLP+hTs0WJLDYFQUURZtJvApjJt9BfrOc3NPbTkvCiAv?=
 =?us-ascii?Q?i9ap6lifqipz7W0Xftj27IpdEphcawu50LM1YQ13jJKDvCWJFLWLBLHtKLiz?=
 =?us-ascii?Q?fYQ1z1n96GcSENXzkLkV/Vq63IhwOAgxCyJZwWd6YrJ95xA8ysfW2WObDaNK?=
 =?us-ascii?Q?gJoRYk8keSAAZc6RSJi7lQnnx1rRYZukK0T/MNUaQ8WiOiznim3vEoQ7Gi8s?=
 =?us-ascii?Q?cfTgHN0rlftyHo2mg+zNoHxfiBus+TM/PbtORZi3rVCJnYOPeFmp7S8onjRQ?=
 =?us-ascii?Q?Gt8kvgTWpfi6uLygY+psiSSDKQ0h+GGp0ULChIN9m56hnf1beWupDdQ40R2p?=
 =?us-ascii?Q?/DBRKn/kH2vp79oKpGRX79XnSKHokwwt67DOpcoMHhHx+g0heHq+je7xi0m/?=
 =?us-ascii?Q?MgYSDyllXf3n29TzHwdMF/OyIK0RWZavLyshNqJZ/TShuAZXE7ezgKZW1C5r?=
 =?us-ascii?Q?i5LUU7rzRMF3YwmihT1VWiLC6MIRyOsv+DsUR5JhAPdU7Lb5bzpkUeF/mUwh?=
 =?us-ascii?Q?czk12ifs4GVZa5siwWCtTjo2JbKYo1MbaZjKmbsm9A4Mjl2F6hgu5OYbvxUY?=
 =?us-ascii?Q?2esZm6yTcZ9TSauFcHvuCRFPNyBoM2x51aAiUXnAkXQL61t3j6ukUD095QKn?=
 =?us-ascii?Q?SNJdutijjniBVS69m+imedWA/t6Vbvg/n3f/7nvXZvVFSHLnuexQyrpIq9zY?=
 =?us-ascii?Q?F+K9wew7jxpQRnjLDxCapMeu618x7i6Ng0SLmjEXTMqZkAIT/TYFo4qDuP7y?=
 =?us-ascii?Q?zqB5mJFjrmY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ra6a6fYG6bi40MAAOvC/LT5Ho5iqdZXbRkSon38OtULQVww/TBmEBDbC1sbT?=
 =?us-ascii?Q?mZeaZOp25GgYXH7tzYQKyxHIbOtQ7+k53oej6uHbUheGgMTE4elpWbnlvgYt?=
 =?us-ascii?Q?aVurrpHkHUBP7GEZSbqZQB+5rvHgeUVmVDx7eYxTv3hz1FukJ6o1geyX75ZT?=
 =?us-ascii?Q?cf8pAZT2k8n7q4ZGVbU/DAaLU81svkjNkSpDqM/sBkJpEkzNhhxL0A3+vlFq?=
 =?us-ascii?Q?r5QdQ05vJcsEZtWkBplvcrmD+BpVN7MpavcmwIYdOCYrHkX5XhX8DVUAm5t+?=
 =?us-ascii?Q?lryolQQfFruS0Gz621tFhXJdmB2787h9PVgWI4S31KAQVfpDzDEHTCPrIr7i?=
 =?us-ascii?Q?5SVSDTc1vgihauQOr/vfF79me2W89Nwuv1i4pbJ21k9X6/3QbyVHt8HsgXSh?=
 =?us-ascii?Q?YkBumRJ7qYJS9eWJZB/Zwbrvxks9G7YhUWKMhNu/3W4RABP8LLIGikhP0KWV?=
 =?us-ascii?Q?QMHhml0GQg2JLZ5RYZpYOr75ugxABjbcdOX1dCP6NY+X5RSWMyXpH/y3p8Hv?=
 =?us-ascii?Q?upyh/Zzchzvz+jZb+Mx86AdJVeLbFAFelzgBfqjlq41W2C3F4PYClCz5onde?=
 =?us-ascii?Q?Trkd28PLZswCaxSAuvwKIXSLcxSDTdsN8yCxNjwYEq2glbmzuENcWopRux59?=
 =?us-ascii?Q?1qoggw2Tmhi4CRwrQZGsZ/J+dM5m+d0Kyp3l+yiiH3PeTZtOz86BTc91vZ3m?=
 =?us-ascii?Q?MezpqJa/Ro/x8cDJV0N6zOMQezwQGaq1dGxgofDKTBwPtT1cNLAMdSvyb1Ep?=
 =?us-ascii?Q?mLSGTYmaB/un1xDTspL+1syxU3WkMFyuBWoDdVKwYBUlGDfPbEdXZwbIABvi?=
 =?us-ascii?Q?75lQ182aOCrISrfiJdLr2ajvJ8Oi0sBt+c5WeNiRU2CIalVpb8TRlYBE4KKJ?=
 =?us-ascii?Q?ADNhfL0/fQL/Zzwj8LjAvlMB7Pxy0SCbekutIQImOnJ6grnW/TN88ml/Ulqg?=
 =?us-ascii?Q?S5mP8yEG+q+y9Ht7F0UR2p3K9MZNZ3bhKBOwIiIVaAzP6eDDrZFl9Kjw3Gbs?=
 =?us-ascii?Q?S02C8lN0MgIMQ3Cizs3mZHHVHsYTHQ200FFhA8i5aSjm6Gwsy4+GvMPRekW8?=
 =?us-ascii?Q?0x06Lu/zMpv1ozZ3E7ccOQrbXwa/KiNMlYNvzoEs927RUKfWcFL9ETrGfhTD?=
 =?us-ascii?Q?z9f5b7pn3TJKdxB0imzcSNeaUGN0oJfDjO6XGd3cjz1sfwNaU4Ay0A+k4Ir/?=
 =?us-ascii?Q?3cYLxmdMR1ZfBjMcvC7myz94m1I0+AvVEQQ/l0SkblpqQq81USPMfxj7fr1o?=
 =?us-ascii?Q?TFepSShbno9368hQltUH8GLCxyy+7ZL3e4E3TFEcGSnyOEeqoHjpkBv1kkR/?=
 =?us-ascii?Q?55sTvSuqG36BkkoEysgPimQaVO81pJMkBCLFUVPgiibCZN3Kb3F7SUK5O9iO?=
 =?us-ascii?Q?GDq52eqrYIGaPDaiLeeqMelNsgJNN7lreQfkiz88PYop2L4HvUCcitCHOjvb?=
 =?us-ascii?Q?XfcrBl8YxqQYfrynvTpBVHHjCWeENq/VBjfDsSebPM+qt0m2HRAGLw3XMsHB?=
 =?us-ascii?Q?92SQSRSJ3d7TZmRDlruoaMTe8bKmjf/nSwRNjBhZ9ab6o6PwJPdrulSvryRi?=
 =?us-ascii?Q?MYOrFJ6UM9sbno4YAvFjagOd9+77Iu172hBy1JoHas5yf2wGstJX6f/Xv9fm?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tnuxSo23WFc0tiKOYTn1vvNQvIR1LiJWVvcPOIA5jAaiKcXqlRG+SSgsuHIV3hR1cBWwQnVmkGJ5NqwI+hzCop8CAoACz3eeXLuLQXm8Cjhk8/7WVG6mrPhQdu+tIwf627ayCmnFzWZ+QwXLLDFDf765XYzbBNOXQi8FjolRRX4mYSkwPi6dgiSpYI9nG9dx9wu5rqRqdEfBHXINycAeIkssRiqRw0Lct0O78sYLmr0VDM281tcXYCK2cRUAzbX+3z9SRPen6DwxeNzop5E8weXoBvymGhS6w+eWqzoWY8HhGdaYFn/fZ/52T5uYwoA7HLiZGcgZ9LI5rjm0nunt0G2zhbivX/uO7mh0yaZjdTvL8i72GgjDaYEMGbZeEoNgjTEBVVKYpgAUE18FBSoOdVEc7yF1+mJv29yENQgMbDEE8WHJvYLTX0LGid049NJSbhWGd2Ita7YCpXC/SQNdQFg+v60xRHsywsKVGMWh6NyRj6XZMYqr5o4waXjJWT5t+ydrpN1aWbph3rGdAegIP2zAJnpf2ty80hTQMb0Zs5wwfLKIzvPvjFJzWAjBehFeS+WDrd2btqK8+P2G6YWzvRH8lX8+46d8uRO1ZR3qYfg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea00c172-0019-479c-0227-08dde712390c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 15:39:21.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQrT02fJAqmketRqMyryLamiWSdbADtPil9I/3rugL9NJTDIr/LV4jgVwUnFxTqHe7Aops5/HBVwBFJ8LyeO7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7694
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfXz87xBNIytZZS
 w2ldocNCxaNn9tHm3/D9FIDcYoU/WSz+oyWrYV6RbywgJiXTNH5zQc1WLODl+BbzITBPVMZ6oP0
 lKKNvU9hVhibcC3m5ahitDD0kIjdRBc8fuUAbQrKU6wI+JxxDpY6vSK3kQaqexjLI7FZG06Y48/
 FHQfHmYuzRdQWMNOX9D8YIJLKZrHeJPdOQA/GorVZWaQUkfPHHnyybkyAWo+JMW91S20cvOAUNd
 pWaCLcdlAQYcjYnwi3++q53iQbgulgRLySQpPHG5+H7uytCDkFKlnejMMH6C/g8jVWio4t2FgYn
 YfR5JTK58TGuybHHfr8SYpKCpC1JxcWP0vf/xd1z5+8Kdz/Yv18yHsg4Z8HU/X0yrzM4ZgKmobV
 9M596A1RKCfHS4cu+0PQVRT/8y6vhw==
X-Proofpoint-ORIG-GUID: Rsl3FKY7KWCLw6pj6Fdpm3e8UDniiswr
X-Proofpoint-GUID: Rsl3FKY7KWCLw6pj6Fdpm3e8UDniiswr
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b1c9b1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7ipKWUHlAAAA:8
 a=KKAkSRfTAAAA:8 a=yPCof4ZbAAAA:8 a=DI4D9awMbfM32L9KmjcA:9 a=CjuIK1q_8ugA:10
 a=gpc5p9EgBqZVLdJeV_V1:22 a=cvBusfyB2V15izCimMoJ:22 cc=ntf awl=host:12068
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49DA2100012
X-Stat-Signature: n3gefabtprf69nrepypkxotzz8dh4th9
X-HE-Tag: 1756481980-498463
X-HE-Meta: U2FsdGVkX19P9y4bJhhEBSZBThF1KiQZiRUt3r9/lB+A4g60UkgvS6GfEXh47/q5KpUqh9HeEGu9WfiMqaEqyX00h0BoQ2weA/Kmx40F7PIE1dL5hUKjJdhIjRhcTzobXEwIZoymKAmZXhlq8XRpRON4xazVHwkWiiMR07FABapVMH9sB0BTEAHGZOcHrD2Nw/r8vj2woOPcL6rn9OKCLL6Vda3lQpvOrTWxpkFN1CwtYyPkEINBhcPE5joo7S9m8WJQ8E6Jo/QdUBmEPNvdsQHmY1gzmfqd40nahGNu+7BHxFty6t9+pqI5fW3CJ/FZMOvaO8+lBvVvssWqWjRL8RqcMBC45KCiKPls9uq8xNhd+duCJXyVJ9Ffm1LKu6w/8gr1XlqF/OsIUvcUMwAR+iWOjStEJ8LGRCMuYzNFthzfQKXJu79zDeqAEQhZEiBC/S1IzGYuwB4RltqYepTiJ0nqS3HObUF8sCRd77Mt/gUFpYCaKarK8AYbJygeuAqV64T9i7ZVL9uHwZ7e/Q+u8FAjmWcAumQaC9elIR7QtsV1cZ2R/+DFmrAMqA8r635dtB8aI49GW04wbE3JrSMlRX3nFzHwdlVBSfnaLPR59rKyHlj8LLDOp7CMVmYt80GvOZFk+05RPMq6iDMc/hSCLB7IvGTY1ZMI8GCcqD0P7+tZr5v2JhPUX//OW1CG16aBtrRQDdpAZ31ppotGK8UVvwFcfNyjd9BQALQvmnaW7vygGNC9IYxHq83VS2fTjV/MVdfdujpg8gqyxFUFGaUSlaNjbhgKpSsfz/H0yTEKx8epQ2g9drppBA01p1N2raZ44R99OUnCTIjEC6XIr3WFWjLVldcBrIEdlnVA2fw5WQ+DtTn5zRUKkG67zXSZiGZJzMYY57PUwQW8pKyRusgXMal+7hrbJn/hbkphkSyBW4ES7eDuoAZRCKePk70OE3PX7+g/pY1LXuPFIWNF366
 J2FpYByy
 k2ElP0fnEs9ZN7omYb6SrmdV0OrxWUoV1Oqyko5KQmZuqjbyLwF+Xj8BHgRXces/deCIhsTbn+pRbYmLyR5rJejzOs9sJL2NatIaOKlugvrXXnnTaZo/k4db25nWHHm6i8yZMEFgH7n+N0xa8Ij0PtKG6j7eP0MHKzCAVL09SQPuj8aqE3PstFPrR6ORxJBjHKeZxOjeQYcgk4EGZTEzA38bzQ+XIl2zTvHc8VanxUCZukOvqxsgtEqQ9wCd+01fuJBIPqD137oUhZIFcSt/+eNOsKAoFdLG/F8FlxXnjvOanOhHg5GCS64pnTP8N0n0CiV1kyQnhnsP9axxZbdZeFiG/0h977Mv3cuzx6ikCdhfPS+2O+tLHM/DxvmkGqTbmePch49Jkju1YDX7knMQuMujuVEXhfOHojShd7wPYKRgw8NO76AkV2WGN6W4yg4QbMg/Fl2+xXqijewwyEDc9EADr9SYTW9zIbjK1Uu+yxpxzIYOZbDqF+vxVp6ONTBH530XkS+TzcLjCiZ4ieZIZ+EdCJAEAXMrSmU0jUmbedaLkbRiDc+j9vH9w7wb4DytFD2dIjoGuwkniQSbiX94JZpBNdMZVvJZ5xBAT8PTMAXZF5cgAVmFKxTICs7ofgsxCf5/LE/G46VNbRtVy/Jz6CZEO9QJDJ9ApobfOryxLMBjw91ybjlx4CkhVniMlQr0S5g1S0NchHN8F4YYW3SRBnxO1j8pqfY+ZX+MAW1/S8Y2PjkXLDiFtjZ5QKAZRALjGg8vAPp+5x8Rm3q7Iab35O9TnZFrMqsYOIUF6ljBjCkJ2INYaQiSQq7jbsqSqRuy/brNTbBUIKFUFWk4atLjFBNQsJ3Z3CZmcJqII+8tJ4OdyryGxa5SDDDWbfxbfFz0OuKR3xMwSh18gHVJ0UZXsYHnAp/w6TPebHfOj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Linus Walleij <linus.walleij@linaro.org> [250829 07:44]:
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> No need to do zero cached stack if memcg charge fails, so move the
> charging attempt before the memset operation.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Link: https://lore.kernel.org/20240311164638.2015063-6-pasha.tatashin@soleen.com
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>


Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  kernel/fork.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index af673856499dcaa35e135a9e8042ef28d5c5370d..2a5b7a5fa09b1f3a42473cf44a1316ec8b3b31d0 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -290,6 +290,11 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>  		if (!vm_area)
>  			continue;
>  
> +		if (memcg_charge_kernel_stack(vm_area)) {
> +			vfree(vm_area->addr);
> +			return -ENOMEM;
> +		}
> +
>  		/* Reset stack metadata. */
>  		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
>  
> @@ -298,11 +303,6 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>  		/* Clear stale pointers from reused stack. */
>  		memset(stack, 0, THREAD_SIZE);
>  
> -		if (memcg_charge_kernel_stack(vm_area)) {
> -			vfree(vm_area->addr);
> -			return -ENOMEM;
> -		}
> -
>  		tsk->stack_vm_area = vm_area;
>  		tsk->stack = stack;
>  		return 0;
> 
> -- 
> 2.50.1
> 

