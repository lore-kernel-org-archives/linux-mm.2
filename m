Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F579CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC246B00F1; Mon, 11 May 2026 05:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75BF66B00F3; Mon, 11 May 2026 05:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B4A6B00F4; Mon, 11 May 2026 05:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 54F436B00F1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:35:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CC261C1018
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:35:34 +0000 (UTC)
X-FDA: 84754631388.18.57E8560
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 09583A0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:35:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=k4dqbEOd;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778492132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WufxmpQiwhOpJBofeZI+ZtjHioGWCbMxkve0DPKIOFk=;
	b=TseiEXboc/6lkywiuel6nYw6Y/SplctNmYYP5NsKSRW+x3IDlA3CHTAnKJ4cdjfWwZpQlY
	mJCh3P6pT2xYd+jmYURHeNwKht86F8SUuKPlup4r326KD9T9w7KKGBUJIwtb8FrVbPQRB0
	OOu0F6Aqg8RZ+PagQ5NNhYdF7yQwuo0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=k4dqbEOd;
	spf=pass (imf25.hostedemail.com: domain of elver@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778492132; a=rsa-sha256;
	cv=pass;
	b=SrMgaJlE+Zw2SfJif99x18cq9BU0orroR1u+zWphe/zcKKmua23FAHaVQ5IWGFnOjvs0u/
	GjZt6uId0jO8TGC9HllizMEKHYPL9bJk/xAkJUNJuikuL9gVQDxC8Fv6397fkSLBSKluoi
	KGWDDgR+OB1F35bDRDpWhMn/E1DFWcw=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1332772f6b3so176964c88.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:35:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778492131; cv=none;
        d=google.com; s=arc-20240605;
        b=FIFNM4WhG7F0nw98yhqX1k6mHpBOvkLJewi6etgmdDba7MqGcaZ1DqxjRCe3fGvsnC
         pO1m8ACtVNa3VcR8cuerLjXNd5p38QkX2B0Hu57cDu0FZKIiOChRr791mLeSYKDoMmny
         369zYt6nz4YYPebZ50u33FEmAjjyk1AgAmfvVKDqfzUtNdIwufq9lTJHpS3Y1oWcddtF
         kos4sxYlvhob0IwbP/xXnNpb0MoqkHhiyRZP/LjRA07zqITzxLlC+iXYERp4aVsNPDx7
         4kUyYYkAW6b37C6mSGLBXFJjViawpWvBUvPMefC9V54i2PAWxzaMHNiJQnaz4qaRdgf7
         opyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WufxmpQiwhOpJBofeZI+ZtjHioGWCbMxkve0DPKIOFk=;
        fh=pnps6GD8YX5QM1tDaER7nB90puiL9Z9Oim/8VMb/l5E=;
        b=ILl/5Vrs5+i/eX3D+ysT0zd/adlGFO7BoWS1MeZxag+rGogIzGsFp/v0K51zN7y3Q5
         ZeIMtrCB4j36AbZDslkoDZK2B2sSvc3WKma3p8nMITFE7HMigX4aE7G+PKYLfFPqunhG
         dh+OHfChvFbLuVFxSnrt3ek7QNNdkxwFxvgsk8NcB7P5Mxo9SOSqJDT8/QiLRMXOLStV
         3+KyJ4bjQ5VTQYHOZCdGpHCMXYObqU4+DxQdcgLLiGiEKWIbJIzsSUc6YZ+THcLeeHwj
         jqOpgi8w/B9d+dmBp683fGOrDFheLXVBBo2I4Za6Y++K1FxJX1XQ6bZqgzt0XCkvMc6g
         bFQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778492131; x=1779096931; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WufxmpQiwhOpJBofeZI+ZtjHioGWCbMxkve0DPKIOFk=;
        b=k4dqbEOdDJJG7VSSY6LxFrFPdkq+3Mi1tPXD+vggGZdF0VyTRbiHy7eOWNVtcUXlaQ
         8SmBwJCpA3M0kgDPovBM+Dw4JLXZ6WtVsiqZ7Kyp6R6Laip+32/bVVnih3HnsoBy4nk+
         yZYYgTpVMGckqGcYS8ooKtf8eAZDxL1okx9MZZreQ9Y1IRkpXVut3/d49U2M7xrH9HVN
         76z4d55sb9VGS0TrXOWZP5TP/W36cl6tfaeH1sg11vwvuEyogbEYu3O+Vh3lrbjVWXB1
         ufhcYJWUBqhPArKuFAgruWl1jJmK49gHdb03zM0A8ehLAVBMZTLyjhUgqeqL9hzJtu+J
         v1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778492131; x=1779096931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WufxmpQiwhOpJBofeZI+ZtjHioGWCbMxkve0DPKIOFk=;
        b=m0/cJ86iU2CFIQLWgNTdI4ZOQWukGFL849prY23+9CCLfd4pVzK40wn+4JbUwhSXTJ
         1E/PU6JRCGcBhoyzoWpJzAaTJZbUbQJ2ILrn+rX0T/Ua0symSWSdhXk53RIyF1OVmRx+
         XOVeyBpRXJdHeFsnfKwGvoAnMYiTzL/0FQURW/UeLFBNuS6WGbwseJ6KQ925eeLoWJOp
         pIa4pLwzFBZeLP0CJntEE7t9V7d+CkjfqrTvRn5HN77ea0vlNJs3/TgFi1yEANVp/7rY
         4je+G/1mClCMHc32q9fZb532NZr1Nq+tKA2349fmNZ3Q6p0OPOwDkyabDunFgnAZMsGk
         s/vA==
X-Forwarded-Encrypted: i=1; AFNElJ/4hsVC4G3Wq8U5FuN70BlObAYePUgSR5r5INyaP4b1Xe7LrZAL7kUr72jk0WoqjuFDOSHQSiLIYA==@kvack.org
X-Gm-Message-State: AOJu0YySREcBKfGoKNVIfUK+41kH0W9Qow0OAylzyzO4LivsqOlcS8YN
	grAfEBqIEYtDerNYfuKNvZPt4kjTzTWunnpEILKrmVydYJeQolR1gtXo24OsRu4rVYvvJL9mRxZ
	B7CsOaJs1kQucLDDf8EMLnW0CIgtA7txuL1hUSglm
X-Gm-Gg: Acq92OF5mYmFJBTZutvWBJFjYTXG6O8f3koTRtIzAhU9hKmm0QCOJbrHQxKMXhJsC/M
	mrG1pgJSKuG//a4GhSKrjFEEV9iIh99A223GN6DvOH+zh5YEVztENfQE78kx/OMKq058NsyRo4r
	rDnNHCLCddynY1ye00KAdFWJbh/oRKvGPsctLFGa/n3dEEp7RoE/ZYPyVuXBQ+bBxTY2/7rpOQK
	u6BfeROg/K6VCVCwPHrrcg13kehYPGFu7AVZF51rUKEo/mns0n/aG1OPnX7cesAt7orlipbRKZ8
	mMphLKPbvFzXQfvCpD5Skn4mGjdm1KbShgOoMsJGMESOsTdLpQ==
X-Received: by 2002:a05:7022:6184:b0:130:ac5d:8f69 with SMTP id
 a92af1059eb24-1318ea1fdd6mr9371056c88.30.1778492129711; Mon, 11 May 2026
 02:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260424132427.2703076-1-elver@google.com> <6f2bd63a-dc02-4631-a3a5-7ec8e58a4a4e@kernel.org>
 <afkOMIPu1WNFE9MS@elver.google.com> <CANpmjNM261J5qefMvmUXWZGBVz-KBs7GkbpdNMfTOvNJ-=LiZQ@mail.gmail.com>
 <afz7pZADZPD4mKJr@MacBook-Air.tail10959e.ts.net> <af3xcFjrZSZFG846@elver.google.com>
 <rz7dt4wghum6beghfgm6suqje6jeivrensojjalfis5zeuyen7@6bj7kfpqb4q5>
In-Reply-To: <rz7dt4wghum6beghfgm6suqje6jeivrensojjalfis5zeuyen7@6bj7kfpqb4q5>
From: Marco Elver <elver@google.com>
Date: Mon, 11 May 2026 11:34:53 +0200
X-Gm-Features: AVHnY4Kqj_o0gwegpds4LdAczqxNps8c5-uDjsqJAwkE704552pC9-_A9oEAMnQ
Message-ID: <CANpmjNNevjTo0uwo3DJdDc=PpQpyzj301kFT39OBoCNLW0A8VQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] slab: support for compiler-assisted type-based
 slab cache partitioning
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 09583A0007
X-Stat-Signature: fwrjrim1ipjawire5ayxdhgyu9afzmgi
X-HE-Tag: 1778492131-53423
X-HE-Meta: U2FsdGVkX19hOIFXEf3cThYj5ggqc+tkTHQxuno3VqYW3DpSjDdJL25J0Wtz1EU9+9r4aJhVHCNThpwmHG8K7U9IgxPjWMewLScv1b4Otj5dDYZZf4vkFOMXuMiJewowjQAG7sAIokbJGhv+Vg4bcMIdnHC4bzmiNIDkZ7eST9QSCbdMCX1RLKTGYjVmLqbc9Yv/bzCM9Ih5p572ekBKNzR504ItQe2gF4EeQHmqPPq5HvVbTxB4l5bxJB2UgGZW7QZo2nfo+Np1xiLisfCg6Xvou+iGo3Wjzb140s0i1VNQ+oeca6Ncf0gbJ2JPF9NI/LfDXj5UcCXU9tNmkmezx1qZn/5Mnu5/S6X11rU9sLWJNrnXdNSdP4XAFo3AP4dyzwBL/jZMeCn2ICbGapSdkNBedozNvHgVeRbvme9joyDHqDddUdapSUBnawXnYb3cV2v8jLiuieIJjZEZvBdL6r7mtiN6SdvnO63u9IXl+bG4x8TPmXrfAS46sEud1EI5+odaG0mn5sn1yg9sC59HrCoMeX7ewEbRFBAOwutjjc2H0YdIA856d+Cf6TL7REenYW1/vb1AoKQQ0wL5pL3o7RLtI7FMJ47d0LyRJHvHNwLRcatt4mAtd60uoWM4EG+BGJwg/vauiOvc2QNSinAYZ2GDbAkPLgrKSQe2xj/lsnC5TMMS2yGaJGWZ1NN4TAJJuzeQZe9bE2PoO3vU31TCHxvyjcEQ5JTLZ8RNb7R+79po7oVOLLeYklntxdkkyFGCbxqs3Qa/nws54abQ+9uyKGBxTHS7kxXM7C+tC+DbADS39Kkb6VdJPFOc9XHNhw2eNTIUkLCThOk9q570fPhH2UyktUJchc1A8Bp0GJGUk4I2ujGgabLerUvjjqtTcO2jEPQYQrxyT1uNMtQdis4J+iOWLvvnq4CQtiO9XUuUvIztWmbBUKleczF3GQtACXR7sHMAxHR6CXjyjX+hGjY
 1r8DqDkM
 4fiHRfb7cFX+MJ2dIFhJTCJmgBszly0ggRMvnfPy1LSsX0g7OTPNyOiXFi29R1J9tlSusdRWDmi8n55Y3yvWBU7b36Jsu4DivlnnQEJ3GHPWs1SC0gaa1wZQqBHNh2TJ6Pk0tWezcs1buuUMOryBL/y6J0umaSa+QKG+tsU5rHzOzj6uoGIdVXq9sQf8SZonkDws51qG63/7Q0dHKDKL12JlpQ//roHIw3GPOQ4rMRtXAuC3xNN0lybQGTPqoxTDyfG1gMG1riapVpADP1HE+Pl56aJ4KKiKCcmc/HrfgS7skdYme9sYvlxe/GO96C+ukUiPV9O/smqi6bCDeVaMBt9e/OUEPzxhWXTSIAlGTfhpJmxgITR2qf+BNA1xx/sdUvhubuElovbda+vAXtlv59IgvWcf8igJnXHcH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 at 10:31, 'Harry Yoo (Oracle)' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On Fri, May 08, 2026 at 04:21:36PM +0200, Marco Elver wrote:
