Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2710F3D333
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 17:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BD26B0095; Thu,  5 Mar 2026 12:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33F06B0098; Thu,  5 Mar 2026 12:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F7E6B0099; Thu,  5 Mar 2026 12:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B377E6B0095
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:00:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 463F4B71F1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:00:30 +0000 (UTC)
X-FDA: 84512623020.20.C926096
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 752D720005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:00:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RQssEgH8;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772730028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7L9WMZrysHkxwDYzDVNsG7LX3C8tfUQuYICosEZ/lbU=;
	b=2fc3h2WseP3VT1ezqA8dJbUUFmLU2+ODfHv8tyyy1+NdPYsPdN8Kwjb6e3jQ3qQ6asSCb7
	FjMZZRhm87/x4Thoy1K13J0inPUUy3SRYuQR/WAIs062Lt5y706Y7IaqFom8+pCJ6XrGfT
	72Wk0RCUDtMiC4q838jQhthZfrU2YqY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RQssEgH8;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772730028; a=rsa-sha256;
	cv=none;
	b=yd0MZC60+P69pThHl28rPaA/aFXG9ibgVpbCoIbQOmtC0FiyRrQeSfZFz+3aPNoNLGhJbx
	6LWxpUZS6+7L8g9K1YVWEOdKoU3UeoSENxBeGO/xEMpiTzo7y9i9k37uD1rBiCsX5k3cLc
	HPD+H3X2YQQBp36997872rtpcHQWF1I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C55566012A;
	Thu,  5 Mar 2026 17:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4096C19425;
	Thu,  5 Mar 2026 17:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772730027;
	bh=wVuwwz894wfgjy7vW04hBybNjmsE0AR/YULz5STkqXw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RQssEgH8hHQ3F/Ij4GfslTLOAzgu+xn6hYeL9SpJucaJaSHmY1jEL+79ubRLV7ZCr
	 aoe1Wd3i+Bu6YSVO/DLLVwlPCTvhE6hWNQ6QXQkiae72t9I57cR5szMQ/FBfG6ZOzz
	 7QOEImnHtsA5QS26mTMHd+IVG4oVgUyTHq3ZHyLY03MJSbvEteZj36hKV33jPux70w
	 umYqOq3cy+mZinIEm6MkPN89bzt7SXR97PTEPla5zgf6W7SJVjxjSwBciWe9QZZaVZ
	 i6I6QrALvC1h+UUurDWi29Z4irEHTdD5K5woaSGqbWrVpSctRm4WZra9k6xPJuCQ8S
	 gBRunH7f/sbhA==
Message-ID: <a8907468-d7e9-4727-af28-66d905093230@kernel.org>
Date: Thu, 5 Mar 2026 18:00:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Huiwen He <hehuiwen@kylinos.cn>, Jerome Marchand <jmarchan@redhat.com>,
 Qing Wang <wangqing7171@gmail.com>, Shengming Hu <hu.shengming@zte.com.cn>,
 Linux-MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>
References: <20260305103941.11f1b27d@gandalf.local.home>
 <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 752D720005
