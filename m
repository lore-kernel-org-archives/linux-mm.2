Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5BE6C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5276B00E9; Mon, 29 Jun 2026 15:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76BA6B00EB; Mon, 29 Jun 2026 15:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DC46B00EC; Mon, 29 Jun 2026 15:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 844836B00E9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:10:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8175120261
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:10:31 +0000 (UTC)
X-FDA: 84933891462.09.026A09F
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id E67D640003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:10:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A1L4E13A;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782760229;
	b=3tMTgN7VuPGIjJZwZzFC8KRT1e5bff+q8jdqAgd5uKzccbpNcIG3rHv4wNDdx6+FFVY6rn
	xDPmeF7UbBnp7T9ql7xa8Q91bz6mR9UpNWdNWdcbPDxyXprrtdkSlsYsurJrsnAGSSj8y8
	voUCVVwXPNFNOynFzyI7IXbNnEPAO6U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782760229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqlqX82xmlKGNezyrTYUwMGt6l+Ufnqh/0K5ySWqGfo=;
	b=z0l8m8px7kp6fRGrEDpJlyxQgdydcT5X2cgLheN/77UadJe9Dm6nYTd/MBvcEyplDQTRra
	Hx9U+KPsKVrXRtWhL3QDzwRsz7AKTB+Y6UxVopGQKjxO38TfdIh1Smz3r2XlDisoIOkfw8
	LN1cNP8PAZYVPC6AMrHMcq009Kz3UYA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A1L4E13A;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e9b895ee02so1980186a34.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782760229; x=1783365029; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YqlqX82xmlKGNezyrTYUwMGt6l+Ufnqh/0K5ySWqGfo=;
        b=A1L4E13Aklra/5IU2lgHqfhMzEfjIfa8WxLI166gon1q8NV6W1V/l7vebW/A1BZp0i
         g8bMh8z8/2aYKQYGvECW9zZbaaEp65Rb2nmF4PBcB73kJbYn7JZ63J5bX9UFaNQ0kdBs
         4VSvsYYlbq54rPnup+7NcJ5sLruQtrUhtSFNknujuHrJcmmrdPQRhXstvXLkd2nLy6Lr
         W4i+jEawKo6suqU1DXEkfx6l6TUX9rz4KwTP/dpqAVNyGHzDyxpBINFoEF276yLjRKrI
         CQp9M7b0BCICPaq57/xtrbZQPCzHcWvMYPziw1fVRkiVo1HE+d/tnqWcJ/HdNcbLO9Gg
         cOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782760229; x=1783365029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YqlqX82xmlKGNezyrTYUwMGt6l+Ufnqh/0K5ySWqGfo=;
        b=sUWs2YbiJiRxm3F0g8f2LB7gb64izwJiytodDovq8GF22LwGLVpgwEqVwc+evo1dKf
         cBlk89Zm+DQvGIFx+mjI1jZSHcPg/EfhHjkA7PiIivgyuwG24ORtvuZulE9F9/VUxINd
         A1QvWJUmemNurRB7jjgFh0eyPN1IxGewmPws06xbWVhLtONRBSky4U8fYALml+gfm+gW
         cNZSVQCudZlY16FeU/jmPUeQN0Yl+OMtIYHmaLH0cWdhy71d3yubxJIIf7EZG27SUPBe
         qGlEgwWa7XKGxR0fiZemfYu7Ye5vV40wcRixDSl2YYVGYosrB9b58feOJiAqhlNMeIfr
         qqYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/xBES+SM0zcaI4rqFZwwGJz8vu7X/hoj6B6TW2TF6yh42r9FugZlklpbsJgCSsHEusfHclUlrJmw==@kvack.org
X-Gm-Message-State: AOJu0Yz0MUJh0Um38MvGPC8akoAXAT7DfJmw/pYBhTfbBZH/aOLVa44f
	Gb9vLng5fxx7bY4Uwr2UzVOrIyZdwCTv7YPsQDdsV0kuxIbxx1ty4YNR
X-Gm-Gg: AfdE7ck+G0BErlv4G/QGr9RZ8vVct/LGWZSX7aBv3AwVCkSybqborStuC3gJprnik0H
	Z6s1lanuaPtloMLmiDcx3vStP3ei5aq8ZbX/O8ScrNiCbWE4fFuDv9mXm35/qSjA6+m8LIQzVOP
	vVMlqruc9WvSiAsV5IlPoXjYiIdOY/N3UdCpwp8SEqCOaeobmB4Eixkg6RXF90sewpxqPyT8QQY
	dB2EZ0UT4SvpTOoVtTcUpr+6NroA481YkLGV8acaeC92R43r2y4oWPlKP+Oxc5S8215vcE6y1E5
	FNlDfcTIGOrcgMOMYp//xvvuAEZv5aazcNaPWr/tOaEu/DKtXuxRQg0B6pJF4g2hDEBJtBSpTmi
	tkwGViMVBYVwEFjsAwMok0OBBXb5XpoD/Q10mLW7Q7EprH8V8yU7oXwnagoP8Wmo8a9IryYsqGI
	/cylMJA6L1DOp/q8lHmtbYcAChYRTm8vqw6wB3f9kH9Lc=
X-Received: by 2002:a05:6808:1821:b0:492:c931:4d67 with SMTP id 5614622812f47-495ead9873cmr594933b6e.1.1782760228797;
        Mon, 29 Jun 2026 12:10:28 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-49352506000sm7433362b6e.3.2026.06.29.12.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 12:10:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>
