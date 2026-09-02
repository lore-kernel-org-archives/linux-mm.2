Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5373C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0866B00BD; Wed,  2 Sep 2026 10:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0992E6B00BE; Wed,  2 Sep 2026 10:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE846B00C0; Wed,  2 Sep 2026 10:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD24C6B00BD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:13:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A388120214
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:13:38 +0000 (UTC)
X-FDA: 85169015316.10.C093E5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A83BAC0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:13:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZnwviuK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLEoYxETqRPjTXxDSlNfnFbEqTN4nnEwi7Vb6jwx3Qk=;
	b=FsgM48/0gEFEwK0xK6dYFmO4z1aBG9tZGhrhBDOwtNxrVcqzxTwN3sPoz8MZfHL+7LVT3y
	quh+opQiAVA4PlF0h/c65dwCOvXkqhZ5WBGpAPUT92OBdr0DZr2CHxAsl/0sQ5hudWLWjl
	VHrR0otKByjblTKonqMj5MJVB1yKx4Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZnwviuK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788358416;
	b=orcZMYzjPdblgHG8U5zkk8eLBMZXDf8nZrjm0nkOzJY6ZD+cR/ooYDJXmi8LSBAn/hY7WE
	ibWMFAIdwRlq25ErjtW1f+xZ+8bgGkvfdAqoTWp6KxDvyOzC3wwjemueuyswqSoikebS80
	xnVkH0Wbx2/PYyOhN4XwBW3vkd8wLKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DE20600D9;
	Wed,  2 Sep 2026 14:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9971E1F00A3D;
	Wed,  2 Sep 2026 14:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788358415;
	bh=NLEoYxETqRPjTXxDSlNfnFbEqTN4nnEwi7Vb6jwx3Qk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QZnwviuKDFKR+6/XzTVwVwWCb9WHHT2ShCVLa52wUcK/DbFoGo9q/O7t7HnF63hAx
	 YuF8M6NhIZmrKZUpeVjBCC42nT54TDSsMXnu3hIutrod+l7hyZfmAdDksuqDnmMXK7
	 UAj2NMR6ZItAWeoByNYlLPEhmPl2yRqvPfRlZMh+EzZGVgs/U4a4mHmxgjURLtj/p+
	 6TaqTzY889EBzEEXfIQFzF2hp5ekOEXuIMa+EuLSWN+eISSzpY+qoR6NJzl19tIOWR
	 2nWHUJbDEMUb8lrUf8/AFQvsSF5faG78/4PJH0L8E71az8tQ2eXJGkjw+x3NX06NR4
	 inVsrFobqC4zg==
Message-ID: <1846af86-cf55-456d-9eca-975a88777a40@kernel.org>
Date: Wed, 2 Sep 2026 16:13:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
Content-Language: en-US
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Harry Yoo <harry@kernel.org>, Clark Williams <clrkwllms@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 syzbot+acf142088e0182172e58@syzkaller.appspotmail.com,
 ThangNN99 <ngocthang2710.1999@gmail.com>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
 <20260901073339.uyKHXWCX@linutronix.de>
 <47aa459f-27d5-4b2f-9eb9-36ebca63d890@kernel.org>
 <20260902104143.j8BXrjKq@linutronix.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260902104143.j8BXrjKq@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xdid6cb1rxbunjprwz33cdwxrfgj7fc1
