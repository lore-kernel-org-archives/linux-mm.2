Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECB7EFCBB6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A476B0146; Mon, 16 Mar 2026 02:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534E46B0147; Mon, 16 Mar 2026 02:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478AA6B0148; Mon, 16 Mar 2026 02:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30E796B0146
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:47:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8F911D7F0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:47:26 +0000 (UTC)
X-FDA: 84550994892.18.392EA89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 450F71C000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:47:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BLFHWwM4;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773643645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvlC4XtEhaXhUXXhIDgpBDyYD6p+n31AHCkGYyQotA4=;
	b=GG9d1+sAW3asZ/moqtOzCLX9HInrEnecvIVXZ44XUAw2dKYwyth3vpYIHtL4B8NKdx32Ud
	SGm6Bs0D8s4RQgO1RIKlET9q+x7JQRlrWCj9J8g1qvnLvfjuA/+dCB8A0b00NsorrJNz62
	j5mr/R0n8JflvpHqWUDuUAHq3nsjmes=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BLFHWwM4;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773643645; a=rsa-sha256;
	cv=none;
	b=PdtwK9TUefN5A1xIGEAtKGPh44bNCJdkDn4NR9yHn4aiDKZxUKFZcY6Dr8JNp6Cda4G6Sd
	D2tL+9CwTSPc/GykAq8aafbRgTSwk1FNp6zLx99Atr7UqQVc0+ycY6onHBnaHiYvgrxQQs
	89bBQCCNGwBlRA7yIhg7f8/Bm+8i8sE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F128408F4;
	Mon, 16 Mar 2026 06:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C97CC19421;
	Mon, 16 Mar 2026 06:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773643644;
	bh=ZDu+xUvhrChyttr6D5WuK5J+jLBduob1K3CBSUvWzKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BLFHWwM4FysvgHmhk+4rELTKsRLvPP+wjzM/AXnEk4opaDmVP7zvG6aVaqvDS0Tl+
	 qoBwoX/XCbc/WlCD0pLZlmfo4BaEXUVJ9OXay2jnv80DISXBU9d56ms86LfF4/OkJR
	 lAwQEtTK7emx18u6CDQorQPwDUwFLrLhnd3g2Wc8i2008cM/a3YG4S5kyApwdFlxuD
	 jO+n5zvq89xJa/SgiDCSte+tJKx0eOkCJxfr/u2TIYkRrG0a6rYri9Vz3EyCpHEtxR
	 E3O/snFJxCWdflcpRk1CehXkP+qAhBhfxo1Da2SjGvUikwbsnmBf426ZaX2jP9PF6U
	 3arAVeCeun/rw==
Date: Mon, 16 Mar 2026 08:47:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Kit Dallege <xaum.io@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, corbet@lwn.net, linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document Boot Memory
Message-ID: <abendSlwDIwB4teF@kernel.org>
References: <20260314152527.100295-1-xaum.io@gmail.com>
 <0c981733-477b-496e-abe5-54eebaae04b1@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c981733-477b-496e-abe5-54eebaae04b1@lucifer.local>
