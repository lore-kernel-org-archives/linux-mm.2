Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 534ACC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509206B009E; Thu,  3 Sep 2026 09:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4936B6B009F; Thu,  3 Sep 2026 09:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B986B00A0; Thu,  3 Sep 2026 09:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 139226B009E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:13:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E9F21A0531
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:13:19 +0000 (UTC)
X-FDA: 85172492118.22.3425BB7
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3FFD140010
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:13:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=jWyuip5R;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf23.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788441197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJI6JQLsYv4HW0vAY5ug+uBCPvyVy4swuM+6iRXROac=;
	b=JZJop0ajpahc3Kbqa3b6Zn4E9emiViFbsFInR3Sq/3XRPcv8ed8YMAnGsAFG+CPrih5JEK
	8EhEY+I24ubMU+davo0rMQQ9amk1yRW/TUuWUBH8NYL1EKco5neRTtpTfMXrdGZbFGsk9N
	pzSGWswJRL6bnW3Fn6flGsuZl2ZR/mk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=jWyuip5R;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf23.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788441197;
	b=qzEvuslv7EpaPC19LP4qMGs11OhnU4eYBsWDWtlQeznqzMbcBvEaWJNBkF7vuNe0JV5qWo
	aabePIiy8XOf8m8+Ip1HhchTah2bRPGRb4fFdGBb/YhumDUHQEReHDtiQ54NwpYvr/JWKD
	97a91ldAkOMo5DacaKcTg760xXzfWT4=
ARC-Seal: i=1; a=rsa-sha256; t=1788441190; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=k7etm9LDlJZNiWzdK/AdPOIgZ8l9WeQ9tY+28rROGbZ9KIepmYpmVR/plJwsI44rZnKz0T9pXbaBmKYuzSx/RmBa3O05aB0V0CMr9zPz/kozZ+AqTxjxyTA3S1gzVdF3F7fl9DgCfFSKieJTC2kd0U8q29VC00o++CgtzNMZ10Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788441190; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=uJI6JQLsYv4HW0vAY5ug+uBCPvyVy4swuM+6iRXROac=; 
	b=FYhQvYaQfyJOPBpM3jQVMgEYyck06k5108qpCbpBXIdddmEfUC8feoKoKjQVQl08We+SE5ljVHkVViJe7L4s8JXqAw22el26Kj8oU6DF7seV5mv9GOmrgoKqWOTiraRj9khbHjpnGtIla9eGmJHOikyIST8XVuBFwu4WKq6R+PE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788441190;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=uJI6JQLsYv4HW0vAY5ug+uBCPvyVy4swuM+6iRXROac=;
	b=jWyuip5Rj1hTP5EM31wAvwmwxrq+E/qbzPiSS5nDZZLDbQN89z913aeHoOExPMhd
	A/R3hq042q0lRByXU+EA7uJnAW9xxf8cFZEuVYMX/6gKHO4xSQI/swNxrX1P6z/xWIs
	21mI+cgG3gAhZwSCkblVIX4aVniKwtTGHVijLwbQ=
Received: by mx.zohomail.com with SMTPS id 1788441188698154.96329628710419;
	Thu, 3 Sep 2026 06:13:08 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 3/9] rust: sync: arc: relax `ForeignOwnable` for `Arc<T>`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-3-e0fdbf8bd108@kylinos.cn>
Date: Thu, 3 Sep 2026 10:12:49 -0300
Cc: rust-for-linux@vger.kernel.org,
 Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <012145F0-65B6-4017-8EE8-0D94E428BBF0@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-3-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9p36kqp3n8jazcm96y3mqf76rfdsocbm
