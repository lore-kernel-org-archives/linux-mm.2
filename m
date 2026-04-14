Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B393F9D0EC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843A16B0088; Tue, 14 Apr 2026 13:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC7F6B0089; Tue, 14 Apr 2026 13:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DA46B0092; Tue, 14 Apr 2026 13:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEE46B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:46:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8081BE2D3B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:46:01 +0000 (UTC)
X-FDA: 84657889722.12.901475D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 11EF340002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:45:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LtjjuKkp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776188759; a=rsa-sha256;
	cv=none;
	b=y3p9NLIfGUeIBkCdAuIRF6SY3nmLustmRce04iZnSlyOOo6P3VLjcM39Ppn5yphxnLLMbN
	F6IEe56PlPANh1KXvIF7RDWULws3bZPDronoojE0i2KIj6L3KY8hMz6PshHQS3OucV/AwL
	ybvW5C6KBBJ6kCMgfuVIX4DQBfWZqHc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LtjjuKkp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776188759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mANt+MJIo4mwSuWx1hJyMYIsIgCq8OGnhUtWVmIQp40=;
	b=OSbPHQiJDQfgPENqSM9guQM/PSv4rwsvtbm093ulJZBmnmOXfcXC1B1EJwcq2O9/azNdki
	6Vj/Np0iYgcMZL1nujbLRqPbErT+Fqpo1bjyMUmniBFAETaywmrMFZ8kJ1Ibr4dUJ9lW4Y
	1IJYxC9rVJitLsbEcuiJ9wd40luqnHQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776188758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mANt+MJIo4mwSuWx1hJyMYIsIgCq8OGnhUtWVmIQp40=;
	b=LtjjuKkptrqLO35z7yX4D7bxxptZCYMXeqFXHpSQlA1o6T67bsCesEeY4/PUoVEXmeOvIZ
	mUFICxbSgIrBQ9IOxg/ZOgB9RxNuYfmaBdZNFU9tgfcSdDERe401nwRY3yCcmHEyJ4rdi3
	Mp4NNdaPsPqv/00aR5K/Uil14zNWoaM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-bu9unZPKOrCrehYtgW9p1g-1; Tue, 14 Apr 2026 13:45:55 -0400
X-MC-Unique: bu9unZPKOrCrehYtgW9p1g-1
X-Mimecast-MFC-AGG-ID: bu9unZPKOrCrehYtgW9p1g_1776188755
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50b4987c698so157259251cf.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776188755; x=1776793555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mANt+MJIo4mwSuWx1hJyMYIsIgCq8OGnhUtWVmIQp40=;
        b=gnsqlWikHJ+L0vDGe1ffoTymdhMMIBt7RJuprewdx7rzKFLgDsTdR7AFBmJRBGJoqb
         hxaKt7yKudwAY7lWfIevzz0k6yn3hiaDyddOro/4D1Je2e705a8Za+U6YeLuehf7TIVj
         KVk9xiEkiAWtYJHRw7XHaO99IkJPPh1pazBl9lcBwYmlnLCwgbl0TiKj+7/MUEpiNn+O
         NZyxErgx5u+5O5OtgQNJcragqQKJZ1MACGzH/hbSPdJi83fAoFiObtrislCkxgaM9eT4
         Ec1zZjrysacsQhQSP+q1vGzHLxNZ94XAVr0roavLs9fFgAvFyXVhFvkz/68ElZCGMfGU
         SXfg==
X-Forwarded-Encrypted: i=1; AFNElJ82NzvoPaU7m01BaVc6N6JszbihiQB7Q4Pz4ahj+P6hHw6RYmRgteSLGb/EAGcqUbsH+tYFbMe+JA==@kvack.org
X-Gm-Message-State: AOJu0YxJw8DS8uNKPfUkIFA767g9PKeHGOOddf4HhvbtGdwNNxSpsbJf
	ER0Nu8Zy7FWonLR/n/biPw3ry3jNF0cxNktczY38M0M960LUnUXRXebLglRVCr1B5AXPQwlFZx3
	UhfzbhQjMA8NWJ5SkxYcjc7TdynTjc2vfazvDsvvAkDZjRZZWn1tv
