Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A50CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AE56B0005; Wed,  6 May 2026 09:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B846B0088; Wed,  6 May 2026 09:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A0F6B0096; Wed,  6 May 2026 09:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 326F86B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:04:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCA9AA01FE
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:04:07 +0000 (UTC)
X-FDA: 84737012934.22.999AE01
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id CBAFF100018
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:04:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HL16z1og;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778072645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VyxSzMGcG4YBihOth/kzEfCuby+TU4nCMC26Shuc0DM=;
	b=7w6noZZKqFDCLQSvjFEvizDp5CLCsDIjWJ+nyGF63CfnHpYDnkdYethLL7briJz1L+U/6M
	RUBdj4d+iAJHQ4uK6iGqu6k7B2gLNIoLE8WfB/28H62JNsYJOkuHmD7HppeR7r+JwgTOwy
	0I5b9ZRxnWb/67ys81VYRneYoX2y/XE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778072645; a=rsa-sha256;
	cv=pass;
	b=V5xksnsCKfNKcPuea9ddDuulPC1Gpe/YwTvjlyo21fycvu7cuEU5PlB01J+1FmH1pB7Pou
	LX8R+ufF05+ExsrKb5gtNv3voK3766MsuUi35cRkTL5wAMbDDxUwW42x239aBkBA0e2xhR
	yTahl3PTBSac1bfsfbwFSH+KxcScAs0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HL16z1og;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1305908ae11so5498079c88.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:04:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778072644; cv=none;
        d=google.com; s=arc-20240605;
        b=JZm1LM5bNXUZcn+FfCD/pOEFYUJkFi7OuB129I0HoBribBZfwnDe4CIrYuyIpvmMf/
         c5VJWWyxmH+jvhhIrhmyVFhwaK3ZxvWAJE+LDWCHq/wuslq7dPI+qruBqS9fzCKBBO+r
         wJylKFEt2XbIIk9jYRIf8IHk6+ong46WCvJtb1HCOZsSr6nz9fLmws/vVQwkmq5uZDtp
         HlMxaVBRae82U17Y9kpPgdJk4tn6pMhNYLU4SEsGKIReUWNorBE7+U14TyVFdUWLkUfP
         FIukzp4rm30Mv61d0VaOffTnMyJfw9IHXr9uAaxLPVzA5cnqNWJWFNHXWndcBVt/HS6+
         SuLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=VyxSzMGcG4YBihOth/kzEfCuby+TU4nCMC26Shuc0DM=;
        fh=7E1YdjsKdQ2Tg00d44wNQrW6XrOywB2pzvKsoETZisI=;
        b=EayvoC4dOjp+mHm4chs5rlRKpRMCL+fmNvC9Rffiz3Q9MmgQJFjpBBXEL+NKZ/1EGT
         Kz4j+gxZTBaYvhpNxUdMaS1Bh7B/ciG6uDY4nYN0+nx28sgzwJizwFWHQjDvVvaRSmyj
         u0BoEeBdCYTDZJUQo7PHBS0nPGQsdRAFCch8ow5N3rZiYSzYK+m8dgS7Jg8pqa6RSCGc
         fWb7T8SjufuT/8BIYp8LzVN62W6oidSn6UWPan6o2W0bTIEmtetjMrk3Z+IXduzRr5me
         QKuXsFTRSS0QeoIdy4WDi4y3G+fS9dUf4w+smEBO/QmKNx87vNUrCVx4koX/uKCukRWd
         KwRA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778072644; x=1778677444; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VyxSzMGcG4YBihOth/kzEfCuby+TU4nCMC26Shuc0DM=;
        b=HL16z1ogYP8ypLMchtwEuBg7PCsAuC7ofMLs+wFJqDsYFQSAtMufwelh91LqoVDYmI
         FqwurvHKR1uMEKc3J7Q2ZywawaaPDrBlb64LIGWyfGBk3MdVNOArMWq3fpqUVDSK4bfY
         twq7RNPwy6wztDULfXo+Fjk5Kuz8g9TNO6LR/cuxuMhimft0X/qcey0urNe1mPadKuni
         g8k3TGh8TwqiXm5w5t1d6SySpet7JoGlieuX2C6OAdinbdWCmoVwcLV8yCwSGp0zgF8t
         e99g1O+0FctTuoODQFwOknAGvKysfgP4rADA4gcgqdqQDNXkGq499drgKkVZoUgbyHK1
         KzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778072644; x=1778677444;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyxSzMGcG4YBihOth/kzEfCuby+TU4nCMC26Shuc0DM=;
        b=QOdlNHZmxzMjwEXfA3otb6+RgVHI2be1F5RdbAPop5aOoIm1dGrf7gksmCbmTWqO9U
         E2LTProBtu9z06/02NLRAlRGWitrWJaa9f4a/c+sipywQAz3MhEXjLopOT7VQyKU4Bi5
         6lHEGKZ0SgPNh7GhdWpiJv+IZwJwhzjgyA4roBCeU+2EYLtKRGz40Dny8NBO3jOlH1Rl
         W4XqZEKBwyfwQRZ/V1YzUJB03b+/yzV688ssVSDNvF1KFl1LysR+SXsuXiqPiUU7ZfDO
         vh4lu5JhswysKDlclaXnpHycLylgM6cOUiqjtt7yqUyDXPOTOvPXKa4/oAhGfsoGZu0O
         uB/Q==
