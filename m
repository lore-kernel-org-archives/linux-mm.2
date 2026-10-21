Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBF4606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 05:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=az3SLXgj
Received: by kanga.kvack.org (Postfix)
	id ACF016B05F9; Wed, 21 Oct 2026 01:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80BF6B05FA; Wed, 21 Oct 2026 01:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D516B05FB; Wed, 21 Oct 2026 01:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0FF6B05F9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:56:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFC671602EC
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:56:32 +0000 (UTC)
X-FDA: 85345573824.20.6924237
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09638180004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:56:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=az3SLXgj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noqW2q3tliwA7l9SCHRgFT9oXvb7LtEfC22fYjKJb5s=;
	b=XB3Iab1osWmeG+xqM05tyx4ze4EEiRuXDyV4O84ZDvyoM4RhLPfxvnlej9ZmTjAYYmLauv
	oXsNf8bvaT15/wfpQYRFEa24EA2EubVdB1S+l8KnnTKEEyUfEINlxILBpA5GcBXsOIkAoH
	tZUFQLVTHEBbtQgYK4A+5JBLmX17seQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=az3SLXgj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562191;
	b=JsGNm1XLoKufmp02o6zNDVO7ao9BAYH+TlkUYogw8TZwmuMFlZVBsIQawmajJ8DhUMtxBG
	0Q/sREUD9MugxLBXwsrUeISTkCihF5EQ8eK47ii/5+dvSrngf3P8fOZVvW/+8mlOJDVcIv
	6211O4tc/s2rg5NTxNGK5Z6T9yG9qS4=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1df4c0966so1783025e9.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562189; x=1793166989; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=noqW2q3tliwA7l9SCHRgFT9oXvb7LtEfC22fYjKJb5s=;
        b=az3SLXgjC8SDd+HfKFWziWASsfUFu+jwLIGQNb7vZLj52ELkjHkTIK/eJ/fiqHzOLI
         n0oquIWPdLu7RFVqBq0VwkG5Tnzu9aPYyM13pmzAa3xaDpuclC9k2LJnuA/eqE+BtE2v
         1m/EdAoi4fdNQy710RIPv5QXxGTUWE+qb+h+y204lbZxH33noIxcHj5doolpfAfTwA8g
         MxVT3MnCThV/q1mdSUTSwqfipbJ237q9/HbnTsNkuY1W96dCGI8LjDu3lfR6O/WlkZi+
         5YS54KO6R1SH71LelZwBxW2OQukr4UWqIGADYE1JG31WSTHlynqVdhCq4AblEl8BFZzS
         p3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562189; x=1793166989;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=noqW2q3tliwA7l9SCHRgFT9oXvb7LtEfC22fYjKJb5s=;
        b=sHsfR9HfCzTvqM2jPe3VXVW/835BGk7DwePvKcL/Q5q7U2MGp0xpA9zVBBKJcObzjk
         l1le8cADhbaXSaFBfQH/ZMN02oDbJxEEI25fI+jlijPCU+k62Ar1pjoexO9VvOVXG6sz
         zX1MPwWj4L1yqKiY1S7sahQLobd66cce312AyyrQlUquBw7r1sju7mxWo1uktJ2AOwxO
         JtPhrn3YIfeLA/XFZCJkX9AYC4wvj/oSAW5C3doHlN3R1sVo4MVamH8jMCD5NlmjlVnm
         Z6BUC1N9FhkpZ774Sh6cS2Gcnceg2PImhyHaukUyf8MoWwDitV3yQpDg2HwO2xTO0QVq
         J94g==
X-Forwarded-Encrypted: i=1; AKwUvBx/8VlQQBBbVUF8jc+UshnrG+al3DMZwjz42Jf7ycCvMTVwWu25wil7K75acOxpxg8hXORiVw2FCQ==@kvack.org
X-Gm-Message-State: AFq9FYIox7KLQzrSxLnFVPkv7U/+7w0y2KcLoRZmI2wSjDNUUA9f8V/z
	qSzN+bqTw8ON+Kgp0GCOsY+0y7ccBDQE88xc+B4Qg3Qx5mtnGLtUeRtn
