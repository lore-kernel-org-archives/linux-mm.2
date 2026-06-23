Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D85CCDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72D56B0093; Tue, 23 Jun 2026 09:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23456B0095; Tue, 23 Jun 2026 09:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39756B0096; Tue, 23 Jun 2026 09:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A45CF6B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:13:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9837167135
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:13:09 +0000 (UTC)
X-FDA: 84911218098.09.D233114
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D63720005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:13:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OjCnwgpr;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782220388;
	b=4A0MPMI11Sdu0MAd98xJq14HPg6xxlfba5T7t44NYJcJwBF1bKVolHJE3OlLkVeoQsxDu1
	IJLeSgMhAwWjoPwjbLXLam8VYM9O5Y+c3qnAU/QpWtPuzdIDKz/UN7t78IIMdYMW7Fquxl
	oGp4NjlJ6WoMGFAnp1cUxSd67BeVOwA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782220388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcLfDsGf5XPj73nZRA08ZmnCvcH4OilI07UFYaMsrX0=;
	b=jdLA/IlDbol5xDqVmMq5qoSp97D8eV/BZgHI585HP4JpTCOM3Ow9OCmkUr4V231Hjc7HQt
	v0mV0g/oXr37gcRRcv1TE2qdxar73Q0J2byBzFSF565DpetvENNGqVsjgi0bXpXUrpls4Q
	qt6/BesxgdhNhz608E98cqN49NKZBT8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OjCnwgpr;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D209F601F5;
	Tue, 23 Jun 2026 13:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46C41F00A3D;
	Tue, 23 Jun 2026 13:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782220387;
	bh=qcLfDsGf5XPj73nZRA08ZmnCvcH4OilI07UFYaMsrX0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OjCnwgprBvqVQyzGVVvo6XJUzznS8AnpuvLHrOCQFqN1QVYAEwE/GNzUwv15vVox0
	 RV7qTbnR9HY6Bg1g4XuP+B/sca6oV8MerRA5MOYnkIW7AlhNI/BFy/pEHGefWsXHVC
	 0QPKUgRxjZskNeLVc1ExAFytUesI1m7OuDn8caryOkjGWcnibEErL8YN0/dEn8DNQb
	 I8DV/2fAeAHWsxW5kh76Uvlj8KrzcccHNBBGocme+XQOgne01TRAVsB1vaR45JAdZ8
	 OzDlBA5wSSflDSl0fC3Sw0rbs2ZcKlIxufpPcm8cBKVDKZgrJkVaBExwebq3v40D6G
	 RMmb3OgkINwtw==
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
 Jan Kara <jack@suse.cz>, Daniel Almeida <daniel.almeida@collabora.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun Feng
 <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Igor Korotin <igor.korotin@linux.dev>, Pavel
 Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 driver-core@lists.linux.dev, Asahi Lina <lina+kernel@asahilina.net>
Subject: Re: [PATCH v17 05/10] rust: page: convert to `Ownable`
In-Reply-To: <CAH5fLgggdf0CM0o4Oa1VbY+y8gQxrU0VU5z_yB4GWCxnbqsFuQ@mail.gmail.com>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
 <20260604-unique-ref-v17-5-7b4c3d2930b9@kernel.org>
 <CAH5fLgggdf0CM0o4Oa1VbY+y8gQxrU0VU5z_yB4GWCxnbqsFuQ@mail.gmail.com>
Date: Tue, 23 Jun 2026 15:11:33 +0200
Message-ID: <87bjd1pfju.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: orrucxq5rjpp7ei3hdje45zciijc56ta
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D63720005
X-HE-Tag: 1782220388-704871
X-HE-Meta: U2FsdGVkX19yO27ppJtZTgflptetINxIddaARMXBtltCH6hQavQjf/PGBIMA82q/RwJ5xRmUhoIJ4wISLZFPVoIx73TWQiM/ohNPw7p9KJaZPC8GHVNlddHZvlelUOGbLy+61HunBM9BngfaFrJzLpjowckXqmeLwYWt+PNOUN8W+1G7yWlf3hfL/5WQ81E2ZwolhC/rmh2y+GzuOBiYCorRwS8JEhjHysxH25VIztScjP9vEIsU1v5xDC4E0liORAgptvbEmkqxFJfQy1ciLq10sgKKY99rXqWagK/R8Rge0R9D/RBFT35L9Kqzo8Vuh4bGONtUaX78laMD2gbIXnk5zUuAN4BO/f8F3SJgE2I0EqdA1escYhffIua49SnACG8M5NcVH1Vn50f+jb8pW845aGXXY7+l3G7kVqQfNK/jbm2TUz6GMenlcwDRWKFkIXcO2l4Cb55t//bk01oJKWOzPE19couR4XuBTond8DPCV3UpQkydJX2xH5ZSorTIdWLJYi7S/mqg6U2iDNch5fPqubSWkFnFv6zE1drq/H2C+b3OZusRWrEzIFDwzm4uVWZ1ePMJc1ZTSGxiGEasLLHHcrwl8Myx6G/Q3nY2YTy4kUQ/OhN4FS4iUKzYNp4tgTJWnDnJ3p9zEysTk6qwKXKnAyK/c2R1/uhxhc7VkAJVfClOdViZpMI+guNeWnpb4yFsGRItDZR58r3AnhvPC2iV/nsEi9rArbrzq4x4s+mCxNRRo6Fb76hOjV/ErYIGzrDZLyTpZHTQMOS4MdGPYRUPmWwXNHfCxr0LDLjN6P0+GIL8cvSmd6IhEi0MknJzjfTxjV/IGBqBIuEGmbuOYh7VTdpJz/jm5I9c+9zBOOlu1PH0mc8BFdgxpDLSakc9S+DbDwUF9QDqP3aR3e6FnHVJ2OuWQCwmE/MGhh7TUk0P1zNV+ewETDUafjKkfBZ4VcMRNfst4u5aqQ9rDZC
 idcFIEPN
 VAcbb+eJL6q3WauO0U8O+tEhdFntgTwlrjMmuW2PAgtS8QWchj0o9mNE4jpCXfjEB89t6IpNlu1cppkY/H9RuwJDnMLzVWo4e96WZhC7DcF/kZtU0RmrdanyIy5iWZM8WVBpdpgGtS8h0mZUjloZkR3BD5T0odT/yNzDHo9/g9WcLmD+bIk3heWCQwqWgK15pbTNWbozUhX7QAeYAdK6b/lh1RLr/OPuSQ5iSZ84JGG+L4Bqc77Y/QSk2enRlwL6m/oKNz5tnGfTLroopn6MGtjrQ+GoAE3YrcY4BZv4PAn3GnE1fPflmRBCOoMKUR0kTSRbPnAXltgIh3Bm+UelxoDG7vf0rnUuhhBpWyk4+Gf/z3J5KMj7etYi8Vr4cW5IvydZNyBy0oUmkeICqDSAJLFbkFTMZEur3623Q+O2BH386ke/iGy2xVP3FpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Thu, Jun 4, 2026 at 10:14=E2=80=AFPM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> From: Asahi Lina <lina@asahilina.net>
>>
>> This allows Page references to be returned as borrowed references,
>> without necessarily owning the struct page.
>>
>> Signed-off-by: Asahi Lina <lina@asahilina.net>
>> [ Andreas: Fix formatting and add a safety comment. ]
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> This will not compile unless Rust Binder is also updated.

I'll be sure to build test against binder.


Best regards,
Andreas Hindborg




