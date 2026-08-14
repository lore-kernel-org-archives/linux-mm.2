Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E239C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 14:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C676B06C4; Fri, 14 Aug 2026 10:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED2B6B06C5; Fri, 14 Aug 2026 10:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203F46B06C6; Fri, 14 Aug 2026 10:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F006C6B06C4
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:54:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80688120172
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:54:25 +0000 (UTC)
X-FDA: 85100170890.03.4475886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD294160006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:54:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=icnyz1CS;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786719263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVwa9W3wNvZdvVfG8ALjTSZQ2WF5kVRRrPid54ltR2M=;
	b=r6HNNVCx2Q+ysyYoFCsYr1S9v0MtWu+G3dYy9IWVJQLhY24id8CWa1iA0o3dAmFIdZ09Ov
	Oxg8uMadKRxSn+IKycafjUVdrOFgjn/ZDx3dQnbL7KhA9oMhVYUWJpC47YXiMyheRtPCSD
	0/7MW6tlbv1+8TpegvmNZ0nLkQ9oFk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786719263;
	b=3BR8EsF2BiyXcklw3pPJKGZ084LKbxwOLT1PjR1lB65eBSXwwi7l3Yyp7I2jtRYWtiXzll
	gPkdCChO0eA2rYnBRdPadEIdh77UqsEFieSsWWCdKYAfwSXL8N8Z9GpEMSxrwDZeKtwZT5
	tadoORK0MT3GCdH9qYXjwFwxLPNe4QQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=icnyz1CS;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A90A600C3;
	Fri, 14 Aug 2026 14:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CA51F000E9;
	Fri, 14 Aug 2026 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786719262;
	bh=qVwa9W3wNvZdvVfG8ALjTSZQ2WF5kVRRrPid54ltR2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icnyz1CSGLfhVWu8Q6+5lvLd76s2TnGEWUy2rjdTTlAmTSseWAQu/6DUgc2s6aljb
	 qY0aiVTtkZV0OKyzUrTA6L+BQgZkEO8TXh7ahZ4MDteEKiPPgLdguI09XzuiZ6zjRD
	 4uHOxM5S6gC7WljO315Gg79Ku0rHeyyh6LWh9e+WLhgJJfst0ZC0CKZXP65n/F238C
	 5LhYOARCXDROeM4cI07mtuw0qy8QOedMM3EPcm2XfI+4wKsD3xSJXwNI59QOt8Flxl
	 aUTlO86JmGUdFrOdHJDh8DJn/kNbks+1jC4A0gAB4yGqqZ++gApp7Kr+mfsVmnbXUR
	 j8Jgv8C/zt/Bw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Gutierrez Asier <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Helping with alternative for watermarks
Date: Fri, 14 Aug 2026 07:54:13 -0700
Message-ID: <20260814145414.91204-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260814084710.39955-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gmor54t64rh97hud1bwz5bs7bqu7qthw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD294160006
X-HE-Tag: 1786719263-879758
X-HE-Meta: U2FsdGVkX1+YuhszdD6FBJBAl1GTWX39aJBTMt0NK4gzuZzBmvRNcE3Ous4sb8GAmZC9m9u2zlf5MZb7tfAEre7LsrlPn6aMgoOunWJKPk7n7/R/MsXMqbhG30c20+JCBqg7jRPj0wgHm6ZZPpE+JcyclFXqvHAbRlE1vYZsLZPL4Whl2RTAOHUlLMb2xSDtlGGcbmVgRn/1j4iv779deBuacIGJGa+dkUq+V2nzXwYl+HbKpGHHK0/6xnv+1MEUNuZgnNyj7VsgnpwBrhHoR9uluynVBzJiE11/rDTHj2iWlTJk4kOcYw/A75XRFdOPhegkyADZQUiJOsOutvRmMdphYokh8WVpj0xjh8/nLp+jTbXRJoFDh8F5f+A0Qqdk/Y/flS3giRHVXjz7V62D6V8kEavh9ttdHprNed6hZodLkFuoxJbN5DbBYNkpMbH/et5PYbssGZL8M1RRc9tKLPp2F9GQg0MDC8pjv4yKdBf6RaQHmzrB3nrxA3u3Tb/3bHrBpeiMdibV/kyIlpmy4FAYRgWdtlQ+5tCgslHDzMOSoHlfa9dU1swraZe4BxfeirUJZ7bK/nUWxi2S0jyZ9F1v5VkYBUFyo9pXrV200JtlwhQS1X/fLB3x19/DUO39BpMEDmRsYNXh0EjiPEPe0hS6gOqukrpPnTQxdTRsQUiQG3D8B9sjQWX4pV3nuL8xTsDvfA9gIkuPOwsLGLy3NCGBFSeg+ia9tYoAR51m5ubVyVbGovq4zA93+IgI6fiYCJ0YwrjoKWbqfFWSS3bSw8n6E8PA9/L7mcFVvVeLvlymJboQpTbI2j4t3GHxp3WSjkyceqq0MHU9SKRaUulq84qbx5n7iBlg8baknu4lpzBf4qzWraWpJIuFt2bmBp5c5Xwa7K3xno8ztmV3cY+LZP6Mtm/0uDkapOueNvri1Yj6/GOESZxI+vSv3uJoTSU/c79KpRhLTz5vgQxlwXy
 +Sec5rN/
 rNtsvc/YKlhLuhWWJMeQ9SLPS/CZoIIm2F6puA2nzvlo0VK7lNX2yqYF7+BxSie6T/MhjMmxsRWHZ2K4vIVT0Rj4cFHfqjeLXoUKxKqZjnMkmYCIbr9b0dQUwNGHfFM8DQkPXe/Tql0dsnY9HlcOWSvyAZul4q3qx/Forn70Q3iz6egOZGXZAZ8XwinbnIbydidp01OZEDcpDsfxmQUxcS19PJhsPpzbTB8BqQD7lRZmjaFZvMYbBaDgyOWDrCxLMsgSl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

