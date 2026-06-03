Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27F7CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9236B0098; Wed,  3 Jun 2026 09:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A106B009B; Wed,  3 Jun 2026 09:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F6E6B009D; Wed,  3 Jun 2026 09:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B77976B0098
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:50:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F9928D424
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:50:54 +0000 (UTC)
X-FDA: 84838737228.17.38F8024
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E698C000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:50:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=NKcYAKGx;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf22.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780494652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTnOwFQTcngYAJlRJ+MALwnYXJnPHJMI8XzuwQM5fsA=;
	b=ziacpheURzcsafUI51yjya6fUpE/xTC6tGc+MiK46WXbhnyyneQgjGDPVZWRg/gLUxMlgT
	UYXSRdYvQZj1OWL4/+14JR+jxtME60rwzDb0WSq585YTqzCdJdPCnaOn6jSUpik14z8hZ8
	aCYgpnand9v10JbKlScHuVjS5Ac4sUE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=NKcYAKGx;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf22.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780494652;
	b=jDCwFh5m5ujrAuPgmtW7/yDBwvVZ2dYLqiv74H9/9mYEQ2WBeiMbyjj7PZqf0EUUoXr/Y6
	pl3znLvTNk1zATvgrqln0TrTOxnaddbsVmtYWofUjorlx49z7oXUuCqR5gCKhRzvFzWHgF
	OmDQdDvkNqeLUK+RftCfZMUTjw2+oM0=
Received: from macsyma.thunk.org ([104.135.218.91])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 653DoGua026124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 3 Jun 2026 09:50:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780494624; bh=eTnOwFQTcngYAJlRJ+MALwnYXJnPHJMI8XzuwQM5fsA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=NKcYAKGxv8EQp4lu0Z0XBUSCuzI8zHt6mSdzmhjZxsjes/74lSNhp5mTUiBPz5k7I
	 x8n7bSOU7bbtds8bbysVLNkhfWhfAJ9+zVN6pbpzfH97nswhrYuebBvNn1bpEVRv9F
	 h3F46hxr/d0Urs6uXUoPKJZkXjOsJAkWZxHSpX6RUxqdgnAJtnWqsoxQ1ODjGatAq2
	 egcWnlC1JJLm3JT+IcLoY7MsPVk2BNMRySRvtjtxIBEMmfy5Nw9WYXUQVga/xho+/b
	 6tF0c35IXZQcou4LetXdv+ISPL1QtWHKiOcrJscYm+tLkqpr6a+ZA3gbcU+JbvyI7c
	 j1FmXnSnSsgHg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A909035DD60; Wed,  3 Jun 2026 09:50:15 -0400 (EDT)
Date: Wed, 3 Jun 2026 09:50:15 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
        NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Kleikamp <shaggy@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E698C000C
X-Stat-Signature: oxxj4f6c9f841jxjh7mzce8mu6b5e6g8
X-Rspam-User: 
X-HE-Tag: 1780494652-656017
X-HE-Meta: U2FsdGVkX18Gbjv9/iBZLWkd+g9mVrumFG/hlfNlPbw2bi2eEi2C2PAcDcf5nCYSqOBmFucMf6YslD3Zc/MvrwWSqnAGEHSukKCFoWgpieZHpmTFATIskFYPecKnFoqQMv88lOFOeK010hTjmrSbLCbbKvg/0XkVOBJjwg5PtN9Kekbq2Ggy4fgebh0iLi9RKlisPkhGlwf0rAoq71F+0+f2uN/4RsgeYMwEb/7JkNwQlbpgsxgiMTe+4VbkOe+HGDavknBdmPprhMiWnXe3z8XT5403HAcla/931Yqr2ZM9rhF9h20T323QgOckFJVCBWLnfweuCt2K6Z5kobWQ8gunn/RyexKG+DIFBUEk5UgPPUKLOJQOpC9ZdSuOx9H5dHg2aOrh/sTuVOQfe9M5wmfSYw1Pv3vD9b15PNe33X7sImxnTyZPfHSvLUvczjeEFgxyyQEql8MIVNvvVBRFdYPsGe7y06KTpafCwagPkmZrD22U5Ftl4jkN3ggEp5OJ2+BHLR4n41KrpNUmdA3bUl9AONNrbf/8ZQzA5iB7fNZPbM2ONtr11N9l5PFkNSjt10hrw0J6tpTwwStSGR4Zc5tFfUe1ceSA4D0MzIGbm38m/iyRbGiCuq10fQM+wIpNmyZqHLH7j+H2hnjCZqynWUQwir7POVQ0xZxfUCKPVdkWZRDxg/A8U4pMNjDCQUlgGfz/2+uq10hFeAgNpkvzq7ggvkqqR1WcM+gp6RlmxpjaUrkDNpxcnNHE2DbHS4JW1XLYA6cZPkoqY81C7ayGJ8HHDyZIwYRZ1B+PCTN/L1sDZctRGQYuZp3NUKwHDRbDwipKYcdR0FzAKZQFzXAqRUnE/PBfcesjNHS5TWXh9Dm+uzCVixEBFvaDjCM9NrVzH1evCFnZGhA4vBaRoDWTRiXBIfQ2ucQ7zgsDeHX7/LzM/B9GG6TEgkMKTlFAJFnxtdv9KZg3h2GVulrwVuO
 8FydOk9A
 wE0WPCkmtqbItBS8ngMOtlMnwHnYB77+Y6kibrLj5H0nE7hwdGkxxBRB8tSaf68QEbZKuKp5MF0k7AJ05ZQGf2HxDW8KPhdd0osVevQnuAZzX8SmAitQ8X8Gcu2NbOvKYBoJVupCdNXkpevnATxToMnmvHwzBkYm8bbRZ+pulNCgMxKdkCXcH1LtbsKWQGi2AH87WqpAQIlIAmtr6BwqjWvqLBMpQsNyKVtkYMN4PGv2tBA9Sln4bL5XqgUi6Juy7E5olm833OWgZZkZpfh8iYkI38gaC0uNRGUTXI+slfmzMiXoJIzw3JgGfikGZZBVQ5Kg+o3/IvmU2sRbDVstBc8sjf1qhgoLlVG+qXzgSHCds8os=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 23, 2026 at 08:54:22PM +0300, Mike Rapoport (Microsoft) wrote:
> jbd2_alloc() falls back from kmem_cache_alloc() to __get_free_pages() for
> allocations larger than PAGE_SIZE.
> But kmalloc() can handle such cases with essentially the same fallback.
> 
> Replace use of __get_free_pages() with kmalloc() and simplify
> jbd2_free() as both kmem_cache_alloc() and kmalloc() allocations can be
> freed with kfree().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

So historically __get_free_pages() was more efficient than kmalloc
since previously the kmalloc overhead meant that a single 4k
allocation would take two pages instead of one.  I'm guessing that has
since changed?

Can you explain to someone who hasn't been tracking the changes in
kmalloc over time:

  * How does the efficiency of kmalloc compare to __get_free_page when
    order == 1?  What is the overhead in terms of memory overhead?
    I'm a bit less concerned about CPU overhead, but it would be good
    to know that?

  * What does kmalloc() do when a size > PAGE_SIZE is passed?  Will it
    return contiguous memory, or return an error or worse, BUG?  And
    same question as above; what is the overhead of kmalloc() when
    size is 2*PAGE_SIZE?  8*PAGE_SIZE?

Thanks,

						- Ted

