Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7457ACD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24116B0093; Thu, 11 Jun 2026 03:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD47A6B0095; Thu, 11 Jun 2026 03:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B127A6B0096; Thu, 11 Jun 2026 03:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A32056B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:53:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45ED28EAAB
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:53:46 +0000 (UTC)
X-FDA: 84866867652.07.D40A93B
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 629B1140003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:53:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jic7N4e3;
	spf=pass (imf26.hostedemail.com: domain of 3hmkqagkKCFs3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3hmkqagkKCFs3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781164424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JSnnESFuG4rV7GM7o/iJXwkWustj1ziUDEWbZsW2C4=;
	b=FN4QacYjPt6MkG5i7cmG/HT6H35qT9oK6yNqovUpJXxBOEFeLXz7GVk9MZuZVLGQNd4txw
	FuJoQAp6/ofMneWxI0NTS7G/otfvhdREII7d4h99OJXeu8/Qx4rsy4fdsWJ0ZApga87uBI
	cvONwm0BcDzSlVP1+PtxIoQGhvY96Lg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781164424;
	b=ZuqoWyTZhZe7kATjMYl/qmJh2ZF4DxzS13MuA8hokUu4ZSKoRBz3klQhFJK5GQx246+Eq9
	jrKKi9T/H3BZ2kvIowfuHuvVqSFImmAZ9k4209AEFMUwBlLcz/A93vxZau/OL0Z2tJlOA3
	dGk/zCT+dChw7Iq/pS6bjAbTIpG2HFg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jic7N4e3;
	spf=pass (imf26.hostedemail.com: domain of 3hmkqagkKCFs3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3hmkqagkKCFs3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b37e1f47so65252875e9.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781164422; x=1781769222; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1JSnnESFuG4rV7GM7o/iJXwkWustj1ziUDEWbZsW2C4=;
        b=jic7N4e3+kLpd1zPACkjHUrk7ZRMDa/gPs9e59a02F+/gUzcrbuAvwB89stvfu+gYO
         cq3PKYxz9PA1yRUfVT0ZHc9KkdVoTEPJEA1itoRb52L+Z61mJ92LPqmrf3aaGUAUp8BO
         wHXMnsvEwGuMpUjJaSiIY6U/x7euGyVM7VUQJI0CQDP6hOTFX+gOzTd+BU0R4uRFNH+j
         pEbvLRgMCBv2TzF4sNLmOvV0eme+csX1PDwbmVsEvNjWM9C1l45m8VJ/2BuRQo/W4JKo
         +T3L4hwdwOed/oLejSee42/ewOkeK/inDhYy3lSHApU3PwcixCAJCgziAXTMiNklYvSb
         xAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781164422; x=1781769222;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1JSnnESFuG4rV7GM7o/iJXwkWustj1ziUDEWbZsW2C4=;
        b=TzeMKB4IVN7euPUJiUUUvzYmS5mHQMHRCEGn2iXAqO3qZF3iVTS10au1Eopc/7MleQ
         q0HpB0TZwhquNsuwuPVz68yLgjgNgueZGg5Hb55vXoZ5F6fiCUMPlzp8RlUCybBOT6th
         +SvUIrYxTElk9dA3+x2r8RfxpR8w4ejNRe2h8ng/g6IEEctA8PSzRcKpmSvz4n/pdnyF
         bNuEA+AqunHBzAsPqPENEF7rlGaC5uj6AkB8fKNjtemnEd+sFGgLVUkeEd4uWmuBzUg8
         otmqrHGasYJawrXtfEmTJmCDjM/u5IapW878w/xupVOlz35iw5H6wfKzPZ4lNrxXbSDZ
         LUtQ==
X-Forwarded-Encrypted: i=1; AFNElJ+MKqZmt7Iy1mt2SQ5h/JpQkkW5Cl4xeRM4cC9f90W8rhPSYLd7jQaFjWhzyRVM9pvRCQ4ECa39Xw==@kvack.org
X-Gm-Message-State: AOJu0Ywjk7wu0V/yMAvSNxPZbAqpnR1ImVIN8IX7b/fVF5n5xw7czsjf
	OWW9uEzlXb09MyaoimGeOXXE1eH3Wuc5Ps6kE1xMx6yNPT1tZ5FDYxQakRlYS9ZWN13jvCvwhWZ
	rfyeoxhaTMJhBD5926g==
X-Received: from wrbdw5.prod.google.com ([2002:a05:6000:dc5:b0:45e:7588:ecd9])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b07:b0:490:bb45:79ef with SMTP id 5b1f17b1804b1-490e534a723mr19329395e9.0.1781164422412;
 Thu, 11 Jun 2026 00:53:42 -0700 (PDT)
Date: Thu, 11 Jun 2026 07:53:41 +0000
In-Reply-To: <20260610230413.D68967BC@davehans-spike.ostc.intel.com>
Mime-Version: 1.0
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com> <20260610230413.D68967BC@davehans-spike.ostc.intel.com>
Message-ID: <aipphZ5iCnbXVNSR@google.com>
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
From: Alice Ryhl <aliceryhl@google.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Carlos Llamas <cmllamas@google.com>, 
	Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Todd Kjos <tkjos@android.com>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 629B1140003
X-Stat-Signature: kozefjhdgicqw4bcgkotsfx7k3r5t1fw
X-HE-Tag: 1781164424-394783
X-HE-Meta: U2FsdGVkX190sspUSnn2T+Zw9kZ7Sgm/91Z1sVuEnfrPNpUK/9lv+Q6EWiPwC8JtwtTNvIn6vu/F30fG1RwHkX9cCLGXAC+KRKpiiyzYyi1h2Nh+vcypXn47VSr8qm9fD9O0kp0VVaL+PqZs0FyczjMfeWihgcpmIKQUvO0V0Jv313xSNxbfVw/sm8sNjPv1QMF5Tbi9fRiBzki2U/jnRRaA5E1jwhSVi+feIH6wm4+lCkWLcpzh5WIn0J8wH5O9x/JvRWoms/S+hZUak1RBEU28z7fhPL95jKfUYM7pijQzxloHFSb9AApaqcsz6+YrEZoIdV1agpTkByP9wLIx+EEbFPpOqFh0cdgZDpTEUHirBt/OLxRfsuwYz6wLJe9f4JswfJ9qLPJDRIHX3BL1IJgQGGv2Ks+yIP+qSOxF8uR+m74IUfRJSepZ8rqZ91FRuyxAvFp2FEHejQIDN0jkXPge4dfd8NUphpo4QXJ5Sg9/Gy/6mBLMkEmJopp9+xb/883kntVGhXqpBhVvFF6Mn/aSn3R/eKaQ54cxfNHh/7l+Nkl4uyDlMrb56qUinFqShwu4JCIWdw6gzVrvxfrl2xCTfob7qPgTxz0f13IBYunr9M4ztLySREfQQ1yA2kdKFHBhVm5PF48fkVJyeacD3a7bug/mbxGWTWq+grBVXIgUm6QF5Oj+fsy8LiAQHIUL//idO4pqkmNRNx+xkrkAEctd9V6K7HuJP2SC++2RilDySWiA1bBF/LiYYhWCci8yGf2nJKIvz1g1KDjwTeFRzYOiJpkVyOofQCt4S8uGdh3nUQpvujWyFgDysyhaLh2WAWdeSbBM3STz1rlQHHrRQwajN3tjZA/GhPTEzDWnUonTxsrYQST2j5flzpyhVhGLeh5bcS4IdESieJgbKsaLsebNrkOAMbhNyOsdpvQgSGBMXRqV7lCbkqujfN2Vx5dnSmHT0F3ekexiaJYKwh9
 KPWsEp4j
 Olx5VYAWguvdMLnPFwBGX9yiuMGg3dULYB+yn/UyjDx5m7J3UYLg2tqj50FnDcl+tpUkswxUQuNeantWV0hfuu+rT2ohDgBawyiS8mjHpaEAl4aHi/DADUFlE13ZBdGIrYct7F5BJM9FcQxXgHZYuJJDP6mf+sjoSuCCIn6pl4c0J5h4KvIwOqZHVrK4jit3Hb2RyZA2iy1bP2SAHK9QVJMin7/1+ZZe9PEi41trbEvePMvqz+HeFII8VqCvqwAUTgPG+JX9nN/6K+SwsLOWny7sGhAj1Q49nPFBBCwjdk/J6xVPWXaKgEQYWLinnSvq9hWUoTlBwZIWeB26iLm216pGMI8isgv00P8rpT0XK9vx9ejWO/axFdqY99D3DKaRat8q/JUQs+ZUviVT0+/VLkYVgq7FMinowXRGEYiR6NsYz1EkjHunH0bxTmRqqwxe9cxZ3yTh+GbIIUqVW3y58yXNVJFvOPzn5ZKw2dVo36UCmTV5FO2wDCYJp9oT/7EQZz9Suv9OmtpjfmM4gweepFnSPEPDdQrwputcQcKUgx9ChnIMPInUK7rxC0vugxZylB7nq/YC4QOlXnCkNvg68e3i/SVsZuN2yvu77qyHHur60XPdDtqGRCreWkqKrPBpFU3UCHfhHmc2IkY1w9sEFfSNKis5t7i2ds+3NRW0mV2IgTNB/fU5pGe+wO40LCW/J8GURW7cbiXqU735IwekmEtW49LmqflrU/VN11u98fIoxM87fO1eCFT3pFBFlImfGeFVqRXfcThyfRieV+R7IpD6ir3+BE4xdYOjtMnX3u4qJUpcFb61oD3VW1TTSVScT1Yl2XKfWD89jD+RkVWW07XfppiS49UeCaiFCeVf3zaM2LXSN1IyLzDlnLOFbWwP7BRGDeYEdBZbYAGEtWfXTZRBRJEbw9DmCBGTZU7jfLVV6Vdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 04:04:13PM -0700, Dave Hansen wrote:
>=20
> From: Dave Hansen <dave.hansen@linux.intel.com>
>=20
> tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> it and mmap_read_trylock().
>=20
> Long Version:
>=20
> =3D=3D Background =3D=3D
>=20
> Historically, binder used an mmap_read_trylock() in its shrinker code.
> This ensures that reclaim is not blocked on an mmap_lock. Commit
> 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> support for the per-VMA lock, but left mmap_read_trylock() as a
> fallback.
>=20
> This was presumably because the per-VMA locking can fail for several
> reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> to mmap_read_trylock().
>=20
> =3D=3D Problem =3D=3D
>=20
> The fallback is not worth the complexity here. lock_vma_under_rcu() is
> essentially already a non-blocking trylock. The main reason it fails
> is also the reason mmap_read_trylock() fails: something is holding
> mmap_write_lock().
>=20
> The only remedy for a collision with mmap_write_lock() is to wait,
> which this code can not do. So the "fallback" after
> lock_vma_under_rcu() failure is not really a fallback: it is really
> likely to just be retrying in vain. That retry in an of itself isn't
> horrible. But it adds complexity.
>=20
> =3D=3D Solution =3D=3D
>=20
> Now that per-VMA locks are universally available, lock_vma_under_rcu()
> will not persistently fail. Rely on it alone and simplify the code.
>=20
> Full disclosure: I originally tried to do this with
> lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> trylock semantics. Claude caught this in a review and suggested the
> approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> I guess.
>=20
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
>=20
> --
>=20
> Changes from v1:
>  * Move forward even if 'vma' is NULL in binder_alloc_free_page().
>    This can happen if the VMA is unmapped (Sashiko).
>  * Rename goto label to be more accurate for new lock scheme
>=20
>=20
> ---

This seems to include the list of changes in the commit message instead
of under the --- line.

>  b/drivers/android/binder_alloc.c |   26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
>=20
> diff -puN drivers/android/binder_alloc.c~binder-try-vma-lock drivers/andr=
oid/binder_alloc.c
> --- a/drivers/android/binder_alloc.c~binder-try-vma-lock	2026-06-10 15:57=
:55.274412018 -0700
> +++ b/drivers/android/binder_alloc.c	2026-06-10 15:57:55.277412124 -0700
> @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(s
>  	struct vm_area_struct *vma;
>  	struct page *page_to_free;
>  	unsigned long page_addr;
> -	int mm_locked =3D 0;
>  	size_t index;
> =20
>  	if (!mmget_not_zero(mm))
> @@ -1151,15 +1150,12 @@ enum lru_status binder_alloc_free_page(s
>  	index =3D mdata->page_index;
>  	page_addr =3D alloc->vm_start + index * PAGE_SIZE;
> =20
> -	/* attempt per-vma lock first */
> +	/*
> +	 * Attempt per-vma lock. This is essentially a
> +	 * "trylock". It can fail even if the VMA exists
> +	 * for 'page_addr'.
> +	 */
>  	vma =3D lock_vma_under_rcu(mm, page_addr);
> -	if (!vma) {
> -		/* fall back to mmap_lock */
> -		if (!mmap_read_trylock(mm))
> -			goto err_mmap_read_lock_failed;
> -		mm_locked =3D 1;
> -		vma =3D vma_lookup(mm, page_addr);
> -	}
> =20
>  	if (!mutex_trylock(&alloc->mutex))
>  		goto err_get_alloc_mutex_failed;
> @@ -1188,13 +1184,11 @@ enum lru_status binder_alloc_free_page(s
>  		zap_vma_range(vma, page_addr, PAGE_SIZE);
> =20
>  		trace_binder_unmap_user_end(alloc, index);
> +
> +		vma_end_read(vma);
>  	}
> =20
>  	mutex_unlock(&alloc->mutex);
> -	if (mm_locked)
> -		mmap_read_unlock(mm);
> -	else
> -		vma_end_read(vma);
>  	mmput_async(mm);
>  	binder_free_page(page_to_free);
> =20
> @@ -1203,11 +1197,9 @@ enum lru_status binder_alloc_free_page(s
>  err_invalid_vma:
>  	mutex_unlock(&alloc->mutex);
>  err_get_alloc_mutex_failed:
> -	if (mm_locked)
> -		mmap_read_unlock(mm);
> -	else
> +	if (vma)
>  		vma_end_read(vma);
> -err_mmap_read_lock_failed:
> +err_vma_lock_failed:
>  	mmput_async(mm);

If the vma lookup fails because the mmap write lock is held, but the vma
actually exists (has not been unmapped), then this code might "successfully=
"
remove the page without invoking zap_vma_range(). This means that the
page does not actually get freed and will just hang around forever until
the process owning the vma exits or Binder needs this page and maps a
new page on top of the page.

Alice

