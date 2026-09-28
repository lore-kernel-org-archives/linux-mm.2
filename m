Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E4DCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A5E6B0088; Mon, 28 Sep 2026 17:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADBBD6B008A; Mon, 28 Sep 2026 17:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1FB6B008C; Mon, 28 Sep 2026 17:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 805136B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:23:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 198761A02C9
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:23:42 +0000 (UTC)
X-FDA: 85264447884.21.9E14C7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5E3BF2000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:23:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tympz9vR;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790630620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPXcX47PeB1/G6r5SAEJKfY/PNsjCyhNbzJxA3X7IOI=;
	b=QB/aylAxYHPhrB/cWfjqDCanKSno96tD5IKar+rxKfryDJ7bw73IedHP4jHB7Gn9kCFR6i
	4S9Y9BxDoz5jaqu79hmJS0QvTVhNLUdMuPoTx9RjHwd7EPXUmpIWPVc1goTQ8mUUVt33rP
	6fEAcpLQ81cieTJPzt14ZwUTxBqv0bY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tympz9vR;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790630620;
	b=RiUUk9a0eMqBSAEcCyxYsVrRTjHAdh5+XUsJgLzfP2n2Hn/pJtlI1aSfDwvF+h0ggqZXuA
	NssTdzVjxzUoHFfB17ZPev4VYDF6iyeF8YvVSBS0ZddUSwTupl7QAaE2fk5j/s6JseNTwg
	4bG8zb3RcUWRpEDlJIvkuX5o28qmXr4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAABA6021C;
	Mon, 28 Sep 2026 21:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4128B1F000FF;
	Mon, 28 Sep 2026 21:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790630619;
	bh=KPXcX47PeB1/G6r5SAEJKfY/PNsjCyhNbzJxA3X7IOI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tympz9vREG90jSuR1uLWwOYu5BU59FiLtaT5xoUSBjDXz70SZGi1X5GKxqotL2I7N
	 JyTEFv6nN0POCW9XSg1uw4XQ3HCvIO4sVyB8lGUdU/6AaOM5MRzbJs7crXu3hHdAfn
	 0EuL7q7/UE7aD5OQYNy/F5kBhS//slN6gz32DA5Q=
