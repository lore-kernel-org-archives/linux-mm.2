Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF22AC5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDDDE6B009B; Mon, 24 Aug 2026 09:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D786B009D; Mon, 24 Aug 2026 09:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FF66B009F; Mon, 24 Aug 2026 09:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C81F6B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:21:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 160E140152
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:21:52 +0000 (UTC)
X-FDA: 85136225664.28.75D7132
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 665D1180003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:21:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3kIUzMh;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787577710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1JOhLm4zg8p33Eesvf4KAwYUKhywd17N8ZTmUOFlhU=;
	b=ur3mPRwe0UVG8VWL7Up3RyJTbxNF4Zs2RJYIwQQl+anfsmyqmKDZ+m/vZ1oHmXiBTCtZs1
	UG+lgAzuItav9OyfUxE5ag51wAooF4j5wtzupKmo3seAyYXXLVRS2LGdNvJGBKYNagq4tR
	ns+0pcB50Izaqy04VuJMYUgwT9kUUME=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3kIUzMh;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787577710;
	b=5QEunRP34LC0GkJg+6DQq6i1q53UIdecF8KzoSTmy+bX1kjEJWH3w/+h/pLU8bRRc9+P9e
	R82EU1zSwhcS8n1DFWZlHz3DXXz0y1oeeicdGJnSJX4ZGGKYogl+5O6GxVuD7pN4YD7LIw
	1qEksofyQgVHWJrWfyszkSKprtfAjC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86BF741256;
	Mon, 24 Aug 2026 13:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8431A1F000E9;
	Mon, 24 Aug 2026 13:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787577709;
	bh=C1JOhLm4zg8p33Eesvf4KAwYUKhywd17N8ZTmUOFlhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C3kIUzMhBQVJBfsXshHzLfqtoxocGaUhRkQoECbAKeJQlpCpUfZUYrgKN+hbK6Fmm
	 vZ+AH6AecQm4ImUrVUYSpRNZ7vp6fEPBYgLlAwq6ojg0QZ8ExNDQ/BV5BMi0+PSfOS
	 jnFW3wNpWO7dNuN4Z+5XMMJReiDd/893GjpZhJuhHBn6d5+l+XALb/h3/DysSKN75q
	 cf7disUtAvAF8RdKux/E1FKxBTsU2c0cTsyEdfslqfP/riTetz4RZ8IJMw0HHxujLW
	 aaB0xLOyX3AwIgIoHEIxVwXQl3pBUpttWNkd0G+TOdXoi+eK8lDcC16I2Syb/hHUXI
	 TGqNKfKngLeig==
