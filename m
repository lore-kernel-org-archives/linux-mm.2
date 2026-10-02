Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76BACCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6731D6B0088; Fri,  2 Oct 2026 05:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6234C6B008A; Fri,  2 Oct 2026 05:15:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A306B00A4; Fri,  2 Oct 2026 05:15:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA696B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:15:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C9D816061E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:15:55 +0000 (UTC)
X-FDA: 85277129070.18.4B8B818
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DCDA2140007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:15:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tn+haMvE;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ncyk5KFdvqxpjC54udFuMVuSf0AeMOFkeg75rLIkGYg=;
	b=w5LUgW/Apepz8jcv7dCsBmFuFcoj69YV72hW4/365JTVR24CaWx1oCd2GZ6vIyznQWXhvL
	3WYsolTKMvow6VTQC2EisSV82UdcgRnWj7q1HOjrDhOjmvijIR4raXIl6/xvjKYJjyo6Am
	x+g/QlJKBvCw1fzFdffkTCR4reo0wAU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tn+haMvE;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932553;
	b=lS2Wc05nvIqzRk/eYHPifGrNmizN6pa2LAiquZhn7/Sqib5qMiRNIJoo9ktpL322ZoBxNQ
	+SqJCKhBRxeUdlPVJ7QiZDevmDYFglKHbXFqcaINUnEu6dA5KxY8BodiXcRCwj5YqHJpKP
	6A71Yr3Lk05EqLCkAE/yoNCT5OWn9kM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FE1D60A8A;
	Fri,  2 Oct 2026 09:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F3E1F00893;
	Fri,  2 Oct 2026 09:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932552;
	bh=Ncyk5KFdvqxpjC54udFuMVuSf0AeMOFkeg75rLIkGYg=;
	h=Date:From:Subject:To:Cc;
	b=Tn+haMvEaetRbIlCmQhuyzrmqqlbZUksmdMQ2y4PTkjbrjwjWPricxTYN7c1dfSrj
	 q7lyy6JkqTRewLSNLnlxeP20qVXKgQ7CtJsN5R6KqcLlOyLrJ9qINnLKIQoAbRxZ9Q
	 h81xrUOMDdBJ+8F7WyEn6MgoScelWBwEUlNM8u2g5IgqRHnbaK26pVoHYlfDSziWww
	 QQYnW0+h7Dervi9nkSCP2Ob/sTa6NAfhbzdD7jBXgFt9JX1lZc2v9Lp53/nF9qAFtd
	 wTv4BiDjvjvGQ9JiUflC83cr0d/uiuqtZoc7POJKNaCd7B3TSRVClzPgSE6gVDfJxp
	 8pBh/DwZIwuRw==
Message-ID: <2283e699-01e3-4575-8bba-93d0f5b2066d@kernel.org>
Date: Fri, 2 Oct 2026 11:15:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab fixes for 7.3-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCDA2140007
X-Stat-Signature: qayybnko56scamk3sjapus4rxrwsd5wu
X-Rspam-User: 
X-HE-Tag: 1790932553-561237
X-HE-Meta: U2FsdGVkX18tghIeI31COhS/BSEGBOdEEhdmIDxK58CePC7+c8WVWXGcR/Fu5jJAgEo2KQY64S+3Wl/YnHNv7G5fk/dvf32afKxz9QOUSgyzodO+m2SX0C7+HX5sqe0mWCb9q0uYzRPjInbrsSURRDWygrw9npsciufn5p49Xyl7mcnVIy7wunzSvMqlXiXxmmfxXNHT8QayldsQBwpjjAHfmgLAkcSDrSbS52V3bAvhOleTDOmUF4uCZmy/bRRgWnwCwMeiqbtB3wY5MHeC6s/zufAbOHwn07lTuq/tc043MakDNgQqPjaD14k18uBaO7gi1BC59N9pzEPUyPAU73zHfF07YcUsA0CCCwLo2Cr09fLBggd8pzIXTqoHlTsCelwV9NNFxVbdGJFiuYgKxXo9ZH4nkVnmnEz76KvXuVYAYSwNPJKnYw/LUhAPeaaHzSRafn4pTa4hVR63uL72lU1Dgg7AaAEK7NQO+o2wDdIrexkzDiwCsTbKWv11UVPFdBqBOwKPhlPy+OTD2Y5sTl51fLP51LUQQLRJT1raAJPVVplZnO3O4y/d0sVENqVkVDT+oCxz3URw1tEIqGVimrdnfdm1Jas9Z5Lw8ZnalBwcltM5mtVV3s5LGKRJnEn8ilgjeKyf0j/TqYfkcG50WrkG8yY3d3hFt6D09bRHI7qsgBOrkDn7oH9LbCyV9zSl+kIlSN/sYF/V8j7le4OG18wLFzUxAjksY5cJXt7N2gfj5Hcxog1wcaFkgqMJwYQPtgLlB2wgpJ4oEkVkQYG8ZsXZ7S+HYjCMI0a84WK3jiK+jGPSOUa7YidOjAnn/CeFoCZ2UQiWdSklOL6A3BQUSWCSKSowf2V2YcWpdukP59EHUt5wOFgSpSXqVYkq337tYnkezRzQqw9CvjTKze/R3gtz93r3Rmh/vOCKsDf1D987bzy19bgJCzJUEPag8adUjOI7GcKwIdzGQP4nvcS
 Am+qsC6H
 Y4WnIVAUHB4qlziAKe/Jid1Jp5eaCgDn1vOdC1Mei5jKWXndCROSMvTnYtN6zewaJplqy46HK1Gpl1ZFPaJsTkfcAYwjNyTLBAwjDHeCqDVH83Fs2Wvjtp2sb32GWRoqqcTQhMb6GxtGXfi1zW9CUDe5JpHCk7LHp681ZjMD9+A0lm9KI2XzdDa+WzhKUi6mgXu1v+9cQIJCX9fj3klevbxTDYXh/lRUX0c0y005RxdoA+oGkYt/7Nb3clm7i4KS7wNUQj6Tlu6HFWLheXbUEDYbn6cDx79doxNF/II2lHDUGum9w28BGw4m5Jn39U/pWMntU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.3-rc5

Thanks,
Vlastimil

======================================

- Stable fix for a potential deadlock in kfree_rcu() when called from
  set_cpus_allowed_force() (Harry Yoo)

- MAINTAINERS update of the slab.git URL

----------------------------------------------------------------
The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.3-rc5

for you to fetch changes up to af2fb3ee6679b517e2fdbd3ba16ec276a8b74312:

  mm/slab: do not wake up kswapd in __kfree_rcu_sheaf() (2026-09-24 10:14:02 +0200)

----------------------------------------------------------------
slab fixes for 7.3-rc5

----------------------------------------------------------------
Harry Yoo (Meta) (1):
      mm/slab: do not wake up kswapd in __kfree_rcu_sheaf()

Vlastimil Babka (SUSE) (1):
      MAINTAINERS: update slab.git URL

 MAINTAINERS | 2 +-
 mm/slub.c   | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

