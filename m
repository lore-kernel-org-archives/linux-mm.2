Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD8BCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AE26B800A; Fri, 22 Aug 2025 14:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432848E009D; Fri, 22 Aug 2025 14:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A876B800A; Fri, 22 Aug 2025 14:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 260978E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:26:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2F23583A2
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:26:48 +0000 (UTC)
X-FDA: 83805224496.09.D99BEA2
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf09.hostedemail.com (Postfix) with ESMTP id DBBD3140003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:26:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755887206; a=rsa-sha256;
	cv=none;
	b=XJNw6U8gNlWrQlNxDu3A8fYuVONS8SePLy9lMiSQjZg1ZKl2zbLD8xvfMXglkAVWER3bQ9
	66EsCmR4LvvM1/def8Kj+iSQbmcLPPdguqwzBpCI3VbaCWBF0impUZd85taR9fMxceo+mh
	faEJgIuFOvUgd0dw+XqtQUxbDZpRW/0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755887206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Scrpg9qTQ5EIvKqqpHuBJQRkHz9Mbbchdf8twG8T0XU=;
	b=VkrtOrJNy7pUK6zSvIJiiRyocBuhWmJNPgV4LSMX7TxUEbb3w8d9wDFqjkdW4jssTnfmU8
	kHrRp30MC+1svGktMm327FfZ3/52nCpA+/CgbxyiOBgbLEBZAnZ2BtB+anBdX4y5YO+FB7
	VwCflCR8RKuxoo+UtcA0Xpf3ZDXdSFM=
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC684819ED;
	Fri, 22 Aug 2025 18:26:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id C440231;
	Fri, 22 Aug 2025 18:26:43 +0000 (UTC)
Date: Fri, 22 Aug 2025 14:26:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Li <chrisl@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, YoungJun Park
 <youngjun.park@lge.com>, ksummit@lists.linux.dev, gunho.lee@lge.com,
 taejoon.song@lge.com, linux-mm@kvack.org, David Hildenbrand
 <david@redhat.com>
Subject: Re: [TECH TOPIC] Per-cgroup Swap Device Control
Message-ID: <20250822142650.572507ff@gandalf.local.home>
In-Reply-To: <CACePvbUYp7w68C8z_TeMhOJQ0hmWw1jkwy+D_Lb+N5WbmufAug@mail.gmail.com>
References: <aKgm+wisMipLqnL4@yjaykim-PowerEdge-T330>
	<aKihqI8PWLFL1b5i@casper.infradead.org>
	<20250822131022.4df59a60@gandalf.local.home>
	<aKisJJYL9LV20qzg@casper.infradead.org>
	<CACePvbUYp7w68C8z_TeMhOJQ0hmWw1jkwy+D_Lb+N5WbmufAug@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19qApwMrh7stjceUbbTYGOhEuvVEc9W+D0=
