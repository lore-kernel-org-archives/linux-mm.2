Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A83C3C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF646B0092; Thu, 24 Sep 2026 11:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99FE16B0093; Thu, 24 Sep 2026 11:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5BB6B0095; Thu, 24 Sep 2026 11:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67D2A6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:51:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB7054033C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:51:39 +0000 (UTC)
X-FDA: 85249095918.06.8626973
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 192B640005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:51:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=I2TLD0XV;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790265098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1SyC9FPSl1SxWObKcKKHtxFd39BYxlX2zBFyTHCl90=;
	b=q4F40KHX6hd0aB2Jx9vIkmdzJjqpgCla1O3BjcmhPAN5N5CcIlocGIngqiwIyHLoBQf9zP
	bnYkLUCz3rd25lkF4srmAb/cmWs1XoYBWF/ja9rbeNXNZ3e5jJoH6HtbzfUEaNqnJ78L9Y
	N+20HpU0ZdI1PNloo3ZPiuebSNmeR8Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=I2TLD0XV;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790265098;
	b=WmREAAqOBek07JTnPdpTj7ggNw+ztEA0AUdfkUpa7U7dP9BpWJW554YrMiVh0HLiureDob
	kIdF2f8GhfokrBXstXU2bP+fviWDdbdi5YNRYF84WJWOEbir0FTLPKyQzGxBJDx/tVTYJ1
	QFIPM0Ew2VNU4gz5zrWKeqNBH6ymWHM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5414B601EF;
	Thu, 24 Sep 2026 15:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585F11F00893;
	Thu, 24 Sep 2026 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790265097;
	bh=I1SyC9FPSl1SxWObKcKKHtxFd39BYxlX2zBFyTHCl90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I2TLD0XVn7SQ741gpQ1gNMfipLrznoSoXQo3p1M9Vtf6mj66Nzyg1wy4x3diSNy1K
	 CbybYAHyfSMXesoua+5B+LM3eDBXvTTAEFljsDSs1x30/sIEfF3YQHLAE2MdJWI+EZ
	 wciMGkvDJb3QgDaxmqm4QZN5l9aB6//t0WJowSWA=
Date: Thu, 24 Sep 2026 17:42:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>,
	syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
Message-ID: <2026092448-urgency-landless-f79c@gregkh>
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
 <2026092406-irritably-maggot-9512@gregkh>
 <arU9Z-EhEQg76CVz@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arU9Z-EhEQg76CVz@gremlin>
X-Stat-Signature: bpx19bg95msk8d5ciwhh6mm6r5a4cyhr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 192B640005
X-HE-Tag: 1790265097-86468
X-HE-Meta: U2FsdGVkX18QKCLY9KeAPvfNgiCnNeVARP6fmDmviu10OirqTl/1Xy4p2u9hyctHnoAXbsdw8lmYoQ9sfipR/cAqCXdoiPGvZ48FoeejKZfqatwDcntdMZFuMloqF8pqjPk4lwtXl3SGM79RYHNewZ5jYpUa6aX/EMxg8xJ3UZwpo/Skw4O3Eu2jV3KZ7Yk/AfRF2ueZEPEmYzgiXDurlykFQGuuRsZXoctdfnyLpo0PLsfL8hsEZq/1E4UQ9Es610X4EdtPeWPJdqCJ/R40m3NxYgp1T5h7wFVSOBb1XLnNHb52UQXhiuq7ssOEITga6Lo53OtHObnbyqFai15YUOztTP8H76jPUWqfCmd7Ok0WX3GFcuqhtKLbwYMu6OwdfpXaunIKc4E3G14VmGU7Fd1ESKeGlEbHK7PyrQkR52B9uGOwjQ2m91KH3PZ1ieIiN+O0CLUPFb12FMLKKvHxUyG8X9QHbKiKTgw3zoM7LJdvvL5+2kw6IjAKV5guSvEMrBXt1ia4PltmXmQMKAgjDu1XjXSAK9HuW6TzRLZEUfZLoHW0RKF4G+mYUuZvKlk7xD4Za7SEod46AKe3/XnGNXtaNK7+kTL7IZW4yAVZJOZ7LibuJQlz6rM+MhUHjZQJRj0jVm/6YGj8n4Pzui2vXkbPEIoEUGDubxnXgkznIyDyAWjtZ7MFx5yCpLFXRxfpp80AosPZzhuQpqibKvlcLOIFmFchqUtQUES11Z1RPjykSWsjJtOlM32nSCgj7sFntjvPG3zCKqrfWoaJA/uAsE6f88PJqDi9ijTulxAaaNJdQja2AHe1Q8A/v7eaYdklf86eNOXRlwWlNgX+tqlSvqLXDi5nW4u6LEbxICIKxTNEPBbTn8h3jYNhUWvpLltAXjDT/sC7sDycWU33DiEsqs4ArR0gZ2UArSMv83SvkP+DuhG5Z5Vshs2mL26ycLXmEsro1lD/x3JGyhEsLc9
 P857Icm8
 F2nYkTN6bPD0rkv8/+qsXupYwjqyeRkSU60ZTvjwef/bgbtytyE6zO8xiP1CJ4LHagub+Sdk63uNLFDAxEivIWvOVJGWtYN6GGXnxdSjTPjup0li+7Ruqs0TvXL1XzsY73dREtxYIvKq1v+ua21XJB4RvFV0RtycWzUxNpSfT16gyo4OvLVUssT07xFjad2cW48bVz04QrydaFWLg/1vbd6uf5hOR/cDR/X5W1MYczTkQYF6K+yfx40c2dFCsvLXf3X/lY0bKMGKI9LrNU9UrweNhPo57zkqZ+dLVrtM3VVE/8MEylQTrfR49hYwopg1PEfvB0hmoLy/TJFSxAdj+9KwtwYeJa6/oOczbAfXWlUgY5c74TFDqWFF2B9/v2BX1YI6/PaVQdHOM0qjR2Ey2ukQsZweSnrGlFCW669gyzuRaH7vuGO+PtI2I6hqGEV+wi5Qu1lFc2KS6kdNkd/FUmsAP62ebodMBG1AHwYfDZWDbbM/MXMVJz5iCk2MncphKmaBeqWc3GNLXsfXesk6OmR10zHTRe6NaBEE7Fw79j/BVytasThcI8Gx1wChlBaJpc3Z1+2PhdoHQD2bL8kGiLTB4QyLC+q9GWdJspOaiWL4ln/nDb/rG2izrKTceM3NT4Spmg8TSOoh5UpPpRdv/bFP7zskjqBTMoDsI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 04:29:23PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 24, 2026 at 05:08:49PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Sep 24, 2026 at 03:48:24PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
