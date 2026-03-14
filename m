Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7E810706DB
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 13:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F806B0088; Sat, 14 Mar 2026 09:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D236B0089; Sat, 14 Mar 2026 09:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204496B008A; Sat, 14 Mar 2026 09:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA476B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:37:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A07E7140790
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 13:37:38 +0000 (UTC)
X-FDA: 84544770996.10.7124346
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020092.outbound.protection.outlook.com [52.101.195.92])
	by imf27.hostedemail.com (Postfix) with ESMTP id C73DD4000E
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 13:37:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=j9ufzrOW;
	spf=pass (imf27.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.92 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773495455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYT6iD4H1Up+5RGxf9rRembNt+jSESpEW16oHNyyGhU=;
	b=aTmIoDhhCvDpfzjaPwHP07+JXax6skFSszV/ZQqKnQeYMajPgFeUpj1Bmj0KFotLbjXC/i
	wTsz+NHXaA9klMnD8JOrCoCtavB9L68YSTV9C1P2EbP5XfSYAQbxCKSDeP4S41ZmV4n6ys
	KhnqYSUdGB3hN4hfMhUw4AdMVNkrXG8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773495456; a=rsa-sha256;
	cv=pass;
	b=4JQxLIlHEVIrD65nL2bmy0jl1xdi9NUb9k47jTcNJj3qnOQ63Eo7XbYALeXojoAxth/tD9
	egYiwGw/q3wRBijeUgknxn2EGB4MIwUJ6KG9/HcAqFKtQ+q/+KOrZQvR18vxnfpYAQdbiS
	ZDNGhrrQ4TzYb0JVzigZ1kqN+dFGT+I=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=j9ufzrOW;
	spf=pass (imf27.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.92 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVJV6VCQ/1vkrPAuQV+Vy3bPUMn5ZsmAJXzmZGt5qu0tIItwoIk+2rFGgYxlQXCAZTC0fFog/EMsvc747VIIWPry3F7QYiCZxov1oGACP85M0tGHy3In27MYQ2APXT1Kinx0tLWAL7+Eir/fOXVoLIS/a/YhLBnWqrji/pbaKoZFlpimXfLAf+SaKqVlE9Fzp+CCdokPmY4/8HOqmLd8KItXG8H2NH+FW8JbZJ1NDUmWDJUKSTKh2FXHW803a7QHx5WLSJTHp0ojRSjuGjyJ/+pCry3/4zaT9b6Hp5ylffW8dzNB574K8W36496kUDnZYL/5KKyhjlQks7YWJQT+sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYT6iD4H1Up+5RGxf9rRembNt+jSESpEW16oHNyyGhU=;
 b=raX9AgL9wZj40rn7clqFqQItcF9OaD6O9+AWfEWwbo4BwuaOy/zYvKVzbDSh9zAtST+yC8lfTdAjvnn9Se3/HzOP2tIid/WEF3pNZaAcoEZvoLm9+3YYnJ+58ZViGd4fxPAnO8Zq4feTiQBZAv8wpVMYAF2jzICBj8+0uFZr6PwudJ8/tckxqN+QtHfjxJwlHKHyUhx+Fm2thipEmeKwHwCA50QLSkV1eEd3tPK9ZzdVuMjkrxqvQY63QmfRM98tWEzoB+tF2/T5x97R4zmguis1iMS8I4Ht9/m+Pgb10NJyubdQuNjbc7R+2j+NzPxjeNphjEdEjNBtCl76wde3cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYT6iD4H1Up+5RGxf9rRembNt+jSESpEW16oHNyyGhU=;
 b=j9ufzrOWuNYX26nXFZZkPM9bREump/gWmiz9EARXeYjsw9ppTbSVjg7O5iL107Ld/2vE6A8zH77rPt+A1O+D30TY2Ci9bLozot4E3dZLb62luQs/9q4kfy/0uhlfWiFwB0uNofU13lZO+OzgkPCA/44m0K8G4lIPopyFHnwZl10=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO6P265MB7034.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:322::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.20; Sat, 14 Mar
 2026 13:37:31 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9700.018; Sat, 14 Mar 2026
 13:37:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 14 Mar 2026 13:37:31 +0000
Message-Id: <DH2JO2PZ0XR4.1GM9108DVQGOL@garyguo.net>
To: "Alice Ryhl" <aliceryhl@google.com>, <gregkh@linuxfoundation.org>
Cc: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>,
 <broonie@kernel.org>, <dakr@kernel.org>, <jannh@google.com>,
 <linux-mm@kvack.org>, <lkp@intel.com>, <llvm@lists.linux.dev>,
 <miguel.ojeda.sandonis@gmail.com>, <nathan@kernel.org>,
 <oe-kbuild-all@lists.linux.dev>, <ojeda@kernel.org>, <rppt@kernel.org>,
 <rust-for-linux@vger.kernel.org>
Subject: Re: [PATCH] rust_binder: use AssertSync for BINDER_VM_OPS
From: "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com> <20260314111951.4139029-1-aliceryhl@google.com>
In-Reply-To: <20260314111951.4139029-1-aliceryhl@google.com>
X-ClientProxiedBy: LO4P123CA0244.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::15) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO6P265MB7034:EE_
X-MS-Office365-Filtering-Correlation-Id: 45e02ffc-7b10-4a70-5ddf-08de81ced7c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|7416014|366016|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	Pe5a5s8smOl60TsT5YatwbR5BI0fXxiANhL/WPumCiOKS18DaSSir3Ri6qrqnWIV+bJDhzKX5id3mHsfmmkQQHEDvOhSQP+GyiF4CooVpYLSRRigmJfwbjTm04aIDq4hmCDU9VXY+YDl+xj1jx2LCGVXvlDiPVL2Vb/vOE0Oi0w4Nj6XMFpM8RILG/EodmwTV5DDa8dsSTegkIHnbQV/st/VScCXs6dZPz96N57E57WFRqX47Ki0hzBC9ilcqpSS73yo1Nr7HaC0Yozj64jWQuKXSVmN23EsBmpHOJn54sDhCoVDzRkd5GTr9W/yktPpxvZm0Xl7HDN2Kw4giDelB7JHPYBTIROqfTTAxqOEtAkjKX4bwNwDucYLQ/PO09lSQ8eDjmglnAF+o/LflmLftjQctH8TA8I77K9sPZvYxLlKpaBN4j4AjMNNAFBDkMrcStFol+heIF3ATSj/F6XxgjYCA6gZCrN2pEf2qblk1/eSr3zk1qrEvruAFZGWMKuoc3PHSHN7Gjrf5DIM0rFgtzjPzO2wqpzZzPHNHSDtlBflgK0f7R1ThKUJIbozWiUMUvCsOLbPG4Qa6qS8rAP2WfNQ8J+qbSzB+oLsKBMx5MW9Jq+dPx3cdDHtljcwJcrRJWWRF5BYPSYwRFCPsgEUutnL+G7UsWQJUTr7r3jNnVmcJU6XesVEMrw3IM24lPyzc3ZTLmfc433GywdIKK5kRf7VJKSCklIdGRdW/bk5UQM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vys1NThReDdQcDBIc1FVY0RaY054U2VGdW9DZjNVL21vNVNiUWdwVCtTLytZ?=
 =?utf-8?B?Rng4d0ZkSThCdUdGejlMdEdOb3NDa0g4VUcrVittOTdYTlZEZHJ4QTVPZUFR?=
 =?utf-8?B?dzcwWllCOUVqVHpMSUlTRWlZcXdrK0x0Y0IySnNETWVQSEIweGtjV1RtYUMx?=
 =?utf-8?B?OGhqTjRzOG1YZFRla2VqalFDOWxhaTBVNjAxMGZwQ3dLRndtSnJRNmhzS284?=
 =?utf-8?B?WUVDY1hZVXZIYkRrakJZUUdEdzJpVHhvT2NrYVZTcldEandkdy8wSmdqbkhI?=
 =?utf-8?B?K1NOWUJ0bWlMU2IwK2hCMVdKS0JlQTErU1RJdUo4ZzRpWnp2ZGZnVEtZQmtZ?=
 =?utf-8?B?d1JxRXF0VU9HNnU1by95ektGZmkrc0dsck01alRiY0N3SngrdkE4Zkw5SmFQ?=
 =?utf-8?B?amJjU2x2bGtxQzJGVmhqdy9VOGRGRGxpWVpvYmw4ekt0MTY5N2d0bG9YN1VO?=
 =?utf-8?B?L1JNRldCRlB1dlJmQVFZWHJ5R05vaUJYb3NJbEp1eEY1YnpyRnBiRGRPTnd2?=
 =?utf-8?B?bGNSR1RBN01oeVZvaTl5ZlF4ZTViN2RvS0xDZ1p5VnRRWnh1enZzS2NRRjVG?=
 =?utf-8?B?RFlSSXVGeHdZUkdrZEVrWldUc1NtUE1XSHRUWERlMzk1YS9sckhSOFlkb25y?=
 =?utf-8?B?MkIrM2VaNTFnRGNmZnM2YVVpT2xQN3poSGlNa0xKR0ZjTVU4L3NvY1hXZnlz?=
 =?utf-8?B?dG80ZTM0bWJ1Y01DQlhDQkNwTTA0Q3drYkN0ZEl0eGhOTi9Uelg3czRRaGs1?=
 =?utf-8?B?VnUyZjdBWUtwQnRrbGt3SVhlS3Z3L2VnK3hwYVVOSUQwRk5FeldYSmFkRzE4?=
 =?utf-8?B?TGFDbXNJa0JRYW9HOVBsaW80bFd1Zk5nM25zU2p6WDFkVlJQMWlMWEZlWVhK?=
 =?utf-8?B?bUdjK251NlZGS05neHQvQnlsRGZvMG0wWXFST2JLTTE0SWJQMjNQL01UWkVI?=
 =?utf-8?B?RW5XWmxrcld3cU5CcDhHYWIxMXdkN2lDd0hwYVpPcXM3YnUrTUZaTlRETEov?=
 =?utf-8?B?bnE4WmVLTlpsaWo3SVB6V0pnU0o3TXBkUUV1Y2ErU3NKSVcwUzBFYWtseDFs?=
 =?utf-8?B?UGk2VGZBaklUbTJEVUVFb094Y3NkU0ZMVTVnS05lT0kwOERxcWZjcEwxb0w3?=
 =?utf-8?B?Wm5Ua0ZtQUNBL0p5L25yMVh2S3RUTXpXNTlFczVpK1FWWUJ3dGxaN3VSMVpI?=
 =?utf-8?B?Y2k3T2hQL0FnQ1NkRXhOTEIrRFd1QXJhbUlSZ0V2N0pEcmNLNlhnTFBQOWtS?=
 =?utf-8?B?WjFLb2pIOUZnT0t0RDBPZXU1cjVScnh6VkY5RlRsUUdtQ2dxNm9DREcxa0t3?=
 =?utf-8?B?enBCaGltQWJrQ21WNEVTN1NqN3N6OU1WWnI2ZzBRdVRHUFVxS01oWUV3emJt?=
 =?utf-8?B?dkdQeFhBY1N3VWRkQjFGSFRwMTlTTmRqU3BhcUNRRExSYUhBQWR6WmNEWVlZ?=
 =?utf-8?B?bmlVY3UySnZWd2ErL3htbEdRSlUxRndMcmJ0aFh0eS8wZjQ2WGlURDZ6QXpq?=
 =?utf-8?B?RURVWWxtVGdlTnprTWljK1VmemxVMFRlY2RyZkZpbFlyT3g3UFpCRW94V3Vq?=
 =?utf-8?B?ZDdxMzRKaFBBbUF0TWJQZ1d0cjBGOWVKMHQ1VU4vTFNUNXA2Vld4WDJSc3dv?=
 =?utf-8?B?ZUtLM0pRZ3B3SmhIN014Mi9XNndFa0p6M3BCMzVhSDNhd21WT09TcjMxSnVE?=
 =?utf-8?B?OFZtQW5tQlpiYkQ1eVlIcXBjd0NJN3ZFT3dDR01MYmpUMlJPd2ppTUFyS0hT?=
 =?utf-8?B?RGVDekpGNVFqcURCUmNLejFlc2Q2RUJvOUk3Z01mNWcvN3dFRkN0bEk4blJq?=
 =?utf-8?B?czRwaWtNWTlZdnZDcGNoeVFhL3VEUHpSK1I0c1JScEtuYVJCay9zTytaNlZp?=
 =?utf-8?B?QUFsYWwyN090Ujc3L3ZRcmQrNkFqLzFhTXppb1B2S01zaSszeU9YaUNSY3Qr?=
 =?utf-8?B?cExVSmdvMFdwMTh1K05iYWtCaTRONUozeTNiMENCejBWb1JhV2haM2FpRnBw?=
 =?utf-8?B?NHJXTDRaWGZKaVNYMnROZ2dRYktxRjZjVmxraFo0ZkpQcWc3b3hQeUZrSzVi?=
 =?utf-8?B?QlE1SUlXaFc2SGswbUQwWUo0aFRWTXBqVllIOWs0WWM2QTVmajVKNTZCRUx4?=
 =?utf-8?B?azlsVVIvRzRZZGU3MnBkN1ZnaWVjU3BMQnpUSk1mTmxEZ3pkOFJlQk9tSDJG?=
 =?utf-8?B?YkZSTkV4NExaN05TRUpHSE1zMERPOG1XTTV6c2xnOWlEcVk2R01LWkFGODJs?=
 =?utf-8?B?V0dHNUEvSWxzeENQUGdTU21kRXhhdmRrWGZRaU0xM2JmNzlpcC9uaWxuUGhu?=
 =?utf-8?B?bEVqanBGQTdwYnBRWTgyZVZIdm4rdGJpRlQ1VzY3dUpLdXZFUmFlUT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e02ffc-7b10-4a70-5ddf-08de81ced7c4
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2026 13:37:31.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQAuJqLWm1CG1XhWZmJ0/UFGlOnd0qR6V6A3h903J+9AotMULDzejJsDZbBRyDU6pbRBbUubWtI22e9YZ6IKMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO6P265MB7034
X-Stat-Signature: gdyxy48rfkixeb4zh5n3fszbrm5ud1sk
X-Rspam-User: 
X-Rspamd-Queue-Id: C73DD4000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773495455-998552
X-HE-Meta: U2FsdGVkX19vRYUvC7RbbA4FaSlimq80xgMt1tpUnz0PF2ywgq771WMCS33tgZJnWpUk+diZpS9Tq+k/BkUxvyNGg0A2dVDxaUX7njmrpV3JdP0LALCEIxEnHxAjc6bi9ezQLqV4Y2TTVR3lyMGrzny+uU2+HVMf/L/spFxcfy8eu+i97uCt9f1/XqS/mgJKCp3imQ7FQmTdJlQM9WLnW3B9gf+nV/EFegv3K90SN54TD0dzcXUAnzxj7lThAKTfRzol+lHV/axGhdjRO+jfJxbmOGE21Qv5mfY34c9LiitdC1VLoBbxwZC0PhCZtGgs1wTVbUkwYuUWlt+rdNeiV76nzvfaloL+p024ExUtdrpTev8XpVSsLC3b0xOBvBwrn6Gxq9J6N9R2uFrKgxuTeR6vEUgE6h7D2cisovGGB1xrRaUGb5OsLmqwmsfpjXC9PUjkt/ge0vfOFM/47h4J2zn3+UpATRFApXyPxkpjNBqMIOvOJYIu0iGlvmz7f/fryGe4J1FHGuMuLtFYOLjnd5Lydb1rFA4nQWKmsDOfA5/bItx3uXNsVIzK2dgtcuJgiDFOWYYdkggURqIdjsVxbZ0EOQ6wP1svG/RNfbQG1oo978Hv/9JGegeAB90rFdMVUFzU2di9K7F7TISvfzJqCU7JP4AKWk95Y4eIETt6XwMTYN/UNAkkgK4xBHmtolC9vAmU9dEd5+rKyB4zg9qiFJ9pqgAI26p9FS74pgNwOVcU53gZpjDkmQS/Pv7Yn4Ff4i9ak35DaliPr/YErrzVZhb0bWGxxls6UopUoZ3P58t+9/mMcEZ3B7LMudEz++3TEevv2g2swgBUrkRlgXZjWW8TKcWi/Sh5H2B+2iSmuRCOOudMr+SH/5atmFZW7Quy6z3V4nGVyQbDgeVXZSgzfvUCCl/yzZ+e6bupQZNea4zvHbgfoKE+kD/S5mWUBlYaWG4VUxlxWaL2ecSG+gp
 ModbNb+B
 P7DYkNabFIUzg/OU+bV9AiU4rE3h0jQInsMcdr9bx7EupTpSjcybpu6bmHxQEkglhOqxAdf/VTOfvMpJ5kUOtgYA5Puiu7Q6TQng7vpAOPCAKjsToj4erAZjRSOp0CtfqvyYtp/a7EvFgjPP2FsiKvB+XL3oIT6wqtxHrxGwqlkuLxCrX1Yu2qOtfEUzQIS5JRm7WrAtPBigtYTI+8ksmACkzgLmWlvlqb78tccD/rSKXL3tvlgyqMWWbLCz2+kj663P1GrejRITRK4FlG42LYYYG2fmjlNj/JnkCruau+j9VASGcyIgzwzHsy9LfjF+xaDIO7cZTHyAGSlEFqEB7GWDS6d/rdchoGjJcRYSoGsL8+zcfw00C2eWEnwLssgcIybxWkJE0ujm4TDci1lzjWAfSALrIr2K7DWyEFQYLSxMV5+oEv6Ysb7r0xQBVz725mhoHpBzoxumIiXTkith8yz/6bzMy+H1EBmnI8F6qOOYmxoJrTWgX3rB3MPKPAh08QXsAPDjO53GrxEkngiwsxLQjhTPi//QcYnaDa42GbasX8IKTc7MyhByMamT/OjXaCTmXs/udifxU4P3jifHrHGOYkswajccm+lOCPpQxw32WmgMjVR589KG9hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Mar 14, 2026 at 11:19 AM GMT, Alice Ryhl wrote:
> When declaring an immutable global variable in Rust, the compiler checks
> that it looks thread safe, because it is generally safe to access said
> global variable. When using C bindings types for these globals, we don't
> really want this check, because it is conservative and assumes pointers
> are not thread safe.
>=20
> In the case of BINDER_VM_OPS, this is a challenge when combined with the
> patch 'userfaultfd: introduce vm_uffd_ops' [1], which introduces a
> pointer field to vm_operations_struct. It previously only held function
> pointers, which are considered thread safe.
>=20
> Rust Binder should not be assuming that vm_operations_struct contains no
> pointer fields, so to fix this, use AssertSync (which Rust Binder has
> already declared for another similar global of type struct
> file_operations with the same problem). This ensures that even if
> another commit adds a pointer field to vm_operations_struct, this does
> not cause problems.
>=20
> Fixes: 8ef2c15aeae0 ("rust_binder: check ownership before using vma")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202603121235.tpnRxFKO-lkp@i=
ntel.com/
> Link: https://lore.kernel.org/r/20260306171815.3160826-8-rppt@kernel.org =
[1]
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
>  drivers/android/binder/page_range.rs       | 8 +++++---
>  drivers/android/binder/rust_binder_main.rs | 2 +-
>  2 files changed, 6 insertions(+), 4 deletions(-)


