Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE7FCCF2C7
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 01:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0FEE6B0088; Sat, 17 Oct 2026 21:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99B86B008A; Sat, 17 Oct 2026 21:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B621B6B008C; Sat, 17 Oct 2026 21:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1B36B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:04:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF8D9A7F24
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 01:04:16 +0000 (UTC)
X-FDA: 85333950912.15.85C2A2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31B37120006
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 01:04:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rQpNBk6P;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792285455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBzg1XnqQp2xTgPKm6aEo7hheg/CtG2kAo70FRWV5Qw=;
	b=sLM1QdNU7ksm7euyqgpb4PdRgiT+0erDIfeWrxsbfHoQUH7FvOpHgArL6r142+6jehJkf7
	j+ocL6rQTqBOgtAMrZpgRzvgJIGuZYd/E/Umg4po44dPTnlSxb2F3/NaXEAhESATHSOWbx
	0uoUMi4QH+u2AY7JdJzovTS4eJPTnkY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rQpNBk6P;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792285455;
	b=sGoSezAZkeNJGoQSNAHckS6LL+ojzsX9OWjdA6BmIXXE8o6ChuLgoteU7QhtIeoFfZXYfI
	Mp3aDfAXI5sxL6xbgtFWBzdJ99c0CbRqhPNfvBWgWehq7fgp2ew+9rdbjxEt6MCtfv/hiW
	AsAsBnHRHytVN6Mw+oWi/Yh8dYqtDnQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEABE60258;
	Sun, 18 Oct 2026 01:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3131F000C4;
	Sun, 18 Oct 2026 01:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792285453;
	bh=yBzg1XnqQp2xTgPKm6aEo7hheg/CtG2kAo70FRWV5Qw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rQpNBk6PIcbBYEEtVcMCyzy80nO9U+u4EV/iOS1fliNGnoTGiXg0V252S8AWxZsPp
	 3q/U+l5BlcKB9IibCRC4lVptDnbNoPCXsbT5riniSZD/gGa6hiibfTBZ1ms3t3f5t1
	 IwdJmCFc6rir3HRCpwCMKJEhgm90/Lem6T6/EFVo=
Date: Sat, 17 Oct 2026 18:04:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/mremap: do not charge a shrinking move twice
Message-Id: <20261017180412.a79a36e873c5268df126cde1@linux-foundation.org>
In-Reply-To: <20261017233527.797191-1-nickolai@csail.mit.edu>
References: <20261017233527.797191-1-nickolai@csail.mit.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 31B37120006
X-Stat-Signature: 7ecwjzw8zm5nyxhhn1z1y9kxqrt91puh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792285455-968727
X-HE-Meta: U2FsdGVkX1+wtMKw76Epr3MNBx7A/ghxI7HuteKm7+kZm5RT7X448SdKDGnQVQdkXwTQsFaTXHB3nvg7aV0H+c2PELK2gLSgwmS8bhYX7bmpPAC406Gez5/tWcHKQyGJsJoroCcN4nRkRuOlLjfupTxXabO2o0woQMg2sHvrUiFdWDW/CaUZcIsw6HHHQ3i3mncxyO0v7QqNRrx5zdJV+ya9nWziT2/RbCZIegjogkrP1JAQD6IoKoQHK+ad+5XqdmqfYnlwVo5v8zMHYFg0YZfuaZglOg8PqvOAfvVicIMG7UGoihN4jqLLPtuXztjOpt/7P8s7fAORd3zBMliw6nGtFLj0tECOhJmrRiQrMsbRQDpmQw21UtbudOlLJfqK+M/7b7hLnDJdYTRruaC3eyCphJeC9kzmqI8LBbng/ceOzixHurXgSAEdhwqeM64E1dy9aTBLPQyCmgJzGBCvLRUcHUSawH9YI6mGbAWOe6ndqc8ffe47MjPw2sqK/MwNfsIneedJ1Q6GqHqunKPlx7o7mQY8QKWJOKK9aEyUJT8L6Yhk4mL45Qi1GCrXFPv9Vn147Yo0+efAfJVJE00H75ApB+tKeu+MalqSpuPujqPR5+senn5iOtNqk6dYYbqJmvKj9qvZdJkpLUVkIp5pnkT2hqFkQteFJ/jMBjz2IC96GA7QlJoQQln7QrXlUPKQRo4g3dDrsxsFENBu7CatOAuER0HNNkIuE+Q3f3Gt9FXkhbQPy17Y3GXQe0j8+QmtcY9eax8Q0mQhs/9etCBbDMS3XtqY/2azMoxeJXs/oFf16VdBycQ628o0ffWF8fHT8OtkCzCBUjQI43GjjT0RQ7VXwDz1V25BpWeZbzCDr4YZeT0hmx2b8EapS3GzpnRvJg57hDMSxUrrRncsE0ZzR5DqPtHZ7k/cGkdl6SYNfU7WXQ+uiP/XGQrgNtilb+bvN9VEAmoVUBQ59gKyIvL
 Nf6VWOxN
 M4w5PscPsD8waOwQUYYIWNDuvGG1VuDRjk65OmBwiat5DH7SrKgh0zaz8FENNacp+CFY+HqF3DRlMYZkU4RwjwvZNYGi+Q6zaj/I2baLV9MPgy1fDu7vSa3bOmkhPAWBBDUYlC+G0+bb3RTdKPE4AolGZ1U9XaScIZM2p24kLDlRXmA/Zlce6BImtJ0ntTagaw8aYVaHfg860aX+ccCFyVEGmRfoN0pbpdEW8Imd57M2hctt3ENOCzRO7mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 19:35:26 -0400 Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

