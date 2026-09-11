Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 474D6C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323136B008C; Fri, 11 Sep 2026 06:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4856B0092; Fri, 11 Sep 2026 06:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA4A6B0093; Fri, 11 Sep 2026 06:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECDD36B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:52:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6973A01C9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:52:48 +0000 (UTC)
X-FDA: 85201168416.15.935FE79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF0471C0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:52:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TMai2M/J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789123967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0wLJyzoS+rujzOY6JY3rDS0t6N6NQfza06M9gcgofo=;
	b=TrdFLKIQNB27gsctbkF8+NrxnduadzjpH7FraSojoYB0g9guFkTTnZp13bxKuOp0I8E5Nn
	Qjsa0wbs4zztoQfouNUc9U0fbvfBSqYzmVy3o7tEfMYo71GY3cPvfpwDSAVhTDi9cf+uAC
	SC1+7yAXMv6nDdcurhz9ZrH3/p4fM4Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789123967;
	b=u0opqPCd4ZJWSaEKxXdcXWtff6WIj7B48a4V+bQnJmCsTigBDEgOnOC8DMWIq3u/whsezp
	E/7k9hgw5xTxXucpkrAqlv80P7XG486pPLlcIdshqBNkqLyiNDUYhlteLCl7okQYQhhhbl
	5+26S1HPwN9sxKIRcvcAV9i/SIxVM9M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TMai2M/J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1562414E3;
	Fri, 11 Sep 2026 10:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553D91F000FF;
	Fri, 11 Sep 2026 10:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789123965;
	bh=X0wLJyzoS+rujzOY6JY3rDS0t6N6NQfza06M9gcgofo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TMai2M/JzHX97Uof3kYcZNAXQxel+xYoWDt/nsWStU1GsLYFl6mRdPH2B6r1ujc4J
	 eFHtj7ktF0FM3oVUDCjjkGnA2ySaseAaONIGzvxd8fKMQKtM0uLlnnpL4Bh3EU+O9q
	 lA0G9iakdBgTAzB4VMlc7MW4xd8FPUO9HSKG6wkooCyjJI32HmMV12LlKT6kGdEFE/
	 iHnV2fjW2JqnLRLDsMD5vdgP9nuUK3QbYMy5PLFBnOVkxlS8ZeWJ+diTH1ShYdVatl
	 0y2uZxCb7gT5yQJRJ2TNQjwp0+JwvIQSgnHgKf7eyuhk3z4NW3nqW3E078ejLa2HrQ
	 y3c+tcRPpLFUA==
Message-ID: <008dcaa3-2068-46e5-9e58-afb590d90584@kernel.org>
Date: Fri, 11 Sep 2026 12:52:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] proc/task_mmu: remove unnecessary helpers
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Usama Arif <usama.arif@linux.dev>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-2-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260910234737.1340642-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EF0471C0005
X-Stat-Signature: ggp8mtjo1i4tj3cqa7sq773dqk3zo6hp
X-HE-Tag: 1789123966-501970
X-HE-Meta: U2FsdGVkX19Aloa+8WTfEwD6BdZBdve+SS8mRQWzaY6ryyp33JcfAD0yki1tKlbkQoIaoc84FH3m5pp7qkGqfKItuJxD+u6e5I20IHqXDt0mvnP2KuuEJMmSlbq+Z1GuZNFh4qF+gFElxD4VDQUuH1QXZv2idpyh5kq+sNCermPs1j2/QMx5cQMk58HVF+T/0HhFCpi2tBQIUOx/TKR6FAwu+8nDU3xfs4gZyLrV+Ew4+CC28hK28i4yqDxenOj8iyRZXhwKtvqDX0n7SWBMsm+Ci/gbCSzlnwYEHBnBhUp7Ahf28SEKt0ICiJBIU6TX40YUWXdwerXFi6wtepVdMGxIxqnZxL3J5H3Ybbdmvda6oQk/56SHVnvH+BhzQsx2vxLJqJCJYFte5jKJnE91RhVOtqXc/palTF/vaW70BZ+zNVPkCp4FsScpbRduXxJWhATUtrcUc6/+gFzUckllgIr+9FRJPAGyH7wFoESwN+fMnjOZ8jgJ19zHV5nt4AyahLBZZlyLOAXa3Jk/969bE2fxV9d2qlOJJjR7QjzS6R2eNE++iEruhotUdyXt25tRwkQvXaHIfY9lamArAFPBjDy7qLeXckjqSAh84EIw7wXHqUlqZv2puThSWhjnRhQ4jpwuPRSKZPb9OG/Ch2D5iHzP7rOfXw0o/bmFSJXDEpaMExLOiDt/1v+sOTKxvWaP4KwVrQRRboWWd498FUx4Ur+EVzLuosL7eHe1A58q43mUCplUof7bZW5e4rwtrhaH0Yf12GC4Ue71A+7KZ1A2Ssl3A9F0ceBFDCuFTkOJNua6EpMYSk9Nt0H8EyhYjJxUT1LaFTE6GHJGg88ey+rV2auUVp28IG5L9B0F9s2N10nAB6Oh9m8whPNefd0SA/WpXdKgJb/rEZiBDDbf96uxnKvwLeBTOe5c3H7kVnbPQ0927S4CcwgD75gZVF8GcwG4yAhEY03kSBC917HS/Yd
 FXI1Q6NH
 4sTb2+GEag8Gw8gYXPdmvWntn1q3+4ph3wfmz9sX8l01z6a8K7gOADOLMnBmvJ9MAlgfyvA1rlkvImwkhLzwatLNpP/N9M8iAWYoscKfQ9F/oXrFDVwjO85gg4Y1hhoVnfXlAvMHPHZxtPLO/+mXM/e7ntRsgm1DayW6KYOpWjx3vLh52IcT5GAyPGrpWBxyfaxsrAfB28urwwH0aPCfXGFnOvrKN+PMiiswB4QL74Cxe7JO+3hEfJU09o+RbGFZwCg22v+bFR5qLo+D1tTuEMfKarnAJgZUtQn/a9ypx3eNAFj8IRLNEUbQQ11JynYdGpSxOudr/zO9fD/0xEjL/UIW4woV6RQG8pncv46MTujwKt7Ge7JILI/NAavdEwzKVgQA4zZuIv3L55/DDFLgD2MSzaKSOXE0GwSzw3TPKhl4DAV79u/OSdoNQ7vGfoloWYLA9qoF/Ils0txRoRpzS28yB8UzDFwppKFJsS7tuhDmwzdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 01:47, Suren Baghdasaryan wrote:
> When per-vma locks were behind a config option, a number of helper
> functions were needed to simplify the locking code. Now that these
> locks are universally available, we can do a little cleanup.
> Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> query_vma_teardown() helpers.
> 
> No functional change intended.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

I think you CCed me only on this mail correctly (the other ones went to my old
RH address, I thought that one would bounce)

-- 
Cheers,

David

