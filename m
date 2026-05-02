Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88B5FCD3424
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 06:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE6C6B0005; Sat,  2 May 2026 02:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F426B008A; Sat,  2 May 2026 02:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985016B008C; Sat,  2 May 2026 02:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 844DA6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:53:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F1AE14025D
	for <linux-mm@kvack.org>; Sat,  2 May 2026 06:53:50 +0000 (UTC)
X-FDA: 84721564620.24.7B9D53E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4F3EF1C0004
	for <linux-mm@kvack.org>; Sat,  2 May 2026 06:53:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oHq0KQKF;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777704828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/L6SgrYKDbX5TU2p9/qialGvPmKF+89Cnc6/vPHvRA=;
	b=JLIVLZ+ZPrnHhAUgY6Wnk5sqfVwcb22az2PDaNel9/9iBn+Uv0xe8gPY9OywpgXVRBK8qu
	DeevS5dvkFT5BiFXnGt1vmkHas1hmy4iic5kajD8n0KMgSZGQ9DrUhM7xYQGyEahgOt42B
	Wsi0OJUb4WbWzFwIpw1F6zpKkps8hrI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oHq0KQKF;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777704828; a=rsa-sha256;
	cv=none;
	b=t7Yr7f3WLVzr4rmDybnP1TK8nOvw5UQPpljq0NDk7uxE/Af4tphQ8EmHc2T3AQWmaMfe1Z
	lzL7YsdLasdGHIX6VyE1RjFKEzcK+T1vo13fbJw2xAMJzJntvuTyz/WbqctYH748xAPqi4
	eptbnPSbH/oq/cUwRtJ/+87gLzAc6ko=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0322D40943;
	Sat,  2 May 2026 06:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3CEC19425;
	Sat,  2 May 2026 06:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777704826;
	bh=kQS7yKwqiwqAKyQDMgOzWCwveY255BxB0f6Ga+V5ci4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oHq0KQKFnrT+Loqq7ap7l1DMv9QoYak9ksxAGyBEnj5ciF45D+T8l09ILtK5UnXq4
	 w21TVr5wvK3QeZ+wsOt1BqBzYH6tnpyblZDAyEUi4q7vGdeRzsQRclZKUrObVnq3IF
	 RMi4ThfBSdHOdasEvjsbkF0Cb186BT1HaJGvi/fw3u0c5QA1dB3zXxfsV77emN6Bl9
	 qTK0D3X0MOrGL+GKC/CFZqzmtCTTnT0ueRFAExNelKPn4BOj9pN6JXttOh01+7SCta
	 DixKhXFyehi4GAEkXdfCAeU0EqqLfHQ/P+k6GF5Js4mTlKGAtGMI+NS1n/Gx+xxRuN
	 2Zs1jNFEfW0yg==
Date: Sat, 2 May 2026 07:53:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Ryan Roberts <ryan.roberts@arm.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>, 
	Barry Song <baohua@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
 [RESEND]
Message-ID: <afWcMyc5M4vViLJd@lucifer>
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
X-Stat-Signature: jwczcdik7o34we88nwf97a8bsui7m5t4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F3EF1C0004
X-Rspam-User: 
X-HE-Tag: 1777704828-543399
X-HE-Meta: U2FsdGVkX1+WMMo/GNiKo1ARZotydX4hXe/L2yUWUOFWSCwqy0Hbsaki5nRPPTNPETbFf2BsyfnxOaRa69ho4W+cwQnmGgnBtwLMfbfeksx75MQqHEgiHzW+OYZ1VP0iA122iJzxPIxXp7n80v40s8NV/z7E7iv14NbZrQx8daE9JECRrYMT5EF40MT0ROdcg0OrzumMAjyL+G40Ud9EA3PjvUY+AznieFV5H5jImxHps/VOG2hlABvPwXouyNDPkll1OWw0jsotgaBLXoZ/bDVaZKyPp7pGH7DrttTi+CZCm5o/ZJJ7W6O7VEHBEW+TeIpdaDfERasshmDlb/eNAyxrgw3+tPI3cmw2aJac2Xd94cxAv4RzMkCXamV40lS7O5xW2ivudLcEkaFXVfZ9tRkDmvZhOSUi2QX/ogcsu/d3X781rdYp7wQu5Uzo05KXjA5I8JoHCSmRjjHQmkiNrOv+djVD+zXNc5gYUvrOpXULyqN12TiFNQCCcE89bakzD8GGieobs+BcrTnAcWo/83TkvVNnWa0yC0TJM2cxrXiQIRqrU7KvDanjLcMVSQEvQdiu36XrnoouQg7Wz0rIJsmnqqX2lkmdEaSvDjx5mY4iQjnrtCrQ76MojqHDRtuKdv2CqAjDFGZJzZ37MbUG5NrQOsDsgiAFlnrHF3eDBVezIVUb4loPfHo0YSekMrMUU5GDWRJNqC1+9So1dZzDh8Hi5J/azX4exqxb8umB8NHdyTdhR94HmI9iur9d/eIFPxFPrwawDvvKqUa8euZMS7A51hZCbVh+rWtjfcIZUcWCb/rqitWxAZxTYZrGuR6HzpkJjCT271rWBrroJw6MVoMGrh6WaN2bGQRwm3bwTxgQmMjsyB+R4PN3AyUt0DXRYT34MdhPnSOy6RjgLbMu/1/IPkAUJaQdTlDTg9K4K7ai9v5kqrUkMqXYED82veXDjYg/3EL6kara7gU0TP5
 ztBG+hhh
 TE40hT4Z0yUUW0tM4K4G0xKoy1ipm5crkykfmvBAcb7WhtaB1o9oqaCStpN56hZqMqNLraKobxVBB+j8Oq+I5H1a8s2XDGN2Qm/DdIohjT76QbplrrESCriYmIN2LWCXwtPqlrYF6rnCYEPWDGAYl3GCBaXy5wP1sTTMChWmAScm5LzMUunNSViJqwf4rXYZHHuMkP2GllJMavZMDPbttbd2Qe+jjiTqk4h0VTpn7/zbTgnXjQv4x9s/tly0M6nVU/bomKPiVMfoos8T2jjhhgWdvmH2qllmOKXffBkNuoi6KDVTIIE57yv30ZpepThmvXlrd156TTr/61OHsoJXRj8IkiIF626181AvE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As is time-honoured LSF tradition, I am sharing code for my proposal.