X-Gm-Gg: AYBFou2F3GwmljhB8HwKmOMY+9wfkqS9IvVNzjIsL9ztf9p4+BF61gJi27l+AF4DR24
	Qg4YFIgL3Kxv+UI+mOnuaIqBTQbeBNkmqqdyspeDlxcKUrUJ9ZVl7SnNWXZKN9P7TOwvQ0P5x3g
	tAbgdtDoqScbHfmKE9qBZklShCptnv5aDuyd82F81tpRgB/PYMBBrW3f36huEqr+ve2wcVieD0d
	fzgDwh9cKBxWnExsIWaET902QOj/TtPVlKH3gfuN9pnC0CGWMnstOW5bN3Pcr4Foqr2ovqLm4E2
	aMTLIkjfHKGiVosFrJaxFeRCUB8DwcqVzDa3tjfAtRhYFtJoCHoHZG78/O0+jywo+9yqKFZ/tuT
	8i9OgMrPyqHqUWznbiMIkbX7efI0mn0Y9HuUaEAvsyV0j5Tp0Y3AX8UgEO3k/vr8dmyTdJh4LzA
	/vQr/gRVJpHrm8YmIOSWoumUxOKNeOwWb9X/VM/qdYnfkcy1QfJonCoYckIN2S7BlTzCONGnN00
	OnCsRLC7+E4amRANdhRQZKRJXdJ5kY+P/jCj/tGxEAqTYYUwryVSta1CY4D83QEPxzCeIR7YUa1
	+uPq2adug8yArQp653c+LyqPFJrbjQ3NkdCQPZN3OrNnSgIf09N2v8SvX429Xy1Pn6fKC/oM39R
	gbgd1SRcf9C7KTQ==
