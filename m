Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8748C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976586B009D; Thu,  6 Aug 2026 15:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FFEB6B009F; Thu,  6 Aug 2026 15:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8556B00A3; Thu,  6 Aug 2026 15:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51EDC6B009D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:21:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBE7B1601AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:21:19 +0000 (UTC)
X-FDA: 85071813078.13.55E98CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1824A40015
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:21:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dvwwpvhI;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786044078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqBkOHdmSbNw3BiGir7LVReVfGTE5RkU8HN/8SqdD8g=;
	b=QbZFE2lCSqppIz7c4zAf4xUgDrM2l/4pKK+K1LEAIcDn/srK+tbrPBhnRASceONfnO15iH
	bIxXUMg+QwxWjLFzEkgpLxj1QW5g5gGSNWAzDzOtx0m1oEBgqiFnJN/0kUxZ2LY1WKr9i9
	SZ5pJ4GdNnL4Dcsn/Fc8rmybocWx4K8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dvwwpvhI;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786044078;
	b=WKqDZRKwPxuEsaT1/ikOmqciXjPGwU5Lp9r/A3ytl33n+yGm5I11pCpavVCwHGAx8TeHT5
	qo9h3VAIDZULCJ006asw3VFhytH0TXIeSR6F8AfeiqDjFnlBQcoom9xsMaS7Ca1KS6q3cE
	iavHcRmhzrc8Mtv1UoV9gsb3o6yPCoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67381409AD;
	Thu,  6 Aug 2026 19:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD8C1F000E9;
	Thu,  6 Aug 2026 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786044076;
	bh=yqBkOHdmSbNw3BiGir7LVReVfGTE5RkU8HN/8SqdD8g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dvwwpvhItmXXrDc+qw6UfX4yhZ9ob0lyXGI8vfSCAUmiQesp88b57y7TxqS+DQdDR
	 68SGrqYvdLD35KMkVYYsXHcMFMzkVpGL7AwiYALGfcmA+EM3ZU1TUwZ9a3X2zk3d5f
	 GxnhHE96A6Dk1oM/+cUXcQt/je3DLlDuaqKk7CY8=
Date: Thu, 6 Aug 2026 12:21:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Ackerley Tng <ackerleytng@google.com>, Sean
 Christopherson <seanjc@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/gup: factor out LRU cache draining for folio into
 lru_cache_drain_for_folio()
Message-Id: <20260806122115.1bde36d4885803a6c370880a@linux-foundation.org>
In-Reply-To: <20260806-lru_cache_drain_for_folio-v1-1-c6287d295e99@kernel.org>
References: <20260806-lru_cache_drain_for_folio-v1-1-c6287d295e99@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 53gy87nrxo6qqyoom8ic4zmjhe9fqota
X-Rspamd-Queue-Id: 1824A40015
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786044077-802706
X-HE-Meta: U2FsdGVkX19ji4mFLtUAt+4DmdhdA9ziNw1vNX+bS2kSEIIf2aU3OAI04GrKoM1skuP17sbM2ch3A9DoN9Toe85SfnsZL/Cc/2thp3lQIbPb8vG4uhJsolVD88Ds4DFUAfUa/6utBtEjwP49FOipGaPObBT+3k0LvhWN43Jh/AxIwkHkTs2CPzxqMdHzI+7rSWygoJIcCZfALgM6OCltwDoNA2aNRkIw8dZaniFtTTyVC6iLzmlTcqlUprpw3Ak38bLtlzMQzD810HK9mY90rwM1skpXqE6CBrKOUEovf/64wqt+xkyNIlcOlfYh2dHQu8hAvsWwPUgNXLo6kcm8Tng0Pwnj2yIIDPVQyK4MOeSpVGuZf9loETdj/ODkBPmJt5FEeq09/Pyo7NJYDKc64P/OiNaQmRdl47/eVVLsprxj7tLbQH6GgxAfunkdnE/TrTxe5MatR0rGbo/zWf/F673JEaKsmapj5SoXveow/RqKGTYBmEdE4IHYpMfvnOpYSIq2hHFHM2J3iBy5L/T/j8YejuAUif9EVjffG64gMSyf+4MY3IfzqL0spDJtVtnsspLEaexOyJabjov1ekB0xNp0cNGxfMRHy5xhTT8nKeaFUN2aSdKvjPgYi0zqhHFvQYEiT+JDVZ/NkOgniVSpk89xfEBvQoK8Ym0lPfAThKIZYLt7tA0UDP2uKkVj+9ZefMkeEcCIzdeWh6N/EPdfr2w3kwmhtbej1nMIzUTvtlQcxeyDLhhH1M59M0dD8eOfgnm5jgEfnd5G/I2YdNZGrpyHOfdssJRE8rjuo7i6bvl1PZb2jtJ5Pn+nO2NjFgH0V8sZ3v4jNpCGqo4BgA4JS1a/dL4Isdwlh5O+Vg5wh7uh2PWWecncmBVbuhrbm5MJVqdyEJ3HEicKQYH4ct1yLCBq6PvwK2waz/StZApcgJuO514zpEGMtlJPgOlLAGwatPLXMshE4ATN6WfXABF
 oYCNCH27
 abAv6wO+KgU9xoZsxPXToH0Qi7w2kM1eca0f0ci5VqPwJ0H40NALbNReTrYpGQFqzXh9qg6mVPphwdbcyTSMuJd2qXxNEMcMjhGXjw/olxS8fxL44OI3atwV36cBqi1133ZfClietGh/jP5ih7Q2z1ds7c71sAWhqYyTJ5eWk/7d6oWml78mu9rmnUNS21JZEEENN2djpWNOAFoo16E9xtLYfr7vNVneFvirg/i48Af/RaMZhzZKuo6G2WOw6s86spVtvCTUru3XRjYIXdujhYvBhMfdytKMCyV7ar4RcNFLcZ9S70HkmCNqhVR3fTbeEYyNWArj7w4iqw83QIlYr7xIJ4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 06 Aug 2026 20:09:06 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> KVM with guest_memfd wants to remove any folio references due to LRU
> caches, as it really must only allow to convert folios from shared to
> private when there are no unexpected folio references (e.g., from GUP
> references).
> 
> So, to drive the refcount down, it needs a way to flush the LRU caches.
> Let's factor out what we have in lru_cache_drain_for_folio(). Document
> it, and also mention that concurrent folio (un)mapping might, in theory,
> miss detecting LRU cache references. Keep obtaining the expected refcount
> twice to minimize the possibility. For the current and future user that
> should work, and we don't really have a better alternative: we could
> detect if the mapcount changed, but it would still be racy and add more
> complexity with questionable benefit.
> 
> Maybe there is a chance to avoid the draining entirely in the future,
> by avoiding extra references from the LRU cache: Hugh thinks there might
> be a way. But for the time being, this handling is unfortunately
> required.
> 
> Make folio_may_be_lru_cached() accept a const pointer so
> lru_cache_drain_for_folio() can accept a const pointer as well.
> 

Thanks, I'll put this straight into mm-unstable next to your [1].

> This is based on the fix [1] that is already on its way upstream.
> 
> guest_memfd will need this for the work they are now targeting for
> 7.4. I expect the guest_memfd user to add a KVM-only export of the
> symbol.
> 
> So either we get this into 7.3-rc1 as well, or Ackerley can carry the
> patch as his stuff goes upstream through the x86 KVM tree.

I expect both [1] and this patch will be in the second week of merge
window batch.

> [1] https://lore.kernel.org/r/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org 
> [2] https://lore.kernel.org/r/20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com 


