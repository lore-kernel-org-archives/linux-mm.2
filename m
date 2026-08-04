Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19293C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA286B009D; Tue,  4 Aug 2026 13:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284206B009F; Tue,  4 Aug 2026 13:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B3E6B00A0; Tue,  4 Aug 2026 13:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEC236B009D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:25:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E45548025C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:25:20 +0000 (UTC)
X-FDA: 85064263200.02.55502F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 024DE1C0011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:25:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DA+QLZsF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785864319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfbkrZHohbv+ms0crwrj/8+2o+bdKwPR7cx2njFKBfg=;
	b=fCKplYgGPpizn+kE6jl8EcCs5PJLFF2q6UuP1dTSmn10Q0/URLeACHzuNLNBfJK9I0G4iC
	kEuKbS875YzmJy8snGoPRBJudMQAoR6Ybd3MLxg808KPJpsB9OOEyWuIjfonBvHzUwRuZy
	BgGzmYfNsERul858Xy0X3duFzmPFRbI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DA+QLZsF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785864319;
	b=Fp43AapOjwnenfVXMM96dJ/A775gAea2spQ7xxwAUShsTsg2YERDzCLPYbAiLt1t9J6/to
	SwPIrDGgqZin1JP9gP97iX63dvPQehCP63WmKOHAM/sfnyem/sk1o9CuSfwwOw+IzH+wvi
	i9cJEH0IoWgFF7a0d5z+akAIjp/0a3s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 480B84121B;
	Tue,  4 Aug 2026 17:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEAE1F000E9;
	Tue,  4 Aug 2026 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785864318;
	bh=hfbkrZHohbv+ms0crwrj/8+2o+bdKwPR7cx2njFKBfg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DA+QLZsFO1b3oMEHakbT2Q+8D8aTePXHBYFO/+vHQHQPFBxU0aPqRdGMIW3ih23eZ
	 QT+PU3qEhLCPetMqQp5s3OUHWDUQLFyIJq3X8KRKbQDIgSxP83vYy/a5x1GEYw9/Uo
	 5IoGIfeBjMBcfXYGm6ypldHoiqyiaN44iiJeOvWRKaNGkz8Ma6PpS4CKY4kK0ZYvY8
	 +ZxNwgFLxPJbyPTN4gSbHmmlwjqwGDtu49LWEG9ldEEPhK3N97Cl1u06XirgRYt1tH
	 NAg4tt7qin33Y0HrskEoKXQwPbp0akGkHKGllwAnmtmMlF7iCpP3k6JeoCIQ+h2LoP
	 FB5bZAIarXoyw==
Message-ID: <c89d1843-e06e-4b8b-bf86-5b0debf489c9@kernel.org>
Date: Tue, 4 Aug 2026 19:25:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
 <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
 <73d28cff-77f5-4cd6-888e-5dce5ebae459@kernel.org> <am7NCCxeg3BsoYSa@dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <am7NCCxeg3BsoYSa@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 024DE1C0011
