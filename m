Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B390A606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=dq8A3F7i
Received: by kanga.kvack.org (Postfix)
	id 97F7C6B0705; Tue, 27 Oct 2026 08:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957736B0707; Tue, 27 Oct 2026 08:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E0C6B0708; Tue, 27 Oct 2026 08:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1B96B0705
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:48:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECAB9409D4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:48:43 +0000 (UTC)
X-FDA: 85368385326.23.8ABBE46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B70B80004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:48:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dq8A3F7i;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=glider@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793105322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDnFJhnX0J4NQBmELS7yCBX5NqK2FFtvmRgZ42+Fi5o=;
	b=urN7XtbzEgHgKG8/8R+MDO9skVn1uJg0cNDHx89FrJAirUUGUfxBbLya6Cq6DZ0Fd4ETI8
	8GgG52jem1IuOSNn5EPJDLglsQ8Cs4RVqtULn0h0GvreJrQNKFLpCqe7R37hIVhsQ1gk3h
	Wfdkv1pbYE/LojaJZU4N/g6VeQWFngo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dq8A3F7i;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=glider@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793105322;
	b=Q/TNUFZYXXrpBMRfEBNGsZmWfjICTAngmyPIdxtx1w3ltzr62xNjCx13L4PwVJThS1sBlb
	mDbe+rqNeenQrZIncjcmloQYHsRrGsedmPz2VKlFlhmsPL6IZNITqWJ0Bmh2f+lx0xDDKJ
	dIY6ahcre5nfxepGtVyhaL5rilRyK5A=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-188406bb948so3321282c88.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:48:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793105321; cv=none;
        d=google.com; s=arc-20260327;
        b=gLM+i/pSKbbFCAJQMmaPWxGFYbC9/+ia6IdHrp6bZphW6QVJfubD8OO6SbkqWXCAhr
         XIFTn4IuMHeFCHwq/GZnl/vMzRQCymBliEU4G8w4n8/YK1+/CtUATbQ+lrU1oBg6Ijne
         fwtuPAXxBgbfXvtbBIkTJTPfo49muQOMwQ9sSJkujoSL9jgCEKDEiILhvtOp/4GYdykE
         cCu/rJoInIn67m8KENnWAWnpJLc1jbuHbYhj2wquNSYZsArJIYnzmiiE9TyU8mGT1QP8
         ub/aOkK2MeTswyjuvSw8ogLWDpQ70X7jUAfaTzi1CG2e5if7/fwzLJoWCAFGqwK1IQDi
         zXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vDnFJhnX0J4NQBmELS7yCBX5NqK2FFtvmRgZ42+Fi5o=;
        fh=0Nic9nr3QC03Zj371EqjT0Z9ylmoAnnYfJddSWGx45E=;
        b=Nmi8+ZtRAyzCsqNkFZRO04IQdkLj33OsMCIiJinjjflsZ2B5cN9G/Db5Y8ZbWvzd22
         u/RjBUx1atRXn8inpdlEkNNWbo5SSY6+c6q02Osa8SaRAGTRTIpnoznm9zGSGLN4nAJJ
         TZfapYj4rhXL6JI74I+uPWQ4uVLv8LIPHsK52PcjwzOVbEIva/V4C2y2RFbBM7E7PYgX
         3dBxf4VEkuc9+NcKeCKdbtVtHM/EpZ5xvFSRhvg1qT2sV9k7p/349zOjgf9MRDBJ5mpL
         tS/1wKK4xR+Kmp+yAxjVFlUtrAulHztp6hZGBPgFLNkuYuIxVBoUmuIWg5AqDDjTdtof
         uWKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793105321; x=1793710121; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vDnFJhnX0J4NQBmELS7yCBX5NqK2FFtvmRgZ42+Fi5o=;
        b=dq8A3F7iCIcKw0BbwQxda9JMn4BcTBSwg338gXH4tAPDLRoL02zvE2upgsseOMUxwM
         1cKYgBXiPcyFJ3NNOIlmKWHxH8UzSHCNu7YfrQMb14RFB6UfjRLNJ2XX/ac5TiuuNefW
         tochLuxSW/TIcH2M20wko601Y0rKgtZ872aNLFEOGbcAniYnDAzNAHu8FJrQ0EDr9nf0
         9mFY2AFgEDRGF8hBQfBO4TkqG6JWOIf+mGXZhp44UPUP5/PQozLZyH+/Wk1KevWIhRgC
         hwBF+7OGOHXV+4hdmaNu3bS0vk+XsSTYe8V34oDP/EEa72TWypBUo3EUJhPcQw9IQV4m
         fsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793105321; x=1793710121;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vDnFJhnX0J4NQBmELS7yCBX5NqK2FFtvmRgZ42+Fi5o=;
        b=0eGL63mV7uVAPi73TfU7atknx7ardjn2kp7ZBkbEDD/w7fjC/YyLAr9IbHIJVt73cX
         wB6KMjaxioZtVT4E7bA5eVZ1lmPdiVPr8yQ/WNbnLsvAxqE8iT8oFnCWCYAoLhQ+4KxS
         DVhDh/vnJMf3QT93uft6ITiBLH/oYaGkfGS5DzcLmn0VzsBMbRWhG01UONb4b8y+wnp2
         0v0iTIn4rSIv+a8+92rnlXw1Hv+JVsKBwngtUBbNk4CPuLdxvy3BMQBfW6JvAlo2V/Ea
         RyeT19gFf8txRopU3R+4TZThHHG6PQRfIWx8IxDWVhbBYPUouU3Zw1ywCzngpLgw8brV
         +afQ==
