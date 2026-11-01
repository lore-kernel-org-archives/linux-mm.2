Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC490606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 19:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=T32TZ0K0
Received: by kanga.kvack.org (Postfix)
	id DBDA76B05B3; Sun,  1 Nov 2026 14:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6ECC6B05B4; Sun,  1 Nov 2026 14:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5CCC6B05B5; Sun,  1 Nov 2026 14:02:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 923656B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 14:02:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00A4C1C44C2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:02:50 +0000 (UTC)
X-FDA: 85387472142.03.43F77BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 44A7C140003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:02:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T32TZ0K0;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793559769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WggtPILRKQmq1fPsXP3UeL8pjRSJDLX7wsrAkv0vb7g=;
	b=becWXMnNXTNKke9Q2PWDxa/oNJiNZwiE9+mJkgWS5VgYjRMjuzPcO4WBrNmNtePPfrka8C
	bhFkbXKq8q+yEieKihiK7qw4lKGrgDpbueF/CQ7NGsL3zeAes6K0bkg1w9oZriCw1TTa0S
	qjaPhUVwrtuiq23byedY2EXzZhTlNks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793559769;
	b=1YWY++Q6uGMFKCdj6ASyIRvVj5ekgHw+mNwiSuim/Si466J0Kmukxz/Da4vtSpiWWU/D9i
	e55szrF4uWmTHVfE2GG15WUiQ8Z6FMOR+kK6fEgypOg/Adxq4y9SS0DlGGU9/9yDN8svJo
	47ixE7RDHEFQZN/xX9eC09pmVfg+uSA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T32TZ0K0;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCCDB605D1;
	Sun,  1 Nov 2026 19:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152201F000C1;
	Sun,  1 Nov 2026 19:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793559768;
	bh=WggtPILRKQmq1fPsXP3UeL8pjRSJDLX7wsrAkv0vb7g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T32TZ0K0bSUBw8B+3JGLMuQPRUCQd1CschZWipLljnoqd5xMJTLLQfZftxMB5iOFH
	 rKVBvPd66COoJcyapjdR00+vfV/yMdY2Wi2Q6HS7u/nY6XHwz7dxk/V30vL+dRmqxJ
	 av67p5tRMF6Lq3FUQ4psOH/sHMHqSHANOU0Bn+qs=
Date: Sun, 1 Nov 2026 11:02:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kelvin Zhang <zhangxp1998@gmail.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Kalesh Singh <kaleshsingh@google.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: check THP exclusivity for each
 subpage
