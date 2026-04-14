Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F6FED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51CF96B0088; Tue, 14 Apr 2026 03:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD8F6B008A; Tue, 14 Apr 2026 03:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8FC6B0092; Tue, 14 Apr 2026 03:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD6F6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:56:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B52F88B697
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:56:44 +0000 (UTC)
X-FDA: 84656404728.02.CC52F1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E812E1A0006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:56:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SxNNWlJe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776153403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WisjpNFP0wiEmrw3s5UoQ6y71ngek50ll0nTfHvPE9s=;
	b=fUjJ+ZfahJabx7MK2h1DQW7yCyowIGyTRMvRbnacWD04Wy4ZKP8jbnTk7gjwjm/V9nQ4hL
	6Ggy9fv1N50ljnTVHW1QNyUzRB4L9n+YhoE7Vs28Q4AHEjD4i5hfEg/qarWTX8+x0oEa8M
	SQ4+eKCah4oXK1XrKQvS3BQDJ/7DoFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776153403; a=rsa-sha256;
	cv=none;
	b=B6qKUdM6G0rAgjsuMPThjCfScyiIAyGg52X0SfULvoTsEqxcd3K+9SbEUGZpVm7Gv1CqYE
	wvdf5223EO7Lf6NMWBrsBGi9HrRUIutzDTxQR9CZ/a8EvioeW7U1/M6WhE/E4m+2hZoSz5
	Ae4Ea4aEmJbhGt4YoC8eVOQOmpHrHqw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SxNNWlJe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E93ED43E97;
	Tue, 14 Apr 2026 07:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB928C19425;
	Tue, 14 Apr 2026 07:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776153401;
	bh=MF/GH4Czp0/CzU5o1NW/2mD2/47rYS+yvk8ECsG09p0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SxNNWlJeD5aohOwDA3UkElufaBir7/GNQbd0STtHgax6fm620fA3M1/yHj/e1LkC/
	 HugQj9UB8Z3rF61Ifmjq5/UN0LoYVyGyt0r328Nkx4gYET5Oj6MfG/IP6lwuZ8a+nL
	 QykXPzLtkRXaTJocTjQuRT88y9HJpES6Smzpk7PZ3MwQXOJ+BpAi6HoJyVxNEOeMVU
	 G4ztlGlMM0a9KkZANrWgosRSGYNSaNSRJWgIgQIINSZGt12U8lI5CohU5ZYKOvWp+G
	 53aOSuX0qa8nwDkonPSp5S9MOdIn8qGMFQJaB4r7jAgOfnqdfIdGHCRjsnn/7tghPX
	 bsksHMA4MzY/Q==
Message-ID: <ef2d8f65-b3b4-4a9c-a77f-78ad1cadff28@kernel.org>
Date: Tue, 14 Apr 2026 09:56:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memcontrol: restore irq wrapper for
 lruvec_stat_mod_folio()
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>, Cao Ruichuang <create0818@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com
References: <20260413064833.964-1-create0818@163.com>
 <ad0clnEYxf1H4_S1@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ad0clnEYxf1H4_S1@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E812E1A0006
