Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35DCAC61DD6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 00:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1B06B0088; Sat, 29 Aug 2026 20:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382926B008A; Sat, 29 Aug 2026 20:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2984A6B008C; Sat, 29 Aug 2026 20:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7426B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:42:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F9F5A01FC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:42:23 +0000 (UTC)
X-FDA: 85156084566.01.E815E76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA19AA0009
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:42:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SV0icf9X;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788050542;
	b=jqsUJFr6ZD+XIrfhrK1BUlHO2TZbluQFz83WPPzBfxOhrdOv9FwfG24fNdwFPhtUBpxHN6
	/fBC4NyOmQcGpvLFBV5CD3U+4dB9k4pjKTSRboVYI1Ne+tbVHB9/memxYDukD3goRo6V12
	+5kRMT/JW0o9lIpotoA5rZ+R/2Jnhxo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788050542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rb4xEC514rL8RB4hHk5hsrJ5d856ovaUy3Z49tjYAx0=;
	b=Dz3b3mu2PKZxa5Ljm9lG+1vconn2fn+QSsneCdKzcja3J5iGrVBkvF8r68JkNjW22b1KU9
	DJ+oogv+JTI+1woyvoB7oGOlV2sEpKXYdoIDzLL2nUEI4CKZaGS79HhJuRVw8TBHskI+lD
	p05cokZjfYToVHIVsveivfEYGDcRtNc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SV0icf9X;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B8FB600AE;
	Sun, 30 Aug 2026 00:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59161F000E9;
	Sun, 30 Aug 2026 00:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788050541;
	bh=Rb4xEC514rL8RB4hHk5hsrJ5d856ovaUy3Z49tjYAx0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SV0icf9XNL8ZxbctcyAIM46gZXeJQW3d+vRCQ/i3WsiaRhzeYIDMCtbcdETuI5hc1
	 onYQb8AgOZwAjr25Im4ziTtdVk+0TNtQoGiWrY7tbadrZxIJOnimL9gbA8ksuCossx
	 nViWZmlkCpuiiYK3QNwEou1JKddc/MCvEpYgrcu0=
Date: Sat, 29 Aug 2026 17:42:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Tao Cui <cui.tao@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev, Tao
 Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-Id: <20260829174220.204771edba7c52511dc08641@linux-foundation.org>
In-Reply-To: <aoVUlFdZYLFn_gvJ@tiehlicka>
References: <20260817042652.74136-1-cui.tao@linux.dev>
	<aoMzchLCCz5hiFHp@linux.dev>
	<aoQNtIRvqXRh-x4u@tiehlicka>
	<aoRz72_zdMai_RNV@linux.dev>
	<aoSLxSBUPbEqimJq@tiehlicka>
	<9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>
	<aoVUlFdZYLFn_gvJ@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EA19AA0009
X-Stat-Signature: squmm4tzdyiezexi1nodeo6jatigaabq
X-HE-Tag: 1788050541-951879
X-HE-Meta: U2FsdGVkX1/JNe9wxRm75OM3gd3ITL0DVQLzW10Vp6Th8bHjgxTn1ZJozYBl8AiTCgXthwpdAJgwaT+e8M+5v7mPsMdU927wmioWqPN+zP2LBoGPnZ9zpdxsa/Gp8zqom08xAA8bn5h4THgq8/5+yTxP8JSjISlQVdGDlGGuoCWgU0jcZ0xxJW7tFiVHrZtAVhQRTisOyI/rUMFd8L9DbBujBI2lKakuBBUouiZJWgEufCz4jrOffgkYPBRqldIkBX4u2xv3MiPTZT12GJerihXSNnA8qH8r69FwAccLxqHWtxGH+kjUI9JMlm+gTlyajLparac9hhDeb9VU2V+XH1gFg4raUDjSbVrXyn2S2pjcuxb3+pCmacFCtPNP3pXt4LqzMwb++btnaVZgUigpPotG25EwaVQbyUyUpHyG/2kzXIWEt3METMVdQZVguGOXJIEa44Wy0oqubaeFjcfTQ8MvIgmw2VdDAIuy9vk8+T+vg4jQPVey3UJyz9UgmdGlhI3bgOjKxPqOo4QijbX94aA3jxWZ0qqLWAKitWwDSLLa3oAjBPIog4xjcqztdkpnKqbnZSH4VH7vCwabYXaghhR87ZwkUxmfbHL89nRPnkasEoX/XG7qTuoO9wIiOlm8nF9HM1a2zbAfgeEX28vZCvxo1yJvVaUvcuQEsziLoX595VNRq6PN5R749nnSfplQSiIEpTXy1ooMv9E7X8KZR042md9NkwU3mPtDPgQo2y7kU3nxbPJHKFpUSeQf3dRZUmWRP8zjbcCodCPq/oHxD61t+mLeL6mUW3e3NlSBg+t4mWHt+/C54NsOHOylEXjVKkaxIdE9K0mY7YBLCd/urzs2DNL0fctVH3nXBYAzdsHxLax1aq44dMGpkjA7LRG5nqKmW6ZcixiQJGyDmJ2oiHzaMMUf/2iLclymbT4yaVtfV4eTe2hRMD4W7LXIjcjnsqTJ5rQASBRKyCQETCG
 nnjaWph0
 rxDsZVbae4iT71x67ZvmxoWngIP0KHdhSUase117veBYmzy59DxeIc5BnU6I0OWILlYu0aFObnmRrvT1Km9Ytk93T/tRDvNppcYW7iw3wOm3fB41PkL/D8Cpv6STOKe3n656t+coCE2bXTIXKxGgjyp3UB24Tn8/zQcqf13KPM6bKkvcawOfZI+LiqT/LAKLjvVIui/z9TikGKEgdx91CpxB2tzl13jW5+aLVBEVYBirP9XgyRQgI1qmZNWzu6O4pbZZZmRl8+UgnZ5qFgq6jH6RZIVJBpRVI+rkpwDUWHxC4KPvSHoyDuV2xcpG0JCMBSk/0YOR4AkJrjEBBntev/rMFmD9eE/NaHnvn8Mw9t/UGsR5CCf4hE7MaYJw6tyKDRgzR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 09:00:36 +0200 Michal Hocko <mhocko@suse.com> wrote:

> > Whether that benefit outweighs the compatibility risk is not mine to
> > decide.
> 
> And I am still not convinced. I do understand your frustration from the
> debugging the issue. In any way, if other maintainers decide this change
> is worth I will not stand in the way.

Shakeel seems OK with it.  Other other maintainers are being aloof ;)

I'll queue it for now, along with a note that additional poking is
needed.

A v2 would be nice, please.  Add details about that production incident
and make the requested update to
Documentation/admin-guide/cgroup-v2.rst.

