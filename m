Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377F1FED3D6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F7A6B00A9; Fri, 24 Apr 2026 10:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705EF6B00AB; Fri, 24 Apr 2026 10:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D1E6B00AC; Fri, 24 Apr 2026 10:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4516B00A9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:40:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0691A01AC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:40:28 +0000 (UTC)
X-FDA: 84693710136.18.C03CA6D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 48237160013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:40:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=sVfAMZEf;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf08.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777041627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZWsZXfkCJdG85BGLfewXfKgzlxRh9RmyEDX14KHVAs=;
	b=6Y5OTVJvBBrWjzYJA6BaiBcijTQE7LNDQaihOqMYwwg1rqnUkhQHdKgch5Oa5WFgervjUV
	odvBkk9XxRSRO3nyHjm5NtYhO115xkRLhu5fpMgipyVbbJWjw8epVDbfAY2lcKRx6PyKV8
	S0ZI54fN7IR10fjUX1AaTGgUoTFLhhk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=sVfAMZEf;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf08.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777041627; a=rsa-sha256;
	cv=none;
	b=J+IZOB4zvO6DYPgL6m1iBH2x1Dis5RtrfbK0HtHBO2wxxl4j2q//MEFGpN/Bz2IxVPepAe
	daK7d5pdEHkpOKEeq98w4sIzYeSZl9B/mM8LVfFp0p+8OJtG2UVso7wAX2TitZ8t2oEe8t
	2Kx5f/4s8shnztvym9poYFJ91+sr8fA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MZWsZXfkCJdG85BGLfewXfKgzlxRh9RmyEDX14KHVAs=; b=sVfAMZEfh7q1NDuffqvDWC4ruC
	BopU9PZQ2Y7bl9TT2MytBxrPPv2LMUeuTZI1Kk5nkD66ytloA0VRKNjeIgYS1TCMI+v4YQJCPOpAk
	IrfrVcGu3H04M/0rDDpAg4+nPOPaMxcywtVSg5LqqJbGLF2LiIEuWr+BNkSayHw6rI8/Z8ogg281L
	NPevIFXsYO39nwDJRKkhbqurwqcZxQs8W2aTahxB0NImCywDnEXjAvPHFmSdoJR03L/Q+qvscT2wM
	O7IjwD4R4atdXyGpyDRoOSEzapT2Kx3AqgoWeyUAQKaxFi8CJuUwORcAuYJv0YHCXHoIHuKy0gSKh
	7XZzuaGA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGHhI-003F2t-1K;
	Fri, 24 Apr 2026 14:40:00 +0000
Date: Fri, 24 Apr 2026 07:39:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 0/4] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <aeuANP7U9IEzA2X_@gmail.com>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
 <aett0XmQ1EPSDdnY@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aett0XmQ1EPSDdnY@casper.infradead.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 48237160013
X-Stat-Signature: id9ozrenpmrsetjfq9zgitgfrtpxy55i
X-Rspam-User: 
X-HE-Tag: 1777041626-207476
X-HE-Meta: U2FsdGVkX18Horj5obz1Jg4wNemn58BaKdhQq0FhCVI6jolH5GKuYnfzAyUl/mAPwK1xveLMUWcE27GRNNov/fnEgpa6jat1gZ9pQZUOmKfgEmlDqyOEIFPtvhqAKdcAIi7y6FVt5t+QU6jPQN+EtLOGJ4r24+v660G71XGCFR9nOBUVDSbAnaPQbrFUym9N50R7MtiPoHI0LEFgsCa3TMvvJCwHL4Bmp0bmxmCi8D96r1lMtZplnj4nzCl5hAz8stX3kov2a7f7QziWzXqLmFkPVD6MCQFg5NxK55AWn5wDg/I3osz0rY8OlivbhcQrSCvj7YM9q50m2jVSFMfV3McL6/cuKH07ERk92syPgmN/Rb051caWCxYp1yaDUZMFpQVvepiNNSSFOcge8HwNI9wMTLx5YqyK4i0D1vH++gBNGij/V+8peQFVtC6rkb3hdW53Audd8OFGhyCjFq58SXNXs4+HPCWjKBkBM03zzFysFJKh/IMf77sTHbQUryHTs97vE+RXyMDvMSBPnsDAMr6rBeXgNK9qOLnp1zb+S2Dl6g9g+sk72T2rL+usVKCjA/f2vGbJMwWET1aAeIr/KqnZ/FSE0TAttVoJZoEsnFHR5cwkSjzPYS2ljgefW2G/lmA5SsF42LfY+pNcmA1o0Q75WECUCXJ/6GWr2AhGFWDW33+cgVUF7u6I2AKKXzyXmCBZJLlCqA/3F86j7hEmukIDnGslPWkOiF3yGU5bCePBUZI1Y2mmkV7x3FkYfg/EnJ4bbGAvK75fr1l6rCDxnQBn7KFEVI7VgTb10UL+7Ynv8N5zwW6Kll/DXFZfbcFLlg1mL4g74rulqM28kHJ4puIWMmfbyQ3xprPpBIsEj4ZLf8KtyTbeM2/vljhuGpw8zHPGItmsAqiAZB+0Z7KVlTlpN2Dc/eLPmxNpSERMWsobT+Em/O+ZODx3bl5xE+nUvzmgZldmjXEJLqlJduF
 XpIRqLoR
 nexNmQVQS63SkYnqy79Vxd7YhNvS5DPdd7CO6hbI3A91tejDZc96HA6fR/KujhXpSis5S62HOcdlQDqaDWv2gEBHwVEn75n7yPYjdTGTHw2YNrgzioqbW0iDGJPTSv/KZPNkKKzWYPvB1OvIh2JrVQZlTYiApHAXJEo8MGyPTTjYRbVTGFWZgGV9jBN1SC0eif3BI+RjbG2aKh6+7iba2mfqgNQtlzpa9zT4u4Ld5JuPxChLQAhEMebvanTvBR+X9PM4+AfvQMq+MHyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 02:19:13PM +0100, Matthew Wilcox wrote:
> On Fri, Apr 24, 2026 at 05:23:58AM -0700, Breno Leitao wrote:
> > This is a common problem on large fleets. We frequently observe multi-bit ECC
> > errors hitting kernel slab pages, where memory_failure() fails to recover them
> > and the system crashes later at an unrelated code path, making root cause
> > analysis unnecessarily difficult.
> 
> Who is "we"?  Please attribute your patches to your employer by putting
> their name in brackets after yours.  My ~/.gitconfig has:
> 
> [user]
>         name = Matthew Wilcox (Oracle)

Thank you for the feedback. You're absolutely right - I avoided
"we" entirely since it lacks proper attribution. This is something
I catch before subimtting patches, but this one went through. 

I'll update the commit message when I respin the series

