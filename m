Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B30D46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E686B00C5; Wed, 21 Jan 2026 11:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2546B00C6; Wed, 21 Jan 2026 11:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4DD6B00C7; Wed, 21 Jan 2026 11:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6EE76B00C5
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 717601A07CE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:25 +0000 (UTC)
X-FDA: 84356576850.29.419EB08
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1CDBE1C0010
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UaEPgE0F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="o4WOu/bK";
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
	b=1mUxQbQqoVm7DS+rJ6bFBW2tIhG5V8vfMpyADu7k/lKAw5gxRz14/5aHw6wBQ9VbjPjyU5
	gTWbmG4p33193t5krXvdnreczzf+e2BYE1MTQDCR19Dss+FSnwSiXe8iRGayg0A5DUFYCr
	RjEcwyfekj1odKg8xLOVjC4r+9YItZs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UaEPgE0F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="o4WOu/bK";
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014642; a=rsa-sha256;
	cv=pass;
	b=Pk25L1ndjpuODk090xp9N/oR1H+v/zS+2h646lZfHdprUWeUaNQghjLApDz8V5oOrEiWoF
	cN4iwOktiezI4Us7bsLUvASggP8eppzFhC2NaZVaLtC3gzjr0vKCSH1XNjuyDW/4k6uutC
	cDbRbU63+YDCItFV5oe9xxsHTtnqjZc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDLNeq3029082;
	Wed, 21 Jan 2026 16:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=; b=
	UaEPgE0FKuDX5Qj9IrrV9D3Xln4c0bZpRZTeNGKw/HHugPK3Yr32jXO2DxxN/Jz7
	Xkz+B/s3H6HgVagBNrdfGyxs4X4U2qhjZeYqLUuAf1AgHiyzDyfPvhycSg6tUxgy
	ABjdU2Zydp+nTt9xm5NRo77nXTVslQl2j7aHRSMGQctvdipnVd+74vPVPAMGsRse
	to9fGE8xQ1oXKFe4C/PaDoFU9VfsYYXCY4oOnEwu5Txx2sHzDuo65RyK0H2oNw0u
	/TXQll0dUxk+qU+Yi57naSLjAaQGHbTpPpH4XKCP04+yVyxsgP3FxXlJKole9g7b
	kOKTkIy7+4572Aqe1E48OQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vx8mk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGNgJj008393;
	Wed, 21 Jan 2026 16:57:13 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012023.outbound.protection.outlook.com [40.107.209.23])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbht22-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iYm6XoH4KE0mJRDI7+Wi6kJKY9Ijs9R5msE6wDsjviooLmKMC6/R4vj/4A5ZPDOBGZ38cf2++CiH9uIibVYOpHSJWfTB2oG21lb33srzji08597RcQYqGGLCwY45DlHEqO0BRI51KPv/dAjrIWLBvP3EIyIhLZ4hc7rBmb6/+Dqt/m1yvhLUtw5JPekrVf6WtXNlyTEcF5NCJpuGF/ZGKQZ4S1FUk4yT35ZrJ+hEbaGB2evzEmeEsuYUK2D4VUMFz9tFLRN3xsc1nfzgJjBn59U+ZOo5P2L9LTzp08hSx2YWfCw6Ru3EK7rj0kiauZC4TbAfgfY7HXhqi8ikF5OWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
 b=HT8A/sXqG7/mGqek0uBTiIKA4OTE6OPOplQBrSbZPro09kMseT/cKWef4kgZWbqqZZoRhdXmCMjz/p2bJBNEcsl82kjb7IDq8D79j9b9whZmMeld8cALUTqMhQj98yKUpBrirE1CeShP1yI5rPgZlEC+tkGsH0SWfNad5PIxb5LZlOAzjG7I2Afz/coAWZX2cTtifQmD+7Y8N5ALi22lBlwAWr6XaIbYJAF8EmjBxnopWPv10+w3nprf0tHgeHhZePpVY31KN8an8XKeXVXIeX2mVkgBI3Rz1vkXO7fyB825QIhsfR4pEQVN0xlIxky5XANMsE7fietim3nlPyf5LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
 b=o4WOu/bKI70v9iDMwUKsJbjTKNOvM4iOnPIkbITmZgzeeyUn+4WwYTDLU+Z+sxy25XRiX3kSl3fuvDqMDr6DEeDE7p8sZ/pm5RkR5hcJDQFxPR4t2XrrG55AgMpWnPYW1rJmVdnE7r0ITrO8hhyMfB/SjQkY73vl5kL4vI16g5U=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:10 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 12/29] maple_tree: Testing update for spanning store
