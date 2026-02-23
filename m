Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9567CEA4FD2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C5B6B0089; Mon, 23 Feb 2026 10:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16296B008A; Mon, 23 Feb 2026 10:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E360A6B008C; Mon, 23 Feb 2026 10:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE0C46B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:01:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66D32139919
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:01:07 +0000 (UTC)
X-FDA: 84476034174.15.B54F713
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D620A80014
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:01:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HOrhgw47;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771858865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2C1A7OwNYuJrMSDy9hYxiHNioYIgYf1CuiO+Ailav6Q=;
	b=ndC3X/jrCv50DAKWeOjaXHk5qpfC6+BUYgkDMu5jRgnhLQqNYChGtwfJLrJaaaSb9YWxJc
	fHw1A4T5j9YDjHRkR/4ivAp8f3r3CwHPzEyNkENUXO323STWDT7XUhDpZ1fqOT6L0UAroT
	Gh7j36OE9P1oZz1ZUC3y8rEND629sA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771858865; a=rsa-sha256;
	cv=none;
	b=Tff2zAcVEfui+fe3pfSMTUvCRtJm+mFfLG1XsNpFZabCDcYk0NOpfXHM2W/DkxL1lKWoj7
	LwPFfbDSMJIeEvaoCchX295VCVxp0nsj4JeRC9Bnp+YyUsLchRviXHYgl9XtJQupa5Piqv
	8dJqoygX/XUy8QkunUpEpcSJAD2Q0vs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HOrhgw47;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46A1A600C4;
	Mon, 23 Feb 2026 15:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36122C2BC9E;
	Mon, 23 Feb 2026 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771858865;
	bh=B2xz+fKywOWEPJTQNuZF8b8xXnGtl74+wA7wAJ3QkxY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=HOrhgw47XKZDmMg5MWkMID+V3NSTRD5aXf9oLJqWATirxNXAGLX+AzBhK9DL7ue6Y
	 iRjkFN9I3/9860PJ7I96Gu5l3xhG1Pf/AKFbkpRbHcrSIXFHoNB2OEEWs7mRRV6Izi
	 HGpZclyGYgQs7dVfpAkVYQmkKnaPs9hGG65AGpFxST0PIg6b7LxgokRWLq1Eyxa+Qx
	 wvlDVZdEUlxqyvh9oRaiOrQTzUfjRfh9ud3uQ439zrysDb8s9wZeSTo3VZTKm0OqNO
	 aZ8Uj8uN/cy91LRX9q+l6LK/lc2Rx6W9BDqezQ1KFQv/BIP+k1F/EXHMQMxLhbwijq
	 B35CWCvsJpVnQ==
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
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v15 9/9] rust: page: add `from_raw()`
In-Reply-To: <CAH5fLggNQD+TbA7rXVB5w+O+qHcJcYC4u0b3W+mHR2DZiUe4eQ@mail.gmail.com>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
 <20260220-unique-ref-v15-9-893ed86b06cc@kernel.org>
 <CAH5fLggNQD+TbA7rXVB5w+O+qHcJcYC4u0b3W+mHR2DZiUe4eQ@mail.gmail.com>
