Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578BED3F06B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 14:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C746B00AA; Wed, 28 Jan 2026 09:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BB96B00AF; Wed, 28 Jan 2026 09:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352146B00B1; Wed, 28 Jan 2026 09:14:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 253806B00AA
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:14:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7F8F1B11A4
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:14:57 +0000 (UTC)
X-FDA: 84381569034.21.A89C2BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE543140014
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:14:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzLKVuKk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769609696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/02rtmIEMs4VvyBJQmsxL+BH3Crmgxcb/R+k8w2dQs=;
	b=hdlw10fOchtez9Rbs8AhA1ryhp0tvEdkFlB+4/IKxwAglwQ9Tmr9GADwbhVBNm4niZ6k3h
	m+7/5eaSFV8gATrQBzgJuxZSxKFvhaL0dGuRQHXBtrM4Bd+UvVNTvxoNoLMasWeOLRMaoe
	LRAF21FiknTiVTv28/jrWOAGxKwG/Xw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769609696; a=rsa-sha256;
	cv=none;
	b=Xt8hIDv5B6Cxm+kyD53Y6JCE8MA8Zoz80LE5dZKVrGczbaVaraXtDlfoJoCZXVHuYCAdBK
	TrjNGzMVFv2AViFD4Z/yoBtdmPomagTibebaZ8fzldyoouC70BqFomQncz8OwetnBjhn+d
	VZ0l97L5Yqq4Lh/7tf3zEUS4zTu6Pgk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzLKVuKk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 063AF4072A;
	Wed, 28 Jan 2026 14:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEAEC4CEF1;
	Wed, 28 Jan 2026 14:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769609694;
	bh=yDghpFh1W7FxCJIU+PStYBy8as07UgH4YWAZWQ8SyD4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bzLKVuKkI3Ahc1uo7JhT0kDwkFR/7YoYjycgGNwZoYJzJtkCL4gPuJVwHxloP9RjX
	 EhfBRonSwhW64fugHhak8dWykFCwCVudNiNrbqZoxjZIvj9hGt70TNCdaX+i97kzLd
	 yhGekKV5ovYPgl4W4MAK2jtlmH6i8DrFPHcopK+eM5vbfoMPYO3VgzjtiDCI80URsU
	 tPInQPYFpRtXz7kgQkgTJLxirV+waxvTNcw6lMIMMspnhkwnSbbqXvJAGiflC8z6H6
	 eSFOD7H2whqYiYKiAJLGIw1AaSDGjCZabShTq+e+5J3fQRisJHhsaV/oLeLewILHKk
	 l4GIg+OSkrLpg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add `from_raw()`
In-Reply-To: <DG09CF1T9SQA.2LKBUV75ZPS1P@garyguo.net>
References: <20260128-page-from-raw-v1-1-b837bd3e0545@kernel.org>
 <qXRxvUYfKk7WCX_IdF9ulmBVTVBDbOkDSg2GYFzEbT_8fLtVFMfT45hs7oCXaZnp4WU1R4ylgTQmBvre5Fnr4g==@protonmail.internalid>
 <DG09CF1T9SQA.2LKBUV75ZPS1P@garyguo.net>