X-HE-Meta: U2FsdGVkX18C6W5l/ocCnOU79zFmh36vZY7+wfTLac660UKzn13RzukaFrddo4l44BiOL+UWqAxbmdGL9fRRLeuWhUKHha6eFN9MU6taVE4q9Sq8QwcGuAZ64bi6hu2YpGTjAnWpES1ewABidgMmUjgtlXxUELGR62hBkXt9fwTQRzT3q0BpPfDVjCpxqbjK1cGCWf3x8SCEe4IVsYb2ziylmyzH/sxMTjxJHg7nCJ220wjShgTb5kEmbxMh7Kzmivcm5u8fABxWILQsSxzv2rsd311ZIUv1hw3zOB/8MsSMDnLHSUvg700JGAFZ72dqkrTp2s2dARstE3zbkrX8rFzDwpPmovPhuGKfFICgs58ZZUEjiG/u4rhA9HwxrvLUI/pLpUTFAQumhEULY7nEkryE7nGCnETyIxOogG0pWC3PWYEhsZEjGQ==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DBBD3140003
X-Stat-Signature: w48wfyqhd6b68pd3568aew8eknfxz6ni
X-HE-Tag-Orig: 1755887203-398458
X-Rspam-User: 
X-HE-Tag: 1755887206-656689
X-HE-Meta: U2FsdGVkX1/BpKLvcHYWsWCIGO2fGI9oJ0PRWnXG+50CQWZlt0kYWmprfIM3ushWkYY0ev5BEDd/2K+vCzsQjD4u+cGn+doFHpXiJ0GxRtAIWoEwW3DULAKwzL0hBCAMPd8tKf2TC8Mt4M2WL0/78TyIE5KUvU4QDFM6mIHprrP7RL3egfucd82ZMkY69L54c2kaTWUc3nq5B9D0LxucBCk7lci6D2/AmRGu3+rww3fWA0B+3mFanOIlo1B1aCiL0ehod+M3KtXpEg+Yk6KTPBtxwQqEwsc49jvOyhDvG8/AzhFaWmbnoyBsbfJeirBn8JbfBhYmBDu4fUgIYHRKxhY6znzLpKoHhwH3RSjt3DhIicTYOTFe8mnE+zUHRMVWwqg+tX4SH94oqRJ7/yDj0uPT3v/tibQ9ysc+3dUghVxtmCc74zSBWHFf3NY7rfHtoEARiLA4JC8EKVqcjoRejjwaYrKns1W1kNN2/46RS0Rukk/bdQQ7yjZFlR/554l4IouZKq1ctCD7xr4BfEmdxc3KMd7BvxeS4XuNjlka/cm+/kAYrFKInz5v8IleqkQNLoCSmPMmBnO6ubcsxI/mdKAcUOQlRbQUHB+cijUYHmT0LoU7iHXPpEEchhELEG7vwsyTJz5Na4MoGmGmF/pfTjJN199V4cNngz6bCRYFhdvrblPZ2b+DsedUJkd1B0hNF95jGoKfQCwlUrx7IDEJ9iGvWRO9FoYYJEusXWfFesDcNNV+IlHSkr48AIHK8FcPhAA99GUPQ5f95keX+++GibAfXbeHsNKQO3eiJ+ScQ1cTLWuvzpUQ4ebHN01pd51oBcZ9h+JtTJOmmJj1xcUDijiHbsKHzZ2EClC4GhmQ42F+q8ZNTPN0Y8cRtAOvXrq8MvOFTqwfE84+RN8WJ91qu3JebWmpVuVRwM0rtNLi2u19s2Ylh0C1cDlwpw0c5c3GgD6UH/Fkj8yAOcU0BRY
 8Fanznfd
 bUhzzU9QWIqbqKqsFs/xJPereLj7XwS02Iqlo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 11:13:41 -0700
Chris Li <chrisl@kernel.org> wrote:

> Anyway, is there any conflict to apply to LPC MM Micro Conference
> track as well? Of course which conference to apply to is a decision
> for YoungJun to make. I am just curious what options are available
> now.

Note that MC topics are more discussion focused than either the Refereed or
Kernel Summit tracks. A MC topic is between 15 to 30 minutes which does not
give much time for presentations. A Track topic is longer and allows more
presentation of the topic. Also, acceptance to a Track talk gives a pass to
Plumbers, whereas acceptance to an MC topic does not guarantee one.

> 
> Hi, YoungJun,
> 
> If you decide to apply for LPC MM MC track as well, don't forget to
> register yourself as a speaker on the LPC website.
> https://lpc.events/event/19/abstracts/
> The lower right of the page, there is a button "Submit a new abstract",
> Click on that to start the process. Don't forget to select the pull
> down menu MM Micro conference.

The part I left out of Ted's email was:

   Secondly, please create a topic at the Linux Plumbers Conference
   proposal submission site and target it to the Kernel Summit track:

        https://lpc.events/event/19/abstracts

   Please do both steps.  I'll try to notice if someone forgets one or the
   other, but your chances of making sure your proposal gets the necessary
   attention and consideration are maximized by submitting both to the
   mailing list and the web site.


So YoungJun has already signed up to the website and proposed a Kernel
Summit track. It can be switched over to a MM MC topic by editing the
submitted abstract and switch the Track over to:

  "Kernel Memory Management MC"

-- Steve