> > I think I have a solution for this mess, see below.
> >
> > I would not send it as 1 series, but only include the slab changes (+
> > instruction_pointer.h change to introduce _CODE_LOCATION_) as one
> > series, to go through the slab tree. The rest of the patches would go to
> > respective arch maintainers.
>
> I'm assuming this will be a follow-up and reviewing patch 1
> (and waiting for Jon's thuoghts on patch 2)

I'll be sending v4 shortly.

> > diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
> > index aa0b3ffea935..dfe73aafddb8 100644
> > --- a/include/linux/instruction_pointer.h
> > +++ b/include/linux/instruction_pointer.h
> > @@ -8,6 +8,30 @@
> >
> >  #ifndef _THIS_IP_
> >  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> > +/*
> > + * The current generic definition of _THIS_IP_ is considered broken by GCC [1]
> > + * and Clang [2]. In particular, the address of a label is only expected to be
> > + * used with a computed goto.
> > + *
> > + *   [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
> > + *   [2] https://github.com/llvm/llvm-project/issues/138272
> > + *
> > + * Mark it as broken, so that appropriate fallback options can be implemented
> > + * for architectures that do not define their won _THIS_IP_.
> > + */
> > +#define HAS_BROKEN_THIS_IP
> > +#endif
>
> As long as _THIS_IP_ is broken on some arches, it cannot be used anyway
> when in a general API that can be used by arbitrary users?

It more or less works today, and for debugging or tracing it's "good
enough" in most cases.

The plan would be to phase out the generic _THIS_IP_ once all
architectures have a correct _THIS_IP_ implementation.

> Is it something that can be fixed in all arches over time?

Yes, I have patches for that.

> > +/*
> > + * _CODE_LOCATION_ provides a unique identifier for the current code location.
> > + * When _THIS_IP_ is broken (generic version), we fall back to a static marker
> > + * which guarantees uniqueness and resolves to a constant address at link time,
> > + * avoiding runtime overhead and compiler optimizations breaking it.
> > + */
> > +#ifdef HAS_BROKEN_THIS_IP
> > +#define _CODE_LOCATION_ ({ static const char __here; (unsigned long)&__here; })
>
> Nice!
>
> Yes, we don't really need the exact code location
> for partitioning kmalloc caches.
>
> IIRC lockdep does a similar thing to define lock classes (unique for
> each lock init location)
>
> > +#else
> > +#define _CODE_LOCATION_ _THIS_IP_
> >  #endif
>
> Probably we don't need this fallback?

x86-64 is the only arch that has working fast _THIS_IP_, and adding
static __here markers to bss is rather wasteful.

More architectures will be supporting _THIS_IP_ properly once I get to
send the patches. The mainstream architectures all have a reasonable
and fast way to get the current IP, so we don't need to waste bss
space there.

