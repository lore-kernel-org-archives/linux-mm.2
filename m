Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D6EBCD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0826B02C8; Fri,  8 May 2026 20:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77526B02C9; Fri,  8 May 2026 20:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87436B02CA; Fri,  8 May 2026 20:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 932C06B02C8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:12:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3808A1602FC
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:12:55 +0000 (UTC)
X-FDA: 84745955910.03.105480E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6E33B18000B
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:12:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=G3D+otWk;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778285573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vMn+do4h7pbO9YVH8tdQgKOPLC/r9DzJcrrDEJfZlvM=;
	b=Q9BvzpmyrWNVpNaPB9X+Inc7wLAHnoC8FnvKu3qyIfLhJhZBabgcKOQVhfLspm4V3Q3K4H
	8BQvYIE0PCvZFvtqcC3xEi/DK7p8DIZtjs/HAb9o9nunztAFn2H32Erh+k9g819d8WPiNd
	lMiSTFxr8gjf4R6e3srYL1cZirfIa6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778285573; a=rsa-sha256;
	cv=none;
	b=SgjrMEZ8U02rAAcNNLMewXpfHY4JnUkMDEGM53JCPSHZ6SKAJT4C2vUVKyp8WRLHkAPkCu
	eO/yCsJKiuq8eiDsTKpphFCEsA17nsYRSm59Ys1SDBIes6LpBrkFBR/4Oy6SiRFlA7nSr6
	7FBUlOPjUiI+eKsQLjnddqTUdgltYwU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=G3D+otWk;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73CA642AFC;
	Sat,  9 May 2026 00:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D500C2BCB0;
	Sat,  9 May 2026 00:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778285572;
	bh=Y0PS00zVL4JN6wHBq10JZ6+2omlC70GREkX6WSUksig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=G3D+otWkjpEuuOmYB9k6qKoX2/m1kh+SDQ8/IJ4U6pOo/FlflrGKj1i/87XmCGiCi
	 lNqFQbBPR3mFs4hcxoCtX+7UxGvD5eReymZcVnxZVx5vfNUjrZeXu+jImmVMJT6Jql
	 t6SsS16mOv/q7wbqnJSgjlnRBfKu7qHH3rIueFC4=
Date: Fri, 8 May 2026 17:12:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/alloc_tag: replace fixed-size early PFN array
 with dynamic linked list
Message-Id: <20260508171251.9bfb5e833859090d4480e222@linux-foundation.org>
In-Reply-To: <20260506022256.32664-1-hao.ge@linux.dev>
References: <20260506022256.32664-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E33B18000B
X-Rspam-User: 
X-Stat-Signature: spc1nrgf6nxiqhd6srdfja3879o1gqqc
X-HE-Tag: 1778285573-917363
X-HE-Meta: U2FsdGVkX1/bcy3e4ridc9YFKVceOTTqF4zhhwVbWigTzf5ao48kr+UIwT9VNrNCwi2eYAV4mEKNMaqSc83vZnpFxFR/KjLrjd6Q0kiRlPiUnJUCQ95PEBDegG7vitDg4Cz2Stbor9tdPiTkKCYxbr9bKjEzo+hc3C2G0yCA/KoYVWF+k4GDBAB/lnBqAsmY3lFJeuhrB9mJerZb6pijUQELq0RcQADthOey3dmUk2HvKYwL4n31fVsR1tctD09AY7fUI+qmuZ6roXShqHoHtZJvmvowsRZcDZqH1qicvZTr2XhQA2bEtLHcs+dg2rBrqH9iLWTXTyo/Wo/Lae1EJy2viKTb+3ZSjIPRaVxBqHC8qJR/NYgVUwzWrJ5UjFEHka3nvs59ECgHjIlBYK52f6v08dqYfJSE0Zlqxg6PUIgP+cY2MScLX7xZX2icyQigMSd96wHrGMDssf4XTTc13cEHjzJ2vKDc78QVQMflrjf8wATY5j4+S68/BPZ9S8LfEZ/OlcdizXvKUjc0YqslVNbbkIWHJ4Z3dXrd3qo0TVgwsMZnPbNzYcHRO2B82edpVxM7YiGmvLdPC6jvffH/5VEJKJD1zEoCxuyrJK0nzk7+9RiGux7L4wfWpb9BjVXB4e7DhJvY5m+ToJRtDm5zwzNgZZplZcMw4X7oP51+pHjUI2JO8Syh50hsrl7pVS8MGkeHmAgNpMafBzOk7uKdog68VDIgLN/e+Sq9OCycsqXHDIhWsV+Y5/iWF6r4QIoBbxMpj3i70vY9Af7tXKAk2MTvV0eR0j7d121mzkHqG3RMVbXpcRRqrUDqdjJQF2PvCudu7TYmUY3Ixv3FLfJcK4dAfZaskC3fIwYnKiW/p4a+SZXuuZn08vROcafGiGOI5M5xzVDBWqeuDm9Gc7AH7nIyp22fLf0mlhXpT4W75WTo7hHt7Js0uWt/hL8TY9VeDAFEy68cKZEIQzlG/5I
 TasmTa+6
 ZcGupHCDJl/zOpHlx0+D45U+osFEf9xFBEoY7Wfy4vq1ETUXvC/7uAhobmNaClBeWMRu+sRqF0neA/LMMt00BrMsP72sFwR0emhiWTOq51Hxl8nSQW1e5WNCDhRXQUTwhVHqfOyrh73EJbozqDgbII+P1dAaXdTph85hOH8EXwwmJXK31T/22MEdeBlSWx1fAeFmpUEbxcIv6julEXMfq8aNpGmq9qKOiyS9IKeoNXL6yEpySZi2VjcXVftkNsF0xkCMUcJD8a9NzwiEug4XFHHG0O4STQjlUft4+fSOAWjKoJWvCTL1suCNABLGStF056GJD4qNcfAaQWcWTOKnjjKZnbpZo15+gWI+9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 May 2026 10:22:56 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> Pages allocated before page_ext is available have their codetag left
> uninitialized. Track these early PFNs and clear their codetag in
> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> warnings when they are freed later.
> 
> Currently a fixed-size array of 8192 entries is used, with a warning if
> the limit is exceeded. However, the number of early allocations depends
> on the number of CPUs and can be larger than 8192.
> 
> Replace the fixed-size array with a dynamically allocated linked list
> of pfn_pool structs. Each node is allocated via alloc_page() and mapped
> to a pfn_pool containing a next pointer, an atomic slot counter, and a
> PFN array that fills the remainder of the page.
> 
> The tracking pages themselves are allocated via alloc_page(), which
> would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
> recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
> %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
> so that the early path can skip recording allocations that carry this
> flag.

AI review asked a couple of things.  I have a feeling we saw at least
one of these, so probably already dealt with.
	https://sashiko.dev/#/patchset/20260506022256.32664-1-hao.ge@linux.dev