Date: Mon, 28 Sep 2026 14:23:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmytro Koziuk <dmytrokoziuk68@gmail.com>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: kmsan: fix iounmap metadata teardown
Message-Id: <20260928142338.1c2c2ec80631bf27d2967a4d@linux-foundation.org>
In-Reply-To: <CAO63FDUNVzMss61+TUYCWSezo1K1PL94iAdt=kNUoWepU=nhMw@mail.gmail.com>
References: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
	<20260915153542.3b9afbd00f7e6cea87a3350b@linux-foundation.org>
	<CAO63FDVJaRzwE_z4-Yd6Z8fZNEGQyx=YbeFatBN30d9X8SYLtw@mail.gmail.com>
	<CAO63FDUNVzMss61+TUYCWSezo1K1PL94iAdt=kNUoWepU=nhMw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: q56s9t877jje55jcz1388wz5cgpkqa57
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E3BF2000C
X-HE-Tag: 1790630620-387941
X-HE-Meta: U2FsdGVkX1/a5zDjT+kGM/zdFL6cMSARg6k9xhtY9eXR0y4KGVO3rB43tAufqdiH6DJ7esDwBRcrJcMEnu2gRclsy62jsBrM+GYfE7bGiZK1MIaURxD3UZTD9awbxwjytZ9mziTOT7Lr3NY1ZcAN6WRbd7iIkL43NuFSvy0R/8UCj9h+krOLuaPWIzCB4PsMsAAh0KYpoJjq64/3lEPfsXe/gI5O3I/me+7yiIvOpaAEOqcNz4AKdYdfr7KEFiY+0DTos9QSE1SUJKwC3Nj3ns2DOiaARsoeXLchHl+IHHXxztKCUfxxqUlRO0KIZxJ+XDK7q++GE/1a+IDxTDtZI81dOD2VgTRCYyBtECkdsUw3MRz58I4Lk7iaNkX+c4K6GLFFIRMquNWMB3kjRqnbp5tsaHZDhIbKVwgTF9UkM/b8waRD3yOyaHW2u4XT2WwiQWdpOIhH7bq8PpEgQnvcMeNDtA/nzwMaq+hRFM4zFyGU/q9DWqV1WreGhYkMlU+ZcuH5Wut2yIwm0Iy828F4YeE12ginlRDIO76Ax9QCRBTSIPXAHyFviKtBFaPEKgcJTn5349+2ROBmJetPUd7JkBa+iJBB94L8xf6n0XYivI/LJYNvubK2ojs8TYFcSMk7CocdLNMA+9AUC1qzOxOZ9X0IJfJFQHtOWjm02hYGTGy9P/Me9153BWOGkqBKJJiFWaWAdF6uAVGc7IHG0PCESFmkyemUAKKsi0J/g6yVbiKFRBwmvAoW96IoKDsOlumL2uut75s7oQo038V3Sp6hrjL5ZmAexyIjCYPNFtJ8U+K4jamDsFe+gc5V9lq0T15Xtyup7jviProE6t+t1uuoNLyNHMNLPUeQtXeOEPmBTC1cone37zCYJvPDCTQYXJkzIt5zvsmPhBYxoSxeUrPbd4Y1iDbEcEhhyTcQnZTOMSjxi5Mwez5MxTBw0MhDGWhbGRklw/HbZYkuFEXaLVR
 qWESzW0a
 uU5lh8OwIpxDYCQECX6QNYq37dDgEWVGJZEtxkMNF9ZQyGZ0c4tZA3f7QyTMSFIpwe5LZDDnLiP+QJewZgAKLxpYiiQ/ieifgSgE6bB4sYm4O4DloyDiMJKXoVj87TTdTm+RCvKjVrIvfcU3nNCMK1qDfaur+WFuJw685e9DdOehlMnbY7IaAk8hM0ed9g4wSBMw8ZEDEnHoR7LF5IoYra3T84zUWAP2Z6JzeWk/U1ELw+YQ2dHfQWa9NzKZW5CM2CYClWjZxPV/IoEWRjWHzZm5UEuRrrqqJ02Kx/TbSK2O4Ofs6RrM2XCJvk6PueVZmw2Igk2tRZwUqzunpu1JWST2gn/wUsvVEzwJY2kpsZsWlUSi/gPw8aFaHLGMQX6N7B+03wwOWWg2i37ahJ8pF0Ys2+VgW/4x8XAwY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 19:55:22 +0300 Dmytro Koziuk <dmytrokoziuk68@gmail.com> wrote:

> Hi Andrew,
> 
> Just a gentle ping on this. Is there anything else I should address?

I was awaiting maintainer review before taking any action.

Folks, could you please take a look at these memory-leak fixes?

> Thanks,
> Dima
> 
> ср, 16 сент. 2026 г. в 10:22, Dmytro Koziuk <dmytrokoziuk68@gmail.com>:
> >
> > >  AI review might have a found a couple of issues - please check?
> >
> > I don't think the patch needs to be changed for these issues. For
> > normal iounmap(), the
> > caller must ensure that the mapping is no longer in use. Also,
> > the x86 implementation keeps the virtual range reserved until after
> > kmsan_iounmap_page_range() returns and its TLB flush completes.
> >
> > For the kmsan_ioremap_page_range() error path, the mapping has not yet
> > been returned to the caller. Cleanup and the TLB flush complete before
> > the reserved virtual range is released.
> >
> >
> > ср, 16 сент. 2026 г. в 01:35, Andrew Morton <akpm@linux-foundation.org>:
> > >
> > > On Tue, 15 Sep 2026 19:02:06 +0300 Dima Koziuk <dmytrokoziuk68@gmail.com> wrote:
> > >
> > > > While studying the code, I noticed that kmsan_iounmap_page_range() calls
> > > > __vunmap_range_noflush(v_shadow, vmalloc_shadow(end)) inside its per-page
> > > > loop, and does the same for origin. The first iteration therefore unmaps
> > > > the entire metadata range, removing the PTEs for later pages before the
> > > > loop can recover their backing pages.
> > >
> > > Thanks.
> > >
> > > AI review might have a found a couple of issues - please check?
> > >
> > > https://sashiko.dev/#/patchset/20260915160207.2952-1-dmytrokoziuk68@gmail.com

