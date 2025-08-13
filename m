Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED54C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 20:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9A59000D2; Wed, 13 Aug 2025 16:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90CF900088; Wed, 13 Aug 2025 16:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDBB9000D2; Wed, 13 Aug 2025 16:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA13900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:48:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E25D0C04CB
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:48:51 +0000 (UTC)
X-FDA: 83772923262.16.38F4C08
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id BD369C0012
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:48:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=RpgxAg2L;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755118130; a=rsa-sha256;
	cv=none;
	b=jsr0YNVbgm9Mx9y+pQ/QrWmbAXLGAy7HwUL+EHyEXh2x1o4gaJZ+2PivWdbIoGznrygLkO
	FKrulNwMbNzAvfckdxVPJTmms5R4CJ/LaZxy7Ei+jUaUwY2qxSFmgcJ4mgjpjphv5HtC8d
	vQNKoIBJwX5zBzpykQWwi1hlAt9Mizs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=RpgxAg2L;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755118130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QU7WwnnYzgxeH9QchqHrK0qbqQ+iKF1S/uY4NskNUc=;
	b=3CYW4AwQXlF73vIzPcIRXXd1eeTJAZAAr9WS5jN+982P+uMLNm8V3t+GMmpN1faI5XQ4+3
	lGskrfm1Dm3bgFPNnSnMat95L41Sy2R48aGAchigGp06PuhOSL0iLHx59ZlLjgLOsCx6Ut
	kzHFg+gPy2D+zkj8J0KQVSueUX2iRbw=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e86faa158fso39766285a.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755118128; x=1755722928; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8QU7WwnnYzgxeH9QchqHrK0qbqQ+iKF1S/uY4NskNUc=;
        b=RpgxAg2L19wnvy74ylG4tW5pX0Pxny5fRtrj+Vxe6/SLEcL74ZO/F35YvHgwjBdwOP
         TtyR5SCfsVKw4wFAJ7R+6F4NIkX8R119NhiKUGj9YGyNRaq8dGinRO8YMXUYcFvIoLtx
         lxorBMFXxSRE+tQ/XoB6hcg1Y+IcZOC9hVv5QYzj/J9GyrRnrv3IoauGKXz6/ACatjpB
         fcHLD2RTzPq5HeJIk93JVudjccMwLTa3CNyqGVw8vYiG6dw9ck/EbsGrsBHWIrnGkzaz
         gC7gFs9hAfsm2VO8OwdcLrNPq7esLLLPdx1lsr3zMK3M4RIsXw/fzjmo2rl9bbaKCKNt
         uk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755118128; x=1755722928;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QU7WwnnYzgxeH9QchqHrK0qbqQ+iKF1S/uY4NskNUc=;
        b=ltDbvOgFyACjTynvU5eNzuqnY5b+6XHuk3slY5/Rj5pFh4H16eBhalGg7MIYkTeQ1g
         YAVzRVuNQ80wIKxVNgeFt0HaK2cMQcoNJkFVsyQY7E0NBPZX1rCEFi3KeFYQ6YAn5jV0
         UI3PU13GRhzUfRQt2NpNuWdzzV+bhmNMR+k48YkfxBs+B+fj4lbwP+bxuhPmVfHZJjE/
         qIA1L1dteJDe2hB0rfCxRCsaQBzxLGZtvNIHSl7ifa+9P3ujpLRmYjV4Y6r990Biu6uf
         Z1spuGph8trF8Npwl7D919uHNJxnNqVKIPBwGa7SWCgBzDs517Nr5yMD2ZzpqIubBNpA
         xLzg==
X-Forwarded-Encrypted: i=1; AJvYcCXPEBC0ZpoV/fD5IW5EjGkoEbouLyGvNf5aQCvpl4RL/O6irLhLOQK6j1thPt3JtOe2eyqGPGul0A==@kvack.org
X-Gm-Message-State: AOJu0YwfJ8eKzqktp2bt3SEJOgGbmQL4v//sTWODyxUJr3GfaDWOydkK
	rEHtTbgMVK2Xt+bJ/qrXC8aHq96gp8D/fAZTivnwFA6NvuU2dJUdwApJi4/oc+ldGFk0qgD1+ts
	pnO9E
