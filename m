Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11481C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 19:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B516B007B; Sat,  1 Aug 2026 15:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3BD96B0088; Sat,  1 Aug 2026 15:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2ABC6B008A; Sat,  1 Aug 2026 15:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B64136B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 15:20:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C138C0365
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 19:20:44 +0000 (UTC)
X-FDA: 85053667608.11.DB936A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 921221C0007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 19:20:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EgIGL3Fb;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785612042;
	b=AhfWSfSKOUPg0Ao25043xGwSfTPy+yf6hTKJH+QoGHm0hSVQeMXV3/u/yAfF83CubY78H9
	n6S7iq+jLZJObNA/feSXaPrGci75s9mnhMq1WTa1Fkzi4zaP3xj0H1DUnedX5cO7jnVD0B
	mSPCWZaq1ysJWveWlYH7HezlYuT5DIk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EgIGL3Fb;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785612042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7eOeE4EBbEtBW4lA82aotTkFyalIM0ORScy2U0jVdEI=;
	b=HmM4DjmcgYTkF6hl/+4xDfmIItRHzFlB5vIoQydFEHtD6RdwGXq1R5PgO6EQbEfv0cXqLd
	p3rg+UOpgFxch9P5Y/ilKdsxSEJXfsw4DRYJKSHjbIBUlAqXGKFyzhodIJliKbfFhflzYc
	Zn2iwg2FF4uzGNQiV7j4zQoI8EwwU6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A3B6400D0;
	Sat,  1 Aug 2026 19:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E9F1F00AC4;
	Sat,  1 Aug 2026 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785612041;
	bh=7eOeE4EBbEtBW4lA82aotTkFyalIM0ORScy2U0jVdEI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EgIGL3FbRxeU5XW2xULyYeljHqCqhy6r6Wkwtxz0U6rEWEYJNOBAW4QS1+i9XzI4r
	 gVnFCttP3qStKohiNNiAuxXCWR+8cOBlZRFOBZqhSMh7qT3a8E0kqkHU8vd6r468US
	 ARj7HeSZzPe34bjt3YF01R/085aCSLysmxJE18Q8=
Date: Sat, 1 Aug 2026 12:20:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, Ackerley Tng
 <ackerleytng@google.com>, Frank van der Linden <fvdl@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/gup: fix always draining LRU caches in
 collect_longterm_unpinnable_folios()
Message-Id: <20260801122040.7230a8eb0dc846ce357fba67@linux-foundation.org>
In-Reply-To: <f616e9fc-339d-4430-43ea-0ec8810c5f3b@google.com>
References: <20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org>
	<f616e9fc-339d-4430-43ea-0ec8810c5f3b@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 921221C0007
X-Stat-Signature: rap5ri8rcz5kaegxyndwqznqm8qxyzze
X-Rspam-User: 
X-HE-Tag: 1785612042-77554
X-HE-Meta: U2FsdGVkX1+kcvZsMpmXrDXyn2xABjpNA+ESHydcURqtsprYpo3qJuLpCtJrYEkxwDZdf6A96vW6PMyXKTSQoAgk1ZDK0XRPrAFrzm/YXyfypX6xpTYADO8suk6OPWICCmOkKuv18ydfIsbidyqU8ooqM0+ojFK1Dr7X6YabxDSmq62GI2qp0Am0hXzznl4W9HTWPf8+Eg1FQK2jddiqE4hXZHwDhwL+vleIua6DLyklIAUOMUAYk0Q+7uA4jTBEzhfhepOFj/Z4V/TiXCaFNhYDZ62CyMt45FluVHz5G97kRn7UFvc/RDAwH1kcoYulDbqGPNCvZ7jRhK7t7en14v2mljudCImvjawBIltaD8cFTHCg93T/Gi6mLAkkG4Ti/DrjxhGnZA7eZctKIKIuT/ahXajO9ZNa3F7Sdca2krPIAVA7KheMiGu+jnwFxQnw6xo0uuEA7zYw8SwytoW8aAsofVW5sIf3eZcaPORQ1XHdtHnvdOTqFH6ASZPigEEFvTXy3kJURzyHBETAC8bCWzhAptS2lt7dgimhx2S5i1x0JYy2AEhGn313Li8XpPnNr91YvAutjbQJkWX74WLgjQrJa2OZV+iH924j4PvuFsvQ8BHz5/9cnvidgNgZsVoVcZ/JKOhiog6lTD565Ea3VOT9HslqqB4eGPZdhfrl0TrcU9pon5g7QQz0xunxL8FV/ttg2zyXWC0mxcCAq9Xo7CAir23GPmq8y61EVOBgzGx5Bh2STgnlHE/+oWzT05fGP6rle875KBwKf/7GuLGjta5cB8Jhzc6zAqOxRGABsUKM7MnU39hk1X4lXLMoW/oGVqXv1j6eg/2JImPDgFd18KQWhTtpxPzsbkZwLMEu/XNWEfxzO9QYCCHtIUPZslHNKtg6r6UaSgJ7LYh3ptRMI2ALQbFT7GojxYZ0mb+/OybgRoZxh/NH4OYiVqjZIiX/8a5tlWVyECbQB+8J/mx
 cIkYkVMY
 OXyzb1mVQq1VXp0qaUXR2GQRYYLhne966ytk3XeFAnPny1q1O18IsFOj807lob7gync236G6zwTesxXd7BRSMQXOH7jZ1af0Usv/4iSbK7v2mkmGDGSlw4VxM3YSZzmJeAYSZMS3sNRInQzj6AlFDZD5QWWPhcw8S/O/zdT1qCrkCQUL9D8FFhKVCUq7PzRQwrPMyE1QmTYyigq82RzykyYNfzQpInAq/jnXt1WIHOIO+DDXvPPtLpSBG22V951wVz/t60IMh5T2+Mb9B7IOtOTG0pDMiGI+nyPbXPREtbLLVg5ioQ0PDkCLrxhuKp7lFg3w4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 1 Aug 2026 11:49:39 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> > Found by code inspection. If someone has a testcase that can easily
> > trigger this and result in migration problems, please test! But this
> > change seems to be "obvious the right thing to do".
> 
> Sorry, I don't (as perhaps is too obvious). And I'm a wee bit afraid
> that some of the problems which those changes happened to succeed in
> fixing, might now reappear once the drains are finely targeted.
> 
> Am I arguing for a delay before advancing to stable?  Perhaps, but
> I think not: it's probably best to get that working as intended,
> then deal with any fallout if it arises: just be on guard.

This patch is in mm-new, so it's still some months away from -stable
eligibility.


