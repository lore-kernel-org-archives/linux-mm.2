Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8125ACCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 16:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0AF8E0011; Wed,  1 Oct 2025 12:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8238E0002; Wed,  1 Oct 2025 12:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDAB8E0011; Wed,  1 Oct 2025 12:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAFC98E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:41:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 512531A0199
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:41:39 +0000 (UTC)
X-FDA: 83950111518.30.21D9310
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3680040014
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:41:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=eM1Klstm;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759336897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8Pdh4UPxBNFa+jIlOxZr+0N7CcxwrBzi/u8gKDgJeo=;
	b=whXUey1ZZfgSsm5prxSvD5wSd1ydZfl/iEGPw6K7rTTbi9x00VEJtI3xGA8TTk9tTmHCrm
	ziIWufarpnCklfWnxsYMfIAEfPH9JufACAXWsWtVYUEwxRC9ld/uBJIj73mB0nkg12J74r
	51tydr+fR+xcz4GJS2xO2U163wCgZkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759336897; a=rsa-sha256;
	cv=none;
	b=oSddkuOmcy4br1hui2pCvnEOoZ9Ji1ZPCSHHxI1Xbnwk6To2som8syWELfV6h9UhZY6OsU
	lanBrc/67bp0n8+c9ATzHtHU6HsL4zdOHiD39jkSwoPp2l+GraWqNuYJb3CbFyDYwBzRBU
	Yv1uODu8YRjlfmhn7IAXouKyDIOmMBc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=eM1Klstm;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4df81016e59so394821cf.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 09:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1759336896; x=1759941696; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x8Pdh4UPxBNFa+jIlOxZr+0N7CcxwrBzi/u8gKDgJeo=;
        b=eM1KlstmrRn+CLLLhlm2qoLY02yq7ePIgE7FLsw+hiigBUByMD3QYGIrD6pn/EK5mT
         TytCk/T30LR1Crvnjm3SAQF0jypwBBaT5/lC9CK5tVTIqcOpKUxfah8zvs0S8S7adMFF
         r6J9FnINBnb3gChawYUzT2cP/vmWPSzVMCtU8IlG7bQa10c5hP8VKITWQ2n1WbQKLq5S
         sYpve/oIl1lRGUPOfSZiC4OVSpDCLinUci+Rc6GQH8t1LojGLUQzdv0AYUro07cPzQxF
         0qetR7tVf+M4zixcwwYUc2yN/5f1Mlu+vJZlWje0Fb0ZzkHhLxqQ3mhX6Ic27X7boOHj
         DBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759336896; x=1759941696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8Pdh4UPxBNFa+jIlOxZr+0N7CcxwrBzi/u8gKDgJeo=;
        b=EdU4HB8kxXxbirE3zRj3RGUYrx6rFfK+G6zFvsCbhzAz6uT/rISQsI7zvvRHjYa9hE
         sgLcMwZ5pXN+eQ1qMkntnNiua4CQTq3EwQBVmKZs9Ns3g+7mOyusKi4ZHIc0bABHY4S2
         1ISfadCjRi/lXNKyEWpmIYDQPVe4Hzkr1vpPqDMr8t5x8mUG9CscGt4Cl5dbrQmOZKgD
         sEQxed7VbZ9YaFwNJuym4EIR2aZtDR5S6CWKIMLzHM5vPfHAL5dx+Oj8DSOkCcMkn9Hb
         V1ws9I93l+M4R+Jg1Ke7GLIixagSiErXFQ48ob9tT2zH9CGMnU702ZoZR8I8EFAJE/nA
         IdGA==
X-Forwarded-Encrypted: i=1; AJvYcCX99XUUY20YqEKZ2F7srOjeRb1CiyVo96Z2UagKs2p8PuxA5/72XqWy6VM9VszSRceAaDR4fEM/9A==@kvack.org
X-Gm-Message-State: AOJu0YzPmXvqmUNaG8Ud7/DSyXwJ4/dcI4Rvp0x39QhJrYYLiJmz5pyt
	xXKccMUDDy0mtyKbzuz18voj8msA6BOx8G2dNvXrYJC7xg1CNAkHFgpUDsUcxmesaro=
