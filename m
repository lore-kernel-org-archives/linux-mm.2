Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA8CEE73157
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 10:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6E56B0095; Mon,  2 Feb 2026 05:07:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461086B0096; Mon,  2 Feb 2026 05:07:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387CD6B0098; Mon,  2 Feb 2026 05:07:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25F526B0095
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:07:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A595A140B3D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:07:26 +0000 (UTC)
X-FDA: 84399089292.26.80BBC55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DFFA9180005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:07:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HQK92qyI;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770026845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF2lVIeEqrHB7Z7MptMoAgaQyJXQFqtW+sssvbTmIJ0=;
	b=Pbp0Qw049uqzlyD+FZP6WblB1ykW4bRjO3LCzfrdqRmF1gQHsOAqOsPsMqdajxxg/Ac3VJ
	ruRgsikwc5hqRPhmSTosNNbVks/q5tSiulW0qkuU5bjpyAdCm8b7cBWKN7TqRyJynnCsPG
	ktsTH0mgdiLg6qLF3qWEWnGadFUDmvQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HQK92qyI;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770026845; a=rsa-sha256;
	cv=none;
	b=npxl/eKZuktgaK9baDdmq6QS6fX1oQN3BzbyjZQaHlzSdmMkH6/ZIaYwN1nzadnUH82dLH
	Fyo7olleY2bDPAZyjYOvPDrgpxunuIrIpIakmuP/EVBesIk4dMkNDIlb/fPVCrG64N7v4l
	+YzTOib+Hn8pdQ40D6NFRckUUkJL9h8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCB5543634;
	Mon,  2 Feb 2026 10:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4150BC116C6;
	Mon,  2 Feb 2026 10:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770026843;
	bh=SPlQg0EyU4/DCh7w2oS8RGOQsjsSnbyrEHo3KSL1y1g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=HQK92qyIX300LRHc2aMK3ubwx7dgLYNuRzLyUUyPldXvf3QcHTBEDznZO9XmT4/xY
	 CIU2+TouJ8b0UyXd4vzERXzW5Cf/dUF760N11p4gF3cvmqGdeP6kbv4bIv4CmGBiEz
	 CDCnliVNe1XhjJ92SpkO91ctMJIVid5sN0XpQW6xEMqM9ZRi57oVT6jhJCBSG61PPe
	 R4n80mZejwHKCRPr4cKNCtNbgTV/LVPVx//RFH3C/pvvRBkuacSHU2tA3lconM/VEr
	 SyWvAEe6FO1M+FglA7GJxmfGwSWOjAC0xiQefn+pDeRSa4TkXkDF8gUy6JFDJawicR
	 x2altsxN3dX5w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Daniel Almeida <daniel.almeida@collabora.com>, Oliver Mangold
 <oliver.mangold@pm.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo
 Krummrich <dakr@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira
 Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth
 Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, Paul
 Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Asahi Lina
 <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v13 3/4] rust: Add missing SAFETY documentation for
 `ARef` example
In-Reply-To: <06C410F4-8534-43B4-8DE1-039F70B26E5A@collabora.com>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
 <20251117-unique-ref-v13-3-b5b243df1250@pm.me>
 <06C410F4-8534-43B4-8DE1-039F70B26E5A@collabora.com>
