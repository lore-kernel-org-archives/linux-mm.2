Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885B9CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8466B0088; Tue, 12 May 2026 09:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41A36B008A; Tue, 12 May 2026 09:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B2A6B008C; Tue, 12 May 2026 09:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BAD56B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:18:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25ABA1A04B3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:18:07 +0000 (UTC)
X-FDA: 84758821014.25.4B28C15
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id DD5F220014
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:18:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U0nleVlK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oIVcWN9O;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U0nleVlK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oIVcWN9O;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778591885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suMYel1hUEuILupPXvkjppmiXwI9Yx6AJKPij/Mwk2o=;
	b=EkqEj1PxE0IZhySAdL6aDx8BVWRUhPZ1Kijc7OwPjqZAe3vtulXGB1/42CEtLHHOohg6Bg
	imS2bSgGycym4pkqd6v7jjMTlv0fJQQugaE7W8tU+8jwiLm444T0E0Cvb8duWvHRoFs7JK
	4UcZxEV/kslrRkKwaM0vck8DVFEdeIw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U0nleVlK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oIVcWN9O;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U0nleVlK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oIVcWN9O;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778591885; a=rsa-sha256;
	cv=none;
	b=tCYF4vc3DvQutszNQfn1w8RBPAGQgfYCfM/Ma7Dwo0T4Z2/GYCnbRwMORb3Sb7dp0IG/f3
	pcJK3NnMplKyNpJDF9NqwphdzHLxt7kOstwJ2mDoCKBTFRBk0xtq5j9h9CDHQvmDbnXLZG
	svC+L3AzXos9gHggBQKa7uBqyTERg28=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 227A376204;
	Tue, 12 May 2026 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778591883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=suMYel1hUEuILupPXvkjppmiXwI9Yx6AJKPij/Mwk2o=;
	b=U0nleVlKAnB3tsHfRCgRC6dzgGot549EjqBJeTfQ8Nl6T4V9G1m4QKTyi+H43DFTYTouMt
	ig5qJsFMg6SY4e6PTnubBAexXnit6NFgAFmPKI2s74+IlPcRvOapyHNxvV6A17cxMI1Yvh
	rpYZA0+HNbXI8ndm4CBydR8lj/cDIdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778591883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=suMYel1hUEuILupPXvkjppmiXwI9Yx6AJKPij/Mwk2o=;
	b=oIVcWN9OZYMKaCbOx89m3Hj6rdmlQNrMtPKQeuM4T8bvuZy9XG/1vyOxjRQa7OgZSBvOj/
	hz49PCysV6otQlAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778591883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=suMYel1hUEuILupPXvkjppmiXwI9Yx6AJKPij/Mwk2o=;
	b=U0nleVlKAnB3tsHfRCgRC6dzgGot549EjqBJeTfQ8Nl6T4V9G1m4QKTyi+H43DFTYTouMt
	ig5qJsFMg6SY4e6PTnubBAexXnit6NFgAFmPKI2s74+IlPcRvOapyHNxvV6A17cxMI1Yvh
	rpYZA0+HNbXI8ndm4CBydR8lj/cDIdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778591883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=suMYel1hUEuILupPXvkjppmiXwI9Yx6AJKPij/Mwk2o=;
	b=oIVcWN9OZYMKaCbOx89m3Hj6rdmlQNrMtPKQeuM4T8bvuZy9XG/1vyOxjRQa7OgZSBvOj/
	hz49PCysV6otQlAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3289593A9;
	Tue, 12 May 2026 13:18:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aWv1NIkoA2oDSgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 13:18:01 +0000
Date: Tue, 12 May 2026 15:17:56 +0200
From: Oscar Salvador <osalvador@suse.de>
To: ackerleytng@google.com
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com,
	jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com,
	mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev,
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com,
	Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Open HugeTLB allocation routine for more generic
 use