> Since v6.15 every mremap() that shrinks an accounted mapping and moves
> it with MREMAP_MAYMOVE | MREMAP_FIXED leaves old_len - new_len bytes
> charged to vm_committed_as for good.  An unprivileged process that
> repeats such a call keeps raising Committed_AS in /proc/meminfo; with
> vm.overcommit_memory=2 it reaches CommitLimit, after which every
> accounted allocation in the system (private writable mmap(), brk(),
> fork()) fails with ENOMEM until reboot.  A loop of 1000 calls moving a
> 2 MiB private anonymous mapping to a 1 MiB fixed destination raises
> Committed_AS by 1 GiB.
> 
> mremap_to() first unmaps the tail of the source with shrink_vma(),
> which uncharges it, and then sets old_len to new_len so that the move
> looks like a same-size one.  vrm->delta, the absolute difference of the
> two lengths computed in do_mremap(), is not updated, and
> vrm_calc_charge() charges delta pages for the move.  For a move that
> does not unmap the source the charge only has to cover the growth from
> old_len to new_len, which here is zero; nothing ever releases the extra
> charge.  Before the vma_remap_struct conversion move_vma() charged
> new_len - old_len with the updated old_len.
> 
> Recompute delta after the shrink.
> 
> Tested with the program in the notes under QEMU (x86_64 defconfig):
> Committed_AS grows by about 1 GiB per run without this patch and stays
> flat with it.

So I'm training my LLM to do better reviews.  It sucks in Tejun's
review prompts which suck in Chris's prompts (which Sashiko also uses).
It also incorporates some of the prompts which Sashiko overlays on
Chris's prompts.

And now rather than just checking code I'm getting it to step back and
take a broader, more architectural/design view.  Scan the lists for
similar changes, look into the revision history to understand why
things are as they are.  Study comparable code sites.  One way I'm
doing this, which might be innovative, is to feed it some of the more
impressive human/maintainer reviews I see and ask it "what rules can
you set in place to make your reviews more like those people's".

I'd like to start using it on people so I can also obtain
author/maintainer comments on its reviews.  I can then feed those
reviews-of-reviews back into it to get it to learn and improve.

It's a work in progress. Here's what it said about this patch:


Hi Nickolai,

The code change looks correct to me. After shrink_vma() has unmapped
and uncharged the tail, resetting vrm->delta to zero correctly avoids
charging again for the remaining same-size move. I checked the other
delta consumers and error paths and found no introduced problems.

One changelog correction:

> For a move that does not unmap the source the charge only has to
> cover the growth from old_len to new_len

This is backwards. MREMAP_DONTUNMAP retains the source and charges
the entire new mapping. An ordinary move unmaps the source and
requires additional commitment only for growth.

I'd suggest:

"For an ordinary move, which unmaps the source, only an increase in
mapping size requires additional commit accounting. Here shrink_vma()
has already unmapped and uncharged the tail, so the remaining
same-size move requires no additional charge."

Two minor points:

- "Until reboot" is too strong: other processes can release
  committed memory, although the leaked charge itself persists.
- The vrm_set_delta() comment says "difference in VMA size specified
  by user", which is no longer quite accurate when called after
  adjusting old_len.

The Fixes: tag looks correct. Given the potentially system-wide
ENOMEM failures under strict overcommit, Cc: stable seems appropriate.

With those minor changes, I think this is ready to go.