> > > MAP_SHARED gets you true anonymous memory (albeit in a VMA with
> > > non-NULL vma->vm_file).
> > >
> > > This is a by-product of MAP_PRIVATE-/dev/zero being how anonymous memory
> > > was mapped in Linux's distant past.
> > >
> > > It happens because mmap_zero_prepare() gates on VMA_SHARED_BIT and when
> > > mapping a read-only file MAP_SHARED, do_mmap() clears VMA_SHARED_BIT and
> > > VMA_MAYWRITE_BIT.
> > >
> > > The gating is incorrect - the (poorly named) VMA_MAYSHARE_BIT flag exists
> > > explicitly to tell you if something was originally mapped MAP_SHARED.
> > >
> > > So the fix is simple - gate on this instead.
> > >
> > > This isn't exactly a common use case, but it's unexpected behaviour which
> > > now causes an assert if CONFIG_DEBUG_VM is set.
> > >
> > > While this bug has existed since the dawn of time for linux (or at least
> > > since 2.6.12), it hasn't caused issues in the past, so while it's incorrect
> > > behaviour, it doesn't seem necessary to backport that far.
> > >
> > > The mapping is now accounted at mmap time and can fail with -ENOMEM under
> > > strict overcommit, and read faults allocate folios. However this is normal
> > > behaviour for a read-only shmem mapping.
> > >
> > > Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
> > > file-backed anon folios") is the first patch at which the debug assert
> > > fires, so target that instead.
> > >
> > > Fixes: 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios")
> > > Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
> > > Closes: https://lore.kernel.org/linux-mm/6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com/
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  drivers/char/mem.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > > index 63253d1de5d7..5b93c92c2cf1 100644
> > > --- a/drivers/char/mem.c
> > > +++ b/drivers/char/mem.c
> > > @@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
> > >  #ifndef CONFIG_MMU
> > >  	return -ENOSYS;
> > >  #endif
> > > -	if (vma_desc_test(desc, VMA_SHARED_BIT))
> > > +	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
> > >  		return shmem_zero_setup_desc(desc);
> >
> > What's the odds that something "big" actually relies on this?
> 
> I think it'd be fairly crazy to, unless people really care about read-faulting a
> lot of zero pages which they want to somehow not account properly.
> 
> Anything's possible but I think on this, right to take a (v. small) risk!
> 
> >
> > I'm all for the change, but be prepared in about 5 years for people to
> > start complaining :)
> >
> > Want me to take it through my tree?
> 
> Sure, thanks, though there will be a conflict against a patch in mm.
> 
> Though it's really that the file is moved (to mm/), so actually should be an
> easy resolution?

No problem, you can take it if that makes it easier:

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