Date: Mon, 23 Feb 2026 15:59:59 +0100
Message-ID: <87tsv733ps.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: rq57z5t9ig88ewu6nb3h6sezgfjdh9j5
X-Rspamd-Queue-Id: D620A80014
X-Rspam-User: 
X-HE-Tag: 1771858865-439283
X-HE-Meta: U2FsdGVkX18+1vKA6UptzXXcE6e/iGra+Zr8R/tvdeUZmO1u1WLjimFstOHxWG/4YgwzZNXL4xbXV6J1B6K2q2rAEOMplRoA4m9OJDKEt/jqqK9MTT8JR8fkcd9hQYMb/CJYRduTMIVBNUKRdefE7jmB3UpdMaoRWhU6ISGiUII2Ie+GnzWQ4UK3yQhEUyYPRCyBBpKt/lNUYkAyZ91pZFfvGbrNl17sbUyn3YviUwZyF1NWxkLk93MlwPzAIdcC0414Mo1BRM/B4G5JWdZcSgqiCq76qAo+0ivIXMTHD+QWqyc2S91nIPsBQZQ1jHZNKbgGoxEMe840W77EXeSWpyOVNdQTz+DISMf6guGYNaqBlBDnEi4AUN6QE+2/JPw1M5S5J6tsuywAbDbFJMuuxAR4QByiIB60C2WuZX5/1k4OXfYSUtJ6Qh9A64Z3IVfJhqdVBbYxE2k1MiqwFjAOfi1qU7zRN/6+1lWDAemjkRRYMTN47mj+kZlwoJoA6iblIRowjd9P80svGhY2RPw5tEx1+xQMumSZ+lMejBv4ZMf4VfKJ4OWHrK0rSdumUI1RJmgS+Splub8Yf9RiSXgPKxk8YKs8GB8adxdqQpGZ83h9nYvbrGMzS9ulbQYe6mx5bkYuoJ7smBpLEIHMBJaBoG56N3391xFOLNfpMxOPvFL2+E8rd4/mq3MsitumjA2mqhQBge9SuVY/L9i1SocCUmB8SXizBkDm0iEN0aZT0XhT8UrSuym7vdQcLvPezUWBF2EuKlTQ8e6MoOCiUPYAf50ZvCSi8voeLLDhFfF9p/SWJRmQncBrh26HtwPeAYOe9trU5hRrZkrG7VTuxLgsZmjG4KxI/wwjMnXf0zqRGvjhb3V8ZXxNXavKXaXo9RGpW0tPNuAd6VYb4FZG/hmeXvKnTTWX4Ub6bFkPa/eByixjfC+qxlcHDM31Aj8ihSbxHXPrvp+p5L8nsUBPtCM
 kGWZzaio
 /exClRo7Dfyw6Oq8J1shaGlK3YZ/0tTD/d1vV7qV6JaYoP2JaskDgazgVDcNfwzGTWGhmt5hjC7y9u7gT2bH+RbmIlnir8Sit09EU7A6WU9phm7Si+rQDqQ2eezKLUG30bB9LmlSWee9hAqn7AK6N1MNAoQ6+4VRGJpWghu/cbIn0QSo2FMSVB66W9youHyCYBzx9kfao6HkpU0f0Ou/PkTHBLONeBN0OPvBtYik2AHtBLH/UaGDCRVBqGKl1FWopRon+KPX3tTGgb56ZZGVAM6NWl4uV+7nC7+RpD0cUveTD027KbcnlkN/M8tdJhzlhXXjK33YW/wpozDs61ka9Va9A6O75KGShD19fqxjtm9hIlh3IMHRw4U8lgDT3qZiQXV2b5dkIbA8tM3/CHlUH1ZVuug==
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
>> Add a method to `Page` that allows construction of an instance from `str=
uct
>> page` pointer.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
>> ---
>>  rust/kernel/page.rs | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>> index 4591b7b01c3d2..803f3e3d76b22 100644
>> --- a/rust/kernel/page.rs
>> +++ b/rust/kernel/page.rs
>> @@ -191,6 +191,17 @@ pub fn nid(&self) -> i32 {
>>          unsafe { bindings::page_to_nid(self.as_ptr()) }
>>      }
>>
>> +    /// Create a `&Page` from a raw `struct page` pointer
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// `ptr` must be valid for use as a reference for the duration of =
`'a`.
>> +    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
>> +        // SAFETY: By function safety requirements, ptr is not null and=
 is
>> +        // valid for use as a reference.
>> +        unsafe { &*Opaque::cast_from(ptr).cast::<Self>() }
>
> If you're going to do a pointer cast, then keep it simple and just do
> &*ptr.cast().

Ok.


Best regards,
Andreas Hindborg



