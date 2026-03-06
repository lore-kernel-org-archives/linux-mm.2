Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39C0FCC056
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 18:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29D86B0096; Fri,  6 Mar 2026 13:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7726B0098; Fri,  6 Mar 2026 13:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9476B0099; Fri,  6 Mar 2026 13:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCFD56B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:25:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5495E16064B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:25:05 +0000 (UTC)
X-FDA: 84516464970.18.216D517
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8CBA640006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:25:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfK5QBJ7;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772821503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pV7WHaJGDa1IFAIeltnCF1PS/BAuwPgVK8PONG7Ltg=;
	b=Vcbq3lwtVjgZd8xXkyN65+IQ75UP8IjrlqbPvfARIg1NifQc4AQTz3j/be/Xv7YLfZ9C7U
	VP0KJZEoqhTw3dgBMqqWmfyh7hozc5XA7m8N3o8eYecN/jA728rtfl/rLDN1MtqRBzBBLP
	ytcqTcEC5XR8uAl82Agvv+PqQ33QYVc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772821503; a=rsa-sha256;
	cv=none;
	b=pyq2wWqb+NmVU+Z2LIOIH0TymCMTKNNArB6bu8hXdPDrHQhjpRxasxzsA6ezUn0TjnWCTu
	VqQ/Vs1vKG/AvPTvBki1MXRE2Q/rb9+pixSTbe3GMwmtSwQrQ0t9cGaykp/03h9oui1kqn
	AUfZ6cWXz7yAkhX3Fc/FdvA2Q7MdR/k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfK5QBJ7;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5902A43AD0;
	Fri,  6 Mar 2026 18:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F1DC4CEF7;
	Fri,  6 Mar 2026 18:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772821502;
	bh=1uq9z4/ibsX1WTmZECq30MMk5X7c41BLu0dsdJbzLvE=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=tfK5QBJ7Ly5+nGF8m5oRBcOsYY4YQPlgbMZyXPT/Sy5R9XEvdzb/Yt00+6n+K1QAj
	 arfzxw5dLDkTzgho+/gGrOaS35/5cO7ue4p0Zyer0FIgDGBfe9NMaB7xQJGmCQjWQr
	 DdrS12z4fGzB588aXtYgq/Re3WU1aKw+ZKwzNbHvxrPslEhKbRMNaw7/jazbhEI029
	 00PVOU5NUzS/ZcusgWmGELcVY3bbB0I+JazrgyqybGM5lksJAhuCac9RUGe5yBjyUV
	 C1rF6N2m8eD4waahoa0jqEKoEjSNfMzBhZYVchJEPelKuO46cEMTPqMTG1eUeZZrSV
	 IPgDlRrvDBYLw==
