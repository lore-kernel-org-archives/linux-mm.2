Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A364C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 11:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E87D6B009F; Sun,  5 Jul 2026 07:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0DA6B00A0; Sun,  5 Jul 2026 07:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6046B00A1; Sun,  5 Jul 2026 07:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15CAA6B009F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:35:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 892B240704
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:35:01 +0000 (UTC)
X-FDA: 84954516402.19.AF22293
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D20AA1C0007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:34:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nV2g4cTj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783251299;
	b=mdit7ZsygTrjx7hBftRHDHMPuPuTl40igGuVDdeqq01fDJJr3ZPlj7WZf/AIHLxIamEAfS
	vKwKZLdMv6qLlW4cfwTDddqtDsh8sSax6PiZBXmEzTG3BioumzE97L8isa1l4dMlKMRQaA
	TeuNORjpXKbWruW5Ktn7G71XS005aao=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nV2g4cTj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783251299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5tukjUWikD+yXvmypS8p+hrJSvR5s26qMGQskWUEKQ=;
	b=0WAxfk8PekerFhS0g4EiECDOaI4Av7PYthux/v5nHNAdsm9HFkMRpp4VmQYmF//Ye6sjfu
	Zf2F42a7yRLLXymLCr/EnEOJu12OpUcS1zdZRZcp2OrpO50Kp269BW5zfsmBjQY3RbQAsS
	8QjsGAV5XnGmb5BLzqTSJYoEKHl48LY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B955440287;
	Sun,  5 Jul 2026 11:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF241F000E9;
	Sun,  5 Jul 2026 11:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783251298;
	bh=a5tukjUWikD+yXvmypS8p+hrJSvR5s26qMGQskWUEKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nV2g4cTjYPDzHQbmjJgpTx3yJ9aufUXGyfYJaCKdBvFt1h6DvrlFbl/MnhrZQiFEZ
	 3dNix56N/U76Co0EvxMMhjFx8cV6XOIaCcwsAwv1mi5Qis4anDQPWFqsHxHRPZh6gT
	 52wBlT0+Hfv5TM7RXbPKuE4yPGyejZf/+9AbOe2LB+qiCpyVVI+JCc0PyO5//CjAEI
	 lxLKJlZhEsOCujsnKSbqvvR/B6Zu8wyQtuZ1QOUA8IlWeI66qV1MkMN4PDDCoIq9wB
	 Auk/ERaD3iUoXfybs/Ci7a4gCJM/RW68gAquQIZ1YG6mGgKCwWQPOAXoGxrliyG/Kv
	 v7WcmnVFE0uKA==
Date: Sun, 5 Jul 2026 14:34:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
Message-ID: <akpBWmnujSnj1ZEE@kernel.org>
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
 <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev>
