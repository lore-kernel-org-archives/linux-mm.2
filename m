Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C860DCD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DCF6B0005; Wed, 17 Jun 2026 07:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720DD6B0088; Wed, 17 Jun 2026 07:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E526B008A; Wed, 17 Jun 2026 07:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 375D16B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:36:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BACA41C1EDD
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:36:36 +0000 (UTC)
X-FDA: 84889201992.20.C09D6E8
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id F0B1B4000C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:36:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I2mRKKGR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3wIYyagkKCO8RcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3wIYyagkKCO8RcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781696195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYicJoYFI4w4qF8sCnn+jRXzXN1/GRmTZzaGc7Ox2u4=;
	b=eMG8I4cgkT+G1xs3cpmX2CZd9Yf2mZ6b59mFh+ehppzQtA4r2JLC8SGfP6nG71M0/NSbhS
	ltjUqMFQmSGPTiLJ9OyWpgRpNKLwn7sdIaqFi2kgcoaL+JupcPoluDMnGrVwYHkJVvl9XB
	EkNOO5qHtJ9k+Ajo0uVy6icpemOBRk0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I2mRKKGR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3wIYyagkKCO8RcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3wIYyagkKCO8RcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781696195;
	b=tb5fmA+48pwSVrkXKeS9EcnzrG6T94JTGU1J0/R1JM7iwJtrjLTzBhGx+/aj1DbznlpTBV
	B3Q16T/r2XyzEi1iy4Jetym/IMXv2xFG2/O8XJ4SgmwyBqmhU2SFGCKABo4W2rjoaQ8JNE
	kdzceHo/4HhHNaCRvvNMyvbZPAPThTA=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-69555d2711cso760049a12.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781696193; x=1782300993; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UYicJoYFI4w4qF8sCnn+jRXzXN1/GRmTZzaGc7Ox2u4=;
        b=I2mRKKGRDr+w46qXnQodwRT9C51vten64ua1cEbpZiI5EHrM5dkf9mGW85BCJ6fzrF
         fyVqFhBhulLS4uQq+BgS9zLE5P5RZBLhUSYTLt2b4PZuWWzt/TzYl2NS6qWn0LvcyjGr
         ME20j55MSuX6WOqVXHgv1K39mOLDyL38yJC2dd0+MYdfWCVcfyY1xmzRj3er2he1kVEf
         kiiwbKgoeCDB2FPJSI+wd21LYWGFDGIRiW58Nedi1p7XuUATvS2wlXb6yoLNLRQJjVZC
         DPB8aMxQXDthUJTzE3pqius61Vlf/7g9TQgP6ndUoRqyMs+xtZyh19YGe4xbJuyYKxkF
         BdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781696193; x=1782300993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UYicJoYFI4w4qF8sCnn+jRXzXN1/GRmTZzaGc7Ox2u4=;
        b=b5BcMYNLvqK32sJ5rp93QfWKcLuDvbE10aCKgnXIan6yHXgDEopnvyaMi+iHdoVWQ8
         xJd9w9OvBq7mq149sbfsMQ8y94Qh1lk0yqfZ+L45m0EehOdtL5x7GVifbFWTYE0wMu1g
         pEKnMLleYYocQdX8GPc6wrZTL3FqMx1odu4RTM6RscBGf58qe803cLOHiqrZpJPiiJxg
         clCkQsZfM1Q61rsNUHS9wsdYK75d4ABOxUP9+dIQxb5zLP3rDfj5C/x1NQm0+Agh3sK0
         IuPwjJPWVgLR+wQCz+ugfdLOppnC0AQ+63GtKAxzh9Q5zvpykxCXFilCQytx8ZijUgku
         RW1A==
X-Forwarded-Encrypted: i=1; AFNElJ+TPn55y8KbtM0spfQYW5qTyRjYrnCIM+jpf3LE3uEKsaKPCzTCRFv0huKqceluWHgRh4BpwDOIDA==@kvack.org
X-Gm-Message-State: AOJu0YzM7C6oRw3k4IPwwkWGsjJcWeqt6SLpgRPNon9EpQnIL+TMU8uK
	xd1z+ASGKac3L8gCB4/X/lmpcm2CaFTKoIWxj6s8s9Tx4JGlBspqxVzbyaPRF6Y9ozLdBTzPMmn
	faHJzRPOW/UTCptbrBg==
X-Received: from edea23.prod.google.com ([2002:a05:6402:a197:b0:695:72e1:a5a0])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a50:cbc1:0:b0:68f:9fd9:435a with SMTP id 4fb4d7f45d1cf-69554cac360mr960260a12.17.1781696192851;
 Wed, 17 Jun 2026 04:36:32 -0700 (PDT)
Date: Wed, 17 Jun 2026 11:36:31 +0000
In-Reply-To: <20260604-unique-ref-v17-5-7b4c3d2930b9@kernel.org>
Mime-Version: 1.0
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org> <20260604-unique-ref-v17-5-7b4c3d2930b9@kernel.org>
Message-ID: <ajKGv5ioLSassmND@google.com>
Subject: Re: [PATCH v17 05/10] rust: page: convert to `Ownable`
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Viresh Kumar <vireshk@kernel.org>, 
	Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	"Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=" <kwilczynski@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Igor Korotin <igor.korotin@linux.dev>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org, driver-core@lists.linux.dev, 
	Asahi Lina <lina+kernel@asahilina.net>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F0B1B4000C