Date: Wed, 21 Jan 2026 11:45:09 -0500
Message-ID: <20260121164526.2093265-13-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0075.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 64878371-c013-475d-6db3-08de590e1d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7UbQ7siAgysaSli+QZ+LTUWFsuIqLiOyVzf91mz4KXjycycI+J/hVGZhSCRt?=
 =?us-ascii?Q?13G3iRzeOha4lhLRgM4bTvmUsk9XKksjg9fJHZV35MzFK5qRw7Wvna0lrU49?=
 =?us-ascii?Q?I2/W70dbE8SzZShc9UEMbF+PREz9fKphFWWPjR6Q4t9cmeO3zdsXzoWDEWq1?=
 =?us-ascii?Q?GU0fYVPuQ1Z/GWLQEX+tNynh/5pZfGnGNMcDCZ7QUtRYLZy+kwqX1u7m1Uzw?=
 =?us-ascii?Q?bA37w0dGpUpOBM5QbOKFP/mv7rqgo6NoPUJUn65BOhHht9CJJJpgCvIqHMsP?=
 =?us-ascii?Q?I9Q5YfqWWOaaAqCi4hS+W9H5JXFNs0kd8iVB9vZyM2Zt1P4iDbWbu92LW5XN?=
 =?us-ascii?Q?VO2GrIpHc7IdWg2CLGrleXyOl47pzLHu7QgaF2EsJdBJNbHaits+29BXRbrL?=
 =?us-ascii?Q?TRezdaJ3dV6OkYHgvDUssVmoJ7tQkMzi36tPdhxapdp/Dfy0nVnjAnHx2coC?=
 =?us-ascii?Q?BWmrnJBvksDeulaLf6q4AZHz9aFyq1hESGSXRDIF939u9CH8z/4YEmzXPnJU?=
 =?us-ascii?Q?/iA7yaTZBMSX+BGW35oqfkS24BCxDvltAa9u4gnaeZP2s6Fo+zvOhQ4EZ2js?=
 =?us-ascii?Q?Lq4CyMAVa+G8GNZ8OGzqHsTk1f47IUTDQcsTO2KJ981+iDTStn0IQYPHt1Ss?=
 =?us-ascii?Q?eNgwqzCDB846jtW3M8s2aK8YKecXuGXH0A3yiP+VWP9e/3O2cCeZAVDw+0x0?=
 =?us-ascii?Q?bK41NNDSPEDeszdmMYASNpVeUjUMesSbVo/C0KRDk2FuSyz7DfB6nyvDVgFQ?=
 =?us-ascii?Q?SP69CuN3O0XxI+0jNZdImNDrKWc/X8AxGcWKGchXtrm8OfhAthgXj88TgK0P?=
 =?us-ascii?Q?fpIlBtK3VU8AHBrIlnclGdpOhu7SumOi0SIN0nCPKdIdoAfOBdKsubvI7q/g?=
 =?us-ascii?Q?shvgR0Eg/EMmdKUxtKAS43fRrDlKu937dGnCkFViW4amTNwkjwcqcb7OWBsE?=
 =?us-ascii?Q?UU0KLArMrsPESoOGh7i+JFdKT0euA8UruMT2TVkE9A2+Dz9H2uB25+mL5ArS?=
 =?us-ascii?Q?ua53aQjm2CMcRYUmDzEXWwJutwXXJGkt8dMmIdO9/WECgqxrAUf7Fc7P1GZ7?=
 =?us-ascii?Q?pTk/anE+Msu8o/+8LB/FoA3xsXhoaVZ/0zbq+L9ocZa2BcHZpJLuJT1g+L1E?=
 =?us-ascii?Q?OHnLpTz0gBnKSp8LZtL+MTkf8UbB20htkKjvPnLbS/EYico5l9wsZs/UYbVO?=
 =?us-ascii?Q?gDoFoCND3DKJRbeRTpFXA4NxZCVA/zxc07zvPeunI6mFsZPhGaPiVuRXZw0o?=
 =?us-ascii?Q?5tEJkLyRPERpFhuRhrA3uGBIDupwyHBmzE67uceoUQXa43bbtiMBKTuQr3Xg?=
 =?us-ascii?Q?TzzfMft4XNhxFY7A2vwGr844QUZTJE16IOmpGz8gs294L1s0PXLR4wOFBAz0?=
 =?us-ascii?Q?S7iivCh9fvTG+uh7/72PKr7PfqJM4h5Bvl42lbVREGXSAxoywwXpsyOsuafh?=
 =?us-ascii?Q?HfBrrun9J2rmVJ8htF0VHtRT0WwACVf7iKjZv3vUkvPpczN0Zacn+yswLBO3?=
 =?us-ascii?Q?QkTCZiKZLGSaDmiJYSF3lO0TFD1hT4QOoZVLxiMCfJT/qnA7HrOof5nG8fch?=
 =?us-ascii?Q?RzBMo9BcSgR/ENNhI78=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WqjpcFH/D7K5V7krVPlbMl7oys8ctJ3b9U2AQBElL4IDI5wAzzRgFFG9dtnb?=
 =?us-ascii?Q?mjBa01/96Ptu/1vQzpYrzp7arUhJVW1g3Igc/FgoptVg4zn37v/Eau5wmxTV?=
 =?us-ascii?Q?BFdXQpEIlL/gPipnaZ3luDVJKDZl/2ASyqeJPuGcDUD91UcRId3bZkV5SOOI?=
 =?us-ascii?Q?Wxo3drBTBomWrNUYppSRCPNDYP/5h47Zio4AxHJ9jpHbN2tuqFuFhJxPz0pp?=
 =?us-ascii?Q?1N5Q+myUqnIdf2X1wdwPEYg4OMuzW+cGRuA/4+ZvmY2iVrq+BUrD2SyvG1ql?=
 =?us-ascii?Q?GQfkQ2Yys6orvzOaWUfEifdxx/cPq8TOHBd6S4c9I8b7x4M1C/jTh4aL1uyV?=
 =?us-ascii?Q?6v9Rq9+010sUO/ivAgCYIufaTifOAo/h84ZmqftSvtnon9y81OZzgWb5VlN9?=
 =?us-ascii?Q?lMuZOdnfWCfXlXy9zzQuhu87CYhe7q5xB4Zq1DJRkEtYNilQPybWxaGYzwMn?=
 =?us-ascii?Q?p4JGF0JbUkboDfYtTNxVaBNAIlQSPKjzW1l58zKzxWymGgFIHk2iqGiTPxF1?=
 =?us-ascii?Q?Zk/iUG0oGHp84DQc4Cyna2AQ6lSR6QlNdTu8sHKPX/oUgHBqap2xkdmlQifM?=
 =?us-ascii?Q?tkrMR1q6BlBC/VR4VEv0lp3iZYUxWbGV3pZf1HxrnZY+kZh+57w0QMQeEgHI?=
 =?us-ascii?Q?gdIy3gotMt6E4CIuNi6AcMpXqTh64+VMRignWAxW0DL8L2llDWZ3Zugp8vZv?=
 =?us-ascii?Q?4/9o3AAkg6J/cV02INxz+AS7kA8VuNNuh05tcVqKJDRiroNHLqutq9Zuc1jU?=
 =?us-ascii?Q?RSkqOcOfTZYuLDPzKa9K/tptSZkBWRAz/0qBpcKKAfA3mFl3H8QV9t+DbEei?=
 =?us-ascii?Q?Tu1VLtTrn/lyVQ5OhcAt4ogf0WKOKESk51OMwb+4b0k6FTCcQtSSeTa3vbVv?=
 =?us-ascii?Q?9RrEUd4rUqXFf14nn4/cT3hcgN1G6NlaQKXOq/ZDGNfjyiBxZ1GYJm87KLEp?=
 =?us-ascii?Q?lcwmL6+AscEnCiWeKrtbMyr5mSpl8YI2qEjkptPeBIVaHzLaZKjiYozKlJtL?=
 =?us-ascii?Q?hrdGxQHT9kQi76yX56keA0CBdCQG99udWumnlskaazYDv2WO1rGUaP0V7MI8?=
 =?us-ascii?Q?zkpFaYV6L2BuXJ3T4YhGe9uBoFpCLl2NmnY8jhoR7gm0D1QZ2c8bRWysCCIK?=
 =?us-ascii?Q?GTvXo6Ex7FwqSJK2aY6NUmDfqWe2lMp8vYhGh03WTQVvsZdSnJLNM9RY2c71?=
 =?us-ascii?Q?GoEbnxQoJTzHuwAsudnvbQbJh6jLXjtIvzdsNm7MFHTIscTc2ZTU0O4Kko65?=
 =?us-ascii?Q?8Kc7ETEYKiHMbsVh9cdqlt48Z3IggzaJ/v9dNoJ4OTGPo2cHevbmBsbsyljC?=
 =?us-ascii?Q?03E5fQ3iAjjNh5X1rdisp9llpF0J5+76jXy5fhzl2GaAz8OIaO0f14MUNgc7?=
 =?us-ascii?Q?s9MOcP8h8nRlVh0jzSpz6cdhaPj6e/aDzw5CmvYLdIcy/p3scQ8GnLiCeEyL?=
 =?us-ascii?Q?VCrucCJ5hPFE4O+uH50nk1axL+kPXTYnrKTzcMtX5CX7DKn6PeyOuuxd0GM/?=
 =?us-ascii?Q?q1veCc/J5dy63Jg8oTe+zW2QhWntE5gy8+x6BohCk56mi1XUP2zzkyDknj8L?=
 =?us-ascii?Q?1I19UVJDBcRQUFAIekJKOKzLQNgQd7y9xyJFRfWleWjh6V1pEfkxBTdhK3Ne?=
 =?us-ascii?Q?mVEiB7bU9juNULPcpkU8ECZgZsIN1bu9sujr+L/JDFJxxduiGx6QgLC9CuGw?=
 =?us-ascii?Q?j5tlPuHytK+QpZyiYCA0yyAIExPafLUUkkaIesZ2n+SeQBVUnBJ6su+WRPnm?=
 =?us-ascii?Q?O/fhDvhTbQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bq05/cFLRO1noF3q+VlZzqmyRZ53wu8PsJ3Qvarme4RXJXzpQLF7gS+38fMZgI8axmpMlq6lPEgfam+/FgqdbhlSgJZo82HogCMVqqeStS8Ksf3PTRQaa9+xwlbGNi2DQUFIPZ9IeKFom6h4J3il5fsVltV+hjJeA/U4lK09kzgpb9src9yAf2kEl7XFFKKFuXDp4jWxU6hjOHtDjsr7iz22VU1XlneyEXQPQsMeVxJJNp3wAWVTzan9WFwuULZWreRt8Z74GeHMhyceeo1bPUCX3As0WUWkRN8SQ7cDNiepo8yIDiuOND6xP2tzmA8+93xRQs+sDNnmK8S3q4fgc0TY59IHeNnRf/N54+7JPj89xHAyv6SRrk2PdDIHmbYZHHt7slQvz8thbBh6rlTQhuGxTKOffUE8vHcaSsd2Ph6CYIVDp2YmnO2L6rMTuzsl6H8JDyERf2l7aAAL+Ekl7wyrfYq6jilm698g3EnT0Raz9WuajV5TxGKSA1ba/o68IEuX0DtBcLwj3lnRZA9bmd1PPtFD9DK9eltp0xM+sYDzSBLihLtMvMiN+ZgPbKcyDJOk21AJ03wvN1DMtP5eJaM+TDsujnQt37fM+nfpSiw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64878371-c013-475d-6db3-08de590e1d22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:08.8407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvbxTAnsOSwBPYHE8bthEY1gUnqKANZz0grbpQpMZkTSgcEPBFQ/KL5ds/ABz/Tk5yCGBKphqK2Vlc08qlYxFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=6971056a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=t0zg3OoRVwqkdlAMXQQA:9