X-Rspamd-Queue-Id: A3FFD140010
X-HE-Tag: 1788441197-644818
X-HE-Meta: U2FsdGVkX1/xyKqw+VQp40CXgMX8iGfCa4Prcsoad6DTXUYBm+hU6p8Xgl+rLt0L4jeMYypHg+Md8bH7YeC9QWoJt+Qe+s+mek6lSkHSMPeNN5evCYU8Pb/ua2Ipy14sCq8h909NcIOrDXWsBNpEhhqMTxRgl8bfke/P6V4xUfXsGN7RbZRzG1InDeztThLijBu9ECEL7JEY3f5cp+UINrXCZovYbkWLco7aOmB0TDM5tpLUKa6KdyEFOEoZ72muK5gtbF6GwP7WyzMSGXeJgu0HfZNlCygTxZbp5ymMvnoUXNmX4nXRrC1yA692fJN9RJT0+drfV2In8D9IcSLVY/m8dDqS9FzenXDGcOkAz/3RRgzH887aI5+wBYeTxRLyOeQcAofXGFYJ/muX7APM7FFaI4JmNldC7wmi6c0eOAqhxUthz99xcU+6asDQiLYYSQOCJg823QzmZNwzq5niA8Tj58W8EbAsbWrinowg8HVUzuHrTsD8JvV5iIpSxBJf5R+VGr6Ccug1Vj/PWxdzMmmvIHQW5MiMlNojad+kBmfMYS5T9TjuRKN+msHD9h+mGsTYCoAQN6ESAF852C6Qlj993qK9ELMQXYrXvNVnoJO5cRFkJeeMGHovHey57Butu+oc8jJB43rIHNtVTra7SFvhslvxMsyId9d0clNJmZyLAwFwo2qkinXMs4RWJw2bvySIKHmNg7/w6rZrKdctPx1M6NF5mypq6cwgndRA6CxSR+r+VwxGZ3gRYbUYao3N1P3iZhh3OA203O7DaPWmhD8MjK2ZHGMpZ0VZqdSh3dyqntJ6OHli+ZatxeGWjwK3SHwOFeyoK7ARNQ7ArFgmqfkl2aOvjnfokHCNkvXr2Kf8RBWSYVKdobr9lRIRXapf2RLUrgrFMbUgHeoCFqlUIS7ZIUmkJnxdNfwtQz/NsgM70ZQz0kBjeoIzrPvMMDUkwFx4W/69zqc5aN4O3ky
 DUOw9/Af
 E94jVcXrN0zYknJ09mf5Fs9TVeh+EpISi9ICZjxKuBXC+Uz8nDIiZilKZAzujmFvmtd0Wmzha7V7RLL4M8Z9ntAtOHvaN8dNcZkRS47txFqsR2iy5iUEVu58UMVIHdQiEG4wkN1gAqjv7ABQky6DUCxE1cBdttXA/dREB1UF3LoNxBcizXzuiEgci0rDcEYGGSOH+9rFBTNE6tngR0rU7tlx0rgenMlc6iU30FaGYzwoLFU9aD3PUy6JF5UNBP1ncTx4JzuD0aYvvmQOFwl9UwGHRc76XZYbH6Dm8fWbHG0eONnHhUoyVj8Hn0TTztv0I0ScxDl5E0+tjMew+FNqiXiisRHNAWqBZ56pp8N1dxEV1F/lY5aI3df5bA1uRaoJs0RTqNjq41XrMyUXpjdVnZTydNuV7GVVclE7GimbZU7fMGAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 1 Sep 2026, at 13:09, Ke Sun via B4 Relay =
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>=20
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> Drop the `'static` bound so that refcounted values borrowing from a
> driver registration scope can be foreign-owned by the XArray
> abstraction.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> rust/kernel/sync/arc.rs | 12 +++++++++---
> 1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index 5ac4961b7cd20..cd6faba84ffcb 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -363,11 +363,17 @@ pub fn into_unique_or_drop(this: Self) -> =
Option<Pin<UniqueArc<T>>> {
>=20
> // SAFETY: The pointer returned by `into_foreign` was originally =
allocated as an
> // `KBox<ArcInner<T>>`, so that type is what determines the alignment.
> -unsafe impl<T: 'static> ForeignOwnable for Arc<T> {
> +unsafe impl<T> ForeignOwnable for Arc<T> {
>     const FOREIGN_ALIGN: usize =3D <KBox<ArcInner<T>> as =
ForeignOwnable>::FOREIGN_ALIGN;
>=20
> -    type Borrowed<'a> =3D ArcBorrow<'a, T>;
> -    type BorrowedMut<'a> =3D Self::Borrowed<'a>;
> +    type Borrowed<'a>
> +        =3D ArcBorrow<'a, T>
> +    where
> +        T: 'a;
> +    type BorrowedMut<'a>
> +        =3D Self::Borrowed<'a>
> +    where
> +        T: 'a;
>=20
>     fn into_foreign(self) -> *mut c_void {
>         ManuallyDrop::new(self).ptr.as_ptr().cast()
>=20
> --=20
> 2.43.0
>=20
>=20

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>


