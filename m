Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6195F1061B1A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF66C6B0096; Mon, 30 Mar 2026 14:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6816B0098; Mon, 30 Mar 2026 14:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B286B0099; Mon, 30 Mar 2026 14:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A00F06B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:56:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FB691B8563
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:56:22 +0000 (UTC)
X-FDA: 84603635004.02.35DD87D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8BF4D40007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:56:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ysBOI21w;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774896980; a=rsa-sha256;
	cv=none;
	b=E9G/eXc5mqalAhot7MIDDJ/Z3jxZQ4cxVNx9cVraZT13iKsZlGuTNtdajzkSBg22MxnaAK
	yTtj0MxPQA2JuLuVUAoN4HprrE0HU3XI0yQsqM2AqERARjppHTMMZ9nQDukyaspQWpdDjy
	2GQOeqvm626JU/UR5wiGqFe23sTOvgk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ysBOI21w;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774896980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTcQbDxFgc1NSGYIiMPFlW+0wV99Pj2wc07/t6/rjB0=;
	b=Eh/t7Y7nL9VxrTXowLbuuH0Q5lS9QLS5nbOwSz4KI0E3nvnQ7x4xXtNWyO/8a+0ev2iV7r
	joqxHNXpzjePwq3NMzS7UZynacBsh6HobYEzthqhMTQSLiJBnrW7TbD6yTnjb8p4mKsMpM
	O5BFQGk6bHqpED8k+Q+/dw3j0p/y5d8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7256241673;
	Mon, 30 Mar 2026 18:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2775FC4CEF7;
	Mon, 30 Mar 2026 18:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774896979;
	bh=59JFEL/6YtbWchuoZOYX4CjEHVV67PqkA6uWzpMcbEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ysBOI21wYxD8GcrME0utq+cQKbiY/9J62YP2177Wdqkv4Zro3jL97Kln2IraAHMIQ
	 SU07hUqLBBLBxMYJ80zFoVkRoLYItJIfEG7EEURAJ59c86VON1R9cCTltAlSJvYyyk
	 n6h84lxLYfOJrd29vIweJRw3JbuPCu8QYNauJNiE=
Date: Mon, 30 Mar 2026 11:56:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, LKML
 <linux-kernel@vger.kernel.org>, lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap
 purge/drain
Message-Id: <20260330115618.62fb0d6bdf89cedd453035d0@linux-foundation.org>
In-Reply-To: <20260330175824.2777270-1-urezki@gmail.com>
References: <20260330175824.2777270-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wtwcosfppwchihf9rbiz4puyzfees6p6
X-Rspamd-Queue-Id: 8BF4D40007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774896980-175334
X-HE-Meta: U2FsdGVkX19O4XrPUSLxQQ9p2rqXHr/RIuhQKG6purWhnoGmeW22X9swrTd3rzSo6LnWftQEz3shIckYTfboEB0dNTYtxw1S7148LOZMEbH3sr/5H58I5zMutNJ8Az+EuZRlG88XBLcWDe8GvkcbSxUhJXpKskZ2xYpG26vbCE7H4FYevXf5uu4YAagurb3goXI1AHbV8O/N16aKarcxoFV9VcqrAj2zTuVW0rWmXYSXL/HGwCAVNF3k95OLnrQwuqRY+ZP9PTQAk1kIB3of/AGNtbJWV1pKsfWTL4RmUid1xrWpiyBkYzHfPDHs+hM2//OHVZQuegxpGCiabC5EUWff7H3N5/ufvhTPRTPyyBhDHKhEhkPCMdH3ELvI5fGKx129DfHAKQEkarx8/aRpzCQogIYITxa0c8tiyhjuaDcbKd6IKEmgW08AVmSc+xUzY3Soj45auH7nETKjOVsyQphatXD9t5vyufKT1GnZNfVzSX3E1RdkccF55Bl0dZSbEBOUXA+5+ubt/jG0lIVaVnyPSzewfQuU5lbKDh9XYwCqhElDD/fkf77qEz3BIZkXPd/SiCg+OpoV30B2fUJEdA8i3Bf9JZiIHrLwOwn9DLO/CUdHqLTkmEaTG+FxvE0IVTGzVl48xqeYY5bCY7whn1KvYUoXzLfW9x85H0rMjSpAt8VPRl+s965oT7kMqGCMwItme8IjA+SgNHvLUYaOK0yGRjMT0Rwh47M9mcCXS73EWhb1MME3lhetQQwrDrWeFSxHo3YWslo1u6w0To05dsbduQlof67a9uo6ePfbg4uuidY+OS+3JtQoydl5/WthLz8FzeQvJSgMCrSxGqnlYT0sliGa3PbrePoMdKGqA+8HdTQn0umjrnE7OQlZR+Efa/OcST00SBHlV1Q5y2sPlGxxEnphwfJslTqP4/GT6dyr+ib18SJIKX8Eg+Q7nLdfR6j6KyxjgzfaGBjz2s2
 oYJQPwoZ
 +mgLFwhezWe3KEMtj9jqqRmvXv1hTmpb6Qnk2BC9k0cNpJZzQmvzLRH+UtugNzr6tMGH+s3JR2ExwazOepCRp7xjiD7Ggg6gEYUK69MmuZk64FZvdGt/lCSY+sxA+LFGJq9o2GeBK5VE/6iPRo49EhJBcej+9ovUXprNu+5qelPuVpOJyi+rNKBTPweT9copQPtBaZf8eEtcOoNb1E8mLDYygDABdNHR9qLixlBnYzENwK1TlWkbaIX+pHLO3cmQWDIRZ2ZNTLmnwBw+79pYUETTUhRh0xqF201C7H1FUFgkBAJAqTZ+NeKAyfL9vvfVkgJRn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 19:58:24 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> The drain_vmap_area_work() function can take >10ms to complete
> when there are many accumulated vmap areas in a system with a
> high CPU count, causing workqueue watchdog warnings when run
> via schedule_work():
> 
> [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> [ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> 
> Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
> run this background task on any available CPU, improving responsiveness.
> Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.
> 
> If queuing work to the dedicated workqueue is not possible(during
> early boot), fall back to processing locally to avoid losing progress.
> 
> Also simplify purge helper scheduling by removing cpumask-based
> iteration in favour to iterating directly over vmap nodes with
> pending work.

Thanks, both.

> Cc: lirongqing <lirongqing@baidu.com>
> Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

We don't want to be scaring our users with kernel warnings.  Do you
think a Fixes: or cc:stable are justified?

And I wonder if that workqueue warning should be WARN_ON_ONCE.  That
would mean that other, later call sites wouldn't get the report, but
we'll still get to hear about those callsites from someone else.


