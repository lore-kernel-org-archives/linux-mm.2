Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B54C2606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vl6uSg+5
Received: by kanga.kvack.org (Postfix)
	id BB15F6B05B2; Wed, 11 Nov 2026 03:06:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33F66B05C7; Wed, 11 Nov 2026 03:06:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23466B05C8; Wed, 11 Nov 2026 03:06:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 681B16B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:06:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D15A41201B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:06:06 +0000 (UTC)
X-FDA: 85422105132.25.D89ECC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C65B20003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:06:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vl6uSg+5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdKcGRF+Thd2B4nVWmeKuOcWRtPqdSv0jcsrCZK/1Fg=;
	b=Vo4qUZJRy2E54peJk/rEzVR97XyeJDFAZHgfr7neaSHn8bD5la4eVOWW+tQsmSVJwLF5F+
	0nO+FxxdSd5MPVFGKiozwLI6rbyOgm3A5NZhIULmESBhL+HbkfoReM9CBXzRVR34M+iSUJ
	2azC0dmgFZecdjTaHEZrqutZc8dfQ8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384365;
	b=weKiRyNschbaBA4qXy5mcmL5kX0pw6cp9Hw/6hy2dDMGWJDufXNsaF+htIp2HE5pAN43/b
	Fk7Lw8peB/fwcig9hBsr/Gcv4KnPDkh+WfhsNLvgMJLGKtyzcjAUyhviu8qSmflC9DrBk7
	Sp10ZS8+TPIiHhRsaxr5j3mHZWxrNws=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vl6uSg+5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84E94614B0;
	Wed, 11 Nov 2026 08:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A1E1F00A08;
	Wed, 11 Nov 2026 08:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384364;
	bh=LdKcGRF+Thd2B4nVWmeKuOcWRtPqdSv0jcsrCZK/1Fg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vl6uSg+5H3MQjU0G8UEBAvxxx48dToHk8qFJy0CRWT5rG45kg0zUz6Q5BzBvivoYP
	 9ls8MupqlwHXysP3k/yldpoy3uQLkl79v/euvRQqxIR168ip5B8Y6IXWPcgW3wqhxy
	 Bu3Tglve+PkvXEWu4oZ9HAB9UXKrbwEVqvFuOJktFXjtrarjOXe2qPtNBHe1l6oAIO
	 WhvGrgGLEkSUi0qCmEnJlkIGJZQ1wwaJmwlyLXZqi5h37ZzFi2CgPsrwMiQlmjKkCE
	 4ZB1xN/onBQU+0NuVvUq+c4nsHbU0SxTd2ikrQLFJFvqr7SgXO0mgEPuLvBZm2eNF1
	 YFp/CXjWnLQNQ==
Message-ID: <7698b32c-eb47-46d9-8ebb-337aa575d062@kernel.org>
Date: Wed, 11 Nov 2026 09:05:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memory: refuse to map page cache folios that
 are not uptodate
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-3-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261109120403.82361-3-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bfi35yny3gb3d9y7fwdstkwgdkwmtc4o
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C65B20003
X-HE-Tag: 1794384364-889929
X-HE-Meta: U2FsdGVkX1+Epd4Sdtws+2BQ4MIYbDkZ9d50L4PqEeUTrIcjBlKD2eXY1TVDo9KIFY+bKokCIyfpcbLZNWRIF4BZRKxeBsWW4T+tM4S8dsGfG/A5M144fF47aImzwrq2DotKMfpXetZhrfcihvjK4F6mn/9nMsM4klk3Ylg/sqDNuGg5wkB7ehgoI5kXeIUVX3yi5KyV+pQHt22mAg/4+m8NlST+cS/Vqq+WTjnr+0WghMEk86TLFpE+CpBHP6ZoSYUtMaQP33CyAQFMwUoF2PyrdWqpbcBOAqN+9i2R4U6faDdlqmNVS2sOzInyXXHS8wgUnv6yriYwnjnZbltVZ3MK1qcdxX/LVivssDXbriNjQS/Gnx2R6Z58UaKqr6z4Qftx/5+gOp4WpWKYPSZ1a7R0QiLJgT0DJrSiPKJd+R8dwAIeTQq2tp8ONzPzhuIkIjM8tty2cpd1UkRW6OZYZXmxRQ/wHCUExWIOyTtdPM7D3T5kJNbPnOFWjyj1QWoDbm7KU/BV6zcTixklgWP6HCLbgbDz56JhPE3m+ijzAkmoAWFkovMdEQQrNajuSKcCSxXrkxQb+FOgsLx53Ft7zh1YsY3H6tXEuoStgIKadKEBTaK/7W3JeN8EhHxwETCH1183oCE9T48NfTbuQvHraGubqNqwVWEpDGIg/nghlctyKFMDbxz7hUTQLKxc5rxTQScEKjAfz66hmBZM9gRxxMODlOhf3brWkgYdy0LI2iJiUiBlQrkfNGDWLl4STo5W1EVHzrubEDgmGFthaOooRe6hvJIULW8g8VHhrmw0rhEiRdAHc1iVlwnZOOrtFPxubLL6q9bHk4ReOrAr9FnHv0lykBJpG4fDo3yl89QxzHWhiBNqUXK1HpnxNX5AjyU1fztqIgNh54n29Y+TTJ8DtqZpBywlxYUV24g3n4iBFuUL2Az3CIWwOLbCe0eHa01+nH3Yy/eNgLK5KI31DI/
 FzPs3vys
 JIewJUGBgr1rnr9ZdOIf5kjixRBD+2BTQ7dI4B5k+vjP2jqncoPDJ1Fj6pnQDLOFaebLQIKsTU0g+uzd1Fr/1KuWj67uNIqAt0AeGR3hOEUovTeWLRzXAK2PM401VQFa3g8F6KXRn7/+OBOVqfQpbbf0Bw2js6GhpRiQumNU7s6mPO0qSr/b2CxLHaQDNHTL73hX71muLfY6d7wMJ26SUf9C0ju8kwIWComxw1cvefNVOBx531FBIwwyyVwtU5Ut9xByUBAH32SD+wJizNrvGTRbetA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 13:04, Kiryl Shutsemau (Meta) wrote:
> A page cache folio that is not uptodate holds data that was never read
> in or cleared. shmem fallocate(2), for one, adds such folios and clears
> them only on first use. Mapping one hands userspace whatever the memory
> held before.
> 
> Each path that maps page cache checks for this itself: fault-around in
> next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
> Nothing in the mapping code does, so a caller that misses the check
> leaks stale memory silently. MADV_COLLAPSE did exactly that with
> fallocated shmem THPs until recently.
> 
> Warn and refuse the mapping in __do_fault() and do_set_pmd().
> 
> __do_fault() checks the folio ->fault() returned while it is still
> locked. do_shared_fault() unlocks it for ->page_mkwrite(), and a
> writeback error can clear PG_uptodate after that; that case retries the
> fault instead. For CoW, __do_fault() sees the page cache folio that
> do_cow_fault() copies from. do_set_pmd() covers MADV_COLLAPSE, which
> maps without a fault.
> 
> The fault gets SIGBUS, as for a folio that fails to read in.
> MADV_COLLAPSE fails and leaves the range to be faulted in.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

How do we proceed with patch #1 (on which this patch relies on :) )?

-- 
Cheers,

David

