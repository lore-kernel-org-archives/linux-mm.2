Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB9EEA4FCE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B936B0005; Mon, 23 Feb 2026 10:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF97C6B0089; Mon, 23 Feb 2026 10:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD14E6B008A; Mon, 23 Feb 2026 10:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5B1C6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:00:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D8491601DF
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:00:59 +0000 (UTC)
X-FDA: 84476033838.13.6FE5194
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 774BDC0028
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:00:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ubEKdO1F;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771858857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9iGI41G7eak+IdmIyouaoIfuO0S/0MYVm41DxHn2KI=;
	b=myR5kHduYCYGZICPvC+PWKMTg3PYz0r6uxDB25yPGU6LUp8EKWQp4JS6MT1BNHTJNraQ3X
	rIzjTGnhlv8c5C8x8l5+iMAGXxdjGNDQTn5ZWEWoRKH16Zo62E1zX0whOb5EdswMCd4df2
	5veghqOJ/CgOB1fraXS+C/wKTjugSOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771858857; a=rsa-sha256;
	cv=none;
	b=Z5tJnJyVZ4fIpOnajgqtpifa155OBTcdxvy/Lhvy+VGFv4XCtd6b1F4gf6isJZUl3lFrkb
	Bow1x0+o+sCKY5k9DezTVxCE2Bmh0eC/H62Q1/g6fc1Akoi15Gp6qsnZwoaXTaq7x49ESr
	/SvR5+HIE1ZEN8pWyK1xooHZlravmhE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ubEKdO1F;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84CBB419B7;
	Mon, 23 Feb 2026 15:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B72C116C6;
	Mon, 23 Feb 2026 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771858856;
	bh=LZJWPyqc7zRDNeLJ/kaMnDCbQKW6iC+a3VJo41M3xIE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ubEKdO1FeQU4KehKkk4Ha+sWn8rhfohWnTzrm5CQTdxfLOh0UTSboTY5F7p1nHvdb
	 c9CXLVWjqNOPyM3IFuKtP5z1azU7USMNNrUpB7SeVFwk3RoAJYzLxs1vztVb8aZ0Dg
	 +JUgamzo3UrhAJN82wQ+cEgtBc6YV+GtEuO3fPoqKYljQW/zE+0q9rjOMZyhojRUaX
	 oaVPUfn3nyPnD1VlIIcPzhKN1gu3nthfg40z8QQBwjBa2qQIklIls4ZYFZ4SJgFW3H
	 mMimssaZEdP8xcE7negFA4+KTvkjEOlgRnMa7kVg1pSO+AhJHvtIApe4ftxUg+oYUJ
	 HNgCcU376zbaw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin.linux@gmail.com>,
 Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun Feng
 <boqun@kernel.org>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 Oliver Mangold <oliver.mangold@pm.me>
Subject: Re: [PATCH v15 3/9] rust: Add missing SAFETY documentation for
 `ARef` example
In-Reply-To: <CAH5fLggNjCZ3AvHnhO8O0cmd33B3zMbfq+hhNvonznTsLLtgYw@mail.gmail.com>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
 <20260220-unique-ref-v15-3-893ed86b06cc@kernel.org>
 <CAH5fLggNjCZ3AvHnhO8O0cmd33B3zMbfq+hhNvonznTsLLtgYw@mail.gmail.com>
