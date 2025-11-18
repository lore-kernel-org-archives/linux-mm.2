Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92302CED635
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 12:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB6B6B00AA; Tue, 18 Nov 2025 07:12:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BA36B00AC; Tue, 18 Nov 2025 07:12:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C646B00AD; Tue, 18 Nov 2025 07:12:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADA866B00AA
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:12:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BCA913B23C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:12:49 +0000 (UTC)
X-FDA: 84123616458.19.9CF2736
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id E95FA1C0007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:12:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hll4ABbt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ziO8BWNF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763467965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2luX4LGmtNTTMzJuWLZXLHESOlGH27T2AY0rGXtmvI=;
	b=KCi4JPQg9s+zwtKHCylUCetInbVkpeu6nZbhMglSIX/1CFsACzXrkDmhtAGV8Y9lrwJDgf
	QyqvlnvtBKmIzzL1BCPtUK6LgoLQrpiwl8OF7t2TTMdJQ5K9z27k4pUZcscF1BbBySycG9
	yFuq1WsBE19OqAEUytRz8L4u/hdG7zo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763467965; a=rsa-sha256;
	cv=pass;
	b=A0Q4Bok3ldGQLM5hZjTH+E9cEgDUP0XVj9qJMLPK15S3SekCtqHiDyK0YRc7SkkrE8SU4d
	DP/2pTdlxP89E3mO0zmWo20oBInAu78+SO2OfURCr0Q34CE4GryKD8PEtBdMfL4LytT1UI
	DQI1wvv/EALZkIoVL9kFCJ08mI3Hgjw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hll4ABbt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ziO8BWNF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIBRYjr025276;
	Tue, 18 Nov 2025 12:12:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=F2luX4LGmtNTTMzJuW
	LZXLHESOlGH27T2AY0rGXtmvI=; b=hll4ABbtjnT5UT9JsHwmDUXW1LI6GyayfE
	z4JoY2itkwhdrRQRYCRgZrZxyOOyJH9sInGohYNrvczquaPhm4AjFdvfHc8nNcjN
	vQHbS+2XPaki43Org8VKCVdFgveww0hajHqzVU7FvhSZKKhUyt4I6n5fgU90O7z8
	PIaD862ujJ85OXmU1FZfLEWGePaVD6jKx0BGQUeFsfXGJAQHM7su4nHMImUAUUl9
	ZDo06BFGV22tYGvAgLKpxNZbGNBfhMj59sho5tcXzefMBlbxtnaSSvg1SrcdxqLv
	Thc30+Ik9FEgwHWjQRsdPck98283WhFYcIzSGYfhIUxc13RxVxtA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbcstg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 12:12:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIAPxAn007231;
	Tue, 18 Nov 2025 12:12:27 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012039.outbound.protection.outlook.com [40.107.200.39])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy92qgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 12:12:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=teSVArm2ICNIwr0rJNSV7Ou4lT3XgOcKbzwolof3elpKrQe8b2DPI+iLhlqHzRbyTm3vDQIELb68B2Lx1gRP7lUI0DKiPokYvBYmT0dOcQVvUvY13jo53JwfAwX3UkH9F9fx349NWJR5k0W1i7nYh484ah7Ns+wCVbIcNMvz3voSXUDbO74385yq/ODBDD9x+OoOyqoR7wopEjhwcF/L2ll6/s5oruF1qXfnFILV+OYTOCX6ECET3ucnayyFseEKXAOENyXzO5U9nU1LZCdaoGPKXEg8QD5NvoBc2ZUk+oKul48eVYOFEoYqZxHY1IwVDii6ICWFa1M8PGFCYEHicA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2luX4LGmtNTTMzJuWLZXLHESOlGH27T2AY0rGXtmvI=;
 b=MR7nrJ8ZeNYqgt/HY1j0iB7aicMx1iDG5zFSPKjhAhCica0cMsIxE7zP6YpHkIx3KXnX0LphyG2mu91ZcCRH6aRkEWy8izZmF9kfGYsJKBkhi9lenSA1Lu7P28Ei8vcrRkqiutdLnWOoIHp6LUEwwPRKTlM88LrT8MIgixyYxwi4fLr2sxixWzCX4X7cZO1TCY8DFaNZfrb9cy/EAU+zed9ZexLdj775+fmIqhPq/WivyZKqtmNtZxsYZEDYz0xhQ3UBfNEy2THRXwtZjJ0XYphs1g7cuaT47kq4LU/1Js1miKc1gy59H0nLkjgFUqU6PMJQjfxP55+njbyKxY+WgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2luX4LGmtNTTMzJuWLZXLHESOlGH27T2AY0rGXtmvI=;
 b=ziO8BWNFwICQALsicciC21RZfbNW7aMwJqUno0d2Fr4ixe49Eb36o48w2DdiKjSptM7dxmeE+WSKXSAX19IlvDR20KB84sAecwGewtB80kT3QHVSoGN0FkagrlfkOv85Q8FgCWRpwWicuei03SD1I10YuUGMG93bxnOnuy3IKvg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS4PPF381FEA7CA.namprd10.prod.outlook.com (2603:10b6:f:fc00::d14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 12:12:24 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 12:12:22 +0000
Date: Tue, 18 Nov 2025 21:12:14 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 06/26] mm: memcontrol: return root object cgroup for
 root memory cgroup