X-Stat-Signature: w4it546tsffwo63tiwcd11sk6txdpu4w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776153402-91050
X-HE-Meta: U2FsdGVkX18i/S7Dq62VBiMNq7HouWHhAOwOd5i3tjuL4AoHv/+Wcn4ii9F4RnIYTNZY1Kh8luu43XNCypsmRVH8AEvwmRQkpNJQZK+U8a7465k8+lbSjhOocDFThDVJ/TbZp7gPzKHWl7pSiLPYxi3ahqZ5u1v8ryrjmF6QFwP1LElP0nyc56N+r9SgC1uctI7EhcSXLXcOX3vysYTT2rDSY69r6+jYyZLutNeV1y6OmugPS2hzBX9dyScmtMI9SfWjW/NOE85jBrOS1fhmjfvB9sTVgzaqRmHgfWbnR6UceY7l/a7oKviKrrSgJsOnnKxEUhDih53EtpUZ7+SpIvdeKPVSyBTRsmxJe+qN9de8t/DxraVsWPyHMB2m0SV8UoZFBlgM01xjdpx3gP4ovZULQcVKwSTqX9n6Rv5QGXVCIlTP+VHZn3fV0dbGF+wUuufQ/yl+3BhuU3tkBOWC8L8BNpgOm7UK6roDvLQtbk2TaDaXudOm3vFQwzg9n0lLRUqhacqTI656F7KJxoYEFbLhnvEZtxXxrU4mXK3RxzfhlChYWZ7WNunecd7jMQ9grS/BNyz+bAKzJoaBW2RzMwdx1ez18dvKLhFYvgXjX0F50tGGP3dkkdX51MlNlo/sTMN6py1F2KBGA77aq/7aSHAzkAKDNhQB99Zk2OYxTIUYM56MI3ar3uZ892EiOOS7I9M9w6lFKVibJNzCls/ut7I8qUDNZmIDteJrfnaoahZt5GNe4QESmLTzqrV2AH3xlwRoLrinAWHObqTd+y0abntEJ9PtB94afMV/5Zr+DDbVQHgBpUBITd/7PCGAcTbnH6gcph/t0RW8y/AcUOUwJwha+Mk7AXpOic/ceeBFKxivz6Fl66hdDgZD+W56S5+UshC2ZUmcv+57t8v5k3X8E6IZn6AEY7wq6rxdOIRaH++Q6TECK2TzCHyfwjziFqSLa2XN9BBrMN8cwnekMjp
 ZKCERRdn
 itvYlUoAT/BZzuEIyx5IfPmK4N+e1tPTsMMzBVfiTraXi10CSrmlphjoQgr9B6dmjNthS0e/HbYIAjXkEAp1QXqH6N+qrucHlprzvxnA3rW2VmaPhiG7BanVsxqcnK2U/m0/Dy0NwKLD2LNYue05D83b2sMC4QJ5AUwmfqSAM6jp5Rnsa9J0nmKLXB7r0X8mvttUCv4AbHtPXV4P0BOo1DD+V7d8DTM0D7caj+wWAdxldYwdjCxeYwLQG5wJ9Ev9n7iE/hLSUZX4XizeVLCDBHjRb71QD8yXpvnYa0W3ipKZmqwrhdybFVK+TW+y1dAKvQ4112oKDy4vcI4iDR9jFMX6ovx0DKENOFtPvOMR81LCluappSwB6vHsXaFpMf0p58XTmJLB7rqNvvnmPdWSW/K7yMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 18:44, Shakeel Butt wrote:
> On Mon, Apr 13, 2026 at 02:48:33PM +0800, Cao Ruichuang wrote:
>> Commit c1bd09994c4d ("memcg: remove __lruvec_stat_mod_folio") removed
>> the local_irq_save/restore wrapper around lruvec_stat_mod_folio(), based
>> on the assumption that the underlying stat update path was already
>> IRQ-safe.
> 
> Why is that an assumption? Please explain how lruvec_stat_mod_folio() is not
> safe against IRQs?
> 
>> 
>> That assumption is too broad for lruvec_stat_mod_folio() callers.
>> This helper is not just a thin stat primitive.  It also resolves
>> folio -> memcg -> lruvec under a helper-managed RCU read-side section.
>> 
>> syzbot now reports a PREEMPT_RT warning from:
> 
> The syzbot link you have provided has the kernel config without PREEMPT_RT?
> Where does this claim come from?
> 
>> 
>>   __filemap_add_folio()
>>     -> lruvec_stat_mod_folio()
>>        -> __rcu_read_unlock()
>> 
>> ending in bad unlock balance / negative RCU nesting.
> 
> If there is bad unlock balance, how is disabling/enabling IRQs would solve that
> issue?

This is obviously a product of LLM producing a patch from the syzbot report.
I suggest we ignore everything from this author.