Date: Mon, 23 Feb 2026 15:59:52 +0100
Message-ID: <87v7fn33pz.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 774BDC0028
X-Stat-Signature: 81kzxntaopw6sc5j4fgjij8q49nhn4c1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771858857-119053
X-HE-Meta: U2FsdGVkX1/BCqMmgzJ3YIbwZSEVFiLGemQRhz2OpZIWMFRuaE/j+pl4emo6TSetCyI7ylfTL+5K9LGK4gqVVQrk0ZAlYnMYDm6h7FLCebYdWbN91q5ELA09c4pbFsI3X5CPwX+7+zcDd9ntde70p70i1ixia5Uhy/9D/4vtwBK1s0lMeG+J5V8SOux9ntsHOBatW0srTrwV24O1i/o+ssVBdv99arehBRXRKqi+2K8aA8yiO8tODUH7Y6egsxOX/DGbGb/EzUxC1Yv3Ar9V1ScsapEMbbFSbX+RB66V7p97NOJ1BCTzZ6Rjg9myvdaLCfEmh3JQCM8zhYwU9BI7ZoxPmlYbNfOvd/BulyXQKu6WrEnX3Uypw49ljDKxtX5nXH6ZnrfTPL3j6N2sUnUeAkRPulN0OJdL6r6QsiwNKWzY5FBPU+qtpiFGh348UiO9FEGsO2PVFZyeUq9qctVbAaIc/4LK2T0jGYBLKGZk5xnq4KsssKTHOcnOtSp8l/F1L/6jmiLiP+8Ci+Igacuqc4BIgyOqmZddlgsryfbd666/VtcRIaOxUET6wR4ycsOkB5fB5Ds84pCfT/bbYnAe6VMnRaT4fjdVwBDnZ+wu/OApHSmeGCbaJc3cgSA1LYGmRnw6nzEdXNQCxyx4hd4M7Ev38bRRPl3/kaimJmeFUGUID4OOcUZ2Ud9h//ZTN35Sq2cxFVC5zCCBlVoiDD/lwGtZUtebAHLdAMNzW1C7aUd/Rzu6fzG0yTeJHyC30jcBhs1Q7L1psqZc9PDXubUbwJDTLMGgcVayRJMT2YSxnicsfZ4dagShs3BX8WK5B8WQvIgcskPROyKw6+UcGSUdaR8n7GwwR0Nc39nXkrrcxoXafDZ+XmNGmuFAgqBTAxoIS/VNLA5jUCQpGBNLz6TMvz7KoSg28kn6ieMk/kDtF5NciVZOcgCGDb0OiGjZhBHDtb+5sHL6X6IgJ+v6URG
 E3N6KPA+
 21o2nxdn2CCmxZ6EJ8RKuTY+8vvxSnYc27RY8WyYpjpAuhwCFxm8ma97bx1H1tiDFpssOE0nvCAiUiaB5IZx06OA00+ztGpH6jvRTMdeJ7BuU2Oznx1jaVQcCPnh71a39B+ar4MGmlnqSQbae2Fp9Uf9yoZ6g8/wQroTh+DjZxT5CBMYjl4r530f9fGmGjaUhBU3F5WnrHF5pRgt4Si96Hk9l/hLTWsgdXxRP+GO1NAPSFU7gfM/f8Jgy0zSBAWRTleVGhMlGj9XcSbgrH2Vic1zCdejDuhIG9aykciftH4A7PdxwFqYHkkXQmZWtSsdpUBt6RbBnH1ME5Z3WNUpr1YEHwgitFHMaKH96+HDKIcvyrxCeC1Ej+dKxOd0xb6bvYy3lDg2+iQ/fKmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Fri, Feb 20, 2026 at 10:52=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
>>
>> From: Oliver Mangold <oliver.mangold@pm.me>
>>
>> SAFETY comment in rustdoc example was just 'TODO'. Fixed.
>>
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/sync/aref.rs | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
>> index 61caddfd89619..efe16a7fdfa5d 100644
>> --- a/rust/kernel/sync/aref.rs
>> +++ b/rust/kernel/sync/aref.rs
>> @@ -129,12 +129,14 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>>      /// # Examples
>>      ///
>>      /// ```
>> -    /// use core::ptr::NonNull;
>> -    /// use kernel::sync::aref::{ARef, RefCounted};
>> +    /// # use core::ptr::NonNull;
>> +    /// # use kernel::sync::aref::{ARef, RefCounted};
>>      ///
>
> Either keep the imports visible or delete this empty line. And either
> way, it doesn't really fit in this commit.

I'll drop this for this commit.


Best regards,
Andreas Hindborg



