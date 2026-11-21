Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862F560A2618
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 04:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JKYY5nbD
Received: by kanga.kvack.org (Postfix)
	id 6A5B96B05B1; Fri, 20 Nov 2026 23:35:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D8F6B05B2; Fri, 20 Nov 2026 23:35:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5983F6B05B3; Fri, 20 Nov 2026 23:35:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24B036B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:35:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D768160335
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:35:31 +0000 (UTC)
X-FDA: 85457862462.17.7C94FA1
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 572321C0004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:35:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JKYY5nbD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795235729;
	b=ENxri7o04B/ryb/K+3KaU2PW+J5ofaXLgxuGZ55luGmnR/YS43ZNUu4HyrqJRTIBNwsS76
	F27e00bwTBZq9T8KaQEH7hMNf97VUinqDjhWbd6zgejd/gm3XtC3PfKnzu03Kg1OEw9nF9
	65An/fXbw+L/mT+9F886Kw9hwvjIb6c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795235729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9R6zaVIvtgH5jzl+qiEpRbTjV5svwtDU6V7VCAEyGSE=;
	b=rGtjCqf3bGs+nh/6QPBAIdBDZVh/qFxmchsudPRulxwFe13+LCLdn2Ci3/HzqupYZmNxpf
	hKhnyFg3czf7I0OKHcqcHfKUy1YDMU+zpWwbtW3FloSL0SfRn+0VmyA/fZG2k5FjTwrPDc
	iSFpNnmyEvNPtHNIZzthmWgGya+KfkQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JKYY5nbD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4a32576da88so907318f8f.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795235728; x=1795840528; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9R6zaVIvtgH5jzl+qiEpRbTjV5svwtDU6V7VCAEyGSE=;
        b=JKYY5nbDe/RZ9YNKMEEFjt4OWgpPth3qmnM9QfEu1wu0exRM6h/m24LZ8zBX+1gCa6
         icSMlfaFUd469In18+Q86Yj+SpI73Pv9ukMh46fxSjLwoER9NaOsj34e4nHmVJsb6r8T
         pub9lm3xzbXVJx2expaTwhr3atw5GQeFJIIiQ6WUibvLEkT/R/b5xTcSAzbP2VT6YoY5
         vkG3/koAm9zayzIzrxEjqIUhTIQLpFl9tNwUc8Hz8Lg3DCkmTiysBSFIUChILzLJX+BF
         NU24VhOK/F7/48i11z7EqDq/ojdWrtWQeFnaVCjIrkxgoFgG4FY1t2SQj5rvyRQE35WY
         m3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795235728; x=1795840528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9R6zaVIvtgH5jzl+qiEpRbTjV5svwtDU6V7VCAEyGSE=;
        b=AccAN6LhABeJCQNRv4vToraaTEhjAFiLL2UvlvUlijqHbC9W7GBFnYZpdRI5uGx1rY
         pA2UKyGsZwYvIUQWRWx6UOo/Oa8mViEA5RebaWDca21uYEc9S71W4B+QVd3bnEV8Vnfi
         CrVHje9GJ1B5/fFARETbxFvZMyzYt5spHA/9bM7+PdDpHZGJmT2THBNQ7zI3eTiuqM7Q
         9nm2WYCba5r2snL8p0jlzLOrEr4gqky2AQ3pQn5eBOVThF0zptl5ReLT9ceIk2jddvMX
         D3z/1lVXGXGn9G2d7Qx31+gsfgjAlWbbdgNEAzW5TfvUHkJMjCH36GbQ4jeSK0WY4GmC
         6tSg==
X-Forwarded-Encrypted: i=1; AL+hErFh08cE7FywXBih/B4XYAP0U+xVtNnL7mao1Ko3f03KDDE1jKhOjt2F++oE3X4Oo8EeqHlTvaQFkQ==@kvack.org
X-Gm-Message-State: APuU4Z/oZXrycRRxp8K5WAiYTRAv5b6S69W9FGKrxRfUF2Za6Hcyrtyp
	7D/kiA3OvmrB1BQr/Ypt3nCQS2g8llFxUcolaFV0bSliOTEK2WzUjNEM
