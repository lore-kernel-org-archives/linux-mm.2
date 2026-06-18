Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E88CCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61BEF6B008A; Thu, 18 Jun 2026 10:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCE66B008C; Thu, 18 Jun 2026 10:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2EF6B0092; Thu, 18 Jun 2026 10:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26C756B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:34:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FBC8140161
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:34:14 +0000 (UTC)
X-FDA: 84893278428.22.6D6681C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E802140006
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:34:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WxZkEKCV;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781793252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6q94yea7fFNH/J8mh/QoFHRvXIsMnsNC6J4EmqlFMA=;
	b=0inHuS2NiV8sYf97QM4U8Lao/NVeHJQbUndV17oEmMfQ10jmJPd6OWCbfQWZwB8D3q/unS
	aTZy/POMOdWLjH1Ss0o/T9JsTdPZOAIcPAJdSAaVTCiB2PGP3gHNIu7kq9SlnSiaXRCiLB
	L0CmjqG5semAMfePON4Eq6n0PwBxx84=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781793252;
	b=Agu+9gzNdkmAUNU5ednWNXBBygTWicYHtFA0qXPQ+n0bc8fsPMrZGNRnAZAEwtxud+6wGn
	RMxPeD3GFaN1cdrJHOvfLWiaPqyhUBtf8Rw0I4C1kLFCqW48YENUqYfpm6inWTsZfnjyYy
	F4mMLW62hrrAOpPOhkRjTkB8fl99I10=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WxZkEKCV;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67EFD60008;
	Thu, 18 Jun 2026 14:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549E21F000E9;
	Thu, 18 Jun 2026 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781793252;
	bh=E6q94yea7fFNH/J8mh/QoFHRvXIsMnsNC6J4EmqlFMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WxZkEKCVPRjJre7oSFwazwbU+kCx3+Ay0lgV6vHyj1ufAPJjpR7g0hHc/7WmZHVIq
	 X3r84xvjmLmi9pXdwhGhQh3IEIiTJ8GOEvdfpyGJJOc+/XaJYhwrkc1ckr2XzAvmnw
	 Kbdl/kuOJfYmlPUKqHuL12ToiuW4BjEZ9nOKOV8uVh+lH0qfc7i00WWBWKk3X61MJf
	 IoaX073AjCP8SlOXsnlFGxoBe4sgJuMBZccnVdLLz4LDsseBg0HZxvnr2q6UrkXNdi
	 +bmELUJWOi2IR+SQf1wL4/SeNKlJsp/SHF4GBEcgO2N5YIr5vPnoJ24TyjY/kaB6Ml
	 /aOLW+8pr2JZQ==
Date: Thu, 18 Jun 2026 15:34:05 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, richard.weiyang@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Message-ID: <ajQBSh7RvRVr-BmO@lucifer>
References: <CAA1CXcDv7WVxMcGv9OOZDzTzzcfEAnaGbX5dJGwqN5mSWkmRvA@mail.gmail.com>
 <20260618131024.69667-1-lance.yang@linux.dev>
 <CAA1CXcA581SeWTWOz=Kcrw=LW5tshzWyNZMtCnn-X5PrZ0RFVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1CXcA581SeWTWOz=Kcrw=LW5tshzWyNZMtCnn-X5PrZ0RFVg@mail.gmail.com>
X-Rspamd-Queue-Id: E802140006
X-Stat-Signature: 1pymbka9i8mrda8pepkuc4t3b4zhgi95
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781793252-355336
X-HE-Meta: U2FsdGVkX1//Oim5qyjFits61zQD29tHkGMc4DmIIpM9D+TrKEDhcCP4uHjCPj5TAkRcLzHsSvcKbgYYbxSVRRixmInDzZeelq7RgnfJn12JTAN714QvLyAu1f/NioUUO9G85beEUkc1GbSQQxX+Zx1KvoE/BYgqRkRuhD0MQ92UFYRyCDFlMypkccE3MtDhr7ED+YbGMxVdgqthM2nJh+ZXuchlMYMAknTd49iuCE9020SkYCYVm7foBAHcIRj8EIaWf1AaRH6WwlJaYJClvM0tGm64tapmoujmWJtmLEffnSYrR0FnEe+jLOokAu42bYvPd2M2Q3XA4adpH9uXKDTDb+UwOs7mopXJTMtLdyRCrJXC6ywGFGrG5wsnCAiG4gZC3XTLH9xdTGJAi4tYsXgqjXEGCNEKzTVtiYRXwOeutwfFfiYuh13/v8p9bVRaFt9iKm0viZkZHo03lVPPS/AMTo0kFIu3GfJnMgypTJJToGne2VjD2z0mqymkVTxQ1qajeFPuL+cmvxtnMNHcSN3hcwvRWSo97eFmBG6I1lnVdpAamiXobDyBIuHeD/EtgLF0mjpiRnrbF0lHdROJlGtpOj0ncLuQXFzt5O2v41dDgLW6Tf6cgPapDFnb62P1spdPZKe0Ag6OmXL6Clhj+TXVql5H2jUeAdfaH3uKuXORezzy2ikpU5BbX42pQGEoRj4yf+D/oWWYOIw8OrBSAjSB66vCe+zPXBp98OY2K7dRNmsAlH3z/VHPNH3moiV474XvRs9GkyIbBQbrz6DPXaLXD2UVHSzTPlgl0jS+lGpgtvNI8Q/A61c52IShwDUGPn90EdUPXIWxPi4LAaOS1vw3QtxXG9roPhIVvrfEXlCS1qG5b0o+5aj2ytFJIVGd25dPiqO3wvZhzK8/uQWvCgW5O6//JrC2hq9MklRKWj6UTfaxTI/LCQWZj7xexsr7TbRb5NxrTyIJxK3JQ2h
 W8vQHMBD
 r/Tk25s7epV2yS+1F1N9QL42Dl3A1jBF3napum9vHL5OGdIMbnmpvGDmym+AakJOzw2ldq3QQ47q/5ifHWohDP3kA4FIVqqIkia8mKEXyfhEa3jNMrvxR7weV9CWTMicsBkmHbf7KRsKSSYd9ooLeTrIOVlVV1BwqLZK7YbqpGMf1fXZT3QfBGcnpFBjT47DzVQcNSeOXQDhXJ56jqxH+d2zfj1stYHKq42F0+Ml7ZnB1lyvXCVbnCrfsUXK5ZwYi8mwFfz/PVZWmTb0oU54v88koxLRdD+I+8zBYRb29L6BEYKp+zYBGGDKGWiprTNwKVzNU73ik/decduwlnka1tvIql/B7keHVl4in
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 07:19:41AM -0600, Nico Pache wrote:
>
> I have a work-in-progress series to address a number of cleanups, the
> code should be ready at the start of next week. I just want to test
> and verify things first, and it's best not to post at the end of the
> week :)

Woo! Thanks :) Cleanups very welcome.

But yeah best to send on week of -rc1 please. I'm holding off on a pretty
large series myself and we need to get into the habit of treating the merge
window as quiet time.

I think Andrew is not taking anything atm anyway and asking people to
resend in -rc1 anyway.

(There's a debate as to - send early, get early feedback, resend in -rc1
vs. tidal wave in -rc1, but I'm kinda in favour of the tidal wave, as it at
least gives some breathing space. I am very very far behind on review rn :)

Thanks, Lorenzo

