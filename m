Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC00CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F6B6B008A; Tue, 12 May 2026 04:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F00C6B008C; Tue, 12 May 2026 04:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEFD6B0092; Tue, 12 May 2026 04:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5046B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:56:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41DA9A03FA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:56:07 +0000 (UTC)
X-FDA: 84758160774.07.55AE88B
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F278100008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:56:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E61EoeHS;
	spf=pass (imf14.hostedemail.com: domain of 3I-sCagkKCFw4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3I-sCagkKCFw4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKt1aQHWlToSTBHmH9DUCE51K0B4uRuyfHpEOr+ZBb4=;
	b=5ExAOfVA7PyTRjDiViMJEPGrsYvGyz/7//Z63S8uvipp8mwL6SGAVFsa4dxuJf45PbDtPE
	V4MsnSqaLiiZQapA/u5l4gOj3v7LVaKEJIGpsS3yM77+b8zkIa4dRO9rVbObbKbXwEqfz1
	kUM4dIbfQCGlZwZTzyFApvQ+Vr5n/kg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E61EoeHS;
	spf=pass (imf14.hostedemail.com: domain of 3I-sCagkKCFw4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3I-sCagkKCFw4FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576165; a=rsa-sha256;
	cv=none;
	b=GK9zhyYhjn02gsuvkCuJUDuoM3l1o/CP1eIrbayg8PgCqnKiMQGOOKBEDLmJ2fIMcESIwe
	mXn/c28M3Biz4ihYjAlcuzzTck7YYFKU3rnVkd0gP7Qmh7bhTOa6dJ/2TPkRHlYSFbXAIC
	zwvQMgFopFIk8ZyNcKSvJuT2Grw/+Pg=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4891f97aef0so28405955e9.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 01:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778576164; x=1779180964; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yKt1aQHWlToSTBHmH9DUCE51K0B4uRuyfHpEOr+ZBb4=;
        b=E61EoeHSX//9nZSn8iAvtmguOwyjMtWnLAlaA0PSNOMvFfcLsT4QwOMpHX/kjxQXi7
         8sKnGkwvyGbCPJOzBCaauzt0Aq5NeF1I3mMlKr/ZzuMxadMrRxNxxmpFwbTy9WqOW3fN
         mEOOR+0OPzNevbNnFy1mb6VA8/nkwj1DfhoElu2+R+if53q9JbjWnsLZHCljzJqObxCo
         tJj6nxuN0VPSX7krSQ5QQU6biSf31+UIQwQRndVbiG1P/oR4maYxGZ0dzAlDk/vJErHS
         yF4pcb09z6OXVHiCH5oE9zfpfhHi01ZqIRwnx5ZyGgUNmSpKdXQQ4nZBefcGhYyj62T+
         b1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778576164; x=1779180964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yKt1aQHWlToSTBHmH9DUCE51K0B4uRuyfHpEOr+ZBb4=;
        b=gwG7EYLlorzJwqVEMeRnbliXK+QnlQIQ7tfqx985jBxRG13LZ7iCpwrr8MfrpTjyXR
         53LWKNdssVVX70Z8omAkqjMRF8vMbbP2HHCM7YztLU9vgaW8H6NHwmIEzu1HZwZL1bvb
         UYtXDLdK5Dgly5U9MZsLVEa4tVVvjUzkP2fd2smRDZQ8Uy1zpNQPdP6PT+iLU5mogiAJ
         nCg1SxB2QtTPr/n3/3dDvqMuEl0sJHAARB4IKt9tGiAnad46E3bH3+mM+77JYL1ZxB3j
         mxmUya7q/pQH3tBVbjnyu6pouZNKq3rfgxiPATO/oY0h3b+KzC4/oK9YGz/rb6jvHxre
         thYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/CtWzcqLikQyis12s2UbYuimx8WKHuS5Rx4Fqz6ml/uBcuAkBOIEfE9gbdvz4waBLWuKkv1o88mA==@kvack.org
X-Gm-Message-State: AOJu0YwaSaU86owahsAtP5PXCvxb74NSpT11Ujt38zb1dbmTZMOZBi7E
	bCOC32bdMUGqBxqHYqd6dJAvCgOoB4cBpVLRiffsrztQuXvlPhdH2mvp7X1S9G6+B4KjkV4kzm8
	CYRti8ZHszC8wTZmxpg==
X-Received: from wmbdn18.prod.google.com ([2002:a05:600c:6552:b0:489:1f67:5a81])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:698d:b0:489:1ba8:5be9 with SMTP id 5b1f17b1804b1-48e706f0e53mr217152875e9.29.1778576163910;
 Tue, 12 May 2026 01:56:03 -0700 (PDT)
Date: Tue, 12 May 2026 08:56:02 +0000
In-Reply-To: <agHUZ4AKQBgMecBY@lucifer>
Mime-Version: 1.0
References: <20260507-binder-shrinker-lockvma-v1-1-76e3406bbfa6@google.com> <agHUZ4AKQBgMecBY@lucifer>
Message-ID: <agLrItFpcWD0N0pO@google.com>
Subject: Re: [PATCH] rust_binder: use lock_vma_under_rcu() in shrinker
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: e687m4m8fyn7fi9bfp3yihxisja7kcmb
X-Rspamd-Queue-Id: 7F278100008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778576165-297008
X-HE-Meta: U2FsdGVkX1/d0bkBYDaJ/7o6HVkGZM2M8I0UyhkZb9BeT10X5Erk3YdOmWYOigNl7frw5KKceq9eJl0Ki3dEnEXxqeqJ9SpiUEH5MXBpfsyBs/8OEHe4GRe84hYYTdhn9NsZ5c1zEOceZQ985WA+TCS844O4dwsDSrQJGIXt22moez7q0eDY0glTnVxq9JfE3cgDY7IKFMnRNVdolrCAaZkD5z8mX2Pinf3GE6NzFyBvbEHyX1ZuJTrnyVCaY2r6eBXABhRW9oBkpiJMWU1bUlADMMlmwYqH8Z5GXi6b/Woe4Sb3p9DJuWyMBjt4AGKNbk+wxxIoI5e1twAln3+IrRFWUDPYjQN0QHHitXdpPXp1yDw/LuJZsItR0HwtR5D5zJ8eqT9aFi69NDueedEt/U8euTS9dmoC0ffEUk9a9CTWg5rXZjX+3Enhq8NKOosBUYewOeyGKK+vA21w3L6ML8YgK9von9oguoIAquDVRkXprXTS9T0p9RpjnmxKsEqHbhJsbcfLr6sE0QwLTwBnVrQ6FhsmQ1ZD7j9K8HHv4VvmcNfSWQYTZaM6r46X2LyRCCvVlKE23ey73aj45xFQ8TTfx53gM7kFCeF2jxbfABecBPmjIdwgufKIfPxtwrU8nbdr+6MGLxes4TigrrnGZVJy8eY9ODoN1jlHKPZQVy8oUso/opVIPvO13ch7CiqfHVIuFD93RPy0ysTq80v71OYs/z8hJzTypXX/le87ctOq3w75gk+NzWkxcAb/J0bKY/YyrMZIIyTA9UHESImCS8mSd4vFDz9fHM2xAjwYw4CQbtI2qkuy3ga106XKR1RipcviiRM9Z8GCyCj+OWAJrPAksGz47FBnaz3yi5DQYa/Nlap8M+ukgzjdLAfOV6Qytgg1ICKmDlgyBnzgWmizc/aXZSmpKTfSE+1lkarvIFFV3AKQDbAjEVv/9cb+XdDYG0TBDWguvDlF2b1aElu
 jEQDnkv9
 7g6FMO8AUBsV3fLf21gb15w8W4u+yEBYm+ynBdEd9t7kFdYYFq7ruFVo90Tr/umsNfw/PBMzuTWday3bScwfER1WLNAqqHZ+ZDgO6AHgrCdzr2tfwSKkFTpf+Sx1Ws0uO7FLF+OZ9OvstFuqdgAHxhLAxXpI4Cms1v8+Py45VLQwGI2kLic/bF+3TSyjerPV+/hIwsr2pQaY0HkvaZjj52XkTjhUuj1dEII7PgFXOyB7UckeOZrLwKkgfx2qYzXQdNqRI79rKBG6IMAglqiBDX3/E6miuUSle+NPRQ0yS80iJ1F1xTDji3yQ5dchvYBzHFYi87t3GWJco8xjOHp3lNPTgeeA1J/NTH4tpFVRsypFA0b7xQrfz14Vi9ntNqNbGnbK+jDgj4Lk8bY/iztqwpRoXTJ8hBYN/q/BEC94o2Otw5ZiQi1kdr3QJdIQttTFm8B7BnhzEXUUDmbghBsHbIkFWXQEglv8+BZuShNsNEVVjO4TplxCzUk17FWfOVNUSyUeTxbw0TfcVKc8RwORdAebimVXppQcuRm+zVVjgneBTqOfFLozLdlrZ9nS3hnreVy9mZJuoWvvDqE2VLy2MMno2wOXlZx4p8LpU+dyctjvPVzBOW4iqLqrpA7sh+3pAhtM5cJfMfLFKQBJlhkZVERVFU4zmMfHmGrxskP4kIxuneaCI60uqc9L4SZaKQphhWlaY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 02:19:42PM +0100, Lorenzo Stoakes wrote:
> On Thu, May 07, 2026 at 11:07:47AM +0000, Alice Ryhl wrote:
> > The shrinker callback currently uses the mmap read trylock operation to
> > attempt to access the vma, but it's generally better to only lock the
> > vma instead of the whole mmap when you can.
> >
> > When lock_vma_under_rcu() fails, there is no reason to lock the mmap
> > lock instead because it's already a trylock operation that is allowed to
> > fail.
> >
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> 
> This seems similar to Dave's patch [0], not sure if it was inspired by that? :)
> 
> [0]:https://lore.kernel.org/all/20260429181957.7511C256@davehans-spike.ostc.intel.com/

I was reminded by that change, but it's been on my list since commit
a0b9b0f1433c ("rust_binder: use lock_vma_under_rcu() in
use_page_slow()").

> In any case the general approach seems sane to me, as rust code I can't really
> review it properly, but aside from the comment below (presumably that's fine) it
> conceptually LGTM so:
> 
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> 
> > ---
> >  drivers/android/binder/page_range.rs | 24 +++++++++++-------------
> >  1 file changed, 11 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
> > index e54a90e62402..e82a5523804f 100644
> > --- a/drivers/android/binder/page_range.rs
> > +++ b/drivers/android/binder/page_range.rs
> > @@ -705,7 +705,7 @@ fn drop(self: Pin<&mut Self>) {
> >      let page;
> >      let page_index;
> >      let mm;
> > -    let mmap_read;
> > +    let vma_read;
> >      let mm_mutex;
> >      let vma_addr;
> >      let range_ptr;
> > @@ -728,17 +728,18 @@ fn drop(self: Pin<&mut Self>) {
> >              None => return LRU_SKIP,
> >          };
> >
> > -        mmap_read = match mm.mmap_read_trylock() {
> > -            Some(guard) => guard,
> > -            None => return LRU_SKIP,
> > -        };
> > -
> >          // We can't lock it normally here, since we hold the lru lock.
> >          let inner = match range.lock.try_lock() {
> >              Some(inner) => inner,
> >              None => return LRU_SKIP,
> >          };
> >
> > +        vma_addr = inner.vma_addr;
> > +        vma_read = match mm.lock_vma_under_rcu(vma_addr) {
> > +            Some(guard) => guard,
> > +            None => return LRU_SKIP,
> > +        };
> > +
> 
> One question here - are we good to do this _after_ locking the 'inner' lock
> above?

Well, it's a spinlock so unless lock_vma_under_rcu() can sleep it should
be fine. Though we also hold *another* spinlock here, so if it can
sleep, we couldn't take it before `inner` either.

Alice