X-Proofpoint-GUID: VZ8nKsl1fGyedEmbz6ORs0cWBXEqRGOe
X-Proofpoint-ORIG-GUID: VZ8nKsl1fGyedEmbz6ORs0cWBXEqRGOe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX479EmmyWz0FG
 eVTZBv87sEs30TxLsHbRbHWO2XWi1udVXSPbmZGInqqxj8Ybrvi0vtOEMhwGDl08lw7U9Cg+LwH
 Montu6PtlIUcocxzH4PUWJByN0CCf4FZaacbOfK/9hE3XfWyC8NRPYOsAX6MFlHBDQl4UF9nDAs
 W0nm8idNs9nEqbXK6RT6DS7lyd5/R6OeoFS6SbJem1N3an5bZ7U0cehNmAYXywvmxWq0XR1tIv9
 Ed5YGOnmbZ5W4oIu3WP2PdNAekedmpp4F52HWOyiMCow4m/UrvkZK1PHInCu9rKCHKaUNkgDPXS
 y1r6a2KJVzD5RHTaxx1Lo/pEDf8V/HohxjP1sUP3zJDzX/6yBV3+ZyNgPtYp8heJoOTbR8tE019
 U/+ypRFCRILJIvBGkGKjVBGdaYLD4X0F7gF8T7qTr9Lxr7VKur9jX/QIa0EVPItE8Awugosx6hX
 9o8lZ+nSYFl1Q2rfxow==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1CDBE1C0010
