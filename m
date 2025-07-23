Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A7FC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 01:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0894F6B0099; Tue, 22 Jul 2025 21:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F8B6B009C; Tue, 22 Jul 2025 21:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE356B009E; Tue, 22 Jul 2025 21:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCB556B0099
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 21:38:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 865FF112E2C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:38:43 +0000 (UTC)
X-FDA: 83693820126.30.59C0CA4
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F6D51A0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:38:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=fuKVzimE;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753234721; a=rsa-sha256;
	cv=pass;
	b=Kfevx0gXxTWMB9SFicf20SnFzEZP5I1/P0bMwh42YjXp7LrdG5nOjCdPGOVeH6/XIIiESN
	O9XEn8F4xktfaC8d1+he5AqliXZXa0EkS/dxftoc4o5D7x7RrpyJOror1nLUTyLBuiLlOn
	zwiiXfkzG+OdUXxQpaOtkBSWy6Vh+ZQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=fuKVzimE;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753234721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQtBD4u/2DWbddKH9xYLkSt3qDB8X4SffSwuW+eoKug=;
	b=XbKjQhLe6YjWJ3NdgVWSIp7rRk/4cWUKuKYbzA4RQJZK02/rYq1C1TPcbAZZszGIUM0cgg
	xiv5TLi6IyY5KUWn/eIQ4aBTOseS+bEs4l4dygYyOUwvoxcsGqf7YZWucK+jir5yZ1EKt6
	M59dhVpna4zHieT+KY/TaFJfKGCd/iU=
ARC-Seal: i=1; a=rsa-sha256; t=1753234699; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dcs/Bw9mxtzJgk7Y5Kk1J2gUOdVUAjSVAGOg/+Yf0e/9Wmj1g/i2y0Bv7E20emP4bZdIinpgEnbICecqExezPikJsckqYIGAcuruusYjhumH6+EdmYGaNdqY12sbkKnqw/asxSUb1VkP1Af9z4er+Jg7bN/7MMou4b2elaOrs1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753234699; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=kQtBD4u/2DWbddKH9xYLkSt3qDB8X4SffSwuW+eoKug=; 
	b=kxjK2/NvQmyPXolw9abSvXe34vFq06jWNRD4QWogwkG7HDLnNzVrzpCJCatp0jmotGc1jYSgXdeiCA0zhcCc1YkU59RvFZTQC9vRXEM2i8KCENO5ZSYwQq4zJkCmpffMCq8NRDHPP77fJi9bZXOt7Zca5Ydu9E4M9OTZPBImJuQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753234699;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=kQtBD4u/2DWbddKH9xYLkSt3qDB8X4SffSwuW+eoKug=;
	b=fuKVzimEnUAiXPzrss/iJfEzZBdyx7qDmgkTKcIIUKG3flg5hyeJGbjhMioC6FTZ
	MLJ9H6a/lhm/CcrgXhfQV7q2EIaKLoxs5H6dxAnRKwF7gAiRJBDtQTuZ8TGCI4rDxq5
	HaGXV4YqPWw/2MzmhP7bxBHTJcGpWMKM9846HjQo=
Received: by mx.zohomail.com with SMTPS id 1753234696386671.5480253480471;
	Tue, 22 Jul 2025 18:38:16 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v2 0/3] rust: xarray: add `insert` and `reserve`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
