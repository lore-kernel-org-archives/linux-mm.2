Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F5010706CD
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 11:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30626B008A; Sat, 14 Mar 2026 07:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE78B6B008C; Sat, 14 Mar 2026 07:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13C86B0092; Sat, 14 Mar 2026 07:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BECC96B008A
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:22:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43F085B922
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:22:22 +0000 (UTC)
X-FDA: 84544430124.11.AA04565
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id A82D9140007
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:22:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iNhoMPPL;
	spf=pass (imf26.hostedemail.com: domain of 36kS1aQkKCJ07IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=36kS1aQkKCJ07IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773487340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIiENy5+TBc+Tmxykx8gjxVXJVl5L84CJZwFGK8GrzA=;
	b=e5qi0kfse2qH4uB6TU2mve7QRGUoftmqSw6ot9Ifo1a4wqTiu0KzwSnmKIQ87FPkHtWYuj
	+bCDWyXdOdmAhRDp9JG9tE0j97s9F/Y3I5b0uXWsoZbPH1lUWCQXR9BalO/zrSOM1pRb4U
	F+dkdYaOp+ZM6OxESHXy3p+KvDVgPvg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iNhoMPPL;
	spf=pass (imf26.hostedemail.com: domain of 36kS1aQkKCJ07IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=36kS1aQkKCJ07IF9BOVEIDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773487340; a=rsa-sha256;
	cv=none;
	b=hsDy06rdYYSu8PThWLyq7aLq7es9IQBSKn62q+FYSaQoqpXFOhI3+cqjVq6zRlCH9NnA7C
	tCl18xsbXuJ1gB5yGgFsrV0D4m+fKR/tnjmHupQOKcMEu5NehKlVFY4ec9YbcDB6C+ypKA
	XvdHmi6SKK0E62uaizvzh57YWIFfo+8=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439c794edd9so2806016f8f.3
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 04:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773487339; x=1774092139; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AIiENy5+TBc+Tmxykx8gjxVXJVl5L84CJZwFGK8GrzA=;
        b=iNhoMPPLhsQidoqnlSiwasw7xQDwEdiiygxwD2XVy92eyqoh3xyDfZ7yFW2SzmXl9Z
         kiltUxpH2sdiq0cqy71yLOfZvdldpTcsZ3+VSrJJzHY84Kmcn6SzwLz+NmTj8n7iXWhS
         6Dv0J+ND3AU68Z5VhE5XenhVvF7Gj67fn7TTQ9ofWlkT6LXp0o9oPn2mUByZmDQ76Z21
         Ig1IqnawhNmDaXRlvL8CNjzUa3ulA/5fU2aUsl1t7Nva742l4qdusB6jAiXpWRkJCfGx
         nikiZwdzhbtdOb8hwBNLCFrcuOJrgoB8V5kGZu7Rc859YXcG/HzTyRf/miODiO93vE7k
         d1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773487339; x=1774092139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AIiENy5+TBc+Tmxykx8gjxVXJVl5L84CJZwFGK8GrzA=;
        b=ngrBczJeka7AbhbOGo9fKS14pRV+tAulzXy4jdxr1HdIlJFiM46eLLm1ul/TEtvxi8
         wilX2UQncIboRl34WL2NtFqJKf7nUGIcPC27MVYohe2u+/MqFkkZAJFAfTe7+E04GXdc
         6IGy1KTPlhDNdOm/lDypKDcDuiufRmgAJntEV2Wf3AS6z3an5Mv67486f33JeYhAGkdL
         3mRPayiqsAQtuKhjAOa/BLOVch3pRdcq4D51uKd/VwC9gQYmfLWz56kNH1lA1R43gzQ5
         iTFsD7wPj/qVuGxXf0wRvdv7PpUpaY+uj4jn28JRbu9f4FIcLd0KYuIwjKLdASxY5DX0
         3sjg==
X-Forwarded-Encrypted: i=1; AJvYcCUzxqwN5OUA6/lkUF7XnwHlGlJtSUgG59e/3IN5x89Kxj4okPN0llWe5/5a+MBtPYwlc1/pbGutUQ==@kvack.org
X-Gm-Message-State: AOJu0YwqiNBX2tJjeWPeegMVWhlPEOIVwhmKKAU3Y8EcR2Qm7ukAr1QD
	1J/VIzW16DrCMZafVvb37QD79SJnzm4+OL13XidBnIYtjqNxp6UfvMWzdtbrpToSoPFQLgYvtNv
	nS1k0OKKCKuGKaocAnQ==
X-Received: from wrwo17.prod.google.com ([2002:a5d:6851:0:b0:439:cce8:91c8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1787:b0:439:c6d9:7fc with SMTP id ffacd0b85a97d-43a04d95261mr12535461f8f.25.1773487338756;
 Sat, 14 Mar 2026 04:22:18 -0700 (PDT)
Date: Sat, 14 Mar 2026 11:22:17 +0000
In-Reply-To: <20260314004012.GD534169@ax162>
Mime-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-3-beb8547a03c9@google.com> <aasPsbMEsX6iGUl8@google.com>
 <20260314004012.GD534169@ax162>
Message-ID: <abVE6VWCzZfyMEsu@google.com>
Subject: Re: [PATCH v2 3/3] build: rust: provide an option to inline C helpers
 into Rust
From: Alice Ryhl <aliceryhl@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A82D9140007
X-Stat-Signature: stk7s9zo9dt1q3fqdbi6mpq7ym7mo43j
X-Rspam-User: 
X-HE-Tag: 1773487340-517539
X-HE-Meta: U2FsdGVkX19K5kO5+SQ6i40GU/DAPs3xqLybYAs3MHyHWWmMqyS8PmBCxmn0Pn0knmYDWYnsMrUyvWB4zMOoyUOo407sr5kK49QHqZZ1JNFhiZAuat1sUL67GP4KtfRqWBjGYfacgamr2SA+g69em2YPyGYnvtrCfQD0IM+pl+q5z9zpvaEaZ9lmTBMhhh3at812poT2BX7Rkrgba+b/m+a+BW5IZEd5NPyyz9zGa3NKhdzoOUVd7+ERe5ji+4w2FDHbD4bKjMz+k2D7D7bZbmzoOqNNUv21QxPFzzXHeBQBeitUUoNzqD/Ds5/CTBl7Ok3DB2xYeGYSzaLr/M9q+D/4u26rtCmdIQifgqepsJtxOQdGEn9rlREwwwSHKO6SJu53fzU2psi/6RJzMBYRmCWZTNLBff+YFDUQH9IDUh8bKnRQKmk/HiNJAmlbol8foebdV+uF51K/cG42qhzYUV5j92adLqDIJ8rTpsSWy7ASwopnzZ5SyGbYtQY6EMFTN0SlomP0EqyBHLMuc4rk1/4bPGSNgh/Xnw9YBCil767nI9zGDu9skmYiC1npvqe1wxo+AdP68Na1AZW8q33ZmqG0oFZePSAxRCtAPdQYfUkqMOhXmLRyomQUGXioMQHzebSQkjgYg8DpPLHdS5goGLYSRM3E7eLCmRTYOfR7pUuHar8z0yf9Nyw3LyjkfZUKRvvH+zx64ls4+ez4nteL5VhyYnzmkRGkJbzu65txFrKqNFHWITAHA/vB1bzyBBmoYEkFk0v5ddyQUIpaTEJGoX0iyNqpetRGuAgqzvVQgQ/k3KKjeVSGGnp8q65sBx0ZTc+EzfbevbzseOTc6G8stO/hleZ7VYTM9rt5uWMpLaKA/1CSNcEzMqxc4EOtlE9mpCHqF+tKDzgTPiABF2pqtNiWBJUZETf/5FSOw5LZt8iKeKPEnARCe+P05DWzZGJ0F7JIG1ROVLAabSLergn
 voAb4QZ5
 4ulTTg6U9cFbwg4hANc9P1uPqaIP5u3R1Mf0ADNip6Z/cE0Sfa4A8sH7I3cpTMOI++YqhD8fyU98LWyDa0YDoxUAz8ytdf4ZrAeG668s4iaC3GIjsJyZByu0lVURaZmmXUX195Wwdk8Y66E6/gy6fQHxX9N1quaqmDFw+UsX5jGS0ZKi17cdnlXv8qteM4LtXN3lptxk8TinMMEYSAVeuS7blxOmMeKM/tB4IfJo4XWWMWFFYwrU/Mnk5LqeLVntXOf/7E1VzxA/M4jPNcxcqNzT//Vtu4KW9v+oqM7sNfuGTB2s3IdtpR4IhvRJiKfpGhDKPmCGhtuASEcJAWsMKosLJo9acIGxmX7XcA3lnW/8AtFRQ0H163WYR1D50I20ZaSotA4AXoNJo12I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 05:40:12PM -0700, Nathan Chancellor wrote:
> On Fri, Mar 06, 2026 at 05:32:33PM +0000, Alice Ryhl wrote:
> > On Tue, Feb 03, 2026 at 11:34:10AM +0000, Alice Ryhl wrote:
> > >  $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers/helpers.c FORCE
> > >  	$(call if_changed_dep,bindgen)
> > >  
> > > +quiet_cmd_rust_helper = HELPER  $@
> > > +      cmd_rust_helper = \
> > > +	$(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)) \
> > > +		-c -g0 $< $(if $(filter %_module.bc,$@),-DMODULE) -emit-llvm -o $@
> > > +
> > > +$(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: $(src)/helpers/helpers.c FORCE
> > > +	+$(call if_changed_dep,rust_helper)
> > 
> > I think this needs:
> > 
> > $(obj)/helpers/helpers.bc: private part-of-builtin := y
> > $(obj)/helpers/helpers_module.bc: private part-of-module := y
> > 
> > at least it seems to make a difference for AutoFDO.
> 
> Would
> 
>   $(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: private is-kernel-object := y
> 
> work as well? Presumably, this is because c_flags only has the AutoFDO
> flags when is-kernel-object is set, which is only true when
> helpers/helpers.o is a part of obj-y.

I assume so, but isn't it more correct to set part-of-builtin and
part-of-module? I don't see any make rules making use of those directly
(instead of is-kernel-object) right now, but if someone adds such uses,
then this could become wrong, right?

Alice

