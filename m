Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896A7C98324
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8DB86B0092; Thu, 24 Sep 2026 11:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A653A6B0093; Thu, 24 Sep 2026 11:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953E56B0095; Thu, 24 Sep 2026 11:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C23A6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:09:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E790803B9
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:09:10 +0000 (UTC)
X-FDA: 85248988860.20.8C6B0F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D49318000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:09:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Ouxl2a3v;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790262548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1SJ5qwFSMkgbZE6m/nDwefDqrv5UvLqOn5y2QRCfZA=;
	b=6HOp5rAMUhppm5CsVmq+aqcKHwuYTUFKmMWG2ggCaZ+P76NyHZWYGA3t0AALZINJitK9lO
	VCCQXOqHlI4xrPcMp4LipmrOqem99yjJpwlVvUbsQojVejXGcBvqjwNnpoi7vTQ0vEwruy
	Zyom9BTsyq1+v1rEtLSO2KjuTzUceMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790262548;
	b=SJTh+LSqn2dY5RFYLA3COuwnuimXarjqC1q8uZabJVPxlj81M2HA7zLYNAIbcdDR+HYCYF
	pCiDXhqgHQiUp3OK9U4ZzMDnsta/bcDkTHR4U6jr2mJcbTcge6PdJ1YDCKxViaIHCbboYq
	e0rZ6kWiOn6vphgf6McnHpEt6ri6/zY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Ouxl2a3v;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83DC160209;
	Thu, 24 Sep 2026 15:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734291F000FF;
	Thu, 24 Sep 2026 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790262547;
	bh=f1SJ5qwFSMkgbZE6m/nDwefDqrv5UvLqOn5y2QRCfZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ouxl2a3vHSSaOQKJ1SJKuM0VXh3++g0batEkZ2MV+2otwiAv4JZruOqJbxveGpveY
	 Bk5f95+RBlfRrTFQDK/ecu3Gak+Kb/5IDAtr61y35JFhy1O2zDJRTMPhHpOalqLzoX
	 mvoigUmfYBLxZPvdGuyLquPJhlIJQYjyDK+r0+hs=
