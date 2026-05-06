Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFD9CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104606B0005; Wed,  6 May 2026 11:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC4D6B0088; Wed,  6 May 2026 11:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018D36B008C; Wed,  6 May 2026 11:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E19D86B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:38:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 909C24022B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:38:46 +0000 (UTC)
X-FDA: 84737402652.12.30D3FC0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5D56C0010
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:38:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=qjjIyhLA;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778081925; a=rsa-sha256;
	cv=none;
	b=wh4ECY1YXrBzkjDjMnVqncAMQ1L4rMKTUo8BsHV/RzyO0ZgJ0WDAmA+pq9I38NHY0IGhMY
	hfR59iYc1A6OuPBiqjxq0HNqzS+J4qLVvCP4tmj8ZFhEhZ2srej44J+4GZ4nb4BTGEhzrx
	wFwsvl5B9VXnf2bkvOrD69JJJllIxcE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=qjjIyhLA;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778081925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBfSkJ+ZAj0IKZzbsOscWzm5w5IqhoP97yR5c6JXd3k=;
	b=2aiOEZ5JQSIBxw0uEdM6hx5MgMSTkk8OxH6DoN/1O0dXIOkj5kCqBRDJkIVwVSNve/FcNg
	HIJzb/fHyZ0qbK6l1akEAnsTpEXzVfgsIVok+BFLxPcqyriO0blchfQdtzmoDh0Zugd9U6
	qdJ+euq1/zUuw9Oro+Wf8sQziqBTNFE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HBfSkJ+ZAj0IKZzbsOscWzm5w5IqhoP97yR5c6JXd3k=; b=qjjIyhLAYnp6+fzWGNQYHTDfMM
	dcIQug2wJEoUes3iojqwilgyNfsTZZsNzrml2u7hAOlBUPV0mOaX18+f+P7JfyKKGQkap35JtApTr
	GGMWo3Xeu1KhmejaIkkUaEHNyTRQFTpchGsurCCHxS/W3A4q7GtjSQyRzJdIMykPhyoWB2bgEwAZD
	m0/7Y2fFAL27EFjrhAWkplpJLJIfpj/o/rPphT1s1BC/ybLVL4N3JUjn27m2jUVvlV+km7EtU3wC/
	cp8mO5EBcC1Fn9qKDps0TKo3abv9aNbX/P+QdjiTrVIoKxEy6ZEtW/v159/j/NKqqzC8qbh7psgKR
	7A+SG5KA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wKeKL-003glf-12;
	Wed, 06 May 2026 15:38:21 +0000
Date: Wed, 6 May 2026 08:38:15 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 3/4] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
Message-ID: <aftfTpgyLRhXPSLm@gmail.com>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
 <20260424-ecc_panic-v5-3-a35f4b50425c@debian.org>
 <20260424054840.a63d80ed01b968caf9d9ef64@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424054840.a63d80ed01b968caf9d9ef64@linux-foundation.org>
X-Debian-User: leitao
X-Stat-Signature: qq78oynp9s7eeed5jjnndys3cnso6hjg
X-Rspam-User: 
X-Rspamd-Queue-Id: C5D56C0010
X-Rspamd-Server: rspam07
X-HE-Tag: 1778081924-473607
X-HE-Meta: U2FsdGVkX1/oe8akMY/gC+feT7HxiXumGbb2Mmys0EHncWu0ATAizr8MIxTkRllvR6Vli+NrEk251KWtV42BdfQjUtBz05dyJrTvNcKGsC8m328cwvIZLgl7sdOH00xC4gGUzxMu+YinP98F7QQqcnTOzL41+21Y5q/C4G9B6OWrindkZRuIYtDyBT08ixv8lFdUXv8obD46rAwFoIhgLKoOicucC5gnxZt3XpHZ3rx+irmIOMk5Z8IvFXi/B+UJZqSvKH/BzY9w5ApA6YqCdBTLDGqWpuEaE70ahR2VelD+B0evm/eUOxshuom4MrkKOMB9qfDN+lQP5I6Z0qpt3PXWwppZGPkalB8AcQpA7xXWui4E2DFLimoveZFqx9fr6xsLK9WvH54ExsxtwLTb5hzMywnEakZ8/qN90TY7mjMx/sfrV61h+k6CLlRKIChSiC2ofrcbIyxobMKi6ZU7GhgCDmZBf4zIJtIcx1FZFTMIs2ay4aCV/jAJ6W16bXzlItqk+FTs7+IU6HqXeZpT5RRnFsyUX0JbpJGi3X5ioJ99GVlQGkO0sou7XUoF1R07nZg7XVae6Mt64Rc+FWXkNMcMqzUYJuG64JVe3ZZqaUMMiI2br241+lnkAy6/usANkU5M7Iq1ECvFLKzSwtv87vlVkk8tJeu3GqIBBbGNpkCbsikXeA3vm+Jye4hW5YuAmD6Z0Z405cHO93ZcMinH1FeeIYsuZSnmq1Q+K71AnKKyU3aD4scYreISVYoTRaww05IH1HhtAU9A4jzPEx8DvFMlLSNbf+/RUjB4Q4o1oJXSNRZuf3znJJV9lSdzVDM3v9xHU3/FziLuHQN3IwZX6KLVUP8uWRqPZt1SwJ87w3U6zzc5W00gtCm8/Q197FCm/VzctCJmUftJw/bWKnGN0U0+sLSCAWISG8QZ9j3u3JwGZnEorayShuraDblM+vhu6lCpTCRECM8VxOYPOkM
 BNMb4xzR
 uYImlhxxYv/cCq1e1EoydYRhzgS9xZOwswAi5QoY3jt5AlIhc2c7pLWwR623AI0mRqkNrOn7LLpQe/naPAJ9RRF2gN/DLFnkLDv4k4N++dV92J6jR6PhcB0nMzSoKLhGPvAgBB2UWUVUvwdSuaymRkp4FIAA1mrBMhXgsP53KIdOVJ6ooXSTgjyp/zO0NGJb7MnVVNxkz38O9A0t0rxkoa37c5dLzyqSLtq6T31aSSQEdwkM/bxXCdokopZuOqhXwuNgc2+scrgD5+hUycoszPvj7kjkTKs/1t9utRVBBEb3+fGti5Qda9rxaDt7ALHxJJF7s808siiqZWh4TxapIIAFbkHdJp5gPu4KB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 05:48:40AM -0700, Andrew Morton wrote:
> On Fri, 24 Apr 2026 05:24:01 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > Add documentation for the new vm.panic_on_unrecoverable_memory_failure
> > sysctl, describing the three categories of failures that trigger a
> > panic and noting which kernel page types are not yet covered.
> > 
> >
> > ...
> >
> > +When enabled, this sysctl triggers a panic on three categories of
> > +unrecoverable failures: reserved kernel pages, non-buddy kernel pages
> > +with zero refcount (e.g. tail pages of high-order allocations), and
> > +pages whose state cannot be classified as recoverable.
> 
> Before someone asks, I wonder if we should make this a bitfield thing,
> so people can select which of the above three should get the panic
> treatment.

That's an interesting idea, though I think the necessary infrastructure
doesn't exist yet. As discussed in this thread, even distinguishing
non-userspace pages from userspace pages presents non-trivial challenges.

Implementing a bitfield-based approach would require significant
groundwork. If we want to pursue that direction, it might make sense to
defer this patchset and focus on building that infrastructure first.

My preference would be to start with the coarse-grained approach
(current approach) and refine it incrementally based on actual needs.