Subject: Re: [PATCH v2 4/9] mm: percpu: Split memcg charging and kmem accounting
Date: Mon, 29 Jun 2026 12:10:26 -0700
Message-ID: <20260629191026.2124952-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260626102358.1603618-5-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E67D640003
X-Stat-Signature: 9htufxtwdom43jaowd6rhc8pnmozrunp
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782760229-408966
X-HE-Meta: U2FsdGVkX19RAE8GLgQ93mZzvRHHaUND8ac1pJ1M54FOkeO3ll24pWRQwpkxIRRJWsqAQDceCQhNSdwv/XXBXdTCmdq115Nl4W+KYmH0VLXjDUPtjadsyIqdH3R3mC1sRDEPsSpuMYN6Pqfzzvs2LvoSwlrJhQNnvyLYOBTA14aQpCKz8eMFxBTlkgUVLr8R28HX0mDBon/47l1xJo8iWdnZEe2HLplb2lnq4mKj30SDDy6ley3+kDwbYXtC503Uc1u5OieUbkjTxOP5RHF811L+oGfqyLwvagMZrWxmPcyk523Ys/RIaw1JdPfQXJeR8CI0DGGJi0OsnsK+uq8ctfxvdVR5+8sAsBFNBotf9BNZKyl9KKSuxRNYhYjvHniiWB8kZajsBrk8oLkVcOleWWHDKvMn91lnVdVm92wtjeF8/la7Mie9L3BmvjwSEqLk4Qc9QLTYZYfhHFzEO1NQeVrnI4TPe4U71bv1K5xI1ap2ejLxEyB5O78dUO8EVwGtGUBs6PhHxf0Blu0dRW/UGUcAmdy+qk6WI1zKZZ0etfvKI5Ww3jAjwVC/SfwDuBSqjq8Krw9V/rWdIr8FYpmMblXqijP+1vF3SyjXKD1OWoIYgUYDZVE6Ury0dPQwg8GRuTy6Nm6l9AvF/oEClEFz55q1yO2vYrBZvAOiHq4vMvV/u189weJ9XU1FdNlRB5JyxUbvxB0UUeDPnJceYGaFxsheQHYBt8haWE5Y9yjaKjNkHHK611E2MEi2dYPuD4fClPdVw44BOIyPWkxBgblGPV9/45pTH2/u8TFKNkReoN7hQo+vfnUzK50kodcfUy8fHtfN4XaAnfbOMth4SYSFX8G8nYLTMEf4MZQj7/RWsnMPOa76AaaZb2U767ryuy+x41c778FaMOvZ2trMQLTha/kQM5336L9SFocq7Z4jdymvbwe0SNtFN/Kg180yRY0vsNR1uMgNNfWq6HnSADT
 WPIe/TkX
 PAoIujWcLZqf6NOOLvYcqfAwcbZvc14dNIl6Q+gboQgIrfbNLkQrzPb/BKJIRAI68OIhuuSZAtNsZBbiN5bCJ8+bMI3aAovsjtSqV5hkQ87PDnQdtbkv/kJSARzKvWmYdfU4f1gH4nS8WsDKcS1U35A9fGYrks+YZ6nX7ZKqK13405HOUutg+siAwUy/hSOau9sKZBkzb8JoLEx36D2M4yJtBM3rGYkgqOHAQNVZW+KBRAQIhTEcqynYzIaq96SwlXa6qzEsz15CFDoutKzk94ViIsiZ90VTCuc0tTXZH1TNlOpdQABWuPsg5+YPzUwGx3Mn2tMJIdHa3yi28nG2UmHx1V3NMy7tpE86z5wjDm41nKBYp49UI27AFuSLuLWBvR2gs5WEokNc0KQJdxNknhkI0uVRnJ3k+4In0epQPa9iW4pM4v9FWPOeE7A63IkPkA43VquIF63417pMJOqPlC0hLwk78cAVfn+WiqirErOMx5yVSP4CVY8nwlOSYSnYWZgJ1UwmJxD/Jjl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This is preparatory patch for upcoming per-memcg-per-node kmem
> accounting.

Hi Alex, I hope you are doing well. Thank you for the series!
And sorry that I took so long to review. I'm slowly going through the
series, so I expect to leave more comments in the future. 

> Percpu allocations charge memory before knowing which NUMA nodes the
> pages will land on. So we need to decouple the memcg charging from the
> kmem accounting:
> 
> 1. In the pre-alloc hook, obj_cgroup_precharge() reserves pages for
>    memcg limit enforcement without updating kmem stats.
> 2. In the post-alloc hook, obj_cgroup_account_kmem() accounts kmem
>    and places the sub-page remainder into the obj stock after the
>    allocation succeeds.
> 
> Because of that decoupling, we must not rely on the stock in the
> precharge function and always charge the necessary pages that will
> be accounted after the allocations happened.

I was thinking about this, I think the reality of the sitaution is
actually a bit better than the description makes it seem. We're still
using stock, just a different level so we're not losing any
fastpath at all. Previously we would use the objcg stock to do the
charge quickly, but if we're going straight to memcg charging, we'll
be using the memcg stock instead. Maybe a clarification here that
we're not relying on the obj_stock would help your case here : -)

> That means we may
> temporarily overcharge the memcg but the obj_stock draining will get
> things back to normal.

Nice, this is quite clean. We might hit memcg limits faster because
we overcharge up to PAGE_SIZE bytes but... I'm not sure if this is even
worth noting since the window is so small. 

I think in all the places where you use PAGE_ALIGN(x) >> PAGE_SHIFT
we can instead use PFN_UP(x)? Or maybe DIV_ROUND_UP(x, PAGE_SIZE)?
Just thought that this way we could avoid some of the two-line function
calls ; -)

> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Anyways I think the split looks clean and makes sense to me. Sashiko
raised no concerns either, just wanted to note some nits. I imagine
there will be a v3 in the future? I think this patch looks good but
I will wait until the next version to leave my signatures in case
some of the context changes.

Thanks again, Alex! I hope you have a great day,
Joshua