X-Gm-Gg: AeBDiesbjaSeIMJfxxSF1YuN0KqZHngVfkyoO48LKPikLGQocb/Wbz8TySrwW+N/Rr5
	AMwSX+cvueRax8TrNoPSDGFDBBtiDAX6OiopXib/1aNxZIL5uxZ7e6AnEZrJabeV2/td4ScBvJa
	Hb0DrHKIn9P1qn8mAZLWZo37Or03FI7CJY9NAqG05jBPvUTA51QdiSxyI2rs/fr6VZeXY6F+fr5
	Ad2OQgDb5RHSIJnwhhlcIwweOz4KlfIP0q39Yc2Z++779eXfPNv32bwtAwbZIbY94vgT3lSM01g
	Ck70uHP0UanmGIuNyzVH0gheYNQt9rnC+53SkY4+2Oz+j6aIFGp12rKnw3r8qgBwxufmvm+9SBS
	2TL+24497bEsv97+lBirJEMRpI+6Det7V8ELVRQka/PDQ5CzvzYwythaPqA==
X-Received: by 2002:a05:622a:5c98:b0:509:11bd:9d3 with SMTP id d75a77b69052e-50dd6a6a478mr232486131cf.1.1776188755081;
        Tue, 14 Apr 2026 10:45:55 -0700 (PDT)
X-Received: by 2002:a05:622a:5c98:b0:509:11bd:9d3 with SMTP id d75a77b69052e-50dd6a6a478mr232485641cf.1.1776188754505;
        Tue, 14 Apr 2026 10:45:54 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50dd53f9c16sm110767131cf.11.2026.04.14.10.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 10:45:53 -0700 (PDT)
Date: Tue, 14 Apr 2026 13:45:51 -0400
From: Peter Xu <peterx@redhat.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <ad59TxAHNwFWH7Cc@x1.local>
References: <20260414142354.1465950-1-kas@kernel.org>
 <ad5dIUpAMs4MuBvV@x1.local>
 <ad5hAVuRwa_0VNPf@thinkstation>