Date: Thu, 24 Sep 2026 17:08:49 +0200
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
Message-ID: <2026092406-irritably-maggot-9512@gregkh>
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D49318000A
X-Stat-Signature: j9prex9j9fkrtxy9c69hwtydchq4pdb6
X-HE-Tag: 1790262547-945002
X-HE-Meta: U2FsdGVkX1+Oe23u3M3HakGpWmuqBtLRvD+tQkPx+81I23cXpAU0Mz9Db1LqrV8u8EeumVqUzSnrcLhOKb1jsK2mGfbcAYbj0n4NEmpeLVkmL6knv6qxDjNkNSy99ggk+isXuiK48EUBnVGYVYcTczYav+m3LutSKfpJE54Gc1V0uWv01XwoYACRGUNG+nz2Y1MDxkLw1PxLJpLMWneAGVdH6Fdca7MGAyMa4tAi57n4AAtYFMGEkJlpkZgpQZkn836pJaSAXbIJeU0sJ1/WJAABzGqySFjo+SJCt62KNBevbrkrj3/u0OcW0pXdGnRNzWAaCcOKBZzqJIjAV6qJUYA4904wpfirMYR/vq2E1yfBikuk7xpsLm5jDh2efX4ggO453OZKPLbS+XnjuOlpXClnyV6eX93KXU8Fk0YP302284jsUerxAhvh5OWfpeMwRl7ha4P7op9Aej0A769BoG9HhLnIjv/tPQ2pUO5h1C1qlVdqxUdaVFo6x1w4RqPQ6QSsc9AKgXrlSSP5hLsDlmIzFPslcqAyEnuwnkYIctpGJHx4l6mEwwvFaUqAkB42LaTxlME8NVm5/4dgrWVlsO2ZLe9vq8wXQZIDoPoz198JN9LUgLTQ+TsE8iV2w1XlvF+8gQvda7liMSBxi214gxpQgCsCQYXs+X4QT0rdXrxYSNG0hM7bhDBALaorSamvrGSYW4vlzpnpBmbICxROFnlvlO+SFcfdmqY5YOoR1tEXgAvpYMFb1O7RmNjf1XHdd0rgFf1HskEiiqb2kT80RG32VMBYsUgbFNub1EaTOiOxhlqPmbj5Xda+Q/Nyhcm5B3030Vp11viisUKrO/ISqkAID1qaIlYW/UYyu8EgiKKur8YO80FhcimBSs99hSODcOxiRq01US1xjfd0Dk374T8KzVxQmKy0o+cWwQx4ULWDP7JqsE+ftLOBESMV4yS1qGSvrPSXqrjr+va0Xbi
 NOdVQSMU
 jfrIhAldcMdL/fcyuLN6wUhst5WrgMqP1O8lunLnepWeu84J1bCmhf2gQR8SLTlbcqrS3QA9Lv29ihiStrYmGcicIlVesY5f0J4s702WpAkAZWL8L+uXJDA9B+P0xXNF/igHzzcoztqoY8OY1l6+kNkfpn1LR8Zyl0nW3EWgiIpRaReriHVhfElyl0KozkX+RcXuN0/ZLNOdLS/UakzfZ31Up6N4J9rIdgi593SP4n+yU4qHhTqOqpskBeY6XowLfJ44yF9tT3LxjTQ/Tu8dCq1uDi0HfIlrV4x+TjvVyY3Ed8ek4sr3xXzoyaT78f93i3dzAOpLJZruk74cMKZVynzELZe349uzWVpX9fqoRxkALWQYYqbs6A40qAspYsVF8UHStq7opK+MGZDGRvmSRj2gPp8Auv5le/Ek2jQw0WePqFmpklk4Cxdyltxca9OQjqqvLI7TiC0kOvV47BkyDB/wSHsSnoqoypblx7CJTNsd2G4m+Zilv6Cxm0i6BbPF1LUbF7Ubi6UOqoLy4Nw24sMoIEhoiJq/CyeFxamP4lyeYzCwRxnnhQ8Ld1gkTqIy8mI59iLCj9R+oTXXwrCbi0fzTCetvDJDIpr8bQ3gCR0QkSXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 03:48:24PM +0100, Lorenzo Stoakes (ARM) wrote:
> Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
> MAP_SHARED gets you true anonymous memory (albeit in a VMA with
> non-NULL vma->vm_file).
> 
> This is a by-product of MAP_PRIVATE-/dev/zero being how anonymous memory
> was mapped in Linux's distant past.
> 
> It happens because mmap_zero_prepare() gates on VMA_SHARED_BIT and when
> mapping a read-only file MAP_SHARED, do_mmap() clears VMA_SHARED_BIT and
> VMA_MAYWRITE_BIT.
> 
> The gating is incorrect - the (poorly named) VMA_MAYSHARE_BIT flag exists
> explicitly to tell you if something was originally mapped MAP_SHARED.
> 
> So the fix is simple - gate on this instead.
> 
> This isn't exactly a common use case, but it's unexpected behaviour which
> now causes an assert if CONFIG_DEBUG_VM is set.
> 
> While this bug has existed since the dawn of time for linux (or at least
> since 2.6.12), it hasn't caused issues in the past, so while it's incorrect
> behaviour, it doesn't seem necessary to backport that far.
> 
> The mapping is now accounted at mmap time and can fail with -ENOMEM under
> strict overcommit, and read faults allocate folios. However this is normal
> behaviour for a read-only shmem mapping.
> 
> Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
> file-backed anon folios") is the first patch at which the debug assert
> fires, so target that instead.
> 
> Fixes: 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios")
> Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  drivers/char/mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 63253d1de5d7..5b93c92c2cf1 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
>  #ifndef CONFIG_MMU
>  	return -ENOSYS;
>  #endif
> -	if (vma_desc_test(desc, VMA_SHARED_BIT))
> +	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
>  		return shmem_zero_setup_desc(desc);

What's the odds that something "big" actually relies on this?

I'm all for the change, but be prepared in about 5 years for people to
start complaining :)

Want me to take it through my tree?

thanks,

greg k-h

