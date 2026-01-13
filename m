Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D6ED2D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2C86B008A; Tue, 13 Jan 2026 08:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2CA6B008C; Tue, 13 Jan 2026 08:05:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5776E6B0092; Tue, 13 Jan 2026 08:05:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 489706B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:05:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF75A1384BB
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:05:34 +0000 (UTC)
X-FDA: 84326962188.23.88960D7
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC76A140003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:05:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b2hWmMah;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.10 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768309532; a=rsa-sha256;
	cv=pass;
	b=HcJJLla2herIeITZgQRUg5x2qk89Zj6F5jvqdw5tj8iw1NdzieqZS+D1QYc0rcdlN5WV2P
	o7suz/OEmov8JkH1THegz+mnGzeikgV/yUKyHOZi1obejxBWlxrfiwKJEQQJjXetxmwqtT
	5lUXcWMgxSKSJvlcip+PT4z86I4IQXY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b2hWmMah;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.10 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768309532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zbcl6c33EIcnVK8ECDvcLnQH18A+fxkim5B7oeY/kJ4=;
	b=HykQejwEZwCVF+yprKB+UTMRqleAwytEs9imb8oG0yy8cjKoGK3u313tdGGqHbZw5uKdZ+
	2x0bzslJLBMH73bIB1qpmpOKTGjTpOvr4Ri5q4zdcRnrIsnnDop3FlCtlbpF2txt9UOa1G
	UlNDI+OWsdtV1FQHVWDDVtx9Xm2YvdQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GyhAcOAycuH/qAsazswN5rSe1lSLs9I74wYxRW72R+lABxZnEwB1BZelwaCnlnJwI9hy7yZbpyFbC8y+xqwbqrqy4h0jE3/OX0ju2VNOlfveOnv0SSrMW14VwOSg1xPu79bf+aj5VYENzbT7G51ZPSR35Sx1mVp3xW6leSt5S2Lc3LQisz0zVQQIETRdqaFvpfIfe4OZxZ6emFdmS4DMr55kjrFviHNIzh7Z96qUI76dvy3AYrPRiZiCE/UVo3yB+SMdKsIjmR/qzvu6uD/z29d3H+9nNbczGs36RYf0FGqbWXg5wZEEdozkuRplimhrt+J/9uwuid7WSzQRBJgHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zbcl6c33EIcnVK8ECDvcLnQH18A+fxkim5B7oeY/kJ4=;
 b=UO/aBroLYxpf0v/aGaE/U116CazJ6FNoNeyLOkBr5hDHLZBTVOhmZRyB0SO7vJtPrImcJ+R/WvUz6upTIdzhkykYA9QwZdZddZwbmz7s04YSibZBQ/mPKErolg5iqyNrCBvdRZeLzUpP/IxPPO1IMCkttp2NGw8X5gV4gxS1+sKwyQAnfEIQoDRlNSK5wabuJK9i0GmnWhlU/FN1IJTxwzNSO5DXbIWSVoOqB3wxtQkBq8fJC2EOY3h7I9y7oihJ78+mgkkuVAZyDZZZD7oaKSk3OSd5rmobpfv4Q7zLhttjUaPlX3NyBvU37Z1M5nrxigAwCnIl62kPLfprvFBFBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zbcl6c33EIcnVK8ECDvcLnQH18A+fxkim5B7oeY/kJ4=;
 b=b2hWmMahwA39hCohKkvFi1GINBAVK3boRVs3uEh+W9xKzH1f84Q+5w0zeNSuyGNZwgBioa1zEITLg+Cee+XuLyQRHc5UVKvA4Az2Y57bUAJaGtPLZdlknygyS9LNcdNOh3IMzK2z4tR3gcLpwIiYegfpLBVGA/yKLXoXwZSHez9feViHon9BCmqq4VqHqule9Y4HEKzR7oXwECOS6XyWSDrLT6s0LYwJSiZ63ShrtfLxTXVBRXwTOHZGc3co7ljD9uZ536mnOkoWl71GkxYdtIwdeymcYDAW+a4pdaTUxOqVzyxmqoiyykCtUzUqGc93MFd/kenzNsOWNRjNPrmM8A==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB9027.namprd12.prod.outlook.com (2603:10b6:610:120::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 13:05:27 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 13:05:27 +0000
Date: Tue, 13 Jan 2026 09:05:26 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <20260113130526.GE812923@nvidia.com>
References: <20260109001127.2596222-1-jasonmiu@google.com>
 <20260109001127.2596222-2-jasonmiu@google.com>
 <aWTJ2v9J-Aa6ykBf@kernel.org>
 <20260112143904.GA812923@nvidia.com>
 <aWYt0gBHxDCKqj9Q@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWYt0gBHxDCKqj9Q@kernel.org>
X-ClientProxiedBy: MN2PR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:208:23b::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB9027:EE_
X-MS-Office365-Filtering-Correlation-Id: 931f04d7-7b51-4c85-8aa8-08de52a46bee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pHMPdC4bp8vZSC1Q3rqf1/prJd7uNfqJqHdvBAJGslSy7XgmTpoOS7U9NNPV?=
 =?us-ascii?Q?fjuprZufElHWFEiHAyq4huZ+PxweoxgxWnCScq7JWz94EDExMrK1ESCHOP5y?=
 =?us-ascii?Q?WL1fFsS38PMo7Ux+SyPXlU+KKLIKVtMsR3OJR5BvjAb1QtSrIXoA6qxeMMJr?=
 =?us-ascii?Q?hiT9K4T+cLUAF+11jqddf+KhuqRvJvjfNjMhuWnkxvMo6qzs3im2ZrgyJqsI?=
 =?us-ascii?Q?t2x//40TKkJxbbuJue9L9hzL6qlawwOUWayg0LMNWnudpBY96AU6to+kdYCW?=
 =?us-ascii?Q?QOyKf53DGs8UK7C/aFxLDSvSaViIBbuxXcrx/chB8fDRkx5iryY0iIy74ERV?=
 =?us-ascii?Q?hwr0+wVWQbKddQaJy9fnILwUb/o+RLPw6R6WeSyBUUPjmm+efNb2BidCYjN2?=
 =?us-ascii?Q?9fMxtukYIGe+Gu6YJl7ZEV7gd23JasIvb5os8d0/1UkJ9QwwBjn8fukmPjxC?=
 =?us-ascii?Q?/CvkxfFUoQkJvwgXBgV97KTdJf5TadhPeB3+9ilfAH2nBXhXCFWIrDZjFPgu?=
 =?us-ascii?Q?i7qCwsqcHHSZ8H/HkkKyW3mvEqGD8dLpWoZLzLqXf4p9kTlL53Rs08JwKvzN?=
 =?us-ascii?Q?nSbzyTAUvePHRNT2q9/k6khyjtge3XCS9bc1/GsBHATHS24fU3rlXAHjeyde?=
 =?us-ascii?Q?nTowE/Q0p9t3o0WlyDRnxphQ4lZj2k7iV2IiI5vHBPBZ7SXNPP/XHTI3HiND?=
 =?us-ascii?Q?FZ3kkYMmU2fFRO6yYbJIgGCTmmUDzGy/8i6532pF1mA04U2l896nnpWwK3Iw?=
 =?us-ascii?Q?qwkEXjoplYokTgMM76YBLKPbYCYMB+uIeC9SzS/8t6mD0eD0mw3nqPk4OJbZ?=
 =?us-ascii?Q?bO9aioBf45z9tPW6gwYrZRr8DFcF0Jz4f+Q6HbSfVIRhVUoO+yi9C12vAefE?=
 =?us-ascii?Q?3WJtFpLkfvkmvlyZ5qhAkGUGwdgSRLW8c4DTnswLC0QdDbRpkHN/ebUoFxuk?=
 =?us-ascii?Q?QzcDFapa1B/uzpe1QoIjHUteuDkl5Xgn19Lr4zkY7ZEV5XNNchZ9Tb62Z1H8?=
 =?us-ascii?Q?+CfFkSU5GHnat2IY4b1BCn0rBUaYLD+2cDKDlPr8KbqCLTEeV/E7IiPMVBH7?=
 =?us-ascii?Q?o9wJbXPuJbaYG8LPmziCp7mCrcF7gZLRuEvC5T0LVE68z9BtU93fNx6M4b5e?=
 =?us-ascii?Q?yhmNqHn6PJGUF3lGMazisizYdJa4TwegBHW15mIhhmSrroUm4ayaQDfLYkrh?=
 =?us-ascii?Q?5bn/kvdCd5LaSgwOBIlx6Pxpz/M8whdGGNXnfp8cPORFKvYuPPNcMiaT2d4u?=
 =?us-ascii?Q?vEfbg+eo8/uBPyxwJQrxMBZP04nptXk5NvRSJYWC3/SEmSMnCs8UPsltqfvX?=
 =?us-ascii?Q?vOT36+ElA1kOwzkqI00wdMSIzMQ5Xb3l11qQM/4+Oc3EbPdkoaNINHJNOhKS?=
 =?us-ascii?Q?tKdTaPSsIq1XVYZ1Y9EeMmNbPWdsiuvTgVzOT0zHcGZtA1gs50hZ7ix71YfM?=
 =?us-ascii?Q?Ohqyzv9nOjN5t/vTokdspnwHcR8/cGSj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EN3X12+Hgp/0aV3YutF/RkVx+QzJ05gO2qdjI3XhWuw4Fe36Nk5LSWHidqzT?=
 =?us-ascii?Q?eJEiwdPtNpQpQ7L6eD4P54meB95Zm/Dnw0YuXpBaUzd210mcgB6X3jb1Q6Yz?=
 =?us-ascii?Q?LqJgEgMVTvwSegbxHHT5xp/geqhBf65Ce5MS+5UDAJBC4vDi4qMrqlFDs+u2?=
 =?us-ascii?Q?6Kdbp9CWDmagtUfp2u/gzuGPumlcuiMpuGu9goa+CY4D03R9UcDCBaIj5sCK?=
 =?us-ascii?Q?lJERRh6bj66woXu7cBMGOusKGKi/qA650AQVtIfHl9vPDFYoGNfd2X8+49Lx?=
 =?us-ascii?Q?Qdk6OUoC8YTsJF/BBZXa2Ji91YX4RT1vtQSubYCq72XtlXbBpFt/Y6uj//tX?=
 =?us-ascii?Q?F7Z75K7Q4X77b27E3+YZlBLmDM1tNQwQYrO3o5K0i7aCfAq2WznQ0nSJx+4A?=
 =?us-ascii?Q?yq52tjNOsiGTNhf4iqR716VWsQ6uLUtTKLkeKwveszWBMMcjWHxnJ2NhE3o/?=
 =?us-ascii?Q?LllneyM8KJqtA+eBbgCw1BeE79GDu6AofqPVZhExYGw03JrDcNJtBydn8H7g?=
 =?us-ascii?Q?lMlUsHOvwir4zxoH7wkUZa7d7STVJDCkDjtbh7aFOHtItvlYIOsgd/ycTl/0?=
 =?us-ascii?Q?YmsIcjaeDuEV2xwmISdQFdI5fW362CnJJ6L585O9vsfKWWFqRHj5ICalIl6H?=
 =?us-ascii?Q?8R1CSbcbEWR7eRtT+HLVJV+vHgR/SO8PI4hq73Wz2+UC9bmAK6DrLLplY8Q0?=
 =?us-ascii?Q?X1vSZT1HFnB5+2/1aYpBfcee622Yy73uMVickJ07BPTG1fF1h9uHFEf49ag0?=
 =?us-ascii?Q?aoR+qY8yg5+f03sTJ7bLFxdig9Gj6arzXGnOvURF6H/WcTTWwz40TkUdBF8U?=
 =?us-ascii?Q?xPqHGeTbECfs3XW3P+0N+C7ahCAqOM/skjPGkCFPiD17kB4xtwtz6j4RZelY?=
 =?us-ascii?Q?MU6xzDxr/Mcvml0iXnXJ/5sv1iihIBaiIw0TzOVdOPsLIRNlBNI3KSBJuHmV?=
 =?us-ascii?Q?YjG+chY2pSeRoRjf++6Gu7oGQgJZNBR8WUTz63SOp6MtJ1oF9UpXIDHLDkj1?=
 =?us-ascii?Q?9L34exBDxzHEeDXC2yct5D8tqZV8Jgf7J1MlqPuuTpU9QydhceA+UQSccrPt?=
 =?us-ascii?Q?sQeNaYMGDpNvIlEaugz7yEBca35dVRIbSQNakj7rj1ZG11OKcx+0HmVMlQmN?=
 =?us-ascii?Q?ct78/SRFk9FYVziNd352qm4eN6LZwjJGQUQyyNsrYGrJ1OfItbleQLn+8DL4?=
 =?us-ascii?Q?L50QpTneos60vlKWHgVPsszYPkamAfBaC/92QXOC6iSDzCARP2Xkp70syDNO?=
 =?us-ascii?Q?YS7IFwS/PuqjWm/HhDekYFGk1MHXZ6qyQkugC0hJQ1ZfWAmfrfZuL+nCp8gw?=
 =?us-ascii?Q?C0mYGyrngttTacByEu69h6IrlDQfekRxJJy8OZvwX91LHVtsYHd9yA8C6+fy?=
 =?us-ascii?Q?C6sgVuNhXdEC8ZiIxZb8VF5CdxXCxEAaArbY+UH9hcn24bAvm+xle+84dbfC?=
 =?us-ascii?Q?AK2Hjb4mrAe7cUIyTF2A8R/EcTs6fTdSexjS2gDnkny8VeJadX9eaEk+aCRE?=
 =?us-ascii?Q?0YArIQh4SCa2c325kuBKIGeE3cWGTt/i0ogep2scEm22ykzJ17F1GjlAkYhv?=
 =?us-ascii?Q?pdUiQksHDsltRhjWNv1V45tpwKkVLEoEKtkBUsUF/PCVCLdR9qnLHKa57C7O?=
 =?us-ascii?Q?7rTlbdXLfMMleJvpP9NbGetJB+JhcUyVTdZtYb4RDcJHagPuiiuvvHaSP6A1?=
 =?us-ascii?Q?Gm2oM9QhMA3IuAswx74/yOjGWmx3TMNeQycTsRUa9CfCuKlkfZ1mn7Op+v4Q?=
 =?us-ascii?Q?xCpxGN7IQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931f04d7-7b51-4c85-8aa8-08de52a46bee
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 13:05:27.4067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFl3YZnORBbAVfenYooJEg9SuJ1SQrDGZfsbhBFnmqBjT8VPueN4pRguTsV5ukJf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9027
X-Rspamd-Queue-Id: EC76A140003
X-Rspamd-Server: rspam06
X-Stat-Signature: fnibaxik6g7utoeqcbkqxr4udaupkp4f
X-Rspam-User: 
X-HE-Tag: 1768309531-768956
X-HE-Meta: U2FsdGVkX19XKn+zaHtXa2grleD4g8SQgb99D7ZQxPbpfz+MuP7EKVGNoLCROBQsfO2cILK3mC2W82kJ+MAnA68IgI8S9y33b7bcJLYrv7XKidWOVV/TWwezIr/p4UGcRmMmkrQSVfGDYjpZvEe5W3mYwHf8ab6kJ1G0I/881YQLeR6Et+sId7P3oB5757UeoPF1pt/IjdTqHhsgNrvGqXA8q1g/X3GruOzbpcL+7sPwtasuFMRRhi549PDqQVQJqWpwpj7PrtO4uxSvCJL7Y5VplrXAYb1li3mUPKraWHl2DaYn4AtVcr5B3KsCTlEkEJQqhZX2MFr7T2YzOWVVMKYCKtw83tb5YpR/X2FwCQBySUDi9UWEtv286Ou4Zp6ULEqJ17a7xC5PK9gR5pRN2Zu5tX8AnCdj4X674HGzleSq4MPd+/JxOllIB1czFyeFuEnuqCFk5QA9W2D1hzwDZVN2zYnUhpyp5yJ6IU9jYqQ6X9ZoXT7tolbpUtwEUAC/R15AX1yYjLJjmyfz2IXTzhWsb5EOOxFh+53pVbik4w8mOmvFLtmYzluwnCiRW9jjurVznwjmbiKjNtpuWCFwtqI0Ffub1bckho58A8q1jZrTuVkZrGk142VCq9Q2THdl+sRagBrM7znBMAPbEKAHkuDjFF+C8ONHCc+fu9+qAJ/AWccrpmlhOBq3VlYoKAVXV+yPQC4JNl7HwAiImwWD2RzcwWYVk1HRUT1OSAxP1O30jLbeNQE0ZYB9POpRWlLTo4qcmXDtacVTynxg0nM6pAmgBQCkg12VLHMQ3uy/eYaW9H0BGqyKVI3ueZO8tVkJJ/dLxs8J/MaHlrTe9EYC0PpocDjDe93eEDx+feiD94KWR8oPOzbuHsCiTl7qrYBkvcgqDkIAfNB49a+boZnDfPxWek+53Fg69xF6JZ7nKOnl6Ee0mfpAZpkjcQ8VaupY8wJPGjkj6magq+q98tc
 EbjRwgkG
 Ew6Zstf4vb5WoEc0L+Zj0ySdlQqIMSgUJvgkugYyWVaOpm8KeR1mySgIl8apDgqABnxJhRaaCTZcdTsUYICX63hT4WpWgca1KwtzRsVyuQxr+a+wrGsiZrQO8cwaEkAaZ9EowdcTUZRjnPIj29PbRi52t7upYdcjdyhHfLyhdvXplxXGNgEq/toJ0xiALwtRj2z4QO6eDTj33P33anUmSKv10/UHEW8EcZ+dSf1T+ZJhkzqMjYS8TIkuOtbzb5RvqB2dVRmbBJeVrhjL+ex925jRx/6RTV9IP7tjcXfqQwtfZ93yq9fLEJALjV4Pu9I5pxmC8g6dThkVd2WeiU3rNprX7faU8nh6xeo+c3QbnznhCb7LgZrjTZYWGyMBsWgJm7+e1Zr7toljNAXHxPE1+g2JQmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 01:34:42PM +0200, Mike Rapoport wrote:

> For example mshv intends to use kho_radix_tree to track the hypervisor
> memory and there unpreserving will be a part of the normal flow.

I do not think this is a good idea.

Nothing should be touching KHO until a kexec sequence is started. KHO
calls should WARN_ON prior to this point. If a kexec sequence aborts
then the entire radix tree should be discarded and it should go back
to WARN_ON'ing KHO calls.

Jason

