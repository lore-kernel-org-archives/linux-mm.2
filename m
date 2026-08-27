Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A0CC5DF97
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 00:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFCC6B0088; Wed, 26 Aug 2026 20:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C76D6B008A; Wed, 26 Aug 2026 20:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAB16B008C; Wed, 26 Aug 2026 20:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C81896B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:56:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 411111601AB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:56:41 +0000 (UTC)
X-FDA: 85145234202.09.58A9672
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3AC3FA000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:56:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=jX7MyS9U;
	spf=pass (imf15.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787792199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LrLE8+rJtI76h8J7YNnJ/2iFK09dqNEr+r/n2j1rL0=;
	b=aA9ErocyNaOwXkShKCW+qliCsAvKkFBIVyXdsZGNXjGpd+jI8hBBu0S4QY21iU/KJeq6EG
	D9FgoURfssDf9NCrHUVbMIUPyrbaPXwnb9PgQTiY55wSFf1j4YI0cA4MFN+v6iTL+OZZsZ
	0IgUR0luMRfLCPley2FOJXvVbERJdDg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787792199;
	b=ZZkmHPa40uqrP9lVAfb6IxQjgAbTMlUiLcJGjd+mmDLYhrD6P6r28qNSGO6cyCZD3SK1fI
	A5lXluu2yi3DjP6h596DvXVTNy8gbT0Lqln/tEV2H/LKEunxW/ZbJGxVgZ6dxpF8GUVMCL
	cWFieNeBuvRKvPdPwklDjUppfbHZ+n4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=jX7MyS9U;
	spf=pass (imf15.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1787792151; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=IJg7DN2ynBoKLJxuLdPi/98gMDxeFQlNBrjpW7l0d4kvH29O2TkVwNnjuAUZaK1M1BfEjeVA969J0SbP1VAP22P8pSIpT7/YLuOqZgxCa+rTHRnV9mW8oi6fXmckROaQim+VZJ+n29Y5SAEeAeWiwDGOr97WTnHnFffrWJIWDRg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787792151; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+LrLE8+rJtI76h8J7YNnJ/2iFK09dqNEr+r/n2j1rL0=; 
	b=Vk6BWSwF0De1cG1FHIjoEsFM5KXFv/MVgKkfRwNhS0qqPxlPa619F2yvRyPVILUA8Eo+2trp7oYgHCdxWO5Da30X/rBQhqoyU2LlIkbBVtsayBciGpUzfak0yCclEwf2nIlGJ4VvVdmua4NgKI6MIWdpqHxY7r11hg70iDeoYDk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787792151;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=+LrLE8+rJtI76h8J7YNnJ/2iFK09dqNEr+r/n2j1rL0=;
	b=jX7MyS9UBkYiXyxmJjm2CtrFStlSKhzaq2fMYbOFFH3qx49LvYU/mWlHsmdYtAHO
	zsmWC/M6ZdCtPDIXZ09Y3rymqZY/nWmYsUhjsqxV6yE4DSXi72b9drHzSDmpmDJV8bj
	7z2dCfy0ql/D2KgOpltrebaN2ADQgA8oAbe8MRWk=
Received: by mx.zohomail.com with SMTPS id 178779214921797.4098834851884;
	Wed, 26 Aug 2026 17:55:49 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v4 03/11] rust: xarray: add `XArrayState`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260604-xarray-entry-send-v4-3-965f6028790e@kernel.org>
Date: Wed, 26 Aug 2026 21:55:29 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tamir Duberstein <tamird@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>,
 Daniel Gomez <da.gomez@kernel.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <66630DA9-0546-4211-BF30-C99123B76E5B@collabora.com>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-3-965f6028790e@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3AC3FA000A
X-Stat-Signature: y86wybdxsi9us6iocujc4ejwpndg95n9
X-HE-Tag: 1787792199-303283
X-HE-Meta: U2FsdGVkX1/kAqyNgGfJjvmvRh2RzhwYZ0ZEHep9TRmh0r+DB7bNSTo08jAfttF3S0TLwwXZQcCC7Y9wFxgoas+Z99xul0jW6HOkKqi99m+sHHxeKfmydUD7FU39mrmb15CKUv2Beg+hI352qohlDj2Ml2ZbL/8wtsHa85zq89kLi0OpYAWt2U/mNxLj29C9sj36s1SgU8wDtxjVg/nZsjTvzyYrc5zd88i4IqUYSLvp6qPlbr8nZBKUq4qulr4zGDILxfEBQRfY5JM4cJozIGEPTMit0RALiZJ+72Gua3aitl3ULU3kL/TD3FvXAA9Mmkcqy2jQBfxlHtyngNv1Sje7ZHYxywaitNDT2pwg0GxoGr+XFaqmrfV+NJF4a9efajEOEK0MF5HBh/vB1tXNSTnaCo1ZI0eUH+GmlXPnVijgQakTIyI9ovt6oojFKrN0fc8ppHNQIiTOHQ2YICKNWUy9nDdyZH7byvzQfGpLsgMyrHPTWX1Gi6UH2d/m84OT20VPRvPGVwVCovp7KIHMNh9ggXw6S1LfvFNYXxkhXM/Gjd/9kEsCoa84f/UDZpl+syG83A3FlAkBpu9qI4CSy1Ibddvp2NBb/KcbKwWsV0qaVX4t5Fv4t5k/GHpErHzgGBCyS8zfGBjuO5X7Rr3cipgRmn294LoggEsgNQicvjXbtiwsczTvDOiiwrc1VSy1Wv92yDc4bg9Lq9or7mhzEbihMc+8ffjvHd09Sk0oSzrRZKriSF59BOMP2dKAi4o8o6h2wbxlHRrDwg/dzmvk2RGb18CsTXCTYXNLHqKunoggeCml4RfkqfGmoNBUaM/LxaUVP3NHmjk4p7KSXVG9wNTZVUywZ/yMUPFSICee9Jb2DfnrdeIuAVqlYEyViuCS1Aqd1EG3f8acX1IQUc5rGpuxT0rPYrCaxOQoR8yDuxwb6kW5v6T90JXQ3RrWElKbQnR3Wv8GR4NnoiAQGXQ
 jq5jUw3G
 avE1JjZS7q6S4qL2Ob0eMu3cbybMV9piAUvy/Ym/W4ql+J2y0LVNjozXhW64d3y6MZdqahC59ZxVK2Njyp4SP+No7TrMTUuLheDHeUucBFtSQ68UyLndkdfCRALdPZMtMUqt96Is54Y6tl74CM0LopVtHFxD5olBfLg5nUSIH5Tx3O1ALgVilsCMhoK7/9yMGzChtzsgECOZaSaEwa0nyb7TtIn+IJti3Rffx+R9pTiqOdayl6w7+0d2x4Yoo9/yViv083abqOmy/0oeM/xLIHPFaTU7E0u7G++h6aSJyiqy5KifEvHrn7UrKXo8cW3up2JuuKdNqcQ4eD0TC8pBxXBluf4Ahfacwc/+HWMgdsFA16twYHF6tq0ymBuETBEY8+x0Z/5Btd9M/q2VvLkT9lWmkWFX908puHXMrRkIDLFYCDucMZ5BZGn/+sTGt4Wf+huJ/A8wSa46GdeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andreas,

My main worry here is cursor invalidation, i.e.: what happens if someone
mutates the tree while we have live instances of XArrayState handed out =
via
patch 7? For example, what if someone writes =
"self.state.guard.remove(...)"
inside the kernel crate itself while some user code has an =
OccupiedEntry?

I think this could be solved by hiding XArrayState in its own module and
exposing only a small set of checked helpers while its fields remain =
private so
that we carefully vet against the situation above.

Additionally we have to ensure that, in order to get the guard, one must
destroy the XArrayState, for the same reason. This is currently the case =
with
into_guard() IIUC, but I think it's worth to spell it out in the =
invariant section.

=E2=80=94 Daniel=