X-Gm-Gg: AZFdTZfbLmM/tp5XyncK0YMpwbJ0SehqwuutEnuXcTPfop+oJn1PdYBnONt10Z0LHtf
	QbST1Rr4ibNwyQU5UXp2KCMUfwOnDVZTKWKBnnsHT7NGmPm1pIYCpoNbbxk2MYbG9T/cA+kRpEN
	XDbWeh1aqkZnj1IgU3eFS/a/DUXibc2vIb2jy1lR7yP12keEwqutAe5+shu7TUdUiejjkQzF3wk
	Z8oypluMhLMLjxucZCWpS00zp+55j0DJ4ryp3Z6/WKgwZDsshFWYbWOUwpiu1s1zFOLEkjgsnUd
	Cdwezq9GXP0R6JH5BXJSafgL2EysonNVXHLq2s/j2gDjdeJN9TcCJf05a6fipfQ5IKX1iucq0fJ
	/O8mMxJqQckh0iD0yrfnPfprxYt/8wcCRT/xNrzgFO+b2BO2r3d+UuWKqbAzXLkCxcFANk/18af
	mrXk2WvUn9qHuCMlhCBh5oa2KrNNGpEJ93afKLYHXUijI/h1PVeF4S1ZTlXhLMGroAKgMcZMnGy
	W6L0ZJ4Z0Mr/RwhaSjpgmLhwh+WLs8icQsOEVUcnvPTETuPDz3uECXpUNahz5pUlX3iIh89L3lh
	OJoSGI5mxWRCCgFTDlkrOjDTe30pnJWBaq98a2pAROYyijx30oMt7QQV9fjyZjzHofEXJkSdhB0
	zDenX/lVwqERWkN/ZQW/qgWj9P+5hIAGcXjwgDqMMpe1/3cXCPuv6dk9CC1scxwpNuhhYDuF+As
	YWOwNML7Y32Wk/2mowLd+hbhb2b43Cj22q
