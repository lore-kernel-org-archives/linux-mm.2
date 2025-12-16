Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE61D5CCBF
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7866B0089; Tue, 16 Dec 2025 05:32:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E866B008A; Tue, 16 Dec 2025 05:32:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243296B008C; Tue, 16 Dec 2025 05:32:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 126396B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:32:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4B951A05AD
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:32:39 +0000 (UTC)
X-FDA: 84224970438.06.C31EED2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5A4BFC0006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:32:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qD2Eza97;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uT62mxgE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765881156; a=rsa-sha256;
	cv=pass;
	b=M27EtTl/lhRb8K97RTfSl7yDjY5/RBDcqxi7BtqrlowzCKXOnHWskyyxfhPGi3EhRsM6OW
	xiU5PNI0CgHZIafme1cjECfKGKq3rvLTMVHqtwxYtfs3oSHWBgXCGXRe2EwICR7tGmY3kB
	DLx1IJpxMfjxMpvXvYEwHKoQ5x3HXf8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qD2Eza97;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uT62mxgE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765881156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhKf4qXDtPfDGaGjGCwhAgO37WUg4nLeovFIXv+dAAk=;
	b=05zhGMkmlyzM5k0gMIBlqPtrot9nwSkG2TewRpIc8gqfXT7XgxweZkVzXw0j39AFU54arj
	16+stQw1HZ672OfEHCfReChPs6WpWZFE1PqOwD9eTiFPeZIzVkxpBR2/AvsceYza+Ip2n8
	+vKz66HkaHDl+2BHYcJd+/RmyJkOaiU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGACDwn137199;
	Tue, 16 Dec 2025 10:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lhKf4qXDtPfDGaGjGC
	whAgO37WUg4nLeovFIXv+dAAk=; b=qD2Eza97L62HTkPIufU+eDb9P0ZsuuUwxq
	Ymi80hfDsRqScFeOOZBLRFvOkQY9+/MA03/aQcfIaiplLAnHSm8+CPzyh/G6653M
	+OqbQA8hlX5qMxwP5Wulkqs92aTmUytpFgpdUJ7ZQkKjULE4tEYj05RFdw5X85Dk
	MVkXdaoAJg56zVE1XThCKdb9feB38nXkss0e0y9Z26nIPIvAAk1JVwnzE9WaLrcc
	pShPKnyRPOFNBynnPTwQkS1ukaYNt6IVbX13KvaPfyeJ7TRjClXAp2JvZ3kjZfg+
	qxA6KrepAfSnMiU6/aGnFjMTSyaAKKlHKkmLJ7/1hJVhN9Gjjcbw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28bs21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:32:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BGAAi2V024610;
	Tue, 16 Dec 2025 10:32:11 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkaafrs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:32:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UYcS/LnTvoA7JfssOJTxznS5hWm3oW4k9j5Df7pp89uE39SiebK/wnmre4Kc/92gHlqkdT6KolwhEAq2kczpQbSaRoJW8eusT7NFu8blgi1CduZoT0AbHstU74jskt5gYNDgvNujbaUH9iAOArJ5ft3wL+Bzm1oGvYFah66W6z6hCdk35irtqflqowOjKE870E8uWN73R1/SPDmqJa1ZQIlOUEUUcvJyqaqaelrmXXWcQYxqAv7Vvx4UVRSn9QqPQhycvfYNLSp3PYeedlrkxufgt79xjGY4DZKT+HBjrmSoryFfjtXAGwVMeGpEFUYoW0qWOptvW7ElO0uTd62XmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhKf4qXDtPfDGaGjGCwhAgO37WUg4nLeovFIXv+dAAk=;
 b=i+5pcH9irxNY+Qh8KbOPv9UvsOojyjPkdzrDgUjqjiomMzjw40+2kUDOZ+VpKXeSSas7BobVNX9s4aWbZPt01eSPn0C0zxTnAcuTgcZq+EYhGinEwi9Rp41LX9RF02TG3xUDlQzYwO7BZfzb48IdlMor45LXxDK2oL1LhO14eiMIPF9yfNlvtDY86kTgIxIUzGrABYh16oqplYKY7jG/l1vOqhSMTRsWMYW2YdWST1MVE46hFl/Hi8chG0ZxLN4q5m8pL3ZlyAHIT1kmxrkF7UC/Lmrww5lb32LOLigz6/Kzy0vRh+PrmiYbSDyjh6uGKhQCDnD39hgtM5aIt6upmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhKf4qXDtPfDGaGjGCwhAgO37WUg4nLeovFIXv+dAAk=;
 b=uT62mxgEiKrFE+Rn/KaxhyyR64lHqDYv5izFzmsJFRzssOGTvF81puTfktJZ0wBn0IQ045591wXVe2tMsLLb4CxUqV3BLg+1+9zMcWW8OYTRczZnDatteqBDORAc+C0OHtXffemY8JOMcvkT4qe5GX7HuUccYdc565fx5ghcrK0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7585.namprd10.prod.outlook.com (2603:10b6:806:379::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 10:32:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 10:32:08 +0000
Date: Tue, 16 Dec 2025 10:32:07 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tal Zussman <tz2294@columbia.edu>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        x86@kernel.org, Will Deacon <will@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
        Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: Remove tlb_flush_reason::NR_TLB_FLUSH_REASONS
Message-ID: <c1dce926-98bf-4c9e-a40f-1ba9bcf03ad2@lucifer.local>
References: <20251212-tlb-trace-fix-v2-0-d322e0ad9b69@columbia.edu>
 <20251212-tlb-trace-fix-v2-2-d322e0ad9b69@columbia.edu>
 <a5f3885f-aa32-420b-8d2f-e8ed6bfc6ee3@lucifer.local>
 <c754c406-2816-4b70-a4a8-7a11b9ec45d3@efficios.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c754c406-2816-4b70-a4a8-7a11b9ec45d3@efficios.com>
X-ClientProxiedBy: LO2P265CA0206.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: 4246d706-03a9-429f-f7ad-08de3c8e5d45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ifSCi+nj13P9EpC6fvn2ixPpO+I/OWcDIJ+aTf5nyb4G7LRcEy8zs3qMlOJb?=
 =?us-ascii?Q?Efsz855M1VsTN9kS/mXeie7L3X2rPYAsuRQRNc07Qx6r6IzJUxl7fBtY7Da9?=
 =?us-ascii?Q?njlno8uRFiokcosYuVhIOgr9UxL3a/kzRSzlZbxuksxARLZZXHWxpEd+LDMt?=
 =?us-ascii?Q?6I4uCsGbvbtmDIF2G1aOBv78T3Sf/W9+Q1Qq1afuvOlV0ZpSWJKGziEKLPMc?=
 =?us-ascii?Q?AKtwzc58sNMAY1jvrvp9ctT0TYwbtMRh7jRJhlOwmkISgThWgivBhVyN4AKk?=
 =?us-ascii?Q?/P0E5tbMy48nph8dIZl5uJ/7eq2vvLGZv+QlLhJvbYgQ14ce19ug7F4W70U4?=
 =?us-ascii?Q?zL5bAHpS7fjZ9GIcX0H4J2OpnnNbrTwizVR1CeGlAKejZcLQ+r2K+dwiXbzT?=
 =?us-ascii?Q?qahw/d1wsnt6yb3fa4pX9K69B4s9A6/+iDXtGzNnVETcI9Xxw/wUIlO+znQW?=
 =?us-ascii?Q?OUfA4e2c5cZ6W9gLbBvKTlg7klcEDkPFYVOecAn7Jd6ipKoNds8+u6Edqr5i?=
 =?us-ascii?Q?WuY0ycXl5KkAWFZCiwRUgXMyRO3cJZkK9HMGunTAwFA/UbP+pkM0TdULxB8i?=
 =?us-ascii?Q?gu7cSdNaZGIVWCz94YpcMcyctxmAtDpjHEo3nslOZEHs8ZlapKxQJY4q0Nfu?=
 =?us-ascii?Q?vrXZJUm1eGW9LMN+w2jyE/77jkrAWjIzeoXE6gvRQF/YYfHqizaELOMdJ9a8?=
 =?us-ascii?Q?UG//fCs0teoLRYPy8bTNQHm90wOKpSxW/9hYrFaJgoTfzwpw2wuRvlV44x50?=
 =?us-ascii?Q?6ErjPLQaRooM5ITdDqA53ZUqDn0D5UXVXqo3SrFhMhZfTm86N/KwIaOJhprF?=
 =?us-ascii?Q?cgHbg2I470iwGB2m4PfrSbcBVK8D2EIQoTlk7eAqDFCxN6C0jBZ6YU62LSJM?=
 =?us-ascii?Q?PgbCbmfAm68H9gGUqvvX1/7wsNaSOmYNDqOqaA9H1HF7dK7NSXOkpITNP6Xe?=
 =?us-ascii?Q?fAE8SYzRSm3EmTMuFNBoF87ASbQQHYErPEKTjMtsFt4ODaL4IvJArOWSpupx?=
 =?us-ascii?Q?2CjJDSKimtcRXxq/cHAKglM15ATfy9LFRxuhPRNMa7sckmGT/0zrN8sMPApp?=
 =?us-ascii?Q?hIaiU3/VdsZqPNQcVKvcVc4Pv3Tb0ehULOIkgdFgQ+800htBMa3giPjktUkm?=
 =?us-ascii?Q?DQ1J0RYDY05oetreuDia3Pr0MwfYekuIovP/G9l1y8LlQUxv2RUsUuhLRmiD?=
 =?us-ascii?Q?wEIgRWfm9wRKUkt0plmnwCY4odWMwKhdo/etz+xyekPDEDxnaWSw6sC5f8hF?=
 =?us-ascii?Q?Q9R+yH4ACqglR3vCLJopHILT5elssWUPtyPtw8ig/8zAdfDyH1Hq4JLoT5Ox?=
 =?us-ascii?Q?dqxLa1bBG3dZcB9p7izJSKoStPwLrZ6dITvGs7OR5f1SI3Y9ekmQLyl1qGUl?=
 =?us-ascii?Q?JqfjrQOmiJXFUo1hoT9+taBJAVqZ3MA9t5yGV9jYlHGXhtbu+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ngLRrtCSZJyFxD/9Bran+oElKG7w21fkbkIBjbrct0U4TaMO90kj+UuS0gt6?=
 =?us-ascii?Q?BLSKk8O/i7tX/GbVBljhW9pQg+ZRiYEOa1XkKbCA/Pm3P9oqP/n+feVcjCLv?=
 =?us-ascii?Q?PEpEn+qLRxcvYdK+rigkR9fiSBbmBhuowk9O/VzwQ7+zdkCUe7WSNm4OjFDe?=
 =?us-ascii?Q?HkJrk5TZM/V89klZrmrXfFRZtYFR1joJID2D5PsoSGnd81+2WvK/dFkJsNX+?=
 =?us-ascii?Q?mvfJNL5bvcxKW//LOds24gOJNWyekTRnUxEUULwJW4DR8zmIb+8Oj0XIxV6N?=
 =?us-ascii?Q?3TPbAqIuHDM31Zw+G2bj305ltxMmzg/TWAFG5/HaD377re+FV2Ctm0pnIM3d?=
 =?us-ascii?Q?riZJ/lYen/v+wvlK4wBpZ1yl4p+ln7Ax+94yCtKXto2bZHQ9QTfjxdaHGbw3?=
 =?us-ascii?Q?JYdFUgfzVmeO1AlO93/rvQ+kyuc5lRQ4WM/3HmD5E/SGG9XQQZzQs5xnaZTT?=
 =?us-ascii?Q?vt1+5xYgCazc+FvYj+ZmuldBqFrgFAaoP1P+flNe6YnM7fa22NJQ+JXx3q5Y?=
 =?us-ascii?Q?HtHXnzANpTOATlMRmtJQ+LRT7D2eKavgQYypDacFp2mVT2RrvnLRreKUgDTt?=
 =?us-ascii?Q?eZpw+E6pfrGMXXiEP1syRB9WWEvcrOWIvFP4jPFyJDGGVUEsiIwZljCnKZjX?=
 =?us-ascii?Q?ASi/DUSmHtOlbhoQNmVD4zwUj7b5Jj+pNVK5mY+c4BD91vdr5hUO99LLhdW7?=
 =?us-ascii?Q?zPtx7Xy0XTo0zOFwbHBzuxeBMDXmBmkqE3FxbXIb2nR05bjXYaaZiTPgeBiJ?=
 =?us-ascii?Q?dYEkBnBBYqtWL/G/xGmhhGSk1Z8JBY2m5OsAVjyCORsRl58aTMW0DyBBws4d?=
 =?us-ascii?Q?4Tq29UlmSndsBCe5nJqEhJTrWCTINaSREVg3JiD2ngpypLI6zrh0HWmZ3k1+?=
 =?us-ascii?Q?5FeafZeEjzLGwBH7YscU7rLZn0jkoi/Rsmg7ZjLB8/epGe4QH5f1JpTkcZ8W?=
 =?us-ascii?Q?N8TzWARdONL++BZgFAVMOSh5x8G7DbwoG1rynEAWv2Y2kpcClWf+9kYjIun8?=
 =?us-ascii?Q?h4uFz+kimaNdnn2mYnYSv9l/c5lymER110NM0XZQ7JgIx+VltFvcK3hGqgT2?=
 =?us-ascii?Q?qMr1qVGZkQdP6bT1LKRw+s9VidzQzfaPZAWsAAGVvHMyCwC2SQWrfE8eLyAJ?=
 =?us-ascii?Q?rYhX9QjWNc3aosb/vnE2JSQXzNKaStd1H8TqDWrxJtRyJk5PM+ZosjzkqH56?=
 =?us-ascii?Q?Lts0hOW+AzyQPi8NbMlgsBoy46+g6DHqczbBe9CasgjkpxoLq8vCCaujhtES?=
 =?us-ascii?Q?WkeQDniSlo+P3v6CwBsf2zPhsvu7wgU2EWfo+qCW1NW+q2DDWf7WGaY8hidO?=
 =?us-ascii?Q?9VAPvwlvgqZn/Hfv0rCo6/oBMwe8keBD8z/9qdwv78kChf0B7VFFJGWP6x15?=
 =?us-ascii?Q?1YeNKb8N5d3jR5RYZtxcnElDMNvIfge6GUyC4YtQHjy6deP1l+i5pBjk/sc9?=
 =?us-ascii?Q?qQljLZ1pIC9vNp3NbX6984N4x6iqrGLmUgDupyxaq6npNMODnKGSoRbmmm+W?=
 =?us-ascii?Q?WcowcmkLyXK4fMlileTMYHUmEGOVvDA5iZ7CZSXnMOYmsHLB+EMU7qp5RJty?=
 =?us-ascii?Q?nlOsQExXu7M4uRZiwmWwBu8w2I6Shp0fXBfC+4lciGVda6ie6Qa5IxCAg4Op?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HWtcMNwoQxWrJNNcDrY+c/zhaCRbL0QFziV8bWrzCJBvLRx2sqR4biHfhKb94I5vn2KhfrlJMxq9r3vD42vgtNzl7e8Uf7GlVztQ6Rue+mcC6IXZPJE9hzpzvKx8ibpr1rfgapu09Ofr9T9Yf8nRfYE96XNSQoT1IDRvFf4/JDjPX6g1QGi5kcDbH7GWYE0LlVadRYW99+zOdfiJ5rj/M+WWdjKHf38tOPdrWg8aNAWsI9Bv/jDTi9ebD1I5D03BbYKr7R02GSrQ/jKaOaLlz3dSXLeGIG12mNzr5uwaXZ69Gi5Rs1c7mFJQ8blj41ZsAtiKFrz3ISiP/ZP9r+W3UXCXi9vEWia4j+smAHVbFkR5WeoirdKrVInFwG0uDUgL0DFcGBsX9bYHi+YOHFmdFg6w0ncSYtaRJs03dHOtKbHa0r+L+V8gJzQ8THIcjPsJkGW7kRvoIQ1taggsjL5MiYWF5mccDe8k7Rol6x//WvWOSgcE7+wPert+Abf9Ahv3SkBK4g9ZTTXNOk87d6ve7VzxturR4j4bInM6BO1cVMli/5A0roNxOW8MJoLhCz84gITlbGC5mQ6QkzAteBQCj5hGcsVkyBw7CcaCWhAaQTk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4246d706-03a9-429f-f7ad-08de3c8e5d45
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 10:32:08.1994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPH3cWwiwDFkZ09YB7disx/xq2BQLSPQfMynQsWEAr8y94vjfmBM0aesT4VEHum43MHMldX8NMrDtj0EnJZbJPE4PqMLTwJz1D1jvZ6kecA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7585
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_01,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160088
X-Proofpoint-GUID: qrtbk-XWNkNIN1W8EHD7HUUY-lNVmo1Z
X-Proofpoint-ORIG-GUID: qrtbk-XWNkNIN1W8EHD7HUUY-lNVmo1Z
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=6941352c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=E73hYilgAAAA:20 a=7d_E57ReAAAA:8 a=20KFwNOVAAAA:8 a=fwyzoN0nAAAA:8
 a=j3rHBRVGMcf5QS-zTEMA:9 a=CjuIK1q_8ugA:10 a=jhqOcbufqs7Y1TYCrUUU:22
 a=Sc3RvPAMVtkGz6dGeUiH:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDA4OCBTYWx0ZWRfX5tWlru6I/jAS
 jmXgIbzauJjelTuHlKv3Z/0lud/dRUCPGMckX+f2HBDgGSXRypaaAh6M9pJ0GWtiwGq5p18EzBZ
 aeOCZbPdoTi1MTCX/OIhw4Q31eQm8f6pcnORsYr6Ug8o5RPAky7/GuEM1DW5dDATWe6yCm2sE4p
 6jENPsenPFyOQtFlsig6tGgbjOJLH7pGDEDrbsRwh1w1MQ1nILiSPkCmlsL22V6MuM0myJ15AUY
 e8DO5ZPtD+9+g6Lv65TqzFc4rfmCPxIeAtwGMrhJRCkdqwBlS7MHgdd4fdbt4wSqrBlLlZ4XjYL
 0+ypnTa69lSpw19GcvzX8lQO8deaoheT5Q5EOunoXBy3NWfu32tvat9wtGgu78puViRRcCqcgR8
 WRpyiraHv4J5kAlr+8BkeKO13VA8Fw==
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A4BFC0006
X-Stat-Signature: bxyqs4ay7jt85jwje48i6kjdn3pjuwz5
X-HE-Tag: 1765881156-140572
X-HE-Meta: U2FsdGVkX19+OZ/Hbm/pLMrr3Hffk5NdCIspOdZ6hpK1PpeGdNzB8b8ZE6Sban8XlcxZKidMqWHuf9cZ+7fenWsUvcT8vLdib58MBv3ljbq7423zkQYMX+o5rWGsP1K9NYMBoCdli2QpQVwg7EdHstYVQIBpzmatPZMB1O/oO67ApJ043hUP2HDYp1gDdW0HIpMFfn9X630V/iX5eLVSlwr7E/wYm0ZDRlH2gmE7dAauI92jp70jkMRWuhr60in+atRKLsO5gI11UDJQ7cikQ+ecvUdFs3vmbO1iuGb7p61juHMMhgbeDp8AvVgWgKJ1siTrdKA5rNoZXJ8r1WLCNpTf5MV0k3xE39FQ3InZivohxDFD387maWDyUguMH785ddwaSMGTJm0ut9kEInqm7UMIO+aql9+M6H4KlRJE+zL1DS4GstC5vij/snJIOXgVLpqpvj9Kiz86NRTObraa08nX0QBm6E0EjYUwtTSrkbCgtRkfCE/Rm6GvZeLxhwtIs8ac2lY2PDl2YAEzen6iNrUiKMuQbclaMeR9sIAPZxeGSROjZRM7UTD9aMP67oqxl4rnALQt7j5tCz7G4Qs6hIQmdRHsvpU7jrT1MwV5ZfQDZadsyH358dR8EOfQJIGJFMggb5EePaYkpvjy6Z2xvcZVaaxD0eOJ2mLxMvs394FN9gxsrY+zHwLMKfUwe/+ktmaNv/vOl58nbyfgFELiD998GQucX/ERZtDRjqCCw5rjgu95aLmXZkBdzEzHJna2FOq0lRDSvJuz0WRvbOCl33jXlE6kvX+BajhYILli7iTdqqfGqgdr0Aa31MjNkJ3plYHC1S+8gTaon5eRPZb4/F8UGl/7ly772tixXKn9AnG8NGRNukxP0vIxVl4qlFEfZQq+ssYOjbeodq8mgqiRU9dLT2kOQzWDEmAvuGxybuXEWDgKq3/EKdnfsTAS+55ZssqflbGuqNwpUyiwwNK
 57jUTB9B
 3T5cARCJqUNn1xpsbcKP5JHg43WkKL4UbjQQNttABMaY6+6Y19kj6RzvRaQAv+Cnlk0zifF1rdDzBIFunZ7wr09Izwispnu3+aa8BOvSnBjRvdJap0pROmxu5c/XqDa1Pwivc0NIGiZ/4PMrk2Jsz4Z5KSGfj9Yq1RBxe212PddMs6clonI5bKUrZyoy9Ip3EvQT7sTizjWnlfpa4x2a5NNITNljxSTLpzwEqU72iST73OrfN1EalL9+YRiRvW2w0WUq3djnIHChxfR7K6JUD+88j1yZHkBEesBxxjdnza51Y2uiIGjUVjlgvkrNema2Jx69f4ibrZxdyH+PlTmDXHmFXivQg2dq3m4BgeLczslKwO9Q+tVKMw17SavDI4AlailjQTlZy5Oh3ZCHmOxtcAGMXJdMAztggZeNq8juQ11oaH2w/2O+d7QWhsPjl7CgSarIT+7ZzJzVu+wX0szyXIeTMNuB+Xy80Q36ITCpYVLfL2HxqfWVkql2PiY0os8ddSwS+LVxzkYfzJOO1tG4859CTe9c6DLvgSkHzCdDvOAo7mz7RSDevSjyprzYZzylL5G8ipn0ngSwTXKFsXqEN+E3KenjHkp9ADyMtWAoMDP+nBjcen4zLiKnr0gPQkiVcuAYnsVvhoPpyk5nRlG74qcTWycwZqNpOY3eObJrGAQO3VwKCdyk7w7hJrXA6lK5b8QhcMzUVfeUZ8hNafzreeOHcsiKl6aFthF7fOmJ9ENxukXcCdfwBeacd7XIe1R+7uf0iEZZqw1G6KyDp6MyG4KlCQy0dV28BVfsRIT2H0D80klTPxzYh0ZJEswPdFeh/HudE587eyWAbH2bmUYCTRaOnJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 08:35:58AM -0500, Mathieu Desnoyers wrote:
> On 2025-12-15 07:40, Lorenzo Stoakes wrote:
> > On Fri, Dec 12, 2025 at 04:08:08AM -0500, Tal Zussman wrote:
> > > This has been unused since it was added 11 years ago in commit
> > > d17d8f9dedb9 ("x86/mm: Add tracepoints for TLB flushes").
> > >
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Reviewed-by: Rik van Riel <riel@surriel.com>
> > > Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >
> > Hmm, guess just a way of counting the number of reasons, but if nobody's using
> > it that's silly. So:
>
> If TRACE_DEFINE_ENUM was implemented differently [1,2], then we could use
> NR_TLB_FLUSH_REASONS in a static assert to validate that the number of
> exported enum labels matches the enum tlb_flush_reason.
>
> This would catch this kind of discrepancy at compile-time.

Sure, but for the time being this isn't being used, so dead code -> yoink!

We can obviously come back to this as necessary.

>
> Thanks,
>
> Mathieu
>
> [1] https://github.com/lttng/lttng-modules/blob/master/include/instrumentation/events/sched.h#L132
> [2] https://github.com/lttng/lttng-modules/blob/master/include/lttng/tracepoint-event-impl.h#L176
>
> >
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com

Cheers, Lorenzo

