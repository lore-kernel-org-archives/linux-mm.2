Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB32CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14B26B0088; Mon, 25 May 2026 04:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7446B008C; Mon, 25 May 2026 04:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB50F6B0093; Mon, 25 May 2026 04:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B47A86B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:42:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CB6D90291
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:42:04 +0000 (UTC)
X-FDA: 84805299768.25.3E2168E
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 712E2140009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:42:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=L8JAt1Vo;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGM0HnwsQ+sAC0d9nq1+H2+fQIQXp7hPnnfrzxBYUA0=;
	b=YoblWNsu3m4Fbaj97FA0lQGz70vs5GyLZd9A/f4aQjZgdSccBjemSJtAXLe5b1vHc95Kjc
	2G1rkU4IEpW4lGhhT0Oz00CKl7eoUrPc0y8QEws0K+DOnw0/q9FNSbQTIhXNX7WGRDyIo9
	2tCZOdBn0hTsBm3R7d7R8hClL35xNHg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698522; a=rsa-sha256;
	cv=none;
	b=PXc5orXWaw1ZVwKYRG6Nt4fSJS8k/MF4RFVCqSRN0Uv1UYr77/iKoBiEVzPVs5EZa3kXcu
	mvgXWzLtT+vFUXpbf3GHVAZRa7OQaXagNJEL6WdhDYbk+dPPoDX83/KrM9HvSdz7Hxqidm
	3nPsLCPnlg4XZICzHN1McJNuwGb2xAA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=L8JAt1Vo;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4903997fcb5so36189935e9.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 01:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779698521; x=1780303321; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TGM0HnwsQ+sAC0d9nq1+H2+fQIQXp7hPnnfrzxBYUA0=;
        b=L8JAt1VoPNfD8L+2nEKcuHgAQce0jCuhgRp4eWiuudsq54T/5kiGnSs6cBduxXGclr
         /9Rix3HtQu+CEnDR1cGndlxgPgYJHriWvXY+eODVC9SDXytgDB0cJkxlc+K22EaHOFdm
         EgLaHz6S6hb+KApUKTC76DYzJ/NweX1kIZsi7wHhoQ1LbSiei6f+hBaW3jTC7ZtXZfqh
         MvPyBwHo5bF52U6Cdkyu/2OUFsoj0PVKchXYSsV6xj1z5gqdFl++1hn50Jq10Y62oImt
         aExoQpwDY1ltpMUOBJKyFdj208uab/X/BElUktqo6NVDDkNaboEZQxHOeCv7RvUw95mT
         sqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698521; x=1780303321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TGM0HnwsQ+sAC0d9nq1+H2+fQIQXp7hPnnfrzxBYUA0=;
        b=LC8mcY0fojmb8nqWNhTpk86zM9r0thBjFEhHuvw2/ydmu2I3kPLEv7BAxMa33ASptC
         KWXyqQq8/8pxdcBya83cTNrTFowCcgkzPK2Iiq8toGmQJsdpbWorC+n+NHzdfUx2MLjm
         UXMvaQ6W01Skr3qf9PXPDr4BlCVhjmpNUtnLQ7OwhpY5TWzS8D32GwH54umcmKfFZtjT
         3pY1f0sDV/S6a3PjcVEZOh3w6FIHctReCzdyRV2ZKDp9D7vXD4p+N2tHKjoFZL1XWPV4
         5B6vyt4aqGyCix6d27AgCjT+vOuu6+yn3byriusBT6iPSZsZ2UtMcEl/XRJJdmT7NliU
         MZqA==
X-Forwarded-Encrypted: i=1; AFNElJ/Y1QBZZoHC/QVygSRbrsE3qhay3atkvsXXUmn9mDuegBo6es5i846eTl7e3CEaUztOWDZ0Zx/kDQ==@kvack.org
X-Gm-Message-State: AOJu0YwTNsfOS+jK0tfk6YE0g82vEWhx7FTsgfj/ljoMYUKT+IBuAeWd
	FDOZiHF8AV89hgzFPwEImuZxxw2zlcE7fwFjcyZpCTJcr5JfXUItopVS6jXS1L0pwLg=