X-Gm-Gg: ASbGnctGuod1MURFyWAbmWXEGMnWBFMaz3L5Ap7Wf9fl7IsA40PKB8DCADAn6za68HU
	iQPVubzVvGSPiPjoGSgHy5D4Bd9n6vzrL7/duICDF8q6+itfHLQNTtTbPP67150kwcZ8+3Z2nNR
	DnadDZLnFJE32OggJ2qmDx0JTj2RASYDE9XGr139PUPYpqW8VoYGCpFpj5yJXr7r97TumcsKhPO
	siJG2obFYXddoTkq3lnyaX3UJ4enOy918m7nQcjGcqfjbJA8dlLkp4fZKzrrh9k1RaXdO2vMAVU
	EoGyMY8VIUEepXhPN/NINsL/zjx4bHAHXgpFpdAa2azRaAArvXdZisF0X2HEpSOEDziYUSfBl3y
	QFJCpgM9wjBSgaYU3qaQOFNPNUE9AKJXTV9qzlJpsTPxB0Q==
X-Google-Smtp-Source: AGHT+IGPb0Edu1K4J4/cuc8wtsu5FZIIzXcuwfIai0CmgIW3O2Li8d+X8dt0nP89wSlyBM1hFk3zHQ==
X-Received: by 2002:a05:622a:2cf:b0:4b7:81df:95e2 with SMTP id d75a77b69052e-4e41ea16a29mr49675751cf.40.1759336896110;
        Wed, 01 Oct 2025 09:41:36 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-877796a1c72sm8001285a.46.2025.10.01.09.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 09:41:35 -0700 (PDT)
Date: Wed, 1 Oct 2025 12:41:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH] mm: page_alloc: avoid kswapd thrashing due to NUMA
 restrictions
Message-ID: <20251001164131.GB1597553@cmpxchg.org>
References: <20250919162134.1098208-1-hannes@cmpxchg.org>
 <4a793133-6cb3-42d4-948f-84eae6fa7df3@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a793133-6cb3-42d4-948f-84eae6fa7df3@suse.cz>
X-Rspamd-Queue-Id: 3680040014
X-Stat-Signature: onxfs5zr9xwzaxbjhopo7c9yen7ci976
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759336897-406826
X-HE-Meta: U2FsdGVkX1/5UwOK+rBI2mtvg42lrcCdiCzqWAdj+iJUu2Fx+sp6/+BtFtnwsYMnpE0f5ayK5xklPZt+5G8x4CrckwrSeCBzyAiny0z9xYf6Got3suUximuByv67w3JA+vmxgx25hLLSCbPKekic9KMXUJ6qtFw2ef4vg67ZUi79QjY6yeD3W4Lkb0oQCQduSVEVhlMK6RLw4okbDPHv+TqIHqbBDYNF/zJiIo2NZlJmrW15lJxftk9836SHmTQKgUU7IoIuyj1FrmcDk/0YwQMNNoZZ9VtPHBTE8fUBjIXATI2jRySpP5Ebz4cCkpbYUyfXwVjLjoJKPJgnW/t5tocrmfEes3G+9d5n6vyQSKfoNNPZdGTIswMdm4P30fi7t1Hj/V/Hg+bJ6ba8bf+GLzCvZ8Z1MKFefWSsstY+6wV7TirfM9EaaINv5tje2NTl4hRBDsAuGWhUDQyfdNLmswOSVYkHTqVjkiiE5m44nRAmgFcGnAo43o3xZchHJKALtt80YF+k0clT4jMKPyiCWFvWneFIwqWGh+h+Dxbysn2UNoFHQkKkjkqVRRIRcnrZJVQ5+xvmAanIMKonWzdAac3jaErdrAIZIyXT+dyTH55oiZccrL0NvnkEOLnAx4RkTiweagQJGQd8SMo4DWN4o5lpU6r58A9XWd0EsgwSxuY0t2ho9ifc2DHXSulmqiXrpVpFWhkDWSUPI2y9sxiYUbv4smLwxVCpIzp5+BcIVwF8MXG2Z9ryoTgO197VKXrxoCZllsmu7WIYYpMb6z1pF+iZY9EJXxjaHmLjHTi2dldA6GINkyiA4rj3sxXngvdSpURjjLnTSkex+MH21tj6222vYXyZe3KZZYdpkenynt1m3QOBUtLBMScCqi66JFKBhaETxBmxADJDLGe00jFz20D3Xwf3wi67BCukOYJ6Yzu1v2dnrhucrnQnYgiKBZ+yomsOZofn2vImpcn6P3U
 Ii3tiCLK
 04G74SvySQjI1JUG14dvqJXst2l70hkRxkI/Um4AJbRARm7awPd06n1ZOzU/5tC7X/NPJdwr4640QUu46RyO4jsBCMjkYB657ZA7zUgtyKUycJBRBLgG/5gsgIuOpmb/FJNr2pNvI6+E8aXNuIDHjGECtc4mFutrFTG6JEyoUd3YZ0E3KOPecR/amhsFO2Yg0df0gOMeBqXte7BKAFqE0U4hwdLaqK6q3Wy428kKL7kE86E/5JYe+PIYbdq6mChCuP37PNE+3kgrid4J/3J/Rd3/7rZ9IOVY6NVpKez5jIDgGUPPXVh62GtDolrHyK1Uyt2F380fy6IxWv8jaOH83AY4JxvEFYfUNZJs+cU57ZxL1S73ShvLXGSYbS+8LQEA2YSJVaXJPVNsy4ox4Vk4kUJMKYvIkq2fNzBSLVEv1wohiu2kaDen5lEMky/IK7P01tE6EkKWo0EHD9Hl2lzUu2PqBAtsF1hwZWoFpcbSmCensxVbQE22/mqO71uaRTqHSzIWJ1CHhcPXPdkM+AxRgKPmsWRltb6wSZRtcW+EtneFk9A7G+xcPV06BPSqUJavd/AremZbDwR/rLNonUSkfVZAxXwuJr4CD3PegVpKAuwBt9qM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 04:59:02PM +0200, Vlastimil Babka wrote:
> On 9/19/25 6:21 PM, Johannes Weiner wrote:
> > On NUMA systems without bindings, allocations check all nodes for free
> > space, then wake up the kswapds on all nodes and retry. This ensures
> > all available space is evenly used before reclaim begins. However,
> > when one process or certain allocations have node restrictions, they
> > can cause kswapds on only a subset of nodes to be woken up.
> > 
> > Since kswapd hysteresis targets watermarks that are *higher* than
> > needed for allocation, even *unrestricted* allocations can now get
> > suckered onto such nodes that are already pressured. This ends up
> > concentrating all allocations on them, even when there are idle nodes
> > available for the unrestricted requests.
> > 
> > This was observed with two numa nodes, where node0 is normal and node1
> > is ZONE_MOVABLE to facilitate hotplugging: a kernel allocation wakes
> > kswapd on node0 only (since node1 is not eligible); once kswapd0 is
> > active, the watermarks hover between low and high, and then even the
> > movable allocations end up on node0, only to be kicked out again;
> > meanwhile node1 is empty and idle.
> 
> Is this because node1 is slow tier as Zi suggested, or we're talking
> about allocations that are from node0's cpu, while allocations on
> node1's cpu would be fine?

It applies in either case. The impetus for this fix was from behavior
in a tiered system, but this seems like a general NUMA problem to me.

Say you have a VM where you use an extra node for runtime resizing,
making it ZONE_MOVABLE to keep it hotpluggable.

> > Similar behavior is possible when a process with NUMA bindings is
> > causing selective kswapd wakeups.
> > 
> > To fix this, on NUMA systems augment the (misleading) watermark test
> > with a check for whether kswapd is already active during the first
> > iteration through the zonelist. If this fails to place the request,
> > kswapd must be running everywhere already, and the watermark test is
> > good enough to decide placement.
> 
> Suppose kswapd finished reclaim already, so this check wouldn't kick in.
> Wouldn't we be over-pressuring node0 still, just somewhat less?

Yes. And we've seen that to a degree, where kswapd goes to sleep
intermittently and the occasional (high - low) batch of fresh pages
makes it into node0 until kswapd is woken up again.

It still fixed the big picture pathological case, though, where
*everything* was just concentrated on node0. So I figured why
complicate it. But there would be room for some hysteresis.

Another option could be, instead of checking kswapds, to check the
watermarks against the high thresholds on that first zonelist
iteration. After all, that's where a recently-gone-to-sleep would
leave the watermark level.

But it would need a fudge factor too, to account for the fact that
kswapd might overreclaim past the high watermark. And the overreclaim
factor is something that has historically fluctuated quite a bit
between systems and kernel versions. So this could be too
fragile. Kswapd being active is a very definitive signal comparably.

