Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABACCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 05:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58CFC8E000B; Tue, 19 Aug 2025 01:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564F88E0006; Tue, 19 Aug 2025 01:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453CB8E000B; Tue, 19 Aug 2025 01:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4C28E0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:20:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AEA5C0297
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:20:14 +0000 (UTC)
X-FDA: 83792355948.04.2AC072B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B0C02A000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:20:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XMNHGDun;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755580812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mSHHKkoWdlpf1tlPQ1om7QWkC8Mo4mgIb3moNHcDws=;
	b=jVwrMNmYriMigsbnhEsc6YIhcxGwvDIZC6DbS8VEBxtyRvsqr4AvAr0G9spnfwZ9RgCxiQ
	0tiGLuk1owtrfL6kNSPGf4a07ufAwnLtZLgblO/8MlVDZ3J8aFjvSvHtxptedX+AM4c7fW
	CqDzzXzu783Y+/yVYpv6NIk90Rh0SAU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XMNHGDun;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755580812; a=rsa-sha256;
	cv=none;
	b=FoPrWyFFq52jYF6PBkv6p9OFR72jIaMAbCXv/4wbew8rHvDViH1a18AQzojuB9bip+tukn
	eyGefPvIeee1m2sP1x1zpRLhvU0QFyWnwzX/P4KniK2bLQaSdsWbMk8dTntr5BSXkUzGjV
	kWUO7WjgRO46JuJlPLhZ+G2QXNt0UrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A547E613AA;
	Tue, 19 Aug 2025 05:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD00C4CEF4;
	Tue, 19 Aug 2025 05:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755580810;
	bh=sxJcUwVN/CsHyd67+5zfW7soLBfQ8ItPLkDXT2omVZ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XMNHGDunAL2ROl6ZH05LV6ePww0er0HEGB6KXTCa1LSzaqIHkg2w+DYblTi6A4w64
	 nM19hkZyotNbVnUHaU4uIMKNwmgobuGOn/yFD+MCyZoQyBbVOSqYrT1Eac5WGaESfX
	 E/VAseYRw6+B61BDDRGmni0hh5vQKFQa5OLvan1Y=
Date: Mon, 18 Aug 2025 22:20:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
 shakeel.butt@linux.dev, wqu@suse.com, mhocko@kernel.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 4/4] memcg: remove warning from folio_lruvec
Message-Id: <20250818222009.7f03b557e6e1b58cb0a100ef@linux-foundation.org>
In-Reply-To: <aKPkWv77HMOQwyVi@casper.infradead.org>
References: <cover.1755562487.git.boris@bur.io>
	<0cf22669a203b8671b6774408bfa4864ba3dbf60.1755562487.git.boris@bur.io>
	<aKPkWv77HMOQwyVi@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0C02A000B