X-Forwarded-Encrypted: i=1; AFNElJ9mdThSg5d4I1BnUt6T3WRVKxNImGXxvyD/29EhkFtxsFUnb5NqA3AXDEKzr26yy/Vb0UugG0qlKg==@kvack.org
X-Gm-Message-State: AOJu0YyUwpgrgtjA8AO5pAu8gQASLLHNo4bhpeLGY5zHk/QNyXZWJaGq
	k67ORvhRFpcOdfv7w76ATWAb49fxw/XXr3ZLlSSC6WjSJYAijDqmOz1oi4SDCnfREwBD9G23UWi
	172BhxIzYn2CkHFmkCqNb/KzMc/AUOkJo9Ngn+3wV
X-Gm-Gg: AeBDiev65IEw5oieagul77GIMAxN0lH/uAUrxjDNbc/1vv3L76lIRYXNmyzLkk1hx1h
	Sj4mP2Siz1vH10/PZnU3Ad35M9nHKUpNxh8914ce22MzX5+aE6uh/tehqAyviwrYfJ4J2Ewp+4l
	Mu2xe5LEzvjwhUou9hK0QD7YHHmoLpJ+FABsTXMxD62ExcMkTIG21uyIS+T17eFmjIccE7l0j0q
	OJIfPors4ah3vgJoiIe6K3OI5TXpw3p2DZZrQfQVK5KoeD6hXqlvnt1aYrN18zm+s39mpLazmpV
	JfTFkFKNN3A0V40Yg2BCUdpjQVMFJa/B9oIq1E5bCI8nDx/6MaCXfCU2pxuTW1Mubb8cNFA=
X-Received: by 2002:a05:7022:ec0b:b0:12d:f7a6:e641 with SMTP id
 a92af1059eb24-1318e9178d9mr1882135c88.25.1778072643669; Wed, 06 May 2026
 06:04:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260424132427.2703076-1-elver@google.com> <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
 <afkOMIPu1WNFE9MS@elver.google.com>
In-Reply-To: <afkOMIPu1WNFE9MS@elver.google.com>
From: Marco Elver <elver@google.com>
Date: Wed, 6 May 2026 15:03:27 +0200
X-Gm-Features: AVHnY4I_sIIXoZtb7Dp2LdZncViXZn8dSOWAzjV1MMogggcywyvPBFhYkIJG5fI
Message-ID: <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] slab: support for compiler-assisted type-based
 slab cache partitioning
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>, 
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>, 
	Matteo Rizzo <matteorizzo@google.com>, GONG Ruiqi <gongruiqi1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CBAFF100018