MIME-Version: 1.0
In-Reply-To: <ad5hAVuRwa_0VNPf@thinkstation>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9yBtuKwb7b89RonwkCgCMViRXLEVQUIjWAueIKKeXkE_1776188755
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 11EF340002
X-Stat-Signature: 7izbizo5b1um343tertpsoqhozs547m1
X-Rspam-User: 
X-HE-Tag: 1776188758-545275
X-HE-Meta: U2FsdGVkX1+WRexxvM/zEZ/yXRZOUVRPvhmAubk1zql87nBhcks2oe5Uyx0bCeU7Akvq4BX0RjvbZg0BfpcJFlFL+KE1EoZx/f30deymSoVYj8WcttWOiv9W6kqFPcK7/8zKbLwkPdul4jmwzntKhySyPxHvheTSAnx+JK0DyBePObSJIyBYtLpMtdzK5gW6nTexXdYd3VfJIH8bTjNC+iihUf+Yq/cUZC+1tjKVgk8NYwpLZFwW1WPqoKlIBkWowXhlkFjOS3UoFQTeuotOZNcOmO5YRnaoXl660lek5vZjKIxQwd0mYshU5sZnOcsH/eenyRB+TDltgX4xgEJsB586SQvpMr50LDZC6RIr7j3Ow0/dPDUF4FncRjGqP7OQtTg06vv55y7/NtAX2EBEPDlAniLZrFfO8iTItoI+s047Uz6Fkx7du0Iad4902v1/ozJmm40kWXX8M86+Z2fC7tqWEG2qU47zCIi9EoO1a36T99pWTjWACuDBCdWMUDq+XNyHyW1hVFcbYJ8wq+yetjUIps8/tYZ3XVPFYb+gGewnECwPn5LeYYUcUIbIX+toaWPNIzS9FUFrQ04KsIy6zObdBpuF+Bu2kQTzWaz2OGZ1DtXtwtESfeWVihEqSkJILqGzZ3II4b1klKm/hNCJBn0GBrXbHvBA+1bUgQuk4Tq7x3zttKYGEOro59WKxV1JY63Krb9B3M6VBdY/ZaCAJqLh4vCQUKQlScyCXQa1X8TDUWrs+RMD5c0MNebZaW9pYHU+Xcc6qzRRXxbWLxTQPrqolTxqy+C8lZT/c1YFmhdq/VFcfulNQfMchDYQJQNpX5Z/43g+zg3cI46pjUvmoTk6RWCH71wtATy3OqUN7vpP/WEua4lnlUmwaKI4Yboms8eHrAoPIiW3PbUVUMszRf50wH0IYgRrCtdIoN0cyoxv+x9qS3VjeoNifkY9FnCfPryqpInX02mCstHRQXe
 yZatPG6W
 azGXLIY40vzdaX21dX5/VPEHc29svv4WAVqkIMt/2NNBczZr5L5TD9/QsoMqJUX4vPdo7oSo8ZtzEbNsuwask6EeHJW7C2E+iO632m0h3enReAy05mn3jkpVYnqZsMf+S72bg2pqSaokALRMeEDcbxmmXx7s5l1561JhU1qA9gK1wQ1OlaFdLGZgslUynjG/6sZZVhxKCsWq5HvL46VQPgVklZeWKawPgJV+kblhfqhN+DD+FR1VzgWXW0PedarN/qw3m3683DUNAO4KueHfL4xuXzmoRcP+gaSCzhbilE7ptzNIJOswAUYjYYTHnmF0TWeFz/BqVKZwfcMYbs6aStNdkR/LtS/Z/t1vXgAKd/uE8nw7l00cd5iF5UHNEM1bdJgo1r3M/qpnk4oGIo7LyAMKDV/Muoc9XarNCz0IHHGPqW/fMfcSvpXxU2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 06:08:48PM +0100, Kiryl Shutsemau wrote:
> On Tue, Apr 14, 2026 at 11:28:33AM -0400, Peter Xu wrote:
> > Hi, Kiryl,
> > 
> > On Tue, Apr 14, 2026 at 03:23:34PM +0100, Kiryl Shutsemau (Meta) wrote:
> > > This series adds userfaultfd support for tracking the working set of
> > > VM guest memory, enabling VMMs to identify cold pages and evict them
> > > to tiered or remote storage.
> > 
> > Thanks for sharing this work, it looks very interesting to me.
> > 
> > Personally I am also looking at some kind of VMM memtiering issues.  I'm
> > not sure if you saw my lsfmm proposal, it mentioned the challenge we're
> > facing, it's slightly different but still a bit relevant:
> > 
> > https://lore.kernel.org/all/aYuad2k75iD9bnBE@x1.local/
> 
> Thanks will read up. I didn't follow userfultfd work until recently.

Thanks.  Note that the proposal doesn't have much with userfaultfd.  You'll
see when you start reading.

> 
> > Unfortunately, that proposal was rejected upstream.
> 
> Sorry about that. We can chat about in hall track, if you are there :)

I won't be there (as it's rejected.. hence not invited).  But I'm always
happy to discuss on this topic on the list or elsewhere.  Alone the way I
believe it'll also help us to know what is the most acceptable path
forward as it's still very relevant.

> 
> > > == VMM Workflow ==
> > 
> > AFAIU, this workflow provides two functionalities:
> > 
> > > 
> > >     UFFDIO_DEACTIVATE(all)            -- async, no vCPU stalls
> > >     sleep(interval)
> > >     PAGEMAP_SCAN                      -- find cold pages
> > 
> > Until here it's only about page hotness tracking.  I am curious whether you
> > evaluated idle page tracking.  Is it because of perf overheads on rmap?
> 
> I didn't gave idle page tracking much thought. I needed uffd faults to
> serialize reclaim against memory accesses. If use it for one thing we
> can as well try to use it for tracking as well. And it seems to be
> fitting together nicely with sync/async mode flipping.

Yes, I get your point.

