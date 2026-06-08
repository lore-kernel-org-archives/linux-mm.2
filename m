Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB8DCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 17:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96FE96B0005; Mon,  8 Jun 2026 13:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9436B0088; Mon,  8 Jun 2026 13:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FA26B008A; Mon,  8 Jun 2026 13:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB896B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:06:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C1E01C15F7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:06:52 +0000 (UTC)
X-FDA: 84857375064.23.8813E45
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5A5B81C0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:06:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pHY0kcV4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780938410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxLCTA42pe5OBef7r2AffcYmw2OMN42SHm3dbS4saMo=;
	b=4l3+VeMUp50IzbkTr3axPVji2rtjVVR/vdMnyJ6fFay3oYwGHBLQo35yjAiS9jeDygWnNh
	Z/Et3n3QHjlypEyrqYdB+RdHcA4P83iwHhc9BKTbTOPkEb0ZJ/ZsLF9tEPgbK+DXJ4UvH1
	AREKsRcYaPVt1OB6fYHJzRT6pLqqeQQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pHY0kcV4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780938410;
	b=DKyBiYH8lPRn8IuHaGPeMWtMlba1lsBbdw+e3m8x2TI4KPbQRIf0TPaqp5LfLJ2UawgJix
	UsO8yGcXhs9BwvSbMIj445Ndum3lCElyWDhVEEngZmyYqFiQA1sSl8R+Hypv6qLtIFeN/D
	llmBlqxmFj45+n7TIPJIcJybUBnGcyY=
Date: Mon, 8 Jun 2026 10:06:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780938408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HxLCTA42pe5OBef7r2AffcYmw2OMN42SHm3dbS4saMo=;
	b=pHY0kcV47BV16ilmop3HvzDI4xCXnAJQvVZg69ND8glUhnSfvxLgyPuqAUPBoAUmm1cP2S
	vdm13RoDZ7A5Cc6ZV7VibBu6yTl0mbvjaSU+7Cn7QgXhUQt5MwDVEoeVaQi+Z7fg0ZV0GW
	DvjjLsO9Kx3S99qPp0oOLCqM3wDEUxM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/vmpressure: skip tree=true accounting on cgroup v2
Message-ID: <aib2hs-mkLjGyH9V@linux.dev>
References: <20260606114158.3126210-1-usama.arif@linux.dev>
 <20260606114158.3126210-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260606114158.3126210-2-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8fbr3bye6wm8cic6moxu1rq4pxbq378i
X-Rspamd-Queue-Id: 5A5B81C0003
X-HE-Tag: 1780938410-554606
X-HE-Meta: U2FsdGVkX18tiffxIQM9QqJUm1+wscZTAGb+JbX1k7fbQhyDUqecj40QBa8X6HHjWz8W5VdQm6nUh5zHN/ioy8TO7EPf90lgrWUnQAwHkIivMTn/CL/jTrE2ZEtGvUr3/ZN+hqtYmQa3/r/kV6em/kgY+BVIOoz8tjC6ohEOjRNcwZ+rzYOpn9ijwL4Bp7pgFQ5XmAv74W+c8FmH+ENYitbG8hvh6DrlQdlFteBJqKIDMdEgxG0tl4RxWYNBqAt6JnUmkN9N1k+y/J1aTDAXGH8/WRCjeUf2v7oPVHWXZOJT+0QKGEFa+Jo56TjOoRK6huc6It2Q0/RukKefn/sVTvNSB61ZFDspVuKdsCLazqNfhcSFLWiCpYfBaMCwi5lA8gdmZT/3nEKarZZ8nEG+1d6s+LXc+veBOFxFOCiqaqTBwOcrSBFmMM9knFWR7hQGaCqajEgg/5kUMQOLJsTLe+qvBYFmNE+ym3wSis14BIlN+jDpRcAc9LSoa/62XRQU8c3Glqk7g9S0kKjaTCeMefboDnHM/cBo8XGBu61MgiutO9pBBZcaU1/49wZSgo0h0nhvad6NPkZSipzqBcvFC/mLlwaJB0ycId75lGf7sHwqRkyjdqMhUNhGMB+1zW2gsDEea0iilgrzaLQexM+SZAIhtALLhN/6NPmfCkR2t+2s8tJ/UlhUKpnzsGhHzFpdE/RIEjzG/27qqha1kTciZ5BF1wuQmOfuZuhXShtjmUg9D/edgztT3AuA4kPRyXkpfrJQ1q1wMUpMsQW56e3GXB8uHOChf8EY5xvbO4kAHH8CatFWkJij31LfSrq7rztKuxokQAAd6vjwTZcMcD3BEuIqsog5LiCznwsTgShaLjhmLDp3coR0i1clv/0hYV7sJJeTcw+GC/zccHUDazh760R2VNAogZtqcNak9+P7KKz+0dvskIge3EFRLpDFWZsj0bjSha4xy6mvfOG55Ow
 E7RtuaXv
 0BORlVI8aYuhV+yU4u7mQk7jQgz5/5yfk8yT8Q9bUtRa7iE+0ao7P7efmGxU+SyDHRMtqO30pranXf3P0jYnr2Ui1G2/nogrDOhcW1E5xQWpeE2dgFxHc4QipjQf959KZrMOEXTdJxMqOclqsgjG4QTKovTmH7EYJWPphI5RF1YcmT1ODHEV1gdxol+iTF5UrXaFcIWceKhflXZbuIgc6UpBxuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 06, 2026 at 04:41:33AM -0700, Usama Arif wrote:
> vmpressure() has two outputs gated by the @tree argument:
> 
>   @tree=false drives in-kernel socket pressure (mem_cgroup_set_
>               socket_pressure), consumed by TCP/SCTP. This only
>               applies on cgroup v2; on v1 socket memory is charged
>               separately via tcpmem and the consumer reads
>               memcg->tcpmem_pressure instead.
> 
>   @tree=true  drives userspace eventfd notifications via the v1
>               memory.pressure_level / cgroup.event_control interface.
>               v2 has no equivalent: userspace gets reclaim signals
>               through memory.pressure (PSI), which does not touch
>               vmpressure.
> 
> The existing early return covered v1 + @tree=false. The symmetric
> v2 + @tree=true case was falling through and doing the full lock /
> accumulate / schedule_work / parent-walk dance for an events list
> that can never be populated. bpftrace on a 176-core production host
> (cgroup v2, CONFIG_MEMCG_V1=n, 285 memcgs, sustained reclaim) showed
> ~16,200 @tree=true vmpressure() calls per minute. Add an early return
> that skips cgroup v2 + tree = true which avoids us doing all this work.
> On a v2-only host this also eliminates a lock contention path that can
> serialise reclaimers on a single global sr_lock.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

