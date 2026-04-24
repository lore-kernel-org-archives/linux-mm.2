Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4BAFB44C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D20F6B0092; Fri, 24 Apr 2026 03:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9A36B0093; Fri, 24 Apr 2026 03:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19BDF6B0095; Fri, 24 Apr 2026 03:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2F106B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:57:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CDE7A06C5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:57:25 +0000 (UTC)
X-FDA: 84692694450.10.4207787
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E65480002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:57:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KSzGjdl6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777017443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQWnF9NzCxgEjMbfmZKZ7IVW4SmCDS5kYe81JwXOOKY=;
	b=G2cJNAkBXHtxE3+vViHghhbwLODL2lDrfJpb+4h/pH2R+zbRXSWsHeOzCpPFtCX9sAm6VH
	AIvjZ+SR96QspezW28K9a62sYUbO+hQ8mpRNu0mZxQCv6hHE9kXY5mU6kxb/Ue1BSCfaQO
	ylCnhrRPlsGBAN7X1gYZJgImMDA8Ki0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KSzGjdl6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777017443; a=rsa-sha256;
	cv=none;
	b=Rlzef7Wr3k8Lq3cEOphJBjl9ZrjXS+C9RhoIlYKyx6ily2NqQsJ/SHImgxRRt6va2ngad6
	U5HcJ6cvnugF5ZJhklzeuhTUKeeikJ+ox7PQNuy8JV5rt6Y4eMIFIDdUdaMlRLyMUFXjAP
	0NCA96BbaZ5TADIwOh6/gqhiyRuwjTY=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4411e1eba51so4066135f8f.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777017442; x=1777622242; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PQWnF9NzCxgEjMbfmZKZ7IVW4SmCDS5kYe81JwXOOKY=;
        b=KSzGjdl6vl27b34/HFm5Cq14omKUoEv11QenW1bdRfojArq28nwFDZPO8g3QhwCOcd
         3PzqS+MV+mDHdrRfzgQ+Skk9jQ4q60mdOXmk4bK9SenSt7xfz6RyTgi2gjQR9dB1USR2
         PZA/618q0yh07rQ46oLmyTO7Lopa6nts9kwhIog468wtDvkuTIV5pklkdOmxAa9x23cc
         T1MuAfSwdaKTia2C7AQ/JWARJtb3nSFy54G2QGl3sI+cDNTUoPFeLTKjhRWsUBjInftx
         t0bOA9JVjGnQ1O0sqJ0hXhXFhIJFGpcK23RXIpduXHDXUBgO8VDJnVzrcqVNVJjUj232
         6c2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777017442; x=1777622242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PQWnF9NzCxgEjMbfmZKZ7IVW4SmCDS5kYe81JwXOOKY=;
        b=tCs9U/1XTYlHcHF4ltJq58Uf+9Ib74OJIjyplKGJPQBrKOe4luuqp36KyVlXd8WEb0
         Ncv0XjZqL+8wp6kVXxX5snzql+FmxQR59Lbz7SccZA0r808Jael5IBCa1u/BT2mCR/af
         kIzayOy2g4TLeofVoyScrS5qFEeQhWiD7y6wlYdKB1kbkW2nKHIS8nqrR6WdFaZGchBU
         fjVwN3ykkp/pGw8I9SZWRDIRyc91f/7/iiLIt8ZQ++40VT/EKoLXar6dSc+Xp06qtjAG
         bNEbb7vLDPyrpXHFZgQOoGW0HNuabs4fbcRXDP45K1rqUd/H1XePrTFCnnFNJPfNSRP8
         Hr5Q==
X-Forwarded-Encrypted: i=1; AFNElJ/xnRI3qI007i/3c2qPbglrh9iwA3BZiFtZVTIRbnqj56EXlbRtSVS3F7kl9qHqEGG15mcgpFOmMw==@kvack.org
X-Gm-Message-State: AOJu0YwOr6/W6OnkK2Nh8Ifzkxs6dIy4hP3lB4khiFSzv7JN7u0EGsoT
	nUsuwg4ZUSogvmBeU98ssvg+WKQoBlgNWundOE6YGan4VOCMBi61ER6SicXt5u9PS7Q=
X-Gm-Gg: AeBDieuzcCZuuwSs4Cn4EcdGub/Zl8NhPf3fVnM0OZaVLEZJ3tPqHb9mTadPKuvASaC
	66PpoL2fWLMizOLW39fbYOf9KM/jQas8myw5REC35n4eZPz4JfBCADwdYNnGZft7+TB1sim5F9B
	t6yFT5AujRD98DYF3QOTkNrQik8Eh52TCdWP3LUjwZhSxaQN+BE/exLWtzQLar3AyVkErtOW7dm
	q+271xUjLg6AsXSjx2Kq48TXh85KbhBg36RaH3a/SgxAbarvTdb/g/CEdC1CBsBinP/U4yd5yRr
	KI+hYZJuXpJ301DaOt4imB2JWC/PLOV8FqkxqaPdF219aNJb4KXGYlXAfmWqB9MLsN0FZXi7Ye4
	ftldJ9p6rQqjBKwm8OWPkqPXLdNwavjcIQSfbQw1plsUj3y+iHoFWZUZW1WVBnGMcitlDU4Mpo2
	BjO/O2Z046zXzqNWdqkS5WM3/4wRmaLN6ll7ugbOtTxuFJbtg=
