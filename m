Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23845CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C196B00EE; Tue, 16 Jun 2026 17:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBEF6B00F0; Tue, 16 Jun 2026 17:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD2F6B00F1; Tue, 16 Jun 2026 17:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFD4D6B00EE
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:16:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 802E01A015D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:36:46 +0000 (UTC)
X-FDA: 84886480812.07.57D2A5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BEF9E40007
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:36:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C90SZoFg;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781631404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=miWoZw44n/i8JPGdPHxVqhm2xC4JeWLsG92ImJPLJOI=;
	b=C8Az39UpOTZ/7X9g5jYFP8rzjcKP33ZQ3B2/XQhUdjN43gfvDveqedH9fQRYdHGqZm/Ead
	T0LGc4lmP4X+YFXdanJPd99vA7H7tkIMZ4o6Ai2kvALl9m+7mvR2GCdIj+8pbab9mWmXTQ
	fP8wKjCDtFohb5bX23QOFe1cLWU1dRc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C90SZoFg;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781631404;
	b=JQAE6N42dJJA4X5PrGR7baZRaEzLTgmmReWmhSaRJOBOzGdALXTQ+H0huwXf+3vRWDXhWM
	r4OszndqC87QIqWj0BdOSOEMVUJY8ZSvZkJ8F0Fv2hj4Knk0ppZ6kyc7r9wgMduMxf3/nm
	4PH+v33f30PDFSn0tVVqn677xZNrM5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3257C60103;
	Tue, 16 Jun 2026 17:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BF81F00A3A;
	Tue, 16 Jun 2026 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781631401;
	bh=miWoZw44n/i8JPGdPHxVqhm2xC4JeWLsG92ImJPLJOI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C90SZoFg4ac5+IOo7IeDW3b2pZsuaYxolz4o7a8725ULS2tGbQBi9DvtDeP8zKVGj
	 l8W7QnZvuVDtl/UjocYfHS5Ns09NH22YGhKDcl7RAlV4F2ADWvP7UObbO5L+0Jnkuj
	 TLb5IPfd962++y4B2ksGFXtQfuXp3Msh5mA5tX84YdaSHQ/G1ev2JODiwMpmVmnl6z
	 I6BvxNw2m63HOVQJzcRY7qkofbiv9KiuMPM6s/+nkHrMtn/gdauhzvUcy1FgaP7eV2
	 twnCczBqnu+6Raiu6oP3cNmjva7BiA8/6cE4NcutFUaEuj5tgNhN8BvVoA704OhiWq
	 pEr2x+df6w1vQ==
Message-ID: <bf349ff7-d749-4cc6-a6c1-56f5549b82b8@kernel.org>
Date: Tue, 16 Jun 2026 19:36:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 8/9] mm/slab: introduce struct kfree_rcu_head
 and use in kfree_rcu_nolock()
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
 <20260615-kfree_rcu_nolock-v3-8-70a54f3775bb@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260615-kfree_rcu_nolock-v3-8-70a54f3775bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BEF9E40007
X-Stat-Signature: wyecwn6igtqs78ujic6t6i9df6uyj8nx
X-Rspam-User: 
X-HE-Tag: 1781631404-871838
X-HE-Meta: U2FsdGVkX191ZwrfyzXz9dIrjxZQFSGbPXhyTHJsl8HQQNaJ8AdwErH+r/rOlbGAX2NuTU7isQRCwWmBfeDSkFOx4cg0/8AbW61tV8Rmb7Q1Q4QtcCZRHQTNWBGBI1EB3RmVu/0h6ghfYpHzVvGtQ/KnRBtcSd6awSjWubUWYm1qRixZKan94xfUTVW+85EYA9VgE7Z2OlYijqsz59FdJ9N8jQqKlbqr/yWv60DcJZsrhRjtAbKi0zTuFwUM7/regGVy5WuhzkSnoOFpG4iRXxqgpfWuwMtLh3AD+r+SimvcHUmi5/5dP58V0D+PAnPruafb0vlCj8lAQiR3mC80ez0DbhPu3Fit4lUOmzoDLpysOemO7NzwVd6RMwqMthhscSBW9DnggRgEiftRYVYamWHaKYfYrhpxfVZhtPp4+VGJyEHjcgSVqErDuSe+/FDurYeNM4vrE1q/euoNlh/DxSFN2Hlzgb+vI8EmqKo3lboh01STAJweMm+i1vD6jdfKVS9watS1lxc4Z4dWEjW4YqYtAfJiVesHwOXg4xjshIjC/G3rxgiRw1hzvcIzrFveOPwz34YQgXtSoYUWVMyLC0hykdhI4Q3fmp34QBhs8Brc5xSVEyWiT2IBlDYktv6PYZuuJGhg47DKc4KpScGRdgmu6JervBxomDoHm6rC30WCS4hqECOFb1Vp6DpkO/sQzaMCYrJ2rrK2Y0j1PZF9T3+GQXgKN/+2O5oTWn3FOsAGI7ToQJpUlYWrg1MPJl9uadgNXhNYIUM696u7/TSKEyzeqryZrRykrGj64LzLh0xtFh9ELNaspOVyMODoV12LxEIGXMq3bEp7N2bxodUSewpEmD1l9bX5r/VDvKA8dqdgAvcdY7Cs7hUmQbsOuDAAEFGZ5jVjqTcWt6obLq4DNuYTKHDP1CoGq6d4erxeWUoKJJpl3JoPjgo4MMkIrcNt5hEldp/4b/xfTwDAUsd
 U5msd2EC
 luIQ5A92SCyOk3SfrrfxXfPN9GMd23qQBNS2nw7uNjnHrdt9yX9tzHLSGepO/L1oXtSlzExVNIef3C9iE/95GkUFyyUsyn4b44IT70TEW5LraThxj5UmHAXePrb0KCHM//1RSunXhKlhl7FWT76NQXkEL4sgmCct6NUp0CFuvz7qsTzifNivWMw2WO1wHdre72gi8zGmjwd6hSC9WGM7LGTkKSuQX84iwApCakToI7QR4ItJNQlmQ1ZkG+ycCw/iXPj0w3GiRN8if/g4kAyHZbm2cFVRT4G5zRa7CYD48peYX06vFbsDHOpje5fURGJFrnC/6czy9ehEryAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 13:06, Harry Yoo (Oracle) wrote:
> struct rcu_head is overkill for kfree_rcu() because the callback
> function is always kfree() and thus there is no need for a function
> pointer.
> 
> It is enough to implement a linked list using a single pointer.
> Introduce a new struct called kfree_rcu_head (the name was suggested
> by Vlastimil Babka), which is similar to struct rcu_head but is only
> a single pointer. Use it only in kfree_rcu_nolock() for now.
> 
> It is intended that in most cases, kfree_rcu_nolock() goes through
> sheaves path and the field is not used at all. However, in the worst
> case where trylock fails or no empty sheaves are available, maintain
> a global list of objects that will later be freed after
> synchronize_rcu() in a workqueue. Since the fallback is intended to be
> the last resort, it focuses on minimizing complexity and memory usage.
> 
> To avoid crashing the kernel in a theoretical case where fallback path
> is taken before kmem_cache_init_late(), do not queue the work until
> the workqueue is actually allocated.
> 
> Factor out the logic that calculates object start address into
> object_start_address() from kvfree_rcu_cb() to avoid duplicating it.
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Looks reasonable, if it works fast enough in practice.
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


