Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56805105F796
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 10:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599D96B0005; Fri, 13 Mar 2026 06:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530496B0088; Fri, 13 Mar 2026 06:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466666B0089; Fri, 13 Mar 2026 06:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33C866B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:40:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A7B25B900
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:40:40 +0000 (UTC)
X-FDA: 84540696240.24.22E0066
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3951A100005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:40:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jORxnQ/C";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773398438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bRz0a5rDf3B7IZQUMIebticNEhlGjLTFEMcGXq89IU=;
	b=qpaCfzStzYgMW3MEaGu3rjaHEtdF6sIEof+T5fnDeyIEFOzKx+XTFdM19lD3AidqXr+MBN
	LKfNiOL9PvE5tQ4VrD9z/HF5EsvmfZrmS7xB9bHDD8DlEo47xLM7byu+arM5VCuJ7Rs5tF
	dJpA/H8eK550yGg9ZUYiYMw5d/AWI+0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jORxnQ/C";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773398438; a=rsa-sha256;
	cv=none;
	b=peSdXo+ycWtU1J8zfbO8Bl5rL+Jpt18UfFJFnUu+F2VCKaSH23DEZdJPbJQp+lnSqZF/Sc
	gE5B6GaTvmqvGKY0EpGc/hMIWt1UM5HcoSytUUN8FmTR4B2eauUUY2z45m8r5P2G2HxrT7
	iKpno2t0/5Xe/hd5mlYY2HGAEIXBD5c=
Message-ID: <b3805934-fb0c-4834-85ea-964ce006050e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773398435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3bRz0a5rDf3B7IZQUMIebticNEhlGjLTFEMcGXq89IU=;
	b=jORxnQ/CClGmZiyZq5YW/ui3uCz8vIxhsfkcXEcQkLuaZqufBN9zXYt+nV5DXaBTlThPnN
	O6vuRlNHol4OE/ixrrJ0fAFgtvrTmXUcL5JngaiSvjRnCV7XdPLs2LbV6iMu7vNhpvYawx
	fqBAxtD6NBt934ZI4NcyFvqw7yG7gRU=
Date: Fri, 13 Mar 2026 13:40:29 +0300
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred
 split queue
Content-Language: en-GB
To: Andrew Morton <akpm@linux-foundation.org>, SeongJae Park <sj@kernel.org>
Cc: npache@redhat.com, david@kernel.org, ziy@nvidia.com, willy@infradead.org,
 linux-mm@kvack.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 richard.weiyang@gmail.com, stable@vger.kernel.org
References: <20260312104723.1351321-1-usama.arif@linux.dev>
 <20260313001630.80081-1-sj@kernel.org>
 <20260312175241.01b876f3b325264f43312d79@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260312175241.01b876f3b325264f43312d79@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3951A100005
X-Stat-Signature: naiz3i71cw9wgphodsnc11od1nbmjxg5
X-Rspam-User: 
X-HE-Tag: 1773398437-43793
X-HE-Meta: U2FsdGVkX1+XL2bIdB4Ly/ATYKnhKAnCRHj0lV0D1DzoLViIki+vjwYj2tDBHxqLooCkHoBBfr2g77OyXmeiW1nUmJYoHXyVbMopiaUP8y4qh2vAfBgLf8r4LJ6+bG39uZtQgFUdBYRbtLeC2kK6H2rBiuRtQcE+DCjARU3R3X9L9830TDrIWOhT4B6Ob+lMlnNHIhs5uNJ4oPI86CIPyruWaoiStdFvUUZZ6hZsisNbYlDVVbgO4mTQRw8H45hvshhYRhvpfXQE5cH4/TpIeJJg9It7n9TbYQPx/X0LWHs8C8JP6Tzu8zUYRJekX/422OSB2+ipQer5LFSIOgkCi0sPPR/QZ5+fjwVYforTLWZ3aDhldUWEGwwtPmYW9aUKZx1ddo6KRCGW3dOyWj8vc3/IjGSQ+6RnOZMqDi3U/Qxwrh51QEYyIOJdMB775OJ1Yu62hIxPQXN/UCxtgHkZn6oRFgOcldcPdYDbBbu2zpiycekrleRFA6yLzv1zoayh5kxcNmOuiL5sgmJ48Sy3Gxt+iU7WfBZAns6lQL/t8pMsBOcLgRSPr3G5Wc8fqtKyX4KV6qw/5mwjaj9aKo5OmP0EJXq0W1XRmodfrPCtQE3vWWZeK+8Y15NkzX42WDGMB7EJfF6PI4vnxFGox3Tm8o218Si0NeWoEtmuykUEwjka9GSdmS1+HkqQAE3vEX/n+hd/DlDSrMK+/X0AcE1UTIy8uFRn1EvIWufspnxdzylYrFiXRkMsHb2W3QtiiiERl28GlB28Av0K8oZZo8GzuFuGuOTSGXjWNzcwjF+9r9tgSxrPGgIvGvlYim8Zhc7ICloVHyi0R4EjUYpWX/HDmvmYlD/VL5+e9Wd0CMKcRdHSZFeM8VEhsN0+f4eNfAFOnIcQqw4XbkD0v7P5W8O/dqhEHgN14qx1s46ExtUWJkewo8bwqGPh3+26ISETtC6wgpLRG9xmDknM84vThxj
 ctw9Gy6a
 DgjTt7itaBZgNJtgHZk4z6aGQ6GpW41TVdNd3x97oa+GFNLm3X+yasj9Oms3pRSJN3tO+Hi0G3824qnE5BQeWlaUBzDijXwqk3kAsNzYiA5pgO1nTbzynguRpfPo0vFaQ8xPhSOTRNNp4FSG0No6+5+pK2T67ICNPmRUQvqqr5tAF752S14kLepwg330TrYbwgv7yM3+cSm+gqEtZqmrLL7ep4hsbXM4GTCXPRWckiYwW5E3wc+ST0WvuIjZyQBNlyO2BKkYSwWGvszvFKDPPNeLy581ihgLIic7JFmLEqzz3TS6HuXbRzm58xWZSDEIWSPRyYsKHRfrIN2ZUSt01FzngVzRdOt2QbrmSXIVeS/10rE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/03/2026 03:52, Andrew Morton wrote:
> On Thu, 12 Mar 2026 17:16:30 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
>>> By the time migrate_folio_move() runs, partially mapped folios without a
>>> pin have already been split by migrate_pages_batch().  So only two cases
>>> remain on the deferred list at this point:
>>>   1. Partially mapped folios with a pin (split failed).
>>>   2. Fully mapped but potentially underused folios.
>>> The recorded partially_mapped state is forwarded to deferred_split_folio()
>>> so that the destination folio is correctly re-queued in both cases.
>>>
>>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>
>> Seems the commit is merged in 6.12.  And I assume the user impact on
>> THP-shrinker enabled systems is visible.  If so, should we Cc stable@ ?
> 
> I think the user impact should be visible to backport, but the
> changelog is elusive on details?
> 


The original patches added THPs to deferred_list at fault/collapse, they
got removed but not added back to the list after migration.
This patch adds them to the deferred_list on migration. The user would
not expect the THPs to get removed from deferred_list on migration, so
this fixes user expectations.

I have CC-ed stable@vger.kernel.org to this email. Should I resend the patch
with CC stable in commit message?


