Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5E6C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694216B00AD; Wed,  2 Sep 2026 12:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BBE6B00AF; Wed,  2 Sep 2026 12:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581E66B00B0; Wed,  2 Sep 2026 12:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6FB6B00AD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:21:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D00571202AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:21:58 +0000 (UTC)
X-FDA: 85169338716.02.286DE76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 30E79C0008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:21:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=etonnWNr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788366117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6GINoLwkUA3hhnBwenhiVH2MG/E/BgWH1U3tO3YoWI=;
	b=Le7ixC8n3VvVDkXQ4zKjzjFC+9uuoUzSZ1EiABrqR9/4wBh5xJIAzGKI7yrlgpgYoJxti5
	iifFlsgmu7UNZsd3JvnDm/L/awjAVEL7jT+AevQwSostZY5rzn/zMhgG4lpx5zGsH/BAww
	q2zRLSgzmXV74oRZrnRh4eAjb+Xn3l0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=etonnWNr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788366117;
	b=TCqo7UNNVfLfpKeJsAt6HoLF1vm0AiD5cI0KAQpyU1v3wmAa0U67f5nEfOTVMWBeRb/y+n
	ocEYK0ig8nv6cYuAwjJ1lWN8P1hGfeQLOCp6WscCPBpYbbtBxYMdJbsRmoYMgHuWy/2s/W
	pJOp4jZwGvWE/RBiHvg7haJZlwxXi2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B66B600D0;
	Wed,  2 Sep 2026 16:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D281F000E9;
	Wed,  2 Sep 2026 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788366116;
	bh=R6GINoLwkUA3hhnBwenhiVH2MG/E/BgWH1U3tO3YoWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=etonnWNrXoT73baz3xJtEhRpNWkjVDs2f5l711wzJlSi2+mJFHLC74fsobQFx/gdL
	 DKN/pu+iXg2MuJxCGaKiT3VVrOIlPbIqnRB/d6bIMZr+A7/iXoEhdVldUQ8v3J1lAt
	 mp4QGN9mzmGajX3Nvi3yu2h20lnjJpMuBOhXKQhyp18GbkTf/is9Q/5QP+tU/Q7ETd
	 MUkamoN2reB0VRMt+53H6OWapmNio02uzoluNZN8ie+pcu7Zaqjtnh3tzUFlSXc7Xw
	 QZ+Bu0jZ3jHHt8IERYRTC7K94xQ/w9P6ZakjlcZHCsPcTytYxaDoBcJx7HZOvUQ54T
	 LNpTnfRFsRaQg==
Date: Wed, 2 Sep 2026 17:21:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Andi Kleen <ak@kernel.org>, 
	akpm@linux-foundation.org, liam@infradead.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <aphJ7olxr-_VhDKt@gremlin>
References: <20260831143511.1133029-1-ak@kernel.org>
 <apWUsc-a6k1YkuMv@pedro-suse>
 <apXXgimKxgJl57qo@firstfloor.org>
 <apXaTN6o5YaEO8FR@lucifer>
 <apc-F_D5mWwWL74i@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apc-F_D5mWwWL74i@firstfloor.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 55zpww6w3yitckpcwk341iaiatnrmgj9
