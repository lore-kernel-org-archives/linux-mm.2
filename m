Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E8CFC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5146B00D4; Wed, 12 Aug 2026 06:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC436B00D5; Wed, 12 Aug 2026 06:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2AB06B00D6; Wed, 12 Aug 2026 06:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFEF16B00D4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:49:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75AD51C0241
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:49:26 +0000 (UTC)
X-FDA: 85092295932.20.A66E5AE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id D56B880005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:49:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cb1+nKww;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aARderwjQ6N4kQxpGMM3ujaudWzwA8axkvxYGtg/BE4=;
	b=D0pvRBjku9dTgRzVaOhc5sLdfjT+jkM34UL9JgK29gYXw1Sznk2h8DQhREfMmHF4xEjHeH
	vzGK76ZnXgMxC8BqcZq4iKxbyYF5DfTC9hvqCDwmh99dlfRVsJWFooq4LRAM0Vx0iofnN2
	HLJIZsTnR4X/5xu5Robdl56UB3TF650=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cb1+nKww;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531764;
	b=A5mXQgKeh3s8ij9o7jFwVkX+0QHkFbenCxIJ57J8WWmMYV22VmW4xr8cjcjvXs7NTmUTpZ
	u2/htyg/foGGl26E6Q7untcwwEKj4cWD+M/RfYBpMKKktRy7VZ39OWRkYpG4W8sOSNJGP4
	WaZ6/UuN2r5rHBWI86crairEPIjnOC0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aARderwjQ6N4kQxpGMM3ujaudWzwA8axkvxYGtg/BE4=; b=cb1+nKwwBiZzY0YKxO+M/J4Utc
	oLwn0Cbv2qTSbjs7MdJLK9qDMiRRJXCtu7Q7HW8WhcqGmbBsK/dUEHgJlu9CCQ68HfCREZoLS4jDT
	IhlPjLEMslK8MvgKpZUWw/ygpPh7+8M5gZiQUIHwnQbyt4B2pxXSoneLA/RvSDIviElTg8Hy7jg43
	C2QftDu/PsUPkfqlpUXApLIBDmZixqjX0ybAZZ/icio80qJuLr5Z5m0hRq00S6qj7Uk8SWLXScvF1
	ZaD2XtKhO6CVzTQ3A1TjlPH1MkgZGjJLEGG22fHxxx8dPpijzrd7hUOnjzuaewzA0iXa+XsGMBvN4
	ZOQNJLrQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu6W7-004I0K-2V;
	Wed, 12 Aug 2026 10:49:04 +0000
Date: Wed, 12 Aug 2026 03:48:56 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 2/3] mm, swap: distinguish a malformed swap entry from a
 dying device
Message-ID: <anxOqNmL24Cj9A7K@gmail.com>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-2-375ef0767206@debian.org>
 <da69545e-4b80-4cd0-8d70-a73023445e9f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da69545e-4b80-4cd0-8d70-a73023445e9f@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D56B880005
X-Stat-Signature: a9iw4c1zmxm63of5f1yomp4hm7h6a9md
X-Rspam-User: 
X-HE-Tag: 1786531764-454672
X-HE-Meta: U2FsdGVkX1/Fv2TfkdL7loQlIkF/wwmD3d3Dfvr30Q2S9jEv5LtKrsOs5okdgPMTUMap2PVokKpgsVTlCGukYWUb7GrhZr58F6fLUzryCFbvk/bQHhJMq4wUVxk5m1dHv3mg5he7py4g9VeBkG6GqXLnJvVc0INOkichkUMaZBVrk9NKuAdQXxGxY3My884HS7RHo4ncCOxQ7PlYQG9ra/UrNxkCZktjEVuVvvHf+Yc/DsD7TQb/XSWHMwRAHqk7qsRe8RPp/dLT5OoumXaSrkta+/pFfuVD8bjPHefuMBlPkvbbujUe5/a2xHuXGbydzG02SIV4jA5s5+HWuTphh1uBT5Cmu1Z8bRE9cwenZp+f/0iMYWA1V+dQs8fexeHyiJfy0rJN+qe72E7VkHg1fb5UWrpGx0v8nlmmkH2CzJ2RhiIRVAyid+WR3iuyt54jTUAAjOwq6/S0Sw0WxI8DBjR1tXVx1vfRohCmtoN8Hn30zqzpM6WY90m0xKoLp+I+S7MkcY3/17GwrcgOkO58U86x91OHtgXHLCJMzi+MaZxuQQXebT0VCidlE+VNVBRG+zYHwp6e3yp3esASD445EtYzg5ZeeVz+F0XID/oU/zeeiOUpIRfMlv1TvtDBt2xvWzTQYTJ2/BuJmzEslr1DgFHIlcud/H0oEl9iCZiNNMFAkdSah8vbowGjYCorqQDGiP3ZbQSc4ZrHcHOGTB9ThVKqKXlD0zDz5pwDfxdAwX/VRGvPqboA8uamp+MIEmtE2kk8P/kZOGX8UPVasy6SW8QEN01cwPPHLBbNKJdEwh340Ac97xdAA4uDMaynpwNVK+pCbyeI3QkbK46IZVIBopMWECbg3EGVoR9hQFLAelaLp6TOiAvsBOBZrxdcQG+KGFh4/B/u05IY4XFNTjdbKcHzS/7Ma/8K5reRTvhzvuEjCLgjrFOP4Dq4KlCZw9DXVVrcibcKv1EfxY7kgio
 3qTwC+bX
 heVyQmfZjCRwD7g5KmYoEZBMHPkJ0dwmjF+ZD1LIaQv89nAjFt7t6+JGpT/uuzGla2mNupJ8pu0qQqE/6xD6xFO5BO7IroX5Jl5s7aaXHShXG/AcmZLbxsrf6b5swHCIpYGenfsLsnliJzC7vAq/bgN+vCtsOaTD+QQMrVdp2n7qvjCnaO+KEpS6FsVAzaWsySsiwBF3UuRhhXYZo+mG7fn8ri9l3X+xHz3yDeK3CZmahJzldUDNY0Ua/GI0tCioBtYS7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello David,

On Tue, Aug 11, 2026 at 05:36:31PM +0200, David Hildenbrand (Arm) wrote:
> On 8/10/26 18:26, Breno Leitao wrote:
> > +	return ERR_PTR(-EINVAL);
> >  }
>
> Is -EINVAL really the logical right return value? Running into bad swap entries
> sounds more serious to me than "-EINVAL" :)

Good point, maybe we need a strong drug here, what about -EIO?

I picked -EINVAL because it is what the swap code already returns for
this exact condition. 


	* Returns -EINVAL if the swap entry is invalid, which might
	* occur if a page table entry has got corrupted.
	*/
	int swap_dup_entry_direct(swp_entry_t entry)
	{
		si = swap_entry_to_info(entry);
		if (WARN_ON_ONCE(!si)) {
			pr_err("%s%08lx\n", Bad_file, entry.val);
			return -EINVAL;

But, I do agree -EINVAL is too soft given the situation we are in.

I will return -EIO in the next version, if I don't hear any concern.


