Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8329606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmodx5Fs
Received: by kanga.kvack.org (Postfix)
	id EF1E46B05B2; Sat,  7 Nov 2026 08:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA36C6B05B3; Sat,  7 Nov 2026 08:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9BC6B05B4; Sat,  7 Nov 2026 08:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBBF56B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:18:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AA4C1C37DD
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:18:08 +0000 (UTC)
X-FDA: 85408376256.01.E3A7EA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92226C0003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:18:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmodx5Fs;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794057486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHIeRQXEN/cLq4RDZzIjHJg7538MWLG7Xtt4v6NPKig=;
	b=i1U975JYWWyBblMEDe/eAfwtvjOvC77t7ycjR1cZP7dvWUWXdgbVWbHsXrQN57iIRp1bkd
	MfyohijUG8eYp1cNN3ISEo3cCs2CmdYv6s+KTMFru2O/buiMSX8kZDSWjI0jAiPPscpRyR
	z3emXH2GZrLvyUboHpGE/anFFM0JIpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794057486;
	b=1kQ11Cylh2sjqTheZOfuCr7HyP4GvTaQMxNuB+kFYothStSjYiJXHUCk5UGBnEYI4mxycO
	2oqKPPcNOan+eDwkDn7+/XBjgcKYNQ0SmU4akKvlXC3yQ0NbIsXqHGVlk1BeCUklKgpbkR
	zSFtqvGM8Al2XjojBqm3Dsfc3BNARgI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmodx5Fs;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A43F360202;
	Sat,  7 Nov 2026 13:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CFA1F0089F;
	Sat,  7 Nov 2026 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794057485;
	bh=WHIeRQXEN/cLq4RDZzIjHJg7538MWLG7Xtt4v6NPKig=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dmodx5FsiwXCu5bCklY+ydYX0FIUmCxrsDzsFLtOh0GTw9MNSoUPtk3zPRKKbP5ep
	 XUZASmIqNRpBJnKezD2+Z0fPtOiQpuw/SXRJ49RgSFG9MM6whfwgFHjUh2KL+PjmZE
	 CpBEeILbLiHqCVPO7B961xZAm1TmrPHV3aFB41z9LbX3rKDvicyY3oiiltvZKfsnfY
	 w7PMu9dtqIY2kQPyZ9OQQYKTiykkHTk+lJwJkniTYmBEr3onylybQ4PLYuChDYs2v9
	 eTavTvW1dcUZPumHUusKC+HEUdeQHDRtJNYkUB+Kv37TZugwtPU0OLMIGv0SOXNsPF
	 2iRJ2C3KSBGXA==
Message-ID: <c243e6ab-3eb9-471c-9b6e-91064528ce82@kernel.org>
Date: Sat, 7 Nov 2026 14:17:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/mremap: F_SEAL_FUTURE_WRITE can be bypassed via mremap() VMA
 expansion/duplication
To: Junyoung Jang <graypanda.inzag@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261107030708.1031977-1-graypanda.inzag@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261107030708.1031977-1-graypanda.inzag@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: j8kfq4oszy9jenpfs5rdouus46me4umq
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 92226C0003
X-Rspam-User: 
X-HE-Tag: 1794057486-320334
X-HE-Meta: U2FsdGVkX18P2HisGLYG4y22nUAU8vfjaJXfRLh+2+GSkylhAJ3TF3r8iY0rfk2zJN9Fcuu2q9RmA34NzbCFgavOHpq9wexDzVqKo6Evdyro7DR0kJFKWAfhy1FdZsh/d/aKiIh13Hp1ChWKUrW+15PTPerWnFnBoVZxWJ6TNQlJRNoxlBkHV0VnksGEWltA3OW2c+4CAFFOd1KJajBdkImk1NXMykAnOM1OJTcjc/VCGvjBB0L7DZ6ka9kiyR+3Wvj2UEeap4BZXyb4hf7vrtwDLxVZkz2b0dqMUNDrZIUo6SEkl1npLZiQHBUALlZDzNfAY8RSF2gFm3wTHGAV7wIyDC58ZN4BQocTNQO5sUlQUvKfHg8KyAkwSdjG2ixlGlnMFOb9ZSS0obUcMAoUFEXjwvu6HHOpIh9mHVsu16CycTCJW5oeX37ulgaU9e29plzA5yGcyW/tCttgeENxBol2ixGtMcqETO75Nxhu0qM5PoiJkUQLVCR8zvekkb2QoMwkp7RRV+9l5Rci2DH9QgbHGeTUt/h5AS7TbNWnvEIyEHHAntpS6QE/XZ4U+Y5uwEZmsVcT0wZgSNi1vyPu+/mmxCNBiX6aj1vmh1FlcECeWZFRonBxkR+MjGnHA1C0rSn3cLg/XPURO2w44S1JUSduJsA0nQ/1bMnTmXJo0Iit0V6sv/FLA36K4KxswYYh+IevJkp9+3H2P941QCTfmRmrQ0ZUtRFiM+9jEmQtDiIMmznaxS9K8VHYL7aZ4OYV3aJR1w13jwZWW0TkrhQo0tbGPbI3qV78ejNv2lnMVE8n58ZoaIJZkWROVH54pZWbYjIuvjMSYt1wwL3FWzWHmY79gDWdhhFVnyM7yAmCSmHSqZknFMLpd8GuF4ZPLkZC7J/vihl8RTxhbl7n2kgpyIRGEMqmf30imf9QS3Z06G6VHUXMKq4UE5LtskOFe9tYhET+uTJ2+hdE675hbrM
 W0rENNlw
 9OKzJbSS9+HyGSzqOXB8Qpuj+RDI/o/1NwAT5mb4CRhS1RzT7yWxYzvTuFrmnqz0P4vlS5uhYXEA0zUTdWGwwiy4VabwcKC/ztcIjI2YY+uYVdYkmeqgw6lJerU0qehm/Dx9lHZY7I3qxQVv48Byw22KZuyeSUsktCXPHJd6EKy+ApSU53iSxvRiYlryoILUF6LuLjPOV/w+og51F3AH0h9yIBNCekjrnpG+pDjjIYhlE1aDFKcCaQfc+Wrcl61ngZ8rPkD9wsPzfSb9zUJNyjGeyuyRAp9TPFFCUKNoate3TzoARr6Bzw90ld6aDPnkypzB+lRHuBP8Nh3IQE2+aWOKjx1EVVy8vMCdeO83pGYoF2gQE9edabSbhy5HlkYoow1sNACGdpFTJK51KqhraJssTGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 04:07, Junyoung Jang wrote:
> Hello,

Hi,

> 
> I found a reproducible F_SEAL_FUTURE_WRITE seal-policy bypass. A process
> holding a one-page shared writable memfd mapping created before the seal can
> use mremap() after the seal to gain writable access to additional file pages.

F_SEAL_FUTURE_WRITE is not really range-aware. What makes you believe that it
would be?

I'd say it's expected that if someone has write access to the memfd, it has
write access to the whole thing, not just some subset that was obtained through
the initial mmap.

Any documentation that made you believe that it works that way?

-- 
Cheers,

David