X-Rspamd-Queue-Id: 30E79C0008
X-HE-Tag: 1788366117-946114
X-HE-Meta: U2FsdGVkX18mOVHwbH4VHWR1UiNVjRq6QnilvXBJ8AxgTdlnfDkCZv4T9FzKsvDmTI+JgB7s7kUrvxvtIzX2NAFcaq+VG0xSiEpaKRor/286DFxU7wsWhrfpHLvg7qwsm1q5B/rFvs5H/vs9NjWm+EJww+Vq770EX8tKKxah0JGqyWehGJ+utVQdQm06XhJUSMk9bqDZiomnvodquJjbCbjFJdAUQ3kV6lsd7Tf/HFtVLkRCjgHgMFinovd40v6CDtv3UyZs1p3odn6YPvkrRF5jJ3qpmTfkzBc/JTzmmh8oAEThCx4Xscs826RoG7HxXP5Hw6ZIuT08tBPJ3lzEfFg4THmqjLBCFyxBADRYIeI803gdJLzY9ecdVWoIBDAb+0aLAnvzuaCN3X7pkc5Rk6Wy2EjSsJ/lkDrvuTF58LJrVlTzuubarFbAcLTSkFhixW6td9/Zy7vxTC+BXv2Z10Y8OKdXWIvUkiEz5BP2dqRx4S1raa2hzH3Kgbots7HwkMKLGbbZ33cO/FOev2xq2b5Q5BGXF2nGgx645j3ZWXAV6t+X3YwWAxgjylDjNAuMvdCgHPGWIONcgUo4nk75jwDDxTps0HS8EfMvcB1ncpVUqwCoCTh6IpRGgGnwC/ynU5xDYhkgC2A2lFn3l7YayZ24PkvPvPDYEF9JTUIXMdi6UBHUUzcCKXNrQWAd4X13L8bZ+nC/C58o+p1XwNxxPbrKO8XEArM7Eg9SlrDpzO2oLd6URgZx65tKvgzEAg5qWUmTdiUGDh7Pj4xseupRf+cxWvFITufBwo7fjeRTHIpjjg21uCL/3hbaCj5/daol6kLH4CB4kpw96gc6Olnp0iuaLwchTbQvRKNIYDDQ7V/5syj1O5K6gA+8yweVy1IB7QejRhjaOfhPxpeV3SLYNqCkj57dt52H6vXu5qOyJk2fFhdOyz3epak5Ax81zMkMNf4upZoY1JElelmQZmg
 sUDW/VLt
 2tqe41c7n2uAwbUAmgoD3djoJUXqkhqJFcUr+mmw/TFuwlTLXi+leKTgieaKbzIdnyGa89r+O3tpo6G2IMB7dbjDq9cqamUILrpmB2bfbEoy6hk0iBbMkA3v8IIuh6Mdqcx2ZrQzuwdo9SnEGYXYjGS0gUYXX1Ke53KcR03SqMd4M+ewTBX8r752mzNU6oKEK/8uleDOJREiu57YQQJMKjPTmC0eqdQzMPpkE7/wN45i2iFvpLV8qSrTM2QM98gDyMQgV1d0E2UsE8vZPoiwF1HOn8TIyh7jN5WJTpuCIp46ihHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andi,

Looking at https://lore.kernel.org/lkml/20260831150651.1134594-6-ak@kernel.org/
I can see the cause of your issue - it's your own patch, exactly as we've been
telling you.

You're inserting a VMA on a uprobe_mmap() call, which is completely incorrect:

<munmap()>
  -> vma_complete()
    -> uprobe_mmap(vp->insert)
      -> install_breakpoint()
        -> ...
	  -> create_uprobe_ptwrite_page()
	    -> _install_special_mapping()

Now you're inserting a VMA, using an entirely distinct iterator, while an
existing VMA iterator is in use.

That means you can end up rebalancing the tree and _trashing the iterator_ in
the core mm code.

Your (LLM's) proposed solution to this was to keep on doing the completely
broken thing, but by inserting various RCU locks, preventing a KASAN report on
use-after-free's due to avoiding an RCU grace period expiring.

You can't reproduce this upstream, because the bug is in your (RFC) series.

So, exactly as we've been trying to tell you.

> Assisted-by: omp:gpt-5.6-luna

I'm a little grumpy about this as you've taken up a bunch of our time to assess
two sets of completely broken LLM-generated code, and you've mostly responded by
denying what the authors of this code have repeatedly told you.

You also seem to be using one of the lightest weight LLM models - it isn't a
great choice for core kernel work, especially in areas you are unfamiliar with.

In future, please audit the code and make sure you understand every part of it
as per https://docs.kernel.org/process/generated-content.html

	As with the output of any tooling, the result may be incorrect or
	inappropriate. You are expected to understand and to be able to defend
	everything you submit. If you are unable to do so, then do not submit
	the resulting changes.

Please respect our time moving forwards, thanks.

--
Cheers, Lorenzo