Date: Wed, 28 Jan 2026 15:14:29 +0100
Message-ID: <87pl6tsu2i.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: EE543140014
X-Stat-Signature: jor4mpr5kqagbjzikwnt48gfczd5higz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769609695-82960
X-HE-Meta: U2FsdGVkX18pr4EG5SM1VMdhCzKVkwyq8DTSmEV7p30zV6V+u75MG584gsS+1A3BYplh8H++lkxdi9nEd5L3acaVCdU5HhqDk0jzc+gORXvp0wcLSp72ItSxViyJu0Xr5GwyW+3crg8ngFRZ0QKKs2A1yvEmYnM9dKWSInXaFMvQYs/fkLEpW+gsQdpIT0sBBn++m4wau0rYB3Xr2A9Hr2m/Pax6sfzE7xzpC9SsaMp+2JA71is6sH+uwAvMWEN/uYyrpv6sSjjMywgJUEI1XzpSJq+hUe76yfAPzAXctRGmWdPyUNgJ25+MMni3Gfr2BLE4dHonuzWKOVuT9PkxnI8byXjBlJMTP/PYLHssxskBN5BGUzcdQWvc6rpmi5745h6e8cH10EJNrzb4F6yRXVj5HmX9NJeSy1tezFXu+0yWT81yHog1pv9FQOcyEkEHhvb8JF/+qI0CIHIQNK8src+pOWzt5I0iudt9CrnkZYiUUQ4DjnBkp0y6ztx8kg5gd5cAsSwS+fqiKRTbSq7uH2xVVu3S37Z3LvEXe+zfwkQGPFYlLMMWmNdznijxBWsGWhEksgj35ss9DmNlEDvijJzjqNDEK7VHGVeIynXkT6nocoKKQQCLSm2Cdv6y2MtpSJkLI0KLLrq1MVM3OSP9jJ6SVSik3b1hGPFUBCwPHhJ38BrvOpXmf/xcTddD8O71++U7MYjMdm/I/C/q3um4PwWhVTnMsLIOKxuFScj47t5j2JWmoLUvwo9znPjpXWo26Vm8Vp1vjbWKT5tS/8bpqBPN1Ki8F0Vd3qlc6gGZ5/VeJxBOJJktPLIMjWg9LXkXf5VMIkOOFPTUW3NA4XPNYYLrhDkyxj90uTIhiKE/e1RXrHyLE0MFhhnU7sEBkneg/KaEif5aDbS29+aRTb93TDAr6adNZN3kD1SG1ixZvnQrn1r83+Ldk7Bfw8YMDQ7GMx9zNyKERE5RWTvArvs
 D2KCvged
 QdK8mdJ4wrKlED7KyrSZJbtv8d6SG6wGhU/AHnlv+Jwvr2D2oIgoMnl37S43wtR7MlCri18h9wGu/2aajbDXOsAtLUKr2+WTji8mbGhoMml5pIQQC+9w+LZYRKGMq2FRX3o2G0pg3puotBkxnmvQM4lE2c60zE9gYxhsMOe0/dtIIGNYHOF3BrIbaRuK6lMz57idUlGccVyj0N028BJ+fpPovT/Y331ek1VNVvq7a8qh33vKtmW7dWcF/REWvuwDMxxGBSP1tF0LpuwYewPIIl14ph0+lJ/wJsv67Z29HJ94C4P2mZUK+8uBbK2kNLy2cqWqJO5zIAm1QzwIZPKlIDEU+62AX/LGFGSwamAs1PmByjiay6WGjighVgLjc3ZQtI0Rn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Wed Jan 28, 2026 at 1:22 PM GMT, Andreas Hindborg wrote:
>> Add a method to `Page` that allows construction of a reference instance
>> from `struct page` pointer.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
>> ---
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/page.rs | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>> index 432fc0297d4a8..f666c92fcf451 100644
>> --- a/rust/kernel/page.rs
>> +++ b/rust/kernel/page.rs
>> @@ -176,6 +176,17 @@ pub fn nid(&self) -> i32 {
>>          unsafe { bindings::page_to_nid(self.as_ptr()) }
>>      }
>>
>> +    /// Create a `&Page` from a raw `struct page` pointer
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// `ptr` must be valid for use as a reference for the duration of `'a`.
>> +    pub unsafe fn from_raw<'a>(ptr: *mut bindings::page) -> &'a Self {
>> +        // SAFETY: By function safety requirements, ptr is not null and is
>> +        // valid for use as a reference.
>> +        unsafe { NonNull::new_unchecked(ptr).cast().as_ref() }
>> +    }
>
> This is wrong. `Page` is a wrapper of `struct page*`, not `struct page`.

Oops. Sorry. This goes on top of a conversion of page to `Ownable` that
I did not send yet.

Please disregard.


Best regards,
Andreas Hindborg





