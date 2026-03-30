Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C941061B1B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B776B008C; Mon, 30 Mar 2026 15:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4E76B0095; Mon, 30 Mar 2026 15:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8F76B0096; Mon, 30 Mar 2026 15:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9624D6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B9A814047E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:16:28 +0000 (UTC)
X-FDA: 84603685656.29.4F8E295
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C0ADD2000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:16:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="wNT35w/v";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774898186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BmKqMFPxOMui3FOF0MKai4rthaBCuKHznDj4Nw7m2A=;
	b=hrlsZT+6SXKqMAe7fAXqwkvRK7Mok3uQ4RD5mSNxCGMNvxZDbIlCebrfxMMlhcSAjXgOJK
	FYQrmYkeHtzMDV/j1eoNuQ3dgRnZAjnIwwQl78MjWw380P6uJ4y8pqRIcP1iFgRHSnQLfp
	bwmR6/o5tayXLUHMGjKcY/ei31V336Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774898186; a=rsa-sha256;
	cv=none;
	b=3R1iDhhAuiHwCyA566Np7YWrZXXdSGsafgjVhOrjKSlP3seiwl+nqWgEppsVNZVptE/Z13
	BzfTG3Rehq4E037uI49lpPA2FJy/SEZDA6Y+nw6aJYihM/PAOWThVKKeu1XD+uW8cOAxJ8
	YCiwhucuKqfNCGtGk4aT7grApWTh+1Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="wNT35w/v";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A13060126;
	Mon, 30 Mar 2026 19:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9871C4CEF7;
	Mon, 30 Mar 2026 19:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898185;
	bh=oXQolb1yAb0DgfmX0q35ABD3ZFnm55kI9pf0oMncHE8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wNT35w/vw8xWsD/40fdXn5qc9f0rBOKnU6X48i8mSooOyOfijeLu3kEYts46pIyKe
	 ei6FPh3502BrQiCMZOvAc7esofUiL4PysrOwbE1Qw4vhTO24C2li4kwdUnNSzkRC1r
	 taTbKOXEtY28t2ZBhhL+VepThvLN2OnPxzQSIpEI=
Date: Mon, 30 Mar 2026 12:16:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Baoquan He <bhe@redhat.com>, LKML
 <linux-kernel@vger.kernel.org>, lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap
 purge/drain
Message-Id: <20260330121625.c69f46a63c86c9540b823398@linux-foundation.org>
In-Reply-To: <20260330175824.2777270-1-urezki@gmail.com>
References: <20260330175824.2777270-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C0ADD2000B
X-Stat-Signature: bwfhbs7ph7ze4cji4pcyg865nt9tr4s4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774898186-169355
X-HE-Meta: U2FsdGVkX1+/j5hb+DCYLB+Icd1BwFrTCvb/T6VRTwrHhxMppr5FTnZW2V+mInxrTqYVgWf95twsLjmMTqxZmGw3eoErRu30CM8Rm2uBT9D9ZMwy8WoQhCpLCxJWaf6qb9TmbeM3I/OCqS4Z6ouQK/R3Y6ygpB1t2+njm0CpYgkfHxRJf9WHRJh34sYauUQMtVsJSRwY7S6RMtosDLiEFs6WjL4vEsl81GTVY61flu7N1heItIN9OCyu723rbuAdIjHnmI/Ml0eOjZuuFhabMZtLn/yj9IFo44MT7ca1jHEhcYM6o0PzOyikqydrzHjTNAe8QOkgAVjl3j0fJZ3QeU0cV/IyWg1/SRnkgpzZnrw477Uhszc5OSiMRCRDejytpbqCs0E4DpNR9W0Ml994E2y0LQX0v9Q7Y6+efXVeqqXD/VEvpMe+D7pHZQw/yVkLG9tl7nYhZo36+EA8gRQtSn5mGKUdpwpQfCKyJ6v07+pVtk4WubNY+8LK6jUewc6QwSSdjPb8WKDZfsvwVcJx7mgOW0k0lwLinF10DiVMgwYcVdWmMoO4DcWg8LKo6KlnlKcI0FB/lmNY7rWAmsKbGHvbhEEg+lDhqbWPGjhFA55/XeDf97Vxn44WfhsZ+JnymvyahaZwoZkpzpQlI7b5PoLSvEuJqnqitBe6unC8MLSlUEECSobNSv7DyxprzgQKCZX2zQ2cw0DEGTpnpKq5rwTzfPcGxzOBoAQNpPI0iUvsWkl7vVkmqmWuReq7xU0nCgIEVE0pmlK2lN7hCSS2dg3g6T9E9n8IAaEqYr/Wm4INnaw6HIYhor8MGCjSDer3eRHzt68efD2oCQttW1WdvS+AzOiVTgv2VvTht+lOVE/5lFyej5FMUqv8qEl5Y12ET/pzj+WNoV1XtF7DxZ4Ziu7lvPsOeZ5hmdCGFA5hsu0d8hV5SBa2AQUBZcDptgM9U1w84WSHDsFme4OCKr8
 NtlkQjug
 a881d9aLxNOH5jIzWGYGCzZUTxwlOMDBFQ2tqxHod5NHeTzS3kYzbY//p1JmBr1rkljwm47rdsCN0YKWzrW3wEjy0HI/WYMPls87IYhtw+26+BVYPvOUkvurKPCpfJjnrVNfkGKSvY4Nc5FxV/nl6kHbEtu2J1BzNt8LLX8lp5hYdaBtmZFD+u0xhhYHKMI6CLaUr9U6DOKKX8Cv2xYXHr+RYnwPcPwNQRzfjSAv4aX100EfLa59qs5ubQeda7PjtHa4fE2i/50Utgo829FlG6s2Ti/vAxBy7YW8CznHyxtrL9nAbaB5dHNHB8JMTNmyhGBP6xmW15xtlpDg=
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

Thanks.  AI review flagged a couple of possible issues.  Do they look
real to you?
	https://sashiko.dev/#/patchset/20260330175824.2777270-1-urezki@gmail.com

