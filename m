Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC07ECD6F8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 22:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0CDE6B0005; Wed, 11 Feb 2026 17:55:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAD96B0089; Wed, 11 Feb 2026 17:55:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72296B008A; Wed, 11 Feb 2026 17:55:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B25856B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:55:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27006B9AD6
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:55:02 +0000 (UTC)
X-FDA: 84433682844.23.991270E
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4B6AE80008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:54:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=itSvhTyf;
	spf=pass (imf30.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.25 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770850499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xhxp542lADX2QxvxB63nfRpaT0d8Qi4JSYHEHkrkfGc=;
	b=2Gbbxn80F626G+jVCXBok3wh5MulCvWL1MNwENYq33Ny8iBk6+tZynT4PVHWLsDBYKFXMn
	eM3FCdaYG1ZKNPoWAZpxbXJxzEzUnBLet876nBmg5HhGlcKXpwcAfN0rDb09liGVVGGETF
	0m+RnOaYWbaD/lGjMfgFHvpiWgsdX2Q=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=itSvhTyf;
	spf=pass (imf30.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.25 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770850499; a=rsa-sha256;
	cv=pass;
	b=3gkzzQxTpeJZmzom4wbXNSSk1mGE22s8GuS8HNz+D+yEFqCqM9v2Cgld0eaR1Bbt7Y6klU
	eikxb4E8EI0E7qk3E1p7n09KRkmHKfMYrkdZfZ1jpZrPUh9YcVzN98Qt5qTjBkoZD6qPtI
	qG/cf8/LcvbLMksIJM9xyHfFVaZN0/w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YUDqfjEnWdtU/5mf5pdTCGO1NPDO7TzEQADb+zvH/1tbrfqgr6dbcDZzSqOVsQAnzEkY1Qs+3x1YyQUO/FiLv9i4PVdS+QthvWS0lJJkWbHVFznRFFEjk/d7yfR2rT1kkKxJ+6OpkPpX0NtCt6Lg0qNvGlG+IzSie59NZAsSnw2zD7Pzbg3VUful0dYXfhd5UXxEYTfU6uE8pzdFuab5dQ3RaOnCSPSs/OWus0tUz5N6ds7iXjCfV2HBGqnfOItZQoSoVGpeqJZMYqZTT6ac9C3/MwCK4qRuqMEK6jtU6sz4ldIjMBItYuaA2ehvS9NKnOWpexGy9Vw1hi0obLBhVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xhxp542lADX2QxvxB63nfRpaT0d8Qi4JSYHEHkrkfGc=;
 b=ufwL+btGnM8T6RyQplMaCZGCEV1mT+7Qwex4xSwIW9J9A7hYDixcPJrVz4Y+OD5OR0YYXhayOnCay0/yw7o17gjDErGd8wgxGilJ9Woq9DaqMMYsik1FnhQOzdXUaxYoSmqpKQ8psaDtnoPHtM+YzWoZ10tCk3zfIqrmxuat4DsgvNa087EHJKhJRbX4TBO+CL7vFAr/kUS8fQK4VEaQLYYCFkPi3S/eTt5KS8oUWN4GYPtSqBZiivd2MXE+IBoRkRtkSvpj2BHaw/tGTiUKdEEldXSCuW7F22r6cWhBU2mlkXf019eBOAfmKnKs09s0kbs2QDaG5pVBawFmGPnvgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xhxp542lADX2QxvxB63nfRpaT0d8Qi4JSYHEHkrkfGc=;
 b=itSvhTyfEzJXOswfhdsulg9nCttlWO3D8im3GsZ6+bFBm9E/HW8unJBhfOhA/rpYu20/YWuKy6t5T17aY4+6C3L776wXqH9IPtKgS+M/mrEg+OmhuHJpXNRg60ilVU3E++7DrdHy2MZoxE8agdYDpwelzJYs3NUmKN32febpiXMOohXtwRsfmsLxSR9P/MiB5HAKeSXnFW4yxpzWl7nDdCqN+9MTdx3AZA1TZudnlWk/1JdkfFDZ8Bc/iLNGb2YeDjPJeL0Sw42q4c+NLRBOak1GgEV9PsBZCnLFeANLwstPUUu4X6c9UBPMmRFE5PNVmOuJ4+GyBPtfsL+Wu2oylg==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 SJ5PPFF6E64BC2C.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9aa) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Wed, 11 Feb
 2026 22:54:55 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 22:54:55 +0000
Date: Thu, 12 Feb 2026 09:54:50 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Thomas =?utf-8?B?SGVsbHN0csOvwr/CvW0=?= <thomas.hellstrom@linux.intel.com>, 
	intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v5] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <vfviexoy6uj6cifcbyezshgssomgu2f3jxpckjnapx5fzqb2bd@dpcaefu5m6du>