X-Rspamd-Queue-Id: A83BAC0004
X-HE-Tag: 1788358416-116581
X-HE-Meta: U2FsdGVkX18Zm+Ax0wzEyPPcojgkeDIUWnjPCwwB4WrMcQ/wXpTbYsZdwg9W4AfdUQycZZanEDsSHYxi5Ciu33l8eCnZK6b4SG5IXu/xOyUKnbvCzH7JDq3YgjYrJnDxkg7uYuk6JJvCo3fBRqEbVmhSxXvRWGkq3p2PKFfM5hWwocd7anafhssgl9/DqQNdrbJUL152Q6/UWL5Hmo0pwHDU0JH5U0d4S5E1/HkvH4v7b5F5W0oGcznTrBte4NGGj1ZoNDQtg6neazlH3MoQK8bF0qufmH/6DArlLeJGopupJ06gk1zokpUwg+zJEKOExWKJAeYf4Qxrr9jS2WAVd8rvNpyrm5oM2eTh752SteHHOoErmHlMcBknLAZtC8UsXI+OJnZczHkBvcB1viVy2bmc3b4Gpl+iZVMmjU1YLTlCI2boIliB1njettUFPzlgkHn1vpgVn0XRFaxmXwW+b7uksGJVH18y3+r+9amAwvFuYSmm0q+rchzqs+DWQSxYpzxaXiSMyGrcEtJRtZ4NqAkf0Iq+iHzmVejmh5yffsGSJAWwaKK5DHAfS/TN0aFSBnKWi6GU9qLOYHLeY+nNW8LjPxXgOor/MaQlRG7EAChvZSFtvS45aJktdsAy2F0YwVMh9S8MVLTTRhToJwLSyuwgy7cRd37GD4CAJfVFGBS+l/045jcJSklmm4Fq4ipzUChqaY1jMlmiFH/z6i+Hbjwtl5PTA7aPEn2GzHbTxPVtHmz0RrekiaiZHrJr5MsBz7qi99Ly0O07zg31wCnyWrWNyzglG6pcq30EEufk6+xXWeMW/CEjsIqeCfexVIRm1ihxtxpc5QHl6WOK53WgapHmog2ptnAYSl87s/RMT5PkeYLMXemgaUZpcdPD9BHb7yFR/l5pyq/02wZw8MPxiP6hHWwSxXGPjKOSmR74cNQKD1oBiPWY6niiw1rMYtyod1KmnDROyjNh+Y7khhF
 fz4KI5XJ
 hy8HIWYMDw6UbZX+bjwQIOeLHezLX2U14Fvb7dS2BACH/QH16M0PdiUxfbdvx50IhIFcGXO57X4shWdZRUyGLlVz6TS4EROo1jo7r6YzW4a3E3sMZFvCrb10q6pNc3qdqf1a6DbmwRcSYYvADy4RPGv1nwJEVZ3zuPiCWdszrhFyM5HNBKzg0QATbax3HD5M/34L1UOGf2xVurxe7dcurNJ2e6G3KDbjckRiVPbBalUjB59KsMkbzkoOGPNO+9QNBsqokUf89vJbydsGrnFzYYG8nQDYpsREVLB/sDGocYcx/yEq0MJWLC5KGfndATOZzWjgElI6t5tPWgv5r2Vb9cTaITdP+ZplLQmKHgQiV85DrJbOBuI3F9crIPl8RhZEhPF1LcDbbikbG1Jio7W8PRKRTO4f5ZTP+gm5quUOgs35lAhdZU0Z9LMBCf2DRp+7A9Z+vVzVKccorLjjdLzKDi8FfgbGBYFwI4R5i6L0xQU4Ie6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 12:41, Sebastian Andrzej Siewior wrote:
> On 2026-09-01 15:59:09 [+0200], Vlastimil Babka (SUSE) wrote:
>> On 9/1/26 09:33, Sebastian Andrzej Siewior wrote:
>> > On 2026-08-31 18:02:38 [+0200], Vlastimil Babka (SUSE) wrote:
>> >> This partially reverts commit 2a8bb29ec9b2 ("mm/slab: allow
>> >> kfree_rcu_sheaf() on PREEMPT_RT"). It was based on an assumption that
>> >> local_trylock() is safe on PREEMPT_RT from any context.
>> > …
>> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> > Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> > 
>> >> ---
>> >> Incidentally I have posted a RFC [1] that leads to replacing that
>> >> kfree_rcu() from set_cpus_allowed_force() but now after back from
>> >> vacation I need to check the feedback and based on this bug report I can
>> >> already see it makes the same bad assumption that trylock is fine.
>> > 
>> > free_to_pcs() has still this trylock.
>> > 
>> > What I am not so sure how good is that kfree_rcu_nolock() may allocate
>> > memory for the sheaf if there is none around.
>> 
>> Per sashiko review it's actually bad too under the pi_lock, because
>> GFP_NOWAIT means __GFP_KSWAPD_RECLAIM which can mean wakeup_kswapd() and
>> thus also need scheduler locks. And it's not a PREEMPT_RT-only issue...
> 
> \o/

More like /o\

>> > It could have a pool of X
>> > and if it runs out, it runs out and waits until the clean up process
>> > feeds the used sheafs back. There is fallback and the run out is not the
>> > usual case.
>> 
>> I'd rather not invent new pools, since there's fallback and the sheaf+barn
>> is already a pool. Could be enough to make sure the allocation attempt is
>> safe, i.e. use only __GFP_NOWARN.
> 
> So we avoid the allocation and just add it to the sheaf+barn and this is
> it?

We don't need to avoid the allocation attempt if it's done in a safe way?
Note the new sheaf can be also served from its kmalloc slab almost
immediately, going all the way to page allocator should be very rare.
But if we stopped doing that sheaf allocation attemps completely, we could
easily end up having long bursts of all kfree_rcu() being deferred.

> Sebastian


