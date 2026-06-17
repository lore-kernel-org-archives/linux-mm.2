Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FE5CD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 21:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEAFC6B0088; Wed, 17 Jun 2026 17:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B426B008A; Wed, 17 Jun 2026 17:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2916B008C; Wed, 17 Jun 2026 17:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87A846B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:12:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7924C2671
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:12:44 +0000 (UTC)
X-FDA: 84890653848.03.89C8AAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C9AB91C0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:12:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=tspjiKyR;
	spf=pass (imf20.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781730763;
	b=ZQfkIhOTeeUeu/CGnoLrUKuq7cYKvxboD2TX7Gq1mVsT51pw7HZHZW9jfeqVBaf6mpNScZ
	vn8BCUuYmmC6XMQG4pAjK5LKxOMwwL/+wKqXF4chCXQS8ksC3mAxexX9SCFxneQzKyRCr9
	yFe7O+Y5mZ04cgM0UrufBDD2fYXEqjA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=tspjiKyR;
	spf=pass (imf20.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781730763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxoMwppuR/i9DtykdAEUJqSQo/wPOwKCHNNYCxORxZ4=;
	b=kqvoC/FBGZsHvk3SVTn11EpNEv5xGIsF3PdU+TMc1IYbbSHXY/4H63oHJfHhWtWrBlxxkT
	76SqY85gILcnHOfNAdasXplg08rbnDcKXA48ae1rH7BBajEO3/PGrhYW4qThL/DwC6MAte
	9FJUwV7Qzif09XKemTtc8XR/IC835jI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF22942A7A;
	Wed, 17 Jun 2026 21:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DEF1F000E9;
	Wed, 17 Jun 2026 21:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781730761;
	bh=FxoMwppuR/i9DtykdAEUJqSQo/wPOwKCHNNYCxORxZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=tspjiKyR7+ce0z/gh5HHx55ffgLPkCTHpW/WDCtVwhyLp7ohosqW6mnArnLgGrL2y
	 zbZHW6ZKsuOQoZJweKQeYu/JUcePYdNA5cYR4CqkkJ61mLN9llmvZKsAeMnQDWOimM
	 N4JceczQu66XPku+JoXFL2BUYIyPWbjOlHIHFmGc=
Date: Wed, 17 Jun 2026 17:12:40 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Remove mentions of PageWriteback
Message-ID: <20260617-nyala-of-noble-refinement-ac7df7@meerkat>
References: <20260526195650.353196-1-willy@infradead.org>
 <849ad1f8-973f-4742-b56b-7d31570d93fc@kernel.org>
 <ajKj71cXOZMf6mK9@casper.infradead.org>
 <53111e55-0e9d-45f1-b19e-554b0b17e746@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53111e55-0e9d-45f1-b19e-554b0b17e746@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9AB91C0003
X-Rspam-User: 
X-Stat-Signature: 45dbbd7dckoc7ij1kxgok45z6rdk1x57
X-HE-Tag: 1781730762-870154
X-HE-Meta: U2FsdGVkX1/1npZJZWxVv7537GEkfkrtK2cD2SdWmOqEosDamLAjEUATARIdKEsf/lJ95W0PJn6QDsyrKyS/ZiNNdeLp6aaJtVkCNdIW4yn990lgKP1C5KZvFqsrEFF3AuTi+EYuMT/SbvVK/V4XQCiaxhxI79IPVzQA5+1JmyLBlFEMtCJ3OArjY8TKbJC6RY3ZNJa+ITZoRW5bUBl6YiXTGEbkAQbwcPkDPTbSRPikTqVX7gu58MkCMnNF3QPCTlV9ebR/3ilKWOR7Gw0qe+Q+qn976knGEv30oxoANGflspyjqasfRRWSguV8/zveNH79WdWdULQT8l/y3GGYoqSKnSO1lIDPhdCT327+9RysMgreMOzQWFg6z+1FpLDIq//KaeXyfjvYxwCKUCT46uel9X3GhqN2djmYYwX4LWuficTYeQbsdTT+4riRch0tzeYqRBC9mkA+i2cMJr2/OPur596ZPerXnMCuwUHysrrdA1trdqk7rLLe2AL1T82gf0Nc0zYUL6O/WIdsTwx7EbxcreoWg+rPnYCqFyNnMyChhyG4t66vw3fyo+cLbTsnFJBv9mBB7vQ+m88i0seSjBEmCyjR3pKIUIu8X8RUZKwnZL4RvJxCigIwsG3c4inkxq5xHVwjtr4ZIRWushyuZpvqOUmVXSGC87LXJ7m0aJEIL7YrB9oVtPtXmAj/tumTwyU7avTYGsm5Zi5U2IlLSiE9v23/WA45/BU5RuYQeTiOqvV7UOTcbUkO4o2GDYaQN+A5Qxc11uWJADQBFTQgoAyfi6pu+qVMNAS9lz7rWWVwitkiNghDlFs77j7Dfu82FHcSaOtJ75XcUtXQyF2EJmMt5FpyWqB2VdTB0bNrCVQIvTn/1LedIs0ioip4kncGXNyW8qGJQsmSP7/C2Xp8jN2kWZA5mLP8SiQY6U7VtN5iRU1rkNmyVzQxtvmgP0Dx5gefIbN+1RSp9nwPibX
 2agpKi/G
 c+/aabGF4CtBjHj4BsM0MVeCmlLYX+nLuPzwlOuVUy+GeOTNw+aOJwojTuRg/Fc9Z7i6lYim24Y+d67ajqlitbBnre/I/W+SEUcr2/xRBack8prnNlGW1uI4sA4qxhfglnw/Wk9vg9BBvxo0LrON/Y8bI1ZzErtJvb57y7IQrARwOPIkl+7qtkSNcC0zUJVrnVSGwybNEB7X7P4mm7U5Mtpsk3Nha5xuYK6g3IqRi+IMgQUrflFhvcTMZe1Rz05/koQpDjghuVNYLgAZDNgK2o7ibcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 04:17:51PM +0200, David Hildenbrand (Arm) wrote:
> > pain to copy-and-paste from.  Particularly when it wants me to cc Ted Ts'o
> > (shell quoting rules are bothersome).
> 
> b4 does a pretty good job for me with "b4 prep --auto-to-cc". I barely ever
> have to remove people (rather add some people I want to CC explicitly).
> 
> It manages the CC list within the kernel tree (in the cover-letter commit),
> and respects CCs on individual commits.
> 
> "b4 send" would send them out, but ...
> 
> > 
> > There's git send-email --cc-cmd, but that doesn't work for my workflow
> > where I generate the patches on machine A then scp them to machine
> > B where I run git send-email, but don't have a current kernel tree.
> > git format-patch doesn't have a --cc-cmd option.
> 
> ... for your workflow that doesn't work.

Since b4 works on special "prep" branches, you can simplify your workflow to
make it work. Get the branch how you like it on machineA, then pull it on
machineB over ssh, and then run "b4 send".

> There is "b4 send -o tmp-mail/" that doesn't send the mail but stores them in a director.
> 
> I just tried with one of my b4 series:
> 
> $ b4 send --no-sign -o tmp-mail/
> 
> Which gives me:
> 
> $ ls tmp-mail/
> 0000-mm-remove-config_have_bootmem_info_node-part-1.eml
> 0001-sparc-mm-remove-register_page_bootmem_info.eml
> 0002-mm-bootmem_info-drop-initialization-of-page-lru.eml
> 0003-mm-bootmem_info-stop-using-pg_private.eml
> 0004-mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.eml
> 0005-mm-bootmem_info-stop-marking-the-pgdat-as-node_info.eml
> 0006-mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.eml
> 0007-s390-mm-use-free_reserved_page-in-vmem_free_pages.eml
> 0008-powerpc-mm-remove-config_have_bootmem_info_node.eml
> 
> Which should contain all information, even including Message-Id:, In-Reply-To:  and everything.
> 
> I guess you could just SCP that to the other machine and send it from there.
> 
> 
> What "b4 send --no-sign -o tmp-mail/" doesn't do is update the version information + create
> tags etc (like b4 send would ordinarily do). "-o" currently implies "--dry-run".
> 
> That makes it a bit harder to use, because one has to manually, after sending, use
> "b4 --manual-reroll COVER_MSGID".
> 
> I guess we could extend b4 to just do the reroll even though the patches
> were not sent yet (to not imply a --dry-run). CCing Konstantin.

I think running manual-reroll is a better approach here, otherwise this would
be a significant reversal in how "-o" currently operates and can catch others
by surprise.

-K