Date: Mon, 02 Feb 2026 10:52:12 +0100
Message-ID: <87tsvzpj5f.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFFA9180005
X-Stat-Signature: xdjbtei3jff6uemskrb77jybgaa8exzf
X-Rspam-User: 
X-HE-Tag: 1770026844-706666
X-HE-Meta: U2FsdGVkX18+tNuuuBFYBtxb+31rBxDvFPlGVU9Pkjvl98l1U+jMGgBDPh6W7Ax9D1tZQnuMnL1pPrHw76DN0i8A+rIyiqHRfDiDFM7wIa/AXvPSgKRiAqLUXT3boDwzQkISxnArXGQeZCPK0XVTuu53998NxtfUE3+6G9ptNVuAQznZgAcz3+pMv2fLdv+1R1hyhzxMBljqNB+WzbvUDFXCLJ0fh8wtCmyJDJI9NvwnSjgUUw+un4nZ5iLb/4ALvUT2cV+4h4WUjjWaHWdpRn+OhIUReqWpRLmiEM9xRpORYIdgPLzwn0QzkMnYmgaSNRbRrncYZ3gPblxp6JUr3xIuEFNax21T8XgcCwbKSkFe3pAY+EJNA0vB+0lTfHWGbqZHTe2uYGs7yVhuT6zy1n0AlFDg6xEQ4YTt1Qn6GcPKOO9QUNPVoBCrhISXGsxpj7uk0Yiq/4clkXPYf05W+yNbSoEnK1KNEbLv0C3V4wnt6j8xbU+h9rpT72tsmlWfS697HTP9F3619wRuVTKE8dgOmKjwkguD4SB/r+0I/FApgU1w4kc08K40boqWT+NhEQM4btVSXSH/tl8o3aRLLCcReQDb8RxyQmxGwgK5/d1UTlBw1TObabxAypD+mG76XOCzelLrfD3Z0OhFai/8SMKXZfngKJnXgWy1CT51anIQ8R6BatskOm1tGJFYEx+9V2pFpUFD3eOn2qhAh13xvXEqKXVwDy7R3WvBQUCr2mOALctrjaxp4d77kBWb+Uurp/iuFxtVHFwrFqol3xJw/4OCmP2keMQk9CFuMcGpG1c7t+ISaVrfmstJeFZgDSTf0gsap7s7d3h7QPnT+/1DUtKk5wp3eGtI+5MY7/hKnCJ5wcqIW95BYoeYALokeQyW0Iq80J1SmYi5t7qL6y3NV+GIgnNv489jCeqDxPm9Yv5GeU0PxcQoW29XB89RxhP0xlbCqxdVtQjrnW62Lzy
 6QR+qRn/
 Q2C6y06MfuZOmYLhk+bSM+HsfgD5Lh4FxX9cGXAJNkZ1jurE8ZxL4UhHwuE4GYeoB/us3AV6H7wg6zQXaBGlm+jRlmAwxXcu1hjYSpUVHl8gB7snYDeJ7xjfVTrG8pbiPSE3hx3aO5gzL2Wd7cwPEW3V4mv2vR82JXl6JCsUPJ3gAcCGv/RSgAz0v3TW3G4nu2upjQWJoLTVNos0K8RdKVdsbU6wvDtUYQKex1VyeyRLl3Ic36N5zmPFtZlOqPI12xFFnkqU4ZfcNoSI/0ALW8HmvinRjCDNrbFd7SShephlMloq+uhPZrW11ecQc3vQ+uEtZ/kUbPLVGpvyccxyPW7T1fQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Almeida <daniel.almeida@collabora.com> writes:

>> On 17 Nov 2025, at 07:08, Oliver Mangold <oliver.mangold@pm.me> wrote:
>>=20
>> SAFETY comment in rustdoc example was just 'TODO'. Fixed.
>>=20
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>> rust/kernel/sync/aref.rs | 10 ++++++----
>> 1 file changed, 6 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
>> index 4226119d5ac9..937dcf6ed5de 100644
>> --- a/rust/kernel/sync/aref.rs
>> +++ b/rust/kernel/sync/aref.rs
>> @@ -129,12 +129,14 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>>     /// # Examples
>>     ///
>>     /// ```
>> -    /// use core::ptr::NonNull;
>> -    /// use kernel::sync::aref::{ARef, RefCounted};
>> +    /// # use core::ptr::NonNull;
>> +    /// # use kernel::sync::aref::{ARef, RefCounted};
>>     ///
>>     /// struct Empty {}
>>     ///
>> -    /// # // SAFETY: TODO.
>> +    /// // SAFETY: The `RefCounted` implementation for `Empty` does not=
 count references and
>> +    /// // never frees the underlying object. Thus we can act as having=
 a refcount on the object
>
> nit: perhaps saying =E2=80=9Can increment on the refcount=E2=80=9D is cle=
arer?

OK


    /// // SAFETY: The `RefCounted` implementation for `Empty` does not cou=
nt references and never
    /// // frees the underlying object. Thus we can act as owning an increm=
ent on the refcount for
    /// // the object that we pass to the newly created `ARef`.

>
>> +    /// // that we pass to the newly created `ARef`.
>>     /// unsafe impl RefCounted for Empty {
>>     ///     fn inc_ref(&self) {}
>>     ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
>> @@ -142,7 +144,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>>     ///
>>     /// let mut data =3D Empty {};
>>     /// let ptr =3D NonNull::<Empty>::new(&mut data).unwrap();
>> -    /// # // SAFETY: TODO.
>> +    /// // SAFETY: We keep `data` around longer than the `ARef`.
>>     /// let data_ref: ARef<Empty> =3D unsafe { ARef::from_raw(ptr) };
>>     /// let raw_ptr: NonNull<Empty> =3D ARef::into_raw(data_ref);
>>     ///
>>=20
>> --=20
>> 2.51.2
>>=20
>>=20
>>=20
>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>

Thanks.


Best regards,
Andreas Hindborg