Message-ID: <aRxingFU0OKRnv8E@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <5e9743f291e7ca7b8f052775e993090ed66cfa80.1761658310.git.zhengqi.arch@bytedance.com>
 <aRroO9ypxvHsAjug@hyeyoo>
 <e5edc1b6-4c63-42c7-91ab-f1a28cb0b50d@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5edc1b6-4c63-42c7-91ab-f1a28cb0b50d@linux.dev>
X-ClientProxiedBy: TYCP286CA0054.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b5::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS4PPF381FEA7CA:EE_
X-MS-Office365-Filtering-Correlation-Id: b963eb62-e519-4780-943e-08de269bba65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a1VHjTjk1dQb3O6ALDNULV+RR9toMkmz9BH9YIRXNnqZsWpl8OcPX9FZY7LT?=
 =?us-ascii?Q?6CJrB8fMnn52EQ2TkiroJ5x1hEewD/ALO9Om8k+woNsJyPI1w0BRJa8wYwCn?=
 =?us-ascii?Q?VMvasyULW/8qT4z7IpuALyWDaPIfNA0+4v18PFH0O/iWlpN1PuYB2C7j4ff9?=
 =?us-ascii?Q?LEehj44uyH5KsEMr9ge75xWcTCeVNE9Lk++8TOyYcdzD5t4OfE9QYlK9rZ6B?=
 =?us-ascii?Q?1mncx88rsTaGHV/5Q3VVvhl/f0rgIH7NvQ6Fx8iROpIL7sdUwUzYRO2qOxww?=
 =?us-ascii?Q?mg+UFgVGPQTKbovcdvBUvsVRWOSyogj6vRW62W9GwPe2MKBrWtKCxDXmu+XP?=
 =?us-ascii?Q?sBPDAH3AzaW/5UDkFkIoNK+gGgqePqFFaDm7mYQy6OwWE2h1H06sA5uIYxHN?=
 =?us-ascii?Q?gUrXop/JQuIVUtGBg1jHPYE4FFvtYJNJ9bR7dTC7ZA51LCnywd/z2qj1pLIF?=
 =?us-ascii?Q?0I0nFTZIjCHsGQjiSzNWTIvhN/Ka4W+Xjm7p+MTOiDVpPni16n/Z3X4hYzpb?=
 =?us-ascii?Q?/zFCyudARz4th+smKaEfHyNBPl4PDYziV5FMnE5b0qhFB+fDOsaWQv7BtkqP?=
 =?us-ascii?Q?949CRCg5k/xt3QJ1bZagR8LWZYoGWB0SAwwFXn5v0Qu5G3Vdmg4LS4fb8OLQ?=
 =?us-ascii?Q?qppu/SunxMpS0Hnxn0or0Qk61UXooeCW8TaNeJsua6e5k9bNBDEmhpuUfHph?=
 =?us-ascii?Q?hF/G1389tqRAxMRcxIIrj1VTm7nf4s9lJwEbDYw0uyWtBXrgEKFU3DBZfSkD?=
 =?us-ascii?Q?YbYLDJHkeWJQn34q5LVJnnGw42t2tnn33QhOJ4Y+hRpa0nGpz/TPqMR/tHYl?=
 =?us-ascii?Q?pDbLdukYfA31S3sMDuq5eJ6rMAieNzksrmIwKiacSONRS2byLteCzOpeyqYZ?=
 =?us-ascii?Q?/EL+6ZppMN3hU5uxetDuL2n04Xx+p+w8J9+veUBohT9wUqnixYMdduGGEFY8?=
 =?us-ascii?Q?+EDbD2GwNbvUnLIK5Ez4qT7KlPGhroyqNoBrN+dqOHYAIy6uPcTzQ2YLyajQ?=
 =?us-ascii?Q?9DLi7jn+XQ5EerQSJKtvtRs0osAP29ioQRJcXk0eYHQJMD5FoVp82z+jp+mK?=
 =?us-ascii?Q?2DaYSZ31rOVyCpXUak9raR3S+NBkroOK7/ABdVOJnbqW9AmGG10dn65TuUll?=
 =?us-ascii?Q?zULV0TInQj6PbNMUP5Hj0I6Rbmx4lApyix1aL+f8BHY4fj4G5ZGlRsxYYVtW?=
 =?us-ascii?Q?AGZUC0YVxqAt2yHiRDBhtyRFGy5fZz/b/N1i/JkdATDIN88Fl74xYMpdKj4x?=
 =?us-ascii?Q?a7D1J579aJi2osSCvDY2e2a40FJdVXcCEqs5nIV/n8jJSK5vMbAte8gGnMUw?=
 =?us-ascii?Q?jvPxFa/uFq7qnb/zqjOkrKY+kcWbetgQfOSV/NLj9Fu6ym8NjnBBGBO1Cfry?=
 =?us-ascii?Q?ckgFMiZsH4jGud51ZTYdEBLcKp1BX7vsIqpOq6DBWY3iiKivWei/q39udzof?=
 =?us-ascii?Q?vp/I0ZkFH1JDJ1S7kWgLUfo2RSFq+ICMvBSNwj7m4bWe5ziu//vcgg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Henf/AjmhJ50aSb8K6OZ+6Fu7ElNHzOI/XVc5deqELjXbwTw+QO+w6iqzoTM?=
 =?us-ascii?Q?V6DcpCG1dSGka2tMTBOxgKTg8BoXXIllmd67WVC/xdYNwRyQA5L9anbzq59p?=
 =?us-ascii?Q?v4//KGXNEPJvdzTcCdXLyIHAdS2j7va9tytQWcCsWnRY2oqczKnoRlIWIXOT?=
 =?us-ascii?Q?4wEp8/FTeDaN/9aTAYfdSUfmqJDqRQVAn+mrLBWdwGk1p3iUnLdxUXX9Os/r?=
 =?us-ascii?Q?hfcFUil+QmA0B6BY4zer2pkta4hhIMXbdy7Vi+PwGgflScozzJBxCDEwXIas?=
 =?us-ascii?Q?8EL/X+37p1DYv9l+Dc0eqKgK9+UWaabFFXkKIgvZ3TprfJiIavRt/KOTG2hE?=
 =?us-ascii?Q?W8kYPdo94su3wEioYKSwKcbTCpIFsWz5e484hArlwufPgmkkCJfw4KU6hvFf?=
 =?us-ascii?Q?Uj7flFFZs5x0VfXweDIQ8MAhHxsDxhu2e+AsfFhz5Kg6yJgdbDeFtQyhU4An?=
 =?us-ascii?Q?qUn66q7gNBzaG/xZoRk7Jnnob4Z8KKOGJNK1a47KN3vRkj7WaspLPXO1svQJ?=
 =?us-ascii?Q?9W2ywTIi6EzVAhduEjC7exPM6G43V4EB0v8Vi5A3CWqumJ47LJSi8/LCxs6v?=
 =?us-ascii?Q?ASlUozT1KXKu1VFv1Y6AZIImYyftqo6CCXsOhMLzt8MHWeocOxDjhDSIMRih?=
 =?us-ascii?Q?wNJnfoNFP2vfrPSSmLt8nA4umNYRw81qKe2gTf5vM6SMvog1lWQjFWqlZmJ3?=
 =?us-ascii?Q?v7HZiCJsnQR+RuOmypvWHDyioqSzsH4tTIH4HOx6u7gC2Ih52jDGwq+5etYx?=
 =?us-ascii?Q?JVQE1tjFn/fFQ+m9bfvW8wd5kU4jVSDfopBOUI+bkbA49ZgXjFo+XjzhieaD?=
 =?us-ascii?Q?yC8qHYNjKs7jLnGwKFlvqLJ/ByHKJY3Hcq8bHIWk6DQgKP+3ObSaZ3uF6q6E?=
 =?us-ascii?Q?lCRrYLCl66SqYlJWyG0UL9xkbZzxvCKF6v/U+tpWn+pqhmuX+s4TJVPjodkm?=
 =?us-ascii?Q?F7tH3KUSISm1GaG16hU9/WZvbzpvmFmsoGC3IW9UILcDiw82cCnxM6QfDaGT?=
 =?us-ascii?Q?AYzOVyWNQMgKgMs9exOYISxYReA77a2g8GRmHr8Lk892sHDYrTjeXx+b+k7l?=
 =?us-ascii?Q?zMgIxY+jUvIUuEeiO+1DaF/BXo+XIbgzf8n5GNaEgAcTL7uE88bsRJ0Eelin?=
 =?us-ascii?Q?BPMBBhsTQ6LfZGlx+U2DEWBTeE1V4lS15lr1n56Ono6CQwWbgimSpus5KhwA?=
 =?us-ascii?Q?dLeh5Z6xPq5T5AtmQYybwuYBNK5OFL9UG5DX0LBf4V87otWrL9gdRbsXqOx7?=
 =?us-ascii?Q?PxhuX846o/SKFBRHoVB/WawBZwfa5a9c7OpNyQWtx+PH6vzwXaCKA6RDbUiT?=
 =?us-ascii?Q?l7Ll5Q8JukelGEqtEatx3kj37H2yd5h2nPQToOWvgUE9U6xsLrFXN2Eb8Doc?=
 =?us-ascii?Q?X070qRKsGOQ4/PHNHtfhRHjUOcRbOsKfwn8JowTJ8SGi1yDLHtR1G4p7aqbu?=
 =?us-ascii?Q?m+KrvsKcSWn0gcGHVnK5MFlH/xKrwf6pDahd5HUg5vubs3nc3gICwJJ6pxXN?=
 =?us-ascii?Q?mJ1PAuE7HBWisX1CO13QrAg11UhpOa9oKMxas99jqfhR0eK44oFhsaDBCyXc?=
 =?us-ascii?Q?pJxKI44hM/IHvn7SZV4r0i0JMEhNt5OQCKB2Fw5/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZkkSJz3Z14YAq0Bfc+6/rNjqDKziJJ2ycNpfeE306JS45BD8aDhzvhwWhJDn4mc4yWB0PDWlMrlida8vqhO6jqp4JXsHQqVwSYehB1kPS8hl+wu9igBHj9tASTx8H+cnQw2yTO+R3oO8vrl3VImG81/lYfQCZ7cu+P19cTrcaTAqtBqr+aD4m/j0HrRo2sC+fiupwHC+lBqykc6ePy/owgtF/3QgAp7uqAnF0VkpWtiRQV0emLYDmK5z29sIeBZKdfd9y+7D4i6B4JrQYKvzosJFS3eXro3GVJokCgV/z0Jy9TCL1Jh291JQiNw3sNoy2GT9NF9kKwok2lKqYSR94Hw15zaKXDIJvUooxP0nH+oXVH4l3JnT7hfKMGCosHi+FmGhTZ5LeJ92uXPpw8GT/cFTuZ+CsDrtwcNlApne00I1sQFNMwOEN1ez5YSKhpb1AD6IHxVvzJMUAToCFAu0VIFm7EfYdcXkQzvko5xqoSvp7c66B36/4GjGk1T1l+BP2qdenvYbUA/FPz7nnrx8yl6re5ifJtAJrlXwHZY3bt9qItGbTh5uUSIBxekzVkr6pAtvL6AXM6Vtlt6mXMYTl55r4ygVhDXhir9HEWStzrA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b963eb62-e519-4780-943e-08de269bba65
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 12:12:22.5363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cWuZmsx4MVHi1YAhMv66rhtcqwwSc+gszwi9ToMfrNww34dPXF7Qy6f+zkFWcql6nTOosjLEEFPd9Bh1dUMeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF381FEA7CA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511180097
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691c62ac cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8 a=36aYqyRNREkgP_8btxwA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: FdF3V0zJaxe_hgjkaGBP34k5534BzZ-r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX+MyDOvPs2LuW
 fyQECM0jCCaKXRJ0b5WEkzbYHtos4SFGncjLWbfNqvDvQwWn4ZeBkbwo5lAIZkydgXth73m6RjX
 MjbdmOmf8as6irNYmW9Cr8kbTqiZ+09xjCZhGEvwT9+iXzA2u3DCW0fNShdVYmBbHIKR1r8UMHB
 g0HEpHJoZc+T+CmsNzeHrihGUioPeC1mKsI5mc8ZSLY0RchQz9SdjEKKcExIzJCQjTu4QQs+1dU
 ZonA2H3r0vtsMN3SPIRXORQ5jnddKTZRWydTMgwI8pc6kBkMgQwn6jLv7CS7grSWp3PO/A2uHVK
 e6y/BVmMTBoqLsHZ1T5KBXkfAQgiUgtIcmpW96lN6/7oWnYMhkUSD3AdeGYXQCUEnZTUp0ZALMH
 X/jwuIRRDZh4XR7Mj9UpGxmcsxQdJw==