Date: Mon, 24 Aug 2026 16:21:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] mm/secretmem: properly account locked pages
Message-ID: <aoxFYlkTvHMqdqf_@kernel.org>
References: <20260822-secretmem-accounting-v2-1-fe445a7c6eb1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822-secretmem-accounting-v2-1-fe445a7c6eb1@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 665D1180003
X-Stat-Signature: 8tqwe54wqfujdyx7nhcghtcsdgf3tqop
X-Rspam-User: 
X-HE-Tag: 1787577710-850458
X-HE-Meta: U2FsdGVkX19BpiPHAQ4lS+QUOk5b6OdDUfzkBPk8vm2nw6L2nKnp1rzGw4ODQcw6F6e2mkt7cnX1x4GlHy9Ts8zpkm+pySdr9ns52Fhhf08e+5Lbl1y2mZaveW9Qro/GDNk/Am1etkz4mXPZgIsYBPai1jVdvKHjRnImGVWSlQKl9UpTakdeeW7qHHf/zjr+MfXe0ppk1N0QTd22TNL7+Xb0twNKfwIYoQDh8OjGOgCD1mrgLRfPSMOgXhj1TT1ZDdKzMFvNd4LirKAyzxEdOOYm9JCQBfHpwbfzxMvzj6cCcL/Rq/p5ifjNrg/MhnY0ikHR6znEmfWdIC+GdeKfvAdilwkqCBfHdk/H4blQnz8hmpxeUN5imOVR5YOgWHWlgS+vAFvjruRtBf4W8djJocQFEfbQFAFryKePj7kQZamL8gveZF8OqqDpimI17jXlwxQRNtFjySulYEFsXLziD3ioMolnWF0Aq88pjWptbufn2fPyC0bTtJgo82ecG39KWmccNZERDM5tPFkBSSzksZO3+c4ljWxjN4LgdmxX5DKaSADIYZA5abQw9+5h+7LmJcy58vlEnIipAHwPPr2ahxT47IY7WTjoADZxbLoXo43EqIf5mGX3IRw7q1/wSxfQQcUBwyqRRH1rzAEWRuMuhizDlwGYHBvTbBw+LzxklkQMpQvqNP0s231fHidfdxbDYI0f9YnrSnPFvnMsImb3EN3kRJcEd6wZQQueBlMyRw/v3In5S8jHP7S0A1SBN1i53ET+BcsD6Zoy27kM2BDESPCfb5tEHmvz0L9/1Shsjlmxz5//QmQHWHYB3nY4Amv//MFH0bkc+YzprMpuvW9UNLe+ebVyRnbpws4AaEKbJSVTh0jFFih+4ReqG3BmSwKwpeFVHbCF99czDAeqNVeFp0VKAK/YX0Icj2uSH3y3fLlklD2+YmN5YykapzFbA5Us4vcuuHTU+U+XJOBuuSQ
 M6VzzKrS
 SqxNxi5SdYGUXC9hyMZild1LRIZDefjQ3Kj0f0y4VR5Yf/+HbBeXBGBtYd0YTFJtKcwPUD4adD38j12BvEtGH3ORfgkZYE4Ai+ZLDHmXvD5jIS91/2gar/ufrThBdOqsOXRpIjYcB0IxxktTtSV8SsLklJ/DhL4by63R1shz8wvdt2JmvtH2iE0d0tC4PIG203HVzmrMeWEgCC8bj/jJj7CcZd90SiEJ+FjW9Gycmt0YwF09r4KtTypeXBkW+y1jG+ltnQDd0Ee+DkoYTrcuc/D9e3w5xvWK3MwjC5XXlog5GOZWI00y7jlI7kvEyjyt4jMfApvr3HcAD8qAiXaRcTp9pzBi3LK+EAzWzoPGB9NLPjxC4IIiPPvEmDjJTpPGqApFtY23d8OSzcxfiH+CVi08T4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 22, 2026 at 08:14:02PM +0100, Lorenzo Stoakes (ARM) wrote:
> secretmem has a relatively laissez-faire attitude to accounting the folios
> it allocates.
> 
> The intention is that the memory is treated as if it were mlock()'d and
> thus is limited by the RLIMIT_MEMLOCK limit if the CAP_IPC_LOCK capability
> is not in place (which broadly allows unlimited ranges of mlock()'d
> memory).
> 
> The lifecycle for memfd accounting against this limit is - account on map,
> unaccount on unmap but the lifecycle of memfd folios is allocate on fault,
> deallocate on inode eviction.
> 
> This mismatch is problematic because the folios are unevictable and remain
> so until the inode is evicted (set using mapping_set_unevictable()).
> 
> This is problematic as it eliminates usual mlock() semantics - mapping
> folios then unmapping them does not clear their unevictable state, since it
> depends on AS_UNEVICTABLE, not PG_mlocked.
> 
> A user can therefore easily work around the RLIMIT_MEMLOCK limit - simply
> map then unmap and VmLck no longer counts the secretmem range (or more
> involved - fork which also achieves the same thing).
> 
> Worse - they are not accounted in the process's RSS even if mapped again,
> meaning the OOM killer won't know to kill the process.
> 
> A user without the CAP_IPC_LOCK capability can therefore repeatedly
> map/unmap (or map/fork) and consume all available system memory with
> unevictable folios and cause system instability.
> 
> A secretmem fd can be passed between processes and over fork so a
> per-process limit simply does not make sense.
> 
> So follow the precedent set by io_uring, perf, skbuff, iommufd and xdp -
> track the number of locked pages in user_struct->locked_vm.
> 
> Since the scope tracked is actually inode lifetime, the RLIMIT_MEMLOCK
> applies per-user not per-process. Also given the change in scope it doesn't
> make sense to bypass for users with CAP_IPC_LOCK, so remove it.
> 
> There is simply no reason to carry on marking the mapping as mlock()'d
> since it's misleading and the lifecycle is now correctly handled, so remove
> this too.
> 
> Additionally, fix the selftest which checks the limit as this now must
> assert SIGBUS on limit violation on fault-in.
> 
> __secretmem_account_pages() is more or less a duplicate of the code that
> io_uring etc. use, but since this is a bug fix that needs backporting,
> defer any de-duplication efforts to a follow-up.
> 
> Reported-by: Daehyeon Ko <4ncienth@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20260813225328.2010303-1-4ncienth@gmail.com/
> Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

