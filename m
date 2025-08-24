Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89DD0CA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 13:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08256B00A8; Sun, 24 Aug 2025 09:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBDD76B00AA; Sun, 24 Aug 2025 09:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7016B00AB; Sun, 24 Aug 2025 09:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 929C46B00A8
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 09:18:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CB0280974
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:18:33 +0000 (UTC)
X-FDA: 83811705306.04.FE44366
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7B158140009
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:18:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XkDBN/xE";
	spf=pass (imf26.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756041511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJw2yvhvcFbhaulELqjS2/eDWWtKUn63h9tnvinVkkY=;
	b=hF9TZBxLTy0v84vRZ5hVt1gwJj4Cx+UkPrYzWHjw0tqHRxlPuQ8eHUdrPAd2PwD1MlOXiO
	XBymGSaIrrWjCIkDuDlcdLfXfP/s6xc3+Dtpgng8bIbmL+g7WEKXX3o5MDgI5wM4FMOKaM
	pgs6vG2uA3BR/sMs6Br4OqHzVJYaWjA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XkDBN/xE";
	spf=pass (imf26.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756041511; a=rsa-sha256;
	cv=none;
	b=U7zx6c7ebhttqUWmn9CjfgmaQBemvhI5rjF1jr3c1Si+gnXvA0bAR2xOpRK+GNijhRbuCY
	WGb3ejxbvpvXvT/l3Ycwzcz1rquKl05pJYoKZDbsUdiW9bNv2TFGuOeJ2f3Jn1WoePuv32
	d4EK8JuJbnlrgOwhfblx0YIOiPiVzZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF18D601DF;
	Sun, 24 Aug 2025 13:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE528C4CEEB;
	Sun, 24 Aug 2025 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756041510;
	bh=8rEG/zHMY62H8SoQpOWtKL4gYJh1rEaAZlfNMZf3TkM=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=XkDBN/xE9oWPNlcrCWXL07yKd/x9NSSWASauXwWDSzb4WTZdnAB57Vh6B85+jYtoo
	 JYVC7SG8PU8+GArm0KxVBQxtz4j1eevX38ETGcrwqK3W//JnpSDfKHwXtSP5g4RFq3
	 mijJyUqdJ/Cpk4RUJgPzIeVnaETtDqZLbS7Yh7Z0L8FObw1XmVrQE1YswZ2P4768vS
	 W5OEMh7up/3lPEfDKQSSs6TcbWcpYnpzZ69e66itU2tFngXuT0Y9ECMx3J8c5yBjIk
	 GYqnAgTNiR+03W586JJBsd/22vPQvCShdLhpPOtrjdD9xDKBZMWb/mU/qZVPLzb++i
	 yVoj+iNRiK5sQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 24 Aug 2025 15:18:24 +0200
Message-Id: <DCAOREAIJOR9.2N5JW0SC9YT93@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH] rust: alloc: add missing trait item MIN_ALIGN to
 Cmalloc
Cc: <lorenzo.stoakes@oracle.com>, <vbabka@suse.cz>,
 <Liam.Howlett@oracle.com>, <urezki@gmail.com>, <ojeda@kernel.org>,
 <alex.gaynor@gmail.com>, <boqun.feng@gmail.com>, <gary@garyguo.net>,
 <bjorn3_gh@protonmail.com>, <lossin@kernel.org>, <a.hindborg@kernel.org>,
 <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>, "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
To: "Alice Ryhl" <aliceryhl@google.com>
References: <20250824120656.208978-1-dakr@kernel.org>
 <CAH5fLgjkqcyzoZD7PP2i4g4r2uqpdbDKVW5hLfm6c9ysbxkPuw@mail.gmail.com>
 <DCAOH44U57K3.2CVDYWF8MJBWL@kernel.org>
In-Reply-To: <DCAOH44U57K3.2CVDYWF8MJBWL@kernel.org>
X-Stat-Signature: i53nyx13kbm1xx8nq8yjbbzxtt4xya11
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B158140009
X-Rspamd-Server: rspam05
X-HE-Tag: 1756041511-440099
X-HE-Meta: U2FsdGVkX18xrKDg+hBeRnqBYSyMKsvOwQ0zvgPU+Pl6NUQqCuMVEggNBttJYC6bVS1hXOq+SU0NDOaUF4z4y7FFx+TiGZxxkCIaOf0IqdUhYynDWmkxoAZrlivoRFvaug6qERK+IDWPMV0mAxmQupNvRcvqeLzs5W4tcBBKju5wCDjV7Ymn8ieEj94kRXGjJjVIl62jrSg1pYrSn4xtM0HPz7o8Chik9QS5cWj9UFKxj3AH0nMp66BNakXjcvInPQVvbxRzhygd8YUks3EUvmOlzXEMdGhUBQme/P5+vF4LCS/qQdkcgW18UOrxkbssFPEoDu3Er9jVTo+GioFaZ1h79gMLK65Xx/AjqKS9T4vnoeqGBcougBz2yR8ImCRtRKcSfLf2LpaRdu8VAz3aPJq3RW2++qLXoiFO36sP3kE4mPXXbTdrdOOKjRgs+kA2y7R3Z9sXgKSb2TckG57klMqgGRedSDfI+JnvIA/lDPFwD9yn8n4S005X0uhm1Nznh1nguRgN+DLO9Qji7YZxWjGh+ztKPrcs+OLAa+RhFJ4EJMNBxNUjEk/lwwIrIqxQnL6Oywo9KFziZ5RIOYrTsEXmTSuYdSbNtBHCVw4GOpG7273D67UMyP6CYosQ/xhcOTfBU8wIZMc+t8W5uuDSyxaw2Jy/Z0oWXSVIMfPTEKER2/A9rR5iOODgqQDdEl2esHu9rxflgeXS4trCMkszHQzTwaA61L9wX1q+X8uzDT1nP8JZwST0B9AKUKUVRqEAYiu+hK8hhcAc/M7R+23EdG+l5Irj0KH8hGy1fMgX6uOZH3BSEotXWGhyyNZ5iDnUycR76K5wpeyoCBuxfUkQ3Y8w0rGZKuNZmd5gQAt4AH4/GlPWRTXJWr9h0E5ptWitYP1x6ODZNjyAe+abbdK6Oy3ccus31kgz0oBbfK3fJsR93Mo7JEEM3T+7U0u5vgDX6t8ZjZDfU6ErP8tHGlk
 jmMMDG36
 rEFHEEX2m8BwJi8hei6Xim/wpPOiGoqYM4OyrK3ShOsn+zZ5n9bJhsxIsVTtusRFMQwUJjgpdDzEKV2TIV2Ggq0bENLvZRtfAXNtXXqBSyUxnXMhT+ewmarY3ZIKrIH2a+mHpXmlAhM4KZHDWVQspahv4HPxAmhJfUBfnF/bfA9wSo1hRVm3+3d8/lO5c5pqMTkOuljCSopghxva+Jlg0Y23xp6apfmsB30SOvAXOEu2lQMTRRcyZbJ2V8sUew3wTyKteH2o0TwjhP90Z51yBUsE9MGupng8dz5lNgLvcwDQ0ONXPRyEAtVlggfe4t0/jHen2gXnL2Sq9hwOWmpd1orK2vqOaiJiifIFSFe53TvHE30jyygBj4jzvKD7H/Vl9OHsNG6xMdTnnfwOjnZqrs0Hm3FuZ4PC/YATppVHEayvnk7w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 24, 2025 at 3:04 PM CEST, Danilo Krummrich wrote:
> On Sun Aug 24, 2025 at 2:36 PM CEST, Alice Ryhl wrote:
>> On Sun, Aug 24, 2025 at 2:07=E2=80=AFPM Danilo Krummrich <dakr@kernel.or=
g> wrote:
>>> +    const MIN_ALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIGN;
>>
>> Is this the right value for normal malloc?
>
> Heh! ARCH_KMALLOC_MINALIGN should be correct, because the Cmalloc impleme=
ntation
> should (ideally) enforce a minimum alignment of ARCH_KMALLOC_MINALIGN for
> compatibility reasons.
>
> However, double checking the existing code, it doesn't. Hence, the correc=
t value
> must either be
>
> 	const MIN_ALIGN: usize =3D align_of::<crate::ffi::c_ulonglong>();
>
> instead. Or, we have to actually enforce ARCH_KMALLOC_MINALIGN.
>
> Given that this fix is only for within the -rc cycles, i.e. we will remov=
e
> allocator_test.rs before the MIN_ALIGN stuff ever hits an actual release,=
 just
> using align_of::<crate::ffi::c_ulonglong>() should be fine.

Just for completeness, allocator_test.rs is also broken for the assumption =
that
Vmalloc allocated memory is always PAGE_SIZE aligned.

Vmalloc::MIN_ALIGN, of course, does not report PAGE_SIZE in the case of
allocator_test.rs being in charge, but it's an assumption that people might
rightfully rely on in their (unsafe) code.

In the end, just another argument for getting rid of allocator_test.rs. :)