X-Received: by 2002:a05:600d:864f:20b0:4a1:d49e:9ce with SMTP id 5b1f17b1804b1-4a1f4c4d55bmr73200075e9.2.1792562189221;
        Tue, 20 Oct 2026 22:56:29 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-095-117-105-001.95.117.pool.telefonica.de. [95.117.105.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25835b1dsm3374756f8f.40.2026.10.20.22.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 22:56:28 -0700 (PDT)
Date: Wed, 21 Oct 2026 07:55:55 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Alexander Duyck <alexanderduyck@fb.com>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: skip shuffling and reporting for no-lock
 frees
Message-ID: <athTqt0vljgHb8q-@gmail.com>
References: <20261005063515.6312-1-kmehltretter@gmail.com>
 <f5e7b114-2bda-49e3-974f-170211501203@kernel.org>
 <20261020110948.wv_yGAhQ@linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020110948.wv_yGAhQ@linutronix.de>
X-Rspamd-Queue-Id: 09638180004
X-Stat-Signature: keum8xwtnezym35f1bndxsmyoj7gcctn
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792562190-558234
X-HE-Meta: U2FsdGVkX18JboR78L/QbOkHyAbXoSOo2ZWa/pDokv2yK0OA+du/ep0pLPFEwjBv+jb+3dXiUjM/r8oz1xlv6z++uCwApEbIY3/e6CzqLI/JIpyekjddfE+lSJqodohsquWfYCUmSX8rBiI2Vj2YI8xVbFzEVkbgt9CWG+2l8mrgfna8bSU1ploK2bXlYOvvvGHOQvDbPnH960g6/OoS2hHnSuXUnYukd2Ii1IWU1O/I/M4IBDdJS1BOaVEh+Z8zU9VBJWXTph5xJtd+kmcI8SABy14NtoJX9pzXLPkHqgsMQ7KAQT+QfR4KLkTs8ttOAsQmUA//9hmLZ0ytfuxJzBamQl9FfQZ4bhCu+6LYAjknIVU5inRhOra5/C4/vYR03neLfhtLWUMpUDq8VbEnbpIOuJp6aTBBJAdTOGpUP3JEscbw19XIugf/nG0mtqXdQL8oXFYo5WBkT3gDKFqLPIJSRD2f3GmFmFt+fpdYbDtrmn9ySItMUQvukgN/LV1QOS/wbdZBO0Tw5y7WUE5lL9ULKQ7TeD2rT4VvLQ1x+rS35A9of4Lqq0tboLkzSmJ1v58cHED6/WrLidJ5BSkR+CWlBUD/0qllxAFi9THa41Zu4NzIUVL6afYqucuR4jC/lNagI0IBVksrjartl1V96cJIg+D8GotxBxL+ODppKmPWb1HzoORNtFVpzARI/T8t/8psogN4vay3oZ3ngDWktQz974GzuzOZXfydIlSVS4G8SYC5IpgEwT8kDz0yQSs2VtX2pCUTntj1qOBGy0KBmvUjq6mIFW1neFcnZ9veonI2fo0oAbUvUlvq2vRgPyx4PLyxs3En/fqYGu2yb0opQQ68TL8V6UbcBLwQSFAKbaMYhr9s/EIjsDyEX4WpszFzx7CZNxBCLCXo97hYA5uzZsUz7Y27Rsdns+ZxGzqDOerX4tHGpzDkp5zpFIOKp81mcG84/BqlYtt3lHIF77u
 6YzFEr9i
 b5wpyg62InERNsCAOri8OnAAtu9KQjR0JYa5Fv5muuE7ZTWSpDhzOELa9TDSUoYVaVB1xJ1jmlWgpC8Wd3uXChNv8Eji/Xf1rkxmFw7O4mEhrgdsOshtD5cPHBatf+xry8BJUZoLtJGWNdba3vERHgdxle8qozQnEDvc1z1RuEQpS2k/r2/l80TnKNF+Ve/8X3P1n+JC1DL5k5zKLFec4psv8wX1LuqJMcmJVS4j4H3nQyVhi0mQKM+CxyLyFzBj0It3FZ8RG+x6mBqTxPtWQoGuBpdy2GWhqiU9RPJluPiFFS7PTrArqlyq0eNmelc2R70V+X/vWCCvixtZ8MliovDvAZ05n1awbP0yLaXEllZ69SLH2yCYr1fLy40MXBDumq9KL6w1rK6hchaXxxZEh2OBEnr1PcsxNxnwD6nOjGvhsY/B1EODc3ElRUl0/+Ia9l5WiTivU86Q8tuwHIt5tJolwRakUO5Y/FxNa/59WNQsK+e0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 01:09:48PM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-10-20 12:02:01 [+0200], Vlastimil Babka (SUSE) wrote:
> > > An instrumented PREEMPT_RT lockdep run forced a random-bit cache refill
> > > while calling free_pages_nolock() under a raw spinlock. The unpatched
> > > allocator reported:
> > > 
> > >     BUG: Invalid wait context
> > > 
> > > The attempted lock was batched_entropy_u64.lock in get_random_u64().
> > > Lockdep showed the raw test lock and zone->lock both held.
> > 
> > In slab we solved this by using prandom - commit a1e244a9f177 ("mm/slab: use
> > prandom if !allow_spin")
> > Could be better?
> 
> I hated it at first but now that I looked longer at it, it is not that
> bad.
> 

For v2 I can pass allow_spin to shuffle_pick_tail(), keep the cached
get_random_u64() path for ordinary frees and use per-CPU prandom for
FPI_NOLOCK.

For page reporting, the issue is NMI rather than raw spinlocks in
general. free_pages_nolock() may be called from NMI, while the reporting
path may queue delayed work. I would keep the FPI_NOLOCK check and add a
comment explaining it.

I will also put is_shuffle_order() first as suggested.

Karl

