Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56429F31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CB56B0096; Thu,  9 Apr 2026 11:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71FD6B0095; Thu,  9 Apr 2026 11:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0FF56B0095; Thu,  9 Apr 2026 11:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9155A6B0095
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:11:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29E3F5A968
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:11:38 +0000 (UTC)
X-FDA: 84639356676.14.DAA0275
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010068.outbound.protection.outlook.com [52.101.193.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C64B18000B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:11:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="HN5A3M/+";
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="HN5A3M/+";
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775747495; a=rsa-sha256;
	cv=pass;
	b=P8dCJrfAkGKse83pD14nLvLZDVegexCDB26xXWHAJkTzbXrC51a87Evh7Ba2FnSh4r/w1V
	t2xgUk89H9+C9FCao7qkSVQxf5G2QuFvK9ct8wkRPToCNfFRBuegVHo4VfoBlrpAsyEKRy
	Qm8UOBDkbvt0RNGLBFO9Z6Ay4RUh/AE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82eDC3kHYFcvLum6EnmUnksTLJfBNXJNJO0rWSuvFMM=;
	b=JixWSyW608D28Mi8FIfSoQK71vKvoSkdm7FoxXb1vvJySWcmAbYX/8+HwAaaWaJjqBMa35
	PUXkqcE7VjPKgxzcsfRC6ER3x0QvAZNpUQ/hfrtMxusLher9RL1aB4eUgECT4rAePadF6U
	qcW/mjtXQpgAcsBhQ0iilgB5xruVlCc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PPdE8Ot6M+H78yp2O/T2DnWHUN/YZ2Zt/R8LsUUV1OYbxxDGv0dx99GK1GElBbD2VSvF3HtQkJe6LNjDX3Zxg7v7s2Qjtz7s/YKeZg7jl/zVcp9rxecMMbjPgdr9jr51dZOuNOKvX5nbf+sxJXH9Mhff4lxEQ5PGk4/7L0ymQTctNGGiK5JP6te/K9/pMCYb4TlSjGIO87R4397+IgyxWlJip82SpfjiVpcOSGkNZAhhueJ0PXCFHZ00KZtWNAj/vIKprlfhWi6CqNqy+4lK6SrhlOWwqHURrAEKWtfU007SA4XuzY2nWN7e9vA+eGAoNE3mRp9Hptf4IXp5GX70KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82eDC3kHYFcvLum6EnmUnksTLJfBNXJNJO0rWSuvFMM=;
 b=PDYNjPnCmxikl9ZiRwCTPvrXkWdZCsTAs5lb45J5LkRtktCGmCaRjV6HejYSIoYC0FyZn6T3lI85kVMxZZVRNwPpMYONpviLwnRb/L+8jMcwAwYyDAc7xjegaCWa5hrHViMjE1FcsM/zb4lBXVRlmIabvvFM57RTglqaHd0copck9Ow+U/1rqdqc9jgg8oljHoSz79Xddm5wgW3JjSrgINzsZuBAmbExtuvZ+YwUTnFIC3Z5jjf+3mFAKtTQmx9rJPrypNzb5dD9eGYejMXZt8F9e7mf6tFmZ2jMsR/7wdzZIRpVpf+urzNE43Z0eWTeGK0fWNVf8tzCHvGjRSzMlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82eDC3kHYFcvLum6EnmUnksTLJfBNXJNJO0rWSuvFMM=;
 b=HN5A3M/+ZVR8kBMAx8opB9wj0gSJXJ+qKeBSP1601gaTSujFYDOz+QruT5jZ3j94v/TAENciTHTalY9gQQZCPbJzFP7dDwnRVSA+C4iZ9RSFp1/DaSbaY6zI9vI4vpEaR3s8UrIhHCwEBEjCOjXPRuiuZCk/VFx7WAJgC5gAeiudHXIQI0uuKtSGNuEL4BkM+0HAAWyxErYuxYubINrYQAApUvqSExJkGJZtntEwKdDUQQcuq4kiW2lfTgtB4t4LVs4nqVS7mOFtgau3UI1otMvg4Up1g7kHhU6/bJgcObvJmihho5diEEaLPXIGNlvm7iJrbr0rPId6+0AwxkfwYQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB9243.namprd12.prod.outlook.com (2603:10b6:a03:578::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9791.32; Thu, 9 Apr 2026 15:11:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:11:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 01/10] docs: tmpfs: remove implementation detail
 reference
Date: Thu, 09 Apr 2026 11:11:25 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <3C2F8FA3-A164-421A-AD6E-D788C77DEADA@nvidia.com>
In-Reply-To: <9a0bed627137a1a0055900114ac6d4abd3a9720c.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <9a0bed627137a1a0055900114ac6d4abd3a9720c.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0049.prod.exchangelabs.com (2603:10b6:208:23f::18)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB9243:EE_
X-MS-Office365-Filtering-Correlation-Id: c6db46b1-2436-4c8a-9ae8-08de964a4623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rePfMUobR+mZ+jyDjVWzqk/WqxPiyvs6vVLauTZE2/6PDCGLWVH+6seOo4H1PLDF1eSQmSmk7RRoWpfzaX8QBLYTkPReGgxjZ9QTy6g/H7vpCXhoOg859KzQivknLpESgBmOxrs41KVnn2lWG1pvW8dVL7CX8lHb2WaRTX+03YcwxlAQnvGRQYWDWxbg8ypUW3esfgnLCtIFafxeIMyxK4pqZk97RWgZoZZ56RZtzfW/79umwTFPpB8pF2c/owHqFdL/dO2OG6VJD+q06USmJs4DXuCEIlGmkg73V5SmbKbp8gfMY7gCOImGBqo2pEpbrxKXILE2WqIoa6OUorSpAAT3W6oUwt2nm3ECwu8HNjNPp87+MVdZt8FXCIwF7K/Gwj1QVs960FQt+k8unNIroD2HG0XHZgXvWj5tB8761lxMW02xq9kz2BueK7Z9E21tRzPpk1afV4SCZSUKptY/EMKgWQmaxNmzHkGXQqomJxIuCne2SB078LptuAe/UTCWtfmLJ3D3EMv7MggxbGEvIpnkhDJK/brPw3gkIJxZLry4ThOAGsYSny3NCL3Il4inT2TQveVoLRMsU08oMRDpD5hnRK/Z/je4yB5LGiOPolt0OMbp8QwtTqx3BKdz+tX62T+S/zGc3+tJXV5fmJ2j+njYEeHsjq1hbsDvsdM42fzH78yfGE/+thwa2wr9Pl9taWei34c9gtBx/Fy+tPhbvxEUy2egQYknGz6zzifwRmA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fzi3LR+A9bLh7E8sjsqYt7PnXM4UdETa0uC5qLKClNP45Bct9O469Rek35rC?=
 =?us-ascii?Q?/3nFCD6Ik9V1W8cL5kuJ/ry6atDoqwDnfnUQjsAlFgf/QeOZ7pYWdVZ+cjCd?=
 =?us-ascii?Q?PKCHqwU5ylpKfG/mp2nFP7iXicpl4VeqvNM/MDiww0UN9Sk9oq0PCDT78fLM?=
 =?us-ascii?Q?VjVNsMMBV3RzeXnP6TyBugt+qf3lbY22/6fihr3VI7B2yWorSUwoiotW87Cu?=
 =?us-ascii?Q?lPfIVRbMF75uNHgnh8JNEeShK/OZ6Rc5W1HPzVIKB0dDHHHtZeZA60rt8qS1?=
 =?us-ascii?Q?w6M/lgPFgMksrU70tn6qOhT2bSmUR+tYjN4Qde/ZvrQ6vd4TdkApsWFaRZvI?=
 =?us-ascii?Q?YWPP7CzrQLZx9PO7LyH8VXWaWaumUM/5zT7OKpM4p4pI0hlTMe0Uw5ElY4NK?=
 =?us-ascii?Q?bS3I12bSmSLXuxzVT1eX3c81GItfhiJ9jLj/qN0ENHsTk96qU3R20l35BE+c?=
 =?us-ascii?Q?iPr0Nud7BCVhLf+t5UDjmm3bIFBlLAKLp1RsZIfmTnAy2hby8UUAzbS86m3l?=
 =?us-ascii?Q?W9NHagaR0p26LZ5BVn7g+zc6jFkCTNgtFA9DOnIlCwMoSonExoqIv5EdPpfu?=
 =?us-ascii?Q?SFi5fynSZo/8gzADQYF8dIRNLxm0C4B0BKw2tDo5MKhNS5dAl0EGzcZj1Xlu?=
 =?us-ascii?Q?/Td4W5hLFP+uZOytLOHTOWbycLGOV+PzwzNs8bACZ/zQKePngvNrC2qaW8Uv?=
 =?us-ascii?Q?9NXnk9IJrJVu4SjZYMb39/cJL4wt1RMcaOV9+VgzTXKhMveldNRw8jdoTytZ?=
 =?us-ascii?Q?cInhLDsi+l/yKAxptj70AMMT7JICRqMjTnp95qHCDliJLaVNnTEFzi3lG6/h?=
 =?us-ascii?Q?+LEKT1u7a7TJ05Xlt1I3760jjeM6AwcCu6WXE9LvVUekiaIKVWYGOp1nB0xg?=
 =?us-ascii?Q?4nYv7uRDhAQWbK8+OYE4OWiqjEK96m2R5AxEhvzhK826tCry4XW2CHuDG4ij?=
 =?us-ascii?Q?dqjEiVEr1L0otqk/QUkS/mK9gqFvJziIR7NdP86e9qdgmVhpmO+nbmEbf4nB?=
 =?us-ascii?Q?OOpkKKZGqixrJ3JoVW8KCpDYC4jaUelubZm/yS3bISDMb96SUB7KX7LAwk+s?=
 =?us-ascii?Q?dYi2sSMRN3VYUXUcn3YZ/ov1pBRtmzrS69ZPydPmCCRNuDY0c4uDr22RiVul?=
 =?us-ascii?Q?kZSMoGnrtQ8vUi1ACpKQ+X7rrQxAOpaM76p+Ct3e9WkbhYeInUCI6Nn8Lhrs?=
 =?us-ascii?Q?ht/iJ6Oq9Ba7W3ZgJCnPEhCzUmODy2wjk1TEnGAGxNsXCX332332NBxmUu8C?=
 =?us-ascii?Q?06oP8HP/3w6HRjVpm55tmBCc+zLzJW6soE0zVWi9f+Wy1gRPHTvVBJm+OcaE?=
 =?us-ascii?Q?uMGvpIhAf3mVzzTWFQ8kzUv9wwSMET7lFgmSrXTyrg9GyQN22hkkObKiqvhm?=
 =?us-ascii?Q?FEqr/B3wugS0TzUU/FZNt1jYVPxGHnpjV+Moi63b6yT+EJ0vdEPlyMi0YwFn?=
 =?us-ascii?Q?T7ottAoHcj/9gx9S1lEWi+AaVu2kFRYqE/tHzJzMvFi2NRH80yb4qfArIOaY?=
 =?us-ascii?Q?FJIL6STLY0e9/WNeygeuSnTi32cfqK2WNQmzqIeGfIIrb993xmIUK5smheUE?=
 =?us-ascii?Q?6fFewjRlL27a3hL/WUFfaEgUQDKx2SuRmSe+Q6DzBava4LCV5OvMOIfHyAtk?=
 =?us-ascii?Q?KTBMlnnhHa7yDN/piqG6mYUI/wwX1a5D9tUTXRCk6Lw+99o9EybImnJGdEHR?=
 =?us-ascii?Q?eCInnYK2Gl0cJ79S6byNJY98KPTptx4ecfFJi6wcq8TkIS76wbgskVYM1Bgw?=
 =?us-ascii?Q?1mBO84Y/uQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6db46b1-2436-4c8a-9ae8-08de964a4623
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:11:28.2929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgrLXmtYSihi3mqgrvy7+nw5+73F6CNhxedHjqBS577IsubmSX4Rwx9E1FAGlm0e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9243
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C64B18000B
X-Stat-Signature: 9emee6jqikwuami4swegamskruafas9w
X-Rspam-User: 
X-HE-Tag: 1775747495-381305
X-HE-Meta: U2FsdGVkX1/4mx1W5JkMhIo8rslFMcnvyO6VbmALmry8wEKVNABHelK1l+sA7aKVeyDhAXUY064PpQfhK+c2mAKetXN/B8sVUhZqHXb9NVdV+3R9FeoIJp1CzhW7GQ/T4j1j8hb3eRSY0H3wdt7aMgbIZad5mtLPP1OKLNS2omWoI13TTCUFULrvHEBoaygO0FH8MCcOuN4adG6K7g5Wu+yMhyAKC6RDNtADwWGCbUWMPDd6vufUqflrxEybRbG371yQ7IyjOP4+UFMEfw7XInFBjcEvN93lp/sI0pqnLKkO1EADGuqExCUw7g9PAGKnMQGbihAu2Y5TdCeZ8SJ3xZOVeixAPmJ/FpxdnrjA2TK/1myq2mjDhUYof6QDxX+dLUHHoMtPtBSuoMV019CgVhJRg0W22D3dMF4d6l6msW4oAgKuH/pP/O8Lu6Bjyd/sTrn7CjnevqY7JFnCbmioz/Ps/bkBoMKOPz9YpLHt+9mbqyuUIKKJ9cRWqLD3KsyK/3Yc/fKMJSKhrYg1JEIhvzjqLz7TckI3IfGq4EIEbo60cFUN4z4WO0zgoQLWNvSsANickExQVOCDgBqEm83RfQJiZfKnfNfgJrUYkgoRgm6l0rHIT//CgP5nsGEsFNwcKCFMU8yOM96T28OOeP8qz0cHSEO2jfSCdjgaIOsGhcIslZfrReJYsugixq97WRCr644XPLs5nP9IpKJtQDj8VOqKyI7I9Sb8gpeIKrpUvIRt6ni7OYZ3lcQqJMfD+BUKgxRsxvMvAOkGTlM8zt34QT3olMqwXYB8qngOCloqDoL8TVMMUSpPtcJATdzeE7lbZApX+Ff3ocojDaFG7gc0CeSa06bviTK2Jff/1kjoVanDr83N+WsYiBgCXS5nta+qZtv7uJgVsXhnGKxHatcrqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 16:22, Luiz Capitulino wrote:

> The tmpfs.rst doc references the has_transparent_hugepage() helper, which
> is an implementation detail in the kernel and not relevant for users
> wishing to properly configure THP support for tmpfs. Remove it.
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  Documentation/filesystems/tmpfs.rst | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

