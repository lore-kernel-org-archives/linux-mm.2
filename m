Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83D5C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 19:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443146B0096; Thu,  3 Sep 2026 15:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3D06B0098; Thu,  3 Sep 2026 15:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2FE6B0099; Thu,  3 Sep 2026 15:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2386B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:03:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9877BA4262
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:03:08 +0000 (UTC)
X-FDA: 85173373656.01.8EA44D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 08C0120003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:03:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MBZB5WTZ;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788462187;
	b=2HIr+RjzRmdloCeK81WxX8OB8+ZGoZZuCLFfOeinYAm03bLc/VpqDj0k1Ewtcii1PH7bZP
	sQ91gKKuan4CsQ/z7EQUgWSqLqtaifWgEug+rk5YKYedVNJMAkhZa2PiHSBT7lWYREAoPN
	eTw4KtpqMdY0JTyJxzIjOj5vBoEppsw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MBZB5WTZ;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788462187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKJemz5ICg83tGFQcJ4mPN4VnwzmurrHkskXzI16ark=;
	b=70wuTvpsId219a1+95U8A5cwU72GnlYDxnw4qdTZC892FsDbE7WQvfZrR537kFiuaGl893
	2trrrTHjvSDrpjMfKESRVSK7hpbEIt0nvCoGZmRafNl8exenrm7F2W98aS8C+Rf6AxXuO5
	2T4SA0LtQ/H0sceNNsBSUUhyLAkGYmo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2800360A67;
	Thu,  3 Sep 2026 19:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871E51F000E9;
	Thu,  3 Sep 2026 19:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788462185;
	bh=rKJemz5ICg83tGFQcJ4mPN4VnwzmurrHkskXzI16ark=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MBZB5WTZLt05umMt+cRoJnwKItp4sJxlinugvuPa8LlkukKfn0nkIMgJAC2m+MTOq
	 7iuzEvTpNZ98F7S78kXvVj7J1vLVmYQhXZ8wqVX6wb+Z7zPi2SyDipYiC1xUk62OUV
	 DI8ZYbXMGL5eUQlptOJEAE80tDZwDcjE7MMDQcc3Tmrq3wjCkJg83sPU5gKdBlka18
	 bd98qKiXmL91nQ6XQfnXd9LfHeEndoJhxftAgiOQfizy/f/Jxq8KYYJZi4lnPO2nMO
	 y80C2VJV0/7gfb+giObYkHb9/CLUaAdHBr+EUBR6xupPYqhF13QeeXq+Djcig9M0IG
	 E5HesY2OGnbDw==
Date: Thu, 3 Sep 2026 20:03:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Kaplinskiy <mike@recall.ai>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com
Subject: Re: [BUG/RFC] mm/madvise: MADV_WILLNEED skips swapped file-backed
 COW pages
