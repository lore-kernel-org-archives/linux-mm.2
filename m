Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1005CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7456B0088; Thu, 18 Jun 2026 09:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981766B008A; Thu, 18 Jun 2026 09:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B2F6B008C; Thu, 18 Jun 2026 09:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBFE6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:48:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5CDC14011B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:48:11 +0000 (UTC)
X-FDA: 84893162382.27.979127F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id E011840007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:48:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hDBPkiAL;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781790490;
	b=2mK5WRuvuDLdw5fPBAnUXt3YIlMuEzRjQXyYNMzRAwhTkeNzIoENl3aEyD3NFVnSaJORW0
	mXekq/vqfSbS0vOWt6vMud6ywfcZiHZfl661bS7ku7MAHlPy8ZbT95wH1VJguSvGTYEUEC
	LFolBT+nRBYDf8J2xQGPjQx2wPKTHcM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hDBPkiAL;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781790490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XoqbKVIcU5m2EYrvfB8gunMpgJ7GPNHrFcOOL/XShk=;
	b=2ExyLcp3zD+xJORY4HPxxDBMKREOyH7LTdd4lp7qxTDFMJrEuVE0DzTWpMGUiyFDdAPcFV
	+a+xt60K75tAI8YVVaiAmsqr9PfAwBmG9kwBs5yOal/ynRTg5M+heNM+KmE0A2egI1zzZR
	uJVtEYTxvjeg8kzNiTNYg3JqwkdY6HU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03C3516F8;
	Thu, 18 Jun 2026 06:48:04 -0700 (PDT)