X-Gm-Gg: Acq92OFfXMMGpHlcF3h3Kaap95qNnB6O1iUr2YfMyjor7jR0Q1du0hz3E4olp3wfd+2
	4NRnOO18tN0IfTElSNes53r85Jj5QDJVa+XkCthMJcv2MxxAqQyLDWb/lbb1ggaDMOWxI8GI9Ox
	qgZpn+OPKkLl6zSHgm7JjXd3+aasQ8rR4CZAXBOZP6qZ/7yMydebautGfcvrkUSa8a6YvYGy8hv
	PsDsph8eMZiJitggyzW2eNRzbG2yztTfyTqzBvAWadAuafar+pMyXVU7Q+uPuWSgtXaASgrbslM
	j5BuKntr0rIjsjL6L0EjzTP0yUuHHdGH97cjGBO9Jm+4YVT1hu82ud/19FUMS0PwXBMfOMzRYa4
	3K95mASbsZtobjm9KrGOB+93dWO9jEpCbKDEb5IoRrFJsDTclcA5aZpr7GVzaB+H7FfMbz1UBXG
	wDmZCoU56Sgyf20hN5s5u2XHykNPMfP4GeDK0D
X-Received: by 2002:a05:600c:6095:b0:490:51b9:2309 with SMTP id 5b1f17b1804b1-49051b924b1mr152029475e9.29.1779698520913;
        Mon, 25 May 2026 01:42:00 -0700 (PDT)
Received: from localhost (109-81-80-247.rct.o2.cz. [109.81.80.247])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428ee444sm82000815e9.24.2026.05.25.01.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:42:00 -0700 (PDT)
Date: Mon, 25 May 2026 10:41:58 +0200
From: Michal Hocko <mhocko@suse.com>
To: Waiman Long <longman@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] gfp_types: Introduce a new GFP_ATOMIC_RT gfp flag
Message-ID: <ahQLVgj8zV4xQRh9@tiehlicka>
References: <20260520204628.933654-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520204628.933654-1-longman@redhat.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: du88kzwwi9ndewt399k3kgodcgytkkop
X-Rspamd-Queue-Id: 712E2140009
X-Rspam-User: 
X-HE-Tag: 1779698522-610410
X-HE-Meta: U2FsdGVkX19+MC5hsZJuqGvg1Ok98OmQjNhyB5cNqghQ2L1VxgUt7A+kotevcgw01Rk4MXzIhcG3LF13RhlBTJrhLlIsvu83c9vBS2zXEN8j+GPpdsqOwvaeVxWoVFDGzINffNipjskgvf4l2zbYuZgmUW1c6Wul0v0pFSrAaw8SLuSrqVvlSYSKDtWS5w95mtkCYCUZlvQkQMJTrhDNwtnQ+t6/GF0c58BISUtpBN6N3pGxMwX9xkOsm0jeRuFB32ea1LUztJIkykkRDYusYl4h68zLlwXsUUg9lzTAPFJNTEa7wc7lcVv6qY6oHs7G3fYhylOk5ip33tD8Bq+A/IljSoJ4i8CUxqT61pWoah2ZquNkyoTYaJoCD/VQuwJVQmmpIBQ622wDVADX5Wclxl3BUqj9+84wy5sQxsQYHApzIgTqjtXRa9gt587O4lDQO8Gg9cyKfFFT+9jhbxRCOvgilAduPzcxDvVv+xJwQjFZIgrSgFHJ8k/QLkoK0pHYw18KOip15Ps9eeR9WmCNkDb5c220IM4GuIQs8tQwNfZfu8hQ4EbyBLSg3AZikK0VlX6huKoTAUd+47pjKMnlN0YnypXbOWhKD1pIjmB3SJxMx0gAeBTQ1vLqaAFc5j9N5QT7QYb2JfMIWUhAPhQpvJHxrR9Mcto+RBqcvGnfnJiTWe0Bw4jEHKE1/DbMJrOMC+LPO66pThaeyWb4T/zNtJ15xg32wmo/yQgU4IDqlQfzvINlfbqb4z2ucAxYqgdzAmIoslDdok8+9kGpeLDjvdBG1A+BTZkhIdQpXcO4j13EWL+rA9T7B7GK2usjWha9P6DLxrl8ScjhveuorlnLKVJwcAWy1M5u2kyQlNTIPnDQle/97FwV3MJJD1VE3YH4BU/ys4H+RsWrHpTdJtNhnm5w8LgZGeOdinlis8qdSRor4hSmH6UsGc7VRHiijfWzsyJ3TW7pKhQLvwAZM2D
 Q/wcpqln
 Gn5jvnSNXeJTVZ4hhRMipi/R9TUKjkILDD/l0+vlvQh0v1P1L/IOSsIkfUwje9c/aFiZ0a8YUfmTYLfHYFTTU8Nb8UBbFawxCE/a+1mDvbil6vJQuGSZm3ZKczkVyPUhkksItEWaBHklmiYaQsycnb1IiO20T6ok2Ncjs7hw1ioNf9MQv47xccBPEq2kt1ffcfeMteINv/dj+U9S+951QNUBphD9Oy16egom+1TJUp2ZMyM551oAlIALlpl6EYwT1vbKqtpEtdpuN69vI4ZTxsPRQAjP+8/hv6S0iv+FTBLOTh+q/OqWq0WdsxxEf2/RTNqkswp12TyAEBU2GjvT4UUpneAuOnaZwn/c3boMnZeTvrP6OXYBY93wTU35BwIcp+k3S87hGh1TioQD203KxVwhLUs3FaycAiqQzgvuS10CwqDVZIInP9SyNjgYiM4HjhXIf4w/hyJoznSUrgTRkzNcMM2jPhydprtOhRwA4nCWscb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 20-05-26 16:46:27, Waiman Long wrote:
> The GFP_ATOMIC flag is to be used in atomic context where user cannot
> sleep and need the allocation to succeed. However, it does not support
> contexts where preemption or interrupt is disabled under PREEMPT_RT
> like raw_spin_lock_irqsave() or plain preempt_disable().
> 
> With the advance of the ALLOC_TRYLOCK allocation flag in the v7.1
> kernel, it is possible to allocate memory under such contexts by using
> spin_trylock to acquire the spinlock in the memory allocation path. This
> does increase the chance that the allocation can fail due to the presence
> of concurrent memory allocation requests. So its users must be able to
> handle such memory allocation failure gracefully.
> 
> The ALLOC_TRYLOCK flag will only be enabled if none of the
> ___GFP_DIRECT_RECLAIM and ___GFP_KSWAPD_RECLAIM flags are set.
> 
> Introduce a new GFP_ATOMIC_RT gfp flag for those PREEMPT_RT
> atomic contexts.  This new flag will fall back to GFP_ATOMIC in
> non-PREEMPT_RT kernel. GFP_ATOMIC can continue to be used in contexts
> where preemption and interrupt are not disabled in PREEMPT_RT kernel
> like spin_lock_irqsave().

Before we go this way we need to really be clear we do want to support
raw_spinlock (aka RT) contexts. This is a big commitment because it
dictates internal allocator locking that would have potentially a much
bigger impact long term. I would go this way only after/when we conclude
there is absolutely no other way and we need to have allocator in those
critical sections. Now you have a single place which complains ATM
without much of an explanation why this cannot be really handled in
other way. Have you even considered any options to pull the allocation
from within the raw spin lock section?

-- 
Michal Hocko
SUSE Labs