X-Stat-Signature: 18yumqpk3wbgtfy51di8baciwrpppwpa
X-Rspam-User: 
X-HE-Tag: 1769014641-450580
X-HE-Meta: U2FsdGVkX1+CYwjgjBt5f1hN0YWK4Z+F+8hLFjSA1je2xqAw9tVJFEReMMki0jiYBfzK5jWuH7umQYBp7ZTudt3uSB7Gy5tb1WUe6vlh9euNL6NKT4VCWrXviuxAm2EbPKLX9zsakjAICaNPw15F2f8qPvA28Uj/hiIYhbo82kEV6Q4/JP9+ouUFx/Om4ubloIhw60iu1H1kSHLXqFFyh6SkJVhlYJ7YoUr6qdIC9qJkOuyP7Hky9+/Sei9RwGFgSrjxazRwj/jr5DBKj43B21wPnXlaqE6JYY5izUjg2310BXNNiejpIkzNr6HIDiBiuard5F1sfA2x0Tnh2emNtdOFYOd047E+bl6hDXc3NriyiXMab5Qflm3hMAzTH4yAlFep0/o5/O3HPwNX4DEBEOypag3104ibIh2KslJfvUo2Brx4JA/wkj1nNaH1kdjaSLUrBYdXi7vC6AxS6ROj4Sa/mzNQ5rFkXH69hBwRZlzFf0A22EnA5kyzFmo2b0+4SjPjo3YnNEVxInizFnxI5hNB9FYZ4HOJfuLYUjTkjTlfrbCj81CUzMwBDFVwzaPjxk371MGIYFy37dhqil1MLoVqAyctVDkbtMRMbfRyZZ1NlYcgkEX4QKgxudQ7dtDfsjbRXaokAey/RH1GpagykXurpCRzJAemRRYlPSUVidQyTPTvqcccl82oMt6G8lwxuE4AfhucUwcU0xwXjIyj6tQ+qi8rk+rrSLWcztkiHShFzRphmYkhrzepZHc0yle3caIREqwHoC85mGgNvEpkcodEZsmxIQZzoV2In5lbyhoYRF/IVA0zbUHLz449UtAwRod5e/7lRhhh+eb7JNgJcSSMRHLsW0xQXK8eYf2UwTp/GE++OpC8Lz249AjR04uQU8O9aCqUfIT3cwZudHIRzZ+BnxnvTnKVKHlU6xnyG5fcdBdh8kJ/L2IJfhLFl7lyjxjnDb82lA318zZk4nn
 zHuAUVw6
 ZnqaJNMVtj+vjEddb2R+l3CAHOVBybWCyWHhs5ty2H+XZT1J+Dg6AHkQiVC+cM3MnfMXPi/MWzd4u7q+iKKNsIpBMNf2dmbcnbjqtN9Qq4w53PUA1DrgnvnM2z8m+zFPTVN/YjRkPJ8Igyus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Spanning store had some corner cases which showed up during rcu stress