X-Stat-Signature: p7o1u17945tgzi5cwt4gq47tsxz9rykc
X-Rspam-User: 
X-HE-Tag: 1785864318-166257
X-HE-Meta: U2FsdGVkX1/LYphMyK5VJt49kK+3TsTaE2iBlELA8rDo6PQJw2NvXEtqwRff0GeGZOROvrC9S9jdGSB1JTk6Ay1lcrLmFbVehCBQHnevKsQCi1ZTzekwsovR3YD8iaKwikc2DSC7IqA8e3aJQvw/osXb+rD3B5ehf/k9TqHg13UGCTHprTbFE0cigY9p2nX63pP/0XHwJScxbclOIGOHLsyd/Br5B56J3SRDwSTegZ3GxbgpKm7eFMRWQtEwtW2nt22P9FXuRt/PvuwIpRhMCzF3FDSRXGiqP6qC3EzPndX7cHWVxchyJYIxqoVJBxCGE3H12HPM7Chyc+SHTU0zLkq2qMcGETYdcPMyt6OWkrVnZNrXNk3psKBbqCcq/CfRVgEgrmf0Qn/FLyC3CRzMWimZ2z8iTT0g6msLQBQ6j15JuP6kaGwKSXKcfmc2pg9gGuO3a5D6SCTwspS5x2JhSEBcXmjzV4GMxUBNj3+n3gf/4kw7gfbBmkt67COWEGsi0JUePxDUlV5s4f4bkxta952qtehXJ5pR9UAqkwaa4X/T/T5lTgwpchr1W6DnW6FbSYPq2BzQu0FcaH4bGnRXS0KXjSuorZYUAGnwt3F1ZjssMWYAGJQ1+2NyXJNiphAmui5Zl9mHYJIx4I/lKfvVAdbRu3Ri2cHtu08UgTThkOre3xH7R3Fb+V0qixVRXfPqhqnoOSIQbnlXEYKlL4ObQ4py9t7jF2K4u8LrxcUB3OPeK9q3QmAGxPvMFnExLbFvJI94mzZaY7LWsPRtzkjcOEinAh21j8EyhgUXFLEWV/8dR0srJF30SBeYdYagj41Brj2S84FR/gJ5MTYDdUQ4QMaXJmcEMmxWSAsXM2opBZ/CZr4osDL/ZqgZMgCmihLiJhGo5NeS7t6eH0LA6eP2PNIuxLdWYT7Y37gVqKjPdfK6+Pie7gxIDIWCm4egA9PNLhR5mDXG490T/6KXWS7
 VxFI9tzG
 QAr+eW2z28SSONA7I6jZeiSkE/7sIbRrEFkHTeLr4h4XAsCvu6M8vt3AVrf5rDxDkiIZIRv2q5IkybNpzduQ6E1px/+0vuAxZADDlJsjlq5u+Kn1/ndZYHvmrgAsz8/wFJoq7IekzHYXV563NyK21TsDYWsQ7wpWWu0U0oefRTBjZumaOnR45xvwx72+oH1UwtRbpzHQI3BxFHqdIjGJn5vAYxMJB+EmwKyeuBfU6AXqi2I8pClh74XyZMnRJ7W0ekBhYkzmmV9hBR+mmNkglgzyaLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/26 07:13, Harry Yoo wrote:
> On Thu, Jul 30, 2026 at 04:15:26PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 7/27/26 07:27, Harry Yoo wrote:
>> > 
>> > 
>> > On 7/25/26 10:28 PM, Alexey Dobriyan wrote:
>> >> Sysfs "ctor" file prints offset/length of the cache's ctor function
>> >> 
>> >> 	$ sudo cat /sys/kernel/slab/bdev_cache/ctor
>> >> 	init_once+0x0/0x10
>> >> 
>> >> This is not useful:
>> >> 
>> >> Offset will always be 0 because ctor is a function.
>> >> 
>> >> I'm not sure what ctor function size is doing here, it should be in
>> >> /proc/kallsyms
>> >> 
>> >> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>> >> ---
>> > 
>> > I'm not convinced that changing this (without strong justification)
>> > after exposing it to sysfs for 10+ years is worth the trouble.
>> 
>> Agreed. It's a pity this was exported in the first place. I can't see a
>> benefit for anyone knowing what the function is called. Should have been at
>> most a flag whether there's ctor or not.
> 
> Agreed.
> 
>> But possibly a justification is not to leak the function size, which might
>> be theoretically (although unlikely) a hint to some attack.
> 
> ...but you need to be the owner (root) to read this :P 
> 
>> Well at least if somebody complains about getting broken, it's trivial to
>> revert and we can hear about their usecase.
> 
> If we were to experiment with this, we'll change it to print a flag
> rather than the ctor's name, right?

Yep, let's try that. Alexey?

>> In-tree tools (slabinfo etc) were checked to work properly?
> 
> Looks like it doesn't read ctor at all.
> 
> Commit a87615b8f9e2 ("SLUB: slabinfo upgrade") added -o/--ops option
> that should "Display of ctor / dtor etc.", but it reads "ops" attribute
> that has never existed? Bit puzzled.

Might have been stale code from some previous revisions that included dtor.

>> >>  mm/slub.c |    2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >> 
>> >> --- a/mm/slub.c
>> >> +++ b/mm/slub.c
>> >> @@ -9149,7 +9149,7 @@ static ssize_t ctor_show(struct kmem_cache *s, char *buf)
>> >>  {
>> >>  	if (!s->ctor)
>> >>  		return 0;
>> >> -	return sysfs_emit(buf, "%pS\n", s->ctor);
>> >> +	return sysfs_emit(buf, "%ps\n", s->ctor);
>> >>  }
>> >>  SLAB_ATTR_RO(ctor);
> 


