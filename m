Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C42D5CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF496B008A; Tue, 23 Jun 2026 09:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0106B008C; Tue, 23 Jun 2026 09:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B81F6B0092; Tue, 23 Jun 2026 09:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 763226B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:12:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D14D916706C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:12:52 +0000 (UTC)
X-FDA: 84911217384.17.0350D4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 55BD040014
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:12:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViufDM0E;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782220371;
	b=nz+pSKhKqdZPPdEXF8V53Hplm7xE4+0EeW/bemZpuX43ABaAW9j2Gv/N9f0EWG1SluLYyT
	WhdlKA/PifuZq7ZKDU/V3PZOixkv1Au82t1V6LC2DOhdu3TKvyMUlQdEUhw3f2IQKYdasA
	O01m04vENNfnq1bIo8esjG/R5Mjoqcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782220371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rzFpQ8O/10QiSxDOc9EPIkCdPQE1on2cJQrgpHbAZE=;
	b=hVmYXNtk7DnJODvY7PwLPhW1aezzi00p2A97NH8BFCjazfieOC3uudTV0XLmlpyyW76uLU
	HpAbW4W+uK4vUahdHol81prNNGPbWUpg5djBdLbFD0FhzhyxtmpR6tbJ32D8JLI/YzssQA
	pzgdMtF0tmS0cEv02McT0+zzY3YY70Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViufDM0E;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C99EA60052;
	Tue, 23 Jun 2026 13:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922CF1F000E9;
	Tue, 23 Jun 2026 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782220370;
	bh=+rzFpQ8O/10QiSxDOc9EPIkCdPQE1on2cJQrgpHbAZE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ViufDM0EZ7iUxbOYXY2wdI5lAjc9KlTZkhijrIJU9IXCwHIq77eaTYi1q+b++HSJt
	 jRu44bv9q4fNbTcplpUTdl0GDJZVn840Fzexjq6sM7GPsYSYiTwtSkcLVYnzJSyZXC
	 XfMSaa+2lXkLKi3I8GME16fOL0/IlJBx82RnEsWbIgLgfIOVvDS8Fqgg/B4uDOaU0P
	 8Yzb+3txaIfMRxZ3u8Rw2Mf2i/3MpTM5foSzb9RR+Z7S8KQiluZIW5EyK08LEoiVk6
	 4B8eyMNZnIAxVokQYMJlAOvP7Ap0MNQAr72k2+A6DrfvBqVFG4VbXV4/dMqiiLtFsS
	 GX+wqSW8Cjyqg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Daniel Almeida <daniel.almeida@collabora.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn
 Helgaas <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, Boqun Feng <boqun@kernel.org>, Uladzislau
 Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Igor
 Korotin <igor.korotin@linux.dev>, Pavel Tikhomirov
 <ptikhomirov@virtuozzo.com>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 driver-core@lists.linux.dev
Subject: Re: [PATCH v17 03/10] rust: implement `ForeignOwnable` for `Owned`
In-Reply-To: <DJAGDGPKZ4HX.M47NMAU53PCJ@garyguo.net>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
 <20260604-unique-ref-v17-3-7b4c3d2930b9@kernel.org>
 <DJAGDGPKZ4HX.M47NMAU53PCJ@garyguo.net>