It's just that it'll still partly done what access bit has already been
doing for mm core in general on tracking hotness.  So I wonder if we should
still try to see if we can separate the two problems.

One other quick thought is maybe we could also report hotness from kernel
directly rather than relying on async faults, you can refer to "(2) Hotness
Information API" in my above proposal.  Here when it's only about knowing
which page is less frequently used, it's only a READ interface.

> 
> > To
> > me, your solution (until here.. on the hotness sampling) reads more like a
> > more efficient way to do idle page tracking but only per-mm, not per-folio.
> > 
> > That will also be something I would like to benefit if QEMU will decide to
> > do full userspace swap.  I think that's our last resort, I'll likely start
> > with something that makes QEMU work together with Linux on swapping
> > (e.g. we're happy to make MGLRU or any reclaim logic that Linux mm
> > currently uses, as long as efficient) then QEMU only cares about the rest,
> > which is what the migration problem is about.
> > 
> > The other issue about idle page tracking to us is, I believe MGLRU
> > currently doesn't work well with it (due to ignoring IDLE bits) where the
> > old LRU algo works.  I'm not sure how much you evaluated above, so it'll be
> > great to share from that perspective too.  I also mentioned some of these
> > challenges in the lsfmm proposal link above.
> > 
> > >     UFFDIO_SET_MODE(sync)             -- block faults for eviction
> > >     pwrite + MADV_DONTNEED cold pages -- safe, faults block
> > >     UFFDIO_SET_MODE(async)            -- resume tracking
> > 
> > These operations are the 2nd function.  It's, IMHO, a full userspace swap
> > system based on userfaultfd.
> 
> Right. And we want to decide where to put cold pages from userspace. 
> 
> > Have you thought about directly relying on userfaultfd-wp to do this work?
> > The relevant question is, why do we need to block guest reads on pages
> > being evicted by the userapp?  Can we still allow that to happen, which
> > seems to be more efficient?  IIUC, only writes / updates matters in such
> > swap system.
> 
> But we do care about about read accesses. We don't want to swap out
> pages that got read-touched. And we cannot in practice switch to WP mode

This is a good point.

When it's considered on top of your above "async trapping to collect
hotness with userfaultfd" idea, it flows naturally with this idea indeed.

However, IMHO that should really be an extremely small window, and the
major part the userapp should rely on is the larger window sampling
whether, in your current case, PROT_NONE (or PTE_NONE for shmem) switched
back to a accessable PTE.

It means using RW protection v.s. WR-ONLY protection will only differ very
slightly if by accident some page got read-only during evicting.  For
example, if the mgmt app monitors PROT_NONE state for 30 seconds, make a
decision to evict, evicting takes 5ms, then within 5ms someone read the
page.  It means it only misses the 5ms/30sec access pattern of guest.

So far I don't yet know if this would justify a new kernel API just for
that small false postive reporting some page is cold but actually it's hot.
To me it's still fine to consider using WP-ONLY and just allow that trivial
window to get refaulted later, because it shouldn't be the majority.

> after PAGEMAP_SCAN: it would require a lot of UFFDIO_WRITEPROTECT calls
> with TLB flushing each.

This is indeed a concern, maybe a bigger one.  I don't know how much
benefit we can get from avoiding one extra TLB flush when evicting.  IMHO
some numbers might be more than great to justify this part.

While at this, I do have a pure question that is relevant on the full
protection scheme (and it can be naive; please bare with me on not yet
reading the whole series): if you change anon mappings to PROT_NONE in
pgtables, then how do the mgmt app reads this page before dumping it to
anywhere? It's not like shmem where you can have a separate mapping.

Do you need to fork(), for example?

> 
> With my approach switching tracking and reclaiming is single bit flip
> under mmap lock.
> 
> > Also, I'm not sure if you're aware of LLNL's umap library:
> > 
> > https://github.com/llnl/umap
> > 
> > That implemnted the swap system using userfaultfd wr-protect mode only, so
> > no new kernel API needed.
> 
> Will look into it. Thanks.

Thanks,

-- 
Peter Xu