References: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
 <20260211222303.42qfp6rqxxnpfkr4@offworld>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260211222303.42qfp6rqxxnpfkr4@offworld>
X-ClientProxiedBy: SY5P282CA0126.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:209::16) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|SJ5PPFF6E64BC2C:EE_
X-MS-Office365-Filtering-Correlation-Id: 93e94177-2b05-415b-b693-08de69c092bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?2gV2O8FfUj23k8yUwhvFD3w1BS1IvZGcrdt8RHnPPIgjVPbOMPLwRqXg8F?=
 =?iso-8859-1?Q?KY2jFM2qxgQEHsRgmcoUfEf2LjoZXfyN4a7w4VWhmi50kX9OQqHRcIWFgZ?=
 =?iso-8859-1?Q?Cba6C13Ku8h6RI7W5zeUZSSL96KZOroxgrzs59VBdhJmQBbhu5f5FOtbQo?=
 =?iso-8859-1?Q?RxzJ6K2HaEKuPyOohY/y4piQAOMmSm1nI7OqO/mPxs82nyNvIgJImkPHMm?=
 =?iso-8859-1?Q?cFPhxVnK2bLuH8ahrJd7dEJp7Qyy2ITU+9oweTUwqPYH+KUaqbZ8FXc/kv?=
 =?iso-8859-1?Q?LvwXyP6hjafD3J48hBeRcikmbv82iyDome1vBOTj/M2Gz61tuLitf+jpXa?=
 =?iso-8859-1?Q?v94czwcaAywfXzuYfu3PWnvvGzWfekf9kk6B69MMWEBFOTpAVQUYGKjVP0?=
 =?iso-8859-1?Q?hNjc9um/ArVa7Tsg2XGhPt5ZD5nl2iSmIwaFad4vSVE9anMr10d1yGm3Jt?=
 =?iso-8859-1?Q?YOuqXLYJ+GuhyPb8V0x4KI/GOJectY7UMjlPmk2g9lufhPY1nV+u5Bf1DU?=
 =?iso-8859-1?Q?EdVR5uRPQJ1U6Hvo9n99j7lnIzZ9E1IdUv0PXqpBhTLO/RD5NBKt5MC7fG?=
 =?iso-8859-1?Q?Nt6CFRr6vJAFE3ygEa5zrwxav5+mg4VMjIKEjWD/cxCvEOZ4lOcM4t2XLt?=
 =?iso-8859-1?Q?9lJa4moK8VclFR59n7nFZ6P42mtant8b3cBeBUbVY6xPrnTyMllHdIF5FX?=
 =?iso-8859-1?Q?7S8KUbLQ0yraR5f/I4PIgcWsPb7SJOxK+6jJzOLxsaz4XPM1kIxb0BPHkG?=
 =?iso-8859-1?Q?azR6cM19IkHiMJPPlzd5goCBrJS7J5RwJMpNYaZhW2rZdN6kpHa4dnO/l8?=
 =?iso-8859-1?Q?0aOMoAPlno9Wz7wIzEvAifjT9CgWZogPJj/nUEqCwCqmhWpOEe6eOTEQfP?=
 =?iso-8859-1?Q?wmBj8pgu8fgT/KVvnoGrIGDWWEHMG7jtypjGa4cjSH2ikQfacO68iSaJf2?=
 =?iso-8859-1?Q?oISg4fMzR9vr6yS6uSYzD2ubdnneA9XbzuphAzLivDHbq6gazl5uhG59rq?=
 =?iso-8859-1?Q?PxG8/7Yd4dMsw/cBYit7AbAHAhs4uJjArmx9W3CD/EUfAAxQlCWGSU0tkQ?=
 =?iso-8859-1?Q?kX+YIozcLbqEFtqPQx8wAk4qZqiITBDcdGli99qctZCk40JuGXw1BFh5M6?=
 =?iso-8859-1?Q?7SMRMZLDfAb138sPIr4YHEADrzylFqnTrrBm+MhAeW2AKLPzAqkMMP+oAy?=
 =?iso-8859-1?Q?MNQqbMeQ+xaQFC8zkoHTON1KKe7gS1jmPI+O7JZX6VH1zc2kk9w9uAjJ1P?=
 =?iso-8859-1?Q?KrMP9i+8o5AvFPB8Svt1wplCvQhP0d8B3vX6QFZGMYtp/yPywh8ZRIRlpa?=
 =?iso-8859-1?Q?4ueuEFvEbF0RUFKdItOWsnfQ+q0rOexIz/SiFSaYhxPQPEhjcdWH9oLaW6?=
 =?iso-8859-1?Q?hT6phbUyF0lJWunwTN59ldu5NzCSZFhBN16gr4aVA/Y2pqC1p8S1ElbIhY?=
 =?iso-8859-1?Q?neSySSJqDuBM7IUC+2Tn8GnJndXtxI3a3IleszgEXs+5meX5VMl4IxFhYP?=
 =?iso-8859-1?Q?HPuEhKoKC46+OZ7srJqX1D0gKM3GDFp3CfvauEGsZwYBi9d9UBBSsc64dr?=
 =?iso-8859-1?Q?+ZfUmqEYtn+kueDFEeioKzjQ+0gRScHVBvSP6qLHH+hWGAlgM0NljHwvQB?=
 =?iso-8859-1?Q?Fq0EGfk8dHNX2dGYhMoqMvNaoi8/LjLhzwFITkGnvsuOcSJDlwLpCywQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?X8V+eXHutDY95rfJe0pATfXqZ8L7LI3hTbgBut2ynaABaFcVWhAJB4yG9A?=
 =?iso-8859-1?Q?FS/smUg3sCbiuEHNyxPBIDNorIxa/RS09AijMCbg3+mq+rZ95YoK00rgHR?=
 =?iso-8859-1?Q?VY0c1Rx7V+0DzElscUfI1ZdooYNk5w0oUUf1xujzaXMPSBxW6+W2rHTcsk?=
 =?iso-8859-1?Q?cETvy+qaYoOKjmzUXX0H+KkhIdarT4r97yGhQEbtV+FCBLUNMhosw5PV9B?=
 =?iso-8859-1?Q?GRYk8AhJWGNdom4qojnMb8GKs/FCCw4EX4JPEBSrjd3uf40oU4dogzi2XA?=
 =?iso-8859-1?Q?eoYj5+YgFgXbdDrvHImVfM0wZejfR/gD7po36y/D7wkXQ5qLI1GpWGs+4e?=
 =?iso-8859-1?Q?7YQm+85XA9SEpLowDjYVnwbEKDvIWi6C2wKXPboLaYgc0dPlbRkizHJmEh?=
 =?iso-8859-1?Q?KAVn5hsQhAiNJ1RptJDreK+Ukszkb8NK2d7PFCM3fx9ce7RtJ9Im6azkOh?=
 =?iso-8859-1?Q?0dfOLhBfvIIRFFSGgLZGI51lTDNOkUHagr54NIzqAuwn1V1UxpPc4wAtdI?=
 =?iso-8859-1?Q?RSDyVflDshvZuhPY2NparyE6Nb2qgWRj5ZodcmZidTx9ggLT8a/ur5WIPO?=
 =?iso-8859-1?Q?35WxY/TWv0Nh26NIypK4MVK8Ni841xXZmebmveucBOt8aAfdslzTD/Gm99?=
 =?iso-8859-1?Q?3qftYtEOVPdu+dUWaYloSTsUp+hYL1S2fEnDn1VbJqjQW+Q7jwEWjwOlAY?=
 =?iso-8859-1?Q?v68LgDCciIs47YMlwLwbJ+MqHTGQJex0QSxJzYeH+t1RNiPhYVMj6Poxv4?=
 =?iso-8859-1?Q?KD64dnqQ897+D4QMnFQ5SFIpvC9WyMk4J31W/JgTPC2BfKEgaMTw6ritdM?=
 =?iso-8859-1?Q?79kQLAdl/YyQU653DhJn5OH72PRoibD/xJjU0ktzwIGCNx9Z603x4LzSjw?=
 =?iso-8859-1?Q?FQkonwWZnJKtQjP6ZFwrxiPnfsm/T6Vzgqj7UCMGipAf+rsU0zCzunGBxe?=
 =?iso-8859-1?Q?GQnV1uVu4oZBqOYABWmzbeADjsnVcCfg4draATFuZ5foF9azoWnk6eiiBG?=
 =?iso-8859-1?Q?aZu3q6ODe/z3NzKa3h3zh2lmooTX+rvThRXMe1YmfkmZI4d4XikIFe7Wbu?=
 =?iso-8859-1?Q?0Mvx1lFHXGi7gkrhiUyF8EWAK7FyBgKYxk8nDkRb3Y+USnGRVWBt5hdJos?=
 =?iso-8859-1?Q?tNpMHdtEovCMADFlvo5TXdYRI7GHL72JCmfLGr5hZxS4vCHkVnhOaGH0jK?=
 =?iso-8859-1?Q?7zQcuIWu8eoPqUmtQWzmyLQRtvyrTvYVA1BUFcAV7S6Ksah0cnUAz2AT6m?=
 =?iso-8859-1?Q?cqLNqESLsSfOFCxOeB2ZA9k0GIdaLI68Jmr0hU1LS2FilfR9r+LDItHY/k?=
 =?iso-8859-1?Q?+zWZjHE6uj6P/NPoxAPXdTIskiYt2FIFFpVOWl0x5KV4SKsBOGtC9pHlYS?=
 =?iso-8859-1?Q?9OSjC3T7wt+Chz3EGZq3R/RRn/bFXLTnww+jI3FknRcDrlVhDNukL3d0Sf?=
 =?iso-8859-1?Q?o8UfkiLkmNFhIKHF3wnZT7xMUg84jOW0WbUvz6o6SsuCkGuqBCXyoPrg6f?=
 =?iso-8859-1?Q?Z2UbMmV80Txw1XFUCtB0UpwObFNG/C4Qz7VkshI9PsjHCL+Zqtj5w0tG5q?=
 =?iso-8859-1?Q?lRaAyVuGpF7EL4JfXr+Kj//qCxrGWjnOOEvRaK81RfnttzXJT8c22ce3k8?=
 =?iso-8859-1?Q?wp4aOJ30A5t58KVQRIN9cK1b8EQ+e/P2N4C46RQoHwduj8643V+IItDz4X?=
 =?iso-8859-1?Q?CFaME90mMBLndEH+Z8Tq3a0w5i69Hmm3Jg1ZN/R/at6JUFegmGrGBnkGny?=
 =?iso-8859-1?Q?Uv9a8cMs2GwXYjxAf6PFwbLcvRJ6en38EumXebeXu3Gh/d6qfbSFHsIjAQ?=
 =?iso-8859-1?Q?agpHICMElg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e94177-2b05-415b-b693-08de69c092bd
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 22:54:55.1285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUnIkqs6l3A6I1iq7gfckwJELSjX49wCf3NuNc3ckJHWzLx/Gp2aPKkAeaSflLb+pom18WZKUTYgTqJN6anrIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF6E64BC2C
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B6AE80008
X-Stat-Signature: srb8f1zpg5quwch85mdhqs1p4naezwq4
X-Rspam-User: 
X-HE-Tag: 1770850499-307068
X-HE-Meta: U2FsdGVkX1/6bk1moHUznJUCgWjmP96B0sqZNybojw/qORzm/KAX09Nb5PmSoPn8H9nFUmqS7fLsiiNwVrWkonBUTwmVEWyg6km7ps68ib+lwW/cv92h64AziwsDq1Sz1y37wH1u1nKq3uKSdaVeMXUXo4IsOixS7waTPhK6ODo3seOsVyvRNH9/imus1mjkAYGTXPUbNv3VZjLlxX1vagirk9vMj8YQc/6lzoJ1VOCiaE/J02ONgVVePEchrOD6qopEbTxhLJsRz5gW3VvCiE9o22We2gPiukiWhnsUhbyXpGPRv6Fm3BxrAQU/K2zHUWuHHPwFVsYZC6HkC0Oj00JJeV3V+EgQkk+yZJSqxm7CuEE2och/ghDDgJ0AS6U2y1o9sFPuosuDad47/BbQmMg7rNbj6UHUUaD/Hlfed9s4/RWZDq3VxGh+HeIuFdhj3tvMzIEE3YJKRuF348a+sujendx5HgXWFoer3SWWVXWIQcjpRts0YemtGNxAXTsKCTXpp/5nThC25dyX65wPNUuVxc53m5j0qmLtIseM70zVrBHMKtgYc1u4wKc9+ixwrQ0FcxxWGtmCavrSzTndcnKVKWSTCpVCsdm3Ek5uIY4ooEKpSLO8pq730WvzY8789cZZR4oZLGZoUwUa5GUsUORGHY/iRoQ6N1eWhyZi1dH2BKjptF4Y48H/yK96ZpeDs6lWP2fBStwfK8EfPNPGPwBvDm4T0FnuXNRuR8ERhlbGRDW8V43yDRq8GQBYpZbi/BdaImhiNtbNGKiMyDDuaRmiuMhEyTESogvezzC0J6RHJJuE9iJSYV2sblolNDjZXLNaul3980Z3h0egEOn8XgSMNJscNadM7ApSJEWfccD4rxSOtRZk6zJqUUWU2K7Qm5JxEfbFQbSYfSt+GZEj/blemcTKhpj9+Wg12vL1aOI8yHwYn7cAiLTV2Lc2nvovjtuCEPuCt/fvQmSXfC1
 yUoM63EP
 6dRKsH3MUF4pFCL8KLxRMFQtdGC+2d0QNwEYUimQGahUb7mPi9gthXRJXeZqgJ5UXqHp7jSELeB4OIBM32ooNm/sme4cqhCthAW5xpiWabVf8X5/VqvoQcR2nDAOBNtONLJcx1qXSKCb5GUSTvStug7SzMVP1aCTPC/1ARSHttCBD2LmIRnXiPK9HvrxL1p8eqQ6jtlxvv8CEkmzo5YDwoRPoACBNFcUU8Q918Hk7f0QbGwkqZyaqfP5gsqt3eLWisnvyNMV3MpR7edhZjEhC0rRN4tGOoeeMCCCwytyI6aXFTpgG/wf2yIuDvYGb4UIUVJQJqiKhwJE7lPAAaFFaXhQH6DjTEpfaylMzLY/KQ//7PBdRhHr2Woc7SRL/QJIXZeKc2BXHPmBsqNXIn99chD+RDImoPCZU3NXUlPuBh4a482CsD1QZ1v7g9hbvToU7CoKHZAweB13SQ2PpZx1LtCfSekKbtxeSyzo8XyQas90JUJ2fYJ+pHbpLm8HMk/tsbSryYuSVr/Sd0Y7J3oluKJT+lTX9wD+4Ah74
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-12 at 09:23 +1100, Davidlohr Bueso <dave@stgolabs.net> wrote...
> On Tue, 10 Feb 2026, Thomas Hellstr�m wrote:
> 
> > @@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
> > 		}
> > 
> > 		if (softleaf_is_migration(entry)) {
> > -			migration_entry_wait_on_locked(entry, ptl);
> > +			softleaf_entry_wait_on_locked(entry, ptl);
> > 			spin_unlock(ptl);
> 
> softleaf_entry_wait_on_locked() unconditionally drops the ptl.

As does migration_entry_wait_on_locked() so obviously a pre-existing issue.
I'm not sure why we would wait on a migration entry here though, maybe Balbir
can help?

> > 			return -EAGAIN;
> > 		}

