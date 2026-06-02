Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE7BCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD086B0408; Tue,  2 Jun 2026 03:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2597D6B040A; Tue,  2 Jun 2026 03:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148CE6B040C; Tue,  2 Jun 2026 03:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00AD86B0408
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:16:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9A60162BCB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:16:31 +0000 (UTC)
X-FDA: 84834114582.07.9C239FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CED1480006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:16:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+W2wLPV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780384589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUNbZYbt9aI1mcjTwuR9tZLk6dg4eovk1Fkh3D9nCH8=;
	b=SqkhOP1laBc6aLBp5wpEXI4dEmcAtq6n4/XMsNWklL457LsIsKvr0NZ1NEbG+xDthQ3402
	GodBbkFaw8ij/gCzQouIrJPU1lF85pMqXMsqW2eokHDgLslpFEasLJzmmQrG/sGMIiOo4Q
	jVIAAzBXnTeUbKRsO7/gICvg6dHRv4I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N+W2wLPV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780384589;
	b=eiIaOD/JxZ4u3GXOmY5Jufrd+jW4alX3L0bWhKEeLQODXaG3S6BMmTtCjBJWsay7JK8VMm
	7dylXqTIzVho7YvFClwvri6wDp7gE04K+EUfe2QkhryxaqKRUbGmlWTSBMPv+l9+Ehgrv9
	UoCZ8thysKQ4e9c5cDP4/DrqyL+TA9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E14AE42A0F;
	Tue,  2 Jun 2026 07:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F011F00898;
	Tue,  2 Jun 2026 07:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780384588;
	bh=cUNbZYbt9aI1mcjTwuR9tZLk6dg4eovk1Fkh3D9nCH8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N+W2wLPVXpHphVHfpDvXlLwOzwIHKEOpSQNJYGgyaMi3txVRj3uPMsrh8FZG4M5y3
	 gysbcy2bu/9T+X+KuzD6fbjLDOOqdJmXXbexEez/EOTH8aExgtDMt2Aenl3vAxPKV8
	 rjcV+uM+jBZ+hU5nd0Wa3Rn8625buOpguXzBbmhwqn2pP/4v9Lnix8GQIfg6gLIVCA
	 HdxwaIPe1CTjPCjzjgOZ0KJMupg24vtMPk56M/bg5OqynOyZE2dqd45km+qUUvpTMu
	 U++QLyWUQvDfdB6zJwiU4gk6qw9N0AcxAKsJCqt97DJIaeQwKc02jMa/+3XiLSXScG
	 mHuats6hLJKhQ==
Message-ID: <536ea40b-8501-4a81-84c7-de5f12f4eaf3@kernel.org>
Date: Tue, 2 Jun 2026 09:16:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
Content-Language: en-US
To: Kaitao Cheng <kaitao.cheng@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Dennis Zhou <dennis@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org,
 tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan> <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
 <ahrm4x2ubbjs4An1@palisades.local>
 <e315d2a9-5069-4a8d-a0b5-7c0033ee46ba@linux.dev> <ah2pD468y1LCIe3G@tiehlicka>
 <7e913ba8-fa91-4916-a871-66de7c80cd29@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <7e913ba8-fa91-4916-a871-66de7c80cd29@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fpwh5ip7ciotmusw4cnp5j7gyaeicqie