X-Stat-Signature: ykckwyatd8r3wu1pytxthtaujtqe9wos
X-Rspam-User: 
X-HE-Tag: 1772730028-105642
X-HE-Meta: U2FsdGVkX18gn84s9I3/badFMw8QttYM8sIjToCTUFmTTfLbHLTXY6cq/jG1cAHkgf62N9tI/knSpmrjScPCRn0HsGpYIuFWNgQ67ExA5chGiDoyG3zq7FarGVNXJHAFba1c3CICEddsDQ7FMZlcN11SJPhBywZfoOG5Zf4b+5jsxFenYU1BJX9BvHBs9pkHZgrhwS6+EC+YnDdPqSvemEnyoqKsUulxwXdFkcwpUTGguE3b/jxyxqhlbMvOAJqQlwR10CCVqNEc7+Nwk8IOznjxtwz1kJ6GdvZMTx/HH+C+G0fmdUejhw/a4GlJkzK/sLEYObg14kjFTPvTGwffbQ0Ia+Sa7j4elUDQoBl27urlT7sMwGZZSz48h5Nklgnz0bnPjXRtLs3rjU3rjVV2SvxYJ4aXQcr5OYeOv43rD3zanh6jhDZHQ6vhbmMctDj8a1DKywzfUAuPBbxvFtmpfua0b0PuZ7A6DMVChN+5vxCknvtmZvlU28Tz1PzoUNFg1g9LqJ3bJ7jf0rN07zjPLUzthq2xp3N50PYME+Rao8wb95Aiv/bYwKrDU2RUkXhD5lj1GPZwCMqrhLQOO8Q1SX959W/iwjHgG0qlPYlXB3cOIm2N/8bM1Q7Mlrm2SYgDScS/que9HHJ4ZqN74tqM0uAJbikEvn9e9TnBwje48b6LLkuOIiEi8IhkNQFd4tCx+Q5zCrzYJ11kF5OABdc6wJK2gomJpwJ6FOxSSOcjVSmQltHCjH2ZWOvj0Jyj6ZJ4uTtMibxbtATY0mh7Tjm/JaWGda2mjI9xwAvu/vRQzbpPtrElWRDee3eMwDjnExohYF6+9wljnWplQG7XlgQXyD5E5X1vtynO8esG8+Mlvq+w4fvq5BkDyizqhDlNBCbmf87ZAXMiaDordwYJ5cB8yf2+xid1vCOa+aK8z6pdguTYUC/XQH5ZtKT4v/SOyKCdXpHKqK2sprr8qeHl6U5
 fHyXI2rY
 G/zzYdkPOIbRS6/c/BcipyuVxkfz4LYIsczD18LD0av/veY2Tm5bMP2ZYe47H4JFBgFVXI2y8rPfKYZW/IHo4qmesxED497zZVsi7nMJokOdGRYV8EkFvUEb4Bs/e9mtvqmBjf+1//OTf6VM3akMunh2AmSaG6fPOs9zax29j+XAqAEr2H4PI09npMgKVyXXXjLOMvzJXOqrGQfREXOeJaHpu/O3MIz6CIPff/gXiEH3HlhfzUedCQU7H6RzkiS/DrytXOpdC2AQhdJfO7ObdwdJ/8JAQxthSaokQ6FtWm4uyLDpc4NTTguBt1pn7zEWk3XV8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 17:44, Linus Torvalds wrote:
> [ Adding linux-mm and the rdma people ]
> 
> On Thu, 5 Mar 2026 at 07:39, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> - Fix accounting of the memory mapped ring buffer on fork
>>
>>   Memory mapping the ftrace ring buffer sets the vm_flags to DONTCOPY. But
>>   this does not prevent the application from calling madvise(MADVISE_DOFORK).
> 
> I wonder how many other things have this assumption.
> 
> Now, many (most?) of the VM_DONTCOPY users set VM_IO too, because the
> most common reason they don't want to be copied is that it's a special
> mapping.
> 
> And then madvise() does nothing.
> 
> But I also get the feeling that the whole *reason* for MADV_DOFORK
> existing in the first place simply doesn't exist any more.
> 
> It was added two decades ago when as a hack for the rdma people who
> wanted to mix fork (with COW) and concurrent DMA, which just didn't
> work reliably because the COW would break either way.

Yes.

> 
> See commit f822566165dd ("[PATCH] madvise MADV_DONTFORK/MADV_DOFORK").
> 
> And that should just not be an issue any more thanks to how it's now
> done with page pinning rather than with the old GUP interfaces.
> 

There are still weird cases with O_DIRECT and concurrent fork, where we
don't use FOLL_PIN just yet (I know, I know, ... all shaky).

QEMU traditionally sets MADV_DONTFORK on guest RAM. One reason is to
speed up fork(), because it doesn't need all the guest RAM in fork'ed
child processes.

> So while I've pulled the tracing fix, I get the feeling that people
> should at least think about just making MADV_{DO,DONT}FORK go away.
> 
> Now, Debian code search does show some users (libfabric, libibverbs),
> and maybe they actually want the forking behavior for other reasons
> too.
> 

I suspect we cannot get rid of it that easily. But ...

> But I get the feeling that maybe we should at least limit MADV_DOFORK
> only to the case where the *source* of the DONTFORK was the user, not
> some kernel mapping.
... that makes sense. Forbid toggling it on something that has
VM_SPECIAL set, maybe.

Or at least forbid re-enabling it for such mappings.

-- 
Cheers,

David

