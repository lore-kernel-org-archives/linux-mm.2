Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E0FFF4936
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6F76B0088; Wed,  1 Apr 2026 23:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A85C6B0089; Wed,  1 Apr 2026 23:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDEA6B008A; Wed,  1 Apr 2026 23:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 75EA46B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:44:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BD9B588B3
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:44:24 +0000 (UTC)
X-FDA: 84612223248.01.4BA07D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54A99100009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:44:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yM2SJakF;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775101462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSlOUi5I27vy2NB31VsjxrLbzp7TT1QoiSy97jKvhDY=;
	b=js0TehijByVeUdg75nXA9WblOHuR/RDFr5gtoKpSKCLVogKRion1NK3wh58Xr83nfjiVqZ
	PH4sK5VxhKFsOiaY5vcparFSMo4+ATnD2QcXF2HwetjQzlFytRxWfxZxe8jvz9lrjVjh3j
	tepRgkVS/iKaU7f3WsDS8RnC+dtWuI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775101462; a=rsa-sha256;
	cv=none;
	b=iLKemA5YRKKcF25lqHEM0TyIIbpdYWsnU3owDXpsan14jyCtyuzrTTrTyeRo/Wqb7aaApr
	WiRa1n8bO8oYOFkAuBhFrNX5meAmlcQgDA2fF+VOPcFBQIrV6S16PCmU0McLqkT+slOwaW
	zlRctlEy4QgPK8Fd+HGAPHo6+kBVZK4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yM2SJakF;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F3F4417E0;
	Thu,  2 Apr 2026 03:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4809C19423;
	Thu,  2 Apr 2026 03:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775101461;
	bh=utH2DEUZc14sIH1OkP4isvD4gLN0I0jn3rJSKnIZ6X4=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=yM2SJakFdW1YNAdT3Rnday936jebe94aPki1dRwx+af/C1Ma/8+0woyCSIc+zufFV
	 lrMNiwUmBX3W3T4DPTOBWv5sMTkfog1wYa0aO9UIsnCKCjEvWFZktGeIJKOzjjGFJu
	 Q0CJj2gI0vIcCbWy7SOuu0cVyJPZaSLBfyQ+YobY=
Date: Wed, 1 Apr 2026 20:44:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Pedro Falcato
 <pfalcato@suse.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Dev Jain <dev.jain@arm.com>, Luke Yang
 <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-Id: <20260401204420.9e7342b7054a5809b8bdfa40@linux-foundation.org>
In-Reply-To: <20260401170931.9e455bbf679792b039d9770a@linux-foundation.org>
References: <20260324154342.156640-1-pfalcato@suse.de>
	<20260324154342.156640-3-pfalcato@suse.de>
	<fbabc728-a87b-48e2-87dc-68ac21eb02d4@kernel.org>
	<dccxy3i3kaprljloxbyo2u346bu6xwev42cpvt5lfbbli2hbap@6n2rd5mftffh>
	<a7a903bf-10c2-4d2c-872d-9b31fefb5d1f@kernel.org>
	<20260401170931.9e455bbf679792b039d9770a@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xyw4484xuqrfjew8fkzp8nwyg441buuz
X-Rspamd-Queue-Id: 54A99100009
X-Rspam-User: 
X-HE-Tag: 1775101462-329578
X-HE-Meta: U2FsdGVkX18jbBBViTJmjJWXNrbeNBSa5GUGV4U/FJVQgWoG3QPfWcfxjMb1SRA9aW7duJ+eScrvieS2vav6zjkkFtBoIpzyUAISttkYLyKG8wqGh2R67XhlL/kfIR5TJv11axXyeq1P6CrYnolEdqLYdhxnDtnaruyF3ehgEQZj6PtTFaUySbI1A0XyH4w+zFqmfXUDQQKV6r3D8Lm4AkvxnZzf5oeB14vHpv7CqCGP4gUXM3fZieKY4JNUFpb1ioCogCaZQrXAhP0IsmRYa+TgUgo8l82xzasoGj0QXuFtqkP3XxeV5bEM4VQB7uyM2czGtLEb79vCfJ/P4keCRZpGI6hvgAVlgiYx1wFzALF8XeDKt9jNaHZIF8aK8Q5r4qot+p179Zme/f57ucrk9BI+D/jNr/+LXLkFmOW6A2c89D5cLv0tXPYreYJjlzZgK+861p/QbtOyYa0OI7v6HF3PhlbaTtFDQeq8KSJhnDqo21rxeYUKp/GzCzYGwuvJgHSukeMZYbKdDWJxb8qaqK/TRrKHGKuj3DpW72Iqi2JnrjhpcdzAkGa7c6QLsprRUfOxAIkdP6BfiiWicGzvh0Omb8v7vPMu8GvAssgM+8c5eav5CwJhvYJkfuQCr1adnK4vjtSPKj5kXywruop5mRhTgfzD6ERRXmgSADw3WXU+ZIJHcINO8waOgA1vjsvcTCLLfN4L1qTYlKSidZmjgGpRR+kTW8kdwUFLHRlVOdL3aJUrRx6ZKXHDaek57wH1uH6+g6kgy3UGTrES/yDW+rpbXF6meL+bEIAHNwn/AMfaw9MzOftGUmoYAu0Lms6gf8itAf4H3/g2NOwRHmsp79zjamUKQPXKqZdICQ0z8BRmE73/risAP2A87ARZtv97+HAnP6DqG4VY8ny52d5i9FUASszCAusZosjHY/AiQy3SpbCFGZkbZNzuQOmevbYPjknXdeXzgKcpD15Okcw
 P/spJIUb
 1oE1tXNCV3vt7oCKnoPKhr3zuMWmUINvSPa1hSSDlIdw4aRp55CREX1INg4SV9AZnJppYkHw8qVz1b6g0CBUtDexhF255terUVLWRzSibfGRUA+g2Xcrg3+Mi1/Apuns0+W9uMLXFPS2oYqCLIfoDKNmf2hb6YlDliaOttoJsy/NcydWxf4Bz0NSRU9i9yuwgiwwpmCb3qyuCk8JvhBhKV0MD7KKZYhOq7qWcSv3k7pUWkMzWqBlMr0Qp9XAQR9KwjnZ9mZPooDJQqfCZ2xkJ6n6wHK7o2tr7JMfX+/37ZJOX8giisMMcOM02nhegUA4Rhl7+k9Lm3vM4I58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 17:09:31 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > I can easily extending
> > 
> > 	https://gitlab.com/davidhildenbrand/scratchspace/-/blob/main/pte-mapped-folio-benchmarks.c
> > 
> > to have an "mprotect" mode. I had that in the past bit discarded it.
> > 
> > Then, we can easily measure the effect on various folio sizes when
> > mprotect'ing a larger memory area.
> > 
> > With order-0 we can then benchmark small folios exclusively.
> 
> It sounds like this is all possible future work?
> 
> We have Lorenzo's R-b on this [2/2].  I'm reading this discussion as
> "upstream both"?

Sorry, please ignore.  Reading skills.


