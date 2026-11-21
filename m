Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC428606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pv6YhcGt
Received: by kanga.kvack.org (Postfix)
	id F31656B00EF; Sat, 21 Nov 2026 09:17:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE29F6B05B0; Sat, 21 Nov 2026 09:17:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1B86B05B1; Sat, 21 Nov 2026 09:17:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8B436B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 09:17:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A8331C33FF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:17:40 +0000 (UTC)
X-FDA: 85459329480.10.5D7F098
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A482B4000F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:17:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pv6YhcGt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795270658;
	b=3ItTknU6TSxvZ+s5SmpIecq7NS0A1j3NQ+7NRR3zqYcXP7XNzMvBrNsNRE2E6sUIFTQ4CP
	+0M9vTp+xzsVcztpWxhQmGx8cu6ShAuh6FQgD/XEHvk9L1HrWTeds9lpM3LDbRrvSGdz8H
	rImMZXksOew3X9f5FNPIakvlYUBe4es=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795270658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFlfbs6Vr7PfYCSMBHpJ9X6tKrWXkYKKM8XUMpezu9Q=;
	b=dpvUArtqvsZa8r7kWJb9m/C0eusaEImviHFdbb1lGdb1u7CJIKstvj6lQSMMmO9KRMZO2T
	ayWw11WVWKcyobjm8ORKm7yqXktYQn7C8WUC/3gnG49domTtYnsUfAmo1DFAJY9iz09hlE
	8WKjpWOsZW9ZT7btWPfRJuQ6602cP5M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pv6YhcGt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 821B5417BA;
	Sat, 21 Nov 2026 14:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE35C1F000C6;
	Sat, 21 Nov 2026 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795270657;
	bh=sFlfbs6Vr7PfYCSMBHpJ9X6tKrWXkYKKM8XUMpezu9Q=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=Pv6YhcGtJpVO6kd28ZFcMwlrc8lsqKYza9hNXQKHFQ6N2rbBtcqDEoZGbPLhWVFNg
	 wIVnjyiJpVrC2NhF8tOLVohtKE615nlWNmmmiaFXzlBwImS0Qd7t+3WHOMgGFBvC3r
	 GzsUGVFPAj6Yn14fbr1zuN11Wl5mFzFh4mkvL3fWKZ3qf9eX64bcSgXMW5dC/T8VVW
	 +if4hvG3Yzx/NgkLADbX3NpF4QpUjUSCpnVMgNpw3N5rS9WChOHpiVGyQ7hfTKfHCN
	 PC51U3nPevE+XKEzkslP1KRGQkrmqBJSFOJGqKPtdiVpQQzcVMIRpDtTesm+55o66V
	 KA9zrGzh/IEEQ==
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 21 Nov 2026 15:17:31 +0100
Message-Id: <DN0YBZJNQVW4.2RY9NCR5T33HZ@kernel.org>
Subject: Re: [PATCH v6 08/12] rust: mm: add abstractions for allocating from
 a `sheaf`
Cc: "Tamir Duberstein" <tamird@kernel.org>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Alexandre Courbot"
 <acourbot@nvidia.com>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 "Matthew Wilcox" <willy@infradead.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Harry Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>
To: "Andreas Hindborg" <a.hindborg@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
 <20261120-xarray-entry-send-v6-8-1f69d7385f70@kernel.org>