X-Proofpoint-GUID: FdF3V0zJaxe_hgjkaGBP34k5534BzZ-r
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E95FA1C0007
X-Stat-Signature: bqt1a9wb1b43f17ajdqikyjz39399o8o
X-Rspam-User: 
X-HE-Tag: 1763467964-476154
X-HE-Meta: U2FsdGVkX1/kLb96XvBlinfqJuGiz0DVBfJ+N+YQPAi2heiFrv4gGe0AcfSgpQBADxoAVweF7V5kZe7yrPjBrpulZDZ34bvuk4A98WzoYjxlXmH0FK2Cofc5I9h1kkdynRNc5GWcHNE2C0Kmq6sOAGhTL3LRHEKA64rCZ0chqtB6sa112guImGRmodiIS1wPQRNR1v2GX8jDgAubzycmRYi2jxnTqLrMhZvy4gCX10P4F8ZP9O4Cl7iFpktdqtK7ZO4K7y/TaB+uMSR+plqM/vNA36ax9Y1SsXKIx8hK4+oJktJEa/CRIvyVuYNufIn0mXr9PhMpBg9Jk731msuL38NJVhj39ssOSeQFgfbPeC7MGdUshc53HDrqyFeehMW9NwzGk+RiJESna+JMubos134h3UPIcoYrHLv0VGj+/ex7OXcWZLCQh5V/RUCXJjrXI7bhKjIdpFj9K47VccxRO7hYwfRO5QV5Xuod3V8PTpHrwBEXHRAUq2snLTNth3EL2J9CgKiq5bnskSfxrFrV8jpUss8MfkK+xPZ4H5qpp6gsfms81742ivxzobaw31zS9P3QfYgWShvvfNOLWE8ek+2sx1zLvHjwe0rlbbHb0xnbmOTss2QM0FvnzqowEq91CjjLAIXSxXcPRe3AlPsbNMEq76xwgLbTO1zCXC9It1gp5Mpur0g4JA2iser4417YtYZMwOtC7lBXUoHQvdV/1mm4ei2YbuIuY6M/DewB+1KleKjdO9Gle7xEHJ4xMCIlK5Yp2cc9ZrbN+QXa3Rt/UnGgFl6RRZu48+L6iSEpN5x0xm1/E0eEUOegzlfpJB8xxqW5aN2bqC58oSW71YvbEcjcBQ8CzQGBNlY9o9RiVShHtGLlGry28mrWjNr7aZmABqK7Se2UKhHj3U7e7HEFZ+j6L/JHrRCrcbMnDp6k9lSXs8ihw0TsuEo0PayA0M5mzimoj6Duv/Uauy4Ue+2
 PmzeAynb
 XYV/QnVYDZZLzvxGmesTzPyspQ8hhI/sMtWS+45XBLOFaqSl6FHJCSCLdCeB56u3oU818KKDFiejGyl+ZJ0njNfXYmu7Oa1SFEZ+ikFZNTJCcaNa8QYmKUdX3OGPN38yKNQZrRSObcdmZDCBdfm+7l7iTR5dPEwBXbvlkA+BxP6nZaSvoAP7Ev4qJ7g7uVskdvbZVPRfpr9cQZHEus6Z9cyYSDIZS4mjx3QGMEb/VKw+lhMzkeAu2i4d6zsD3tCsR1YE1MBWPSVFhEksqDn4o7t70ivtW8X8KD6ApWtpGJrwvCnjqIvak6CmApA3wbNnAxeiA0RmO/aW8b4PziAvvaxiv/VYe7+OI9kSFZVXLgE1lfLkQmD5fvClIGdaDJrgOHoRTsk/0e++GZkkcGvABdFb6MUEt5uicLlV/puxZgWIC4+lbxaamsJ+bt1eWwLjg9ph22rYUPWwF9h45IFlmzIrCVOldld5XikWHaSfIZfTDmZAbV2CRNR1Wkz2+rZDzN4PCFNB5cAHdgYV9GVlWYDfw/RCpse/xYWfC2cXaR2AKLIoaYK74V7OZ/zcu8Hi89fN26pnl1Kz8oORlEfyBGVSJO1J8rGS3fT5hGXAxMPQw6a+saXl6O8EjGSSXRDpKPj59W4N2ET1BkR9bHSq3gw6CfRR/daAfxnfUHm0IKKy04Gs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:28:41PM +0800, Qi Zheng wrote:
