Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F413C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405FC6B008A; Wed,  9 Sep 2026 13:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6D06B0092; Wed,  9 Sep 2026 13:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD006B0093; Wed,  9 Sep 2026 13:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14A126B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:31:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 565C540286
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:31:45 +0000 (UTC)
X-FDA: 85194916170.14.8B921AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD25B40016
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:31:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2aybex3;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788975103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ubKjcUHJ8BQDEwwualgzTahZHaTSfH4i57++l4iDsE=;
	b=aKNRpekttCgot+dSGUzbDc0s4dFoNNbWKhUbkbkZK7KpFqXcUTM2TcJFZKOWVGYSFF34KO
	qX/8ioPpemUgz7zt8Ch0ynrdtjxT4TClWYjz6d+GUO5tViVNjQSq2J0BGwagVpD7XAVGgJ
	B2OMAUi4BdokgqNKgAUzHVvj5K4kSjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788975103;
	b=eTXavtYo5a2Z17heYiB0shdiVo4wkfswRrUxNT+D8TwdC+IffHZZOMoysgjHDh1h7M6tu8
	4S5U8R0BHbRSAiiGCJ7DHIuJeXha7gp4hH2XCsVhqRc5HJ23cEIkzUiLVkoRb8BCN1zVvS
	kMe0SmiX6HFPTG1BiTW3osj64rSxP4Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2aybex3;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C58A0409FF;
	Wed,  9 Sep 2026 17:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333FC1F000FF;
	Wed,  9 Sep 2026 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788975102;
	bh=0ubKjcUHJ8BQDEwwualgzTahZHaTSfH4i57++l4iDsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m2aybex3X2RAJXPixBts2jyvWtg7abtHlmkNtumHVYjajCSdO+TTS0vt7NuUZa+ED
	 u+oo/zEfcmYwmSFc/bU2p5oE3US3YBdd7yZVlM4HJAe2nOXHLNUcpSJQ0kdVMimmUc
	 7M7nmVvUJUHHccsh3Qv/X+6UEd6u1wa3Q6r6AHH356SUSRi2rqlNX2n0F4YisRygFC
	 hZ3VC7HzkMVzeP9QNI+2l3RssjnwC3GSwxbDniSPL4jbNA++YlNjfObQ82VGeCZhaJ
	 BGtAvoOA/uLjSPjr2VqQp6i9cYOnRkw9DvcGEwxsxsISI0GZp8PL3IQRgZmxmJZKlJ
	 3KYIfDGsjSBQw==
Date: Wed, 9 Sep 2026 20:31:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] memblock tests: cover low-address allocations
Message-ID: <aqGX-ZhxsJppfNpi@kernel.org>
References: <20260906144011.848898-1-hi@tychen.cc>
 <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
X-Stat-Signature: gnmh9i1a9ew3q7gkroptyibf6kcx4bdp
X-Rspam-User: 
X-Rspamd-Queue-Id: AD25B40016
X-Rspamd-Server: rspam03
X-HE-Tag: 1788975103-726379
X-HE-Meta: U2FsdGVkX1+DFiwNef4M/wqpl6EPxncO13WRB0B1DywOQ6UcI95LLcLz/vCKI/R/Q5NinABkFGa2yXXwqtOqFej5kmXo5SAtJKLvXD1WPIr5KI/2wytB0tqNRoP4o6XCX8xmcWJiigGbdm9oiITF37bQm+H3OlJOPsKdZiaIsjSnJEJU1X9Jf1OXXlaG+hhpxhQjnnQsKteLJpWQiiFzm98Z+KyU2CuBWgSdbUgY+IblBbj61bdJKxkNTtUxt//pcxYCc/f/VAUxomzsw+4SNSvar4V44uzafZka9KIE+2TN8kNgu0tDyx4NEeLCWeHqO1pSCdYzTl7Bn2fJicKSzZMXL6p3fnp1qEQuPnadK2+rgMRtwD3ion9wFl3ohqg62RdlXZTA1s4l3ilAgTsgbwJ5IHxShWa6z4nXeYZVQcoCUubqfgyG/h8NgnxfvUjlqu14sx3Q4qHDkVTItm2MUzzMLi+77zs1S6EYeOQMCYYDrjeUV2jIvPkbJ/fYbZkjn3Yu53ISg3lfe2dqdT8xxTsAo/Kxtc/lq8+CYzX8O+SBB2sziZYgYhpRP4BzP6EMJebtJ9Kn3r2KGbZ37xEMDZH1OJsxEhFiKYdfLuRZ87u+K0lE8k0qNZi+Ap1eJmgZzI3hm3HG321Rqs4+oaZNwa/jBRdryV7+JENcLXwR8MlMw6Fzid79OuERNsgrib1uE8w2tar146P+alWeQDSuw1PmNe9BoPQvtNCqUiezasHRUAY1Ku/zb0X5aOr36wrCbOeEpZVuaPPcAu48m7FhtD+hED+2oDAtcOOK74RZsbznlYVhqw+/LhQN32y2zNGNeHiykZuq20kDw+TwiouQ9KLCqApj4fk4niuoiUqs0Xu3VbIJVT+qAybfMC/9i9mfFQq1I5+liHLxtEHfsAE0d/+yx2h3Uzn7pq24CMSaMKQL5rs4mRqLilwH+omuMYppJZRnSL+4F9o2ccQ+Agx
 XvOKloSH
 aRKPIibrcoq+R/H1Sx7niCeQz/zMZGPpez03vGkQnnD4bGSB/l6017WxdLdxwZzBKnfWCXcPKMPxeg9RHU6XPa/UdeWeDeuGp6L7OyZmGmyNa4UZK89jXmiYcZsflNdEXjKEtwS0x1U3B/oL74nQ+28faQK98vO0+IrDfKVafsvBct3JdiFBML02pRyRJjAvONlsYwO7upWU5sSaPbvh7CaDWGZ2LKm7n4ZuQ5l8xd7bZjG+qfYzg8So01Yl8MHuVAZreVg+6U6zxIcIPTdBx8rZA8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