Message-Id: <20261101110247.95a03a5601f235ffb39c54c1@linux-foundation.org>
In-Reply-To: <4c1b393a4b04bd94e4f1c7879ae04e1793eb0931.1793552446.git.zhangxp1998@gmail.com>
References: <4c1b393a4b04bd94e4f1c7879ae04e1793eb0931.1793552446.git.zhangxp1998@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 44A7C140003
X-Stat-Signature: 78n1dim5awrjxsbcm3ckfg7eufb9c7tw
X-Rspam-User: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793559769-363712
X-HE-Meta: U2FsdGVkX18T2y0F8BnsFtEHoigbnPym13ZFXbJIr74uWGRyWM9XPnOs+hZSlXLQhlKJkDxBIrjmg3KENRSrgNJi0PxUn/if10p5z+zYc7IJC3gjhZAmymeBiOP15se/P0o5HrHvkMfAX6KJpRWbBx0OIQXYAr3pPHQY6h288EnuxYOfVdSoxcRWKmXCH4GbXWEdciq9+bbFOok14tAtI6MV0zXQuqNp7ALfxYN+bGntImqPg34vRw53zZi75eIDKJHgGLTPKm34nBeEBDP8qOmQvfduIq6glyPD6XQ/0evBoXfUU6WyV8dkqvyAaKgGbtO+D64b5EI05rROQTTbKslrm5rGLGhek3qyXgpdGgGsaHjdf8hu6gdK4y8rj1Dpqb5CzbnrINDjhniQkFQWjlJWPz4h6JLWpW6y2/ORF8Ho5RN6Z5GjbVURseUp5QzUbu5US2h6AnmLO25Ab9m7CZGPYYPOpWXZ+Tpm4qBVxmHyd2OUBYCIXp6eajInb6BYFM63FVX1HEVFnuk0j0/YRyuheQUs66ZLqwoAUlB+f813z+9+nosvAfy5dCzK4rfo1KBYNNYpxduAYFcMnMQSjl1kOPwqe775mG0UwOFzJcp9Ae0rjgz+GsnuQ1pQkVVfZ0K8WrCFdD6BRu8qVpvLFOqVJqLxYE/4q/9VhkBhFMEHsP1en8hfgXrwBMbPpZc6CgwxtIS8tRxGDmz1C5271SGipAkvIq4RZOx3qNa2KNX4PjvFRwT01Fbu22aln2Q5MV5gN4TtWdQyb8m5t+0ASkGIrVX3qSzy+gQe23bxzp9Va6GSqZaLlQpNG38gstR8d8ehWmQj0Pe4J4aVZ8h3rpDMX2ONbB4FZqWWSx5kZT59evcNWI8JdgUCEhtCU3osl18SM+sKDhaNMEqE8CfAJZigpahHd+Yv/3K1G0hbRpIbrt/lBhP2s9YkZuYC3xcPhpynb5N8C4TINgNbt+a
 clhcj17c
 pU7t0+LI+cHwxfVRtx8Y8Eyb6+JOeTSaXYDK4Aundg+mquw1bL4XceHWEO9gGEhlMu4ltffJ8fuuTb0MbBi+Lrlz6qxuunuOn3J5brvzQ5FlAkEu4y7KRocVdSQEPXmm0MVGz+n8H0qdMKmokaErRLcbKSifr7XblWNaX1MuBApoLEQk2Y9Sr67o+/0sOW/64b7wNUffFAYA72ZWJliLvj4mkrZ6j54Fnoh5md6wN3zTNM486B3Aj7rg2uP7pNsfo6TonHpzkGSLNqjw3le8fjIDC+73E+gXC1aaqhau3A1FofXQXCL9ieh1CCnkEQzAwsIDN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun,  1 Nov 2026 09:01:00 -0800 Kelvin Zhang <zhangxp1998@gmail.com> wrote:

> A PMD-mapped THP can contain subpages with different mapcounts. For
> example, after fork(), the child can unmap only part of the THP. The
> parent retains its PMD mapping, while the remaining child mappings
> are PTE mappings.
> 
> pagemap_pmd_range_thp() passes the same initial page to
> __folio_page_mapped_exclusively() for every pagemap entry. With
> CONFIG_PAGE_MAPCOUNT=y, this applies the first subpage's exclusivity
> to all entries, falsely setting or clearing PM_MMAP_EXCLUSIVE for
> subpages with different sharing.
> 
> Pass page + idx to check the subpage corresponding to each entry, as
> was done before converting to __folio_page_mapped_exclusively(). The
> index already accounts for reads starting partway through the PMD.
> The conservative whole-folio check without CONFIG_PAGE_MAPCOUNT is
> unchanged.

Thanks.

I don't want to pick on you at all, but this is a classic changelog - I
see this pattern so often.

	a) here's what the code does

	b) here's why that's wrong

	c) here's how I fixed it.

But that's missing a very important bullet point:

	a) here's what the code does

	b) here's why that's wrong

	c) here's how this affects users

	d) here's how I fixed it.

see?  This omission is so common!  And I might have sent one or two
emails asking people for the missing info.

For the missing c), how does this sound?

: With transparent huge pages, /proc/PID/pagemap can incorrectly
: report shared pages as exclusive, or vice versa, after fork() and
: partial unmapping.  This can mislead memory-analysis and
: checkpoint/restore tools.  Actual mappings and copy-on-write behavior
: are unaffected.

And now that we have our statement of userspace impact, busy non-mm
downstream readers of this patch can easily see why your proposed
cc:stable is justified.


Also, it would be helpful to show brief before-and-after excerpts from
/proc/PID/pagemap to help others understand the impact of the change. 
But I don't think we need a v2 just for this.


