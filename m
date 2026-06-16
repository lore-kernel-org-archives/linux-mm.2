Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A362BCD98E6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE036B00C1; Tue, 16 Jun 2026 17:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5D36B00CF; Tue, 16 Jun 2026 17:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3876B00D2; Tue, 16 Jun 2026 17:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 165396B00CF
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:05:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EF6F1C31AE
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:28:14 +0000 (UTC)
X-FDA: 84886459308.27.A4E58C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7C589180004
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:28:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZNzoKRNX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781630892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyG97ng1Fn1T2laiW4tpsv24G07CL+haanDsoY1+JKs=;
	b=rZxjjIqVZg5y4qE5SZS3VON4b97idlNNJwXSHbwSJqZsWd0BGETTLeXreoctzGWspCT7Tv
	DnrF55P0tIqZU8GivLwO2qUz02aPRMDnmUVnsXnR0b4N7Ad8cCJKuBjztGSbUiaegf14bd
	bTwXL0SwfqM6oAAgxN5XYvZwfSp3fyQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZNzoKRNX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781630892;
	b=bN3gpCBBiGEYJ0zg/JzmSVKZT+WJBKFF3pPCybfeLsEqVfcPQoAyGIgKIAw7aXLIPkxXRu
	OdFnPPj+akMWXHbiTARzthAlXS7SfHVJRuPfevaUpT5kQpKDViRvdr9+3+G556VPQKjKQp
	zydZEJhRx0NQZXdJmXX/qoK3uPRZP0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11CDF600AB;
	Tue, 16 Jun 2026 17:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D9C1F00A3A;
	Tue, 16 Jun 2026 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781630889;
	bh=WyG97ng1Fn1T2laiW4tpsv24G07CL+haanDsoY1+JKs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZNzoKRNXPa9VesT5+aoHFmh+j6Dtp6RDQphh2tnejnZEsrzZBWqKsfstiugwI7nUY
	 dy3UtCeldFvqMroY6SC0uxtG631j0tT87BqPlen3Hg6FIz3dPFKYuYYxsjkmdR+gDj
	 aYmPyufcMcQN7UjRR389q2MeHOJfF1vX7hwKQp+oxjct+a84Ex06Jc2hPnOISi/ml5
	 ENEAQmdPEtBiMtk/cfEu5z03sYntLjNdzeSgzA3WGm5iV3rt4AZxOi0FpLT/J+TUMY
	 FF/9CwCLTCvHehGD2vSnOCzHlrVAy2o0z47SqJBZmws5g2gn5kv4TNpo3oKC8oQzwI
	 diCYM76RBlP2g==
Message-ID: <26022de8-eea6-4684-bb2d-05419b10d898@kernel.org>
Date: Tue, 16 Jun 2026 19:28:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 7/9] mm/slab: introduce kfree_rcu_nolock()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-7-70a54f3775bb@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260615-kfree_rcu_nolock-v3-7-70a54f3775bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C589180004
X-Rspam-User: 
X-Stat-Signature: gx9qkku4ekmafgbz5gg6s7jf7jjjbmwb
X-Rspamd-Server: rspam09
X-HE-Tag: 1781630892-607529
X-HE-Meta: U2FsdGVkX1/qOzbwFMLNcgy2zOEPVJtvXDmHyFdgWwQ2iu0aOa3W/mw/rz7Bos+1PW//xahRJIV0nHjRxJZ+C77Aa9EOrTe9VoTTcH807VlAqe/bXGF8rBgBzKAwOsMYYHNvusE+Vai0gzHWdkOn3VI9V+zgD0ZiLxmDU2sea5mPDRHczoX3PFVqpbAalCQCgOZKjFSbSz78kbl3UhHp/R5+MLX2SEliFO3F23U2dg35dEMmuDIeqscrMScQJP/GNQF6Vg/CHuEs4jZBMqrzFVIaCS4kybv26xYk11ugEWWGYXKhbK8jUKUL76fGl15H9VTNNGlvABZc9ylosiQ5IjO78yAoDHMCt0KkDQOJzXIZTeTZ/KUAJSpqK8GnGe2GXGxgU0DSKwcEWxq+ds9Zy0EeC8HaNLwn54k2uMnObF5GcNjFk9JANh8Hd/umMmi7RR7HzFNMIM0P9G6vmXISMgRLdD+qzF3VCEjo5X50XrkyvyPOD7slsltKO2knLsw1J+P3NvXyALhdP6qUqQvwCNvBSjk9Rs+1oRsYZRRGIMQWjO3e3vH4ur/Y8VBdlnete/vPocjDu1EmAa6ITeA56WAmJMkehaOasZRiRLXzkR8ByCp2GtweMdj8POOY+3NF2wwdFwAjzXCFn6mVq7sAP35bns47vMRSfm+qR41Fx7ZLZk2QLQ+xyI4MyOCmZLgy8jA6cqJ/uW5CP9hCpXE1qrzIP/kX+IyQZC+ifOiRcNyjopzBU0ZsemSTI6pBCj+50GJ8jWdO9EB6jFyg0rqq5XD+Ao3HMBufX0vmQwS+gRXsayQXpsYTII0akXe5UGtOi8oGPDix4PPlA2iN/qc0Y3yej+eesG3E53KsdQl6J1W5XlT4I6gRssaBuS9XeDnfq0ImfyGz6ujCKs8ILd80wdKpnZimZzU6gVWV/xgGdSKifH6XNbUMkYEPyRI5vOrQMThxSJrMT6ZUvDAqu05
 XHqZmlDi
 ImqJN+6hfubra+H9MjEVq8a5T+LdP283DoKHNrrDXmNVxHcHK+lCzX35dJoKhOTHEYcnlp1IclP2wrxN6W2ESvb2jc/MNurfbxqVvELAmi7G6HWPR4o87RJOzGD1JTn/xDnqcqBKyz2MeB0SeYdnKamDty88+VjdMlTDqcj+MBEGdTrCKxJrKySICfkNXBMI9mcf8Qd6uSY7CEmEigsaNtXJSmWnrrlNE9tpcMQKeV1HEDnE7MiNCcK/8np+W4c92UIVFxhfLcet1dH8upCF16qroA7V+MszgIs+FpggkZ4d7WKR4IjoLSPps+NDT0zmvUL2Ja3+Ib2lxIpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 13:06, Harry Yoo (Oracle) wrote:
> Currently, k[v]free_rcu() cannot be called in unknown context since
> it could lead to a deadlock when called in the middle of k[v]free_rcu().
> 
> Make users' lives easier by introducing kfree_rcu_nolock() variant,
> now that kfree_rcu_sheaf() is available on PREEMPT_RT and
> __kfree_rcu_sheaf() handles unknown context.
> 
> Unlike k[v]free_rcu(), kfree_rcu_nolock() does not fall back to
> the kvfree_rcu batching when the sheaves path fails, and falls back to
> defer_kfree_rcu() instead. In most cases, the sheaves path is expected
> to succeed and it's unnecessary to add complexity to the existing
> kvfree_rcu batching.
> 
> Since defer_kfree_rcu() can be called on caches without sheaves, move
> deferred_work_barrier() and rcu_barrier() outside the branch in
> kvfree_rcu_barrier_on_cache().
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

LGTM, nice.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