For the future postings, please don't send vN+1 as a reply to vN.

On Mon, Sep 07, 2026 at 09:20:31AM +0800, Tianyi Chen wrote:
> Model a low allocation limit within the dummy memory registered with
> memblock, then exercise memblock_alloc_low() in both allocation directions.
> 
> Changes in v2, following Mike Rapoport's review:
> - Clarify why the limit splits MEM_SIZE, the region registered by
>   setup_memblock(), rather than the larger PHYS_MEM_SIZE malloc buffer.
> - Explain why the malloc-backed base still needs alignment.
> - Describe the boundary in terms of the last usable byte and clarify
>   that reserving low memory succeeds; the following allocation fails.
> - Update Assisted-by tags to the required tool:model format.
> 
> No allocator or test behavior changes from v1.
> 
> Validation with the existing Makefile and ASan/UBSan enabled:
> - Default, NUMA=1, 32BIT_PHYS_ADDR_T=1, 32BIT_PHYS_ADDR_T=1 with NUMA=1,
>   and MEMBLOCK_DEBUG=1 with NUMA=1 builds passed.
> - Each configuration passed both ./main -v and ./main -v -m.
> - A separate BUILD=32 run still hits the pre-existing
>   memblock_free_near_max_check assertion in basic_api.c, also seen on
>   the baseline. This is distinct from the passing 32-bit physical-address
>   configuration above.
> 
> v1: https://lore.kernel.org/r/20260906144011.848898-1-hi@tychen.cc
> Review: https://lore.kernel.org/r/ap3LTQlKTpDbAEJZ@kernel.org
> Review: https://lore.kernel.org/r/ap3NJsaG10rLDVpd@kernel.org
> 
> Tianyi Chen (2):
>   memblock tests: model the low allocation limit within dummy memory
>   memblock tests: cover allocations below the low address limit
> 
>  tools/testing/memblock/Makefile              |   3 +-
>  tools/testing/memblock/README                |  14 +-
>  tools/testing/memblock/TODO                  |   5 -
>  tools/testing/memblock/asm/dma.h             |   6 +
>  tools/testing/memblock/main.c                |   2 +
>  tools/testing/memblock/tests/alloc_low_api.c | 148 +++++++++++++++++++
>  tools/testing/memblock/tests/alloc_low_api.h |   9 ++
>  tools/testing/memblock/tests/common.c        |   6 +
>  8 files changed, 180 insertions(+), 13 deletions(-)
>  delete mode 100644 tools/testing/memblock/TODO
>  create mode 100644 tools/testing/memblock/tests/alloc_low_api.c
>  create mode 100644 tools/testing/memblock/tests/alloc_low_api.h
> 
> -- 
> 2.55.0
> 
> 

-- 
Sincerely yours,
Mike.