Message-ID: <apm68kgHC0NK2zVI@gremlin>
References: <CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 08C0120003
X-Stat-Signature: faugju3erz4tpydhms3y3jwpyor3hnq3
X-Rspam-User: 
X-HE-Tag: 1788462186-1186
X-HE-Meta: U2FsdGVkX19veYhnfLRS4fJiplGO4paQX5mta8eC1i7ENgVDvSJjZvqpsrhtMNosnMS0Umn/o74Zm6F9mU3l0Xi0bHmidb+El08KQIdQEGIG9JkAeIfSpuYuOvTXVG1ShLgmdA2jlPJWM5nme8dwim0aFhGCZj8Hit9g4mmU4yU1liPwdO4tC6G+d1WW/Wxhnnu5wskZ6qGm23tOLoq7lpVA0XIzom+yo5ali89oALrEUCA7wN+ONf7GAKYhwTsEFLrt3OsklJNLD7KIDtgdMp7QWMozAwP1nfOTo/0ANutsyVOrL9oBmRcyeAF4I87DxYhHxfpV9A4fPWt2qOqE+24KzmqH8BShmDH+exswd4BcAY2qLzLkpcSCm4YbrR6NjGp4RzUyZQ0To4BD59VAII0/6kOz9eiHi6+GZWZMqvcR2+E8ySJIFO/jlsHxnGlI1Cdb8Iw5Gu9YI1Y+k9dafcsSiiICzrIVgLpMOXoMn2cK9G+spFr1jg3HGmC76l/5Ms2sKWXaxalFeNh6qANWTajG9TX62mfT9dqK6cLrYrLw3NS78RNdM/7F/njv5wpDe60Y24cjdvleXu0ncn90/jlV6vwMH6v26OjuITwTWM3QH26gxnEoVFrfA0mxHFmLLSqYn0C/lg87L+qv+HZLIplzvkBTLbBzA2DHiKLWY4Ub8aHg6P+wbfKFNP2I7IJCGjW3RRZkQ9OZaA7SlHQuQ8ky2QcAWDYi9y9qZ+CmaGuoJnnOd7VcCcuOihz65Kg/GuOL9eGw/gZrFRMRooAS2YFl0ghAYiJtIGAIrFzV8NQzmu+YTNn2uRTQt+HyeQqFP6eW7+AGDaKBtz+nrbTd4Jk+wY6yzdwL5s+Gk9sWq5HJLfjcDEf1Ys0y3XcDcKbTwsryfBuNmyU48zbvWARFLQJsFWX/4QlJhetAAZmSWvbrMomcF1+PkZbDleI6UxyoFm0MinkYvwug1lA/Rq8
 YywggiyY
 3b9n1n3B+y5kbZkWSg4bOrVbbBMSRxDosJAvFymWdwhT8stVpXRWlubwq8gSQMVoI95OJNorX07p9udIMpQ9jlqwbwTlDwPnvo0msa9tuKMZZ7SbhKpb5hEj1Co/4TZF5hyPRfcvcjJ4ZxesTd/a3O2x2ioGCvv99/x7O7LQ4fLsAqf2z1q5Sp3tCrHds2ZeycW1X6eJDi2SLXMjLXtXNrgQGyUGXWOwmoOaSqCuxEX9NsNUXEl06vle6qm6UbS5PBa6X7ZsK5vOnW0Am0+dwb1WghxjXbyCppvmEP2khlA5bf1hiGqr0yegr6nP6Pek9+xtS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 11:24:48AM -0700, Mike Kaplinskiy wrote:
> Hi,
>
> I'm seeing a strange behavior when using MADV_WILLNEED to schedule
> swap page-in. It seems MADV_WILLNEED does not schedule swap reads for
> swapped-out COW pages in an ordinary file-backed MAP_PRIVATE mapping.
>
> I reproduced this on Linux 7.0.14 on aarch64, but I think this code
> hasn't changed in a while. mm/madvise.c:madvise_willneed walks swap

It's more a known limitation of MADV_WILLNEED that has existed forever.

The issue is that every single MAP_PRIVATE-file backed mapping would then
need to be walked twice, once via page tables -> swap cache and once via
readahead.

But you could figure out if it was CoW'd...

Something like:

diff --git a/mm/madvise.c b/mm/madvise.c
index bc6a7dc73021..33ff3ba69c7f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -297,10 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
        loff_t offset;

 #ifdef CONFIG_SWAP
-       if (!file) {
+       if (!file || (vma_is_cow_mapping(vma) && vma->anon_vma))
                walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
                lru_add_drain(); /* Push any new pages onto the LRU now */
-               return 0;
+               if (!file)
+                       return 0;
        }

        if (shmem_mapping(file->f_mapping)) {

(This also happens to fix a bug there with MAP_PRIVATE-/dev/zero though
that'll get fixed with my upcoming series anyway :)

The vma->anon_vma check ensures CoW'd pages have actually been mapped in.

But then you'd have to do two walks for every single CoW'd MAP_PRIVATE-file
backed mapping.

The majority of the anon walk would be a no-op also.

> PTEs only when vma->vm_file is NULL, and sends other file-backed
> mappings to vfs_fadvise(POSIX_FADV_WILLNEED). This skips the case of
> MAP_PRIVATE mappings with changes, which frequently happens for
> libraries/binaries with relocations and/or writable globals.
>
> The code is at the top of
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/madvise.c#n282

That code is skipping non-swap entries for a swapped out shmem folio? I
think that's irrelevant to this.

> .
>
> Minimal reproducer attached. Would there be interest in changing this
> path to prefetch private copies in addition to the readahead?

I mean I'd like to hear from others, if OK I can send the patch above.

Are we concerned about the inefficiency of this?

Or dropping the mmap lock right after and faulting in the file-backed bits?

I guess if you're doing an MADV_WILLNEED you are fine with it taking a bit
of extra time to swap stuff in.

>
> Thanks,
> Mike

--
Cheers, Lorenzo