testing.  Add explicit tests for those cases.

At the same time add some locking for easier visibility of the rcu
stress testing.  Only a single dump of the tree will happen on the first
detected issue instead of flooding the console with output.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 tools/testing/radix-tree/maple.c | 172 +++++++++++++++++++++++++++++--
 1 file changed, 163 insertions(+), 9 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 5c1b18e3ed210..85fb5616c133c 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -38,6 +38,7 @@ struct rcu_test_struct2 {
 
 	unsigned long index[RCU_RANGE_COUNT];
 	unsigned long last[RCU_RANGE_COUNT];
+	pthread_mutex_t dump;
 };
 
 struct rcu_test_struct3 {
@@ -33997,8 +33998,25 @@ static void *rcu_reader_fwd(void *ptr)
 				}
 			}
 
-			RCU_MT_BUG_ON(test, mas.index != r_start);
-			RCU_MT_BUG_ON(test, mas.last != r_end);
+			if (mas.index != r_start) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+				printk("start is wrong: %lx (%lu) vs expected %lx (%lu)\n",
+				       mas.index, mas.index, r_start, r_start);
+				RCU_MT_BUG_ON(test, mas.index != r_start);
+			}
+
+			if (mas.last != r_end) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+				printk("last is wrong: %lx (%lu) vs expected %lx (%lu)\n",
+				       mas.last, mas.last, r_end, r_end);
+				RCU_MT_BUG_ON(test, mas.last != r_end);
+			}
 
 			if (i == reader->flip) {
 				alt = xa_mk_value(index + i + RCU_RANGE_COUNT);
@@ -34014,7 +34032,8 @@ static void *rcu_reader_fwd(void *ptr)
 				else if (entry == alt)
 					toggled  = true;
 				else {
-					printk("!!%lu-%lu -> %p not %p or %p\n", mas.index, mas.last, entry, expected, alt);
+					printk("!!%lu-%lu -> %p not %p or %p\n",
+					       mas.index, mas.last, entry, expected, alt);
 					RCU_MT_BUG_ON(test, 1);
 				}
 
@@ -34047,9 +34066,11 @@ static void *rcu_reader_fwd(void *ptr)
 		usleep(test->pause);
 	}
 
