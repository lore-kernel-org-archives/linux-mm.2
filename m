Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533F6C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503546B008C; Tue, 11 Aug 2026 09:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B32A6B0092; Tue, 11 Aug 2026 09:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A57A6B0093; Tue, 11 Aug 2026 09:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAB296B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:55:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E0BB160460
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:55:41 +0000 (UTC)
X-FDA: 85089136482.24.4964B2C
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 93D3D80012
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:55:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fwvYGHVT;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786456539;
	b=FTTfVcitEY6+Z8Bub+EjyCKZQHCq22YebwIML59rMx/5GoQf5ivYCBHlZtHBKxAnKRdHxz
	X/n9U7/5tMNumvfxmkHV9AgCbV8VsPOuMGMP9JLNRnOZklMkWGitSVBQ07wqhYsPtUtLhO
	+A6KoNTYtTPouodTFU6UgqO1X9I0ryc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fwvYGHVT;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786456539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xauE7W5wOY3LNWuplU4mgV1n8xBkZN1XfpHr0f+D+b0=;
	b=dZipTvGqnU3LepiuLYQgX2cm1CMSUgmcHNkdYDXLdZ4C1Oo97GptNBYsV20EHLDuTigMqW
	q7jujtfsNfk5Q4NkFXY4vGsurW2V22sEr/X/rKe2RFd89MR3eij1ZkeJsjBwAAeXqejw5m
	L3+I5whMAa4b4DWsO30OCXfVL8uCkrU=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c1372f84dso19792331cf.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786456539; x=1787061339; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xauE7W5wOY3LNWuplU4mgV1n8xBkZN1XfpHr0f+D+b0=;
        b=fwvYGHVT+Pscu2P61HB3Bv93jxKoSs7Yj6Y6ojqXpFHW+rkezmOaviQvHRiz0QEeQc
         PsmFnZzEHLUEF4rl0OFJsNDl62v+85q7hvbAwteGDgwyt9kfRnTECrNz8DkgO2xB64cB
         3ksv5/R9g6cSKpRkD2261rmqekbb3qTamoP9fhB2Ra3lEAtwunQsiu6n1uyHgY7jgUTG
         HxxSsssNzmxOxwCfgKoiZ1WlKKK+DpzmK741aDPc0QJk4CiQ+Uj5iGUu/RQgkE1DNEQ3
         FriRV3jOdj01s1Gx8gj++NwRNLKuv66RMeQwFbQmLE9ed3veSUlUQzTUY0XnF/sGSgGx
         JwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786456539; x=1787061339;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xauE7W5wOY3LNWuplU4mgV1n8xBkZN1XfpHr0f+D+b0=;
        b=lIOLytYLKvJUrkpUvh420mM8wJMXpT1ug/6zvbOn2ZRVZUEcMEi4kmp5Cxw1R4bliA
         NH9NEzDwKQQYjhkQBLxJOYm9kzwDVrYDX/xa+SCxOMoMVOTpIdvrTf/uS9cEp2rwmZab
         5qyTBJOdIj7jM/aWrIIrRjXTQoDt0og9n7vqnstC7eVxV8oN8ic9Twdxp8ZGM+O3IkdO
         J4fcdaJFvsi2oAmDErK9X/rxsJ90kO7BH7uAEX8lFITmjB0FHlLHdLgPjdFFNgCfcTY7
         ztT09nW3XiW0JnWBFCwTcFOIg7J/Q+R8GdhJS1lW6dFEQJaQni7lf680dD4sOyV9E8of
         NAXw==
X-Forwarded-Encrypted: i=1; AHgh+RoHldPp+OyMZLnkaYiIszRwV4lDiRVSLp54Aik06AWlD3efLSRk3rq0I3u8lFFFUt0l4Fx7tVKmWg==@kvack.org
X-Gm-Message-State: AOJu0Yw5mutMDYUauQQIuGC3ml3t3FPIKicKD+WYhUoTSftFgmTNQdQ0
	HT2D+fXu21/aXxUACVhSiq815K1Ng4u5EDbHBz3AFBup5vxK9iUISPlR1LR40MeQk4k=
X-Gm-Gg: AR+sD12dpG70OvikoTYwlxqXZS+2+3Jyz1yOvyJtjWcb90iDrAbe8DHGjroiDL2jIlH
	55kiRcG0+m3fT1ihcQbaIvN7gXxMH7PaMSciehLbJb7cTf+61CDkJ0297HQp9ShiPtS+eVY77eH
	uld160VEo9/R6rwdaxXXGlQGBCbD2hGm0x4EBldL1kjDc67czsbmXaDFnjaK/L2ncMuUC2ClH++
	C9RwolsufcxV7qP5FcaYReeRr2IskbqNWYr9eWIVvLoXf7F6k/+NhZQMT/bpu8Rnegt9y1Lq815
	JHYSiX6+0VVCsXPugQe7io8AyUmh2iDT+F1gXw2CH8lIejON7eS3DyYr9i7VQrxgZbPTkqij5Bb
	Iz8OWRqW00gn67ab9SGu1psUwdCMR9UG6Q7xYxO4iNJcPtSsNcSI/hRs3I5r+IWDe4v0P9OQyVm
	dWlLT+aowzcbgR1DGzcLmYR9vT6lFZ+md5RGDaMg==