Date: Tue, 23 Jun 2026 15:10:44 +0200
Message-ID: <87echxpfl7.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: 4ae3gkr3b7pjbbcfx9jo3fkmjgm4db81
X-Rspamd-Queue-Id: 55BD040014
X-Rspamd-Server: rspam06
X-HE-Tag: 1782220371-958973
X-HE-Meta: U2FsdGVkX18Y6NpiMZ1VF4yBGymDTfpb6PLmfk9FqO007zTp6pN3d10ZcddP1ybPmGeW4Gl/tpNH1ou5UZrokkQi+DD+15yg53XbE97SaATbWhSmN0yxcNn5+OfoujYbrYQUyQLjCMQcInD8sQDG3XxkH7FEhiEfPg6DrxqR4shGeK41W4bKfhheCfk5CNje8ORQd9lgZczHZ2p2O84EDu0KrFH+Eyhf6J0ML+saH8rw2ohOsh5EdBxnFt+AfE9ty2U21k/wB7/bia9XfLed0dAF0Nqk8v+qlqSMdoNymzGn/S2j8uJP44AfFHcjFixNs7uIHd02kjHUCnWDPwEALhpU6L0Q/DDTtZBdUkCfW8T0bXw26hzWx3AXI3mvuNnzMGYnfj22sBQ3PncWu8l4plpoLT3kHEfFKkqjRhSRzFNZGXeOxZNSwiaTNvir/hlNXLmvuIGMJgj0+Kg8ajYi6xhdDRgNB2KreIMLG35n6gdMPE9+nJBMk7tKCrOiU/VzVTdSX/wJlVAL0BRUuL21/+697lxDWtC1yNboT4AaKgmUCuebpZR6kjzAsO/1vU1C07miU+KXCDQuilIDFhcDgxzAYBsnCyCVSZcjQ1x8cybhsc/vW9kPBAzU3gei9gW9qOi9c/v1sPlIRX4WYz/HLqex+boRXrTmRexcg6ybyAwBRldeXRd/6Gh3Bu0sZeNgzrGdCZ2Ib8DX+s+JEvLm7DpZoPyPqXkBFIS51BzyDm1pv5bVkBHW2tOP7NnR2V5sGqTHqtHj3fwNJwnuzRqdbQCcv/08opMLcZENG/bolIrAkXVgXaUMa1tgcd3AxgHSysyoHnuSbwTDD6lVNGA23W7WcAoFSR0SJoWQcJrEML/3hv1mOWwblpGfbmGCAVItuyn791PiwxXyT0vV8s1kjf2qr8Ydf3zFyiY0vaIj/KY1XEkT+VRn59LP3h9xTOeQ1cKot4LpDmXwHENZe4t
 t7AZIyYO
 rkQb0G3lbKmk0Uj5NhBwI/eThKogmk0XmILFUO4wHG9Codt1PmP3fWSnYlTUjsdDGw603oYvpRD4jyK8vAzMOoabscEZv/q38sylGiuTMP4SbYXomo/9QZECAcLrTfwi/OJwWihTdpEcEX0HXlsxLrijHTlkk6kZeT3mfyGcIitlI11KdMOjRVbuSPMXKeXMUoHS7CC2cbXPv+0AMLTJ/e05tBFLicCyvRccXMjmQ7ibXv3bJ6GIg/W8j9FrcRJKQzWVy8dxnTM5zNIHKsP0sQKeTqekpRqNY9pOt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Thu Jun 4, 2026 at 9:11 PM BST, Andreas Hindborg wrote:
>> Implement `ForeignOwnable` for `Owned<T>`. This allows use of `Owned<T>` in
>> places such as the `XArray`.
>>
>> Note that `T` does not need to implement `ForeignOwnable` for `Owned<T>` to
>> implement `ForeignOwnable`.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/owned.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 46 insertions(+)
>>
>> diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
>> index 456e239e906e..5eacdf327d12 100644
>> --- a/rust/kernel/owned.rs
>> +++ b/rust/kernel/owned.rs
>> @@ -15,6 +15,8 @@
>>      ptr::NonNull, //
>>  };
>>  
>> +use kernel::types::ForeignOwnable;
>> +
>>  /// Types that specify their own way of performing allocation and destruction. Typically, this trait
>>  /// is implemented on types from the C side.
>>  ///
>> @@ -108,6 +110,7 @@ pub trait Ownable {
>>  ///
>>  /// - Until `T::release` is called, this `Owned<T>` exclusively owns the underlying `T`.
>>  /// - The `T` value is pinned.
>> +#[repr(transparent)]
>
> AFAIT this `#[repr(transparent)]` isn't actually needed.

I'll drop it.

>
>>  pub struct Owned<T: Ownable> {
>>      ptr: NonNull<T>,
>>  }
>> @@ -185,3 +188,46 @@ fn drop(&mut self) {
>>          unsafe { T::release(self.ptr.as_mut()) };
>>      }
>>  }
>> +
>> +// SAFETY: We derive the pointer to `T` from a valid `T`, so the returned
>> +// pointer satisfy alignment requirements of `T`.
>> +unsafe impl<T: Ownable + 'static> ForeignOwnable for Owned<T> {
>
> You should drop the `'static` bound and put where bound on the GAT below
> instead. See how `Box` is doing it.

I will take a look.


Best regards,
Andreas Hindborg



