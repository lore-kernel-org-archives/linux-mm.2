Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53AF2C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF646B00B7; Tue,  1 Sep 2026 03:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FEC6B00BA; Tue,  1 Sep 2026 03:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576B16B00BB; Tue,  1 Sep 2026 03:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34B0A6B00B7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:33:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA1841C1941
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:33:44 +0000 (UTC)
X-FDA: 85164378768.02.033C2DB
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9932A0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:33:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TzXPT7Dz;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=j5HparhZ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf25.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788248023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27tX09Ku1yUGrS5nmgj4LhtsjBb7cHNJOk2p+V8FmWM=;
	b=6M7owtE1fEBp41z0SF+FqtTYD5qT7p35hjPL8FYmXs83OeTBlvCA7WZuC2dwsUzAaTcBpj
	06I/zMWHnhxIPwkH4u1sfKTR0C2lcgcxn2IwstZ+UmbmbRjr0UBNCARQEIKlQYzhUQ06fD
	utx6F9OM8beAMp7wgfZh3QkxNm7wFJo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788248023;
	b=FWW66M01gM9qb3Yg5IgQCC9B/uTTQNjKd8QL+ybMhdCvISZmAPIy4Hjac7vjgF6WDPhqzi
	nPHS3Xersqi+4fC76rIrQsDEml21CoF4dD8MCilTg9NGsniB91CsKOBFQuTFRRDdJuntbk
	UIr3YSQKBqDuSmHVmWk1VmP3SWDOlBc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TzXPT7Dz;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=j5HparhZ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf25.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
Date: Tue, 1 Sep 2026 09:33:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788248020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27tX09Ku1yUGrS5nmgj4LhtsjBb7cHNJOk2p+V8FmWM=;
	b=TzXPT7DznQcsARnerro9taiipvSEM2X4U6+EbW/xr0uCME3BEEanTcS3RZhQRaKNv0rNvk
	xLbOEj2o7nhwUkqENBSWmmQaneC5z0upECKOVEg7ddZZgaiHc+F8OkPvYhI1M5XI+/rv7R
	7+GCjWG1qrxKVUYbvb3qO9z7G8FBZ+EGBC0/PfmaIisZewxwvyzGN7T0pCBXk14Xh6vaMe
	WoK+lp2PjmP+gSyE7q4G/BqhFM7RCl+iPxiG2tcFRmY7/FVMKvsEhq2pzWJKTu4WwgR4YD
	tIYR9Oet+Deeo//rNW5xbdDusLTe39SixfjGT9K3QS3v/r89NkNBY2q9+mL4SQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788248020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27tX09Ku1yUGrS5nmgj4LhtsjBb7cHNJOk2p+V8FmWM=;
	b=j5HparhZ5Xj8SedssfmGWoPfae5sXvItOLzUQ2qVxQ1rNXl/NIuvUgxPjxIUaeOrCN+8f6
	gF/WO4VMNvyDGuCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com,
	ThangNN99 <ngocthang2710.1999@gmail.com>