+quit:
 	rcu_unregister_thread();
 	return NULL;
 }
+
 /* RCU reader in decreasing index */
 static void *rcu_reader_rev(void *ptr)
 {
@@ -34119,13 +34140,17 @@ static void *rcu_reader_rev(void *ptr)
 				line = __LINE__;
 
 			if (mas.index != r_start) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+
 				alt = xa_mk_value(index + i * 2 + 1 +
 						  RCU_RANGE_COUNT);
 				mt_dump(test->mt, mt_dump_dec);
-				printk("Error: %lu-%lu %p != %lu-%lu %p %p line %d i %d\n",
-				       mas.index, mas.last, entry,
-				       r_start, r_end, expected, alt,
-				       line, i);
+				printk("Error: %p %lu-%lu %p != %lu-%lu %p %p line %d i %d\n",
+				       mas.node, mas.index, mas.last, entry,
+				       r_start, r_end, expected, alt, line, i);
 			}
 			RCU_MT_BUG_ON(test, mas.index != r_start);
 			RCU_MT_BUG_ON(test, mas.last != r_end);
@@ -34180,6 +34205,7 @@ static void *rcu_reader_rev(void *ptr)
 		usleep(test->pause);
 	}
 
+quit:
 	rcu_unregister_thread();
 	return NULL;
 }
@@ -34329,6 +34355,7 @@ static void rcu_stress(struct maple_tree *mt, bool forward)
 	test.seen_modified = 0;
 	test.thread_count = 0;
 	test.start = test.stop = false;
