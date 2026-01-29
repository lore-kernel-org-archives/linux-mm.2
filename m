Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11ED2D6B076
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 15:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB616B0005; Thu, 29 Jan 2026 10:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369A86B0089; Thu, 29 Jan 2026 10:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B676B008A; Thu, 29 Jan 2026 10:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC3F6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:28:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3B8E1401CB
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 15:28:06 +0000 (UTC)
X-FDA: 84385382172.26.905D7F0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54746C0009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 15:28:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SPvQ6zPt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fF4xAtLt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SPvQ6zPt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fF4xAtLt;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769700484; a=rsa-sha256;
	cv=none;
	b=RSeabWmqbeWN370AcRmi3rPvJ5jbzn75gu0ZKnEk33IGzmQMQZ/Mm5GY9EepqnaqLTusA0
	afH02CCrGGN+OO8e+Lc9Tur7sNxU/TeNRvWbEJeGLisSJT4zCb2/4oZLBfuEcLlmvLddHB
	21lXAEvHrRQvrIYzU27sreautDHPmNI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SPvQ6zPt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fF4xAtLt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SPvQ6zPt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fF4xAtLt;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769700484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeqYiO1LEtxxtRWamYuqS6iEqkru6NTx0+Qpp776dGI=;
	b=cloCV937ODWNGycZrN/KkgwwGdHSgpQj7luzHfw+axwIjdrgPSauijZYhPYcAVzrrzFNiF
	i6lpLUi+y+CY4adYgHbfWlGfcnQyLqy6R/niODL6dTKi/3L9PTKunzVFSTvFjI3g88cNhA
	NWVo1y+7qCbbIzTATgLC+C30FQfE9qY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 678BD5BCE2;
	Thu, 29 Jan 2026 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769700482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EeqYiO1LEtxxtRWamYuqS6iEqkru6NTx0+Qpp776dGI=;
	b=SPvQ6zPtckYiTXyT5RAitGUsWCU4ZpxbtLyjf1N1WNFGOcDJGb2dS+LkEtuKIYHILcKEL/
	v0igDFh42jaTsLyb87yiYcuVsyDYP5sS9yJX3OtXkswF4zPjDTxjFQ76MUsne+y/o/HSTk
	l0wtXsTOjMPs6G5ajcKazuisZLqoW+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769700482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EeqYiO1LEtxxtRWamYuqS6iEqkru6NTx0+Qpp776dGI=;
	b=fF4xAtLt63/d4chgP0ONKjUyDIk9keW8dk5auVhPhv6ZOs9qik82fxJzFUG7/KeyVLgI5d
	NCowLYstOMfx5UDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769700482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EeqYiO1LEtxxtRWamYuqS6iEqkru6NTx0+Qpp776dGI=;
	b=SPvQ6zPtckYiTXyT5RAitGUsWCU4ZpxbtLyjf1N1WNFGOcDJGb2dS+LkEtuKIYHILcKEL/
	v0igDFh42jaTsLyb87yiYcuVsyDYP5sS9yJX3OtXkswF4zPjDTxjFQ76MUsne+y/o/HSTk
	l0wtXsTOjMPs6G5ajcKazuisZLqoW+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769700482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EeqYiO1LEtxxtRWamYuqS6iEqkru6NTx0+Qpp776dGI=;
	b=fF4xAtLt63/d4chgP0ONKjUyDIk9keW8dk5auVhPhv6ZOs9qik82fxJzFUG7/KeyVLgI5d
	NCowLYstOMfx5UDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 352C83EA61;
	Thu, 29 Jan 2026 15:28:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id K/UsDIJ8e2k7MQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 29 Jan 2026 15:28:02 +0000
Message-ID: <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
Date: Thu, 29 Jan 2026 16:28:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 54746C0009
X-Stat-Signature: dm5jfgpccaas6f3qec4away5moftwcbs
X-HE-Tag: 1769700484-756316
X-HE-Meta: U2FsdGVkX19vZDt9EpqafG/eKh7nyn3VWSMN7SHKuwxR9YhAFCyQqqWu49zqlkHfXbVfzsQu33WV2eBROMrBO1s/lrZ2nckxh7TsR12j2VXu6hF6NJw88bIA29ip5+ihUA3SDj5VjhijVzidKLDaAQeyzrEZrBLPg/7qygPZ3a749D5J06FnzJeNk7fgyPxRycWeLLPz2U+9Ymh43nK/kF2/KC+wRjSZV9Xb5LefuE4GDTjWbLJgg7y7vjd5DXXEICTYDVUig0MzgrRh49zYPd4xu11Lgt7tRSqjDUUhfLc870kD4urdg5iZ+THemlaRXX9YvtSDuhj/GYBSeLHXM8pLyIzNSoVaBx0B23xFacP9nE7E3sbyHkhtt6GmG5L9SqVy/RqDRfCFxks0tHTDWoAn/b0UsXb2MQWt9sj1zxve9uzuiEhOEb9DKCVc6++sQkzDTEkJCM4uwvbi/4wPzdPwwYCU1YIY9T+oLlRRXptsl2dqBJXVrFLxyj4oiiYD2TD8AV8xj3OR1OA9aPTpC5ADmbOkdX2l3miBVIh+WxhKsf1HX7vTWHxj9So6TQwxTFkrlCPA6ty8hAgV+puhxyRXt2k/iW6dWVdHmm1y3vWdb9ecOy00+mKx68I15R4K6AlfP0mh1lCPhbUuBXNDkX+WWMC8CVICJx3n8oR8bRfQgUemUaYYOkPH1aqHGKinZOzf70S9RNBeHJljipGkKVSF6A5EL+kUDM09hPGEBMwIFWvjqYFd7+Ri+BqebF+IU1cfquf5JFVpONOA2jEfY6rzof4AWC8ChRqut9+kqeo4IoO0I59dcAlyzkb31Gr6Pe7MPGGK8P5JVI/5TB+0SlbrhTTFG+fNpae81pZwMaOcDLCLKodUaAX9BSGqXXm9bczEuKSVYe6wsX0x9cCPucSoPo+eY6fa1vpjzCILz8zRnzxFXbY/1GBXyDvCr7sY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 16:18, Hao Li wrote:
> Hi Vlastimil,
> 
> I conducted a detailed performance evaluation of the each patch on my setup.

Thanks! What was the benchmark(s) used? Importantly, does it rely on
vma/maple_node objects? So previously those would become kind of double
cached by both sheaves and cpu (partial) slabs (and thus hopefully benefited
more than they should) since sheaves introduction in 6.18, and now they are
not double cached anymore?

> During my tests, I observed two points in the series where performance
> regressions occurred:
> 
>     Patch 10: I noticed a ~16% regression in my environment. My hypothesis is
>     that with this patch, the allocation fast path bypasses the percpu partial
>     list, leading to increased contention on the node list.

That makes sense.

>     Patch 12: This patch seems to introduce an additional ~9.7% regression. I
>     suspect this might be because the free path also loses buffering from the
>     percpu partial list, further exacerbating node list contention.

Hmm yeah... we did put the previously full slabs there, avoiding the lock.

> These are the only two patches in the series where I observed noticeable
> regressions. The rest of the patches did not show significant performance
> changes in my tests.
> 
> I hope these test results are helpful.

They are, thanks. I'd however hope it's just some particular test that has
these regressions, which can be explained by the loss of double caching.


