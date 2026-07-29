Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78687C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD266B00B4; Wed, 29 Jul 2026 10:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4536B00B5; Wed, 29 Jul 2026 10:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712046B00B6; Wed, 29 Jul 2026 10:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5045E6B00B4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:59:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33842C066A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:32:59 +0000 (UTC)
X-FDA: 85041753678.10.15217AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id ABCCF40008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:32:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qzq7eu1M;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785328377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMKkWg8XdJsSIEmhemedMokfn0GRxLZnWltJrqTwpQs=;
	b=yq6IJ1QVPzdpndkaYhW/pCwzps7jg1GHUjw3IkWqeENPJIqIfVcvvRiHJedJE7s/+89/UO
	EZEc3HfysNLEM+ULlLyHRLbe8+tplcztvgUrflylKVfJgfzKkssfGACa/KgSNPz3u0hFvN
	fUsSvaeZuTONhY88+ZaLuaSxRmevKl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785328377;
	b=meh8aF27pFvujaO1XfULztZ5ltGrEEJ00BMewjttF5YE7uV0GJlWv+ucMpaUfZagYEadmx
	gMQH1rHFqYToWH5veYMoZ2vhd7Nqex+IdDY1DwgZ0rftdqDlilHwfHaO5NV8XeaDo0lv1v
	VKgI72842UvGJ31PpRmrrv7c35MHul0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qzq7eu1M;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 547FF60A66;
	Wed, 29 Jul 2026 12:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A091F00A3A;
	Wed, 29 Jul 2026 12:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328376;
	bh=MMKkWg8XdJsSIEmhemedMokfn0GRxLZnWltJrqTwpQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qzq7eu1MaYkAGXp2fv+t+sZs8j5PskkpKyWC5c4Gg5UdYH5H8C2P1aaDFMNhjm5Ju
	 MjZOkmAmyF2c9E85Y5Aq1jrZtMu/ih8IEThObQ/n4GNux8aQej1L3SaeLhXJwguiPb
	 wgWniTdqSnj/P+7bE3SsPdsIJIEK/vM70VxOeetbVHs3e6vaeGQ5sxoHVIM6+WuSqD
	 J41U3v7/Cgjjf4uqZHJ9ExCKZ2X5VB5EuvhlMs2LR4FbSzXHSwivFVNBVY9QprWIiL
	 qJuG5bDWWNBbWjJvxF5I//jrjY4iyDR0mXob0qyw7z+CBAhoA7Ma5yPvk03Ta+CyUH
	 +MbisVYo+PqPg==
Date: Wed, 29 Jul 2026 15:32:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update address for Brendan Jackman
Message-ID: <amny8Ke9v3sOIYfa@kernel.org>
References: <20260729-email-change-v1-1-666ae7c2b7fc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-email-change-v1-1-666ae7c2b7fc@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ABCCF40008
X-Stat-Signature: ktkxwaj97ceyojawiz4uas1hercdqjcj
X-Rspam-User: 
X-HE-Tag: 1785328377-122680
X-HE-Meta: U2FsdGVkX1+CGcsA4hZrAvYIKpLOaH6+1SVvbulXEBQDKSq2uUd+1yK+ao1ECSPlh5Q/ur+04eOEv5cZ+/YDAalLovEu2f/SdoyfpBgdylkb1v42zMXJdqkr+98UykyQdu4w7YuVLove8FWnfpBzCQ9f+kT2BOwwHwr+R0uDkZXQ9iUQBvvv9LV1OIIMhViiI4wQUhBqmTGyY3UX8APcK8Jluvw1qZkMJ/v7ezZkbap7Z20IQHyvO2UK2BBnJdTyx5Kwc/AaIrE8OWsE02m2NCAzrsL2ZLnXXlXRbidA21MbcawH5lJzUWsxuoViPjbDTw7U1sqmI6H1NcTdS/d5eYQ7xb/W7e73fVs7XlfUTrHnOazZrH0JQ4OZBy0QoPaLXNDFhkqu7LbToDqkvyozXSKfETuutaid/bDXgkMyBW0OwM+Dqny7vH5UOz0lAOQMrMGbxjlDTspUYVElfRha61/dxtHGudYmIzbNq07J/+2mFqCVFKoMjH6Xfca7fOK/cnhCukUJzM/PxMRlHQERnbWu1QuYcZxclGqqXK+H0FN3jVhSRMwcapIlUAsODRhmNqzzMmoO7noPlmf+OlBQ+iEM1KyDGEAsvoZWFKbhXOLlU3KjV1fV2zYos1P6zNaiFpSomhOB9p24KCcIXp/Z8B8UNsVsWeh51TdgOzy9SKWgZWoSnfp9oot4t3qRoGwGYwWnAiLjedvUFcl27gzaCft6Qyxx08M3e0+eQTrG1NXmcQ6HTFzr9HNij/QSoaOsFbcYSialc5jxgmsGO3PPifMaSYQ7TutL/uLizoefZacdY+7EmUmLOnQLl0w9YTOGfTGLanyJ2/6y5Xk4Cx/S/c8XYmB9QQoUAkH9tu0ugQ/jfaM6lFAjMzzsrGJo/J+VGydY8lQMZcrYe5oi6jBEkbiGxBS2SUoQEBDA8JlXGzhz1q7m3iRDvorLv1dHFam0FRqsmURCS2aYKlQlqJK
 1bpraHCk
 6xrhPuuHdSwRrJHWY5HVtwKrnr6lIBUiSWi/C9c2U55g0CsPLROp0oD64hhi+0M8pX1rew6BmRLM7DuF5qzbnW1NVH4aNj6o6h2VWy/jaDAX334zTnDkN3E3nyvZTu7jOCh1La8IVHrq95+VxAYfU7QupmE/9jX2weqkZUhJNG8Wazlhl9jFtyeBDT2G19NeqP0CazcvWnuEtxTcmolU70edCmq3a1kshad7WVnzGfmAl0iqnq7dDInVZcvVaXfFusnJJdsLugzVXAQh0VXQ09KIRxHSSgqDp0MIrgr5u8kqXdH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 12:01:48PM +0000, Brendan Jackman wrote:
> From: Brendan Jackman <brendan.jackman@linux.dev>
> 
> Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> Signed-off-by: Brendan Jackman <brendan.jackman@linux.dev>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

-- 
Sincerely yours,
Mike.

