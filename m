Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCD4606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=garyguo.net header.i=@garyguo.net header.a=rsa-sha256 header.s=selector1 header.b=pxvCQeEz
Received: by kanga.kvack.org (Postfix)
	id 35F3F6B05B1; Thu, 26 Nov 2026 10:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337896B05B2; Thu, 26 Nov 2026 10:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24DBA6B05B3; Thu, 26 Nov 2026 10:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E434F6B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:49:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2C7DC04CB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:49:36 +0000 (UTC)
X-FDA: 85477705152.06.A1A5FBB
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022117.outbound.protection.outlook.com [52.101.96.117])
	by imf26.hostedemail.com (Postfix) with ESMTP id 06DC7140013
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:49:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IpVC1KQX19j7qp7ZBViVcHSe5qqhjvY/+HtUGO5FPwNFjdOBm7VFlDGWqKfp2WSZnUjEJpfFgbOjjxThf97isa8fjAGY3ZgnLbgOehR4kUdukfMC9p6R9wb46oybB/9eRLW4X2EzmPdhbiuMAKboDLHhXJCefyAcFExXA5nrGjWbhTXcFZkUU3Z7ZQ0bvjeY6eIAMTewFldDgMxPQcp+lgSwxVGDI2GzXKDgxurPwciDnHAooToRLta/4nJVeYo86J4JldmCmUBEQIsxE1cWqik3Y4Tokmk2mRfDiI+QAEYD48ypF654xts8nbQf5j6eFPAiVItC9VMZeKpZn5/N3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ez40QSda35CUuJ8kw0NMlMjvzoHZw50eP3m9edVfqJ4=;
 b=IBSIVYTTwJRdzR+AzocWZz1bQc+ZOi4/ehO9Hh/30PZnqBDtSuToPmB8N46m0BhYzvR/7UFKxP8KfSfZr0ZwrU9xtykYcMDPni92OO3cgikcY2+a/ZUM5G/J5TwatMcHRot0MsvFikPJEDbKN8z7+AWrc/XAkp/AIadL5ryUliusFvMZnTk10dwIGC/4k+WYJUJdIsDSSMiePlzrtOILywl2V/K3e0QynocjVkZf899T7p7/oR8TuxPRybDb5fptFBDTdm1VKYLIx1K5Hpm/FXkS4JTXFGNwbVfcJx7TAt8t0u2/iJN63Waq7JBsEJI/jnHxYLUWZ4e4DPN/pSFOLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ez40QSda35CUuJ8kw0NMlMjvzoHZw50eP3m9edVfqJ4=;
 b=pxvCQeEzQcj7MJbZr6AswA2E7vUM2Pyi8pm35Sq+uqOeM16EpZw5L9T+rkeTm4bYj1ROPQsQytOMgwB69zr6M00wyVmI8u7go2HA1xQrgZlnbv7+YGVWFpHNNkbQ6WPMiFj3LLjCkxqFZn3fbzN3gMWwsxOq4dDYN4JVfvrcvHw=
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1cb::9)
 by LO0P265MB9290.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 15:49:14 +0000
Received: from CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3]) by CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 ([fe80::55f6:f98b:7fad:c6e3%2]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 15:49:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Nov 2026 15:49:13 +0000
Message-Id: <DN59EXEWINPV.3UUBOIK6EROAC@garyguo.net>
Cc: <fujita.tomonori@gmail.com>, <ojeda@kernel.org>, <boqun@kernel.org>,
 <gary@garyguo.net>, <bjorn3_gh@protonmail.com>, <lossin@kernel.org>,
 <a.hindborg@kernel.org>, <aliceryhl@google.com>, <tmgross@umich.edu>,
 <dakr@kernel.org>, <daniel.almeida@collabora.com>, <tamird@kernel.org>,
 <acourbot@nvidia.com>, <work@onurozkan.dev>, <liam@infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] rust: bug: add warn_once! macro
From: "Gary Guo" <gary@garyguo.net>
To: "FUJITA Tomonori" <tomo@flapping.org>, <mbkchelofficialdev@gmail.com>
X-Mailer: aerc 0.22.0
References: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
 <20261124.225103.2152350984946270550.tomo@flapping.org>
