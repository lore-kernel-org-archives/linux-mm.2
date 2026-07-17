Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD436C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED946B00A2; Fri, 17 Jul 2026 12:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4336B00B5; Fri, 17 Jul 2026 12:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A022E6B00B9; Fri, 17 Jul 2026 12:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 766BE6B00A2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:39:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05BE01A013C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:39:44 +0000 (UTC)
X-FDA: 84998829888.16.9966A25
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id D68A0180003
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:39:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oy4ZaEHP;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784306382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ya+InH9zHTxRKy9yFZiyuHezRl2aF6oKNFYbwfd+f4s=;
	b=zzHkz/Ph+gKhx8gCXi9YXGNp7cRBZA2Z2T65uPPCq1Wglt/9z+laQsOMFpOQ3uekfoY0qp
	GPLFpMiUeQrC+4sYNSBX48jBHm5Mo53vRd9c7Y8nuAYjDH7XSxVUQ7hvJhyhfV4kSDJa4S
	BWB6HZSli30rT+Ix9lVKtJCI1IFL9qk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Oy4ZaEHP;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784306382;
	b=mczWvlq4Ho9/b3V0Zrno5sR3oWPtYKLn/is4eMiZAOtFgZ6cIgwpfivIzo9uu6qyNN5Y1v
	/SA4e+tIiERvTeJOoJ9oHr9hlnYzQOwMljG/9TRpKSY8cCEXI4257FraSrLWTyZkbX4uDu
	E3TPkUgH6akRh/iBtfEx7LQLqE5qhhc=
Date: Fri, 17 Jul 2026 09:39:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784306380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ya+InH9zHTxRKy9yFZiyuHezRl2aF6oKNFYbwfd+f4s=;
	b=Oy4ZaEHPqZyanD21ryxsXbU1/13Hkpzada47xZFUyF5M++wS7YQHG20dAXxvgg+59vgijG
	s75SnEW/PCi9s2/YZmD7DnbaGDHIU5/B+3ZPGohP0ERT4QHsmZ+tWtAQ6gfqI1IcClF6T9
	JhBdBQVDKgCLWipu0EhrsYjQq8g4Jfo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zhongkun He <hezhongkun.hzk@bytedance.com>, 
	Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH 3/3] mm: vmscan: drop unused gfp_mask parameter from
 __node_reclaim()
Message-ID: <alpamr4VSiSQIczO@linux.dev>
References: <20260717113300.214717-1-ridong.chen@linux.dev>
 <20260717113300.214717-4-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717113300.214717-4-ridong.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D68A0180003
X-Stat-Signature: 3qot1bnkmcuxioxz3nmsom8u7x5u3otj
X-HE-Tag: 1784306381-60362
X-HE-Meta: U2FsdGVkX1/xE7VXkyCHegJmlg7YcwjVGX8Y/KGj27SVr9YLrK5cxuNYLiQxfY/6JVFp7Zen9+9bkAGXxPT/Huuiw3+ZLmXqfwi9GOG+D1y/O1xBVrmzmlOxWIhb2jBHOFor8+1Xa3ncd8b1/rR4CaKf8TK6VG3KccDZjRHtoblRur4Q5xUV4gQa4Kzu5MqDb0p5JajoF8QAJdsjpDOcReysFDBsYvHy5hkzcIafiVdnWj3SBTShXuMFK+1cRDcR7WlFw+2gk7RWJ65gJBZSuwNRpOXq9tP+7wUoL8uyIzHu7Pjik/SGqVWPxuo5A+il5bxPcGPBA5khl08/fbNKRiN0YryUoJPl0OZsCkaqBeeIVPP2jbw1+O7gKCl6HDWJydk76ZCm1nNVriNuRD73aMsdL7KyWzAaUYSMyYB4CkynN/CHisyqgMtP0xH8pf5NGs0QoXgIRgK55QgPDRImmlfxYyf6jBl8FJbqYPmnMY2c5dGjugmDxwImRcIClVfATZbAfUpbD8Dp/EzfQ17ruZ4Litdm0n6qFJ4yU1J1qR52nRnvovj0csS+7jjco2uERXA8gkQXp59RQUQTEeSQPdMqDr4lVeeSPJmpsY4PT3kTXKSH7BIcxF/mKrvbdUfDMBmsSUVjNUErEh3E1lrZ0YWxTM9YYcxKLA6+m1wm/rKsd0QN0R0dJFeUjAHoOBfC3gUXGwlAeIvxgjyA78dPqpaoEOJiBHEwj+VoNP/Sm+965SqI7R7arRi6SNUfCOvgvrFt/UpfbZ8Uvg0J+nTODYgNBluyEAB2VQNlNMaaT5jq85AUP+ZCwdCFuqMjIIcJ3GvB6/4yBOBFdMbZIgUzRwHQQHc+8Nh1hsMXw7IJM5Q0csGpFjMel8bEvg+gwuFrkscqMAq2ArmcpKMDGp9jeLKv6w5r5RCpIq2k46P8RNZnijr06Lx9dqkKC77l8vEBvvq03IJxKkprk2H1j+5
 Sxu/FpJ1
 497j/DqSgGvqcYFsIxtFJt/aK9mC2QolTEQHpQB3eLLdvMdWpA0Hchs4/UYPb709Dx8OqTOcp0O7aVZJ5VqxfQK/DzHb/rwV6gdi87252DRhlVn4NJKCBzxqg01mxpvteMkmEN6YUw9sGgviQ78Qfn8xKgHssvUMFmDM3CsY27uOj9LGgUtq2InmyLBuZ1tKbbCsFKtKdQiwOSoN6e1gm6jpbv+etrViWLRtN06eRSUBPxj1CAjHCufNTDQM7kMSFgKFEc7UuOGkZdGfgJH7onA9sqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:33:00PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Commit 57972c78e678 ("mm/vmscan: make __node_reclaim() more generic")
> moved the scan_control construction out to the callers and passed the
> struct in by pointer.  After that change every use of the gfp mask inside
> __node_reclaim() goes through sc->gfp_mask, leaving the gfp_mask parameter
> unused. Just remove the dead parameter and update the callers accordingly.
> No functional change.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

