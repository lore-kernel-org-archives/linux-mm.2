Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3D5606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XpiFpmIP
Received: by kanga.kvack.org (Postfix)
	id C7D596B08F1; Tue, 27 Oct 2026 17:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54626B08F3; Tue, 27 Oct 2026 17:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91916B08F4; Tue, 27 Oct 2026 17:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2FE6B08F1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:18:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAB5A120B42
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:18:46 +0000 (UTC)
X-FDA: 85369670652.21.1B79082
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 050F9180004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:18:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XpiFpmIP;
	spf=pass (imf06.hostedemail.com: domain of 3MxXhagYKCEAugcpleiqqing.eqonkpwz-oomxcem.qti@flex--seanjc.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3MxXhagYKCEAugcpleiqqing.eqonkpwz-oomxcem.qti@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793135925;
	b=MdlgLswAgnyu/bnBRiFet16nVB7hYwIjsholi60r77dwrEbexlvBo0ijoRmeXVntYVwBwn
	LTnI5Zw/m7TFzbMOH5bY6Vw/s90ujeT5Qo1AV625ORL7g/mw2fDbC1XIpp6SYc/ktUu1yz
	CPVJeoRfAWrjET2GoLnTdhdMesxBfB4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XpiFpmIP;
	spf=pass (imf06.hostedemail.com: domain of 3MxXhagYKCEAugcpleiqqing.eqonkpwz-oomxcem.qti@flex--seanjc.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3MxXhagYKCEAugcpleiqqing.eqonkpwz-oomxcem.qti@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793135925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
	b=IEiuxlKnwqARSM2Ei9OS1tWUlmiTr9fWhWPkrJSoHK73n33O6jQhlR26bfaRuo09tG8vl9
	rbSYhKnQfhK4drwva2o297/LGPIug2oopJCYcWSUFUoBD9/qpikp7pOh24pCmiSKOatB5l
	I53g7alOJc5mKL6qsC12AkqZvgWPz4I=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3adf71ee6a5so387613a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793135924; x=1793740724; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
        b=XpiFpmIPfQgnSg+W6ekkhV5Jzj8VprJQLK+Scdi2XipkRkv36WlQVMsR9OpfFc2T43
         LzAD0e/s5OYcnw9bmdj/J7C9kmv+gSSfvx+8AVCqtrRJOvMqrVbYIv/VlPT4ikzIKt94
         pQLhz9++qREVmTovlyG+Ag81SpkUBMH/+cqm0Hq5SDdpQTNI8TGT+qNx6u1QN7g/9YBa
         Z82iDwFT3DB3M/Nxa/6o5vODFCb+L/mAX44nsqUBfA4Ur3ICVu4IqyzabV3GtBjPwfvC
         IlOXvo+0KniI1kB8rW3nzCihllcAkuCK3nH3BkGqRUHy/vU6UooWuvE3Cw6sdREekB1p
         2Lew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135924; x=1793740724;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qUMx95Z2/FLv64tnydT/x/C4fd+wJMNdslwBEILinGo=;
        b=CX5+JYMfIZxqcQV3ZijoLgSDHECoPz1PwyCVWbmNeRvauDI28RTHRkWiVXWymRt5On
         27YADWo5bPqaS2wg9uCCsy9R6nEmdlE1nzzMcjQRrgCb9N/adx7V2Su52XkeJX451ZHU
         I2PkEZEDLJlzrKnIWA1FXgQgqyYJZLRa5Nh65P27gkmX7ELNO3URVSN8Pf4qXM3glFy7
         RQv1A7kkNjx4RvPVlClKOpQYGYnl+rw4CrcYVvrSgWAP0iGDgQHPW8wIvdyEkyHggTfE
         bgRQS4NsYNyeR0Z8BfAcrOELeo0+Cny+5Afv+ekzrC1lw9VCz56F0nsKK75nmfKheI2H
         6ckg==
X-Forwarded-Encrypted: i=1; AKwUvByhHbcQMk2rQ7FKYXpK5uFU4OTcky695QNDVUTi4gXFhQ146djNZbJNCSLdJbt0aFO6qYlqYru7Iw==@kvack.org
X-Gm-Message-State: AFq9FYKMHKFMCYg0smHMMSkMnGvTOVqkP3gFve1sjQTiHIHkaKOIsdU1
	5apUCXicXNnRAb+O+TN3gqdlZwWPWGEuWauXa64VODy4mB4g0GJ5Ha1pajaJPc6GxxzLHAEimnt
	5QJL6jw==
X-Received: from pjvv8.prod.google.com ([2002:a17:90b:5888:b0:3ad:850b:6f1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288a:b0:3ac:9706:7739
 with SMTP id 98e67ed59e1d1-3ae5819e5afmr211698a91.17.1793135923585; Tue, 27
 Oct 2026 14:18:43 -0700 (PDT)
Date: Tue, 27 Oct 2026 14:18:42 -0700
In-Reply-To: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com> <CADrL8HXQdzcroeGN-ACjyy-jSAdBNHiT1_BCVVe0P+Y8ZueiyA@mail.gmail.com>
 <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
Message-ID: <auEVMrMDqVuKtDqh@google.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
From: Sean Christopherson <seanjc@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 050F9180004
X-Stat-Signature: rru6dhd5uj1ptr8y8xjzge3ze9wgr1gi
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793135924-86051
X-HE-Meta: U2FsdGVkX19Nrc33FKWymHlexd7SHtRz9TeE6N0VNWxeMK2jKIc6QVKU4thD1aOhaAp+1f1l0BsqwvLWyRsGYqkEEgpA9cokeLYOHicuQ9RoeFJzdZuyZTqtVHFti7Ur4Rx9yHvu//1xyXvoq9WiHMnfamosINlHligYwm2bQhekwa+NeDhvzeH7ck8K3aAvT2s8xNNIASELP3ydRzzzD7x/nNj3ye6yu88koztw4kNewmnymus3V8sl+fQKuxKpC3KGyyP8SVlqKiwyRisd/rPRGWQpUxSGnCrS5Lq9nsc9izOOkpHsexeMD0rpe9doewD5sLpKyiP0WnoegNty4HCxmbBUHmanZ+kDOz22numt93KmX/9YVXp3Ad6YghXGSuJuUQ2R7HyJEKV8TAF0uwOZxfBCgXwVOklEtxlN1nHxpWivxhJNqBq76epqPZuUyBl0Hqg/r//q52LHOlQInPTbuV/Jaf/FfJ+hst8dejQDNXyHeCz7q8uOn7+C/3LJwyQh3S0GKUXQhMH6FXe5n01Oj54P3tLWc3ZTtfXg+2bQHojXYWRGbVs+Y+HnaCj4xQ+ExBUD3kA7rVpozE++yv/wKvaaw/SiWDw7Hpo1I5dHi0ZEjG/GMMN6Wt5SkPgVBjU4hgz4+Jo0sNr8thaK9hmv9wZXyv7Cn0nJVEJoG76QeFMxGNZgV5xBSxRsA6EkDI4tZ0BTu1Fj+/rRomH4+mdx4fJTo1sYEw+yEAjyx9j3j9swQkJN7VXQwbKBcdnC9v58PtrHLDv3jryc0rMo0YcVUHYXO5kVUsIsobJcJ8hz0YbZoYNLiM1gIiRTJtTdnKAxXmq5IWKGW9Qpwd0zOFxNfWyyfiA0odBv65ZKax7Cz1JkN+BiFk77oX92YeGziur10rStGhUMb3EWcXu3J+WDmyFxFqaKBH9/lp5fFphDZwCIfy1wzvj0k+L0wMCIzSR2eLl3t/At2RrHzQG
 sezvyGIS
 MvtRmPHU380VwwI7tyDuHkZI+VUOQhv5mEyN7oA9nGo8QAEjdr5x717iwAyHZuw/Vc6FgE3/uExZotdMhUKaMBTtW6W8+OceZ53a8sP5uIG5Y7HbVF1IZPm4y4WhY0n6JVaHJfa9xYZJcKSFWC6jI7lZjOI3V/OcDwFHfswvikkOywFi5NqmhqopWkeDo65fKv2gCd25qWiP5kTHO8QSmU7AA8TnGe1OSaX/mNXV6EJ1GJ7SGUnhXK99+xzuYYPZ+qCy4PISLv8WFDzs2xR8BaiMncUVeGGOhjvpMGyGL1YPhvsjYRLZSYPMh/xtfQu+swFk2m/FBbfA/fcF9zCzxXF2DMlGx4U0BYvWlTXI2gRrGxTmKI0Z880V7yY0FzEVf0+z5hm8OrJZvXDuFzPoA6GZ9FgLBYItcz6Wb+0r45a5/X8f4fICOODFoKZi7g2Knz8Pe1diEjrYNid3QNKZtBoOKRzdHGmTqRjNo/BFNADub66LVWpMxXu2OhpjZguTgWDCHhlqUOgemzQzzRiVLSzXolLCvRl2oEAbQVfGoCVRlPaTv8LmBLuco4S0HkYIYRWaU2+U/LaS27ON+IMp3pYniI3ltxnRZY5QGxDJa0rJDWWGD+fDV9VnvoPUiN7MdAZT4cVfh9twguzbRpm7qLY3r33yrj5XudtufBuJwlimDhcfVI9srV1XoYERrk9mr58dXD+fXPp7SKBbVMS3M1zagweDKIeMInJZR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026, Arnd Bergmann wrote:
> On Tue, Oct 27, 2026, at 18:29, James Houghton wrote:
> >> I would think that user_access_begin() is a more natural place
> >> for the added checks, as this should be called exactly once for
> >> any function that accesses user space and also stays out of the
> >> way of the copy_from_kernel_nofault() etc.
> >
> > user_access_begin() isn't used in a lot of places that I want to
> > catch, including the KVM case. Roughly:
> >
> >   kvm_write_guest_cached() --> __copy_to_user() --> raw_copy_to_user()
> >
> > There's no user_access_begin() in there. :/
> 
> Good point, yes. After the changes described in
> https://lwn.net/Articles/1102061/, I had assumed that all
> __copy_{from,to}_user() are going from common code, but it looks
> like the series so far only touches __{get,put}_user().
> 
> There are of course few enough of these left that I think
> we can consider doing the same thing here and turn them all
> into the checking version:
> 
> $ git grep -wl __copy_'\(from\|to\)'_user  drivers mm virt
> drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> drivers/gpu/drm/i915/i915_gem.c
> drivers/gpu/drm/i915/i915_query.c
> drivers/usb/gadget/udc/atmel_usba_udc.c
> drivers/vhost/scsi.c
> drivers/vhost/vhost.c
> mm/kasan/kasan_test_c.c
> virt/kvm/kvm_main.c
> 
> > I do think user_access_begin() should have the new check though, so
> > I've added it in the v2.
> 
> I had the details confused here. Seing that user_access_begin()
> and the other accessors always call access_ok() at some
> point, maybe that would be enough?:

It would help, but it wouldn't cover everything, e.g. KVM "caches" the access_ok()
checks well in advance of actually performing a user access.  I don't know that I
would fixate on KVM too much though, as KVM's memslots infrastructure that begets
that behavior is quite unique, i.e. it's unlikely other subsystems will have these
types of bugs *and* elide access_ok() checks at the time of access.  And KVM has
natural chokepoints for these accesses, so it's easy enough to harden KVM itself.

The counter-argument is that _if_ there are other subsystems that are caching
access_ok() checks, then those are probably the subsystems that are most likely
to mess this up and thus would benefit the most from common hardening.

> --- a/include/asm-generic/access_ok.h
> +++ b/include/asm-generic/access_ok.h
> @@ -33,6 +33,9 @@ static inline int __access_ok(const void __user *ptr, unsigned long size)
>         unsigned long limit = TASK_SIZE_MAX;
>         unsigned long addr = (unsigned long)ptr;
>  
> +       if (WARN_ONCE(!current->mm))
> +               return false;
> +
>         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
>             !IS_ENABLED(CONFIG_MMU))
>                 return true;
> 
> (plus the few extra copies of access_ok()/__access_ok())
> 
> As a quick fix I would probably start with just the 'if (!mm) return false'
> bit here to get something merged while we still discuss the other
> details.