Date: Tue, 22 Jul 2025 22:38:00 -0300
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 Janne Grunau <j@jannau.net>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7C5ED010-C61D-4748-B399-C6D052170224@collabora.com>
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
To: Tamir Duberstein <tamird@gmail.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8F6D51A0005
X-Stat-Signature: rg856qingr7c91rd8hsw5nx85s6j8q1g
X-HE-Tag: 1753234721-761684
X-HE-Meta: U2FsdGVkX1//oPNVrkBdoH6U41i/YMEob0HD+UGJ+r/qLC2W+dWF9cYUdKNa8JwpCIF+ALRViTuhglhhAwNLqU2spV+PJzv83fFUYRAiis3mCi10aIie2XENWk72sNnLR6d/gAcBh0yvG7lklVf3TUBDcnFjfRo1iWjVUVMsTcguMTa5u+AiOieOTWKldBDa3wjKWR45gG6o1KiouxIjhUc6eKD6CqzAprAUJvBe38zzvyghxDoLm++I51LOawkTVxeKIcHBqgtIV1IXc/MWIR+0M71kMGGVccjI5ksW0XhF9hjGLk1fU7b/f+5STYLKx4ALWSRi8Pztr477dckakoAH5g4mVkkhcOtqBSKaBT6uddzaea6eYTdjNM8qGQVcAADNh1TJT4LULKQMBO9GuOiRZyRMa8idj6THoAl2NPNBcEw2qg97yc8kqlEnfx8A+ly3HnLr1eW/s0cZmsGiNQGIUu3If2HioCsjDJz1nw+Jswxi1XxPwahY135z/xduyd5lEG5VW3imkBTZPWjePrswdq5mjcZTKy5Ziihopreds8T1CR55ke/Wh5n/3FZANIZa+eNJ1RwxZ2pouhjgFOMJ5FCler2emzS2hASwQNexEg0TMB8V1ZMld8H97pb4YqkxlhtUnM99bdU0oAyzMhWQBanIhTdeTwfwPEJ9Dkvxz4IC2m1TjBowfGdFsuGcijkVfyEihYnHUgSvHRryU8zolZgctrADI775kzOKVY2sb7ox31LCc4eHDA2AO3CGbm+qz1a5LixjK6yRIEVGv9QJsYlHYb3t0U2HqxdzZRx4cWhmQlVEZRq+uZnqT+w2lHxl49Jd67xiGrS/vlS6WHHPu3eF3rYXAInOamCw4qz7dK5verfFTk4eLV0r84xwcxddRTyWL8kZbJlREW5n0pp+I+XXM+1aMsigDQHGmN2W5l24WlHnWXr1Qg4/1enBbPuIaJH1aqjbEwZU4b6
 xxDoJku8
 LGvi8koQBhX794xsGOKM16qG7PvnIjiTjtpWo+if7bZFkVLyaV3ypKOXdul1b9dMG3RPwkndsqZzagjOkpGFQgzj3WP6za03PRzoD830Glrhho/BfFngGMtn3ts770surnAI8NQsAGbR5iTK1IUFQvC9rxb09UtZzGLM7Chk1dAX6Yv6OEDUbXBkwniRaSDNu71om8hNM/NBWd1STNq+vUxcm1votfzkrCq7a7pHSoHtgJWZ0wMIGi3yRtS077cg4hkM2TqHpmkiXPH8UoBFSUVFSFzXIibcnHuGA+/JOs6lFzEAbh75IeGYnlaJI/Vy9PfjXBxNYCb1SRDNccZIIdpFCoTcreOzk88pqTnDh5aQZuwH6PJ8IqL+kig9/2bYN6Ux/lZReU/snZcA0Frzch1Q/F+pwsI72MRNkJHjlIkpm1v6oAEUULlhOJa2uonuj4+eHU0qptBOsaukaJgr7Im57vTAEsFsLn0EuKRKrsBDuGZRywC6SZVNNbT/7rfF2wqC67jiihxpdNvnSMoOVYypW+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tamir,


> On 13 Jul 2025, at 09:05, Tamir Duberstein <tamird@gmail.com> wrote:
>=20
> The reservation API is used by asahi; currently they use their own
> abstractions but intend to use these when available.
>=20
> Rust Binder intends to use the reservation API as well.
>=20
> Daniel Almeida mentions a use case for `insert_limit`, but didn't name
> it specifically.

Sorry, this fell out of my radar for a bit. Will have a look in the next =
couple of days.


=E2=80=94 Daniel=

