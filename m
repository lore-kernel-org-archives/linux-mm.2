Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C31E5EA3F27
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 10:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC9F6B0005; Wed, 11 Feb 2026 05:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1857E6B0089; Wed, 11 Feb 2026 05:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032DA6B008A; Wed, 11 Feb 2026 05:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E67296B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:45:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97B991A0317
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:45:43 +0000 (UTC)
X-FDA: 84431844966.16.B1D69EF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4EDD2C000E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:45:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XBlfOWne;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SO01Nhnu;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770806740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPFRCMI8keKlNL3y8MwOSZzNwbHM/045SJJGxx8NlKY=;
	b=Qh8gQUhgQOb4psgu6sy3+wE8Vsp6z2GcfjxRXtur2RsKJ/tLY9rnNSg7/dMHGb7hrkzRyJ
	mL0Upb7dPzSBF/hasCbNVW3aGNepeaS6ieO1FE6eKeG5jgy/O9BtaviSMQRjkikqHUCHk/
	9BAviRP5XQ1M2WuUgNtqhnGIEHqrJoc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XBlfOWne;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SO01Nhnu;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770806740; a=rsa-sha256;
	cv=pass;
	b=3pY4jvqDT6NktI/GY9FbSYx+xVhdfv2OH1LczE+1ArdEz1H49XuhaEoz7ZEOAW6Zk9eXjk
	YP5FwyE1D5MYOknczELCTE4RMq/DiIVxRk5JacFM7xA6ds7ckMZHWUnziaruJxgEgKRIhO
	pNf6y8AxiN59zIfvoe+IJHrADxvw7NU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B9uori2124780;
	Wed, 11 Feb 2026 10:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vPFRCMI8keKlNL3y8M
	wOSZzNwbHM/045SJJGxx8NlKY=; b=XBlfOWneddaeEhyRHdY4be767OFkgrfpGL
	jb935iIjjQO3do9JgAr5uYyLfUPBLJadn9BCzQo4q2EhmhUgpIbyreF+Etmx7KY1
	J9mb7z49EKyxzpz9znG9bwXtmVoB3TYH1pFiVjsSHF2TV9bhWwYanBKWBfwedNjv
	1G5o1hNwteIqYyP/XBufNr34oL+XxdQ5QBgAPVSuxVRXf0yhtQG4snOCCPSnpqfj
	Ky8uZgzxZzTCO3DU8zAIw+60FJAYf7rmQGnR1Vg9s1TbTsE/OCsgv2x8SVvE6lOh
	ad1rL0oMHZ26ZnsoP1jyfnBGj9tcYLtLnnuzfbVKLH0b/LvzWCcA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7rxu2qwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 10:45:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61B8DeKV030039;
	Wed, 11 Feb 2026 10:45:17 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012006.outbound.protection.outlook.com [40.107.209.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8229dg8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 10:45:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6gzfBYmM+MmOP/uljhyJzRP45Zdg2FpHJ+3zhKdrLyXeFHaKCqwZjyBO26NnZtRuoSyVcWKr4Du3ED5t19KVy550xRss3Bgb/6GjCqOp3rLwumVRj6VaOYY55RiAXQZ+cAJy7Z9nQLiJpZm1CFWzzBD4J770MJ4x7YGruLJ30Z9F+reyOyGSiboMawkX1GcnU5ELJqY8yx3ihXABTvJCUIzoQqrCtlOobsemLfPQcPYA6ThyK5HPXGDLwL+YF1nr5negQWDlKRAnnJiMBOon7JjOuIV+sETYXYXdK5P1OZ3DsDlGMawANAreL/NoX04Gx5SstOpWfbmSHvQZ5y33Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPFRCMI8keKlNL3y8MwOSZzNwbHM/045SJJGxx8NlKY=;
 b=ISSzSK64GdH5Wvx6GBQaW/uWajmROVLm5gQ0G18dCylDz0+1p/8EOgadsPMqASCO9zF00yPwHcwZTvKsDJ9zmfE+DoWLAfMLeA3nBFwgS/Y61HvoYiRH9XeK3MeGKrgj2gVQtsz+0rWqifIqsYSNWvCyBBMEeBysCcSQDNkxJgw7G4/1bQFyJAh+kL2MXt1hKtPgmppXxavWL6XrpjAHeTFluELPQduKTmRrMG8iqlxpdr8t5WGXoNApjUEtgZw/XLlw1X9cEamg7/Fz+b+xgrbSd4SdF4fyHufh/ZLsiv3ClhhzpA84OTJOR9q46FaBE2vpDCyCiTqZuz84EjnocA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPFRCMI8keKlNL3y8MwOSZzNwbHM/045SJJGxx8NlKY=;
 b=SO01NhnuBm3hDGLyEXe6TcBC7cwhmmhmTRSfZsJ3RQIKXBl7HJg0N/7WhMDo/PpkaKyOh1QcF1SxH2aUEZf7QlfeKVknoR6katR6Lr9CdloofFnOV4c7CPpvH1a+kr0eVRWzUnhSo6CeCxrj5EXibTMvh0Orh4jyu1qbYVFzvZc=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 DS7PR10MB7155.namprd10.prod.outlook.com (2603:10b6:8:e0::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.10; Wed, 11 Feb 2026 10:45:14 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::81bc:4372:aeda:f71d%5]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 10:45:14 +0000
Date: Wed, 11 Feb 2026 19:44:37 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 1/7] mm/slab: introduce k[v]free_rcu() with struct
 rcu_ptr
