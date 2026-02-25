Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8738BF55437
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2AD6B0092; Tue, 24 Feb 2026 21:22:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8AC16B0093; Tue, 24 Feb 2026 21:22:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58E16B0095; Tue, 24 Feb 2026 21:22:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD14D6B0092
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:22:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70A6DB90CC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:22:06 +0000 (UTC)
X-FDA: 84481379052.06.F4713D8
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010055.outbound.protection.outlook.com [52.101.46.55])
	by imf23.hostedemail.com (Postfix) with ESMTP id B4777140004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:22:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ebewswGC;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771986123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXQCW1iTaGAkFluO9xzh0BzF1eCE+y79bI1HuSt2JdQ=;
	b=QRyxr0vi5PthOTNl+YmSN/tocjUln7K5LSFmC9ZxMfaF9NuwJvh4syguTIkry7HGcADbV9
	0cLDuYDehXG/NFZIzRXNmtXrMO4E6szZSYszzpnWiE8HHX56tTqbN+tEIyftww8xx0VZvj
	/9q0bthCicvkl88wzGaTdJ2l+48UEi8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ebewswGC;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771986123; a=rsa-sha256;
	cv=pass;
	b=kU261BJWWT3BrCJfW0R/nzb4Ru0X793eYZJh2TlCy5dQdZq6Ebm695eMIVqcfcuo9iS0d/
	14mps5Ln/ONcIGGHJRwLdjcimwYI4Bvd1AKFYshxvlMYj0kxdFjVlQWIV/ca9sjGZrmh1q
	1b6kdIqMjjXEhH/X8+x4Sw/yT1pQdAY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SqF353nMzbTTNxQliTzv5E8ttwOa//LI9XHEBsE+E7tck7KsuM8/4OO2pjVDHq2MnRycikHrMhHVw1LHup9x35G4rwXy8WyAE1/OPcsLrMB5u+un9zxzPifgRTrrXcvXslb0695+bbQ17rddiGyeNvL4WRzfzD9X3GhzUSr+k+uJ2i3XG3xF0Np1dTCzDqfBpAr7/NTf7BaMNMhz0zgozuVOVyhsWc4hHA580RVkpifzPIfH7Rbwp+4eoR/GUJHaqcPS7yatl0XZK/jMxo3LINYLdJ9+hmFWIai2fPtBjOTetp0OL8Pqn9Ok13lx0khcIN7ohCvutwbYFttnhM2sTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXQCW1iTaGAkFluO9xzh0BzF1eCE+y79bI1HuSt2JdQ=;
 b=Xvqt4FMFvOrA8zUaq8Gb2Ou87wyY2K6EIXwbe8x3tlreBqTtpl/D6AMKfPmmpjwcZWVe8RzXeQSec5YQeSjLtmdgeasu6aby6L0btcwYZ8k5n9Wj7DDk+T7UJSRo7PSn3UmLrRDOAaTsgdWBDsotfeNcT9CxpgP9H25IAu1TLPd45FjWQWkVRJVR66cfYYUlegXy7aJ+gYI/wWs2B08gVGRDo/WNSDY4HwJPMwrL17IsDXPQwLmZtb8OfYJXi8Cu1woF96ThmTaz9cRYgZ8mRdDHBrZ8kaoki85byvu55+eUiMsdX1quWif27EGg2W5V2QelrMw3817wRCVfGHJg+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXQCW1iTaGAkFluO9xzh0BzF1eCE+y79bI1HuSt2JdQ=;
 b=ebewswGCrOqf64G0hbFwGwAoUOVmP77ZfP/Z2bjzvNo0XAkHuikBscFOx5Hx6GTR/dHNGsx6JKm3PId1jFjKinEw/xGAXcd9fOhprw+s5Hvxmg9w6RlsyjueO8yZyLqB9xwCxYR3dJaLT2xJ8kbtmPhdMhX9V84MiU1t809EaS/elyWRr75ZRRjqVVdCHgOFcqKAeRjjuLOrvBjT27TdK1JDDeJ0CArJnZ7L6r3zXeJOXJJ9zg+nVEu9a/00EKx3sadrIbWUM/poLNtI/BnJaJ58QOG8S5kxeoVfT1YpoL44EP9oSEReDctGZy7bLNWJxpIPMw1mp2kXa/SlupY//A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6805.namprd12.prod.outlook.com (2603:10b6:a03:44f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.14; Wed, 25 Feb 2026 02:21:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 02:21:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ron Economos <re@w6rz.net>
