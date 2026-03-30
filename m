Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1B01061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B576B0095; Mon, 30 Mar 2026 17:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4234C6B0096; Mon, 30 Mar 2026 17:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360DE6B0098; Mon, 30 Mar 2026 17:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24D856B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:24:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA75F13BCA2
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:23:59 +0000 (UTC)
X-FDA: 84604006998.11.891DC0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1E52740010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:23:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OI9ZKAjq;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774905838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q/nQnw7KyazJXBkM+LB/F6mfA9S66unYoFl7udhm8Zc=;
	b=RuUZyw27sP8GesDyZwuEGDILVkmPC4SkKeor+WIeBuBedzO5cnyn///hK283Z6MLUnHD6Z
	fawjb5UeYDD6e7GmRm0TJKFAmKYfZYq+MqKXQJe8tVgc5dOksJNjYwP/E1h+tr3QG8shPU
	9mlo5kqYoXCqxI2JjUl9gY208Qd7LGo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OI9ZKAjq;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774905838; a=rsa-sha256;
	cv=none;
	b=S+mLwtC8qvglwIg5fXjA/rrjDBANBw+YJbb/OzQ4O73GQVbayCohcruTdl2Wlz/pKzcwDk
	+ofL5CipRAIcV7P3qQyVrCcin3AYF6RNY/JqmG/F2DXqd3lw7zSESbMtEXxtVPutZxcXEZ
	7C9GL/vjYnr/5+Ze3owd7fmIfFQjzFc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01CB4441B6;
	Mon, 30 Mar 2026 21:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D1BC4CEF7;
	Mon, 30 Mar 2026 21:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774905836;
	bh=q/nQnw7KyazJXBkM+LB/F6mfA9S66unYoFl7udhm8Zc=;
	h=Date:From:To:Cc:Subject:From;
	b=OI9ZKAjq3NUr8kq7WhlZrNWB3h455apwn4ZAjzlW/I6t7LdogJS9Hjl/yKJazuJvp
	 ucvNhZ2hfV+kfeYgZR49pdQsWYSChd8gaLfbSrqRFdKT6C8fAfWFgPkcstcjeSuWJb
	 1cWnxOmOQBLnDTX5mFtoL37o6T6QhH3sLDXl5vH/xw/8d2+Wv4trKiUVUSZDUBeZNQ
	 tw2gkImvuiXGbLiKu7fXICLTtZv7VZ1Yp717RuWPiWrqkbFYAhDqfozgNIGJhTU/PG
	 N+jXXLxTlcidJycblgp9UYLjnppE2VQF6Hh3qZDMuxh5k0dI2QWE4FhoZoo2srZBjk
	 mciUSQISVa34w==
Date: Mon, 30 Mar 2026 22:23:52 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Ryan Roberts <ryan.roberts@arm.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>, 
	Barry Song <baohua@kernel.org>
Subject: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
 [RESEND]