In-Reply-To: <20261120-xarray-entry-send-v6-8-1f69d7385f70@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A482B4000F
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: fs5h7t41mj7wh7m56zk1zgbu71gwghzs
X-HE-Tag: 1795270658-393555
X-HE-Meta: U2FsdGVkX1+7ebWYrqxUK2+7Bi0eSejIYIai9bXm143V2zSliM+lqoVRXXNeE35PSX4M6UjJCLKweZ8L2dcbWgfzUE5gKQ0xk/9DYZTxb4s6fmDTFllIs22Pw/CdBp5IFXiKjqoByrAKwNJFwypH9KAK3THc0SfP6MrkdUDuB9M/MASFtmBn95NEJrxlWgbLUP9bRvtRPR1TWDJBLG0gR3rsMZCPtpYa7B2z5y8nz3ACf0hz8I3nTUaTYHuXjwngYtT9WPwwcK2PiI6PkC/yon7a/AJ0GzPMXaJHmhSAPGxtnlNfUCu+DaKte1S26Vvxzx3wRD4L6SS9lsiA3vatxmw3CjEdgIf/3v3VhD8JNFF6IdQ44llLSAbwVelhy8cEg7vdka55Ak6oFkzTB6w1Yt3dZw3Nv6B9owXZMzZE5Uo2d5zf0+ZlGfK9RZHXxlDwtZnMblEOc2fLbKeX6ghxF3no9jrNjlPAt027kawO5BCxQ7xpagjUyYsWtk54MN9S38BoZMxTxneV2b21rejvtE89R+QqFR8SFcyWe3EHGg1XdKXmFATijlj1FX4bB9lkVY+3dBQnIO9w7h3eeO5dJTcUmFnE+lYMcf0q7rgnVDJcyckaL/Lg35/4+f3JFc2OzQvHCBHJpoadj7wAuVxazJbKQXrEhI9vUp2qi9lMgPO7DABLhdF2U2sEXWGcx/QWbH5sVvuky3iTOzfiQkskTVTfIAfuvPa5u9ksiXPYjMgWsn8Idc/adTESYgJljvUE0stlSzhAvTQzK8VgpfajVXxXTnqZ2vtGO+QicVa1XsHU1l9aYj0H4iOLl2EkGbIwRRmwngpLj0APOB8UmOm/AXBGkNwnBq6ILWrdn+0pgdzEfJf11dm8TGn3uOfMhZ+6KGmQgXQtRN4ORQciaTYdreYSCfL70GPh8PQlM5k1XZzvEMcZIlKv+r7wHG3NOzyBaO3AiuULo0TvI02CFkO
 TV6SD949
 048VytQ0DZOTMJfqczLRh2E2qDT5wV5euRroONNLdbQLy33YG8SUj/GIKDpUvSRamzL4mhK127prMFGLI1KJ0B9w4iWdkQ5QX9T7nToHYg73ByuShvuGW7wc24Zka3Cs0bNXEZjsCUbid5LmgxBuf3iZUeUOV0NHkTUClbYjlF/HFTtQ/upbVNNrgrP+ls9VfZ3O87Rrfrl4TtXNkBI9iducVDhrJfK7QgCUNpx8HhCdgYXwkVvmSiwee9d/zFCDxZV76vc2nLhoAQK/Y4e3TfReS4L3O4lvQiEBHKdPUg2EwvIaiJJNFltH1bGu6XnM+nHSDDM2YpGBr6IIV9s9mzgyA1WaCxWyRMOtKQ55NQLRYsDbI9hzTRtjlTtYcP+lZLm3uWf+uaWG2i4X0s1i/yGx3qwj3DWNo5WBAQkW+9+vj7U0QIlkbVKrCa+B17xPv92pxiotZU48kYqZkxM73quhEDx9j8SfU8VtcNfCwr377DVqXlFgSeepnJBTKpC88oopl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 20, 2026 at 2:10 PM CET, Andreas Hindborg wrote:
> +/// An owned allocation from a cache sheaf.
> +///
> +/// `SBox` is similar to `Box` but is backed by a slab cache allocation =
obtained
> +/// through a [`Sheaf`]. It provides owned access to an initialized obje=
ct and
> +/// ensures the object is properly freed back to the cache when dropped.
> +///
> +/// The contained `T` is initialized when the `SBox` is returned from al=
loc and
> +/// dropped when the `SBox` is dropped.
> +///
> +/// An `SBox` holds a reference to the [`KMemCache`] it was allocated fr=
om.
> +/// Dropping the `SBox` may thus drop the last reference to the cache an=
d
> +/// destroy the cache, which may sleep. See the `# Context` section of
> +/// [`KMemCache`].
> +///
> +/// # Invariants
> +///
> +/// - `ptr` points to a valid, initialized object of type `T`.
> +/// - `cache` is the cache from which this object was allocated.
> +/// - The object remains valid for the lifetime of the `SBox`.
> +pub struct SBox<T: KMemCacheInit<T>> {
> +    ptr: NonNull<T>,
> +    cache: Arc<KMemCache<T>>,
> +}

I did only notice this patch just now, will take a closer look later on. Bu=
t
this all looks like it belongs into the alloc module.

Thanks,
Danilo