Subject: Re: [PATCH] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
Date: Tue, 24 Feb 2026 21:21:55 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <88B98450-B0CE-476D-9E09-98DF6A1F6E3B@nvidia.com>
In-Reply-To: <20260225022012.62985-1-sj@kernel.org>
References: <20260225022012.62985-1-sj@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: db60cc25-2d48-4077-623a-08de7414a73d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tZk+iUuIQ6JRPyNqfbqKUwY9qfwU1gHKUhkeieeC6drwnOqXuHH1Js1mMEec?=
 =?us-ascii?Q?9Lu3HHquBDd/t98ehJS33ec1T1lsTL7KdiBQV4s9nqReScwMBJiTQnKTJWvB?=
 =?us-ascii?Q?lzItqXhn0LqSpJzzKaAAZVl/SaYU8Gdzxt8hIKmh86LpR7RsPoyr0rsvIJSf?=
 =?us-ascii?Q?rFM5WKYRxM6BxOZ1lwAHB5q/wjfB1sGBaoqvtPbhuTG1aqgGQdAq/l7ohQPp?=
 =?us-ascii?Q?BWQphhQ0emDu0A5jXbeN8mCPmuZ0OVo6tglGk0489qsyi1CIbdrbmyxbcGyH?=
 =?us-ascii?Q?UiGkyayt0GT9QRWp3A0KvOgTtAVg+kfj0yi0NvSYKSdXsNT20F0gAKXBOgPF?=
 =?us-ascii?Q?vFaBhgqXMLzf3Xn9MV3WYZyssjbV6gzz5cTqpgcqd4xpL8RLHYQsMGCpsxW8?=
 =?us-ascii?Q?1NGKz32u2y3qdtxgbrJzsGcmLmLz0cYW0+NguZraTmGOFQqSeA3EN5xf8b0t?=
 =?us-ascii?Q?iTartU4dKSFkXOIdNd6yVy2LnxhwVioONE52KlfrwJAu31UpyE7Bu7ENEHZT?=
 =?us-ascii?Q?ciEo21dhU2ZeHw7uzBTppr723gjRP5+xDomsPpExOvrAyqAjITU3OAQNOA/l?=
 =?us-ascii?Q?U0UR1Vz6gNzmaNFy80TGcQPYyA7DG/Yj3GdC9GUc0BDJDT5RkBqd6x3QgBD/?=
 =?us-ascii?Q?AhnPxUf3kegOZrzdm86a86Z0IJt3wL6qqpWlJJC7Rzht57XNdcNXslpmuBUM?=
 =?us-ascii?Q?xaqTqQUM0jduixxJutzwNtSZSX97AG2A5iHjjTGqK0WDY+vyHpPLiMud7wX7?=
 =?us-ascii?Q?C4En5FUWlrBAauJFFNXLw0o9kYoTQoEm6/hqRmtFAEkYuj1L45Tw+voa1aff?=
 =?us-ascii?Q?ro/MAJ0HQuSh2RxfVmjU+HitSj+SoZW+d/n6TJ5XaYRhcQhiVsWnitYsJ9Im?=
 =?us-ascii?Q?Kyjn+g114SKJcLogDXgHhJODOg/3NS0FIJDwZziDb532g7B1wQZJsexeuXeB?=
 =?us-ascii?Q?eRQiB0+8EczN64LN8d/Z4W7kyDfdmMWkzsEjnYOpgobbABHb0mQNHZGFyz1v?=
 =?us-ascii?Q?xD1MAvS1nlsdgTl58AvS82f0OBJRUijVS+lG0uS1+iefjGuGyMBo4//5CZZ/?=
 =?us-ascii?Q?XyIfl1eBjKeU3W4aBy710xnnJfE/u1o8BkG+c0r9ZBdxjro8tiEhZ0r2481d?=
 =?us-ascii?Q?0UG132M0cxfZ7l9Zde2Hk8RjOxlsxYdLuks8/cfs6udsksjMIM24HgTjNlmW?=
 =?us-ascii?Q?6drOyoBu56TwN52PLHSVRpXp2SBrHfiqJd54DYJb71xAgzXwB7IytGNoMnU/?=
 =?us-ascii?Q?IV8O0xptbRnfbR5WbKTdoLDxfsDly5NPKacJk7JfNbRBjjmbUmgwU8uKxnTA?=
 =?us-ascii?Q?Ok4zYL5qOwrwPo5Z7rWavW6w83O7mzngPcoHSmuJLMUUkWtUoo7msxODfPJR?=
 =?us-ascii?Q?oRGYTH/NjeSCqZqlKYc5+71XYeTx+ZAx/VsSytiwDEx+2xPK7OHmxYSxt//e?=
 =?us-ascii?Q?5TFiSYTwqbrnmIV7sMxV4EJV9IZhH3Cv6FO+h6fHLNRDcaTcCrFR8UFsOmHK?=
 =?us-ascii?Q?YNfAPZ12MD+yxB9weW7rsQBg+t6tNR/fvMLcJIHrwVYPLKScusFajxY9OyU0?=
 =?us-ascii?Q?s7CJBA9EnUUkXUOsV4Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mx5nBZCtW7zhm17Ps6hIHrRMXN6gO4Rawi0EryKRggHDFfQXQOEfAKQIzJIJ?=
 =?us-ascii?Q?DpHn2LJxxgJUmyQsjxJziDTHwk3Lld1x7POpL6cbVmb+69b4NEtzrikTVAUQ?=
 =?us-ascii?Q?JAlkriWRyBd/WD7uEiyF57wmJ3zH7WGGRIq8eBwkqhcXmHo8/6eIA2pYFwm0?=
 =?us-ascii?Q?ufpTxhm8SgZj2WCQDErmsgZswKmc1hqiysrmb9NQ83BfUU8pWb46yeAqhCFj?=
 =?us-ascii?Q?Gq2NR605alXqdCCY6bwAPzGxfjRDe73Rclls0fQOaXd0G2LVPNKul5odPXeI?=
 =?us-ascii?Q?ltT1ANYQ+vw8jk9Q4QBP6yYyXaJ2nOA2UrV+yR1ADvRdmEzJjYKRSptB3TvU?=
 =?us-ascii?Q?AhKDfNgU5stDERm/S5lrNj7urJk4Ve2mRyUEZlqH2Idte+HV9UvxF0YVJkSJ?=
 =?us-ascii?Q?rKYVy1a/P/19R+0/M61d2GwOvl6r5sdViSQDg2vmEC3KXpLjV/JTXAdcRWAt?=
 =?us-ascii?Q?1j8Qvocw3smi/Q6MLbVFiQAEmdBUl4Rr2UllLVnKlYAjkrcb9+h27KfknAZM?=
 =?us-ascii?Q?FbwK6pOCC0Hfuw9DAuMVd8zODMroIMP/V4oGurDlDDe67VkMmNNCEr559MU2?=
 =?us-ascii?Q?D7YFtRHCS++27pjULY4l5BV4YYctuiIUsPuL8qxhW9cFMWqTEMxYhdV4rSLC?=
 =?us-ascii?Q?fKlKjLXcQ/Us35fizogXVIRyGtrg3ZzGG0w2l/SLpD9/YdwbmRNKuVPjOtNm?=
 =?us-ascii?Q?ERgvpCQzNd2Li+vrJ4AdvQkhCIGzp33IVD5cQQYt8W+1FW8UcZ+xk4d96eMW?=
 =?us-ascii?Q?gkUfBBtt8stb2oQxeW4fPwdXWbF6hyfFm1dfsLntDHdqjRgDxcP1Q7bRRoNV?=
 =?us-ascii?Q?Br/nTE9zWvMkA+VLI8MeTXUfcSpXtQWSi+BegaDat40ZZAqz3tV8umhrQf80?=
 =?us-ascii?Q?u4ISWp8VgzjBc6o+lFH4LZTPCgbNow/CxGgBl/7PVBjOp8InjvTcBBDvzlW5?=
 =?us-ascii?Q?DkRW6SsQ9gNdbI3fThs0Pe8drjZOHiCtyQfQuzyEh6OpHeB7tJIRZgnekUKs?=
 =?us-ascii?Q?CqePOlIgTGMwxk2xeTqVUSzp8XT2A3b8ljzXqgMJsyEolZOBRfeo/ljsbZdJ?=
 =?us-ascii?Q?lkzbTRDuHQgodSLwG9HTgJXI7KGozqHJkzMjcJMZi4HrC+KjPdPcNU1nL366?=
 =?us-ascii?Q?ECDHvXy3Fra+7vIVYpxHjPHmGo8j0FwzFoP02sw4tD5l8pLIBAOyT/PolWeg?=
 =?us-ascii?Q?upJnPZ6yTcczrN5H8a+a/6cI8P92op3e8IaZl0lX6m5RgjYvdwAQGmm5zTcL?=
 =?us-ascii?Q?tUULmhz9iT1u4wLDjguvcSuIFFguEmptVuTsEctizEHOF4AJxeX1J5f44Si8?=
 =?us-ascii?Q?QDXYApwPFpsrXlYhaET7pyrH0gAgWNm1AkzCUjQMX7XVU5mTWGE7catN9B6y?=
 =?us-ascii?Q?OwIgsVZSiezwumorX7SZKRVoR5A/qrvs3QyWipHA3lWRSSAIq8b4YOA+A5f+?=
 =?us-ascii?Q?pe0kZT92Bq5GDadiJ67p9MW7und0Xb/mEJzoypwRpyX+9w3JZJjBXDPfFGC9?=
 =?us-ascii?Q?cL/wWWlAR8e6x4CtdQ8WIskie1VGbJ3wvvHjjpVWdxPm6glYTYhtsjnauaG2?=
 =?us-ascii?Q?idp1SEvJTSIglMHymCaAhDY7LY/HJdAMygUfSDlqX9WYG+wwCJfpP/PF00lW?=
 =?us-ascii?Q?jCub4jeswi/Sv+fAVr7g5AWLfOHuxS22IxnEYAKe3S5XA5NhLS22zxMsyMgT?=
 =?us-ascii?Q?gSEccLky8d59LPeIFwgEH31OQKBw1GCJtYiUm95J1YyKYCOsEH78Lc4MBL5y?=
 =?us-ascii?Q?LnFVA5JOkw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db60cc25-2d48-4077-623a-08de7414a73d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 02:21:58.8239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERnTAAADvzFMxx7lQvlODnu7baEnW+og0H/6zFuV6mLAv2NaVFkkINPEFfWUdf9+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6805
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4777140004
X-Stat-Signature: 4owba59ybbogs64xnteitshtjssefu5g
X-Rspam-User: 
X-HE-Tag: 1771986123-388289
X-HE-Meta: U2FsdGVkX19wbwFqRg4R8K4s9NsQFXrjQlkPVGFpRnIJT+pQUe7jO6hTeDgG9Cy3N4IRSoh66EAo8mqYujjDs370RFuuxa+6JMd/4OJHw6MYgPeSKBoTWQijpuRbhrcQNmi82peGFp/wICeE9vUlIx0eRIKjt8bwioekZvhUsojLTgy8b1Dh9+jdOrQeIsNF8530Ww8KPI5a3eYdkGaFrz85pjluIhKME39ejVUbpQqvvzrG43soqVOpowS401U8OJQQHXnMqFaMPyrsNU45tjrZCh1CYmIa1MPOuzHbZSaEBjFjLFt27W9W5IfSOVkk4Eq3/1tP0OvsUIaz6zmbdLBcTJ8MR9c4oUivpoOI3F66NQayaVY43YveQfWZ9dM9mA3IAFtUtZrjnjPdSjRWoPDHc/53PlvGsX0w82933mYZMW/CQRmg0DVs8fOXrMG5EgN8kLr8IUA01PlwYMsDrBnTW7VuODN2XBg32cid86tI6NSJRXJYpSsZgbpQzbot0BdymkFX3PUxCGxi6Rwkq3zad5dl5VkY3bRIs68WzhqZcX0c5Xb2V1wTjnGyonvD+Zn3vSaS9hcna8S71+gv2V5hiWEZ7qI9CwaXJJveU5B36jKR4E53WnBRWrPVIFl7collppTY6E+oLXmhJKfe0Ls9PsfJHNF+SpT1mt2pkQNGGZUTh5hxzGG5A9xrTNwjuYhQN8PiAoxVcsSSALQgjRGlt7c6oZdlSxSwaqYwskGWhUi0tKNcC/G0/YXUgnuTt4e/7vfy4FBnFXSl/7Q9eyddVNoXSh+hOnRreJpU+98bReoMQ5fnDi1FDOierEsDRg2BlVQBIptmevyxaa3WC8it5DfG1R89FGRoJEJDSCkt98qmZebro/8IQtbm93MIoOYOXdCNYQkVqDr8UApcLQKssWEbXSqg6bR9hOaPZsbTiFiRROoL9t+IWsahefKZc3Pc3QV8O7lnrMvcTDw
 qtMVFj8Z
 OYxSjNBOrmQbE/i/5MovTFe8rTW4kElWQ4D89IMh2URtFnBl5tBLck9okcxGR8hLf5xT3EVol+Qr4CkJLDUUSXREPX42/9di2flYWFAD0YHYBMDHQx/lGYMUFhqtvC41MAODyBb+kpstXgUt4Gk4c0G9A6Pf2AGx4PPgMALMkU1Jlu5MT1FVisRpsxF/eSISi5s3kSmrPf8g+RkHijP6B2O0gR5BqtcIQuXf0i5RvCDzKlmVdsyVShED0MUJSmUi5MdAgdmpq7qGWCCFRq0A25hfK4yBplebIrlr46nJjshozJD1p8d9XFCSdtuR0rjAPbVvaJyGaO+PeNCA0tAnIcF230SeORB49yDCqIP4iyWzvTFbyd8aEZqRF4p0nXJ/WYykJKSUUMAFuXCwTGGgHF/6do6ZuSdSaMlOkTfE5O0OeDwaHsIuVsn7qDoy4gtBDpmhe5Dq1KHpz70aIM1Y7lS1RCynvd5ZgiZKav01gIYqqLF2/D5X0fhMO0UNMufsbM+7JK/ki4vveNAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Feb 2026, at 21:20, SeongJae Park wrote:

> On Tue, 24 Feb 2026 18:18:44 -0800 SeongJae Park <sj@kernel.org> wrote:=

>
>> On Tue, 24 Feb 2026 16:39:46 -0500 Zi Yan <ziy@nvidia.com> wrote:
>>
>>> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any sta=
tement
>>> with side effect inside it is incorrect. Move put_page_testzero() out=
 and
>>> check its return value in VM_WARN_ON. Add __maybe_unused to the retur=
n
>>> value for when CONFIG_DEBUG_VM is not set.
>>>
>>> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
>>> Reported-by: Ron Economos <re@w6rz.net>
>>> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada=
885@w6rz.net/
>
> I forgot asking this, sorry.
>
> Should we Cc stable@ ?

The commit is just in 7.0-rc1. Nothing is needed for stable.

Best Regards,
Yan, Zi