X-Forwarded-Encrypted: i=1; AKwUvBz5LqAT82DlcBdiqlgdnjsO7Zgzd8Sy4wBPaRdcIY04+5fEBoXQOb+jL+CVHpkmTt1/TGNkhPPlkQ==@kvack.org
X-Gm-Message-State: AFq9FYIsLAfzF9GyNVkhWtARhhVyb8RUh78SYXgCXg1DjqOFRbk04/VI
	k1iAqjuAX/P/cwxCOkYU857InG58ono0kO+rcN5YVWcq9GaMMhQwwvCZKj4Kbm1SKgOcF/mk4EC
	ZIZFgCG8uHBLHeBB6zYbwNgH+485uXiS9yrQpf8IY
X-Gm-Gg: AYBFou3ftAgqxwsVyZDEmW6qs1/6wfWBbAg5NDcLGGvux1S9ej9TMtUs1f1tmv3Ug5U
	uAGkZibyaVtltZ1XptFpJjJdf3P9J5ckfTyOacFVWZALnUhDQiwUSlB73vFsFsA/FpOm1X1bvYA
	OteoVE/Dvx5Clv9isqrzdD/rqGD4knI4ypM9KLYvAtyzmwJYC2S081GMhtkSZ0g112mIMgWJyok
	0sdrUmdw8lQQE6DGs4zllThth3Zot34iORFgqXxL5A/tC/bLHWkNM79zVfweeJZ9AIkcAUzJSuL
	ZLv9lcHvN64IwhN5nY78QwfEjdsI+WD6iGpCMTGCX6sOuEXp65m75dbcioPIEzFSQpyEQ9mDOve
	k8JPDQG/YYyc71QI9PJzGIk/V44OaAsb2l2WDbKw/39z6yO6FpC20I/pFhEdZzHQBOeYskg90BE
	Iij2RgLYcn5ZQi
X-Received: by 2002:a05:7022:4387:b0:1a1:8974:593f with SMTP id
 a92af1059eb24-1a1897459a7mr8543576c88.30.1793105319741; Tue, 27 Oct 2026
 05:48:39 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261009214639.2878857-1-kuniyu@google.com> <20261009214639.2878857-2-kuniyu@google.com>
