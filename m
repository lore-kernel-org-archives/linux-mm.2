Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBBCFC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60A26B00B5; Wed, 26 Aug 2026 05:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B112A6B00B8; Wed, 26 Aug 2026 05:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26BF6B00BC; Wed, 26 Aug 2026 05:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 728486B00B5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:29:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F23391C171C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:29:34 +0000 (UTC)
X-FDA: 85142897868.21.8D085CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E59D180009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:29:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMLbpbtV;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736573;
	b=V1Qak0lOfoMRZ2LjoprEvwAy9d6oPadtVS+r6g5PnfuHYvUfpbOh/CVpniIQieDKUtPRN8
	KcC6ReUsvrTAfhVHFaGSpT/F1b0MRUDNU8gIBiro0zGY6vdfAKsxT7pB1V/FfNmONPmDUR
	byfvFCKx6DPPL8irvXhiNkmKbrNHjII=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMLbpbtV;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vE0DFncUbEa7WUezDlJbcmjpQbbiEpMqeMkCvD7YDbU=;
	b=iR/sk26XezKnpmgjC/ybDlddVCQ1bgdA/U3xV/SirujB2iBMMUG8KbQ2QaaIMHr6v1xS6N
	csm52iwgyENvkSg/Ir1orO2chidHwM17oE2oTYRU/WEHDab9hSt6v+CqE/uFLf7W03Mcyw
	Nu5WScGPIa3+e7wdUneJMmYO6WEdY+w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B60740148;
	Wed, 26 Aug 2026 09:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9931F01561;
	Wed, 26 Aug 2026 09:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787736572;
	bh=vE0DFncUbEa7WUezDlJbcmjpQbbiEpMqeMkCvD7YDbU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=GMLbpbtV6XRD4w6KN91RH1oCiVx72uKzWQqLkbfx2kIDN9D9Eag0gzkEbhDAl0gWt
	 P1YCkvBlGTSdwRH3cp7KuiATo/uaSTYejkU3Vxpztm9iu3uFxILV1ojmRaKWYlikRY
	 Ggw4d12WTNh1bcjG7gDKhj2+I6mDhrKTue5CuHtVBbtjdSc5JxIGzd18mhpGbu9Yql
	 CcB/55rMLKstOxN38hkC+/m6VAXbVIPr7Ta8HzW2B+7BxGx5BXD678vW+tpQrbQfJh
	 g9tTDJTf0faFwf4/6U0eVGbrjKFJOeooMnCeoyi93Y+sF616btPc7GrV1O9Sww9y70
	 JGj0Mli2sglfQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>,
 Lyude Paul
 <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve
 =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, Todd Kjos
 <tkjos@android.com>, Christian
 Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Dave Ertman <david.m.ertman@intel.com>,
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar
 <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd
 <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Pavel Tikhomirov
 <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>,
 Ira Weiny <iweiny@kernel.org>, Philipp Stanner <phasta@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, Oliver Mangold
 <oliver.mangold@pm.me>
Subject: Re: [PATCH v20 6/8] rust: Add missing SAFETY documentation for
 `ARef` example
In-Reply-To: <CANiq72mPLrKQMzb37ow2969m5r3Z2Kh_4LHERUun6ALw3ea6tg@mail.gmail.com>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-6-490735672187@kernel.org>
 <CANiq72mPLrKQMzb37ow2969m5r3Z2Kh_4LHERUun6ALw3ea6tg@mail.gmail.com>
Date: Wed, 26 Aug 2026 11:29:08 +0200
Message-ID: <87y0dt1b8b.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E59D180009
X-Stat-Signature: mj35yeiz4sk3369nzztduktjh8k48n4m
X-HE-Tag: 1787736573-732884
X-HE-Meta: U2FsdGVkX19+TBS9uBkE3NyLCzDWQ/cxtVbf9AeV42yaXmUPgfu/fZ1ybuf+4+731FM2hy+78srQTPVPrreHVq9CJafxbWpUJe7frkGqTWUreS4BNl0Icw1L1Xmo9jskXXBgFTKfGGYlq/+hxtWtIeVJ09HENk6BVwXI/mSp85AdNrIPZwR76i5nJx0+xy7AwvmfD+hnJcTUsiEaAyjW0JrCwAHyfogNStWS7PA/HbfANfD6iPcg9dMCIvQRZik/YnqYl60W5JTYMIMJZoHoOecGx4KULYkJQbcbEriA6xqlfU4LbsYvKNy1LMWFitgVVe/3RSUhb2sQtd6Ngd9yyX2Tk+it0r7DEdljrKub+S5hvSGW20JW/00YBizXMQJM+/+5q6O1yYCRWfSYXRaX+YXp53q7pDd+9P17lN1w3KrGTOt25us/Rals8rW0E9srJRwvw2VqVwqkcC9AE6OvSAno9gMP0m2Hi3WYbynWrRf/kmx6uxvttftHO2yxsu9pY0cgViP6TQ+FySJg85f7LV19BGo8Ilg0awlzRmPKUr0ZySUSo8ILsh0qwoRUFxxl+ntcA325UyMl4ruUVkp6toWlqJA8aFlZ08k4rB+0eWPl281LAQxg4XbV6CwZ/Ypor9KcsbtX9Z3SA4JIQnKeYYY8Orm+sWgj0EqKz4Caj2q84Si+/OOEupkzhO9C5sp7UIo7yfnffAucf3NzfJTApoWuWWv1dDE5qmNBeIGzE8wZWPLI7jL36tqW1UDi8oarBVG2vKCoaBnmTY9xeHFQvhOzJ15vAn56dtPUKpv5uidpyycH+DymAOxPYR/wieozXV8kvh3A0AisGjDDQBEkTAiP16eQq2qWShI34J2qYXK9IzSO9KFUpv45/5gDPX8zyWa/cQdJCilHGUgX96EaxFZEAWU2RsKzwr3unBjj6wJlgYMfikKk47Al3owYvhs9Dxsrcc7IWoyoytk/Uzi
 mRtbFL00
 7sTeotmQVOW2N73RNBxufELOEqXJ6a3u7LNjLNxRVHcHyesqrTeLjg9GwPYC9cXIYRYpdHgAhQJa11gvnoexClSMtIcmHn4amyvuksjc77yOCtmVRPvimb9PbIbAbnayaAaXwNo0lxRHC7SKW+iuyi7LlQQJJ678Fiu0J2LdT2b21ADNmp8Of9mXijj4tfcrrjJqXrJ1Q8Dp+l2VkPn5dAlb4ErdkfGoSPjSwWVQP5kA0EIsaNhb+4stM0OvXM75TcR9anamyo4UuacibSvIt/a7IjI4vynU1GcESTx9J3DqJl27jY4782e/OiMxFm2SHTHqAVIDJrUUGtyfOZbl4MQSPo2e5A00zWBow5Q6kJLZEY569nRSL2lUQdM9lyC0fDDQKBew9uQWpG8sDvrHb5fXovZwHVMqTNto3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> writes:

> On Mon, Aug 24, 2026 at 1:19=E2=80=AFPM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> From: Oliver Mangold <oliver.mangold@pm.me>
>>
>> SAFETY comment in rustdoc example was just 'TODO'. Fixed.
>>
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> Please see/link https://github.com/Rust-for-Linux/linux/issues/351.

Do you want a link to this issue with a regular `Link:` tag?


Best regards,
Andreas Hindborg