Message-ID: <agMohIaXKLlBKM6A@localhost.localdomain>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DD5F220014
X-Rspamd-Server: rspam06
X-Stat-Signature: dw5japzuo3od163swsmsr1q6c4s1nd4w
X-HE-Tag: 1778591884-942569
X-HE-Meta: U2FsdGVkX19LIMX5LLWHqaqt0S2BThPYFokvlOiujPLNgqOvxr0Jfnb2uGhWihTYzV6jfCfXWpU2MpG3s+YvrNNQpSYi9JSwa3bxJ50VL3RscLHeSEsBBGAVQlYver0N6VFrrqYkSMuMjU+VqhYb2jj94wmfuaLY4VwO33x310MzY6H44oZyiQjhC2RRMXexq8blo5kh1ag8NaevYArc0uXU2xo+ySPY/ziZuQ20QHBG1DwAwxiN4cmeBj+5AMla50IriZpTEunolalpfc39jU/+TrJohgjAjcBtdNUrRx3fb/z9t/8MCs2E9SF0BHhfS2UByXNJsUzYsc6/Rw/UlpEfTC+JvIcmw23oVdbVcpD+g08xPQJUdyM3CgP6yeshi3pQ3Tzfaxj0XBdJ21lC1gYLG4pqLglzDqT94Okxkya8dbHZ/Ch8Thr/6m9M1bNRMcgRny9TZQ7aN7yTQJNZY4O9HdARbTPX/hASp6N9RKsXXiCU5yxrfhohQ8ZIx3I6UFbeai7KLnGBamMUv30HeVfYXV81eg2rErF9AJWWtdz0WJAV3fiPhpJ1wHD6VudyIKZdVZe5kWLtVIhLAMFazq3AmBlQm+OuuCcVuJZIN8jFOtY/MpBjTt0gAZtQuvDidNe8WxeHSA0GhrGTQ6Acs+qTt3R48fWsUrxiOXQwzrJnm12fbH/PVI/oxuUXgtyLts4voxc/i5sSbWI6X9iJi2p0MsZ5TdqK67W4gpIN49DXKJOYB3EHjSGH8FUKFf6I9dostr5C+3G0gNSJvYpmSMqEbVCumc/hy9ZWd3wKhcPzX/rWNDTCdwDmtPCjLKVZVYL4PqS/Vp8pHDKYAZ9xu1SM2q2jH8sYPjcYSWPm2WPqoiu+d/OyVLDVip9RISjCGuGqx1XlUjatvhmR95bpbOOrykVUOPRzEq6ZHzIsl2aNKghyiGC8rsiOWTDtZLm7ysCUV+wAaZ6+pRh17mp
 Dhaldt7X
 t69VRPjWe2xIc9y5/X0ddh/VY2ddfzySPp1plfrT5ui+4CDLMuv0hoDzXcxJKhyGHKbCXUkpW6nWWVZUr/L+Eqol2pn/+G1WDbCDR1g1Zh0+QMM5dIVGMdaH+Oq03hcHBUNzhCAdtLmBRDpTFRuWQ08zeX2DSw6FH8Db7oz4q1pdx4G4HtHFMs7zIxtGX/oE+624QUA4O05XuJuLu2rdUIgaiQvtiyTKNNT8w5ZC7wgnb0Ry+8XvHxQLgtC15kMTUeNtlbfAhrxZZYoQSZ0mRBXZSWnAQd66VAHm19getgDVR6YlzHv6FatYXMfJcGUkjkiedkv/4mnVEKkKVrl5XHXjfc4GCf7wC5JFouUCMOPJvM6yxizjzZtb69nimKK5/QNM8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 08:54:36AM -0700, Ackerley Tng via B4 Relay wrote:
> Hi,
> 
> The motivation for this patch series is guest_memfd, which would like
> to use HugeTLB as a generic source of huge pages but not adopt
> HugeTLB's reservation at mmap() time.
> 
> By refactoring alloc_hugetlb_folio() and some dependent functions,
> there is now an option to allocate HugeTLB folios without providing a
> VMA. Specifically, HugeTLB allocation used to be dependent on the VMA
> to
> 
> 1. Look up reservations in the resv_map
> 2. Get mpol, stored at vma->vm_policy
> 
> This refactoring provides hugetlb_alloc_folio(), which focuses on just
> the allocation itself, and associated memory and HugeTLB charging
> (cgroups). alloc_hugetlb_folio() still handles reservations in the
> resv_map and subpools.
> 
> Regarding naming, I'm definitely open to alternative names :) I chose
> hugetlb_alloc_folio() because I'm seeing this function as a general
> allocation function that is provided by the HugeTLB subsystem (hence
> the hugetlb_ prefix). I'm intending for alloc_hugetlb_folio() to be
> later refactored as a static function for use just by HugeTLB, and
> HugeTLBfs should probably use hugetlb_alloc_folio() directly.
> 
> To see how hugetlb_alloc_folio() is used by guest_memfd, the most
> recent patch series that uses this more generic HugeTLB allocation
> routine is at [1], and a newer revision of that patch series is at
> [2].

Would that be

https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/#me2152fa2cc79d651ecea7a2bce8b57725fb57465

?


-- 
Oscar Salvador
SUSE Labs