> Hi Harry,
> 
> On 11/17/25 5:17 PM, Harry Yoo wrote:
> > On Tue, Oct 28, 2025 at 09:58:19PM +0800, Qi Zheng wrote:
> > > From: Muchun Song <songmuchun@bytedance.com>
> > > 
> > > Memory cgroup functions such as get_mem_cgroup_from_folio() and
> > > get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
> > > even for the root memory cgroup. In contrast, the situation for
> > > object cgroups has been different.
> > > 
> > > Previously, the root object cgroup couldn't be returned because
> > > it didn't exist. Now that a valid root object cgroup exists, for
> > > the sake of consistency, it's necessary to align the behavior of
> > > object-cgroup-related operations with that of memory cgroup APIs.
> > > 
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > > ---
> > >   include/linux/memcontrol.h | 29 +++++++++++++++++-------
> > >   mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
> > >   mm/percpu.c                |  2 +-
> > >   3 files changed, 46 insertions(+), 30 deletions(-)
> > > 
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 6185d8399a54e..9fdbd4970021d 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -332,6 +332,7 @@ struct mem_cgroup {
> > >   #define MEMCG_CHARGE_BATCH 64U
> > >   extern struct mem_cgroup *root_mem_cgroup;
> > > +extern struct obj_cgroup *root_obj_cgroup;
> > >   enum page_memcg_data_flags {
> > >   	/* page->memcg_data is a pointer to an slabobj_ext vector */
> > > @@ -549,6 +550,11 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
> > >   	return (memcg == root_mem_cgroup);
> > >   }
> > > +static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
> > > +{
> > > +	return objcg == root_obj_cgroup;
> > > +}
> > 
> > After reparenting, an objcg may satisfy objcg->memcg == root_mem_cgroup
> > while objcg != root_obj_cgroup. Should they be considered as
> > root objcgs?
> 
> Indeed, it's pointless to charge to root_mem_cgroup (objcg->memcg).
> 
> So it should be:
> 
> static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
> {
> 	return (objcg == root_obj_cgroup) || (objcg->memcg == root_mem_cgroup);
> }
> 

Thanks and tomorrow I'll try to review if will be correct ;)

> > >   static inline bool mem_cgroup_disabled(void)
> > >   {
> > >   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 2afd7f99ca101..d484b632c790f 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2871,7 +2865,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
> > >   	int ret = 0;
> > >   	objcg = current_obj_cgroup();
> > > -	if (objcg) {
> > > +	if (!obj_cgroup_is_root(objcg)) {
> > 
> > Now that we support the page and slab allocators support allocating memory
> > in NMI contexts (on some archs), current_obj_cgroup() can return NULL
> > if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi()) returns true
> > (then it leads to a NULL-pointer-deref bug).
> > 
> > But IIUC this is applied to kmem charging only (as they use this_cpu ops
> > for stats update), and we don't have to apply the same restriction to
> > charging LRU pages with objcg.
> > 
> > Maybe Shakeel has more insight on this.
> > 
> > Link: https://lore.kernel.org/all/20250519063142.111219-1-shakeel.butt@linux.dev
> 
> Thanks for this information, and it seems there's nothing wrong here.

I mean at least we should not introduce a NULL-pointer-deref bug in
__memcg_kmem_charge_page(), by assuming objcg returned by
current_obj_cgroup() is non-NULL?

1. Someone allocates non-slab kmem in an NMI context (in_nmi() == true),
   calling __memcg_kmem_charge_page().
2. current_obj_cgruop() returns NULL because the architectures
   has CONFIG_MEMCG_NMI_UNSAFE and it's in an NMI context.
3. obj_cgroup_is_root() returns false since
   objcg (NULL) != root_obj_cgroup
4. we pass NULL to obj_cgroup_charge_pages().
5. obj_cgroup_charge_pages() calls get_mem_cgroup_from_objcg(),
   dereference objcg->memcg (! a NULL-pointer-deref).

> Thanks,
> Qi
> 
> > 

-- 
Cheers,
Harry / Hyeonggon