I worked a very long day yesterday and got the _very_ rough PoC code into
some kind of vaguely shareable state.

https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=project/cow-context

CAVEATS:

* The code is not great, it's 'experimental, wave your arms, hope for the
  best' stuff used for experimentation.

* I know the dynamic array implementation is probably entirely broken from
  a concurrency point of view, inefficient (an n gets squared, *gasp*!),
  etc. etc. - it is _not_ what I am proposing to actually do in any even
  RFC of this code, it's just for PoC purposes.

* By default it runs CoW context alongside anon_vma, and will pr_err() if
  there are mismatches between the two.

* However you can enable 'pure' CoW context mode via
  CONFIG_COW_CONTEXT_ANON_RMAP.

* This is, as the talk will cover, currently broken for migration, not
  because of bugs etc. but because I've not decided on the synchronisation
  method yet (_everything_ is RCU in this mode).

The kernel boots in either mode :)

Obviously this is going to go through a lot more changes before any RFC,
but wanted to get this code out there in the 'discussion topic at LSF, have
code for it' tradition.

See all those who are attending in Zagreb! :)

Cheers, Lorenzo

On Mon, Mar 30, 2026 at 10:23:57PM +0100, Lorenzo Stoakes (Oracle) wrote:
> [sorry subject line was typo'd, resending with correct subject line for
> visibility. Original at
> https://lore.kernel.org/linux-mm/8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local/]
>
> Currently we track the reverse mapping between folios and VMAs at a VMA level,
> utilising a complicated and confusing combination of anon_vma objects and
> anon_vma_chain's linking them, which must be updated when VMAs are split,
> merged, remapped or forked.
>
> It's further complicated by various optimisations intended to avoid scalability
> issues in locking and memory allocation.
>
> I have done recent work to improve the situation [0] which has also lead to a
> reported improvement in lock scalability [1], but fundamentally the situation
> remains the same.
>
> The logic is actually, when you think hard enough about it, is a fairly
> reasonable means of implementing the reverse mapping at a VMA level.
>
> It is, however, a very broken abstraction as it stands. In order to work with
> the logic, you have to essentially keep a broad understanding of the entire
> implementation in your head at one time - that is, not much is really
> abstracted.
>
> This results in confusion, mistakes, and bit rot. It's also very time-consuming
> to work with - personally I've gone to the lengths of writing a private set of
> slides for myself on the topic as a reminder each time I come back to it.
>
> There are also issues with lock scalability - the use of interval trees to
> maintain a connection between an anon_vma and AVCs connected to VMAs requires
> that a lock must be held across the entire 'CoW hierarchy' of parent and child
> VMAs whenever performing an rmap walk or performing a merge, split, remap or
> fork.
>
> This is because we tear down all interval tree mappings and reestablish them
> each time we might see changes in VMA geometry. This is an issue Barry Song
> identified as problematic in a real world use case [2].
>
> So what do we do to improve the situation?
>
> Recently I have been working on an experimental new approach to the anonymous
> reverse mapping, in which we instead track anonymous remaps, and then use the
> VMA's virtual page offset to locate VMAs from the folio.
>
> I have got the implementation working to the point where it tracks the exact
> same VMAs as the anon_vma implementation, and it seems a lot of it can be done
> under RCU.
>
> It avoids the need to maintain expensive mappings at a VMA level, though it
> incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a TODO
> (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracking is
> pretty sub-optimal).
>
> I am investigating whether I can change how MAP_PRIVATE file-backed mappings
> work to avoid this issue, and will be developing tests to see how lock
> scalability, throughput and memory usage compare to the anon_vma approach under
> different workloads.
>
> This experiment may or may not work out, either way it will be interesting to
> discuss it.
>
> By the time LSF/MM comes around I may even have already decided on a different
> approach but that's what makes things interesting :)
>
> [0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@oracle.com/
> [1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
> [2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/
>
> Cheers, Lorenzo

