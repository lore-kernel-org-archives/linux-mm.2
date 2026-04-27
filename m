Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8418BFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54416B008A; Mon, 27 Apr 2026 12:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04D26B008C; Mon, 27 Apr 2026 12:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1AD76B0092; Mon, 27 Apr 2026 12:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5596B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:22:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B9E740CF7
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:56:04 +0000 (UTC)
X-FDA: 84704787048.20.DE8BFBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6E6DC100019
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:56:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dbh7pNvl;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777305362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWC8elueKMcWLFgLmq31j2LqM6n2xpTf9xGZ8V075u4=;
	b=4ollZEg1eNJ6inc//9282fz++VkjF3jtZMkni3c7tHA7V1Kl4AJF/Sl9MNbAIZmkXwCwan
	/PSdRrxWLNlYvz2ml4TW1zK74gh/8kd2hALAtSORKIfgXtIljuDBKtuqeUc9jCNjKyIy3D
	hrSXg8eWxZ4una66Up9UDcAMbRgDk5Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dbh7pNvl;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777305362; a=rsa-sha256;
	cv=none;
	b=kTBg8flCyB0VIHaconf5W2sJsfxVdcLiNCPY0I3SJ3/b+HNWzcIGnjZfR4ulB7im0Zppkn
	sl15xfsN5vgB/itx4wHdvVh1CJbAYTGFz+CSH9+O09OCtayMHDwCceAzI0CKpaENTjPYgT
	i7Fv4PmjYOFDTmQPfFjTLIHcf4KbvNw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE87D60126;
	Mon, 27 Apr 2026 15:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF07FC2BCC4;
	Mon, 27 Apr 2026 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777305361;
	bh=CybBkUF9PqqrkXon4a/OotVsf6egaS9WEDxo0coSCCk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dbh7pNvlqujxe5FnKHZ43oaR7DpNHmV0YkHnDdqyjresMN5AOnx900oedYNP3oT1v
	 Z9WHVsu0W9QrObQNcQr/NCTzwuncqFQsnSYonWUK+MONsi6XRg1/gEw/FD49bbQvBZ
	 1QdY3zu572TlcvnLusTsZbJ9sxkYgiK91W2nGjFkCUAD7ErCpwxvqHhTRWHC2qUK5c
	 zpa8bT4spd52AzUbXp72p9qWThv34zzy69hKfFeIq2IRs52DRIUZBU3OTsxTpSUkmI
	 +tddMYK4syoRbwSVzUDf/yAaSbOoTFaJtNxue/WH/A/bdZNmr5VR7zQ3Ri3EsXzDOZ
	 g4Plm6qqbl0QA==
Message-ID: <52506ad5-99fe-4686-86bd-6d9e38b5ae36@kernel.org>
Date: Mon, 27 Apr 2026 17:55:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] mm/slab: introduce deferred submission of rcu sheaves
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-8-harry@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260416091022.36823-8-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E6DC100019
X-Rspamd-Server: rspam06
X-Stat-Signature: 7ry3uktikgz5zy6s1prcerqcqhqox5cb
X-HE-Tag: 1777305362-76286
X-HE-Meta: U2FsdGVkX19MyYX6xpGfUz3ceYyUefl40eMuN3+tDOoJL1CUuGEVdkeYS+lLUOp8Ptm4nB12plxoN5K9BwEymRH3SLH7L9ynW2JSsV7f2zvh9/duqvUmlioXJT41qLNwkSyJDui19QlYjKJdk1c9V3EgzufwOABOCvG3e8DuZl8OD2HtfJsckiwQWZvVe3OE6P25NbyT9GskQ9++usJ9YMyZxp3j98PFWGpdtPDUawfp24Ayqu8JVK1cJLNPlMvPy9h8fB2KrrUshfiEFX31LZMrLBt3yasZqyI2mAwVskuFC/nlbt8kf2a0sqnGqHaZO31J2Fs2XCQpw6S0Kn4JORpww6y3RkPSnTi66mTtvcDc+b2tuy+qJMUgx4eQ5sRvetc1eY8B30OquLO6kSLMjIsG8pM8kv2Hs992jzCs7o4i/U2GeDTnuJM9aB4+JWI58sFYFacnAXOtu2Hh2c6L/89xhyFizm9HHlzjNlxO6PxmUqQLYijO30q0jSmjlps9apx6JOdC1iuI45zBAferW8scd+8Rs41m62jIdqI0pGODgfMmZHNVg9PTTIxStjvVSba+7Oj5FDvvDoABPEepmAEfbp+2auGOWgfS5pCM+Pso+7iTrWpyVOBK4qevRi8mU6clQzgx0NIHregBYwr5jEavsud9FIh+GFRl0FPboEvrXTaKKXa9zOwyM22O1Gz/0w236FNGDGtKpBBaMW097hBF6czW2ZQYPd2yN6pa5M7rtgYfWcPbxR9iqhoajISZKzmLFtVAOln7dvaSiHAwtiXM85GlBf6jWQL4aTaDIQ6u02NnGKoeTyVG4/wNXxoernI/Kkh8UAGjR5pirOZoA+RZb7/7oKotAP6jNbJXx8BJtnA3rr7ztv1Tr+2lZp2sXQnbkKUj7ErNtkd1KmrlKjJ+fnLWYQePO21FlBj5WOiQjX6lVBHACie1Yo/GMlclGIfTwIKTyIU1CW5YuLo
 GLHSimc+
 CTBSzZS7TlB+KsrzFMy8KBvvHL2fVumJs/N5BHq4A1R8aVFeuDwJQiIXHt7niffwZa4uExNY55pQFiNyzf59Inkdmd3wGm0+jvkHV1SolrmOTWbsotHqSnWpacqnK0OG1sUGxZ8WYdnJcvMUpVLWxuh7xZAlYY3gV+vAabr/yBBS9ros7t+9fqmvFBtp76L9c7kTrzUbF5qAjU4xzxjMiDfXu4PPbU3gKsY01wLuA+EDHpu7vlv7sJWYXnyGiuAyMqHbBdFM41hhgpTxtMrJlJBr51w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> Instead of falling back when the rcu sheaf becomes full, implement
> deferred submission of rcu sheaves. If kfree_rcu_sheaf() is invoked
> by kfree_rcu_nolock() (!allow_spin) and IRQs are disabled, the CPU might
> be in the middle of call_rcu() and thus defer call_rcu() with irq_work.

Seems like we're doing two things here. Implementing a fallback is the
advertised one. But also narrowing the definition of "unknown context where
call_rcu() is unsafe" to mean irqs_disabled().

Where does that condition (!irqs_disabled() means we're safe) come from
exactly, does RCU guarantee it anywhere? And if that condition is indeed
reliable, shouldn't it have been used by patch 5 already?

> Submit all deferred RCU sheaves to call_rcu() before calling
> rcu_barrier() to ensure the promise of kvfree_rcu_barrier().
> 
> An alternative approach could be to implement this in the RCU subsystem,
> tracking if it's safe to call call_rcu() and allowing falling back to
> deferred call_rcu() at the cost of more expensive rcu_barrier() calls.
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