In-Reply-To: <20261009214639.2878857-2-kuniyu@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 27 Oct 2026 13:48:03 +0100
X-Gm-Features: AclHuK9zisUq0e4E9bmEu5A-F2KfWQlEBXxUv6RjNCKCfl4f_c7wMtNgkWObV2U
Message-ID: <CAG_fn=U=Rf8y49JGYjJ4qT96=MwD5v6SLwVqeiOhR+Z7R2ZKRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0B70B80004
X-Stat-Signature: 8sa7h713c9apr8xfyzk3tugub1icuide
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793105321-423936
X-HE-Meta: U2FsdGVkX1+73BA7Ch0kS4VZSnMJrmfH4G+tFkuzIz752/0NH7vLsRxTFn9EpkF7hD8bX1qbn8bN3kuuSeO1T0OHe8qWycT3/XDWUQra04NCV7nVzIJKnxXsK3nnF5L2XdnJ70rFQCnrm5rVe4DDSHHkeG4DJLo0kV8bGoFy2QHFHTZZe0SjUbe1tbcpYV4i08l8fdt19ONdUdfaxwQnzpGlEIdBHz118MCjzzo+uoWcx7yvGZxzMina4ybRrksdCjGD0e0g/njcEs01RV7wbwpqYltyS5E19jC89ILc993ipbSUbdAS0n+ggC9HTP1bOr8W8UXCbu9DXzsy9OADPfXXs9wXPHcv/F2EoSsiZ0Q+eCnsMB81pS7Sq6INdyzgbiGxl+WFSXnRMWiiL3Vdt/CSGh52BI38nO/7uqDXmS4x6mi+0asl0DiQc9RKQcyr4TIXDU22a7y/AoG3Sxw/ojgNgbGYYVQkCmF0lJv13FnI1GjhXbVxOsoTd/qvlNoYUTqEi0/NfEuwVNcHOhtFvzeRMuSOI8jHI0byMknbH6Y0V/qKZ4vuo4utT0TzrBlGXn3/JyQ0178obNOOrYnrkqbhcXi8vetuaF+rACSo4QxMAWzT2lmIj0TBuzYAnN3FoweH0Z59pLAWfek3vbsGocNLZhl+bWBcho177zh8inx+6e1Zp0pxaYZIBT2RKSkI7+8QauJIx349G9DAIOOwSUvxHEtwR5LQ1q764plBtZRJ/JNMrJSzL7dTLHZ2dFicELsX1dxa4Ugc2TIhgbuLx0UM7927gDcS/lpo2iJaRjyFIGXsXLvke7eesAM9qM0W/vG5RSjCrxxJQ5HZ30CdOyClPD7sflyMI86FyxAvI41PxWkxCG/7UaQjDipLfR5DuyQABL4G3HZzEDzzGlDh0LWFuUevSJhjsFR5NeVHV3+iRIr2EBajZ/8nmRLEWnPUAyq/PxufeJ6YblIMwkb
 CZ2zyqPd
 acodjYFsvn6QvQ+HaWeQ8ErF/1npUY3tmuPDkDOqrlqdLWtpeSqUYfDgM7H8vj0Rr0r/vyysD+SkZ800NWSXG47pINfHWXoJaXx5Cj1D21lZWMnxe2qMgk3NiOn22a7BuIvEJUZWNSXI132HNdgWW7F1Jm/umSMMg/t8hiNDDuAVKZDrHXUZ67zulIEeqyxbHItoIeG7B7O2kUBYNehK3uVdoDDXllM6N/9GCtjhyI5qSU8dXHHIHoGmyhK2GPU85XP6WwfGpRdXTuLW41O8Nz9IByEkIChy1e+H6AtD05BUU43i/60QrUTIXRUt8Aqjs/P8BRbnACDJ955VtY5m0NxI15KN5k29zKq3VvXe8Nbkd66tYeXBDATx5b3/usbkaxxpzvcd23kUNKCbTAs7hdagGJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 9, 2026 at 11:46=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:

> The bit is marked along with recording the stack trace when
> deferring slab frees in kfree_rcu_sheaf() and checked in
> check_slab_allocation() so that any double-free pattern above
> can be detected immediately.
>
> Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google=
.com/ #[0]
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Tested-by: Alexander Potapenko <glider@google.com>

Do we need a Fixes: tag?




>   */
>  static __always_inline bool kasan_slab_pre_free(struct kmem_cache *s,
> -                                               void *object)
> +                                               void *object,
> +                                               bool after_rcu_delay)

Please update the doc comment as well.


>         poison_slab_object(slab->slab_cache, ptr, false);
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index 2b8e73f5f6a7..07636ffe1626 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -536,7 +536,7 @@ size_t kasan_metadata_size(struct kmem_cache *cache, =
bool in_object)
>   * This function avoids dynamic memory allocations and thus can be calle=
d from
>   * contexts that do not allow allocating memory.
>   */

Please update the comment for this function.


> +void kasan_record_aux_stack(void *addr)
> +{
> +       __kasan_record_aux_stack(addr, false);
> +}
> +

I think there's an important distinction between
kasan_record_aux_stack() and kasan_record_aux_stack_rcu(): namely, it
affects how this object is handled later.
Let's somehow reflect this in a comment ("records the aux stack and
arms the check") and perhaps rename it to something like
kasan_mark_rcu_free_pending()?

Otherwise the series looks good, I'll be happy to stamp it once you
fix the comments.