Received: from [10.1.25.219] (XHFQ2J9959-3.cambridge.arm.com [10.1.25.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C96A63F915;
	Thu, 18 Jun 2026 06:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781790488; bh=4+3YH9+OATahnfK6V4DDGPracyWuXKqHO5B9kHTtB+k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hDBPkiAL2u8VTbYCHCj8Av31c5gef+OAcJThQqRjNlf20cUZNt5BoVAu5U09JiYRP
	 q2TDscpDjuJODPCb0KxbMEttDvPKMyn5gHiQSi6xN+ZZlRcdvnm6Qr/yJJLwh+Uv6w
	 neXc2gCyt2w7AESd32PfSu+02EtHqxsUFsqDUaRI=
Message-ID: <dbc2800f-7880-486f-831c-ec9b6cedc005@arm.com>
Date: Thu, 18 Jun 2026 14:48:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
Content-Language: en-GB
To: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, anshuman.khandual@arm.com,
 kaleshsingh@google.com, 21cnbao@gmail.com, david@kernel.org,
 will@kernel.org, catalin.marinas@arm.com
References: <20260612044425.763060-1-dev.jain@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260612044425.763060-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E011840007
X-Stat-Signature: 95hjwu9pmmggiffyt9obnb1jm555pe41
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781790489-418621
X-HE-Meta: U2FsdGVkX198urhjwjj+JTTz7GT8Nq2ZHCxjZrVPS9sT6Y68DtDHQJNH7SCYmL6jE8J09XBJL0tb2EfejZL5whL99XW4+ZJBsVgOzeW2qEr71xD6ZHwOf2+U8hU+t2ZjJiynWXMqb3i2HGF+spxHidZokoNG17k0CsKttZKRbqmDz0tR/KNZ1Yenw3Vs5tRNXncPnBzmW5twMZxReZoJs17dQaX83fj621fCBNK3QLEtFSN6p/cIytucNSIYClAzAY1Tgh3bRreA3GW9tjGPMmRZVRExVILWJX3cCBGjaUESilmTftifC0kATNJxjIYsweFIlN0HmTci9un5qleWQbn2epjEFdy1FnVFab955Oo5n9n6InmC3TJH1soE4UmqAvkqg3mvioagbafVWVUhjGKQmKbP/b/3cSHHit/8t2Uc02Xah2CUkuv8RlWi3CwZN2fjt23fjwmFjflQFn2PL3emPzrcLIzV+nrFWuQvaFjGSJx8w59JEAbJO+Xgfzp0skUVYNuh8i4OMbZDEKIT468gLn4SgoWP7BxADcfj4Zv7GKXEhMsdHD5U+H3EQjJtwnODDGVcW52qVZ4tSJXczsyLfUpzMqiclZt8GIrh4+LaZz20r6gob016fqnix5khMF5z/nyqxbGsT5ishW7cjC73dIBDu3yZ7jMw8gKGxcFosfzskzlGYh22tIHaBEtz66/rl5yb2G+uPfsV0WXdppjr29bMsgcEvETV0rbLiPsw+F0kPvENgSk/qVzF2JN1YWJJAqjvR0HoB/P6dhMJbXr6DeVLLkj74O+ii9fnmRvJ82Ag1yJmrzj6B/aOrmm4gaQwBoUymrqWaqQ7S/IEOQrtkrslTrMznFWP4qa0n6J2DXWJlnesPI9kEbZLFI0mOLEDE1Lk54jj4ibjyVNoMhvlqSIfMgjN3a6dgDMFnxc43AZqk3oybZbmvDyhmCi4H6QBs8XFdkAdz9e1dPm
 rD2z+A1h
 xhPihJDsjYUsav529Pp99jhkgQaILkrxnU1V/ZvBbwtXj23cRmlyQ7n5WPWWk8+GsuQbdloVCOUsFFN+5KFPZ4dA3Q/NKNVJjpXaL5NlIyvXMvfKk0bmSCZYR8SFN77lP0qHZk3OowcyvZwXVE7kFDUzi3uoSnugB3xZomqm4Y79XXbZIr9H15V/hCZ+qs4aHPuLomBe2vD/SkCrbTndxsHS4fISO7cAwxVHw3E0Mx5Js6bFxc2gUZJP5CKmMeTF1SoBWN9QrjeQ2PZnpf92YtasxnzW+wmc8+f660DvLcNX2NACRa5VJ85c+yHbD3fmmERPFx4XYyP2dsm6Ve+lbAaRqDlw9zmeFrVUieVm59oVpwUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/06/2026 05:44, Dev Jain wrote:
> Introduce a boot option to tag only at allocation time of the objects. This
> reduces KASAN MTE overhead, the tradeoff being reduced ability of
> catching bugs.
> 
> Now, when a memory object will be freed, it will retain the random tag it
> had at allocation time. This compromises on catching UAF bugs, till the
> time the object is not reallocated, at which point it will have a new
> random tag.
> 
> Hence, not catching "use-after-free-before-reallocation" and not catching
> "double-free" will be the compromise for reduced KASAN overhead.

Does standard KASAN with HW_TAGS really detect double-free? How does it do that?
I could imagine it testing the tags of memory being freed to see if they are set
to the poison tag, but that would lead to false positives for the GFP_SKIP_KASAN
case, surely?

If I'm right, then the only downgrade this new mode causes is that if
freed-but-not-yet-reallocated memory is accessed via it's dangling pointer, then
that bad access is not detected. I think that would be benign in all the cases I
can think of, so while it would be a problem for a debugging use case, it would
unlikely be a problem for security enforcement?

Thanks,
Ryan


> 
> This is an RFC because we are not clear about the performance benefit.
> 
> Android folks, please help with testing!
> 
> ---
> Applies on Linus master (9716c086c8e8).
> 
> Dev Jain (2):
>   kasan: hw_tags: Use KASAN_PAGE_REDZONE for vmalloc redzoning
>   kasan: hw_tags: Add boot option to elide free time poisoning
> 
>  Documentation/dev-tools/kasan.rst |  4 +++
>  mm/kasan/hw_tags.c                | 45 +++++++++++++++++++++++++++++--
>  mm/kasan/kasan.h                  | 23 +++++++++++++++-
>  3 files changed, 69 insertions(+), 3 deletions(-)
> 