+	pthread_mutex_init(&test.dump, NULL);
 	seed = time(NULL);
 	srand(seed);
 	for (i = 0; i < RCU_RANGE_COUNT; i++) {
@@ -34414,6 +34441,7 @@ struct rcu_test_struct {
 	unsigned long removed;		/* The index of the removed entry */
 	unsigned long added;		/* The index of the removed entry */
 	unsigned long toggle;		/* The index of the removed entry */
+	pthread_mutex_t dump;
 };
 
 static inline
@@ -34506,7 +34534,9 @@ static void *rcu_loop(void *ptr)
 			/* Out of the interesting range */
 			if (mas.index < test->index || mas.index > test->last) {
 				if (entry != expected) {
-					printk("%lx - %lx = %p not %p\n",
+					if (pthread_mutex_trylock(&test->dump) != 0)
+						break;
+					printk("\nERROR: %lx - %lx = %p not %p\n",
 					       mas.index, mas.last, entry, expected);
 				}
 				MT_BUG_ON(test->mt, entry != expected);
@@ -34854,6 +34884,7 @@ static noinline void __init check_rcu_threaded(struct maple_tree *mt)
 	vals.range_end = ULONG_MAX;
 	vals.seen_entry2 = 0;
 	vals.seen_entry3 = 0;
+	pthread_mutex_init(&vals.dump, NULL);
 
 	run_check_rcu(mt, &vals);
 	mtree_destroy(mt);
@@ -35250,6 +35281,8 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 {
 	unsigned long i, max = 5000;
 	MA_STATE(mas, mt, 1200, 2380);
+	struct maple_enode *enode;
+	struct maple_node *pnode;
 
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
@@ -35410,6 +35443,128 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	mas_set_range(&mas, 76, 875);
 	mas_store_gfp(&mas, NULL, GFP_KERNEL);
 	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	if (MAPLE_32BIT)
+		i = 49750; /* 0xC25B */
+	else
+		i = 49835; /* 0xC2AB */
+
+	mtree_lock(mt);
+	/* Store a null across a boundary that ends in a null */
+	mas_set(&mas, i); /* 0xC2AB */
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.end != mas.offset);
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	mas_set_range(&mas, i, mas.last - 1);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mt_validate(mt);
+
+	/* Store a null across a boundary that starts and ends in a null */
+	mas_set(&mas, 49849);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.index != 49846);
+	mas_set(&mas, 49876);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.last != 49879);
+	mas_set_range(&mas, 49849, 49876);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	/* Results in 49846-49879: (nil) */
+	MT_BUG_ON(mt, mas.index != 49846);
+	MT_BUG_ON(mt, mas.last != 49879);
+	mt_validate(mt);
+
+	/* Store a null across a boundary that starts and ends next to nulls */
+	mas_set(&mas, 49800);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != 49800);
+	mas_set(&mas, 49815);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.last != 49815);
+	mas_set_range(&mas, 49800, 49815);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	/* Results in 49846-49879: (nil) */
+	MT_BUG_ON(mt, mas.index != 49796);
+	MT_BUG_ON(mt, mas.last != 49819);
+	mt_validate(mt);
+
+	/* Store a value across a boundary that starts and ends in a null */
+	mas_set(&mas, 49907);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.index != 49906);
+	mas_set(&mas, 49928);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.last != 49929);
+	mas_set_range(&mas, 49907, 49928);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	MT_BUG_ON(mt, mas.index != 49907);
+	MT_BUG_ON(mt, mas.last != 49928);
+	mt_validate(mt);
+
+	/* Store a value across a node boundary that causes a 3 way split */
+
+	if (MAPLE_32BIT)
+		i = 49590; /* 0xc1b6 */
+	else
+		i = 49670; /* 0xC206 */
+
+	mas_set(&mas, i);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != i);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	enode = mas.node;
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	MT_BUG_ON(mt, mas.index != i + 6);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	MT_BUG_ON(mt, enode == mas.node);
+	mas_set_range(&mas, i + 2, i + 7);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	MT_BUG_ON(mt, mas.index != i + 2);
+	MT_BUG_ON(mt, mas.last != i + 7);
+	mt_validate(mt);
+
+	/* 2 levels of basically the same testing */
+
+	if (MAPLE_32BIT) {
+		/* 32bit needs a bit more work to fill the nodes.
+		 * The two parent nodes need to be filled (they have one space
+		 * vacant) without causing a split at the store locations (or
+		 * the siblings).
+		 */
+		i = 44426;
+		mas_set(&mas, i);
+		mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+		i = 45126;
+		mas_set(&mas, i);
+		mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+		i = 44790;
+	} else {
+		/* 48950 - 48955 => ptr, 48956 - 48959 => NULL */
+		i = 48950;
+
+	}
+	mas_set(&mas, i);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != i);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	enode = mas.node;
+	pnode = mte_parent(enode);
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	MT_BUG_ON(mt, mas.index != i + 6);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	MT_BUG_ON(mt, enode == mas.node);
+	MT_BUG_ON(mt, pnode == mte_parent(mas.node));
+	mas_set_range(&mas, i + 2, i + 8);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mt_validate(mt);
+
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+	rcu_barrier();
 }
 /* End of spanning write testing */
 
@@ -36029,7 +36184,6 @@ static inline int check_vma_modification(struct maple_tree *mt)
 	return 0;
 }
 
-
 void farmer_tests(void)
 {
 	struct maple_node *node;
-- 
2.47.3