X-Received: by 2002:a05:6000:4283:b0:43d:73ff:fd59 with SMTP id ffacd0b85a97d-43fe3db9bc9mr46929495f8f.10.1777017441623;
        Fri, 24 Apr 2026 00:57:21 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cc0d51sm59342251f8f.10.2026.04.24.00.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 00:57:20 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:57:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com, Minchan Kim <minchan@google.com>
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aesiYAumkLCyedf0@tiehlicka>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421230239.172582-4-minchan@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E65480002
X-Stat-Signature: ef19cni9ms3sge3k7jmp5afugycobxrd
X-Rspam-User: 
X-HE-Tag: 1777017442-694624
X-HE-Meta: U2FsdGVkX1+7xx4o8q19TelYXSCRxO4yl9ihxuhDTDIXOIiob74rvkyvaroIyVPstZBAPQpGtCHZ3HRrC3cl24aXhlKUCRr6rbts3HZWIFrH2UeRVG+hUaAvs+uehGeyzsLAJWAx2dqbtJY7QhDLr8zN3RNlpKVB5KhqGO6AGZI5BHCAs5wPk6wL2GQMXAZw7iGnlDKYE3Grtzrl8yA1LIY7l77NZ4BcSNSELEnoLlEeHKnY5iANQa4N9QBsPjM5M92qiCVslRiYfyFcqAd8HBWYj1sEJAq57LzDVRg6r5XaFryxJ3bl61wvCvQm3NUQK72yRpsCFdFXi8WcPYRr5HXKcfWbOwLxYNQuU0NFR1yidlcBg8L3TrlaAjxwMqy70kRZUfYafSVqHoNYKd2cQAy8ZkAk7pex1bpT2YQnad0COdNAMTtkmX3Z+zU9zPflxNNJ0Aqdzl70re/T9MI+5J7qKFYossfozK3ZtiQZbLvdnM447HveeDdI6GqsYgdD63QzszHVQFMBfRDPpBFjrlL+BUdHhBght1K84+k90egLyuk89yrC1CGLs9+RR3rQ3+u//ELh9U1As5gJUZglvu90xF8Fv6BNF99KXnDhhyQhydrElvsj5I+s7u73WNDCH+K7xXds0kGFXwDehn5UMn3zHDyTFM+gUpbu8H96Olvo6QRaakCLbeVsZC8piDrXC49rXw6qFsZ9exajZTX6N/JLiUM8e1XDAjhC8V/u9GMUcqhAgK1CgGmiJnJ9k9Gvn3vxF9rbZAMeRV6ZWaXMz7GXVsLX0IvSD523fdSRcmLFC5jJOqXcYgQ2dftdu2WTwhqtMFJ/ItlDERdTDqzZuLtqeWSXqLk6tsS73t/tCtK7pfyAzIpN2GJokqRluNVcSvGDAJfZ4Cg+rDfmmT0gDnfApW3oSC0RFxkSNSTh1MoVO4uXCXCnRlTSrrVv1nGgWXJVaUxlprdxhTRvwAF
 Wy9AL40g
 EjihEGoL1RD3PRUUVfatYSRsfi0Nsoksqe2mOrrVpRROUrR3XGGM1SI9EIPDnzEm+1VDcO8v3ahsVqVlNoqr1LzNJW36MSYv0Ot9Lm/o0gZlA0GZxi34/Anh+oi67/NMeD/TdnfDe37ZZeVs//bIhh0iKTZ52HCwcOVqJ/DCnKl1g3+H/+oxR/yIJ2PMpTQWgSwKYzbLHiC2xHZ0FBuFCD0pbmrRDy2lib4YpFxI7qk2Gv1QIrvgxl7JpxEfwfn48cvZ1g3YzqEoi8qaXIuwKzQbObMu/8I95A4GDzHQtbCARnhpKkqI8hu8OHIFeFn19irH67e5UqN+3goPMrdS1olvkU7cZE4qKWimqnofAIQ89/c8S69c5T99059gX0CNx2Dy5W3lIu03KOiawS44LuqvdQGgLNwED6Mcxrd+Qxelq8LTP9sPtyqQ37Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-04-26 16:02:39, Minchan Kim wrote:
> Currently, process_mrelease() requires userspace to send a SIGKILL signal
> prior to the call. This separation introduces a scheduling race window
> where the victim task may receive the signal and enter the exit path
> before the reaper can invoke process_mrelease().
> 
> When the victim enters the exit path (do_exit -> exit_mm), it clears its
> task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> leaving the actual address space teardown (exit_mmap) to be deferred until
> the mm's reference count drops to zero. In Android, arbitrary reference counts
> (e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
> VM accesses) frequently delay this teardown indefinitely, defeating the
> purpose of expedited reclamation.
> 
> This delay keeps memory pressure high, forcing the system to unnecessarily
> kill additional innocent background apps before the memory from the first
> victim is recovered.

Thanks, this makes the motivation much more clear and usecase very
sound.

> This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> an integrated auto-kill mode. When specified, process_mrelease() directly
> injects a SIGKILL into the target task.
> 
> To solve the race condition deterministically, we grab the mm reference
> via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
> Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
> victim from calling exit_mmap() in its own exit path.

Why is this needed? Address space tear down is an operation that can run
from several execution contexts.

> This ensures that
> the memory is reclaimed synchronously and deterministically by the reaper
> in the context of process_mrelease(), avoiding delays caused by
> non-deterministic scheduling of the victim task.

The memory is still reclaimed synchronously from the mrelease context.
This is really confusing.

Please also explain why do you need to do all that ugly
task_will_free_mem hoops. Why cannot you simply kill the task if
task_will_free_mem fails (if PROCESS_MRELEASE_REAP_KILL is used).
-- 
Michal Hocko
SUSE Labs