X-Stat-Signature: fnyix7nbsbusi8jw7hn9bdkd94e91zu1
X-Rspam-User: 
X-HE-Tag: 1778072645-357547
X-HE-Meta: U2FsdGVkX1+37C8wjYoNq1swuvTCjOrVP/mW2j7GeHEyM7PoJXN6LMTyH1PYTU2NkXwcX/QsxvhnbM7XJRtvIqNhqxcg2lN5kWT0HkIZkBRi7JTil7AqnEUC5B4Ry5Cks7bCqb+3KBnT8B04L4igLw0rW14K3ii4D0uVVBOuMncz49RlYtmVkJsHmX/WiM6sbMrDvIFfzM3VrNkYbsycX2l7t7Tq7XvzOaXqrVIZ27CJDRYs5V3QjwzocKkOlTGCsjjUOYgYFmeWy4X2H2/SKLZ7dUTBKYtPwDriklhA+t2Afom3krxggewCLqkWdJlChtsbWIHIUJf9o2roAaaqv05kTVN4RE/fQdh5sUxrMnzNGfgprfbp9vfxy2PBiNo3kB6lmt9Ewh3sduf7wKBnKX2HQTxWE2kPWrsWYxjp+49qHG25zrXNZe6OVawihdGaaswY4Y5q8zvWDQWlOHDjazbJVJaJ37NfvgKin2ws8EUzXjEW7ELWf96SECJxIS3Stod3BOYSrONhYnD6ZdRFDuYG+Y4aRD+9sMpCG+jQStEjY2b45L+TLIAERFoAbiZFMFeA9mVX9dkfzW7oWEkjJ1tiQxWgPiC8lvXvFLEhsioKlFNdmtIb6JXEnIi3QB7AlsJeT4m7T4OvSsKVXPUW+or9QJsBLycSSQS6mkOjcBmrUy3a55RZDOdLdPSNmYHUGlLVL7Xi1BuN3BIIvAWiH8qWoPA5OPyKpuQgKUQ2FW9uJhlB5lf/q2uJVl1YfQM4zl9UoU/4/vvrip8GZ7bDluOT6943vQGymb9h1DzaDM5MktcCLoiDInuetslna1t2IBP7xtYeQO33C0nC5ybjhiTOfVMCGY79LKFbgoH/Mu5gbLvvdysaNUHtul/QhK65vUlQC3Jc8IiHXhosJCKdhQ4xT+aV5ckfHg2cGqw5EC6eAUrllXgBAdkucr/tmVrUftrrfsq4LntXIBGfLrQ
 CY9FGwgj
 s1qdIlpYlV3lW3tDyfAHlutDd4VGA4UQtBMID50HFPT+X8OYOXdgy4QimXg1hma8AhNU4ZJzxwQzqo8OwDiAclEZhkJf38uBH8Ooy160KJ3pH5BcIrYbqm50LGU9I/QI25KWqJ1f8ki+5AMtJcF9PV5esy0h+vjTTbmeLtgErQA+REWE802arbu0nwIabbEgxqMgl9yKbkxAXr+SCIPLyPKS5aRfNZG3Xqv5ywNlaO5KrCXkKAlPiPXa+7KDbCGuJQPtZ78Gdo0kE3Hq5X4dw5XQaPV9NpItfc3mZb9mQ0/+FozkJfWp2gfe9qijb9hW99FbyJpk/iupA6cFqxNhNxkNhz/ji4HB9nGhF201WLxC1JpoOE9QaDT3im7j2SMOAIf5k3TjKEwaqpOGyZ9F4M2D9n3b9eMw/nM+Jx00oi2teE5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 4 May 2026 at 23:23, Marco Elver <elver@google.com> wrote:
