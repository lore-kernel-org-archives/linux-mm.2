Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117E8CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 20:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5126B0005; Sun, 17 May 2026 16:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C326B0088; Sun, 17 May 2026 16:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA046B008C; Sun, 17 May 2026 16:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E22FC6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 16:06:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 773D58FCC1
	for <linux-mm@kvack.org>; Sun, 17 May 2026 20:06:54 +0000 (UTC)
X-FDA: 84777995148.10.C987D25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1F32A0007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 20:06:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLsN1KPy;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779048412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/Bp+/tLEI+4NW8kmR5jMcppDzOEYABZu6fCV9lX+3o=;
	b=j3TuiFhBLtQfC3z5YUwXMwb60sreDit2abMQ4McIgG0hWOgzlMjE7Z9cC2/U5MD1zKq/ZA
	Jg/5TNCcHiSm70xGsLxE4eljuUYyvKJWKa8h0hQkIIxW88hmw5Qts/sWs2gv7QALjwR/Pj
	R5Vl5W0FuEB39yEdUX+zgGeJkjpEIeo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLsN1KPy;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779048412; a=rsa-sha256;
	cv=none;
	b=jyjto7urW1Yp2uBvEJoF40kjKW3emIHoBeYn4gTmZUk0kdRbPIRKPbEAJQcIL2TS4XOsu7
	hmWblNNLSGQ5p5jzzMdrJ6JwrC4arJkh1KTqaJBshKolo+ScURw9OHuu4ASNUFwRuyk6YS
	16/PGitdaIQAPhEaHE2fmG1PRPwUK7k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B21A043944;
	Sun, 17 May 2026 20:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B7AC2BCB0;
	Sun, 17 May 2026 20:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779048411;
	bh=1jR4VX0JH89Q5myxphrlJ1We7QqP2GmhqIm9qlScids=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kLsN1KPyLk8DdyXryMn4yzh4aQAsjdgC+8dX7efJ36TBpLZMTeTyVl3hR5NMxjRuo
	 Qpo2CDWraGCLYVgHP+39Jvhi8QNHNXTWk9Q4lhwD0ohmDKHBzvJ4GxBkjd+5WSlU+K
	 uys/Y1AoA7KX9GAn319kuuxkVY7OSFN2aL7IgiWw6jvVltdGHFoe3mHyJAQdP9LgBK
	 08/QGZ3jQUARoKrxskI4eWS8lNC4hyvmRA/ui8UtxqUAsMK8Mf/w/BRrt6QjpeqJrG
	 LCQ5RV8vP26luMXvup77gPJaCgZdK4nWzkYdH0ZM6IlmrH1558CBFnJKrzIO9mIhyD
	 NtQjGd7QibKZg==
Date: Sun, 17 May 2026 22:06:43 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, djakov@kernel.org
Subject: Re: [PATCH v2] drivers/base/memory: set mem->altmap after successful
 device registration
Message-ID: <agof08pql5svngb-@localhost.localdomain>
References: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
X-Stat-Signature: 9keiwi1kc7m4hu7q3etn845b6hmgpz95
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1F32A0007
X-Rspam-User: 
X-HE-Tag: 1779048412-707787
X-HE-Meta: U2FsdGVkX1+gyiQUHYrGeySsBjuIxb0zYmi+RkCIM6J3AjAjJ+4xK2asZq0dvxUUKoieKpMD0AOiwe+NceCMBl/mnxeNH08qVJR8MYyIUIaGfGXFGKfhaAJWfrioUVVHlbECf1vTMPH422KQ7kI3Ine7IJEhl9KueBxl62WmZqvsbRC/DVxyY2kIExMfdPHoK8K40+eUQ3V42XBOLcCCz/j/y45rUvRNqJdLJAsfyaH84wZbVK4oiAIxOpDIVr+743PR5ri9s1FIM+Xa7ODul/GNokizRyJuv0jl0EgRjFOSg4ZEN9sLY1tLgF5zlGAKBuYRAegdpAibg78DKJWSFcdnj4LTx5Blveefhs61xKsua/jaxDd6EAsAgl91hdlDvX9PJIjaEQdUj02hm9rweOTqyAR0P4R0V4H+S0b4MdmNlj9l+ywof8JXvaKA4pr10IuusZfqFEMAEtgTHDFY4N7c8l5ef7SET3F4StyhqR9J3E1ApEWElPs0CF0SDbYjPDWFY8RCYEckzXSP9zrScegsCCQNB3Exbzot8M1vUpNataVigfPegLE8H9kwwVXEeuwhu1waU7aMoxVqlOZDidN/QtCdUzgQ1nwRGodzeZ/7xspGQh2hAcXKPEL1SsvU17oRIkw4RdcT+DhdIfsvWg3IBCb+8ZO/jRR0G7nrWMRG5DaQ4aMO0N86PNjErvEYOYpaDg1eQE5lteFCcJrITmTgDCZFVKbPgCX7Z36wNR+K0MBzhc/QkElGy6SwS2RtwDu/zPlXxEEMI9Fyqvu9gdgo43l9QAJemuiUllJLrslTjKrS4+7ImI4Ab1YtSvt1Fj92BsW5nuCuWxl5uv7qBAMigm6RJJmzdn7F5m4gH/B1NWtezZYQboyCebbEnXR/IrlffYsR/cawi5Pq3fHOilQaYzgf5mAg3gkcaHsSbdXKnS+Rw2VBHb6ImU43ZdM/SZ1A5CMSSkQrVxHaEAp
 6utatSb0
 67L1q2AuN0iOUPpN3Z3+1oiZAFoPQ2xsgtIS48GozumnhN9aFEx7J7HFmnktavi+spD3B28NnMIFDPZeI5mit41qlnssflp7BhIT9ebl/5YcHu4A5dojZ/tbsMlJnZUdWH+WAdDyDC0TXz+mViH/m2EDd9gTTKUTGzerMT4iOERr8NUYEbXr8Rac2R2e0F7lR0xkUrEcErEyGe2z+jTeDFhTCecbY6Dco7d7kWadobXLJR5wYRttRjf9obQkD7asqO/fJRg9FjcABOCrISIeo5u6CuQdVjC1a5F3G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 02:26:57AM -0700, Georgi Djakov wrote:
> If __add_memory_block() fails at xa_store() (under memory pressure
> for example), device_unregister() is called, which eventually
> triggers memory_block_release() with mem->altmap still set, causing
> a WARN_ON(mem->altmap). This was triggered by modifying virtio-mem
> driver.
> 
> Fix this by delaying the assignment of mem->altmap until after
> __add_memory_block() has succeeded.
> 
> Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
> Signed-off-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>



-- 
Oscar Salvador
SUSE Labs