Subject: Re: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
Message-ID: <20260901073339.uyKHXWCX@linutronix.de>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C9932A0008
X-Stat-Signature: 13s3o4uwj57hukuytzkx3sjc9b3fgrwf
X-Rspam-User: 
X-HE-Tag: 1788248022-421516
X-HE-Meta: U2FsdGVkX19YinKbMXG8Wsm3ekXTXhEKM7xNZ3LnSbQ5Mbu8hjcXSEBHLEobfJbfOlVuvr5Qv8HizlgoL+WAxchYpmWLk7TU05Ud+URuZPpwMZo4V3/JNCx9Srr4wLarSyiLX/EfMOlNbTi//mkciHtYRMDL8XB76tSSMFhh12U86GLe50ghR3G1f5+EHYvtcA+4MkA2y+0GOxftBcZVv3p71ZZGct7Z0X/yZinA+gaySQQHGQWZaGmt4N+JZzEm9Wd0+vbz3avsbGqP92D27riuOQpVvRqSyiF1MkAe24MnZmPkHWywpfD0yue9WnGC1eyToRW54Z3EjQv82bwmQ14xjyYrNeZxSic23S+g1+aNPYyyDuSRhRyIZ05yPdp05h+WbsBPUdPXR1Xkr8xxYpm/grpAa8wFz2htwMwCWuqG76gyihskpGXxl0nMfwntBsfIa1Gj8l7y4O6iLBHP88/PFAGYtTHXi+dbZVO9xJ79NavWliDDgPjkNXv/BE2DJOESTvMIxICVdR1cQvi3pG7j3PgFIziOyKR6v7V9CCLgMQGmJxd/F9UURDsoRONbpsb0rMVe2MhgTZl4RjxuA0JCObYk4fC99mAHtUv5htNVrL1SBdQC9EdZCaBDvaAsZPBzvncy4OWibdLbkARS0CFqOwAwuzU8vrmUZlbw/CwDxVEFBzmA5rCIMxe4TiUOroCytUGY0fxO1qR94wXTtS9G0+HdGfhKHzpj/ztczzqWZjZ2Py/7oTnW1zOaBRk5vDAg1II/Hc69yIfDP/m+K56M1cYz2ia5QHpyZ3jiEaKPp9D0OXJFupE0aZNWc+iEI9cw+lKpJFEWoxfsLHpe/qAElig5Lpmp/mni9sI90SAydIJX56pWVzY9fLQT4WD76v5fEzTs1uTx7SA9OX8c/tkQ8EEaEQF1E4tQ6eXhB93RiEAsmYQ0E7hl+AEUabsma+MzZpazgY38LrZwWdq
 wadnaNcd
 SL6g2ZMv/rMF8YU5L26FokSM+acrzGQPbGfOB+op0Cv4vdc1E0qhD5L66N43RM+0svSU5cKG7cVqe3ZemzNLkvZ1qjNWv2Z2BJzWDbBxTt0vvn60r20X8KZkxX6nMVyeEoAdHpkoDaTe19QdBMNnInbih3JDWpj6WqiZElORlV1OL7JfikFJ9oFGxBfW70tw8DL3osabVjye7JOU/YDri1gVlQYgHqOODEWZWm6MZr3OX1wmSqKuPL9RNvoMBjc2cJUdXx+ZUJon0zeOeMn+uIp4ZSQSoCmI5O3lalFI0wc4kcn0cOzDmttlqwpQFeFsf/f3/ItnBKrUyUdCfc9bMwe+hYtb4uvkWZsEeyIRkxlcIdhyRfbcwcMo3AedcjbVKuHAPv9y3pUxCPyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-31 18:02:38 [+0200], Vlastimil Babka (SUSE) wrote:
> This partially reverts commit 2a8bb29ec9b2 ("mm/slab: allow
> kfree_rcu_sheaf() on PREEMPT_RT"). It was based on an assumption that
> local_trylock() is safe on PREEMPT_RT from any context.
=E2=80=A6
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

> ---
> Incidentally I have posted a RFC [1] that leads to replacing that
> kfree_rcu() from set_cpus_allowed_force() but now after back from
> vacation I need to check the feedback and based on this bug report I can
> already see it makes the same bad assumption that trylock is fine.

free_to_pcs() has still this trylock.

What I am not so sure how good is that kfree_rcu_nolock() may allocate
memory for the sheaf if there is none around. It could have a pool of X
and if it runs out, it runs out and waits until the clean up process
feeds the used sheafs back. There is fallback and the run out is not the
usual case.

I do remember RCU tried the same thing but then it got to the case where
HEAD had to be supplied or it had to be preemptible so could wait for
grace period and free it. I just don't remember if it had a pool pages
to fill pointers to or allocated pages if it run out. And I am too lazy
to look atm.

Sebastian