X-Stat-Signature: mdy1ncous46779xx3cb66fmrc6w6bpm1
X-HE-Tag: 1781696194-184091
X-HE-Meta: U2FsdGVkX1/DAlPi89pkBpblhsYb4c8fh6/+J99qPzV7tq9XDGEHCN1Ry+jq1GUKR9wrNjVvlelZ5nVW1orcfwqEfZTeh289Rt7RXmyK0F31wL3tm4OFBp0TByUjK4CGAr37k/aGXt/3F5EPaCp9w0Kv7p60UC0uCPYZp2FW2J8CZBnCyjNhiMNOrm5Wex1/QiPqslc0ryoFUpu8kkL0DY8JTzMYDwd0QFH8cL287EgPeRWjq/yKKytbKIE56n9TC7BbGWmlWh+GF8pvUG6CSLpTFBA4TzvN9URLP7BuROEAmubj9EMGIfjDvB4MwGbmAIC43pxJH5jugC4TpD/2BkjQ+W/USouiVBFuLWL0XkuYTUt2KpoNqsu99d9PoaukfzbhRc2kntRj6MP7svk654o1sCDtPUKXSN4Jzi//D+Bd5OG2Vu5dtS/SaLLALm1iD+w6w4zkt5yZ02WJXiRvUm0ulLOBjpD7GEM6t9NIaN1D+zDhtWzadfzH7Y7z0OsI8NYlI7x8G0ps2L4kSdFGks+r2KiJjBQdXhMg5m3ycBXI3batDGZ+0pcAFYy8syzLjDtryXXgLrwHqPLUEzWJJwwWkYRqto3XiwSgU4IcHeR+xifSpyy175KWvHKOf8549qbtE3kgLnK24EN+8DPE0zal6maBNQ9cd3KSz7P3NsCAq0VupAp4LqRIL897+iLR+wsHqGRVNfhwMf8PVBm9b8YniSE7fJE+7WzVF7l2PEGN1qZ5qpVLEgW5ZiTED2pcIwa1aiNXojUMFA6MNLHd4z+QQzgtmLQti9FjrXzEBh/+ml5bhYV6gq0jrlrRECP8JcIiaq7/pK5vT8oWuOE8I81cWiQQzTES4UA0ZezxdGqWlwoiJKWBrA7noPKFJSfQ0ASGD/MreCrHFFQJ3Ewo4pHq+s3oehOhgI6eOQtwN3F6Fd7h35kM+U/L00do7KRniHnXHBVXkQmY8yBSHwn
 qJfDCsHv
 gUOXQP2kBHFfVHFACr8osPVt3b/ex7W4nSMLVWYUw6l3JhLdXDwlyhUvRTNIpG1QiDf6zCN+ltVVLd8FUlQoYnbqoNQ3RrRnbVsJCW8DN8ofbWf8R5AHK5fbwBHYVPBTcKhAXErlGG3iTvXoqQbU+a5G1IkOI1zwwKSwLHv6eIBQGuSZsf0830pfUuFxaKisHVpxyuO27+r9VihRX9/1iGLhIwf54DhxHZiJ27v26FS9IBpQ56hG4R1+S2RMpMkX1pfeAaNvuAgQngfkIAuvAn0Xw7ESiTlxYvfmF4ZFgF1ZeOYW+HURemLxjZErXg3oz4RqrawWAf4PYQnKQZIArAhwh0hiiVsAFJi0aZAhEeiJeybs2zW5plbYTzP5riYhUzflgou4Kdt1MKXl4/r8Vv4GDyOqZ+MN+crjlAgK2LDmqbQCgugjhkKa1T+Qly1pvD5DZwDHojXR4l90OOgmugWjarcwHyqbWhiJsaB3WslGmunubtR6Z7OnE18ZqDd4xXdf2tS4Tja1p2rymdN5ZBhss8Nmj0NpfBAt7Pl8T27j7SltoErRUurYNZh2mJJ3RHAiebIf4CN5NHpGm+ruXH4mBMEu/+LunKrjJ8lBuel3ltGcUF6xA09x/3mvrpZCJeicLjbHUBqt0/qAxVKc1PPHNzO+l4UXgOcycvJBxVIulCGeghxXMFu2WbgrMwykM1FfsaPvpR0FYRt36y9VqoLsun6XYv42rrtOYaslckowwezWzRNAdWkepnXD6yiAZdgTUvFid6na2CYFY/eQyzGN6TuDxmH5nVLG5U3mXoGkwZGj29E1G0UJ0pNePqQuAjhNmXYjQpMaV+R2qBWHJ/xUS9ejTNuSTrGwYmi+oeaK55mHs8l89PVvSrwopiTUujeULvQOCiBqd9Yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 10:11:17PM +0200, Andreas Hindborg wrote:
> From: Asahi Lina <lina@asahilina.net>
> 
> This allows Page references to be returned as borrowed references,
> without necessarily owning the struct page.
> 
> Signed-off-by: Asahi Lina <lina@asahilina.net>
> [ Andreas: Fix formatting and add a safety comment. ]
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/page.rs | 38 +++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 3bdcee0e16a8..844c75e54134 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
> @@ -10,6 +10,11 @@
>      bindings,
>      error::code::*,
>      error::Result,
> +    types::{
> +        Opaque,
> +        Ownable,
> +        Owned, //
> +    },
>      uaccess::UserSliceReader, //
>  };
>  use core::{
> @@ -105,7 +110,7 @@ pub const fn page_align(addr: usize) -> Option<usize> {
>  ///
>  /// [`VBox`]: kernel::alloc::VBox
>  /// [`Vmalloc`]: kernel::alloc::allocator::Vmalloc
> -pub struct BorrowedPage<'a>(ManuallyDrop<Page>, PhantomData<&'a Page>);
> +pub struct BorrowedPage<'a>(ManuallyDrop<NonNull<Page>>, PhantomData<&'a Page>);

BorrowedPage<'a> is no longer needed because it's just &Page.

Alice