Message-ID: <aYxdleYc7_TWj9To@hyeyoo>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-2-harry.yoo@oracle.com>
 <aYxXE6CC0XQr1KNK@milan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYxXE6CC0XQr1KNK@milan>
X-ClientProxiedBy: SL2PR03CA0007.apcprd03.prod.outlook.com
 (2603:1096:100:55::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|DS7PR10MB7155:EE_
X-MS-Office365-Filtering-Correlation-Id: e6639333-c10b-4c56-0fa0-08de695a9b3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f1IVNsGApxag8bNKA2poc09AxV2SCWSwmZGae6p4SzKqq+cx5FEvRe9wyIaw?=
 =?us-ascii?Q?L20u2NAx/jE9u+NGi2r3PzOMTVWUWJEDw5XQzukbWBJ1b0gwR3SlnWdQsiSL?=
 =?us-ascii?Q?/5X1HaQaug+yBRYWWC0kbZBF3ir8stC2fGfv71KzOfykyEkB2CxN1HCtZ8P7?=
 =?us-ascii?Q?Wu+y4K0ItLrIUURSnWcONycB/oK41qDoQ7v+xqUDQOVCKbyGUpS2SbpMcMIS?=
 =?us-ascii?Q?V0Jr4um6CMWvnnL/j9hLDfwp0I2jE1gE5eRWaJaY4vrlocaIbWJ+VYvNeYfM?=
 =?us-ascii?Q?fb7FzM27x8XYNb41p4QKROJN+sRlIlpfdKC4xq64a3m9mExjNjigA5Pi0Plk?=
 =?us-ascii?Q?azMA5rXexXaCX5g9Xb6YguqE3lS54W85youuvOnb9CyJom96Cu3Ozi0mPZ64?=
 =?us-ascii?Q?VRUsMm/ZGGDnYROgfijW5j6e3XFQvcUQZVM0SmfgIbvftfa1PUloVRDtQG0g?=
 =?us-ascii?Q?ZEHQfRErdWBC7+Esoge2eM++ilFZZjx3lEzsElDPitVk3MnDYPiM5wGk/o/x?=
 =?us-ascii?Q?nO48nbjQE/1zrW4stWK9w+Ov/8bXYjEMHsRkoznTU5X7JSnP5x/b/Xo0iwJb?=
 =?us-ascii?Q?Kqdgxm0iVhT2RyUm0sf6i+0McY5f69tQf8R/zezcoVYKSU5qaZICfw5poZiO?=
 =?us-ascii?Q?gQA3Y2WtnLzEBPHrxOFYlTXG+qU+dmQgZNi9mu1jHnNUQ70lavFMbKVineWr?=
 =?us-ascii?Q?U9T41QO5C+JYugpPamrmnbu/dCbj5Po9JCUpRLL34i6NHHG/sBJMDEs8hHzf?=
 =?us-ascii?Q?Ghwi/FtNcNXg5Obf0k4zOXCrZJJluQhXaq1qqiZPh6fg9+33+xE70QxknxZ4?=
 =?us-ascii?Q?QAiAccut68qUzC+G3imEl8bGkC95pSaYFaMyNQUW8NZkIcxVs/gmdRM4edcM?=
 =?us-ascii?Q?qdvAKJXBl9jYLrNf3Vsl+H/MccycxNlqtD4wFGhWleoWteVTWvxo4/frRgzX?=
 =?us-ascii?Q?b5n7lJv7riTZXXxAuKM6keR7ayutyyvlMa3lMHKKQXK/5HSRAc76wDU0BsXv?=
 =?us-ascii?Q?xmijABYTSzVgo6P9+dpifnUeTYxPCu+AG3oVz/cLIqrTCXoJ3XrYUyvOgLBI?=
 =?us-ascii?Q?C6kofxLsivHLkLfb2AjymAiFTBmKZHtVQjzlJs3reHCTcqOFTzV2JVBHPuj1?=
 =?us-ascii?Q?dzifdfT8KqgMNed5z1WpL89PFCU0rtTTCLriXjLLygRMPcyI8C6cgJ06K247?=
 =?us-ascii?Q?yOo8r/F3wjlE+Nek+28NRbwNZmlox+AnMyn6CFErvL50LYv+fn8ZUQ58HEFU?=
 =?us-ascii?Q?cgKI9B6P6X2dBqZJA+2sf7/wbYVsPAOzdYoBLf0xhILcr9wWVyQHbvZpfoy4?=
 =?us-ascii?Q?vQGtUJrjPtyKqrMHWeKRo/tuXhe0FNxafg21eD6emFbCPCqlBvQaiZYO91az?=
 =?us-ascii?Q?cHHkQA9cPzNaUuT9xOd2BY+okj+0bifCvQ2VPL0i23QuyCe9AChnPFghOati?=
 =?us-ascii?Q?iIPc1F1Tp1jGMnOUe/THrPaykxIzGCqgqfjzg4APTNrDzYIR48c+ZWRZguYP?=
 =?us-ascii?Q?jondaOaFeanQjQQztTwdyEaorQfND/98m2AuxhNYu4rG/o9elsOzEgbxFwS1?=
 =?us-ascii?Q?1SS8oefD5jGPWxosNeQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sh5WDXFgWARJFE/oQmmEdISUpxULUe7HZaoilG5V2wnhKVwD4pw/BwRuabbi?=
 =?us-ascii?Q?4JEkxkTs9k3Gu3Mj6zNFpS5e2IYdVxrMaE1pPlVVh9gFxinXhZ9I2rzi+yOb?=
 =?us-ascii?Q?l6RxXSZJ3HYvy9FPXWjIZ6S/g6W1yKIVjVG3xbjmyDMTJYge97AJR2QpfMbu?=
 =?us-ascii?Q?71lfE93j5VTXTUAQ3H867PbaijchwxL6dEE6xxKvbKu5JJgSA9uLDxFqPZxL?=
 =?us-ascii?Q?yjqobRwy8IqeZNGDrGLsen6NqphfAEZDQ24Zx5idfYpzZkujEGrPtHRHYYsq?=
 =?us-ascii?Q?JpL9arIglGcap7/ipy0BWpS88FLfq7vU4JvEGBxPpQCSn+GRp6FyaFLDJyoU?=
 =?us-ascii?Q?qFE8XPSGTyBjFAVBXRKZzNYm0LDvmxNmGVQdWrTd8rTaR4mWxNfHzKwAwyzt?=
 =?us-ascii?Q?Bn01f6PSx+c12MbYZdSAUucPwOvATjdIYE9JhSFelZrEwXhbGbE4lhZmJwa4?=
 =?us-ascii?Q?klxTAgn4Hxm5mGxRxz/dE6bmxTIjwrbHaVTuV7LhfXCL+yFUcHTmD5TUJOmt?=
 =?us-ascii?Q?nQsg7cWmJ+w5XhGjpaSngdu060BHfAtOhS/9tHTgVKyWdedu1DVNehpIplIV?=
 =?us-ascii?Q?5N7lVf0CRJ6vZqjoie4hFmhazAiFtjfi8w8o++W3T9QUz+YVHIVxigSSWwqe?=
 =?us-ascii?Q?S/2DO8cHACMebcr+as3Tn1Dw/tSiRa+uZTLvqqn65vAqZiaUKdHLNvVmI0HM?=
 =?us-ascii?Q?2BEJ9ctAi7Cd8oR+pJ25gq56U+9GuWuz6j9zxa4TpOlf4mutjWka8MUVvh2C?=
 =?us-ascii?Q?3HXcHLOW7hRG/2dMg9uEanAt4dZ62Goc6E5roSgef2jG50zZCJtRiKWcAt3x?=
 =?us-ascii?Q?8mhk2MMkwIuRKkJG9JQYf4inJIeeC5a/ojoSQHk/SUpkt5rUsA72krBwooHa?=
 =?us-ascii?Q?2+68n3C+/vJw76AWjblb/hCcTE+1ZBX1ZMkTqQKZ1e/GEqQemOdV3aLz3TYY?=
 =?us-ascii?Q?Lvs/b6GUdz9Tpb1z49+OnNrngz990tCUwtEajNgtcXQ+sUqD5L2aqJ5rDfVX?=
 =?us-ascii?Q?E92VMPbNZPC1xQjl5NaXou+oAnLZ0AO9e6YArFjCc1/lp+UHw8C9oMwt8sqd?=
 =?us-ascii?Q?RwE9PEEfN8r1WpHFit8Xc4z18lXaD56p8OgTh/VxH+0Hq+AtHuosBup0pB6x?=
 =?us-ascii?Q?JQsw7ILhai9uHKsM50YtSh8/QYtw0lnJRODhsaNdIBUUBY1WqOJwLrNY+WoW?=
 =?us-ascii?Q?a7qY5URkWPHRjB1WSHVlgxV8sMqd967FLQcWpHNEQsec6f3ecgNRZn7ev1dr?=
 =?us-ascii?Q?FH7om1WPKR7qlG44NsDOWeAU92n/p8Aw58SRwZTlt08WaP2bRtDISmpv3oTd?=
 =?us-ascii?Q?Rtbd7JLZdlppvw9ns6BX/kh7GQdx/939OBcrDQo/tWnZJHHrqDRPhXvdDQtc?=
 =?us-ascii?Q?ua9GaahaUZ3fUVbXTuxC0d/uixBgnvjBwLJGDG0a3+MMUFBnt+oZWV2ou42v?=
 =?us-ascii?Q?sLG66NJLfXrAQa6fxuAZUPyfBFgHqwyhFmLV0JAfqj1i7WWkIhZup77KWcHG?=
 =?us-ascii?Q?l+1/KM3nNgG+ApNWTHFY20gd5Bgaytrh7PPNs0OqjZ9tMBm44rJNqeLT4AL0?=
 =?us-ascii?Q?CnEfMIn4XNX6G5mBj/TOK8jNx2KiLQSsfGVDFt/XQY4TSC96vSf0wlPWV+Ws?=
 =?us-ascii?Q?1zVzbwxeXU+O2ydO/9xPQ1iqwWKloNZUQ9Ixt2gjYbIuuBessW1RHbHve6RI?=
 =?us-ascii?Q?D5eAtWvZPTcBGbSv/jqDKWXH0AkUWEin7FxD/GPiQawHdz0r2Gxtt9lxQSyl?=
 =?us-ascii?Q?OcSrjrbc1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zx3Y/SLWBZxxFknxKERDLY51MZdmF6nwvAUnwC329V3/kVBCQdwqOIJ9qwBd+fcnI29itkzUkxeVqGsPsQvKC49KsX/ZNy1VExp9chPjNXJj1ROGyU9t16JqdvouSxJ7OTfDdprkp0x29ujY3mpNBFdlcAQpEJnVTG+p0lDXHU+ftGQEsBPeLvD83vGtzHRL0zCH/Uw3rnoggiqF2/oqI6gUSFrA1wKQWoaZO2Jyb62V/ZzNFFey+ISOvF6DzeemxaLWhT4X4taZ68Qi44cFVHY2wXozewPKaLe1TYFV69I1PYsVQsrjq+IEgZJf1YnhenhXLaEco06wcD6bQaYJmYrVHOn5/zgIItjGKpO2F2rJM5WN4Oqyt7y1b7WFf1QJH2xZqP+BRHy488SCai94n/eKRrvbHGnjXq9YP5oaB6/hnweeaFJCuAbDx8HVFdZsy/t6qoLRKnK+mxE+lEbRs8/eh/K4YReg4MKy1ay78OKcav1SspOHpmz2ax8bSnvTkYz5UVUrku8sQMgJdOL1xslAKLSewg587M76ffWkku3k7t1Bt6gyQ7zzWyoQxZl7TTVERwYM46fXwJIN6Mw3ySLH6rlMIyLwG8Zks7TQxRc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6639333-c10b-4c56-0fa0-08de695a9b3b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 10:45:14.1895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZxQQdbkNR3my6IjRSWRXYcCfofl/RGJNfknB0RiF0jLmAAMt4QN9FmvRoWQEz5iqkPkUxkWUvRQ89f75MyQ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=790 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602110088
X-Proofpoint-GUID: 3k-hAd2sTjcTcsjMJpd4BjSUtdBJSCTP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA4OCBTYWx0ZWRfX7akFBcK3wikC
 u3nt83UWcXj6KvT506677tSq6HHv6mHSbKqKgYb+v+vg9uIZvFenOgF6arP9Ux3k/S4Aapif3RR
 7CpMya8RItywhG9wZ0wAAY4qlvMlHwN9K59N+KkNpbUuQb0L9koC0hP/xhpxfJmulirmWshl+2l
 v1EP8YZg3VZwfxVlKGbSE9f72TPoCKoG2p40GrLjtrNQOb8NIiHtPPayZN15DOckWssNlGmV9B8
 CNt382KCihm3Vlsel3cLx8LBoKL70GwpWXUKEikQYQnTG9hTFGIGxguFICeAuJRhoWrpxMqyRaJ
 ZgXH0r+8Ad8/UZl4KVsaaLNISZltpiw9E8+msAG/emLZejAsLOWXgbVkazyWajEsLzO1+uWenVH
 5d/fuVSfeZYCwdND4EO22iTtXXmL0E7SyhXNN/zgSbql+WG+Q/TVBOMA/qcHjlCtWohNw9nyS5w
 U6vqP8Lf1EX8cygYX3g==
X-Proofpoint-ORIG-GUID: 3k-hAd2sTjcTcsjMJpd4BjSUtdBJSCTP
X-Authority-Analysis: v=2.4 cv=Y6f1cxeN c=1 sm=1 tr=0 ts=698c5dbe cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=MO3VOf5dGC1ijp0DBRYA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4EDD2C000E
X-Stat-Signature: x1rniz6xpgxb35k79rojiu8rxk6jm6zw
X-Rspam-User: 
X-HE-Tag: 1770806740-975983
X-HE-Meta: U2FsdGVkX19DgstI/4PiHNsnxdMeqsho078iEAxFSQ/qjGEzM2LeXcssYuutd2IIjzSV43R/WczfcU/wpwgl2ZQa4x6vF8V2zckJlp+2+NXAhNTvm4LOhtm3qDQANr5BlhncFjQS/fGWKU6bHgZVQ15Wg6qu1+uws0psJhZnReCLe2awU78li8eYkljiuOR0dwnl3mNt7VRoacZmhG/Tnyv5CyGhQmrkwa7iW7PwPdaeB4ul7TurxJzmr3mh7PKMNH7mHdYHhjQ2rF5TBpdsGXnSmn4AbaO2jH6XLCZgsRJPCphrKEc09/tMcJLbJDMVIovkkjOiJYfVArW3FyGpQQNQVZc050dNsn1QbMah2ikex2KCn4Gz28muuH9NzsnzV8KzOVShp56z547BTvObPObh71AfQaF6Fk4kK0nb8G8opH2f5swSC1iIwUwnIg3aCrbzTv8lC5G1X2o9cUqV1nI9Hu+sEFf8qD3naYATA4hfwsbidl9UwjFzoZ5AzEJ9G/imorDa0RBAzIKhPw0wjvlFSvKgwImGhke3Jy0vbdF9uOpG7pWW1A16/9m2aR0/29PuJT7ckomW8IBuPFhirI6zzuD1hDGX7+JPMrouRIAOrB8EuBW6/2ZbPUhytvejS0+eFm5w6XTeIu9AagWJ0iW3gX9GGJ4Kr72y7KoRJLJuWeG0XYU+FaUzAJOlN/tQZHR1BT23oI5b8fQWXYJ8/ZpA7jK6TatOzZNGz9B3+xMrzCI4szeBcJyY+bDiYqZFQTZGNOC/tO8RR/5Ev+ACFUaHa+HCralASXc6cFo7WLhKUijmUt4avuvW8TBw0AHy8NTKn4+gpv9nUBj5PdGEbSjWfz1iplMVEBVrSGBcy2+HQcssKVuOOVqwZ1GlY/iZeKR+/avcbFANIeGFQL14agSwFI9CSSaS/L5NBIkR6H5FGKHhp7F33jmkAtLp8HBaLZ6qo6XiIWFBsA1UO6+
 AppT2r8s
 2iQylep6+DLkEr0uGi/4uglJjh4Sl+oAuBV+Lfa/gNV+LT44DJUDzoHuA1mYX8RXiNqiomNPeAWJ2LMw+pZ5t5vGZbhil/ehZXk1DTle7UB9wLVkiHj9HkQk/4jZfrtgvhuYcRr9xuAdqx44arQQ+welyUMDwhgKeULoU+Gv0q1sRtDgyTWBJiwTuVvsYWnZmB4yGuqSO2JTkiU27m2aU0GwdGfVvTcAk6lCKYAhKpepN7jmVnQLEArKxI5lBfc9hyJflqib76+jQ4dlS/yl01blJPS6KwXKnVsDxKkvNvvdYO08cPdwc9+PVWFIN4q71wb1IjcGIFUPCIVu9J/cS4q8AX9nENnMcDXca4iXg2lr7mJE9yZOuCXGIQMzuufhfLFOPsz+hMRtuhjD1KBdFhRLW0eSGbLqXsrxwtuYw4BxW5X7xmEpM6HnL24Guxh7VGNx4hqpHg3l2XqiB8/6Vdndmzl12Ih37J4qFsuGm28I7kB9CQMGJs0AabvjRsPRd/ev6btMlY09Fhsr/vzOLW/iW95VHZNLkRv0Lh0HbbBtjXODT6VYV8nRgJB0vmpkOLFMZwU47qRNaLKaKcnQPuqfaM+6q/liQY1enuzYPkOKmRxYETHCfWhFrLcB9KdGkY8KC8WM7qhPr7hnOEjftxXrPKTFlN7pR7iQHnASghTZLBsR3ahu85xFvNSrv4/LKxJUJEx915Ab0SWIrLFAkClRajOjDmg2eOskjk+l4yHYkrYk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 11:16:51AM +0100, Uladzislau Rezki wrote:
> If this is supposed to be invoked from NMI, should we better just detect
> such context in the kvfree_call_rcu()? There are lot of "allow_spin" checks
> which make it easy to get lost.

Detecting if it's NMI might be okay, but IIUC re-entrancy requirement
not only comes from NMI but also from attaching bpf programs to
kernel functions, something like:

"Run a BPF program whenever queue_delayed_work() is called,
 ... and the BPF program somehow frees memory via kfree_rcu_nolock()".

Then, by the time the kernel calls queue_delayed_work() while holding
krcp->lock, it run the BPF program and calls kfree_rcu_nolock(),
it is not allowed to spin on krcp->lock.

It is hard to detect if it can spin in this case.

> As i see you maintain llist and the idea is simply to re-enter to the
> kvfree_rcu() again with allow-spin=true, since then it will be "normal"
> context.

It tries to acquire the lock and add it to krcp->head, but if somebody
is already holding the lock, it re-runs kvfree_rcu() with irq work.

> --
> Uladzislau Rezki

-- 
Cheers,
Harry / Hyeonggon

