Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B56CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D896B04C6; Mon,  1 Jun 2026 16:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9C46B04C7; Mon,  1 Jun 2026 16:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8BF6B04C8; Mon,  1 Jun 2026 16:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8D906B04C6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:44:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69CFF91777
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:44:31 +0000 (UTC)
X-FDA: 84832521942.01.6086BC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89337A001C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:44:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hrrMw5Xx;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780346669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1Ita4ALRIwbUma+e/SouNp6V9HdLIRsvnqj4QVKvVc=;
	b=MAY0jadyNdPX8uSfQDWKdVdpkqWlbxx2xD2j3n2CRtvIh+Q690uwZ9DHFMX8vqDNgp6ggy
	KtadQb95w+8lt/rNFz7Smg4YyyMVECPDzIeKJL7o37FLoz7rM+G8tMBxVjElxnA7yZ8SkX
	S0D2bUgrhAB5IAd1bhVyarPviWvNcSM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hrrMw5Xx;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780346669;
	b=H+5AfIo2Aqhpmmt+MN0YXRR0R874qFv1IT1zJCCt52lHS9L/vWtliVsGEf7Ck+f7Zqv6rq
	WbbOHH2OAtByPqPgH44VpYhzcmuiz02GUFQsVppv91sW4VZpKMj48ovrU+i0VhyMUhIa/9
	HJphTXGU9Y/LVcJyylfzY2g//VKWlZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08D70600AA;
	Mon,  1 Jun 2026 20:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6858A1F00893;
	Mon,  1 Jun 2026 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780346668;
	bh=x1Ita4ALRIwbUma+e/SouNp6V9HdLIRsvnqj4QVKvVc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hrrMw5Xx9njrDfRhxz8cA2HudadDAyZ/Tq/XTLaaWnSpxkbH7q96Xak4yU+QSv52M
	 QAPXFegY6c4cYCJjYPzFdkmx1oksfr/gs4pKXzc6kLSZdy54qt58pLrhha3ANm+XnO
	 Lc/OdZmlpzwyZ//IdLHBeaiJf88jBAyJH073AIi8=
Date: Mon, 1 Jun 2026 13:44:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/compaction: guard move_freelist_head() against
 invalid freepage
Message-Id: <20260601134427.dda82558dfb2da579d66cbb0@linux-foundation.org>
In-Reply-To: <20260601133941.111989-2-giorgitchankvetadze1997@gmail.com>
References: <20260601133941.111989-2-giorgitchankvetadze1997@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 89337A001C
X-Rspam-User: 
X-Stat-Signature: 6ojaa5eicu7kspxm9iug5eapps5o1r4p
X-Rspamd-Server: rspam09
X-HE-Tag: 1780346669-366202
X-HE-Meta: U2FsdGVkX1+u5/BS3HiBrtnTelaBSOKIHxFulEegua4evJ0y9ke9XTcnh6R0dimQv0Yyp4r4R1T42D6Jb0Gqj5GYp7wGoNQu5x4yIZJzZTyXvOZmDlRwYZaBu3nL2Ife1QHwBqunPfnlmwTqBR+hucAQee0LBb1V8XOqq/kKtrqVTefVb2tNu1iWR3wLeS6SP2hml3+Uvdyd9UzACXK5oipbI3ozWEOQy/inz2xM0vygaFEtgNjPGCZr0RT1xtbCcPDSgtbJwnJQTmcHAAJE/JZYu15dHW9IgGoTNNdFanSNhgzrpJxw30xPUaq4fHVzqerseipM8ctbfrrdsH81bm4OtDqCtqPdBJ/FqU8XK5+1ZZuaGZNFhS/HY14NrdR/4Fe4LHY6V8A9x2b7dc5sABzfVh/fKRVFe6POIaUXd1p6nbbF3cWX2/oSD5p6HI5ooCkte8oWvKg0zSvxdJe4Xr8poe3VcoYRyva1Brx70CJwLmTmwqB9wN95DlLTU2hNwgiC/ywaEanwEik3aMoT6k3wXdb7gMxOYL3fsmJXfZWZ4dEwfUGHVya3yMEQqjGBqlF+CLc/aGxkejiUL5bdNZjKdCdnhGZP5n3zgZiT79H5jYiFXQTN4V4zjkC9ZUIPyfqKN6Bm5Uh1IBaqGn9PAA//d+CkgRJX7aISUHXxWRSIlHRg2gEp8vVJEdiW/yQKJlcwcCRD3rjT0qZn2FCX9DXUOMkHK+fu4xLrytN+YjAYR/2THC81tASTvtJ7jSySBfSKX4k+Q1jTjslqlPDy0XKOIUilPcsicjvG/AzAizxUOBW6inKZp2QEDwzTq1puShUBUDjU5hk429FN3PPC1RU7FBn22dfLHeIf85PC0AJI3GMOlasl/A1vzhN+xfjWm22tdDpxToZecc61tKSGu3F416KBl5JSqMMGmJdiOHW1bTiqLDU1PWap0LIKSoYzmFJlaYP1j09r2LOaP+0
 k74ROE/b
 o918g668uC0E5rSASsn2aHWWDcKned6vlmmUYBJKGkPYiBUJRCcbiMuNvg79w/4EnMrYlSUvUNmQ8j298LE1lPvOltPkkNJVTyQtCiWrHkZlkfaP6Qzw4hPd3mcqHMx/C7+71K9iC6zXu+AMsVOZuZec/h6eDyu+gDqZSkO3otAFKrRksSSMY24RHmPXU+NkKd2V+0ms5wpD22mmqe+jLiDKNib8WVGyH/Ja0AIzCTN1SAVKexRqkO7H3A058+wbHnORFtGcDvqkqe95AxO73ipXbPCUG8F85BB9oc+Qc5NRvWwMERhe3mx0Uow730Al+OHueSrZxl0FZlqQunP2U2jgGlijuE7uwmTpZNgni6iqX3BNdyXV0IpDo4l5l6j2woAX5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 17:39:42 +0400 Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com> wrote:

> In fast_isolate_freepages(), freepage is declared uninitialized and
> is only assigned a valid page pointer if list_for_each_entry_reverse
> exits via break. If the loop runs to completion (all pages in the
> freelist have pfn < min_pfn), freepage holds the list head sentinel
> and high_pfn remains zero, so the high_pfn fallback does not update
> it either.
> 
> The subsequent unconditional call to move_freelist_head(freelist,
> freepage) then passes the sentinel as a page pointer, which is
> invalid.
> 
> Guard move_freelist_head() inside the existing 'if (page)' block
> where freepage is guaranteed to refer to a real page.

Seems correct from my reading.  That code is rather twisty.

> This issue was identified via Coccinelle (use_after_iter.cocci).

But AI review is worried:
	https://sashiko.dev/#/patchset/20260601133941.111989-2-giorgitchankvetadze1997@gmail.com