On Fri, 14 Aug 2026 16:47:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> Regarding the alternative superior feature to replace watermarks [1], I
> am very interested in helping you design and/or implement it.

Thank you for starting this discussion.

> 
> To share my context: I am primarily using DAMON_RECLAIM on my personal
> laptop.  During my usage, I found that using the free memory rate
> (MemFree) as the default watermark metric is highly problematic for
> modern Linux environments, because the kernel aggressively uses free
> memory for page cache.

Thank you for sharing your use case!

> Therefore, I compiled a custom kernel that
> supports monitoring the available memory rate (MemAvailable).  Since I
> understand that the current watermark mechanism is not planned for
> long-term extension, I refrained from proposing improvements to it, and
> instead focused on understanding why that direction is limited.
> 
> I am very interested in understanding the design constraints behind
> deprecating watermarks.  From my current perspective, watermarks have
> these drawbacks as a run/stop mechanism:
> 
> - Mismatch between local monitoring and global triggers: When monitoring
>   a specific target (e.g., via VADDR), the scheme's run/stop decision is
>   currently tied to global system watermarks.  It is impossible to
>   determine whether to run/stop the scheme based solely on that specific
>   target's memory usage.  Therefore, the new mechanism might need to
>   allow user-space to pause/resume schemes based on custom, target-aware
>   metrics.
> 
> - Lack of diverse metrics: Watermarks currently lack support for metrics
>   like PSI or inactive/active memory ratio, even though such metrics
>   might be better suited for DAMOS auto-tuning goals.
> 
> However, I realize these features could probably be achieved by simply
> improving the current watermarks.  Most of the drawbacks I can think of
> are basically about "not enough metrics/customizability".
> 
> I assume there is a deeper architectural reason why you consider this
> direction unsuitable for long-term evolution.  If you could share a bit
> about those constraints, I would be able to think about the new
> mechanism in the right direction, rather than approaching it from my own
> assumptions.
> 
> My need for a more accurate trigger metric (like MemAvailable) and
> always-on monitoring is exactly why I want to help build the new
> mechanism.  I prefer to invest my time in the future architecture rather
> than adding features to a mechanism that is about to be deprecated.
> 
> If you are open to this, I would be happy to start by reviewing the
> design direction you have in mind, and then help with implementation or
> testing where it is feasible for me to contribute meaningfully.

I think watermarks is bettert to be deprecated due to following reasons.  First
of all, it stops monitoring.  It means the converged region age and addresses
information is lost.  This is the biggest problem.  Secondly, we already have
similar and better features including DAMOS quotas.  For your DAMON_RECLAIM use
case, I'd suggest using it without watermarks but quota_mem_pressure_us.

Hence I want to deprecate watermarks rather than improving it.  If we need a
better watermarks, I think we should improve/extend alternatives like DAMOS
quotas, or implement a new one.  But, we should first understand why we need a
better watermarks.  You mentioned you want to use DAMOS watermarks with
DAMON_RECLAIM on your laptop.  Could you further share why you want to use
watermarks, and what was the problem?  You mentioned it was problematic due to
page cache, and you implemented memAvailable based watermarks.  Why you use
wateramrks?  How exactly the page cache usage becomes a problem for you?  Has
the memAvaialble based one solved your problem? 

> 
> [1] https://lore.kernel.org/damon/20260808000739.1308-1-sj@kernel.org


Thanks,
SJ

[...]