X-Rspamd-Queue-Id: CED1480006
X-HE-Tag: 1780384589-995054
X-HE-Meta: U2FsdGVkX19Vbas4urIM74X9kB0xgPfR+iI440mbdFh8XJVbuRZfaZHf7oil3Qh8A7voByW5auypWL1uaCQ3Lyb80t6Ln9p9kL43G7td5FUoSOv6H7P2eLXP3nuut1XtR2eYGynTCxlWOE3mt/Z7+U3muW26GBq/BfVQk/OB5Je3Wd3CjEVcTzTUGV7fsCSL53XNcdkuCGTiRE8yuQdtSDIWp/osvzbTqQQQ5GGBq+s9EnRF9Wv8GlgVKsRHAHRAb2PT839xu/xWLJLdR0o5NsL4fnXekQVdRm1AOX96XyMZTNVuOgH82e2q5I1pt+QpHCmhNif7cPNGUrRdM232IJPH1HMBClVQTsBECUYl1M/PVwQ1VxZt04XPDjw37hPflwpgvtnwHZbXw5/crn3igo0FwexG8WmI4ttMTCLcgOMH+GaAFMLRfGOCIVkLfYOxAVf/iMV2COMQzjnNkeR+w8MsN+UbsTp98gMI1imJWwa2aLOGpODuG8ZLCQBqkIwAQJ0aw9hHgvNWt/pr4JUy0bIE68RNiK+FiqmcyW23PG4mGh4tXSHwGjysyCnTbgaUg6g5Q8vTMc0yFLMCpW9ZQbxLXANtzbg8XFEHKVJKpw1wEEborVZU9xQSA6JyAxEzx1S7NqT6/4gOg+rvtJ9TYzgeouQZbT6mwrv9iwp87fwRWjFoC0bNSmHlW8rptVYvzBGGEwHE1GqLHuKXepEB4U0Sr3Ygr2p5KLJ4CXkDVaPwBeYV16HLQKSPEwkVhTzz45cW8LewxI7Aujjy4/MWSGlVvLmPPWwM8oYETdCpuEXZJSOVZ4ebdESz/nqdrKaLI98BBXySg3FOSR9wfQ9xcSpPZbbStzQEtG20zBM2i5bdNUjdpps9rq79Cml+hyqjjfp7pfbOfB5YGkazMixByiXuYKP6xxtxDwjzvKD1fPx4KzeZYyv70rNizziIZUeodUzJsaeEDp1KGO82VX+
 JRSSfhi0
 OMtR173YQlnhyQmrJnXu6GxKu6pYznD63RZtA5FtDIvcUVKX2d4ZijmOE/7EY6B3xO1YL5F2OPQnNNfB3jj3YGQVNcClQHtg6Vi6IdW+WU2Oey/GvbKzq3Bv4IFfkaALl6h3LLic/exzo9AFWS3RgAvfE/KP3pvEbtld067yAX4Vx24FpDCf12ptsMwCkXuK7jksSksYlLjXw6Rr3DCJZyU+ZzgR7IlsKmhPPD2tdVc1+USp1LZqpSISLjXRHLXkNrcrkkwqZ0Q2q8jCKLKg4VqH3bDb7llHZ3XR7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 05:03, Kaitao Cheng wrote:
> 
> 
> 在 2026/6/1 23:45, Michal Hocko 写道:
>> On Mon 01-06-26 10:27:53, Kaitao Cheng wrote:
>>> However, if we revert 9a5b183941b, it seems that all of these issues would
>>> be resolved. The only downside is that the failure rate of pcpu_alloc_noprof()
>>> allocations may increase, which might be acceptable.
>> 
>> That has practical impact on some versions of iscsid which do not have
>> PR_SET_IO_FLUSHER. And maybe some more so I would rather not revert
>> based on a theoretical concerns which I believe is the case here. 
>> 
> 
> Based on the previous discussion, I think we have a way to address most
> of the concurrency issues around percpu allocation.
> 
> However, there still seems to be one remaining case that I do not yet
> have a good way to solve. For example:
> 
> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
> pcpu_alloc_mutex. Since the internal allocation is not constrained by
> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
> creating a dependency like:
> 
> pcpu_alloc_mutex -> fs_reclaim -> FS lock
> At the same time, Thread B may already hold an FS lock and then call
> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
> pcpu_alloc_mutex and block, creating the reverse dependency:
> 
> FS lock -> pcpu_alloc_mutex
> This can still form a potential deadlock cycle.
> 
> Does anyone have a good suggestion for how to handle this remaining case?
> Or should we simply treat all GFP_KERNEL/GFP_NOFS allocation behavior in
> pcpu_alloc_noprof() as GFP_NOIO?
> 
> If there is no clear solution for now, would it be acceptable to first
> fix some of the issues introduced by commit 9a5b183941b, and leave this
> remaining case as a pre-existing historical issue to be handled separately
> later?

We don't need to solve any issues that are only theoretical and based on
scenarios that nobody sane should be doing, i.e. Pedro already pointed out
"As in no reclaim path should be insane^W daring enough to do pcpu allocations?"

If anyone would (start to) do that, we would likely have lockdep reports
from the testing bots, which warn that the scenario can now exist, even
before it results in an actual deadlock.

Elsewhere Pedro said "The proper way of fixing this would probably be to
release pcpu_alloc_mutex (or not have it in the first place!) while you're
allocating memory."

Such a refactoring might be worth it (if it's feasible to do cleanly and
doesn't come with downsides) just to eliminate these lock dependencies
properly for good. Patching over individual theoretical issues is IMHO not
worth it.

