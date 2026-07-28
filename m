Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 472C7C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2679F6B009F; Tue, 28 Jul 2026 16:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219796B00A0; Tue, 28 Jul 2026 16:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F826B00A1; Tue, 28 Jul 2026 16:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E165D6B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:40:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6107C1204F1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:40:20 +0000 (UTC)
X-FDA: 85039353000.29.AC95E47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5365A100007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:40:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1s9EWD24;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iCJ5ibfxCuvMusKlg060KfaWqeHlzZj7o4SsVu/F4c=;
	b=MPpFULyLwHXvqeMI6BPqCZbzn4CTLi6LpzR53Y7d0z3N3+l89c9kl6jWViMHPuheVTvnbX
	fmwsmSn6wE6pQrgri1aOSrwmv7ZJ5u1SzyK/QaE/XtZ++m+IYIMXOHcjE02Tww7RnxpiUu
	Wz/qLuMLi/iM9DYuK60BecrcLp8cJ9k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271218;
	b=IRlJ0bO+LmG+OI50omHH1OZCXM9Ui6KUmFe6OzOBYBCBVlhNY5Yyr9CGcSqMx5q7Jsw1Cl
	8NRTmcx3SbH8fq3hdS9f02C/uIzF6Kw2IBMre9HlLmRO9fGJ7GCpTZpUq00nqyvTcRoNpj
	rfoEPOcvfCQBty+xWMt+7/LHgy3fLwQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1s9EWD24;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBE6140DD3;
	Tue, 28 Jul 2026 20:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0341F000E9;
	Tue, 28 Jul 2026 20:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785271216;
	bh=4iCJ5ibfxCuvMusKlg060KfaWqeHlzZj7o4SsVu/F4c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1s9EWD24ckpU4w+D5abt8/lqV7IpJgNtvl/zlpRAut9kokLsM8eIlniHFuc48CqYd
	 TTcgCoogEme/+zoQnk8tsFTlx7qMQnh4AXiy0nU/xx56PLy9fASrLRGeKCQfFMHQka
	 De/dmJ0kFUxwi7p9q4NryLyTfQLb4tIENH6NIs+o=
Date: Tue, 28 Jul 2026 13:40:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ionut.nechita@windriver.com
Cc: bugzilla-daemon@kernel.org, linux-mm@kvack.org, Mike Rapoport
 <rppt@kernel.org>, Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [Bug 221804] New: WARNING at mm/memblock.c:904
 __free_reserved_area():
 "Cannot free reserved memory because of deferred initialization of the memory map"
 during housekeeping_init() at boot