X-Gm-Gg: ASbGncvyIR1eK0X6QJK/9olKhkz3FT+hqVVbPhsYj3Kn8Yl7ZrbCNK0+E0nfDibf1b2
	qXWC1wT+zU8g7VjsGwQPg/wLpP2EMkWM48frpcZzvq2mXZqfLodoeuo43Q5zIOpIsHh7gXi0Bnl
	m68LtWYHLtbMCpOA60SNJuRi+tIkA47jL7ZIm6f1E416Yrzl7PeQjT+4ydLz3UkkW9pHm3Rcd6K
	MR2GIYnqqy6+DgMsG+Fh8v5U6p379CWP/QjaBrCH31nxGYHc+6QtBdjWgTSl7+JJ9bCaRsNcs50
	cXsg6ew9vUvZXeZCybR8u7+3/zYbVWQz68el2Xe0M5RTKCR3nrB13fAVElihM2UoydLi0IW9Eii
	3WuduHTccE0sePoULAHztPuKFpTsljwxM
X-Google-Smtp-Source: AGHT+IHz7GMMnYpZ4wiU0jk2n1e+DTQ8iUPbC7vlSKZF1R1r+EM0QvuCypZHUr0KQmfRxyjkSfm0bA==
X-Received: by 2002:a05:620a:a81c:b0:7e7:f2a2:251 with SMTP id af79cd13be357-7e8719ba2e8mr12990885a.27.1755118128568;
        Wed, 13 Aug 2025 13:48:48 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-7e85d4f5ff4sm372396285a.3.2025.08.13.13.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 13:48:47 -0700 (PDT)
Date: Wed, 13 Aug 2025 16:48:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>,
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
Message-ID: <20250813204844.GC115258@cmpxchg.org>
References: <20250812170046.56468-1-sj@kernel.org>
 <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
 <uo6vtumoy4txklyqy4njitf5ex4eanudncicbbzknmuowopd7v@jm4ao4qapiza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uo6vtumoy4txklyqy4njitf5ex4eanudncicbbzknmuowopd7v@jm4ao4qapiza>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD369C0012
