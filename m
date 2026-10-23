Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04DE606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 08:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLvHS0z3
Received: by kanga.kvack.org (Postfix)
	id C8A876B0B13; Fri, 23 Oct 2026 04:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62DB6B0B17; Fri, 23 Oct 2026 04:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78616B0B18; Fri, 23 Oct 2026 04:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 945F06B0B13
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:04:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AEB7160321
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:04:23 +0000 (UTC)
X-FDA: 85353153606.04.BF67990
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 67721160005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:04:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLvHS0z3;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792742661;
	b=P3KxKpZ3/huavfZp209ZEbubLP8CJpknPnPsSvkvOYwlr9NzjJ4weqSLKuMfJ0so3wJ/wk
	wHxgJ1gvVSSrnbwUauekVHRSiXMsiFdmfCr7Zw6HlgyD0WmWjDYvm76YNRceT3hySfLbav
	yI4B/djkugNonoKSaP0T3vKUB2oyGtI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLvHS0z3;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792742661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdLhW5v/uXp4ejNif40TjF7Cr8YlsY2rrfu5zrwCz7c=;
	b=Rtnnj5LJj1lPAPDXUWOrswEv8YalDcmSuEaKaANtv80DrK44F+g8ouay3n/FV4KjkN9FyD
	/Ok/v9hRVYjFrQxAa0lxeV3azppYG+5j9Q6Hb3yzHSnenqQGSX/M+cMfuLFT3tstH+EcBe
	xsajMqFfxWXwdILpEQ3eyBiNtNWSNkc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B417760252;
	Fri, 23 Oct 2026 08:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F141F031E1;
	Fri, 23 Oct 2026 08:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792742660;
	bh=IdLhW5v/uXp4ejNif40TjF7Cr8YlsY2rrfu5zrwCz7c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DLvHS0z3aZq5esQJCFYVnmr4BZd8HRgdUe7FpM8c/zwhoNvsqtTxGjMcmiUJ954iy
	 4/qivbqF8g3/ACcZlqnn7TNf7fVKzzyHmS80beVWwifppBXCr41RqxdOUVP0yvmsK4
	 z5dMIazWDzhhA6GBnOLndxrdRIbVWdl0R8wsiexT4ZvZYWXKiQNSOpnYySqtCl722M
	 2S1zVy7NeBI/Hlvcq6cT0Adjjwv2wnEW8/Tvwor0Cn8lYHtACdwi35eIJ+bwbjnrJ9
	 70xMSu1I8xSLZlTqeVgfBxKDJxrNtSZotA+PsWNANM9e7IrLI8p53uqS2R+a6A2QUM
	 K7oqvPGi0nEqQ==
Message-ID: <f60ccfa0-088d-46cf-841c-b44546ab3e2c@kernel.org>
Date: Fri, 23 Oct 2026 10:04:16 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/8] mm, slab: introduce slab_debug=N
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
 <20260923-slub_tiny_rework-v1-2-a0e66d536eb5@kernel.org>
 <arUx56ee_nkxYP_f@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <arUx56ee_nkxYP_f@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 67721160005
X-Stat-Signature: h74atwh3fysfop9rjx7prdgjyfym1abk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792742661-836172
X-HE-Meta: U2FsdGVkX1/QurMwmyn4k/bb3/aGLPENPknzrHZQUr/usT60Ul1bGl1aI1rtMA8s5arCoPFgdhBmTIvTpv9xt730KEmenfV380Qjw7zPm3/Ei/I8O74B1YU6YrjgsWWW7+yR65BXz2CikUkczxjRZMcLfapWcoa4KnRd6UmIKiT5xvYmGrDe5JhUjbUiFyZClepYD239akq7ZVtiF+zYCCNhDPN1dwISQY2O6DwLj2ebU00aOLZ8wMGU5QZR8pxXoAQ3qSjRTCq2K7SPBfP3x8+9K/T727qWfmWMLEnQcbT8mIj0LeX8jmMqN/WnlaIYzIBCE6lnnz0NGWUDRVNzbDF2/Q/63msZ4DscIhhbGs5osqtScCKNiWgd6QqLdbRbrJbQwbPrBd2QwR58/dcWfvp+oxnrQY2MO5vtHCZLjO2gRvveXHwQYSzGonFHj+BZN0Ffnb6atyd2NugMuSaf/dWYqcklUnjsNiGTbWFpqNsAbYQ06XqnkmJFD2QYD3GQdtV9pmS6uzzYhIUhTKjlSGYykmfjneH7ycRyhWfQQ6Ekxp0jcl3mN76NYqS5mbOmy55PTelpndqrVYVRltgD5AMsF7BkfgjZnH7OsTxHJAj5Y6+lGR+x1DbtKmrp2bsdKqiSZYS3pS51r8U/XNc/lSjGqvWOCY9JOQoqOHCN71MQQP6ChDY1qv0SSqDBrg6WP74rX7qQIyx0G9Xu46G3AFfvmmQesgO0Oz6tZE/y3RWw/ug9WCE/evy9UrUeROy+TNff83E3xhcE2ZmqBH+Sk57cUujHX0bNXtiyQ6WTORPoDv/QZ0Fo9HsZg0GrFboev9spS1nezidW+5G61oR2Xl/cY+ugtQNg0UwGyQINbLher5kiqxI2bD2DHylnOK+Ta5iCyIhrfGdXIFxEOCUO2/+KAnqRDQr8yE3H8fDjqnTfpxZvfXSrxbT8a3/7/bYtysu4R2QqLO2UucUcQkp
 N964aMkR
 1ZgoRyzGytgl9KlBg/JcRoYG0mLaTI4zTGz90jMevleA2SeBDMoJfZ9s+YG1mlMoUjrJUcwEOLUXrsNFyKSHsldC2zeIBMfrjatQR6wn4uj3NbjUcFsGiQMSPlkNEkxx6iO20bRvDL0/ij5RSEwIpWuzvpOUCHHcTgBzWNqAnmsXRF9qYhZeLvKokHL0jOr09Z8unY4ms9c3BpBCKQr/Yvy9gSaSfhJ8ntbWlv5dhe1T/9FRJ4e3zxobWY343IfFjKD0yH/EP8kfcF3yg9E+YUF9NvQPlK606SeHZxdWQwp6x/z+fkkrObQmTKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 9/24/26 16:48, Harry Yoo wrote:
> On Wed, Sep 23, 2026 at 05:45:07PM +0200, Vlastimil Babka (SUSE) wrote:
>> Enabling slab_debug has the side-effect of disabling all percpu caching
>> of objects (now via sheaves), which can be sometimes useful for saving
>> memory for e.g. kdump kernels. To make this possible without the
>> overhead (CPU or memory) of actual debugging options such as poisoning,
>> introduce a No-op debug option that only forces the debugging slow paths
>> and zero sheaf capacity.
> 
> Just to clarify, the intended behavior of slab_debug=- still
> does not change, right? (the name "No-op" could be confusing here I
> guess)

Yeah it doesn't change.

Perhaps, later in the series I should consider what exactly slab_tiny=1
slab_debug=- shhould do. Hm.

> And My LLM flagged an issue here (that I reviewed)
> 
> Implementing it as debug flag has a few side effects:
> 
>   - pointer hashing will be disabled unless hash_pointers=always is
>     specified. [+Cc: Kees]

Hm that likely should not happen with =N, will adjust.

>   - Disable slab merging. Since this does not affect object metadata
>     layout, this could be excluded.

Right, also we want merging with slab_tiny=1.

Thanks!