X-Stat-Signature: 55qk9emwyh3zg5ynkj5bumwfazgh6obg
X-Rspam-User: 
X-HE-Tag: 1755580812-627591
X-HE-Meta: U2FsdGVkX1+f+ECd79gCAs4Su+Di0ue2MfPbzvgQlqowKlElivioq40jBAAFAmx29WFaNFHe7FCuddfzxqhQX8DVk7EP5yt6YfQTIbvte6eAcu/1bygkA1d9oVXn+7X7A1MnAeLg7nWLDJX53khrBi4GJz7GWXtIidBlv+yJXqmlVdDHysHfU70ifK937VRC4TaQqRxVj9EZHlL1giJtx95aef7wO8sTE5PE764vdjrpZk5T4MIQeBpmcuYdEXebrPak5cDjuahNtnDQ5Y5U4V+7SPFGqkVBAuJzAxGSah1Rqi++lzwdGYH3CwM07E4C4Z0Bpp6uasASKyOlEnKxYX0IeUtTfuKCYtsH5agAkx79xvAICD80pZWL73VLq4VVqXIlMPOt/kCxyZeHobCksPLPCRMx9qNUfBXN79AeG7GJ+uuq2tfF2JIS4frEgA06RjGcTy54mZ0OlP+k+WZIIb68g9DHRu5GwS0oUIogNpdei+KE1n9h+2O3bb0E3/jnRZvTuNvqwl+S6I6lRs5G3xxuDEeohVuN/qmfzr4ImbZT9b/oy4jjDvQr4xa1Gte208ZMHBxJ9AceaPdydHUxoT8rE1nEQ6MRYup9FPSJabd9744A9zOi7SDVly/1whfZH4i25tck0xrMEtILRN3BFU2hIS/B7KkOcSE3Lz52MA6Man093bnp8XN8uZ4eehlbJQtH48sYm+v+cRIzs4+UUWKcBpPR+PUMlB79lmWfLzLW3FvBzJ3JUZr+t/1tGOEwMR/uRM9SNCyqqwWacvfvqAsiTm3OwxajOt3hw3PTz+8ZmPy3D+gOM2wHRc7kStalVMxyaNpKj4mN/1bVbed8d0lVO+7y3+giEx/UoWVRNwq1PDZBDvig+2eVWl9XQ8AJflU7oXuytv2+RPJ+wbnY4hquu9678NjE7f8Lpu2RgOi9w/hNg931LiQ5HXlJilWzHFVxGDG6eEaFnpFlgsm
 fPnSRYWM
 GqO1nClZrkPikKfg5og6gLW3sCLFbFfd72Rmge5+uTiaeQCgWZKYqdDVS7TZ06bRq+bIEBbGu3mRTnKf35iylQv4t21/KtmFwI2SseGmohO7LAHTPBGcjbLM9aGO7NBVOBb9ESNG18lWp0ESIUnYL3X18sMSSZ+a++F/f3zXQQILuuU6epW3Gb/yVNfUm5XPU5j3j65X1FMfpXOJ2RTfPuQap5sl71K+Dx4xor5EvHQpe45SUalHoJ62WRlAI4eRuJ+vr5w9bthr4XWmOc80dFFoQLgBslt+OM8JXAlFLdTgDFyu3e19n3T5VD4MlmvtP7qYwt+65+hKVZkeR4VkNXZccI1uuKKxa2LL6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 03:41:30 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Aug 18, 2025 at 05:36:56PM -0700, Boris Burkov wrote:
> > Commit a4055888629bc ("mm/memcg: warning on !memcg after readahead page
> > charged") added the warning in folio_lruvec (older name was
> > mem_cgroup_page_lruvec) for !memcg when charging of readahead pages were
> > added to the kernel. Basically lru pages on a memcg enabled system were
> > always expected to be charged to a memcg.
> > 
> > However a recent functionality to allow metadata of btrfs, which is in
> > page cache, to be uncharged is added to the kernel. We can either change
> > the condition to only check anon pages or file pages which does not have
> > AS_UNCHARGED in their mapping. Instead of such complicated check, let's
> > just remove the warning as it is not really helpful anymore.
> 
> This has to go before patch 3 (and I'd put it before patch 1) in order
> to preserve bisectability..

Thanks, I'll move it to [2/4]

?  That requires changing the tenses in the
> commit message, but that's perfectly acceptable.

I'm not spottig this.  a4055888629bc was added in 2020 and the btrfs
change is in a preceding series.  I'll describe that by name, so

: Commit a4055888629bc ("mm/memcg: warning on !memcg after readahead page
: charged") added the warning in folio_lruvec (older name was
: mem_cgroup_page_lruvec) for !memcg when charging of readahead pages were
: added to the kernel.  Basically lru pages on a memcg enabled system were
: always expected to be charged to a memcg.
: 
: However a recent functionality to allow metadata of btrfs, which is in
: page cache, to be uncharged was added to the kernel
: ("btrfs-set-as_uncharged-on-the-btree_inode.patch").  We can either change
: the condition to only check anon pages or file pages which does not have
: AS_UNCHARGED in their mapping.  Instead of such complicated check, let's
: just remove the warning as it is not really helpful anymore.