X-Received: by 2002:a05:600c:820d:b0:4bb:7b4d:6396 with SMTP id 5b1f17b1804b1-4bb887e21c6mr111271405e9.3.1795235727586;
        Fri, 20 Nov 2026 20:35:27 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-aeb0-6801-ad74-bca0-dc5f-7242.310.pool.telefonica.de. [2a02:3100:aeb0:6801:ad74:bca0:dc5f:7242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8526cbd0sm214023515e9.0.2026.11.20.20.35.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 20:35:27 -0800 (PST)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on RT
Date: Sat, 21 Nov 2026 05:35:13 +0100
Message-Id: <20261121043513.20538-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261020152708.3atPlnSl@linutronix.de>
References: <20261005070625.8871-1-kmehltretter@gmail.com> <20261020152708.3atPlnSl@linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 572321C0004
X-Stat-Signature: k6o89nf3d4mjyn8yc3nyykrde836bdyj
X-HE-Tag: 1795235729-4091
X-HE-Meta: U2FsdGVkX18zI51Cu1neSHB5XbCoDgTm/egyDo58ivhngGivqCWG4jJ15uppHz5PKcQj0CVx9GdvgM7/RAyelpdqnyc7dsWpMo3SiBJdICKcABk8p9T4wd7SSLEwFmSV2XnhmLr6m0YAk+WCY/EHVJUu5J02ckc7vBGMw7huVZ2nS0/bXdV6oTNIpruFXzvsR4ASqPChACRn429aUQhbfF5OR10Dwzx5E8gml6JX1CIx4VrHcWWoKcHsyQYC3nsyHsKusm5HsIlczaQ1i88Bo109I0b8Cw5wGaCEW954Svmr0NwmFxiIRUYg/YnpT5Hs/gBcGSWtAQB3qPBZNS5Z7J7f7wQnHbFOGPe1UU2/rwoe//1Okx6h2rL6uGrfBEDKvCyNIoEs5GBxAhA00eOCPNdfUsccB16vLH9IIJ9p36kXZlMQE+5DZM52o3WvEQvyAa5XVd4N9Gs9ZnKvov2mto0/zyr18iEAcKKgh6CbR7boPCuVtzYFnrW/6yUwSK9mMOu143Lq3RlWIePn2KboRQbm29AKSdlw6hokZZINveuRmGUXeSAAWd1EePP9Y4f9QD5T8ebhtIjXqmmoZ2sKfW324Ro5BkOhDig63Xlt4Rms8WZbuvv+MQpQFReHlDrpJCw4VQy0pdiE63Xw0r31plZ2olbwPtK/2od5WT9v5DA09H2mqRLC+Sy0S1lHujIKP9tcm6vI7hXkkUvas+pYNoNNBi7/lLuDzuWaRFxm80iF84k9seG6e1o1eeNV4DVQQsMLhafAXbKQUJiJq27EMv0SdL6xRGqKl3sdx4wclJ7G5isqZnXTPjCX9yyXsG+eT1SxYTEq5y83f6KdCyW4xLCFhOtuIJg4sZ6r8zlF1kCtH8LipMjaea/T9Jn0sEmwXtzHd0DoHq8+xETqjeU/PILeOAvrxzEYeW5QhO9KTNDOLqbXxnOKv6hBynIB3jiWK9A7r9N5GGdrlsLpCmN
 ep55O++h
 sdJeQ75srge9f/5lWwlVEVKUAgQvqcxnTE5chMwD1DH7Y8tPdA44jYEv8xC6twhV7xVAZy6IEkEsCwa9htByQXln5eO0q/IfPENpmTDuIpxsl/PD+5oBAE/lO8x29Ko2PDWs9ywgyerb9asTkQ34SDTcbLHWy7FUscoQhYukY+u7myHL491pfPYRywMAjs4UhUAvel5bidMZ0PHbr429gGhwacIxO+bQKEWYTxLUtYkaGUO/UQSAv3MBPAOx2T8faPl3+69oksBvsGzeGe+EhGYAtgIp9ln7fRiW4tX77MD2RfXnFsPttPxwm1I3bPEZZRkWjjICFGP6dVtymdwRnS1dQB8PeKFQfKadVs4AqzAgp+UY+itmZWEZyBng1byo5IvSBdA4xcPDYb2GUU8tUpjCgq8E+MeRXbOToV9aX9DB7FpJ+MjhTnaPi6n5gHqROIpWQ9rZdmZFA3fm3FtduGQ+4Fez9aagILBSofiUmPKIm/qg0ZAmmgbItUSF6duEG1fmZ0hPXkii6OgAKhB99TW7Khpz16y+Yg6zGhzV0FI+begNfmYJ8am835JwSN9aL0xH818piPhzXTnESgUpmWj6ERtXUP8x2GRZHQhj4FskSuWaZG5Txsgs6ZVe+S7M0zPFoMb/To6QI24Vq7QDZdduwje77us2yNYYhjAdvJPux+9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 05:27:08PM +0200, Sebastian Andrzej Siewior wrote:
> What is it that you try to achieve and why. Why is !PREEMPT_RT not
> affected? Half of the problems origin from PI-boosst.
> Why has the nolock an rmutex-backed allocator.

The bug still reproduces on v7.4-rc3. 

GDB caught n->list_lock's unlock re-entering try_to_wake_up() under p->pi_lock.
kmalloc_nolock() uses normal SLUB locks. On RT they are rtmutex-backed, unlike
!RT.

> can_spin_trylock() skips hardirq and NMI. There is a trylock on the
> local_lock_t.
> Why do we have this mess and couldn't we avoid having it?

This was IRQ-disabled task context, so the check passed.

> I looked at the patches and there something about hardirq-atomic waiter.
> Wen don't have this. I don't think we want.

OK, I am dropping it.

I plan two patches: move range-tree allocation before arena->spinlock, then
restore the RT check that rejects non-preemptible callers. Does that sound like
the right split?

Thanks,
Karl