In-Reply-To: <20261124.225103.2152350984946270550.tomo@flapping.org>
X-ClientProxiedBy: LO2P265CA0509.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::16) To CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:1cb::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP265MB6051:EE_|LO0P265MB9290:EE_
X-MS-Office365-Filtering-Correlation-Id: 605a8b7c-d1b8-4e53-51f7-08df4bd4d248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|23010399003|7416014|1800799024|4143699003|6133799003|22082099003|18002099003|261026140227099003|10067099003|56012099006|261026121527099003|261028144727099003|261021121427099003|261022105027099003|261102123227099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	Mm8wwSWI3vbcknlBCOjukn3f4HxQYXP8liyS0AtWIQSEd2blZVwjYj7mb5WZXIDZFMGY8bIX+/iUNHbontWAZj0g6yIE7vmMBOtmUzm6hp9cAvvXRZenQ+R4awGS9ZwfTqzXg3itcP7RI/U0z+sH2HzieTZ27BLrgBHL+ZPC8utYZpvgjUn8HMmJiXYda4UayBLx8/HmTGv7PAVdiXhxAKoStsiATW202V7RDj8OU4F01fXxAjwee08ipQgD8nIX2/DOPZiDYqt66nWrVS7fjWIZ2tinejtNfNe+Z9hMm/ISax74w2yf+2vZjYvyMzZt0qdiRZAuNbD0XTQW2ize/yh3C2xjP3F10c9aYcTZJ/Dny2k+u2oC7LGiJcKlkh8a/RntrS7MQCIKNaMYlyQllXLEIQP7GVMivtAL0RZ9jcyqVR6im4tMq2gzW1S9VGvX59YBZkSw9rtXU1IdXsGNAcpH7lYoSeHkQ+WbSGHXZIXwnvL9QOYg6K9DCUoj5RbU1VnSRb7LsSebijOOk5pTrZXv9S+SHdzpDWgNM6Srh0qu+1qsSVX4Jf5ikQ9JEd4VimCyaXAlXel4RXuY/CEmTEaFmQ3vJQjCwSEHfgIUe4fGKp9tyPUdQfUZKH3grzJH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(23010399003)(7416014)(1800799024)(4143699003)(6133799003)(22082099003)(18002099003)(261026140227099003)(10067099003)(56012099006)(261026121527099003)(261028144727099003)(261021121427099003)(261022105027099003)(261102123227099003)(261022075727099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azlXWnhEdWtMT2JzdEpXSWpVckZxcUN5TzhmQUhlZXdVNXp2WHBieW82N3Vl?=
 =?utf-8?B?RGxXOWVra0UwUHk1dFRQai9ScDF2bklRYkZ4cVkwNXpQcjBTRm1jSU1IWXp2?=
 =?utf-8?B?WUYzR3pXdCtEei9kNk85aGs4am90eFA5em9aa3Eya0M3SXBXalZaMGFDRVpI?=
 =?utf-8?B?V3laTGZXbXRudFhHU3ozUktYZUcrRStFdW8ranhBbWdrVXpWRGZxOEZRZjd4?=
 =?utf-8?B?QkpSeENROHRva0RkV2t3ck5yOXdIc0s4Nm1hQ3hlL3pKK01Na3RqTFB4bmlQ?=
 =?utf-8?B?WnpoelNOWCtVaC94bGZvQ2ZGM3dvK25KbDlvOXVGWTFsQ3JYaTBvN0paaFdO?=
 =?utf-8?B?Y0lBdmxiVGVUdWloZTBVNEd0ZFlOQ1MwMXlMUURoVlFEeEhUWkdScFpJTDIx?=
 =?utf-8?B?VnRLelpSaGRZdGw2TnVDa3NFWHJiNzRJZ3hTWmxLcDZuT0szdThaQ3NGaVFs?=
 =?utf-8?B?akRVd0QrZGJlWE1mUy9EWDFlNVRmTVQ5Wm1Wbm5ZQytBTFcxQk5jWlBscnNY?=
 =?utf-8?B?OXg0WmdNcG5BdElRNERaT2xDSis0Njl0Z0NwT3BvRDM0OHF3VVFzcEduRlhz?=
 =?utf-8?B?Uy9aeWhJMVJjM0NXWDIwbXNBQ1V5S1JPOTlMcytBUGFVL05oTnBEWVlTN1pW?=
 =?utf-8?B?Zm51b25rRDBqelBUOUI5Slg0cFcvYStZU1I5S2Q5Y0hvM0NhUXM5ZUZHL21a?=
 =?utf-8?B?TW9jMjBRYysxWDFWcUhWanVONXJ1ZGFXZUdSdzVEN2xIWjJYSnUwM25YUjk1?=
 =?utf-8?B?dk5SbnlZdDZsMk1sbFN3M2ZGMXdmVjVqZ0ZnUkpIeXFMODlSbVIrQmV6ZkN5?=
 =?utf-8?B?RlV3R2pYVkZoR0RYUXp1QzlqMHFsU3hINHZJTnFOYzNyRVN3MFZRUFVkRTVz?=
 =?utf-8?B?RGlsOC9FdDlxZEo3T0czN2hDU3pkQkE1MGlvYVBGbGlETHpQZmlyMUNYdEda?=
 =?utf-8?B?WDIrZU5KbEFmejFhbXJmKzVXQVFrWXZxY05sMndJVitkYjhObDk4RU9EQjlJ?=
 =?utf-8?B?K1BHOXhtYmtoSVR6L2FLbC9zcFBISU02K09UMHM3dXhTMlVVakw5RjBCam9l?=
 =?utf-8?B?QUhiQXJmVm1KWUFFVlpvaHlacjIzUUJ6OHNmaWdtalhsRENWNm0vdVRCRmEr?=
 =?utf-8?B?VE5tZlkrQ3RwV1RtSmZ6RE11OVhZc2t5dmhLdXkwSU9uWnRvVWdwaFVlNGU3?=
 =?utf-8?B?VnY5bDlBRXIwREE0RXZROEs0MDcrY013YjBDYSsvdDEwVFh0WXl1QVVPUENi?=
 =?utf-8?B?anVWS1Q3YUNSZDNKN05NUGdndjJETUFET1RFRit4RHptdDdobElIWUYxTDY5?=
 =?utf-8?B?UDF4dVN5RTZwcXFNZ0x5RWsyR0Mrc3Z1NVRSVi9INEhrRTdVNlVqbThoM3Zi?=
 =?utf-8?B?TlJDUXIrSlc0cHFxc1pIT2p3WlVpWW9PTmpnNHJlVFN5eHdJMGhjMkxDVmQ0?=
 =?utf-8?B?d0l6c1ZZa1FOc013bVI2eUxsVWl0ai9WRFpGSm12L21JY0lyMXBxNE8yT3lu?=
 =?utf-8?B?NmQ0UGlGbjRsS25qMVc4b0EwZ0VwUWNoUHFVeWdrNU4zUVdpS0ZWOG9CMi9o?=
 =?utf-8?B?YlRVaDdoMkRpRy9DOHY3WEF6UVZzRHUwaXFaeHhXZDhmRE1jZzdMLzZRWVV1?=
 =?utf-8?B?aUg0M3c2dU9reGFZZGJvSG5WRTZLZzcrcjJkMnlUMUtjWHRxNmFQNjZDa2Fh?=
 =?utf-8?B?c2FCbFhWc0MxeGNVcHVLTWlqOWlGdmFmejVKVUFHSlRpY0x0djdUNFMwbjZk?=
 =?utf-8?B?ZmhFNUlqYmJjYjY1OW1SSWhVUXV5WXpkbitNYkRFRVk4Q0IzQnpia3IrQ0Rl?=
 =?utf-8?B?YWhJK2R4VnQ0aGVOQUwvM3NQSW10aHBkb3k0ZldjM0lyRzRvc1kyczM0L29T?=
 =?utf-8?B?RHVvTkVEdUkxQlRtdGJmN3lhelRaUUVwVEszamVERC8zMHdJWU5Ca3orcm1t?=
 =?utf-8?B?SXcwTmxuVnFIWFJJU3JDMFpGQ3NkL2M2eFNsaHZnWW1uU3FEZ1k4eWhFRldv?=
 =?utf-8?B?UU5RdzdGUDJXZEE5R3pWaDAvbjhpUjVqcjlJb3VUM0tuRDNRczA0L0s1ZmM5?=
 =?utf-8?B?TFVKamRZdXp3c2JUaXhnM2hudVlVWEgxVkdwYzdsMjdxcVhRMnh2eEJJeiti?=
 =?utf-8?B?SkZ4VDlrUzFjNW9EMUJtdm5xWlJiRnAwUG5UOGxVczdQQWdxTlQ0TCtldzRD?=
 =?utf-8?B?cUZqckgwSUlBb0VpR3BTdjJQb01JaDVBZHNqMWIxTTRlc2t3d2tDam1yajE2?=
 =?utf-8?B?bzVWNW41dkcwRG93QUp1Tk5sbWZLZGFFeDlHY1crRDJoMnh5bXVKVVpqT1pG?=
 =?utf-8?B?cENGcVBmRDhUdmo5N2NBRUExTGQ5amZtd0VxYkUyRFFVYTVHQ2hCdz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 605a8b7c-d1b8-4e53-51f7-08df4bd4d248
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB6051.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 15:49:14.4153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/YHoVi+IACdaBSLe0HxbFkByADG5HO8bJT84qXlj3LI89qe7HdCuAiOCi2S2YVGf0oWKSxwq0RooyzmIZ8coA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB9290
X-Rspam-User:
X-Rspamd-Queue-Id: 06DC7140013
X-Stat-Signature: cy4a1kytnmexcg5n7inx4qfyyepxe57q
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795708165-674032
X-HE-Meta: U2FsdGVkX18efSnHYKaBqsiSDlDP7aDrtIQsngHtep+BtyV049YRjBTLtHfvp8uQaRQ80lhBWTbkmd7XgZvshk6ylDN1w/efMCPnyzZUzA8hYskCqzDOLK/xMockWRVE8aDvfCrA4lRBydBauFLKoq4xRqnaj1jP1htnJ/at3TYKtri0XiRkaomf03HjLCOvQ+k7WExDtyZYczlM000h9lv9XzNsCIRxbL4B6iNWSVRmmbd28JyHB+rrGo+PiD04SKyZY7ytjFy1Zp3kRbQOHCAd9XBfUXPFopJdWm9bCVxPTsX3CaK0w36ipor3bzu+M1j9j16B+E5PCLj8mJpQ4b1W8R7KXWtZmvrq1ly2eQ+m/t4fQ4TYixO5VPRRbNnxK+n1k0GOYOjmF+52EkrlMKlEZlKkE6M9UAM9MKla+5DvBhLo/+MVa4RxNzL71sAF459FFcaZqwqtHawpRy48OmOTw6l9jJe5GndkNb8aKtQ+WCSt9yGAzewIac3eu0xOpjTztA3WQXJnQFzpsCmYd5iGsiFU5RZGUP8OwevI21IpnATpWlzybbzV6Pf9mw/jxUxsKH9lcevBOItNOISJkCdZDmaSKoDMH9CwYY1cPIdrU8eCR+yYIqW7wnIaP2sy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 24, 2026 at 1:51 PM GMT, FUJITA Tomonori wrote:
> On Tue, 24 Nov 2026 15:27:07 +0200
> Ivan Tverdokhleb <mbkchelofficialdev@gmail.com> wrote:
>
>> Add a Rust counterpart of the C WARN_ONCE() macro. It behaves like
>> warn_on!(), but additionally sets BUGFLAG_ONCE, so the warning is
>> reported only the first time a given call site triggers.
>
> C WARN_ONCE() takes a format string. This macro is the Rust version
> of WARN_ON_ONCE().
>
>> The macro returns the evaluated condition, like warn_on!(), so it can be
>> used directly in an `if`.
>>=20
>> Use it in Vma::zap_vma_range() to report an invalid range, which
>> resolves the pending TODO there.
>>=20
>> On configurations where warn_flags!() ignores the flags (UML, ARM and
>> LoongArch), the macro behaves like warn_on!() and warns every time.
>
> C WARN_ON_ONCE() warns only once on these architectures too. I have a
> local warn_on_once!() patch that does the same on all architectures.
> I can post it if needed.
>
> Also, this patch does not build on UML, and test_warn_once fails on
> x86_64.
>
>> --- a/rust/kernel/mm/virt.rs
>> +++ b/rust/kernel/mm/virt.rs
>> @@ -115,8 +115,7 @@ pub fn end(&self) -> usize {
>>      #[inline]
>>      pub fn zap_vma_range(&self, address: usize, size: usize) {
>>          let (end, did_overflow) =3D address.overflowing_add(size);
>> -        if did_overflow || address < self.start() || self.end() < end {
>> -            // TODO: call WARN_ONCE once Rust version of it is added
>> +        if crate::warn_once!(did_overflow || address < self.start() || =
self.end() < end) {
>
> Miguel said that "Erroneous Behavior" cases like this should use
> debug_assert!() plus pr_warn_once!() [1]. Also, the C side uses
> VM_WARN_ON_ONCE() in __zap_vma_range(), which warns only with
> CONFIG_DEBUG_VM.
>
> [1] https://lore.kernel.org/rust-for-linux/CANiq72=3DtKVD13GD2Bzmt_LnC4Si=
OX1nkHQPcz2BS=3DP=3Db23e0Yw@mail.gmail.com/

For zap_vma_range I think we do actually want WARN_ONCE. For something impo=
rtant
like zapping a VMA range if thngs are used incorrectly we do want to figure=
 out.

A debug_assert is not as useful because it's not enabled on kernel shipped =
to
end users. A pr_warn_once is not useful because you don't know who's callin=
g the
library and causing issue, and also a dmesg warning is mostly ignored by pe=
ople
like a WARN.

I think a condition is unlikely to be triggered from invalid userspace inpu=
ts,
and the misuse is actually a bug, we should prefer WARN_ON because that's h=
ow
can get things fixed.

Best,
Gary