Message-Id: <20260728134016.674388f101f141362598240f@linux-foundation.org>
In-Reply-To: <bug-221804-27@https.bugzilla.kernel.org/>
References: <bug-221804-27@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5365A100007
X-Stat-Signature: wf87pwsrfb6t6cyfnyytkiqspg1mooq9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785271218-463994
X-HE-Meta: U2FsdGVkX19kLJ/GKchQoNqpggD51nSsNkoqACSwzRMKwVOM0PJwNC93g0THumwzoNREht2VeEd058cW257uGbwUnToyjNclRMVdr+tGXSlm+eyWcXTC4W13Ln/U+NAEcQ/MNTAzKvHWrxRb+zFk2u3WkWKYzTrdC76myAxCSfMGxAU4/+3/trMKD2DdlckKbyuqZ5u92cBweqvTATXgjceFKHmS4XiB6ns4ytHRcgQy2818V1CdmBQzgM30CPfvTJTOPUklW+OUAAu2CZ8OPkkHRGXB29WD6+RiGaBSksM4SxSOzK8YepCadl2xOZoVkh1xwTlYPel8T8NPSVtAQsitnAUDe46uMonITln7kkUB36w6WNCZSeNjLA/P/YEFHNNiouvK1d5cu//Kx+2jVxOc0NlJwwboa7BBmhDBYwkgSttPsc8Xt26ecweTGUQGT7PnQAhGr5BqWc+gb6LjSchDgU95LLb3LI1wMid44yFXVGQJ4h9OG43+fSHN41qIRc6W2TqO+JEbJUiEEr9RX85Fwj4UZ84RXQ9KgoR97JgJC2PyU62gjYR1+C+3Zls6QRUCWrfFSOcX6Yfb9XxsWXT69h7sYWL+KJQYMT1oRNQLw2zmlesCSgtNhleitM9eF0C7sybHMYQREeXjIzKQW3GYfHEtCihCo0OVy+uXuQj65L21JDm9nwCFIxtwOgm/anPIhu1p8/Gt9ISR6efk0KFPXuNc2vQh0AIryWm+P0QyUdXw0BAKEH4vwAeDhEz74OpJfIIfCHw+q8MnvuX86baoldEhQurliXBCijqZrsxnWSqbpTQBEK19PnNQcbCLYj2FEdSRBuo5IjF1BLog/m696Rx6eouFjflDCYC9DscN6ovwYqFtpnfmGNS4joQXP7ygeoDc3L69AJkJIt7VMqiBdrcYql+g1YNNOzqs2CjG/2jqWqqBR0pwshbMaHtyu4aLqLvyPvPVDpOWJGE
 Yjz2bI7e
 4n7v61ap45ZuKAoOg1OfRHZukNj4pV2Lw9kCBc+R5KI0zZlmV9i1wzIue68CYmI0qTYGTjjYaGb7ptt906m5JFi+ugjoVRZh3cFSpbTJPFZ8D5a653vu6KC5Cv4m6NZRQF765hEpXbYFv/s7WzQviXR1iLR5ouH6WhpzU3DuHBgA7fZj0M4UAJICZUrHD2SyTRrIdpDCNvzdx+AFAJM9aS7JCdYWPQNnZXbEngsrxVD4uf1CniqD0TQbwaceUbQyfcYVwC79ynAPEcO4xl4lvNtQE6Legr04Sp0HHFbVpYdKvGZEkc+QiBBLbfJTolWwMY/ztmavdOAWXv2fvgaUwje3xff7LDpNRDUH0SONIkhCJPmMUAca2NFhYpcEO6nE7DGmapHVDLqXf4Wd8L1m+3TIFodoR/AwnOsrwXdSdH/qtcUOrXLwMPXhqtdJuAoYeEDTrjNySUzhu4g99nPEOQ1QFlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 28 Jul 2026 15:52:54 +0000 bugzilla-daemon@kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=221804
> 
>             Bug ID: 221804
>            Summary: WARNING at mm/memblock.c:904 __free_reserved_area():
>                     "Cannot free reserved memory because of deferred
>                     initialization of the memory map" during
>                     housekeeping_init() at boot
>            Product: Memory Management
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: Other
>           Assignee: akpm@linux-foundation.org
>           Reporter: ionut.nechita@windriver.com
>         Regression: No
> 
> Hello Kernel Team,
> 
> I notice this today:
> 
> ...
> [    0.075447] Dynamic Preempt: lazy
> [    0.075489] ------------[ cut here ]------------
> [    0.075490] Cannot free reserved memory because of deferred initialization
> of the memory map

Thanks.  I asked Gemini "what happened here" and the response was
illuminating.

The bottom lines:


The Core Issue: Initialization Order Conflict

  The kernel hit an order-of-operations conflict between memory setup
  and kernel parameter parsing:

  CONFIG_DEFERRED_STRUCT_PAGE_INIT=y delays initializing struct page
  tracking structures for large pools of RAM until secondary CPUs come
  online (to speed up boot times on large systems).

  housekeeping_init() runs very early during start_kernel().  It
  parses CPU isolation/housekeeping flags (isolcpus=, nohz_full=,
  rcu_nocbs=) and allocates temporary cpumask buffers in memblock. 
  Once parsed, it tries to free those temporary buffers back to the
  memory pool using memblock_phys_free().

  The Collision: memblock_phys_free() calls __free_reserved_area(),
  which requires valid struct page mappings.  Because page
  initialization was deferred, __free_reserved_area() detects that the
  target memory's struct page maps aren't ready yet (at time 0.075s,
  whereas deferred init only finished around 0.325s).

As a safeguard, __free_reserved_area() issues a WARN() and refuses to
free the pages.

Fix/Workaround:

  Fix the nohz_full syntax on the command line (e.g.,
  nohz_full=8-55,64-111).

  To eliminate the warning entirely until fixed upstream, boot with
  deferred_init=off as a kernel parameter or disable
  CONFIG_DEFERRED_STRUCT_PAGE_INIT in the kernel build.  Upstream,
  housekeeping_init() should either avoid early memblock freeing or use
  allocations that don't depend on fully initialized page maps.


I don't think this is very high priority.

