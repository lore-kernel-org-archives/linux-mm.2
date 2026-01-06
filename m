Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59034C47BD5
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 09:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC9D6B0093; Tue,  6 Jan 2026 04:47:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C4E6B0095; Tue,  6 Jan 2026 04:47:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A246F6B0096; Tue,  6 Jan 2026 04:47:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9307F6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:47:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DFEB1B738
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:47:36 +0000 (UTC)
X-FDA: 84301061712.23.E4AB171
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4200C180002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:47:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a4Hk70mo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767692854; a=rsa-sha256;
	cv=none;
	b=u3SYHPyvWBFD5NjAdW/Q3xYUA03O8yKPRzOrHEJW13U5CKcOMhAKhIqBUKUjK9OqvUx+0y
	cxgqT2IFoMFEgKLyC3qDBe8dfh4I639qXwjXyCOj3W6qg1n/MOHMDmYVwDdtcSEtFrDkGL
	EuHevLplOzwgTNzSZCMX2iCtp4cLN7M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a4Hk70mo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767692854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWbwJwnDTfPjdPCmjmHqCRdpTs92qDux6TJ83FRvhPQ=;
	b=rXxqqaDk3gtNhBU7J92EqhRL0FJ9RQDhK+jjizUSKe3ENmmzZ67Vpwx0dWDnlFZLIwSoHj
	ME9lmBJ/NUfP/7nHWHmUFjz+2qybgdFVzMDixxRTgk8otUPkJEmsUCjt8fglch5zj13dzO
	SExaSGtbJiL1vx2FrrMof8UCaJ7OkaA=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so513375f8f.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 01:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767692852; x=1768297652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWbwJwnDTfPjdPCmjmHqCRdpTs92qDux6TJ83FRvhPQ=;
        b=a4Hk70moiNBL173KnO3/HCb0h+ED1vMEdpW6hXtu09Wa5io+gTXQhle6+kbARIO8MP
         9+6CwyV+fxCGCbOUEcIqBCt1JO3NKxkXt/1ARdud5eL+Pc3GehAT8zdFcobbdS7JvqlT
         yxgQZz/5T13Sa6wR5epq6uFWORpivaSHXldgh8HbWus56xUR9hsso4L4Sy2UMMDyzskm
         XNAWvLdH2fjsrX0/aBiLccT1yonYTfjMF/OPeAUqoeRMUtGT1qdO16m/pqH24UrNQIuq
         ZBwP9fC+QpivlVJG2gQpQztKTNQB+g/u7bIl6CSJ0euL2UTBDDT4J8Kdn3czW9XU0VP+
         fAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767692852; x=1768297652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wWbwJwnDTfPjdPCmjmHqCRdpTs92qDux6TJ83FRvhPQ=;
        b=vXa4iAmTfsMQ1OR3VsurRxjKr8DyK7cNlseZVHzNlg5PxxQRByRb6sTWqnKehZ4fug
         eTrPzxhzqFAL2XJMVg7KlHV4w7cbi1iX3p6pfxFuFxyhZoMCRNAZ8xSaKt4kV1X3iojd
         rNcqTL0zqSQFlqprsZScA3a5ISPzxrD0msE0xTOY4GrZhWmJw/hTws/CWBBnDlf042Hx
         eUxOgjk504AOsq9sGFMTTQ7czHnU0BbOF9iI5PxX4lQjz8CxkCcWeGBuho8AfqbIIZ91
         4Wi7yKrrTXUin9Vx62Nb8/aYEJT7PSA/9zphS8BU2P+NsSBJAVGF4FYotWlxNeVCg5On
         hxTw==
X-Forwarded-Encrypted: i=1; AJvYcCU6uj3q45XktJYXjpDN+EM8nVth1ZrBl9GGBcPnDxPF2sP8Gf/RChC3eqTy4XuLilsHbm8h8jzYMw==@kvack.org
X-Gm-Message-State: AOJu0YwqnIAgueCImjE5DXeWvUaCN23jlmCnfVGBhV//4EyDmvcyBhXP
	EjB5actvc1QQa1JbJoBdLCwPjHUxt56L4s4JfklHkj2qjKBsu/azxliF