X-Rspamd-Queue-Id: 450F71C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: x3nyd834tr7jiuymyfwmpkq184resi5d
X-Rspam-User: 
X-HE-Tag: 1773643645-989144
X-HE-Meta: U2FsdGVkX1+rUN107IXwAeL/ERuVn6epxG/LqwtcW4jZk8glURLO9oiCn8oq9fTXytwEyDPziP+K0nymkKci9S7cijY8IlIorW31K8ugA0FzBU5CrvFI8u8QVYI+zb/CjxxHBk0SgHDE8+sG6Gnzel+pk7E/jTTd7Sqhgn062mHAs6lkmZ6d9mXoHlI8iRcXkMNB9iH0HAWm9K2A40+Ir/x+DoRDygYRC0d2GtyzzxQ3rik7N0rJrWb4M3CIi9xAmqOPL+nQoPg+LsPslKrLkk8edKC1MsMVb4N6YyE7U+k4t31NLMfTO/mlDzJC4vmYkwZkVe+peh2sORz2NddURDSFq/WKw585cMB16yyQKyDXw8MtSuiQJpGxppotjHv422S8WRfCcuX+wNQlT/O0XuCkvYYgz9lVXcWQWWt+wzasRZOcVygGw6YyhlJckka1eY0zPIq7RKjuOLW6X/CjN7d8k6rQb1ek3R7EQC5tfUJ9pdj3lpeSHJGSgL/7H/NPpJpp0mU0NuOWtA30XRQaK0uVmfYbsyvNK+z81UFCabWhRnB4xspPRMXwo7CMktYZIxsRDm6ds5eoE3dh1k8SpLALPIFeJKVABmfo6IxHCTUE13Of5+thssOnHITMwDW4oVwVhSq3E4VEJTjXOEZm+cAJuF7KLit8Lj4Yy4sdLISY7I/+m7jivMzMYY9ibQYSocSgM/nvNo/1eBae+8s0HPdtySWyybOIlUsexx113tdq/pNxBcYLN1ZOv1pnjE015NPAQAGuawDcNLdSdQ+dcUytFMgi5MbNu/peAWaykJRoP0pjDX9Mtt83DQ6cxFmDj0hJqJ/Crky1IuCdCAjg6cW3EKB5OPNi3mqFtUhmt4UNzDY28WAApamPQXHUwO3NjwsuXVrFDnEXjuSHlkmM3OFFyJqm4VJiTT74+IYTys77uCuGRjQt9+LZQm6xp2Pd2ABfnqRvb6zH9mywVMf
 fT6zb5xH
 2LyoSMBWSQZzg3Vlq2dF+cleVc+s+VTHAz8F6XuY4odcaXEUKt/F5pD2SLxKaV3tsnUwum4YiI+yi82VqmPZ0X+rm/MORyN95CzQHjVXUCOzN4/TPU6vxNoTriBsHoMDrCdjl5AzdaxCuuFrcE1UaKv9dH72Ac4TdwSi9Z9DZLCVgMJ72xKfcHIjNm/q7YVfqx2mf7J2WzxWMtg9m/7JNJsJglw6jh1SeSdSUPc1H7ajEtrT8n3f8AmybGAcEX+mQNjkAHPC8NjSKfLla8NxPE6cfqS3hV2VYD22kr0B1xXd0XGLUiBBiB3FbENDbeJrjFqNT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 08:43:24PM +0000, Lorenzo Stoakes (Oracle) wrote:
> NAK for being AI slop, again, obviously.
> 
> +cc Mike, the 'boot memory' maintainer, who again I'm sure will be
> overjoyed by this.
 
I'm not going to review it thoroughly because
"maintainers are entitled to reject your series without detailed review"

> Reasons, as the rest:
> - Worthless documentation
> - Everything about patch screams 'zero effort, Claude did it all'
> - Bad etiquette
> 
> On Sat, Mar 14, 2026 at 04:25:27PM +0100, Kit Dallege wrote:
> > Fill in the bootmem.rst stub created in commit 481cc97349d6
> > ("mm,doc: Add new documentation structure") as part of
> > the structured memory management documentation following
> > Mel Gorman's book outline.

We don't need to fill in missing parts just to fill files with contents, we
need quality documentation.
This doc does not improve over what we already have in
Documentation/core-api/boot-time-mm.rst.

...

> > +The memblock allocator fills this role, managing physical memory from the
> > +earliest stages of boot until the buddy allocator takes over.  The
> > +implementation is in ``mm/memblock.c`` and ``mm/mm_init.c``.
> 
> This is at least reasonable.

But still wrong. mm_init.c is not a part of memblock allocator.
 
> > +- ``kernelcore=`` sets the amount of memory that must be in non-movable
> > +  zones.
> > +- ``movablecore=`` sets the amount of memory to place in ``ZONE_MOVABLE``.
> > +- ``movable_node`` allows entire NUMA nodes to be treated as movable.
> > +- ``kernelcore=mirror`` restricts non-movable memory to mirrored regions.
> > +
> > +These parameters control the boundary between ``ZONE_MOVABLE`` and the
> > +other zones, which in turn affects how much memory is available for
> > +transparent huge pages, memory hot-remove, and CMA.

Oh, my ...
How CMA and THP are related to ZONE_MOVABLE here?!

-- 
Sincerely yours,
Mike.

