Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD688606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LFWo5UYY
Received: by kanga.kvack.org (Postfix)
	id EA8C76B0BD1; Fri, 23 Oct 2026 15:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59906B0BD2; Fri, 23 Oct 2026 15:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D962D6B0BD3; Fri, 23 Oct 2026 15:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB44E6B0BD1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:08:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DCE01401F0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:08:10 +0000 (UTC)
X-FDA: 85354826340.18.B2E338C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B90080003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:08:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LFWo5UYY;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792782488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEFifYg6a2nyazL1s6Ddx4/FoL09hcLUL0ZmGYbCVdA=;
	b=mEWwJglmjE2vAd3KvD7w0y4yTA5kMQbvPrcrdlA++X+HiDE2+8gngufJIOd2HRBjcG1F4E
	UguC6nTy2UVpbhJo8ssLErg798Y9s0+N86UoDJliY32hNZnwJbIEbIcHJz7VbUb5uY9AKq
	cmQ4O7sKg2IKcHodUZ9AYF9jfT/0e+M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LFWo5UYY;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792782488;
	b=xsXkqJU8EpfaQ3eqWvIGAKNlFhlD3eTlBIaeqSZYqZTCOg6BT8s8E5MuGPbdJVXHQNxysY
	haoj1iDd7M2gfMJXJGDH8UFNxNaVQC024Skc0f+inZnQkkSazScXVbLQk01wmsnxvvcZI/
	q28V35GHFSYkK2dl5rE4Zst8WZlQumM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAA6D601FA;
	Fri, 23 Oct 2026 19:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1BE1F01825;
	Fri, 23 Oct 2026 19:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792782487;
	bh=xEFifYg6a2nyazL1s6Ddx4/FoL09hcLUL0ZmGYbCVdA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LFWo5UYYqiHQP2M2zIVZiVaDSk+/76WOvHUHdxOY5iWBZodd/7ZHjuYU4oxRcu2tg
	 +XERiVgDZ1DsvXExmg2SObPrKD+RFWxgDevxlYSSuJTwTCNsUyUuQJT07mbpCuwoEC
	 bseBWIN4Qfv4KnkRVVkKwTzjGd7ia7rso8iD37SM=
Date: Fri, 23 Oct 2026 12:08:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, SJ Park
 <sj@kernel.org>, Kees Cook <kees@kernel.org>, Colin Cross
 <ccross@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH 0/4] mm: avoid losing atomic VMA flags
Message-Id: <20261023120806.9ae793140c252b4a4cfb3894@linux-foundation.org>
In-Reply-To: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5B90080003
X-Stat-Signature: o6rg98z9fktn6r7gzs945zo5rhesyymf
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792782488-820034
X-HE-Meta: U2FsdGVkX1/y2LMvj828DT+oa6TwXmmdf0Yz3GR3HiL+41OPogP6rwDTa+M7FfEvwK3ZLsH+t4xTfTay6cfRwn0A5fFFuxzQQKXQSlk3vARwokmFUdBmWUL3UnEWiFdYsrRCoG8NNENt8JS6LPjZ2IOCc/GX6Rk863hW4m+UDFwl9t+ZiwwiAlizlhX7gjpGGkSP6d+nQVF7r2+XSe0iYSAqVWY4jiyXsvkPWGPGBZdY3+hp6CCAZ1ZrpzyELn04dEevSlRT+tv7GhSkjRpvAcb5V3lRnmL1kIsiTuBlfaAk/hV46tA1USI065KJa8nZmOaltTLcos9xl3mcok63nObQuyue2ki6gF8uKaRPaD30alNKGjeThJku81DA8vgvQViNuI75DDC0bhATJBcPysAiBcaAzOTrSTwkmsIjxXTqs2iDIn2ybgRvD58aVXeu/MYlUsX9Dlxjgc7gG2KJihVBl8w2gqXaffYIn46UqlIpmN+Vhor923BtE5Qrc54F2cU6XpIgcKd3r6yAd+61q2R0rRlg0VHWV+kFckoWb30MEiENnHSPXcQYOz1wb6dEhENKRuIpZ/vhZqlbU1ondmhgXxAFsLyAxRZAKYlOerozhfxq3aZWuFIx4qbbYFx9YEXa6mgiybT8aMWhsYu5ta7jf85grXlA2wuIFWkTs3HOUkMVjBS5FA6TzsSKlhARAB+bxZ0SRt+02CLVn2/Jlos8Ys0DncXXWf3ti5I54fcBw04Is2ZIA/ez0Kr+2IGCmF7mJ5BPAkwiOFJb3Olh8aWcMicOQVqUiuHpmXpiSk25/UVY+4x9MxMvjFN4lPBt9+GDEgh+mSV2Q1ooMpNWJ/3AzwAm9cY3FItXhEFCPjddZxTnpBgschdiXjaYkkWPpf6w+log29H7+GBN1Iu5Sm+6Ydj1EY0pSuG4e790k01A6ueVjTqxrF0uJMcDzmoNC13FOogpHLVLClj7M5k
 GWbu26KO
 rtPNzz+hq7ZtlteXOZiH8M9YI9bSxIK2uXBURkBzbeNBYbS2rLJNhTs8dlgqNwbY1ogQOZ2dDN5Y70V4AxNo6cdwKQkV3HxVjZYMuyNmhYx/W+04KFLDG+S7Ye6dnTDIpJn5WkRPkn/m0QSZnF6jn/JPgR7O1/GJ3kSvljAJEBDtdd20RFZad7E5nSZGGntSG3tFdadlyxOQ6eGWUqpKMUU49Z5lfCL3QBwJcY5n3tjx1Gf+PCigVVqHhSfHCr9kVE6HfiwlvFw2gFC52YyKN/9P5Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 14:47:26 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Since commit 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove
> under VMA lock"), VMA_MAYBE_GUARD_BIT can be set atomically under the VMA
> read lock.
> 
> However, a number of places wrongly assume the flags are stable under the
> read lock, which can cause stale atomic VMA flags to overwrite existing
> valid ones.
> 
> Additionally, one case in which VMA_SOFTDIRTY_BIT was overwritten is also
> addressed.
> 
> This series addresses each of these, while keeping the logic inline with
> existing conventions.

Added to mm-unstable thanks.

> Each patch in this series is a hotfix.

The fixes continue to pour in.  Right now I'm adding everything to the
tail of mm-unstable while patiently for Linus to merge our stuff.

Once that happens I'll assemble the second-week merge-window material
into mm-stable and I'll spill the recently-arriving cc:stable material
into mm-hotfixes.

I don't think it matters whether cc:stable material is upstreamed in
7.4-rc1 or in 7.4-rc3 - rather than rushing it in I'd prefer to give it
a week or two baking time.