Message-ID: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E52740010
X-Stat-Signature: axegen44hfkagpkqj6n43cqwnzwek4kc
X-Rspam-User: 
X-HE-Tag: 1774905837-237006
X-HE-Meta: U2FsdGVkX1+CITYHXBYwN2dxHQWLfFXo/+IjKDuYii1sJpuPl8osRwt7ioQv0WLpL7JXP7gTwzQBsITd95dwLEHQM2uMKp/LJlqTS1rQIsVgJlatd1Jz45ZlZxtGdL1ptKiSFblD0delT0K3Myre9j3m9kLkJjHsVQixm0F3pEQUXcmcg9ZJbVQyXwyKEljz3tSkE10HTVAmZXeIqwxLF6d5dCmgTEUmk5fFAytrbvL+HDtXlcAlZXKtxocNNALkp8uZ0iDQE3GkM+eF3DJvlWVeFJSnrcwsc7XY4JCkFmAnm/UJzTFmjL2IZfcC9hodcZcpu0NpAp9/yO9+g8z9eUUPKtUhLmi44llTde7M0iLmLDJmaJpFuDWoBT8G/B4RNbhdCPsrphWF1TwmPGMkty8fVw8x4Ro/o3jU3bQdX8t+Haqu0t+XipN1V/UMqNoOArY3s27AKq2tH6nIK2P8zP9surTF9lRLj4ZjR2S0haUlnAUEF6Tk0sbCKmcHiHUbYoFIRVIemjFp2z8Yt029dZK3Q6daKWrcz8SpOcoMPneHMlutU5V2S/OXVLRl0B/TP9JL/4RrJ30dx8SeeeMWm7zXBmhdhQwCd5Kg7OCVC7zCwkeC5QSBXV0qcylf0APNHZirLxMY9u+bGkSFwMvZ+9wFxH9tdhb5fJClrk0hYFGXW7Nd+whwlHt5bqFCNwfnMSOe4og22viT6WnfcgJeIL4wJBJ7AnANZtjiQYqws30r4TA1i1RoQNPk7K2gbF4iVuksjjuU1or9ZhRpz3XeccuGdVinlbOei9AGepL8fDZjRWbRzDaEyvzJVOZYBq1BNf6t/TWaJYGwskgG/sX5vWM4EkmVkcyJVglkLxQRMKriR2YYA4Vr7aiihnj2mEIAh7s9kyRTC3EozxFJz3q/HhRO7uglay/iKC6oz4zo5iIHwHfmWLat9Ssi5LqdF1Q7Pf9APFE0oVSjvB1qDzm
 fR9FuHrG
 gkoNK6+MXVj4NgOi+jxHchgDyWaXS4tsU81Cxy+F/U9tBy8YE6sITMOHvcHCDMRmm2ZFvqAlimaVsEuuQrQVWU+uJbjKSXXVhAOpUHOMkOTP165WVr/oakVh0BCVscaj9nEojiin6KC20MCuIIUfsBi4VHJYwA4D/eU+oWwQLPRRNudxt5BbnDmcqSPJ43gioAn3IFmgecEV5X4J1EVLT1lncnNMPF1dHn4E8J9JD1nW9RsyhX35Y5BxI9dPapIRfvIES+BaZ15OGZ395GM7ChPzKHaPencxHGI60Ytp0j3Y9Z6K9vWj7HwYsmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[sorry subject line was typo'd, resending with correct subject line for
visibility. Original at
https://lore.kernel.org/linux-mm/8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local/]

Currently we track the reverse mapping between folios and VMAs at a VMA level,
utilising a complicated and confusing combination of anon_vma objects and
anon_vma_chain's linking them, which must be updated when VMAs are split,
merged, remapped or forked.

It's further complicated by various optimisations intended to avoid scalability
issues in locking and memory allocation.

I have done recent work to improve the situation [0] which has also lead to a
reported improvement in lock scalability [1], but fundamentally the situation
remains the same.

The logic is actually, when you think hard enough about it, is a fairly
reasonable means of implementing the reverse mapping at a VMA level.

It is, however, a very broken abstraction as it stands. In order to work with
the logic, you have to essentially keep a broad understanding of the entire
implementation in your head at one time - that is, not much is really
abstracted.

This results in confusion, mistakes, and bit rot. It's also very time-consuming
to work with - personally I've gone to the lengths of writing a private set of
slides for myself on the topic as a reminder each time I come back to it.

There are also issues with lock scalability - the use of interval trees to
maintain a connection between an anon_vma and AVCs connected to VMAs requires
that a lock must be held across the entire 'CoW hierarchy' of parent and child
VMAs whenever performing an rmap walk or performing a merge, split, remap or
fork.

This is because we tear down all interval tree mappings and reestablish them
each time we might see changes in VMA geometry. This is an issue Barry Song
identified as problematic in a real world use case [2].

So what do we do to improve the situation?

Recently I have been working on an experimental new approach to the anonymous
reverse mapping, in which we instead track anonymous remaps, and then use the
VMA's virtual page offset to locate VMAs from the folio.

I have got the implementation working to the point where it tracks the exact
same VMAs as the anon_vma implementation, and it seems a lot of it can be done
under RCU.

It avoids the need to maintain expensive mappings at a VMA level, though it
incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a TODO
(they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracking is
pretty sub-optimal).

I am investigating whether I can change how MAP_PRIVATE file-backed mappings
work to avoid this issue, and will be developing tests to see how lock
scalability, throughput and memory usage compare to the anon_vma approach under
different workloads.

This experiment may or may not work out, either way it will be interesting to
discuss it.

By the time LSF/MM comes around I may even have already decided on a different
approach but that's what makes things interesting :)

[0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@oracle.com/
[1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
[2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/

Cheers, Lorenzo

