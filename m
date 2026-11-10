Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984E2606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SNfQ2j5T
Received: by kanga.kvack.org (Postfix)
	id B49156B05D5; Tue, 10 Nov 2026 11:18:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21066B05D7; Tue, 10 Nov 2026 11:18:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5E4C6B05DA; Tue, 10 Nov 2026 11:18:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82A266B05D5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:18:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24CE0120961
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:18:44 +0000 (UTC)
X-FDA: 85419717768.28.45D4E25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81247A0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:18:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNfQ2j5T;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794327522;
	b=TAeC62ZUGidki0yTR456oV3wxjOwP1qjpa8BIcyXKh8G0jVJPQojLKkVq+2YAvEkdaq64P
	dqQj3lp8lQn27U6E073Vvc6NqMYJo48lqnqW5B98lfi8+sBIOueKyOS7X2fO2nXvRgOFtO
	44XvhVqxrIyc0eF3mHn4+ZNdAAN1Ykw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNfQ2j5T;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794327522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCECkq6v4+9D6kK3ah/nuf5WbScQfy10bXlUvhxbr5Q=;
	b=uH/bRtQdkPct/Iw37gaT+2t4RCt+bsk6ZocG3x5gcKcZ+bYi7z/JHSXRZL8A9WJBlu2Xgt
	fsB9df2vhrvzNawocdb/9zXPR8bJQWKMZvKTvz91goH89PCKiLimflwbvQ2dJ5TCj2UiPz
	SUtzGo4RNbjlzGdLZPAnrfziRAjX7aI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2195633D1;
	Tue, 10 Nov 2026 16:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1219C1F0089F;
	Tue, 10 Nov 2026 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794327521;
	bh=UCECkq6v4+9D6kK3ah/nuf5WbScQfy10bXlUvhxbr5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SNfQ2j5Tt1wcgoESjEHsHrd/7ffBl6iai388sz/sKf9upCOfDKpqrXm5O6lQvjLqi
	 Bgg5psXrozdaS7TIGnK/xbMVHtm+/Qf6O0YRa1ZbYvCwcf7HPguiACb9lPo10jqakN
	 Sgo7UItp/Ws6HwcRU4iT8BAm1cu0JVevjrj1C4HOpFlg157gYI5kX+EMQ/ejcvOjIb
	 DdZyFFMlrQuOx/z6qQdbP8sdEKL7q9+P1Dn4LIjOvyQkCeVyuVvWNVIJz1r9zfVv/p
	 8gAFyY4uoTWyyra/7FoloqMDaf6pMbmsvqKlKFHZRh65q/OZ6aj0h2WoZl/CMj98m1
	 OQxOwLEhzYfzQ==
Date: Tue, 10 Nov 2026 16:18:35 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Lance Yang <lance.yang@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Seunghyun An <san55@wisc.edu>
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Message-ID: <avNDjxZ9jeYiwdVh@gremlin>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
 <avNAgtDzM0MYevV8@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avNAgtDzM0MYevV8@gremlin>
