Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56076CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D836B0005; Thu, 28 May 2026 03:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5657F6B0088; Thu, 28 May 2026 03:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2B76B008A; Thu, 28 May 2026 03:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7946B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:54:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1014C27BB
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:54:14 +0000 (UTC)
X-FDA: 84816065628.09.64D5088
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 12E4E40002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:54:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VMjrDY9P;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779954853; a=rsa-sha256;
	cv=none;
	b=Sx4ZFz78P2NYGAwgM5tP/upo+EekLrfVq0vQEtERlCMFQ59MwgxQhtWzOi/rnpASR1ZRD7
	2MPlGLMeRHtFUYKxacmP7VTqPGNy9fLw5UpwMltOM1LtBItbjTA/l7FGvw5EZpkO24/pf2
	MUITj4ucTnaTLYOFDx1NSwImlT5cCJM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VMjrDY9P;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779954853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXyX/vSlotir1MvkerBIJgI1i61yQB1gKf3by/+LUNM=;
	b=vK0ucl5ApWOwzW1NED/mYY93QatFQ1jWyutjL8o5k/T1peHvkDq8ai+QXdaRt1JWz0xIjF
	i0bmCznGrhEdmx5tcnW1HzHbTPNDs1xGqAUXdlq4VQ6medVrnLCifaujkSJrASpNTIY8CJ
	N3JIsd/sPzJPGZGhg0xNvwa1HvigBu8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C393439A6;
	Thu, 28 May 2026 07:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9356E1F000E9;
	Thu, 28 May 2026 07:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779954852;
	bh=DXyX/vSlotir1MvkerBIJgI1i61yQB1gKf3by/+LUNM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VMjrDY9Pl3stXYQe+Hx8eLna86X/Ey4PyiJtR5xorT1OA8XptvPgr3Kq85FgSVgNh
	 XR5ZRMbBKfKNps0UVTzXEY41Ic+sODBxgi/xjj9tPCy+Ql2pHaWWCgA/L/SIkQY6n/
	 rUyS+sJi7qt+Lcj/pLTsdZQRxS3LbGoiTQsXMd/KzNA1MBtfs30uncfKm54xfbyX5S
	 Z3uKgxF21zys8QvrAUiNCE3/eibp0rmcLMiUVLuVLOlhQaO6XWudf3wGznREbnm86m
	 fCv+Tq/bLgD8uIQB/KRD09em28nvvNanynmcl6DzZrTHJ18DJ4H4zz3/fAErmSlw9s
	 uMQJeq3+ON0SA==
Message-ID: <146b3bdf-0219-4eae-a569-6ffb3d5ea400@kernel.org>
Date: Thu, 28 May 2026 09:54:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempool: use static key for boot-time debug enablement
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 lirongqing <lirongqing@baidu.com>, Usama Arif <usama.arif@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260527104634.2434-1-lirongqing@baidu.com>
 <20260527130656.a448e84a30dc44617b51b45a@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260527130656.a448e84a30dc44617b51b45a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12E4E40002
X-Stat-Signature: nfzq8wtfguan9nsmhjpz86xmn4di6761
X-HE-Tag: 1779954852-383192
X-HE-Meta: U2FsdGVkX1/uszshf6y+vlVjIvGQL3MudishawGXpY/cb6s55ErNjng9o8Zr+HUo06HFTpRKrGlsy9kaK8w5a9ZLcI/TARfuGdvWKPab0QBr7urjjXY1DI+v8EZeanxc9UJhUo2cBOUY8+FsxskaBqIzrZEWeT4hoggYjoekx20Lf92hE5M0t2UDL7eUwPORD9Of7sc9WvRczemFW/w96G7xcZQJeXD2UUzZt0XRT+0wzqBaHtlW5Wh/FGCEy4qlxpEpdTooChjjTJYNOTEkY1qm2NGsNmxC10WYzGYtr24U57ZPVmTGujVmJfiWhuRTZK3Qym3z88WbNlwAOAbBsWJ1bmmgLexEptaeLOf8hMXwRaGvGwDgpFF8jx1ledag3OrKB/hdJa45qFaVbBsTWZ/uHg/G2x+HGcNChekwelm2kf8hLEYF9MwexcAoun9UEm6WvIY6C8MV/SKXM5tmNGhQrz230eBZJEj8bx/166SuupFGzOPLHjtxfSzdEpE1nOQICW7lgo9GWsv+xWHLj30kMBI2/37fuSOp1fKQupDGEjKZWrXWa4hANUuPHSwbnpHrJdB793A3xDd4ol3jPFw5rwruFCeL0NaWKETE39mTy6wSOZXIzTHr4D3vajQGb+WIQiq7hRx7MauJL5d2caT/ub3pNbvAmUr9ld6Bt3LOSbRx6QSNe7Z8sG49bv4FOWqWi/QQeQJHycQdjJuuVkdpl7mJdm7J9Cepqh6Qum9ccJcGlja27TLQzT+cBhf0Xcwwad5Px/dQtyizFVbmF578SrtHElIEpei3p4R4IZr6mvzktVsbk5FnswrnAEv04iSZk7ZvPHc+mTiVZBBgG6hfyPxwRzn3lrynbwbxcSt3nqh/uJRRAOQ/qs11m0MukvQ0DPzoXJ5pVnjjqzZzvlNZnIN8VeGANTg8IuLpZFdvBmw8yM/f1MI6AZsbY/wuyWYFUvDuTQIPAh11mNf
 DZZ22M9h
 /T0oLcVQR1Q2IPkuPODDYMDA6Nc+qsWopxkNurz4vLRzQ4kTBUxZ3KbNRnnrTg7vQcHJbywTIiyW+/b4JHbPxvgQ/rtd1vuTf6wlLiGylMvdMqrv7XOl9z67YLBauQHhpfC8bAVRERRht8dmJUFBAz9Cq5HPg11BjWkoNFF4GhEri1s6EDPRWcXZXpLVYUjvfLBYomDJ92mECwjdqTim62CRsN8vUc4ompLMLp6A5vuJ36V9DUhjSGnGHVGB/3BBdPA3h3Eo+Maaa7qaDFWYZVEtWedfYqIE5xkPwnuZP6CVYWp1e5uCIyQYkDLDl7W7tx8Acca5LGpDaWlNGz2BZhxRUaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 22:06, Andrew Morton wrote:
> On Wed, 27 May 2026 06:46:34 -0400 lirongqing <lirongqing@baidu.com> wrote:
> 
>> Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with a
>> static key (mempool_debug_enabled). This allows enabling mempool debugging
>> at boot time via:
>> 
>>     mempool_debug
>> 
>> Instead of requiring CONFIG_SLUB_DEBUG_ON at compile time. Benefits:
> 
> Sashiko is suggesting that we use mempool_debug=<...> here.  Which permits
> mempool_debug=n if for some reason the kernel is defaulting to "on".  Which
> we might choose to do in the future.   I think that's a little better - do others agree?

Yeah we could do that. But I still think "CONFIG_SLUB_DEBUG_ON" isn't what
should cause mempool_debug to default to "on". It can be revisited once
there's a solid argument why default on would be needed.

> Same goes for the new dmapool_debug.

Ack.

> Sashiko asked a second question:
> 	https://sashiko.dev/#/patchset/20260527104634.2434-1-lirongqing@baidu.com

Seems the same thing as Usama raised about static key init ordering.