X-Rspamd-Queue-Id: D20AA1C0007
X-Rspam-User: 
X-Stat-Signature: rbpbqe58b8b9fj9hzywbgyoamxbqpzf4
X-Rspamd-Server: rspam03
X-HE-Tag: 1783251299-257829
X-HE-Meta: U2FsdGVkX19nuELp5/MUs6mQdUsLbRonA5wJ8SZe43nhTTsPnckEEvYKhvBwFkxtreKlppXpnMNBEkJUCe+Akseu4EZ/vk6wJuGR1pieOj9GbGGiX+5AKYtko7wT6lxX9QPYhu7eHO8UVB4iROtdk/L6oeQcxIpT6K0zhuiiRdlIs2gRj82W0FeJGoTsf87qCQ/68IykfLREPupLAuecVMzdQdxlraFlPeSKlx8szTLx50N5g9Z2EQ1EApwGVnulPb2p467nDwDCn9X5paekC7i+8GdjaYUbUCTIZq6chw0VTlVPCx1yYxYp9Tq8z5U/rCdTKSjBbPl5NZFegU0ZFgqXe0ooYNBWKBY3cQlKZF1jTXOeeQiGyPzd8hvP9GjMeMtA0QywQ+Tqe7xnjy5kldUAQ4t34yQlGyKqw56UxiekHrX0KVf2N8OTb9R9RvqkMbVRukDJI1zzETdEV3sA0kqAYVGz5pkgWdjytC5S56p1yzYSADu/HA5e5ZiHokD9FzT+4CVSeDzQcUZCAJbYeGkBHoRh/g5Re0msyzGwjhE8W1kVf7ifjrVT6yCCwU5/c6RZG7zOAtC7DniISUbHfaXemjrM9UG8IiYJYII58w0Ushf83uEBj3CkULovrfDhmW0BfsxS45b/4+VtNz6QsdUkcsEX6AdEaPxGngPxLNcwJEEnrq42NgqXZkzT1c1qe3exG2kDurv5wqQfinwm+aVBbzeSThbHaW+iIDmYOnQ6ahjszX1ROO+irdlVThBpucHx6lmLO8O95QIQq324HQq1Fv3F1Vn95ZPC6w88oGej5mgsvvnqWXuqvGLcRVP4CJXKKFt4nvifGNYY1GgTjBViPDkJ3bY0hiCvEJTONYaOFyXmbr6O6dF5el6HIBZ2cAVJXShj1J8s0PPGux8k/pK3++sm1xo43/+flsi0DnYu0AVDUXZAybWZ1iKtEdPq42WeWMwnQp6n4ZdShvX
 pz+0Oq3+
 ts1GQ6A0kFzP2NhZ3/ZDVbwzmSxTckoqiRshSdR34JTLpjDm9q1xaavn63H0yFwWjEg0FZGNchkSGwncZlanitB3PuWjziq48GJTHAEHGhxiW24fI70VOiZYIBTIprl+0pUdtnbWekuMO7g3ervORuj+QzFl7v7gBBXeUOo99gIBKQU0HIwPj58gtoU+FCKYPIaYfn/2+K2n+hyOYgVEm1OAZyZaKQdeDL5uWFDu1vvokBdHSYdrUSp4xRO01oJzF+a6m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 10:46:19AM +0000, Brendan Jackman wrote:
> On Sun Jul 5, 2026 at 2:26 AM UTC, Andrew Morton wrote:
> >
> > Well OK, but the secretmem code is still wrong.  The patch protects
> > people from hitting the bug but leaves the bug in place.  Surely it would be
> > better to fix the bug?
> 
> I don't think the code is wrong if highmem is disabled. Certainly
> there is an implicit coupling between the .c file and the Kconfig file,
> but we could always add a BUILD_BUG_ON(IS_ENABLED(CONFIG_SECRETMEM)) to
> the relevant bit of code to make it explicit.
> 
> > Is that as simple as adding the folio_test_highmem() test?  
> 
> This would fix the WARN+SIGBUS but I don't think it resolves the fact
> that this configuration is completely untested - there are likely other
> functional bugs? But more importantly, I am not sure if secretmem
> actually does its security job if kmap_local_page() isn't a NOP. I
> think shipping a "security feature" that doesn't do what it says would
> be really terrible. (It might work totally fine, I dunno, but it would
> require some research and deep thinking that I don't really want to do
> for a configuration with no users).
> 
> > Or switching to GFP_KERNEL?  
> 
> ... Oh, that's a nice idea though :)

GFP_USER if anything :)

But still with kmap() and friends not being an NOP the promise "kernel does
not map this memory" does not hold.

I think that keeping SECRETMEM and HIGHMEM mutually exclusive is
conceptually correct.
 
> Any thoughts from Mike on that? I think it might be just as good as this
> patch? And then you can still use secretmem reliably on a 32bit build 
> as long as you have <1G RAM (or whatever the limit is).

With <1G RAM there is no need for HIGHMEM :) 

-- 
Sincerely yours,
Mike.

