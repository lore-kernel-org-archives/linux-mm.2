Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660E9CA5FF1
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853F06B008C; Sun,  4 Oct 2026 13:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B3D6B0098; Sun,  4 Oct 2026 13:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768006B0099; Sun,  4 Oct 2026 13:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D2F6B008C
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:53:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3D41140B75
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:53:38 +0000 (UTC)
X-FDA: 85285691316.12.8CD897B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4D22C40008
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:53:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QoiadJJT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791136417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dW2d3LGbBGSadjanQBD6Rhc29aMig4rkrP/cDF4hCPM=;
	b=eYONkC+1zJD4aiG7dV31D0dK9ioXi7O94IwSHReM80G5/U0GCXf9gxRyRpralMw6zU4Pc4
	zJeqOYyuifAxTuOvflZuwYK30rxxRYB8V2/OiDcmtFzXI3p76An+G8I2hQoKBh6Jsx+p18
	kEZFKwTL6mrH9g6j7WMPiy45rhfxvq8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QoiadJJT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791136417;
	b=3olViagkQ1+nkUya3KgcByV5fIK1VmHlV6U5pibv7vO3kg9T4t1DwAhhEdygSY6biPShkf
	q/qtutKdsedqHvF8dtWSQ3GoBiXu+YNsxHIByX2HO6YUTlsazw2u68gCHdoCkeo086GIb4
	hbK9rZ9LtwTWpqE730lISRFH54NQJvk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EA50601F7;
	Sun,  4 Oct 2026 17:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1167B1F000FF;
	Sun,  4 Oct 2026 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791136416;
	bh=dW2d3LGbBGSadjanQBD6Rhc29aMig4rkrP/cDF4hCPM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QoiadJJTHbytHLLUgcMMJDU2oFapVhRXRlzl12k8kd8u1xmwsp91V3Vv5KdQJ8/8n
	 SRnfB2A4IIMfYR5JpyY29iU+f88a4kaHKDpHr3HlX+Y/2Kdh/cEUvZFKyDjeQp+9sR
	 fdXwZkKRN5on7IdkIwshDYEf/pgjqQW6kScfNW/Yk3BT4/s0+KDfaEPd8WKRNmZTkn
	 K3NccYEeufnFJV7FH2iw27/6wrnSQPDhBnGg9gmyv2S6+421Jkv8hqxUWvc+lTzBjn
	 w8rCq9In5zLZUrPSnFVq5PLTJPIxBMhg3QqnjJDetBIE2lvyL1LhuWZr5G5+6XRRhl
	 JkK1N+yfcGN7A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chris Bainbridge <chris.bainbridge@canonical.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Jason Miu
 <jasonmiu@google.com>,  Alexander Graf <graf@amazon.com>,  Ran Xiaokai
 <ran.xiaokai@zte.com.cn>,  regressions@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?=
 <mclapinski@google.com>
Subject: Re: [BUG] KHO handover hangs when memmap reserves PMEM
In-Reply-To: <asJc1GIBbCJ26akS@px13> (Chris Bainbridge's message of "Sun, 4
	Oct 2026 16:09:00 +0100")
References: <asE0R_f2r2TL-3Sy@px13> <2vxzcxtplh4i.fsf@kernel.org>
	<asJc1GIBbCJ26akS@px13>
Date: Sun, 04 Oct 2026 19:53:32 +0200
Message-ID: <2vxzzewtjqsj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4D22C40008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: j3a1fjt57zyxwk98i5g4t53r1i71r6ag
X-HE-Tag: 1791136417-671615
X-HE-Meta: U2FsdGVkX18kOEgzTVsXSyVqvm62DNJ92KyUqgGbGQOsY+hASCtpum7eqgaj5liNnqpCgjQQNpvEtAcyELjDT+kCGvuM8IqbUw+eV8RnegjkpdOFF54g05RGl1sp5G58pd5uqC0CNT7ZESFewCQXUBL3adg/2/SPwlvlW282jHYOesB5Eu7ggPZgRaiGKJiQVIfuJaA8ga12R99rrILBbrjpGP0BK+nroocLvLn7SSR4kMfyA6R8Wf8SdSQreTQRNNm4dUNid6QOZOb/UaGwvteXIJmxDnZa12XKRwDYLrmsKodk4z8O5KqmdjrOV31tohtaS815H9VO+YXXuOWRVXslPC6UXknmiCupYQF0Mp4tgc2adx16ENyefNVAvV6tR/rFbQvbj7g0w319mRo4Ha7Lb8eaqleliD2m3H9gK1lEdOSHI5cAtAK5h1AAyBRHgG4BuNiQdi1ljjYf5yCwy3iPcaAx6Sx7s4icvV1qLSq+7VHSti3EzhfphNHi88al7ncUx+fnOEDHhvUwiaiog4aWcXh1l9854Zm2ZgJ8mX6LQoirW+csXFecgTuEmbCANKiQIjRdnsmgIrDVEim7IFPUePL4olJudHJ9TUIdy2zs+SRSwV2RXvxkiMZHx9MwfnY8DMsJjbmBh5vVsFXIkX6W2y2Xg3Omf9XPZLUWYAe9oiCKgJFyCCh2sYsz1z34jhY8vcE9QSJgZTgVOE9JTMwOyS5va546h9/sTnWmsRgXFLI2nJB42RtwcBXUPCcy8L4wHXzBPdPTVfiy8bj3K795HtgABNZ7AKPSPDB73reAnOU6oFDzQp0HEK5rT7/NP0MCSvCLMhYKVvppFNNWpxfItruRUWigc+pin80GcFXSbIb3FtuL3i86sfsujUzkpuZmtIU7BIcEg8oUvVv7qowDix40dI9vBwyEfxZNQDBA+2iEPJOVaNRhG/uQ0Q+3lWUvnFFlwWQQt8395IY
 js6HXABJ
 rTlzHxt8pVXma433nPlHTx1H2fQTj8q0Jmzc+Fsv1gEo0os5CjeFHdaoWzA7muU3qLuGBp9fVt9CdlcwOpOrNgHcihapw6nQT8dVRrwV/cqh+37LTmvJi8zkBhV1I4RTmZSXKJDLcHubCcea66Go6Eq85SNc9BjfhCc9NscwT+xTt+ham9ML59NRQ6A48zNfmx0crv9JfylkWmIvlfP0AVUvh9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04 2026, Chris Bainbridge wrote:

> On Sun, Oct 04, 2026 at 03:39:25PM +0200, Pratyush Yadav wrote:
>> 
>> Just to confirm, the first kernel boots without memmap= right?
>
> Yes.
>
>> I think the main problem is that the radix tree pages can be anywhere in
>> memory. So on the first kernel, they can land in an area that the second
>> kernel's memmap= reserves. So kho_memory_init() might end up using
>> memory that memmap= reserved. I'm not sure why exactly the next kernel
>> doesn't produce any output, but IIRC memmap= memory is not mapped to the
>> direct map, so accessing those pages likely causes a page fault.
>
> That's correct, kho_memory_init() page faults. It happens before the
> serial console is available, so there is no output.

Yeah, then I think you need an extra kexec with KHO off to enable
memmap=. Or I guess hot-unplug the memory you'd like to memmap= early on
first boot, which should make sure no radix tree pages land there.

Apart from that, I don't have any good ideas to properly solve this
problem.

-- 
Regards,
Pratyush Yadav

