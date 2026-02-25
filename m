Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE399FD45EB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07BDB6B008A; Wed, 25 Feb 2026 15:12:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FF76B008C; Wed, 25 Feb 2026 15:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E856B0092; Wed, 25 Feb 2026 15:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D50B76B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:12:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 717D7BA815
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:12:56 +0000 (UTC)
X-FDA: 84484077552.23.1312E13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE0C91C0006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:12:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vZXOPZ1F;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772050374; a=rsa-sha256;
	cv=none;
	b=7Q1hBJ3rNVXq9dcRUdhUSw8hlap+22s0Kzg1l4A+8RrY+wDgh+SagHbbIgTOzD8fd/RLKy
	fmFjWm0aEFm9yirUbs4xZitVL8iL+fUyoIktAqAi4lTm20yS7Fi76sXHd3mxssen4YNZMG
	xB19NJIuFeaLlf35L1EuVJwdq4oz3Dg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vZXOPZ1F;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772050374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFcNUDMA0fpfKTsH+tpEq3bJZDfRy3nnHNOQvpT4r0I=;
	b=IFgIlJ7L3EG7R692Pn2bpTS8+xNAZg2gauXjzoGE0fibdXBLqmfyaZ/vQoaNlSRBEcxvnQ
	wP54Iig8VODH0cC9khPUnpmZ3QMc7Y+oSu8A8xHMgl4ofeplOpTuuptw9GMZir48+HoOco
	lFZdsf51Z1UDL5ZBdbLb+kA5SlvdQ6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25B6060053;
	Wed, 25 Feb 2026 20:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BCEC116D0;
	Wed, 25 Feb 2026 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772050373;
	bh=hvDyKIkKV0xKNXKf+f4mVxzCGIFYEMzA/sqURO92W30=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vZXOPZ1F0hslCdpR1V7LhWv/gVAq66hcZRmtOh8L0xMZCTpYuZhP96kGtG+PXIthU
	 ZM6TOaD8CYQ8v8jrmSN2C10ygQ+Vc29+ZUVwzbn3eeprcJHSdh0uzI/RtkPKH6erMZ
	 xv09WEpiHYPEtpqqi/5rOnyYmVcb7IHVcxQrnKTc=
Date: Wed, 25 Feb 2026 12:12:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Steven
 Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v2 3/4] mm: convert compaction to zone lock wrappers
Message-Id: <20260225121252.7c6519a857c1a8c56ba5206f@linux-foundation.org>
In-Reply-To: <9710c3448c6c984164c93d7c6c0283e06ff987bf.1772030186.git.d@ilvokhin.com>
References: <cover.1772030186.git.d@ilvokhin.com>
	<9710c3448c6c984164c93d7c6c0283e06ff987bf.1772030186.git.d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE0C91C0006
X-Stat-Signature: wa1oxhur9roh8mih8qctqcffjx4zdkht
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772050374-723883
X-HE-Meta: U2FsdGVkX19MAspfx1Y3qB+a6fzJVh6zVqFI/opy0dQGENksPRLRfUEmVzgXrGGdBG/O736zvHMHO8vr+W0yIiYeaZWObEv+qxu1ijJmOsIybmGbUwKYv5N8qp1sijQOBUORrJMvnuGHM3IkVC5cavzaXjWdOYSwg5tKffaWwoW+3RPeTvb7IXmjwp5LJ5Cmk0Hkkz/PfdUZLMduW7bUSrRV6TWEziydPIEVJ3eLxF9b/Y3nzE61IbSlVs2GMAeE36+QpS5+D0bZSCDH4lrV95owe0kQQAf1koI+qQKZkQY/ElpVBYR1U0fzm5TViC9I2roE+LfTTNCvoISgZ2Px9dYO4twA+dibKMkLM5P0m5WofzukfP4jGXm0ULbeyl7LySZyd8c53b3ETtk0iaZ+6wgVZEbMvM8rUY1OE0ZzPFwhV56cZeOPkbVa3WHjdJTjpS0Wr7PNqHlXW/3SeNAJOS6Sz2SdlOOyw8WLmI4vJ9tD0nxVTlbUdRZdcSjPPmGDB2LL445I7VAhXpy8zox1QRCYbi9EOVCvDUu9MzEVB4/EyUlyejpWFHTuU0s/0G1A5TeBtqjcDc75cHLpgBfDmroI4uKCwzt350S/dZy5RvSDaZQ49hoAymAByhdIWiW3qYCXba31+gyzl6z3BQJIYqfWycY0S6nCMkNXjM9PjkiJAZB+zXxClKORcfwaWwPL48r8CKpk16rAsmtTRjhUIONSqHTqaZcCcOfUKxE00oJz7RVyuYxZUItLfYP2m9gQ3JYlz7wI5HU/PBCFk74d3b7fVK/kprwUqcdtEcjkmlVCZ64R8JjD4SeaTJ1DoPlJX2n+pt+6M7l52xGDXB4Iq/Mra8nDVkTKIWhHyCOygQPEIRTXIip9CYVk1Vn1ALqkwLPvJWl8suo6bwxBSlmA1i24hlDR/AfClyCWt1Y4tb+SuRCUoVYi1XjTe2kt9MVwXorgoCNr84CjHm8TTC+
 f9+arvAU
 f5uXzjPXtm4XVC10e7h9yn968Jfc9R9pmhVSpHIw0ZKwWyCQg6Fi/V97LOLQ9WuLqbhmhjHZig3lo2DDSvXZWYRFsn0zgaShaBSe6rC+XAAXvIypf1YK5Sa/klJ08b1iGEAHvku/NQa9XL/m6y8y/xwk4MqLIwxR6PwzzDyHJ7NEAa8NM6J78bPdOlISKUa400lH+jaULfVH7fR55k6PTFkZ4gbpfaBzMJrhHXfwBwFsfYV7b9GiBdp4PjjEZtcbxyWxcpHxl7osMldEQ2Do8kdQbkMcsZk7d1297HxUqzwomE9eohk2PxKVnnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 14:43:05 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Compaction uses compact_lock_irqsave(), which currently operates
> on a raw spinlock_t pointer so that it can be used for both
> zone->lock and lru_lock. Since zone lock operations are now wrapped,
> compact_lock_irqsave() can no longer operate directly on a spinlock_t
> when the lock belongs to a zone.
> 
> Introduce struct compact_lock to abstract the underlying lock type. The
> structure carries a lock type enum and a union holding either a zone
> pointer or a raw spinlock_t pointer, and dispatches to the appropriate
> lock/unlock helper.

It's regrettable that adds overhead - increased .text, increased
instructions.

Thing is, compact_lock_irqsave() has only two callsites.  One knows
that it's dealing with the zone lock, the other knows that it's dealing
with the lruvec lock.

Would it not be simpler and more efficient to copy/paste/edit two
versions of compact_lock_irqsave()?  A compact_zone_lock_irqsave() and a
compact_lruvec_lock_irqsave()?