X-Received: by 2002:ac8:5cc5:0:b0:51c:963:cafc with SMTP id d75a77b69052e-52d5867f904mr29812841cf.41.1786456538732;
        Tue, 11 Aug 2026 06:55:38 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d57c749aesm11606881cf.31.2026.08.11.06.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 06:55:37 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtmx7-00000002UhD-1Ab6;
	Tue, 11 Aug 2026 10:55:37 -0300
Date: Tue, 11 Aug 2026 10:55:37 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260811135537.GC544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 93D3D80012
X-Stat-Signature: asmhnyji1y6jcbqhfg5nj8sgca5hqguo
X-Rspam-User: 
X-HE-Tag: 1786456539-275128
X-HE-Meta: U2FsdGVkX1+O5qwE4s1gAovgmObp0yjlZDUu67l8PlEg2WGu1giXvjqMxSMEzzpjP8ezRUT5xw8EYDtWvOLsbgqNiJMfuIkS5v/7NnNks9QC8V0dfReJnO6Joz3CCyJDSEOVtSJbCg7Cf+I8UC3zKPHqvQj0/pbe+9cDwvIJaDiGOYuI1LbQuWvjFb3IM89bthTdsHLGUZUwQhplTSpNTMRAjqxcRPArSntC2ygHMD+ni3BZe/Z1Z/lJTQ17JWYMTb8jsn3T4xdrXosHHO09ps0sGpL7KcpFRZCkHdjhb0/m0lEnHyPSXyPD2MNlZJoCDKB78/K/WVyMy+6LR614Wsl4OCQf1QrHqZRrsCjPAAE6pSShjLvdWZ08akMzUsHUPQ57sGQaRZAsoaosdTwMa0qJTt3AXpWpUFsR3hwR6lbhg8VCBp7Jt3Zt1vrRNZ0yZ/D7SVrfyZz6aKH3hdjGIgYa57A0i7Ho3bzH3nBQCmEAJg8qPk/tAswATyOfU+ssBrGUFRcMumf2wQrKyxn8Lmm4DxeduhP38uKnvHkMtrR/soqLJggmJqZxe0Eiack01jiI6AmiStOLDGn+naJMRz5+du+hKkUAkMCuNhA2Mef/ETcbfMP1q1tHu2dg5Z0a4XVsNANLFexZ3w7huhEjq42A3xSgaqX3xgqE10ReSUA9hJiIf2eTw5461sLXUXrvZuX/A3IE6pKHD7hbR9SZRPEkEqj6cWF8MipnuMxs+8A1jl6iZxGsD3KRWqQBvWe1YDFY6KJ9xUzANoSlEeygru91IUOy5m8j0/pkpeW6m6i7Lrx3BCEra2aKR6H8L29ivCKxJPWpfTd2C2dvibXpbR1XMcXBvDSpFWpokTR4Qh6cCWC4S0TP6rP8R8AwJbOCjSx1Z3MeBiYR6jBCh5IXc0ckjkxAQOYw2I3ALKDzmSaCJ0d6ayNdlyGYzqzOc9v6uRHircxGLxyI/yU7Vqv
 NhWEEJx5
 jNGIAmWotpSe2GZWrSyytiZo/5X+ioM9vI5flOqnOenhr73wFzQVXzqOXXWnVSA6ABmtAa73YeIlnPXXCdJW3XFQioqvgHygA72lWIR9q6JTjA3WKnOXePIBwHbvBxrHgCIZJ4vkmlFkzPAuqaIAzVuy4+xVWVAlD8QNOOQGJGsLSzfJHD16wJq/e8o1BLwF9NV4tJNqmyQ5du8v3FLmL3CuK3wsuIZCIpM3vHaT2MwO6yU9oNK7QEQrQ84dvDp2QwfTJY4RhtAj6iQo+6awel9evs6mNUkQBX0V+DxaQo3Lnapvk6Li25ses5EyBERXdeyx4cCC8wNmRHlc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 09:58:44AM +0100, David Woodhouse wrote:
> As Michal Hocko put it when the
> annotation was first proposed (quoted in commit 312364f3534c
> ("kernel.h: Add non_block_start/end()")), the OOM reaper "shouldn't
> depend on any locks or sleepable conditionals" and checking for
> sleepable context was "the best thing we could come up with that would
> describe these demands at least partially". 

Sure, but we translated this into the notifier must run in an atomic
context and everyone has been happy with this.

> That distinction now matters in both directions:
> 
>  - On PREEMPT_RT, spinning locks become sleeping locks, and perfectly
>    legitimate spinlock/rwlock usage in notifier implementations (e.g.
>    KVM's mn_invalidate_lock and gfn_to_pfn_cache locks) triggers the
>    splat despite having no allocator dependency whatsoever. This is
>    reproducible today on a PREEMPT_RT kernel: KVM takes
>    kvm->mn_invalidate_lock in kvm_mmu_notifier_invalidate_range_start(),
>    and if the OOM reaper reaps a KVM process the result is a "BUG:
>    sleeping function called from invalid context" from
>    rt_spin_lock().

I don't know anything about PREEEMPT_RT, but this seems like an issue
with RT if a traditionally atomic safe functions are now triggering
might sleep failures?

>  - A notifier implementation may legitimately need to wait for an RCU
>    grace period before allowing the caller to proceed with unmapping

That's not allowed. We really want to forbid that, it is not an
acceptable way to implement a driver using these APIs due to
performance.

Maybe change this to #ifdef it around PREEMPT_RT.

Jason

