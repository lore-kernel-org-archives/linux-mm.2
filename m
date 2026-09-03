Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D57C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 23:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE486B0088; Thu,  3 Sep 2026 19:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA49E6B008A; Thu,  3 Sep 2026 19:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E536B008C; Thu,  3 Sep 2026 19:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8CA6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:53:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13AE71A0655
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:53:33 +0000 (UTC)
X-FDA: 85174105506.04.A8461AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4D006100009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:53:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uk+m9wlV;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788479611;
	b=zm4jp3ZPUPfsmRlLu7abglxWBYdDCpe8Jnahbf4E4bZ5wHDISZKljt63GBkAHSV3EZxEsA
	BFY1mxcBuvK1qD4hqn/uZKBJcW/UHsFQNv7b5CInI/0dqvsBuB1GmnsTR2qGPYEZBk+k6L
	QckahHhKxA4jMHc88FsJ8Bhl9tIg/cw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uk+m9wlV;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788479611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UF7yqAp8ad+9sMAMDxO8x1qaT7SamIPUcIuJfPgR/wE=;
	b=r0PWHIvvKBsWUB8Q3vn65/LBAFTbLQeReHtfIR1k8+mkjyCzH/JpXQXdRuYlBTtUMi3qJS
	j1FSXamsdVAMGfGjKklV0XF994S7bueVKyaRz7Lpj4ehgkeFQa06YIExpQpvWBKBAIvn91
	Ua6HChHdh4GpkUxBnSHV1G5rJgUr/jc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E37CB60546;
	Thu,  3 Sep 2026 23:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770721F000E9;
	Thu,  3 Sep 2026 23:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788479609;
	bh=UF7yqAp8ad+9sMAMDxO8x1qaT7SamIPUcIuJfPgR/wE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Uk+m9wlVUndtTSDqMjlQ18780tb8+rvugNYeEio+29CXjGT3nCz5uJkUU4dmL/8N2
	 KLPVjhXRir+7Ku8w5RHFhLFfU308IBkFDEm1noTc2OaDDHiZKDYmuyCmKShEMvUmme
	 RXswuNalV7Mu1dLlbMS3bVXItpa0zTpfSefpfZqc=
Date: Thu, 3 Sep 2026 16:53:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adam Harshbarger <handyhandyman.adam@gmail.com>
Cc: I Hsin Cheng <richard120310@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] lib/plist: fix plist_requeue() corrupting order in the
 last bucket
Message-Id: <20260903165328.2e781581d28ce1f4dbbc0da7@linux-foundation.org>
In-Reply-To: <20260903222456.1881786-1-handyhandyman.adam@gmail.com>
References: <20260903222456.1881786-1-handyhandyman.adam@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D006100009
X-Stat-Signature: q7jwq4yuegn86agem8rhos39yus4bf9i
X-HE-Tag: 1788479611-816191
X-HE-Meta: U2FsdGVkX196i7CXyQN+tGZGHBV/MteZtzdlNjS+SytvQIL71paI4jinuBc7wBt5mon0jTFLM29bFidV/07TOv8fALuaERcjcXdkwlwgeXBKXg+2X6XXOrmR1OAHqLnJ0Yp836kDzSanNBvgkJXqzFQlKs3udEfHDHTdYjtPt0hYG/wf8GBcUzPQIPFbs5NHF68pCrngME1UYeaib8bmfbeksdkyLUMRCBYl380RU1uKPPH9vsMV7PSOuMZAMJ7wSAb/iyb1olwqNlwlNcnWrbx8vPXdB4W9RE/jaAoJlOeMi32dYQJep4jUdHllM3PerKC/kLPMOwq5t75ETlmSk6sk/jliA0XCUXTTB6+dxcSDWvITFzPHpqZuPDVQIkFyDdqHF5YD1lMCD1y0sbNRR6HLKDlyWCL4R28sCpmIkwjf9SYbxk5zXI1aetX5OsLRVeP9EcPENYazv2wc9rIsYZXnxFlTlbdCF3fnxHIbl4OBxEvrY+FwMH+ze9Uc7QSBUrCDftXp2oL8zD7eJlrzFZqelRXKRG1duM+Iz4UkSYeW8AaftzLFe1/yurkmitIMpf+rchW1IEK4okJ4kMgkbDpOubueSM0f7mPYV+1e55ElR0CSGYWODbXv3KSnk525mzHJtdIXsNp3VtKSf/qFKlzysHU8OwZD332u1KftJt1V3Mh+z93j2+/tvG0guXJrYPATVuJa3IKTeHzce3OEfNluIktGfC2V7fpaQP8ekjkfIVnf3yzSXC6/YE9FT8WU0NaibCGwvF4RWtWH6nd+ZR2tPzVbuFf+X3mnoSASt7llrEgZ9AFwKhP1kjUhNFTdoCqbf6pct1Ek/t4DYooK78wocMEhVwyQQexgBcKwXeJ6wk0QVmEPWeh5XbD+1GSXB1yL1LT+veEk5zyaDe6kmxfdtyoUAnok/liWqmIeX5elfbwFDb+O6MJDbvgTVTxqqLdSujgI6AG6R8cHZZh
 /ZyC5c7W
 wEGlmuQeNouhrV6ckZMVUsa2ZkIkncCzBz77gxedqKufU0b/rzz5MwwTJvyZeFjiAiaWx+aInnLKCN4oSPEAFRDKyANzBvQsS4M1kZGymgwEtVuKh6ZOfDAs3N2q+FArvGfN/1TVTrTeK8OXenl7ma2gTWC+3h82cQds1JqLbhZTdWJr45x/RPvxdmGdVnLBw7r8UkstrrKFBJYkS4d9PaQ2D3erFI24pd3wej/gvr/4vFq65Cv0BSqIlUIMf9Jqp1xfeM3iNJ5kcYssfwxVEhY2pzca/3C9+pn+mRUF5UMj5eAEiPkMLa2uG18ho91oYjVngKEHfo7jylYOrItRuPHkkRmJQAVN+RtiJwK/1/sYj2BGT1KRwm5zl9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 17:24:56 -0500 Adam Harshbarger <handyhandyman.adam@gmail.com> wrote:

> plist_requeue() is meant to move a node to the end of its own priority
> run.  When the node heads the *last* priority bucket it is instead placed
> at the head of the whole list, leaving the plist unsorted:
> 
> ...
>
> Reachable from mm/swapfile.c, which rotates swap_avail_heads[] with
> plist_requeue().  It takes three or more swap devices: at least two
> distinct priorities, so that a later bucket exists for the ring to wrap
> round from, and two or more devices sharing the lowest priority, so that
> plist_requeue() does not return early.  One device per priority returns
> early at the node->prio != iter->prio test.  A single priority is also
> safe, but for a different reason worth stating: with one bucket no node
> is ever linked onto prio_list at all -- plist_add() skips it for the
> first node and for every node whose predecessor shares its priority --
> so list_empty(&iter->prio_list) holds and the shortcut is never entered.
> 
> ...
>

Thanks.

> Fixes: 95d4b3450ebe ("lib/plist.c: add shortcut for plist_requeue()")
> Cc: stable@vger.kernel.org # v6.15+

Why the cc:stable?  A description of the userspace impact would help
people understand the need for backporting.  Please always include
such a description when fixing things.