X-Gm-Gg: AY/fxX4C6YITVQbuPIo6BmtnDDDQgJCNA98bUeRyGXBvvZqj4dKLnmKTeMJ2/orGS9f
	Wa6RpK6DIyc3G2UZDPevbwd4/1eXJ44X1kGFTJsdweRaSAezrJf0om7CMcaaq3Zz7BqnPkJKc13
	73eVfl2B/OeiprehuNwNaXgrdT8JC4nhT0Cg4kyM3jkmHiaC4D3uED7Is4dKPfxvvhwY8gtr99m
	gxkwdN83HUDoqklmfcL0A68HWjBPrTCIasgWB+YY6COFfTHnV1Nvv/6eTOjgiRs2NOR0yulfN4I
	pAiYAXmie9NP1KdOZE9S8jDPtNeonFpnST3LwhxbWkH+qu46LnNzRpO8QZ6i8z6CO9fE2fA00gm
	OEFjdLW0RYgpPAO5BAdtQc9zVY+EL8lpDSlA/ASB5+dCUj5ahFIbjrWKEQGdznmlv+/bDKwqsQX
	HO5m5QNkHCAdAVbUBL1qgRPunQWPPe4ZeDKm7L0a+Kc7lIGKmD7trM
X-Google-Smtp-Source: AGHT+IEJuXARGSuR2ZkRliwbvSQyzqWqgknzwJNvwe/R9c1AH9eJI/Brwr8I5Q4AyCGkr5RrUvSiZw==
X-Received: by 2002:a05:6000:1843:b0:431:266:d135 with SMTP id ffacd0b85a97d-432bc9fc654mr3482602f8f.52.1767692852347;
        Tue, 06 Jan 2026 01:47:32 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ff1e9sm3541857f8f.41.2026.01.06.01.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 01:47:32 -0800 (PST)
Date: Tue, 6 Jan 2026 09:47:27 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Uladzislau Rezki
 <urezki@gmail.com>, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] vmalloc: Optimize vfree
Message-ID: <20260106094727.5bea5ed6@pumpkin>
In-Reply-To: <aVyRR2-fdvJ_9JNy@casper.infradead.org>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
	<20260105161741.3952456-3-ryan.roberts@arm.com>
	<aVyRR2-fdvJ_9JNy@casper.infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4200C180002
X-Rspamd-Server: rspam10
X-Stat-Signature: 1gan91o56gt7k7xf75tdnx1o9gp7o8kp
X-HE-Tag: 1767692854-857966
X-HE-Meta: U2FsdGVkX18uyswzYGJZvh/LuOLqPeIvvGUkOEx64dQP7JzPn1EFILoP+a4igEpe6SF5NzZqpVVbICfQiZ6na4IgGsD3eqzA0KUkwprPoJMbL/m4uPPkX3r+pMwl2ZIKS8dOHYhLWBHuBi3ZQyK+KzbUGceMUY6o84//GsWNlYQeHQdPzQKoi/Y9/QJ2w2w/XF8BAl6IowLsXIfvl/iXbGQrlDGTAxNOqDIlZ5V+isDg6rZY2baZ/1I0U/0HFbJevTeVplf7+JGnXlhoNKF7ruM0k4lLoPyXRrHrVI3NM2EfSxiwLvtJcQ7j491Mm3nNa12mGnv2QcUyoKGpF87jJWlHnkTSVGd41sOWz31ENULulUhBfx7aUtn/cU6exJWB6jTORd66CFiF0SS1ie0u2ZdOKAXuOA5Cy+Of/156UCOKbRjU3tuB4Q+rWp0XoM1rnjhiS30MMCEal8TK6iuxC4sNgAGqg9yguQ1p9l6y7GUP5Eo6bgzxED8mhWsVW7Ntar1yIcK/3Ji9GH8eoZlwwhEH/MjG21qAuHldS//GHcvvXRAoQ/GpZ0+GAEH/L+BtmqiNkIamm25O1XXKwmOH4W9UCYFQfJt4po1ECy2u+RNUzDZ/UsihqyNld9YH5fmUgEKShHJw3GbCKtgbGiPQV16177ApXejBMC2fgGuILEps5b+s10p/IaulMNneYFH8J9r5LjQRlMifzkc0AAxuI/KjmuiSSscZr3Ccb8QCtUf1QS/zn1AXJfzM/dLdZre9FJNSr4LMSmT9lfwT5jqIPB3qU5RmiUZE/wuR11gfSelJ9ND2yYzFJ0nmnscjNbOjtqiHM6zeyrCSxE6JxSlGDz0ZHj0Q7B1QXIIObe5/TmY9DGpuEBugu6Yg1fjjIEuDJRhHxVeR7ycyGu5WXo7JM9CyiybSjJEl8MmyQZab6WCqFPq/W2Zma5WAmNBrIbvejFy99tMkTytvWlvkrJs
 teJOe0iu
 m5KhNIkOtddd9PD4yCRBwPYPRwofMVvGXr270nckIs/yB/q4CZpBi+fWq0gu1Dznt092STGSKBIT4KkY2AQGIBpJnbALkiWWY1Kl6c+EfRmT73l18kbjFSczU+KAgfuWd8kJQSE3zbTGoc4rm5A9Aof7yAM0nmnvi/u7gKLTG6Ei3XlqIjHU3nvlI1+m5W5xWeS/NQ9P6tYgJ8jqepSQCllk4muShH+JX1croP3oRgHRjZjSL957Q9xcrM7fdAgHMtHyMOWX2jSfZ2RKXNY68PhOaiwMx56cBXaM4Q3tBz+k67X0TuB+ULM8ekbiu23NhutaKdf49HDwVhAuRSd/na+M/gPcR6esb/OW0LsPUWcRkXr5trx2aGPz7hPMQhtOYs+ulUjcy6K/Q+nJikgtQo4RaBivv6UNlTxgfrcaXbaK+6fPQ5/Ai7o5cfY7mp+x0dsGabZvJXLuy5j4bNzUK4/ysoM/fwZGf14zefWpZIimRWCzalYgEixvbL/yM7YCfqJMY2HSkPi8RSz0PhRprHwjfhoIsfv1DcUTkwUjIXSRJgKsVbpUETRkpoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 04:36:23 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Jan 05, 2026 at 04:17:38PM +0000, Ryan Roberts wrote:
> > +	if (vm->nr_pages) {
> > +		start_pfn = page_to_pfn(vm->pages[0]);
> > +		nr = 1;
> > +		for (i = 1; i < vm->nr_pages; i++) {
> > +			unsigned long pfn = page_to_pfn(vm->pages[i]);
> > +
> > +			if (start_pfn + nr != pfn) {
> > +				__free_contig_range(start_pfn, nr);
> > +				start_pfn = pfn;
> > +				nr = 1;
> > +				cond_resched();
> > +			} else {
> > +				nr++;
> > +			}  
> 
> It kind of feels like __free_contig_range() and this routine do the same
> thing -- iterate over each page and make sure that it's compatible with
> being freed.  What if we did ...
> 
	nr = 0;
> +	for (i = 0; i < vm->nr_pages; i++) {
> +		struct page *page = vm->pages[i];
> +
> +		if (!put_page_testzero(page)) {

Do you need an if (nr) here?
If nothing else something might complain about start_page being unset.
Is this a common/expected path?
If not I think you can just 'continue' and it all still look ok.
There is also a cond_reshed() below, if a common path should
there be one here?

> +			__free_frozen_contig_pages(start_page, nr);
> +			nr = 0;
> +			continue;
> +		}
> +
> +		if (!nr) {
> +			start_page = page;
> +			nr = 1;
> +			continue;
> +		}
> +
> +		if (start_page + nr != page) {
> +			__free_frozen_contig_pages(start_page, nr);
> +			start_page = page;
> +			nr = 1;
> +			cond_resched();
> +		} else {
> +			nr++;
> +		}
> +	}
> +
> +	__free_frozen_contig_pages(start_page, nr);
> 
> That way we don't need to mess around with returning the number of pages
> not freed.
> 

I think this shorter form is equivalent.

	nr = 0;
	start_page = NULL;
	for (i = 0; i < vm->nr_pages; i++) {
		struct page *page = vm->pages[i];

		if (!put_page_testzero(page))
			continue;

		if (start_page + nr != page) {
			if (nr) {
				__free_frozen_contig_pages(start_page, nr);
				cond_resched();
			}
			start_page = page;
			nr = 1;
		} else {
			nr++;
		}
	}

	if (nr)
		__free_frozen_contig_pages(start_page, nr);

    David