X-Stat-Signature: 7g4ssfbssjfzjscgzxiz1mk6o93kk19k
X-Rspam-User: 
X-HE-Tag: 1755118129-60678
X-HE-Meta: U2FsdGVkX1+MwL2odwjZZBx02JM9n68q47v8onRvxmAboLD7Vg9dddvDKSFgICkZCtJ/8x3wdBAZ5gdCAtisHpYd6v192B1S1JgGtFNp2YPBl3j9lne0Q8JLHZMGfNfS+9g1PNM0kv3TqT+1gNxC5IRAP+gtex8mU+C7NX+lfQv9ou1N6yclp4yHOmEP62U8tAaAvgfEBWkpN30CJLYjOck0aq+Ync9v9acp63eNKX1cDIod8B1Z140Z/fdzqr2orEz4HQzEgGKXC2Rrc+JHtBHhdMwNDoDNAnE+umpq5DpnVwkLROPWrZQu95DmXRKqQyIQmMAsML3ETS4AoG5GrzWtT/uovX/b7Eg2trswl9tsIP8GiCpwHjKQl2VWEEhG2IkQVgj3yHtWbTkNMa+WORGy3Fhk1B6ETRKUqcYc0E5rYxkq9eKSFgRsBThaLUoqlVRtDO9SzpUu0W5Fjcd5yZbWNXMXWyebYkpeWjWqt/md3Zju09nJPrZIph59yk2Bk4dKf/gCSaxU5pTOxM/5XuQIvFHMq+HnjjdNj7UiczIk2Qc3aMIgah6COTlvsgjvMVJ4GH4SjmQYi91VrU7Om4zyTyVLojLFxmdniRYdK1lJaL1FVGSS5Dr0p+2mwb4rwUnASqY4Vur8SyWp6JZLiOzhWctG0FUp/n2efkJJl3cG8aum4821CdQ4vndTeXDCEmOz8+ojf9/wvOlY7WN+71Mjx8zQHHIm2Tog5Mo4V3paHWCoy+iU+sDVuoI9rnh2jtV4syq5orkwdG0biT1aRHcUseY1GHdOQNYwejK6JxYl3/QGcAF7zggg8q2V/i/zmqkLGANFHBkP+zuXjaBXXuL16+FJsn527dpS1pd1DTeklQwyIIxRKUhdi585fR4CtqrTwd5AG14zV0eOI+ns4JPeIodRaNKwCiORthh7KJi9VqHiFcONOawYgRBoahIN/VbqVRbQvwkvDcBGr/R
 eieB8/L7
 leIaUTxDSrI86fTSV5yNzUtY5gcB6KloI9QFGoDdfYtg6Auc8KAsWqWrQOe1ZoEkJ4O7/xlyk8cfR11zWAMrGl0CD3PpzPXWP6FD5QRNJw6w275iV4NqaN59XrCBaMgfdAGr/Bv3Z8DOpH44tbJSs7ytYI2XvLhMv5vIg94H7JSjeM5ram1nE9q4zisHPc/D0Nqiv1RoVqdBML22RDEzYm1RwDHILQCee12oi1F5IG5HfJRFjFuFYeiyVhRwGec5wociz0YHesuVLDXoAn9g6zl44gWMDEHKjKqpbnWlpRx9TGe5snrJTqFWgcKwU9pNmTbbQy0pCaDVGOPDZ2D4LpslOEpscrVVu6P8+P9r3DUpE2Q+d44bRQ+LoBNkwZkY57pBGD08YbplaAJ2v8HTDorLVcmCdiqohOboWcchLNR+0kVWXqK30+IKPve5Oy5ooo+ALtQjcW+N6S3StGd04UnqY0cKmeiDDb/urWkxIFiVt3pbsLayw1I3yygT4zCpk8H3rJacF4EtNW2/gEtJI4vNqwqK7Oc087mW6m8MIkg5+VHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 12:42:32PM -0700, Shakeel Butt wrote:
> On Wed, Aug 13, 2025 at 10:07:18AM -0700, Chris Li wrote:
> > 
> > If you store uncompressed data in the zpool, zpool has metadata
> > overhead, e.g. allocating the entry->handle for uncompressed pages.
> > If the page is not compressed, another idea is just skip the zpool,
> > store it as a page in the zswap entry as page. We can make a union of
> > entry->handle and entry->incompressble_page. If entry->length ==
> > PAGE_SIZE, use entry->incompressable_page as a page.
> 
> The main problem being solved here is to avoid the scenario where the
> incompressible pages are being rotated in LRUs and zswapped multiple
> times and wasting CPU on compressing incompressible pages. SJ's approach
> solves the issue but with some memory overhead (zswap entry). With your
> suggestion and to solve the mentioned issue, we will need to change some
> core parts of reclaim (__remove_mapping()), LRU handling (swap cache
> pages not in LRUs) and refault (putting such pages back in LRU and
> should it handle read and write faults differently). So, the cons of
> that approach is more complex code.

What Chris is proposing would also fix that, even for configurations
without writeback. So I'm not opposed to it.

However, for deployments where writeback *is* enabled, this code is an
improvement over the status quo. And it's not in conflict with a
broader fix for !writeback setups, so it's not an either-or scenario.

Specifically for the writeback case, the metadata overhead is not much
of a concern: we can just write back more zswap tail to make up for
it; the more important thing is that we can now do so in LRU order.

The premise being that writing an additional cold page from zswap to
disk to make room for a slightly inefficiently stored warm page is
better than rejecting and sending the *warm* page to disk instead.

So I agree with you Chris. But also think that's follow-up work for
somebody who cares about the !writeback case.