X-Stat-Signature: rq699j1fphnsbx9ctqgzzho4j3grdo16
X-Rspamd-Queue-Id: 81247A0009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794327522-602188
X-HE-Meta: U2FsdGVkX185YpjFPrIv45I8frHp69yRSJLQrjLfprU7QVk1AnJ0NNOAYXToke6mBuJse5VSswt6lctDOX0Mwn5NF9yDoq5L071eDaYjNFQuDbRV5+APwB8/JlE97GE9VIfVDGZlpGX3I4zyfpYsnl77QHXIxMa9Ybr+dKwBtfHq/XCg+ui1HyTBahIf1UVXkbRW8UV2ZE1LfIFisqRYFhVzBZSWLhEi0GGZhfM3OGXTnK+HQ+tQ4i/xE+FWQk/zHx0TuHWmc7pOe95YkAoHTZ5NkKCIxAExW8WF0CFCFSrYqhDpQ0tsBQilD78jOsX8/4SgoOaD6MDc4Jbk9QY+HKAaonLvR8nXA1P9j39L1Pwy95jHjsFYRJTOf4/PBOLVf+0AcWXdRH0OfBa80qiUl3dNkFHedoJVWd4rOmwwBLW1Nv/zS4qScwh3N1deaFzc3KkayXQ2KcuXTBWLUs626JJSreQ45bhV4YhSELgICUoWqRLbeeL40VdyXLtOTszjrTBj92XeNEWpK3tXjovmV2qoqxdFO3V5UcGvlca0k+JEahsC1q04qvc9zpGABNBOdKd4mP+vEze9WmOP87lP0tbc63cpq5NYXbp73fvUiA/qPz34zlbOOfrlmXBtk9JMOy5hoYQiUGFByr3v/sXKrqjmokKKGwpNzP3hpsjWgHcA0yjlihNVc9vOsNKJ/CFHi1fKW6ER2s6yGwRxBMs5POGFS0P7JBJD41sM13w8r9dSNLIBwih+EKmj4NiSpzVbT/+RddQNMMWyESco2bIS6Ht8qvR8IjLEsBk8ufkMug7CiT9qIavVZnuShZV1jHd//BrWmyGcPtnAjX8vTA9Q3eZf7Yz9tBLce7hGIU7d/Osz8EmEC4fExKNB5pwm540H5KU6TfnGAxTvroaQ/dXnppfIdTh0UYUNSY6EQw90n9/0uP6tqughd1QvekI6dZuwuHTSHUzrff4ADOLPDv8
 VQPHRrZG
 OTaK8LxfDAewwuW+JlrPy5fmFRKh1R6ROLFWoPuMUqqK+qwnNEt8b8h2JuYDerY1N8h260vunD9ns5T6+1VW2+oo+B1C2pV/HWmC/Gqt1WKq3aDocGMk+Q4fuVAM0+g7Dq5jgZereqy2PmLwvowW99xKpHYArnVO5Dd11sHPJ61NuT7kM2xdesOXBOJv4QPaz0oBuCT3sqZnP6GyoTIS2SkAvQqSr+I6wldZA6+ExXmbJ/58TxBtimt6XzFkJ1Q+ZC8Zbzh56tajM+3ywgFdb2dakSnS9gUAjcm36S6y29kKY2H4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 04:07:48PM +0000, Lorenzo Stoakes (ARM) wrote:
> Andrew - could you update as below?
>
> Thanks!
>
> On Tue, Nov 10, 2026 at 03:10:40PM +0000, Lorenzo Stoakes (ARM) wrote:
> [ ... ]
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 9ccbbcbd7aca..9c3a9c6525c1 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> [ ... ]
> >  /**
> >   * vma_assert_stabilised() - assert that this VMA cannot be changed from
> >   * underneath us either by having a VMA or mmap lock held.
> > @@ -418,9 +423,18 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
> >   *
> >   * With lockdep disabled we may sometimes race with other threads acquiring the
> >   * mmap read lock simultaneous with our VMA read lock.
> > + *
> > + * Assert only if CONFIG_DEBUG_VM is set.

Also this should say:

'Assert only if CONFIG_DEBUG_VM or CONFIG_LOCKDEP is set.'

> >   */
> >  static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
> >  {
> > +	if (!IS_ENABLED(CONFIG_DEBUG_VM))
>
> Actually I think this should be:
>
> 	if (!IS_ENABLED(CONFIG_DEBUG_VM) || !IS_ENABLED(CONFIG_LOCKDEP))

Sorry this should be...

	if (!IS_ENABLED(CONFIG_DEBUG_VM) && !IS_ENABLED(CONFIG_LOCKDEP))

(I have a bit of a fever today, can you tell? :P)

Thanks!

--
Cheers, Lorenzo