Message-ID: <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
Date: Fri, 6 Mar 2026 19:24:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
To: Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Peter Zijlstra <peterz@infradead.org>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
Content-Language: en-US
In-Reply-To: <20260306130052.7da8eab3@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: smjxpbnamue7hxbgnwrkm7p8jbfbkfr6
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CBA640006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772821503-792450
X-HE-Meta: U2FsdGVkX19sSrv3mpqNufF+cWqtddYoYndd/7oS7rUKzGmDsneyXerJ/BB800IbnH2YuGpSF3uSPBV1aAJgCoAiEJpUXITnk4gqIP5Z89oY7vagN7u8d4bnv2z29K0Qpl5NAi1cHdIV2BdO/IruAviOr+7JputMjia3uV2J01feR3vv8EeBu2vkjfa6SaG56prX+r35j+GUsRTr9/e4wLxue3Z/RFd6ZaRUv/Wl8xRQKs9IKrPWdppjiiM/nN3tRHhn0Mib494R+Wf2kMpZxoTG8Uku0uVTOqfuNMexny06lfmqyBbH1B6/RRyiiVFJLMG222quhbvixAPbcUI2eoFY200NpRauvaPQVhAiBV6G93amJncl6WoViCNR2me56/peUseLq5ORPS4qvyNbi8TN114INR7B20wtd8qWktE1qRf3A2nzjz7+EHZ6dJIsdUADkv2Tef6GYpl2++DGEWx3GMHrqkxTMTKY8aWliU4qdrkdAxWdAVfrCb88K6JZ3q3iI6jozxLm6TlJnQSVswxQ7o0cVQ4gF8HtYdIa2WpK0/Dl3Qgr4orgXYJDGeKIS9vD+frtbbZOMhG7Fhu8mw3oQK5w785/LLfCocMNkApMnd6RCgJLRp7v9To0xwVfly6q1kyVNsFGmFWxFHYgZYhewZEuzR/SaBpa3RkxRauzm9VcFN2nfdFmmFl8UN77Q0QrER22I0M/VhMMRuAbKs2upE93W7ZQzniAn7EO+trVS7lSdQbbdFAkADkqINgb/FvKyDMKXoW3kcGQR0B4ULqYVGWbk15o1Sad/H44UOBacm2EfCC3maZsZTs31PedlN+qscmL0d/lN4ahnnWRcvYUoyakyYLgyPjJKZNwISzU6H8CSLNUxEVu1osXH3bi/2tqdIMMsnifhb33YJobLH44ugLTiPSChpiYaGUUqjlpy0ahEtk80aJDGI6LMhiioG+8vbi84ozNZl1Azvl
 5fYWiHDd
 Gu21VINy4aiwWbbE4/Ys2RZMO6wMj9KgfsilgY+0my+E1hS2WzqcWZYAAGjvgAL+W+lQwHYJfHREV4cp+VSpbFjbfUuUa3jRIUq8C/ODPX/fiQD8/im+RgVmc3lNLONsspgYCdTIs8Z56xR3nhUtl2y2MralBARtVRZfPyvbxHxVyYcnC0gsrWlmFdApTPmGhWNglfcpdxTVPxxmeQme4ZLw+4Y1sBcQblRmC+itoIXzc0qTqlBrMSShaeBov8Lc3tNoJiSMIS0+u3GPSwAGGNPumK4c6s2ULqd6yOHtHqWFhH3xpNo+7BISw8rQAVSq6/jSwQk8j94lNM33xSUiD7Txp/Ids1xZ22JEKK4ao7kDbokc4plaxD4eYqQM/VYqM7xICn4bj0U7vXSfonDCg56wGbrXEQVwCnRUR5LAU0PiQY/zB2bWXTbejS4g7kttLDwgR3gvjYDt/taUhxqlPxee8rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 19:00, Steven Rostedt wrote:
> 
> [ Adding Peter ]
> 
> On Fri, 6 Mar 2026 09:53:36 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Fri,  6 Mar 2026 16:05:35 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
>> 
>> > Use the newly introduced zone_lock_irqsave lock guard in
>> > reserve_highatomic_pageblock() to replace the explicit lock/unlock and
>> > goto out_unlock pattern with automatic scope-based cleanup.
>> > 
>> > ...
>> >
>> > -	zone_lock_irqsave(zone, flags);
>> > +	guard(zone_lock_irqsave)(zone);  
>> 
>> guard() is cute, but this patch adds a little overhead - defconfig
>> page_alloc.o text increases by 32 bytes, presumably all in
>> reserve_highatomic_pageblock().  More instructions, larger cache
>> footprint.

I get this:

Function                                     old     new   delta
get_page_from_freelist                      6389    6452     +63

>> So we're adding a little overhead to every user's Linux machine for all
>> time.  In return for which the developers get a little convenience and
>> maintainability.
> 
> I think maintainability is of importance. Is there any measurable slowdown?
> Or are we only worried about the text size increase?
> 
>> 
>> Is it worth it?
> 
> This is being done all over the kernel. Perhaps we should look at ways to
> make the generic infrastructure more performant?

Yeah I don't think the guard construct in this case should be doing anything
here that wouldn't allow the compiler to compile to the exactly same result
as before? Either there's some problem with the infra, or we're just victim
of compiler heuristics. In both cases imho worth looking into rather than
rejecting the construct.

> -- Steve