>
> On Thu, Apr 30, 2026 at 03:03PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 4/24/26 15:24, Marco Elver wrote:
> >
> > > @@ -938,7 +968,7 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
> > >   * Try really hard to succeed the allocation but fail
> > >   * eventually.
> > >   */
> > > -static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t flags)
> > > +static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
> > >  {
> > >     if (__builtin_constant_p(size) && size) {
> > >             unsigned int index;
> > > @@ -948,14 +978,16 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
> > >
> > >             index = kmalloc_index(size);
> > >             return __kmalloc_cache_noprof(
> > > -                           kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
> > > +                           kmalloc_caches[kmalloc_type(flags, token)][index],
> >
> > While reviewing this, it occured to me we might have been using _RET_IP_
> > here in a suboptimal way ever since this was introduced. Since this is all
> > inlined, shouldn't have we been using _THIS_IP_ to really randomize using
> > the kmalloc() callsite, and not its parent?
> >
> > And after this patch, we get the token passed to _kmalloc_noprof()...
> >
> > >                             flags, size);
> > >     }
> > > -   return __kmalloc_noprof(size, flags);
> > > +   return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);
> >
> > ... and used also here for the non-constant-size, where previously
> > __kmalloc_noprof() (not inline function) would correctly use _RET_IP_ on its
> > own ...
> >
> > >  }
> > > +#define kmalloc_noprof(...)                        _kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
> >
> > ... and the token comes from here. With random partitioning that's
> > #define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
> >
> > so that AFAIK makes the situation worse as now the cases without constant
> > size also start randomizing by the parent callsite and not the kmalloc callsite.
> >
> > But there are many users of __kmalloc_token() and maybe some are corrent in
> > using _RET_IP_, I haven't checked, maybe we'll need two variants, or further
> > change things around.
>
> Good catch. I don't think we need multiple variants (otherwise the TYPED
> variant would be broken) - we're moving token generation to the callers
> (not even inlined anymore) with all this macro magic.
>
> I think this is all we need:
>
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -503,7 +503,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
>  typedef struct { unsigned long v; } kmalloc_token_t;
>  #ifdef CONFIG_KMALLOC_PARTITION_RANDOM
>  extern unsigned long random_kmalloc_seed;
> -#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
> +#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _THIS_IP_ })
>  #elif defined(CONFIG_KMALLOC_PARTITION_TYPED)
>  #define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
>  #endif
>
> Plus a paragraph in the commit message.  Let me add that.

Bah, this is why it doesn't work:

>> drivers/gpu/drm/msm/msm_gpu.c:272:4: error: cannot jump from this indirect goto statement to one of its possible targets
     272 |                         drm_exec_retry_on_contention(&exec);
         |                         ^
   include/drm/drm_exec.h:123:4: note: expanded from macro
'drm_exec_retry_on_contention'
     123 |                         goto *__drm_exec_retry_ptr;             \
         |                         ^
   drivers/gpu/drm/msm/msm_gpu.c:304:16: note: possible target of
indirect goto statement
     304 |                 state->bos = kcalloc(submit->nr_bos,
         |                              ^
   include/linux/slab.h:1173:34: note: expanded from macro 'kcalloc'
    1173 | #define kcalloc(n, size, flags)         kmalloc_array(n,
size, (flags) | __GFP_ZERO)
         |                                         ^
   include/linux/slab.h:1133:42: note: expanded from macro 'kmalloc_array'
    1133 | #define kmalloc_array(...)
alloc_hooks(kmalloc_array_noprof(__VA_ARGS__))
         |                                                             ^
   include/linux/slab.h:1132:71: note: expanded from macro
'kmalloc_array_noprof'
    1132 | #define kmalloc_array_noprof(...)
_kmalloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
         |
                       ^
   include/linux/slab.h:506:55: note: expanded from macro '__kmalloc_token'
     506 | #define __kmalloc_token(...) ((kmalloc_token_t){ .v = _THIS_IP_ })
         |                                                       ^
   include/linux/instruction_pointer.h:10:41: note: expanded from
macro '_THIS_IP_'
      10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
long)&&__here; })
         |                                         ^
   drivers/gpu/drm/msm/msm_gpu.c:304:16: note: jump enters a statement
expression


Apparently using _THIS_IP_ creates a possible indirect jump target,
but because it's in a statement expression, it's invalid, so the
compiler complains. This is obviously nonsense, because the actual
indirect jump in this gpu driver code would never jump to the
_THIS_IP_ __here label, but that's what it is.

Given this pre-existing issue, we probably need to continue using
_RET_IP_, as before. I tried to fix _THIS_IP_, but it's incredibly
brittle (e.g. __always_inline function returning address of label
doesn't work on Clang, but would on GCC).

