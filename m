Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB5DE7315A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E996B00AF; Mon,  2 Feb 2026 06:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F166B00B0; Mon,  2 Feb 2026 06:30:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1ED86B00B1; Mon,  2 Feb 2026 06:30:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0C266B00AF
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:30:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F74ED53AF
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:30:48 +0000 (UTC)
X-FDA: 84399299376.22.171D4DA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12AC9100016
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:30:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jfLRtsJJ;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bhqznOUp;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770031845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNAnNRIkVr2VlIS8vb1YHsEe1UGwGuPJhYoSDjUCAGQ=;
	b=hoL9P9Geo5TliGt0Mha16HTEsSBC5/yiw2bgL/QNRSU/1dGyc+8WAlNHVoEN9FE7KxEV/X
	7v51yDtym7Ox36/w82OC2IOv8gRp0jv55ve9xoag7Nda4qUqvpnPwYo089ztsuB3bsB53z
	4nNlTHDjZUfs8Lenq+yEY5UDfuth7JE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jfLRtsJJ;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bhqznOUp;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770031845; a=rsa-sha256;
	cv=fail;
	b=4zqXamMGmAsRWdlALqdH5ZNSOT+J4c0jCYkHupJJiWGr9yKhOfmglqpDAXhUuHztXfwXu9
	cA9W9WrViZ6Y7aIIFjVxVo59M10a+t3m/m2RQi6wuYfftX4NQY7ql6c/5TJC0C0sDBDrj8
	QfF2+pjwmYhkUh26aNGPv59GgJicH1k=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128wk5q943013;
	Mon, 2 Feb 2026 11:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uNAnNRIkVr2VlIS8vb1YHsEe1UGwGuPJhYoSDjUCAGQ=; b=
	jfLRtsJJdL/KtDWTn0yRqOvaq22z3Z1InjFlUw4uDFhB/2G/7qQehkO0OH7Ne7ZH
	qPdvylUGQhGwRzfR44cj4vMnehI8CYYSZ5j38a/1bzDQV/0D1xHnNGvC7NylEuhb
	Klxgbhredt/xZRU4YVg/ITzchiFEqct1YgoSSHeqTQlc+zVhTuzgF4K7Lkai0l9w
	Hy8SRD3HtkEy48xHOE/ndjF+kdvn99RH3jhXaNckKS7/VMC1dAt1S2FPYDCbd3pT
	dnixLEapOmW5p8QYymv4RosIJOjs3wUYj4XUpwRx8atf/IWFsbHCOeTNRxICaoap
	gFpKgSeG39KooDnxY9sFXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1arkt2vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 11:30:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612AgWqD037298;
	Mon, 2 Feb 2026 11:30:34 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010020.outbound.protection.outlook.com [52.101.201.20])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186899ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 11:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JKBakDV2Ws2rMuw1/MLvo25F73uxj5CgKFlu0yyYSDmMmKbnSzt1AU7fG6rhIo834cx+sum/ILLEXo0W3WTbYxy7YZDIAzcNENZDoruQLFmcKAplg4aPsDwAUxfa7xL4WcnMgwc5wG5eybk3yRxCEnxHQcW26paVb4dwDLQrrDY0NteYHelOTzyOzGWsP5k6RfLsrv0isYf8eeabWYN5YteGVDnE1ngCpcCg9d0qVFhoSDYhuRhlmWuYta0qPKQiOLWYxnLuDyJ1TAOrg/zPUQrkZ+Dppku4q519JzEqbb8soNnqe2y0TZOdAZPiua2LvRllh1taDsZYhUhk2QTGIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlzGKlq2bidqyfwLw1oao7GDJsint0ZDG1RLbWaQeQ0=;
 b=df7GzOLzq010EUQZQDp1mmBX+IMUGrVW8TpA8A7q2gdqysbeYF6DyhLp76Al/Ox2bzjis6f3Jfe1w4utVqJG7i0NfublKFJ/RRlZxswHTGkhbuVbSB47hx3XhJmVuotKDRyqkuMdSYrVM0YwYqPkSUkHgH3V5ZxReEZHFVtyfIznEog2hDMQf46W9hWfMej1x+aN2UY3guQvZ8c6289Yp12KJ4d/rTdBD82h8CLdoXdfNXnxoCSXO5Awb+8iwA8JccK2hZsPSKfzKKTdef0ytF/3r0VT248npJf+B0nxxwxu9AQ6zSTbhqXaB/EndIoferNzJ+IE8lunX0wNiM2hOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlzGKlq2bidqyfwLw1oao7GDJsint0ZDG1RLbWaQeQ0=;
 b=bhqznOUpxECTyGaH9nTj5LEbAcXQ2XG2ggCTWhN+mwo1WO2kY9c18/BxoCTRE45UWyt1Jo/Yfl5KTpwW3sr1YKwd2OfZRjh2Za0uesvOexrXgZjtp3g8zshCnJa6UCgYf/QbQ0Y8CzojDyPmO14LO9jz+gKcsbg9CaKuJ29ro64=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB7477.namprd10.prod.outlook.com (2603:10b6:8:162::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 11:30:27 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 2 Feb 2026
 11:30:27 +0000
Date: Mon, 2 Feb 2026 11:30:27 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usamaarif642@gmail.com>, ziy@nvidia.com,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
        hannes@cmpxchg.org, shakeel.butt@linux.dev, kas@kernel.org,
        baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
        vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, Frank van der Linden <fvdl@google.com>
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Message-ID: <7d246914-6077-4dc1-bbcf-8dabbe6183e7@lucifer.local>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <a0c6c8d86ea05dcf5ff96a9d48d6ec79948c88ee.camel@surriel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0c6c8d86ea05dcf5ff96a9d48d6ec79948c88ee.camel@surriel.com>
X-ClientProxiedBy: LO4P123CA0129.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB7477:EE_
X-MS-Office365-Filtering-Correlation-Id: 36845bb1-f558-4756-a21c-08de624e76e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?W1SWcnBZRI1q7RZ3yO2F1hPCKHDW3bqGM1fPbPOkUSRFIShItBG8VAG6Tg?=
 =?iso-8859-1?Q?sE02F5lX+UNDOpkOwpz0q5Wwctm6XrxTGMNFwbLaiRGnmrDHoqjS2CZSKy?=
 =?iso-8859-1?Q?tnTfoF7KHxydTa7+W/c4VYx2kx43nBRw3YYnHoC5QXywCaFBpL1H/E/FbF?=
 =?iso-8859-1?Q?n19nqSkh1gVvJZiFGbqKll4/wM+kgSY81CVeFOscNwq1t/s1x3z3Tgapgt?=
 =?iso-8859-1?Q?EJSR4cKbs4RbIWxKwoxJWsEYHvcdj3fEYeqmdxIrUNw/iystzEJR3CdMDs?=
 =?iso-8859-1?Q?2Q0ujR9YQlqGq8kcKAtUKQMUJNFz2sQv65uuLLQuwrgCHZ/1WXIt0IBmvB?=
 =?iso-8859-1?Q?Fy6d/g97jZU/fkRknzQDWP5oq6q+Y/xqFD1tDw+RqpA+0iiLl0n/vNXyGp?=
 =?iso-8859-1?Q?Ul2Swhe7slBliJJz0NwLKxPjmwuj875kwOy27zZsx/J/wQryNA+3o2/cbk?=
 =?iso-8859-1?Q?u1lCLQZfRHiI61NJA+ZwS4sYegEP891CxcfFLDrFdfeWajJ95GpVAcYB+i?=
 =?iso-8859-1?Q?DxNCNCPgi8+ZTpAa+g945RypHpju+E4qyV3B4NQUYn+tQKoWePdvvXFAE6?=
 =?iso-8859-1?Q?Cv+JznsoulLcVXY6Kw31INZHiyN8GEfOsbnSCUdTyDW3pVmRqBa1U6T7/v?=
 =?iso-8859-1?Q?82hBFHFYYsUaF4bpG9H7m8Wfk8fqC6gF07iBiduUF6o81IOJp3M8Rz+1hP?=
 =?iso-8859-1?Q?5SO11dTUjPHjBigH1xqZhuxg4JYNI4FVtFjTnb+neoBhk/t/l9mOnCe+v7?=
 =?iso-8859-1?Q?gz1iAy+2QqUAHPRVapVKAvlj2sOhCRrDLYMcn6+/LBAE8gTC21YwTKEOj3?=
 =?iso-8859-1?Q?RHywRSYerJJ37dgIrDUSe796uPkkxhfKM+fY1L0Q0hetLWtpKEUlma+MG2?=
 =?iso-8859-1?Q?/OyR71ZnRLsrmOLo8jwO4dTJv6X2fYfdBnwPtYDoZmBCMyE9zYaQS921qT?=
 =?iso-8859-1?Q?/TZ/4bJjCc62sxiU2odCoJjE13BbPwwMt3VvYw51jr44mL2HtXKr9ki/Kz?=
 =?iso-8859-1?Q?cCGSd5d3ovMKEIPIT4eSeh0ki5lh+pW+0AO3ztMP7iUOLi9K2/D11qinXl?=
 =?iso-8859-1?Q?7B9R5rWlxy+97YxKfsSt+LHNZKXY78yIoRRt4K05pCJIKqW2ndAOVIAk0G?=
 =?iso-8859-1?Q?lbOP8E7h4e5Qbv3NoLLLF96kkjBtgfhJtgtsI6AdYVRZlUiM9AeRgYUqnx?=
 =?iso-8859-1?Q?ROcvckRAvL4v+EnnctNyEHrK+smfV89s83LqZX3JaO9aQ4cjOv6sRwzf+Q?=
 =?iso-8859-1?Q?yJMFmhinLHnm3jKUyFjFs4nR34uSAr/k+ZZLhzh3uOWLN45uXCPjEoh/CJ?=
 =?iso-8859-1?Q?0BRnyVrERwwlETTQHmHheg6VZcrKazid2RtVjXatNKvKVx8EaERkk5eCXj?=
 =?iso-8859-1?Q?EyAKS+iKxRGSpiaeG3rJJS7GshFwoq4ugCQDnH+fBvz2eMcRsoQbDG0B1C?=
 =?iso-8859-1?Q?BrR6EQ4wVKNqkJxMJF5nnS+xf8K0LWQeNKQx/LO/rr1BCgb/Uu0puHkk3P?=
 =?iso-8859-1?Q?RxZfgQ/MxlDfjTrYPRwBTty4Md+F4vxaIKJjUeIQpq1JcQaEsL893Bu1ia?=
 =?iso-8859-1?Q?lrJNUzgvu/iSRcowFx3uA3S+ovt5EPn6sDcvhCqM2BKhqmn3wU30y5rgga?=
 =?iso-8859-1?Q?vZxF1v3gBwyx0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?Kdo8p5rMyDFyWzATztZmKEn9Uuh1jWU27CWNdzYA77iqEneiJJc9vc4ZKa?=
 =?iso-8859-1?Q?5Y3xiUoxhmNwhrDWJVCpV/AX+K3MfXn/V9qrb7cJqlkbzpmOWfMB4lZpme?=
 =?iso-8859-1?Q?hNWQ743T7zSiHIUWHAhDa99ZZRr8nLWFJmDlLwb3+pI7fujNn/43sRKV/u?=
 =?iso-8859-1?Q?2RRdhrZkDAo9nbfYFsm4ageAPnKUwaWAdfvX3VJ7YmAaIP1/P0vCh0iyVC?=
 =?iso-8859-1?Q?7ioAdN6Lr92FsCQFOp0959eGYhZ172zrOPioFJi441/mGXO98EacqFiyL5?=
 =?iso-8859-1?Q?fBJqoBVL8YDMVgpTGwVWXOqQrItVmzkLo3YsfDLjtWfg6Inh6DEZg8Mr5X?=
 =?iso-8859-1?Q?yzxC8hWOln7KAYM4YwU71ekga0kMTGsGFo2U0UqaVnxkBxrHMntbpSj+H0?=
 =?iso-8859-1?Q?NgjTNYF6KYj/VCWBkQj9qidWY0Ddwn4suVw2+1n2lVOP8jeVac6VrLCjKy?=
 =?iso-8859-1?Q?Q/NmF7wwFCPoeBH7qdgfYV6wp9Z5wIqx6QR3qnqXZHXXXyqFxH9v1eURqZ?=
 =?iso-8859-1?Q?Sai6FtaC+G4iMJyEJULfR5f1g6zeubEPlWe1bI8doynpDrugfyX2A+eWTB?=
 =?iso-8859-1?Q?BcEzOw4iil18HmflsSJFvpIZb6kHuaFtS+DMlEoxaB4OwD/XDlDx0SsD3k?=
 =?iso-8859-1?Q?YkHtpEvA5ZM9nuywKSCTEg7O/Wb2vNs4nqkMFgcqvfBuOu4AANYajrdl2F?=
 =?iso-8859-1?Q?5fCwGXaYNBXFGTmfOq9UoipCUSAoC9HeubgJgmhGhbTuOW+mhLK20afp3z?=
 =?iso-8859-1?Q?Fv/UQgnqeyjxug/ylPUfS75lK3mW4a2x36vEAoOHlpaAzlxlW0ROwo3IsL?=
 =?iso-8859-1?Q?JIW9g0YlsZNq/DlOMAZBv0UtrIngnLJCaArhhfofj4boZXj4r2O3LLHqAW?=
 =?iso-8859-1?Q?hQi1XiHhMPAf5HbLAWFpyhI0IYhDIxoxCHwihFpf0OajwHV6YpQpaQ9Afg?=
 =?iso-8859-1?Q?9UJWTtT0PLsOgUxGDPooav4k3tCBezQnteOV+vSczGqcWVtdNAsdwOymeV?=
 =?iso-8859-1?Q?+OpKfgrdlCKGlTVE3sIlpA1JGC7SWjNpwrYHRsvQDuKc9NFReNt4KRhHMy?=
 =?iso-8859-1?Q?idA4mJ4ZQIAhdqHR55OM1lK+u42fLi4+w14xfW7S8TVI537WfInPb1TeqS?=
 =?iso-8859-1?Q?F3Lt7q9kTlV0Mj/E204GTyKUKX4CmdJpPWfXBw0nOUOy4oswTe2TTu8MUW?=
 =?iso-8859-1?Q?p4JebXFCLcPwkHeicpKXFu5EHdzaFkNVgaFD1l+XNm9vqVz2h3aMkBbQOI?=
 =?iso-8859-1?Q?WI/U6LUrmaLYbrO1B9PPAUYkAiB5SLYS5yq1zCyq/9g3CY24uroR7AUSom?=
 =?iso-8859-1?Q?13T8yrHtadAGm9GvJS9pNKq7KDkBrSRdbKT8TK2/iTPQzBwbo+zBVOyBZf?=
 =?iso-8859-1?Q?G3LDLJjoVJ3Zsoz2szWJBZ0OzAapFGudpvmw56h/W0sxjedBttVjNGztTM?=
 =?iso-8859-1?Q?zuIIrgUkCVrfKe2qx2Nb/q5W7l9oikgm/YGZhRHwR/UQ3Svxy6os4A5JEy?=
 =?iso-8859-1?Q?2t9zh1c92EkjsDuu7zPTD1Q9AhQKszqMSRXiPVYUMKUuaO76Xt1pr6akxq?=
 =?iso-8859-1?Q?i8Xh4VP+/zGKx8TVhKUhDz1kG/ldR8lEMlWj0ch040SfH52PrTvv3sUWEB?=
 =?iso-8859-1?Q?WI+2lCUQn1Qs0m1dbtJu3O/iLpz5y6j3MenMY5pEHR/EcesaJXXtYnkLJA?=
 =?iso-8859-1?Q?D+GQSOjogPNOhPsrL8L2TRc6UXAIUjK91pxH5RKDbiDSHl/a2+BjPtbezu?=
 =?iso-8859-1?Q?J4lEuH11S1xhgiMXPtqPMy1ZtPcTrC7C074xkYtPZ89Or8RW35akWhFXXy?=
 =?iso-8859-1?Q?0YLz6jgswcxyDso/ymMl4GnA9J5Fp5g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jx97RnK0G3dSe+RN6GPqhVgAJ849gh0mNJVrjkoP/HRFVFAtHGpSRYr+6ObBIciEAK2RFu4wdIoKlPiZvNb3/JIwg0eBIaTM2UKxXsO+BzEZk6cujekZD2pXAD+UhKhqNA1jnHh3ZItp1ZRaupWWUSfUGYbRJ6N+7KmW+zY7A0EjqV0g0+1E+Iax4DHTxkaPVAMCE76baaJZNKW5ZUYrXAUu7wkZ7UKVAZ0+RDk0AlUrTuKvbO5wylRc70cvO1f6uZ3APRawwx0p52F/p8xBxD/EjRMJ/dk1rswNFBXnZsBGu0BOGpCouLD8jaoQYohB3Hlc2v1zp42wp0LDDP3MGwFwRjPP62NFoffVOR9acKBSZXyXWk+awz9uoVKkNv1yiP62LeKrdY3PDpgFKoCxRbyYbU24y4dUwfgrYCGzvxZotFRaiBsHPo9e5t0zIXEihJSobEI3BSls8/5k+Ww5mvDpJ6zQDzPhun0QBb3h87GV2vT3eFQs7T311tC0ynIKVU+44Ku3Tf+l+Lk31hky4wzSsNYDZUAvNx4FCj80GZznxkCP9wbQn7DgroTFd7sX2VU8jQRFBAMKjI2JJpkd2pSCdiox6qmJfgq/Hpj68KE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36845bb1-f558-4756-a21c-08de624e76e3
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:30:27.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oYXcamRzgoc7L4uteZxxthFenS232Qcr9H99nNIBy8pB1NYeLDasBm8Ea946zFu7iSf/rzuusF1BW+OTMBnHe+FlF64gU8VQNA8sGEfCty4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7477
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=749
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602020090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA5MCBTYWx0ZWRfX8FQCrMhpD6on
 QAK3Co+ySGMfultav4m7hvoaeq1xdlRsYRAViyhcaUNnvFqBp6dHQmm72TiO2VR67x1H8kSsOg8
 6Ii7f9U07AUeRvkq/c4Fi352pzG/gztOPOMWVY9G1EM0vw8zkifjGZIUkxBkXrFHhHxx37bPq30
 wyYwX5hn7K+lMBH3oday236BMhG81AAbO36/yo6NF1jY8ocQHicsG9n/JqJFI9T9hfrPP1LwYV3
 dA8v9r5Ktq1RDuDiQAooYO3wwCUpcf+SxzJIixrsFjJ/L1UdvjfYnczbMr/GMvS6yEhTfyLVkW2
 PSK1kcJBRWXmfrpVgrGKw3Rb4yaPZpPYoaxXzdc/nfGBsJGqlNJmwq9i72OTduFYtCW+pVlAfbt
 JhMAXA4D4q0DKyFrl8D1tGgzhMh8WN2bdqWLYzWRbHD3j9VDo922G2H5PMx0H4/xb7o2eJMlZNp
 x3mBTJv6Xu/DOOGlrxQ==
X-Proofpoint-ORIG-GUID: IvhdRKhTfZcAgs3QOO_T7yNKyEqXxyC8
X-Proofpoint-GUID: IvhdRKhTfZcAgs3QOO_T7yNKyEqXxyC8
X-Authority-Analysis: v=2.4 cv=VfL6/Vp9 c=1 sm=1 tr=0 ts=69808ada b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=D19gQVrFAAAA:8 a=OfwHY_D1PFdm6tJENCAA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=W4TVW4IDbPiebHqcZpNg:22
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 12AC9100016
X-Stat-Signature: uinkb8jrfnefn75ugjdcgr4kkgpxcjpp
X-Rspam-User: 
X-HE-Tag: 1770031844-994137
X-HE-Meta: U2FsdGVkX18xQNEV1qV0VpICcz3hlIzQtzbv1wwH9DQt4HqDDSGKzYmvq+EzLYkAlCcE/EWoKldriYmP0kJNIFGC6u7baU6GuTK5SBw18CQs3KW2Qv/8fZjp8z7LQHqwSzwN4N+clxUQD5U5c5DHXxooz4XGHpzaLcbqIUTzqcXs+RGrq55G98Akeb1NnryQSqBXpnLMED6RvaMtXFQrfI4y3H+I2R7UCksML00KD9qGWNTLnvthzpxZyAmyRfDDMg2jHxkWkXGaGUGL6DesFM4PBcC+cytMNnSkExd5EtCwHvNAT17WG5UKQoTpf56O+u74KW4qyrkgrX94aNkgHNDu9gtMCXSq7voOW/wUGcvkNvXswWJoCcM6Bii8o1zD/zyjUoclQ7L4F9sN5d9rchpb5G6EmGesHT/Z2I406d1UsGk2VKMhCQ+S9JNqL0dy17Tb87ihSZ+CNAtBGGgYVpk+IOj8v5e69d38ce9l5ua+tLQW6XMSUCOmfItRvQS+A14a8p1lxNZJByIVgb7TZWHWpPzksEl+b5KeDkSrmC5c4UaCp41CwPQ7ddxbnx2/zZ+wGs6RjZ6oyTN5Ry95gMXMxr4FqVbWn6avoE2Xa8qcF8jqN7bwf9DmQmuhYJHFHXiwgBNJYZWYKiS1FGPu70PramqdcwZ4/WW2nW0Tz0uiAiGS2hW7K0ZFWWycr+2RJxJCsXeq+fdxejzz6zfY/R4uCVoEv6JY9kYTx2sBnkKrKDpwvRG7bf5Bs/+BiHCMH3bmN5Y4JoQTxSmzvx1VUTLi+B4DhZ4TA130kid7cnlUaJoLUz9A1/dvjVJgpjc2iS84VTWsYobANRwaGg3KVvIAC+O8fglujfW1QCygySQtD86JoasrqfBVx9ng6n5ltSpyoz2MzbxIzVisF/vwEL2aRF27gNSFCm3bjG8bz7qzeCDHcwhJzL34ECGgJtKlDKsLGQN5axo7CWZdsWh
 0vd99Qwy
 TZSsC8i7zrnNIf7rgKfDzdy59ksp2fP/znAvYRNxZRYeNBnYFHILbiIThQr3SMFRUL8bPOAxbzXSoglJx91NQLTrNAzP6+La9i340hUIwso39AbM8JJ7pEj3XOjoj0hJnbUAqArM/4SSXmZ8up5Llvs93hZQPc2v8l+t6j4D89affOIjhcMhgWMsEP/AIHsdJ5YcsLtMY9JDpUaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 01, 2026 at 09:44:12PM -0500, Rik van Riel wrote:
> On Sun, 2026-02-01 at 16:50 -0800, Usama Arif wrote:
> >
> > 1. Static Reservation: hugetlbfs requires pre-allocating huge pages
> > at boot
> >    or runtime, taking memory away. This requires capacity planning,
> >    administrative overhead, and makes workload orchastration much
> > much more
> >    complex, especially colocating with workloads that don't use
> > hugetlbfs.
> >
> To address the obvious objection "but how could we
> possibly allocate 1GB huge pages while the workload
> is running?", I am planning to pick up the CMA balancing
> patch series (thank you, Frank) and get that in an
> upstream ready shape soon.
>
> https://lkml.org/2025/9/15/1735

That link doesn't work?

Did a quick search for CMA balancing on lore, couldn't find anything, could you
provide a lore link?

>
> That patch set looks like another case where no
> amount of internal testing will find every single
> corner case, and we'll probably just want to
> merge it upstream, deploy it experimentally, and
> aggressively deal with anything that might pop up.

I'm not really in favour of this kind of approach. There's plenty of things that
were considered 'temporary' upstream that became rather permanent :)

Maybe we can't cover all corner-cases, but we need to make sure whatever we do
send upstream is maintainable, conceptually sensible and doesn't paint us into
any corners, etc.

>
> With CMA balancing, it would be possibly to just
> have half (or even more) of system memory for
> movable allocations only, which would make it possible
> to allocate 1GB huge pages dynamically.

Could you expand on that?

>
> --
> All Rights Reversed.

Thanks, Lorenzo

